#!/usr/bin/env python3
"""Replay exact universal algebra; check, but do not rerun, the Lean receipt."""

import hashlib
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


class Polynomial:
    def __init__(self, terms=None):
        self.terms = {
            word: Fraction(coefficient)
            for word, coefficient in (terms or {}).items()
            if coefficient
        }

    def __add__(self, other):
        terms = self.terms.copy()
        for word, coefficient in other.terms.items():
            terms[word] = terms.get(word, 0) + coefficient
        return Polynomial(terms)

    def __neg__(self):
        return Polynomial({word: -c for word, c in self.terms.items()})

    def __sub__(self, other):
        return self + -other

    def __mul__(self, other):
        terms = {}
        for left, a in self.terms.items():
            for right, b in other.terms.items():
                word = left + right
                terms[word] = terms.get(word, 0) + a * b
        return Polynomial(terms)

    def __eq__(self, other):
        return isinstance(other, Polynomial) and self.terms == other.terms


def scalar(value):
    return Polynomial({(): Fraction(value)})


def letter(name):
    return Polynomial({(name,): 1})


SELFADJOINT = {"H", "b", "K", "P"}


def adjoint(poly):
    def star_name(name):
        return name if name in SELFADJOINT else (
            name[:-1] if name.endswith("*") else name + "*"
        )

    return Polynomial({
        tuple(star_name(name) for name in reversed(word)): coefficient
        for word, coefficient in poly.terms.items()
    })


def reduce_words(poly, rules):
    pending = poly.terms.copy()
    result = {}
    steps = 0
    while pending:
        word = min(pending)
        coefficient = pending.pop(word)
        if not coefficient:
            continue
        replacement = None
        for pattern, value in rules:
            for index in range(len(word) - len(pattern) + 1):
                if word[index:index + len(pattern)] == pattern:
                    replacement = Polynomial({
                        word[:index] + middle + word[index + len(pattern):]: c
                        for middle, c in value.terms.items()
                    })
                    break
            if replacement is not None:
                break
        if replacement is None:
            result[word] = result.get(word, 0) + coefficient
        else:
            for new_word, c in replacement.terms.items():
                pending[new_word] = pending.get(new_word, 0) + coefficient * c
        steps += 1
        require(steps <= 100000, "Word reduction exceeded its explicit bound")
    return Polynomial(result)


def exact_algebra():
    one, zero = scalar(1), scalar(0)
    H, b, K, r1, r2 = map(letter, ["H", "b", "K", "r1", "r2"])
    s1, s2 = adjoint(r1), adjoint(r2)
    rules = [
        (("b", "b"), one - H * H),
        (("H", "r1"), r1),
        (("H", "r2"), r2),
        (("r1*", "H"), s1),
        (("r2*", "H"), s2),
        (("r1*", "r1"), H * H),
        (("r2*", "r2"), H * H),
        (("r1*", "r2"), zero),
        (("r2*", "r1"), zero),
        (("K", "H"), H),
        (("H", "K"), H),
        (("r1", "K"), r1),
        (("K", "r1*"), s1),
        (("K", "b"), b * K),
    ]
    checked = []

    def check(name, left, right=zero, active_rules=None):
        active = rules if active_rules is None else active_rules
        require(reduce_words(left - right, active) == zero, name)
        checked.append(name)

    for r, index in [(r1, "1"), (r2, "2")]:
        check("complement_star_square_" + index, adjoint(b * r) * (b * r))
        # This inference is the C*-identity, separately proved in Lean.
        rules.append((("b", "r" + index), zero))
        rules.append((("r" + index + "*", "b"), zero))

    v = r1 + b
    P = one - v * adjoint(v)
    check("isometry", adjoint(v) * v, one)
    check("orthogonal_second_column", adjoint(v) * r2)
    check("defect_selfadjoint", adjoint(P), P, [])
    check(
        "defect_idempotence_factorization",
        P * P - P,
        v * (adjoint(v) * v - one) * adjoint(v),
        [],
    )
    check("defect_idempotence", v * reduce_words(adjoint(v) * v - one, rules) * adjoint(v))
    check("defect_fixes_second_column", P * r2, r2)
    check("defect_expansion", P, H * H - r1 * s1 - r1 * b - b * s1)
    check(
        "left_cutoff_relation_certificate",
        K * r1 - r1,
        (K * H - H) * r1 - K * (H * r1 - r1) + (H * r1 - r1),
        [],
    )
    rules.append((("K", "r1"), r1))
    rules.append((("r1*", "K"), s1))
    check("left_cutoff_fixes_defect", K * P, P)
    check("right_cutoff_by_adjoint", P * K - P, adjoint(K * P - P), [])
    check(
        "two_sided_cutoff_certificate",
        K * P * K - P,
        (K * P - P) * K + adjoint(K * P - P),
        [],
    )

    t, S, X, inverse = map(letter, ["t", "S", "X", "inverse"])
    check(
        "graph_recovery",
        t * S * X * t * inverse,
        S,
        [
            (("t", "S"), S),
            (("X", "t"), X),
            (("S", "X", "inverse"), S),
        ],
    )
    require(r1 * r2 != r2 * r1, "Free algebra accidentally became commutative")
    require(
        reduce_words(v * adjoint(v) - one, rules) != zero,
        "The reverse isometry product was incorrectly forced to be one",
    )
    return checked


def rational_wire(value):
    q = Fraction(value)
    return {"num": str(q.numerator), "den": str(q.denominator)}


def rational_read(value):
    q = Fraction(int(value["num"]), int(value["den"]))
    require(value == rational_wire(q), "Noncanonical rational in adapter output")
    return q


def determinant(matrix):
    work = [row[:] for row in matrix]
    answer = Fraction(1)
    for column in range(len(work)):
        pivot = next((r for r in range(column, len(work)) if work[r][column]), None)
        if pivot is None:
            return Fraction(0)
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        diagonal = work[column][column]
        answer *= diagonal
        for row in range(column + 1, len(work)):
            ratio = work[row][column] / diagonal
            for j in range(column + 1, len(work)):
                work[row][j] -= ratio * work[column][j]
            work[row][column] = Fraction(0)
    return answer


def exact_jacobian(certificate):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    operation = certificate["jacobian"]["operation_id"]
    require(operation == "matrix.rational_linear_system.solve", "Wrong operation")
    require(envelope["tool"] == "math.run", "Not an operation execution receipt")
    require(envelope["request"] == {"operation_id": operation, "payload": payload},
            "Adapter request is not bound to the exact payload")
    require(envelope["result"]["operation_id"] == operation, "Wrong result operation")
    require(envelope["server"]["version"] == "0.14.0", "Unexpected server version")
    require(envelope["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require("error" not in envelope and "error" not in envelope["result"],
            "Adapter returned an error, not evidence")
    output = envelope["result"]["output"]
    require(output["outcome"] == "UNIQUE", "Adapter did not return a unique solution")
    require(output["convention"] == "LINEAR_SYSTEM_CLASSIFICATION_OVER_QQ",
            "Unexpected typed outcome convention")

    B3, B4, P = map(letter, ["B3", "B4", "P"])
    h = scalar("1/2")
    D = B3 * adjoint(B3)
    G1, G2, G3 = D * P - h * P, P * B4 - B4, adjoint(B3) * B4
    columns = [D * G2, G1 * B4, G2, B3 * G3]
    words = [
        ("B3", "B3*", "P", "B4"),
        ("B3", "B3*", "B4"),
        ("P", "B4"),
        ("B4",),
    ]
    require(
        all(set(poly.terms).issubset(words) for poly in columns),
        "Certificate omitted a noncommutative word",
    )
    matrix = [[poly.terms.get(word, Fraction(0)) for poly in columns] for word in words]
    rhs = [Fraction(0), Fraction(0), Fraction(0), Fraction(1, 2)]
    expected = {
        "matrix": {"domain": "QQ", "entries": [[rational_wire(c) for c in row]
                                              for row in matrix]},
        "rhs": [rational_wire(c) for c in rhs],
    }
    require(payload == expected, "Payload is not the stated free-word coefficient system")
    require(output["matrix"] == payload["matrix"] and output["rhs"] == payload["rhs"],
            "Typed result changed the source system")
    solution = [rational_read(q) for q in output["solution"]]
    require(solution == [Fraction(q) for q in certificate["jacobian"]["coefficients"]],
            "Unexpected exact coefficient vector")
    require(len(solution) == 4, "Wrong coefficient-vector length")
    require([sum(a * x for a, x in zip(row, solution)) for row in matrix] == rhs,
            "Independent rational residual is nonzero")
    require(determinant(matrix) == Fraction(certificate["jacobian"]["determinant"]) != 0,
            "Unique classification failed independent determinant check")
    identity = scalar(0)
    for coefficient, poly in zip(solution, columns):
        identity = identity + scalar(coefficient) * poly
    require(identity == h * B4, "The universal noncommutative certificate is false")
    bad = identity + scalar(2) * columns[1]
    require(bad != h * B4, "A flipped-sign negative control was not detected")
    return "exact coefficient system and free-word certificate"


def exact_thresholds(certificate):
    a0, a, beta, s, h, theta = map(Fraction, certificate["thresholds"])
    require(0 < a0 < a < beta < s and 0 < h < 1 and 0 < theta < 1,
            "A required strict spectral gap was lost")
    require([a0, a, beta, s, h, theta] ==
            list(map(Fraction, ["1/32", "1/16", "1/8", "1/4", "1/2", "1/2"])),
            "Thresholds do not instantiate the literal manuscript")
    gamma_squared, sigma_squared = Fraction(1, 4), Fraction(1, 20)
    require(gamma_squared + 4 * sigma_squared == Fraction(9, 20) < 1,
            "Graph radicand margin is not strictly positive")
    require(Fraction(1, 4) / (1 - Fraction(1, 4)) == Fraction(1, 3),
            "Wrong infinite-square coefficient in the range example")
    for N in certificate["actual_range_example"]["replay_N"]:
        require(isinstance(N, int) and N > 0, "Invalid sharpness replay index")
        f = [Fraction(4 ** n, N) for n in range(1, N + 1)]
        first = [Fraction(1, 4 ** n) * value for n, value in enumerate(f, 1)]
        last = sum(first)
        require(last == 1 and sum(value * value for value in first) == Fraction(1, N),
                "Actual-range sharpness example does not have the stated error")
    return "literal gaps, graph margin, and exact range-example arithmetic"


def lean_receipt():
    receipt = json.loads((HERE / "lean_verify.json").read_text())
    require(receipt["status"] == "success" and receipt["exit_code"] == 0,
            "Lean did not succeed")
    require(receipt["proof_holes"] == [] and receipt["audit_exit_code"] == 0,
            "Lean has a proof hole or failed transitive axiom audit")
    require("version 4.31.0," in receipt["tools"]["lean"]["version"],
            "Wrong Lean version")
    require(hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest() ==
            receipt["source_sha256"], "Lean source changed after compilation")
    fidelity = (HERE / "statement_fidelity.md").read_text()
    require(hashlib.sha256(fidelity.encode()).hexdigest() ==
            receipt["statement_fidelity_sha256"], "Statement fidelity changed after compilation")
    expected_names = {
        "complement_annihilates", "scaling_isometry", "defect_nonzero",
        "cutoff_compression", "two_column_obstruction",
        "four_entry_impossible", "graph_recovery",
    }
    printed_names = set()
    for line in receipt["stdout"].splitlines():
        name, axioms = line.split(" depends on axioms: ")
        printed_names.add(name.strip("'").removeprefix("FourEntryCore."))
        require(set(axioms.strip("[]").split(", ")) <=
                {"propext", "Classical.choice", "Quot.sound"},
                "Unexpected transitive axiom")
    require(printed_names == expected_names, "Missing transitive-axiom printout")
    record = receipt["kernel"]["recorded"]
    require(record["subject"]["subject_id"] == "V_FOUR_ENTRY_CORE" and
            record["verdict"] == "supports" and record["tier"] == "mechanical",
            "Compiler outcome was not recorded on the required claim")
    require(receipt["kernel"]["refusals"] == [], "Mechanical recording was refused")
    archive = json.loads((HERE.parents[1] / record["artifact"]).read_text())
    require(archive["lean_source"]["text"] == (HERE / "Main.lean").read_text() and
            archive["statement_fidelity"]["text"] == fidelity,
            "Archived compiler certificate is not the current source and reading")
    return "Lean 4.31.0 receipt, current hashes, and standard transitive axioms"


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["classification"] == "universal_algebraic_verification",
            "Certificate misclassifies its mathematical result")
    require(certificate["full_mathematical_claim"] == "V_FOUR_MECHANISM" and
            certificate["formalized_claim"] == "V_FOUR_ENTRY_CORE",
            "The complete analytical goal and formalized subclaim were conflated")
    identities = exact_algebra()
    require(identities == certificate["identities"], "Identity manifest is inconsistent")
    checks = [
        exact_jacobian(certificate),
        exact_thresholds(certificate),
        lean_receipt(),
    ]
    print(json.dumps({
        "status": "verified",
        "universal_free_star_algebra_identities": len(identities) + 1,
        "checks": checks,
        "scope": "Algebraic core and unchanged real compiler receipt; analytical proof and statement fidelity require independent review.",
        "independent_review": "pending",
    }, indent=2))


if __name__ == "__main__":
    main()
