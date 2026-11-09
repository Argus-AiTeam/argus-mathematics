#!/usr/bin/env python3
"""Replay exact certificates, without promoting them to a formal geometric proof."""

from fractions import Fraction
import hashlib
import json
from pathlib import Path
import re


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
Polynomial = dict[tuple[int, ...], Fraction]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def load_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as stream:
        return json.load(stream)


def monomial(exponents: tuple[int, ...], coefficient=1) -> Polynomial:
    coefficient = Fraction(coefficient)
    return {exponents: coefficient} if coefficient else {}


def add(*polynomials: Polynomial) -> Polynomial:
    result: Polynomial = {}
    for polynomial in polynomials:
        for exponents, coefficient in polynomial.items():
            result[exponents] = result.get(exponents, Fraction(0)) + coefficient
    return {exponents: coefficient for exponents, coefficient in result.items() if coefficient}


def scale(polynomial: Polynomial, coefficient) -> Polynomial:
    return add({exponents: value * coefficient for exponents, value in polynomial.items()})


def multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    terms = []
    for a, ca in left.items():
        for b, cb in right.items():
            require(len(a) == len(b), "Polynomial arities differ")
            terms.append(monomial(tuple(x + y for x, y in zip(a, b)), ca * cb))
    return add(*terms)


def power(polynomial: Polynomial, exponent: int, arity: int) -> Polynomial:
    require(exponent >= 0, "Negative polynomial exponent")
    result = monomial((0,) * arity)
    for _ in range(exponent):
        result = multiply(result, polynomial)
    return result


def derivative(polynomial: Polynomial, variable: int) -> Polynomial:
    terms = []
    for exponents, coefficient in polynomial.items():
        if exponents[variable]:
            powers = list(exponents)
            powers[variable] -= 1
            terms.append(monomial(tuple(powers), coefficient * exponents[variable]))
    return add(*terms)


def read_polynomial(data: dict, variables: list[str]) -> Polynomial:
    require(data["domain"] == "QQ", "Expected exact rational coefficients")
    require(data["variables"] == variables, "Unexpected polynomial variables")
    result: Polynomial = {}
    powers_seen = []
    for term in data["polynomial"]["terms"]:
        powers = tuple(term["exponents"])
        require(len(powers) == len(variables), "Invalid monomial arity")
        require(all(type(value) is int and value >= 0 for value in powers),
                "Monomial exponents must be natural numbers")
        rational = term["coefficient"]
        coefficient = Fraction(int(rational["num"]), int(rational["den"]))
        require(str(coefficient.numerator) == rational["num"] and
                str(coefficient.denominator) == rational["den"],
                "Rational coefficient is not canonical")
        require(coefficient != 0 and powers not in result, "Noncanonical sparse polynomial")
        result[powers] = coefficient
        powers_seen.append(powers)
    require(powers_seen == sorted(powers_seen, reverse=True), "Terms are not lexicographically ordered")
    return result


def verify_reconstruction(certificate: dict) -> None:
    q = monomial((1,))
    constant = lambda value: monomial((0,), value)
    even = add(
        scale(power(add(scale(q, 4), constant(2)), 2, 1), 2),
        scale(power(add(scale(q, 5), constant(2)), 2, 1), -1),
    )
    odd = add(
        scale(power(add(scale(q, 4), constant(4)), 2, 1), 2),
        scale(multiply(add(scale(q, 5), constant(4)),
                       add(scale(q, 5), constant(5))), -1),
    )
    reconstruction = certificate["reconstruction"]
    require(reconstruction["twist"] == "m=2d+1", "Unexpected reconstruction twist")
    for name, actual in (("even", even), ("odd", odd)):
        coefficients = reconstruction[f"{name}_surplus_coefficients_low_to_high"]
        expected = add(*(monomial((index,), value)
                         for index, value in enumerate(coefficients)))
        require(actual == expected, f"{name} all-degree surplus identity fails")
        require(all(value >= 0 for value in actual.values()) and actual[(0,)] > 0,
                f"{name} polynomial is not certified positive for every q>=0")


def verify_jacobian(certificate: dict) -> None:
    spec = certificate["jacobian"]
    discovery = load_json(HERE / "jacobian_find.json")
    inspection = load_json(HERE / "jacobian_inspect.json")
    payload = load_json(HERE / spec["payload"])
    response = load_json(HERE / spec["typed_output"])
    status = load_json(HERE / spec["adapter_status"])
    operation = spec["operation_id"]
    require(status["adapter_exit_code"] == 0 and status["operation_id"] == operation,
            "Jacobian adapter did not complete successfully")
    require(any(item["operation_id"] == operation
                for item in discovery["result"]["matches"]), "Operation was not discovered")
    require(inspection["result"]["operation"]["operation_id"] == operation,
            "Wrong inspected operation")
    for document in (discovery, inspection, response):
        require(document["server"]["version"] == spec["server_version"],
                "Jacobian server versions differ")
        require(document["protocol_version"] == spec["protocol_version"],
                "Jacobian protocol versions differ")
    require(response["request"] == {"operation_id": operation, "payload": payload},
            "Typed output is not for the preserved exact payload")
    require(response["result"]["operation_id"] == operation, "Wrong executed operation")
    output = response["result"]["output"]
    require(output["convention"] == "EXACT_DIVISION_REMAINDER" and
            output["monomial_order"] == payload["monomial_order"] == "lex",
            "Unexpected polynomial division contract")
    variables = ["r", "z", "a", "b"]
    left = read_polynomial(payload["left"], variables)
    right = read_polynomial(payload["right"], variables)
    quotient = read_polynomial(output["quotient"], variables)
    remainder = read_polynomial(output["remainder"], variables)
    require(right == monomial((3, 0, 0, 0)), "Wrong normal factor")
    require(not remainder and multiply(right, quotient) == left,
            "Exact division has a nonzero remainder or incorrect quotient")
    r, z, a, b = [monomial(tuple(int(i == j) for i in range(4))) for j in range(4)]
    s = multiply(power(r, 4, 4), add(monomial((0, 0, 0, 0)), z, r))
    wedge = add(multiply(a, derivative(s, 1)), scale(multiply(b, derivative(s, 0)), -1))
    require(wedge == left, "Payload is not the stated exceptional wedge coefficient")
    leading = {powers: value for powers, value in quotient.items() if powers[0] == 0}
    require(leading == add(scale(multiply(z, b), -4), scale(b, -4)),
            "Canceled normal-leading wedge has the wrong sign or coefficient")


def verify_local_model(certificate: dict) -> None:
    model = certificate["local_model"]
    require(model["is_projective_counterexample"] is False,
            "An affine construction must not be relabeled as a projective counterexample")
    components = [read_polynomial(data, ["s", "t"]) for data in model["components"]]
    require(len(components) == 3, "Local model must have three target coordinates")
    x, y, z = components
    for component, degree in zip(components, (2, 3, 5)):
        diagonal = add(*(monomial((sum(powers),), coefficient)
                         for powers, coefficient in component.items()))
        require(diagonal == monomial((degree,)), "Box diagonal is not the stated curve")
    require(not derivative(x, 1) and not derivative(y, 1), "Second direction is not in E2")
    require(derivative(z, 0) == multiply(x, derivative(y, 0)),
            "First direction is not in the specified E1")
    require(all(derivative(component, direction).get((0, 0), 0) == 0
                for component in components for direction in (0, 1)),
            "The claimed critical point is not critical")
    one = monomial((0, 0, 0))
    target_x = monomial((1, 0, 0))
    A = [one, {}, {}]
    B = [{}, one, target_x]
    C = [{}, {}, one]
    bracket = [
        add(*(add(multiply(A[j], derivative(B[i], j)),
                  scale(multiply(B[j], derivative(A[i], j)), -1))
              for j in range(3)))
        for i in range(3)
    ]
    require(bracket == C, "The specified nonintegrable-frame bracket is wrong")
    require(add(bracket[2], scale(multiply(target_x, bracket[1]), -1)) == one,
            "The bracket is not certified outside E1")
    projector = [[{}, {}, {}], [{}, {}, {}], [{}, scale(target_x, -1), one]]
    square = [[add(*(multiply(projector[i][k], projector[k][j]) for k in range(3)))
               for j in range(3)] for i in range(3)]
    require(square == projector, "The local complementary projector is not idempotent")


def check_native_result(record: dict, source: bytes, fidelity: bytes) -> None:
    require(record["status"] == "success" and record["exit_code"] == 0,
            "Lean did not successfully compile the formal source")
    require(record["proof_holes"] == [], "Lean proof holes are present")
    require(re.search(r"\b4\.31\.0\b", record["tools"]["lean"]["version"]) is not None,
            "Expected the actual Lean 4.31.0 compiler")
    require(record["source_sha256"] == hashlib.sha256(source).hexdigest(),
            "Lean certificate is stale for Main.lean")
    normalized_fidelity = fidelity.decode("utf-8").encode("utf-8")
    require(record["statement_fidelity_sha256"] == hashlib.sha256(normalized_fidelity).hexdigest(),
            "Lean certificate is stale for statement fidelity")


def verify_lean(certificate: dict) -> str:
    source = (HERE / certificate["formal_source"]).read_bytes()
    fidelity = (HERE / certificate["statement_fidelity"]).read_bytes()
    native = load_json(HERE / "lean_check.json")
    response = load_json(HERE / "lean_verify.json")
    check_native_result(native, source, fidelity)
    require({key: value for key, value in response.items() if key != "kernel"} == native,
            "CLI compiler receipt differs from the native compiler record")
    names = re.findall(r"^(?:noncomputable\s+)?(?:theorem|def)\s+([A-Za-z0-9_]+)",
                       source.decode("utf-8"), flags=re.MULTILINE)
    require(names == certificate["formal_declarations"], "Formal declaration inventory changed")
    recorded = response["kernel"]["recorded"]
    require(recorded is not None and response["kernel"]["refusals"] == [],
            "The actual compiler answer was not recorded against a claim")
    require(recorded["verdict"] == "supports" and recorded["tier"] == "mechanical",
            "The recorded Lean answer is not mechanical support")
    state = load_json(PROJECT / "research/MATH_STATE.json")
    claim = max((item for item in state["claims"]
                 if item["claim_id"] == certificate["formal_claim"]), key=lambda item: item["version"])
    require(recorded["subject"]["subject_id"] == claim["claim_id"] and
            recorded["subject"]["content_hash"] == claim["content_hash"],
            "Mechanical evidence is for a different version of the formal claim")
    require(claim["formal_statement"].strip() == source.decode("utf-8").strip(),
            "The formal claim does not contain the compiled source")
    require(recorded in state["evidence"], "Mechanical receipt is absent from the ledger")
    archive_path = (PROJECT / recorded["artifact"]).resolve()
    require(archive_path.is_relative_to(HERE / "certificates"), "Certificate archive is outside this proof")
    archive = load_json(archive_path)
    require(archive["evidence_id"] == recorded["evidence_id"] and
            archive["subject"] == recorded["subject"] and
            archive["verdict"] == "supports" and archive["lean_check"] == native,
            "Archived compiler certificate does not match the recorded evidence")
    require(archive["lean_source"]["text"] == source.decode("utf-8") and
            archive["statement_fidelity"]["text"] == fidelity.decode("utf-8"),
            "Archived formal source or fidelity text differs from the current proof")
    return recorded["artifact"]


def main() -> None:
    certificate = load_json(HERE / "exact_certificate.json")
    require(certificate["schema_version"] == 1, "Unknown certificate schema")
    limits = certificate["certification_limits"]
    require(limits["entire_geometry_formalized"] is False and
            limits["python_certifies_geometric_proof"] is False,
            "Algebraic checks cannot certify the entire geometric argument")
    source = (PROJECT / certificate["manuscript_source"]).read_text(encoding="utf-8")
    normalized = " ".join(source.split())
    for anchor in certificate["literal_source_anchors"]:
        require(" ".join(anchor.split()) in normalized, "Certificate is not anchored to the staged assertion")
    verify_reconstruction(certificate)
    verify_jacobian(certificate)
    verify_local_model(certificate)
    archive = verify_lean(certificate)
    print(json.dumps({
        "status": "exact_checks_passed",
        "universal_algebra": "Fresh Lean 4.31.0 compilation; exit_code=0; proof_holes=[]",
        "formal_claim": certificate["formal_claim"],
        "formal_certificate": archive,
        "geometric_theorem": "Unrestricted proof in argument.md; independent review required",
        "geometric_formalization": False,
        "refutation_claimed": False
    }, indent=2))


if __name__ == "__main__":
    main()
