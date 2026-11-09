"""Independent exhaustive replay of endpoint cases and cut obstructions."""

import argparse
from collections import Counter
from fractions import Fraction
from itertools import combinations
import json
from pathlib import Path


def adjacency(edges):
    labels = sorted({v for edge in edges for v in edge})
    if labels != list(range(len(labels))):
        raise ValueError("Active labels must be consecutive.")
    matrix = [[0] * len(labels) for _ in labels]
    for u, v in edges:
        if type(u) is not int or type(v) is not int or u == v:
            raise ValueError("Invalid endpoint edge.")
        matrix[u][v] += 1
        matrix[v][u] += 1
    return matrix


def fingerprint(matrix):
    return len(matrix), tuple(sorted(map(sum, matrix)))


def isomorphic(left, right):
    if fingerprint(left) != fingerprint(right):
        return False
    count = len(left)
    degrees_left = list(map(sum, left))
    degrees_right = list(map(sum, right))
    mapping = {}
    used = set()

    def extend():
        if len(mapping) == count:
            return True
        u = max((i for i in range(count) if i not in mapping),
                key=lambda i: (sum(left[i][j] for j in mapping), degrees_left[i]))
        for v in range(count):
            if v in used or degrees_left[u] != degrees_right[v]:
                continue
            if any(left[u][i] != right[v][j] for i, j in mapping.items()):
                continue
            mapping[u] = v
            used.add(v)
            if extend():
                return True
            used.remove(v)
            del mapping[u]
        return False

    return extend()


def endpoint_partitions():
    labels = [0] * 10

    def extend(position, maximum):
        if position == 10:
            yield tuple(labels)
            return
        for label in range(maximum + 2):
            if position % 2 and label == labels[position - 1]:
                continue
            labels[position] = label
            yield from extend(position + 1, max(maximum, label))

    yield from extend(1, 0)


def verify_cover(data):
    if data["scope"] != "complete_endpoint_incidence_graph_cover_only":
        raise ValueError("This is not a sharp global-bound checker.")
    if (data["labels"], data["dimension"]) != (11, 5):
        raise ValueError("Incorrect problem size.")
    buckets = {}
    identifiers = set()
    for case in data["cases"]:
        if case["id"] in identifiers or len(case["edges"]) != 5:
            raise ValueError("Repeated identifier or wrong number of edges.")
        identifiers.add(case["id"])
        matrix = adjacency(case["edges"])
        if (case["active_labels"] != len(matrix)
                or case["isolated_labels"] != 11 - len(matrix)
                or not 2 <= len(matrix) <= 10):
            raise ValueError("Incorrect active or isolated label count.")
        bucket = buckets.setdefault(fingerprint(matrix), [])
        if any(isomorphic(matrix, previous) for _, previous in bucket):
            raise ValueError("Two cases are isomorphic.")
        bucket.append((case["id"], matrix))
    partition_count = 0
    hits = Counter()
    for labels in endpoint_partitions():
        edges = [(labels[k], labels[k + 1]) for k in range(0, 10, 2)]
        matrix = adjacency(edges)
        matches = [case_id for case_id, candidate in buckets.get(fingerprint(matrix), [])
                   if isomorphic(matrix, candidate)]
        if len(matches) != 1:
            raise ValueError(f"Uncovered or multiply covered endpoint partition: {labels}")
        hits[matches[0]] += 1
        partition_count += 1
    if set(hits) != identifiers:
        raise ValueError("An enumerated case is unreachable.")
    if data["global_lower_bound_proved"] is not False:
        raise ValueError("Endpoint coverage alone does not prove a global bound.")
    return {
        "cases": len(identifiers),
        "all_loopless_endpoint_partitions_checked": partition_count,
        "coverage": "complete_up_to_graph_isomorphism",
        "global_lower_bound_proved": False,
    }


def verify_endpoint_relaxation():
    terms = []
    ends = [(2 * j + 1, 2 * j + 2) for j in range(5)]
    for coordinate, pair in enumerate(ends):
        for endpoint in pair:
            terms.append((coordinate, frozenset([endpoint]), Fraction(7, 16)))
            terms.append((coordinate, frozenset([0, endpoint]), Fraction(1, 16)))
    for coordinate, cut, weight in terms:
        a, b = ends[coordinate]
        if weight <= 0 or (a in cut) == (b in cut):
            raise ValueError("Cut does not separate its designated endpoints.")
    values = [
        sum(weight for _, cut, weight in terms if (u in cut) != (v in cut))
        for u, v in combinations(range(11), 2)
    ]
    if values != [1] * 55:
        raise ValueError("Relaxed metric is not exactly equilateral.")
    failures = 0
    for coordinate in range(5):
        a, b = ends[coordinate]
        oriented = [cut if a in cut else frozenset(range(11)) - cut
                    for j, cut, _ in terms if j == coordinate]
        incomparable = [(s, t) for s, t in combinations(oriented, 2)
                        if not s <= t and not t <= s]
        if not incomparable:
            raise ValueError("Expected an incompatible positive cut pair.")
        failures += len(incomparable)
    return {
        "scope": "endpoint_only_cut_relaxation_not_an_l1_5_configuration",
        "exact_relaxed_optimum": "1",
        "exact_pair_distances_checked": len(values),
        "positive_incomparable_cut_pairs": failures,
        "global_lower_bound_proved": False,
    }


def relaxed_cut_family(edges):
    active = len(adjacency(edges))
    terms = []
    if active == 2:
        for bits in range(1 << 9):
            mask = 1 | (bits << 2)
            terms.append((0, mask, 1))
        denominator, optimum = 256, Fraction(2)
    elif active == 3:
        others = list(range(3, 11))
        for endpoint in range(3):
            coordinate = next(j for j, edge in enumerate(edges) if endpoint in edge)
            for size, weight in [(4, 1), (5, 15)]:
                for chosen in combinations(others, size):
                    mask = (1 << endpoint) | sum(1 << v for v in chosen)
                    terms.append((coordinate, mask, weight))
        denominator, optimum = 1470, Fraction(26, 21)
    else:
        base = next((set(group) for group in combinations(range(active), 4)
                     if all(any(v in edge and set(edge) <= set(group) for edge in edges)
                            for v in group)), None)
        if base is None:
            raise ValueError("No four active vertices induce a graph without isolates.")
        others = sorted(set(range(11)) - base)
        for endpoint in sorted(base):
            coordinate = next(j for j, edge in enumerate(edges)
                              if endpoint in edge and set(edge) <= base)
            for bits in range(1 << len(others)):
                mask = (1 << endpoint) | sum(1 << v for k, v in enumerate(others)
                                            if bits & (1 << k))
                terms.append((coordinate, mask, 1))
        denominator, optimum = 256, Fraction(1)
    return terms, denominator, optimum


def cut_distances(terms):
    return [
        sum(weight for _, mask, weight in terms
            if bool(mask & (1 << u)) != bool(mask & (1 << v)))
        for u, v in combinations(range(11), 2)
    ]


def replay_chain(terms, ends):
    positive = [[] for _ in range(5)]
    for coordinate, mask, weight in terms:
        if not 0 <= coordinate < 5 or not 0 < mask < (1 << 11) - 1 or weight < 0:
            raise ValueError("Invalid cut term.")
        if weight == 0:
            continue
        a, b = ends[coordinate]
        if bool(mask & (1 << a)) == bool(mask & (1 << b)):
            raise ValueError("Positive cut does not separate coordinate endpoints.")
        if not mask & (1 << a):
            mask ^= (1 << 11) - 1
        positive[coordinate].append((mask, weight))
    points = [[0] * 5 for _ in range(11)]
    for coordinate, cuts in enumerate(positive):
        for (s, _), (t, _) in combinations(cuts, 2):
            if s & t != s and s & t != t:
                raise ValueError("Positive coordinate cut support is not nested.")
        for label in range(11):
            points[label][coordinate] = sum(weight for mask, weight in cuts
                                            if not mask & (1 << label))
    values = [sum(abs(points[u][j] - points[v][j]) for j in range(5))
              for u, v in combinations(range(11), 2)]
    if values != cut_distances(terms):
        raise ValueError("Recovered line coordinates disagree with cut distances.")
    return points


def terms_from_points(points):
    terms, ends = [], []
    for coordinate in range(5):
        order = sorted(range(11), key=lambda i: (points[i][coordinate], i))
        ends.append((order[0], order[-1]))
        mask = 0
        for u, v in zip(order, order[1:]):
            mask |= 1 << u
            weight = points[v][coordinate] - points[u][coordinate]
            terms.append((coordinate, mask, weight))
    return terms, ends


def verify_relaxation_classification(data):
    counts = Counter()
    excluded = []
    for case in data["cases"]:
        terms, denominator, optimum = relaxed_cut_family(case["edges"])
        for coordinate, mask, weight in terms:
            a, b = case["edges"][coordinate]
            if (weight <= 0
                    or bool(mask & (1 << a)) == bool(mask & (1 << b))):
                raise ValueError("An atom is not in the endpoint-only relaxation.")
        values = cut_distances(terms)
        if min(values) != denominator or Fraction(max(values), denominator) != optimum:
            raise ValueError("Incorrect exact relaxed primal attainment.")
        active = case["active_labels"]
        counts["two" if active == 2 else "three" if active == 3 else "at_least_four"] += 1
        if optimum > Fraction(115, 106):
            excluded.append(case["id"])
        if active == 3:
            if any((h - 4) * (h - 5) < 0 for h in range(9)):
                raise ValueError("The integer cut inequality failed.")
        try:
            replay_chain(terms, case["edges"])
        except ValueError as error:
            if str(error) != "Positive coordinate cut support is not nested.":
                raise
        else:
            raise ValueError("A relaxed primal was unexpectedly a five-line embedding.")
    return {
        "case_counts_by_active_endpoint_labels": dict(counts),
        "exact_relaxed_optima": {
            "two": "2",
            "three": "26/21",
            "at_least_four": "1",
        },
        "all_66_exact_relaxed_primal_metrics_checked": True,
        "endpoint_cases_excluded_above_current_upper_bound": excluded,
        "remaining_endpoint_cases": len(data["cases"]) - len(excluded),
        "strict_distortion_gap_from_live_endpoint_relaxations": False,
    }


def verify_chain_recovery(configuration):
    points = configuration["integer_points"]
    if len(points) != 11 or any(len(point) != 5 for point in points):
        raise ValueError("Wrong witness shape.")
    terms, ends = terms_from_points(points)
    replay_chain(terms, ends)
    original = [sum(abs(points[u][j] - points[v][j]) for j in range(5))
                for u, v in combinations(range(11), 2)]
    if original != cut_distances(terms):
        raise ValueError("Witness conversion changed the metric.")
    tied = [[i // 3, i % 3, 0, (i // 2) % 2, 0] for i in range(11)]
    tied_terms, tied_ends = terms_from_points(tied)
    tied_terms.append((2, 5, 0))
    replay_chain(tied_terms, tied_ends)
    return {
        "witness_pairs_reconstructed": len(original),
        "witness_positive_cuts": sum(weight > 0 for _, _, weight in terms),
        "constant_coordinates_and_zero_weight_incomparable_cuts": "accepted",
        "positive_incompatible_relaxation_supports": "rejected_in_all_66_cases",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cover", type=Path)
    parser.add_argument("--configuration", type=Path, required=True)
    args = parser.parse_args()
    data = json.loads(args.cover.read_text())
    result = {
        "endpoint_cover": verify_cover(data),
        "endpoint_relaxation_obstruction": verify_endpoint_relaxation(),
        "complete_endpoint_relaxation_classification": verify_relaxation_classification(data),
        "chain_recovery": verify_chain_recovery(json.loads(args.configuration.read_text())),
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
