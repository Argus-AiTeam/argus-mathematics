#!/usr/bin/env python3
"""Replay exact diagnostics, the universal Lean proof, and campaign-local gates."""

import itertools
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
Z = sp.Symbol("z", real=True)


def expected_polynomial(matrix, weights, coloring, r, t, variables, forced=None):
    n = matrix.rows
    laws = []
    for v in range(n):
        colors = [coloring[v]] if coloring[v] else range(1, r + 1)
        if forced is not None and forced[0] == v:
            colors = [forced[1]]
        laws.append(list(itertools.product(colors, (1, -1))))
    total = sp.Integer(0)
    count = 0
    for outcome in itertools.product(*laws):
        shifted = sp.zeros(n)
        for u in range(n):
            shifted[u, u] = -(80 if coloring[u] else 1) * t * weights[u]
            for v in range(u):
                if outcome[u] == outcome[v]:
                    shifted[u, v] = (
                        outcome[u][1] * sp.sqrt(weights[u] * weights[v]) * matrix[u, v]
                    )
                    shifted[v, u] = shifted[u, v]
        total += (sp.diag(*variables) - shifted).det()
        count += 1
    return sp.expand(total / count)


def exact_coloring_checks():
    fixtures = [
        (
            sp.Matrix([[0, sp.Rational(1, 2)], [sp.Rational(1, 2), 0]]),
            [sp.Integer(1), sp.Integer(1)],
            [0, 0],
            sp.Rational(1, 8),
        ),
        (
            sp.Matrix(
                [
                    [0, sp.Rational(1, 3), sp.Rational(1, 4)],
                    [sp.Rational(1, 3), 0, -sp.Rational(1, 5)],
                    [sp.Rational(1, 4), -sp.Rational(1, 5), 0],
                ]
            ),
            [sp.Integer(1), sp.Integer(4), sp.Rational(1, 4)],
            [0, 1, 0],
            sp.Rational(1, 10),
        ),
    ]
    results = []
    for matrix, weights, coloring, t in fixtures:
        n = matrix.rows
        assert matrix == matrix.T and all(matrix[i, i] == 0 for i in range(n))
        assert all(w > 0 for w in weights) and t > 0 and coloring[0] == 0
        for sign in (-1, 1):
            contraction_test = sp.eye(n) + sign * matrix
            for size in range(1, n + 1):
                for subset in itertools.combinations(range(n), size):
                    assert contraction_test.extract(subset, subset).det() >= 0
        variables = sp.symbols(f"x0:{n}")
        multivariate = expected_polynomial(matrix, weights, coloring, 2, t, variables)
        substitution = dict.fromkeys(variables, Z)
        old = sp.expand(multivariate.subs(substitution))
        deleted = expected_polynomial(
            matrix[1:, 1:], weights[1:], coloring[1:], 2, t, [Z] * (n - 1)
        )
        assert sp.expand(sp.diff(multivariate, variables[0]).subs(substitution) - deleted) == 0
        conditioned = []
        permanent = []
        for color in (1, 2):
            conditional = expected_polynomial(
                matrix, weights, coloring, 2, t, [Z] * n, forced=(0, color)
            )
            assigned = list(coloring)
            assigned[0] = color
            option = expected_polynomial(matrix, weights, assigned, 2, t, [Z] * n)
            assert sp.expand(option - conditional - 79 * t * weights[0] * deleted) == 0
            conditioned.append(conditional)
            permanent.append(option)
        assert sp.expand(sum(conditioned) / 2 - old) == 0
        for polynomial in [old, deleted, *conditioned, *permanent]:
            exact = sp.Poly(polynomial, Z, domain=sp.QQ)
            assert sum(m for _, m in exact.intervals()) == exact.degree()
        results.append(
            {
                "dimension": n,
                "old_polynomial": str(old),
                "deletion_polynomial": str(deleted),
                "permanent_polynomials": [str(p) for p in permanent],
                "all_input_hypotheses_checked": True,
                "conditioning_and_diagonal_shift_identities": True,
                "classification": "exact_normalization_fixture_not_a_universal_proof",
            }
        )
    old = sp.Poly(Z**2 + Z / 4 - sp.Rational(3, 64), Z)
    deleted = Z + sp.Rational(1, 8)
    positive_root = sp.Rational(1, 8)
    rooted_weight = sp.cancel(deleted.subs(Z, positive_root) / old.diff().eval(positive_root))
    assert rooted_weight == sp.Rational(1, 2)
    assert rooted_weight * positive_root == sp.Rational(1, 16)
    for polynomial in results[0]["permanent_polynomials"]:
        intervals = sp.Poly(sp.sympify(polynomial, locals={"z": Z}), Z).intervals(
            eps=sp.Rational(1, 1000000)
        )
        assert all(upper < 0 for ((_, upper), _) in intervals)
    results[0]["rooted_positive_mass"] = "1/16"
    results[0]["deletion_increment"] = "1/8"
    results[0]["permanent_deletion_increments"] = ["0", "0"]
    return results


def exact_jacobian_replay():
    status = json.loads((HERE / "jacobian_status.json").read_text())
    assert status["operation_id"] == "matrix.inertia.compute"
    assert status["adapter_exit_code"] == 0
    payload = json.loads((ROOT / status["payload"]).read_text())
    result = json.loads((ROOT / status["output"]).read_text())
    assert result["server"]["version"] == "0.14.0"
    assert result["protocol_version"] == "2025-11-25"
    assert result["result"]["operation_id"] == status["operation_id"]
    assert result["request"]["payload"] == payload
    output = result["result"]["output"]
    exact = sp.zeros(payload["dimension"])
    for entry in payload["entries"]:
        u, v = entry["row"], entry["col"]
        value = sp.Rational(entry["value"]["num"], entry["value"]["den"])
        exact[u, v] = exact[v, u] = value
    dense = sp.Matrix(
        [
            [sp.Rational(value["num"], value["den"]) for value in row]
            for row in output["matrix"]["entries"]
        ]
    )
    assert exact == dense
    intervals = exact.charpoly(Z).as_poly().intervals(eps=sp.Rational(1, 1000000))
    counts = {"n_positive": 0, "n_negative": 0, "n_zero": 0}
    for (lower, upper), multiplicity in intervals:
        if lower > 0:
            counts["n_positive"] += multiplicity
        elif upper < 0:
            counts["n_negative"] += multiplicity
        else:
            assert lower == upper == 0
            counts["n_zero"] += multiplicity
    assert all(output[key] == value for key, value in counts.items())
    assert counts == {"n_positive": 2, "n_negative": 1, "n_zero": 0}
    rejected_status = json.loads((HERE / "jacobian_rejected_status.json").read_text())
    rejected = json.loads((ROOT / rejected_status["output"]).read_text())
    assert rejected_status["adapter_exit_code"] == 2
    assert rejected["error"]["data"]["code"] == "INVALID_REQUEST"
    return {
        "operation_id": status["operation_id"],
        "adapter_exit_code": 0,
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "inertia": counts,
        "exact_characteristic_polynomial": str(exact.charpoly(Z).as_expr()),
        "rejected_request_retained_as_nonconclusion": True,
        "classification": "exact_finite_diagnostic_not_a_universal_proof",
    }


def symbolic_assembly():
    m, a, ep, en, epsilon, beta = sp.symbols("m a ep en epsilon beta", real=True)
    D, B = 8 * m + 4 * a, 12 * m + 8 * a
    assert sp.expand(D + B - beta * a - (20 * m + (12 - beta) * a)) == 0
    assert sp.cancel(2 * (m + (m + a)) * ep / D - ep / 2) == 0
    assert sp.expand(2 * (m + a) + 2 * ((m + a) + m) - (6 * m + 4 * a)) == 0
    assert sp.expand((4 * m + ep) + (en + epsilon) + 20 * m - (m + ep + en)) == 23 * m + epsilon
    return {
        "positive_side_buffer": "8m+4a",
        "negative_side_buffer": "12m+8a",
        "total_buffer": "20m+12a",
        "cost_before_finite_epsilon_removal": "23m+epsilon",
    }


def run_module(module, arguments):
    command = [PYTHON, "-m", module, *arguments]
    outcome = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
    if outcome.returncode:
        raise RuntimeError(
            f"Command failed with exit {outcome.returncode}: {command}\n"
            f"{outcome.stdout}\n{outcome.stderr}"
        )
    return outcome


def validate_lean_result(mechanical):
    assert mechanical["status"] == "success"
    assert "version 4.31.0," in mechanical["tools"]["lean"]["version"]
    assert mechanical["exit_code"] == 0 and mechanical["proof_holes"] == []
    assert mechanical["audit_exit_code"] == 0
    assert Path(mechanical["source"]).resolve() == HERE / "Main.lean"
    assert mechanical["kernel"]["refusals"] == []
    recorded = mechanical["kernel"]["recorded"]
    assert recorded is not None and recorded["tier"] == "mechanical"
    assert (ROOT / recorded["artifact"]).is_file()
    return recorded


def main():
    certificate_path = HERE / "exact_certificate.json"
    certificate = json.loads(certificate_path.read_text())
    assert certificate["claim_id"] == "C_PINNING_UNIVERSAL"
    assert certificate["principal_declaration"] == "WeightedPinning.weighted_pinning_split"
    assert certificate["manuscript_corollary"] == "WeightedPinning.manuscript_arrow_assignment"
    fixtures = exact_coloring_checks()
    jacobian = exact_jacobian_replay()
    assembly = symbolic_assembly()
    compiled = run_module(
        "argus_skill.verticals.math.lean_evidence",
        [
            "verify",
            "research/pinning/Main.lean",
            "--statement-fidelity",
            "research/pinning/statement_fidelity.md",
            "--artifact-dir",
            "research/pinning",
            "--project-root",
            str(ROOT),
            "--claim",
            certificate["claim_id"],
            "--timeout",
            "120",
        ],
    )
    (HERE / "lean_verification.json").write_text(compiled.stdout)
    mechanical = json.loads(compiled.stdout)
    recorded = validate_lean_result(mechanical)
    checks = {}
    for module, name in [
        ("argus_skill.verticals.math.math_state", "math_state"),
        ("argus_skill.verticals.math.proof_graph_check", "proof_graph"),
    ]:
        checked = run_module(module, ["check", "--project-root", str(ROOT)])
        checks[name] = {"exit_code": checked.returncode, "output": checked.stdout.strip()}
    certificate.update(
        {
            "status": "universal_lean_kernel_verification_replayed",
            "official_compiler": {
                "command": "lean_evidence verify --claim C_PINNING_UNIVERSAL",
                "exit_code": mechanical["exit_code"],
                "proof_holes": mechanical["proof_holes"],
                "archived_certificate": recorded["artifact"],
                "compiler_result": "research/pinning/lean_verification.json",
                "statement_fidelity_independently_reviewed": False,
            },
            "project_root": str(ROOT),
            "campaign_local_checks": checks,
            "exact_coloring_fixtures": fixtures,
            "jacobian_replay": jacobian,
            "symbolic_assembly": assembly,
        }
    )
    certificate_path.write_text(json.dumps(certificate, indent=2) + "\n")
    for role in ("engineer", "planner"):
        path = ROOT / "roles" / role / "progress.json"
        progress = json.loads(path.read_text())
        progress.update(
            {
                "status": "ready_for_review",
                "stage": "certify",
                "next_owner": "reviewer",
                "current_result": "Universal arrow pinning proved for beta>=12 with cost 23m; beta=80, 24m manuscript corollary also proved. Independent review remains required.",
                "validation": {
                    "project_root": str(ROOT),
                    "math_state_exit_code": checks["math_state"]["exit_code"],
                    "proof_graph_exit_code": checks["proof_graph"]["exit_code"],
                    "lean_exit_code": 0,
                    "proof_holes": [],
                },
                "artifact": "research/pinning/exact_certificate.json",
            }
        )
        path.write_text(json.dumps(progress, indent=2) + "\n")
    action = {
        "ts": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "role": "engineer",
        "agent": "gpt-6.1-sol",
        "kind": "verification",
        "action": "Replayed exact coloring normalization and typed inertia diagnostics, compiled the universal beta>=12, 23m theorem and manuscript corollary through claim-bound Lean evidence, and passed both campaign-local gates. Host independent review is pending.",
        "status": "ready_for_review",
        "artifact": "research/pinning/exact_certificate.json",
    }
    with (ROOT / "activity.jsonl").open("a") as stream:
        stream.write(json.dumps(action) + "\n")
    print(
        json.dumps(
            {
                "status": certificate["status"],
                "claim": certificate["claim_id"],
                "lean_exit_code": 0,
                "proof_holes": [],
                "project_root": str(ROOT),
                "math_state_exit_code": 0,
                "proof_graph_exit_code": 0,
                "independent_review": "pending_host_invocation",
            }
        )
    )


if __name__ == "__main__":
    main()
