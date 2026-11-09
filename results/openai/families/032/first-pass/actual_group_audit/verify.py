#!/usr/bin/env python3
"""Recompute the finite algebraic certificate for the universal proof in report.tex.

Uses only the Python standard library. No network, Argus installation, floating
point arithmetic, or stored answers are needed to recompute the mathematics.
"""

import argparse
import json
from collections import Counter
from fractions import Fraction
from itertools import combinations, combinations_with_replacement, permutations, product
from math import isqrt, prod
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def transpose(a):
    return [list(row) for row in zip(*a)]


def rref(rows):
    a = [[Fraction(x) for x in row] for row in rows]
    require(bool(a) and bool(a[0]), "Empty linear system")
    require(all(len(row) == len(a[0]) for row in a), "Nonrectangular matrix")
    pivots = []
    for col in range(len(a[0])):
        pivot = next((i for i in range(len(pivots), len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        row = len(pivots)
        a[row], a[pivot] = a[pivot], a[row]
        scale = a[row][col]
        a[row] = [x / scale for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][col]:
                factor = a[i][col]
                a[i] = [x - factor * y for x, y in zip(a[i], a[row])]
        pivots.append(col)
        if len(pivots) == len(a):
            break
    return a, pivots


def nullspace(rows):
    a, pivots = rref(rows)
    free = [j for j in range(len(a[0])) if j not in pivots]
    basis = []
    for col in free:
        v = [Fraction(0)] * len(a[0])
        v[col] = Fraction(1)
        for i, pivot in enumerate(pivots):
            v[pivot] = -a[i][col]
        require(all(sum(x * y for x, y in zip(row, v)) == 0 for row in rows),
                "Kernel residual is nonzero")
        basis.append(v)
    return basis, pivots, free


def rank(rows):
    return len(rref(rows)[1])


def eye(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def unit(n, i, j):
    return [[int(r == i and c == j) for c in range(n)] for r in range(n)]


def add(a, b, sign=1):
    return [[x + sign * y for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def multiply(a, b):
    return [[sum(x * y for x, y in zip(row, col)) for col in transpose(b)] for row in a]


def kron(a, b):
    return [
        [a[i // len(b)][j // len(b[0])] * b[i % len(b)][j % len(b[0])]
         for j in range(len(a[0]) * len(b[0]))]
        for i in range(len(a) * len(b))
    ]


def flatten(a):
    return [x for row in a for x in row]


def invariant_equations(generators, commutant=False):
    n = len(generators[0])
    rows = []
    for x in generators:
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[n * k + j] += x[i][k] if commutant else x[k][i]
                    row[n * i + k] += -x[k][j] if commutant else x[k][j]
                if any(row):
                    rows.append(row)
    return rows


def sl_basis(n):
    return (
        [unit(n, i, j) for i in range(n) for j in range(n) if i != j]
        + [add(unit(n, i, i), unit(n, i + 1, i + 1), -1) for i in range(n - 1)]
    )


def sp_basis(m):
    n = 2 * m
    basis = []
    for i in range(m):
        for j in range(m):
            basis.append(add(unit(n, i, j), unit(n, m + j, m + i), -1))
    for i in range(m):
        for j in range(i, m):
            upper = unit(n, i, m + j)
            lower = unit(n, m + i, j)
            if i != j:
                upper = add(upper, unit(n, j, m + i))
                lower = add(lower, unit(n, m + j, i))
            basis.extend([upper, lower])
    return basis


def so4_generators():
    e, f, identity = unit(2, 0, 1), unit(2, 1, 0), eye(2)
    return [kron(e, identity), kron(f, identity), kron(identity, e), kron(identity, f)]


def wedge_square(x):
    pairs = list(combinations(range(len(x)), 2))
    matrix = [[0] * len(pairs) for _ in pairs]
    for col, (i, j) in enumerate(pairs):
        for k in range(len(x)):
            for a, b, value in ((k, j, x[k][i]), (i, k, x[k][j])):
                if a != b:
                    row = pairs.index(tuple(sorted((a, b))))
                    matrix[row][col] += value if a < b else -value
    return matrix


def model_record(name, basis, expected_dimension, expected_form_sign):
    n = len(basis[0])
    image_rank = rank([flatten(x) for x in basis])
    forms, _, _ = nullspace(invariant_equations(basis))
    centralizer, _, _ = nullspace(invariant_equations(basis, commutant=True))
    require(image_rank == expected_dimension, name + ": wrong Lie-image dimension")
    require(len(centralizer) == 1, name + ": nonscalar commutant")
    if expected_form_sign == 0:
        require(not forms, name + ": unexpected self-duality")
    else:
        require(len(forms) == 1, name + ": invariant form not unique")
        form = [forms[0][i * n:(i + 1) * n] for i in range(n)]
        require(rank(form) == n, name + ": degenerate invariant form")
        require(form == [[expected_form_sign * x for x in row] for row in transpose(form)],
                name + ": wrong symmetry sign")
    return {
        "module": name, "dimension": n, "lie_image_dimension": image_rank,
        "commutant_dimension": len(centralizer), "invariant_form_dimension": len(forms),
        "form_symmetry": expected_form_sign,
        "form_basis": [[str(v) for v in vector] for vector in forms],
    }


def matrix_models():
    records = [
        model_record("SL" + str(n) + "_standard", sl_basis(n), n * n - 1, -1 if n == 2 else 0)
        for n in range(2, 7)
    ]
    records.extend(
        model_record("Sp" + str(2 * m) + "_standard", sp_basis(m), m * (2 * m + 1), -1)
        for m in (2, 3)
    )
    a1 = sl_basis(2)
    so4 = [kron(x, eye(2)) for x in a1] + [kron(eye(2), x) for x in a1]
    records.append(model_record("SL2_tensor_SL2", so4, 6, 1))
    so6 = [wedge_square(x) for x in sl_basis(4)]
    records.append(model_record("SL4_wedge2", so6, 15, 1))
    for x in sl_basis(4):
        for y in sl_basis(4):
            require(
                wedge_square(add(multiply(x, y), multiply(y, x), -1))
                == add(multiply(wedge_square(x), wedge_square(y)),
                       multiply(wedge_square(y), wedge_square(x)), -1),
                "Exterior-square representation fails the bracket identity",
            )
    diagonal = [add(kron(x, eye(2)), kron(eye(2), x)) for x in a1]
    diag_centralizer = nullspace(invariant_equations(diagonal, commutant=True))[0]
    require(len(diag_centralizer) == 2, "Diagonal SL2 exclusion not detected")
    diagonal_copies = [kron(eye(2), x) for x in a1]
    independent_copies = [
        kron(unit(2, i, i), x) for i in range(2) for x in a1
    ]
    copy_commutants = [
        len(nullspace(invariant_equations(basis, commutant=True))[0])
        for basis in (diagonal_copies, independent_copies)
    ]
    require(copy_commutants == [4, 2], "Matrix-copy obstruction not detected")
    alternating = [[0, 1], [-1, 0]]
    for weight in (-1, 1):
        pure_differential = [[weight * x for x in row] for row in eye(2)]
        pure_action = add(multiply(transpose(pure_differential), alternating),
                          multiply(alternating, pure_differential))
        require(pure_action == [[2 * weight * x for x in row] for row in alternating],
                "Pure orientation has the wrong determinant weight")
    mixed_differential = [[1, 0], [0, -1]]
    mixed_action = add(multiply(transpose(mixed_differential), alternating),
                       multiply(alternating, mixed_differential))
    require(mixed_action == [[0, 0], [0, 0]], "Mixed Hodge-pair distinction lost")
    return {
        "models": records,
        "so4_diagonal_control": {
            "lie_image_dimension": rank([flatten(x) for x in diagonal]),
            "commutant_dimension": len(diag_centralizer),
            "interpretation": "Excluded representation diagram, not an abelian-variety counterexample.",
        },
        "matrix_copy_control": {
            "diagonal_commutant_dimension": copy_commutants[0],
            "independent_commutant_dimension": copy_commutants[1],
            "interpretation": "The diagonal action on two copies enlarges the actual commutant and is absorbed by matrix-copy identification.",
        },
        "rank_two_pair_control": {
            "pure_circle_weights_on_alternating_determinant": [-2, 2],
            "mixed_circle_weight_on_alternating_determinant": 0,
            "interpretation": "Derived self-duality does not imply an all-conjugate (1,1) self-pair.",
        },
    }


def cartan(kind, n):
    a = [[2 * int(i == j) for j in range(n)] for i in range(n)]
    if kind == "G":
        return [[2, -1], [-3, 2]]
    for i in range(n - 1):
        a[i][i + 1] = a[i + 1][i] = -1
    if kind == "B":
        a[n - 1][n - 2] = -2
    elif kind == "C":
        a[n - 2][n - 1] = -2
    elif kind == "D":
        a[n - 2][n - 1] = a[n - 1][n - 2] = 0
        a[n - 3][n - 1] = a[n - 1][n - 3] = -1
    elif kind == "F":
        a[2][1] = -2
    return a


def roots(a):
    n = len(a)
    pending = [tuple(row) for row in eye(n)]
    found = set(pending)
    while pending:
        root = pending.pop()
        for i in range(n):
            reflected = list(root)
            reflected[i] -= sum(a[i][j] * root[j] for j in range(n))
            reflected = tuple(reflected)
            if reflected not in found:
                found.add(reflected)
                pending.append(reflected)
        require(len(found) <= 240, "Root closure exceeds the finite-type bound")
    require(all(all(c >= 0 for c in r) or all(c <= 0 for c in r) for r in found),
            "Root does not have a definite sign")
    return sorted(found)


def weight_orbit(a, highest):
    pending = [tuple(highest)]
    found = set(pending)
    while pending:
        weight = pending.pop()
        for i in range(len(a)):
            reflected = tuple(weight[j] - weight[i] * a[j][i] for j in range(len(a)))
            if reflected not in found:
                found.add(reflected)
                pending.append(reflected)
    return found


def root_certificate():
    types = (
        [("A", n) for n in range(1, 6)]
        + [(kind, n) for kind in ("B", "C") for n in range(2, 6)]
        + [("D", 4), ("D", 5), ("F", 4), ("G", 2)]
    )
    systems, small = [], []
    for kind, n in types:
        a = cartan(kind, n)
        all_roots = roots(a)
        all_coroots = roots(transpose(a))
        expected = {
            "A": n * (n + 1), "B": 2 * n * n, "C": 2 * n * n,
            "D": 2 * n * (n - 1), "F": 48, "G": 12,
        }[kind]
        require(len(all_roots) == len(all_coroots) == expected, "Wrong root-system size")
        positive = [r for r in all_coroots if all(x >= 0 for x in r)]
        minuscule = []
        for i in range(n):
            if any(r[i] > 1 for r in positive):
                continue
            dimension = prod(Fraction(sum(r) + r[i], sum(r)) for r in positive)
            require(dimension.denominator == 1, "Nonintegral Weyl dimension")
            highest = tuple(int(j == i) for j in range(n))
            orbit = weight_orbit(a, highest)
            require(len(orbit) == dimension, "Weyl orbit and dimension disagree")
            record = {
                "type": kind + str(n), "fundamental_weight": i + 1,
                "dimension": int(dimension),
                "self_dual": tuple(-x for x in highest) in orbit,
            }
            minuscule.append(record)
            if dimension <= 6:
                small.append(record)
        systems.append({
            "type": kind + str(n), "cartan": a, "root_count": len(all_roots),
            "positive_coroots": [list(r) for r in positive], "minuscule_modules": minuscule,
        })
    expected_small = {
        ("A1", 1, 2), ("A2", 1, 3), ("A2", 2, 3),
        ("A3", 1, 4), ("A3", 2, 6), ("A3", 3, 4),
        ("A4", 1, 5), ("A4", 4, 5), ("A5", 1, 6), ("A5", 5, 6),
        ("B2", 2, 4), ("C2", 1, 4), ("C3", 1, 6),
    }
    require({(m["type"], m["fundamental_weight"], m["dimension"]) for m in small}
            == expected_small, "Small-module table differs from the claimed covering table")
    aliases = {}
    for left, right in ((("B", 2), ("C", 2)), (("D", 3), ("A", 3))):
        a, b = cartan(*left), cartan(*right)
        witnesses = [
            list(p) for p in permutations(range(len(a)))
            if [[a[p[i]][p[j]] for j in range(len(a))] for i in range(len(a))] == b
        ]
        require(bool(witnesses), "Missing exceptional Cartan identification")
        aliases[left[0] + str(left[1]) + "=" + right[0] + str(right[1])] = witnesses
    tensor_dimensions = [
        list(values) for length in (2, 3)
        for values in combinations_with_replacement(range(2, 7), length)
        if prod(values) <= 6
    ]
    require(tensor_dimensions == [[2, 2], [2, 3]], "Missing nontrivial tensor dimension")
    canonical = [m for m in small if m["type"] != "B2"]
    tensor_modules = [
        {"factors": [left, right], "dimension": left["dimension"] * right["dimension"],
         "self_dual": left["self_dual"] and right["self_dual"]}
        for left, right in combinations_with_replacement(canonical, 2)
        if left["dimension"] * right["dimension"] <= 6
    ]
    require(len(tensor_modules) == 3, "Unexpected small minuscule tensor module")
    nonselfdual_tensors = [m for m in tensor_modules if not m["self_dual"]]
    require(all({f["type"] for f in m["factors"]} == {"A1", "A2"}
                for m in nonselfdual_tensors), "Quadratic-center orbit exclusion is incomplete")
    quadratic_simple = [m for m in canonical if not m["self_dual"]]
    require(all(m["type"] == "A" + str(m["dimension"] - 1)
                and m["fundamental_weight"] in (1, m["dimension"] - 1)
                for m in quadratic_simple), "Nonstandard quadratic-center simple module")
    return {
        "rank_bound": 5, "rank_bound_reason": "A faithful simple Lie algebra on n<=6 has a Cartan in traceless diagonal n-by-n matrices.",
        "systems": systems, "small_modules": small,
        "exceptional_identifications": aliases, "tensor_dimensions": tensor_dimensions,
        "tensor_modules": tensor_modules,
        "quadratic_center_simple_modules": quadratic_simple,
        "quadratic_center_tensor_exclusion": "The only nonselfdual composite candidates have different simple types A1 and A2; the one-Galois-orbit argument excludes them.",
    }


def parameter_cases():
    cases, exclusions = [], []

    def append(kind, g, f, r, a, mode=None, signature=None):
        record = {"albert_type": kind, "g": g, "f": f, "r": r, "column_dimension": a,
                  "cost": g * r, "mode": mode, "signature": signature}
        record["name"] = f"{kind}:g{g}:f{f}:r{r}:a{a}"
        if mode:
            record["name"] += ":" + mode + ":p" + ",".join(map(str, signature))
            record["E_copy_ranks"] = [[i, r - i] for i in range(r + 1)] if mode == "split" else []
        cases.append(record)

    for g in range(1, 7):
        for f in range(1, g + 1):
            for r in range(1, 6 // g + 1):
                if g % f == 0 and r % 2 == 0:
                    append("I", g, f, r, 2 * g // f)
                if g % (2 * f) == 0:
                    a = g // f
                    append("II", g, f, r, a)
                    if a == 2:
                        exclusions.append({"type": "III", "g": g, "f": f, "r": r,
                                           "reason": "A symmetric irreducible rank-two derived column would lie in a torus."})
                    else:
                        append("III", g, f, r, a)
                for b in range(1, isqrt(g) + 1):
                    if g % (f * b * b):
                        continue
                    a = g // (f * b)
                    if b > 1:
                        require((g, f, b, a, r) == (4, 1, 2, 2, 1),
                                "Uncovered noncommutative Type IV tuple")
                        exclusions.append({"type": "IV", "g": g, "f": f, "b": b, "r": r,
                                           "reason": "The only embedding pair is pure (CM) or rank-two mixed in every conjugate (extra commutant)."})
                        continue
                    if a == 1:
                        exclusions.append({"type": "IV", "g": g, "f": f, "b": b, "r": r,
                                           "reason": "Rank-one columns give a toric Hodge group."})
                        continue
                    for mode in ("split", "field"):
                        if mode == "field" and r % 2:
                            continue
                        for signature in product(range(a + 1), repeat=f):
                            active = [0 < p < a for p in signature]
                            if not any(active):
                                continue
                            if a == 2 and all(active):
                                continue
                            append("IV", g, f, r, a, mode, list(signature))
    for c in cases:
        a, f, g, r = (c[k] for k in ("column_dimension", "f", "g", "r"))
        require(a in range(2, 7), "Uncovered column dimension")
        if c["albert_type"] in ("I", "II"):
            require(a in (2, 4, 6), "Uncovered alternating dimension")
        elif c["albert_type"] == "III":
            require((g, f, r) in ((4, 1, 1), (6, 1, 1)), "Uncovered Type III case")
        elif c["mode"] == "field":
            require((f, g, r, a) == (1, 3, 2, 3), "Uncovered nonsplit quadratic action")
        else:
            require((f == 1 and 3 <= a == g <= 6)
                    or (f, a, g) in ((2, 2, 4), (2, 3, 6), (3, 2, 6)),
                    "Uncovered split Type IV case")
            if f > 1:
                require(r == 1, "Repeated higher-center factor exceeds the budget")
    require(len({c["name"] for c in cases}) == len(cases), "Duplicate parameter case")
    return cases, exclusions


def partitions(n):
    if n == 0:
        yield ()
        return

    def extend(labels):
        if len(labels) == n:
            yield tuple(labels)
        else:
            for label in range(max(labels) + 2):
                yield from extend(labels + [label])

    yield from extend([0])


def target_data(pack):
    targets, cycles, so4_pairs = [], [], []
    for factor, c in enumerate(pack):
        kind, a, f = c["albert_type"], c["column_dimension"], c["f"]
        start = len(targets)
        if kind == "III" and a == 4:
            so4_pairs.append((start, start + 1))
            cycles.append([start, start + 1])
            for active in (True, False):
                targets.append({"factor": factor, "type": "A1", "module": "tensor2x2",
                                "always_mixed": False, "active": active})
        elif kind == "III":
            targets.append({"factor": factor, "type": "A3", "module": "wedge2of4",
                            "always_mixed": True, "active": True})
        else:
            signature = c["signature"]
            active = [True] * f if signature is None else [0 < p < a for p in signature]
            always_mixed = all(active)
            lie_type = ("A1" if a == 2 else "C" + str(a // 2)) if kind in ("I", "II") else "A" + str(a - 1)
            for bit in active:
                targets.append({"factor": factor, "type": lie_type, "module": "standard" + str(a),
                                "always_mixed": always_mixed, "active": bit})
            if not always_mixed:
                require(f in (2, 3) and any(active), "Not a prime partially pure orbit")
                cycles.append(list(range(start, start + f)))
    for orbit in cycles:
        require(len(targets) - len(orbit) <= 1, "Unproved action on external Galois targets")
    return targets, cycles, so4_pairs


def rejection(labels, targets, cycles, so4_pairs):
    linked = [(i, j) for i in range(len(labels)) for j in range(i + 1, len(labels))
              if labels[i] == labels[j]]
    if any(targets[i]["type"] != targets[j]["type"] for i, j in linked):
        return "nonisomorphic_simple_ideals"
    if any(labels[i] == labels[j] for i, j in so4_pairs):
        return "individual_SO4_projection_not_surjective"
    for orbit in cycles:
        permutation = list(range(len(labels)))
        for i, j in zip(orbit, orbit[1:] + orbit[:1]):
            permutation[i] = j
        if any((labels[i] == labels[j]) != (labels[permutation[i]] == labels[permutation[j]])
               for i in range(len(labels)) for j in range(len(labels))):
            return "not_Galois_invariant"
    if any(targets[i]["active"] != targets[j]["active"] for i, j in linked):
        return "pure_mixed_circle_differential_conflict"
    for i, j in linked:
        left, right = targets[i], targets[j]
        if left["always_mixed"] and right["always_mixed"] and left["module"] == right["module"]:
            return "all_conjugate_intertwiner_enlarges_actual_commutant"
    return None


def graph_certificate(cases):
    packs = [()]

    def extend(prefix, first, cost):
        for i in range(first, len(cases)):
            new_cost = cost + cases[i]["cost"]
            if new_cost <= 6:
                new_prefix = prefix + (i,)
                packs.append(new_prefix)
                extend(new_prefix, i, new_cost)

    extend((), 0, 0)
    outcomes, counts = [], Counter()
    max_targets = 0
    for indices in packs:
        pack = [cases[i] for i in indices]
        targets, cycles, so4_pairs = target_data(pack)
        n = len(targets)
        max_targets = max(max_targets, n)
        require(n <= 3, "The claimed absolute-target budget is false")
        for i, j in combinations(range(n), 2):
            if targets[i]["type"] == targets[j]["type"]:
                require({targets[i]["module"], targets[j]["module"]}
                        != {"wedge2of4", "standard4"}, "SO6 and SL4 coexist within the budget")
        rejected, accepted = [], []
        for labels in partitions(n):
            reason = rejection(labels, targets, cycles, so4_pairs)
            if reason:
                rejected.append({"partition": list(labels), "obstruction": reason})
                counts[reason] += 1
            else:
                accepted.append(list(labels))
        require(accepted == [list(range(n))],
                "A proper subdirect diagram survives: " + repr((indices, accepted)))
        outcomes.append({
            "factors": [c["name"] for c in pack], "dimension_cost": sum(c["cost"] for c in pack),
            "absolute_targets": targets, "necessary_Galois_cycles": cycles,
            "surviving_partitions": accepted, "excluded_partitions": rejected,
        })
    return {
        "parameter_multisets": len(packs), "max_absolute_targets": max_targets,
        "proper_partition_obstructions": dict(sorted(counts.items())),
        "proper_partitions_surviving": 0, "cases": outcomes,
        "coverage": "All multisets of the necessary non-CM factor templates with total dimension <=6; an arbitrary CM remainder contributes no derived target.",
    }


def rational_entry(value):
    value = Fraction(value)
    return {"num": str(value.numerator), "den": str(value.denominator)}


def payload(rows):
    return {"matrix": {"domain": "QQ", "entries": [[rational_entry(x) for x in row] for row in rows]}}


def jacobian_matrices():
    full = invariant_equations(so4_generators())
    reduced, pivots = rref(full)
    reduced = reduced[:len(pivots)]
    require((len(full), len(full[0]), len(reduced)) == (48, 16, 15), "Unexpected SO4 system shape")
    require(rref(full)[0][:15] == rref(reduced)[0], "Row-space compression changed the system")
    return full, reduced


def jacobian_evidence():
    full, reduced = jacobian_matrices()
    require(json.loads((HERE / "jacobian_payload.json").read_text()) == payload(full),
            "Original Jacobian payload does not match the full invariant equations")
    require(json.loads((HERE / "jacobian_reduced_payload.json").read_text()) == payload(reduced),
            "Reduced Jacobian payload does not match exact row-space compression")
    failure = json.loads((HERE / "jacobian_output.json").read_text())
    require(failure["ok"] is False
            and failure["error"]["data"]["code"] == "INVALID_REQUEST"
            and failure["error"]["data"]["errors"][0]["code"] == "matrix.budget_exceeded",
            "The original adapter failure is not preserved")
    reply = json.loads((HERE / "jacobian_reduced_output.json").read_text())
    require(reply["result"]["operation_id"] == "matrix.nullspace.compute",
            "Wrong Jacobian operation")
    output = reply["result"]["output"]
    basis, pivots, free = nullspace(full)
    require(output["matrix"] == payload(reduced)["matrix"], "Jacobian checked a different matrix")
    require(output["ambient_dimension"] == 16 and output["rank"] == len(pivots) == 15
            and output["nullity"] == len(basis) == 1, "Jacobian dimension mismatch")
    require(output["free_columns"] == free
            and output["convention"] == "RREF_FUNDAMENTAL_BASIS", "Jacobian basis convention mismatch")
    require(output["basis_vectors"] == [[rational_entry(x) for x in v] for v in basis],
            "Jacobian basis differs from independent exact elimination")
    return {
        "operation_id": reply["result"]["operation_id"],
        "server": reply["server"],
        "protocol_version": reply["protocol_version"],
        "transport": reply["transport"],
        "original_request": {
            "payload_file": "jacobian_payload.json", "output_file": "jacobian_output.json",
            "adapter_exit_code": 2, "status": "INVALID_REQUEST_NOT_A_MATHEMATICAL_VERDICT",
            "structured_error": failure["error"],
        },
        "row_equivalent_request": {
            "payload_file": "jacobian_reduced_payload.json",
            "output_file": "jacobian_reduced_output.json",
            "adapter_exit_code": 0, "status": "EXACT_KERNEL_RETURNED_AND_INDEPENDENTLY_RECOMPUTED",
            "rows": len(reduced), "columns": 16, "rank": 15, "nullity": 1,
            "basis_vectors": output["basis_vectors"], "free_columns": output["free_columns"],
        },
    }


def compute():
    root_data = root_certificate()
    cases, exclusions = parameter_cases()
    return {
        "certificate_version": 1,
        "claim_id": "AG-UNIVERSAL",
        "result_kind": "exact_algebraic_certificate_for_a_prose_universal_verification_theorem",
        "scope": {
            "dimension_bound": 6,
            "action": "unital imaginary-quadratic action on the actual abelian variety",
            "verified_conclusion": "Derived-column independence, subject to the geometric reduction proved in report.tex and the explicitly cited structural inputs.",
            "not_claimed": [
                "Geometric realizability of every numerical template",
                "Independence of central characters",
                "Determinant-balance condition (d) or any Hodge-conjecture conclusion",
                "A Lean/kernel proof of the geometric bridge",
                "Independent Reviewer acceptance or verified publication novelty",
            ],
        },
        "root_systems": root_data,
        "rational_matrix_models": matrix_models(),
        "factor_parameter_cases": cases,
        "excluded_numerical_parameters": exclusions,
        "graph_exclusion": graph_certificate(cases),
        "jacobian": jacobian_evidence(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--prepare-jacobian", action="store_true")
    mode.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    if args.prepare_jacobian:
        full, reduced = jacobian_matrices()
        require(json.loads((HERE / "jacobian_payload.json").read_text()) == payload(full),
                "Original adapter input was changed")
        target = HERE / "jacobian_reduced_payload.json"
        target.write_text(json.dumps(payload(reduced), indent=2) + "\n")
        print("Prepared exact row-equivalent Jacobian payload: 15 rows, 16 columns.")
        return 0
    result = compute()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    saved = json.loads(target.read_text())
    require(saved == result, "Stored certificate differs from independent recomputation")
    print(json.dumps({
        "result": "PASS",
        "root_systems": len(result["root_systems"]["systems"]),
        "small_minuscule_entries_including_B2_C2_alias": len(result["root_systems"]["small_modules"]),
        "factor_templates": len(result["factor_parameter_cases"]),
        "dimension_bounded_multisets": result["graph_exclusion"]["parameter_multisets"],
        "proper_partitions_surviving": result["graph_exclusion"]["proper_partitions_surviving"],
        "certificate": str(target.relative_to(HERE.parent.parent)),
        "independent_review": "pending",
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
