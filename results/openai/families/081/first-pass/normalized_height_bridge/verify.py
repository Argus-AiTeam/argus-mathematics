#!/usr/bin/env python3
"""Replay exact supplemental obligations, not the full analytic proof."""

import hashlib
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SECTIONS = (
    ROOT
    / "research/openai_manuscript"
    / "Riesz-transforms-and-uniform-rectifiability-in-higher-codimension-September-24-2026"
    / "build/sections"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(path):
    return json.loads(path.read_text())


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for exponent, coefficient in polynomial.items():
            result[exponent] = result.get(exponent, Fraction(0)) + coefficient
    return {e: c for e, c in result.items() if c}


def scale(polynomial, coefficient):
    return {e: c * coefficient for e, c in polynomial.items() if c * coefficient}


def multiply(left, right):
    result = {}
    for le, lc in left.items():
        for re, rc in right.items():
            require(len(le) == len(re), "Polynomial variable axes differ")
            exponent = tuple(a + b for a, b in zip(le, re))
            result[exponent] = result.get(exponent, Fraction(0)) + lc * rc
    return {e: c for e, c in result.items() if c}


def square(polynomial):
    return multiply(polynomial, polynomial)


def variable(count, index):
    exponent = tuple(int(i == index) for i in range(count))
    return {exponent: Fraction(1)}


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(
        str(result.numerator) == value["num"]
        and str(result.denominator) == value["den"],
        "Noncanonical typed rational",
    )
    return result


def typed_polynomial(value, variables):
    require(value["domain"] == "QQ", "Expected rational polynomial ring")
    require(value["variables"] == variables, "Typed polynomial axis mismatch")
    result = {}
    previous = None
    for term in value["polynomial"]["terms"]:
        exponent = tuple(term["exponents"])
        require(len(exponent) == len(variables), "Wrong monomial dimension")
        require(all(type(e) is int and e >= 0 for e in exponent), "Invalid exponent")
        require(previous is None or previous > exponent, "Noncanonical monomial order")
        coefficient = rational(term["coefficient"])
        require(coefficient != 0, "Zero coefficient in canonical polynomial")
        result[exponent] = coefficient
        previous = exponent
    return result


def verify_jacobian(certificate):
    spec = certificate["jacobian"]
    payload = load(HERE / spec["payload"])
    execution = load(HERE / spec["execution"])
    response = load(HERE / spec["typed_output"])
    operation = spec["operation_id"]
    require(execution["operation_id"] == operation, "Execution operation mismatch")
    require(execution["adapter_exit_code"] == 0, "Jacobian adapter failed")
    require(execution["timeout"] is False, "Jacobian adapter timed out")
    require(execution["stderr"] == "", "Jacobian adapter reported an error")
    require(response["server"]["version"] == spec["server_version"], "Server mismatch")
    require(response["protocol_version"] == spec["protocol_version"], "Protocol mismatch")
    require(response["request"]["operation_id"] == operation, "Request mismatch")
    require(response["request"]["payload"] == payload, "Payload was not preserved")
    require(response["result"]["operation_id"] == operation, "Result mismatch")
    output = response["result"]["output"]
    require(output["status"] == "FACTORIZED", "No mathematical factorization obtained")
    require(output["product_reconstruction"] == "EXACT", "Inexact reconstruction")
    variables = certificate["cutoff"]["variables"]
    requested = typed_polynomial(payload["polynomial"], variables)
    reconstructed = {(0,) * len(variables): rational(output["coefficient"])}
    for entry in output["factors"]:
        multiplicity = entry["multiplicity"]
        require(type(multiplicity) is int and 1 <= multiplicity <= 64, "Invalid factor")
        factor = typed_polynomial(entry["factor"], variables)
        for _ in range(multiplicity):
            reconstructed = multiply(reconstructed, factor)
    require(reconstructed == requested, "Independent factor multiplication failed")
    require(
        typed_polynomial(output["reconstructed"], variables) == requested,
        "Typed reconstructed source differs",
    )

    U, V, a, b = [variable(4, i) for i in range(4)]
    local = multiply(
        add(U, scale(V, -1)),
        add(multiply(square(a), U), scale(multiply(square(b), V), -1)),
    )
    positive = square(add(multiply(a, U), scale(multiply(b, V), -1)))
    error = multiply(multiply(U, V), square(add(a, scale(b, -1))))
    require(add(positive, scale(local, -1)) == requested, "Source cutoff translation failed")
    require(error == requested, "Cutoff error has the wrong sign or factor")
    require(local == add(positive, scale(error, -1)), "Cutoff identity failed")
    require(local != add(positive, error), "Opposite-sign negative control failed")
    require(Fraction(*certificate["cutoff"]["pairing_factor"]) == Fraction(1, 2),
            "The local pairing factor is not one half")


def verify_variance():
    for size in range(1, 5):
        p = [variable(2 * size, i) for i in range(size)]
        x = [variable(2 * size, size + i) for i in range(size)]
        pairs = add(*[
            multiply(multiply(p[i], p[j]), square(add(x[i], scale(x[j], -1))))
            for i in range(size) for j in range(size)
        ])
        mass = add(*p)
        first = add(*[multiply(p[i], x[i]) for i in range(size)])
        second = add(*[multiply(p[i], square(x[i])) for i in range(size)])
        centered = add(multiply(mass, second), scale(square(first), -1))
        require(pairs == scale(centered, 2), f"Variance coefficient identity failed: {size}")
        if size == 2:
            require(pairs != centered, "Missing-factor-two negative control failed")


def verify_exponents(certificate):
    horizon = certificate["horizon"]
    delta = horizon["delta_base_two_exponent"]
    last = horizon["last_radius_base_two_exponent"]
    require(delta == [-1, 0] and last == [2, 3], "Not the manuscript's horizon schedule")
    remote = [-a - b for a, b in zip(delta, last)]
    fourth = [4 * a + b for a, b in zip(delta, last)]
    require(remote == horizon["normalized_remote_base_two_exponent"] == [-1, -3],
            "Normalized remote exponent lost a factor of delta")
    require(fourth == horizon["smallness_fourth_power_base_two_exponent"] == [-2, 3],
            "Quarter-gamma smallness exponent failed")
    gamma = Fraction(*horizon["gamma"])
    require(gamma == Fraction(1, 4), "Expected the actual quarter-gamma schedule")
    require(Fraction(*horizon["controlled_tail_shell_exponent"]) == gamma - 1,
            "Controlled shell exponent failed")
    require(Fraction(2) ** (4 * (gamma - 1)) ==
            Fraction(*horizon["controlled_tail_ratio_fourth_power"]) == Fraction(1, 8),
            "Tail geometric ratio failed")
    sheet = certificate["two_sheet"]
    mass = sheet["small_sheet_mass_exponent"]
    height = sheet["small_sheet_height_exponent"]
    require(sheet["sheet_separation"] == 1, "The two sheets are not separated")
    require(mass + height == sheet["signed_measure_exponent"] == 1, "Signed scaling failed")
    require(mass + 2 * height == sheet["squared_measure_exponent"] == 0,
            "Squared-measure defect scaling failed")
    require(mass + 2 * height == sheet["cross_energy_parameter_exponent"] == 0,
            "Cross-sheet energy scaling failed")
    require(sheet["cross_energy_factor"] == 2, "Cross-energy symmetry factor failed")


def verify_lean(certificate):
    spec = certificate["formal"]
    source = HERE / spec["source"]
    fidelity = HERE / spec["statement_fidelity"]
    check = load(HERE / spec["compiler_result"])
    recording = load(HERE / spec["recording_result"])
    require(check["status"] == "success" and check["exit_code"] == 0, "Lean did not compile")
    require(check["proof_holes"] == [] and check["audit_exit_code"] == 0, "Lean proof audit failed")
    require(check["source_sha256"] == hashlib.sha256(source.read_bytes()).hexdigest(),
            "Lean source changed after compilation")
    require(check["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.read_text().encode()).hexdigest(),
            "Statement fidelity changed after compilation")
    require(spec["required_lean_version"] in check["tools"]["lean"]["version"], "Wrong Lean version")
    require(recording["source_sha256"] == check["source_sha256"], "Recording source mismatch")
    require(recording["statement_fidelity_sha256"] == check["statement_fidelity_sha256"],
            "Recording fidelity mismatch")
    require(recording["kernel"]["refusals"] == [], "Compiler evidence was not accepted")
    record = recording["kernel"]["recorded"]
    require(record is not None, "No mechanical evidence recorded")
    require(record["subject"]["subject_id"] == spec["claim_id"], "Wrong formal claim")
    require(record["verdict"] == "supports" and record["tier"] == "mechanical",
            "Not a supporting compiler certificate")
    archive = load(ROOT / record["artifact"])
    require(archive["lean_source"]["text"] == source.read_text(), "Archived source mismatch")
    require(archive["statement_fidelity"]["text"] == fidelity.read_text(),
            "Archived fidelity mismatch")
    require(archive["subject"] == record["subject"], "Archived claim mismatch")
    claims = load(ROOT / "research/MATH_STATE.json")["claims"]
    current = max((c for c in claims if c["claim_id"] == spec["claim_id"]),
                  key=lambda c: c["version"])
    require(current["content_hash"] == record["subject"]["content_hash"], "Stale formal claim")
    require(current["formal_statement"] == source.read_text(), "Claim carries different formal text")
    for declaration in spec["declarations"]:
        require("theorem " + declaration in source.read_text(), "Missing formal declaration")
        require("`" + declaration + "`" in fidelity.read_text(), "Declaration not explained")


def main():
    certificate = load(HERE / "exact_certificate.json")
    require(certificate["claim_id"] == "NHB_GOAL", "Wrong analytic claim")
    require(certificate["campaign_completion"] is False, "Supplement cannot certify the campaign")
    require(certificate["formal"]["full_analytic_theorem_formalized"] is False,
            "Supplement overstates formal scope")
    anchors = 0
    for filename, labels in certificate["source_labels"].items():
        text = (SECTIONS / filename).read_text()
        for label in labels:
            require("\\label{" + label + "}" in text, f"Source anchor missing: {filename}:{label}")
            anchors += 1
    verify_jacobian(certificate)
    verify_variance()
    verify_exponents(certificate)
    verify_lean(certificate)
    print(json.dumps({
        "exact_checks": "passed",
        "source_anchors": anchors,
        "jacobian_status": "FACTORIZED",
        "lean_claim": "NHB_FORMAL",
        "lean_exit_code": 0,
        "proof_holes": [],
        "scope": "Exact supplemental obligations only; the full analytic proof in bridge.md requires independent Reviewer acceptance.",
        "campaign_completion": False,
    }, indent=2))


if __name__ == "__main__":
    main()
