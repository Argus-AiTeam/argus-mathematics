"""Deterministic bounded experiments; only an explicit violation is a witness."""

import argparse
import json
import random
from pathlib import Path

from model import Construction, Model, Violation, WorkLimit


def instance(seed, n, density, family):
    rng = random.Random(seed)
    labels = list(range(n))
    rng.shuffle(labels)
    schedule = tuple(sum(1 << x for x in labels[t:t + 3]) for t in range(0, n, 3))
    if family == "scatter":
        edges = [(labels[i], labels[j]) for i in range(n) for j in range(i + 1, n)
                 if i // 3 < j // 3 and rng.random() < density]
    elif family == "local":
        edges = [(labels[i], labels[j]) for i in range(n) for j in range(i + 1, n)
                 if 1 <= j // 3 - i // 3 <= 2 and rng.random() < density]
    elif family == "backbone":
        edges = [(labels[i], labels[i + 3]) for i in range(0, n - 3, 3)]
        edges += [(labels[i], labels[j]) for i in range(n) for j in range(i + 1, n)
                  if 1 <= j // 3 - i // 3 <= 2
                  and (i % 3 or j % 3) and rng.random() < density]
    else:
        raise ValueError("invalid instance family")
    return edges, schedule


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--cases", type=int, default=120)
    parser.add_argument("--start", type=int, default=0)
    parser.add_argument("--sizes", type=int, nargs="+", default=[24, 36, 48, 60])
    parser.add_argument("--work-limit", type=int, default=200000)
    parser.add_argument("--family", choices=["scatter", "local", "backbone"],
                        default="scatter")
    parser.add_argument("--center-order", choices=["rank", "varied"], default="rank")
    parser.add_argument("--centers", choices=["cycle", "first", "last", "balanced", "varied"],
                        default="cycle")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    totals = {"completed": 0, "work_limited": 0, "nodes": 0, "switch_edges": 0,
              "i3_candidates": 0, "switch_carry_switch_nodes": 0,
              "surviving_first_entries": 0, "flattened_first_entries": 0,
              "max_entries": 0, "max_entry_leaves": 0, "max_switches": 0,
              "complex_switch_carry_switch_nodes": 0, "split_formulas": 0}
    best = None
    i3_example = None
    for seed in range(args.start, args.start + args.cases):
        n = args.sizes[seed % len(args.sizes)]
        densities = ([0.025, 0.05, 0.1, 0.2, 0.4] if args.family == "scatter"
                     else [0.12, 0.22, 0.35, 0.5, 0.7])
        density = densities[seed % 5]
        choice = (["balanced", "first", "last"][seed % 3]
                  if args.centers == "cycle" else args.centers)
        edges, schedule = instance(seed, n, density, args.family)
        source = {"n": n, "edges": edges, "schedule": [
            [x for x in range(n) if triple >> x & 1] for triple in schedule],
            "seed": seed, "density": density, "center_choice": choice,
            "family": args.family, "center_order": args.center_order, "center_seed": seed}
        model = Model(n, edges, args.work_limit)
        construction = Construction(model, schedule, choice, args.center_order, seed)
        try:
            stats = construction.run()
        except WorkLimit as error:
            totals["work_limited"] += 1
            print(json.dumps({"seed": seed, "status": "incomplete", "detail": str(error)}),
                  flush=True)
            continue
        except Violation as error:
            result = {"status": "candidate_violation", "assertion": error.assertion,
                      "instance": source, "detail": error.detail, "totals": totals}
            args.output.write_text(json.dumps(result, indent=2) + "\n")
            print(json.dumps({"seed": seed, "status": result["status"],
                              "assertion": error.assertion, "output": str(args.output)}))
            return
        totals["completed"] += 1
        for field in ("nodes", "switch_edges", "i3_candidates", "switch_carry_switch_nodes",
                      "surviving_first_entries", "flattened_first_entries",
                      "complex_switch_carry_switch_nodes", "split_formulas"):
            totals[field] += stats[field]
        for field in ("max_entries", "max_entry_leaves", "max_switches"):
            totals[field] = max(totals[field], stats[field])
        quality = (bool(stats["complex_switch_carry_switch_nodes"]),
                   bool(stats["switch_carry_switch_nodes"]),
                   stats["flattened_first_entries"], stats["max_entry_leaves"],
                   stats["max_switches"],
                   stats["max_depth"])
        if best is None or quality > tuple(best["quality"]):
            best = {"quality": quality, "instance": source, "stats": stats,
                    "events": construction.events}
        if construction.i3_example is not None and (
                i3_example is None
                or len(construction.i3_example["jobs"]) > len(i3_example["query"]["jobs"])):
            i3_example = {"instance": source, "query": construction.i3_example}
        if (seed - args.start + 1) % 10 == 0:
            print(json.dumps({"through_seed": seed, **totals,
                              "best_quality": best["quality"] if best else None}), flush=True)
    result = {"status": "bounded_no_witness", "requested_cases": args.cases,
              "totals": totals, "best": best, "i3_example": i3_example,
              "conclusion": "Finite experiments only; the universal claim remains open."}
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"status": result["status"], **totals, "output": str(args.output)}))


if __name__ == "__main__":
    main()
