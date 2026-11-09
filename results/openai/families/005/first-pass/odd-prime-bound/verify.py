#!/usr/bin/env python3
"""Replay exact arithmetic tests and the source-bound Lean core certificate."""

import argparse
from fractions import Fraction as Q
from hashlib import sha256
import json
from math import comb, isqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent


def residue(x, p):
    x = Q(x)
    if x.denominator % p == 0:
        raise AssertionError(f"nonintegral residue: {x}, p={p}")
    return x.numerator * pow(x.denominator, -1, p) % p


def valuation_at_least(x, p, bound):
    x = Q(x)
    if bound >= 0:
        return (x / p**bound).denominator % p != 0
    return (x * p**(-bound)).denominator % p != 0


def moments(H):
    c = [Q(comb(2*k, k), 4**k) for k in range(H + 2)]
    m = [Q(0) if i % 2 else 2 / ((i + 1) * c[i // 2])
         for i in range(H + 2)]
    km, kp = [Q(0)] * (H + 2), [Q(0)] * (H + 2)
    km[1] = Q(2)
    for d in range(2, H + 2):
        km[d] = ((d-1)*km[d-2] + m[d-2] + m[d-1]) / d
        kp[d] = ((d-2)*kp[d-2] + Q(2, d-1)) / (d-1)
    M = [[Q(0)] * H for _ in range(H)]
    for i in range(H):
        M[i][0] = km[i]
    for j in range(H):
        M[0][j] = kp[j]
    for i in range(1, H):
        for j in range(1, H):
            M[i][j] = M[i-1][j-1] - m[i-1] / j
    B1, B2 = [Q(0)], [Q(0)]
    for i in range(1, H):
        B1.append(B1[-1] + Q(1, i))
        B2.append(B2[-1] + Q(1, i*i))
    Z = [[-B2[i] if i == j else (B1[i]-B1[j])/(i-j)
          for j in range(H)] for i in range(H)]
    return c, m, km, kp, M, Z


def prime_list(H):
    return [p for p in range(3, H + 1, 2)
            if all(p % d for d in range(2, isqrt(p) + 1))]


def check_jacobian():
    result = json.loads((HERE / "jacobian_result.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    assert result["request"]["payload"] == payload
    assert result["server"]["version"] == "0.14.0"
    assert result["protocol_version"] == "2025-11-25"
    assert result["result"]["operation_id"] == (
        "combinatorics.recurrence.p_recursive.evaluate")
    output = result["result"]["output"]
    assert output["exactness"] == "EXACT_RATIONAL"
    assert output["determinism"] == "DETERMINISTIC"
    prefix = [Q(int(x["num"]), int(x["den"]))
              for x in output["replay_prefix"]]
    assert len(prefix) == 33
    for k, x in enumerate(prefix):
        assert x == Q(2 * 4**k, (2*k+1)*comb(2*k, k))
    for item in output["residuals"]:
        assert item["value"] == {"num": "0", "den": "1"}
    return len(prefix)


def audit(N, counts):
    H, A, b, L, n, q = 65*N, 19*N, 7*N, 59*N, 48*N, 4*N
    _, _, _, kp, M, Z = moments(H)
    for p in prime_list(H):
        if p*p <= 4*H:
            continue
        counts["admissible_N_prime_pairs"] += 1
        E = [0] * p
        for k in range((p-1)//2 + 1):
            E[2*k] = (-1)**k * comb((p-1)//2, k) % p

        def e(d):
            return E[d] if 0 <= d < p else 0

        def reduced_m(i, j):
            return kp[j+1] if i == -1 else M[i][j]

        for i in range(H):
            for j in range(H):
                ell, d = j % p, (j-i-1) % p
                ii, jj = (i+1+d-ell)//p-1, j//p
                assert ii >= -1
                if ii == -1:
                    counts["negative_reduced_index"] += 1
                assert residue(p*p*M[i][j], p) == (
                    E[d] * residue(reduced_m(ii, jj), p) % p), (
                        "digit-M", N, p, i, j, ii, jj)
                expected = Z[i//p][jj] if i % p == ell else Q(0)
                assert residue(p*p*Z[i][j], p) == residue(expected, p), (
                    "digit-Z", N, p, i, j)
                counts["digit_pairs"] += 1

        lo = max(b, H-2*p)
        hi = min(p, L-p, A)
        assert max(0, hi-lo) <= L-b
        for ell in range(lo, min(p, L-p, A+1)):
            optional = ell == A
            for array, start in ((M, A), (Z, A+1)):
                for i in range(start, H):
                    pair = array[i][ell] + array[i][p+ell]
                    assert valuation_at_least(pair, p, -1), (
                        "pair", N, p, ell, i)
                    counts["pair_scalar_checks"] += 1
                    counts["optional_A_endpoint"] += int(optional)

        if 2*p <= H:
            d0 = max(0, hi-lo)
            for selected_improved in range(max(0, d0-q), min(n, d0)+1):
                assert 2*n-selected_improved <= 2*n-max(0, d0-q)
            continue

        J, K = H-p, L-p
        counts["K_nonpositive"] += int(K <= 0)
        counts["J_le_b"] += int(J <= b)
        B = max(0, min(A, K)-b)
        R = max(0, K) + max(0, K-A) + max(0, J-max(b, K))
        exceptional = range(max(0, K), min(b, J))
        exception_set = set(exceptional)
        S = B + len(exception_set)
        assert R == max(0, K) + max(0, J-b) - B
        counts["retained_count_checks"] += 1
        for j in range(max(b, J), min(p, L)):
            for array, is_m in ((M, True), (Z, False)):
                v = (lambda i, ell: 2*e(2*p+ell-1-i)) if is_m else (
                    lambda i, ell: int(i == p+ell))
                for i in range(H):
                    expected = -sum(Q(v(i, ell), j-ell)
                                    for ell in range(J))
                    assert residue(p*array[i][j], p) == residue(expected, p), (
                        "central", N, p, i, j, is_m)
                    counts["central_scalar_checks"] += 1
                # Replay actual rational shears, retaining all secondary terms.
                if N == 1:
                    for i in range(A if is_m else A+1, H):
                        correction = Q(0)
                        for ell in range(J):
                            if ell in exception_set:
                                continue
                            y, sign = (ell, 1) if ell >= b else (p+ell, -1)
                            assert b <= y < L
                            correction += Q(sign, j-ell) * array[i][y]
                        scaled = p*array[i][j] + p*p*correction
                        expected = -sum(Q(v(i, ell), j-ell)
                                        for ell in exceptional)
                        assert residue(scaled, p) == residue(expected, p), (
                            "secondary-shear", N, p, i, j, is_m)
                        counts["secondary_term_shears"] += 1
        for r in range(min(n, R)+1):
            for s in range(min(n-r, S)+1):
                assert 2*r+s <= min(2*n, n+R, 2*R+S)
                counts["loss_allocations"] += 1


def compute():
    counts = dict.fromkeys((
        "admissible_N_prime_pairs", "digit_pairs", "negative_reduced_index",
        "pair_scalar_checks", "optional_A_endpoint", "K_nonpositive",
        "J_le_b", "retained_count_checks", "central_scalar_checks",
        "secondary_term_shears", "loss_allocations"), 0)
    jacobian_terms = check_jacobian()
    for N in (1, 2):
        audit(N, counts)
    assert all(value > 0 for value in counts.values())
    return {
        "result_class": "finite_verification",
        "scope": "Exact adversarial replay for N=1,2; not a universal proof.",
        "universal_proof": "report.md",
        "formal_core": "Main.lean",
        "independent_review": "pending_host",
        "N_values": [1, 2],
        "counts": counts,
        "jacobian": {
            "operation_id": "combinatorics.recurrence.p_recursive.evaluate",
            "server_version": "0.14.0",
            "protocol_version": "2025-11-25",
            "payload": "jacobian_payload.json",
            "typed_output": "jacobian_result.json",
            "adapter_exit_status": 0,
            "structured_error": None,
            "timeout": False,
            "independently_replayed_terms": jacobian_terms,
            "limitation": "A finite recurrence prefix cannot prove a universal congruence."
        }
    }


def check_formal():
    root = HERE.parent.parent
    result = json.loads((HERE / "lean_verify.json").read_text())
    assert result["status"] == "success"
    assert result["exit_code"] == 0
    assert result["proof_holes"] == []
    assert result["environment_failure"] == ""
    version = result["tools"]["lean"]["version"]
    assert "version 4.31.0," in version
    source = (HERE / "Main.lean").read_bytes()
    fidelity = (HERE / "statement_fidelity.md").read_text()
    assert sha256(source).hexdigest() == result["source_sha256"]
    assert sha256(fidelity.encode()).hexdigest() == result[
        "statement_fidelity_sha256"]
    record = result["kernel"]["recorded"]
    assert record["subject"]["subject_id"] == "C_ODD_CORE"
    assert record["verdict"] == "supports"
    assert record["tier"] == "mechanical"
    assert result["kernel"]["refusals"] == []
    archive = json.loads((root / record["artifact"]).read_text())
    assert archive["subject"] == record["subject"]
    assert archive["lean_source"]["text"] == source.decode()
    assert archive["statement_fidelity"]["text"] == fidelity
    assert archive["lean_check"]["exit_code"] == 0
    assert archive["lean_check"]["proof_holes"] == []
    state = json.loads((root / "research/MATH_STATE.json").read_text())
    claim = max((c for c in state["claims"] if c["claim_id"] == "C_ODD_CORE"),
                key=lambda c: c["version"])
    assert claim["content_hash"] == record["subject"]["content_hash"]
    assert claim["formal_statement"] == source.decode()
    return {
        "claim": "C_ODD_CORE",
        "certificate": record["artifact"],
        "lean_version": version,
        "exit_code": 0,
        "proof_holes": [],
        "statement_fidelity": "statement_fidelity.md",
        "scope": "Algebraic core and determinant integrality, not the full arithmetic proof."
    }


def theorem_certificate(finite):
    return {
        "result_class": "new_theorem",
        "qualification": "Support-only universal arithmetic verification; novelty unassessed.",
        "claim": "C_ODD_UNIVERSAL",
        "independent_review": "pending_host",
        "universal_statement": {
            "parameters": "All integers 0<=b<=A<L<=H, 1<=n<=L-b; odd prime p<=H with p^2>4H.",
            "rows": "Arbitrary p-integral P_r,D_r supported in [A,H-1],[A+1,H-1], and arbitrary p-integral gamma.",
            "entries": "Equation (1) of report.md, defined by the exact rational moment recurrences.",
            "filter": "Any p-integral (L-b)-by-n matrix; every full raw minor is also covered.",
            "lower_range": "For p<=H/2: v_p(Delta)>=-2n+(d0-q)_+, q=L-b-n, d0=(min(p,L-p,A)-max(b,H-2p))_+.",
            "upper_range": "For H/2<p<=H and p>b: v_p(Delta)>=-min(2n,n+R,2R+S), with R,S exactly as in report.md.",
            "manuscript_specialization": "For every positive N, n=48N,b=7N,A=19N,L=59N,H=65N, and every admissible odd prime."
        },
        "proof": {
            "complete_arithmetic_argument": "report.md, Sections 1-6",
            "arithmetic_argument_is_fully_kernel_checked": False,
            "kernel_checked_algebraic_core": check_formal(),
            "unproved_disputed_congruences_assumed": [],
            "analytic_moment_identification_audited": False,
            "catalan_irrationality_certified": False
        },
        "finite_tests": finite
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--formal-only", action="store_true",
                        help="Check new formal evidence without repeating finite tests.")
    args = parser.parse_args()
    certificate = HERE / "exact_certificate.json"
    if args.formal_only:
        previous = json.loads(certificate.read_text())
        finite = previous.get("finite_tests", previous)
    else:
        finite = compute()
    actual = theorem_certificate(finite)
    if args.write_certificate:
        certificate.write_text(json.dumps(actual, indent=2) + "\n")
    else:
        assert json.loads(certificate.read_text()) == actual
    print(json.dumps(actual, indent=2))


if __name__ == "__main__":
    main()
