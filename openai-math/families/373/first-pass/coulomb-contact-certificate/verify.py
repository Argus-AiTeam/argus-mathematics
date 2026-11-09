#!/usr/bin/env python3
"""Replay the exact arithmetic supporting report.md; requires SymPy."""

import argparse
import hashlib
import itertools
import json
from fractions import Fraction as Q
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def verify() -> dict:
    checks = []

    def require(condition, label):
        if not condition:
            raise AssertionError(label)
        checks.append(label)

    def matrix_strings(matrix):
        return [[str(entry) for entry in row] for row in matrix.tolist()]

    b = sp.symbols("b0:3", real=True)
    norm2 = sum(t * t for t in b)
    h = norm2 ** -sp.Rational(1, 2)
    pair_hessian = sp.hessian(h, b)
    for i, j in itertools.product(range(3), repeat=2):
        expected = (3 * b[i] * b[j] - int(i == j) * norm2) / norm2 ** sp.Rational(5, 2)
        require(sp.simplify(pair_hessian[i, j] - expected) == 0,
                f"pair Hessian {i},{j}")
    for i, j, k in itertools.product(range(3), repeat=3):
        expected = (
            3 * (int(i == j) * b[k] + int(i == k) * b[j] + int(j == k) * b[i])
            / norm2 ** sp.Rational(5, 2)
            - 15 * b[i] * b[j] * b[k] / norm2 ** sp.Rational(7, 2)
        )
        require(sp.simplify(sp.diff(pair_hessian[i, j], b[k]) - expected) == 0,
                f"pair third derivative {i},{j},{k}")

    x = sp.symbols("x0:3", real=True)
    y = sp.symbols("y0:3", real=True)
    z = sp.symbols("z0:3", real=True)
    variables = x + y + z

    def interaction(p, q):
        return sum((p[i] - q[i]) ** 2 for i in range(3)) ** -sp.Rational(1, 2)

    cost = interaction(x, y) + interaction(x, z) + interaction(y, z)
    gradient = sp.Matrix([sp.diff(cost, t) for t in variables])
    full_hessian = sp.hessian(cost, variables)
    xz_indices = [0, 1, 2, 6, 7, 8]
    center_records = []
    for axis in (0, 1):
        a = sp.eye(3)[:, axis]
        center = dict(zip(variables, [0] * 3 + list(a) + list(-a)))
        jets = gradient.subs(center)
        require(cost.subs(center) == sp.Rational(5, 2), f"center cost axis {axis}")
        require(jets[:3] == [0] * 3, f"central gradient axis {axis}")
        require(sp.Matrix(jets[6:]) == sp.Rational(5, 4) * a,
                f"negative gradient axis {axis}")
        D = 3 * a * a.T - sp.eye(3)
        H = full_hessian.subs(center)
        M = H.extract(xz_indices, xz_indices)
        N = H.extract(xz_indices, [3, 4, 5])
        expected_M = sp.BlockMatrix([[2 * D, -D], [-D, sp.Rational(9, 8) * D]]).as_explicit()
        expected_N = sp.BlockMatrix([[-D], [-D / 8]]).as_explicit()
        require(M == expected_M, f"center M axis {axis}")
        require(N == expected_N, f"center N axis {axis}")
        H0 = M + 16 * sp.eye(6)
        row_lower = min(H0[i, i] - sum(abs(H0[i, j]) for j in range(6) if j != i)
                        for i in range(6))
        require(row_lower >= 13, f"center Hessian Gershgorin axis {axis}")
        derivative = -H0.inv() * N
        Lx = sp.diag(*(sp.Rational(37, 361) if i == axis else -sp.Rational(59, 829)
                      for i in range(3)))
        Lz = sp.diag(*(sp.Rational(9, 361) if i == axis else -sp.Rational(3, 829)
                      for i in range(3)))
        require(derivative == Lx.col_join(Lz), f"both implicit derivatives axis {axis}")
        center_records.append({
            "axis": axis + 1,
            "M": matrix_strings(M),
            "N": matrix_strings(N),
            "DX": matrix_strings(Lx),
            "DZ": matrix_strings(Lz),
            "H0_lower_bound": str(row_lower),
        })

    K, d = sp.symbols("K d")
    block = sp.Matrix([[K + 2 * d, -d], [-d, K + sp.Rational(9, 8) * d]])
    denominator = K ** 2 + sp.Rational(25, 8) * K * d + sp.Rational(5, 4) * d ** 2
    require(sp.expand(block.det() - denominator) == 0, "directional determinant identity")
    direction = sp.simplify(block.inv() * sp.Matrix([d, d / 8]))
    require(sp.simplify(direction[0] - d * (K + sp.Rational(5, 4) * d) / denominator) == 0,
            "directional DX identity")
    require(sp.simplify(direction[1] - d * (K / 8 + sp.Rational(5, 4) * d) / denominator) == 0,
            "directional DZ identity")
    require(direction[1].subs({K: 10, d: -1}) == 0,
            "K=10 degeneracy is not an admissible coordinate-diffeomorphism parameter")

    r, delta, beta = Q(1, 10**6), Q(1, 10**8), Q(1, 10**10)
    E = 3 * 2 * 24 * 16 * 2 * r
    q = E / 13
    derivative_error = E / 12 * (1 + Q(3, 13))
    require(0 < beta < delta < 2 * delta < r / 2 < r < Q(1, 4),
            "positive nested radii")
    require(2 * r < 1, "disjoint closed component balls")
    require(Q(65, 16) < Q(25, 4), "center mixed derivative norm is less than 5/2")
    require(Q(5, 2) + E < 3, "mixed derivative norm is less than 3 on the full product")
    require(13 - E > 12, "uniform strong convexity on the full continuum product")
    require(q < Q(1, 1000), "stationary fixed-point contraction")
    require(q * r / 2 + 6 * delta / 13 < r / 2,
            "stationary contraction preserves the closed six-ball, even for |y-a|<=2delta")
    require(Q(3, 13) / (1 - q) < Q(1, 4), "stationary displacement less than |y-a|/4")
    require(derivative_error < Q(1, 1000), "uniform implicit derivative perturbation")
    require(min(Q(37, 361), Q(59, 829)) > Q(7, 100), "center DX singular margin")
    require(min(Q(9, 361), Q(3, 829)) > Q(3, 1000), "center DZ singular margin")
    require(Q(7, 100) - Q(1, 1000) == Q(69, 1000), "global X injectivity margin")
    require(Q(3, 1000) - Q(1, 1000) == Q(1, 500), "global Z injectivity margin")
    inverse_norm = Q(100, 7)
    inverse_q = inverse_norm / 1000
    inverse_image = inverse_norm * (beta + delta / 1000)
    require(inverse_q < 1, "central inverse contraction")
    require(inverse_image < delta, "central inverse maps closed delta-ball strictly inside")

    require((1 - 2 * r) ** -2 + (2 - 2 * r) ** -2 < 5, "envelope gradient bound")
    require(8 * r**2 < 5 * r, "central potential perturbation")
    require(Q(5, 4) * r + 8 * r**2 < 2 * r, "negative potential bound")
    require(5 * delta < 3 and 2 * r < 3 and Q(5, 2) < 3, "uniform potential bound M=3")
    require(1 / (2 * r) > 9, "strict repeated-component exclusion")
    require(Q(7, 10) ** 2 * 2 < 1, "strict lower bound 7/10 for inverse sqrt(2)")
    require(2 / (1 - 2 * r) + 1 / (2 - 2 * r) < 3, "finite contact-plan cost bound")

    centers = [(0, 0, 0), (1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0)]
    allowed = {(0, 1, 2), (0, 3, 4)}
    patterns = []
    counts = {"allowed_distinct": 0, "excluded_distinct": 0, "excluded_repeated": 0}
    for indices in itertools.combinations_with_replacement(range(5), 3):
        if len(set(indices)) < 3:
            counts["excluded_repeated"] += 1
            patterns.append({"components": list(indices), "type": "repeated",
                             "slack_lower_bound": str(1 / (2 * r) - 9)})
            continue
        center_cost_lower = Q(0)
        for i, j in itertools.combinations(indices, 2):
            distance_squared = sum((u - v) ** 2 for u, v in zip(centers[i], centers[j]))
            require(distance_squared in (1, 2, 4), f"center distance pattern {indices}:{i},{j}")
            center_cost_lower += {1: Q(1), 2: Q(7, 10), 4: Q(1, 2)}[distance_squared]
        center_gap = center_cost_lower - (Q(5, 2) if 0 in indices else 0)
        if indices in allowed:
            require(center_gap == 0, f"allowed center equality {indices}")
            counts["allowed_distinct"] += 1
            patterns.append({"components": list(indices), "type": "contact_branch"})
        else:
            require(center_gap >= Q(1, 5), f"unwanted center gap {indices}")
            slack_lower = center_gap - 39 * r
            require(slack_lower > Q(19, 100), f"continuum unwanted-type slack {indices}")
            counts["excluded_distinct"] += 1
            patterns.append({"components": list(indices), "type": "unwanted_distinct",
                             "center_gap_strict_lower_bound": str(center_gap),
                             "slack_strict_lower_bound": str(slack_lower)})
    require(counts == {"allowed_distinct": 2, "excluded_distinct": 8, "excluded_repeated": 25},
            "all 35 unordered component patterns covered")
    ordered_counts = {"contact": 0, "unwanted_distinct": 0, "repeated": 0}
    for indices in itertools.product(range(5), repeat=3):
        kind = ("repeated" if len(set(indices)) < 3 else
                "contact" if tuple(sorted(indices)) in allowed else "unwanted_distinct")
        ordered_counts[kind] += 1
    require(ordered_counts == {"contact": 12, "unwanted_distinct": 48, "repeated": 65},
            "all 125 ordered component patterns covered")
    require(Q(1, 3) + 4 * Q(1, 6) == 1, "probability weights")
    require(Q(1, 3) > Q(1, 6), "strict image-measure imbalance")

    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    sidecar = json.loads((ROOT / "jacobian_result.json").read_text())
    adapter = json.loads((ROOT / "jacobian_status.json").read_text())
    require(sidecar["request"]["payload"] == payload, "Jacobian exact source binding")
    require(sidecar["request"]["operation_id"] == "interval.expression.second_jet_enclosure.compute",
            "Jacobian inspected operation binding")
    require(sidecar["server"]["version"] == "0.14.0", "Jacobian recorded server version")
    output = sidecar["result"]["output"]
    require(output["status"] in {"ENCLOSED", "DOMAIN_UNPROVEN", "BACKEND_ERROR"},
            "Jacobian typed status, not an inferred mathematical verdict")

    lean = json.loads((ROOT / "lean_verify_v2.json").read_text())
    require(lean["status"] == "success" and lean["exit_code"] == 0,
            "real Lean compiler success")
    require(lean["proof_holes"] == [], "Lean proof has no holes")
    require(lean["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "required Lean 4.31.0 compiler")
    require(lean["source_sha256"] == hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest(),
            "Lean source is still the compiled source")
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    require(lean["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(),
            "Lean statement fidelity is still the compiled reading")
    mechanical = lean["kernel"]["recorded"]
    require(mechanical["verdict"] == "supports" and mechanical["tier"] == "mechanical",
            "compiler verdict was recorded as mechanical claim evidence")
    require(mechanical["subject"]["subject_id"] == "C_CC_SELECTOR",
            "formal evidence binds to the intended selection claim")
    certificate_path = ROOT.parent.parent / mechanical["artifact"]
    require(certificate_path.is_file(), "archived Lean claim certificate exists")

    return {
        "result_class": "new_theorem_candidate",
        "statement": "Explicit quantitative verification of the staged d=3,s=1 Coulomb construction",
        "independent_review": "pending",
        "novelty_status": "not_yet_independently_determined",
        "parameters": {"K": "16", "r": str(r), "delta": str(delta), "beta": str(beta)},
        "center_derivatives": center_records,
        "continuum_bounds": {
            "third_derivative_pair_bound": "24/|b|^4",
            "full_hessian_perturbation": str(E),
            "strong_convexity_lower_bound": "12",
            "stationary_contraction_upper_bound": str(q),
            "stationary_displacement_factor": str(Q(3, 13) / (1 - q)),
            "implicit_derivative_error_upper_bound": str(derivative_error),
            "X_lower_Lipschitz": "69/1000",
            "Z_lower_Lipschitz": "1/500",
            "inverse_contraction_upper_bound": str(inverse_q),
            "inverse_closed_ball_image_radius_upper_bound": str(inverse_image),
            "unwanted_distinct_type_slack_lower_bound": str(Q(1, 5) - 39 * r),
            "repeated_type_slack_lower_bound": str(1 / (2 * r) - 9),
            "contact_plan_cost_upper_bound": "3",
        },
        "component_pattern_counts": counts,
        "ordered_component_pattern_counts": ordered_counts,
        "component_patterns": patterns,
        "parameter_boundary_diagnostic": {
            "K": "10", "transverse_DZ": "0",
            "interpretation": "Not a manuscript counterexample: its sufficiently-large-K choice excludes this degeneracy.",
        },
        "jacobian": {
            "operation_id": sidecar["request"]["operation_id"],
            "server_version": sidecar["server"]["version"],
            "protocol_version": sidecar["protocol_version"],
            "adapter_exit_code": adapter["adapter_exit_code"],
            "typed_status": output["status"],
            "detail": output["detail"],
            "used_as_mathematical_evidence": False,
        },
        "formal_verification": {
            "claim": "C_CC_SELECTOR",
            "status": lean["status"],
            "exit_code": lean["exit_code"],
            "proof_holes": lean["proof_holes"],
            "compiler": lean["tools"]["lean"]["version"],
            "certificate": mechanical["artifact"],
            "scope": "Full finite weighted measurable-selection obstruction and four-branch Coulomb specialization",
            "statement_fidelity_independently_reviewed": False,
        },
        "proof_boundary": {
            "exactly_replayed": "Symbolic derivative identities, rational bounds, exhaustive component-pattern reduction",
            "analytic_argument": "report.md: explicit fixed-point, inverse-function, convexity, density, and optimality proofs",
            "formal_core": "Main.lean; only a successful source-bound Lean certificate establishes formal verification",
            "unverified": "Full Riesz extension; independent Reviewer acceptance; literature-wide novelty",
        },
        "check_count": len(checks),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = verify()
    certificate = ROOT / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    elif json.loads(certificate.read_text()) != result:
        raise AssertionError("exact_certificate.json differs from exact recomputation")
    print(f"PASS: {result['check_count']} exact checks; all 125 ordered component patterns covered.")
    print("Continuum theorem uses the explicit analytic proof in report.md; independent review is pending.")


if __name__ == "__main__":
    main()
