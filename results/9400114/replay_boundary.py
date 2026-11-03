"""Replay scoped no-witness results without importing the construction code."""

import argparse
import json
import math
from pathlib import Path

from verify_candidate import coefficients, cyclic_product


def primes_by_trial_division(bound):
    primes = []
    for value in range(2, bound + 1):
        prime = True
        for divisor in primes:
            if divisor * divisor > value:
                break
            if value % divisor == 0:
                prime = False
                break
        if prime:
            primes.append(value)
    return primes


def factors(value):
    answer = []
    divisor = 2
    while divisor * divisor <= value:
        if value % divisor == 0:
            answer.append(divisor)
            while value % divisor == 0:
                value //= divisor
        divisor += 1
    if value > 1:
        answer.append(value)
    return answer


def require(condition, message):
    if not condition:
        raise ArithmeticError(message)


def verify_local_record(record, mode):
    p, order = record["p"], record["modulus"]
    if mode == "source":
        require(p % 5 in (2, 3), "a source prime is not primitive modulo 5")
        require(order == 10 * (p * p - 1), "wrong source modulus")
        for s in (2, 3):
            a = 1 if p % 5 == s else 3
            require(record["target_residues"][str(s)] == pow(p, a, order),
                    "wrong source residue")
        return

    inverse = pow(5, -1, p)
    identity = [(-inverse) % p] * 5
    identity[0] = (identity[0] + 1) % p
    base = [p - 1, 1, 0, 0, 0]

    def power(exponent):
        if exponent == 0:
            return identity[:]
        return coefficients(exponent, 5, p)[0]

    require(order >= 1, "nonpositive local order")
    require(power(order) == identity, "claimed order does not annihilate X-1")
    for divisor in factors(order):
        require(power(order // divisor) != identity, "claimed order is not minimal")

    width = math.isqrt(order) + 1
    baby = {}
    value = identity[:]
    for j in range(width):
        baby.setdefault(tuple(value), j)
        value = cyclic_product(value, base, p)
    step = power((-width) % order)
    for s in (2, 3):
        target = [0] * 5
        target[0] = p - 1
        target[s] = 1
        supplied = record["target_residues"][str(s)]
        if supplied is not None:
            require(0 <= supplied < order, "noncanonical local logarithm")
            require(power(supplied) == target, "local logarithm fails in the full cyclic ring")
        else:
            value = target[:]
            found = False
            for i in range(width):
                j = baby.get(tuple(value))
                if j is not None and i * width + j < order:
                    found = True
                    break
                value = cyclic_product(value, step, p)
            require(not found, "a purportedly absent local logarithm exists")


def replay_squarefree(data):
    domain = data["domain"]
    mode, bound = domain["mode"], domain["prime_bound"]
    require(mode in ("source", "orders", "source-final-prime") and domain["r"] == 5,
            "this completion argument is specific to r=5")
    free_last = mode == "source-final-prime"
    local_mode = "source" if free_last else mode
    require(data["exhausted"] is True and data["candidate"] is None,
            "this replayer requires a completed no-witness batch")
    expected_primes = [p for p in primes_by_trial_division(bound)
                       if p not in (2, 5) and (local_mode != "source" or p % 5 in (2, 3))]
    records = data["local_records"]
    require([row["p"] for row in records] == expected_primes,
            "local table omits or adds coefficient primes")
    for record in records:
        verify_local_record(record, local_mode)
    sizes = set(domain["factor_counts"])
    require(min(sizes) >= 2, "prime cases are not a counterexample domain")
    max_size = max(sizes)
    if free_last:
        require(sizes == {5} and domain["prefix_factor_count"] == 4,
                "the free-prime completion argument requires four prefix factors")
        max_size = 4
    visited = 0
    tested = 0
    free_prefixes = 0
    free_trials = 0
    for s in (2, 3):
        entries = []
        for record in records:
            b = record["target_residues"][str(s)]
            if b is not None and (b - s) % math.gcd(record["modulus"], 5) == 0:
                entries.append((record["p"], b, record["modulus"]))
        edges = [set() for _ in entries]
        for i, (p, b, m) in enumerate(entries):
            for j in range(i + 1, len(entries)):
                q, c, n = entries[j]
                if (b - c) % math.gcd(m, n):
                    continue
                if (m % q == 0 and b % q != 0) or (n % p == 0 and c % p != 0):
                    continue
                edges[i].add(j)

        def enumerate_cliques(selected, product, available):
            nonlocal visited, tested, free_prefixes, free_trials
            visited += 1
            if free_last and len(selected) == 4:
                free_prefixes += 1
                largest, b, modulus = entries[selected[-1]]
                if math.gcd(product, modulus) != 1:
                    return
                q = b * pow(product, -1, modulus) % modulus
                upper = math.isqrt(product)
                require(modulus > upper, "single-congruence completion range is not unique")
                if not largest < q <= upper:
                    return
                free_trials += 1
                if q % 2 == 0 or q % 5 not in (2, 3):
                    return
                if any(q % divisor == 0 for divisor in primes_by_trial_division(math.isqrt(q))):
                    return
                value = product * q
                exponent = 1 if q % 5 == s else 3
                own_modulus = 10 * (q * q - 1)
                valid = value % 5 == s and value % own_modulus == pow(q, exponent, own_modulus)
                valid = valid and all(value % entries[i][2] == entries[i][1] for i in selected)
                require(not valid, f"missed free-prime completion n={value}, q={q}")
                return
            if len(selected) in sizes:
                tested += 1
                valid = product % 5 == s and all(
                    product % entries[i][2] == entries[i][1] for i in selected
                )
                require(not valid, f"missed product n={product}, r=5")
            if len(selected) == max_size:
                return
            for offset, index in enumerate(available):
                tail = [j for j in available[offset + 1:] if j in edges[index]]
                enumerate_cliques(selected + [index], product * entries[index][0], tail)

        enumerate_cliques([], 1, list(range(len(entries))))
    result = {
        "mode": mode, "prime_bound": bound, "factor_counts": sorted(sizes),
        "local_records_recomputed": len(records),
        "compatible_clique_nodes": visited, "products_checked": tested,
        "boundary_replayed": True, "is_counterexample": False,
        "scope": "Only the declared finite prime pool, r=5, and factor counts.",
    }
    if free_last:
        result.update({
            "free_final_prefixes": free_prefixes,
            "single_congruence_final_prime_trials": free_trials,
            "scope": "Four source-criterion prefix primes within the declared bound; the fifth prime is unrestricted except for the derived q^2<=P bound.",
        })
    return result


def replay_prime_powers(data):
    domain = data["domain"]
    counts = {"pairs": 0, "conclusion_exclusions": 0, "norm_exclusions": 0,
              "coefficient_exclusions": 0}
    survivors = []
    lifts = []
    for p in primes_by_trial_division(domain["prime_bound"]):
        if p == 2:
            continue
        for r in domain["r_values"]:
            if math.gcd(p, r) != 1:
                continue
            counts["pairs"] += 1
            if (p * p - 1) % r == 0:
                counts["conclusion_exclusions"] += 1
                continue
            if pow(r, p - 1, p * p) != 1:
                counts["norm_exclusions"] += 1
                continue
            residual = coefficients(p, r, p * p)[2]
            survivors.append({"p": p, "r": r, "residual_mod_p_squared": residual})
            if any(residual):
                counts["coefficient_exclusions"] += 1
            else:
                lifts.append({"p": p, "r": r})
    require(counts == data["counts"], "first-lift counts disagree")
    require(survivors == data["norm_survivors"], "first-lift coefficients disagree")
    require(lifts == data["first_lift_survivors"], "first-lift survivors disagree")
    require(not lifts and data["all_exponents_excluded_in_domain"] is True,
            "unresolved first-lift survivors prevent an all-exponent boundary")
    return {
        "mode": "prime-powers", "prime_bound": domain["prime_bound"],
        "r_values": domain["r_values"], "counts": counts,
        "coefficient_survivors": len(lifts), "boundary_replayed": True,
        "is_counterexample": False,
        "scope": "All e>=2 for pure powers with the declared p bound and r list; relies on the first-lift argument in search/prime_power_lift.md.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("batches", type=Path, nargs="+")
    args = parser.parse_args()
    results = []
    for path in args.batches:
        data = json.loads(path.read_text())
        if data["domain"]["mode"] == "prime-powers":
            result = replay_prime_powers(data)
        else:
            result = replay_squarefree(data)
        result["batch"] = str(path)
        results.append(result)
    print(json.dumps({
        "results": results, "campaign_complete": False,
        "independent_reviewer_replay": "not_asserted; this is Engineer-run independent code",
    }, indent=2))


if __name__ == "__main__":
    main()
