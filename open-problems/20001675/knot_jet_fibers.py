"""Exact delta replay for corona-lifted endpoint-jet fibers among knots."""

import argparse
import json
from itertools import product
from math import comb
from pathlib import Path

import sympy as sp

from exponential_fibers import polynomial
from full_jet_scalar_fibers import (
    coefficients_poly, decode_coefficient, decoder_system,
    insertion_polynomials, jet_coefficient, scalar_jet,
)
from jet_fibers import (
    ROOT, X, Y, forest_order, graph_states, remove_vertices, structure,
)
from joint_refinement import (
    add, canonical, homfly_terms, rank_refinement, refinement, scale,
    slice_polynomial,
)
from plabic_realization import realize
from polarized_jet_fibers import family, switch, switch_order, typed_function
from rooted_trees import rooted_data


D = 1 + X
FX = X * (1 + X * Y) / D**2
GY = Y * D / (1 + X * Y)
Q, Z, A = sp.symbols("q z a")


def corona(n, edges):
    forest_order(n, edges, 0)
    return 2 * n, tuple(sorted(
        tuple(sorted(edge))
        for edge in (*edges, *((v, n + v) for v in range(n)))
    ))


def knot_tree(depth, word):
    return corona(*family(depth, word, "path"))


def forced_matching(n, edges):
    neighbors, _, _, _ = forest_order(2 * n, edges, 0)
    matching = tuple((v, n + v) for v in range(n))
    if any(neighbors[n + v] != [v] for v in range(n)):
        raise ArithmeticError("A fresh leaf no longer forces its claimed matching edge")
    if sorted(vertex for edge in matching for vertex in edge) != list(range(2 * n)):
        raise ArithmeticError("The forced edges do not form a perfect matching")
    return matching


def lift_terms(terms, n, degree=None):
    result, binomials = {}, {}
    for i, j, coefficient in terms:
        exponent = n - 2 * i + j
        if i < j or exponent < 0:
            raise ArithmeticError("The input violates the forest refinement support")
        if degree is not None and j > degree:
            continue
        if exponent not in binomials:
            binomials[exponent] = tuple(comb(exponent, k) for k in range(exponent + 1))
        last = i - j if degree is None else min(i - j, degree - j)
        for k in range(last + 1):
            factor = coefficient * comb(i - j, k)
            for ell, value in enumerate(binomials[exponent]):
                powers = i + k + ell, j + k
                result[powers] = result.get(powers, 0) + factor * value
    return canonical(result)


def inflate_poly(poly, power, denominator_power):
    result = {}
    for (i,), coefficient in poly.terms():
        exponent = power - denominator_power * i
        if exponent < 0 or not coefficient.is_Integer:
            raise ArithmeticError("The requested polynomial inflation is not integral")
        value = int(coefficient)
        for k in range(exponent + 1):
            result[i + k] = result.get(i + k, 0) + value * comb(exponent, k)
    return sp.Poly.from_dict({(i,): c for i, c in result.items()}, X, domain=sp.ZZ)


def poly_values(poly):
    if poly.is_zero:
        return [0]
    return [int(poly.nth(i)) for i in range(poly.degree() + 1)]


def count_from_independence(values, n):
    return sp.cancel(sum(
        coefficient * Q**i * (Q - 1)**(n - 2 * i)
        for i, coefficient in enumerate(values)
    ))


def disk_summary(n, edges):
    disk = realize(n, edges)
    if disk["non_reduced_certificate"]["neighbor_degree"] < 4:
        raise ArithmeticError("The new disk map lost the reviewed forbidden leaf")
    if sorted(tuple(sorted(e)) for e in disk["quiver_arrows"]) != list(edges):
        raise ArithmeticError("The new disk map has the wrong mutable quiver")
    if len(disk["boundary_clockwise"]) != 6 * n - 2:
        raise ArithmeticError("The new disk map has the wrong boundary order")
    return {
        "tree_vertices": n,
        "disk_vertex_count": len(disk["vertices"]),
        "disk_edge_count": len(disk["edges"]),
        "interior_face_count": sum(name.startswith("cell") for name in disk["disk_faces"]),
        "boundary_vertices": len(disk["boundary_clockwise"]),
        "quiver_arrows": disk["quiver_arrows"],
        "non_reduced_certificate": disk["non_reduced_certificate"],
        "embedding_certificate": disk["embedding_certificate"],
        "full_map_reproduction": "plabic_realization.realize(n, tree_edges)",
    }


def jacobian_evidence(exact):
    folder = ROOT / "research/jacobian"
    operation = "matrix.symbolic.determinant.compute"
    payload = json.loads((folder / "knot-jet-input.json").read_text())
    response = json.loads((folder / "knot-jet-output.json").read_text())
    contract = json.loads((folder / "knot-jet-inspect.json").read_text())
    adapter = json.loads((folder / "knot-jet-status.json").read_text())
    if response["request"] != {"operation_id": operation, "payload": payload}:
        raise ValueError("The retained Jacobian output belongs to a different payload")
    if response["result"]["operation_id"] != operation or adapter["operation_id"] != operation:
        raise ValueError("Unexpected Jacobian operation")
    if contract["result"]["operation"]["operation_id"] != operation:
        raise ValueError("The retained inspection describes a different operation")
    if adapter["adapter_exit_status"] != 0 or adapter["timeout"]:
        raise ValueError("The bounded Jacobian operation did not complete successfully")
    if adapter["structured_error"] is not None or not adapter["complete_typed_output"]:
        raise ValueError("The bounded Jacobian output is incomplete or has an error")
    if response["result"]["output"]["method"] != "SYMPY_BAREISS":
        raise ValueError("Unexpected determinant method")
    for field in ("server_version", "protocol_version"):
        actual = response["server"]["version"] if field == "server_version" else response[field]
        inspected = contract["server"]["version"] if field == "server_version" else contract[field]
        if adapter[field] != actual or inspected != actual:
            raise ValueError(f"Inconsistent Jacobian {field}")
    u, v = sp.symbols("u v")
    expected = ((1 - u + v, -2 * u), (-v, 1 + u))
    entries = payload["matrix"]["entries"]
    if payload["matrix"]["variables"] != ["u", "v"] or len(entries) != 2:
        raise ValueError("Unexpected cleared corona Jacobian matrix")
    for i, row in enumerate(entries):
        if len(row) != 2:
            raise ValueError("The retained Jacobian matrix is not two by two")
        for j, entry in enumerate(row):
            exact(f"typed_corona_jacobian_entry_{i}{j}",
                  typed_function(entry) - expected[i][j])
    exact("typed_corona_jacobian_determinant",
          typed_function(response["result"]["output"]["determinant"]) - (1 - u) * (1 + u + v))
    cleared = sp.Matrix(expected)
    rational = sp.Matrix([[u / (1 + u + v)**2], [v / (1 + u + v)]])
    jac = rational.jacobian((u, v))
    for i in range(2):
        for j in range(2):
            exact(f"cleared_jacobian_derivative_{i}{j}",
                  jac[i, j] * (1 + u + v)**(3 if i == 0 else 2) - cleared[i, j])
    exact("rational_corona_jacobian", jac.det() - (1 - u) / (1 + u + v)**4)
    return {
        **adapter,
        "payload": "research/jacobian/knot-jet-input.json",
        "output": "research/jacobian/knot-jet-output.json",
        "inspection": "research/jacobian/knot-jet-inspect.json",
        "determinant": "(1-u)*(1+u+v)",
        "scope": "An exact determinant only; injectivity is proved separately in prose.",
    }


def certify():
    residuals = {}

    def exact(label, expression):
        residual = sp.cancel(expression)
        if residual != 0:
            raise ArithmeticError(f"{label}: {residual}")
        residuals[label] = 0

    def equal(label, left, right):
        if left != right:
            raise ArithmeticError(f"{label}: exact objects differ")
        residuals[label] = 0

    exact("known_pendant_unselected_weight", 1 + X * (1 - Y) + X * Y - D)
    exact("rank_coordinates_sum", FX - X * (1 - Y) / D**2 - X * Y / D)
    exact("rank_coordinates_nullity", FX * GY - X * Y / D)
    exact("rank_coordinates_rank", FX * (1 - GY) - X * (1 - Y) / D**2)
    exact("corona_zero_endpoint_x", FX.subs(Y, 0) - X / D**2)
    exact("corona_one_endpoint_x", FX.subs(Y, 1) - X / D)
    exact("corona_zero_endpoint_y", GY.subs(Y, 0))
    exact("corona_one_endpoint_y", GY.subs(Y, 1) - 1)
    exact("zero_endpoint_factor", GY / Y - D / (1 + X * Y))
    exact("one_endpoint_factor", (GY - 1) / (Y - 1) - 1 / (1 + X * Y))
    exact("x_adic_substitution_first_coordinate", sp.cancel(FX / X).subs(X, 0) - 1)
    exact("x_adic_substitution_second_coordinate", GY.subs(X, 0) - Y)
    exact("omitted_zero_jet_unit", sp.cancel(GY / Y).subs(Y, 0) - D)
    exact("omitted_one_jet_unit", sp.cancel((GY - 1) / (Y - 1)).subs(Y, 1) - 1 / D)
    exact("omitted_coefficient_injective_linear_term", sp.diff(X / D**2, X).subs(X, 0) - 1)
    exact("one_endpoint_injective_linear_term", sp.diff(X / D, X).subs(X, 0) - 1)
    exact("homfly_endpoint_simple_zero", sp.cancel((1 - A**-2) / (A - 1)).subs(A, 1) - 2)
    exact("normalized_top_endpoint_ideal", (Y * (Y - 1)).subs(Y, 1 - X) + X * (1 - X))
    count_x = Q / (Q - 1)**2
    s = Q**2 - Q + 1
    exact("corona_count_prefactor", (Q - 1)**2 * (1 + count_x) - s)
    exact("corona_count_argument", count_x / (1 + count_x) - Q / s)
    conway_x = Z**-2
    exact("corona_conway_prefactor", Z**2 * (1 + conway_x) - (1 + Z**2))
    exact("corona_conway_argument", conway_x / (1 + conway_x)**2 - Z**2 / (1 + Z**2)**2)
    exact("unlink_factor_at_a_one", ((A - A**-1) / Z).subs(A, 1))
    c, d = sp.symbols("c d")
    exact("universal_leaf_homfly_skein",
          c + Z**-2 * d - Z / A * (A / Z * c) - A**-2 * (A**2 / Z**2 * d))
    exact("universal_leaf_normalized_count",
          (Q - 1)**2 * (c + count_x * d) - (Q - 1)**2 * c - Q * d)
    n, m, r = sp.symbols("n m r")
    exact("corona_family_order", 2 * (n * m + 4) - (2 * n * m + 8))
    exact("corona_fiber_rate", (2 * n * m + 8 - 8) / (2 * n) - m)
    exact("corona_quadratic_rate_bound", 2 * (37 * r**2) - 74 * r**2)
    jacobian = jacobian_evidence(exact)

    small = []
    samples = [
        (1, ()),
        (3, ((0, 1), (1, 2))),
        (4, ((0, 1), (0, 2), (0, 3))),
        (6, ((0, 1), (1, 2), (1, 3), (3, 4), (3, 5))),
        (4, ((0, 1), (2, 3))),
    ]
    for index, (n, edges) in enumerate(samples):
        nc, ec = corona(n, edges)
        original = refinement(n, edges, 0)[0]
        actual = refinement(nc, ec, 0)[0]
        predicted = lift_terms(original, n)
        equal(f"small_full_corona_{index}", actual, predicted)
        equal(f"small_subset_rank_corona_{index}", rank_refinement(nc, ec), actual)
        i0, m0 = slice_polynomial(original, 1), slice_polynomial(original, 0)
        ic, mc = slice_polynomial(actual, 1), slice_polynomial(actual, 0)
        equal(f"small_entire_independence_{index}",
              poly_values(inflate_poly(coefficients_poly(i0), n, 1)), list(ic))
        equal(f"small_entire_matching_{index}",
              poly_values(inflate_poly(coefficients_poly(m0), n, 2)), list(mc))
        forced = forced_matching(n, ec)
        equal(f"small_unique_perfect_matching_{index}", mc[n], 1)
        exact(f"small_entire_point_count_{index}",
              count_from_independence(ic, nc) - s**n * coefficients_poly(i0).as_expr().subs(X, Q / s))
        small.append({
            "original_vertices": n, "original_edges": edges,
            "corona_vertices": nc, "corona_edges": ec,
            "refinement_xy": actual, "forced_perfect_matching": forced,
            "independence_x": ic, "matching_x": mc,
            "subset_rank_scope": f"All {1 << nc} induced subsets of this {nc}-vertex forest.",
        })

    full_examples = []
    for bit in (0, 1):
        h, edges = family(1, (bit,), "path")
        nc, ec = corona(h, edges)
        base = refinement(h, edges, 0)[0]
        actual = refinement(nc, ec, 0)[0]
        equal(f"actual_full_depth_one_corona_{bit}", actual, lift_terms(base, h))
        ih, _, mh, _ = rooted_data(h, edges, 0)
        ic, _, mc, _ = rooted_data(nc, ec, 0)
        equal(f"actual_full_independence_{bit}", slice_polynomial(actual, 1), ic)
        equal(f"actual_full_matching_{bit}", slice_polynomial(actual, 0), mc)
        equal(f"actual_full_independence_inflation_{bit}",
              poly_values(inflate_poly(coefficients_poly(ih), h, 1)), list(ic))
        equal(f"actual_full_matching_inflation_{bit}",
              poly_values(inflate_poly(coefficients_poly(mh), h, 2)), list(mc))
        matching = forced_matching(h, ec)
        equal(f"actual_full_conway_constant_{bit}", mc[h], 1)
        leaf, neighbor = nc - 1, h - 1
        n1, e1, root1 = remove_vertices(nc, ec, {leaf})
        n2, e2, root2 = remove_vertices(nc, ec, {leaf, neighbor})
        minus, pair = refinement(n1, e1, root1)[0], refinement(n2, e2, root2)[0]
        equal(f"actual_full_leaf_refinement_{bit}", actual, add(minus, scale(pair, dx=1)))
        homfly = homfly_terms(actual, nc)
        homfly_minus, homfly_pair = homfly_terms(minus, n1), homfly_terms(pair, n2)
        equal(f"actual_full_leaf_homfly_skein_{bit}",
              homfly, add(scale(homfly_minus, dx=-1, dy=1), scale(homfly_pair, dx=-2)))
        point = count_from_independence(ic, nc)
        exact(f"actual_full_leaf_point_count_{bit}",
              point - (Q - 1) * count_from_independence(slice_polynomial(minus, 1), n1)
              - Q * count_from_independence(slice_polynomial(pair, 1), n2))
        if not sp.Poly(point, Q).get_domain().is_ZZ:
            raise ArithmeticError("The corona normalized point count is not an integer polynomial")
        full_examples.append({
            "r": 1, "word": [bit], "original_vertices": h,
            "n": nc, "tree_edges": ec,
            "refinement_xy": actual, "homfly_az": homfly,
            "independence_x": ic, "matching_x": mc,
            "conway_z": [(2 * h - 2 * i, value) for i, value in enumerate(mc) if value],
            "normalized_point_count_q": [
                int(sp.Poly(point, Q).nth(i)) for i in range(sp.degree(point, Q) + 1)
            ],
            "forced_perfect_matching": matching,
            "skein_count_leaf": {
                "leaf": leaf, "neighbor": neighbor,
                "minus_refinement_xy": minus, "pair_refinement_xy": pair,
                "minus_homfly_az": homfly_minus, "pair_homfly_az": homfly_pair,
                "homfly_residual": 0, "point_count_residual": 0,
            },
            "plabic": disk_summary(nc, ec),
        })
    equal("actual_full_pair_entire_independence",
          full_examples[0]["independence_x"], full_examples[1]["independence_x"])
    equal("actual_full_pair_entire_matching",
          full_examples[0]["matching_x"], full_examples[1]["matching_x"])
    if full_examples[0]["homfly_az"] == full_examples[1]["homfly_az"]:
        raise ArithmeticError("The explicit depth-one knot polynomials did not separate")

    endpoint_examples = []
    for depth in (1, 2, 3):
        original_states, lifted_states, top_states = [], [], []
        for bit in (0, 1):
            h, edges = family(depth, (bit,), "path")
            nc, ec = corona(h, edges)
            original = graph_states(h, edges, 0, depth, axis=1)[0]
            actual = graph_states(nc, ec, 0, depth, axis=1)[0]
            top = graph_states(nc, ec, 0, depth, axis=1, endpoint=1)[0]
            equal(f"actual_all_x_corona_jet_r{depth}_b{bit}",
                  actual, lift_terms(original, h, degree=depth))
            ic, _, mc, _ = rooted_data(nc, ec, 0)
            equal(f"actual_all_x_matching_r{depth}_b{bit}",
                  poly_values(jet_coefficient(actual, 0)), list(mc))
            equal(f"actual_all_x_independence_r{depth}_b{bit}",
                  poly_values(jet_coefficient(top, 0)), list(ic))
            equal(f"actual_conway_constant_r{depth}_b{bit}", mc[h], 1)
            forced_matching(h, ec)
            original_states.append(original)
            lifted_states.append(actual)
            top_states.append(top)
        for j in range(depth):
            equal(f"actual_preserved_zero_jet_r{depth}_j{j}",
                  jet_coefficient(lifted_states[0], j), jet_coefficient(lifted_states[1], j))
            equal(f"actual_preserved_one_jet_r{depth}_j{j}",
                  jet_coefficient(top_states[0], j), jet_coefficient(top_states[1], j))
        gap = jet_coefficient(original_states[0], depth) - jet_coefficient(original_states[1], depth)
        lifted_gap = jet_coefficient(lifted_states[0], depth) - jet_coefficient(lifted_states[1], depth)
        equal(f"actual_omitted_jet_inflation_r{depth}",
              lifted_gap, inflate_poly(gap, h + depth, 2))
        if lifted_gap.is_zero:
            raise ArithmeticError("The actual first omitted knot coefficient vanished")
        endpoint_examples.append({
            "r": depth, "m": 1, "original_vertices": h, "corona_vertices": nc,
            "full_x_zero_endpoint_jets": lifted_states,
            "full_x_one_endpoint_jets": top_states,
            "original_omitted_difference_x": poly_values(gap),
            "corona_omitted_difference_x": poly_values(lifted_gap),
            "scope": f"All x coefficients; Taylor orders 0 through {depth} at both endpoints.",
        })

    word_examples = []
    for depth, length in ((1, 2), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2)):
        h = switch_order(depth) * length + 4
        seeds = tuple(graph_states(*switch(depth, bit), depth, axis=1) for bit in (0, 1))
        original_basis = insertion_polynomials(depth, length)
        basis = tuple(inflate_poly(column, h + depth, 2) for column in original_basis)
        powers, inverse = decoder_system(basis)
        zero = (0,) * length
        original_reference = scalar_jet(seeds, zero, depth)
        reference = jet_coefficient(lift_terms(original_reference, h, degree=depth), depth)
        original_reference_coefficient = jet_coefficient(original_reference, depth)
        observed_coefficients, decoded = [], []
        for word in product((0, 1), repeat=length):
            original = scalar_jet(seeds, word, depth)
            observed = jet_coefficient(lift_terms(original, h, degree=depth), depth)
            gap = original_reference_coefficient - jet_coefficient(original, depth)
            equal(f"word_omitted_corona_identity_r{depth}_m{length}_{''.join(map(str, word))}",
                  reference - observed, inflate_poly(gap, h + depth, 2))
            equal(f"word_exact_knot_decoder_r{depth}_m{length}_{''.join(map(str, word))}",
                  decode_coefficient(observed, reference, basis, powers, inverse), word)
            observed_coefficients.append(observed)
            decoded.append({
                "word": word,
                "corona_omitted_coefficient_x": poly_values(observed),
                "decoded_word": word,
            })
        equal(f"word_fiber_cardinality_r{depth}_m{length}",
              len({tuple(poly_values(p)) for p in observed_coefficients}), 1 << length)
        word_examples.append({
            "r": depth, "m": length, "n": 2 * h,
            "decoder_x_pivots": list(powers),
            "inflated_insertion_basis_x": [poly_values(column) for column in basis],
            "decoded": decoded,
            "scope": "Complete word enumeration for these parameters only; every x coefficient is retained.",
        })

    structural = []
    for depth, word in ((1, (0, 1)), (2, (1, 0)), (3, (0, 1)), (5, (1,)), (6, (0,))):
        nc, ec = knot_tree(depth, word)
        data = structure(nc, ec, 0)
        expected = 2 * switch_order(depth) * len(word) + 8
        equal(f"actual_structure_order_r{depth}_m{len(word)}", nc, expected)
        if data["maximum_degree"] > 6:
            raise ArithmeticError("The actual knot tree exceeds degree six")
        matching = forced_matching(nc // 2, ec)
        structural.append({
            "r": depth, "word": word, **data,
            "perfect_matching_size": len(matching),
            "unique_matching_by_fresh_leaf_forcing": True,
        })

    return {
        "goal_claim": "CKNOTJETFIBER",
        "evidence_kind": "ordinary universal proof with exact bounded implementation replay",
        "proof": "research/knot_jet_fibers.md",
        "new_claims": ["CKNOTCORONA", "CKNOTJETS", "CKNOTNESS", "CKNOTJETFIBER"],
        "accepted_inputs": ["CFULLJETFIBER", "CPOLARDATA", "CINTERLACE", "CJOINTCOMPARE", "CPLABIC"],
        "unchanged_reviewed_certificate_programs_invoked": False,
        "formal_kernel_evidence": False,
        "independent_review_required": True,
        "novelty_status": "unverified",
        "significance_status": "unassessed",
        "project_complete": False,
        "jacobian": jacobian,
        "exact_zero_residuals": residuals,
        "small_full_rank_examples": small,
        "explicit_full_knot_examples": full_examples,
        "all_x_endpoint_examples": endpoint_examples,
        "exact_word_decoding_examples": word_examples,
        "actual_structure_examples": structural,
        "universal_conclusions": {
            "quantifiers": "Every integer r,m>=1.",
            "corona_refinement": "(1+x)^h*C_T(x*(1+x*y)/(1+x)^2,y*(1+x)/(1+x*y))",
            "independence": "(1+x)^h*I_T(x/(1+x))",
            "matching": "(1+x)^h*M_T(x/(1+x)^2)",
            "omitted_coefficient": "(1+x)^(h+r)*([y^r]Delta)(x/(1+x)^2)",
            "normalized_count": "(q^2-q+1)^h*I_T(q/(q^2-q+1))",
            "conway": "(1+z^2)^h*M_T(z^2/(1+z^2)^2)",
            "knotness": "Forced perfect matching gives Conway constant one; the prose oriented-skein induction excludes every multi-component link.",
            "tree_order": "N=2*n(r)*m+8",
            "maximum_tree_degree": 6,
            "fiber_size": "2^m",
            "fiber_log2": "(N-8)/(2*n(r))>=(N-8)/(74*r^2)",
            "comparison": "Knot-subclass improvement at doubled order, not an improvement over the accepted unrestricted-link rate.",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--certify", action="store_true")
    mode.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.certify and args.output is None:
        parser.error("--certify requires --output")
    if args.check and args.output is not None:
        parser.error("--check cannot be combined with --output")
    certificate = certify()
    serialized = json.loads(json.dumps(certificate))
    if args.certify:
        args.output.write_text(json.dumps(serialized, indent=2) + "\n")
        if json.loads(args.output.read_text()) != serialized:
            raise ArithmeticError("The persisted knot certificate failed exact JSON readback")
    elif json.loads(args.check.read_text()) != serialized:
        raise ArithmeticError("The retained knot certificate differs from exact replay")
    words = sum(len(example["decoded"]) for example in certificate["exact_word_decoding_examples"])
    print(f"Knot corona delta verified: {len(certificate['exact_zero_residuals'])} zero residuals; {words} exactly decoded words.")


if __name__ == "__main__":
    main()
