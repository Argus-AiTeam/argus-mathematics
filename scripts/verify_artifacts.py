#!/usr/bin/env python3
"""Verify the integrity of the archived public result artifacts."""

from __future__ import annotations

import hashlib
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
CHECKSUMS = ROOT / "SHA256SUMS"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    checked = 0
    for line in CHECKSUMS.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        expected, relative = line.split(maxsplit=1)
        path = ROOT / relative
        if not path.is_file():
            raise SystemExit(f"missing artifact: {relative}")
        actual = sha256(path)
        if actual != expected:
            raise SystemExit(
                f"checksum mismatch: {relative}\n"
                f"expected {expected}\n"
                f"actual   {actual}"
            )
        checked += 1
    print(f"artifact_integrity=passed files={checked}")


if __name__ == "__main__":
    main()

