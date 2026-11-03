#!/usr/bin/env sage-python
import argparse
import json
import sys
from pathlib import Path

from sage.all import PolynomialRing, proof, sage_eval


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

import construct_local_cover_points as local_cover


DEFAULT_LOCAL_POINTS = HERE / "local_cover_points.json"
DEFAULT_TANGENT = HERE / "global_tangent.json"
DEFAULT_OUTPUT = HERE / "cassels_tate_pairing.json"


def two_division_data(field, curve, first_mask, second_mask):
    polynomial_ring = PolynomialRing(field, "pairing_beta_polynomial")
    beta_polynomial = polynomial_ring.gen()
    _, a2, _, a4, a6 = curve.ainvs()
    polynomial = (
        beta_polynomial**3
        + a2 * beta_polynomial**2
        + a4 * beta_polynomial
        + a6
    )
    relative_field = field.extension(polynomial, "beta")
    _, generators = local_cover.parse_global_generators(field)
    first_beta = local_cover.class_element(
        first_mask, relative_field, generators
    )
    second_beta = local_cover.class_element(
        second_mask, relative_field, generators
    )
    return polynomial, relative_field, first_beta, second_beta


def parse_field_element(value, field):
    return field(
        sage_eval(
            value,
            locals={str(field.gen()): field.gen()},
        )
    )


def pairing_quadric(field, curve, relative_field, first_beta):
    _, a2, _, a4, a6 = curve.ainvs()
    source_ring = PolynomialRing(
        field, names=("U0", "U1", "U2", "T")
    )
    U0, U1, U2, T = source_ring.gens()
    reduction_ring = PolynomialRing(source_ring, "z")
    z = reduction_ring.gen()
    beta_lift = sum(
        source_ring(first_beta[index]) * z**index
        for index in range(3)
    )
    gamma = U0 + U1 * z + U2 * z**2
    cubic = z**3 + a2 * z**2 + a4 * z + a6
    remainder = (beta_lift * gamma**2) % cubic
    coefficients = remainder.list()
    coefficients += [source_ring(0)] * (3 - len(coefficients))
    _, Q1, Q2 = coefficients[:3]

    target_ring = PolynomialRing(
        relative_field, names=("U0", "U1", "U2", "T")
    )
    variables = target_ring.gens()
    coefficient_map = source_ring.hom(
        variables,
        codomain=target_ring,
        base_map=field.hom(
            relative_field, [relative_field(field.gen())]
        ),
    )
    quadric = (
        coefficient_map(Q1)
        - (relative_field(a2) + relative_field.gen())
        * coefficient_map(Q2)
        + variables[3] ** 2
    )
    return quadric, variables


def parse_tangent(
    path,
    field,
    relative_field,
    quadric,
    quadric_variables,
    expected_selmer_mask,
):
    payload = json.loads(path.read_text())
    if payload.get("selmer_mask") != expected_selmer_mask:
        raise RuntimeError(
            "the global tangent belongs to the wrong Selmer class"
        )
    tangent = payload.get("global_tangent", {})
    if (
        tangent.get("status") != "complete"
        or not tangent.get("point_certificate_unconditional")
        or not tangent.get("point_on_quadric_verified")
        or not tangent.get("tangent_contains_point_verified")
    ):
        raise RuntimeError("the global tangent certificate is not verified")
    ordered = tangent.get(
        "tangent_coefficients_U0_U1_U2_T", []
    )
    if len(ordered) != 4:
        raise RuntimeError("the global tangent has incomplete coefficients")
    names = {
        str(field.gen()): field.gen(),
        str(relative_field.gen()): relative_field.gen(),
    }
    affine_values = tangent.get(
        "affine_point_U0_U1_U2_T", []
    )
    if len(affine_values) != 4:
        raise RuntimeError("the global tangent has an incomplete base point")
    affine_point = [
        relative_field(sage_eval(value, locals=names))
        for value in affine_values
    ]
    tangent_coefficients = [
        relative_field(sage_eval(value, locals=names))
        for value in ordered
    ]
    if affine_point[3] != 1:
        raise RuntimeError("the global tangent base point is not affine")
    if quadric(*affine_point) != 0:
        raise RuntimeError("the displayed tangent point misses the quadric")
    expected_coefficients = [
        quadric.derivative(variable)(*affine_point)
        for variable in quadric_variables
    ]
    if tangent_coefficients != expected_coefficients:
        raise RuntimeError(
            "the displayed tangent is not the exact quadric gradient"
        )
    if not any(tangent_coefficients):
        raise RuntimeError("the displayed tangent is zero")
    if (
        sum(
            coefficient * coordinate
            for coefficient, coordinate in zip(
                tangent_coefficients, affine_point
            )
        )
        != 0
    ):
        raise RuntimeError("the displayed tangent misses its base point")
    return (
        tangent_coefficients,
        {
            "tangent_verified": True,
            "solver": tangent.get("solver"),
        },
    )


def primes_over_base(
    absolute_field,
    base_prime,
    rational_prime,
    base_to_absolute,
):
    extended_ideal = absolute_field.ideal(
        [
            base_to_absolute(generator)
            for generator in base_prime.gens()
        ]
    )
    return [
        prime
        for prime in absolute_field.primes_above(rational_prime)
        if extended_ideal.valuation(prime) > 0
    ]


def validate_support(field, curve, selected_places):
    rational_bad_primes = {
        int(prime)
        for prime, exponent in curve.discriminant().norm().factor()
        if exponent
    }
    expected = {2, 3, 7, 14177}
    if rational_bad_primes != expected:
        raise RuntimeError(
            f"unexpected rational bad-prime support: "
            f"{sorted(rational_bad_primes)}"
        )
    covered = {
        (place["rational_prime"], place["prime_index"])
        for place in selected_places
    }
    required = set()
    for rational_prime in expected:
        for prime_index, prime in enumerate(
            field.primes_above(rational_prime)
        ):
            if (
                rational_prime == 2
                or curve.discriminant().valuation(prime) > 0
            ):
                required.add((rational_prime, prime_index))
    if covered != required:
        raise RuntimeError("the local certificate has incomplete support")
    return sorted(rational_bad_primes)


def tangent_value(
    coefficients,
    tangent_coefficients,
    relative_field,
):
    return sum(
        tangent_coefficients[index]
        * relative_field(coefficients[index])
        for index in range(3)
    ) + tangent_coefficients[3]


def prime_valuation_at_least(value, prime, bound):
    if value == 0:
        return bound
    return int(value.valuation(prime))


def compute(
    local_points_path,
    tangent_path,
    output_path,
    first_mask=local_cover.FIRST_CLASS,
    second_mask=local_cover.SECOND_CLASS,
):
    proof.all(True)
    if first_mask == second_mask:
        raise RuntimeError("the two pairing masks must be distinct")
    local_payload = json.loads(local_points_path.read_text())
    if (
        local_payload.get("schema")
        != "argus.d1-cassels-tate-local-cover-points.v2"
    ):
        raise RuntimeError("unsupported local cover-point schema")
    if not local_payload.get("proof_flag"):
        raise RuntimeError("the local cover-point proof flag is false")
    if not local_payload.get("all_requested_places_completed"):
        raise RuntimeError("the local cover-point certificate is incomplete")
    if (
        local_payload.get("first_mask") != first_mask
        or local_payload.get("second_mask") != second_mask
    ):
        raise RuntimeError(
            "the local cover-point certificate has the wrong pairing order"
        )

    field, curve = local_cover.build_curve()
    (
        two_division,
        relative_field,
        first_beta,
        second_beta,
    ) = two_division_data(
        field, curve, first_mask, second_mask
    )
    quadric, quadric_variables = pairing_quadric(
        field, curve, relative_field, first_beta
    )
    tangent_coefficients, tangent_payload = parse_tangent(
        tangent_path,
        field,
        relative_field,
        quadric,
        quadric_variables,
        first_mask,
    )
    absolute_field = relative_field.absolute_field(
        "d1_absolute_gamma"
    )
    _, to_absolute = absolute_field.structure()

    def base_to_absolute(value):
        return to_absolute(relative_field(value))

    selected_places = local_cover.bad_places(field, curve)
    rational_bad_primes = validate_support(
        field, curve, selected_places
    )
    records_by_place = {
        (record["rational_prime"], record["prime_index"]): record
        for record in local_payload["records"]
    }
    if len(records_by_place) != len(selected_places):
        raise RuntimeError("duplicate or missing local place records")

    total_sign = 1
    place_records = []
    for place in selected_places:
        rational_prime = place["rational_prime"]
        prime_index = place["prime_index"]
        base_prime = place["prime_ideal"]
        local_record = records_by_place.get(
            (rational_prime, prime_index)
        )
        if local_record is None:
            raise RuntimeError("missing local cover-point record")
        if not (
            local_record.get("target_kummer_class_verified")
            and local_record.get("affine_cover_point_verified")
        ):
            raise RuntimeError("an unverified local cover point was supplied")
        if min(
            local_record["cover_equation_error_valuations"]
        ) <= local_record[
            "cover_coordinate_square_stability_threshold"
        ]:
            raise RuntimeError("a local cover equation lacks precision")

        low_coefficients = [
            parse_field_element(value, field)
            for value in local_record[
                "global_cover_coefficients_low"
            ]
        ]
        high_coefficients = [
            parse_field_element(value, field)
            for value in local_record[
                "global_cover_coefficients_high"
            ]
        ]
        low_line = tangent_value(
            low_coefficients,
            tangent_coefficients,
            relative_field,
        )
        high_line = tangent_value(
            high_coefficients,
            tangent_coefficients,
            relative_field,
        )
        if low_line == 0 or high_line == 0:
            raise RuntimeError(
                "a cover approximation lies on the tangent hyperplane"
            )
        absolute_low_line = to_absolute(low_line)
        absolute_high_line = to_absolute(high_line)
        component_primes = primes_over_base(
            absolute_field,
            base_prime,
            rational_prime,
            base_to_absolute,
        )
        orbit_records = {
            record["absolute_prime"]: record
            for record in local_record["orbit_records"]
        }
        minimum_orbit_precisions = local_record.get(
            "minimum_orbit_cover_precisions", []
        )
        if len(minimum_orbit_precisions) != 2:
            raise RuntimeError(
                "the local orbit precision gates are missing"
            )
        if {str(prime) for prime in component_primes} != set(
            orbit_records
        ):
            raise RuntimeError(
                "the replayed local two-division orbits changed"
            )

        component_records = []
        place_sign = 1
        for component_prime in component_primes:
            source_record = orbit_records[str(component_prime)]
            if not (
                source_record[
                    "high_ratio_is_exact_local_square"
                ]
                and source_record[
                    "low_to_high_ratio_is_exact_local_square"
                ]
                and source_record[
                    "stable_against_actual_local_value"
                ]
            ):
                raise RuntimeError(
                    "the local point lacks a stable Kummer certificate"
                )
            if (
                source_record[
                    "low_orbit_cover_equation_error_valuation"
                ]
                < minimum_orbit_precisions[0]
                or source_record[
                    "high_orbit_cover_equation_error_valuation"
                ]
                < minimum_orbit_precisions[1]
            ):
                raise RuntimeError(
                    "the exact ideal-CRT cover equation lacks precision"
                )
            line_ratio_is_square = (
                absolute_low_line / absolute_high_line
            ).is_padic_square(component_prime)
            line_difference_valuation = prime_valuation_at_least(
                absolute_low_line - absolute_high_line,
                component_prime,
                1000,
            )
            high_line_valuation = int(
                absolute_high_line.valuation(component_prime)
            )
            relative_error_valuation = (
                line_difference_valuation - high_line_valuation
            )
            square_stability_threshold = 2 * int(
                absolute_field(2).valuation(component_prime)
            )
            if (
                not line_ratio_is_square
                or relative_error_valuation
                <= square_stability_threshold
            ):
                raise RuntimeError(
                    "the tangent squareclass did not stabilize between "
                    "the exact low- and high-precision ideal-CRT lifts"
                )
            hilbert_symbol = int(
                absolute_field.hilbert_symbol(
                    absolute_high_line,
                    to_absolute(second_beta),
                    component_prime,
                )
            )
            if hilbert_symbol not in (-1, 1):
                raise RuntimeError("invalid Hilbert-symbol value")
            place_sign *= hilbert_symbol
            component_records.append(
                {
                    "absolute_prime": str(component_prime),
                    "relative_degree": source_record[
                        "relative_degree"
                    ],
                    "root_residual_valuation": source_record[
                        "root_residual_valuation"
                    ],
                    "low_crt_error_valuation": source_record[
                        "low_crt_error_valuation"
                    ],
                    "high_crt_error_valuation": source_record[
                        "high_crt_error_valuation"
                    ],
                    "low_to_high_line_ratio_is_exact_local_square": (
                        line_ratio_is_square
                    ),
                    "line_difference_valuation": (
                        line_difference_valuation
                    ),
                    "high_line_valuation": high_line_valuation,
                    "line_relative_error_valuation": (
                        relative_error_valuation
                    ),
                    "line_square_stability_threshold": (
                        square_stability_threshold
                    ),
                    "hilbert_symbol": hilbert_symbol,
                }
            )
        total_sign *= place_sign
        place_records.append(
            {
                "rational_prime": rational_prime,
                "prime_index": prime_index,
                "base_prime": str(base_prime),
                "curve_discriminant_valuation": int(
                    curve.discriminant().valuation(base_prime)
                ),
                "component_records": component_records,
                "place_product": place_sign,
            }
        )

    pairing_value = "1/2" if total_sign == -1 else "0"
    result = {
        "schema": "argus.d1-cassels-tate-pairing.v1",
        "first_selmer_mask": first_mask,
        "second_selmer_mask": second_mask,
        "pairing_argument_order": [first_mask, second_mask],
        "pairing_order_note": (
            "On 2-Selmer classes the alternating Cassels-Tate pairing "
            "has values in {0,1/2}, so reversing the arguments leaves "
            "the displayed value unchanged."
        ),
        "base_field_polynomial": str(field.polynomial()),
        "two_division_polynomial": str(two_division),
        "absolute_two_division_field_polynomial": str(
            absolute_field.polynomial()
        ),
        "tangent_source": str(tangent_path),
        "tangent_verified": tangent_payload["tangent_verified"],
        "local_cover_point_source": str(local_points_path),
        "rational_bad_primes": rational_bad_primes,
        "finite_support_complete": True,
        "omitted_finite_places": (
            "Trivial by Shukla-Stoll Corollary 5.5: outside the "
            "places above 2 and the bad-reduction places, both Selmer "
            "cocycles are unramified and the local product is 1."
        ),
        "infinite_places": (
            "All contributions are 1 by the infinite-place argument "
            "in Shukla-Stoll Corollary 5.5."
        ),
        "place_records": place_records,
        "total_hilbert_symbol_product": total_sign,
        "cassels_pairing_value": pairing_value,
        "cassels_tate_pairing_value": pairing_value,
        "formula": (
            "Shukla-Stoll equation (3.10), with equality to the "
            "Cassels-Tate pairing by Theorem 5.6."
        ),
        "proof_flag": True,
    }
    output_path.write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print(
        json.dumps(
            {
                "output": str(output_path),
                "total_hilbert_symbol_product": total_sign,
                "cassels_tate_pairing_value": pairing_value,
                "proof_flag": True,
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--local-points",
        type=Path,
        default=DEFAULT_LOCAL_POINTS,
    )
    parser.add_argument(
        "--tangent",
        type=Path,
        default=DEFAULT_TANGENT,
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT,
    )
    parser.add_argument(
        "--first-mask",
        type=int,
        default=local_cover.FIRST_CLASS,
    )
    parser.add_argument(
        "--second-mask",
        type=int,
        default=local_cover.SECOND_CLASS,
    )
    arguments = parser.parse_args()
    compute(
        arguments.local_points,
        arguments.tangent,
        arguments.output,
        arguments.first_mask,
        arguments.second_mask,
    )
