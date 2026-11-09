#!/usr/bin/env python3
"""Replay literal switching/code examples, then recompile the universal theorem."""

from dataclasses import dataclass
from datetime import datetime, timezone
from fractions import Fraction
import json
from pathlib import Path
import subprocess


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
ARGUS = "$WORKSPACE/argus-live-update/.venv/bin/python"
CLAIM = "C_AMP_JOINT_UNDO"
CERTIFICATE = HERE / "exact_certificate.json"
Edge = tuple[int, int]
Fields = tuple[tuple[bool, ...], ...]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


@dataclass(frozen=True)
class Move:
    index: int
    seam: int
    piece: frozenset[int]
    mask: frozenset[int]


def component(
    edges: tuple[Edge, ...],
    field: tuple[bool, ...],
    start: int,
    blocked: frozenset[int] = frozenset(),
) -> frozenset[int]:
    if start in blocked:
        return frozenset()
    seen = {start}
    todo = [start]
    while todo:
        vertex = todo.pop()
        for (a, b), opened in zip(edges, field, strict=True):
            if not opened:
                continue
            neighbor = b if a == vertex else a if b == vertex else None
            if neighbor is not None and neighbor not in blocked and neighbor not in seen:
                seen.add(neighbor)
                todo.append(neighbor)
    return frozenset(seen)


def slot(family: int, index: int, k: int) -> int:
    return 1 + family * k + index


def exchange(fields: Fields, family: int, move: Move, k: int) -> Fields:
    result = [list(field) for field in fields]
    auxiliary = slot(family, move.index, k)
    for edge in move.mask:
        result[0][edge], result[auxiliary][edge] = result[auxiliary][edge], result[0][edge]
    return tuple(tuple(field) for field in result)


def apply_history(
    fields: Fields, family: int, moves: tuple[Move, ...], k: int, *, reverse: bool = False
) -> Fields:
    for move in reversed(moves) if reverse else moves:
        fields = exchange(fields, family, move, k)
    return fields


def mask(edges: tuple[Edge, ...], root: frozenset[int], piece: frozenset[int], seam: int):
    return frozenset(
        edge
        for edge, (a, b) in enumerate(edges)
        if edge == seam or ((a in piece or b in piece) and a not in root and b not in root)
    )


def old_replay(edges, fields, family, endpoint, old_targets, cap):
    k = len(old_targets)
    tips = [endpoint] * k
    clusters = [frozenset()] * k
    current = endpoint
    for index in reversed(range(k)):
        tips[index] = current
        cluster = component(edges, fields[slot(family, index, k)], current)
        require(len(cluster) <= cap, "old-map cluster exceeds its cap")
        # This sufficient integer bound implies goodness for s=3/4 after every deletion.
        require((len(cluster) - 1) ** 4 <= cap**3, "old-map goodness bound failed")
        target = old_targets[index]
        current = min(cluster, key=lambda vertex: (vertex != target, vertex))
        require(current == target, "fixed old-map priority did not recover its target")
        clusters[index] = cluster
    return tuple(tips), tuple(clusters), current


def run(
    edges, fields, family, endpoint, old_targets, uniforms, n, cap, *, virtual=False
):
    k = len(old_targets)
    tips, clusters, y0 = old_replay(edges, fields, family, endpoint, old_targets, cap)
    original_aux = tuple(fields[slot(family, i, k)] for i in range(k))
    root = component(edges, fields[0], 0)
    initial = root
    if not virtual:
        require(n <= len(root) < 2 * n, "original bin test failed")
        require(y0 in root, "original terminal old endpoint is outside the root")
    moves = []
    contact_counts = []
    lo = 0
    while endpoint not in root:
        eligible = [i for i in range(lo, k) if clusters[i] & root]
        require(bool(eligible), "greedy procedure has no eligible cluster")
        index = max(eligible)
        require(tips[index] not in root, "selected tip is already in the root")
        require(
            fields[slot(family, index, k)] == original_aux[index],
            "an eligible original auxiliary field was modified",
        )
        piece = component(edges, original_aux[index], tips[index], root)
        contacts = [
            edge
            for edge, (a, b) in enumerate(edges)
            if original_aux[index][edge]
            and ((a in piece and b in root) or (b in piece and a in root))
        ]
        require(bool(contacts), "selected piece has no open contact")
        uniform = uniforms[index]
        require(0 <= uniform < 1, "invalid fixed contact uniform")
        seam = contacts[int(uniform * len(contacts))]
        move = Move(index, seam, piece, mask(edges, root, piece, seam))
        fields = exchange(fields, family, move, k)
        root = root | piece
        require(component(edges, fields[0], 0) == root, "one-step root identity failed")
        moves.append(move)
        contact_counts.append(len(contacts))
        lo = index + 1
        require(len(moves) <= k, "indices did not increase")
    return fields, tuple(moves), initial, y0, tuple(contact_counts)


def separating_bridges(edges, field, endpoint):
    bridges = []
    for edge, opened in enumerate(field):
        if not opened:
            continue
        cut = tuple(bit and i != edge for i, bit in enumerate(field))
        far = component(edges, cut, endpoint)
        if 0 not in far:
            bridges.append((len(far), edge, far))
    return tuple(sorted(bridges))


def encode(edges, output, endpoint, moves, cap):
    bridges = separating_bridges(edges, output[0], endpoint)
    positions = {edge: position for position, (_, edge, _) in enumerate(bridges)}
    previous = -1
    code = []
    for move in reversed(moves):
        require(move.seam in positions, "a selected seam does not separate endpoint and root")
        position = positions[move.seam]
        gap = position - previous
        require(1 <= gap <= cap, "invalid positive bridge gap")
        code.append((move.index + 1, gap))
        previous = position
    return tuple(code)


def decode_and_check(edges, output, family, endpoint, code, targets, uniforms, n, cap):
    bridges = separating_bridges(edges, output[0], endpoint)
    selected = []
    position = -1
    for source_index, gap in code:
        require(1 <= source_index <= len(targets), "coded index is out of range")
        require(1 <= gap <= cap, "coded gap is out of range")
        position += gap
        require(position < len(bridges), "coded seam is beyond the separating bridges")
        _, seam, far = bridges[position]
        selected.append((source_index - 1, seam, far))
    selected.reverse()
    require(bool(selected), "this regression requires a nonempty inverse")
    root = component(edges, output[0], 0) - selected[0][2]
    moves = []
    for offset, (index, seam, far) in enumerate(selected):
        next_far = selected[offset + 1][2] if offset + 1 < len(selected) else frozenset()
        require(next_far <= far, "coded far components are not nested")
        piece = far - next_far
        moves.append(Move(index, seam, piece, mask(edges, root, piece, seam)))
        root |= piece
    history = tuple(moves)
    original = apply_history(output, family, history, len(targets), reverse=True)
    replay, replay_history, initial, y0, counts = run(
        edges, original, family, endpoint, targets, uniforms, n, cap
    )
    require(replay == output, "literal coded inverse did not reproduce all output bits")
    require(replay_history == history, "literal inverse disagrees with actual greedy replay")
    return original, history, initial, y0, counts


def separated(edges, first, second):
    return not first & second and not any(
        (a in first and b in second) or (b in first and a in second) for a, b in edges
    )


def bit_weight(fields: Fields, p: Fraction) -> Fraction:
    count = sum(sum(field) for field in fields)
    total = sum(len(field) for field in fields)
    formula = p**count * (1 - p) ** (total - count)
    product = Fraction(1)
    for field in fields:
        for opened in field:
            product *= p if opened else 1 - p
    require(formula == product, "Bernoulli count formula disagrees with product")
    return product


def example(k: int, uniform: Fraction):
    core = frozenset({0, 1, 2} | set(range(7, 68)))
    edges = [(0, 1), (0, 2), (1, 2), (0, 3), (1, 3), (3, 4), (2, 5), (5, 6)]
    previous = 0
    for vertex in range(7, 68):
        edges.append((previous, vertex))
        previous = vertex
    edges = tuple(edges)

    def field(open_edges):
        return tuple(i in open_edges for i in range(len(edges)))

    distinguished = field({0, 1, 2} | set(range(8, len(edges))))
    if k == 1:
        auxiliary = (field({4, 5}), field({6, 7}))
        targets = ((1,), (2,))
    else:
        require(k == 3, "unsupported regression case")
        auxiliary = (
            field({2, 6, 7}),
            field({3, 4}),
            field({5}),
            field({2, 4, 5}),
            field({6}),
            field({7}),
        )
        targets = ((6, 1, 3), (4, 2, 5))
    initial = (distinguished,) + auxiliary
    require(component(edges, initial[0], 0) == core, "regression core is incorrect")
    uniforms = (uniform,) * k
    n, cap = 64, 8
    require(k * cap <= n // 2, "scale/cap condition failed")

    first_only, first, _, _, _ = run(
        edges, initial, 0, 4, targets[0], uniforms, n, cap, virtual=True
    )
    output, second, _, _, _ = run(
        edges, first_only, 1, 6, targets[1], uniforms, n, cap
    )
    second_only, second_virtual, _, _, _ = run(
        edges, initial, 1, 6, targets[1], uniforms, n, cap, virtual=True
    )
    opposite_output, first_actual, _, _, _ = run(
        edges, second_only, 0, 4, targets[0], uniforms, n, cap
    )
    require(output == opposite_output, "two actual orders produced different outputs")
    require(first == first_actual and second == second_virtual, "actual/virtual histories differ")
    codes = (
        encode(edges, output, 4, first, cap),
        encode(edges, output, 6, second, cap),
    )
    decoded_first = decode_and_check(
        edges, output, 0, 4, codes[0], targets[0], uniforms, n, cap
    )
    decoded_second = decode_and_check(
        edges, output, 1, 6, codes[1], targets[1], uniforms, n, cap
    )
    require(decoded_first[1] == first and decoded_second[1] == second, "codes lost a move")
    hanging = (
        frozenset().union(*(m.piece for m in first)),
        frozenset().union(*(m.piece for m in second)),
    )
    require(separated(edges, *hanging), "hanging sets are not graph-separated")
    masks = (
        frozenset().union(*(m.mask for m in first)),
        frozenset().union(*(m.mask for m in second)),
    )
    require(not masks[0] & masks[1], "the two families share a mask edge")
    restored = apply_history(decoded_first[0], 1, second, k, reverse=True)
    require(restored == initial, "joint undo did not recover the complete initial tuple")
    require(component(edges, restored[0], 0) == component(edges, output[0], 0) - hanging[0] - hanging[1],
            "exact joint-root identity failed")
    require(n - k * cap <= len(core) < 2 * n, "joint-root size window failed")
    for family, endpoint, history in ((0, 4, first), (1, 6, second)):
        replay, recovered, _, _, _ = run(
            edges, restored, family, endpoint, targets[family], uniforms, n, cap, virtual=True
        )
        require(recovered == history, "joint tuple did not recover an entire greedy history")
        _, clusters, _ = old_replay(edges, restored, family, endpoint, targets[family], cap)
        require(any(cluster & core for cluster in clusters), "restored trajectory misses the root")
        require(replay == apply_history(restored, family, history, k),
                "virtual replay does not equal physical forward swaps")
    combined = apply_history(apply_history(restored, 1, second, k), 0, first, k)
    require(combined == output, "recovered histories did not reconstruct every output bit")
    for p in (Fraction(0), Fraction(1, 3), Fraction(1, 2), Fraction(2, 3), Fraction(1)):
        require(bit_weight(output, p) == bit_weight(restored, p), "tuple weight changed")
    require(
        not separated(edges + ((3, 5),), *hanging),
        "a closed underlying cross edge was incorrectly admitted",
    )
    if k == 3:
        require(decoded_first[3] in hanging[1] and decoded_second[3] in hanging[0],
                "the y0-in-the-other-hanging-set regression was not exercised")
        require(0 not in {m.index for m in first + second}, "unused index was not skipped")
        require(max(decoded_first[4]) == 2, "multiple contact choices were not exercised")
        require(bool(first[0].mask & first[1].mask), "within-family overlapping masks were not exercised")
    return {
        "k": k,
        "n": n,
        "cap": cap,
        "contact_uniform": [uniform.numerator, uniform.denominator],
        "vertex_count": 68,
        "edge_count": len(edges),
        "bit_coordinates": sum(len(field) for field in output),
        "open_coordinates": sum(sum(field) for field in output),
        "selected_indices": [[m.index + 1 for m in history] for history in (first, second)],
        "literal_bridge_gap_codes": [[list(item) for item in code] for code in codes],
        "hanging_sets": [sorted(h) for h in hanging],
        "original_y0": [decoded_first[3], decoded_second[3]],
        "original_root_sizes": [len(decoded_first[2]), len(decoded_second[2])],
        "joint_root_size": len(core),
        "closed_cross_edge_excluded": True,
        "scope": "exact semantic regression, not a universal proof or percolation counterexample",
    }


def main() -> None:
    certificate = {
        "claim": CLAIM,
        "status": "running",
        "result_kind": "universal_formal_verification",
        "research_target_level": "publishable",
        "math_objective_mode": "exploratory",
        "project_root": str(ROOT),
        "independent_review": "not performed or asserted by this verifier",
        "finite_regressions": [
            example(1, Fraction(1, 4)),
            example(3, Fraction(1, 4)),
            example(3, Fraction(3, 4)),
        ],
    }
    CERTIFICATE.write_text(json.dumps(certificate, indent=2) + "\n")
    command = [
        ARGUS, "-m", "argus_skill.verticals.math.lean_evidence", "verify",
        "--project-root", str(ROOT), "--claim", CLAIM,
        str(HERE / "Main.lean"),
        "--statement-fidelity", str(HERE / "statement_fidelity.md"),
        "--timeout", "240",
    ]
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
    certificate["compiler_command"] = command
    certificate["compiler_process_exit_code"] = result.returncode
    certificate["compiler_stderr"] = result.stderr
    certificate["compiler"] = json.loads(result.stdout)
    certificate["status"] = "compiler_failed"
    CERTIFICATE.write_text(json.dumps(certificate, indent=2) + "\n")
    require(result.returncode == 0, f"official compiler verification failed: {result.stdout} {result.stderr}")
    compiler = certificate["compiler"]
    require(compiler["status"] == "success", "compiler did not report success")
    require(compiler["exit_code"] == 0 and compiler["audit_exit_code"] == 0,
            "compiler or axiom audit did not exit zero")
    require(compiler["proof_holes"] == [], "compiler reported proof holes")
    require("version 4.31.0," in compiler["tools"]["lean"]["version"], "wrong Lean version")
    require(bool(compiler["kernel"]["recorded"]), "no claim-bound mechanical evidence was recorded")
    require(compiler["kernel"]["refusals"] == [], "claim recording was refused")
    certificate["official_checks"] = []
    for module in ("math_state", "proof_graph_check"):
        command = [
            ARGUS, "-m", f"argus_skill.verticals.math.{module}", "check",
            "--project-root", str(ROOT),
        ]
        check = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=False)
        certificate["official_checks"].append({
            "command": command, "exit_code": check.returncode,
            "stdout": check.stdout, "stderr": check.stderr,
        })
        certificate["status"] = "checking"
        CERTIFICATE.write_text(json.dumps(certificate, indent=2) + "\n")
        require(check.returncode == 0, f"campaign-local {module} failed: {check.stdout} {check.stderr}")
    certificate["status"] = "verified_pending_independent_review"
    certificate["completed_at"] = datetime.now(timezone.utc).isoformat()
    certificate["jacobian"] = {
        "operation_id": "graph.decomposition.bridge_block_tree.compute",
        "discovery": "research/joint_switching/jacobian_discovery.json",
        "typed_contract": "research/joint_switching/jacobian_contract.json",
        "exact_payload": "research/joint_switching/jacobian_payload.json",
        "typed_output": "research/joint_switching/jacobian_result.json",
        "adapter_exit_code": 0,
        "error": None,
        "timeout": False,
        "mathematical_scope": "one auxiliary bridge-geometry example only",
    }
    CERTIFICATE.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps({
        "status": certificate["status"], "claim": CLAIM,
        "lean_exit_code": compiler["exit_code"], "proof_holes": compiler["proof_holes"],
        "finite_regressions": len(certificate["finite_regressions"]),
        "project_root": str(ROOT),
        "official_check_exit_codes": [check["exit_code"] for check in certificate["official_checks"]],
        "certificate": str(CERTIFICATE.relative_to(ROOT)),
    }))


if __name__ == "__main__":
    main()
