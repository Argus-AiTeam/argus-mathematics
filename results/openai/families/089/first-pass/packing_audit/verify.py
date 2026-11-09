#!/usr/bin/env python3
"""Replay the universal Lean proof and exact supporting arithmetic."""

from collections import deque
from datetime import datetime, timezone
from fractions import Fraction
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def run_module(module, arguments, output_name):
    command = [ARGUS, "-m", module, *arguments]
    completed = subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True, timeout=120
    )
    (HERE / output_name).write_text(completed.stdout, encoding="utf-8")
    require(
        completed.returncode == 0,
        f"{module} exited {completed.returncode}:\n"
        f"{completed.stdout}\n{completed.stderr}",
    )
    return completed.stdout, completed.returncode


def replay_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    envelope = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["exit_code"] == 0 and not status["timeout"], "Adapter failed.")
    require(
        envelope["request"]["payload"] == payload,
        "Jacobian output is bound to another input.",
    )
    operation = "graph.distance_matrix.compute"
    require(envelope["request"]["operation_id"] == operation, "Wrong operation.")
    require(envelope["result"]["operation_id"] == operation, "Wrong result type.")
    require(envelope["server"]["version"] == "0.14.0", "Unexpected server version.")
    require(envelope["protocol_version"] == "2025-11-25", "Unexpected protocol.")
    vertices = payload["graph"]["vertices"]
    edges = payload["graph"]["edges"]
    require(len(vertices) == len(set(vertices)) <= 64, "Invalid graph vertices.")
    adjacency = {v: set() for v in vertices}
    seen = set()
    for u, v in edges:
        require(u in adjacency and v in adjacency and u != v, "Invalid edge.")
        edge = tuple(sorted((u, v)))
        require(edge not in seen, "Duplicate edge.")
        seen.add(edge)
        adjacency[u].add(v)
        adjacency[v].add(u)
    for u, v in seen:
        a, b = sorted((int(u), int(v)))
        for x, y in seen:
            c, d = sorted((int(x), int(y)))
            require(not (a < c < b < d or c < a < d < b), "Crossing links.")
    output = envelope["result"]["output"]
    axis = sorted(vertices)
    require(output["vertices"] == axis, "Wrong matrix axis.")
    require(output["pair_coverage"] == "ALL_ORDERED_VERTEX_PAIRS", "Partial output.")
    require(output["vertex_ordering"] == "LEXICOGRAPHIC_ASCENDING", "Wrong order.")
    require(output["unreachable_representation"] == "JSON_NULL", "Wrong null type.")
    require(len(output["rows"]) == len(axis), "Incomplete matrix.")
    connected = True
    for source, row in zip(axis, output["rows"], strict=True):
        require(row["source"] == source, "A row is attached to the wrong source.")
        distances = {source: 0}
        queue = deque([source])
        while queue:
            u = queue.popleft()
            for v in sorted(adjacency[u]):
                if v not in distances:
                    distances[v] = distances[u] + 1
                    queue.append(v)
        expected = [distances.get(v) for v in axis]
        require(row["distances"] == expected, "Exact BFS replay disagrees.")
        connected = connected and len(distances) == len(axis)
    require(output["connected"] == connected, "Wrong connectivity flag.")
    return {
        "operation_id": operation,
        "vertices": len(vertices),
        "exact_bfs_replay": "passed",
        "scope": "Unweighted active-graph sanity check, not the localization proof.",
    }


def exact_arithmetic():
    one = Fraction(1)
    R = Fraction(1, 10**8)
    g = Fraction(1, 10**14)
    j = Fraction(1, 10**20)
    epsilon = Fraction(1, 10**24)
    E = epsilon / 1000
    amax = E / 10**6
    dmin = Fraction(1, 10**5)
    T = Fraction(2, 100)
    L = 4 * R
    b = g / 100
    rho = j + epsilon + 2 * amax
    delta = b - 2 * rho
    margins = {
        "low_profile": dmin / 2 - (2 * L + E + epsilon + amax),
        "partner_shortcut": one - (2 * L + amax + T),
        "ambient_barrier_radius": one - 2 * L,
        "chart_path_availability": 5 - (2 * L + T + amax),
        "assignment_spacing": delta,
        "spacing_above_b_over_2": delta - b / 2,
    }
    require(all(v > 0 for v in margins.values()), "A source parameter margin fails.")
    source_bound = 2 + (1600 * R / g).__ceil__()
    improved_bound = 2 + (2 * L / delta).__floor__()
    require(source_bound == 1600000002, "Wrong manuscript bound.")
    require(improved_bound == 800160050, "Wrong sharper bound.")
    require(2 * L / delta < 800160049, "The sharper integer step is invalid.")
    return {
        "parameters": {
            k: str(v)
            for k, v in {
                "R": R, "g": g, "j": j, "epsilon": epsilon, "E_A": E,
                "a1_max": amax, "dmin": dmin, "T": T, "L": L, "b": b,
            }.items()
        },
        "quantifier": "All real 0 < a1 <= a1_max; worst-case monotone margins below.",
        "rho_max": str(rho),
        "delta_min": str(delta),
        "margins_at_a1_max": {k: str(v) for k, v in margins.items()},
        "general_count": "card(F) <= 2 + 2*L/(b-2*(j+epsilon+2*a1))",
        "worst_case_real_ratio": str(2 * L / delta),
        "manuscript_integer_group_bound": source_bound,
        "sharper_integer_group_bound": improved_bound,
    }


def main():
    arithmetic = exact_arithmetic()
    jacobian = replay_jacobian()
    stdout, lean_exit = run_module(
        "argus_skill.verticals.math.lean_evidence",
        [
            "verify", str(HERE / "Main.lean"),
            "--statement-fidelity", str(HERE / "statement_fidelity.md"),
            "--project-root", str(ROOT), "--claim", "L89_CORE", "--timeout", "110",
        ],
        "lean_verify_output.json",
    )
    lean = json.loads(stdout)
    require(lean["status"] == "success", "The compiler did not succeed.")
    require(lean["exit_code"] == 0, "The compiler exit status is not zero.")
    require(lean["proof_holes"] == [], "The source contains proof holes.")
    require(lean["kernel"]["recorded"] is not None, "No mechanical evidence recorded.")
    require(lean["kernel"]["refusals"] == [], "Mechanical evidence was refused.")
    require("4.31.0" in json.dumps(lean), "Wrong Lean version.")
    record = lean["kernel"]["recorded"]
    artifact = ROOT / record["artifact"]
    require(artifact.is_file() and artifact.is_relative_to(HERE), "Wrong archive path.")
    certificate = json.loads(artifact.read_text())
    require(certificate["subject"]["subject_id"] == "L89_CORE", "Wrong certified claim.")
    checks = {}
    for label, module in [
        ("math_state", "argus_skill.verticals.math.math_state"),
        ("proof_graph", "argus_skill.verticals.math.proof_graph_check"),
    ]:
        _, checks[label] = run_module(
            module, ["check", "--project-root", str(ROOT)], f"{label}_check.txt"
        )
    result = {
        "result_class": "new_theorem",
        "interpretation": "Universal formal verification and structural generalization; not a finite experiment.",
        "claim_id": "L89_CORE",
        "project_root": str(ROOT),
        "formal_source": str((HERE / "Main.lean").relative_to(ROOT)),
        "statement_fidelity": str((HERE / "statement_fidelity.md").relative_to(ROOT)),
        "declarations": [
            "PackingAudit.distanceProfile",
            "PackingAudit.profile_localization",
            "PackingAudit.profile_localization_and_packing",
            "PackingAudit.manuscript_core_certified",
        ],
        "localization_radius": "j+epsilon+2*a1 in the actual bounded J1-path relation",
        "column_and_history_quantifier": "Arbitrary finite column models and finite seed families satisfying the explicit hypotheses; no column-count or history bound.",
        "disconnected_witness_partners": "Allowed; the old metric and bounded broad-band paths are distinct.",
        "arithmetic": arithmetic,
        "lean": {
            "producer_exit_code": lean_exit,
            "compiler_exit_code": lean["exit_code"],
            "proof_holes": lean["proof_holes"],
            "archive": record["artifact"],
            "source_sha256": lean["source_sha256"],
            "statement_fidelity_sha256": lean["statement_fidelity_sha256"],
        },
        "jacobian": jacobian,
        "campaign_local_check_exit_codes": checks,
        "upstream_geometric_inputs": [
            "geo:geodesics: actual quotient metrics and finite attained shortest words",
            "geo:padding: separation of seeds in distinct radially padded cells",
            "Source-to-model identification of the actual charts, bands, switches, and retained witnesses",
        ],
        "not_certified": [
            "Full planar or bounded-treewidth L1 embedding theorem",
            "Interpolation, main-update validity, secondary success, or chart persistence",
            "Optimality of the improved packing constant",
        ],
        "flawed_manuscript_assertions_identified": [],
        "novelty_status": "not_established",
        "significance_status": "pending_independent_review",
        "independent_review": "Pending Host-invoked Reviewer replay and statement-fidelity reading.",
    }
    (HERE / "exact_certificate.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="utf-8"
    )
    action = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "role": "engineer", "agent": "copilot", "kind": "certification",
        "action": "Certified the universal noncrossing localization-to-packing core and sharper sufficient group bound; independent review remains pending.",
        "status": "ready_for_review",
        "artifact": "research/packing_audit/exact_certificate.json",
    }
    with (ROOT / "activity.jsonl").open("a", encoding="utf-8") as stream:
        stream.write(json.dumps(action) + "\n")
    print(json.dumps({
        "status": "passed",
        "project_root": str(ROOT),
        "claim": "L89_CORE",
        "lean_exit_code": lean["exit_code"],
        "proof_holes": lean["proof_holes"],
        "campaign_local_checks": checks,
        "manuscript_group_bound": arithmetic["manuscript_integer_group_bound"],
        "sharper_group_bound": arithmetic["sharper_integer_group_bound"],
        "independent_review": "pending",
    }, indent=2))


if __name__ == "__main__":
    main()
