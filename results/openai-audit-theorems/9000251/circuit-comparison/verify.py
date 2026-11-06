#!/usr/bin/env python3
"""Replay the exact supporting certificate; the uniform proof is comparison.md."""

import hashlib
import itertools
import json
import re
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def identity(n):
    return [[F(i == j) for j in range(n)] for i in range(n)]


def zeros(n):
    return [[F(0) for _ in range(n)] for _ in range(n)]


def transpose(a):
    return [list(row) for row in zip(*a)]


def multiply(a, b):
    require(len(a[0]) == len(b), "matrix dimensions do not match")
    return [
        [sum((x * y for x, y in zip(row, col)), F(0)) for col in zip(*b)]
        for row in a
    ]


def subtract(a, b):
    return [[x - y for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def block_diagonal(a, b):
    n, m = len(a), len(b)
    return [
        (a[i] + [F(0)] * m) if i < n else ([F(0)] * n + b[i - n])
        for i in range(n + m)
    ]


def exchange(c, si):
    n = len(c)
    return [[F(0)] * n + row for row in c] + [
        row + [F(0)] * n for row in si
    ]


def projector(n, indices):
    return [[F(i == j and i in indices) for j in range(n)] for i in range(n)]


def normalized(text):
    return " ".join(text.split())


def check_source(certificate):
    source = (ROOT / certificate["source"]).read_text()
    locations = {}
    for item in certificate["source_assertions"]:
        label = "\\label{" + item["label"] + "}"
        require(source.count(label) == 1, "source label is missing or ambiguous: " + label)
        require(
            normalized(item["literal"]) in normalized(source),
            "literal source assertion changed: " + item["label"],
        )
        locations[item["label"]] = source[: source.index(label)].count("\n") + 1
    proof = (HERE / certificate["proof"]).read_text()
    for equation in ("40h+16N\\eta+30Nh\\eta", "40h+16N\\delta+30Nh\\zeta"):
        require(equation in proof, "proof/certificate coefficient mismatch")
    require("not** a certification" in proof, "the theorem's scope disclaimer is absent")
    return locations


def check_constants(certificate):
    c = {key: F(value) for key, value in certificate["uniform_parameters"].items()
         if key not in {"level_positivity", "manuscript_specialization"}}
    require(c["h_max"] == F(1, 128), "wrong h regime")
    require(c["delta_max"] == c["zeta_max"] == F(1, 4), "wrong sparse regime")
    require(F(3, 4) ** 2 <= F(3, 4), "square-root lower bound")
    require(F(3, 4) * (1 + F(3, 4)) >= 1, "inverse-square-root scalar bound")
    require(F(8, 3) + F(32, 9) < c["schur_global"], "Schur-map constant")
    require(F(9, 8) ** 2 >= 1 + 2 * F(1, 8), "inverse norm bound")
    require(F(9, 8) * 2 * c["schur_global"] <= c["nested_global"], "nested global")
    require(F(9, 8) * 4 <= c["nested_protected"], "nested protected")
    require(3 * c["nested_protected"] == c["truncation_error"], "truncation cost")
    require(c["nested_global"] * c["h_max"] < F(1, 2), "truncation t hypothesis")
    require(
        c["nested_protected"] * c["h_max"] * c["zeta_max"] <= F(1, 2),
        "truncation e hypothesis",
    )
    require(
        c["nested_global"] + c["truncation_error"] * c["zeta_max"]
        <= c["corrected_global"],
        "corrected unitary cost",
    )
    require(4 * 2 == c["frame_layer"], "frame layer cost")
    require(2 * c["corrected_global"] == c["bound_h"], "comparison h cost")
    require(2 * c["frame_layer"] == c["bound_N_delta"], "comparison frame cost")
    require(2 * c["truncation_error"] == c["bound_N_h_zeta"], "comparison priority cost")
    require(
        max(c["bound_h"], c["bound_N_delta"], c["bound_N_h_zeta"])
        <= c["manuscript_common_constant"],
        "manuscript common constant",
    )
    # Coefficients of the universal Schur-budget identity in powers of h.
    left = (F(0), F(2, 3), -F(4, 3) - 4)
    right = (F(0), F(2, 3), -F(16, 3))
    require(left == right, "Schur budget factorization")
    require(1 - 2 * F(1, 8) > 0 and 1 - 8 * F(1, 8) == 0,
            "positivity factors on the whole Schur interval")
    return {key: str(c[key]) for key in
            ("bound_h", "bound_N_delta", "bound_N_h_zeta", "h_max")}


# Free noncommutative polynomials; only adjacent inverse pairs are reduced.
INVERSE_PAIRS = {("r", "u"), ("u", "r"), ("s", "v"), ("v", "s")}
ADJOINT = {"r": "r", "u": "u", "s": "s", "v": "v", "b": "bt", "bt": "b"}


def reduce_word(word):
    stack = []
    for letter in word:
        if stack and (stack[-1], letter) in INVERSE_PAIRS:
            stack.pop()
        else:
            stack.append(letter)
    return tuple(stack)


def nc_add(*polys):
    out = {}
    for poly in polys:
        for word, coefficient in poly.items():
            out[word] = out.get(word, F(0)) + coefficient
    return {word: coefficient for word, coefficient in out.items() if coefficient}


def nc_neg(poly):
    return {word: -coefficient for word, coefficient in poly.items()}


def nc_mul(*polys):
    out = {(): F(1)}
    for poly in polys:
        terms = {}
        for aw, ac in out.items():
            for bw, bc in poly.items():
                word = reduce_word(aw + bw)
                terms[word] = terms.get(word, F(0)) + ac * bc
        out = {word: coefficient for word, coefficient in terms.items() if coefficient}
    return out


def nc_star(poly):
    return {tuple(ADJOINT[x] for x in reversed(word)): coefficient
            for word, coefficient in poly.items()}


def nc_matmul(a, b):
    return [[nc_add(*(nc_mul(a[i][k], b[k][j]) for k in range(2)))
             for j in range(2)] for i in range(2)]


def check_universal_schur_algebra():
    r, u, s, v, b, bt = ({(name,): F(1)} for name in ("r", "u", "s", "v", "b", "bt"))
    zero, one = {}, {(): F(1)}
    h = [[nc_mul(r, r), b],
         [bt, nc_add(nc_mul(s, s), nc_mul(bt, u, u, b))]]
    q = [[u, nc_neg(nc_mul(u, u, b, v))], [zero, v]]
    qs = [[nc_star(q[j][i]) for j in range(2)] for i in range(2)]
    require(nc_matmul(nc_matmul(qs, h), q) == [[one, zero], [zero, one]],
            "noncommutative block-Schur congruence")
    # No commutation of r,b,s is used. r=a^(1/2), s=E^(1/2).
    return "Q* H Q = I in the free inverse-pair algebra"


def matching_priority(selected, a, b, h):
    det = a * a - b * b
    q = identity(4)
    for i, j in ((0, 3), (1, 2)):
        require(not (i in selected and j in selected), "priority compression is nonzero")
        if i not in selected and j not in selected:
            q[i][i] = q[j][j] = a / det
            q[i][j] = q[j][i] = -b / det
        else:
            p, other = (i, j) if i in selected else (j, i)
            q[p][p] = 1
            q[p][other] = -h / det
            q[other][p] = 0
            q[other][other] = 1 / det
    return q


def check_prescribed_priority(q, metric, selected):
    indices = sorted(selected)
    complement = [i for i in range(4) if i not in selected]

    def restrict(matrix, rows, columns):
        return [[matrix[i][j] for j in columns] for i in rows]

    if indices:
        require(restrict(metric, indices, indices) == identity(len(indices)),
                "example's a block is not identity")
        require(restrict(q, indices, indices) == identity(len(indices)),
                "priority a^{-1/2} block")
        require(all(q[i][j] == 0 for i in complement for j in indices),
                "priority lower-left block")
        coupling = restrict(metric, indices, complement)
        schur = subtract(restrict(metric, complement, complement),
                         multiply(transpose(coupling), coupling))
    else:
        coupling = []
        schur = metric
    v = restrict(q, complement, complement)
    require(v == transpose(v), "inverse Schur square root is not self-adjoint")
    require(all(v[i][i] > sum((abs(v[i][j]) for j in range(len(v)) if i != j), F(0))
                for i in range(len(v))),
            "inverse Schur square root is not certified positive")
    require(multiply(multiply(v, schur), v) == identity(len(v)),
            "inverse Schur square-root identity")
    if indices:
        require(restrict(q, indices, complement) ==
                [[-x for x in row] for row in multiply(coupling, v)],
                "priority upper-right block is not -a^{-1}b E^{-1/2}")


def check_priority_example(certificate):
    example = certificate["rational_priority_example"]
    a, b, h = (F(example[key]) for key in ("a", "b", "h"))
    require(a * a + b * b == 1 and a > b > 0, "positive rational square roots")
    require(2 * a * b == h and 0 < h <= F(1, 128), "example parameter regime")
    det = a * a - b * b
    require(det > 0 and det * det == 1 - h * h, "Schur complement square root")
    i4 = identity(4)
    gamma = zeros(4)
    for i, j in ((0, 3), (1, 2)):
        gamma[i][j] = gamma[j][i] = 1
    z = projector(4, {0, 1})
    z = [[2 * z[i][j] - i4[i][j] for j in range(4)] for i in range(4)]
    require(transpose(gamma) == gamma and multiply(gamma, gamma) == i4,
            "actual involution algebra")
    require(multiply(gamma, z) == [[-x for x in row] for row in multiply(z, gamma)],
            "Jordan-Wigner local parity algebra")
    metric = [[i4[i][j] + h * gamma[i][j] for j in range(4)] for i in range(4)]
    root = [[a * i4[i][j] + b * gamma[i][j] for j in range(4)] for i in range(4)]
    require(multiply(root, root) == metric, "positive metric square root")
    root_inv = [[(a * i4[i][j] - b * gamma[i][j]) / det for j in range(4)]
                for i in range(4)]
    require(multiply(root, root_inv) == i4, "fixed reverse-leg inverse")
    small = set(example["small_priority_coordinates"])
    large = set(example["large_priority_coordinates"])
    require(small < large, "strictly nested priorities")
    s2 = matching_priority(small, a, b, h)
    s3 = matching_priority(large, a, b, h)
    s3inv = [[sum((s3[k][i] * metric[k][j] for k in range(4)), F(0))
              for j in range(4)] for i in range(4)]
    require(multiply(s3inv, s3) == i4, "nested map inverse")
    k = multiply(s3inv, s2)
    expected = identity(4)
    expected[1][1] = expected[2][2] = a
    expected[1][2], expected[2][1] = b, -b
    require(k == expected and k != i4, "nontrivial exact priority rotation")
    error = subtract(k, i4)
    p2, p3 = (projector(4, indices) for indices in (small, large))
    for p in (p2, p3):
        require(multiply(multiply(p, gamma), p) == zeros(4), "zero priority compression")
    require(multiply(error, p2) == zeros(4), "exact protected action")
    rho2 = 2 * (1 - a)
    require(multiply(transpose(error), error) ==
            [[rho2 * F(i == j and i in {1, 2}) for j in range(4)] for i in range(4)],
            "exact discrepancy norm square")
    require(rho2 <= (16 * h) ** 2, "global nested bound in the example")
    next_layer = identity(5)
    next_layer[0][0] = next_layer[4][4] = 0
    next_layer[0][4] = next_layer[4][0] = 1
    k5 = block_diagonal(k, identity(1))
    require(multiply(k5, next_layer) == multiply(next_layer, k5),
            "actual protected-coordinate exchange commutation")
    edge_metric = block_diagonal(metric, i4)
    old_inverse = exchange(s2, root)
    new_swap = exchange(root_inv, s3inv)
    require(multiply(new_swap, old_inverse) == block_diagonal(i4, k),
            "arrival, not departure, post-error orientation")
    require(multiply(multiply(transpose(new_swap), edge_metric), new_swap) == edge_metric,
            "directed exchange isometry in the endpoint metrics")
    states = [set(x for x in pair if x is not None)
              for pair in itertools.product((None, 0, 3), (None, 1, 2))]
    nested_cases = 0
    for r2 in states:
        q2 = matching_priority(r2, a, b, h)
        check_prescribed_priority(q2, metric, r2)
        require(multiply(multiply(transpose(q2), metric), q2) == i4,
                "finite priority-map congruence")
        require(multiply(subtract(q2, i4), projector(4, r2)) == zeros(4),
                "finite zero-compression priority estimate")
        for r3 in states:
            if not r2 <= r3:
                continue
            q3 = matching_priority(r3, a, b, h)
            q3inv = multiply(transpose(q3), metric)
            kk = multiply(q3inv, q2)
            require(multiply(transpose(kk), kk) == i4, "finite nested unitarity")
            require(multiply(subtract(kk, i4), projector(4, r2)) == zeros(4),
                    "finite nested protected estimate")
            nested_cases += 1
    require(nested_cases == 25, "finite nested-case coverage changed")
    return error, nested_cases


def check_jacobian(certificate, error):
    config = certificate["jacobian"]
    payload = json.loads((HERE / config["payload"]).read_text())
    output = json.loads((HERE / config["typed_output"]).read_text())
    status = json.loads((HERE / config["process_status"]).read_text())
    require(status == {"process_exit_code": 0}, "Jacobian process error")
    require(output["protocol_version"] == "2025-11-25", "unexpected adapter protocol")
    require(output["server"]["name"] == "jacobian"
            and output["server"]["version"] == "0.14.0", "unexpected server identity")
    require(output["request"]["operation_id"] == config["operation_id"],
            "Jacobian operation binding")
    require(output["request"]["payload"] == payload, "Jacobian payload binding")
    result = output["result"]
    require(result["operation_id"] == config["operation_id"]
            and "output" in result and "error" not in result,
            "Jacobian incomplete or error result is not mathematical evidence")
    typed = result["output"]
    require(typed["matrix"] == payload["matrix"], "Jacobian source matrix binding")
    require(typed["method"] == "EXACT_RATIONAL_ROW_REDUCTION", "unexpected rank method")
    raw = payload["matrix"]["entries"]
    matrix = [[F(int(x["num"]), int(x["den"])) for x in row] for row in raw]
    require(matrix == [row[:3] for row in error[:3]], "rank payload is not the priority error")
    require(all(x == 0 for x in error[3])
            and all(row[3] == 0 for row in error), "omitted fourth coordinate is not fixed")
    determinant = matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1]
    require(determinant != 0 and matrix[0] == [0, 0, 0], "independent rank-two replay")
    require(typed["rank"] == 2 and typed["pivot_columns"] == [1, 2], "rank output mismatch")
    return {"operation_id": config["operation_id"], "rank": 2, "process_exit_code": 0}


def check_f1_support():
    count = 0
    for size in range(2, 6):
        for before in itertools.product((0, 1), repeat=size):
            for after in itertools.product((0, 1), repeat=size):
                # 0 is E; 1 is F. A is the first size-1 configurations.
                if any(b == 0 and a == 1 for b, a in zip(before, after)):
                    continue
                a_flags = before[:-1]
                surviving = 0 in a_flags and 1 in a_flags
                new_common_f = all(x == 1 for x in after[:-1]) and after[-1] == 0
                require(not (surviving and new_common_f), "F1 adjacent-support counterexample")
                count += 1
    return {"finite_boolean_cases": count,
            "scope": "support truth-table supplement; the all-cardinality argument is in the proof"}


def check_lean(certificate):
    formal = certificate["formal_core"]
    record = json.loads((HERE / formal["compiler_record"]).read_text())
    require(record["exit_code"] == 0, "Lean compiler did not succeed")
    require(record["proof_holes"] == [], "Lean proof has holes")
    source = (HERE / formal["source"]).read_bytes()
    fidelity = (HERE / formal["statement_fidelity"]).read_text()
    require(hashlib.sha256(source).hexdigest() == record["source_sha256"],
            "Lean source changed after compilation")
    require(hashlib.sha256(fidelity.encode()).hexdigest() == record["statement_fidelity_sha256"],
            "Lean statement fidelity changed after compilation")
    require("4.31.0" in json.dumps(record), "required Lean version is absent")
    require(not re.search(r"\b(sorry|admit|axiom)\b", source.decode()),
            "untrusted proof declaration in source")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    evidence = [item for item in state["evidence"]
                if item["subject"]["subject_id"] == formal["claim"]
                and item["tier"] == "mechanical" and item["verdict"] == "supports"]
    require(len(evidence) == 1, "formal core lacks a unique current mechanical certificate")
    archive = json.loads((ROOT / evidence[0]["artifact"]).read_text())
    require(archive["lean_check"] == record, "archived compiler record mismatch")
    require(archive["lean_source"]["text"].encode() == source, "archived source mismatch")
    require(archive["statement_fidelity"]["text"] == fidelity, "archived reading mismatch")
    return {"claim": formal["claim"], "exit_code": 0, "proof_holes": [],
            "archived_certificate": evidence[0]["artifact"]}


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["schema_version"] == 1, "unsupported certificate version")
    locations = check_source(certificate)
    constants = check_constants(certificate)
    schur = check_universal_schur_algebra()
    error, cases = check_priority_example(certificate)
    adapter = check_jacobian(certificate, error)
    support = check_f1_support()
    lean = check_lean(certificate)
    print(json.dumps({
        "supporting_certificate_checks": "passed",
        "claims": certificate["claims"],
        "source_assertion_lines": locations,
        "bound_coefficients": constants,
        "universal_schur_identity": schur,
        "exact_nested_priority_cases": cases,
        "adjacent_support_check": support,
        "jacobian": adapter,
        "formal_core": lean,
        "uniform_proof": "comparison.md; requires independent mathematical review",
        "not_claimed": "A finite experiment or this algebraic Lean core proves neither full main converse.",
    }, indent=2))


if __name__ == "__main__":
    main()
