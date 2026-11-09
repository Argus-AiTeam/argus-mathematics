#!/usr/bin/env python3
"""Bind the requested old-draft inventory, or check its unchanged inputs."""

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
INDEX = ROOT / "research/DRAFT_REVIEW_INDEX.json"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def measure(index, prior):
    old = Path(prior["old_workspace"])
    snapshot = json.loads(Path(prior["preserved_snapshot_manifest"]).read_text())
    prefix = old.name + "/"
    preserved = {
        row["path"][len(prefix):]: row
        for row in snapshot["files"]
        if row["path"].startswith(prefix)
    }
    listed = [row["path"] for row in prior["artifacts"]]
    grouped = [path for group in index["artifact_groups"] for path in group["paths"]]
    require(Counter(listed) == Counter(grouped), "Missing, duplicate, or extra artifact mapping")
    require(all(count == 1 for count in Counter(grouped).values()), "Repeated artifact")
    require(len(listed) == index["listed_artifact_count"], "Incorrect artifact count")
    bindings = []
    for row in prior["artifacts"]:
        path = old / row["path"]
        size = path.stat().st_size
        sha = digest(path)
        require(size == row["bytes"], f"Listed byte count changed: {path}")
        archived = preserved.get(row["path"])
        if archived is not None:
            require(sha == archived["sha256"], f"Snapshot mismatch: {path}")
            require(size == archived["bytes"], f"Snapshot byte count mismatch: {path}")
        bindings.append({
            "path": row["path"],
            "bytes": size,
            "sha256": sha,
            "snapshot": "matched" if archived is not None else "not_in_partial_snapshot",
        })
    require(set(preserved) <= set(listed), "Unmapped family snapshot artifact")

    state = json.loads((old / "research/MATH_STATE.json").read_text())
    claims = {(row["claim_id"], row["version"]): row for row in state["claims"]}
    require(
        set(claims) == {(row["id"], row["version"]) for row in index["claim_versions"]},
        "Missing or extra claim version",
    )
    assessments = {
        (claim_id, version)
        for claim_id, row in index["claim_assessment_map"].items()
        for version in row["versions"]
    }
    require(assessments == set(claims), "Unassessed claim version")
    modules = index["upstream_source_disposition"]
    module_names = modules["incorporated_modules"] + modules["reference_only_modules"]
    upstream = [
        Path(path).name.removesuffix(".lean.txt") for path in listed
        if "/upstream/OAI/NumberTheory/ShortEgyptian/" in path
    ]
    require(Counter(module_names) == Counter(upstream), "Unclassified upstream module")
    require(len(upstream) == modules["total_modules"], "Incorrect upstream module count")
    evidence = []
    for row in state["evidence"]:
        record = {key: row[key] for key in
                  ("evidence_id", "subject", "tier", "verdict", "produced_by", "artifact")}
        record["artifact_sha256"] = digest(old / row["artifact"])
        evidence.append(record)

    versions = []
    for mapping in index["claim_versions"]:
        claim = claims[(mapping["id"], mapping["version"])]
        formal = claim["formal_statement"]
        require(isinstance(formal, str), "Unexpected formal-statement representation")
        versions.append({
            "id": claim["claim_id"],
            "version": claim["version"],
            "content_hash": claim["content_hash"],
            "context": claim["context"],
            "statement": claim["natural_statement"],
            "formal_utf8_sha256": hashlib.sha256(formal.encode()).hexdigest() if formal else None,
            "assumptions": claim["external_assumptions"],
            "historical_evidence_ids": [
                row["evidence_id"] for row in evidence
                if row["subject"]["kind"] == "claim"
                and row["subject"]["subject_id"] == claim["claim_id"]
                and row["subject"]["content_hash"] == claim["content_hash"]
            ],
        })

    archives = []
    for folder, name, claim_id in (
        ("divisor_moment", "C_DIVISOR_MOMENT_REAL-fc7c571de81c7bb9.json",
         "C_DIVISOR_MOMENT_REAL"),
        ("growing_divisor_moments", "C_GROWING_DIVISOR_UPPER-7711f0443152c62e.json",
         "C_GROWING_DIVISOR_UPPER"),
    ):
        base = old / "research" / folder
        certificate = base / "certificates" / name
        archive = json.loads(certificate.read_text())
        record = archive["lean_check"]
        source = base / "Main.lean"
        fidelity = base / "statement_fidelity.md"
        source_sha, fidelity_sha = digest(source), digest(fidelity)
        for key, path in (
            ("lean_source", source),
            ("statement_fidelity", fidelity),
        ):
            require(archive[key]["text"] == path.read_text(), f"Archived text mismatch: {path}")
            require(archive[key]["path"] == str(path.relative_to(old)),
                    f"Archived path mismatch: {path}")
        require(record["source_sha256"] == source_sha, f"Compiler source mismatch: {source}")
        require(record["statement_fidelity_sha256"] == fidelity_sha,
                f"Compiler fidelity mismatch: {fidelity}")
        require(archive["subject"]["content_hash"] == claims[(claim_id, 2)]["content_hash"],
                f"Certificate claim mismatch: {claim_id}")
        require(claims[(claim_id, 2)]["formal_statement"] == source.read_text(),
                f"Ledger formal-source mismatch: {claim_id}")
        require(record["status"] == "success" and record["exit_code"] == 0,
                f"Historical compiler did not succeed: {claim_id}")
        require(record["audit_exit_code"] == 0 and record["proof_holes"] == [],
                f"Historical proof-hole audit failed: {claim_id}")
        archives.append({
            "claim": claim_id,
            "version": 2,
            "certificate": str(certificate.relative_to(old)),
            "certificate_sha256": digest(certificate),
            "source_sha256": source_sha,
            "statement_fidelity_sha256": fidelity_sha,
            "compiler_version": record["tools"]["lean"]["version"],
            "mathlib_workspace": record["lake_workspace"],
            "historical_exit_code": record["exit_code"],
            "historical_audit_exit_code": record["audit_exit_code"],
            "historical_axiom_report": record["stdout"],
            "reuse": "Exact archived reviewed bytes; no fresh compiler execution claimed",
        })

    manuscript = json.loads(Path(prior["manuscript_reference_manifest"]).read_text())
    manuscripts = []
    for paper in manuscript["manuscripts"]:
        copy = old / "research/openai_manuscript" / paper["manuscript_id"]
        for row in paper["tex_sources"]:
            local = copy / row["path"]
            upstream = Path(paper["source_directory"]) / row["path"]
            require(digest(local) == row["sha256"], f"Manuscript copy mismatch: {local}")
            require(digest(upstream) == row["sha256"], f"Manifest source mismatch: {upstream}")
            manuscripts.append({
                "manuscript_id": paper["manuscript_id"],
                "path": row["path"],
                "sha256": row["sha256"],
                "old_copy_and_manifest_source_match": True,
            })
    return {
        "artifact_bindings": bindings,
        "historical_claim_bindings": versions,
        "historical_evidence_bindings": evidence,
        "historical_route_bindings": state["routes"],
        "formal_archive_bindings": archives,
        "manuscript_bindings": manuscripts,
        "snapshot_coverage": {
            "matched": len(preserved),
            "not_in_partial_snapshot": len(listed) - len(preserved),
            "mismatches": 0,
            "interpretation": "Absence from the partial snapshot is not a changed source",
        },
        "manifest_bindings": {
            "OBJECTIVE.md": digest(ROOT / "OBJECTIVE.md"),
            "PRIOR_DRAFTS.json": digest(ROOT / "PRIOR_DRAFTS.json"),
            prior["preserved_snapshot_manifest"]: digest(Path(prior["preserved_snapshot_manifest"])),
            prior["manuscript_reference_manifest"]: digest(Path(prior["manuscript_reference_manifest"])),
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bind", action="store_true")
    args = parser.parse_args()
    index = json.loads(INDEX.read_text())
    prior = json.loads((ROOT / "PRIOR_DRAFTS.json").read_text())
    measured = measure(index, prior)
    if args.bind:
        index.update(measured)
        INDEX.write_text(json.dumps(index, indent=2, ensure_ascii=True) + "\n")
    else:
        for key, value in measured.items():
            require(index.get(key) == value, f"Binding changed or missing: {key}")
        for unit in index["units"]:
            report = ROOT / unit["report"]
            verdict = ROOT / unit["verdict"]
            require(report.is_file() and report.stat().st_size > 1000, f"Missing assessment: {unit['id']}")
            require(verdict.is_file(), f"Missing verdict: {unit['id']}")
            assessment = json.loads(verdict.read_text())
            require(assessment["unit"] == unit["id"], f"Wrong verdict unit: {unit['id']}")
            require(assessment["verdict"] == unit["engineer_verdict"],
                    f"Index/verdict disagreement: {unit['id']}")
            require(assessment["native_independent_reviewer_acceptance_performed"] is False,
                    "Engineer cannot perform native independent acceptance")
        require((ROOT / "research/OLD_ROUND_REVIEW.md").is_file(), "Missing family summary")
    print(json.dumps({
        "ok": True,
        "mode": "bind" if args.bind else "check",
        "project_root": str(ROOT),
        "artifacts": len(measured["artifact_bindings"]),
        "claim_versions": len(measured["historical_claim_bindings"]),
        "historical_evidence_records": len(measured["historical_evidence_bindings"]),
        "formal_archives": len(measured["formal_archive_bindings"]),
        "manuscript_sources": len(measured["manuscript_bindings"]),
        "snapshot": measured["snapshot_coverage"],
    }, ensure_ascii=True))


if __name__ == "__main__":
    main()
