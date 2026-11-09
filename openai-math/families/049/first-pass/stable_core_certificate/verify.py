#!/usr/bin/env python3
"""Replay exact identities; universal derivation claims are proved separately."""

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def compute():
    checks = []

    def identity(name, expression, statement):
        residual = sp.cancel(sp.expand(expression))
        if residual != 0:
            raise AssertionError(f"{name}: nonzero exact residual {residual}")
        checks.append({
            "name": name,
            "kind": "exact_polynomial_or_localized_identity",
            "statement": statement,
            "residual": "0",
        })

    def ideal_check(name, expression, generators, variables, statement):
        basis = sp.groebner(generators, *variables, order="lex", domain=sp.QQ)
        remainder = basis.reduce(sp.expand(expression))[1]
        if remainder != 0:
            raise AssertionError(f"{name}: nonzero ideal remainder {remainder}")
        checks.append({
            "name": name,
            "kind": "exact_QQ_ideal_membership",
            "statement": statement,
            "generators": [str(g) for g in generators],
            "remainder": "0",
        })

    p, s, u, F, J, w = sp.symbols("p s u F J w")
    x = s**2 - u**2 + p*F
    H = x**2*F - (1 + 2*s*x)*J - p*J**2 - u
    y = s + x*(x + u**2)
    z = s*x + p*J
    identity("oct_quadric", x*y-z*(z+1)-p*(H+u),
             "xy-z(z+1)=p(H+u), with the manuscript's signs.")
    identity("oct_local_inverse_s", y-x*(x+u**2)-s,
             "The localized inverse recovers s without division.")
    identity("oct_local_inverse_F", (x-s**2+u**2)-p*F,
             "The numerator of the inverse F is pF, not -pF.")
    identity("oct_local_inverse_J", (z-s*x)-p*J,
             "The numerator of the inverse J is pJ.")

    M = sp.Matrix([[F, s-u], [s+u, -p]])
    e, n = sp.Matrix([x, -J]), sp.Matrix([J, x])
    nil = n*e.T
    for i in range(2):
        for j in range(2):
            identity(f"matrix_nilpotent_{i}{j}", (nil*nil)[i, j],
                     "(n e^t)^2=0 in the free polynomial ring.")
    identity("matrix_determinant", (sp.eye(2)-2*nil).det()-1,
             "The signed matrix substitution has determinant one.")
    Mp = (sp.eye(2)-2*nil)*M
    identity("matrix_preserves_x", -Mp.det()-x,
             "The matrix substitution preserves x=-det(M).")
    up = (Mp[1, 0]-Mp[0, 1])/2
    identity("matrix_linearizes_H", H+J+up,
             "H=-J-u_prime, so the hypersurface eliminates u_prime.")
    recovered = (sp.eye(2)+2*nil)*Mp
    for i in range(2):
        for j in range(2):
            identity(f"matrix_inverse_{i}{j}", recovered[i, j]-M[i, j],
                     "The stated polynomial inverse recovers M.")

    pp, ss, FF, JJ, uu = sp.symbols("pp ss FF JJ uu")
    xx = ss**2-uu**2+pp*FF
    MM = sp.Matrix([[FF, ss-uu], [ss+uu, -pp]])
    ee, nn = sp.Matrix([xx, -JJ]), sp.Matrix([JJ, xx])
    oldp = -((sp.eye(2)+2*nn*ee.T)*MM)[1, 1]
    identity("literal_p_transport", oldp-(pp-2*xx*(xx*(ss-uu)+pp*JJ)),
             "The inverse lower-right entry has the literal p formula.")
    x1, x2, x3, x4 = sp.symbols("x1 x2 x3 x4")
    Q = x2**2-x4**2+x1*x3
    literal_f = x1-2*Q*(Q*(x2+x4)+x1*x4)
    transported = oldp.subs({pp: x1, ss: x2, FF: x3, JJ: x4, uu: -x4})
    identity("literal_f", transported-literal_f,
             "After u_prime=-J, p is exactly the printed f.")
    if sp.Poly(literal_f, x1, x2, x3, x4).total_degree() != 5:
        raise AssertionError("The literal polynomial does not have degree five.")

    variables = (p, s, u, F, J)
    values = (0, 2*p*x*u, -p, -4*s*x*u-2*u, -2*x**2*u)

    def delta(expression):
        return sp.expand(sum(sp.diff(expression, t)*v
                             for t, v in zip(variables, values)))

    for name, expression in (("x", x), ("y", y), ("z", z), ("p", p)):
        identity(f"delta_fixes_{name}", delta(expression), f"Delta({name})=0.")
    identity("delta_H", delta(H)-p, "Delta(H)=p.")
    orders = {p: 1, s: 3, u: 2, F: 5, J: 3}
    shifted = {}
    for variable, order in orders.items():
        term, image = variable, variable
        for r in range(1, order+1):
            previous = term
            term = delta(term)
            if r < order:
                image += w**r*term/sp.factorial(r)
            else:
                identity(f"generator_nilpotence_{variable}", term,
                         f"Delta^{order}({variable})=0; Leibniz extends this to all polynomials.")
                if sp.expand(previous) == 0:
                    raise AssertionError(f"The claimed nilpotence order for {variable} is not minimal.")
                checks.append({
                    "name": f"minimal_generator_nilpotence_{variable}",
                    "kind": "exact_nonzero_polynomial",
                    "statement": f"Delta^{order-1}({variable}) is nonzero in the free QQ polynomial ring.",
                    "nonzero_witness": str(sp.factor(previous)),
                })
        shifted[variable] = sp.expand(image)
    xt = shifted[s]**2-shifted[u]**2+p*shifted[F]
    identity("exponential_preserves_x", xt-x, "The finite polynomial exponential fixes x.")
    identity("exponential_preserves_y", shifted[s]+x*(x+shifted[u]**2)-y,
             "The finite polynomial exponential fixes y, using its verified fixed x.")
    identity("exponential_preserves_z", shifted[s]*x+p*shifted[J]-z,
             "The finite polynomial exponential fixes z.")
    Ht = x**2*shifted[F]-(1+2*shifted[s]*x)*shifted[J]-p*shifted[J]**2-shifted[u]
    identity("exponential_shift", Ht-H-p*w, "exp(w Delta)(H)=H+pw exactly.")

    L, N = sp.symbols("L N")
    x0 = s**2-u**2
    l = x0**2*F-(1+2*s*x0)*J
    n0 = (1-2*s*x0)*F+4*s**2*J
    finv = 4*s**2*L+(1+2*s*x0)*N
    jinv = -(1-2*s*x0)*L+x0**2*N
    identity("linear_determinant", 4*s**2*x0**2+(1+2*s*x0)*(1-2*s*x0)-1,
             "The stabilization linear substitution has determinant one.")
    identity("linear_inverse_L", l.subs({F: finv, J: jinv}, simultaneous=True)-L,
             "The explicit inverse recovers L.")
    identity("linear_inverse_N", n0.subs({F: finv, J: jinv}, simultaneous=True)-N,
             "The explicit inverse recovers N.")
    q0 = 2*x0*F**2+p*F**3-2*s*F*J-J**2
    identity("H_linearization", H-(l-u+p*q0), "H=L-u+pQ0, including p=0.")
    identity("boundary_p_zero", H.subs(p, 0).subs({F: finv, J: jinv}, simultaneous=True)-L+u,
             "At p=0 the equation is exactly L-u, with N free.")

    a, d, b, c, t = sp.symbols("a d b c t")
    determinant = a*c-b*d-1
    sb = d*c-a*b*t
    f0, g0 = t-sb**2, b*d-sb*a*b
    v = a**2*t-d**2
    A = c**2-b**2*t
    r = a**2*(a*c-3*b*d)
    q = d**2*(3*a*c-b*d)+r*t
    identity("global_f0_factor", f0-A*v+t*determinant*(determinant+2),
             "f0=A*v-t*(ac-bd-1)*(ac-bd+1), over Z.")
    identity("global_g0_factor", g0-b**2*v+b*d*determinant,
             "g0=b^2*v-b*d*(ac-bd-1), over Z.")
    identity("global_bezout", r*A+q*b**2-(a*c-b*d)**3,
             "r*A+q*b^2=(ac-bd)^3, with no division or regularity hypotheses.")
    multiplier = -r*t*(determinant+2)-q*b*d+v*((a*c-b*d)**2+(a*c-b*d)+1)
    identity("global_reverse_ideal", r*f0+q*g0-v-determinant*multiplier,
             "v=r*f0+q*g0 modulo the determinant relation, including zero divisors.")

    vv = v.subs(t, a*b+u**2)
    gg = g0.subs(t, a*b+u**2)
    ideal_check("boundary_a_zero_g0", gg+1, [determinant, a], (a, d, b, c, u),
                "At a=0, g0=-1 on the whole determinant quotient.")
    ideal_check("boundary_a_zero_v_unit", -b**2*vv-1, [determinant, a],
                (a, d, b, c, u), "At a=0, v has inverse -b^2; no prime is omitted.")
    ideal_check("base_relation", (a*b)*(d*c)-(d*b)*(d*b+1),
                [determinant], (a, d, b, c),
                "The base map (x,y,z)=(ab,dc,db) has the correct orientation.")

    X, Y, Z = sp.symbols("X Y Z")
    quadric = X*Y-Z*(Z+1)
    b0, c0, d0 = X/a, (Z+1)/a, a*Y/(Z+1)
    identity("chart_U0_determinant", (a*c0-b0*d0-1)*(Z+1)+quadric,
             "U0=D(z+1) is a Laurent-a chart after precisely the quadric relation.")
    identity("chart_U0_z", (d0*b0-Z)*(Z+1)-quadric,
             "The U0 chart recovers z without assuming x or y invertible.")
    a1, b1, c1 = X*d/Z, Z/d, Y/d
    identity("chart_U1_determinant", (a1*c1-b1*d-1)*Z-quadric,
             "U1=D(z) is a Laurent-d chart.")
    identity("chart_U1_x", a1*b1-X, "The U1 chart recovers x.")
    identity("chart_U1_y", d*c1-Y, "The U1 chart recovers y.")
    identity("chart_U1_z", d*b1-Z, "The U1 chart recovers z.")
    identity("chart_cover", (Z+1)-Z-1, "z and z+1 generate the unit ideal.")
    ideal_check("boundary_z_zero", sp.cancel((a*(1/a)-(X/a)*(a*Y)-1)),
                [X*Y], (X, Y), "At z=0 the U0 determinant holds on both components xy=0.")
    ideal_check("boundary_z_zero_base", sp.cancel((d0*b0).subs(Z, 0)), [X*Y], (X, Y),
                "At z=0 the U0 base z is zero even at the component intersection.")
    ideal_check("boundary_z_minus_one", sp.cancel((-X*d)*(Y/d)-(-1/d)*d-1),
                [X*Y], (X, Y), "At z=-1 the U1 determinant holds on both components xy=0.")

    Sf, Uf, psiX = sp.symbols("S_family U_family psiX")
    tf = Uf**2+psiX
    sf = Y-X*tf
    family_relation = Sf**2-tf
    family_map = {Y: Sf+X*tf, Z: X*Sf}
    identity("family_quadric_transport",
             quadric.subs(family_map, simultaneous=True)+X**2*family_relation,
             "The quadric relation is -X^2 times the surface relation for arbitrary psi(X).")
    identity("family_s_recovery", sf.subs(family_map, simultaneous=True)-Sf,
             "The inverse recovers S globally, without dividing by X.")
    identity("family_first_generator",
             (tf-sf**2).subs(family_map, simultaneous=True)+family_relation,
             "The first ideal generator is the negative surface relation.")
    identity("family_second_generator",
             (Z-sf*X).subs(family_map, simultaneous=True),
             "The second ideal generator vanishes on the embedded surface.")
    identity("family_split_surface", (Sf-Uf)*(Sf+Uf)-psiX-family_relation,
             "R=S-U and V=S+U give RV=psi(X), including psi=0.")
    identity("family_boundary_nonvanishing",
             (Z-sf*X).subs({X: 0, Y: 0, Z: -1, Uf: 0})+1,
             "The second generator is -1 at the omitted-chart point for every psi.")

    h, U, V, W, G, xs, ys, ss0, T = sp.symbols("h U V W G xs ys ss0 T")
    alpha, beta, aa, bb, rr, qq = sp.symbols("alpha beta aa bb rr qq")

    def cusp_S(hh, uu0, vv0, ww0):
        return (2*uu0**3*vv0+3*uu0**4*ww0
                +hh*(vv0**2-3*uu0**2*ww0**2)+hh**2*ww0**3)

    xx0, yy0 = U**3+h*V, -U**2+h*W
    s0 = cusp_S(h, U, V, W)
    identity("sep_cusp", xx0**2+yy0**3-h*s0, "The literal September S is (x^2+y^3)/h.")
    RW = h*W-ys-U**2
    identity("sep_linear_S", cusp_S(h, U, G-U*W, W)
             -(h*G**2-2*U*ys*G+ys**2*W)-RW*(-2*U*G+2*ys*W+RW*W),
             "The S substitution is a polynomial identity, not cancellation of h.")
    identity("sep_linear_first", U**3+h*(G-U*W)-xs-(h*G-ys*U-xs)+U*RW,
             "The first relation linearizes without regularity assumptions.")
    identity("sep_compatibility", ys**2*(ys+U**2)-h*(ss0-h*G**2+2*U*ys*G)
             -((h*G-ys*U)**2+ys**3-h*ss0),
             "The two linear W equations have exactly the stated compatibility.")
    identity("sep_squared_bezout",
             alpha*(1+beta*ys)*h+beta**2*ys**2-1-(alpha*h+beta*ys-1)*(1+beta*ys),
             "(h,y)=1 gives (h,y^2)=1 by an integer identity.")
    W0 = rr*aa+qq*bb
    unit_defect, compatibility = rr*h+qq*ys**2-1, ys**2*aa-h*bb
    identity("sep_W0_first", h*W0-aa-unit_defect*aa+qq*compatibility,
             "hW0=a follows by compatibility and Bezout, even with zero divisors.")
    identity("sep_W0_second", ys**2*W0-bb-unit_defect*bb-rr*compatibility,
             "y^2W0=b follows without division.")
    identity("sep_ideal_W", W-W0-rr*(h*W-aa)-qq*(ys**2*W-bb)+unit_defect*W,
             "The two W relations generate (W-W0), not just an equal zero set.")
    UT, GT = h*T-beta*xs, ys*T+alpha*xs
    identity("sep_UG_relation", h*GT-ys*UT-xs-xs*(alpha*h+beta*ys-1),
             "The inverse U,G polynomials satisfy the defining linear relation.")
    identity("sep_T_inverse", alpha*UT+beta*GT-T-T*(alpha*h+beta*ys-1),
             "The parameter composite is the identity modulo Bezout.")

    ps = -2*ss0**2*xs+3*ss0*ys**2-3*ss0**3*ys
    shifted_X, shifted_Y = xs+ss0**3, ys-ss0**2
    identity("sep_cusp_translation", shifted_X**2+shifted_Y**3-(xs**2+ys**3-ss0*ps),
             "The s^6 terms cancel with the printed translation signs.")
    al = 1+2*ss0**2*xs+4*ss0**5
    be = (3*ss0**3-3*ss0*ys)*(1+2*ss0**2*xs)-4*ss0**4*ys**2
    identity("sep_explicit_bezout", al*h+be*ys-1
             -(1+2*ss0**2*xs)*(h-1-ps)+4*ss0**4*(xs**2+ys**3-ss0*h),
             "The September alpha,beta certificate has the stated signs.")
    actual_p = ps.subs({xs: xx0, ys: yy0, ss0: s0}, simultaneous=True)
    september_F = h-actual_p-1
    point = {h: 2, U: 0, V: sp.Rational(-1, 2), W: sp.Rational(1, 2)}
    identity("sep_critical_value", september_F.subs(point)+1, "F(P)=-1 exactly.")
    for variable in (h, U, V, W):
        identity(f"sep_critical_derivative_{variable}",
                 sp.diff(september_F, variable).subs(point),
                 f"The literal derivative with respect to {variable} vanishes at P.")

    adapter_request = json.loads((HERE/"jacobian_request.json").read_text())
    adapter = json.loads((HERE/"jacobian_result.json").read_text())
    contract = json.loads((HERE/"jacobian_contract.json").read_text())
    typed = adapter["result"]["output"]
    if adapter["result"]["operation_id"] != contract["inspected_operation"]:
        raise AssertionError("The Jacobian result is from a different operation.")
    if (adapter["server"]["version"] != contract["server_version"]
            or adapter["protocol_version"] != contract["protocol_version"]):
        raise AssertionError("The recorded Jacobian server or protocol version changed.")
    if adapter["request"]["payload"] != adapter_request:
        raise AssertionError("Jacobian output is bound to a different payload.")
    if typed["request"] != adapter_request:
        raise AssertionError("The typed Jacobian result has a different request.")
    if typed["outcome"] != "COMPUTED" or typed["in_ideal"] is not True:
        raise AssertionError("Jacobian did not return a conclusive ideal computation.")
    if typed["remainder"]["polynomial"]["terms"] != []:
        raise AssertionError("Jacobian returned a nonzero normal form.")

    return {
        "result_class": "exact_verification_certificate",
        "symbolic_scope": "Exact identities and explicitly presented ideal reductions, not a finite LND ansatz.",
        "universal_claims": {
            "not_inferred_from_computation": True,
            "proof_source": "Main.lean",
            "mathematical_report": "report.md",
            "claims": ["C_STABLE_CORE_VERIFY", "C_PERTURBATION_RIGIDITY", "C_GLOBAL_PRINCIPAL"],
            "independent_review": "required_from_Host",
        },
        "literal_october_f": str(sp.expand(literal_f)),
        "literal_october_degree": 5,
        "generator_nilpotence_orders": {str(k): v for k, v in orders.items()},
        "global_principalization": {
            "base": "every commutative ring with identity",
            "hypothesis": "a*c-b*d=1",
            "t": "arbitrary ring element",
            "s": str(sb),
            "v": str(v),
            "f0_cofactor": str(A),
            "g0_cofactor": "b**2",
            "reverse_f0_coefficient": str(r),
            "reverse_g0_coefficient": str(q),
        },
        "surface_family": {
            "claim": "C_DANIELEWSKI_RESTRICTION",
            "parameter": "every psi in C[T], including zero and repeated roots",
            "embedding": "(x,y,z,u)=(X,S+X*(U**2+psi(X)),X*S,U)",
            "quotient": "C[X,R,V]/(R*V-psi(X))",
            "identity_scope": "psiX is an indeterminate; substitute any polynomial psi(X).",
            "unrestricted_LND_proof": "report.md Theorem 3, not inferred from these identities",
            "formal_scope": "corollary of the certified cores, not a separate Main.lean declaration",
        },
        "jacobian": {
            "operation_id": adapter["result"]["operation_id"],
            "server_version": adapter["server"]["version"],
            "protocol_version": adapter["protocol_version"],
            "outcome": typed["outcome"],
            "in_ideal": typed["in_ideal"],
            "adapter_exit_code": 0,
            "structured_error": None,
            "payload": "jacobian_request.json",
            "typed_output": "jacobian_result.json",
        },
        "checks": checks,
        "check_count": len(checks),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = compute()
    certificate = HERE/"exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2, sort_keys=True)+"\n")
    if json.loads(certificate.read_text()) != result:
        raise AssertionError("The stored exact certificate differs from this replay.")
    print(f"PASS: {result['check_count']} exact checks; literal degree-five transport; "
          "uniform surface embeddings; a=0, z=0, z=-1, p=0 boundaries retained.")


if __name__ == "__main__":
    main()
