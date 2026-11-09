#!/usr/bin/env python3
"""Replay the exact algebraic components of the accompanying analytic proof.

Requires SymPy. This is not a formalization of the analytic hypotheses or
Holder's inequality; the certificate explicitly preserves that distinction.
"""

import hashlib
import json
from collections import deque
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def verify_principal_linearization():
    h = sp.Symbol("h")
    a, b, c, d, r, s, t = sp.symbols("a b c d r s t")
    entries = sp.symbols("e00 e01 e02 e03 e11 e12 e13 e22 e23 e33")
    e00, e01, e02, e03, e11, e12, e13, e22, e23, e33 = entries
    error = sp.Matrix([
        [e00, e01, e02, e03],
        [e01, e11, e12, e13],
        [e02, e12, e22, e23],
        [e03, e13, e23, e33],
    ])
    columns = sp.Matrix([[a, b], [c, d], [r, s], [s, t]])
    select = sp.Matrix([[0, 0], [0, 0], [1, 0], [0, 1]])
    swap = sp.Matrix([[0, 1], [1, 0]])
    huu, huv, hvv = sp.symbols("huu huv hvv")
    middle = sp.Matrix([[huu, huv], [huv, hvv]])
    actual_map = sp.eye(4) - columns * middle * select.T
    actual_increment = actual_map * error * actual_map.T - error
    for sign in (-1, 1):
        linear_map = sp.eye(4) + sign * h * columns * swap * select.T
        increment = linear_map * error * linear_map.T - error
        expected_pair = (
            sign * h * (a * e13 + b * e12 + c * e03 + d * e02)
            + h**2 * (a * c * e33 + a * d * e23 + b * c * e23 + b * d * e22)
        )
        expected_diagonal = (
            2 * sign * h * (a * e03 + b * e02)
            + h**2 * (a**2 * e33 + 2 * a * b * e23 + b**2 * e22)
        )
        require(sp.expand(increment[0, 1] - expected_pair) == 0,
                "The generic pair linearization has an incorrect coefficient.")
        require(sp.expand(increment[0, 0] - expected_diagonal) == 0,
                "The diagonal linearization has an incorrect coefficient.")
        coefficient_error = middle + sign * h * swap
        one_axis_remainder = (
            -columns * coefficient_error * select.T * error
            -error * select * coefficient_error * columns.T
        )
        compressed_error = select.T * error * select
        two_axis_remainder = columns * (
            middle * compressed_error * middle - h**2 * swap * compressed_error * swap
        ) * columns.T
        for i, j in ((0, 0), (0, 1)):
            require(sp.expand(actual_increment[i, j] - increment[i, j]
                              - one_axis_remainder[i, j] - two_axis_remainder[i, j]) == 0,
                    "The claimed remainder classification omits a linear term.")
    for outer in range(2):
        for other_outer in range(2):
            coefficient = (
                middle[outer, outer] * middle[outer, other_outer]
                - h**2 * swap[outer, outer] * swap[outer, other_outer]
            )
            require(sp.expand(coefficient - middle[outer, outer] * middle[outer, other_outer]) == 0,
                    "A same-end diagonal input lacks the required diagonal middle factor.")
    require(len(sp.Poly(expected_pair, h, a, b, c, d, *entries).terms()) == 8,
            "The principal pair update must have exactly eight monomials.")
    return {
        "signs": [-1, 1],
        "generic_pair_monomials": 8,
        "remainder_one_axis_forms": 8,
        "remainder_two_axis_forms": 16,
        "principal_and_remainder_identities": 8,
        "same_end_diagonal_coefficient_identities": 4,
    }


def verify_interpolation_comparisons():
    p, t = sp.symbols("p t")
    order_excess, gap_excess = sp.symbols("order_excess gap_excess")
    exponent_gap = sp.cancel(t / p - (t - 2) / (p - 2))
    require(sp.cancel(exponent_gap - 2 * (p - t) / (p * (p - 2))) == 0,
            "The p-moment interpolation exponent is too large.")
    saving_numerator = 2 * p * (p - t) - (p - 2)
    positive = sp.Poly(sp.expand(saving_numerator.subs(t, p - 1 - gap_excess)
                               .subs(p, 4 + order_excess)), order_excess, gap_excess)
    require(all(coefficient >= 0 for coefficient in positive.coeffs()),
            "The interpolation saving is not positive for every p >= 4, t <= p-1.")
    require(positive.coeff_monomial(1) > 0, "The interpolation saving must be strict.")
    require(sp.cancel(1 - (p - 1) / (2 * p) - sp.Rational(1, 2)) == 1 / (2 * p),
            "The Young principal coefficient is not uniformly bounded by two.")
    return {
        "p_moment_exponent_gap": str(exponent_gap),
        "saving_numerator_at_p_equals_4_plus_order_excess": str(positive.as_expr()),
        "scope": "all p >= 4 and integer 1 <= t < p; the t <= 2 case uses the second moment directly",
    }


def word_successors(state):
    endpoint, mask, errors, length, _exception = state
    yield (1 - endpoint, mask | (1 << endpoint), errors, min(2, length + 1), False)
    if errors == 0:
        for destination in (0, 1):
            exception = length == 0 and endpoint == 1 and destination == 1
            yield (1 - destination, mask, 1, min(2, length + 1), exception)


def verify_word_automaton(certificate):
    initial = (1, 0, 0, 0, False)
    reached = {initial}
    pending = deque([initial])
    while pending:
        state = pending.popleft()
        for successor in word_successors(state):
            if successor not in reached:
                reached.add(successor)
                pending.append(successor)
    require(len(reached) <= certificate["word_classification"]["state_space_upper_bound"],
            "The declared finite state space is too small.")
    transitions = 0
    for state in reached:
        endpoint, mask, errors, length, exception = state
        if length == 0:
            require(state == initial, "A noninitial zero-length state was reached.")
        elif endpoint == 0 and not (mask & 2):
            require(errors == 1 and length == 1 and exception,
                    "A same-end word escaped the opposite-local-factor classification.")
        if length > 0 and endpoint == 1 and mask and errors == 0:
            require(mask == 3,
                    "A distinct-end topology-only word failed to visit both endpoints.")
        for successor in word_successors(state):
            require(successor in reached, "The claimed reachable set is not transition-closed.")
            transitions += 1
    require(certificate["word_classification"]["not_a_length_cutoff_experiment"],
            "The certificate must not reinterpret closure as a length cutoff.")
    return {
        "reachable_states": len(reached),
        "transitions": transitions,
        "proof": "initial membership, transition closure, and invariant on every reachable state",
        "word_length_bound": None,
    }


def verify_weighted_closure():
    A, l, T, F, D, v = sp.symbols("A l T F D v")
    kappa = 1 / (1 + T)
    budget = T / (kappa * l**2) + (1 + kappa) * v / kappa
    raw_upper = (
        1 + (1 + A / l) * F + T * D / l**2
        + kappa * ((1 + A / l) * D + T * F / l)
        + (1 + kappa) * v * (1 + F + D)
    )
    target = (1 + (A + 1) / l + budget) * (1 + F + kappa * D)
    displayed_gap = (
        (A + 1) / l + T / (kappa * l**2)
        + (1 + kappa) * (1 / kappa - 1) * v
        + F * ((1 - kappa * T) / l + T / (kappa * l**2)
               + (1 + kappa) * (1 / kappa - 1) * v)
        + kappa * D / l
    )
    require(sp.cancel(target - raw_upper - displayed_gap) == 0,
            "The weighted absorption identity is false.")
    numerator = sp.cancel((target - raw_upper) * l**2 * (1 + T))
    poly = sp.Poly(numerator, A, l, T, F, D, v)
    require(all(coefficient >= 0 for coefficient in poly.coeffs()),
            "The absorption numerator must have nonnegative coefficients.")
    require(sp.cancel(1 - kappa * T - kappa) == 0, "The fixed weight was changed.")

    shift = sp.Symbol("shift")
    denominator_gap = sp.expand(((l + 16) * (l - 2)**2 - l**3).subs(l, shift + 4))
    require(all(coefficient >= 0 for coefficient in sp.Poly(denominator_gap, shift).coeffs()),
            "The denominator bound is not certified for every l >= 4.")
    H = sp.Symbol("H")
    spare = sp.Poly(sp.expand((64 + 8192 * H) - (16 + 4096 * H + 1 + 1)), H)
    require(all(coefficient >= 0 for coefficient in spare.coeffs()),
            "The stated uniform coefficient is too small.")
    return {
        "absorption_numerator_monomials": len(poly.terms()),
        "denominator_gap_at_l_equals_4_plus_shift": str(denominator_gap),
        "scope": "all A,T,F,D,v >= 0 and l > 0; denominator change requires l >= 4",
    }


def verify_constant_envelope(certificate):
    constants = certificate["constants"]
    require(constants["maximum_principal_young_splittings"] == 6,
            "The principal splitting count changed.")
    require(constants["maximum_linear_monomials"] == 32, "The monomial envelope changed.")
    t_vector = {"2": 320, "p": 64, "d": 8, "H": 8}
    q_vector = {"2": 80, "p": 32, "d": 8, "H": 8}
    difference = {base: t_vector[base] - q_vector[base] for base in t_vector}
    require(difference == constants["T_over_Q_exponent_vector_per_p"],
            "T_p no longer dominates Q_p by the stated exponent vector.")
    require(all(value >= 0 for value in difference.values()),
            "The uniform finite-splitting envelope is invalid.")
    return {"T_over_Q_exponent_vector_per_p": difference}


def verify_budget_exponents(certificate):
    a, eta = sp.symbols("a eta")
    l0 = sp.Rational(2, 3) + sp.Rational(3, 20) * a
    alpha = -sp.Rational(1, 3) + a / 2
    B = sp.Rational(31, 100) * a - l0 / 2
    dm = sp.Rational(33, 100) * a - l0 / 2
    path = l0 / 2 - sp.Rational(29, 100) * a
    vstar = a / 8
    forbidden = a / 500
    expressions = {
        "mean_trace": vstar - alpha - l0 - B,
        "mean_path": eta + path - l0 - B,
        "mean_forbidden": forbidden - l0 - B,
        "mean_l_three_halves": eta - l0 / 2 - B,
        "mean_nonlinear": 2 * dm - B,
        "residual_second": eta - l0 - 2 * B,
        "residual_nonlinear": 4 * dm - 2 * B,
        "residual_sup_tail": sp.Rational(30, 100) * a - l0 / 2 - B,
        "residual_sup_nonlinear": 2 * dm - B,
        "residual_sup_centering": dm - l0 - B,
        "reverse_leakage": -l0,
    }
    recorded = certificate["budget_exponents"]
    require(set(expressions) == set(recorded), "The exponent certificate omitted a budget.")
    evaluated = {}
    for name, expression in expressions.items():
        entry = recorded[name]
        expected = (
            sp.Rational(entry["eta_coefficient"]) * eta
            + sp.Rational(entry["constant"])
            + sp.Rational(entry["a_coefficient"]) * a
        )
        require(sp.expand(expression - expected) == 0, f"Incorrect exponent for {name}.")
        worst_case = sp.simplify(expression.subs(eta, a / 100).subs(a, sp.Rational(1, 10000)))
        require(worst_case < 0, f"The {name} budget is not power-small.")
        evaluated[name] = str(worst_case)
    return {"exact_worst_case_exponents_at_eta_equals_a_over_100": evaluated}


def verify_second_moment_normalization(certificate):
    a, eta = sp.symbols("a eta")
    l0 = sp.Rational(2, 3) + sp.Rational(3, 20) * a
    alpha = -sp.Rational(1, 3) + a / 2
    B = sp.Rational(31, 100) * a - l0 / 2
    expressions = {
        "stub_row": -l0 - 2 * B,
        "global_resolvent_row": -alpha - 1 - 2 * B,
        "global_path_row": -1 - 2 * B,
        "diagonal_and_near": eta - l0 - 2 * B,
    }
    recorded = certificate["normalization_exponents"]
    require(set(recorded) == set(expressions), "A second-moment normalization is missing.")
    margins = {}
    for name, expression in expressions.items():
        entry = recorded[name]
        expected = (
            sp.Rational(entry["eta_coefficient"]) * eta
            + sp.Rational(entry["constant"])
            + sp.Rational(entry["a_coefficient"]) * a
        )
        require(sp.expand(expression - expected) == 0, f"Incorrect normalization for {name}.")
        margin = sp.simplify((expression + a / 4).subs(eta, a / 100)
                             .subs(a, sp.Rational(1, 10000)))
        require(margin < 0, f"The {name} average does not have the claimed beta margin.")
        margins[name] = str(margin)
    return {"beta": "a/4", "worst_case_exponent_after_adding_beta": margins}


def rational_function(value, variables):
    def polynomial(data):
        result = sp.Integer(0)
        for term in data["terms"]:
            coefficient = term["coefficient"]
            require(len(term["exponents"]) == len(variables), "Incorrect typed exponent axis.")
            monomial = sp.Rational(coefficient["num"], coefficient["den"])
            for variable, exponent in zip(variables, term["exponents"]):
                require(isinstance(exponent, int) and exponent >= 0, "Invalid polynomial exponent.")
                monomial *= variable**exponent
            result += monomial
        return result

    require(value["domain"] == "QQ", "Jacobian returned a different coefficient domain.")
    denominator = polynomial(value["denominator"])
    require(denominator != 0, "Jacobian returned a zero rational-function denominator.")
    return sp.cancel(polynomial(value["numerator"]) / denominator)


def verify_jacobian(certificate):
    record = certificate["jacobian"]
    payload = json.loads((HERE / record["payload"]).read_text())
    response = json.loads((HERE / record["typed_response"]).read_text())
    status = json.loads((HERE / record["adapter_status"]).read_text())
    require(status["adapter_exit_code"] == 0, "The adapter did not complete successfully.")
    require(response["protocol_version"] == record["protocol_version"], "Unexpected protocol.")
    require(response["server"]["version"] == record["server_version"], "Unexpected server version.")
    require(response["request"]["operation_id"] == record["operation_id"], "Wrong operation.")
    require(response["request"]["payload"] == payload, "The exact executed payload differs.")
    require(response["result"]["operation_id"] == record["operation_id"], "Wrong result operation.")
    output = response["result"]["output"]
    require(output["degree"] == 2, "Incomplete or wrong-degree characteristic polynomial.")
    require(output["convention"] == "DET_LAMBDA_I_MINUS_A", "Wrong characteristic convention.")
    require(len(output["coefficients_descending"]) == 3, "Incomplete coefficient list.")
    T, x = sp.symbols("T x")
    variables = [T, x]
    decoded = []
    for item in output["coefficients_descending"]:
        require(item["variables"] == ["T", "x"], "Jacobian changed the symbolic variable axis.")
        decoded.append(rational_function(item, variables))
    expected = [sp.Integer(1), sp.Integer(0), -T**2 * x]
    require(all(sp.expand(actual - wanted) == 0 for actual, wanted in zip(decoded, expected)),
            "Jacobian did not return lambda^2 - T^2*x.")
    return {
        "operation_id": record["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "timed_out": False,
        "coefficients": [str(value) for value in decoded],
    }


def verify_source_links(certificate):
    sections = ROOT / "research/openai_manuscript" / certificate["source_release"] / "build/sections"
    grouped = {}
    for item in certificate["source_inputs"] + [certificate["target"]]:
        grouped.setdefault(item["file"], []).extend(item["labels"])
    count = 0
    for filename, labels in grouped.items():
        text = (sections / filename).read_text()
        for label in labels:
            require("\\label{" + label + "}" in text, f"Source locator {label} is missing.")
            count += 1
    return {"checked_source_locators": count, "source_release": certificate["source_release"]}


def verify_lean(certificate):
    formal = certificate["evidence"]["compiler_proof"]
    source = HERE / formal["source"]
    fidelity = HERE / formal["statement_fidelity"]
    result = json.loads((HERE / formal["result"]).read_text())
    recording_result = json.loads((HERE / formal["recording_result"]).read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The committed Lean source has not compiled successfully.")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "The formal source has proof holes or an incomplete axiom audit.")
    require(result["environment_failure"] == "", "The formal environment was not verified.")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "The formal theorem was not checked with Lean 4.31.0.")
    require(Path(result["source"]).resolve() == source.resolve(), "Wrong compiled source.")
    require(result["source_sha256"] == hashlib.sha256(source.read_bytes()).hexdigest(),
            "The Lean source changed after compilation.")
    fidelity_text = fidelity.read_text()
    require(result["statement_fidelity_sha256"]
            == hashlib.sha256(fidelity_text.encode()).hexdigest(),
            "The statement-fidelity document changed after compilation.")
    recorded = recording_result["kernel"]["recorded"]
    require(isinstance(recorded, dict), "The compiler outcome was not recorded on the claim.")
    require(recorded["verdict"] == "supports" and recorded["tier"] == "mechanical",
            "The claim lacks supporting mechanical evidence.")
    require(recorded["subject"]["subject_id"] == formal["claim_id"], "Wrong formal claim.")
    archive_path = ROOT / recorded["artifact"]
    require(archive_path.parent == HERE / "certificates",
            "The formal archive escaped the owned audit directory.")
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"] == result, "The archived compile result differs.")
    require(archive["lean_source"]["text"] == source.read_text(), "The archive has other Lean text.")
    require(archive["statement_fidelity"]["text"] == fidelity_text, "The archive has other fidelity text.")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    versions = [claim for claim in ledger["claims"] if claim["claim_id"] == formal["claim_id"]]
    require(bool(versions), "The formal claim is missing from the campaign ledger.")
    current_claim = max(versions, key=lambda claim: claim["version"])
    require(recorded["subject"]["content_hash"] == current_claim["content_hash"],
            "The mechanical evidence belongs to a superseded claim.")
    return {
        "claim_id": formal["claim_id"],
        "declaration": "HighMomentAudit.weighted_drift",
        "lean_version": result["tools"]["lean"]["version"],
        "compiler_exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "archive": recorded["artifact"],
        "scope": formal["scope"],
        "human_statement_fidelity_review": "still required",
    }


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim_id"] == "C_HM_UNIFORM", "Wrong theorem claim.")
    require(certificate["result_kind"] == "conditional_verification_theorem",
            "The certificate must preserve the conditional analytic scope.")
    require(certificate["novelty"] == "not_certified", "Arithmetic replay cannot certify novelty.")
    results = {
        "principal_linearization": verify_principal_linearization(),
        "interpolation_comparisons": verify_interpolation_comparisons(),
        "word_automaton": verify_word_automaton(certificate),
        "weighted_closure": verify_weighted_closure(),
        "constant_envelope": verify_constant_envelope(certificate),
        "budgets": verify_budget_exponents(certificate),
        "second_moment_normalizations": verify_second_moment_normalization(certificate),
        "jacobian": verify_jacobian(certificate),
        "lean_scalar_absorption": verify_lean(certificate),
        "source_links": verify_source_links(certificate),
    }
    h = Fraction(7, 10)
    require(2 * h * h < 1 and 2 * h > 1, "The degree-three amplification diagnostic changed.")
    results["degree_three_diagnostic"] = {
        "h": str(h),
        "two_h": str(2 * h),
        "claim": "The one-axis diagonal channel can have an order-dependent coefficient.",
        "not_a_realizable_manuscript_counterexample": True,
    }
    print(json.dumps({
        "ok": True,
        "claim_id": certificate["claim_id"],
        "scope": "Exact algebra and induction components of proof.md, not the upstream analytic inputs.",
        "independent_review": certificate["independent_review"],
        "results": results,
    }, indent=2))


if __name__ == "__main__":
    main()
