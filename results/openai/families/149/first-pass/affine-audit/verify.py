#!/usr/bin/env python3
"""Re-elaborate the complete affine proof and replay its exact certificate."""

import argparse
import json
import pathlib
import re
import subprocess
import sys
import urllib.request
from fractions import Fraction


HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"
BASE_URL = f"https://raw.githubusercontent.com/openai/math/{COMMIT}/lean/"
SEEDS = ["OAI.Analysis.MassAction.AffineExistence"]
CLAIM = "C149_AFFINE"

STATEMENT = r"""

namespace Campaign149

open Filter Topology
open OAI.Problem326.Affine

noncomputable section

/-- The literal cube-domain version of the shared manuscript lemma. -/
theorem literal_affine_lemma
    (m : ℕ) (_hm : 0 < m) (a b : ℝ) (hab : a < b)
    (E : {r : Fin m → ℝ // Cube a b r} → ℝ)
    (hE : ∀ r, 0 < E r) :
    ∃ (Λ : Finset (Label m)) (hs : ∀ L ∈ Λ, Cube a b L.slope),
      Λ.Nonempty ∧
      (∀ L ∈ Λ, L.offset =o[𝓝[>] (0 : ℝ)] (fun h => h ^ a)) ∧
      ∀ (L : Label m) (hL : L ∈ Λ)
        (h : ℕ → ℝ) (p : ℕ → (Fin m → ℝ)) (p₀ : Fin m → ℝ),
        (∀ n, 0 < h n) → Tendsto h atTop (𝓝 0) →
        Tendsto p atTop (𝓝 p₀) → Cube a b p₀ →
        (∀ n, Active Λ L (h n) (powerPoint (h n) (p n))) →
        ‖p₀ - L.slope‖ < E ⟨L.slope, hs L hL⟩ := by
  classical
  let extended : (Fin m → ℝ) → ℝ :=
    fun r => if hr : Cube a b r then E ⟨r, hr⟩ else 1
  have hpos : ∀ r, Cube a b r → 0 < extended r := by
    intro r hr
    simpa only [extended, dif_pos hr] using hE ⟨r, hr⟩
  obtain ⟨F⟩ := exists_fullCertificate m a b extended hab hpos
  refine ⟨F.labels, F.slopes, F.nonempty, F.offsets, ?_⟩
  intro L hL h p p₀ hh hh0 hp hp₀ hactive
  have hbound := F.approximation L hL h p p₀ hh hh0 hp hp₀ hactive
  simpa only [extended, dif_pos (F.slopes L hL)] using hbound

end
end Campaign149

#print axioms Campaign149.literal_affine_lemma
#print axioms OAI.Problem326.Affine.exists_fullCertificate
"""


def acquire():
    """Fetch licensed, pinned proof sources; flatten only internal imports."""
    ordered = []
    sources = {}
    visiting = set()

    def fetch(relative):
        with urllib.request.urlopen(BASE_URL + relative, timeout=30) as response:
            return response.read().decode("utf-8")

    def visit(module):
        if module in sources:
            return
        if module in visiting:
            raise RuntimeError(f"Import cycle at {module}")
        if not module.startswith("OAI.Analysis.MassAction."):
            raise RuntimeError(f"Unexpected non-Mathlib dependency: {module}")
        visiting.add(module)
        text = fetch(module.replace(".", "/") + ".lean")
        for line in text.splitlines():
            if line.startswith("import "):
                for dependency in line.split()[1:]:
                    if not dependency.startswith("Mathlib"):
                        visit(dependency)
        visiting.remove(module)
        sources[module] = text
        ordered.append(module)

    for seed in SEEDS:
        visit(seed)
    license_text = fetch("LICENSE")
    (HERE / "LICENSE.upstream").write_text(license_text, encoding="utf-8")
    blocks = [
        "/- Licensed upstream proof, OpenAI, Apache-2.0; see LICENSE.upstream.\n"
        f"Source: https://github.com/openai/math/tree/{COMMIT}/lean\n"
        "MODIFICATION: dependency-ordered concatenation, internal imports removed;\n"
        "Lean 4.31 API spellings: IsLittleO.fun_sum -> IsLittleO.sum,\n"
        "and dite_eq_left -> dif_pos (no mathematical change);\n"
        "the final Campaign149 theorem is an independently written statement adapter.\n"
        "No mathematical proof is attributed to the audit author. -/\n\n"
        "import Mathlib\n"
    ]
    for module in ordered:
        body = "\n".join(
            line for line in sources[module].splitlines()
            if not line.startswith("import ")
        )
        body = body.replace("IsLittleO.fun_sum", "IsLittleO.sum")
        body = body.replace("dite_eq_left", "dif_pos")
        blocks.append(f"\n/- BEGIN UPSTREAM MODULE {module} -/\n{body}\n")
    blocks.append(STATEMENT)
    (HERE / "Main.lean").write_text("\n".join(blocks), encoding="utf-8")
    manifest = {
        "schema_version": 1,
        "claim": CLAIM,
        "upstream_repository": "https://github.com/openai/math",
        "upstream_commit": COMMIT,
        "upstream_license": "Apache-2.0",
        "upstream_toolchain": "leanprover/lean4:v4.34.1",
        "required_replay_toolchain": "Lean 4.31.0",
        "module_order": ordered,
        "declarations": [
            "Campaign149.literal_affine_lemma",
            "OAI.Problem326.Affine.exists_fullCertificate",
        ],
        "trusted_axioms": ["propext", "Classical.choice", "Quot.sound"],
        "postcondition": {
            "all_positive_dimensions": True,
            "arbitrary_real_cube": True,
            "arbitrary_positive_discontinuous_cube_domain_tolerance": True,
            "fixed_finite_nonempty_slopes": True,
            "offsets_little_o_h_to_a": True,
            "strict_sup_norm_error_at_slope": True,
            "all_tied_minimizers": True,
            "approximating_sequences_may_leave_cube": True,
        },
        "classification": "independent_replay_of_existing_complete_proof",
        "novelty": "No new mathematical theorem is claimed.",
        "not_certified": [
            "The downstream mass-action theorems",
            "A publishable novelty claim",
            "Independent Reviewer acceptance",
        ],
        "replay": None,
    }
    (HERE / "exact_certificate.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Acquired {len(ordered)} complete proof modules into Main.lean.")


def replay_jacobian():
    payload_path = HERE / "jacobian-cut-payload.json"
    output_path = HERE / "jacobian-cut-output.json"
    if not payload_path.exists() or not output_path.exists():
        raise RuntimeError("The bounded Jacobian cut certificate has not been produced.")
    payload = json.loads(payload_path.read_text())
    output = json.loads(output_path.read_text())
    result = output["result"]["output"]
    if result.get("status") != "OPTIMAL":
        raise RuntimeError(f"Jacobian is not a mathematical conclusion: {result}")
    program = payload["program"]
    if output["request"]["payload"] != payload:
        raise RuntimeError("Jacobian output is bound to a different source program.")

    def rational(value):
        return Fraction(int(value["num"]), int(value["den"]))

    point = [rational(x) for x in result["primal_candidate"]]
    if point != [Fraction(1, 2), Fraction(1, 4)]:
        raise RuntimeError(f"Unexpected exact cut and margin: {point}")
    for row in program["constraints"]:
        lhs = sum(rational(c) * x for c, x in zip(row["coefficients"], point))
        rhs = rational(row["rhs"])
        if row["relation"] == "GE" and lhs < rhs:
            raise RuntimeError(f"Invalid inequality: {row['label']}")
        if row["relation"] == "LE" and lhs > rhs:
            raise RuntimeError(f"Invalid inequality: {row['label']}")
        if row["relation"] == "EQ" and lhs != rhs:
            raise RuntimeError(f"Invalid equality: {row['label']}")
    if point[1] <= 0 or point[0] - point[1] != Fraction(1, 4):
        raise RuntimeError("The closed LP did not supply a strict interior cut.")
    if point[0] + point[1] != Fraction(3, 4):
        raise RuntimeError("The upper cut margin is incorrect.")
    dual = [rational(x) for x in result["constraint_dual"]]
    if dual != [Fraction(-1, 2), Fraction(1, 2)]:
        raise RuntimeError("The source-coordinate optimality multipliers are incorrect.")
    stationarity = [
        sum(multiplier * rational(row["coefficients"][i])
            for multiplier, row in zip(dual, program["constraints"]))
        for i in range(2)
    ]
    if stationarity != [Fraction(0), Fraction(1)]:
        raise RuntimeError("The exact dual does not bound the requested objective.")
    upper_bound = sum(multiplier * rational(row["rhs"])
                      for multiplier, row in zip(dual, program["constraints"]))
    if upper_bound != point[1] or upper_bound != rational(result["primal_objective"]):
        raise RuntimeError("The exact primal and dual objectives disagree.")
    return {
        "operation_id": "optimization.linear.rational_general_optimum.compute",
        "scope": "One bounded illustration of strict interval-cut selection only.",
        "cut": "1/2",
        "strict_margin": "1/4",
        "universal_affine_evidence": False,
    }


def verify():
    manifest_path = HERE / "exact_certificate.json"
    manifest = json.loads(manifest_path.read_text())
    result = subprocess.run(
        [
            ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence",
            "verify", "--project-root", str(ROOT), "--claim", CLAIM,
            "--statement-fidelity", str(HERE / "statement_fidelity.md"),
            str(HERE / "Main.lean"),
        ],
        cwd=ROOT, capture_output=True, text=True,
    )
    print(result.stdout)
    if result.stderr:
        print(result.stderr, file=sys.stderr)
    validation = {}
    for module in ["math_state", "proof_graph_check"]:
        check = subprocess.run(
            [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
             "check", "--project-root", str(ROOT)],
            cwd=ROOT, capture_output=True, text=True,
        )
        validation[module] = check.returncode
        print(f"project_root={ROOT} {module}_exit={check.returncode}")
        if check.returncode:
            print(check.stdout, check.stderr, file=sys.stderr)
    if result.returncode:
        raise SystemExit(result.returncode)
    checked = json.loads(result.stdout)
    if checked["exit_code"] != 0 or checked["proof_holes"] != []:
        raise RuntimeError("The complete proof did not compile without holes.")
    if "4.31.0" not in json.dumps(checked):
        raise RuntimeError("The required Lean 4.31.0 compiler was not used.")
    if checked["kernel"]["recorded"] is None:
        raise RuntimeError("No mechanical ledger evidence was recorded.")
    log = (HERE / "compile.log").read_text()
    for declaration in manifest["declarations"]:
        pattern = rf"'{re.escape(declaration)}' depends on axioms:\s*\[([^\]]*)\]"
        match = re.search(pattern, log)
        if match is None:
            raise RuntimeError(f"No fresh axiom report for {declaration}")
        axioms = {name.strip() for name in match.group(1).split(",") if name.strip()}
        if not axioms <= set(manifest["trusted_axioms"]):
            raise RuntimeError(f"Untrusted axioms for {declaration}: {axioms}")
    if any(validation.values()):
        raise RuntimeError(f"Campaign-local structural validation failed: {validation}")
    manifest["replay"] = {
        "exit_code": 0,
        "proof_holes": [],
        "project_root": str(ROOT),
        "campaign_local_checks": validation,
        "mechanical_evidence": checked["kernel"]["recorded"],
        "jacobian": replay_jacobian(),
    }
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print("VERIFIED: complete literal affine lemma; no permanence or novelty claim.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--acquire", action="store_true",
                        help="Fetch pinned licensed sources and prepare the proof; not a check.")
    args = parser.parse_args()
    if args.acquire:
        acquire()
    else:
        verify()
