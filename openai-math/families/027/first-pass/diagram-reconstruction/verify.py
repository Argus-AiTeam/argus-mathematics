#!/usr/bin/env python3
"""Replay universal identities and the recorded formal reconstruction cores."""

import hashlib
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent
INVERSES = {
    "PA": "PAinv", "PAinv": "PA",
    "PB": "PBinv", "PBinv": "PB",
    "IA": "IAinv", "IAinv": "IA",
}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def matmul(a, b):
    require(len(a[0]) == len(b), "incompatible matrix product")
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def matadd(a, b):
    require(len(a) == len(b) and len(a[0]) == len(b[0]), "incompatible matrix sum")
    return [[x + y for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def identity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def zero(rows, columns):
    return [[0] * columns for _ in range(rows)]


def determinant(a):
    a = [[Fraction(x) for x in row] for row in a]
    n = len(a)
    require(all(len(row) == n for row in a), "determinant requires a square matrix")
    result = Fraction(1)
    for j in range(n):
        pivot = next((i for i in range(j, n) if a[i][j]), None)
        if pivot is None:
            return Fraction(0)
        if pivot != j:
            a[j], a[pivot] = a[pivot], a[j]
            result = -result
        scale = a[j][j]
        result *= scale
        for i in range(j + 1, n):
            ratio = a[i][j] / scale
            a[i] = [x - ratio * y for x, y in zip(a[i], a[j])]
    return result


def check_swap(certificate):
    modules = certificate["modules"]
    require(modules == {
        "U": ["a", "b", "h"],
        "M": ["a", "h", "x", "b", "h", "y"],
        "Q": ["h", "x", "y"],
    }, "the labeled direct sums do not match the theorem")
    expected_types = {
        "P": ("U", "M"), "I": ("M", "Q"),
        "R": ("M", "U"), "S": ("Q", "M"),
    }
    maps = {}
    for name, (source, target) in expected_types.items():
        record = certificate["maps"][name]
        require((record["source"], record["target"]) == (source, target),
                f"wrong type for {name}")
        matrix = record["matrix"]
        require(len(matrix) == len(modules[target]), f"wrong row count for {name}")
        require(all(len(row) == len(modules[source]) for row in matrix),
                f"wrong column count for {name}")
        for i, row in enumerate(matrix):
            for j, entry in enumerate(row):
                require(type(entry) is int, "block coefficients must be integers")
                require(entry == 0 or modules[target][i] == modules[source][j],
                        f"{name} uses an identity between different module types")
        maps[name] = matrix
    p, i, r, s = (maps[name] for name in ("P", "I", "R", "S"))
    require(matmul(i, p) == zero(3, 3), "IP is not zero")
    require(matmul(r, p) == identity(3), "RP is not the identity")
    require(matmul(i, s) == identity(3), "IS is not the identity")
    require(matadd(matmul(p, r), matmul(s, i)) == identity(6),
            "PR+SI is not the identity")
    wrong_sign = [row[:] for row in i]
    wrong_sign[0][4] = 1
    require(matmul(wrong_sign, p) != zero(3, 3),
            "the negative-scalar sign control did not detect the error")
    return 4


def stabilizer(u_blocks, q_blocks, u_flags, q_flags):
    require(len(u_flags) == len(q_flags), "different numbers of flag steps")
    require(set(u_flags[-1]) == set(u_blocks), "U flag is not exhaustive")
    require(set(q_flags[-1]) == set(q_blocks), "Q flag is not exhaustive")
    previous_u = set()
    previous_q = set()
    allowed = {(u, q) for u in u_blocks for q in q_blocks}
    for u_step, q_step in zip(u_flags, q_flags):
        u_step, q_step = set(u_step), set(q_step)
        require(previous_u <= u_step and previous_q <= q_step, "flags are not nested")
        allowed = {(u, q) for u, q in allowed if q not in q_step or u in previous_u}
        previous_u, previous_q = u_step, q_step
    return allowed


def check_stabilizers(certificate):
    expected = {"coarse": set(), "incoming": {("a", "y")}, "outgoing": {("b", "x")}}
    for name, support in expected.items():
        data = certificate["swap_stabilizers"][name]
        result = stabilizer(["a", "b", "h"], ["h", "x", "y"],
                            data["u_flags"], data["q_flags"])
        require(result == support == {tuple(pair) for pair in data["support"]},
                f"incorrect {name} identified-quotient stabilizer")
        u_flags = [["u_before"]] + [
            ["u_before"] + step for step in data["u_flags"]
        ] + [["u_before", "a", "b", "h", "u_after"]]
        q_flags = [["q_before"]] + [
            ["q_before"] + step for step in data["q_flags"]
        ] + [["q_before", "h", "x", "y", "q_after"]]
        extended = stabilizer(
            ["u_before", "a", "b", "h", "u_after"],
            ["q_before", "h", "x", "y", "q_after"], u_flags, q_flags)
        if name == "coarse":
            outside = extended
        else:
            require(outside <= extended and extended - outside == support,
                    f"outside blocks did not cancel for {name}")
    fine = stabilizer(["w1", "w2"], ["q1", "q2"],
                      [["w1"], ["w1", "w2"]], [["q1"], ["q1", "q2"]])
    require(fine == {("w1", "q2")}, "identified quotients require strict indices")
    require(("w1", "q1") not in fine, "a diagonal shear changed an identified quotient")
    require(expected["incoming"] != expected["outgoing"],
            "the two one-sided fibers have been conflated")
    return 6


def poly_add(a, b):
    result = dict(a)
    for word, coefficient in b.items():
        result[word] = result.get(word, 0) + coefficient
    return {word: coefficient for word, coefficient in result.items() if coefficient}


def poly_mul(a, b):
    result = {}
    for left, x in a.items():
        for right, y in b.items():
            stack = []
            for symbol in left + right:
                if stack and INVERSES.get(symbol) == stack[-1]:
                    stack.pop()
                else:
                    stack.append(symbol)
            word = tuple(stack)
            result[word] = result.get(word, 0) + x * y
    return {word: coefficient for word, coefficient in result.items() if coefficient}


def poly_matmul(a, b):
    require(len(a[0]) == len(b), "incompatible polynomial matrix product")
    result = [[{} for _ in b[0]] for _ in a]
    for i in range(len(a)):
        for j in range(len(b[0])):
            for k in range(len(b)):
                result[i][j] = poly_add(result[i][j], poly_mul(a[i][k], b[k][j]))
    return result


def check_generic_lower_data(certificate):
    generic = certificate["generic_lower_data"]
    require(generic["fourth_contact_map"] == "IB = -IA PA PB^-1",
            "the negative-scalar contact equation was changed")
    one = {(): 1}
    pa, pb, ia, pai, pbi, iai, ca, cb, da, db = (
        {(name,): 1} for name in
        ("PA", "PB", "IA", "PAinv", "PBinv", "IAinv", "cA", "cB", "dA", "dB")
    )
    minus = lambda polynomial: {word: -coefficient for word, coefficient in polynomial.items()}
    ib = minus(poly_mul(poly_mul(ia, pa), pbi))
    t, ti = poly_mul(ia, pa), poly_mul(pai, iai)
    actual_p = [
        [one, {}, ca], [{}, {}, pa], [{}, {}, {}],
        [{}, one, cb], [{}, {}, pb], [{}, {}, {}],
    ]
    actual_i = [
        [{}, ia, da, {}, ib, db],
        [{}, {}, one, {}, {}, {}],
        [{}, {}, {}, {}, {}, one],
    ]
    normal_m = [
        [one, ca, {}, {}, {}, {}], [{}, pa, {}, {}, {}, {}],
        [{}, {}, one, {}, {}, {}], [{}, {}, {}, one, cb, {}],
        [{}, {}, {}, {}, pb, {}], [{}, {}, {}, {}, {}, one],
    ]
    inverse_m = [
        [one, minus(poly_mul(ca, pai)), {}, {}, {}, {}],
        [{}, pai, {}, {}, {}, {}], [{}, {}, one, {}, {}, {}],
        [{}, {}, {}, one, minus(poly_mul(cb, pbi)), {}],
        [{}, {}, {}, {}, pbi, {}], [{}, {}, {}, {}, {}, one],
    ]
    normal_q = [[t, da, db], [{}, one, {}], [{}, {}, one]]
    inverse_q = [
        [ti, minus(poly_mul(ti, da)), minus(poly_mul(ti, db))],
        [{}, one, {}], [{}, {}, one],
    ]
    symbols = {
        "PA": ("hU", "hA"), "PB": ("hU", "hB"), "IA": ("hA", "hQ"),
        "PAinv": ("hA", "hU"), "PBinv": ("hB", "hU"), "IAinv": ("hQ", "hA"),
        "cA": ("hU", "a"), "cB": ("hU", "b"),
        "dA": ("x", "hQ"), "dB": ("y", "hQ"),
    }

    def typed(matrix, source, target):
        require(len(matrix) == len(target) and all(len(row) == len(source) for row in matrix),
                "wrong symbolic block shape")
        for row, output_type in zip(matrix, target):
            for polynomial, input_type in zip(row, source):
                for word in polynomial:
                    current = input_type
                    for symbol in reversed(word):
                        domain, codomain = symbols[symbol]
                        require(current == domain, "noncomposable symbolic maps")
                        current = codomain
                    require(current == output_type, "wrong symbolic block target")

    u = ["a", "b", "hU"]
    canonical_m = ["a", "hU", "x", "b", "hU", "y"]
    actual_m = ["a", "hA", "x", "b", "hB", "y"]
    canonical_q, actual_q = ["hU", "x", "y"], ["hQ", "x", "y"]
    typed(actual_p, u, actual_m)
    typed(actual_i, actual_m, actual_q)
    typed(normal_m, canonical_m, actual_m)
    typed(inverse_m, actual_m, canonical_m)
    typed(normal_q, canonical_q, actual_q)
    typed(inverse_q, actual_q, canonical_q)

    def polynomial_matrix(matrix):
        return [[{(): entry} if entry else {} for entry in row] for row in matrix]

    p = polynomial_matrix(certificate["maps"]["P"]["matrix"])
    i = polynomial_matrix(certificate["maps"]["I"]["matrix"])
    for normal, inverse, size in ((normal_m, inverse_m, 6), (normal_q, inverse_q, 3)):
        require(poly_matmul(normal, inverse) == polynomial_matrix(identity(size)) and
                poly_matmul(inverse, normal) == polynomial_matrix(identity(size)),
                "the proposed lower-data normalization is not invertible")
    require(actual_p == poly_matmul(normal_m, p),
            "normalization changed an actual injection or its named quotients")
    require(poly_matmul(actual_i, normal_m) == poly_matmul(normal_q, i),
            "normalization changed an actual projection or its named quotients")
    require(poly_matmul(actual_i, actual_p) == polynomial_matrix(zero(3, 3)),
            "generic lower data have an uncancelled off-diagonal composite")
    return 7


def check_universal_schemas(certificate):
    split = certificate["split_stabilizer"]
    require(split["support"] == "k < j" and split["forward_witness"] == "t = j",
            "the unbounded split proof has changed")
    require(split["reverse_identity"] == "(t-k-1) = (j-k-1) + (t-j)",
            "wrong integer-order certificate")
    lhs = {("t",): 1, ("k",): -1, (): -1}
    rhs = poly_add({("j",): 1, ("k",): -1, (): -1},
                   {("t",): 1, ("j",): -1})
    require(lhs == rhs, "the universal order implication is invalid")
    # Words remain noncommutative, so no commuting-map assumption is introduced.
    one, h, g = {(): 1}, {("h",): 1}, {("g",): 1}
    shear_h = [[one, h], [{}, one]]
    shear_g = [[one, g], [{}, one]]
    require(poly_matmul(shear_h, shear_g) ==
            [[one, poly_add(h, g)], [{}, one]], "incorrect additive shear action")
    require(poly_matmul(shear_h, [[one, {("h",): -1}], [{}, one]]) ==
            [[one, {}], [{}, one]], "incorrect shear inverse")
    require(certificate["anchor"]["stabilizer"] == "H" and
            certificate["anchor"]["identified_lift_space"] == "singleton",
            "the closure theorem lacks its anchor hypothesis")
    # The all-h example has two identity restrictions, whose joint image is diagonal.
    require(matmul([[1], [1]], [[0]]) != [[0], [1]],
            "the one-sided/two-sided distinction was lost")
    return 3


def rational(value):
    require(set(value) == {"num", "den"}, "noncanonical rational fields")
    result = Fraction(int(value["num"]), int(value["den"]))
    require(value == {"num": str(result.numerator), "den": str(result.denominator)},
            "rational is not in reduced canonical form")
    return result


def check_jacobian(certificate):
    record = certificate["jacobian"]
    payload = read_json(ROOT / record["payload"])
    response = read_json(ROOT / record["output"])
    status = read_json(ROOT / record["status"])
    require(status["adapter_exit_code"] == 0 and status["timeout"] is False,
            "Jacobian did not complete successfully")
    require(status["operation_id"] == record["operation_id"], "wrong adapter status")
    require(response["protocol_version"] == record["protocol_version"],
            "unexpected Jacobian protocol")
    require(response["server"]["version"] == record["server_version"],
            "unexpected Jacobian server version")
    require(response["request"] == {
        "operation_id": record["operation_id"], "payload": payload
    }, "Jacobian answer is for a different payload")
    result = response["result"]
    require(result["operation_id"] == record["operation_id"], "wrong Jacobian operation")
    output = result["output"]
    require(output["outcome"] == "UNIQUE", "Jacobian did not certify a unique solution")
    require(output["matrix"] == payload["matrix"] and output["rhs"] == payload["rhs"],
            "Jacobian changed the system")
    a = [[rational(x) for x in row] for row in payload["matrix"]["entries"]]
    b = [[rational(x)] for x in payload["rhs"]]
    solution = [rational(x) for x in output["solution"]]
    require(solution == [Fraction(x) for x in record["solution"]] ==
            [Fraction(0), Fraction(1), Fraction(1), Fraction(0)],
            "incorrect h-block contraction coefficients")
    require(matmul(a, [[x] for x in solution]) == b, "the returned solution is false")
    require(determinant(a) == record["coefficient_determinant"] == 1,
            "uniqueness or integral unimodularity failed")
    ra, rb, sa, sb = solution
    require(ra + rb == sa - sb == 1 and
            [[ra + sa, rb - sa], [ra + sb, rb - sb]] == identity(2),
            "the coefficient solution is not a chain contraction")
    return 1


def check_lean(certificate):
    record = certificate["lean"]
    source = (ROOT / record["source"]).read_text(encoding="utf-8")
    fidelity = (ROOT / record["fidelity"]).read_text(encoding="utf-8")
    result = read_json(ROOT / record["result"])
    archive = read_json(ROOT / record["archive"])
    require(result["status"] == "success" and result["exit_code"] == 0 and
            result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "the actual Lean compile or proof-hole audit did not pass")
    require("version 4.31.0," in result["tools"]["lean"]["version"],
            "the recorded kernel is not Lean 4.31.0")
    require(result["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(),
            "the Lean source changed after compilation")
    require(result["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.encode()).hexdigest(),
            "statement fidelity changed after compilation")
    require(archive["lean_check"] == result and archive["verdict"] == "supports" and
            archive["tier"] == "mechanical", "the archived result is not this successful run")
    require(archive["lean_source"]["text"] == source and
            archive["statement_fidelity"]["text"] == fidelity,
            "the archive does not bind the current statements")
    for declaration in record["declarations"]:
        require(f"theorem {declaration} " in source,
                f"missing formal declaration {declaration}")
    state = read_json(PROJECT / "research/MATH_STATE.json")
    claims = [claim for claim in state["claims"] if claim["claim_id"] == record["claim_id"]]
    require(bool(claims), "the formal theorem was not registered")
    current = max(claims, key=lambda claim: claim["version"])
    require(archive["subject"]["subject_id"] == record["claim_id"] and
            archive["subject"]["content_hash"] == current["content_hash"],
            "the compiler archive is for a superseded claim")
    require(current["formal_statement"].strip() == source.strip(),
            "the ledger formal statement differs from the compiler input")
    return len(record["declarations"])


def main():
    certificate = read_json(ROOT / "exact_certificate.json")
    require(certificate["claim_id"] == "C_DISK_RECONSTRUCTION", "wrong target claim")
    manuscript = (PROJECT / certificate["source"]).read_text(encoding="utf-8")
    for fragment in certificate["source_fragments"]:
        require(fragment in manuscript, f"literal manuscript fragment not found: {fragment}")
    counts = {
        "typed_universal_swap_identities": check_swap(certificate),
        "generic_lower_data_normalization_identities": check_generic_lower_data(certificate),
        "identified_quotient_support_checks": check_stabilizers(certificate),
        "universal_shear_and_order_schemas": check_universal_schemas(certificate),
        "bounded_jacobian_answers_replayed": check_jacobian(certificate),
        "lean_declarations_bound_to_fresh_compile": check_lean(certificate),
    }
    print(json.dumps({
        "ok": True,
        "claim": certificate["claim_id"],
        "kind": "universal_identity_replay_with_constructive_proof",
        "finite_rank_bound": None,
        "checks": counts,
        "independent_review": certificate["independent_review"],
        "scope": certificate["scope"],
    }, indent=2))


if __name__ == "__main__":
    main()
