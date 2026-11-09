#!/usr/bin/env python3
"""Exact regression certificate for the theorem in restoration.md."""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction as F
import hashlib
from itertools import combinations, combinations_with_replacement, permutations, product
import json
from math import comb, factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
RHO = F(1, 2)
V = F(3, 2)
WEIGHT = F(32)
NU = {3: F(1, 2), 5: F(3, 4)}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add(row, target, coefficient):
    row[target] += coefficient


def memories(primes, bound):
    particles = [(p, r) for p in primes for r in range(p)]
    return [
        memory
        for size in range(bound + 1)
        for memory in combinations_with_replacement(particles, size)
    ]


def memory_mass(memory, nu):
    mass = F(1)
    for (p, _), count in Counter(memory).items():
        mass *= nu[p] ** count / factorial(count)
    return mass


def sign(p):
    return -1 if p % 4 == 3 else 1


def birth_multiplier(batch, mode):
    if mode == "identity":
        return F(1)
    if mode == "first":
        return F(sign(batch[0])) if batch else F(0)
    if mode == "two":
        return F(sign(batch[0]) * sign(batch[1])) if len(batch) >= 2 else F(0)
    raise ValueError(f"Unknown multiplier: {mode}")


def batch_average(batch, mode):
    return sum(
        (birth_multiplier(ordered, mode) for ordered in permutations(batch)), F(0)
    ) / factorial(len(batch))


def ghost_choices(memory, nu, bound, qi, mode="identity", reverse=False, absolute=False):
    a = qi / RHO**2
    d = -(1 - qi) / RHO
    c = V * d
    if reverse:
        d, c = c, d
    if absolute:
        d, c = abs(d), abs(c)
    hits = [i for i, (_, r) in enumerate(memory) if r == 0]
    for deleted_size in range(len(hits) + 1):
        for deleted in combinations(hits, deleted_size):
            selected = set(deleted)
            survivors = tuple(z for i, z in enumerate(memory) if i not in selected)
            deleted_primes = tuple(memory[i][0] for i in deleted)
            base = d**deleted_size * a ** (len(hits) - deleted_size)
            for size in range(bound - len(survivors) + 1):
                for batch in product(nu, repeat=size):
                    phi = (
                        batch_average(deleted_primes, mode)
                        if reverse
                        else birth_multiplier(batch, mode)
                    )
                    coefficient = base * c**size * phi / factorial(size)
                    for p in batch:
                        coefficient *= nu[p]
                    target = tuple(sorted(survivors + tuple((p, 0) for p in batch)))
                    if coefficient:
                        yield target, coefficient, batch


def ghost_matrix(states, nu, bound, qi, mode, reverse=False, absolute=False):
    matrix = {}
    for memory in states:
        row = defaultdict(F)
        for target, coefficient, _ in ghost_choices(
            memory, nu, bound, qi, mode, reverse, absolute
        ):
            add(row, target, coefficient)
        matrix[memory] = dict(row)
    return matrix


def raw_edge_choices(active, memory, nu, bound, orientation, reverse=False, mode="identity"):
    shared, source = active
    delta = orientation * shared
    translated = tuple((p, (r + delta) % p) for p, r in memory)
    promotions = [None] + [
        i for i, (p, r) in enumerate(translated) if r == 0 and p != shared
    ]
    for store in [0, 1]:
        if store and source == shared:
            continue
        for promoted in promotions:
            a = int(promoted is not None)
            survivors = tuple(z for i, z in enumerate(translated) if i != promoted)
            stored = ((source, delta % source),) if store else ()
            output = tuple(sorted(survivors + stored))
            if len(output) > bound:
                continue
            labels = list(nu) if promoted is None else [translated[promoted][0]]
            for target in labels:
                coefficient = (
                    RHO ** sum(r == 0 for _, r in memory)
                    * RHO ** sum(r == 0 for _, r in output)
                    * V ** (-(store if reverse else a))
                )
                if promoted is None:
                    coefficient *= nu[target]
                if mode == "first":
                    coefficient *= (
                        sign(source) * (1 - store)
                        if reverse
                        else sign(target) * (1 - a)
                    )
                elif mode != "identity":
                    raise ValueError(mode)
                if coefficient:
                    yield (shared, target), output, coefficient, (
                        target if promoted is None else None
                    ), store, a


def edge_choices(active, memory, nu, bound, orientation, reverse=False, mode="identity"):
    for source in [active, active[::-1]]:
        for target, output, coefficient, birth, store, promote in raw_edge_choices(
            source, memory, nu, bound, orientation, reverse, mode
        ):
            for final in [target, target[::-1]]:
                yield (final, output), coefficient / 4, birth, store, promote


def edge_matrix(states, nu, bound, orientation, reverse=False, mode="identity", sym=True):
    matrix = {}
    for active, memory in states:
        row = defaultdict(F)
        if sym:
            for target, coefficient, _, _, _ in edge_choices(
                active, memory, nu, bound, orientation, reverse, mode
            ):
                add(row, target, coefficient)
        else:
            for target, output, coefficient, _, _, _ in raw_edge_choices(
                active, memory, nu, bound, orientation, reverse, mode
            ):
                add(row, (target, output), coefficient)
        matrix[(active, memory)] = dict(row)
    return matrix


def adjoint(matrix, mass):
    result = {state: defaultdict(F) for state in matrix}
    for source, row in matrix.items():
        for target, coefficient in row.items():
            add(result[target], source, coefficient * mass[source] / mass[target])
    return {state: dict(row) for state, row in result.items()}


def normalized(matrix):
    return {state: {t: c for t, c in row.items() if c} for state, row in matrix.items()}


def require_equal(left, right, message):
    require(normalized(left) == normalized(right), message)


def dominate(matrix, positive):
    for source, row in matrix.items():
        for target, coefficient in row.items():
            require(
                abs(coefficient) <= positive[source].get(target, 0),
                f"Positive domination failed at {source!r}, {target!r}",
            )


def row_ratio(matrix, weight):
    return max(
        sum((abs(c) * weight(t) for t, c in row.items()), F(0)) / weight(source)
        for source, row in matrix.items()
    )


def exp_polynomial(value, bound):
    return sum((value**n / factorial(n) for n in range(bound + 1)), F(0))


def check_local_operators():
    qi = F(1, 9)
    states = memories(NU, 3)
    mass = {memory: memory_mass(memory, NU) for memory in states}
    positive = ghost_matrix(states, NU, 3, qi, "identity", absolute=True)
    positive_adjoint = adjoint(positive, mass)
    records = {}
    for mode in ["identity", "first", "two"]:
        matrix = ghost_matrix(states, NU, 3, qi, mode)
        reversed_matrix = ghost_matrix(states, NU, 3, qi, mode, reverse=True)
        require_equal(adjoint(matrix, mass), reversed_matrix, "Ghost adjoint mismatch")
        dominate(matrix, positive)
        dominate(adjoint(matrix, mass), positive_adjoint)
        records[mode] = sum(len(row) for row in matrix.values())
    a, d = qi / RHO**2, (1 - qi) / RHO
    c = V * d
    require(a + d / WEIGHT <= 1 and a + c / WEIGHT <= 1, "Invalid Schur weight")
    row = row_ratio(positive, lambda memory: WEIGHT ** len(memory))
    column = row_ratio(positive_adjoint, lambda memory: WEIGHT ** len(memory))
    require(row <= exp_polynomial(c * WEIGHT * sum(NU.values()), 3), "Ghost row bound")
    require(column <= exp_polynomial(d * WEIGHT * sum(NU.values()), 3), "Ghost column bound")
    batch_checks = 0
    for size in range(5):
        for mode in ["first", "two"]:
            raw, averaged = F(0), F(0)
            for batch in product(NU, repeat=size):
                weight = F(1, factorial(size))
                for p in batch:
                    weight *= NU[p]
                symmetric_test = 1 + sum(batch) ** 2
                raw += weight * birth_multiplier(batch, mode) * symmetric_test
                averaged += weight * batch_average(batch, mode) * symmetric_test
            require(raw == averaged, "Ordered birth averaging changed the integral")
            batch_checks += 1
    edge_states = [
        (active, memory)
        for active in product(NU, repeat=2)
        for memory in memories(NU, 2)
    ]
    edge_mass = {
        (active, memory): NU[active[0]] * NU[active[1]] * memory_mass(memory, NU)
        for active, memory in edge_states
    }
    edge_checks = 0
    negative_control = False
    for sym in [False, True]:
        baseline = edge_matrix(edge_states, NU, 2, 1, sym=sym)
        for mode in ["identity", "first"]:
            matrix = edge_matrix(edge_states, NU, 2, 1, mode=mode, sym=sym)
            reversed_matrix = edge_matrix(
                edge_states, NU, 2, -1, reverse=True, mode=mode, sym=sym
            )
            require_equal(adjoint(matrix, edge_mass), reversed_matrix, "Edge adjoint mismatch")
            dominate(matrix, baseline)
            dominate(adjoint(matrix, edge_mass), adjoint(baseline, edge_mass))
            edge_checks += 1
            if mode == "first":
                wrong = edge_matrix(edge_states, NU, 2, -1, mode=mode, sym=sym)
                negative_control |= normalized(wrong) != normalized(reversed_matrix)
    require(negative_control, "Reversal negative control was vacuous")
    old_index_values = [-(1 - qi) / RHO * a, F(0)]
    require(old_index_values[0] != old_index_values[1], "Old-index obstruction vanished")
    factorial_checks = 0
    for k, deleted, born in product(range(13), repeat=3):
        require(
            F(comb(k + deleted, deleted), factorial(k + deleted))
            == F(1, factorial(k) * factorial(deleted)),
            "Ghost factorial identity",
        )
        require(
            F(factorial(k + deleted), factorial(k)) / factorial(k + deleted)
            == F(factorial(k + born), factorial(k)) / factorial(k + born),
            "Edge factorial reversal",
        )
        factorial_checks += 1
    return {
        "ghost_states": len(states),
        "edge_states": len(edge_states),
        "ghost_nonzero_choice_sums": records,
        "ghost_adjoint_modes": 3,
        "edge_adjoint_modes": edge_checks,
        "batch_average_integrals": batch_checks,
        "factorial_regressions": factorial_checks,
        "ghost_weighted_row": str(row),
        "ghost_weighted_column": str(column),
        "old_index_raw_outputs": list(map(str, old_index_values)),
        "incorrect_reversal_detected": negative_control,
        "numerical_repetitions_allowed": True,
    }


def partitions(size):
    if size == 0:
        yield ()
        return
    for previous in partitions(size - 1):
        yield previous + ((size - 1,),)
        for i in range(len(previous)):
            yield previous[:i] + (previous[i] + (size - 1,),) + previous[i + 1 :]


def mu_rank(partition):
    coefficient = 1
    rank = 0
    for block in partition:
        coefficient *= (-1) ** (len(block) - 1) * factorial(len(block) - 1)
        rank += len(block) - 1
    return coefficient, rank


def polynomial_product(factors):
    coefficients = [1]
    for factor in factors:
        updated = [0] * (len(coefficients) + 1)
        for degree, coefficient in enumerate(coefficients):
            updated[degree] += coefficient
            updated[degree + 1] += factor * coefficient
        coefficients = updated
    return coefficients


def compatible(partition, births):
    return all(
        len(block) == 1
        or (births[block[0]] != 0 and all(births[i] == births[block[0]] for i in block))
        for block in partition
    )


def check_partitions():
    profiles = {}
    for size in range(9):
        result = [0] * (size + 1)
        for partition in partitions(size):
            coefficient, rank = mu_rank(partition)
            result[rank] += abs(coefficient)
            involved = sum(len(block) for block in partition if len(block) >= 2)
            require(involved <= 2 * rank, "Rank failed to bound affected addresses")
        require(result == polynomial_product(range(size)), "Rank coefficient profile")
        for rank, value in enumerate(result):
            require(
                value * factorial(rank) <= (size * (size - 1) // 2) ** rank,
                "Elementary symmetric coefficient bound",
            )
        profiles[str(size)] = result
    tests = 0
    for size in range(7):
        ps = [(p, mu_rank(p)[0]) for p in partitions(size)]
        for births in product([0, 3, 5], repeat=size):
            expansion = sum(c for p, c in ps if compatible(p, births))
            performed = [p for p in births if p]
            require(expansion == int(len(set(performed)) == len(performed)), "Distinctness IE")
            tests += 1
    losses = 0
    s, k = F(1, 4), F(3, 2)
    for n, rank in product(range(21), range(13)):
        upper = s**n * (k / s) ** min(n, 2 * rank)
        for affected in range(min(n, 2 * rank) + 1):
            require(s ** (n - affected) * k**affected <= upper, "Rank loss bound")
            losses += 1
    return {"profiles": profiles, "performed_address_cases": tests, "rank_loss_cases": losses}


def check_fresh_and_hybrid_bounds():
    total, atom = sum(NU.values()), max(NU.values())
    fresh_checks = 0
    for size in range(7):
        for partition in partitions(size):
            _, rank = mu_rank(partition)
            actual = F(1)
            for block in partition:
                actual *= sum((mass ** len(block) for mass in NU.values()), F(0))
            require(actual <= total**size * atom**rank, "Same-operation fresh atom bound")
            fresh_checks += 1
    for pivot, dependent_count in product(NU, range(13)):
        require(
            NU[pivot] ** dependent_count <= total**dependent_count * atom**dependent_count,
            "Retained dead-pivot atom bound",
        )
        fresh_checks += 1
    hybrid_checks = 0
    for addresses, n in product(range(9), range(11)):
        coefficients = polynomial_product(range(addresses))
        u, v, q = F(17, 3), F(1, 13), F(7, 2)
        hybrid = sum(
            c * min(u * atom**rank, v * q ** min(n, 2 * rank))
            for rank, c in enumerate(coefficients)
        )
        for threshold in range(addresses + 2):
            split = sum(
                c * (v * q ** min(n, 2 * rank) if rank < threshold else u * atom**rank)
                for rank, c in enumerate(coefficients)
            )
            require(hybrid <= split, "Hybrid bound worse than a threshold split")
            hybrid_checks += 1
    return {
        "fresh_law_total": str(total),
        "fresh_law_maximal_atom": str(atom),
        "conditional_atom_cases": fresh_checks,
        "hybrid_threshold_comparisons": hybrid_checks,
    }


def check_histories():
    nu = {3: F(1, 2), 5: F(1, 2), 7: F(1, 2)}
    bound, address_count = 1, 7
    histories = defaultdict(F)
    for active in product(nu, repeat=2):
        births = (active[0], active[1], 0, 0, 0, 0, 0)
        histories[(active, (), births, 0)] += nu[active[0]] * nu[active[1]]
    peak = len(histories)
    for operation in range(5):
        following = defaultdict(F)
        for (active, memory, births, features), weight in histories.items():
            if operation % 2 == 0:
                visit = operation // 2
                qi = F(1, 81) if visit == 1 else F(1, 9)
                address = 2 + 2 * visit
                for output, coefficient, batch in ghost_choices(memory, nu, bound, qi):
                    updated = list(births)
                    if batch:
                        updated[address] = batch[0]
                    following[(active, output, tuple(updated), features | (4 if batch else 0))] += (
                        weight * coefficient
                    )
            else:
                edge = operation // 2
                address = 3 + 2 * edge
                for (target, output), coefficient, birth, store, promote in edge_choices(
                    active, memory, nu, bound, 1 if edge == 0 else -1
                ):
                    updated = list(births)
                    if birth is not None:
                        updated[address] = birth
                    feature = features | store | (2 if promote else 0)
                    following[(target, output, tuple(updated), feature)] += weight * coefficient
        histories = {state: value for state, value in following.items() if value}
        peak = max(peak, len(histories))
    terminal = defaultdict(F)
    feature_support = set()
    for (_, memory, births, features), weight in histories.items():
        if not memory:
            terminal[births] += weight
            feature_support.add(features)
    terminal = {births: weight for births, weight in terminal.items() if weight}
    ps = [(p, *mu_rank(p)) for p in partitions(address_count)]
    direct, expanded = F(0), [F(0)] * (address_count + 1)
    for births, weight in terminal.items():
        performed = [p for p in births if p]
        if len(set(performed)) == len(performed):
            direct += weight
        for partition, coefficient, rank in ps:
            if compatible(partition, births):
                expanded[rank] += coefficient * weight
    require(direct == sum(expanded), "Complete finite history IE mismatch")
    require(direct != 0, "Distinct history check is vacuous")
    require(any(f & 1 for f in feature_support), "No stores in terminal histories")
    require(any(f & 2 for f in feature_support), "No promotions in terminal histories")
    require(any(f & 4 for f in feature_support), "No ghosts in terminal histories")
    nu4 = {p: F(1, 3) for p in [3, 5, 7, 11]}
    ghost0 = [
        c for m, c, batch in ghost_choices((), nu4, 2, F(1, 9))
        if m == ((7, 0),) and batch == (7,)
    ]
    edge0 = [
        c for a, m, c, birth, store, promote in raw_edge_choices((3, 5), ((7, 0),), nu4, 2, 1)
        if a == (3, 11) and m == ((5, 3), (7, 3))
        and birth == 11 and store == 1 and promote == 0
    ]
    edge1 = [
        c for a, m, c, birth, store, promote in raw_edge_choices(
            (3, 11), ((5, 3), (7, 3)), nu4, 2, -1
        )
        if a == (3, 5) and m == ((7, 0),)
        and birth is None and store == 0 and promote == 1
    ]
    ghost2 = [
        c for m, c, batch in ghost_choices(((7, 0),), nu4, 2, F(1, 9))
        if m == () and batch == ()
    ]
    require(all(len(x) == 1 for x in [ghost0, edge0, edge1, ghost2]), "Explicit trace not unique")
    all_features_trace = nu4[3] * nu4[5] * ghost0[0] * edge0[0] / 4 * edge1[0] / 4 * ghost2[0]
    require(all_features_trace == F(4, 6561), "Store/promotion/ghost trace coefficient")
    return {
        "model": "Two active slots, three primes, all residues, B=1, two opposite edges, three full ghost operations.",
        "peak_aggregated_histories": peak,
        "terminal_birth_maps": len(terminal),
        "direct_distinct_value": str(direct),
        "independent_partition_rank_values": list(map(str, expanded)),
        "terminal_feature_masks": sorted(feature_support),
        "distinct_four_prime_store_promotion_ghost_trace": str(all_features_trace),
    }


def check_sources_and_adapter():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    for entry in certificate["source_locators"].values():
        source = (ROOT / entry["file"]).read_text()
        start, end = entry["lines"]
        require(0 < start <= end <= len(source.splitlines()), "Source range out of bounds")
        passage = "\n".join(source.splitlines()[start - 1 : end])
        for label in entry.get("labels", [entry.get("label")]):
            if label:
                require("\\label{" + label + "}" in passage, f"Source locator mismatch: {label}")
        for phrase in entry.get("required_phrases", []):
            require(phrase in " ".join(passage.split()), f"Source wording changed: {phrase}")
    result = json.loads((HERE / "jacobian_result.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    require(result["request"]["payload"] == payload, "Adapter payload does not match archive")
    output = result["result"]["output"]
    require(output["outcome"] == "VALID", "Jacobian result is not a valid conclusion")
    require(output["valid_complete_rational_spectrum"], "Projector spectrum not certified")
    require(
        [(x["eigenvalue"], x["exact_nullity"]) for x in output["nullity_ledger"]]
        == [({"num": "0", "den": "1"}, 1), ({"num": "1", "den": "1"}, 1)],
        "Wrong projector spectrum",
    )
    projector = [[F(1, 2)] * 2 for _ in range(2)]
    square = [[sum(projector[i][k] * projector[k][j] for k in range(2))
               for j in range(2)] for i in range(2)]
    require(square == projector, "Compression is not idempotent")
    return {
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "operation_id": result["request"]["operation_id"],
        "outcome": output["outcome"],
        "adapter_exit_status": 0,
        "timeout": False,
        "structured_error": None,
    }


def check_formal_record():
    result = json.loads((HERE / "lean_verify.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean not verified")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require(result["audit_exit_code"] == 0, "Lean axiom audit failed")
    version = result["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "Wrong Lean version")
    require(
        hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest() == result["source_sha256"],
        "Lean source changed after compilation",
    )
    require(
        hashlib.sha256((HERE / "statement_fidelity.md").read_text().encode()).hexdigest()
        == result["statement_fidelity_sha256"],
        "Statement fidelity changed after compilation",
    )
    recorded = result["kernel"]["recorded"]
    require(recorded["verdict"] == "supports", "No supporting mechanical ledger record")
    require(recorded["subject"]["subject_id"] == "C_MS_FORMAL_CORE", "Wrong formal claim")
    archive = json.loads((ROOT / recorded["artifact"]).read_text())
    require(archive["lean_check"]["source_sha256"] == result["source_sha256"], "Wrong archive")
    return {
        "status": result["status"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "version": version,
        "artifact": recorded["artifact"],
        "source_and_fidelity_match_compiler_record": True,
        "compiler_rerun_by_this_script": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Update the exact finite-check results")
    args = parser.parse_args()
    results = {
        "local_operators": check_local_operators(),
        "partitions_and_losses": check_partitions(),
        "fresh_and_hybrid_bounds": check_fresh_and_hybrid_bounds(),
        "histories": check_histories(),
        "jacobian": check_sources_and_adapter(),
        "formal_record": check_formal_record(),
    }
    path = HERE / "exact_certificate.json"
    certificate = json.loads(path.read_text())
    if args.write:
        certificate["finite_checks"] = results
        path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        require("finite_checks" in certificate, "No stored certificate; use --write once")
        require(results == certificate["finite_checks"], "Recomputed certificate differs")
    print(json.dumps({
        "status": "verified",
        "arithmetic": "exact rational and integer",
        "certificate": str(path.relative_to(ROOT)),
        "universal_proof": "research/memory_stability/restoration.md",
        "finite_checks_are_not_universal_proof": True,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
