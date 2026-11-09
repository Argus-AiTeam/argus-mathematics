"""Exact algebraic replay for eta_status_resolution.md; no analytic verdict."""

import argparse
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NAMES = ("f", "e2", "e4", "e6", "j1", "j2", "j3", "a", "c", "d", "y", "I")
ZERO_MONOMIAL = (0,) * len(NAMES)
PAYLOAD_VARIABLES = ["j3", "j2", "j1", "e6", "e4", "e2", "f"]
OPERATION = "polynomial.ideal.normal_form.compute"


def require(condition, message):
    if not condition:
        raise ValueError(message)


class Polynomial:
    """Sparse QQ polynomials; I is reduced modulo I^2+1 only when requested."""

    def __init__(self, terms):
        self.terms = {m: Fraction(c) for m, c in terms.items() if c}

    @staticmethod
    def constant(value):
        return Polynomial({ZERO_MONOMIAL: Fraction(value)})

    @staticmethod
    def coerce(value):
        return value if isinstance(value, Polynomial) else Polynomial.constant(value)

    def __add__(self, other):
        terms = self.terms.copy()
        for monomial, coefficient in self.coerce(other).terms.items():
            terms[monomial] = terms.get(monomial, Fraction(0)) + coefficient
        return Polynomial(terms)

    __radd__ = __add__

    def __neg__(self):
        return Polynomial({m: -c for m, c in self.terms.items()})

    def __sub__(self, other):
        return self + -self.coerce(other)

    def __rsub__(self, other):
        return self.coerce(other) + -self

    def __mul__(self, other):
        terms = {}
        for left, a in self.terms.items():
            for right, b in self.coerce(other).terms.items():
                monomial = tuple(x + y for x, y in zip(left, right))
                terms[monomial] = terms.get(monomial, Fraction(0)) + a * b
        return Polynomial(terms)

    __rmul__ = __mul__

    def __pow__(self, exponent):
        require(isinstance(exponent, int) and exponent >= 0, "Invalid polynomial power")
        result = self.constant(1)
        for _ in range(exponent):
            result = result * self
        return result

    def derivative(self, name):
        index = NAMES.index(name)
        terms = {}
        for monomial, coefficient in self.terms.items():
            exponent = monomial[index]
            if exponent:
                reduced = list(monomial)
                reduced[index] -= 1
                terms[tuple(reduced)] = coefficient * exponent
        return Polynomial(terms)

    def substitute(self, replacements):
        result = self.constant(0)
        for monomial, coefficient in self.terms.items():
            term = self.constant(coefficient)
            for name, exponent in zip(NAMES, monomial):
                if exponent:
                    term = term * replacements.get(name, VARIABLES[name]) ** exponent
            result = result + term
        return result

    def reduce_imaginary(self):
        index = NAMES.index("I")
        terms = {}
        for monomial, coefficient in self.terms.items():
            reduced = list(monomial)
            quotient, reduced[index] = divmod(reduced[index], 2)
            key = tuple(reduced)
            terms[key] = terms.get(key, Fraction(0)) + coefficient * (-1) ** quotient
        return Polynomial(terms)


VARIABLES = {
    name: Polynomial({tuple(int(j == index) for j in range(len(NAMES))): 1})
    for index, name in enumerate(NAMES)
}


def decode_polynomial(value):
    require(value["domain"] == "QQ", "Wrong coefficient domain")
    require(value["variables"] == PAYLOAD_VARIABLES, "Wrong polynomial variable axis")
    result = Polynomial.constant(0)
    for row in value["polynomial"]["terms"]:
        exponents = row["exponents"]
        require(len(exponents) == len(PAYLOAD_VARIABLES), "Wrong exponent dimension")
        term = Polynomial.constant(
            Fraction(int(row["coefficient"]["num"]), int(row["coefficient"]["den"]))
        )
        for name, exponent in zip(PAYLOAD_VARIABLES, exponents):
            term = term * VARIABLES[name] ** exponent
        result = result + term
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--jacobian-output",
        type=Path,
        default=ROOT / "research/jacobian/normal-form.output.json",
    )
    args = parser.parse_args()
    payload = json.loads((ROOT / "research/jacobian/normal-form.payload.json").read_text())
    response = json.loads(args.jacobian_output.read_text())
    require(response["operation_id"] == OPERATION, "Wrong Jacobian operation")
    output = response["output"]
    require(output["request"] == payload, "Jacobian response belongs to another request")
    require(output["outcome"] == "COMPUTED", "Incomplete Jacobian outcome is not evidence")
    require(output["in_ideal"] is True, "Jacobian did not establish ideal membership")
    require(output["monomial_order"] == payload["monomial_order"] == "lex", "Wrong order")
    require(output["remainder"]["polynomial"]["terms"] == [], "Nonzero normal form")
    require(output["remainder"]["variables"] == PAYLOAD_VARIABLES, "Wrong remainder ring")
    require(output["remainder"]["domain"] == "QQ", "Wrong remainder field")
    require(payload["ideal"]["variables"] == PAYLOAD_VARIABLES, "Wrong ideal ring")
    checks = ["exact_typed_request_and_complete_zero_remainder"]

    def verify(name, polynomial, imaginary=False):
        if imaginary:
            polynomial = polynomial.reduce_imaginary()
        require(not polynomial.terms, f"Nonzero exact residual: {name}")
        checks.append(name)

    f, e2, e4, e6, j1, j2, j3 = (VARIABLES[n] for n in NAMES[:7])
    verify("arithmetic_mixed_terms", (f + e2) ** 2 - f ** 2 - 2 * f * e2 - e2 ** 2)
    verify("arithmetic_derivative", (f ** 3 * e2).derivative("f") - 3 * f ** 2 * e2)
    require(bool((f + 1).terms), "The polynomial checker erased a nonzero polynomial")

    flow = {
        "f": f * e2,
        "e2": Fraction(1, 12) * (e2 ** 2 - e4),
        "e4": Fraction(1, 3) * (e2 * e4 - e6),
        "e6": Fraction(1, 2) * (e2 * e6 - e4 ** 2),
    }

    def theta(polynomial):
        return sum(polynomial.derivative(name) * value for name, value in flow.items())

    f1 = theta(f)
    f2 = theta(f1)
    f3 = theta(f2)
    verify("first_ramanujan_jet", f1 - f * e2)
    verify("second_ramanujan_jet", 12 * f2 - f * (13 * e2 ** 2 - e4))
    verify("third_ramanujan_jet", 72 * f3 - f * (91 * e2 ** 3 - 21 * e2 * e4 + 2 * e6))
    generators = [
        j1 - f * e2,
        12 * j2 - f * (13 * e2 ** 2 - e4),
        72 * j3 - f * (91 * e2 ** 3 - 21 * e2 * e4 + 2 * e6),
        e4 ** 3 - e6 ** 2 - 1728 * f,
    ]
    require(len(payload["ideal"]["generators"]) == 4, "Wrong ideal presentation")
    for number, (typed, expected) in enumerate(zip(payload["ideal"]["generators"], generators), 1):
        verify(f"payload_generator_{number}", decode_polynomial(typed) - expected)

    A = 13 * j1 ** 2 - 12 * f * j2
    B = 91 * j1 ** 3 - 126 * f * j1 * j2 + 36 * f ** 2 * j3
    target = A ** 3 - B ** 2 - 1728 * f ** 7
    verify("payload_is_stated_nonlinear_equation", decode_polynomial(payload["polynomial"]) - target)
    verify("genuine_nonlinear_third_order_term", target.derivative("j3").derivative("j3") + 2592 * f ** 4)
    jets = {"j1": f1, "j2": f2, "j3": f3}
    verify("E4_reconstruction", A.substitute(jets) - f ** 2 * e4)
    verify("E6_reconstruction", B.substitute(jets) - f ** 3 * e6)
    residual = target.substitute(jets)
    verify("independent_exact_factorization", residual - f ** 6 * generators[3])
    require(bool((residual - f ** 6 * generators[3] + 1).terms), "Negative control failed")
    checks.append("nonzero_residual_negative_control")

    a, c, d, y, imaginary_unit = (VARIABLES[n] for n in ("a", "c", "d", "y", "I"))
    tau_numerator = a + imaginary_unit * c * y
    z_numerator = -c * d * y + imaginary_unit
    z_denominator = c ** 2 * y
    b_numerator = a * d - 1
    verify("determinant_one", a * d - b_numerator - 1)
    verify(
        "inverse_mobius_for_arbitrary_cusp",
        c * (-tau_numerator + a) * z_numerator
        - (d * tau_numerator - b_numerator) * z_denominator,
        imaginary=True,
    )
    verify(
        "forward_mobius_for_arbitrary_cusp",
        a * c * z_numerator + b_numerator * z_denominator
        - tau_numerator * (c * z_numerator + d * z_denominator),
        imaginary=True,
    )
    verify(
        "weight_factor_for_arbitrary_cusp",
        (c * z_numerator + d * z_denominator) * c * y
        - imaginary_unit * z_denominator,
    )
    verify("weight_twelve_phase", imaginary_unit ** 12 - 1, imaginary=True)
    print(json.dumps({
        "result_class": "exact_symbolic_certificate",
        "arithmetic": "Python standard library Fraction; independent of Jacobian's CAS",
        "jacobian_operation": OPERATION,
        "jacobian_outcome": output["outcome"],
        "checks_passed": checks,
        "analytic_argument": "research/eta_status_resolution.md, Sections 4-5",
        "limits": [
            "No coefficient scan or sampled cusp is used.",
            "The analytic flatness and ODE-continuation proof requires human review.",
            "Source fidelity, citation attribution and AIM status correspondence require independent Reviewer.",
            "This is not a Lean/kernel certificate or a counterexample to AIM Problem 1.2."
        ]
    }, indent=2))


if __name__ == "__main__":
    main()
