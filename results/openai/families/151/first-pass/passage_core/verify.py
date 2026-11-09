#!/usr/bin/env python3
"""Replay the exact algebra and compile the universal nonlinear passage theorem."""

import json
import subprocess
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "polynomial.ideal.normal_form.compute"
DECLARATION = "PassageCore.Orbit.complete_passage"


def polynomial(value):
    terms = {}
    for term in value["polynomial"]["terms"]:
        exponent = tuple(term["exponents"])
        coefficient = term["coefficient"]
        if exponent in terms:
            raise ValueError("Duplicate polynomial monomial")
        terms[exponent] = Fraction(int(coefficient["num"]), int(coefficient["den"]))
    return {exponent: coefficient for exponent, coefficient in terms.items() if coefficient}


def exact_algebra():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    if response["request"] != {"operation_id": OPERATION, "payload": payload}:
        raise ValueError("Jacobian output is not bound to the exact input payload")
    if response["result"]["operation_id"] != OPERATION:
        raise ValueError("Unexpected Jacobian operation")
    output = response["result"]["output"]
    if output["outcome"] != "COMPUTED" or output["in_ideal"] is not True:
        raise ValueError("Jacobian did not compute a conclusive ideal membership")
    if polynomial(output["remainder"]):
        raise ValueError("Jacobian returned a nonzero remainder")
    if payload["ideal"]["variables"] != ["z", "r", "b", "c", "v", "w"]:
        raise ValueError("Unexpected exact polynomial ring")
    g1, g2 = map(polynomial, payload["ideal"]["generators"])
    residual = polynomial(payload["polynomial"])
    for exponent, coefficient in g2.items():
        residual[exponent] = residual.get(exponent, Fraction(0)) - coefficient
    for exponent, coefficient in g1.items():
        shifted = list(exponent)
        shifted[2] += 1
        shifted = tuple(shifted)
        residual[shifted] = residual.get(shifted, Fraction(0)) - 2 * coefficient
    if any(residual.values()):
        raise ValueError("The exact identity P=g2+2*b*g1 is false")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": 0,
        "typed_outcome": output["outcome"],
        "independent_rational_syzygy": "P = g2 + 2*b*g1",
        "verified": True,
    }


def source_markers():
    directory = (
        ROOT
        / "research/openai_manuscript"
        / "A-C1-Counterexample-to-the-Entropy-Conjecture-September-25-2026"
        / "build/source"
    )
    expected = {
        "construction.tex": [
            r"\label{eq:clock-barrier}",
            r"\label{eq:clock-increment}",
            r"\label{eq:readout-cover}",
            r"\label{eq:gain-choice}",
            r"\label{eq:register-gain}",
            r"\label{eq:input}",
            r"L^{1-m}\beta_\ell(T_m(t,z))",
            r"\left(\frac{z}{|z|}\right)^{2^{m+1}}",
            r"\label{eq:map}",
            "All right-hand sides use the old state.",
        ],
        "orbits.tex": [
            r"\label{lem:passage-preparation}",
            r"\label{lem:clock-prediction}",
            r"\label{lem:register-linearity}",
            r"\label{lem:passage-escape}",
            r"2\sum_{\ell=1}^q\beta_\ell(s_j)^2",
        ],
    }
    for filename, markers in expected.items():
        text = (directory / filename).read_text()
        for marker in markers:
            if marker not in text:
                raise ValueError(f"Staged source marker changed: {filename}: {marker}")
    return {
        "staged_definitions_present": True,
        "translation_document": "research/passage_core/statement_fidelity.md",
        "translation_independently_reviewed": False,
        "note": "Marker checks detect source mismatch; they do not prove statement fidelity.",
    }


def main():
    algebra = exact_algebra()
    source = source_markers()
    command = [
        ARGUS,
        "-m",
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        "--project-root",
        str(ROOT),
        "--claim",
        "C_PASSAGE_CORE",
        "--statement-fidelity",
        str(HERE / "statement_fidelity.md"),
        str(HERE / "Main.lean"),
    ]
    run = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
    (HERE / "lean_verification.json").write_text(run.stdout)
    if run.returncode:
        raise RuntimeError(f"Official Lean verification failed ({run.returncode}):\n{run.stdout}\n{run.stderr}")
    result = json.loads(run.stdout)
    if result["status"] != "success" or result["exit_code"] != 0 or result["proof_holes"] != []:
        raise RuntimeError("The compiler did not certify a zero-hole theorem")
    if result["kernel"]["recorded"] is None:
        raise RuntimeError("The compiler result was not attached to C_PASSAGE_CORE")
    compiler_output = result.get("stdout", "")
    if DECLARATION not in compiler_output:
        raise RuntimeError("The compiler output does not name the intended theorem")
    if "sorryAx" in compiler_output:
        raise RuntimeError("The theorem depends on a proof hole")
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        checked = subprocess.run(
            [
                ARGUS,
                "-m",
                f"argus_skill.verticals.math.{module}",
                "check",
                "--project-root",
                str(ROOT),
            ],
            cwd=ROOT,
            capture_output=True,
            text=True,
            check=False,
        )
        checks[module] = {"exit_code": checked.returncode, "output": checked.stdout.strip()}
        if checked.returncode:
            raise RuntimeError(f"Campaign-local {module} check failed:\n{checked.stdout}\n{checked.stderr}")
    certificate = {
        "claim_id": "C_PASSAGE_CORE",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "result_class": "new_theorem",
        "classification": "exact formal verification and structural generalization",
        "declaration": DECLARATION,
        "quantification": "Every q, every Data q, every N, every Orbit D N; no upper bound on N or on prediction delays.",
        "conclusions": [
            "reset before preparation and preparation radius strictly above one half",
            "actual and predicted clock agreement through readout",
            "at most one readout per channel",
            "phase-independent register linearity through each register's own readout",
            "exact radial addition 2*sum(beta_l^2)*sum(alpha_i*chi_i)",
            "nonvanishing, phase doubling, square lower bounds, and compulsory escape before passage end",
        ],
        "arbitrary_post_readout_saturation": True,
        "overlapping_channels_allowed": True,
        "gain_and_exponent": {"gain": "L^(1-m)", "exponent": "2^(m+1)"},
        "lean": {
            "command": command,
            "exit_code": result["exit_code"],
            "proof_holes": result["proof_holes"],
            "compiler_output": compiler_output.strip(),
            "kernel_recording": result["kernel"],
            "result_file": "research/passage_core/lean_verification.json",
        },
        "exact_algebra": algebra,
        "source_application": source,
        "campaign_validation": {"project_root": str(ROOT), "checks": checks},
        "independent_review": {"required": True, "status": "pending_host_invocation"},
        "significance_status": "awaiting_independent_review",
        "novelty_status": "not_yet_independently_assessed",
        "global_theorem_certified": False,
        "verified_at": datetime.now(timezone.utc).isoformat(),
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    activity = {
        "ts": certificate["verified_at"],
        "role": "engineer",
        "agent": "gpt-6.1-sol",
        "kind": "formal_verification",
        "action": f"Certified {DECLARATION} with a fresh real Lean run, exit_code=0 and proof_holes=[]; campaign-local math_state and proof_graph_check both exited 0 at {ROOT}. Independent source-fidelity review remains pending.",
        "status": "kernel_verified_review_pending",
        "artifact": "research/passage_core/exact_certificate.json",
    }
    with (ROOT / "activity.jsonl").open("a") as stream:
        stream.write(json.dumps(activity) + "\n")
    print(json.dumps({
        "claim": "C_PASSAGE_CORE",
        "lean_exit_code": 0,
        "proof_holes": [],
        "project_root": str(ROOT),
        "math_state_exit_code": checks["math_state"]["exit_code"],
        "proof_graph_exit_code": checks["proof_graph_check"]["exit_code"],
        "independent_review": "pending_host_invocation",
        "certificate": "research/passage_core/exact_certificate.json",
    }, indent=2))


if __name__ == "__main__":
    main()
