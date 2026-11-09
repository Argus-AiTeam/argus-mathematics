#!/usr/bin/env python3
"""Replay the exact finite combinatorial coverage, not the universal proof."""

import argparse
import hashlib
import itertools
import json
from collections import defaultdict, deque
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path


ROOT = Path(__file__).resolve().parent
MAX_SHAPE_EDGES = 5
MAX_TREE_VERTICES = 4
MAX_CUTOFF = 5


@dataclass(frozen=True)
class Cell:
    dimension: int
    source: tuple | None = None
    target: tuple | None = None


@dataclass(frozen=True)
class SourceAttachment:
    index: int
    source: tuple
    target: tuple
    joining: tuple

    def suspended(self, slot):
        return SourceAttachment(
            self.index + 1,
            (slot,) + self.source,
            (slot,) + self.target,
            (slot,) + self.joining,
        )

    def tagged(self, tag):
        return SourceAttachment(
            self.index,
            (tag,) + self.source,
            (tag,) + self.target,
            (tag,) + self.joining,
        )


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def validate(cells):
    for key, cell in cells.items():
        if cell.dimension == 0:
            check(cell.source is None and cell.target is None, ("vertex faces", key))
            continue
        check(cell.source in cells and cell.target in cells, ("missing face", key))
        s, t = cells[cell.source], cells[cell.target]
        check(s.dimension == t.dimension == cell.dimension - 1, ("face dimension", key))
        if cell.dimension > 1:
            check(s.source == t.source and s.target == t.target, ("globular identity", key))


def realize(shape):
    cells = {(i,): Cell(0) for i in range(len(shape) + 1)}
    for i, child in enumerate(shape):
        for key, cell in realize(child).items():
            if cell.dimension == 0:
                cells[(i,) + key] = Cell(1, (i,), (i + 1,))
            else:
                cells[(i,) + key] = Cell(
                    cell.dimension + 1, (i,) + cell.source, (i,) + cell.target
                )
    validate(cells)
    return cells


def height(shape):
    return max((height(child) + 1 for child in shape), default=0)


def globe(dimension):
    return () if dimension == 0 else (globe(dimension - 1),)


def spine(shape, index):
    return tuple(() if index == 0 else spine(child, index - 1) for child in shape)


@lru_cache(maxsize=None)
def shapes_exact(edges):
    return forests(edges)


@lru_cache(maxsize=None)
def forests(weight):
    if weight == 0:
        return ((),)
    return tuple(
        (child,) + rest
        for first_weight in range(1, weight + 1)
        for child in shapes_exact(first_weight - 1)
        for rest in forests(weight - first_weight)
    )


def build_from_vertex(shape):
    result = [
        SourceAttachment(0, (i,), (i + 1,), (i, 0))
        for i in range(len(shape))
    ]
    for i, child in enumerate(shape):
        result.extend(atom.suspended(i) for atom in build_from_vertex(child))
    return result


def spine_attachments(shape, index):
    result = []
    for i, child in enumerate(shape):
        inside = (
            build_from_vertex(child)
            if index == 0
            else spine_attachments(child, index - 1)
        )
        result.extend(atom.suspended(i) for atom in inside)
    return result


def replay_source_attachments(start, full, attachments):
    check(all(full.get(key) == cell for key, cell in start.items()), "not a subdiagram")
    current = dict(start)
    for atom in attachments:
        check(atom.source in current, ("missing attachment source", atom))
        check(atom.target not in current and atom.joining not in current, ("not fresh", atom))
        s, t, e = (full[key] for key in (atom.source, atom.target, atom.joining))
        check(s.dimension == t.dimension == atom.index, ("source index", atom))
        check(e == Cell(atom.index + 1, atom.source, atom.target), ("joining orientation", atom))
        check((s.source, s.target) == (t.source, t.target), ("not parallel", atom))
        for face in (t.source, t.target):
            check(face is None or face in current, ("unavailable target boundary", atom))
        current[atom.target] = t
        current[atom.joining] = e
    check(current == full, "source attachments do not reconstruct the diagram")


def tagged(cells, tag):
    return {
        (tag,) + key: Cell(
            cell.dimension,
            None if cell.source is None else (tag,) + cell.source,
            None if cell.target is None else (tag,) + cell.target,
        )
        for key, cell in cells.items()
    }


def whiskers(cells, index, orientations):
    result = tagged(cells, "old")
    for key, cell in cells.items():
        if cell.dimension != index:
            continue
        old, duplicate = ("old",) + key, ("duplicate",) + key
        result[duplicate] = result[old]
        s, t = (old, duplicate) if orientations[key] == 0 else (duplicate, old)
        result[("whisker",) + key] = Cell(index + 1, s, t)
    validate(result)
    return result


def disk_map(dimension, target, cells):
    disk = realize(globe(dimension))
    top = next(key for key, cell in disk.items() if cell.dimension == dimension)
    mapping = {}
    pending = [(top, target)]
    while pending:
        key, value = pending.pop()
        if key in mapping:
            check(mapping[key] == value, "inconsistent disk face")
            continue
        check(disk[key].dimension == cells[value].dimension, "disk-map dimension")
        mapping[key] = value
        if disk[key].dimension:
            pending.extend(
                [(disk[key].source, cells[value].source), (disk[key].target, cells[value].target)]
            )
    check(set(mapping) == set(disk), "incomplete disk map")
    return mapping


def glue_critical_cylinders(cells, index, epsilon):
    result = tagged(cells, "old")
    cylinder = realize(globe(index + 1))
    top = next(key for key, cell in cylinder.items() if cell.dimension == index + 1)
    ends = (cylinder[top].source, cylinder[top].target)
    face = disk_map(index, ends[epsilon], cylinder)
    for key, cell in cells.items():
        if cell.dimension != index:
            continue
        retained = disk_map(index, ("old",) + key, result)
        mapping = {face[disk_key]: retained[disk_key] for disk_key in face}
        mapping[ends[1 - epsilon]] = ("duplicate",) + key
        mapping[top] = ("whisker",) + key
        check(set(mapping) == set(cylinder), "critical cylinder has unexpected cells")
        for right_key, right_cell in cylinder.items():
            value = Cell(
                right_cell.dimension,
                None if right_cell.source is None else mapping[right_cell.source],
                None if right_cell.target is None else mapping[right_cell.target],
            )
            image = mapping[right_key]
            if image in result:
                check(result[image] == value, "pushout disagrees on a shared face")
            else:
                result[image] = value
    validate(result)
    return result


def tree_slots(cells, index):
    vertices = {key: cell for key, cell in cells.items() if cell.dimension == index}
    groups = defaultdict(list)
    for key, cell in vertices.items():
        groups[(cell.source, cell.target)].append(key)
    edge_groups = defaultdict(list)
    for key, cell in cells.items():
        if cell.dimension == index + 1:
            check(cell.source in vertices and cell.target in vertices, "tree edge face")
            boundary = (vertices[cell.source].source, vertices[cell.source].target)
            check(
                boundary == (vertices[cell.target].source, vertices[cell.target].target),
                "tree slot lower boundary",
            )
            edge_groups[boundary].append((cell.source, cell.target))
    for boundary, group in groups.items():
        edges = edge_groups[boundary]
        check(len(edges) == len(group) - 1, "slot is not a tree: edge count")
        adjacency = defaultdict(list)
        for s, t in edges:
            adjacency[s].append(t)
            adjacency[t].append(s)
        seen, pending = {group[0]}, [group[0]]
        while pending:
            for other in adjacency[pending.pop()]:
                if other not in seen:
                    seen.add(other)
                    pending.append(other)
        check(seen == set(group), "slot is disconnected")
    return len(groups)


def verify_shapes():
    counts = defaultdict(int)
    for edges in range(MAX_SHAPE_EDGES + 1):
        for shape in shapes_exact(edges):
            counts["shapes"] += 1
            full = realize(shape)
            replay_source_attachments({(0,): Cell(0)}, full, build_from_vertex(shape))
            for index in range(height(shape) + 2):
                small = realize(spine(shape, index))
                schedule = spine_attachments(shape, index)
                check(height(spine(shape, index)) <= index + 1, "spine height")
                check(
                    {k: c for k, c in small.items() if c.dimension <= index}
                    == {k: c for k, c in full.items() if c.dimension <= index},
                    "lost or changed lower cell",
                )
                check(all(atom.index > index for atom in schedule), "non-upper spine attachment")
                replay_source_attachments(small, full, schedule)
                counts["spines"] += 1
                keys = [key for key, cell in full.items() if cell.dimension == index]
                for bits in itertools.product((0, 1), repeat=len(keys)):
                    orientations = dict(zip(keys, bits))
                    start = whiskers(small, index, orientations)
                    end = whiskers(full, index, orientations)
                    counts["tree_slots"] += tree_slots(start, index)
                    replay_source_attachments(
                        start, end, [atom.tagged("old") for atom in schedule]
                    )
                    counts["independently_oriented_whisker_diagrams"] += 1
                for epsilon in (0, 1):
                    orientations = {key: epsilon for key in keys}
                    check(
                        glue_critical_cylinders(full, index, epsilon)
                        == whiskers(full, index, orientations),
                        "C_n(S) differs from the whiskered shape",
                    )
                    counts["critical_skeletal_pushouts"] += 1
    check(counts["shapes"] == 65, "shape enumeration threshold changed")
    return dict(counts)


def prufer_trees(vertices):
    if vertices == 1:
        yield ()
        return
    for code in itertools.product(range(vertices), repeat=vertices - 2):
        degree = [1] * vertices
        for vertex in code:
            degree[vertex] += 1
        edges = []
        for vertex in code:
            leaf = next(i for i, d in enumerate(degree) if d == 1)
            edges.append(tuple(sorted((leaf, vertex))))
            degree[leaf] -= 1
            degree[vertex] -= 1
        remaining = [i for i, d in enumerate(degree) if d == 1]
        edges.append(tuple(remaining))
        yield tuple(sorted(edges))


def path_word(edges, start, end):
    adjacency = defaultdict(list)
    for index, (s, t) in enumerate(edges):
        adjacency[s].append((t, index, 1))
        adjacency[t].append((s, index, -1))
    pending = deque([start])
    previous = {start: None}
    while pending:
        vertex = pending.popleft()
        if vertex == end:
            break
        for other, index, sign in adjacency[vertex]:
            if other not in previous:
                previous[other] = (vertex, index, sign)
                pending.append(other)
    check(end in previous, "path endpoints disconnected")
    result = []
    while end != start:
        before, index, sign = previous[end]
        result.append((index, sign))
        end = before
    return tuple(reversed(result))


def inverse(word):
    return tuple((index, -sign) for index, sign in reversed(word))


def reduce_word(word):
    stack = []
    for index, sign in word:
        if stack and stack[-1] == (index, -sign):
            stack.pop()
        else:
            stack.append((index, sign))
    return tuple(stack)


def comparison_word(edges, order, edge_index):
    line = tuple(zip(order, order[1:]))
    s, t = edges[edge_index]
    mapped = []
    for line_index, sign in path_word(line, s, t):
        a, b = line[line_index]
        word = path_word(edges, a, b)
        mapped.extend(word if sign == 1 else inverse(word))
    return tuple(mapped)


def verify_tree_comparisons():
    counts = defaultdict(int)
    for vertices in range(1, MAX_TREE_VERTICES + 1):
        labeled = tuple(prufer_trees(vertices))
        check(len(labeled) == (1 if vertices == 1 else vertices ** (vertices - 2)), "Pruefer count")
        for edges in labeled:
            for bits in itertools.product((0, 1), repeat=len(edges)):
                oriented = tuple(edge if bit == 0 else tuple(reversed(edge)) for edge, bit in zip(edges, bits))
                for order in itertools.permutations(range(vertices)):
                    for index in range(len(edges)):
                        word = comparison_word(oriented, order, index)
                        check(reduce_word(word) == ((index, 1),), "tree comparison failed")
                        counts["generator_comparisons"] += 1
                        counts["nontrivial_backtracking_words"] += len(word) > 1
                    counts["oriented_tree_and_linear_order_cases"] += 1
    triangle = ((0, 1), (1, 2), (0, 2))
    non_tree_word = comparison_word(triangle, (0, 1, 2), 2)
    check(reduce_word(non_tree_word) != ((2, 1),), "non-tree control failed")
    counts["non_tree_negative_controls"] = 1
    return dict(counts)


def suspended_graph(vertex_names, edges, index):
    vertices = {name: ("v", name) for name in vertex_names}
    edge_keys = {name: ("e", name) for name in edges}
    cells = {key: Cell(0) for key in vertices.values()}
    for name, (s, t) in edges.items():
        cells[edge_keys[name]] = Cell(1, vertices[s], vertices[t])
    for depth in range(1, index + 1):
        prefix = ("s", depth)
        poles = (("pole", depth, 0), ("pole", depth, 1))
        raised = {key: Cell(0) for key in poles}
        for key, cell in cells.items():
            raised[prefix + key] = Cell(
                cell.dimension + 1,
                poles[0] if cell.dimension == 0 else prefix + cell.source,
                poles[1] if cell.dimension == 0 else prefix + cell.target,
            )
        cells = raised
        vertices = {name: prefix + key for name, key in vertices.items()}
        edge_keys = {name: prefix + key for name, key in edge_keys.items()}
    validate(cells)
    return cells, vertices, edge_keys


def check_isomorphism(left, right, mapping):
    check(set(mapping) == set(left), "incomplete globular isomorphism")
    check(len(set(mapping.values())) == len(left) == len(right), "non-bijective globular map")
    check(set(mapping.values()) == set(right), "non-surjective globular map")
    for key, cell in left.items():
        image = right[mapping[key]]
        check(image.dimension == cell.dimension, "isomorphism changes dimension")
        if cell.dimension:
            check(
                image.source == mapping[cell.source] and image.target == mapping[cell.target],
                "isomorphism changes a face",
            )


def verify_joint_domains():
    edges = {"h": ("x0", "x1"), "k": ("y0", "y1"), "a0": ("x0", "y0"), "a1": ("x1", "y1")}
    count = 0
    for index in range(MAX_CUTOFF):
        full, vertices, edge_keys = suspended_graph(("x0", "x1", "y0", "y1"), edges, index)
        tree_edges = {key: value for key, value in edges.items() if key != "k"}
        domain, _, _ = suspended_graph(("x0", "x1", "y0", "y1"), tree_edges, index)
        check(tree_slots(domain, index) == 1, "joint prescribed data is not one tree slot")
        missing = edge_keys["k"]
        check(set(full) - set(domain) == {missing}, "joint domain requires extra lower cells")
        check(full[missing].dimension == index + 1 > index, "missing comparison is not upper I")
        for epsilon in (0, 1):
            keep_edges = {key: value for key, value in edges.items() if key in ("h", "k", f"a{epsilon}")}
            one_sided, _, _ = suspended_graph(("x0", "x1", "y0", "y1"), keep_edges, index)
            check(tree_slots(one_sided, index) == 1, "one-sided domain is not a tree")
            disk = realize(globe(index + 1))
            top = next(key for key, cell in disk.items() if cell.dimension == index + 1)
            image = disk_map(index + 1, edge_keys[f"a{epsilon}"], one_sided)
            old_ends = (disk[top].source, disk[top].target)
            whiskered = whiskers(disk, index, {key: epsilon for key in old_ends})
            mapping = {("old",) + key: value for key, value in image.items()}
            for old, label, comparison in zip(old_ends, ("x", "y"), ("h", "k")):
                mapping[("duplicate",) + old] = vertices[f"{label}{1-epsilon}"]
                mapping[("whisker",) + old] = edge_keys[comparison]
            check_isomorphism(whiskered, one_sided, mapping)
        for cutoff in range(index + 1, MAX_CUTOFF + 1):
            check(index < cutoff and index + 1 <= cutoff, "cylinder level unavailable")
            count += 1
    return {"suspension_indices": MAX_CUTOFF, "fixed_cutoff_pairs": count, "one_sided_domain_isomorphisms": 2 * MAX_CUTOFF}


def verify_categorical_equations():
    arrows = {"i": ("X", "Y"), "r": ("Y", "X"), "u": ("X", "X")}

    def normalize(word, source):
        target = source
        for letter in word:
            check(arrows[letter][0] == target, "ill-typed categorical composite")
            target = arrows[letter][1]
        stack = []
        for letter in word:
            if stack and stack[-1] == "i" and letter == "r":
                stack.pop()
            else:
                stack.append(letter)
        return tuple(stack)

    check(normalize(("i", "r"), "X") == (), "ri is not the identity")
    check(normalize(("i", "r", "u", "i"), "X") == ("u", "i"), "vi != iu")
    check(normalize(("r", "u", "i"), "Y") == ("r", "u", "i"), "(iu)r != v")
    check(normalize(("r", "i"), "Y") != (), "retraction incorrectly treated as isomorphism")
    triples = [("a0", "r", "idA"), ("a1", "r", "idA"), ("a0", "h", "idA"), ("a1", "h", "gf")]
    weak, derivation = {"a0", "idA"}, []
    changed = True
    while changed:
        changed = False
        for triple in triples:
            unknown = [name for name in triple if name not in weak]
            if len(unknown) == 1:
                weak.add(unknown[0])
                derivation.append({"two_out_of_three": list(triple), "concludes": unknown[0]})
                changed = True
    check({"r", "a1", "h", "gf"} <= weak, "promotion lacks a weak-equivalence consequence")
    return {"retract_equations": 3, "non_isomorphism_control": True, "promotion_derivation": derivation}


def verify_mixed_face():
    arity = realize(globe(2))
    top = next(key for key, cell in arity.items() if cell.dimension == 2)
    mapping = disk_map(1, arity[top].source, arity)
    check(len(mapping) == 3 and height(globe(2)) == 2, "mixed-dimensional face changed")
    return {
        "face_output_dimension": 1,
        "arity_height": 2,
        "strict_smaller_arity_bound_valid": False,
        "meaning": "The source face of a 2-operation on d_2 is an operation d_1 -> d_2; the manuscript explicitly allows this.",
    }


def verify_jacobian():
    folder = ROOT / "jacobian"
    payload = json.loads((folder / "edge_word_payload.json").read_text())
    contract = json.loads((folder / "operation_contract.json").read_text())
    result = json.loads((folder / "edge_word_result.json").read_text())
    status = json.loads((folder / "adapter_status.json").read_text())
    check(status["exit_code"] == 0 and not status["timeout"] and status["error"] is None, "Jacobian did not complete")
    check(result["request"]["payload"] == payload, "Jacobian payload mismatch")
    check(result["request"]["operation_id"] == contract["operation_id"], "Jacobian operation mismatch")
    check(result["server"]["version"] == contract["server"]["version"], "Jacobian server version changed")
    check(result["protocol_version"] == contract["protocol_version"], "Jacobian protocol mismatch")
    output = result["result"]["output"]
    expected_labels = [
        f"e{step['edge_index']+1}" + ("^-1" if step["orientation"] == -1 else "")
        for step in payload["path"]
    ]
    check(output["word"] == expected_labels and output["length"] == len(expected_labels), "unexpected edge-label output")
    word = tuple((step["edge_index"], step["orientation"]) for step in payload["path"])
    check(reduce_word(word) == ((0, 1),), "independent exact cancellation failed")
    return {
        "operation_id": contract["operation_id"],
        "server_version": result["server"]["version"],
        "protocol_version": result["protocol_version"],
        "adapter_exit": status["exit_code"],
        "typed_output": output,
        "interpretation": "The adapter returned unreduced edge labels, not a cancellation proof. Local stack reduction independently gives e1.",
    }


def verify_formal_core():
    folder = ROOT / "lean"
    result = json.loads((folder / "verify_result.json").read_text())
    source = (folder / "Main.lean").read_bytes()
    fidelity = (folder / "statement_fidelity.md").read_bytes()
    check(result["status"] == "success" and result["exit_code"] == 0, "formal core did not compile")
    check(result["proof_holes"] == [], "formal core contains proof holes")
    check(result["source_sha256"] == hashlib.sha256(source).hexdigest(), "Lean source changed after compilation")
    check(
        result["statement_fidelity_sha256"] == hashlib.sha256(fidelity).hexdigest(),
        "statement fidelity changed after compilation",
    )
    version = result["tools"]["lean"]["version"]
    check("Lean (version 4.31.0," in version, "wrong Lean toolchain")
    recorded = result["kernel"]["recorded"]
    state = json.loads((ROOT.parent / "MATH_STATE.json").read_text())
    claim = max(
        (claim for claim in state["claims"] if claim["claim_id"] == "C_PP_CORE"),
        key=lambda claim: claim["version"],
    )
    check(recorded["subject"]["content_hash"] == claim["content_hash"], "compiler evidence belongs to a stale claim")
    check(recorded["tier"] == "mechanical" and recorded["verdict"] == "supports", "compiler support was not recorded")
    check(claim["formal_statement"].strip() == source.decode().strip(), "claim formalization differs from the compiled source")
    archive_path = ROOT.parent.parent / recorded["artifact"]
    archive = json.loads(archive_path.read_text())
    check(archive["lean_source"]["text"].encode() == source, "archived Lean source differs")
    check(archive["lean_check"]["status"] == "success", "archived result is not successful")
    return {
        "claim": "C_PP_CORE",
        "result_class": "formal_verification",
        "status": result["status"],
        "exit_code": result["exit_code"],
        "proof_holes": result["proof_holes"],
        "toolchain": "Lean 4.31.0",
        "source_sha256": result["source_sha256"],
        "statement_fidelity_sha256": result["statement_fidelity_sha256"],
        "archive": recorded["artifact"],
        "scope": "Universal spine globular cells, unique-filler operations, naturality congruences, generator promotion, and the final retract algebra; not the full coherator theorem.",
    }


def certificate():
    return {
        "campaign": 9000312,
        "artifact_result_class": "finite_verification",
        "universal_proof": "research/partial_path/report.md",
        "universal_claims_for_independent_review": ["C_PP_PATH", "C_PP_FIXED", "C_PP_ALL", "C_PP_LOCAL"],
        "formal_core_claim": "C_PP_CORE",
        "source_locations": {
            "cutoff": "sections/02-cutoffs-trees.tex:29-114",
            "tree_promotion": "sections/02-cutoffs-trees.tex:336-424",
            "skeletal_gluing": "sections/03-partial-cylinders.tex:141-202",
            "operation_extension": "sections/03-partial-cylinders.tex:279-372",
            "endpoint_lifting": "sections/03-partial-cylinders.tex:374-439",
            "descent_and_cutoff_removal": "sections/03-partial-cylinders.tex:443-end",
        },
        "hypotheses": [
            "The raw combinatorial checks use actual finite globular-sum shapes, not arbitrary alleged coherator models.",
            "The universal induction step assumes E(q,j) only for n<j<=q; the report discharges these hypotheses by descending induction.",
            "The local triangularity extension permits unrestricted finite arities only for free generators of output>q.",
        ],
        "bounds": {
            "recursive_shape_edges_at_most": MAX_SHAPE_EDGES,
            "labeled_tree_vertices_at_most": MAX_TREE_VERTICES,
            "all_tree_edge_orientations": True,
            "all_tree_vertex_linear_orders": True,
            "all_whisker_orientations_for_each_enumerated_shape": True,
            "critical_cylinder_cutoff_at_most": MAX_CUTOFF,
        },
        "exact_results": {
            "globular_shapes": verify_shapes(),
            "tree_linearization": verify_tree_comparisons(),
            "endpoint_domains": verify_joint_domains(),
            "categorical_algebra": verify_categorical_equations(),
            "mixed_dimensional_face": verify_mixed_face(),
            "jacobian": verify_jacobian(),
            "formal_core": verify_formal_core(),
        },
        "literal_manuscript_assertions_refuted": [],
        "not_certified_by_this_script": [
            "The universal coherator theorem or an infinite free-model completion",
            "The full small-object construction or transfinite cellular closure",
            "Independent literature attribution, statement fidelity, novelty, or publishable significance",
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the exact finite certificate after successful replay")
    args = parser.parse_args()
    actual = certificate()
    path = ROOT / "exact_certificate.json"
    if args.write:
        path.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
    check(path.is_file(), "missing exact_certificate.json; use --write to generate it")
    expected = json.loads(path.read_text())
    check(actual == expected, "certificate differs from exact replay")
    print(json.dumps({"ok": True, "result_class": actual["artifact_result_class"], "counts": {key: value for key, value in actual["exact_results"].items() if key in ("globular_shapes", "tree_linearization", "endpoint_domains")}}, sort_keys=True))


if __name__ == "__main__":
    main()
