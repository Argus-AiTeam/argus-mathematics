#!/usr/bin/env python3
"""Replay exact algebra, parameter budgets and the real Lean binding."""

import hashlib
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
VARIABLES = sp.symbols("e u v x y z")
OPERATION = "matrix.symbolic.determinant.compute"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def load(path):
    return json.loads(path.read_text())


def polynomial(record):
    terms = []
    for term in record["terms"]:
        powers = term["exponents"]
        require(len(powers) == len(VARIABLES), "Wrong monomial dimension")
        require(all(type(k) is int and k >= 0 for k in powers), "Invalid power")
        coefficient = term["coefficient"]
        numerator, denominator = int(coefficient["num"]), int(coefficient["den"])
        require(denominator > 0, "Nonpositive rational denominator")
        terms.append(
            sp.Rational(numerator, denominator)
            * sp.prod(var**power for var, power in zip(VARIABLES, powers))
        )
    return sp.Add(*terms)


def rational_function(record):
    require(record["domain"] == "QQ", "Nonrational Jacobian result")
    require(record["variables"] == [str(v) for v in VARIABLES], "Variable mismatch")
    denominator = polynomial(record["denominator"])
    require(denominator != 0, "Zero rational-function denominator")
    return sp.cancel(polynomial(record["numerator"]) / denominator)


def main():
    certificate = load(HERE / "exact_certificate.json")
    require(certificate["schema_version"] == 1, "Unknown certificate schema")
    require(certificate["analytic_claim"] == "P_EXPOSURE", "Wrong analytic claim")
    require(
        certificate["continuous_statement_machine_checked"] is False,
        "The finite checks cannot certify the continuous exposure theorem",
    )
    require(
        certificate["analytic_review"] == "independent_review_required",
        "This certificate does not carry an independent analytic verdict",
    )

    source = ROOT / certificate["manuscript_source"]
    source_text = " ".join(source.read_text().split())
    require(r"\label{exp:exposure}" in source_text, "Missing target proposition")
    require(
        " ".join(certificate["literal_bound"].split()) in source_text,
        "The literal manuscript assertion no longer matches",
    )

    payload = load(HERE / "jacobian_payload.json")
    archived = load(HERE / "jacobian_output.json")
    require(archived["schema_version"] == 1, "Unknown adapter schema")
    require(archived["protocol_version"] == "2025-11-25", "Protocol mismatch")
    require(archived["server"]["name"] == "jacobian", "Wrong server")
    require(archived["server"]["version"] == "0.14.0", "Server version mismatch")
    require(archived["request"]["operation_id"] == OPERATION, "Wrong operation")
    require(archived["request"]["payload"] == payload, "Payload not source-bound")
    result = archived["result"]
    require(result["operation_id"] == OPERATION, "Output operation mismatch")
    require(result["output"]["method"] == "SYMPY_BAREISS", "Unexpected method")
    require(certificate["jacobian_exit_code"] == 0, "Adapter did not complete")

    e, u, v, x, y, z = VARIABLES
    matrix = sp.Matrix(
        [[rational_function(entry) for entry in row] for row in payload["matrix"]["entries"]]
    )
    expected_matrix = sp.Matrix(
        [
            [x, 2 * e * (1 - u**2 + v**2), -4 * e * u * v],
            [y, -4 * e * u * v, 2 * e * (1 + u**2 - v**2)],
            [z, -4 * e * u, -4 * e * v],
        ]
    )
    require(
        all(sp.expand(value) == 0 for value in matrix - expected_matrix),
        "Payload does not encode the contact chart",
    )
    D = 1 + u**2 + v**2
    normal = sp.Matrix([2 * u, 2 * v, 1 - u**2 - v**2]) / D
    expected_det = 4 * e**2 * D * (2 * u * x + 2 * v * y + (1 - u**2 - v**2) * z)
    require(sp.expand(matrix.det() - expected_det) == 0, "Flux determinant failed")
    adapter_det = rational_function(result["output"]["determinant"])
    require(sp.expand(adapter_det - expected_det) == 0, "Typed determinant failed")
    require(sp.cancel(normal.dot(normal) - 1) == 0, "Stereographic normal failed")
    require(
        all(sp.cancel(value) == 0 for value in normal.diff(u).cross(normal.diff(v)) - 4 * normal / D**2),
        "Sphere area-vector orientation failed",
    )
    require(
        all(sp.cancel(value) == 0 for value in matrix[:, 1] - e * D**2 * normal.diff(u)),
        "First tangent column failed",
    )
    require(
        all(sp.cancel(value) == 0 for value in matrix[:, 2] - e * D**2 * normal.diff(v)),
        "Second tangent column failed",
    )
    rho = sp.Symbol("rho", real=True)
    require(
        8 * sp.pi**2 * sp.integrate(rho, (rho, 0, 1)) == 4 * sp.pi**2,
        "Normalized Haar/impact-disk flux constant failed",
    )

    anchor, shift, qi, ql = sp.symbols("anchor shift qi ql")
    require(
        sp.expand(anchor + (shift + ql) - (shift + qi) - (anchor + ql - qi)) == 0,
        "Dormant common-translation cancellation failed",
    )
    require(
        sp.expand((shift + qi) + ql - qi - (shift + ql)) == 0,
        "Dormant contact recovery failed",
    )
    exponents = {key: Fraction(value) for key, value in certificate["exponents"].items()}
    require(
        exponents == {
            "arc_error": Fraction(24, 25),
            "time": Fraction(19, 20),
            "separation": Fraction(17, 20),
            "birth_spacing": Fraction(9, 10),
            "interaction_radius": Fraction(1),
        },
        "Certificate exponents differ from the selected manuscript gates",
    )
    gaps = {
        "tube": exponents["arc_error"] - exponents["time"],
        "early_motion": exponents["time"] - exponents["separation"],
        "initial_offset": exponents["interaction_radius"] - exponents["separation"],
        "birth_spacing": exponents["time"] - exponents["birth_spacing"],
        "radius_in_arc_error": exponents["interaction_radius"] - exponents["arc_error"],
    }
    require(all(gap > 0 for gap in gaps.values()), "A required scale gap is nonpositive")
    require(
        {key: str(value) for key, value in gaps.items()} == certificate["scale_gaps"],
        "Incorrect exact scale-gap certificate",
    )
    require(Fraction(certificate["claimed_epsilon_exponent"]) == gaps["tube"], "Wrong gain")

    power = certificate["power_complexity"]
    require(
        power == {
            "claim": "V_POWER_EXPOSURE_001",
            "parameters": "B>=1; 0<alpha<=1",
            "eta": "alpha/(800*(3*B+1))",
            "range": "p,J<=epsilon**(-eta)",
            "exposed_fraction": "k>=alpha*p",
            "absolute_bound": "A_p*epsilon**(alpha*p/800)",
            "mass_bound": "(B*p*J)**(B*p)",
            "one_test_gain": "B*p**B*epsilon**(1/100)",
            "tube_gap_lower_bound": "23/2400",
            "early_motion_gap_lower_bound": "239/2400",
            "log_coefficient_upper_bound": "-3*alpha/800",
            "constant_log_budget": "alpha/800",
            "post_absorption_decay": "alpha/400",
            "claimed_decay": "alpha/800",
            "analytic_review": "independent_review_required",
            "continuous_statement_machine_checked": False,
        },
        "Power-complexity parameters differ from the theorem",
    )
    B, alpha, eta = sp.symbols("B alpha eta", real=True)
    budget = alpha / 800 - (3 * B + 1) * eta
    eta_value = alpha / (800 * (3 * B + 1))
    require(sp.cancel(budget.subs(eta, eta_value)) == 0, "Incorrect eta budget")
    nonnegative_gap = (budget + (1 - alpha) / 800 + eta) / 3
    for gap, lower in [
        (sp.Rational(1, 100), sp.Rational(23, 2400)),
        (sp.Rational(1, 10), sp.Rational(239, 2400)),
    ]:
        require(
            sp.expand(gap - B * eta - lower - nonnegative_gap) == 0,
            "Scale slack has no stated nonnegative decomposition",
        )
    cost = (2 * B + alpha * B / 2) * eta - alpha / 200
    nonnegative_margin = budget + eta + B * eta / 2 + (1 - alpha) * B * eta / 2
    require(
        sp.expand(-3 * alpha / 800 - cost - nonnegative_margin) == 0,
        "Extensive logarithmic cost balance failed",
    )
    require(
        Fraction(3, 800) - Fraction(1, 800) == Fraction(1, 400)
        and Fraction(1, 400) > Fraction(1, 800) > 0,
        "Constant absorption does not imply the claimed positive decay",
    )

    formal_path = certificate["formal_certificate"]
    formal = load(ROOT / formal_path)
    check = formal["lean_check"]
    require(formal["subject"]["subject_id"] == "L_CAUSAL_CORE", "Wrong formal subject")
    require(formal["tier"] == "mechanical" and formal["verdict"] == "supports", "No kernel support")
    require(check["status"] == "success" and check["exit_code"] == 0, "Lean failed")
    require(check["audit_exit_code"] == 0 and check["proof_holes"] == [], "Lean proof audit failed")
    require("version 4.31.0," in check["tools"]["lean"]["version"], "Wrong Lean version")
    require(check["environment_failure"] == "", "Unverified Lean environment")
    source_bytes = (HERE / "Main.lean").read_bytes()
    fidelity_bytes = (HERE / "statement_fidelity.md").read_bytes()
    require(source_bytes.decode() == formal["lean_source"]["text"], "Lean source is stale")
    require(fidelity_bytes.decode() == formal["statement_fidelity"]["text"], "Fidelity document is stale")
    require(hashlib.sha256(source_bytes).hexdigest() == check["source_sha256"], "Lean source binding failed")
    require(
        hashlib.sha256(fidelity_bytes).hexdigest() == check["statement_fidelity_sha256"],
        "Lean fidelity binding failed",
    )
    state = load(ROOT / "research/MATH_STATE.json")
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "L_CAUSAL_CORE"),
        key=lambda c: c["version"],
    )
    require(formal["subject"]["content_hash"] == claim["content_hash"], "Formal claim was revised")
    require(claim["formal_statement"] == source_bytes.decode(), "Wrong recorded formal statement")
    require(
        any(
            item["subject"] == formal["subject"]
            and item["artifact"] == formal_path
            and item["tier"] == "mechanical"
            and item["verdict"] == "supports"
            for item in state["evidence"]
        ),
        "The archived compiler result is not attached to the current claim",
    )
    print(json.dumps({
        "status": "exact_checks_passed",
        "formal_claim": "L_CAUSAL_CORE",
        "lean_exit_code": 0,
        "proof_holes": [],
        "contact_chart": "exact",
        "scale_gaps": certificate["scale_gaps"],
        "power_complexity_claim": power["claim"],
        "power_budget": "universal_nonnegative_decompositions_checked",
        "power_decay_per_label": power["claimed_decay"],
        "analytic_claim": "P_EXPOSURE",
        "analytic_review": "independent_review_required",
        "continuous_statement_machine_checked": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
