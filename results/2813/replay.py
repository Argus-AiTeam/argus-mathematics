#!/usr/bin/env python3
"""Run both public exact-arithmetic checks for Result 2813."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def run(command: list[str], cwd: Path) -> bytes:
    return subprocess.check_output(command, cwd=cwd)


def main() -> None:
    witness_dir = ROOT / "witness"
    witness_output = run(
        [sys.executable, "verify_sstsst_minus_i.py"],
        witness_dir,
    )
    expected_witness = (witness_dir / "sstsst-minus-i-certificate.json").read_bytes()
    if witness_output != expected_witness:
        raise SystemExit("witness replay differs from the published certificate")

    equivalence_output = run([sys.executable, "verify_equivalence.py"], ROOT)
    equivalence = json.loads(equivalence_output)
    if equivalence.get("status") != "PASS":
        raise SystemExit("equivalence replay did not pass")

    print(json.dumps({
        "status": "PASS",
        "witness_certificate_byte_identical": True,
        "affine_noncollision_replay": equivalence,
    }, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
