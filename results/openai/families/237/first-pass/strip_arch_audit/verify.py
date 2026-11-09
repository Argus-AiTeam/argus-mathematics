#!/usr/bin/env python3
"""Exact zero-loop diagram reconstruction; requires SymPy."""

import argparse
import hashlib
import itertools
import json
from functools import lru_cache
from fractions import Fraction
from pathlib import Path

import sympy as sp
from sympy.polys.rings import ring
from sympy.polys.fields import field


K = sp.QQ.algebraic_field(sp.sqrt(2 + sp.sqrt(2)) / 2)
ZERO, ONE = K.zero, K.one
C = K.from_sympy(sp.sqrt(2 + sp.sqrt(2)) / 2)
RHO = ONE / (2 * C)
c = C - RHO
d = 2 * C**2 - ONE
ETA = 2 * d - ONE
VACANT, DEFECT = -1, -2


def exact(value):
    coefficients = list(reversed(value.to_list()))
    return [str(x) for x in coefficients] or ["0"]


def encoded_matrix(matrix):
    return [[exact(x) for x in row] for row in matrix]


def zeros(rows, columns):
    return [[ZERO for _ in range(columns)] for _ in range(rows)]


def matvec(matrix, vector):
    return [sum((x * y for x, y in zip(row, vector)), ZERO) for row in matrix]


def sign(value):
    if not value:
        return 0
    coefficients = [Fraction(str(x)) for x in value.to_list()]
    lower, upper = Fraction(9, 10), Fraction(1)
    for _ in range(128):
        lo = hi = Fraction(0)
        for coefficient in coefficients:
            products = (lo*lower, lo*upper, hi*lower, hi*upper)
            lo, hi = min(products) + coefficient, max(products) + coefficient
        if lo > 0:
            return 1
        if hi < 0:
            return -1
        middle = (lower + upper) / 2
        polynomial = 8*middle**4 - 8*middle**2 + 1
        if polynomial < 0:
            lower = middle
        else:
            upper = middle
    raise ArithmeticError("exact real-root isolation did not decide a sign")


def solve(matrix, vector):
    """Return a checked exact solution and a nonzero determinant."""
    n = len(matrix)
    if not n:
        return [], ONE
    work = [row[:] + [value] for row, value in zip(matrix, vector)]
    determinant = ONE
    for column in range(n):
        pivot = next((i for i in range(column, n) if work[i][column]), None)
        if pivot is None:
            raise ArithmeticError("singular evaluated resolvent")
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            determinant = -determinant
        scale = work[column][column]
        determinant *= scale
        work[column] = [x / scale for x in work[column]]
        for i in range(n):
            if i != column and work[i][column]:
                factor = work[i][column]
                work[i] = [x - factor * y for x, y in zip(work[i], work[column])]
    answer = [row[-1] for row in work]
    assert matvec(matrix, answer) == vector
    assert determinant
    return answer, determinant


@lru_cache(None)
def vacuum_states(n):
    def pairings(indices):
        if not indices:
            yield {}
            return
        first, *rest = indices
        for tail in pairings(rest):
            yield {first: VACANT, **tail}
        for j, partner in enumerate(rest):
            for inside in pairings(rest[:j]):
                for outside in pairings(rest[j + 1 :]):
                    yield {first: partner, partner: first, **inside, **outside}

    states = [tuple(p[i] for i in range(n)) for p in pairings(list(range(n)))]
    return tuple(sorted(states, key=lambda s: (sum(x != VACANT for x in s), s)))


@lru_cache(None)
def source_states(n):
    states = []
    for state in vacuum_states(n):
        for i, value in enumerate(state):
            if value == VACANT and not any(j < i < k for j, k in enumerate(state)):
                new = list(state)
                new[i] = DEFECT
                states.append(tuple(new))
    return tuple(sorted(states, key=lambda s: (sum(x != VACANT for x in s), s)))


def components(edges):
    adjacency = {}
    for a, b in edges:
        adjacency.setdefault(a, []).append(b)
        adjacency.setdefault(b, []).append(a)
    result = []
    unseen = set(adjacency)
    while unseen:
        todo = [next(iter(unseen))]
        component = set()
        while todo:
            vertex = todo.pop()
            if vertex in component:
                continue
            component.add(vertex)
            unseen.discard(vertex)
            todo.extend(adjacency[vertex])
        result.append(component)
    return result


def input_edges(state, source):
    edges = [(i, j) for i, j in enumerate(state) if j > i]
    edges.extend((i, source) for i, j in enumerate(state) if j == DEFECT)
    return edges


def output_state(edges, outputs, source=None):
    result = [VACANT] * len(outputs)
    external = set(outputs)
    if source is not None:
        external.add(source)
    positions = {value: i for i, value in enumerate(outputs)}
    for component in components(edges):
        ends = component & external
        if not ends:
            return None
        if len(ends) != 2:
            raise ArithmeticError(f"invalid boundary component: {ends}")
        a, b = tuple(ends)
        if source in ends:
            other = b if a == source else a
            result[positions[other]] = DEFECT
        else:
            i, j = positions[a], positions[b]
            result[i], result[j] = j, i
    return tuple(result)


@lru_cache(None)
def sin_multiple(j):
    j %= 16
    previous, current = ZERO, c
    if j == 0:
        return previous
    for _ in range(1, j):
        previous, current = current, 2 * C * current - previous
    return current


@lru_cache(None)
def weights(j):
    denominator = sin_multiple(j + 2) * sin_multiple(j + 3)
    if not denominator:
        raise ArithmeticError("genuine local weight pole")
    return {
        "1": ONE,
        "A": d * sin_multiple(3 - j) / denominator,
        "U": d * sin_multiple(j) / denominator,
        "B": sin_multiple(j) * sin_multiple(3 - j) / denominator,
        "E": sin_multiple(3 - j) * sin_multiple(2 - j) / denominator,
        "F": sin_multiple(j - 1) * sin_multiple(j) / denominator,
    }


# Ports are south, west, east, north; these are geometric rhombus weights.
LOCAL = (
    ("1", ()),
    ("U", ((0, 2),)),
    ("U", ((1, 3),)),
    ("B", ((0, 3),)),
    ("B", ((1, 2),)),
    ("A", ((0, 1),)),
    ("A", ((2, 3),)),
    ("F", ((0, 2), (1, 3))),
    ("E", ((0, 1), (2, 3))),
)


@lru_cache(None)
def column(row_list, sector, insertion=False):
    n = len(row_list)
    inputs = source_states(n) if sector else vacuum_states(n)
    outputs = source_states(n) if sector or insertion else vacuum_states(n)
    output_indices = {state: i for i, state in enumerate(outputs)}
    matrix = zeros(len(outputs), len(inputs))
    source = 3 * n + 1
    for column_index, state in enumerate(inputs):
        initial = input_edges(state, source)
        if insertion:
            initial.append((2 * n, source))

        def append_row(i, south_occupied, edges, value):
            if i == n:
                if south_occupied:
                    return
                output = output_state(
                    edges, list(range(n, 2 * n)), source if sector or insertion else None
                )
                if output is not None:
                    if output not in output_indices:
                        raise ArithmeticError(f"nonplanar source state: {output}")
                    matrix[output_indices[output]][column_index] += value
                return
            west_occupied = state[i] != VACANT
            ports = (2 * n + i, i, n + i, 2 * n + i + 1)
            for name, local_edges in LOCAL:
                weight = weights(row_list[i])[name]
                if not weight:
                    continue
                occupied = {p for edge in local_edges for p in edge}
                if (0 in occupied) != south_occupied or (1 in occupied) != west_occupied:
                    continue
                append_row(
                    i + 1,
                    3 in occupied,
                    edges + [(ports[a], ports[b]) for a, b in local_edges],
                    value * weight,
                )

        append_row(0, insertion, initial, ONE)
    return matrix


def stationary_and_source(row_list):
    n = len(row_list)
    transfer = column(row_list, 0)
    source_transfer = column(row_list, 1)
    insertion = column(row_list, 0, True)
    nv, ns = len(transfer), len(source_transfer)
    assert transfer[0] == [ONE] + [ZERO] * (nv - 1)
    vacuum_resolvent = [
        [(ONE if i == j else ZERO) - transfer[i + 1][j + 1] for j in range(nv - 1)]
        for i in range(nv - 1)
    ]
    tail, vacuum_determinant = solve(vacuum_resolvent, [transfer[i][0] for i in range(1, nv)])
    vacuum = [ONE] + tail
    assert matvec(transfer, vacuum) == vacuum
    source_resolvent = [
        [(ONE if i == j else ZERO) - source_transfer[i][j] for j in range(ns)]
        for i in range(ns)
    ]
    integrated, source_determinant = solve(source_resolvent, matvec(insertion, vacuum))
    vacuum_contraction, _ = solve(vacuum_resolvent, [ONE] * (nv - 1))
    source_contraction, _ = solve(source_resolvent, [ONE] * ns)
    assert all(sign(x) > 0 for x in vacuum_contraction + source_contraction)
    assert all(sign(x) >= 0 for matrix in (transfer, source_transfer, insertion)
               for row in matrix for x in row)
    return {
        "T0": transfer,
        "T1": source_transfer,
        "b": insertion,
        "P": vacuum,
        "H": integrated,
        "det_vacuum": vacuum_determinant,
        "det_source": source_determinant,
        "contraction_vacuum": vacuum_contraction,
        "contraction_source": source_contraction,
    }


@lru_cache(None)
def gluing_matrix(n):
    states = source_states(n)
    matrix = zeros(len(states), len(states))
    for i, left in enumerate(states):
        for j, right in enumerate(states):
            if any((a == VACANT) != (b == VACANT) for a, b in zip(left, right)):
                continue
            edges = input_edges(left, n) + input_edges(right, n + 1)
            connected = components(edges)
            if len(connected) == 1 and {n, n + 1} <= connected[0]:
                matrix[i][j] = ONE
    return matrix


def pfaffian_terms(indices):
    if not indices:
        yield 1, ()
        return
    first = indices[0]
    for j in range(1, len(indices)):
        rest = indices[1:j] + indices[j + 1 :]
        for sign, pairs in pfaffian_terms(rest):
            yield (-1) ** (j + 1) * sign, ((first, indices[j]),) + pairs


@lru_cache(None)
def scalar_polynomial(n):
    if n == 0:
        return None
    polynomial_ring, *variables = ring(",".join(f"a{i}" for i in range(n)), K)
    pairs = tuple(itertools.combinations(range(n), 2))
    denominators = {
        (i, j): variables[i] ** 2 + variables[j] ** 2
        + 2 * d * variables[i] * variables[j] - d**2
        for i, j in pairs
    }
    numerator = polynomial_ring.zero
    indices = tuple(range(n + n % 2))
    for sign, matching in pfaffian_terms(indices):
        term = polynomial_ring(sign)
        selected = {(i, j) for i, j in matching if j < n}
        for i, j in pairs:
            if (i, j) in selected:
                term *= (variables[i] - variables[j]) * (variables[i] + variables[j] + RHO)
            else:
                term *= denominators[i, j]
        numerator += term
    vandermonde = polynomial_ring.one
    for i, j in pairs:
        vandermonde *= variables[i] - variables[j]
    quotient, remainder = divmod(numerator, vandermonde)
    assert not remainder, "Pfaffian numerator is not Vandermonde-divisible"
    return quotient


def scalar_value(arguments, last_power=None):
    n = len(arguments) + (last_power is not None)
    if n == 0:
        return ONE
    result = ZERO
    for exponents, coefficient in scalar_polynomial(n).terms():
        if last_power is not None and exponents[-1] != last_power:
            continue
        for argument, exponent in zip(arguments, exponents):
            coefficient *= argument**exponent
        result += coefficient
    return result


def cosine_argument(j):
    return sin_multiple(4 + 2 * j - 3)


def operator_sum(inputs, outputs, terms):
    result = {}
    for edges, coefficient in terms:
        key = tuple(sorted(tuple(sorted(edge)) for edge in edges))
        result[key] = result.get(key, 0) + coefficient
    return inputs, outputs, {key: value for key, value in result.items() if value}


def equal_operators(left, right):
    if left[:2] != right[:2]:
        return False
    return all(not (left[2].get(key, 0) - right[2].get(key, 0))
               for key in left[2].keys() | right[2].keys())


def identity_operator(n):
    return operator_sum(n, n, (
        (tuple((i, n + i) for i in range(n) if mask & (1 << i)), ONE)
        for mask in range(1 << n)
    ))


def r_operator(w):
    return operator_sum(2, 2, (
        ((), w["1"]),
        (((0, 2),), w["A"]), (((1, 3),), w["A"]),
        (((0, 3),), w["B"]), (((1, 2),), w["B"]),
        (((0, 1),), w["U"]), (((2, 3),), w["U"]),
        (((0, 2), (1, 3)), w["E"]),
        (((0, 1), (2, 3)), w["F"]),
    ))


def splitter(s):
    if s == 2:
        return operator_sum(1, 2, (
            ((), ONE), (((1, 2),), RHO),
            (((0, 1),), RHO), (((0, 2),), RHO),
        ))
    if s == 3:
        return operator_sum(0, 2, (((), ONE), (((0, 1),), ONE)))
    raise ValueError("splitter index must be 2 or 3")


def transpose(operator):
    m, n, terms = operator
    def move(i):
        return n + i if i < m else i - m
    return operator_sum(n, m, (
        (tuple((move(a), move(b)) for a, b in edges), coefficient)
        for edges, coefficient in terms.items()
    ))


def tensor(left, right):
    lm, ln, lt = left
    rm, rn, rt = right
    def move_left(i):
        return i if i < lm else i + rm
    def move_right(i):
        return lm + i if i < rm else lm + ln + i
    return operator_sum(lm + rm, ln + rn, (
        (tuple((move_left(a), move_left(b)) for a, b in le)
         + tuple((move_right(a), move_right(b)) for a, b in re), lv * rv)
        for le, lv in lt.items() for re, rv in rt.items()
    ))


def compose(left, right):
    middle, n, lt = left
    m, other_middle, rt = right
    assert middle == other_middle
    terms = []
    for le, lv in lt.items():
        left_occupied = {i for edge in le for i in edge if i < middle}
        for re, rv in rt.items():
            right_occupied = {i - m for edge in re for i in edge if i >= m}
            if left_occupied != right_occupied:
                continue
            joined = re + tuple((m + a, m + b) for a, b in le)
            external = set(range(m)) | set(range(m + middle, m + middle + n))
            edges = []
            loop = False
            for component in components(joined):
                ends = component & external
                if not ends:
                    loop = True
                    break
                assert len(ends) == 2
                ends = tuple(i if i < m else i - middle for i in ends)
                edges.append(ends)
            if not loop:
                terms.append((tuple(edges), lv * rv))
    return operator_sum(m, n, terms)


def symbolic_weights(sine, cosine):
    denominator = d * (cosine + sine) * (C * cosine + c * sine)
    opposite = C * cosine - c * sine
    return {
        "1": sine.parent().one,
        "A": d * opposite / denominator,
        "U": d * sine / denominator,
        "B": sine * opposite / denominator,
        "E": opposite * d * (cosine - sine) / denominator,
        "F": (C * sine - c * cosine) * sine / denominator,
    }


def verify_local_identities():
    rational_field, t = field("t", K)
    sx, cx = 2 * t / (1 + t**2), (1 - t**2) / (1 + t**2)
    def shifted(j, sign=1):
        sj, cj = sin_multiple(j), sin_multiple(j + 4)
        return symbolic_weights(sign * sx * cj + cx * sj, cx * cj - sign * sx * sj)

    identity = identity_operator(1)
    rx = r_operator(shifted(0))
    assert equal_operators(r_operator(weights(0)), identity_operator(2))
    unitary = compose(rx, r_operator(shifted(0, -1)))
    assert equal_operators(unitary, identity_operator(2)), "symbolic diagrammatic unitarity failed"
    counts = {"unitarity_nonzero_coefficients": len(unitary[2])}
    for s in (2, 3):
        split = splitter(s)
        factorized = compose(split, transpose(split))
        assert equal_operators(factorized, r_operator(weights(s))), f"factorization s={s} failed"
        left = compose(
            tensor(identity, rx),
            compose(tensor(r_operator(shifted(s)), identity), tensor(identity, split)),
        )
        effective = r_operator(shifted(1)) if s == 2 else identity
        right = compose(tensor(split, identity), effective)
        assert equal_operators(left, right), f"symbolic splitting s={s} failed"
        reflected_left = compose(
            tensor(transpose(split), identity),
            compose(tensor(identity, r_operator(shifted(s))), tensor(rx, identity)),
        )
        reflected_right = compose(effective, tensor(identity, transpose(split)))
        assert equal_operators(reflected_left, reflected_right), \
            f"symbolic reflected projection s={s} failed"
        counts[f"splitting_{s}_boundary_coefficients"] = len(left[2])
    return {
        "result": "exact_symbolic_identities",
        "field": "Q(C)(t), t=tan(x/2); C satisfies 8C^4-8C^2+1=0",
        "checked": ["R(0)=I", "R(x)R(-x)=I",
                    "R(2lambda)=S2 S2^t", "R(3lambda)=S3 S3^t",
                    "splitting s=2 for symbolic x", "splitting s=3 for symbolic x",
                    "reflected projection s=2 for symbolic x",
                    "reflected projection s=3 for symbolic x"],
        "method": "Full boundary-connectivity diagram composition with zero loop value, not a sector representation.",
        "counts": counts,
    }


def verify_scalar_identities():
    rational_field, t, v = field("t,v", K)
    sx, cx = 2 * t / (1 + t**2), (1 - t**2) / (1 + t**2)
    sy, cy = 2 * v / (1 + v**2), (1 - v**2) / (1 + v**2)
    def sine(sine_value, cosine_value, j):
        return sine_value * sin_multiple(j + 4) + cosine_value * sin_multiple(j)
    def cosine(sine_value, cosine_value, j):
        return cosine_value * sin_multiple(j + 4) - sine_value * sin_multiple(j)
    def a(sine_value, cosine_value, j):
        double_sine = 2 * sine_value * cosine_value
        double_cosine = cosine_value**2 - sine_value**2
        return cosine(double_sine, double_cosine, 2 * j - 3)
    def D(x, y):
        return x*x + y*y + 2*d*x*y - d*d
    s = {j: sine(sx, cx, j) for j in range(16)}
    checks = {
        "appendix_period": s[8] + s[0],
        "appendix_product_sum": s[0]*s[1] + s[4]*s[5] - C,
        "appendix_s2s6": s[2]*s[6] - d*d + s[0]*s[0],
        "appendix_s1s5": s[1]*s[5] - d*d + s[7]*s[7],
        "appendix_linear_1": RHO*(s[1]-s[7]) - s[0],
        "appendix_linear_2": RHO*(s[6]-s[0]) - s[7],
        "appendix_quadratic_1": RHO*(s[1]*s[2]-s[6]*s[7]) - s[0]*s[4],
        "appendix_quadratic_2": RHO*(s[5]*s[6]-s[0]*s[1]) - s[7]*s[3],
        "appendix_quadratic_3": RHO*(s[7]*s[0]+s[4]*s[5]) - s[6]*s[2],
        "appendix_quadratic_4": RHO*(s[2]*s[3]+s[7]*s[0]) - s[1]*s[5],
        "appendix_quadratic_5": s[1]*s[6]-s[7]*s[0] - RHO*d*d,
        "appendix_cubic_1": s[1]*s[6]*s[5] - s[7]*s[2]*s[3] - d*d*s[0],
        "appendix_cubic_2": s[1]*s[6]*s[2] - s[0]*s[4]*s[5] - d*d*s[7],
    }
    f = {j: cosine(sx, cx, j) for j in (-6, -2, 0, 2, 6, 12)}
    g = {j: cosine(sy, cy, j) for j in (-6, 0, 6, 12)}
    checks.update({
        "scalar_flat_D": D(sx, c) - (sx-c)*(sx+C),
        "scalar_delete_D_zero": D(f[0], f[6]),
        "scalar_delete_D_factor": D(f[0], sy) - (sy-f[-6])*(sy-f[6]),
        "scalar_merge_flat": (C+f[-2])*(C+f[2]) - (c+f[0])*(C+f[0]),
        "scalar_merge_spectators":
            (f[-2]-g[-6])*(f[-2]-g[12])*(f[2]-g[-6])*(f[2]-g[12])
            - (f[0]+g[0])*(f[0]+g[6])*(f[0]-g[-6])*(f[0]-g[12]),
        "moment_merge": f[-2]+f[2]-f[0] - ETA*f[0],
        "moment_delete": f[0]+f[6] + ETA*(f[-6]+f[12]),
        "moment_flat": c-ETA*C,
        "vacuum_dividing_sine":
            a(sx,cx,0)+a(sx,cx,3)+RHO
            - 4*c*sine(sx,cx,3)*(C*cx-c*sx),
        "vacuum_beta_difference":
            a(sx,cx,3)-a(sy,cy,3)
            + 2*sine(sx*cy+cx*sy,cx*cy-sx*sy,3)*(sx*cy-cx*sy),
    })
    local = symbolic_weights(sx, cx)
    checks["one_band_arch_base"] = local["A"]*local["U"]/(1-local["B"])**2 \
        - a(sx,cx,0) + ETA*(a(sx,cx,0)+RHO)
    # Multiply out the moving-box cancellation instead of dividing at its zeros.
    difference_sine = sx*cy-cx*sy
    difference_cosine = cx*cy+sx*sy
    sum_sine = sx*cy+cx*sy
    sum_cosine = cx*cy-sx*sy
    moving_L = sine(difference_sine, difference_cosine, 5) \
        * sine(difference_sine, difference_cosine, 6)
    checks["vacuum_moving_denominator"] = (
        (a(sy,cy,0)-a(sx,cx,-3))*(a(sy,cy,0)-a(sx,cx,6))
        + 4*sine(sum_sine,sum_cosine,-6)*sine(sum_sine,sum_cosine,3)*moving_L
    )
    failures = [name for name, residual in checks.items() if residual]
    assert not failures, f"false scalar source identities: {failures}"
    return {
        "result": "exact_symbolic_identities",
        "field": "Q(C)(t,v), t=tan(x/2), v=tan(y/2)",
        "zero_residuals": list(checks),
        "count": len(checks),
    }


def jacobian_payload():
    transfer = column((1, 1), 1)
    entries = []
    for i, row in enumerate(transfer):
        encoded_row = []
        for j, entry in enumerate(row):
            value = (ONE if i == j else ZERO) - entry
            coefficients = list(reversed(value.to_list()))
            terms = []
            for exponent in range(len(coefficients) - 1, -1, -1):
                coefficient = sp.Rational(coefficients[exponent])
                if coefficient:
                    terms.append({
                        "coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                        "exponents": [exponent],
                    })
            encoded_row.append({
                "domain": "QQ", "variables": ["q"],
                "numerator": {"terms": terms},
                "denominator": {"terms": [{
                    "coefficient": {"num": "1", "den": "1"}, "exponents": [0],
                }]},
            })
        entries.append(encoded_row)
    return {"matrix": {"variables": ["q"], "entries": entries}}


def verify_jacobian():
    directory = Path(__file__).parent
    payload = json.loads((directory / "jacobian_payload.json").read_text())
    output = json.loads((directory / "jacobian_output.json").read_text())
    status = json.loads((directory / "jacobian_status.json").read_text())
    operation = "matrix.symbolic.determinant.compute"
    assert status == {"operation_id": operation, "adapter_exit_code": 0, "timeout": False}
    assert payload == jacobian_payload()
    assert output["request"] == {"operation_id": operation, "payload": payload}
    assert output["result"]["operation_id"] == operation
    determinant = output["result"]["output"]["determinant"]
    assert determinant["domain"] == "QQ" and determinant["variables"] == ["q"]
    def evaluate_polynomial(polynomial):
        answer = ZERO
        for term in polynomial["terms"]:
            coefficient = term["coefficient"]
            answer += K.convert(sp.Rational(coefficient["num"], coefficient["den"])) \
                * C**term["exponents"][0]
        return answer
    value = evaluate_polynomial(determinant["numerator"]) \
        / evaluate_polynomial(determinant["denominator"])
    expected = stationary_and_source((1, 1))["det_source"]
    assert value == expected and sign(value) > 0
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "timeout": status["timeout"],
        "typed_determinant_at_C": exact(value),
        "positive": True,
    }


def verify_formal_core():
    directory = Path(__file__).resolve().parent
    root = directory.parents[1]
    result = json.loads((directory / "lean_verification.json").read_text())
    recorded = result["kernel"]["recorded"]
    archive = root / recorded["artifact"]
    certificate = json.loads(archive.read_text())
    check = certificate["lean_check"]
    assert check["status"] == "success" and check["exit_code"] == 0
    assert check["audit_exit_code"] == 0 and check["proof_holes"] == []
    assert "version 4.31.0," in check["tools"]["lean"]["version"]
    assert certificate["subject"]["subject_id"] == "C_ARCH_RESOLVENT"
    assert certificate["tier"] == "mechanical" and certificate["verdict"] == "supports"
    assert recorded["evidence_id"] == certificate["evidence_id"]
    for filename, text_key, digest_key in (
        ("Main.lean", "lean_source", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity", "statement_fidelity_sha256"),
    ):
        content = (directory / filename).read_bytes()
        assert content.decode() == certificate[text_key]["text"]
        assert hashlib.sha256(content).hexdigest() == check[digest_key]
    state = json.loads((root / "research" / "MATH_STATE.json").read_text())
    claim = max((x for x in state["claims"] if x["claim_id"] == "C_ARCH_RESOLVENT"),
                key=lambda x: x["version"])
    assert claim["content_hash"] == certificate["subject"]["content_hash"]
    assert any(x["evidence_id"] == recorded["evidence_id"] for x in state["evidence"])
    return {
        "claim": "C_ARCH_RESOLVENT",
        "compiler_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "artifact": recorded["artifact"],
        "original_source_and_fidelity_match_compiled_text": True,
        "scope": "Universal source projection, source insertion, adjoint pairing, and abstract polynomial uniqueness; not the entire arch formula.",
    }


def evaluate(row_list):
    forward = stationary_and_source(row_list)
    reflected = stationary_and_source(tuple(3 - u for u in row_list))
    n = len(row_list)
    glue = gluing_matrix(n)
    physical = sum((x * y for x, y in zip(reflected["H"], matvec(glue, forward["H"]))), ZERO)
    arguments = [cosine_argument(j) for j in row_list]
    normalization = scalar_value(arguments)
    assert normalization, "evaluated scalar normalization vanishes"
    coefficient = scalar_value(arguments, n - 1) / normalization
    assert scalar_value(arguments, n) == normalization
    predicted = sum(arguments, ZERO) - ETA * coefficient
    record = {
        "rows_in_units_of_lambda": list(row_list),
        "vacuum_basis": [list(state) for state in vacuum_states(n)],
        "source_basis": [list(state) for state in source_states(n)],
        "gluing_matrix": encoded_matrix(glue),
        "forward": {},
        "reflected": {},
        "p_N": exact(normalization),
        "quotient_coefficient": exact(coefficient),
        "glued_moment": exact(physical),
        "pfaffian_prediction": exact(predicted),
        "difference": exact(physical - predicted),
        "agreement": physical == predicted,
    }
    for name, data in (("forward", forward), ("reflected", reflected)):
        record[name] = {
            key: encoded_matrix(value) if key in {"T0", "T1", "b"}
            else [exact(x) for x in value] if key in {
                "P", "H", "contraction_vacuum", "contraction_source"}
            else exact(value)
            for key, value in data.items()
        }
    return record


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    assert 8 * C**4 - 8 * C**2 + ONE == ZERO
    assert d**2 == ONE / 2
    assert c**2 + C**2 == ONE
    cases = [evaluate(rows) for rows in ((1,), (1, 1), (1, 1, 1), (0, 2, 1), (0, 3, 1))]
    assert cases[0]["agreement"], "one-band normalization control failed"
    local_identities = verify_local_identities()
    scalar_identities = verify_scalar_identities()
    jacobian = verify_jacobian()
    formal_core = verify_formal_core()
    assert all(case["agreement"] for case in cases)
    expected_glue = zeros(5, 5)
    for i in range(3):
        expected_glue[i][i] = ONE
    expected_glue[3][4] = expected_glue[4][3] = ONE
    assert gluing_matrix(3) == expected_glue
    certificate = {
        "result_class": "exact_verification_with_general_proof",
        "field": {
            "generator": "C=cos(pi/8), the root in (9/10,1) of 8C^4-8C^2+1",
            "encoding": "rational coefficients in ascending powers of C",
        },
        "local_diagrams": [{"weight": name, "edges": [list(edge) for edge in edges]}
                           for name, edges in LOCAL],
        "cases": cases,
        "symbolic_local_identities": local_identities,
        "symbolic_scalar_identities": scalar_identities,
        "jacobian": jacobian,
        "formal_core": formal_core,
        "general_proof": {
            "statement": "For every width, the zero-loop arch moment is the claimed Pfaffian quotient coefficient.",
            "proof": "report.md, sections headed General verification theorem and Proof",
            "formal_core": "Main.lean; scope and hypotheses in statement_fidelity.md",
            "machine_checked_scope": "Exact rational-function local identities, elementary scalar identities, finite transfer controls and their convergence; abstract source projection and interpolation require the separately archived Lean compiler certificate.",
            "not_claimed": "The Python program alone does not kernel-check the all-width vacuum degree induction or the analytic path/transfer correspondence.",
        },
        "independent_review": "pending Host-invoked Reviewer",
        "novelty_status": "unreviewed; no publishability or newness verdict is asserted",
    }
    destination = Path(__file__).with_name("exact_certificate.json")
    if args.write_certificate:
        destination.write_text(json.dumps(certificate, indent=2) + "\n")
    stored = json.loads(destination.read_text())
    assert stored == certificate, "stored certificate differs from exact replay"
    print(json.dumps({
        "cases": [
            {"rows": case["rows_in_units_of_lambda"], "agreement": case["agreement"],
             "difference": case["difference"]}
            for case in cases
        ],
        "all_resolvents_nonsingular": True,
        "all_finite_control_series_converge": True,
        "symbolic_local_identities": len(local_identities["checked"]),
        "symbolic_scalar_identities": scalar_identities["count"],
        "jacobian_replayed": True,
        "formal_core_certificate_valid": True,
        "persisted_certificate_matches_replay": True,
        "all_width_proof": "report.md; human mathematical review remains necessary",
    }, indent=2))


if __name__ == "__main__":
    main()
