#!/usr/bin/env python3
"""Replay exact algebra supporting, but not formalizing, the analytic proof."""

import json
import math
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROJECT_ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def require_zero(expression, message):
    require(sp.simplify(expression) == 0, message)


def load_json(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def polynomial(record):
    require(record["domain"] == "QQ", "Expected an exact QQ polynomial")
    names = record["variables"]
    require(1 <= len(names) <= 8 and len(set(names)) == len(names),
            "Invalid polynomial variable list")
    variables = tuple(sp.Symbol(name) for name in names)
    expression = sp.Integer(0)
    previous = None
    for term in record["polynomial"]["terms"]:
        exponents = tuple(term["exponents"])
        require(len(exponents) == len(variables), "Exponent dimension mismatch")
        require(all(type(e) is int and e >= 0 for e in exponents),
                "Exponents must be nonnegative integers")
        require(previous is None or previous > exponents,
                "Terms must be distinct and in descending lexicographic order")
        previous = exponents
        numerator_text = term["coefficient"]["num"]
        denominator_text = term["coefficient"]["den"]
        numerator, denominator = int(numerator_text), int(denominator_text)
        require(str(numerator) == numerator_text and str(denominator) == denominator_text,
                "Noncanonical rational spelling")
        require(denominator > 0 and math.gcd(numerator, denominator) == 1,
                "Rational must be reduced with positive denominator")
        require(numerator != 0, "Sparse terms must have nonzero coefficients")
        coefficient = sp.Rational(numerator, denominator)
        expression += coefficient * sp.prod(
            variable ** exponent for variable, exponent in zip(variables, exponents)
        )
    return variables, sp.expand(expression)


def check_source(certificate):
    source = (PROJECT_ROOT / certificate["source"]).read_text(encoding="utf-8")
    labels = [binding["label"] for binding in certificate["source_bindings"]]
    require(labels == ["pi:radial-transport", "pi:sharp-projection"],
            "The certificate must bind both audited lemmas")
    for binding in certificate["source_bindings"]:
        marker = "\\label{" + binding["label"] + "}"
        require(source.count(marker) == 1, "Missing or ambiguous source label")
        start = source.index(marker) + len(marker)
        end = source.index("\\end{lemma}", start)
        require(source[start:end].strip() == binding["literal_statement"],
                "Literal source statement changed: " + binding["label"])


def check_cutoff(certificate):
    record = certificate["cutoff_nonnegative_numerator"]
    require(record["variables"] == ["N", "u", "v", "delta", "phi", "d"],
            "Cutoff variables changed")
    require(certificate["cutoff_parameter_definitions"] == {
        "N": "n-2 >= 0",
        "u": "R-1 > 0",
        "v": "t-R >= 0 on the annulus",
        "delta": "n+1-a >= 0",
        "phi": "cutoff value >= 0",
        "d": "-phi_prime-A0*phi >= 0",
        "A0": "2*(n+4)/(R-1)",
    }, "Cutoff parameter meanings changed")
    variables, expected = polynomial(record)
    N, u, v, delta, phi, defect = variables
    n, R = N + 2, u + 1
    t, a = R + v, n + 1 - delta
    A0 = 2 * (n + 4) / u
    minus_phi_prime = A0 * phi + defect
    numerator = sp.cancel(u * ((t - 1) * minus_phi_prime - (a + 3) * phi))
    require_zero(numerator - expected, "Cutoff margin certificate is not the derived margin")
    coefficients = sp.Poly(expected, *variables, domain=sp.QQ).coeffs()
    require(all(coefficient >= 0 for coefficient in coefficients),
            "Cutoff margin has a negative coefficient")

    n, R, t = sp.symbols("n R t", real=True)
    A0 = 2 * (n + 4) / (R - 1)
    first = sp.exp(-A0 * (t - R))
    second = first * (3 * R - t) / R
    require_zero(-sp.diff(first, t) - A0 * first, "First cutoff derivative is wrong")
    require_zero(-sp.diff(second, t) - A0 * second - first / R,
                 "Second cutoff derivative is wrong")
    require_zero(first.subs(t, R) - 1, "Cutoff is discontinuous at R")
    require_zero(first.subs(t, 2 * R) - second.subs(t, 2 * R),
                 "Cutoff is discontinuous at 2R")
    require_zero(second.subs(t, 3 * R), "Cutoff is discontinuous at 3R")
    require_zero(first.subs(t, 2 * R) - sp.exp(-A0 * R),
                 "The inner-ball lower bound has the wrong endpoint value")


def check_jacobian(certificate):
    evidence = certificate["jacobian"]
    contract = load_json(evidence["contract"])
    payload = load_json(evidence["payload"])
    typed = load_json(evidence["typed_output"])
    operation = evidence["operation_id"]
    require(operation == "polynomial.sos.decomposition.check", "Wrong Jacobian operation")
    require(evidence["adapter_exit_code"] == 0 and evidence["timeout"] is False
            and evidence["error"] is None, "Jacobian result is not a completed success")
    for retained in (contract, typed):
        require(retained["protocol_version"] == evidence["protocol_version"],
                "Jacobian protocol mismatch")
        require(retained["server"]["name"] == "jacobian"
                and retained["server"]["version"] == evidence["server_version"],
                "Jacobian server metadata mismatch")
        require(retained["transport"] == evidence["transport"], "Jacobian transport mismatch")
    inspected = contract["result"]["operation"]
    require(inspected["operation_id"] == operation and inspected["read_only"] is True,
            "Wrong retained operation contract")
    require(set(inspected["input_schema"]["required"]) == {"polynomial", "summands"},
            "Unexpected SOS input contract")
    require(typed["tool"] == "math.run", "Retained answer is not an execution")
    require(typed["request"] == {"operation_id": operation, "payload": payload},
            "Typed result is not bound to the retained payload")
    require(typed["result"]["operation_id"] == operation, "Result operation mismatch")
    output = typed["result"]["output"]
    require(output["is_valid"] is True and output["method"] == "EXACT_COEFFICIENT_IDENTITY",
            "Typed SOS answer does not assert an exact identity")
    require(output["polynomial"] == payload["polynomial"]
            and output["summands"] == payload["summands"],
            "Typed result changed the input polynomials")

    variables, p = polynomial(payload["polynomial"])
    require(payload["polynomial"]["variables"] == ["t", "m", "s"],
            "Young identity variables changed")
    t, m, s = variables
    require_zero(p - (t ** 2 / 4 - m * s * t + m ** 2 * s ** 2),
                 "Payload does not encode the required Young margin")
    require(len(payload["summands"]) == 1, "Expected the specific one-square identity")
    square_variables, q = polynomial(payload["summands"][0])
    require(square_variables == variables, "Summand variables differ")
    require_zero(q - (t / 2 - m * s), "Wrong Young square")
    require_zero(p - q ** 2, "Independent exact SOS replay failed")
    sum_variables, retained_sum = polynomial(output["computed_sum"])
    require(sum_variables == variables, "Computed-sum variables differ")
    require_zero(retained_sum - q ** 2, "Retained computed sum is wrong")


def check_other_algebra(certificate):
    alpha, s, C = sp.symbols("alpha s C", real=True)
    require_zero(2 * (alpha ** 2 + s ** 2) - (alpha + s) ** 2 - (alpha - s) ** 2,
                 "The forcing square inequality has the wrong sign")
    require_zero(C * (alpha + s) / alpha - C * (1 + s / alpha),
                 "Normalization coefficient identity failed")

    t, k = sp.symbols("t k", real=True)
    H = sp.Function("H")(t)
    quotient_derivative = sp.diff((H + k) / t, t)
    require_zero(quotient_derivative - (t * sp.diff(H, t) - H - k) / t ** 2,
                 "Euler ray-quotient differentiation failed")

    L, separation = sp.symbols("L C_sep", real=True)
    R, S = 16 * (L + separation + 2), 32 * 16 * (L + separation + 2)
    derived = {
        "target_ball": R / 2 - (2 * L + 4 + separation),
        "common_radial_ball": S / 2 - 8 * R - 2 * separation,
    }
    require(set(certificate["domain_margins"]) == set(derived), "Domain margin list changed")
    for name, expression in derived.items():
        coefficients = certificate["domain_margins"][name]
        require(set(coefficients) == {"L", "C_sep", "constant"}, "Wrong margin variables")
        require(all(type(c) is int and c > 0 for c in coefficients.values()),
                "Domain margin is not strictly positive for L,C_sep>1")
        expected = coefficients["L"] * L + coefficients["C_sep"] * separation \
            + coefficients["constant"]
        require_zero(expression - expected, "Wrong ball-inclusion margin: " + name)


def main():
    certificate = load_json("exact_certificate.json")
    require(certificate["schema_version"] == 1 and certificate["claim_id"] == "C_SP",
            "Unexpected certificate identity")
    require(certificate["result_type"] == "conditional_analytic_verification"
            and certificate["main_theorem_verified"] is False
            and certificate["novelty_claimed"] is False,
            "The certificate overstates its mathematical scope")
    require(set(certificate["analytic_inputs"]) == {
        "SP_GEOMETRY", "SP_POISSON", "SP_RADIAL", "SP_CALCULUS",
        "AH_LOCAL_COMPACTNESS", "AH_LOCAL_STABILITY", "AH_LOCAL_PAIRING",
    }, "The imported dependency boundary changed")
    require((HERE / certificate["analytic_report"]).is_file()
            and (HERE / certificate["statement_fidelity"]).is_file(),
            "The mathematical report or statement-fidelity explanation is missing")

    check_source(certificate)
    check_cutoff(certificate)
    check_jacobian(certificate)
    check_other_algebra(certificate)
    print(json.dumps({
        "claim_id": "C_SP",
        "exact_core_valid": True,
        "checks": [
            "literal_source_statements",
            "universal_cutoff_sign_polynomial",
            "cutoff_derivatives_and_joining_values",
            "source_bound_typed_jacobian_SOS_replay",
            "forcing_square_and_normalization_identities",
            "Euler_ray_quotient_identity",
            "strict_ball_inclusion_margins",
        ],
        "sampled_parameters": 0,
        "analytic_theorem_machine_verified": False,
        "complete_analytic_proof": "report.md",
        "independent_review": certificate["independent_review"],
        "main_theorem_verified": False,
    }, indent=2))


if __name__ == "__main__":
    main()
