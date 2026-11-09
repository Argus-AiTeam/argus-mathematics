#!/usr/bin/env python3
"""Replay exact diagnostics and the native, source-bound Lean certificate."""

import argparse
from dataclasses import dataclass
from fractions import Fraction as F
import hashlib
from itertools import product
import json
from math import comb
import os
from pathlib import Path
import re
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
COMMIT = "4eaee87548250b2682affda7d05d947c05554bae"


def floor(x):
    return x.numerator // x.denominator


def ceil(x):
    return -floor(-x)


def resolution(q, b):
    target = 4 / ((1 - q) * q**b)
    n = 1
    while n < target:
        n *= 2
    assert target <= n < 2 * target
    return n


def key(q, b, x):
    return floor(resolution(q, b) * (x - floor(x)))


@dataclass(frozen=True)
class Edge:
    path: tuple
    a: int
    b: int
    height: int


class Construction:
    def __init__(self, q, m, d, r0):
        self.q, self.m, self.d = q, m, d
        edge_count = sum(m**h for h in range(1, d + 1))
        c = 4 / (1 - q)
        self.g = 1
        while 4 * edge_count * c * q ** (self.g + 1) >= F(1, 4):
            self.g += 1
        self.r = {1: r0}
        span = m * r0 + (m - 1) * self.g
        for h in range(2, d + 1):
            self.r[h] = max(r0, self.g + span)
            span = m * (self.r[h] + self.g + span) + (m - 1) * self.g
        n0 = 1
        while 2 * q**n0 > F(1, 4):
            n0 += 1
        self.n0, self.edges = n0, []

        def place(prefix, h, start):
            cursor = start
            for i in range(m):
                edge = Edge(prefix + (i,), cursor, cursor + self.r[h] - 1, h)
                self.edges.append(edge)
                cursor = edge.b + 1
                if h > 1:
                    cursor = place(edge.path, h - 1, cursor + self.g)
                if i < m - 1:
                    cursor += self.g
            return cursor

        end = place((), d, n0)
        assert end - n0 == span
        self.by_path = {e.path: e for e in self.edges}
        self.star = {
            e.path: max(f.b for f in self.edges if f.path[:len(e.path)] == e.path)
            for e in self.edges
        }
        for e in self.edges:
            assert self.star[e.path] - e.a + 1 <= 2 * self.r[e.height]
        for before, after in zip(self.edges, self.edges[1:]):
            assert after.a == before.b + self.g + 1

    def stable(self, x):
        return all(
            floor(resolution(self.q, e.b) * x)
            == floor(resolution(self.q, e.b) * (x + 2 * self.q**f.a))
            for e, f in zip(self.edges, self.edges[1:])
        )

    def selector(self, path, z, center, pattern, seed):
        e = self.by_path[path]
        address = key(self.q, e.b, z)
        center_address = key(self.q, e.b, center)
        if address == center_address:
            return pattern[path]
        tag = sum((j + 3) * (i + 1) for j, i in enumerate(path))
        return ((address * (2 * seed + 3) + tag + seed) // (seed + 1)) % 2

    def route(self, z, center, pattern, seed, prefix=()):
        visited = []
        path = prefix
        first_default = None
        while len(path) < self.d:
            chosen = self.m - 1
            for i in range(self.m - 1):
                child = path + (i,)
                visited.append((child, key(self.q, self.by_path[child].b, z)))
                if self.selector(child, z, center, pattern, seed):
                    chosen = i
                    break
            if chosen == self.m - 1 and first_default is None:
                first_default = path
            path = path + (chosen,)
        return path, first_default, visited

    def trials(self, prefix):
        return [
            (i, n, self.by_path[prefix + (i,)])
            for i in range(self.m - 1)
            for n in range(
                self.by_path[prefix + (i,)].a,
                self.by_path[prefix + (i,)].b + 1,
            )
        ]

    def representatives(self, prefix, x):
        boundaries = {F(1), F(2)}
        for _, n, edge in self.trials(prefix):
            ngrid = resolution(self.q, self.star[edge.path])
            left = ngrid * (x + self.q**n)
            right = ngrid * (x + 2 * self.q**n)
            count = floor(right) - ceil(left) + 1
            assert count <= 1 + ngrid * self.q**n
            assert ngrid * self.q**n < 2 * (4 / (1 - self.q)) * self.q ** (
                -2 * self.r[edge.height]
            )
            for j in range(ceil(left), floor(right) + 1):
                boundaries.add((F(j, ngrid) - x) / self.q**n)
        ordered = sorted(boundaries)
        reps = boundaries | {(a + b) / 2 for a, b in zip(ordered, ordered[1:])}
        r = self.r[self.d - len(prefix)]
        bound = 4 + 2 * (self.m - 1) * r * (
            1 + 2 * (4 / (1 - self.q)) * self.q ** (-2 * r)
        )
        assert len(reps) <= bound
        return ordered, reps


def jacobian_replay():
    payload = json.loads((HERE / "jacobian-payload.json").read_text())
    output = json.loads((HERE / "jacobian-output.json").read_text())
    status = json.loads((HERE / "jacobian-status.json").read_text())
    assert status["adapter_exit_code"] == 0 and not status["timeout"]
    assert output["server"]["version"] == "0.14.0"
    assert output["protocol_version"] == "2025-11-25"
    assert output["request"]["operation_id"] == "integer.counting.floor_sum.compute"
    assert output["request"]["payload"] == payload
    expected = sum(
        (payload["a"] * i + payload["b"]) // payload["m"]
        for i in range(payload["n"])
    )
    assert output["result"]["output"] == {"value": str(expected)}
    q, x, n, b = F(2, 3), F(1, 7), 6, 8
    ngrid = resolution(q, b)
    assert ngrid == 512
    left, right = ngrid * (x + q**n), ngrid * (x + 2 * q**n)
    assert F(payload["b"], payload["m"]) == right
    assert F(payload["a"] + payload["b"], payload["m"]) == 384 - left
    count = floor(right) - ceil(left) + 1
    assert expected - 383 == count == 45
    return {"operation_id": output["request"]["operation_id"], "closed_boundary_count": count}


def diagnostics():
    ratios = [F(1, 4), F(1, 3), F(1, 2), F(2, 3), F(3, 4), F(7, 8), F(15, 16)]
    counts = dict(constructions=0, grid_checks=0, stable_center_checks=0,
                  fixed_scale_atoms=0, representative_intervals=0,
                  terminal_address_checks=0, exact_probability_sums=0)
    equal_adjacent = False
    for q in ratios:
        for b in range(1, 25):
            n1, n2 = resolution(q, b), resolution(q, b + 1)
            assert n2 % n1 == 0
            equal_adjacent |= n1 == n2
            for z in [F(-5, 3), F(-1), F(0), F(1, 7), F(1) - F(1, n2), F(1)]:
                assert key(q, b, z) == key(q, b + 1, z) // (n2 // n1)
                counts["grid_checks"] += 1
        for m, d, r0 in [(2, 1, 1), (2, 1, 3), (3, 1, 2), (2, 2, 1)]:
            con = Construction(q, m, d, r0)
            counts["constructions"] += 1
            selector_paths = [e.path for e in con.edges if e.path[-1] < m - 1]
            patterns = [
                dict(zip(selector_paths, bits))
                for bits in product([0, 1], repeat=len(selector_paths))
            ]
            finest = resolution(q, con.edges[-1].b)
            for x in [F(-1), F(0), F(1), F(1) - F(1, finest), F(1, finest)]:
                if not con.stable(x):
                    continue
                counts["stable_center_checks"] += 1
                for e in con.edges:
                    ngrid = resolution(q, e.b)
                    for t in [F(1), F(3, 2), F(2)]:
                        points = [x] + [x + t * q**n for n in range(e.a, e.b + 1)]
                        addresses = [key(q, e.b, z) for z in points]
                        assert len(addresses) == len(set(addresses))
                        for z in points[1:]:
                            for before in con.edges[:con.edges.index(e)]:
                                assert key(q, before.b, x) == key(q, before.b, z)
                        assert ngrid > 0
                for pattern in patterns:
                    _, first, _ = con.route(x, x, pattern, 0)
                    if first is None:
                        continue
                    trials = con.trials(first)
                    for t in [F(1), F(3, 2), F(2)]:
                        counts["fixed_scale_atoms"] += 1
                        fresh = [
                            (e.path, key(q, e.b, x + t * q**n))
                            for _, n, e in trials
                        ]
                        exposed = {(p, key(q, con.by_path[p].b, x)) for p in selector_paths}
                        assert len(set(fresh)) == len(fresh)
                        assert not (set(fresh) & exposed)
                        for seed in range(3):
                            terminal = []
                            for i, n, e in trials:
                                z = x + t * q**n
                                leaf, _, _ = con.route(z, x, pattern, seed, first + (i,))
                                assert leaf[:len(first) + 1] == first + (i,)
                                address = (leaf, key(q, con.by_path[leaf].b, z))
                                terminal.append(address)
                                if con.selector(e.path, z, x, pattern, seed):
                                    actual_leaf, _, _ = con.route(z, x, pattern, seed)
                                    assert actual_leaf == leaf
                            assert len(set(terminal)) == len(terminal)
                            counts["terminal_address_checks"] += 1
                    if con.d - len(first) == 1:
                        boundaries, reps = con.representatives(first, x)
                        assert F(1) in reps and F(2) in reps
                        for a, b in zip(boundaries, boundaries[1:]):
                            mid = (a + b) / 2
                            counts["representative_intervals"] += 1
                            for s in [(3 * a + b) / 4, (a + 3 * b) / 4]:
                                for _, n, edge in trials:
                                    finest_b = con.star[edge.path]
                                    assert key(q, finest_b, x + s * q**n) == key(
                                        q, finest_b, x + mid * q**n
                                    )
                    k = len(trials)
                    for p in [F(1, 7), F(1, 2), F(6, 7)]:
                        total = sum(F(comb(k, j), 2**k) * (1 - p)**j for j in range(k + 1))
                        assert total == (1 - p / 2)**k
                        counts["exact_probability_sums"] += 1
    assert equal_adjacent
    return {
        "classification": "finite_adversarial_diagnostics_not_a_uniform_proof",
        "ratios": [str(q) for q in ratios],
        "counts": counts,
        "equal_adjacent_resolutions_exercised": True,
        "counterexample_found": False,
        "jacobian": jacobian_replay(),
        "limitations": [
            "The rational-ratio search is finite and cannot certify all real q.",
            "Representative interval diagnostics use height-one first-default subtrees.",
            "Full terminal-table outcomes are not enumerated; distinct terminal addresses are checked for sampled selector completions.",
            "Novelty, significance, and independent Reviewer approval are not inferred from these checks."
        ],
    }


def build_upstream():
    vendor = HERE / "vendor"
    env = os.environ.copy()
    env["LEAN_PATH"] = str(vendor) + (":" + env["LEAN_PATH"] if env.get("LEAN_PATH") else "")
    workspace = "$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0"
    done = set()

    def compile_module(module):
        if module in done:
            return
        path = vendor / (module.replace(".", "/") + ".lean")
        text = path.read_text()
        code = re.sub(r"/\-[\s\S]*?\-/|--[^\n]*", "", text)
        assert not re.search(r"\b(sorry|admit|axiom)\b", code), str(path)
        dependencies = []
        for line in text.splitlines():
            if line.startswith("import "):
                for dep in line[7:].split():
                    if dep.startswith("OAI."):
                        compile_module(dep)
                        dependencies.append(vendor / (dep.replace(".", "/") + ".olean"))
        output = path.with_suffix(".olean")
        if output.exists() and output.stat().st_mtime_ns >= max(
                source.stat().st_mtime_ns for source in [path] + dependencies):
            done.add(module)
            print("using compiled", module, flush=True)
            return
        subprocess.run(["lake", "env", "lean", "-R", str(vendor),
                        "-o", str(output),
                        str(path)], cwd=workspace, env=env, check=True)
        done.add(module)
        print("compiled", module, flush=True)

    for module in json.loads((HERE / "upstream.json").read_text())["entry_modules"]:
        compile_module(module)
    print(json.dumps({"compiled_upstream_modules": len(done), "commit": COMMIT}))

def verify_lean():
    build_upstream()
    python = "$WORKSPACE/argus-live-update/.venv/bin/python"
    env = os.environ.copy()
    env["LEAN_PATH"] = str(HERE / "vendor")
    command = [
        python, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        str(HERE / "Main.lean"), "--statement-fidelity", str(HERE / "statement-fidelity.md"),
        "--project-root", str(ROOT), "--claim", "C_GEOMETRIC_CONDITIONAL_SCALES",
        "--artifact-dir", str(HERE / "lean-evidence"), "--timeout", "100",
    ]
    with (HERE / "native-result.json").open("w") as out:
        result = subprocess.run(command, cwd=ROOT, env=env, stdout=out)
    checks = [
        subprocess.run([python, "-m", "argus_skill.verticals.math." + module,
                        "check", "--project-root", str(ROOT)], cwd=ROOT)
        for module in ["math_state", "proof_graph_check"]
    ]
    result.check_returncode()
    for check in checks:
        check.check_returncode()


def native_evidence():
    native = json.loads((HERE / "native-result.json").read_text())
    record = native["kernel"]["recorded"]
    archive_path = ROOT / record["artifact"]
    archive = json.loads(archive_path.read_text())
    assert record["tier"] == archive["tier"] == "mechanical"
    assert record["verdict"] == archive["verdict"] == "supports"
    assert record["subject"] == archive["subject"]
    assert record["subject"]["subject_id"] == "C_GEOMETRIC_CONDITIONAL_SCALES"
    for check in [native, archive["lean_check"]]:
        assert check["status"] == "success"
        assert check["exit_code"] == check["audit_exit_code"] == 0
        assert check["proof_holes"] == []
        assert check["environment_failure"] == ""
        assert check["command"] and check["audit_command"]
        assert "4.31.0" in check["tools"]["lean"]["version"]
        assert "sorryAx" not in check["audit_stdout"] + check["audit_stderr"]
    for filename, field, archived_field in [
        ("Main.lean", "source_sha256", "lean_source"),
        ("statement-fidelity.md", "statement_fidelity_sha256", "statement_fidelity"),
    ]:
        data = (HERE / filename).read_bytes()
        assert hashlib.sha256(data).hexdigest() == native[field]
        assert native[field] == archive["lean_check"][field]
        assert data.decode() == archive[archived_field]["text"]
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    claim = max(
        (c for c in state["claims"] if c["claim_id"] == "C_GEOMETRIC_CONDITIONAL_SCALES"),
        key=lambda c: c["version"],
    )
    assert claim["content_hash"] == archive["subject"]["content_hash"]
    shown = subprocess.run(
        ["$WORKSPACE/argus-live-update/.venv/bin/python",
         "-m", "argus_skill.verticals.math.math_state", "show",
         "--project-root", str(ROOT), "--claim", "C_GEOMETRIC_CONDITIONAL_SCALES"],
        capture_output=True, text=True, check=True,
    )
    derived = json.loads(shown.stdout)["claim"]
    assert derived["issues"] == []
    assert record["artifact"] in [c["artifact"] for c in derived["certificates"]]
    return {
        "classification": "parameter_uniform_formal_window_interface_theorem",
        "claim": "C_GEOMETRIC_CONDITIONAL_SCALES",
        "ledger_status": derived["status"],
        "undischarged": derived["undischarged"],
        "native_certificate": record["artifact"],
        "compiler_version": "4.31.0",
        "compiler_exit_code": native["exit_code"],
        "audit_exit_code": native["audit_exit_code"],
        "proof_holes": native["proof_holes"],
        "source_and_statement_fidelity_fresh": True,
        "declarations": [
            "GeometricBridge.LocalWindows.conditional_scales",
            "GeometricBridge.LocalWindows.conditional_scales_sharp",
        ],
        "original_prefactor": "4+2*k*(1+2*c/q^(2*r))",
        "sharper_prefactor": "1+k*(1+2*c/q^(2*r))",
        "parameters": "All real 0<q,p<1; c=4/(1-q), k=(M-1)*r; no rational or dyadic restriction on q.",
        "coverage": "Actual finite tables, derived selector and adaptive-terminal address injectivity, completion-uniform representatives, stable-key routing transfer, and normalized positive-atom conditional probability.",
        "boundary": "The original preorder-window realization of the deterministic endpoint interface is proved in proof.md and remains an explicit ledger dependency, not a Lean-constructed window family.",
        "independent_review": "required; not supplied by this certificate",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build-upstream", action="store_true")
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--verify-lean", action="store_true",
                        help="Run the real native compiler again, then both campaign-local checks.")
    parser.add_argument("--formal-only", action="store_true",
                        help="Reuse the saved finite diagnostics; check only the current native proof record.")
    args = parser.parse_args()
    if args.build_upstream:
        build_upstream()
        return
    target = HERE / "exact_certificate.json"
    if args.verify_lean:
        verify_lean()
    if args.formal_only:
        saved = json.loads(target.read_text())
        if "diagnostics" in saved:
            finite = saved["diagnostics"]
        else:
            assert saved["classification"] == "finite_adversarial_diagnostics_not_a_uniform_proof"
            finite = saved
    else:
        finite = diagnostics()
    result = {
        "schema_version": 2,
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "candidate_result_class": "new_theorem",
        "novelty_status": "pending_independent_review",
        "significance_status": "pending_independent_review",
        "diagnostics": finite,
        "uniform_verification": native_evidence(),
    }
    if args.write_certificate:
        target.write_text(json.dumps(result, indent=2) + "\n")
    else:
        assert json.loads(target.read_text()) == result
    print(json.dumps({
        "certificate": str(target.relative_to(ROOT)),
        "finite_diagnostics": finite["counts"],
        "uniform_verification": result["uniform_verification"],
    }, indent=2))


if __name__ == "__main__":
    main()
