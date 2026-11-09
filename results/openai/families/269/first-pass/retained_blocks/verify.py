#!/usr/bin/env python3
"""Exact reconstruction from the staged seven rows; no numerical eigensolver."""

import argparse
from fractions import Fraction as Q
from functools import lru_cache
from itertools import combinations
import json
from math import comb, factorial as fac, isqrt
from pathlib import Path
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
STABILITY = ROOT / "research/openai_manuscript/Uniform-Stability-of-the-Spherical-Laughlin-Gap-October-5-2026"
FOCK = ROOT / "research/openai_manuscript/A-Fock-space-inequality-and-the-Laughlin-spectral-gap-September-24-2026"
P = 10**7
EPSILON = Q(3, 10**6)
PRIOR_GAMMA = Q(4616733319001, 10**14)
CONSUMED_D = {5, 11, 13, 15}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def two(n):
    return Q(2**n) if n >= 0 else Q(1, 2**(-n))


def sqrtq(x):
    require(x >= 0, "negative radicand")
    a, b = isqrt(x.numerator), isqrt(x.denominator)
    require(a * a == x.numerator and b * b == x.denominator,
            "radical did not cancel exactly")
    return Q(a, b)


def falling(n, k):
    return fac(n) // fac(n-k)


def rows():
    text = (STABILITY / "verification/rows.txt").read_text()
    require(text == (FOCK / "verification/rows.txt").read_text(),
            "the manuscripts have different row data")
    result = []
    for line in text.splitlines():
        if not line.strip():
            continue
        fields = line.split()
        if not line[0].isspace():
            t, ell = map(int, fields[:2])
            result.append({"t": t, "ell": ell, "entries": []})
            fields = fields[2:]
        require(bool(result), "continuation without a row")
        for field in fields:
            pair, value = field.split(":")
            require(len(pair) == 2, "pair labels must be single digits")
            p, j = map(int, pair)
            require(0 <= p <= 7 and 0 <= j <= 8
                    and 0 <= p+j-result[-1]["t"] <= 8,
                    "row entry outside its declared support")
            result[-1]["entries"].append((p, j, int(value)))
    require(len(result) == 7, "expected seven rows")
    for row in result:
        labels = [(p, j) for p, j, _ in row["entries"]]
        require(len(set(labels)) == len(labels), "duplicate row entry")
    return result


@lru_cache(None)
def polynomial(c, z, T):
    if not 0 <= z <= T:
        return ()
    coefficients = [1]
    for constant, linear in [(-1, 1)] * z + [(1, c)] * (T-z):
        nxt = [0] * (len(coefficients)+1)
        for p, a in enumerate(coefficients):
            nxt[p] += constant * a
            nxt[p+1] += linear * a
        coefficients = nxt
    return tuple(coefficients)


@lru_cache(None)
def U(c, z, T, p):
    if not (0 <= z <= T and 0 <= p <= T):
        return 0
    value = sum((-1)**(z-h) * comb(z, h) * comb(T-z, p-h) * c**(p-h)
                for h in range(max(0, p+z-T), min(p, z)+1))
    require(value == polynomial(c, z, T)[p],
            "binomial sum disagrees with direct polynomial multiplication")
    return value


@lru_cache(None)
def V(r, D, T, p, j, k):
    if r > j+k:
        return 0
    return U(1, r, j+k, j) * U(1, D-r, T-r, p)


def three_body(data):
    expected = [1298313, 211317, 249, 250, 249, 250, 250,
                250, 249, 250, 250, 6470, 250]
    result = []
    for z, floor in zip([2] + list(range(4, 16)), expected):
        e = Q(0)
        for row in data:
            t, ell = row["t"], row["ell"]
            for T in range(max(z, t), 16):
                X = sum(a * U(2, z, T, p)
                        for p, j, a in row["entries"] if p+j == T)
                e += Q(2**z * comb(T, z),
                       3**T * 2**t * comb(T, t)) * X * (
                           X + 2*ell*U(2, z, T, t))
        e /= P**2
        margin = Q(3, 2) * (3*z-1) * Q(-1, 2)**z - e
        require(margin > 0, "failed three-body margin z=" + str(z))
        require((10**6*margin).__floor__() == floor,
                "three-body table mismatch z=" + str(z))
        result.append({"z": z, "trace": str(e), "margin": str(margin)})
    return result


def check_oscillators():
    checks = 0
    for c in (1, 2):
        for T in range(24):
            for z in range(T+1):
                norm = sum(Q(U(c, z, T, p)**2*c**z*comb(T, z),
                             (c+1)**T*c**p*comb(T, p))
                           for p in range(T+1))
                require(norm == 1, "oscillator coupling normalization failed")
                for w in range(z):
                    overlap = sum(Q(U(c, z, T, p)*U(c, w, T, p),
                                    c**p*comb(T, p)) for p in range(T+1))
                    require(overlap == 0, "oscillator coupled copies are not orthogonal")
                    checks += 1
    for p in range(24):
        norm = sum(Q((i-j)**2*fac(p), 2**p*fac(i)*fac(j))
                   for i in range(p+2) for j in range(i+1, p+2) if i+j == p+1)
        require(norm == 1, "limiting pair normalization failed")
    return checks


def zero(n):
    return [[Q(0) for _ in range(n)] for _ in range(n)]


def multiply(A, B):
    n, m, k = len(A), len(B[0]), len(B)
    C = [[Q(0) for _ in range(m)] for _ in range(n)]
    for i in range(n):
        for a in range(k):
            if A[i][a]:
                for j in range(m):
                    if B[a][j]:
                        C[i][j] += A[i][a] * B[a][j]
    return C


def parity(sequence):
    return (-1)**sum(sequence[i] > sequence[j]
                     for i in range(len(sequence))
                     for j in range(i+1, len(sequence)))


def quadruples(total):
    for x in range(total+1):
        for y in range(x+1, total+1):
            for j in range(y+1, total+1):
                k = total-x-y-j
                if k > j:
                    yield (x, y, j, k)


def gram(D, copies):
    Z = zero(len(copies))
    for A in quadruples(D+1):
        fA = fac(A[0])*fac(A[1])*fac(A[2])*fac(A[3])
        values = []
        for r in copies:
            direct, shortcut = Q(0), Q(0)
            for x, y in combinations(A, 2):
                j, k = (a for a in A if a not in (x, y))
                p = x+y-1
                v = V(r, D, D, p, j, k)
                sign = parity((x, y, j, k))
                shortcut += sign*(x-y)*fac(p)*fac(j)*fac(k)*v
                # Multiply the normalized pair and coupled coefficients first.
                radicand = (two(1-j-k-D+r) * fac(j)*fac(k)*fac(p)
                             * Q(fac(p), 2**p*fac(x)*fac(y)) * fA)
                direct += sign*(x-y)*v*sqrtq(radicand)
            shortcut *= two((1-2*D+r)//2)
            require(direct == shortcut, "independent wedge coefficient mismatch")
            values.append(direct)
        for i, a in enumerate(values):
            for j, b in enumerate(values):
                Z[i][j] += a*b/fA
    return Z


def four_body(data, D, copies):
    n = len(copies)
    Y = zero(n)
    for row in data:
        t = row["t"]
        for p, j, a in row["entries"]:
            i = p+j-t
            for pp, ell, b in row["entries"]:
                k = pp+ell-t
                T = p+j+k
                require(T == pp+ell+i and T <= 23,
                        "four-body weight/support identity failed")
                if T < D or j == k or ell == i:
                    continue
                left = [2**((r-1)//2)*V(r, D, T, p, j, k) for r in copies]
                right = [2**((s-1)//2)*V(s, D, T, pp, ell, i) for s in copies]
                factor = (-Q(a*b*fac(i)*fac(k)*fac(t), P**2*fac(T-D))
                          * two(2-2*T+p+pp-t))
                for r in range(n):
                    if left[r]:
                        for s in range(n):
                            if right[s]:
                                Y[r][s] += factor*left[r]*right[s]
    require(all(Y[i][j] == Y[j][i] for i in range(n) for j in range(n)),
            "four-body coefficient matrix is not symmetric")
    return Y


def compressed(D, copies, Y, Z, allowance, target=1):
    u = [Q(1, fac(r)*fac(D-r)) for r in copies]
    B = [[-u[i]*Y[i][j]*u[j] for j in range(len(copies))]
         for i in range(len(copies))]
    for i, r in enumerate(copies):
        B[i][i] += (2*target*(r == 1) + allowance)*u[i]
    return multiply(multiply(Z, B), Z)


def psd(A):
    """Exact symmetric Schur complements, including singular zero residuals."""
    A = [row[:] for row in A]
    pivots = []
    while A:
        n = len(A)
        require(all(A[i][j] == A[j][i] for i in range(n) for j in range(n)),
                "asymmetric Schur complement")
        if any(A[i][i] < 0 for i in range(n)):
            return {"psd": False, "reason": "negative diagonal Schur pivot"}
        index = next((i for i in range(n) if A[i][i] > 0), None)
        if index is None:
            if any(value for row in A for value in row):
                return {"psd": False, "reason": "zero diagonal with nonzero off-diagonal"}
            return {"psd": True, "rank": len(pivots), "pivots": list(map(str, pivots))}
        order = [index] + [i for i in range(n) if i != index]
        A = [[A[i][j] for j in order] for i in order]
        pivot = A[0][0]
        pivots.append(pivot)
        A = [[A[i][j]-A[i][0]*A[0][j]/pivot for j in range(1, n)]
             for i in range(1, n)]
    return {"psd": True, "rank": len(pivots), "pivots": list(map(str, pivots))}


def check_finite_flux():
    count = 0
    for q in range(2, 15):
        for p in range(2*q-1):
            norm = sum(Q((i-j)**2*comb(q, i)*comb(q, j),
                         q*comb(2*q-2, p))
                       for i in range(q+1) for j in range(i+1, q+1)
                       if i+j == p+1)
            require(norm == 1, "finite-flux pair normalization failed")
        for z in range(q+1):
            coefficients = [Q(1)]
            for p in range(z):
                coefficients.append(coefficients[-1] *
                    Q((z-p)*(q-z+p+1), (p+1)*(2*q-2-p)))
            s0sq = 1/sum(coefficients)
            Ksq = Q(fac(z), q*fac(q-z)*fac(q))
            norm = Q(0)
            for A in combinations(range(q+1), 3):
                if sum(A) != z+1:
                    continue
                weight = Q(1)
                for a in A:
                    weight *= Q(falling(q, a), fac(a))
                amplitude = Q(0)
                for i, j in combinations(A, 2):
                    k = next(a for a in A if a not in (i, j))
                    p = i+j-1
                    amplitude += (parity((i, j, k)) * (-1)**p * (i-j)
                                  * Q(fac(q-k), falling(2*q-2, p)))
                norm += weight*amplitude**2
            norm *= s0sq*Ksq
            qz = ((-1)**z * Q(falling(q, z), falling(2*q-2, z))
                  * (3*z-1-Q(z*(z+1), q)))
            require(norm == 1+qz, "finite-flux Gram eigenvalue mismatch")
            count += 1
    return count


def tail_sum():
    # z=17+2m; sum (900+208m+12m^2)/4^m, times 3/(2*2^17).
    t = Q(1, 4)
    return Q(3, 2*2**17)*(900/(1-t) + 208*t/(1-t)**2
                          + 12*t*(1+t)/(1-t)**3)


def typed_payload(A):
    return {"dimension": len(A), "entries": [
        {"row": i, "col": j, "value": {"num": str(a.numerator), "den": str(a.denominator)}}
        for i, row in enumerate(A) for j, a in enumerate(row) if a and i <= j]}


def reconstruct():
    data = rows()
    eta = Q(sum(row["ell"]**2 for row in data), P**2)
    require(eta == Q(93527408868499, 10**14), "two-body cost mismatch")
    traces = three_body(data)
    require(tail_sum() == Q(61, 4096), "tail constant mismatch")
    all_blocks, nonzero_allowance, payload = [], [], None
    selected_cost = 0
    for D in range(1, 24):
        copies = list(range(1, D+1, 2))
        Y, Z = four_body(data, D, copies), gram(D, copies)
        original = compressed(D, copies, Y, Z, EPSILON)
        original_check = psd(original)
        require(original_check["psd"], "manuscript PSD failed D=" + str(D))
        no_allowance = psd(compressed(D, copies, Y, Z, Q(0), target=D in CONSUMED_D))
        allowance = Q(0) if no_allowance["psd"] else EPSILON
        selected_check = psd(compressed(D, copies, Y, Z, allowance,
                                        target=D in CONSUMED_D))
        require(selected_check["psd"], "selective-retention PSD failed D=" + str(D))
        nD = (D+1)**2//4
        if allowance:
            nonzero_allowance.append(D)
            selected_cost += nD
            if payload is None:
                payload = typed_payload(original)
        all_blocks.append({
            "D": D, "copies": copies, "rank_gram": psd(Z)["rank"],
            "rank_comparison": original_check["rank"],
            "target_consumed": D in CONSUMED_D,
            "selected_allowance": str(allowance),
            "zero_allowance_psd": no_allowance["psd"],
            "positive_pivots": original_check["pivots"],
            "selected_positive_pivots": selected_check["pivots"],
            "Y": [[str(a) for a in row] for row in Y],
            "Z": [[str(a) for a in row] for row in Z],
        })
    if payload is None:
        D = 5
        copies = list(range(1, D+1, 2))
        payload = typed_payload(compressed(D, copies, four_body(data, D, copies),
                                           gram(D, copies), Q(0)))
    gamma = 1-eta-tail_sum()-selected_cost*EPSILON
    require(1-eta-tail_sum()-1222*EPSILON == PRIOR_GAMMA, "prior gamma mismatch")
    certificate = {
        "result_type": "exact finite comparison and input to a quantified theorem",
        "source_rows": data,
        "eta": str(eta),
        "epsilon": str(EPSILON),
        "three_body": traces,
        "four_body": all_blocks,
        "finite_flux_gram_checks": check_finite_flux(),
        "oscillator_orthogonality_checks": check_oscillators(),
        "tail_limit": str(tail_sum()),
        "original_allowance_cost": 1222,
        "selected_allowance_blocks": nonzero_allowance,
        "selected_allowance_cost": selected_cost,
        "consumed_D": sorted(CONSUMED_D),
        "retained_projection": "I-P_{q,4}-P_{q,10}-P_{q,12}-P_{q,14}",
        "all_pair_spin_deficits_at_least": 15,
        "prior_gamma": str(PRIOR_GAMMA),
        "improved_gamma": str(gamma),
        "gain_over_prior": str(gamma-PRIOR_GAMMA),
        "jacobian_payload": payload,
        "quantifier_warning": "The finite computations are not by themselves a full-Fock proof. See theorem.md for the transfer, support, spectators, and infinite tail.",
    }
    return certificate


def check_jacobian(certificate):
    output = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0 and not status["timeout"],
            "unsuccessful adapter operation is not evidence")
    require(output["server"]["version"] == "0.14.0", "unexpected Jacobian version")
    require(output["protocol_version"] == "2025-11-25", "unexpected protocol version")
    require(output["transport"] == "mcp-stdio", "unexpected Jacobian transport")
    result = output["result"]
    require(result["operation_id"] == "matrix.inertia.compute", "wrong typed operation")
    # The adapter's envelope is retained verbatim; unsuccessful runs are not evidence.
    if "output" in result:
        result = result["output"]
    expected_payload = certificate["jacobian_payload"]
    saved_payload = json.loads((HERE / "jacobian_payload.json").read_text())
    require(saved_payload == expected_payload, "Jacobian source binding mismatch")
    dense = zero(expected_payload["dimension"])
    for entry in expected_payload["entries"]:
        value = entry["value"]
        i, j = entry["row"], entry["col"]
        dense[i][j] = dense[j][i] = Q(int(value["num"]), int(value["den"]))
    source = [[Q(int(x["num"]), int(x["den"])) for x in row]
              for row in result["matrix"]["entries"]]
    require(source == dense, "Jacobian did not retain the exact source matrix")
    own = psd(dense)
    require(own["psd"] and result["n_negative"] == 0
            and result["n_positive"] == own["rank"]
            and result["n_zero"] == len(dense)-own["rank"],
            "Jacobian inertia disagrees with independent Schur complements")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    start = time.monotonic()
    certificate = reconstruct()
    target = HERE / "exact_certificate.json"
    if args.write_certificate:
        target.write_text(json.dumps(certificate, indent=2) + "\n")
        (HERE / "jacobian_payload.json").write_text(
            json.dumps(certificate["jacobian_payload"], indent=2) + "\n")
    else:
        expected = json.loads(target.read_text())
        # JSON arrays replace tuples in the input row records.
        require(json.loads(json.dumps(certificate)) == expected,
                "recomputed certificate differs from the stored exact certificate")
        check_jacobian(certificate)
    print(json.dumps({
        "status": "exact comparisons passed",
        "four_body_blocks": 23,
        "finite_flux_gram_checks": certificate["finite_flux_gram_checks"],
        "selected_allowance_blocks": certificate["selected_allowance_blocks"],
        "selected_allowance_cost": certificate["selected_allowance_cost"],
        "consumed_D": certificate["consumed_D"],
        "prior_gamma": certificate["prior_gamma"],
        "improved_gamma": certificate["improved_gamma"],
        "gain_over_prior": certificate["gain_over_prior"],
        "seconds": round(time.monotonic()-start, 3),
    }, indent=2))


if __name__ == "__main__":
    main()
