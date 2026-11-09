#!/usr/bin/env python3
"""Replay exact algebra; the analytic theorem is proved in AUDIT_REPORT.md."""

import argparse
import json
import math
import subprocess
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "research/exact_certificate.json"
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def zero(expression):
    residual = sp.factor(expression)
    if residual != 0:
        raise AssertionError(f"Nonzero exact residual: {residual}")
    return "0"


def build_certificate():
    n, k = sp.symbols("n k", positive=True)
    p2, pd, d2, e2, vp, vd = sp.symbols("p2 pd d2 e2 vp vd")
    delta = 1 / (n + 2)
    theta = (n + 2) / (2 * (n + 1))
    c = (n + 2) / 2
    lam = sp.Rational(15, 16)
    kappa = sp.Rational(1, 256)
    p_identity = k + (n + 1) * p2 + c * pd - 2 * vp
    d_identity = n / 2 * (d2 + e2) + (n + 2) * (p2 + pd) - (n - 2 * k) + 2 * vd
    cancellation = n / 2 * (d2 + e2 - 2 * p2 - 2) + 2 * vd + 4 * vp
    coercive_identity = (
        k - 2 * lam + (n + 1 - 2 * lam) * p2 + c * pd
        + lam * (d2 + e2) - (2 - 8 * lam / n) * vp + 4 * lam / n * vd
    )
    x, o, z, oz, u, du, lx = sp.symbols("x o z oz u du lx")
    identities = {
        "cap_psi_coefficient": zero(n - n / delta + n * (n + 1)),
        "cap_cutoff_gradient_coefficient": zero(2 - 1 / delta + n),
        "cap_affine_difference": zero(
            (oz - u + (x - o) * du) * z
            - (x - o) * (lx + z * du)
            - (lx * o + z * oz - lx * x - z * u)
        ),
        "base_matrix_density_h_exponent": zero(1 - n / 2 - c + n),
        "angular_matrix_density_h_exponent": zero(1 - n / 2 + c - 2),
        "area_over_volume_log_exponent": zero(n / 2 - c * n / (n + 2)),
        "p_d_cancellation": zero(d_identity - 2 * p_identity - cancellation),
        "coercive_linear_combination": zero(
            p_identity + 2 * lam / n * cancellation - coercive_identity
        ),
        "interpolation_R_exponent": zero(theta * (1 - delta) - sp.Rational(1, 2)),
        "interpolation_B_exponent": zero(delta * theta + 1 - theta - sp.Rational(1, 2)),
        "interpolation_t_exponent": zero(theta + 1 - theta - 1),
        "positive_mass_B_exponent": zero(delta - delta),
        "positive_mass_R_exponent": zero(delta + 1 - 2 * delta - (1 - delta)),
        "positive_mass_h_exponent": zero(-n * delta + n * delta),
        "coercive_determinant_factorization": zero(
            lam * (n + 1 - 2 * lam) - (n + 2) ** 2 / 16
            - sp.Rational(7, 128) - (n - 2) * (9 - n) / 16
        ),
        "frame_inverse_denominator": zero(1 + k * (k + 2) - (k + 1) ** 2),
    }

    dimension_rows = []
    for dim in range(3, 10):
        matrix = sp.Matrix([
            [sp.Rational(dim) + 1 - 2 * lam, sp.Rational(dim + 2, 4)],
            [sp.Rational(dim + 2, 4), lam],
        ])
        shifted = matrix - kappa * sp.eye(2)
        if shifted[0, 0] <= 0 or shifted.det() <= 0:
            raise AssertionError(f"Coercivity failed in dimension {dim}")
        for directions in range(2, dim + 1):
            if directions - 2 * lam < kappa:
                raise AssertionError("The constant term is not coercive")
        dimension_rows.append({
            "n": dim,
            "determinant": str(matrix.det()),
            "shifted_determinant": str(shifted.det()),
            "minimum_scalar_term": "1/8",
        })

    frame_rows = []
    for directions in range(2, 10):
        ones = sp.ones(directions, 1)
        vectors = [ones + sp.eye(directions)[:, r] for r in range(directions)]
        gram = sum((v * v.T for v in vectors), sp.zeros(directions))
        target = sp.eye(directions) + (directions + 2) * ones * ones.T
        if gram != target:
            raise AssertionError("Cap-testing frame identity failed")
        inverse = sp.eye(directions) - sp.Rational(
            directions + 2, (directions + 1) ** 2
        ) * ones * ones.T
        if gram * inverse != sp.eye(directions):
            raise AssertionError("Frame inverse identity failed")
        frame_rows.append({"k": directions, "gram_and_inverse_exact": True})

    cap_calibrations = []
    s, v = sp.symbols("s v")
    for dim in range(3, 10):
        for power in (4, 5, 6):
            psi = (2 - s) ** power
            integrand = (
                2 * s * (1 + s) * sp.diff(psi, s, 2)
                + dim * (1 - s) * sp.diff(psi, s)
                - dim * (dim + 1) * psi
            )
            polynomial = sp.Poly(sp.expand(integrand.subs(s, 2 * v)), v)
            integral = sum(
                coefficient / (sp.Rational(dim, 2) + degree[0])
                for degree, coefficient in polynomial.terms()
            )
            cap_calibrations.append({
                "n": dim, "cutoff_power": power,
                "normalized_radial_integral": zero(integral),
            })

    degeneracy_checks = 0
    for dim in range(3, 10):
        for directions in range(2, dim + 1):
            for exponent in (0, 1, 4, 12):
                determinant_b = Fraction(1, 10 ** exponent)
                determinant_r = Fraction(10 ** exponent + 1, 3)
                trace_inverse = 1 / determinant_b + directions - 1
                left = (determinant_b * determinant_r) ** (dim + 1)
                left *= trace_inverse ** (2 * (dim + 1))
                right = determinant_b * determinant_r ** (dim + 1)
                right *= trace_inverse ** (dim + 2)
                right *= (determinant_b * trace_inverse) ** dim
                if left != right:
                    raise AssertionError("Degenerate positive-data interpolation failed")
                degeneracy_checks += 1

    horizon_rows = []
    for directions in range(2, 10):
        initial, box, q, l0 = Fraction(3, 7), Fraction(11, 5), Fraction(9, 8), 4
        threshold = (
            box / initial * 2 ** (2 * directions + 1)
            * math.factorial(directions + 1) / (q - 1) ** (directions + 1)
        )
        horizon = max(2 * (directions + 1), l0 + 1, math.floor(threshold) + 1)
        lower = math.comb(horizon, directions + 1) * (q - 1) ** (directions + 1)
        upper = box * (l0 + horizon + 1) ** directions
        if initial * lower <= upper:
            raise AssertionError("The finite horizon does not give strict contradiction")
        horizon_rows.append({
            "k": directions, "N": str(horizon),
            "binomial_lower_exceeds_polynomial": True,
        })

    evidence = ROOT / "research/evidence"
    payload = json.loads((evidence / "jacobian_payload.json").read_text())
    response = json.loads((evidence / "jacobian_result.json").read_text())
    status = json.loads((evidence / "jacobian_status.json").read_text())
    if status["exit_code"] != 0 or status["timeout"]:
        raise AssertionError(f"Jacobian is a non-conclusion: {status}")
    if response["request"]["payload"] != payload:
        raise AssertionError("Jacobian response is not bound to the saved payload")
    if response["result"]["operation_id"] != "matrix.inverse.compute":
        raise AssertionError("Unexpected Jacobian operation")
    output = response["result"]["output"]
    if output["convention"] != "TWO_SIDED_INVERSE_OVER_QQ":
        raise AssertionError("Unexpected matrix inverse convention")
    input_matrix = sp.Matrix([[int(x) for x in row] for row in payload["matrix"]["entries"]])
    output_matrix = sp.Matrix([
        [sp.Rational(entry["num"], entry["den"]) for entry in row]
        for row in output["inverse"]["entries"]
    ])
    if input_matrix * output_matrix != sp.eye(3) or output_matrix * input_matrix != sp.eye(3):
        raise AssertionError("Jacobian output is not the exact two-sided inverse")

    return {
        "claim": "C_ONE_DIRECTION",
        "classification": "exact algebraic support for a complete analytic verification",
        "analytic_proof": "research/AUDIT_REPORT.md",
        "formal_subclaim": "C_FORMAL_CORE",
        "independent_review": "required; not supplied by this script",
        "symbolic_residuals": identities,
        "coercivity_constant": "1/256",
        "dimension_rows": dimension_rows,
        "cap_frame_checks": frame_rows,
        "paraboloid_cap_calibrations": cap_calibrations,
        "positive_degenerate_data_checks": degeneracy_checks,
        "finite_horizon_examples": {
            "boundary": "Synthetic rational constants, not measured constants of the graph.",
            "c0": "3/7", "C_box": "11/5", "q": "9/8", "l0": 4,
            "rows": horizon_rows,
        },
        "jacobian": {
            "operation_id": response["result"]["operation_id"],
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "adapter_exit_code": status["exit_code"],
            "inverse_replayed_exactly": True,
        },
        "not_machine_checked": [
            "Euclidean completeness, affine-limit geometry, maximal-direction centering.",
            "Smooth support coordinates, area covariance, cap stationarity and integration by parts.",
            "Uniform cap support, Hessian-minor integral bounds and Holder applications.",
            "Positive mass and simultaneous eventuality for one smooth approximant.",
            "Novelty and independent Reviewer acceptance.",
        ],
        "false_assertions_established": [],
    }


def campaign_checks():
    rows = []
    for module in ("math_state", "proof_graph_check"):
        command = [
            ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
            "check", "--project-root", str(ROOT),
        ]
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
        rows.append({
            "command": command, "project_root": str(ROOT),
            "exit_code": result.returncode, "stdout": result.stdout, "stderr": result.stderr,
        })
    path = ROOT / "research/evidence/campaign_checks.json"
    path.write_text(json.dumps(rows, indent=2) + "\n")
    for row in rows:
        if row["exit_code"] != 0:
            raise AssertionError(f"Campaign-local validation failed: {row}")
    print(f"Campaign-local checks: math_state=0, proof_graph_check=0; root={ROOT}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true", help="Generate the exact certificate.")
    mode.add_argument("--check", action="store_true", help="Replay and compare the saved certificate.")
    parser.add_argument("--campaign-checks", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    if args.write:
        CERTIFICATE.write_text(json.dumps(certificate, indent=2) + "\n")
    elif certificate != json.loads(CERTIFICATE.read_text()):
        raise AssertionError("The saved exact certificate differs from a fresh exact replay")
    print(
        f"Exact replay passed: {len(certificate['symbolic_residuals'])} symbolic identities, "
        f"7 dimensions, 8 cap frames, 21 cap calibrations, "
        f"{certificate['positive_degenerate_data_checks']} positive-degeneracy cases."
    )
    if args.campaign_checks:
        campaign_checks()


if __name__ == "__main__":
    main()
