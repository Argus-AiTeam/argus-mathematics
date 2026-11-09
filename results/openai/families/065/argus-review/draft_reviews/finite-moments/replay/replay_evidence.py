#!/usr/bin/env python3
"""Bounded replays of the assigned, immutable Family 065 evidence."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone


ROOT = Path(__file__).resolve().parents[4]
UNIT = Path("research/draft_reviews/finite-moments")
REPLAY = UNIT / "replay"
DEPENDENCIES = REPLAY / "dependencies"
if (ROOT / DEPENDENCIES).is_dir():
    sys.path.insert(0, str(ROOT / DEPENDENCIES))
OLD_ROOT = Path("campaigns/9000065")
OLD = OLD_ROOT / "research/family_orbit_localization"
LATEST = "$WORKSPACE/argus-latest/.venv/bin/python"
ADAPTER = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "matrix.symbolic.multiply.compute"
SUCCESS = OLD / "lean_evidence/certificates/C_LOC_JET-eb1805af26b62351.json"
FAILED = OLD / "lean_evidence/certificates/C_LOC_JET-434d7c41b97fb184.json"
MANIFEST = Path("campaigns/9100065/MANUSCRIPTS.json")
NATURAL_STATEMENT = (
    "This auxiliary replay asserts only the six even algebra statements in "
    "FamilyOrbitLocalization, not review completeness or geometry. For every "
    "commutative ring A, x in A and N in Nat (including zero), "
    "(1-x)*sum_{0<=j<N} x^j = 1-x^N. Define R(u,nu,N) = "
    "u*sum_{0<=j<N} (-nu*u)^j. For every commutative ring A, t,u,nu in A "
    "and N in Nat with t*u=1 and nu^N=0, (t+nu)*R(u,nu,N)=1; "
    "for every v in A with (t+nu)*v=1, v=R(u,nu,N). "
    "For every commutative scalar ring K, K-modules V,W,U with additive "
    "commutative group structures, finite type J, linear P:V->W and L:W->U, "
    "c:J->K and h:J->V, L(sum_j c(j) smul P(h(j))) = "
    "sum_j c(j) smul (L compose P)(h(j)). For the same modules and finite J, "
    "every linear L:W->U, family of linear D(j):V->W and h:J->V satisfies "
    "L(sum_j D(j)(h(j))) = sum_j (L compose D(j))(h(j)). "
    "For every commutative K, finite type I with decidable equality, "
    "K-modules V_i,W with additive commutative group structures, finite "
    "types J_i, multilinear F:(product_i V_i)->W, scalar families c_i:J_i->K "
    "and vectors h_i:J_i->V_i, F(i |-> sum_j c_i(j) smul h_i(j)) equals "
    "sum_{choice:product_i J_i} (product_i c_i(choice_i)) smul "
    "F(i |-> h_i(choice_i)). Empty finite types are included. "
    "No nontriviality, characteristic-zero, geometric nilpotence, "
    "super-sign, moduli, virtual-class, S/R-factorization or quantization "
    "claim is made."
)


def load(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def utc_now():
    return datetime.now(timezone.utc).isoformat()


def review_subject(state):
    return {
        "claims": [c for c in state["claims"] if c["claim_id"] == "C_REVIEW"],
        "evidence": [
            e for e in state["evidence"]
            if e.get("subject", {}).get("subject_id") == "C_REVIEW"
        ],
    }


def run_logged(base, command, *, json_output=False, timeout=None, extra_env=None):
    status_path = Path(str(base) + ".status.json")
    if status_path.exists():
        raise RuntimeError(f"Refusing a second execution: {status_path}")
    base.parent.mkdir(parents=True, exist_ok=True)
    stdout_path = Path(str(base) + (".stdout.json" if json_output else ".stdout.log"))
    stderr_path = Path(str(base) + ".stderr.log")
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
    if command[0] == LATEST and (ROOT / DEPENDENCIES).is_dir():
        env["PYTHONPATH"] = str(ROOT / DEPENDENCIES) + (
            os.pathsep + env["PYTHONPATH"] if env.get("PYTHONPATH") else ""
        )
    env.update(extra_env or {})
    started_at = utc_now()
    start = time.monotonic()
    timed_out = False
    exception = None
    exit_code = None
    try:
        result = subprocess.run(
            command, cwd=ROOT, env=env, capture_output=True, timeout=timeout,
            check=False,
        )
        stdout, stderr = result.stdout, result.stderr
        exit_code = result.returncode
    except subprocess.TimeoutExpired as exc:
        stdout, stderr = exc.stdout or b"", exc.stderr or b""
        timed_out = True
        exception = str(exc)
    stdout_path.write_bytes(stdout)
    stderr_path.write_bytes(stderr)
    status = {
        "command": command,
        "cwd": str(ROOT),
        "started_at": started_at,
        "finished_at": utc_now(),
        "duration_ms": round(1000 * (time.monotonic() - start)),
        "exit_code": exit_code,
        "outer_timeout_seconds": timeout,
        "timed_out": timed_out,
        "exception": exception,
        "environment": {
            key: env[key] for key in ("PYTHONDONTWRITEBYTECODE", "PYTHONPATH", "TMPDIR")
            if key in env
        },
        "stdout_file": str(stdout_path),
        "stderr_file": str(stderr_path),
        "stdout_bytes": len(stdout),
        "stderr_bytes": len(stderr),
    }
    write_json(status_path, status)
    print(json.dumps({"stage": str(base), "exit_code": exit_code, "timed_out": timed_out}))
    return status, stdout


def official_checks(label):
    results = {}
    for name in ("math_state", "proof_graph_check"):
        status, _ = run_logged(
            REPLAY / "checks" / label / name,
            [
                LATEST, "-m", f"argus_skill.verticals.math.{name}", "check",
                "--project-root", str(ROOT),
            ],
            json_output=(name == "math_state"),
        )
        results[name] = status["exit_code"]
    return results


def prepare():
    inventory = load(Path("PRIOR_DRAFTS.json"))
    before = [
        {
            "path": str(OLD_ROOT / item["path"]),
            "expected_bytes": item["bytes"],
            "actual_bytes": (OLD_ROOT / item["path"]).stat().st_size,
            "sha256": digest(OLD_ROOT / item["path"]),
        }
        for item in inventory["artifacts"]
    ]
    success, failed = load(SUCCESS), load(FAILED)
    old_state = load(OLD_ROOT / "research/MATH_STATE.json")
    versions = [c for c in old_state["claims"] if c["claim_id"] == "C_LOC_JET"]
    source, note = (OLD / "Main.lean").read_bytes(), (OLD / "statement_fidelity.md").read_bytes()
    checks = {
        "two_old_source_copies_byte_equal": source == (OLD / "lean_evidence/Main.lean").read_bytes(),
        "two_old_fidelity_copies_byte_equal": note == (OLD / "lean_evidence/statement_fidelity.md").read_bytes(),
        "source_equals_successful_archive": source == success["lean_source"]["text"].encode(),
        "fidelity_equals_successful_archive": note == success["statement_fidelity"]["text"].encode(),
        "source_hash_matches_successful_archive": digest(OLD / "Main.lean") == success["lean_check"]["source_sha256"],
        "fidelity_hash_matches_successful_archive": digest(OLD / "statement_fidelity.md") == success["lean_check"]["statement_fidelity_sha256"],
        "lean_check_equals_successful_archive_check": load(OLD / "lean_evidence/lean_check.json") == success["lean_check"],
        "verification_receipt_duplicates_successful_check": {
            k: v for k, v in load(OLD / "lean_verification.json").items() if k != "kernel"
        } == success["lean_check"],
        "natural_statement_unchanged_across_three_versions": len({c["natural_statement"] for c in versions}) == 1,
        "failed_archive_bound_to_v2": failed["subject"]["content_hash"] == versions[1]["content_hash"],
        "successful_archive_bound_to_v3": success["subject"]["content_hash"] == versions[2]["content_hash"],
        "v2_formal_text_matches_failed_archive": versions[1]["formal_statement"] == failed["lean_source"]["text"],
        "v3_formal_text_matches_successful_archive": versions[2]["formal_statement"] == success["lean_source"]["text"],
    }
    manifest = load(MANIFEST)
    paper = manifest["manuscripts"][0]
    reference = next(x for x in paper["tex_sources"] if x["path"] == "build/sections/04-localization.tex")
    manuscript = Path(paper["source_directory"]) / reference["path"]
    checks["manuscript_localization_hash_matches_reference_manifest"] = digest(manuscript) == reference["sha256"]
    write_json(REPLAY / "provenance_before.json", {
        "recorded_at": utc_now(),
        "old_inventory": before,
        "binding_checks": checks,
        "old_claim_versions": versions,
        "old_jet_evidence": [
            e for e in old_state["evidence"]
            if e.get("subject", {}).get("subject_id") == "C_LOC_JET"
        ],
        "old_successful_certificate": str(SUCCESS),
        "old_failed_certificate": str(FAILED),
        "source_sha256": hashlib.sha256(source).hexdigest(),
        "statement_fidelity_sha256": hashlib.sha256(note).hexdigest(),
        "manuscript_reference": {
            "manifest": str(MANIFEST), "source": str(manuscript),
            "expected_sha256": reference["sha256"], "actual_sha256": digest(manuscript),
            "source_revision": paper["source_revision"],
        },
        "current_C_REVIEW_before": review_subject(load(Path("research/MATH_STATE.json"))),
    })
    if not all(checks.values()):
        raise AssertionError(checks)
    for src, dst in [
        (OLD / "Main.lean", REPLAY / "Main.lean"),
        (OLD / "statement_fidelity.md", REPLAY / "statement_fidelity.md"),
        (OLD / "jacobian_payload.json", REPLAY / "jacobian/payload.json"),
        (OLD / "verify.py", REPLAY / "finite/archived_verify.py"),
        (OLD / "exact_certificate.json", REPLAY / "finite/archived_exact_certificate.json"),
    ]:
        dst.parent.mkdir(parents=True, exist_ok=True)
        if dst.exists():
            raise RuntimeError(f"Refusing to overwrite {dst}")
        shutil.copyfile(src, dst)
    write_json(REPLAY / "auxiliary_claim.json", {
        "claim_id": "C_REPLAY_ALG", "context": "CTX_REVIEW",
        "natural_statement": NATURAL_STATEMENT,
        "formal_file": str((ROOT / REPLAY / "Main.lean")),
        "scope": "A faithful reproduction, never mechanical evidence for C_REVIEW.",
    })
    print(json.dumps(checks))


def dependencies():
    work = REPLAY / "pip_work"
    work.mkdir(parents=True, exist_ok=True)
    try:
        status, _ = run_logged(
            REPLAY / "finite/dependency_install",
            [
                LATEST, "-m", "pip", "install", "--no-input", "--no-cache-dir",
                "--no-compile", "--disable-pip-version-check", "--target",
                str(DEPENDENCIES), "-r", str(REPLAY / "requirements-replay.txt"),
            ],
            timeout=110,
            extra_env={"TMPDIR": str(ROOT / work)},
        )
    finally:
        shutil.rmtree(work)
    if status["exit_code"] != 0:
        raise RuntimeError("The unit-local replay dependency installation failed.")


def finite():
    import sympy

    write_json(REPLAY / "finite/toolchain.json", {
        "python_executable": sys.executable, "python_version": sys.version,
        "sympy_version": sympy.__version__, "sympy_module": sympy.__file__,
        "checker_executed": str(OLD / "verify.py"),
        "checker_sha256": digest(OLD / "verify.py"),
        "copied_checker_sha256": digest(REPLAY / "finite/archived_verify.py"),
        "mode": "default; no --write-certificate",
        "expected_certificate": str(OLD / "exact_certificate.json"),
        "expected_certificate_sha256": digest(OLD / "exact_certificate.json"),
        "output_limit": "Default prints PASS only; archived_exact_certificate.json is the unchanged expected value, not fresh stdout.",
    })
    status, _ = run_logged(
        REPLAY / "finite/default",
        [LATEST, str(OLD / "verify.py")],
        timeout=110,
    )
    if status["exit_code"] != 0:
        raise RuntimeError("The exact default finite replay did not pass.")


def register():
    status, _ = run_logged(
        REPLAY / "lean_registration",
        [
            LATEST, "-m", "argus_skill.verticals.math.math_state", "claim",
            "--project-root", str(ROOT), "--id", "C_REPLAY_ALG",
            "--context", "CTX_REVIEW", "--statement", NATURAL_STATEMENT,
            "--formal-file", str(ROOT / REPLAY / "Main.lean"),
        ],
        json_output=True,
    )
    checks = official_checks("post_registration")
    if status["exit_code"] != 0 or any(checks.values()):
        raise RuntimeError("Auxiliary registration or current-root checks failed.")


def lean():
    status, stdout = run_logged(
        REPLAY / "lean_verification",
        [
            LATEST, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
            str(ROOT / REPLAY / "Main.lean"),
            "--statement-fidelity", str(ROOT / REPLAY / "statement_fidelity.md"),
            "--claim", "C_REPLAY_ALG", "--project-root", str(ROOT),
            "--artifact-dir", str(ROOT / REPLAY / "lean_evidence"),
            "--timeout", "45",
        ],
        json_output=True,
    )
    checks = official_checks("post_lean")
    result = json.loads(stdout)
    recorded = result.get("kernel", {}).get("recorded", {})
    certificate_path = Path(recorded["artifact"]) if recorded else None
    certificate = load(certificate_path) if certificate_path else {}
    state = load(Path("research/MATH_STATE.json"))
    claim = next(c for c in state["claims"] if c["claim_id"] == "C_REPLAY_ALG")
    bindings = {
        "copy_equals_old_source": (REPLAY / "Main.lean").read_bytes() == (OLD / "Main.lean").read_bytes(),
        "copy_equals_old_note": (REPLAY / "statement_fidelity.md").read_bytes() == (OLD / "statement_fidelity.md").read_bytes(),
        "compiled_source_equals_copy": Path(result["source"]).read_bytes() == (REPLAY / "Main.lean").read_bytes(),
        "compiled_note_equals_copy": Path(result["statement_fidelity"]).read_bytes() == (REPLAY / "statement_fidelity.md").read_bytes(),
        "compiled_source_hash_matches_old_success": result["source_sha256"] == load(SUCCESS)["lean_check"]["source_sha256"],
        "compiled_note_hash_matches_old_success": result["statement_fidelity_sha256"] == load(SUCCESS)["lean_check"]["statement_fidelity_sha256"],
        "claim_formal_text_equals_copy": claim["formal_statement"] == (REPLAY / "Main.lean").read_text(),
        "claim_natural_statement_exact": claim["natural_statement"] == NATURAL_STATEMENT,
        "certificate_subject_is_auxiliary_claim": certificate.get("subject", {}).get("subject_id") == "C_REPLAY_ALG",
        "certificate_subject_hash_matches_claim": certificate.get("subject", {}).get("content_hash") == claim["content_hash"],
        "certificate_archived_source_equals_copy": certificate.get("lean_source", {}).get("text") == (REPLAY / "Main.lean").read_text(),
        "certificate_archived_fidelity_equals_copy": certificate.get("statement_fidelity", {}).get("text") == (REPLAY / "statement_fidelity.md").read_text(),
    }
    write_json(REPLAY / "lean_binding.json", {
        "checks": bindings, "certificate": str(certificate_path),
        "claim_id": claim["claim_id"], "claim_version": claim["version"],
        "claim_content_hash": claim["content_hash"],
        "evidence": recorded,
        "copied_fidelity_names_old_claim": "The preserved note still says C_LOC_JET. It is intentionally not rewritten; the certificate binds its unchanged contents to auxiliary C_REPLAY_ALG.",
        "statement_fidelity_judgement": "Human unit assessment in report.md; compiler success is not a semantic comparison.",
    })
    if status["exit_code"] != 0 or result["status"] != "success" or any(checks.values()) or not all(bindings.values()):
        raise RuntimeError("Lean replay, binding or official checks failed.")
    (REPLAY / "Main.lean").unlink()


def jacobian_contract():
    status, _ = run_logged(
        REPLAY / "jacobian/contract",
        [ADAPTER, "-m", "argus_skill.tools.jacobian", "inspect", "--operation", OPERATION],
        json_output=True, timeout=110,
    )
    if status["exit_code"] != 0:
        raise RuntimeError("The operation contract was unavailable.")


def jacobian_run():
    status, stdout = run_logged(
        REPLAY / "jacobian/run",
        [
            ADAPTER, "-m", "argus_skill.tools.jacobian", "run",
            "--operation", OPERATION, "--payload-file",
            str(ROOT / REPLAY / "jacobian/payload.json"), "--timeout", "75",
        ],
        json_output=True, timeout=110,
    )
    try:
        output = json.loads(stdout)
    except (ValueError, UnicodeDecodeError):
        output = {}
    write_json(REPLAY / "jacobian/adapter_status.json", {
        **status, "operation_id": OPERATION, "adapter_timeout_seconds": 75,
        "structured_error": output.get("error"),
        "server": output.get("server"), "protocol_version": output.get("protocol_version"),
        "payload_file": str(REPLAY / "jacobian/payload.json"),
        "payload_sha256": digest(REPLAY / "jacobian/payload.json"),
        "payload_byte_identical_to_old": (REPLAY / "jacobian/payload.json").read_bytes() == (OLD / "jacobian_payload.json").read_bytes(),
        "one_live_run_only": True,
    })


def jacobian_compare():
    import sympy as sp

    status = load(REPLAY / "jacobian/adapter_status.json")
    if status["exit_code"] != 0 or status["structured_error"] or status["timed_out"]:
        write_json(REPLAY / "jacobian/independent_comparison.json", {
            "status": "non_conclusion", "reason": "The sole live adapter run did not return a successful typed result.",
            "no_retry": True,
        })
        return
    output = load(REPLAY / "jacobian/run.stdout.json")
    archived = load(OLD / "jacobian_output.json")
    payload = load(REPLAY / "jacobian/payload.json")

    def matrix(data):
        variables = data["variables"]
        symbols = [sp.Symbol(v) for v in variables]

        def rational(entry):
            if entry["variables"] != variables:
                raise ValueError("Mismatched ordered variables")

            def polynomial(data):
                result = sp.Integer(0)
                for term in data["terms"]:
                    if len(term["exponents"]) != len(symbols):
                        raise ValueError("Invalid exponent vector")
                    coefficient = term["coefficient"]
                    value = sp.Rational(coefficient["num"], coefficient["den"])
                    for symbol, exponent in zip(symbols, term["exponents"]):
                        if not isinstance(exponent, int) or exponent < 0:
                            raise ValueError("Invalid sparse exponent")
                        value *= symbol ** exponent
                    result += value
                return result

            denominator = polynomial(entry["denominator"])
            if denominator == 0:
                raise ValueError("Zero rational-function denominator")
            return sp.cancel(polynomial(entry["numerator"]) / denominator)

        return sp.Matrix([[rational(e) for e in row] for row in data["entries"]])

    left, right = matrix(payload["left"]), matrix(payload["right"])
    product = matrix(output["result"]["output"])
    historical = matrix(archived["result"]["output"])
    residuals = {
        "independent_row_column_product_minus_returned": (left * right - product).applyfunc(sp.cancel),
        "returned_minus_identity": (product - sp.eye(3)).applyfunc(sp.cancel),
        "returned_minus_archived_product": (product - historical).applyfunc(sp.cancel),
    }
    checks = {
        "request_operation_matches": output["request"]["operation_id"] == OPERATION,
        "request_payload_matches": output["request"]["payload"] == payload,
        "result_operation_matches": output["result"]["operation_id"] == OPERATION,
        "shape_is_3_by_3": product.shape == (3, 3),
        "typed_output_equal_to_archived_typed_output": output["result"]["output"] == archived["result"]["output"],
        **{name + "_is_zero": all(e == 0 for e in residual) for name, residual in residuals.items()},
    }
    write_json(REPLAY / "jacobian/independent_comparison.json", {
        "status": "pass" if all(checks.values()) else "mismatch",
        "checks": checks, "python_executable": sys.executable,
        "sympy_version": sp.__version__,
        "left": str(left), "right": str(right), "returned": str(product),
        "residuals": {name: str(residual) for name, residual in residuals.items()},
        "scope": "Only the exact historical 3x3 example over QQ(t), with t invertible.",
        "server_runtime_ms": output["result"].get("runtime_ms"),
    })
    if not all(checks.values()):
        raise AssertionError(checks)


def preservation():
    before = load(REPLAY / "provenance_before.json")
    comparisons = [
        {
            "path": item["path"], "before_sha256": item["sha256"],
            "after_sha256": digest(Path(item["path"])),
            "unchanged": item["sha256"] == digest(Path(item["path"])),
        }
        for item in before["old_inventory"]
    ]
    current_review = review_subject(load(Path("research/MATH_STATE.json")))
    write_json(REPLAY / "preservation_check.json", {
        "recorded_at": utc_now(), "old_inventory": comparisons,
        "all_26_old_inventory_paths_unchanged": all(c["unchanged"] for c in comparisons),
        "current_C_REVIEW_before": before["current_C_REVIEW_before"],
        "current_C_REVIEW_after": current_review,
        "current_C_REVIEW_unchanged": before["current_C_REVIEW_before"] == current_review,
        "mechanical_evidence_on_C_REVIEW_after": [
            e for e in current_review["evidence"] if e["tier"] == "mechanical"
        ],
    })


if __name__ == "__main__":
    if Path.cwd().resolve() != ROOT:
        raise SystemExit(f"Run from {ROOT}; all writes must remain below {UNIT}.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("stage", choices=[
        "prepare", "dependencies", "finite", "register", "lean", "jacobian_contract",
        "jacobian_run", "jacobian_compare", "preservation",
    ])
    globals()[parser.parse_args().stage]()
