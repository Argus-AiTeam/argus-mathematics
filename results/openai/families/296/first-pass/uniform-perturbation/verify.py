#!/usr/bin/env python3
"""Recompute exact regressions, compile the universal theorem, and check its ledger."""

import argparse
from collections import Counter, defaultdict
from fractions import Fraction
import hashlib
import itertools
import json
import math
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
LEAN = "$WORKSPACE/.elan/bin/lean"
CLAIM = "C_UP_CORE"


def reduce_word(letters):
    stack = []
    for letter in letters:
        assert isinstance(letter, int) and letter != 0
        if stack and stack[-1] == -letter:
            stack.pop()
        else:
            stack.append(letter)
    return tuple(stack)


def inverse(word):
    return tuple(-letter for letter in reversed(word))


def multiply_words(*words):
    return reduce_word(itertools.chain.from_iterable(words))


def prefix(k):
    return tuple(range(1, k + 1))


def label(k, j):
    return multiply_words(prefix(k), inverse(prefix(j)))


def add(*polynomials):
    result = defaultdict(Fraction)
    for polynomial in polynomials:
        for word, value in polynomial.items():
            result[word] += value
    return {word: value for word, value in result.items() if value}


def scale(polynomial, scalar):
    return {word: scalar * value for word, value in polynomial.items() if scalar * value}


def multiply(left, right):
    result = defaultdict(Fraction)
    for x, a in left.items():
        for y, b in right.items():
            result[multiply_words(x, y)] += a * b
    return {word: value for word, value in result.items() if value}


def power(polynomial, degree):
    result = {(): Fraction(1)}
    for _ in range(degree):
        result = multiply(result, polynomial)
    return result


def ordered_coefficients(rows, maximum_degree):
    coefficients = [{(): Fraction(1)}] + [{} for _ in range(maximum_degree)]
    for row in rows:
        divided_powers = [
            scale(power(row, m), Fraction(1, math.factorial(m)))
            for m in range(maximum_degree + 1)
        ]
        coefficients = [
            add(*(multiply(coefficients[d - m], divided_powers[m]) for m in range(d + 1)))
            for d in range(maximum_degree + 1)
        ]
    return coefficients


def rows_for(n, c):
    labels = sorted({label(k, j) for k in range(1, n + 1) for j in range(1, n + 1)})
    generators = {p: i + 1 for i, p in enumerate(labels)}
    signed_rows = []
    positive_rows = []
    for k in range(1, n + 1):
        signed = defaultdict(Fraction)
        positive = defaultdict(Fraction)
        for j in range(1, n + 1):
            t = generators[label(k, j)]
            signed[(t,)] += c
            signed[(-t,)] -= c
            positive[(t,)] += c
            positive[(-t,)] += c
        signed_rows.append(dict(signed))
        positive_rows.append(dict(positive))
    return signed_rows, positive_rows, generators


def token_coefficient(n, d, c, generators):
    tokens = [
        (k, sign * generators[label(k + 1, j + 1)], sign * c)
        for k in range(n)
        for j in range(n)
        for sign in (-1, 1)
    ]
    coefficient = defaultdict(Fraction)
    for sequence in itertools.product(tokens, repeat=d):
        row_indices = tuple(t[0] for t in sequence)
        if row_indices != tuple(sorted(row_indices)):
            continue
        denominator = math.prod(math.factorial(row_indices.count(k)) for k in range(n))
        value = math.prod((t[2] for t in sequence), start=Fraction(1)) / denominator
        coefficient[reduce_word(t[1] for t in sequence)] += value
    return {word: value for word, value in coefficient.items() if value}


def exact_prefix_checks():
    results = []
    for n in range(1, 33):
        multiplicities = Counter(label(k, j) for k in range(1, n + 1) for j in range(1, n + 1))
        assert multiplicities[()] == n
        assert all(m == 1 for p, m in multiplicities.items() if p)
        assert sum(m * m for m in multiplicities.values()) == 2 * n * n - n
        for k in range(1, n + 1):
            for j in range(1, n + 1):
                p = label(k, j)
                moment = (
                    sum(1 if x > 0 else -1 for x in p),
                    sum((1 if x > 0 else -1) * (2 * abs(x) - 1) for x in p),
                )
                assert moment == (k - j, k * k - j * j)
        results.append({"length": n, "labels": len(multiplicities),
                        "collision_energy": sum(m * m for m in multiplicities.values())})
    return results


def exact_orientation_checks():
    controls = []
    for n in range(1, 9):
        a, q, u = (1,), (2,), (3,)
        steps = [(3, 4 + k) for k in range(n)]
        left = multiply_words(a, *(multiply_words(q, x) for x in steps))
        g = a
        conjugates = []
        wrong_conjugates = []
        for x in steps:
            conjugates.append(multiply_words(g, q, inverse(g)))
            wrong_conjugates.append(multiply_words(inverse(g), q, g))
            g = multiply_words(g, x)
        right = multiply_words(*conjugates, g)
        assert left == right
        inverse_prefix_fails = multiply_words(*wrong_conjugates, g) != left
        reversed_order_fails = multiply_words(*reversed(conjugates), g) != left
        assert inverse_prefix_fails
        assert reversed_order_fails == (n > 1)
        controls.append({"length": n, "correct_orientation": True,
                         "inverse_prefix_rejected": inverse_prefix_fails,
                         "reversed_order_rejected": reversed_order_fails})
    return controls


def exact_degree_checks():
    results = []
    for n, maximum_degree in [(1, 8), (2, 6), (3, 4), (4, 3)]:
        alpha = Fraction(1, 4)
        c = alpha / (2 * n)
        signed, positive, generators = rows_for(n, c)
        coefficients = ordered_coefficients(signed, maximum_degree)
        A = add(*positive)
        multiplicities = Counter(label(k, j) for k in range(1, n + 1) for j in range(1, n + 1))
        coefficient_l2_squared = sum(a * a for a in A.values())
        assert coefficient_l2_squared == 2 * c * c * sum(m * m for m in multiplicities.values())
        assert coefficient_l2_squared == alpha * alpha * (1 - Fraction(1, 2 * n))
        for d, coefficient in enumerate(coefficients):
            independent = token_coefficient(n, d, c, generators)
            assert coefficient == independent, (n, d, "ordered-token translation")
            positive_power = power(A, d)
            assert all(value >= 0 for value in positive_power.values())
            assert all(abs(value) <= positive_power.get(w, 0) for w, value in coefficient.items())
            l2_squared = sum(value * value for value in coefficient.values())
            assert l2_squared <= (2 * alpha) ** (2 * d)
            results.append({
                "length": n,
                "degree": d,
                "signed_support": len(coefficient),
                "positive_support": len(positive_power),
                "l2_squared": str(l2_squared),
                "positive_identity_coefficient": str(positive_power.get((), 0)),
                "reduced_shorter_support": sum(len(w) < d for w in positive_power),
            })
    return results


def exact_correlation_checks():
    results = []
    for n in range(1, 7):
        for name, u, z in [
            ("free_base", (1,), (2,)),
            ("u_identity", (), (2,)),
            ("z_identity", (1,), ()),
            ("z_equals_u", (1,), (1,)),
            ("base_identity", (), ()),
        ]:
            t = [(3 + j,) for j in range(n + 1)]
            W = multiply_words(t[0], *(multiply_words(u, t[k]) for k in range(1, n + 1)))
            prefixes = []
            g = t[0]
            for k in range(1, n + 1):
                prefixes.append(g)
                g = multiply_words(g, u, t[k])
            assert g == W
            y = multiply_words(z, inverse(W))
            c = Fraction(1, 8 * n)
            linear = defaultdict(Fraction)
            for k, gk in enumerate(prefixes):
                for j, gj in enumerate(prefixes):
                    p = multiply_words(gk, inverse(gj))
                    Y = multiply_words(p, y, inverse(p))
                    positive = multiply_words(Y, W)
                    negative = multiply_words(inverse(Y), W)
                    assert (positive == z) == (k == j)
                    linear[positive] += c
                    linear[negative] -= c
            for xi in [(), (1,), (2,), u, z, multiply_words(u, z), inverse(z)]:
                target_trace = int(multiply_words(inverse(xi), z) == ())
                correlation = Fraction(int(multiply_words(inverse(xi), W) == ()))
                correlation += sum(value for word, value in linear.items()
                                   if multiply_words(inverse(xi), word) == ())
                assert correlation == Fraction(1, 8) * target_trace
            results.append({"length": n, "base_case": name,
                            "diagonal_correlation": str(linear[z])})
    return results


def jacobian_replay():
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    output = json.loads((HERE / "jacobian_output.json").read_text())
    operation = "topology.simplicial.edge_path.word.compute"
    assert output["request"]["operation_id"] == operation
    assert output["request"]["payload"] == payload
    assert output["result"]["operation_id"] == operation
    typed = output["result"]["output"]
    expected = []
    for step in payload["path"]:
        suffix = "" if step["orientation"] == 1 else "^-1"
        expected.append(f"e{step['edge_index'] + 1}{suffix}")
    assert typed["word"] == expected
    assert typed["length"] == len(expected)
    independent_word = reduce_word(
        (step["edge_index"] + 1) * step["orientation"] for step in payload["path"]
    )
    assert independent_word == ()
    return {
        "operation_id": operation,
        "server_version": output["server"]["version"],
        "protocol_version": output["protocol_version"],
        "adapter_exit_code": 0,
        "structured_error": output.get("error"),
        "typed_output": typed,
        "independent_reduced_word": list(independent_word),
        "scope": "One bounded edge-label computation; not evidence for the universal theorem.",
    }


def compute_exact_evidence():
    return {
        "prefixes": exact_prefix_checks(),
        "orientation": exact_orientation_checks(),
        "degrees": exact_degree_checks(),
        "correlations": exact_correlation_checks(),
        "jacobian": jacobian_replay(),
    }


def run_checked(arguments):
    process = subprocess.run(arguments, cwd=ROOT, text=True, capture_output=True, check=False)
    if process.returncode:
        raise RuntimeError(
            f"Command failed ({process.returncode}): {arguments}\n"
            f"{process.stdout[-12000:]}\n{process.stderr[-12000:]}"
        )
    return process.stdout


def verify_universal_theorem():
    version = run_checked([LEAN, "--version"]).strip()
    assert "version 4.31.0," in version, version
    command = [
        ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--project-root", str(ROOT), "--claim", CLAIM,
    ]
    result = json.loads(run_checked(command))
    assert result["status"] == "success", result
    assert result["exit_code"] == 0 and result["audit_exit_code"] == 0, result
    assert result["proof_holes"] == [], result
    assert result["kernel"]["recorded"] is not None, result
    assert result["source_sha256"] == hashlib.sha256((HERE / "Main.lean").read_bytes()).hexdigest()
    assert result["statement_fidelity_sha256"] == hashlib.sha256(
        (HERE / "statement_fidelity.md").read_text().encode()
    ).hexdigest()
    return {
        "claim": CLAIM,
        "version": version,
        "status": result["status"],
        "exit_code": result["exit_code"],
        "audit_exit_code": result["audit_exit_code"],
        "proof_holes": result["proof_holes"],
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
    }


def check_campaign_state():
    for module in ("math_state", "proof_graph_check"):
        run_checked([
            ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}", "check",
            "--project-root", str(ROOT),
        ])
    return {"project_root": str(ROOT), "math_state_exit": 0, "proof_graph_exit": 0}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    exact = compute_exact_evidence()
    lean = verify_universal_theorem()
    validation = check_campaign_state()
    certificate = {
        "claim": CLAIM,
        "result_class": "new_theorem",
        "scope": "Universal algebraic verification theorem, with separately written analytic derivation.",
        "independent_review": "required; this verifier does not supply a reviewer verdict",
        "exact": exact,
        "lean": lean,
        "campaign_validation": validation,
    }
    path = HERE / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        expected = json.loads(path.read_text())
        assert certificate == expected, "The recomputed certificate differs from the stored certificate."
    print(json.dumps({
        "status": "verified",
        "claim": CLAIM,
        "lean_exit_code": lean["exit_code"],
        "proof_holes": lean["proof_holes"],
        "degree_regressions": len(exact["degrees"]),
        "independent_review": "pending",
        "campaign_validation": validation,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
