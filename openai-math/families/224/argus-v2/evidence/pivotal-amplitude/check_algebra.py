#!/usr/bin/env python3
"""Recheck local rational identities, not the annular probabilistic identification."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[2]
PAPER = ROOT / "paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026"


def zero(expression):
    return sp.cancel(expression) == 0


def algebra():
    t = sp.symbols("t0:4")
    cot = {
        (i, j): (1 + t[i] * t[j]) / (t[i] - t[j])
        for i in range(4)
        for j in range(4)
        if i != j
    }
    triple_constants = []
    for triple in itertools.combinations(range(4), 3):
        cross = sum(
            cot[i, j] * cot[i, k]
            for i in triple
            for j, k in [tuple(v for v in triple if v != i)]
        )
        assert zero(cross + 1)
        assert not zero(cross)
        triple_constants.append(-1)
    # Expanding sum_i(sum_j cot_ij)^2 gives ordered squares plus twice
    # these triple cross terms; each ordered csc^2 is 1 + cot^2.
    csc_sum = sp.symbols("C")
    constant = 2 * sum(triple_constants) - len(cot)
    square_sum = csc_sum + constant
    assert constant == -20
    assert square_sum - csc_sum + 18 != 0

    def tuple_eigenvalue(power):
        return (
            -3 * power * csc_sum + (3 * power**2 + 2 * power) * square_sum
        ) / 32

    exponent = sp.Rational(1, 3)
    value = tuple_eigenvalue(exponent)
    assert zero(value + sp.Rational(5, 8))
    assert zero(2 * value + sp.Rational(5, 4))
    assert not zero(2 * value + 1)
    assert not zero(tuple_eigenvalue(sp.Rational(1, 4)) + sp.Rational(5, 8))
    assert sp.Rational(1, 8) + sp.Rational(3, 8) * exponent == sp.Rational(1, 4)
    assert zero(
        sp.Rational(1, 8) * csc_sum
        - sp.Rational(1, 6) * square_sum
        - (sp.Rational(10, 3) - csc_sum / 24)
    )

    gap = sp.symbols("gap", positive=True)
    zeta = gap / (4 * (2 + 2 * sp.Rational(5, 4) + gap))
    eta = gap / 8
    assert zero(-gap + 2 * eta + zeta * (2 + 2 * sp.Rational(5, 4) + gap) + gap / 2)
    print("PASS: cotangent identity as a rational-function identity in four variables")
    print("PASS: one-tuple eigenvalue -5/8, two-tuple eigenvalue -5/4")
    print("PASS: transformed drift coefficient 1/4 and Lyapunov identity")
    print("PASS: normalized determinant power is -nu'/2")
    print("PASS: wrong cotangent constant, eigenvalue and ground-state power rejected")


def source_hashes(tree_path):
    tree = json.loads(tree_path.read_text())
    parent = json.loads((tree_path.parent / "upstream-preprints-root.json").read_text())
    root = json.loads((tree_path.parent / "upstream-root.json").read_text())
    assert root["sha"] == "4eaee87548250b2682affda7d05d947c05554bae"
    assert next(e["sha"] for e in root["tree"] if e["path"] == "preprints") == parent["sha"]
    assert next(e["sha"] for e in parent["tree"] if e["path"] == PAPER.name) == tree["sha"]
    if tree.get("truncated"):
        raise ValueError("A truncated GitHub tree cannot certify source integrity")
    if tree.get("sha") != "fbce2c7e63d4e8d8446e10a78fd9b306bf390ed5":
        raise ValueError("Unexpected paper subtree; verify its link to the pinned commit")
    blobs = {e["path"]: e["sha"] for e in tree["tree"] if e["type"] == "blob"}
    checked = 0
    for path in sorted(PAPER.rglob("*")):
        if not path.is_file():
            continue
        relative = path.relative_to(PAPER).as_posix()
        data = path.read_bytes()
        actual = hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
        if relative not in blobs or actual != blobs[relative]:
            raise AssertionError(f"source mismatch: {relative}")
        checked += 1
    if checked != 11:
        raise AssertionError(f"expected 11 retained source files, found {checked}")
    print(f"PASS: all {checked} retained source files match the pinned upstream tree")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-tree", type=Path)
    args = parser.parse_args()
    algebra()
    if args.source_tree:
        source_hashes(args.source_tree)


if __name__ == "__main__":
    main()
