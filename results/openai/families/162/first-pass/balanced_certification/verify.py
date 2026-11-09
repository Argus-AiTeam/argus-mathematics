#!/usr/bin/env python3
"""Verify exact, source-bound balanced-theorem certificates and audit probes."""

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
REVISION = "4eaee87548250b2682affda7d05d947c05554bae"
MATHLIB_REVISION = "d13f23b723b8a846827a245b89c10fc7d3f11612"


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def read_json(path):
    return json.loads(path.read_text())


def axioms_from(text):
    answers = re.findall(r"depends on axioms:\s*\[([^\]]*)\]", text)
    require(bool(answers), "Compiler output contains no transitive axiom answer")
    result = set()
    for answer in answers:
        result.update(a.strip() for a in answer.split(",") if a.strip())
    require(result <= AXIOMS, f"Additional axioms: {sorted(result - AXIOMS)}")
    return sorted(result)


def check_lean_record(record_file, source, fidelity, version, claim, staging=None):
    record = read_json(record_file)
    require(record["status"] == "success" and record["exit_code"] == 0,
            f"Unsuccessful compiler result: {record_file}")
    require(record["proof_holes"] == [] and record["audit_exit_code"] == 0,
            f"Missing or unsuccessful proof-hole audit: {record_file}")
    require(f"version {version}," in record["tools"]["lean"]["version"],
            f"Wrong compiler version: {record_file}")
    for field, path in [("source", source), ("statement_fidelity", fidelity)]:
        compiled = path if staging is None else staging / (
            "Main.lean" if field == "source" else "statement_fidelity.md")
        require(Path(record[field]).resolve() == compiled.resolve(), f"Wrong {field} path")
        require(record[field + "_sha256"] == hashlib.sha256(path.read_bytes()).hexdigest(),
                f"Stale {field} evidence: {path}")
        require(compiled.read_bytes() == path.read_bytes(),
                f"Staged {field} differs from its original: {compiled}")
    kernel = record["kernel"]["recorded"]
    require(kernel["subject"]["subject_id"] == claim, "Certificate names the wrong claim")
    ledger = read_json(ROOT / "research/MATH_STATE.json")
    current = max((c for c in ledger["claims"] if c["claim_id"] == claim),
                  key=lambda c: c["version"])
    require(kernel["subject"]["content_hash"] == current["content_hash"],
            f"Certificate refers to a superseded claim: {claim}")
    archive = ROOT / kernel["artifact"]
    archived = read_json(archive)
    archived_check = archived["lean_check"]
    require(archived["subject"] == kernel["subject"] and
            archived["evidence_id"] == kernel["evidence_id"] and
            archived["tier"] == "mechanical" and archived["verdict"] == "supports" and
            archived_check["source_sha256"] == record["source_sha256"] and
            archived_check["statement_fidelity_sha256"] == record["statement_fidelity_sha256"] and
            archived_check["exit_code"] == 0 and archived_check["proof_holes"] == [] and
            archived_check["audit_exit_code"] == 0,
            f"Archived certificate mismatch: {archive}")
    return {"claim": claim, "version": version, "exit_code": 0, "proof_holes": [],
            "axioms": axioms_from(record["stdout"]),
            "certificate": kernel["artifact"]}


def baseline_check():
    payload = read_json(HERE / "jacobian_payload.json")
    reply = read_json(HERE / "jacobian_output.json")
    require(reply["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(reply["request"]["operation_id"] == "hypergraph.independence_number.compute",
            "Wrong Jacobian operation")
    graph = payload["hypergraph"]
    vertices = graph["vertices"]
    edges = [set(e) for _, e in graph["edges"]]
    covers = [set(c) for size in range(len(vertices) + 1)
              for c in itertools.combinations(vertices, size)
              if all(set(c) & edge for edge in edges)]
    tau = min(map(len, covers))
    require(tau == 2 and all(e & f for e in edges for f in edges),
            "Affine-plane baseline has unexpected ordinary-hypergraph invariants")
    answer = reply["result"]["output"]
    require(answer["status"] == "EXACT" and answer["independence_number"] == len(vertices) - tau,
            "Jacobian result is incomplete or disagrees with exhaustive replay")
    return {"classification": "known_finite_baseline", "vertices": len(vertices),
            "edges": len(edges), "cover_number": tau,
            "jacobian_status": answer["status"], "adapter_exit_code": 0,
            "protocol": reply["protocol_version"], "server": reply["server"]["version"],
            "operation_id": reply["request"]["operation_id"],
            "payload": "research/balanced_certification/jacobian_payload.json",
            "typed_output": "research/balanced_certification/jacobian_output.json"}


def line_points(q, direction, offset):
    return {(x, y) for x in range(q) for y in range(q)
            if (x if direction == q else (y - direction * x) % q) == offset}


def incidence_checks():
    tested = {}
    for q in (2, 3, 5, 7, 11):
        points = list(itertools.product(range(q), repeat=2))
        lines = [line_points(q, d, b) for d in range(q + 1) for b in range(q)]
        if q <= 3:
            samples = [{p for i, p in enumerate(points) if mask >> i & 1}
                       for mask in range(1 << (q * q))]
        else:
            full = set(points)
            samples = [set(), full, *lines, *(full - line for line in lines),
                       {(x, x * x % q) for x in range(q)}]
        for sample in samples:
            u = len(sample)
            counts = [len(sample & line) for line in lines]
            require(sum(counts) == (q + 1) * u, f"Affine first moment fails: q={q}")
            require(sum(c * c for c in counts) == u * u + q * u,
                    f"Affine second moment fails: q={q}")
            centered = sum((q * c - u) ** 2 for c in counts)
            require(centered == q ** 3 * u - q * u * u and 4 * centered <= q ** 5,
                    f"Affine variance identity or bound fails: q={q}")
        tested[str(q)] = len(samples)
    return {"classification": "finite_adversarial_test_not_asymptotic_proof",
            "point_sets_tested": tested}


def tuple_checks():
    tested = {}
    for q in (5, 7, 11):
        offsets = {d: ((d * d + 3 * d) % q, (d * d + 3 * d + 1) % q)
                   for d in range(q + 1)}

        def meet(d, a, e, b):
            if d == q:
                return (a, (e * a + b) % q)
            if e == q:
                return (b, (d * b + a) % q)
            x = (b - a) * pow(d - e, -1, q) % q
            return (x, (d * x + a) % q)

        def intercept(g, point):
            x, y = point
            return x if g == q else (y - g * x) % q

        aligned = valid = 0
        for g in range(q + 1):
            for generators in itertools.combinations([d for d in range(q + 1) if d != g], 4):
                for tail in itertools.permutations(generators[1:]):
                    ds = (generators[0], *tail)
                    for bits in itertools.product((0, 1), repeat=4):
                        us = [meet(ds[i], offsets[ds[i]][bits[i]],
                                   ds[(i + 1) % 4], offsets[ds[(i + 1) % 4]][1 - bits[(i + 1) % 4]])
                              for i in range(4)]
                        if len(set(us)) != 4 or len({intercept(g, p) for p in us}) != 1:
                            continue
                        aligned += 1
                        target = intercept(g, us[0])
                        pairs = {frozenset([meet(g, target, d, offsets[d][0]),
                                            meet(g, target, d, offsets[d][1])])
                                 for d in range(q + 1) if d != g}
                        for i, j in itertools.combinations(range(4), 2):
                            require(i % 2 == j % 2 or frozenset([us[i], us[j]]) in pairs,
                                    f"Cycle orientation/bit-complement failure: q={q}")
                        if target in offsets[g] or any(frozenset([us[i], us[i + 2]]) in pairs
                                                       for i in (0, 1)):
                            continue
                        external = line_points(q, g, target) - set(us)
                        if any(sum(frozenset([x, u]) in pairs for u in us) > 1 for x in external):
                            continue
                        valid += 1
        require(aligned > 0, f"Tuple orientation test was vacuous: q={q}")
        tested[str(q)] = {"aligned_tuples": aligned, "valid_tuples": valid}
    for q in range(3, 102):
        require(Fraction(6 * (q * (q - 1) * (q - 2) // 6), q ** 3) ==
                (1 - Fraction(1, q)) * (1 - Fraction(2, q)),
                "Deletion-law role-assignment ratio identity failed")
    return {"classification": "finite_orientation_test_not_configuration_existence",
            "prime_orders": tested, "deletion_ratio_orders_tested": 99}


def native_environment():
    native = HERE / "native"
    mathlib = native / "mathlib"
    manifest = read_json(mathlib / "lake-manifest.json")
    libraries = [native / "upstream_build", mathlib / ".lake/build/lib/lean"]
    libraries += [mathlib / ".lake/packages" / p["name"] / ".lake/build/lib/lean"
                  for p in manifest["packages"]]
    env = os.environ.copy()
    env["LEAN_PATH"] = os.pathsep.join(map(str, libraries))
    env["PATH"] = "$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.34.1/bin" + os.pathsep + env["PATH"]
    return env


def compile_evidence(source, fidelity, claim, output, native=False):
    command = [ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify", str(source),
               "--statement-fidelity", str(fidelity), "--claim", claim,
               "--project-root", str(ROOT), "--timeout", "100"]
    if native:
        command += ["--no-lake", "--lean-bin",
                    "$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.34.1/bin/lean",
                    "--artifact-dir", str(HERE / "native/evidence")]
    result = subprocess.run(command, cwd=ROOT, env=native_environment() if native else None,
                            text=True, capture_output=True)
    output.write_text(result.stdout)
    require(result.returncode == 0,
            f"Lean evidence command failed: {result.stderr}\n{result.stdout[-4000:]}")


def certify_native():
    compile_evidence(HERE / "NativeMain.lean", HERE / "native_statement_fidelity.md",
                     "C_BALANCED_NATIVE", HERE / "native_compile_result.json", native=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--replay-lean", action="store_true",
                        help="rerun both real compilers before validating their records")
    args = parser.parse_args()
    if args.replay_lean:
        compile_evidence(HERE / "Main.lean", HERE / "statement_fidelity.md",
                         "C_BALANCED_431", HERE / "core_compile_result.json")
        certify_native()
    core = check_lean_record(HERE / "core_compile_result.json", HERE / "Main.lean",
                             HERE / "statement_fidelity.md", "4.31.0", "C_BALANCED_431")
    native = check_lean_record(HERE / "native_compile_result.json", HERE / "NativeMain.lean",
                               HERE / "native_statement_fidelity.md", "4.34.1", "C_BALANCED_NATIVE",
                               staging=HERE / "native/evidence")
    replay = read_json(HERE / "native_replay_result.json")
    binding = read_json(HERE / "native/source_binding.json")
    require(replay["status"] == "verified" and replay["exit_code"] == 0 and
            replay["upstream_revision"] == binding["revision"] == REVISION,
            "Native replay or source revision is not certified")
    require(set(replay["axioms"]) <= AXIOMS, "Native theorem has extra axioms")
    require(len(binding["blobs"]) == replay["source_count"] > 0, "Source closure mismatch")
    for module, expected in binding["blobs"].items():
        source = HERE / "native/upstream" / (module.replace(".", "/") + ".lean")
        data = source.read_bytes()
        require(hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest() == expected,
                f"Upstream source changed: {module}")
    certificate = {
        "status": "verified_pending_independent_review",
        "result_class": "exact_verification",
        "claim": "C_BALANCED",
        "statement": "For every sufficiently large prime q there is an intersecting (q+1)-partite (q+1)-uniform finite hypergraph with exactly q+1 nonisolated vertices in each part and cover number q+1.",
        "threshold": "existential; not numerical",
        "extension_field_theorem": "not certified",
        "upstream_revision": REVISION,
        "native_source_modules": replay["source_count"],
        "trusted_library_inputs": {
            "native_mathlib_revision": MATHLIB_REVISION,
            "native_package_pins": "native/mathlib/lake-manifest.json",
            "core_mathlib": "host's built Lean 4.31.0 Mathlib workspace",
            "independent_mathlib_rebuild": False,
        },
        "native_full_theorem": native,
        "independent_deterministic_core": core,
        "ordinary_hypergraph_semantics": "native_statement_fidelity.md; kernel-checked generic cover equivalence in Main.lean",
        "baseline": baseline_check(),
        "incidence_audit": incidence_checks(),
        "tuple_orientation_audit": tuple_checks(),
        "false_manuscript_assertions_certified": [],
        "novelty": "No new construction claimed; independent certification significance remains for Reviewer.",
        "independent_reviewer": "Host invocation required; no acceptance claimed",
    }
    (HERE / "exact_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({"status": certificate["status"], "claim": certificate["claim"],
                      "native_source_modules": replay["source_count"],
                      "core_lean": "4.31.0", "native_lean": "4.34.1",
                      "certificate": str((HERE / "exact_certificate.json").relative_to(ROOT))},
                     indent=2))


if __name__ == "__main__":
    main()
