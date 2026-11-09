#!/usr/bin/env python3
"""Replay exact identities for the transport proof and its critical affine law."""

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent


def equal(actual, expected, label):
    residual = sp.simplify(sp.together(actual - expected))
    if residual != 0:
        raise AssertionError(f"{label}: nonzero exact residual {residual}")


def sparse_polynomial(data, variables):
    return sum(
        (
            sp.Rational(term["coefficient"]["num"], term["coefficient"]["den"])
            * sp.prod(
                variable**exponent
                for variable, exponent in zip(
                    variables, term["exponents"], strict=True
                )
            )
        )
        for term in data["terms"]
    )


def rational_function(data, variables):
    if data["variables"] != [str(variable) for variable in variables]:
        raise AssertionError("Jacobian variable order changed")
    return sparse_polynomial(data["numerator"], variables) / sparse_polynomial(
        data["denominator"], variables
    )


def verify():
    p, beta = sp.symbols("p beta", positive=True)
    k, a, b = sp.symbols("k a b", real=True)
    x, t, u = sp.symbols("x t u", real=True)
    y = sp.symbols("y", positive=True)
    z, w = sp.symbols("z w")
    checks = []

    def check(actual, expected, label):
        equal(actual, expected, label)
        checks.append(label)

    request = json.loads((HERE / "jacobian_request.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    operation = "matrix.symbolic.determinant.compute"
    if response["request"] != {
        "operation_id": operation,
        "payload": request,
    }:
        raise AssertionError("Saved Jacobian output does not bind the exact payload")
    if response.get("error") or response["result"].get("error"):
        raise AssertionError("Jacobian errors are not mathematical evidence")
    if response["result"]["operation_id"] != operation:
        raise AssertionError("Unexpected Jacobian operation")
    variables = (k, a, b)
    input_matrix = sp.Matrix(
        [
            [rational_function(entry, variables) for entry in row]
            for row in request["matrix"]["entries"]
        ]
    )
    determinant = rational_function(
        response["result"]["output"]["determinant"], variables
    )
    check(input_matrix.det(), determinant, "independent replay of typed determinant")
    j_numerator = k * (k - 1) + (2 * k - 1) * a + a**2 + b**2
    check(determinant, j_numerator, "critical-map Jacobian orientation")
    hessian = k / y**2 * sp.Matrix([[-(k + a), b], [b, k - 1 + a]])
    check(
        hessian.det(),
        -k**2 / y**4 * j_numerator,
        "critical Hessian determinant has the opposite Jacobian sign",
    )
    check(sp.trace(hessian), -k / y**2, "critical Hessian trace")
    check(
        j_numerator,
        (a + k - sp.Rational(1, 2)) ** 2 + b**2 - sp.Rational(1, 4),
        "zero-Jacobian circle",
    )

    inverse = sp.Matrix([-x / y, 1 / y])
    check(
        inverse.jacobian((x, y)).det(),
        y ** (-3),
        "affine inversion Jacobian, not hyperbolic inversion",
    )
    check(-inverse[0] / inverse[1], x, "affine inversion real involution")
    check(1 / inverse[1], y, "affine inversion height involution")
    modulus_squared = (x**2 + (y - 1) ** 2) / (x**2 + (y + 1) ** 2)
    check(
        ((x / y) ** 2 + (1 / y - 1) ** 2)
        / ((x / y) ** 2 + (1 / y + 1) ** 2),
        modulus_squared,
        "affine inversion preserves S0",
    )
    check(
        beta + p + 2 - 3,
        beta + p - 1,
        "inverse-area exponent after the y^-3 coordinate change",
    )
    general_k = (beta + p + 1) / (p + 2)
    check(
        (p + 2) * general_k,
        beta + p + 1,
        "submean tail exponent",
    )
    check(
        (p + 2) * (general_k - 1),
        beta - 1,
        "critical value and target weight agree",
    )
    check(
        (beta - 1) - beta,
        -1,
        "expected source density is dx dy/y",
    )
    check(
        general_k - sp.Rational(1, 2),
        (beta + p / 2) / (p + 2),
        "positive dyadic target-cover exponent",
    )

    qr, qi, dr, di = sp.symbols("qr qi dr di", real=True)
    radius_squared = qr**2 + qi**2
    power = radius_squared ** (p / 2)
    gradient_y = -di * sp.diff(power, qr) + dr * sp.diff(power, qi)
    a_over_y = (qi * dr - qr * di) / radius_squared
    check(
        gradient_y,
        p * power * a_over_y,
        "first derivative of the inverse-derivative weight",
    )
    laplacian = (dr**2 + di**2) * (
        sp.diff(power, qr, 2) + sp.diff(power, qi, 2)
    )
    check(
        laplacian,
        p**2 * radius_squared ** (p / 2 - 1) * (dr**2 + di**2),
        "holomorphic inverse-derivative weight Laplacian",
    )
    expected_numerator = (
        general_k * (general_k - 1)
        - (2 * general_k - 1) * beta / p
        + beta * (beta + 1) / p**2
    )
    expected_factor = (
        (beta + p + 1) * (4 * beta - p**2) / (p**2 * (p + 2) ** 2)
    )
    check(expected_numerator, expected_factor, "general expected Jacobian factor")
    check(
        expected_numerator.subs(p, 1),
        (beta + 2) * (4 * beta - 1) / 9,
        "inverse-first-power expected Jacobian",
    )
    check(
        expected_numerator.subs(p, 2),
        (beta + 3) * (beta - 1) / 16,
        "inverse-square expected Jacobian",
    )

    n, Y = sp.symbols("N Y", positive=True)
    box_ratio = (1 + n / Y) * (1 + 2 * sp.log(n) / sp.log(Y))
    check(sp.limit(box_ratio, Y, sp.oo), 1, "fixed-N enlarged box ratio limit")
    check(
        general_k.subs(beta, p**2 / 4),
        (p + 2) / 4,
        "quadratic-bound equality parameter",
    )

    def quadratic(vertex, point):
        return ((point - vertex) ** 2 - (sp.I - vertex) ** 2) / (
            2 * (sp.I - vertex)
        )

    Ft = quadratic(t, z)
    Ft_prime = sp.diff(Ft, z)
    check(Ft.subs(z, sp.I), 0, "quadratic normalization F(i)")
    check(Ft_prime.subs(z, sp.I), 1, "quadratic normalization Fprime(i)")
    check(
        Ft - quadratic(t, w),
        (z - w) * (z + w - 2 * t) / (2 * (sp.I - t)),
        "quadratic injectivity factorization on H",
    )
    rebased = (
        quadratic(t, x + y * w) - quadratic(t, x + sp.I * y)
    ) / (y * Ft_prime.subs(z, x + sp.I * y))
    check(
        rebased,
        quadratic((t - x) / y, w),
        "entire affine orbit of normalized quadratics",
    )
    check(
        sp.limit(Ft, t, sp.oo), z - sp.I, "affine limit at the compactified vertex"
    )
    q = -sp.I * y / (x + sp.I * y - t)
    q_real = sp.simplify(sp.re(q))
    q_imag = sp.simplify(sp.im(q))
    check(
        q_real + q_real**2 + q_imag**2,
        0,
        "quadratic critical-map Jacobian vanishes at k=1",
    )
    G = quadratic(t, x + sp.I * y) - sp.I * y * Ft_prime.subs(
        z, x + sp.I * y
    )
    check(
        G,
        ((x - t) ** 2 + y**2 - (sp.I - t) ** 2) / (2 * (sp.I - t)),
        "degenerate critical map has a one-dimensional image",
    )
    check(
        1 / sp.diff(Ft, z, 2) * Ft_prime,
        z - t,
        "quadratic pre-Schwarzian reciprocal",
    )
    density = 1 / (sp.pi * (1 + t**2))
    squared_weight = (1 + t**2) / ((t - x) ** 2 + y**2)
    check(
        (density * squared_weight).subs(t, x + y * u) * y,
        1 / (y * sp.pi * (1 + u**2)),
        "Cauchy-law covariance density for all affine coordinates",
    )
    check(
        sp.diff(sp.atan(t), t),
        1 / (1 + t**2),
        "Cauchy normalization antiderivative",
    )
    mass = (
        sp.limit(sp.atan(t), t, sp.oo) - sp.limit(sp.atan(t), t, -sp.oo)
    ) / sp.pi
    check(mass, 1, "Cauchy probability has mass one")
    check(
        squared_weight.subs(y, 1) * (1 + (t - x) ** 2),
        1 + t**2,
        "tilted vertex measure is translation invariant",
    )
    check(
        sp.integrate(-density / (1 + t**2), (t, -sp.oo, sp.oo)),
        -sp.Rational(1, 2),
        "Cauchy endpoint first logarithmic-derivative moment",
    )
    check(
        sp.integrate(density / (1 + t**2), (t, -sp.oo, sp.oo)),
        sp.Rational(1, 2),
        "Cauchy endpoint squared logarithmic-derivative moment",
    )
    disk_variable = sp.symbols("zeta")
    disk_map = quadratic(0, sp.I * (1 + disk_variable) / (1 - disk_variable)) / (
        2 * sp.I
    )
    check(
        disk_map,
        disk_variable / (1 - disk_variable) ** 2,
        "the zero-vertex quadratic is exactly the Koebe map in disk coordinates",
    )
    general_disk_map = quadratic(
        t, sp.I * (1 + disk_variable) / (1 - disk_variable)
    ) / (2 * sp.I)
    check(
        general_disk_map,
        disk_variable
        * (1 + t * disk_variable / (sp.I - t))
        / (1 - disk_variable) ** 2,
        "general quadratic disk map, not an assumed rotation of Koebe",
    )
    boundary_phase = (t - sp.I) / (t + sp.I)
    check(
        sp.im(sp.diff(boundary_phase, t) / boundary_phase),
        2 / (1 + t**2),
        "Cauchy vertex density is uniform boundary-parameter phase",
    )

    return {
        "certificate_version": 1,
        "result_class": "new_theorem",
        "claim": "C_AT_ENDPOINT",
        "statement": (
            "An inverse-square weighted affine probability law on K with "
            "beta>=1 exists exactly at beta=1 and is uniquely the normalized "
            "quadratic family F_t with vertex density 1/(pi*(1+t^2))."
        ),
        "quantifiers": {
            "vertex": "all real t",
            "affine_coordinates": "all real x and all y>0",
            "test_functions": (
                "all nonnegative Borel tests, by the exact pushforward density "
                "identity and the change-of-variables argument in report.md"
            ),
        },
        "witness": {
            "F_t(z)": "((z-t)^2-(i-t)^2)/(2*(i-t))",
            "vertex_density": "1/(pi*(1+t^2))",
            "rebased_vertex": "(t-x)/y",
            "beta": 1,
            "root_moments": {"E[a]": "-1/2", "E[abs(q)^2]": "1/2", "E[J]": "0"},
        },
        "general_expected_k_squared_J": str(sp.factor(expected_factor)),
        "exact_checks": checks,
        "jacobian": {
            "operation_id": operation,
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "transport": response["transport"],
            "payload_file": "jacobian_request.json",
            "typed_output_file": "jacobian_result.json",
            "adapter_exit_status": 0,
            "adapter_error": None,
            "adapter_timeout": False,
            "independently_recomputed": True,
        },
        "scope": {
            "machine_checked": (
                "Exact symbolic identities, box-factor limit, full-parameter "
                "quadratic admissibility identities, and affine pushforward density."
            ),
            "analytic_proof": "report.md",
            "not_claimed": (
                "The Python replay is not a formal proof of compactness, "
                "measurable pairing, uniqueness, or literature novelty."
            ),
            "independent_review": "pending",
            "novelty": "unlocated in bounded prior-art search; not yet verified_new",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the exact certificate")
    args = parser.parse_args()
    result = verify()
    certificate = HERE / "exact_certificate.json"
    if args.write:
        certificate.write_text(json.dumps(result, indent=2, ensure_ascii=True) + "\n")
    else:
        recorded = json.loads(certificate.read_text())
        if recorded != result:
            raise AssertionError("Certificate differs from the exact replay")
    print(
        f"PASS: {len(result['exact_checks'])} exact checks; "
        "critical Cauchy-quadratic law verified for all affine parameters."
    )
    print("Analytic proof and independent-review/novelty decisions remain separate.")


if __name__ == "__main__":
    main()
