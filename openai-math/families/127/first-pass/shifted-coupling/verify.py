#!/usr/bin/env python3
"""Replay exact rational primal/dual certificates for one-sided transport."""

import argparse
import copy
import json
from fractions import Fraction as Q
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def primitive(x):
    return x * abs(x) / 2


def envelope(x, a):
    return 4 * (x * x - max(abs(x) - a / 2, Q(0)) ** 2)


def dual(x, a, c):
    potential = 4 * primitive(x - c - a / 2) - 2 * a * (x - c)
    return envelope(x - c, a) + potential, -potential


def make_fixture(name, masses, d):
    n = len(masses) - 1
    c, a = Q(n, 2), Q(d)
    require(0 <= d <= n, "shift outside fixture domain")
    require(sum(masses) == 1, "marginal is not normalized")
    require(all(p >= 0 for p in masses), "negative marginal mass")
    require(masses == masses[::-1], "marginal is not symmetric")
    require(
        all(masses[i] <= masses[i + 1] for i in range(n // 2)),
        "marginal is not unimodal",
    )
    joint = {}
    for i, p in enumerate(masses):
        t = min(p, masses[i + d]) if i + d <= n else Q(0)
        if t:
            joint[i, i + d] = joint.get((i, i + d), Q(0)) + t
        if p > t:
            joint[i, n - i] = joint.get((i, n - i), Q(0)) + p - t
    duals = [dual(Q(i), a, c) for i in range(n + 1)]
    objective = sum(p * envelope(Q(i) - c, a) for i, p in enumerate(masses))
    return {
        "name": name,
        "n": n,
        "d": d,
        "marginal": [str(p) for p in masses],
        "primal": [[i, j, str(p)] for (i, j), p in sorted(joint.items())],
        "dual_u": [str(u) for u, _ in duals],
        "dual_v": [str(v) for _, v in duals],
        "objective": str(objective),
    }


def binomial_fixture(n, d):
    masses = [Q(comb(n, i), 2**n) for i in range(n + 1)]
    fixture = make_fixture(f"binomial-{n}-{d}", masses, d)
    fixture["family"] = "binomial"
    return fixture


def verify_fixture(fixture):
    n, d = fixture["n"], fixture["d"]
    require(isinstance(n, int) and n >= 0, "invalid dimension")
    require(isinstance(d, int) and 0 <= d <= n, "invalid shift")
    masses = [Q(p) for p in fixture["marginal"]]
    alpha = [Q(p) for p in fixture["dual_u"]]
    beta = [Q(p) for p in fixture["dual_v"]]
    require(len(masses) == len(alpha) == len(beta) == n + 1, "wrong dimensions")
    require(sum(masses) == 1 and all(p >= 0 for p in masses), "invalid marginal")
    require(masses == masses[::-1], "nonsymmetric fixture")
    require(
        all(masses[i] <= masses[i + 1] for i in range(n // 2)),
        "nonunimodal fixture",
    )
    rows, columns = [Q(0)] * (n + 1), [Q(0)] * (n + 1)
    primal, edges, checks = Q(0), set(), 0
    for i, j, value in fixture["primal"]:
        require(isinstance(i, int) and isinstance(j, int), "noninteger index")
        require(0 <= i <= n and 0 <= j <= n, "primal index out of bounds")
        require((i, j) not in edges, "duplicate primal entry")
        edges.add((i, j))
        p = Q(value)
        require(p > 0, "nonpositive sparse primal entry")
        require(j - i <= d, "one-sided support violation")
        rows[i] += p
        columns[j] += p
        primal += p * (i - j) ** 2
        require(alpha[i] + beta[j] == (i - j) ** 2, "complementary slackness")
    require(rows == masses and columns == masses, "primal marginal violation")
    for i in range(n + 1):
        for j in range(n + 1):
            if j - i <= d:
                require(alpha[i] + beta[j] >= (i - j) ** 2, "dual infeasibility")
                checks += 1
    dual_value = sum(p * (u + v) for p, u, v in zip(masses, alpha, beta))
    a, c = Q(d), Q(n, 2)
    bound = sum(p * envelope(Q(i) - c, a) for i, p in enumerate(masses))
    mad = sum(p * abs(Q(i) - c) for i, p in enumerate(masses))
    require(primal == dual_value == bound == Q(fixture["objective"]), "objective gap")
    require(bound <= 4 * a * mad, "MAD bound")
    if fixture.get("family") == "binomial":
        require(
            masses == [Q(comb(n, i), 2**n) for i in range(n + 1)],
            "wrong binomial marginal",
        )
        tail = sum(
            p * max(abs(Q(i) - c) - a / 2, Q(0)) ** 2
            for i, p in enumerate(masses)
        )
        require(bound == n - 4 * tail, "binomial envelope identity")
        require(mad**2 <= Q(n, 4), "binomial variance comparison")
        if n:
            require(
                mad == Q(n * comb(n - 1, (n - 1) // 2), 2**n),
                "exact binomial MAD formula",
            )
    return checks


def pointwise_checks():
    checks = 0
    values = [Q(k, 2) for k in range(-6, 7)]
    for a in [Q(0), Q(1, 2), Q(1), Q(3)]:
        for c in [Q(-1), Q(0), Q(3, 2)]:
            for u in values:
                for v in values:
                    if v - u <= a:
                        alpha, _ = dual(u, a, c)
                        _, beta = dual(v, a, c)
                        require((u - v) ** 2 <= alpha + beta, "pointwise dual bound")
                        require(envelope(u - c, a) <= 4 * a * abs(u - c), "pointwise MAD")
                        checks += 1
    return checks


def sharpness_checks():
    results = []
    for k in [2, 4, 10, 100, 1000]:
        c, a = Q(k - 1, 2), Q(1)
        cost = sum(Q((i - ((i + 1) % k)) ** 2, k) for i in range(k))
        mad = sum(abs(Q(i) - c) / k for i in range(k))
        require(cost == k - 1, "cyclic cost")
        require(mad == Q(k, 4), "even uniform MAD")
        ratio = cost / (a * mad)
        require(ratio == 4 - Q(4, k), "sharpness ratio")
        require(all(((i + 1) % k) - i <= a for i in range(k)), "cyclic support")
        results.append({"k": k, "cost": str(cost), "mad": str(mad), "ratio": str(ratio)})
    return results


def rejection_checks(fixture):
    mutations = []
    bad = copy.deepcopy(fixture)
    bad["primal"][0][2] = "-1"
    mutations.append(bad)
    bad = copy.deepcopy(fixture)
    bad["dual_u"][0] = "-1000"
    mutations.append(bad)
    bad = copy.deepcopy(fixture)
    bad["primal"][0][2] = str(Q(bad["primal"][0][2]) + Q(1, 1000))
    mutations.append(bad)
    bad = copy.deepcopy(fixture)
    bad["objective"] = str(Q(bad["objective"]) + 1)
    mutations.append(bad)
    bad = copy.deepcopy(fixture)
    bad["primal"][0][0:2] = [0, fixture["n"]]
    mutations.append(bad)
    for bad in mutations:
        try:
            verify_fixture(bad)
        except AssertionError:
            continue
        raise AssertionError("corrupted certificate was accepted")
    return len(mutations)


def verify_jacobian():
    request_path, result_path = ROOT / "jacobian_request.json", ROOT / "jacobian_result.json"
    status_path = ROOT / "jacobian_status.json"
    require(request_path.exists() and result_path.exists() and status_path.exists(), "missing Jacobian evidence")
    request = json.loads(request_path.read_text())
    response = json.loads(result_path.read_text())
    status = json.loads(status_path.read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not succeed")
    require(status["operation_id"] == "matrix.rational_linear_system.solve", "wrong Jacobian operation")
    require(response["server"]["version"] == "0.14.0", "unexpected archived server version")
    require(response["protocol_version"] == "2025-11-25", "unexpected archived protocol")
    require(response["request"]["payload"] == request, "Jacobian payload mismatch")
    require(response["request"]["operation_id"] == status["operation_id"], "Jacobian request operation mismatch")
    output = response["result"]
    if "output" in output:
        output = output["output"]
    require(output["matrix"] == request["matrix"] and output["rhs"] == request["rhs"], "Jacobian echoed a different system")
    def rational(value):
        return Q(int(value["num"]), int(value["den"]))
    require(output["outcome"] == "UNIQUE", "Jacobian returned no unique solution")
    solution = [rational(value) for value in output["solution"]]
    matrix = [[rational(value) for value in row] for row in request["matrix"]["entries"]]
    rhs = [rational(value) for value in request["rhs"]]
    require(len(solution) == 4 and solution == [Q(1, 4)] * 4, "wrong Jacobian fixture solution")
    require(
        all(sum(a * x for a, x in zip(row, solution)) == b for row, b in zip(matrix, rhs)),
        "Jacobian solution does not replay",
    )
    return {
        "operation_id": status["operation_id"],
        "server_version": response["server"]["version"],
        "protocol_version": response["protocol_version"],
        "adapter_exit_code": status["adapter_exit_code"],
        "meaning": "Unique masses on (0,1),(1,2),(1,1),(2,0) for the n=2,d=1 binomial fixture; not a universal proof.",
    }


def certificate_data():
    selected = [(0, 0), (1, 0), (1, 1), (2, 1), (3, 1), (4, 2), (5, 2),
                (8, 1), (9, 3), (16, 2), (32, 1), (64, 0), (64, 8), (64, 64)]
    fixtures = [binomial_fixture(n, d) for n, d in selected]
    for name, masses in [
        ("uniform", [Q(1, 6)] * 6),
        ("central-plateau", [Q(1, 12), Q(1, 6), Q(1, 4), Q(1, 4), Q(1, 6), Q(1, 12)]),
        ("zero-endpoints", [Q(0), Q(1, 4), Q(1, 2), Q(1, 4), Q(0)]),
        ("point-mass", [Q(0), Q(0), Q(1), Q(0), Q(0)]),
    ]:
        for d in range(len(masses)):
            fixtures.append(make_fixture(f"{name}-{d}", masses, d))
    return {
        "claim": "C_BINOM127",
        "result_class": "exact_verification_fixtures_for_parameter_uniform_theorems",
        "scope": "Exact finite primal and dual feasibility plus equality of objectives; the universal proof is in report.md and the finite coupling core in Main.lean.",
        "novelty_status": "not_independently_assessed",
        "fixtures": fixtures,
        "sharpness": sharpness_checks(),
        "jacobian": verify_jacobian(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    expected = certificate_data()
    certificate_path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        certificate_path.write_text(json.dumps(expected, indent=2) + "\n")
    require(certificate_path.exists(), "run --write-certificate once to materialize the certificate")
    certificate = json.loads(certificate_path.read_text())
    require(certificate == expected, "certificate differs from the declared deterministic construction")
    dual_checks = sum(verify_fixture(fixture) for fixture in certificate["fixtures"])
    sweep_count = 0
    for n in range(17):
        for d in range(n + 1):
            dual_checks += verify_fixture(binomial_fixture(n, d))
            sweep_count += 1
    points = pointwise_checks()
    rejected = rejection_checks(binomial_fixture(4, 1))
    print(json.dumps({
        "status": "pass",
        "certificate_fixtures": len(certificate["fixtures"]),
        "additional_binomial_fixtures": sweep_count,
        "exact_dual_inequalities": dual_checks,
        "pointwise_checks": points,
        "rejected_corruptions": rejected,
        "sharpness_ratio_at_k_1000": certificate["sharpness"][-1]["ratio"],
        "scope": "Finite exact replay; universal proofs and statement-fidelity review remain separate.",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
