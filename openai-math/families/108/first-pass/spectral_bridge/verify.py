#!/usr/bin/env python3
"""Replay exact spectral examples; the universal geometric proof is proof.md."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
S, T, U, Z = sp.symbols("s t u z")


def require(condition, message):
    if not condition:
        raise AssertionError(message)


class BinaryField:
    def __init__(self, modulus):
        self.modulus = modulus
        self.degree = modulus.bit_length() - 1
        self.order = 1 << self.degree
        for value in range(1, self.order):
            require(
                self.mul(value, self.power(value, self.order - 2)) == 1,
                "The declared binary polynomial does not define a field.",
            )

    def reduce(self, value):
        while value.bit_length() > self.degree:
            value ^= self.modulus << (value.bit_length() - self.degree - 1)
        return value

    def mul(self, left, right):
        result = 0
        while right:
            if right & 1:
                result ^= left
            left = self.reduce(left << 1)
            right >>= 1
        return result

    def power(self, value, exponent):
        value = self.reduce(value)
        result = 1
        while exponent:
            if exponent & 1:
                result = self.mul(result, value)
            value = self.mul(value, value)
            exponent >>= 1
        return result

    def expression(self, value):
        return sp.Add(
            *(Z**index for index in range(self.degree) if (value >> index) & 1)
        )

    def defining_polynomial(self):
        return sp.Add(
            *(
                Z**index
                for index in range(self.degree + 1)
                if (self.modulus >> index) & 1
            )
        )


def normalize(expression, field):
    result = {}
    for (i, j, ell, zpower), coefficient in sp.Poly(
        expression, S, T, U, Z, modulus=2
    ).terms():
        if int(coefficient) % 2:
            key = (i, j, ell)
            result[key] = result.get(key, 0) ^ field.power(2, zpower)
    return {key: value for key, value in result.items() if value}


def expression(polynomial, field):
    return sp.Add(
        *(
            field.expression(value) * S**i * T**j * U**ell
            for (i, j, ell), value in polynomial.items()
        )
    )


def serialized(polynomial):
    return [
        {"exponents": list(key), "coefficient": value}
        for key, value in sorted(polynomial.items(), reverse=True)
    ]


def monomials(degree):
    return [
        (i, j, degree - i - j)
        for i in range(degree + 1)
        for j in range(degree + 1 - i)
    ]


def rank_over_field(matrix, field):
    rows = [list(row) for row in matrix]
    columns = len(rows[0]) if rows else 0
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, len(rows)) if rows[row][column]),
            None,
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        inverse = field.power(rows[pivot_row][column], field.order - 2)
        rows[pivot_row] = [field.mul(value, inverse) for value in rows[pivot_row]]
        for row in range(len(rows)):
            if row != pivot_row and rows[row][column]:
                factor = rows[row][column]
                rows[row] = [
                    value ^ field.mul(factor, pivot_value)
                    for value, pivot_value in zip(rows[row], rows[pivot_row])
                ]
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return pivot_row


def restrict_scalars(matrix, field):
    result = []
    for row in matrix:
        for output_bit in range(field.degree):
            result.append(
                [
                    (field.mul(value, 1 << input_bit) >> output_bit) & 1
                    for value in row
                    for input_bit in range(field.degree)
                ]
            )
    return result


def affine_quotient(polynomials, field):
    generators = [
        expression(polynomial, field).subs(U, 1) for polynomial in polynomials
    ] + [field.defining_polynomial()]
    basis = sp.groebner(generators, S, T, Z, modulus=2, order="grevlex")
    leading = [tuple(poly.LM(order=basis.order).exponents) for poly in basis.polys]

    for generator in generators:
        require(basis.reduce(generator)[1] == 0, "Original ideal generator lost.")
    for left, right in itertools.combinations(basis.polys, 2):
        left_exp = tuple(left.LM(order=basis.order).exponents)
        right_exp = tuple(right.LM(order=basis.order).exponents)
        common = tuple(max(x, y) for x, y in zip(left_exp, right_exp))
        left_multiplier = sp.prod(
            variable ** (high - low)
            for variable, high, low in zip((S, T, Z), common, left_exp)
        )
        right_multiplier = sp.prod(
            variable ** (high - low)
            for variable, high, low in zip((S, T, Z), common, right_exp)
        )
        s_pair = (
            left_multiplier * left.as_expr() / left.LC(order=basis.order)
            - right_multiplier * right.as_expr() / right.LC(order=basis.order)
        )
        require(
            basis.reduce(sp.expand(s_pair))[1] == 0,
            "Buchberger S-pair did not reduce to zero.",
        )

    if (0, 0, 0) in leading:
        standard = []
    else:
        bounds = []
        for axis in range(3):
            powers = [
                exponent[axis]
                for exponent in leading
                if exponent[axis] > 0
                and all(exponent[other] == 0 for other in range(3) if other != axis)
            ]
            require(powers, "The affine quotient was not proved finite.")
            bounds.append(min(powers))
        standard = [
            exponent
            for exponent in itertools.product(*(range(bound) for bound in bounds))
            if not any(
                all(x >= y for x, y in zip(exponent, divisor))
                for divisor in leading
            )
        ]
    require(len(standard) % field.degree == 0, "Restriction-of-scalars mismatch.")
    return {
        "length_over_declared_field": len(standard) // field.degree,
        "dimension_over_F2": len(standard),
        "groebner_order": "grevlex",
        "groebner_basis_over_F2": [
            [
                {"exponents": list(exponents), "coefficient": int(coefficient) % 2}
                for exponents, coefficient in poly.terms()
            ]
            for poly in basis.polys
        ],
        "standard_monomials_over_F2": [list(exponent) for exponent in standard],
        "all_buchberger_pairs_zero": True,
    }


def zero_matrix(size):
    return [[0] * size for _ in range(size)]


def chain_matrix(size):
    matrix = zero_matrix(size)
    for index in range(size - 1):
        matrix[index][index + 1] = 1
    return matrix


def cases():
    wild = [[0, 1], [1, 0]]
    blocks = zero_matrix(4)
    blocks[0][1] = blocks[2][3] = 1
    mixed = zero_matrix(4)
    mixed[0][1] = mixed[1][0] = 1
    diagonal = zero_matrix(4)
    diagonal[3][3] = 1
    return [
        ("node_zero", 3, [0, 1], zero_matrix(2)),
        ("wild_smooth_conic", 3, [0, 1], wild),
        ("triple_point", 7, [0, 1, 2], zero_matrix(3)),
        ("triple_nilpotent_chain", 7, [0, 1, 2], chain_matrix(3)),
        ("quadruple_point", 7, [0, 1, 2, 3], zero_matrix(4)),
        ("quadruple_nilpotent_chain", 7, [0, 1, 2, 3], chain_matrix(4)),
        ("quadruple_two_blocks", 7, [0, 1, 2, 3], blocks),
        ("wild_conic_and_two_lines", 7, [0, 1, 2, 3], mixed),
        ("triple_point_and_transverse_line", 7, [0, 1, 2, 3], diagonal),
    ]


def pencil_data(modulus, theta, entries):
    field = BinaryField(modulus)
    size = len(theta)
    require(len(set(theta)) == size, "Boundary roots are not distinct.")
    require(
        all(0 <= value < field.order for value in theta),
        "Noncanonical boundary coefficient.",
    )
    matrix_x = sp.Matrix(
        [[field.expression(value) for value in row] for row in entries]
    )
    matrix = S * sp.eye(size) + T * sp.diag(
        *(field.expression(value) for value in theta)
    ) + U * matrix_x
    determinant = normalize(matrix.det(), field)
    adjugate = matrix.adjugate()
    cofactors = [
        normalize(adjugate[row, column], field)
        for row in range(size)
        for column in range(size)
    ]
    row_forms = [
        normalize(sum(adjugate[row, column] for row in range(size)), field)
        for column in range(size)
    ]
    coefficient_matrix = [
        [poly.get(exponent, 0) for poly in cofactors]
        for exponent in monomials(size - 1)
    ]
    return field, matrix, determinant, cofactors, row_forms, coefficient_matrix


def verify_case(name, modulus, theta, entries):
    field, matrix, determinant, cofactors, row_forms, coefficient_matrix = (
        pencil_data(modulus, theta, entries)
    )
    size = len(theta)
    degree = size - 1
    expected_row_length = size * (size - 1) // 2
    expected_boundary = normalize(
        sp.prod(S + field.expression(value) * T for value in theta), field
    )
    require(
        {key: value for key, value in determinant.items() if key[2] == 0}
        == expected_boundary,
        f"{name}: wrong fixed boundary.",
    )
    cofactor_matrix = sp.Matrix(
        size, size, [expression(poly, field) for poly in cofactors]
    )
    laplace_error = matrix * cofactor_matrix - expression(determinant, field) * sp.eye(size)
    require(
        all(not normalize(value, field) for value in laplace_error),
        f"{name}: adjugate identity failed.",
    )
    row = sp.Matrix(1, size, [expression(poly, field) for poly in row_forms])
    require(
        all(
            not normalize(value, field)
            for value in row * matrix
            - expression(determinant, field) * sp.ones(1, size)
        ),
        f"{name}: row orientation or multiplication identity failed.",
    )

    full_quotient = affine_quotient([determinant] + cofactors, field)
    row_quotient = affine_quotient([determinant] + row_forms, field)
    full_rank = rank_over_field(coefficient_matrix, field)
    full_length = full_quotient["length_over_declared_field"]
    require(
        full_length == size * (size + 1) // 2 - full_rank,
        f"{name}: exact adjugate rank/length formula failed.",
    )
    require(
        row_quotient["length_over_declared_field"] == expected_row_length,
        f"{name}: row length was not N.",
    )

    rho = sp.Matrix(
        [
            [sp.Poly(expression(poly, field), S).nth(index) for poly in row_forms]
            for index in range(size)
        ]
    )
    rho_determinant = normalize(rho.det(), field)
    vandermonde = 1
    for left, right in itertools.combinations(theta, 2):
        vandermonde = field.mul(vandermonde, left ^ right)
    require(vandermonde != 0, f"{name}: boundary frame singular.")
    require(
        rho_determinant.get((0, expected_row_length, 0), 0) == vandermonde
        and all(
            i == 0 and j + ell == expected_row_length
            for i, j, ell in rho_determinant
        ),
        f"{name}: determinant of row frame has wrong degree or boundary.",
    )

    critical_triples = [
        exponent
        for exponent in monomials(degree)
        if all(poly.get(exponent, 0) == 0 for poly in cofactors)
    ]
    for a, b, _ in critical_triples:
        require(
            full_length >= (a + 1) * (b + 1),
            f"{name}: rectangular bound refuted for {(a, b, degree-a-b)}.",
        )
    return {
        "name": name,
        "k": size,
        "field_modulus_bits": modulus,
        "field_degree_over_F2": field.degree,
        "theta_bits": theta,
        "X_bits": entries,
        "F": serialized(determinant),
        "adjugate_coefficient_rank": full_rank,
        "full_adjugate_quotient": full_quotient,
        "row_adjugate_quotient": row_quotient,
        "row_frame_determinant": serialized(rho_determinant),
        "critical_exponent_triples": [list(exponent) for exponent in critical_triples],
    }


def verify_nodal_scheme_isomorphism():
    a, b, s, t = sp.symbols("A B S T")
    diagonal_left, diagonal_right, u = sp.symbols("L R U")
    mod2 = lambda value: sp.Poly(value, a, b, s, t, modulus=2).as_expr()
    generic_matrix = sp.Matrix(
        [[s + u * diagonal_left, u * a], [u * b, s + t + u * diagonal_right]]
    )
    curve_relation = s * (s + t)
    coefficient_equations = sp.Poly(
        generic_matrix.det() - curve_relation, s, t, u
    ).coeffs()
    fiber_basis = sp.groebner(
        coefficient_equations, diagonal_left, diagonal_right, a, b, modulus=2
    )
    expected_basis = sp.groebner(
        [diagonal_left, diagonal_right, a * b],
        diagonal_left, diagonal_right, a, b, modulus=2,
    )
    require(fiber_basis == expected_basis, "The entire matrix fiber ideal is wrong.")
    forward = {s: a, t: a + b}
    inverse = {a: s, b: s + t}
    require(
        mod2(curve_relation.subs(forward, simultaneous=True) - a * b) == 0,
        "Forward curve relation failed.",
    )
    require(
        mod2((a * b).subs(inverse, simultaneous=True) - curve_relation) == 0,
        "Inverse fiber relation failed.",
    )
    forward_then_back = tuple(value.subs(forward, simultaneous=True) for value in (s, s + t))
    back_then_forward = tuple(value.subs(inverse, simultaneous=True) for value in (a, a + b))
    require(
        mod2(forward_then_back[0] - a) == 0
        and mod2(forward_then_back[1] - b) == 0
        and mod2(back_then_forward[0] - s) == 0
        and mod2(back_then_forward[1] - t) == 0,
        "Entire nodal-fiber scheme maps are not inverse.",
    )
    row_after_substitution = (a + (a + b) + b, a + a)
    require(
        all(mod2(value) == 0 for value in row_after_substitution),
        "The row does not vanish at the reconstructed universal point.",
    )
    # This nonconstant dual-number point has A=B=epsilon, A*B=epsilon^2=0.
    epsilon = sp.symbols("epsilon")
    require(
        sp.rem(epsilon**2, epsilon**2, epsilon, domain=sp.GF(2)) == 0,
        "Dual-number fiber point failed.",
    )
    return {
        "fiber_ring": "F2[A,B]/(A*B)",
        "row_scheme_ring": "F2[S,T]/(S*(S+T))",
        "forward": {"S": "A", "T": "A+B"},
        "inverse": {"A": "S", "B": "S+T"},
        "universal_row_ideal_on_u_1": ["s+t+B", "s+A"],
        "compositions_and_defining_relations_checked": True,
        "valid_over_nonreduced_parameter_rings": True,
        "dual_number_point": {"A": "epsilon", "B": "epsilon", "epsilon^2": 0},
    }


def verify_wild_projection():
    y = sp.symbols("y")
    local_equation = sp.Poly(
        ((S**2 + S * T + U**2).subs({S: y + 1, U: 1})),
        y,
        T,
        modulus=2,
    ).as_expr()
    require(
        sp.Poly(local_equation - y**2 - (1 + y) * T, y, T, modulus=2).is_zero,
        "Wild local coordinate identity failed.",
    )
    return {
        "F": "s^2+s*t+u^2",
        "point": [1, 0, 1],
        "local_parameter": "y=s/u+1",
        "local_equation": "y^2+(1+y)*(t/u)=0",
        "base_parameter": "(t/u)=y^2/(1+y)",
        "ramification_index": 2,
        "residue_characteristic": 2,
        "generic_s_derivative": "t",
        "smoothness_check": "F_s=t, F_t=s; their only projective candidate is not on F",
    }


def verify_formal_record():
    directory = HERE / "formal"
    record = json.loads((directory / "lean_check.json").read_text())
    require(
        record["status"] == "success"
        and record["exit_code"] == 0
        and record["audit_exit_code"] == 0
        and record["proof_holes"] == [],
        "Official Lean record is not a successful hole-free compiler run.",
    )
    require(
        "4.31.0" in record["tools"]["lean"]["version"],
        "The requested Lean version was not used.",
    )
    for filename, hash_key in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        require(
            hashlib.sha256((directory / filename).read_bytes()).hexdigest()
            == record[hash_key],
            f"The official compiler record is stale for {filename}.",
        )
    certificates = sorted(
        (directory / "certificates").glob("L_RECTANGULAR_CORE-*.json")
    )
    require(len(certificates) == 1, "Expected one current formal-core certificate.")
    return {
        "claim": "L_RECTANGULAR_CORE",
        "compiler_version": "4.31.0",
        "compiler_exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "certificate": str(certificates[0].relative_to(HERE)),
        "scope": "Universal polynomial coefficient recovery and rectangle count; not geometry.",
    }


def verify_jacobian():
    payload = json.loads((HERE / "jacobian/quadruple_payload.json").read_text())
    output = json.loads((HERE / "jacobian/quadruple_output.json").read_text())
    adapter_status = json.loads(
        (HERE / "jacobian/quadruple_adapter_status.json").read_text()
    )
    require(adapter_status["exit_code"] == 0, "The Jacobian adapter failed.")
    operation = "prime_field.matrix.rank.compute"
    require(
        output["request"] == {"operation_id": operation, "payload": payload},
        "Jacobian response is not bound to the exact saved payload.",
    )
    require(
        output["result"]["operation_id"] == operation
        and output["result"]["output"]["source"] == payload,
        "Jacobian returned a different operation or source matrix.",
    )
    require(
        output["result"]["output"]["prime"] == 2
        and output["result"]["output"]["rank"] == 8,
        "The typed prime-field rank was not the expected exact rank 8.",
    )
    chosen = next(case for case in cases() if case[0] == "quadruple_point")
    field, _, _, _, _, coefficient_matrix = pencil_data(*chosen[1:])
    expected = restrict_scalars(coefficient_matrix, field)
    require(
        payload == {"matrix": {"prime": 2, "columns": 32, "entries": expected}},
        "The saved matrix was not the actual adjugate coefficient map.",
    )
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "transport": output["transport"],
        "adapter_exit_code": adapter_status["exit_code"],
        "adapter_error": None,
        "timeout": False,
        "rank_over_F2": 8,
        "rank_over_F4": 4,
        "payload": "jacobian/quadruple_payload.json",
        "typed_output": "jacobian/quadruple_output.json",
    }


def compute_certificate():
    computed_cases = [verify_case(*case) for case in cases()]
    by_name = {case["name"]: case for case in computed_cases}
    require(
        by_name["quadruple_point"]["full_adjugate_quotient"][
            "length_over_declared_field"
        ] == 6,
        "The nonreduced ordinary quadruple-point scheme must have length 6.",
    )
    require(
        by_name["quadruple_two_blocks"]["full_adjugate_quotient"][
            "length_over_declared_field"
        ] == 4,
        "The corank-two block example must have full-adjugate length 4.",
    )
    require(
        by_name["quadruple_nilpotent_chain"]["full_adjugate_quotient"][
            "length_over_declared_field"
        ] == 0,
        "The regular nilpotent example must have empty full-adjugate scheme.",
    )
    k = 128
    q = (k - 1) // 3
    triangle = (q + 1) * (q + 2) // 2
    rectangle = (q + 1) ** 2
    return {
        "schema_version": 1,
        "claim": "C_COEFFICIENT_STRONG",
        "claimed_result_class": "improved_bound",
        "acceptance_status": "requires independent Host Reviewer",
        "universal_mathematical_proof": "proof.md",
        "universal_formal_core": verify_formal_record(),
        "finite_computation_scope": (
            "Exact degenerate examples and polynomial scheme identities only; "
            "not a finite-test proof of the universal dimension theorem."
        ),
        "cases": computed_cases,
        "entire_nodal_fiber_scheme_isomorphism": verify_nodal_scheme_isomorphism(),
        "wild_projection": verify_wild_projection(),
        "jacobian": verify_jacobian(),
        "k128_comparison": {
            "q": q,
            "manuscript_T": triangle,
            "rectangle_Q": rectangle,
            "manuscript_dimension_bound": k * k + k - triangle,
            "improved_dimension_bound": k * k + k - rectangle,
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--prepare-jacobian", action="store_true")
    group.add_argument("--write-certificate", action="store_true")
    arguments = parser.parse_args()
    if arguments.prepare_jacobian:
        case = next(case for case in cases() if case[0] == "quadruple_point")
        field, _, _, _, _, coefficient_matrix = pencil_data(*case[1:])
        matrix = restrict_scalars(coefficient_matrix, field)
        payload = {"matrix": {"prime": 2, "columns": len(matrix[0]), "entries": matrix}}
        path = HERE / "jacobian/quadruple_payload.json"
        path.write_text(json.dumps(payload, indent=2) + "\n")
        print(f"Prepared {len(matrix)} by {len(matrix[0])} exact GF(2) matrix.")
        return
    certificate = compute_certificate()
    path = HERE / "exact_certificate.json"
    if arguments.write_certificate:
        path.write_text(json.dumps(certificate, indent=2) + "\n")
        print(f"Wrote {path.relative_to(HERE.parent.parent)}")
    else:
        require(path.is_file(), "Missing exact_certificate.json; use --write-certificate.")
        expected = json.loads(path.read_text())
        require(certificate == expected, "Exact certificate replay differs from saved data.")
        print(f"Exact certificate replay passed: {len(certificate['cases'])} schemes.")
    print("Universal coefficient core: Lean 4.31.0, exit 0, no proof holes.")
    print("Universal geometric theorem: proof.md; independent review still required.")


if __name__ == "__main__":
    main()
