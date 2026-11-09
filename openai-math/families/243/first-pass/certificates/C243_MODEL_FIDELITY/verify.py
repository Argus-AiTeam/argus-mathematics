#!/usr/bin/env python3
"""Replay exact supporting checks, not the universal separation theorem."""

import argparse
import itertools
import json
import math
from dataclasses import dataclass
from pathlib import Path


HERE = Path(__file__).resolve().parent


@dataclass(frozen=True)
class Atom:
    value: int


def op(a, b):
    return frozenset((frozenset((a,)), frozenset((a, b))))


def ordinal(n):
    result = frozenset()
    for _ in range(n):
        result = result | frozenset((result,))
    return result


def relations(n):
    pairs = tuple(itertools.product(range(n), repeat=2))
    for mask in range(1 << len(pairs)):
        yield frozenset(p for i, p in enumerate(pairs) if mask & (1 << i))


def generated(n, relation):
    reach = set(relation) | {(b, a) for a, b in relation}
    reach |= {(a, a) for a in range(n)}
    for k in range(n):
        reach |= {(a, b) for a in range(n) for b in range(n)
                  if (a, k) in reach and (k, b) in reach}
    return frozenset(reach)


def bounded_reach(n, relation):
    links = set(relation) | {(b, a) for a, b in relation}
    links |= {(a, a) for a in range(n)}
    reach = set(links)
    for _ in range(n):
        reach |= {(a, c) for a, b in reach for d, c in links if b == d}
    return frozenset(reach)


def components(n, relation):
    remaining = set(range(n))
    result = []
    while remaining:
        seen = {min(remaining)}
        frontier = set(seen)
        while frontier:
            following = {b for a, b in relation if a in frontier}
            following |= {a for a, b in relation if b in frontier}
            frontier = following - seen
            seen |= frontier
        result.append(frozenset(seen))
        remaining -= seen
    return result


def coding_checks():
    pool = (Atom(0), Atom(1), ordinal(0), ordinal(1), ordinal(2),
            frozenset((Atom(0),)), frozenset((Atom(0), Atom(1))))
    pairs = {(a, b): op(a, b) for a in pool for b in pool}
    assert len(set(pairs.values())) == len(pairs)
    relation_count = 0
    saturation_basis_count = 0
    relabeling_count = 0
    hartig_count = 0
    for n in range(4):
        for relation in relations(n):
            relation_count += 1
            reach = generated(n, relation)
            assert reach == bounded_reach(n, relation)
            classes = components(n, relation)
            code = {
                block: op(ordinal(1),
                          frozenset(op(Atom(a), Atom(a)) for a in block))
                for block in classes
            }
            assert len(set(code.values())) == len(classes)
            assert reach == frozenset((a, b) for block in classes
                                      for a in block for b in block)
            for singleton in (frozenset(), *(frozenset((p,))
                                              for p in itertools.product(range(n), repeat=2))):
                by_representatives = {
                    (code[left], code[right])
                    for left in classes for right in classes
                    if any((a, b) in singleton for a in left for b in right)
                }
                by_image = {
                    (code[next(block for block in classes if a in block)],
                     code[next(block for block in classes if b in block)])
                    for a, b in singleton
                }
                assert by_representatives == by_image
                saturation_basis_count += 1
            for permutation in itertools.permutations(range(n)):
                moved = frozenset((permutation[a], permutation[b]) for a, b in relation)
                moved_reach = frozenset((permutation[a], permutation[b]) for a, b in reach)
                assert generated(n, moved) == moved_reach
                relabeling_count += 1
        subsets = [frozenset(i for i in range(n) if mask & (1 << i))
                   for mask in range(1 << n)]
        for left, right in itertools.product(subsets, repeat=2):
            direct = len(left) == len(right)
            translated = any(len(left) == k and len(right) == k
                             for k in range(max(2, n) + 1))
            assert direct == translated
            assert (ordinal(len(left)) == ordinal(len(right))) == direct
            hartig_count += 1
    return {
        "mixed_pool_ordered_pairs": len(pairs),
        "all_identification_relations_domain_sizes_0_through_3": relation_count,
        "empty_and_singleton_relation_saturation_checks": saturation_basis_count,
        "identification_relation_relabelings": relabeling_count,
        "bounded_hartig_comparisons": hartig_count,
    }


def heisenberg_checks():
    elements = tuple(itertools.product(range(3), repeat=3))

    def product(a, b, sign):
        x, y, z = a
        u, v, w = b
        return ((x + u) % 3, (y + v) % 3,
                (z + w + 2 * sign * (x * v - y * u)) % 3)

    def inverse(a):
        return tuple(-x % 3 for x in a)

    associativity_count = 0
    commutator_count = 0
    for sign in (-1, 1):
        for a in elements:
            assert product(a, inverse(a), sign) == (0, 0, 0)
            for b in elements:
                commutator = product(product(product(a, b, sign), inverse(a), sign),
                                     inverse(b), sign)
                assert commutator == (0, 0, sign * (a[0] * b[1] - a[1] * b[0]) % 3)
                commutator_count += 1
                for c in elements:
                    assert product(product(a, b, sign), c, sign) == product(a, product(b, c, sign), sign)
                    associativity_count += 1

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    expected_generators = [
        [elements.index(product(g, a, 1)) for a in elements]
        for g in ((1, 0, 0), (0, 1, 0))
    ]
    assert payload == {"group": {"degree": 27, "generators": expected_generators}, "point": 0}
    orbit = {0}
    while True:
        following = orbit | {g[a] for g in expected_generators for a in orbit}
        if following == orbit:
            break
        orbit = following
    assert orbit == set(range(27))
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    assert status == {"operation_id": "group.orbit.compute", "exit_code": 0, "timeout": False}
    output = json.loads((HERE / "jacobian_output.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    assert output["protocol_version"] == contract["protocol_version"]
    assert output["server"]["name"] == contract["server"]["name"]
    assert output["server"]["version"] == contract["server"]["version"]
    assert output["request"] == {"operation_id": "group.orbit.compute", "payload": payload}
    assert output["result"]["operation_id"] == "group.orbit.compute"
    assert output["result"]["output"] == {"orbit": list(range(27)), "point": 0}
    return {
        "group_elements_per_sign": 27,
        "signs": [-1, 1],
        "associativity_triples": associativity_count,
        "commutator_pairs": commutator_count,
        "independently_recomputed_orbit_size": len(orbit),
        "jacobian_exit_code": status["exit_code"],
        "jacobian_timeout": status["timeout"],
    }


def polynomial_and_rank_checks():
    difference = [-1, -2, -4, 6]
    shifted = [
        sum(a * math.comb(d, k) * 2 ** (d - k)
            for d, a in enumerate(difference) if d >= k)
        for k in range(4)
    ]
    assert shifted == [27, 54, 32, 6]
    assert all(c > 0 for c in shifted)
    chain = Atom(0)
    family = {chain}
    for depth in range(1, 33):
        chain = frozenset((chain,))
        family.add(chain)
        assert len(family) == depth + 1
    return {
        "trace_difference_coefficients_in_B_ascending": difference,
        "substitution": "B=u+2",
        "trace_difference_coefficients_in_u_ascending": shifted,
        "inequality_domain": "Every integer B>=2 (coefficient identity and positivity, not sampling)",
        "singleton_chain_checked_depth": 32,
        "singleton_chain_general_argument": "Induction: one fresh singleton increases rank by one and adds one object.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = {
        "claim_id": "C243_FINITE_CHECKS",
        "result_class": "finite_verification",
        "scope": "Supporting finite models and an exact trace-size polynomial identity only.",
        "coding": coding_checks(),
        "heisenberg": heisenberg_checks(),
        "trace_bound_and_rank": polynomial_and_rank_checks(),
        "not_certified": [
            "The universal interpretation-to-FullCPT simulation",
            "The support and supported-HF transfer theorems",
            "Either manuscript's main theorem",
            "The upstream Lean dependency closure",
            "Novelty or publishable campaign completion",
        ],
    }
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        assert json.loads(certificate.read_text()) == result, "Stored certificate differs from replay"
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
