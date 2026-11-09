#!/usr/bin/env python3
"""Replay the exact algebra in REPORT.md; no external packages or network."""

import argparse
import copy
import json
import sys
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
N = 4
CELLS = [(i, j) for i in range(N) for j in range(N)]
WEIGHTS = [i + j + 1 for i, j in CELLS]


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def reduce_word(word):
    result = []
    for letter in word:
        if result and result[-1] == -letter:
            result.pop()
        else:
            result.append(letter)
    return tuple(result)


def inverse(word):
    return tuple(-letter for letter in reversed(word))


def product(*words):
    return reduce_word(letter for word in words for letter in word)


def substitute(word, images):
    return reduce_word(
        letter
        for generator in word
        for letter in (
            images[generator] if generator > 0 else inverse(images[-generator])
        )
    )


def gid(cell):
    return N * cell[0] + cell[1] + 1


def shift_images(axis):
    return {
        gid(cell): (gid(tuple((x + (axis == k)) % N for k, x in enumerate(cell))),)
        for cell in CELLS
    }


def sign_images(b):
    return {
        gid(cell): (-gid(tuple((b[k] - cell[k]) % N for k in range(2))),)
        for cell in CELLS
    }


def difference_basis():
    shifts = [shift_images(0), shift_images(1)]
    words = {}
    initial = (1,)
    for j in range(N):
        word = initial
        for i in range(N):
            words[gid((i, j))] = word
            word = product(substitute(word, shifts[0]), inverse(word))
        initial = product(substitute(initial, shifts[1]), inverse(initial))
    old_in_new = {}
    for cell in sorted(CELLS, key=lambda x: (sum(x), x)):
        index = gid(cell)
        word = words[index]
        require(word[0] == index, "difference basis is not triangular")
        require(
            all(abs(letter) in old_in_new for letter in word[1:]),
            "triangular tail uses a not-yet-defined generator",
        )
        old_in_new[index] = product(
            (index,), inverse(substitute(word[1:], old_in_new))
        )
    for index in words:
        require(substitute(words[index], old_in_new) == (index,), "basis inverse")
        require(substitute(old_in_new[index], words) == (index,), "reverse inverse")
    return words, old_in_new, shifts


def magnus(word, weights, cutoff):
    terms = {(): 0}
    for letter in word:
        variable = abs(letter)
        weight = weights[variable - 1]
        updated = dict(terms)
        for monomial, degree in terms.items():
            repetitions = min(1, (cutoff - degree) // weight) if letter > 0 else (
                (cutoff - degree) // weight
            )
            for count in range(1, repetitions + 1):
                new = monomial + (variable,) * count
                if new in updated:
                    del updated[new]
                else:
                    updated[new] = degree + count * weight
        terms = updated
    require(terms.get(()) == 0, "a group word lost its constant term")
    return {monomial: degree for monomial, degree in terms.items() if monomial}


def raising_record(error_word, cell):
    weight = sum(cell) + 1
    expansion = magnus(error_word, WEIGHTS, weight + 1)
    require(all(d >= weight + 1 for d in expansion.values()), "degree-raising failure")
    return {
        "generator": list(cell),
        "weight": weight,
        "error_word_length": len(error_word),
        "first_allowed_degree": weight + 1,
        "terms_in_first_allowed_degree": [list(m) for m in sorted(expansion)],
    }


def toggle(result, item):
    if item in result:
        result.remove(item)
    else:
        result.add(item)


def ring_multiply(left, right):
    result = set()
    for a, b in left:
        for c, d in right:
            if a + c < N and b + d < N:
                toggle(result, (a + c, b + d))
    return result


def ring_power(poly, exponent):
    result = {(0, 0)}
    for _ in range(exponent):
        result = ring_multiply(result, poly)
    return result


def ring_sigma(poly, b):
    prefactor = ring_multiply(
        ring_power({(0, 0), (1, 0)}, b[0]),
        ring_power({(0, 0), (0, 1)}, b[1]),
    )
    x_inverse = {(k, 0) for k in range(1, N)}
    y_inverse = {(0, k) for k in range(1, N)}
    result = set()
    for i, j in poly:
        value = ring_multiply(ring_power(x_inverse, i), ring_power(y_inverse, j))
        result ^= ring_multiply(prefactor, value)
    return result


def differential(poly, b):
    result = set()
    for i, j in poly:
        if (b[0] + i) % 2 and i + 1 < N:
            toggle(result, (i + 1, j))
        if (b[1] + j) % 2 and j + 1 < N:
            toggle(result, (i, j + 1))
    return result


def vector(poly):
    return sum(1 << (gid(cell) - 1) for cell in poly)


def word_vector(word):
    result = 0
    for letter in word:
        result ^= 1 << (abs(letter) - 1)
    return result


def echelon(vectors):
    pivots = {}
    for value in vectors:
        while value:
            pivot = value.bit_length() - 1
            if pivot in pivots:
                value ^= pivots[pivot]
            else:
                pivots[pivot] = value
                break
    return list(pivots.values())


def rank(vectors):
    return len(echelon(vectors))


def columns_as_rows(columns, size):
    return [[(column >> row) & 1 for column in columns] for row in range(size)]


def complement(b):
    u = {(1, 0)} if b[0] % 2 else {(0, 1)}
    if b[0] % 2 and b[1] % 2:
        u.add((0, 1))
    v = {(0, 1)} if b[0] % 2 else {(1, 0)}
    return [
        (a + j + 1, ring_multiply(ring_power(u, a), ring_power(v, j)))
        for a in range(0, N, 2)
        for j in range(N)
    ]


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "prime_field.matrix.rank.compute"
    chosen = [p for _, p in complement((1, 0))]
    columns = [vector(p) for p in chosen + [differential(p, (1, 0)) for p in chosen]]
    expected = {"matrix": {"prime": 2, "columns": 16, "entries": columns_as_rows(columns, 16)}}
    require(payload == expected, "Jacobian payload is not the C,dC matrix")
    require(status == {"exit_code": 0, "timed_out": False, "operation_id": operation},
            "Jacobian run did not finish successfully")
    require(contract["result"]["operation"]["operation_id"] == operation, "wrong contract")
    require(result["request"] == {"operation_id": operation, "payload": payload},
            "typed result has a different request")
    require(result["result"]["operation_id"] == operation, "wrong executed operation")
    output = result["result"]["output"]
    require(output == {"prime": 2, "rank": 16, "source": payload}, "wrong typed rank")
    for envelope in (contract, result):
        require(envelope["server"]["version"] == "0.14.0", "uninspected server version")
        require(envelope["protocol_version"] == "2025-11-25", "unexpected protocol")
    require(rank(columns) == output["rank"], "local and adapter ranks differ")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "rank": output["rank"],
        "exit_code": status["exit_code"],
        "timed_out": status["timed_out"],
    }


def check_basis_and_involution():
    words, old_in_new, shifts = difference_basis()
    translations = {}
    for axis, shift in enumerate(shifts):
        records = []
        for cell in CELLS:
            original = words[gid(cell)]
            error = substitute(product(substitute(original, shift), inverse(original)),
                               old_in_new)
            records.append(raising_record(error, cell))
        translations["T" + str(axis + 1)] = records
    involutions = []
    for b in CELLS:
        if b[0] % 2 == 0 and b[1] % 2 == 0:
            continue
        images = sign_images(b)
        records = []
        for cell in CELLS:
            original = words[gid(cell)]
            image = substitute(substitute(original, images), old_in_new)
            require(word_vector(image) == vector(ring_sigma({cell}, b)),
                    "nonlinear and polynomial Frattini actions disagree")
            error = product(image, (-gid(cell),))
            records.append(raising_record(error, cell))
            full_error = ring_sigma({cell}, b) ^ {cell}
            leading = {term for term in full_error if sum(term) == sum(cell) + 1}
            require(leading == differential({cell}, b), "incorrect differential")
            require(not differential(differential({cell}, b), b), "d^2 is nonzero")
        chosen = complement(b)
        c = [vector(p) for _, p in chosen]
        dc = [vector(differential(p, b)) for _, p in chosen]
        sigma_c = [vector(ring_sigma(p, b)) for _, p in chosen]
        require(rank(c + dc) == 16, "C plus dC is not a basis")
        require(rank(c + sigma_c) == 16, "g and sigma(g) fail to generate")
        require(rank([vector(differential({cell}, b)) for cell in CELLS]) == 8,
                "differential is not acyclic")
        fixed_points = [h for h in CELLS if all((2 * h[k] - b[k]) % N == 0
                                               for k in range(2))]
        require(not fixed_points, "admissible sign has a fixed disk")
        involutions.append({
            "b": list(b),
            "rank_C_dC": 16,
            "rank_C_sigmaC": 16,
            "rank_d": 8,
            "chosen_g": [
                {"weight": weight, "word_in_difference_basis": [gid(x) for x in sorted(p)]}
                for weight, p in chosen
            ],
            "nonlinear_degree_checks": records,
        })
    return {
        "old_basis_in_difference_basis": [list(old_in_new[i]) for i in range(1, 17)],
        "difference_basis_in_old_basis": [list(words[i]) for i in range(1, 17)],
        "two_sided_free_group_inverse": True,
        "translations": translations,
        "all_12_admissible_displacements": involutions,
        "excluded_even_displacement_example": {
            "b": [0, 0],
            "fixed_disks": [list(h) for h in CELLS if (2 * h[0]) % N == 0
                            and (2 * h[1]) % N == 0],
            "rank_sigma_minus_identity": rank([
                vector(ring_sigma({cell}, (0, 0)) ^ {cell}) for cell in CELLS
            ]),
        },
    }


def check_universal_word_certificates():
    triangular = {i: (i + 1, i) for i in range(1, 4)}
    triangular[4] = (4,)
    third = (1,)
    for _ in range(3):
        third = substitute(third, triangular)
    fourth = substitute(third, triangular)
    actual = dict(triangular)
    actual[4] = (5, 4)
    require(substitute(third, actual) == product((5,), fourth), "cyclic endpoint identity")
    endpoint_error = product(fourth, (-1,))
    require(not magnus(endpoint_error, [1, 2, 3, 4], 4), "cyclic endpoint degree")
    boundary_error = (3, 1, -3, 4, 3, -1, 2, -3, -4, -2)
    require(not magnus(boundary_error, [1, 2, 1, 2], 2), "weight-two boundary error")
    commuting_left = product((4, 3), inverse((2, 1)))
    commuting_right = product((4,), (3, -1), (-2,))
    require(commuting_left == commuting_right, "commuting-difference identity")
    return {
        "cyclic_fourth_formal_word": list(fourth),
        "cyclic_extra_difference_is_left_prefix": True,
        "cyclic_error_has_no_weight_at_most_4": True,
        "boundary_error_word_in_a_c_w_e": list(boundary_error),
        "boundary_variable_weights": [1, 2, 1, 2],
        "boundary_error_has_no_weight_at_most_2": True,
        "commuting_difference_free_word": list(commuting_left),
        "scope": "Formal free words; degree bounds survive every filtration-respecting substitution.",
    }


def check_lattice_and_finite_group():
    def omega(h):
        return (-h[1] % N, (h[0] - h[1]) % N)

    def ompow(h, j):
        for _ in range(j):
            h = omega(h)
        return h

    def group_multiply(g, h):
        sign = -1 if g[2] else 1
        return ((g[0] + sign * h[0]) % N, (g[1] + sign * h[1]) % N,
                g[2] ^ h[2])

    def action(g, j, h):
        sign = -1 if g[2] else 1
        t = ompow(g[:2], j)
        return tuple((sign * h[k] + t[k]) % N for k in range(2))

    elements = [(x, y, e) for x, y in CELLS for e in range(2)]
    index = {g: i for i, g in enumerate(elements)}
    multiplication = [[index[group_multiply(g, h)] for h in elements] for g in elements]
    permutations = []
    for g in elements:
        permutations.append(tuple(j * 16 + gid(action(g, j, h)) - 1
                                  for j in range(3) for h in CELLS))
    require(len(set(permutations)) == 32, "finite action is not faithful")
    for g in elements:
        for h in elements:
            gh = group_multiply(g, h)
            for j in range(3):
                for cell in CELLS:
                    require(action(g, j, action(h, j, cell)) == action(gh, j, cell),
                            "marking actions do not compose")
    for h in CELLS:
        require(ompow(h, 3) == h, "omega^3")
        second = omega(omega(h))
        require(all((h[k] + omega(h)[k] + second[k]) % N == 0 for k in range(2)),
                "omega^2+omega+1")
    nonzero_two_torsion = [(2, 0), (0, 2), (2, 2)]
    require([ompow((2, 0), j) for j in range(3)] == nonzero_two_torsion,
            "wrong nonzero two-torsion orbit")
    e = [(Fraction(1, 2), Fraction(0)), (Fraction(0), Fraction(1, 2)),
         (Fraction(-1, 2), Fraction(-1, 2))]
    displacements = [[int(-2 * coordinate) % N for coordinate in point] for point in e]
    require(displacements == [[3, 0], [0, 3], [1, 1]], "wrong sign displacement")
    local = (3, 0, 1)
    require(group_multiply(local, local) == (0, 0, 0), "local finite action is not order two")
    require(all(action(local, j, h) != h for j in range(3) for h in CELLS),
            "local circuit has a fixed marking")

    def algebra_multiply(left, right):
        result = 0
        while left:
            bit = left & -left
            a = bit.bit_length() - 1
            left ^= bit
            remaining = right
            while remaining:
                bit_b = remaining & -remaining
                b = bit_b.bit_length() - 1
                remaining ^= bit_b
                result ^= 1 << multiplication[a][b]
        return result

    one = 1 << index[(0, 0, 0)]
    generators = [one ^ (1 << index[g]) for g in [(1, 0, 0), (0, 1, 0), (0, 0, 1)]]
    layer = [1 << i for i in range(32)]
    dimensions = [32]
    for _ in range(8):
        layer = echelon(algebra_multiply(v, g) for v in layer for g in generators)
        dimensions.append(len(layer))
    require(dimensions == [32, 31, 28, 23, 16, 9, 4, 1, 0], "augmentation filtration")
    pbw = []
    for i, j in CELLS:
        for k in range(2):
            value = one
            for generator, exponent in zip(generators, (i, j, k)):
                for _ in range(exponent):
                    value = algebra_multiply(value, generator)
            pbw.append(value)
    require(rank(pbw) == 32, "group-algebra normal forms are not a basis")
    grid = [(x, y) for x in range(6) for y in range(6)]
    two = {h for h in grid if all((2 * c) % 6 == 0 for c in h)}
    kernel = {h for h in grid if (h[0] + h[1]) % 6 == 0
              and (2 * h[1] - h[0]) % 6 == 0}
    quotient_orbits = {min(h, tuple((-c) % 6 for c in h)) for h in two | kernel}
    require(len(two) == 4 and len(kernel) == 3 and two & kernel == {(0, 0)}
            and len(quotient_orbits) == 5, "parameter puncture count")
    return {
        "omega_lattice_matrix": [[0, -1], [1, -1]],
        "pair_centers_mod_lattice": [[str(c) for c in point] for point in e],
        "actual_displacements_for_selected_access_paths": displacements,
        "parameter_punctures": 5,
        "parameter_rank": 4,
        "ranks": {"F": 7, "K": 97, "Pi": 47, "L": 48, "Pi_pair": 24},
        "finite_action_model": "C4^2 semidirect inversion C2; block j uses omega^j translation",
        "finite_action_order": 32,
        "local_circuit": list(local),
        "local_circuit_marking_transpositions": 24,
        "augmentation_power_dimensions": dimensions,
        "augmentation_nilpotence_index": 8,
        "marking_permutations": [list(p) for p in permutations],
    }


def fraction_data(value):
    return {"numerator": value.numerator, "denominator": value.denominator}


def check_cost():
    t = Fraction(49, 200)
    p = sum(3 * t ** (i + j + 1) for i, j in CELLS)
    g = 3 * t * (1 + t) * (1 + t * t) ** 2
    require(p == (1 + t) * g, "incorrect generator-relation polynomial")
    require(t * t > Fraction(3, 50), "source rational lower bound")
    require(g > Fraction(102817827, 100000000) > Fraction(257, 250),
            "insufficient involution margin")
    budget = Fraction(1, 100)
    j = 8
    q = 4 * t
    cost = 97 * t * q ** j / (1 - q)
    while cost >= budget:
        j += 1
        cost *= q
    require(cost / q >= budget, "claimed first admissible depth is not minimal")
    margin = 1 - g + 2 * budget
    require(margin < Fraction(-1, 125), "nonnegative complete relator bound")
    return {
        "t": fraction_data(t),
        "P_coefficients_degrees_1_to_7": [3, 6, 9, 12, 9, 6, 3],
        "G_coefficients_degrees_1_to_6": [3, 3, 6, 6, 3, 3],
        "P_at_t": fraction_data(p),
        "G_at_t": fraction_data(g),
        "first_depth_J_with_monodromy_cost_below_1_over_100": j,
        "finite_geometric_action_killed_by_D": 8,
        "monodromy_cost": fraction_data(cost),
        "upper_bound_after_both_budgets": fraction_data(margin),
        "boundary_power_rule": "For b finite, choose 2^e >= bit_length(b)+7.",
        "universal_extension": "n=2^r, r>=2; G_n=3t(1+t^2+...+t^(n-2))(1+t+...+t^(n-1)) >= G_4.",
    }


def build_certificate():
    adapter = check_jacobian()
    return {
        "claim": "S_DYADIC",
        "result_kind": "exact algebraic certificate supporting the universal prose theorem",
        "scope": "Actual surface-family quotient and its dyadic extension; neither manuscript main theorem.",
        "independent_review": "pending",
        "formal_kernel_verification": False,
        "lattice_and_finite_action": check_lattice_and_finite_group(),
        "universal_word_certificates": check_universal_word_certificates(),
        "weighted_free_group": check_basis_and_involution(),
        "weighted_deficiency": check_cost(),
        "jacobian": adapter,
    }


def validate_certificate(candidate, expected):
    candidate_json = json.dumps(candidate, sort_keys=True, separators=(",", ":"))
    expected_json = json.dumps(expected, sort_keys=True, separators=(",", ":"))
    require(candidate_json == expected_json, "certificate differs from exact recomputation")


def mutation_tests(expected):
    mutations = [
        ("wrong geometric displacement", ["lattice_and_finite_action",
                                         "actual_displacements_for_selected_access_paths", 0, 0], 0),
        ("missing cyclic endpoint", ["universal_word_certificates",
                                    "cyclic_extra_difference_is_left_prefix"], False),
        ("wrong involution rank", ["weighted_free_group", "all_12_admissible_displacements",
                                  0, "rank_C_sigmaC"], 15),
        ("wrong deep-relation depth", ["weighted_deficiency",
                                      "first_depth_J_with_monodromy_cost_below_1_over_100"], 8),
        ("altered weighted margin", ["weighted_deficiency", "upper_bound_after_both_budgets",
                                    "numerator"], 1),
        ("inexact depth type", ["weighted_deficiency",
                               "first_depth_J_with_monodromy_cost_below_1_over_100"],
         float(expected["weighted_deficiency"]["first_depth_J_with_monodromy_cost_below_1_over_100"])),
        ("wrong logical type", ["formal_kernel_verification"], 0),
    ]
    for name, path, value in mutations:
        altered = copy.deepcopy(expected)
        target = altered
        for key in path[:-1]:
            target = target[key]
        target[path[-1]] = value
        try:
            validate_certificate(altered, expected)
        except VerificationError:
            continue
        raise VerificationError("accepted mutation: " + name)
    return len(mutations)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=HERE / "exact_certificate.json")
    parser.add_argument("--write", action="store_true", help="write the recomputed certificate")
    args = parser.parse_args()
    expected = build_certificate()
    rejected = mutation_tests(expected)
    if args.write:
        args.certificate.write_text(json.dumps(expected, indent=2) + "\n")
    candidate = json.loads(args.certificate.read_text())
    validate_certificate(candidate, expected)
    j = expected["weighted_deficiency"]["first_depth_J_with_monodromy_cost_below_1_over_100"]
    print(f"PASS: exact nonlinear algebra, 12 sign displacements, D_8 finite-action kernel; "
          f"J={j}; {rejected} altered certificates rejected.")
    print("Universal geometric and pro-2 arguments are in REPORT.md; independent review is pending.")


if __name__ == "__main__":
    try:
        main()
    except (VerificationError, OSError, json.JSONDecodeError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
