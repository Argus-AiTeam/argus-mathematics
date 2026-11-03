#!/usr/bin/env python3
"""Validate that the public open catalogue cannot contain unverified rows."""

from __future__ import annotations

import csv
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
AS_OF = "2026-08-27"
SOURCE = ROOT / "inputs" / "POSSIBLE_COUNTEREXAMPLES_ALL.csv"
OPEN = ROOT / "outputs" / f"open_problems_{AS_OF}.csv"
REMOVED = ROOT / "outputs" / f"resolved_removed_{AS_OF}.csv"
UNCERTAIN = ROOT / "outputs" / f"status_uncertain_{AS_OF}.csv"


def rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def main() -> None:
    source = rows(SOURCE)
    groups = {"open": rows(OPEN), "removed": rows(REMOVED), "uncertain": rows(UNCERTAIN)}
    source_ids = {row["ID"] for row in source}
    seen: set[str] = set()
    for name, group in groups.items():
        ids = {row["ID"] for row in group}
        if len(ids) != len(group):
            raise SystemExit(f"duplicate IDs in {name}")
        if seen & ids:
            raise SystemExit(f"overlapping IDs in {name}: {sorted(seen & ids)}")
        seen |= ids
    if seen != source_ids:
        raise SystemExit("catalogue partition does not match source IDs")
    for row in groups["open"]:
        if not (
            row["resolution_status"] == "open_confirmed"
            and row["claim_alignment"].startswith("exact")
            and row["review_status"] == "independently_verified"
            and row["evidence_level"] in {
                "primary_source_fulltext",
                "multiple_primary_full_texts",
                "multiple_primary_full_text_status_statements",
                "primary_full_text_peer_reviewed",
                "formal_artifact",
                "exact_computational_certificate",
                "direct_counterexample_proof_with_exact_symbolic_corroboration",
            }
        ):
            raise SystemExit(f"unsafe public open row: {row['ID']}")
    print(
        f"PASS: {len(source)} rows partitioned into "
        f"{len(groups['open'])} open, {len(groups['removed'])} removed, "
        f"{len(groups['uncertain'])} uncertain"
    )


if __name__ == "__main__":
    main()
