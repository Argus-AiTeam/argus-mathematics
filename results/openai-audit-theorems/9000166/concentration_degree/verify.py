#!/usr/bin/env python3
"""Replay exact algebra used in report.md; no sampling or geometric oracle."""

import argparse
import json
from math import comb
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def require(condition, label):
    if not condition:
        raise AssertionError(label)


def zero(expression, label):
    require(sp.expand(expression) == 0, label)


def coefficient(p, u):
    return sum(comb(p, k) * (-2) ** (u - k) for k in range(min(p, u) + 1))


def check_segre():
    a, ell, z = sp.symbols("a ell z")
    zero((1 + z) ** 2 - (1 + 2 * z) - z**2, "universal recurrence identity")
    require(coefficient(1, 1) == -1, "out-of-range positivity must not be assumed")
    recurrence_cases = 0
    for p in range(33):
        require(coefficient(p, 0) == 1, "constant coefficient")
        require(coefficient(p, 1) == p - 2, "linear coefficient")
        for u in range(31):
            require(
                coefficient(p + 2, u + 2) == comb(p, u + 2) + coefficient(p, u),
                "two-step coefficient recurrence",
            )
            recurrence_cases += 1
    segre_cases = 0
    for e in range(3, 13):
        for h in range(1, e - 1):
            direct = sum(
                comb(e, k) * a**k * (-2 * a) ** (h - q - k) * (ell - a) ** q
                for q in range(h + 1)
                for k in range(h - q + 1)
            )
            positive = sum(
                coefficient(e - 1 - i, h - i) * ell**i * a ** (h - i)
                for i in range(h + 1)
            )
            zero(direct - positive, "line-convention Segre coefficient")
            require(
                all(coefficient(e - 1 - i, h - i) >= 0 for i in range(h + 1)),
                "positive expansion in the stated range",
            )
            require(coefficient(e - 1 - h, 0) == 1, "leading ell coefficient")
            segre_cases += 1
    return {
        "recurrence_cases": recurrence_cases,
        "recurrence_range": {"p": [0, 32], "u": [0, 30]},
        "segre_cases": segre_cases,
        "segre_range": {"e": [3, 12], "h": "1..e-2"},
        "outside_range_c_1_1": -1,
        "universal_proof": "report.md Section 2; Lean proves recurrence-to-positivity",
    }


def kernel_basis(v):
    e = len(v)
    result = []
    for i in range(1, e):
        for j in range(i + 1, e):
            left = sp.eye(e)[:, i] - v[i] * sp.eye(e)[:, 0]
            right = sp.eye(e)[:, j] - v[j] * sp.eye(e)[:, 0]
            result.append(left * right.T - right * left.T)
    return result


def check_kernel_and_tests():
    tau = sp.Symbol("tau")
    cases = 0
    maximum_test_degree = 0
    for e in range(3, 8):
        coordinates = sp.symbols(f"v1:{e}")
        v = sp.Matrix([1, *coordinates])
        basis = kernel_basis(v)
        require(len(basis) == comb(e - 1, 2), "kernel dimension")
        pairs = [(i, j) for i in range(1, e) for j in range(i + 1, e)]
        for index, matrix in enumerate(basis):
            require(matrix.T == -matrix, "alternating kernel form")
            require((matrix * v).applyfunc(sp.expand) == sp.zeros(e, 1), "K_v evaluation")
            require(
                all(sp.Poly(entry, *coordinates).total_degree() <= 1 for entry in matrix),
                "kernel basis is affine, not genuinely quadratic",
            )
            require(
                [matrix[i, j] for i, j in pairs]
                == [int(index == other) for other in range(len(pairs))],
                "independent kernel basis",
            )
            cases += 1
        b = sp.symbols(f"b1:{e}")
        a = sp.symbols(f"a1:{e}")
        v_line = sp.Matrix([1, *(b[i] + tau * a[i] for i in range(e - 1))])
        n = comb(e, 2)
        db = sp.symbols(f"db0:{n}")
        da = sp.symbols(f"da0:{n}")
        upper = [(i, j) for i in range(e) for j in range(i + 1, e)]
        for matrix in kernel_basis(v_line):
            test = sum(
                matrix[i, j] * (db[m] + tau * da[m])
                for m, (i, j) in enumerate(upper)
            )
            degree = sp.Poly(sp.expand(test), tau).degree()
            require(degree <= 2, "first tangency tests have degree at most two")
            maximum_test_degree = max(maximum_test_degree, int(degree))
    return {
        "e_range": [3, 7],
        "kernel_basis_vectors": cases,
        "maximum_first_test_degree": maximum_test_degree,
        "general_argument": "Every entry of B(v) is affine; differentiating b+tau*a adds one factor.",
    }


def pair(matrix, i, j, value=1):
    matrix[i, j] = value
    matrix[j, i] = -value


def check_skew_pencil():
    restriction_cases = 0
    for p in range(1, 9):
        for q in range(p):
            ambient = 2 * p - q
            matrix = sp.zeros(ambient)
            common_even = q - q % 2
            for i in range(0, common_even, 2):
                pair(matrix, i, i + 1)
            if q % 2:
                pair(matrix, q - 1, p)
                pair(matrix, q, q - 1)
                start = 1
            else:
                start = 0
            for i in range(start, p - q):
                pair(matrix, q + i, p + i)
            rows = list(range(p))
            columns = list(range(q)) + list(range(p, ambient))
            restriction = matrix.extract(rows, columns)
            require(matrix.T == -matrix, "ambient skew extension")
            require(abs(restriction.det()) == 1, "invertible unequal-subspace restriction")
            restriction_cases += 1
    t = sp.Symbol("t")
    coefficient_cases = []
    for p in (1, 3, 5):
        c = sp.Matrix(p, p, sp.symbols(f"c0:{p*p}"))
        d = sp.zeros(p)
        for i in range(1, p, 2):
            pair(d, i, i + 1)
        determinant = (c - t * d).det(method="domain-ge")
        top = sp.Poly(determinant, t).coeff_monomial(t ** (p - 1))
        expected = c[0, 0] * d[1:, 1:].det()
        zero(top - expected, "odd-pencil diagonal detecting coefficient")
        coefficient_cases.append(p)
    return {
        "unequal_subspace_cases": restriction_cases,
        "p_range": [1, 8],
        "q_range": "0..p-1",
        "odd_coefficient_sizes": coefficient_cases,
        "general_proof": "report.md Section 3, for all dimensions, not inferred from these cases",
    }


def sparse_polynomial(item, variables):
    require(item["domain"] == "QQ", "Jacobian coefficient domain")
    require(item["variables"] == [str(v) for v in variables], "Jacobian authoritative ring")
    expression = 0
    for term in item["polynomial"]["terms"]:
        exponents = term["exponents"]
        require(len(exponents) == len(variables), "Jacobian monomial arity")
        require(all(isinstance(k, int) and k >= 0 for k in exponents), "Jacobian exponents")
        rational = term["coefficient"]
        require(int(rational["den"]) > 0, "positive rational denominator")
        expression += sp.Rational(rational["num"], rational["den"]) * sp.prod(
            v**power for v, power in zip(variables, exponents, strict=True)
        )
    return sp.expand(expression)


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    record = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "polynomial.ideal.elimination.compute"
    require(record["request"]["operation_id"] == operation, "Jacobian requested operation")
    require(record["request"]["payload"] == payload, "source-bound exact Jacobian payload")
    require(record["result"]["operation_id"] == operation, "Jacobian returned operation")
    output = record["result"]["output"]
    require(output["outcome"] == "COMPUTED", "Jacobian non-conclusions cannot support a claim")
    require(output["detail"] is None, "Jacobian operation detail")
    all_variables = sp.symbols(" ".join(payload["ideal"]["variables"]))
    input_polynomials = [
        sparse_polynomial(item, all_variables) for item in payload["ideal"]["generators"]
    ]
    full_basis = sp.groebner(input_polynomials, *all_variables, order="lex")
    s, t, a, b, c, d = all_variables
    eliminated = [
        polynomial.as_expr()
        for polynomial in full_basis.polys
        if not polynomial.as_expr().has(s, t)
    ]
    remaining = (a, b, c, d)
    require(output["eliminated_variables"] == ["s", "t"], "eliminated variables")
    require(
        output["elimination_ideal"]["variables"] == ["a", "b", "c", "d"],
        "elimination target ring",
    )
    returned = [
        sparse_polynomial(item, remaining)
        for item in output["elimination_ideal"]["generators"]
    ]
    expected = [a + c, b * d - c**2]
    expected_basis = sp.groebner(expected, *remaining, order="lex")
    for generators in (eliminated, returned):
        basis = sp.groebner(generators, *remaining, order="lex")
        require(all(basis.reduce(f)[1] == 0 for f in expected), "expected ideal inclusion")
        require(
            all(expected_basis.reduce(f)[1] == 0 for f in generators),
            "returned ideal inclusion",
        )
    return {
        "operation_id": operation,
        "server_version": record["server"]["version"],
        "protocol_version": record["protocol_version"],
        "transport": record["transport"],
        "adapter_status": "COMPUTED",
        "structured_error": None,
        "timeout": False,
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "independent_replay": "equal ideals over QQ by mutual Groebner reduction",
        "elimination_generators": ["a+c", "b*d-c^2"],
    }


def pfaffian(matrix):
    size = matrix.rows
    if size == 0:
        return sp.Integer(1)
    return sp.expand(
        sum(
            (-1) ** (j + 1)
            * matrix[0, j]
            * pfaffian(matrix.extract(
                [i for i in range(size) if i not in (0, j)],
                [i for i in range(size) if i not in (0, j)],
            ))
            for j in range(1, size)
        )
    )


def check_pfaffians():
    cases = []
    for size in (2, 4, 6):
        matrix = sp.zeros(size)
        variables = []
        for i in range(size):
            for j in range(i + 1, size):
                variable = sp.Symbol(f"z{i}{j}")
                variables.append(variable)
                pair(matrix, i, j, variable)
        pf = pfaffian(matrix)
        zero(matrix.det(method="domain-ge") - pf**2, "Pfaffian square identity")
        require(sp.Poly(pf, *variables).total_degree() == size // 2, "Pfaffian degree")
        canonical = sp.zeros(size)
        for i in range(2, size, 2):
            pair(canonical, i, i + 1)
        require(canonical.rank() == size - 2, "generic hypersurface corank model")
        substitution = {
            matrix[i, j]: canonical[i, j]
            for i in range(size)
            for j in range(i + 1, size)
        }
        require(sp.diff(pf, matrix[0, 1]).subs(substitution) == 1, "reduced smooth Pfaffian point")
        tau = sp.Symbol("tau")
        v = sp.Matrix([1, tau, *([0] * (size - 2))])
        basis = kernel_basis(v)
        weights = sp.symbols(f"w0:{len(basis)}")
        form = sum((weight * item for weight, item in zip(weights, basis)), sp.zeros(size))
        require((form * v).applyfunc(sp.expand) == sp.zeros(size, 1), "full kernel chart")
        zero(pfaffian(form), "every kernel-chart flat lies on the Pfaffian")
        cases.append({
            "size": size,
            "degree": size // 2,
            "generic_corank": 2,
            "det_equals_pf_squared": True,
            "entire_kernel_chart": True,
        })
    return cases


def check_sharp_example():
    x, y, z, t, u, a, b, c = sp.symbols("x y z t u a b c")
    matrix = sp.Matrix([[0, x, y], [-x, 0, z], [-y, -z, 0]])
    first = {x: t, y: u, z: t * u}
    second = {x: u, y: t, z: t * u}
    require(matrix.subs(first) * sp.Matrix([t, -1, 0]) == sp.Matrix([-t, -t**2, 0]), "first ruling evaluation")
    require(matrix.subs(second) * sp.Matrix([t, 0, 1]) == sp.Matrix([t, 0, -t**2]), "second ruling evaluation")
    zero((z - x * y).subs(first), "first entire affine ruling")
    zero((z - x * y).subs(second), "second entire affine ruling")
    line_identity = (x * y + t * c) - (x + t * a) * (y + t * b)
    zero(line_identity - t * (c - a * y - b * x) + t**2 * a * b, "all lines through every point")
    x0 = sp.Symbol("x0")
    projective_equation = x0 * z - x * y
    require(sp.hessian(projective_equation, (x0, x, y, z)).det() != 0, "smooth irreducible projective quadric")
    s = sp.Symbol("s")
    parameter = sp.Matrix([s * t, -s**2, 0, -s * t, -t**2, 0])
    zero((parameter[:3, 0].T * parameter[3:, 0])[0], "whole homogeneous parameter conic is isotropic")
    require(parameter.subs({s: 0, t: 1}) == sp.Matrix([0, 0, 0, 0, -1, 0]), "nonempty v=0 boundary")
    conic_b, conic_c, conic_d = sp.symbols("B C D")
    require(
        sp.hessian(conic_b * conic_d - conic_c**2, (conic_b, conic_c, conic_d)).det() != 0,
        "smooth irreducible plane conic",
    )
    return {
        "e": 3,
        "V": "z-x*y=0 in skew coordinates (z12,z13,z23)=(x,y,z)",
        "s0": 1,
        "h": 1,
        "j_per_ruling": 0,
        "degree_V": 2,
        "dominating_parameter_components": 2,
        "degree_each_parameter_component": 2,
        "sum_parameter_degrees": 4,
        "aggregate_ratio": 2,
        "boundary_of_first_component": "[0:0:0:0:-1:0]",
        "all_point_directions": "a*b=0 and c=a*y+b*x; exactly two projective directions",
    }


def certificate():
    return {
        "scope": "Exact algebraic replay supporting the general proofs in report.md; not a finite-test proof of the geometric proposition.",
        "target_claim": "C166_DEGREE",
        "geometric_proof": "report.md Sections 1-4",
        "strengthenings": "report.md Sections 5-6",
        "research_target_level": "publishable",
        "independent_review": "required; not supplied by this script",
        "novelty_status": "not_established",
        "segre": check_segre(),
        "kernel_and_quadratic_tests": check_kernel_and_tests(),
        "singular_skew_pencil": check_skew_pencil(),
        "jacobian": check_jacobian(),
        "pfaffian_examples": check_pfaffians(),
        "sharp_aggregate_example": check_sharp_example(),
        "formal_source": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "formal_scope": "Universal coefficient induction and universal symmetry/antisymmetry tensor theorem only; see real compiler certificates separately.",
        "refuted_manuscript_assertions": [],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(target.read_text()) == result, "persisted certificate does not match replay")
    print(json.dumps({
        "status": "PASS",
        "certificate": str(target.relative_to(HERE.parent.parent)),
        "segre_cases": result["segre"]["segre_cases"],
        "pencil_restriction_cases": result["singular_skew_pencil"]["unequal_subspace_cases"],
        "jacobian_status": result["jacobian"]["adapter_status"],
        "geometric_scope": "general proof in report; exact identities and examples in this replay",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
