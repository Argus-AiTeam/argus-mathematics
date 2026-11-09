#!/usr/bin/env python3
"""Exact finite replay of the source-retaining likelihood algebra, not the gas."""

import argparse
import hashlib
import json
from fractions import Fraction as F
from itertools import combinations, product
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
MANUSCRIPT = (
    ROOT
    / "research/openai_manuscript"
    / "Quantum-Depletion-and-Momentum-Distribution-in-the-Dilute-Hard-Sphere-Bose-Gas-October-5-2026"
    / "build/sections"
)
LOCAL_STATES = tuple(product((0, 1), repeat=2))
UNION_STATES = tuple(product((0, 1), repeat=4))
OPERATION = "probability.conditional_expectation.finite.compute"


def exact(value):
    if isinstance(value, F):
        return str(value)
    if isinstance(value, dict):
        return {key: exact(item) for key, item in value.items()}
    if isinstance(value, (tuple, list)):
        return [exact(item) for item in value]
    return value


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def compatible(x, y):
    return not (x == y == 1)


def base(state, epsilon):
    value = F(1)
    for bit in state:
        value *= epsilon if bit else 1 - epsilon
    return value


def reference_local(latent, opposing, separate):
    a, j = latent
    if not compatible(a, j):
        return False
    return separate or (
        compatible(a, opposing[0]) and compatible(j, opposing[1])
    )


def reference_union(state):
    a, j, b, k = state
    return (
        compatible(a, j)
        and compatible(b, k)
        and compatible(a, b)
        and compatible(j, k)
    )


def kernel(latent, output, opposing, epsilon, separate):
    """A shared-midpoint middle pair, then a pin to latent[0]."""
    proposal_rare = 2 * epsilon

    def middle_allowed(midpoint):
        return compatible(midpoint, latent[0]) and (
            separate or compatible(midpoint, opposing[0])
        )

    acceptance = sum(
        (proposal_rare if midpoint else 1 - proposal_rare)
        * middle_allowed(midpoint)
        for midpoint in (0, 1)
    )
    require(acceptance >= F(1, 2), "Middle acceptance is too small")
    if output[1] != latent[0]:
        return F(0)
    if not separate and not compatible(latent[0], opposing[1]):
        return F(0)
    midpoint = output[0]
    return (
        (proposal_rare if midpoint else 1 - proposal_rare)
        * middle_allowed(midpoint)
        / acceptance
    )


def output_mass(output, opposing, epsilon, separate, tagged):
    return sum(
        base(latent, epsilon)
        * reference_local(latent, opposing, separate)
        * (not latent[1] if tagged else 1)
        * kernel(latent, output, opposing, epsilon, separate)
        for latent in LOCAL_STATES
    )


def likelihood(output, opposing, epsilon, separate=False, tagged=True):
    return output_mass(output, opposing, epsilon, separate, tagged) / base(
        output, epsilon
    )


def selected_density(f, selected, values, epsilon):
    return sum(
        base(tuple(state[i] for i in range(2) if i not in selected), epsilon)
        * f[state]
        for state in LOCAL_STATES
        if all(state[i] == value for i, value in zip(selected, values))
    )


def insertion_minimum(edges, size, epsilon):
    minimum = F(1)
    for count in range(len(edges) + 1):
        for selected in combinations(edges, count):
            for label in range(size):
                for outside in product((0, 1), repeat=size):
                    success = sum(
                        base((bit,), epsilon)
                        * all(
                            compatible(bit, outside[j if i == label else i])
                            for i, j in selected
                            if label in (i, j)
                        )
                        for bit in (0, 1)
                    )
                    minimum = min(minimum, success)
    return minimum


def fixture(epsilon):
    c0 = F(3, 4)
    G = F(3)
    minimum_insertion = min(
        insertion_minimum(((0, 1), (2, 3), (0, 2), (1, 3)), 4, epsilon),
        insertion_minimum(((0, 1), (1, 2), (0, 2)), 3, epsilon),
    )
    require(minimum_insertion >= c0, "Check-deletion insertion bound failed")
    zminus = sum(
        base(state, epsilon) * compatible(*state) for state in LOCAL_STATES
    )
    zunion = sum(
        base(state, epsilon) * reference_union(state) for state in UNION_STATES
    )
    require(zunion > 0 and zminus > 0, "A normalizer vanished")
    ratio = zminus**2 / zunion
    beta_sum = 2 * epsilon
    ratio_bound = (1 - epsilon / c0) ** -2
    require(1 <= ratio <= ratio_bound, "Disjoint normalizer comparison failed")
    protocol_ratio = 1 / (1 - 2 * epsilon)
    require(protocol_ratio**2 - 1 <= 4 * beta_sum, "Transition increment failed")

    for opposing in LOCAL_STATES:
        for latent in LOCAL_STATES:
            row_mass = sum(
                kernel(latent, out, opposing, epsilon, False)
                for out in LOCAL_STATES
            )
            require(0 <= row_mass <= 1, "Original kernel is not substochastic")
            separate_mass = sum(
                kernel(latent, out, opposing, epsilon, True)
                for out in LOCAL_STATES
            )
            require(separate_mass == 1, "Separate kernel lost mass")
            for out in LOCAL_STATES:
                old = kernel(latent, out, opposing, epsilon, False)
                new = kernel(latent, out, opposing, epsilon, True)
                require(old <= protocol_ratio * new, "Pointwise comparison failed")
                if old and reference_local(latent, opposing, False):
                    require(
                        reference_local(out, opposing, False),
                        "An original output is not reference-admissible",
                    )

    tag_reference = sum(
        base(state, epsilon)
        * reference_union(state)
        * (not state[1])
        * (not state[3])
        for state in UNION_STATES
    ) / zunion
    tag_separate = sum(
        base(state, epsilon)
        * compatible(state[0], state[1])
        * compatible(state[2], state[3])
        * (not state[1])
        * (not state[3])
        for state in UNION_STATES
    ) / zunion
    tag_error = tag_separate - tag_reference
    require(0 <= tag_error <= ratio - 1, "Exact deleted-tag bound failed")
    require(ratio - 1 <= ratio * beta_sum / c0, "Union-bound tag estimate failed")

    moment = F(0)
    conditional_mass_error = F(0)
    for state in UNION_STATES:
        if not reference_union(state):
            continue
        left, right = state[:2], state[2:]
        ls = likelihood(left, right, epsilon)
        lt = likelihood(right, left, epsilon)
        moment += base(state, epsilon) * ls * lt / zunion
    for opposing in LOCAL_STATES:
        if not compatible(*opposing):
            continue
        zconditional = sum(
            base(latent, epsilon)
            * reference_local(latent, opposing, False)
            for latent in LOCAL_STATES
        )
        observed_mass = sum(
            base(out, epsilon)
            * reference_local(out, opposing, False)
            * likelihood(out, opposing, epsilon)
            for out in LOCAL_STATES
        ) / zconditional
        expected_mass = sum(
            base(latent, epsilon)
            * reference_local(latent, opposing, False)
            * (not latent[1])
            * sum(
                kernel(latent, out, opposing, epsilon, False)
                for out in LOCAL_STATES
            )
            for latent in LOCAL_STATES
        ) / zconditional
        conditional_mass_error += abs(observed_mass - expected_mass)
    require(conditional_mass_error == 0, "Conditional normalizer did not cancel")
    upper = tag_reference + (ratio - 1) + ratio * (protocol_ratio**2 - 1)
    require(moment <= upper, "Disjoint near-unit comparison failed")
    no_cross_mass = sum(
        base(out, epsilon)
        * compatible(*out)
        * likelihood(out, (0, 0), epsilon, True)
        for out in LOCAL_STATES
    ) / zminus
    no_cross_tag = sum(
        base(latent, epsilon) * compatible(*latent) * (not latent[1])
        for latent in LOCAL_STATES
    ) / zminus
    require(no_cross_mass**2 == no_cross_tag**2, "Zero-contact error is not zero")

    densities = {}
    maximal_marginals = {}
    for tagged in (False, True):
        f = {
            out: output_mass(out, (0, 0), epsilon, True, tagged)
            / (zminus * base(out, epsilon))
            for out in LOCAL_STATES
        }
        densities[tagged] = f
        for count in range(3):
            for selected in combinations(range(2), count):
                maximum = max(
                    selected_density(f, selected, values, epsilon)
                    for values in product((0, 1), repeat=count)
                )
                require(maximum <= G**count, "Selected output domination failed")
                maximal_marginals[f"{tagged}:{selected}"] = maximum

    f = densities[True]
    shared_integrals = {}
    for shared_count, sets in (
        (0, ((0, 1), (2, 3))),
        (1, ((0, 1), (1, 2))),
        (2, ((0, 1), (0, 1))),
    ):
        union_size = max(max(s) for s in sets) + 1
        total = sum(
            base(state, epsilon)
            * f[tuple(state[i] for i in sets[0])]
            * f[tuple(state[i] for i in sets[1])]
            for state in product((0, 1), repeat=union_size)
        )
        require(total <= G**shared_count, "Shared-output product bound failed")
        shared_integrals[str(shared_count)] = total
    actual_shared_moment = sum(
        base(out, epsilon)
        * compatible(*out)
        * likelihood(out, (0, 0), epsilon, True) ** 2
        for out in LOCAL_STATES
    ) / zminus
    require(
        actual_shared_moment <= zminus * G**2,
        "Shared conditional likelihood comparison failed",
    )
    triangle_states = tuple(product((0, 1), repeat=3))
    triangle_allowed = lambda state: all(
        compatible(state[i], state[j]) for i, j in combinations(range(3), 2)
    )
    ztriangle = sum(
        base(state, epsilon) * triangle_allowed(state)
        for state in triangle_states
    )
    shared_one_ratio = zminus**2 / ztriangle
    require(
        shared_one_ratio <= (1 / c0) / (1 - epsilon / c0),
        "One-shared-label normalizer comparison failed",
    )
    shared_one_moment = sum(
        base(state, epsilon)
        * triangle_allowed(state)
        * likelihood(state[:2], (state[2], state[2]), epsilon)
        * likelihood(state[1:], (state[0], state[0]), epsilon)
        for state in triangle_states
    ) / ztriangle
    require(
        shared_one_moment <= protocol_ratio**2 * shared_one_ratio * G,
        "One-shared-label conditional product comparison failed",
    )

    source_law = {
        latent: base(latent, epsilon) * compatible(*latent) / zminus
        for latent in LOCAL_STATES
    }
    opposing_law = {
        out: sum(
            source_law[latent] * kernel(latent, out, (0, 0), epsilon, True)
            for latent in LOCAL_STATES
        )
        for out in LOCAL_STATES
    }
    require(sum(opposing_law.values()) == 1, "Opposing output law is not normalized")
    for bit in (0, 1):
        source_marginal = sum(
            weight for latent, weight in source_law.items() if latent[0] == bit
        )
        require(
            source_marginal <= base((bit,), epsilon) / c0,
            "Retained-source free-law domination failed",
        )
    cost = lambda x, w: 1 / (F(1, 4) + abs(x - w))
    free_cost_cap = max(
        sum(
            (epsilon if x else 1 - epsilon) * cost(x, w) for x in (0, 1)
        )
        for w in (0, 1)
    )
    cross_cost = sum(
        source_law[latent]
        * kernel(latent, own_out, (0, 0), epsilon, True)
        * opposing_law[other_out]
        * cost(latent[0], other_out[0])
        for latent in LOCAL_STATES
        for own_out in LOCAL_STATES
        for other_out in LOCAL_STATES
    )
    require(
        cross_cost <= free_cost_cap / c0,
        "Retained-source versus opposing-output estimate failed",
    )
    source_one = sum(p for x, p in source_law.items() if x[0] == 1)
    own_joint_one = sum(
        source_law[latent]
        * kernel(latent, out, (0, 0), epsilon, True)
        for latent in LOCAL_STATES
        for out in LOCAL_STATES
        if latent[0] == out[1] == 1
    )
    require(own_joint_one == source_one, "The pin lost its latent source")
    require(
        own_joint_one != source_one**2,
        "The fixture accidentally made own pin and source independent",
    )
    return exact(
        {
            "epsilon": epsilon,
            "middle_proposal_rare": 2 * epsilon,
            "minimum_insertion_after_arbitrary_check_deletion": minimum_insertion,
            "separate_normalizer": zminus,
            "union_normalizer": zunion,
            "normalizer_ratio": ratio,
            "normalizer_ratio_bound": ratio_bound,
            "conditional_mass_error": conditional_mass_error,
            "original_tag_expectation": tag_reference,
            "deleted_tag_error": tag_error,
            "disjoint_product": moment,
            "near_unit_upper_bound": upper,
            "zero_contact_disjoint_error": no_cross_mass**2 - no_cross_tag**2,
            "selected_marginal_maxima": maximal_marginals,
            "free_shared_output_integrals": shared_integrals,
            "shared_conditional_product": actual_shared_moment,
            "one_shared_label_union_normalizer": ztriangle,
            "one_shared_label_normalizer_ratio": shared_one_ratio,
            "one_shared_label_conditional_product": shared_one_moment,
            "source_opposing_cost": cross_cost,
            "source_opposing_cost_cap": free_cost_cap / c0,
            "source_one_probability": source_one,
            "own_pin_source_joint_one": own_joint_one,
            "own_pin_source_product_one": source_one**2,
        }
    )


def sharp_overlap_examples():
    patterns = (
        ((0, 1), (2, 3)),
        ((0, 1), (1, 2)),
        ((0, 1), (1, 2), (2, 3)),
        ((0, 1), (1, 2), (0, 2)),
        ((0, 1), (0, 1), (0, 1)),
        ((0,), (0, 1), (0, 1, 2)),
    )
    results = []
    G = 3
    for sets in patterns:
        size = len(set().union(*map(set, sets)))
        exponent = sum(map(len, sets)) - size
        total = F(0)
        for state in product(range(G), repeat=size):
            value = F(1, G**size)
            for subset in sets:
                value *= G ** len(subset) if all(state[i] == 0 for i in subset) else 0
            total += value
        for subset in sets:
            local = tuple(product(range(G), repeat=len(subset)))
            for count in range(len(subset) + 1):
                for selected in combinations(range(len(subset)), count):
                    for values in product(range(G), repeat=count):
                        marginal = sum(
                            F(1, G ** (len(subset) - count))
                            * (G ** len(subset) if all(x == 0 for x in state) else 0)
                            for state in local
                            if all(state[i] == value for i, value in zip(selected, values))
                        )
                        require(0 <= marginal <= G**count, "Extremizer marginal bound failed")
        require(total == G**exponent, "Sharp overlap equality failed")
        results.append(
            {"sets": sets, "G": G, "overlap_exponent": exponent, "integral": total}
        )
    return exact(results)


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["timed_out"] is False, "Jacobian timed out")
    require(output["request"]["operation_id"] == OPERATION, "Wrong operation")
    require(output["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(output["result"]["operation_id"] == OPERATION, "Wrong typed result")
    typed = output["result"]["output"]
    space = payload["rv"]["space"]
    rational = lambda x: F(int(x["num"]), int(x["den"]))
    masses = list(map(rational, space["masses"]))
    values = list(map(rational, payload["rv"]["values"]))
    expected = {}
    for block in payload["sigma"]["blocks"]:
        indices = [space["samples"].index(sample) for sample in block]
        average = sum(masses[i] * values[i] for i in indices) / sum(
            masses[i] for i in indices
        )
        expected.update({sample: average for sample in block})
    actual = dict(zip(typed["space"]["samples"], map(rational, typed["values"])))
    require(actual == expected, "Jacobian conditional expectation replay failed")
    require(
        actual == {"00": F(1, 2), "01": F(0), "10": F(1, 2)},
        "Unexpected conditioning result",
    )
    return exact(
        {
            "operation_id": OPERATION,
            "server_version": output["server"]["version"],
            "protocol_version": output["protocol_version"],
            "adapter_exit_code": status["adapter_exit_code"],
            "timed_out": status["timed_out"],
            "conditional_expectation": actual,
            "mathematical_scope": "finite conditioning example, not a manuscript refutation",
        }
    )


def source_map():
    assertions = (
        ("long-palm.tex", "long:exact-likelihood", r"L_S(z,o)=\frac{\dd M_S(o)}{\dd B_S}(z)."),
        ("long-palm.tex", "right-pin enlargement", "The left suffix pins do not use these right paths."),
        ("long-palm.tex", "prefix seam", "all checks using the old trajectory are among the deleted"),
        ("long-palm.tex", "retained sources", "these sources lie in the"),
        ("long-palm.tex", "distinct sources", "The sources for distinct pins are distinct labels."),
        ("long-palm.tex", "separate latent copies", "These copies are not identified even if"),
        ("long-palm.tex", "long:disjoint-product", r"\E[L_SL_T\mid U^c]\le"),
        ("long-palm.tex", "long:shared-product", r"\le e^{C D^{-19/100}J}G_D^q"),
        ("local-paths.tex", "check-deletion quantifier", "an arbitrary subset of avoidance"),
        ("local-paths.tex", "local Gaussian ratio", r"\leq C D^{C\sqrt{x}}."),
    )
    result = []
    for filename, locator, literal in assertions:
        source = " ".join((MANUSCRIPT / filename).read_text().split())
        require(" ".join(literal.split()) in source, f"Source changed at {locator}")
        result.append({"file": filename, "locator": locator, "literal": literal})
    return result


def formal_replay():
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (claim for claim in state["claims"] if claim["claim_id"] == "C_LPP_ALGEBRA"),
        key=lambda item: item["version"],
    )
    evidence = [
        item
        for item in state["evidence"]
        if item["subject"]["subject_id"] == "C_LPP_ALGEBRA"
        and item["subject"]["content_hash"] == claim["content_hash"]
        and item["tier"] == "mechanical"
        and item["verdict"] == "supports"
    ]
    require(len(evidence) == 1, "Expected one current mechanical core certificate")
    artifact = evidence[0]["artifact"]
    proof = json.loads((ROOT / artifact).read_text())
    require(proof["subject"] == evidence[0]["subject"], "Formal subject mismatch")
    run = proof["lean_check"]
    require(run["status"] == "success", "Lean did not succeed")
    require(run["exit_code"] == run["audit_exit_code"] == 0, "Lean or axiom audit failed")
    require(run["proof_holes"] == [], "Lean proof has holes")
    require(not run["environment_failure"], "Lean environment failure")
    for source, field in (
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ):
        current = (HERE / source).read_bytes()
        archived = (HERE / "lean" / source).read_bytes()
        require(current == archived, f"Compiled copy is stale: {source}")
        require(
            hashlib.sha256(current).hexdigest() == run[field],
            f"Compiler certificate is stale: {source}",
        )
    version = run["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "Unexpected Lean version")
    return {
        "claim": "C_LPP_ALGEBRA",
        "artifact": artifact,
        "compiler_version": version,
        "compiler_exit_code": run["exit_code"],
        "axiom_audit_exit_code": run["audit_exit_code"],
        "proof_holes": run["proof_holes"],
        "source_and_statement_fidelity_fresh": True,
        "scope": "universal finite algebra only",
    }


def duplicate_source_boundary():
    source = {0: F(1, 2), 1: F(1, 2)}
    joint = {
        (x, y): sum(
            weight * (x == latent) * (y == latent)
            for latent, weight in source.items()
        )
        for x, y in LOCAL_STATES
    }
    density = {state: weight / F(1, 4) for state, weight in joint.items()}
    require(density[(0, 0)] == density[(1, 1)] == 2, "Wrong diagonal density")
    require(density[(0, 1)] == density[(1, 0)] == 0, "Wrong off-diagonal density")
    for selected in (0, 1):
        for bit in (0, 1):
            marginal = sum(weight for state, weight in joint.items() if state[selected] == bit)
            require(marginal / F(1, 2) == 1, "Single pin is not uniform")
    return {
        "joint_density_on_diagonal": "2",
        "single_output_density": "1",
        "is_manuscript_counterexample": False,
    }


def certificate():
    return {
        "schema_version": 1,
        "campaign": "9000267",
        "claim": "C_LPP_VERIFICATION",
        "result_class": "conditional_verification",
        "mathematical_scope": "source-retaining comparison theorem and universal finite algebra",
        "manuscript_refuted": False,
        "full_gas_theorem_certified": False,
        "independent_review": "required; not performed by the Engineer",
        "novelty_status": "not_established",
        "analytic_inputs": [
            "The exact conditional admissible product-bridge law",
            "Uniform c0=3/4 one-path insertion after arbitrary check deletion",
            "Ordinary, uniform-midpoint, and separated pinned collision estimates",
            "History-uniform middle primary domination and capped pin divisors",
            "Neighboring Gaussian midpoint ratio and bounded contact multiplicity",
        ],
        "source_map": source_map(),
        "jacobian": jacobian_replay(),
        "disjoint_and_shared_fixtures": [fixture(F(1, n)) for n in (16, 32, 64)],
        "sharp_overlap_examples": sharp_overlap_examples(),
        "duplicate_source_boundary": duplicate_source_boundary(),
        "formal_core": formal_replay(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="Write exact arithmetic results")
    args = parser.parse_args()
    result = certificate()
    path = HERE / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == result, "Exact certificate is stale")
    print(
        "Exact replay passed: 3 conditional-product fixtures, 6 sharp overlap "
        "examples, retained-source costs, Jacobian output, and a fresh zero-hole "
        "Lean 4.31.0 core. No gas theorem or manuscript refutation is inferred."
    )


if __name__ == "__main__":
    main()
