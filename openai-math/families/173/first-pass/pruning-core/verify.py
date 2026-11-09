#!/usr/bin/env python3
"""Exact supplementary replay for the universal pruning verification."""

import argparse
from dataclasses import dataclass
from fractions import Fraction
from functools import lru_cache
import hashlib
from itertools import combinations
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent


@dataclass(frozen=True)
class Matrix:
    nrows: int
    ncols: int
    data: tuple

    @classmethod
    def build(cls, nrows, ncols, entry):
        return cls(nrows, ncols, tuple(
            tuple(Fraction(entry(i, j)) for j in range(ncols))
            for i in range(nrows)
        ))

    def transpose(self):
        return Matrix.build(self.ncols, self.nrows, lambda i, j: self.data[j][i])

    def mul_vec(self, vector):
        assert len(vector) == self.ncols
        return tuple(sum((x * y for x, y in zip(row, vector)), Fraction(0))
                     for row in self.data)

    def multiply(self, other):
        assert self.ncols == other.nrows
        return Matrix.build(self.nrows, other.ncols, lambda i, j: sum(
            (self.data[i][k] * other.data[k][j] for k in range(self.ncols)),
            Fraction(0),
        ))

    def columns(self, indices):
        return Matrix.build(self.nrows, len(indices),
                            lambda i, j: self.data[i][indices[j]])

    def rref(self):
        rows = [list(row) for row in self.data]
        pivots = []
        for col in range(self.ncols):
            pivot = next((i for i in range(len(pivots), self.nrows)
                          if rows[i][col]), None)
            if pivot is None:
                continue
            row = len(pivots)
            rows[row], rows[pivot] = rows[pivot], rows[row]
            scale = rows[row][col]
            rows[row] = [x / scale for x in rows[row]]
            for i in range(self.nrows):
                if i != row:
                    scale = rows[i][col]
                    rows[i] = [x - scale * y for x, y in zip(rows[i], rows[row])]
            pivots.append(col)
        return rows, tuple(pivots)

    def rank(self):
        return len(self.rref()[1])

    def nullspace(self):
        rows, pivots = self.rref()
        vectors = []
        for col in range(self.ncols):
            if col not in pivots:
                vector = [Fraction(0)] * self.ncols
                vector[col] = Fraction(1)
                for i, pivot in enumerate(pivots):
                    vector[pivot] = -rows[i][col]
                vectors.append(tuple(vector))
        return tuple(vectors)

    def solve_full_column_rank(self, target):
        assert len(target) == self.nrows and self.rank() == self.ncols
        augmented = Matrix.build(self.nrows, self.ncols + 1, lambda i, j:
                                 target[i] if j == self.ncols else self.data[i][j])
        rows, pivots = augmented.rref()
        assert self.ncols not in pivots, "inconsistent lift equation"
        result = [Fraction(0)] * self.ncols
        for i, col in enumerate(pivots):
            result[col] = rows[i][-1]
        assert self.mul_vec(result) == tuple(target)
        return tuple(result)

    def determinant(self):
        assert self.nrows == self.ncols
        rows = [list(row) for row in self.data]
        answer = Fraction(1)
        for col in range(self.ncols):
            pivot = next((i for i in range(col, self.nrows) if rows[i][col]), None)
            if pivot is None:
                return Fraction(0)
            if pivot != col:
                rows[col], rows[pivot] = rows[pivot], rows[col]
                answer = -answer
            value = rows[col][col]
            answer *= value
            for i in range(col + 1, self.nrows):
                scale = rows[i][col] / value
                rows[i] = [x - scale * y for x, y in zip(rows[i], rows[col])]
        return answer

    def json(self):
        return {"shape": [self.nrows, self.ncols],
                "entries": [[str(x) for x in row] for row in self.data]}


def optimal_matching(neighbors, right_count, original_left=0, original_right=0):
    """Maximum cardinality, then minimum number of original-original edges."""
    assert all(0 <= j < right_count for row in neighbors for j in row)

    @lru_cache(None)
    def solve(i, used):
        if i == len(neighbors):
            return 0, 0, ()
        best = solve(i + 1, used)
        for j in neighbors[i]:
            if used & (1 << j):
                continue
            size, cost, edges = solve(i + 1, used | (1 << j))
            candidate = (size + 1, cost + int(i < original_left and j < original_right),
                         ((i, j),) + edges)
            if (candidate[0], -candidate[1]) > (best[0], -best[1]):
                best = candidate
        return best

    return solve(0, 0)[2]


def augmented(arrows, left, right):
    conflicts = tuple((r, c) for r in left for c in right
                      if (r[0], c[0]) in arrows and (c[1], r[1]) in arrows)
    z = tuple(sorted({(c[0], r[1]) for r, c in conflicts}))
    h = tuple(sorted({(r[0], c[1]) for r, c in conflicts}))

    def left_covers(r, point):
        return r[1] == point[1] and (r[0], point[0]) in arrows

    def right_covers(c, point):
        return c[0] == point[0] and (c[1], point[1]) in arrows

    neighbors = tuple(
        tuple(j for j, c in enumerate(right) if (r, c) in conflicts)
        + tuple(len(right) + j for j, point in enumerate(z) if left_covers(r, point))
        for r in left
    ) + tuple(tuple(j for j, c in enumerate(right) if right_covers(c, point))
              for point in z)
    return conflicts, z, h, neighbors, left_covers, right_covers


def check_pruning(arrows, left, right):
    conflicts, z, h, neighbors, left_covers, right_covers = augmented(arrows, left, right)
    matching = optimal_matching(neighbors, len(right) + len(z), len(left), len(right))
    assert len(matching) <= len(z) + len(h), "augmented matching bound violated"
    mate_left, mate_right = dict(matching), {j: i for i, j in matching}
    reached_left = set(range(len(neighbors))) - mate_left.keys()
    reached_right = set()
    queue = sorted(reached_left)
    for i in queue:
        for j in neighbors[i]:
            if mate_left.get(i) == j or j in reached_right:
                continue
            reached_right.add(j)
            assert j in mate_right, "augmenting path contradicts maximal cardinality"
            mate = mate_right[j]
            if mate not in reached_left:
                reached_left.add(mate)
                queue.append(mate)
    cover_left = set(range(len(neighbors))) - reached_left
    cover_right = reached_right
    assert len(cover_left) + len(cover_right) == len(matching)
    assert all(i in cover_left or j in cover_right
               for i, row in enumerate(neighbors) for j in row)
    assert all(neighbors[i] for i in cover_left)
    assert all(any(j in row for row in neighbors) for j in cover_right)
    kept_left = tuple(r for i, r in enumerate(left) if i not in cover_left)
    kept_right = tuple(c for j, c in enumerate(right) if j not in cover_right)
    assert not any(r in kept_left and c in kept_right for r, c in conflicts)
    free_left = tuple(r for r in left if not any(r == a for a, _ in conflicts))
    free_right = tuple(c for c in right if not any(c == b for _, b in conflicts))
    assert set(free_left) <= set(kept_left)
    assert set(free_right) <= set(kept_right)
    uncovered = tuple(point for point in z
                      if not any(left_covers(r, point) for r in kept_left)
                      and not any(right_covers(c, point) for c in kept_right))
    deleted = len(left) + len(right) - len(kept_left) - len(kept_right)
    assert deleted <= len(h) + len(uncovered), "full pruning conclusion violated"
    alpha = tuple(i for i, j in matching if i < len(left) and j >= len(right))
    beta = tuple(j for i, j in matching if i >= len(left) and j < len(right))
    original = tuple((i, j) for i, j in matching if i < len(left) and j < len(right))
    alpha_graph = tuple(tuple(j - len(right) for j in row if j >= len(right))
                        for row in neighbors[:len(left)])
    beta_graph = neighbors[len(left):]
    assert len(alpha) == len(optimal_matching(alpha_graph, len(z)))
    assert len(beta) == len(optimal_matching(beta_graph, len(right)))
    return {
        "Z": z, "H": h, "matching": matching, "alpha": alpha, "beta": beta,
        "original": original, "cover_left": tuple(sorted(cover_left)),
        "cover_right": tuple(sorted(cover_right)), "kept_left": kept_left,
        "kept_right": kept_right, "initially_free_left": free_left,
        "initially_free_right": free_right, "uncovered_Z": uncovered,
        "deleted": deleted,
    }


def exact_example():
    arrows = {(0, 2), (1, 2), (6, 3), (6, 4), (7, 5), (8, 5)}
    left = tuple(sorted({(p, j) for p in (0, 1) for j in (3, 4, 5)} | {(9, 9)}))
    right = ((2, 6), (2, 7), (2, 8), (9, 9))
    result = check_pruning(arrows, left, right)
    z, h = result["Z"], result["H"]
    weights = {edge: 2 ** (2 ** index) for index, edge in enumerate(sorted(arrows))}
    coefficient = lambda x, y: weights.get((x, y), 0)
    lmap = Matrix.build(len(z), len(left), lambda a, r:
                        coefficient(left[r][0], z[a][0]) if left[r][1] == z[a][1] else 0)
    nmap = Matrix.build(len(right), len(z), lambda c, a:
                        coefficient(right[c][1], z[a][1]) if right[c][0] == z[a][0] else 0)
    bmap = Matrix.build(len(h), len(left), lambda a, r:
                        coefficient(h[a][1], left[r][1]) if h[a][0] == left[r][0] else 0)
    amap = Matrix.build(len(right), len(h), lambda c, a:
                        coefficient(h[a][0], right[c][0]) if right[c][1] == h[a][1] else 0)
    assert nmap.multiply(lmap) == amap.multiply(bmap)
    assert lmap.rank() == len(result["alpha"])
    assert nmap.rank() == len(result["beta"])
    nt = nmap.transpose()
    assert bmap.nullspace() and nt.nullspace()
    conflict_indices = [(left.index(r), right.index(c))
                        for r, c in augmented(arrows, left, right)[0]]
    for u in bmap.nullspace():
        for v in nt.nullspace():
            assert all(u[r] * v[c] == 0 for r, c in conflict_indices)
    local_ranks = []
    for p, i in sorted(arrows):
        jp = tuple(j for q, j in left if q == p)
        si = tuple(s for q, s in right if q == i)
        dmap = Matrix.build(len(si), len(jp), lambda a, b: coefficient(si[a], jp[b]))
        support = tuple(tuple(b for b, j in enumerate(jp) if (s, j) in arrows) for s in si)
        maximum_rank = len(optimal_matching(support, len(jp)))
        assert dmap.rank() == maximum_rank
        local_ranks.append({"arrow": [p, i], "shape": [len(si), len(jp)], "rank": maximum_rank})
    u_lifts, v_lifts = [], []
    for r, c in result["original"]:
        uc = lmap.columns(result["alpha"]).solve_full_column_rank(
            tuple(-lmap.data[i][r] for i in range(lmap.nrows)))
        vc = nt.columns(result["beta"]).solve_full_column_rank(
            tuple(-nt.data[i][c] for i in range(nt.nrows)))
        u, v = [Fraction(0)] * len(left), [Fraction(0)] * len(right)
        u[r], v[c] = Fraction(1), Fraction(1)
        for a, value in zip(result["alpha"], uc):
            u[a] = value
        for b, value in zip(result["beta"], vc):
            v[b] = value
        assert not any(lmap.mul_vec(u)) and not any(nt.mul_vec(v))
        assert not any(amap.mul_vec(bmap.mul_vec(u)))
        u_lifts.append(tuple(u))
        v_lifts.append(tuple(v))
    images = Matrix.build(len(h), len(u_lifts), lambda i, j: bmap.mul_vec(u_lifts[j])[i])
    assert images.rank() == len(result["original"]) > 0
    assert len(h) - amap.rank() >= images.rank()
    active_rows = sorted({p for p, _ in arrows})
    active_cols = sorted({i for _, i in arrows})
    minor_counts = {"structurally_nonzero": 0, "structurally_zero": 0}
    for size in range(min(len(active_rows), len(active_cols)) + 1):
        for rows in combinations(active_rows, size):
            for cols in combinations(active_cols, size):
                minor = Matrix.build(size, size, lambda i, j: coefficient(rows[i], cols[j]))
                support = tuple(tuple(j for j, col in enumerate(cols) if (row, col) in arrows)
                                for row in rows)
                structural = len(optimal_matching(support, size)) == size
                assert (minor.determinant() != 0) == structural
                minor_counts["structurally_nonzero" if structural else "structurally_zero"] += 1
    return {
        "vertices": list(range(10)), "arrows": sorted(arrows),
        "R": left, "C": right, "coefficient_arrays_equal": True,
        "arrow_coefficients": [[*edge, str(weights[edge])] for edge in sorted(arrows)],
        "pruning": result,
        "matrices": {"L": lmap.json(), "N": nmap.json(), "B": bmap.json(), "A": amap.json()},
        "ranks": {"L": lmap.rank(), "N": nmap.rank(), "B": bmap.rank(),
                  "A": amap.rank(), "NL": nmap.multiply(lmap).rank(),
                  "independent_B_lifts": images.rank()},
        "kernel_B": [[str(x) for x in u] for u in bmap.nullspace()],
        "kernel_N_transpose": [[str(x) for x in v] for v in nt.nullspace()],
        "u_lifts": [[str(x) for x in u] for u in u_lifts],
        "v_lifts": [[str(x) for x in v] for v in v_lifts],
        "B_lifts": images.json(), "local_support_ranks": local_ranks,
        "all_active_submatrix_minors": minor_counts,
    }


def exhaustive_small():
    counts = {}
    for n in range(3):
        pairs = tuple((i, j) for i in range(n) for j in range(n))
        subsets = tuple(tuple(pair for index, pair in enumerate(pairs) if mask & (1 << index))
                        for mask in range(1 << (n * n)))
        count = 0
        for relation in subsets:
            arrows = set(relation)
            for left in subsets:
                for right in subsets:
                    check_pruning(arrows, left, right)
                    count += 1
        counts[str(n)] = count
    assert counts == {"0": 1, "1": 8, "2": 4096}
    return {"scope": "all labeled relations, including loops, and all separate R,C copies",
            "counts_by_order": counts, "total": sum(counts.values()),
            "interpretation": "finite regression only; not a universal proof"}


def jacobian_payload():
    variables = ["b00", "b01", "b12", "b22"]

    def entry(index):
        powers = [0] * len(variables)
        if index is not None:
            powers[index] = 1
        one = {"coefficient": {"num": "1", "den": "1"}, "exponents": [0] * len(variables)}
        numerator = [] if index is None else [
            {"coefficient": {"num": "1", "den": "1"}, "exponents": powers}]
        return {"domain": "QQ", "variables": variables,
                "numerator": {"terms": numerator}, "denominator": {"terms": [one]}}

    return {"matrix": {"variables": variables, "entries": [
        [entry(0), entry(1), entry(None)],
        [entry(None), entry(None), entry(2)],
        [entry(None), entry(None), entry(3)],
    ]}}


def stored_evidence():
    compiler = json.loads((ROOT / "lean_check.json").read_text())
    assert compiler["status"] == "success" and compiler["exit_code"] == 0
    assert compiler["proof_holes"] == [] and compiler["audit_exit_code"] == 0
    assert compiler["tools"]["lean"]["version"].startswith("Lean (version 4.31.0,")
    assert compiler["source_sha256"] == hashlib.sha256((ROOT / "Main.lean").read_bytes()).hexdigest()
    fidelity = (ROOT / "statement_fidelity.md").read_text().encode("utf-8")
    assert compiler["statement_fidelity_sha256"] == hashlib.sha256(fidelity).hexdigest()
    payload = json.loads((ROOT / "jacobian_payload.json").read_text())
    response = json.loads((ROOT / "jacobian_result.json").read_text())
    status = json.loads((ROOT / "jacobian_status.json").read_text())
    operation = "matrix.symbolic.rank.compute"
    assert payload == jacobian_payload()
    assert response["request"] == {"operation_id": operation, "payload": payload}
    assert response["result"]["operation_id"] == operation
    assert response["result"]["output"] == {
        "method": "EXACT_SYMBOLIC_ROW_REDUCTION", "rank": 2, "pivot_columns": [0, 2]}
    assert response["server"]["version"] == status["server_version"] == "0.14.0"
    assert response["protocol_version"] == status["protocol_version"] == "2025-11-25"
    assert status["operation_id"] == operation and status["adapter_exit_code"] == 0
    assert status["timeout"] is False and status["structured_error"] is None
    return {
        "lean": {"result_file": "lean_check.json", "version": "4.31.0",
                 "exit_code": 0, "proof_holes": [], "audit_exit_code": 0,
                 "source_and_fidelity_match_compiler": True},
        "jacobian": {"operation_id": operation, "payload_file": "jacobian_payload.json",
                     "typed_response_file": "jacobian_result.json",
                     "server_version": "0.14.0", "protocol_version": "2025-11-25",
                     "adapter_exit_code": 0, "rank": 2, "pivot_columns": [0, 2]},
        "interpretation": "Stored tool evidence is checked for consistency; this does not run either tool again.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-certificate", action="store_true")
    parser.add_argument("--write-jacobian-payload", action="store_true")
    args = parser.parse_args()
    if args.write_jacobian_payload:
        path = ROOT / "jacobian_payload.json"
        path.write_text(json.dumps(jacobian_payload(), indent=2) + "\n")
        print("Wrote exact typed payload:", path.name)
        return
    certificate = {
        "claim": "C_PRUNING", "result_class": "universal_verification",
        "universal_evidence": {
            "proof": "pruning_theorem.md", "formal_source": "Main.lean",
            "statement_fidelity": "statement_fidelity.md", "formal_claim": "C_KERNEL_CORE",
            "scope": "The universal argument is the proof and formal core, not these finite computations.",
            "independent_review": "required; this replay cannot confer it",
        },
        "exact_nontrivial_instance": exact_example(),
        "finite_regression": exhaustive_small(),
        "stored_tool_evidence": stored_evidence(),
    }
    path = ROOT / "exact_certificate.json"
    normalized = json.loads(json.dumps(certificate))
    if args.write_certificate:
        path.write_text(json.dumps(normalized, indent=2, sort_keys=True) + "\n")
    expected = json.loads(path.read_text())
    assert normalized == expected, "certificate differs from exact recomputation"
    print(json.dumps({"ok": True, "finite_instances": certificate["finite_regression"]["total"],
                      "nontrivial_B_lifts": certificate["exact_nontrivial_instance"]["ranks"]["independent_B_lifts"],
                      "stored_lean_evidence_current": True,
                      "universal_proof": "pruning_theorem.md + Main.lean",
                      "independent_review": "required"}, sort_keys=True))


if __name__ == "__main__":
    main()
