#!/usr/bin/env python3
"""Replay exact diagnostics and compile the universal comparison theorem."""

import json
import subprocess
import sys
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
MANUSCRIPT = (
    "research/openai_manuscript/"
    "Fiber-functors-for-finite-symmetric-tensor-categories-in-positive-"
    "characteristic-September-24-2026/build/sections/restricted.tex"
)


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def run(command):
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
    if result.returncode:
        sys.stderr.write(result.stdout)
        sys.stderr.write(result.stderr)
        raise RuntimeError(f"Command failed with exit {result.returncode}: {command}")
    return result.stdout


def zero(matrix):
    return all(sp.cancel(entry) == 0 for entry in matrix)


def reduce_word(word):
    stack = []
    for symbol, exponent in word:
        if stack and stack[-1] == (symbol, -exponent):
            stack.pop()
        else:
            stack.append((symbol, exponent))
    return stack


def verify_word():
    p, h, d, b = [[(name, 1)] for name in ("p", "h", "d", "b")]
    pi, hi, di = [[(name, -1)] for name in ("p", "h", "d")]
    e = d + b + di
    c = h + e + hi
    a = pi + c + p
    f = pi + h + d
    require(reduce_word(p + a) == reduce_word(c + p), "P transport orientation")
    require(reduce_word(c + h) == reduce_word(h + e), "Gauge orientation")
    require(reduce_word(d + b) == reduce_word(e + d), "D transport orientation")
    normal = reduce_word(a + f)
    require(normal == reduce_word(f + b), "Universal transport word identity")
    require(
        reduce_word(a + pi + h) != reduce_word(pi + h + b),
        "Omitting D must not be certified",
    )
    return [name if exponent == 1 else f"{name}^-1" for name, exponent in normal]


def verify_binary_forms():
    pairs = []
    for a in range(1, 4):
        for b in range(1, 4):
            source = [(i, j) for i in range(a) for j in range(b)]
            target = [(i, j) for i in range(a + 1) for j in range(b + 1)]
            row = {pair: index for index, pair in enumerate(target)}
            determinant_map = sp.zeros(len(target), len(source))
            for col, (i, j) in enumerate(source):
                determinant_map[row[i, j + 1], col] = 1
                determinant_map[row[i + 1, j], col] = -1
            multiply = sp.zeros(a + b + 1, len(target))
            for col, (i, j) in enumerate(target):
                multiply[i + j, col] = 1
            require(zero(multiply * determinant_map), "Binary-form complex identity")
            injective_rows = [row[i, j + 1] for i, j in source]
            injective_minor = determinant_map.extract(
                injective_rows, list(range(len(source)))
            ).det()
            surjective_cols = [
                row[min(a, degree), degree - min(a, degree)]
                for degree in range(a + b + 1)
            ]
            surjective_minor = multiply.extract(
                list(range(a + b + 1)), surjective_cols
            ).det()
            require(injective_minor == 1, "Integral unit minor for determinant map")
            require(surjective_minor == 1, "Integral unit minor for multiplication")
            require(len(target) - (a + b + 1) == len(source), "Kernel dimension")
            pairs.append([a, b])
    return pairs


def integral_laurent(matrix, x, t, s):
    for entry in matrix:
        numerator, denominator = sp.fraction(sp.cancel(entry))
        sp.Poly(numerator, x, t, s, domain=sp.ZZ)
        terms = sp.Poly(denominator, x, t, s, domain=sp.ZZ).terms()
        require(
            len(terms) == 1
            and terms[0][1] == 1
            and terms[0][0][1:] == (0, 0),
            "The exact model must work over ZZ[x,x^-1,s,t], without prime denominators",
        )


def verify_transport():
    x, t, s = sp.symbols("x t s")
    standard = sp.Matrix([[1, t], [0, 1]])
    torus = sp.diag(x, 1 / x)
    ranks = [0]
    require(sp.eye(0).det() == 1, "Zero-rank determinant")
    omitted = None
    for power in range(3):
        action, diagonal = sp.eye(1), sp.eye(1)
        for _ in range(power):
            action = sp.kronecker_product(action, standard)
            diagonal = sp.kronecker_product(diagonal, torus)
        n = action.rows
        nilpotent = sp.zeros(n)
        if n > 1:
            nilpotent[n - 1, 0] = 1
        require(zero(nilpotent * nilpotent), "Square-zero frame change")
        gauge = sp.eye(n) + x * nilpotent
        gauge_inverse = sp.eye(n) - x * nilpotent
        origin_frame = sp.eye(n) + nilpotent
        origin_frame_inverse = sp.eye(n) - nilpotent
        moving = gauge * action * gauge_inverse
        original = moving.subs(x, 1)
        transport = gauge * diagonal * origin_frame_inverse
        transport_inverse = origin_frame * diagonal.subs(x, 1 / x) * gauge_inverse
        comparison = transport_inverse * gauge * diagonal
        identities = {
            "rational group law": moving.subs(t, t + s)
            - moving * moving.subs(t, s),
            "gauge": moving * gauge - gauge * action,
            "bundle transport": transport * original
            - moving.subs(t, x**2 * t) * transport,
            "origin transport": diagonal * action
            - action.subs(t, x**2 * t) * diagonal,
            "inverse": transport_inverse * transport - sp.eye(n),
            "original parameter": original * comparison - comparison * action,
            "comparison value": comparison - origin_frame,
        }
        for name, residual in identities.items():
            require(zero(residual), f"Rank {n}: {name}")
        for matrix in (action, diagonal, gauge, moving, transport, comparison):
            integral_laurent(matrix, x, t, s)
        require(
            all(matrix.det() == 1 for matrix in (gauge, transport, comparison)),
            f"Rank {n}: invertibility",
        )
        if power == 1:
            bad = transport_inverse * gauge
            residual = original * bad - bad * action
            omitted = [
                [str(sp.cancel(residual[i, j].subs({x: 2, t: 1}))) for j in range(n)]
                for i in range(n)
            ]
            require(not zero(residual), "Missing-D diagnostic must be nonzero")
        ranks.append(n)
    return ranks, omitted


def verify_descent():
    z0, z1, s = sp.symbols("z0 z1 s")
    q = sp.Matrix([[1, 1], [0, 1]])
    b = sp.diag(0, 1)
    a = q * b * q.inv()
    m0, m1 = q * sp.diag(1, 0), q * sp.diag(0, 1)
    require(m0.det() == m1.det() == 0, "Both coordinate matrices are singular")
    require(zero(a * m0 - m0 * b) and zero(a * m1 - m1 * b), "Coordinate equations")
    generic = m0 + s * m1
    require(generic.det() == s, "Invertible matrix over QQ(s)")
    require(zero(a * generic - generic * b), "Extension-field intertwiner")
    determinant = sp.expand((z0 * m0 + z1 * m1).det())
    require(determinant.subs({z0: 1, z1: 1}) == 1, "Base-field specialization")
    return {
        "coordinate_determinants": [str(m0.det()), str(m1.det())],
        "extension_determinant": str(generic.det()),
        "determinant_polynomial": str(determinant),
        "base_point": [1, 1],
    }


def verify_jacobian():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    result = json.loads((HERE / "jacobian_output.json").read_text())
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    operation = "modular.polynomial_identity.compute"
    require(contract["result"]["operation"]["operation_id"] == operation, "Typed contract")
    require(result["request"]["operation_id"] == operation, "Executed operation")
    require(result["request"]["payload"] == payload, "Exact executed payload")
    require(
        status == {"operation_id": operation, "adapter_exit_code": 0, "timeout": False},
        "Adapter failure or timeout is not a mathematical conclusion",
    )
    output = result["result"]["output"]
    require(output["comparison_scope"] == "FORMAL_COEFFICIENTWISE_IDENTITY", "Typed scope")
    require(output["identical"] is False, "Finite-points diagnostic")
    require(payload["modulus"] == 2 and payload["variables"] == ["t"], "Diagnostic domain")
    t, s = sp.symbols("t s")
    polynomial = sum(
        int(term["coefficient"]) * t ** term["exponents"][0] for term in payload["left"]
    )
    require(payload["right"] == [], "Diagnostic zero comparison")
    require(sp.expand(polynomial - (t**2 - t)) == 0, "Diagnostic polynomial")
    require(all(int(polynomial.subs(t, a)) % 2 == 0 for a in (0, 1)), "Rational points")
    additive_residual = sp.Poly(
        polynomial.subs(t, t + s) - polynomial - polynomial.subs(t, s), t, s
    )
    require(all(int(c) % 2 == 0 for c in additive_residual.coeffs()), "Additive polynomial")
    expected_residual = [
        {"coefficient": 1, "exponents": [1]},
        {"coefficient": 1, "exponents": [2]},
    ]
    require(output["residual"] == expected_residual, "Independent modular coefficient replay")
    return {
        "operation_id": operation,
        "protocol": result["protocol_version"],
        "server_version": result["server"]["version"],
        "polynomial": "t^2-t",
        "rational_points": [0, 1],
        "coefficientwise_zero": False,
        "adapter_exit_code": status["adapter_exit_code"],
    }


def exact_replay():
    ranks, omitted = verify_transport()
    return {
        "transport_word_normal_form": verify_word(),
        "binary_form_pairs": verify_binary_forms(),
        "binary_form_injective_and_surjective_minors": [1, 1],
        "integral_laurent_transport_ranks": ranks,
        "omitted_D_residual_at_x2_t1": omitted,
        "descent": verify_descent(),
        "group_scheme_diagnostic": verify_jacobian(),
    }


def main():
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    source = (ROOT / MANUSCRIPT).read_text()
    label = source.index(r"\label{lem:formal-comparison}")
    start = source.rfind(r"\begin{lemma}", 0, label)
    end = source.index(r"\end{lemma}", label) + len(r"\end{lemma}")
    require(
        " ".join(source[start:end].split())
        == " ".join(certificate["literal_manuscript_lemma"].split()),
        "The literal target hypotheses or conclusion changed",
    )
    require(
        r"Let $G=\mathrm{SL}_{2,k}$, let $V=k^2$ be its standard module"
        in " ".join(source.split()),
        "The target group or plane changed",
    )
    actual = exact_replay()
    require(actual == certificate["exact_replay"], "Exact certificate differs from replay")
    version = run(["$WORKSPACE/.elan/bin/lean", "--version"])
    require("version 4.31.0," in version, "Lean 4.31.0 is required")
    native = json.loads(
        run(
            [
                ARGUS_PYTHON,
                "-m",
                "argus_skill.verticals.math.lean_evidence",
                "verify",
                str(HERE / "Main.lean"),
                "--statement-fidelity",
                str(HERE / "statement_fidelity.md"),
                "--claim",
                "C_COMPARE_ALGEBRA",
                "--project-root",
                str(ROOT),
                "--timeout",
                "100",
            ]
        )
    )
    require(native["status"] == "success", "A real successful compiler run is required")
    require(native["exit_code"] == 0 and native["proof_holes"] == [], "Formal proof holes")
    require(native["kernel"]["recorded"] is not None, "Mechanical evidence was not recorded")
    for module in ("math_state", "proof_graph_check"):
        run(
            [
                ARGUS_PYTHON,
                "-m",
                f"argus_skill.verticals.math.{module}",
                "check",
                "--project-root",
                str(ROOT),
            ]
        )
    print(
        json.dumps(
            {
                "status": "verified_engineering_evidence",
                "literal_claim": "C_FORMAL_COMPARE",
                "compiled_claim": "C_COMPARE_ALGEBRA",
                "lean_exit_code": 0,
                "proof_holes": [],
                "exact_replay": actual,
                "project_root": str(ROOT),
                "math_state_exit_code": 0,
                "proof_graph_exit_code": 0,
                "independent_review": "required; not performed by this script",
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
