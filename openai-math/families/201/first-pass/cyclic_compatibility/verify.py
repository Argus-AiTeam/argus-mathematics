#!/usr/bin/env python3
"""Replay exact diagnostics and check the recorded universal Lean core."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def equal(actual, expected, message):
    difference = actual - expected
    if isinstance(difference, sp.MatrixBase):
        require(all(sp.cancel(x) == 0 for x in difference), message)
    else:
        require(sp.cancel(difference) == 0, message)


def rational_rref(matrix):
    rows = [
        [Fraction(int(x.p), int(x.q)) for x in map(sp.Rational, row)]
        for row in matrix.tolist()
    ]
    pivots = []
    for column in range(matrix.cols):
        pivot = next(
            (r for r in range(len(pivots), matrix.rows) if rows[r][column]),
            None,
        )
        if pivot is None:
            continue
        lead = len(pivots)
        rows[lead], rows[pivot] = rows[pivot], rows[lead]
        divisor = rows[lead][column]
        rows[lead] = [x / divisor for x in rows[lead]]
        for r in range(matrix.rows):
            if r != lead and rows[r][column]:
                factor = rows[r][column]
                rows[r] = [x - factor * y for x, y in zip(rows[r], rows[lead])]
        pivots.append(column)
        if len(pivots) == matrix.rows:
            break
    return rows, pivots


def rank(matrix):
    return len(rational_rref(matrix)[1])


def unit(n, row, column):
    result = sp.zeros(n)
    result[row, column] = 1
    return result


def unimodular(n, seed):
    lower, upper = sp.eye(n), sp.eye(n)
    for r in range(n):
        for c in range(r):
            lower[r, c] = (seed + r + 2 * c) % 3 - 1
            upper[c, r] = (seed + 2 * r + c + 1) % 3 - 1
    return lower * upper


def projectors(n, seed, diagonal=False):
    change = sp.eye(n) if diagonal else unimodular(n, seed)
    inverse = change.inv()
    result = [change * unit(n, j, j) * inverse for j in range(n)]
    equal(sum(result, sp.zeros(n)), sp.eye(n), "incomplete projectors")
    for j, left in enumerate(result):
        equal(sp.trace(left), 1, "projector does not have trace one")
        for k, right in enumerate(result):
            equal(left * right, left if j == k else sp.zeros(n), "nonorthogonal projectors")
    return result


def abstract_model(m, length, a, g, diagonal=False, common=True):
    q = a - g
    require(q >= 0 and m >= 1 and length >= 1, "invalid abstract model")
    hub_count = length + int(common)
    row_count = (m * length + hub_count) * a
    changes = [unimodular(a, v + 3) for v in range(m + hub_count)]
    loops = [change[:, :q] for change in changes]
    duals = [change.inv().T[:, q:] for change in changes]
    projections = {
        (i, h): projectors(length, 17 * i + 11 * h + length, diagonal)
        for i in range(m) for h in range(a)
    }

    def leaf(i, h, j):
        return (i * a + h) * length + j

    def hub(p, h):
        return m * a * length + p * a + h

    columns = []
    for i in range(m):
        for k, r, s in itertools.product(range(q), range(length), range(length)):
            column = sp.zeros(row_count, 1)
            for h, j in itertools.product(range(a), range(length)):
                column[leaf(i, h, j)] = loops[i][h, k] * projections[i, h][j][s, r]
            columns.append(column)
    for p, k in itertools.product(range(hub_count), range(q)):
        column = sp.zeros(row_count, 1)
        for h in range(a):
            column[hub(p, h)] = loops[m + p][h, k]
        columns.append(column)
    for i, p in itertools.product(range(m), range(hub_count)):
        arrow_change = unimodular(g, i + 5 * p + 1)
        left = changes[i][:, q:] * arrow_change
        right = -changes[m + p][:, q:] * arrow_change
        equal(duals[i].T * left + duals[m + p].T * right, sp.zeros(g), "pair incompatibility")
        require(rank(duals[i].T * left) == g, "pair endpoint is not onto")
        for r, k in itertools.product(range(length), range(g)):
            column = sp.zeros(row_count, 1)
            for h, j in itertools.product(range(a), range(length)):
                projection = projections[i, h][j]
                factor = (
                    sum(projection[r, s] for s in range(length))
                    if p == length else projection[r, p]
                )
                column[leaf(i, h, j)] = left[h, k] * factor
            if p == length or p == r:
                for h in range(a):
                    column[hub(p, h)] = right[h, k]
            columns.append(column)
    matrix = sp.Matrix.hstack(*columns) if columns else sp.zeros(row_count, 0)
    lift = sp.zeros(row_count, g)
    for i, h, j, k in itertools.product(range(m), range(a), range(length), range(g)):
        lift[leaf(i, h, j), k] = duals[i][h, k]
    for p, h, k in itertools.product(range(hub_count), range(a), range(g)):
        lift[hub(p, h), k] = duals[m + p][h, k]
    return matrix, lift, projections


def abstract_checks():
    parameters = [
        (1, 1, 1, 0), (2, 3, 2, 0), (1, 1, 1, 1),
        (1, 2, 2, 1), (2, 3, 2, 1), (1, 2, 2, 2),
        (2, 2, 3, 2), (1, 3, 4, 2), (2, 4, 2, 1),
    ]
    results = []
    noncommuting = False
    for m, length, a, g in parameters:
        matrix, lift, projections = abstract_model(m, length, a, g)
        equal(matrix.T * lift, sp.zeros(matrix.cols, g), "compatible lift failed")
        require(rank(lift) == g, "lift is not injective")
        base_rank = rank(matrix)
        require(base_rank == matrix.rows - g, "hub nullspace dimension mismatch")
        added = sp.Matrix(
            matrix.rows, g + 1,
            lambda r, c: ((r + 1) * (c + 2) + 3 * c) % 7 - 3,
        )
        obstruction_rank = rank(added.T * lift)
        augmented_rank = rank(matrix.row_join(added))
        require(
            augmented_rank == matrix.rows - g + obstruction_rank,
            "arbitrary-column rank formula failed",
        )
        if a >= 2 and length >= 2:
            left, right = projections[0, 0][0], projections[0, 1][0]
            noncommuting |= left * right != right * left
        results.append({
            "m": m, "L": length, "a": a, "g": g,
            "rows": matrix.rows, "columns": matrix.cols,
            "rank": base_rank, "nullity": matrix.rows - base_rank,
            "added_columns": added.cols, "obstruction_rank": obstruction_rank,
            "augmented_rank": augmented_rank,
        })
    require(noncommuting, "diagnostics never tested different label eigenbases")
    return {"cases": results, "noncommuting_label_projectors_tested": noncommuting}


def canonical_rational(item):
    value = Fraction(int(item["num"]), int(item["den"]))
    require(str(value.numerator) == item["num"], "noncanonical numerator")
    require(str(value.denominator) == item["den"], "noncanonical denominator")
    return sp.Rational(value.numerator, value.denominator)


def jacobian_check():
    payload = json.loads((HERE / "jacobian.payload.json").read_text())
    envelope = json.loads((HERE / "jacobian.output.json").read_text())
    status = json.loads((HERE / "jacobian.run_status.json").read_text())
    require(status["adapter_exit_status"] == 0, "the archived adapter run failed")
    require(status["transport_status"] == "completed", "the adapter transport did not complete")
    require(status["timeout"] is False and status["structured_error"] is None, "the adapter result is inconclusive")
    require(envelope["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(envelope["server"]["version"] == "0.14.0", "unexpected Jacobian version")
    require(envelope["protocol_version"] == "2025-11-25", "unexpected protocol")
    result = envelope["result"]
    require(result["operation_id"] == "matrix.nullspace.compute", "wrong operation")
    require("output" in result and "error" not in result, "Jacobian did not return a result")
    output = result["output"]
    matrix = sp.Matrix([
        [canonical_rational(x) for x in row]
        for row in payload["matrix"]["entries"]
    ])
    reduced, pivots = rational_rref(matrix)
    free = [c for c in range(matrix.cols) if c not in pivots]
    basis = []
    for c in free:
        vector = [Fraction(0) for _ in range(matrix.cols)]
        vector[c] = Fraction(1)
        for r, pivot in enumerate(pivots):
            vector[pivot] = -reduced[r][c]
        basis.append(vector)
    returned = [
        [Fraction(canonical_rational(x)) for x in row]
        for row in output["basis_vectors"]
    ]
    require(output["matrix"] == payload["matrix"], "Jacobian returned a different matrix")
    require(output["rank"] == len(pivots), "independent Fraction rank mismatch")
    require(output["nullity"] == len(free), "Jacobian nullity mismatch")
    require(output["free_columns"] == free and returned == basis, "Jacobian basis mismatch")
    require(output["convention"] == "RREF_FUNDAMENTAL_BASIS", "wrong basis convention")
    return {
        "operation_id": result["operation_id"],
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_exit_status": status["adapter_exit_status"],
        "structured_error": status["structured_error"], "timeout": status["timeout"],
        "rows": matrix.rows, "columns": matrix.cols,
        "rank": len(pivots), "nullity": len(free),
        "basis": [[str(x) for x in row] for row in basis],
        "replay_arithmetic": "Python fractions.Fraction RREF, not the Jacobian implementation",
    }


def point(value):
    return unit(2, 0, 1), value * unit(2, 1, 0)


def commutator(pair):
    return pair[0] * pair[1] - pair[1] * pair[0]


def derivative(pair, direction):
    return (
        direction[0] * pair[1] + pair[0] * direction[1]
        - direction[1] * pair[0] - pair[1] * direction[0]
    )


def paired(left, right, forward, reverse, projection, root, inverse=None):
    p1, p2 = left
    q1, q2 = right
    u1, u2 = forward
    v1, v2 = reverse
    out = p1 * u2 + u1 * q2 - p2 * u1 - u2 * q1
    back = v1 * p2 + q1 * v2 - v2 * p1 - q2 * v1
    if inverse is None:
        inverse = (commutator(right) - root * sp.eye(q1.rows)).inv()
    return sp.cancel(sp.trace(projection * (u1 * v2 - u2 * v1 - out * inverse * back)))


def input_basis():
    result = []
    for c, r, s in itertools.product(range(2), range(2), range(2)):
        pair = [sp.zeros(2), sp.zeros(2)]
        pair[c] = unit(2, r, s)
        result.append(tuple(pair))
    return result


def response_data(value, partner_value, arrow):
    left, right = point(value), point(partner_value)
    leaf_columns, hub_columns = [], []
    for reverse in input_basis():
        leaf_columns.append(sp.Matrix([
            paired(left, right, arrow, reverse, unit(2, h, h), (-1) ** h * value)
            for h in range(2)
        ]))
        hub_columns.append(sp.Matrix([
            paired(right, left, reverse, arrow, unit(2, h, h), (-1) ** h * partner_value)
            for h in range(2)
        ]))
    leaf = sp.Matrix.hstack(*leaf_columns)
    hub = sp.Matrix.hstack(*hub_columns)
    quotient = sp.ones(1, 2)
    equal(quotient * (leaf + hub), sp.zeros(1, 8), "commutator pair trace did not cancel")
    require(rank(quotient * leaf) == 1, "commutator pair quotient is not onto")
    return leaf, hub


def loop_data(value):
    result = sp.Matrix.hstack(*[
        sp.Matrix([sp.trace(unit(2, h, h) * derivative(point(value), direction)) for h in range(2)])
        for direction in input_basis()
    ])
    require(rank(result) == 1, "commutator loop rank is not one")
    equal(sp.ones(1, 2) * result, sp.zeros(1, 8), "loop trace did not cancel")
    return result


def commutator_hub_check():
    length, row_count = 2, 10
    change = sp.Matrix([[1, 2], [3, 7]])
    projections = [change * unit(2, j, j) * change.inv() for j in range(2)]
    values = [5, 7, 11]
    arrows = [
        (sp.Matrix([[1 + p, 2], [3, 5]]), sp.Matrix([[2, p], [1, 4 + p]]))
        for p in range(3)
    ]
    columns = []
    loops = loop_data(3)
    for k, r, s in itertools.product(range(8), range(length), range(length)):
        column = sp.zeros(row_count, 1)
        for h, j in itertools.product(range(2), range(length)):
            column[h * length + j] = loops[h, k] * projections[j][s, r]
        columns.append(column)
    for p in range(3):
        hub_loops = loop_data(values[p])
        for k in range(8):
            column = sp.zeros(row_count, 1)
            column[4 + 2 * p:6 + 2 * p, 0] = hub_loops[:, k]
            columns.append(column)
        leaf, hub = response_data(3, values[p], arrows[p])
        for r, k in itertools.product(range(length), range(8)):
            column = sp.zeros(row_count, 1)
            for h, j in itertools.product(range(2), range(length)):
                factor = sum(projections[j][r, s] for s in range(length)) if p == 2 else projections[j][r, p]
                column[h * length + j] = leaf[h, k] * factor
            if p == 2 or p == r:
                column[4 + 2 * p:6 + 2 * p, 0] = hub[:, k]
            columns.append(column)
    matrix = sp.Matrix.hstack(*columns)
    equal(matrix.T * sp.ones(row_count, 1), sp.zeros(matrix.cols, 1), "actual response relation failed")
    require(rank(matrix) == row_count - 1, "actual response nullspace is not one-dimensional")
    curve = sp.Matrix([-2, 4, 2, -4] + [0] * 6)
    require(rank(matrix.row_join(curve)) == row_count - 1, "actual compatible curve lost the relation")
    return {
        "polynomial": "z1*z2-z2*z1", "m": 1, "b": 2, "L": 2,
        "a": 2, "g": 1, "ell": 2,
        "old_roots": [3, -3], "hub_roots": [[v, -v] for v in values],
        "rows": row_count, "columns": matrix.cols, "rank": row_count - 1,
        "nullity_including_curve": 1, "curve": list(map(int, curve)),
        "scope": "Exact non-generic polynomial model, not a counterexample to a generic-point statement.",
    }


def at_zero(expression, variable):
    if isinstance(expression, sp.MatrixBase):
        return expression.applyfunc(lambda x: sp.limit(sp.cancel(x), variable, 0))
    return sp.limit(sp.cancel(expression), variable, 0)


def embed_arrow(pair, position, forward, common=False):
    result = []
    for matrix in pair:
        embedded = sp.zeros(4, 2) if forward else sp.zeros(2, 4)
        for r, c, p in itertools.product(range(2), range(2), range(2)):
            if common or p == position:
                if forward:
                    embedded[2 * r + p, c] = matrix[r, c]
                else:
                    embedded[r, 2 * c + p] = matrix[r, c]
        result.append(embedded)
    return tuple(result)


def specialization_checks():
    delta = sp.Symbol("delta")
    change = sp.Matrix([[1, 2], [3, 7]])
    projections = [change * unit(2, j, j) * change.inv() for j in range(2)]
    slopes = [-1, 2]
    slope_matrix = change * sp.diag(*slopes) * change.inv()
    conjugation = (sp.eye(4) + delta * unit(4, 0, 2)) * (sp.eye(4) + delta * unit(4, 2, 0))
    inverse = conjugation.inv()
    require(conjugation.det() == 1, "singular test conjugation")
    schur_results = []
    compression_warning = False
    for ell in (1, 2, 3):
        unshifted = (
            sp.kronecker_product(unit(2, 0, 1), sp.eye(2)),
            sp.kronecker_product(unit(2, 1, 0), 3 * sp.eye(2) + delta ** ell * slope_matrix),
        )
        leaf = tuple(conjugation * matrix * inverse for matrix in unshifted)
        output = commutator(leaf)
        for h in range(2):
            root = (-1) ** h * 3
            selected = list(range(2 * h, 2 * h + 2))
            complementary = [r for r in range(4) if r not in selected]
            shifted = output - root * sp.eye(4)
            m11 = shifted.extract(selected, selected)
            m12 = shifted.extract(selected, complementary)
            m21 = shifted.extract(complementary, selected)
            m22 = shifted.extract(complementary, complementary)
            schur = m11 - m12 * m22.inv() * m21
            equal(at_zero(schur / delta ** ell, delta), (-1) ** h * slope_matrix, "Schur leading coefficient changed")
            for degree in range(ell):
                equal(
                    schur.applyfunc(lambda x: sp.diff(sp.cancel(x), delta, degree).subs(delta, 0)),
                    sp.zeros(2), "lower Schur coefficient did not vanish",
                )
            if ell == 3:
                compression_warning |= m11.applyfunc(
                    lambda x: sp.diff(x, delta, 2).subs(delta, 0)
                ) != sp.zeros(2)
            for j in range(2):
                projection = conjugation * sp.kronecker_product(unit(2, h, h), projections[j]) * inverse
                branch = (-1) ** h * (3 + delta ** ell * slopes[j])
                equal(output * projection, branch * projection, "branch/projector eigen-equation failed")
                equal(projection * projection, projection, "deformed projector not idempotent")
                equal(at_zero(projection, delta), sp.kronecker_product(unit(2, h, h), projections[j]), "wrong projector limit")
                require(all(sp.denom(sp.cancel(x)).subs(delta, 0) != 0 for x in projection), "projector has a pole")
                equal(
                    at_zero(delta ** (1 - ell) * sp.diff(branch, delta), delta),
                    ell * (-1) ** h * slopes[j], "scaled curve limit is wrong",
                )
        schur_results.append({"ell": ell, "all_root_clusters": 2, "scalar_branches": 4, "projectors_integral": True})
    require(compression_warning, "Schur/compression negative control was not exercised")

    ell = 2
    leaf = tuple(conjugation * matrix * inverse for matrix in (
        sp.kronecker_product(unit(2, 0, 1), sp.eye(2)),
        sp.kronecker_product(unit(2, 1, 0), 3 * sp.eye(2) + delta ** ell * slope_matrix),
    ))
    partner = point(7)
    arrow = (sp.Matrix([[2, 1], [3, 5]]), sp.Matrix([[1, 4], [2, 3]]))
    reverse = (sp.Matrix([[3, 2], [1, 4]]), sp.Matrix([[2, 5], [3, 1]]))
    tests = [(False, 0, 0), (False, 0, 1), (False, 1, 0), (True, 0, 0), (True, 0, 1)]
    limit_count = 0
    for common, p, r in tests:
        forward = embed_arrow(arrow, p, True, common)
        back = embed_arrow(reverse, r, False)
        repeat = sum((unit(2, s, r) for s in range(2)), sp.zeros(2)) if common else unit(2, p, r)
        for h, j in itertools.product(range(2), range(2)):
            branch = (-1) ** h * (3 + delta ** ell * slopes[j])
            projection = conjugation * sp.kronecker_product(unit(2, h, h), projections[j]) * inverse
            actual = paired(leaf, partner, forward, back, projection, branch)
            expected = paired(point(3), partner, arrow, reverse, unit(2, h, h), (-1) ** h * 3) * sp.trace(projections[j] * repeat)
            equal(at_zero(actual, delta), expected, "leaf paired-column limit failed")
            limit_count += 1
        for h in range(2):
            actual = paired(partner, leaf, back, forward, unit(2, h, h), (-1) ** h * 7)
            expected = paired(partner, point(3), reverse, arrow, unit(2, h, h), (-1) ** h * 7)
            equal(at_zero(actual, delta), expected if common or p == r else 0, "hub delta/multiplicity factor failed")
            limit_count += 1
    for h, j in itertools.product(range(2), range(2)):
        projection = conjugation * sp.kronecker_product(unit(2, h, h), projections[j]) * inverse
        direction = tuple(sp.kronecker_product(matrix, sp.Matrix([[1, 3], [2, 4]])) for matrix in reverse)
        actual = sp.trace(projection * derivative(leaf, direction))
        expected = sp.trace(unit(2, h, h) * derivative(point(3), reverse)) * sp.trace(projections[j] * sp.Matrix([[1, 3], [2, 4]]))
        equal(at_zero(actual, delta), expected, "loop-column limit failed")
    normalized = []
    for multiplicity in (1, 2, 3):
        tensor_trace = sp.trace(sp.kronecker_product(sp.eye(multiplicity), slope_matrix))
        equal(tensor_trace / multiplicity, sp.trace(slope_matrix), "trace/t normalization failed")
        normalized.append(multiplicity)
    require(projections[0][1, 0] != projections[0][0, 1], "transpose control is symmetric")
    equal(sp.trace(projections[0] * unit(2, 0, 1)), projections[0][1, 0], "E_pr trace orientation failed")
    return {
        "schur_and_projector_cases": schur_results,
        "paired_limit_equalities": limit_count,
        "loop_limit_equalities": 4,
        "trace_normalizations_t": normalized,
        "nonsymmetric_projector": [list(map(int, row)) for row in projections[0].tolist()],
        "transpose_control_values": [int(projections[0][1, 0]), int(projections[0][0, 1])],
        "compression_is_not_schur_detected": compression_warning,
        "scope": "Exact rational-function diagnostics; the report supplies the arbitrary-order proof.",
    }


def cycle_checks():
    comparisons = 0
    cycles = 0
    periodic = 0
    for length in range(1, 8):
        words = list(itertools.product(range(2), repeat=length))
        for labels in words:
            matrices = [sp.zeros(length), sp.zeros(length)]
            for j, color in enumerate(labels):
                matrices[color][j, (j + 1) % length] = 1
            orbit = {labels[r:] + labels[:r] for r in range(length)}
            stabilizer = length // len(orbit)
            periodic += int(stabilizer > 1)
            for word in words:
                product = sp.eye(length)
                for color in word:
                    product = product * matrices[color]
                expected = stabilizer if word in orbit else 0
                equal(sp.trace(product), expected, "directed-cycle trace or distinct-rotation convention failed")
                comparisons += 1
            cycles += 1
    return {
        "maximum_exhaustive_length": 7, "labeled_cycles": cycles,
        "word_trace_comparisons": comparisons,
        "cycles_with_nontrivial_stabilizer": periodic,
        "periodic_example": {"word": "1212", "distinct_rotations": 2, "trace_per_rotation": 2},
        "scope": "Finite diagnostics only; the counting proof covers every length.",
    }


def negative_controls():
    without, _, _ = abstract_model(1, 2, 1, 1, diagonal=True, common=False)
    with_common, _, _ = abstract_model(1, 2, 1, 1, diagonal=True)
    require(without.rows - rank(without) == 2, "common-hub ablation did not retain two relations")
    require(with_common.rows - rank(with_common) == 1, "common hub failed to identify positions")
    payload = json.loads((HERE / "jacobian.payload.json").read_text())
    transpose = sp.Matrix([[canonical_rational(x) for x in row] for row in payload["matrix"]["entries"]])
    matrix, good = transpose[:6, :].T, transpose[6:7, :].T
    bad = sp.Matrix([0, 2, 0, 0, 0])
    require(rank(matrix) == rank(matrix.row_join(good)) == 4, "compatible-curve control failed")
    require(rank(matrix.row_join(bad)) == 5, "incompatible curve should violate the augmented rank bound")
    first, second = sp.Matrix([1, 0]), sp.Matrix([0, 1])
    require(rank(first) == rank(second) == 1 and rank(first.row_join(second)) == 2, "separate-rank control failed")
    return {
        "omit_common_hub": {"L": 2, "expected_g": 1, "actual_nullity": 2},
        "include_common_hub": {"nullity": 1},
        "omit_augmented_rank_hypothesis": {"base_rank": 4, "compatible_rank": 4, "incompatible_rank": 5},
        "separate_rank_bounds": {"each_rank": 1, "collective_span_rank": 2},
        "interpretation": "These refute weakened hypotheses, not the manuscript's stated theorem.",
    }


def lean_record_check():
    result = json.loads((HERE / "lean_check.json").read_text())
    require(result["status"] == "success", "the universal Lean core has not compiled successfully")
    require(result["exit_code"] == 0 and result["proof_holes"] == [], "Lean did not establish a hole-free proof")
    require(result["audit_exit_code"] == 0, "the Lean axiom audit did not pass")
    source = HERE / "Main.lean"
    fidelity = HERE / "statement_fidelity.md"
    require(
        result["source_sha256"] == hashlib.sha256(source.read_bytes()).hexdigest(),
        "Lean result is stale for the source",
    )
    require(
        result["statement_fidelity_sha256"] == hashlib.sha256(fidelity.read_text().encode()).hexdigest(),
        "Lean result is stale for the fidelity statement",
    )
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (item for item in ledger["claims"] if item["claim_id"] == "CC-FORMAL-HUB9000201"),
        key=lambda item: item["version"],
    )
    records = [
        item for item in ledger["evidence"]
        if item.get("subject", {}).get("subject_id") == "CC-FORMAL-HUB9000201"
        and item.get("subject", {}).get("content_hash") == claim["content_hash"]
        and item.get("tier") == "mechanical" and item.get("verdict") == "supports"
    ]
    require(records, "real compiler success has not been recorded against the formal claim")
    record = records[-1]
    archive_path = (ROOT / record["artifact"]).resolve()
    require(archive_path.is_relative_to(HERE), "compiler archive is outside this mission's evidence")
    archive = json.loads(archive_path.read_text())
    require(archive["evidence_id"] == record["evidence_id"], "compiler evidence identity mismatch")
    require(archive["subject"] == record["subject"], "compiler claim version mismatch")
    require(archive["lean_check"] == result, "live compiler result and claim archive differ")
    require(archive["lean_source"]["text"] == source.read_text(), "archived Lean source is stale")
    require(archive["statement_fidelity"]["text"] == fidelity.read_text(), "archived fidelity statement is stale")
    return {
        "source": "Main.lean", "fidelity": "statement_fidelity.md",
        "status": "success",
        "claim": "CC-FORMAL-HUB9000201",
        "recorded_artifact": record["artifact"],
        "proof_holes": [], "axiom_audit_exit_status": 0,
        "scope": "Universal abstract hub core only; this replay checks freshness, not a new compiler invocation.",
    }


def compute():
    return {
        "schema_version": 1,
        "mathematical_result": "Universal hub-rigidity rank reduction and conditional cyclic-compatibility proof",
        "proof_report": "report.md",
        "classification": {
            "universal_formal_core": "CC-FORMAL-HUB9000201",
            "remaining_universal_argument": "Prose proof in report.md",
            "executable_diagnostics": "Finite exact arithmetic and rational-function identities, not arbitrary-size exhaustion",
            "manuscript_refutation": False,
            "main_theorem_verified": False,
            "campaign_complete": False,
            "independent_review": "pending",
            "novelty_status": "not_assessed",
            "significance_status": "not_assessed",
        },
        "upstream_assumptions": ["A-ADMISS", "A-SPECTRAL", "A-RESPONSE", "A-TRANSFER", "A-GLOBAL"],
        "jacobian": jacobian_check(),
        "abstract_hub_models": abstract_checks(),
        "actual_commutator_responses": commutator_hub_check(),
        "singular_specialization": specialization_checks(),
        "directed_cycles": cycle_checks(),
        "negative_controls": negative_controls(),
        "formal_core": lean_record_check(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = compute()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    require(target.exists(), "missing exact_certificate.json")
    require(json.loads(target.read_text()) == result, "certificate does not match the exact replay")
    print(json.dumps({
        "status": "passed",
        "abstract_models": len(result["abstract_hub_models"]["cases"]),
        "actual_response_rank": result["actual_commutator_responses"]["rank"],
        "paired_limits": result["singular_specialization"]["paired_limit_equalities"],
        "cycle_comparisons": result["directed_cycles"]["word_trace_comparisons"],
        "universal_lean_core": result["formal_core"]["status"],
        "independent_review": "pending", "campaign_complete": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
