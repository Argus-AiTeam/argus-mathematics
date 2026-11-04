"""Exact finite checks; the asymptotic assertion is the separate prose proof."""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from itertools import product
import json
from math import gcd, isqrt, prod
from pathlib import Path
from time import perf_counter

Point = tuple[int, int] | None


def labels(word: dict) -> list[int]:
    result = [0, 1]
    for gate in word["gates"]:
        assert gate[0] in ("+", "-", "neg")
        assert all(0 <= i < len(result) for i in gate[1:])
        a = result[gate[1]]
        value = -a if gate[0] == "neg" else (
            a + result[gate[2]] if gate[0] == "+" else a - result[gate[2]]
        )
        result.append(value)
    assert result == word["labels"], (result, word["labels"])
    return result


def relations(values: set[int]) -> set[int]:
    result = {abs(a) for a in values} | {2 * abs(a) for a in values}
    result.update(abs(a + b) for a in values for b in values)
    result.update(abs(a - b) for a in values for b in values)
    result.discard(0)
    return result


def support(values: set[int]) -> set[int]:
    primes: set[int] = set()
    for value in values:
        divisor = 2
        while divisor * divisor <= value:
            if value % divisor == 0:
                primes.add(divisor)
                while value % divisor == 0:
                    value //= divisor
            divisor += 1
        if value > 1:
            primes.add(value)
    return primes


def rough_cofactor(value: int, support_product: int) -> int:
    while (common := gcd(value, support_product)) > 1:
        value //= common
    return value


def field_add(p: int, a: int, left: Point, right: Point) -> Point:
    if left is None:
        return right
    if right is None:
        return left
    x1, y1 = left
    x2, y2 = right
    if x1 == x2 and (y1 + y2) % p == 0:
        return None
    if left == right:
        slope = (3 * x1 * x1 + a) * pow(2 * y1, -1, p) % p
    else:
        slope = (y2 - y1) * pow(x2 - x1, -1, p) % p
    x3 = (slope * slope - x1 - x2) % p
    return x3, (slope * (x1 - x3) - y1) % p


@dataclass(frozen=True)
class Local:
    order: int
    curve_order: int
    cycle: tuple[Point, ...]

    def multiple(self, coefficient: int) -> Point:
        return self.cycle[coefficient % self.order]


def local_data(p: int) -> tuple[dict[tuple[int, int, int], Local], dict]:
    models: dict[tuple[int, int], int] = {}
    expected = Counter()
    for a, b in product(range(p), repeat=2):
        if (4 * a**3 + 27 * b**2) % p == 0:
            continue
        affine = sum(
            (y * y - x**3 - a * x - b) % p == 0
            for x, y in product(range(p), repeat=2)
        )
        models[a, b] = affine + 1
        expected[affine + 1] += affine
    result: dict[tuple[int, int, int], Local] = {}
    observed = Counter()
    singular = 0
    for a, x, y in product(range(p), repeat=3):
        b = (y * y - x**3 - a * x) % p
        if (a, b) not in models:
            singular += 1
            continue
        m = models[a, b]
        cycle: list[Point] = [None]
        point = (x, y)
        current = point
        while current is not None:
            cycle.append(current)
            current = field_add(p, a, current, point)
            assert len(cycle) <= m
        order = len(cycle)
        assert m % order == 0
        assert (m - p - 1) ** 2 < 4 * p
        result[a, x, y] = Local(order, m, tuple(cycle))
        observed[m] += 1
    assert observed == expected
    assert singular <= 4 * p * p
    return result, {
        "prime": p,
        "raw_triples": p**3,
        "singular_triples": singular,
        "nonsingular_triples": sum(observed.values()),
        "actual_triples_by_curve_order": dict(sorted(observed.items())),
        "uniform_order_mass_is_not_the_sampler": len(set(observed.values())) > 1,
    }


@dataclass(frozen=True)
class Step:
    point: Point
    factor: int | None
    kind: str
    normalized: bool = False


def normalized_add(N: int, a: int, left: Point, right: Point) -> Step:
    if left is None:
        return Step(right, None, "identity")
    if right is None:
        return Step(left, None, "identity")
    x1, y1 = left
    x2, y2 = right
    d = (x1 - x2) % N
    g = gcd(d, N)
    if 1 < g < N:
        return Step(None, g, "x")
    if g == 1:
        z = (y1 - y2) % N
        kind = "secant"
    else:
        g = gcd((y1 + y2) % N, N)
        if 1 < g < N:
            return Step(None, g, "y")
        if g == N:
            return Step(None, None, "inverse")
        assert left == right
        d = 2 * y1 % N
        z = (3 * x1 * x1 + a) % N
        kind = "tangent"
    assert gcd(d, N) == 1
    X3 = (z * z - (x1 + x2) * d * d) % N
    Y3 = (z * (x1 * d * d - X3) - y1 * d**3) % N
    inverse = pow(d, -1, N)
    return Step(
        (X3 * inverse**2 % N, Y3 * inverse**3 % N),
        None,
        kind,
        True,
    )


def conditional_compare(N: int, left: Point, right: Point) -> Step:
    if left is None or right is None:
        return Step(None, None, "infinity_comparison")
    g = gcd((left[0] - right[0]) % N, N)
    if 1 < g < N:
        return Step(None, g, "x")
    if g == 1:
        return Step(None, None, "unit_x_comparison")
    g = gcd((left[1] + right[1]) % N, N)
    return Step(None, g if 1 < g < N else None, "y")


def audit_relation(step: Step, alpha: int, beta: int, local: Local) -> None:
    candidates = (abs(alpha - beta), abs(alpha + beta)) if step.kind == "x" else (
        abs(alpha + beta),
    )
    assert any(v > 0 and v % local.order == 0 for v in candidates), (
        step.kind, alpha, beta, local.order
    )


def hall_checks(p: int, table: dict[tuple[int, int, int], Local]) -> dict:
    checked = 0
    nontrivial = 0
    for primes in ({2}, {3}, {2, 3}, {5}):
        M = prod(primes)
        models = {}
        observed = Counter()
        for (a, x, y), data in table.items():
            b = (y * y - x**3 - a * x) % p
            models[a, b] = data.curve_order
            if rough_cofactor(data.order, M) == 1:
                observed[a, b] += 1
        for model, m in models.items():
            m_P = m // rough_cofactor(m, M)
            assert observed[model] == m_P - 1
            checked += 1
            nontrivial += m_P < m
    assert nontrivial > 0
    return {"model_support_pairs_checked": checked, "proper_Hall_subgroups_checked": nontrivial}


def audit_samples(fixture: dict, stripe: bool) -> dict:
    p, q = fixture["primes"]
    N = p * q
    fields, weights = {}, []
    for r in (p, q):
        fields[r], mass = local_data(r)
        mass["exact_affine_Hall_counts"] = hall_checks(r, fields[r])
        weights.append(mass)
    words = fixture["words"]
    integer_labels = [labels(w) for w in words]
    inventory = relations(set().union(*(set(v) for v in integer_labels)))
    M = prod(inventory)
    t = max(len(w["gates"]) for w in words)
    assert len(support(inventory)) <= 4 * len(words) ** 2 * (t + 2) ** 3
    assert max(inventory) <= 2 ** (t + 1)
    counts = Counter()
    for a, x, y in product(range(1 if stripe else N), range(N), range(N)):
        counts["raw_triples"] += 1
        b = (y * y - x**3 - a * x) % N
        disc = gcd(6 * (4 * a**3 + 27 * b**2), N)
        local = {r: fields[r].get((a % r, x % r, y % r)) for r in (p, q)}
        expected_disc = prod(r for r in (p, q) if local[r] is None)
        assert disc == expected_disc
        if disc != 1:
            counts["discriminant_factor" if disc != N else "singular_discard"] += 1
            continue
        assert all(v is not None for v in local.values())
        registers: list[list[Point]] = [[None, (x, y)] for _ in words]
        order = ((a + x + y) & 1, 1 - ((a + x + y) & 1))
        stopped = False
        for i in range(t):
            for w in order:
                if i >= len(words[w]["gates"]):
                    continue
                gate = words[w]["gates"][i]
                parents = registers[w]
                alpha = integer_labels[w][gate[1]]
                left = parents[gate[1]]
                if gate[0] == "neg":
                    point = None if left is None else (left[0], -left[1] % N)
                    step = Step(point, None, "negation")
                    beta = 0
                else:
                    beta = integer_labels[w][gate[2]]
                    right = parents[gate[2]]
                    if gate[0] == "-":
                        beta = -beta
                        right = None if right is None else (right[0], -right[1] % N)
                    step = normalized_add(N, a, left, right)
                counts[step.kind] += 1
                if step.factor is not None:
                    for r in (p, q):
                        if step.factor % r == 0:
                            audit_relation(step, alpha, beta, local[r])
                            assert rough_cofactor(local[r].order, M) == 1
                            counts["direct_nonzero_annihilation_checks"] += 1
                    counts["arithmetic_factor"] += 1
                    stopped = True
                    break
                coefficient = integer_labels[w][i + 2]
                for r in (p, q):
                    expected_point = local[r].multiple(coefficient)
                    reduced = None if step.point is None else (
                        step.point[0] % r, step.point[1] % r
                    )
                    assert reduced == expected_point
                    counts["independent_field_register_checks"] += 1
                if step.point is None and coefficient != 0:
                    counts["nonzero_label_global_infinity"] += 1
                if step.normalized:
                    counts["normalized_denominator_records"] += 1
                parents.append(step.point)
                other = 1 - w
                if i % 3 == 1:
                    compare = conditional_compare(N, parents[-1], registers[other][-1])
                    counts["cross_word_comparisons"] += 1
                    if compare.factor is not None:
                        beta = integer_labels[other][len(registers[other]) - 1]
                        for r in (p, q):
                            if compare.factor % r == 0:
                                audit_relation(compare, coefficient, beta, local[r])
                                assert rough_cofactor(local[r].order, M) == 1
                                counts["direct_nonzero_annihilation_checks"] += 1
                        counts["comparison_factor"] += 1
                        stopped = True
                        break
            if stopped:
                break
        if not stopped:
            counts["completed_no_factor"] += 1
    assert counts["nonzero_label_global_infinity"] > 0
    assert counts["cross_word_comparisons"] > 0
    assert counts["direct_nonzero_annihilation_checks"] > 0
    if not stripe:
        assert counts["raw_triples"] == N**3
    return {
        "scope": "Complete raw-triple replay" if not stripe else "a=0 timing stripe",
        "N": N,
        "counts": dict(counts),
        "relation_inventory": sorted(inventory),
        "prime_support": sorted(support(inventory)),
        "actual_sampler_checks": weights,
    }


def is_prime(value: int) -> bool:
    return value >= 2 and all(value % d for d in range(2, isqrt(value) + 1))


def weighted_selection(fixture: dict) -> dict:
    data = fixture["weighted_selection"]
    X = data["X"]
    prefixes = 2 ** data["selector_bits"]
    words = data["words"]
    assert sum(w["full_prefix_multiplicity"] for w in words) == prefixes
    products = [prod(relations(set(labels(w)))) for w in words]
    tapes = []
    for M, word in zip(products, words):
        bad = {
            m for m in range(1, 3 * X + 1)
            if rough_cofactor(m, M) <= data["rough_cofactor_bound"]
        }
        tapes.append((bad, word["full_prefix_multiplicity"]))
    assert X & (X - 1) == 0
    parity_checks = {}
    for parity, numerator, denominator in (("odd", 1, 1), ("even", 3, 2)):
        intervals = (
            ((numerator * X + denominator - 1) // denominator, 21 * numerator * X // (20 * denominator)),
            ((6 * numerator * X + 5 * denominator - 1) // (5 * denominator), 5 * numerator * X // (4 * denominator)),
        )
        pools, chosen = [], []
        for lo, hi in intervals:
            rows = []
            for p in range(lo, hi + 1):
                if not is_prime(p):
                    continue
                counts = [sum((m - p - 1) ** 2 < 4 * p for m in bad) for bad, _ in tapes]
                weighted = sum(c * multiplicity for c, (_, multiplicity) in zip(counts, tapes))
                full_prefix_sum = sum(
                    counts[0 if sigma < 2 else 1] for sigma in range(prefixes)
                )
                assert weighted == full_prefix_sum
                rows.append({"prime": p, "tape_counts": counts, "weighted_numerator": weighted})
            assert rows
            least = min(rows, key=lambda row: (row["weighted_numerator"], row["prime"]))
            chosen.append(least["prime"])
            pools.append(rows)
            for bad, _ in tapes:
                incidents = sum(sum((m - p - 1) ** 2 < 4 * p for m in bad) for p in range(lo, hi + 1))
                assert incidents <= 8 * (isqrt(X) + 1) * len(bad)
        n = 2 * (X.bit_length() - 1) + (1 if parity == "odd" else 2)
        assert prod(chosen).bit_length() == n
        assert 7 * chosen[1] >= 8 * chosen[0]
        assert 4 * chosen[1] <= 5 * chosen[0]
        parity_checks[parity] = {
            "pools": pools,
            "same_pair_used_on_every_tape": chosen,
            "N": prod(chosen),
            "bit_length": n,
        }
    return {
        "scope": "Exact finite weighted averages, not asymptotic eligibility",
        "selector_prefixes": prefixes,
        "weights": [w["full_prefix_multiplicity"] for w in words],
        "both_input_length_parities": parity_checks,
    }


def shell_coverage(fixture: dict) -> dict:
    h, W = (fixture["shell_coverage"][key] for key in ("h", "W"))
    X = 2**h
    breakpoints = {X}
    for r in range(2, W + 1):
        power = r
        while power <= 4 * X:
            if power > X:
                breakpoints.add(power)
            power *= r
    assert len(breakpoints) <= 2 * W + 1
    def scalar(H: int) -> int:
        result = 1
        for r in range(2, W + 1):
            power = r
            while power <= H:
                result *= r
                power *= r
        return result
    bank = {scalar(b) for b in breakpoints}
    for H in range(X, 4 * X + 1):
        assert scalar(H) in bank
    return {"all_heights_checked": 3 * X + 1, "breakpoints": sorted(breakpoints), "scalars": sorted(bank)}


def negative_controls() -> dict:
    conditional_witness = None
    for p in (5, 7, 11, 13):
        table, _ = local_data(p)
        for (a, x, y), data in table.items():
            for alpha, beta in product(range(1, min(data.order, 12)), repeat=2):
                left, right = data.multiple(alpha), data.multiple(beta)
                if left is None or right is None:
                    continue
                if left[0] != right[0] and (left[1] + right[1]) % p == 0:
                    if (alpha + beta) % data.order and (alpha - beta) % data.order:
                        conditional_witness = {
                            "p": p, "a": a, "P": [x, y], "order": data.order,
                            "alpha": alpha, "beta": beta, "left": left, "right": right,
                        }
                        break
            if conditional_witness:
                break
        if conditional_witness:
            break
    assert conditional_witness is not None
    N = 55
    assert gcd(5 * 11, N) == N
    individual = [gcd(v, N) for v in (5, 11)]
    assert individual == [5, 11]
    return {
        "unconditional_y_sum_implication_refuted": conditional_witness,
        "whole_x_batch_requires_individual_split": individual,
        "zero_inverse_relations_excluded": 0 not in relations({0, 1, -1}),
    }


def mutation_checks(fixture: dict) -> int:
    word = fixture["words"][0]
    mutants = [json.loads(json.dumps(word)) for _ in range(4)]
    mutants[0]["labels"][4] = 1
    mutants[1]["labels"][5] = 1
    mutants[2]["gates"][2] = ["+", 1, 1]
    mutants[3]["gates"][0] = ["+", 2, 2]
    for mutant in mutants:
        try:
            labels(mutant)
        except AssertionError:
            continue
        raise AssertionError("a material signed-word mutation was accepted")
    return len(mutants)


def jacobian_check(directory: Path, fixture: dict) -> dict:
    discovery = json.loads((directory / "jacobian-discovery.json").read_text())
    contract = json.loads((directory / "jacobian-contract.json").read_text())
    result = json.loads((directory / "jacobian-output.json").read_text())
    payload = json.loads((directory / "jacobian-payload.json").read_text())
    operation = fixture["jacobian_operation"]
    assert contract["result"]["operation"]["operation_id"] == operation
    assert result["request"] == {"operation_id": operation, "payload": payload}
    assert result["result"]["operation_id"] == operation
    assert result["result"]["output"]["point"] == {
        "x": {"num": "0", "den": "1"}, "y": {"num": "-1", "den": "1"}
    }
    assert not result["result"]["output"]["at_infinity"]
    assert discovery["server"] == contract["server"] == result["server"]
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "structured_error": None,
        "timeout": False,
        "incomplete_output": False,
        "scope": "Only 2*(0,1)=(0,-1) over QQ on y^2=x^3+1",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, default=Path(__file__).with_name("signed-fixture.json"))
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--stripe", action="store_true")
    args = parser.parse_args()
    started = perf_counter()
    fixture = json.loads(args.fixture.read_text())
    result = {
        "status": "EXACT_FINITE_CHECKS_PASSED",
        "asymptotic_theorem_verified_by_this_script": False,
        "independent_reviewer_acceptance": False,
        "signed_arithmetic": audit_samples(fixture, args.stripe),
        "weighted_selection": weighted_selection(fixture),
        "shell_coverage": shell_coverage(fixture),
        "negative_controls": negative_controls(),
        "material_signed_word_mutations_rejected": mutation_checks(fixture),
        "jacobian": jacobian_check(args.fixture.parent, fixture),
    }
    result["elapsed_seconds"] = round(perf_counter() - started, 6)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "status": result["status"],
        "raw_triples": result["signed_arithmetic"]["counts"]["raw_triples"],
        "field_checks": result["signed_arithmetic"]["counts"]["independent_field_register_checks"],
        "elapsed_seconds": result["elapsed_seconds"],
        "output": str(args.output),
        "asymptotic_proof_scope": "analysis.md; not certified by finite checks",
    }))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
