#!/usr/bin/env python3
"""Replay exact graph checks and compile the universal Lean theorem."""

import itertools
import json
import os
from pathlib import Path
import re
import subprocess
from fractions import Fraction


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def powerset(vertices):
    for mask in range(1, 1 << len(vertices)):
        yield {v for i, v in enumerate(vertices) if mask & (1 << i)}


def adjacency(r, edges):
    require(len(edges) == len(set(edges)), "Repeated graph edge")
    neighbours = [set() for _ in range(r)]
    for u, v in edges:
        require(0 <= u < v < r, "Graph must be simple and canonically ordered")
        neighbours[u].add(v)
        neighbours[v].add(u)
    return neighbours


def exact_expansion(neighbours):
    r = len(neighbours)
    bit_neighbours = [sum(1 << v for v in ns) for ns in neighbours]
    best = None
    full = (1 << r) - 1
    for mask in range(1, full):
        size = mask.bit_count()
        if 2 * size > r:
            continue
        cut = sum((ns & (full ^ mask)).bit_count()
                  for u, ns in enumerate(bit_neighbours) if mask & (1 << u))
        value = Fraction(cut, size)
        best = value if best is None else min(best, value)
    return best


def ball_layers(neighbours, deleted, forbidden, root):
    require(root not in forbidden, "Root deleted by its own forbidden set")
    reached = {root}
    layers = [reached]
    for _ in neighbours:
        new = set(reached)
        for u in reached:
            new.update(v for v in neighbours[u] if v not in forbidden
                       and tuple(sorted((u, v))) not in deleted)
        layers.append(new)
        reached = new
    require(layers[-1] == layers[-2], "Graph balls did not saturate")
    return layers


def check_growth(neighbours, deleted, forbidden, roots, h, layers):
    r = len(neighbours)
    checked = 0
    for active in powerset(roots):
        for t in range(r):
            before = set().union(*(layers[s][t] for s in active))
            after = set().union(*(layers[s][t + 1] for s in active))
            if 2 * len(before) > r or len(deleted) > h * len(before) / 4:
                continue
            labels = {v: min(s for s in active if v in layers[s][t])
                      for v in before}
            cut = [(u, v) for u in before for v in neighbours[u] if v not in before]
            deleted_cut = [(u, v) for u, v in cut
                           if tuple(sorted((u, v))) in deleted]
            forbidden_cut = [(u, v) for u, v in cut if v in forbidden[labels[u]]]
            usable = [(u, v) for u, v in cut
                      if tuple(sorted((u, v))) not in deleted
                      and v not in forbidden[labels[u]]]
            require(len(cut) >= h * len(before), "Cut expansion failed")
            require(len(deleted_cut) <= len(deleted), "Deleted-edge injection failed")
            require(len(forbidden_cut) <= sum(len(forbidden[labels[u]]) for u in before),
                    "Root-labelled forbidden-edge count failed")
            require(len(usable) >= h * len(before) / 2, "Usable boundary count failed")
            require(all(v in after - before for _, v in usable), "Wrong root graph used")
            require(len(usable) <= r * len(after - before), "New-vertex count failed")
            require(len(after) >= (1 + h / (2 * r)) * len(before), "Union growth failed")
            checked += 1
    return checked


def check_small_graphs(orders):
    graphs = connected = growth_checks = 0
    for r in orders:
        possible = list(itertools.combinations(range(r), 2))
        for mask in range(1 << len(possible)):
            edges = [e for i, e in enumerate(possible) if mask & (1 << i)]
            neighbours = adjacency(r, edges)
            h = exact_expansion(neighbours)
            graphs += 1
            if h == 0:
                continue
            connected += 1
            roots = list(range(r))
            forbidden = {s: set() for s in roots}
            layers = {s: ball_layers(neighbours, set(), forbidden[s], s) for s in roots}
            growth_checks += check_growth(neighbours, set(), forbidden, roots, h, layers)
            require(all(len(layers[s][-1]) == r for s in roots), "Connected ball failed")
    return {"graphs": graphs, "connected_graphs": connected, "growth_checks": growth_checks}


def case_graph(case):
    r = case["r"]
    h = Fraction(case["h"])
    if case["graph_family"] == "complete":
        edges = list(itertools.combinations(range(r), 2))
        require(all(m * (r - m) >= h * m for m in range(1, r // 2 + 1)),
                "Complete graph expansion certificate failed")
    else:
        require(case["graph_family"] == "clique_with_low_degree_root",
                "Unknown graph family")
        require(case["special_root"] == 0, "Unexpected special-root labelling")
        edges = list(itertools.combinations(range(1, r), 2))
        ns = case["special_neighbours"]
        edges += [(0, v) for v in ns]
        degree = len(ns)
        require(degree == h, "Singleton cut must attain the certified expansion")
        for inside in (0, 1):
            for a in range(degree + 1):
                for b in range(r - 1 - degree + 1):
                    size = inside + a + b
                    if not 0 < 2 * size <= r:
                        continue
                    m = a + b
                    cut = m * (r - 1 - m) + (degree - a if inside else a)
                    require(cut >= h * size, "Symmetry-reduced expansion check failed")
    return adjacency(r, edges), set(edges)


def check_case(case):
    neighbours, edges = case_graph(case)
    r, h = case["r"], Fraction(case["h"])
    roots = case["roots"]
    deleted = {tuple(e) for e in case["deleted_edges"]}
    forbidden = {int(s): set(ws) for s, ws in case["forbidden"].items()}
    require(deleted <= edges, "Deleted nonedge in finite certificate")
    require(len(deleted) <= h * len(roots) / 4, "Initial edge budget failed")
    require(len(deleted) <= h * r / 64, "Restart edge budget failed")
    require(all(len(forbidden[s]) <= h / 4 for s in roots), "Forbidden budget failed")
    require(all(forbidden[s] <= set(range(r)) for s in roots), "Forbidden vertex out of range")
    require(len(set(roots)) == len(roots), "Repeated roots are not a set")
    layers = {s: ball_layers(neighbours, deleted, forbidden[s], s) for s in roots}
    expected = {int(s): size for s, size in case["expected_radius_one_sizes"].items()}
    require({s: len(layers[s][1]) for s in roots} == expected, "Ball sizes differ")
    require((2 * r) & (2 * r - 1) == 0, "Exact g calculation needs a power-of-two 2r")
    g_real = 8 * Fraction(r, h) * ((2 * r).bit_length() - 1)
    g = -(-g_real.numerator // g_real.denominator)
    require(g == case["g"], "Ceiling-defined g differs")
    radius = g * (1 + (len(roots) - 1).bit_length())
    witnesses = [s for s in roots if 2 * len(layers[s][min(radius, r)]) > r]
    require(witnesses, "Root theorem failed on an exact finite case")
    for s in case.get("expected_permanently_isolated_roots", []):
        require(layers[s][-1] == {s}, "Expected isolated root is not isolated")
    checks = check_growth(neighbours, deleted, forbidden, roots, h, layers)
    return {"name": case["name"], "g": g, "radius_bound": radius,
            "majority_roots": witnesses, "growth_checks": checks}


def check_budget_identities(data):
    h = list(map(Fraction, data["h"]))
    forbidden = [Fraction(x) for x in (0, 4, 1, 0)]
    initial = [Fraction(x) for x in (8, 0, 0, 0)]
    global_ = [Fraction(x) for x in (1, 0, 0, 0)]
    for key, divisor, sub in (
        ("h_over_16_minus_forbidden", 16, forbidden),
        ("h_over_4_minus_initial_edge_coefficient", 4, initial),
        ("h_over_64_minus_global_edge_coefficient", 64, global_),
    ):
        result = [v / divisor - u for v, u in zip(h, sub)]
        require(result == list(map(Fraction, data[key])), "Polynomial identity failed: " + key)
        require(all(v >= 0 for v in result), "Negative coefficient in budget certificate")
    for n in range(1, 257):
        count = n
        for j in range((n - 1).bit_length() + 1):
            require(count <= (n + (1 << j) - 1) // (1 << j), "Rounded halving bound failed")
            count = (count + 1) // 2
        require(count == 1, "Rounded halving failed to reach one root")


def check_jacobian(data, case):
    request = json.loads((HERE / data["payload"]).read_text())
    result = json.loads((HERE / data["typed_output"]).read_text())
    status = json.loads((HERE / data["adapter_status"]).read_text())
    require(status["adapter_exit"] == 0 and not status["timed_out"],
            "Jacobian failure or timeout is not mathematical evidence")
    require(result["server"]["version"] == data["server_version"], "Server version differs")
    require(result["protocol_version"] == data["protocol_version"], "Protocol differs")
    require(result["result"]["operation_id"] == data["operation_id"], "Operation differs")
    require(result["request"]["payload"] == request, "Typed output is not bound to the payload")
    neighbours, _ = case_graph(case)
    root, sink = data["root"], data["sink"]
    forbidden = set(case["forbidden"][str(root)])
    deleted = {tuple(e) for e in case["deleted_edges"]}
    expected_edges = [
        {"source": u, "target": v, "capacity": {"num": "1", "den": "1"}}
        for u in range(case["r"]) for v in range(case["r"])
        if v in neighbours[u] and u not in forbidden and v not in forbidden
        and tuple(sorted((u, v))) not in deleted
    ]
    require(request == {"graph": {"vertex_count": case["r"], "edges": expected_edges},
                        "source": root, "sink": sink}, "Payload changed the root-specific graph")
    output = result["result"]["output"]
    require(output["convention"] == "NETWORKX_MINIMUM_CUT", "Wrong cut convention")
    left, right = set(output["reachable"]), set(output["unreachable"])
    require(not left & right and left | right == set(range(case["r"])), "Not a cut partition")
    require(root in left and sink in right, "Cut does not separate the terminals")
    arcs = {(e["source"], e["target"]) for e in expected_edges}
    cut_value = sum(u in left and v in right for u, v in arcs)
    expected = Fraction(data["expected_cut_value"])
    typed = output["cut_value"]
    require(Fraction(int(typed["num"]), int(typed["den"])) == cut_value == expected,
            "Cut capacity does not replay")
    paths = [[root, sink]] + [[root, v, sink] for v in sorted(neighbours[root])
                             if v != sink and (root, v) in arcs and (v, sink) in arcs]
    used = set()
    for path in paths:
        path_edges = set(zip(path, path[1:]))
        require(path_edges <= arcs and not used & path_edges, "Lower-bound paths overlap")
        used.update(path_edges)
    require(len(paths) == expected, "Cut upper bound lacks an equal path lower bound")
    return {"operation": data["operation_id"], "cut_value": cut_value,
            "independently_replayed_paths": len(paths)}


def compile_theorem(certificate):
    workspace = Path(os.environ.get(
        "ARGUS_SKILL_MATHLIB_WORKSPACE",
        str(Path.home() / ".local/share/argus-skill/mathlib-v4.31.0")))
    require((workspace / "lakefile.toml").is_file(), "Built Mathlib workspace is missing")
    version = subprocess.run(["lean", "--version"], check=True, text=True,
                             capture_output=True, timeout=10).stdout
    require("version " + certificate["required_lean_version"] + "," in version,
            "Wrong Lean compiler version")
    source = HERE / certificate["formal_source"]
    result = subprocess.run(["lake", "env", "lean", str(source)], cwd=workspace,
                            text=True, capture_output=True, timeout=110)
    if result.returncode:
        raise RuntimeError("Lean compilation failed:\n" + result.stdout + result.stderr)
    axioms = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", result.stdout)
    require({name for name, _ in axioms} ==
            {"RoutingCore.union_growth", certificate["principal_declaration"]},
            "Compiler did not print the expected theorem dependencies")
    allowed = set(certificate["allowed_foundational_axioms"])
    for name, dependencies in axioms:
        require(set(dependencies.split(", ")) <= allowed,
                "Unapproved axiom in " + name + ": " + dependencies)
    require("sorryAx" not in result.stdout, "A proof hole reached the compiler")
    return {"version": version.strip(), "exit_code": result.returncode,
            "theorem": certificate["principal_declaration"], "proof_holes": []}


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim"] == "V_ROUTING_ROOT", "Wrong goal claim")
    require(certificate["graph_theorem_external_assumptions"] == [],
            "The graph theorem must not acquire an external assumption")
    check_budget_identities(certificate["budget_identities"])
    cases = certificate["finite_checks"]["cases"]
    output = {
        "finite_validation": check_small_graphs(certificate["finite_checks"]["all_simple_graph_orders"]),
        "root_specific_cases": [check_case(case) for case in cases],
        "jacobian_replay": check_jacobian(certificate["jacobian"], cases[0]),
        "universal_formal_verification": compile_theorem(certificate),
        "scope": certificate["scope"],
        "independent_review": "not performed by this script",
    }
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
