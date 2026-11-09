"""Bounded numerical exploration; its output is not a proof."""

import argparse
import json
import time

import numpy as np

from tensor_semantics import boundary, interior_matrix


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--samples", type=int, default=80)
    args = parser.parse_args()
    rng = np.random.default_rng(367)
    eps = 438907 / 12000000
    delta = 6984137359 / 31250000000
    best = float("inf")
    start = time.monotonic()
    minimum = None
    for k in range(args.samples):
        alpha = rng.normal(size=5)
        alpha -= alpha.mean()
        alpha /= np.linalg.norm(alpha)
        A = np.diag(alpha)
        pg = rng.normal(size=6)
        pg *= (1 if k % 3 == 0 else rng.random() ** (1 / 6)) / np.linalg.norm(pg)
        if k % 5 == 0:
            pg[:] = 0
        B = interior_matrix(A, pg[:5], pg[5])
        B[31, 31] -= eps
        B[32:, 32:] -= eps * np.eye(5)
        eigenvalues, eigenvectors = np.linalg.eigh(B)
        if eigenvalues[0] < best:
            best = float(eigenvalues[0])
            minimum = {
                "sample": k,
                "minimum_residual_eigenvalue": best,
                "eigenvalues_A": alpha.tolist(),
                "p": pg[:5].tolist(),
                "g": float(pg[5]),
                "jet_coordinates": eigenvectors[:, 0].tolist(),
            }
        if best < -1e-6:
            break
    samples_completed = k + 1
    alpha = np.array([0.5, 0.5, -0.5, -0.5, 0])
    boundary_samples = []
    for k in range(5):
        if alpha[k] < 0:
            p = np.eye(5)[k]
            boundary_samples.append({"lambda": float(alpha[k]), "S_minus_delta": float(boundary(np.diag(alpha), p) - delta)})
    print(json.dumps({
        "classification": "numerical_experiment",
        "samples": samples_completed,
        "interior_minimum": minimum,
        "boundary_samples": boundary_samples,
        "elapsed_seconds": time.monotonic() - start,
    }, indent=2))


if __name__ == "__main__":
    main()
