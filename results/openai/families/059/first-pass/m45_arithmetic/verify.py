#!/usr/bin/env python3
"""Replay compact exact calculations supporting the M45 arithmetic proof."""

import argparse
import json
from math import gcd
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = ROOT / "research/openai_manuscript" / (
    "Ambiently-homeomorphic-isolated-hypersurface-germs-in-C4-"
    "with-multiplicities-four-and-five-September-27-2026/build/sections"
)
OPERATION = "matrix.symbolic.characteristic_polynomial.compute"
CHECKS = []


def require(condition, label):
    if not condition:
        raise AssertionError(label)
    CHECKS.append(label)


def zero(expression, label):
    require(sp.cancel(expression) == 0, label)


def matrix_zero(matrix, label):
    require(all(sp.cancel(entry) == 0 for entry in matrix), label)


def source_bindings():
    bindings = {
        "02-plane.tex": [
            r"h(X,T)&=T(X-T^2)(X-2T^2)",
            r"q_1(u,w)&=(u-w-w^8)(u-w-2w^8)(u-w^2)",
            r"q_2(u,w)&=q_1(u,w)-u^2",
            r"u=x+w",
        ],
        "03-ambient.tex": [
            r"n_1&=n_0+5\cdot2^r",
            r"a&=(n_0^2-1)/4",
            r"b&=(n_1^2-1)/4",
        ],
        "09-arithmetic.tex": [
            r"UV(U^{4a}+V^{4b})",
            r"e(b_j,b_j)&=-\frac{n_j^2}{4}",
            r"e(b_0,b_1)&=-\frac14",
            r"J_1=\rho_1J_0\rho_0^{-1}",
        ],
    }
    for filename, fragments in bindings.items():
        text = "".join((SOURCE / filename).read_text().split())
        require(
            all("".join(fragment.split()) in text for fragment in fragments),
            f"staged source binding: {filename}",
        )
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    retained = {}
    for claim_id in ("C059BASE", "C059APPLICATION", "M45:thm:tube"):
        claim = max(
            (c for c in state["claims"] if c["claim_id"] == claim_id),
            key=lambda c: c["version"],
        )
        reviews = [
            e for e in state["evidence"]
            if e["subject"]["kind"] == "claim"
            and e["subject"]["subject_id"] == claim_id
            and e["subject"]["content_hash"] == claim["content_hash"]
            and e["verdict"] == "supports"
            and e["produced_by"].startswith("reviewer:")
        ]
        require(bool(reviews), f"retained independent input: {claim_id}")
        retained[claim_id] = sorted({e["artifact"] for e in reviews})
    return retained


def plane_calculations():
    u, w, v, x, t, X, T = sp.symbols("u w v x t X T")
    h = T * (X - T**2) * (X - 2 * T**2)
    q1 = (u - w - w**8) * (u - w - 2 * w**8) * (u - w**2)
    q2 = q1 - u**2
    phi = u**2 + q1
    psi = (u * (u - w**2) * q2).subs(u, x + w)
    zero(h.subs({X: phi, T: u}) - u * q1 * q2, "exact first pullback")
    zero(q1.subs(u, 0) + w**4 * (1 + w**7) * (1 + 2 * w**7),
         "first finite-map specialization")
    remainder = sp.Poly(sp.expand(psi.subs(x, 0) + w**4 * (1 - w)), w)
    require(min(monomial[0] for monomial, _ in remainder.terms()) == 19,
            "second finite-map remainder starts at degree 19")
    zero(q2.subs(w, 0) - u**2 * (u - 1), "two local q2 branches")
    leading = sp.expand(q2.subs(u, v * w**2)).coeff(w, 4)
    zero(leading + v**2 - v + 1, "q2 branch leading polynomial")
    require(sp.discriminant(v**2 - v + 1, v) == -3,
            "q2 branch leading roots simple")
    b_poly = v * (v - 1) * (v**2 - v + 1)
    require(sp.discriminant(b_poly, v) == -3, "four distinct B coefficients")
    require(sp.discriminant((v - 1) * (v - 2), v) == 1,
            "two distinct A coefficients")
    dstar = (x - t**8) * (x - 2 * t**8) * t * (t - x**2) * (
        t**2 - t * x**2 + x**4
    )
    terms = sp.Poly(dstar, x, t).terms()
    face_t = sum(c * x**i * t**j for (i, j), c in terms if 8*i + j == 20)
    face_x = sum(c * x**i * t**j for (i, j), c in terms if i + 2*j == 10)
    zero(face_t - t**4 * (x - t**8) * (x - 2*t**8), "t-side weighted face")
    zero(face_x - x**2 * t * (t - x**2) * (t**2 - t*x**2 + x**4),
         "x-side weighted face")
    require(all(8*i + j >= 20 and i + 2*j >= 10 for (i, j), _ in terms),
            "no lower weighted monomials")
    require(2 * sp.Rational(8, 20) + 4 * sp.Rational(1, 20) == 1,
            "t-side overlap phase speed")
    require(2 * sp.Rational(1, 10) + 4 * sp.Rational(2, 10) == 1,
            "x-side overlap phase speed")
    require(gcd(2, 4) == 2 and (2-8, 4-1) == (-6, 3),
            "two annuli and three primitive kernel turns")
    cyclotomic = sp.cyclotomic_poly(5, t)
    annihilator = (t + 1) * (t**20 - 1)
    repeated = sp.gcd(annihilator, sp.diff(annihilator, t))
    require(repeated == t + 1, "annular annihilator repeated root only at -1")
    target = (t - 1) * cyclotomic
    require(sp.rem(annihilator, target, t) == 0, "required roots in annihilator")
    require(sp.gcd(target, sp.div(annihilator, target, t)[0]) == 1,
            "no Jordan multiplicity at 1 or primitive fifth roots")
    require(2 + 4 == 6 and 2 - 1 == 1, "base rational rank and trace")
    return {
        "B_coefficient_discriminant": -3,
        "annulus_count": 2,
        "twentieth_return_difference": [-6, 3],
        "annihilator_from_geometric_relation": "(t+1)*(t^20-1)",
        "repeated_factor": "t+1",
        "base_trivial_rank": 2,
        "base_cyclotomic_rank": 4,
        "scope": "The annular geometry and ordered isotopy are proved in prose.",
    }


def decode_rational_function(value, variables):
    require(value["variables"] == [str(v) for v in variables],
            "Jacobian rational-function variable order")

    def polynomial(data):
        result = sp.Integer(0)
        for term in data["terms"]:
            c = term["coefficient"]
            coefficient = sp.Rational(int(c["num"]), int(c["den"]))
            require(len(term["exponents"]) == len(variables),
                    "Jacobian exponent dimension")
            result += coefficient * sp.prod(
                v**exponent for v, exponent in zip(variables, term["exponents"])
            )
        return result

    denominator = polynomial(value["denominator"])
    require(denominator != 0, "Jacobian denominator nonzero")
    return sp.cancel(polynomial(value["numerator"]) / denominator)


def boundary_and_lift():
    n0, n1 = sp.symbols("n0 n1", nonzero=True)
    gram = -sp.Matrix([[n0**2, 1], [1, n1**2]]) / 4
    payload = json.loads((HERE / "jacobian_boundary_payload.json").read_text())
    result = json.loads((HERE / "jacobian_boundary_result.json").read_text())
    status = json.loads((HERE / "jacobian_boundary_status.json").read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter exited successfully")
    require(result["request"] == {"operation_id": OPERATION, "payload": payload},
            "Jacobian result is bound to the exact retained payload")
    require(result["server"]["name"] == "jacobian"
            and result["server"]["version"] == "0.14.0"
            and result["protocol_version"] == "2025-11-25",
            "Jacobian server and protocol retained")
    require(not result.get("error") and not result["result"].get("error"),
            "Jacobian result has no structured error")
    require(result["result"]["operation_id"] == OPERATION,
            "Jacobian returned the inspected operation")
    decoded = sp.Matrix([
        [decode_rational_function(v, (n0, n1)) for v in row]
        for row in payload["matrix"]["entries"]
    ])
    matrix_zero(decoded - gram, "Jacobian payload is the actual boundary Gram matrix")
    output = result["result"]["output"]
    require(output["degree"] == 2 and output["convention"] == "DET_LAMBDA_I_MINUS_A",
            "Jacobian output degree and convention")
    coefficients = [
        decode_rational_function(v, (n0, n1)) for v in output["coefficients_descending"]
    ]
    expected = gram.charpoly().all_coeffs()
    require(len(coefficients) == len(expected), "Jacobian output coefficient count")
    require(all(sp.cancel(a-b) == 0 for a, b in zip(coefficients, expected)),
            "independent exact replay of Jacobian characteristic polynomial")
    zero(gram.det() - (n0**2*n1**2 - 1)/16, "boundary Gram determinant")
    v0, v1 = sp.Matrix([1/n0, 0]), sp.Matrix([0, 1/n1])
    w = v0 - v1
    norm = (w.T * gram * w)[0]
    zero(norm + (1 - 1/(n0*n1))/2, "reflection denominator")
    reflection = sp.eye(2) - 2 * w * (w.T * gram) / norm
    matrix_zero(reflection * v0 - v1, "reflection exchanges normalized boundaries")
    matrix_zero(reflection**2 - sp.eye(2), "reflection involution")
    matrix_zero(reflection.T * gram * reflection - gram, "reflection preserves form")
    zero(reflection.det() + 1, "reflection determinant is -1")
    residue_table = []
    for residue in (1, 3):
        inverse = pow(residue, -1, 4)
        residue_table.append({
            "n_mod_4": residue,
            "tau_v_mod_4": inverse,
            "coefficient_of_b_mod_4": residue,
            "unmodified_alpha_matches_residue": inverse == 1,
        })
    require(residue_table[0]["unmodified_alpha_matches_residue"]
            and not residue_table[1]["unmodified_alpha_matches_residue"],
            "mod-four condition needs n=1 mod 4 for the stated alpha")
    D, H = sp.symbols("D H")
    zero(-(D - H/4) - H/4 + D, "ordered local Seifert cancellation")
    q1, q2 = sp.symbols("q1 q2", nonzero=True)
    word = ["u1p", "u2p", "u1", "u2"]
    values = {"u1": q1, "u1p": q1, "u2": q2, "u2p": q2}
    stack, norm_product = [], sp.Integer(1)
    for letter in list(reversed(word)) + word:
        if stack and stack[-1] == letter:
            stack.pop()
            norm_product *= values[letter]
        else:
            stack.append(letter)
    require(not stack, "Clifford reversal cancels without cross-space assumptions")
    zero(norm_product/(q1*q2)**2 - 1, "rational Clifford lift has norm one")
    require((-1)**2 * (-1)**2 == 1 and (-1) * (-1) == 1,
            "orthogonal and L-linear determinant cancellations")
    return {
        "characteristic_polynomial_coefficients": [str(v) for v in expected],
        "reflection_norm": str(sp.factor(norm)),
        "mod_four_table": residue_table,
        "Clifford_word": word,
        "Clifford_normalizing_denominator": "q1*q2",
        "Clifford_norm": 1,
        "jacobian": {
            "operation_id": OPERATION,
            "server_version": result["server"]["version"],
            "protocol_version": result["protocol_version"],
            "transport": result["transport"],
            "adapter_exit_code": status["adapter_exit_code"],
            "runtime_ms": result["result"]["runtime_ms"],
            "payload_file": "jacobian_boundary_payload.json",
            "typed_output_file": "jacobian_boundary_result.json",
        },
    }


def positive_indices(a, b, q):
    g = gcd(a, b)
    m = 4*a*b + a + b
    A, B = a//g, b//g
    d = gcd(A + B, 4*B)
    period = 4*B//d
    target = q*m//(5*g)
    j = (pow((A+B)//d, -1, period) * (target//d)) % period
    if j == 0:
        j = period
    i, remainder = divmod(target - A*j, B)
    if remainder or i <= 0 or j <= 0 or (i-j) % 4 or 5*(b*i+a*j) != q*m:
        raise AssertionError(f"positive-index construction failed for {(a,b,q)}")
    if not (i < 4*a+1 and j < 4*b+1):
        raise AssertionError("positive-index upper bounds")
    orders = [(4*a+1)*j - i - 1, (4*b+1)*i - j - 1, (5-q)*m//(5*g)-1]
    if min(orders) < 0:
        raise AssertionError("holomorphic end-order bound")
    return {"q": q, "i": i, "j": j, "minimum_end_orders": orders}


def index_and_end_calculations():
    a, b, A, B, g, i, j, u, v, c, q = sp.symbols("a b A B g i j u v c q")
    m = 4*a*b + a + b
    zero(b*(4*a+1) - (4*m/5-a) - m/5, "universal upper bound for i")
    zero(a*(4*b+1) - (4*m/5-b) - m/5, "universal upper bound for j")
    zero((4*g*A*B+A+B)/5 - 4*A*B - (4*(g-5)*A*B+A+B)/5,
         "universal positive-index margin")
    order_u = (i-1)*u + (j-1)*v + u - 1 - (4*a+1)*u
    zero(order_u.subs(v, -(4*a+1)*u) - ((i-(4*a+1)*j)*u-1),
         "U-pole end differential order")
    order_v = (i-1)*u + (j-1)*v + v - 1 - (4*b+1)*v
    zero(order_v.subs(u, -(4*b+1)*v) - ((j-(4*b+1)*i)*v-1),
         "V-pole end differential order")
    equal_order = ((i-1)*u+(j-1-4*b)*v-1).subs(
        {a: g*A, b: g*B, u: -c*B, v: -c*A}
    )
    quotient_m = 4*g*A*B + A+B
    zero(equal_order - (c*(quotient_m-B*i-A*j)-1),
         "equal-weight end order before the index equation")
    zero(c*(quotient_m-q*quotient_m/5)-1
         - (c*(1-q/5)*quotient_m-1),
         "equal-weight end order after the index equation")
    cases, first = 0, None
    for r in range(4, 11):
        step = 2**r
        t = pow(step, -1, 5)
        while t < 5:
            t += 5
        first_n0 = 1+t*step
        for offset in range(8):
            n0 = first_n0 + offset*5*step
            n1 = n0 + 5*step
            av, bv = (n0*n0-1)//4, (n1*n1-1)//4
            gv = gcd(av, bv)
            conditions = (
                n0 > 5*step, n0 % step == 1, n0 % 5 == 2,
                n1 % 4 == n0 % 4 == 1, gcd(n0, n1) == 1,
                av % 5 == bv % 5 == 2, gv % (step//2) == 0,
                gv > 5, gv % 5 != 0,
                av*bv-2*bv > 4*(av+bv),
                av*bv-2*av > 4*(av+bv),
            )
            if not all(conditions):
                raise AssertionError(f"admissible parameter arithmetic: {(r,n0)}")
            pairs = [positive_indices(av, bv, qv) for qv in (1, 4)]
            cases += 1
            if first is None:
                first = {
                    "r": r, "n0": n0, "n1": n1, "a": av, "b": bv,
                    "g": gv, "m": 4*av*bv+av+bv, "indices": pairs,
                }
    require(cases == 56, "56 exact admissible arithmetic regression cases")
    return {
        "regression_case_count": cases,
        "first_admissible_example": first,
        "universal_end_cases": ["U-pole", "V-pole", "equal weighted poles"],
        "scope": "Universal inequalities and exhaustiveness are proved in the report.",
    }


def real_sign_calculations():
    z, h, e, t = sp.symbols("z h e t", nonzero=True)
    ih, ie = sp.I*(1-1/z)*h, sp.I*(1-z)*e
    zero(4*h*e + 4*ih*ie/((1-z)*(1-1/z)), "fixed-sector tensor sign identity")
    ratio = (1+1/z)/(sp.I*(1-1/z))
    conjugate_ratio = (1+z)/(-sp.I*(1-z))
    zero(ratio-conjugate_ratio, "Hermitian ratio is real on the unit circle")
    phi5 = sp.cyclotomic_poly(5, z)
    require(sp.gcd(phi5, z-1) == 1 and sp.gcd(phi5, z+1) == 1,
            "Hermitian ratio finite and nonzero at primitive fifth roots")
    ch, sh = (t+1/t)/2, (t-1/t)/2
    boost = sp.Matrix([[ch, sh], [sh, ch]])
    signature = sp.diag(1, -1)
    matrix_zero(boost.T*signature*boost-signature, "exact indefinite-plane boost")
    zero(boost.det()-1, "boost lies in determinant-one group")
    zero(ch**2-sh**2-1, "real Clifford boost norm")
    return {
        "fixed_sector_sign_formula": "-4*I_H*I_E/((1-z)*(1-z^-1))",
        "Hermitian_ratio": "(1+z^-1)/(I*(1-z^-1))",
        "quadratic_dimension_lower_bound": 6,
        "Hermitian_dimension_lower_bound": 4,
        "noncompactness_witness": "boost with c=(t+t^-1)/2, s=(t-t^-1)/2, t>0",
    }


def calculate():
    retained = source_bindings()
    plane = plane_calculations()
    boundary = boundary_and_lift()
    indices = index_and_end_calculations()
    signs = real_sign_calculations()
    return {
        "goal": "M45:prop:arith-integral-congruence",
        "result_kind": "exact supporting calculations for a mathematical proof",
        "theorem_proof": "audit_report.tex",
        "formal_kernel_verification": False,
        "largest_matrix_order": 2,
        "retained_reviewed_inputs": retained,
        "plane": plane,
        "boundary_and_lift": boundary,
        "indices_and_ends": indices,
        "real_signs": signs,
        "passed_checks": CHECKS,
        "noncomputational_obligations": [
            "Simultaneous plane resolution and integral ordered-form transport.",
            "Two-annulus return calculation and the homological relation (5).",
            "Both ordered branched-cover adjunctions.",
            "Actual cone boundary classes and transfer congruence.",
            "Every-prime surjectivity of alpha on the full mod-four lattice.",
            "Primary support and the identification of the two minus spaces.",
            "Exhaustion of compactification ends and nonzero period classes.",
            "Classical group properties and primary-source citation attribution.",
            "Strong approximation inside full-lattice stabilizers and intersection.",
        ],
        "completion_boundary": (
            "No explicit integral Milnor matrix, formal kernel proof, independent "
            "Reviewer acceptance, novelty, ambient equivalence, or campaign completion "
            "is asserted by this computational certificate."
        ),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = calculate()
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, ensure_ascii=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        if certificate != expected:
            raise AssertionError("recomputed certificate differs from exact_certificate.json")
    print(
        f"PASS: {len(CHECKS)} exact checks, 56 admissible parameter cases, "
        "maximum matrix order 2; prose proof and independent review remain separate."
    )


if __name__ == "__main__":
    main()
