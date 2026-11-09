#!/usr/bin/env python3
"""Replay the universal Lean theorem; finite diagnostics are not its proof."""

import argparse
import hashlib
import itertools
import json
import math
import os
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
LAKE = "$WORKSPACE/.elan/bin/lake"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
CLAIM = "V_CHARP_LINE_RECOVERY"
DECLARATION = "CharPLineRecovery.prop_lines_source"
DEPENDENCY = ROOT / (
    "research/char-p-intersection/certificates/"
    "V_CHARP_INTERSECTION-8ee0aa52ccd7bea2.json"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path):
    return json.loads(path.read_text())


def run(command, cwd=ROOT, log=None):
    env = dict(os.environ, LEAN_PATH=str(HERE))
    result = subprocess.run(
        [str(x) for x in command], cwd=cwd, env=env,
        text=True, capture_output=True, timeout=115,
    )
    if log is not None:
        log.write_text(result.stdout + result.stderr)
    if result.returncode:
        raise RuntimeError(
            f"exit {result.returncode}: {command}\n"
            f"{result.stdout[-6000:]}\n{result.stderr[-2000:]}"
        )
    return result.stdout


def module(name, *args):
    return [PYTHON, "-m", f"argus_skill.verticals.math.{name}", *args]


def reviewed_dependency():
    certificate = load(DEPENDENCY)
    source = ROOT / certificate["lean_source"]["path"]
    linked = HERE / "ReviewedIntersection.lean"
    check = certificate["lean_check"]
    require(source.read_bytes() == linked.read_bytes(), "reviewed import differs")
    require(digest(source) == check["source_sha256"], "dependency source changed")
    require(certificate["lean_source"]["text"] == source.read_text(),
            "dependency snapshot differs")
    require(check["exit_code"] == 0 and check["proof_holes"] == [],
            "reviewed dependency lacks a successful compiler result")
    fidelity = ROOT / certificate["statement_fidelity"]["path"]
    require(digest(fidelity) == check["statement_fidelity_sha256"],
            "reviewed dependency reading changed")
    shown = json.loads(run(module(
        "math_state", "show", "--project-root", ROOT,
        "--claim", "V_CHARP_INTERSECTION",
    )))["claim"]
    require(shown["version"] == 3 and shown["status"] == "closed_kernel",
            "reviewed intersection claim has changed")
    relative = str(DEPENDENCY.relative_to(ROOT))
    require(any(
        c["tier"] == "judgement" and c["produced_by"] == "reviewer:copilot"
        and c["verdict"] == "supports" and c["artifact"] == relative
        for c in shown["certificates"]
    ), "unchanged independent intersection judgement is missing")
    return {
        "claim_id": "V_CHARP_INTERSECTION", "claim_version": 3,
        "certificate": relative, "certificate_sha256": digest(DEPENDENCY),
        "source_sha256": digest(source),
        "local_import": str(linked.relative_to(ROOT)),
        "independent_supporter": "reviewer:copilot",
        "certificate_regenerated": False,
    }


def diagnostics():
    counts = {}
    for p in (2, 3, 5, 7):
        count = 0
        for a, b, x, y in itertools.product(range(p), repeat=4):
            require((b*x-a*y-b*(x+a)+a*(y+b)) % p == 0,
                    f"affine sign identity failed modulo {p}")
            count += 1
        counts[str(p)] = count
    coefficients = 0
    for p in (2, 3, 5, 7, 11, 13, 17, 19):
        for r in range(2, p):
            require(math.comb(r, 1) % p != 0, "rigidity coefficient vanished")
            coefficients += 1
    typed = load(HERE / "jacobian-output.json")
    payload = load(HERE / "jacobian-input.json")
    operation = "modular.polynomial_identity.compute"
    require(typed["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian output does not bind the exact payload")
    require(typed["result"]["operation_id"] == operation, "wrong operation")
    output = typed["result"]["output"]
    require(output["comparison_scope"] == "FORMAL_COEFFICIENTWISE_IDENTITY"
            and output["identical"] is True and output["residual"] == [],
            "Jacobian result is incomplete or inconclusive")
    require(not typed.get("error"), "Jacobian adapter reported an error")
    return {
        "kind": "finite_diagnostics_only",
        "affine_identity_assignments_by_prime": counts,
        "scalar_nonzero_coefficients": coefficients,
        "characteristic_two": "only the exponent 1 is admissible",
        "jacobian": {
            "operation_id": operation, "server_version": typed["server"]["version"],
            "protocol_version": typed["protocol_version"],
            "adapter_error": typed.get("error"), "typed_result_complete": True,
            "payload_sha256": digest(HERE / "jacobian-input.json"),
            "output_sha256": digest(HERE / "jacobian-output.json"),
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--record", action="store_true",
                        help="certify through lean_evidence --claim and write the certificate")
    args = parser.parse_args()
    dependency = reviewed_dependency()
    finite = diagnostics()
    files = ("Main.lean", "statement-fidelity.md", "report.md", "verify.py")
    hashes = {name: digest(HERE / name) for name in files}
    old = None if args.record else load(HERE / "exact_certificate.json")
    if old is not None:
        require(old["files_sha256"] == hashes, "certified files have changed")
        require(old["reviewed_dependency"] == dependency, "dependency binding changed")
        require(old["diagnostics"] == finite, "diagnostic replay differs")
        require(digest(ROOT / old["formal_certificate"]) ==
                old["formal_certificate_sha256"], "formal certificate changed")
    run([LAKE, "env", "lean", f"--root={HERE}",
         "-o", HERE / "ReviewedIntersection.olean", HERE / "ReviewedIntersection.lean"],
        cwd=WORKSPACE, log=HERE / "dependency-link.log")
    directory = HERE if args.record else HERE / "replay"
    command = module(
        "lean_evidence", "verify", HERE / "Main.lean",
        "--statement-fidelity", HERE / "statement-fidelity.md",
        "--project-root", ROOT, "--artifact-dir", directory, "--timeout", "100",
    )
    if args.record:
        command.extend(["--claim", CLAIM])
    run(command)
    check = load(directory / "lean_check.json")
    require(check["exit_code"] == 0 and check["audit_exit_code"] == 0
            and check["proof_holes"] == [] and check["status"] == "success",
            "unverified or failing formalization")
    require(check["source_sha256"] == hashes["Main.lean"]
            and check["statement_fidelity_sha256"] == hashes["statement-fidelity.md"],
            "compiler result is bound to different text")
    require("4.31.0" in check["tools"]["lean"]["version"], "wrong Lean version")
    axiom_report = (
        f"'{DECLARATION}' depends on axioms: "
        "[propext, Classical.choice, Quot.sound]"
    )
    require(axiom_report in check["stdout"], "unexpected root axiom closure")
    require(hashes == {name: digest(HERE / name) for name in files},
            "source, reading, report, or verifier changed during certification")
    gates = {}
    for name in ("math_state", "proof_graph_check"):
        run(module(name, "check", "--project-root", ROOT))
        gates[name + "_exit_code"] = 0
    if args.record:
        candidates = [
            path for path in (HERE / "certificates").glob(f"{CLAIM}-*.json")
            if load(path)["lean_check"]["source_sha256"] == hashes["Main.lean"]
            and load(path)["lean_check"]["statement_fidelity_sha256"] ==
            hashes["statement-fidelity.md"]
        ]
        require(len(candidates) == 1, "formal certificate is missing or ambiguous")
        formal = candidates[0]
        result = {
            "schema_version": 1, "claim_id": CLAIM,
            "evidence_kind": "universal_kernel_checked_theorem",
            "declaration": DECLARATION,
            "statement": (
                "For all characteristic-p fields of finite degree over their p-th-power "
                "subfields, both degrees at least p^2, every isomorphism of the actual "
                "multiplicative quotients preserving the actual Steinberg relation "
                "subspaces admits exactly one nonzero scalar sending every projective "
                "line onto some projective line."
            ),
            "formal_certificate": str(formal.relative_to(ROOT)),
            "formal_certificate_sha256": digest(formal),
            "files_sha256": hashes, "reviewed_dependency": dependency,
            "lean_version": check["tools"]["lean"]["version"],
            "exit_code": 0, "audit_exit_code": 0, "proof_holes": [],
            "axioms": ["propext", "Classical.choice", "Quot.sound"],
            "diagnostics": finite,
            "validation": {"project_root": str(ROOT), **gates},
            "independent_review": "pending_host_reviewer",
            "novelty_status": "not_claimed",
            "scope_excludes": ["projective lifting", "field reconstruction"],
        }
        (HERE / "exact_certificate.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "ok": True, "claim": CLAIM, "declaration": DECLARATION,
        "mode": "record" if args.record else "independent_replay",
        "project_root": str(ROOT), "exit_code": check["exit_code"],
        "proof_holes": check["proof_holes"], **gates,
        "independent_review": "pending_host_reviewer",
    }, indent=2))


if __name__ == "__main__":
    main()
