"""Check coverage, recorded source versions, and exact evidence without old writes."""

import hashlib
import json
import os
import runpy
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    prior = read_json(ROOT / "PRIOR_DRAFTS.json")
    index = read_json(ROOT / "research/DRAFT_REVIEW_INDEX.json")
    old = Path(prior["old_workspace"])
    listed = {item["path"]: item["bytes"] for item in prior["artifacts"]}
    indexed = {item["path"]: item for item in index["artifacts"]}
    require(len(listed) == len(prior["artifacts"]) == 40, "Duplicate or missing input")
    require(len(indexed) == len(index["artifacts"]) == 40, "Duplicate index entry")
    require(listed.keys() == indexed.keys(), "Coverage differs from PRIOR_DRAFTS.json")
    files = []
    for relative, size in listed.items():
        path = old / relative
        require(path.is_file(), "Missing listed artifact: " + str(path))
        require(path.stat().st_size == size, "Listed size changed: " + relative)
        require(indexed[relative]["listed_bytes"] == size, "Index size changed")
        files.append({"path": relative, "bytes": size, "present": True})

    snapshot = read_json(Path(prior["preserved_snapshot_manifest"]))
    snapshot_files = [
        entry for entry in snapshot["files"] if entry["path"].startswith("9000038/")
    ]
    require(len(snapshot_files) == 11, "Unexpected preserved campaign subset")
    preserved = []
    for entry in snapshot_files:
        relative = entry["path"].removeprefix("9000038/")
        data = (old / relative).read_bytes()
        agrees = hashlib.sha256(data).hexdigest() == entry["sha256"]
        preserved.append({
            "manifest_path": entry["path"],
            "workspace_path": relative,
            "manifest_sha256": entry["sha256"],
            "bytes_match_manifest": len(data) == entry["bytes"],
            "sha256_matches_manifest": agrees,
        })
        require(agrees and len(data) == entry["bytes"], "Snapshot drift: " + relative)

    manuscript_manifest = read_json(Path(prior["manuscript_reference_manifest"]))
    require(len(manuscript_manifest["manuscripts"]) == 1, "Unexpected manuscript count")
    manuscript = manuscript_manifest["manuscripts"][0]
    reference_root = old / "research/openai_manuscript"
    source_root = reference_root / manuscript["manuscript_id"]
    require(
        source_root.resolve() == Path(manuscript["source_directory"]).resolve(),
        "Reference link does not resolve to the assigned manuscript source",
    )
    reference_files = []
    for directory, dirs, names in os.walk(reference_root, followlinks=True):
        dirs[:] = sorted(d for d in dirs if d not in {".git", "__pycache__"})
        for name in sorted(names):
            if name == ".git" or name.endswith(".pyc"):
                continue
            path = Path(directory) / name
            reference_files.append({
                "path": path.relative_to(reference_root).as_posix(),
                "bytes": path.stat().st_size,
            })
    expected_references = {item["path"]: item["bytes"] for item in index["reference_inputs"]}
    require(
        {item["path"]: item["bytes"] for item in reference_files} == expected_references,
        "Reference tree coverage or sizes differ",
    )
    source_bindings = []
    for entry in manuscript["tex_sources"]:
        agrees = hashlib.sha256((source_root / entry["path"]).read_bytes()).hexdigest() == entry["sha256"]
        source_bindings.append({
            "path": entry["path"],
            "manifest_sha256": entry["sha256"],
            "sha256_matches_manifest": agrees,
        })
        require(agrees, "Reference source drift: " + entry["path"])

    state = read_json(old / "research/MATH_STATE.json")
    mapping = {
        (item["claim"], version)
        for item in index["claim_version_mapping"]
        for version in item["versions"]
    }
    actual = {(item["claim_id"], item["version"]) for item in state["claims"]}
    require(mapping == actual, "A historical claim version is unaccounted for")
    claims = [{
        "claim_id": item["claim_id"],
        "version": item["version"],
        "context": item["context"],
        "natural_statement": item["natural_statement"],
        "content_hash": item["content_hash"],
        "has_formal_statement": bool(item["formal_statement"]),
        "external_assumptions": item["external_assumptions"],
        "retired_assumptions": item["retired_assumptions"],
    } for item in state["claims"]]
    hashes = {item["content_hash"]: (item["claim_id"], item["version"]) for item in state["claims"]}
    old_proof = old / "research/fujita_point_center"
    source = (old_proof / "Main.lean").read_bytes()
    fidelity = (old_proof / "statement_fidelity.md").read_bytes()
    certificates = []
    for path in sorted((old_proof / "certificates").glob("*.json")):
        certificate = read_json(path)
        check = certificate["lean_check"]
        bound = hashes[certificate["subject"]["content_hash"]]
        certificates.append({
            "path": path.relative_to(old).as_posix(),
            "claim_id": bound[0],
            "claim_version": bound[1],
            "subject": certificate["subject"],
            "tier": certificate["tier"],
            "verdict": certificate["verdict"],
            "status": check["status"],
            "exit_code": check["exit_code"],
            "proof_holes": check["proof_holes"],
            "audit_exit_code": check["audit_exit_code"],
            "source_sha256": check["source_sha256"],
            "statement_fidelity_sha256": check["statement_fidelity_sha256"],
            "source_matches_final": certificate["lean_source"]["text"].encode() == source,
            "fidelity_matches_final": certificate["statement_fidelity"]["text"].encode() == fidelity,
            "stdout": check["stdout"],
            "tools": check["tools"],
        })

    helpers = runpy.run_path(str(old_proof / "verify.py"))
    payload = read_json(HERE / "quantitative-strengthening/jacobian_payload.json")
    output = read_json(HERE / "quantitative-strengthening/jacobian_output.json")
    status = read_json(HERE / "quantitative-strengthening/jacobian_status.json")
    operation = "polynomial.multivariate.factor.compute"
    require(status["adapter_exit_code"] == 0, "Fresh adapter failed")
    require((HERE / "quantitative-strengthening/jacobian_stderr.txt").read_text() == "", "Fresh adapter diagnostics")
    require(output["request"]["operation_id"] == output["result"]["operation_id"] == operation, "Wrong operation")
    require(output["request"]["payload"] == payload, "Fresh request/payload mismatch")
    result = output["result"]["output"]
    require(result["status"] == "FACTORIZED" and result["product_reconstruction"] == "EXACT", "Non-conclusive factorization")
    product = helpers["constant"](helpers["rational"](result["coefficient"]))
    for factor in result["factors"]:
        require(type(factor["multiplicity"]) is int and 1 <= factor["multiplicity"] <= 64, "Invalid multiplicity")
        for _ in range(factor["multiplicity"]):
            product = helpers["multiply"](product, helpers["polynomial"](factor["factor"]))
    require(product == helpers["polynomial"](payload["polynomial"]), "Fresh product reconstruction failed")
    require(product == helpers["polynomial"](result["reconstructed"]), "Fresh retained polynomial differs")

    evidence = state["evidence"]
    for item in evidence:
        artifact = item["artifact"]
        if artifact:
            require((old / artifact).is_file(), "Historical evidence missing: " + artifact)
    receipt = read_json(old / "roles/reviewer/progress.json")
    result = {
        "project_root": str(ROOT),
        "interpreter": sys.executable,
        "python_version": sys.version,
        "listed_artifacts": files,
        "snapshot_manifest_agreement": preserved,
        "snapshot_scope": "Hash agreement with the existing manifest, not a new archive integrity audit; archive not unpacked",
        "manuscript_attribution": "OpenAI, September 23, 2026, as printed in the archived README and main.tex",
        "manuscript_revision": manuscript["source_revision"],
        "reference_link": {
            "root_is_symlink": reference_root.is_symlink(),
            "nested_source_is_symlink": source_root.is_symlink(),
            "resolved_source": str(source_root.resolve()),
        },
        "reference_files": reference_files,
        "manuscript_source_bindings": source_bindings,
        "old_contexts": state["contexts"],
        "old_claim_versions": claims,
        "old_evidence": evidence,
        "old_routes": state["routes"],
        "old_reviewer_receipt": receipt,
        "old_certificates": certificates,
        "fresh_jacobian": {
            "operation_id": operation,
            "server": output["server"],
            "protocol_version": output["protocol_version"],
            "transport": output["transport"],
            "adapter_exit_code": status["adapter_exit_code"],
            "typed_status": output["result"]["output"]["status"],
            "runtime_ms": output["result"]["runtime_ms"],
            "independent_product_reconstruction": "EXACT",
            "structured_error": None,
            "scope": "Existing polynomial identity only; no geometric or irreducibility conclusion",
        },
    }
    destination = HERE / "input_bindings.json"
    destination.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "status": "input_checks_passed",
        "artifacts": len(files),
        "snapshot_entries": len(preserved),
        "reference_files": len(reference_files),
        "manuscript_sources": len(source_bindings),
        "claim_versions": len(claims),
        "historical_evidence_rows": len(evidence),
        "fresh_factor_reconstruction": "EXACT",
        "output": str(destination.relative_to(ROOT)),
    }, sort_keys=True))


if __name__ == "__main__":
    main()
