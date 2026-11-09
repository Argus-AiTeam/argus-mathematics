#!/usr/bin/env python3
"""Exact finite replays accompanying, not replacing, the universal Lean proof."""

import argparse
from collections import deque
from fractions import Fraction as F
from itertools import combinations, product
import json
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def radius(level):
    return 3**level - 1


def levels(cutoff):
    assert cutoff >= 1
    k = 1
    while 3**k <= cutoff:
        k += 1
    return k


def near(distance, bound):
    return distance is not None and distance <= bound


def profile(distance, radii):
    return F(sum(near(distance, r) for r in radii), len(radii))


def subsets(n):
    return tuple(
        tuple(i for i in range(n) if mask & (1 << i))
        for mask in range(2**n)
    )


def partitions(n):
    def extend(prefix):
        if len(prefix) == n:
            yield tuple(prefix)
            return
        for label in range(max(prefix, default=-1) + 2):
            yield from extend(prefix + [label])

    return tuple(extend([]))


def distances(labels, retained):
    n = len(labels[0])
    adjacency = [
        [
            z
            for z in range(n)
            if z != x and any(labels[i][x] == labels[i][z] for i in retained)
        ]
        for x in range(n)
    ]
    answer = []
    for x in range(n):
        row = [None] * n
        row[x] = 0
        queue = deque([x])
        while queue:
            y = queue.popleft()
            for z in adjacency[y]:
                if row[z] is None:
                    row[z] = row[y] + 1
                    queue.append(z)
        answer.append(tuple(row))
    return tuple(answer)


class Instance:
    def __init__(self, labels, family, k, theta, last_representative=False):
        self.labels = tuple(tuple(row) for row in labels)
        self.n = len(labels[0])
        self.u = len(labels)
        self.family = tuple(family)
        self.all_tags = subsets(self.u)
        self.k = k
        self.theta = F(theta)
        self.s = (1 / self.theta).__ceil__()
        self.radii = tuple(radius(l) for l in range(k))
        self.q = max(max(row) for row in labels) + 1
        self.m = self.s * 2**self.u
        self.mesh = self.theta / self.m
        self.alphabet = int(1 / self.mesh) + 1
        self.columns = tuple(product(range(self.n), self.family))
        assert self.n and self.u and self.q and k and self.theta > 0
        assert F(1, k) <= self.theta
        assert self.s * self.theta >= 1
        assert all(self.u - len(t) <= self.theta * self.u for t in family)
        self.dist = {t: distances(self.labels, t) for t in self.all_tags}
        choose = max if last_representative else min
        self.representatives = tuple(
            tuple(
                choose([x for x in range(self.n) if row[x] == c] or [0])
                for c in range(self.q)
            )
            for row in self.labels
        )
        self.g = tuple(
            tuple(profile(self.dist[t][x][v], self.radii) for x in range(self.n))
            for v, t in self.columns
        )

    def mixture(self, weights):
        return tuple(
            sum((w * g[x] for w, g in zip(weights, self.g)), F(0))
            for x in range(self.n)
        )

    def decode(self, code):
        index, labels, integers = code
        assert 0 <= index < self.u
        assert len(labels) == self.k * self.s
        assert len(integers) == self.k * self.m
        assert all(0 <= c < self.q for c in labels)
        assert all(0 <= c < self.alphabet for c in integers)
        answer = [F(0)] * self.n
        position = 0
        for l, r in enumerate(self.radii):
            for slot in range(self.s):
                rep = self.representatives[index][labels[l * self.s + slot]]
                for tag in self.all_tags:
                    weight = self.mesh * integers[position]
                    position += 1
                    for x in range(self.n):
                        if near(self.dist[tag][x][rep], 2 * r + 1):
                            answer[x] += weight / self.k
        return tuple(answer)

    def encode(self, weights):
        assert len(weights) == len(self.columns)
        assert all(w >= 0 for w in weights) and sum(weights) <= 1
        omitted = tuple(
            sum(w for w, (_, tag) in zip(weights, self.columns) if i not in tag)
            for i in range(self.u)
        )
        index = min(i for i in range(self.u) if omitted[i] <= self.theta)
        code_labels, code_integers = [], []
        unrounded = [F(0)] * self.n
        for r in self.radii:
            incidence = tuple(
                frozenset(
                    y
                    for y, (v, tag) in enumerate(self.columns)
                    if index in tag and near(self.dist[tag][x][v], r)
                )
                for x in range(self.n)
            )
            covered, pivots = set(), []
            while True:
                pivot = next(
                    (
                        x
                        for x in range(self.n)
                        if sum(weights[y] for y in incidence[x] - covered)
                        > self.theta
                    ),
                    None,
                )
                if pivot is None:
                    break
                pivots.append(pivot)
                covered.update(incidence[pivot])
                assert len(pivots) <= self.s
            assignment = {
                y: next(slot for slot, z in enumerate(pivots) if y in incidence[z])
                for y in covered
            }
            assert all(
                sum(weights[y] for y in incidence[x] - covered) <= self.theta
                for x in range(self.n)
            )
            padded = pivots + [0] * (self.s - len(pivots))
            code_labels.extend(self.labels[index][z] for z in padded)
            level = [F(0)] * self.n
            rounded = [F(0)] * self.n
            for slot, z in enumerate(padded):
                rep = self.representatives[index][self.labels[index][z]]
                for tag in self.all_tags:
                    weight = sum(
                        (
                            weights[y]
                            for y in covered
                            if assignment[y] == slot and self.columns[y][1] == tag
                        ),
                        F(0),
                    )
                    integer = int(weight / self.mesh)
                    assert 0 <= weight <= 1 and 0 <= integer < self.alphabet
                    assert 0 <= weight - integer * self.mesh < self.mesh
                    code_integers.append(integer)
                    for x in range(self.n):
                        if near(self.dist[tag][x][rep], 2 * r + 1):
                            level[x] += weight
                            rounded[x] += integer * self.mesh
            for x in range(self.n):
                original = sum(
                    (
                        w
                        for w, (v, tag) in zip(weights, self.columns)
                        if near(self.dist[tag][x][v], r)
                    ),
                    F(0),
                )
                inflated = sum(
                    (
                        w
                        for w, (v, tag) in zip(weights, self.columns)
                        if near(self.dist[tag][x][v], 3 * r + 2)
                    ),
                    F(0),
                )
                assert original - 2 * self.theta <= level[x] <= inflated
                assert 0 <= level[x] - rounded[x] <= self.theta
                unrounded[x] += level[x] / self.k
        code = (index, tuple(code_labels), tuple(code_integers))
        answer = self.decode(code)
        original = self.mixture(weights)
        for f, before, after in zip(original, unrounded, answer):
            assert f - 2 * self.theta <= before <= f + sum(weights) / self.k
            assert 0 <= before - after <= self.theta
            assert f - 3 * self.theta <= after <= f + self.theta
        return code, answer


def grid(size, denominator):
    def generate(position, remaining, prefix):
        if position == size:
            yield tuple(F(x, denominator) for x in prefix)
            return
        for value in range(remaining + 1):
            yield from generate(position + 1, remaining - value, prefix + [value])

    return generate(0, denominator, [])


def check_minimax():
    examples = []
    for cutoff in range(1, 257):
        k = levels(cutoff)
        radii = tuple(radius(l) for l in range(k))
        tests = tuple(radius(l + 1) for l in range(k))
        assert 3 ** (k - 1) <= cutoff < 3**k
        assert all(r < cutoff for r in radii)
        assert all(
            sum(j < d <= 3 * j + 2 for d in tests) == 1
            for j in range(cutoff)
        )
        largest = max(
            sum(r < d <= 3 * r + 2 for r in radii)
            for d in range(3 * cutoff + 1)
        )
        assert largest == 1
        assert profile(None, radii) == 0
        if cutoff in (1, 2, 3, 8, 9, 26, 27, 80, 81, 242, 243, 256):
            examples.append(
                {"H": cutoff, "k": k, "radii": radii, "dual_distances": tests,
                 "optimal_loss": str(F(1, k))}
            )
    return {"cutoffs": 256, "exact_primal_dual_examples": examples}


def check_signed(instance, weights):
    assert sum(abs(w) for w in weights) <= 1
    positive = tuple(max(w, 0) for w in weights)
    negative = tuple(max(-w, 0) for w in weights)
    _, a = instance.encode(positive)
    _, b = instance.encode(negative)
    original = instance.mixture(weights)
    assert all(
        abs(f - (p - n)) <= 4 * instance.theta
        for f, p, n in zip(original, a, b)
    )


def check_partitions():
    inputs = positives = signed = disconnected = 0
    for n in range(1, 4):
        for u in (1, 2):
            for labels in product(partitions(n), repeat=u):
                admissible = tuple(t for t in subsets(u) if u - len(t) <= F(u, 2))
                for mask in range(1, 2 ** len(admissible)):
                    family = tuple(t for i, t in enumerate(admissible) if mask & (1 << i))
                    for last in (False, True):
                        case = Instance(labels, family, 2, F(1, 2), last)
                        inputs += 1
                        disconnected += any(
                            d is None for tag in family for row in case.dist[tag] for d in row
                        )
                        for weights in grid(len(case.columns), 2):
                            case.encode(weights)
                            positives += 1
                            for sign in (-1, 1):
                                vector = tuple(w * (sign if i % 2 else -sign)
                                               for i, w in enumerate(weights))
                                check_signed(case, vector)
                                signed += 1
    curated = (
        ((0, 0, 1, 1, 2, 2, 3, 3, 4),
         (0, 1, 1, 2, 2, 3, 3, 4, 4),
         (0, 1, 2, 3, 4, 5, 6, 7, 8)),
        ((0, 0, 1, 1, 2, 2, 3, 3, 4),
         (0, 1, 1, 2, 2, 3, 3, 4, 4),
         (0, 0, 1, 1, 2, 2, 3, 3, 4)),
    )
    for labels, k, theta in product(curated, (3, 4), (F(1, 3), F(1, 2))):
        family = tuple(t for t in subsets(3) if 3 - len(t) <= 3 * theta)
        case = Instance(labels, family, k, theta, True)
        inputs += 1
        disconnected += any(
            d is None for tag in family for row in case.dist[tag] for d in row
        )
        vectors = [tuple(F(0) for _ in case.columns)]
        for index in range(len(case.columns)):
            vectors.append(tuple(F(i == index) for i in range(len(case.columns))))
        vectors.append(tuple(case.mesh * F(2 * index + 1, 2 * len(case.columns))
                             for index in range(len(case.columns))))
        vectors.append(tuple(F(1, len(case.columns)) for _ in case.columns))
        for weights in vectors:
            case.encode(weights)
            positives += 1
            check_signed(case, tuple(w * (-1 if i % 2 else 1)
                                     for i, w in enumerate(weights)))
            signed += 1
    return {"partition_inputs": inputs, "positive_vectors": positives,
            "signed_vectors": signed, "inputs_with_infinite_distances": disconnected}


def check_enumerated_list():
    case = Instance(((0, 1),), ((), (0,)), 1, F(1), True)
    fixed_codes = tuple(
        (0, (label,), integers)
        for label in range(case.q)
        for integers in product(range(case.alphabet), repeat=case.m)
    )
    fixed_list = {case.decode(code) for code in fixed_codes}
    for weights in grid(len(case.columns), 3):
        code, answer = case.encode(weights)
        assert code in fixed_codes and answer in fixed_list
    bound = case.u * case.q ** (case.k * case.s) * (
        case.alphabet ** (case.k * case.s * 2**case.u)
    )
    assert len(fixed_codes) == bound and len(fixed_list) <= bound
    return {"codes": len(fixed_codes), "distinct_decoded_functions": len(fixed_list),
            "exact_code_bound": bound, "theta": "1",
            "scope": "Tiny full code enumeration; theorem also covers theta>=1"}


def check_rounding_and_dimension():
    checks = 0
    for theta, s, u in product((F(1, 2), F(1, 3), F(1, 7)), range(1, 5), range(1, 4)):
        mesh = theta / (s * 2**u)
        alphabet = int(1 / mesh) + 1
        for integer in range(alphabet):
            for shift in (F(-1, 2), F(0), F(1, 2)):
                weight = mesh * (integer + shift)
                if 0 <= weight <= 1:
                    code = int(weight / mesh)
                    assert 0 <= code < alphabet
                    assert 0 <= weight - mesh * code < mesh
                    checks += 1
    dimensions = 0
    for rank, degree in product(range(1, 31), range(1, 31)):
        dh = comb(rank + degree - 1, degree)
        previous = comb(rank + degree - 2, degree - 1)
        k, s = levels(degree), 3
        assert F(previous, dh) == F(degree, rank + degree - 1)
        assert F(2 * k * s * previous, dh) == F(2 * k * s * degree, rank + degree - 1)
        assert F(2 * k * s * previous, dh) <= F(2 * degree * s * previous, dh)
        dimensions += 1
    return {"exact_rounding_checks": checks, "dimension_identities": dimensions}


def jacobian_record():
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_result.json").read_text())
    assert response["request"]["payload"] == payload
    assert response["result"]["operation_id"] == "optimization.linear.rational_general_optimum.compute"
    status = response["result"]["output"]["status"]
    assert status == "UNKNOWN", "A different adapter result needs explicit human inspection."
    rejection = json.loads((ROOT / "jacobian_rejected_result.json").read_text())
    assert rejection["error"]["data"]["code"] == "INVALID_REQUEST"
    return {"server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "operation_id": response["result"]["operation_id"],
            "adapter_exit_status": 0, "typed_status": status,
            "mathematical_conclusion": "none",
            "rejected_request_exit_status": 2,
            "rejection": rejection["error"]["data"]["errors"][0]["code"]}


def build_certificate():
    return {
        "schema_version": 1,
        "evidence_kind": "exact_finite_replay_and_universal_proof_sources",
        "universal_proof": "Main.lean; see statement_fidelity.md for exact formal scope",
        "proof_report": "report.md",
        "independent_review": "required_not_recorded_by_engineer",
        "minimax": check_minimax(),
        "compression": check_partitions(),
        "fixed_list": check_enumerated_list(),
        "boundaries_and_dimensions": check_rounding_and_dimension(),
        "jacobian": jacobian_record(),
        "manuscript_refutations": [],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        assert json.loads(path.read_text()) == json.loads(json.dumps(certificate)), (
            "The exact replay differs from the persisted certificate."
        )
    print(json.dumps({"ok": True, **certificate["compression"],
                      **certificate["boundaries_and_dimensions"]}, sort_keys=True))


if __name__ == "__main__":
    main()
