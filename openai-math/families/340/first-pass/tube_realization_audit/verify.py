#!/usr/bin/env python3
"""Replay exact algebra and analytic identities, not the imported topology."""

import argparse
from collections import Counter
from copy import deepcopy
from itertools import product
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OPERATION = "abelian_group.quotient.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def zero(expression, message):
    require(sp.simplify(expression) == 0, message)


def group_calculation():
    moduli = (2, 2, 8)
    group = tuple(product(*(range(n) for n in moduli)))
    identity = (0, 0, 0)
    source = tuple(product(range(2), repeat=3))

    def add(x, y):
        return tuple((a + b) % n for a, b, n in zip(x, y, moduli))

    def multiple(x, n):
        return tuple(n * a % m for a, m in zip(x, moduli))

    involutions = tuple(x for x in group if multiple(x, 2) == identity)
    require(len(involutions) == 8, "H[2] has the wrong order")
    image_counts, kernel_counts, type_counts = Counter(), Counter(), Counter()
    checked = 0
    for first, second in product(involutions, repeat=2):
        mapping = {
            x: add(multiple(first, x[1]), multiple(second, x[2]))
            for x in source
        }
        require(mapping[(1, 0, 0)] == identity, "Specified source vector survives")
        for x, y in product(source, repeat=2):
            summed = tuple((a + b) % 2 for a, b in zip(x, y))
            require(mapping[summed] == add(mapping[x], mapping[y]), "Not a homomorphism")
        image = set(mapping.values())
        kernel_size = sum(value == identity for value in mapping.values())
        require(len(image) * kernel_size == 8, "Kernel-image order identity")
        require(len(image) <= 4, "Rigid kernel did not bound the image")
        require(image <= set(involutions), "Image is not killed by two")

        coset_of = {
            x: min(add(x, h) for h in image)
            for x in group
        }
        quotient = tuple(sorted(set(coset_of.values())))
        quotient_zero = coset_of[identity]
        require(len(quotient) * len(image) == 32, "Cosets do not partition H")

        def qadd(x, y):
            return coset_of[add(x, y)]

        for x, y in product(group, repeat=2):
            require(
                coset_of[add(x, y)] == qadd(coset_of[x], coset_of[y]),
                "Quotient addition is not well-defined",
            )

        def qorder(x):
            for n in (1, 2, 4, 8):
                if coset_of[multiple(x, n)] == quotient_zero:
                    return n
            raise ValueError("Unexpected quotient exponent")

        contains_z = (0, 0, 4) in image
        if len(image) == 1:
            factors = (2, 2, 8)
        elif len(image) == 2:
            factors = (2, 2, 4) if contains_z else (2, 8)
        else:
            factors = (2, 4) if contains_z else (8,)

        domain = tuple(product(*(range(n) for n in factors)))
        candidates = [tuple(x for x in quotient if qorder(x) == n) for n in factors]
        isomorphic = False
        for generators in product(*candidates):
            values = []
            for coefficients in domain:
                value = identity
                for coefficient, generator in zip(coefficients, generators):
                    value = add(value, multiple(generator, coefficient))
                values.append(coset_of[value])
            if len(set(values)) == len(domain) == len(quotient):
                # Generator orders make this map a homomorphism on the cyclic product.
                isomorphic = True
                break
        require(isomorphic, "No explicit isomorphism to the claimed cokernel")
        require({x[2] % 4 for x in quotient} == set(range(4)), "Missing C4 quotient")
        for x, h in product(group, image):
            require(add(x, h)[2] % 4 == x[2] % 4, "C4 map does not descend")
        image_counts[len(image)] += 1
        kernel_counts[kernel_size] += 1
        type_counts[factors] += 1
        checked += 1

    torsion_kernel = {x for x in group if x[2] % 4 == 0}
    require(torsion_kernel == set(involutions), "H -> C4 does not have kernel H[2]")
    return {
        "source_moduli": [2, 2, 2],
        "killed_basis_vector": [1, 0, 0],
        "target_moduli": list(moduli),
        "homomorphisms_checked": checked,
        "quotient_isomorphisms_checked": checked,
        "image_size_histogram": {str(n): image_counts[n] for n in sorted(image_counts)},
        "kernel_size_histogram": {str(n): kernel_counts[n] for n in sorted(kernel_counts)},
        "cokernel_types": [
            {"invariant_factors": list(factors), "map_count": count}
            for factors, count in sorted(type_counts.items())
        ],
        "maximum_image_order": max(image_counts),
        "minimum_cokernel_order": 32 // max(image_counts),
        "universal_quotient_invariant_factors": [4],
        "actual_connecting_map_identified": False,
    }


def jacobian_calculation(payload, output, status):
    expected_payload = {
        "invariant_factors": [2, 2, 8],
        "subgroup_generators": [[1, 0, 0], [0, 1, 0], [0, 0, 4]],
    }
    require(payload == expected_payload, "Jacobian input is not the canonical H/H[2] input")
    require(status["exit_code"] == 0 and not status["timed_out"], "Adapter failed or timed out")
    require(status["structured_error"] is None, "Structured adapter error")
    require(output.get("error") is None, "Typed Jacobian error")
    require(output["tool"] == "math.run", "Not a Jacobian execution")
    require(output["transport"] == "mcp-stdio", "Unexpected adapter transport")
    require(output["request"] == {"operation_id": OPERATION, "payload": payload}, "Input/output mismatch")
    require(output["result"]["operation_id"] == OPERATION, "Wrong executed operation")
    result = output["result"]["output"]
    require(result["method"] == "SMITH_NORMAL_FORM", "Unexpected quotient method")
    require(result["quotient_order"] == 4, "Incorrect universal quotient order")
    require(result["quotient_invariant_factors"] == [4], "Incorrect universal quotient type")
    require(output["protocol_version"] == "2025-11-25", "Uninspected protocol version")
    require(output["server"]["version"] == "0.14.0", "Uninspected server version")
    return {
        "operation_id": OPERATION,
        "protocol_version": output["protocol_version"],
        "server_version": output["server"]["version"],
        "adapter_exit_code": status["exit_code"],
        "timed_out": status["timed_out"],
        "structured_error": status["structured_error"],
        "quotient_order": result["quotient_order"],
        "quotient_invariant_factors": result["quotient_invariant_factors"],
        "scope": "H/H[2], not an asserted image of the connecting map",
    }


def analytic_calculations():
    x, y, b = sp.symbols("x y b", real=True)
    r, T, R, K, Lam = sp.symbols("r T R K Lambda", positive=True)
    c, C, delta, Rmax = sp.symbols("c C delta Rmax", positive=True)
    C1, M, D = sp.symbols("C1 M D", nonnegative=True)
    s, t = sp.symbols("s t", real=True)
    k, ell, stage = sp.symbols("k ell i", integer=True)
    a_index, b_index = k - 1, ell - 1
    zero(a_index + b_index + 1 - (k + ell - 1), "Partition ambient dimension")
    zero((k - ell) + (k + ell - 2 * stage) - 2 * (k - stage), "Component parity")
    zero(a_index.subs(k, k + 1) - a_index - 1, "Negative stabilization index")
    zero(b_index.subs(ell, ell + 1) - b_index - 1, "Positive stabilization index")
    shifts = {
        "BG_source_degree": 10,
        "stable_stem_degree": 10 - 1,
        "Hs_degree": 10 - 1,
        "Whitehead_degree": (10 - 1) + 1,
        "rigid_lifting_J_degree": 10 - 1,
        "rigid_injectivity_J_degree": 9 - 1,
        "partition_indices": [str(a_index), str(b_index)],
        "component_parity_modulus": 2,
        "parameter_dimension_including_nullhomotopy": 10,
        "sufficient_model_index": 10 + 3,
        "minimal_allowed_m": 20,
        "model_dimension_margin": 20 - (10 + 3),
        "actual_representative_dimension_specified": False,
    }
    for degree in (shifts["rigid_lifting_J_degree"], shifts["rigid_injectivity_J_degree"]):
        require(degree > 1 and degree % 8 in (0, 1), "Adams theorem does not apply in this degree")

    other_radius_sq = sp.symbols("other_radius_sq", positive=True)
    v, other_dot = sp.symbols("v other_dot", real=True)
    radius = sp.sqrt(x**2 + other_radius_sq)
    dot = v * x + other_dot
    beta, chi, local_g = sp.Function("beta"), sp.Function("chi"), sp.Function("g")
    beta_prime = sp.Subs(sp.diff(beta(s), s), s, radius / T)
    cutoff_linear = R * beta(radius / T) * dot
    expected_derivative = R * (
        beta(radius / T) * v + beta_prime * dot * x / (T * radius)
    )
    zero(sp.diff(cutoff_linear, x) - expected_derivative, "Linear cutoff derivative")
    chi_prime = sp.Subs(sp.diff(chi(s), s), s, radius)
    zero(
        sp.diff(chi(radius) * local_g(x), x)
        - chi(radius) * sp.diff(local_g(x), x)
        - chi_prime * local_g(x) * x / radius,
        "Origin smoothing derivative",
    )
    cutoff = {
        "linear_cutoff_gradient_coefficients": [1, 1],
        "origin_smoothing_gradient_coefficients": [1, 1],
        "outer_bound": "c*r - D*R",
        "inner_bound": "Rmin - M",
        "cutoff_derivative_omitted": False,
    }

    scale_K = 1 + C1 / (c * delta)
    scale_min = 1 + C + M
    outer_T = 1 + (1 + D) * Rmax / c
    margins = {
        "K_delta_minus_C1_over_c": str(sp.simplify(scale_K * delta - C1 / c)),
        "Rmin_minus_C": str(sp.simplify(scale_min - C)),
        "Rmin_minus_M": str(sp.simplify(scale_min - M)),
        "cT_minus_Rmax": str(sp.expand(c * outer_T - Rmax)),
        "cT_minus_D_Rmax": str(sp.expand(c * outer_T - D * Rmax)),
        "T_minus_one_times_c": str(sp.expand(c * (outer_T - 1))),
    }
    require(margins["K_delta_minus_C1_over_c"] == "delta", "No strict separation margin")
    require(sp.simplify(c * outer_T - D * Rmax).is_positive, "No outer gradient margin")
    require((scale_min - C).is_positive, "No lower radius margin")
    require((scale_min - M).is_positive, "No inner gradient margin")

    h = sp.Function("h")(b, s)
    homogeneous = r**2 * h
    zero(r * sp.diff(homogeneous, r) - 2 * homogeneous, "Euler radial identity")
    zero(sp.diff(homogeneous, b) - r**2 * sp.diff(h, b), "Base derivative homogeneity")
    zero(sp.diff(homogeneous, r, b) - 2 * r * sp.diff(h, b), "Radial mixed derivative")
    h0, norm_tangent_sq, u_sq, u_dot_tangent = sp.symbols(
        "h0 norm_tangent_sq u_sq u_dot_tangent", real=True
    )
    expanded_norm = 4 * h0**2 * u_sq + 4 * h0 * u_dot_tangent + norm_tangent_sq
    norm_squared = expanded_norm.subs({u_sq: 1, u_dot_tangent: 0})
    zero(norm_squared - (4 * h0**2 + norm_tangent_sq), "Angular orthogonality identity")
    homogeneous_data = {
        "radial_Euler_coefficient": 2,
        "angular_norm_squared_h_coefficient": 4,
        "base_derivative_degree": 2,
        "mixed_derivative_degree": 1,
        "origin_extension_is_proved_in_prose": True,
    }

    block = sp.diag(R, -R)
    inverse = sp.diag(1 / R, -1 / R)
    require(block * inverse == sp.eye(2), "Parallel/perpendicular right inverse")
    a = sp.symbols("a", positive=True)
    zero((R / a) * a - R, "Radial critical-locus parametrization")
    morse = {
        "parallel_perpendicular_block_product": [[1, 0], [0, 1]],
        "hessian_inverse_used": False,
        "radial_solution_scale": str(R / a),
        "scope": "scalar block identity; the full dimension-independent argument is in proof.tex",
    }

    theta = sp.Function("theta")(b)
    base_scale = Lam * sp.exp(K * theta)
    zero(sp.diff(base_scale, b) - K * base_scale * sp.diff(theta, b), "Varying scale derivative")
    base_g = sp.Function("g")(b, x, y)
    fiber_expression = base_g - base_scale * dot
    zero(sp.diff(fiber_expression, v) + base_scale * x, "Sphere momentum sign")
    zero(
        sp.diff(fiber_expression, b)
        - sp.diff(base_g, b) + K * base_scale * sp.diff(theta, b) * dot,
        "Base momentum sign",
    )
    g_value = sp.symbols("g_value")
    primitive = sp.simplify(g_value - R * (2 * g_value / R))
    require(primitive == -g_value, "Primitive has the wrong sign")
    theta_prime, norm_v_squared = sp.symbols("dtheta norm_v_squared", real=True)
    collision_scale = -K * R * theta_prime * t * norm_v_squared
    zero(
        collision_scale.subs(norm_v_squared, 1) + K * R * t * theta_prime,
        "Collision scale covector difference",
    )
    momentum = {
        "sphere_momentum_coefficient": -1,
        "base_scale_momentum_coefficient": -1,
        "primitive_coefficient": -1,
        "collision_scale_difference": "-K*R*t*dtheta",
        "fundamental_theorem_through_zero_is_proved_in_prose": True,
    }

    radius2 = x**2 + y**2
    singular_g = -x**2 + y**4 / radius2
    singular_point = {x: 2, y: 0}
    singular_gradient = sp.Matrix([sp.diff(singular_g, z) for z in (x, y)])
    singular_hessian = sp.hessian(singular_g, (x, y)).subs(singular_point)
    singular_gradient_value = singular_gradient.subs(singular_point)
    zero(x * singular_gradient[0] + y * singular_gradient[1] - 2 * singular_g, "Singular model Euler")
    require(singular_hessian.det() == 0, "Test model is not singular")
    full_minor = sp.Matrix.hstack(singular_hessian[:, 0], sp.Matrix([0, -4]))
    require(full_minor.det() == 8, "Singular Hessian destroyed full Morse regularity")
    angular_path = 2 * s - 1 - t * s * (1 - s)
    zero(sp.diff(angular_path, s) - 1 - ((1 - t) + 2 * t * s), "Angular regularity margin")
    singular = {
        "point": [2, 0],
        "gradient": [int(z) for z in singular_gradient_value],
        "hessian": [[int(z) for z in row] for row in singular_hessian.tolist()],
        "hessian_determinant": int(singular_hessian.det()),
        "full_gradient_minor_determinant": int(full_minor.det()),
        "angular_path_endpoint_values": [
            int(angular_path.subs(s, 0)), int(angular_path.subs(s, 1))
        ],
        "angular_path_derivative_lower_bound": 1,
        "stable_class_used_as_a": False,
    }

    tau = sp.symbols("tau", real=True)
    crossing_family = x * sp.sqrt(radius2) - tau * x * y**3 / radius2
    crossing_g = crossing_family.subs(tau, 2)
    crossing_gradient = sp.Matrix([sp.diff(crossing_g, z) for z in (x, y)])
    points = ({x: 2, y: 0}, {x: -2, y: 0})
    gradients = [crossing_gradient.subs(p) for p in points]
    require(gradients[0] == gradients[1] == sp.Matrix([4, 0]), "Not an equal-gradient pair")
    zero(x * crossing_gradient[0] + y * crossing_gradient[1] - 2 * crossing_g, "Crossing model Euler")
    base_derivatives = [sp.diff(crossing_family, tau).subs(p) for p in points]
    require(base_derivatives == [0, 0], "Unexpected intrinsic base-momentum difference")
    base_momenta = [base_derivatives[i] - 4 * point[x] for i, point in enumerate(points)]
    sphere_momenta = [-4 * point[y] for point in points]
    require(sphere_momenta[0] == sphere_momenta[1], "Sphere momenta do not collide")
    require(base_momenta[0] - base_momenta[1] == -16, "Scale failed to separate the pair")
    segment_x = -2 + 4 * s
    zero(segment_x.subs(s, sp.Rational(1, 2)), "Segment does not cross the origin")
    norm_integral = sp.integrate(-segment_x, (s, 0, sp.Rational(1, 2))) + sp.integrate(
        segment_x, (s, sp.Rational(1, 2), 1)
    )
    zero(norm_integral - 1, "Origin-crossing line integral")
    phi = sp.symbols("phi", real=True)
    angular_cross = sp.cos(phi) * (1 - 2 * sp.sin(phi)**3)
    angular_derivative = sp.diff(angular_cross, phi)
    transverse_derivatives = [
        angular_derivative.subs(phi, sp.pi / 2),
        angular_derivative.subs(phi, 3 * sp.pi / 2),
    ]
    require(transverse_derivatives == [1, 3], "Cosine zeros are not transverse")
    require(sp.Poly(2 * s**3 - 1, s).count_roots(0, 1) == 1, "Extra angular-root count")
    cosine, sine = sp.symbols("cosine sine")
    formal_derivative = -sine * (1 - 2 * sine**3) - 6 * sine**2 * cosine**2
    remainder = sp.rem(formal_derivative + 6 * sine**2 * cosine**2, 2 * sine**3 - 1, sine)
    zero(remainder, "Other angular zero derivative")
    crossing = {
        "points": [[2, 0], [-2, 0]],
        "common_gradient": [int(z) for z in gradients[0]],
        "sphere_momenta": sphere_momenta,
        "base_momenta_with_Rprime_4": [int(z) for z in base_momenta],
        "base_momentum_difference": int(base_momenta[0] - base_momenta[1]),
        "segment_zero_parameter": "1/2",
        "segment_norm_integral": str(norm_integral),
        "cosine_zero_derivatives": [int(z) for z in transverse_derivatives],
        "other_sine_roots_in_0_1": 1,
        "angular_zero_count": 4,
        "stable_class_used_as_a": False,
    }
    return {
        "degree_and_model_shifts": shifts,
        "cutoff_differentials": cutoff,
        "uniform_choice_margins": margins,
        "homogeneous_identities": homogeneous_data,
        "full_morse_right_inverse": morse,
        "momenta_and_primitive": momentum,
        "singular_hessian_model": singular,
        "origin_crossing_model": crossing,
    }


def build_certificate():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    groups = {
        "universal_homomorphisms": group_calculation(),
        "jacobian_quotient": jacobian_calculation(payload, output, status),
        **analytic_calculations(),
    }
    return {
        "result_class": "exact_calculations_supporting_a_prose_verification_theorem",
        "claim": "TR-exact-calculations",
        "topology_machine_verified": False,
        "external_group_identifications_machine_verified": False,
        "explicit_nonzero_tube_representative": None,
        "Hamiltonian_transport_verified": False,
        "groups": groups,
    }


def compare_certificate(certificate, expected):
    if certificate != expected:
        differing = [
            key for key in set(certificate) | set(expected)
            if certificate.get(key) != expected.get(key)
        ]
        if "groups" in differing and isinstance(certificate.get("groups"), dict):
            differing.extend(
                "groups." + key
                for key in set(certificate["groups"]) | set(expected["groups"])
                if certificate["groups"].get(key) != expected["groups"].get(key)
            )
        raise ValueError("Certificate mismatch: " + ", ".join(sorted(differing)))


def self_test(certificate, expected):
    changes = [
        ("universal_homomorphisms", "homomorphisms_checked", 63),
        ("universal_homomorphisms", "maximum_image_order", 8),
        ("universal_homomorphisms", "minimum_cokernel_order", 4),
        ("universal_homomorphisms", "universal_quotient_invariant_factors", [2, 2]),
        ("degree_and_model_shifts", "Whitehead_degree", 9),
        ("degree_and_model_shifts", "partition_indices", ["k", "ell"]),
        ("degree_and_model_shifts", "rigid_injectivity_J_degree", 9),
        ("cutoff_differentials", "linear_cutoff_gradient_coefficients", [1, 0]),
        ("uniform_choice_margins", "cT_minus_D_Rmax", "0"),
        ("full_morse_right_inverse", "parallel_perpendicular_block_product", [[1, 0], [0, -1]]),
        ("momenta_and_primitive", "primitive_coefficient", 1),
        ("singular_hessian_model", "hessian_determinant", 1),
        ("singular_hessian_model", "full_gradient_minor_determinant", 0),
        ("origin_crossing_model", "base_momentum_difference", 0),
        ("origin_crossing_model", "cosine_zero_derivatives", [0, 3]),
    ]
    for group, key, value in changes:
        mutant = deepcopy(certificate)
        mutant["groups"][group][key] = value
        try:
            compare_certificate(mutant, expected)
        except ValueError:
            continue
        raise ValueError("Accepted a substantive certificate mutation: " + group + "." + key)

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    bad_output = deepcopy(output)
    bad_output["result"]["output"]["quotient_invariant_factors"] = [2, 2]
    bad_status = deepcopy(status)
    bad_status["timed_out"] = True
    bad_payload = deepcopy(payload)
    bad_payload["subgroup_generators"][-1][-1] = 2
    for args in ((payload, bad_output, status), (payload, output, bad_status), (bad_payload, output, status)):
        try:
            jacobian_calculation(*args)
        except ValueError:
            continue
        raise ValueError("Accepted altered or inconclusive Jacobian evidence")
    return len(changes) + 3


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("certificate", nargs="?", type=Path, default=HERE / "exact_certificate.json")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())
    expected = build_certificate()
    compare_certificate(certificate, expected)
    rejected = self_test(certificate, expected) if args.self_test else 0
    print(json.dumps({
        "result": "PASS",
        "exact_check_groups": len(expected["groups"]),
        "universal_homomorphisms": expected["groups"]["universal_homomorphisms"]["homomorphisms_checked"],
        "substantive_mutations_rejected": rejected,
        "topology_machine_verified": False,
        "actual_connecting_map_identified": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
