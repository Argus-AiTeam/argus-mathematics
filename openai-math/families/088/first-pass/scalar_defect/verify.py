#!/usr/bin/env python3
"""Recompute the scalar certificate exactly. Requires Python 3 and SymPy."""

import argparse
import copy
import json
from pathlib import Path

import sympy as s


ROOT = Path(__file__).resolve().parent
n, z, x, y, t = s.symbols("n z x y t")
DELTA = s.Rational(41, 360)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def zero(expression, label):
    require(s.cancel(expression) == 0, f"Identity failed: {label}")


def coefficients(expression, variable):
    p = s.Poly(s.expand(expression), variable)
    return [str(p.nth(j)) for j in range(p.degree() + 1)]


def positive_shift(expression, start, label, strict=True):
    values = s.Poly(s.expand(expression.subs(n, start + t)), t)
    require(all(a >= 0 for a in values.all_coeffs()), f"Negative coefficient: {label}")
    if strict:
        require(values.nth(0) > 0, f"Nonpositive constant: {label}")
    return coefficients(values.as_expr(), t)


def constants(nn):
    k = 1 if nn == 4 else 2
    beta = s.Rational(1, 2) if nn == 4 else s.Rational(2, 3)
    w = s.Rational(3, 14) if nn == 4 else (
        s.Rational(1, 3) if nn in (5, 6) else s.Rational(1, 2)
    )
    c = s.Rational(121, 35) if nn == 4 else (nn**2 + 5 * nn + 7) / ((nn + 1) * (nn + 3))
    return k, beta, w, c


def defect(nn, zz, *, large=False):
    k, beta, w, c = constants(nn)
    if large:
        k, beta, w = 2, s.Rational(2, 3), s.Rational(1, 2)
    inv = 1 / y if large else zz ** (-nn)
    e = (inv - 1) / nn
    M = zz**k - 1 + k * e
    W = zz**k - zz ** (k - 1) + e
    G = beta * M
    D = zz**k - 1 - G
    if large:
        zI = k**2 * (
            (zz ** (2 * k) - zz) / (2 * k - 1)
            - 2 * (zz - zz**k / y) / (nn + 1 - k)
            + (zz - 1 / y**2) / (2 * nn + 1)
        )
    else:
        I = k**2 * (
            (zz ** (2 * k - 1) - 1) / s.Integer(2 * k - 1)
            - 2 * (1 - zz ** (k - 1 - nn)) / (nn + 1 - k)
            + (1 - zz ** (-2 * nn - 1)) / (2 * nn + 1)
        )
        Mp = s.diff(M, zz)
        zero(s.diff(I, zz) - Mp**2, f"I'=M'^2, n={nn}")
        zero(I.subs(zz, 1), f"I(1)=0, n={nn}")
        zI = zz * I
    L = c * (
        ((nn - 1) * beta**2 * zI - 2 * nn * G**2) / (w * (2 * nn + 8))
        + D**2 / (1 - w)
    )
    return s.cancel(2 * W - L)


def compute_certificate():
    certificate = {
        "claim": "C_SCALAR_DEFECT",
        "result_class": "new_theorem",
        "scope": "Universal scalar remainder and a conditional quantitative norm transfer; not the full geometric theorem.",
        "remainder_constant": str(DELTA),
        "dimension_domain": "Every integer n >= 4",
        "scalar_domain": "Every real z > 0",
        "equality": "2W(z)-L(z)=0 if and only if z=1",
    }
    N = s.Symbol("N", integer=True, positive=True)
    Z = s.Symbol("Z", positive=True)
    general_M = Z**2-1+2*(Z**(-N)-1)/N
    general_I = 4*((Z**3-1)/3-2*(1-Z**(1-N))/(N-1)
                   +(1-Z**(-2*N-1))/(2*N+1))
    require(s.simplify(s.diff(general_I,Z)-s.diff(general_M,Z)**2)==0,
            "Universal I'=M'^2 for k=2, n>=5")
    zero(general_I.subs(Z,1), "Universal I(1)=0")
    certificate["integral_closed_form"] = "Derivative identity and base value checked symbolically for k=1,n=4 and k=2,every n>=5."

    # These recurrences, not a dimension sweep, certify the infinite range.
    B = lambda a: 1 + a * x + a * (a + 1) * x**2 / 2
    zero(B(n) - (1 - x) * B(n + 1) - (n + 1) * (n + 2) * x**3 / 2,
         "inverse-power quadratic induction")
    B3 = lambda a: 1 + a * x + a * (a - 1) * x**2 / 2 + a * (a - 1) * (a - 2) * x**3 / 6
    zero((1 + x) * B3(n) - B3(n + 1) - n * (n - 1) * (n - 2) * x**4 / 6,
         "cubic Bernoulli induction")
    E = lambda a, b: b**2 - 8 * b + 7 + 6 * a * x + (2 * a**2 - 3 * a) * x**2
    zero(E(n + 1, (1 + x) * y) - (1 + x)**2 * E(n, y)
         - 8 * x * ((1 + x) * y - B3(n + 1))
         - 4 * n * x**3 - n * (4 * n**2 - 6 * n + 5) * x**4 / 3,
         "double-power third-tail induction")
    zero(E(0, 1), "double-power induction base")
    require(all((a * (a - 1) * (a - 2)) == 0 for a in (0, 1, 2)),
            "cubic induction boundary")
    certificate["universal_inductions"] = {
        "inverse_quadratic_increment": str((n + 1) * (n + 2) * x**3 / 2),
        "cubic_increment_shift_n_3": positive_shift(n * (n - 1) * (n - 2) / 6, 3, "cubic increment"),
        "tail_recurrence": "E(n+1)=(1+x)^2 E(n)+8x((1+x)^(n+1)-B3(n+1))+4n*x^3+n(4n^2-6n+5)*x^4/3",
        "tail_quartic_shift_n_1": positive_shift(4 * n**2 - 6 * n + 5, 1, "tail quartic"),
        "tail_quartic_n_0": "5",
        "tail_conclusion": "T3(2n,x)>=8*T3(n,x)>=0 for every natural n and x>=0",
    }

    local = {}
    mean = {}
    for nn in (4, 5, 6):
        k, beta, w, c = constants(s.Integer(nn))
        margin = nn + 2 * k - 1 - c * k**2 / (1 - w)
        lhs = c * (2 * nn * beta**2 / (w * (2 * nn + 8)) - (1 - beta)**2 / (1 - w))
        require(margin >= DELTA, f"Left-interval margin, n={nn}")
        require(lhs <= s.Rational(2 * k - 1, k**2), f"Mean bound, n={nn}")
        local[str(nn)] = str(margin)
        mean[str(nn)] = str(lhs)
    require(list(local.values()) == ["3/5", "7/8", "43/21"], "Printed local margins")
    require(list(mean.values()) == ["11/12", "589/864", "1387/1890"], "Printed mean bounds")

    c = constants(n)[3]
    margin = n + 3 - 8 * c
    margin_num = s.cancel((margin - s.Rational(9, 10)) * 10 * (n + 1) * (n + 3))
    local["n_ge_7_margin_minus_9_10_numerator_shift"] = positive_shift(margin_num, 7, "left margin", strict=False)
    zero(margin_num.subs(n, 7), "local margin at seven")
    mean_lhs = c * (2 * n * s.Rational(4, 9) / (s.Rational(1, 2) * (2 * n + 8))
                    - s.Rational(1, 9) / s.Rational(1, 2))
    mean_gap_num = 3 * n**3 + 128 * n**2 + 505 * n + 548
    zero(s.Rational(3, 4) - mean_lhs - mean_gap_num / (36 * (n + 1) * (n + 3) * (n + 4)),
         "all-dimensional mean bound")
    require(all(a > 0 for a in s.Poly(mean_gap_num, n).all_coeffs()), "Mean gap coefficients")
    zero(s.diff(c, n) + (n**2 + 8 * n + 13) / ((n + 1)**2 * (n + 3)**2),
         "printed derivative of c")
    certificate["left_interval"] = local
    certificate["mean_bound"] = {**mean, "n_ge_7_gap_numerator": coefficients(mean_gap_num, n)}

    scales = {4: 2880, 5: 712800, 6: 221130}
    printed = {
        4: 462*z**10 - 983*z**9 + 93*z**8 + 3399*z**5 - 3378*z**4 + 407,
        5: 151525*z**14 - 273570*z**12 - 680800*z**11 + 938157*z**10 + 225720*z**7 - 462264*z**5 + 101232,
        6: 48399*z**16 - 75894*z**14 - 218004*z**13 + 285961*z**12 + 56940*z**8 - 127478*z**6 + 30076,
    }
    U = {
        4: 1728 - 1446*x - 6711*x**2 + 17052*x**4,
        5: 623700 - 1505900*x - 5802775*x**2 + 86314305*x**4,
        6: 452790 - 132249*x**2 + 51269452*x**4,
    }
    lower = {4: 328, 5: 193700, 6: 451790}
    printed_shift_table = {
        4: [1728,-1446,-6711,1173,17052,20796],
        5: [623700,-1505900,-5802775,12849430,86314305,191506920],
        6: [452790,679380,-132249,7800780,51269452,146058120],
    }
    small = {}
    for nn, scale in scales.items():
        P = s.cancel(scale * z ** (2 * nn) * defect(s.Integer(nn), z))
        zero(P - printed[nn], f"printed P_{nn}, recomputed from definitions")
        shifted = s.expand(P.subs(z, 1 + x))
        require(shifted.subs(x, 0) == 0 and s.diff(shifted, x).subs(x, 0) == 0,
                f"Order of vanishing, n={nn}")
        shifted_poly = s.Poly(shifted,x)
        require([shifted_poly.nth(j) for j in range(2,8)] == printed_shift_table[nn],
                f"Printed shifted coefficient table n={nn}")
        discarded = s.Poly(s.cancel(shifted / x**2) - U[nn], x)
        require(all(a >= 0 for a in discarded.all_coeffs()), f"Quartic truncation, n={nn}")
        require(s.Rational(lower[nn], scale) >= DELTA, f"Uniform small margin, n={nn}")
        poly = s.Poly(P, z)
        cover = sum(a * s.binomial(m[0], 8) for m, a in poly.terms()
                    if a < 0 or m[0] == poly.degree())
        require(cover == {4:11943, 5:207280425, 6:114414300}[nn], f"Leading-term cover, n={nn}")
        small[str(nn)] = {
            "scale": scale,
            "P_z_coefficients": coefficients(P, z),
            "P_1_plus_x_coefficients": coefficients(shifted, x),
            "quartic_coefficients": coefficients(U[nn], x),
            "quartic_lower_bound": lower[nn],
            "remainder_constant": str(s.Rational(lower[nn], scale)),
            "leading_term_cover_at_8": str(cover),
        }

    quadratics = [(1446, 400, 1400), (8111, 1000, 17052),
                  (1505900, 200000, 2900000), (8702775, 230000, 86314305),
                  (132249, 1000, 51269452)]
    discriminants = [4*a*b-d*d for d,a,b in quadratics]
    require(all(a > 0 for a in discriminants), "Quadratic domination certificates")
    require(discriminants[:4] == [149084,2419679,52265190000,3670867899375],
            "Printed quadratic discriminants")
    require(4*452790*51269452-132249**2 == 92839690886319, "Printed U6 discriminant")
    # a+b*u^2-d*u = ((2b*u-d)^2+(4ab-d^2))/(4b).
    u, a, b, d = s.symbols("u a b d")
    zero(4*b*(a+b*u**2-d*u) - (2*b*u-d)**2 - (4*a*b-d*d), "quadratic SOS identity")
    certificate["small_dimensions"] = small
    certificate["quadratic_domination"] = [
        {"d":d,"a":a,"b":b,"four_ab_minus_d_squared":v}
        for (d,a,b),v in zip(quadratics,discriminants)
    ]

    scale = 9 * (n + 4) / c
    P = s.cancel(scale * y**2 * defect(n, z, large=True))
    poly = s.Poly(P, y, z)
    A4,A2,A1,A0,B2,B0,T0 = [s.factor(poly.coeff_monomial(m))
                            for m in (y*y*z**4,y*y*z*z,y*y*z,y*y,y*z*z,y,1)]
    require(len(poly.terms()) == 7, "Large polynomial support")
    H = 18 * (n + 4) / c
    printed_large = [(2*n-8)/3, H-12*n-32-64/n,
                     -H+16*(n-1)/3+32-16*(n-1)/(2*n+1),
                     -H/n+6*n+40+64/n-128/n**2,
                     16+64/n, H/n-48-64/n+256/n**2,
                     16*(n-1)/(2*n+1)-128/n**2]
    for recomputed, original in zip((A4,A2,A1,A0,B2,B0,T0),printed_large):
        zero(recomputed-original, "printed large-polynomial coefficient")
    q = [A4+A2+A1+A0,4*A4+2*A2+A1,6*A4+A2,4*A4,A4]
    r = [B2+B0,2*B2,B2]
    q = list(map(s.factor,q)); r = list(map(s.factor,r))
    zero(q[0]+r[0]+T0, "constant cancellation")
    zero(2*n*q[0]+q[1]+n*r[0]+r[1], "linear cancellation")
    K = n*(2*n-1)*q[0]+2*n*q[1]+q[2]+n*(n-1)*r[0]/2+n*r[1]+r[2]
    zero(K-scale*margin, "quadratic coefficient")

    V = [
        34*n**5-95*n**4-1666*n**3-5701*n**2-8052*n-2688,
        2*n**5+9*n**4-162*n**3-845*n**2-1220*n-448,
        5*n**3+8*n**2-41*n-56,
        7*n**4+8*n**3-187*n**2-748*n-896,
    ]
    sign_expressions = [q[0]+r[0]/8,q[1],q[2],r[0]]
    sign_forms = [V[0]/(4*n**2*(2*n+1)*(n*n+5*n+7)),
                  2*V[1]/(n*(2*n+1)*(n*n+5*n+7)),
                  2*(n+4)*V[2]/(n*(n*n+5*n+7)),
                  -2*V[3]/(n*n*(n*n+5*n+7))]
    for left,right in zip(sign_expressions,sign_forms):
        zero(left-right, "large sign certificate")
    shifts = [positive_shift(v,start,f"V{i}") for i,(v,start) in enumerate(zip(V,[10,10,7,7]))]

    T3 = lambda a,b: b-1-a*x-a*(a-1)*x*x/2
    tail2 = lambda a,b: b-1-a*x
    shifted_P = P.subs(z,1+x)
    decomposition = (
        (q[0]+r[0]/8)*T3(2*n,y*y) - r[0]/8*(T3(2*n,y*y)-8*T3(n,y))
        +q[1]*x*tail2(2*n,y*y)+r[1]*x*tail2(n,y)
        +q[2]*x*x*(y*y-1)+r[2]*x*x*(y-1)+q[3]*x**3*y*y+q[4]*x**4*y*y
    )
    zero(shifted_P-K*x*x-decomposition, "universal nonnegative remainder decomposition")
    bridge = {}
    component_bounds = {
        7: [-2,-11,60,-2,50],
        8: [-1,-6,72,-6,46],
        9: [-1,-6,72,-6,46],
    }
    printed_bridge_bounds = {
        7: [s.Rational(5,26),s.Rational(1233,1144),s.Rational(589,176)],
        8: [s.Rational(37,28),s.Rational(10707,3640),s.Rational(1153,208)],
        9: [s.Rational(101,136),s.Rational(3851,2040),s.Rational(395,112)],
    }
    printed_tuples = {
        7: ["-5984/3185","-4832/455","792/13","-1216/637","352/7"],
        8: ["-421/629","-3736/629","2688/37","-145/37","48"],
        9: ["2416/10773","-2192/1197","100568/1197","-57968/10773","416/9"],
    }
    for nn in (7,8,9):
        concrete = s.expand(P.subs(n,nn).subs(y,z**nn).subs(z,1+x))
        p = s.Poly(concrete,x)
        require(p.nth(0)==0 and p.nth(1)==0, f"Bridge cancellation n={nn}")
        require(all(p.nth(j)>=0 for j in range(2,p.degree()+1)), f"Bridge signs n={nn}")
        zero(p.nth(2)-(scale*margin).subs(n,nn), f"Bridge quadratic n={nn}")
        exact_tuple = [v.subs(n,nn) for v in [q[0],q[1],q[2],r[0],r[1]]]
        require([str(v) for v in exact_tuple] == printed_tuples[nn], f"Printed tuple n={nn}")
        bounds = list(map(s.Integer,component_bounds[nn]))
        require(all(a>=b for a,b in zip(exact_tuple,bounds)), f"Component bounds n={nn}")
        bq0,bq1,bq2,br0,br1 = bounds
        evaluated = []
        for j in (3,4,5):
            value = (bq0+br0/s.Integer(2)**j
                     +s.Rational(j,2*nn-j+1)*(bq1+bq2*s.Rational(j-1,2*nn-j+2)))
            if j < 5:
                value += br1*s.binomial(nn,j-1)/s.binomial(2*nn,j)
            require(value>0, f"Printed bridge lower bound n={nn}, j={j}")
            evaluated.append(value)
        require(evaluated==printed_bridge_bounds[nn], f"Printed lower-bound table n={nn}")
        require(bq1+bq2*s.Rational(4,2*nn-3)
                == {7:s.Rational(119,11),8:s.Rational(210,13),9:s.Rational(66,5)}[nn],
                f"Monotone-tail start n={nn}")
        require(bq1+2*nn*bq2=={7:829,8:1146,9:1290}[nn], f"Top coefficient bound n={nn}")
        bridge[str(nn)] = {"coefficients":coefficients(concrete,x),
                           "q": [str(v.subs(n,nn)) for v in q],
                           "r": [str(v.subs(n,nn)) for v in r],
                           "printed_component_lower_bounds": [str(v) for v in bounds],
                           "printed_lower_bounds_at_3_4_5": [str(v) for v in evaluated]}
    certificate["large_dimensions"] = {
        "recomputed_coefficients": {name:str(value) for name,value in
                                    zip(["A4","A2","A1","A0","B2","B0","T0"],[A4,A2,A1,A0,B2,B0,T0])},
        "sign_numerators": [coefficients(v,n) for v in V],
        "positive_shift_coefficients": shifts,
        "bridge_dimensions": bridge,
        "quadratic_coefficient": str(s.factor(K)),
        "universal_range": "n>=10, by the double-power third-tail induction and the displayed exact decomposition",
    }
    certificate["norm_transfer"] = (
        "(E g^k)^2-(E g^(k-1))^2-c||Q(g^k)||_2^2"
        " >= (41/360) E[(g-1)^2/max(1,g)^(2n)], assuming the manuscript curvature/projection reduction"
    )
    certificate["manuscript_refutations"] = []
    return certificate


def verify(candidate):
    expected = compute_certificate()
    require(candidate == expected, "Certificate differs from exact recomputation")
    return expected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=ROOT / "exact_certificate.json")
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--test-tamper", action="store_true")
    args = parser.parse_args()
    expected = compute_certificate()
    if args.write_certificate:
        args.certificate.write_text(json.dumps(expected,indent=2,sort_keys=True)+"\n")
    candidate = json.loads(args.certificate.read_text())
    require(candidate == expected, "Certificate differs from exact recomputation")
    tamper_rejected = False
    if args.test_tamper:
        altered = copy.deepcopy(candidate)
        altered["small_dimensions"]["4"]["P_1_plus_x_coefficients"][2] = "1729"
        try:
            require(altered == expected, "Certificate differs from exact recomputation")
        except ValueError:
            tamper_rejected = True
        require(tamper_rejected, "Altered certificate was accepted")
    print(json.dumps({"verified":True,"claim":"C_SCALAR_DEFECT",
                      "dimensions":"all integers n>=4","domain":"all real z>0",
                      "constant":str(DELTA),"tamper_rejected":tamper_rejected,
                      "manuscript_refutations":0},sort_keys=True))


if __name__ == "__main__":
    main()
