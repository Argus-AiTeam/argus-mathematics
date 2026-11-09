#!/usr/bin/env python3
"""Bounded read-only replay; every generated artifact stays beside this script."""

import argparse
from datetime import datetime, timezone
from fractions import Fraction
import hashlib
import json
import os
from pathlib import Path
import runpy
import signal
import subprocess
import sys
import time
import traceback


OUT = Path(__file__).resolve().parent
OLD = Path("families/066/first-pass/lc-slice-audit")
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
TOOLCHAIN = Path("$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0")
LIVE_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "polynomial.box.enclosure.compute"
ARCHIVE = "certificates/C_LC_PENALTY_ALG-acb7dd6349d2d7b2.json"
INPUTS = (
    "Main.lean", "statement_fidelity.md", "verify.py", "exact_certificate.json",
    ARCHIVE, "compile.log", "lean_check.json", "lean_submit.json",
    "jacobian_payload.json", "jacobian_response.json",
)
ADAPTER_CONTEXT = {
    "operation_id": OPERATION,
    "server": {"name": "jacobian", "version": "0.14.0"},
    "protocol_version": "2025-11-25",
    "transport": "mcp-stdio",
    "provenance": "Parent's prior authorized live discovery; no find repeated here.",
}


def now():
    return datetime.now(timezone.utc).isoformat()


def read(path):
    return json.loads(path.read_text(encoding="utf-8"))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dump(name, data):
    (OUT / name).write_text(
        json.dumps(data, indent=2, sort_keys=True, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def log(message):
    with (OUT / "replay.log").open("a", encoding="utf-8") as stream:
        stream.write(f"{now()} {message}\n")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def execute(command, cwd, timeout, extra_environment=None):
    environment = dict(os.environ)
    environment.update(
        PYTHONDONTWRITEBYTECODE="1", TMPDIR=str(OUT), TMP=str(OUT), TEMP=str(OUT)
    )
    if extra_environment:
        environment.update(extra_environment)
    started = time.monotonic()
    result = {
        "command": command, "cwd": str(cwd), "started_at": now(),
        "timeout_seconds": timeout, "timeout": False, "structured_error": None,
    }
    try:
        process = subprocess.Popen(
            command, cwd=cwd, env=environment, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, text=True, encoding="utf-8",
            errors="replace", start_new_session=True,
        )
        try:
            stdout, stderr = process.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            result["timeout"] = True
            os.killpg(process.pid, signal.SIGTERM)
            try:
                stdout, stderr = process.communicate(timeout=2)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                stdout, stderr = process.communicate(timeout=2)
        result.update(exit_code=process.returncode, stdout=stdout, stderr=stderr)
        if result["timeout"]:
            result["structured_error"] = {
                "kind": "timeout", "message": "Process group terminated at the bound."
            }
        elif process.returncode:
            result["structured_error"] = {
                "kind": "process_exit", "exit_code": process.returncode
            }
    except OSError as error:
        result.update(exit_code=None, stdout="", stderr="")
        result["structured_error"] = {
            "kind": type(error).__name__, "message": str(error)
        }
    result["duration_seconds"] = round(time.monotonic() - started, 6)
    result["finished_at"] = now()
    result["status"] = "completed" if result["structured_error"] is None else "inconclusive"
    log(json.dumps({
        key: result[key] for key in
        ("command", "cwd", "exit_code", "timeout", "duration_seconds", "status")
    }))
    return result


def arithmetic():
    started = time.monotonic()
    before = {name: digest(OLD / name) for name in INPUTS}
    # Only these two inspected functions execute: neither calls check_lean or main.
    sys.dont_write_bytecode = True
    verifier = runpy.run_path(str(OLD / "verify.py"), run_name="read_only_replay")
    identities = verifier["check_identities"]()
    historical_interval = verifier["check_jacobian"]()
    retained = read(OLD / "exact_certificate.json")
    require(identities == retained["polynomial_identities"], "Identity records differ")
    require(historical_interval == retained["jacobian"], "Historical enclosure differs")
    (OUT / "jacobian_payload.json").write_bytes((OLD / "jacobian_payload.json").read_bytes())

    source = (OLD / "Main.lean").read_bytes()
    fidelity = (OLD / "statement_fidelity.md").read_bytes()
    archive = read(OLD / ARCHIVE)
    check = read(OLD / "lean_check.json")
    submission = read(OLD / "lean_submit.json")
    compile_log = (OLD / "compile.log").read_text(encoding="utf-8")
    alignment = {
        "source_hash_matches_lean_check": before["Main.lean"] == check["source_sha256"],
        "fidelity_hash_matches_lean_check":
            before["statement_fidelity.md"] == check["statement_fidelity_sha256"],
        "archive_source_bytes_equal": archive["lean_source"]["text"].encode() == source,
        "archive_fidelity_bytes_equal": archive["statement_fidelity"]["text"].encode() == fidelity,
        "archive_lean_check_equals_standalone": archive["lean_check"] == check,
        "compile_log_has_same_compile_command":
            "$ " + " ".join(check["command"]) in compile_log,
        "compile_log_has_same_stdout": "--- stdout ---\n" + check["stdout"] in compile_log,
        "compile_log_has_same_audit_command":
            "$ " + " ".join(check["audit_command"]) in compile_log,
        "compile_log_has_success_and_both_zero_exits":
            all(item in compile_log for item in
                ("status: success", "exit_code: 0", "audit_exit_code: 0")),
        "retained_summary_has_same_exit_and_holes":
            retained["lean"]["exit_code"] == check["exit_code"]
            and retained["lean"]["proof_holes"] == check["proof_holes"],
    }
    require(all(alignment.values()), "Historical certificate alignment failed")
    require(before == {name: digest(OLD / name) for name in INPUTS}, "An old input changed")
    dump("arithmetic_replay.json", {
        "status": "verified_exact_arithmetic", "exit_code": 0, "timeout": False,
        "structured_error": None, "duration_seconds": round(time.monotonic() - started, 6),
        "executed_old_functions": ["check_identities", "check_jacobian"],
        "not_executed": ["main", "certificate", "check_lean"],
        "old_verifier_cli": {
            "safe_output_redirect_option": False,
            "reason": "--write-certificate writes HERE; certificate/check_lean also reads the excluded ledger.",
        },
        "arithmetic": "Sparse multivariate polynomial arithmetic over fractions.Fraction; no floating point.",
        "polynomial_identities": identities,
        "historical_jacobian_exact_interval_replay": historical_interval,
        "infinite_family_formulas_read": retained["adversarial_family"],
        "infinite_family_algebra_replayed": [
            "m*(1+q)-m=m*q, identically in m and q",
            "(2+q)-2=q, identically in q",
            "(q+2*lam)^2-4*lam^2*(1+q)=q*(q+4*lam*(1-lam))",
            "Dividing the last identity by 1+q gives the retained volume-excess expression.",
            "For q>0 and 0<lam<1 its numerator and denominator are positive.",
            "For positive integer m, (m*q)/m=q follows by nonzero cancellation.",
        ],
        "scope": "Conditional arithmetic identities and factor signs only, not geometric valuation formulas.",
        "not_replayed": [
            "The geometric identifications of discrepancy, retraction, or valuation volume.",
            "The original verifier's ledger version/hash/evidence linkage check.",
            "The complete geometric proof, manuscript encodings, or novelty.",
        ],
        "old_inputs_sha256": before, "old_input_bytes_unchanged": True,
        "payload_copy_byte_identical": digest(OUT / "jacobian_payload.json") == before["jacobian_payload.json"],
    })
    dump("historical_alignment.json", {
        "alignment": alignment, "old_inputs_sha256": before,
        "source_sha256": before["Main.lean"],
        "statement_fidelity_sha256": before["statement_fidelity.md"],
        "archive_subject": archive["subject"],
        "archive_evidence_id": archive["evidence_id"],
        "archive_claim_version_as_retained": retained["lean"]["claim_version"],
        "ledger_content_hash_recomputed": False,
        "ledger_read": False,
        "historical_compiler": check,
        "historical_submission_receipt": submission,
        "duplication_audit": {
            "one_compilation_record":
                "Archive.lean_check equals lean_check.json; compile.log repeats its commands and warnings.",
            "summary_not_another_run":
                "exact_certificate.json repeats the exit code, holes and toolchain.",
            "submission_not_success":
                "lean_submit.json records submitted state only, not a second completed compiler check.",
            "two_historical_commands":
                "One source compile and one separate axiom-audit command, both recorded as exit 0.",
        },
        "label_scope": {
            "exact_certificate_claim_label": retained["claim"],
            "lean_archive_subject": archive["subject"]["subject_id"],
            "difference":
                "The broader bridge label is not a Lean theorem of geometry; the retained certificate itself leaves geometric theorems open.",
            "current_review_mechanical_evidence_attached": False,
        },
        "statement_analysis": {
            "LCSliceAudit.exact_penalty": {
                "quantifiers": "For every e, lam, C, D, B, b, h, R, V in Real.",
                "hypotheses": [
                    "0<e", "0<lam", "0<=C", "0<=D", "0<=B",
                    "0<b", "b<=B", "0<R", "b-D*e<=h",
                    "R/(1+C*e)<=V", "lam*(D+C*B)<1",
                ],
                "conclusion": "lam*b*R < (e+lam*h)*V",
                "comparison_to_natural_claim_as_recorded_in_fidelity_and_sign_certificate":
                    "The natural claim additionally assumes e+lam*h>0; Lean omits it, a strengthening.",
                "redundancy": [
                    "The displayed proof derives e+lam*h > lam*b*(1+C*e)>0.",
                    "V>0 is derived, not assumed.",
                    "hD and hB are not explicitly referenced by this proof, matching compiler warnings.",
                    "B>=0 already follows from 0<b<=B; D>=0 is unused in the displayed scalar proof.",
                ],
            },
            "LCSliceAudit.common_budget": {
                "quantifiers": "For every lam, S in Real.",
                "hypotheses": ["0<lam", "0<=S", "lam<=1/(2*(1+S))"],
                "conclusion": "lam*S<1/2",
                "scope":
                    "Substitution S=D+C*B yields a common budget if the geometric constants are uniform. It is not invoked by the other two declarations.",
            },
            "LCSliceAudit.minimizer_defect_zero": {
                "quantifiers":
                    "For every universe-polymorphic type T, e,h,root:T->Real, r:T->T, u:T, and lam,C,D,B in Real.",
                "hypotheses": [
                    "0<lam", "0<=C", "0<=D", "0<=B", "lam*(D+C*B)<1",
                    "0<=e(u)", "e(r(u))=0", "0<h(r(u))", "h(r(u))<=B",
                    "0<root(r(u))", "h(r(u))-D*e(u)<=h(u)",
                    "root(r(u))/(1+C*e(u))<=root(u)",
                    "For all w:T, (e(u)+lam*h(u))*root(u) <= (e(w)+lam*h(w))*root(w)",
                ],
                "conclusion": "e(u)=0",
                "scope": [
                    "Functions and map are arbitrary; no valuation construction or retraction laws are assumed or proved.",
                    "Comparisons and defect conditions are only imposed at u and r(u), not globally.",
                    "The proof uses global minimality only for w=r(u); a single comparison would suffice.",
                    "No minimizer existence, uniform geometric comparisons, sublevel membership, or volume-limit theorem is proved.",
                ],
            },
            "compiler_scope":
                "Scalar algebra/order and conditional abstract minimizer reduction only; not the geometric bridge or manuscript conclusions.",
            "fidelity_document":
                "Matches these declarations and explicitly disclaims geometry; its assertion that the proof note establishes uniform comparisons is not compiler evidence.",
        },
    })
    log("Exact arithmetic and historical source/fidelity/certificate/log alignment completed; no ledger read.")


def jacobian(action):
    require(action in ("inspect", "run"), "Unsupported adapter action")
    contract = None
    command = [LIVE_PYTHON, "-B", "-m", "argus_skill.tools.jacobian", action,
               "--operation", OPERATION]
    if action == "run":
        inspection = read(OUT / "jacobian_inspect.json")
        require(inspection["exit_code"] == 0 and not inspection["timeout"]
                and inspection["typed_output"] is not None, "No completed typed inspection")
        contract = inspection["typed_output"]["result"]["operation"]
        require(contract["operation_id"] == OPERATION and contract["read_only"],
                "The inspected contract is not the expected read-only operation")
        require(set(contract["input_schema"]["required"]) == {"polynomial", "box"},
                "Unexpected input contract")
        require(digest(OUT / "jacobian_payload.json") == digest(OLD / "jacobian_payload.json"),
                "Replay payload is not byte-identical")
        command.extend(["--payload-file", str(OUT / "jacobian_payload.json"), "--timeout", "30"])
    result = execute(command, OUT, 45 if action == "inspect" else 60)
    result["adapter_context"] = ADAPTER_CONTEXT
    result["operation_id"] = OPERATION
    try:
        typed = json.loads(result["stdout"])
    except (ValueError, TypeError):
        typed = None
        if result["structured_error"] is None:
            result["structured_error"] = {"kind": "non_json_output"}
            result["status"] = "inconclusive"
    result["typed_output"] = typed
    result["geometric_result"] = None
    if contract is not None:
        result["contract_applicability"] = {
            "read_only": contract["read_only"],
            "input_type": contract["input_schema"]["title"],
            "output_type": contract["output_schema"]["title"],
            "reviewed_payload": "QQ polynomial 1-t, ordered axis [t], closed box [0,1/2].",
            "canonical_input": "Two nonzero terms, exponent tuples [1] then [0], reduced positive-denominator rationals.",
            "bounds": "One axis, two terms, degree one: within all advertised bounds.",
            "contract_limitation": "Sound enclosure, not necessarily exact range; containing zero does not establish a root.",
        }
    if isinstance(typed, dict):
        result["reported_server"] = typed.get("server")
        result["reported_protocol_version"] = typed.get("protocol_version")
        result["reported_transport"] = typed.get("transport")
        body = typed.get("result", {})
        errors = [value["error"] for value in (typed, body)
                  if isinstance(value, dict) and "error" in value]
        if errors:
            result["structured_error"] = {"kind": "typed_adapter_error", "errors": errors}
            result["status"] = "inconclusive"
        if action == "run" and result["structured_error"] is None:
            try:
                require(body.get("status", "completed") in ("success", "completed"),
                        "Operation status is nonconclusive")
                require(body["operation_id"] == OPERATION, "Wrong executed operation")
                payload = read(OUT / "jacobian_payload.json")
                require(typed["request"]["payload"] == payload, "Payload echo mismatch")
                output = body["output"]
                require(output["polynomial"] == payload["polynomial"]
                        and output["box"] == payload["box"], "Output input mismatch")
                enclosure = output["enclosure"]
                lower = Fraction(int(enclosure["lower"]["num"]), int(enclosure["lower"]["den"]))
                upper = Fraction(int(enclosure["upper"]["num"]), int(enclosure["upper"]["den"]))
                require((lower, upper) == (Fraction(1, 2), Fraction(1)),
                        "The live enclosure differs from the exact retained interval")
                result["arithmetic_sanity"] = {
                    "enclosure": [str(lower), str(upper)],
                    "equals_historical_exact_interval": (lower, upper) == (Fraction(1, 2), Fraction(1)),
                    "payload_byte_identical": True,
                    "scope": "Enclosure of 1-t on [0,1/2] only; no geometric inference.",
                }
            except (KeyError, TypeError, ValueError, ZeroDivisionError) as error:
                result["structured_error"] = {
                    "kind": "incomplete_or_nonconclusive_typed_output", "message": str(error)
                }
                result["status"] = "inconclusive"
    dump(f"jacobian_{action}.json", result)


def compiler():
    source_before = digest(OLD / "Main.lean")
    fidelity_before = digest(OLD / "statement_fidelity.md")
    old_names_before = sorted(path.name for path in OLD.iterdir())
    manifest = read(WORKSPACE / "lake-manifest.json")
    package_builds = [
        WORKSPACE / ".lake/packages" / package["name"] / ".lake/build/lib/lean"
        for package in manifest["packages"]
    ]
    search_path = [WORKSPACE / ".lake/build/lib/lean"] + package_builds
    search_path = [path for path in search_path if path.is_dir()]
    mathlib_object = WORKSPACE / ".lake/packages/mathlib/.lake/build/lib/lean/Mathlib.olean"
    lean = TOOLCHAIN / "bin/lean"
    require(lean.is_file() and mathlib_object.is_file(), "Installed compiler/prebuilt Mathlib unavailable")
    versions = {
        "lean": execute([str(lean), "--version"], WORKSPACE, 2),
        "lake": execute([str(TOOLCHAIN / "bin/lake"), "--version"], WORKSPACE, 2),
        "elan": execute(["$WORKSPACE/.elan/bin/elan", "--version"], WORKSPACE, 2),
    }
    environment = {
        "LEAN_PATH": os.pathsep.join(map(str, search_path)),
        "LD_LIBRARY_PATH": os.pathsep.join(str(path.parent) for path in search_path),
    }
    result = execute([str(lean), str(OLD / "Main.lean")], WORKSPACE, 90, environment)
    result.update({
        "source_sha256": source_before,
        "statement_fidelity_sha256": fidelity_before,
        "toolchain_versions": versions,
        "lean_toolchain_file": (WORKSPACE / "lean-toolchain").read_text(encoding="utf-8"),
        "workspace_manifest_sha256": digest(WORKSPACE / "lake-manifest.json"),
        "workspace_package_revisions": {
            package["name"]: package["rev"] for package in manifest["packages"]
        },
        "prebuilt_mathlib_object": str(mathlib_object),
        "compiler_environment_overrides": environment,
        "source_bytes_unchanged": source_before == digest(OLD / "Main.lean"),
        "fidelity_bytes_unchanged": fidelity_before == digest(OLD / "statement_fidelity.md"),
        "old_directory_entry_names_unchanged":
            old_names_before == sorted(path.name for path in OLD.iterdir()),
        "output_artifact_flags": [],
        "fresh_axiom_audit": "not_run; applicable historical audit is preserved in historical_alignment.json",
        "scope":
            "Compiler replay of the exact old read-only source, not a certificate for the current review or for geometry.",
        "timeout_interpretation": "If timed out, nonconclusive; do not infer compilation failure.",
    })
    dump("compiler_replay.json", result)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("arithmetic", "jacobian-inspect", "jacobian-run", "compiler"))
    args = parser.parse_args()
    try:
        if args.action == "arithmetic":
            arithmetic()
        elif args.action == "compiler":
            compiler()
        else:
            jacobian(args.action.removeprefix("jacobian-"))
    except Exception as error:
        dump(f"{args.action}_error.json", {
            "status": "inconclusive", "timeout": False, "exit_code": 1,
            "structured_error": {"kind": type(error).__name__, "message": str(error)},
            "traceback": traceback.format_exc(),
        })
        log(f"{args.action}: {type(error).__name__}: {error}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
