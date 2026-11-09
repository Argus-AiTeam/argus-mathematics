#!/usr/bin/env python3
"""Replay exact algebra and finite regressions; inspect real Lean evidence."""

import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def threshold(alpha, u, delta):
    if not (alpha > 0 and u > 0 and 0 <= delta < u):
        raise ValueError("Threshold requires alpha>0 and 0<=delta<u.")
    return alpha * u / (u - delta)


def symbolic_identities():
    a, u, delta, theta, r, q, m, c = sp.symbols("a u delta theta r q m c")
    identities = [
        a / (1 - delta / u) - a * u / (u - delta),
        (1 - delta / theta) * r - q - ((r - q) * theta - r * delta) / theta,
        theta * c - (theta - delta) * m - (delta * m - theta * (m - c)),
        a * (r - q) / (r - q - r * delta)
        - (a * u / (u - delta)).subs(u, 1 - q / r),
    ]
    w1, w2, beta1, beta2, beta3, v = sp.symbols("w1 w2 beta1 beta2 beta3 v")
    weights = [w1, w2, 1 - w1 - w2]
    betas = [beta1, beta2, beta3]
    identities.append(
        sum(w * (1 - beta) * v for w, beta in zip(weights, betas))
        - (1 - sum(w * beta for w, beta in zip(weights, betas))) * v
    )
    for index, identity in enumerate(identities):
        check(sp.cancel(identity) == 0, f"Symbolic identity {index} failed.")
    return len(identities)


def finite_bad_mass_cases():
    cases = 0
    packing_cases = 0
    for j in range(1, 4):
        weight_sets = [tuple(Fraction(1, j) for _ in range(j))]
        weight_sets += [
            tuple(Fraction(int(h == active)) for h in range(j)) for active in range(j)
        ]
        if j == 3:
            weight_sets.append((Fraction(1, 2), Fraction(1, 3), Fraction(1, 6)))
        for size in range(5):
            for entries in itertools.product((0, 1), repeat=j * size):
                rows = [entries[h * size : (h + 1) * size] for h in range(j)]
                delta = Fraction(max(map(sum, rows)), size) if size else Fraction(0)
                for weights in weight_sets:
                    check(sum(weights) == 1, "Invalid test probability weights.")
                    masses = [
                        sum(weights[h] * rows[h][e] for h in range(j))
                        for e in range(size)
                    ]
                    check(sum(masses) <= delta * size, "Weighted total-mass bound failed.")
                    for theta in (Fraction(1, 4), Fraction(1, 2), Fraction(3, 4)):
                        kept = sum(mass <= theta for mass in masses)
                        check(
                            theta * (size - kept) <= delta * size,
                            "Markov retention failed.",
                        )
                        for r in range(2, 6):
                            for q in range(1, r):
                                if delta * r > theta * (r - q):
                                    continue
                                for d in range(size // r + 1):
                                    check(kept >= q * d, "Packing-slack implication failed.")
                                    packing_cases += 1
                        cases += 1
    return cases, packing_cases


def dyadic_cases():
    cases = 0
    for exponent in range(13):
        upper_sum = sum(2 ** (j + 1) for j in range(exponent + 1))
        check(upper_sum == 4 * 2**exponent - 2, "Dyadic identity failed.")
        for selected in itertools.product((0, 1), repeat=exponent):
            sizes = [2**exponent]
            sizes += [
                2 ** (j + 1) - 1
                for j, include in enumerate(selected)
                if include
            ]
            check(sum(sizes) < 4 * sizes[0], "Dyadic tail bound failed.")
            cases += 1
    return cases


def psd(matrix):
    if matrix != matrix.T:
        return False
    return all(
        matrix.extract(indices, indices).det() >= 0
        for size in range(1, matrix.rows + 1)
        for indices in itertools.combinations(range(matrix.rows), size)
    )


def resistance(matrix, column):
    return (column.T * matrix.inv() * column)[0]


def matrix_cases():
    columns = [
        sp.Matrix([1, -1, 0]),
        sp.Matrix([0, 1, -1]),
        sp.Matrix([1, 0, -1]),
        sp.Matrix([1, -1, 0]),
        sp.zeros(3, 1),
    ]
    responses = [
        sp.diag(1, 2, 4),
        sp.eye(3) + sp.Matrix([1, -1, 0]) * sp.Matrix([[1, -1, 0]]),
        sp.diag(4, 2, 1),
    ]
    weights_list = [
        (sp.Rational(1, 3),) * 3,
        (sp.Rational(1, 2), sp.Rational(1, 2), sp.Rational(0)),
        (sp.Rational(1), sp.Rational(0), sp.Rational(0)),
        (sp.Rational(1, 2), sp.Rational(1, 3), sp.Rational(1, 6)),
    ]
    response_costs = [
        [resistance(matrix, b) for b in columns] for matrix in responses
    ]
    cases = 0
    for weights in weights_list:
        mixture = sum((w * y for w, y in zip(weights, responses)), sp.zeros(3))
        check(mixture.is_positive_definite is True, "Mixture was not positive definite.")
        costs = [resistance(mixture, b) for b in columns]
        for a in map(sp.Rational, ["1/4", "1/2", "1", "2"]):
            for h, matrix in enumerate(responses):
                for e, b in enumerate(columns):
                    check(
                        (response_costs[h][e] <= a) == psd(a * matrix - b * b.T),
                        "Resistance/rank-one equivalence failed.",
                    )
            for theta in map(sp.Rational, ["1/4", "1/2", "3/4"]):
                for e, b in enumerate(columns):
                    mass = sum(
                        weights[h]
                        for h in range(3)
                        if a < response_costs[h][e]
                    )
                    check(
                        resistance(mixture, -b) == costs[e],
                        "Orientation invariance failed.",
                    )
                    if mass <= theta:
                        check(
                            costs[e] <= a / (1 - theta),
                            "Weighted rank-one resistance bound failed.",
                        )
                    cases += 1
    return cases


def replay_jacobian(certificate):
    data = certificate["jacobian"]
    request = json.loads((ROOT / data["request"]).read_text())
    result = json.loads((ROOT / data["typed_result"]).read_text())
    status = json.loads((ROOT / data["adapter_status"]).read_text())
    operation = data["operation_id"]
    check(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed.")
    check(status["operation_id"] == operation, "Jacobian adapter operation mismatch.")
    check(result["request"]["operation_id"] == operation, "Jacobian request operation mismatch.")
    check(result["request"]["payload"] == request, "Jacobian exact payload was not preserved.")
    check(result["result"]["operation_id"] == operation, "Jacobian result operation mismatch.")
    check(result["server"]["version"] == "0.14.0", "Unexpected recorded Jacobian server version.")
    check(result["protocol_version"] == "2025-11-25", "Unexpected recorded protocol version.")
    output = result["result"]["output"]
    check(output["convention"] == "TWO_SIDED_INVERSE_OVER_QQ", "Wrong inverse convention.")
    matrix = sp.Matrix(request["matrix"]["entries"])
    inverse = sp.Matrix(
        [
            [sp.Rational(entry["num"], entry["den"]) for entry in row]
            for row in output["inverse"]["entries"]
        ]
    )
    check(matrix * inverse == sp.eye(2), "Jacobian right-inverse replay failed.")
    check(inverse * matrix == sp.eye(2), "Jacobian left-inverse replay failed.")
    b = sp.Matrix([1, -1])
    check((2 * b.T * inverse * b)[0] == sp.Rational(4, 65), "Resistance replay failed.")
    return {"operation_id": operation, "adapter_exit_code": status["adapter_exit_code"]}


def sample_and_negative_control(certificate):
    sample = certificate["exact_sample"]
    r, q = int(sample["r"]), int(sample["q"])
    alpha, delta, u = (Fraction(sample[key]) for key in ("alpha", "delta", "u"))
    check(r == 8**16, "Sample r is not the stated exact sixteenth power.")
    check(q == (7 * r) // 8, "Sample packing count is not the literal floor.")
    check(u == 1 - Fraction(q, r), "Sample slack mismatch.")
    check(delta == Fraction(40, 8**4), "Sample response fraction mismatch.")
    check(alpha == Fraction(1, 8**8), "Sample resistance threshold mismatch.")
    endpoint = threshold(alpha, u, delta)
    check(endpoint == Fraction(sample["endpoint"]), "Sample endpoint mismatch.")
    check(endpoint / alpha == Fraction(sample["endpoint_over_alpha"]), "Sample ratio mismatch.")
    check(4 * alpha == Fraction(sample["manuscript_threshold"]), "Source threshold mismatch.")
    check(Fraction(4, 4 * r + 1) < endpoint, "Actual two-vertex graph sample failed.")
    for invalid in [(0, 1, 0), (1, 0, 0), (1, 1, -1), (1, 1, 1), (1, 1, 2)]:
        try:
            threshold(*map(Fraction, invalid))
        except ValueError:
            pass
        else:
            raise AssertionError("An excluded boundary was silently admitted.")
    negative = certificate["negative_control"]
    y1, y2 = sp.Matrix(negative["Y1"]), sp.Matrix(negative["Y2"])
    weights = list(map(sp.Rational, negative["weights"]))
    b = sp.Matrix(negative["incidence"])
    mixed = resistance(weights[0] * y1 + weights[1] * y2, b)
    averaged = weights[0] * resistance(y1, b) + weights[1] * resistance(y2, b)
    check(mixed == sp.Rational(negative["resistance_of_mixture"]), "Negative control mismatch.")
    check(averaged == sp.Rational(negative["mixture_of_resistances"]), "Negative control mismatch.")
    check(mixed != averaged, "Invalid average-of-inverses shortcut was not rejected.")
    return str(endpoint)


def lean_evidence(certificate):
    evidence = certificate["evidence"]
    result = json.loads((ROOT / evidence["compiler_result"]).read_text())
    archived = json.loads((ROOT / evidence["archived_kernel_certificate"]).read_text())
    check(result["status"] == "success", "Lean compilation did not succeed.")
    check(result["exit_code"] == 0, "Lean compiler exit code was not zero.")
    check(result["proof_holes"] == [], "Lean source contains proof holes.")
    source = (ROOT / evidence["lean_source"]).read_bytes()
    fidelity = (ROOT / evidence["statement_fidelity"]).read_text()
    check(
        result["source_sha256"] == hashlib.sha256(source).hexdigest(),
        "Lean source changed after the recorded compiler run.",
    )
    check(
        result["statement_fidelity_sha256"]
        == hashlib.sha256(fidelity.encode()).hexdigest(),
        "Statement fidelity changed after the recorded compiler run.",
    )
    check("4.31.0" in json.dumps(result["tools"]["lean"]), "Lean 4.31.0 was not recorded.")
    check(archived["tier"] == "mechanical", "The archived certificate is not mechanical.")
    check(archived["verdict"] == "supports", "The archived compiler did not support the claim.")
    check(
        archived["subject"]["subject_id"] == "C_TC_COMPACT_CORE",
        "The compiler certificate belongs to a different claim.",
    )
    check(
        archived["lean_source"]["text"].encode() == source,
        "The archived compiler certified a different source.",
    )
    check(
        archived["statement_fidelity"]["text"] == fidelity,
        "The archived compiler used a different fidelity document.",
    )
    check(
        archived["lean_check"]["source_sha256"] == result["source_sha256"]
        and archived["lean_check"]["statement_fidelity_sha256"]
        == result["statement_fidelity_sha256"],
        "The current and archived compiler bindings disagree.",
    )
    return {
        "exit_code": 0,
        "proof_holes": [],
        "scope": "C_TC_COMPACT_CORE, with explicit Brouwer and graph-interface hypotheses",
    }


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    check(certificate["schema_version"] == 1, "Unknown certificate schema.")
    check(
        certificate["threshold"]["response_quantifiers"]
        == "forall X in K, exists Y in K, forall s>0",
        "The simultaneous response quantifiers were weakened.",
    )
    check(certificate["threshold"]["inclusive_endpoint"] is True, "Endpoint was weakened.")
    check(
        certificate["application"]["full_thin_tree_theorem_certified"] is False,
        "The certificate overstates its full-theorem scope.",
    )
    identities = symbolic_identities()
    mass_cases, packing_cases = finite_bad_mass_cases()
    result = {
        "ok": True,
        "universal_proof": "proof.md, subject to independent mathematical review",
        "formal_scope": "Quantified compact consistency, conditional on explicit Brouwer and graph interfaces",
        "symbolic_identities": identities,
        "finite_bad_mass_cases": mass_cases,
        "finite_packing_implications": packing_cases,
        "finite_dyadic_cases": dyadic_cases(),
        "finite_matrix_cases": matrix_cases(),
        "exact_sample_endpoint": sample_and_negative_control(certificate),
        "jacobian": replay_jacobian(certificate),
        "lean": lean_evidence(certificate),
        "independent_review_complete": certificate["review"]["independent_review_complete"],
        "campaign_complete": certificate["review"]["campaign_complete"],
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
