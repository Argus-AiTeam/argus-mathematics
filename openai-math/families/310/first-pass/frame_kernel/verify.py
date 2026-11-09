#!/usr/bin/env python3
"""Replay actual plane presentations and, by default, compile the universal proof."""

import argparse
from fractions import Fraction
from functools import cached_property, lru_cache
from itertools import combinations, permutations, product
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
WORKSPACE = Path("$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0")
LEAN = Path("$WORKSPACE/.elan/bin/lean")
LAKE = Path("$WORKSPACE/.elan/bin/lake")


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rational_rref(rows, columns):
    matrix = [[Fraction(x) for x in row] for row in rows]
    require(all(len(row) == columns for row in matrix), "Ragged rational matrix")
    pivots = []
    for column in range(columns):
        pivot = next(
            (i for i in range(len(pivots), len(matrix)) if matrix[i][column]), None
        )
        if pivot is None:
            continue
        k = len(pivots)
        matrix[k], matrix[pivot] = matrix[pivot], matrix[k]
        divisor = matrix[k][column]
        matrix[k] = [x / divisor for x in matrix[k]]
        for i, row in enumerate(matrix):
            if i != k and row[column]:
                scalar = row[column]
                matrix[i] = [x - scalar * y for x, y in zip(row, matrix[k])]
        pivots.append(column)
    return matrix[:len(pivots)], pivots


class Quotient:
    def __init__(self, words, relations):
        self.words = sorted(words, reverse=True)
        self.index = {word: i for i, word in enumerate(self.words)}
        rows = []
        for relation in sorted(relations):
            row = [0] * len(self.words)
            for word in relation:
                row[self.index[word]] += 1
            rows.append(row)
        self.rows, self.pivots = rational_rref(rows, len(self.words))
        self.free = [i for i in range(len(self.words)) if i not in self.pivots]
        self.basis = [self.words[i] for i in self.free]

    def reduce(self, terms):
        vector = [Fraction(0)] * len(self.words)
        for word, scalar in terms.items():
            vector[self.index[word]] += scalar
        for pivot, row in zip(self.pivots, self.rows):
            if vector[pivot]:
                scalar = vector[pivot]
                vector = [x - scalar * y for x, y in zip(vector, row)]
        return [vector[i] for i in self.free]


class ActualPlaneModel:
    def __init__(self, field, dimension, form, line_type):
        self.field = field
        self.dimension = dimension
        self.form = form
        self.line_type = line_type
        squares = {x * x % field for x in range(1, field)}
        self.lines = []
        for vector in product(range(field), repeat=dimension):
            first = next((x for x in vector if x), None)
            if first != 1:
                continue
            norm = self.dot(vector, vector)
            if form and (not norm or (line_type == "square" and norm not in squares)):
                continue
            self.lines.append(vector)
        self.frames = {(): [()]}
        for size in range(1, dimension + 1):
            for frame in combinations(range(len(self.lines)), size):
                if form and any(
                    self.dot(self.lines[a], self.lines[b])
                    for a, b in combinations(frame, 2)
                ):
                    continue
                support = self.span(self.lines[i] for i in frame)
                if len(support) == size:
                    self.frames.setdefault(support, []).append(frame)
        self.supports = sorted(self.frames, key=lambda x: (len(x), x))
        self.full = self.span(
            tuple(int(i == j) for j in range(dimension)) for i in range(dimension)
        )
        require(self.full in self.frames, "The selected space has no allowed frame")

    def dot(self, a, b):
        return sum(x * y for x, y in zip(a, b)) % self.field

    def span(self, vectors):
        rows = [list(row) for row in vectors]
        rank = 0
        for column in range(self.dimension):
            pivot = next(
                (i for i in range(rank, len(rows)) if rows[i][column]), None
            )
            if pivot is None:
                continue
            rows[rank], rows[pivot] = rows[pivot], rows[rank]
            inverse = pow(rows[rank][column], -1, self.field)
            rows[rank] = [x * inverse % self.field for x in rows[rank]]
            for i, row in enumerate(rows):
                if i != rank and row[column]:
                    scalar = row[column]
                    rows[i] = [
                        (x - scalar * y) % self.field
                        for x, y in zip(row, rows[rank])
                    ]
            rank += 1
        return tuple(tuple(row) for row in rows[:rank])

    @lru_cache(maxsize=None)
    def contained(self, smaller, larger):
        return self.span(smaller + larger) == larger

    @lru_cache(maxsize=None)
    def decomposes(self, a, b, support):
        if len(a) + len(b) != len(support) or self.span(a + b) != support:
            return False
        return not self.form or not any(self.dot(x, y) for x in a for y in b)

    @lru_cache(maxsize=None)
    def decompositions(self, support, left_dimension):
        left = [
            x for x in self.supports
            if len(x) == left_dimension and self.contained(x, support)
        ]
        right = [
            x for x in self.supports
            if len(x) == len(support) - left_dimension and self.contained(x, support)
        ]
        return tuple((a, b) for a in left for b in right if self.decomposes(a, b, support))

    @lru_cache(maxsize=None)
    def ordered_frames(self, support):
        return tuple(sorted(word for frame in self.frames[support] for word in permutations(frame)))

    @lru_cache(maxsize=None)
    def quotient(self, support):
        words = self.ordered_frames(support)
        relations = set()
        for word in words:
            for gap in range(len(word) - 1):
                plane = self.span(self.lines[i] for i in word[gap:gap + 2])
                relations.add(tuple(sorted(
                    word[:gap] + pair + word[gap + 2:]
                    for pair in self.ordered_frames(plane)
                )))
        return Quotient(words, relations)

    @lru_cache(maxsize=None)
    def lie_dimension(self, support):
        if not support:
            return 0
        quotient = self.quotient(support)
        vectors = []
        for frame in self.frames[support]:
            anchor = min(frame)
            for order in permutations(i for i in frame if i != anchor):
                terms = {(anchor,): 1}
                length = 1
                for letter in order:
                    bracket = {}
                    for word, scalar in terms.items():
                        bracket[word + (letter,)] = bracket.get(word + (letter,), 0) + scalar
                        new = (letter,) + word
                        bracket[new] = bracket.get(new, 0) - (-1) ** length * scalar
                    terms = bracket
                    length += 1
                vectors.append(quotient.reduce(terms))
        return len(rational_rref(vectors, len(quotient.basis))[1])

    @lru_cache(maxsize=None)
    def kernel(self, support):
        dimension = len(support)
        domain = []
        if dimension >= 2:
            for prefix, plane in self.decompositions(support, dimension - 2):
                for word in self.quotient(prefix).basis:
                    domain.append((word, prefix, plane))
        domain.sort()
        target = []
        if dimension:
            for prefix, line in self.decompositions(support, dimension - 1):
                letter = self.frames[line][0][0]
                for word in self.quotient(prefix).basis:
                    target.append((letter, prefix, word))
        target.sort()
        target_index = {entry: i for i, entry in enumerate(target)}
        matrix = [[Fraction(0)] * len(domain) for _ in target]
        for column, (word, prefix, plane) in enumerate(domain):
            for first, last in self.ordered_frames(plane):
                merged = self.span(prefix + (self.lines[first],))
                quotient = self.quotient(merged)
                for basis_word, scalar in zip(
                    quotient.basis, quotient.reduce({word + (first,): 1})
                ):
                    matrix[target_index[(last, merged, basis_word)]][column] += scalar
        full_quotient = self.quotient(support)
        d1_columns = [
            full_quotient.reduce({word + (last,): 1}) for last, _, word in target
        ]
        d1 = [
            [column[i] for column in d1_columns]
            for i in range(len(full_quotient.basis))
        ]
        for row in d1:
            for column in range(len(domain)):
                require(
                    sum(x * matrix[i][column] for i, x in enumerate(row)) == 0,
                    "The actual plane presentation violates d1*d2=0",
                )
        _, pivots = rational_rref(matrix, len(domain))
        rank_d1 = len(rational_rref(d1, len(target))[1])
        require(
            len(pivots) + rank_d1 == len(target),
            "Exactness fails in an enumerated actual good component",
        )
        if dimension:
            require(rank_d1 == len(full_quotient.basis), "Augmentation ideal not generated")
        return {
            "domain": len(domain), "target": len(target),
            "rank": len(pivots), "dimension": len(domain) - len(pivots),
            "matrix": matrix, "pivots": pivots,
        }

    @cached_property
    def result(self):
        all_lhs = {}
        for support in self.supports:
            lhs = 0
            for dimension in range(1, len(support) + 1):
                for a, b in self.decompositions(support, dimension):
                    lhs += dimension * self.lie_dimension(a) * self.kernel(b)["dimension"]
            nullity = self.kernel(support)["dimension"]
            require(lhs <= max(0, len(support) - 2) * nullity, "Strengthened inequality fails")
            all_lhs[support] = lhs
        kernel = self.kernel(self.full)
        return {
            "field": self.field, "dimension": self.dimension,
            "structure": "symmetric_identity" if self.form else "no_form",
            "allowed_line_types": self.line_type,
            "allowed_lines": len(self.lines),
            "unordered_frames": len(self.frames[self.full]),
            "supports_checked": len(self.supports),
            "U_dimension": len(self.quotient(self.full).basis),
            "P_dimension": self.lie_dimension(self.full),
            "d2_domain": kernel["domain"], "d2_target": kernel["target"],
            "d2_rank": kernel["rank"], "C_dimension": kernel["dimension"],
            "marked_lhs": all_lhs[self.full],
            "strengthened_rhs": (self.dimension - 2) * kernel["dimension"],
            "manuscript_rhs": self.dimension * kernel["dimension"],
        }


def check_jacobian(model, certificate):
    payload = json.loads((HERE / "jacobian_payload.json").read_text())
    response = json.loads((HERE / "jacobian_result.json").read_text())
    status = json.loads((HERE / "jacobian_status.json").read_text())
    require(status["adapter_exit_code"] == 0, "Jacobian adapter did not complete successfully")
    require(response["server"]["version"] == certificate["jacobian"]["server_version"],
            "Unexpected Jacobian server version")
    require(response["protocol_version"] == certificate["jacobian"]["protocol_version"],
            "Unexpected Jacobian protocol version")
    require(response["request"]["operation_id"] == "matrix.rank.compute", "Wrong operation")
    require(response["request"]["payload"] == payload, "Jacobian request/payload mismatch")
    output = response["result"]["output"]
    require(output["matrix"] == payload["matrix"], "Jacobian matrix binding mismatch")
    entries = [
        [Fraction(x["num"]) / Fraction(x["den"]) for x in row]
        for row in payload["matrix"]["entries"]
    ]
    actual = model.kernel(model.full)
    require(entries == actual["matrix"], "Payload is not the actual three-dimensional d2")
    require(output["rank"] == actual["rank"] == 2, "Rank disagreement")
    require(output["pivot_columns"] == actual["pivots"] == [0, 1], "Pivot disagreement")
    require(all(sum(row) == 0 for row in entries), "Claimed exact kernel vector is invalid")


def compile_formal_source():
    version = subprocess.run([str(LEAN), "--version"], check=True, text=True, capture_output=True)
    require("version 4.31.0," in version.stdout, "Lean 4.31.0 is required")
    require(WORKSPACE.is_dir(), "The declared prebuilt Mathlib workspace is missing")
    command = [str(LAKE), "--dir", str(WORKSPACE), "env", "lean", str(HERE / "Main.lean")]
    compiled = subprocess.run(command, text=True, capture_output=True, timeout=110)
    require(compiled.returncode == 0, compiled.stdout + compiled.stderr)
    require(not compiled.stdout.strip() and not compiled.stderr.strip(),
            "Unexpected compiler output: " + compiled.stdout + compiled.stderr)
    return version.stdout.strip()


def check_archived_proof(certificate):
    formal = certificate["formal_core"]
    archive = json.loads((HERE / formal["certificate"]).read_text())
    official = json.loads((HERE / formal["official_result"]).read_text())
    require(archive["subject"]["subject_id"] == formal["claim"], "Wrong formal claim")
    require(archive["tier"] == "mechanical" and archive["verdict"] == "supports",
            "The archive is not supporting mechanical evidence")
    require(archive["lean_source"]["text"] == (HERE / formal["source"]).read_text(),
            "The Lean source changed after official certification")
    require(archive["statement_fidelity"]["text"] ==
            (HERE / formal["statement_fidelity"]).read_text(),
            "Statement fidelity changed after official certification")
    for result in (archive["lean_check"], official):
        require(result["status"] == "success" and result["exit_code"] == 0,
                "The official compiler run did not succeed")
        require(result["proof_holes"] == [], "The official run contains proof holes")
    require(archive["produced_by"] == "lean_evidence/lean 4.31.0", "Wrong certified toolchain")
    require(official["kernel"]["recorded"]["subject"] == archive["subject"],
            "Official claim binding differs from the archived proof")
    require((HERE.parent.parent / official["kernel"]["recorded"]["artifact"]).resolve()
            == (HERE / formal["certificate"]).resolve(), "Wrong certificate artifact")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--finite-only", action="store_true",
                        help="Development checkpoint only; do not recompile the universal theorem")
    args = parser.parse_args()
    certificate = json.loads((HERE / "exact_certificate.json").read_text())
    models = [
        ActualPlaneModel(3, 2, True, "square"),
        ActualPlaneModel(3, 3, True, "square"),
        ActualPlaneModel(3, 4, True, "square"),
        ActualPlaneModel(2, 3, False, "all"),
        ActualPlaneModel(5, 3, True, "both"),
    ]
    results = [model.result for model in models]
    require(results == certificate["actual_kernel_examples"],
            "Computed examples differ from the certificate:\n" + json.dumps(results, indent=2))
    check_jacobian(models[1], certificate)
    check_archived_proof(certificate)
    version = None if args.finite_only else compile_formal_source()
    print(json.dumps({
        "finite_examples_replayed": len(results),
        "actual_supports_checked": sum(x["supports_checked"] for x in results),
        "actual_plane_relations": "constructed, not sampled",
        "jacobian_payload_bound_to_actual_d2": True,
        "official_proof_and_fidelity_match_current_files": True,
        "formal_core_freshly_compiled": not args.finite_only,
        "lean": version,
        "scope": "universal weighted-marking core plus finite actual-kernel replays; "
                 "the all-dimensions PBW/support bridge is proved in REPORT.md",
        "independent_review": "not supplied by this script",
    }, indent=2))


if __name__ == "__main__":
    main()
