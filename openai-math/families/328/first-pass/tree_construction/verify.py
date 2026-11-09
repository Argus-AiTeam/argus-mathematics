#!/usr/bin/env python3
"""Rebuild the construction and obtain official claim-bound Lean evidence."""

import hashlib
import json
from pathlib import Path
import re
import subprocess
from datetime import datetime, timezone
from fractions import Fraction

from build import lean_environment


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
PRINCIPALS = (
    "TreeConstruction.tree_construction",
    "TreeConstruction.normalized_contradiction",
)
CLAIMS = ("C_TREE_CONSTRUCTION", "C_NORMALIZED_CONTRADICTION")
REVIEW_RECEIPT = Path(
    "$WORKSPACE/.argus-campaign-9000328/projects/cc0d0b95067e/"
    "handoffs/e29718d7e892/round-0001.json"
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_checked(command, label, env=None):
    process = subprocess.run(
        command, cwd=ROOT, env=env, text=True, capture_output=True, check=False,
    )
    logs = HERE / "build/replay"
    logs.mkdir(parents=True, exist_ok=True)
    (logs / f"{label}.log").write_text(
        process.stdout + process.stderr, encoding="utf-8",
    )
    if process.returncode:
        raise RuntimeError(
            f"{label} exited {process.returncode}\n"
            f"{process.stdout[-8000:]}\n{process.stderr[-3000:]}"
        )
    print(f"{label}: exit=0", flush=True)
    return process


def campaign_checks(label):
    results = {}
    for module in ("math_state", "proof_graph_check"):
        process = run_checked(
            [PYTHON, "-m", f"argus_skill.verticals.math.{module}",
             "check", "--project-root", str(ROOT)],
            f"{label}-{module}",
        )
        results[module] = {
            "project_root": str(ROOT),
            "exit_code": process.returncode,
            "output": process.stdout.strip(),
        }
    return results


def check_library_result(path):
    result = read_json(path)
    require(result["status"] == "passed", f"Unverified library: {path}")
    require(result["compiler_exit_code"] == 0, f"Library compiler failed: {path}")
    require(result["proof_holes"] == [], f"Library proof holes: {path}")
    require(
        re.search(r"\bversion 4\.31\.0(?:,|\))", result["compiler_version"]),
        f"Wrong library compiler: {path}",
    )
    for declaration, axioms in result["principal_axioms"].items():
        require(set(axioms) <= STANDARD_AXIOMS, f"Nonstandard axiom: {declaration}")
    return result


def preserved_bridge():
    directory = ROOT / "research/switching_bridge"
    old = read_json(directory / "exact_certificate.json")
    require(digest(directory / "Main.lean") == old["source_sha256"],
            "The reviewed switching source changed")
    require(digest(directory / "STATEMENT_FIDELITY.md") == old["statement_fidelity_sha256"],
            "The reviewed switching fidelity document changed")
    receipt = read_json(REVIEW_RECEIPT)
    require(receipt["review"]["status"] == "done", "The prior bridge review was not accepted")
    return {
        "claim": "C_SWITCHING_BRIDGE",
        "source_sha256": old["source_sha256"],
        "statement_fidelity_sha256": old["statement_fidelity_sha256"],
        "existing_review_receipt": str(REVIEW_RECEIPT),
        "review_repeated": False,
    }


def rational(value):
    result = Fraction(int(value["num"]), int(value["den"]))
    require(value == {"num": str(result.numerator), "den": str(result.denominator)},
            "Noncanonical rational in the preserved Jacobian request")
    return result


def finite_diagnostic():
    contract = read_json(HERE / "jacobian_contract.json")
    operation = "formal_series.rational.inverse.compute"
    require(contract["result"]["operation"]["operation_id"] == operation,
            "Wrong preserved Jacobian contract")
    requests = []
    for payload_name, output_name in (
        ("jacobian_rejected_payload.json", "jacobian_rejected_output.json"),
        ("jacobian_payload.json", "jacobian_output.json"),
    ):
        payload = read_json(HERE / payload_name)
        output = read_json(HERE / output_name)
        require(output["ok"] is False, "A rejected adapter invocation was relabelled")
        require(output["error"]["data"]["operation_id"] == operation,
                "The error is not bound to the inspected operation")
        require(output["error"]["data"]["code"] == "INVALID_REQUEST",
                "Unexpected adapter error classification")
        n = payload["truncation_order"]
        coefficients = [rational(v) for v in payload["coefficients"]]
        require(n == 12 and len(coefficients) == n, "The bounded diagnostic changed")
        scale = coefficients[0]
        require(scale in (1, 512), "Unexpected generating-series scale")
        require(coefficients == [scale, -scale / 2] + [Fraction(0)] * (n - 2),
                "The request no longer tests the geometric budget recurrence")
        inverse = [Fraction(1, scale * 2**i) for i in range(n)]
        product = [
            sum(coefficients[j] * inverse[i-j] for j in range(i+1))
            for i in range(n)
        ]
        require(product == [1] + [0] * (n - 1), "Exact truncated inverse identity failed")
        requests.append({
            "operation_id": operation,
            "payload": payload_name,
            "typed_output": output_name,
            "adapter_status": "operation_validation_failed",
            "structured_error": output["error"],
            "adapter_conclusion": "none",
            "independent_rational_product_replay": True,
        })
    for n in range(33):
        require(
            sum(Fraction(1, 2**(i+9)) for i in range(n))
            == Fraction(1, 256) * (1 - Fraction(1, 2**n)),
            "Exact finite candidate-budget identity failed",
        )
    return {
        "scope": "Finite coefficient/sign diagnostic only; infinite summability is proved in Lean.",
        "server": contract["server"],
        "protocol_version": contract["protocol_version"],
        "requests": requests,
        "exact_prefix_cases": 33,
        "rational_replay": "passed",
    }


def main():
    started = datetime.now(timezone.utc).isoformat()
    bridge = preserved_bridge()
    finite = finite_diagnostic()
    run_checked([PYTHON, str(HERE / "producer/build.py")], "producer-build")
    producer = check_library_result(HERE / "producer/build/result.json")
    inspection = read_json(HERE / "producer/build/dependency_inspection.json")
    require(inspection["forbidden_modules_present"] == [],
            "The producer imports a final contradiction module")
    require(inspection["hole_tokens_present"] == [], "The producer has proof-hole tokens")
    require(
        producer["upstream_revision"] == "4eaee87548250b2682affda7d05d947c05554bae",
        "The attributed upstream revision changed",
    )
    run_checked([PYTHON, str(HERE / "difference/build.py")], "difference-build")
    difference = check_library_result(HERE / "difference/build/result.json")
    run_checked([PYTHON, str(HERE / "build.py")], "integration-build")
    require(
        (HERE / "ReviewedSwitchingBridge.lean").read_bytes()
        == (ROOT / "research/switching_bridge/Main.lean").read_bytes(),
        "The bridge import is not the unchanged reviewed source",
    )
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    prefix = source.split("theorem normalized_contradiction", 1)[0]
    for name in (
        "SwitchingBridge.switching_bridge_from_manuscript",
        "SwitchingBridge.switching_bridge_contradiction",
        "TreeConstruction.normalized_contradiction",
    ):
        require(name not in prefix, f"Construction invokes the final contradiction: {name}")
    env = lean_environment()
    certificates = {}
    checks = {}
    for claim in CLAIMS:
        command = [
            PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
            "--project-root", str(ROOT), "--claim", claim,
            "--artifact-dir", str(HERE),
            "--statement-fidelity", str(HERE / "STATEMENT_FIDELITY.md"),
            str(HERE / "Main.lean"),
        ]
        result = json.loads(run_checked(command, f"official-{claim}", env).stdout)
        require(result["status"] == "success" and result["exit_code"] == 0,
                f"The compiler did not certify {claim}")
        require(result["audit_exit_code"] == 0, "The official axiom audit failed")
        require(result["proof_holes"] == [], "The integration has proof holes")
        require(result["environment_failure"] == "", "The required environment is unverified")
        require(
            result["kernel"]["recorded"] is not None
            and result["kernel"]["recorded"]["subject"]["subject_id"] == claim,
            f"Official evidence was not attached to {claim}",
        )
        version = result["tools"]["lean"]["version"]
        require(re.search(r"\bversion 4\.31\.0(?:,|\))", version), "Wrong official Lean version")
        require(result["source_sha256"] == digest(HERE / "Main.lean"),
                "Main.lean changed after compilation")
        require(result["statement_fidelity_sha256"] == digest(HERE / "STATEMENT_FIDELITY.md"),
                "Statement fidelity changed after compilation")
        axioms = {}
        for theorem in PRINCIPALS:
            match = re.search(
                rf"'{re.escape(theorem)}' depends on axioms:\s*\[([^\]]*)\]",
                result["stdout"],
            )
            require(match is not None, f"Missing principal axiom output: {theorem}")
            names = [name.strip() for name in match.group(1).split(",") if name.strip()]
            require(set(names) <= STANDARD_AXIOMS, f"Nonstandard principal axiom: {theorem}")
            axioms[theorem] = names
        checks = campaign_checks(claim)
        certificates[claim] = {
            "mechanical_evidence": result["kernel"]["recorded"],
            "lean_version": version,
            "exit_code": result["exit_code"],
            "audit_exit_code": result["audit_exit_code"],
            "proof_holes": result["proof_holes"],
            "principal_axioms": axioms,
        }
    certificate = {
        "started_at": started,
        "finished_at": datetime.now(timezone.utc).isoformat(),
        "result_class": "exact_verification_theorem",
        "scope": "Actual input producer from normalized minimal invariant data, and its composition with the reviewed switching theorem.",
        "claim_ids": list(CLAIMS),
        "principal_declarations": list(PRINCIPALS),
        "source": "Main.lean",
        "source_sha256": digest(HERE / "Main.lean"),
        "statement_fidelity": "STATEMENT_FIDELITY.md",
        "statement_fidelity_sha256": digest(HERE / "STATEMENT_FIDELITY.md"),
        "producer": {
            "upstream_revision": producer["upstream_revision"],
            "source_count": producer["source_count"],
            "compiled_count": len(producer["compiled"]),
            "reused_count": len(producer["reused"]),
            "compiler_version": producer["compiler_version"],
            "compiler_exit_code": producer["compiler_exit_code"],
            "proof_holes": producer["proof_holes"],
            "principal_axioms": producer["principal_axioms"],
            "elapsed_seconds": producer["elapsed_seconds"],
            "receipt": "producer/build/result.json",
            "dependency_inspection": "producer/build/dependency_inspection.json",
            "final_contradiction_imports": inspection["forbidden_modules_present"],
        },
        "difference_transport": {
            "receipt": "difference/build/result.json",
            "compiler_exit_code": difference["compiler_exit_code"],
            "source_sha256": difference["source_sha256"],
            "principal_axioms": difference["principal_axioms"],
            "elapsed_seconds": difference["elapsed_seconds"],
            "norm": "inherited original norm; no renorming",
        },
        "reviewed_bridge": bridge,
        "official_certificates": certificates,
        "finite_diagnostic": finite,
        "campaign_local_checks": checks,
        "arbitrary_domain_reduction": "open: C_NORMALIZED_REDUCTION",
        "independent_review": "pending Host-invoked Reviewer",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "not_claimed",
        "significance_status": "unassessed",
        "campaign_complete": False,
    }
    (HERE / "exact_certificate.json").write_text(
        json.dumps(certificate, indent=2, ensure_ascii=True) + "\n", encoding="utf-8",
    )
    event = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "role": "engineer", "agent": "copilot", "kind": "certification",
        "action": "Rebuilt the attributed producer and original-norm difference transport, and obtained official Lean 4.31.0 evidence for the actual tree producer and normalized contradiction. Both principal declarations have no proof holes or nonstandard axioms. The existing bridge review was reused. Independent review, arbitrary-domain reduction, and publishability remain open.",
        "status": "review_pending",
        "artifact": "research/tree_construction/exact_certificate.json",
        "project_root": str(ROOT),
        "math_state_exit": checks["math_state"]["exit_code"],
        "proof_graph_exit": checks["proof_graph_check"]["exit_code"],
    }
    with (ROOT / "activity.jsonl").open("a", encoding="utf-8") as log:
        log.write(json.dumps(event, ensure_ascii=True) + "\n")
    print(json.dumps({
        "claims": list(CLAIMS), "exit_code": 0, "proof_holes": [],
        "project_root": str(ROOT), "independent_review": "pending",
        "campaign_complete": False,
    }), flush=True)


if __name__ == "__main__":
    main()
