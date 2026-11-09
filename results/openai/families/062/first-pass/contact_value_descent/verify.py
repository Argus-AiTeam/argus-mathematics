#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from fractions import Fraction
from itertools import permutations
from pathlib import Path


HERE = Path(__file__).resolve().parent
Polynomial = dict[int, Fraction]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def load_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def add(left: Polynomial, right: Polynomial) -> Polynomial:
    result = left.copy()
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, Fraction(0)) + coefficient
    return {exponent: value for exponent, value in result.items() if value}


def multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    result: Polynomial = {}
    for i, a in left.items():
        for j, b in right.items():
            result[i + j] = result.get(i + j, Fraction(0)) + a * b
    return {exponent: value for exponent, value in result.items() if value}


def determinant(matrix: list[list[Polynomial]]) -> Polynomial:
    size = len(matrix)
    require(all(len(row) == size for row in matrix), "Nonsquare Sylvester matrix.")
    result: Polynomial = {}
    for permutation in permutations(range(size)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(size)
            for j in range(i + 1, size)
        )
        term = {0: Fraction((-1) ** inversions)}
        for row, column in enumerate(permutation):
            term = multiply(term, matrix[row][column])
        result = add(result, term)
    return result


def rational(coefficient: dict) -> Fraction:
    numerator = int(coefficient["num"])
    denominator = int(coefficient["den"])
    require(denominator > 0, "Rational denominator must be positive.")
    value = Fraction(numerator, denominator)
    require(
        str(value.numerator) == coefficient["num"]
        and str(value.denominator) == coefficient["den"],
        "Noncanonical rational in typed payload.",
    )
    return value


def univariate_terms(terms: list[dict]) -> Polynomial:
    result: Polynomial = {}
    previous = None
    for term in terms:
        exponents = term["exponents"]
        require(len(exponents) == 1, "Expected one polynomial variable.")
        exponent = exponents[0]
        require(type(exponent) is int and exponent >= 0, "Invalid exponent.")
        require(
            previous is None or previous > exponent,
            "Typed polynomial terms are not in strict descending order.",
        )
        value = rational(term["coefficient"])
        require(value != 0, "Zero term in canonical polynomial.")
        result[exponent] = value
        previous = exponent
    return result


def check_jacobian(
    payload: dict, output: dict, status: dict, local: dict
) -> Polynomial:
    operation = "polynomial.compute.discriminant"
    require(local["jacobian_operation"] == operation, "Wrong declared operation.")
    require(status["operation_id"] == operation, "Wrong adapter operation.")
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed.")
    require(status["timed_out"] is False, "Jacobian timed out; no conclusion.")
    require(status["stderr"] == "", "Jacobian reported an adapter error.")
    require(output["tool"] == "math.run", "Not an executed typed operation.")
    require(
        output["protocol_version"] == local["jacobian_protocol_version"]
        and output["server"]["version"] == local["jacobian_server_version"],
        "Jacobian server or protocol mismatch.",
    )
    require(output["request"]["operation_id"] == operation, "Wrong typed request.")
    require(output["request"]["payload"] == payload, "Payload/result mismatch.")
    require(output["result"]["operation_id"] == operation, "Wrong typed result.")
    typed = output["result"]["output"]
    require(typed["convention"] == "STANDARD_UNIVARIATE", "Wrong convention.")
    require(typed["variable"] == "z", "Discriminant taken in the wrong variable.")
    value = typed["discriminant"]
    require(value["kind"] == "POLYNOMIAL", "Incomplete or unknown typed result.")
    require(value["value"]["domain"] == "QQ", "Wrong coefficient domain.")
    require(value["value"]["variables"] == ["t"], "Wrong remaining variables.")
    return univariate_terms(value["value"]["polynomial"]["terms"])


def check_cubic(payload: dict, expected: dict) -> Polynomial:
    require(expected["polynomial"] == "z^3-t", "Changed local model.")
    require(expected["ramification_index"] == 3, "Changed cubic index.")
    require(payload["variable"] == "z", "Wrong discriminant variable.")
    polynomial = payload["polynomial"]
    require(polynomial["domain"] == "QQ", "Wrong input coefficient domain.")
    require(polynomial["variables"] == ["z", "t"], "Wrong input variables.")
    sparse = {
        tuple(term["exponents"]): rational(term["coefficient"])
        for term in polynomial["polynomial"]["terms"]
    }
    require(
        len(polynomial["polynomial"]["terms"]) == 2
        and sparse == {(3, 0): Fraction(1), (0, 1): Fraction(-1)},
        "Payload is not exactly z^3-t.",
    )
    f = [{0: Fraction(1)}, {}, {}, {1: Fraction(-1)}]
    derivative = [{0: Fraction(3)}, {}, {}]
    matrix: list[list[Polynomial]] = []
    for shift in range(2):
        row: list[Polynomial] = [{} for _ in range(5)]
        row[shift : shift + 4] = f
        matrix.append(row)
    for shift in range(3):
        row = [{} for _ in range(5)]
        row[shift : shift + 3] = derivative
        matrix.append(row)
    resultant = determinant(matrix)
    discriminant = {exponent: -value for exponent, value in resultant.items()}
    declared = univariate_terms(expected["discriminant_in_z"]["terms"])
    require(
        expected["discriminant_in_z"]["variables"] == ["t"]
        and discriminant == declared == {2: Fraction(-27)},
        "Exact Sylvester discriminant mismatch.",
    )
    dt = {
        (z_degree, t_degree - 1): coefficient * t_degree
        for (z_degree, t_degree), coefficient in sparse.items()
        if t_degree
    }
    require(
        dt == {(0, 0): Fraction(-1)}
        and expected["partial_derivative_in_t"] == -1,
        "The claimed smooth hypersurface derivative is not a unit.",
    )
    substituted: Polynomial = {}
    for (z_degree, t_degree), coefficient in sparse.items():
        substituted = add(
            substituted, {z_degree + 3 * t_degree: coefficient}
        )
    require(substituted == {}, "The parametrization does not lie on the curve.")
    require(
        expected["order_of_base_parameter_in_z"] == min({3: Fraction(1)}),
        "Wrong order of t=z^3.",
    )
    return discriminant


def check_compiler_result(
    result: dict, source: bytes, fidelity: bytes
) -> None:
    require(result["status"] == "success", "Lean result is not successful.")
    require(result["exit_code"] == 0, "Lean compiler failed.")
    require(result["proof_holes"] == [], "Lean proof has holes.")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not pass.")
    require(result["environment_failure"] == "", "Lean environment failure.")
    require(
        result["tools"]["lean"]["available"] is True
        and result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
        "Expected an actual Lean 4.31.0 compiler run.",
    )
    require(
        "sorryAx" not in result["stdout"] + result["audit_stdout"],
        "The compiler or axiom audit reported an admitted proof.",
    )
    require(
        hashlib.sha256(source).hexdigest() == result["source_sha256"],
        "Lean source changed after compilation.",
    )
    require(
        hashlib.sha256(fidelity).hexdigest()
        == result["statement_fidelity_sha256"],
        "Statement fidelity changed after compilation.",
    )


def check_lean(arithmetic: dict) -> None:
    require(
        arithmetic["claim_id"] == "C_DES_INTEGER_ORDER",
        "Do not attach the sublemma compiler result to the geometric theorem.",
    )
    source = (HERE / arithmetic["lean_source_file"]).read_bytes()
    fidelity = (HERE / arithmetic["statement_fidelity_file"]).read_bytes()
    result = load_json(HERE / arithmetic["lean_check_file"])
    check_compiler_result(result, source, fidelity)
    require(
        arithmetic["compiler_version"] == "4.31.0"
        and arithmetic["compiler_exit_code"] == 0
        and arithmetic["proof_holes"] == [],
        "Certificate misstates the actual compiler result.",
    )
    archived = load_json(HERE / arithmetic["archived_certificate_file"])
    require(
        archived["subject"]["subject_id"] == "C_DES_INTEGER_ORDER"
        and archived["tier"] == "mechanical"
        and archived["verdict"] == "supports"
        and archived["produced_by"] == "lean_evidence/lean 4.31.0",
        "Wrong claim-bound compiler archive.",
    )
    require(archived["lean_check"] == result, "Archive and live result disagree.")
    require(
        archived["lean_source"]["text"] == source.decode("utf-8"),
        "Archived formal statement differs from the compiled source.",
    )
    require(
        archived["statement_fidelity"]["text"].strip()
        == fidelity.decode("utf-8").strip(),
        "Archived statement fidelity differs from the current reading.",
    )


def verify() -> dict:
    certificate = load_json(HERE / "exact_certificate.json")
    require(certificate["claim_id"] == "C_DES_DESCENT", "Wrong geometric target.")
    require(
        certificate["original_quantifiers"]["additional_geometric_hypotheses"]
        == [],
        "The certificate added geometric hypotheses.",
    )
    require(
        certificate["limits"]["full_geometric_theorem_machine_checked"] is False
        and certificate["limits"]["classification_verified"] is False
        and certificate["limits"]["counterexample_claimed"] is False
        and certificate["limits"]["novelty_asserted"] is False,
        "The exact replay must not overstate its mathematical scope.",
    )
    require(
        certificate["independent_review"]["status"] == "pending"
        and certificate["independent_review"]["reviewer_confirmed"] is False,
        "This Engineer certificate cannot manufacture independent review.",
    )
    for filename in (
        certificate["proof_file"],
        certificate["statement_fidelity_file"],
    ):
        require((HERE / filename).read_text(encoding="utf-8").strip(), "Empty proof or fidelity document.")
    local = certificate["local_algebra"]
    payload = load_json(HERE / local["jacobian_payload_file"])
    output = load_json(HERE / local["jacobian_output_file"])
    status = load_json(HERE / local["jacobian_status_file"])
    computed = check_cubic(payload, local)
    require(
        check_jacobian(payload, output, status, local) == computed,
        "Independent exact calculation disagrees with Jacobian.",
    )
    check_lean(certificate["universal_arithmetic"])
    return {
        "exact_polynomial_replay": "passed",
        "jacobian_typed_cross_check": "passed",
        "universal_arithmetic_lean_certificate": "passed",
        "lean_version": "4.31.0",
        "source_and_fidelity_match_compiler_run": True,
        "compiler_rerun_by_this_script": False,
        "full_geometric_theorem_machine_checked": False,
        "independent_geometric_and_citation_review": "pending",
    }


if __name__ == "__main__":
    print(json.dumps(verify(), indent=2, sort_keys=True))
