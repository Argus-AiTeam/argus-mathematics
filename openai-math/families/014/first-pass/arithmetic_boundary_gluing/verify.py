#!/usr/bin/env python3
"""Replay exact algebraic evidence; the universal geometric proof is theorem.md."""

import argparse
import json
from math import gcd
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
T = sp.Symbol("t")
Z, Y = sp.symbols("z y", nonzero=True)
Q = sp.Rational(11)
ELL = 5
E = 24


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def equal(left, right, message):
    require(left.shape == right.shape, f"{message}: matrix shapes")
    require(all(sp.expand(x) == 0 for x in left - right), message)


def matrix_data(matrix):
    return [[str(x) for x in row] for row in matrix.tolist()]


def polynomial_at(polynomial, matrix):
    value = sp.zeros(matrix.rows)
    identity = sp.eye(matrix.rows)
    for coefficient in polynomial.all_coeffs():
        value = value * matrix + coefficient * identity
    return value


def primary_grading(matrix, multiplier):
    n = matrix.rows
    require(matrix.cols == n and n > 0, "nonempty square matrix required")
    require(matrix.det() != 0, "Frobenius matrix must be invertible")
    require(multiplier > 1, "this rational replay uses a multiplier greater than one")
    characteristic = sp.Poly(matrix.charpoly(T).as_expr(), T, domain=sp.QQ)
    factors = sp.factor_list(characteristic)[1]
    polynomials = [factor.monic() for factor, _ in factors]
    positions = {tuple(f.all_coeffs()): i for i, f in enumerate(polynomials)}
    predecessors = {}
    for i, factor in enumerate(polynomials):
        shifted = sp.Poly(
            multiplier ** factor.degree() * factor.as_expr().subs(T, T / multiplier),
            T,
            domain=sp.QQ,
        ).monic()
        successor = positions.get(tuple(shifted.all_coeffs()))
        if successor is not None:
            require(successor not in predecessors, "nonunique primary predecessor")
            predecessors[successor] = i

    heights = []
    for i in range(len(factors)):
        seen = set()
        vertex = i
        while vertex in predecessors:
            require(vertex not in seen, "a primary multiplier cycle is forbidden")
            seen.add(vertex)
            vertex = predecessors[vertex]
        heights.append(len(seen))

    projectors = {}
    components = []
    for i, (factor, multiplicity) in enumerate(factors):
        modulus = factor ** multiplicity
        complement = characteristic.exquo(modulus)
        inverse = sp.invert(complement, modulus)
        polynomial = (complement * inverse).rem(characteristic)
        projector = polynomial_at(polynomial, matrix)
        height = heights[i]
        projectors[height] = projectors.get(height, sp.zeros(n)) + projector
        components.append(
            {
                "factor": str(factor.as_expr()),
                "characteristic_multiplicity": multiplicity,
                "height": height,
                "primary_dimension": int(sp.trace(projector)),
            }
        )
    return projectors, components


def cocharacter(projectors, value):
    n = next(iter(projectors.values())).rows
    result = sp.zeros(n)
    for height, projector in projectors.items():
        result += value ** height * projector
    return result


def jordan_type(nilpotent):
    n = nilpotent.rows
    nullities = [0] + [n - (nilpotent ** k).rank() for k in range(1, n + 1)]
    at_least = [nullities[k] - nullities[k - 1] for k in range(1, n + 1)] + [0]
    return [
        size
        for size in range(n, 0, -1)
        for _ in range(at_least[size - 1] - at_least[size])
    ]


def check_pair(name, matrix, nilpotent, multiplier=Q, degree=E, include_matrices=False):
    n = matrix.rows
    require(nilpotent.shape == (n, n), f"{name}: nilpotent shape")
    equal(matrix * nilpotent, multiplier * nilpotent * matrix, f"{name}: AN=rNA")
    equal(nilpotent ** n, sp.zeros(n), f"{name}: nilpotence")
    projectors, components = primary_grading(matrix, multiplier)
    equal(sum(projectors.values(), sp.zeros(n)), sp.eye(n), f"{name}: projector sum")
    zero = sp.zeros(n)
    for height, projector in projectors.items():
        require(0 <= height < n, f"{name}: weight bound")
        equal(projector * matrix, matrix * projector, f"{name}: centralizing projector")
        for other_height, other in projectors.items():
            target = projector if height == other_height else zero
            equal(projector * other, target, f"{name}: orthogonal idempotents")
        equal(
            nilpotent * projector,
            projectors.get(height + 1, zero) * nilpotent,
            f"{name}: primary height raises by one",
        )
    equal(projectors.get(0, zero) * nilpotent, zero, f"{name}: no incoming height zero")
    cz = cocharacter(projectors, Z)
    cy = cocharacter(projectors, Y)
    equal(cz * cy, cocharacter(projectors, Z * Y), f"{name}: symbolic group law")
    equal(cz * nilpotent, Z * nilpotent * cz, f"{name}: symbolic weight-one identity")
    value = -sp.Rational(1, degree)
    conjugator = cocharacter(projectors, value)
    inverse = cocharacter(projectors, 1 / value)
    equal(conjugator * inverse, sp.eye(n), f"{name}: conjugator inverse")
    equal(
        conjugator * nilpotent * inverse,
        value * nilpotent,
        f"{name}: exact boundary conjugation",
    )
    power = sp.eye(n)
    for k in range(n):
        equal(
            (-degree) ** k * conjugator * power * inverse,
            power,
            f"{name}: exponential coefficient {k}",
        )
        power *= nilpotent
    summary = {
        "name": name,
        "dimension": n,
        "nilpotent_jordan_type": jordan_type(nilpotent),
        "primary_components": components,
        "weight_dimensions": {
            str(h): int(sp.trace(projector)) for h, projector in sorted(projectors.items())
        },
        "symbolic_cocharacter_and_boundary_identities": True,
    }
    if include_matrices:
        summary.update(A=matrix_data(matrix), N=matrix_data(nilpotent), P=matrix_data(conjugator))
    return summary, conjugator, projectors


def partitions(total, maximum=None):
    if total == 0:
        yield ()
        return
    maximum = total if maximum is None else min(maximum, total)
    for first in range(maximum, 0, -1):
        for rest in partitions(total - first, first):
            yield (first,) + rest


def partition_pair(partition):
    blocks_a = []
    blocks_n = []
    for size in partition:
        blocks_a.append(sp.diag(*(Q ** i for i in range(size))))
        block = sp.zeros(size)
        for i in range(size - 1):
            block[i + 1, i] = 1
        blocks_n.append(block)
    return sp.diag(*blocks_a), sp.diag(*blocks_n)


def valuation(value, prime):
    value = sp.Rational(value)
    require(value != 0, "valuation of zero is not requested")
    numerator, denominator = abs(int(value.p)), int(value.q)
    result = 0
    while numerator % prime == 0:
        result += 1
        numerator //= prime
    while denominator % prime == 0:
        result -= 1
        denominator //= prime
    return result


def integral(matrix):
    return all(x == 0 or valuation(x, ELL) >= 0 for x in matrix)


def exponential(nilpotent, scalar=1):
    result = sp.eye(nilpotent.rows)
    power = sp.eye(nilpotent.rows)
    for k in range(1, nilpotent.rows):
        power *= nilpotent
        result += sp.Rational(scalar) ** k * power / sp.factorial(k)
    return result


def reduce_matrix(matrix, modulus):
    return matrix.applyfunc(
        lambda value: (int(value.p) * pow(int(value.q), -1, modulus)) % modulus
    )


def minimal_polynomial(matrix):
    n = matrix.rows
    power = sp.eye(n)
    columns = [power.reshape(n * n, 1)]
    for degree in range(1, n + 1):
        power *= matrix
        vector = power.reshape(n * n, 1)
        previous = sp.Matrix.hstack(*columns)
        if previous.row_join(vector).rank() == previous.cols:
            coefficients, parameters = previous.gauss_jordan_solve(vector)
            require(parameters.rows == 0, "minimal dependence must be unique")
            polynomial = sp.Poly(
                T ** degree - sum(coefficients[i] * T ** i for i in range(degree)),
                T,
                domain=sp.QQ,
            )
            equal(polynomial_at(polynomial, matrix), sp.zeros(n), "minimal polynomial replay")
            return polynomial
        columns.append(vector)
    raise AssertionError("Cayley-Hamilton bound not reached")


def typed_rational(value):
    numerator, denominator = int(value["num"]), int(value["den"])
    require(denominator > 0, "typed denominator must be positive")
    require(gcd(abs(numerator), denominator) == 1, "typed rational must be reduced")
    require(str(numerator) == value["num"] and str(denominator) == value["den"], "canonical decimals")
    return sp.Rational(numerator, denominator)


def typed_polynomial(value):
    coefficients = [typed_rational(x) for x in value["coefficients"]]
    require(coefficients[-1] == 1, "typed polynomial must be monic")
    return sp.Poly(sum(c * T ** i for i, c in enumerate(coefficients)), T, domain=sp.QQ)


def replay_jacobian():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_result.json").read_text())
    operation = json.loads((ROOT / "jacobian_operation.json").read_text())
    operation_id = "matrix.primary_decomposition.compute"
    require(response["request"]["operation_id"] == operation_id, "Jacobian operation id")
    require(response["request"]["payload"] == payload, "Jacobian exact input binding")
    require(operation["adapter_exit_code"] == 0 and not operation["timeout"], "adapter must have succeeded")
    require(operation["adapter_error"] is None, "adapter error is not evidence")
    require(response["protocol_version"] == operation["protocol_version"], "protocol binding")
    require(response["server"]["version"] == operation["server_version"], "server version binding")
    result = response["result"]
    require(result["operation_id"] == operation_id and "error" not in result, "typed operation success")
    output = result["output"]
    require(output["matrix"] == payload, "typed output source matrix")
    require(output["method"] == "FACTOR_LCM", "typed method")
    matrix = sp.Matrix([[typed_rational(x) for x in row] for row in payload["matrix"]["entries"]])
    polynomial = minimal_polynomial(matrix)
    require(polynomial == typed_polynomial(output["minimal_polynomial"]), "independent minimal polynomial")
    expected = {str((factor ** exponent).as_expr()) for factor, exponent in sp.factor_list(polynomial)[1]}
    observed = {str(typed_polynomial(x).as_expr()) for x in output["components"]}
    require(expected == observed, "independent primary components")
    require(not polynomial.gcd(polynomial.diff()).is_one, "fixture must be nonsemisimple")
    return {
        "operation_id": operation_id,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "timeout": False,
        "minimal_polynomial": str(polynomial.as_expr()),
        "components": sorted(observed),
        "independent_exact_replay": True,
    }


def run_checks():
    require(E > 1 and gcd(E, ELL) == 1, "common degree is prime to l")
    require(valuation(-sp.Rational(1, E) - 1, ELL) == 2, "specified closeness threshold")
    summaries = []
    partition_count = 0
    for n in range(1, 7):
        for partition in partitions(n):
            matrix, nilpotent = partition_pair(partition)
            change = sp.eye(n)
            for i in range(n - 1):
                change[i, i + 1] = i + 1
            for suffix, basis in [("standard", sp.eye(n)), ("changed-basis", change)]:
                a = basis * matrix * basis.inv()
                b = basis * nilpotent * basis.inv()
                summary, _, _ = check_pair(f"partition-{partition}-{suffix}", a, b)
                require(summary["nilpotent_jordan_type"] == list(partition), "prescribed Jordan partition")
                summaries.append(summary)
            partition_count += 1
    require(partition_count == 29, "all 29 partitions in dimensions one through six")

    u = sp.Matrix([[1, 1], [0, 1]])
    a_repeated = sp.diag(u, Q * u)
    n_repeated = sp.zeros(4)
    n_repeated[2:4, 0:2] = sp.eye(2)
    repeated_minimal = minimal_polynomial(a_repeated)
    require(not repeated_minimal.gcd(repeated_minimal.diff()).is_one, "nonsemisimple A with nonzero N")

    rotation = sp.Matrix([[0, -1], [1, 0]])
    rotation_jordan = rotation.row_join(sp.eye(2)).col_join(sp.zeros(2).row_join(rotation))
    for block, name in [(rotation, "nonsplit-quadratic"), (rotation_jordan, "nonsplit-primary-square")]:
        a = sp.diag(block, Q * block)
        n = sp.zeros(2 * block.rows)
        n[block.rows:, :block.rows] = sp.eye(block.rows)
        summary, _, _ = check_pair(name, a, n)
        require(all(sp.Poly(c["factor"], T).degree() == 2 for c in summary["primary_components"]), name)
        summaries.append(summary)

    gap_summary, gap_p, _ = check_pair("missing-intermediate-eigenvalue", sp.diag(1, Q ** 2), sp.zeros(2))
    equal(gap_p, sp.eye(2), "path origins reset across a spectral gap")
    summaries.append(gap_summary)
    u2 = sp.eye(2)
    u2[1, 0] = 1
    u3 = sp.eye(3)
    u3[1, 0] = u3[2, 1] = 1
    a_unequal = sp.diag(u2, Q * u3)
    n_unequal = sp.zeros(5)
    n_unequal[3, 0] = n_unequal[4, 1] = 1
    summary, _, _ = check_pair("unequal-nonsemisimple-primary-multiplicities", a_unequal, n_unequal)
    summaries.append(summary)

    a_regular, n_regular = partition_pair((4,))
    a_zero = sp.eye(4)
    a_zero[0, 1] = 1
    n_zero = sp.zeros(4)
    a_denominator = sp.diag(sp.Matrix([[1, 1], [0, Q]]), sp.eye(2))
    n_denominator = sp.zeros(4)
    n_denominator[:2, :2] = sp.Matrix([[Q - 1, -1], [(Q - 1) ** 2, -(Q - 1)]])
    common_pairs = [
        ("common-regular", a_regular, n_regular),
        ("common-nonsemisimple-2+2", a_repeated, n_repeated),
        ("common-zero-with-nonsemisimple-A", a_zero, n_zero),
        ("common-nonintegral-primary-projector", a_denominator, n_denominator),
    ]
    common = []
    conjugators = []
    reductions = 0
    for name, a, n in common_pairs:
        summary, p, projectors = check_pair(name, a, n, include_matrices=True)
        for matrix in [a, a.inv(), p, p.inv(), exponential(n), exponential(n, -1)]:
            require(integral(matrix), f"{name}: GL_4(Z_5) membership")
        equal(p * a, a * p, f"{name}: arithmetic square")
        inertia = exponential(n)
        for level in range(1, 4):
            modulus = ELL ** level
            equal(
                reduce_matrix(p * exponential(n, -E) * p.inv(), modulus),
                reduce_matrix(inertia, modulus),
                f"{name}: stage-{level} balanced gluing",
            )
            equal(
                reduce_matrix(exponential(n, ELL ** level), modulus),
                sp.eye(4),
                f"{name}: common root index kills inertia",
            )
            if level > 1:
                equal(
                    reduce_matrix(reduce_matrix(p, modulus), ELL ** (level - 1)),
                    reduce_matrix(p, ELL ** (level - 1)),
                    f"{name}: quotient transition",
                )
            reductions += 1
        if name == "common-nonintegral-primary-projector":
            require(any(not integral(x) for x in projectors.values()), "denominator fixture is not vacuous")
            bad_p = cocharacter(projectors, -sp.Rational(1, 2))
            require(not integral(bad_p), "an arbitrary prime-to-l degree must fail the fixed-lattice test")
            require(valuation(bad_p.det(), ELL) == 0, "bad conjugator cannot be repaired by projective rescaling")
        if n != sp.zeros(4):
            require(E * p * n * p.inv() != n, "wrong boundary sign must be detected")
        common.append(summary)
        conjugators.append(p)
    require(conjugators[0] * conjugators[3] != conjugators[3] * conjugators[0], "independent node maps need not commute")

    n0 = sp.Matrix([[0, 0], [1, 0]])
    b0 = sp.Matrix([[0, 1], [1, 0]])
    return0 = sp.diag(1, Q ** 2)
    b1 = return0 * b0.inv()
    n1 = b0 * n0 * b0.inv() / Q
    return1 = b0 * b1
    equal(b0 * n0 * b0.inv(), Q * n1, "orbit first arithmetic transport")
    equal(b1 * n1 * b1.inv(), Q * n0, "orbit second arithmetic transport")
    orbit0, p0, _ = check_pair("orbit-return-0", return0, n0, Q ** 2, include_matrices=True)
    orbit1, p1, _ = check_pair("orbit-return-1", return1, n1, Q ** 2, include_matrices=True)
    equal(p1 * b0, b0 * p0, "permuted-node first square")
    equal(p0 * b1, b1 * p1, "permuted-node second square")
    require(p0 * b0 != b0 * p0, "commuting with each transport is not the orbit condition")
    for matrix in [b0, b1, p0, p1]:
        require(integral(matrix) and integral(matrix.inv()), "orbit compactness")

    x = sp.Symbol("x")
    simple_zeros = x * (x - 1) * (x - 2)
    function = sp.expand(simple_zeros * (3 * x ** 2 - 6 * x + 1) / 2)
    for point in (0, 1, 2):
        require(function.subs(x, point) == 0, "simultaneous marked zero")
        require(sp.diff(function, x).subs(x, point) == 1, "prescribed first jet")
    require(sp.degree(function, x) == 5 and 5 > -2 + 2 * 3, "strict Riemann-Roch jet threshold")
    jacobian = replay_jacobian()
    return {
        "claim": "C_ABG",
        "result_class": "theorem_candidate_with_finite_exact_regression",
        "universal_proof": "theorem.md",
        "statement_fidelity": "statement_fidelity.md",
        "formal_kernel_certificate": False,
        "independent_review": "required_not_yet_performed",
        "novelty_status": "unverified",
        "significance_status": "unreviewed",
        "campaign_complete": False,
        "scope": "Exact finite rational/polynomial evidence supporting, not replacing, the universal written proof.",
        "parameters": {"q": int(Q), "l": ELL, "common_e": E, "v_l_minus_one_over_e_minus_one": 2},
        "partition_count": partition_count,
        "partition_basis_cases": 2 * partition_count,
        "additional_primary_cases": len(summaries) - 2 * partition_count,
        "primary_cases": summaries,
        "simultaneous_compact_boundary_cases": common,
        "finite_stage_checks": reductions,
        "independent_node_maps_need_not_commute": True,
        "frobenius_orbit": {"length": 2, "B_0": matrix_data(b0), "B_1": matrix_data(b1), "returns": [orbit0, orbit1]},
        "jet_example": {"genus": 0, "marked_points": [0, 1, 2], "function": str(function), "pole_degree": 5, "all_first_jets": 1},
        "negative_controls": [
            "nonsemisimple Frobenius with nonzero nilpotent",
            "wrong branch sign fails",
            "prime-to-l degree 2 fails the chosen compact lattice",
            "permuted-node transport need not commute with the individual conjugator",
        ],
        "jacobian": jacobian,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = run_checks()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        require(certificate == expected, "stored certificate differs from exact replay")
    print(json.dumps({
        "ok": True,
        "claim": certificate["claim"],
        "partition_basis_cases": certificate["partition_basis_cases"],
        "additional_primary_cases": certificate["additional_primary_cases"],
        "simultaneous_boundaries": len(certificate["simultaneous_compact_boundary_cases"]),
        "finite_stage_checks": certificate["finite_stage_checks"],
        "jacobian_independent_replay": True,
        "universal_theorem_mechanically_proved": False,
        "independent_review": certificate["independent_review"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
