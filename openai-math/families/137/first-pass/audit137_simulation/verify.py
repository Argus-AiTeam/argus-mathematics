#!/usr/bin/env python3
"""Replay the capped realization, or obtain fresh claim-bound Lean evidence."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import os
from pathlib import Path
import shutil
import subprocess
from dataclasses import dataclass


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PYTHON = Path("$WORKSPACE/argus-live-update/.venv/bin/python")
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LAKE = Path("$WORKSPACE/.elan/bin/lake")
DEPENDENCY = ROOT / "research/audit137/Main.lean"
DEPENDENCY_CERTIFICATE = (
    ROOT / "research/audit137/certificates/C137_WEIGHTED-27839afb29348646.json"
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path: Path, value: object) -> None:
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


@dataclass(frozen=True)
class Controller:
    state: int
    flag: int
    time: int
    heads: tuple[int, ...]


@dataclass(frozen=True)
class Codec:
    cap: int
    rho: int

    @property
    def field(self) -> int:
        return (2 * self.cap + 2).bit_length()

    @property
    def width(self) -> int:
        return 4 + (self.rho + 2) * self.field

    def encode(self, c: Controller) -> int:
        assert 0 <= c.state < 3 and 0 <= c.flag < 3
        assert 0 <= c.time <= self.cap
        assert len(c.heads) == self.rho + 1
        assert all(abs(q) <= c.time for q in c.heads)
        word = c.state | (c.flag << 2)
        shift = 4
        for value in (c.time, *(q + self.cap for q in c.heads)):
            word |= value << shift
            shift += self.field
        assert word < 1 << self.width
        return word

    def decode(self, word: int) -> Controller | None:
        assert 0 <= word < 1 << self.width
        state, flag = word & 3, (word >> 2) & 3
        mask, shift = (1 << self.field) - 1, 4
        fields = []
        for _ in range(self.rho + 2):
            fields.append((word >> shift) & mask)
            shift += self.field
        time = fields[0]
        heads = tuple(q - self.cap for q in fields[1:])
        if state == 3 or flag == 3 or time > self.cap:
            return None
        if any(q > 2 * self.cap for q in fields[1:]):
            return None
        if any(abs(q) > time for q in heads):
            return None
        return Controller(state, flag, time, heads)

    @property
    def dummy(self) -> int:
        return self.encode(Controller(0, 2, 0, (0,) * (self.rho + 1)))


@dataclass(frozen=True)
class Machine:
    mode: str
    rho: int = 0

    def transition(
        self, state: int, symbol: int, inputs: tuple[int, ...]
    ) -> tuple[int, int, tuple[int, ...]]:
        assert state < 2 and symbol < 3 and len(inputs) == self.rho
        write = (symbol + state + sum(inputs) + 1) % 3
        if self.mode == "right":
            return 0, write, (1,) * (self.rho + 1)
        if self.mode == "left":
            return 0, write, (-1,) * (self.rho + 1)
        if self.mode == "halt":
            return 2, write, (1,) * (self.rho + 1)
        if self.mode == "stationary":
            return 1 - state, write, (0,) * (self.rho + 1)
        if self.mode == "bounce":
            return 1 - state, write, ((1 if state == 0 else -1),) * (self.rho + 1)
        if self.mode == "input":
            next_state = 2 if inputs[0] == 2 and symbol == 1 else 1 - state
            return next_state, write, (
                1 if inputs[0] == 0 else -1,
                1 if state == 0 else -1,
            )
        raise ValueError(f"unknown finite transition table: {self.mode}")


def symbol(head: int, cap: int, q: int) -> int:
    assert abs(q) <= cap, ("accessor radius exceeded", head, cap, q)
    return (q * q + 3 * head + 1) % 3


def initial_symbol(q: int) -> int:
    return (q * q + q + 1) % 3


def selector(codec: Codec, offset: int, b: int, raw: int) -> int:
    c = codec.decode(raw)
    return ((0 if c is None else c.heads[0]) - offset) // b


def visit(
    codec: Codec, machine: Machine, offset: int, b: int, raw: int, block: tuple[int, ...]
) -> tuple[int, tuple[int, ...], tuple[tuple[int, int, int], ...]]:
    assert len(block) == b and all(0 <= x < 4 for x in block)
    c = codec.decode(raw)
    if c is None:
        return codec.dummy, block, ()
    if c.flag:
        return raw, block, ()
    selected = (c.heads[0] - offset) // b
    left = offset + selected * b
    buffer = list(block)
    queries = []
    while True:
        if c.state == 2:
            c = Controller(c.state, 1, c.time, c.heads)
            break
        if c.time == codec.cap:
            c = Controller(c.state, 2, c.time, c.heads)
            break
        q = c.heads[0]
        assert abs(q) <= c.time < codec.cap
        queries.append((-1, c.time, q))
        value = buffer[q - left]
        writable = value if value < 3 else 0
        inputs = []
        for h, position in enumerate(c.heads[1:]):
            queries.append((h, c.time, position))
            inputs.append(symbol(h, codec.cap, position))
        state, write, moves = machine.transition(c.state, writable, tuple(inputs))
        buffer[q - left] = write
        time = c.time + 1
        heads = tuple(x + dx for x, dx in zip(c.heads, moves))
        flag = 1 if state == 2 else 2 if time == codec.cap else 0
        c = Controller(state, flag, time, heads)
        if flag or (heads[0] - offset) // b != selected:
            break
    return codec.encode(c), tuple(buffer), tuple(queries)


def direct_visit(
    codec: Codec, machine: Machine, offset: int, b: int, raw: int, block: tuple[int, ...]
) -> tuple[int, tuple[int, ...]]:
    """Whole-tape specification; no call to the buffer visit or its selector."""
    incoming = codec.decode(raw)
    if incoming is None:
        return codec.dummy, block
    if incoming.flag != 0:
        return raw, block
    state, time, heads = incoming.state, incoming.time, incoming.heads
    physical = (heads[0] - offset) // b
    addresses = tuple(range(offset + physical * b, offset + (physical + 1) * b))
    tape = dict(zip(addresses, block))
    flag = 0
    for _ in range(codec.cap - time + 1):
        if state == 2:
            flag = 1
            break
        if time >= codec.cap:
            flag = 2
            break
        q = heads[0]
        assert q in tape
        s = tape[q]
        state, write, movement = machine.transition(
            state,
            0 if s == 3 else s,
            tuple(symbol(h, codec.cap, p) for h, p in enumerate(heads[1:])),
        )
        tape[q] = write
        heads = tuple(heads[h] + movement[h] for h in range(len(heads)))
        time += 1
        if state == 2:
            flag = 1
        elif time == codec.cap:
            flag = 2
        if flag != 0 or not addresses[0] <= heads[0] <= addresses[-1]:
            break
    result = codec.encode(Controller(state, flag, time, heads))
    return result, tuple(tape[q] for q in addresses)


def run_steps(codec: Codec, machine: Machine, limit: int) -> tuple[Controller, dict[int, int]]:
    c = Controller(0, 0, 0, (0,) * (machine.rho + 1))
    tape: dict[int, int] = {}
    for _ in range(limit):
        if c.flag:
            break
        q = c.heads[0]
        state, write, moves = machine.transition(
            c.state,
            tape.get(q, initial_symbol(q)),
            tuple(symbol(h, codec.cap, p) for h, p in enumerate(c.heads[1:])),
        )
        tape[q] = write
        time = c.time + 1
        heads = tuple(x + dx for x, dx in zip(c.heads, moves))
        c = Controller(state, 1 if state == 2 else 2 if time == codec.cap else 0, time, heads)
    return c, tape


def local_diagnostics() -> dict[str, int]:
    totals = {"raw_visits": 0, "rejected_visits": 0, "queries": 0, "exterior_slots": 0}
    cases = (
        (2, Machine("right"), 1),
        (2, Machine("bounce"), 2),
        (2, Machine("halt"), 2),
        (2, Machine("input", 1), 1),
    )
    for cap, machine, b in cases:
        codec = Codec(cap, machine.rho)
        for offset in range(b):
            for raw in range(1 << codec.width):
                c = codec.decode(raw)
                if c is not None:
                    assert codec.encode(c) == raw
                v = selector(codec, offset, b, raw)
                left = offset + b * v
                for block in itertools.product(range(4), repeat=b):
                    out, buffer, queries = visit(codec, machine, offset, b, raw, block)
                    assert (out, buffer) == direct_visit(codec, machine, offset, b, raw, block)
                    assert codec.decode(out) is not None
                    for _, time, q in queries:
                        assert abs(q) <= time < cap
                    if c is None:
                        totals["rejected_visits"] += 1
                        assert buffer == block and not queries and out == codec.dummy
                    if c is not None and c.flag:
                        assert (out, buffer, queries) == (raw, block, ())
                    for j in range(b):
                        if abs(left + j) > cap:
                            totals["exterior_slots"] += 1
                            assert buffer[j] == block[j]
                    totals["raw_visits"] += 1
                    totals["queries"] += len(queries)
    return totals


def replay_generic(sel, kernel, index, z, outgoing, block):
    p = True
    for y in outgoing:
        if sel(z) == index:
            result, block = kernel(z, block)
            p = p and result == y
        z = y
    return block, p


def serial_generic(sel, kernel, z, arrays, n):
    arrays = list(arrays)
    outgoing = []
    for _ in range(n):
        i = sel(z)
        z, arrays[i] = kernel(z, arrays[i])
        outgoing.append(z)
    return outgoing, arrays


def replay_diagnostics() -> dict[str, int]:
    totals = {"raw_transcripts": 0, "accepted_transcripts": 0, "factored_coordinates": 0}
    for nblocks in (1, 2, 3):
        sel = lambda z: z % nblocks
        kernel = lambda z, a: ((3 * z + a + 1) % 4, (a + z + 1) % 2)
        for z0 in range(4):
            for arrays in itertools.product(range(2), repeat=nblocks):
                for m in range(4):
                    expected, final = serial_generic(sel, kernel, z0, arrays, m)
                    for ys in itertools.product(range(4), repeat=m):
                        results = [
                            replay_generic(sel, kernel, i, z0, ys, arrays[i])
                            for i in range(nblocks)
                        ]
                        passes = all(p for _, p in results)
                        assert passes == (list(ys) == expected)
                        if passes:
                            assert [a for a, _ in results] == final
                            totals["accepted_transcripts"] += 1
                        totals["raw_transcripts"] += 1
                k, c, b = 2, 2, 4
                d = (b + 1) * c + 3
                actual, _ = serial_generic(sel, kernel, z0, arrays, b)
                for j in range(k):
                    prefix = actual[: j * k]
                    values = [0] * (d + 1)
                    passing = []
                    for suffix in itertools.product(range(4), repeat=k):
                        proposed = prefix + list(suffix)
                        flags = [
                            replay_generic(sel, kernel, i, z0, proposed, arrays[i])[1]
                            for i in range(nblocks)
                        ]
                        if all(flags):
                            passing.append(suffix)
                            packed = sum(
                                value << (c * t) for t, value in enumerate([z0] + proposed)
                            )
                            for bit in range(d):
                                values[bit] += (packed >> bit) & 1
                            values[d] += 1
                    assert passing == [tuple(actual[j * k : (j + 1) * k])]
                    expected_word = sum(
                        value << (c * t)
                        for t, value in enumerate([z0] + actual[: (j + 1) * k])
                    )
                    assert values == [(expected_word >> bit) & 1 for bit in range(d)] + [1]
                    totals["factored_coordinates"] += d + 1
    return totals


def completion_diagnostics() -> dict[str, int]:
    totals = {"capped_trials": 0, "completed_offsets": 0, "actual_visits": 0}
    for cap in (2, 3, 5, 9, 17, 33):
        k = 1
        while k**5 < cap:
            k += 1
        b = k * k
        r = 1 + (cap + b - 1) // b
        epochs = (r + b - 1) // b
        for machine in (
            Machine("right"), Machine("left"), Machine("bounce"),
            Machine("halt"), Machine("stationary"), Machine("input", 1),
        ):
            codec = Codec(cap, machine.rho)
            final, final_tape = run_steps(codec, machine, cap)
            outcomes = []
            crossings = [0] * b
            step_c = Controller(0, 0, 0, (0,) * (machine.rho + 1))
            for t in range(cap):
                next_c, _ = run_steps(codec, machine, t + 1)
                if not step_c.flag:
                    for offset in range(b):
                        crossings[offset] += (
                            (step_c.heads[0] - offset) // b
                            != (next_c.heads[0] - offset) // b
                        )
                step_c = next_c
            assert sum(crossings) <= cap
            assert min(crossings) <= cap // b
            for offset in range(b):
                indices = range((-cap - offset) // b, (cap - offset) // b + 1)
                arrays = {
                    i: tuple(
                        initial_symbol(q) if abs(q) <= cap else 0
                        for q in range(offset + i * b, offset + (i + 1) * b)
                    )
                    for i in indices
                }
                raw = codec.encode(Controller(0, 0, 0, (0,) * (machine.rho + 1)))
                for _ in range(epochs * b):
                    i = selector(codec, offset, b, raw)
                    raw, arrays[i], _ = visit(codec, machine, offset, b, raw, arrays[i])
                    totals["actual_visits"] += 1
                    c = codec.decode(raw)
                    assert c is not None
                    direct, tape = run_steps(codec, machine, c.time)
                    assert c == direct
                    for v, block in arrays.items():
                        for j, entry in enumerate(block):
                            q = offset + v * b + j
                            assert entry == (
                                tape.get(q, initial_symbol(q)) if abs(q) <= cap else 0
                            )
                c = codec.decode(raw)
                if c.flag:
                    assert c == final
                    outcomes.append(c)
                    totals["completed_offsets"] += 1
                totals["capped_trials"] += 1
            assert outcomes and all(c == final for c in outcomes)
            assert final_tape is not None
    return totals


def diagnostics() -> dict[str, object]:
    typed = json.loads((HERE / "jacobian_output.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    assert status["adapter_exit_code"] == 0 and not status["timeout"]
    assert typed["result"]["operation_id"] == "integer.counting.floor_sum.compute"
    expected = sum(
        (payload["a"] * i + payload["b"]) // payload["m"] for i in range(payload["n"])
    )
    assert typed["result"]["output"] == {"value": str(expected)}
    return {
        "classification": "finite_diagnostics_not_universal_proof",
        "verifier_sha256": digest(Path(__file__)),
        "local_visits": local_diagnostics(),
        "raw_replay_and_factoring": replay_diagnostics(),
        "offset_completion": completion_diagnostics(),
        "jacobian": {
            "operation_id": typed["result"]["operation_id"],
            "server_version": typed["server"]["version"],
            "protocol_version": typed["protocol_version"],
            "payload": payload,
            "output": typed["result"]["output"],
            "adapter_status": status,
        },
    }


def check_dependency() -> dict:
    cert = json.loads(DEPENDENCY_CERTIFICATE.read_text())
    check = cert["lean_check"]
    assert check["exit_code"] == check["audit_exit_code"] == 0
    assert check["proof_holes"] == []
    assert digest(DEPENDENCY) == check["source_sha256"]
    assert DEPENDENCY.read_text() == cert["lean_source"]["text"]
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current = next(
        c for c in reversed(state["claims"]) if c["claim_id"] == "C137_WEIGHTED"
    )
    assert cert["subject"]["content_hash"] == current["content_hash"]
    assert any(
        e["subject"]["subject_id"] == "C137_WEIGHTED"
        and e["subject"]["content_hash"] == current["content_hash"]
        and e["verdict"] == "supports"
        and e["produced_by"].startswith("reviewer:")
        and e["artifact"] == str(DEPENDENCY_CERTIFICATE.relative_to(ROOT))
        for e in state["evidence"]
    )
    return cert


def prepare_dependency() -> None:
    check_dependency()
    target = HERE / "AcceptedEvaluator.lean"
    shutil.copyfile(DEPENDENCY, target)
    result = subprocess.run(
        [
            str(LAKE), "env", "lean", "-R", str(HERE),
            "-o", str(HERE / "AcceptedEvaluator.olean"), str(target),
        ],
        cwd=WORKSPACE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    (HERE / "dependency_compile.log").write_text(result.stdout)
    if result.returncode:
        raise RuntimeError(f"accepted dependency failed to compile: {result.stdout}")


def certify() -> None:
    check_dependency()
    target = HERE / "AcceptedEvaluator.lean"
    if not target.exists() or not (HERE / "AcceptedEvaluator.olean").exists():
        prepare_dependency()
    elif target.read_bytes() != DEPENDENCY.read_bytes():
        raise RuntimeError("local evaluator import differs from the accepted dependency")
    env = dict(os.environ)
    env["LEAN_PATH"] = str(HERE) + (
        ":" + env["LEAN_PATH"] if env.get("LEAN_PATH") else ""
    )
    result = subprocess.run(
        [
            str(PYTHON), "-m", "argus_skill.verticals.math.lean_evidence", "verify",
            str(HERE / "Main.lean"),
            "--statement-fidelity", str(HERE / "statement_fidelity.md"),
            "--claim", "C137_REALIZATION", "--project-root", str(ROOT),
            "--artifact-dir", str(HERE / "certificates"),
        ],
        cwd=ROOT, env=env, text=True, stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT, check=False,
    )
    (HERE / "formal_run.json").write_text(result.stdout)
    if result.returncode:
        raise RuntimeError(f"realization certification failed: {result.stdout}")
    validate_campaign()


def validate_campaign() -> None:
    checks = {}
    for name in ("math_state", "proof_graph_check"):
        command = [
            str(PYTHON), "-m", f"argus_skill.verticals.math.{name}",
            "check", "--project-root", str(ROOT),
        ]
        completed = subprocess.run(
            command, cwd=ROOT, text=True, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, check=False,
        )
        checks[name] = {"exit_code": completed.returncode, "output": completed.stdout}
    save(HERE / "validation.json", {"project_root": str(ROOT), "checks": checks})
    failed = {name: result for name, result in checks.items() if result["exit_code"]}
    if failed:
        raise RuntimeError(f"campaign-local checks rejected the campaign: {failed}")


def source_bindings() -> dict[str, str]:
    return {
        str(p.relative_to(ROOT)): digest(p)
        for p in (
            HERE / "Main.lean", HERE / "statement_fidelity.md", Path(__file__),
            HERE / "AcceptedEvaluator.lean", HERE / "AcceptedEvaluator.olean",
            DEPENDENCY, DEPENDENCY_CERTIFICATE,
        )
    }


def current_formal_certificate() -> tuple[Path, dict]:
    candidates = []
    for p in sorted((HERE / "certificates").rglob("C137_REALIZATION-*.json")):
        certificate = json.loads(p.read_text())
        check = certificate["lean_check"]
        if (
            check["source_sha256"] == digest(HERE / "Main.lean")
            and check["statement_fidelity_sha256"] == digest(HERE / "statement_fidelity.md")
        ):
            candidates.append((p, certificate))
    assert candidates, "no fresh claim-bound compiler certificate"
    path, certificate = candidates[-1]
    check = certificate["lean_check"]
    assert check["exit_code"] == check["audit_exit_code"] == 0
    assert check["proof_holes"] == [] and check["status"] == "success"
    assert "4.31.0" in check["tools"]["lean"]["version"]
    assert certificate["lean_source"]["text"] == (HERE / "Main.lean").read_text()
    assert (HERE / "AcceptedEvaluator.lean").read_bytes() == DEPENDENCY.read_bytes()
    state = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current = next(
        c for c in reversed(state["claims"]) if c["claim_id"] == "C137_REALIZATION"
    )
    assert certificate["subject"] == {
        "kind": "claim",
        "subject_id": "C137_REALIZATION",
        "content_hash": current["content_hash"],
    }
    return path, certificate


def seal() -> dict:
    check_dependency()
    path, formal = current_formal_certificate()
    finite = json.loads((HERE / "diagnostics.json").read_text())
    assert finite["verifier_sha256"] == digest(Path(__file__))
    validation = json.loads((HERE / "validation.json").read_text())
    assert validation["project_root"] == str(ROOT)
    assert set(validation["checks"]) == {"math_state", "proof_graph_check"}
    assert all(x["exit_code"] == 0 for x in validation["checks"].values())
    result = {
        "claim": "C137_REALIZATION",
        "result_class": "new_theorem",
        "theorem_kind": "exact_semantic_verification",
        "scope": "semantic_and_explicit_resource_model_not_compiled_Turing_machine",
        "independent_review": "pending_host_reviewer",
        "novelty_status": "not_self_certified",
        "significance_status": "not_self_certified",
        "source_bindings": source_bindings(),
        "lean_certificate": str(path.relative_to(ROOT)),
        "lean_exit_code": formal["lean_check"]["exit_code"],
        "axiom_audit_exit_code": formal["lean_check"]["audit_exit_code"],
        "proof_holes": formal["lean_check"]["proof_holes"],
        "accepted_dependency": str(DEPENDENCY_CERTIFICATE.relative_to(ROOT)),
        "diagnostics": finite,
        "campaign_validation": validation,
        "remaining_boundary": "C137_BIT_REALIZATION and the explicit A137_BIT_REALIZATION/A137_UNIFORM_BITS interpretation; novelty and significance require independent assessment.",
    }
    save(HERE / "exact_certificate.json", result)
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "action", choices=("diagnostics", "prepare", "certify", "validate", "seal", "replay"),
        nargs="?", default="replay",
    )
    args = parser.parse_args()
    if args.action == "diagnostics":
        result = diagnostics()
        save(HERE / "diagnostics.json", result)
        print(json.dumps(result, sort_keys=True))
    elif args.action == "prepare":
        prepare_dependency()
        print("Accepted dependency compiled without changing its source or ledger claim.")
    elif args.action == "certify":
        certify()
        print("Fresh realization compiler and campaign-local checks passed.")
    elif args.action == "validate":
        validate_campaign()
        print(f"Both campaign-local checks passed at {ROOT}.")
    elif args.action == "seal":
        result = seal()
        print(json.dumps({k: result[k] for k in ("claim", "result_class", "proof_holes")}))
    else:
        saved = json.loads((HERE / "exact_certificate.json").read_text())
        assert saved["source_bindings"] == source_bindings(), "source-bound evidence is stale"
        check_dependency()
        current_formal_certificate()
        result = diagnostics()
        assert result == saved["diagnostics"], "diagnostic certificate does not replay"
        print("Exact realization certificate replayed; publication and independent review are not inferred.")


if __name__ == "__main__":
    main()
