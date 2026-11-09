#!/usr/bin/env python3
"""Replay the word-level host construction; finite replay is not a universal proof."""

import argparse
import copy
import hashlib
import json
import subprocess
from collections import Counter, defaultdict, deque
from pathlib import Path


class VerificationError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise VerificationError(message)


def primitive(block):
    return bool(block) and all(
        any(block[x] != block[(x + shift) % len(block)] for x in range(len(block)))
        for shift in range(1, len(block))
    )


def spell(text, a, b):
    require(a <= b, "negative window length")
    return "".join(text(x) for x in range(a, b))


def check_walk(vertices, language, closed=False):
    require(bool(vertices), "empty walk representation")
    require(all(v in language for v in vertices), "walk leaves the substring graph")
    cost = 0
    for u, v in zip(vertices, vertices[1:]):
        if len(v) == len(u) + 1 and v[:-1] == u:
            cost += 1
        elif len(u) == len(v) + 1 and u[1:] == v:
            pass
        else:
            raise VerificationError(f"invalid directed hierarchical edge {u!r} -> {v!r}")
    if closed:
        require(vertices[0] == vertices[-1], "walk is not closed")
        balance = Counter()
        for u, v in zip(vertices, vertices[1:]):
            balance[u] += 1
            balance[v] -= 1
        require(not any(balance.values()), "unbalanced added edge multiset")
    return cost


def join(walks):
    result = []
    for walk in walks:
        require(bool(walk), "empty constituent walk")
        if result:
            require(result[-1] == walk[0], "walk endpoints do not match")
            result.extend(walk[1:])
        else:
            result.extend(walk)
    return result


def follow(text, first, second, language):
    a, b = first
    c, d = second
    require(a <= b and c <= d and a <= c and b <= d, "unordered windows")
    vertices = [spell(text, a, b)]
    if c <= b:
        vertices.extend(spell(text, x, b) for x in range(a + 1, c + 1))
        vertices.extend(spell(text, c, y) for y in range(b + 1, d + 1))
    else:
        vertices.extend(spell(text, x, b) for x in range(a + 1, b + 1))
        for x in range(b, c):
            vertices.extend([text(x), ""])
        vertices.extend(spell(text, c, y) for y in range(c + 1, d + 1))
    require(check_walk(vertices, language) == d - b, "incorrect ordered-window cost")
    require(min(map(len, vertices)) <= max(0, b - c), "missing short transition vertex")
    return vertices


def layer_walk(text, z, period, start):
    vertices = [spell(text, start, z(start - 1))]
    for x in range(start, start + period):
        require(z(x - 1) <= z(x) and z(x - 1) >= x, "invalid layer function")
        vertices.extend(spell(text, x, y) for y in range(z(x - 1) + 1, z(x) + 1))
        require(z(x) >= x + 1, "invalid layer down step")
        vertices.append(spell(text, x + 1, z(x)))
    require(vertices[0] == vertices[-1], "period does not close the layer")
    return vertices


def verify_instance(cert):
    host = cert["host"]
    q = host["period"]
    host_block = "".join(host["segments"])
    require(type(q) is int and q > 0 and len(host_block) == q, "invalid host period")
    require(primitive(host_block), "host block does not have the declared least period")
    bands = host["z_bands"]
    require(bands and bands[0][0] == 0 and bands[-1][1] == q, "incomplete host bands")
    require(all(lo < hi for lo, hi, _ in bands), "empty host band")
    require(all(a[1] == b[0] for a, b in zip(bands, bands[1:])), "host band gap")

    def host_text(x):
        return host_block[x % q]

    def host_z(x):
        turn, residue = divmod(x, q)
        height = next(h for lo, hi, h in bands if lo <= residue < hi)
        return turn * q + max(residue + 1, height)

    children = cert["children"]
    require(bool(children), "no child groups")
    require(len({c["id"] for c in children}) == len(children), "duplicate child group id")
    blocks = [c["primitive_word"] for c in children]
    require(all(primitive(b) for b in blocks), "nonprimitive child period")
    for i, block in enumerate(blocks):
        require(
            not (len(block) == q and block in host_block + host_block),
            "child and host belong to the same group",
        )
        for earlier in blocks[:i]:
            require(
                not (len(block) == len(earlier) and block in earlier + earlier),
                "two children belong to the same group",
            )
    chosen = next((c for c in children if c["id"] == cert["minimum_group"]), None)
    require(chosen is not None, "minimum group is absent")
    a0, b0 = chosen["record"]
    p0 = len(chosen["primitive_word"])
    require(all(p0 <= len(b) for b in blocks), "chosen group has nonminimum period")
    require(chosen["transport"] == 0, "chosen record must fix the cycle origin")

    top_words = [spell(host_text, x, host_z(x)) for x in range(q)]
    base_layers = [(host_text, host_z, q, 0)]
    normalized = []
    available = q
    for child in children:
        a, b = child["record"]
        block = child["primitive_word"]
        p = len(block)
        ends = child["requester_ends"]
        require(bool(ends), "child group has no requesting layers")
        require(a <= b and host_z(a - 1) <= b <= host_z(a), "record is not an actual host window")
        text = lambda x, block=block, a=a, p=p: block[(x - a) % p]
        require(spell(host_text, a, b) == spell(text, a, b), "record texts disagree")
        require(b - a < p + q, "violated host-child agreement bound")
        shift = -((a - a0) // q) * q
        if a + shift == a0 and b + shift < b0:
            shift += q
        require(shift == child["transport"], "incorrect cyclic alignment transport")
        na, nb = a + shift, b + shift
        require(a0 <= na <= a0 + q and b0 <= nb <= b0 + q, "record is outside the cyclic strip")
        shifted_text = lambda x, text=text, shift=shift: text(x - shift)
        require(
            spell(shifted_text, na, nb) == spell(host_text, na, nb),
            "transported child alignment does not agree",
        )
        for end in ends:
            require(type(end) is int and a + p < end <= b - p, "request condition fails")
            z = lambda x, a=a, end=end, p=p: end + p * ((x - a) // p)
            require(z(a - 1) <= end <= z(a), "requester window is not actual")
            base_layers.append((text, z, p, a))
            top_words.extend(spell(text, x, z(x)) for x in range(a, a + p))
            available += p
        normalized.append(
            {"id": child["id"], "a": na, "b": nb, "p": p,
             "ends": [e + shift for e in ends], "text": shifted_text}
        )

    normalized.sort(key=lambda c: (c["a"], c["b"], c["id"]))
    require(normalized[0]["id"] == chosen["id"], "chosen record is not first")
    require(
        [[c["a"], c["b"]] for c in normalized] == cert["expected"]["normalized_records"],
        "normalized records differ from the certificate",
    )
    for first, later in zip(normalized, normalized[1:]):
        require(first["a"] <= later["a"] and first["b"] <= later["b"], "host records cross")
        require(first["b"] - later["a"] < first["p"] + later["p"], "child agreement bound fails")

    language = {""}
    for word in top_words:
        language.update(word[a:b] for a in range(len(word) + 1) for b in range(a, len(word) + 1))
    require(set(host_block).issubset(language), "host alphabet is not in V")
    base_walks = [layer_walk(*layer) for layer in base_layers]
    for walk, (_, _, p, _) in zip(base_walks, base_layers):
        require(check_walk(walk, language, closed=True) == p, "incorrect layer period cost")

    first_group = normalized[0]
    host_windows = [(a0, e) for e in sorted(first_group["ends"])] + [(a0, b0)]
    contacts = []
    attachments = []
    requester_words = [spell(host_text, a0, e) for e in first_group["ends"]]
    for child in normalized[1:]:
        a, b, p = child["a"], child["b"], child["p"]
        require(b - (a0 + q) < p + p0, "next-copy agreement bound fails")
        for index, end in sorted(enumerate(child["ends"]), key=lambda item: item[1]):
            s, h = min(a + p, a0 + q), max(end, b0)
            require(a <= s < h <= b and end <= h <= end + p, "invalid clipped contact")
            require(h < a0 + q + p0, "closing contact is not short")
            contacts.append({"group": child["id"], "requester": index, "window": [s, h]})
            host_windows.append((s, h))
            text = child["text"]
            require(spell(text, s, h) == spell(host_text, s, h), "contact texts disagree")
            middle = (a + p, end + p)
            loop = join(
                [follow(text, (s, h), middle, language),
                 follow(text, middle, (s + p, h + p), language)]
            )
            require(check_walk(loop, language, closed=True) == p, "attachment cost is not p")
            attachments.append(loop)
            requester_words.append(spell(text, a, end))
            require(spell(text, a, end) in loop, "attachment misses its actual requester word")
    require(contacts == cert["expected"]["contacts"], "contacts differ from the certificate")
    host_windows.append((a0 + q, min(first_group["ends"]) + q))
    host_parts = [follow(host_text, u, v, language) for u, v in zip(host_windows, host_windows[1:])]
    host_walk = join(host_parts)
    host_cost = check_walk(host_walk, language, closed=True)
    require(host_cost == q, "host excursion costs more than its budget")
    short_word = min(host_parts[-1], key=len)
    require(len(short_word) < p0, "no contact shorter than the minimum child period")
    root = [short_word[i:] for i in range(len(short_word) + 1)]
    root.extend(short_word[:i] for i in range(1, len(short_word) + 1))
    root_cost = check_walk(root, language, closed=True)
    attachment_cost = sum(check_walk(w, language, closed=True) for w in attachments)
    total = host_cost + attachment_cost + root_cost
    expected = cert["expected"]
    for key, value in {
        "short_word": short_word, "host_up_cost": host_cost,
        "attachment_up_cost": attachment_cost, "root_up_cost": root_cost,
        "total_up_cost": total, "available_budget": available,
    }.items():
        require(expected[key] == value, f"incorrect certified {key}")
    require(total <= available, "total reserved budget exceeded")

    adjacency = defaultdict(set)
    all_walks = base_walks + [host_walk, root] + attachments
    for walk in all_walks:
        for u, v in zip(walk, walk[1:]):
            adjacency[u].add(v)
            adjacency[v].add(u)
    reached = {""}
    queue = deque([""])
    while queue:
        for vertex in adjacency[queue.popleft()] - reached:
            reached.add(vertex)
            queue.append(vertex)
    require(all(v in reached for walk in all_walks for v in walk), "participating support is not rooted")
    require(all(v in reached for v in requester_words), "a requester is not rooted")
    return {"periods": [q] + [len(b) for b in blocks], "requesters": len(requester_words),
            "up_cost": total, "budget": available, "vertices": len(language),
            "rooted_support_vertices": len(reached), "clipping": "both_start_and_end"}


def check_jacobian(directory):
    payload = json.loads((directory / "jacobian_payload.json").read_text())
    record = json.loads((directory / "jacobian_result.json").read_text())
    require(record["request"]["operation_id"] == "word.periods.compute", "wrong Jacobian operation")
    require(record["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(record["server"]["version"] == "0.14.0", "unexpected recorded server version")
    require(record["protocol_version"] == "2025-11-25", "unexpected recorded protocol")
    output = record["result"]["output"]
    letters = payload["word"]["letters"]
    periods = [p for p in range(1, len(letters) + 1) if letters[p:] == letters[:-p]]
    require(output["complete"] is True and output["periods"] == periods, "incomplete period output")
    require(output["is_primitive"] is primitive("".join(letters)), "incorrect primitivity output")
    require(output["least_period"] == min(periods), "incorrect finite overlap period")
    return {"operation": "word.periods.compute", "status": "exact_typed_output_replayed",
            "finite_overlap_periods": periods, "infinite_repetition_least_period": len(letters)}


def corruption_tests(cert):
    mutations = [
        ("bad_request", lambda c: c["children"][0]["requester_ends"].__setitem__(0, 76)),
        ("bad_transport", lambda c: c["children"][1].__setitem__("transport", 109)),
        ("bad_contact", lambda c: c["expected"]["contacts"][0]["window"].__setitem__(1, 87)),
        ("bad_cost", lambda c: c["expected"].__setitem__("total_up_cost", 54)),
        ("empty_requesters", lambda c: c["children"][1].__setitem__("requester_ends", [])),
        ("nonprimitive_child", lambda c: c["children"][0].__setitem__("primitive_word", "aaaa")),
        ("bad_host_period", lambda c: c["host"].__setitem__("period", 0)),
        ("bad_record", lambda c: c["children"][2].__setitem__("record", [138, 154])),
    ]
    rejected = []
    for name, mutate in mutations:
        bad = copy.deepcopy(cert)
        mutate(bad)
        try:
            verify_instance(bad)
        except VerificationError:
            rejected.append(name)
        else:
            raise VerificationError(f"corrupted witness accepted: {name}")
    return rejected


def validate_formal_record(record, source, fidelity):
    check = record["lean_check"]
    require(record["subject"]["subject_id"] == "H_PATHS", "formal certificate has the wrong claim")
    require(record["tier"] == "mechanical" and record["verdict"] == "supports", "not mechanical support")
    require(check["status"] == "success" and check["exit_code"] == 0, "Lean did not compile")
    require(check["audit_exit_code"] == 0 and check["proof_holes"] == [], "Lean proof audit did not pass")
    require(not check["environment_failure"], "formal environment failure")
    require(check["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,"), "wrong Lean version")
    require(record["lean_source"]["text"].encode() == source, "archived Lean source differs")
    require(record["statement_fidelity"]["text"].encode() == fidelity, "archived fidelity differs")
    require(hashlib.sha256(source).hexdigest() == check["source_sha256"], "stale Lean source")
    require(
        hashlib.sha256(fidelity).hexdigest() == check["statement_fidelity_sha256"],
        "stale statement fidelity",
    )


def check_formal(cert, directory, self_test):
    evidence = cert["universal_evidence"]
    record = json.loads((directory / evidence["compiler_evidence"]).read_text())
    source_path = (directory / evidence["lean_source"]).resolve()
    fidelity_path = directory / evidence["statement_fidelity"]
    source = source_path.read_bytes()
    fidelity = fidelity_path.read_bytes()
    validate_formal_record(record, source, fidelity)
    require((directory / "lean/Main.lean").read_bytes() == source, "compiled snapshot differs from source")
    require(
        (directory / "lean/statement_fidelity.md").read_bytes() == fidelity,
        "compiled fidelity snapshot differs from the original",
    )
    rejected = []
    if self_test:
        mutations = [
            ("bad_formal_exit", lambda r: r["lean_check"].__setitem__("exit_code", 1)),
            ("formal_proof_hole", lambda r: r["lean_check"].__setitem__("proof_holes", ["hole"])),
            ("altered_formal_source", lambda r: r["lean_source"].__setitem__("text", "import Mathlib\n")),
            ("wrong_formal_claim", lambda r: r["subject"].__setitem__("subject_id", "H_HOST_VERIFIED")),
        ]
        for name, mutate in mutations:
            bad = copy.deepcopy(record)
            mutate(bad)
            try:
                validate_formal_record(bad, source, fidelity)
            except VerificationError:
                rejected.append(name)
            else:
                raise VerificationError(f"corrupted formal certificate accepted: {name}")
    workspace = record["lean_check"]["lake_workspace"]
    compiler = subprocess.run(
        ["lake", "env", "lean", str(source_path)], cwd=workspace, capture_output=True, text=True,
    )
    require(compiler.returncode == 0, f"fresh Lean compilation failed:\n{compiler.stdout}{compiler.stderr}")
    audit = subprocess.run(
        ["lake", "env", "lean", "--run",
         "$WORKSPACE/argus-live-update/argus_skill/tools/lean_axiom_audit.lean",
         str(source_path)],
        cwd=workspace, capture_output=True, text=True,
    )
    require(audit.returncode == 0, f"fresh Lean axiom audit failed:\n{audit.stdout}{audit.stderr}")
    require(source_path.read_bytes() == source, "source changed during the fresh compiler run")
    require(fidelity_path.read_bytes() == fidelity, "fidelity changed during the fresh compiler run")
    return {
        "claim": "H_PATHS", "lean_version": "4.31.0", "fresh_compiler_exit": compiler.returncode,
        "fresh_axiom_audit_exit": audit.returncode, "proof_holes": record["lean_check"]["proof_holes"],
        "whole_host_assembly": "mathematical proof.md, not a single kernel-closed host declaration",
        "corruptions_rejected": rejected,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=Path(__file__).with_name("exact_certificate.json"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    cert = json.loads(args.certificate.read_text())
    result = {
        "claim": cert["claim"],
        "classification": "universal_component_formalization_and_exact_word_replay",
        "instance": verify_instance(cert),
        "jacobian": check_jacobian(args.certificate.parent),
        "formal": check_formal(cert, args.certificate.parent, args.self_test),
    }
    if args.self_test:
        result["corruptions_rejected"] = corruption_tests(cert)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
