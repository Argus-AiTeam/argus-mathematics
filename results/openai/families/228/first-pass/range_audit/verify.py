#!/usr/bin/env python3
"""Replay exact evidence; the analytic theorem is proved in report.md."""

import itertools
import json
import math
import re
from fractions import Fraction as F
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(path):
    return json.loads(path.read_text())


def verify_scope(certificate):
    require(certificate["claim_id"] == "C_RANGE", "Wrong analytic claim.")
    require(certificate["formal_claim"] == "C_RANGE_CORE", "Wrong formal claim.")
    require(certificate["analytic_proof_machine_checked"] is False,
            "The continuum proof must not be presented as machine checked.")
    require(certificate["finite_experiments_are_universal_proofs"] is False,
            "Finite experiments cannot certify universal pressure statements.")
    require(certificate["continuum_thermodynamics_formalized"] is False,
            "The Lean scope excludes continuum thermodynamics.")
    require(certificate["manuscript_main_theorems_certified"] is False,
            "This is the bounded range audit, not a main-theorem certificate.")
    require(certificate["independent_review"] == "pending_host",
            "This verifier does not manufacture independent review.")
    require(certificate["novelty_status"] == "not_claimed",
            "The verifier does not certify publication priority.")
    require(certificate["refutation_claims"] == [],
            "No literal manuscript assertion was refuted by this certificate.")
    source = (ROOT / certificate["manuscript"]).read_text()
    start = source.index(r"\begin{theorem}[Quantitative approximation")
    stop = source.index(r"\end{theorem}", start)
    theorem = source[start:stop]
    for fragment in (
        r"\label{k:range}",
        r"R_0\ge2",
        "empty, finite, or countably infinite",
        r"a>0",
        r"\sum_j\alpha_j+a\le A+1",
        r"\sqrt{\frac{R_0}{R}}",
        "Both constants are independent",
    ):
        require(fragment in theorem, f"Literal theorem mismatch: {fragment}")
    require((HERE / certificate["analytic_proof"]).is_file(),
            "The standalone analytic proof is missing.")


def verify_symbolic(certificate):
    beta, a, eta, d, u, D, c, qb, qs, delta = sp.symbols(
        "beta a eta d u D c qb qs delta", real=True)
    D0, M, n, G = sp.symbols("D0 M n G", positive=True)
    identities = {
        "ideal_square_completion":
            beta * a * u * d - beta * a * u**2 / 2
            - (beta * a * d**2 / 2 - beta * a * (u - d)**2 / 2),
        "arbitrary_density_square":
            -u * d + (1 - eta) * d**2 / 2
            - (-u**2 / 2 + (d - u)**2 / 2 - eta * d**2 / 2),
        "full_lower_transfer":
            qb + c * (-u * d + (1 - eta) * d**2 / 2) - delta
            - (qs - c * u**2 / 2 - 2 * delta - c * eta * D**2 / 2)
            - (qb - qs + delta + c * (d - u)**2 / 2
               + c * eta * (D**2 - d**2) / 2),
        "upper_field_shift":
            beta * a * (1 + eta) * d**2 / 2 - beta * a * d**2
            - (-beta * a * d**2 / 2 + beta * a * eta * d**2 / 2),
        "conditional_young":
            D0 * n**2 / 4 + G**2 / D0 - n * G
            - (D0 * n / 2 - G)**2 / D0,
        "moment_finiteness_margin":
            3 * D0 / 4 - M / 2 - 11 * D0 / 16 - (D0 - 8 * M) / 16,
        "conditional_moment_margin":
            D0 / 2 - M / 2 - 7 * D0 / 16 - (D0 - 8 * M) / 16,
        "bootstrap_exponent_margin":
            D0**2 - 64 * M**2 - (D0 - 8 * M) * (D0 + 8 * M),
    }
    x = sp.symbols("x0:3", real=True)
    r = sp.symbols("r", real=True)
    k = {}
    for i in range(3):
        for j in range(i, 3):
            k[i, j] = k[j, i] = sp.Symbol(f"k{i}{j}", real=True)
    quadratic = sum(k[i, j] * x[i] * x[j]
                    for i in range(3) for j in range(3))
    sos = sum((r - sum(k[i, j] for j in range(3))) * x[i]**2
              for i in range(3))
    sos += sum(k[i, j] * (x[i] - x[j])**2
               for i in range(3) for j in range(i + 1, 3))
    identities["symmetric_kernel_sum_of_squares"] = (
        r * sum(v**2 for v in x) - quadratic - sos)
    require(list(identities) == certificate["symbolic_identities"],
            "The exact symbolic obligations differ from the certificate.")
    for name, difference in identities.items():
        require(sp.cancel(sp.expand(difference)) == 0,
                f"False exact identity: {name}")
    return len(identities)


def verify_finite_stress_tests():
    density_tests = 0
    for c, eta, u, d in itertools.product(
        [F(0), F(1, 10), F(1), F(7), F(1, 2**128)],
        [F(0), F(1, 8), F(1)],
        [F(0), F(1, 3), F(1), F(7, 3)],
        [F(0), F(1, 5), F(1), F(11, 2)],
    ):
        lower = c * (-u * d + (1 - eta) * d*d / 2)
        target = c * (-u*u / 2 - eta * F(6)**2 / 2)
        require(lower >= target, "Arbitrary-density lower stress test failed.")
        density_tests += 1

    coexistence_tests = 0
    for a in [F(1), F(1, 10), F(1, 2**128)]:
        h = -a / 2
        slopes, offsets = [F(0), F(1), F(4)], [F(0), F(0), F(-9)]
        values = [d*h + b + a*d*d/2 for d, b in zip(slopes, offsets)]
        require(values[0] == values[1] == 0 and values[2] < 0,
                "The exact coexistence model has the wrong active branches.")
        for u in [F(0), F(1)]:
            shifted_pressure = max(d*(h + a*u) + b
                                   for d, b in zip(slopes, offsets))
            require(shifted_pressure - a*u*u/2 == 0,
                    "The claimed shift is not actually active.")
        coexistence_tests += 1

    signed_tests = 0
    for core, attraction in itertools.product(
        [F(0), F(1, 3), F(1), F(5)], repeat=2
    ):
        require(abs(core - attraction) <= core + attraction,
                "The absolute signed-deletion majorant failed.")
        signed_tests += 1

    factorial_tests = 0
    for boxes in range(1, 5):
        for total in range(8):
            for counts in itertools.product(range(total + 1), repeat=boxes):
                if sum(counts) != total:
                    continue
                denominator = math.prod(math.factorial(n) for n in counts)
                labels = math.factorial(total) // denominator
                require(labels * denominator == math.factorial(total),
                        "A label assignment count is not integral.")
                require(F(labels, math.factorial(total)) == F(1, denominator),
                        "Global and box factorials do not cancel.")
                factorial_tests += 1

    rounding_tests = 0
    b = F(1, 4)
    for R0, p in itertools.product(
        [F(2), F(17, 8), F(3), F(7)],
        [F(2), F(9, 4), F(3), F(13, 2), F(16)],
    ):
        R = R0 * p*p
        unrounded = R0 * p
        s = b * (unrounded // b)
        require(R0 <= s <= R, "The rounded side is not admissible.")
        require(unrounded / 2 <= s <= unrounded, "Rounding lost a factor two.")
        require(R0 / s + s / R <= 3 / p, "The balanced ratio bound failed.")
        rounding_tests += 1

    crossover_tests = 0
    sharp_rounding_tests = 0
    for p, m in itertools.product(
        [F(4), F(8), F(16)],
        [F(1, 4), F(1, 2), F(1), F(3, 2), F(2), F(3), F(5)],
    ):
        epsilon, a = 1 / (p*p), m*m / (p*p)
        root = m / (p*p)
        require(root*root == a*epsilon, "The crossover root is not exact.")
        worst_error = min(a, root) if a >= 9*epsilon else a
        require(worst_error <= 3 * min(a, root),
                "The small-mass regime combination failed.")
        crossover_tests += 1
        if a >= 9*epsilon:
            for R0 in [F(2), F(17, 8), F(3), F(7)]:
                R = R0 * p*p
                unrounded = R0 * p*p / m
                s = b * (unrounded // b)
                require(R0 <= s <= R and 3*s/R <= 1,
                        "The mass-adapted side fails its kernel condition.")
                require(R0/s <= 2*root and a*s/R <= root,
                        "The mass-adapted error bound failed.")
                sharp_rounding_tests += 1
    return {
        "arbitrary_density_instances": density_tests,
        "exact_coexistence_instances": coexistence_tests,
        "signed_majorant_instances": signed_tests,
        "factorial_cancellations": factorial_tests,
        "rounded_scale_instances": rounding_tests,
        "mass_crossover_instances": crossover_tests,
        "mass_adapted_scale_instances": sharp_rounding_tests,
    }


def verify_jacobian(certificate):
    info = certificate["jacobian"]
    payload = read_json(HERE / info["payload"])
    result = read_json(HERE / info["typed_output"])
    status = read_json(HERE / info["adapter_status"])
    require(status["adapter_exit_code"] == 0 and status["timeout"] is False,
            "The accepted adapter run did not succeed.")
    require(result["protocol_version"] == info["protocol_version"],
            "Jacobian protocol mismatch.")
    require(result["server"]["version"] == info["server_version"],
            "Jacobian server version mismatch.")
    require(result["request"]["operation_id"] == info["operation_id"],
            "Wrong Jacobian operation.")
    require(result["request"]["payload"] == payload,
            "The typed result is not bound to the exact payload.")
    require(payload["dimension"] == 3, "Wrong finite kernel dimension.")
    matrix = sp.zeros(3)
    for entry in payload["entries"]:
        i, j = entry["row"], entry["col"]
        value = sp.Rational(entry["value"]["num"], entry["value"]["den"])
        matrix[i, j] = matrix[j, i] = value
    points = [sp.Rational(x) for x in certificate["finite_kernel"]["sample_points"]]
    kernel = sp.Matrix([
        [max(0, 1 - (x - y)**2)**2 for y in points] for x in points
    ])
    expected_matrix = sp.diag(*[sum(kernel.row(i)) for i in range(3)]) - kernel
    require(matrix == expected_matrix,
            "The source matrix is not the stated sampled-kernel Laplacian.")
    output = result["result"]["output"]
    typed_matrix = sp.Matrix([
        [sp.Rational(e["num"], e["den"]) for e in row]
        for row in output["matrix"]["entries"]
    ])
    require(typed_matrix == matrix, "Jacobian returned a different source matrix.")
    eigenvalues = sorted(matrix.eigenvals())
    expected_eigenvalues = [
        sp.Rational(x) for x in certificate["finite_kernel"]["laplacian_eigenvalues"]
    ]
    require(eigenvalues == expected_eigenvalues and
            all(multiplicity == 1 for multiplicity in matrix.eigenvals().values()),
            "Independent exact eigenvalue replay failed.")
    inertia = {
        "n_positive": sum(1 for x in eigenvalues if x > 0),
        "n_negative": sum(1 for x in eigenvalues if x < 0),
        "n_zero": sum(1 for x in eigenvalues if x == 0),
    }
    require(inertia == certificate["finite_kernel"]["inertia"],
            "Wrong independently computed inertia.")
    require(all(output[key] == value for key, value in inertia.items()) and
            output["definiteness"] == "positive_semidefinite",
            "The typed inertia does not agree with the exact source matrix.")
    rejected = read_json(HERE / info["rejected_output"])
    rejected_status = read_json(HERE / info["rejected_adapter_status"])
    rejected_payload = read_json(HERE / info["rejected_payload"])
    require(rejected_status["adapter_exit_code"] == 2 and
            rejected["ok"] is False and
            rejected["error"]["data"]["code"] == "INVALID_REQUEST" and
            len(rejected_payload["entries"]) == 7,
            "The initial rejected request was not preserved as a non-conclusion.")
    require(F(4) * F(105, 32) * (F(1, 3) - F(2, 5) + F(1, 7)) == 1,
            "The example radial kernel normalization is wrong.")
    return inertia


def verify_lean(certificate):
    result = read_json(HERE / certificate["formal_compiler_record"])
    require(result["status"] == "success" and result["exit_code"] == 0,
            "There is no successful real Lean compile.")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "The formal source is not certified hole-free.")
    require("version 4.31.0" in result["tools"]["lean"]["version"],
            "Wrong Lean version.")
    require(result["environment_failure"] == "" and
            result["kernel"]["refusals"] == [],
            "Lean evidence was not accepted by the recording command.")
    evidence = result["kernel"]["recorded"]
    require(evidence["subject"]["subject_id"] == certificate["formal_claim"] and
            evidence["tier"] == "mechanical" and evidence["verdict"] == "supports",
            "Compiler evidence is attached to the wrong claim or tier.")
    archived = read_json(ROOT / evidence["artifact"])
    source = (HERE / certificate["formal_source"]).read_text()
    fidelity = (HERE / certificate["statement_fidelity"]).read_text()
    require(archived["lean_source"]["text"] == source,
            "The Lean source changed after its successful compile.")
    require(archived["statement_fidelity"]["text"] == fidelity,
            "The statement-fidelity document changed after its successful compile.")
    for key in ("source_sha256", "statement_fidelity_sha256"):
        require(archived["lean_check"][key] == result[key],
                "Compiler and archived evidence disagree on their source binding.")
    declarations = re.findall(r"^theorem\s+([A-Za-z0-9_]+)", source, re.MULTILINE)
    require(declarations == certificate["formal_declarations"],
            "The formal declaration list changed.")
    require(all(f"`{name}`" in fidelity for name in declarations),
            "A formal declaration is absent from the fidelity document.")
    state = read_json(ROOT / "research/MATH_STATE.json")
    versions = [c for c in state["claims"]
                if c["claim_id"] == certificate["formal_claim"]]
    current = max(versions, key=lambda c: c["version"])
    require(current["content_hash"] == evidence["subject"]["content_hash"] and
            current["formal_statement"] == source,
            "The compiler evidence certifies a stale formal claim.")
    require(any(e["evidence_id"] == evidence["evidence_id"] and
                e["artifact"] == evidence["artifact"] for e in state["evidence"]),
            "The mechanical evidence is absent from the campaign ledger.")
    return {"version": "4.31.0", "declarations": len(declarations),
            "exit_code": 0, "proof_holes": []}


def main():
    certificate = read_json(HERE / "exact_certificate.json")
    verify_scope(certificate)
    identities = verify_symbolic(certificate)
    finite_tests = verify_finite_stress_tests()
    inertia = verify_jacobian(certificate)
    lean = verify_lean(certificate)
    print(json.dumps({
        "status": "pass",
        "claim": certificate["claim_id"],
        "exact_symbolic_identities": identities,
        "finite_experiments": finite_tests,
        "jacobian_inertia_replayed": inertia,
        "lean_core": lean,
        "analytic_proof": "report.md; mathematical proof, not machine-checked analysis",
        "independent_review": "pending_host",
        "novelty": "not_claimed",
    }, indent=2))


if __name__ == "__main__":
    main()
