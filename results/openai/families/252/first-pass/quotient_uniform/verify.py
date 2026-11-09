#!/usr/bin/env python3
"""Replay exact supporting fixtures; the universal proof is in proof.md."""

import argparse
import hashlib
import itertools
import json
from collections import Counter
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def multiply(a, b):
    return [
        [sum(x * y for x, y in zip(row, col)) for col in zip(*b)]
        for row in a
    ]


def transpose(a):
    return [list(row) for row in zip(*a)]


def matrix_sum(matrices, size):
    result = [[0] * size for _ in range(size)]
    for matrix in matrices:
        for i, row in enumerate(matrix):
            for j, value in enumerate(row):
                result[i][j] += value
    return result


def residues(a, prime):
    return [[x % prime for x in row] for row in a]


def rank(a, prime=None):
    b = residues(a, prime) if prime else [[Fraction(x) for x in row] for row in a]
    pivot_row = 0
    for col in range(len(b[0])):
        pivot = next((i for i in range(pivot_row, len(b)) if b[i][col]), None)
        if pivot is None:
            continue
        b[pivot_row], b[pivot] = b[pivot], b[pivot_row]
        inverse = pow(b[pivot_row][col], -1, prime) if prime else 1 / b[pivot_row][col]
        b[pivot_row] = [x * inverse for x in b[pivot_row]]
        if prime:
            b[pivot_row] = [x % prime for x in b[pivot_row]]
        for i in range(pivot_row + 1, len(b)):
            coefficient = b[i][col]
            if coefficient:
                b[i] = [x - coefficient * y for x, y in zip(b[i], b[pivot_row])]
                if prime:
                    b[i] = [x % prime for x in b[i]]
        pivot_row += 1
        if pivot_row == len(b):
            break
    return pivot_row


def determinant(a):
    b = [row[:] for row in a]
    previous, sign = 1, 1
    for k in range(len(b) - 1):
        pivot = next((i for i in range(k, len(b)) if b[i][k]), None)
        if pivot is None:
            return 0
        if pivot != k:
            b[k], b[pivot] = b[pivot], b[k]
            sign = -sign
        p = b[k][k]
        for i in range(k + 1, len(b)):
            for j in range(k + 1, len(b)):
                numerator = p * b[i][j] - b[i][k] * b[k][j]
                require(numerator % previous == 0, "Bareiss division is not exact")
                b[i][j] = numerator // previous
            b[i][k] = 0
        previous = p
    return sign * b[-1][-1]


def compose(g, h):
    return tuple(g[h[i]] for i in range(len(g)))


def inverse(g):
    return tuple(g.index(i) for i in range(len(g)))


def regular(group, g):
    return [[int(x == compose(g, y)) for y in group] for x in group]


def block_array(group, array):
    d = len(group)
    blocks = [[regular(group, g) for g in row] for row in array]
    return [
        [blocks[u][v][x][y] for v in range(len(array[0])) for y in range(d)]
        for u in range(len(array))
        for x in range(d)
    ]


def rectangular_word(array, u, up, v, vp):
    return compose(
        compose(compose(array[u][v], inverse(array[up][v])), array[up][vp]),
        inverse(array[u][vp]),
    )


def check_array(group, array, prime):
    r, d = len(array), len(group)
    identity = tuple(range(len(group[0])))
    for u, up, v, vp in itertools.product(range(r), repeat=4):
        word = rectangular_word(array, u, up, v, vp)
        require((word == identity) == (u == up or v == vp), "Rectangle hypothesis fails")
    y = block_array(group, array)
    gram = multiply(y, transpose(y))
    first = sum(gram[i][i] for i in range(r * d))
    second = sum(x * x for row in gram for x in row)
    require(first == r * r * d, "First real trace identity fails")
    require(second == (2 * r**3 - r**2) * d, "Second real trace identity fails")
    require(all(sum(x * x for x in row) == r for row in y), "Wrong row norm")
    rational_rank, modular_rank = rank(y), rank(y, prime)
    require((2 * r - 1) * rational_rank >= r * r * d, "Real rank lower bound fails")
    require(2 * modular_rank > rational_rank, "Strict integral rank comparison fails")
    require(4 * modular_rank > r * d, "Strict characteristic-independent bound fails")
    return y, rational_rank, modular_rank


def permutation_fixture():
    group = list(itertools.permutations(range(3)))
    identity = (0, 1, 2)
    a, b = (1, 0, 2), (0, 2, 1)
    ua, ub = regular(group, a), regular(group, b)
    require(multiply(ua, ub) != multiply(ub, ua), "Fixture permutations commute")
    for g, h in itertools.product(group, repeat=2):
        require(
            multiply(regular(group, g), regular(group, h)) == regular(group, compose(g, h)),
            "Left regular multiplication order is wrong",
        )
        require(transpose(regular(group, g)) == regular(group, inverse(g)), "Transpose fails")
        require(
            sum(regular(group, g)[i][i] for i in range(6)) == (6 if g == identity else 0),
            "Regular trace formula fails",
        )
    histogram = Counter()
    survived = 0
    for entries in itertools.product(group, repeat=4):
        array = [list(entries[:2]), list(entries[2:])]
        if rectangular_word(array, 0, 1, 0, 1) == identity:
            continue
        _, real_rank, modular_rank = check_array(group, array, 3)
        histogram[(real_rank, modular_rank)] += 1
        survived += 1
    require(survived == 1080, "Unexpected exhaustive S3 count")
    return {
        "group": "S3",
        "D": 6,
        "q": 3,
        "r": 2,
        "q_divides_D": True,
        "arrays_examined": 6**4,
        "arrays_satisfying_all_rectangles": survived,
        "first_trace": 24,
        "second_trace": 72,
        "rank_histogram": [
            {"rational_rank": a, "modular_rank": b, "count": n}
            for (a, b), n in sorted(histogram.items())
        ],
        "noncommuting_generators": [list(a), list(b)],
    }


def minor_fixture():
    matrix = [[1, 0, -1, 1], [1, -1, -1, 0], [0, -1, 1, 1], [1, 1, 0, -1]]
    require(determinant(matrix) == 5, "Incorrect determinant of rank-loss witness")
    require(rank(matrix) == 4 and rank(matrix, 5) == 3, "Incorrect rank-loss witness")
    require(all(sum(x * x for x in row) == 3 for row in matrix), "Incorrect norm bound")
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_result.json").read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    require(payload == {"matrix": {"prime": 5, "entries": residues(matrix, 5), "columns": 4}},
            "Jacobian payload is not bound to the integer minor")
    require(status == {"operation_id": "prime_field.matrix.rank.compute",
                       "adapter_exit_code": 0, "timeout": False}, "Adapter did not succeed")
    require(response["request"]["payload"] == payload, "Adapter request mismatch")
    require(response["result"]["operation_id"] == status["operation_id"], "Operation mismatch")
    output = response["result"]["output"]
    require(output["source"] == payload and output["rank"] == 3 and output["prime"] == 5,
            "Typed Jacobian result mismatch")
    return {
        "matrix": matrix,
        "determinant": 5,
        "r": 3,
        "q": 5,
        "rational_rank": 4,
        "modular_rank": 3,
        "divisibility": "5^(4-3) divides determinant",
        "squared_Hadamard_bound": {"determinant_squared": 25, "r_to_d": 81},
        "jacobian_operation": status["operation_id"],
        "jacobian_adapter_exit_code": 0,
    }


def local_fixture():
    group = list(itertools.permutations(range(3)))
    e, a, b = (0, 1, 2), (1, 0, 2), (0, 2, 1)
    left = [[a, b], [e, a]]
    right = [[b, e, a], [a, b, e]]
    arrays = []
    for alpha, beta in itertools.product(range(2), range(3)):
        arrays.append([
            [compose(inverse(left[u][(alpha + v) % 2]), right[v][(beta + u) % 3])
             for v in range(2)]
            for u in range(2)
        ])
    block_sum = matrix_sum((block_array(group, array) for array in arrays), 12)
    column = [
        row
        for u in range(2)
        for row in matrix_sum((regular(group, inverse(g)) for g in left[u]), 6)
    ]
    row_sums = [matrix_sum((regular(group, g) for g in right[v]), 6) for v in range(2)]
    row = [[row_sums[v][x][y] for v in range(2) for y in range(6)] for x in range(6)]
    require(block_sum == multiply(column, row), "Shifted noncommutative factorization fails")
    require(rank(block_sum, 3) <= 6, "Local rank bound fails")
    wrong = matrix_sum(
        (block_array(group, [
            [compose(right[v][(beta + u) % 3], inverse(left[u][(alpha + v) % 2]))
             for v in range(2)] for u in range(2)
        ]) for alpha, beta in itertools.product(range(2), range(3))), 12
    )
    require(residues(wrong, 3) != residues(block_sum, 3), "Reversed-order control is insensitive")
    return {
        "group": "S3", "D": 6, "q": 3, "q_divides_D": True,
        "r": 2, "s": 2, "t": 3, "block_size": 6,
        "sum_rank_mod_q": rank(block_sum, 3), "inner_dimension": 6,
        "reversed_order_changes_answer": True,
    }


def interpolation_fixture():
    q, r, h = 7, 2, 2
    marks = list(itertools.product(range(2), repeat=h))
    directions = [(1, 0), (0, 1), (1, 1), (1, 2)]
    points = list(itertools.product(range(q), repeat=h))
    lines = [
        {tuple((a[k] + t * d[k]) % q for k in range(h)) for t in range(q)}
        for a, d in zip(marks, directions)
    ]
    require(all(len(line) == q for line in lines), "A line direction vanishes")
    weights = {}
    for z in points:
        f = []
        for mark in marks:
            value = 1
            for k in range(h):
                for other in (0, 1):
                    if other != mark[k]:
                        value *= (z[k] - other) * pow((mark[k] - other) % q, -1, q)
                        value %= q
            f.append(value)
        weights[z] = [[x * y % q for y in f] for x in f]
        require(rank(weights[z], q) <= 1, "Weight rank exceeds one")
    bad_punctures = 0
    for i, (mark, line) in enumerate(zip(marks, lines)):
        unit = [[int(j == i and k == i) for k in range(4)] for j in range(4)]
        require(weights[mark] == unit, "Lagrange evaluation fails")
        expected = residues([[-x for x in row] for row in unit], q)
        actual = residues(matrix_sum((weights[z] for z in line if z != mark), 4), q)
        require(actual == expected, "Own-mark punctured line sum fails")
        wrong = residues(matrix_sum((weights[z] for z in line if z not in marks), 4), q)
        bad_punctures += int(wrong != expected)
    require(bad_punctures > 0, "All-marks deletion control is insensitive")
    for degree in range(q - 1):
        require(sum(pow(t, degree, q) for t in range(q)) % q == 0, "Power sum fails")
    require(sum(pow(t, q - 1, q) for t in range(q)) % q == q - 1,
            "Degree-threshold control fails")

    rotation = tuple((x + 1) % 7 for x in range(7))
    reflection = tuple((-x) % 7 for x in range(7))
    identity = tuple(range(7))
    rotations = [tuple((x + t) % 7 for x in range(7)) for t in range(7)]
    group = sorted(set(rotations + [compose(g, reflection) for g in rotations]))
    require(len(group) == 14 and len(group) % q == 0, "Wrong dihedral order")
    require(compose(rotation, reflection) != compose(reflection, rotation), "Dihedral control commutes")
    arrays = [
        [[identity, rotation], [reflection, identity]],
        [[rotation, identity], [identity, reflection]],
        [[reflection, rotation], [identity, identity]],
        [[identity, reflection], [rotation, identity]],
    ]
    checked = [check_array(group, array, q) for array in arrays]
    ys = [item[0] for item in checked]
    size = r * len(group)
    z_values = {
        z: matrix_sum((ys[i] for i in range(4) if z in lines[i] and z != marks[i]), size)
        for z in points
    }
    for j, k in itertools.product(range(4), repeat=2):
        tensor_block = [[0] * size for _ in range(size)]
        for z in points:
            coefficient = weights[z][j][k]
            for a in range(size):
                for b in range(size):
                    tensor_block[a][b] += coefficient * z_values[z][a][b]
        expected = [[-ys[j][a][b] if j == k else 0 for b in range(size)] for a in range(size)]
        require(residues(tensor_block, q) == residues(expected, q), "Full tensor identity fails")
    return {
        "q": q, "D": 14, "q_divides_D": True, "group": "dihedral_order_14",
        "h": h, "S": [0, 1], "r": r, "N": 4, "m": len(points),
        "marks": [list(a) for a in marks], "directions": [list(d) for d in directions],
        "entry_degree_bound": 4, "required_strict_degree_threshold": 6,
        "line_certificates": 4, "weight_rank_bound": 1,
        "tensor_shape": [4 * size, 4 * size],
        "tensor_entries_checked": 16 * size * size,
        "array_ranks": [{"rational": a, "mod_q": b} for _, a, b in checked],
        "all_marks_deletion_fails_on_lines": bad_punctures,
        "budget_satisfied": False,
        "budget_comparison": "Nr/4=2 < 2m=98; this is a supporting identity fixture, not admissible strict-budget data.",
    }


def formal_core_evidence():
    result = json.loads((ROOT / "lean_check.json").read_text())
    recording = json.loads((ROOT / "lean_verify_result.json").read_text())["kernel"]
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The formal core has no successful compiler run")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "The formal core has proof holes or an unsuccessful axiom audit")
    source = (ROOT / "Main.lean").read_bytes()
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"],
            "The compiler run is stale for Main.lean")
    require(hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"],
            "The compiler run is stale for statement fidelity")
    recorded = recording["recorded"]
    require(recording["refusals"] == [] and recorded is not None, "Mechanical recording was refused")
    require(recorded["subject"]["subject_id"] == "Q_FORMAL_CORE"
            and recorded["tier"] == "mechanical" and recorded["verdict"] == "supports"
            and recorded["produced_by"] == "lean_evidence/lean 4.31.0",
            "The mechanical verdict has the wrong claim, tier, verdict, or compiler")
    archived = json.loads((ROOT.parent.parent / recorded["artifact"]).read_text())
    require(archived["lean_source"]["text"] == source.decode()
            and archived["statement_fidelity"]["text"] == fidelity,
            "The archived source or reading differs from the current formalization")
    require(archived["subject"] == recorded["subject"]
            and archived["lean_check"]["source_sha256"] == result["source_sha256"]
            and archived["lean_check"]["statement_fidelity_sha256"] == result["statement_fidelity_sha256"],
            "The archived certificate is not bound to the recorded compiler result")
    return {
        "claim": "Q_FORMAL_CORE",
        "compiler": recorded["produced_by"],
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "archived_certificate": recorded["artifact"],
        "scope": "Universal algebraic core only; analytic rank and integer-minor arguments remain prose proofs.",
        "statement_fidelity_independent_review": "not established by this script",
    }


def certificate():
    return {
        "claim": "Q_OBSTRUCTION",
        "result_class": "universal_verification_with_prose_proof_and_formal_algebraic_core",
        "universal_proof": "research/quotient_uniform/proof.md",
        "formal_core": "research/quotient_uniform/Main.lean",
        "statement_fidelity": "research/quotient_uniform/statement_fidelity.md",
        "hypotheses": [
            "q prime; h,r>=1; q>r; nonempty S subset F_q; P=F_q^h",
            "Distinct grid marks, nonzero line directions, 2h(|S|-1)<q-1",
            "Outside E every punctured incidence set has the two stated Cartesian blocks",
            "Shifted group factorizations in the exact order L inverse then R",
            "Nr/4>2|P|+r|E| (the proof also permits weak inequality)",
        ],
        "conclusion": "For every finite group, some rectangular word is identity; no assumption on q dividing its order.",
        "scope_exclusions": [
            "No incidence-existence theorem is certified here.",
            "No geometric nontriviality or hyperbolicity theorem is certified here.",
            "Finite fixtures do not establish the universal theorem.",
            "The Lean core is not a formalization of the analytic rank or integral-minor argument.",
            "Novelty, publishability and independent review are not self-certified.",
        ],
        "formal_core_evidence": formal_core_evidence(),
        "fixtures": {
            "exhaustive_S3_arrays": permutation_fixture(),
            "integer_minor": minor_fixture(),
            "local_factorization": local_fixture(),
            "interpolation_and_tensor": interpolation_fixture(),
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    computed = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == computed, "Stored certificate differs from replay")
    print(json.dumps({
        "ok": True, "claim": computed["claim"],
        "exact_S3_arrays": computed["fixtures"]["exhaustive_S3_arrays"]["arrays_satisfying_all_rectangles"],
        "q_divides_D_fixtures": 3,
        "tensor_entries": computed["fixtures"]["interpolation_and_tensor"]["tensor_entries_checked"],
        "formal_core": "Lean 4.31.0, exit_code=0, proof_holes=[]; current source and fidelity",
        "universal_argument": "proof.md; finite fixtures are not a universal proof",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
