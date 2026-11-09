"""Exact sparse branch bounds and positive multistage solving templates."""

import argparse
from collections import Counter, defaultdict
from itertools import combinations
import json
from pathlib import Path
import time

from fan_bound import cases
from fiber_discharge import fiber_solution, shifted_fiber_solution
from multistage import resource_demand, trim_to_root
from pebbling import (
    ADJ, DIST, EDGES, INDEX, fan_solution, product_automorphisms, replay,
)


AUTOMORPHISMS = product_automorphisms()


class CoverageLimit(Exception):
    pass


class DischargeCover:
    def __init__(self, root, heavy, templates, max_nodes, discover=False,
                 checkpoint=None):
        self.root = root
        self.heavy = heavy
        self.templates = templates
        self.max_nodes = max_nodes
        self.discover = discover
        self.checkpoint = checkpoint
        self.template_index = defaultdict(list)
        for template in templates:
            if template["root"] == root:
                sparse = template["sparse_demand"]
                self.template_index[tuple(v for v, _ in sparse)].append(sparse)
        self.stats = Counter()
        self.uncovered = None
        self.discovery_error = None
        self.thresholds = [1 << DIST[u][root] for u in range(64)]
        self.fans = []
        for b in range(64):
            if DIST[heavy][b] == 2:
                children = set(ADJ[heavy]) & set(ADJ[b])
                self.fans.append((b, children, {heavy, b, *children}))

    def caps(self, selected, maximum):
        counts = dict(selected)
        gather = [sum(n >> DIST[v][u] for v, n in selected)
                  for u in range(64)]
        if any(n >= t for n, t in zip(gather, self.thresholds)):
            self.stats["gathering_families"] += 1
            return None
        heavy_count = counts[self.heavy]
        fan_data = []
        for b, children, used in self.fans:
            numerator = heavy_count + 2 * sum(counts.get(w, 0)
                                             for w in children)
            outside = counts.get(b, 0) + sum(
                n >> DIST[v][b] for v, n in selected if v not in used)
            if numerator // 4 + outside >= self.thresholds[b]:
                self.stats["fan_families"] += 1
                return None
            fan_data.append((b, children, numerator, outside))
        caps = []
        last_aux = selected[-1][0] if len(selected) > 1 else -1
        for v in range(64):
            if v in counts:
                caps.append(0)
                continue
            cap = min(maximum, self.thresholds[v] - 1)
            if last_aux >= 0 and v < last_aux:
                cap = min(cap, maximum - 1)
            for u, contribution in enumerate(gather):
                cap = min(cap, ((self.thresholds[u] - contribution)
                                << DIST[v][u]) - 1)
                if cap == 0:
                    break
            if cap:
                for b, children, numerator, outside in fan_data:
                    if v in children:
                        bound = (4 * (self.thresholds[b] - outside)
                                 - 1 - numerator) // 2
                    elif v == b:
                        bound = self.thresholds[b] - 1 - numerator // 4 - outside
                    else:
                        bound = ((self.thresholds[b] - numerator // 4 - outside)
                                 << DIST[v][b]) - 1
                    cap = min(cap, bound)
                    if cap == 0:
                        break
            if cap < 0:
                raise ValueError("A nonnegative partial state got a negative cap")
            caps.append(cap)
        for families in self.template_index.values():
            for demand in families:
                missing = []
                for v, n in demand:
                    if v in counts:
                        if counts[v] < n:
                            break
                    else:
                        missing.append((v, n))
                else:
                    if not missing:
                        self.stats["multistage_families"] += 1
                        return None
                    if len(missing) == 1:
                        v, n = missing[0]
                        caps[v] = min(caps[v], n - 1)
        return caps

    def covered_by_template(self, selected):
        c = dict(selected)
        support = sorted(c)
        for size in range(1, len(support) + 1):
            for subset in combinations(support, size):
                for demand in self.template_index.get(subset, ()):
                    if all(c[v] >= n for v, n in demand):
                        return True
        return False

    def add_template_orbit(self, moves):
        moves = trim_to_root(moves, self.root)
        demand = resource_demand(moves, self.root)
        for image in AUTOMORPHISMS:
            if image[self.root] != self.root:
                continue
            sparse = sorted((image[v], n) for v, n in enumerate(demand) if n)
            if self.covered_by_template(sparse):
                continue
            transformed = [(image[v], image[w], n) for v, w, n in moves]
            transformed_demand = resource_demand(transformed, self.root)
            template = {
                "root": self.root, "demand": transformed_demand,
                "moves": transformed,
                "sparse_demand": [[v, n] for v, n in sparse],
            }
            self.templates.append(template)
            self.template_index[tuple(v for v, _ in sparse)].append(sparse)
            self.stats["new_multistage_templates"] += 1
        if self.checkpoint is not None:
            self.checkpoint()

    def visit(self, selected):
        self.stats["nodes"] += 1
        if self.stats["nodes"] > self.max_nodes:
            raise CoverageLimit("The configured exact-search node limit was reached")
        if self.covered_by_template(selected):
            self.stats["multistage_families"] += 1
            return True
        caps = self.caps(selected, selected[-1][1])
        if caps is None:
            return True
        total = sum(n for _, n in selected)
        slots = 5 - len(selected)
        if total < 64 and (
                not slots or total + sum(sorted(caps, reverse=True)[:slots]) < 64):
            self.stats["strict_total_bounds"] += 1
            return True
        c = [0] * 64
        for v, n in selected:
            c[v] = n
        moves = fiber_solution(c, self.root)
        if moves is None:
            moves = shifted_fiber_solution(c, self.root, self.heavy)
        if moves is None and total == 64:
            moves = fan_solution(c, self.root)
        if moves is not None:
            self.stats["structural_multistage_families"] += 1
            if self.discover:
                self.add_template_orbit(moves)
            return True
        if total == 64:
            if not self.discover:
                self.uncovered = c
                return False
            from solve_configuration import NoPositiveCertificate, find_solution

            try:
                moves, report = find_solution(
                    c, self.root, seconds=10, greedy=True, optimize_moves=False)
            except NoPositiveCertificate as error:
                self.uncovered = c
                self.discovery_error = error.report
                return False
            self.stats["positive_discovery_calls"] += 1
            self.stats["positive_discovery_milliseconds"] += int(
                1000 * report["elapsed_seconds"])
            replay(c, self.root, moves)
            self.add_template_orbit(moves)
            return True
        minimum = (64 - total + slots - 1) // slots
        for v, cap in enumerate(caps):
            if cap < minimum:
                continue
            others = sorted(caps[:v] + caps[v + 1:], reverse=True)
            lower = max(minimum, 64 - total - sum(others[:slots - 1]))
            upper = min(cap, 64 - total)
            for n in range(upper, lower - 1, -1):
                if not self.visit(selected + [(v, n)]):
                    return False
        self.stats["exhaustive_next_pile_branches"] += 1
        return True


def validate_templates(templates):
    for template in templates:
        demand = resource_demand(template["moves"], template["root"])
        if template["demand"] != demand or template["sparse_demand"] != [
                [v, n] for v, n in enumerate(demand) if n]:
            raise ValueError("A template has an incorrect prefix-resource demand")


def run(args):
    path = Path(args.certificate)
    if path.exists():
        data = json.loads(path.read_text())
        if (data["kind"] != "integral_sparse_multistage_discharge_cover"
                or data["edges"] != [list(e) for e in EDGES]):
            raise ValueError("The existing cover is for a different problem")
    else:
        if args.command == "check":
            raise ValueError("The coverage certificate does not exist")
        seed = json.loads(Path(__file__).with_name(
            "multistage_template.json").read_text())
        seed["sparse_demand"] = [[v, n] for v, n in enumerate(seed["demand"]) if n]
        data = {
            "kind": "integral_sparse_multistage_discharge_cover",
            "edges": [list(e) for e in EDGES],
            "templates": [seed], "covered_heavy_counts": [],
        }
    validate_templates(data["templates"])
    expected = [(r, a, h) for r, a in cases() if DIST[r][a] >= 5
                for h in range(13, 1 << DIST[r][a])]
    targets = expected
    if args.root is not None:
        r = INDEX[tuple(args.root)]
        targets = [case for case in targets if case[0] == r]
    if args.heavy is not None:
        a = INDEX[tuple(args.heavy)]
        targets = [case for case in targets if case[1] == a]
    if args.count is not None:
        targets = [case for case in targets if case[2] == args.count]
    if not targets:
        raise ValueError("The requested rooted-pair/count range is empty")
    recorded = {tuple(c) for c in data["covered_heavy_counts"]}
    if (len(recorded) != len(data["covered_heavy_counts"])
            or not recorded <= set(expected)):
        raise ValueError("Unexpected or duplicate covered rooted-pair/count")
    start = time.perf_counter()
    stats = Counter()
    uncovered = None
    state = "partial"
    checked_this_run = 0

    def save():
        data["covered_heavy_counts"] = sorted(recorded)
        path.write_text(json.dumps(data, separators=(",", ":")) + "\n")

    try:
        for root, heavy, count in targets:
            if args.command == "generate" and (root, heavy, count) in recorded:
                continue
            engine = DischargeCover(root, heavy, data["templates"],
                                    args.max_nodes, args.command == "generate",
                                    save if args.command == "generate" else None)
            if not engine.visit([(heavy, count)]):
                uncovered = {
                    "root": root, "heavy": heavy, "count": count,
                    "configuration": engine.uncovered,
                }
                if engine.discovery_error is not None:
                    uncovered["discovery_error"] = engine.discovery_error
                stats.update(engine.stats)
                state = ("positive_discovery_inconclusive"
                         if engine.discovery_error is not None
                         else "uncovered_by_this_certificate")
                break
            stats.update(engine.stats)
            recorded.add((root, heavy, count))
            checked_this_run += 1
            if args.command == "generate":
                save()
        else:
            state = ("covered_requested_range" if len(targets) < len(expected)
                     else "covered_all_distance_five_six_cases")
    except CoverageLimit as error:
        stats.update(engine.stats)
        state = "node_limit"
        uncovered = {"root": root, "heavy": heavy, "count": count,
                     "reason": str(error)}
    if args.command == "generate":
        save()
    universal = False
    distance_four_orbits = 0
    if (args.command == "check"
            and state == "covered_all_distance_five_six_cases"):
        from distance_four import check as check_distance_four

        result = check_distance_four(
            Path(__file__).with_name("distance_four_cover.json"), emit=False)
        distance_four_orbits = result["root_heavy_orbits_covered"]
        universal = True
    report = {
        "state": state,
        "elapsed_seconds": time.perf_counter() - start,
        "requested_heavy_counts": len(targets),
        "recorded_covered_heavy_counts": len(recorded),
        "checked_this_run": checked_this_run,
        "required_distance_five_six_heavy_counts": len(expected),
        "templates": len(data["templates"]),
        "statistics": dict(stats),
        "uncovered": uncovered,
        "distance_four_orbits_covered": distance_four_orbits,
        "root_heavy_orbits_covered": (
            len(cases()) if universal else None),
        "universal_support_five_coverage": universal,
        "independent_review_completed": False,
    }
    print(json.dumps(report, indent=2))
    return report


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("generate", "check", "probe"))
    parser.add_argument("certificate")
    parser.add_argument("--root", type=int, nargs=2)
    parser.add_argument("--heavy", type=int, nargs=2)
    parser.add_argument("--count", type=int)
    parser.add_argument("--max-nodes", type=int, default=100000)
    arguments = parser.parse_args()
    result = run(arguments)
    if arguments.command != "probe" and not result["state"].startswith("covered_"):
        raise SystemExit(1)
