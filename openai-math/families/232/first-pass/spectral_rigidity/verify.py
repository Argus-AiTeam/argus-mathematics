#!/usr/bin/env python3
"""Replay exact algebra and source bindings; do not certify the analytic proof."""

import json
import re
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def zero(expression, name):
    require(sp.simplify(sp.together(expression)) == 0, name)
    return "0"


def nonnegative_polynomial(expression, variables, name):
    polynomial = sp.Poly(sp.expand(expression), *variables)
    require(all(coefficient >= 0 for coefficient in polynomial.coeffs()), name)
    return sp.sstr(sp.expand(expression))


def polynomial(record, variables):
    require(record["domain"] == "QQ", "Jacobian polynomial must be over QQ")
    require(record["variables"] == ["k", "l"], "Jacobian variables changed")
    return sum(
        sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
        * sp.prod(variable**power for variable, power in zip(variables, term["exponents"], strict=True))
        for term in record["polynomial"]["terms"]
    )


def check_jacobian(k, l):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "polynomial.multivariate.factor.compute"
    require(status == {"adapter_exit_code": 0, "timeout_seconds": 45}, "Adapter did not succeed")
    require(contract["result"]["operation"]["operation_id"] == operation, "Wrong inspected operation")
    require(response["request"] == {"operation_id": operation, "payload": payload}, "Payload binding differs")
    require(response["result"]["operation_id"] == operation, "Wrong executed operation")
    for envelope in (contract, response):
        require(envelope["server"]["version"] == "0.14.0", "Server version changed")
        require(envelope["protocol_version"] == "2025-11-25", "Protocol changed")
    output = response["result"]["output"]
    require(output["status"] == "FACTORIZED", "No mathematical Jacobian factorization")
    require(output["product_reconstruction"] == "EXACT", "Inexact Jacobian reconstruction")
    requested = polynomial(payload["polynomial"], (k, l))
    require(requested == k**4 - 6*k**2*l**2 + l**4, "Wrong harmonic polynomial")
    reconstructed = sp.Rational(output["coefficient"]["num"], output["coefficient"]["den"])
    for factor in output["factors"]:
        reconstructed *= polynomial(factor["factor"], (k, l)) ** factor["multiplicity"]
    zero(reconstructed - requested, "Jacobian factors fail independent reconstruction")
    zero(polynomial(output["reconstructed"], (k, l)) - requested, "Returned source differs")
    return "EXACT"


def exact_checks():
    k, l = sp.symbols("k l", real=True)
    a, s, r = sp.symbols("a s r", positive=True)
    u, v, epsilon = sp.symbols("u v epsilon", nonnegative=True)
    x = sp.symbols("x", real=True)
    results = {}

    def chi(horizontal, normal):
        return 1 - 8*horizontal**2*normal**2/(horizontal**2 + normal**2)**2

    numerator = k**4 - 6*k**2*l**2 + l**4
    results["jacobian_factorization"] = check_jacobian(k, l)
    results["harmonic_factorization"] = zero(
        numerator - (k**2 - 2*k*l - l**2)*(k**2 + 2*k*l - l**2),
        "Fourth harmonic factorization",
    )
    results["bounded_harmonic_slack"] = zero(
        2*(k**2 + l**2)**2 - 8*k**2*l**2 - 2*(k**2 - l**2)**2,
        "|chi| <= 1 sum-of-squares certificate",
    )
    rotation = sp.Matrix([
        [sp.Rational(1, 2), -sp.sqrt(3)/2],
        [sp.sqrt(3)/2, sp.Rational(1, 2)],
    ])
    vector = sp.Matrix([k, l])
    orbit = [rotation**j * vector for j in range(6)]
    results["rotation_preserves_radius"] = zero(
        (rotation * vector).dot(rotation * vector) - vector.dot(vector),
        "Rotation norm",
    )
    results["sixfold_harmonic_sum"] = zero(
        sum(chi(point[0], point[1]) for point in orbit),
        "Sixfold cancellation",
    )
    normal0 = sp.Matrix([0, 1])
    normal1 = rotation * normal0
    results["independent_normals_determinant_squared"] = sp.sstr(
        sp.det(sp.Matrix.hstack(normal0, normal1))**2
    )
    require(results["independent_normals_determinant_squared"] == "3/4", "Parallel chart normals")

    results["partial_fraction_identity"] = zero(
        x**2/((x**2 + a**2)*(x**2 + s**2))
        - (a**2/(x**2 + a**2) - s**2/(x**2 + s**2))/(a**2 - s**2),
        "Unintegrated partial fractions",
    )
    results["arctangent_primitive"] = zero(
        sp.diff(sp.atan(x/a)/a, x) - 1/(x**2 + a**2),
        "Elementary integral primitive",
    )
    results["differentiated_cauchy_integral"] = zero(
        -sp.diff(sp.pi/(a+s), a)/(2*a) - sp.pi/(2*a*(a+s)**2),
        "Differentiated parameter integral",
    )
    integrand = chi(a, x)*s/(sp.pi*(s**2 + x**2))
    generic_integral = sp.factor(
        2*sp.pi*sp.I*(sp.residue(integrand, x, sp.I*a) + sp.residue(integrand, x, sp.I*s))
    )
    results["cauchy_poisson_residual"] = zero(
        generic_integral - (a-s)**2/(a+s)**2,
        "Generic Cauchy integral",
    )
    results["equal_scale_cauchy_integral"] = zero(
        2*sp.pi*sp.I*sp.residue(integrand.subs(s, a), x, sp.I*a),
        "Coincident Cauchy poles must be checked separately",
    )
    results["harmonic_complement_integral_over_pi_a"] = sp.sstr(sp.simplify(
        2*sp.pi*sp.I*sp.residue(8*a**2*x**2/(a**2+x**2)**2, x, sp.I*a)/(sp.pi*a)
    ))
    require(results["harmonic_complement_integral_over_pi_a"] == "4", "Wrong periodization mass")
    results["zero_scale_defect"] = sp.sstr(((a-s)**2/(a+s)**2).subs(s, 0))
    results["infinite_scale_defect"] = sp.sstr(sp.limit((a-s)**2/(a+s)**2, s, sp.oo))

    results["negative_cap_polynomial"] = zero(
        numerator - (l**2*(l**2 - 6*k**2) + k**4),
        "Negative cap confinement",
    )
    low_band = 3*((r+u)-(r/2-v)) - ((r+u)+(r/2-v))
    high_band = 3*((4*r+v)-(2*r-u)) - ((4*r+v)+(2*r-u))
    results["low_band_defect_slack"] = nonnegative_polynomial(
        low_band, (u, v), "Low normal scale D >= 1/9"
    )
    results["high_band_defect_slack"] = nonnegative_polynomial(
        high_band, (u, v), "High normal scale D >= 1/9"
    )
    low_scale = (1-epsilon)*a-u
    high_scale = (1+epsilon)*a+u
    results["low_ratio_gap_slack"] = nonnegative_polynomial(
        (2+epsilon)*(a-low_scale)-epsilon*(a+low_scale),
        (a, u, epsilon),
        "Low ratio gap",
    )
    results["high_ratio_gap_slack"] = nonnegative_polynomial(
        (2+epsilon)*(high_scale-a)-epsilon*(high_scale+a),
        (a, u, epsilon),
        "High ratio gap",
    )
    results["cauchy_density_square"] = zero(
        s**2 + a**2 - 2*s*a - (s-a)**2,
        "Uniform density bound",
    )
    results["arctangent_lower_bound_factorization"] = zero(
        1-4*x**2 - (1-2*x)*(1+2*x), "atan(1/2) >= 2/5"
    )
    results["central_cauchy_probability_lower_bound"] = sp.sstr(
        sp.Rational(2, 4)*sp.Rational(2, 5)
    )

    margins = {
        "normal_coordinate_lower": 1-sp.Rational(1, 100)-sp.Rational(19, 20)**2,
        "rotation_sine_lower": sp.Rational(3, 4)-sp.Rational(5, 6)**2,
        "rotation_sine_upper": sp.Rational(7, 8)**2-sp.Rational(3, 4),
        "rotated_tangent_lower": sp.Rational(5, 6)*sp.Rational(19, 20)-sp.Rational(1, 20)-sp.Rational(2, 3),
        "rotated_tangent_upper": 2-(2*sp.Rational(7, 8)+sp.Rational(1, 20)),
        "rotated_normal_lower": sp.Rational(19, 40)-sp.Rational(7, 80)-sp.Rational(1, 3),
        "rotated_normal_upper": sp.Rational(6, 5)-(1+sp.Rational(7, 80)),
        "interval_length_squared": 9-sp.Rational(16, 3),
    }
    require(all(value > 0 for value in margins.values()), "Endcap geometry margin is not positive")
    results["endcap_positive_margins"] = {name: sp.sstr(value) for name, value in margins.items()}

    theta = sp.symbols("theta", real=True)
    results["angular_integration_by_parts_identity"] = zero(
        sp.expand_trig(sp.sin(4*theta)*sp.tan(theta) - 4*sp.sin(theta)**2*sp.cos(2*theta)),
        "Scalar angular integration by parts",
    )
    results["angular_coefficient_over_pi"] = sp.sstr(sp.simplify(
        4*sp.integrate(sp.sin(theta)**2*sp.cos(2*theta), (theta, 0, sp.pi/2))/sp.pi
    ))
    require(results["angular_coefficient_over_pi"] == "-1/2", "Wrong unique-coefficient sign")
    j = sp.symbols("j", integer=True, nonnegative=True)
    results["infinite_dyadic_tail_multiplier"] = sp.sstr(sp.summation(sp.Rational(1, 2)**j, (j, 0, sp.oo)))

    A, B, z = sp.symbols("A B z", real=True)
    results["gaussian_alias_projection"] = zero(
        2*A/(A**2-B**2*(1+z)/2) - (4*A/B**2)/(2*A**2/B**2-1-z),
        "Two-sheet Gaussian mixture",
    )
    q, c = sp.symbols("q c", real=True)
    results["poisson_geometric_denominator"] = zero(
        (1-q**2)/(1-2*q*c+q**2)
        - ((1/q-q)/2)/((1/q+q)/2-c),
        "Periodized Cauchy closed form",
    )
    denominator = 6-2*sp.cos(k)-4*sp.cos(k/2)*sp.cos(sp.sqrt(3)*l/2)
    hessian = sp.hessian(denominator, (k, l)).subs({k: 0, l: 0})
    require(hessian == 3*sp.eye(2), "Gaussian infrared Hessian")
    results["gaussian_hessian"] = [[sp.sstr(entry) for entry in row] for row in hessian.tolist()]
    results["gaussian_scaling_coefficient"] = sp.sstr(2/hessian[0, 0])
    results["classification_only_distinct_coefficients"] = [
        sp.sstr(2+sp.sin(-sp.pi/2)), sp.sstr(2+sp.sin(sp.pi/2))
    ]
    atoms = [rotation**j * sp.Matrix([0, sp.Rational(1, 8)]) for j in range(6)]
    orbit_points = {tuple(sp.simplify(entry) for entry in point) for point in atoms}
    reflected_points = {(horizontal, -normal) for horizontal, normal in orbit_points}
    require(len(orbit_points) == 6 and reflected_points == orbit_points, "Atomic D6 symmetry")
    results["atomic_symmetry"] = "D6"
    squared_radii = {sp.simplify(point.dot(point)) for point in atoms}
    require(squared_radii == {sp.Rational(1, 64)}, "Wrong atomic radius")
    results["atomic_orbit_radius_squared"] = sp.sstr(squared_radii.pop())
    cutoff_scale = sp.Rational(1, 32)
    horizontal_ratios = {
        sp.simplify((point[0]/cutoff_scale)**2) for point in atoms if point[0] != 0
    }
    radial_ratio = sp.Rational(1, 64)/cutoff_scale**2
    require(horizontal_ratios == {12} and radial_ratio == 16, "Cutoff must vanish at every nonzero scaled coordinate")
    results["atomic_cutoff_scale"] = sp.sstr(cutoff_scale)
    results["atomic_nonzero_horizontal_ratio_squared"] = sp.sstr(horizontal_ratios.pop())
    results["atomic_radial_ratio_squared"] = sp.sstr(radial_ratio)
    atom_harmonics = [sp.simplify(chi(point[0], point[1])) for point in atoms]
    results["atomic_orbit_harmonics"] = [sp.sstr(value) for value in atom_harmonics]
    zero(sum(atom_harmonics), "Atomic orbit must be rotation invariant")
    cutoff_limit = -sum(
        value for point, value in zip(atoms, atom_harmonics, strict=True) if point[0] == 0
    )
    line_counterterm = sum(1 for point in atoms if point[0] == 0)
    results["atomic_error_raw_cutoff_limit"] = sp.sstr(cutoff_limit)
    results["atomic_error_line_counterterm"] = str(line_counterterm)
    results["atomic_error_corrected_cutoff_limit"] = sp.sstr(cutoff_limit + line_counterterm)
    results["atomic_error_uncorrected_coefficient_over_inverse_pi"] = sp.sstr(-2*cutoff_limit)
    require(cutoff_limit == -2 and line_counterterm == 2, "Necessary line correction not reproduced")
    return results


def check_sources(bindings):
    label_count = 0
    for binding in bindings:
        source = (ROOT / binding["path"]).read_text()
        compact_source = re.sub(r"\s+", "", source)
        for label in binding["labels"]:
            matches = re.findall(r"\\label\s*\{\s*" + re.escape(label) + r"\s*\}", source)
            require(len(matches) == 1, f"Source label missing or ambiguous: {label}")
            label_count += 1
        for fragment in binding["required_fragments"]:
            require(re.sub(r"\s+", "", fragment) in compact_source, f"Source formula changed: {fragment}")
    return label_count


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim_id"] == "S232-STABILITY", "Wrong theorem claim")
    require(certificate["independent_review"]["required"] is True, "Analytic review must remain separate from this replay")
    require(certificate["formal_verification"] is None, "No compiler evidence was produced")
    require(certificate["proof"]["kind"] == "analytic_not_kernel_checked", "Incorrect machine proof classification")
    require(certificate["conclusion"]["strict_positivity_claimed"] is False, "Strict positivity is outside scope")
    source_label_count = check_sources(certificate["source_bindings"])
    computed = exact_checks()
    require(computed == certificate["exact_checks"], "Computed exact checks differ from the certificate")
    print(json.dumps({
        "status": "PASS",
        "project_root": str(ROOT),
        "exact_checks": len(computed),
        "source_labels": source_label_count,
        "jacobian_status": "FACTORIZED",
        "machine_scope": "Exact scalar algebra, rational inequalities, source bindings, and saved typed output only.",
        "analytic_proof": "report.md; analytic acceptance is outside this replay; not kernel checked",
    }, indent=2))


if __name__ == "__main__":
    main()
