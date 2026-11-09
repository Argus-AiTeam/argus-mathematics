#!/usr/bin/env python3
"""Replay exact diagnostics and fresh-source checks; --compile reruns Argus Lean certification."""

import argparse
import json
import subprocess
from fractions import Fraction as F
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARGUS = Path("$WORKSPACE/argus-live-update/.venv/bin/python")


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def load(path):
    return json.loads((ROOT / path).read_text())


def argus(module, *args):
    result = subprocess.run(
        [str(ARGUS), "-m", f"argus_skill.verticals.math.{module}", *args],
        cwd=ROOT, text=True, capture_output=True, timeout=115, check=False,
    )
    if result.returncode:
        raise RuntimeError(
            f"{module} exited {result.returncode}:\n{result.stdout}\n{result.stderr}"
        )
    return result.stdout


def exp_upper(x, terms=24):
    check(0 <= x < terms + 2, "exponential remainder ratio must be less than one")
    term = total = F(1)
    for k in range(1, terms + 1):
        term *= x / k
        total += term
    return total + term * x / (terms + 1) / (1 - x / (terms + 2))


def ceil(x):
    return -(-x.numerator // x.denominator)


def parameter_samples(expected):
    z = F(1, 3)
    terms = 24
    low = 2 * sum((z ** (2 * k + 1) / (2 * k + 1) for k in range(terms)), F(0))
    high = low + 2 * z ** (2 * terms + 1) / ((2 * terms + 1) * (1 - z * z))
    results = []
    for power, sample in zip((2, 4, 6), expected, strict=True):
        N = 2 ** power
        n, M = N ** 5, N ** 10
        tlo, thi = power * low, power * high
        qlo, qhi = ceil(2 * tlo * tlo), ceil(2 * thi * thi)
        check(qlo == qhi, "log interval did not determine the ceiling")
        observed = {"N": N, "n": n, "q": qlo, "M": M}
        check(observed == sample, "parameter sample differs from certificate")
        d0, d1, eps = F(1, 2 ** (5 * power // 2)), F(1, 2 ** (power // 2)), F(1, N ** 2)
        check(tlo >= 1 and n * d0 >= 1 and N * d1 >= 1, "count thresholds")
        check(d0 * exp_upper(thi / 10) <= eps, "index exponential threshold")
        R_upper = 1 / (1 - 1 / (1000 * tlo))
        check((d1 + eps) * (R_upper ** qlo - 1) <= 1, "macro geometric threshold")
        check(N * qlo * n <= M and n * n == M, "partition and floor relations")
        results.append(observed)
    return results


def polynomial(document):
    check(document["domain"] == "QQ", "wrong coefficient ring")
    check(document["variables"] == ["a", "c", "d", "x"], "wrong polynomial variables")
    result = {}
    for term in document["polynomial"]["terms"]:
        exponents = tuple(term["exponents"])
        check(len(exponents) == 4 and all(e >= 0 for e in exponents), "invalid monomial")
        rational = term["coefficient"]
        value = F(int(rational["num"]), int(rational["den"]))
        check(value != 0 and exponents not in result, "noncanonical sparse polynomial")
        check(str(value.numerator) == rational["num"] and str(value.denominator) == rational["den"],
              "noncanonical rational coefficient")
        result[exponents] = value
    return result


def multiply(left, right):
    result = {}
    for a, x in left.items():
        for b, y in right.items():
            e = tuple(i + j for i, j in zip(a, b, strict=True))
            result[e] = result.get(e, F(0)) + x * y
    return {e: x for e, x in result.items() if x}


def jacobian_check(spec):
    payload, contract, output = (load(spec[k]) for k in ("payload", "contract", "output"))
    check(contract["result"]["operation"]["operation_id"] == spec["operation_id"], "wrong contract")
    check(output["server"]["version"] == spec["server_version"], "wrong Jacobian server")
    check(output["protocol_version"] == spec["protocol_version"], "wrong MCP protocol")
    check(output["request"]["operation_id"] == spec["operation_id"], "wrong operation")
    check(output["request"]["payload"] == payload, "Jacobian result is bound to another payload")
    typed = output["result"]["output"]
    check(typed["status"] == spec["status"], "Jacobian did not return a factorization")
    check(typed["product_reconstruction"] == "EXACT", "incomplete Jacobian reconstruction")
    coefficient = typed["coefficient"]
    product = {(0, 0, 0, 0): F(int(coefficient["num"]), int(coefficient["den"]))}
    for factor in typed["factors"]:
        for _ in range(factor["multiplicity"]):
            product = multiply(product, polynomial(factor["factor"]))
    check(product == polynomial(payload["polynomial"]), "factor product is not the requested polynomial")
    check(product == polynomial(typed["reconstructed"]), "wrong reconstructed polynomial")
    check(product == {
        (2, 0, 1, 0): F(1), (1, 1, 0, 0): F(1),
        (1, 0, 1, 1): F(2), (0, 1, 0, 1): F(2),
    }, "factorization does not certify the shifted recurrence identity")
    return {"operation_id": spec["operation_id"], "status": typed["status"], "factors": len(typed["factors"])}


def regression(case):
    n, q, N = 8, 5, 2
    size = n * q * N
    u, eta, a0, a1, d0, d1, eps = F(1, 4), F(1, 32), F(2), F(64), F(1, 8), F(1, 2), F(1, 2)
    check(n * d0 >= 1 and N * d1 >= 1 and q * u > 1, "fixture count thresholds")
    check(d0 * exp_upper(2 * u / a0) <= eps, "fixture index threshold")
    check((d1 + eps) * ((a1 / (a1 - a0)) ** q - 1) <= 1, "fixture macro threshold")
    weights = [F(1, size)] * size
    if case == "both_skips":
        weights = [F(0)] * size
        weights[0], weights[72], weights[79] = F(3, 5), F(1, 5), F(1, 5)
    if case == "threshold_equal":
        weights = [F(0)] * size
        weights[32], weights[39], weights[79] = F(1, 8), F(3, 8), F(1, 2)
    endpoints, remaining = [], F(1)
    for weight in weights:
        endpoints.append(remaining)
        remaining -= weight
        endpoints.append(remaining)
    a, cost = [F(1)] * (size + 1), F(0)
    metrics = {k: 0 for k in (
        "updates", "index_skips", "macro_skips", "width_increases", "overshoots",
        "clipped_targets", "index_threshold_equal", "macro_threshold_equal",
    )}
    macro_segments = []

    def telescope(segments):
        for left, right in zip(segments, segments[1:]):
            check(right[0] <= left[1], "entry/exit endpoints do not telescope")
        return sum((hi - lo for hi, lo, _ in segments), F(0))

    def finish(j):
        check(a[j] <= eta, "no discovery at final index")
        check(cost <= 2 * a1 + 2 * a0 <= 4 * a1, "total cost bound")
        span = telescope(macro_segments)
        check(span <= 1, "macro spans exceed one")
        check(sum((c for _, _, c in macro_segments), F(0)) <= a1 * span, "skipped macro costs")
        return {"case": case, "index": j, "cost": str(cost), **metrics}

    for macro in range(N):
        base, last = macro * q * n, (macro + 1) * q * n - 1
        macro_hi, macro_cost = endpoints[2 * base], cost
        targets = []
        skipped_macro = False
        for sub in reversed(range(q)):
            P, c1 = macro_hi - endpoints[2 * last + 1], cost - macro_cost
            check(0 <= P <= 1, "macro envelope left normalized range")
            metrics["macro_threshold_equal"] += P == c1 / a1 + d1
            if P > c1 / a1 + d1:
                metrics["macro_skips"] += 1
                macro_segments.append((macro_hi, endpoints[2 * last + 1], c1))
                skipped_macro = True
                break
            check(c1 <= a1, "continuing macro prefix exceeded its geometric budget")
            sub_cost, segments = cost, []
            terminal = False
            for j in range(base + sub * n, base + (sub + 1) * n):
                entry_hi, entry_a, entry_cost = endpoints[2 * j], a[j], cost
                target_sum, iterations = F(0), 0
                while True:
                    check(iterations <= ceil(u / eta), "index loop exceeded its exact fuel")
                    c0, drop = cost - entry_cost, entry_a - a[j]
                    check(c0 <= a0 * eps, "index cost bound")
                    check(0 <= target_sum <= min(u, drop), "target clipping or overshoot invariant")
                    p = entry_hi - endpoints[2 * j + 1]
                    if a[j] <= eta:
                        status = "good"
                        break
                    if drop >= u:
                        status = "target"
                        break
                    metrics["index_threshold_equal"] += p == c0 / a0 + d0
                    if p > c0 / a0 + d0:
                        status = "skip"
                        break
                    x = min(eta, u - drop)
                    check(0 < x <= eta, "invalid partial-observation target")
                    old_a, old_e, old_cost = a[:], endpoints[:], cost
                    width = endpoints[2 * j] - endpoints[2 * j + 1]
                    actual = min(a[j], x * (F(3, 2) if case == "overshoot" else 1))
                    a[:j + 1] = [min(value, a[j] - actual) for value in a[:j + 1]]
                    cost += 2 * width * x
                    if case == "width_growth":
                        cut = endpoints[2 * j + 1] / 2
                        endpoints[2 * j + 1:] = [min(value, cut) for value in endpoints[2 * j + 1:]]
                    check(old_a[j] - a[j] >= x, "offer did not deliver the requested decrease")
                    check(0 <= cost - old_cost <= 2 * width * x, "offer cost contract")
                    check(all(0 <= value <= 1 for value in a + endpoints), "normalization")
                    check(all(x <= y for x, y in zip(a, a[1:])), "a index ordering")
                    check(all(x >= y for x, y in zip(endpoints, endpoints[1:])), "endpoint ordering")
                    check(all(x <= y for x, y in zip(a, old_a)), "a increased under refinement")
                    check(all(x <= y for x, y in zip(endpoints, old_e)), "endpoint increased under refinement")
                    metrics["updates"] += 1
                    metrics["overshoots"] += actual > x
                    metrics["clipped_targets"] += x < eta
                    metrics["width_increases"] += endpoints[2 * j] - endpoints[2 * j + 1] > width
                    target_sum += x
                    iterations += 1
                if status == "skip":
                    check(p > d0 and c0 <= a0 * p, "index skip contract")
                    metrics["index_skips"] += 1
                    segments.append((entry_hi, endpoints[2 * j + 1], c0))
                    check(telescope(segments) <= macro_hi - endpoints[2 * last + 1], "skipped subblock span")
                    continue
                terminal = True
                P = macro_hi - endpoints[2 * last + 1]
                check(cost - sub_cost <= a0 * (P + eps), "subblock cost bound")
                if status == "good":
                    return finish(j)
                if targets:
                    check(j < targets[-1][0] and entry_a <= targets[-1][2], "target entry/exit telescope")
                targets.append((j, entry_a, a[j]))
                check(sum((x - y for _, x, y in targets), F(0)) <= 1, "target drops exceed one")
                break
            check(terminal, "all indices were skipped despite the count hypothesis")
        check(skipped_macro, "macro exhausted without skip or discovery")
    raise AssertionError("all macroblocks skipped despite the count hypothesis")


def lean_check(spec, recompile):
    source, fidelity = ROOT / spec["source"], ROOT / spec["statement_fidelity"]
    native = load(spec["certificate"])
    check(native["subject"]["subject_id"] == "C_ER_FINITE", "wrong certified claim")
    check(native["tier"] == "mechanical" and native["verdict"] == "supports", "not a mechanical proof")
    check((ROOT / native["lean_source"]["path"]).read_bytes() == source.read_bytes(),
          "working source differs from the compiled archive")
    check(native["lean_source"]["text"] == source.read_text(), "source differs from certificate")
    check((ROOT / native["statement_fidelity"]["path"]).read_bytes() == fidelity.read_bytes(),
          "working fidelity differs from the compiled archive")
    check(native["statement_fidelity"]["text"] == fidelity.read_text(), "fidelity differs from certificate")
    if recompile:
        result = json.loads(argus(
            "lean_evidence", "verify", str(source), "--statement-fidelity", str(fidelity),
            "--artifact-dir", str(HERE), "--claim", "C_ER_FINITE",
            "--project-root", str(ROOT), "--timeout", "100",
        ))
        check(result["status"] == "success" and result["proof_holes"] == [], "compiler replay failed")
        native = load(spec["certificate"])
    result = native["lean_check"]
    check(result["status"] == "success" and result["exit_code"] == 0, "no successful compiler result")
    check(result["audit_exit_code"] == 0 and result["proof_holes"] == [], "unresolved proof holes")
    check("version 4.31.0," in result["tools"]["lean"]["version"], "wrong Lean compiler")
    for name in ("finite_search", "manuscript_search"):
        expected = f"'EntropyRefinement.{name}' depends on axioms: [propext, Classical.choice, Quot.sound]"
        check(expected in result["stdout"], "unexpected theorem axioms")
    freshness = json.loads(argus("lean_evidence", "check", "--project-root", str(ROOT)))
    check(freshness["ok"], "native Lean evidence is stale")
    return {"claim": "C_ER_FINITE", "exit_code": 0, "proof_holes": [], "recompiled": recompile}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compile", action="store_true", help="rerun the real Argus compiler/audit and refresh its claim evidence")
    args = parser.parse_args()
    certificate = load("research/entropy_refinement/exact_certificate.json")
    check(certificate["result_class"] == "formal_verification", "incorrect result classification")
    symbolic = jacobian_check(certificate["jacobian"])
    samples = parameter_samples(certificate["parameter_samples"])
    cases = [regression(case) for case in certificate["regression_cases"]]
    for case in cases:
        expected = certificate["regression_results"][case["case"]]
        check({k: case[k] for k in expected} == expected, "exact regression witness changed")
    for event in certificate["required_regression_events"]:
        check(sum(case[event] for case in cases) > 0, f"unexercised event: {event}")
    formal = lean_check(certificate["lean"], args.compile)
    state = json.loads(argus("math_state", "check", "--project-root", str(ROOT)))
    check(state["ok"], "campaign ledger failed")
    argus("proof_graph_check", "check", "--project-root", str(ROOT))
    print(json.dumps({
        "status": "verified",
        "result_class": certificate["result_class"],
        "lean": formal, "jacobian": symbolic,
        "parameter_samples": samples, "regressions": cases,
        "campaign_validation": {
            "project_root": str(ROOT), "math_state_exit_code": 0, "proof_graph_exit_code": 0,
        },
        "manuscript_transfer": "conditional_on_recorded_entropy_inputs",
        "independent_review": certificate["independent_review"],
    }, indent=2))


if __name__ == "__main__":
    main()
