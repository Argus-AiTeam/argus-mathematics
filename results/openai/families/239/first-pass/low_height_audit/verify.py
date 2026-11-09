#!/usr/bin/env python3
"""Replay exact audit regressions, exponent algebra, and Lean attestation binding.

The covering theorem is proved in quantitative_cover.md, not by these finite
checks. Run the official lean_evidence command separately to replay Lean.
"""

import argparse
from fractions import Fraction as F
from functools import lru_cache
import hashlib
from itertools import combinations, product
import json
from math import gcd, isqrt, lcm
from pathlib import Path


HERE = Path(__file__).resolve().parent
DIM = 3
ZERO = ()


@lru_cache(maxsize=None)
def rref(rows):
    a = [list(map(F, row)) for row in rows]
    pivot = 0
    for col in range(DIM):
        found = next((i for i in range(pivot, len(a)) if a[i][col]), None)
        if found is None:
            continue
        a[pivot], a[found] = a[found], a[pivot]
        divisor = a[pivot][col]
        a[pivot] = [x / divisor for x in a[pivot]]
        for i in range(len(a)):
            if i != pivot and a[i][col]:
                factor = a[i][col]
                a[i] = [x - factor * y for x, y in zip(a[i], a[pivot])]
        pivot += 1
        if pivot == len(a):
            break
    return tuple(tuple(row) for row in a[:pivot])


def span(*rows):
    return rref(tuple(tuple(row) for row in rows))


@lru_cache(maxsize=None)
def add(a, b):
    return rref(a + b)


@lru_cache(maxsize=None)
def perp(a):
    a = rref(a)
    pivots = [next(i for i, x in enumerate(row) if x) for row in a]
    basis = []
    for free in range(DIM):
        if free not in pivots:
            v = [F(0)] * DIM
            v[free] = F(1)
            for row, pivot in zip(a, pivots):
                v[pivot] = -row[free]
            basis.append(tuple(v))
    return rref(tuple(basis))


@lru_cache(maxsize=None)
def meet(a, b):
    return perp(add(perp(a), perp(b)))


@lru_cache(maxsize=None)
def distance(a, b):
    return len(a) + len(b) - 2 * len(meet(a, b))


def contained(a, b):
    return add(a, b) == b


def primitive(v):
    denominator = lcm(*(x.denominator for x in map(F, v)))
    ints = [int(F(x) * denominator) for x in v]
    divisor = gcd(*ints)
    if not divisor:
        raise ValueError("A primitive direction must be nonzero")
    ints = [x // divisor for x in ints]
    if next(x for x in ints if x) < 0:
        ints = [-x for x in ints]
    return tuple(ints)


@lru_cache(maxsize=None)
def height_squared(a):
    if len(a) in (0, DIM):
        return 1
    direction = a[0] if len(a) == 1 else perp(a)[0]
    return sum(x * x for x in primitive(direction))


def dot(u, v):
    return sum((F(x) * F(y) for x, y in zip(u, v)), F(0))


def determinant(a):
    n = len(a)
    b = [list(map(F, row)) for row in a]
    result = F(1)
    for j in range(n):
        found = next((i for i in range(j, n) if b[i][j]), None)
        if found is None:
            return F(0)
        if found != j:
            b[j], b[found] = b[found], b[j]
            result = -result
        divisor = b[j][j]
        result *= divisor
        for i in range(j + 1, n):
            factor = b[i][j] / divisor
            for k in range(j + 1, n):
                b[i][k] -= factor * b[j][k]
    return result


def gram_determinant(basis):
    return determinant([[dot(u, v) for v in basis] for u in basis])


E = tuple(tuple(int(i == j) for j in range(DIM)) for i in range(DIM))
FULL = span(*E)


def check_subspaces():
    generators = E + ((1, 1, 1), (1, -1, 0))
    family = {ZERO, FULL}
    for size in (1, 2):
        family.update(span(*vectors) for vectors in combinations(generators, size))
    family = sorted(family)
    nested = [(p, pp) for p in family for pp in family if contained(pp, p)]
    cross = 0
    for x, y in product(family, repeat=2):
        assert len(add(x, y)) + len(meet(x, y)) == len(x) + len(y)
        assert distance(perp(x), perp(y)) == distance(x, y)
        assert height_squared(add(x, y)) * height_squared(meet(x, y)) <= (
            height_squared(x) * height_squared(y)
        )
        for p, pp in nested:
            assert distance(add(x, y), p) + distance(meet(x, y), pp) <= (
                distance(x, p) + distance(y, pp)
            )
            cross += 1
    return {"spaces": len(family), "nested_pairs": len(nested), "cross_inequalities": cross}


def all_small_height_spaces():
    lines = set()
    bound = isqrt(8)
    for v in product(range(-bound, bound + 1), repeat=DIM):
        if any(v) and sum(x * x for x in v) <= 8:
            lines.add(span(primitive(v)))
    return sorted({ZERO, FULL} | lines | {perp(line) for line in lines})


def graph_chain(w):
    pivots = [next(i for i, x in enumerate(row) if x) for row in w]
    equations = []
    chain = [FULL]
    for j in range(DIM):
        if j in pivots:
            continue
        equation = list(map(F, E[j]))
        for row, pivot in zip(w, pivots):
            equation[pivot] -= row[j]
        equations.append(tuple(equation))
        chain.append(perp(tuple(equations)))
    assert chain[-1] == w
    return chain


def check_minimizers():
    candidates = all_small_height_spaces()
    assert all(height_squared(u) <= 8 for u in candidates)
    targets = [
        ZERO, FULL, span(E[1]), span((1, 1, 2)),
        span((1, 2, 3)), span((1, 0, 1), (0, 1, 1)),
    ]
    steps = 0
    multidrop_examples = 0
    for w in targets:
        previous = FULL
        previous_energy = 1
        drops = []
        zero_drops = 0
        for p in graph_chain(w):
            # N=4, a=1/4: 2 F_P(U) = log_4(H(U)^2 * 2^d).
            values = [height_squared(u) * 2 ** distance(u, p) for u in candidates]
            energy = min(values)
            minimizers = [u for u, value in zip(candidates, values) if value == energy]
            greatest = ZERO
            for u in minimizers:
                greatest = add(greatest, u)
            assert greatest in minimizers, "Greatest minimizer must be an actual minimizer"
            assert contained(greatest, previous)
            assert energy >= previous_energy
            for e in E:
                if contained(span(e), p):
                    assert contained(span(e), greatest)
            if p != FULL:
                drop = len(previous) - len(greatest)
                drops.append(drop)
                if drop == 0:
                    zero_drops += 1
                    assert energy == 2 * previous_energy
                steps += 1
            previous, previous_energy = greatest, energy
        h2 = height_squared(w)
        assert 2 ** distance(previous, w) <= h2
        s = sum(c for c in drops if c >= 2)
        theta = len(previous) - len(w)
        assert sum(c - 1 for c in drops if c >= 2) == zero_drops - theta
        assert 2 ** zero_drops <= h2
        assert 2 ** s <= h2 ** 4
        multidrop_examples += int(s > 0)
    return {
        "N": 4,
        "a": "1/4",
        "all_global_minimizer_candidates": len(candidates),
        "height_squared_cutoff": 8,
        "target_spaces": len(targets),
        "graph_steps": steps,
        "multidrop_target_examples": multidrop_examples,
    }


def check_normal_identity():
    old_basis = ((1, 0, 1), (0, 1, 1))
    new_basis = ((1, 1, 2),)
    dual = ((F(2, 3), F(-1, 3), F(1, 3)), (F(-1, 3), F(2, 3), F(1, 3)))
    for i, row in enumerate(dual):
        assert [dot(row, v) for v in old_basis] == [int(i == j) for j in range(2)]
    normal = tuple(x - y for x, y in zip(*dual))
    assert dot(normal, new_basis[0]) == 0
    assert gram_determinant((normal,)) == gram_determinant(new_basis) / gram_determinant(old_basis)
    assert gram_determinant(dual) == 1 / gram_determinant(old_basis)
    mu1_squared = dot(dual[0], dual[0])
    projection = tuple(
        y - dot(dual[1], dual[0]) / mu1_squared * x for x, y in zip(*dual)
    )
    mu2_squared = dot(projection, projection)
    assert mu1_squared * mu2_squared == gram_determinant(dual)
    old = span(*old_basis)
    new = span(*new_basis)
    assert meet(old, perp(span(normal))) == new
    e = span(E[2])
    assert add(old, e) == FULL and meet(old, e) == ZERO
    assert dot(old_basis[0], E[2]) != 0
    for u in all_small_height_spaces():
        assert height_squared(add(u, e)) <= height_squared(u)
        assert distance(add(u, e), FULL) <= distance(u, old)
    return {
        "old_height_squared": str(gram_determinant(old_basis)),
        "new_height_squared": str(gram_determinant(new_basis)),
        "normal_determinant_squared": str(gram_determinant((normal,))),
        "dual_determinant_squared": str(gram_determinant(dual)),
        "projected_flag_lengths_squared": [str(mu1_squared), str(mu2_squared)],
        "graph_direct_sum_is_nonorthogonal": True,
    }


def check_blocks():
    a, q, epsilon = F(1, 40), F(256), F(1, 1000)
    starts = F(1, 2) - 3 * a + epsilon
    options = []
    for exponent in (0, 1, 4, 8, 16, 20):
        u = F(2 ** exponent)
        normalized_log = F(exponent, 20)
        w = u * (starts - a - normalized_log / 2)
        assert w >= -(4 * a) * u
        if u <= q:
            assert w >= u / 5
        assert 1 <= 5 * w + (20 * a + 1 / q) * u
        options.append((u, w))
    checked = balanced = 0
    for length in range(5):
        for blocks in product(options, repeat=length):
            c = sum((u for u, _ in blocks), F(0))
            w_total = sum((w for _, w in blocks), F(0))
            checked += 1
            if w_total <= 0:
                assert length <= (20 * a + 1 / q) * c
                assert length <= 21 * a * c
                balanced += 1
    return {"abstract_block_families": checked, "nonpositive_excess_families": balanced}


def check_exponents():
    beta, gamma = F(1, 9), F(2, 9)
    exponents = {
        "height_log_power": beta,
        "negative_a_log_power": gamma,
        "distance_log_power": beta + gamma - 1,
        "expensive_image_log_power": beta - gamma,
        "fiber_log_power": 2 * beta + 3 * gamma - 1,
        "a_times_log_N_power": 1 - gamma,
    }
    assert exponents["distance_log_power"] == F(-2, 3)
    assert exponents["expensive_image_log_power"] == F(-1, 9)
    assert exponents["fiber_log_power"] == F(-1, 9)
    assert exponents["a_times_log_N_power"] == F(7, 9)
    assert 462 * 4 == 1848 and 6 * 4 ** 2 == 96
    return {key: str(value) for key, value in exponents.items()}


def check_jacobian():
    payload = json.loads((HERE / "jacobian_rank_payload.json").read_text())
    record = json.loads((HERE / "jacobian_rank_output.json").read_text())
    assert record["request"]["operation_id"] == "matrix.rank.compute"
    assert record["request"]["payload"] == payload
    assert record["result"]["operation_id"] == "matrix.rank.compute"
    output = record["result"]["output"]
    assert output["matrix"] == payload["matrix"]
    rows = tuple(tuple(F(int(v["num"]), int(v["den"])) for v in row) for row in output["matrix"]["entries"])
    assert len(rref(rows)) == output["rank"] == 2
    assert output["pivot_columns"] == [0, 1]
    return {
        "operation_id": "matrix.rank.compute",
        "server_version": record["server"]["version"],
        "protocol_version": record["protocol_version"],
        "rank": output["rank"],
        "adapter_status": "success",
        "mathematical_scope": "one exact rational rank sanity check, not the covering theorem",
    }


def check_lean_attestation():
    record = json.loads((HERE / "lean_check.json").read_text())
    assert record["status"] == "success", "Lean compilation has not succeeded"
    assert record["exit_code"] == 0 and record["proof_holes"] == []
    assert "4.31.0" in json.dumps(record)
    for filename, key in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        digest = hashlib.sha256((HERE / filename).read_bytes()).hexdigest()
        assert digest == record[key], f"{filename} changed after its compiler run"
    return {
        "compiler_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "source_and_fidelity_match_existing_compiler_attestation": True,
        "scope": "L_FLAG_AMORTIZATION only; replay compilation with the official lean_evidence command",
    }


def certificate():
    return {
        "claim": "C_QUANT_COVER",
        "result_class": "improved_bound",
        "mathematical_status": "complete_proof_offered_for_independent_review",
        "novelty_status": "not_verified",
        "significance_status": "unassessed",
        "campaign_complete": False,
        "proof": "research/low_height_audit/quantitative_cover.md",
        "source_assertion": "U sections/04-low-height-cover.tex:28-41, thm:low-height-cover",
        "false_manuscript_assertions_found": [],
        "checks": {
            "rational_subspaces": check_subspaces(),
            "exact_global_minimizers_in_dimension_three": check_minimizers(),
            "primitive_normals_and_quotients": check_normal_identity(),
            "finite_block_regressions": check_blocks(),
            "universal_parameter_exponent_algebra": check_exponents(),
            "jacobian": check_jacobian(),
            "lean_attestation": check_lean_attestation(),
        },
        "not_certified": [
            "The complete covering theorem by a proof kernel",
            "Either main singularity theorem",
            "Originality or publishable significance",
            "Independent Reviewer acceptance or citation attribution",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    result = certificate()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2) + "\n")
    expected = json.loads(target.read_text())
    assert result == expected, "Exact certificate differs from replayed evidence"
    print(json.dumps({
        "ok": True,
        "claim": result["claim"],
        "result_class": result["result_class"],
        "novelty_status": result["novelty_status"],
        "campaign_complete": False,
        "checks": list(result["checks"]),
    }, indent=2))


if __name__ == "__main__":
    main()
