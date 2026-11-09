#!/usr/bin/env python3
"""Exact degree-five algebra; geometric and spectral applications are human proofs."""

import argparse
from fractions import Fraction
from itertools import combinations, permutations, product
import json
from math import comb
from pathlib import Path
import runpy


HERE = Path(__file__).resolve().parent
RESEARCH = HERE.parents[1]
HELPERS = runpy.run_path(
    str(RESEARCH / "rational-unit-obstruction" / "verify.py"),
    run_name="degree_five_matrix_helpers",
)
multiply = HELPERS["matrix_product"]
commutator = HELPERS["matrix_commutator"]
trace_three = HELPERS["trace_form"]
rank = HELPERS["rank"]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def sign(indices):
    return (-1) ** sum(a > b for i, a in enumerate(indices) for b in indices[i + 1:])


PERMUTATIONS = [(p, sign(p)) for p in permutations(range(5))]


def elementary(i, j):
    result = [[0] * 3 for _ in range(3)]
    result[i][j] = 1
    return result


def trace_five(arguments):
    result = 0
    for p, parity in PERMUTATIONS:
        value = arguments[p[0]]
        for i in p[1:]:
            value = multiply(value, arguments[i])
        result += parity * sum(value[i][i] for i in range(3))
    return result


def evaluate(coboundary, cochain):
    return [sum(a * b for a, b in zip(row, cochain)) for row in coboundary]


def source_primitive():
    basis = HELPERS["sl_basis"](3)
    triples = list(combinations(range(8), 3))
    fives = list(combinations(range(8), 5))
    omega_three = [trace_three(*(basis[i] for i in c)) for c in triples]
    omega_five = [trace_five([basis[i] for i in c]) for c in fives]
    d3 = HELPERS["ce_differential"](basis, 3)
    d4 = HELPERS["ce_differential"](basis, 4)
    d5 = HELPERS["ce_differential"](basis, 5)
    d7 = HELPERS["ce_differential"](basis, 7)
    require(not any(evaluate(d3, omega_three)), "The degree-three pairing cocycle is not closed")
    require(not any(evaluate(d5, omega_five)), "The degree-five trace is not closed")
    require(not any(entry for row in d7 for entry in row), "Top coboundaries need not vanish")
    wedge = 0
    index_five = {c: i for i, c in enumerate(fives)}
    for c, value in zip(triples, omega_three):
        complement = tuple(i for i in range(8) if i not in c)
        wedge += sign(c + complement) * value * omega_five[index_five[complement]]
    require(wedge != 0, "The primitive's top pairing does not prove nonexactness")
    ranks = [rank(d4), rank(d5)]
    require(56 - sum(ranks) == 1, "The source degree-five line is not unique")
    return {
        "sl3_basis": basis,
        "omega5_values_in_lexicographic_wedge_basis": omega_five,
        "cocycle_checked_on_six_tuples": comb(8, 6),
        "degree_four_and_five_coboundary_ranks_over_Q": ranks,
        "H5_dimension_over_Q": 56 - sum(ranks),
        "omega3_wedge_omega5_top_value": wedge,
        "degree_seven_coboundary_zero": True,
        "Huber_Kings_p3_normalization": str(Fraction(1, 30)),
        "normalization_is_rational_not_mod_five": True,
    }


def chain_differential(basis, coordinates, degree):
    n = len(basis)
    targets = list(combinations(range(n), degree - 1))
    sources = list(combinations(range(n), degree))
    target_index = {c: i for i, c in enumerate(targets)}
    rows = [[0] * len(sources) for _ in targets]
    for column, c in enumerate(sources):
        for i, j in combinations(range(degree), 2):
            bracket = commutator(basis[c[i]], basis[c[j]])
            remaining = tuple(c[k] for k in range(degree) if k not in (i, j))
            for h, (a, b) in enumerate(coordinates):
                if h in remaining or not bracket[a][b]:
                    continue
                key = tuple(sorted((h,) + remaining))
                rows[target_index[key]][column] += (
                    (-1) ** (i + j) * sign((h,) + remaining) * bracket[a][b]
                )
    return rows


def mixed_and_parabolic():
    coordinates = [(0, 0), (0, 1), (1, 0), (1, 1), (2, 2)]
    levi = [elementary(i, j) for i, j in coordinates]
    parabolic = levi + [elementary(0, 2), elementary(1, 2)]
    values = [
        trace_five([parabolic[i] for i in c])
        for c in combinations(range(7), 5)
    ]
    require(not any(values), "A mixed or unipotent parabolic contribution survived")
    for a, b in product(parabolic, repeat=2):
        ab = multiply(a, b)
        kernel = multiply([row[:2] for row in a[:2]], [row[:2] for row in b[:2]])
        require([row[:2] for row in ab[:2]] == kernel, "The kernel product does not factor")
        require(ab[2][2] == a[2][2] * b[2][2], "The quotient product does not factor")
        require(ab[2][:2] == [0, 0], "The parabolic is not multiplicatively closed")

    mixed = 0
    for e_index in range(5):
        for triple in combinations([i for i in range(5) if i != e_index], 3):
            h_index = next(i for i in range(5) if i not in (e_index,) + triple)
            e = levi[e_index][0][0] + levi[e_index][1][1]
            h = levi[h_index][2][2]
            mixed += (
                sign((e_index,) + triple + (h_index,))
                * e * trace_three(*(levi[i] for i in triple)) * h
            )
    require(mixed == -2, "The mixed degree-five class was accidentally discarded")
    differentials = [chain_differential(levi, coordinates, d) for d in range(1, 6)]
    ranks = [rank(d) for d in differentials]
    dimensions = [comb(5, d) for d in range(6)]
    homology = [
        dimensions[d] - ([0] + ranks)[d] - (ranks + [0])[d]
        for d in range(6)
    ]
    require(homology == [1, 2, 1, 1, 2, 1], "Wrong full-Levi cohomology")
    require(not any(row[0] for row in differentials[-1]), "The top mixed class is a boundary")

    parent = HERE.parent
    payload = json.loads((parent / "degree-five-jacobian-payload.json").read_text())
    response = json.loads((parent / "degree-five-jacobian-output.json").read_text())
    status = json.loads((parent / "degree-five-jacobian-status.json").read_text())
    operation = "lie_algebra.chevalley_eilenberg.complex.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter failed")
    require(status["timed_out"] is False, "Jacobian timed out")
    require(status["structured_error"] is None, "Jacobian returned a structured error")
    require(response["request"]["operation_id"] == operation, "Wrong requested operation")
    require(response["result"]["operation_id"] == operation, "Wrong returned operation")
    require(response["request"]["payload"] == payload, "Jacobian used another payload")
    typed = response["result"]["output"]
    require(typed["lie_algebra"] == payload["lie_algebra"], "Output lost its Lie-algebra source")
    expected_constants = [
        [
            [commutator(a, b)[i][j] % 5 for i, j in coordinates]
            for b in levi
        ]
        for a in levi
    ]
    require(payload["lie_algebra"]["structure_constants"] == expected_constants,
            "The typed bracket is not the actual mixed Levi bracket")
    require(typed["group_dimensions"] == dimensions, "Wrong typed chain dimensions")
    require(len(typed["differentials"]) == 5, "Incomplete Jacobian chain complex")
    for degree, (exact, item) in enumerate(zip(differentials, typed["differentials"]), 1):
        require(item["degree"] == degree, "Jacobian changed differential order")
        require(item["matrix"]["prime"] == 5, "Wrong Jacobian coefficient field")
        require(item["matrix"]["columns"] == comb(5, degree), "Wrong typed matrix shape")
        require(item["matrix"]["entries"] == [[x % 5 for x in row] for row in exact],
                "Jacobian and characteristic-zero differential definitions disagree")
    return {
        "parabolic_matrix_unit_positions": [
            list(position) for position in coordinates + [(0, 2), (1, 2)]
        ],
        "parabolic_multiplication_basis_checks": 49,
        "all_parabolic_five_wedge_values": values,
        "mixed_e_wedge_omega3_wedge_h_value": mixed,
        "mixed_class_mod_five_value": mixed % 5,
        "levi_differential_ranks_over_Q": ranks,
        "levi_cohomology_dimensions": homology,
        "jacobian": {
            "operation_id": operation,
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "adapter_exit_code": status["adapter_exit_code"],
            "timed_out": status["timed_out"],
            "structured_error": status["structured_error"],
            "all_five_typed_differentials_match": True,
            "scope": "The five-dimensional Levi over F_5, not a p-adic group or spectrum",
        },
    }


def degree_and_weight_checks():
    def entries(stem, bound):
        return [
            [s, t] for s in range(bound + 1) for t in range(-24, 25, 8)
            if t - s == stem
        ]
    require(entries(-5, 9) == [[5, 0]], "The source primitive is not on a unique edge")
    require(entries(-5, 5) == [[5, 0]], "The completed target has another degree-five edge")
    require(entries(-4, 5) == [[4, 0]], "The target Milnor term has another edge")
    possible_differentials = [r for r in range(2, 10) if (r - 1) % 8 == 0]
    require(possible_differentials == [9], "Wrong periodicity bound")
    require(5 + 9 > 9 and 5 - 9 < 0, "A source differential can touch (5,0)")
    weights = [pow(2, exponent, 5) for exponent in (-1, -2)]
    require(weights == [3, 4], "Wrong ordinary support characters")
    require(all((weight - 1) % 5 for weight in weights), "A removed support row survives")
    source_degrees = HELPERS["exterior_degrees"]((-1, -3, -5))
    k1_degrees = [-1, 0]
    outer_degrees = sorted(k1_degrees + [d - 1 for d in k1_degrees])
    require(-5 not in outer_degrees and -6 not in outer_degrees,
            "K(1) localization of the first block can change the comparison line")
    require(source_degrees.count(-5) == 1, "The source degree-minus-five line is not unique")
    return {
        "source_degree_minus_five_edges": entries(-5, 9),
        "target_degree_minus_five_edges": entries(-5, 5),
        "target_degree_minus_four_edges": entries(-4, 5),
        "ordinary_removed_support_central_weights_mod_five": weights,
        "geometric_degree_five_projective_row_weights": [0, -1, -2],
        "possible_differentials_into_Drinfeld_bottom_5_0": [[3, 1], [2, 2]],
        "K1_first_block_rational_degrees": outer_degrees,
        "spectrum_level_machine_checked": False,
    }


def replay():
    return {
        "result_class": "exact_algebraic_verification",
        "scope": "New degree-five trace, every mixed/unipotent direction, and bridge degree arithmetic",
        "source_primitive": source_primitive(),
        "full_parabolic_and_mixed_line": mixed_and_parabolic(),
        "spectral_degree_arithmetic": degree_and_weight_checks(),
        "human_application": {
            "proof": "proof.md",
            "claim": "C318LEVELCZERO",
            "asserted_actual_scalar": 0,
            "asserted_ordinary_level": 2,
            "geometric_and_spectral_proofs_machine_checked": False,
            "independent_review_required": True,
            "publication_novelty_certified": False,
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = replay()
    certificate = HERE / "exact_certificate.json"
    if args.write:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    if args.check:
        require(json.loads(certificate.read_text()) == result, "The stored exact certificate differs")
    print(json.dumps({
        "ok": True,
        "parabolic_five_wedges_checked": 21,
        "mixed_degree_five_class_value": result["full_parabolic_and_mixed_line"]["mixed_e_wedge_omega3_wedge_h_value"],
        "source_top_pairing": result["source_primitive"]["omega3_wedge_omega5_top_value"],
        "source_H5_dimension": result["source_primitive"]["H5_dimension_over_Q"],
        "spectra_machine_checked": False,
    }))


if __name__ == "__main__":
    main()
