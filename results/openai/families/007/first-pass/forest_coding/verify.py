#!/usr/bin/env python3
"""Exact rational replay of the forest encoder, not a finite proof of its theorem."""

from __future__ import annotations

import argparse
import json
from collections import deque
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def canonical(word):
    numbers = {}
    return tuple(numbers.setdefault(z, len(numbers)) for z in word)


def rref(rows, width):
    matrix = [[Fraction(x) for x in row] for row in rows]
    require(all(len(row) >= width for row in matrix), "ragged matrix")
    pivots = []
    for column in range(width):
        pivot = next(
            (i for i in range(len(pivots), len(matrix)) if matrix[i][column]), None
        )
        if pivot is None:
            continue
        index = len(pivots)
        matrix[index], matrix[pivot] = matrix[pivot], matrix[index]
        scale = matrix[index][column]
        matrix[index] = [x / scale for x in matrix[index]]
        for i in range(len(matrix)):
            if i != index and matrix[i][column]:
                scale = matrix[i][column]
                matrix[i] = [
                    x - scale * y for x, y in zip(matrix[i], matrix[index])
                ]
        pivots.append(column)
    return matrix, pivots


def rank(rows, width):
    return len(rref(rows, width)[1])


def unit(index, size):
    return tuple(Fraction(int(j == index)) for j in range(size))


def sub(left, right):
    return tuple(x - y for x, y in zip(left, right))


def dot(left, right):
    return sum((x * y for x, y in zip(left, right)), Fraction(0))


def pair_data(word, coefficients, lit):
    size = max(word) + 1
    offsets = [tuple(Fraction(0) for _ in range(size))]
    for z, t in zip(word, coefficients):
        entry = list(offsets[-1])
        entry[z] += t
        offsets.append(tuple(entry))
    pairs = [
        (unit(word[i], size), sub(offsets[i], offsets[j]))
        for i in range(len(word))
        for j in range(i + 1, len(word))
        if lit[i] and lit[j] and word[i] == word[j]
    ]
    return offsets, pairs


def has_joint_pairs(pairs, count, size, rows=(), start=0):
    if count == 0:
        return True
    if len(rows) + 2 * count > size:
        return False
    for index in range(start, len(pairs)):
        candidate = rows + pairs[index]
        if rank(candidate, size) == len(candidate):
            if has_joint_pairs(pairs, count - 1, size, candidate, index + 1):
                return True
    return False


def quotient(word, coefficients, lit, r):
    size = max(word) + 1
    offsets, pairs = pair_data(word, coefficients, lit)
    require(not has_joint_pairs(pairs, r, size), "r jointly independent pairs")
    rows = ()
    for pair in pairs:
        if rank(rows + pair, size) == len(rows) + 2:
            rows += pair
    require(len(rows) < 2 * r, "maximal pair bound")
    require(
        all(rank(rows + pair, size) < len(rows) + 2 for pair in pairs),
        "pair collection not inclusion-maximal",
    )
    basis = list(rows)
    regular = []
    for z in range(size):
        if rank(basis + [unit(z, size)], size) > len(basis):
            basis.append(unit(z, size))
            regular.append(z)
    require(len(basis) == size, "coordinate-image basis incomplete")
    require(size - len(regular) == len(rows), "wrong omitted-label count")
    augmented = [
        [basis[j][i] for j in range(size)] + list(unit(i, size))
        for i in range(size)
    ]
    inverse, pivots = rref(augmented, size)
    require(pivots == list(range(size)), "singular completed basis")
    inverse = [row[size:] for row in inverse]
    projected = [
        tuple(dot(row, offset) for row in inverse[len(rows) :])
        for offset in offsets
    ]
    regular_index = {z: i for i, z in enumerate(regular)}
    for z in regular:
        starts = [i for i in range(len(word)) if lit[i] and word[i] == z]
        if starts:
            base = projected[starts[0]]
            require(
                all(
                    all(x == 0 or j == regular_index[z] for j, x in enumerate(
                        sub(projected[i], base)
                    ))
                    for i in starts
                ),
                "quotient saturation failed",
            )
    return projected, set(regular), len(rows)


def block_runs(word, coefficients, lit, blocks):
    n = len(word)
    covered = set()
    result = []
    previous_end = 0
    for start, end in blocks:
        require(previous_end <= start < end <= n, "invalid or overlapping blocks")
        require(all(lit[start:end]), "block contains an unlit position")
        runs = []
        index = start
        seen = set()
        while index < end:
            stop = index + 1
            while stop < end and word[stop] == word[index]:
                stop += 1
            require(word[index] not in seen, "non-interval label occurrence")
            require(sum(coefficients[index:stop]) != 0, "zero run increment")
            seen.add(word[index])
            runs.append((index, stop, word[index]))
            index = stop
        covered.update(range(start, end))
        previous_end = end
        result.append(runs)
    return result, covered


def forest_encode(adjacency, kinds):
    visited = set()
    preorder = {}
    bits = []
    for root in range(len(adjacency)):
        if root in visited:
            continue
        stack = [(root, -1, False)]
        while stack:
            vertex, parent, closing = stack.pop()
            if closing:
                bits.append("1")
                continue
            require(vertex not in visited, "incidence graph has a cycle")
            visited.add(vertex)
            preorder[vertex] = len(preorder)
            bits.extend(("0", str(kinds[vertex])))
            stack.append((vertex, parent, True))
            for child in sorted(adjacency[vertex], reverse=True):
                if child != parent:
                    stack.append((child, vertex, False))
    return int("1" + "".join(bits), 2), preorder


def forest_decode(number, n):
    require(type(number) is int and 1 <= number < 2 ** (6 * n + 3),
            "forest integer out of range")
    bits = bin(number)[3:]
    adjacency = []
    kinds = []
    stack = []
    index = 0
    while index < len(bits):
        if bits[index] == "0":
            require(index + 1 < len(bits), "truncated forest type")
            vertex = len(kinds)
            kind = int(bits[index + 1])
            kinds.append(kind)
            adjacency.append(set())
            if stack:
                parent = stack[-1]
                require(kinds[parent] != kind, "forest is not bipartite")
                adjacency[parent].add(vertex)
                adjacency[vertex].add(parent)
            stack.append(vertex)
            index += 2
        else:
            require(bool(stack), "unmatched forest close")
            stack.pop()
            index += 1
    require(not stack, "unclosed forest")
    require(len(kinds) <= 2 * n, "too many forest vertices")
    return adjacency, kinds


def endpoint_path(adjacency, kinds, start, end):
    require(0 <= start < len(kinds) and kinds[start] == 0, "invalid start line")
    require(0 <= end < len(kinds) and kinds[end] == 0, "invalid end line")
    queue = deque([start])
    previous = {start: None}
    while queue and end not in previous:
        current = queue.popleft()
        for neighbour in sorted(adjacency[current]):
            if neighbour not in previous:
                previous[neighbour] = current
                queue.append(neighbour)
    require(end in previous, "disconnected segment endpoints")
    vertices = []
    current = end
    while current is not None:
        vertices.append(current)
        current = previous[current]
    return [v for v in reversed(vertices) if kinds[v] == 0]


def encode_witness(word, coefficients, lit, blocks, r=None, B=None, I=None):
    word = canonical(word)
    n = len(word)
    require(n >= 1, "empty word")
    coefficients = tuple(Fraction(t) for t in coefficients)
    require(len(coefficients) == n and len(lit) == n, "wrong witness lengths")
    size = max(word) + 1
    r = size // 2 + 1 if r is None else r
    require(r >= 1, "r must be positive")
    runs_by_block, covered = block_runs(word, coefficients, lit, blocks)
    B = len(blocks) if B is None else B
    I = n - len(covered) if I is None else I
    require(B >= len(blocks) and I >= n - len(covered), "insufficient block bounds")
    projected, regular, d = quotient(word, coefficients, lit, r)
    masks = [[0] * n for _ in range(4)]
    for i in range(n):
        masks[0][i] = int(i not in covered)
    segments = []
    omitted_runs = []
    for runs in runs_by_block:
        masks[1][runs[0][0]] = 1
        segment = []
        for start, end, z in runs:
            masks[2][start] = 1
            if z in regular:
                segment.append((start, end, z))
            else:
                for i in range(start, end):
                    masks[3][i] = 1
                omitted_runs.append((start, end, z))
                if segment:
                    segments.append(segment)
                    segment = []
        if segment:
            segments.append(segment)
    require(len(omitted_runs) <= d * len(blocks), "omitted run bound")
    require(len(segments) <= (d + 1) * len(blocks), "regular segment bound")
    vertices = {}
    adjacency = []
    kinds = []

    def vertex(key, kind):
        if key not in vertices:
            vertices[key] = len(vertices)
            adjacency.append(set())
            kinds.append(kind)
        return vertices[key]

    for segment in segments:
        for _, _, z in segment:
            vertex(("line", z), 0)
        for left, right in zip(segment, segment[1:]):
            point = vertex(("point", projected[left[1]]), 1)
            require(projected[left[1]] == projected[right[0]], "transition mismatch")
            for run in (left, right):
                line = vertex(("line", run[2]), 0)
                adjacency[line].add(point)
                adjacency[point].add(line)
    require(len(vertices) <= 2 * n, "incidence size bound")
    forest, preorder = forest_encode(adjacency, kinds)
    records = []
    for segment in segments:
        records.extend(preorder[vertices[("line", run[2])]]
                       for run in (segment[0], segment[-1]))
    first_omitted = {}
    for start, _, z in omitted_runs:
        records.append(first_omitted.setdefault(z, start))
    first_perfect = {}
    for i in sorted(covered):
        first_perfect.setdefault(word[i], i)
    first_imperfect = {}
    for i, z in enumerate(word):
        if i not in covered:
            if z in first_perfect:
                records.append(first_perfect[z])
            else:
                records.append(first_imperfect.setdefault(z, i))
    exponent = (6 * r - 4) * B + I
    require(len(records) <= exponent, "record-count bound")
    used = len(records)
    records.extend([0] * (exponent - used))
    code = {"masks": masks, "forest": forest, "records": records}
    require(decode(code, n, r, B, I) == word, "decode/encode mismatch")
    return code, {
        "n": n, "r": r, "B": B, "I": I, "omitted_labels": d,
        "omitted_runs": len(omitted_runs), "regular_segments": len(segments),
        "forest_vertices": len(vertices), "used_records": used,
        "record_budget": exponent,
    }


def decode(code, n, r, B, I):
    require(n >= 1 and r >= 1 and B >= 0 and I >= 0, "invalid public parameters")
    masks = code["masks"]
    require(len(masks) == 4 and all(len(mask) == n for mask in masks),
            "invalid mask dimensions")
    require(all(type(x) is int and x in (0, 1) for mask in masks for x in mask),
            "invalid mask bit")
    outside, block_start, run_start, omitted = masks
    require(sum(outside) <= I, "too many imperfect positions")
    require(all(not outside[i] or
                (block_start[i] == run_start[i] == omitted[i] == 0)
                for i in range(n)), "data on imperfect position")
    blocks = []
    index = 0
    while index < n:
        if outside[index]:
            index += 1
            continue
        require(block_start[index] == 1, "missing block start")
        end = index + 1
        while end < n and not outside[end] and not block_start[end]:
            end += 1
        require(run_start[index] == 1, "missing initial run")
        starts = [i for i in range(index, end) if run_start[i]]
        runs = []
        for start, stop in zip(starts, starts[1:] + [end]):
            require(all(omitted[i] == omitted[start] for i in range(start, stop)),
                    "mixed run status")
            runs.append((start, stop, omitted[start]))
        blocks.append(runs)
        index = end
    require(len(blocks) <= B, "too many blocks")
    segments = []
    omitted_runs = []
    for runs in blocks:
        segment = []
        for run in runs:
            if run[2]:
                omitted_runs.append(run)
                if segment:
                    segments.append(segment)
                    segment = []
            else:
                segment.append(run)
        if segment:
            segments.append(segment)
    records = code["records"]
    exponent = (6 * r - 4) * B + I
    used = 2 * len(segments) + len(omitted_runs) + sum(outside)
    require(len(records) == exponent and used <= exponent, "wrong record budget")
    require(all(type(x) is int and 0 <= x < 2 * n for x in records),
            "record out of range")
    require(all(x == 0 for x in records[used:]), "nonzero padding")
    adjacency, kinds = forest_decode(code["forest"], n)
    output = [None] * n
    cursor = 0
    for segment in segments:
        path = endpoint_path(adjacency, kinds, records[cursor], records[cursor + 1])
        cursor += 2
        require(len(path) == len(segment), "wrong decoded segment length")
        for (start, end, _), line in zip(segment, path):
            output[start:end] = [("regular", line)] * (end - start)
    omitted_starts = {run[0] for run in omitted_runs}
    for start, end, _ in omitted_runs:
        representative = records[cursor]
        cursor += 1
        require(representative in omitted_starts and representative <= start,
                "invalid omitted representative")
        output[start:end] = [("omitted", representative)] * (end - start)
    for start, _, _ in omitted_runs:
        representative = output[start][1]
        require(output[representative] == ("omitted", representative),
                "non-root omitted representative")
    imperfect = [i for i in range(n) if outside[i]]
    references = dict(zip(imperfect, records[cursor:cursor + len(imperfect)]))
    for i in imperfect:
        representative = references[i]
        require(representative < n, "imperfect representative out of range")
        if outside[representative]:
            require(references.get(representative) == representative,
                    "non-root imperfect representative")
            output[i] = ("imperfect_only", representative)
        else:
            require(output[representative] is not None, "unresolved perfect label")
            output[i] = output[representative]
    require(all(z is not None for z in output), "unassigned position")
    for runs in blocks:
        run_labels = [output[start] for start, _, _ in runs]
        require(len(set(run_labels)) == len(run_labels), "decoded non-interval block")
    return canonical(output)


def restricted_growth(n):
    def extend(prefix, maximum):
        if len(prefix) == n:
            yield tuple(prefix)
            return
        for z in range(maximum + 2):
            yield from extend(prefix + [z], max(maximum, z))
    yield from extend([], -1)


def admissible_blocks(word, coefficients, lit, cap=3):
    blocks = []
    index = 0
    while index < len(word):
        if not lit[index]:
            index += 1
            continue
        end = index + 1
        while end < len(word) and lit[end] and end - index < cap:
            try:
                block_runs(word, coefficients, lit, [(index, end + 1)])
            except ValueError as error:
                require(str(error) in ("zero run increment", "non-interval label occurrence"),
                        "unexpected block construction error")
                break
            end += 1
        blocks.append((index, end))
        index = end
    return blocks


def reject(function, message):
    try:
        function()
    except ValueError as error:
        require(message in str(error), f"wrong rejection: {error}")
        return
    raise AssertionError(f"expected rejection: {message}")


def formal_core():
    source = (ROOT / "Main.lean").read_text()
    fidelity = (ROOT / "statement_fidelity.md").read_text()
    matching = []
    for path in sorted((ROOT / "certificates").glob("C_FOREST_FORMAL_CORE-*.json")):
        archive = json.loads(path.read_text())
        if (archive["verdict"] == "supports"
                and archive["lean_source"]["text"] == source
                and archive["statement_fidelity"]["text"] == fidelity):
            matching.append((path, archive))
    require(len(matching) == 1, "no unique current formal-core certificate")
    path, archive = matching[0]
    result = archive["lean_check"]
    require(result == json.loads((ROOT / "lean_check.json").read_text()),
            "current compiler result differs from the archived run")
    require(result["status"] == "success" and result["exit_code"] == 0,
            "Lean did not succeed")
    require(result["proof_holes"] == [] and result["audit_exit_code"] == 0,
            "Lean proof-hole or axiom audit failed")
    require("version 4.31.0," in result["tools"]["lean"]["version"],
            "wrong Lean version")
    require(archive["subject"]["subject_id"] == "C_FOREST_FORMAL_CORE",
            "wrong formal claim")
    return {
        "claim": "C_FOREST_FORMAL_CORE",
        "certificate": str(path.relative_to(ROOT)),
        "compiler_version": "4.31.0",
        "exit_code": 0,
        "proof_holes": [],
        "axiom_audit_exit_code": 0,
        "scope": "universal core lemmas; full witness encoding is proved in report.md",
        "source_and_fidelity_match_archived_text": True,
    }


def replay():
    cases = [
        ("path_and_reverse", [0, 1, 2, 2, 1, 0],
         [1, 1, 1, -1, -1, -1], [1] * 6, [(0, 3), (3, 6)], 1),
        ("three_concurrent_lines", [0, 1, 1, 0, 0, 2, 2, 0],
         [1, 1, -1, -1, 1, 1, -1, -1], [1] * 8,
         [(0, 2), (2, 4), (4, 6), (6, 8)], 1),
        ("imperfect_only_and_existing_labels", [0, 1, 2, 2, 1, 0, 3, 3, 0],
         [1, 1, 1, -1, -1, -1, 2, -2, 3], [1] * 6 + [0] * 3,
         [(0, 3), (3, 6)], 1),
        ("two_omitted_labels", [0, 1, 0, 2, 1, 2],
         [1] * 6, [1] * 6, [(0, 2), (2, 5), (5, 6)], 2),
        ("zero_dimensional_quotient", [0, 1, 0],
         [1] * 3, [1] * 3, [(0, 2), (2, 3)], 2),
        ("no_perfect_position", [0, 1, 0, 2, 1],
         [1, -2, 3, -4, 5], [0] * 5, [], 1),
        ("one_run", [0, 0, 0], [1, -2, 4], [1] * 3, [(0, 3)], 1),
    ]
    fixtures = []
    for name, word, coefficients, lit, blocks, r in cases:
        code, diagnostics = encode_witness(word, coefficients, lit, blocks, r)
        fixtures.append({
            "name": name, "word": word, "coefficients": coefficients,
            "lit": lit, "blocks": [list(block) for block in blocks],
            "parameters": diagnostics, "code": code,
        })
    counts = {"witnesses": 0, "patterns": 0, "codes": 0}
    observed_codes = {}
    observed_patterns = set()
    for n in range(1, 7):
        for word in restricted_growth(n):
            observed_patterns.add(word)
            coefficient_arrays = (
                [1] * n,
                [(-1) ** i for i in range(n)],
                [Fraction((-1) ** i * (i + 1), i + 2) for i in range(n)],
            )
            for coefficients in coefficient_arrays:
                for lit in ([1] * n, [int(i % 3 != 1) for i in range(n)], [0] * n):
                    blocks = admissible_blocks(word, coefficients, lit)
                    code, diagnostics = encode_witness(
                        word, coefficients, lit, blocks, r=n // 2 + 1, B=n, I=n
                    )
                    key = (n, diagnostics["r"], diagnostics["B"], diagnostics["I"],
                           json.dumps(code, sort_keys=True))
                    require(key not in observed_codes or observed_codes[key] == word,
                            "cross-coefficient code collision")
                    observed_codes[key] = word
                    counts["witnesses"] += 1
    counts["patterns"] = len(observed_patterns)
    counts["codes"] = len(observed_codes)
    reject(lambda: encode_witness([0, 1, 1, 2], [1, 1, -1, 1], [1] * 4,
                                  [(0, 4)], 1), "zero run increment")
    reject(lambda: encode_witness([0, 1, 0], [1] * 3, [1] * 3,
                                  [(0, 3)], 2), "non-interval")
    reject(lambda: encode_witness([0, 1, 0], [1] * 3, [1] * 3,
                                  [(0, 2), (2, 3)], 1),
           "r jointly independent pairs")
    reject(lambda: encode_witness([0, 1], [1, 1], [1, 0], [(0, 2)], 1),
           "unlit position")
    malformed = json.loads(json.dumps(fixtures[2]["code"]))
    data = fixtures[2]["parameters"]
    cursor = 2 * data["regular_segments"] + data["omitted_runs"]
    malformed["records"][cursor:cursor + 2] = [7, 6]
    reject(lambda: decode(malformed, data["n"], data["r"], data["B"], data["I"]),
           "non-root imperfect representative")
    payload = json.loads((ROOT / "jacobian/rank_payload.json").read_text())
    adapter = json.loads((ROOT / "jacobian/rank_output.json").read_text())
    require(adapter["request"]["payload"] == payload, "Jacobian payload mismatch")
    require(adapter["result"]["operation_id"] == "matrix.rank.compute",
            "wrong Jacobian operation")
    matrix = [[Fraction(int(x["num"]), int(x["den"])) for x in row]
              for row in payload["matrix"]["entries"]]
    require(rank(matrix, len(matrix[0])) == adapter["result"]["output"]["rank"] == 2,
            "Jacobian rank replay failed")
    return {
        "result_class": "structural_verification",
        "claim": "C_FOREST_SPECIALIZATION",
        "full_theorem_evidence": "report.md: all-length proof, Sections 1-4 and specialization",
        "finite_replay_is_not_an_all_length_proof": True,
        "theorem": {
            "parameters": "n>=1,r>=1,B>=0,I>=0",
            "union": "all fields, coefficients, lit sets, and admissible block choices",
            "bound": "2^(10*n+3)*(2*n)^((6*r-4)*B+I)",
            "manuscript_constant_C": 2048,
            "sufficient_L_lower_bound": 1024,
        },
        "finite_replay": counts,
        "expected_hypothesis_rejections": 5,
        "fixtures": fixtures,
        "lean": formal_core(),
        "jacobian": {
            "operation_id": "matrix.rank.compute",
            "server_version": adapter["server"]["version"],
            "protocol_version": adapter["protocol_version"],
            "adapter_exit_status": 0,
            "structured_error": None,
            "rank": 2,
            "payload": "jacobian/rank_payload.json",
            "typed_output": "jacobian/rank_output.json",
        },
        "independent_review": "pending; not supplied by this script",
        "novelty": "global novelty not established",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    args = parser.parse_args()
    certificate = replay()
    path = ROOT / "exact_certificate.json"
    if args.write_certificate:
        path.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    require(json.loads(path.read_text()) == certificate, "certificate replay differs")
    print(json.dumps({
        "ok": True, "claim": certificate["claim"],
        "finite_replay": certificate["finite_replay"],
        "hypothesis_rejections": certificate["expected_hypothesis_rejections"],
        "lean_exit_code": certificate["lean"]["exit_code"],
        "proof_holes": certificate["lean"]["proof_holes"],
        "all_length_proof": "research/forest_coding/report.md",
        "independent_review": "pending",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
