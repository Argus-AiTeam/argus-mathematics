#!/usr/bin/env python3
"""Replay the exact finite checks and compile the universal collar core."""

from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "graph.multigraph.cycle_multicover.check"
CLAIM = "C9000019-COLLAR-CORE"
DECLARATIONS = [
    "CollarRootAudit.rational_collar_capture",
    "CollarRootAudit.circuit_genus_balance",
    "CollarRootAudit.circuit_stability_balance",
    "CollarRootAudit.unramified_stability_balance",
    "CollarRootAudit.stable_tree_side_impossible",
]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def replay_jacobian():
    discovery = read_json(HERE / "jacobian_find.json")
    contract = read_json(HERE / "jacobian_contract.json")
    payload = read_json(HERE / "jacobian_payload.json")
    response = read_json(HERE / "jacobian_result.json")
    require(
        OPERATION in {
            entry["operation_id"] for entry in discovery["result"]["matches"]
        },
        "The executed operation was not among the discovered candidates.",
    )
    require(
        contract["result"]["operation"]["operation_id"] == OPERATION,
        "Wrong inspected operation.",
    )
    require(
        response["request"]["operation_id"] == OPERATION
        and response["result"]["operation_id"] == OPERATION,
        "Wrong executed operation.",
    )
    require(response["request"]["payload"] == payload, "Payload binding failed.")
    for record in (discovery, contract, response):
        require(record["server"]["version"] == "0.14.0", "Server version changed.")
        require(
            record["protocol_version"] == "2025-11-25",
            "Protocol version changed.",
        )
        require(record["transport"] == "mcp-stdio", "Wrong adapter transport.")
        require(not record.get("error"), "Adapter returned an error, not evidence.")
    result = response["result"]["output"]
    for key in ("graph", "cycles", "target_multiplicity"):
        require(result[key] == payload[key], f"Output binding failed: {key}.")
    graph = payload["graph"]
    require(graph["vertex_count"] == 2, "This example has exactly two sides.")
    edges = {
        row["edge_id"]: frozenset((row["left"], row["right"]))
        for row in graph["edges"]
    }
    require(len(edges) == len(graph["edges"]) == 3, "Duplicate or missing edge.")
    require(all(pair == frozenset((0, 1)) for pair in edges.values()),
            "Expected three distinct parallel edges.")
    counts = Counter({edge_id: 0 for edge_id in edges})
    validity = []
    for cycle in payload["cycles"]:
        vertices, edge_ids = cycle["vertices"], cycle["edge_ids"]
        valid = (
            len(vertices) == len(edge_ids) + 1
            and len(edge_ids) >= 2
            and vertices[0] == vertices[-1]
            and len(set(vertices[:-1])) == len(vertices) - 1
            and len(set(edge_ids)) == len(edge_ids)
        )
        for index, edge_id in enumerate(edge_ids):
            valid = valid and edge_id in edges and edges[edge_id] == frozenset(
                (vertices[index], vertices[index + 1])
            )
        require(valid, "A purported cycle fails incidence or simplicity.")
        validity.append(valid)
        counts.update(edge_ids)
    target = payload["target_multiplicity"]
    require(all(count == target == 2 for count in counts.values()),
            "Cycle multiplicity is not exactly two.")
    require(result["cycle_validity"] == validity, "Cycle validity disagrees.")
    require(dict(result["edge_multiplicity"]) == dict(counts),
            "Typed multiplicities disagree with independent replay.")
    require(result["missing_edge_ids"] == result["overcovered_edge_ids"] == [],
            "Typed output has missing or overcovered edges.")
    require(result["is_exact_k_cover"] is True, "Typed output is a non-conclusion.")
    deletion_connected = {}
    for deleted in edges:
        seen = {0}
        pending = [0]
        while pending:
            vertex = pending.pop()
            for edge_id, pair in edges.items():
                if edge_id != deleted and vertex in pair:
                    for neighbor in pair - seen:
                        seen.add(neighbor)
                        pending.append(neighbor)
        deletion_connected[deleted] = len(seen) == graph["vertex_count"]
    require(all(deletion_connected.values()), "Some lifted bridge is separating.")
    return {
        "operation_id": OPERATION,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_status": "success",
        "adapter_error": None,
        "adapter_timeout": False,
        "runtime_ms": response["result"]["runtime_ms"],
        "payload": "research/collar_root_audit/jacobian_payload.json",
        "typed_output": "research/collar_root_audit/jacobian_result.json",
        "scope": "one exact ell=3 multigraph, not a universal lifting theorem",
        "edge_multiplicity": dict(counts),
        "connected_after_each_edge_deletion": deletion_connected,
    }


def multiply_truncated(left, right, order):
    out = [Fraction(0) for _ in range(order)]
    for i, first in enumerate(left):
        for j, second in enumerate(right[:order - i]):
            out[i + j] += first * second
    return out


def replay_exact_arithmetic():
    order = 13
    denominator_checks = 0
    for ell in (3, 5, 7):
        coefficients = [Fraction(1)]
        for j in range(1, order):
            coefficients.append(
                coefficients[-1] * (Fraction(1, ell) - (j - 1)) / j
            )
        power = [Fraction(1)] + [Fraction(0) for _ in range(order - 1)]
        for _ in range(ell):
            power = multiply_truncated(power, coefficients, order)
        require(power == [Fraction(1), Fraction(1)] + [Fraction(0)] * 11,
                "The truncated binomial identity failed.")
        for p in (2, 3, 5, 7):
            if p != ell:
                require(all(c.denominator % p != 0 for c in coefficients),
                        "A tame binomial coefficient is not p-integral.")
                denominator_checks += 1
        require(coefficients[1].denominator % ell == 0,
                "The wild-order negative control failed.")
        for winding in (-7, -1, 0, 1, 7):
            for orientation in (-ell, ell):
                require((winding * orientation) % ell == 0,
                        "A signed pulled-back Laurent slope is not divisible.")
    ell = 3
    require(2 * 1 - 2 == ell * (2 * 1 - 2),
            "The elliptic residue precover violates Riemann--Hurwitz.")
    require(2 * 1 - 2 + 3 == ell * (2 * 1 - 2 + 1),
            "The bridge precover violates stability scaling.")
    precover_genus = 3 - 2 + 1 + 1 + 1
    require(precover_genus == ell * (2 - 1) + 1 == 4,
            "The whole bridge precover has the wrong genus.")
    circuit_genus, circuit_valence = ell, 2 + ell * (3 - 2)
    require(2 * circuit_genus - 2 == ell * (2 * 1 - 2) + 2 * (ell - 1),
            "Circuit ramification has the wrong sign.")
    require(2 * circuit_genus - 2 + circuit_valence == ell * (2 * 1 - 2 + 3),
            "Circuit stability has the wrong multiplicity.")
    circuit_lift_genus = (2 + ell) - 2 + 1 + 2 * circuit_genus
    require(circuit_lift_genus == ell * (precover_genus - 1) + 1 == 10,
            "The whole circuit lift has the wrong genus.")
    inner, outer = Fraction(1, 5**2), Fraction(1, 5)
    require(0 < inner < outer, "Valuation endpoints were not reversed for radii.")
    return {
        "bridge_example": {
            "ell": ell,
            "base_genus": 2,
            "unramified_precover_genus": precover_genus,
            "one_circuit_lift_genus": circuit_lift_genus,
            "scope": "explicit genus and local ramification checks only",
        },
        "binomial_checks": {
            "orders": [3, 5, 7],
            "coefficient_degrees": [0, order - 1],
            "identity_modulo": "z^13",
            "prime_to_order_integrality_pairs": denominator_checks,
            "wild_order_first_coefficient_nonintegral": True,
            "scope": "finite controls; convergence is proved in report.md",
        },
        "signed_laurent_windings": [-7, -1, 0, 1, 7],
        "radius_order_control": {
            "p": 5,
            "valuation_interval": ["1", "2"],
            "radius_interval": [str(inner), str(outer)],
        },
    }


def run_module(module, arguments):
    return subprocess.run(
        [ARGUS_PYTHON, "-m", module, *arguments],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=115,
        check=False,
    )


def compile_and_check():
    compiled = run_module(
        "argus_skill.verticals.math.lean_evidence",
        [
            "verify", str(HERE / "Main.lean"),
            "--statement-fidelity", str(HERE / "statement_fidelity.md"),
            "--claim", CLAIM,
            "--project-root", str(ROOT),
            "--timeout", "90",
        ],
    )
    (HERE / "lean_verification.json").write_text(compiled.stdout, encoding="utf-8")
    state = run_module(
        "argus_skill.verticals.math.math_state",
        ["check", "--project-root", str(ROOT)],
    )
    graph = run_module(
        "argus_skill.verticals.math.proof_graph_check",
        ["check", "--project-root", str(ROOT)],
    )
    for name, process in (("Lean", compiled), ("math_state", state),
                          ("proof_graph", graph)):
        require(
            process.returncode == 0,
            f"{name} exited {process.returncode}:\n"
            f"{process.stdout[-6000:]}\n{process.stderr[-3000:]}",
        )
    result = json.loads(compiled.stdout)
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The compiler did not succeed.")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "The actual Lean axiom audit did not pass.")
    require(result["environment_failure"] == "", "Lean was environmentally unverified.")
    require("Lean (version 4.31.0," in result["tools"]["lean"]["version"],
            "The compiler is not the required Lean 4.31.0.")
    require(result["kernel"]["recorded"] is not None, "No mechanical evidence was recorded.")
    require(result["kernel"]["refusals"] == [], "Mechanical recording was refused.")
    source = (HERE / "Main.lean").read_text(encoding="utf-8")
    fidelity = (HERE / "statement_fidelity.md").read_text(encoding="utf-8")
    require(hashlib.sha256(source.encode()).hexdigest() == result["source_sha256"],
            "The source changed after compilation.")
    require(hashlib.sha256(fidelity.encode()).hexdigest()
            == result["statement_fidelity_sha256"],
            "The statement-fidelity document changed after compilation.")
    artifact = result["kernel"]["recorded"]["artifact"]
    archive = read_json(ROOT / artifact)
    require(archive["lean_source"]["text"] == source,
            "The archived source is not the compiled source.")
    require(archive["statement_fidelity"]["text"] == fidelity,
            "The archived fidelity document is not the current reading.")
    require(archive["lean_check"]["exit_code"] == 0
            and archive["lean_check"]["proof_holes"] == [],
            "The archived compiler result does not certify this source.")
    require(json.loads(state.stdout) == {"ok": True, "issues": []},
            "The campaign ledger has structural issues.")
    return {
        "claim_id": CLAIM,
        "declarations": DECLARATIONS,
        "lean_version": "4.31.0",
        "exit_code": result["exit_code"],
        "audit_exit_code": result["audit_exit_code"],
        "proof_holes": result["proof_holes"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "archived_certificate": artifact,
        "scope": "universal compact rational-value exclusion and exact integer arithmetic",
    }, {
        "project_root": str(ROOT),
        "math_state_exit_code": state.returncode,
        "proof_graph_exit_code": graph.returncode,
    }


def main():
    jacobian = replay_jacobian()
    arithmetic = replay_exact_arithmetic()
    core, checks = compile_and_check()
    certificate = {
        "claim_id": "C9000019-COLLARS",
        "result_class": "verification_theorem",
        "conclusion": (
            "The exact all-sheet collar-root lemma follows by the proof in report.md "
            "from the identified external analytic and algebraic inputs."
        ),
        "universal_machine_checked_core": core,
        "finite_jacobian_replay": jacobian,
        "exact_finite_controls": arithmetic,
        "external_inputs_not_formalized": [
            "MT-RNS-DOMINATION",
            "ABBR-TAME-LIFT",
            "MILNE-DIVISIBILITY-TORSION",
            "BPR-ANNULAR-FACTORIZATION",
            "ABBR-TUBES-REDUCTION",
            "TEMKIN-COMPACT-TYPE2",
        ],
        "full_analytic_lemma_formalized": False,
        "primary_source_attributions": "read by Engineer; independent attribution pending",
        "independent_review": {"status": "pending", "verdict": None},
        "novelty_status": "not_claimed",
        "significance_status": "not_assessed",
        "campaign_complete": False,
        "official_checks": checks,
    }
    target = HERE / "exact_certificate.json"
    target.write_text(json.dumps(certificate, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "certificate": str(target.relative_to(ROOT)),
        "universal_core_lean_exit_code": core["exit_code"],
        "proof_holes": core["proof_holes"],
        "finite_jacobian_replay": "passed",
        "official_checks": checks,
        "independent_review": "pending",
        "campaign_complete": False,
    }, indent=2))


if __name__ == "__main__":
    main()
