#!/usr/bin/env python3
"""Replay exact algebra and current Lean evidence; analysis is in REPORT.md."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def symbolic_identities():
    n = sp.Symbol("n", integer=True, positive=True)
    sigma, tau, lam, q = sp.symbols("sigma tau lam q", positive=True)
    h, d, s, t, mi, mj = sp.symbols("h d s t mi mj", real=True)
    a, bi, bj, directional, ci, cj = sp.symbols(
        "a bi bj directional ci cj", real=True
    )
    m = n + 3
    k = n * (m + 1)
    big_n = k + n + 2
    kernel = (lam**2 + (s - t)**2) ** (-tau / 2)
    divergence = sp.diff((s - mi) * kernel, s) + sp.diff(
        (t - mj) * kernel, t
    )
    midpoint_rhs = 2 * kernel - tau * (
        (s - t)**2 - (mi - mj) * (s - t)
    ) * kernel / (lam**2 + (s - t)**2)
    weighted_rhs = (
        ci * bi + cj * bj + ci * directional + (cj - ci) * a
        - (ci + cj) * a
    )
    weighted_factor = (
        ci * (directional - 2 * a + bi + bj) + (cj - ci) * bj
    )
    reverse_rhs = (
        ci * bi + cj * bj + cj * directional + (ci - cj) * a
        - (ci + cj) * a
    )
    reverse_factor = (
        cj * (directional - 2 * a + bi + bj) + (ci - cj) * bi
    )
    degree = sp.Symbol("N", integer=True, positive=True)
    eta = (1 - s**3)**degree
    w = 3 * degree * (s + 1) * s**2 * (1 - s**3)**(degree - 1)
    r = sp.Symbol("r", nonnegative=True)
    expressions = {
        "paired_distance_square_difference": (h + d)**2 - (h - d)**2 - 4*h*d,
        "interval_midpoint_divergence": divergence - midpoint_rhs,
        "riesz_kernel_derivative": (
            sp.diff(kernel, s)
            + tau * (s - t) * kernel / (lam**2 + (s - t)**2)
        ),
        "weighted_remainder_ci_le_cj": weighted_rhs - weighted_factor,
        "weighted_remainder_cj_le_ci": reverse_rhs - reverse_factor,
        "cutoff_cubic_factor": 1 - s**3 - (1 - s)*(1 + s + s**2),
        "cutoff_radial_derivative": -(s + 1)*sp.diff(eta, s) - w,
        "cap_short_exponent": big_n - n - 1 + m - (big_n + 2),
        "cap_far_riesz_exponent": (
            big_n - n - m*(n - sigma) - (n + 2 + m*sigma)
        ),
        "high_layer_exponent": big_n - n + k - m*n - big_n,
        "low_layer_exponent": big_n - 1 - k - (n + 1),
        "newton_far_exponent": big_n - n - m*(n - 2) - (3*n + 8),
        "manuscript_localization_exponent_1": (
            big_n - 1 - m*(n - 2) - (4*n + 7)
        ),
        "manuscript_localization_exponent_2": (
            big_n - m*(n - 1) - (3*n + 5)
        ),
        "power_layer_primitive": (
            sp.integrate(1 - r**(1/q), (r, 0, 1)) - 1/(q + 1)
        ),
    }
    for name, expression in expressions.items():
        require(sp.simplify(expression) == 0, f"Nonzero identity: {name}")
    return {
        "classification": "universal_exact_symbolic_identities",
        "identities": sorted(expressions),
        "residuals": "all exactly zero",
        "domains": {
            "kernel": "lambda>0, tau>0; real s,t,midpoints",
            "layer_primitive": "q>0",
            "cutoff_derivative": "integer N>=1 and 0<s<1",
            "exponent_positivity": (
                "n>=2, 0<sigma<n: n+2+(n+3)*sigma>0 and n+1>0"
            ),
        },
    }


def overlap(length_i, length_j, radius):
    return max(
        Fraction(0),
        min(length_i, length_j, (length_i + length_j)/2 - radius),
    )


def finite_boundary_experiments():
    lengths = [Fraction(1, 3), Fraction(1), Fraction(7, 3)]
    separations = [
        Fraction(-3), Fraction(-1), Fraction(-1, 3), Fraction(0),
        Fraction(1, 3), Fraction(1), Fraction(3),
    ]
    arguments = [
        Fraction(0), Fraction(1, 6), Fraction(1, 3), Fraction(1, 2),
        Fraction(1), Fraction(2), Fraction(7, 3), Fraction(3), Fraction(4),
    ]
    count = 0
    for li, lj, d, h in itertools.product(
        lengths, lengths, separations, arguments
    ):
        for signed_h in {h, -h}:
            left = max(d/2 - li/2, -d/2 - lj/2 + signed_h)
            right = min(d/2 + li/2, -d/2 + lj/2 + signed_h)
            direct = max(Fraction(0), right - left)
            require(
                direct == overlap(li, lj, abs(signed_h - d)),
                "Overlap density mismatch",
            )
        paired = d * (
            overlap(li, lj, abs(h - d)) - overlap(li, lj, abs(h + d))
        )
        require(paired >= 0, "Negative paired midpoint term")
        count += 1

    budgets = 0
    for n, eps, c0, c1, c2 in itertools.product(
        [2, 3, 7],
        [Fraction(1, 16), Fraction(1), Fraction(16)],
        [Fraction(0), Fraction(2, 3)],
        [Fraction(0), Fraction(5, 2)],
        [Fraction(0), Fraction(7, 3)],
    ):
        kappa = min(Fraction(1, 2), eps/(3*(c0 + 1)))
        delta = min(Fraction(1, 8), eps*kappa**n/(3*(c1 + 1)))
        p = max(Fraction(1), 3*c2*kappa**(-n)*delta**(-n)/eps)
        terms = [
            c0*kappa, c1*kappa**(-n)*delta,
            c2*kappa**(-n)*delta**(-n)/p,
        ]
        require(0 < kappa < 1 and 0 < delta < Fraction(1, 4), "Bad scales")
        require(p >= 1, "Bad high/low threshold")
        require(all(term <= eps/3 for term in terms), "Unabsorbed error")
        require(sum(terms) <= eps, "Relative budget exceeds epsilon")
        budgets += 1
    return {
        "classification": "finite_exact_experiments_not_a_continuum_proof",
        "overlap_and_signed_midpoint_cases": count,
        "sequential_parameter_cases": budgets,
        "counterexamples_found": 0,
        "universal_sign_evidence": "Main.lean; REPORT.md Steps 1 and 6",
    }


def jacobian_evidence():
    request = read_json(HERE / "jacobian_request.json")
    response = read_json(HERE / "jacobian_result.json")
    operation = "polynomial.box.enclosure.compute"
    require(response["schema_version"] == 1, "Wrong adapter schema")
    require(response["request"]["operation_id"] == operation, "Wrong operation")
    require(response["request"]["payload"] == request, "Changed typed payload")
    require("error" not in response, "Adapter error is not evidence")
    result = response["result"]
    require("error" not in result, "Operation error is not evidence")
    require(result["operation_id"] == operation, "Wrong result operation")
    output = result["output"]
    require(output["polynomial"] == request["polynomial"], "Changed polynomial")
    require(output["box"] == request["box"], "Changed rational box")
    expected_terms = [{"coefficient": {"num": "4", "den": "1"}, "exponents": [1, 1]}]
    require(request["polynomial"]["variables"] == ["h", "d"], "Changed axes")
    require(
        request["polynomial"]["polynomial"]["terms"] == expected_terms,
        "Polynomial is not the midpoint square difference",
    )
    expected_axis = {
        "lower": {"num": "0", "den": "1"},
        "upper": {"num": "1", "den": "1"},
    }
    require(request["box"]["intervals"] == [expected_axis]*2, "Changed box")
    enclosure = output["enclosure"]
    require(enclosure["lower"] == {"num": "0", "den": "1"}, "Bad lower bound")
    require(enclosure["upper"] == {"num": "4", "den": "1"}, "Bad upper bound")
    return {
        "classification": "bounded_exact_adapter_operation_not_the_full_proof",
        "operation_id": operation,
        "protocol_version": response["protocol_version"],
        "server": response["server"],
        "transport": response["transport"],
        "exact_payload": request,
        "typed_output": output,
        "adapter_status": "typed_success",
        "adapter_error": None,
        "timeout": False,
    }


def known_transfer_obstruction():
    n, p, q, weight_a, weight_b = 5, 4, 4, 3, 3
    weighted = Fraction(n + weight_a, p + 1) + Fraction(n + weight_b, q + 1)
    unweighted = Fraction(n, p + 1) + Fraction(n, q + 1)
    require(n >= 3 and p > 0 and q > 0 and p*q > 1, "Invalid parameters")
    require(weight_a > -2 and weight_b > -2, "Invalid admissible weights")
    require(weighted > n - 2 and unweighted <= n - 2, "No transfer obstruction")
    return {
        "classification": "known_parameter_obstruction_not_a_pde_counterexample",
        "parameters": {"n": n, "p": p, "q": q, "A": weight_a, "B": weight_b},
        "weighted_sum": str(weighted),
        "unweighted_sum": str(unweighted),
        "threshold": n - 2,
        "already_explicit_in_manuscript": True,
    }


def lean_evidence():
    result = read_json(HERE / "lean_check.json")
    require(result["status"] == "success", "Lean did not succeed")
    require(result["exit_code"] == 0, "Nonzero Lean compiler exit")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["environment_failure"] == "", "Unverified Lean environment")
    version = result["tools"]["lean"]["version"]
    require("Lean (version 4.31.0," in version, "Not Lean 4.31.0")
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    require(
        hashlib.sha256(source.encode()).hexdigest() == result["source_sha256"],
        "Lean result is stale for the source",
    )
    require(
        hashlib.sha256(fidelity.encode()).hexdigest()
        == result["statement_fidelity_sha256"],
        "Lean result is stale for statement fidelity",
    )
    state = read_json(ROOT / "research" / "MATH_STATE.json")
    claim = max(
        (item for item in state["claims"] if item["claim_id"] == "L_MIDPOINT_SIGN"),
        key=lambda item: item["version"],
    )
    require(claim["formal_statement"].strip() == source.strip(), "Changed claim")
    records = [
        item for item in state["evidence"]
        if item["subject"]["subject_id"] == "L_MIDPOINT_SIGN"
        and item["subject"]["content_hash"] == claim["content_hash"]
        and item["tier"] == "mechanical" and item["verdict"] == "supports"
    ]
    require(len(records) == 1, "Expected one current mechanical support record")
    archived = read_json(ROOT / records[0]["artifact"])
    require(archived["lean_source"]["text"] == source, "Archive source mismatch")
    require(
        archived["statement_fidelity"]["text"] == fidelity,
        "Archive fidelity mismatch",
    )
    require(archived["lean_check"] == result, "Archive compiler result mismatch")
    return {
        "classification": "kernel_checked_geometric_core_only",
        "claim": "L_MIDPOINT_SIGN",
        "lean_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "mechanical_artifact": records[0]["artifact"],
        "analytic_theorem_formalized": False,
        "statement_fidelity_checked_by_this_script": False,
    }


def certificate():
    return {
        "schema_version": 1,
        "claim": "C_PRESSURE_VERIFICATION",
        "result": "complete_analytic_pressure_verification_and_riesz_extension",
        "proof": "REPORT.md, Theorem 1 and Steps 1-6",
        "main_pde_theorem_independently_verified": False,
        "independent_review": "not_established_by_this_script",
        "novelty": "not_established_by_this_script",
        "symbolic_algebra": symbolic_identities(),
        "finite_experiments": finite_boundary_experiments(),
        "known_failed_route": known_transfer_obstruction(),
        "jacobian": jacobian_evidence(),
        "lean": lean_evidence(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    else:
        require(read_json(target) == actual, "Exact certificate differs from replay")
    print(
        "PASS: 15 symbolic identities; 567 signed-overlap cases; "
        "72 parameter cases; exact Jacobian replay; fresh zero-hole Lean 4.31.0 core."
    )
    print("Continuum proof: REPORT.md. Independent review and novelty remain pending.")


if __name__ == "__main__":
    main()
