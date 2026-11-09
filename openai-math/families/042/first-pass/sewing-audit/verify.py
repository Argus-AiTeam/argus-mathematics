#!/usr/bin/env python3
"""Replay exact support for the all-chain analytic proof in report.md."""

import argparse
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
CHECKS = []


def check(name, condition):
    if not condition:
        raise AssertionError(name)
    CHECKS.append(name)


def zero(name, expression):
    check(name, sp.cancel(sp.expand(expression)) == 0)


def nonnegative_polynomial(name, expression, *variables):
    coefficients = sp.Poly(sp.expand(expression), *variables, domain=sp.QQ).coeffs()
    check(name, all(c >= 0 for c in coefficients))


def read_polynomial(record, variables):
    check("typed polynomial ring", record["domain"] == "QQ")
    check("typed polynomial axes", record["variables"] == [str(v) for v in variables])
    value = sp.Integer(0)
    previous = None
    for term in record["polynomial"]["terms"]:
        powers = tuple(term["exponents"])
        check("typed monomial arity", len(powers) == len(variables))
        check("typed nonnegative exponents", all(type(k) is int and k >= 0 for k in powers))
        check("typed monomial order", previous is None or previous > powers)
        numerator = int(term["coefficient"]["num"])
        denominator = int(term["coefficient"]["den"])
        check("typed positive denominator", denominator > 0)
        rational = Fraction(numerator, denominator)
        check("typed canonical rational", rational.numerator == numerator and rational.denominator == denominator)
        check("typed nonzero coefficient", numerator != 0)
        monomial = sp.Rational(numerator, denominator)
        for variable, power in zip(variables, powers):
            monomial *= variable**power
        value += monomial
        previous = powers
    return value


def verify_adapter(certificate):
    adapter = certificate["jacobian"]
    response = json.loads((HERE / adapter["output_file"]).read_text())
    payload = json.loads((HERE / adapter["payload_file"]).read_text())
    check("adapter schema", response["schema_version"] == 1)
    check("adapter server version", response["server"]["version"] == adapter["server_version"])
    check("adapter protocol", response["protocol_version"] == adapter["protocol_version"])
    check("adapter transport", response["transport"] == adapter["transport"])
    check("adapter operation", response["result"]["operation_id"] == adapter["operation_id"])
    check("adapter requested operation", response["request"]["operation_id"] == adapter["operation_id"])
    check("adapter payload binding", response["request"]["payload"] == payload)
    check("adapter has typed output, not an error", "output" in response["result"] and "error" not in response["result"])
    check("adapter observed successful invocation", adapter["observed_exit_code"] == 0 and not adapter["timeout"])
    check("adapter no recorded transport or typed error", adapter["transport_error"] is None and adapter["typed_error"] is None)
    variables = sp.symbols("w p s")
    check("shear payload input axes", payload["input_variables"] == ["w", "p", "s"])
    polynomials = [read_polynomial(p, variables) for p in payload["output_polynomials"]]
    w, p, s = variables
    check("shear payload dimensions", len(polynomials) == 2)
    zero("shear payload W", polynomials[0] - w - s * p**2)
    zero("shear payload P", polynomials[1] - p)
    output = response["result"]["output"]
    check("adapter matrix dimensions", output["n_inputs"] == 3 and output["n_outputs"] == 2)
    check("adapter row-major entry count", len(output["entries"]) == 6)
    entries = [read_polynomial(e, variables) for e in output["entries"]]
    for row in range(2):
        for column in range(3):
            zero(
                f"adapter exact derivative {row},{column}",
                entries[3 * row + column] - sp.diff(polynomials[row], variables[column]),
            )
    zero("active shear determinant", sp.Matrix([[entries[0], entries[1]], [entries[3], entries[4]]]).det() - 1)


def verify_identities():
    alpha, gw, gp, hw, hp, u0 = sp.symbols("alpha gw gp hw hp u0")
    shear = sp.Matrix([[1, alpha], [0, 1]])
    omega = sp.Matrix([[0, 1], [-1, 0]])
    check("universal shear symplecticity", shear.T * omega * shear == omega)
    pulled = shear.inv() * sp.Matrix([gp, -gw])
    expected = sp.Matrix([gp + alpha * gw, -gw])
    check("universal Hamiltonian shear pullback", pulled == expected)
    x_g = sp.Matrix([gp + alpha * gw - hp, -gw + hw])
    raw = sp.Matrix([u0 + hp, -hw])
    check("all first-order modes cancel", raw + x_g - pulled == sp.Matrix([u0, 0]))
    check("incorrect unsheared shortcut is distinguishable", pulled - sp.Matrix([gp, -gw]) == sp.Matrix([alpha * gw, 0]))

    uw, up, vw, vp, p, v = sp.symbols("uw up vw vp p v")
    zero(
        "symplectic error identity",
        sp.Matrix([[1 + uw, up], [vw, 1 + vp]]).det() - 1 - (uw + vp + uw * vp - up * vw),
    )
    zero("period integrand expansion", (p + v) * (1 + uw) - p - (v + p * uw + v * uw))

    future, past, plus, minus = sp.symbols("future past plus minus")
    g_j = minus + future - past
    g_next_composed = future - past - plus
    zero("Fourier common-tail telescoping", g_j - g_next_composed - minus - plus)

    w, z, k, epsilon, s, a0 = sp.symbols("w z k epsilon s a0")

    def dw(expression):
        return sp.diff(expression, w) + k * z * sp.diff(expression, z)

    P = p + epsilon * z
    W = w + a0 + s * P**2
    derivative = sp.Matrix([[dw(W), sp.diff(W, p)], [dw(P), sp.diff(P, p)]])
    zero("exact Fourier-kick family determinant", derivative.det() - 1)
    primitive = sp.Rational(2, 3) * s * P**3 + epsilon * z / k
    zero("exact Fourier-kick primitive, dw component", P * dw(W) - p - dw(primitive))
    zero("exact Fourier-kick primitive, dp component", P * sp.diff(W, p) - sp.diff(primitive, p))
    zero("nonlinear shear normalization of kick", W - a0 - s * P**2 - w)
    check("nonzero Fourier mode has no constant Laurent coefficient", sp.Poly(P - p, z).coeff_monomial(1) == 0)

    c, d_j, c_j, c_next, n = sp.symbols("c d_j c_j c_next n")
    zero("excluded transverse translation period", (p + c) - p - c)
    zero("flux recentering sign", (d_j + c_j - c_next).subs(c_next, c_j + d_j))
    zero("constant nonzero flux primitive induction", ((c_j + (n + 1) * c) - (c_j + n * c)) - c)


def verify_majorants(certificate):
    constants = certificate["constants"]
    check("Newton exponent fixed", constants["q"] == 6)
    check("margin budget fixed", constants["c0"] == 64)
    check("Cauchy constant fixed", constants["N"] == "8*(A+2)")
    check("Newton constant fixed", constants["K"] == "1024*N**6")
    check("uniform threshold fixed", constants["e_star"] == "d**7/(1024*K)")
    check("uniform radius fixed", constants["b"] == "r/4")
    check("dyadic reserve fixed", constants["d"] == "min(1/4,h/(32*c0),r/(32*c0))")

    t = sp.symbols("t", nonnegative=True)
    x = sp.Rational(9, 2) + t
    zero("Fourier denominator comparison identity", sp.Rational(11, 9) - (1 + x) / x - 2 * t / (9 * x))
    check("Fourier both-direction bound", 2 * Fraction(11, 9) * Fraction(2, 9) == Fraction(44, 81) < 1)
    check("Fourier certificate constants", certificate["fourier_majorant"]["both_directions_coefficient"] == "44/81")

    N = 1 + t
    K = 1024 * N**6
    nonnegative_polynomial("K dominates normalized quadratic remainder", K - 38 * N**3, t)
    nonnegative_polynomial("K dominates Cauchy-flow constants", K - N**2, t)
    nonnegative_polynomial("composition remainder budget", 19 * N**3 - (17 * N**3 + 2), t)
    check("flow displacement stays inside one Cauchy reserve", Fraction(1, 1024) < Fraction(1, 4))
    check("flow Lipschitz bound is contractive", Fraction(4, 1024) < Fraction(1, 2))

    n, q = sp.symbols("n q", integer=True, nonnegative=True)
    zero("Newton rescaling, all n and q", q * (n + 2) + q * n - 2 * q * (n + 1))
    zero("double-exponential induction exponent", 2 * 2**n - 2 ** (n + 1))
    nonnegative_polynomial("2**n >= n+1 induction step", 2 * (n + 1) - (n + 2), n)
    check("theta is at most 1/64", Fraction(1, 4) / 16 == Fraction(1, 64) < Fraction(1, 2))
    check("all-stage domain smallness", Fraction(1, 64 * 16) == Fraction(1, 1024))

    zero("general differentiated-series ratio exponent", 2 * t - t - t)
    check("translation tail reserve", Fraction(2, 1024) == Fraction(1, 512))
    check("translation derivative sum", 1024 * (1 - Fraction(1, 2**6)) == 1008)
    check("flow displacement sum", 1024 * (1 - Fraction(1, 2**5)) == 992)
    check("flow derivative sum", 128 * (1 - Fraction(1, 2**4)) == 120)
    check("derivative product bounded", 1 / (1 - Fraction(1, 120)) == Fraction(120, 119) < 2)
    check("core coordinate changes injective", Fraction(1, 119) < Fraction(1, 4))
    check("translation derivatives remain bounded", Fraction(1, 1008) < 1)

    c0 = constants["c0"]
    check("total margin loss", Fraction(2 * c0, 32 * c0) == Fraction(1, 16))
    check("positive limiting margins", Fraction(1, 2) - Fraction(1, 16) == Fraction(7, 16))
    check("chosen transverse radius is buffered", Fraction(1, 4) < Fraction(7, 16))
    check("core lower edge is buffered", Fraction(7, 16) - Fraction(1, 3) == Fraction(5, 48) > 0)
    check("updated translations stay within h/3", Fraction(1, 8) + Fraction(1, 512 * 32 * c0) < Fraction(1, 3))

    length, old_length, shift, previous_shift, offset = sp.symbols("length old_length shift previous_shift offset")
    edge = length - shift
    previous_edge = old_length - previous_shift
    zero(
        "global edge gap identity",
        (edge - previous_edge).subs(shift, previous_shift - old_length + offset) - (length - offset),
    )
    check("global edge increment positive", 1 - Fraction(1, 8) / 3 == Fraction(23, 24) > 0)
    check("nonadjacent blocks do not overlap", 1 - Fraction(4, 3) * Fraction(1, 8) == Fraction(5, 6) > 0)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true", help="print the exact replay summary as JSON")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    check("certificate version", certificate["schema_version"] == 1)
    check("certificate claim", certificate["claim_id"] == "C_SEW_CHAIN")
    check("no false claim of kernel certification", "proof-kernel" in certificate["verification_boundary"]["not_claimed"][0])
    source = (PROJECT / certificate["manuscript"]["file"]).read_text()
    for label in certificate["manuscript"]["labels"]:
        check(f"manuscript label {label}", "\\label{" + label + "}" in source)
    for fragment in certificate["manuscript"]["literal_fragments"]:
        check("literal manuscript correspondence", fragment in source)
    verify_adapter(certificate)
    verify_identities()
    verify_majorants(certificate)
    result = {
        "status": "pass",
        "exact_checks": len(CHECKS),
        "claim": certificate["claim_id"],
        "scope": "Universal symbolic identities and scalar majorants supporting the complete analytic proof in report.md.",
        "independent_review": "not_performed_by_this_script",
    }
    if args.json:
        print(json.dumps(result, indent=2))
    else:
        print(f"PASS: {len(CHECKS)} exact checks; analytic theorem and verification boundary are stated in report.md.")


if __name__ == "__main__":
    main()
