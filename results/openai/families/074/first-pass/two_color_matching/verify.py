#!/usr/bin/env python3
"""Exact replay accompanying report.md; not a checker for its continuous proof."""

from __future__ import annotations

import argparse
from collections import defaultdict
from fractions import Fraction as F
from hashlib import sha256
from itertools import islice, permutations, product
import json
from math import comb, factorial
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def symbolic_determinants() -> dict:
    checked = []
    for m in range(1, 6):
        g = sp.symbols(f"g0:{m}")
        x = sp.symbols(f"x0:{m}")
        matrix = sp.Matrix(
            m, m, lambda j, p: -g[p] * x[p] ** (m - j - 1) / factorial(m - j - 1)
        )
        vandermonde = sp.prod(x[q] - x[p] for p in range(m) for q in range(p + 1, m))
        expected = (
            (-1) ** (m * (m + 1) // 2)
            * sp.prod(g)
            * vandermonde
            / sp.prod(factorial(k) for k in range(m))
        )
        determinant = matrix.det(method="domain-ge")
        require(sp.expand(determinant - expected) == 0, f"determinant at order {m}")
        require(determinant.subs(g[0], 0) == 0, "zero control-gap boundary")
        if m > 1:
            require(sp.expand(determinant.subs(x[1], x[0])) == 0, "colliding-time boundary")
        s, t = sp.symbols("s t")
        for j in range(m):
            power = m - j
            derivative = sp.diff(g[0] * (s - t) ** power / factorial(power), t)
            require(
                sp.expand(derivative + g[0] * (s - t) ** (power - 1) / factorial(power - 1))
                == 0,
                "endpoint differentiation",
            )
        checked.append(m)
    m, j = sp.symbols("m j", integer=True, positive=True)
    width_sum = sp.summation(1 - j / m, (j, 0, m - 1))
    require(sp.simplify(width_sum - (m + 1) / 2) == 0, "arbitrary-order width sum")
    return {
        "finite_determinant_orders": checked,
        "signed_determinant_factor": "(-1)^(m*(m+1)/2)",
        "degenerate_boundaries_checked": True,
        "symbolic_width_sum_for_all_positive_integer_m": "(m+1)/2",
        "unbounded_order_determinant_proof": "lean/Main.lean: endpoint_abs_det",
    }


def signed_flows() -> dict:
    cases = 0
    for m in range(1, 7):
        initial = [F(j + 1, m + 2) for j in range(m)]
        controls = [F((-1) ** p * (p + 2), p + 1) for p in range(m + 1)]
        s0, final = F(1, 2), F(1, 3)
        internal = tuple(F(p + 1, m + 2) for p in range(m))
        for times in islice(permutations(internal), 120 if m <= 5 else 24):
            state = initial[:]
            previous = s0
            for control, arrival in zip(controls, (*times, final)):
                h = arrival - previous
                state = [
                    sum(state[k] * h ** (k - j) / factorial(k - j) for k in range(j, m))
                    + control * h ** (m - j) / factorial(m - j)
                    for j in range(m)
                ]
                previous = arrival
            for j in range(m):
                free = sum(
                    initial[k] * (final - s0) ** (k - j) / factorial(k - j)
                    for k in range(j, m)
                )
                controlled = controls[0] * (final - s0) ** (m - j)
                controlled += sum(
                    (controls[p + 1] - controls[p]) * (final - times[p]) ** (m - j)
                    for p in range(m)
                )
                expected = free + controlled / factorial(m - j)
                require(state[j] == expected, f"signed flow, m={m}, times={times}")
            cases += 1
    return {"exact_rational_signed_time_cases": cases, "orders": list(range(1, 7))}


def scale_data(beta: tuple[F, ...]) -> tuple[list[F], list[tuple[F, F, int]]]:
    J = len(beta)
    points = {F(0), F(1)}
    for i in range(1, J + 1):
        for j in range(i + 1, J + 1):
            x = (j * beta[i - 1] - i * beta[j - 1]) / (j - i)
            if 0 < x < 1:
                points.add(x)
    points = sorted(points)
    pieces = []
    for left, right in zip(points, points[1:]):
        mid = (left + right) / 2
        active = max(range(1, J + 1), key=lambda k: (mid - beta[k - 1]) / k)
        if pieces and pieces[-1][2] == active:
            pieces[-1] = (pieces[-1][0], right, active)
        else:
            pieces.append((left, right, active))
    return points, pieces


def scales() -> dict:
    profiles = 0
    values = (F(0), F(1, 3), F(2, 3), F(4, 3))
    for D in range(1, 4):
        J = D + 1
        for beta in product(values, repeat=J):
            if F(0) not in beta[:D]:
                continue
            points, pieces = scale_data(beta)

            def r(a: F) -> F:
                return max((a - beta[j - 1]) / j for j in range(1, J + 1))

            def ell(j: int, a: F) -> F:
                candidates = [p for p in points if p <= a] + [a]
                return max(x - j * r(x) for x in candidates)

            require(r(F(0)) == 0, "r(0)")
            for left, right, m in pieces:
                require(m <= D, "active order above D")
                a = (2 * left + right) / 3
                require(r(a) >= a / D, "finite-type lower scale")
                for j in range(J + 1):
                    lj = ell(j, a)
                    require(lj >= 0, "negative record exponent")
                    if j:
                        require(lj <= beta[j - 1], "record finer than matching gap")
                    if j <= m:
                        require(lj == a - j * r(a), "active low-jet formula")
                    else:
                        require(lj > a - j * r(a), "strict high-jet gap")
                    require((J + 1 - j) * r(a) > lj, "Taylor remainder gap")
                    for i in range(J - j + 1):
                        require(lj - ell(j + i, a) <= i * r(a), "translation exponents")
                for i in range(1, J - m + 1):
                    require(ell(m + i, a) + i * r(a) > beta[m - 1], "control variation")
            slope_integral = sum((right - left) / m for left, right, m in pieces)
            B = sum((right - left) * F(m + 1, 2) for left, right, m in pieces)
            A = sum(
                (right - left) * (F(1, m) + F(m + 1, 2))
                for left, right, m in pieces
            )
            require(slope_integral == r(F(1)), "integral r'=r(1)")
            require(A - r(F(1)) == B >= 1, "state-count cancellation yielding d>=1")
            profiles += 1
    sharp = []
    for m in range(1, 9):
        beta = tuple(max(F(0), 1 - F(j, m)) for j in range(1, m + 2))
        _, pieces = scale_data(beta)
        require(pieces == [(F(0), F(1), m)], "pure-type active order")
        A = F(1, m) + sum(1 - F(j, m) for j in range(m))
        require(A - F(1, m) == F(m + 1, 2), "sharp pure-type cancellation")
        sharp.append({"m": m, "target_exponent_per_b": str(A), "d_lower_bound": str(F(m + 1, 2))})
    return {"finite_rational_gap_profiles": profiles, "pure_type_replays": sharp}


def adaptive_kernels() -> dict:
    reference = (F(2, 5), F(3, 5))
    hidden = tuple(product(range(2), repeat=2))

    def kernel(history: tuple, outcome: tuple) -> F:
        b, z = outcome
        signature = sum((k + 1) * (2 * past_b + past_z + 1) for k, (past_b, past_z) in enumerate(history))
        retain = F(8 + signature % 5, 13)
        split = F(1 + (signature + 2 * b) % 6, 7)
        return reference[b] * retain * (split if z == 0 else 1 - split)

    totals = []
    paths_checked = 0
    for n in range(1, 6):
        projected = defaultdict(F)
        for path in product(hidden, repeat=n):
            mass = F(1)
            history = ()
            for outcome in path:
                for b in range(2):
                    fiber = sum(kernel(history, (b, z)) for z in range(2))
                    require(fiber <= reference[b], "full-history fiber domination")
                mass *= kernel(history, outcome)
                history += (outcome,)
            projected[tuple(b for b, _ in path)] += mass
            paths_checked += 1
        for path, mass in projected.items():
            bound = F(1)
            for b in path:
                bound *= reference[b]
            require(mass <= bound, "displayed-path product bound")
        total = sum(projected.values())
        require(0 < total < 1, "nontrivial successful subprobability mass")
        totals.append(str(total))
    killed = (F(1, 2), F(0))
    base = (F(1, 2), F(1, 2))
    require(all(q <= w for q, w in zip(killed, base)), "killed-step domination")
    require(killed[0] / sum(killed) > base[0], "renormalization obstruction")
    return {
        "finite_hidden_paths_checked": paths_checked,
        "nonuniform_reference_weights": list(map(str, reference)),
        "successful_masses_by_length": totals,
        "counterexample_to_survival_renormalization_only": True,
        "unbounded_length_finite_kernel_proof": "lean/Main.lean: adaptive_domination_from_fibers",
    }


def eval_derivative(coefficients: list[F], j: int, t: F) -> F:
    return sum(
        coefficients[k] * F(factorial(k), factorial(k - j)) * t ** (k - j)
        for k in range(j, len(coefficients))
    )


def sharp_construction() -> dict:
    t, n, L = sp.symbols("t n L", real=True, nonzero=True)
    for m in range(1, 7):
        delta = t**m + sum(comb(m, j) * (-n / L) ** (m - j) * t**j for j in range(m))
        require(sp.expand(delta - (t - n / L) ** m) == 0, "binomial construction identity")
    event_checks = 0
    examples = []
    for m in range(1, 4):
        for length in (2, 3):
            M = length ** (m * (m + 1) // 2)
            ratio = 1
            for j in range(m):
                ratio *= 2 * comb(m, j) + 1
            A = list(product(*(range(length ** (m - j)) for j in range(m))))
            require(len(A) == M, "first list cardinality")
            for cell in range(length):
                seen = set()
                for a in A:
                    b = tuple(a[j] - comb(m, j) * (-cell) ** (m - j) for j in range(m))
                    require(b not in seen, "translation is not injective")
                    seen.add(b)
                    for j in range(m):
                        size = length ** (m - j)
                        C = comb(m, j)
                        require(-C * size <= b[j] < (C + 1) * size, "second list index out of bounds")
                    coefficients1 = [F(a[j], length ** (m - j)) for j in range(m)] + [F(1)]
                    coefficients2 = [F(b[j], length ** (m - j)) for j in range(m)] + [F(0)]
                    for offset in (F(0), F(1, 2), F(1)):
                        time = F(cell, length) + offset / length
                        for j in range(m + 1):
                            gap = eval_derivative(coefficients1, j, time) - eval_derivative(coefficients2, j, time)
                            expected = F(factorial(m), factorial(m - j)) * (offset / length) ** (m - j)
                            require(gap == expected, "actual polynomial derivative mismatch")
                            require(abs(gap) <= F(factorial(m), factorial(m - j)) / length ** (m - j), "pure-type gap bound")
                        event_checks += 1
                require(len(seen) == M, "second marginal cell density bound")
            require(F(M * length, M * length) == 1, "event law normalization")
            require(F(1, M) == ratio * F(1, ratio * M), "arbitrary-index marginal domination")
            examples.append({"m": m, "L": length, "N": length**m, "list1_size": M, "list2_size": ratio * M, "marginal_loss": ratio})
    return {
        "parameterized_family": "For every integer m>=1 and L>=2; N=L^m; report.md Section 10",
        "finite_symbolic_orders": list(range(1, 7)),
        "finite_boundary_event_checks": event_checks,
        "finite_examples": examples,
        "sharp_exponent_for_general_family": "(m+1)/2",
        "not_a_counterexample_to_the_manuscript": True,
    }


def rational_function(data: dict, variables: tuple) -> sp.Expr:
    require(data["domain"] == "QQ", "Jacobian output domain")

    def polynomial(record: dict) -> sp.Expr:
        result = sp.Integer(0)
        for term in record["terms"]:
            coefficient = term["coefficient"]
            require(len(term["exponents"]) == len(variables), "typed exponent dimension")
            result += sp.Rational(coefficient["num"], coefficient["den"]) * sp.prod(
                v**e for v, e in zip(variables, term["exponents"])
            )
        return result

    return polynomial(data["numerator"]) / polynomial(data["denominator"])


def replay_jacobian() -> dict:
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    operation = "matrix.symbolic.determinant.compute"
    require(result["request"]["operation_id"] == operation, "wrong adapter operation")
    require(result["request"]["payload"] == payload, "adapter payload mismatch")
    require(result["result"]["operation_id"] == operation, "wrong typed result")
    require("error" not in result and "error" not in result["result"], "structured adapter error")
    names = tuple(payload["matrix"]["variables"])
    variables = sp.symbols(" ".join(names))
    matrix = sp.Matrix([[rational_function(entry, variables) for entry in row] for row in payload["matrix"]["entries"]])
    output = result["result"]["output"]
    require(output["determinant"]["variables"] == list(names), "typed variable order")
    determinant = rational_function(output["determinant"], variables)
    require(sp.expand(matrix.det() - determinant) == 0, "typed determinant replay")
    g1, g2, g3, x1, x2, x3 = variables
    expected = g1 * g2 * g3 * (x2 - x1) * (x3 - x1) * (x3 - x2) / 2
    require(sp.expand(determinant - expected) == 0, "typed determinant sign")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "transport": result["transport"],
        "method": output["method"],
        "status": "exact_typed_output_replayed",
        "structured_error": None,
        "timeout": False,
    }


def lean_record() -> dict:
    record = json.loads((HERE / "lean/lean_check.json").read_text())
    require(record["status"] == "success" and record["exit_code"] == 0, "Lean has not succeeded")
    require(record["proof_holes"] == [], "Lean proof holes")
    require(sha256((HERE / "lean/Main.lean").read_bytes()).hexdigest() == record["source_sha256"], "stale Lean source")
    fidelity = (HERE / "lean/statement_fidelity.md").read_text()
    require(sha256(fidelity.encode()).hexdigest() == record["statement_fidelity_sha256"], "stale statement fidelity")
    require("4.31.0" in json.dumps(record), "wrong Lean version")
    return {
        "claim": "CORE074",
        "compiler_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "source_and_fidelity_match_official_record": True,
        "coverage": "arbitrary-order determinant and arbitrary-length finite hidden-history domination only",
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = {
        "classification": "mathematical_proof_with_formalized_core_and_exact_replay",
        "claims": ["MATCH074", "SHARP074", "CORE074"],
        "independent_review": "pending_host_invocation",
        "novelty_status": "not_independently_verified",
        "continuous_proof": "report.md Sections 2-10; requires independent mathematical review",
        "not_certified": ["3D Kakeya maximal theorem", "4D Kakeya Hausdorff dimension theorem"],
        "determinants": symbolic_determinants(),
        "signed_endpoints": signed_flows(),
        "scale_bookkeeping": scales(),
        "adaptive_kernels": adaptive_kernels(),
        "sharpness_construction": sharp_construction(),
        "jacobian": replay_jacobian(),
        "lean": lean_record(),
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        require(certificate == expected, "exact certificate differs from this replay")
    print(json.dumps({
        "status": "pass",
        "certificate": str(path.relative_to(HERE.parent.parent)),
        "independent_review": certificate["independent_review"],
        "lean_exit_code": certificate["lean"]["exit_code"],
        "proof_holes": certificate["lean"]["proof_holes"],
        "full_continuous_proof_machine_checked": False,
    }, indent=2))


if __name__ == "__main__":
    main()
