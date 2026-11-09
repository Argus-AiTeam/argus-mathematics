#!/usr/bin/env python3
"""Replay the exact continuation-core certificate using only the standard library."""

import argparse
from fractions import Fraction
from functools import reduce
import hashlib
from itertools import combinations, combinations_with_replacement, permutations
import json
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
DIAMONDS = [
    (3, 1, ("i", "j"), ("j", "h")),
    (3, 1, ("i", "h"), ("j", "i")),
    (2, 0, ("j", "i"), ("h", "j")),
    (2, 0, ("i", "j"), ("h", "i")),
]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def transpose(a):
    return [list(row) for row in zip(*a)]


def columns(vectors):
    return transpose(vectors)


def identity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def dot(a, b):
    return sum(x * y for x, y in zip(a, b))


def multiply(a, b):
    bt = transpose(b)
    return [[dot(row, col) for col in bt] for row in a]


def apply(a, v):
    return [dot(row, v) for row in a]


def subtract(a, b):
    return [[x - y for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def determinant(a):
    n = len(a)
    require(all(len(row) == n for row in a), "determinant requires a square matrix")
    if n == 0:
        return 1
    work = [list(row) for row in a]
    sign, previous = 1, 1
    for k in range(n - 1):
        pivot = next((i for i in range(k, n) if work[i][k]), None)
        if pivot is None:
            return 0
        if pivot != k:
            work[k], work[pivot] = work[pivot], work[k]
            sign = -sign
        value = work[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                numerator = work[i][j] * value - work[i][k] * work[k][j]
                require(numerator % previous == 0, "Bareiss division is not exact")
                work[i][j] = numerator // previous
            work[i][k] = 0
        previous = value
    return sign * work[-1][-1]


def solve_injective(a, b):
    rows, cols = len(a), len(a[0])
    require(len(b) == rows, "linear system dimensions disagree")
    work = [
        [Fraction(x) for x in row] + [Fraction(value)]
        for row, value in zip(a, b)
    ]
    for j in range(cols):
        pivot = next((i for i in range(j, rows) if work[i][j]), None)
        require(pivot is not None, "pairing map is not injective")
        work[j], work[pivot] = work[pivot], work[j]
        value = work[j][j]
        work[j] = [x / value for x in work[j]]
        for i in range(rows):
            if i != j:
                value = work[i][j]
                work[i] = [x - value * y for x, y in zip(work[i], work[j])]
    require(
        all(not any(row) for row in work[cols:]),
        "common-potential system is inconsistent",
    )
    return [work[j][-1] for j in range(cols)]


def reflection(root):
    n = len(root)
    require(dot(root, root) == 2, "root length is not two")
    return [[int(i == j) - root[i] * root[j] for j in range(n)] for i in range(n)]


def route_matrices(roots):
    n = len(roots[0])
    frame = identity(n)
    gamma = []
    for root in roots:
        gamma.append(apply(transpose(frame), root))
        frame = multiply(reflection(root), frame)
    return columns(roots), columns(gamma), frame


def right_route(a, b):
    position = [a, apply(reflection(a), b)]
    return columns(position), columns([a, b]), multiply(reflection(a), reflection(b))


def compose(p, q):
    return tuple(p[q[i]] for i in range(len(p)))


def length(p):
    return sum(p[i] > p[j] for i in range(len(p)) for j in range(i + 1, len(p)))


def check_a2():
    roots = {"i": [1, -1, 0], "j": [0, 1, -1], "h": [1, 0, -1]}
    swaps = {"i": (1, 0, 2), "j": (0, 2, 1), "h": (2, 1, 0)}
    intervals = {}
    for start in permutations(range(3)):
        for first, second in permutations(roots, 2):
            middle = compose(start, swaps[first])
            end = compose(middle, swaps[second])
            if length(start) > length(middle) > length(end):
                require(
                    length(start) - length(middle) == length(middle) - length(end) == 1,
                    "a two-step decreasing A2 path is not a pair of covers",
                )
                intervals.setdefault((start, end), []).append((first, second))
    actual = {
        (length(start), length(end), frozenset(paths))
        for (start, end), paths in intervals.items()
    }
    expected = {(a, b, frozenset([old, new])) for a, b, old, new in DIAMONDS}
    require(actual == expected, "the four manuscript diamonds are not the complete S3 table")
    require(all(len(paths) == 2 for paths in intervals.values()), "a diamond has the wrong size")

    maps, descent_cases = [], 0
    for start_length, end_length, old, new in DIAMONDS:
        bo, go, po = right_route(*(roots[x] for x in old))
        bn, gn, pn = right_route(*(roots[x] for x in new))
        require(po == pn, f"reflection products differ for {old}, {new}")
        require(multiply(bo, transpose(go)) == subtract(identity(3), po), "old telescoping")
        require(multiply(bn, transpose(gn)) == subtract(identity(3), pn), "new telescoping")
        solutions = [solve_injective(bn, v) for v in transpose(bo)]
        m = columns(solutions)
        require(all(x.denominator == 1 for row in m for x in row), "nonintegral pair map")
        m = [[int(x) for x in row] for row in m]
        require(abs(determinant(m)) == 1, "pair map is not unimodular")
        require(multiply(bn, m) == bo, "pair coefficient displacement is not preserved")
        require(multiply(m, transpose(go)) == transpose(gn), "potential transport fails")
        inverse = columns([solve_injective(m, v) for v in identity(2)])
        require(multiply(m, inverse) == identity(2), "reverse pair map fails")
        maps.append({
            "lengths": [start_length, end_length],
            "old": list(old),
            "new": list(new),
            "new_coefficients_from_old": m,
        })
        for times in [
            {"i": Fraction(0), "h": Fraction(1), "j": Fraction(2)},
            {"j": Fraction(0), "h": Fraction(1), "i": Fraction(2)},
            {"i": Fraction(0), "h": Fraction(0), "j": Fraction(0)},
        ]:
            for before, after in [(old, new), (new, old)]:
                if times[before[0]] > times[before[1]]:
                    require(times[after[0]] < times[before[0]], "diamond does not descend")
                    descent_cases += 1

    require(descent_cases == 8, "not all eight directed strict diamond cases were tested")
    orthogonal = [[1, -1, 0, 0], [0, 0, 1, -1]]
    require(
        multiply(reflection(orthogonal[0]), reflection(orthogonal[1]))
        == multiply(reflection(orthogonal[1]), reflection(orthogonal[0])),
        "orthogonal reflections do not commute",
    )
    return {
        "classification": "all six S3 states and all ordered distinct reflection-line pairs",
        "downward_paths": sum(map(len, intervals.values())),
        "diamonds": maps,
        "strict_descent_cases": descent_cases,
        "persistent_tie_order_cells": 1,
        "orthogonal_commutation": True,
    }


BREAKS = [Fraction(0), Fraction(1, 3), Fraction(2, 3), Fraction(1)]


def pl_value(slopes, t):
    value = Fraction(0)
    for left, right, slope in zip(BREAKS, BREAKS[1:], slopes):
        if t <= left:
            break
        value += slope * (min(t, right) - left)
    return value


def pl_zero(slopes, offset):
    for left, right, slope in zip(BREAKS, BREAKS[1:], slopes):
        value = pl_value(slopes, left) - offset
        root = left - value / slope
        if left <= root <= right:
            require(pl_value(slopes, root) == offset, "piecewise inverse is incorrect")
            return root
    raise AssertionError("piecewise level has no zero in [0,1]")


def check_shape_breaks():
    f, g = [Fraction(x) for x in [1, 3, 2]], [Fraction(x) for x in [2, 1, 4]]
    h = [x + y for x, y in zip(f, g)]
    cases = []
    for a, b in [
        (Fraction(1, 5), Fraction(4, 5)),
        (Fraction(4, 5), Fraction(1, 5)),
        (Fraction(1, 3), Fraction(1, 3)),
    ]:
        fa, gb = pl_value(f, a), pl_value(g, b)
        c = pl_zero(h, fa + gb)
        require(pl_zero(f, fa) == a and pl_zero(g, gb) == b, "old candidate zeros")
        if a == b:
            require(c == a, "persistent tie fails exactly at a shape break")
        else:
            require(min(a, b) < c < max(a, b), "median fails across shape breaks")
        cases.append({"i": str(a), "j": str(b), "h": str(c)})
    return {"breaks": [str(x) for x in BREAKS], "exact_cases": cases}


def root_lines(n):
    result = []
    for i, j in combinations(range(n), 2):
        for sign in [-1, 1]:
            root = [0] * n
            root[i], root[j] = 1, sign
            result.append(tuple(root))
    return result


def connected_unbalanced(roots):
    n = len(roots[0])
    adjacency = [[] for _ in range(n)]
    for root in roots:
        i, j = [a for a in range(n) if root[a]]
        sign = -root[i] * root[j]
        adjacency[i].append((j, sign))
        adjacency[j].append((i, sign))
    values = {0: 1}
    queue, unbalanced = [0], False
    for i in queue:
        for j, sign in adjacency[i]:
            value = values[i] * sign
            if j in values:
                unbalanced |= values[j] != value
            else:
                values[j] = value
                queue.append(j)
    return len(values) == n and unbalanced


def primitive_cofactor(roots):
    b = columns(roots)
    n, k = len(b), len(roots)
    minors = [
        (-1) ** i * determinant([[row[j] for j in range(k) if j != i] for row in b])
        for i in range(k)
    ]
    divisor = reduce(gcd, (abs(x) for x in minors), 0)
    if divisor == 0:
        return 0, []
    c = [x // divisor for x in minors]
    if next(x for x in c if x) < 0:
        c = [-x for x in c]
    require(apply(b, c) == [0] * n, "cofactors do not give a relation")
    require(reduce(gcd, (abs(x) for x in c), 0) == 1, "relation is not primitive")
    return divisor, c


def check_small_rank_lattices():
    results = []
    for n in [2, 3, 4]:
        lines, generating, order_tests, potentials = root_lines(n), 0, 0, 0
        all_multisets = 0
        for indices in combinations_with_replacement(range(len(lines)), n + 1):
            roots = [lines[i] for i in indices]
            all_multisets += 1
            divisor, c = primitive_cofactor(roots)
            graph_generates = connected_unbalanced(roots)
            require((divisor == 2) == graph_generates, "signed-graph lattice criterion fails")
            if not graph_generates:
                continue
            generating += 1
            require(max(map(abs, c)) <= 2, "primitive position relation exceeds the bound")
            gram = [[dot(a, b) for b in roots] for a in roots]
            for order in permutations(range(n + 1)):
                cg = [
                    -c[i] - sum(c[j] * gram[j][i] for j in order[:p])
                    for p, i in enumerate(order)
                ]
                require(max(map(abs, cg)) <= 2, "primitive gap relation exceeds the bound")
                order_tests += 1
            b, gamma, frame = route_matrices(roots)
            require(
                multiply(b, transpose(gamma)) == subtract(identity(n), frame),
                "full-list telescoping fails",
            )
            gap_map = [
                [
                    -1 if i == j else -gram[j][i] if j < i else 0
                    for j in range(n + 1)
                ]
                for i in range(n + 1)
            ]
            require(
                multiply(gamma, gap_map) == multiply(transpose(frame), b),
                "position-to-gap kernel transformation identity fails",
            )
            gap_kernel = apply(gap_map, c)
            require(apply(gamma, gap_kernel) == [0] * n, "gap vector is not a relation")
            require(
                reduce(gcd, map(abs, gap_kernel), 0) == 1,
                "gap relation is not primitive",
            )
            require(multiply(frame, transpose(frame)) == identity(n), "frame is not orthogonal")
            potential = solve_injective(transpose(gamma), c)
            require(apply(transpose(gamma), potential) == c, "common potential fails")
            require(apply(frame, potential) == potential, "potential is not fixed by total frame")
            require(determinant(frame) == (-1) ** (n + 1), "reflection-product parity fails")
            potentials += 1
        results.append({
            "rank": n,
            "root_lines": len(lines),
            "root_multisets_including_repetitions": all_multisets,
            "lattice_generating_multisets": generating,
            "ordered_index_tests_including_repeated_column_labels": order_tests,
            "exact_potentials": potentials,
            "gap_kernel_identity": True,
        })
    return {
        "scope": "bounded adversarial calibration only; not an all-rank proof",
        "root_signs": "one canonical representative per line; sign covariance is proved in the report",
        "results": results,
    }


def decode_matrix(matrix):
    rows = [[int(x) for x in row] for row in matrix["entries"]]
    require(len(rows) == matrix["row_count"], "typed row count differs")
    require(all(len(row) == matrix["column_count"] for row in rows), "typed column count differs")
    require(matrix.get("domain", "ZZ") == "ZZ", "typed matrix is not integral")
    return rows


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    operation = "matrix.normal_form.smith.certified.compute"
    require(response["request"]["operation_id"] == operation, "wrong Jacobian operation")
    require(response["request"]["payload"] == payload, "Jacobian source payload differs")
    require(response["result"]["operation_id"] == operation, "Jacobian result is incomplete")
    output = response["result"]["output"]
    require(output["exactness"] == "EXACT_INTEGER", "Jacobian output is not exact")
    require(output["completeness"] == "FULL_MATRIX_TRANSFORMATIONS", "incomplete Smith output")
    certificate = output["certificate"]
    a = decode_matrix(payload["matrix"])
    require(decode_matrix(certificate["source"]) == a, "Smith certificate uses another source")
    d = decode_matrix(certificate["diagonal"])
    u = decode_matrix(certificate["left_transformation"])
    v = decode_matrix(certificate["right_transformation"])
    require(multiply(multiply(u, a), v) == d, "Smith transformation identity fails")
    require(determinant(u) == int(certificate["left_determinant"]), "left determinant differs")
    require(determinant(v) == int(certificate["right_determinant"]), "right determinant differs")
    require(abs(determinant(u)) == abs(determinant(v)) == 1, "Smith maps are not unimodular")
    require(
        d == [[1, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 2, 0]],
        "unexpected root-lattice Smith diagonal",
    )
    require(certificate["rank"] == 4, "Smith rank differs")
    require(certificate["invariant_factors"] == ["1", "1", "1", "2"], "Smith factors differ")
    kernel = [row[-1] for row in v]
    require(apply(a, kernel) == [0] * 4, "Smith kernel column fails")
    require(reduce(gcd, map(abs, kernel), 0) == 1, "Smith kernel is not primitive")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "timeout": False,
        "transport_error": None,
        "typed_output_complete": True,
        "diagonal": d,
        "primitive_kernel": kernel,
        "independent_exact_replay": True,
    }


def check_lean_record():
    result = json.loads((HERE / "lean_verify_output.json").read_text())
    require(result["status"] == "success", "Lean compiler did not succeed")
    require(result["exit_code"] == 0, "Lean compiler returned a nonzero exit code")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not succeed")
    require("4.31.0" in result["tools"]["lean"]["version"], "wrong Lean version")
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text().encode()
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"], "Lean source is stale")
    require(
        hashlib.sha256(fidelity).hexdigest() == result["statement_fidelity_sha256"],
        "Lean statement fidelity is stale",
    )
    record = result["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "no kernel evidence")
    require(record["subject"]["subject_id"] == "C_CONT_CORE", "Lean record names the wrong claim")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C_CONT_CORE"),
        key=lambda c: c["version"],
    )
    require(record["subject"]["content_hash"] == claim["content_hash"], "Lean claim was revised")
    archive = json.loads((ROOT / record["artifact"]).read_text())
    require(archive["lean_source"]["text"].encode() == source, "archived Lean source differs")
    require(archive["statement_fidelity"]["text"].encode() == fidelity, "archived reading differs")
    require(archive["lean_check"]["exit_code"] == 0, "archived compile did not succeed")
    require(archive["lean_check"]["proof_holes"] == [], "archived proof has holes")
    return {
        "claim": "C_CONT_CORE",
        "version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "archive": record["artifact"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "scope": "universal core lemmas only; geometric and signed-graph assembly is a prose proof",
    }


def verify():
    return {
        "claim": "C_CONT_ALT",
        "result_class": "new_theorem",
        "theorem": "All-rank type-D corank-one continuation: integral schedule or deficient-rank schedule.",
        "proof": "research/continuation/report.md, Theorem A and Proofs 1-6",
        "scope": {
            "ranks": "all n>=2",
            "shape": "polygonal, slopes relatively interior to endpoint chamber face",
            "initial_state": "feasible at 0<s0<1; n+1 lattice-generating roots; primitive half-direction and integral extrapolation",
            "sorting_bound": "(n(n-1))^(n+1)-1 replacements at each fixed nearby parameter",
            "not_claimed": "moment counts, columns, zero-tail removal, or type-D tensor saturation",
        },
        "rank_two": check_a2(),
        "shape_break_calibration": check_shape_breaks(),
        "small_rank_lattice_calibration": check_small_rank_lattices(),
        "jacobian": check_jacobian(),
        "lean": check_lean_record(),
        "independent_review": {
            "status": "pending_host_invoked_reviewer",
            "engineer_does_not_certify": [
                "independent acceptance",
                "statement fidelity approval",
                "absolute literature novelty",
                "publishability assessment",
            ],
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = verify()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == actual, "stored exact certificate differs from replay")
    print(json.dumps({
        "ok": True,
        "claim": actual["claim"],
        "lean_exit_code": actual["lean"]["exit_code"],
        "proof_holes": actual["lean"]["proof_holes"],
        "a2_diamonds": len(actual["rank_two"]["diamonds"]),
        "lattice_calibration": actual["small_rank_lattice_calibration"]["results"],
        "independent_review": actual["independent_review"]["status"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
