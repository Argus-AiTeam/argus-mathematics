#!/usr/bin/env python3
"""Replay exact finite checks and the complete Lean transfer certificate."""

import itertools
import json
import math
import subprocess
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS = Path("$WORKSPACE/argus-live-update/.venv/bin/python")
CLAIM = "C277_TRANSFER"


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def compositions(total, size):
    if size == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, size - 1):
            yield (first,) + rest


def probability(law, predicate):
    return sum((p for x, p in law.items() if predicate(x)), Fraction())


def ceil_fraction(x):
    return -(-x.numerator // x.denominator)


def sampling_checks():
    draw_cases = 0
    for n in range(1, 5):
        for ell in range(5):
            draws = tuple(itertools.product(range(n), repeat=ell))
            require(len(draws) == n**ell, "incorrect draw universe")
            for x in range(1 << n):
                successes = 0
                for draw in draws:
                    tested = sum(1 << i for i in set(draw))
                    require(tested.bit_count() <= ell, "draw-set cardinality")
                    successes += (x & tested) == tested
                require(successes == x.bit_count() ** ell, "draw-count identity")
                draw_cases += 1

    q0, q, eps = Fraction(1, 4), Fraction(3, 4), Fraction(1, 2)
    selected, zero_tail, max_ell = 0, 0, 0
    for n, denominator in ((1, 6), (2, 6), (3, 6), (4, 3)):
        for weights in compositions(denominator, 1 << n):
            law = {x: Fraction(w, denominator) for x, w in enumerate(weights) if w}
            p = probability(law, lambda x: x.bit_count() >= q * n)
            if p == 0:
                zero_tail += 1
                continue
            ell = 0
            while q0**ell > eps * p * q**ell / 4:
                ell += 1
                require(ell <= 64, "sampling exponent search exceeded its bound")
            max_ell = max(max_ell, ell)
            candidates = []
            for tested in range(1 << n):
                if tested.bit_count() > ell:
                    continue
                pc = probability(law, lambda x: (x & tested) == tested)
                bad = probability(
                    law,
                    lambda x: (x & tested) == tested and x.bit_count() < q0 * n,
                )
                if pc >= p * q**ell / 2 and bad <= eps * pc:
                    candidates.append(tested)
            require(candidates, "upper-tail selection failed")
            selected += 1
    return {
        "draw_identity_cases": draw_cases,
        "rational_laws_with_selected_set": selected,
        "zero_tail_laws_excluded_by_hypothesis": zero_tail,
        "maximum_draw_length": max_ell,
        "scope": "all stated rational mass compositions; a finite experiment, not the universal proof",
    }


def tensor_and_marginal_checks():
    tensor_cases, marginal_cases = 0, 0
    n = 2
    for weights in compositions(4, 1 << n):
        law = {x: Fraction(w, 4) for x, w in enumerate(weights) if w}
        for tested in range(1 << n):
            pc = probability(law, lambda x: (x & tested) == tested)
            remaining = sum(
                (
                    p * (x.bit_count() - tested.bit_count())
                    for x, p in law.items()
                    if (x & tested) == tested
                ),
                Fraction(),
            )
            marginal_sum = sum(
                (
                    probability(
                        law,
                        lambda x, i=i: (x & tested) == tested and (x & (1 << i)),
                    )
                    for i in range(n)
                    if not (tested & (1 << i))
                ),
                Fraction(),
            )
            require(remaining == marginal_sum, "remaining marginal-sum identity")
            require(remaining >= 0, "negative remaining wins")
            if pc > 0 and tested.bit_count() < n:
                require(
                    marginal_sum / pc / (n - tested.bit_count())
                    == remaining / (pc * (n - tested.bit_count())),
                    "conditional-mean equivalence",
                )
            marginal_cases += 1
        for copies in range(4):
            tensor = {}
            for blocks in itertools.product(law, repeat=copies):
                x = sum(block << (j * n) for j, block in enumerate(blocks))
                tensor[x] = math.prod(law[block] for block in blocks)
                require(x.bit_count() == sum(b.bit_count() for b in blocks), "block win sum")
            require(sum(tensor.values(), Fraction()) == 1, "product-law normalization")
            for q in (Fraction(1, 4), Fraction(1, 2), Fraction(3, 4)):
                p = probability(law, lambda x: x.bit_count() >= q * n)
                all_blocks = probability(
                    tensor,
                    lambda x: all(
                        ((x >> (j * n)) & 3).bit_count() >= q * n
                        for j in range(copies)
                    ),
                )
                tail = probability(tensor, lambda x: x.bit_count() >= q * n * copies)
                require(all_blocks == p**copies, "independent block-event power")
                require(all_blocks <= tail, "global-threshold inclusion")
                require(
                    copies * ceil_fraction(q * n) >= ceil_fraction(q * n * copies),
                    "integer ceiling inclusion",
                )
                tensor_cases += 1
    return {"tensor_event_cases": tensor_cases, "marginal_identity_cases": marginal_cases}


def exact_rate_checks():
    cases = 0
    for numerator in range(1, 8):
        delta = Fraction(numerator, 8)
        eta = delta / 16
        for b4 in (Fraction(1), Fraction(3, 2), Fraction(4)):
            budget = (delta / (4 * b4)) ** 4
            require(0 < budget <= delta / 4 < 1, "fourth-root budget")
            for answer_log in (Fraction(), Fraction(1, 3), Fraction(5)):
                rate = delta * budget / (16 * (1 + answer_log))
                fifth = delta**5 / (16 * (4 * b4) ** 4 * (1 + answer_log))
                require(rate == fifth, "fifth-power rate substitution")
                cases += 1
        for v in (Fraction(), (1 - delta) / 2):
            q0 = v + delta / 2
            for n in range(1, 33):
                for size in range(n + 1):
                    if size > eta * n:
                        continue
                    difference = (1 - eta) * (q0 * n - size) - (q0 - eta) * (n - size)
                    require(difference == (1 - q0) * (eta * n - size), "surplus identity")
                    require(difference >= 0 and q0 - eta > v + delta / 4, "strict surplus")
                    cases += 1
    return {"exact_rational_rate_and_geometry_cases": cases}


def jacobian_replay():
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    inspection = json.loads((HERE / "jacobian-inspect.json").read_text())
    result = json.loads((HERE / "jacobian-output.json").read_text())
    operation = "probability.finite_distribution.condition.compute"
    require(inspection["result"]["operation"]["operation_id"] == operation, "typed contract mismatch")
    require(result["request"]["operation_id"] == operation, "Jacobian operation mismatch")
    require(result["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(result["server"]["version"] == "0.14.0", "unexpected saved server version")
    require(result["protocol_version"] == "2025-11-25", "unexpected saved protocol")
    require("error" not in result and "output" in result["result"], "nonconclusive adapter result")

    def rational(value):
        return Fraction(int(value["num"]), int(value["den"]))

    event = {rational(x) for x in payload["event_values"]}
    law = {
        rational(atom["value"]): rational(atom["probability"])
        for atom in payload["distribution"]["atoms"]
    }
    mass = probability(law, lambda x: x in event)
    output = result["result"]["output"]
    require(rational(output["event_probability"]) == mass == Fraction(1, 2), "event mass")
    conditioned = {
        rational(atom["value"]): rational(atom["probability"])
        for atom in output["distribution"]["atoms"]
    }
    require(conditioned == {x: p / mass for x, p in law.items() if x in event}, "conditioning")
    for contribution in output["contributions"]:
        x = rational(contribution["value"])
        require(rational(contribution["source_probability"]) == law[x], "source contribution")
        require(rational(contribution["conditioned_probability"]) == law[x] / mass, "conditional contribution")
    return {
        "operation_id": operation,
        "server_version": result["server"]["version"],
        "protocol": result["protocol_version"],
        "status": "success",
        "adapter_error": None,
        "timeout": False,
        "scope": "exact finite conditioning calibration only, not a universal proof",
    }


def module_command(module, *arguments):
    completed = subprocess.run(
        [str(ARGUS), "-m", module, *map(str, arguments)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    if completed.returncode:
        raise RuntimeError(
            f"{module} exited {completed.returncode}\n{completed.stdout}\n{completed.stderr}"
        )
    return completed


def main():
    finite = {
        **sampling_checks(),
        **tensor_and_marginal_checks(),
        **exact_rate_checks(),
    }
    jacobian = jacobian_replay()
    compiler = module_command(
        "argus_skill.verticals.math.lean_evidence",
        "verify",
        HERE / "Main.lean",
        "--statement-fidelity",
        HERE / "statement_fidelity.md",
        "--claim",
        CLAIM,
        "--project-root",
        ROOT,
    )
    evidence = json.loads(compiler.stdout)
    require(evidence["exit_code"] == 0, "compiler did not succeed")
    require(evidence["proof_holes"] == [], "proof holes present")
    require(evidence["status"] == "success", "formalization is not verified")
    require(evidence.get("kernel", {}).get("recorded"), "mechanical evidence was not recorded")
    state = module_command(
        "argus_skill.verticals.math.math_state", "check", "--project-root", ROOT
    )
    graph = module_command(
        "argus_skill.verticals.math.proof_graph_check", "check", "--project-root", ROOT
    )
    certificate = {
        "schema_version": 1,
        "claim_id": CLAIM,
        "result_class": "new_theorem",
        "result_scope": "independent formal verification and finite-law generalization of the existing prose transfer",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "novelty_and_significance": "pending independent Reviewer; no claim that the manuscript's exponent or Song's quantum input is new here",
        "statement": (
            "For any tensor-product-closed finite binary-law family, v>=0, "
            "0<delta<1-v, L>=0 and 0<T<=delta/4, the uniform proper-tested-set "
            "conditioning hypothesis implies Pr(W>=ceil((v+delta)n))"
            "<=exp(-delta*T*n/(16*(1+L))) at every n>=1."
        ),
        "hypotheses": [
            "All masses are real, nonnegative, and sum to one; coordinates may be arbitrarily correlated.",
            "The family is closed under the explicit independently repeated product law.",
            "Every proper tested set of positive mass with cost at most T has conditional mean at most v+delta/4.",
        ],
        "formal_declarations": [
            "ConditioningBridge.upper_tail_selection",
            "ConditioningBridge.tensorLaw",
            "ConditioningBridge.tensor_block_event",
            "ConditioningBridge.tensor_tailProb",
            "ConditioningBridge.large_length_threshold",
            "ConditioningBridge.conditioning_to_threshold_at_every_length",
            "ConditioningBridge.threshold_supremum",
        ],
        "source_locations": {
            "manuscript": "research/openai_manuscript/Threshold-parallel-repetition-for-finite-dimensional-entangled-games-September-25-2026/build/sections/04-threshold.tex",
            "manuscript_labels": ["prop:song-conditioning", "prop:conditioning-to-tail"],
            "external_source": "https://eccc.weizmann.ac.il/report/2026/199/download/",
            "external_locator": "Song, Definition 4.3 and Lemma 4.4, PDF pp. 11-12",
        },
        "external_quantum_input": {
            "claim": "C277_SONG",
            "applicability": "matches the literal manuscript statement in the inspected primary PDF text",
            "not_formalized": "Song Lemma 4.1 and imported Chapter 6 ideal-state, alignment, and history-sampling machinery",
            "source_grounding_limit": "PDF text extraction through Jina from the official URL; direct shell PDF downloads failed with curl exit 56",
        },
        "finite_experiments": finite,
        "jacobian": jacobian,
        "formal_verification": evidence,
        "campaign_local_checks": {
            "project_root": str(ROOT),
            "math_state_exit_code": state.returncode,
            "proof_graph_exit_code": graph.returncode,
        },
        "independent_review": {"status": "pending Host invocation", "reviewer_confirmed": False},
        "refutation": "No false literal manuscript assertion established; no refutes judgement warranted.",
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(
        json.dumps(
            {
                "claim": CLAIM,
                "compiler_exit_code": evidence["exit_code"],
                "proof_holes": evidence["proof_holes"],
                "finite_experiments": finite,
                "campaign_local_checks": certificate["campaign_local_checks"],
                "independent_review": "pending",
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
