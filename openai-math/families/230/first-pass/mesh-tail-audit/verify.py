#!/usr/bin/env python3
"""Replay exact algebra; do not mistake it for a stochastic proof checker."""

import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    identities = {}

    def zero(name, expression):
        remainder = sp.factor(sp.cancel(expression))
        require(remainder == 0, f"{name}: nonzero remainder {remainder}")
        identities[name] = "identically zero"

    k = sp.Symbol("kappa", positive=True)
    p = 1 - k / 8
    a0 = 8 / k - 1
    x, y, u, v = sp.symbols("x y u v", real=True)
    ctheta, b = sp.symbols("cot_theta b", real=True)
    z2 = x * x + y * y
    w2 = u * u + v * v

    zero("parameter_conversion", k * a0 / 8 - p)
    zero("positive_near_real_exponent", a0 - p - (8 - k) ** 2 / (8 * k))
    log_x = -a0 * x / z2
    log_y = (a0 - p) / y - a0 * y / z2
    log_xx = sp.diff(log_x, x)
    drift = (
        2 * x / z2 * log_x
        - 2 * y / z2 * log_y
        - 2 * p * (x * x - y * y) / z2**2
        + k / 2 * (log_xx + log_x**2)
    )
    zero("physical_green_martingale_drift", drift)
    zero("positive_brownian_coefficient_sign", -log_x - a0 * x / z2)
    zero("full_radius_clock", -2 / z2 + 2 * (x * x - y * y) / z2**2
         + 4 * y * y / z2**2)

    hprime_ratio = a0 * ctheta
    hsecond_ratio = a0 * (a0 - 1) * ctheta**2 - a0
    zero("radius_generator_eigenfunction",
         k / 8 * hsecond_ratio + (k - 4) / 4 * ctheta * hprime_ratio + p)
    zero("tilted_angle_drift", (k - 4) / 4 + k * a0 / 4 - 1)
    inverse_generator = k / 8 * (b + b * (b + 1) * ctheta**2) - b * ctheta**2
    zero("inverse_angle_lyapunov", inverse_generator
         - (k * b / 8 - k * b * (a0 - b) / 8 * ctheta**2))

    green = sp.log(((x - u) ** 2 + (y + v) ** 2)
                   / ((x - u) ** 2 + (y - v) ** 2)) / 2
    zero("common_translation_cancellation", sp.diff(green, x) + sp.diff(green, u))
    green_drift = (
        sp.diff(green, x) * 2 * x / z2
        - sp.diff(green, y) * 2 * y / z2
        + sp.diff(green, u) * 2 * u / w2
        - sp.diff(green, v) * 2 * v / w2
    )
    zero("all_kappa_green_decrease", green_drift + 4 * y * v / (z2 * w2))

    t, beta = sp.symbols("P beta", real=True)
    lyapunov = (1 + t * t) ** (beta / 2)
    derivative_ratio = sp.simplify(sp.diff(lyapunov, t) / lyapunov)
    second_ratio = sp.simplify(sp.diff(lyapunov, t, 2) / lyapunov)
    generator_ratio = k / 4 * (1 + t * t) * second_ratio + 2 * t * derivative_ratio
    stated_ratio = (
        2 * beta * t * t + k * beta / 4 * (1 + (beta - 1) * t * t)
    ) / (1 + t * t)
    zero("swallowing_lyapunov_generator", generator_ratio - stated_ratio)
    beta_choice = (k - 4) / (2 * k)
    rho = 2 * beta_choice + k * beta_choice * (beta_choice - 1) / 4
    zero("swallowing_positive_gap",
         beta_choice - rho - (k - 4) ** 2 / (16 * k))
    zero("swallowing_gronwall_gap",
         beta_choice - (rho + beta_choice) / 2 - (k - 4) ** 2 / (32 * k))
    zero("swallowing_rho_positive_decomposition",
         rho - beta_choice * ((8 - k) / 4 + k * beta_choice / 4))

    alpha, C1, Lambda = sp.symbols("alpha C1 Lambda", real=True)
    request = json.loads((HERE / "jacobian_request.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    operation = "matrix.symbolic.multiply.compute"
    require(response["request"]["operation_id"] == operation, "Wrong requested operation")
    require(response["request"]["payload"] == request, "Adapter payload does not match")
    require(response["result"]["operation_id"] == operation, "Wrong returned operation")
    require("output" in response["result"] and "error" not in response,
            "Adapter has no complete typed output")

    def rational_function(entry):
        symbols = [sp.Symbol(name, real=True) for name in entry["variables"]]

        def polynomial(poly):
            value = sp.Integer(0)
            for term in poly["terms"]:
                coefficient = term["coefficient"]
                numerator, denominator = int(coefficient["num"]), int(coefficient["den"])
                require(denominator > 0, "Nonpositive typed denominator")
                require(sp.gcd(numerator, denominator) == 1, "Noncanonical typed rational")
                require(len(term["exponents"]) == len(symbols), "Wrong monomial arity")
                monomial = sp.Rational(numerator, denominator)
                for symbol, exponent in zip(symbols, term["exponents"]):
                    require(isinstance(exponent, int) and exponent >= 0,
                            "Invalid polynomial exponent")
                    monomial *= symbol**exponent
                value += monomial
            return value

        denominator = polynomial(entry["denominator"])
        require(denominator != 0, "Zero rational-function denominator")
        return sp.cancel(polynomial(entry["numerator"]) / denominator)

    def matrix(value):
        require(value["variables"] == ["alpha", "C1", "Lambda"], "Wrong field")
        return sp.Matrix([[rational_function(entry) for entry in row]
                          for row in value["entries"]])

    left = matrix(request["left"])
    right = matrix(request["right"])
    output = matrix(response["result"]["output"])
    require(left.shape == (2, 2) and right.shape == output.shape == (2, 1),
            "Wrong recurrence matrix dimensions")
    expected_left = sp.Matrix([[1, alpha], [C1 / Lambda, alpha / Lambda]])
    require(left == expected_left and right == sp.Matrix([1, Lambda]),
            "Typed request is not the claimed envelope coefficient calculation")
    for row in range(2):
        zero(f"jacobian_product_row_{row}", (left * right - output)[row])
    zero("envelope_first_coefficient", output[0] - (1 + Lambda * alpha))
    zero("envelope_second_coefficient", output[1] - (C1 / Lambda + alpha))
    zero("envelope_nonnegative_slack",
         Lambda - C1 - alpha * Lambda
         - ((Lambda / 2 - C1) + Lambda * (sp.Rational(1, 2) - alpha)))

    P, a, err, value = sp.symbols("product a error value", real=True)
    zero("finite_product_induction_slack",
         (value + err) * P * (1 + a)
         - ((1 + a) * value * P + err)
         - (err * (P - 1) + err * P * a))
    j = sp.Symbol("j", positive=True, integer=True)
    zero("inverse_square_telescope_comparison",
         1 / (j * (j + 1)) - 1 / (j + 1) ** 2 - 1 / (j * (j + 1) ** 2))
    zero("inverse_square_telescope",
         1 / j - 1 / (j + 1) - 1 / (j * (j + 1)))
    epsilon = sp.Symbol("epsilon", real=True)
    zero("window_failure_q_exponent",
         2 * p + 2 * epsilon - 2 + 2 * (1 - p - epsilon))
    zero("window_failure_delta_exponent", -2 * p - (-2 - (2 * p - 2)))
    zero("density_area_scaling", 2 - p - (1 + k / 8))

    receipt = json.loads((HERE / "lean_run.json").read_text())
    require(receipt["status"] == "success" and receipt["exit_code"] == 0,
            "Lean compilation did not succeed")
    require(receipt["audit_exit_code"] == 0 and receipt["proof_holes"] == [],
            "Lean proof audit did not establish zero holes")
    require("4.31.0" in receipt["tools"]["lean"]["version"], "Wrong Lean version")
    require(receipt["kernel"]["recorded"] is not None, "Compiler result not in claim ledger")
    for filename, field in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        digest = hashlib.sha256((HERE / filename).read_bytes()).hexdigest()
        require(digest == receipt[field], f"Stale compiler receipt for {filename}")

    source_root = ROOT / "research" / "openai_manuscript"
    sep26 = source_root / "An-explicit-exact-Hausdorff-gauge-for-SLE-September-26-2026" / "build" / "sections"
    sep25 = source_root / "An-exact-Hausdorff-gauge-for-SLE-September-25-2026" / "build" / "sections"
    anchors = []
    for directory, name, labels in [
        (sep26, "mesh-tails.tex",
         ["mesh:tail", "mesh:layer", "mesh:green-decrease", "mesh:bracket-bound",
          "win:concentration", "win:means", "win:recurrences"]),
        (sep26, "local-laws.tex",
         ["ll:finite-tilt", "ll:approach", "ll:localization", "ll:swallowing", "ll:disk-rule"]),
        (sep26, "geometry.tex", ["geom:extension", "geom:fresh-tip", "geom:first-hit-access"]),
        (sep26, "introduction.tex", ["thm:main"]),
        (sep25, "introduction.tex", ["thm:main"]),
    ]:
        path = directory / name
        text = path.read_text()
        for label in labels:
            marker = "\\label{" + label + "}"
            require(text.count(marker) == 1, f"Missing or ambiguous source anchor {label}")
            line = text[:text.index(marker)].count("\n") + 1
            anchors.append({"path": str(path.relative_to(ROOT)), "label": label, "line": line})

    certificate = {
        "schema_version": 1,
        "claim": "C26_MESH_TAIL",
        "proposed_result_class": "new_theorem",
        "status": "engineer_proof_ready_independent_review_required",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "convention": {
            "p": "1-kappa/8", "a0": "8/kappa-1", "d": "1+kappa/8",
            "radius": "full conformal radius; R_H(x+iy)=2y",
            "driver": "sqrt(kappa)*B_t; partial_t g=2/(g-driver)",
            "september25_mapping": "alpha_old=p; p_old=a0; time_old=kappa*time_here",
        },
        "theorems": [
            {
                "id": "V",
                "claim": "C26_MESH_TAIL",
                "quantifiers": "Every fixed 0<kappa<8, fixed free collar of A=B(0,1), every permitted marked stopped domain, every prescribed 0<e<=delta<=delta0.",
                "conclusion": "P(integral_A W_e>C delta^(-p))<=C exp(-c delta^(-2)); constants depend only on kappa and collar.",
            },
            {
                "id": "D",
                "claim": "C_MESH_DOMAIN_EXTENSION",
                "quantifiers": "Every bounded simply connected locally connected-boundary initial domain with arbitrary distinct marked prime ends, and finite stopped pasts, with the same free collar.",
                "conclusion": "The same uniform estimate, independent of domain diameter, boundary modulus, and end locations.",
            },
            {
                "id": "U",
                "claim": "C_MESH_SIMULTANEOUS",
                "quantifiers": "4<kappa<8; either domain class; every 0<delta<=delta0; all 0<e<=delta on one event.",
                "conclusion": "E_delta=q^(-p) sup_j r_j^(-p) integral_A I_(r_j) is measurable, dominates every integral_A W_e, and has the same exp(-c delta^(-2)) tail.",
            },
        ],
        "source_anchors": anchors,
        "symbolic_identities": identities,
        "universal_inequalities": {
            "formal_claim": "C_MESH_ALGEBRA",
            "declarations": [
                "MeshTail.envelope_step", "MeshTail.scalar_product_bound",
                "MeshTail.uniform_scalar_bound", "MeshTail.fifth_power_bound",
                "MeshTail.geometric_over_fourth",
            ],
            "infinite_failure_sum": "B>=32 implies B^j/(j+1)^4>=j+1 for every natural j, then use the exact geometric series.",
            "error_sum": "The inverse-square sum is at most 2 by the exact telescoping comparison.",
            "coefficient_sum": "alpha_j=alpha_0*t^j, 0<t<1, has sum alpha_0/(1-t).",
        },
        "jacobian": {
            "operation_id": operation,
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "transport": response["transport"],
            "request": "jacobian_request.json",
            "typed_output": "jacobian_result.json",
            "recorded_adapter_exit_code": 0,
            "timeout": False,
            "structured_error": None,
            "coverage": "Exact two-row recurrence coefficient product only.",
        },
        "lean": {
            "receipt": "lean_run.json",
            "version": receipt["tools"]["lean"]["version"],
            "exit_code": receipt["exit_code"],
            "audit_exit_code": receipt["audit_exit_code"],
            "proof_holes": receipt["proof_holes"],
            "claim": "C_MESH_ALGEBRA",
            "ledger_record": receipt["kernel"]["recorded"],
            "coverage": "Deterministic real recurrence bounds and all-natural-index series comparison only.",
        },
        "analytic_proof": "report.md Sections 1-7; no disputed stochastic dependency is assumed.",
        "not_mechanically_verified": [
            "SLE trace and stochastic-calculus arguments",
            "Brownian circuit and Green occupation",
            "Prime-end continuity and fresh-tip access",
            "Uniform conformal energy localization and swallowing",
            "Adaptive enumeration, stochastic Fubini, and application of the universal inequalities",
            "Global novelty, significance, and independent Reviewer acceptance",
        ],
        "false_manuscript_claims_identified": [],
        "novelty_status": "bounded_primary_source_comparison_only",
        "independent_review": "pending_host_invocation",
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "ok": True,
        "exact_symbolic_identities": len(identities),
        "formal_declarations": 5,
        "source_anchors": len(anchors),
        "certificate": "research/mesh-tail-audit/exact_certificate.json",
        "analytic_review": "pending",
    }))


if __name__ == "__main__":
    main()
