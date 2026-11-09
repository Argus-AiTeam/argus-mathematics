#!/usr/bin/env python3
"""Reconstruct exposed-path conditional laws from all fair switch-coin atoms."""

import argparse
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from fractions import Fraction
from itertools import combinations
import json
from math import prod
from pathlib import Path


HERE = Path(__file__).resolve().parent
ZERO = Fraction(0)


@dataclass
class Node:
    count: int = 0
    tags: Counter = field(default_factory=Counter)
    common_one: int = 0
    any_one: int = 0
    free: frozenset = frozenset()
    w: tuple = ()
    energy: Fraction = ZERO
    loss: Fraction = ZERO


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def edges(d, direction):
    bit = 1 << direction
    return tuple((x, x ^ bit) for x in range(1 << d) if not x & bit)


def simulate(d, word, coins):
    n = 1 << d
    positions = tuple(range(n))
    path = [positions]
    for r, direction in enumerate(word):
        switch = list(range(n))
        for j, (x, y) in enumerate(edges(d, direction)):
            if (coins >> (r * (n // 2) + j)) & 1:
                switch[x], switch[y] = y, x
        positions = tuple(switch[x] for x in positions)
        path.append(positions)
    return tuple(path)


def average(vector, direction):
    bit = 1 << direction
    return tuple((value + vector[x ^ bit]) / 2 for x, value in enumerate(vector))


def projected(vector, directions):
    for direction in sorted(directions):
        vector = average(vector, direction)
    return vector


def norm2(vector):
    return sum((value * value for value in vector), ZERO)


def cylinder(d, word, prefix):
    mask = value = 0
    n = 1 << d
    for r in range(len(prefix) - 1):
        edge_numbers = {x: j for j, edge in enumerate(edges(d, word[r])) for x in edge}
        for before, after in zip(prefix[r], prefix[r + 1]):
            require(after in (before, before ^ (1 << word[r])), "Illegal exposed step")
            bit = 1 << (r * (n // 2) + edge_numbers[before])
            wanted = bit if after != before else 0
            require(not mask & bit or value & bit == wanted, "Inconsistent exposed pair")
            mask |= bit
            value |= wanted
    return mask, value


def case_laws(d, word, exposed, tagged):
    n, horizon = 1 << d, len(word)
    total_bits = horizon * (n // 2)
    atom_count = 1 << total_bits
    total_mask = atom_count - 1
    nodes = [dict() for _ in range(horizon + 1)]
    smoothed = {}
    for coins in range(atom_count):
        path = simulate(d, word, coins)
        exposed_path = tuple(tuple(state[label] for label in exposed) for state in path)
        for t in range(horizon + 1):
            prefix = exposed_path[: t + 1]
            if prefix not in nodes[t]:
                nodes[t][prefix] = Node(common_one=total_mask)
            node = nodes[t][prefix]
            node.count += 1
            node.tags[path[t][tagged]] += 1
            node.common_one &= coins
            node.any_one |= coins
        if exposed_path not in smoothed:
            smoothed[exposed_path] = [Counter() for _ in range(horizon + 1)]
        for t in range(horizon + 1):
            smoothed[exposed_path][t][path[t][tagged]] += 1

    m = n - len(exposed)
    for t, layer in enumerate(nodes):
        for prefix, node in layer.items():
            mask, value = cylinder(d, word, prefix)
            require(node.count == 1 << (total_bits - mask.bit_count()), "Not a cylinder")
            require(node.common_one == value, "Incorrect fixed-one coins")
            require(node.any_one == value | (total_mask ^ mask), "Incorrect free coins")
            node.free = frozenset(range(n)).difference(prefix[-1])
            require(len(node.free) == m, "Exposed labels collided")
            require(set(node.tags).issubset(node.free), "Tagged label collided")
            node.w = tuple(
                Fraction(node.tags[x], node.count) - (Fraction(1, m) if x in node.free else 0)
                for x in range(n)
            )
            require(sum(node.w) == 0, "Flow is not centered")
            node.energy = norm2(node.w)
            require(node.energy <= 1, "Flow energy exceeds one")
            if t < horizon:
                bit = 1 << word[t]
                node.loss = sum(
                    (node.w[x] ** 2 for x in node.free if x ^ bit not in node.free), ZERO
                )

    smoothing_checks = 0
    for full_prefix, counts in smoothed.items():
        full_count = nodes[horizon][full_prefix].count
        for t in range(horizon + 1):
            prefix_node = nodes[t][full_prefix[: t + 1]]
            for x in range(n):
                require(
                    counts[t][x] * prefix_node.count == prefix_node.tags[x] * full_count,
                    "Future exposed paths changed the tagged law",
                )
                smoothing_checks += 1
    return nodes, atom_count, smoothing_checks


def check_updates(d, word, nodes):
    n = 1 << d
    checked = 0
    for r, direction in enumerate(word):
        children = defaultdict(list)
        for prefix, child in nodes[r + 1].items():
            children[prefix[:-1]].append((prefix, child))
        for prefix, parent in nodes[r].items():
            one_free = [
                (x, y) for x, y in edges(d, direction)
                if (x in parent.free) != (y in parent.free)
            ]
            signs = Counter()
            centered_sum = [ZERO] * n
            for child_prefix, child in children[prefix]:
                moves = dict(zip(prefix[-1], child_prefix[-1]))
                expected = [ZERO] * n
                edge_signs = []
                for x, y in edges(d, direction):
                    if x in parent.free and y in parent.free:
                        expected[x] = expected[y] = (parent.w[x] + parent.w[y]) / 2
                    elif (x in parent.free) != (y in parent.free):
                        free, occupied = (x, y) if x in parent.free else (y, x)
                        stays = moves[occupied] == occupied
                        expected[free if stays else occupied] = parent.w[free]
                        edge_signs.append(1 if stays else -1)
                require(tuple(expected) == child.w, "Averaging/transport law failed")
                signs[tuple(edge_signs)] += child.count
                baseline = average(parent.w, direction)
                noise = tuple(child.w[x] - baseline[x] for x in range(n))
                for x in range(n):
                    centered_sum[x] += child.count * noise[x]
            require(all(value == 0 for value in centered_sum), "Noise mean is not zero")
            require(len(signs) == 1 << len(one_free), "Missing independent sign outcome")
            require(
                all(count * (1 << len(one_free)) == parent.count for count in signs.values()),
                "One-free signs are not conditionally independent and fair",
            )
            checked += 1
    return checked


def conditional_sum(nodes, earlier, later, value):
    totals = defaultdict(Fraction)
    for prefix, node in nodes[later].items():
        totals[prefix[: earlier + 1]] += node.count * value(node)
    return totals


def check_energy(d, word, nodes):
    checked = 0
    for a in range(len(word) + 1):
        for t in range(a, len(word) + 1):
            lhs = conditional_sum(nodes, a, t, lambda node: node.energy)
            losses = {
                r: conditional_sum(nodes, a, r, lambda node: node.loss)
                for r in range(a, t)
            }
            directions = set(word[a:t])
            for prefix, base in nodes[a].items():
                rhs = base.count * norm2(projected(base.w, directions))
                for r in range(a, t):
                    following = set(word[r + 1:t])
                    if word[r] not in following:
                        rhs += losses[r][prefix] / (1 << (len(following) + 1))
                require(lhs[prefix] == rhs, "General last-occurrence energy identity failed")
                if a == t - d and word == tuple(r % d for r in range(len(word))):
                    cyclic_rhs = sum(
                        (losses[t - j][prefix] / (1 << j) for j in range(1, d + 1)), ZERO
                    )
                    require(lhs[prefix] == cyclic_rhs, "Literal one-sweep identity failed")
                checked += 1
    return checked


def components(d, directions):
    active = sum(1 << direction for direction in directions)
    result = defaultdict(list)
    for x in range(1 << d):
        result[x & ~active].append(x)
    return tuple(tuple(vertices) for vertices in result.values())


def check_components(d, word, nodes):
    checked = 0
    for a in range(len(word) + 1):
        for s in range(a, len(word) + 1):
            pieces = components(d, set(word[a:s]))
            joint = defaultdict(Counter)
            marginals = {}
            availability = defaultdict(Counter)
            for prefix, node in nodes[s].items():
                past = prefix[: a + 1]
                if past not in marginals:
                    marginals[past] = [Counter() for _ in pieces]
                states = tuple(
                    (tuple(x in node.free for x in piece), tuple(node.w[x] for x in piece))
                    for piece in pieces
                )
                joint[past][states] += node.count
                for j, state in enumerate(states):
                    marginals[past][j][state] += node.count
                for x in node.free:
                    availability[past][x] += node.count
            for prefix, base in nodes[a].items():
                require(
                    len(joint[prefix]) == prod(len(counter) for counter in marginals[prefix]),
                    "Component joint support does not factor",
                )
                for states, count in joint[prefix].items():
                    require(
                        count * base.count ** (len(pieces) - 1)
                        == prod(marginals[prefix][j][state] for j, state in enumerate(states)),
                        "Full component conditional law does not factor",
                    )
                for piece in pieces:
                    initial_free = len(base.free.intersection(piece))
                    for y in piece:
                        require(
                            availability[prefix][y] * len(piece) == initial_free * base.count,
                            "Component availability is not the initial density",
                        )
                checked += 1
    return checked


def check_halves(d, word, nodes):
    if word != tuple(r % d for r in range(len(word))):
        return 0, None
    checked, example = 0, None
    for s in range(d - 1, len(word) + 1):
        a = s - d + 1
        bit = 1 << (s % d)
        mixed = defaultdict(lambda: [ZERO, ZERO])
        energies = defaultdict(lambda: [ZERO, ZERO])
        for prefix, node in nodes[s].items():
            past = prefix[: a + 1]
            for x, value in enumerate(node.w):
                h = int(bool(x & bit))
                energies[past][h] += node.count * value ** 2
                if x ^ bit in node.free:
                    mixed[past][h] += node.count * value ** 2
        for prefix, base in nodes[a].items():
            for h in range(2):
                opposite = sum(int(bool(x & bit)) != h for x in base.free)
                require(
                    mixed[prefix][h] * (1 << (d - 1))
                    == opposite * energies[prefix][h],
                    "Literal opposite-half conditional identity failed",
                )
                density = Fraction(opposite, 1 << (d - 1))
                if example is None and a > 0 and 0 < density < 1 and energies[prefix][h] > 0:
                    example = {
                        "a": a, "s": s, "half": h,
                        "exposed_prefix": prefix,
                        "opposite_density": str(density),
                        "conditional_half_energy": str(energies[prefix][h] / base.count),
                        "conditional_mixed_energy": str(mixed[prefix][h] / base.count),
                    }
                checked += 1
    return checked, example


def all_small_cases(d, word):
    for tagged in range(1 << d):
        others = [label for label in range(1 << d) if label != tagged]
        for ell in range(len(others) + 1):
            for exposed in combinations(others, ell):
                yield d, word, exposed, tagged


def cases():
    yield from all_small_cases(1, (0, 0, 0))
    yield from all_small_cases(2, (0, 1, 0, 1))
    for ell in range(8):
        yield 3, (0, 1, 2), tuple(range(1, ell + 1)), 0
    yield 3, (0, 1, 2), (1, 3, 6), 0
    yield 3, (0, 1, 2, 0), (1, 2, 5), 0
    yield from all_small_cases(2, (0, 0, 1))
    yield 3, (2, 0, 2), (1, 3, 7), 0
    yield 3, (2, 0, 2), (2, 5), 6


def certificate():
    results = []
    totals = Counter()
    example = None
    for d, word, exposed, tagged in cases():
        nodes, atoms, smoothing = case_laws(d, word, exposed, tagged)
        counts = {
            "coin_atoms": atoms,
            "path_cylinders": sum(len(layer) for layer in nodes),
            "smoothing_coordinate_equalities": smoothing,
            "conditionally_centered_updates": check_updates(d, word, nodes),
            "conditional_energy_atoms": check_energy(d, word, nodes),
            "conditional_component_atoms": check_components(d, word, nodes),
        }
        counts["conditional_half_atoms"], local_example = check_halves(d, word, nodes)
        totals.update(counts)
        if example is None and local_example is not None:
            example = {"d": d, "exposed_labels": exposed, "tagged_label": tagged, **local_example}
        results.append({
            "d": d, "coordinate_word_zero_based": word,
            "exposed_labels": exposed, "tagged_label": tagged,
            "counts": counts,
            "E": [
                str(sum((node.count * node.energy for node in layer.values()), ZERO) / atoms)
                for layer in nodes
            ],
            "b": [
                str(sum((node.count * node.loss for node in nodes[r].values()), ZERO) / atoms)
                for r in range(len(word))
            ],
        })
    return {
        "result_class": "parameter_uniform_verification_with_finite_replay",
        "audited_assertions": ["lem:path-cylinder", "eq:h-2", "eq:h-3"],
        "finite_replay_is_not_a_universal_proof": True,
        "universal_proof": "report.md",
        "formal_core": "Main.lean",
        "statement_fidelity": "statement_fidelity.md",
        "campaign_goal_closed": False,
        "independent_review": "pending",
        "novelty_status": "not_assessed",
        "conditional_laws_reconstructed_from": "Uniform full switch-coin atoms and actual labeled permutations; not the flow recursion.",
        "case_count": len(results),
        "totals": dict(totals),
        "nontrivial_conditional_half_example": example,
        "cases": results,
    }


def prepare_jacobian():
    d, word, exposed, tagged = 2, (0, 1), (1,), 0
    histories = [simulate(d, word, coins) for coins in range(16)]
    observations = [
        [
            json.dumps([tuple(state[label] for label in exposed) for state in path[: s + 1]])
            for path in histories
        ]
        for s in range(3)
    ]
    payoffs = [int(path[-1][tagged] == 0) for path in histories]
    payload = {
        "space": {
            "samples": [f"coins_{coins:02d}" for coins in range(16)],
            "masses": [{"num": "1", "den": "16"} for _ in histories],
        },
        "observations": observations,
        "payoff": [{"num": str(value), "den": "1"} for value in payoffs],
    }
    expected = []
    for row in observations:
        grouped = defaultdict(list)
        for observation, payoff in zip(row, payoffs):
            grouped[observation].append(payoff)
        expected.append([
            {
                "num": str(Fraction(sum(grouped[observation]), len(grouped[observation])).numerator),
                "den": str(Fraction(sum(grouped[observation]), len(grouped[observation])).denominator),
            }
            for observation in row
        ])
    (HERE / "jacobian/payload.json").write_text(json.dumps(payload, indent=2) + "\n")
    (HERE / "jacobian/expected.json").write_text(
        json.dumps({"martingale": expected}, indent=2) + "\n"
    )
    print("Prepared the exact 16-atom Doob conditional-expectation diagnostic.")


def check_jacobian():
    directory = HERE / "jacobian"
    payload = json.loads((directory / "payload.json").read_text())
    expected = json.loads((directory / "expected.json").read_text())
    output = json.loads((directory / "output.json").read_text())
    inspection = json.loads((directory / "inspection.json").read_text())
    status = json.loads((directory / "status.json").read_text())
    operation = "probability.process.doob_martingale.compute"
    require(status["adapter_exit_code"] == 0 and not status["timed_out"], "Adapter did not finish")
    require(output["server"] == inspection["server"], "Jacobian server identity changed")
    require(output["protocol_version"] == inspection["protocol_version"], "Protocol changed")
    require(output["tool"] == "math.run", "Not an operation execution")
    require(output["request"] == {"operation_id": operation, "payload": payload}, "Payload changed")
    require(output["result"]["operation_id"] == operation, "Wrong executed operation")
    require(output["result"]["output"] == expected, "Jacobian conditional expectations differ")
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--prepare-jacobian", action="store_true")
    parser.add_argument("--check-jacobian", action="store_true")
    args = parser.parse_args()
    if args.prepare_jacobian:
        prepare_jacobian()
        return
    jacobian_matches = check_jacobian()
    if args.check_jacobian:
        print(json.dumps({"jacobian_matches_exact_conditional_law": jacobian_matches}))
        return
    actual = json.loads(json.dumps(certificate()))
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2) + "\n")
    else:
        require(actual == json.loads(path.read_text()), "Stored certificate differs from replay")
    print(json.dumps({
        "ok": True, "case_count": actual["case_count"], **actual["totals"],
        "jacobian_matches_exact_conditional_law": jacobian_matches,
    }))


if __name__ == "__main__":
    main()
