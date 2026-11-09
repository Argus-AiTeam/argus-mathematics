#!/usr/bin/env python3
"""Replay the exact examples and the source-bound Lean evidence.

Use --compile for a fresh official Lean run. The arbitrary-H band construction
is a prose proof in theorem.md, not a conclusion of this executable.
"""

from __future__ import annotations

import argparse
from collections import deque
from dataclasses import dataclass
from hashlib import sha256
from itertools import permutations, product
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
ARGUS_PYTHON = "$WORKSPACE/argus-live-update/.venv/bin/python"
OPERATION = "combinatorial_map.faces.compute"
IDENTITY = (0, 1, 2)
Perm = tuple[int, int, int]
FreeWord = tuple[int, ...]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def mul(a: Perm, b: Perm) -> Perm:
    return tuple(a[b[i]] for i in range(3))


def inv(a: Perm) -> Perm:
    return tuple(a.index(i) for i in range(3))


def reduce_word(word: FreeWord) -> FreeWord:
    stack: list[int] = []
    for letter in word:
        require(letter != 0, "Zero is not a signed free generator.")
        if stack and stack[-1] == -letter:
            stack.pop()
        else:
            stack.append(letter)
    return tuple(stack)


def inverse_word(word: FreeWord) -> FreeWord:
    return tuple(-letter for letter in reversed(word))


def substitute(word: FreeWord, generator: int, value: FreeWord) -> FreeWord:
    pieces: list[int] = []
    for letter in word:
        if abs(letter) == generator:
            pieces.extend(value if letter > 0 else inverse_word(value))
        else:
            pieces.append(letter)
    return reduce_word(tuple(pieces))


@dataclass(frozen=True)
class CyclicWord:
    letters: FreeWord
    gaps: tuple[Perm, ...]

    def __post_init__(self) -> None:
        require(bool(self.letters), "A cyclic word needs an exterior occurrence.")
        require(len(self.letters) == len(self.gaps), "Missing cyclic gap.")

    def inverse(self) -> CyclicWord:
        n = len(self.letters)
        return CyclicWord(
            inverse_word(self.letters),
            tuple(inv(self.gaps[(n - 2 - k) % n]) for k in range(n)),
        )


def plain(word: FreeWord) -> CyclicWord:
    return CyclicWord(word, (IDENTITY,) * len(word))


def cyclically_reduced(word: CyclicWord) -> bool:
    n = len(word.letters)
    return all(
        word.letters[i] != -word.letters[(i + 1) % n]
        or word.gaps[i] != IDENTITY
        for i in range(n)
    )


def check_relators(relators: list[CyclicWord], minimum: int) -> None:
    for r in relators:
        require(len(r.letters) >= minimum, "Relator is too short.")
        require(all(e > 0 for e in r.letters), "Relator is not positive.")
        require(len(set(r.letters)) == len(r.letters), "Repeated exterior generator.")
        require(r.inverse().inverse() == r, "Incorrect signed gap inversion.")
    for i, r in enumerate(relators):
        for s in relators[i + 1 :]:
            require(len(set(r.letters) & set(s.letters)) <= 1, "Excess overlap.")


def matches(word: CyclicWord, relators: list[CyclicWord]) -> list[tuple[int, ...]]:
    found = []
    for rid, relator in enumerate(relators):
        for sign, oriented in ((1, relator), (-1, relator.inverse())):
            n, m = len(word.letters), len(oriented.letters)
            for start in range(n):
                for rstart in range(m):
                    for length in range(1, min(n, m) + 1):
                        windex, rindex = (start + length - 1) % n, (rstart + length - 1) % m
                        if word.letters[windex] != oriented.letters[rindex]:
                            break
                        if length > 1 and word.gaps[(windex - 1) % n] != oriented.gaps[(rindex - 1) % m]:
                            break
                        found.append((start, length, rid, sign, rstart))
    return found


def full_match(word: CyclicWord, relators: list[CyclicWord]) -> bool:
    n = len(word.letters)
    for start, length, rid, sign, rstart in matches(word, relators):
        r = relators[rid] if sign == 1 else relators[rid].inverse()
        if length == n == len(r.letters):
            if word.gaps[(start + n - 1) % n] == r.gaps[(rstart + n - 1) % n]:
                return True
    return False


def long_pair(word: CyclicWord, relators: list[CyclicWord]) -> list[tuple[int, ...]] | None:
    n = len(word.letters)
    candidates = [
        match for match in matches(word, relators)
        if match[1] >= len(relators[match[2]].letters) - 2
    ]
    for first in candidates:
        used = {(first[0] + i) % n for i in range(first[1])}
        for second in candidates:
            other = {(second[0] + i) % n for i in range(second[1])}
            if used.isdisjoint(other):
                return [first, second]
    return None


def twist(word: CyclicWord, p: dict[int, Perm], q: dict[int, Perm]) -> CyclicWord:
    left = [p[e] if e > 0 else inv(q[-e]) for e in word.letters]
    right = [q[e] if e > 0 else inv(p[-e]) for e in word.letters]
    n = len(word.letters)
    return CyclicWord(
        word.letters,
        tuple(mul(mul(right[i], word.gaps[i]), left[(i + 1) % n]) for i in range(n)),
    )


def evaluate(word: CyclicWord, values: dict[int, Perm]) -> Perm:
    value = IDENTITY
    for letter, gap in zip(word.letters, word.gaps, strict=True):
        image = values[abs(letter)] if letter > 0 else inv(values[-letter])
        value = mul(mul(value, image), gap)
    return value


def face_certificate() -> tuple[dict, dict]:
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    graph = payload["map"]
    darts, rotations = graph["darts"], graph["rotations"]
    count = graph["vertex_count"]
    require(len(rotations) == count, "Wrong number of vertex rotations.")
    require(sorted(d for row in rotations for d in row) == list(range(len(darts))),
            "Rotations do not partition the darts.")
    next_rotation = {}
    for v, row in enumerate(rotations):
        for i, d in enumerate(row):
            require(darts[d][0] == v, "A rotation contains a dart at another vertex.")
            next_rotation[d] = row[(i + 1) % len(row)]
    for d, (tail, head, reverse) in enumerate(darts):
        require(0 <= tail < count and 0 <= head < count, "Invalid dart endpoint.")
        require(0 <= reverse < len(darts) and reverse != d, "Invalid reversal.")
        require(darts[reverse] == [head, tail, d], "Dart reversal is not an involution.")

    # Jacobian uses reversal after rotation, not rotation after reversal.
    successor = [darts[next_rotation[d]][2] for d in range(len(darts))]
    require(sorted(successor) == list(range(len(darts))), "Face successor is not bijective.")
    face_walks, assignment = [], [-1] * len(darts)
    for start in range(len(darts)):
        if assignment[start] != -1:
            continue
        face, d = [], start
        while assignment[d] == -1:
            assignment[d] = len(face_walks)
            face.append(d)
            d = successor[d]
        require(d == start, "A face orbit did not close at its start.")
        face_walks.append(face)
    require(count - len(darts) // 2 + len(face_walks) == 2, "Not a sphere map.")
    reached, queue = {0}, deque([0])
    while queue:
        v = queue.popleft()
        for d in rotations[v]:
            w = darts[d][1]
            if w not in reached:
                reached.add(w)
                queue.append(w)
    require(len(reached) == count, "The map is disconnected.")
    require(min(map(len, face_walks)) >= 2, "A monogon was overlooked.")

    envelope = json.loads((HERE / "jacobian_result.json").read_text())
    require(envelope["tool"] == "math.run", "Not an executed Jacobian operation.")
    require(envelope["request"]["operation_id"] == OPERATION, "Wrong Jacobian operation.")
    require(envelope["request"]["payload"] == payload, "Jacobian used another payload.")
    require(envelope["result"]["operation_id"] == OPERATION, "Wrong result operation.")
    output = envelope["result"]["output"]
    expected = {"map": graph, "face_walks": face_walks,
                "face_of_dart": assignment, "successor": successor}
    require(output == expected, "Independent face computation disagrees with Jacobian.")
    return graph, {
        "operation_id": OPERATION,
        "protocol_version": envelope["protocol_version"],
        "server_version": envelope["server"]["version"],
        "payload_file": "research/planar-audit/jacobian_payload.json",
        "typed_output_file": "research/planar-audit/jacobian_result.json",
        "adapter_exit_code": 0,
        "timeout": False,
        "structured_error": None,
        "vertices": count,
        "edges": len(darts) // 2,
        "face_walks": face_walks,
        "euler_characteristic": 2,
    }


def cube_threshold(graph: dict) -> dict:
    darts, rotations = graph["darts"], graph["rotations"]
    positive = {1, 3, 6, 8}
    for d in range(0, len(darts), 2):
        v, w, _ = darts[d]
        if v and w:
            require((v in positive) != (w in positive), "The inner graph is not bipartite.")
    raw = {}
    for v in range(1, 9):
        row = tuple(d // 2 + 1 for d in rotations[v])
        raw[v] = row if v in positive else row[::-1]
    relators = [plain(raw[v]) for v in range(1, 9)]
    check_relators(relators, 3)
    require(sorted(len(r.letters) for r in relators) == [3] * 7 + [4],
            "The degree-three threshold witness has wrong degrees.")
    leaf_generator = rotations[0][0] // 2 + 1

    parent, parent_edge, order = {1: 0}, {}, [1]
    queue = deque([1])
    while queue:
        v = queue.popleft()
        for d in sorted(rotations[v], key=lambda index: darts[index][1]):
            w = darts[d][1]
            if w and w not in parent:
                parent[w] = v
                parent_edge[w] = d // 2 + 1
                order.append(w)
                queue.append(w)
    require(len(parent) == 8, "Missing cube spanning-tree vertex.")
    remaining = dict(raw)
    steps = []
    for v in reversed(order[1:]):
        relation, generator = remaining[v], parent_edge[v]
        positions = [i for i, letter in enumerate(relation) if abs(letter) == generator]
        require(len(positions) == 1, "Tree generator must occur exactly once.")
        i = positions[0]
        before, after = relation[:i], relation[i + 1 :]
        value = (inverse_word(before) + inverse_word(after)
                 if relation[i] > 0 else after + before)
        value = reduce_word(value)
        require(abs(generator) not in map(abs, value), "Circular generator elimination.")
        require(substitute(relation, generator, value) == (), "Invalid Tietze elimination.")
        steps.append({"vertex": v, "generator": generator,
                      "relation": relation, "replacement": value})
        del remaining[v]
        remaining = {w: substitute(r, generator, value) for w, r in remaining.items()}
    require(remaining == {1: (leaf_generator,)}, "The leaf generator was not killed.")
    word = plain((leaf_generator,))
    require(cyclically_reduced(word), "The one-letter boundary is not reduced.")
    require(not full_match(word, relators), "Unexpected full match.")
    require(long_pair(word, relators) is None, "A one-position word has disjoint intervals.")
    coefficient_exteriors = [
        plain(tuple(e for e in r.letters if e != leaf_generator)) for r in relators
    ]
    check_relators(coefficient_exteriors, 3)
    require(all(len(r.letters) == 3 for r in coefficient_exteriors),
            "The coefficient reinterpretation must have exterior degree three.")
    return {
        "scope": "Counterexample only to relaxing the minimum relator length to three.",
        "refutes_manuscript": False,
        "coefficient_group": "trivial; hence H->D is injective",
        "positive_relators": [r.letters for r in relators],
        "boundary_word": word.letters,
        "eliminations": steps,
        "remaining_relation": remaining[1],
        "full_match": False,
        "two_nonempty_exterior_disjoint_matches": False,
        "coefficient_reinterpretation": {
            "coefficient_group": "infinite cyclic, generated by h",
            "h_free_generator": leaf_generator,
            "all_exterior_degrees": [3] * 8,
            "remaining_relation_h": remaining[1],
            "h_is_nontrivial_in_coefficient_group": True,
            "H_to_D_injective": False,
            "scope": "Sharpness of automatic injectivity at degree four, not a manuscript counterexample.",
        },
    }


def square_sharpness() -> list[dict]:
    group = list(permutations(range(3)))
    output = []
    for m in range(4, 13):
        blocks = [tuple(range(5 + i * (m - 2), 5 + (i + 1) * (m - 2)))
                  for i in range(4)]
        a, b, c, d = blocks
        relators = [plain((4, 1) + a), plain((2, 1) + b),
                    plain((2, 3) + c), plain((4, 3) + d)]
        word = plain(inverse_word(a) + b + inverse_word(c) + d)
        check_relators(relators, 4)
        require(cyclically_reduced(word), "The sharp square boundary is not reduced.")
        derived = (4, 1, -1, -2, 2, 3, -3, -4)
        require(reduce_word(derived) == (), "The square quotient equality failed.")
        require(not full_match(word, relators), "The sharp square has a full match.")
        found = matches(word, relators)
        maxima = [max(match[1] for match in found if match[2] == i) for i in range(4)]
        require(maxima == [m - 2] * 4, "The loss-two bound was not sharp.")
        pair = long_pair(word, relators)
        require(pair is not None, "The sharp example violates the proved dichotomy.")
        generators = sorted(set(e for r in relators for e in r.letters))
        p = {g: group[g % 6] for g in generators}
        q = {g: group[(2 * g + 1) % 6] for g in generators}
        twisted_r = [twist(r, p, q) for r in relators]
        twisted_w = twist(word, p, q)
        require(cyclically_reduced(twisted_w), "Twisting broke cyclic H-reduction.")
        require(matches(twisted_w, twisted_r) == found, "Twisting changed coefficient matches.")
        values = {g: mul(inv(p[g]), inv(q[g])) for g in generators}
        require(all(evaluate(r, values) == IDENTITY for r in twisted_r),
                "The explicit coefficient-group retraction failed.")
        require(evaluate(twisted_w, values) == IDENTITY, "Twisted null boundary evaluation failed.")
        output.append({"m": m, "boundary_length": len(word.letters),
                       "maximum_match_lengths": maxima, "disjoint_long_pair": pair,
                       "nonabelian_twist_preserves_every_match": True,
                       "coefficient_group_retraction": True})
    return output


def nonabelian_checks() -> dict:
    group = list(permutations(range(3)))
    for p, q, h, k in product(group, repeat=4):
        require((mul(mul(p, h), q) == mul(mul(p, k), q)) == (h == k),
                "A sandwich coefficient equality failed.")
    for p, h in product(group, repeat=2):
        require((mul(mul(p, h), inv(p)) == IDENTITY) == (h == IDENTITY),
                "Conjugation did not preserve the identity gap.")
    a, conjugator = (1, 0, 2), (1, 2, 0)
    conjugate = mul(mul(conjugator, a), inv(conjugator))
    require(a != conjugate, "The conjugacy trap accidentally has equal elements.")
    require(mul(a, inv(conjugate)) != IDENTITY, "Mere conjugacy passed a bigon equation.")
    return {"group": "S3", "sandwich_tests": 6 ** 4, "identity_gap_tests": 6 ** 2,
            "distinct_conjugate_elements": [a, conjugate],
            "mere_conjugacy_rejected_by_exact_face_equation": True}


def convention_checks() -> dict:
    relator = plain(tuple(range(1, 8)))
    changed_closing = CyclicWord(relator.letters, (IDENTITY,) * 6 + ((1, 0, 2),))
    require(not full_match(changed_closing, [relator]), "Full match ignored its closing gap.")
    require((0, 7, 0, 1, 0) in matches(changed_closing, [relator]),
            "An interval incorrectly checked its closing gap.")
    doubled = plain(relator.letters * 2)
    require(max(m[1] for m in matches(doubled, [relator])) == 7,
            "An interval reused a relator position.")
    require(not full_match(doubled, [relator]) and long_pair(doubled, [relator]) is not None,
            "The two-copy null word was classified incorrectly.")
    p, q = {1: (1, 2, 0)}, {1: (1, 0, 2)}
    for first, last in product((IDENTITY, (1, 0, 2)), repeat=2):
        word = CyclicWord((1, -1), (first, last))
        require(cyclically_reduced(word) == cyclically_reduced(twist(word, p, q)),
                "Twisting changed identity-gap cyclic reduction.")
        require(twist(word.inverse(), p, q) == twist(word, p, q).inverse(),
                "Signed inverse gap orientation is wrong.")
    return {"full_match_checks_closing_gap": True,
            "interval_omits_closing_gap": True,
            "relator_position_reuse_rejected": True,
            "two_copy_null_word": True,
            "twisting_preserves_signed_inverse_and_cyclic_reduction": True}


def official_checks() -> dict[str, int]:
    statuses = {}
    failures = []
    for module in ("math_state", "proof_graph_check"):
        run = subprocess.run(
            [ARGUS_PYTHON, "-m", f"argus_skill.verticals.math.{module}",
             "check", "--project-root", str(ROOT)],
            cwd=ROOT, capture_output=True, text=True, check=False,
        )
        statuses[module] = run.returncode
        if run.returncode:
            failures.append(f"{module} failed at {ROOT}:\n{run.stdout}\n{run.stderr}")
    if failures:
        raise RuntimeError("\n".join(failures))
    return statuses


def compile_source() -> None:
    run = subprocess.run(
        [ARGUS_PYTHON, "-m", "argus_skill.verticals.math.lean_evidence",
         "verify", str(HERE / "Main.lean"), "--statement-fidelity",
         str(HERE / "statement_fidelity.md"), "--claim", "C_PLANAR_KERNEL",
         "--project-root", str(ROOT), "--artifact-dir", str(HERE / "lean-evidence"),
         "--timeout", "90"],
        cwd=ROOT, capture_output=True, text=True, check=False,
    )
    checks = official_checks()
    print(json.dumps({"project_root": str(ROOT), "official_checks": checks}))
    require(run.returncode == 0, f"Real Lean verification failed:\n{run.stdout}\n{run.stderr}")
    result = json.loads(run.stdout)
    (HERE / "compiler_result.json").write_text(json.dumps(result, indent=2) + "\n")


def mechanical_certificate() -> dict:
    result = json.loads((HERE / "compiler_result.json").read_text())
    require(result["status"] == "success" and result["exit_code"] == 0,
            "No successful real Lean run.")
    require(result["proof_holes"] == [] and not result["environment_failure"],
            "The compiler evidence has holes or an environment failure.")
    require("4.31.0" in result["tools"]["lean"]["version"], "Wrong Lean version.")
    for source, key in (("Main.lean", "source_sha256"),
                        ("statement_fidelity.md", "statement_fidelity_sha256")):
        require(sha256((HERE / source).read_bytes()).hexdigest() == result[key],
                f"The compiler evidence is stale for {source}.")
    record = result["kernel"]["recorded"]
    require(record["tier"] == "mechanical" and record["verdict"] == "supports",
            "The official compiler result did not record supporting mechanical evidence.")
    require(record["subject"]["subject_id"] == "C_PLANAR_KERNEL", "Wrong claim binding.")
    archived = json.loads((ROOT / record["artifact"]).read_text())
    require(archived["lean_check"]["exit_code"] == 0
            and archived["lean_check"]["proof_holes"] == [], "Invalid archived compiler result.")
    require(archived["lean_source"]["text"] == (HERE / "Main.lean").read_text(),
            "The archived source differs from the working source.")
    require(archived["statement_fidelity"]["text"] == (HERE / "statement_fidelity.md").read_text(),
            "The archived statement reading differs from the working reading.")
    ledger = json.loads((ROOT / "research/MATH_STATE.json").read_text())
    current = max((c for c in ledger["claims"] if c["claim_id"] == "C_PLANAR_KERNEL"),
                  key=lambda c: c["version"])
    require(current["content_hash"] == record["subject"]["content_hash"],
            "The compiler evidence belongs to a superseded claim.")
    require(current["formal_statement"] == (HERE / "Main.lean").read_text(),
            "The ledger formal statement differs from the source.")
    return {"claim": "C_PLANAR_KERNEL", "lean_version": "4.31.0", "exit_code": 0,
            "proof_holes": [],
            "compiler_result": "research/planar-audit/compiler_result.json",
            "source_and_fidelity_current": True}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compile", action="store_true", help="Run the real official Lean verifier.")
    parser.add_argument("--write-certificate", action="store_true",
                        help="Write the deterministic mathematical replay result.")
    args = parser.parse_args()
    if args.compile:
        compile_source()
    graph, jacobian = face_certificate()
    result = {
        "statement": "For m>=4 the coefficient group embeds automatically and the full coefficient-sensitive lemma holds with loss two.",
        "proof": "research/planar-audit/theorem.md",
        "proof_kind": "Universal prose proof with a kernel-checked finite extraction core.",
        "not_claimed": ["Kernel verification of the arbitrary-H band bridge",
                        "A counterexample to the manuscript",
                        "Verification of the main cost theorem",
                        "Verified novelty or independent Reviewer acceptance"],
        "formal_core": mechanical_certificate(),
        "automatic_embedding": "The prose band argument uses the kernel-checked no_closed_component obstruction.",
        "jacobian": jacobian,
        "optimal_length_examples": square_sharpness(),
        "optimal_degree_example": cube_threshold(graph),
        "nonabelian_coefficient_checks": nonabelian_checks(),
        "convention_checks": convention_checks(),
    }
    result = json.loads(json.dumps(result))
    certificate = HERE / "exact_certificate.json"
    if args.write_certificate:
        certificate.write_text(json.dumps(result, indent=2) + "\n")
    else:
        require(json.loads(certificate.read_text()) == result,
                "The exact certificate does not match the independent replay.")
    print(json.dumps({"exact_certificate": "pass", "formal_core": "pass",
                      "square_examples": len(result["optimal_length_examples"]),
                      "cube_eliminations": len(result["optimal_degree_example"]["eliminations"]),
                      "project_root": str(ROOT),
                      "scope": "Complete prose theorem; formal core and exact examples checked."}))


if __name__ == "__main__":
    main()
