#!/usr/bin/env python3
"""Replay the exact cut-transfer certificate; finite tests are not the theorem."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
from pathlib import Path
import shutil
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def form(**coefficients):
    return {key: Fraction(value) for key, value in coefficients.items() if value}


def add_forms(*forms):
    result = {}
    for item in forms:
        for key, value in item.items():
            result[key] = result.get(key, Fraction(0)) + value
    return {key: value for key, value in result.items() if value}


def exact_identities():
    identities = {
        "moving_barrier": (
            form(T=1, B=-1, gammaD=Fraction(-1, 2)),
            [
                form(T=1, M=-1, ES=1),
                form(M=1, R=-1, gammaD=-1),
                form(R=1, az=1, ax=-1, B=-1),
                form(gammaD=Fraction(1, 8), az=-1),
                form(gammaD=Fraction(1, 8), ax=1),
                form(gammaD=Fraction(1, 8), ES=-1),
                form(gammaD=Fraction(1, 8)),
            ],
        ),
        "moving_metric_budget": (
            form(gammaD=Fraction(1, 8), ES=-1),
            [form(ED=5, ES=-1), form(gammaD=Fraction(1, 8), ED=-5)],
        ),
        "fixed_barrier": (
            form(T=1, B=-1, gS=Fraction(-1, 2)),
            [
                form(T=1, M=-1, epsS=1),
                form(M=1, R=-1, gS=-1),
                form(R=1, az=1, ax=-1, B=-1),
                form(abs_sum=1, az=-1, ax=1),
                form(epsS=1, C=2, abs_sum=-1),
                form(gS=Fraction(1, 4), epsS=-2),
                form(gS=Fraction(1, 4), C=-2),
            ],
        ),
        "moving_radius": (
            form(D=2, Z=-1),
            [form(D=2, Z=-2, X=2), form(Z=1, n=-1), form(n=1, X=-2)],
        ),
        "moving_scale": (
            form(D=5, X=-1, Z=-1, n=-1),
            [form(D=5, Z=-5, X=5), form(Z=4, n=-4), form(n=3, X=-6)],
        ),
        "moving_cut_distance": (
            form(D=1, n=Fraction(-1, 2)),
            [form(D=1, Z=-1, X=1), form(Z=1, n=-1),
             form(n=Fraction(1, 2), X=-1)],
        ),
        "upper_sector_comparability": (
            form(cD=1, D=2, cX=-1, cZ=-1),
            [form(cD=1, cX=1, cZ=-1), form(D=2, cX=-2)],
        ),
        "lower_sector_comparability": (
            form(cD=1, D=4, cX=-1, cZ=-1),
            [form(cD=1, cX=1, cZ=-1), form(D=4, cX=-2)],
        ),
    }
    checked = {}
    for name, (target, summands) in identities.items():
        require(add_forms(*summands) == target, f"False exact identity: {name}")
        checked[name] = {
            "target_coefficients": {key: str(value) for key, value in target.items()},
            "summand_coefficients": [
                {key: str(value) for key, value in item.items()} for item in summands
            ],
        }
    return checked


def shared_edge(u, v, side):
    in_upper = u[1] >= 0 and v[1] >= 0
    return in_upper if side == 1 else not in_upper


def original_weight(u, v):
    edge = sorted((u, v))
    return Fraction(3 + abs(edge[0][0]) + 2 * abs(edge[1][1]), 7)


def changed_weight(u, v, side):
    if shared_edge(u, v, side):
        return original_weight(u, v)
    return original_weight(u, v) + Fraction(1, 101)


def path_cost(path, weight):
    return sum((weight(u, v) for u, v in zip(path, path[1:])), Fraction(0))


def check_walk(path, side):
    require(side * path[-1][1] > 0, "Regression endpoint is on the wrong side")
    hits = [i for i, vertex in enumerate(path) if vertex[1] == 0]
    if not hits:
        require(all(side * vertex[1] > 0 for vertex in path), "A walk skipped the cut")
        require(all(shared_edge(u, v, side) for u, v in zip(path, path[1:])),
                "A cut-avoiding walk used a changed edge")
        return False, False, False
    last = hits[-1]
    suffix = path[last:]
    require(all(side * vertex[1] > 0 for vertex in suffix[1:]),
            "Last-cut suffix left the retained side")
    require(all(shared_edge(u, v, side) for u, v in zip(suffix, suffix[1:])),
            "Last-cut suffix has an unshared edge")
    changed = lambda u, v: changed_weight(u, v, side)
    require(path_cost(suffix, changed) == path_cost(suffix, original_weight),
            "Suffix traversal costs changed")
    require(path_cost(path, changed) ==
            path_cost(path[:last + 1], changed) + path_cost(suffix, changed),
            "Walk-cost split lost a traversal")
    horizontal_cut = any(u[1] == v[1] == 0 for u, v in zip(path, path[1:]))
    return True, len(hits) > 1, horizontal_cut


def finite_walk_regression():
    steps = ((1, 0), (-1, 0), (0, 1), (0, -1))
    counts = {"enumerated": 0, "retained_side_endpoint": 0, "cut_touching": 0,
              "repeated_cut_visits": 0, "horizontal_cut_edge": 0}
    for side in (1, -1):
        for length in range(8):
            for word in itertools.product(steps, repeat=length):
                counts["enumerated"] += 1
                path = [(0, side)]
                for dx, dy in word:
                    x, y = path[-1]
                    path.append((x + dx, y + dy))
                if side * path[-1][1] <= 0:
                    continue
                counts["retained_side_endpoint"] += 1
                touch, repeated, horizontal = check_walk(path, side)
                counts["cut_touching"] += int(touch)
                counts["repeated_cut_visits"] += int(repeated)
                counts["horizontal_cut_edge"] += int(horizontal)
    require(counts["enumerated"] == 2 * sum(4 ** length for length in range(8)),
            "The advertised walk range was not exhausted")
    require(all(value > 0 for value in counts.values()), "Missing boundary regression coverage")
    examples = {
        "upper": [(0, 1), (0, 0), (0, -1), (1, -1), (1, 0), (1, 1)],
        "lower": [(0, -1), (0, 0), (1, 0), (1, -1), (0, -1)],
    }
    for side, name in ((1, "upper"), (-1, "lower")):
        path = examples[name]
        check_walk(path, side)
        first = next(i for i, vertex in enumerate(path) if vertex[1] == 0)
        require(any(not shared_edge(u, v, side)
                    for u, v in zip(path[first:], path[first + 1:])),
                "First-cut regression did not distinguish first and last visits")
    return {
        "scope": "All four-neighbor walks of lengths 0 through 7 from (0,1) and (0,-1).",
        "counts": counts,
        "first_cut_is_insufficient_examples": {
            name: [list(vertex) for vertex in path] for name, path in examples.items()
        },
        "interpretation": "Finite regression only; the universal walk theorem is proved in Lean.",
    }


def rational(entry):
    num, den = int(entry["num"]), int(entry["den"])
    require(den > 0, "Nonpositive Jacobian rational denominator")
    value = Fraction(num, den)
    require(value.numerator == num and value.denominator == den,
            "Noncanonical Jacobian rational")
    return value


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "matrix.rational_linear_system.solve"
    require(response["request"]["operation_id"] == operation, "Wrong Jacobian operation")
    require(response["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(response["result"]["operation_id"] == operation, "Wrong result operation")
    require(not response.get("error") and not response["result"].get("error"),
            "Jacobian adapter reported an error")
    output = response["result"]["output"]
    require(output["outcome"] == "UNIQUE", "A non-unique or unknown solve is not a certificate")
    require(output["matrix"] == payload["matrix"] and output["rhs"] == payload["rhs"],
            "Jacobian result changed the problem")
    matrix = [[rational(item) for item in row] for row in output["matrix"]["entries"]]
    rhs = [rational(item) for item in output["rhs"]]
    solution = [rational(item) for item in output["solution"]]
    require(matrix == [[0, 1], [1, 1]] and rhs == [0, 0], "Wrong two-direction map")
    require(len(solution) == 2, "Incomplete Jacobian solution")
    determinant = matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    require(determinant == -1, "The two lattice directions are not independent")
    require([sum((a * b for a, b in zip(row, solution)), Fraction(0))
             for row in matrix] == rhs, "Jacobian solution fails exact replay")
    require(solution == [0, 0], "The two label-coordinate differences did not vanish")
    return {
        "operation_id": operation,
        "server": response["server"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "payload_file": "jacobian_payload.json",
        "typed_output_file": "jacobian_output.json",
        "adapter_status": "success",
        "adapter_exit_code": 0,
        "structured_error": None,
        "outcome": output["outcome"],
        "determinant": str(determinant),
        "coordinate_difference": [str(item) for item in solution],
        "scope": "Exact rational coefficient matrix; Lean's limit theorem is over the reals.",
    }


def lean_certificate(recompile):
    source_path = HERE / "Main.lean"
    fidelity_path = HERE / "statement_fidelity.md"
    source = source_path.read_text()
    fidelity = fidelity_path.read_text()
    run = json.loads((HERE / "lean_verification.json").read_text())
    check = json.loads((HERE / "lean_check.json").read_text())
    record = run["kernel"]["recorded"]
    archive_path = ROOT / record["artifact"]
    require(archive_path.resolve().is_relative_to(HERE), "Compiler archive is outside this node")
    archive = json.loads(archive_path.read_text())
    require(check["status"] == "success" and check["exit_code"] == 0,
            "No successful authorized Lean run")
    require(check["proof_holes"] == [] and check["audit_exit_code"] == 0,
            "Lean proof has holes or its axiom audit failed")
    require(not check["environment_failure"], "Lean environment failure")
    require("version 4.31.0," in check["tools"]["lean"]["version"], "Wrong Lean version")
    require(check["source_sha256"] == hashlib.sha256(source_path.read_bytes()).hexdigest(),
            "Lean source changed after certification")
    require(check["statement_fidelity_sha256"] ==
            hashlib.sha256(fidelity.encode()).hexdigest(),
            "Statement-fidelity document changed after certification")
    require(archive["lean_check"] == check, "Archived and current compiler records differ")
    require(archive["lean_source"]["text"] == source, "Archive contains a different theorem")
    require(archive["statement_fidelity"]["text"] == fidelity,
            "Archive contains a different statement-fidelity reading")
    require(archive["subject"] == record["subject"] and
            archive["subject"]["subject_id"] == "C_CT_CORE", "Wrong kernel subject")
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            "The archived record is not a mechanical supporting verdict")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max((item for item in state["claims"] if item["claim_id"] == "C_CT_CORE"),
                key=lambda item: item["version"])
    require(claim["formal_statement"].strip() == source.strip(),
            "The claim ledger records different Lean text")
    require(claim["content_hash"] == record["subject"]["content_hash"],
            "Compiler certificate belongs to a superseded claim")
    require(any(item["evidence_id"] == record["evidence_id"] and
                item["artifact"] == record["artifact"] for item in state["evidence"]),
            "Mechanical evidence is absent from the campaign ledger")
    if recompile:
        workspace = Path(check["lake_workspace"])
        require(workspace.is_dir(), f"Certified Mathlib workspace is missing: {workspace}")
        lake = shutil.which("lake")
        require(lake is not None, "Lake is missing; a compiler replay cannot be claimed")
        version = subprocess.run([lake, "env", "lean", "--version"], cwd=workspace,
                                 text=True, capture_output=True, timeout=10)
        require(version.returncode == 0 and "version 4.31.0," in version.stdout,
                f"Wrong or unavailable live compiler: {version.stdout}{version.stderr}")
        compiled = subprocess.run([lake, "env", "lean", str(source_path)], cwd=workspace,
                                  text=True, capture_output=True, timeout=90)
        require(compiled.returncode == 0,
                f"Fresh Lean replay failed:\n{compiled.stdout}{compiled.stderr}")
    return {
        "claim": "C_CT_CORE",
        "certificate": record["artifact"],
        "produced_by": record["produced_by"],
        "exit_code": check["exit_code"],
        "proof_holes": check["proof_holes"],
        "axiom_audit_exit_code": check["audit_exit_code"],
        "source_sha256": check["source_sha256"],
        "statement_fidelity_sha256": check["statement_fidelity_sha256"],
        "statement_fidelity_verified_by": None,
        "scope": "Universal deterministic core only; source premises and stochastic lift are in prose.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true",
                        help="Write the computed exact_certificate.json.")
    parser.add_argument("--recorded-lean", action="store_true",
                        help="Check the real authorized certificate without repeating its compiler run.")
    args = parser.parse_args()
    certificate = {
        "claim": "C_CT_TRANSFER",
        "result_class": "conditional_verification_theorem",
        "campaign_complete": False,
        "novelty_status": "not_claimed",
        "independent_review": "required; this script does not supply a Reviewer judgement",
        "quantifiers": {
            "upper": "exists deterministic n_k; almost surely forall finite ray families P and finite K, exists k0, forall k>=k0, transfer holds; exists target J depending on P,K,k",
            "lower": "on the same event forall n>=1 and every lower ray q, exists a retained tail with the exact original label",
        },
        "proof": "report.md",
        "upstream_dependencies": {
            "C_CT_TRANSFER": ["A_CT_MINIMIZERS", "A_CT_BUSEMANN", "A_CT_STRUCTURE",
                              "A_CT_UNIFORM", "A_CT_CHART", "A_CT_COUPLING"],
            "C_CT_INPUTS": ["A_CT_BOUNDARY_SCOPE"],
            "boundary_comparison_independently_verified": False,
        },
        "exact_nonnegative_slack_identities": exact_identities(),
        "finite_walk_regression": finite_walk_regression(),
        "two_direction_check": jacobian_replay(),
        "lean": lean_certificate(not args.recorded_lean),
    }
    certificate_path = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate_path.write_text(json.dumps(certificate, indent=2) + "\n")
    else:
        require(certificate_path.is_file(), "Missing exact_certificate.json")
        recorded = json.loads(certificate_path.read_text())
        require(recorded == certificate, "Exact certificate differs from independent recomputation")
    print(json.dumps({
        "ok": True,
        "claim": certificate["claim"],
        "result_class": certificate["result_class"],
        "lean": "recorded real compiler certificate checked" if args.recorded_lean
                else "fresh Lean 4.31.0 replay succeeded",
        "proof_holes": certificate["lean"]["proof_holes"],
        "lattice_walks_enumerated": certificate["finite_walk_regression"]["counts"]["enumerated"],
        "independent_review": "not performed by this script",
        "campaign_complete": False,
    }, indent=2))


if __name__ == "__main__":
    main()
