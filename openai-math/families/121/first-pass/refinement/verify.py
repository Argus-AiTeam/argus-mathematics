#!/usr/bin/env python3
"""Replay the scoped formal, exact-algebra, and exponent certificates."""

import hashlib
import json
import re
from fractions import Fraction as F
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ZERO = (F(0), F(0), F(0))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def term(coefficient=1, H=0, ell=0, q=0):
    return {(F(H), F(ell), F(q)): F(coefficient)}


def add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for powers, coefficient in polynomial.items():
            result[powers] = result.get(powers, F(0)) + coefficient
    return {p: c for p, c in result.items() if c}


def multiply(*polynomials):
    result = {ZERO: F(1)}
    for polynomial in polynomials:
        product = {}
        for p, a in result.items():
            for q, b in polynomial.items():
                powers = tuple(x + y for x, y in zip(p, q))
                product[powers] = product.get(powers, F(0)) + a * b
        result = {p: c for p, c in product.items() if c}
    return result


def row_term(row):
    return term(row["coefficient"], row["H"], row["ell"], row["q"])


def substituted_baseline():
    H, ell, q = term(H=1), term(ell=1), term(q=1)
    J, inv_P = term(100, H=1, ell=-1), term(H=-20)
    inv_T, inv_S = term(H="-3/4"), term(H=-1, ell=2)
    tau, kappa = term(ell=-4), term(ell=-4)
    inv_eta, delta = term(ell=-5), term(ell=-10)
    return add(
        multiply(add(multiply(term(8), H), multiply(term(512), ell)), J, inv_P),
        multiply(
            term(40000), ell, ell, term(H="1/4"),
            add(term(), multiply(J, inv_P), multiply(J, inv_T)), inv_S,
        ),
        multiply(
            term(2), J, inv_S,
            add(
                term(H="-1/4"),
                multiply(term(4), tau, ell),
                multiply(
                    term(64), ell,
                    add(multiply(term(4), q, ell, inv_eta), multiply(term(2), kappa)),
                ),
                multiply(term(2), delta),
            ),
        ),
        multiply(term(128), ell, J, term(H=-3)),
    )


def check_parameters(data):
    p = data["parameters"]
    e0 = p["e_min"]
    require(e0 == 1000, "The certificate changed the manuscript's cutoff.")
    require(p["substitution"] == {
        "J": "100 H/ell", "inverse_T": "H^(-3/4)", "inverse_S": "ell^2/H",
        "F": "ell", "M_upper": "H", "inverse_P": "H^(-20)",
        "tau": "ell^(-4)", "kappa": "ell^(-4)", "inverse_eta": "ell^(-5)",
        "delta": "ell^(-10)",
    }, "The listed substitution differs from the reconstructed one.")
    rows, upper = p["dominance"], p["upper_terms"]
    reconstructed = add(*(row_term(row) for row in rows))
    require(reconstructed == substituted_baseline(), "Incorrect symbolic E0 substitution.")
    expected_upper = [
        term(52000, H=-18),
        term(8040000, H="-1/2", ell=4),
        term(200, H="-1/4", ell=1),
        term(1000000, ell=-2, q=1),
        term(13200, H=-2),
    ]
    require([row_term(row) for row in upper] == expected_upper, "Changed five-term bound.")
    coefficients = [F(0) for _ in upper]
    for row in rows:
        j = row["target"]
        require(isinstance(j, int) and 0 <= j < len(upper), "Invalid monomial target.")
        coefficient = F(row["coefficient"])
        powers = tuple(F(row[v]) for v in ("H", "ell", "q"))
        target = tuple(F(upper[j][v]) for v in ("H", "ell", "q"))
        require(coefficient > 0, "A domination step has nonpositive coefficient.")
        require(all(a <= b for a, b in zip(powers, target)), "False monomial domination.")
        coefficients[j] += coefficient
    require(
        all(c <= F(row["coefficient"]) for c, row in zip(coefficients, upper)),
        "Insufficient target coefficients.",
    )

    affine = p["affine_exponent_bounds"]
    required_affine = [(1, 19), (10, 52), (8, 44), (1, 17), (1, 12), (20000, 0)]
    require([(r["a"], r["b"]) for r in affine] == required_affine, "Changed exponent route.")
    for row in affine:
        a, b = row["a"], row["b"]
        require(a >= 0 and b >= 0, "Negative induction coefficients.")
        require(1 << (e0 - 1) >= a * e0 + b, "Exponent base case fails.")
        require(a * (e0 - 1) + b >= 0, "Exponent induction step fails.")
    ceilings = p["dyadic_ceilings"]
    require(
        [(r["value"], r["power"]) for r in ceilings]
        == [(416000, 19), (64320000, 26), (1600, 11), (105600, 17), (3200, 12)],
        "Changed dyadic allocations.",
    )
    for row in ceilings:
        require(row["value"] <= 1 << row["power"], "False dyadic coefficient ceiling.")
    allocations = [
        (F(18), 1, 19, F(1), 19),
        (F(1, 2), 10, 52, F(5), 26),
        (F(1, 4), 8, 44, F(2), 11),
        (F(2), 1, 17, F(1), 17),
        (F(3), 1, 12, F(1), 12),
    ]
    for h_power, a, b, ell_power, constant in allocations:
        require(
            h_power * a - ell_power >= 0 and h_power * b - constant >= 0,
            "An affine exponent bound does not imply its allocation.",
        )

    variable = term(q=1)
    shifted = add(variable, term())
    fourth_minus_first = add(multiply(shifted, shifted, shifted, shifted),
                             multiply(term(-1), shifted))
    require(all(c >= 0 for c in fourth_minus_first.values()), "p^4>=p proof fails at p>=1.")
    require((0 ** 4) - 0 == 0, "p=0 branch fails.")
    e21, e22 = add(variable, term(21)), add(variable, term(22))
    square_difference = add(multiply(term(2), e21, e21),
                            multiply(term(-1), e22, e22))
    expected_difference = {
        (F(0), F(0), F(i)): F(c)
        for i, c in enumerate(p["square_induction_difference"])
    }
    require(square_difference == expected_difference, "False square-induction identity.")
    require(all(c >= 0 for c in expected_difference.values()), "Square step has negative terms.")
    require((e0 + 21) ** 2 <= 1 << e0, "Square-induction base fails.")
    require((8 * 1000000) ** 2 <= 1 << e0, "Fourth numerical allocation fails.")
    require(F(20000, 100) == 200, "Structural slack exponent mismatch.")
    require(180000 <= 1 << (35 * e0), "Group union-bound exponent fails.")
    require(8 <= 2 ** 3 and 1500 - 2 - 44 >= 1 and 4000 - 1 - 44 >= 1,
            "Comparison-band remainder allocation fails.")
    require(F(399, 20) / F(1, 100) * 200 >= 40, "Rounded-grid compatibility fails.")
    require(66 <= 2 ** 20, "Initial-cone grid slack fails.")
    require(400 * 2 <= 2 ** 18, "Comparison-frontier growth slack fails.")
    require(1024 <= 1 << (29 * e0), "Within-block decrement slack fails.")
    require(3 <= 1 << e0, "Entropy parameter slack fails.")
    require(4 <= 1 << (6 * e0) and 131072 <= 1 << (24 * e0),
            "Soft group-error absorption fails.")

    unit = F(p["per_term_allocation"])
    require(unit == F(1, 8), "Changed per-term accuracy threshold.")
    baseline = F(p["baseline_allocation"])
    defect = F(p["original_defect_allocation"])
    allowed = F(p["allowed_defect_allocation"])
    total = F(p["original_total_allocation"])
    require(baseline == 5 * unit and defect == unit, "Incorrect allocation count.")
    require(allowed == F(3, 8) and baseline + allowed == 1, "L1 robustness budget fails.")
    require(total == baseline + defect == F(3, 4) and total < 1,
            "Original refinement error does not meet its strict threshold.")


def rational(encoded):
    require(set(encoded) == {"num", "den"}, "Invalid typed rational fields.")
    for value in encoded.values():
        require(isinstance(value, str) and re.fullmatch(r"0|-?[1-9][0-9]*", value),
                "Noncanonical decimal rational encoding.")
    numerator, denominator = int(encoded["num"]), int(encoded["den"])
    require(denominator > 0, "Nonpositive rational denominator.")
    value = F(numerator, denominator)
    require((value.numerator, value.denominator) == (numerator, denominator),
            "The typed rational is not reduced.")
    return value


def check_oracle_and_jacobian(data):
    x = data["oracle_example"]
    require(x["is_edit_string_counterexample"] is False, "Misclassified finite example.")
    require(x["horizon"] == 1, "Changed finite example horizon.")
    c, delta, kappa = (F(x[k]) for k in ("c", "delta", "kappa"))
    previous, current, online, children = (
        F(x[k]) for k in ("previous_action", "current_action", "online", "clipped_children")
    )
    cones, weights = [F(v) for v in x["cone"]], [F(v) for v in x["probabilities"]]
    require(c >= 0 and delta > 0 and 0 <= kappa < F(1, 2), "Invalid example parameters.")
    require(c <= current <= previous and online <= current and children >= c,
            "Example violates the first-crossing hypotheses.")
    require(len(cones) == len(weights) == 2 and sum(weights) == 1
            and all(w > 0 for w in weights), "Invalid example law.")
    defects, returned = [], []
    for cone in cones:
        require(cone <= previous, "Example violates previous-index Bellman domination.")
        defect = max(cone - (1 + delta) * current - kappa * delta * c, F(0))
        value = min(cone, max(cone / (1 + delta), online))
        require(
            max(c, value) <= current + kappa * (previous - current) + defect,
            "Soft prefix inequality fails in the example.",
        )
        defects.append(defect)
        returned.append(value)
    require(defects == [F(v) for v in x["oracle_defects"]], "Incorrect oracle defects.")
    require(returned == [F(v) for v in x["returned_values"]], "Incorrect clipped updates.")
    moment = sum(w * d for w, d in zip(weights, defects))
    excess = sum(w * max(d - c, F(0)) for w, d in zip(weights, returned))
    require(moment == F(x["expected_defect"]) == F(3, 400), "Incorrect defect expectation.")
    require(excess == F(x["expected_positive_excess"]) == F(1, 55),
            "Incorrect returned positive-excess expectation.")
    coarse_tax = 2 * c * sum(w for w, d in zip(weights, defects) if d > 0)
    require(coarse_tax == F(x["coarse_failure_tax_at_F_1"]) and moment < coarse_tax,
            "The example does not show a strictly smaller oracle charge.")

    j = data["jacobian"]
    require(j["operation_id"] == "probability.finite_distribution.raw_moment.compute",
            "The inspected Jacobian operation was replaced.")
    require(j["adapter_exit_code"] == 0 and j["status"] == "success"
            and j["timeout"] is False, "Jacobian did not return a conclusive typed result.")
    payload, output = read_json(ROOT / j["payload"]), read_json(ROOT / j["output"])
    require(output["protocol_version"] == j["protocol_version"], "Protocol mismatch.")
    require(output["server"]["version"] == j["server_version"], "Server version mismatch.")
    require(output["request"]["operation_id"] == j["operation_id"]
            == output["result"]["operation_id"], "Operation mismatch.")
    require(output["request"]["payload"] == payload, "Adapter payload was not preserved.")
    require(payload["order"] == 1, "Not an expectation operation.")
    atoms = [(rational(a["value"]), rational(a["probability"])) for a in payload["atoms"]]
    require(atoms == list(zip(defects, weights)), "Jacobian input does not match the oracle model.")
    result = output["result"]["output"]
    require(result["order"] == 1 and rational(result["moment"]) == moment
            == F(j["expected_moment"]), "Typed moment does not replay.")
    require(len(result["contributions"]) == len(atoms), "Incomplete typed contributions.")
    for contribution, (value, probability) in zip(result["contributions"], atoms):
        require(
            rational(contribution["value"]) == rational(contribution["powered_value"]) == value
            and rational(contribution["probability"]) == probability
            and rational(contribution["contribution"]) == value * probability,
            "Incorrect typed atom contribution.",
        )
    require("error" not in output and "error" not in output["result"], "Adapter returned an error.")
    return moment


def check_source(data):
    source = data["manuscript"]
    directory = ROOT / source["directory"]
    target = " ".join((directory / source["target"]).read_text(encoding="utf-8").split())
    require(len(source["literal_fragments"]) == 5, "Missing literal target bindings.")
    for fragment in source["literal_fragments"]:
        require(" ".join(fragment.split()) in target, "Literal target assertion changed.")
    for name, labels in source["dependency_labels"].items():
        text = (directory / name).read_text(encoding="utf-8")
        for label in labels:
            require("\\label{" + label + "}" in text, "A manuscript dependency label changed.")
    randomness = " ".join((directory / "10-work.tex").read_text(encoding="utf-8").split())
    require(
        "complete child tables depend on descendant streams and earlier passes, "
        "but not on fresh streams of the current parent." in randomness,
        "The scoped complete-child-table randomness assertion changed.",
    )


def check_lean(data):
    l = data["lean"]
    source, fidelity = ROOT / l["source"], ROOT / l["statement_fidelity"]
    result, archive = read_json(ROOT / l["compiler_result"]), read_json(ROOT / l["archive"])
    require(result == archive["lean_check"], "Canonical result differs from the archived compile.")
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["audit_exit_code"] == 0 and result["proof_holes"] == [],
            "The real Lean compiler/auditor did not certify a zero-hole source.")
    require(not result["environment_failure"], "The Lean toolchain was unverified.")
    require("version " + l["version"] + "," in result["tools"]["lean"]["version"],
            "Wrong Lean version.")
    for path, digest_key, archived_key in (
        (source, "source_sha256", "lean_source"),
        (fidelity, "statement_fidelity_sha256", "statement_fidelity"),
    ):
        require(hashlib.sha256(path.read_bytes()).hexdigest() == result[digest_key],
                "Stale compiler source or statement fidelity.")
        require(archive[archived_key]["text"] == path.read_text(encoding="utf-8"),
                "Archived proof text or reading differs from the current file.")
    require(not re.search(r"\b(sorry|admit|axiom)\b", source.read_text(encoding="utf-8")),
            "The Lean source contains an admission or declared axiom.")
    printed = {}
    for line in result["stdout"].splitlines():
        match = re.fullmatch(r"'([^']+)' depends on axioms: \[([^\]]*)\]", line)
        require(match is not None, "Unexpected compiler output instead of the axiom audit.")
        printed[match[1]] = set(filter(None, (v.strip() for v in match[2].split(","))))
    require(set(printed) == set(l["declarations"]), "Missing transitive-assumption inspection.")
    allowed = set(l["allowed_axioms"])
    require(allowed == {"propext", "Classical.choice", "Quot.sound"}, "Relaxed axiom policy.")
    require(all(axioms <= allowed for axioms in printed.values()), "Unapproved transitive axiom.")

    state = read_json(ROOT / "research/MATH_STATE.json")
    claim_id = data["formal_core_claim_id"]
    versions = [c for c in state["claims"] if c["claim_id"] == claim_id]
    require(bool(versions), "The formal claim is missing.")
    claim = max(versions, key=lambda c: c["version"])
    require(claim["version"] == l["claim_version"], "The formal claim was revised.")
    require(claim["formal_statement"] == source.read_text(encoding="utf-8"),
            "The registered formal statement differs from the proof.")
    require(archive["subject"]["subject_id"] == claim_id
            and archive["subject"]["content_hash"] == claim["content_hash"],
            "The compiler evidence certifies a different claim version.")
    records = [
        e for e in state["evidence"]
        if e["evidence_id"] == archive["evidence_id"]
        and e["subject"] == archive["subject"]
        and e["tier"] == "mechanical" and e["verdict"] == "supports"
        and e["artifact"] == l["archive"]
    ]
    require(len(records) == 1 and archive["tier"] == "mechanical"
            and archive["verdict"] == "supports", "No current claim-bound mechanical evidence.")
    return sorted(printed)


def main():
    data = read_json(HERE / "exact_certificate.json")
    require(data["schema_version"] == 1, "Unsupported exact certificate schema.")
    require(data["research_target_level"] == "publishable"
            and data["math_objective_mode"] == "exploratory", "Changed campaign research bar.")
    require(data["scope"]["end_to_end_edit_distance_lean"] is False,
            "The certificate overstates the Lean verification boundary.")
    check_source(data)
    check_parameters(data)
    moment = check_oracle_and_jacobian(data)
    declarations = check_lean(data)
    print(json.dumps({
        "ok": True,
        "claim": data["claim_id"],
        "formal_core_claim": data["formal_core_claim_id"],
        "result_class": data["result_class"],
        "universal_arithmetic_certificate": "passed",
        "lean_version": data["lean"]["version"],
        "proof_holes": [],
        "transitive_axioms": data["lean"]["allowed_axioms"],
        "checked_declarations": len(declarations),
        "oracle_example_expected_defect": str(moment),
        "full_edit_distance_theorem_kernel_closed": False,
        "independent_review": data["independent_review"]["status"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
