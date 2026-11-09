#!/usr/bin/env python3
"""Replay exact probes and the official Lean certificate for the unbounded core."""

import argparse
from fractions import Fraction
from functools import cache
from itertools import product
import json
from math import factorial, isqrt
from pathlib import Path
import subprocess
import sys


def add(a, b):
    out = a.copy()
    for exponent, coefficient in b.items():
        out[exponent] = out.get(exponent, 0) + coefficient
        if not out[exponent]:
            del out[exponent]
    return out


def scale(a, scalar):
    return {e: scalar * c for e, c in a.items() if scalar * c}


def multiply(a, b):
    out = {}
    for e, c in a.items():
        for f, d in b.items():
            g = tuple(x + y for x, y in zip(e, f))
            out[g] = out.get(g, 0) + c * d
    return {e: c for e, c in out.items() if c}


def power(a, k, n):
    out = {(0,) * n: 1}
    while k:
        if k & 1:
            out = multiply(out, a)
        a = multiply(a, a)
        k >>= 1
    return out


def derivative(a, i):
    out = {}
    for e, c in a.items():
        if e[i]:
            f = list(e)
            f[i] -= 1
            out[tuple(f)] = c * e[i]
    return out


def determinant(a):
    n = len(a)
    if not n:
        return 1
    a = [row[:] for row in a]
    sign, previous = 1, 1
    for k in range(n - 1):
        pivot_row = next((i for i in range(k, n) if a[i][k]), None)
        if pivot_row is None:
            return 0
        if pivot_row != k:
            a[k], a[pivot_row] = a[pivot_row], a[k]
            sign = -sign
        pivot = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                numerator = pivot * a[i][j] - a[i][k] * a[k][j]
                quotient, remainder = divmod(numerator, previous)
                assert remainder == 0, "Bareiss division must be exact"
                a[i][j] = quotient
            a[i][k] = 0
        previous = pivot
    return sign * a[-1][-1]


def matrix_multiply(a, b):
    n = len(a)
    return [[sum(a[i][k] * b[k][j] for k in range(n))
             for j in range(n)] for i in range(n)]


def characteristic_coefficients(a):
    """Interpolate independent integer determinants, without using traces."""
    n = len(a)
    values = [determinant([[y * (i == j) - a[i][j] for j in range(n)]
                           for i in range(n)]) for y in range(n + 1)]
    coefficients = [Fraction(0) for _ in range(n + 1)]
    binomial = [Fraction(1)]
    for k in range(n + 1):
        for i, c in enumerate(binomial):
            coefficients[i] += values[0] * c
        values = [b - a for a, b in zip(values, values[1:])]
        if k < n:
            next_binomial = [Fraction(0)] * (len(binomial) + 1)
            for i, c in enumerate(binomial):
                next_binomial[i] -= k * c / (k + 1)
                next_binomial[i + 1] += c / (k + 1)
            binomial = next_binomial
    assert all(c.denominator == 1 for c in coefficients)
    return [int(c) for c in coefficients]


def is_prime(p):
    return p >= 2 and all(p % d for d in range(2, isqrt(p) + 1))


def first_prime_above(bound):
    p = bound + 1
    while not is_prime(p):
        p += 1
    return p


def exponential(traces, p):
    d = len(traces)
    s = [0] + [-t * pow(k, -1, p) % p
               for k, t in enumerate(traces, 1)]
    result, term, factorial = [1] + [0] * (d * d), [1], 1
    for j in range(1, d + 1):
        out = [0] * (len(term) + d)
        for a, c in enumerate(term):
            for b in range(1, d + 1):
                out[a + b] = (out[a + b] + c * s[b]) % p
        term = out
        factorial = factorial * j % p
        inverse = pow(factorial, -1, p)
        for a, c in enumerate(term):
            result[a] = (result[a] + c * inverse) % p
    return result


def evaluate(a, z, p):
    return sum(c * product_int(pow(x, k, p) for x, k in zip(z, e))
               for e, c in a.items()) % p


def product_int(items):
    out = 1
    for item in items:
        out *= item
    return out


def quotient_probe(name, ell, relations, v, grid=False, flat=False):
    n = len(relations)
    assert n in (1, 2)
    assert ell >= 2
    assert all(sum(e) < ell for r in relations for e in r)
    omega = max((sum(e) for e in v), default=0)
    basis = list(product(range(ell), repeat=n))
    d, tau = ell ** n, (ell - 1,) * n
    l0 = d * omega + n * (ell - 1)
    cutoff = n * (ell - 1) + ell * l0 + d * d + 10
    p = first_prime_above(cutoff)

    @cache
    def reduce_monomial(e):
        i = next((i for i in range(n) if e[i] >= ell), None)
        if i is None:
            return {e: 1}
        out = {}
        for f, c in relations[i].items():
            g = tuple(e[j] + f[j] - (ell if i == j else 0)
                      for j in range(n))
            assert sum(g) < sum(e)
            out = add(out, scale(reduce_monomial(g), c))
        return out

    def reduce_polynomial(a):
        out = {}
        for e, c in a.items():
            out = add(out, scale(reduce_monomial(e), c))
        return out

    columns = [reduce_polynomial(multiply(v, {e: 1})) for e in basis]
    matrix = [[column.get(e, 0) for column in columns] for e in basis]
    f = []
    for i, r in enumerate(relations):
        e = tuple(ell if i == j else 0 for j in range(n))
        f.append(add({e: 1}, scale(r, -1)))
    jacobian_entries = [[derivative(fi, j) for j in range(n)] for fi in f]
    jacobian = jacobian_entries[0][0]
    if n == 2:
        jacobian = add(multiply(jacobian_entries[0][0], jacobian_entries[1][1]),
                       scale(multiply(jacobian_entries[0][1],
                                      jacobian_entries[1][0]), -1))
    powers = [[power(r, j, n) for j in range(l0 + 1)] for r in relations]
    trace_residues, direct_traces, residue_values = [], [], []
    current = [[int(i == j) for j in range(d)] for i in range(d)]
    for k in range(1, d + 1):
        current = matrix_multiply(current, matrix)
        actual = sum(current[i][i] for i in range(d))
        numerator_base = multiply(power(v, k, n), jacobian)
        residual_degree = max((sum(e) for e in numerator_base), default=-1)
        effective = max(-1, residual_degree - n * (ell - 1))
        residue = 0
        for j in product(range(l0 + 1), repeat=n):
            if sum(j) > l0:
                continue
            target = tuple(tau[i] + ell * j[i] for i in range(n))
            assert sum(target) < p - 1
            assert ell * l0 < p - 1
            if sum(j) > effective:
                continue
            numerator = numerator_base
            for i in range(n):
                numerator = multiply(numerator, powers[i][j[i]])
            residue += numerator.get(target, 0)
        assert residue == actual, (name, k, residue, actual)
        direct_traces.append(actual)
        residue_values.append(residue)
        trace_residues.append(residue % p)
    coefficients = characteristic_coefficients(matrix)
    e = exponential(trace_residues, p)
    assert [e[d - i] for i in range(d + 1)] == [c % p for c in coefficients]
    grid_coefficients = [
        sum(evaluate({(i,): c for i, c in enumerate(e) if c}, (z,), p)
            * pow(z, -(d - index), p) for z in range(1, p))
        * pow(p - 1, -1, p) % p
        for index in range(d + 1)
    ]
    assert grid_coefficients == [c % p for c in coefficients]
    h_values = {
        z: -sum(t * pow(k, -1, p) * pow(z, k, p)
                for k, t in enumerate(trace_residues, 1)) % p
        for z in range(1, p)
    }
    if flat:
        for z, expected in h_values.items():
            total = 0
            for k in range(1, d + 1):
                for j in product(range(l0 + 1), repeat=n):
                    if sum(j) > l0:
                        continue
                    for u in product(range(1, p), repeat=n):
                        total -= (
                            pow(k, -1, p) * pow(z, k, p)
                            * pow(evaluate(v, u, p), k, p)
                            * evaluate(jacobian, u, p)
                            * product_int(
                                pow(evaluate(relations[i], u, p), j[i], p)
                                * pow(u[i], -(tau[i] + ell * j[i]), p)
                                for i in range(n)))
            total = total * pow(pow(p - 1, n, p), -1, p) % p
            assert total == expected, (name, z, total, expected)
    flattened_coefficients = [
        sum(pow(factorial(h), -1, p) * pow(h_values[z], h, p)
            * pow(z, -(d - index), p)
            for z in range(1, p) for h in range(d + 1))
        * pow(p - 1, -1, p) % p
        for index in range(d + 1)
    ]
    assert flattened_coefficients == [c % p for c in coefficients]
    for y in (0, 1, p - 1):
        merged_value = (
            sum(pow(factorial(h), -1, p) * pow(h_values[z], h, p)
                * pow(z, -(d - index), p) * pow(y, index, p)
                for index in range(d + 1)
                for z in range(1, p) for h in range(d + 1))
            * pow(p - 1, -1, p) % p)
        assert merged_value == sum(c * pow(y, i, p)
                                   for i, c in enumerate(coefficients)) % p
    grid_trace = None
    if grid:
        grid_trace = 0
        inverse = pow(pow(p - 1, n, p), -1, p)
        for z in product(range(1, p), repeat=n):
            r_values = [evaluate(r, z, p) for r in relations]
            weight = 0
            for j in product(range(l0 + 1), repeat=n):
                if sum(j) <= l0:
                    weight += product_int(
                        pow(r_values[i], j[i], p)
                        * pow(z[i], -(tau[i] + ell * j[i]), p)
                        for i in range(n))
            grid_trace += (evaluate(v, z, p) * evaluate(jacobian, z, p)
                           * weight)
        grid_trace = grid_trace * inverse % p
        assert grid_trace == trace_residues[0]
    for modulus in (2, 3, 4, 6, 8, 9):
        assert [x % modulus for x in direct_traces] == [
            x % modulus for x in residue_values]
    return {
        "name": name, "n": n, "ell": ell, "Omega": omega, "D": d,
        "L0": l0, "strict_prime_cutoff": cutoff,
        "least_admissible_prime": p,
        "trace_values": direct_traces, "characteristic_ascending": coefficients,
        "integral_trace_identity_reduced_modulo": [2, 3, 4, 6, 8, 9],
        "all_indices_checked": list(range(d + 1)),
        "full_trace_grid_k1": grid_trace,
        "direct_flattened_inner_sum": flat,
        "merged_determinant_evaluation_points": [0, 1, p - 1]
    }


def check_jacobian(directory):
    envelope = json.loads((directory / "jacobian_output.json").read_text())
    payload = json.loads((directory / "jacobian_payload.json").read_text())
    assert envelope["request"]["payload"] == payload
    assert envelope["request"]["operation_id"] == (
        "matrix.symbolic.characteristic_polynomial.compute")
    result = envelope["result"]["output"]
    assert result["degree"] == 2
    assert result["convention"] == "DET_LAMBDA_I_MINUS_A"
    assert len(result["coefficients_descending"]) == 3
    expected = [(1, 0), (-2, 1), (1, 2)]
    for coefficient, (c, e) in zip(result["coefficients_descending"], expected):
        assert coefficient["variables"] == ["t"]
        assert coefficient["denominator"]["terms"] == [
            {"coefficient": {"num": "1", "den": "1"}, "exponents": [0]}]
        assert coefficient["numerator"]["terms"] == [
            {"coefficient": {"num": str(c), "den": "1"}, "exponents": [e]}]
    return {
        "operation_id": envelope["request"]["operation_id"],
        "server": envelope["server"], "protocol_version": envelope["protocol_version"],
        "adapter_status": "complete", "adapter_error": None,
        "timeout": False,
        "meaning": "Exactly det(yI-[[0,-t^2],[1,2t]])=(y-t)^2 over QQ[t]; not a universal residue proof."
    }


def derivative_probes():
    out = []
    for d in (0, 1, 2, 6):
        p = first_prime_above(d + 1)
        coefficients = [(-1) ** k * (k + 1) for k in range(d + 1)]
        for z in range(p):
            grid = sum(
                k * pow(z, k - 1, p) * pow(u, -k, p)
                * sum(c * pow(u, i, p) for i, c in enumerate(coefficients))
                for u in range(1, p) for k in range(1, d + 1)
            ) * pow(p - 1, -1, p) % p
            direct = sum(k * coefficients[k] * pow(z, k - 1, p)
                         for k in range(1, d + 1)) % p
            assert grid == direct, (d, p, z, grid, direct)
        out.append({"degree": d, "prime": p, "points_checked": p})
    return out


def formal_replay(directory):
    root = directory.parent.parent.resolve()
    python = "$WORKSPACE/argus-live-update/.venv/bin/python"
    command = [
        python, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(directory / "Main.lean"),
        "--project-root", str(root), "--claim", "C_UNIVERSAL_BRIDGE",
        "--statement-fidelity", str(directory / "statement_fidelity.md")
    ]
    completed = subprocess.run(command, cwd=root, capture_output=True, text=True)
    (directory / "lean_verify_output.json").write_text(completed.stdout)
    if completed.stderr:
        sys.stderr.write(completed.stderr)
    if completed.returncode:
        raise RuntimeError(
            f"Official Lean verification failed ({completed.returncode}):\n"
            + completed.stdout)
    result = json.loads(completed.stdout)
    assert result["status"] == "success"
    assert result["exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["kernel"]["recorded"] is not None
    assert result["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    checks = []
    for module in ("math_state", "proof_graph_check"):
        check_command = [
            python, "-m", f"argus_skill.verticals.math.{module}", "check",
            "--project-root", str(root)
        ]
        check = subprocess.run(
            check_command, cwd=root, capture_output=True, text=True)
        checks.append({
            "module": module, "project_root": str(root),
            "exit_code": check.returncode,
            "stdout": check.stdout, "stderr": check.stderr
        })
    for check in checks:
        if check["exit_code"]:
            raise RuntimeError(f"Campaign-local structural check failed: {check}")
    return result, checks


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--finite-only", action="store_true")
    args = parser.parse_args()
    if args.finite_only and args.write_certificate:
        parser.error("--finite-only cannot replace the unbounded certificate")
    directory = Path(__file__).resolve().parent
    probes = []
    for ell in (2, 3):
        probes.append(quotient_probe(
            f"nilpotent-univariate-ell{ell}", ell, [{}], {(1,): 1}, grid=True))
    for t in (-1, 0, 1, 2):
        probes.append(quotient_probe(
            f"double-root-t{t}", 2,
            [{(1,): 2 * t, (0,): -t * t}], {(1,): 1}, flat=(t == 1)))
        probes.append(quotient_probe(
            f"triple-root-t{t}", 3,
            [{(2,): 3 * t, (1,): -3 * t * t, (0,): t ** 3}],
            {(2,): 1}))
    probes.append(quotient_probe(
        "constant-objective", 2, [{(1,): 2, (0,): -1}], {(0,): -3}))
    for t, u, s in ((0, 0, 0), (0, 0, 1), (1, 1, 0), (1, -1, 2)):
        probes.append(quotient_probe(
            f"coupled-specialization-{t}-{u}-{s}", 2,
            [{(1, 0): 2 * t, (0, 0): -t * t},
             {(1, 0): s, (0, 1): 2 * u, (0, 0): -u * u}],
            {(1, 0): 1, (0, 1): 1}, grid=(t == u == s == 0)))
    probes.append(quotient_probe(
        "cubic-coupled", 3, [{(0, 1): 1}, {(1, 0): 1}],
        {(1, 0): 1, (0, 1): 1}))
    certificate = {
        "result_class": "finite_verification",
        "status": "finite_checks_passed_unbounded_proof_pending",
        "scope": "Deterministic exact probes, not exhaustive or universal.",
        "independent_review": "pending",
        "probe_count": len(probes), "probes": probes,
        "derivative_probes": derivative_probes(),
        "jacobian": check_jacobian(directory)
    }
    if not args.finite_only:
        lean, checks = formal_replay(directory)
        certificate.update({
            "result_class": "improved_bound",
            "status": "engineer_verified_awaiting_independent_review",
            "scope": "Unbounded proof in report.md; universal algebraic bridge compiled by Lean; finite tests are supplementary.",
            "theorem": "Under exactly the manuscript prime range, characteristic coefficients are in F_max(a+2,5). Controlled multiplication determinants with common input evaluators in F_a have evaluators in F_max(a+3,5) and the original size bounds, uniformly under all specializations.",
            "formal_scope": "All finite square matrices, arbitrary-ring normalized generating Bezoutian trace bridge, and their composition; actual Laurent/basis identifications and complexity are proved in prose.",
            "formal_limitations": [
                "The actual multivariate Laurent functional and quotient-basis construction are not definitions in Lean.",
                "The actual Bezoutian's structural hypotheses are discharged in the unbounded report, not by the kernel.",
                "The hierarchy machines, degree/norm bounds and specialization argument are mathematical proofs in the report, not fully formalized programs."
            ],
            "novelty_status": "not_claimed",
            "significance_status": "pending_independent_review",
            "campaign_complete": False,
            "lean": lean,
            "campaign_local_checks": checks
        })
    if args.write_certificate:
        (directory / "exact_certificate.json").write_text(
            json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "status": certificate["status"], "probe_count": len(probes),
        "result_class": certificate["result_class"]
    }))


if __name__ == "__main__":
    main()
