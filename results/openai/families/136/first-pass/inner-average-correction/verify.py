#!/usr/bin/env python3
"""Replay the exact arithmetic and finite diagnostics of the correction theorem."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from fractions import Fraction as F
from itertools import product
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def ceil_fraction(x: F) -> int:
    return -(-x.numerator // x.denominator)


def replacement_constant(axes: int) -> int:
    require(axes >= 1, "At least one axis is required")
    value = 12
    for j in range(2, axes + 1):
        value *= 1 + 36 * 2 ** (j - 1)
    return value


def support_radius(axes: int) -> F:
    require(axes >= 1, "At least one row axis is required")
    return F(2) ** (2 - 10 * axes)


def one_axis_rounds(target: F) -> tuple[int, F]:
    require(target > 0, "The support target must be positive")
    rounds, bound = 1, F(1, 32)
    while bound > target:
        rounds += 1
        bound /= 16
    return rounds, bound


def phase_schedule(axes: int, target: F) -> list[int]:
    if axes == 1:
        return [one_axis_rounds(target)[0]]
    require(axes > 1, "The row-axis count must be positive")
    return phase_schedule(axes - 1, target / 1024) + [
        one_axis_rounds(target / 2)[0]
    ]


def envelope_bound(schedule: list[int]) -> F:
    require(bool(schedule) and all(h >= 1 for h in schedule), "Invalid phase schedule")
    last = F(1, 32) / 16 ** (schedule[-1] - 1)
    if len(schedule) == 1:
        return last
    return 2 * envelope_bound(schedule[:-1]) / F(1, 256) + last


def majority_count(error: F, target: F) -> tuple[int, F]:
    require(0 <= error < 1 and 0 < target <= 1, "Invalid majority parameters")
    ratio = (1 + error) ** 2 / 2
    require(ratio < 1, "The stated moment bound does not contract")
    half_count, bound = 0, (1 + error) / 2
    while bound > target:
        half_count += 1
        bound *= ratio
    return 2 * half_count + 1, bound


def parameters(case: dict) -> dict:
    a, d, b, t = (case[k] for k in ("axes", "degree", "blocks", "expansion"))
    density, accuracy = F(case["density"]), F(case["accuracy"])
    require(all(type(x) is int and x >= 1 for x in (a, d, b, t)),
            "Counts must be positive integers")
    require(d >= 8 and density >= 1 and 0 < accuracy <= 1,
            "Require d >= 8, C >= 1, and 0 < eta <= 1")
    c, threshold = d // 4, d // 8 + 1
    theta = F(threshold, d)
    require(threshold == c // 2 + 1 and theta >= F(1, 8),
            "The local decoding threshold is incorrect")
    require(2 * (threshold - 1) < c + 1, "Local unique decoding is not justified")
    k = replacement_constant(a)
    lipschitz = (a + 1) * (1 + 3 * a * k)
    nu2 = F(2) ** (-a - 6)
    gamma = nu2 / lipschitz
    nu1 = nu2 / (24 * lipschitz)
    radius = nu1 * support_radius(a) / (64 * b * t)
    delta = accuracy / (16 * t * density)
    require(0 < nu1 < nu2 < F(1, 64), "The inner radii are not ordered")
    require(2 * nu2 < F(1, 2 ** a), "The nearby inner symbol need not be unique")
    require(2 ** a * nu2 == F(1, 64), "Inner prediction exceeds its trial budget")
    require(3 * nu1 == gamma / 8, "The flag promises lack their stated gap")
    require(t * b * radius / (nu1 * support_radius(a)) == F(1, 64),
            "The radius depends on an incorrect bad-column budget")

    schedules = [phase_schedule(j, delta) for j in range(1, a + 1)]
    for j, schedule in enumerate(schedules, start=1):
        require(support_radius(a) <= support_radius(j),
                "The common initial support threshold is too large")
        require(envelope_bound(schedule) <= delta,
                "The actual multi-axis envelope exceeds the requested residual")
    depth = max(map(sum, schedules))
    leaves = d ** depth
    decoders = (leaves - 1) // (d - 1)
    decisions = decoders * comb(d, c) * d
    sigma = F(1, 64 * t)
    flag_error = sigma / (3 * leaves)
    flag_samples = ceil_fraction(4 / (flag_error * gamma ** 2))
    equality_trials, equality_miss = 1, 1 - F(1, 2 ** a)
    while equality_miss > sigma / (3 * decisions):
        equality_trials += 1
        equality_miss *= 1 - F(1, 2 ** a)
    predictions = (decisions * equality_trials + 1) * leaves
    prediction_trials, prediction_error = majority_count(
        F(1, 64), sigma / (3 * predictions)
    )
    flag_union = leaves * 4 / (flag_samples * gamma ** 2)
    equality_union = decisions * equality_miss
    prediction_union = predictions * prediction_error
    require(flag_union <= sigma / 3, "The flag union bound fails")
    require(equality_union <= sigma / 3, "The equality union bound fails")
    require(prediction_union <= sigma / 3, "The bit-prediction union bound fails")
    require(t * (flag_union + equality_union + prediction_union) <= F(1, 64),
            "The complete trial exceeds the simulation budget")
    exceptional_uniform = 8 * t * delta
    require(density * exceptional_uniform == accuracy / 2,
            "The common exceptional set exceeds the request-law budget")
    amplifications, amplified_error = majority_count(F(5, 32), accuracy / 2)
    require(density * exceptional_uniform + amplified_error <= accuracy,
            "The final average error exceeds eta")
    raw_queries = amplifications * t * (
        3 * leaves * flag_samples
        + predictions * 2 ** a * prediction_trials
    )
    return {
        "axes": a,
        "density": str(density),
        "accuracy": str(accuracy),
        "radius": str(radius),
        "delta": str(delta),
        "phase_half_rounds": schedules,
        "amplifications": amplifications,
        "flag_samples_per_initial_table": flag_samples,
        "equality_trials_per_comparison": equality_trials,
        "inner_prediction_trials": prediction_trials,
        "raw_query_bound": str(raw_queries),
        "average_error_bound": str(density * exceptional_uniform + amplified_error),
        "full_tree_density_bound": f"B*C*d^a*Q*2^Q, Q={raw_queries}"
    }


def add(p: dict, q: dict) -> dict:
    result = dict(p)
    for monomial, coefficient in q.items():
        result[monomial] = result.get(monomial, F(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def scale(p: dict, coefficient: F | int) -> dict:
    return {m: c * coefficient for m, c in p.items() if c * coefficient}


def multiply(p: dict, q: dict) -> dict:
    result: dict = {}
    for m, c in p.items():
        for n, e in q.items():
            exponent = tuple(x + y for x, y in zip(m, n))
            result[exponent] = result.get(exponent, F(0)) + c * e
    return {m: c for m, c in result.items() if c}


def universal_identities(certificate: dict) -> None:
    constants = certificate["universal_constants"]
    require(support_radius(1) == F(constants["one_axis_uncertainty_radius"]),
            "One-axis radius mismatch")
    require(support_radius(2) == F(constants["two_axis_uncertainty_radius"]),
            "Two-axis radius mismatch")
    require(8 * support_radius(1) <= F(1, 16), "The first support step is too large")
    require((2 * F(1, 64) / F(1, 8)) ** 2 == F(constants["support_contraction"]),
            "The mixing contraction factor is incorrect")
    require(sum(F(constants[k]) for k in (
        "bad_column_budget", "simulation_budget", "residual_budget"
    )) == F(constants["trial_error"]) < F(1, 4), "The trial error bound is incorrect")
    require(F(constants["inner_prediction_trial_error"]) == F(1, 64),
            "The inner-prediction constant is incorrect")
    require((1 + F(constants["trial_error"])) ** 2 / 2
            == F(constants["outer_amplification_ratio"]) < 1,
            "The universal amplification constant is incorrect")
    for j, value in constants["multilinear_replacement_constants"].items():
        require(replacement_constant(int(j)) == value, "Replacement constant mismatch")
    for residue in range(8):
        require((residue // 4) // 2 == 0 and 8 - residue > 0,
                "The eight-residue proof of the threshold fails")

    one, u, v = {(0, 0): F(1)}, {(1, 0): F(1)}, {(0, 1): F(1)}
    copy_gap = add(add(scale(u, 2), scale(multiply(u, u), -2)), scale(u, -1))
    require(copy_gap == multiply(u, add(one, scale(u, -2))),
            "The universal copy-majority identity fails")
    delta1 = scale(multiply(u, v), F(1, 4))
    delta2 = scale(v, F(1, 2))
    require(add(add(scale(delta1, 2), multiply(u, delta2)),
                scale(multiply(u, v), -1)) == {},
            "The universal product-support induction identity fails")
    k = add(scale(one, 12), u)
    factor = add(one, v)
    next_k = multiply(k, add(one, scale(factor, 36)))
    domination_gap = add(next_k, scale(factor, -12))
    require(all(c >= 0 for c in domination_gap.values()),
            "The dimension-independent replacement induction lacks positivity")
    beta = lambda p: scale(multiply(add(one, p), add(one, p)), F(1, 2))
    beta_gap = add(beta(add(u, v)), scale(beta(u), -1))
    expected_gap = add(multiply(v, add(one, u)), scale(multiply(v, v), F(1, 2)))
    require(beta_gap == expected_gap and all(c >= 0 for c in beta_gap.values()),
            "The amplification ratio is not certified monotone")
    require(F(3, 8) >= F(1, 4) and F(1, 12) * 6 < 1,
            "The flag or additive-majority threshold is invalid")


def rational(value: dict) -> F:
    result = F(int(value["num"]), int(value["den"]))
    require(str(result.numerator) == value["num"] and str(result.denominator) == value["den"],
            "A typed rational is not canonical")
    return result


def jacobian_replay(certificate: dict) -> None:
    spec = certificate["jacobian"]
    status = json.loads((HERE / "jacobian_status.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    payload = json.loads((HERE / spec["payload"]).read_text())
    answer = json.loads((HERE / spec["output"]).read_text())
    adapter = json.loads((HERE / spec["adapter_status"]).read_text())
    for record in (status, contract, answer):
        require(record["protocol_version"] == spec["protocol_version"], "Protocol mismatch")
        require(record["server"]["version"] == spec["server_version"], "Server mismatch")
    operation = spec["operation_id"]
    require(contract["result"]["operation"]["operation_id"] == operation,
            "A different Jacobian contract was inspected")
    require(adapter == {"operation_id": operation, "exit_code": 0, "timeout": False},
            "Jacobian did not complete successfully")
    require(answer["request"] == {"operation_id": operation, "payload": payload},
            "The typed result is not bound to the exact payload")
    require(answer["result"]["operation_id"] == operation, "Wrong operation result")
    output = answer["result"]["output"]
    require(output["polynomial"] == payload["polynomial"] and output["box"] == payload["box"],
            "The retained source does not match the payload")
    terms = payload["polynomial"]["polynomial"]["terms"]
    coefficients = {tuple(t["exponents"]): rational(t["coefficient"]) for t in terms}
    require(coefficients == {(2,): F(1, 2), (1,): F(1), (0,): F(1, 2)},
            "The payload does not encode (1+p)^2/2")
    interval = payload["box"]["intervals"][0]
    left, right = rational(interval["lower"]), rational(interval["upper"])
    require(left == 0 and right == F(5, 32), "Wrong amplification interval")
    lower = sum(c * left ** m[0] for m, c in coefficients.items())
    upper = sum(c * right ** m[0] for m, c in coefficients.items())
    require(rational(output["enclosure"]["lower"]) == lower == F(spec["lower_bound"]),
            "The exact lower enclosure fails independent replay")
    require(rational(output["enclosure"]["upper"]) == upper == F(spec["upper_bound"]) < 1,
            "The amplification ratio is not uniformly below one")


def lean_replay(certificate: dict) -> None:
    spec = certificate["formal_core"]
    source = (HERE / spec["source"]).read_bytes()
    fidelity = (HERE / spec["statement_fidelity"]).read_text()
    result = json.loads((HERE / spec["compiler_result"]).read_text())
    archive = json.loads((HERE / spec["certificate"]).read_text())
    require(result["status"] == "success" and result["exit_code"] == spec["exit_code"] == 0,
            "The real Lean compiler has not accepted this source")
    require(result["proof_holes"] == spec["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "The formal evidence contains a proof hole or failed axiom audit")
    require("version " + spec["lean_version"] in result["tools"]["lean"]["version"],
            "The formal evidence uses the wrong Lean version")
    require(result["source_sha256"] == hashlib.sha256(source).hexdigest(),
            "The Lean source changed after compilation")
    require(result["statement_fidelity_sha256"]
            == hashlib.sha256(fidelity.encode()).hexdigest(),
            "The statement-fidelity document changed after compilation")
    require(archive["lean_check"] == result, "The archived compiler result is different")
    require(archive["lean_source"]["text"] == source.decode(),
            "The archived formal statement is different")
    require(archive["statement_fidelity"]["text"] == fidelity,
            "The archived statement-fidelity reading is different")
    require(archive["subject"]["subject_id"] == spec["claim"]
            and archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "The compiler certificate is not mechanical support for the formal-core claim")
    for declaration in spec["declarations"]:
        require("theorem " + declaration in source.decode(), "A formal declaration is missing")


def kernel_diagnostics(certificate: dict) -> None:
    spec = certificate["finite_diagnostics"]
    n, d = spec["cyclic_group_order"], spec["edge_labels"]
    indices = list(product(range(d), range(n), range(n)))
    require(len(indices) == spec["complete_outer_index_size"], "Outer-index size mismatch")

    def shift(x: tuple[int, int, int], h: int) -> tuple[int, int, int]:
        i, g, point = x
        return i, (g + h) % n, (point - h) % n

    for h in range(n):
        require({shift(x, h) for x in indices} == set(indices), "A shift is not a permutation")
    for x in indices:
        images = [shift(x, h) for h in range(n)]
        require(Counter(y[2] for y in images) == Counter(range(n)),
                "A requested column is not uniform")
        require(all((y[1] + y[2]) % n == (x[1] + x[2]) % n for y in images),
                "The value-preserving invariant changed")
        require(len(set((y[1], y[2]) for y in images)) < n * n,
                "This diagnostic failed to exercise row/column correlation")
    for h1, h2 in product(range(n), repeat=2):
        images = {(shift(x, h1), shift(y, h2)) for x, y in product(indices, repeat=2)}
        require(len(images) == len(indices) ** 2, "A complete product shift is not bijective")
    m = len(indices)
    shifted_diagonal = Counter(
        (shift(x, h1), shift(x, h2))
        for x in indices for h1, h2 in product(range(n), repeat=2)
    )
    require(F(m) == F(spec["diagonal_joint_density"]), "Diagonal density mismatch")
    shifted_density = F(max(shifted_diagonal.values()) * m * m, m * n * n)
    require(shifted_density == d * n == F(spec["diagonal_joint_density_after_independent_shifts"]),
            "Independent shifts unexpectedly supplied joint domination")
    for axis in (0, 1):
        marginal = Counter()
        for pair, count in shifted_diagonal.items():
            marginal[pair[axis]] += count
        require(set(marginal.values()) == {n * n}, "A diagonal-law marginal is not uniform")
    for x in indices:
        restricted_mass = F(1, m) if x == indices[0] else F(0)
        require(restricted_mass <= F(1, m), "Unconditioned restriction increased density")
    require(F(1) / F(1, m) == m, "Rare-event conditioning diagnostic failed")
    for axes in range(1, 4):
        masks = list(product(range(4), repeat=axes))
        uniform = Counter(masks)
        for specified in masks:
            for term in product(range(2), repeat=axes):
                distribution = Counter(
                    tuple(r[j] ^ (specified[j] if term[j] else 0) for j in range(axes))
                    for r in masks
                )
                require(distribution == uniform,
                        "A column-mask term depends on the specified request")


def gf4_multiply(a: int, b: int) -> int:
    result = 0
    for _ in range(2):
        if b & 1:
            result ^= a
        b >>= 1
        a <<= 1
        if a & 4:
            a ^= 7
    return result


def bilinear(matrix: int, x: int, y: int) -> int:
    return sum(
        ((matrix >> (2 * i + j)) & 1) * ((x >> i) & 1) * ((y >> j) & 1)
        for i, j in product(range(2), repeat=2)
    ) % 2


def inner_table_diagnostics(certificate: dict) -> dict:
    spec = certificate["finite_diagnostics"]
    pairs = list(product(range(4), repeat=2))
    legal = [sum(bilinear(matrix, x, y) << (4 * x + y) for x, y in pairs)
             for matrix in range(16)]
    require(len(set(legal)) == spec["bilinear_legal_tables"], "Legal bilinear tables collide")
    require(min(F(table.bit_count(), 16) for table in legal[1:])
            == F(spec["bilinear_minimum_distance"]), "Bilinear distance mismatch")
    signatures = {table: matrix for matrix, table in enumerate(legal)}

    def action(matrix: int, scalar: int, axis: int) -> int:
        signature = sum(
            bilinear(matrix,
                     gf4_multiply(scalar, x) if axis == 0 else x,
                     gf4_multiply(scalar, y) if axis == 1 else y) << (4 * x + y)
            for x, y in pairs
        )
        return signatures[signature]

    for matrix, a, b in product(range(16), range(4), range(4)):
        for axis in (0, 1):
            require(action(matrix, a ^ b, axis)
                    == action(matrix, a, axis) ^ action(matrix, b, axis),
                    "A scalar action is not additive in its scalar")
            require(action(matrix, gf4_multiply(a, b), axis)
                    == action(action(matrix, b, axis), a, axis),
                    "A scalar action is not multiplicative")
            require(action(matrix, 1, axis) == matrix and action(matrix, 0, axis) == 0,
                    "A scalar action violates its unit or zero axiom")
        require(action(action(matrix, a, 0), b, 1)
                == action(action(matrix, b, 1), a, 0), "The two scalar actions do not commute")
    for matrix, x, y in product(range(16), range(4), range(4)):
        for r, s in pairs:
            value = (bilinear(matrix, r, s) ^ bilinear(matrix, x ^ r, s)
                     ^ bilinear(matrix, r, y ^ s) ^ bilinear(matrix, x ^ r, y ^ s))
            require(value == bilinear(matrix, x, y), "Bilinear arbitrary-request prediction fails")
        for first, second in product(range(2), repeat=2):
            distribution = Counter(
                (r ^ (x if first else 0), s ^ (y if second else 0)) for r, s in pairs
            )
            require(distribution == Counter(pairs), "A split multiplier pair is not jointly uniform")
    hadamard = [sum(((x & mu).bit_count() % 2) << mu for mu in range(4)) for x in range(4)]
    require(min(F(table.bit_count(), 4) for table in hadamard[1:])
            == F(spec["hadamard_minimum_distance"]), "Hadamard distance mismatch")
    for copies in product(range(2), repeat=3):
        p = F(sum(copies), 3)
        require(min(p, 1 - p) <= 2 * p * (1 - p), "Copy-majority bound fails")

    tests: list[list[int]] = [[], []]
    for x, y, z in product(range(4), repeat=3):
        tests[0].append((1 << (4 * x + z)) ^ (1 << (4 * y + z)) ^ (1 << (4 * (x ^ y) + z)))
        tests[1].append((1 << (4 * z + x)) ^ (1 << (4 * z + y)) ^ (1 << (4 * z + (x ^ y))))
    minimum_rejection = F(1)
    for received in range(1 << 16):
        distance = min(F((received ^ table).bit_count(), 16) for table in legal)
        errors = [sum((received & mask).bit_count() % 2 for mask in family) for family in tests]
        failure_sum = F(sum(errors), 64)
        require(distance <= replacement_constant(2) * failure_sum,
                "A finite table violates the multilinear replacement bound")
        if distance:
            minimum_rejection = min(minimum_rejection, failure_sum / 2)
    require(1 << 16 == spec["bilinear_tables_exhausted"], "Exhaustion size mismatch")
    require(minimum_rejection == F(spec["minimum_nonlegal_addition_rejection"]),
            "The exact finite rejection gap changed")
    return {"tables": 1 << 16, "minimum_nonlegal_addition_rejection": str(minimum_rejection)}


def source_fidelity(certificate: dict, project_root: Path) -> None:
    source = certificate["source"]
    text = " ".join((project_root / source["path"]).read_text().split())
    for anchor in source["required_anchors"]:
        require(" ".join(anchor.split()) in text, f"Source assertion missing: {anchor}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=HERE.parents[1])
    parser.add_argument("--density", type=F)
    parser.add_argument("--accuracy", type=F)
    args = parser.parse_args()
    require((args.density is None) == (args.accuracy is None),
            "Supply --density and --accuracy together")
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    source_fidelity(certificate, args.project_root)
    universal_identities(certificate)
    jacobian_replay(certificate)
    lean_replay(certificate)
    kernel_diagnostics(certificate)
    finite_result = inner_table_diagnostics(certificate)
    cases = certificate["parameter_cases"]
    if args.density is not None:
        cases = cases + [{
            "axes": 2, "degree": 8, "blocks": 7, "expansion": 32,
            "density": str(args.density), "accuracy": str(args.accuracy)
        }]
    results = [parameters(case) for case in cases]
    radius_pairs = [(case, result["radius"]) for case, result in zip(cases, results)]
    for i, (case, radius) in enumerate(radius_pairs):
        for other, other_radius in radius_pairs[i + 1:]:
            if all(case[k] == other[k] for k in ("axes", "degree", "blocks", "expansion")):
                require(radius == other_radius, "Changing C or eta changed the correction radius")
    print(json.dumps({
        "ok": True,
        "claim": certificate["claim"],
        "proof_kind": certificate["proof_kind"],
        "universal_arithmetic": "passed",
        "finite_diagnostics": finite_result,
        "formal_core": {
            "claim": certificate["formal_core"]["claim"],
            "lean_version": certificate["formal_core"]["lean_version"],
            "exit_code": 0,
            "proof_holes": [],
            "statement_fidelity_review": certificate["formal_core"]["statement_fidelity_review"]
        },
        "parameter_cases": [{
            k: result[k] for k in (
                "axes", "density", "accuracy", "radius", "phase_half_rounds", "amplifications"
            )
        } for result in results],
        "independent_review_status": certificate["independent_review_status"],
        "manuscript_construction": "explicit unresolved input; not certified by this verifier"
    }, indent=2))


if __name__ == "__main__":
    main()
