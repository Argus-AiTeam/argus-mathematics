#!/usr/bin/env python3
"""Reproduce the standalone source without editing either certified module."""

import hashlib
import json
import argparse
from pathlib import Path

HERE = Path(__file__).resolve().parent
PREFIX = HERE.parent
CAMPAIGN = PREFIX.parent.parent
SOURCES = (
    PREFIX / "formal_lists" / "Main.lean",
    PREFIX / "formal_boundary" / "Main.lean",
    HERE / "Integration.lean",
)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    pieces = ["import Mathlib\n"]
    manifest = []
    for path in SOURCES:
        raw = path.read_bytes()
        text = raw.decode()
        if path.parent != HERE:
            assert text.startswith("import Mathlib\n")
            certificate = path.parent / "evidence" / "lean_check.json"
            certified = json.loads(certificate.read_text())
            assert hashlib.sha256(raw).hexdigest() == certified["source_sha256"]
            body = text[len("import Mathlib\n") :]
        else:
            assert not any(line.startswith("import ") for line in text.splitlines())
            body = text
        pieces.append(f"\n-- BEGIN {path.relative_to(CAMPAIGN)}\n")
        pieces.append(body)
        pieces.append(f"\n-- END {path.relative_to(CAMPAIGN)}\n")
        manifest.append(
            {
                "path": str(path.relative_to(CAMPAIGN)),
                "sha256": hashlib.sha256(raw).hexdigest(),
                "composition": "unchanged body; initial Mathlib import hoisted"
                if path.parent != HERE
                else "unchanged",
            }
        )
    combined = "".join(pieces)
    metadata = (
        json.dumps(
            {
                "sources": manifest,
                "combined_sha256": hashlib.sha256(combined.encode()).hexdigest(),
                "external_imports": ["Mathlib"],
            },
            indent=2,
        )
        + "\n"
    )
    dev = (
        "import formal_lists.Main\nimport formal_boundary.Main\n"
        + SOURCES[-1].read_text()
    )
    if args.check:
        assert (HERE / "Main.lean").read_text() == combined
        assert (HERE / "composition.json").read_text() == metadata
        print("Exact composition and both certified source hashes match.")
    else:
        (HERE / "Main.lean").write_text(combined)
        (HERE / "composition.json").write_text(metadata)
        (HERE / "Dev.lean").write_text(dev)


if __name__ == "__main__":
    main()
