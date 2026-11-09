#!/usr/bin/env python3
"""Replay exact supporting calculations and the recorded all-finite Lean core."""

import hashlib
import itertools
import json
import math
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def product(values):
    return math.prod(values, start=F(1))


def partial_matchings(rows, columns):
    def extend(row, used, chosen):
        if row == rows:
            yield tuple(chosen)
            return
        yield from extend(row + 1, used, chosen)
        for column in range(columns):
            if column not in used:
                chosen.append((row, column))
                yield from extend(row + 1, used | {column}, chosen)
                chosen.pop()

    yield from extend(0, set(), [])


def check_parameters(certificate):
    p = certificate["parameters"]
    eps, root_eps, a, d = (F(p[key]) for key in ("eps", "sqrt_eps", "a", "D"))
    require(root_eps * root_eps == eps == F(1, 2**30), "epsilon normalization")
    require(a == 1 + eps and d == F(1, 1024), "original geometric parameters")
    require(F(p["v"]) == F(1, 64), "original volume parameter")
    require(p["lambda0"] == "log(1+D/a)"
            and p["gamma"] == "log(4)-2*lambda0"
            and p["c0"] == "1/(64*max(C_star,1))"
            and p["Ctail"] == "2*k0+5/2", "quantified symbolic constants")
    require(8 * root_eps / d == F(p["coarse_ratio"]) == F(1, 4), "coarse ratio")
    require(1 - 2 * eps + F(2, 3) * eps**2 < 1 - eps <= 1 / a,
            "strict cap-radius comparison polynomial")
    require(0 < d / a < d and 5 * d < 1, "positive separation of exponential rates")
    s = certificate["exact_scalar_identities"]
    require(F(s["target_exponent"]) - F(s["allowed_self_exponent"])
            == F(s["diagonal_gap"]) == F(3, 64), "self/target exponent gap")
    require(F(s["diagonal_gap"]) - F(s["safe_diagonal_gap"]) == F(1, 64),
            "polynomial absorption margin")
    require(F(1, 2) - 2 * F(s["target_exponent"])
            == F(s["fine_pair_gap"]) == F(3, 8), "fine-pair union-bound margin")
    require(s["coarse_rate_prefactor"] == 8 * 4 == 32, "coarse prefactor")
    require(s["ordered_bad_pair_prefactor"] == 2 * 10 // 2 == 10, "ordered pairs")
    require(s["diagonal_denominator_prefactor"] == 2 * 4 == 8, "Janson denominator")
    require(s["cross_dependency_prefactor"] == 4 * 10 == 40, "cross activity bounds")
    require(s["polynomial_error_prefactor"] == 10 * 32 == 320, "polynomial error")
    require(s["polynomial_error_exponent"] == "2*k0+3/2", "polynomial error exponent")
    require(F(5, 2) == F(3, 2) + 1, "final denominator absorption")
    original = certificate["original_pattern_parameters"]
    k0 = original["length_exponent_k0"]
    require(k0 == 3 and 2*k0 + F(5, 2) == F(original["permitted_Ctail"]) == F(17, 2),
            "explicit original-pattern polynomial loss")
    require(20 * 9 / F(p["v"]) + 1
            == original["length_bound_dimension_threshold"] == 11521,
            "uniform original-pattern length coefficient")
    require(1 + F(5, 2**3) < 2, "uniform outer-radius exponent at n>=2")
    exp_upper = sum((F(1, math.factorial(j)) for j in range(6)), F(0)) + F(7, 4320)
    require(exp_upper < 3, "rational series upper bound for e<3")


def check_jacobian(certificate):
    specification = certificate["jacobian"]
    payload = json.loads((HERE / specification["payload"]).read_text())
    response = json.loads((HERE / specification["output"]).read_text())
    require(specification["adapter_exit_code"] == 0
            and specification["adapter_status"] == "completed"
            and not specification["adapter_timeout"]
            and specification["adapter_error"] is None, "adapter execution was inconclusive")
    require(response["protocol_version"] == specification["protocol_version"],
            "Jacobian protocol")
    require(response["server"]["version"] == specification["server_version"],
            "Jacobian server")
    require(response["request"]["operation_id"] == specification["operation_id"]
            == response["result"]["operation_id"], "Jacobian operation binding")
    require(response["request"]["payload"] == payload, "Jacobian exact payload")
    require("error" not in response and "error" not in response["result"],
            "Jacobian structured error")
    expected_edges = {(i, j) for i in range(3) for j in range(3, 6)}
    graph = payload["graph"]
    require(graph["vertex_count"] == 6
            and {(e["u"], e["v"]) for e in graph["edges"]} == expected_edges
            and len(graph["edges"]) == 9, "Jacobian graph is not K_3,3")
    terms = {term["degree"]: term["coefficient"]
             for term in response["result"]["output"]["terms"]}
    counts = certificate["repeated_slot_fixture"]["matching_counts_by_size"]
    require(terms == {6 - 2 * k: (-1)**k * count
                      for k, count in enumerate(counts)}, "Jacobian matching polynomial")


def check_matchings(certificate):
    enumeration_count = 0
    weighted_terms = 0
    for n in range(7):
        counts = [0] * (n + 1)
        for matching in partial_matchings(n, n):
            counts[len(matching)] += 1
        require(counts == [math.comb(n, k)**2 * math.factorial(k) for k in range(n + 1)],
                f"labeled matching counts at size {n}")
        enumeration_count += sum(counts)
        if n == 3:
            require(counts == certificate["repeated_slot_fixture"]["matching_counts_by_size"],
                    "three repeated slots")

    for n in range(6):
        a = [F(i + 2) for i in range(n)]
        w = {(i, j): F((3 * i + 2 * j + 1) % 5, 6)
             for i in range(n) for j in range(n) if i != j}
        full = F(0)
        completed = F(0)
        global_factor = product(x * x for x in a)
        for matching in partial_matchings(n, n):
            full += product(a[i]**2 - 1 if i == j else w[i, j] * a[i] * a[j]
                            for i, j in matching)
            if any(i == j for i, j in matching):
                continue
            incident = {i for i, _ in matching} | {j for _, j in matching}
            weight = product(w[i, j] * a[i] * a[j] for i, j in matching)
            term = weight * product(a[i]**2 for i in range(n) if i not in incident)
            require(term <= global_factor * product(w[i, j] for i, j in matching),
                    f"normalization for directed matching {matching}")
            completed += term
            weighted_terms += 1
        rhs = global_factor * product(1 + sum((w[i, j] for j in range(n) if i != j), F(0))
                                      for i in range(n))
        require(full == completed <= rhs, f"loop completion and row product at size {n}")

    fixture = certificate["repeated_slot_fixture"]
    lam = F(fixture["intensity"])
    counts = fixture["matching_counts_by_size"]
    second_moment = sum((F(count) / lam**k for k, count in enumerate(counts)), F(0))
    require(second_moment == F(fixture["normalized_second_moment"]) == 352,
            "repeated-slot normalized second moment")
    delta = 1 + 1 / lam
    w = 1 / (1 + lam)
    require(delta**3 * (1 + 2 * w)**3 == F(fixture["self_product_upper_bound"]) == 1000,
            "repeated-slot self-product bound")
    require(lam**3 == F(fixture["activity"]) == F(1, 27), "ordered activity, no factorial")
    full_permutations = [p for p in partial_matchings(3, 3) if len(p) == 3]
    identity = tuple((i, i) for i in range(3))
    require(sum(p == identity for p in full_permutations)
            == fixture["full_identity_matchings"] == 1, "identity matching")
    require(sum(p != identity for p in full_permutations)
            == fixture["other_full_matchings"] == 5, "nonidentity full matchings")
    return enumeration_count, weighted_terms


def polynomial_mul(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            result[i + j] += x * y
    return result


def falling_polynomial(k):
    result = [1]
    for j in range(k):
        result = polynomial_mul(result, [-j, 1])
    return result


def check_factorial_moment_polynomials():
    identities = 0
    for k in range(6):
        for ell in range(6):
            left = polynomial_mul(falling_polynomial(k), falling_polynomial(ell))
            right = [0] * (k + ell + 1)
            for r in range(min(k, ell) + 1):
                multiplicity = math.comb(k, r) * math.comb(ell, r) * math.factorial(r)
                for degree, coefficient in enumerate(falling_polynomial(k + ell - r)):
                    right[degree] += multiplicity * coefficient
            require(left == right, f"factorial moment identity ({k},{ell})")
            identities += 1
    return identities


def check_finite_janson():
    probabilities = (F(1, 4), F(1, 2), F(3, 4))

    def occurrence(mask):
        return product(p for i, p in enumerate(probabilities) if mask & (1 << i))

    states = []
    for state in range(8):
        mass = product(p if state & (1 << i) else 1 - p
                       for i, p in enumerate(probabilities))
        states.append((state, mass))
    require(sum((mass for _, mass in states), F(0)) == 1, "Bernoulli mass")
    log_lower_bounds = {}
    cases = 0
    for length in range(1, 5):
        for family in itertools.product(range(1, 8), repeat=length):
            mean = sum((occurrence(mask) for mask in family), F(0))
            dependency = sum((occurrence(x | y) for x in family for y in family if x & y),
                             F(0))
            zero = sum((mass for state, mass in states
                        if all(state & mask != mask for mask in family)), F(0))
            require(0 < mean <= dependency and 0 < zero < 1, "finite Janson hypotheses")
            if zero not in log_lower_bounds:
                t = (1 - zero) / (1 + zero)
                log_lower_bounds[zero] = 2 * sum((t**(2*j + 1) / (2*j + 1)
                                                 for j in range(32)), F(0))
            exponent = mean**2 / (2 * dependency)
            require(log_lower_bounds[zero] >= exponent,
                    f"exact sufficient Janson logarithm bound for {family}")
            q = mean / dependency
            require(0 < q <= 1
                    and -q * mean + q**2 * (dependency - mean) / 2 <= -exponent,
                    "exact thinning algebra")
            cases += 1
    return cases


def check_cell_collision_bound():
    measures = (F(1, 5), F(1, 7), F(1, 11))
    occupied = tuple(a - a*a/2 for a in measures)
    delta = max(measures)
    require(all(0 <= a - p <= delta*a/2 for a, p in zip(measures, occupied)),
            "rational cell-occupation approximation hypotheses")

    def measure(mask):
        return sum((a for i, a in enumerate(measures) if mask & (1 << i)), F(0))

    cases = 0
    for length in range(1, 4):
        for masks in itertools.product(range(8), repeat=length):
            masses = [measure(mask) for mask in masks]
            unconstrained = product(masses)
            distinct = sum((product(occupied[i] for i in cells)
                            for cells in itertools.permutations(range(3), length)
                            if all(mask & (1 << cell) for mask, cell in zip(masks, cells))),
                           F(0))
            collision = sum((measure(masks[i] & masks[j])
                             * product(masses[k] for k in range(length) if k not in (i, j))
                             for i in range(length) for j in range(i + 1, length)), F(0))
            error = delta * (F(length, 2) * unconstrained + collision)
            require(0 <= unconstrained - distinct <= error,
                    f"cell collision error including null and repeated slots: {masks}")
            cases += 1
    return cases


def check_lean(certificate):
    formal = certificate["formal_core"]
    result = json.loads((HERE / formal["compiler_record"]).read_text())
    source = (HERE / formal["source"]).read_bytes()
    fidelity = (HERE / formal["statement_fidelity"]).read_text()
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean compiler or axiom audit did not succeed")
    require(f"version {formal['lean_version']}," in result["tools"]["lean"]["version"],
            "Lean version")
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"],
            "Lean source changed after compilation")
    require(hashlib.sha256(fidelity.encode()).hexdigest() == result["statement_fidelity_sha256"],
            "statement-fidelity document changed after compilation")
    record = result["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports"
            and record["subject"]["subject_id"] == formal["claim_id"]
            and result["kernel"]["refusals"] == [], "Lean claim attachment")
    archive_path = (ROOT / record["artifact"]).resolve()
    require(archive_path.is_relative_to(HERE), "compiler archive outside mission evidence")
    archive = json.loads(archive_path.read_text())
    require(archive["lean_source"]["text"].encode() == source
            and archive["statement_fidelity"]["text"] == fidelity,
            "archived theorem or reading does not match the compiled source")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    versions = [c for c in ledger["claims"] if c["claim_id"] == formal["claim_id"]]
    require(bool(versions), "formal claim missing from campaign ledger")
    current = max(versions, key=lambda c: c["version"])
    require(current["content_hash"] == record["subject"]["content_hash"]
            and current["formal_statement"].encode() == source, "stale formal claim version")
    require(any(e["evidence_id"] == record["evidence_id"] and e == record
                for e in ledger["evidence"]), "mechanical evidence is not in the ledger")
    text = source.decode()
    for declaration in formal["declarations"]:
        require(f"theorem {declaration.rsplit('.', 1)[1]}" in text,
                f"missing formal declaration {declaration}")
    return record["artifact"]


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["schema_version"] == 1
            and certificate["claim_id"] == "C_PATTERN_TAIL", "certificate scope")
    require(certificate["review"]["independent_review_required"]
            and not certificate["review"]["independent_acceptance_recorded_by_engineer"],
            "Engineer must not manufacture independent acceptance")
    manuscript = ROOT / "research/openai_manuscript"
    targets = (manuscript / "Translative-covering-densities-of-order-n-log-n-September-23-2026"
               / "build/sections/07-targets.tex").read_text()
    require(r"\label{prop:pattern-tail}" in targets
            and r"1\le R\le c_0n\log n" in targets
            and "its repetitions" in targets, "literal manuscript target changed")
    check_parameters(certificate)
    check_jacobian(certificate)
    matching_count, weighted_terms = check_matchings(certificate)
    factorial_identities = check_factorial_moment_polynomials()
    janson_cases = check_finite_janson()
    collision_cases = check_cell_collision_bound()
    lean_archive = check_lean(certificate)
    print(json.dumps({
        "status": "pass",
        "project_root": str(ROOT),
        "claim_id": certificate["claim_id"],
        "exact_supporting_checks": {
            "labeled_matchings": matching_count,
            "normalized_off_diagonal_terms": weighted_terms,
            "factorial_moment_polynomial_identities": factorial_identities,
            "finite_repeated_support_janson_families": janson_cases,
            "cell_collision_slot_lists": collision_cases,
            "jacobian_typed_output": "matched"
        },
        "all_parameter_formal_core": {
            "claim_id": certificate["formal_core"]["claim_id"],
            "lean_version": "4.31.0",
            "exit_code": 0,
            "proof_holes": [],
            "certificate": lean_archive
        },
        "analytic_proof": "report.md; human mathematical proof, not fully formalized",
        "independent_review": "required; not self-awarded"
    }, indent=2))


if __name__ == "__main__":
    main()
