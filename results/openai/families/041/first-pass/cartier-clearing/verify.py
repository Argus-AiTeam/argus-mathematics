#!/usr/bin/env python3
"""Replay the universal Lean proof and separately labelled exact diagnostics."""

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
DECLARATIONS = (
    "CartierClearing.cartier_clearing",
    "CartierClearing.cartier_clearing_noncontainment",
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def add(p, *polynomials):
    result = {}
    for polynomial in polynomials:
        for exponent, coefficient in polynomial.items():
            result[exponent] = (result.get(exponent, 0) + coefficient) % p
    return {exponent: value for exponent, value in result.items() if value}


def multiply(p, left, right):
    result = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b, strict=True))
            result[exponent] = (result.get(exponent, 0) + ca * cb) % p
    return add(p, result)


def derivative(p, polynomial, coordinate):
    result = {}
    for exponent, coefficient in polynomial.items():
        target = list(exponent)
        target[coordinate] -= 1
        result[tuple(target)] = coefficient * exponent[coordinate]
    return add(p, result)


def cartier(p, polynomial):
    return add(p, {
        tuple((value - (p - 1)) // p for value in exponent): coefficient
        for exponent, coefficient in polynomial.items()
        if all((value - (p - 1)) % p == 0 for value in exponent)
    })


def apply_word(p, polynomial, word):
    for coordinate in reversed(word):
        polynomial = derivative(p, polynomial, coordinate)
    return polynomial


def adjoint_coefficient(p, polynomial, word):
    for coordinate in word:
        polynomial = {
            exponent: -value
            for exponent, value in derivative(p, polynomial, coordinate).items()
        }
    return add(p, polynomial)


def exact_diagnostics(certificate):
    counts = {"derivative_annihilation": 0, "word_adjoint": 0,
              "rational_coefficient_extraction": 0, "tame_trace": 0,
              "hypothesis_controls": 0}
    for p in certificate["supplemental_experiments"]["primes"]:
        require(p >= 2 and all(p % d for d in range(2, math.isqrt(p) + 1)),
                f"Nonprime diagnostic characteristic: {p}")
        f = add(p, {(-3, 4): 1, (p - 1, -1): 2, (2 * p + 1, p + 2): 3})
        c = add(p, {(2, 3): 1, (-2, 1): 1, (0, 0): 1})
        for i in range(2):
            require(cartier(p, derivative(p, f, i)) == {},
                    f"Cartier derivative failure at p={p}, i={i}")
            counts["derivative_annihilation"] += 1
        for length in range(certificate["supplemental_experiments"]["word_length_max"] + 1):
            for word in itertools.product(range(2), repeat=length):
                left = cartier(p, multiply(p, c, apply_word(p, f, word)))
                right = cartier(p, multiply(p, adjoint_coefficient(p, c, word), f))
                require(left == right, f"Adjoint failure at p={p}, word={word}")
                counts["word_adjoint"] += 1
        coefficients = {}
        z = {}
        for alpha in itertools.product(range(p), repeat=2):
            coefficient = add(p, {(-1, 1): 1, (alpha[0] + 1, -2): 2})
            coefficients[alpha] = coefficient
            summand = {
                tuple(a + p * value for a, value in zip(alpha, exponent, strict=True)): v
                for exponent, v in coefficient.items()
            }
            z = add(p, z, summand)
        for alpha, coefficient in coefficients.items():
            complement = {tuple(p - 1 - value for value in alpha): 1}
            require(cartier(p, multiply(p, complement, z)) == coefficient,
                    f"Rational coefficient extraction failure at p={p}, alpha={alpha}")
            counts["rational_coefficient_extraction"] += 1
        for e in range(2, p):
            for m in range(-2 * p * e, 2 * p * e + 1):
                after_cartier = {}
                if (m - e * (p - 1)) % p == 0:
                    power = (m - e * (p - 1)) // p
                    if power % e == 0:
                        after_cartier = {(power // e,): e}
                trace_first = {(m // e,): e} if m % e == 0 else {}
                require(add(p, after_cartier) == cartier(p, trace_first),
                        f"Tame ramified trace failure at p={p}, e={e}, m={m}")
                if m > 0 and trace_first:
                    require(next(iter(trace_first))[0] > 0,
                            "Trace did not preserve the maximal ideal")
                counts["tame_trace"] += 1
        s = {(p - 1,): 1}
        g = {(p,): 1}
        require(cartier(p, s) == {(0,): 1}, "Control splitting is not normalized")
        require(multiply(p, {(-p,): 1}, multiply(p, g, s)) == s,
                "Nonregular-coefficient control has no scalar identity")
        require(math.comb(2 * p - 1, p) % p == 1,
                "Hasse-derivative boundary coefficient is incorrect")
        for r in range(2 * p + 1):
            monomial = {(r,): 1}
            image = cartier(p, multiply(p, s, multiply(p, g, monomial)))
            expected = multiply(p, {(1,): 1}, cartier(p, multiply(p, s, monomial)))
            require(image == expected and (0,) not in image,
                    "Hypothesis control does not land in the maximal ideal")
        counts["hypothesis_controls"] += 2
    return counts


def check_jacobian(certificate):
    data = certificate["jacobian"]
    contract = json.loads((HERE / data["contract"]).read_text())
    payload = json.loads((HERE / data["payload"]).read_text())
    result = json.loads((HERE / data["typed_output"]).read_text())
    require(contract["result"]["operation"]["operation_id"] == data["operation_id"],
            "Jacobian operation contract mismatch")
    require(result["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(result["result"]["operation_id"] == data["operation_id"],
            "Jacobian result operation mismatch")
    require(result["server"]["version"] == data["server_version"]
            and result["protocol_version"] == data["protocol_version"],
            "Jacobian server or protocol mismatch")
    expected = {"domain": "QQ", "variables": ["u", "v"], "polynomial": {
        "terms": [{"coefficient": {"num": "3", "den": "1"}, "exponents": [2, 2]}]
    }}
    require(result["result"]["output"]["result"] == expected,
            "The bounded Jacobian derivative did not return 3*u^2*v^2")
    require(not result.get("error") and not result["result"].get("error"),
            "Jacobian returned a structured error")


def replay_lean(certificate, workspace):
    archived = json.loads((HERE / certificate["formal_certificate"]).read_text())
    check = archived["lean_check"]
    source = HERE / certificate["formal_source"]
    fidelity = HERE / certificate["statement_fidelity"]
    require(archived["subject"]["subject_id"] == certificate["claim"]
            and archived["verdict"] == "supports", "Wrong claim certificate")
    require(check["exit_code"] == 0 and check["audit_exit_code"] == 0
            and check["proof_holes"] == [] and check["status"] == "success",
            "The archived compiler certificate is not successful and hole-free")
    for path, key in ((source, "source_sha256"), (fidelity, "statement_fidelity_sha256")):
        require(hashlib.sha256(path.read_bytes()).hexdigest() == check[key],
                f"Stale official certificate: {path.name}")
    require(source.read_text() == archived["lean_source"]["text"],
            "Archived formal statement differs from the current source")
    require(fidelity.read_text() == archived["statement_fidelity"]["text"],
            "Archived statement fidelity differs from the current reading")
    require(tuple(certificate["formal_declarations"]) == DECLARATIONS,
            "The certificate targets different declarations")
    require(not re.search(r"\b(sorry|admit|axiom|unsafe|implemented_by)\b", source.read_text()),
            "Untrusted declaration or proof-hole token in the formal source")
    workspace = Path(workspace or check["lake_workspace"]).resolve()
    require(workspace.is_dir(), f"Built Mathlib workspace is missing: {workspace}")
    version = subprocess.run(["lake", "env", "lean", "--version"], cwd=workspace,
                             text=True, capture_output=True, check=True, timeout=30)
    require("version 4.31.0," in version.stdout, "Lean 4.31.0 is required")
    run = subprocess.run(["lake", "env", "lean", str(source)], cwd=workspace,
                         text=True, capture_output=True, timeout=100)
    require(run.returncode == 0, f"Fresh Lean compilation failed:\n{run.stdout}\n{run.stderr}")
    dependencies = dict(re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", run.stdout))
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    used = set()
    for declaration in DECLARATIONS:
        require(declaration in dependencies, f"No fresh axiom report for {declaration}")
        axioms = {name.strip() for name in dependencies[declaration].split(",") if name.strip()}
        require(axioms <= allowed, f"Unexpected axioms for {declaration}: {axioms - allowed}")
        used.update(axioms)
    return {"exit_code": run.returncode, "declarations": list(DECLARATIONS),
            "proof_holes": [], "axioms": sorted(used), "fresh_compiler_run": True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", help="Built Lean 4.31.0 Mathlib Lake workspace")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    check_jacobian(certificate)
    counts = exact_diagnostics(certificate)
    formal = replay_lean(certificate, args.workspace)
    print(json.dumps({
        "claim": certificate["claim"],
        "result": "parameter_uniform_theorem_verified",
        "formal": formal,
        "supplemental_finite_checks": counts,
        "finite_checks_are_the_proof": False,
        "independent_review": "not performed by this replay script",
        "statement_fidelity_human_approval": "pending",
        "novelty_status": "unestablished"
    }, indent=2))


if __name__ == "__main__":
    main()
