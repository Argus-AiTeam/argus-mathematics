#!/usr/bin/env python3
"""Replay the exact parameter certificate, not the spectral proof."""

from fractions import Fraction
from hashlib import sha256
from itertools import combinations, combinations_with_replacement, permutations
import json
from math import comb, gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(name):
    return json.loads((ROOT / name).read_text(encoding="utf-8"))


def sub(left, right):
    return tuple(a - b for a, b in zip(left, right, strict=True))


def add(left, right):
    return tuple(a + b for a, b in zip(left, right, strict=True))


def basis(label, order):
    return tuple(int(item == label) for item in order)


def overlap_form(a, b, low, high, order):
    rank = {label: index for index, label in enumerate(order)}
    left = max((a, low), key=rank.__getitem__)
    right = min((b, high), key=rank.__getitem__)
    if rank[right] <= rank[left]:
        return (0,) * len(order)
    return sub(basis(right, order), basis(left, order))


def nonnegative_on_order(form):
    if sum(form) != 0:
        return False
    return all(sum(form[index:]) >= 0 for index in range(1, len(form)))


def orders_for(chains):
    labels = tuple(label for chain in chains for label in chain)
    require(len(set(labels)) == len(labels), "Endpoint labels must be distinct.")
    for order in permutations(labels):
        rank = {label: index for index, label in enumerate(order)}
        if all(
            all(rank[a] < rank[b] for a, b in zip(chain, chain[1:]))
            for chain in chains
        ):
            yield order


def universal_arithmetic(certificate):
    data = certificate["universal_arithmetic"]
    split = data["adjacent_overlap_additivity"]
    split_count = 0
    for order in orders_for(split["ordered_chains"]):
        whole = overlap_form("a", "c", "l", "u", order)
        first = overlap_form("a", "b", "l", "u", order)
        second = overlap_form("b", "c", "l", "u", order)
        require(whole == add(first, second), f"Additivity failed on {order}.")
        require(nonnegative_on_order(whole), f"Negative overlap on {order}.")
        split_count += 1
    require(split_count == split["order_cones"] == split["zero_residuals"] == 10,
            "The complete set of adjacent-interval order cones was not covered.")

    positive = data["two_positive_intervals_give_break"]
    separation_count = 0
    possible_count = 0
    for order in orders_for(positive["ordered_chains"]):
        first = overlap_form("a", "b", "l", "u", order)
        second = overlap_form("c", "d", "l", "u", order)
        separation_count += 1
        if not any(first) or not any(second):
            continue
        possible_count += 1
        lower_gap = sub(basis("b", order), basis("l", order))
        upper_gap = sub(basis("u", order), basis("b", order))
        require(nonnegative_on_order(sub(lower_gap, first)),
                f"The positive first overlap does not force l<b on {order}.")
        require(nonnegative_on_order(sub(upper_gap, second)),
                f"The positive second overlap does not force b<u on {order}.")
    require(separation_count == positive["order_cones"] == 15,
            "The separated-interval order cones were not all covered.")
    require(possible_count == positive["potentially_positive_pair_cones"] == 4,
            "The positive-overlap cases differ from the certificate.")

    order = ("zero", "l", "u", "one")
    require(overlap_form("zero", "one", "l", "u", order) ==
            sub(basis("u", order), basis("l", order)),
            "The unit-interval normalization identity failed.")
    require(data["normalization_order_cones"] == 1, "Wrong normalization count.")
    empty_count = 0
    for order in orders_for((("a",), ("l", "u"))):
        require(not any(overlap_form("a", "a", "l", "u", order)),
                f"A zero-length mass interval contributes on {order}.")
        empty_count += 1
    require(empty_count == data["empty_interval_order_cones"] == 3,
            "The empty-interval cases were not all covered.")
    return {"additivity_order_cones": split_count,
            "separation_order_cones": separation_count}


def overlap(a, b, low, high):
    return max(Fraction(0), min(b, high) - max(a, low))


def slicing(masses, factors):
    require(factors > 0, "Slicing requires a positive number of factors.")
    require(all(x >= 0 for x in masses) and sum(masses) == 1,
            "The input is not a simplex point.")
    endpoints = [Fraction(0)]
    for mass in masses:
        endpoints.append(endpoints[-1] + mass)
    return tuple(
        tuple(factors * overlap(a, b, Fraction(r, factors), Fraction(r + 1, factors))
              for a, b in zip(endpoints, endpoints[1:]))
        for r in range(factors)
    )


def compositions(total, parts):
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, parts - 1):
            yield (first, *rest)


def pushforward(masses, alpha, target_dimension):
    return tuple(sum((mass for mass, image in zip(masses, alpha, strict=True)
                      if image == target), Fraction(0))
                 for target in range(target_dimension + 1))


def bounded_simplices(certificate):
    data = certificate["bounded_experiments"]
    denominator = data["simplex_grid_denominator"]
    source_max = data["max_source_simplex_dimension"]
    target_max = data["max_target_simplex_dimension"]
    factors_max = data["max_smash_factors"]
    require((denominator, source_max, target_max, factors_max) == (6, 3, 3, 5),
            "The declared finite experiment bounds have changed.")
    instances = naturalities = subsets = 0
    for j in range(source_max + 1):
        for weights in compositions(denominator, j + 1):
            masses = tuple(Fraction(x, denominator) for x in weights)
            for factors in range(1, factors_max + 1):
                result = slicing(masses, factors)
                bad = {r for r, point in enumerate(result)
                       if sum(x > 0 for x in point) != 1}
                require(all(sum(point) == 1 and all(x >= 0 for x in point)
                            for point in result), "An output left the simplex.")
                require(len(bad) <= j, "The nonvertex bound failed.")
                instances += 1
                for n in range(j + 1, factors + 1):
                    for restricted in combinations(range(factors), n):
                        require(any(r not in bad for r in restricted),
                                "The restricted union did not collapse.")
                        subsets += 1
                for k in range(target_max + 1):
                    for alpha in combinations_with_replacement(range(k + 1), j + 1):
                        target = slicing(pushforward(masses, alpha, k), factors)
                        transported = tuple(pushforward(point, alpha, k)
                                            for point in result)
                        require(transported == target,
                                f"Naturality failed for j={j}, k={k}, alpha={alpha}.")
                        naturalities += 1
    expected_instances = factors_max * sum(comb(denominator + j, j)
                                           for j in range(source_max + 1))
    require(instances == data["sliced_simplex_instances"] == expected_instances == 600,
            "The finite simplex instances were not all checked.")
    require(naturalities == data["monotone_map_instances"] == 29170,
            "The finite monotone maps were not all checked.")
    require(subsets == data["restricted_subset_instances"] == 1555,
            "The finite restricted-coordinate sets were not all checked.")
    return {"simplex_instances": instances, "monotone_maps": naturalities,
            "restricted_subsets": subsets}


def negative_controls(certificate):
    sharp = slicing((Fraction(1, 4), Fraction(3, 4)), 2)
    require(sum(sum(x > 0 for x in point) != 1 for point in sharp) == 1,
            "The sharpness control for the bound j was lost.")
    diagonal = ((Fraction(1, 2), Fraction(1, 2)),) * 2
    require(sum(sum(x > 0 for x in point) != 1 for point in diagonal) > 1,
            "The naive diagonal should fail the j=1, ell=2 vertex bound.")
    require(overlap(1, 1, 0, 1) != overlap(1, 0, 0, 1) + overlap(0, 1, 0, 1),
            "The a<=b hypothesis control should fail without that hypothesis.")
    masses = (Fraction(1, 4), Fraction(3, 4))
    nonmonotone = (1, 0)
    require(tuple(pushforward(point, nonmonotone, 1)
                  for point in slicing(masses, 2)) !=
            slicing(pushforward(masses, nonmonotone, 1), 2),
            "Naturality is in Delta, not in the category of all finite-set maps.")
    require(certificate["bounded_experiments"]["negative_controls"] == 4,
            "The negative control count changed.")
    return 4


def matrix_rank(matrix):
    rows = [list(map(Fraction, row)) for row in matrix]
    pivot_row = 0
    for col in range(len(rows[0])):
        pivot = next((r for r in range(pivot_row, len(rows)) if rows[r][col]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = rows[pivot_row][col]
        rows[pivot_row] = [value / scale for value in rows[pivot_row]]
        for r in range(len(rows)):
            if r != pivot_row:
                scale = rows[r][col]
                rows[r] = [a - scale * b
                           for a, b in zip(rows[r], rows[pivot_row], strict=True)]
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return pivot_row


def replay_jacobian(certificate):
    data = certificate["retired_route_diagnostic"]
    payload = read_json(data["payload"])
    typed = read_json(data["typed_output"])
    status = read_json(data["adapter_status"])
    require(status["exit_code"] == 0, "The adapter did not complete successfully.")
    require(status["operation_id"] == data["operation_id"], "Wrong adapter operation.")
    require(typed["server"]["version"] == data["server_version"] == "0.14.0",
            "The retained Jacobian server version is not the inspected version.")
    require(typed["protocol_version"] == data["protocol_version"] == "2025-11-25",
            "The retained adapter protocol changed.")
    require(typed["request"]["operation_id"] == data["operation_id"] ==
            typed["result"]["operation_id"] == "chain_complex.homology.compute",
            "The retained typed result is for a different operation.")
    require(typed["request"]["payload"] == payload, "Payload and response differ.")
    source = payload["complex"]
    require(source["coefficient_field"] == "QQ" and source["basis_sizes"] == [3, 3]
            and source["degree_min"] == 0 and source["degree_max"] == 1,
            "The diagnostic chain complex changed.")
    matrix = [[int(x) for x in row] for row in source["differential_matrices"][0]]
    require(matrix == [[-1, 0, 1], [1, -1, 0], [0, 1, -1]],
            "The oriented circle boundary matrix changed.")
    require(matrix_rank(matrix) == 2, "The circle boundary rank is not two.")
    cycle = data["integral_kernel_generator"]
    require(cycle == [1, 1, 1] and
            all(sum(a * b for a, b in zip(row, cycle, strict=True)) == 0
                for row in matrix), "The primitive integral loop is not a cycle.")
    minor_gcd = 0
    for r, s in combinations(range(3), 2):
        for c, d in combinations(range(3), 2):
            minor_gcd = gcd(minor_gcd, matrix[r][c] * matrix[s][d] -
                            matrix[r][d] * matrix[s][c])
    require(minor_gcd == 1, "The image lattice was not certified primitive.")
    output = typed["result"]["output"]
    require(output["complex"] == {**source, "prime": None},
            "The output did not retain the exact source complex.")
    expected = [
        {"degree": 0, "cycle_rank": 3, "boundary_rank": 2, "betti_number": 1},
        {"degree": 1, "cycle_rank": 1, "boundary_rank": 0, "betti_number": 1},
    ]
    require(output["homology_groups"] == expected,
            "The typed homology output differs from direct exact replay.")
    require(data["betti_numbers_over_QQ"] == [1, 1], "Wrong circle Betti numbers.")
    return [1, 1]


def replay_lean_receipt(certificate):
    data = certificate["formal_core"]
    record = read_json(data["compiler_certificate"])
    source = (ROOT / data["source"]).read_bytes()
    fidelity = (ROOT / data["statement_fidelity"]).read_bytes()
    require(record["tier"] == "mechanical" and record["verdict"] == "supports"
            and record["subject"]["subject_id"] == data["claim_id"] == "C_SLICE_CORE",
            "The compiler certificate is not mechanical support for the formal core.")
    check = record["lean_check"]
    require(check["status"] == "success" and check["exit_code"] == 0
            and check["audit_exit_code"] == 0 and check["proof_holes"] == [],
            "The retained compiler run does not establish a hole-free formal core.")
    require(check["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "The retained run did not use Lean 4.31.0.")
    require(sha256(source).hexdigest() == check["source_sha256"]
            and record["lean_source"]["text"] == source.decode("utf-8"),
            "The current Lean source differs from the compiled source.")
    require(sha256(fidelity).hexdigest() == check["statement_fidelity_sha256"]
            and record["statement_fidelity"]["text"] == fidelity.decode("utf-8"),
            "The current statement-fidelity reading differs from the compiler record.")
    return {"recorded_compiler_exit_code": 0, "proof_holes": [],
            "source_and_fidelity_current": True, "compiler_reexecuted": False}


def main():
    certificate = read_json("exact_certificate.json")
    require(certificate["schema_version"] == 1, "Unsupported certificate schema.")
    require(certificate["claim_id"] == "C_COHERENT_ADAMS_LIFT", "Wrong target claim.")
    universal = universal_arithmetic(certificate)
    finite = bounded_simplices(certificate)
    controls = negative_controls(certificate)
    diagnostic = replay_jacobian(certificate)
    lean = replay_lean_receipt(certificate)
    print(json.dumps({
        "status": "passed",
        "universal_arithmetic": universal,
        "bounded_experiments": finite,
        "negative_controls": controls,
        "circle_betti_numbers": diagnostic,
        "lean_receipt": lean,
        "spectral_theorem_machine_checked": False,
        "formal_core_requires_separate_lean_evidence": True,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
