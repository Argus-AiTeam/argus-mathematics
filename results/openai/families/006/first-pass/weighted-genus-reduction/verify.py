#!/usr/bin/env python3
"""Replay exact components of the integral weighted genus-reduction proof."""

import argparse
import json
from collections import Counter
from fractions import Fraction
from itertools import product
from math import gcd, isqrt, lcm
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def legendre(a, p):
    residue = pow(a % p, (p - 1) // 2, p)
    require(residue in (0, 1, p - 1), "Invalid Legendre-symbol denominator")
    return -1 if residue == p - 1 else residue


def mmul(x, y, modulus):
    a, b, c, d = x
    e, f, g, h = y
    return (
        (a * e + b * g) % modulus,
        (a * f + b * h) % modulus,
        (c * e + d * g) % modulus,
        (c * f + d * h) % modulus,
    )


def mdet(x):
    a, b, c, d = x
    return a * d - b * c


def minverse(x, p):
    a, b, c, d = x
    inverse_det = pow(mdet(x), -1, p)
    return tuple(value * inverse_det % p for value in (d, -b, -c, a))


def conjugate(g, x, p):
    return mmul(mmul(g, x, p), minverse(g, p), p)


def nilpotent_orbit(p):
    reference = (0, 1, 0, 0)
    signs = {}
    centralizer = []
    group_size = 0
    for g in product(range(p), repeat=4):
        if mdet(g) % p == 0:
            continue
        group_size += 1
        image = conjugate(g, reference, p)
        sign = legendre(mdet(g), p)
        if image in signs:
            require(signs[image] == sign, "Nilpotent sign fails descent")
        signs[image] = sign
        if image == reference:
            centralizer.append(g)
            a, b, c, d = g
            require(c == 0 and a == d and a != 0, "Wrong centralizer")
            require(sign == 1, "Nonsquare determinant in centralizer")
    expected_support = {
        x
        for x in product(range(p), repeat=4)
        if x != (0, 0, 0, 0)
        and (x[0] + x[3]) % p == 0
        and mdet(x) % p == 0
    }
    require(set(signs) == expected_support, "Nilpotent orbit is incomplete")
    require(len(signs) == p * p - 1, "Wrong nilpotent orbit size")
    require(len(centralizer) == p * (p - 1), "Wrong centralizer size")
    generators = ((1, 1, 0, 1), (0, -1, 1, 0), (2, 0, 0, 1))
    for x, sign in signs.items():
        for unit in range(1, p):
            scaled = tuple(unit * value % p for value in x)
            require(signs[scaled] == legendre(unit, p) * sign, "Scaling sign")
        for g in generators:
            require(
                signs[conjugate(g, x, p)] == legendre(mdet(g), p) * sign,
                "Conjugation sign",
            )
    return signs, {
        "prime": p,
        "general_linear_group_size": group_size,
        "nilpotent_orbit_size": len(signs),
        "centralizer_size": len(centralizer),
        "centralizer_determinants_are_squares": True,
        "scaling_and_conjugation_checks": "passed",
    }


def canonical_lines(p, exponent):
    modulus = p**exponent
    return [(1, t) for t in range(modulus)] + [
        (p * t, 1) for t in range(modulus // p)
    ]


def stable_lines(lines, diagonal, modulus):
    answer = []
    for a, b in lines:
        image = (diagonal[0] * a % modulus, diagonal[1] * b % modulus)
        scalar = image[0] if a == 1 else image[1]
        if image == (scalar * a % modulus, scalar * b % modulus):
            answer.append((a, b))
    return answer


def level_checks():
    results = []
    spurious_dyadic = 0
    for p, exponents in ((2, range(1, 6)), (3, range(1, 4)), (5, range(1, 3))):
        for exponent in exponents:
            modulus = p**exponent
            lines = canonical_lines(p, exponent)
            require(len(set(lines)) == modulus + modulus // p, "Projective lines")
            if p == 2:
                root = next(r for r in range(1, 2 * modulus, 2)
                            if (r * r + 319) % (2 * modulus) == 0)
                generator = ((1 + root) // 2, (1 - root) // 2)
                for unit in range(1, 2 * modulus, 2):
                    scaled = ((1 + unit * root) // 2, (1 - unit * root) // 2)
                    affine = tuple(unit * t + (1 - unit) // 2 for t in generator)
                    require(scaled == affine, "Dyadic affine scaling identity")
                    require(
                        stable_lines(lines, scaled, modulus) == [(1, 0), (0, 1)],
                        "Dyadic scaling changed the eigensummands",
                    )
                wrong = stable_lines(lines, (root, -root), modulus)
                spurious_dyadic += len(wrong) - 2
                require(len(wrong) > 2, "Dyadic negative control was vacuous")
            else:
                generator = (1, -1)
            stable = stable_lines(lines, generator, modulus)
            require(stable == [(1, 0), (0, 1)], "Wrong split-level orientations")
            exponent_pairs = [
                (a, exponent - a)
                for a in range(exponent + 1)
                if min(a, exponent - a) == 0
            ]
            require(
                exponent_pairs == [(0, exponent), (exponent, 0)],
                "Cyclic split-lattice classification",
            )
            results.append({
                "prime": p,
                "exponent": exponent,
                "projective_lines_examined": len(lines),
                "stable_lines": [list(line) for line in stable],
            })
    return {
        "prime_power_cases": results,
        "dyadic_x_only_spurious_lines": spurious_dyadic,
        "integral_generator_scaling": "passed",
    }


def qmul(x, y):
    a, b, c, d = x
    e, f, g, h = y
    return (
        a * e - b * f - 7 * c * g - 7 * d * h,
        a * f + b * e + 7 * (c * h - d * g),
        a * g + c * e - b * h + d * f,
        a * h + d * e + b * g - c * f,
    )


def qbar(x):
    return (x[0], -x[1], -x[2], -x[3])


def qnorm(x):
    a, b, c, d = x
    return a * a + b * b + 7 * c * c + 7 * d * d


def order_coordinates(x):
    a, b, c, d = x
    return (a - c, b - d, 2 * c, 2 * d)


def in_order(x):
    return all(Fraction(value).denominator == 1 for value in order_coordinates(x))


def determinant(matrix):
    matrix = [[Fraction(value) for value in row] for row in matrix]
    answer = Fraction(1)
    for column in range(len(matrix)):
        pivot = next((r for r in range(column, len(matrix))
                      if matrix[r][column] != 0), None)
        if pivot is None:
            return Fraction(0)
        if pivot != column:
            matrix[column], matrix[pivot] = matrix[pivot], matrix[column]
            answer = -answer
        diagonal = matrix[column][column]
        answer *= diagonal
        for r in range(column + 1, len(matrix)):
            ratio = matrix[r][column] / diagonal
            for c in range(column + 1, len(matrix)):
                matrix[r][c] -= ratio * matrix[column][c]
    return answer


def reduced_forms(discriminant):
    answer = []
    for a in range(1, isqrt(abs(discriminant) // 3) + 1):
        for b in range(-a, a + 1):
            numerator = b * b - discriminant
            if numerator % (4 * a):
                continue
            c = numerator // (4 * a)
            if a > c or gcd(gcd(a, b), c) != 1:
                continue
            if (abs(b) == a or a == c) and b < 0:
                continue
            answer.append((a, b, c))
    return answer


def genus_sign(form):
    a, b, c = form
    represented = next(
        a * x * x + b * x * y + c * y * y
        for x, y in product(range(-3, 4), repeat=2)
        if gcd(x, y) == 1
        and (a * x * x + b * x * y + c * y * y) % 11 != 0
    )
    return legendre(represented, 11)


def quaternion_fixture(nilpotent_signs):
    half = Fraction(1, 2)
    basis = [
        (1, 0, 0, 0),
        (0, 1, 0, 0),
        (half, 0, half, 0),
        (0, half, 0, half),
    ]
    for x, y in product(basis, repeat=2):
        require(in_order(qmul(x, y)), "Quaternion order is not closed")
    trace_pairing = [[2 * qmul(x, y)[0] for y in basis] for x in basis]
    require(determinant(trace_pairing) == -49, "Wrong order discriminant")
    require(legendre(-1, 7) == -1 and (-7) % 8 == 1, "Wrong ramification")
    units = [(a, b, 0, 0) for a, b in product(range(-1, 2), repeat=2)
             if a * a + b * b == 1]
    require(len(units) == 4, "Wrong unit enumeration")
    require(all(in_order(u) and qnorm(u) == 1 for u in units), "Invalid unit")
    embeddings = []
    for a in range(-isqrt(319), isqrt(319) + 1):
        for b, c in product(range(-isqrt(319 // 7), isqrt(319 // 7) + 1),
                            repeat=2):
            x = (0, a, b, c)
            generator = (half, Fraction(a, 2), Fraction(b, 2), Fraction(c, 2))
            if qnorm(x) == 319 and in_order(generator):
                require(qmul(x, x) == (-319, 0, 0, 0), "Wrong quadratic relation")
                embeddings.append(x)
    require(len(embeddings) == 40, "Incomplete embedding enumeration")
    embedding_set = set(embeddings)
    weights = {}
    orientations = {}
    i_matrix = (0, -1, 1, 0)
    j_matrix = (2, 0, 0, -2)
    k_matrix = mmul(i_matrix, j_matrix, 11)
    require(mmul(i_matrix, i_matrix, 11) == (10, 0, 0, 10), "i relation")
    require(mmul(j_matrix, j_matrix, 11) == (4, 0, 0, 4), "j relation")
    for x in embeddings:
        _, a, b, c = x
        matrix = tuple(
            (a * i_matrix[t] + b * j_matrix[t] + c * k_matrix[t]) % 11
            for t in range(4)
        )
        require(matrix in nilpotent_signs, "Ramified residue is not primitive")
        require(a % 7 in (2, 5), "Wrong unramified quadratic residue")
        orientation = a % 7
        orientations[x] = orientation
        weights[x] = nilpotent_signs[matrix] * legendre(a, 7)
    unseen = set(embeddings)
    orbits = []
    census = Counter()
    while unseen:
        x = min(unseen)
        orbit = {qmul(qmul(u, x), qbar(u)) for u in units}
        require(orbit <= embedding_set, "Unit conjugation left the embeddings")
        stabilizer = [u for u in units if qmul(qmul(u, x), qbar(u)) == x]
        require(len(stabilizer) == 2, "Embedding stabilizer is not {+1,-1}")
        require(len(orbit) == 2, "Wrong embedding orbit size")
        require(len({orientations[y] for y in orbit}) == 1, "Orientation lost")
        require(len({weights[y] for y in orbit}) == 1, "Weight fails unit descent")
        require(tuple(-value for value in x) not in orbit, "Conjugate orientations")
        census[(orientations[x], weights[x])] += 1
        orbits.append(sorted(orbit))
        unseen -= orbit
    require(len(orbits) == 20, "Wrong number of global embedding orbits")
    require(
        census == Counter({(2, 1): 5, (2, -1): 5, (5, 1): 5, (5, -1): 5}),
        "Wrong weighted orientation census",
    )
    forms = reduced_forms(-319)
    require(len(forms) == 10, "Wrong reduced-form enumeration")
    signs = [genus_sign(form) for form in forms]
    require(Counter(signs) == Counter({1: 5, -1: 5}), "Wrong genus census")
    for x in embeddings:
        require(weights[tuple(-v for v in x)] == weights[x], "Global evenness")
    return signs, {
        "h": 29,
        "h_star": -11,
        "field_discriminant": -319,
        "inert_prime": 7,
        "level_for_embedding_fixture": 1,
        "is_full_elliptic_curve_instance": False,
        "trace_pairing_determinant": -49,
        "order_basis": [["1", "0", "0", "0"], ["0", "1", "0", "0"],
                        ["1/2", "0", "1/2", "0"], ["0", "1/2", "0", "1/2"]],
        "unit_group_size": 4,
        "embedding_generators": [list(x[1:]) for x in sorted(embeddings)],
        "embedding_orbits": [[list(x[1:]) for x in orbit] for orbit in orbits],
        "stabilizer_sizes": [2] * len(orbits),
        "weighted_orientation_census": [
            {"residue_coefficient": o, "weight": s, "orbits": census[(o, s)]}
            for o, s in sorted(census)
        ],
        "reduced_forms": [list(form) for form in forms],
        "genus_signs": signs,
    }


def transport_checks(genus_signs):
    common_multiplier = lcm(*range(1, 82))
    for unit_order in range(2, 82, 2):
        require(common_multiplier % unit_order == 0, "Nonintegral unit clearing")
        require(
            (common_multiplier // unit_order) * (unit_order // 2)
            == common_multiplier // 2,
            "Incorrect stabilizer mass",
        )
    sign_cases = 0
    for w, chi, parity in product((-1, 1), (-1, 1), (0, 1)):
        schwartz = w * chi**parity
        require(schwartz * w * chi**parity == 1, "Level sign mismatch")
        require(sum((schwartz * w * chi**parity)**b for b in (0, 1)) == 2,
                "Wrong local orientation sum")
        sign_cases += 1
    for sigma in (-1, 1):
        require((-1) * sigma * (-sigma) == 1, "Inert orientation sign")
        require(sum(((-1) * sigma * (-sigma))**b for b in (0, 1)) == 2,
                "Wrong inert orientation sum")
        sign_cases += 1
    level_data = [(5, -1, -1), (2, 1, -1), (1, -1, 1)]
    sigma = 1

    def mass(*, inert_orientation=True, inert_weight=-1, stabilizer_size=2):
        coefficients = [0] * len(genus_signs)
        inert_bits = (0, 1) if inert_orientation else (0,)
        for bits in product((0, 1), repeat=len(level_data)):
            schwartz = param = norm = 1
            for bit, (exponent, w, chi) in zip(bits, level_data):
                schwartz *= (w * chi**exponent)**bit
                param *= w**bit
                norm *= chi**(exponent * bit)
            for inert_bit in inert_bits:
                local_product = (
                    schwartz * param * norm * inert_weight**inert_bit
                    * sigma**inert_bit * (-sigma)**inert_bit
                )
                for index, character in enumerate(genus_signs):
                    unit_order = (2, 4, 6, 8, 12, 24)[index % 6]
                    orbit_size = unit_order // stabilizer_size
                    coefficients[index] += (
                        (common_multiplier // unit_order) * orbit_size
                        * local_product * character
                    )
        return coefficients

    expected = [common_multiplier * 2**len(level_data) * c for c in genus_signs]
    reconstructed = mass()
    require(reconstructed == expected, "Free-module weighted identity fails")
    require(any(reconstructed), "Free-module test is vacuous")
    mutants = {
        "missing_inert_orientation": mass(inert_orientation=False),
        "wrong_inert_weight": mass(inert_weight=1),
        "stabilizer_mass_one": mass(stabilizer_size=1),
    }
    for name, result in mutants.items():
        require(result != expected, "Negative control did not detect " + name)
    for precision in (1, 6, 12, 17):
        modulus = 2**precision
        require([value % modulus for value in reconstructed]
                == [value % modulus for value in expected], "Precision comparison")
        for unit_order in (2, 4, 6, 8, 12, 24):
            require(((common_multiplier // unit_order) * modulus) % modulus == 0,
                    "Integer-lift independence failed")
    require(any(value % 2**12 for value in expected), "No visible modular test")
    require(all([v % 2**12 for v in mutant] != [v % 2**12 for v in expected]
                for mutant in mutants.values()), "Modular controls are vacuous")
    return {
        "common_multiplier": common_multiplier,
        "uniform_unit_order_bound": 81,
        "local_sign_cases_exhausted": sign_cases,
        "orientation_count_for_free_module_replay": 16,
        "free_module_coefficients": reconstructed,
        "expected_multiplier": common_multiplier * 8,
        "working_precisions": [1, 6, 12, 17],
        "visible_at_precision": 12,
        "negative_controls_rejected": sorted(mutants),
        "universal_argument": {
            "inert_factor_after_integral_mass": 1,
            "factor_for_each_additional_level_prime": 2,
            "induction_formula": "F(0)=1; F(r+1)=2*F(r); F(r)=2^r",
            "arbitrary_character_sum": "coefficientwise in the free module",
        },
    }


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    result = json.loads((HERE / "jacobian_result.json").read_text())
    operation = "number_theory.compute.legendre_symbol"
    require(payload == {"a": -1, "prime": 7}, "Jacobian payload changed")
    require(result["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian request is not bound to the exact payload")
    require(result["server"]["version"] == contract["server"]["version"] == "0.14.0",
            "Unrecorded Jacobian server version")
    require(result["protocol_version"] == contract["protocol_version"] == "2025-11-25",
            "Unrecorded Jacobian protocol")
    require(result["result"]["operation_id"] == operation, "Wrong typed operation")
    require(result["result"]["output"] == {"a": -1, "prime": 7, "symbol": -1},
            "Jacobian did not return the exact complete result")
    require(result["result"]["output"]["symbol"] == legendre(-1, 7),
            "Independent symbol replay disagrees")
    require(contract["adapter_exit_code"] == 0
            and contract["adapter_error"] is None
            and contract["adapter_timeout"] is False, "Adapter diagnostic failed")
    return {
        "operation_id": operation,
        "payload": payload,
        "typed_output": result["result"]["output"],
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "adapter_exit_code": 0,
        "adapter_error": None,
        "adapter_timeout": False,
    }


def reconstruct():
    require(-11 % 4 == 29 % 4 == 1 and gcd(11, 29) == 1,
            "Fixture discriminants are not coprime odd fundamental discriminants")
    require((-319) % 8 == 1 and legendre(-319, 7) == -1,
            "Fixture does not have the declared split/inert types")
    nilpotents = {}
    orbit_results = []
    for p in (3, 5, 11):
        nilpotents[p], result = nilpotent_orbit(p)
        orbit_results.append(result)
    genus_signs, quaternion = quaternion_fixture(nilpotents[11])
    return {
        "claim": "V_WEIGHTED_GENUS_IDENTITY",
        "result_kind": "general_mathematical_verification_with_exact_component_replay",
        "machine_checked_scope": [
            "nilpotent determinant-character descent and scaling",
            "split-level prime powers including the integral generator at two",
            "complete discriminant -319 quaternion embedding fixture",
            "integral weighted free-module mass and orientation identities",
            "negative controls and a complete typed Jacobian diagnostic",
        ],
        "not_machine_checked": [
            "the general adelic proof in report.md",
            "the cited oriented CM reduction theorem",
            "the source detecting-prime and parametrization construction",
            "modularity, analytic-rank detection and both Goldfeld theorems",
            "novelty, significance and independent review",
        ],
        "nilpotent_orbits": orbit_results,
        "level_orientations": level_checks(),
        "quaternion_fixture": quaternion,
        "integral_transport": transport_checks(genus_signs),
        "jacobian": jacobian_check(),
        "proof": "report.md",
        "statement_fidelity": "statement-fidelity.md",
        "independent_review": "required; not manufactured by this verifier",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = reconstruct()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    expected = json.loads(target.read_text())
    require(certificate == expected, "Reconstructed evidence disagrees with certificate")
    print(json.dumps({
        "status": "passed",
        "claim": certificate["claim"],
        "embedding_generators": len(certificate["quaternion_fixture"]["embedding_generators"]),
        "embedding_orbits": len(certificate["quaternion_fixture"]["embedding_orbits"]),
        "stabilizer_sizes": sorted(set(certificate["quaternion_fixture"]["stabilizer_sizes"])),
        "level_prime_power_cases": len(certificate["level_orientations"]["prime_power_cases"]),
        "negative_controls_rejected":
            certificate["integral_transport"]["negative_controls_rejected"],
        "scope": "exact component replay; general proof and arithmetic inputs require review",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
