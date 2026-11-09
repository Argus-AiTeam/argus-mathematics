#!/usr/bin/env python3
"""Replay exact algebra used in report.md, not the continuum proof itself."""

import argparse
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent


def constant(c, n):
    return {(0,) * n: c} if c else {}


def variable(i, n):
    e = [0] * n
    e[i] = 1
    return {tuple(e): 1}


def add(*polynomials):
    result = {}
    for p in polynomials:
        for e, c in p.items():
            result[e] = result.get(e, 0) + c
    return {e: c for e, c in result.items() if c}


def scale(c, p):
    return {e: c * a for e, a in p.items() if c * a}


def multiply(p, q):
    result = {}
    for e, a in p.items():
        for f, b in q.items():
            g = tuple(x + y for x, y in zip(e, f, strict=True))
            result[g] = result.get(g, 0) + a * b
    return {e: c for e, c in result.items() if c}


def power(p, exponent):
    n = len(next(iter(p)))
    result = constant(1, n)
    for _ in range(exponent):
        result = multiply(result, p)
    return result


def dot(u, v):
    return add(*(multiply(a, b) for a, b in zip(u, v, strict=True)))


def determinant(matrix):
    result = {}
    n = len(matrix)
    for p in itertools.permutations(range(n)):
        inversions = sum(p[i] > p[j] for i in range(n) for j in range(i + 1, n))
        term = constant((-1) ** inversions, len(next(iter(matrix[0][0]))))
        for i in range(n):
            term = multiply(term, matrix[i][p[i]])
        result = add(result, term)
    return result


def chart_data(n):
    t = [variable(i, n) for i in range(n)]
    one = constant(1, n)
    d = add(one, *(multiply(x, x) for x in t))
    matrix = [
        [
            add(d if i == j else {}, scale(-1, multiply(t[i], t[j])))
            for j in range(n)
        ]
        for i in range(n)
    ]
    w = [one] + t
    columns = [
        [
            add(d if row == j + 1 else {}, scale(-1, multiply(t[j], w[row])))
            for row in range(n + 1)
        ]
        for j in range(n)
    ]
    for j in range(n):
        assert not dot(w, columns[j]), "Projection column not perpendicular to (1,t)"
        for i in range(n):
            assert dot(columns[i], columns[j]) == multiply(d, matrix[i][j]), (
                "The claimed projection Gram matrix is wrong"
            )
    expected = power(d, n - 1)
    assert determinant(matrix) == expected, "Affine projection determinant identity failed"
    return matrix, expected


def rational_function(p, variables):
    n = len(variables)

    def sparse(q):
        return {
            "terms": [
                {"exponents": list(e), "coefficient": {"num": str(c), "den": "1"}}
                for e, c in sorted(q.items(), reverse=True)
            ]
        }

    return {
        "domain": "QQ",
        "variables": variables,
        "numerator": sparse(p),
        "denominator": sparse(constant(1, n)),
    }


def jacobian_payload():
    matrix, _ = chart_data(3)
    variables = ["x", "y", "z"]
    return {
        "matrix": {
            "variables": variables,
            "entries": [[rational_function(p, variables) for p in row] for row in matrix],
        }
    }


def check_projector_identity(k):
    n = 2 * k
    u = [variable(i, n) for i in range(k)]
    v = [variable(i + k, n) for i in range(k)]
    difference = [
        [
            add(multiply(u[i], u[j]), scale(-1, multiply(v[i], v[j])))
            for j in range(k)
        ]
        for i in range(k)
    ]
    actual = add(*(multiply(p, p) for row in difference for p in row))
    expected = add(
        power(dot(u, u), 2),
        power(dot(v, v), 2),
        scale(-2, power(dot(u, v), 2)),
    )
    assert actual == expected, "Frobenius distance polynomial identity failed"


def check_euclidean_basis():
    matrices = []
    for diagonal in ((1, -1, 0, 0), (1, 1, -2, 0), (1, 1, 1, -3)):
        matrices.append([[diagonal[i] if i == j else 0 for j in range(4)] for i in range(4)])
    for a, b in itertools.combinations(range(4), 2):
        matrices.append(
            [[int((i, j) in ((a, b), (b, a))) for j in range(4)] for i in range(4)]
        )
    norms = [2, 6, 12] + [2] * 6
    for i, a in enumerate(matrices):
        assert sum(a[j][j] for j in range(4)) == 0
        for j, b in enumerate(matrices):
            product = sum(a[r][s] * b[s][r] for r in range(4) for s in range(4))
            assert product == (norms[i] if i == j else 0), "Nine-coordinate Gram failure"
    assert len(matrices) == 9
    return norms


def exact_results():
    for k in (3, 4):
        chart_data(k - 1)
        check_projector_identity(k)
    norms = check_euclidean_basis()
    c = frozenset(range(6))
    triples = [frozenset(t) for t in itertools.combinations(c, 3)]
    complementary_pairs = {frozenset((t, c - t)) for t in triples}
    pairs = list(itertools.combinations(c, 2))
    assert len(triples) == 20 and len(complementary_pairs) == 10 and len(pairs) == 15
    assert all(sum(set(p) <= t for t in triples) == 4 for p in pairs)
    assert 2 * len(pairs) == 3 * len(complementary_pairs) == 30
    dimensions = []
    for k in (3, 4):
        m = k * (k + 1) // 2
        h = k * (k - 1) // 2
        for s in range(1, k + 1):
            a = m - s
            d = k - s
            assert d == a - h
            assert d + h - 1 == a - 1
            assert 1 + (k - 1) + (h - 1) == m - 1
            assert 1 + (s - 1) + (a - 1) == m - 1
            assert (a - 1 >= h) == (s < k)
            dimensions.append(
                {"k": k, "s": s, "m": m, "h": h, "a": a, "level_dimension": d}
            )
    return {
        "chart_projection": {
            "dimensions": [3, 4],
            "D": "1 + sum(t_i^2)",
            "numerator_matrix": "D*Id - t*t^T",
            "determinant": "D^(k-2)",
            "projection_Gram_determinant": "1/D",
            "orthogonality_and_Gram_identities": "exact integer polynomial identities",
        },
        "projector_distance": {
            "dimensions": [3, 4],
            "identity": "tr((u*u^T-v*v^T)^2)=(u.u)^2+(v.v)^2-2*(u.v)^2",
        },
        "nine_coordinate_basis_squared_norms": norms,
        "six_label_incidence": {
            "pairs": 15,
            "triples": 20,
            "complementary_pairs": 10,
            "minimum_triangle_pair_incidences": 30,
            "maximum_triangle_pair_incidences": 30,
        },
        "dimension_cases": dimensions,
    }


def check_jacobian():
    operation = "matrix.symbolic.determinant.compute"
    payload = json.loads((HERE / "jacobian_input.json").read_text())
    assert payload == jacobian_payload(), "Jacobian input is not the chart-projection matrix"
    contract = json.loads((HERE / "jacobian_contract.json").read_text())
    assert contract["result"]["operation"]["operation_id"] == operation
    response = json.loads((HERE / "jacobian_output.json").read_text())
    assert response["schema_version"] == 1
    assert response["protocol_version"] == contract["protocol_version"] == "2025-11-25"
    assert response["server"]["name"] == contract["server"]["name"] == "jacobian"
    assert response["server"]["version"] == contract["server"]["version"] == "0.14.0"
    assert response["transport"] == "mcp-stdio" and response["tool"] == "math.run"
    assert response["request"] == {"operation_id": operation, "payload": payload}
    result = response["result"]
    assert result["operation_id"] == operation
    _, expected = chart_data(3)
    assert result["output"] == {
        "determinant": rational_function(expected, ["x", "y", "z"]),
        "method": "SYMPY_BAREISS",
    }, "Typed Jacobian determinant differs from the independent polynomial calculation"
    assert isinstance(result["runtime_ms"], int) and result["runtime_ms"] >= 0
    return {
        "operation_id": operation,
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "runtime_ms": result["runtime_ms"],
        "adapter_exit_code": 0,
        "adapter_error": None,
        "timed_out": False,
    }


def check_retained_finite_certificate():
    relative = (
        "research/ten_label_obstruction/certificates/"
        "C9000156_COMB-3e41b9605d2fdf73.json"
    )
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C9000156_COMB"),
        key=lambda c: c["version"],
    )
    assert claim["version"] == 5, "Retained finite claim version changed"
    certificate = json.loads((ROOT / relative).read_text())
    subject = {
        "kind": "claim",
        "subject_id": claim["claim_id"],
        "content_hash": claim["content_hash"],
    }
    assert certificate["subject"] == subject
    assert certificate["tier"] == "mechanical" and certificate["verdict"] == "supports"
    check = certificate["lean_check"]
    assert check["status"] == "success"
    assert certificate["produced_by"] == "lean_evidence/lean 4.31.0"
    assert check["exit_code"] == check["audit_exit_code"] == 0
    assert check["proof_holes"] == []
    for field in ("lean_source", "statement_fidelity"):
        retained = certificate[field]
        assert (ROOT / retained["path"]).read_text() == retained["text"], (
            f"Retained {field} no longer matches its certified text"
        )
    assert claim["formal_statement"] == certificate["lean_source"]["text"]
    assert any(
        e["subject"] == subject
        and e["tier"] == "mechanical"
        and e["verdict"] == "supports"
        and e["evidence_id"] == certificate["evidence_id"]
        for e in state["evidence"]
    ), "The retained mechanical certificate is not attached to the current claim"
    reviewer = "reviewer:gpt-6.1-sol:62918ef4ee29"
    assert any(
        e["subject"] == subject
        and e["tier"] == "judgement"
        and e["verdict"] == "supports"
        and e["produced_by"] == reviewer
        and e["artifact"] == relative
        for e in state["evidence"]
    ), "The retained current-version independent review is missing"
    return {"claim_id": claim["claim_id"], "version": 5, "certificate": relative, "reviewer": reviewer}


def main():
    if not __debug__:
        raise SystemExit("Verification requires Python assertions; do not use -O.")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--emit-jacobian-payload", action="store_true")
    parser.add_argument("--emit-calculations", action="store_true")
    args = parser.parse_args()
    if args.emit_jacobian_payload:
        (HERE / "jacobian_input.json").write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
        print("Wrote the exact affine-projection numerator matrix payload.")
        return
    calculations = exact_results()
    if args.emit_calculations:
        print(json.dumps(calculations, indent=2))
        return
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    assert certificate["exact_calculations"] == calculations, "Exact certificate differs from replay"
    assert certificate["jacobian"] == check_jacobian(), "Jacobian receipt differs from replay"
    assert certificate["retained_finite_core"] == check_retained_finite_certificate(), (
        "Retained finite evidence differs from its declared binding"
    )
    print(json.dumps({
        "exact_algebra": "verified",
        "dimension_cases": len(calculations["dimension_cases"]),
        "continuum_proof_machine_checked": False,
        "continuum_independent_review": "pending",
        "finite_core_recompiled_or_replayed": False,
        "retained_finite_source_and_review_bindings": "verified",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
