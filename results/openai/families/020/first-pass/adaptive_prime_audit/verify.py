#!/usr/bin/env python3
"""Exact regression checks accompanying the general proof in report.md."""

import argparse
from fractions import Fraction as Q
from hashlib import sha256
from itertools import combinations, product
import json
from math import comb, prod
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def subsets(n, size=None):
    sizes = range(n + 1) if size is None else [size]
    return [frozenset(c) for k in sizes for c in combinations(range(n), k)]


def fraction(x):
    return f"{x.numerator}/{x.denominator}"


def rref(matrix, columns):
    a = [[Q(x) for x in row] for row in matrix]
    pivots = []
    for j in range(columns):
        k = next((k for k in range(len(pivots), len(a)) if a[k][j]), None)
        if k is None:
            continue
        i = len(pivots)
        a[i], a[k] = a[k], a[i]
        pivot = a[i][j]
        a[i] = [x / pivot for x in a[i]]
        for k in range(len(a)):
            if k != i and a[k][j]:
                factor = a[k][j]
                a[k] = [x - factor * y for x, y in zip(a[k], a[i])]
        pivots.append(j)
    return a[:len(pivots)], pivots


def kernel(matrix, columns):
    a, pivots = rref(matrix, columns)
    basis = []
    for j in range(columns):
        if j not in pivots:
            v = [Q(0)] * columns
            v[j] = Q(1)
            for i, pivot in enumerate(pivots):
                v[pivot] = -a[i][j]
            basis.append(v)
    return basis


def exhaustive_adaptive_checks():
    """Optimize over every stable adaptive divisor map, not random samples."""
    counts = {"records": 0, "optimized_cases": 0, "deletion_edges": 0}
    for n in range(1, 4):
        levels = [subsets(n, t) for t in range(n + 1)]
        states = subsets(n)
        index = {s: i for i, s in enumerate(states)}
        edges = [(s, q, s - {q}) for s in states for q in sorted(s)]
        for values in product(range(3), repeat=len(states)):
            record = dict(zip(states, values))
            if any(record[s] > record[a] for s, _, a in edges):
                continue
            counts["records"] += 1
            parent = list(range(len(states)))

            def find(i):
                while parent[i] != i:
                    i = parent[i]
                return i

            for s, _, a in edges:
                if record[s] == record[a]:
                    parent[find(index[s])] = find(index[a])
            component = {s: find(index[s]) for s in states}
            groups = sorted(set(component.values()))
            for ell in range(1, n + 1):
                for length in range(1, n - ell + 2):
                    end = ell + length - 1
                    weights = {c: [Q(0)] * n for c in groups}
                    for t in range(ell, end + 1):
                        weight = Q(1, length * comb(n, t) * t)
                        for s in levels[t]:
                            for q in s:
                                weights[component[s]][q] += weight
                    for divisor_cap in range(n + 1):
                        bad = {
                            c: frozenset(sorted(
                                range(n), key=lambda q: (-weights[c][q], q)
                            )[:divisor_cap])
                            for c in groups
                        }
                        full = deleted = changed = increment = Q(0)
                        for t in range(ell, end + 1):
                            weight = Q(1, length * comb(n, t) * t)
                            for s in levels[t]:
                                for q in s:
                                    a = s - {q}
                                    f = int(q in bad[component[s]])
                                    d = int(q in bad[component[a]])
                                    step = record[a] - record[s]
                                    assert step >= 0
                                    if step == 0:
                                        assert bad[component[a]] == bad[component[s]]
                                    assert f <= int(step != 0) + d <= step + d
                                    full += weight * f
                                    deleted += weight * d
                                    changed += weight * int(step != 0)
                                    increment += weight * step
                                    counts["deletion_edges"] += 1
                        f_start = sum((Q(record[a]) for a in levels[ell - 1]), Q(0))
                        f_start /= len(levels[ell - 1])
                        f_end = sum((Q(record[s]) for s in levels[end]), Q(0))
                        f_end /= len(levels[end])
                        telescoping = (f_start - f_end) / length
                        error = sum((Q(divisor_cap, n - t + 1)
                                     for t in range(ell, end + 1)), Q(0)) / length
                        assert increment == telescoping
                        assert full <= changed + deleted <= increment + deleted
                        assert deleted <= error
                        assert full <= telescoping + error
                        assert telescoping <= Q(2, length)
                        assert error <= Q(divisor_cap, n - end + 1)
                        counts["optimized_cases"] += 1
    counts["scope"] = (
        "All monotone records valued in {0,1,2} on pools of sizes 1,2,3; "
        "all allowed intervals and divisor caps; exact maximization over all "
        "divisor maps constant on stable-edge components. This is finite "
        "regression evidence, not the proof of the general theorem."
    )
    return counts


def evaluation_kernel_checks():
    primes = [7, 11, 13, 17, 19]
    results = []
    for degree in range(1, 4):
        pool = primes[:degree + 2]
        monomials = [(a, total - a) for total in range(degree + 1)
                     for a in range(total, -1, -1)]
        points = [(0, 0)] + [(p * k, p * p * k)
                            for p in pool for k in range(1, degree + 2)]
        columns = len(monomials)
        paths = {}
        for state in subsets(len(pool)):
            modulus = prod(pool[i] for i in state)
            residue = [(x, y) for x, y in points
                       if x % modulus == y % modulus == 0]
            matrix = [[x ** a * y ** b for a, b in monomials] for x, y in residue]
            space = kernel(matrix, columns)
            rank = columns - len(space)
            if not state:
                assert rank == columns and not space
                patch, minors = "plane", (1, 1, 1)
            elif len(state) == 1:
                p = pool[next(iter(state))]
                assert len(residue) == degree + 2 and rank == degree + 1
                for v in space:
                    coefficients = [Q(0)] * (degree + 1)
                    for coefficient, (a, b) in zip(v, monomials):
                        coefficients[a + b] += coefficient * p ** b
                    assert not any(coefficients)
                linear = [Q(p) if (a, b) == (1, 0)
                          else Q(-1) if (a, b) == (0, 1) else Q(0)
                          for a, b in monomials]
                assert all(sum(x * y for x, y in zip(row, linear)) == 0
                           for row in matrix)
                patch, minors = f"line:y={p}x", (1, p, p)
            else:
                assert residue == [(0, 0)] and rank == 1
                assert all(v[0] == 0 for v in space)
                patch, minors = "point:(0,0)", (1, 1, 1)
            record = rank * (columns + 1) + rank
            paths[state] = (record, patch, minors, space)
        edge_count = 0
        for state, (record, _, minors, space) in paths.items():
            for q in state:
                a = state - {q}
                previous = paths[a]
                assert record <= previous[0]
                assert all(
                    all(sum(u * v for u, v in zip(
                        [x ** i * y ** j for i, j in monomials], vector)) == 0
                        for x, y in points
                        if x % prod(pool[i] for i in state) ==
                        y % prod(pool[i] for i in state) == 0)
                    for vector in previous[3]
                )
                if record == previous[0]:
                    assert minors == previous[2]
                prime = pool[q]
                full_bad = any(m % prime == 0 for m in minors)
                deleted_bad = any(m % prime == 0 for m in previous[2])
                assert full_bad <= (record != previous[0]) + deleted_bad
                edge_count += 1
        results.append({
            "degree": degree,
            "pool": pool,
            "point_count": len(points),
            "rank_record_bound_B0": (columns + 1) ** 2,
            "states": len(paths),
            "edges": edge_count,
            "singleton_full_bad_fraction": "1/1",
            "singleton_deleted_bad_fraction": "0/1",
            "interpretation": (
                "Actual full evaluation kernels with two stages and empty "
                "second block; deterministic primitive line equation px-y "
                "and first nonzero Jacobian column. The full minor targets "
                "the selected prime. This is not a manuscript refutation."
            )
        })
    return results


def constant_checks():
    cases = []
    for r, ambient, eps, e_one, record_bound in [
        (1, 2, Q(1, 10), Q(3, 2), 49),
        (3, 7, Q(1, 100), Q(5), 500),
        (5, 10, Q(2), Q(1, 3), 1234)
    ]:
        gamma = min(Q(1), eps / (16 * r * (r + 1)))
        xi = min(Q(1, 4), gamma / (4 * (e_one + r * gamma)),
                 eps / (16 * ambient * (e_one + 2 * r * gamma)))
        length = (8 * r * record_bound / xi).__floor__() + 1
        zeta = gamma / (2 * (length + 1))
        assert xi * (e_one + r * gamma) < gamma / 2
        assert gamma * r * (r + 1) < eps / 4
        assert ambient * xi * (e_one + 2 * r * gamma) < eps / 4
        assert zeta * (length + 1) <= gamma
        assert r * record_bound / (xi * length) < Q(1, 8)
        for increment in [Q(0), Q(1, 7), e_one]:
            ell = ((increment + gamma) / zeta).__ceil__()
            assert increment + gamma <= zeta * ell
            assert zeta * (ell + length - 1) <= increment + 2 * gamma
        cases.append({
            "r": r, "N": ambient, "epsilon": fraction(eps),
            "E1": fraction(e_one), "B0": record_bound,
            "gamma": fraction(gamma), "xi": fraction(xi),
            "T": length, "zeta": fraction(zeta)
        })
    return cases


def formal_check():
    record = json.loads((ROOT / "lean_check.json").read_text())
    assert record["status"] == "success"
    assert record["exit_code"] == record["audit_exit_code"] == 0
    assert record["proof_holes"] == []
    assert record["environment_failure"] == ""
    assert record["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    assert Path(record["source"]).resolve() == (ROOT / "Main.lean").resolve()
    assert Path(record["statement_fidelity"]).resolve() == (ROOT / "statement_fidelity.md").resolve()
    for source, field in [
        ("Main.lean", "source_sha256"),
        ("statement_fidelity.md", "statement_fidelity_sha256")
    ]:
        content = (ROOT / source).read_bytes()
        assert sha256(content).hexdigest() == record[field]
    return {
        "claim": "C_ADAPTIVE_FORMAL",
        "compiler": "Lean 4.31.0",
        "exit_code": 0,
        "axiom_audit_exit_code": 0,
        "proof_holes": [],
        "record": "lean_check.json",
        "scope": "Regular-incidence and all-parameter averaging core; see statement_fidelity.md.",
        "independent_statement_fidelity_review": "not supplied by this certificate"
    }


def compute():
    result = {
        "result_class": "exact_verification_theorem",
        "claim": "C_ADAPTIVE_FINITE",
        "general_proof": "report.md, Theorems 1-3; Main.lean as delimited by statement_fidelity.md",
        "finite_bound": (
            "E[bad_fraction] <= (F(ell-1)-F(ell+T-1))/T "
            "+ (D/T)*sum(t=ell..ell+T-1, 1/(n-t+1)) "
            "<= (B0-1)/T + D/(n-ell-T+2)"
        ),
        "exhaustive_adaptive_checks": exhaustive_adaptive_checks(),
        "actual_evaluation_kernel_checks": evaluation_kernel_checks(),
        "constant_selection_checks": constant_checks(),
        "formal_core": formal_check(),
        "limitations": [
            "No counterexample to a literal manuscript assertion is claimed.",
            "Finite computations are not substituted for the general proof.",
            "The full affine-counting and density theorems are not certified.",
            "Novelty and publishable significance require independent review."
        ]
    }
    adapter_path = ROOT / "jacobian_result.json"
    if adapter_path.exists():
        adapter = json.loads(adapter_path.read_text())
        payload = json.loads((ROOT / "jacobian_payload.json").read_text())
        points = [(0, 0), (7, 49), (14, 98), (21, 147)]
        monomials = [(0, 0), (1, 0), (0, 1), (2, 0), (1, 1), (0, 2)]
        rational_matrix = [[x ** a * y ** b for a, b in monomials]
                           for x, y in points]
        assert payload == {"matrix": {
            "prime": 7,
            "columns": 6,
            "entries": [[entry % 7 for entry in row] for row in rational_matrix]
        }}
        rational_rank = len(rref(rational_matrix, 6)[1])
        assert rational_rank == 3
        assert adapter["server"]["version"] == "0.14.0"
        assert adapter["protocol_version"] == "2025-11-25"
        assert adapter["request"]["operation_id"] == "prime_field.matrix.rank.compute"
        assert adapter["result"]["operation_id"] == "prime_field.matrix.rank.compute"
        assert adapter["request"]["payload"] == payload
        assert adapter["result"]["output"]["rank"] == 1
        assert adapter["result"]["output"]["source"] == payload
        result["jacobian_cross_check"] = {
            "operation": "prime_field.matrix.rank.compute",
            "rank": 1,
            "rational_rank": rational_rank,
            "adapter_status": "completed",
            "timed_out": False,
            "structured_error": None,
            "source_points": [list(point) for point in points],
            "monomials": [list(exponent) for exponent in monomials],
            "payload": "jacobian_payload.json",
            "typed_output": "jacobian_result.json"
        }
    else:
        raise FileNotFoundError("Run the documented Jacobian operation before certification.")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the exact regression certificate")
    args = parser.parse_args()
    result = compute()
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(result, indent=2) + "\n")
    expected = json.loads(path.read_text())
    if expected != result:
        raise AssertionError("Certificate does not match the exact replay.")
    print(json.dumps({
        "certificate": "written" if args.write else "verified",
        "monotone_records": result["exhaustive_adaptive_checks"]["records"],
        "optimized_cases": result["exhaustive_adaptive_checks"]["optimized_cases"],
        "actual_kernel_degrees": [x["degree"] for x in result["actual_evaluation_kernel_checks"]],
        "lean_exit_code": result["formal_core"]["exit_code"],
        "proof_holes": result["formal_core"]["proof_holes"]
    }))


if __name__ == "__main__":
    main()
