#!/usr/bin/env python3
"""Replay exact algebra and the accurately scoped formal certificate."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
from pathlib import Path
import shutil
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((HERE / name).read_text())


def add(a, b):
    result = a.copy()
    for exponent, coefficient in b.items():
        result[exponent] = result.get(exponent, 0) + coefficient
        if not result[exponent]:
            del result[exponent]
    return result


def scale(a, coefficient):
    return {e: coefficient * c for e, c in a.items() if coefficient * c}


def mul(a, b):
    result = {}
    for ea, ca in a.items():
        for eb, cb in b.items():
            require(len(ea) == len(eb), "Polynomial rings differ")
            exponent = tuple(x + y for x, y in zip(ea, eb))
            result = add(result, {exponent: ca * cb})
    return result


def typed_polynomial(value):
    require(value["domain"] == "QQ", "Unexpected Jacobian coefficient ring")
    result = {}
    for term in value["polynomial"]["terms"]:
        rational = term["coefficient"]
        coefficient = Fraction(int(rational["num"]), int(rational["den"]))
        exponent = tuple(term["exponents"])
        require(exponent not in result, "Repeated polynomial exponent")
        require(len(exponent) == len(value["variables"]), "Wrong polynomial arity")
        if coefficient:
            result[exponent] = coefficient
    return result


def matrix_mul(a, b):
    n = len(a)
    require(n == len(b), "Matrix dimensions differ")
    return [
        [
            sum_polynomials(mul(a[i][k], b[k][j]) for k in range(n))
            for j in range(n)
        ]
        for i in range(n)
    ]


def sum_polynomials(values):
    result = {}
    for value in values:
        result = add(result, value)
    return result


def check_symbolic_identities():
    one, b, s = {(0, 0): 1}, {(1, 0): 1}, {(0, 1): 1}
    one_minus_b = add(one, scale(b, -1))
    correction = add(add(b, mul(one_minus_b, s)), scale(one, -1))
    require(
        correction == mul(one_minus_b, add(s, scale(one, -1))),
        "Relative witness factorization fails over Z",
    )
    payload = load("jacobian_payload.json")
    require(payload["polynomial"]["variables"] == ["b", "s"], "Wrong variables")
    require(typed_polynomial(payload["polynomial"]) == correction, "Wrong payload")
    generators = payload["ideal"]["generators"]
    require(len(generators) == 1, "Wrong Jacobian ideal")
    require(
        typed_polynomial(generators[0]) == add(s, scale(one, -1)),
        "Wrong ideal generator",
    )
    status = load("jacobian_adapter_status.json")
    require(status["adapter_status"] == "RETURNED", "Adapter did not return")
    require(status["adapter_exit_code"] == 0, "Adapter failed")
    result = load("jacobian_result.json")
    require(result["server"]["version"] == "0.14.0", "Unexpected server version")
    require(result["protocol_version"] == "2025-11-25", "Unexpected protocol")
    require(
        result["result"]["operation_id"] == "polynomial.ideal.normal_form.compute",
        "Wrong Jacobian operation",
    )
    output = result["result"]["output"]
    require(output["request"] == payload, "Jacobian result is for another payload")
    require(output["outcome"] == "COMPUTED", "Incomplete Jacobian computation")
    require(output["in_ideal"] is True, "Identity was not proved")
    require(typed_polynomial(output["remainder"]) == {}, "Nonzero remainder")

    one, u, u_inverse = {(0,): 1}, {(1,): 1}, {(-1,): 1}
    zero = {}
    e12u = [[one, u], [zero, one]]
    e21minus = [[one, zero], [scale(u_inverse, -1), one]]
    w = matrix_mul(matrix_mul(e12u, e21minus), e12u)
    require(w == [[zero, u], [scale(u_inverse, -1), zero]], "Wrong w(u)")
    e12minus = [[one, scale(one, -1)], [zero, one]]
    e21one = [[one, zero], [one, one]]
    w_minus_one = matrix_mul(matrix_mul(e12minus, e21one), e12minus)
    require(
        matrix_mul(w, w_minus_one) == [[u, zero], [zero, u_inverse]],
        "Elementary factorization of diag(u,u^-1) fails",
    )
    return ["integer relative-witness factorization", "Laurent diagonal factorization"]


def normalize(a, p):
    a = tuple(x % p for x in a)
    while a and not a[-1]:
        a = a[:-1]
    return a


def p_add(a, b, p):
    return normalize(
        tuple(
            (a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)
            for i in range(max(len(a), len(b)))
        ),
        p,
    )


def p_scale(a, c, p):
    return normalize(tuple(c * x for x in a), p)


def p_mul(a, b, p):
    if not a or not b:
        return ()
    result = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            result[i + j] += x * y
    return normalize(result, p)


def p_divmod(a, b, p):
    require(bool(b), "Polynomial division by zero")
    quotient = [0] * max(0, len(a) - len(b) + 1)
    while a and len(a) >= len(b):
        degree = len(a) - len(b)
        coefficient = a[-1] * pow(b[-1], -1, p) % p
        quotient[degree] = coefficient
        term = (0,) * degree + p_scale(b, coefficient, p)
        a = p_add(a, p_scale(term, -1, p), p)
    return normalize(quotient, p), a


def p_bezout(a, b, p):
    x0, x1, y0, y1 = (1,), (), (), (1,)
    while b:
        quotient, remainder = p_divmod(a, b, p)
        a, b = b, remainder
        x0, x1 = x1, p_add(x0, p_scale(p_mul(quotient, x1, p), -1, p), p)
        y0, y1 = y1, p_add(y0, p_scale(p_mul(quotient, y1, p), -1, p), p)
    if not a:
        return (), (), ()
    inverse = pow(a[-1], -1, p)
    return p_scale(a, inverse, p), p_scale(x0, inverse, p), p_scale(y0, inverse, p)


def unit_mul(x, y, p):
    u, a = x
    v, b = y
    return u * v, p_add(p_add(p_scale(b, u, p), p_scale(a, v, p), p), p_mul(a, b, p), p)


def check_finite_rows():
    checked = 0
    one = (1,)
    for p, m, degree in ((3, 1, 2), (5, 1, 1), (3, 2, 2)):
        ideal = [
            normalize((0,) * m + coefficients, p)
            for coefficients in itertools.product(range(p), repeat=degree - m + 1)
        ]
        for x, b2, b3 in itertools.product(ideal, repeat=3):
            b1 = p_add(one, x, p)
            g12, _, _ = p_bezout(b1, b2, p)
            gcd, _, _ = p_bezout(g12, b3, p)
            if gcd != one:
                continue
            found = False
            for coefficients in itertools.product(range(p), repeat=len(b1) - 1):
                v = normalize((0,) * m + coefficients, p)
                beta2 = p_add(b2, p_mul(v, b3, p), p)
                gcd, c1, c2 = p_bezout(b1, beta2, p)
                if gcd != one:
                    continue
                correction = p_add(one, p_scale(b1, -1, p), p)
                witness1 = p_add(one, p_mul(correction, c1, p), p)
                witness2 = p_mul(correction, c2, p)
                require(
                    p_add(p_mul(b1, witness1, p), p_mul(beta2, witness2, p), p) == one,
                    "Polynomial relative witness fails",
                )
                require(
                    all(c == 0 for c in p_add(witness1, (-1,), p)[:m])
                    and all(c == 0 for c in witness2[:m]),
                    "Witness is not relative",
                )
                lift1 = (1, p_add(b1, (-1,), p))
                lift2 = (0, beta2)
                witness_lift1 = (1, p_add(witness1, (-1,), p))
                witness_lift2 = (0, witness2)
                product1 = unit_mul(lift1, witness_lift1, p)
                product2 = unit_mul(lift2, witness_lift2, p)
                require(
                    (product1[0] + product2[0], p_add(product1[1], product2[1], p))
                    == (1, ()),
                    "Integer-unitization witness fails",
                )
                found = True
                checked += 1
                break
            require(found, "No relative stable-range reduction in a finite test")
    return checked


def check_formal_record(certificate):
    name = certificate["formal_certificate"]
    require(isinstance(name, str) and name.startswith("certificates/"), "No formal certificate")
    archive_path = (HERE / name).resolve()
    require(archive_path.parent == HERE / "certificates", "Certificate escapes its directory")
    archive = json.loads(archive_path.read_text())
    require(archive["subject"]["subject_id"] == certificate["formal_claim"], "Wrong formal claim")
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports", "No mechanical support")
    result = archive["lean_check"]
    source = (HERE / certificate["formal_source"]).read_text()
    fidelity = (HERE / certificate["statement_fidelity"]).read_text()
    require(archive["lean_source"]["text"] == source, "Source differs from certified text")
    require(result["status"] == "success" and result["exit_code"] == 0, "Compiler did not succeed")
    require(result["proof_holes"] == [], "Formal proof has holes")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "Wrong Lean version")
    require(result["source_sha256"] == hashlib.sha256(source.encode()).hexdigest(), "Stale source")
    require(
        result["statement_fidelity_sha256"] == hashlib.sha256(fidelity.encode()).hexdigest(),
        "Stale statement fidelity",
    )
    for declaration in certificate["formal_declarations"]:
        require(
            f"theorem {declaration.split('.')[-1]}" in source,
            f"Missing declaration {declaration}",
        )
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = [
        c for c in ledger["claims"] if c["claim_id"] == certificate["formal_claim"]
    ][-1]
    require(claim["formal_statement"].strip() == source.strip(), "Ledger formalization differs")
    require(archive["subject"]["content_hash"] == claim["content_hash"], "Stale claim version")
    require(
        any(
            e.get("artifact") == str(archive_path.relative_to(ROOT))
            and e.get("subject") == archive["subject"]
            and e.get("tier") == "mechanical"
            for e in ledger["evidence"]
        ),
        "Formal certificate is not attached to the current ledger claim",
    )
    return result


def fresh_compile(result):
    lake = shutil.which("lake")
    require(lake is not None, "Lake missing; install the required Lean/Mathlib toolchain")
    workspace = Path(result["lake_workspace"])
    require(workspace.is_dir(), "Recorded Mathlib workspace is unavailable")
    version = subprocess.run(
        [lake, "env", "lean", "--version"],
        cwd=workspace, text=True, capture_output=True, check=True, timeout=60,
    )
    require("version 4.31.0," in version.stdout, "Replay compiler is not Lean 4.31.0")
    compiled = subprocess.run(
        [lake, "env", "lean", str(HERE / "Main.lean")],
        cwd=workspace, text=True, capture_output=True, timeout=720,
    )
    require(compiled.returncode == 0, compiled.stdout + compiled.stderr)
    return "fresh Lean 4.31.0 compilation succeeded"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--algebra-only", action="store_true", help="No formal or full-theorem verdict")
    mode.add_argument("--recorded", action="store_true", help="Check the real recorded compile without repeating it")
    args = parser.parse_args()
    certificate = load("exact_certificate.json")
    require(certificate["research_target_level"] == "publishable", "Wrong research bar")
    require(certificate["math_objective_mode"] == "exploratory", "Wrong objective mode")
    require(
        {c["claim_id"] for c in certificate["claims"]}
        == {"C9000177_STABILIZATION", "C9000177_ACTION"},
        "Wrong target claims",
    )
    require(certificate["campaign_terminal"] is False, "Unreviewed campaign closure")
    identities = check_symbolic_identities()
    rows = check_finite_rows()
    formal = "not checked (algebra-only mode)"
    if not args.algebra_only:
        result = check_formal_record(certificate)
        formal = "source-bound real compiler certificate checked"
        if not args.recorded:
            formal = fresh_compile(result)
    print(json.dumps({
        "exact_identities": identities,
        "finite_adversarial_rows": rows,
        "finite_rows_are_not_a_universal_proof": True,
        "jacobian": "COMPUTED; payload and integer identity independently replayed",
        "formal_bridge": formal,
        "concrete_homology_application": "universal mathematical proof in proof.md; not fully kernel formalized",
        "independent_review": certificate["independent_review"],
        "novelty": certificate["novelty_status"],
        "campaign_terminal": False,
    }, indent=2))


if __name__ == "__main__":
    main()
