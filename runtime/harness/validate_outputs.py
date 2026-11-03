#!/usr/bin/env python3
"""Fail closed on the minimum evidence contract for Batch 001."""

from __future__ import annotations

import csv
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "inputs" / "POSSIBLE_COUNTEREXAMPLES_ALL.csv"
RESULTS = ROOT / "outputs" / "results.csv"

EXPECTED_COLUMNS = [
    "ID",
    "title",
    "disposition",
    "exact_proposition",
    "counterexample_or_refutation",
    "verification_method",
    "verification_command",
    "source_urls",
    "source_excerpt_location",
    "confidence",
    "limitations",
]
ALLOWED_DISPOSITIONS = {
    "confirmed_counterexample",
    "published_refutation",
    "corrected_misstatement",
}


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    if not RESULTS.is_file():
        fail(f"missing {RESULTS}")

    with SOURCE.open(encoding="utf-8-sig", newline="") as handle:
        source_ids = {row["ID"].strip() for row in csv.DictReader(handle)}
    with RESULTS.open(encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames != EXPECTED_COLUMNS:
            fail(f"unexpected columns: {reader.fieldnames!r}")
        rows = list(reader)

    if not rows:
        fail("results.csv has no accepted rows")
    ids = [row["ID"].strip() for row in rows]
    if len(ids) != len(set(ids)):
        fail("duplicate accepted IDs")

    for row in rows:
        item_id = row["ID"].strip()
        if item_id not in source_ids:
            fail(f"ID {item_id} is absent from the supplied CSV")
        if row["disposition"].strip() not in ALLOWED_DISPOSITIONS:
            fail(f"ID {item_id} has invalid disposition")
        for field in (
            "title",
            "exact_proposition",
            "counterexample_or_refutation",
            "verification_method",
            "source_urls",
            "source_excerpt_location",
            "confidence",
        ):
            if not row[field].strip():
                fail(f"ID {item_id} has empty {field}")
        evidence_dir = ROOT / "evidence" / item_id
        if not (evidence_dir / "README.md").is_file():
            fail(f"ID {item_id} is missing evidence/{item_id}/README.md")
        if row["disposition"].strip() == "confirmed_counterexample":
            if not row["verification_command"].strip():
                fail(f"ID {item_id} counterexample lacks a verification command")
            if not any(evidence_dir.glob("*output*")):
                fail(f"ID {item_id} counterexample lacks archived checker output")

    print(f"PASS: {len(rows)} accepted rows satisfy the Batch 001 evidence contract")


if __name__ == "__main__":
    main()
