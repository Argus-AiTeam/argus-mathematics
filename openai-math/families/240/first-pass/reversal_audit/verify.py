#!/usr/bin/env python3
"""Replay the exact formal core and explicitly scoped finite sanity checks."""

import itertools
import json
import re
import subprocess
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C240_FORMAL_CORE"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def leading_lt(positions, left, right):
    return any(
        left[i] < right[i]
        and all(left[j] == right[j] for j in range(len(left)) if positions[i] < positions[j])
        for i in range(len(left))
    )


def semantic_compare(positions, left, right):
    differing = [i for i in range(len(left)) if left[i] != right[i]]
    if not differing:
        return 0
    i = max(differing, key=positions.__getitem__)
    return 1 if left[i] > right[i] else -1


def check_integer_codes():
    cases = 0
    for n in range(1, 5):
        vectors = list(itertools.product((-1, 0, 1), repeat=n))
        for positions in itertools.permutations(range(n)):
            moved = tuple(3 + 5 * p + p * p for p in positions)
            for left, right in itertools.product(vectors, repeat=2):
                expected = semantic_compare(positions, left, right) < 0
                require(leading_lt(positions, left, right) == expected, "Leading-coordinate sign error")
                require(leading_lt(moved, left, right) == expected, "Position transport changed order")
                cases += 1
    require(cases == 162009, "Incomplete integer-code replay")
    return cases


def check_nested_codes():
    ranks = list(itertools.product((-1, 0, 1), repeat=2))
    positions = (0, 1)
    moved = (5, 17)
    higher = [
        [leading_lt(positions, left, right) for right in ranks]
        for left in ranks
    ]
    moved_higher = [
        [leading_lt(moved, left, right) for right in ranks]
        for left in ranks
    ]
    require(higher == moved_higher, "Integer-rank order changed")
    zero = Fraction(0)
    vectors = [tuple(zero for _ in ranks)]
    for size in (1, 2):
        for support in itertools.combinations(range(len(ranks)), size):
            for values in itertools.product((Fraction(-1), Fraction(1, 2), Fraction(1)), repeat=size):
                vector = [zero for _ in ranks]
                for i, value in zip(support, values):
                    vector[i] = value
                vectors.append(tuple(vector))

    def nested_lt(left, right, order):
        return any(
            left[i] < right[i]
            and all(left[j] == right[j] for j in range(len(ranks)) if order[i][j])
            for i in range(len(ranks))
        )

    cases = 0
    for left, right in itertools.product(vectors, repeat=2):
        differing = [i for i in range(len(ranks)) if left[i] != right[i]]
        if differing:
            i = max(differing, key=lambda j: (ranks[j][1], ranks[j][0]))
            expected = left[i] < right[i]
        else:
            expected = False
        require(nested_lt(left, right, higher) == expected, "Nested leading-rank sign error")
        require(nested_lt(left, right, moved_higher) == expected, "Nested transport changed order")
        cases += 1
    require(len(vectors) == 352 and cases == 123904, "Incomplete rational-code replay")
    return {"ranks": len(ranks), "vectors": len(vectors), "pairs": cases}


def check_preorders():
    counts = {}
    elimination_cases = 0
    for n in range(1, 5):
        off_diagonal = [(i, j) for i in range(n) for j in range(n) if i != j]
        count = 0
        for mask in range(1 << len(off_diagonal)):
            relation = {(i, i) for i in range(n)}
            relation.update(pair for k, pair in enumerate(off_diagonal) if mask & (1 << k))
            if any(
                (x, y) in relation and (y, z) in relation and (x, z) not in relation
                for x, y, z in itertools.product(range(n), repeat=3)
            ):
                continue
            count += 1
            for p, r in relation:
                if (r, p) in relation:
                    continue
                for q in range(n):
                    target = r if (q, p) in relation else q
                    require((q, target) in relation, "Elimination step is not an arrow")
                    require((target, p) not in relation, "Elimination target can return")
                    for future in range(n):
                        if (target, future) in relation:
                            require((future, p) not in relation, "Reachability recovered")
                    elimination_cases += 1
        counts[str(n)] = count
    require(counts == {"1": 1, "2": 4, "3": 29, "4": 355}, "Incomplete preorder enumeration")
    return {"preorders_by_size": counts, "elimination_cases": elimination_cases}


def check_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_run_status.json").read_text())
    operation = "implication_system.closure.compute"
    require(status["adapter_exit_code"] == 0 and status["timeout"] is False, "Jacobian did not conclude")
    require(response["request"]["operation_id"] == operation, "Wrong Jacobian operation")
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch")
    output = response["result"]["output"]
    closure = set(payload["seed"])
    while True:
        previous = set(closure)
        for rule in payload["system"]["implications"]:
            if set(rule["premise"]) <= previous:
                closure.update(rule["conclusion"])
        if closure == previous:
            break
    require(sorted(closure) == output["closure"] == [0, 1, 2], "Incorrect Horn closure")
    require(output["added"] == [2], "Incorrect Horn derivation")
    require(
        output["lineage"] == [{"activation_round": 1, "attribute": 2, "implication_index": 0}],
        "Incorrect canonical lineage",
    )
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "timeout": status["timeout"],
        "closure": sorted(closure),
        "scope": "Three-attribute transitivity implication only",
    }


def compile_core():
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"),
        "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--project-root", str(ROOT),
        "--claim", CLAIM,
        "--timeout", "300",
    ]
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    checks = {}
    for module in ("math_state", "proof_graph_check"):
        check = subprocess.run(
            [ARGUS, "-m", f"argus_skill.verticals.math.{module}", "check", "--project-root", str(ROOT)],
            cwd=ROOT, text=True, capture_output=True,
        )
        checks[module] = check.returncode
        if check.returncode:
            print(check.stdout, check.stderr, flush=True)
    if result.returncode:
        print(result.stdout, result.stderr, flush=True)
        raise RuntimeError(f"Official Lean verification failed with exit {result.returncode}")
    require(all(code == 0 for code in checks.values()), "Campaign-local structural check failed")
    evidence = json.loads(result.stdout)
    require(evidence["status"] == "success", "Compiler did not report success")
    require(evidence["exit_code"] == 0, "Compiler exit was nonzero")
    require(evidence["proof_holes"] == [], "Compiler found a proof hole")
    require(evidence["audit_exit_code"] == 0, "The axiom audit did not finish")
    version = evidence["tools"]["lean"]["version"]
    require(re.search(r"\b4\.31\.0\b", version) is not None, "Wrong Lean version")
    require(evidence["kernel"]["recorded"] is not None, "Mechanical evidence was not attached to the claim")
    return evidence, {"project_root": str(ROOT), **checks}


def main():
    finite_checks = {
        "integer_code_pairs": check_integer_codes(),
        "nested_codes": check_nested_codes(),
        "preorders": check_preorders(),
    }
    jacobian = check_jacobian()
    compiler, checks = compile_core()
    certificate = {
        "result_class": "formal_verification",
        "claim": CLAIM,
        "conclusion": (
            "Order-pattern transport preserves nested leading-coordinate comparisons and strict slots; "
            "ordinal tuple capture and the stated two-scale orbit-elimination criterion hold."
        ),
        "scope_limit": (
            "The complete unrestricted reversal argument is in proof.md and awaits independent mathematical "
            "review. The compiler does not formalize AECs, support-closure existence, profile selection, "
            "or the construction of the processing chain. Finite checks do not prove infinite claims."
        ),
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "not_established",
        "independent_review": "pending_host_invocation",
        "finite_sanity_checks": finite_checks,
        "jacobian": jacobian,
        "lean": {
            "version": compiler["tools"]["lean"]["version"],
            "exit_code": compiler["exit_code"],
            "proof_holes": compiler["proof_holes"],
            "axiom_audit_exit_code": compiler["audit_exit_code"],
            "source_sha256": compiler["source_sha256"],
            "statement_fidelity_sha256": compiler["statement_fidelity_sha256"],
            "kernel_record": compiler["kernel"]["recorded"],
        },
        "campaign_checks": checks,
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "claim": CLAIM,
        "result": "verified_formal_core",
        "lean_exit_code": compiler["exit_code"],
        "proof_holes": compiler["proof_holes"],
        "integer_code_pairs": finite_checks["integer_code_pairs"],
        "nested_code_pairs": finite_checks["nested_codes"]["pairs"],
        "campaign_checks": checks,
        "full_reversal": "complete_prose_argument_pending_independent_review",
        "novelty": "not_established",
    }, indent=2))


if __name__ == "__main__":
    main()
