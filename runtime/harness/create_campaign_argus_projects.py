#!/usr/bin/env python3
"""Materialize one independent Argus workdir per active counterexample campaign."""

from __future__ import annotations

import csv
import json
import sys
from datetime import UTC, datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CAMPAIGN_IDS = (
    "1417", "1518", "1243", "1187", "8200002", "1900020", "2457", "20001578",
    "11000263", "20000786", "1994", "1285", "20000582", "2305027", "8", "1380", "2800203",
    "2338", "2662", "2669", "2862",
    "2248", "1921", "2775", "2813", "2884", "1465", "2307015", "6800022",
    "1413", "20001904",
)
PRIORITY_POOL = ROOT / "inputs" / "priority_pool.csv"

AGENTS = """# Independent counterexample Argus rules

- This directory owns exactly one conjecture and one Argus daemon.
- Search only for a counterexample or explicit negative witness. Do not spend
  the campaign proving the conjecture true.
- The authoritative original dataset and source audit are read-only at
  `/home/argustest/zimo/counterexample-batch-1`.
- Write all campaign artifacts inside this directory.
- Maintain `roles/planner/progress.json`, `roles/engineer/progress.json`, and
  `roles/reviewer/progress.json` with public operational status.
- Append public actions to `activity.jsonl` with fields
  `ts,role,agent,kind,action,status,artifact`. Never record hidden reasoning,
  credentials, or private chain-of-thought.
- Write all public-facing progress labels, activity actions, and summaries in
  English (mathematical notation may remain unchanged) so international viewers
  can follow the live workbench.
- A timeout, failed search, numerical near-solution, or finite boundary is not
  a counterexample. Require an independently rerunnable exact certificate.
- Use Jacobian only through the Argus sidecar bridge or the pinned executable
  `/home/argustest/zimo/references/jacobian/.venv/bin/jacobian`.
"""


def main() -> None:
    selected = tuple(sys.argv[1:]) or CAMPAIGN_IDS
    with PRIORITY_POOL.open(encoding="utf-8-sig", newline="") as handle:
        priority_rows = {
            str(row["ID"]): row for row in csv.DictReader(handle)
        }
    unknown = {
        campaign_id
        for campaign_id in selected
        if campaign_id not in CAMPAIGN_IDS and campaign_id not in priority_rows
    }
    if unknown:
        raise SystemExit(f"unknown campaign IDs: {sorted(unknown)}")
    for campaign_id in selected:
        source = ROOT / "proof-campaigns" / f"{campaign_id}.json"
        if source.is_file():
            campaign = json.loads(source.read_text(encoding="utf-8"))
        else:
            row = priority_rows[campaign_id]
            campaign = {
                "id": campaign_id,
                "title": row["题目"],
                "objective": (
                    row["具体描述"]
                    + " Independently determine the exact source-aligned statement "
                    "and produce a rigorous counterexample, correction, or status "
                    "resolution with a rerunnable certificate."
                ),
                "target_kind": "counterexample_only",
                "status": "active",
                "started_at": datetime.now(UTC).isoformat(),
                "why_selected": row["可能有反例的依据"],
                "known_boundary": (
                    "The current lead is not yet an accepted mathematical result. "
                    "Primary-source statement alignment, hypotheses, and the exact "
                    "negative witness must be verified independently."
                ),
                "source_leads": row["参考链接"],
                "source_page": row["原始来源网页"],
                "unsolvedmath_page": row["UnsolvedMath题目页"],
                "priority_score": int(row["priority_score"]),
            }
            source.parent.mkdir(parents=True, exist_ok=True)
            source.write_text(
                json.dumps(campaign, ensure_ascii=False, indent=2) + "\n",
                encoding="utf-8",
            )
        workdir = ROOT / "campaigns" / campaign_id
        workdir.mkdir(parents=True, exist_ok=True)
        (workdir / "AGENTS.md").write_text(AGENTS, encoding="utf-8")
        (workdir / "campaign.json").write_text(
            json.dumps(campaign, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        objective = f"""# Counterexample campaign {campaign_id}: {campaign['title']}

## Exact objective

{campaign['objective']}

## Current boundary

{campaign['known_boundary']}

## Execution contract

Run this as an independent Argus math campaign. Planner must freeze the exact
claim and a counterexample certificate. Engineer must execute multiple concrete
search strategies and record every batch in `activity.jsonl`. Reviewer remains
independent and checks only concrete candidates. Keep the public role progress
files current at least every two minutes while active.

Do not claim success without an exact witness and rerunnable certificate. If a
bounded route is exhausted, archive the boundary and immediately switch to a
materially different counterexample strategy.
"""
        (workdir / "OBJECTIVE.md").write_text(objective, encoding="utf-8")
        launch = f"""This is daemon bootstrap context. Route it to the existing `math`
vertical with a staged Planner -> Engineer -> independent Reviewer workflow.
The Manager decision must include an `EXECUTION_TASK` field containing this
standalone handoff:

Read `{workdir / 'OBJECTIVE.md'}` and execute the independent
counterexample-only campaign for ID {campaign_id}. Maintain the public
activity and role-progress files in this workdir and stop only at the exact
candidate-or-exhausted-boundary contract.
"""
        (workdir / "LAUNCH.md").write_text(launch, encoding="utf-8")
        print(workdir)


if __name__ == "__main__":
    main()
