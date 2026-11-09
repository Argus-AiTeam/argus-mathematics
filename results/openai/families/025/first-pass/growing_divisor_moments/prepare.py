#!/usr/bin/env python3
"""Reuse the approved finite dependency slice without the fixed-order theorem."""

from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE.parent / "divisor_moment" / "Main.lean"


def source_text():
    base = BASE.read_text()
    prefix, marker, _ = base.partition("theorem uniform_divisor_moment (")
    if not marker:
        raise ValueError("The approved finite dependency boundary was not found.")
    bridge_start = base.index("theorem shifted_sum (")
    bridge_end = base.index("theorem uniform_divisor_moment_real (")
    helpers = base[bridge_start:bridge_end]
    return (
        prefix
        + "\nend ShortEgyptian\nend OAI\n\n"
        + "namespace DivisorMomentAudit\n"
        + "open scoped BigOperators\n"
        + "open Finset Filter OAI.ShortEgyptian\n\n"
        + helpers
        + "\nend DivisorMomentAudit\n\n"
        + (HERE / "growing.lean.txt").read_text()
    )


if __name__ == "__main__":
    (HERE / "Main.lean").write_text(source_text())
