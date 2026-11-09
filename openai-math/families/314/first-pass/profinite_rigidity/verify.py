#!/usr/bin/env python3
"""Exact finite replays of the identities proved universally in report.md."""

import argparse
import itertools
import json
import math
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parent


class Group:
    def __init__(self, table):
        self.table = table
        self.n = len(table)
        assert self.n > 0 and all(len(row) == self.n for row in table)
        assert all(0 <= z < self.n for row in table for z in row)
        assert all(table[0][x] == table[x][0] == x for x in range(self.n))
        assert all(
            table[table[x][y]][z] == table[x][table[y][z]]
            for x in range(self.n) for y in range(self.n) for z in range(self.n)
        ), "Finite multiplication table is not associative"
        self.inverses = [
            next(y for y in range(self.n) if table[x][y] == table[y][x] == 0)
            for x in range(self.n)
        ]

    def generated(self, generators):
        steps = tuple(generators) + tuple(self.inverses[x] for x in generators)
        seen = {0}
        todo = deque([0])
        while todo:
            x = todo.popleft()
            for y in steps:
                z = self.table[x][y]
                if z not in seen:
                    seen.add(z)
                    todo.append(z)
        return frozenset(seen)

    def subgroups(self):
        known = {frozenset({0}): ()}
        todo = deque(known)
        while todo:
            subgroup = todo.popleft()
            generators = known[subgroup]
            for x in range(self.n):
                if x not in subgroup:
                    larger = self.generated(generators + (x,))
                    if larger not in known:
                        known[larger] = generators + (x,)
                        todo.append(larger)
        return sorted(known.items(), key=lambda item: (len(item[0]), sorted(item[0])))

    def normal(self, subgroup):
        return all(
            self.table[self.table[g][x]][self.inverses[g]] in subgroup
            for g in range(self.n)
            for x in subgroup
        )

    def quotient(self, subgroup):
        assert self.normal(subgroup)
        coset_of = {}
        representatives = []
        for x in range(self.n):
            if x not in coset_of:
                i = len(representatives)
                representatives.append(x)
                for y in subgroup:
                    coset_of[self.table[x][y]] = i
        table = [
            [coset_of[self.table[x][y]] for y in representatives]
            for x in representatives
        ]
        return Group(table), coset_of


def cyclic(n):
    return Group([[(x + y) % n for y in range(n)] for x in range(n)])


def product(left, right):
    n = right.n
    return Group([
        [left.table[x // n][y // n] * n + right.table[x % n][y % n]
         for y in range(left.n * n)]
        for x in range(left.n * n)
    ])


def abelian(p, partition):
    group = cyclic(1)
    for exponent in partition:
        group = product(group, cyclic(p**exponent))
    return group


def dihedral():
    return Group([
        [((x // 2 + (-1)**(x % 2) * (y // 2)) % 4) * 2
         + (x + y) % 2 for y in range(8)]
        for x in range(8)
    ])


def quaternion():
    basis = [
        [(0, 0), (0, 1), (0, 2), (0, 3)],
        [(0, 1), (1, 0), (0, 3), (1, 2)],
        [(0, 2), (1, 3), (1, 0), (0, 1)],
        [(0, 3), (0, 2), (1, 1), (1, 0)],
    ]
    return Group([
        [4 * ((x // 4 + y // 4 + basis[x % 4][y % 4][0]) % 2)
         + basis[x % 4][y % 4][1] for y in range(8)]
        for x in range(8)
    ])


def log_p(n, p):
    exponent = 0
    while n > 1 and n % p == 0:
        n //= p
        exponent += 1
    assert n == 1
    return exponent


def valuation(n, p):
    assert n != 0
    n = abs(n)
    exponent = 0
    while n % p == 0:
        n //= p
        exponent += 1
    return exponent


def surjections(domain, subgroup, generators, target):
    for images in itertools.product(range(target.n), repeat=len(generators)):
        mapping = {0: 0}
        todo = deque([0])
        valid = True
        while todo and valid:
            x = todo.popleft()
            for g, image in zip(generators, images):
                y = domain.table[x][g]
                value = target.table[mapping[x]][image]
                if y in mapping:
                    if mapping[y] != value:
                        valid = False
                        break
                else:
                    mapping[y] = value
                    todo.append(y)
        if valid and len(mapping) == len(subgroup) and len(set(mapping.values())) == target.n:
            assert all(
                mapping[domain.table[x][y]] == target.table[mapping[x]][mapping[y]]
                for x in subgroup for y in subgroup
            )
            yield mapping


def graph_replay(name, k, p, m, d):
    lattice = abelian(p, [m] * d)
    ambient = product(k, lattice)
    actual = {
        h for h, _ in ambient.subgroups()
        if {x // lattice.n for x in h} == set(range(k.n))
    }
    constructed = {}
    automorphism_witness = 0
    weights = [0] * (log_p(k.n, p) + 1)
    for v, _ in k.subgroups():
        if not k.normal(v):
            continue
        quotient, coset_of = k.quotient(v)
        weights[log_p(quotient.n, p)] += sum(
            len(quotient.generated(values)) == quotient.n and all(
                quotient.table[x][y] == quotient.table[y][x]
                for x in values for y in values
            )
            for values in itertools.product(range(quotient.n), repeat=d)
        )
        for w, generators in lattice.subgroups():
            for mapping in surjections(lattice, w, generators, quotient):
                h = frozenset(
                    x * lattice.n + y
                    for x in range(k.n) for y in w
                    if coset_of[x] == mapping[y]
                )
                assert h not in constructed
                recovered_v = frozenset(x // lattice.n for x in h if x % lattice.n == 0)
                recovered_w = frozenset(x % lattice.n for x in h)
                assert (v, w) == (recovered_v, recovered_w)
                index = ambient.n // len(h)
                assert index == (k.n // len(v)) * (lattice.n // len(w))
                constructed[h] = index
                if len(v) == 1 and len(w) == lattice.n:
                    automorphism_witness += 1
    assert set(constructed) == actual
    counts = {}
    for h in actual:
        exponent = log_p(ambient.n // len(h), p)
        counts[exponent] = counts.get(exponent, 0) + 1
    numbers = lattice_numbers(p, d, m)
    stable = [
        sum(weights[i] * numbers[h-i] for i in range(min(h, len(weights)-1) + 1))
        for h in range(m + 1)
    ]
    assert stable == [counts.get(h, 0) for h in range(m + 1)]
    return {
        "group": name, "p": p, "cyclic_exponent": m, "rank": d,
        "ambient_order": ambient.n,
        "actual_graph_subgroups": len(actual),
        "counts_by_index_exponent": {str(h): counts[h] for h in sorted(counts)},
        "graphs_with_V_trivial_W_full": automorphism_witness,
        "stable_infinite_counts_through_exponent_m": stable,
    }


def lattice_numbers(p, d, bound):
    coefficients = [1] + [0] * bound
    for u in range(d):
        for j in range(1, bound + 1):
            coefficients[j] += p**u * coefficients[j - 1]
    return coefficients


def partitions(n, maximum=None):
    if n == 0:
        yield ()
        return
    for head in range(min(n, n if maximum is None else maximum), 0, -1):
        for tail in partitions(n - head, head):
            yield (head,) + tail


def quotient_weights(a, p, d, enumerate_tuples=False):
    b = log_p(a.n, p)
    weights = [0] * (b + 1)
    for subgroup, _ in a.subgroups():
        q, _ = a.quotient(subgroup)
        p_multiples = {0}
        for x in range(q.n):
            value = 0
            for _ in range(p):
                value = q.table[value][x]
            p_multiples.add(value)
        rank = log_p(q.n // len(p_multiples), p)
        count = q.n**d
        for j in range(rank):
            if j >= d:
                count = 0
                break
            numerator, denominator = p**d - p**j, p**d
            assert count * numerator % denominator == 0
            count = count * numerator // denominator
        if enumerate_tuples:
            brute = sum(
                len(q.generated(values)) == q.n
                for values in itertools.product(range(q.n), repeat=d)
            )
            assert count == brute
        weights[log_p(q.n, p)] += count
    assert sum(weights) == a.n**d
    return weights


def abelian_replays():
    results = []
    for p, bound in [(2, 4), (3, 3), (5, 2)]:
        for b in range(1, bound + 1):
            for partition in partitions(b):
                a = abelian(p, partition)
                rank = len(partition)
                for d in range(1, 5):
                    weights = quotient_weights(a, p, d, a.n <= 9 and d <= 3)
                    h = b * (d + 1)
                    numbers = lattice_numbers(p, d, h + 1)
                    denominator = math.prod(1 - p**u for u in range(1, d))
                    counts = [
                        sum(weights[i] * numbers[j - i] for i in range(min(b, j) + 1))
                        for j in range(h + 2)
                    ]
                    for j in range(b, h + 2):
                        assert (denominator * counts[j] - p**(b*d)) % p**(j-b+1) == 0
                    assert valuation(counts[h], p) == b * d
                    assert valuation(counts[h + 1], p) == b * d
                    assert valuation(p**rank * counts[h], p) == b*d + rank <= h
                    results.append({
                        "p": p, "cyclic_exponents": list(partition), "d": d,
                        "weights": weights, "h": h, "D_d": denominator,
                        "c_h": counts[h], "valuation": b*d,
                        "detector_valuation": b*d + rank,
                        "required_divisibility_exponent": h + 1,
                    })
    return results


def detector_replay(p, rank):
    f = abelian(p, [1] * rank)
    subgroups = [s for s, _ in f.subgroups()]
    mobius = {}
    for s in reversed(subgroups):
        mobius[s] = 1 if len(s) == f.n else -sum(
            mobius[t] for t in mobius if s < t
        )
    marks = []
    for t in subgroups:
        mark = sum(
            len(s) * mobius[s] * (f.n // len(s))
            for s in subgroups if t <= s
        )
        assert mark == (f.n if len(t) == f.n else 0)
        marks.append(mark)
    return {
        "p": p, "rank": rank, "order": f.n, "subgroups": len(subgroups),
        "integral_coefficients": [len(s) * mobius[s] for s in subgroups],
        "marks_in_subgroup_order": marks,
    }


def actual_set_obstruction():
    p, rank, d, h = 2, 2, 2, 6
    f = abelian(p, [1] * rank)
    subgroups = [s for s, _ in f.subgroups()]
    counts = {}
    mobius = {}
    for s in reversed(subgroups):
        mobius[s] = 1 if len(s) == f.n else -sum(mobius[t] for t in mobius if s < t)
        elements = sorted(s)
        index = {x: i for i, x in enumerate(elements)}
        group = Group([[index[f.table[x][y]] for y in elements] for x in elements])
        weights = quotient_weights(group, p, d)
        j = h - log_p(f.n // len(s), p)
        numbers = lattice_numbers(p, d, j)
        counts[s] = sum(weights[i] * numbers[j-i] for i in range(min(j, len(weights)-1)+1))
    orbit_sums = [
        -(f.n // len(s)) * sum(counts[t] for t in subgroups if not t <= s)
        for s in subgroups
    ]
    detector_sum = sum(
        len(s) * mobius[s] * value for s, value in zip(subgroups, orbit_sums)
    )
    full = frozenset(range(f.n))
    assert detector_sum == f.n * counts[full] == 3520
    assert orbit_sums[0] == -5392 and orbit_sums[0] % p**(h+1) != 0
    return {
        "group": "C2^2 x Z_2^2",
        "h": h, "actual_set": "regular C2^2-set inflated through projection",
        "actual_set_cardinality": f.n,
        "congruence_sum": orbit_sums[0],
        "required_modulus": p**(h+1),
        "residue": orbit_sums[0] % p**(h+1),
        "all_transitive_orbit_sums": orbit_sums,
        "virtual_detector_sum": detector_sum,
        "scope": "Explicit failure of the congruence hypothesis, not a counterexample to thm:procyclic.",
    }


def polynomial_product(left, right):
    out = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            out[i + j] += x * y
    return out


def jacobian_payload():
    p, d, j = 2, 4, 6
    denominator = [1]
    coefficients = [1] + [0] * j
    for u in range(1, d):
        denominator = polynomial_product(denominator, [1, -p**u])
        for k in range(1, j + 1):
            coefficients[k] += p**u * coefficients[k - 1]
    expanded = polynomial_product(denominator, coefficients)
    assert expanded[0] == 1 and all(x % p**(j + 1) == 0 for x in expanded[1:])
    return {
        "modulus": p**(j + 1), "variables": ["t"],
        "left": [
            {"coefficient": str(c), "exponents": [i]}
            for i, c in enumerate(expanded) if c
        ],
        "right": [{"coefficient": "1", "exponents": [0]}],
    }


def replay_jacobian(payload):
    saved = json.loads((ROOT / "jacobian_output.json").read_text())
    assert saved["request"] == {
        "operation_id": "modular.polynomial_identity.compute",
        "payload": payload,
    }
    assert saved["server"]["version"] == "0.14.0"
    assert saved["protocol_version"] == "2025-11-25"
    assert saved["transport"] == "mcp-stdio" and saved["tool"] == "math.run"
    assert "error" not in saved and "error" not in saved["result"]
    assert saved["result"]["operation_id"] == "modular.polynomial_identity.compute"
    output = saved["result"]["output"]
    assert output == {
        "comparison_scope": "FORMAL_COEFFICIENTWISE_IDENTITY",
        "identical": True,
        "modulus": payload["modulus"],
        "normalized_left": [{"coefficient": 1, "exponents": [0]}],
        "normalized_right": [{"coefficient": 1, "exponents": [0]}],
        "residual": [],
        "variable_order": ["t"],
    }
    assert json.loads((ROOT / "jacobian_payload.json").read_text()) == payload
    return {
        "server_version": saved["server"]["version"],
        "protocol_version": saved["protocol_version"],
        "operation": saved["result"]["operation_id"],
        "structured_error": None,
        "typed_output_identical": True,
        "independent_integer_residual_check": True,
    }


def certificate():
    lattice_checks = []
    for p in (2, 3, 5):
        for d in range(1, 6):
            denominator = math.prod(1 - p**u for u in range(1, d))
            values = lattice_numbers(p, d, 12)
            assert denominator % p != 0
            assert all((denominator * a - 1) % p**(j + 1) == 0
                       for j, a in enumerate(values))
            lattice_checks.append({"p": p, "d": d, "D_d": denominator, "values": values})
    graphs = [
        graph_replay("C2", cyclic(2), 2, 2, 1),
        graph_replay("C3", cyclic(3), 3, 1, 1),
        graph_replay("C2", cyclic(2), 2, 1, 2),
        graph_replay("C2xC2", abelian(2, [1, 1]), 2, 1, 2),
        graph_replay("D8", dihedral(), 2, 2, 1),
        graph_replay("Q8", quaternion(), 2, 2, 1),
    ]
    assert graphs[3]["graphs_with_V_trivial_W_full"] == 6
    abelian_cases = abelian_replays()
    return {
        "result_class": "exact_verification_of_finite_replays",
        "universal_result": "Proved in report.md; arithmetic core in Main.lean, not inferred from these samples.",
        "manuscript_assertions_tested": [
            "eq:graph-subgroup-count", "lem:lattice-limit",
            "lem:kernel-abelianization (finite-abelian arithmetic)"
        ],
        "scope_exclusions": ["thm:pro-characters", "thm:subgroup-congruence", "thm:main"],
        "graph_bijections": graphs,
        "lattice_checks": lattice_checks,
        "finite_abelian_checks": abelian_cases,
        "detector_checks": [detector_replay(p, r) for p, r in [(2, 1), (2, 2), (2, 3), (3, 2)]],
        "actual_finite_set_obstruction": actual_set_obstruction(),
        "jacobian_operation": "modular.polynomial_identity.compute",
        "jacobian_payload": jacobian_payload(),
        "jacobian_replay": replay_jacobian(jacobian_payload()),
        "summary": {
            "graph_examples": len(graphs),
            "lattice_congruences": 3 * 5 * 13,
            "finite_abelian_effective_obstructions": len(abelian_cases),
            "counterexamples_found": 0,
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    args = parser.parse_args()
    actual = certificate()
    encoded = json.dumps(actual, indent=2) + "\n"
    if args.write_certificate:
        (ROOT / "exact_certificate.json").write_text(encoded)
    else:
        expected = (ROOT / "exact_certificate.json").read_text()
        assert encoded == expected, "Exact certificate differs from byte-for-byte recomputation"
    if args.write_jacobian_payload:
        (ROOT / "jacobian_payload.json").write_text(
            json.dumps(actual["jacobian_payload"], indent=2) + "\n"
        )
    print(json.dumps({"ok": True, **actual["summary"]}, sort_keys=True))


if __name__ == "__main__":
    main()
