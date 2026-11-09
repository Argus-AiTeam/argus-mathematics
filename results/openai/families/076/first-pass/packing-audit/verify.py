#!/usr/bin/env python3
"""Replay exact packing evidence; universal counting is certified by Lean."""

import argparse
from collections import Counter
from fractions import Fraction
from functools import cache
from hashlib import sha256
from itertools import combinations, product
import json
from math import comb, isqrt
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def rational(value):
    value = Fraction(value)
    return [value.numerator, value.denominator]


def prime(q):
    return q >= 2 and all(q % d for d in range(2, isqrt(q) + 1))


def dot(a, x, q):
    return sum(c * y for c, y in zip(a, x)) % q


def rank(rows, q):
    matrix = [[value % q for value in row] for row in rows]
    height, width = len(matrix), len(matrix[0])
    pivot = 0
    for column in range(width):
        found = next((j for j in range(pivot, height) if matrix[j][column]), None)
        if found is None:
            continue
        matrix[pivot], matrix[found] = matrix[found], matrix[pivot]
        inverse = pow(matrix[pivot][column], -1, q)
        matrix[pivot] = [(value * inverse) % q for value in matrix[pivot]]
        for j in range(height):
            if j != pivot:
                coefficient = matrix[j][column]
                matrix[j] = [
                    (a - coefficient * b) % q
                    for a, b in zip(matrix[j], matrix[pivot])
                ]
        pivot += 1
        if pivot == height:
            break
    return pivot


def scalar_multiple(g, f, q):
    pivot = next(j for j, value in enumerate(f) if value % q)
    coefficient = (g[pivot] * pow(f[pivot] % q, -1, q)) % q
    if all((a - coefficient * b) % q == 0 for a, b in zip(g, f)):
        return coefficient
    return None


def exceptional_centers(forms, i, q, radius):
    result = set()
    others = [j for j in range(len(forms)) if j != i]
    for j, k in combinations(others, 2):
        for sign in (-1, 1):
            row = tuple(a + sign * b for a, b in zip(forms[j], forms[k]))
            coefficient = scalar_multiple(row, forms[i], q)
            if coefficient is not None:
                require(coefficient != 0, "Pairwise nonparallelism was lost.")
                inverse = pow(coefficient, -1, q)
                result.update((t * inverse) % q for t in range(-radius, radius + 1))
    result.discard(0)
    return result


class Slots:
    """Exact marginal probabilities, integrating shifts and slot orientations."""

    def __init__(self, q, lengths):
        require(prime(q) and q % 2, "The slot model requires an odd prime.")
        require(all(width > 0 and width % 2 for width in lengths), "Odd widths required.")
        self.q, self.lengths = q, tuple(lengths)
        self.period, self.radius = sum(lengths), isqrt(q)
        self.n = (q - 1) // 2
        self.chunks = [
            (left, min(self.n, left + self.radius - 1))
            for left in range(1, self.n + 1, self.radius)
        ]
        self.patterns = []
        for left, right in self.chunks:
            shifted = []
            for shift in range(self.period):
                centers, offset = {}, 0
                for kind, width in enumerate(lengths):
                    base = 1 + offset + shift
                    first = base + ((left - base + self.period - 1) // self.period) * self.period
                    for start in range(first, right - width + 2, self.period):
                        centers[start + (width - 1) // 2] = kind
                    offset += width
                shifted.append(centers)
            self.patterns.append(shifted)

    def fold(self, residue):
        residue %= self.q
        return min(residue, self.q - residue)

    def chunk(self, residue):
        return (self.fold(residue) - 1) // self.radius

    def interior(self, residue):
        site = self.fold(residue)
        if not site:
            return False
        left, right = self.chunks[self.chunk(residue)]
        return min(site - left, right - site) >= self.period

    @cache
    def chunk_probability(self, chunk, requirements):
        centers = {}
        for kind, residue in requirements:
            site = self.fold(residue)
            orientation = 1 if residue <= self.n else -1
            required = (kind, orientation)
            if site in centers and centers[site] != required:
                return Fraction(0)
            centers[site] = required
        valid = sum(
            all(pattern.get(site) == kind for site, (kind, _) in centers.items())
            for pattern in self.patterns[chunk]
        )
        return Fraction(valid, self.period * 2 ** len(centers))

    def probability(self, requirements):
        grouped = {}
        for kind, residue in requirements:
            residue %= self.q
            if residue == 0:
                return Fraction(0)
            grouped.setdefault(self.chunk(residue), set()).add((kind, residue))
        value = Fraction(1)
        for chunk, events in grouped.items():
            value *= self.chunk_probability(chunk, tuple(sorted(events)))
        return value

    def good(self, requirements, conditioning_chunk):
        if not all(self.interior(residue) for _, residue in requirements):
            return False
        chunks = [self.chunk(residue) for _, residue in requirements]
        return conditioning_chunk not in chunks and len(set(chunks)) == len(chunks)

    def bound(self, r, u):
        k = u * (r - 1)
        tau = Fraction(1 + 4 * self.period * len(self.chunks) + 2 * self.radius, self.q)
        return k * tau + 2 * comb(k, 2) * Fraction(2 * self.radius + 1, self.q)


def counting_checks(forms, i, s, q, fiber, radius):
    counts_checked, constant_branches = 0, 0
    rows = [forms[j] for j in range(len(forms)) if j != i]
    rows += [
        tuple(a + sign * b for a, b in zip(forms[j], forms[k]))
        for j, k in combinations([j for j in range(len(forms)) if j != i], 2)
        for sign in (-1, 1)
    ]
    for row in rows:
        counts = Counter(dot(row, y, q) for y in fiber)
        coefficient = scalar_multiple(row, forms[i], q)
        if coefficient is None:
            require(
                all(counts[value] * q == len(fiber) for value in range(q)),
                "The nonconstant fiber distribution was not uniform.",
            )
        else:
            require(counts == {coefficient * s % q: len(fiber)}, "Wrong constant branch.")
            if coefficient:
                constant_branches += 1
                require(
                    min(coefficient * s % q, (-coefficient * s) % q) > radius,
                    "A tested center is exceptional.",
                )
        counts_checked += 1
    return {"signed_and_single_forms": counts_checked, "constant_branches": constant_branches}


def moment_case(name, q, forms, lengths, i, s, orders):
    require(all(rank([a, b], q) == 2 for a, b in combinations(forms, 2)), "Excluded prime.")
    model = Slots(q, lengths)
    exceptional = exceptional_centers(forms, i, q, model.radius)
    require(s and s not in exceptional, "Moment fixture is outside the claimed domain.")
    fiber = [
        y for y in product(range(q), repeat=len(forms[0])) if dot(forms[i], y, q) == s
    ]
    require(len(fiber) == q ** (len(forms[0]) - 1), "Incorrect affine fiber cardinality.")
    counting = counting_checks(forms, i, s, q, fiber, model.radius)
    evaluations = [
        tuple((j, dot(forms[j], y, q)) for j in range(len(forms)) if j != i)
        for y in fiber
    ]
    presence = model.probability(((i, s),))
    require(presence > 0, "Conditioning event has zero probability.")
    p = Fraction(1, 2 * model.period)
    results = []
    for u in orders:
        target = p ** (u * (len(forms) - 1))
        total, bad, good = Fraction(0), 0, 0
        for samples in product(evaluations, repeat=u):
            events = tuple(event for sample in samples for event in sample)
            probability = model.probability(events + ((i, s),)) / presence
            require(0 <= probability <= 1, "Invalid exact conditional probability.")
            if model.good(events, model.chunk(s)):
                require(probability == target, "Good tuple did not factor by chunks.")
                good += 1
            else:
                bad += 1
            total += probability
        denominator = len(fiber) ** u
        moment, bad_fraction = total / denominator, Fraction(bad, denominator)
        bound = model.bound(len(forms), u)
        require(bad_fraction <= bound, "The explicit good-tuple union bound failed.")
        require(abs(moment - target) <= bad_fraction, "Bad-tuple decomposition failed.")
        require(abs(moment - target) <= bound, "The requested conditional bound failed.")
        results.append({
            "u": u,
            "moment": rational(moment),
            "target": rational(target),
            "absolute_error": rational(abs(moment - target)),
            "explicit_bound": rational(bound),
            "bad_fraction": rational(bad_fraction),
            "good_tuples": good,
            "fiber_tuples": denominator,
        })
    return {
        "name": name, "q": q, "forms": forms, "lengths": lengths, "i": i, "s": s,
        "rank": rank(forms, q), "r": len(forms), "m": len(forms[0]),
        "fiber_size": len(fiber), "conditioning_probability": rational(presence),
        "conditioning_center_interior": model.interior(s),
        "exceptional_center_count": len(exceptional), "counting": counting,
        "moments": results,
    }


def formal_certificate():
    result = json.loads((ROOT / "formal/lean_check.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0, "Lean did not succeed.")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0, "Proof holes found.")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "Wrong Lean version.")
    for filename, key in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256"),
    ]:
        text = (ROOT / "formal" / filename).read_text()
        require(sha256(text.encode()).hexdigest() == result[key], f"Stale {filename} evidence.")
    archive_path = ROOT / "formal/certificates/C_PACK_COUNT-0dd7e477d502abfe.json"
    archive = json.loads(archive_path.read_text())
    require(archive["lean_check"] == result, "The archived compiler result changed.")
    require(archive["subject"]["subject_id"] == "C_PACK_COUNT", "Wrong claim certificate.")
    require(archive["verdict"] == "supports", "The compiler certificate does not support.")
    require(
        archive["lean_source"]["text"] == (ROOT / "formal/Main.lean").read_text(),
        "Archived formal statement differs from the current source.",
    )
    require(
        archive["statement_fidelity"]["text"] == (ROOT / "formal/statement_fidelity.md").read_text(),
        "Archived fidelity differs from the current document.",
    )
    project = ROOT.parent.parent
    state = json.loads((project / "research/MATH_STATE.json").read_text())
    claim = [item for item in state["claims"] if item["claim_id"] == "C_PACK_COUNT"][-1]
    require(claim["content_hash"] == archive["subject"]["content_hash"], "Stale claim version.")
    require(claim["formal_statement"] == archive["lean_source"]["text"], "Claim translation changed.")
    require(any(
        item["evidence_id"] == archive["evidence_id"]
        and item["artifact"] == str(archive_path.relative_to(project))
        and item["tier"] == "mechanical" and item["verdict"] == "supports"
        for item in state["evidence"]
    ), "The real compiler result is not attached to the claim ledger.")
    return {
        "claim": "C_PACK_COUNT",
        "certificate": str(archive_path.relative_to(ROOT)),
        "lean_version": "4.31.0", "exit_code": 0, "proof_holes": [],
        "source_and_fidelity_match_official_certificate": True,
        "formal_scope": "Exact uniform counts on arbitrary finite-field affine fibers and the constant/nonproportional alternatives.",
    }


def edge_and_geometry():
    q, forms = 101, [(1, 0), (0, 1), (1, 1), (1, 2)]
    model, chosen, all_events, used = Slots(q, [1, 1, 1, 1]), [], [], set()
    for y in product(range(q), repeat=2):
        events = [(j, dot(row, y, q)) for j, row in enumerate(forms)]
        sites = [model.fold(value) for _, value in events]
        if 0 in sites or len(set(sites)) != len(sites) or used.intersection(sites):
            continue
        if not chosen and model.n not in sites:
            continue
        if model.probability(tuple(all_events + events)) == 0:
            continue
        chosen.append(y)
        all_events.extend(events)
        used.update(sites)
        if len(chosen) == 2:
            break
    require(len(chosen) == 2, "No two-edge exact geometry fixture found.")
    width, arcs = Fraction(1, 1000 * len(chosen)), []
    for _, residue in all_events:
        for signed in (residue, (-residue) % q):
            center = Fraction(signed, q)
            left, right = center - width / 2, center + width / 2
            container_left, container_right = center - Fraction(1, 2 * q), center + Fraction(1, 2 * q)
            require(container_left < left < right < container_right, "Containment is not strict.")
            require(0 < left < right < 1, "An arc wrapped across zero.")
            arcs.append((left, right))
    arcs.sort()
    require(all(a[1] < b[0] for a, b in zip(arcs, arcs[1:])), "Closed arcs intersect.")
    require(arcs[-1][1] < 1 + arcs[0][0], "Circular gap is missing.")
    require(model.n in used, "Half-circle endpoint case was not exercised.")
    return {
        "q": q, "forms": forms, "H": len(chosen), "generating_vectors": chosen,
        "widths_w_i": [[1, 1000]] * len(forms),
        "joint_slot_event_probability": rational(model.probability(tuple(all_events))),
        "signed_closed_arcs": [[rational(a), rational(b)] for a, b in arcs],
        "container_reflections_share_half_circle_endpoint": True,
        "desired_closed_arcs_strictly_disjoint": True,
    }


def guards():
    modular_forms = [(1, 0), (0, 1), (1, 102)]
    exceptions = exceptional_centers(modular_forms, 0, 101, 10)
    require(1 in exceptions and 11 not in exceptions, "Modular-only relation was missed.")
    require(scalar_multiple((-1, -101), modular_forms[0], 101) == 100, "Wrong modular relation.")
    require(rank([(1, 0), (1, 3)], 3) == 1, "Excluded-prime fixture was not degenerate.")
    short = Slots(11, [3, 3])
    require(short.probability(((0, 4),)) == 0, "Short-final-chunk zero-probability fixture failed.")
    require(short.probability(((0, 0),)) == 0, "Zero can never be a slot center.")
    q = 1_000_003
    require(prime(q), "Large bound-only fixture is not prime.")
    radius, period = isqrt(q), 4
    chunks = (((q - 1) // 2) + radius - 1) // radius
    tau = Fraction(1 + 4 * period * chunks + 2 * radius, q)
    delta2 = 6 * tau + 2 * comb(6, 2) * Fraction(2 * radius + 1, q)
    require(0 < delta2 < 1, "Explicit second-moment bound is vacuous in the large fixture.")
    third = Slots(101, [1, 1])
    events, presence = ((1, 5), (1, 15), (1, 35)), third.probability(((0, 21),))
    require(third.good(events, third.chunk(21)), "Third-order good tuple was not good.")
    require(
        third.probability(events + ((0, 21),)) / presence == Fraction(1, 4) ** 3,
        "Third-order conditional chunk factorization failed.",
    )
    return {
        "modular_only_relation": {"q": 101, "forms": modular_forms, "exceptional_s": 1, "allowed_s": 11},
        "excluded_odd_prime": {"q": 3, "rows": [[1, 0], [1, 3]], "rank": 1},
        "zero_probability_conditioning_not_evaluated": {"q": 11, "lengths": [3, 3], "s": 4},
        "nonvacuous_analytic_bound_only": {"q": q, "u": 2, "r": 4, "bound": rational(delta2)},
        "explicit_third_order_good_tuple": {
            "q": 101, "forms": [[1, 0], [0, 1]], "s": 21,
            "other_evaluations": [5, 15, 35], "conditional_product_probability": [1, 64],
        },
    }


def full_random_state_check():
    q, forms, lengths, s = 11, [(1, 0), (0, 1)], [1, 3], 4
    model = Slots(q, lengths)
    local_states = []
    for patterns in model.patterns:
        states = []
        for pattern in patterns:
            slots = sorted(pattern.items())
            for signs in product((-1, 1), repeat=len(slots)):
                centers = frozenset(
                    (kind, (sign * site) % q)
                    for (site, kind), sign in zip(slots, signs)
                )
                states.append((centers, Fraction(1, model.period * 2 ** len(slots))))
        require(sum(weight for _, weight in states) == 1, "Local state weights do not sum to one.")
        local_states.append(states)
    presence, first, second, state_count = Fraction(0), Fraction(0), Fraction(0), 0
    for states in product(*local_states):
        state_count += 1
        centers, weight = set(), Fraction(1)
        for local_centers, local_weight in states:
            centers.update(local_centers)
            weight *= local_weight
        if (0, s) not in centers:
            continue
        value = Fraction(sum((1, y) in centers for y in range(q)), q)
        presence += weight
        first += weight * value
        second += weight * value * value
    require(presence > 0, "Full-state conditioning event is empty.")
    reference = moment_case("full_state_reference", q, forms, lengths, 0, s, [1, 2])
    observed = [rational(first / presence), rational(second / presence)]
    require(
        observed == [entry["moment"] for entry in reference["moments"]],
        "Direct random-state enumeration disagrees with the fiber moment expansion.",
    )
    require(rational(presence) == reference["conditioning_probability"], "Presence marginals disagree.")
    return {
        "q": q, "forms": forms, "lengths": lengths, "s": s,
        "full_shift_and_orientation_states": state_count,
        "conditioning_probability": rational(presence), "moments_u_1_2": observed,
        "independent_expansion_paths_agree": True,
    }


def jacobian_result():
    request = json.loads((ROOT / "jacobian_request.json").read_text())
    result = json.loads((ROOT / "jacobian_result.json").read_text())
    require(result["request"]["payload"] == request, "Jacobian source payload differs.")
    require(result["result"]["operation_id"] == "prime_field.matrix.rank.compute", "Wrong operation.")
    require(result["result"]["output"]["source"] == request, "Jacobian omitted source binding.")
    require(result["result"]["output"]["rank"] == rank(request["matrix"]["entries"], 101) == 2, "Wrong rank.")
    return {
        "operation_id": result["result"]["operation_id"], "rank": 2,
        "server_version": result["server"]["version"], "protocol_version": result["protocol_version"],
        "adapter_status": "success", "structured_error": None,
        "not_a_conditional_moment_or_packing_certificate": True,
    }


def build_certificate():
    forms = [(1, 0), (0, 1), (1, 1), (1, 2)]
    cases = [
        moment_case("dependent_boundary", 101, forms, [1, 1, 1, 1], 0, 11, [1, 2]),
        moment_case("other_fiber_boundary", 101, forms, [1, 1, 1, 1], 1, 21, [1, 2]),
        moment_case("unequal_odd_slots", 101, forms, [1, 3, 1, 3], 0, 11, [1, 2]),
        moment_case("good_tuples_with_dependencies", 211, forms, [1, 1, 1, 1], 0, 15, [1, 2]),
        moment_case("second_moment_distinct_chunks", 211, forms[:3], [1, 1, 1], 0, 15, [1, 2]),
        moment_case("modular_only_exception", 101, [(1, 0), (0, 1), (1, 102)], [1, 1, 1], 0, 11, [1, 2]),
        moment_case("rank_below_ambient_dimension", 7, [(1, 0, 0), (0, 1, 0), (1, 1, 0), (1, 2, 0)], [1] * 4, 0, 3, [1, 2]),
        moment_case("rank_three_higher_dependencies", 11, [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (1, 0, 1)], [1] * 5, 0, 4, [1, 2]),
        moment_case("third_raw_moment", 31, forms, [1, 1, 1, 1], 0, 6, [3]),
    ]
    require(any(m["good_tuples"] for case in cases for m in case["moments"]), "No good tuple exercised.")
    require(any(
        m["u"] == 2 and m["good_tuples"] > 0
        for case in cases for m in case["moments"]
    ), "Second-moment good tuples were not exercised.")
    require(any(case["r"] > case["m"] for case in cases), "Higher dependencies not exercised.")
    require(any(not case["conditioning_center_interior"] for case in cases), "Boundary centers not exercised.")
    return {
        "schema_version": 1,
        "result_class": "parameter_uniform_verification",
        "manuscript_refutations": [],
        "novelty": "No verified-new literature-novelty claim; the exact theorem extends the displayed estimates to every positive integer raw moment.",
        "universal_theorem": {
            "claim": "C_PACK_MOMENTS", "proof": "report.md",
            "orders": "every positive integer u",
            "error_bound": "u(r-1)tau_q + 2 binom(u(r-1),2)(2R+1)/q",
            "scope": "arbitrary pairwise nonparallel forms, s!=0 outside E_i, Pr(V_i_s)>0",
            "packing_implication": "report.md: From moments to the manuscript's matching; Strict closed-interval containment",
            "external_input": "Alon-Yuster (2005), Lemma 2.1, doi:10.1007/s00373-005-0628-x",
            "formalization_does_not_cover_probability_matching_or_geometry": True,
        },
        "formal_counting": formal_certificate(),
        "jacobian": jacobian_result(),
        "finite_regressions_not_a_universal_proof": cases,
        "scope_guards": guards(),
        "separate_full_random_state_enumeration": full_random_state_check(),
        "exact_small_matching_and_geometry": edge_and_geometry(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    actual = json.loads(json.dumps(build_certificate()))
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(actual, indent=2) + "\n")
    else:
        require(json.loads(path.read_text()) == actual, "The exact certificate does not replay.")
    print(json.dumps({
        "status": "verified",
        "finite_model_cases": len(actual["finite_regressions_not_a_universal_proof"]),
        "lean_exit_code": actual["formal_counting"]["exit_code"],
        "proof_holes": actual["formal_counting"]["proof_holes"],
        "universal_proof": "report.md plus the separately scoped formal counting certificate",
        "independent_review": "pending Host-invoked Reviewer",
    }))


if __name__ == "__main__":
    main()
