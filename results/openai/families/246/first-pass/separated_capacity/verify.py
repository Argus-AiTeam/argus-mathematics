#!/usr/bin/env python3
"""Replay the exact finite reduction; the universal theorem is in Main.lean."""

import copy
import hashlib
import json
import re
from fractions import Fraction as F
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent


class VerificationError(Exception):
    pass


def require(condition, code):
    if not condition:
        raise VerificationError(code)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def polynomial(encoded):
    require(encoded["domain"] == "QQ", "polynomial_domain")
    variables = encoded["variables"]
    result = {}
    previous = None
    for term in encoded["polynomial"]["terms"]:
        powers = tuple(term["exponents"])
        coefficient = F(int(term["coefficient"]["num"]), int(term["coefficient"]["den"]))
        require(len(powers) == len(variables), "polynomial_arity")
        require(all(type(p) is int and p >= 0 for p in powers), "polynomial_exponents")
        require(coefficient != 0 and powers not in result, "polynomial_canonical")
        require(previous is None or powers < previous, "polynomial_order")
        result[powers] = coefficient
        previous = powers
    return result


def multiply(left, right):
    result = {}
    for lp, lc in left.items():
        for rp, rc in right.items():
            powers = tuple(x + y for x, y in zip(lp, rp, strict=True))
            result[powers] = result.get(powers, F(0)) + lc * rc
    return {p: c for p, c in result.items() if c}


def check_jacobian(metadata):
    payload = read_json(ROOT / metadata["payload_file"])
    response = read_json(ROOT / metadata["output_file"])
    contract = read_json(ROOT / metadata["contract_file"])
    operation = metadata["operation_id"]
    require(contract["result"]["operation"]["operation_id"] == operation, "inspected_operation")
    require(response["request"]["operation_id"] == operation, "executed_operation")
    require(response["request"]["payload"] == payload, "exact_adapter_payload")
    require(response["server"]["version"] == metadata["server_version"], "adapter_version")
    require(response["protocol_version"] == metadata["protocol_version"], "adapter_protocol")
    require(metadata["adapter_exit_code"] == 0, "adapter_exit")
    require(metadata["structured_error"] is None, "adapter_structured_error")
    require(response.get("error") is None, "adapter_error")
    output = response["result"]["output"]
    require(output["is_valid"] is True, "adapter_nonconclusion")
    require(output["method"] == "EXACT_COEFFICIENT_IDENTITY", "adapter_method")
    require(output["polynomial"] == payload["polynomial"], "adapter_polynomial_binding")
    require(output["summands"] == payload["summands"], "adapter_summand_binding")
    computed = {}
    for summand in payload["summands"]:
        require(summand["variables"] == payload["polynomial"]["variables"], "sos_variables")
        for powers, coefficient in multiply(polynomial(summand), polynomial(summand)).items():
            computed[powers] = computed.get(powers, F(0)) + coefficient
    computed = {p: c for p, c in computed.items() if c}
    require(computed == polynomial(payload["polynomial"]), "exact_sos_identity")
    require(computed == polynomial(output["computed_sum"]), "adapter_computed_sum")
    expected = {}
    for i in range(3):
        for j in range(3):
            powers = [0] * 6
            powers[i] += 2
            powers[3 + j] += 2
            key = tuple(powers)
            expected[key] = expected.get(key, F(0)) + 1
            powers = [0] * 6
            for index in (i, j, 3 + i, 3 + j):
                powers[index] += 1
            key = tuple(powers)
            expected[key] = expected.get(key, F(0)) - 1
    require(computed == {p: c for p, c in expected.items() if c}, "lagrange_not_arbitrary_sos")
    return len(computed)


def detector(instance):
    data = instance["transfer"]
    weights = list(map(F, data["target_weights"]))
    require(all(w >= 0 for w in weights), "nonnegative_target_weight")
    count = len(instance["candidates"])
    auxiliaries = data["auxiliaries"]
    row_bound = data["row_bound"]
    column_bound = data["column_bound"]
    overlap_bound = data["overlap_bound"]
    require(all(type(n) is int and n > 0 for n in
                (row_bound, column_bound, overlap_bound)), "positive_transfer_bounds")
    sigma = [F(0)] * count
    overlaps = [0] * count
    local_energy = F(0)
    target_energy = sum((w * w for w in weights), F(0))
    for auxiliary in auxiliaries:
        require(len(auxiliary) == count, "transfer_candidate_arity")
        columns = [0] * len(weights)
        local = []
        for y, row in enumerate(auxiliary):
            require(len(row) == len(set(row)), "transfer_duplicate_target")
            require(all(type(i) is int and 0 <= i < len(weights) for i in row),
                    "transfer_target_index")
            require(len(row) <= row_bound, "transfer_row_bound")
            for i in row:
                columns[i] += 1
            value = sum((weights[i] for i in row), F(0))
            local.append(value)
            sigma[y] += value
            overlaps[y] += bool(row)
            require(value * value <= row_bound * sum((weights[i] ** 2 for i in row), F(0)),
                    "transfer_local_cauchy")
        require(all(n <= column_bound for n in columns), "transfer_column_bound")
        energy = sum((v * v for v in local), F(0))
        require(energy <= row_bound * column_bound * target_energy, "transfer_local_energy")
        local_energy += energy
    require(all(n <= overlap_bound for n in overlaps), "transfer_overlap_bound")
    actual = sum((v * v for v in sigma), F(0))
    upper = overlap_bound * row_bound * column_bound * len(auxiliaries) * target_energy
    require(actual <= overlap_bound * local_energy <= upper, "transfer_total_energy")
    require(upper > 0, "positive_detector_energy")
    return sigma, upper, actual


def check_instance(instance):
    left, right = map(F, instance["J"])
    require(left < right, "nonempty_interval")
    delta = right - left
    lam, Lam = F(instance["lambda"]), F(instance["Lambda"])
    N, m, chi = instance["bins"], instance["m"], instance["chi"]
    require(lam > 0 and Lam > 0, "positive_capacity_coefficients")
    require(all(type(n) is int and n > 0 for n in (N, m, chi)), "positive_finite_counts")
    candidates = instance["candidates"]
    ranges = []
    cuts = {left, right}
    for candidate in candidates:
        lo, hi = map(F, candidate["interval"])
        require(lo <= hi, "interval_order")
        ranges.append((lo, hi))
        cuts.update(t for t in (lo, hi) if left < t < right)
        bins = candidate["bins"]
        require(len(set(bins)) == len(bins), "duplicate_bin")
        require(len(bins) <= m, "bin_multiplicity")
        require(all(type(b) is int and 0 <= b < N for b in bins), "bin_index")
        require(type(candidate["color"]) is int and 0 <= candidate["color"] < chi,
                "color_index")
    cuts = sorted(cuts)
    atoms = [(lo, hi) for lo, hi in zip(cuts[:-1], cuts[1:], strict=True)]
    ell = [(hi - lo) / delta for lo, hi in atoms]
    require(all(length > 0 for length in ell) and sum(ell) == 1, "normalized_atom_partition")
    active = [[int(lo <= (a + b) / 2 <= hi) for lo, hi in ranges] for a, b in atoms]
    t = [sum((ell[a] * active[a][y] for a in range(len(atoms))), F(0))
         for y in range(len(candidates))]
    for y, (lo, hi) in enumerate(ranges):
        direct = max(F(0), min(right, hi) - max(left, lo)) / delta
        require(t[y] == direct and 0 <= t[y] <= 1, "actual_interval_overlap")
    large = [value >= lam / Lam for value in t]
    sigma, E, actual_energy = detector(instance)
    marked_rows = unmarked_rows = 0
    levels = [(a + b) / 2 for a, b in atoms] + cuts[1:-1]
    for b in range(N):
        for level_index, level in enumerate(levels):
            incident = [y for y, candidate in enumerate(candidates)
                        if b in candidate["bins"] and ranges[y][0] <= level <= ranges[y][1]]
            marked = any(large[y] for y in incident)
            if marked:
                marked_rows += level_index < len(atoms)
            else:
                unmarked_rows += level_index < len(atoms)
                require(sum((sigma[y] for y in incident if not large[y]), F(0)) >= 1,
                        "unmarked_detection")
            cover = sum((F(1) if large[y] else sigma[y] for y in incident), F(0))
            require(cover >= 1, "weighted_row_cover")
    L = sum((t[y] for y in range(len(t)) if large[y]), F(0))
    T = sum((sigma[y] * t[y] for y in range(len(t)) if not large[y]), F(0))
    V = sum((t[y] ** 2 for y in range(len(t)) if not large[y]), F(0))
    capacity = [min(lam * value, Lam * value * value) for value in t]
    S = sum(capacity, F(0))
    require(N <= m * (L + T), "summed_weighted_cover")
    require(T * T <= E * V, "detector_cauchy")
    require(lam * L <= S and Lam * V <= S, "minimum_branch_matching")
    for y, value in enumerate(t):
        require(capacity[y] == (lam * value if large[y] else Lam * value * value),
                "actual_minimum_branch")
    lower = min(lam * N / (2 * m), Lam * N * N / (4 * m * m * E))
    require(S >= lower, "finite_capacity_conclusion")
    separation = F(instance["separation"])
    require(separation > 0, "positive_separation")
    for y, candidate in enumerate(candidates):
        for z in range(y):
            if abs(F(candidate["position"]) - F(candidates[z]["position"])) <= separation:
                require(candidate["color"] != candidates[z]["color"], "proper_coloring")
    classes = [sum((capacity[y] for y, c in enumerate(candidates) if c["color"] == k), F(0))
               for k in range(chi)]
    require(sum(classes) == S and max(classes) >= S / chi >= lower / chi,
            "separated_color_capacity")
    return {
        "t": t, "capacity": S, "lower_bound": lower, "best_separated": max(classes),
        "atoms": len(atoms), "marked_rows": marked_rows, "unmarked_rows": unmarked_rows,
        "endpoint_rows": N * (len(cuts) - 2),
        "detector_energy": actual_energy, "detector_energy_bound": E
    }


def affine_instance(instance, scale, offset):
    result = copy.deepcopy(instance)
    require(scale > 0, "positive_affine_scale")
    result["J"] = [str(offset + scale * F(x)) for x in instance["J"]]
    for candidate in result["candidates"]:
        candidate["interval"] = [str(offset + scale * F(x)) for x in candidate["interval"]]
    return result


def check_mutations(instances, expected):
    instance = instances[0]
    mutations = {}
    broken = copy.deepcopy(instance)
    broken["transfer"]["auxiliaries"][0][0] = []
    mutations["unmarked_detection"] = broken
    broken = copy.deepcopy(instance)
    broken["transfer"]["column_bound"] = 1
    mutations["transfer_column_bound"] = broken
    transfer_instance = next(item for item in instances
                             if item["name"] == "two-target-two-auxiliary-transfer")
    broken = copy.deepcopy(transfer_instance)
    broken["transfer"]["row_bound"] = 1
    mutations["transfer_row_bound"] = broken
    broken = copy.deepcopy(transfer_instance)
    broken["transfer"]["overlap_bound"] = 1
    mutations["transfer_overlap_bound"] = broken
    broken = copy.deepcopy(instance)
    broken["transfer"]["target_weights"][0] = "-1"
    mutations["nonnegative_target_weight"] = broken
    broken = copy.deepcopy(instance)
    broken["candidates"][1]["color"] = 0
    mutations["proper_coloring"] = broken
    broken = copy.deepcopy(instance)
    broken["candidates"][0]["bins"] = [0, 1]
    mutations["bin_multiplicity"] = broken
    broken = copy.deepcopy(instance)
    broken["transfer"]["auxiliaries"][0][0] = [1]
    mutations["transfer_target_index"] = broken
    broken = copy.deepcopy(instance)
    broken["candidates"][0]["interval"] = ["1", "0"]
    mutations["interval_order"] = broken
    broken = copy.deepcopy(instance)
    broken["J"] = ["1", "1"]
    mutations["nonempty_interval"] = broken
    require(set(mutations) == set(expected), "mutation_manifest")
    for code, broken in mutations.items():
        try:
            check_instance(broken)
        except VerificationError as error:
            require(str(error) == code, "unexpected_mutation_failure:" + code + ":" + str(error))
        else:
            raise VerificationError("mutation_accepted:" + code)
    return len(mutations)


def check_compiler(certificate):
    data = certificate["universal_reduction"]
    result = read_json(ROOT / data["compiler_result"])
    require(result["status"] == "success" and result["exit_code"] == 0, "real_compiler_success")
    require(result["proof_holes"] == [], "no_proof_holes")
    require(result["audit_exit_code"] == 0, "real_axiom_audit_success")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "lean_version")
    source = ROOT / data["formal_source"]
    fidelity = ROOT / data["statement_fidelity"]
    require(hashlib.sha256(source.read_bytes()).hexdigest() == result["source_sha256"],
            "fresh_compiler_source")
    require(hashlib.sha256(fidelity.read_text(encoding="utf-8").encode("utf-8")).hexdigest()
            == result["statement_fidelity_sha256"], "fresh_statement_fidelity")
    text = source.read_text(encoding="utf-8")
    require(re.search(r"\b(sorry|admit|axiom)\b", text) is None, "no_user_proof_holes")
    for declaration in data["declarations"]:
        require("theorem " + declaration.rsplit(".", 1)[-1] in text, "formal_declaration")
    require("mathlib-v4.31.0" in result["lake_workspace"], "pinned_mathlib_workspace")
    return data["declarations"]


def main():
    certificate = read_json(ROOT / "exact_certificate.json")
    require(certificate["schema_version"] == 1, "certificate_schema")
    source = PROJECT / certificate["source"]["file"]
    require(certificate["source"]["literal_lemma"] in source.read_text(encoding="utf-8"),
            "literal_manuscript_binding")
    sos_terms = check_jacobian(certificate["jacobian"])
    summaries = []
    for instance in certificate["finite_instances"]:
        baseline = check_instance(instance)
        for transform in certificate["affine_interval_tests"]:
            scaled = affine_instance(instance, F(transform["scale"]), F(transform["offset"]))
            require(check_instance(scaled) == baseline, "exact_interval_scale_invariance")
        summaries.append({"name": instance["name"],
                          **{k: str(v) if isinstance(v, F) else v
                             for k, v in baseline.items() if k != "t"}})
    rejected = check_mutations(certificate["finite_instances"],
                               certificate["required_rejected_mutations"])
    declarations = check_compiler(certificate)
    print(json.dumps({
        "ok": True, "claim": certificate["claim"],
        "scope": "Conditional analytic theorem; universal finite core compiler-verified.",
        "finite_instances": summaries,
        "affine_replays": len(summaries) * len(certificate["affine_interval_tests"]),
        "rejected_mutations": rejected, "exact_sos_terms": sos_terms,
        "formal_declarations": declarations, "independent_review": "pending_host"
    }, indent=2))


if __name__ == "__main__":
    try:
        main()
    except VerificationError as error:
        print(json.dumps({"ok": False, "error": str(error)}))
        raise SystemExit(1) from error
