#!/usr/bin/env python3
"""Recompute the exact algebra in report.tex; no network or sampled periods."""

import argparse
from collections import Counter
from fractions import Fraction
from functools import reduce
from itertools import combinations_with_replacement, permutations, product
import json
from math import factorial, gcd, lcm, prod
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero_matrix(matrix, message):
    require(all(sp.cancel(x) == 0 for x in matrix), message)


def parity(sequence):
    return (-1) ** sum(
        sequence[i] > sequence[j]
        for i in range(len(sequence))
        for j in range(i + 1, len(sequence))
    )


def permutation_data(n):
    return [(p, parity(p)) for p in permutations(range(n))]


def compositions(n):
    if n == 0:
        yield ()
    for first in range(1, n + 1):
        for rest in compositions(n - first):
            yield (first,) + rest


def hermitian_identities():
    d = sp.Symbol("d", positive=True)
    u = sp.Symbol("u")

    def field_reduce(value):
        numerator, denominator = sp.cancel(value).as_numer_denom()
        require(not denominator.has(u), "Unexpected quadratic-field denominator")
        return sp.cancel(sp.rem(numerator, u * u + d, u) / denominator)

    records = []
    for n in range(1, 7):
        size = 2 * n
        entries = iter(sp.symbols(f"x0:{size * (size - 1) // 2}"))
        e0 = sp.zeros(size)
        for i in range(size):
            for j in range(i + 1, size):
                e0[i, j] = next(entries)
                e0[j, i] = -e0[i, j]
        action = sp.diag(*([sp.Matrix([[0, -d], [1, 0]])] * n))
        e = e0 + action.T * e0 * action / d
        zero_matrix(action * action + d * sp.eye(size), "u^2=-d")
        zero_matrix(e + e.T, "Averaging lost alternation")
        zero_matrix(e * action + action.T * e, "Averaging lost compatibility")
        h0, h1 = e * action, e
        zero_matrix(h0 - h0.T, "Real Hermitian coefficient is not symmetric")
        zero_matrix(h1 + h1.T, "Imaginary Hermitian coefficient is not skew")
        zero_matrix(h0 * action + d * h1, "Second-variable E-linearity, real")
        zero_matrix(h1 * action - h0, "Second-variable E-linearity, imaginary")
        zero_matrix(action.T * h0 - d * h1, "First-variable conjugate-linearity")
        zero_matrix(action.T * h1 + h0, "First-variable imaginary coefficient")
        diagonal = sp.symbols(f"a0:{n}", nonzero=True)
        qdet = prod(diagonal) * prod(d * x for x in diagonal)
        require(sp.expand(qdet - d**n * prod(diagonal) ** 2) == 0,
                "Underlying rational quadratic determinant")
        records.append({
            "E_rank": n,
            "rational_dimension": size,
            "independent_alternating_coefficients": size * (size - 1) // 2,
            "generic_identities": "passed",
            "quadratic_determinant": "d^n * (product a_i)^2",
        })

    a0, a1 = sp.symbols("h0 h1")
    trace = (a0 + u * a1) * (-u / (2 * d))
    require(field_reduce(trace + trace.subs(u, -u)) == a1,
            "Trace recovery of the Riemann form")

    a = sp.Symbol("a", nonzero=True)
    x, y = sp.symbols("x y", real=True)
    norm = x * x + d * y * y
    b = -norm / a
    v = sp.Matrix([(x + u * y) / a, 1])
    w0 = sp.Matrix([0, 1 / b])
    w = w0 - v / (2 * b)
    change = sp.Matrix.hstack(v, w)
    gram = change.subs(u, -u).T * sp.diag(a, b) * change
    hyperbolic = sp.Matrix([[0, 1], [1, 0]])
    zero_matrix((gram - hyperbolic).applyfunc(field_reduce),
                "Explicit binary hyperbolic basis")
    change_norm = field_reduce(change.det() * change.det().subs(u, -u))
    require(sp.cancel(change_norm - 1 / norm) == 0,
            "Binary change-of-basis norm")
    return {
        "generic_averaging": records,
        "trace_identity": "Tr((2u)^(-1) h)=e",
        "binary_hyperbolic_change": {
            "hypotheses": "a != 0; d > 0; x,y rational and not both zero",
            "b": "-(x^2+d*y^2)/a",
            "v": ["(x+u*y)/a", "1"],
            "w": "(0,1/b) - v/(2b)",
            "resulting_gram": [[0, 1], [1, 0]],
            "norm_of_change_determinant": "1/(x^2+d*y^2)",
        },
        "meyer_scope": {
            "imported_not_computationally_proved": True,
            "dimensions_used": [12, 8],
            "dimension_four_handled_by_norm_identity": True,
        },
    }


def padding_identities():
    delta = sp.Symbol("delta", positive=True)
    scale_integer = sp.Symbol("N", positive=True)
    records = []
    for p, q in product(range(4), repeat=2):
        n = p + q
        if not 1 <= n < 6:
            continue
        signs = [1] * (3 - p) + [-1] * (3 - q)
        magnitudes = sp.symbols(f"c0:{6 - n}", positive=True)
        coefficients = [s * c for s, c in zip(signs, magnitudes)]
        determinant = (-1)**q * delta * prod(coefficients)
        require(sp.expand(determinant + delta * prod(magnitudes)) == 0,
                "Padded determinant must be negative")
        correction = sp.cancel(-1 / determinant)
        require(correction.is_positive is True, "Padding rescales positively")
        adjusted = list(coefficients)
        adjusted[-1] *= correction
        require(sp.cancel((-1)**q * delta * prod(adjusted)) == -1,
                "Actual padded determinant is not -1")
        require(p + signs.count(1) == 3 and q + signs.count(-1) == 3,
                "Padded signature is not (3,3)")
        j = n - 3
        source_type = [3 - q, 3 - p]
        target_type = [value + j for value in source_type]
        require(target_type == [p, q], "Padding Hodge twist has wrong sign")
        require((6 - n) + 2 * j == n, "Padding cohomological degree shift")
        require((6 - n) + j == 3, "CM-source correspondence codimension")
        records.append({
            "signature": [p, q],
            "target_degree": n,
            "added_line_signs": signs,
            "source_dimension_and_degree": 6 - n,
            "source_type_before_twist": source_type,
            "Tate_twist": 3 - n,
            "target_type": target_type,
            "correspondence_shift_j": j,
            "correspondence_codimension": 3,
            "determinant_before_correction": "-delta * product(c_i)",
            "positive_correction": "1/(delta * product(c_i))",
            "determinant_after_correction": -1,
        })
    require(len(records) == 14, "Incomplete smaller-signature coverage")
    require(sp.expand(scale_integer**6 - (scale_integer**3)**2) == 0,
            "Integral scaling is not a norm in rank six")
    return {
        "smaller_signatures": records,
        "integral_scaling_norm": "N^6 = Nm_E/Q(N^3)",
        "split_rank_six_source": "point, using Markman Theorem 1.5.1",
        "original_factor_polarization_changed": False,
    }


def determinant_identities():
    direct_sums = []
    contractions = []
    for n in range(1, 7):
        perms = permutation_data(n)
        for parts in compositions(n):
            bounds = []
            start = 0
            for length in parts:
                bounds.extend([(start, start + length)] * length)
                start += length
            local = [
                (p, sign) for p, sign in perms
                if all(lo <= value < hi for value, (lo, hi) in zip(p, bounds))
            ]
            local_count = prod(factorial(r) for r in parts)
            require(len(local) == local_count, "Block determinant projection")
            for p, sign in local:
                offset, block_sign = 0, 1
                for length in parts:
                    block_sign *= parity(p[offset:offset + length])
                    offset += length
                require(sign == block_sign, "Block projection Koszul sign")
            alternating = Counter()
            for p, p_sign in local:
                for permutation, sign in perms:
                    alternating[tuple(p[i] for i in permutation)] += p_sign * sign
            require(
                dict(alternating) == {p: sign * local_count for p, sign in perms},
                "Direct-sum inverse alternation coefficient",
            )
            direct_sums.append({
                "rank": n,
                "composition": list(parts),
                "projection_coefficient": 1,
                "inverse_alternation_coefficient": local_count,
            })

        polynomial = Counter()
        for left, left_sign in perms:
            inverse = [0] * n
            for position, row in enumerate(left):
                inverse[row] = position
            for right, right_sign in perms:
                monomial = tuple(right[inverse[row]] for row in range(n))
                polynomial[monomial] += left_sign * right_sign
        expected = {p: factorial(n) * sign for p, sign in perms}
        require(dict(polynomial) == expected, "Generic r! det(B) contraction")
        contractions.append({
            "rank": n,
            "independent_determinant_monomials": factorial(n),
            "contraction_factor": factorial(n),
            "identity": "contraction(delta_r,delta_r)=r!*det(B)",
            "inverse_pair_alternation_factor": factorial(n),
        })
    require(len(direct_sums) == 63, "Missing a rank-at-most-six composition")
    return {"direct_sum_maps": direct_sums, "generic_contractions": contractions}


def pfaffian_identities():
    def pfaffian(matrix, indices):
        if not indices:
            return sp.Integer(1)
        return sum(
            (-1)**(j + 1) * matrix[indices[0], indices[j]]
            * pfaffian(matrix, indices[1:j] + indices[j + 1:])
            for j in range(1, len(indices))
        )

    def wedge(left, right):
        answer = {}
        for i, a in left.items():
            for j, b in right.items():
                if set(i).isdisjoint(j):
                    key = tuple(sorted(i + j))
                    answer[key] = answer.get(key, 0) + parity(i + j) * a * b
        return {key: sp.expand(value) for key, value in answer.items()}

    records = []
    for n in (2, 4, 6):
        matrix = sp.zeros(n)
        for i in range(n):
            for j in range(i + 1, n):
                matrix[i, j] = sp.Symbol(f"b{i}{j}")
                matrix[j, i] = -matrix[i, j]
        pf = sp.expand(pfaffian(matrix, tuple(range(n))))
        determinant = sum(
            sign * prod(matrix[i, p[i]] for i in range(n))
            for p, sign in permutation_data(n)
        )
        require(sp.expand(determinant - pf**2) == 0, "det(B)=Pf(B)^2")
        two_form = {(i, j): 2 * matrix[i, j]
                    for i in range(n) for j in range(i + 1, n)}
        power = {(): sp.Integer(1)}
        for _ in range(n // 2):
            power = wedge(power, two_form)
        coefficient = 2**(n // 2) * factorial(n // 2)
        require(sp.expand(power[tuple(range(n))] - coefficient * pf) == 0,
                "Top wedge of an alternating pair tensor")
        records.append({
            "rank": n,
            "pfaffian_monomials": len(sp.Poly(pf).terms()),
            "top_wedge_factor": coefficient,
            "determinant_identity": "det(B)=Pf(B)^2",
        })
    return records


def degree_one_projectors():
    records = []
    for g in range(1, 7):
        coefficients = [Fraction(1)]
        for r in range(2 * g + 1):
            if r == 1:
                continue
            denominator = 2 - 2**r
            updated = [Fraction(0)] * (len(coefficients) + 1)
            for i, value in enumerate(coefficients):
                updated[i] -= value * 2**r / denominator
                updated[i + 1] += value / denominator
            coefficients = updated
        eigenvalues = [
            sum(value * (2**r)**i for i, value in enumerate(coefficients))
            for r in range(2 * g + 1)
        ]
        require(eigenvalues == [Fraction(int(r == 1)) for r in range(2 * g + 1)],
                "Degree-one interpolation projector")
        records.append({
            "abelian_dimension": g,
            "polynomial_coefficients_low_to_high": [str(x) for x in coefficients],
            "eigenvalues_on_degrees_zero_to_2g": [int(x) for x in eigenvalues],
        })
    return records


def primitive_kernel(matrix):
    bases = sp.Matrix(matrix).nullspace()
    require(len(bases) == 1, "Expected a one-dimensional rational kernel")
    denominator = lcm(*(int(x.q) for x in bases[0]))
    vector = [int(x * denominator) for x in bases[0]]
    divisor = reduce(gcd, (abs(x) for x in vector))
    vector = [x // divisor for x in vector]
    if next(x for x in vector if x) < 0:
        vector = [-x for x in vector]
    require(vector[0] == 1, "No integral coordinate proves kernel primitiveness")
    zero_matrix(sp.Matrix(matrix) * sp.Matrix(vector), "Kernel generator")
    return vector


def balance_lattices():
    quartic, cubic, cyclic = [], [], []
    for d in sorted(set(permutations((0, -2))) | set(permutations((0, 2)))):
        matrix = [[d[0], d[1], 1], [d[1], d[0], 1]]
        generator = primitive_kernel(matrix)
        require(generator == [1, 1, -sum(d)], "Quartic fixed-CM integer kernel")
        quartic.append({"imbalance": list(d), "matrix": matrix,
                        "integer_kernel_generator": generator})
    for d in ((-1, 1), (1, -1)):
        matrix = [list(d), list(reversed(d))]
        generator = primitive_kernel(matrix)
        require(generator == [1, 1], "Two rank-three columns")
        cubic.append({"imbalance": list(d), "matrix": matrix,
                      "integer_kernel_generator": generator})
    for d in permutations((-2, 0, 2)):
        matrix = [list(d[shift:] + d[:shift]) for shift in range(3)]
        generator = primitive_kernel(matrix)
        require(generator == [1, 1, 1], "Three rank-two columns")
        cyclic.append({"imbalance": list(d), "matrix": matrix,
                       "integer_kernel_generator": generator})
    odd_imbalances = [-3, -1, 1, 3]
    for imbalance in odd_imbalances:
        require(sp.Matrix([[imbalance]]).nullspace() == [],
                "Nonzero odd single-column imbalance must force zero exponent")

    reconstructions = []
    for columns in (1, 2, 3):
        pairs = sp.symbols(f"a0:{columns}", nonnegative=True, integer=True)
        common = sp.Symbol("t", nonnegative=True, integer=True)
        for orientation in (1, -1):
            plus = [a + common if orientation == 1 else a for a in pairs]
            minus = [a if orientation == 1 else a + common for a in pairs]
            for i, (p, q) in enumerate(zip(plus, minus)):
                require(sp.expand(p - q - orientation * common) == 0,
                        "Universal integer net exponent")
                require(sp.expand(p - pairs[i] - (common if orientation == 1 else 0)) == 0,
                        "Positive determinant monoid reconstruction")
                require(sp.expand(q - pairs[i] - (common if orientation == -1 else 0)) == 0,
                        "Opposite determinant monoid reconstruction")
            reconstructions.append({
                "columns": columns, "orientation": orientation,
                "opposite_pair_counts": [str(a) for a in pairs],
                "full_determinant_count": "t",
                "plus_counts": [str(p) for p in plus],
                "minus_counts": [str(q) for q in minus],
                "parameters": "a_i,t arbitrary nonnegative integers",
            })

    matrix = sp.Matrix([[-2, 0, 2], [2, -2, 0], [0, 2, -2]])
    witness = sp.Matrix([0, 1, 0])
    require((matrix * witness)[0] == 0 and matrix * witness != sp.zeros(3, 1),
            "Identity-only balance negative control")
    varying_cm = sp.Matrix([[0, -2, 1, 0], [-2, 0, 0, 1]])
    artificial = sp.Matrix([1, 0, 0, 2])
    zero_matrix(varying_cm * artificial, "Varying-CM-list negative control")
    fixed_cm = sp.Matrix([[0, -2, 1], [-2, 0, 1]])
    require(fixed_cm * sp.Matrix([1, 0, 0]) != sp.zeros(2, 1),
            "A fixed CM list must exclude the artificial solution")
    return {
        "quartic_center_with_fixed_CM": quartic,
        "two_rank_three_columns": cubic,
        "three_rank_two_columns": cyclic,
        "odd_single_column": {"nonzero_imbalances": odd_imbalances,
                              "integer_kernel": [0]},
        "universal_monoid_reconstruction": reconstructions,
        "negative_controls": {
            "identity_only_cyclic_witness": [0, 1, 0],
            "identity_only_residual": list(map(int, matrix * witness)),
            "varying_CM_witness_n1_n2_c0_c1": [1, 0, 0, 2],
            "abelian_variety_counterexample_claimed": False,
        },
    }


def factor_templates():
    factors = []

    def add(kind, g, f, a, r, holomorphic, signature, **extra):
        factors.append({
            "kind": kind, "g": g, "f": f, "column_rank": a,
            "multiplicity": r, "cost": g * r,
            "holomorphic_multiplicities": list(holomorphic),
            "E_signature": list(signature), **extra,
        })

    for g in (4, 6):
        add("III", g, 1, g, 1, (g // 2,), (g // 2, g // 2))
    for g in range(3, 7):
        for p in range(1, g):
            add("IV-field", g, 1, g, 1, (p,), (p, g - p))
    for p in (1, 2):
        for positive_copies in range(3):
            p_total = positive_copies * p + (2 - positive_copies) * (3 - p)
            add("IV-field", 3, 1, 3, 2, (p,), (p_total, 6 - p_total),
                positive_E_copies=positive_copies)
        add("IV-nonembedded", 3, 1, 3, 2, (p,), (3, 3))
    for f, a in ((2, 2), (2, 3), (3, 2)):
        for h in product(range(a + 1), repeat=f):
            mixed = [0 < p < a for p in h]
            if not any(mixed):
                continue
            if a == 2 and all(mixed):
                continue
            add("IV-field", f * a, f, a, 1, h, (sum(h), f * a - sum(h)))
    return factors


def configuration_coverage():
    templates = factor_templates()
    records = []
    routes = Counter()
    for family, dimensions in (("quadratic-five", range(1, 6)),
                               ("split-sixfold", (6,))):
        for dimension in dimensions:
            allowed = [(i, f) for i, f in enumerate(templates) if f["cost"] <= dimension]
            for count in range(dimension // 3 + 1):
                for choices in combinations_with_replacement(allowed, count):
                    indices = [i for i, _ in choices]
                    factors = [f for _, f in choices]
                    used = sum(f["cost"] for f in factors)
                    if used > dimension:
                        continue
                    p = sum(f["E_signature"][0] for f in factors)
                    q = sum(f["E_signature"][1] for f in factors)
                    residual_dimension = dimension - used
                    if family == "split-sixfold":
                        residuals = [(3 - p, 3 - q)] if p <= 3 and q <= 3 else []
                    else:
                        residuals = [(s, residual_dimension - s)
                                     for s in range(residual_dimension + 1)]
                    for residual in residuals:
                        require(sum(residual) == residual_dimension, "Residual dimension")
                        choices_of_route = []
                        for factor in factors:
                            g, f, a, r = (factor[key] for key in
                                           ("g", "f", "column_rank", "multiplicity"))
                            sig = factor["E_signature"]
                            h = factor["holomorphic_multiplicities"]
                            if factor["kind"] == "III":
                                require(sig == [g // 2, g // 2], "Orthogonal signature")
                                route = "padded-orthogonal" if g == 4 else "actual-split-volume"
                            elif factor["kind"] == "IV-nonembedded":
                                require(dimension == used == 6 and len(factors) == 1,
                                        "Nonembedded case must exhaust A")
                                require(2 * h[0] - 3 != 0, "Odd nonembedded imbalance")
                                route = "zero-net-nonembedded"
                            elif f == 1 and r == 2:
                                require(g == 3 and dimension == used == 6,
                                        "Only repeated non-CM threefold allowed")
                                require(h[0] in (1, 2), "Central threefold must be mixed")
                                route = "central-threefold-padding"
                            elif f == 1 and g == 5 and family == "quadratic-five":
                                require(dimension == used == 5 and len(factors) == 1,
                                        "Odd fivefold must exhaust A")
                                require(2 * h[0] - 5 != 0, "Fivefold imbalance")
                                route = "zero-net-odd-fivefold"
                            elif f == 1 and g < 6:
                                require(max(sig) <= 3, "Invoking padding outside signature bound")
                                route = "padded-quadratic-singleton"
                            elif f == 1 and g == 6:
                                require(family == "split-sixfold" and sig == [3, 3],
                                        "Rank-six determinant needs actual split hypothesis")
                                route = "actual-split-volume"
                            elif (f, a) == (2, 2):
                                require(len(factors) == 1, "Quartic fourfold cannot coexist")
                                require(sorted(abs(2 * x - 2) for x in h) == [0, 2],
                                        "Quartic mixed/pure imbalance")
                                if family == "quadratic-five":
                                    require(residual_dimension in (0, 1),
                                            "Small quartic remainder is not elliptic")
                                else:
                                    require(residual in ((2, 0), (0, 2)),
                                            "Split quartic remainder is not pure E-CM")
                                require(tuple(sig) in ((1, 3), (3, 1)), "Quartic signature")
                                route = "fixed-E-CM-diagonal-quartic"
                            elif (f, a) == (2, 3):
                                require(dimension == used == 6 and residual == (0, 0),
                                        "Higher-center rank-three case must exhaust A")
                                require(sorted(h) == [1, 2], "Rank-three balanced signatures")
                                route = "two-column-diagonal-actual-volume"
                            elif (f, a) == (3, 2):
                                require(dimension == used == 6 and residual == (0, 0),
                                        "Higher-center rank-two case must exhaust A")
                                require(sorted(h) == [0, 1, 2], "Rank-two special-period signatures")
                                route = "three-column-diagonal-actual-volume"
                            else:
                                raise AssertionError(f"Uncovered factor: {factor}")
                            if route == "actual-split-volume":
                                require(dimension == used == 6 and len(factors) == 1,
                                        "A proper summand was assumed hyperbolic")
                            choices_of_route.append(route)
                            routes[route] += 1
                        records.append({
                            "family": family, "dimension": dimension,
                            "factor_indices": indices,
                            "residual_E_signature": list(residual),
                            "total_E_signature": [p + residual[0], q + residual[1]],
                            "supply_routes": choices_of_route or ["pair-only-or-CM"],
                        })
    require(set(routes) == {
        "padded-orthogonal", "actual-split-volume", "zero-net-nonembedded",
        "central-threefold-padding", "zero-net-odd-fivefold",
        "padded-quadratic-singleton", "fixed-E-CM-diagonal-quartic",
        "two-column-diagonal-actual-volume", "three-column-diagonal-actual-volume",
    }, "Missing a necessary supply route")
    return {
        "covering_templates": templates,
        "configurations": records,
        "template_count": len(templates),
        "configuration_count": len(records),
        "route_occurrences": dict(sorted(routes.items())),
        "scope": "Necessary overapproximation from reviewed AG-UNIVERSAL; not realizability",
        "tensor_degree_or_exponent_bound": None,
    }


def jacobian_evidence():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "matrix.nullspace.compute"
    require(status == {"adapter_exit_code": 0, "timeout": False, "error": None},
            "Jacobian failure, timeout or unknown status is not mathematical evidence")
    require(contract["result"]["operation"]["operation_id"] == operation,
            "Wrong inspected operation")
    require(response["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian request does not match the saved payload")
    require(response["result"]["operation_id"] == operation, "Wrong executed operation")
    output = response["result"]["output"]
    require(output["matrix"] == payload["matrix"], "Jacobian returned a different matrix")
    require(response["server"]["version"] == contract["server"]["version"],
            "Server changed between inspection and execution")
    require(response["protocol_version"] == contract["protocol_version"],
            "Protocol changed between inspection and execution")

    def rational(value):
        result = Fraction(int(value["num"]), int(value["den"]))
        require(value == {"num": str(result.numerator), "den": str(result.denominator)},
                "Noncanonical typed rational")
        return sp.Rational(result.numerator, result.denominator)

    matrix = sp.Matrix([[rational(v) for v in row]
                        for row in payload["matrix"]["entries"]])
    rref, pivots = matrix.rref()
    nullspace = matrix.nullspace()
    returned = [sp.Matrix([rational(v) for v in row]) for row in output["basis_vectors"]]
    require(matrix == sp.Matrix([[-2, 0, 2], [2, -2, 0], [0, 2, -2]]),
            "Jacobian matrix is not the claimed balance system")
    require(returned == nullspace, "Jacobian basis disagrees with exact recomputation")
    require(output["rank"] == len(pivots) == 2, "Jacobian rank")
    require(output["nullity"] == len(nullspace) == 1, "Jacobian nullity")
    require(output["ambient_dimension"] == matrix.cols == 3, "Jacobian dimension")
    require(output["free_columns"] == [i for i in range(3) if i not in pivots],
            "Jacobian free columns")
    require(output["convention"] == "RREF_FUNDAMENTAL_BASIS", "Jacobian convention")
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_status": status,
        "matrix": [[int(v) for v in row] for row in matrix.tolist()],
        "rref": [[str(v) for v in row] for row in rref.tolist()],
        "rank": 2, "nullity": 1,
        "basis": [[int(v) for v in vector] for vector in nullspace],
        "integer_kernel": "Z*(1,1,1), because the first coordinate is one",
    }


def recompute():
    return {
        "schema_version": 1,
        "claim": "DS-UNIVERSAL",
        "result_kind": "exact_algebraic_certificate_for_universal_prose_verification",
        "formal_kernel_verification": False,
        "external_inputs": [
            "reviewed AG-UNIVERSAL", "MARKMAN-WEIL", "MEYER",
            "HERMITIAN-CONVENTION", "FFT-SP", "FFT-SO", "FFT-SL",
        ],
        "CM_Hodge_theorem_used_for_supply": False,
        "hermitian_algebra": hermitian_identities(),
        "polarization_padding": padding_identities(),
        "determinant_maps": determinant_identities(),
        "pfaffian_signs": pfaffian_identities(),
        "degree_one_projectors": degree_one_projectors(),
        "integer_balance": balance_lattices(),
        "case_coverage": configuration_coverage(),
        "jacobian": jacobian_evidence(),
        "unbounded_steps_proved_in_report": [
            "all-degree invariant spanning",
            "simultaneous balance of dependent lines for one fixed CM list",
            "geometric realization of the necessary E-CM remainders",
            "arbitrary nonnegative counts and integer net exponents",
            "rational coefficient descent and polarizable Hodge lifts",
            "labeled tensor slots and exterior classes on every self-power",
        ],
        "not_claimed": [
            "geometric realizability of every enumerated numerical template",
            "a formal proof of Markman or Meyer",
            "the separate CM Hodge theorem",
            "unconditional algebraicity from the supply result",
            "saturation after arbitrary added CM companions",
            "publication novelty or independent Reviewer acceptance",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="issue the certificate after recomputing every check")
    args = parser.parse_args()
    computed = recompute()
    destination = HERE / "exact_certificate.json"
    if args.write_certificate:
        destination.write_text(json.dumps(computed, indent=2, sort_keys=True) + "\n")
    else:
        recorded = json.loads(destination.read_text())
        require(recorded == computed, "The recorded exact certificate is stale or incorrect")
    coverage = computed["case_coverage"]
    print(json.dumps({
        "ok": True,
        "mode": "issued" if args.write_certificate else "read_only_replay",
        "smaller_padding_signatures": len(computed["polarization_padding"]["smaller_signatures"]),
        "direct_sum_compositions": len(computed["determinant_maps"]["direct_sum_maps"]),
        "primitive_exceptional_balance_kernels": sum(
            len(computed["integer_balance"][key]) for key in
            ("quartic_center_with_fixed_CM", "two_rank_three_columns", "three_rank_two_columns")
        ),
        "covering_templates": coverage["template_count"],
        "dimension_signature_configurations": coverage["configuration_count"],
        "jacobian_rank": computed["jacobian"]["rank"],
        "jacobian_nullity": computed["jacobian"]["nullity"],
        "tensor_degree_or_exponent_bound": None,
        "formal_kernel_verification": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
