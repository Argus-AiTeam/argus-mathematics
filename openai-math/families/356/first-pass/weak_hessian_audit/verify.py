#!/usr/bin/env python3
"""Replay exact supporting calculations, not the unformalized RCD analysis."""

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(expression, label):
    require(sp.simplify(expression) == 0, label)


def polynomial(terms, variables):
    return sum(
        sp.Integer(term["coefficient"])
        * sp.prod(v ** e for v, e in zip(variables, term["exponents"], strict=True))
        for term in terms
    )


def normalized_terms(terms, modulus):
    coefficients = {}
    for term in terms:
        exponents = tuple(term["exponents"])
        coefficients[exponents] = (
            coefficients.get(exponents, 0) + int(term["coefficient"])
        ) % modulus
    return [
        {"coefficient": value, "exponents": list(exponents)}
        for exponents, value in sorted(coefficients.items())
        if value
    ]


def calculate():
    xi, d, b, c, r, u = sp.symbols("xi d b c r u")
    variables = (xi, d, b, c, r)
    weighted = -u + (xi * (d + b) + c) * (d + b)
    original = -u - xi * r + (xi * d + c + xi * b) * d
    correction = xi * r + b * (c + xi * (d + b))
    zero(weighted - original - correction, "weighted Bochner cancellation")

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    run = json.loads((HERE / "jacobian_run_status.json").read_text())
    operation = "modular.polynomial_identity.compute"
    require(payload["variables"] == [str(v) for v in variables], "variable order")
    zero(polynomial(payload["left"], variables) - (weighted - original), "left binding")
    zero(polynomial(payload["right"], variables) - correction, "right binding")
    require(run["exit_code"] == 0, "adapter failure is not a conclusion")
    require(run["timeout_status"] == "completed_without_timeout", "adapter timeout")
    require(contract["result"]["operation"]["operation_id"] == operation, "contract")
    require(response["request"] == {"operation_id": operation, "payload": payload},
            "response is not bound to the exact payload")
    require(response["result"]["operation_id"] == operation, "response operation")
    require(response["server"]["version"] == contract["server"]["version"], "server")
    require(response["protocol_version"] == contract["protocol_version"], "protocol")
    output = response["result"]["output"]
    require(output["comparison_scope"] == "FORMAL_COEFFICIENTWISE_IDENTITY", "scope")
    require(output["modulus"] == payload["modulus"] == 101, "modulus")
    require(output["variable_order"] == payload["variables"], "output variables")
    for side in ("left", "right"):
        require(output["normalized_" + side] == normalized_terms(payload[side], 101),
                "independent coefficient replay: " + side)
    require(output["identical"] is True and output["residual"] == [], "nonidentity")
    coefficient_bound = sum(
        abs(int(term["coefficient"])) for side in ("left", "right")
        for term in payload[side]
    )
    require(coefficient_bound == 14 < 101, "integer lifting bound")
    zero(polynomial(payload["left"], variables) - polynomial(payload["right"], variables),
         "exact rational coefficient replay")

    t, s = sp.symbols("t s", real=True)
    left_kernel = s * (1 - t)
    right_kernel = t * (1 - s)
    kernel_integral = sp.integrate(left_kernel, (s, 0, t)) + sp.integrate(
        right_kernel, (s, t, 1)
    )
    zero(kernel_integral - t * (1 - t) / 2, "Green kernel normalization")
    zero(sp.Rational(1, 8) - kernel_integral - (t - sp.Rational(1, 2)) ** 2 / 2,
         "Green kernel maximum")
    zero(left_kernel.subs(s, 0), "left Dirichlet condition")
    zero(right_kernel.subs(s, 1), "right Dirichlet condition")
    zero(left_kernel.subs(s, t) - right_kernel.subs(s, t), "kernel continuity")
    zero(sp.diff(right_kernel, s) - sp.diff(left_kernel, s) + 1,
         "Green derivative jump")

    lam, At, A0, A1, Et, E0, E1, K, C, D = sp.symbols(
        "lam At A0 A1 Et E0 E1 K C D"
    )
    entropy_residual = Et - lam * At - (
        (1 - t) * (E0 - lam * A0) + t * (E1 - lam * A1) - K * C + lam * D
    )
    rearranged_residual = lam * (At - (1 - t) * A0 - t * A1 + D) - (
        Et - (1 - t) * E0 - t * E1 + K * C
    )
    zero(entropy_residual + rearranged_residual, "entropy sign rearrangement")

    a, x = sp.symbols("a x", positive=True)
    zero(
        1 / (4 * a) - x / (a + x) ** 2
        - (a - x) ** 2 / (4 * a * (a + x) ** 2),
        "L2 resolvent gradient bound",
    )
    alpha, zeta = sp.symbols("alpha zeta")
    zero(
        sp.Rational(1, 2) - (2 * alpha + zeta)
        - (2 * (sp.Rational(1, 8) - alpha) + sp.Rational(1, 4) - zeta),
        "resolvent contraction slack identity",
    )

    x = sp.symbols("x", real=True)
    Fplus = -x / (1 + x)
    Fminus = x / (1 - x)
    Gplus = 2 / (1 + x) ** 3
    Gminus = 2 / (1 - x) ** 3
    zero(sp.diff(Fplus, x, 2) - Gplus, "positive-half-line Hessian density")
    zero(sp.diff(Fminus, x, 2) - Gminus, "negative-half-line Hessian density")
    zero(Fplus.subs(x, 0) - Fminus.subs(x, 0), "F continuity at kink")
    jump = sp.diff(Fplus, x).subs(x, 0) - sp.diff(Fminus, x).subs(x, 0)
    require(jump == -2, "distributional Hessian atom")
    zero(Gplus.subs(x, 0) - Gminus.subs(x, 0), "G continuity at kink")
    zero(1 - x / (1 + x) - 1 / (1 + x), "F boundedness")
    zero(x / (1 + x) - sp.Rational(1, 2) - (x - 1) / (2 * (1 + x)),
         "non-L2 tail bound for x>=1")
    energy = sp.integrate(sp.diff(Fplus, x) ** 2, (x, 0, sp.oo)) + sp.integrate(
        sp.diff(Fminus, x) ** 2, (x, -sp.oo, 0)
    )
    require(energy == sp.Rational(2, 3), "finite gradient energy")
    curve_plus = Fplus.subs(x, 2 * t - 1)
    curve_minus = Fminus.subs(x, 2 * t - 1)
    zero(sp.diff(curve_plus, t, 2) - 4 * Gplus.subs(x, 2 * t - 1),
         "positive curve Hessian density")
    zero(sp.diff(curve_minus, t, 2) - 4 * Gminus.subs(x, 2 * t - 1),
         "negative curve Hessian density")
    curve_jump = sp.diff(curve_plus, t).subs(t, sp.Rational(1, 2)) - sp.diff(
        curve_minus, t
    ).subs(t, sp.Rational(1, 2))
    require(curve_jump == -4, "curve Hessian atom")

    lean = json.loads((HERE / "lean/verification_output.json").read_text())
    require(lean["status"] == "success" and lean["exit_code"] == 0, "Lean verdict")
    require(lean["proof_holes"] == [], "Lean proof holes")
    require("version 4.31.0," in lean["tools"]["lean"]["version"], "Lean version")
    recorded = lean["kernel"]["recorded"]
    require(recorded["verdict"] == "supports", "formal claim attachment")
    require(recorded["subject"]["subject_id"] == "C_W356_FORMAL_CORE", "formal claim")
    archive_path = HERE.parent.parent / recorded["artifact"]
    require(archive_path.parent == HERE / "lean/certificates", "archive scope")
    archive = json.loads(archive_path.read_text())
    require(archive["lean_source"]["text"] == (HERE / "lean/Main.lean").read_text(),
            "formal source changed after compilation")
    require(archive["statement_fidelity"]["text"]
            == (HERE / "lean/statement_fidelity.md").read_text(),
            "statement fidelity changed after compilation")
    require(archive["lean_check"] == {k: v for k, v in lean.items() if k != "kernel"},
            "compiler receipt differs from the immutable archive")

    return {
        "claim_ids": ["C_W356_VARIABLE_CD", "C_W356_EVERY_GEODESIC"],
        "proof": "research/weak_hessian_audit/report.md",
        "classification": "exact_supporting_identities_and_admissible_boundary_test",
        "analytic_theorem_machine_checked": False,
        "independent_review_required": True,
        "novelty_claimed": False,
        "bochner_correction": str(sp.expand(correction)),
        "jacobian": {
            "operation_id": operation,
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "adapter_exit_code": run["exit_code"],
            "timeout_status": run["timeout_status"],
            "coefficient_bound": coefficient_bound,
            "modulus": 101,
            "integer_identity": True,
        },
        "green_kernel_integral": str(sp.factor(kernel_integral)),
        "green_kernel_derivative_jump": -1,
        "green_kernel_maximum": "1/8",
        "entropy_rearrangement_residual": "0",
        "resolvent_spectral_slack": "(a-x)^2/(4*a*(a+x)^2)",
        "contraction": {
            "c_a": "2/sqrt(a)+sqrt(max(-K,0))/a",
            "sufficient_a": "a>=max(1,64*B^2,4*B*sqrt(max(-K,0)))",
            "factor_bound": "B*c_a<=1/2",
        },
        "lean": {
            "claim_id": "C_W356_FORMAL_CORE",
            "compiler_version": "4.31.0",
            "exit_code": 0,
            "proof_holes": [],
            "certificate": recorded["artifact"],
            "scope": "abstract graph closure and energy convergence; scalar cancellations",
            "current_source_and_fidelity_match_archive": True,
            "full_RCD_theorem_formalized": False,
        },
        "boundary_example": {
            "space": "(R,usual distance,dx), RCD(0,2), infinite total measure",
            "F": "-abs(x)/(1+abs(x))",
            "G": "2/(1+abs(x))^3",
            "F_second_derivative": "G*dx-2*delta_0",
            "gradient_energy": str(energy),
            "F_in_L2": False,
            "F_in_Delta_domain": False,
            "weighted_test_classes_identical": False,
            "local_weighted_generator_jump": "-2*lambda",
            "geodesic": "sigma(t)=2*t-1",
            "curve_second_derivative": "4*G(2*t-1)*dt-4*delta_(1/2)",
            "counterexample_to_manuscript": False,
        },
        "limitations": [
            "The RCD analytic proof and external equivalences require human review.",
            "The boundary test is not a counterexample and proves no universal theorem alone.",
            "The separate Lean certificate covers only its statement-fidelity declarations.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = calculate()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(certificate.read_text()) == result, "certificate changed")
    print("Exact algebra, typed Jacobian replay, kernel normalization, and kink data: PASS")
    print("Full analytic proof: independent review required; no novelty or refutation claimed.")


if __name__ == "__main__":
    main()
