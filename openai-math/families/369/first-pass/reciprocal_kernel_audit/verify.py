#!/usr/bin/env python3
"""Replay exact algebra and the universal Lean core; do not certify prose."""

import json
import subprocess
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def symbolic_identities():
    x1, x2, y1, y2 = sp.symbols("x1 x2 y1 y2", real=True)
    h, r, a, c, u, m, iz, zj, w = sp.symbols("h r a c u m iz zj w")
    xx, yy = x1**2 + x2**2, y1**2 + y2**2
    distance = (x1 - y1) ** 2 + (x2 - y2) ** 2
    k = 1 / (1 + h)
    H = iz * zj / m
    identities = {
        "lorentz_normalization": distance
        + (1 - xx) * (1 - yy) / 2
        - ((1 + xx) * (1 + yy) / 2 - 2 * (x1 * y1 + x2 * y2)),
        "mixture_division": h * (h + 1) / (h + r)
        - (h + 1 - r - r * (1 - r) / (h + r)),
        "schur_geometric_ratio": 1 / (h + r) - k / (1 - (1 - r) * k),
        "reciprocal_column_normalization": iz * zj / (m + c * iz * zj)
        - H / (1 + c * H),
        "update_defect": a / (1 + c * a)
        - (a - u) / (1 + c * (a - u))
        - u / ((1 + c * a) * (1 + c * a - c * u)),
        "schur_series_sum": u / (1 + c * a) ** 2
        / (1 - c * u / (1 + c * a))
        - u / ((1 + c * a) * (1 + c * a - c * u)),
        "elimination_coefficient": w / (1 - w * a)
        - 1 / (1 / w - a),
        "one_sided_radial_factor": (1 - r**2) / (1 - r) - (1 + r),
        "two_sided_radial_factor": (1 - r**2) ** 2 / (r**2 * (1 - r) ** 2)
        - (1 + r) ** 2 / r**2,
        "logarithm_chord_majorant": (3 - u) / 2
        - 1 / u
        - (u - 1) * (2 - u) / (2 * u),
    }
    for name, expression in identities.items():
        require(sp.cancel(expression) == 0, f"Symbolic identity failed: {name}")
    require(sp.integrate((3 - u) / 2, (u, 1, 2)) == sp.Rational(3, 4),
            "The exact logarithm chord integral failed")
    require(sp.limit((1 + r) ** 2 / r**2, r, 1) == 4,
            "The two-sided radial factor is not 4")
    return list(identities)


def exact_update(certificate):
    points = [Fraction(0), Fraction(1, 2), Fraction(-1, 2)]
    M = [
        [
            1 / ((x - y) ** 2 / ((1 - x**2) * (1 - y**2)) + Fraction(1, 2))
            for y in points
        ]
        for x in points
    ]
    w = Fraction(1, 12)
    c = w / (1 - w * M[0][0])
    require(c == Fraction(1, 10), "Wrong exact elimination coefficient")
    A = [[1 / (M[i][j] + c * M[i][0] * M[0][j]) for j in range(3)]
         for i in range(3)]
    expected = [[Fraction(x) for x in row]
                for row in certificate["rational_update"]["reciprocal_matrix"]]
    require(A == expected, "The certificate is not the reconstructed update")

    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    reconstructed = [[Fraction(0) for _ in range(3)] for _ in range(3)]
    require(payload["dimension"] == 3, "Unexpected Jacobian dimension")
    for entry in payload["entries"]:
        i, j = entry["row"], entry["col"]
        value = Fraction(entry["value"]["num"]) / Fraction(entry["value"]["den"])
        reconstructed[i][j] = reconstructed[j][i] = value
    require(reconstructed == A, "Jacobian input differs from the exact update")

    d0 = A[0][0]
    l10, l20 = A[1][0] / d0, A[2][0] / d0
    d1 = A[1][1] - l10**2 * d0
    l21 = (A[2][1] - l20 * l10 * d0) / d1
    d2 = A[2][2] - l20**2 * d0 - l21**2 * d1
    L = [[Fraction(1), Fraction(0), Fraction(0)],
         [l10, Fraction(1), Fraction(0)],
         [l20, l21, Fraction(1)]]
    diagonal = [d0, d1, d2]
    require(
        all(sum(L[i][k] * diagonal[k] * L[j][k] for k in range(3)) == A[i][j]
            for i in range(3) for j in range(3)),
        "Exact LDL congruence failed",
    )
    inertia = {
        "n_positive": sum(x > 0 for x in diagonal),
        "n_negative": sum(x < 0 for x in diagonal),
        "n_zero": sum(x == 0 for x in diagonal),
    }
    require(inertia == {"n_positive": 1, "n_negative": 2, "n_zero": 0},
            "The corroborating matrix has unexpected inertia")

    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0 and status["timeout"] is False,
            "The Jacobian adapter did not complete successfully")
    response = json.loads((HERE / "jacobian_output.json").read_text())
    require(response["request"]["operation_id"] == "matrix.inertia.compute",
            "Wrong Jacobian operation")
    require(response["request"]["payload"] == payload, "Payload was not preserved")
    require(response["server"]["version"] == "0.14.0", "Unexpected server version")
    require(response["protocol_version"] == "2025-11-25", "Unexpected protocol")
    result = response["result"]["output"]
    returned = [[Fraction(v["num"]) / Fraction(v["den"]) for v in row]
                for row in result["matrix"]["entries"]]
    require(returned == A and result["definiteness"] == "indefinite",
            "The typed output does not describe the reconstructed matrix")
    require(all(result[name] == value for name, value in inertia.items()),
            "The typed inertia disagrees with exact LDL")
    return {"inertia": inertia, "ldl_diagonal": [str(x) for x in diagonal],
            "scope": "one corroborating example, not the universal proof"}


def fresh_lean():
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "lean/Main.lean"), "--statement-fidelity",
        str(HERE / "lean/statement_fidelity.md"), "--claim", "C_RK_SCHUR",
        "--project-root", str(ROOT),
    ]
    completed = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    (HERE / "lean/verification_output.json").write_text(completed.stdout)
    require(completed.returncode == 0,
            f"Official Lean verification failed:\n{completed.stdout}\n{completed.stderr}")
    result = json.loads(completed.stdout)
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean did not establish the formal statement")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean has proof holes or an unsuccessful axiom audit")
    recorded = result["kernel"]["recorded"]
    require(recorded is not None and recorded["verdict"] == "supports",
            "No mechanical evidence was recorded on C_RK_SCHUR")
    require(recorded["produced_by"] == "lean_evidence/lean 4.31.0",
            "The required Lean 4.31.0 kernel was not used")
    return {"exit_code": 0, "proof_holes": [], "certificate": recorded["artifact"],
            "claim": "C_RK_SCHUR", "scope": "universal Schur-resolvent core only"}


def local_checks():
    statuses = {}
    failures = []
    for module in ("math_state", "proof_graph_check"):
        command = [
            ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check",
            "--project-root", str(ROOT),
        ]
        completed = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
        statuses[module] = completed.returncode
        if completed.returncode != 0:
            failures.append(f"{module}:\n{completed.stdout}\n{completed.stderr}")
    require(not failures, "Campaign-local validation failed:\n" + "\n".join(failures))
    return statuses


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    require(certificate["claim"] == "C_RK"
            and certificate["extension_claim"] == "C_RK_MEASURE",
            "Unexpected mathematical claim identifiers")
    require(certificate["formal_core"]["claim"] == "C_RK_SCHUR",
            "The analytic theorem is being confused with the formal core")
    identities = symbolic_identities()
    require(identities == certificate["symbolic_identities"],
            "The identity list does not match the certificate")
    rational = exact_update(certificate)
    require((1 + Fraction(3, 2)) / (2 * 3) == Fraction(5, 12) < Fraction(1, 2),
            "The rational consequence of the stated log/pi bounds failed")
    formal = fresh_lean()
    checks = local_checks()
    result = {
        "project_root": str(ROOT),
        "symbolic_identities": len(identities),
        "rational_update": rational,
        "formal_core": formal,
        "official_checks": checks,
        "analytic_theorems": "REPORT.md: universal human-readable proofs A and B",
        "independent_review_performed_by_script": False,
        "full_hot_spots_theorem_certified": False,
    }
    (HERE / "verification_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
