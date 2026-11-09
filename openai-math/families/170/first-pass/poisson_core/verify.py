#!/usr/bin/env python3
"""Exact algebra and source-bound formal-core replay; not a full theorem prover."""

import hashlib
import itertools
import json
from fractions import Fraction as Q
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def add(*polys):
    result = {}
    for poly in polys:
        for powers, coefficient in poly.items():
            result[powers] = result.get(powers, Q(0)) + coefficient
    return {powers: c for powers, c in result.items() if c}


def scale(poly, coefficient):
    return {powers: c * coefficient for powers, c in poly.items() if c * coefficient}


def multiply(left, right):
    result = {}
    for a, ca in left.items():
        for b, cb in right.items():
            powers = tuple(x + y for x, y in zip(a, b, strict=True))
            result[powers] = result.get(powers, Q(0)) + ca * cb
    return {powers: c for powers, c in result.items() if c}


def constant(nvars, value):
    return {(0,) * nvars: Q(value)} if value else {}


def variable(nvars, index):
    powers = [0] * nvars
    powers[index] = 1
    return {tuple(powers): Q(1)}


def product(polys, nvars):
    result = constant(nvars, 1)
    for poly in polys:
        result = multiply(result, poly)
    return result


def mixed_union_polynomial(blocks, natoms):
    nvars = natoms + 1
    result = {}
    for chosen in itertools.product((False, True), repeat=len(blocks)):
        union = set()
        for block, take in zip(blocks, chosen, strict=True):
            if take:
                union.update(block)
        exponent = [0] * nvars
        exponent[0] = len(blocks) - sum(chosen)
        for atom in union:
            exponent[atom + 1] = 1
        result = add(result, {tuple(exponent): Q((-1) ** exponent[0])})
    return result


def mixed_hit_polynomial(blocks, natoms):
    nvars = natoms + 1
    one = constant(nvars, 1)
    b = variable(nvars, 0)
    z = [variable(nvars, i + 1) for i in range(natoms)]
    result = {}
    for pattern in itertools.product((False, True), repeat=natoms):
        hits = {i for i, hit in enumerate(pattern) if hit}
        probability = product(
            [add(one, scale(z[i], -1)) if hit else z[i]
             for i, hit in enumerate(pattern)], nvars
        )
        factors = [
            add(constant(nvars, int(not (set(block) & hits))), scale(b, -1))
            for block in blocks
        ]
        result = add(result, multiply(probability, product(factors, nvars)))
    return result


def evaluate(poly, values):
    return sum(
        (coefficient * product_rational(
            value ** exponent for value, exponent in zip(values, powers, strict=True)
        ) for powers, coefficient in poly.items()), Q(0)
    )


def product_rational(values):
    result = Q(1)
    for value in values:
        result *= value
    return result


def check_moment_algebra():
    blocks = ({0, 1, 2}, {0, 1, 2}, {0, 3, 4}, {1, 3, 5})
    union = mixed_union_polynomial(blocks, 6)
    enumerated = mixed_hit_polynomial(blocks, 6)
    require(union == enumerated, "Repeated-block union expansion disagrees with hit law")

    nvars = 4
    b, z, u, v = [variable(nvars, i) for i in range(nvars)]
    one = constant(nvars, 1)
    repeated_next = add(
        product([add(one, scale(z, -1)), scale(b, -1), u], nvars),
        product([z, add(one, scale(b, -1)), v], nvars)
    )
    recurrence_next = add(
        multiply(scale(b, -1), add(
            multiply(add(one, scale(z, -1)), u), multiply(z, v)
        )),
        multiply(z, v)
    )
    require(repeated_next == recurrence_next,
            "Universal two-state repeated-block recurrence failed")
    require(add(add(one, scale(z, -1)), z) == one,
            "Repeated-block induction base failed")

    b, zh, zk, zu = [variable(nvars, i) for i in range(nvars)]
    centered = add(zu, scale(multiply(b, add(zh, zk)), -1), multiply(b, b))
    covariance = add(
        multiply(add(zh, scale(b, -1)), add(zk, scale(b, -1))),
        zu, scale(multiply(zh, zk), -1)
    )
    require(centered == covariance, "Universal covariance identity failed")

    repeated = mixed_union_polynomial(({0, 1}, {0, 1}, {1, 2}), 3)
    value = evaluate(repeated, (Q(1, 4), Q(1, 2), Q(1, 2), Q(1, 2)))
    require(value == Q(1, 32), "Exact repeated mixed product is not 1/32")
    return {"symbolic_regression_monomials": len(union), "repeat_moment": str(value)}


def rational_atom(value):
    return Q(int(value["num"]), int(value["den"]))


def check_jacobian(certificate):
    data = certificate["jacobian"]
    payload = json.loads((ROOT / data["payload"]).read_text())
    response = json.loads((ROOT / data["output"]).read_text())
    require(data["adapter_exit_code"] == 0 and data["adapter_status"] == "completed",
            "Jacobian execution was not completed successfully")
    require(data["structured_error"] is None, "Jacobian has a structured error")
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(response["request"]["operation_id"] == data["operation_id"],
            "Jacobian operation mismatch")
    require(response["server"]["version"] == data["server_version"],
            "Jacobian server version mismatch")
    require(response["protocol_version"] == data["protocol_version"],
            "Jacobian protocol mismatch")
    require(sum((rational_atom(a["probability"]) for a in payload["atoms"]), Q(0)) == 1,
            "Jacobian finite law is not normalized")
    own = sum((rational_atom(a["probability"]) *
               rational_atom(a["value"]) ** payload["order"]
               for a in payload["atoms"]), Q(0))
    output = response["result"]["output"]
    require(own == rational_atom(output["moment"]) == Q(data["expected_moment"]),
            "Independent exact arithmetic disagrees with Jacobian")
    return str(own)


def check_universal_accounting(certificate):
    c = certificate["constants"]
    ns = Q(c["nonsimple_attenuation"])
    simple = Q(c["simple_attenuation"])
    overlap = Q(c["overlap_loss"])
    deviation = Q(c["deviation_loss"])
    saving = Q(c["per_position_saving"])
    target = Q(c["target_saving"])
    require(ns - overlap == 2 * saving, "Nonsimple first-pair budget fails")
    slacks = certificate["universal_nonnegative_slacks"]
    require(slacks["nonsimple_k_equals_2_plus_u"] == "33/50*u",
            "Unknown nonsimple affine certificate")
    require(1 - saving == Q(33, 50) >= 0,
            "Universal nonsimple residual is not nonnegative")
    exact = {
        "simple_shift_one_position": simple - overlap - saving,
        "simple_shift_two_positions": 2 * simple - overlap - 2 * saving,
        "deviation_one_position": simple - deviation - saving,
        "anchor_one_position": simple - saving,
        "root_per_position": simple - saving,
        "final_exponent_after_overhead":
            saving - Q(c["declared_overhead_exponent"],
                       c["large_parameter_log_factor"]) - target,
        "scale_gap_coefficient": Q(1, 2) - Q(9, 10**7)
    }
    for name, value in exact.items():
        require(value == Q(slacks[name]) and value >= 0,
                f"Invalid universal nonnegative slack: {name}")

    nvars = 2
    r, u = [variable(nvars, i) for i in range(nvars)]
    h = add(scale(r, 10), u)
    root_residual = add(scale(h, 1), scale(r, -10))
    require(root_residual == u, "Universal root-count Farkas certificate failed")
    require(slacks["root_exponent_h_equals_10r_plus_u"] == "u",
            "Unknown root certificate")
    require(c["root_probability"] == "1/20" and c["root_fraction"] == "1/10",
            "Root expectation ratio does not support Markov step")
    require(c["root_distinct_witness_divisor"] == 800 and
            c["overlap_power"] == c["dictionary_per_position"] == 200,
            "Witness, pair or dictionary budget mismatch")
    require(2 * 400 <= c["root_distinct_witness_divisor"],
            "Greedy witness loss is undercounted")
    require(c["local_algebraic_exponent"] >= c["overlap_power"] + 2,
            "Local dyad and power overhead is undercounted")
    total = c["local_algebraic_exponent"] + c["scheme_exponent"]
    require(total <= c["declared_overhead_exponent"],
            "Declared overhead does not cover local and scheme costs")
    require(Q(4, 3) < 2 and 4 * (1 + Q(1, 2) + Q(1, 4)) <= 8,
            "Projective size constants fail")
    require(2 * (1 + Q(1, 2)) <= 4, "Projective atom-degree constant fails")
    return {"overhead_exponent_used": total,
            "declared_overhead_exponent": c["declared_overhead_exponent"],
            "nonnegative_affine_certificates": len(exact) + 2}


def check_formal_source_binding(certificate):
    source = ROOT / certificate["formal_source"]
    fidelity = ROOT / certificate["statement_fidelity"]
    result = json.loads((ROOT / certificate["formal_result"]).read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "No successful real Lean compiler run")
    require(result["proof_holes"] == [], "Lean proof has holes")
    require("4.31.0" in result["tools"]["lean"]["version"], "Wrong Lean version")
    require(hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
            "Lean source changed after compilation")
    require(hashlib.sha256(fidelity.read_text().encode()).hexdigest() ==
            result["statement_fidelity_sha256"],
            "Statement-fidelity document changed after compilation")
    record = result["kernel"]["recorded"]
    require(record["subject"]["subject_id"] == certificate["formal_claim"],
            "Formal evidence was attached to the wrong claim")
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            "Formal-core claim lacks supporting mechanical evidence")
    require(certificate["formal_claim"] != certificate["manuscript_target"],
            "Partial formalization must not masquerade as full moment certification")
    project = ROOT.parent.parent
    archive = project / record["artifact"]
    require(archive.is_file(), "Archived formal certificate is missing")
    return {"claim": certificate["formal_claim"], "proof_holes": [],
            "archive": record["artifact"]}


def main():
    certificate = json.loads((ROOT / "exact_certificate.json").read_text())
    require(certificate["independent_review_required"] and
            not certificate["reviewer_approval"],
            "Engineer certificate must not manufacture Reviewer approval")
    require(not certificate["manuscript_refuted"], "No refutation was established")
    results = {
        "exact_moment_algebra": check_moment_algebra(),
        "jacobian_repeat_moment": check_jacobian(certificate),
        "universal_accounting": check_universal_accounting(certificate),
        "source_bound_formal_core": check_formal_source_binding(certificate),
        "full_analytic_theorem": "proof in report.md; independent review pending",
        "novelty": "unassessed"
    }
    print(json.dumps(results, sort_keys=True, indent=2))


if __name__ == "__main__":
    main()
