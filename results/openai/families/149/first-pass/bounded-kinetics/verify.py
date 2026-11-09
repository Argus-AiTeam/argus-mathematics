#!/usr/bin/env python3
"""Replay the exact core; the full analytic theorem also requires proof review."""

import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(relative):
    return json.loads((PROJECT / relative).read_text())


def check_axioms(output, declarations):
    for declaration in declarations:
        name = f"Campaign149.BoundedKinetics.{declaration}"
        pattern = re.escape(f"'{name}' depends on axioms:") + r"\s*\[([^\]]*)\]"
        match = re.search(pattern, output)
        require(match is not None, f"Missing axiom report for {name}")
        axioms = {part.strip() for part in match[1].split(",") if part.strip()}
        require(axioms <= ALLOWED_AXIOMS, f"Unexpected axioms for {name}: {axioms}")


def check_evidence(spec):
    evidence = load(spec["certificate"])
    check = evidence["lean_check"]
    require(evidence["subject"]["subject_id"] == spec["claim_id"], "Wrong claim binding")
    require(evidence["tier"] == "mechanical" and evidence["verdict"] == "supports",
            "The certificate is not supporting mechanical evidence")
    require(check["status"] == "success" and check["exit_code"] == 0,
            "The recorded compiler run did not succeed")
    require(check["audit_exit_code"] == 0 and check["proof_holes"] == [],
            "The recorded proof-hole/axiom audit did not succeed")
    require(check["environment_failure"] == "", "The compiler environment was unverified")
    for key, record, digest_key in (
        ("source", "lean_source", "source_sha256"),
        ("fidelity", "statement_fidelity", "statement_fidelity_sha256"),
    ):
        data = (PROJECT / spec[key]).read_bytes()
        require(data.decode() == evidence[record]["text"], f"Changed {key} text")
        require(hashlib.sha256(data).hexdigest() == check[digest_key],
                f"Changed source-bound {key} digest")
    require("sorryAx" not in check["stdout"], "The recorded output has a proof hole")
    return check


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(value == {"num": str(result.numerator), "den": str(result.denominator)},
            "A rational is not in canonical form")
    return result


def check_normalized_margin(spec):
    require(spec["adapter_exit_code"] == 0 and spec["adapter_error"] is None
            and spec["timeout"] is False, "The adapter did not complete successfully")
    payload = load(spec["payload"])
    response = load(spec["typed_output"])
    require(response["request"] == {
        "operation_id": spec["operation_id"], "payload": payload
    }, "The adapter response is not bound to the exact request")
    require(response["result"]["operation_id"] == spec["operation_id"],
            "Wrong typed operation")
    require(response["server"]["version"] == "0.14.0"
            and response["protocol_version"] == "2025-11-25",
            "Unexpected retained adapter version")
    output = response["result"]["output"]
    require(output["box"] == payload["box"]
            and output["polynomial"] == payload["polynomial"],
            "The typed result is not bound to its source")
    require(payload["polynomial"]["variables"] == ["eta"]
            and payload["box"]["variables"] == ["eta"], "Wrong ordered variable axis")
    terms = payload["polynomial"]["polynomial"]["terms"]
    coefficients = {tuple(t["exponents"]): rational(t["coefficient"]) for t in terms}
    require(len(terms) == 2 and coefficients == {(1,): Fraction(-1), (0,): Fraction(1)},
            "The polynomial is not the universal normalized margin")
    interval = payload["box"]["intervals"]
    require(len(interval) == 1, "Wrong box dimension")
    lower, upper = rational(interval[0]["lower"]), rational(interval[0]["upper"])
    require((lower, upper) == (Fraction(0), Fraction(1, 2)), "Wrong normalized box")
    exact_range = (1 - upper, 1 - lower)
    enclosure = output["enclosure"]
    require((rational(enclosure["lower"]), rational(enclosure["upper"])) == exact_range,
            "Incorrect exact enclosure")
    require(exact_range[0] > 0, "The uniform rate margin is not positive")
    return {"lower": str(exact_range[0]), "upper": str(exact_range[1])}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--evidence-only", action="store_true",
                        help="Check the real source-bound compiler record without recompiling")
    parser.add_argument("--workspace", type=Path,
                        help="Built Lean 4.31.0 Mathlib workspace for a fresh replay")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    core = certificate["formal_core"]
    recorded = check_evidence(core)
    check_axioms(recorded["stdout"], core["declarations"])
    check_evidence(certificate["reviewed_input"])
    margin = check_normalized_margin(certificate["normalized_rate_margin"])
    if not args.evidence_only:
        workspace = args.workspace or Path(recorded["lake_workspace"])
        require(workspace.is_dir(), f"Missing built Mathlib workspace: {workspace}")
        command = [recorded["command"][0], "env", "lean"]
        version = subprocess.run(command + ["--version"], cwd=workspace, check=True,
                                 capture_output=True, text=True, timeout=60).stdout
        require("version 4.31.0," in version, f"Wrong compiler: {version.strip()}")
        replay = subprocess.run(command + [str(PROJECT / core["source"])],
                                cwd=workspace, capture_output=True, text=True, timeout=600)
        require(replay.returncode == 0, replay.stdout + replay.stderr)
        check_axioms(replay.stdout, core["declarations"])
    print(json.dumps({
        "formal_core": core["claim_id"],
        "fresh_compiler_replay": not args.evidence_only,
        "source_bound_compiler_evidence": "verified",
        "proof_holes": [],
        "normalized_margin": margin,
        "reviewed_affine_input": "reused_without_recompilation",
        "full_analytic_theorem": "requires_independent_proof_and_citation_review",
        "novelty": "requires_independent_assessment",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
