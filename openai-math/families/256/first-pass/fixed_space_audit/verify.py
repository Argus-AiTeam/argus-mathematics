#!/usr/bin/env python3
"""Replay exact algebraic evidence; never infer a universal theorem from a sweep."""

import argparse
import itertools
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


BASE = Path(__file__).resolve().parent
PROJECT = BASE.parents[1]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def determinant(matrix):
    n = len(matrix)
    require(all(len(row) == n for row in matrix), "determinant needs a square matrix")
    a = [[Fraction(x) for x in row] for row in matrix]
    answer = Fraction(1)
    for j in range(n):
        pivot = next((i for i in range(j, n) if a[i][j]), None)
        if pivot is None:
            return Fraction(0)
        if pivot != j:
            a[j], a[pivot] = a[pivot], a[j]
            answer = -answer
        value = a[j][j]
        answer *= value
        for i in range(j + 1, n):
            ratio = a[i][j] / value
            for h in range(j + 1, n):
                a[i][h] -= ratio * a[j][h]
    return answer


def matrix_rank(matrix):
    if not matrix:
        return 0
    a = [[Fraction(x) for x in row] for row in matrix]
    require(len({len(row) for row in a}) == 1, "rank needs a rectangular matrix")
    pivot_row = 0
    for j in range(len(a[0])):
        pivot = next((i for i in range(pivot_row, len(a)) if a[i][j]), None)
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        value = a[pivot_row][j]
        for i in range(pivot_row + 1, len(a)):
            ratio = a[i][j] / value
            for h in range(j, len(a[0])):
                a[i][h] -= ratio * a[pivot_row][h]
        pivot_row += 1
        if pivot_row == len(a):
            break
    return pivot_row


def nested_columns(b):
    r = len(b)
    require(matrix_rank(b) == r, "nested-column test requires full rational row rank")
    selected = []
    for t in range(1, r + 1):
        for j in range(len(b[0])):
            if j in selected:
                continue
            columns = selected + [j]
            minor = [[b[i][h] for h in columns] for i in range(t)]
            if determinant(minor):
                selected.append(j)
                break
        require(len(selected) == t, "rank did not supply the next nested minor")
    return selected


def wedge(left, right):
    result = {}
    for a, u in left.items():
        for b, v in right.items():
            if a & b:
                continue
            inversions = sum(
                (b & ((1 << i) - 1)).bit_count()
                for i in range(a.bit_length())
                if a & (1 << i)
            )
            mask = a | b
            result[mask] = result.get(mask, 0) + (-1) ** inversions * u * v
    return {mask: sp.expand(value) for mask, value in result.items() if sp.expand(value) != 0}


def generators(k):
    return {(i, a): q for q, (i, a) in enumerate(
        (i, a) for i, size in enumerate(k) for a in range(1, size + 1)
    )}


def pullback_generator(k, b, j, a):
    indices = generators(k)
    return {
        1 << indices[i, a]: b[i][j]
        for i, size in enumerate(k)
        if size >= a and b[i][j] != 0
    }


def exterior_product(k, b, selected, columns, replacement=None):
    targets = {j: k[t] for t, j in enumerate(selected)}
    answer = {0: sp.Integer(1)}
    for j in columns:
        labels = range(1, targets.get(j, 0) + 1)
        if replacement is not None and replacement[0] == j:
            labels = replacement[1]
        for a in labels:
            answer = wedge(answer, pullback_generator(k, b, j, a))
    return answer


def block_permutation_sign(k, selected):
    exponent = sum(
        k[s] * k[t]
        for s in range(len(k))
        for t in range(s + 1, len(k))
        if selected[s] > selected[t]
    )
    return (-1) ** exponent


def coefficient_formula(k, b, selected):
    answer = sp.Integer(block_permutation_sign(k, selected))
    minors = []
    for a in range(1, max(k, default=0) + 1):
        t = sum(size >= a for size in k)
        minor = sp.Matrix([[b[i][selected[j]] for j in range(t)] for i in range(t)]).det()
        answer *= minor
        minors.append(str(minor))
    return sp.expand(answer), minors


def algebra_case(name, k, b, selected, n):
    require(k == sorted(k, reverse=True), "sizes must be normalized in nonincreasing order")
    actual = exterior_product(k, b, selected, range(n))
    predicted, minors = coefficient_formula(k, b, selected)
    top = (1 << sum(k)) - 1
    expected = {} if predicted == 0 else {top: predicted}
    require(actual == expected, f"{name}: exterior coefficient or orientation sign mismatch")
    return {
        "name": name,
        "sizes": k,
        "pivot_columns_zero_based": selected,
        "orientation_sign": block_permutation_sign(k, selected),
        "layer_determinants": minors,
        "top_coefficient": str(predicted),
    }


def occurrences_from_matrix(b):
    n = len(b[0])
    return [
        [(i, 1 if b[i][j] > 0 else -1)
         for i in range(len(b)) for _ in range(abs(b[i][j]))]
        for j in range(n)
    ]


def audit_occurrences(name, sizes, lists):
    order = sorted(range(len(sizes)), key=lambda i: -sizes[i])
    new_index = {old: new for new, old in enumerate(order)}
    k = [sizes[i] for i in order]
    lists = [[[new_index[i], sign] for i, sign in block] for block in lists]
    r, n = len(k), len(lists)
    require(n >= 1 and all(size > 0 for size in k), "invalid theorem size hypotheses")
    require(all(0 <= i < r and sign in (-1, 1) for block in lists for i, sign in block),
            "invalid signed occurrence")
    b = [[sum(sign for h, sign in block if h == i) for block in lists] for i in range(r)]
    selected = nested_columns(b)
    d = [sum(k[i] for i, _ in block) for block in lists]
    targets = [0] * n
    for t, j in enumerate(selected):
        targets[j] = k[t]
    require(all(l <= size for l, size in zip(targets, d)), "infeasible target dimension")
    require(sum(targets) == sum(k), "target dimension sum mismatch")
    require(sum(l * l for l in targets) == sum(size * size for size in k),
            "real complementary dimension mismatch")
    answer = algebra_case(name, k, b, selected, n)
    answer.update({
        "input_sizes": sizes,
        "sorted_original_rows_zero_based": order,
        "signed_occurrences": lists,
        "signed_matrix": b,
        "target_group_dimensions": d,
        "allocated_fixed_dimensions": targets,
        "rational_rank": matrix_rank(b),
    })
    shorter_count = 0
    nonzero_shorter_pullbacks = 0
    for j, l in enumerate(targets):
        for length in range(l):
            max_index = min(d[j], (l * l + 1) // 2)
            for labels in itertools.combinations(range(1, max_index + 1), length):
                if sum(2 * a - 1 for a in labels) != l * l:
                    continue
                shorter_count += 1
                term = {0: sp.Integer(1)}
                for a in labels:
                    term = wedge(term, pullback_generator(k, b, j, a))
                nonzero_shorter_pullbacks += bool(term)
                product = exterior_product(k, b, selected, range(n), (j, labels))
                require(product == {}, f"{name}: shorter incidence term survived top degree")
    answer["shorter_terms_checked"] = shorter_count
    answer["nonzero_shorter_pullbacks_killed_by_other_factors"] = nonzero_shorter_pullbacks
    return answer


def exact_occurrence_cases():
    cases = [
        ("r_zero", [], [[], []]),
        ("empty_target_and_signed_cancellation", [3],
         [[], [(0, 1), (0, -1)], [(0, -1), (0, -1), (0, 1)]]),
        ("unequal_sizes_negative_orientation", [3, 1],
         [[(0, 1), (0, -1), (1, -1)], [(0, 1), (1, 1), (0, 1)], [(0, 1)]]),
        ("equal_even_sizes_reversed_pivots", [2, 2],
         occurrences_from_matrix([[0, 1], [1, 0]])),
        ("rational_rank_without_unimodularity", [2, 1],
         occurrences_from_matrix([[2, 0], [0, -3]])),
        ("three_unequal_sizes_extra_column", [3, 2, 1],
         occurrences_from_matrix([[0, 1, 1, 0], [1, 0, 1, 0], [1, -1, 2, 1]])),
        ("shorter_term_nonzero_before_full_product", [5, 3],
         occurrences_from_matrix([[1, 1], [1, 2]])),
        ("unsorted_input_sizes", [1, 3, 2],
         occurrences_from_matrix([[1, -1, 2], [0, 1, 1], [1, 0, 1]])),
    ]
    return [audit_occurrences(*case) for case in cases]


def symbolic_cases():
    a, b, c, d = sp.symbols("a b c d")
    answers = [algebra_case("universal_2_by_2_profile_2_1", [2, 1],
                            [[a, b], [c, d]], [0, 1], 2)]
    symbols = sp.symbols("b00:03 b10:13 b20:23")
    matrix = [list(symbols[3 * i:3 * i + 3]) for i in range(3)]
    answers.append(algebra_case("universal_3_by_3_profile_3_2_1",
                                [3, 2, 1], matrix, [0, 1, 2], 3))
    answers.append(algebra_case("universal_3_by_3_reversed_columns",
                                [3, 2, 1], matrix, [2, 1, 0], 3))
    answers.append(algebra_case("rational_coefficients", [3, 1],
                                [[Fraction(1, 2), Fraction(1, 3)],
                                 [Fraction(-1), Fraction(2, 5)]], [0, 1], 2))
    return answers


def unitary_basis(d):
    result = []
    for p in range(d):
        x = sp.zeros(d)
        x[p, p] = sp.I
        result.append(x)
    for p in range(d):
        for q in range(p + 1, d):
            x = sp.zeros(d)
            x[q, p], x[p, q] = 1, -1
            result.append(x)
            x = sp.zeros(d)
            x[q, p] = x[p, q] = sp.I
            result.append(x)
    return result


def skew_coordinates(x):
    d = x.rows
    require(x + x.conjugate().T == sp.zeros(d), "tangent is not skew-Hermitian")
    coordinates = [-sp.I * x[p, p] for p in range(d)]
    for p in range(d):
        for q in range(p + 1, d):
            coordinates.extend([sp.re(x[q, p]), sp.im(x[q, p])])
    return sp.Matrix(coordinates)


def incidence_tangents():
    answers = []
    for d in range(6):
        for l in range(d + 1):
            m = d - l
            w = sp.diag(*([1] * l + [-1] * m))
            columns = []
            for x in unitary_basis(l):
                columns.append(skew_coordinates(sp.diag(x, sp.zeros(m))))
            for x in unitary_basis(m):
                columns.append(skew_coordinates(sp.diag(sp.zeros(l), x)))
            for p in range(l):
                for q in range(l, d):
                    for z in (sp.Integer(1), sp.I):
                        t = sp.zeros(d)
                        t[q, p], t[p, q] = z, -sp.conjugate(z)
                        tangent = (t * w - w * t) * w
                        require(tangent == 2 * t, "incidence commutator sign mismatch")
                        columns.append(skew_coordinates(tangent))
            matrix = sp.Matrix.hstack(*columns) if columns else sp.zeros(0)
            value = matrix.det()
            require(matrix.shape == (d * d, d * d), "wrong tangent dimensions")
            require(abs(value) == 2 ** (2 * l * m), "incidence transversality failed")
            answers.append({"d": d, "l": l, "real_jacobian_determinant": str(value)})
    return answers


def rational_function(value):
    variables = [sp.Symbol(name) for name in value["variables"]]

    def polynomial(data):
        return sum(
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"]) *
            sp.prod(x ** exponent for x, exponent in zip(variables, term["exponents"]))
            for term in data["terms"]
        )

    return polynomial(value["numerator"]) / polynomial(value["denominator"])


def jacobian_replay():
    payload = json.loads((BASE / "jacobian_payload.json").read_text())
    response = json.loads((BASE / "jacobian_result.json").read_text())
    require(response["tool"] == "math.run", "not a Jacobian execution")
    require("error" not in response and "error" not in response["result"],
            "Jacobian returned a structured error, not evidence")
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(response["result"]["operation_id"] == "matrix.symbolic.determinant.compute",
            "unexpected Jacobian operation")
    output = response["result"]["output"]
    require(output["method"] == "SYMPY_BAREISS", "unexpected determinant method")
    matrix = sp.Matrix([[rational_function(x) for x in row]
                        for row in payload["matrix"]["entries"]])
    a, b, c, d = sp.symbols("a b c d")
    result = rational_function(output["determinant"])
    require(sp.expand(result - matrix.det()) == 0, "typed determinant replay mismatch")
    require(sp.expand(result - a * (a * d - b * c)) == 0,
            "typed determinant does not equal the unequal-size profile coefficient")
    return {
        "operation_id": response["result"]["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "adapter_status": "success",
        "structured_error": None,
        "timeout": False,
        "typed_determinant": str(sp.expand(result)),
    }


def negative_controls():
    singular = algebra_case("rank_deficient_coefficient_zero", [2, 1],
                             [[1, 1], [2, 2]], [0, 1], 2)
    require(singular["top_coefficient"] == "0", "rank-negative control did not vanish")
    x = sp.Symbol("x", nonzero=True)
    p = sp.Matrix([[0, 1], [-1, 0]])
    f = sp.diag(x, 1 / x) * p
    require(p.T * p == sp.eye(2), "negative-control P is not unitary")
    require(sp.simplify((f - sp.eye(2)).det()) == 2, "rank-zero obstruction failed")
    return {
        "singular_algebra": singular,
        "omitted_rank_hypothesis": {
            "k": [1],
            "signed_occurrences": [[[0, 1], [0, -1]]],
            "B": [[0]],
            "P": [[0, 1], [-1, 0]],
            "det_F_minus_I": "2",
            "classification": "negative control only; violates the manuscript's rank hypothesis",
        },
    }


def exact_replays():
    return {
        "signed_occurrence_cases": exact_occurrence_cases(),
        "symbolic_and_rational_coefficient_cases": symbolic_cases(),
        "incidence_tangent_cases": incidence_tangents(),
        "jacobian": jacobian_replay(),
        "negative_controls": negative_controls(),
    }


def recorded_lean_certificate():
    state = json.loads((PROJECT / "research/MATH_STATE.json").read_text())
    claims = [c for c in state["claims"] if c["claim_id"] == "L_FS_FORMAL"]
    require(bool(claims), "the universal algebraic claim is not recorded")
    claim = max(claims, key=lambda c: c["version"])
    source = (BASE / "Main.lean").read_text()
    fidelity = (BASE / "statement_fidelity.md").read_text()
    require(claim["formal_statement"] == source, "ledger formalization is stale")
    matches = []
    for path in sorted((BASE / "certificates").glob("L_FS_FORMAL-*.json")):
        certificate = json.loads(path.read_text())
        result = certificate["lean_check"]
        if (certificate["subject"]["content_hash"] == claim["content_hash"]
                and certificate["lean_source"]["text"] == source
                and certificate["statement_fidelity"]["text"] == fidelity
                and certificate["verdict"] == "supports"
                and result["status"] == "success"
                and result["exit_code"] == 0
                and result["proof_holes"] == []):
            matches.append((path, certificate))
    require(len(matches) == 1, "need exactly one current successful native Lean certificate")
    path, certificate = matches[0]
    result = certificate["lean_check"]
    require("4.31.0" in result["tools"]["lean"]["version"], "wrong Lean compiler version")
    return {
        "claim": "L_FS_FORMAL",
        "native_certificate": str(path.relative_to(BASE)),
        "compiler_version": result["tools"]["lean"]["version"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "scope": "universal rational exterior algebra, unequal finite layers, and shorter products",
        "not_formalized": "unitary topology, incidence geometry, and existence of an intersection",
    }


def build_certificate():
    require((BASE / "report.md").is_file(), "the universal mathematical proof is missing")
    require((BASE / "literature.md").is_file(), "the topological prerequisites are missing")
    return {
        "claim": "C_FS",
        "result_class": "universal_verification_with_formal_algebraic_core",
        "manuscript_refutation_identified": False,
        "mathematical_proof": "report.md",
        "statement_fidelity": "statement_fidelity.md",
        "independent_review_required": True,
        "novelty": "not claimed; bounded primary-source comparison only",
        "full_arbitrary_group_theorem": "not settled by this scoped certificate",
        "formal_core": recorded_lean_certificate(),
        "exact_replays": exact_replays(),
        "interpretation": (
            "The Lean theorems are universal. The finite and fixed-size symbolic replays "
            "are adversarial checks, not a proof of the topological theorem."
        ),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="generate the certificate after a successful native Lean run")
    args = parser.parse_args()
    actual = build_certificate()
    path = BASE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    recorded = json.loads(path.read_text())
    require(recorded == actual, "exact certificate differs from deterministic replay")
    print("Exact certificate verified: universal Lean core; exact adversarial replays; topology in report.")


if __name__ == "__main__":
    main()
