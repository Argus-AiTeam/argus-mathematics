"""Replay a finite history certificate. This does not certify the universal goal."""

import argparse
import json
from itertools import combinations
from pathlib import Path

from model import Construction, Model, bits


HERE = Path(__file__).resolve().parent


def replay(instance):
    model = Model(instance["n"], instance["edges"], work_limit=1000000)
    schedule = tuple(sum(1 << x for x in triple) for triple in instance["schedule"])
    construction = Construction(
        model, schedule, instance["center_choice"],
        instance.get("center_order", "rank"), instance.get("center_seed", 0))
    stats = construction.run()
    return construction, stats


def exchange_payload(query):
    jobs = query["jobs"]
    slots = len(jobs) // 3
    names = sorted(
        [f"job_{x:04d}_slot_{t:04d}" for x in jobs for t in range(slots)]
        + [f"count_slot_{t:04d}_prefix_{i:04d}_ge_{k}"
           for t in range(slots) for i in range(1, len(jobs)) for k in range(1, 4)])
    index = {name: i + 1 for i, name in enumerate(names)}

    def variable(x, t):
        return index[f"job_{x:04d}_slot_{t:04d}"]

    def counter(t, i, k):
        return index[f"count_slot_{t:04d}_prefix_{i:04d}_ge_{k}"]

    clauses = set()

    def add(literals):
        clause = tuple(sorted(set(literals), key=abs))
        if any(-literal in clause for literal in clause):
            return
        clauses.add(clause)

    for x in jobs:
        add(variable(x, t) for t in range(slots))
        for s, t in combinations(range(slots), 2):
            add([-variable(x, s), -variable(x, t)])
    for t in range(slots):
        for i, x in enumerate(jobs, 1):
            if i < len(jobs):
                add([-variable(x, t), counter(t, i, 1)])
            if i == 1:
                add([-counter(t, 1, 2)])
                add([-counter(t, 1, 3)])
            else:
                add([-variable(x, t), -counter(t, i - 1, 3)])
                if i < len(jobs):
                    for k in range(1, 4):
                        add([-counter(t, i - 1, k), counter(t, i, k)])
                    for k in range(2, 4):
                        add([-variable(x, t), -counter(t, i - 1, k - 1),
                             counter(t, i, k)])
    predecessors = {y: sum(1 << x for x in query["augmented_predecessors"][y])
                    for y in jobs}
    for k in jobs:
        for y in jobs:
            if predecessors[y] >> k & 1:
                predecessors[y] |= predecessors[k]
    for y in jobs:
        for x in bits(predecessors[y]):
            if any(predecessors[z] >> x & 1 for z in bits(predecessors[y])):
                continue
            for t in range(slots):
                for s in range(t + 1):
                    add([-variable(x, t), -variable(y, s)])
    payload = {"cnf": {"variables": names, "clauses": [list(c) for c in sorted(clauses)]},
               "timeout_ms": 1000}
    if len(names) > 1024 or len(clauses) > 8192:
        raise ValueError("the actual scheduling query exceeds the inspected Jacobian contract")
    return payload


def bind_canonical_output(query, response):
    raw = exchange_payload(query)
    expected_request = {"variable_names": raw["cnf"]["variables"],
                        "clauses": raw["cnf"]["clauses"]}
    if response["request"] != {"operation_id": "sat.cnf.canonicalize",
                               "payload": expected_request}:
        raise ValueError("canonicalizer request is not the replayed scheduling query")
    if response["result"]["operation_id"] != "sat.cnf.canonicalize":
        raise ValueError("wrong canonicalizer operation")
    cnf = response["result"]["output"]["cnf"]
    if cnf["variables"] != raw["cnf"]["variables"]:
        raise ValueError("canonicalizer changed the already sorted variable names")
    if {frozenset(c) for c in cnf["clauses"]} != {
            frozenset(c) for c in raw["cnf"]["clauses"]}:
        raise ValueError("canonicalizer changed the signed clause set")
    return {"cnf": cnf, "timeout_ms": raw["timeout_ms"]}


def bind_solver_output(query, payload, response):
    if response["request"] != {"operation_id": "sat.solve", "payload": payload}:
        raise ValueError("solver request differs from the canonical scheduling payload")
    if response["result"]["operation_id"] != "sat.solve":
        raise ValueError("wrong solver operation")
    output = response["result"]["output"]
    if output["source"] != payload:
        raise ValueError("typed solver source differs from the exact payload")
    if output["outcome"] == "UNKNOWN":
        raise ValueError("UNKNOWN is not a mathematical conclusion")
    if output["outcome"] != query["expected_outcome"]:
        raise ValueError("adapter outcome disagrees with exhaustive scheduling replay")
    if output["outcome"] == "SAT":
        assignment = output["assignment"]
        if len(assignment) != len(payload["cnf"]["variables"]):
            raise ValueError("incomplete SAT assignment")
        if not all(any(assignment[abs(lit) - 1] == (lit > 0) for lit in clause)
                   for clause in payload["cnf"]["clauses"]):
            raise ValueError("SAT assignment violates a clause")
        placement = {}
        for name, value in zip(payload["cnf"]["variables"], assignment):
            if name.startswith("job_") and value:
                parts = name.split("_")
                x, t = int(parts[1]), int(parts[3])
                if x in placement:
                    raise ValueError("job assigned to several slots")
                placement[x] = t
        if set(placement) != set(query["jobs"]):
            raise ValueError("SAT assignment omits jobs")
        if any(list(placement.values()).count(t) != 3
               for t in range(len(query["jobs"]) // 3)):
            raise ValueError("SAT assignment violates full slot capacity")
        if any(placement[x] >= placement[y] for y in query["jobs"]
               for x in query["augmented_predecessors"][y]):
            raise ValueError("SAT assignment violates an original augmented precedence")
    return output["outcome"]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--certificate", type=Path, default=HERE / "finite_certificate.json")
    parser.add_argument("--from-experiment", type=Path)
    parser.add_argument("--example", choices=["best", "i3_example"], default="best")
    parser.add_argument("--write-jacobian-payload", type=Path)
    parser.add_argument("--canonical-output", type=Path)
    parser.add_argument("--jacobian-result", type=Path)
    args = parser.parse_args()
    if args.from_experiment:
        experiment = json.loads(args.from_experiment.read_text())
        if experiment["status"] != "bounded_no_witness":
            raise ValueError("this mode records finite no-witness histories only")
        example = experiment[args.example]
        if example is None:
            raise ValueError(f"experiment has no {args.example} example")
        instance = example["instance"]
        construction, stats = replay(instance)
        certificate = {
            "result_class": "finite_verification",
            "universal_compression_certified": False,
            "manuscript_assertion_refuted": False,
            "scope": "One deterministic root-reachable hierarchy, including all future reorderings in I3 at each of its nodes.",
            "instance": instance, "expected_stats": stats,
            "expected_events": construction.events,
            "i3_query": construction.i3_example,
        }
        args.certificate.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        certificate = json.loads(args.certificate.read_text())
        if certificate["result_class"] != "finite_verification":
            raise ValueError("unsupported certificate classification")
        if certificate["universal_compression_certified"] or certificate["manuscript_assertion_refuted"]:
            raise ValueError("a finite replay cannot carry either universal conclusion")
        construction, stats = replay(certificate["instance"])
        if stats != certificate["expected_stats"]:
            raise ValueError("replayed statistics differ from the certificate")
        if construction.events != certificate["expected_events"]:
            raise ValueError("root-reachable events differ from the certificate")
        if construction.i3_example != certificate["i3_query"]:
            raise ValueError("future-exchange query differs from the certificate")
    jacobian_outcome = None
    if args.write_jacobian_payload or args.jacobian_result:
        if certificate["i3_query"] is None:
            raise ValueError("the certified history has no nonvacuous bounded I3 query")
        if args.canonical_output is None:
            raise ValueError("use the inspected canonicalizer; do not guess CNF ordering")
        response = json.loads(args.canonical_output.read_text())
        payload = bind_canonical_output(certificate["i3_query"], response)
        if args.write_jacobian_payload:
            args.write_jacobian_payload.write_text(json.dumps(payload, indent=2) + "\n")
        if args.jacobian_result:
            jacobian_outcome = bind_solver_output(
                certificate["i3_query"], payload,
                json.loads(args.jacobian_result.read_text()))
    print(json.dumps({
        "status": "verified_finite_history_only",
        "certificate": str(args.certificate),
        "instance_seed": certificate["instance"]["seed"],
        "stats": stats,
        "universal_goal": "open",
        "refutation": None,
        "jacobian_outcome": jacobian_outcome,
    }))


if __name__ == "__main__":
    main()
