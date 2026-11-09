#!/usr/bin/env python3
"""Replay the realized boundary proof and exact, non-proof finite regressions."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from fractions import Fraction as Q
from functools import lru_cache


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent.parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
MATHLIB = "$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"
CLAIM = "C_REALIZED_BOUNDARY"
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
DECLARATIONS = [
    "BoundaryAudit.actual_bridge",
    "BoundaryAudit.realized_signed_boundary",
    "BoundaryAudit.realized_boundary",
]


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path):
    return json.loads(path.read_text())


def call(command, log, env=None):
    result = subprocess.run(
        command, cwd=PROJECT, env=env, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
    )
    log.write_text(result.stdout)
    if result.returncode:
        print(result.stdout[-12000:], file=sys.stderr)
    return result


def is_basic(interval):
    left, right = interval
    width = right - left
    return (
        0 <= left < right <= 1
        and width.numerator == 1
        and width.denominator & (width.denominator - 1) == 0
        and (left / width).denominator == 1
    )


def image(g, n):
    points = tuple(g(Q(k, 2**n)) for k in range(2**n + 1))
    cells = tuple(zip(points, points[1:]))
    require(points[0] == 0 and points[-1] == 1, "Image endpoints changed")
    require(all(is_basic(cell) for cell in cells), "Image is not basic")
    return cells


def respects(partition, interval):
    endpoints = {point for cell in partition for point in cell}
    return interval[0] in endpoints and interval[1] in endpoints


def restrict(partition, interval):
    require(respects(partition, interval), "Undefined normalized restriction")
    left, right = interval
    width = right - left
    result = tuple(
        ((a - left) / width, (b - left) / width)
        for a, b in partition if left <= a and b <= right
    )
    require(bool(result) and all(is_basic(cell) for cell in result),
            "Restriction is not a basic partition")
    return result


def insert(parent, child):
    left, right = parent
    return tuple(left + (right - left) * x for x in child)


def x0(x):
    if x <= Q(1, 2):
        return x / 2
    if x <= Q(3, 4):
        return x - Q(1, 4)
    return 2 * x - 1


def x0_inverse(x):
    if x <= Q(1, 4):
        return 2 * x
    if x <= Q(1, 2):
        return x + Q(1, 4)
    return (x + 1) / 2


def finite_regressions():
    parents = ((Q(1, 8), Q(1, 4)), (Q(3, 8), Q(1, 2)))
    children = tuple(tuple(insert(parent, child) for child in parents)
                     for parent in parents)
    family = parents + tuple(child for row in children for child in row)

    @lru_cache(maxsize=None)
    def color(partition):
        if not all(respects(partition, parent) for parent in parents):
            return Q(0)
        restrictions = tuple(restrict(partition, parent) for parent in parents)
        require(all(len(part) < len(partition) for part in restrictions),
                "Recursive cell count did not decrease")
        value = (sum(color(part) for part in restrictions) / 2 + 1) / 2
        require(abs(value) <= 1, "Color escaped the unit ball")
        return value

    covariance_count = restriction_count = recursion_count = 0
    differences = []
    for name, g in (("identity", lambda x: x), ("standard_x0", x0),
                    ("standard_x0_inverse", x0_inverse)):
        partition = image(g, 8)
        translated = image(lambda x: x0(g(x)), 8)
        require(all(respects(partition, interval) for interval in family),
                "Source regression is not admissible")
        for interval in family:
            target = tuple(x0(point) for point in interval)
            require(respects(translated, target), "Target is not admissible")
            require(restrict(translated, target) == restrict(partition, interval),
                    "Composition orientation or covariance is wrong")
            covariance_count += 1
        xs = tuple(color(restrict(partition, parent)) for parent in parents)
        zs = []
        for i, parent in enumerate(parents):
            for j, child in enumerate(parents):
                require(
                    restrict(restrict(partition, parent), child)
                    == restrict(partition, children[i][j]),
                    "Successive restriction identity is wrong",
                )
                restriction_count += 1
            z = sum(color(restrict(partition, child)) for child in children[i]) / 2
            require(xs[i] == (z + 1) / 2, "Actual recursive identity failed")
            recursion_count += 1
            zs.append(z)
        if name != "standard_x0_inverse":
            differences.append(zs[0] - sum(xs) / 2)

    require(differences == [Q(-1, 2), Q(-1, 8)], "Moment payload is mistranslated")
    moment = sum(x*x for x in differences) / len(differences)
    require(moment == Q(17, 128), "Exact second moment is wrong")
    payload = read_json(HERE / "jacobian_payload.json")
    status = read_json(HERE / "jacobian_status.json")
    typed = read_json(HERE / "jacobian_output.json")
    require(status["adapter_exit_code"] == 0 and not status["timeout"],
            "Jacobian execution was inconclusive")
    require(typed["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(typed["result"]["operation_id"]
            == "probability.finite_distribution.raw_moment.compute",
            "Wrong Jacobian operation")
    answer = typed["result"]["output"]["moment"]
    require(Q(int(answer["num"]), int(answer["den"])) == moment,
            "Jacobian typed moment disagrees")
    return {
        "classification": "finite_regression_only",
        "uniform_level": 8,
        "D": 2,
        "parent_depth": 3,
        "maps": ["identity", "standard_x0", "standard_x0_inverse"],
        "covariance_equalities": covariance_count,
        "successive_restriction_equalities": restriction_count,
        "recursive_equalities": recursion_count,
        "z1_minus_m": [str(x) for x in differences],
        "second_moment": str(moment),
        "positive_displacement_assumed": False,
    }


def main():
    require(PROJECT.name == "9000248", "Wrong campaign project root")
    regression = finite_regressions()
    build = call([PYTHON, str(HERE / "replay_upstream.py")], HERE / "build.log")
    require(build.returncode == 0, "Upstream dependency replay failed")
    replay = read_json(HERE / "upstream/.replay/last_run.json")
    require(replay["status"] == "success" and replay["standard_axioms_only"],
            "Upstream proof closure is not certified")
    require(replay["module_count"] == 35, "Unexpected realized dependency closure")
    env = os.environ.copy()
    env["LEAN_PATH"] = str(HERE / "upstream")
    env["ARGUS_SKILL_MATHLIB_WORKSPACE"] = MATHLIB
    compiler = call(
        [PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
         str(HERE / "Main.lean"), "--statement-fidelity",
         str(HERE / "statement_fidelity.md"), "--claim", CLAIM,
         "--project-root", str(PROJECT), "--lake", "--timeout", "180"],
        HERE / "compiler_command.json", env,
    )
    gates = {}
    for module in ("math_state", "proof_graph_check"):
        gate = call(
            [PYTHON, "-m", "argus_skill.verticals.math." + module,
             "check", "--project-root", str(PROJECT)],
            HERE / (module + "_check.log"),
        )
        gates[module] = gate.returncode
    require(compiler.returncode == 0, "Official Lean certification failed")
    formal = read_json(HERE / "compiler_command.json")
    require(formal["status"] == "success" and formal["exit_code"] == 0
            and formal["proof_holes"] == [], "Lean proof has not passed")
    require(formal["source_sha256"] == sha256(HERE / "Main.lean"),
            "Compiled source is stale")
    require(formal["statement_fidelity_sha256"]
            == sha256(HERE / "statement_fidelity.md"), "Fidelity document is stale")
    compiler_text = json.dumps(formal)
    require("Lean (version 4.31.0," in compiler_text, "Wrong compiler version")
    axiom_lines = re.findall(
        r"'(BoundaryAudit\.[A-Za-z_]+)' depends on axioms: \[([^\]]*)\]",
        compiler_text,
    )
    axioms = {
        name: [item.strip() for item in values.split(",") if item.strip()]
        for name, values in axiom_lines
    }
    require(set(axioms) == set(DECLARATIONS), "Missing theorem axiom audit")
    require(all(set(values) <= ALLOWED_AXIOMS for values in axioms.values()),
            "Nonstandard theorem axiom")
    require(all(code == 0 for code in gates.values()), "Campaign-local gate failed")
    certificate = {
        "schema_version": 1,
        "status": "verified_pending_independent_review",
        "result_class": "formal_verification",
        "claim": CLAIM,
        "theorems": DECLARATIONS,
        "boundary_constant": "(delta^2/L^2-4/D)/(4*(1-1/D))",
        "fixed_set": "OAI.ThompsonNonamenability.fixedTransportSet hD",
        "interval_family": "selectedInterval D i, depth 2*D, index 2*i+1",
        "quantifiers": "S(D) fixed; every finite nonempty A; N before every f; every n>=N",
        "extension": "Cofinal bridge uniform in f; signed boundary without D>4*L^2/delta^2",
        "lean": {
            "exit_code": formal["exit_code"],
            "proof_holes": formal["proof_holes"],
            "source_sha256": formal["source_sha256"],
            "statement_fidelity_sha256": formal["statement_fidelity_sha256"],
            "kernel_record": formal["kernel"],
            "axioms": axioms,
        },
        "dependency_replay": {
            "module_count": replay["module_count"],
            "version": replay["version"],
            "compiled_count": replay["compiled_count"],
            "cached_count": replay["cached_count"],
            "source_sha256": replay["source_sha256"],
            "report": "research/boundary_audit/upstream/.replay/" + replay["run"] + "/report.json",
        },
        "finite_regressions": regression,
        "jacobian": {
            "operation_id": "probability.finite_distribution.raw_moment.compute",
            "adapter_exit_code": 0,
            "payload": "research/boundary_audit/jacobian_payload.json",
            "typed_output": "research/boundary_audit/jacobian_output.json",
            "scope": "Exact finite second moment only; not a universal proof",
        },
        "validation": {"project_root": str(PROJECT), "exit_statuses": gates},
        "scope_exclusions": [
            "Existence of a uniformly displaced Lipschitz map",
            "Analytic appendix, Folner implication, and downstream consequences",
            "A formal theorem for every possible parent interval family",
            "Independent statement-fidelity approval or verified novelty",
        ],
        "independent_review": {"required": True, "confirmed": False},
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "status": certificate["status"],
        "claim": CLAIM,
        "lean_exit": 0,
        "proof_holes": [],
        "dependency_modules": replay["module_count"],
        "finite_regressions": regression,
        "validation": certificate["validation"],
    }, indent=2))


if __name__ == "__main__":
    main()
