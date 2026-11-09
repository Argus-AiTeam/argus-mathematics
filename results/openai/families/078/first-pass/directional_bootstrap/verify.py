#!/usr/bin/env python3
"""Replay exact finite evidence; do not certify the analytical limit."""

import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
F = Fraction


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def rational(value):
    if isinstance(value, dict):
        answer = F(int(value["num"]), int(value["den"]))
        require(
            str(answer.numerator) == value["num"]
            and str(answer.denominator) == value["den"],
            "Noncanonical Jacobian rational",
        )
        return answer
    return F(value)


def mass(table, rows, columns):
    return sum((table[a][b] for a in rows for b in columns), F(0))


def marginals(table):
    return (
        [sum(row, F(0)) for row in table],
        [sum((row[b] for row in table), F(0)) for b in range(len(table[0]))],
    )


def normalized(table):
    total = sum((sum(row, F(0)) for row in table), F(0))
    require(total > 0, "Cannot normalize zero mass")
    return [[value / total for value in row] for row in table]


def subsets(size):
    for bits in itertools.product((False, True), repeat=size):
        yield {i for i, present in enumerate(bits) if present}


def degree_core(table, mu, nu, delta):
    rows, columns = set(range(len(mu))), set(range(len(nu)))
    charged = F(0)
    while True:
        bad_row = next(
            (a for a in sorted(rows) if mass(table, {a}, columns) < delta * mu[a]),
            None,
        )
        if bad_row is not None:
            charged += mass(table, {bad_row}, columns)
            rows.remove(bad_row)
            continue
        bad_column = next(
            (b for b in sorted(columns) if mass(table, rows, {b}) < delta * nu[b]),
            None,
        )
        if bad_column is None:
            break
        charged += mass(table, rows, {bad_column})
        columns.remove(bad_column)
    total = mass(table, range(len(mu)), range(len(nu)))
    kept = mass(table, rows, columns)
    require(total - kept == charged, "Deletion charges do not telescope")
    require(charged <= 2 * delta, "Two-sided core loss exceeds 2 delta")
    require(kept >= total - 2 * delta, "Core mass lower bound failed")
    require(
        all(mass(table, {a}, columns) >= delta * mu[a] for a in rows),
        "Surviving row lacks its reference floor",
    )
    require(
        all(mass(table, rows, {b}) >= delta * nu[b] for b in columns),
        "Surviving column lacks its reference floor",
    )
    return rows, columns, kept


def check_jacobian(certificate):
    payload = load(HERE / "jacobian_condition_payload.json")
    result = load(HERE / "jacobian_condition_output.json")
    expected = certificate["jacobian"]
    require(result["schema_version"] == 1, "Unexpected adapter schema")
    require(result["protocol_version"] == expected["protocol"], "Protocol changed")
    require(result["server"]["version"] == expected["server_version"], "Server changed")
    require(result["request"]["operation_id"] == expected["operation"], "Wrong operation")
    require(result["request"]["payload"] == payload, "Payload was not preserved")
    require("error" not in result and "error" not in result["result"], "Adapter error")
    output = result["result"]["output"]
    source = {
        int(rational(atom["value"])): rational(atom["probability"])
        for atom in payload["distribution"]["atoms"]
    }
    require(set(source) == set(range(6)), "The encoded 2-by-3 law changed")
    require(sum(source.values(), F(0)) == 1, "Source is not a probability")
    event = {int(rational(value)) for value in payload["event_values"]}
    event_mass = sum((source[value] for value in event), F(0))
    require(event_mass == rational(expected["event_mass"]), "Wrong event mass")
    require(rational(output["event_probability"]) == event_mass, "Adapter mass mismatch")
    actual = {
        int(rational(atom["value"])): rational(atom["probability"])
        for atom in output["distribution"]["atoms"]
    }
    require(actual == {value: source[value] / event_mass for value in event},
            "Adapter conditional law mismatch")
    contributions = output["contributions"]
    require(len(contributions) == len(event), "Incomplete typed contributions")
    for entry in contributions:
        value = int(rational(entry["value"]))
        require(rational(entry["source_probability"]) == source[value],
                "Wrong source contribution")
        require(rational(entry["conditioned_probability"]) == actual[value],
                "Wrong normalized contribution")
    table = [[source[3 * a + b] for b in range(3)] for a in range(2)]
    mu, nu = marginals(table)
    require(all(table[a][b] == mu[a] * nu[b] for a in range(2) for b in range(3)),
            "The named source product identity failed")
    raw = [[table[a][b] if 3 * a + b in event else F(0)
            for b in range(3)] for a in range(2)]
    conditioned = normalized(raw)
    require(
        marginals(conditioned)[1] == [F(3, 10), F(2, 5), F(3, 10)],
        "Actual retained pin marginal mismatch",
    )
    r = sum(raw[0], F(0)) / mu[0]
    v = raw[0][2] / sum(raw[0], F(0))
    cap = table[0][2] / mu[0]
    posterior = raw[0][2] / (mu[0] * r * v)
    require((r, v, cap, posterior) == (F(2, 3), F(1, 4), F(1, 6), F(1)),
            "Sharp parent-retention fixture changed")
    require(posterior == cap / (r * v), "Required retention factors do not cancel")
    require(posterior > cap / v, "Fixture no longer detects the omitted r factor")
    return conditioned, mu, nu


def check_cores(fixtures):
    core_tests = 0
    cap_tests = 0
    for table, mu, nu in fixtures:
        require(sum(mu, F(0)) == sum(nu, F(0)) == 1, "References not normalized")
        require(mass(table, range(len(mu)), range(len(nu))) == 1, "Law not normalized")
        for divisor in (8, 4, 3):
            delta = F(1, divisor)
            degree_core(table, mu, nu, delta)
            core_tests += 1
        rows, columns, kept = degree_core(table, mu, nu, F(1, 4))
        density = max(
            (table[a][b] / (mu[a] * nu[b])
             for a in range(len(mu)) for b in range(len(nu)) if table[a][b]),
        )
        alpha = {a: mass(table, {a}, columns) / kept for a in rows}
        beta = {b: mass(table, rows, {b}) / kept for b in columns}
        require(kept >= F(1, 2), "Actual-product core has too little mass")
        for a in rows:
            require(alpha[a] <= density * mu[a] / kept, "Child marginal changed")
            for b in columns:
                require(table[a][b] / kept <= 16 * density * kept * alpha[a] * beta[b],
                        "Actual-product replacement inequality failed")
        for b in columns:
            require(beta[b] <= density * nu[b] / kept, "Pin marginal changed")

        original_mu, original_nu = marginals(table)
        raw = [[value * (F(1) if (a + b) % 2 == 0 else F(1, 2))
                for b, value in enumerate(row)] for a, row in enumerate(table)]
        raw_mass = mass(raw, range(len(mu)), range(len(nu)))
        delta = raw_mass / 4
        rows, columns, kept = degree_core(raw, original_mu, original_nu, delta)
        require(kept >= raw_mass / 2, "Common conditional-cap core is too small")
        for a in rows:
            row_mass = mass(raw, {a}, columns)
            if row_mass == 0:
                continue
            for event in subsets(len(nu)):
                old_cap = mass(table, {a}, event) / original_mu[a]
                actual_cap = mass(raw, {a}, columns & event) / row_mass
                require(actual_cap <= old_cap / delta, "Conditional row cap failed")
                cap_tests += 1
        for b in columns:
            column_mass = mass(raw, rows, {b})
            if column_mass == 0:
                continue
            for event in subsets(len(mu)):
                old_cap = mass(table, event, {b}) / original_nu[b]
                actual_cap = mass(raw, rows & event, {b}) / column_mass
                require(actual_cap <= old_cap / delta, "Conditional column cap failed")
                cap_tests += 1
    return core_tests, cap_tests


def check_rate_algebra():
    cases = 0
    for s_a, s_b in itertools.product((F(1, 4), F(1, 2), F(3, 4), F(1)), repeat=2):
        target_a = min(s_b, (s_a + s_b) / 2)
        target_b = min(s_a, (s_a + s_b) / 2)
        x, y = s_b / 2, s_a / 2
        for _ in range(12):
            next_x = min(s_b, (s_b + y) / 2)
            next_y = min(s_a, (s_a + x) / 2)
            require(x <= next_x <= target_a and y <= next_y <= target_b,
                    "Asymmetric rate update is not monotone below its fixed point")
            require(max(target_a - next_x, target_b - next_y)
                    <= max(target_a - x, target_b - y) / 2,
                    "Rate update lost its contraction factor")
            x, y = next_x, next_y
            cases += 1
    mesh_cases = 0
    mesh = F(1, 20)
    for s in (F(1, 4), F(1, 2), F(1)):
        for e_left, e_right, e_child in itertools.product((F(0), mesh / 2, mesh), repeat=3):
            a = F(1, 4)
            gap = s * (a + e_left - e_child) - 2 * (e_left + e_right) - (s * a - 4 * mesh)
            decomposition = ((2 - s) * (mesh - e_left)
                             + 2 * (mesh - e_right) + s * (mesh - e_child))
            require(gap == decomposition >= 0, "Mesh loss decomposition failed")
            mesh_cases += 1
    return cases, mesh_cases


def check_lean(certificate):
    archive_path = ROOT / certificate["lean"]["archive"]
    archived = load(archive_path)
    result = archived["lean_check"]
    current = load(HERE / "lean_check.json")
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    require(archived["lean_source"]["text"] == source, "Archived formal source is stale")
    require(archived["statement_fidelity"]["text"] == fidelity, "Archived fidelity is stale")
    for name in ("status", "exit_code", "proof_holes", "audit_exit_code",
                 "source_sha256", "statement_fidelity_sha256"):
        require(current[name] == result[name], f"Current/archived Lean field differs: {name}")
    require(result["status"] == "success" and result["exit_code"] == 0,
            "No successful real compiler result")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean proof has holes or its axiom audit failed")
    require("version 4.31.0," in result["tools"]["lean"]["version"], "Wrong Lean version")
    require(hashlib.sha256(source.encode()).hexdigest() == result["source_sha256"],
            "Compiler result does not bind the current source")
    require(hashlib.sha256(fidelity.encode()).hexdigest()
            == result["statement_fidelity_sha256"], "Compiler result does not bind fidelity")
    ledger = load(ROOT / "research/MATH_STATE.json")
    claim = max(
        (item for item in ledger["claims"] if item["claim_id"] == "DB_FINITE_CORE"),
        key=lambda item: item["version"],
    )
    require(claim["formal_statement"] == source, "Ledger formal statement is stale")
    require(any(item["subject"]["subject_id"] == "DB_FINITE_CORE"
                and item["subject"]["content_hash"] == claim["content_hash"]
                and item["tier"] == "mechanical" and item["verdict"] == "supports"
                and item["artifact"] == certificate["lean"]["archive"]
                for item in ledger["evidence"]), "Missing claim-linked compiler evidence")


def main():
    certificate = load(HERE / "exact_certificate.json")
    require(certificate["schema_version"] == 1, "Unsupported exact certificate schema")
    require(certificate["formal_claim"] == "DB_FINITE_CORE", "Formal coverage changed")
    require(certificate["analytical_claims"] == ["DB_MAIN", "DB_APPLICATION", "DB_ASYMMETRIC"],
            "Analytical coverage changed")
    require(certificate["result_class"] == "verification_theorem_candidate",
            "Replay cannot promote a candidate to an independently accepted theorem")
    require(certificate["false_manuscript_assertions_established"] == []
            and certificate["all_scale_counterexample"] is None,
            "This evidence contains no manuscript counterexample")
    require(certificate["novelty_status"] == "not_established"
            and certificate["statement_fidelity_independently_reviewed"] is False,
            "Independent novelty/fidelity approval cannot be supplied by this replay")
    require(certificate["campaign_complete"] is False, "Finite replay cannot close the campaign")
    conditioned, mu, nu = check_jacobian(certificate)
    fixtures = [
        (conditioned, mu, nu),
        ([[a * b for b in nu] for a in mu], mu, nu),
        ([[F(1, 16), F(0)], [F(0), F(15, 16)]], [F(1, 2)] * 2, [F(1, 2)] * 2),
        ([[F(0) if a == b else F(1, 6) for b in range(3)] for a in range(3)],
         [F(1, 3)] * 3, [F(1, 3)] * 3),
        ([[F(1), F(0)], [F(0), F(0)]], [F(1), F(0)], [F(1), F(0)]),
    ]
    core_tests, cap_tests = check_cores(fixtures)
    rate_cases, mesh_cases = check_rate_algebra()
    check_lean(certificate)
    manuscript = ROOT / certificate["manuscript"]["path"]
    text = manuscript.read_text(encoding="utf-8")
    for anchor in certificate["manuscript"]["required_anchors"]:
        require(anchor in text, f"Literal manuscript anchor missing: {anchor}")
    print(json.dumps({
        "ok": True,
        "jacobian_exact_conditioning": "5/9",
        "sharp_reciprocal_retention": {"r": "2/3", "v": "1/4", "cap": "1/6", "posterior": "1"},
        "finite_core_cases": core_tests,
        "simultaneous_conditional_cap_checks": cap_tests,
        "finite_rate_updates": rate_cases,
        "finite_mesh_cases": mesh_cases,
        "lean": "recorded Lean 4.31.0 run: exit_code=0, proof_holes=[], current source/fidelity bound",
        "coverage": "Universal finite core is formalized; analytical projection and limits are in report.md.",
        "independent_review": "pending",
        "novelty": "not established",
        "campaign_complete": False,
    }, indent=2))


if __name__ == "__main__":
    main()
