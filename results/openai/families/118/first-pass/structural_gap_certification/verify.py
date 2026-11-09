#!/usr/bin/env python3
"""Replay the uniform Lean theorem and exact adversarial unit certificates.

The default rechecks Lean and its environment axiom audit (about 11 minutes on
the recorded host). Submit that command through the Argus durable runner.
--recorded-lean instead checks the current, source-bound official result.
Neither finite probes nor the small displacement LP prove the uniform theorem:
that conclusion comes from the full Lean proof, whose statement fidelity still
requires independent human review.
"""

import argparse
from fractions import Fraction as Q
import hashlib
import itertools
import json
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
TARGET = "OAI.BinPackingGap.structural_additive_gap"
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
STATEMENT = """theorem structural_additive_gap (c : ℕ) :
    ∃ I : Instance, ∃ B : ℕ,
      I.n = 5 * B ∧
      (∀ i, (1 / 6 : ℚ) < I.size i ∧ I.size i < 1) ∧
      B + c < opt I ∧ individualLP I = (B : ℝ) ∧ typeLP I = (B : ℝ)"""


def require(condition, message):
    if not condition:
        raise ValueError(message)


def load(name):
    return json.loads((HERE / name).read_text())


def digest(data):
    return hashlib.sha256(data).hexdigest()


def rational(value):
    result = Q(int(value["num"]), int(value["den"]))
    require(value == {"num": str(result.numerator), "den": str(result.denominator)},
            "Noncanonical rational in typed evidence")
    return result


def axioms_from_output(output, source):
    expected = re.findall(r"^#print axioms ([\w.]+)$", source, re.M)
    entries = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", output)
    result = {name: sorted(a.strip() for a in raw.split(",") if a.strip())
              for name, raw in entries}
    require(len(entries) == len(result) == len(expected) == 48,
            "Missing or duplicate transitive axiom audit")
    require(set(result) == set(expected), "Axiom output is not the requested audit")
    require(TARGET in result, "The full uniform theorem was not audited")
    for name, dependencies in result.items():
        require(set(dependencies) <= ALLOWED_AXIOMS,
                f"Unproved or nonstandard axiom in {name}: {dependencies}")
    return result


def source_closure(compare_upstream):
    provenance = load("localization_provenance.json")
    source = (HERE / "Main.lean").read_text()
    require(digest(source.encode()) == provenance["main_sha256"],
            "Localized source differs from its provenance")
    require(re.findall(r"^import (.+)$", source, re.M) == ["Mathlib"],
            "The proof imports a domain theorem or another untracked module")
    require(" ".join(STATEMENT.split()) in " ".join(source.split()),
            "The exact parameter-uniform theorem signature changed")
    require(not re.search(r"^\s*(?:axiom|opaque|unsafe\s+def)\s", source, re.M),
            "A domain axiom or opaque implementation was added")
    rows = source.splitlines(keepends=True)
    rebuilt = provenance["replay_preamble"]
    seen = set()
    for item in provenance["sources"]:
        dependencies = {m for m in item["imports"] if m.startswith("OAI.")}
        require(dependencies <= seen, "Domain modules are not dependency-closed")
        body = "".join(rows[item["main_body_start_line"] - 1:
                            item["main_body_end_line"]])
        require(digest(body.encode()) == item["localized_body_sha256"],
                f"Localized body changed: {item['module']}")
        if compare_upstream:
            original = Path(item["source"]).read_bytes()
            require(digest(original) == item["source_sha256"],
                    f"Read-only upstream source changed: {item['module']}")
            lines = []
            for line in original.decode().splitlines():
                lines.append(("-- localized import: " + line[len("import "):]
                              if line.startswith("import ") else line) + "\n")
            for edit in reversed(item["localization_edits"]):
                start = edit["start_line_zero_based"]
                end = edit["end_line_exclusive_zero_based"]
                require(lines[start:end] == edit["expected_lines"],
                        f"Compatibility edit precondition failed: {item['module']}")
                lines[start:end] = edit["replacement_lines"]
            require("".join(lines) == body,
                    f"Localization has an undocumented change: {item['module']}")
        rebuilt += item["begin_marker"] + body + item["end_marker"]
        seen.add(item["module"])
    rebuilt += provenance["replay_suffix"]
    require(rebuilt == source, "The complete localization cannot be reconstructed")
    require(len(seen) == provenance["domain_file_count"] == 44,
            "The complete 44-file domain closure is required")
    return source, provenance


def lean_evidence(source, replay):
    recorded = load("lean_check.json")
    official = load("official_bound_verify.json")
    fidelity = (HERE / "STATEMENT_FIDELITY.md").read_bytes()
    require(fidelity == (HERE / "statement_fidelity.md").read_bytes(),
            "The official and supplied statement-fidelity documents differ")
    for result in (recorded, official):
        require(result["status"] == "success" and result["exit_code"] == 0,
                "The official Lean compile did not succeed")
        require(result["audit_exit_code"] == 0 and result["proof_holes"] == [],
                "The environment axiom audit failed or found proof holes")
        require(result["environment_failure"] == "", "Unverified Lean environment")
        require(result["source_sha256"] == digest(source.encode()),
                "Official evidence certifies different Lean text")
        require(result["statement_fidelity_sha256"] == digest(fidelity),
                "Official evidence certifies a different statement reading")
        require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
                "A different compiler version is not the requested evidence")
    require(official["kernel"]["recorded"] is not None
            and not official["kernel"]["refusals"],
            "The successful compiler result was not attached to the claim")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == "C118_STRUCTURAL_GAP"),
                key=lambda c: c["version"])
    require(claim["formal_statement"].strip() == source.strip(),
            "The ledger claim carries a different formalization")
    require(not claim["external_assumptions"],
            "The structural claim has undischarged external assumptions")
    dependencies = axioms_from_output(recorded["stdout"], source)
    require(dependencies == axioms_from_output(official["stdout"], source),
            "The bound and canonical compiler results disagree")
    if replay:
        lake = recorded["tools"]["lake"]["path"]
        workspace = recorded["lake_workspace"]
        version = subprocess.run([lake, "env", "lean", "--version"], cwd=workspace,
                                 check=True, capture_output=True, text=True).stdout
        require(version.startswith("Lean (version 4.31.0,"), "Replay compiler changed")
        compile_result = subprocess.run(
            [lake, "env", "lean", str(HERE / "Main.lean")],
            cwd=workspace, capture_output=True, text=True)
        (HERE / "replay_compile.log").write_text(
            compile_result.stdout + compile_result.stderr)
        require(compile_result.returncode == 0, "Replay compilation failed; see replay_compile.log")
        require(axioms_from_output(compile_result.stdout, source) == dependencies,
                "Replay transitive axioms changed")
        audit = subprocess.run(
            [lake, "env", "lean", "--run",
             "$WORKSPACE/argus-live-update/argus_skill/tools/lean_axiom_audit.lean",
             str(HERE / "Main.lean")],
            cwd=workspace, capture_output=True, text=True)
        (HERE / "replay_environment_audit.log").write_text(audit.stdout + audit.stderr)
        require(audit.returncode == 0, "Replay environment audit failed")
        require((HERE / "Main.lean").read_text() == source
                and (HERE / "STATEMENT_FIDELITY.md").read_bytes() == fidelity,
                "Source or statement fidelity changed during replay")
    return {
        "claim_id": claim["claim_id"],
        "claim_version": claim["version"],
        "claim_content_hash": claim["content_hash"],
        "source_sha256": digest(source.encode()),
        "statement_fidelity_sha256": digest(fidelity),
        "lean_version": "4.31.0",
        "exit_code": 0,
        "environment_axiom_audit_exit_code": 0,
        "proof_holes": [],
        "printed_transitive_axiom_sets": dependencies,
        "official_ledger_record": official["kernel"]["recorded"],
    }


def pattern_and_label_probes():
    subclasses = ("Tp", "Tm", "S", "Z", "Y", "Up", "Um", "W",
                  "DM", "DG", "FT", "FM", "FG")
    roles = dict(zip(subclasses, ("X", "X", "X", "A", "A", "U", "U",
                                  "U", "D", "D", "F", "F", "F")))
    expected = {tuple(sorted(p)) for p in [
        ("Tp", "Z", "Up", "DM", "FT"), ("Tm", "Z", "Um", "DM", "FT"),
        ("S", "Z", "Up", "DM", "FM"), ("S", "Y", "W", "DG", "FG")]}
    found = set()
    count = 0
    for items in itertools.combinations_with_replacement(subclasses, 5):
        n = {s: items.count(s) for s in subclasses}
        equations = [5 * sum(n[s] for s in subclasses if roles[s] == r) - 5
                     for r in ("X", "A", "U", "D", "F")]
        equations += [n["Tp"] + n["Tm"] - n["FT"],
                      n["Z"] - n["FT"] - n["FM"],
                      n["Up"] + n["Um"] - n["FT"] - n["FM"],
                      n["DM"] - n["FT"] - n["FM"], n["Tm"] - n["Um"]]
        score = sum(100**j * a for j, a in enumerate(equations))
        require(all(abs(a) < 100 for a in equations), "Radix digit bound")
        require((score == 0) == all(a == 0 for a in equations), "Signed radix collision")
        if score == 0:
            found.add(tuple(sorted(items)))
        count += 1
    require(found == expected, "Primary-zero patterns differ from the manuscript")
    for x, a, local in itertools.product(range(1, 5), repeat=3):
        score = 3**x + 3**local - 2 * 3**a
        require(score > 0 or (x <= a and local <= a), "Label orientation failed")
        require((score == 0) == (x == a == local), "False equal-label test")
    grid = (Q(-1), Q(0), Q(1, 2), Q(1), Q(2))
    prefix_cases = 0
    for h, b, a in itertools.product(grid, repeat=3):
        if h <= b:
            require(int(h <= a) == int(b <= a) + int(h <= a < b),
                    "Half-open prefix identity failed")
            prefix_cases += 1
    return {"five_item_subclass_multisets": count, "zero_patterns": sorted(map(list, found)),
            "label_triples": 64, "tied_endpoint_prefix_cases": prefix_cases}


def key_order_probes():
    checked = 0
    feasible = 0
    for m, repetitions in itertools.product(range(1, 5), repeat=2):
        positions = [(e, j) for e in range(1, m + 1)
                     for j in range(1, repetitions + 1)]
        theta = lambda e: (repetitions + 1)**(e - 1) - 1
        height = lambda r: r[1] * (repetitions + 1)**(r[0] - 1) - 1
        for key, row in itertools.product(positions, repeat=2):
            if row > key:
                require(height(row) - height(key) >= theta(key[0]) + 1,
                        "Row-order separation failed")
            for edge, nonpermit, short in itertools.product(range(1, m + 1), range(2), range(2)):
                if edge > key[0]:
                    require(theta(edge) - theta(key[0])
                            >= height((key[0], repetitions)) + 1,
                            "Independent edge-order separation failed")
                expression = (height(row) - height(key) + theta(edge) - theta(key[0])
                              + Q(nonpermit - short, 2000))
                if expression <= 0:
                    require(row <= key and edge <= key[0], "A feasible later row/resource")
                    if row == key and not short and edge == key[0]:
                        require(not nonpermit, "A long current row used a current nonpermit")
                    feasible += 1
                checked += 1
    return {"parameter_ranges": "1<=m,R<=4; Delta/g=1/2000",
            "exact_key_inequalities": checked, "feasible_cases": feasible}


def displacement_and_conservation_probes():
    corrections = 0
    positive_displacements = 0
    for d, loss in itertools.product(range(1, 17), range(4)):
        for plus, short, displaced in itertools.product(range(d + 1), repeat=3):
            if d + displaced <= plus + short + 6 * loss:
                long = max(0, short - displaced - 3 * loss)
                require(d <= long + plus + 9 * loss, "Displacement did not compensate")
                corrections += 1
                positive_displacements += int(displaced > 0)
    conservation = 0
    for stock in range(8):
        universe = set(range(stock))
        for number in range(stock + 1):
            for keys in itertools.combinations(range(stock), number):
                for resources in itertools.combinations(range(stock), number):
                    matching = dict(zip(keys, resources))
                    require(len(set(matching.values())) == len(matching), "Resource reused")
                    remaining = universe - set(matching.values())
                    missing = universe - set(keys)
                    require(len(remaining) == len(missing), "Earlier-resource conservation failed")
                    conservation += 1
    # Each expression is multilinear in d,P,n,K; the Boolean cube determines
    # every coefficient exactly, not just finitely many sample parameters.
    values = {}
    for point in itertools.product(range(2), repeat=4):
        d, quota, n, loss = point
        repetitions = 100 * (quota + n * loss + 1)
        lhs = 2 * (repetitions - quota) * Q(3 * d, 4) - (d * repetitions + 3 * n * loss)
        rhs = Q(97, 2) * d * quota + (50 * d - 3) * n * loss + 50 * d
        require(lhs == rhs, "Multilinear edge-demand identity failed")
        values[point] = lhs
    coefficients = {}
    for mask in itertools.product(range(2), repeat=4):
        coefficient = sum(
            (-1)**(sum(mask) - sum(point)) * value
            for point, value in values.items()
            if all(a <= b for a, b in zip(point, mask)))
        if coefficient:
            monomial = "*".join(name for name, bit in zip(("d", "P", "n", "K"), mask) if bit)
            coefficients[monomial] = str(coefficient)
    require(coefficients == {"n*K": "-3", "d": "50", "d*n*K": "50", "d*P": "97/2"},
            "Unexpected symbolic coefficients")
    return {"integer_correction_cases": corrections,
            "cases_with_positive_displacement": positive_displacements,
            "earlier_inventory_injections": conservation,
            "edge_demand_excess_coefficients": coefficients,
            "positive_excess_reason": "d>=1: (50*d-3)*n*K>=0; 97*d*P/2>=0; 50*d>0"}


def pooled_copy_probes():
    cases = 0
    for globals_, flags in itertools.product(range(1, 8), repeat=2):
        weight = Q(1, 2 * globals_ * flags)
        require(globals_ * flags * weight == Q(1, 2), "Template mass differs")
        for _ in range(globals_):
            require(flags * weight == Q(1, 2 * globals_), "Global-copy coverage differs")
        for _ in range(flags):
            require(globals_ * weight == Q(1, 2 * flags), "Flag-copy coverage differs")
        cases += 1
    covers = [set(c) for size in range(5) for c in itertools.combinations(range(4), size)
              if all(u in c or v in c for u, v in itertools.combinations(range(4), 2))]
    require(min(map(len, covers)) == 3 and Q(2) + Q(4, 8) < 3, "K4 obstruction failed")
    return {"pool_size_pairs": cases, "K4_minimum_vertex_cover": 3,
            "extracted_K4_cover_bound": "5/2"}


def jacobian_replay():
    payload = load("displacement_payload.json")
    wrapped = load("displacement_output.json")
    operation = "optimization.linear.rational_general_optimum.compute"
    require(wrapped["request"] == {"operation_id": operation, "payload": payload},
            "Jacobian output is bound to another request")
    require(wrapped["result"]["operation_id"] == operation, "Wrong operation")
    result = wrapped["result"]["output"]
    program = payload["program"]
    require(result["status"] == "OPTIMAL" and result["program"] == program,
            "Incomplete, UNKNOWN, or nonoptimal adapter output is not evidence")
    status = load("displacement_adapter_status.json")
    require(status["adapter_exit_code"] == 0 and not status["timeout"], "Adapter failed")
    x = list(map(rational, result["primal_candidate"]))
    dual = list(map(rational, result["constraint_dual"]))
    lower = list(map(rational, result["lower_bound_dual"]))
    upper = list(map(rational, result["upper_bound_dual"]))
    objective = list(map(rational, program["objective"]["coefficients"]))
    require(program["objective"]["sense"] == "MINIMIZE", "Unexpected objective sense")
    stationarity = [Q(0)] * len(x)
    dual_value = Q(0)
    for row, multiplier in zip(program["constraints"], dual, strict=True):
        a = list(map(rational, row["coefficients"]))
        rhs = rational(row["rhs"])
        value = sum(v * w for v, w in zip(a, x, strict=True))
        require((row["relation"] == "GE" and value >= rhs and multiplier >= 0)
                or (row["relation"] == "LE" and value <= rhs and multiplier <= 0)
                or (row["relation"] == "EQ" and value == rhs),
                "Primal feasibility or dual row orientation failed")
        dual_value += multiplier * rhs
        stationarity = [s + multiplier * a_ for s, a_ in zip(stationarity, a, strict=True)]
    for i, variable in enumerate(program["variables"]):
        for key, multiplier, direction in [
                ("lower_bound", lower[i], 1), ("upper_bound", upper[i], -1)]:
            bound = variable[key]
            if bound is None:
                require(multiplier == 0, "Dual weight on an absent bound")
            else:
                q = rational(bound)
                require(direction * (x[i] - q) >= 0 and direction * multiplier >= 0,
                        "Primal/dual bound failed")
                dual_value += multiplier * q
                stationarity[i] += multiplier
    require(stationarity == objective, "Dual stationarity failed")
    primal_value = sum(a * b for a, b in zip(objective, x, strict=True))
    require(primal_value == dual_value == rational(result["primal_objective"])
            == rational(result["dual_objective"]) == 54, "Exact optimality equality failed")
    full = load("displacement_prefix_payload.json")["program"]
    combined = [Q(0)] * 6
    rhs = Q(0)
    for row, multiplier in zip(full["constraints"][:4], (1, -1, -1, -1), strict=True):
        combined = [v + multiplier * rational(a)
                    for v, a in zip(combined, row["coefficients"], strict=True)]
        rhs += multiplier * rational(row["rhs"])
    require(combined == [0, 0, 0, 1, -1, 0] and rhs == 57,
            "Elimination from full prefixes is incorrect")
    require(x == [57, 0, 54], "Unexpected sharp primal point")
    for xi in (0, 15):
        point = (75 - xi, 141, 66 + xi, 57 + xi, xi, 54)
        for row in full["constraints"]:
            value = sum(rational(a) * v for a, v in zip(row["coefficients"], point, strict=True))
            bound = rational(row["rhs"])
            require((row["relation"] == "GE" and value >= bound)
                    or (row["relation"] == "LE" and value <= bound)
                    or (row["relation"] == "EQ" and value == bound), "Prefix lift failed")
        for variable, value in zip(full["variables"], point, strict=True):
            require(value >= rational(variable["lower_bound"]), "Prefix lift lower bound")
            require(variable["upper_bound"] is None
                    or value <= rational(variable["upper_bound"]), "Prefix lift upper bound")
    failed = load("displacement_prefix_output.json")
    require(failed["ok"] is False
            and failed["error"]["data"]["code"] == "INVALID_REQUEST",
            "The earlier admission failure must remain a non-conclusion")
    return {"operation_id": operation, "protocol_version": wrapped["protocol_version"],
            "server_version": wrapped["server"]["version"], "adapter_exit_code": 0,
            "status": "OPTIMAL", "exact_optimum": "54", "primal": list(map(str, x)),
            "dual": list(map(str, dual)), "full_prefix_positive_displacement": 15,
            "scope": "Sharp abstract loss arithmetic with d=72,K=1,x_plus=9; not a constructed bin-packing instance.",
            "rejected_larger_request": "INVALID_REQUEST: simplex-basis admission bound; no mathematical conclusion"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--recorded-lean", action="store_true",
                        help="Check the source-bound official result without repeating its compiler run")
    parser.add_argument("--compare-upstream", action="store_true",
                        help="Also replay every documented localization edit against the read-only originals")
    parser.add_argument("--write-certificate", action="store_true",
                        help="Write exact_certificate.json after all checks pass")
    args = parser.parse_args()
    source, provenance = source_closure(args.compare_upstream)
    kernel = lean_evidence(source, not args.recorded_lean)
    certificate = {
        "schema_version": 1,
        "result_kind": "parameter_uniform_formal_verification",
        "claim": "For every natural c there exist a rational I and natural B with 5B items in (1/6,1), individualLP(I)=typeLP(I)=B, and opt(I)>B+c.",
        "formal_declaration": TARGET,
        "formal_signature": STATEMENT,
        "construction": "K4, k=2, rho=1/8; P0=100^11; K=25(c+1)(1+5P0); d=ceil(max(72K,120K/rho)); actual competing trees; R=100(P+4K+1).",
        "domain_source_files": provenance["domain_file_count"],
        "external_imports": ["Mathlib"],
        "mathematical_assumptions": [],
        "kernel": kernel,
        "exact_probes": {
            "classification": "Finite adversarial unit experiments, not substitutes for the uniform proof.",
            "patterns_and_labels": pattern_and_label_probes(),
            "key_order": key_order_probes(),
            "displacement_and_conservation": displacement_and_conservation_probes(),
            "physical_pool_and_clique": pooled_copy_probes(),
            "jacobian": jacobian_replay(),
        },
        "scope": {
            "arbitrary_integral_packings": True,
            "all_individual_copy_configurations": True,
            "all_numerical_type_multisets_without_demand_cap": True,
            "unbounded_parameter_c": True,
            "polynomial_time_and_PCP_claims_certified": False,
            "stronger_all_real_prefix_intermediate_lemma_certified": False,
            "independent_reviewer_acceptance": "pending",
            "novelty": "Not claimed; this certifies a complete localization of existing domain proofs.",
        },
    }
    encoded = json.dumps(certificate, indent=2, ensure_ascii=False) + "\n"
    if args.write_certificate:
        (HERE / "exact_certificate.json").write_text(encoded)
    else:
        require(certificate == load("exact_certificate.json"),
                "The exact certificate differs from the replayed mathematics")
    print(json.dumps({"result": "pass", "claim": "C118_STRUCTURAL_GAP",
                      "uniform_parameter": "all c in Nat",
                      "lean": "recorded_4.31.0" if args.recorded_lean else "replayed_4.31.0",
                      "proof_holes": [], "domain_files": 44,
                      "axiom_audits": 48, "reviewer_acceptance": "pending"}))


if __name__ == "__main__":
    main()
