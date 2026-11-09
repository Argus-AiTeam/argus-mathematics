#!/usr/bin/env python3
"""Replay the exact formal core and its explicitly finite regressions."""

import argparse
import hashlib
import itertools
import json
import re
import subprocess
from collections import deque
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_APR_FORMAL_CORE"


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def run_checked(command):
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    require(
        result.returncode == 0,
        f"Command failed ({result.returncode}): {command}\n"
        f"{result.stdout}\n{result.stderr}",
    )


def replay_lean():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence",
        "verify", str(HERE / "Main.lean"),
        "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--artifact-dir", str(HERE), "--project-root", str(ROOT),
        "--claim", CLAIM, "--timeout", "100",
    ]
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    for module in ("math_state", "proof_graph_check"):
        run_checked([
            ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
            "check", "--project-root", str(ROOT),
        ])
    require(
        result.returncode == 0,
        f"Lean replay failed ({result.returncode}):\n"
        f"{result.stdout}\n{result.stderr}",
    )


def verify_formal(certificate):
    formal = certificate["formal"]
    require(formal["claim_id"] == CLAIM, "Unexpected formal claim.")
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    archive_path = ROOT / formal["archive"]
    archive = load(archive_path)
    require(archive["tier"] == "mechanical", "Not mechanical evidence.")
    require(archive["verdict"] == "supports", "No supporting compiler verdict.")
    require(archive["subject"]["subject_id"] == CLAIM, "Wrong archived claim.")
    require(archive["lean_source"]["text"] == source, "Archived source is stale.")
    require(
        archive["statement_fidelity"]["text"] == fidelity,
        "Archived statement-fidelity document is stale.",
    )
    expected_source = hashlib.sha256(source.encode("utf-8")).hexdigest()
    expected_fidelity = hashlib.sha256(fidelity.encode("utf-8")).hexdigest()
    for result in (archive["lean_check"], load(HERE / "lean_check.json")):
        require(result["status"] == "success", "Lean did not succeed.")
        require(result["exit_code"] == 0, "Lean returned a failure.")
        require(result["proof_holes"] == [], "Lean proof has holes.")
        require(result["audit_exit_code"] == 0, "Axiom audit did not succeed.")
        require(not result["environment_failure"], "Lean environment failure.")
        require(
            "version 4.31.0," in result["tools"]["lean"]["version"],
            "The required Lean 4.31.0 was not used.",
        )
        require(result["source_sha256"] == expected_source, "Stale source digest.")
        require(
            result["statement_fidelity_sha256"] == expected_fidelity,
            "Stale statement-fidelity digest.",
        )
    for declaration in formal["declarations"]:
        require(
            re.search(rf"(?m)^(?:theorem|def) {re.escape(declaration)}\b", source),
            f"Missing formal declaration: {declaration}",
        )
        require(
            declaration in fidelity,
            f"Statement fidelity does not discuss {declaration}.",
        )
    state = load(ROOT / "research" / "MATH_STATE.json")
    versions = [c for c in state["claims"] if c["claim_id"] == CLAIM]
    require(bool(versions), "The formal claim is missing from the ledger.")
    current = max(versions, key=lambda c: c["version"])
    require(current["formal_statement"] == source, "Ledger formalization is stale.")
    require(
        current["content_hash"] == archive["subject"]["content_hash"],
        "Certificate refers to a superseded claim version.",
    )
    require(
        any(
            e["subject"] == archive["subject"]
            and e["tier"] == "mechanical"
            and e["verdict"] == "supports"
            and e["artifact"] == formal["archive"]
            for e in state["evidence"]
        ),
        "The actual compiler evidence is not recorded on the current claim.",
    )
    return len(formal["declarations"])


def verify_boundary(certificate):
    spec = certificate["jacobian"]
    contract = load(HERE / spec["contract"])
    payload = load(HERE / spec["payload"])
    result = load(HERE / spec["output"])
    require(spec["adapter_exit_code"] == 0, "Adapter failed.")
    require(spec["timeout"] is False, "Adapter timed out.")
    require(spec["error"] is None, "Adapter reported an error.")
    require(result["request"]["payload"] == payload, "Payload/source mismatch.")
    require(
        result["request"]["operation_id"] == "matrix.nullspace.compute",
        "Wrong operation.",
    )
    require(
        contract["result"]["operation"]["operation_id"]
        == result["request"]["operation_id"],
        "The operation's typed contract was not retained.",
    )
    require(
        result["server"]["version"] == contract["server"]["version"] == "0.14.0",
        "Unexpected Jacobian version.",
    )
    require(
        result["protocol_version"] == contract["protocol_version"] == "2025-11-25",
        "Unexpected Jacobian protocol.",
    )
    matrix = {"domain": "QQ", "entries": [[{"num": "1", "den": "1"}]]}
    require(payload == {"matrix": matrix}, "Wrong fixed-point equation.")
    output = result["result"]["output"]
    expected = {
        "matrix": matrix, "ambient_dimension": 1, "rank": 1, "nullity": 0,
        "basis_vectors": [], "free_columns": [],
        "convention": "RREF_FUNDAMENTAL_BASIS",
    }
    require(output == expected, "Incorrect exact nullspace result.")
    require(2 - 1 == 1, "Incorrect doubling fixed-point coefficient.")
    completed = certificate["boundary_examples"]["completed_ray"]
    matrix, inverse = completed["matrix"], completed["inverse_matrix"]
    require(matrix == [[2, 0], [1, 1]], "Incorrect interval automorphism.")
    require(inverse == [[1, 0], [-1, 2]], "Incorrect interval inverse.")
    for left, right in ((matrix, inverse), (inverse, matrix)):
        composition = [
            [sum(left[i][k] * right[k][j] for k in range(2))
             for j in range(2)] for i in range(2)
        ]
        require(composition == [[2, 0], [0, 2]], "Inverse composition is not scalar.")
    for transform in (matrix, inverse):
        (a, b), (c, d) = transform
        require(a * d - b * c > 0, "The interval map is not increasing.")
        require(d > 0 and c + d > 0, "A denominator can vanish on [0,1].")
        require(b == 0 and a + b == c + d, "Endpoints are not fixed.")
    numerator = completed["numerator"]
    require(numerator == [0, 1, -1], "Incorrect Mobius fixed-point numerator.")
    product = [0, 0, 0]
    for i, a in enumerate([0, 1]):
        for j, b in enumerate([1, -1]):
            product[i + j] += a * b
    require(product == numerator, "The numerator does not factor as t(1-t).")


def labelled_trees(n):
    if n == 1:
        yield frozenset()
        return
    for code in itertools.product(range(n), repeat=n - 2):
        degree = [1] * n
        for v in code:
            degree[v] += 1
        edges = []
        for v in code:
            leaf = next(i for i, d in enumerate(degree) if d == 1)
            edges.append(tuple(sorted((leaf, v))))
            degree[leaf] -= 1
            degree[v] -= 1
        a, b = [v for v, d in enumerate(degree) if d == 1]
        edges.append(tuple(sorted((a, b))))
        yield frozenset(edges)


def subsets(n):
    return [
        frozenset(v for v in range(n) if mask & (1 << v))
        for mask in range(1 << n)
    ]


def root_data(adjacency, root):
    parent = {root: root}
    queue = deque([root])
    while queue:
        v = queue.popleft()
        for w in adjacency[v]:
            if w not in parent:
                parent[w] = v
                queue.append(w)
    ancestors = []
    for v in range(len(adjacency)):
        chain = [v]
        while chain[-1] != root:
            chain.append(parent[chain[-1]])
        ancestors.append(chain)
    meet = [
        [next(a for a in ancestors[u] if a in ancestors[v])
         for v in range(len(adjacency))]
        for u in range(len(adjacency))
    ]
    return ancestors, meet


def finite_regressions(max_vertices):
    counts = {
        "labelled_trees": 0, "rooted_trees": 0, "rooted_automorphisms": 0,
        "admissible_U_V_instances": 0, "leaf_deletions": 0,
    }
    for n in range(1, max_vertices + 1):
        sets = subsets(n)
        for edges in labelled_trees(n):
            counts["labelled_trees"] += 1
            adjacency = [set() for _ in range(n)]
            for a, b in edges:
                adjacency[a].add(b)
                adjacency[b].add(a)
            leaves = [v for v in range(n) if len(adjacency[v]) == 1]
            for mask in range(1 << len(leaves)):
                removed = {v for i, v in enumerate(leaves) if mask & (1 << i)}
                remaining = set(range(n)) - removed
                if remaining:
                    reached = {min(remaining)}
                    queue = deque(reached)
                    while queue:
                        v = queue.popleft()
                        for w in adjacency[v] & remaining - reached:
                            reached.add(w)
                            queue.append(w)
                    require(reached == remaining, "Leaf deletion disconnected a tree.")
                else:
                    require(n <= 2, "Leaf deletion emptied a larger tree.")
                counts["leaf_deletions"] += 1
            for root in range(n):
                counts["rooted_trees"] += 1
                ancestors, meet = root_data(adjacency, root)
                lower_sets = [
                    V for V in sets
                    if all(set(ancestors[v]) <= V for v in V)
                ]
                meet_sets = [
                    U for U in sets if U
                    and all(meet[a][b] in U for a in U for b in U)
                ]
                for f in itertools.permutations(range(n)):
                    if f[root] != root:
                        continue
                    if {tuple(sorted((f[a], f[b]))) for a, b in edges} != edges:
                        continue
                    counts["rooted_automorphisms"] += 1
                    fixed = {v for v in range(n) if f[v] == v}
                    for y in range(n):
                        x = meet[y][f[y]]
                        require(
                            any(x in ancestors[z] for z in fixed),
                            "No fixed point above the orbit meet.",
                        )
                    for U in meet_sets:
                        if any(f[v] not in U for v in U):
                            continue
                        for V in lower_sets:
                            if U & V:
                                continue
                            require(fixed - V, "No fixed point outside the lower set.")
                            counts["admissible_U_V_instances"] += 1
    return counts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--replay-lean", action="store_true")
    args = parser.parse_args()
    if args.replay_lean:
        replay_lean()
    certificate = load(HERE / "exact_certificate.json")
    declarations = verify_formal(certificate)
    verify_boundary(certificate)
    for relative in certificate["primary_sources"]:
        path = HERE / relative
        require(path.is_file() and path.stat().st_size > 0, f"Missing source: {path}")
    counts = finite_regressions(certificate["finite_regressions"]["max_vertices"])
    for key, value in certificate["finite_regressions"]["expected"].items():
        require(counts[key] == value, f"Incorrect regression coverage for {key}.")
    require(
        certificate["independent_review"] == "pending_Host_Reviewer",
        "This Engineer verifier cannot manufacture an independent review.",
    )
    print(json.dumps({
        "status": "PASS",
        "formal_core": "Lean 4.31.0; exit_code=0; proof_holes=[]",
        "formal_declarations": declarations,
        "finite_regressions_only": counts,
        "full_reduction": "proof in report.md; independent review pending",
        "manuscript_refutations": [],
        "campaign_completion_claimed": False,
    }, indent=2))


if __name__ == "__main__":
    main()
