#!/usr/bin/env python3
"""Replay exact diagnostics and check the source-bound real Lean certificate."""

import hashlib
import json
import math
from collections import Counter
from fractions import Fraction
from itertools import product
from pathlib import Path


HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def read_json(name):
    return json.loads((HERE / name).read_text(encoding="utf-8"))


def check_fibers():
    cases = 0
    sharpness = None
    for p in (2, 3, 5, 7, 11):
        for k in range(3):
            for omitted in product(range(p), repeat=k):
                consumed = [sum(o != x for o in omitted) for x in range(p)]
                if k < p:
                    require(max(consumed) == k, "An unused lift was not found")
                    for n in range(k + 2):
                        capacity = all(d <= n for d in consumed)
                        require(not capacity or k <= n, "Fiber capacity failed")
                for x in range(p):
                    require(k - consumed[x] == omitted.count(x),
                            "Drop multiplicity was lost at a collision")
                if p == k == 2 and omitted == (0, 1):
                    require(max(consumed) == 1, "The sharpness example changed")
                    sharpness = {"p": p, "lists": k, "omitted": list(omitted),
                                 "initial_rank": 1, "consumed": consumed}
                cases += 1
    require(sharpness is not None, "Missing out-of-scope sharpness example")
    return cases, sharpness


def check_euler():
    cases = 0
    for M in range(1, 5):
        for centers in product(range(M), repeat=2):
            multiplicity = Counter(centers)
            for n in product(range(3), repeat=M):
                if any(n[a] < multiplicity[a] for a in range(M)):
                    continue
                for gamma in range(3):
                    if sum(n) + M * gamma != 2:
                        continue
                    require(gamma == 0, "A positive Euler term survived")
                    require(all(n[a] == multiplicity[a] for a in range(M)),
                            "Euler saturation failed")
                    cases += 1
    return cases


def check_divisors():
    cases = 0
    for m in product(range(1, 8), repeat=2):
        for b in product(range(-6, 7), repeat=2):
            ratios = [Fraction(bi, mi) for bi, mi in zip(b, m)]
            h = -math.floor(min(ratios))
            C = h + math.ceil(max(ratios))
            require(C >= 0, "Negative thickness comparison constant")
            for s in (C + 1, C + 2):
                T = [(s - h) * mi - bi for mi, bi in zip(m, b)]
                require(all((s - C) * mi <= ti <= s * mi
                            for mi, ti in zip(m, T)),
                        "Signed nonreduced thickness bounds failed")
            for l in range(-2, 3):
                t = l - h
                require(l - 1 + min(ratios) < t <= l + min(ratios),
                        "Canonical endpoint floor has the wrong sign")
                for candidate in (t - 1, t + 1):
                    require(not (l - 1 + min(ratios) < candidate
                                 <= l + min(ratios)),
                            "Canonical integral pole ratio is not unique")
            if math.gcd(*m) == 1:
                for denominator in range(1, 7):
                    t = Fraction(1, denominator)
                    if all((t * mi).denominator == 1 for mi in m):
                        require(t.denominator == 1, "Primitivity failed")
            cases += 1
    require(all((Fraction(1, 2) * mi).denominator == 1 for mi in (2, 4)),
            "The nonprimitive boundary diagnostic changed")
    for p in (5, 7):
        for exponent in range(3):
            P = p ** exponent
            for j, m, v in product(range(-3, 4), range(1, 8), range(-3, 4)):
                t = j * P
                b = t * m + P * v
                require(b - t * m == P * v and b % P == 0,
                        "The powered coefficient sign is inconsistent")
    return cases


def check_integer_lifting():
    cases = 0
    for N in range(1, 25):
        for C in range(N):
            for e, f in product(range(C + 1), repeat=2):
                if (f - e) % N == 0:
                    require(e == f, "Bounded congruent offsets differed")
                cases += 1
        for x in range(1, 2 * N):
            if x % N == 0:
                require(x == N, "Positive congruence did not lift uniquely")
    return cases


def centered(p, M, d, c):
    return 2 * (p + 1) * d - 2 * p * M + (p + 1) * c


def check_tails():
    cases = 0
    for p, M, c, initial in product((2, 3, 5, 7, 11), range(1, 9),
                                   range(-2, 4), range(-4, 5)):
        d = initial
        K = centered(p, M, d, c)
        for n in range(12):
            period = M * p ** n
            require(centered(p, period, d, c) == (-1) ** n * K,
                    "All-index tail invariant failed in a diagnostic")
            exact = (Fraction(p * period, p + 1) - Fraction(c, 2)
                     + Fraction((-1) ** n * K, 2 * (p + 1)))
            require(exact == d, "Closed tail formula failed")
            dn = p * period - d - c
            dnn = p * p * period - dn - c
            if dn >= p * d and dnn >= p * dn:
                require(abs(K) <= (p - 1) * c, "Growth bound failed")
            d = dn
        cases += 1
    return cases


def canonical_rational(item):
    numerator, denominator = int(item["num"]), int(item["den"])
    require(denominator > 0, "Nonpositive Jacobian rational denominator")
    require(math.gcd(numerator, denominator) == 1, "Unreduced Jacobian rational")
    require(str(numerator) == item["num"] and str(denominator) == item["den"],
            "Noncanonical Jacobian decimal")
    return Fraction(numerator, denominator)


def check_jacobian(certificate):
    payload = read_json("jacobian_payload.json")
    result = read_json("jacobian_output.json")
    recorded = certificate["jacobian"]
    operation = recorded["operation_id"]
    require(recorded["adapter_exit_code"] == 0, "Adapter did not succeed")
    require(recorded["timeout"] is False, "A timeout is not evidence")
    require(result["server"]["version"] == recorded["server_version"],
            "Jacobian server version changed")
    require(result["protocol_version"] == recorded["protocol_version"],
            "Jacobian protocol changed")
    require(result["tool"] == "math.run", "Not an executed operation")
    require(result["request"] == {"operation_id": operation, "payload": payload},
            "Typed result is not bound to the exact payload")
    require(result["result"]["operation_id"] == operation, "Wrong operation")
    output = result["result"]["output"]
    require(output["exactness"] == "EXACT_RATIONAL"
            and output["determinism"] == "DETERMINISTIC",
            "Incomplete or nonexact output is not evidence")
    coefficients = list(map(canonical_rational, payload["coefficients"]))
    sequence = list(map(canonical_rational, payload["initial_values"]))
    require(coefficients == [5, 1, -5] and sequence == [1, 8, 41],
            "The example no longer matches the stated width recurrence")
    require(payload["term_count"] == 12, "Unexpected finite operation scope")
    for n in range(len(sequence), payload["term_count"]):
        sequence.append(sum(coefficients[j - 1] * sequence[n - j]
                            for j in range(1, len(coefficients) + 1)))
    require(list(map(canonical_rational, output["replay_prefix"])) == sequence,
            "Independent exact recurrence replay disagreed")
    require(output["replay_scope_end"] == len(sequence) - 1, "Incomplete prefix")
    values = output["values"]
    require([item["index"] for item in values] == list(range(len(sequence))),
            "Incomplete indexed result")
    require([canonical_rational(item["value"]) for item in values] == sequence,
            "Indexed result disagreed with its replay prefix")
    for n, d in enumerate(sequence):
        M = 2 * 5 ** n
        require(0 < d < M and centered(5, M, d, 1) == (-1) ** n * -2,
                "Example is not an admissible abstract width tail")
        if n + 1 < len(sequence):
            dn = sequence[n + 1]
            require(dn >= 5 * d and dn + d + 1 == 5 * M,
                    "Example violates Frobenius growth or exact recurrence")
            old = Counter((int(-d) % (5 * M), int(1 + d) % (5 * M)))
            new = Counter((int(-dn) % (5 * M), int(1 + dn) % (5 * M)))
            require(old == new, "Swapped residues failed with multiplicities")
    return len(sequence)


def check_lean(certificate):
    formal = certificate["formal"]
    result = read_json(formal["compiler_record"])
    require(result["status"] == "success" and result["exit_code"] == 0,
            "The real Lean compiler has not accepted this source")
    require(result["audit_exit_code"] == 0, "The Lean axiom audit did not finish")
    require(result["environment_failure"] == "", "The Lean environment failed")
    require(result["proof_holes"] == [], "Lean proof holes remain")
    version = result["tools"]["lean"]["version"]
    require("version 4.31.0," in version, "Not the required Lean toolchain")
    source = (HERE / formal["source"]).read_bytes()
    fidelity = (HERE / formal["statement_fidelity"]).read_text(encoding="utf-8")
    require(hashlib.sha256(source).hexdigest() == result["source_sha256"],
            "Lean source changed after compilation")
    require(hashlib.sha256(fidelity.encode("utf-8")).hexdigest()
            == result["statement_fidelity_sha256"],
            "Statement fidelity changed after compilation")
    declarations = {line.split()[1] for line in source.decode("utf-8").splitlines()
                    if line.startswith("theorem ")}
    require(set(formal["declarations"]).issubset(declarations),
            "A declared formal conclusion is missing")
    return version


def main():
    certificate = read_json("exact_certificate.json")
    require(certificate["claim_id"] == "C_SJR_CORE", "Wrong claim certificate")
    require(certificate["abundance_theorem_certified"] is False,
            "This evidence must not be relabeled as abundance")
    fibers, sharpness = check_fibers()
    report = {
        "status": "verified",
        "scope": "Quantified discrete jet core; geometric bridge is prose, not Lean",
        "formal_compiler": check_lean(certificate),
        "finite_diagnostics_not_the_proof": {
            "fiber_configurations": fibers,
            "saturated_euler_configurations": check_euler(),
            "signed_nonreduced_divisor_configurations": check_divisors(),
            "bounded_offset_configurations": check_integer_lifting(),
            "exact_recurrence_tails": check_tails(),
            "jacobian_prefix_terms": check_jacobian(certificate),
        },
        "sharpness_outside_manuscript_scope": sharpness,
        "independent_review": certificate["independent_review"]["status"],
        "abundance_theorem_certified": False,
    }
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
