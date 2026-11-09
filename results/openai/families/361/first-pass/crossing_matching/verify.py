#!/usr/bin/env python3
"""Replay exact algebra and the recorded formal core, not the analytic PDE proof."""

import argparse
import hashlib
import json
from fractions import Fraction
from math import ceil, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
VARIABLES = ["a", "b", "e", "f", "u"]
OPERATION = "matrix.symbolic.linear_system.solve"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] = result.get(monomial, Fraction(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def scale(polynomial, coefficient):
    return {m: c * coefficient for m, c in polynomial.items() if c * coefficient}


def multiply(left, right):
    result = {}
    for m, c in left.items():
        for n, d in right.items():
            key = tuple(sorted(m + n))
            result[key] = result.get(key, Fraction(0)) + c * d
    return {m: c for m, c in result.items() if c}


def variable(name):
    return {(name,): Fraction(1)}


def sparse_polynomial(value, variables):
    result = {}
    for term in value["terms"]:
        exponents = term["exponents"]
        require(len(exponents) == len(variables), "Polynomial axis mismatch")
        require(all(type(e) is int and e >= 0 for e in exponents), "Invalid exponents")
        raw = term["coefficient"]
        coefficient = Fraction(int(raw["num"]), int(raw["den"]))
        require(
            str(coefficient.numerator) == raw["num"]
            and str(coefficient.denominator) == raw["den"],
            "Noncanonical rational coefficient",
        )
        monomial = tuple(
            sorted(name for name, power in zip(variables, exponents) for _ in range(power))
        )
        require(monomial not in result and coefficient != 0, "Noncanonical polynomial")
        result[monomial] = coefficient
    return result


def rational_function(value):
    require(value["variables"] == VARIABLES, "Rational-function axis mismatch")
    require(value.get("domain", "QQ") == "QQ", "Unexpected coefficient domain")
    numerator = sparse_polynomial(value["numerator"], VARIABLES)
    denominator = sparse_polynomial(value["denominator"], VARIABLES)
    require(bool(denominator), "Zero polynomial denominator")
    return numerator, denominator


def equal_rational(left, right):
    return multiply(left[0], right[1]) == multiply(right[0], left[1])


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_status"] == 0, "Jacobian adapter did not succeed")
    require(status["inspection_completed_before_run"] is True, "Missing contract inspection")
    require(response["request"]["operation_id"] == OPERATION, "Wrong requested operation")
    require(response["request"]["payload"] == payload, "Unbound Jacobian payload")
    require(response["result"]["operation_id"] == OPERATION, "Wrong returned operation")
    output = response["result"]["output"]
    require(output["classification"] == "UNIQUE", "No unique generic-field solution")
    require(output["consistency"] == "EXACT_RATIONAL_FUNCTION", "Inexact output")
    require(output["field_semantics"] == "GENERIC_OVER_QQ_FIELD", "Wrong field semantics")
    system = output["system"]
    require(system["matrix"]["variables"] == VARIABLES, "Wrong matrix variables")
    for source_row, returned_row in zip(payload["matrix"]["entries"], system["matrix"]["entries"]):
        require(len(source_row) == len(returned_row) == 2, "Wrong matrix shape")
        for source, returned in zip(source_row, returned_row):
            require(equal_rational(rational_function(source), rational_function(returned)),
                    "Returned matrix differs from the submitted system")
    require(len(system["matrix"]["entries"]) == 2, "Wrong row count")
    require(len(system["rhs"]) == 2, "Wrong right-hand side shape")
    for source, returned in zip(payload["rhs"], system["rhs"]):
        require(equal_rational(rational_function(source), rational_function(returned)),
                "Returned right-hand side differs from the submitted system")

    a, b, e, f, u = (variable(name) for name in VARIABLES)
    determinant = add(multiply(a, b), scale(multiply(e, f), -1))
    numerators = [
        add(b, scale(multiply(e, u), -1)),
        add(multiply(a, u), scale(f, -1)),
    ]
    require(len(output["solution"]) == 2, "Wrong solution dimension")
    for value, numerator in zip(output["solution"], numerators):
        require(equal_rational(rational_function(value), (numerator, determinant)),
                "Jacobian solution fails independent polynomial replay")
    require(add(multiply(a, numerators[0]), multiply(e, numerators[1])) == determinant,
            "First inverse-action equation failed")
    require(add(multiply(f, numerators[0]), multiply(b, numerators[1]))
            == multiply(determinant, u), "Second inverse-action equation failed")
    force_numerator = add(
        multiply(b, numerators[1]), scale(multiply(multiply(a, u), numerators[0]), -1)
    )
    expected_force = add(multiply(multiply(a, e), multiply(u, u)),
                         scale(multiply(b, f), -1))
    require(force_numerator == expected_force, "Projective normalization identity failed")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_exit_status": status["adapter_exit_status"],
        "typed_classification": output["classification"],
        "replay": "Exact polynomial cross-multiplication over QQ[a,b,e,f,u]",
        "solution": ["(b-e*u)/(a*b-e*f)", "(a*u-f)/(a*b-e*f)"],
        "projective_force": "(a*e*u^2-b*f)/(b*(b-e*u))",
        "real_specialization_conditions": ["a*b-e*f != 0", "b != 0", "b-e*u != 0"],
        "no_conclusion_at_singular_specializations": True,
    }


def check_expanded_force():
    alpha = [variable(f"alpha{i}") for i in range(3)]
    error = [[variable(f"E{i}{j}") for j in range(3)] for i in range(3)]
    u = [None, variable("u1"), variable("u2")]
    low_error = add(error[0][0], *(multiply(error[0][l], u[l]) for l in [1, 2]))
    denominator = add(alpha[0], low_error)
    for h in [1, 2]:
        high_error = add(error[h][0], *(multiply(error[h][l], u[l]) for l in [1, 2]))
        image = add(multiply(alpha[h], u[h]), high_error)
        actual = add(multiply(alpha[0], image),
                     scale(multiply(multiply(alpha[h], u[h]), denominator), -1))
        claimed = add(multiply(alpha[0], high_error),
                      scale(multiply(multiply(alpha[h], u[h]), low_error), -1))
        require(actual == claimed, "Expanded projective force has the wrong sign or indices")
    return {
        "identity": "n:eq-expanded-force after clearing alpha_i times the denominator",
        "generic_dimension_checked": 3,
        "rows_checked": [1, 2],
        "all_finite_dimensions": "The normalized-line equivalence, not this finite instance, is proved in Lean.",
    }


def propagate(ratios, force, cut):
    end = len(force)
    forward = [Fraction(0)]
    for j in range(cut):
        forward.append(ratios[j] * forward[-1] + force[j])
    backward = [Fraction(0)] * (end + 1)
    for j in range(end - 1, cut - 1, -1):
        backward[j] = (backward[j + 1] - force[j]) / ratios[j]
    weights_left = [prod(ratios[j + 1:cut], start=Fraction(1)) for j in range(cut)]
    weights_right = [
        prod((1 / ratios[l] for l in range(cut, j + 1)), start=Fraction(1))
        for j in range(cut, end)
    ]
    require(all(w > 0 for w in weights_left + weights_right), "Nonpositive stable weight")
    weighted = sum((force[j] * weights_left[j] for j in range(cut)), Fraction(0))
    weighted += sum((force[j] * weights_right[j - cut] for j in range(cut, end)),
                    Fraction(0))
    require(forward[-1] - backward[cut] == weighted, "Backward minus sign or cut index is wrong")
    return forward, backward, weighted


def check_cuts():
    cases = []
    for crossing in [Fraction(14, 3), Fraction(5)]:
        cut, end = ceil(crossing), 11
        ratios = [1 + (Fraction(j) - crossing) / 32 for j in range(end)]
        require(all(0 < ratios[j] < 1 for j in range(cut)), "Pre-crossing ratio changed side")
        require(all(ratios[j] >= 1 for j in range(cut, end)), "Post-crossing ratio changed side")
        base = [Fraction((-1) ** j * (j + 1), 1024) for j in range(end)]
        direction = [Fraction(1, 16)] * end
        _, _, d0 = propagate(ratios, base, cut)
        _, _, d1 = propagate(ratios, direction, cut)
        require(d0 + d1 > 0 and d0 - d1 < 0, "Endpoint mismatch signs failed")
        control = -d0 / d1
        require(-1 < control < 1, "The exact matching control is outside its box")
        force = [base[j] + control * direction[j] for j in range(end)]
        forward, backward, mismatch = propagate(ratios, force, cut)
        require(mismatch == 0, "Exact mismatch did not vanish")
        column = forward + backward[cut + 1:]
        require(all(column[j + 1] == ratios[j] * column[j] + force[j]
                    for j in range(end)), "A crossing-straddling recurrence failed")
        reversed_ratios = [1 / r for r in ratios]
        reversed_force = [-v / 3 for v in force]
        reversed_column = [Fraction(0)] * (end + 1)
        for j in range(cut - 1, -1, -1):
            reversed_column[j] = (reversed_column[j + 1] - reversed_force[j]) / reversed_ratios[j]
        for j in range(cut, end):
            reversed_column[j + 1] = reversed_ratios[j] * reversed_column[j] + reversed_force[j]
        require(all(reversed_column[j + 1] == reversed_ratios[j] * reversed_column[j]
                    + reversed_force[j] for j in range(end)),
                "Reversed ordering needs an incorrect additional matching condition")
        cases.append({
            "crossing_time": str(crossing),
            "ceiling_cut": cut,
            "neutral_step": ratios[cut] == 1,
            "exact_control": str(control),
            "exact_mismatch": str(mismatch),
            "recurrences_verified_in_both_orderings": 2 * end,
        })
    return cases


def check_parameter_box(order):
    rho = (Fraction(3, 5), Fraction(9, 10))
    require(order in [1, 3], "No advertised interval box for this crossing order")
    threshold = Fraction(order, order + 1)
    if order == 1:
        q = (Fraction(2, 3), Fraction(5, 6))
        beta = (Fraction(1, 24), Fraction(1, 8))
        example = {"rho": Fraction(3, 4), "q": Fraction(3, 4), "beta": Fraction(1, 8)}
    else:
        q = (Fraction(5, 6), Fraction(11, 12))
        beta = (Fraction(1, 48), Fraction(1, 16))
        example = {"rho": Fraction(3, 4), "q": Fraction(7, 8), "beta": Fraction(1, 32)}
    margins = {
        "rho_above_half": rho[0] - Fraction(1, 2),
        "rho_below_one": 1 - rho[1],
        "q_above_crossing_threshold": q[0] - threshold,
        "q_below_one": 1 - q[1],
        "positive_box_exponent": beta[0],
        "trial_inside_box": q[0] - threshold - beta[1],
    }
    growth_upper = {
        "phase": rho[1],
        "radial": 2 - 2 * rho[0],
        "control": 1 - rho[0] * q[0],
        "mesh": 1 - rho[0],
    }
    require(all(m > 0 for m in margins.values()), "Parameter box meets a forbidden boundary")
    require(all(0 < e < 1 for e in growth_upper.values()), "A growth error is not sublinear")
    require(example["q"] - threshold - example["beta"] > 0,
            "Example exponents do not lie in the proved region")
    require(order - (order + 1) * threshold == 0, "Incorrect effective Green scale")
    return {
        "maximal_odd_crossing_order": order,
        "green_length_exponent": str(threshold),
        "rho_interval": list(map(str, rho)),
        "q_interval": list(map(str, q)),
        "beta_interval": list(map(str, beta)),
        "strict_lower_margins": {k: str(v) for k, v in margins.items()},
        "growth_error_upper_exponents": {k: str(v) for k, v in growth_upper.items()},
        "method": "Exact rational interval bounds using positivity and coordinate monotonicity",
        "example_point": {k: str(v) for k, v in example.items()},
        "example_is_manuscript_choice": order == 1,
    }


def check_lean():
    result = json.loads((HERE / "lean_check.json").read_text())
    run = json.loads((HERE / "lean_run.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean compilation failed")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0, "Lean has proof holes")
    version = result["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "The required Lean version was not used")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"], "Stale Lean source")
    require(hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"],
            "Stale statement-fidelity reading")
    record = run["kernel"]["recorded"]
    require(record is not None and run["kernel"]["refusals"] == [], "Lean evidence was not recorded")
    require(record["subject"]["subject_id"] == "C_CM_FORMAL_CORE", "Wrong formal claim")
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "Wrong evidence type")
    require(all(run[k] == v for k, v in result.items()), "Recorded run differs from compiler result")
    relative = Path(record["artifact"])
    require(relative.parent == Path("research/crossing_matching/certificates"), "Wrong archive directory")
    certificate = json.loads((HERE / "certificates" / relative.name).read_text())
    require(certificate["lean_check"] == result, "Archive differs from the real compiler result")
    require(certificate["lean_source"]["text"].encode() == source, "Archive has different source")
    require(certificate["statement_fidelity"]["text"] == fidelity, "Archive has a different reading")
    return {
        "claim": "C_CM_FORMAL_CORE",
        "compiler_version": version,
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "axiom_audit_exit_code": result["audit_exit_code"],
        "certificate": str(relative),
        "finite_solvability_is_an_explicit_hypothesis": True,
        "full_analytic_theorem_is_not_kernel_checked": True,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = {
        "schema_version": 1,
        "claims": ["C_CM_UNIFORM", "C_CM_ODD"],
        "result_class": "parameter_uniform_verification_theorem",
        "jacobian": check_jacobian(),
        "expanded_force": check_expanded_force(),
        "finite_cut_experiments": check_cuts(),
        "exact_parameter_boxes": [check_parameter_box(order) for order in [1, 3]],
        "formal_core": check_lean(),
        "infinite_analytic_proof": "theorem.md, Proofs 1-4 and odd-order extension; requires independent mathematical review",
        "not_certified": [
            "existence of the angular program",
            "Ricci curvature and the radial construction",
            "the manuscript's main theorem or its Berger construction",
            "novelty, publishable significance, or independent Reviewer acceptance",
        ],
        "manuscript_refutation_claimed": False,
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "Exact certificate differs from replay")
    print(json.dumps({
        "ok": True,
        "exact_algebra": True,
        "crossing_cut_cases": len(certificate["finite_cut_experiments"]),
        "lean_exit_code": certificate["formal_core"]["exit_code"],
        "proof_holes": certificate["formal_core"]["proof_holes"],
        "analytic_proof_review": "pending independent Reviewer",
    }))


if __name__ == "__main__":
    main()
