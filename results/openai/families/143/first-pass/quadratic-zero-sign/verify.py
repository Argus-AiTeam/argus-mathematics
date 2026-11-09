#!/usr/bin/env python3
"""Replay exact endpoint identities and the polynomial sign-certificate data."""

import argparse
import json
from fractions import Fraction
from math import isqrt
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parent


def zero(name, expression, identities):
    numerator = sp.fraction(sp.cancel(expression))[0]
    if sp.expand(numerator) != 0:
        raise AssertionError(f"{name}: nonzero exact residual {sp.factor(numerator)}")
    identities.append(name)


def polynomial_terms(expression, variables):
    polynomial = sp.Poly(expression, *variables, domain=sp.QQ)
    return {
        "terms": [
            {
                "coefficient": {"num": str(coefficient.p), "den": str(coefficient.q)},
                "exponents": list(exponents),
            }
            for exponents, coefficient in polynomial.terms()
            if coefficient
        ]
    }


def rational_function(expression, variables):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    leading = sp.Poly(denominator, *variables, domain=sp.QQ).LC()
    return {
        "domain": "QQ",
        "variables": [str(v) for v in variables],
        "numerator": polynomial_terms(numerator / leading, variables),
        "denominator": polynomial_terms(denominator / leading, variables),
    }


def decode_function(value, variables):
    if value["variables"] != [str(v) for v in variables]:
        raise AssertionError("Jacobian variable order changed")

    def decode(polynomial):
        return sum(
            sp.Rational(t["coefficient"]["num"], t["coefficient"]["den"])
            * sp.prod(v**e for v, e in zip(variables, t["exponents"], strict=True))
            for t in polynomial["terms"]
        )

    return decode(value["numerator"]) / decode(value["denominator"])


def endpoint_identities():
    m, n, ell, w, schwarzian = sp.symbols("m n ell w schwarzian")
    variables = (m, n, ell, w, schwarzian)
    identities = []

    def derivative(expression):
        return (
            sp.diff(expression, m)
            + ell * sp.diff(expression, n)
            + ell * w * sp.diff(expression, ell)
            + (schwarzian + w**2 / 2) * sp.diff(expression, w)
        )

    x = (ell / m - 1 / n) / (1 + ell)
    z_endpoint = (ell * m - n) / (1 + ell)
    gamma = (ell / m**2 + 1 / n**2) / (1 + ell)
    xm, zm, gm = map(derivative, (x, z_endpoint, gamma))
    xmm, zmm, gmm = map(derivative, (xm, zm, gm))
    coefficient = 1 - 2 * n / m + ell * (2 * m / n - 1)
    dstar = (m - n) * schwarzian + coefficient * w + (m + n) * w**2 / 2
    wstar = 2 * (ell * m**4 - 2 * ell * m**3 * n + 2 * m * n**3 - n**4)
    wstar /= m**2 * n**2 * (m + n)
    prefactor = ell**2 * (m + n)**2 / (m**2 * n**2 * (1 + ell) ** 3)
    determinant = xm * zmm - zm * xmm
    zero("endpoint_determinant", determinant - prefactor * dstar, identities)
    zero("Z_first_derivative", zm - w * ell * (m + n) / (1 + ell) ** 2, identities)
    zero(
        "X_first_derivative",
        xm - ell * (1 / n**2 - 1 / m**2) / (1 + ell) - zm / (m * n),
        identities,
    )
    at_zero = -(coefficient * w + (m + n) * w**2 / 2) / (m - n)
    gamma_factor = ell * (m + n) ** 2 * (wstar - w)
    gamma_factor /= (1 + ell) * m**2 * n**2 * (m - n)
    zero(
        "gamma_factor_cleared_Xm",
        (gmm * xm - xmm * gm - xm * gamma_factor).subs(schwarzian, at_zero),
        identities,
    )
    kappa, rr, sr, rrr, srr, slope = sp.symbols("kappa R S Rr Sr slope")
    zero(
        "fixed_model_parameter_determinant",
        kappa * rr * (slope * rrr + 3 * kappa * srr)
        - (slope * rr + 3 * kappa * sr) * kappa * rrr
        - 3 * kappa**2 * (rr * srr - sr * rrr),
        identities,
    )
    a, c, fx, gx, fxx, gxx = sp.symbols("a c fx gx fxx gxx")
    zero(
        "coordinate_determinant",
        (a * fx) * (a**2 * gxx + c * gx)
        - (a * gx) * (a**2 * fxx + c * fx)
        - a**3 * (fx * gxx - gx * fxx),
        identities,
    )
    sigma0, sigma, gamma1, gamma2 = sp.symbols("sigma0 sigma gamma1 gamma2")
    zero(
        "coordinate_gamma_at_zero",
        (
            (a**2 * gamma2 + c * gamma1 - sigma0 * a * gamma1)
            - a**2 * (gamma2 - sigma * gamma1)
        ).subs(c, sigma0 * a - sigma * a**2),
        identities,
    )
    scale, zz, ww, ss, dd, bb, d, b = sp.symbols("N z v s delta beta d b")
    substitutions = {m: scale * zz, n: scale, w: ww / scale, schwarzian: ss / scale**2}
    zero(
        "endpoint_normalization_Dstar",
        dstar.subs(substitutions) - dstar.subs({m: zz, n: 1, w: ww, schwarzian: ss}) / scale,
        identities,
    )
    zero(
        "endpoint_normalization_wstar",
        wstar.subs({m: scale * zz, n: scale}) - wstar.subs({m: zz, n: 1}) / scale,
        identities,
    )
    zero(
        "endpoint_normalization_gamma_factor",
        gamma_factor.subs(substitutions)
        - gamma_factor.subs({m: zz, n: 1, w: ww}) / scale**4,
        identities,
    )
    schwarzian_formula = (
        2 * b * (m + n * ell**2)
        + d**2 * (ell**2 - 1) / 2
        - d * (1 / m + ell**2 / n)
        + sp.Rational(3, 2) * (ell**2 / n**2 - 1 / m**2)
    )
    zero(
        "endpoint_normalization_Schwarzian",
        schwarzian_formula.subs({m: scale * zz, n: scale, d: dd / scale, b: bb / scale**3})
        - schwarzian_formula.subs({m: zz, n: 1, d: dd, b: bb}) / scale**2,
        identities,
    )
    y, u, vv, nu = sp.symbols("y u V nu")
    uy = d*u+b*u**2-y
    vy = -(b*u+d/2)*vv
    zero("regular_linearization_U", uy*vv+u*vy-(d*u*vv/2-y*vv), identities)
    zero(
        "positive_V_scalar_equation",
        sp.diff(vy, u)*uy+sp.diff(vy, vv)*vy-(b*y+d**2/4)*vv,
        identities,
    )
    potential_y = b*y+d**2/4-d/(2*y)+sp.Rational(3,4)/y**2
    zero(
        "endpoint_Schwarzian_from_common_label",
        schwarzian_formula-(-2*potential_y.subs(y,-m)+2*ell**2*potential_y.subs(y,n)),
        identities,
    )
    zero(
        "Riccati_integral_bound_cancellation",
        (2*b*m/(nu-d/2)+d+2*nu).subs(b,(d**2/4-nu**2)/m),
        identities,
    )
    potential, logarithmic_derivative = sp.symbols("potential logarithmic_derivative")
    zero(
        "solution_ratio_Schwarzian",
        -2 * potential + 6 * logarithmic_derivative**2
        - sp.Rational(3, 2) * (-2 * logarithmic_derivative) ** 2
        + 2 * potential,
        identities,
    )
    payload = {
        "left": {
            "variables": [str(v) for v in variables],
            "entries": [[rational_function(xm, variables), rational_function(-zm, variables)]],
        },
        "right": {
            "variables": [str(v) for v in variables],
            "entries": [[rational_function(zmm, variables)], [rational_function(xmm, variables)]],
        },
    }
    return identities, payload, determinant, variables


def sign_certificate():
    z, ell, d, b, s, v = sp.symbols("z ell d b s v")
    x = sp.symbols("x")
    identities = []
    k = z**2 * (z + 1)
    numerator = ell * z**3 * (z - 2) + 2 * z - 1
    threshold = 2 * numerator
    coefficient = z - 2 + ell * z * (2 * z - 1)
    t = 2 * ell * z**3 - ell * z**2 - z + 2
    aa = 2 * ell * z**3 - 3 * ell * z**2 + 3 * z - 2
    jj = threshold + z * coefficient
    s0 = sp.Rational(3, 2) * (ell**2 * z**2 - 1)
    s_arc = (
        2 * b * z**2 * (z + ell**2)
        + d**2 * (ell**2 - 1) * z**2 / 2
        - d * (z + ell**2 * z**2)
        + s0
    )
    f = v**2 + 2 * z * coefficient * v + 2 * z**2 * (z**2 - 1) * s
    zero(
        "small_endpoint_negative_threshold",
        numerator + (1 - z) ** 3 * (z + 1) + (ell - 1) * z**3 * (2 - z),
        identities,
    )
    zero(
        "large_endpoint_positive_threshold",
        numerator - (1 - ell) * (2 * z - 1) - ell * (z - 1) ** 3 * (z + 1),
        identities,
    )
    zero(
        "J_positive_interpolation",
        jj - (1 - ell) * ((z - 1) ** 2 + 4 * (z - 1) + 1)
        - ell * (2 * (z - 1) * (z + 1) * ((z - 1) ** 2 + (z - 1) + 1)),
        identities,
    )
    zero(
        "A_positive_interpolation",
        aa - (1 - ell) * (3 * (z - 1) + 1)
        - ell * (z - 1) * (2 * (z - 1) ** 2 + 3 * (z - 1) + 3),
        identities,
    )
    zero("Delta_factorization", z * (z + 1) - ell * k - threshold + (z - 1) * t, identities)
    zero(
        "monotonicity_remainder",
        f - f.subs(v, threshold) - (v - threshold) * (v - threshold + 2 * jj),
        identities,
    )
    zero("baseline_factorization", f.subs({v: threshold, s: s0}) - (z**2 - 1) * aa * t, identities)
    zero(
        "strict_baseline_improvement",
        s_arc - s0
        + (d**2 - 4 * b * z) * z**2 / 2
        - ell**2 * z**2 * (2 * b + d**2 / 2 - d) + d * z,
        identities,
    )
    zero(
        "last_subcase_S_rewrite",
        s_arc + (d**2 - 4 * b * z) * z**2 / 2
        - ell**2 * z**2 * (2 * b + d**2 / 2 - d + sp.Rational(3, 2))
        + d * z + sp.Rational(3, 2),
        identities,
    )
    zero("diagonal_before_division", f.subs(z, 1) - v * (v + 2 * (ell - 1)), identities)
    zero(
        "large_ell_coefficient",
        coefficient - (ell - 1) * z * (2 * z - 1) - 2 * (z**2 - 1),
        identities,
    )
    zero("T_negative_strong_slope", (z**2 * (2 * z - 1) - 3).subs(z, x + 2) - (2*x**3 + 11*x**2 + 20*x + 9), identities)
    w = sp.symbols("w")
    dstar = (z - 1) * s / z**2 + (1 - 2 / z + ell * (2 * z - 1)) * w + (z + 1) * w**2 / 2
    zero("cleared_Dstar_equivalence", f.subs(v, k*w) - 2*z**4*(z+1)*dstar, identities)
    positive_polynomials = {
        "J_at_ell_0": x**2 + 4*x + 1,
        "J_at_ell_1": 2*x*(x+2)*(x**2+x+1),
        "A_at_ell_0": 3*x+1,
        "A_at_ell_1": x*(2*x**2+3*x+3),
        "T_negative_margin_at_z_2_plus_x": 2*x**3+11*x**2+20*x+9,
    }
    for name, polynomial in positive_polynomials.items():
        coefficients = sp.Poly(sp.expand(polynomial), x).all_coeffs()
        if not all(c >= 0 for c in coefficients) or not any(c > 0 for c in coefficients):
            raise AssertionError(f"{name}: invalid positive-coefficient certificate")
    diagonal = f.subs({z: 1, ell: 2, v: 2})
    unit_ell = f.subs(s, s_arc).subs({z: 2, ell: 1, d: -2, b: 1, v: 0})
    t_zero_data = {z: 3, ell: sp.Rational(1,45), d: -2, b: 1}
    t_zero = t.subs(t_zero_data)
    t_zero_f = f.subs({v: threshold, s: s_arc}).subs(t_zero_data)
    radical_data = {z: 2, ell: sp.Rational(1,10), d: -2, b: sp.Rational(1,2)}
    radical_zero = (d**2-4*b*z).subs(radical_data)
    radical_upper = (1/z-ell+d*ell).subs(radical_data)
    radical_threshold = (threshold/k).subs(radical_data)
    if not (diagonal > 0 and unit_ell > 0 and t_zero == 0 and t_zero_f > 0):
        raise AssertionError("A diagonal, unit-ell or T=0 boundary regression failed")
    if radical_zero != 0 or not radical_upper < radical_threshold:
        raise AssertionError("The zero-radicand boundary regression failed")
    boundary_values = {
        "m_equals_n": {"z": "1", "ell": "2", "v": "2", "F": str(diagonal)},
        "ell_equals_1": {"z": "2", "ell": "1", "d": "-2", "b": "1", "v": "0", "F": str(unit_ell)},
        "T_equals_0": {"z": "3", "ell": "1/45", "d": "-2", "b": "1", "T": str(t_zero), "F_at_threshold": str(t_zero_f)},
        "zero_radicand": {"z": "2", "ell": "1/10", "d": "-2", "b": "1/2", "radicand": str(radical_zero), "Riccati_w_upper": str(radical_upper), "wstar": str(radical_threshold)},
    }
    return {
        "identities": identities,
        "positive_coefficient_certificates": {name: str(sp.expand(p)) for name, p in positive_polynomials.items()},
        "branches": [
            "z<1: actual-arc ell>1 and v>0 force W-v<0; z-1<0.",
            "z=1: F=v*(v+2*(ell-1))>0, so no division by z-1 is made.",
            "z>1, ell>=1: d<0, v>=0 force s>0 and F>0; ell=1 is included.",
            "z>1, 0<ell<1, v>=W, T>=0: Riccati excludes d^2>=4bz, including equality; s>s0, F(W)>0 and F(v)>=F(W). T=0 is included.",
            "z>1, 0<ell<1, v>=W, T<0, d^2<=4bz: endpoint slope bound gives -dz>2, hence s>0 and F>0.",
            "z>1, 0<ell<1, v>=W, T<0, d^2>4bz: Riccati gives r*z<1 for r^2=d^2-4bz; then s>0 and F>0.",
        ],
        "boundary_regressions_not_actual_arc_witnesses": boundary_values,
        "formal_core": "Main.lean: endpoint_zero_sign; all real variables, no sampling or desired-sign hypothesis.",
    }


def rational_root(value):
    if value < 0:
        return None
    numerator, denominator = isqrt(value.numerator), isqrt(value.denominator)
    return Fraction(numerator, denominator) if numerator**2 == value.numerator and denominator**2 == value.denominator else None


def adversarial_rational_search():
    tested = 0
    admissible = 0
    examples = []
    for z in map(Fraction, ("1/2", "2/3", "1", "3/2", "2", "3", "4")):
        for ell in map(Fraction, ("1/4", "1/2", "1", "2", "3")):
            for d in map(Fraction, ("-4", "-2", "-1", "0", "1")):
                for b in map(Fraction, ("1/8", "1/2", "1", "2")):
                    s = 2*b*(z+ell**2) + d*d*(ell**2-1)/2 - d*(1/z+ell**2) + Fraction(3,2)*(ell**2-1/z**2)
                    coefficient = 1-2/z+ell*(2*z-1)
                    discriminant = coefficient**2-2*(z+1)*(z-1)*s
                    root = rational_root(discriminant)
                    if root is None:
                        continue
                    for w in {(-coefficient-root)/(z+1), (-coefficient+root)/(z+1)}:
                        tested += 1
                        if not d < (ell/z-1)/(1+ell):
                            continue
                        if z <= 1 and not (ell > 1 and w > 0):
                            continue
                        if z > 1 and not (d < 0 and (ell < 1 or w >= 0)):
                            continue
                        q = d*d-4*b*z
                        if d < 0 and q >= 0:
                            margin = 1/z-ell+d*ell-w
                            if margin < 0 or margin*margin < q:
                                continue
                        admissible += 1
                        wstar = 2*(ell*z**3*(z-2)+2*z-1)/(z*z*(z+1))
                        if z == 1 or (wstar-w)/(z-1) <= 0:
                            raise AssertionError(f"Endpoint-constraint countermodel: {(z,ell,d,b,w)}")
                        examples.append({key: str(value) for key,value in zip(("z","ell","d","b","w","positive_quotient"),(z,ell,d,b,w,(wstar-w)/(z-1)),strict=True)})
    return {"rational_zero_tuples_tested": tested, "full_constraint_tuples": admissible, "countermodels": 0, "nonvacuity_examples_not_claimed_realizable": examples, "scope": "Finite adversarial regression only, not a proof or a claim of actual-arc realization."}


def formal_evidence():
    source = (ROOT / "Main.lean").read_text()
    fidelity = (ROOT / "statement-fidelity.md").read_text()
    matches = []
    for path in sorted((ROOT / "certificates").glob("V_QUADRATIC_ZERO_SIGN-*.json")):
        archive = json.loads(path.read_text())
        check = archive["lean_check"]
        if (
            archive["lean_source"]["text"] == source
            and archive["statement_fidelity"]["text"] == fidelity
            and check["status"] == "success"
            and check["exit_code"] == 0
            and check["proof_holes"] == []
        ):
            matches.append((path,check))
    if len(matches) != 1:
        raise AssertionError(f"Expected one successful compiler archive for the current source and fidelity; found {len(matches)}")
    path,check = matches[0]
    if "sorryAx" in check["stdout"]:
        raise AssertionError("Compiler axiom audit contains a proof hole")
    for name in ("endpoint_zero_sign","endpoint_gamma_positive"):
        if f"'QuadraticZeroSign.{name}' depends on axioms:" not in check["stdout"]:
            raise AssertionError(f"Missing compiler axiom audit for {name}")
    canonical = ROOT / "statement_fidelity.md"
    if canonical.read_text() != fidelity:
        raise AssertionError("The verifier's canonical fidelity document differs from the submitted reading")
    return {
        "archive": str(path.relative_to(ROOT)),
        "status": check["status"],
        "exit_code": check["exit_code"],
        "proof_holes": check["proof_holes"],
        "lean_version": check["tools"]["lean"]["version"],
        "current_source_equals_compiled_source": True,
        "current_fidelity_equals_compiled_fidelity": True,
        "axiom_audit": check["stdout"].strip().splitlines(),
        "replay_scope": "Exact comparison to a real compiler archive; this Python invocation does not rerun Lean.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    args = parser.parse_args()
    identities, payload, determinant, variables = endpoint_identities()
    if args.write_jacobian_payload:
        (ROOT / "jacobian" / "determinant-payload.json").write_text(json.dumps(payload, indent=2) + "\n")
    jacobian_result = ROOT / "jacobian" / "determinant-output.json"
    jacobian = {"operation_id": "matrix.symbolic.multiply.compute", "status": "not_yet_executed"}
    if jacobian_result.exists():
        if json.loads((ROOT / "jacobian" / "determinant-payload.json").read_text()) != payload:
            raise AssertionError("Retained Jacobian payload does not equal the reconstructed endpoint determinant")
        output = json.loads(jacobian_result.read_text())
        discovery = json.loads((ROOT / "jacobian" / "discovery.json").read_text())
        result = output.get("result", {})
        jacobian = {
            "operation_id": "matrix.symbolic.multiply.compute",
            "discovery_server": discovery["server"],
            "discovery_protocol_version": discovery["protocol_version"],
            "operation_response_server": output.get("server"),
            "operation_response_protocol_version": output.get("protocol_version"),
            "adapter_status": json.loads((ROOT / "jacobian" / "determinant-status.json").read_text()),
            "structured_error": output.get("error"),
            "status": "non_conclusion",
        }
        typed = result.get("result", result)
        if "entries" in typed:
            zero("Jacobian_exact_determinant_replay", decode_function(typed["entries"][0][0], variables) - determinant, identities)
            jacobian["status"] = "exact_product_replayed"
        else:
            jacobian["structured_result"] = result
    certificate = {
        "claim_id": "V_QUADRATIC_ZERO_SIGN",
        "result_class": "exact_verification_theorem",
        "scope": "Complete normalized quadratic endpoint sign obstruction, conditional analytic bridge to model:zero-sign; no global cycle theorem or novelty certification.",
        "coefficient_domain": "QQ for identities; universally quantified real inequalities in Main.lean",
        "nonvanishing_requirements": [
            "m,n,ell>0; 1+ell>0; the endpoint normalization N=n is positive and constant at the point.",
            "X_m>0 follows from kappa*R/m_r>0 on actual arcs, not from arbitrary endpoint jets.",
            "m-n is divided by only after the diagonal has been excluded.",
        ],
        "endpoint_identities": identities,
        "sign_certificate": sign_certificate(),
        "formal_evidence": formal_evidence(),
        "adversarial_regression": adversarial_rational_search(),
        "jacobian": jacobian,
        "independent_review": "pending_host_invocation",
        "false_manuscript_assertions_identified": [],
    }
    destination = ROOT / "exact_certificate.json"
    if args.write_certificate:
        destination.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        recorded = json.loads(destination.read_text())
        if recorded != certificate:
            raise AssertionError("exact_certificate.json differs from the exact replay; inspect before regenerating")
    print(json.dumps({"ok": True, "endpoint_identities": len(identities), "sign_identities": len(certificate["sign_certificate"]["identities"]), "branches": len(certificate["sign_certificate"]["branches"]), "adversarial_regression": certificate["adversarial_regression"], "jacobian_status": jacobian["status"]}, indent=2))


if __name__ == "__main__":
    main()
