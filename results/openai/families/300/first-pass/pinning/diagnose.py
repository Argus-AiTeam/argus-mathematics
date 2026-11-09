#!/usr/bin/env python3
"""Bounded diagnostics, never a proof of the quantified arrow theorem."""

import json
from pathlib import Path

import numpy as np


def arrow(a, poles, residues):
    matrix = np.diag(np.r_[-a, poles])
    matrix[0, 1:] = np.sqrt(residues)
    matrix[1:, 0] = matrix[0, 1:]
    return matrix


def run():
    rng = np.random.default_rng(9000300)
    worst = -float("inf")
    cases = 0
    for size in range(9):
        for sample in range(80):
            colors = 1 + sample % 5
            a = 10.0 ** rng.uniform(-2, 2)
            poles = rng.choice([-3.0, -1.0, 0.0, 0.0, 1.0, 3.0], size=size)
            poles *= 10.0 ** rng.uniform(-2, 2)
            probabilities = rng.integers(0, 6, size=colors).astype(float)
            probabilities[0] += 1
            probabilities /= probabilities.sum()
            options = 10.0 ** rng.uniform(-5, 3, size=(colors, size))
            options[rng.random(options.shape) < 0.35] = 0
            residues = probabilities @ options
            matrix = arrow(a, poles, residues)
            values, vectors = np.linalg.eigh(matrix)
            positive = (vectors * np.maximum(values, 0)) @ vectors.T
            negative = (vectors * np.maximum(-values, 0)) @ vectors.T
            mass = positive[0, 0]
            old_trace = np.maximum(values, 0).sum()
            eplus = np.diag(negative)[1:][poles > 0].sum()
            eminus = np.diag(positive)[1:][poles <= 0].sum()
            buffer = 8 * mass + 4 * a
            test_plus = (options[:, poles > 0] / (buffer + poles[poles > 0])).sum(axis=1)
            nonpositive = poles <= 0
            denominators = eminus + abs(poles[nonpositive])
            if np.any(denominators == 0):
                zero = denominators == 0
                assert np.all(options[probabilities > 0][:, nonpositive][:, zero] == 0)
                options_minus = options[:, nonpositive][:, ~zero]
                denominators = denominators[~zero]
            else:
                options_minus = options[:, nonpositive]
            test_minus = (options_minus / denominators).sum(axis=1)
            tolerance = 1e-8 * max(1.0, old_trace, a)
            assert probabilities @ test_plus <= 2 * mass + eplus / 2 + tolerance
            assert probabilities @ test_minus <= 6 * mass + 4 * a + tolerance
            selected = (
                (probabilities > 0)
                & (test_plus <= 4 * mass + eplus + tolerance)
                & (test_minus <= 12 * mass + 8 * a + tolerance)
            )
            assert selected.any()
            changes = [
                np.maximum(np.linalg.eigvalsh(arrow(12 * a, poles, option)), 0).sum()
                - old_trace
                for option in options[selected]
            ]
            gap = min(changes) - 23 * mass
            assert gap <= tolerance
            worst = max(worst, gap)
            cases += 1
    result = {
        "classification": "finite_floating_point_diagnostic_not_a_universal_certificate",
        "seed": 9000300,
        "cases": cases,
        "maximum_deletion_dimension": 8,
        "buffer": 12,
        "cost_constant": 23,
        "maximum_observed_conclusion_gap": worst,
        "includes": [
            "zero residues",
            "zero probability options",
            "zero and repeated poles",
            "empty deletion spectrum",
            "nonuniform probabilities",
        ],
    }
    output = Path(__file__).with_name("diagnostics.json")
    output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result))


if __name__ == "__main__":
    run()
