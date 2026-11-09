"""Check coverage, evidence consistency, and the unmodified official gates."""

from fractions import Fraction
import argparse
import json
from pathlib import Path
import re
import subprocess


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "validation.json"
PYTHON = "$WORKSPACE/argus-latest/.venv/bin/python"
issues = []


def read(path):
    return json.loads(Path(path).read_text())


def check(condition, message):
    if not condition:
        issues.append(message)


def evidence_path(value):
    path = Path(value)
    return path if path.is_absolute() else ROOT / path


def official_check(module):
    command = [
        PYTHON, "-m", "argus_skill.verticals.math." + module,
        "check", "--project-root", str(ROOT),
    ]
    result = subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True, timeout=30
    )
    return {
        "command": command,
        "exit_code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr,
    }


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument(
    "--coverage-only", action="store_true",
    help="Preserve prior official receipts after report/checker-only edits; not for ledger or graph edits.",
)
args = parser.parse_args()
if args.coverage_only:
    previous = read(OUTPUT)
    if previous["project_root"] != str(ROOT):
        raise ValueError("Cannot reuse checks from a different project root")
    gates = previous["official_checks"]
else:
    gates = {name: official_check(name) for name in ("math_state", "proof_graph_check")}
prior = read(ROOT / "PRIOR_DRAFTS.json")
index = read(ROOT / "research/DRAFT_REVIEW_INDEX.json")
old = Path(prior["old_workspace"])
old_state = read(old / "research/MATH_STATE.json")
state = read(ROOT / "research/MATH_STATE.json")
summary = (ROOT / "research/OLD_ROUND_REVIEW.md").read_text()
artifacts = {item["id"]: item for item in index["artifacts"]}
expected_paths = {item["path"]: item["bytes"] for item in prior["artifacts"]}
indexed_paths = {item["path"]: item["listed_bytes"] for item in artifacts.values()}
check(len(artifacts) == 26 and indexed_paths == expected_paths,
      "All 26 inventory entries must occur exactly once with their listed sizes")
check(len(index["artifacts"]) == len(artifacts), "Duplicate artifact IDs")
for item in artifacts.values():
    path = old / item["path"]
    check(path.is_file() and path.stat().st_size == item["listed_bytes"],
          "Missing or size-changed old artifact: " + item["path"])
    check(item["units"] or item["id"] in {"A02", "A10"},
          "Unjustified mathematical exclusion: " + item["id"])
check(index["coverage"]["historical_claim_versions"] == len(old_state["claims"]) == 11,
      "Historical version count mismatch")
check(index["coverage"]["independent_acceptance"] == "pending_native_Host_Reviewer",
      "Engineer must not claim independent acceptance")
check(index["research_target_level"] == "exploratory", "Research target changed")

expected_units = {
    "core": ("C55_CORE", []),
    "aisles": ("C55_AISLE", ["core"]),
    "refinement": ("C55_REFINEMENT", ["core", "aisles"]),
    "blocks": ("C55_BLOCKS", ["core", "refinement"]),
    "gepner": ("C55_GEPNER_VERIFY", ["core", "aisles", "refinement", "blocks"]),
}
check({unit["id"] for unit in index["units"]} == set(expected_units),
      "Missing or extra mathematical unit")
check(len(index["units"]) == 5, "Draft copies counted as mathematical units")
units_by_id = {unit["id"]: unit for unit in index["units"]}
for aid, artifact in artifacts.items():
    for name in artifact["units"]:
        unit = units_by_id[name]
        check(aid in unit["primary_artifacts"] + unit["supporting_artifacts"],
              "Artifact omitted from its assigned unit: " + aid + ": " + name)
markdown = [ROOT / "research/OLD_ROUND_REVIEW.md"]
current_claims = {claim["claim_id"] for claim in state["claims"]}
for unit in index["units"]:
    name = unit["id"]
    claim, dependencies = expected_units[name]
    verdict = read(ROOT / unit["verdict"])
    report_path = ROOT / unit["report"]
    report = report_path.read_text()
    markdown.append(report_path)
    check(unit["claim_id"] == verdict["claim_id"] == claim, name + ": wrong claim")
    check(claim in current_claims, name + ": missing current ledger claim")
    check(unit["assessment"] == verdict["assessment"], name + ": verdict mismatch")
    check(verdict["report"] == unit["report"], name + ": report link mismatch")
    check(unit["depends_on_units"] == verdict["depends_on_units"] == dependencies,
          name + ": dependency mismatch")
    versions = sorted(c["version"] for c in old_state["claims"] if c["claim_id"] == claim)
    check(unit["historical_versions"] == verdict["historical_versions"] == versions,
          name + ": incomplete historical versions")
    for field in ("exact_claim", "hypotheses", "source_version", "attribution",
                  "decisive_argument", "supported_scope", "limitations", "evidence"):
        check(bool(verdict.get(field)), name + ": missing substantive field " + field)
    check(verdict["native_independent_review"] == "required_pending"
          and verdict["accepted_by_engineer"] is False,
          name + ": improper acceptance")
    check(verdict["research_target_level"] == "exploratory", name + ": changed target")
    check(verdict["assessment"] in report and claim in report,
          name + ": report and machine verdict disagree")
    row = next((line for line in summary.splitlines()
                if line.startswith("| [" + name + " /")), "")
    check(claim in row and verdict["assessment"] in row,
          name + ": summary and verdict disagree")
    for value in verdict["evidence"]:
        check(evidence_path(value).exists(), name + ": missing evidence " + value)
    for aid in unit["primary_artifacts"] + unit["supporting_artifacts"]:
        check(aid in artifacts and name in artifacts[aid]["units"],
              name + ": invalid artifact mapping " + aid)

historical_evidence = {record["evidence_id"]: record for record in old_state["evidence"]}
check(len(index["historical_evidence_records"]) == len(historical_evidence) == 15,
      "Incomplete historical evidence accounting")
check({entry["id"] for entry in index["historical_evidence_records"]}
      == set(historical_evidence), "Duplicate or omitted historical evidence")
for entry in index["historical_evidence_records"]:
    record = historical_evidence[entry["id"]]
    check(entry["tier"] == record["tier"] and entry["verdict"] == record["verdict"]
          and entry["producer"] == record["produced_by"]
          and artifacts[entry["artifact"]]["path"] == record["artifact"],
          "Misattributed historical evidence: " + entry["id"])
for record in state["evidence"]:
    check(record["tier"] == "judgement", "Unjustified current mechanical promotion")
    check(evidence_path(record["artifact"]).is_file(), "Missing ledger evidence")
check("C55_CORE_V1_FAILURE" in current_claims, "Historical scalar failure not recorded")
retired = next(r for r in state["routes"] if r["route_id"] == "R55_NUMERICAL_ONLY")
check(bool(retired["retired_because"]), "Numerical-only route reopened")

history = read(HERE / "core/historical_versions.json")
v = {key: Fraction(value) for key, value in history["version_1_countermodel"]["values"].items()}
a, n0, n1, n2, n3, x, t = (v[k] for k in ("a", "n0", "n1", "n2", "n3", "X", "T"))
check(all((a >= Fraction(7, 20), n1 >= 0, n2 >= 0, x >= 0,
           x / 8000 <= n1, t <= 16*x + 24*(n1+n2),
           -t/500000 <= n0, -t/500000 <= n3,
           n0 + a*n1 + a*n2 + n3 == 0)) and n1 != 0,
      "Historical scalar assignment is not a counterexample")
check(n0+n3 < -t/500000, "Countermodel incorrectly attributed to current hends")
core_text = next(c["formal_statement"] for c in old_state["claims"]
                 if c["claim_id"] == "C55_CORE" and c["version"] == 3)
declarations = re.findall(r"^theorem\s+(\w+)", core_text, re.MULTILINE)
core_report = (HERE / "core/report.md").read_text()
check(len(declarations) == 19 and all(name in core_report for name in declarations),
      "Current formal declaration coverage incomplete")

payload = read(HERE / "core/jacobian_payload.json")
adapter = read(HERE / "core/jacobian_status.json")
response = read(HERE / "core/jacobian_output.json")
lp = response["result"]["output"]
q = lambda value: Fraction(int(value["num"]), int(value["den"]))
point = list(map(q, lp["primal_candidate"]))
dual = list(map(q, lp["constraint_dual"]))
rows = payload["program"]["constraints"]
matrix = [list(map(q, row["coefficients"])) for row in rows]
rhs = [q(row["rhs"]) for row in rows]
check(lp["program"] == payload["program"] and lp["status"] == "OPTIMAL",
      "Jacobian output not bound to the reviewed LP")
check(point == [Fraction(13, 46), Fraction(13, 23)]
      and all(sum(c*z for c, z in zip(row, point)) <= b
              for row, b in zip(matrix, rhs))
      and all(z >= 0 for z in point + dual)
      and [sum(dual[i]*matrix[i][j] for i in range(2)) for j in range(2)] == [1, 0]
      and sum(y*b for y, b in zip(dual, rhs)) == point[0] == Fraction(13, 46),
      "Exact threshold primal-dual verification failed")
check(point[0] <= Fraction(3, 10)
      and Fraction(1, 2) <= point[1] <= Fraction(8, 13),
      "Reduced LP optimum does not satisfy the archived finite bounds")
check(adapter["adapter_exit_code"] == 0 and not adapter["timed_out"],
      "Jacobian error/timeout must not be treated as support")

replay = read(HERE / "core/lean_replay.json")
check(replay["compiler"]["exit_code"] == replay["axiom_audit"]["exit_code"] == 0
      and replay["source_unchanged_during_replay"]
      and replay["fidelity_unchanged_during_replay"]
      and replay["source_matches_successful_historical_certificate"]
      and replay["fidelity_matches_successful_historical_certificate"],
      "Fresh read-only compiler replay does not support its reported scope")
check(read(HERE / "core/exact_replay.json")["final_exit_code"] == 0,
      "Exact comparison did not pass")
check(read(HERE / "sources/reference_versions.json")["all_match"],
      "Reference version mismatch")
for source in read(HERE / "sources/sources.json")["sources"]:
    check(source["status"] == "retrieved" and source["discrepancy"] is None
          and (HERE / "sources" / source["local_excerpt"]).is_file(),
          "Missing primary-source passage or unresolved discrepancy")
for path in markdown:
    prose = re.sub(r"```[\s\S]*?```|`[^`]*`", "", path.read_text())
    for link in re.findall(r"\[[^\]]+\]\(([^)]+)\)", prose):
        if "://" not in link:
            target = (path.parent / link.split("#", 1)[0]).resolve()
            check(target == OUTPUT or target.exists(),
                  "Unresolvable report link: " + str(path) + ": " + link)

result = {
    "project_root": str(ROOT),
    "coverage_exit_code": 0 if not issues else 1,
    "coverage_issues": issues,
    "artifacts_accounted": len(artifacts),
    "units_assessed": len(index["units"]),
    "historical_claim_versions": len(old_state["claims"]),
    "historical_evidence_records": len(historical_evidence),
    "official_checks": gates,
    "official_checks_reused": args.coverage_only,
    "gate_passed": not issues and all(g["exit_code"] == 0 for g in gates.values()),
    "independent_acceptance": "not_asserted",
}
OUTPUT.write_text(json.dumps(result, indent=2) + "\n")
print(json.dumps(result, ensure_ascii=True, indent=2))
raise SystemExit(0 if result["gate_passed"] else 2)
