"""Replay only the old finite diagnostics; native Lean verification is separate."""

import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import sys

from argus_skill.verticals.math import math_state


ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
REPLAY = HERE / "replay"


def prepare():
    prior = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
    old = Path(prior["old_workspace"]) / "research/cartier-clearing"
    names = (
        "Main.lean", "statement_fidelity.md", "verify.py", "exact_certificate.json",
        "jacobian_contract.json", "jacobian_payload.json", "jacobian_result.json",
        "certificates/C_ADJOINT-f51e1ae321822ae4.json",
    )
    for name in names:
        target = REPLAY / name
        if target.exists():
            raise ValueError(f"Refusing to overwrite an existing replay input: {target}")
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(old / name, target)
    state = math_state.load_state(ROOT)
    isolated = math_state.MathState()
    isolated.add_context(state.latest_context("RV_CTX"))
    isolated.add_claim(state.latest_claim("RV_ADJOINT"))
    target = REPLAY / "research/MATH_STATE.json"
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(isolated.as_dict(), ensure_ascii=True, indent=2) + "\n")
    print(json.dumps({
        "replay_root": str(REPLAY),
        "source_copy": "byte-for-byte, no old workspace writes",
        "active_claim_alias": "RV_ADJOINT",
        "historical_fidelity_claim_label": "C_ADJOINT",
        "isolated_ledger": "same context and exact claim reference as active project",
    }))


def diagnostics():
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location("old_cartier_checker", REPLAY / "verify.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    certificate = json.loads((REPLAY / "exact_certificate.json").read_text())
    archived = json.loads((REPLAY / certificate["formal_certificate"]).read_text())
    checks = archived["lean_check"]
    for name, key in (
        (certificate["formal_source"], "source_sha256"),
        (certificate["statement_fidelity"], "statement_fidelity_sha256"),
    ):
        if hashlib.sha256((REPLAY / name).read_bytes()).hexdigest() != checks[key]:
            raise ValueError(f"Stale historical certificate: {name}")
    if (REPLAY / "Main.lean").read_text() != archived["lean_source"]["text"]:
        raise ValueError("Historical certificate has different formal source.")
    if (REPLAY / "statement_fidelity.md").read_text() != archived["statement_fidelity"]["text"]:
        raise ValueError("Historical certificate has a different statement reading.")
    if archived["verdict"] != "supports" or checks["exit_code"] != 0:
        raise ValueError("Historical final certificate was not successful.")
    module.check_jacobian(certificate)
    counts = module.exact_diagnostics(certificate)
    result = {
        "old_executable_inspected_before_import": True,
        "executed_from": str(REPLAY / "verify.py"),
        "entrypoint_not_executed": "main() and replay_lean() deliberately not called",
        "reason": "one native fresh compiler run is used instead of compiling the unchanged source twice",
        "historical_source_and_fidelity_match_final_certificate": True,
        "historical_jacobian_payload_contract_output_consistent": True,
        "supplemental_finite_checks": counts,
        "finite_checks_are_the_proof": False,
        "covers_rational_functions_generally": False,
        "scope": "specific Laurent-polynomial instances and tame monomial trace instances only",
    }
    (HERE / "diagnostics.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] not in {"prepare", "diagnostics"}:
        raise SystemExit("usage: replay_checks.py prepare|diagnostics")
    {"prepare": prepare, "diagnostics": diagnostics}[sys.argv[1]]()
