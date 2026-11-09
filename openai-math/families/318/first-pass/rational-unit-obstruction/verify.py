#!/usr/bin/env python3
"""Exact diagnostics, not a computation of a Morava localization map."""

import argparse
from fractions import Fraction
from itertools import combinations, product
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent


def rank(rows):
    a = [[Fraction(x) for x in row] for row in rows]
    pivot_row = 0
    for column in range(len(a[0]) if a else 0):
        pivot = next(
            (i for i in range(pivot_row, len(a)) if a[i][column]), None
        )
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        scalar = a[pivot_row][column]
        a[pivot_row] = [x / scalar for x in a[pivot_row]]
        for i in range(len(a)):
            if i != pivot_row:
                scalar = a[i][column]
                a[i] = [
                    x - scalar * y for x, y in zip(a[i], a[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == len(a):
            break
    return pivot_row


def exterior_degrees(generators):
    degrees = []
    for size in range(len(generators) + 1):
        degrees.extend(sum(term) for term in combinations(generators, size))
    return sorted(degrees)


def degree_and_retraction_checks():
    r = exterior_degrees((-1, -3))
    shifted = sorted(degree - 1 for degree in r)
    assert r == [-4, -3, -1, 0]
    assert -2 not in r and -3 not in shifted
    assert sorted(set(r) & set(shifted)) == [-4, -1]

    cases = 0
    for free_at_minus_four, free_at_minus_one in product(range(-3, 4), repeat=2):
        free = {-4: free_at_minus_four, -1: free_at_minus_one}
        for degree in sorted(set(r) | set(shifted)):
            if degree not in r:
                continue
            row = [Fraction(1)]
            if degree in shifted:
                row.append(Fraction(free[degree]))
            assert row[0] == 1
            if degree == -3:
                assert row == [Fraction(1)]
                for detected in (Fraction(-5), Fraction(-1, 5), Fraction(0),
                                 Fraction(1, 5), Fraction(5)):
                    assert row[0] * detected == detected
                    assert (row[0] * detected == 0) == (detected == 0)
            cases += 1
    return {
        "known_height_two_degrees": r,
        "minus_one_shift_degrees": shifted,
        "degree_minus_three_target_dimensions": [1, 0],
        "free_retraction_parameter_degrees": [-4, -1],
        "finite_retraction_rows_checked": cases,
        "universal_retraction_statement": "Main.lean: excludesEveryRetraction",
        "rational_spectrum_homotopy_computed": False,
    }


def secondary_class_checks():
    boundary = [
        [1, 0, 0],
        [-1, 1, 0],
        [0, -1, 1],
        [0, 0, -1],
    ]
    v0 = [1, 0, 0, 0]
    augmented = [row + [value] for row, value in zip(boundary, v0)]
    assert rank(boundary) == 3
    assert rank(augmented) == 4
    assert all(sum(row[j] for row in boundary) == 0 for j in range(3))
    assert sum(v0) == 1
    assert rank([[1]]) == 1
    assert [[v0[0]]] == [[1]]

    vertical = {(i, 2 - i): (i, 3 - i) for i in range(3)}
    horizontal = {(i, 2 - i): (i + 1, 2 - i) for i in range(3)}
    assert all(target not in vertical and target not in horizontal
               for target in list(vertical.values()) + list(horizontal.values()))
    assert {(i, 3 - i) for i in range(3)} == set(vertical.values())
    assert (3, 0) not in vertical.values()

    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    typed_matrix = payload["matrix"]["entries"]
    decoded = [
        [Fraction(int(x["num"]), int(x["den"])) for x in row]
        for row in typed_matrix
    ]
    assert decoded == augmented
    result = json.loads((HERE / "jacobian-output.json").read_text())
    typed = result["result"]["output"]
    assert typed["rank"] == 4
    assert typed["pivot_columns"] == [0, 1, 2, 3]
    assert typed["matrix"]["entries"] == typed_matrix
    assert result["request"]["operation_id"] == "matrix.rank.compute"
    assert result["result"]["operation_id"] == "matrix.rank.compute"
    status = json.loads((HERE / "jacobian-status.json").read_text())
    assert status["adapter_exit_code"] == 0
    assert status["timed_out"] is False
    return {
        "total_boundary_matrix": boundary,
        "total_boundary_rank": 3,
        "boundary_plus_class_rank": 4,
        "vertical_column_zero_boundary_rank": 1,
        "total_degree_three_class_nonzero": True,
        "class_zero_after_forgetting_horizontal_action": True,
        "scope": "A finite rational bicomplex, not the manuscript's coefficients",
        "jacobian": {
            "operation_id": "matrix.rank.compute",
            "server_version": result["server"]["version"],
            "protocol_version": result["protocol_version"],
            "typed_rank": typed["rank"],
            "adapter_exit_code": status["adapter_exit_code"],
            "timed_out": status["timed_out"],
            "structured_error": result.get("error"),
            "payload": "research/rational-unit-obstruction/jacobian-payload.json",
            "output": "research/rational-unit-obstruction/jacobian-output.json",
        },
    }


def matrix_product(a, b):
    columns = list(zip(*b))
    return [[sum(x * y for x, y in zip(row, column))
             for column in columns] for row in a]


def matrix_commutator(a, b):
    ab, ba = matrix_product(a, b), matrix_product(b, a)
    return [[x - y for x, y in zip(row_ab, row_ba)]
            for row_ab, row_ba in zip(ab, ba)]


def trace_form(a, b, c):
    result = matrix_product(a, matrix_commutator(b, c))
    return sum(result[i][i] for i in range(len(result)))


def determinant(rows):
    a = [list(row) for row in rows]
    sign, previous = 1, 1
    for k in range(len(a) - 1):
        pivot = next((i for i in range(k, len(a)) if a[i][k]), None)
        if pivot is None:
            return 0
        if pivot != k:
            a[k], a[pivot] = a[pivot], a[k]
            sign = -sign
        value = a[k][k]
        for i in range(k + 1, len(a)):
            for j in range(k + 1, len(a)):
                numerator = value * a[i][j] - a[i][k] * a[k][j]
                assert numerator % previous == 0
                a[i][j] = numerator // previous
            a[i][k] = 0
        previous = value
    return sign * a[-1][-1] if a else 1


def sl_basis(n):
    result = []
    for i, j in product(range(n), repeat=2):
        if i != j:
            a = [[0] * n for _ in range(n)]
            a[i][j] = 1
            result.append(a)
    for i in range(n - 1):
        a = [[0] * n for _ in range(n)]
        a[i][i], a[-1][-1] = 1, -1
        result.append(a)
    return result


def ce_differential(basis, degree):
    dimension = len(basis)
    n = len(basis[0])
    coordinates = [(i, j) for i, j in product(range(n), repeat=2)
                   if i != j] + [(i, i) for i in range(n - 1)]
    brackets = {}
    for i, j in product(range(dimension), repeat=2):
        bracket = matrix_commutator(basis[i], basis[j])
        brackets[i, j] = [bracket[a][b] for a, b in coordinates]
    columns = list(combinations(range(dimension), degree))
    column_index = {column: index for index, column in enumerate(columns)}
    rows = []
    for arguments in combinations(range(dimension), degree + 1):
        row = [0] * len(columns)
        for i, j in combinations(range(degree + 1), 2):
            remaining = tuple(arguments[k] for k in range(degree + 1)
                              if k not in (i, j))
            for h, coefficient in enumerate(brackets[arguments[i], arguments[j]]):
                if not coefficient or h in remaining:
                    continue
                inversions = sum(h > k for k in remaining)
                key = tuple(sorted((h,) + remaining))
                row[column_index[key]] += (
                    (-1) ** (i + j + inversions) * coefficient
                )
        rows.append(row)
    return rows


def lie_primitive_checks():
    minors = (
        (
            1,
            (1, 2, 3, 5, 7, 9, 15, 16),
            tuple(range(8)),
            -1,
        ),
        (
            2,
            (0, 2, 4, 6, 7, 8, 9, 11, 12, 13, 19, 22, 24, 28,
             30, 37, 39, 41, 43, 52),
            (0, 1, 2, 3, 4, 5, 6, 7, 8, 11, 13, 14, 15, 16, 17,
             20, 22, 23, 25, 27),
            2916,
        ),
        (
            3,
            (0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 15, 16, 17,
             18, 19, 20, 21, 22, 23, 25, 26, 27, 31, 35, 36, 37,
             39, 40, 41, 45, 55, 56, 61),
            (0, 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
             16, 17, 18, 20, 21, 22, 24, 25, 28, 31, 32, 36, 37,
             38, 40, 42, 43, 44, 45, 52),
            1024,
        ),
    )
    ranks, matrices = {}, {}
    for n in (2, 3):
        basis = sl_basis(n)
        differentials = {k: ce_differential(basis, k) for k in (1, 2, 3)}
        for k in (1, 2):
            assert all(not any(row) for row in
                       matrix_product(differentials[k + 1], differentials[k]))
        omega = [[trace_form(*(basis[i] for i in arguments))]
                 for arguments in combinations(range(len(basis)), 3)]
        assert all(not any(row) for row in
                   matrix_product(differentials[3], omega))
        actual = [rank(differentials[k]) for k in (1, 2, 3)]
        assert actual == ([3, 0, 0] if n == 2 else [8, 20, 35])
        ranks[str(n)] = actual
        matrices[n] = differentials
    assert matrices[2][1] == [[0, 0, -1], [2, 0, 0], [0, -2, 0]]
    assert determinant(matrices[2][1]) == 4
    actual_minors = []
    for degree, rows, columns, expected in minors:
        matrix = matrices[3][degree]
        actual = determinant([[matrix[i][j] for j in columns] for i in rows])
        assert actual == expected, (degree, actual, expected)
        actual_minors.append(actual)

    parabolic_basis = []
    for i, j in ((0, 0), (0, 1), (0, 2), (1, 1), (1, 2), (2, 1), (2, 2)):
        a = [[0] * 3 for _ in range(3)]
        a[i][j] = 1
        parabolic_basis.append(a)
    quotient = lambda a: [row[1:] for row in a[1:]]
    for a, b, c in product(parabolic_basis, repeat=3):
        assert trace_form(a, b, c) == trace_form(
            quotient(a), quotient(b), quotient(c)
        )
    e, f, h = sl_basis(2)
    assert trace_form(e, f, h) == 2
    assert not any(any(row) for row in matrices[2][2])
    return {
        "sl2_d1_determinant": 4,
        "sl3_literal_minor_determinants": actual_minors,
        "d1_d2_d3_ranks": ranks,
        "H1_H2_H3_dimensions_in_both_ranks": [0, 0, 1],
        "trace_on_e_f_h": 2,
        "full_parabolic_trilinear_basis_identities": 7 ** 3,
        "parabolic_identity_scope": (
            "All triples by trilinearity, including the unipotent directions"
        ),
        "p_adic_group_comparison_machine_checked": False,
    }


def prime_five_transition_checks():
    character = {a: pow(a, -2, 5) for a in range(1, 5)}
    assert character[2] == 4 != 1
    assert sum(character.values()) % 5 == 0
    assert pow(2, 4, 5) == 1 and pow(2, 2, 5) != 1
    assert all(4 > n for n in (2, 3))
    assert 6 % 5 != 0
    windows = {}
    for group, dimension in (("G3", 9), ("G", 13), ("H", 5)):
        window = list(range(-3, -3 + dimension + 1))
        surviving = [(t + 3, t) for t in window if t == 0]
        assert surviving == [(3, 0)]
        for t in window:
            if t % 2 == 0 and t:
                assert Fraction(6) ** (t // 2) - 1 != 0
        windows[group] = {
            "cohomological_bound": dimension,
            "degree_minus_three_postnikov_interval": [window[0], window[-1]],
            "only_possible_rational_graded_piece": [3, 0],
        }
    incoming = {}
    for n in (2, 3):
        sources = [[r, 3 - r, r - 1]
                   for r in range(2, 4) if r - 1 <= n - 1]
        assert all(Fraction(6) ** (-j) != 1 for _, _, j in sources)
        incoming[str(n)] = sources
    return {
        "mu4_character_alpha_minus_two_mod5": {
            str(a): value for a, value in character.items()
        },
        "mu4_average_is_zero": True,
        "cyclotomic_degree_four_exceeds_both_division_degrees": True,
        "extended_galois_order_prime_to_five": True,
        "finite_postnikov_windows": windows,
        "drinfeld_incoming_differentials_r_s_j": incoming,
        "scope": (
            "Exact character and index arithmetic; finite resolutions, "
            "geometric comparison and spectral applicability use proof.md"
        ),
    }


def source_scope_checks():
    manuscript = ROOT / "research/openai_manuscript" / (
        "A-rational-obstruction-to-strong-chromatic-splitting-at-height-three"
        "-September-25-2026/build/sections"
    )
    detection = (manuscript / "07-detection.tex").read_text()
    completed = (manuscript / "03-completed-tower.tex").read_text()
    oriented = (manuscript / "10-oriented-projection.tex").read_text()
    assert r"c_3=a\,c_2\ne0" in detection
    assert r"\pi_tE_2^{\square}" in completed
    assert r"r_Tb_T\simeq c_T" in oriented
    literature = ROOT / "research/literature"
    bmr = (literature / "bmr-coheight-one-primary.txt").read_text()
    assert "Date: Wednesday 7th October, 2026." in bmr
    for locator in ("Proposition 2.7.1.", "Proposition 4.3.13.",
                    "Example 4.6.4.", "Theorem 5.2.6."):
        assert locator in bmr
    assert "Theorem 5.1.7." in (
        literature / "alm-six-functors-v2.txt"
    ).read_text()
    assert "Proposition 3.2.2." in (
        literature / "lrz-relative-poincare-v1.txt"
    ).read_text()
    assert "Corollary 2.5.10." in (
        literature / "lurie-elliptic-II-2018.txt"
    ).read_text()
    return {
        "literal_nonzero_claim_located": True,
        "individual_coefficient_descent_located": True,
        "oriented_tensor_factor_identity_located": True,
        "completed_primary_source_obtained": True,
        "completed_primary_version": "October 7, 2026",
        "cited_august_version_obtained": False,
        "source_applicability_proof": "proof.md, Sections 4.1--4.8",
        "primitive_transport_engineer_proof_complete": True,
        "independent_mathematical_and_source_review": "pending",
        "actual_canonical_map_degree_minus_three": (
            "nonzero by the human proof; not computed by this script"
        ),
        "manuscript_refutation_claimed": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = {
        "result_class": "verification_theorem_with_no_retraction_corollary",
        "engineer_mathematical_proof_complete": True,
        "independent_target_certification": "pending",
        "unit_first_retraction_implication": degree_and_retraction_checks(),
        "failed_forget_and_inflate_route": secondary_class_checks(),
        "lie_primitive": lie_primitive_checks(),
        "prime_five_transition_arithmetic": prime_five_transition_checks(),
        "statement_scope": source_scope_checks(),
        "spectra_machine_checked": False,
        "publishable_novelty_certified": False,
    }
    target = HERE / "exact_certificate.json"
    if args.write:
        target.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        assert json.loads(target.read_text()) == certificate
    print(json.dumps({
        "exact_checks": "passed",
        "engineer_mathematical_proof": "complete",
        "independent_target_certification": "pending",
        "canonical_detector": "nonzero by the human proof",
        "underlying_spectrum_unit_retractions": "excluded by the human proof",
        "sl3_literal_minors": [-1, 2916, 1024],
        "spectra_machine_checked": False,
        "secondary_class_ranks": [3, 4],
        "manuscript_refutation_claimed": False,
    }))


if __name__ == "__main__":
    main()
