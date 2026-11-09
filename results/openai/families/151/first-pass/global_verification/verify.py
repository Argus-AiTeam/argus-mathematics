#!/usr/bin/env python3
"""Replay exact algebra and source-bound evidence, not the whole prose proof."""

import hashlib
import itertools
import json
import subprocess
from collections import Counter
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / "research/global_verification"
PRIMARY = BASE / "primary_sources"
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPENAI = "fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb"
MATHLIB = "d13f23b723b8a846827a245b89c10fc7d3f11612"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(path):
    return json.loads(path.read_text())


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def blob_sha(path):
    data = path.read_bytes()
    return hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()


def latest(state, claim_id):
    claims = [c for c in state["claims"] if c["claim_id"] == claim_id]
    require(bool(claims), f"Missing claim {claim_id}")
    return max(claims, key=lambda c: c["version"])


def source_bindings():
    provenance = load(PRIMARY / "provenance.json")
    require(provenance["openai_commit"] == OPENAI, "Wrong OpenAI revision")
    require(provenance["published_mathlib_commit"] == MATHLIB, "Wrong Mathlib revision")
    for name, digest in provenance["retrieved_sha256"].items():
        require(sha256(PRIMARY / name) == digest, f"Changed primary source: {name}")
    directory = load(PRIMARY / "openai_source_tree.json")
    require(directory["commit"] == OPENAI, "Source metadata is not pinned")
    metadata = {p["path"]: p for p in directory["entries"]}
    extra = load(PRIMARY / "openai_homology_metadata.json")
    require(OPENAI in extra["html_url"], "Unpinned homology realization metadata")
    metadata[extra["path"]] = extra
    result = {}
    for path in sorted((BASE / "upstream").glob("*.lean.txt")):
        if path.name.startswith("Mathlib_"):
            continue
        prefix = "lean/OAI/Dynamics/EntropyCounterexample/"
        if path.name == "MapRealizedHomology.lean.txt":
            prefix = "lean/OAI/Geometry/SingularHomology/"
        name = prefix + path.name.removesuffix(".txt")
        require(name in metadata, f"Source not covered by frozen metadata: {name}")
        require(blob_sha(path) == metadata[name]["sha"], f"Changed release source: {name}")
        result[name] = metadata[name]["sha"]
    require(
        all(
            "lean/OAI/Dynamics/EntropyCounterexample/" + name + ".lean" in result
            for name in ("Definitions", "Assembly", "Counterexample", "Map", "MapData",
                         "RealizedConstruction", "MapC1Complete", "MapEntropyComplete")
        ),
        "Missing a load-bearing release source",
    )
    for name, meta_name in (
        ("Mathlib_CoverEntropy.lean.txt", "mathlib_entropy_metadata.json"),
        ("Mathlib_SingularHomology_Basic.lean.txt", "mathlib_homology_metadata.json"),
    ):
        meta = load(PRIMARY / meta_name)
        require(MATHLIB in meta["html_url"], f"Unpinned Mathlib metadata: {name}")
        require(blob_sha(BASE / "upstream" / name) == meta["sha"],
                f"Changed Mathlib definition: {name}")
        result["Mathlib@" + MATHLIB + "/" + meta["path"]] = meta["sha"]
    manifest = (PRIMARY / "MANIFEST.txt").read_text()
    require(OPENAI in manifest and "leanprover/lean4:v4.34.1" in manifest
            and MATHLIB in manifest, "Historical manifest does not match the reused run")
    records = [
        json.loads(line) for line in (PRIMARY / "comparator_all.jsonl").read_text().splitlines()
    ]
    matches = [r for r in records if r["config"] == "C1EntropyCounterexample"]
    require(len(matches) == 1, "Historical acceptance is missing or ambiguous")
    accepted = matches[0]
    require(accepted["solution"] == "OAI.Dynamics.EntropyCounterexample.Counterexample",
            "Wrong historical solution")
    require(accepted["outcome"] == "accepted" and accepted["theorem_count"] == 1
            and accepted["build_exit"] == 0, "Historical solution was not accepted")
    require(accepted["nanoda"] is False and accepted["build_skipped"] is True,
            "Historical run flags differ from the report")
    config = load(PRIMARY / "challenge_config.json")
    require(config["theorem_names"] == ["OAI.Problem340.exists_C1_entropy_counterexample"]
            and config["definition_names"] == [], "Challenge statement/definition holes changed")
    require(set(config["permitted_axioms"]) == {"propext", "Quot.sound", "Classical.choice"},
            "Wrong permitted axioms")
    return {"openai_commit": OPENAI, "mathlib_commit": MATHLIB,
            "source_blob_identities": result, "historical_acceptance": accepted,
            "fresh_upstream_compilation": False}


def kernel_binding(state, claim_id, source, fidelity, require_review):
    claim = latest(state, claim_id)
    evidence = [
        e for e in state["evidence"]
        if e["subject"]["subject_id"] == claim_id
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
    ]
    require(len(evidence) == 1, f"Expected one current kernel certificate for {claim_id}")
    item = evidence[0]
    certificate = load(ROOT / item["artifact"])
    check = certificate["lean_check"]
    require(certificate["subject"]["content_hash"] == claim["content_hash"],
            f"Stale kernel claim binding: {claim_id}")
    require(check["exit_code"] == 0 and check["proof_holes"] == []
            and check["audit_exit_code"] == 0, f"Unverified Lean source: {claim_id}")
    require("version 4.31.0," in check["tools"]["lean"]["version"], "Wrong campaign Lean version")
    require(sha256(source) == check["source_sha256"]
            and source.read_text() == claim["formal_statement"],
            f"Changed formal source: {claim_id}")
    require(sha256(fidelity) == check["statement_fidelity_sha256"],
            f"Changed statement-fidelity document: {claim_id}")
    require(sha256(ROOT / certificate["lean_source"]["path"]) == check["source_sha256"],
            f"Changed compiled copy: {claim_id}")
    require(sha256(ROOT / certificate["statement_fidelity"]["path"])
            == check["statement_fidelity_sha256"], f"Changed compiled reading: {claim_id}")
    require("sorryAx" not in check["stdout"], f"Unexpected proof-hole axiom: {claim_id}")
    reviewers = [
        e["produced_by"] for e in state["evidence"]
        if e["subject"]["subject_id"] == claim_id
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "judgement" and e["verdict"] == "supports"
        and e["produced_by"].startswith("reviewer:")
    ]
    if require_review:
        require(bool(reviewers), f"No existing independent judgement for {claim_id}")
    return {"claim_id": claim_id, "version": claim["version"], "certificate": item["artifact"],
            "exit_code": 0, "proof_holes": [], "audit_exit_code": 0,
            "source_sha256": check["source_sha256"],
            "statement_fidelity_sha256": check["statement_fidelity_sha256"],
            "independent_reviewers": reviewers, "recompiled_by_this_replay": False}


def exact_algebra():
    a, b, u, v, d, z, w, c, s = sp.symbols("a b u v d z w c s", real=True)
    require(sp.expand((a + sp.I*b)*(u + sp.I*v)
                      - (a*u-b*v + sp.I*(b*u+a*v))) == 0,
            "Real-pair complexification sign failed")
    require(sp.expand((a+sp.I*b)*(a-sp.I*b) - (a*a+b*b)) == 0,
            "Eigenvalue modulus identity failed")
    f, g = (d-a)*u+b*v, (d-a)*v-b*u
    determinant = (d-a)**2+b*b
    require(sp.expand((d-a)*f-b*g-determinant*u) == 0
            and sp.expand(b*f+(d-a)*g-determinant*v) == 0,
            "Diagonal paired-eigenvalue certificate failed")
    require(sp.cancel((1/(z*z+(1-s)*c)).subs(z, 1/w)
                      - w*w/(1+(1-s)*c*w*w)) == 0,
            "Joint pole-homotopy formula failed")
    gain, bound, x0, xb, x2 = sp.symbols("L B x0 xB x2")
    tail = gain*x0/(1-1/gain) + gain*xb/(1-bound/gain) + 2*gain*x2/(1-2/gain)
    next_tail = tail.subs({x0:x0/gain, xb:xb*bound/gain, x2:2*x2/gain}, simultaneous=True)
    require(sp.cancel(tail-next_tail-gain*(x0+xb+2*x2)) == 0,
            "Geometric derivative-tail identity failed")
    centers = [Fraction(76) + Fraction(i, 2) for i in range(3)]
    require(all(Fraction(74) < x-Fraction(9,20)
                and x+Fraction(9,20) < Fraction(80) for x in centers),
            "Closed readout supports are out of range")
    require(2*Fraction(9,20) < 1 and centers[0]-Fraction(1,4) <= 76
            and centers[-1]+Fraction(1,4) >= 77
            and all(y-x <= Fraction(1,2) for x,y in zip(centers,centers[1:])),
            "Plateau cover or strict single-hit width failed")
    q, eigenvalues, betti = 3, [], Counter()
    for circle in (0,1):
        for spheres in itertools.product((0,1), repeat=q+1):
            betti[circle+2*sum(spheres)] += 1
            eigenvalues.append(0 if any(spheres[1:]) else 2 if spheres[0] else 1)
    require([betti[n] for n in range(10)] == [1,1,4,4,6,6,4,4,1,1], "Wrong Betti vector")
    t = sp.Symbol("lambda")
    polynomial = sp.prod(t-e for e in eigenvalues)
    require(sp.expand(polynomial-t**28*(t-1)**2*(t-2)**2) == 0,
            "Wrong total homology polynomial")
    jstatus, jresult = load(BASE / "jacobian_status.json"), load(BASE / "jacobian_result.json")
    payload = load(BASE / "jacobian_payload.json")
    require(jstatus["adapter_exit_code"] == 0 and jstatus["status"] == "returned",
            "Jacobian did not return a conclusive typed result")
    require(jresult["server"]["version"] == "0.14.0"
            and jresult["protocol_version"] == "2025-11-25", "Unexpected Jacobian protocol/server")
    require(jresult["request"]["operation_id"] == "matrix.characteristic_polynomial.compute"
            and jresult["request"]["payload"] == payload, "Jacobian request binding failed")
    matrix = sp.Matrix([[sp.Rational(x["num"], x["den"]) for x in row]
                        for row in payload["matrix"]["entries"]])
    require(matrix == sp.diag(2,0,0,0), "Wrong derived H2 matrix")
    output = jresult["result"]["output"]
    coefficients = [sp.Rational(x["num"],x["den"]) for x in output["coefficients_descending"]]
    require(output["degree"] == 4 and output["convention"] == "DET_LAMBDA_I_MINUS_A"
            and coefficients == matrix.charpoly(t).all_coeffs() == [1,-2,0,0,0],
            "Jacobian characteristic polynomial does not replay")
    return {"universal_polynomial_identities": "passed",
            "closed_support_and_plateau_rational_checks": "passed",
            "homology_normal_form_q": q, "betti_vector": [betti[n] for n in range(10)],
            "H2_characteristic_polynomial": "lambda^3*(lambda-2)",
            "total_characteristic_polynomial": "lambda^28*(lambda-1)^2*(lambda-2)^2",
            "radius_set": [0,1,2], "conventional_spectral_radius": 2,
            "jacobian_operation": jstatus["operation_id"], "jacobian_typed_output": output,
            "topological_identification": "proved in report; requires independent reading"}


def campaign_checks():
    results = {}
    for module in ("math_state", "proof_graph_check"):
        command = [PYTHON, "-m", "argus_skill.verticals.math."+module, "check",
                   "--project-root", str(ROOT)]
        run = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=60)
        require(run.returncode == 0,
                f"{module} failed at {ROOT}:\n{run.stdout}\n{run.stderr}")
        results[module] = {"command": command, "exit_code": run.returncode,
                           "stdout": run.stdout, "stderr": run.stderr}
    return {"project_root": str(ROOT), "checks": results}


def main():
    require(Path.cwd().resolve() == ROOT, "Run this entry point from the campaign root")
    state = load(ROOT / "research/MATH_STATE.json")
    provenance = source_bindings()
    bridge = kernel_binding(state, "C_PAIR_BRIDGE", BASE / "Main.lean",
                            BASE / "statement_fidelity.md", False)
    passage = kernel_binding(state, "C_PASSAGE_CORE", ROOT / "research/passage_core/Main.lean",
                             ROOT / "research/passage_core/statement_fidelity.md", True)
    graph = load(ROOT / "research/PROOF_GRAPH.json")
    require(graph["nodes"]["C_PASSAGE_CORE"]["status"] == "proved"
            and graph["nodes"]["C_PASSAGE_CORE"]["reviewer_confirmed"] is True,
            "Graph ignores the existing independent passage judgement")
    pipeline = load(ROOT / ".argus/PIPELINE_STATE.json")
    require(pipeline["math_objective_mode"] == "exploratory"
            and pipeline["research_target_level"] == "publishable", "Campaign target changed")
    algebra = exact_algebra()
    validation = campaign_checks()
    source = ROOT / "research/openai_manuscript/A-C1-Counterexample-to-the-Entropy-Conjecture-September-25-2026/build/source"
    manuscript = {name: sha256(source / name) for name in
                  ("main.tex", "construction.tex", "orbits.tex", "entropy.tex", "homology.tex")}
    certificate = {
        "claim_id": "C_GLOBAL_STANDARD", "result_class": "complete_solution",
        "classification": "source-faithful global mathematical verification; not a new existential example",
        "research_target_level": "publishable", "math_objective_mode": "exploratory",
        "standard_conclusion": {"q":3, "manifold":"S1 x (S2)^4", "dimension":9,
                                "conventional_C1":True, "ordinary_entropy":0,
                                "second_real_singular_homology_eigenvalue":2,
                                "conventional_total_homology_spectral_radius":2,
                                "noninvertible":True},
        "proof": {"report":"research/global_verification/report.md",
                  "report_sha256":sha256(BASE / "report.md"),
                  "staged_source_sha256":manuscript,
                  "whole_report_kernel_checked":False,
                  "released_witness_is_admissible_staged_specialization":True,
                  "human_bridges_require_independent_review":True},
        "upstream":provenance, "new_lean_bridge":bridge, "reused_passage":passage,
        "exact_algebra":algebra, "campaign_validation":validation,
        "independent_review":{"required":True, "global_acceptance":"pending_host_invocation",
                              "publication_level_acceptance":"not_asserted"},
        "novelty_status":"not_yet_independently_assessed",
        "known_prior_existence_and_finite_regularity":True,
        "false_manuscript_assertions_identified":[],
    }
    (BASE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2)+"\n")
    action = {
        "ts":datetime.now(timezone.utc).isoformat(), "role":"engineer", "agent":"gpt-6.1-sol",
        "kind":"global_verification",
        "action":f"Bound the frozen released theorem and historical acceptance to exact sources; replayed exact algebra and current Lean 4.31.0 bridge evidence with no proof holes; reused the independently reviewed passage without recompilation. Both official checks exited zero at {ROOT}. Prose source-fidelity and publishable-level acceptance remain for the Host-invoked Reviewer.",
        "status":"global_result_ready_for_independent_review",
        "artifact":"research/global_verification/exact_certificate.json",
    }
    with (ROOT / "activity.jsonl").open("a") as stream:
        stream.write(json.dumps(action)+"\n")
    print(json.dumps({"exact_certificate":"research/global_verification/exact_certificate.json",
                      "checks":"passed", "whole_report_kernel_checked":False,
                      "independent_global_review":"required"}, indent=2))


if __name__ == "__main__":
    main()
