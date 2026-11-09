#!/usr/bin/env python3
"""Deterministic floating-point diagnostics; never an exact norm certificate."""

import argparse
import itertools
import json
import time
from pathlib import Path

import clarabel
import numpy as np
from scipy import sparse


class ConicStatusError(RuntimeError):
    pass


def partition_matrices(parents):
    n = len(parents)
    children = [[v for v in range(n) if parents[v] == u] for u in range(n)]
    matrices = []
    for selected in itertools.product(*[[-1] + c for c in children]):
        root = list(range(n))
        for u, v in enumerate(selected):
            if v >= 0:
                root[v] = root[u]
        matrices.append(
            np.array([[float(root[u] == root[v]) for v in range(n)] for u in range(n)])
        )
    return np.array(matrices)


def primal_norm(vector, matrices):
    return np.sqrt(np.max(np.einsum("i,kij,j->k", vector, matrices, vector)))


def solver_settings():
    settings = clarabel.DefaultSettings()
    settings.verbose = False
    settings.tol_gap_abs = 1e-8
    settings.tol_gap_rel = 1e-8
    settings.tol_feas = 1e-8
    return settings


def blocks_for(matrices):
    blocks = [np.unique(matrix, axis=0) for matrix in matrices]
    return [block[np.any(block != 0, axis=1)] for block in blocks]


def dual_norm(vector, matrices):
    if not np.any(vector):
        return 0.0
    scale = np.linalg.norm(vector)
    objective = vector / scale
    blocks = blocks_for(matrices)
    constraint_matrix = sparse.vstack(
        [sparse.csc_matrix(np.vstack((np.zeros(len(vector)), -block)))
         for block in blocks],
        format="csc",
    )
    bounds = np.concatenate([np.r_[1.0, np.zeros(len(block))] for block in blocks])
    cones = [clarabel.SecondOrderConeT(len(block) + 1) for block in blocks]
    solver = clarabel.DefaultSolver(
        sparse.csc_matrix((len(vector), len(vector))),
        -objective, constraint_matrix, bounds, cones, solver_settings(),
    )
    result = solver.solve()
    if str(result.status) != "Solved":
        raise ConicStatusError(
            f"Unresolved conic norm: {result.status}; input={vector.tolist()}"
        )
    return -result.obj_val * scale


def minimum_lens(x, tail, matrices):
    blocks = blocks_for(matrices)
    head_size = len(x)
    n = head_size + len(tail)
    groups = []
    size = 1
    for sign in [1, -1]:
        for block in blocks:
            groups.append((sign, size, block))
            size += 1 + len(block)
    equalities = head_size + 2 * len(tail)
    rows = [np.zeros((equalities, size)), np.zeros((2, size))]
    rows[1][:, 0] = -1
    bounds = [np.r_[2 * x, tail, -tail], np.zeros(2)]
    cones = [clarabel.ZeroConeT(equalities), clarabel.NonnegativeConeT(2)]
    for sign, start, block in groups:
        rows[0][:head_size, start + 1:start + 1 + len(block)] = block[:, :head_size].T
        begin = head_size if sign == 1 else n
        rows[0][begin:begin + len(tail), start + 1:start + 1 + len(block)] = block[:, head_size:].T
        rows[1][0 if sign == 1 else 1, start] = 1
        row = np.zeros((len(block) + 1, size))
        row[:, start:start + len(block) + 1] = -np.eye(len(block) + 1)
        rows.append(row)
        bounds.append(np.zeros(len(block) + 1))
        cones.append(clarabel.SecondOrderConeT(len(block) + 1))
    objective = np.zeros(size)
    objective[0] = 1
    solver = clarabel.DefaultSolver(
        sparse.csc_matrix((size, size)), objective,
        sparse.csc_matrix(np.vstack(rows)), np.concatenate(bounds),
        cones, solver_settings(),
    )
    result = solver.solve()
    if str(result.status) != "Solved":
        raise ConicStatusError(f"Unresolved conic lens: {result.status}")
    plus = np.zeros(n)
    for sign, start, block in groups:
        if sign == 1:
            plus += block.T @ np.array(result.x[start + 1:start + 1 + len(block)])
    return result.x[0], plus[:head_size] - x


def minimum_extension_average(head, tail, matrices):
    head_size = len(head)
    size = len(tail) + 2
    blocks = blocks_for(matrices)
    rows = []
    bounds = []
    cones = []
    for sign, radius in [(1, 0), (-1, 1)]:
        for block in blocks:
            row = np.zeros((len(block) + 1, size))
            row[0, radius] = -1
            row[1:, 2:] = -block[:, head_size:]
            rows.append(row)
            bounds.append(np.r_[0.0, block @ np.r_[head, sign * tail]])
            cones.append(clarabel.SecondOrderConeT(len(block) + 1))
    objective = np.r_[0.5, 0.5, np.zeros(len(tail))]
    solver = clarabel.DefaultSolver(
        sparse.csc_matrix((size, size)), objective,
        sparse.csc_matrix(np.vstack(rows)), np.concatenate(bounds),
        cones, solver_settings(),
    )
    result = solver.solve()
    if str(result.status) != "Solved":
        raise ConicStatusError(f"Unresolved conic extension: {result.status}")
    return result.obj_val, result.x[2:]


def run_extensions(parents, head_size, samples, seed):
    rng = np.random.default_rng(seed)
    matrices = partition_matrices(parents)
    head_matrices = partition_matrices(parents[:head_size])
    tail_indices = range(head_size, len(parents))
    tail_matrices = matrices[:, tail_indices, :][:, :, tail_indices]
    best = None
    unresolved = []
    completed = 0
    for sample in range(samples):
        head = rng.normal(size=head_size)
        head /= primal_norm(head, head_matrices)
        tail = rng.normal(size=len(parents) - head_size)
        magnitude = 10 ** rng.uniform(-2, 0)
        tail *= magnitude / primal_norm(tail, tail_matrices)
        try:
            average, correction = minimum_extension_average(head, tail, matrices)
        except ConicStatusError as error:
            unresolved.append({"sample": sample, "error": str(error)})
            continue
        ratio = (average ** 2 - 1) / magnitude ** 2
        completed += 1
        record = {
            "extension_squared_coefficient_diagnostic": float(ratio),
            "head_test": head.tolist(), "tail_test": tail.tolist(),
            "common_correction": list(correction),
            "minimum_average_diagnostic": float(average),
        }
        if best is None or ratio > best["extension_squared_coefficient_diagnostic"]:
            best = record
    return {
        "classification": "floating_point_diagnostic_not_certificate",
        "parents": parents, "head_size": head_size, "samples": samples,
        "completed": completed, "unresolved": unresolved, "seed": seed, "best": best,
    }


def run(parents, head_size, samples, seed):
    rng = np.random.default_rng(seed)
    matrices = partition_matrices(parents)
    head_matrices = partition_matrices(parents[:head_size])
    tail_indices = range(head_size, len(parents))
    tail_matrices = matrices[:, tail_indices, :][:, :, tail_indices]
    best = None
    unresolved = []
    completed = 0
    for sample in range(samples):
        x = rng.normal(size=head_size)
        tail = rng.normal(size=len(parents) - head_size)
        magnitude = 10 ** rng.uniform(-1, 0)
        try:
            x /= dual_norm(x, head_matrices)
            tail *= magnitude / dual_norm(tail, tail_matrices)
            radius, head = minimum_lens(x, tail, matrices)
        except ConicStatusError as error:
            unresolved.append({"sample": sample, "error": str(error)})
            continue
        radius2 = radius ** 2
        ratio = magnitude ** 2 / (radius2 - 1)
        completed += 1
        record = {
            "ratio_diagnostic": float(ratio),
            "x_head": x.tolist(),
            "y_head": head.tolist(),
            "y_tail": tail.tolist(),
            "radius_squared_diagnostic": float(radius2),
        }
        if best is None or ratio > best["ratio_diagnostic"]:
            best = record
    return {
        "classification": "floating_point_diagnostic_not_certificate",
        "parents": parents,
        "head_size": head_size,
        "samples": samples,
        "completed": completed,
        "unresolved": unresolved,
        "seed": seed,
        "best": best,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--samples", type=int, default=5)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--extensions", action="store_true")
    args = parser.parse_args()
    start = time.monotonic()
    models = [
        ([-1, 0, 1], 2),
        ([-1, 0, 0, 1], 3),
        ([-1, 0, 1, 2], 3),
        ([-1, 0, 1], 1),
        ([-1, 0, 1, 2], 1),
        ([-1, 0, 1, 1], 2),
        ([-1, 0, 1, 2, 2], 2),
        ([-1, 0, 0, 1, 1, 2, 2], 3),
    ]
    result = {
        "models": [
            (run_extensions if args.extensions else run)(
                parents, head_size, args.samples, seed=331 + i
            )
            for i, (parents, head_size) in enumerate(models)
        ],
        "elapsed_seconds": time.monotonic() - start,
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
