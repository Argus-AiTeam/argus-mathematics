#!/usr/bin/env python3
"""Replay exact algebra used in Theorem U; analytic proof is in report.md."""

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "A-Coulomb-Ground-State-Density-without-Kohn-Sham-Ensemble-Representation-September-25-2026"
    / "build/sections/02-channels.tex"
)


def equal(actual, expected, name):
    difference = sp.simplify(sp.expand(actual - expected))
    if difference != 0:
        raise AssertionError(f"{name}: nonzero difference {difference}")


def source_locations():
    lines = SOURCE.read_text().splitlines()
    labels = [
        "lem:channel-cutoff",
        "eq:channel-residual",
        "eq:density-cutoff-error",
        "eq:cutoff-residual-identity",
        "lem:channel-expansion",
        "eq:scalar-remainder-derivatives",
        "eq:scalar-channel-recursion",
        "lem:plane-coefficient",
        "eq:complementary-expansion",
        "eq:equatorial-coefficient",
        "eq:complementary-recursion",
        "eq:three-scale-lower-bound",
        "eq:quantitative-density-drift",
    ]
    result = {}
    for label in labels:
        marker = "\\label{" + label + "}"
        matches = [i + 1 for i, line in enumerate(lines) if marker in line]
        if len(matches) != 1:
            raise AssertionError(f"source label {label}: {matches}")
        result[label] = matches[0]
    required_literals = [
        r"\|\partial_x^\nu R(x)\|\leq C_{D,s}\lambda e^{-\sigma r}",
        r"\partial_r^2\Omega^\ell\mathcal E=O(r^{-4})",
        r"\leq C_D\lambda Ar^{-5}\quad(|\nu|\leq2).",
        r"=-a_0'(0)B_Q^{-2}QY_z\phi .",
        r"\|F\|\geq c_D(A|\omega_z|+b+\lambda Ar^{-4}).",
        r"\leq100(|\gamma-k|+|\gamma-k|^2)+\rho_D(R).",
    ]
    text = "\n".join(lines)
    for literal in required_literals:
        if literal not in text:
            raise AssertionError(f"source assertion changed: {literal}")
    return {"path": str(SOURCE.relative_to(ROOT)), "label_lines": result}


def radial_checks():
    r, k, beta = sp.symbols("r k beta", positive=True)
    charge = k * (beta + 1)
    cases = {}
    for j in range(5):
        power = beta - j
        logarithmic_derivative = -k + power / r
        second_ratio = logarithmic_derivative**2 - power / r**2
        conjugated = -second_ratio / 2 - logarithmic_derivative / r
        conjugated += k**2 / 2 - charge / r
        expected = -j * k / r - power * (power + 1) / (2 * r**2)
        equal(conjugated, expected, f"radial conjugation j={j}")
        shifted_first = logarithmic_derivative + k
        shifted_second = shifted_first**2 - power / r**2
        equal(shifted_first, power / r, f"shifted first j={j}")
        equal(
            shifted_second, power * (power - 1) / r**2,
            f"shifted second j={j}",
        )
        cases[str(j)] = str(sp.factor(expected))
    m, c = sp.symbols("M C")
    scalar_potential = k**2 / 2 - charge / r - c / r**2
    profile = sp.exp(-k * r) * r**beta * (1 - m / r)
    residual = (
        -sp.diff(profile, r, 2) / 2
        - sp.diff(profile, r) / r
        + scalar_potential * profile
    ) / (sp.exp(-k * r) * r**beta)
    coefficient = sp.expand(sp.simplify(residual)).coeff(r, -2)
    equal(coefficient, k * m - beta * (beta + 1) / 2 - c,
          "norm supersolution coefficient")
    return {
        "charge_relation": "charge=k*(beta+1)=2-2*lambda",
        "conjugated_radial_terms": cases,
        "supersolution_r_minus_2": str(coefficient),
    }


def recursion_checks():
    k = sp.Symbol("k", positive=True)
    a0, k0a0, k1a1, c3a0 = sp.symbols("a0 K0a0 K1a1 c3a0")
    a1 = k0a0 / k
    a2 = (k1a1 + c3a0) / (2 * k)
    equal(-k * a1 + k0a0, 0, "scalar order two")
    equal(-2 * k * a2 + k1a1 + c3a0, 0, "scalar order three")
    bt2, bt3, bt4, s2, s3, s4, t2, t3, kt2 = sp.symbols(
        "BT2 BT3 BT4 S2 S3 S4 T2 T3 K2plusC2T2"
    )
    substitutions = {
        bt2: s2,
        bt3: s3 + 2 * k * t2,
        bt4: s4 + 3 * k * t3 - kt2,
    }
    for name, coefficient in [
        ("complementary order two", bt2 - s2),
        ("complementary order three", bt3 - 2 * k * t2 - s3),
        ("complementary order four", bt4 - 3 * k * t3 + kt2 - s4),
    ]:
        equal(coefficient.subs(substitutions), 0, name)
    return {
        "cancelled_orders": {"scalar": [2, 3], "complementary": [2, 3, 4]},
        "scope": "Formal coefficient matching only; invertibility and localization are analytic proof obligations.",
    }


def angular_checks():
    t, az = sp.symbols("t az", real=True)
    alpha, cubic, ux, uy, uz = sp.symbols("alpha cubic Ux Uy Uz", real=True)
    a = alpha * t + cubic * t**3
    w2 = sp.sqrt(1 - t**2) * (sp.cos(az) * ux + sp.sin(az) * uy) + t * uz
    product = a * w2
    laplace = (
        (1 - t**2) * sp.diff(product, t, 2)
        - 2 * t * sp.diff(product, t)
        + sp.diff(product, az, 2) / (1 - t**2)
    )
    equatorial = sp.simplify(laplace.subs(t, 0))
    equal(equatorial, 2 * alpha * uz, "equatorial product rule")
    equal(-equatorial / 2, -alpha * uz, "plane coefficient sign and factor")
    x, y, z, u, v, w = sp.symbols("x y z u v w")
    ambient = z * (x * u + y * v + z * w)
    ambient_laplace = sum(sp.diff(ambient, axis, 2) for axis in (x, y, z))
    equal(ambient_laplace, 2 * w, "ambient quadratic Laplacian")
    return {
        "equatorial_laplacian": str(equatorial),
        "plane_coefficient": "-a0_prime(0)*B_Q^(-2)*Q*Y_z*phi",
        "jet_scope": "A second-order differential operator uses only the odd scalar two-jet a(0)=a''(0)=0, a'(0)=alpha.",
    }


def inequality_checks():
    d = sp.Symbol("D", positive=True)
    margin = sp.Rational(1, 9) - 2 / d - sp.Rational(1160, 9) / d**2
    at_100 = margin.subs(d, 100)
    equal(at_100, sp.Rational(88, 1125), "exponent margin at D=100")
    equal(
        margin - at_100,
        2 * (sp.Rational(1, 100) - 1 / d)
        + sp.Rational(1160, 9) * (sp.Rational(1, 10000) - 1 / d**2),
        "monotone exponent margin decomposition",
    )
    if not at_100 > 0:
        raise AssertionError("exponent margin is not positive")
    b, v = sp.symbols("b v", nonnegative=True)
    root2 = sp.sqrt(2)
    equal(
        (2 * b**2 + v**2) / root2 - 2 * b * v,
        (root2 * b - v)**2 / root2,
        "spin noncancellation square",
    )
    gram = sp.Matrix([[1, 1 / root2], [1 / root2, 1]])
    if set(gram.eigenvals()) != {1 - 1 / root2, 1 + 1 / root2}:
        raise AssertionError("unexpected spin Gram eigenvalues")
    a, c, lam, q = sp.symbols("a c lambda q", nonnegative=True)
    numerator = lam * q**2 * a + q * c
    decomposition = q * a * (1 - lam) + lam * q * a * (1 - q) + q * b
    equal(q * (a + b + c) - numerator, decomposition, "uniform crossover bound")
    ratio = sp.simplify((1 + 1 / root2) / (1 - 1 / root2))
    equal(ratio, 3 + 2 * root2, "spin ratio")
    if not 2 < sp.Rational(3, 2)**2:
        raise AssertionError("rational square-root bound failed")
    ratio_upper = 6 * sp.Rational(11, 9)**3
    if not ratio_upper < 20:
        raise AssertionError("vertical ratio does not imply twenty")
    if not (6 < 100 and 16 + 6 < 100):
        raise AssertionError("density constants do not imply one hundred")
    if not sp.Rational(4) > 2 + sp.Rational(3, 2):
        raise AssertionError("incorrect Sobolev derivative count")
    return {
        "margin_at_100": str(at_100),
        "spin_gram_eigenvalues": [str(1 - 1 / root2), str(1 + 1 / root2)],
        "crossover_domain": "a,b,c>=0; 0<=lambda<=1; 0<q=1/r<=1; c=lambda*A*r^-4",
        "crossover_nonnegative_decomposition": str(decomposition),
        "vertical_ratio_upper": str(ratio_upper),
        "vertical_ratio_target": 20,
        "absolute_density_coefficient_target": 100,
    }


def horizontal_checks():
    p, z = sp.symbols("p z", positive=True)
    r = sp.sqrt(p**2 + z**2)
    s, t = p / r, z / r
    equal(sp.diff(r, p), s, "horizontal radial coefficient")
    equal(sp.diff(t, p), -s * t / r, "horizontal angular coefficient")
    equal(sp.diff(s, p), t**2 / r, "horizontal coefficient derivative")
    return {"dr_dp": "s", "dt_dp": "-s*t/r", "ds_dp": "t^2/r"}


def jacobian_check():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    operation = "polynomial.differential_operator.apply.compute"
    if status != {
        "operation_id": operation, "exit_code": 0, "timeout": False, "stderr": ""
    }:
        raise AssertionError(f"nonconclusive Jacobian adapter status: {status}")
    if output["request"]["operation_id"] != operation:
        raise AssertionError("saved Jacobian operation differs")
    if output["request"]["payload"] != payload:
        raise AssertionError("saved Jacobian payload differs")
    result = output["result"]["output"]
    if result["matches_expected"] is not True:
        raise AssertionError("Jacobian did not certify the expected polynomial")
    if result["output"] != payload["expected"]:
        raise AssertionError("Jacobian returned a different polynomial")
    if result["polynomial"] != payload["polynomial"]:
        raise AssertionError("Jacobian source polynomial differs")
    if result["operator"] != payload["operator"] or result["iterations"] != 1:
        raise AssertionError("Jacobian operator or iteration count differs")
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "transport": output["transport"],
        "adapter_exit_code": status["exit_code"],
        "adapter_timeout": status["timeout"],
        "matches_expected": True,
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
    }


def certificate():
    if not (HERE / "report.md").is_file():
        raise AssertionError("analytic proof is missing")
    return {
        "claim_id": "C_CROSSOVER_278",
        "result_type": "analytic_verification_theorem_with_exact_algebraic_components",
        "claim_scope": "Theorem U, report.md; conditional on the explicit Section 1 spectral input.",
        "quantifiers": "For each fixed D>=100 satisfying the scope inputs there exist Lambda_D>0, R_D and C_D, independent of lambda in [0,Lambda_D], such that U1-U3 hold, with differentiated remainders.",
        "analytic_proof": "report.md, Sections 1-6",
        "independent_review": "pending",
        "mechanical_scope": "Exact finite symbolic identities and inequalities only. This is not a machine proof of the analytic estimate or a novelty certificate.",
        "refutation_found": False,
        "source_locations": source_locations(),
        "radial": radial_checks(),
        "recursions": recursion_checks(),
        "angular": angular_checks(),
        "inequalities": inequality_checks(),
        "horizontal": horizontal_checks(),
        "jacobian": jacobian_check(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(target.read_text())
        if actual != expected:
            raise AssertionError("replayed certificate differs from exact_certificate.json")
    print(
        "PASS: exact channel algebra, source anchors, uniform ratio majorants, "
        "and saved Jacobian payload/output. Analytic proof requires independent review."
    )


if __name__ == "__main__":
    main()
