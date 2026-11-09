#!/usr/bin/env python3
"""Compare the standalone root-based model with the staged implementation."""

import importlib.util
import json
import sys
from math import factorial
from pathlib import Path

import verify


def main():
    if not __debug__:
        raise SystemExit("Assertions must be enabled.")
    sys.dont_write_bytecode = True
    campaign = Path(__file__).resolve().parent.parent.parent
    relative = (
        "research/openai_manuscript/"
        "The-Campana-Peternell-conjecture-in-dimension-six-September-25-2026/"
        "verification/verify.py"
    )
    spec = importlib.util.spec_from_file_location("supplied_cp6", campaign / relative)
    supplied = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(supplied)
    A, columns, _, M, G, C1, _ = verify.build_constraints()
    original = supplied.mat(supplied.rows())
    assert original.shape == A.shape and (original - A).is_zero_matrix
    assert columns == tuple(next(iter(m)) for m in supplied.mons(9, supplied.gens))
    assert M == tuple(next(iter(m)) for m in supplied.M)
    assert G == tuple(next(iter(m)) for m in supplied.G)
    assert C1 == [(i, z[0]) for i, z in supplied.C]
    q, theta, psi = verify.characteristic_polynomials()
    for i in range(10):
        assert dict(q[i].items()) == dict(supplied.q[i].items())
        assert dict(theta[i].items()) == dict(supplied.td[i].items())
        old = sum(
            supplied.QQ((-1)**j, factorial(j)) * supplied.q[j] * supplied.td[i-j]
            for j in range(i + 1)
        )
        assert dict(psi[i].items()) == dict(old.items())
    c = 2*verify.h - verify.ell
    for i in range(1, 11):
        D = (c**i - q[i] - (-c)**i + verify.replace_h(q[i], verify.ell-verify.h)).exquo(c)
        assert dict(D.items()) == dict(supplied.D[i].items())
    result = {
        "status": "exact_coefficient_equality",
        "source": relative,
        "A_shape": list(A.shape),
        "A_rows_compared": 1785,
        "q_theta_psi_weights": [0, 9],
        "D_weights": [1, 10],
        "selected_coordinates_compared": 129,
        "supplied_full_verifier_executed": False,
        "independent_construction": "Root-factor Todd products and divided-difference integration.",
        "invocation": "env -u PYTHONOPTIMIZE PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python research/pseudoindex-five-audit/compare_source.py",
        "exit_status": 0,
    }
    (verify.ROOT / "source_comparison.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="ascii"
    )
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
