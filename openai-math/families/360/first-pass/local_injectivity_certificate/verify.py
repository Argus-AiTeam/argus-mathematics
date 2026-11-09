#!/usr/bin/env python3
"""Replay exact algebra and check the current, genuinely compiled Lean evidence."""

import argparse
import hashlib
import json
import re
from fractions import Fraction as Q
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def dot(a, b):
    return sum((x * y for x, y in zip(a, b, strict=True)), Q(0))


def weighted(weights, values):
    return dot(weights, values)


def check_stage(weights, first, second, remainder, length, radius):
    require(len(weights) > 0, "A unit-mass stage needs a slot.")
    require(all(w >= 0 for w in weights), "Negative barycentric weight.")
    require(sum(weights) == 1, "Weights do not have unit sum.")
    require(length > 0, "Nonpositive collision separation.")
    require(weighted(weights, first) == 0, "Finite-stage cancellation failed.")
    require(all(abs(e) <= radius for e in remainder), "Nonuniform remainder.")
    increments = [
        length * d + length**2 * b / 2 + length**2 * e
        for d, b, e in zip(first, second, remainder, strict=True)
    ]
    normalized = weighted(weights, second) / 2 + weighted(weights, remainder)
    require(
        weighted(weights, increments) == length**2 * normalized,
        "Weighted Taylor identity failed.",
    )
    require(abs(weighted(weights, remainder)) <= radius, "Remainder bound failed.")
    delta = max(increments)
    require(delta >= weighted(weights, increments), "Weighted comparison failed.")
    if normalized > 0:
        require(delta > 0, "A positive normalized gap permitted a collision.")
    return normalized


def exact_regressions():
    stages = 0
    for slots in range(1, 17):
        denominator = slots * (slots + 1) // 2
        weights = [Q(i + 1, denominator) for i in range(slots)]
        for dimension in (1, 2, 4):
            vertices = [
                tuple(Q((-1) ** (i + k) * (i + 1), i + k + 2) for k in range(dimension))
                for i in range(slots)
            ]
            pole = tuple(weighted(weights, [a[k] for a in vertices]) for k in range(dimension))
            direction = (Q(1),) if dimension == 1 else (
                Q(3, 5), Q(4, 5), *([Q(0)] * (dimension - 2))
            )
            require(dot(direction, direction) == 1, "Direction not normalized.")
            first = [
                dot(tuple(a[k] - pole[k] for k in range(dimension)), direction)
                for a in vertices
            ]
            length = Q(1, 2 ** (slots + 3))
            second = [Q(2 * i - slots, i + 1) for i in range(slots)]
            remainder = [length * Q((-1) ** i, i + 1) for i in range(slots)]
            check_stage(weights, first, second, remainder, length, length)
            stages += 1

    slow_cases = 0
    for k in range(2, 41):
        small = Q(1, k + 1)
        length = Q(1, 2 ** (k * k))
        weights = [1 - small, small]
        first = [-small * length / (1 - small), length]
        second = [Q(2), Q((-1) ** k)]
        remainder = [-length / 2, length / 3]
        normalized = check_stage(weights, first, second, remainder, length, length)
        require(normalized > 0, "Slow-zero-weight stress case lost its positive gap.")
        require(abs(small * second[1]) <= small, "Bounded oscillating slot did not vanish.")
        require(small / length**2 >= Q(256, 3), "Stress weights vanished too quickly.")
        slow_cases += 1

    changing_cases = 0
    for j in range(1, 25):
        slots = j + 1
        weights = [Q(0)] * (slots // 2) + [Q(1, slots - slots // 2)] * (
            slots - slots // 2
        )
        values = [Q(i, slots) for i in range(slots)]
        mean = weighted(weights, values)
        first = [a - mean for a in values]
        second = [Q(2)] * slots
        radius = Q(1, j + 2)
        remainder = [-radius] * slots
        check_stage(weights, first, second, remainder, Q(1, 2 ** (j + 1)), radius)
        require(weighted(weights, second) == 2, "Changing slots changed the prescribed gap.")
        changing_cases += 1

    for denominator in range(2, 20):
        length = Q(1, denominator)
        first = -length
        delta = -length**2 / 2
        require(delta == length * first + length**2 / 2, "Sensitivity identity failed.")
        require(delta < 0 and first != 0, "Missing-cancellation guard failed.")

    radial_cases = 0
    for denominator in range(3, 14):
        for numerator in range(1, denominator - 1):
            t = Q(numerator, denominator)
            s = Q(numerator + 1, denominator)
            gap = 1 / t - 1 / s
            require(gap == (s - t) / (s * t), "Flat radial divided-action identity failed.")
            require(gap >= s - t > 0, "Radial sign or duration orientation reversed.")
            radial_cases += 1

    return {
        "kind": "finite_exact_regression_illustrations_not_universal_proof",
        "barycentric_taylor_stages": stages,
        "slow_zero_weight_stages": slow_cases,
        "changing_cardinality_stages": changing_cases,
        "flat_radial_sign_stages": radial_cases,
        "slow_weight_family": "m=1/(k+1), l=2^(-k^2), bounded zero-slot coefficient=(-1)^k",
        "omitted_cancellation_guard": {
            "d": "-l",
            "B": "1",
            "epsilon": "0",
            "Delta": "-l^2/2",
            "interpretation": "A sensitivity example only; it violates the manuscript's exact finite-stage cancellation.",
            "manuscript_refutation": False,
        },
    }


def check_reused_sources():
    modules = [
        "OAI/Geometry/WeakMTW/Variations/SecondCurveChain.lean",
        "OAI/Geometry/WeakMTW/Variations/LineTaylor.lean",
        "OAI/Geometry/WeakMTW/Variations/MovingTaylor.lean",
        "OAI/Geometry/WeakMTW/Variations/ParametricTaylor.lean",
        "OAI/Geometry/WeakMTW/Support/CollisionCalculus.lean",
    ]
    source = (HERE / "Main.lean").read_text()
    for index, module in enumerate(modules):
        marker = "-- Upstream module: " + module
        following = (
            "-- Upstream module: " + modules[index + 1]
            if index + 1 < len(modules)
            else "-- BEGIN CAMPAIGN CORE"
        )
        original = (HERE / "upstream_sources/lean" / module).read_text()
        expected = "\n".join(line for line in original.splitlines() if not line.startswith("import "))
        embedded = source.split(marker, 1)[1].split(following, 1)[0]
        require(embedded.strip() == expected.strip(), "Changed upstream proof body: " + module)
    require("Apache License" in (HERE / "upstream_sources/LICENSE").read_text(), "Missing reuse license.")
    return modules


def compiled_evidence():
    result = json.loads((HERE / "lean_check.json").read_text())
    recorded = json.loads((HERE / "lean_verification.json").read_text())
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text().encode()
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean did not succeed.")
    require(result["proof_holes"] == [], "Lean proof has holes.")
    require(result["audit_exit_code"] == 0, "Lean axiom audit did not succeed.")
    require(result["source_sha256"] == hashlib.sha256(source).hexdigest(), "Stale Lean source.")
    require(
        result["statement_fidelity_sha256"] == hashlib.sha256(fidelity).hexdigest(),
        "Stale statement-fidelity document.",
    )
    require("4.31.0" in result["tools"]["lean"]["version"], "Wrong Lean version.")
    for key in ("status", "exit_code", "source_sha256", "statement_fidelity_sha256"):
        require(recorded[key] == result[key], "Claim-bound and current compiler records differ.")
    required = {
        "MovingActive.movingFiniteCollisionImpossible",
        "MovingActive.barycentricCancellation",
        "MovingActive.limitingPositiveWeightFace",
        "MovingActive.vanishingWeightBounded",
        "MovingActive.smoothParameterCollisionImpossible",
    }
    axioms = dict(re.findall(r"'(MovingActive\.\w+)' depends on axioms: \[([^\]]*)\]", result["stdout"]))
    require(set(axioms) == required, "Principal declarations were not all audited.")
    allowed = {"propext", "Classical.choice", "Quot.sound"}
    for declaration, names in axioms.items():
        require(
            {name.strip() for name in names.split(",") if name.strip()} <= allowed,
            "Additional axiom in " + declaration,
        )
    evidence = recorded["kernel"]["recorded"]
    require(evidence["subject"]["subject_id"] == "C_LOCAL_INJECTIVITY_CORE", "Wrong claim binding.")
    require(evidence["verdict"] == "supports", "Compiler evidence does not support the core.")
    state = json.loads((PROJECT / "research/MATH_STATE.json").read_text())
    current = max(
        (claim for claim in state["claims"] if claim["claim_id"] == "C_LOCAL_INJECTIVITY_CORE"),
        key=lambda claim: claim["version"],
    )
    require(
        evidence["subject"]["content_hash"] == current["content_hash"],
        "Compiler certificate belongs to a superseded claim statement.",
    )
    require(
        any(item["evidence_id"] == evidence["evidence_id"] for item in state["evidence"]),
        "Claim-bound compiler evidence is absent from the ledger.",
    )
    require((PROJECT / evidence["artifact"]).is_file(), "Missing archived claim certificate.")
    return {
        "claim": "C_LOCAL_INJECTIVITY_CORE",
        "claim_version": current["version"],
        "status": result["status"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "axiom_audit_exit_code": result["audit_exit_code"],
        "lean_version": result["tools"]["lean"]["version"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "claim_certificate": evidence["artifact"],
        "principal_declarations": sorted(required),
        "nonstandard_axioms": [],
    }


def certificate():
    return {
        "schema_version": 1,
        "target": "Foundation geometry.tex, geo:local-injectivity",
        "result_class": "new_reduction",
        "result": "Direct verification of the arbitrary-continuous-datum moving-active collision mechanism and a fiber-local transverse-Hessian criterion.",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_status": "pending_independent_review",
        "significance_status": "pending_independent_review",
        "independent_review": "required_pending_host_reviewer",
        "manuscript_refuted": False,
        "formal_core": compiled_evidence(),
        "quantification": {
            "slot_sets": "arbitrary sequences I(j) of finite types, without any cardinality bound",
            "weights": "nonnegative, unit-sum at every stage; zero limiting weights permitted",
            "remainder": "uniform |epsilon(j,i)| <= r(j), r(j) -> 0",
            "cancellation": "exact sum_i m(j,i)*d(j,i)=0 before normalization",
            "gap": "weighted second-order sums tend to a strictly positive real",
            "conclusion": "nonpositive collision increments satisfying all slot inequalities cannot exist",
            "convergence_rates": "none",
        },
        "geometric_bridge": {
            "proof": "report.md, Sections 1-5",
            "formalized_in_lean": False,
            "datum": "arbitrary continuous representing function; no dual completion",
            "local_hypotheses": [
                "0<t<1 and nonconjugacy at the one limiting velocity t*p",
                "subcritical interiority of only the limiting subgradient fiber",
                "transverse Hessian concavity on the indicated contracted fiber segments",
            ],
            "global_weak_mtw": "sufficient for the local transverse condition, not needed away from those segments",
            "global_support_used": False,
            "engineer_verdict": "supports",
        },
        "known_prior": {
            "commit": "4eaee87548250b2682affda7d05d947c05554bae",
            "reused": "OAI.WeakMTWGlobalSupport.MovingTaylor.collision_limits and its four generic helper modules",
            "exact_body_reuse_checked": check_reused_sources(),
            "not_claimed_new": "moving-parameter Taylor calculus and fixed-finite-index cancellation",
        },
        "exact_regressions": exact_regressions(),
        "limitations": [
            "Compilation certifies the scalar analysis core, not the Riemannian translation.",
            "Finite exact stress cases are not a proof of universal local injectivity.",
            "The full global foundation and transport conclusions remain outside this certificate.",
            "Novelty, significance, and independent acceptance are not inferred from compiler success.",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Compare against the persisted certificate.")
    args = parser.parse_args()
    actual = certificate()
    target = HERE / "exact_certificate.json"
    if args.check:
        require(json.loads(target.read_text()) == actual, "Persisted certificate differs from replay.")
    else:
        target.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    print("Exact replay passed; Lean 4.31.0 exit_code=0, proof_holes=[], axiom audit=0.")
    print("The analytic bridge and independent novelty/significance review are explicitly separate.")


if __name__ == "__main__":
    main()
