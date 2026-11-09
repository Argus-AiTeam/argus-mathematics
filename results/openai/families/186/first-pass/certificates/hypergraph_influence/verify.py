#!/usr/bin/env python3
"""Replay the complete hypergraph theorem and its exact dependency closure."""

import hashlib
import json
import math
import os
from pathlib import Path
import re
import subprocess
import time
from fractions import Fraction


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BUILD = HERE / "build"
LOGS = HERE / "replay"
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
LEAN = "$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean"
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
BLOCK_MODULES = (
    "BlockSymmetry", "RestrictionInfluence", "BlockOrbit", "BlockCounting",
    "BlockAverage", "RestrictionMassSubtype",
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(command, *, cwd=ROOT, env=None, log=None, timeout=360):
    completed = subprocess.run(
        command, cwd=cwd, env=env, text=True, capture_output=True,
        timeout=timeout, check=False,
    )
    if log is not None:
        log.write_text(completed.stdout + completed.stderr)
    require(
        completed.returncode == 0,
        f"Command failed ({completed.returncode}): {command}\n"
        f"{completed.stdout[-6000:]}\n{completed.stderr[-6000:]}",
    )
    return completed.stdout


def product_weight(p, bits):
    ones = sum(bits)
    return p ** ones * (1 - p) ** (len(bits) - ones)


def cube(d):
    return [tuple((mask >> i) & 1 for i in range(d)) for mask in range(1 << d)]


def squared_fourier(p, values, d):
    points = cube(d)
    q = p * (1 - p)
    result = []
    for mask in range(1 << d):
        moment = Fraction(0)
        for x in points:
            term = product_weight(p, x) * values[x]
            for i in range(d):
                if (mask >> i) & 1:
                    term *= x[i] - p
            moment += term
        result.append(moment ** 2 / q ** mask.bit_count())
    return result


def pivotal(p, values, d, i):
    answer = Fraction(0)
    for x in cube(d):
        zero, one = list(x), list(x)
        zero[i], one[i] = 0, 1
        if values[tuple(zero)] != values[tuple(one)]:
            answer += product_weight(p, x)
    return answer


def exact_experiments():
    cases = identities = 0
    biases = (Fraction(1, 1000003), Fraction(1, 2), Fraction(1000002, 1000003))
    functions = (
        lambda x: 0,
        lambda x: 1,
        lambda x: sum(x) % 2,
        lambda x: int(sum(x) == 1),
        lambda x: int(sum(x) >= 2),
        lambda x: x[0] ^ x[2],
    )
    for p in biases:
        for function in functions:
            values = {x: function(x) for x in cube(4)}
            energy = squared_fourier(p, values, 4)
            mean = sum(product_weight(p, x) * values[x] for x in cube(4))
            influences = [pivotal(p, values, 4, i) for i in range(4)]
            require(sum(energy[1:]) == mean * (1 - mean), "biased variance identity")
            require(
                sum(mask.bit_count() * energy[mask] for mask in range(16))
                == p * (1 - p) * sum(influences),
                "pivotal weighted Parseval normalization",
            )
            averages = [Fraction(0)] * 4
            average_influences = [Fraction(0)] * 2
            for y in cube(2):
                restricted = {
                    x: values[(x[0], y[0], x[1], y[1])] for x in cube(2)
                }
                local = squared_fourier(p, restricted, 2)
                for mask in range(4):
                    averages[mask] += product_weight(p, y) * local[mask]
                for i in range(2):
                    average_influences[i] += product_weight(p, y) * pivotal(
                        p, restricted, 2, i
                    )
            for mask in range(4):
                exterior_sum = sum(
                    energy[s] for s in range(16)
                    if ((s & 1) | ((s >> 1) & 2)) == mask
                )
                require(averages[mask] == exterior_sum, "all exterior degrees retained")
                identities += 1
            require(average_influences == [influences[0], influences[2]],
                    "averaged restricted pivotal influences")
            cases += 1
    orbit_checks = 0
    for m in range(4, 10):
        for j in range(1, m):
            require(math.comb(m, j) >= m, "interior block orbit lower bound")
            orbit_checks += 1
        require(math.comb(m, m) == 1 < m, "excluded full-block orbit boundary")
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    typed = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_adapter_status.json").read_text())
    require(status == {"adapter_exit_code": 0, "timeout": False}, "adapter non-conclusion")
    require(typed["request"]["operation_id"] == "group_action.subset.canonicalize",
            "wrong exact orbit operation")
    require(typed["request"]["payload"] == payload, "changed exact orbit payload")
    require(typed["server"]["version"] == "0.14.0", "unrecognized recorded Jacobian")
    require(typed["protocol_version"] == "2025-11-25", "unrecognized protocol")
    orbit = {tuple(payload["subset"]["positions"])}
    queue = list(orbit)
    for subset in queue:
        for generator in payload["subset"]["action"]["generators"]:
            image = tuple(sorted(generator[i] for i in subset))
            if image not in orbit:
                orbit.add(image)
                queue.append(image)
    output = typed["result"]["output"]
    require(len(orbit) == output["orbit_size"] == math.comb(6, 3) == 20,
            "typed subset orbit disagrees with exact replay")
    require(output["stabilizer_size"] * len(orbit) == math.factorial(6),
            "typed orbit-stabilizer identity")
    return {
        "kind": "finite_adversarial_experiment_not_universal_proof",
        "boolean_bias_cases": cases,
        "restriction_coefficient_identities": identities,
        "interior_orbit_checks": orbit_checks,
        "nonmonotone_functions_included": True,
        "biases": [str(p) for p in biases],
        "counterexamples": 0,
        "jacobian_orbit_size": len(orbit),
    }


def accepted_capture(certificate):
    archived = json.loads((ROOT / certificate["accepted_capture_certificate"]).read_text())
    checked = archived["lean_check"]
    require(checked["exit_code"] == 0 and checked["proof_holes"] == [],
            "capture dependency was not kernel verified")
    require(digest(ROOT / archived["lean_source"]["path"]) == checked["source_sha256"],
            "the independently accepted capture source changed")
    require(digest(ROOT / archived["statement_fidelity"]["path"])
            == checked["statement_fidelity_sha256"], "the accepted capture reading changed")
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "V_HYPERGRAPH_CAPTURE"),
        key=lambda c: c["version"],
    )
    require(any(
        e["subject"]["subject_id"] == "V_HYPERGRAPH_CAPTURE"
        and e["subject"]["content_hash"] == claim["content_hash"]
        and e["tier"] == "judgement" and e["verdict"] == "supports"
        and e["produced_by"] == "reviewer:copilot-independent"
        for e in state["evidence"]
    ), "the accepted capture dependency lacks its recorded independent review")
    return {
        "certificate": certificate["accepted_capture_certificate"],
        "source_sha256": checked["source_sha256"],
        "statement_fidelity_sha256": checked["statement_fidelity_sha256"],
        "independent_review_preserved": True,
    }


def dependency_plan():
    plan = []
    upstream = HERE / "upstream"
    manifest = json.loads((upstream / "source-manifest.json").read_text())
    require(manifest["commit"] == "4eaee87548250b2682affda7d05d947c05554bae",
            "generic source revision changed")
    for name in manifest["dependency_order"]:
        entry = manifest["modules"][name]
        original = upstream / "original" / entry["path"]
        require(digest(original) == entry["sha256"], f"changed upstream original: {name}")
        source = upstream / "port" / entry["path"]
        plan.append((name, source, upstream / "port"))
    plan.extend([
        ("research.certificates.hypergraph_capture.Main",
         ROOT / "research/certificates/hypergraph_capture/Main.lean", ROOT),
        ("research.certificates.hypergraph_influence.Model", HERE / "Model.lean", ROOT),
    ])
    block = HERE / "block_support"
    manifest = json.loads((block / "source-manifest.json").read_text())
    for entry in manifest["sources"]:
        require(digest(block / "original" / entry["path"]) == entry["sha256"],
                f"changed block-helper original: {entry['path']}")
    for name in BLOCK_MODULES:
        plan.append((
            "HypergraphBlockSupport." + name,
            block / "port/OAI/Combinatorics/SharpThreshold" / (name + ".lean"), ROOT,
        ))
    for name in ("Orbit", "Restriction"):
        plan.append(("HypergraphBlockSupport." + name, block / (name + ".lean"), ROOT))
    for name in ("Block", "Transfer", "Constants"):
        plan.append(("research.certificates.hypergraph_influence." + name,
                     HERE / (name + ".lean"), ROOT))
    return plan


def compile_dependencies(plan, env):
    results = []
    for name, source, source_root in plan:
        output = BUILD.joinpath(*name.split(".")).with_suffix(".olean")
        output.parent.mkdir(parents=True, exist_ok=True)
        log = LOGS / (name + ".log")
        command = [LEAN, "--root=" + str(source_root), "-o", str(output), str(source)]
        started = time.monotonic()
        run(command, env=env, log=log)
        results.append({
            "module": name, "source": str(source.relative_to(ROOT)),
            "source_sha256": digest(source), "exit_code": 0,
            "seconds": round(time.monotonic() - started, 3),
            "log": str(log.relative_to(ROOT)),
        })
        print(f"COMPILED {name}", flush=True)
    return results


def verify_theorem(certificate, env):
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / certificate["source"]),
        "--statement-fidelity", str(HERE / certificate["statement_fidelity"]),
        "--project-root", str(ROOT), "--claim", certificate["claim_id"],
        "--artifact-dir", str(HERE / "certificates"),
        "--no-lake", "--lean-bin", LEAN, "--timeout", "360",
    ]
    text = run(command, env=env, log=LOGS / "claim-linked-verification.json", timeout=420)
    result = json.loads(text)
    require(result["status"] == "success" and result["exit_code"] == 0
            and result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "the actual theorem did not pass the official hole-free compiler/audit")
    require(result["kernel"]["recorded"] is not None, "mechanical claim evidence not recorded")
    require(result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"),
            "the claim was not checked with Lean 4.31.0")
    axioms = {
        name: [item.strip() for item in values.split(",") if item.strip()]
        for name, values in re.findall(
            r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", result["stdout"]
        )
    }
    permitted = set(certificate["permitted_axioms"])
    for theorem in certificate["audited_theorems"]:
        require(theorem in axioms, f"missing actual transitive axiom audit: {theorem}")
        require(set(axioms[theorem]) <= permitted,
                f"unsupported axioms in {theorem}: {axioms[theorem]}")
    return {
        "status": "success", "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"], "axiom_audit_exit_code": result["audit_exit_code"],
        "axioms": axioms, "kernel": result["kernel"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "runtime_record": "certificates/lean_check.json",
        "full_output": str((LOGS / "claim-linked-verification.json").relative_to(HERE)),
    }


def check_campaign():
    results = {}
    for module in ("math_state", "proof_graph_check"):
        command = [
            ARGUS, "-m", f"argus_skill.verticals.math.{module}",
            "check", "--project-root", str(ROOT),
        ]
        run(command, log=LOGS / (module + ".log"), timeout=60)
        results[module] = {"project_root": str(ROOT), "exit_code": 0}
    return results


def main():
    certificate_path = HERE / "exact_certificate.json"
    certificate = json.loads(certificate_path.read_text())
    LOGS.mkdir(exist_ok=True)
    version = run([LEAN, "--version"], timeout=30).strip()
    require(version.startswith("Lean (version 4.31.0,"), f"wrong compiler: {version}")
    capture = accepted_capture(certificate)
    experiments = exact_experiments()
    plan = dependency_plan()
    sources = [source for _, source, _ in plan] + [
        HERE / certificate["source"], HERE / certificate["statement_fidelity"],
    ]
    before = {str(source.relative_to(ROOT)): digest(source) for source in sources}
    if "dependency_sources" in certificate:
        require(certificate["dependency_sources"] == before,
                "certified dependency text changed; inspect it before issuing a new certificate")
    inherited = run(["lake", "env", "printenv", "LEAN_PATH"], cwd=WORKSPACE).strip()
    env = dict(os.environ, LEAN_PATH=str(BUILD) + ":" + inherited)
    compiled = compile_dependencies(plan, env)
    mechanical = verify_theorem(certificate, env)
    require(before == {str(source.relative_to(ROOT)): digest(source) for source in sources},
            "the theorem, fidelity document, or a dependency changed during verification")
    checks = check_campaign()
    certificate.update({
        "status": "kernel_verified_review_pending",
        "compiler": version, "dependency_sources": before,
        "compiled_dependencies": compiled, "accepted_capture": capture,
        "mechanical_result": mechanical, "exact_experiments": experiments,
        "campaign_local_validation": checks,
    })
    certificate_path.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "claim_id": certificate["claim_id"], "theorem": certificate["theorem"],
        "status": certificate["status"], "compiled_dependencies": len(compiled),
        "exit_code": mechanical["exit_code"], "proof_holes": mechanical["proof_holes"],
        "axiom_audit_exit_code": mechanical["axiom_audit_exit_code"],
        "campaign_local_validation": checks, "exact_experiments": experiments,
        "independent_review": certificate["independent_review"],
    }, indent=2))


if __name__ == "__main__":
    main()
