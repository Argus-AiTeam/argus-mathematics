#!/usr/bin/env python3
"""Exact identities for the marked I16 family; not a substitute for its proof."""

import argparse
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent
OPERATION = "polynomial.compute.resultant"
a, r, x, y, t, u, z = sp.symbols("a r x y t u z")
RELATION = r**2 + 6*r - 3
rp = -6-r
h = a+1/a
n = 6*a+(r-rp)/a
lam = a**2+a**-2-1
Q = rp*x**2*y+3*x**2-3*a*x+a*x*y**2-y**2+rp*y+n*x*y
FA = x*(x-a)*(x-1/a)
FB = y*(y-r)*(y-rp)
ALLOWED_ZEROS = sp.Poly(a*(a**2-1)*(a**4-a**2+1), a)
CHECKS = []


def reduced(expression):
    numerator, denominator = sp.cancel(expression).as_numer_denom()
    numerator = sp.rem(numerator, RELATION, r)
    denominator = sp.rem(denominator, RELATION, r)
    if denominator == 0:
        raise AssertionError("A denominator vanishes in the coefficient field")
    return sp.factor(numerator)/sp.factor(denominator)


def require_zero(expression, label):
    numerator = sp.cancel(expression).as_numer_denom()[0]
    remainder = sp.rem(numerator, RELATION, r)
    if remainder != 0:
        raise AssertionError(f"{label}: {sp.factor(remainder)}")
    CHECKS.append(label)


def nonzero_on_open(expression):
    norm = sp.cancel(reduced(expression*expression.subs(r, rp)))
    assert norm != 0 and not norm.has(r), norm
    for polynomial in norm.as_numer_denom():
        squarefree = sp.Poly(polynomial, a).sqf_part()
        assert ALLOWED_ZEROS.rem(squarefree).is_zero, squarefree
    return str(sp.factor(norm))


def quartic_invariants(polynomial, variable):
    p = sp.Poly(sp.expand(polynomial), variable)
    A, B, C, D, E = [p.nth(i) for i in (4, 3, 2, 1, 0)]
    I = reduced(12*A*E-3*B*D+C**2)
    J = reduced(72*A*C*E+9*B*C*D-27*A*D**2-27*B**2*E-2*C**3)
    return I, reduced((4*I**3-J**2)/27)


def geometry():
    selected = {(i, i) for i in range(4)}
    selected |= {((i+1) % 4, i) for i in range(4)}
    rows = (0, a, None, 1/a)
    columns = (0, r, None, rp)
    b, c = sp.symbols("b c")
    local_norms = {}
    for i, row in enumerate(rows):
        for j, column in enumerate(columns):
            local = sp.cancel(b**2*Q.subs(x, 1/b)) if row is None else Q.subs(x, row+b)
            local = sp.cancel(c**2*local.subs(y, 1/c)) if column is None else local.subs(y, column+c)
            value = local.subs({b: 0, c: 0})
            if (i, j) in selected:
                require_zero(value, f"selected node {i},{j}")
                local_norms[f"{i},{j}"] = [
                    nonzero_on_open(sp.diff(local, v).subs({b: 0, c: 0}))
                    for v in (b, c)
                ]
            else:
                nonzero_on_open(value)

    vertices = {f"R{i}" for i in range(4)} | {f"C{j}" for j in range(4)}
    vertices |= {f"E{i}{j}" for i in range(4) for j in range(4) if (i, j) not in selected}
    edges = []
    for i in range(4):
        for j in range(4):
            if (i, j) not in selected:
                edges += [(f"R{i}", f"E{i}{j}"), (f"C{j}", f"E{i}{j}")]
    assert len(vertices) == len(edges) == 16
    adjacency = {v: {w if v == q else q for q, w in edges if v in (q, w)}
                 for v in vertices}
    assert all(len(neighbors) == 2 for neighbors in adjacency.values())
    reached = {next(iter(vertices))}
    for _ in range(16):
        reached |= set.union(*(adjacency[v] for v in reached))
    assert reached == vertices

    require_zero(
        x**2*y**2*Q.subs({x: 1/x, y: -3/y}, simultaneous=True)+3*Q,
        "pencil base action s maps to -s",
    )
    A = a*x-1
    B = rp*(x**2+1)+n*x
    C = 3*x*(x-a)
    f = (rp*t+n)**2-12*a*(t-h)
    require_zero(Q-A*y**2-B*y-C, "quadratic presentation of Q")
    nonzero_on_open(C.subs(x, 1/a))
    require_zero(B**2-4*A*C-x**2*f.subs(t, x+1/x), "reciprocal quartic")
    require_zero(sp.discriminant(f, t)-144, "quadratic discriminant is 144")
    IQ, deltaQ = quartic_invariants(B**2-4*A*C, x)
    IR, deltaR = quartic_invariants((t**2-4)*f, t)
    require_zero(IQ-144*(16*lam**2-16*lam+1), "Q binary quartic invariant")
    require_zero(deltaQ-2**16*3**6*lam*(lam-1), "Q discriminant factorization")
    require_zero(IR-2304*(lam**2-lam+1), "R binary quartic invariant")
    require_zero(deltaR-2**24*3**6*lam**2*(lam-1)**2, "R discriminant factorization")
    nonzero_on_open(f.subs(t, 2))
    nonzero_on_open(f.subs(t, -2))

    W = 2*A*y+B
    require_zero(
        x**2*y*(W.subs({x: 1/x, y: -3/y}, simultaneous=True)+W/x**2)-2*Q,
        "actual involution on Q",
    )
    tx, uy, dx, ey = x+1/x, y-3/y, x-1/x, y+3/y
    K = tx*uy-2*rp*tx-2*a*uy-2*n
    require_zero(K-dx*ey+2*Q/(x*y), "actual invariant field relation")
    require_zero(FA*FB/(x*y)**2-(tx-h)*(uy+6), "actual Kummer cover square")
    return {
        "selected_nodes": sorted(selected),
        "local_partial_derivative_norms": local_norms,
        "I16_vertices_and_edges": [len(vertices), len(edges)],
        "Q_discriminant": "2^16*3^6*lambda*(lambda-1)",
        "R_discriminant": "2^24*3^6*lambda^2*(lambda-1)^2",
    }


def marked_quotient():
    f = (rp*t+n)**2-12*a*(t-h)
    Rpoly = (t**2-4)*f
    g = (t-2*a)*(rp*t+n)-12*a*(t-h)
    em = reduced(n*r/3+sp.Rational(2, 3)*(a-1)*r**2)
    ep = reduced(n*r/3+sp.Rational(2, 3)*(a+1)*r**2)
    k = reduced((ep-2)*rp**2/12)
    zz = k*(t-em)/(t-2)
    for value in (k, k-1, k-lam, 2-em):
        nonzero_on_open(value)
    require_zero(ep-em-12/rp**2, "ordered roots of f")
    require_zero(f-rp**2*(t-em)*(t-ep), "split quadratic f")
    require_zero(zz.subs(t, -2)-lam, "ordered Legendre cross ratio")
    require_zero(g-4*(r+3)*(t-h)-rp*(t+2)*(t-em), "marked negative factor")
    require_zero(g+4*(r+3)*(t-h)-rp*(t-2)*(t-ep), "marked positive factor")
    require_zero(Rpoly-g**2+192*(t-h)**2, "norm of V-g")

    K = (t-2*a)*u-2*rp*t-2*n
    Rrelation = ((t**2-4)*(u**2+12)-K**2)/4
    V = 2*a*(t-h)*u+(t-2*a)*(rp*t+n)
    require_zero(V**2-Rpoly-4*a*(t-h)*Rrelation, "R coordinate V")
    require_zero(
        (t**2-4)*(t-h)*(u+6)-(t**2-4)*(V-g)/(2*a),
        "actual C over R, not an arbitrary isogeny kernel",
    )

    c2 = -rp/(4*a*k)
    p2 = c2*(t**2-4)**2
    q2 = 1/(16*a**2*c2*zz**2)
    require_zero(
        p2+q2*Rpoly+(t**2-4)*g/(2*a*zz),
        "constant coefficient of Z^2/z = (p+qV)^2",
    )
    require_zero(
        2*(t**2-4)/(4*a*zz)-(t**2-4)/(2*a*zz),
        "V coefficient of Z^2/z = (p+qV)^2",
    )
    ell2 = k*(k-1)*(k-lam)/rp**2
    require_zero(
        ell2*Rpoly/(t-2)**4-zz*(zz-1)*(zz-lam),
        "R isomorphism to the ordered Legendre model",
    )
    require_zero(
        (t**2-4)*(zz-k)**2-4*k*(2-em)*(zz-lam),
        "canonical cover becomes square root of zeta^2-lambda",
    )

    L, b, X = sp.symbols("L b X")
    quartic = (z**2-1)*(z**2-L)
    XX = (1-L)*(z+1)/(z-1)
    YYfactor = 2*(1-L)/(z-1)**2
    cubic = X*(X**2+2*(1+L)*X+(1-L)**2)
    require_zero(YYfactor**2*quartic-cubic.subs(X, XX), "marked quartic to cubic")
    require_zero(cubic.subs({X: -(1+b)**2, L: b**2}), "first missing two-torsion point")
    require_zero(cubic.subs({X: -(1-b)**2, L: b**2}), "second missing two-torsion point")
    require_zero(XX.subs(z, -1), "canonical-cover point is (0,0)")

    A, B = 2*(1+L), (1-L)**2
    c4 = 16*(A**2-3*B)
    delta = 16*B**2*(A**2-4*B)
    require_zero(c4-16*(L**2+14*L+1), "c4 of the actual marked curve")
    require_zero(delta-256*L*(L-1)**4, "discriminant of the actual marked curve")
    require_zero(c4**3/delta-16*(L**2+14*L+1)**3/(L*(L-1)**4), "actual j invariant")
    j0 = 16*(sp.Integer(33)**2+14*33+1)**3/(sp.Integer(33)*32**4)
    assert j0 == sp.Rational(912673, 528)
    return {
        "actual_curve": "Y^2=X*(X^2+2*(1+lambda)*X+(1-lambda)^2)",
        "canonical_cover_class": "(0,0)",
        "missing_classes": ["(-(1+sqrt(lambda))^2,0)", "(-(1-sqrt(lambda))^2,0)"],
        "j_at_m_zero": str(j0),
        "j": "16*(lambda^2+14*lambda+1)^3/(lambda*(lambda-1)^4)",
        "cover_identification": "D=C(sqrt(zeta^2-lambda)); C: v^2=(zeta^2-1)*(zeta^2-lambda)",
    }


def local_certificate():
    b, m = sp.symbols("b m")
    a0 = 3+2*b
    am = a0+11*m
    derivative = -192+144*b
    red = lambda value: sp.factor(sp.rem(sp.expand(value), b**2-2, b))
    assert red(a0**4-a0**2+1-33*a0**2) == 0
    assert red((2*a0-derivative)*a0**3-2) == 0
    remainder = red(am**4-am**2+1-(33+11*m*derivative)*am**2)
    coefficients = sp.Poly(remainder, m, b).coeffs()
    assert all(c % 121 == 0 for c in coefficients)
    assert -192 % 11 == 6 and 144 % 11 == 1
    assert pow(2, 5, 11) == 10
    assert red(a0*a0.subs(b, -b)) == 1
    assert red((a0**2-1)*(a0.subs(b, -b)**2-1)) == -32
    assert 6912 % 11 != 0
    L, X, Y = sp.symbols("L X Y")
    equation = Y**2-X*(X**2+2*(1+L)*X+(1-L)**2)
    assert sp.expand(equation.subs(L, 0)-(Y**2-X*(X+1)**2)) == 0
    assert sp.diff(equation, L).subs({L: 0, X: -1, Y: 0}) == -4
    assert sp.diff(equation, X).subs({L: 0, X: 0, Y: 0}) == -1
    nu = (b+1)**2/(b-1)**2
    require_zero(nu-1-4*b/(b-1)**2, "marked Legendre parameter approaches one, not zero")
    assert sp.expand(
        equation.subs(L, 33)-(Y**2-X*(X**2+68*X+1024))
    ) == 0
    CHECKS.append("uniform N=1 Taylor congruence, not a finite parameter search")
    return {
        "N": 1,
        "coefficient_field": "Q(sqrt(2),sqrt(3))",
        "residue_field": "F_11[b]/(b^2-2)",
        "lambda_over_11_mod_11": "3+m*(6+b)",
        "universal_nonvanishing": "Its b coefficient forces m=0 if it vanishes; its constant coefficient would then be 3.",
        "cleared_taylor_remainder_divided_by_121": str(sp.factor(remainder/121)),
        "v_11_lambda": 1,
        "v_11_lambda_minus_one": 0,
        "v_11_j_C": -1,
        "v_11_cubic_discriminant": 1,
        "special_fiber": "Y^2=X*(X+1)^2",
        "node": [-1, 0],
        "total_space_derivative_in_lambda_at_node": -4,
        "canonical_point": [0, 0],
        "special_fiber_X_derivative_at_canonical_point": -1,
        "marked_Legendre_parameter": "(sqrt(lambda)+1)^2/(sqrt(lambda)-1)^2",
        "v_11_marked_Legendre_parameter": 0,
        "v_11_marked_Legendre_parameter_minus_one": "1/2",
        "m_zero_curve": "Y^2=X*(X^2+68*X+1024)",
        "surface_discriminants": ["16*(a-1/a)^2", "6912"],
    }


def moduli_and_adapter():
    P = a**8+12*a**6-10*a**4+12*a**2+1
    B = a*(a**2-1)*(a**4-a**2+1)
    denominator = a**2*(a**2-1)**8*(a**4-a**2+1)
    j = 16*(lam**2+14*lam+1)**3/(lam*(lam-1)**4)
    require_zero(j-16*P**3/denominator, "degree-24 parameter-to-moduli map")
    assert sp.degree(16*P**3, a) == 24 and sp.degree(denominator, a) == 22
    assert sp.resultant(P, B, a) == 256

    def typed(polynomial):
        return {
            "domain": "QQ",
            "variables": ["a"],
            "polynomial": {
                "terms": [
                    {"coefficient": {"num": str(c.p), "den": str(c.q)},
                     "exponents": list(exponents)}
                    for exponents, c in sp.Poly(polynomial, a, domain=sp.QQ).terms()
                ]
            },
        }

    payload = {"left": typed(P), "right": typed(B), "elimination_variable": "a"}
    assert json.loads((ROOT/"jacobian-resultant-payload.json").read_text()) == payload
    output = json.loads((ROOT/"jacobian-univariate-output.json").read_text())
    assert output["request"] == {"operation_id": OPERATION, "payload": payload}
    assert output["result"]["operation_id"] == OPERATION
    assert output["result"]["output"] == {
        "convention": "SYLVESTER_DETERMINANT",
        "elimination_variable": "a",
        "resultant": {"kind": "SCALAR", "value": {"num": "256", "den": "1"}},
    }
    rejected = json.loads((ROOT/"jacobian-resultant-output.json").read_text())
    assert rejected["ok"] is False
    assert rejected["error"]["data"]["code"] == "INVALID_REQUEST"
    assert rejected["error"]["data"]["operation_id"] == "polynomial.multivariate.resultant.compute"
    return {
        "map_degree": 24,
        "max_integer_parameters_per_geometric_curve_class": 24,
        "resultant": 256,
        "operation_id": OPERATION,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "runtime_ms": output["result"]["runtime_ms"],
        "adapter_exit_status": 0,
        "timed_out": False,
        "structured_error": None,
        "prior_multivariate_request": {
            "adapter_exit_status": 2,
            "status": "INVALID_REQUEST: this contract requires at least two variables",
            "mathematical_conclusion": None,
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", type=Path)
    args = parser.parse_args()
    result = {
        "geometry": geometry(),
        "marked_quotient": marked_quotient(),
        "uniform_local_certificate": local_certificate(),
        "moduli_and_jacobian": moduli_and_adapter(),
        "exact_identity_count": len(CHECKS),
        "exact_identities": CHECKS,
        "scope": "Exact algebra and uniform local certificate. Geometric realization, all-complex-correspondence transfer, and publication qualification require the accompanying proof and independent review.",
    }
    if args.write_certificate:
        args.write_certificate.write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps({
        "ok": True,
        "exact_identity_count": len(CHECKS),
        "N": result["uniform_local_certificate"]["N"],
        "v_11_j_C": -1,
        "j_at_m_zero": result["marked_quotient"]["j_at_m_zero"],
        "moduli_degree": 24,
        "resultant": 256,
    }, indent=2))


if __name__ == "__main__":
    main()
