#!/usr/bin/env python3
"""Replay exact algebraic subclaims; this does not encode the surface geometry."""

import argparse
import copy
import itertools
import json
import math
import sys
from collections import Counter
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


class VerificationError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def load_json(path):
    with path.open(encoding="utf-8") as stream:
        return json.load(stream)


def same(expected, actual, path="certificate"):
    require(type(actual) is type(expected), f"{path}: wrong type")
    if isinstance(expected, dict):
        require(expected.keys() == actual.keys(), f"{path}: wrong fields")
        for key in expected:
            same(expected[key], actual[key], f"{path}.{key}")
    elif isinstance(expected, list):
        require(len(expected) == len(actual), f"{path}: wrong list length")
        for index, (left, right) in enumerate(zip(expected, actual)):
            same(left, right, f"{path}[{index}]")
    else:
        require(expected == actual, f"{path}: wrong value")


def add(a, b, moduli):
    return tuple((x + y) % m for x, y, m in zip(a, b, moduli))


def scale(k, a, moduli):
    return tuple(k * x % m for x, m in zip(a, moduli))


def element_order(a, moduli):
    return math.lcm(*(m // math.gcd(m, x) for m, x in zip(moduli, a)))


def local_kernel(moduli, alpha, beta):
    a = element_order(alpha, moduli)
    e = element_order(beta, moduli)
    alpha_powers = {scale(i, alpha, moduli): i for i in range(a)}
    for c in range(1, e + 1):
        target = scale(-c, beta, moduli)
        if target in alpha_powers:
            b = alpha_powers[target]
            break
    require(e % c == 0, "local kernel: bad coset order")
    require((e // c) * b % a == 0, "local kernel: bad periodicity")
    image = set()
    zero = (0,) * len(moduli)
    checks = 0
    for x in range(a):
        for y in range(e):
            value = add(scale(x, alpha, moduli), scale(y, beta, moduli), moduli)
            image.add(value)
            lattice = y % c == 0 and (x - b * (y // c)) % a == 0
            require((value == zero) == lattice, "local kernel lattice mismatch")
            checks += 1
    require(len(image) == a * c, "local kernel index mismatch")
    return {
        "moduli": list(moduli),
        "meridians": [list(alpha), list(beta)],
        "meridian_orders": [a, e],
        "kernel_basis_columns": [[a, 0], [b, c]],
        "image_order": len(image),
        "image_elements": [list(x) for x in sorted(image)],
    }, checks


def local_exhaustion():
    pairs = coefficient_checks = 0
    histogram = Counter()
    for m in range(1, 7):
        for n in range(1, 7):
            elements = list(itertools.product(range(m), range(n)))
            for alpha in elements:
                for beta in elements:
                    witness, count = local_kernel((m, n), alpha, beta)
                    pairs += 1
                    coefficient_checks += count
                    histogram[witness["image_order"]] += 1
    require(pairs == sum(i * i for i in range(1, 7)) ** 2, "wrong local range")
    examples = [
        ((1, 1), (0, 0), (0, 0)),
        ((2, 2), (1, 0), (1, 0)),
        ((2, 2), (1, 0), (0, 1)),
        ((4, 2), (1, 0), (1, 1)),
        ((4, 4), (1, 1), (1, 3)),
        ((6, 4), (1, 1), (2, 1)),
        ((3, 5), (1, 1), (1, 2)),
    ]
    return {
        "scope": "All ordered meridian pairs in C_m x C_n, 1<=m,n<=6; finite only.",
        "checked_pairs": pairs,
        "checked_period_rectangle_points": coefficient_checks,
        "image_order_histogram": {str(k): histogram[k] for k in sorted(histogram)},
        "examples": [local_kernel(*example)[0] for example in examples],
    }


def determinant(a):
    return a[0][0] * a[1][1] - a[0][1] * a[1][0]


def multiply(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(2)) for j in range(2)]
        for i in range(2)
    ]


def integer_matrix(data):
    same("ZZ", data["domain"], "Jacobian matrix domain")
    same(2, data["row_count"], "Jacobian row count")
    same(2, data["column_count"], "Jacobian column count")
    entries = data["entries"]
    require(len(entries) == 2 and all(len(row) == 2 for row in entries),
            "Jacobian matrix shape")
    for row in entries:
        for value in row:
            require(type(value) is str, "Jacobian integers must be typed strings")
            require(str(int(value)) == value, "noncanonical Jacobian integer")
    return [[int(value) for value in row] for row in entries]


def smith_certificate():
    operation = "matrix.normal_form.smith.certified.compute"
    payload = {
        "matrix": {
            "domain": "ZZ", "row_count": 2, "column_count": 2,
            "entries": [["4", "-2"], ["0", "2"]],
        }
    }
    same(payload, load_json(ROOT / "jacobian_payload.json"), "Jacobian payload")
    record = load_json(ROOT / "jacobian_result.json")
    same(operation, record["request"]["operation_id"], "Jacobian requested operation")
    same(payload, record["request"]["payload"], "Jacobian recorded payload")
    same(operation, record["result"]["operation_id"], "Jacobian result operation")
    same("0.14.0", record["server"]["version"], "Jacobian server")
    same("2025-11-25", record["protocol_version"], "Jacobian protocol")
    same("mcp-stdio", record["transport"], "Jacobian transport")
    status = load_json(ROOT / "jacobian_status.json")
    same(0, status["exit_code"], "Jacobian exit")
    same(False, status["timed_out"], "Jacobian timeout")
    same("", status["stderr"], "Jacobian stderr")
    output = record["result"]["output"]
    same("FULL_MATRIX_TRANSFORMATIONS", output["completeness"], "Smith completeness")
    same("EXACT_INTEGER", output["exactness"], "Smith exactness")
    same("DETERMINISTIC", output["determinism"], "Smith determinism")
    certificate = output["certificate"]
    same("DIAGONAL_EQUALS_LEFT_TIMES_SOURCE_TIMES_RIGHT",
         certificate["relation"], "Smith convention")
    same("POSITIVE_DIVISIBILITY_DIAGONAL", certificate["convention"], "Smith signs")
    same("FULL_BASIS_BOTH_SIDES", certificate["transformation_scope"], "Smith scope")
    source = integer_matrix(certificate["source"])
    diagonal = integer_matrix(certificate["diagonal"])
    left = integer_matrix(certificate["left_transformation"])
    right = integer_matrix(certificate["right_transformation"])
    same([[4, -2], [0, 2]], source, "Smith source")
    same([[2, 0], [0, 4]], diagonal, "Smith diagonal")
    require(abs(determinant(left)) == abs(determinant(right)) == 1,
            "Smith transformations are not unimodular")
    require(multiply(multiply(left, source), right) == diagonal, "D != U A V")
    same(str(determinant(left)), certificate["left_determinant"], "Smith det U")
    same(str(determinant(right)), certificate["right_determinant"], "Smith det V")
    same(["2", "4"], certificate["invariant_factors"], "Smith invariants")
    same(2, certificate["rank"], "Smith rank")
    return {
        "operation": operation,
        "source": source, "left": left, "right": right, "diagonal": diagonal,
        "invariant_factors": [2, 4], "lattice_index": abs(determinant(source)),
        "adapter_exit": 0, "timed_out": False,
        "scope": "One mixed crossing kernel lattice, not geometric resolution.",
    }


def crossing_models():
    moduli = (4, 2)
    alpha, beta = (1, 0), (1, 1)
    full_rays = [(4, 0), (2, 2), (0, 4)]
    full_images = [
        add(scale(x, alpha, moduli), scale(y, beta, moduli), moduli)
        for x, y in full_rays
    ]
    require(all(v == (0, 0) for v in full_images), "full detection failed")
    full_determinants = [
        determinant([[x[0], y[0]], [x[1], y[1]]])
        for x, y in zip(full_rays, full_rays[1:])
    ]
    require(full_determinants == [8, 8], "mixed fan not regular in its lattice")
    weak_rays = [(2, 0), (1, 1), (0, 2)]
    weak_images = [(x % 2, y % 2) for x, y in weak_rays]
    weak_quotient = [(x + y) % 2 for x, y in weak_images]
    require(weak_images[1] != (0, 0) and weak_quotient[1] == 0,
            "cyclic-only countermodel lost its obstruction")
    for axis in [(1, 0), (0, 1)]:
        require((axis[0] + axis[1]) % 2 == 1, "cyclic restriction not injective")
    weak_determinants = [
        determinant([[x[0], y[0]], [x[1], y[1]]])
        for x, y in zip(weak_rays, weak_rays[1:])
    ]
    require(weak_determinants == [2, 2], "A1 fan not regular in parity lattice")
    chart = {"u": [1, 0], "v": [1, 2], "z": [1, 1]}
    require([chart["u"][i] + chart["v"][i] for i in range(2)]
            == [2 * x for x in chart["z"]], "z^2=uv chart exponent error")
    return {
        "full_detection": {
            "local_group_moduli": [4, 2],
            "meridians": [list(alpha), list(beta)],
            "kernel_basis_columns": [[4, 0], [-2, 2]],
            "image_order": 8, "product_of_separate_orders": 16,
            "fan_rays": [list(v) for v in full_rays],
            "projected_images": [list(v) for v in full_images],
            "adjacent_determinants": full_determinants,
        },
        "cyclic_only_countermodel": {
            "scope": "Refutes only cyclic-only detection, not the manuscript lemma.",
            "local_group_moduli": [2, 2], "quotient_modulus": 2,
            "quotient_map": "a+b mod 2",
            "fan_rays": [list(v) for v in weak_rays],
            "local_images": [list(v) for v in weak_images],
            "quotient_images": weak_quotient,
            "adjacent_determinants": weak_determinants,
            "exceptional_meridian": [1, 1],
            "exceptional_image": [1, 1],
            "resolution_chart_exponents": chart,
        },
    }


def cyclic_models():
    models = []
    for e in range(1, 33):
        kernel, _ = local_kernel((1, e), (0, 0), (0, 1 % e))
        require(kernel["kernel_basis_columns"] == [[1, 0], [0, e]],
                "vertical-zero local kernel is not Z x eZ")
        euler = 2 * e - 2 * (e - 1)
        require(euler == 2, "two-branch Riemann-Hurwitz arithmetic failed")
        models.append({
            "horizontal_order": e,
            "kernel_basis_columns": kernel["kernel_basis_columns"],
            "map_monomial_exponents": [[1, 0], [0, e]],
            "pullback_boundary_exponents": [1, e],
            "reduced_boundary_exponents": [1, 1],
            "jacobian_monomial": {"coefficient": e, "exponents": [0, e - 1]},
            "tail_degree": e, "attaching_node_preimages": e,
            "two_branch_euler_characteristic": euler,
            "two_branch_genus": (2 - euler) // 2,
        })
    return {
        "scope": "Exact arithmetic for orders 1..32; all-order geometry is proved in REPORT.md.",
        "models": models,
    }


def abelian_table(moduli):
    elements = list(itertools.product(*(range(m) for m in moduli)))
    index = {x: i for i, x in enumerate(elements)}
    return [[index[add(x, y, moduli)] for y in elements] for x in elements]


def dihedral_table():
    return [
        [((i % 4 + (-1) ** (i // 4) * (j % 4)) % 4) + 4 * ((i // 4 + j // 4) % 2)
         for j in range(8)]
        for i in range(8)
    ]


def group_checks(table):
    n = len(table)
    require(all(len(row) == n for row in table), "group table shape")
    for a in range(n):
        require(table[a][0] == table[0][a] == a, "group identity")
        require(any(table[a][b] == table[b][a] == 0 for b in range(n)),
                "group inverse")
        for b in range(n):
            require(0 <= table[a][b] < n, "group closure")
            for c in range(n):
                require(table[table[a][b]][c] == table[a][table[b][c]],
                        "group associativity")


def generated(table, generators):
    reached = {0}
    queue = [0]
    for x in queue:
        for a in generators:
            y = table[x][a]
            if y not in reached:
                reached.add(y)
                queue.append(y)
    return sorted(reached)


def cosets(table, subgroup):
    remaining = set(range(len(table)))
    result = []
    while remaining:
        p = min(remaining)
        coset = sorted(table[p][a] for a in subgroup)
        require(set(coset) <= remaining, "cosets overlap improperly")
        result.append(coset)
        remaining.difference_update(coset)
    return result


def incidence_graph(table, generators):
    order = len(table)
    nodes = [{"kind": "main", "sheet": p} for p in range(order)]
    edges = []
    degrees = []
    tail_cosets = []
    for j, a in enumerate(generators):
        subgroup = generated(table, [a])
        degrees.append(len(subgroup))
        blocks = cosets(table, subgroup)
        tail_cosets.append(blocks)
        for block in blocks:
            vertex = len(nodes)
            nodes.append({"kind": "tail", "tail": j, "coset": block})
            edges.extend([[p, vertex] for p in block])
    adjacency = [set() for _ in nodes]
    for a, b in edges:
        adjacency[a].add(b)
        adjacency[b].add(a)
    components = []
    remaining = set(range(len(nodes)))
    while remaining:
        component = {min(remaining)}
        queue = list(component)
        for vertex in queue:
            for neighbor in sorted(adjacency[vertex]):
                if neighbor not in component:
                    component.add(neighbor)
                    queue.append(neighbor)
        components.append(sorted(component))
        remaining.difference_update(component)
    subgroup = generated(table, generators)
    expected_main_blocks = cosets(table, subgroup)
    main_blocks = sorted([sorted(v for v in c if v < order) for c in components])
    require(main_blocks == expected_main_blocks, "graph components are not P/H")
    c = order // len(subgroup)
    betti = len(edges) - len(nodes) + len(components)
    formula = order * (len(generators) - 1) - sum(order // e for e in degrees) + c
    require(len(components) == c and betti == formula and betti >= 0,
            "coset graph Betti formula failed")
    return {
        "group_order": order, "generators": list(generators),
        "cyclic_orders": degrees, "generated_subgroup": subgroup,
        "tail_cosets": tail_cosets, "nodes": nodes, "edges": edges,
        "components": components, "component_count": len(components),
        "first_betti_number": betti,
    }


def graph_models():
    groups = {
        "trivial": abelian_table((1,)),
        "C4": abelian_table((4,)),
        "C2xC2": abelian_table((2, 2)),
        "D8": dihedral_table(),
    }
    for table in groups.values():
        group_checks(table)
    inputs = [
        ("trivial", [0]),
        ("C4", [1, 1]),
        ("C2xC2", [1, 2, 3]),
        ("D8", [4, 5, 1]),
        ("D8", [2, 0]),
        ("C2xC2", [1, 2, 3] * 8),
    ]
    examples = []
    for name, generators in inputs:
        examples.append({"group": name, **incidence_graph(groups[name], generators)})
    counts = {}
    for name in ("C2xC2", "D8"):
        table = groups[name]
        count = 0
        for k in range(4):
            for generators in itertools.product(range(len(table)), repeat=k):
                incidence_graph(table, generators)
                count += 1
        counts[name] = count
    return {
        "scope": "Finite combinatorial models, not constructed projective surfaces.",
        "multiplication_tables": groups,
        "exhaustion": {"generator_list_lengths": [0, 1, 2, 3], "counts": counts},
        "examples": examples,
    }


def barycentric_checks():
    count = 0
    for vertices in range(1, 5):
        for weights in itertools.product(range(3), repeat=vertices):
            total = sum(weights)
            if not total:
                continue
            point = [Fraction(x, total) for x in weights]
            for mask in range(1, 1 << vertices):
                retained = [bool(mask & (1 << i)) for i in range(vertices)]
                s = sum((x for x, keep in zip(point, retained) if keep), Fraction(0))
                if not s:
                    continue
                retract = [x / s if keep else Fraction(0)
                           for x, keep in zip(point, retained)]
                require(sum(retract) == 1, "retraction barycentric sum")
                for t in (Fraction(0), Fraction(1, 3), Fraction(1, 2), Fraction(1)):
                    homotopy = [(1 - t) * x + t * y for x, y in zip(point, retract)]
                    new_s = sum((x for x, keep in zip(homotopy, retained) if keep),
                                Fraction(0))
                    require(new_s > 0 and sum(homotopy) == 1,
                            "homotopy left its open star")
                    require(all(x >= 0 for x in homotopy), "negative barycentric coordinate")
                    again = [x / new_s if keep else Fraction(0)
                             for x, keep in zip(homotopy, retained)]
                    require(again == retract, "retraction homotopy mismatch")
                    count += 1
    return {
        "scope": "Finite exact checks of the local formula, not a triangulation theorem.",
        "simplex_vertex_counts": [1, 2, 3, 4],
        "unnormalized_coordinate_values": [0, 1, 2],
        "homotopy_parameters": [[0, 1], [1, 3], [1, 2], [1, 1]],
        "checked_homotopies": count,
        "fullness_warning": {
            "complex": "closed triangle",
            "subcomplex": "boundary, not full before subdivision",
            "point": [[1, 3], [1, 3], [1, 3]],
            "retained_vertex_sum": [1, 1],
            "formula_lands_in_subcomplex": False,
        },
    }


def build_certificate():
    return {
        "claim": "S_SURFACE_DYADIC",
        "result_kind": "exact_subclaim_certificate_supporting_a_universal_prose_proof",
        "independent_review": "pending_host_reviewer_for_new_geometry",
        "formal_kernel_scope": "S_MERIDIAN_KERNEL only; see statement_fidelity.md",
        "unencoded_obligations": [
            "The reviewed actual-family infinite quotient, reused unchanged.",
            "Algebraization, normalization and prescribed-open resolution.",
            "Identification of the actual fiber with the local models and coset graph.",
            "Properness, compatible triangulation and specialization of infinite image.",
            "Universal covering geometry, maximum principle and holomorphic hull.",
        ],
        "local_kernel_exhaustion": local_exhaustion(),
        "jacobian_smith": smith_certificate(),
        "crossing_models": crossing_models(),
        "vertical_zero_cyclic_models": cyclic_models(),
        "rational_fiber_graphs": graph_models(),
        "neighborhood_retraction_formula": barycentric_checks(),
    }


def reject_altered_witnesses(expected):
    mutations = [
        (("local_kernel_exhaustion", "checked_pairs"), 1),
        (("local_kernel_exhaustion", "examples", 3, "kernel_basis_columns", 1, 0), 1),
        (("jacobian_smith", "left", 0, 0), 2),
        (("crossing_models", "cyclic_only_countermodel", "exceptional_image"), [0, 0]),
        (("crossing_models", "full_detection", "projected_images", 1), [1, 0]),
        (("vertical_zero_cyclic_models", "models", 1, "two_branch_genus"), 1),
        (("vertical_zero_cyclic_models", "models", 0, "horizontal_order"), True),
        (("rational_fiber_graphs", "examples", 1, "edges", 0, 1), 0),
        (("rational_fiber_graphs", "examples", 2, "first_betti_number"), 0),
        (("rational_fiber_graphs", "examples", 4, "component_count"), 1),
        (("neighborhood_retraction_formula", "fullness_warning",
          "formula_lands_in_subcomplex"), True),
        (("unencoded_obligations",), []),
    ]
    for path, replacement in mutations:
        altered = copy.deepcopy(expected)
        parent = altered
        for key in path[:-1]:
            parent = parent[key]
        parent[path[-1]] = replacement
        try:
            same(expected, altered)
        except VerificationError:
            continue
        raise VerificationError(f"altered witness accepted: {path}")
    return len(mutations)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    parser.add_argument("--write", action="store_true",
                        help="generate this mission's exact certificate before replay")
    args = parser.parse_args()
    expected = build_certificate()
    if args.write:
        require(args.certificate.resolve() == ROOT / "exact_certificate.json",
                "--write is restricted to this mission's certificate")
        args.certificate.write_text(json.dumps(expected, indent=2) + "\n", encoding="utf-8")
    same(expected, load_json(args.certificate))
    rejected = reject_altered_witnesses(expected)
    print(json.dumps({
        "status": "passed",
        "local_meridian_pairs": expected["local_kernel_exhaustion"]["checked_pairs"],
        "coefficient_checks":
            expected["local_kernel_exhaustion"]["checked_period_rectangle_points"],
        "graph_generator_lists": expected["rational_fiber_graphs"]["exhaustion"]["counts"],
        "cyclic_orders_checked": [1, 32],
        "altered_witnesses_rejected": rejected,
        "whole_surface_geometry_machine_verified": False,
    }, sort_keys=True))


if __name__ == "__main__":
    try:
        main()
    except (VerificationError, OSError, ValueError, KeyError, TypeError) as error:
        print(f"verification failed: {error}", file=sys.stderr)
        sys.exit(1)
