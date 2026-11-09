#!/usr/bin/env python3
"""Replay the universal formal core and exact Fourier-field diagnostics."""

from __future__ import annotations

import argparse
import itertools
import json
import math
from pathlib import Path
import re
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = Path("$WORKSPACE/argus-live-update/.venv/bin/python")
SOURCE = (
    ROOT
    / "research/openai_manuscript"
    / "Polynomial-Time-Unitary-Synthesis-from-a-Boolean-Oracle-October-5-2026"
    / "build/sections/04-fields.tex"
)
DECLARATIONS = (
    "defect_telescope",
    "forward_gram_defect",
    "backward_gram_defect",
    "orthogonal_gram",
    "feedback_from_conservation",
    "block_feedback_algebra",
    "backward_resolvent_algebra",
    "power_sums_determine_multiset",
    "manuscript_fullRow_bound",
    "prime_code_injective",
    "compact_code_exists",
    "prime_fullRow_bound",
)


class VerificationError(Exception):
    pass


def require(condition: bool, message: str) -> None:
    if not condition:
        raise VerificationError(message)


def scalar(value):
    return sp.expand_complex(sp.cancel(value))


def clean(matrix):
    return matrix.applyfunc(scalar)


def equal(left, right) -> bool:
    return clean(left - right) == sp.zeros(left.rows, left.cols)


def encoded(matrix) -> list[list[str]]:
    return [[str(scalar(matrix[i, j])) for j in range(matrix.cols)] for i in range(matrix.rows)]


def psd(matrix, label: str) -> int:
    matrix = clean(matrix)
    require(equal(matrix, matrix.H), f"{label}: matrix is not Hermitian")
    count = 0
    for size in range(1, matrix.rows + 1):
        for indices in itertools.combinations(range(matrix.rows), size):
            minor = scalar(matrix.extract(indices, indices).det())
            require(minor.is_Rational is True, f"{label}: non-rational principal minor {minor}")
            require(minor >= 0, f"{label}: negative principal minor {indices}: {minor}")
            count += 1
    return count


def add_term(poly, frequency, matrix) -> None:
    matrix = clean(matrix)
    if frequency in poly:
        matrix = clean(poly[frequency] + matrix)
    if matrix == sp.zeros(matrix.rows, matrix.cols):
        poly.pop(frequency, None)
    else:
        poly[frequency] = matrix


def poly_add(left, right):
    result = {w: m.copy() for w, m in left.items()}
    for w, matrix in right.items():
        add_term(result, w, matrix)
    return result


def poly_mul(left, right, modulus: int):
    result = {}
    for w, a in left.items():
        for v, b in right.items():
            frequency = tuple((x + y) % modulus for x, y in zip(w, v))
            add_term(result, frequency, a * b)
    return result


def poly_adjoint(poly, modulus: int):
    return {tuple(-x % modulus for x in w): clean(matrix.H) for w, matrix in poly.items()}


def frequency(indices, length: int, modulus: int):
    return tuple(sum(i**j for i in indices) % modulus for j in range(length + 1))


def make_phases(size: int, length: int, modulus: int):
    result = {}
    for i in range(size):
        diagonal = sp.zeros(size)
        diagonal[i, i] = 1
        add_term(result, frequency((i + 1,), length, modulus), diagonal)
    return result


def field_coefficients(a, b, c, d, length: int, modulus: int):
    k, s = a.rows, d.rows
    zero = (0,) * (length + 1)
    constant = lambda matrix: {zero: matrix}
    z = make_phases(s, length, modulus)
    zs = poly_adjoint(z, modulus)
    forward_step = poly_mul(constant(d), z, modulus)
    backward_step = poly_mul(zs, constant(d.H), modulus)
    fpow = constant(sp.eye(s))
    rpow = constant(sp.eye(s))
    lower_e, lower_r = {}, {}
    for _ in range(length):
        lower_e = poly_add(
            lower_e, poly_mul(poly_mul(z, fpow, modulus), constant(c), modulus)
        )
        lower_r = poly_add(
            lower_r, poly_mul(poly_mul(rpow, zs, modulus), constant(b.H), modulus)
        )
        fpow = poly_mul(fpow, forward_step, modulus)
        rpow = poly_mul(rpow, backward_step, modulus)
    fields = []
    for lower in (lower_e, lower_r):
        coeff = {zero: sp.Matrix.hstack(sp.eye(k), sp.zeros(k, s))}
        for w, matrix in poly_adjoint(lower, modulus).items():
            add_term(coeff, w, sp.Matrix.hstack(sp.zeros(k), matrix))
        fields.append(coeff)
    defect_e = poly_mul(
        poly_mul(poly_mul(z, fpow, modulus), poly_adjoint(fpow, modulus), modulus),
        zs,
        modulus,
    )
    defect_r = poly_mul(rpow, poly_adjoint(rpow, modulus), modulus)
    return fields, [
        defect_e.get(zero, sp.zeros(s)),
        defect_r.get(zero, sp.zeros(s)),
    ]


def code_table(size: int, length: int, modulus: int):
    table = {}
    for count in range(length + 1):
        for bag in itertools.combinations_with_replacement(range(1, size + 1), count):
            w = frequency(bag, length, modulus)
            require(w not in table, f"moment-code collision modulo {modulus}: {table.get(w)}, {bag}")
            table[w] = bag
    return table


def rotation(c, s):
    return sp.Matrix([[c, -s], [s, c]])


def examples():
    q, t = sp.Rational(3, 5), sp.Rational(4, 5)
    u = rotation(q, t)
    yield "balanced-real", 2, q, q * sp.eye(2), t * sp.eye(2), -t * u, q * u, (1, 2, 3, 4)
    u = sp.diag(1, sp.I) * u
    w = rotation(sp.Rational(5, 13), sp.Rational(12, 13))
    cos = sp.diag(q, sp.Rational(5, 13))
    sin = sp.diag(t, sp.Rational(12, 13))
    yield "anisotropic-complex", 2, q, cos, sin * w, -u * sin, u * cos * w, (1, 2, 3)
    yield "scalar-real", 1, q, sp.Matrix([[q]]), sp.Matrix([[t]]), sp.Matrix([[-t]]), sp.Matrix([[q]]), (1, 2, 3)
    yield "zero-contraction", 1, sp.Integer(0), sp.zeros(1), sp.ones(1), -sp.ones(1), sp.zeros(1), (1, 2, 3)


def pointwise_checks(a, b, c, d, r, length: int):
    k, s = a.rows, d.rows
    v = sp.BlockMatrix([[a, b], [c, d]]).as_explicit()
    tau = r**length / (1 - r)
    count, minor_count = 0, 0
    for phases in itertools.product((1, sp.I, -1, -sp.I), repeat=s):
        z = sp.diag(*phases)
        inverse = clean((sp.eye(s) - d * z).inv())
        x = clean(inverse * c)
        f = clean(a + b * z * x)
        y = clean(x * f.H)
        e = sp.Matrix.vstack(sp.eye(k), z * x)
        out = sp.Matrix.vstack(sp.eye(k), y)
        require(equal(f.H * f, sp.eye(k)) and equal(f * f.H, sp.eye(k)), "feedback is not unitary")
        require(equal(f * e.H, out.H * v), "exact feedback intertwining failed")
        require(
            equal(y, (sp.eye(s) - z.H * d.H).inv() * z.H * b.H),
            "backward resolvent formula failed",
        )
        low_e, low_r = sp.zeros(s, k), sp.zeros(s, k)
        for ell in range(length):
            low_e += z * (d * z) ** ell * c
            low_r += (z.H * d.H) ** ell * z.H * b.H
        et = sp.Matrix.vstack(sp.eye(k), low_e)
        rt = sp.Matrix.vstack(sp.eye(k), low_r)
        for label, tail in (("E", e - et), ("R", out - rt)):
            minor_count += psd(tau**2 * sp.eye(k) - tail.H * tail, f"{label} tail")
        error = clean(f * et.H - rt.H * v)
        minor_count += psd(4 * tau**2 * sp.eye(k) - error * error.H, "intertwining error")
        if r == 0:
            require(equal(error, sp.zeros(k, k + s)), "r=0 did not give exact intertwining")
        count += 1
    return count, minor_count


def exact_field_checks():
    cases = []
    for name, n, r, a, b, c, d, lengths in examples():
        k, s = a.rows, d.rows
        v = sp.BlockMatrix([[a, b], [c, d]]).as_explicit()
        require(k >= 1 and s >= 1 and k + s <= 2**n, "inadmissible diagnostic dimensions")
        require(0 <= r < 1 and equal(v.H * v, sp.eye(k + s)), "inadmissible block unitary")
        psd(r**2 * sp.eye(s) - d.H * d, "contraction hypothesis")
        for length in lengths:
            bits = n * length + length.bit_length()
            modulus = 2**bits
            table = code_table(s, length, modulus)
            for bag in table.values():
                for degree in range(length + 1):
                    require(sum(i**degree for i in bag) < modulus, "integer no-wrap bound failed")
            fields, defects = field_coefficients(a, b, c, d, length, modulus)
            grams, maxima, mode_counts, minor_count = [], [], [], 0
            for side, (coeff, defect) in enumerate(zip(fields, defects)):
                gram = sp.zeros(k + s)
                maximum = 0
                for w, matrix in coeff.items():
                    gram += matrix.H * matrix
                    signed = tuple((-x if side == 0 else x) % modulus for x in w)
                    bag = table.get(signed)
                    require(bag is not None, f"{name}: frequency has no source multiset")
                    for port in range(k):
                        support = [i for i in range(k + s) if scalar(matrix[port, i]) != 0]
                        maximum = max(maximum, len(support))
                        require(len(support) <= length, f"{name}: row exceeds L")
                        for column in support:
                            if column < k:
                                require(not any(w) and column == port, "non-identity port support")
                            else:
                                require(column - k + 1 in bag, "input endpoint absent from frequency bag")
                gram = clean(gram)
                predicted = sp.diag(sp.eye(k), sp.eye(s) - defect)
                require(equal(gram, predicted), f"{name}: ordered Gram defect formula failed")
                minor_count += psd(sp.eye(k + s) - gram, "Gram upper bound")
                minor_count += psd(
                    gram - (1 - r ** (2 * length)) * sp.eye(k + s), "Gram lower bound"
                )
                require(
                    equal(coeff[(0,) * (length + 1)], sp.Matrix.hstack(sp.eye(k), sp.zeros(k, s))),
                    "zero-frequency field coefficient is not the port identity",
                )
                grams.append(encoded(gram))
                maxima.append(maximum)
                mode_counts.append(len(coeff))
            points, tail_minors = pointwise_checks(a, b, c, d, r, length)
            cases.append(
                {
                    "name": name,
                    "n": n,
                    "k": k,
                    "s": s,
                    "L": length,
                    "r": str(r),
                    "N": modulus,
                    "moment_multisets": len(table),
                    "E_R_mode_counts": mode_counts,
                    "E_R_max_row_support": maxima,
                    "E_R_grams": grams,
                    "pointwise_diagonal_phases": points,
                    "nonnegative_principal_minors": minor_count + tail_minors,
                }
            )
    return cases


def positive_phase_dft():
    n, length, modulus = 1, 1, 4
    q, t = sp.Rational(3, 5), sp.Rational(4, 5)
    grid = list(itertools.product(range(modulus), repeat=length + 1))
    observed = [set(), set()]
    for w in grid:
        values = [sp.Integer(0), sp.Integer(0)]
        for z in grid:
            phase = sp.I ** (z[0] + z[1])
            bra_phase = sp.I ** (-sum(x * y for x, y in zip(w, z)))
            values[0] += bra_phase * (-t / phase)
            values[1] += bra_phase * (t * phase)
        for side in range(2):
            value = scalar(values[side] / len(grid))
            if value != 0:
                observed[side].add(w)
    require(observed == [{(3, 3)}, {(1, 1)}], "positive-phase DFT orientation failed")
    require(q**2 + t**2 == 1 and n == 1, "DFT probe unitary hypothesis failed")
    return {"N": modulus, "grid_points": len(grid), "E_internal_frequency": [3, 3], "R_internal_frequency": [1, 1]}


def prime_extension_checks():
    cases = []
    for size, length, prime in ((1, 1, 2), (2, 3, 5), (3, 4, 5), (4, 5, 7)):
        require(sp.isprime(prime) and prime > max(size, length), "inadmissible prime extension")
        table = code_table(size, length, prime)
        require(prime <= 2 * max(size, length), "compact-grid interval failed")
        cases.append({"s": size, "L": length, "p": prime, "distinct_multisets": len(table)})
    require(
        frequency((1, 1), 2, 2) == frequency((2, 2), 2, 2),
        "finite-characteristic boundary control did not collide",
    )
    return cases


def order_negative_control():
    sample = next(sample for sample in examples() if sample[0] == "anisotropic-complex")
    _, _, _, _, b, _, d, _ = sample
    z = sp.diag(1, sp.I)
    require(not equal(d * d.H, d.H * d), "the nonnormal diagnostic became normal")
    require(not equal(d * z, z * d), "the noncommuting diagnostic became commuting")
    c0 = z.H * b.H
    right = z.H * d.H
    wrong = d.H * z.H
    require(equal(c0 * c0.H, sp.eye(2) - right * right.H), "correct backward defect failed")
    residual = clean(c0 * c0.H - (sp.eye(2) - wrong * wrong.H))
    require(not equal(residual, sp.zeros(2)), "order negative control failed to distinguish products")
    return {"wrong_backward_order_rejected": True, "wrong_order_defect_residual": encoded(residual)}


def rejection_controls() -> None:
    for label, operation, reason in (
        ("invalid Gram bound", lambda: psd(sp.Matrix([[-1]]), "negative control"), "negative principal minor"),
        ("aliased moment code", lambda: code_table(2, 2, 2), "moment-code collision"),
    ):
        try:
            operation()
        except VerificationError as exc:
            require(reason in str(exc), f"{label} failed for an unexpected reason: {exc}")
        else:
            raise VerificationError(f"verifier accepted {label}")


def jacobian_replay():
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    response = json.loads((HERE / "jacobian-result.json").read_text())
    require(response["request"]["operation_id"] == "matrix.inverse.compute", "wrong Jacobian operation")
    require(response["request"]["payload"] == payload, "Jacobian source-payload mismatch")
    require(response["result"]["operation_id"] == "matrix.inverse.compute", "wrong typed result")
    require("error" not in response and "error" not in response["result"], "Jacobian returned a structured error")
    output = response["result"]["output"]
    require(output["convention"] == "TWO_SIDED_INVERSE_OVER_QQ", "wrong inverse convention")
    matrix = sp.Matrix([[int(x) for x in row] for row in payload["matrix"]["entries"]])
    entries = []
    for row in output["inverse"]["entries"]:
        values = []
        for rational in row:
            num, den = int(rational["num"]), int(rational["den"])
            require(den > 0 and math.gcd(num, den) == 1, "noncanonical typed rational")
            values.append(sp.Rational(num, den))
        entries.append(values)
    inverse = sp.Matrix(entries)
    require(equal(matrix * inverse, sp.eye(2)) and equal(inverse * matrix, sp.eye(2)), "inverse replay failed")
    q, t = sp.Rational(3, 5), sp.Rational(4, 5)
    d = q * rotation(q, t)
    require(equal(matrix, 25 * (sp.eye(2) - d * sp.diag(1, -1))), "Jacobian matrix is not source-bound")
    return {
        "operation_id": "matrix.inverse.compute",
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "transport": response["transport"],
        "structured_error": None,
        "typed_output_replayed": True,
        "matrix": encoded(matrix),
        "inverse": encoded(inverse),
    }


def source_contract():
    source = " ".join(SOURCE.read_text().split())
    fragments = (
        r"d=k+s\le 2^n",
        r"k,s\ge1",
        r"\norm{D}\le r<1,\quad r\ge0",
        r"\exp(2\pi i\,w\cdot z/2^b)",
        r"FE^*=R^*V",
        r"(1-r^{2L})I_d\ \le\ \mathcal T^*\mathcal T\ \le\ I_d",
        r"\norm{\widetilde F\mathcal E_L-\mathcal R_L V}\le2\tau",
        r"every row of $\mathcal E_L$ and of $\mathcal R_L$ has at most $L$ nonzero entries",
    )
    for fragment in fragments:
        require(fragment in source, f"source contract changed: {fragment}")
    return {"path": SOURCE.relative_to(ROOT).as_posix(), "labels": ["fields:unitary", "fields:gram", "fields:sparsity"]}


def run_module(module: str, *args):
    command = [str(ARGUS_PYTHON), "-m", module, *map(str, args)]
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=110, check=False)
    if result.returncode:
        raise VerificationError(
            f"command failed ({result.returncode}): {' '.join(command)}\n{result.stdout}\n{result.stderr}"
        )
    return result.stdout


def formal_replay():
    payload = json.loads(
        run_module(
            "argus_skill.verticals.math.lean_evidence",
            "verify",
            HERE / "Main.lean",
            "--statement-fidelity",
            HERE / "statement_fidelity.md",
            "--claim",
            "C_FOURIER_CORE",
            "--project-root",
            ROOT,
            "--timeout",
            "90",
        )
    )
    require(payload["status"] == "success" and payload["exit_code"] == 0, "Lean compilation did not succeed")
    require(payload["proof_holes"] == [], "Lean formalization has proof holes")
    require(payload["kernel"]["recorded"] is not None, "formal result was not attached to its claim")
    version = payload["tools"]["lean"]["version"]
    require(re.search(r"\b4\.31\.0\b", version) is not None, f"wrong Lean version: {version}")
    stdout = payload["stdout"]
    axiom_lines = [line for line in stdout.splitlines() if "depends on axioms:" in line]
    require(len(axiom_lines) == len(DECLARATIONS), "missing formal axiom audits")
    for declaration in DECLARATIONS:
        lines = [line for line in axiom_lines if f"'FourierAudit.{declaration}'" in line]
        require(len(lines) == 1, f"missing axiom audit: {declaration}")
        axioms = set(re.findall(r"[A-Za-z_][A-Za-z_0-9.]*", lines[0].split("[", 1)[1]))
        require(axioms <= {"propext", "Classical.choice", "Quot.sound"}, f"unapproved axioms: {axioms}")
    return {
        "claim": "C_FOURIER_CORE",
        "lean_version": "4.31.0",
        "exit_code": payload["exit_code"],
        "proof_holes": payload["proof_holes"],
        "source_sha256": payload["source_sha256"],
        "statement_fidelity_sha256": payload["statement_fidelity_sha256"],
        "declarations": list(DECLARATIONS),
        "axioms": ["propext", "Classical.choice", "Quot.sound"],
    }


def campaign_checks() -> None:
    outcomes = {}
    for module in ("math_state", "proof_graph_check"):
        command = [
            str(ARGUS_PYTHON),
            "-m",
            f"argus_skill.verticals.math.{module}",
            "check",
            "--project-root",
            str(ROOT),
        ]
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=110, check=False)
        outcomes[module] = result.returncode
        if result.returncode:
            print(f"{module}: {result.stdout}\n{result.stderr}", file=sys.stderr)
    require(all(code == 0 for code in outcomes.values()), f"campaign-local checks failed at {ROOT}: {outcomes}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true", help="write the recomputed certificate instead of comparing it")
    args = parser.parse_args()
    source = source_contract()
    cases = exact_field_checks()
    dft = positive_phase_dft()
    compact = prime_extension_checks()
    order = order_negative_control()
    rejection_controls()
    jacobian = jacobian_replay()
    try:
        formal = formal_replay()
    finally:
        campaign_checks()
    certificate = {
        "schema_version": 1,
        "project_root": str(ROOT),
        "result": "universal_fourier_field_verification_and_compact_grid_corollary",
        "classification": {
            "proof": "universal prose theorem with a compiled algebraic-combinatorial core",
            "finite_tests": "diagnostics, not universal proofs",
            "independent_review": "required_separately",
            "novelty": "requires independent assessment; classical ingredients not claimed new",
        },
        "source": source,
        "formal_core": formal,
        "prose_obligations": [
            "stable resolvent existence and norm",
            "finite complex-character orthogonality",
            "matrix-product to signed path-sum identification",
            "Loewner estimates from the exact Gram defects",
            "Neumann tails and averaged operator-norm intertwining",
        ],
        "exact_diagnostics": cases,
        "positive_phase_dft": dft,
        "prime_grid_diagnostics": compact,
        "negative_controls": {**order, "p_le_L_code_collision_detected": True},
        "jacobian": jacobian,
        "campaign_local_checks": {"math_state_exit_code": 0, "proof_graph_exit_code": 0},
    }
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(target.read_text())
        require(expected == certificate, "recomputed certificate differs from exact_certificate.json")
    print(
        json.dumps(
            {
                "status": "verified",
                "formal_exit_code": formal["exit_code"],
                "proof_holes": formal["proof_holes"],
                "exact_cases": len(cases),
                "pointwise_phase_checks": sum(case["pointwise_diagonal_phases"] for case in cases),
                "independent_review": "not_performed_by_verifier",
                "certificate": target.relative_to(ROOT).as_posix(),
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (VerificationError, OSError, subprocess.TimeoutExpired) as exc:
        print(f"verification failed: {exc}", file=sys.stderr)
        raise SystemExit(1) from exc
