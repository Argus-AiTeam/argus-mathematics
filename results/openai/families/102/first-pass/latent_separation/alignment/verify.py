#!/usr/bin/env python3
"""Rebuild imports and record official, source-bound Lean certification."""

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

from build import HERE, ROOT, PYTHON, lean_environment, sha256


CLAIM = "C_LATENT_ALIGNMENT_POLY"
SOURCE = "research/latent_separation/alignment/Main.lean"
FIDELITY = "research/latent_separation/alignment/statement_fidelity.md"
PREFIX = "argus_skill.verticals.math."
STATEMENT = (
    "For every natural r and finite indexed family t_e of distinct nonzero Boolean "
    "points with |E|>3r, put R=F2[T_ij] (three rows), F=Frac(R), "
    "z_i(e)=sum_j T_ij^2 t_ej, M_e,(i,j)=t_ej z_i(e), and "
    "c(e)=(sum_j T_0j t_ej)(sum_j T_1j t_ej)(sum_j T_2j t_ej). "
    "Then c(e)^2=z_0(e)z_1(e)z_2(e), and c is outside the F-column span of "
    "the actual matrix M. Moreover there exists P in R with P nonzero and "
    "totalDegree(P)<=6r+3 such that, for every commutative characteristic-two "
    "ring S and every assignment T* in S^(3r), if there are weights a_ij in S "
    "with sum_ij a_ij M_e,(i,j)(T*)=c(e)(T*) for every e, then P(T*)=0. "
    "The same obstruction holds for arbitrary ring homomorphisms R to S. "
    "In characteristic-two fields the specialized c(e) is the unique square "
    "root of the specialized product of the z_i(e). No distribution, "
    "probability bound, or geometric-extension-to-linear-system reduction "
    "is asserted as compiler-verified here."
)
THEOREMS = [
    "LatentAlignment.column_quadratic",
    "LatentAlignment.response_eq_radicalCombination",
    "LatentAlignment.responsePolynomial_sq",
    "LatentAlignment.actual_matrix_nonmembership",
    "LatentAlignment.independent_has_minor",
    "LatentAlignment.augmentedDet_degree",
    "LatentAlignment.specialized_response_unique_square_root",
    "LatentAlignment.exists_alignment_polynomial",
    "LatentAlignment.exists_alignment_polynomial_specialization",
]


def write_json(path, value):
    Path(path).write_text(json.dumps(value, indent=2) + "\n")


def run_logged(command, name, env):
    result = subprocess.run(command, cwd=ROOT, env=env, text=True, capture_output=True)
    if name == "revise_claim":
        write_json(HERE / "driver" / f"{name}.stdout", {
            "claim_id": CLAIM, "exit_code": result.returncode,
            "formal_file": SOURCE, "formal_source_sha256": sha256(ROOT / SOURCE),
            "note": "The CLI's full natural/formal claim JSON is intentionally suppressed.",
        })
    else:
        (HERE / "driver" / f"{name}.stdout").write_text(result.stdout)
    (HERE / "driver" / f"{name}.stderr").write_text(result.stderr)
    return result


def project_checks(label, env):
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        command = [
            PYTHON, "-m", PREFIX + module, "check", "--project-root", str(ROOT),
        ]
        result = run_logged(command, f"{label}_{module}", env)
        checks[module] = {"exit_code": result.returncode, "command": command}
    print(label + ": " + ", ".join(
        name + "=" + str(item["exit_code"]) for name, item in checks.items()
    ), flush=True)
    return checks


def hole_lists(value):
    if isinstance(value, dict):
        for key, child in value.items():
            if key == "proof_holes" and isinstance(child, list):
                yield child
            yield from hole_lists(child)
    elif isinstance(value, list):
        for child in value:
            yield from hole_lists(child)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--revise-claim", action="store_true",
                        help="Bind this exact theorem using the official locked ledger CLI.")
    args = parser.parse_args()
    env = lean_environment()
    (HERE / "driver").mkdir(exist_ok=True)
    before = {name: sha256(ROOT / name) for name in (SOURCE, FIDELITY)}
    checks = {}
    if args.revise_claim:
        command = [
            PYTHON, "-m", PREFIX + "math_state", "revise-claim",
            "--project-root", str(ROOT), "--id", CLAIM,
            "--statement", STATEMENT, "--formal-file", SOURCE,
        ]
        result = run_logged(command, "revise_claim", env)
        print(f"revise-claim: exit_code={result.returncode} (source JSON suppressed)", flush=True)
        checks["after_revise_claim"] = project_checks("after_revise_claim", env)
        if result.returncode:
            raise RuntimeError("Claim revision failed; inspect driver/revise_claim.stderr.")
    imports = run_logged([PYTHON, str(HERE / "build.py"), "imports"], "import_build", env)
    if imports.returncode:
        raise RuntimeError("Import build failed; inspect driver/import_build.stdout.")
    command = [
        PYTHON, "-m", PREFIX + "lean_evidence", "verify", SOURCE,
        "--statement-fidelity", FIDELITY, "--claim", CLAIM,
        "--project-root", ".",
    ]
    result = run_logged(command, "official_verify", env)
    checks["after_official_verify"] = project_checks("after_official_verify", env)
    after = {name: sha256(ROOT / name) for name in (SOURCE, FIDELITY)}
    if before != after:
        raise RuntimeError("Source or fidelity changed during certification.")
    try:
        official_result = json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        raise RuntimeError("Official verifier returned malformed JSON; inspect driver/official_verify.stdout.") from exc
    if not isinstance(official_result, dict):
        raise RuntimeError("Official verifier did not return a result object.")
    kernel = official_result.get("kernel", {})
    recorded = kernel.get("recorded") or {}
    if not recorded.get("artifact"):
        raise RuntimeError("Official verifier recorded no claim certificate; inspect driver/official_verify.stdout.")
    artifacts = []
    reported_holes = list(hole_lists(official_result))
    current_artifacts = [HERE / "lean_check.json", ROOT / recorded["artifact"]]
    for path in current_artifacts:
        artifacts.append({"path": str(path.relative_to(ROOT)), "sha256": sha256(path)})
        reported_holes.extend(hole_lists(json.loads(path.read_text())))
    certificate = {
        "schema_version": 1,
        "claim_id": CLAIM,
        "recorded_at": datetime.now(timezone.utc).isoformat(),
        "natural_statement": STATEMENT,
        "main_declarations": THEOREMS,
        "sources": before,
        "import_manifest": "research/latent_separation/alignment/imports/manifest.json",
        "import_manifest_sha256": sha256(HERE / "imports" / "manifest.json"),
        "official_command": command,
        "official_process_exit_code": result.returncode,
        "compilation_exit_code": (official_result or {}).get("exit_code"),
        "axiom_audit_exit_code": (official_result or {}).get("audit_exit_code"),
        "ledger_evidence_id": recorded.get("evidence_id"),
        "official_certificate": recorded.get("artifact"),
        "official_result": official_result,
        "official_artifacts": artifacts,
        "proof_holes": [hole for holes in reported_holes for hole in holes]
            if reported_holes else None,
        "structural_checks": checks,
        "source_and_fidelity_unchanged": before == after,
        "reproduce_imports": [PYTHON, "research/latent_separation/alignment/build.py", "imports"],
        "reproduce_verification": [PYTHON, "research/latent_separation/alignment/verify.py"],
        "scope_exclusions": [
            "finite-field sampling/distribution and probability estimates",
            "geometric-extension-to-linear-system reduction",
            "independent Reviewer acceptance",
            "literature novelty",
        ],
    }
    write_json(HERE / "exact_certificate.json", certificate)
    print(f"official verify: exit_code={result.returncode}; "
          f"proof_holes={certificate['proof_holes']}", flush=True)
    if result.returncode:
        raise RuntimeError("Official verification failed; inspect driver/official_verify.*.")
    if not reported_holes or certificate["proof_holes"]:
        raise RuntimeError("Official proof-hole evidence missing or nonempty.")
    if not official_result or any((
        official_result.get("status") != "success",
        certificate["compilation_exit_code"] != 0,
        certificate["axiom_audit_exit_code"] != 0,
        official_result.get("source_sha256") != before[SOURCE],
        official_result.get("statement_fidelity_sha256") != before[FIDELITY],
        recorded.get("subject", {}).get("subject_id") != CLAIM,
        recorded.get("tier") != "mechanical",
        recorded.get("verdict") != "supports",
        bool(kernel.get("refusals")),
    )):
        raise RuntimeError("Compilation, axiom audit, hashes, or ledger binding failed.")
    if any(item["exit_code"] for group in checks.values() for item in group.values()):
        raise RuntimeError("A structural check failed; inspect driver/ logs.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
