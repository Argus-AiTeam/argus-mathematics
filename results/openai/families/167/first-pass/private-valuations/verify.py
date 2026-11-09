#!/usr/bin/env python3
"""Replay exact algebra; the universal geometric proof is in report.md."""

import argparse
import copy
import json
import sys
from pathlib import Path

import sympy as sp


CASES = (
    "left_plane",
    "curve_different_loci",
    "same_curve_projection_degree_at_least_two",
    "same_line",
    "same_fractional_curve",
)
FIELD = {
    "base": "B_0",
    "coefficient": "K_0",
    "valuation_field": "K_0(V_1)",
    "genericity": "joint_over_B_0",
    "surviving_point": "generic_over_K_0",
    "k_0_adjoined": False,
}


class VerificationFailure(ValueError):
    pass


class InvalidHypothesis(VerificationFailure):
    pass


def require(condition, message):
    if not condition:
        raise VerificationFailure(message)


def equal(left, right, message):
    require(sp.cancel(left - right) == 0, message)


def nonzero(value, message):
    if sp.cancel(value) == 0:
        raise InvalidHypothesis(message)


def order_at_zero(expression, variable):
    numerator, denominator = sp.cancel(expression).as_numer_denom()
    nonzero(numerator, "The order of the zero rational function is not finite.")
    nonzero(denominator, "A rational-function denominator is zero.")

    def polynomial_order(polynomial):
        return min(monomial[0] for monomial, _ in sp.Poly(polynomial, variable).terms())

    return polynomial_order(numerator) - polynomial_order(denominator)


def validate_scope(certificate):
    require(certificate["schema"] == "private-valuations-exact-v1", "Wrong certificate schema.")
    require(certificate["claim"] == "C167_PV_AUDIT", "Wrong scoped theorem.")
    require(certificate["field"] == FIELD, "The coefficient-field or genericity setup changed.")
    require(tuple(certificate["locus_cases"]) == CASES, "A locus case was changed or omitted.")
    require(certificate["distance_threshold"] == 4, "The manuscript threshold is exactly four.")
    require(certificate["campaign_complete"] is False, "This is not campaign completion.")
    require(certificate["novelty_claimed"] is False, "No novelty is certified here.")


def plane_hypotheses(a0, c0, a1, c1):
    if sp.cancel(a0 - a1) == 0 and sp.cancel(c0 - c1) == 0:
        raise InvalidHypothesis("Plane prime centers must be distinct.")


def line_hypotheses(e):
    nonzero(e, "A line must have nonconstant ordinate projection.")


def sheet_hypotheses(fw, ordinate_difference, other_radicand):
    nonzero(fw, "The sheet point must have f_w nonzero.")
    nonzero(ordinate_difference, "The selected sheet ordinate must differ from its anchor.")
    nonzero(other_radicand, "The sheet point must be private.")


def fractional_hypotheses(b):
    nonzero(b, "Parameter b=0 is a reducible curve, outside the hypotheses.")
    nonzero(b - 1, "The exact common unit circle is explicitly excluded.")


def validate_private_orders(data):
    require(data["j"] == 5, "The manuscript grid has five columns.")
    matrix = data["matrix"]
    require(
        matrix == [[int(i == j) for j in range(5)] for i in range(5)],
        "Orders must be one on the diagonal and zero off it.",
    )
    for mask in range(1, 1 << 5):
        selected = [j for j in range(5) if mask & (1 << j)]
        for i in selected:
            require(sum(matrix[i][j] for j in selected) == 1, "A product has no private odd order.")
    require(data["nonempty_products"] == 31, "All 31 nonempty products must be covered.")


def symbolic_algebra(certificate):
    z, w, a0, a1, c0, c1, s, q, T = sp.symbols("z w a0 a1 c0 c1 s q T")
    e, ep, b, u, v, rho, cc = sp.symbols("e ep b u v rho cc")
    A0, C0, D0, E0 = sp.symbols("A0 C0 D0 E0")
    x, y = sp.symbols("x y")
    identities = 0

    def identity(left, right, name):
        nonlocal identities
        equal(left, right, name)
        identities += 1

    L0 = (z - a0) * (w - c0)
    L1 = (z - a1) * (w - c1)
    prime_substitution = c0 + 4 / (z - a0)
    identity(
        (z - a0) * (L1.subs(w, prime_substitution) - 4),
        (c0 - c1) * (z - a1) * (z - a0) + 4 * (a0 - a1),
        "Plane private-prime restriction has the wrong sign.",
    )
    plane_hypotheses(a0, c0, a1, c1)
    plane0 = (L0 * (L0 - 4)).subs(w, prime_substitution + T)
    plane1 = (L1 * (L1 - 4)).subs(w, prime_substitution + T)
    orders = {"left_plane": [order_at_zero(plane0, T), order_at_zero(plane1, T)]}
    for substitutions in ({c1: c0}, {a1: a0}):
        require(order_at_zero(plane1.subs(substitutions), T) == 0, "A distinct-center boundary failed.")

    local0 = T * (s - c0 + T * q)
    local1 = (a0 + T - a1) * (s + T * q - c1)
    sheet_hypotheses(sp.Symbol("fw"), s - c0, (a0 - a1) * (s - c1) * ((a0 - a1) * (s - c1) - 4))
    identity(sp.diff(local0 * (local0 - 4), T).subs(T, 0), -4 * (s - c0), "Wrong sheet leading term.")
    sheet_orders = [order_at_zero(local0 * (local0 - 4), T), order_at_zero(local1 * (local1 - 4), T)]
    orders["curve_different_loci"] = sheet_orders
    orders["same_curve_projection_degree_at_least_two"] = sheet_orders
    anchor_test = (x - a0) * (y - s) - 4
    require(sp.Poly(anchor_test, x, y).coeff_monomial(y) == -a0, "Center recovery failed.")
    identities += 1

    f = A0 * z * w + C0 * z + D0 * w + E0
    identity((A0 * z + D0) * (A0 * w + C0) + A0 * E0 - C0 * D0, A0 * f, "Bidegree-one classification identity failed.")
    identity(((z - a0) * (w - (e * a0 + ep))).subs(w, e * z + ep), e * (z - a0) ** 2, "Line distance failed.")
    line_hypotheses(e)
    line0 = (e * (z - a0) ** 2).subs({e: 4 / cc**2, z: a0 + cc + T})
    line1 = (e * (z - a1) ** 2).subs({e: 4 / cc**2, z: a0 + cc + T})
    orders["same_line"] = [
        order_at_zero(line0 * (line0 - 4), T),
        order_at_zero(line1 * (line1 - 4), T),
    ]

    fractional_hypotheses(b)
    distance = (z - a0) * (b / (z - u) - b / (a0 - u))
    identity(distance, -b * (z - a0) ** 2 / ((z - u) * (a0 - u)), "Fractional distance sign failed.")
    identity(distance.subs(z, u + (a0 - u) * x), -b * (x - 1) ** 2 / x, "Fractional normalized distance failed.")
    g = b * x**2 + (4 - 2 * b) * x + b
    identity(sp.discriminant(g, x), 16 * (1 - b), "Fractional discriminant failed.")
    identity(sp.diff(g, x) ** 2 - 4 * b * g, 16 * (1 - b), "Simple-root Bezout identity failed.")
    require(g.subs(x, 0) == b and sp.expand(g.subs(x, 1)) == 4, "A forbidden zero or unit root was lost.")
    identities += 1
    require(
        certificate["fractional_quadratic"] == {
            "coefficients_descending": ["b", "4-2*b", "b"],
            "discriminant_coefficients_ascending": [16, -16],
            "root_parameterization": "b=-4*rho/(rho-1)^2",
            "excluded_root_parameters": [0, 1, -1],
        },
        "The fractional root certificate was changed.",
    )
    root_b = -4 * rho / (rho - 1) ** 2
    identity(g.subs({x: rho, b: root_b}), 0, "Root parameterization failed.")
    identity((b - 1).subs(b, root_b), -(rho + 1) ** 2 / (rho - 1) ** 2, "Unit-circle root exclusion failed.")
    identity(sp.diff(g, x).subs({x: rho, b: root_b}), -4 * (rho + 1) / (rho - 1), "Root derivative failed.")
    zT = u + (a0 - u) * (rho + T)
    fractional0 = distance.subs({z: zT, b: root_b})
    fractional1 = (-b * (z - a1) ** 2 / ((z - u) * (a1 - u))).subs({z: zT, b: root_b})
    orders["same_fractional_curve"] = [
        order_at_zero(fractional0 * (fractional0 - 4), T),
        order_at_zero(fractional1 * (fractional1 - 4), T),
    ]
    other_test = -b * (s - x) ** 2 - 4 * (s - u) * (x - u)
    require(sp.Poly(other_test, x).degree() == 2 and sp.Poly(other_test, x).LC() == -b, "The other-anchor test is nonconstant only under the stated hypotheses.")
    identities += 1
    Lunit = -(x - 1) ** 2 / x
    identity(Lunit * (Lunit - 4), ((x**2 - 1) / x) ** 2, "Excluded unit-circle square identity failed.")

    lam = sp.Symbol("lam")
    Llambda = 2 - lam - 1 / lam
    identity((1 / lam - lam) ** 2, Llambda * (Llambda - 4), "Radicand identity failed.")
    identity(lam * sp.diff(Llambda, lam), 1 / lam - lam, "Logarithmic derivative sign failed.")

    av = sp.symbols("av0:3")
    bv = sp.symbols("bv0:3")
    rv = sp.symbols("rv0:3")
    X, Y, Z = sp.symbols("X Y Z")
    minors = (
        av[1] * bv[2] - av[2] * bv[1],
        av[2] * bv[0] - av[0] * bv[2],
        av[0] * bv[1] - av[1] * bv[0],
    )
    delta = sum(minors[i] * rv[i] for i in range(3))
    matrix = sp.Matrix([[av[i], bv[i], -rv[i]] for i in range(3)])
    identity(matrix.det(), -delta, "Three-row determinant sign failed.")
    eqs = [av[i] * X + bv[i] * Y - rv[i] * Z for i in range(3)]
    weights_x = (bv[1] * rv[2] - bv[2] * rv[1], bv[2] * rv[0] - bv[0] * rv[2], bv[0] * rv[1] - bv[1] * rv[0])
    weights_y = (av[2] * rv[1] - av[1] * rv[2], av[0] * rv[2] - av[2] * rv[0], av[1] * rv[0] - av[0] * rv[1])
    identity(sum(weights_x[i] * eqs[i] for i in range(3)), delta * X, "Three-row x elimination failed.")
    identity(sum(weights_y[i] * eqs[i] for i in range(3)), delta * Y, "Three-row y elimination failed.")
    identity(-sum(minors[i] * eqs[i] for i in range(3)), delta * Z, "Three-row scalar elimination failed.")
    delta2 = av[1] * rv[0] - av[0] * rv[1]
    eq2 = [av[i] * X - rv[i] * Z for i in range(2)]
    identity(-rv[1] * eq2[0] + rv[0] * eq2[1], delta2 * X, "Two-row x elimination failed.")
    identity(-av[1] * eq2[0] + av[0] * eq2[1], delta2 * Z, "Two-row scalar elimination failed.")
    Q, R, AA, tt = sp.symbols("Q R AA tt")
    identity((Q + R * (AA - tt)) - (Q - R * (AA - tt)), 2 * R * (AA - tt), "Unused-sign subtraction failed.")

    t = sp.Symbol("t")
    require(order_at_zero(t, t) == 1 and order_at_zero(t.subs(t, s**2), s) == 2, "The smaller-field warning was not reproduced.")
    identities += 1
    require(orders == certificate["local_order_normal_forms"], "A local order is not the certified private pair [1,0].")
    require(all(pair == [1, 0] for pair in orders.values()), "A private-order normal form failed.")
    return identities, orders


def replay_jacobian(certificate, directory):
    meta = certificate["jacobian"]
    require(meta["adapter_exit_code"] == 0 and meta["adapter_error"] is None and meta["adapter_timeout"] is False, "The adapter did not complete successfully.")
    payload = json.loads((directory / meta["payload"]).read_text())
    output = json.loads((directory / meta["typed_output"]).read_text())
    require(output["server"]["version"] == meta["server_version"], "Jacobian version changed.")
    require(output["protocol_version"] == meta["protocol_version"], "Jacobian protocol changed.")
    require(output["request"]["operation_id"] == meta["operation_id"], "Wrong Jacobian operation.")
    require(output["request"]["payload"] == payload, "Jacobian result is not bound to the exact payload.")
    result = output["result"]["output"]
    require(result["status"] == "FACTORIZED" and result["product_reconstruction"] == "EXACT", "A nonconclusion cannot certify factorization.")

    def polynomial(data):
        variables = sp.symbols(" ".join(data["variables"]))
        return sum(
            sp.Rational(int(term["coefficient"]["num"]), int(term["coefficient"]["den"]))
            * sp.prod(variable**power for variable, power in zip(variables, term["exponents"], strict=True))
            for term in data["polynomial"]["terms"]
        )

    source = polynomial(payload["polynomial"])
    x, y = sp.symbols("x y")
    equal(source, x * y * (x * y - 4), "The bounded adapter problem is not the translated radicand.")
    coefficient = sp.Rational(int(result["coefficient"]["num"]), int(result["coefficient"]["den"]))
    reconstructed = coefficient
    for item in result["factors"]:
        factor = polynomial(item["factor"])
        require(sp.Poly(factor, x, y, domain=sp.QQ).is_irreducible is True, "An adapter factor is reducible.")
        require(item["multiplicity"] == 1, "A translated plane factor is not simple.")
        reconstructed *= factor
    equal(reconstructed, source, "Adapter factors do not reconstruct the input.")
    equal(polynomial(result["reconstructed"]), source, "Adapter reconstructed polynomial differs from its source.")


def rejection_tests(certificate):
    def bad_matrix():
        bad = copy.deepcopy(certificate["private_orders"])
        bad["matrix"][0][1] = 1
        validate_private_orders(bad)

    def missing_case():
        bad = copy.deepcopy(certificate)
        bad["locus_cases"].pop()
        validate_scope(bad)

    def changed_field():
        bad = copy.deepcopy(certificate)
        bad["field"]["valuation_field"] = "B_0(V_1)"
        validate_scope(bad)

    tests = {
        "duplicate_plane_centers": lambda: plane_hypotheses(0, 0, 0, 0),
        "zero_line_slope": lambda: line_hypotheses(0),
        "zero_sheet_derivative": lambda: sheet_hypotheses(0, 1, 1),
        "anchor_equal_to_sheet_ordinate": lambda: sheet_hypotheses(1, 0, 1),
        "other_radicand_zero_at_sheet": lambda: sheet_hypotheses(1, 1, 0),
        "fractional_b_zero": lambda: fractional_hypotheses(0),
        "fractional_b_one": lambda: fractional_hypotheses(1),
        "nonprivate_order_matrix": bad_matrix,
        "missing_locus_case": missing_case,
        "changed_coefficient_field": changed_field,
    }
    require(set(tests) == set(certificate["invalid_hypothesis_tests"]), "A rejection test was omitted.")
    for name, run in tests.items():
        try:
            run()
        except VerificationFailure:
            continue
        raise VerificationFailure(f"Invalid hypotheses were accepted: {name}")
    return len(tests)


def verify(certificate, directory):
    validate_scope(certificate)
    validate_private_orders(certificate["private_orders"])
    identities, orders = symbolic_algebra(certificate)
    radical = certificate["radical_field"]
    require(radical["degree"] == 2**5, "The degree must be 32, conditional on the proved Kummer step.")
    require(radical["unused_column_rank_two"] == 4 and radical["unused_column_rank_one"] == 3, "The unused columns changed.")
    characters = [tuple(-1 if mask & (1 << i) else 1 for i in range(5)) for mask in range(32)]
    require(len(set(characters)) == 32, "Squarefree monomials have distinct sign characters.")
    replay_jacobian(certificate, directory)
    rejected = rejection_tests(certificate)
    return {
        "status": "verified_exact_algebra",
        "claim": certificate["claim"],
        "symbolic_identities": identities,
        "local_order_normal_forms": orders,
        "nonempty_products": 31,
        "rejected_invalid_hypotheses": rejected,
        "universal_geometric_proof": "report.md, not a finite computation",
        "formal_claim": "C167_PV_CORE, separately compiled",
        "campaign_complete": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=Path(__file__).with_name("exact_certificate.json"))
    args = parser.parse_args()
    try:
        certificate = json.loads(args.certificate.read_text())
        result = verify(certificate, args.certificate.resolve().parent)
    except (VerificationFailure, OSError, json.JSONDecodeError) as error:
        print(json.dumps({"status": "rejected", "error": str(error)}), file=sys.stderr)
        return 1
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    sys.exit(main())
