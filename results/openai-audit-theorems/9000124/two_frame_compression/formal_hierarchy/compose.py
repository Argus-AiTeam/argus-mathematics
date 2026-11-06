#!/usr/bin/env python3
"""Recompile the protocol, visibly generalizing its exhausted switch guard."""

import argparse
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent.parent
BASE = HERE.parent / "formal_protocol" / "Main.lean"
BASE_HASH = "662a1770644db33a1d534d78c15d878a2bb96dd3a70fd5ffe7e1424e4d0be086"
OLD_GUARD = """  rank_attained : r = 0 ∨ ∃ x ∈ Inside prepared (reverseTime T N.b) (reverseTime T N.a),
    x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x = r"""
NEW_GUARD = """  -- Exhaustion uses the source's final threshold h = |J| + 1.
  rank_attained : r = 0 ∨ r = Fintype.card Job ∨
    ∃ x ∈ Inside prepared (reverseTime T N.b) (reverseTime T N.a),
      x ∉ D N.frame.reverse N.right.reverse ∧ N.frame.reverse.rank x = r"""


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    raw = BASE.read_bytes()
    assert digest(raw) == BASE_HASH
    certificate = json.loads((BASE.parent / "evidence" / "lean_check.json").read_text())
    assert certificate["status"] == "success" and certificate["proof_holes"] == []
    assert certificate["source_sha256"] == BASE_HASH
    text = raw.decode()
    assert text.count(OLD_GUARD) == 1
    assert text.count("rank_attained") == 1, "Inspect any new semantic guard use before composing."
    transformed = text.replace(OLD_GUARD, NEW_GUARD)
    extension = (HERE / "Hierarchy.lean").read_text()
    assert transformed.startswith("import Mathlib\n")
    assert not any(
        line.lstrip().startswith("import ")
        for line in (transformed[len("import Mathlib\n") :] + extension).splitlines()
    )
    combined = (
        transformed
        + "\n-- BEGIN formal_hierarchy/Hierarchy.lean\n"
        + extension
        + "\n-- END formal_hierarchy/Hierarchy.lean\n"
    )
    metadata = {
        "unmodified_input": str(BASE.relative_to(ROOT)),
        "unmodified_input_sha256": BASE_HASH,
        "transformation": {
            "reason": "Allow source-final exhausted switched threshold h=|J|+1.",
            "exact_old_text": OLD_GUARD,
            "exact_new_text": NEW_GUARD,
            "old_guard_occurrences": 1,
            "all_guard_identifier_occurrences": 1,
            "semantic_theorem_uses_of_guard": 0,
            "previous_certificate_covers_transformation": False,
            "all_combined_theorems_must_be_recompiled": True,
        },
        "transformed_base_sha256": digest(transformed.encode()),
        "extension_sha256": digest(extension.encode()),
        "combined_sha256": digest(combined.encode()),
        "external_imports": ["Mathlib"],
    }
    manifest = json.dumps(metadata, indent=2) + "\n"
    if args.check:
        assert (HERE / "Main.lean").read_text() == combined
        assert (HERE / "composition.json").read_text() == manifest
        print("Exact visible guard transformation and standalone composition match.")
    else:
        (HERE / "Base.lean").write_text(transformed)
        (HERE / "Dev.lean").write_text("import Base\n" + extension)
        (HERE / "Main.lean").write_text(combined)
        (HERE / "composition.json").write_text(manifest)


if __name__ == "__main__":
    main()
