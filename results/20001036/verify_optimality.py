#!/usr/bin/env python3
"""Verify that 5,454 is the exact LP and integer minimum vertex count for the 16-vertex prototype."""

from __future__ import annotations
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent

def main() -> None:
    cert = json.loads((HERE / "optimality-certificate.json").read_text(encoding="utf-8"))
    c6000 = json.loads((HERE / "copies-6000.json").read_text(encoding="utf-8"))
    A = c6000["A"]
    m = cert["primal_weights"]
    y = cert["dual_deficit_multipliers_y"]
    z = cert["dual_lower_bound_multipliers_z"]

    assert len(A) == 16 and all(len(row) == 16 for row in A)
    assert len(m) == 16 and all(isinstance(v, int) and v >= 1 for v in m)
    assert len(y) == 16 and all(isinstance(v, int) and v >= 0 for v in y)
    assert len(z) == 16 and all(isinstance(v, int) and v >= 0 for v in z)

    # 1. Primal feasibility: A m >= 1 and sum(m) == 5454
    deficits = [sum(A[u][v] * m[v] for v in range(16)) for u in range(16)]
    assert deficits == cert["primal_deficits"]
    assert min(deficits) >= 1
    assert sum(m) == 5454

    # 2. Dual feasibility: A^T y + z == 1 and sum(y) + sum(z) == 5454
    for v in range(16):
        col_dot = sum(A[u][v] * y[u] for u in range(16)) + z[v]
        assert col_dot == 1, f"Column {v} stationarity failed: {col_dot}"
    assert sum(y) + sum(z) == 5454

    print("prototype_integer_optimality=passed optimal_vertices=5454 integrality_gap=0")

if __name__ == "__main__":
    main()
