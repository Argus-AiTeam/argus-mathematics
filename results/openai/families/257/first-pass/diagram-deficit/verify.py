#!/usr/bin/env python3
"""Reconstruct exact premises and certify the universal Lean fragment theorem."""

import argparse
import itertools
import json
import subprocess
import sys
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "A-hyperbolic-group-with-no-geometric-CAT0-action-September-25-2026"
    / "build/sections"
)
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def reconstruct_template():
    points = tuple(range(1, 8))
    lines = sorted({tuple(sorted((i, j, i ^ j))) for i, j in itertools.combinations(points, 2)})
    assert len(lines) == 7
    quad = (1, 2, 4, 7)
    exceptional_line = tuple(sorted((4, 7, 4 ^ 7)))
    edges = []
    fans = {}
    for point in points:
        representatives = [(point, "X")]
        if point in quad:
            representatives.append((point, "Y"))
        fan_edges = []
        for representative in representatives:
            for line in lines:
                if point not in line or (representative == (7, "Y") and line == exceptional_line):
                    continue
                edge = (representative, line)
                edges.append(edge)
                if representative == (7, "X") and line == exceptional_line:
                    continue
                fan_edges.append(edge)
        vertices = sorted({u for u, _ in fan_edges}) + sorted({v for _, v in fan_edges})
        vertex_id = {vertex: index for index, vertex in enumerate(vertices)}
        ports = {vertex_id[v] for v in vertices if v in lines}
        special = vertex_id[(7, "X")] if point == 7 else None
        if special is not None:
            ports.add(special)
        fans[point] = {
            "vertices": tuple(range(len(vertices))),
            "edges": {frozenset((vertex_id[u], vertex_id[v])) for u, v in fan_edges},
            "ports": ports,
            "special": special,
        }
    all_vertices = {v for edge in edges for v in edge}
    assert len(all_vertices) == 18 and len(edges) == 32
    assert sorted(len(fan["edges"]) for fan in fans.values()) == [3, 3, 3, 4, 6, 6, 6]
    return fans


def local_links(fan):
    vertices = fan["vertices"]
    for size in range(2, len(vertices) + 1):
        for cycle in itertools.permutations(vertices, size):
            if cycle[0] != min(cycle) or (size > 2 and cycle[1] > cycle[-1]):
                continue
            choices = []
            for index, left in enumerate(cycle):
                right = cycle[(index + 1) % size]
                kinds = []
                if frozenset((left, right)) in fan["edges"]:
                    kinds.append("F")
                if left in fan["ports"] and right in fan["ports"]:
                    kinds.extend(("D", "O"))
                choices.append(kinds)
            for steps in itertools.product(*choices):
                if steps == ("F", "F"):
                    continue
                if any(steps[i] == steps[(i + 1) % size] == "D" for i in range(size)):
                    continue
                yield cycle, steps


def locator(filename, label):
    lines = (SOURCE / filename).read_text().splitlines()
    matches = [number for number, line in enumerate(lines, 1) if "\\label{" + label + "}" in line]
    assert len(matches) == 1, (filename, label, matches)
    return {"file": str((SOURCE / filename).relative_to(ROOT)), "label": label, "line": matches[0]}


def check_links():
    summaries = []
    for point, fan in reconstruct_template().items():
        count = masks = 0
        max_triangles = max_dominant = 0
        minimum_slack = {"ordinary": None, "dominant": None, "transitions": None}
        sharp = {}
        for cycle, steps in local_links(fan):
            count += 1
            size = len(cycle)
            assert len(set(cycle)) == size <= 5
            max_triangles = max(max_triangles, steps.count("F"))
            max_dominant = max(max_dominant, steps.count("D"))
            for mask in range(1, 1 << size):
                masks += 1
                selected = [bool(mask & (1 << i)) for i in range(size)]
                partial = int(mask != (1 << size) - 1)
                q = sum(selected[i] and steps[i] == "F" for i in range(size))
                x = sum(selected[i] and steps[i] == "D" for i in range(size))
                y = sum(selected[i] and steps[i] == "O" for i in range(size))
                d = x + y
                payment = sum(
                    selected[i]
                    and steps[i] != "F"
                    and fan["special"] in (cycle[i], cycle[(i + 1) % size])
                    for i in range(size)
                )
                transitions = sum(selected[i] != selected[(i + 1) % size] for i in range(size))
                slacks = {
                    "ordinary": q + payment + 3 * partial - (4 - 2 * d),
                    "dominant": q + payment + 3 * partial - 2 * (x - y),
                    "transitions": transitions - 2 * partial,
                }
                assert q <= 4 and x <= 1 and q + d >= 1
                for edge in fan["edges"]:
                    use = sum(
                        selected[i]
                        and steps[i] == "F"
                        and frozenset((cycle[i], cycle[(i + 1) % size])) == edge
                        for i in range(size)
                    )
                    assert use <= 1, (point, cycle, steps, mask, edge)
                for name, slack in slacks.items():
                    assert slack >= 0, (point, cycle, steps, mask, name, slack)
                    if minimum_slack[name] is None or slack < minimum_slack[name]:
                        minimum_slack[name] = slack
                        sharp[name] = {
                            "cycle": list(cycle),
                            "steps": list(steps),
                            "mask": mask,
                            "q": q,
                            "dominant": x,
                            "other": y,
                            "loose_payments": payment,
                            "partial": partial,
                            "transitions": transitions,
                        }
        assert count and masks and max_triangles <= 4 and max_dominant <= 1
        summaries.append(
            {
                "point": point,
                "radial_labels": len(fan["vertices"]),
                "fan_edges": len(fan["edges"]),
                "ports": sorted(fan["ports"]),
                "exceptional_port": fan["special"],
                "colored_links_up_to_dihedral_vertex_order": count,
                "nonempty_selected_subsets": masks,
                "max_fan_triangles": max_triangles,
                "max_dominant_turns": max_dominant,
                "minimum_doubled_slacks": minimum_slack,
                "sharp_examples": sharp,
            }
        )
    return summaries


def check_macro_cycles():
    points = tuple(range(1, 8))
    lines = sorted({tuple(sorted((i, j, i ^ j))) for i, j in itertools.combinations(points, 2)})
    subdivision = "subdivision"
    vertices = list(points) + lines + [subdivision]
    ids = {v: i for i, v in enumerate(vertices)}
    adjacency = [set() for _ in vertices]
    exceptional_line = tuple(sorted((4, 7, 4 ^ 7)))
    for point in points:
        for line in lines:
            if point not in line:
                continue
            path = [point, line]
            if point == 7 and line == exceptional_line:
                path = [point, subdivision, line]
            for u, v in zip(path, path[1:]):
                adjacency[ids[u]].add(ids[v])
                adjacency[ids[v]].add(ids[u])
    assert len(vertices) == 15 and sum(map(len, adjacency)) == 44
    counts = Counter()
    point_counts = Counter()

    def extend(path):
        for v in sorted(adjacency[path[-1]]):
            if v == path[0] and len(path) >= 3 and path[1] < path[-1]:
                point_count = sum(vertex < 7 for vertex in path)
                assert 3 <= point_count <= 7
                assert len(path) <= 15
                counts[len(path)] += 1
                point_counts[point_count] += 1
            elif v > path[0] and v not in path:
                extend(path + [v])

    for start in range(len(vertices)):
        extend([start])
    assert counts and min(point_counts) == 3
    return {
        "vertices": len(vertices),
        "edges": sum(map(len, adjacency)) // 2,
        "simple_cycles_up_to_rotation_and_reversal": sum(counts.values()),
        "cycle_counts_by_perimeter": {str(k): v for k, v in sorted(counts.items())},
        "minimum_point_turns": min(point_counts),
        "maximum_perimeter": max(counts),
    }


def replay_jacobian():
    payload = json.loads((HERE / "jacobian/fan_cycle_payload.json").read_text())
    response = json.loads((HERE / "jacobian/fan_cycle_output.json").read_text())
    operation = "graph.multigraph.cycle_multicover.check"
    assert response["request"]["operation_id"] == operation
    assert response["request"]["payload"] == payload
    assert response["result"]["operation_id"] == operation
    assert response["server"]["version"] == "0.14.0"
    assert response["protocol_version"] == "2025-11-25"
    graph = payload["graph"]
    edges = {edge["edge_id"]: frozenset((edge["left"], edge["right"])) for edge in graph["edges"]}
    assert len(edges) == len(graph["edges"])
    assert set(edges.values()) == reconstruct_template()[1]["edges"]
    coverage = Counter()
    for cycle in payload["cycles"]:
        vertices, edge_ids = cycle["vertices"], cycle["edge_ids"]
        assert vertices[0] == vertices[-1]
        assert len(set(vertices[:-1])) == len(vertices) - 1
        assert len(set(edge_ids)) == len(edge_ids) == len(vertices) - 1
        for index, edge in enumerate(edge_ids):
            assert edges[edge] == frozenset((vertices[index], vertices[index + 1]))
            coverage[edge] += 1
    assert all(coverage[edge] == payload["target_multiplicity"] for edge in edges)
    output = response["result"]["output"]
    assert output["cycle_validity"] == [True] * len(payload["cycles"])
    assert output["is_exact_k_cover"] is True
    assert dict(output["edge_multiplicity"]) == dict(coverage)
    assert output["missing_edge_ids"] == output["overcovered_edge_ids"] == []
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_error_or_timeout": None,
        "typed_output_independently_replayed": True,
        "scope": "K2,3 incidence cross-check only, not a fragment proof",
    }


def certify_formal():
    command = [
        ARGUS_PYTHON,
        "-m",
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        str(HERE / "Main.lean"),
        "--statement-fidelity",
        str(HERE / "statement_fidelity.md"),
        "--artifact-dir",
        str(HERE),
        "--project-root",
        str(ROOT),
        "--claim",
        "D_CORE_257",
        "--timeout",
        "600",
    ]
    process = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    (HERE / "compiler_record.json").write_text(process.stdout)
    if process.returncode:
        sys.stderr.write(process.stdout + process.stderr)
        raise SystemExit(process.returncode)
    result = json.loads(process.stdout)
    assert result["status"] == "success" and result["exit_code"] == 0
    assert result["proof_holes"] == []
    assert "4.31.0" in result["tools"]["lean"]["version"]
    record = result["kernel"]["recorded"]
    assert record is not None and record["tier"] == "mechanical" and record["verdict"] == "supports"
    archived = json.loads((ROOT / record["artifact"]).read_text())
    assert archived["lean_source"]["text"] == (HERE / "Main.lean").read_text()
    assert archived["statement_fidelity"]["text"] == (HERE / "statement_fidelity.md").read_text()
    return {
        "claim_id": "D_CORE_257",
        "status": result["status"],
        "compiler_exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "lean_version": result["tools"]["lean"]["version"],
        "source": "research/diagram-deficit/Main.lean",
        "statement_fidelity": "research/diagram-deficit/statement_fidelity.md",
        "archived_certificate": record["artifact"],
        "declarations": [
            "DiagramDeficit.local_sound",
            "DiagramDeficit.LocalPattern.field_capacity",
            "DiagramDeficit.weighted_rank",
            "DiagramDeficit.Incidence.weight_is_max",
            "DiagramDeficit.Incidence.apex",
            "DiagramDeficit.Incidence.occurrence_bound",
            "DiagramDeficit.RankedFragment.layer_rank",
            "DiagramDeficit.RankedFragment.weighted_contacts",
            "DiagramDeficit.fragment_bound",
            "DiagramDeficit.manuscript_fragment",
        ],
    }


def campaign_checks():
    statuses = {}
    for module in ("math_state", "proof_graph_check"):
        process = subprocess.run(
            [
                ARGUS_PYTHON,
                "-m",
                "argus_skill.verticals.math." + module,
                "check",
                "--project-root",
                str(ROOT),
            ],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
        statuses[module] = process.returncode
        if process.returncode:
            sys.stderr.write(process.stdout + process.stderr)
    if any(statuses.values()):
        raise SystemExit(1)
    return {"project_root": str(ROOT), "exit_statuses": statuses}


def compute_certificate():
    return {
        "claim_id": "D_CORE_257",
        "classification": "strengthened conditional universal verification theorem",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "independent_review": "pending",
        "novelty_status": "unverified",
        "significance_status": "unreviewed",
        "source_locators": [
            locator("02-model.tex", "def:template"),
            locator("03-diagrams.tex", "diagram:normal-form"),
            locator("03-diagrams.tex", "diagram:weighted-rank"),
            locator("03-diagrams.tex", "diagram:apex"),
            locator("03-diagrams.tex", "diagram:fragment"),
        ],
        "premises": [
            "The fan graph and exceptional ports are reconstructed from F_2^3, not from a stored case table.",
            "Every full link is a cyclic list of distinct radial labels, of length at least two.",
            "Each step is a fan edge, a turn of one designated occurrence D, or a turn of another occurrence O.",
            "Consecutive D turns are excluded at every radial label, including across the cyclic join.",
            "A two-step link consisting of the same fan edge traversed twice is excluded by indexed-side cancellation.",
            "O turns may have arbitrary mutually different occurrence identities; their other cancellation exclusions are relaxed.",
            "Each selected turn incident to X_D contributes one loose-side payment.",
            "Every nonempty selected subset is tested, without a connectivity or single-run restriction.",
        ],
        "universal_local_conclusions": [
            "4 - 2*d <= q + loose_payments + 3*partial",
            "2*(dominant-other) <= q + loose_payments + 3*partial",
            "2*partial <= radial_transitions",
            "q <= 4",
            "dominant <= 1",
            "each indexed fan field is used at most once per link",
        ],
        "fans": check_links(),
        "macro_graph": check_macro_cycles(),
        "jacobian": replay_jacobian(),
        "universal_conclusion": {
            "parameters": "real alpha>0, beta>7*alpha, delta>0",
            "kappa4": "min(beta-7*alpha,alpha/4,delta)",
            "bound": "4*kappa4*(T+Q+E) <= 2*B_raw+3*B_rad <= 3*(B_raw+B_rad)",
            "manuscript_corollary": "T+Q+E <= (B_raw+B_rad)/min(beta-7*alpha,alpha/5,delta)",
            "quantifier": "all finite occurrence counts, all multiplicities, all shared prerequisite incidences, and all selected local masks satisfying RankedFragment",
            "conditional_on": "faithful normalized-incidence data and the manuscript occurrence-rank hypothesis for every prerequisite-closed collection of at most 8A occurrences",
        },
        "not_concluded": [
            "Finite computations alone do not prove the universal theorem; the attached Lean run is required.",
            "No existence or chain preservation of normal pictures is inferred.",
            "No occurrence-rank probability estimate or main CAT(0) theorem is certified here.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = compute_certificate()
    result["formal"] = certify_formal()
    result["campaign_checks"] = campaign_checks()
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        recorded = json.loads(certificate.read_text())
        assert recorded == result, "The recorded exact certificate differs from independent reconstruction."
    fans = result["fans"]
    print(
        json.dumps(
            {
                "status": "universal formal theorem and exact reconstruction passed",
                "colored_links": sum(fan["colored_links_up_to_dihedral_vertex_order"] for fan in fans),
                "selected_subsets": sum(fan["nonempty_selected_subsets"] for fan in fans),
                "max_selected_fan_triangles_per_link": max(fan["max_fan_triangles"] for fan in fans),
                "compiler_exit_code": result["formal"]["compiler_exit_code"],
                "proof_holes": result["formal"]["proof_holes"],
                "campaign_checks": result["campaign_checks"],
                "independent_review": "pending",
            }
        )
    )


if __name__ == "__main__":
    main()
