#!/usr/bin/env python3
"""Replay exact adversarial checks and the universal Lean certificate."""

import argparse
from bisect import bisect_right
from collections import Counter
from fractions import Fraction as Q
from itertools import product
import json
from pathlib import Path
import re
import subprocess
import time

from build_cone import HERE, ROOT, build, digest


ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
ARCS = tuple((Q(2 * i + 1, 10), Q(2 * i + 2, 10)) for i in range(4))


def homeo(s, y):
    p = s - (s % 2)
    a, b = ARCS[p]
    c, d = ARCS[p + 1]
    if s % 2 == 0:
        j = (y - c).__floor__()
        x = y - j
        if x <= d:
            return b - 1 + (x - c) * (a - b + 1) / (d - c) + j
        return a + (x - d) * (b - a) / (c + 1 - d) + j
    j = (y - (b - 1)).__floor__()
    x = y - j
    if x <= a:
        return c + (x - (b - 1)) * (d - c) / (a - b + 1) + j
    return d + (x - a) * (c + 1 - d) / (b - a) + j


def action(word, y):
    for s in reversed(word):
        y = homeo(s, y)
    return y


def inside(s, y):
    a, b = ARCS[s]
    x = y - y.__floor__()
    return a <= x < b


def chi(s, y):
    return int(inside(s, y)) - (s % 2)


def cocycle(word, y):
    value = 0
    for s in word:
        value += chi(s, y)
        y = homeo(s ^ 1, y)
    return value


def reduce_word(word):
    stack = []
    for s in word:
        if stack and stack[-1] == (s ^ 1):
            stack.pop()
        else:
            stack.append(s)
    return tuple(stack)


def prefix_norm(coefficients):
    current = 0
    maximum = 0
    for value in coefficients:
        current += value
        maximum = max(maximum, abs(current))
    return maximum


def audit_prefix(word):
    n = len(word)
    length = 8 * (n + 1)
    a, b = length // 4, 3 * length // 4
    reduced = reduce_word(word)
    ell = len(reduced)
    negative = sum(s % 2 for s in reduced)
    orbit = action(word, Q(0))
    z = orbit - orbit.__floor__()
    labels = []
    points = set()
    for i, s in enumerate(word):
        positive = s - (s % 2)
        prefix = word[:i] if s % 2 == 0 else word[: i + 1]
        sign = 1 if s % 2 == 0 else -1
        label = Counter()
        for j in range(length):
            left = action(prefix, ARCS[positive][0] + j)
            right = action(prefix, ARCS[positive][1] + j)
            assert left < right
            label[left] += sign
            label[right] -= sign
        assert len(label) == 2 * length
        assert sum(label.values()) == 0
        assert sum(abs(v) for v in label.values()) == 2 * length
        assert prefix_norm([label[x] for x in sorted(label)]) == 1
        labels.append(label)
        points.update(label)
    probes = [Q(j) for j in range(a, b + 1)]
    if ell:
        assert 0 < z < 1
        probes.extend(z + j for j in range(a, b + 1))
    points.update(probes)
    ordered = sorted(points)
    total = Counter()
    for label in labels:
        total.update(label)
    coefficients = [total[x] for x in ordered]
    assert sum(coefficients) == 0
    cumulative = [0]
    for value in coefficients:
        cumulative.append(cumulative[-1] + value)

    def prefix_at(y):
        return cumulative[bisect_right(ordered, y)]

    for y0 in probes:
        y = y0
        for s in word:
            assert 0 < y < length
            y = homeo(s ^ 1, y)
            assert 0 < y < length
        assert prefix_at(y0) == cocycle(word, y0)
    for j in range(a, b + 1):
        assert prefix_at(Q(j)) == -negative
        if ell:
            assert prefix_at(z + j) == ell - negative
    if ell:
        cuts = [Q(a)]
        for j in range(a, b):
            cuts.extend((z + j, Q(j + 1)))
        values = [0] + [prefix_at(cut) for cut in cuts] + [0]
        compressed = [v - u for u, v in zip(values, values[1:])]
        assert compressed == [-negative] + [ell, -ell] * (b - a) + [negative]
        assert bisect_right(ordered, Q(b)) < len(ordered)
        assert sum(abs(v) for v in compressed) <= sum(abs(v) for v in coefficients)
        assert prefix_norm(compressed) <= prefix_norm(coefficients)
        assert Q(sum(abs(v) for v in coefficients)) >= Q(ell, 6) * (2 * length)
        assert Q(prefix_norm(coefficients)) >= Q(ell, 6)
    return len(probes)


def exact_checks():
    boundary_checks = 0
    probes = {Q(0)}
    for a, b in ARCS:
        probes.update((a, b, (a + b) / 2))
    for s, y0, j in product(range(4), sorted(probes), (-1, 0, 1)):
        y = y0 + j
        assert homeo(s ^ 1, homeo(s, y)) == y
        assert homeo(s, y + 1) == homeo(s, y) + 1
        assert abs(homeo(s, y) - y) < 2
        assert inside(s ^ 1, homeo(s ^ 1, y)) == (not inside(s, y))
        assert chi(s ^ 1, homeo(s ^ 1, y)) == -chi(s, y)
        boundary_checks += 1
    word_checks = 0
    prefix_checks = 0
    prefix_probes = 0
    enumeration_counts = {}
    for n in range(1, 7):
        counts = Counter()
        for word in product(range(4), repeat=n):
            reduced = reduce_word(word)
            ell = len(reduced)
            counts[ell] += 1
            negative = sum(s % 2 for s in reduced)
            orbit = action(word, Q(0))
            assert orbit == action(reduced, Q(0))
            assert abs(orbit) < 2 * n
            assert cocycle(word, Q(0)) == -negative
            assert cocycle(word, orbit) == ell - negative
            assert cocycle(word, Q(1)) == -negative
            assert cocycle(word, orbit - 1) == ell - negative
            if ell:
                alpha, beta = ARCS[reduced[0]]
                assert alpha < orbit - orbit.__floor__() < beta
            if n <= 3:
                prefix_probes += audit_prefix(word)
                prefix_checks += 1
            word_checks += 1
        enumeration_counts[n] = dict(counts)
    counts = {0: 1}
    tails = []
    for n in range(1, 65):
        next_counts = Counter()
        for ell, count in counts.items():
            if ell == 0:
                next_counts[1] += 4 * count
            else:
                next_counts[ell - 1] += count
                next_counts[ell + 1] += 3 * count
        counts = dict(next_counts)
        assert sum(counts.values()) == 4**n
        if n <= 6:
            assert counts == enumeration_counts[n]
        mean = Q(sum(ell * count for ell, count in counts.items()), 4**n)
        tail = Q(sum(count for ell, count in counts.items() if 4 * ell >= n), 4**n)
        assert mean >= Q(n, 2)
        assert tail >= Q(1, 4)
        assert tail - Q(1, 10) >= Q(3, 20)
        tails.append({"n": n, "mean": str(mean), "tail_at_n_over_4": str(tail)})
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    assert status["exit_code"] == 0
    assert response["request"]["payload"] == payload
    assert response["result"]["operation_id"] == status["operation_id"]
    output = response["result"]["output"]
    assert output["unique"] is True
    extreme, = output["extreme_distributions"]
    assert extreme["closed_class"] == list(range(4))
    pi = [Q(int(x["num"]), int(x["den"])) for x in extreme["distribution"]]
    matrix = [[Q(int(x["num"]), int(x["den"])) for x in row] for row in payload["matrix"]]
    assert pi == [Q(1, 4)] * 4
    for j in range(4):
        assert sum(pi[i] * matrix[i][j] for i in range(4)) == pi[j]
        for i in range(4):
            assert pi[i] * matrix[i][j] == pi[j] * matrix[j][i]
    return {
        "classification": "bounded exact adversarial tests, not the universal proof",
        "boundary_checks": boundary_checks,
        "words_through_length_6": word_checks,
        "full_prefix_and_compression_words_through_length_3": prefix_checks,
        "transported_prefix_probes": prefix_probes,
        "admissible_norm_examples": ["l1", "maximum absolute coefficient-prefix sum"],
        "reduced_length_distributions_through_time": 64,
        "reduced_length_results": tails,
        "jacobian": {
            "operation_id": status["operation_id"],
            "server_version": response["server"]["version"],
            "protocol_version": response["protocol_version"],
            "stationary_distribution": [str(x) for x in pi],
            "scope": "four-state independent uniform letter component only",
        },
    }


def local_gates():
    records = {}
    for name in ("math_state", "proof_graph_check"):
        command = [
            ARGUS, "-m", f"argus_skill.verticals.math.{name}",
            "check", "--project-root", str(ROOT),
        ]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        records[name] = {
            "command": command, "exit_code": completed.returncode,
            "stdout": completed.stdout, "stderr": completed.stderr,
        }
    data = {"project_root": str(ROOT), "checks": records}
    (HERE / "validation.json").write_text(json.dumps(data, indent=2) + "\n")
    if any(record["exit_code"] for record in records.values()):
        raise RuntimeError(f"Campaign-local gates failed: {json.dumps(data)}")
    return data


def verified_claim_record(payload):
    recording = payload["kernel"]
    record = recording["recorded"]
    if recording["refusals"] or record["verdict"] != "supports" or record["tier"] != "mechanical":
        raise RuntimeError("The successful compile was not recorded as mechanical support for the claim")
    if record["subject"]["subject_id"] != "CWalk" or not (ROOT / record["artifact"]).is_file():
        raise RuntimeError("The recorded compiler certificate is not an existing certificate for CWalk")
    shown = subprocess.run(
        [ARGUS, "-m", "argus_skill.verticals.math.math_state",
         "show", "--project-root", str(ROOT), "--claim", "CWalk"],
        cwd=ROOT, check=True, capture_output=True, text=True,
    )
    assessment = json.loads(shown.stdout)["claim"]
    if assessment["status"] != "closed_kernel" or assessment["undischarged"]:
        raise RuntimeError("The formal proof still has undischarged ledger assumptions")
    return record, assessment


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exact-only", action="store_true")
    parser.add_argument("--formal-only", action="store_true",
                        help="Use the already recorded exact tests; compile and verify the formal proof.")
    args = parser.parse_args()
    if args.exact_only and args.formal_only:
        parser.error("--exact-only and --formal-only are mutually exclusive")
    started = time.monotonic()
    if args.formal_only:
        checks = json.loads((HERE / "exact_tests.json").read_text())
    else:
        checks = exact_checks()
        (HERE / "exact_tests.json").write_text(json.dumps(checks, indent=2) + "\n")
    if args.exact_only:
        print(json.dumps({key: value for key, value in checks.items() if key != "reduced_length_results"}, indent=2))
        return
    compiled, env = build()
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--project-root", str(ROOT), "--claim", "CWalk", "--no-lake",
    ]
    verified = subprocess.run(command, cwd=ROOT, env=env, capture_output=True, text=True)
    (HERE / "formal_verifier_stdout.json").write_text(verified.stdout)
    (HERE / "formal_verifier_stderr.txt").write_text(verified.stderr)
    gates = local_gates()
    if verified.returncode:
        print(verified.stdout + verified.stderr)
        raise SystemExit(verified.returncode)
    record, assessment = verified_claim_record(json.loads(verified.stdout))
    lean = json.loads((HERE / "lean_check.json").read_text())
    if lean.get("status") != "success" or lean.get("exit_code") != 0 or lean.get("proof_holes") != []:
        raise RuntimeError("The formal verifier did not produce the required hole-free successful run")
    log = lean["stdout"]
    matches = re.findall(
        r"Campaign9000327\.prop_walks'?\s+depends on axioms:\s*\[([^\]]*)\]", log
    )
    if len(matches) != 1:
        raise RuntimeError("The compiler log does not contain exactly one transitive wrapper axiom report")
    axioms = sorted(x.strip() for x in matches[0].split(",") if x.strip())
    if not set(axioms) <= {"propext", "Classical.choice", "Quot.sound"}:
        raise RuntimeError(f"Unexpected transitive mathematical axiom or proof hole: {axioms}")
    certificate = {
        "claim_id": "CWalk",
        "classification": "source-faithful universal formal verification of an existing proposition",
        "theorem": "Campaign9000327.prop_walks",
        "statement": "For every OrderedNorm N and every natural n>0, all finite marked-chain, stationary, reversible, odd unit-label, finite-support, and n-step escape conditions of prop:walks hold.",
        "constants": {"distance_per_step": "1/24", "escape_probability": "3/20"},
        "formal_source": "Main.lean",
        "source_sha256": digest(HERE / "Main.lean"),
        "statement_fidelity": "statement_fidelity.md",
        "statement_fidelity_sha256": digest(HERE / "statement_fidelity.md"),
        "lean_version": compiled["lean_version"],
        "proof_holes": lean["proof_holes"],
        "exit_code": lean["exit_code"],
        "transitive_axioms": axioms,
        "custom_modules_recompiled": compiled["module_count"],
        "source_inventory": "public_sources/inventory.json",
        "compatibility_edits": "compatibility_patches.json",
        "build_record": "build_result.json",
        "formal_record": "formal_verifier_stdout.json",
        "kernel_certificate": record["artifact"],
        "kernel_status": assessment["status"],
        "undischarged_assumptions": assessment["undischarged"],
        "exact_adversarial_tests": checks,
        "campaign_local_validation": gates,
        "independent_review": "pending Host-invoked Reviewer; not self-confirmed",
        "novelty": "No claim of a new mathematical theorem; the original proposition and public proof are prior work.",
        "outside_scope": ["lem:ordered-norm", "lem:edge-labels", "thm:main"],
        "elapsed_seconds": round(time.monotonic() - started, 3),
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "theorem": certificate["theorem"], "exit_code": 0, "proof_holes": [],
        "transitive_axioms": axioms, "module_count": compiled["module_count"],
        "certificate": str(HERE / "exact_certificate.json"),
    }, indent=2))


if __name__ == "__main__":
    main()
