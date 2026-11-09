#!/usr/bin/env python3
"""Replay exact controls and the source-bound Lean certificate using stdlib only."""

from fractions import Fraction
from hashlib import sha256
from itertools import permutations, product
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def reduced(word):
    result = []
    for letter in word:
        require(type(letter) is int and letter != 0, "Invalid free-group letter")
        if result and result[-1] == -letter:
            result.pop()
        else:
            result.append(letter)
    return result


def check_kernel(certificate):
    kernel = certificate["kernel"]
    record = read_json(HERE / kernel["record"])
    archive = read_json(HERE / kernel["archive"])
    source = (HERE / certificate["source"]).read_bytes()
    fidelity = (HERE / certificate["statement_fidelity"]).read_bytes()
    require(record["status"] == "success", "Lean did not report success")
    require(record["exit_code"] == 0, "Lean compiler failed")
    require(record["audit_exit_code"] == 0, "Lean axiom audit failed")
    require(record["proof_holes"] == [], "Lean proof has holes")
    require(record["environment_failure"] == "", "Lean environment was unverified")
    require("version 4.31.0," in record["tools"]["lean"]["version"], "Wrong Lean version")
    require(record["source_sha256"] == sha256(source).hexdigest(), "Stale Lean source")
    require(record["statement_fidelity_sha256"] == sha256(fidelity).hexdigest(), "Stale fidelity")
    require((HERE / "statement_fidelity.md").read_bytes() == fidelity, "Canonical fidelity differs")
    require(archive["lean_source"]["text"].encode() == source, "Archived source differs")
    require(archive["statement_fidelity"]["text"].encode() == fidelity, "Archived fidelity differs")
    require(archive["lean_check"] == {k: v for k, v in record.items() if k != "kernel"},
            "Compiler record differs from its archived result")
    require(record["kernel"]["refusals"] == [], "Kernel recording was refused")
    require(record["kernel"]["recorded"]["artifact"] == str((HERE / kernel["archive"]).relative_to(ROOT)),
            "Wrong archived certificate")
    require(archive["subject"] == record["kernel"]["recorded"]["subject"], "Claim binding differs")
    require(archive["verdict"] == "supports" and archive["tier"] == "mechanical",
            "Not supporting mechanical evidence")
    state = read_json(ROOT / "research/MATH_STATE.json")
    versions = [c for c in state["claims"] if c["claim_id"] == certificate["claim_id"]]
    current = max(versions, key=lambda c: c["version"])
    require(current["version"] == kernel["claim_version"], "Claim version changed")
    require(current["content_hash"] == archive["subject"]["content_hash"], "Stale claim reference")
    require(current["formal_statement"].encode() == source, "Ledger formalization differs")
    require(any(e["evidence_id"] == archive["evidence_id"] and
                e["subject"] == archive["subject"] and
                e["tier"] == "mechanical" and e["verdict"] == "supports"
                for e in state["evidence"]), "Mechanical evidence missing from ledger")
    for declaration in ("derived_inclusion", "correctionCost", "simultaneous_averaging", "endpoint_bridge"):
        expected = (f"'EndpointBridge.{declaration}' depends on axioms: "
                    "[propext, Classical.choice, Quot.sound]")
        require(expected in record["stdout"], f"Missing restricted axiom report for {declaration}")
    return archive["evidence_id"]


def check_words(certificate):
    identities = certificate["free_group_identities"]
    require(len({i["name"] for i in identities}) == len(identities), "Duplicate word identity")
    for identity in identities:
        letters = {abs(x) for x in identity["lhs"] + identity["rhs"]}
        require(letters == {int(x) for x in identity["variables"]}, "Word variable declaration differs")
        require(reduced(identity["lhs"]) == reduced(identity["rhs"]), identity["name"])
    require(reduced([1, 2, -1, -2]) != [], "Reducer incorrectly abelianizes")
    require(reduced([1, 2, -2, -1]) == [], "Reducer fails cancellation")
    return len(identities)


def compose(p, q):
    return tuple(p[q[i]] for i in range(len(p)))


def cycle_cost(p):
    seen = set()
    cycles = 0
    for i in range(len(p)):
        if i not in seen:
            cycles += 1
            while i not in seen:
                seen.add(i)
                i = p[i]
    return len(p) - cycles


def check_actions(certificate):
    group = list(permutations(range(3)))
    index = {p: i for i, p in enumerate(group)}
    identity = index[(0, 1, 2)]
    table = [[index[compose(g, h)] for h in group] for g in group]
    inverses = [next(j for j in range(6) if table[i][j] == identity) for i in range(6)]
    costs = [cycle_cost(g) for g in group]
    require(len(group) == certificate["finite_controls"]["coefficient_group_order"], "Wrong control group")
    require(any(table[g][h] != table[h][g] for g in range(6) for h in range(6)), "Control is commutative")
    for g, h in product(range(6), repeat=2):
        require(costs[table[g][h]] <= costs[g] + costs[h], "Cost not subadditive")
        require(costs[table[table[h][g]][inverses[h]]] == costs[g], "Cost not conjugation invariant")
        require(costs[inverses[g]] == costs[g], "Cost not inversion invariant")

    def difference(g, h):
        return table[g][inverses[h]]

    def multiply(values):
        result = identity
        for value in values:
            result = table[result][value]
        return result

    actions = [
        ("C2", [tuple(range(5)), (1, 0, 3, 2, 4)]),
        ("S3", [p + (3,) for p in group]),
        ("trivial", [(0, 1)]),
    ]
    results = []
    for name, action in actions:
        size = len(action[0])
        h = len(action)
        require(all(compose(a, b) in action for a, b in product(action, repeat=2)),
                "Not a group action")
        orbits = sorted({tuple(sorted({a[x] for a in action})) for x in range(size)},
                        key=lambda orbit: orbit[0])
        require(sum(map(len, orbits)) == size, "Orbit sets do not partition the domain")

        def average(values):
            return tuple(multiply(values[a[x]] for a in action) for x in range(size))

        def normalize(values, anchor):
            return tuple(table[value][inverses[values[anchor]]] for value in values)

        def diameter(values, orbit):
            return max(costs[difference(values[x], values[y])] for x in orbit for y in orbit)

        count = 0
        for values in product(range(6), repeat=size):
            count += 1
            first = average(values)
            for orbit in orbits:
                require(all(costs[difference(first[x], first[y])] % 2 == 0
                            for x in orbit for y in orbit), "Abelianization averaging fails")
            derived_values = first
            finished = []
            for orbit in orbits:
                derived_values = average(normalize(derived_values, orbit[0]))
                finished.append(orbit)
                for old in finished:
                    require(diameter(derived_values, old) == 0, "Derived-depth or preservation failure")

            target = orbits[0]
            anchor = target[0]
            current = normalize(values, anchor)
            degree = 1
            initial_B = max(costs[current[x]] for x in target)
            for step in range(2):
                B = max(costs[current[x]] for x in target)
                previous = [diameter(current, orbit) for orbit in orbits]
                averaged = average(current)
                next_values = tuple(table[value][inverses[current[anchor]]] for value in averaged)
                require(max(costs[next_values[x]] for x in target) <= (h - 1) * B,
                        "Omitted-factor contraction fails")
                for orbit, old in zip(orbits, previous):
                    new = diameter(next_values, orbit)
                    require(new <= h * old, "Product-difference bound fails")
                    require(Fraction(new, h * degree) <= Fraction(old, degree),
                            "An already achieved orbit ratio was spoiled")
                current = next_values
                degree *= h
                require(degree == h ** (step + 1), "Expression degree drift")
                require(diameter(current, target) <= 2 * (h - 1) ** (step + 1) * initial_B,
                        "Iterated contraction estimate fails")
        results.append({"group": name, "orbit_sizes": list(map(len, orbits)), "assignments": count})
    require(results == certificate["finite_controls"]["actions"], "Finite action coverage differs")
    require(sum(r["assignments"] for r in results) ==
            certificate["finite_controls"]["total_assignments"], "Assignment count differs")
    return results


def check_weights(certificate):
    count = 0
    for s, m, a, b, q in product(range(2, 11), range(1, 7), range(9), range(9),
                                (Fraction(1, 100), Fraction(1, 2), Fraction(1), Fraction(7, 3))):
        delta = Fraction(a + b, s * m) + Fraction(1, 50)
        larger, smaller = m + a, q * m + b
        require(a + b <= s * delta * m, "Control violates its degree budget")
        require(larger > 0 and smaller >= 0, "Invalid path weight")
        require(smaller / larger <= q + s * delta, "Endpoint weight inequality fails")
        count += 1
    require(count == certificate["finite_controls"]["rational_weight_cases"], "Weight coverage differs")
    return count


def check_jacobian(certificate):
    expected = certificate["jacobian"]
    result = read_json(HERE / expected["typed_output"])
    payload = read_json(HERE / expected["payload"])
    require(result["server"]["version"] == expected["server_version"], "Jacobian version changed")
    require(result["protocol_version"] == expected["protocol_version"], "Jacobian protocol differs")
    require(result["request"] == {"operation_id": expected["operation_id"], "payload": payload},
            "Jacobian request differs")
    require(result["result"]["operation_id"] == expected["operation_id"], "Wrong Jacobian operation")
    require(result["result"]["output"] == {"method": "SYMPY_SCHREIER_SIMS", "order": "6"},
            "Jacobian did not return the exact S3 order")
    require("error" not in result and expected["adapter_error"] is None and
            expected["adapter_timeout"] is False, "Adapter failure is not mathematical evidence")


def main():
    certificate = read_json(HERE / "exact_certificate.json")
    require(certificate["schema_version"] == 1, "Unknown certificate schema")
    require(certificate["claim_id"] == "C172_ENDPOINT_BRIDGE", "Wrong claim")
    check_jacobian(certificate)
    evidence = check_kernel(certificate)
    words = check_words(certificate)
    actions = check_actions(certificate)
    weights = check_weights(certificate)
    print(json.dumps({
        "status": "pass",
        "claim_id": certificate["claim_id"],
        "kernel_evidence_replayed": evidence,
        "fresh_compilation_by_this_script": False,
        "universal_proof": "source-bound Lean 4.31.0 certificate, no proof holes",
        "word_identities": words,
        "finite_action_controls": actions,
        "exact_rational_weight_controls": weights,
        "finite_controls_are_not_the_universal_proof": True,
        "independent_review": certificate["independent_review"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
