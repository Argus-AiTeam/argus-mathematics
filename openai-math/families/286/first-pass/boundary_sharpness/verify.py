#!/usr/bin/env python3
"""Replay exact local identities; do not infer a lattice theorem from finite tests."""

import argparse
import json
from fractions import Fraction as Q
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def mat(rows):
    return tuple(tuple(Q(x) for x in row) for row in rows)


def zero(n):
    return mat([[0] * n for _ in range(n)])


def eye(n):
    return mat([[int(i == j) for j in range(n)] for i in range(n)])


def add(a, b):
    return tuple(tuple(x + y for x, y in zip(r, s)) for r, s in zip(a, b))


def scale(c, a):
    return tuple(tuple(c * x for x in row) for row in a)


def sub(a, b):
    return add(a, scale(-1, b))


def trans(a):
    return tuple(zip(*a))


def mul(a, b):
    return tuple(tuple(sum(x * y for x, y in zip(r, c)) for c in trans(b)) for r in a)


def block(a, b, c, d):
    return tuple(r + s for r, s in zip(a, b)) + tuple(r + s for r, s in zip(c, d))


def trace(a):
    return sum(a[i][i] for i in range(len(a)))


def det2(a):
    return a[0][0] * a[1][1] - a[0][1] * a[1][0]


def psd2(a):
    return a == trans(a) and a[0][0] >= 0 and a[1][1] >= 0 and det2(a) >= 0


def rank(a):
    rows = [list(r) for r in a]
    pivot_row = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(pivot_row, len(rows)) if rows[i][column]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        value = rows[pivot_row][column]
        rows[pivot_row] = [x / value for x in rows[pivot_row]]
        for i in range(len(rows)):
            if i != pivot_row:
                value = rows[i][column]
                rows[i] = [x - value * y for x, y in zip(rows[i], rows[pivot_row])]
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return pivot_row


def pinv2(a):
    require(psd2(a), "pseudoinverse input is not positive semidefinite")
    determinant = det2(a)
    if determinant:
        result = scale(1 / determinant, mat([[a[1][1], -a[0][1]], [-a[1][0], a[0][0]]]))
    elif trace(a):
        result = scale(1 / trace(a) ** 2, a)
    else:
        require(a == zero(2), "trace-zero positive input is not zero")
        result = zero(2)
    require(mul(mul(a, result), a) == a, "first Moore-Penrose identity")
    require(mul(mul(result, a), result) == result, "second Moore-Penrose identity")
    require(mul(a, result) == trans(mul(a, result)), "third Moore-Penrose identity")
    require(mul(result, a) == trans(mul(result, a)), "fourth Moore-Penrose identity")
    return result


def parallel(a, b):
    require(psd2(a) and psd2(b), "effect positivity")
    s = add(a, b)
    si = pinv2(s)
    k = mul(si, a)
    c = sub(a, mul(mul(a, si), a))
    require(c == sub(b, mul(mul(b, si), b)), "parallel sum symmetry")
    require(c == mul(mul(a, si), b), "parallel sum product identity")
    require(psd2(c), "parallel sum positivity")
    require(psd2(sub(a, c)) and psd2(sub(b, c)), "CP domination")
    require(mul(s, k) == a, "singular minimization range condition")
    z = zero(2)
    change = block(eye(2), z, scale(-1, k), eye(2))
    original = block(a, scale(-1, a), scale(-1, a), s)
    completed = mul(mul(trans(change), block(c, z, z, s)), change)
    require(original == completed, "completing-the-square identity for ALL vectors")
    return c, det2(s) == 0


I = eye(2)
Z = zero(2)
U = mat([[1, 0], [0, -1]])
P = mat([[1, 0], [0, 0]])
Q34 = scale(Q(1, 25), mat([[9, 12], [12, 16]]))
PERM = (1, 0, 3, 2)


def conjugate(u, a):
    return mul(mul(u, a), trans(u))


def effects(p, t):
    require(p == trans(p) and mul(p, p) == p, "rank-one projection input")
    raw = (p, conjugate(U, p), sub(I, p), conjugate(U, sub(I, p)))
    return tuple(add(scale(t / 2, a), scale((1 - t) / 4, I)) for a in raw)


def verify_pair(e, f, u=U):
    require(mul(u, u) == I and trans(u) == u and trace(u) == 0, "C2 regular representation")
    require(sum_matrices(e) == I and sum_matrices(f) == I, "unitality")
    for family in (e, f):
        require(all(psd2(a) for a in family), "positive effects")
        require(
            all(conjugate(u, family[i]) == family[PERM[i]] for i in range(4)),
            "target covariance",
        )
    checked = [parallel(a, b) for a, b in zip(e, f)]
    common = tuple(c for c, _ in checked)
    require(
        all(conjugate(u, common[i]) == common[PERM[i]] for i in range(4)),
        "common CP subordinate covariance",
    )
    return common, sum(singular for _, singular in checked)


def sum_matrices(values):
    total = zero(len(values[0]))
    for a in values:
        total = add(total, a)
    return total


def display(a):
    return [[str(x) for x in row] for row in a]


def verify_frame_algebra():
    e = mat([[int(i == j and i < 3) for j in range(4)] for i in range(4)])
    u = mat([[Q(3, 5), Q(-4, 5), 0, 0], [Q(4, 5), Q(3, 5), 0, 0],
             [0, 0, -1, 0], [0, 0, 0, 0]])
    a = mat([[i + 2 * j for j in range(4)] for i in range(4)])
    b = mat([[int(i == j) + i - j for j in range(4)] for i in range(4)])

    def theta(m):
        return mat([
            [int(i // 4 == j // 4) * m[j % 4][i % 4] for j in range(16)]
            for i in range(16)
        ])

    def vec(m):
        return tuple((x,) for row in m for x in row)

    q = theta(e)
    require(mul(e, e) == e and trans(e) == e, "frame projection")
    require(sum(x * x for row in e for x in row) / 2 == trace(e) / 2,
            "normalized frame vector norm equals the finite module trace")
    require(mul(u, trans(u)) == e and mul(trans(u), u) == e, "source corner unitary")
    require(mul(theta(a), theta(b)) == theta(mul(b, a)), "opposite-algebra orientation")
    require(theta(trans(a)) == trans(theta(a)), "star operation")
    require(mul(q, vec(e)) == vec(e), "frame support")
    require(mul(theta(trans(u)), vec(e)) == vec(mul(trans(u), e)), "translated frame")
    require(mul(trans(u), e) == mul(e, trans(u)), "left/right frame identity")
    global_u = add(theta(u), sub(eye(16), q))
    require(mul(global_u, trans(global_u)) == eye(16), "extended corner unitary")
    require(mul(trans(global_u), global_u) == eye(16), "extended corner unitary adjoint")
    return {"normalized_frame_mass": str(trace(e) / 2), "all_identities": True}


def verify_jacobian(pure_sum, noisy_sum):
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    reply = json.loads((ROOT / "jacobian_result.json").read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    operation = "matrix.symmetric.rational_spectrum_claim.check"
    require(status["adapter_exit_code"] == 0, "Jacobian adapter failed")
    require(not (ROOT / "jacobian_stderr.txt").read_text().strip(), "Jacobian stderr is nonempty")
    require(reply["protocol_version"] == "2025-11-25", "unexpected adapter protocol")
    require(reply["server"]["version"] == "0.14.0", "unexpected retained server version")
    require(reply["transport"] == "mcp-stdio", "unexpected retained transport")
    require(reply["request"]["operation_id"] == operation, "retained operation mismatch")
    require(reply["request"]["payload"] == payload, "retained exact payload mismatch")
    output = reply["result"]["output"]
    require(reply["result"]["operation_id"] == operation, "result operation mismatch")
    require(output["outcome"] == "VALID" and output["valid_complete_rational_spectrum"],
            "Jacobian outcome is not a complete decision")
    entries = payload["matrix"]["entries"]
    matrix = mat([[Q(int(x["num"]), int(x["den"])) for x in row] for row in entries])
    require(matrix == block(pure_sum, Z, Z, noisy_sum), "spectral matrix is not the tested sum")
    require(output["matrix"] == payload["matrix"], "typed result source mismatch")
    require(output["claimed_profile"] == payload["claimed_profile"], "typed result claim mismatch")
    require(len(output["nullity_ledger"]) == 4, "incomplete typed nullity ledger")
    eigenvalues = []
    for claim, entry in zip(payload["claimed_profile"], output["nullity_ledger"]):
        value = Q(int(claim["eigenvalue"]["num"]), int(claim["eigenvalue"]["den"]))
        nullity = 4 - rank(sub(matrix, scale(value, eye(4))))
        require(entry["eigenvalue"] == claim["eigenvalue"], "typed eigenvalue mismatch")
        require(nullity == claim["multiplicity"] == entry["exact_nullity"] == 1,
                "independent exact shifted-nullity replay")
        require(entry["claimed_multiplicity"] == 1 and entry["multiplicity_matches"],
                "typed multiplicity mismatch")
        require(det2(sub(pure_sum, scale(value, I))) *
                det2(sub(noisy_sum, scale(value, I))) == 0,
                "exact characteristic polynomial root")
        eigenvalues.append(str(value))
    require(len(set(eigenvalues)) == 4, "spectrum not complete")
    require(output["matrix_order"] == output["established_multiplicity_sum"] ==
            output["claimed_multiplicity_sum"] == 4, "typed multiplicity total")
    require(output["first_failed_condition"] is None and output["first_failed_claim_index"] is None,
            "typed output contains a failed condition")
    return {
        "operation_id": operation,
        "server_version": reply["server"]["version"],
        "protocol_version": reply["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "typed_outcome": output["outcome"],
        "independently_replayed_spectrum": eigenvalues,
    }


def build_certificate():
    pure_e, pure_f = effects(P, Q(1)), effects(Q34, Q(1))
    noisy_e, noisy_f = effects(P, Q(1, 2)), effects(Q34, Q(1, 2))
    pure_c, singular = verify_pair(pure_e, pure_f)
    noisy_c, count = verify_pair(noisy_e, noisy_f)
    singular += count
    require(all(c == Z for c in pure_c), "pure rank-one forms should be disjoint")
    require(mul(pure_e[0], pure_f[0]) != Z, "nonzero product example")
    require(mul(pure_e[0], pure_f[0]) != mul(pure_f[0], pure_e[0]), "noncommuting example")
    require(all(det2(c) > 0 for c in noisy_c), "noisy common map is not nonzero")
    require(mul(noisy_e[0], noisy_f[0]) != mul(noisy_f[0], noisy_e[0]),
            "noisy effects unexpectedly commute")
    lower = scale(Q(1, 16), I)
    require(all(psd2(sub(a, lower)) for a in noisy_e + noisy_f),
            "explicit nonzero equivariant CP lower bound")
    require(psd2(sub(noisy_e[0], scale(Q(1, 8), P))) and
            psd2(sub(noisy_f[0], scale(Q(1, 8), P))), "common scalar functional norm bound")
    _, count = verify_pair(pure_e, pure_e)
    singular += count
    _, count = verify_pair((Z, Z, scale(Q(1, 2), I), scale(Q(1, 2), I)),
                           (scale(Q(1, 4), I),) * 4)
    singular += count
    flip = mat([[0, 1], [1, 0]])
    sharp_c, count = verify_pair((P, sub(I, P), Z, Z), (sub(I, P), P, Z, Z), flip)
    singular += count
    require(all(c == Z for c in sharp_c), "orthogonal sharp example")
    cases = 5
    parameters = ((1, 0), (1, 1), (2, 1), (3, 1), (3, 2), (4, 1), (4, 3))
    levels = (Q(0), Q(1, 4), Q(1, 2), Q(3, 4), Q(1))
    for p, q in parameters:
        den = p * p + q * q
        v = (Q(p * p - q * q, den), Q(2 * p * q, den))
        projection = mat([[x * y for y in v] for x in v])
        for t in levels:
            for s in levels:
                _, count = verify_pair(effects(P, t), effects(projection, s))
                singular += count
                cases += 1
    pure_sum = add(pure_e[0], pure_f[0])
    noisy_sum = add(noisy_e[0], noisy_f[0])
    return {
        "claim": "C286_CONDITIONAL_DISJOINTNESS",
        "result_class": "conditional_verification",
        "certifies": "Exact local finite-dimensional identities and concrete covariant CP examples; not the infinite-dimensional theorem.",
        "upstream_lattice_inputs_verified": False,
        "full_manuscript_verified": False,
        "novelty_claimed": False,
        "independent_review_certified_by_this_script": False,
        "literal_refutations": [],
        "arithmetic": "fractions.Fraction; no floating-point tolerance",
        "covariant_map_pairs_checked": cases,
        "effect_pairs_checked": 4 * cases,
        "singular_effect_sums_checked": singular,
        "target_action": "C2 swaps (0,1) and (2,3); its input representation is regular",
        "pure_noncommuting_example": {
            "E0": display(pure_e[0]),
            "F0": display(pure_f[0]),
            "product": display(mul(pure_e[0], pure_f[0])),
            "parallel_sum": display(pure_c[0]),
        },
        "noisy_noncommuting_example": {
            "E0": display(noisy_e[0]),
            "F0": display(noisy_f[0]),
            "parallel_sum": display(noisy_c[0]),
            "equivariant_common_effect_at_each_point": display(lower),
            "scalar_functional_bound_squared": "8",
        },
        "identities": [
            "A:B = A - A(A+B)^+A = B - B(A+B)^+B = A(A+B)^+B",
            "0 <= A:B <= A,B without A B = B A",
            "exact completing-the-square block-matrix congruence, including singular sums",
            "covariance and unitality of both input POVMs; covariance of the CP subordinate",
            "canonical frame support, opposite multiplication, and source corner-unitary identity",
        ],
        "frame_algebra": verify_frame_algebra(),
        "jacobian": verify_jacobian(pure_sum, noisy_sum),
        "prose_theorem": "theorem.md",
        "lean_scope": "Closed anti-diagonal nonvanishing and invariance only; see lean/statement_fidelity.md and real compiler evidence.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    else:
        require(json.loads(path.read_text()) == certificate, "stored exact certificate differs from replay")
    print(json.dumps({
        "status": "verified",
        "scope": "exact local identities, not the lattice theorem",
        "covariant_map_pairs": certificate["covariant_map_pairs_checked"],
        "effect_pairs": certificate["effect_pairs_checked"],
        "singular_sums": certificate["singular_effect_sums_checked"],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
