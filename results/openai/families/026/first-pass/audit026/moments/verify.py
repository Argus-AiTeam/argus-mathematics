#!/usr/bin/env python3
"""Replay exact components; do not certify the analytic proof or novelty."""

import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import itertools
import json
import math
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[2]
OPERATION = "additive.subset_sum.profile.compute"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def partitions(n):
    """Canonical restricted-growth strings, including the empty partition."""
    if n == 0:
        yield ()
        return

    def extend(prefix, maximum):
        if len(prefix) == n:
            yield tuple(prefix)
            return
        for value in range(maximum + 2):
            yield from extend(prefix + [value], max(maximum, value))

    yield from extend([0], 0)


def submasks(mask):
    sub = mask
    while sub:
        yield sub
        sub = (sub - 1) & mask


def sign(mask):
    return -1 if mask.bit_count() % 2 else 1


def fibers(pattern):
    return [
        sum(1 << i for i, value in enumerate(pattern) if value == block)
        for block in range(max(pattern, default=-1) + 1)
    ]


def local_factor_checks():
    counts = Counter()
    primes = (2, 3, 5, 7)
    for m in range(7):
        for equality in partitions(m):
            exact_fibers = fibers(equality)
            t = len(exact_fibers)
            pole_exponent = sum(
                sum(sign(sub) for sub in submasks(fiber))
                for fiber in exact_fibers
            )
            require(pole_exponent == -t, ("pole exponent", equality))
            counts["equality_patterns"] += 1
            for delta in (0, 1):
                for residues in partitions(t + delta):
                    nu = max(residues, default=-1) + 1
                    allowed_sign = 0
                    for selected in range(1, 1 << m):
                        occupied = {
                            residues[equality[i]]
                            for i in range(m)
                            if selected & (1 << i)
                        }
                        if len(occupied) == 1 and (
                            delta == 0 or residues[t] not in occupied
                        ):
                            allowed_sign += sign(selected)
                    require(allowed_sign == -(nu - delta), "residue-fiber sign")
                    for p in primes:
                        if nu > p:
                            continue
                        base = Fraction(p - 1, p)
                        density = 1 + Fraction(allowed_sign, p - delta)
                        normalized = density / base**t
                        singular = (1 - Fraction(nu, p)) / base ** (t + delta)
                        require(
                            normalized == singular,
                            ("local normalization", equality, delta, residues, p),
                        )
                        counts["normalizations"] += 1
                        counts["marked" if delta else "unmarked"] += 1
                        if nu == p:
                            require(normalized == 0, "zero factor not zero")
                            counts["zero_factors"] += 1
                        if nu < t + delta:
                            counts["collision_factors"] += 1
                        if t < m:
                            counts["repeated_shift_cases"] += 1
    require(counts["zero_factors"] > 0, "missing zero-factor coverage")
    require(counts["collision_factors"] > 0, "missing collision coverage")
    require(counts["repeated_shift_cases"] > 0, "missing repeated fibers")
    return {
        "kind": "finite_exact_enumeration",
        "max_divisor_coordinates": 6,
        "residue_scope": "every coarsening of every equality pattern, up to relabeling",
        "primes": list(primes),
        "counts": dict(sorted(counts.items())),
        "not_a_universal_proof": True,
    }


def kernel(ws):
    answer = sp.Integer(1)
    for mask in range(1, 1 << len(ws)):
        subset_sum = sum(ws[i] for i in range(len(ws)) if mask & (1 << i))
        answer *= subset_sum ** (-sign(mask))
    return answer


def symbolic_checks():
    eps = sp.Symbol("eps")
    xs = sp.symbols("x0:4")
    checked = 0
    for m in range(5):
        for equality in partitions(m):
            exact_fibers = fibers(equality)
            p1 = sum(
                sp.prod(1 - xs[i] for i in range(m) if fiber & (1 << i)) - 1
                for fiber in exact_fibers
            )
            b = sp.Integer(1)
            for fiber in exact_fibers:
                for selected in submasks(fiber):
                    monomial = sp.prod(
                        xs[i] for i in range(m) if selected & (1 << i)
                    )
                    b *= (1 - eps * monomial) ** (-sign(selected))
            for delta in (0, 1):
                p = 1 + eps * p1 / (1 - delta * eps)
                require(sp.simplify((p / b).subs(eps, 0) - 1) == 0, "constant")
                require(
                    sp.expand(sp.diff(p / b, eps).subs(eps, 0)) == 0,
                    ("generic linear cancellation", equality, delta),
                )
                checked += 1

    p, nu = sp.symbols("p nu")
    marked_difference = (
        (1 - (nu - 1) / (p - 1)) * (1 - 1 / p) - (1 - nu / p)
    )
    require(sp.cancel(marked_difference) == 0, "marked rational identity")

    ws = sp.symbols("w0:4", positive=True)
    c, y = sp.symbols("c y", positive=True)
    require(sp.cancel(kernel(ws[:1]) - ws[0]) == 0, "singleton kernel")
    require(
        sp.cancel(kernel(ws[:2]) - ws[0] * ws[1] / (ws[0] + ws[1])) == 0,
        "double kernel",
    )
    pair_integral = sp.integrate(sp.exp(-(ws[0] + ws[1]) * y), (y, 0, sp.oo))
    require(
        sp.cancel(ws[0] * ws[1] * pair_integral - kernel(ws[:2])) == 0,
        "Laplace pair sign",
    )
    for size in range(1, 5):
        require(
            sp.cancel(kernel(tuple(c * w for w in ws[:size])) - c * kernel(ws[:size]))
            == 0,
            ("one net pole per fiber", size),
        )
    return {
        "kind": "exact_symbolic_identities",
        "generic_local_first_order_cases": checked,
        "generic_local_max_coordinates": 4,
        "marked_identity": "valid over QQ(p,nu); arithmetic domain p!=0,1",
        "singleton_kernel": "w0",
        "double_kernel": "w0*w1/(w0+w1)",
        "homogeneous_kernel_sizes_checked": [1, 2, 3, 4],
        "analytic_derivative_and_Fubini_steps": "prose proof, not symbolic certification",
    }


def support_and_deletion_checks():
    tau = Fraction(1, 8)
    uses = [
        ("square", 2, Fraction(1)),
        ("one_prime_mark", 2, Fraction(1, 2)),
        ("fourth_moment", 4, Fraction(1)),
        ("detector_off_diagonal", 6, Fraction(1)),
    ]
    budgets = {}
    for name, factors, threshold in uses:
        budget = factors * tau
        require(budget < threshold, ("support threshold", name))
        budgets[name] = {"budget": str(budget), "strict_threshold": str(threshold)}
    require(6 * tau >= Fraction(1, 2), "six-factor estimate must be unmarked")

    deletion_cases = 0
    for h in range(1, 8):
        universe = set(range(h))
        for k in range(h + 1):
            subsets = [
                frozenset(s)
                for j in range(k + 1)
                for s in itertools.combinations(range(h), j)
            ]
            for a in range(h):
                contributions = Counter((s - {a}, a in s) for s in subsets)
                remaining = sorted(universe - {a})
                expected = Counter()
                for j in range(k + 1):
                    for u in itertools.combinations(remaining, j):
                        expected[(frozenset(u), False)] = 1
                        if j < k:
                            expected[(frozenset(u), True)] = 1
                require(contributions == expected, ("deletion bijection", h, k, a))
                deletion_cases += 1
    return {
        "kind": "exact_budget_and_finite_bijection_checks",
        "tau": str(tau),
        "support_uses": budgets,
        "deletion_cases": deletion_cases,
        "deletion_max_block_size": 7,
        "deletion_multiplicity": "one per containing subset, no dimension factor",
        "uniform_error_summation": "proved for all fixed patterns in verification.md",
    }


def zero_obstruction():
    p_zero = 1 - (Fraction(1) + Fraction(1)) / 2
    p_positive = 1 - (Fraction(1, 2) + Fraction(1, 2)) / 2
    require(p_zero == 0 and p_positive == Fraction(1, 2), "relative-route obstruction")
    return {
        "kind": "exact_route_obstruction_not_manuscript_refutation",
        "unmarked_shifts": [0, 1],
        "prime": 2,
        "P_at_zero": str(p_zero),
        "P_at_z1_z2_equal_1": str(p_positive),
        "conclusion": "division by P_p(0) is unavailable; additive comparison is necessary",
    }


def jacobian_replay():
    payload = read_json(HERE / "jacobian_payload.json")
    contract = read_json(HERE / "jacobian_contract.json")
    result = read_json(HERE / "jacobian_output.json")
    require(contract["result"]["operation"]["operation_id"] == OPERATION, "contract id")
    require(result["request"]["operation_id"] == OPERATION, "request id")
    require(result["result"]["operation_id"] == OPERATION, "output id")
    require(result["request"]["payload"] == payload, "Jacobian exact payload")
    require(result["server"] == contract["server"], "Jacobian server")
    require(result["protocol_version"] == contract["protocol_version"], "protocol")
    require("error" not in result, "Jacobian adapter error")
    output = result["result"]["output"]
    require(payload["source"]["items"] == ["1"] * 6, "profile scope")
    require(output["source"] == payload["source"], "profile source")
    expected = [
        {"sum": str(i), "multiplicity": str(math.comb(6, i))}
        for i in range(7)
    ]
    require(output["entries"] == expected, "complete binomial profile")
    require(output["support_size"] == 7 and output["total_subsets"] == "64", "size")
    alternating = sum(
        (-1) ** int(row["sum"]) * int(row["multiplicity"])
        for row in output["entries"][1:]
    )
    require(alternating == -1, "Jacobian sign replay")
    return {
        "kind": "finite_exact_adapter_replay",
        "operation_id": OPERATION,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "transport": result["transport"],
        "adapter_status": "completed",
        "structured_error": None,
        "timeout": False,
        "indexed_coordinates": 6,
        "nonempty_alternating_sum": alternating,
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "typed_contract_file": "jacobian_contract.json",
    }


def lean_replay():
    result = read_json(HERE / "lean_check.json")
    invocation = read_json(HERE / "lean_verification.json")
    require(result["status"] == "success", "Lean compiler did not succeed")
    require(result["exit_code"] == 0, "Lean compiler exit")
    require(result["proof_holes"] == [], "Lean proof holes")
    require(result["audit_exit_code"] == 0, "Lean transitive axiom audit")
    version = result["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "wrong Lean version")
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    require(
        hashlib.sha256(source.encode()).hexdigest() == result["source_sha256"],
        "Lean source changed after compilation",
    )
    require(
        hashlib.sha256(fidelity.encode()).hexdigest()
        == result["statement_fidelity_sha256"],
        "Lean statement fidelity changed after compilation",
    )
    for key, value in result.items():
        require(invocation[key] == value, ("official Lean invocation", key))
    record = invocation["kernel"]["recorded"]
    require(record is not None, "no mechanical evidence recorded")
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "tier")
    require(record["subject"]["subject_id"] == "L026_EULER_CORE", "Lean claim")
    archive_path = (PROJECT / record["artifact"]).resolve()
    require(archive_path.is_relative_to(HERE), "archive outside owned evidence")
    archive = read_json(archive_path)
    require(archive["lean_check"] == result, "archived compiler answer")
    require(archive["lean_source"]["text"] == source, "archived source")
    require(archive["statement_fidelity"]["text"] == fidelity, "archived fidelity")
    ledger = read_json(PROJECT / "research" / "MATH_STATE.json")
    claim = max(
        (c for c in ledger["claims"] if c["claim_id"] == "L026_EULER_CORE"),
        key=lambda c: c["version"],
    )
    require(claim["formal_statement"] == source, "ledger formal statement")
    require(claim["content_hash"] == record["subject"]["content_hash"], "claim version")
    require(claim["external_assumptions"] == [], "unexpected formal assumption")
    return {
        "kind": "real_universal_Lean_compilation",
        "claim": "L026_EULER_CORE",
        "exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "version": version,
        "archive": record["artifact"],
        "source_and_fidelity_fresh": True,
        "scope": "finite subset identities and rational local normalization only",
        "independent_statement_fidelity_review": "pending Host Reviewer",
    }


def certificate():
    return {
        "mission": "certify-uniform-moments",
        "classification": "universal prose verification with separately checked exact components",
        "local_factors": local_factor_checks(),
        "symbolic": symbolic_checks(),
        "support_and_deletion": support_and_deletion_checks(),
        "relative_route_obstruction": zero_obstruction(),
        "jacobian": jacobian_replay(),
        "lean": lean_replay(),
        "analytic_claims": [
            "C026_UNIFORM_MOMENTS",
            "C026_WEIGHT_MOMENTS",
            "C026_STRONG_ERROR",
        ],
        "analytic_status": "prose proof; pending independent mathematical review",
        "quantitative_refinement": "O(L^(-t-1)(log L)^A) for B>=1; prose proof only",
        "external_number_theoretic_dependency": {
            "theorem": "ordinary endpoint Bombieri-Vinogradov",
            "source_id": "doi:10.1007/BF02399204",
            "locator": "p. 206, equation (1.4); notation p. 204",
            "source_reading": "Engineer read primary source; independent attribution pending",
            "excerpt_file": "BV_source_excerpt.md",
        },
        "false_manuscript_assertion_certified": False,
        "novelty_status": "not_assessed",
        "campaign_complete": False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="regenerate exact_certificate.json")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    else:
        require(read_json(path) == result, "certificate differs from fresh exact replay")
    print(
        json.dumps(
            {
                "status": "exact_components_verified",
                "local_normalizations": result["local_factors"]["counts"]["normalizations"],
                "lean_exit_code": result["lean"]["exit_code"],
                "analytic_status": result["analytic_status"],
            }
        )
    )


if __name__ == "__main__":
    main()
