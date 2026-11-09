#!/usr/bin/env python3
"""Replay exact arithmetic and validate the genuine universal Lean certificate."""

import argparse
import hashlib
from itertools import combinations, product
import json
from pathlib import Path
import re

from replay_formal import imports as formal_imports


HERE = Path(__file__).resolve().parent


def add(x, y):
    return x[0] + y[0], x[1] + y[1]


def neg(x):
    return -x[0], -x[1]


def sub(x, y):
    return add(x, neg(y))


def mul(x, y):
    return x[0] * y[0] - x[1] * y[1], x[0] * y[1] + x[1] * y[0]


def divide_one_plus_i(x):
    numerator = mul(x, (1, -1))
    assert numerator[0] % 2 == numerator[1] % 2 == 0
    return numerator[0] // 2, numerator[1] // 2


def convolution(f, g):
    assert len(f) == len(g)
    n = len(f)
    answer = [0] * n
    for i, a in enumerate(f):
        if a:
            for j, b in enumerate(g):
                answer[(i + j) % n] += a * b
    return answer


def star(f):
    return [f[-j % len(f)] for j in range(len(f))]


def scalar(n, a):
    return [a] + [0] * (n - 1)


def cyclotomic_reduce(coefficients, p):
    a = list(coefficients) + [0] * max(0, p - 1 - len(coefficients))
    for degree in range(len(a) - 1, p - 2, -1):
        lead = a[degree]
        for j in range(p):
            a[degree - (p - 1) + j] -= lead
    return tuple(a[:p - 1])


def polynomial_product(f, g):
    answer = [0] * (len(f) + len(g) - 1)
    for i, a in enumerate(f):
        for j, b in enumerate(g):
            answer[i + j] += a * b
    return answer


def binary_coefficients():
    cases = 0
    for h0, h1, h2, h3 in product((-1, 1), repeat=4):
        assert (h0 + h1 + h2 + h3) % 2 == 0
        assert (h0 - h1 + h2 - h3) % 2 == 0
        c = ((h0 + h1 + h2 + h3) // 2, 0)
        d = ((h0 - h1 + h2 - h3) // 2, 0)
        g = ((h0 - h2) // 2, (h1 - h3) // 2)
        b = ((h1 + h3) // 2, 0)
        U = ((h2 - 1) // 2, (h3 - 1) // 2)
        assert sub(d, c) == mul((-2, 0), b)
        assert sub(g, c) == sub(mul((-1, 1), b), (h2, h3))
        assert (h2, h3) == add((1, 1), mul((2, 0), U))
        lr_numerator = neg(b)
        lw_numerator = divide_one_plus_i(sub(g, c))
        assert lw_numerator == sub(sub(mul((0, 1), b), (1, 0)), mul((1, -1), U))
        assert add(lr_numerator, lw_numerator) == sub(
            (-1, 0), mul((1, -1), add(b, U))
        )
        cases += 1
    return {"sign_quadruples": cases, "identities": "exact, denominator-free, including c=0"}


def boundary_cases():
    h = [1, 1, 1, -1]
    assert convolution(h, star(h)) == scalar(4, 4)
    examples = []
    for p in (3, 5, 7):
        f = [p - 2] + [-2] * (p - 1)
        assert convolution(f, star(f)) == scalar(p, p * p)
        assert sum(f) == -p
        assert cyclotomic_reduce(f, p) == (p,) + (0,) * (p - 2)
        assert (-1 - 1) % p != 0
        examples.append({"p": p, "F": f, "group_exponent": 1, "scalar_valuation": 2, "ratio": -1})
    for p, a in ((3, 1), (3, 2), (5, 1)):
        u = p ** a
        x = [0] * (u * u)
        x[1] = u
        assert convolution(x, star(x)) == scalar(u * u, u * u)
        assert sum(x) == u
        one = cyclotomic_reduce([1], p)
        delta = cyclotomic_reduce([0] * (p - 1) + [1], p)
        assert cyclotomic_reduce(polynomial_product(delta, cyclotomic_reduce(x, p)), p) == tuple(
            u * a for a in one
        )
        for exponent in range(1, p + 1):
            power = cyclotomic_reduce([0] * ((p - 1) * exponent) + [1], p)
            assert (power == one) == (exponent == p)
    return {
        "order_four": {"h": h, "norm": 4, "c": [1, 0], "d": [1, 0], "g": [0, 1]},
        "single_prime_monomials": [[3, 1], [3, 2], [5, 1]],
        "single_prime_delta": "rho_p^(-1), of order p",
        "excluded_scalar_exponent_examples": examples,
    }


def integer_norm_nine():
    examined = 0
    solutions = 0
    rotations = [0, 0, 0]
    positions = tuple(range(9))
    for n3, n2, n1 in ((1, 0, 0), (0, 2, 1), (0, 1, 5), (0, 0, 9)):
        assert 9 * n3 + 4 * n2 + n1 == 9
        for p3 in combinations(positions, n3):
            remaining2 = tuple(j for j in positions if j not in p3)
            for p2 in combinations(remaining2, n2):
                remaining1 = tuple(j for j in remaining2 if j not in p2)
                for p1 in combinations(remaining1, n1):
                    support = p3 + p2 + p1
                    magnitudes = [3] * n3 + [2] * n2 + [1] * n1
                    for signs in product((-1, 1), repeat=len(support)):
                        f = [0] * 9
                        for j, magnitude, sign in zip(support, magnitudes, signs):
                            f[j] = magnitude * sign
                        examined += 1
                        if convolution(f, star(f)) != scalar(9, 9):
                            continue
                        solutions += 1
                        augmentation = sum(f)
                        assert augmentation in (-3, 3)
                        sums = [sum(f[r::3]) for r in range(3)]
                        value = (sums[0] - sums[2], sums[1] - sums[2])
                        choices = [(augmentation, 0), (0, augmentation), (-augmentation, -augmentation)]
                        assert value in choices
                        rotations[choices.index(value)] += 1
                        assert all(coefficient % 3 == 0 for coefficient in sums)
                        descended = [coefficient // 3 for coefficient in sums]
                        assert convolution(descended, star(descended)) == scalar(3, 1)
    return {
        "scope": "all integer elements of Z[C_9] with identity norm coefficient 9",
        "vectors_examined": examined,
        "scalar_norm_solutions": solutions,
        "ratio_exponent_counts": rotations,
        "conclusion": "each solution descends and F(rho_3)/F(1) is a power of rho_3",
        "universal_evidence": False,
    }


def jacobian_payload():
    n = 9
    f = [1, 0, 0, -2, 0, 0, -2]
    group_f = f + [0, 0]
    assert group_f == star(group_f)
    assert convolution(group_f, star(group_f)) == scalar(n, 9)
    polynomial = polynomial_product(f, f)
    polynomial[0] -= 9
    factorized = polynomial_product([2, 0, 0, 1], [-1] + [0] * 8 + [1])
    assert polynomial == [4 * a for a in factorized]
    return {
        "matrix": {
            "entries": [
                [{"num": str(int(i == (j + 1) % n)), "den": "1"} for j in range(n)]
                for i in range(n)
            ]
        },
        "polynomial": {
            "variables": ["t"],
            "polynomial": {
                "terms": [
                    {"coefficient": {"num": str(c), "den": "1"}, "exponents": [e]}
                    for e in range(len(polynomial) - 1, -1, -1)
                    if (c := polynomial[e]) != 0
                ]
            },
        },
    }


def jacobian_result():
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    assert "error" not in envelope
    assert envelope["request"]["operation_id"] == "matrix.polynomial.evaluate.compute"
    assert envelope["request"]["payload"] == jacobian_payload()
    result = envelope["result"]
    assert result["operation_id"] == "matrix.polynomial.evaluate.compute"
    output = result["output"]
    assert output["source_matrix"]["entries"] == jacobian_payload()["matrix"]["entries"]
    assert output["polynomial"]["polynomial"] == jacobian_payload()["polynomial"]["polynomial"]
    assert output["polynomial"]["variables"] == ["t"]
    assert output["value"]["domain"] == "QQ"
    assert len(output["value"]["entries"]) == 9
    assert all(
        len(row) == 9 and all(entry == {"num": "0", "den": "1"} for entry in row)
        for row in output["value"]["entries"]
    )
    return {
        "operation_id": result["operation_id"],
        "server_version": envelope["server"]["version"],
        "protocol_version": envelope["protocol_version"],
        "adapter_status": "completed",
        "adapter_error": None,
        "timeout": False,
        "runtime_ms": result["runtime_ms"],
        "exact_value": "zero matrix of order 9 over QQ",
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "scope": "one matching-exponent group-ring norm identity, not the universal obstruction",
    }


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def formal_build():
    configuration = json.loads((HERE / "formal_dependencies.json").read_text())
    path = HERE / "formal_build_manifest.json"
    manifest = json.loads(path.read_text())
    require(manifest["exit_code"] == 0, "The full dependency build did not pass.")
    require(
        manifest["toolchain"] == configuration["required_toolchain"] == "leanprover/lean4:v4.31.0",
        "The dependency build must use Lean 4.31.0.",
    )
    for key in ("repository", "revision"):
        require(manifest[key] == configuration[key], f"Wrong source provenance: {key}.")
    modules = {}
    for entry in manifest["modules"]:
        module = entry["module"]
        require(module not in modules, f"Duplicate dependency module: {module}.")
        source_name = "formal/" + module.replace(".", "/") + ".lean"
        require(entry["source"] == source_name, f"Wrong source path: {module}.")
        source = HERE / source_name
        require(sha256(source) == entry["source_sha256"], f"Stale source evidence: {module}.")
        require(entry["olean"] == str(Path(source_name).with_suffix(".olean")),
                f"Wrong compiled module path: {module}.")
        require(sha256(HERE / entry["olean"]) == entry["olean_sha256"],
                f"Stale compiled evidence: {module}.")
        dependencies = formal_imports(source.read_text())
        require(dependencies == entry["imports"], f"Changed imports: {module}.")
        require(set(dependencies) <= modules.keys(), f"Missing or unordered imports: {module}.")
        modules[module] = entry
    require(set(formal_imports((HERE / "Main.lean").read_text())) == set(configuration["roots"]),
            "The main theorem and dependency build have different proof roots.")
    pending = list(configuration["roots"])
    closure = set()
    while pending:
        module = pending.pop()
        require(module in modules, f"The proof root or a dependency is missing: {module}.")
        if module not in closure:
            closure.add(module)
            pending.extend(modules[module]["imports"])
    require(closure == modules.keys(), "The manifest is not the exact proof dependency closure.")
    return {
        "file": path.name,
        "sha256": sha256(path),
        "modules": len(modules),
        "repository": manifest["repository"],
        "revision": manifest["revision"],
        "toolchain": manifest["toolchain"],
    }


def formal_certificate(path):
    path = path.resolve()
    require(path.is_relative_to(HERE / "certificates"), "Use an official claim-bound archive.")
    archive = json.loads(path.read_text())
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "The archive does not record mechanical support.")
    subject = archive["subject"]
    require(subject["kind"] == "claim" and subject["subject_id"] == "C_ODD_SQUARE",
            "The archive certifies a different subject.")
    check = archive["lean_check"]
    require(check["status"] == "success" and check["exit_code"] == 0,
            "The actual Lean compilation did not succeed.")
    require(check["audit_exit_code"] == 0 and not check["environment_failure"],
            "The actual transitive axiom audit did not succeed.")
    require(check["proof_holes"] == [], "The formal proof contains proof holes.")
    version = check["tools"]["lean"]["version"]
    require(check["tools"]["lean"]["available"] and
            re.search(r"\bversion 4\.31\.0(?:,|\))", version),
            "The actual compiler must be Lean 4.31.0.")
    for section, filename, digest_key in (
        ("lean_source", "Main.lean", "source_sha256"),
        ("statement_fidelity", "statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        live = HERE / filename
        require(archive[section]["text"] == live.read_text(), f"Changed formal input: {filename}.")
        require(check[digest_key] == sha256(live), f"Stale compiler hash: {filename}.")
    expected = {
        "Audit9000179.odd_square_obstruction",
        "OAI.CirculantHadamard.LocalComparison.local_character_comparison",
        "OAI.CirculantHadamard.alternatingProduct_odd_torsion",
        "OAI.CirculantHadamard.binary_sign_norm_impossible",
    }
    matches = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", check["stdout"], re.S)
    require(len(matches) == len(expected) and {name for name, _ in matches} == expected,
            "The compiler did not report all four required transitive axiom sets.")
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    axioms = {}
    for name, names in matches:
        actual = {item.strip() for item in names.split(",") if item.strip()}
        require(actual <= allowed, f"Nonstandard transitive axioms in {name}: {actual - allowed}.")
        axioms[name] = sorted(actual)
    build = formal_build()
    require(build["sha256"] == "5acf9c589eb06c42a9c665ec762fa16b3f20267e4371abfaeee87c9c2a599c94",
            "The dependency snapshot differs from the certified run; a fresh official run "
            "and an explicit snapshot-pin review are required.")
    return {
        "certificate_file": str(path.relative_to(HERE)),
        "certificate_sha256": sha256(path),
        "evidence_id": archive["evidence_id"],
        "claim_content_hash": subject["content_hash"],
        "declaration": "Audit9000179.odd_square_obstruction",
        "lean_version": version,
        "source_sha256": check["source_sha256"],
        "statement_fidelity_sha256": check["statement_fidelity_sha256"],
        "compiler_exit_code": check["exit_code"],
        "axiom_audit_exit_code": check["audit_exit_code"],
        "proof_holes": check["proof_holes"],
        "transitive_axioms": axioms,
        "dependency_build": build,
        "scope": "every odd natural u>1; actual integer cyclic group ring, sign coefficients, full scalar norm",
        "independent_review": "not performed by this replay script",
    }


def exact_results(lean_certificate=None):
    formal = formal_certificate(lean_certificate) if lean_certificate is not None else None
    result = {
        "claim": "C_ODD_SQUARE",
        "result_class": "finite_verification",
        "universal_claim_certified": False,
        "manuscript_refutation_found": False,
        "binary_identities": binary_coefficients(),
        "boundary_cases": boundary_cases(),
        "norm_nine_search": integer_norm_nine(),
        "jacobian_operation": "matrix.polynomial.evaluate.compute",
        "jacobian_identity": "(3-2*(1+t^3+t^6))^2-9 = 4*(t^3+2)*(t^9-1)",
        "jacobian_result": jacobian_result(),
    }
    if formal is not None:
        result.update({
            "result_class": "known_result",
            "verification_class": "universal_formal_verification",
            "universal_claim_certified": True,
            "novelty_status": "not_claimed",
            "campaign_complete": False,
            "formal_verification": formal,
        })
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    parser.add_argument("--lean-certificate", type=Path,
                        help="Official claim-bound archive to pin when writing the certificate.")
    args = parser.parse_args()
    if not __debug__:
        parser.error("Exact arithmetic replay requires Python assertions to be enabled.")
    if args.lean_certificate is not None and not args.write_certificate:
        parser.error("--lean-certificate requires --write-certificate")
    path = HERE / "exact_certificate.json"
    if not path.exists() and not args.write_certificate:
        parser.error("The exact certificate is missing; use --write-certificate to create it.")
    previous = json.loads(path.read_text()) if path.exists() else {}
    selected = args.lean_certificate
    if selected is None and "formal_verification" in previous:
        selected = HERE / previous["formal_verification"]["certificate_file"]
    if args.write_jacobian_payload:
        (HERE / "jacobian_payload.json").write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
    result = exact_results(selected)
    if args.write_certificate:
        path.write_text(json.dumps(result, indent=2) + "\n")
    else:
        assert previous == result, "The exact certificate does not replay."
    print(json.dumps(result, sort_keys=True))
