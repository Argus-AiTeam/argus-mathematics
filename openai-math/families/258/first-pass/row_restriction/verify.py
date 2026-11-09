#!/usr/bin/env python3
"""Replay the universal algebra certificate; --compile also reruns the kernel."""

import argparse
import ast
import hashlib
import json
from pathlib import Path
import shutil
import subprocess


ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent
STATEMENT = (
    "For every U<=L, the actual refined-level and coarse-level direct sums of "
    "H1(U intersect X_xi;D_U) inject into H1(U;D_U); the corresponding one-slot "
    "assertions hold inside every refined and coarse vertex row, already over "
    "the original induced modules."
)
INVERSES = {
    "x": "X", "X": "x", "v": "V", "V": "v", "g": "G", "G": "g",
    "u": "U", "U": "u", "z": "Z", "Z": "z",
}
VARIABLES = set(INVERSES) | {"c", "e", "s", "w"}
DECLARATIONS = [
    "right_pivot_cancel", "triangular_injective", "private_column",
    "root_frame_inverse", "line_single_support", "line_vertex_relation",
]
IDENTITIES = [
    ("root-forward-x", "-(-c*x)*X", "c"),
    ("root-forward-u", "(-c*x)*X*s+c*s+e", "e"),
    ("root-reverse-y", "-(-c*X)*x", "c"),
    ("root-reverse-u", "(-c*X)*s+c*X*s+e", "e"),
    ("fox-inverse-boundary", "-V*(v-1)", "V-1"),
    ("fox-product-boundary", "(v-1)+v*(w-1)", "v*w-1"),
    ("conjugation-boundary", "(1-g*v*G)*(g-1)+g*(v-1)", "g*v*G-1"),
    ("root-relation-power-sign", "z*(-Z*s)", "-s"),
    ("power-positive-induction", "(s+z)*(u-1)-(z*u-1)", "s*(u-1)-(z-1)"),
    ("power-negative-reduction", "(-Z*s)*(u-1)-(Z-1)", "-Z*(s*(u-1)-(z-1))"),
]

Polynomial = dict[tuple[str, ...], int]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def read_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def reduce_word(word: tuple[str, ...]) -> tuple[str, ...]:
    result: list[str] = []
    for symbol in word:
        if result and INVERSES.get(symbol) == result[-1]:
            result.pop()
        else:
            result.append(symbol)
    return tuple(result)


def add(p: Polynomial, q: Polynomial) -> Polynomial:
    result = p.copy()
    for word, coefficient in q.items():
        result[word] = result.get(word, 0) + coefficient
        if result[word] == 0:
            del result[word]
    return result


def negative(p: Polynomial) -> Polynomial:
    return {word: -coefficient for word, coefficient in p.items()}


def multiply(p: Polynomial, q: Polynomial) -> Polynomial:
    result: Polynomial = {}
    for a, ca in p.items():
        for b, cb in q.items():
            result = add(result, {reduce_word(a + b): ca * cb})
    return result


def polynomial(expression: str) -> Polynomial:
    def visit(node: ast.AST) -> Polynomial:
        if isinstance(node, ast.Name) and node.id in VARIABLES:
            return {(node.id,): 1}
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return {(): node.value} if node.value else {}
        if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
            return negative(visit(node.operand))
        if isinstance(node, ast.BinOp):
            left, right = visit(node.left), visit(node.right)
            if isinstance(node.op, ast.Add):
                return add(left, right)
            if isinstance(node.op, ast.Sub):
                return add(left, negative(right))
            if isinstance(node.op, ast.Mult):
                return multiply(left, right)
        raise ValueError(f"Unsupported noncommutative expression: {ast.dump(node)}")

    return visit(ast.parse(expression, mode="eval").body)


def check_identities(certificate: dict) -> int:
    expected = [
        {"id": name, "lhs": left, "rhs": right}
        for name, left, right in IDENTITIES
    ]
    require(certificate["symbolic_identities"] == expected,
            "The certificate does not state the required Fox identities.")
    pairs = certificate["symbolic_interpretation"]["inverse_pairs"]
    require(dict(pairs) == {s: INVERSES[s] for s in ("x", "v", "g", "u", "z")},
            "The declared unit relations changed.")
    require(certificate["symbolic_interpretation"]["other_variables"] == ["c", "e", "s", "w"],
            "Nonunit coefficient variables changed.")
    for name, left, right in IDENTITIES:
        require(polynomial(left) == polynomial(right), f"Identity failed: {name}")
    return len(IDENTITIES)


def check_lean(certificate: dict, compile_again: bool) -> dict:
    require(certificate["lean_claim"] == "F258-CORE", "Wrong formal claim.")
    require(certificate["formal_declarations"] == DECLARATIONS,
            "The required universal declarations changed.")
    source = ROOT / certificate["lean_source"]
    fidelity = ROOT / certificate["statement_fidelity"]
    archive_path = ROOT / certificate["lean_archive"]
    archive = read_json(archive_path)
    result = archive["lean_check"]
    require(archive["verdict"] == "supports" and archive["tier"] == "mechanical",
            "No supporting mechanical certificate.")
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The archived compiler run did not succeed.")
    require(result["proof_holes"] == [], "The proof contains holes.")
    require("version 4.31.0," in result["tools"]["lean"]["version"],
            "The required Lean 4.31.0 kernel was not used.")
    source_bytes = source.read_bytes()
    fidelity_text = fidelity.read_text(encoding="utf-8")
    require(hashlib.sha256(source_bytes).hexdigest() == result["source_sha256"],
            "The source changed after the real compiler run.")
    require(hashlib.sha256(fidelity_text.encode()).hexdigest()
            == result["statement_fidelity_sha256"],
            "The statement-fidelity document changed after compilation.")
    require(archive["lean_source"]["text"] == source_bytes.decode(),
            "The archived source differs from the checked source.")
    require(archive["statement_fidelity"]["text"] == fidelity_text,
            "The archived reading differs from the current reading.")
    require(archive["lean_source"]["path"] == str(source.relative_to(PROJECT)),
            "The certificate names another source.")
    for name in DECLARATIONS:
        require(f"theorem {name}" in archive["lean_source"]["text"],
                f"Missing universal theorem: {name}")
    ledger = read_json(PROJECT / "research/MATH_STATE.json")
    claims = [c for c in ledger["claims"] if c["claim_id"] == "F258-CORE"]
    require(bool(claims), "The formal claim is not registered.")
    claim = max(claims, key=lambda c: c["version"])
    require(claim["formal_statement"] == source_bytes.decode(),
            "The current ledger formalization is stale.")
    require(archive["subject"]["subject_id"] == "F258-CORE"
            and archive["subject"]["content_hash"] == claim["content_hash"],
            "The certificate belongs to a different claim version.")
    require(any(
        e["evidence_id"] == archive["evidence_id"]
        and e["subject"] == archive["subject"]
        and e["verdict"] == "supports"
        and e["artifact"] == str(archive_path.relative_to(PROJECT))
        for e in ledger["evidence"]
    ), "The real compiler certificate is not attached to the current ledger.")
    if compile_again:
        lake = shutil.which("lake")
        require(lake is not None, "A fresh replay needs the lake executable.")
        replay = subprocess.run(
            [lake, "env", "lean", str(source)],
            cwd=result["lake_workspace"], text=True, capture_output=True, timeout=600,
        )
        require(replay.returncode == 0,
                f"Fresh Lean replay failed:\n{replay.stdout}\n{replay.stderr}")
    return {
        "claim": "F258-CORE",
        "exit_code": 0,
        "proof_holes": [],
        "fresh_kernel_replay": compile_again,
    }


def check_jacobian(certificate: dict) -> None:
    data = certificate["jacobian"]
    request = read_json(ROOT / data["payload"])
    output = read_json(ROOT / data["output"])
    status = read_json(ROOT / data["status"])
    operation = "chain_complex.homology.compute"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter failed.")
    require(data["operation_id"] == operation
            and output["result"]["operation_id"] == operation, "Wrong Jacobian operation.")
    require(output["request"] == {"operation_id": operation, "payload": request},
            "The retained Jacobian payload and typed output disagree.")
    require(output["server"]["version"] == "0.14.0"
            and output["protocol_version"] == "2025-11-25",
            "Jacobian server or protocol provenance changed.")
    result = output["result"]["output"]
    require([g["betti_number"] for g in result["homology_groups"]] == [1, 0],
            "The auxiliary rational incidence check failed.")


def verify(compile_again: bool = False) -> dict:
    certificate = read_json(ROOT / "exact_certificate.json")
    require(certificate["schema_version"] == 1 and certificate["claim"] == "C258-ROW",
            "Wrong certificate or claim.")
    require(certificate["statement"] == STATEMENT
            and certificate["result_class"] == "universal_verification_theorem",
            "The certificate substituted a different mathematical statement.")
    require(certificate["coefficient_order"]
            == "coefficients on the left; group-ring entries multiply on the right",
            "The noncommutative coefficient convention changed.")
    require(certificate["primitive_forms"] == ["pr(x,y)", "pr(xy,z)"],
            "A primitive presentation form was omitted.")
    require(certificate["external_assumptions"] == ["A258-ATIYAH-PRECISE"],
            "The coefficient dependency changed.")
    require(certificate["independent_review_required"] is True
            and certificate["campaign_complete"] is False,
            "The local certificate must not claim independent or campaign-wide acceptance.")
    require((ROOT / certificate["proof"]).is_file(), "The group-theoretic proof is missing.")
    identities = check_identities(certificate)
    lean = check_lean(certificate, compile_again)
    check_jacobian(certificate)
    return {
        "claim": "C258-ROW",
        "certificate_replay": "passed",
        "universal_noncommutative_identities": identities,
        "lean_core": lean,
        "full_group_theorem": "proved in report.md; independent mathematical review required",
        "finite_examples_used_as_universal_evidence": False,
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compile", action="store_true", help="Also rerun Lean 4.31.0.")
    arguments = parser.parse_args()
    print(json.dumps(verify(arguments.compile), indent=2))
