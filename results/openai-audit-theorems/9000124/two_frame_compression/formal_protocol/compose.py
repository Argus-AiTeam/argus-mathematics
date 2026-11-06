#!/usr/bin/env python3
"""Bind the unchanged certified construction and the protocol proof."""

import argparse
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent.parent
BASE = HERE.parent / "formal_construction" / "Main.lean"
SOURCES = (BASE, HERE / "Protocol.lean")


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certified = json.loads((BASE.parent / "evidence" / "lean_check.json").read_text())
    assert certified["status"] == "success"
    assert certified["proof_holes"] == []
    assert digest(BASE.read_bytes()) == certified["source_sha256"]
    pieces = ["import Mathlib\n"]
    manifest = []
    for path in SOURCES:
        raw = path.read_bytes()
        text = raw.decode()
        hoisted = text.startswith("import Mathlib\n")
        if hoisted:
            text = text[len("import Mathlib\n") :]
        assert not any(line.lstrip().startswith("import ") for line in text.splitlines())
        relative = str(path.relative_to(ROOT))
        pieces.extend((f"\n-- BEGIN {relative}\n", text, f"\n-- END {relative}\n"))
        manifest.append(
            {
                "path": relative,
                "sha256": digest(raw),
                "composition": "unchanged body; initial Mathlib import hoisted"
                if hoisted else "unchanged",
            }
        )
    combined = "".join(pieces)
    metadata = json.dumps(
        {
            "sources": manifest,
            "combined_sha256": digest(combined.encode()),
            "external_imports": ["Mathlib"],
            "certified_base_source_sha256": certified["source_sha256"],
        },
        indent=2,
    ) + "\n"
    if args.check:
        assert (HERE / "Main.lean").read_text() == combined
        assert (HERE / "composition.json").read_text() == metadata
        print("Exact composition and certified construction hash match.")
    else:
        (HERE / "Main.lean").write_text(combined)
        (HERE / "composition.json").write_text(metadata)
        (HERE / "Dev.lean").write_text("import Main\n" + SOURCES[-1].read_text())


if __name__ == "__main__":
    main()
