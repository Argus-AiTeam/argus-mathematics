#!/usr/bin/env python3
"""Supervise the counterexample/audit fleet and the public live-data path."""

from __future__ import annotations

import csv
import hashlib
import json
import os
import re
import signal
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
WORKSPACE = ROOT.parent
DEFAULT_CAMPAIGN_IDS = (
    "1417",
    "1518",
    "1243",
    "8200002",
    "1900020",
    "2457",
    "1994",
    "1285",
    "20000582",
    "2305027",
    "8",
    "1380",
    "2338",
    "2669",
    "2862",
    "2248",
    "1921",
    "2813",
    "2884",
    "2307015",
)
CAMPAIGN_POOL_IDS = (
    "3395",
    "1138",
    "20002392",
    "40",
    "1275",
    "9400078",
    "7200051",
    "3059",
    "3102",
    "20001675",
    "3167",
    "3256",
    "9400114",
    "20000278",
    "20000715",
    "20000816",
    "20001036",
    "20001274",
    "20001352",
    "20001516",
    "20001602",
    "20001849",
    "1417",
    "1518",
    "1243",
    "1187",
    "8200002",
    "1900020",
    "2457",
    "20001578",
    "11000263",
    "20000786",
    "1994",
    "1285",
    "20000582",
    "2305027",
    "8",
    "1380",
    "2800203",
    "2338",
    "2662",
    "2669",
    "2862",
    "2248",
    "1921",
    "2775",
    "2813",
    "2884",
    "1465",
    "2307015",
    "6800022",
    "1413",
    "20001904",
)
CAMPAIGN_TARGET_COUNT = 17
PROOF_TIMEBOX_SECONDS = 365 * 24 * 60 * 60
PROOF_TIMEBOX_EVIDENCE = ROOT / "supervisor-evidence" / "five-day-retirements"
# Refreshed from persisted rotation state at the start of every supervisor pass.
CAMPAIGN_IDS = DEFAULT_CAMPAIGN_IDS
AUDIT_RUNTIMES = {
    "01": {
        "home": WORKSPACE / ".argus-audit-shard-01-run3",
        "workdir_suffix": "",
        "home_suffix": "-run3",
    },
    "02": {
        "home": WORKSPACE / ".argus-audit-shard-02-retry2",
        "workdir_suffix": "-retry1",
        "home_suffix": "-retry2",
    },
}
SITE_SERVICES: tuple[str, ...] = ()
OUTPUT = ROOT / "outputs" / "fleet-supervisor.json"
STATE = ROOT / "outputs" / "fleet-supervisor-state.json"
LIVE_DATA = WORKSPACE / "open-conjectures-live" / "public" / "open-data.json"
CATALOG_DATA = WORKSPACE / "open-conjectures-live" / "public" / "catalog-table.json"
CHROME = Path("/usr/bin/google-chrome")
CAMPAIGN_LAUNCHER = ROOT / "scripts" / "launch_campaign_argus.py"
AUDIT_LAUNCHER = ROOT / "scripts" / "launch_audit_argus.py"
PYTHON = Path("/home/argustest/miniconda3/bin/python")
ARGUS_SOURCE = WORKSPACE / "argus-live-update"
ARGUS_PYTHON = ARGUS_SOURCE / ".venv" / "bin" / "python"
RESTART_COOLDOWN_SECONDS = 300
PROVIDER_RELEASE_COOLDOWN_SECONDS = 60
STALE_SECONDS = 900
TERMINAL_RESPONSE_STALL_SECONDS = 120
AGENT_IO_TAIL_BYTES = 8_000_000
HTTP_JSON_MAX_BYTES = 16_000_000
BROWSER_RENDER_INTERVAL_SECONDS = 120
BROWSER_RENDER_SCHEMA_VERSION = 16
DISK_HEAVY_JOB_HEADROOM_BYTES = 1024 * 1024 * 1024
BROWSER_RENDER_HEADROOM_BYTES = 4 * 1024 * 1024 * 1024
Q384_RAW_PROOF_HEADROOM_BYTES = 16 * 1024 * 1024 * 1024
Q384_RAW_PROOF_MARKERS = (
    "q384-canonical-coordinate-kernel",
    "q384-seed-free-union-decision-v1",
)
MAX_1417_HYBRID_PREFIX_CONCURRENCY = 8
MAX_1417_CONCURRENCY_VIOLATIONS_BEFORE_PROVIDER_RELEASE = 3
CONCURRENCY_VIOLATION_WINDOW_SECONDS = 600
PROFESSIONAL_PDF_POLICY_EFFECTIVE = "2026-08-30T06:21:00Z"
PROFESSIONAL_PDF_GRANDFATHERED_IDS = frozenset(
    {
        "11000263",
        "1100101",
        "1100501",
        "1200029",
        "1350",
        "20001068",
        "20001760",
    }
)
CONFIRMED_NOVELTY_STATUS = "independent_novelty_review_passed"


def novelty_gate_passed(signal: dict[str, Any]) -> bool:
    return bool(
        signal.get("project_produced")
        and signal.get("novelty_status") == CONFIRMED_NOVELTY_STATUS
        and signal.get("novelty_reviewer_status") == "accepted"
    )


def now_iso() -> str:
    return datetime.now(UTC).isoformat()


def load_json(path: Path, default: Any) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return default


def iso_epoch(value: object) -> float:
    text = str(value or "").strip()
    if not text:
        return 0.0
    try:
        return datetime.fromisoformat(text.replace("Z", "+00:00")).timestamp()
    except ValueError:
        return 0.0


def write_json_atomic(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    try:
        temporary.write_text(
            json.dumps(value, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)


def write_text_atomic(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    try:
        temporary.write_text(value, encoding="utf-8")
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)


def campaign_is_completed(campaign_id: str) -> bool:
    workdir = ROOT / "campaigns" / campaign_id
    if (workdir / "SUPERVISOR_COMPLETED.json").is_file():
        return True
    campaign = load_json(workdir / "campaign.json", {})
    return str(campaign.get("state") or campaign.get("status") or "").lower() in {
        "complete",
        "completed",
    }


def campaign_is_operator_retired(campaign_id: str) -> bool:
    return (ROOT / "campaigns" / campaign_id / "SUPERVISOR_RETIRED.json").is_file()


def campaign_started_at(campaign_id: str) -> float:
    workdir = ROOT / "campaigns" / campaign_id
    objective = workdir / "OBJECTIVE.md"
    try:
        return objective.stat().st_mtime
    except OSError:
        try:
            return workdir.stat().st_mtime
        except OSError:
            return time.time()


def campaign_title(campaign_id: str) -> str:
    objective = ROOT / "campaigns" / campaign_id / "OBJECTIVE.md"
    try:
        for line in objective.read_text(encoding="utf-8").splitlines():
            if line.startswith("#"):
                return re.sub(r"^#+\s*", "", line).strip()
    except OSError:
        pass
    return f"Campaign {campaign_id}"


def campaign_activity_summary(campaign_id: str, limit: int = 5) -> list[dict[str, str]]:
    workdir = ROOT / "campaigns" / campaign_id
    records: list[dict[str, str]] = []
    activity = workdir / "activity.jsonl"
    try:
        lines = activity.read_text(encoding="utf-8").splitlines()
    except OSError:
        lines = []
    for line in lines:
        try:
            payload = json.loads(line)
        except json.JSONDecodeError:
            continue
        action = " ".join(str(payload.get("action") or "").split())
        if not action:
            continue
        kind = str(payload.get("kind") or "").lower()
        status = str(payload.get("status") or "").lower()
        if any(
            token in kind
            for token in ("pulse", "liveness", "checkpoint", "progress")
        ) and status in {"in_progress", "working", "implementation"}:
            continue
        records.append(
            {
                "ts": str(payload.get("ts") or ""),
                "status": str(payload.get("status") or ""),
                "kind": str(payload.get("kind") or ""),
                "action": action[:900],
            }
        )
    if records:
        return records[-limit:]

    role_progress = workdir / "ROLE_PROGRESS.md"
    try:
        compact = [
            line.strip()
            for line in role_progress.read_text(encoding="utf-8").splitlines()
            if line.strip()
        ]
    except OSError:
        compact = []
    if compact:
        return [
            {
                "ts": "",
                "status": "preserved_role_progress",
                "kind": "role_progress",
                "action": " ".join(compact[-20:])[:1800],
            }
        ]
    return []


def write_five_day_retirement_summary(
    campaign_id: str,
    *,
    started_at: float,
    retired_at: float,
) -> Path:
    evidence_dir = PROOF_TIMEBOX_EVIDENCE / campaign_id
    summary_path = evidence_dir / "SUMMARY.md"
    start_text = datetime.fromtimestamp(started_at, UTC).isoformat()
    retire_text = datetime.fromtimestamp(retired_at, UTC).isoformat()
    activity = campaign_activity_summary(campaign_id)
    lines = [
        f"# Five-day proof-timebox retirement: {campaign_id}",
        "",
        f"- Objective: {campaign_title(campaign_id)}",
        f"- Campaign start: {start_text}",
        f"- Retirement time: {retire_text}",
        "- Final status: no completed proof or counterexample marker within five days",
        "- Data policy: all campaign files and exact certificates are preserved",
        "",
        "## Preserved result frontier",
        "",
    ]
    if activity:
        for item in activity:
            label = " · ".join(
                value
                for value in (item["ts"], item["kind"], item["status"])
                if value
            )
            lines.extend((f"- {label}", f"  {item['action']}", ""))
    else:
        lines.extend(("- No structured activity summary was available.", ""))
    lines.extend(
        (
            "## Retirement boundary",
            "",
            "The preserved work may contain exact partial lemmas, route exclusions,",
            "or conditional certificates, but the campaign did not complete its main",
            "proof/counterexample objective inside the operator's five-day API",
            "timebox. The daemon and campaign-owned detached computations were stopped.",
            "No mathematical nonexistence conclusion is inferred from retirement.",
            "",
        )
    )
    write_text_atomic(summary_path, "\n".join(lines))
    marker = ROOT / "campaigns" / campaign_id / "SUPERVISOR_RETIRED.json"
    write_json_atomic(
        marker,
        {
            "schema_version": 1,
            "campaign_id": campaign_id,
            "status": "retired_unfinished",
            "reason": "five_day_no_completed_proof",
            "started_at": start_text,
            "retired_at": retire_text,
            "summary": str(summary_path.relative_to(ROOT)),
        },
    )
    return summary_path


def select_active_campaign_ids(
    state: dict[str, Any],
) -> tuple[tuple[str, ...], list[dict[str, Any]]]:
    """Keep the compute fleet full while preserving completed artifacts."""
    configured = state.get("active_campaign_ids")
    if not isinstance(configured, list):
        configured = list(DEFAULT_CAMPAIGN_IDS)

    operator_retired = {
        str(campaign_id)
        for campaign_id in state.get("operator_retired_campaign_ids", [])
    }
    active: list[str] = []
    for raw_id in configured:
        campaign_id = str(raw_id)
        if campaign_id not in CAMPAIGN_POOL_IDS or campaign_id in active:
            continue
        if (
            campaign_is_completed(campaign_id)
            or campaign_id in operator_retired
            or campaign_is_operator_retired(campaign_id)
        ):
            continue
        active.append(campaign_id)

    target_count = max(
        0,
        int(state.get("campaign_target_count", CAMPAIGN_TARGET_COUNT)),
    )
    overflow = active[target_count:]
    active = active[:target_count]

    previous = [
        str(campaign_id)
        for campaign_id in configured
        if str(campaign_id) in CAMPAIGN_POOL_IDS
    ]
    retired = [
        campaign_id
        for campaign_id in previous
        if campaign_is_completed(campaign_id)
    ]
    replacements: list[str] = []
    if bool(state.get("auto_refill_campaign_slots", True)):
        for campaign_id in CAMPAIGN_POOL_IDS:
            if len(active) >= target_count:
                break
            if (
                campaign_id in active
                or campaign_is_completed(campaign_id)
                or campaign_id in operator_retired
                or campaign_is_operator_retired(campaign_id)
            ):
                continue
            active.append(campaign_id)
            replacements.append(campaign_id)

    state["active_campaign_ids"] = active
    if retired:
        already_retired = {
            str(campaign_id)
            for campaign_id in state.get("retired_campaign_ids", [])
        }
        already_retired.update(retired)
        state["retired_campaign_ids"] = sorted(already_retired)

    actions: list[dict[str, Any]] = []
    if retired or replacements or overflow:
        actions.append(
            {
                "target": "campaign-fleet",
                "action": "rotate_completed_campaign_slots",
                "retired_completed": retired,
                "trimmed_for_resource_cap": overflow,
                "activated_replacements": replacements,
                "active_campaign_count": len(active),
                "target_campaign_count": target_count,
            }
        )
    return tuple(active), actions


def pid_alive(pid: object) -> bool:
    try:
        numeric_pid = int(pid)
        os.kill(numeric_pid, 0)
    except (OSError, TypeError, ValueError):
        return False
    try:
        stat_tail = (
            Path(f"/proc/{numeric_pid}/stat")
            .read_text(encoding="utf-8")
            .rsplit(")", 1)[1]
            .split()
        )
    except (OSError, IndexError):
        return False
    if stat_tail and stat_tail[0] == "Z":
        return False
    return True


def exact_campaign_homes(campaign_id: str) -> list[Path]:
    prefix = f".argus-campaign-{campaign_id}"
    return [
        path
        for path in WORKSPACE.iterdir()
        if path.is_dir()
        and (path.name == prefix or path.name.startswith(f"{prefix}-"))
    ]


def next_campaign_run_suffix(campaign_id: str) -> str:
    prefix = f".argus-campaign-{campaign_id}"
    highest = 1 if (WORKSPACE / prefix).is_dir() else 0
    for home in exact_campaign_homes(campaign_id):
        match = re.fullmatch(rf"{re.escape(prefix)}-run([0-9]+)", home.name)
        if match:
            highest = max(highest, int(match.group(1)))
    return f"-run{max(2, highest + 1)}"


def latest_life(homes: list[Path]) -> Path | None:
    candidates: list[tuple[int, float, float, Path]] = []
    for home in homes:
        projects = home / "projects"
        if not projects.is_dir():
            continue
        for life in projects.iterdir():
            if not life.is_dir():
                continue
            status = life / "daemon.status.json"
            payload: dict[str, Any] = {}
            started_ts = 0.0
            if status.is_file():
                payload = load_json(status, {})
                started_at = str(payload.get("started_at_iso") or "").strip()
                try:
                    started_ts = datetime.fromisoformat(
                        started_at.replace("Z", "+00:00")
                    ).timestamp()
                except ValueError:
                    started_ts = 0.0
            # A graceful daemon stop removes daemon.status.json.  Keep that
            # just-stopped life eligible by ranking all lives on durable
            # activity files; otherwise an older home with a stale status (or
            # upgrade request) can be selected and restarted during the brief
            # boundary-upgrade window.
            activity_mtimes: list[float] = []
            for marker in (
                status,
                life / "continuous.json",
                life / "mission-view.json",
                life / "events.jsonl",
                life / "daemon.health.json",
            ):
                try:
                    activity_mtimes.append(marker.stat().st_mtime)
                except OSError:
                    continue
            try:
                activity_mtimes.append(life.stat().st_mtime)
            except OSError:
                pass
            candidates.append(
                (
                    int(pid_alive(payload.get("pid"))),
                    max(activity_mtimes, default=0.0),
                    started_ts,
                    life,
                )
            )
    return max(candidates, default=(0, 0.0, 0.0, None))[3]


def child_process_ids(pid: int) -> list[int]:
    children: set[int] = set()
    task_dir = Path(f"/proc/{pid}/task")
    try:
        child_files = list(task_dir.glob("*/children"))
    except OSError:
        return []
    for children_path in child_files:
        try:
            children.update(int(item) for item in children_path.read_text().split())
        except (OSError, ValueError):
            continue
    return sorted(children)


def descendant_process_ids(pid: int) -> list[int]:
    descendants: set[int] = set()
    pending = [pid]
    while pending:
        current = pending.pop()
        children = child_process_ids(current)
        for child in children:
            if child in descendants:
                continue
            descendants.add(child)
            pending.append(child)
    return sorted(descendants)


def descendant_commands(pid: int) -> list[str]:
    commands: list[str] = []
    pending = [pid]
    seen: set[int] = set()
    while pending:
        current = pending.pop()
        if current in seen:
            continue
        seen.add(current)
        children = child_process_ids(current)
        pending.extend(children)
        for child in children:
            try:
                raw = Path(f"/proc/{child}/cmdline").read_bytes()
                commands.append(raw.replace(b"\0", b" ").decode("utf-8", "replace"))
            except OSError:
                pass
    return commands


def external_durable_jobs_by_workdir() -> dict[str, list[dict[str, Any]]]:
    candidates: dict[str, dict[str, Any]] = {}
    for process_dir in Path("/proc").iterdir():
        if not process_dir.name.isdigit():
            continue
        try:
            raw = (process_dir / "cmdline").read_bytes()
            command = raw.replace(b"\0", b" ").decode("utf-8", "replace").strip()
            is_submit = "argus_skill.tools.subagent submit" in command
            is_wrapper = "argus-durable-job" in command
            if not (is_submit or is_wrapper):
                continue
            workdir = str((process_dir / "cwd").resolve(strict=True))
        except OSError:
            continue
        task_match = re.search(r"--task-id(?:=|\s+)([^\s]+)", command)
        if task_match is None:
            task_match = re.search(r"/\.argus_subagents/([^/\s]+)_logs/", command)
        task_id = task_match.group(1) if task_match else f"pid-{process_dir.name}"
        record = {
            "pid": int(process_dir.name),
            "task_id": task_id,
            "workdir": workdir,
            "command": command[-1000:],
            "process_kind": "submit" if is_submit else "wrapper",
        }
        previous = candidates.get(task_id)
        if previous is None or (
            record["process_kind"] == "submit"
            and previous.get("process_kind") != "submit"
        ):
            candidates[task_id] = record
    jobs: dict[str, list[dict[str, Any]]] = {}
    for record in candidates.values():
        workdir = str(record["workdir"])
        jobs.setdefault(workdir, []).append(
            {
                "pid": record["pid"],
                "task_id": record["task_id"],
                "workdir": workdir,
                "command": record["command"],
            }
        )
    for records in jobs.values():
        records.sort(key=lambda item: str(item.get("task_id", "")))
    return jobs


def external_jobs_under(
    jobs_by_workdir: dict[str, list[dict[str, Any]]],
    project_root: Path,
) -> list[dict[str, Any]]:
    try:
        resolved_root = project_root.resolve(strict=True)
    except OSError:
        return []
    jobs: list[dict[str, Any]] = []
    for workdir, records in jobs_by_workdir.items():
        try:
            Path(workdir).relative_to(resolved_root)
        except ValueError:
            continue
        jobs.extend(records)
    jobs.sort(key=lambda item: str(item.get("task_id", "")))
    return jobs


def provider_descendant_pids(pid: int) -> list[int]:
    providers: list[int] = []
    pending = [pid]
    seen: set[int] = set()
    while pending:
        current = pending.pop()
        if current in seen:
            continue
        seen.add(current)
        children = child_process_ids(current)
        pending.extend(children)
        for child in children:
            try:
                command = (
                    Path(f"/proc/{child}/cmdline")
                    .read_bytes()
                    .replace(b"\0", b" ")
                    .decode("utf-8", "replace")
                )
            except OSError:
                continue
            if any(token in command for token in ("copilot", "codex", "claude")):
                providers.append(child)
    return providers


def latest_completed_response(life: Path) -> tuple[float, str] | None:
    path = life / "agent_io.jsonl"
    try:
        size = path.stat().st_size
        with path.open("rb") as handle:
            offset = max(0, size - AGENT_IO_TAIL_BYTES)
            handle.seek(offset)
            raw = handle.read()
    except OSError:
        return None
    lines = raw.splitlines()
    if offset and lines:
        lines = lines[1:]
    for raw_line in reversed(lines):
        if b"model.response" not in raw_line:
            continue
        try:
            outer = json.loads(raw_line)
            inner = json.loads(str(outer.get("line") or ""))
        except (json.JSONDecodeError, UnicodeDecodeError):
            continue
        if inner.get("type") != "model.response":
            continue
        response = (inner.get("data") or {}).get("response") or {}
        if (
            response.get("responses_message_status") == "completed"
            and response.get("phase") == "final_answer"
        ):
            return float(outer.get("ts") or 0), str(outer.get("run_label") or "")
    return None


def latest_active_role_provider_start(life: Path, active_role: str) -> float:
    """Return the newest provider request start for the current role."""
    path = life / "events.jsonl"
    try:
        size = path.stat().st_size
        with path.open("rb") as handle:
            offset = max(0, size - AGENT_IO_TAIL_BYTES)
            handle.seek(offset)
            raw = handle.read()
    except OSError:
        return 0.0
    lines = raw.splitlines()
    if offset and lines:
        lines = lines[1:]
    role = active_role.casefold()
    for raw_line in reversed(lines):
        try:
            event = json.loads(raw_line)
        except (json.JSONDecodeError, UnicodeDecodeError):
            continue
        if event.get("type") != "agent.io.start":
            continue
        run_label = str(event.get("run_label") or "").casefold()
        if run_label.startswith(role):
            return float(event.get("ts") or 0)
    return 0.0


def runtime_record(
    label: str,
    homes: list[Path],
    *,
    expected_campaign_id: str = "",
    expected_audit_workdir: str = "",
    external_jobs: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:
    completion: dict[str, Any] = {}
    if expected_campaign_id:
        marker = ROOT / "campaigns" / expected_campaign_id / "SUPERVISOR_COMPLETED.json"
        payload = load_json(marker, {})
        if (
            isinstance(payload, dict)
            and payload.get("status") == "completed"
            and str(payload.get("campaign_id")) == expected_campaign_id
        ):
            completion = payload
        else:
            life_candidate = latest_life(homes)
            if life_candidate is not None:
                w_ps = ROOT / "campaigns" / expected_campaign_id / ".argus" / "PIPELINE_STATE.json"
                l_ps = life_candidate / ".argus" / "PIPELINE_STATE.json"
                if w_ps.is_file() and l_ps.is_file():
                    w_data = load_json(w_ps, {})
                    l_data = load_json(l_ps, {})
                    stage_rank = {"scope": 0, "solve": 1, "review": 2}
                    if isinstance(w_data, dict) and isinstance(l_data, dict):
                        l_st = str(l_data.get("current_stage") or "scope")
                        w_st = str(w_data.get("current_stage") or "scope")
                        if stage_rank.get(l_st, 0) > stage_rank.get(w_st, 0) or l_data.get("stages") != w_data.get("stages"):
                            w_data["current_stage"] = l_st
                            if l_data.get("stages"):
                                w_data["stages"] = l_data["stages"]
                            if l_data.get("stage_history"):
                                w_data["stage_history"] = l_data["stage_history"]
                            try:
                                write_json_atomic(w_ps, w_data)
                            except OSError:
                                pass
            for ps_root in (
                [life_candidate, ROOT / "campaigns" / expected_campaign_id]
                if life_candidate is not None
                else [ROOT / "campaigns" / expected_campaign_id]
            ):
                ps_data = load_json(ps_root / ".argus" / "PIPELINE_STATE.json", {})
                rev_stage = (
                    (ps_data.get("stages") or {}).get("review")
                    if isinstance(ps_data, dict)
                    and isinstance(ps_data.get("stages"), dict)
                    else None
                )
                if (
                    isinstance(ps_data, dict)
                    and str(ps_data.get("current_stage") or "") == "review"
                    and isinstance(rev_stage, dict)
                    and str(rev_stage.get("status") or "") == "done"
                    and str(rev_stage.get("completion_contract_sha256") or "")
                ):
                    completion = {
                        "campaign_id": expected_campaign_id,
                        "status": "completed",
                        "completed_at": now_iso(),
                        "completion_contract_sha256": rev_stage.get(
                            "completion_contract_sha256"
                        ),
                    }
                    try:
                        write_json_atomic(marker, completion)
                    except OSError:
                        pass
                    break
    elif expected_audit_workdir:
        marker = (
            ROOT
            / "audit-shards"
            / expected_audit_workdir
            / "SUPERVISOR_COMPLETED.json"
        )
        payload = load_json(marker, {})
        if (
            isinstance(payload, dict)
            and payload.get("status") == "completed"
            and str(payload.get("audit_workdir")) == expected_audit_workdir
        ):
            completion = payload
    if completion:
        live_completed_runtime = False
        for home in homes:
            projects = home / "projects"
            if not projects.is_dir():
                continue
            for status_path in projects.glob("*/daemon.status.json"):
                status_payload = load_json(status_path, {})
                if pid_alive(status_payload.get("pid")):
                    live_completed_runtime = True
                    break
            if live_completed_runtime:
                break
        if not live_completed_runtime:
            return {
                "label": label,
                "state": "completed",
                "alive": False,
                "completed": True,
                "completion": completion,
            }
    life = latest_life(homes)
    if life is None:
        if completion:
            return {
                "label": label,
                "state": "completed",
                "alive": False,
                "completed": True,
                "completion": completion,
            }
        return {"label": label, "state": "missing", "alive": False}
    status_path = life / "daemon.status.json"
    mission_path = life / "mission-view.json"
    status = load_json(status_path, {})
    mission = load_json(mission_path, {})
    pid = status.get("pid")
    alive = pid_alive(pid)
    activity_mtimes: list[float] = []
    for marker in (status_path, mission_path, life):
        try:
            activity_mtimes.append(marker.stat().st_mtime)
        except OSError:
            continue
    updated_at = max(activity_mtimes, default=time.time())
    age = max(0, int(time.time() - updated_at))
    active_role = str(mission.get("active_role", ""))
    role_records = list(mission.get("roles", []))
    role_states = {
        str(role.get("role", "")): str(role.get("status", ""))
        for role in role_records
    }
    role_error = any(status == "error" for status in role_states.values())
    role_error_updated_at = max(
        (
            float(role.get("updated_at") or 0)
            for role in role_records
            if str(role.get("status", "")) == "error"
        ),
        default=0,
    )
    later_role_progress_at = max(
        (
            float(role.get("updated_at") or 0)
            for role in role_records
            if str(role.get("status", "")) != "error"
        ),
        default=0,
    )
    # A Planner failure can be historical: the harness may subsequently run
    # Engineer and Reviewer rounds successfully.  Only treat the role error as
    # unresolved when no later role transition has superseded it.
    unresolved_role_error = bool(
        role_error and role_error_updated_at >= later_role_progress_at
    )
    role_updated_at = max(
        (float(role.get("updated_at") or 0) for role in role_records),
        default=0,
    )
    active_role_updated_at = max(
        (
            float(role.get("updated_at") or 0)
            for role in role_records
            if str(role.get("role", "")) == active_role
        ),
        default=0,
    )
    role_age = max(0, int(time.time() - role_updated_at)) if role_updated_at else None
    commands = descendant_commands(int(pid)) if alive else []
    backend_active = any(
        token in command
        for command in commands
        for token in ("copilot", "codex", "claude", "gemini")
    )
    mission_info = mission.get("mission") or {}
    # A failed mission can leave the Manager marked active while one of the
    # executed roles is already in ``error``.  The provider/session child may
    # also remain alive after the mission completion event, so the generic
    # active-role/backend checks are not evidence of forward progress.  Once
    # that contradictory state is old enough to exclude a transient commit,
    # recover it as a role failure in a fresh campaign life.
    failed_mission_role_stall = bool(
        mission_info.get("status") == "failed"
        and unresolved_role_error
        and role_age is not None
        and role_age >= TERMINAL_RESPONSE_STALL_SECONDS
    )
    engineer_progress = (
        load_json(
            ROOT
            / "campaigns"
            / expected_campaign_id
            / "roles"
            / "engineer"
            / "progress.json",
            {},
        )
        if expected_campaign_id
        else {}
    )
    engineer_progress_updated = iso_epoch(engineer_progress.get("updated_at"))
    mission_started_at = float(mission_info.get("started_at") or 0)
    pending_reviewer_handoff = bool(
        str(engineer_progress.get("next_owner") or "").strip().casefold()
        == "reviewer"
        and str(engineer_progress.get("status") or "").strip().casefold()
        in {"done", "completed", "ready_for_review"}
        and engineer_progress_updated >= mission_started_at
        and active_role != "engineer"
    )
    current_time = time.time()
    mission_completed_at = float(mission_info.get("completed_at") or 0)
    failed_mission_active_stall = bool(
        mission_info.get("status") == "failed"
        and active_role
        and mission_completed_at
        and active_role_updated_at <= mission_completed_at + 5
        and current_time - mission_completed_at >= TERMINAL_RESPONSE_STALL_SECONDS
    )
    completed_response = (
        latest_completed_response(life)
        if active_role and role_age is not None and role_age >= 90
        else None
    )
    latest_role_provider_start = (
        latest_active_role_provider_start(life, active_role)
        if active_role and completed_response
        else 0.0
    )
    if (
        completed_response
        and latest_role_provider_start > completed_response[0] + 5
    ):
        # A new provider turn is actively working after the older completed
        # response.  The old final-answer marker cannot describe the current
        # role turn and must not trigger provider release or a fresh restart.
        completed_response = None
    terminal_response_at = completed_response[0] if completed_response else 0.0
    terminal_response_role = completed_response[1] if completed_response else ""
    terminal_response_stall = bool(
        terminal_response_at
        and terminal_response_role.casefold().startswith(active_role.casefold())
        and role_updated_at <= terminal_response_at + 5
        and current_time - terminal_response_at >= TERMINAL_RESPONSE_STALL_SECONDS
    )
    recent_planner_retries = [
        float(event["ts"])
        for event in mission.get("role_work", [])
        if event.get("role") == "planner"
        and event.get("kind") == "verdict"
        and event.get("status") == "planned"
        and isinstance(event.get("ts"), (int, float))
        and float(event["ts"]) >= current_time - 1_800
    ]
    planner_retry_span = (
        max(recent_planner_retries) - min(recent_planner_retries)
        if len(recent_planner_retries) >= 2
        else 0
    )
    # A bounded continuous mission may settle as ``continued`` when the
    # current stage cannot close.  If Planner then emits the same no-task
    # verdict over multiple polling cycles, the process is alive but cannot
    # enqueue work (for example, a repeated review certification rejected by
    # the stage anti-duplication gate).  Treat that state like the existing
    # complete/ended procedural loop so recovery starts a fresh campaign life
    # while preserving the campaign worktree and evidence.
    procedural_loop = bool(
        not completion
        and
        mission_info.get("status") in {"complete", "ended", "continued"}
        and active_role in {"", "planner"}
        and len(recent_planner_retries) >= 3
        and planner_retry_span >= 600
    )
    external_jobs = list(external_jobs or [])
    external_job_active = bool(external_jobs)
    paused_external_work = bool(
        external_job_active
        and any(
            event.get("mission_id") == mission_info.get("id")
            and event.get("kind") == "completion"
            and (
                event.get("detail") == "paused_external_work"
                or event.get("title") == "Mission ended · paused_external_work"
            )
            for event in mission.get("role_work", [])
        )
    )
    reviewer_verdict: dict[str, Any] | None = None
    latest_reviewer_verdict: dict[str, Any] | None = None
    for event in reversed(mission.get("role_work", [])):
        if event.get("role") != "reviewer" or event.get("kind") not in {
            "verdict",
            "review_verdict",
        }:
            continue
        verdict = {
            "ts": event.get("ts"),
            "status": event.get("status", ""),
            "detail": str(event.get("detail") or event.get("title") or "")[:1200],
            "mission_id": event.get("mission_id", ""),
        }
        if latest_reviewer_verdict is None:
            latest_reviewer_verdict = verdict
        if event.get("mission_id") == mission_info.get("id"):
            reviewer_verdict = verdict
            break
    if (
        pending_reviewer_handoff
        and reviewer_verdict is not None
        and float(reviewer_verdict.get("ts") or 0) >= engineer_progress_updated
    ):
        # The Reviewer has already answered this handoff.  A stale role
        # progress file must not keep the public workbench in "pending review"
        # after an accepted or rejected verdict has been recorded.
        pending_reviewer_handoff = False
    mission_text = "\n".join(
        str(mission_info.get(key, "")) for key in ("title", "objective", "summary")
    )
    campaign_refs = set(
        re.findall(r"counterexample-batch-1/campaigns/([0-9]+)/", mission_text)
    )
    audit_refs = set(re.findall(r"counterexample-batch-1/audit-shards/([^/`\s]+)/", mission_text))
    route_mismatch = bool(
        (expected_campaign_id and campaign_refs and campaign_refs != {expected_campaign_id})
        or (expected_audit_workdir and audit_refs and audit_refs != {expected_audit_workdir})
    )
    if completion:
        state = "completed"
    elif not alive:
        state = "dead"
    elif route_mismatch:
        state = "route_mismatch"
    elif procedural_loop:
        state = "procedural_loop"
    elif failed_mission_active_stall:
        # The harness has already closed the mission, but a provider-backed
        # role survived and may keep mutating the worktree forever. Such work
        # cannot reach the normal Reviewer transition. Preserve its files and
        # resume the campaign in a fresh life.
        state = "failed_mission_active_stall"
    elif failed_mission_role_stall:
        state = "role_error"
    elif paused_external_work and not active_role:
        # The mission deliberately released its role slot while a durable
        # computation continues.  A later Planner DAG mistake is recoverable
        # coordination noise, not evidence that the owned external job died.
        # If the job disappears before producing a terminal record, this
        # exemption vanishes and the unresolved role error becomes actionable.
        state = "external_task"
    elif unresolved_role_error and not active_role:
        # A failed Argus role must remain visible even when detached durable
        # jobs are still running.  Previously ``external_task`` masked this
        # condition, so the fleet summary incorrectly reported zero alerts
        # while the main Planner/Engineer/Reviewer pipeline was dead.  Keep
        # the detached jobs alive and surface a distinct non-restart state;
        # supervision can then repair the role without destroying long jobs.
        state = (
            "role_error_external_task"
            if external_job_active
            else "role_error"
        )
    elif not active_role and external_job_active:
        state = "external_task"
    elif terminal_response_stall:
        state = "terminal_response_stall"
    elif (
        not active_role
        and not backend_active
        and role_age is not None
        and role_age > 600
    ):
        state = "idle_stalled"
    elif age > STALE_SECONDS and not backend_active:
        state = "stale"
    elif active_role:
        state = "active"
    else:
        state = "idle"
    return {
        "label": label,
        "state": state,
        "alive": alive,
        "completed": bool(completion),
        "completion": completion,
        "pid": pid,
        "home": str(life.parents[1]),
        "life_dir": str(life),
        "updated_at": datetime.fromtimestamp(updated_at, UTC).isoformat(),
        "age_seconds": age,
        "role_age_seconds": role_age,
        "active_role": active_role,
        "roles": role_states,
        "role_error": unresolved_role_error,
        "historical_role_error": bool(role_error and not unresolved_role_error),
        "failed_mission_role_stall": failed_mission_role_stall,
        "failed_mission_active_stall": failed_mission_active_stall,
        "terminal_response_stall": terminal_response_stall,
        "latest_role_provider_start": (
            datetime.fromtimestamp(latest_role_provider_start, UTC).isoformat()
            if latest_role_provider_start
            else ""
        ),
        "terminal_response_at": (
            datetime.fromtimestamp(terminal_response_at, UTC).isoformat()
            if terminal_response_at
            else ""
        ),
        "backend_active": backend_active,
        "external_job_active": external_job_active,
        "paused_external_work": paused_external_work,
        "external_jobs": external_jobs,
        "route_mismatch": route_mismatch,
        "procedural_loop": procedural_loop,
        "recent_planner_retries": len(recent_planner_retries),
        "planner_retry_span_seconds": int(planner_retry_span),
        "campaign_path_references": sorted(campaign_refs),
        "audit_path_references": sorted(audit_refs),
        "reviewer_verdict": reviewer_verdict,
        "latest_reviewer_verdict": latest_reviewer_verdict,
        "pending_reviewer_handoff": pending_reviewer_handoff,
        "reviewer_handoff_summary": (
            str(engineer_progress.get("current_activity") or "")[:1200]
            if pending_reviewer_handoff
            else ""
        ),
        "mission": {
            "id": mission_info.get("id", ""),
            "title": mission_info.get("title", ""),
            "status": mission_info.get("status", ""),
        },
    }


MISSION_CONTRACT_TEXT_FIELDS = (
    "objective",
    "acceptance_check",
    "decision_rule",
    "execution_workdir",
)


def mission_contract_issues(record: dict[str, Any]) -> list[str]:
    """Validate the active staged-mission charter before scientific writes."""
    mission = record.get("mission") if isinstance(record.get("mission"), dict) else {}
    mission_id = str(mission.get("id") or "").strip()
    status = str(mission.get("status") or "").strip().lower()
    if (
        not mission_id
        or mission_id.startswith("intent-daemon-")
        or status not in {"working", "continued"}
    ):
        return []
    life_text = str(record.get("life_dir") or "").strip()
    if not life_text:
        return ["active mission has no life directory"]
    path = Path(life_text) / "handoffs" / mission_id / "mission.json"
    payload = load_json(path, None)
    if not isinstance(payload, dict):
        return [f"active mission contract is missing or unreadable: {path}"]
    issues: list[str] = []
    if payload.get("kind") != "mission_context":
        issues.append("kind is not mission_context")
    for field in MISSION_CONTRACT_TEXT_FIELDS:
        if not str(payload.get(field) or "").strip():
            issues.append(f"missing {field}")
    owns_paths = payload.get("owns_paths")
    if not (
        isinstance(owns_paths, list)
        and any(str(item or "").strip() for item in owns_paths)
    ):
        issues.append("missing owns_paths")
    if str(payload.get("stage") or "").strip() not in {"scope", "solve", "review"}:
        issues.append("invalid stage")
    if not str(payload.get("scope") or "").strip():
        issues.append("missing scope")
    return issues


def enforce_mission_contract(
    label: str,
    record: dict[str, Any],
    state: dict[str, Any],
) -> list[dict[str, Any]]:
    issues = list(record.get("mission_contract_issues") or [])
    if not issues:
        return []
    life_text = str(record.get("life_dir") or "").strip()
    mission = record.get("mission") if isinstance(record.get("mission"), dict) else {}
    mission_id = str(mission.get("id") or "").strip()
    fingerprint = hashlib.sha256(
        (life_text + "\n" + mission_id + "\n" + "\n".join(issues)).encode("utf-8")
    ).hexdigest()
    key = f"mission-contract:{label}"
    fingerprints = state.setdefault("mission_contract_fingerprints", {})
    already_notified = fingerprints.get(key) == fingerprint
    life = Path(life_text)
    if not life.is_dir():
        return []
    actions: list[dict[str, Any]] = []
    if not already_notified:
        try:
            source_path = str(ARGUS_SOURCE)
            if source_path not in sys.path:
                sys.path.insert(0, source_path)
            from argus_skill.apps._inbox import queue_inbox_message

            listed = "; ".join(issues)
            queue_inbox_message(
                life,
                (
                    f"Supervisor mission-charter gate for {label}, mission {mission_id}: "
                    f"{listed}. Do not write scientific evidence, staging rows, MathState, "
                    "or proof-graph changes under this charter. Planner must replace it with "
                    "a complete mission_context that freezes the exact statement, branch "
                    "quantifiers, acceptance and failure rules, owned write paths, review "
                    "requirement, and honest novelty boundary before execution resumes."
                ),
                source="fleet-supervisor.mission-contract-gate",
            )
            actions.append(
                {
                    "target": label,
                    "action": "queue_mission_contract_repair",
                    "mission_id": mission_id,
                    "issues": issues,
                }
            )
        except Exception as error:  # noqa: BLE001 - preserve structural gate failure
            return [
                {
                    "target": label,
                    "action": "queue_mission_contract_repair_failed",
                    "mission_id": mission_id,
                    "issues": issues,
                    "error": str(error),
                }
            ]
        fingerprints[key] = fingerprint
    if record.get("active_role") == "engineer":
        release_key = f"malformed-mission-provider:{label}:{mission_id}"
        if not provider_release_allowed(state, release_key):
            return actions
        released = terminate_provider_processes(record)
        mark_provider_release(state, release_key)
        if released.get("provider_pids"):
            actions.append(
                {
                    "target": label,
                    "action": "release_malformed_mission_engineer_provider",
                    "mission_id": mission_id,
                    **released,
                }
            )
    return actions


def abort_invalid_reviewer_mission(
    label: str,
    record: dict[str, Any],
    issues: list[str],
    state: dict[str, Any],
    *,
    request_abort=None,
) -> dict[str, Any] | None:
    """Abort a Reviewer round that cannot yield an admissible verdict."""
    mission = record.get("mission") if isinstance(record.get("mission"), dict) else {}
    if (
        not issues
        or str(record.get("active_role") or "").casefold() != "reviewer"
        or mission.get("status") != "working"
    ):
        return None
    life_text = str(record.get("life_dir") or "").strip()
    mission_id = str(mission.get("id") or "").strip()
    if not life_text or not mission_id:
        return None
    fingerprint = hashlib.sha256(
        (life_text + "\n" + mission_id + "\n" + "\n".join(issues)).encode("utf-8")
    ).hexdigest()
    key = f"invalid-reviewer-abort:{label}"
    fingerprints = state.setdefault("invalid_reviewer_abort_fingerprints", {})
    if fingerprints.get(key) == fingerprint:
        return None
    try:
        if request_abort is None:
            source_path = str(ARGUS_SOURCE)
            if source_path not in sys.path:
                sys.path.insert(0, source_path)
            from argus_skill.life.memory import request_running_item_abort

            request_abort = request_running_item_abort
        requested, item_id = request_abort(
            Path(life_text),
            reason=(
                "Supervisor mission-contract gate: "
                + "; ".join(issues)
                + ". Reviewer output cannot be accepted; return to Planner."
            ),
            requested_by="fleet-supervisor",
        )
    except Exception as error:  # noqa: BLE001 - preserve control failure
        return {
            "target": label,
            "action": "abort_invalid_reviewer_mission_failed",
            "mission_id": mission_id,
            "issues": issues,
            "error": str(error),
        }
    if not requested:
        return None
    fingerprints[key] = fingerprint
    return {
        "target": label,
        "action": "abort_invalid_reviewer_mission",
        "mission_id": mission_id,
        "item_id": item_id,
        "issues": issues,
    }


def run_command(command: list[str], *, env: dict[str, str] | None = None) -> dict[str, Any]:
    try:
        completed = subprocess.run(
            command,
            cwd=ROOT,
            env=env,
            text=True,
            capture_output=True,
            timeout=90,
            check=False,
        )
        return {
            "exit_code": completed.returncode,
            "output": (completed.stdout + completed.stderr).strip()[-2000:],
        }
    except (OSError, subprocess.TimeoutExpired) as error:
        return {"exit_code": None, "output": str(error)}


def queue_reviewer_handoff_recovery(
    campaign_id: str,
    home: Path,
    record: dict[str, Any],
) -> dict[str, Any]:
    life = latest_life([home])
    if life is None:
        return {
            "reviewer_handoff_nudge": False,
            "reviewer_handoff_error": "new campaign life not found",
        }
    try:
        source_path = str(ARGUS_SOURCE)
        if source_path not in sys.path:
            sys.path.insert(0, source_path)
        from argus_skill.apps._inbox import queue_inbox_message

        summary = str(record.get("reviewer_handoff_summary") or "").strip()
        message = (
            "The previous campaign life ended after Engineer explicitly set "
            "NEXT_OWNER=reviewer. Preserve the frozen campaign worktree and do "
            "not repeat or extend that route before review. Read "
            f"campaigns/{campaign_id}/roles/engineer/progress.json and the latest "
            "activity.jsonl handoff, create only the minimal immutable-artifact "
            "handoff needed by the staged workflow, and require an independent "
            "Reviewer replay with the original finite scope preserved."
        )
        if summary:
            message += f" Previous Engineer summary: {summary}"
        queue_inbox_message(
            life,
            message,
            source="fleet-supervisor.reviewer-handoff-recovery",
        )
        return {
            "reviewer_handoff_nudge": True,
            "reviewer_handoff_life": str(life),
        }
    except Exception as error:  # noqa: BLE001 - recovery must remain observable
        return {
            "reviewer_handoff_nudge": False,
            "reviewer_handoff_error": str(error),
        }


def restart_allowed(state: dict[str, Any], key: str) -> bool:
    last = float(state.setdefault("last_restart", {}).get(key, 0))
    return time.time() - last >= RESTART_COOLDOWN_SECONDS


def mark_restart(state: dict[str, Any], key: str) -> None:
    state.setdefault("last_restart", {})[key] = time.time()


def provider_release_allowed(state: dict[str, Any], key: str) -> bool:
    last = float(state.setdefault("last_provider_release", {}).get(key, 0))
    return time.time() - last >= PROVIDER_RELEASE_COOLDOWN_SECONDS


def mark_provider_release(state: dict[str, Any], key: str) -> None:
    state.setdefault("last_provider_release", {})[key] = time.time()


def terminate_provider_processes(record: dict[str, Any]) -> dict[str, Any]:
    """Release a completed model subprocess without killing its Argus daemon.

    Copilot can emit a complete final response yet leave its streaming process
    alive.  The life worker is then blocked in ``wait()`` and never commits the
    Engineer -> Reviewer transition.  Killing the whole daemon loses that
    persisted handoff; terminating only the already-completed provider lets
    the original life worker return and process the captured final response.
    """
    try:
        pid = int(record.get("pid"))
    except (TypeError, ValueError):
        return {"provider_pids": [], "provider_release_error": "invalid daemon pid"}
    provider_pids = provider_descendant_pids(pid)
    for provider_pid in provider_pids:
        if not pid_alive(provider_pid):
            continue
        try:
            os.kill(provider_pid, signal.SIGTERM)
        except (ProcessLookupError, OSError):
            continue
    deadline = time.monotonic() + 5
    while (
        any(pid_alive(provider_pid) for provider_pid in provider_pids)
        and time.monotonic() < deadline
    ):
        time.sleep(0.25)
    for provider_pid in provider_pids:
        if not pid_alive(provider_pid):
            continue
        try:
            os.kill(provider_pid, signal.SIGKILL)
        except (ProcessLookupError, OSError):
            pass
    return {"provider_pids": provider_pids}


def terminate_runtime(record: dict[str, Any]) -> dict[str, Any]:
    try:
        pid = int(record.get("pid"))
    except (TypeError, ValueError):
        return {"stopped_pid": None, "provider_pids": [], "stop_error": "invalid pid"}
    provider_pids = provider_descendant_pids(pid)
    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
    except OSError as error:
        return {
            "stopped_pid": pid,
            "provider_pids": provider_pids,
            "stop_error": str(error),
        }
    deadline = time.monotonic() + 10
    while pid_alive(pid) and time.monotonic() < deadline:
        time.sleep(0.25)
    if pid_alive(pid):
        try:
            os.kill(pid, signal.SIGKILL)
        except (ProcessLookupError, OSError):
            pass
    for provider_pid in provider_pids:
        if not pid_alive(provider_pid):
            continue
        try:
            os.kill(provider_pid, signal.SIGTERM)
        except (ProcessLookupError, OSError):
            continue
    provider_deadline = time.monotonic() + 3
    while (
        any(pid_alive(provider_pid) for provider_pid in provider_pids)
        and time.monotonic() < provider_deadline
    ):
        time.sleep(0.25)
    for provider_pid in provider_pids:
        if not pid_alive(provider_pid):
            continue
        try:
            os.kill(provider_pid, signal.SIGKILL)
        except (ProcessLookupError, OSError):
            pass
    return {"stopped_pid": pid, "provider_pids": provider_pids}


def terminate_durable_job(job: dict[str, Any]) -> dict[str, Any]:
    """Stop one detached durable-job process group without touching Argus.

    Subagent submit processes supervise a separate argus-durable-job process
    group. Killing only the submit PID can leave the expensive job running,
    so use the persisted wrapper PID and terminate its whole group.
    """
    task_id = str(job.get("task_id") or "").strip()
    workdir = Path(str(job.get("workdir") or ""))
    metadata = load_json(
        workdir / ".argus_subagents" / f"{task_id}.json",
        {},
    )
    wrapper_pid = 0
    process_group = 0
    pid_source = ""
    candidates = (
        (metadata.get("pid"), "metadata"),
        (job.get("pid"), "live-snapshot"),
    )
    for raw_pid, source in candidates:
        try:
            candidate_pid = int(raw_pid)
            candidate_group = os.getpgid(candidate_pid)
        except (TypeError, ValueError, ProcessLookupError, OSError):
            continue
        if source == "live-snapshot":
            try:
                command = (
                    Path(f"/proc/{candidate_pid}/cmdline")
                    .read_bytes()
                    .replace(b"\0", b" ")
                    .decode("utf-8", "replace")
                )
            except OSError:
                continue
            # A persisted PID can be reused.  Accept the live-snapshot
            # fallback only when both the owned task and worktree are still
            # present in argv.
            if task_id not in command or str(workdir) not in command:
                continue
        wrapper_pid = candidate_pid
        process_group = candidate_group
        pid_source = source
        break
    if not wrapper_pid:
        return {
            "task_id": task_id,
            "stopped_process_group": None,
            "stop_error": "durable wrapper pid is unavailable",
        }
    tracked_pids = [wrapper_pid, *descendant_process_ids(wrapper_pid)]
    process_groups: set[int] = set()
    for tracked_pid in tracked_pids:
        try:
            process_groups.add(os.getpgid(tracked_pid))
        except (ProcessLookupError, OSError):
            continue
    process_groups.add(process_group)
    process_groups.discard(os.getpgrp())

    stop_errors: list[str] = []
    for group in sorted(process_groups, key=lambda value: value == process_group):
        try:
            os.killpg(group, signal.SIGTERM)
        except ProcessLookupError:
            continue
        except OSError as error:
            stop_errors.append(f"SIGTERM pgid {group}: {error}")
    deadline = time.monotonic() + 10
    while (
        any(pid_alive(tracked_pid) for tracked_pid in tracked_pids)
        and time.monotonic() < deadline
    ):
        time.sleep(0.25)
    remaining_groups: set[int] = set()
    for tracked_pid in tracked_pids:
        try:
            if pid_alive(tracked_pid):
                remaining_groups.add(os.getpgid(tracked_pid))
        except (ProcessLookupError, OSError):
            continue
    remaining_groups.discard(os.getpgrp())
    for group in sorted(remaining_groups):
        try:
            os.killpg(group, signal.SIGKILL)
        except ProcessLookupError:
            continue
        except OSError as error:
            stop_errors.append(f"SIGKILL pgid {group}: {error}")

    result: dict[str, Any] = {
        "task_id": task_id,
        "stopped_process_group": process_group,
        "stopped_process_groups": sorted(process_groups),
        "tracked_process_count": len(tracked_pids),
        "pid_source": pid_source,
    }
    if stop_errors:
        result["stop_error"] = "; ".join(stop_errors)
    return result


def terminate_processes_matching_command(
    marker: str,
    *,
    required_any: tuple[str, ...] = (),
) -> dict[str, Any]:
    """Terminate residual processes whose argv contains one exact marker.

    Some durable tools daemonize their workers.  Those workers can be
    reparented outside the wrapper process group before supervision pauses the
    job, so the normal descendant walk cannot see them.  This fallback is used
    only with a campaign-unique absolute work-directory marker.
    """
    marker_bytes = str(marker).encode("utf-8")
    required_bytes = tuple(item.encode("utf-8") for item in required_any)

    excluded_pids: set[int] = set()
    ancestor = os.getpid()
    while ancestor > 0 and ancestor not in excluded_pids:
        excluded_pids.add(ancestor)
        try:
            stat_tail = (
                Path(f"/proc/{ancestor}/stat")
                .read_text(encoding="utf-8")
                .rsplit(")", 1)[1]
                .split()
            )
            # Fields after the executable name begin with state, then PPID.
            ancestor = int(stat_tail[1])
        except (OSError, IndexError, ValueError):
            break

    def matching_pids() -> list[int]:
        found: list[int] = []
        for proc in Path("/proc").iterdir():
            if not proc.name.isdigit():
                continue
            pid = int(proc.name)
            if pid in excluded_pids:
                continue
            try:
                command = (proc / "cmdline").read_bytes()
            except OSError:
                continue
            if (
                marker_bytes in command
                and (
                    not required_bytes
                    or any(token in command for token in required_bytes)
                )
            ):
                found.append(pid)
        return sorted(found)

    matched = matching_pids()
    for pid in matched:
        try:
            os.kill(pid, signal.SIGTERM)
        except (ProcessLookupError, OSError):
            continue
    deadline = time.monotonic() + 10
    remaining = matching_pids()
    while remaining and time.monotonic() < deadline:
        time.sleep(0.25)
        remaining = matching_pids()
    for pid in remaining:
        try:
            os.kill(pid, signal.SIGKILL)
        except (ProcessLookupError, OSError):
            continue
    final_remaining = matching_pids()
    return {
        "matched_process_pids": matched,
        "sigkill_process_pids": remaining,
        "remaining_process_pids": final_remaining,
    }


def retire_expired_campaigns(
    state: dict[str, Any],
    durable_jobs: dict[str, list[dict[str, Any]]],
) -> list[dict[str, Any]]:
    """Archive and stop unfinished campaigns after the operator's five-day cap."""
    configured = list(
        dict.fromkeys(
            [
                str(campaign_id)
                for campaign_id in state.get(
                    "active_campaign_ids", DEFAULT_CAMPAIGN_IDS
                )
            ]
            + list(CAMPAIGN_POOL_IDS)
        )
    )
    now = time.time()
    due: list[tuple[str, float, dict[str, Any]]] = []
    for campaign_id in configured:
        if campaign_id not in CAMPAIGN_POOL_IDS:
            continue
        if campaign_is_completed(campaign_id) or campaign_is_operator_retired(campaign_id):
            continue
        started_at = campaign_started_at(campaign_id)
        if now - started_at < PROOF_TIMEBOX_SECONDS:
            continue
        record = runtime_record(
            campaign_id,
            exact_campaign_homes(campaign_id),
            expected_campaign_id=campaign_id,
            external_jobs=external_jobs_under(
                durable_jobs,
                ROOT / "campaigns" / campaign_id,
            ),
        )
        due.append((campaign_id, started_at, record))

    if not due:
        return []

    summaries: dict[str, Path] = {}
    for campaign_id, started_at, _record in due:
        summaries[campaign_id] = write_five_day_retirement_summary(
            campaign_id,
            started_at=started_at,
            retired_at=now,
        )

    runtime_stops: dict[str, dict[str, Any]] = {}
    with ThreadPoolExecutor(max_workers=min(8, len(due))) as executor:
        pending = {
            executor.submit(terminate_runtime, record): campaign_id
            for campaign_id, _started_at, record in due
            if record.get("alive")
        }
        for future, campaign_id in pending.items():
            try:
                runtime_stops[campaign_id] = future.result()
            except Exception as error:  # noqa: BLE001 - preserve stop failure
                runtime_stops[campaign_id] = {"stop_error": str(error)}

    job_stops: dict[str, list[dict[str, Any]]] = {
        campaign_id: [] for campaign_id, *_ in due
    }
    jobs_to_stop: list[tuple[str, dict[str, Any]]] = []
    for campaign_id, _started_at, record in due:
        jobs_to_stop.extend(
            (campaign_id, job) for job in list(record.get("external_jobs") or [])
        )
    if jobs_to_stop:
        with ThreadPoolExecutor(max_workers=min(12, len(jobs_to_stop))) as executor:
            pending_jobs = {
                executor.submit(terminate_durable_job, job): (campaign_id, job)
                for campaign_id, job in jobs_to_stop
            }
            for future, (campaign_id, job) in pending_jobs.items():
                try:
                    stopped = future.result()
                except Exception as error:  # noqa: BLE001 - preserve stop failure
                    stopped = {"stop_error": str(error)}
                job_stops[campaign_id].append(
                    {"task_id": str(job.get("task_id") or ""), **stopped}
                )

    actions: list[dict[str, Any]] = []
    retired_ids = {
        str(campaign_id)
        for campaign_id in state.get("operator_retired_campaign_ids", [])
    }
    for campaign_id, started_at, _record in due:
        residual = terminate_processes_matching_command(
            str((ROOT / "campaigns" / campaign_id).resolve())
        )
        retired_ids.add(campaign_id)
        actions.append(
            {
                "target": f"campaign:{campaign_id}",
                "action": "retire_after_five_day_proof_timebox",
                "started_at": datetime.fromtimestamp(started_at, UTC).isoformat(),
                "retired_at": datetime.fromtimestamp(now, UTC).isoformat(),
                "summary": str(summaries[campaign_id].relative_to(ROOT)),
                "runtime_stop": runtime_stops.get(campaign_id, {}),
                "durable_job_stops": job_stops.get(campaign_id, []),
                "residual_process_stop": residual,
            }
        )

    previously_active = [
        str(campaign_id)
        for campaign_id in state.get("active_campaign_ids", DEFAULT_CAMPAIGN_IDS)
    ]
    remaining = [
        campaign_id for campaign_id in previously_active if campaign_id not in retired_ids
    ]
    state["operator_retired_campaign_ids"] = sorted(retired_ids)
    state["active_campaign_ids"] = remaining
    state["campaign_target_count"] = len(remaining)
    state["auto_refill_campaign_slots"] = False
    state.setdefault("five_day_retirement_history", []).append(
        {
            "retired_at": datetime.fromtimestamp(now, UTC).isoformat(),
            "campaign_ids": [campaign_id for campaign_id, *_ in due],
            "remaining_active_campaign_ids": remaining,
        }
    )

    index_lines = [
        "# Five-day proof-timebox retirements",
        "",
        f"Updated: {datetime.fromtimestamp(now, UTC).isoformat()}",
        "",
        "Unfinished campaigns are preserved but no longer consume daemon,",
        "detached-compute, or model-API resources after five days.",
        "",
    ]
    for campaign_id in sorted(retired_ids):
        summary = PROOF_TIMEBOX_EVIDENCE / campaign_id / "SUMMARY.md"
        if summary.is_file():
            index_lines.append(
                f"- `{campaign_id}` — `{summary.relative_to(ROOT)}`"
            )
    index_lines.append("")
    write_text_atomic(PROOF_TIMEBOX_EVIDENCE / "SUMMARY.md", "\n".join(index_lines))
    return actions


def disk_pressure_q384_raw_proof_jobs(
    campaigns: dict[str, dict[str, Any]],
    host_disk: dict[str, Any],
) -> list[dict[str, Any]]:
    """Stop unbounded in-memory/raw-DRAT q384 runs before terminal write bursts."""
    try:
        available_bytes = int(host_disk.get("available_bytes") or 0)
        pressure_threshold = int(host_disk.get("pressure_threshold_bytes") or 0)
    except (TypeError, ValueError):
        return []
    if not (
        pressure_threshold
        and available_bytes
        <= pressure_threshold + Q384_RAW_PROOF_HEADROOM_BYTES
    ):
        return []

    campaign = campaigns.get("1518", {})
    jobs = list(campaign.get("external_jobs") or [])
    targets = []
    for job in jobs:
        command = str(job.get("command") or "")
        if (
            any(marker in command for marker in Q384_RAW_PROOF_MARKERS)
            and "--proof" in command
            and "--conflict-budget" not in command
        ):
            targets.append(job)
    stopped: list[dict[str, Any]] = []
    for job in targets:
        try:
            result = terminate_durable_job(job)
        except Exception as error:  # noqa: BLE001 - preserve stop failure
            result = {"stop_error": str(error)}
        stopped.append({"task_id": str(job.get("task_id") or ""), **result})

    residual_results = [
        terminate_processes_matching_command(
            marker,
            required_any=("--proof", ".drat"),
        )
        for marker in Q384_RAW_PROOF_MARKERS
    ]
    residual = {
        field: sorted(
            {
                int(pid)
                for result in residual_results
                for pid in result.get(field, [])
            }
        )
        for field in (
            "matched_process_pids",
            "sigkill_process_pids",
            "remaining_process_pids",
        )
    }
    stopped_ids = {
        str(item.get("task_id") or "")
        for item in stopped
        if not item.get("stop_error")
    }
    # A wrapper can exit while its metadata is being refreshed, making the
    # durable stop helper report an unavailable PID even though the requested
    # state has already been reached.  The campaign-unique residual sweep is
    # authoritative here: if it found no survivor and the observed submit PID
    # is also gone, clear that task instead of retaining a false active job.
    if not residual.get("remaining_process_pids"):
        stopped_ids.update(
            str(job.get("task_id") or "")
            for job in targets
            if not pid_alive(job.get("pid"))
        )
    unresolved_stop_errors = [
        item
        for item in stopped
        if item.get("stop_error")
        and str(item.get("task_id") or "") not in stopped_ids
    ]
    if stopped_ids:
        campaign["external_jobs"] = [
            job
            for job in jobs
            if str(job.get("task_id") or "") not in stopped_ids
        ]
        campaign["external_job_active"] = bool(campaign["external_jobs"])
    if not targets and not residual.get("matched_process_pids"):
        return []
    return [
        {
            "target": "campaign:1518:q384-raw-proof",
            "action": "pause_unbounded_q384_raw_proof_for_headroom",
            "available_bytes_before": available_bytes,
            "headroom_bytes": Q384_RAW_PROOF_HEADROOM_BYTES,
            "task_count": len(targets),
            "stopped_task_count": len(stopped_ids),
            "stop_error_count": len(unresolved_stop_errors),
            "resolved_stop_warning_count": sum(
                bool(item.get("stop_error")) for item in stopped
            )
            - len(unresolved_stop_errors),
            **residual,
        }
    ]


def disk_pressure_q384_jobs(
    campaigns: dict[str, dict[str, Any]],
    host_disk: dict[str, Any],
    state: dict[str, Any],
) -> list[dict[str, Any]]:
    """Fail closed on the known multi-gigabyte q384 proof generators."""
    try:
        available_bytes = int(host_disk.get("available_bytes") or 0)
        pressure_threshold = int(host_disk.get("pressure_threshold_bytes") or 0)
    except (TypeError, ValueError):
        available_bytes = 0
        pressure_threshold = 0
    if not (
        host_disk.get("pressure")
        or (
            pressure_threshold
            and available_bytes
            <= pressure_threshold + DISK_HEAVY_JOB_HEADROOM_BYTES
        )
    ):
        return []
    campaign = campaigns.get("1518", {})
    jobs = list(campaign.get("external_jobs") or [])
    actions: list[dict[str, Any]] = []
    stopped_ids: set[str] = set()
    for job in jobs:
        command = str(job.get("command") or "")
        task_id = str(job.get("task_id") or "")
        if "q384-global-shell-completion" not in command:
            continue
        if not any(
            runner in command
            for runner in (
                "run_proof_batch.py",
                "run_union_batch.py",
                "run_union_sequence.py",
                "run_monitored_chunk.py",
                "run_union_proof.py",
                "solve_endpoint_union.py",
                "run_bounded_probe.py",
                "solve_endpoint_shell_reduced.py",
                "solve_global_shell_reduced.py",
            )
        ):
            continue
        key = f"disk-pressure:q384:{task_id}"
        if not restart_allowed(state, key):
            continue
        stopped = terminate_durable_job(job)
        residual = terminate_processes_matching_command("cado-h731-r498-work")
        mark_restart(state, key)
        actions.append(
            {
                "target": f"campaign:1518:{task_id}",
                "action": "pause_q384_batch_for_disk_pressure",
                "available_bytes_before": host_disk.get("available_bytes"),
                "headroom_bytes": DISK_HEAVY_JOB_HEADROOM_BYTES,
                **stopped,
            }
        )
        if not stopped.get("stop_error"):
            stopped_ids.add(task_id)
    if stopped_ids:
        remaining = [
            job for job in jobs
            if str(job.get("task_id") or "") not in stopped_ids
        ]
        campaign["external_jobs"] = remaining
        campaign["external_job_active"] = bool(remaining)
    # Do not apply restart cooldown to an actually running direct process.  A
    # role can launch a new q384 variant inside the five-minute action cooldown;
    # suppressing the second stop lets it consume the very reserve this guard
    # exists to protect.  With no matching process this is a no-op, so repeated
    # supervisor cycles remain quiet.
    # The q384 campaign has repeatedly introduced new runner filenames while
    # staying inside the same unique work tree.  Matching a growing script-name
    # allow-list leaves each new variant unprotected for one cycle.  Under disk
    # headroom pressure, stop every direct process whose argv names this exact
    # campaign directory; the Argus role/provider itself does not carry that
    # path in argv and remains alive to record the pause.
    direct = terminate_processes_matching_command("q384-global-shell-completion")
    if direct.get("matched_process_pids"):
        mark_restart(state, "disk-pressure:q384-direct")
        actions.append(
            {
                "target": "campaign:1518:q384-direct-processes",
                "action": "pause_direct_q384_for_disk_pressure",
                "available_bytes_before": host_disk.get("available_bytes"),
                "headroom_bytes": DISK_HEAVY_JOB_HEADROOM_BYTES,
                **direct,
            }
        )
    return actions


def is_1417_hybrid_prefix_round3_job(job: dict[str, Any]) -> bool:
    """Identify the round-3 search by its owned work, not a mutable task name."""
    command = str(job.get("command") or "")
    return (
        any(
            script in command
            for script in (
                "solve_hybrid_prefix_classes.py",
                "solve_hybrid_compact_prefix_classes.py",
            )
        )
        and "hybrid-prefix-round3" in command
        and "/campaigns/1417" in command
    )


def hybrid_prefix_shard_index(job: dict[str, Any]) -> int:
    match = re.search(r"--shard-index\s+(\d+)", str(job.get("command") or ""))
    return int(match.group(1)) if match else sys.maxsize


def running_1417_hybrid_prefix_solvers() -> list[dict[str, Any]]:
    """Return actual round-3 solver processes, including unregistered tmux jobs."""
    records: list[dict[str, Any]] = []
    for proc in Path("/proc").iterdir():
        if not proc.name.isdigit():
            continue
        try:
            argv = [
                part.decode("utf-8", "replace")
                for part in (proc / "cmdline").read_bytes().split(b"\0")
                if part
            ]
        except OSError:
            continue
        if not argv or not Path(argv[0]).name.startswith("python"):
            continue
        if not any(
            arg.endswith(
                (
                    "solve_hybrid_prefix_classes.py",
                    "solve_hybrid_compact_prefix_classes.py",
                )
            )
            for arg in argv
        ):
            continue
        command = " ".join(argv)
        if "/campaigns/1417/" not in command or "hybrid-prefix-round3" not in command:
            continue
        match = re.search(r"--shard-index\s+(\d+)", command)
        if match is None:
            continue
        pid = int(proc.name)
        try:
            process_group = os.getpgid(pid)
        except (ProcessLookupError, OSError):
            continue
        records.append(
            {
                "pid": pid,
                "process_group": process_group,
                "shard_index": int(match.group(1)),
            }
        )
    return sorted(records, key=lambda item: (item["shard_index"], item["pid"]))


def limit_1417_hybrid_prefix_solver_processes() -> dict[str, Any]:
    """Enforce the shard cap from live solver processes, not task metadata."""
    solvers = running_1417_hybrid_prefix_solvers()
    by_shard: dict[int, list[dict[str, Any]]] = {}
    for solver in solvers:
        by_shard.setdefault(int(solver["shard_index"]), []).append(solver)
    kept_shards = sorted(by_shard)[:MAX_1417_HYBRID_PREFIX_CONCURRENCY]
    kept_pids = {
        int(by_shard[shard][0]["pid"])
        for shard in kept_shards
    }
    excess = [
        solver
        for solver in solvers
        if int(solver["shard_index"]) not in kept_shards
        or int(solver["pid"]) not in kept_pids
    ]
    groups = {
        int(solver["process_group"])
        for solver in excess
        if int(solver["process_group"]) != os.getpgrp()
    }
    for group in sorted(groups):
        try:
            os.killpg(group, signal.SIGTERM)
        except (ProcessLookupError, OSError):
            continue
    deadline = time.monotonic() + 5
    remaining = [
        solver for solver in excess if pid_alive(int(solver["pid"]))
    ]
    while remaining and time.monotonic() < deadline:
        time.sleep(0.2)
        remaining = [
            solver for solver in excess if pid_alive(int(solver["pid"]))
        ]
    kill_groups = {
        int(solver["process_group"])
        for solver in remaining
        if int(solver["process_group"]) != os.getpgrp()
    }
    for group in sorted(kill_groups):
        try:
            os.killpg(group, signal.SIGKILL)
        except (ProcessLookupError, OSError):
            continue
    final_remaining = [
        solver for solver in excess if pid_alive(int(solver["pid"]))
    ]
    return {
        "observed_solver_count": len(solvers),
        "observed_unique_shard_count": len(by_shard),
        "kept_shards": kept_shards,
        "stopped_solver_pids": [int(item["pid"]) for item in excess],
        "stopped_process_groups": sorted(groups),
        "sigkill_process_groups": sorted(kill_groups),
        "remaining_excess_solver_pids": [
            int(item["pid"]) for item in final_remaining
        ],
    }


def limit_1417_hybrid_prefix_concurrency(
    campaigns: dict[str, dict[str, Any]],
) -> list[dict[str, Any]]:
    """Keep the measured high-write round-3 search at bounded concurrency."""
    campaign = campaigns.get("1417", {})
    jobs = list(campaign.get("external_jobs") or [])
    targets = sorted(
        (
            job
            for job in jobs
            if is_1417_hybrid_prefix_round3_job(job)
        ),
        key=lambda job: (
            hybrid_prefix_shard_index(job),
            str(job.get("task_id") or ""),
        ),
    )
    excess = targets[MAX_1417_HYBRID_PREFIX_CONCURRENCY:]

    stopped: list[dict[str, Any]] = []
    if excess:
        with ThreadPoolExecutor(max_workers=min(16, len(excess))) as executor:
            futures = {
                executor.submit(terminate_durable_job, job): job
                for job in excess
            }
            for future, job in futures.items():
                task_id = str(job.get("task_id") or "")
                try:
                    result = future.result()
                except Exception as error:  # noqa: BLE001 - preserve stop failures
                    result = {"stop_error": str(error)}
                stopped.append({"task_id": task_id, **result})

    stopped_ids = {
        str(item.get("task_id") or "")
        for item in stopped
        if not item.get("stop_error")
    }
    campaign["external_jobs"] = [
        job
        for job in jobs
        if str(job.get("task_id") or "") not in stopped_ids
    ]
    campaign["external_job_active"] = bool(campaign["external_jobs"])
    process_limit = limit_1417_hybrid_prefix_solver_processes()
    if not excess and not process_limit["stopped_solver_pids"]:
        return []
    return [
        {
            "target": "campaign:1417:hybrid-prefix-round3",
            "action": "limit_hybrid_prefix_concurrency",
            "limit": MAX_1417_HYBRID_PREFIX_CONCURRENCY,
            "observed_task_count": len(targets),
            "stopped_task_count": len(stopped_ids),
            "stop_error_count": sum(bool(item.get("stop_error")) for item in stopped),
            **process_limit,
        }
    ]


def queue_1417_concurrency_cap_guidance(
    record: dict[str, Any],
    state: dict[str, Any],
) -> dict[str, Any] | None:
    """Tell each active campaign life once that daemonization does not bypass the cap."""
    life_text = str(record.get("life_dir") or "").strip()
    if not life_text:
        return None
    life = Path(life_text)
    if not life.is_dir():
        return None
    key = "campaign:1417:concurrency-cap-guidance"
    if state.setdefault("resource_guidance", {}).get(key) == life_text:
        return None
    try:
        source_path = str(ARGUS_SOURCE)
        if source_path not in sys.path:
            sys.path.insert(0, source_path)
        from argus_skill.apps._inbox import queue_inbox_message

        queue_inbox_message(
            life,
            (
                "Operator resource directive for campaign 1417: OBJECTIVE.md "
                "permits at most eight concurrent round-3 hybrid-prefix solver "
                "shards. Keep only the lowest eight active shard indices and "
                "start at most one waiting shard when a slot terminates. Do not "
                "rename, daemonize, use tmux, or change launch wrappers to bypass "
                "the cap. The supervisor enforces it from actual solver processes; "
                "every interrupted excess prefix remains nonconclusive."
            ),
            source="fleet-supervisor.1417-concurrency-cap",
        )
    except Exception as error:  # noqa: BLE001 - keep the failed nudge observable
        return {
            "target": "campaign:1417",
            "action": "queue_concurrency_cap_guidance_failed",
            "error": str(error),
        }
    state["resource_guidance"][key] = life_text
    return {
        "target": "campaign:1417",
        "action": "queue_concurrency_cap_guidance",
        "life_dir": life_text,
    }


def release_repeated_1417_concurrency_violator(
    record: dict[str, Any],
    state: dict[str, Any],
) -> dict[str, Any] | None:
    """End only an Engineer provider after repeated cap bypasses in one life."""
    life_text = str(record.get("life_dir") or "").strip()
    now = time.time()
    key = "campaign:1417:hybrid-prefix-round3"
    violations = state.setdefault("resource_violations", {}).setdefault(key, {})
    if violations.get("life_dir") != life_text:
        violations.clear()
        violations["life_dir"] = life_text
        violations["timestamps"] = []
    timestamps = [
        float(value)
        for value in violations.get("timestamps", [])
        if now - float(value) <= CONCURRENCY_VIOLATION_WINDOW_SECONDS
    ]
    timestamps.append(now)
    violations["timestamps"] = timestamps
    if (
        len(timestamps)
        < MAX_1417_CONCURRENCY_VIOLATIONS_BEFORE_PROVIDER_RELEASE
        or record.get("active_role") != "engineer"
    ):
        return None
    release_key = f"repeated-concurrency-violation:{life_text}"
    if not provider_release_allowed(state, release_key):
        return None
    released = terminate_provider_processes(record)
    mark_provider_release(state, release_key)
    provider_pids = list(released.get("provider_pids") or [])
    if not provider_pids:
        return None
    return {
        "target": "campaign:1417:engineer-provider",
        "action": "release_repeated_concurrency_violating_provider",
        "violation_count_in_window": len(timestamps),
        "window_seconds": CONCURRENCY_VIOLATION_WINDOW_SECONDS,
        **released,
    }


def disk_pressure_1417_jobs(
    campaigns: dict[str, dict[str, Any]],
    host_disk: dict[str, Any],
    state: dict[str, Any],
) -> list[dict[str, Any]]:
    """Pause the checkpointable round-3 hybrid-prefix search under pressure."""
    try:
        available_bytes = int(host_disk.get("available_bytes") or 0)
        pressure_threshold = int(host_disk.get("pressure_threshold_bytes") or 0)
    except (TypeError, ValueError):
        available_bytes = 0
        pressure_threshold = 0
    if not (
        host_disk.get("pressure")
        or (
            pressure_threshold
            and available_bytes
            <= pressure_threshold + DISK_HEAVY_JOB_HEADROOM_BYTES
        )
    ):
        return []

    campaign = campaigns.get("1417", {})
    jobs = list(campaign.get("external_jobs") or [])
    targets = [job for job in jobs if is_1417_hybrid_prefix_round3_job(job)]
    if not targets:
        return []

    stopped: list[dict[str, Any]] = []
    with ThreadPoolExecutor(max_workers=min(16, len(targets))) as executor:
        futures = {
            executor.submit(terminate_durable_job, job): job
            for job in targets
        }
        for future, job in futures.items():
            task_id = str(job.get("task_id") or "")
            try:
                result = future.result()
            except Exception as error:  # noqa: BLE001 - preserve all stop results
                result = {"stop_error": str(error)}
            stopped.append({"task_id": task_id, **result})

    residual = terminate_processes_matching_command(
        "/campaigns/1417/",
        required_any=(
            "solve_hybrid_prefix_classes.py",
            "solve_hybrid_compact_prefix_classes.py",
            "solve_hybrid_prefix_partition.py",
            "hybrid-prefix-round3",
        ),
    )
    stopped_ids = {
        str(item.get("task_id") or "")
        for item in stopped
        if not item.get("stop_error")
    }
    campaign["external_jobs"] = [
        job
        for job in jobs
        if str(job.get("task_id") or "") not in stopped_ids
    ]
    campaign["external_job_active"] = bool(campaign["external_jobs"])
    mark_restart(state, "disk-pressure:1417-hybrid-prefix-round3")
    return [
        {
            "target": "campaign:1417:hybrid-prefix-round3",
            "action": "pause_checkpointable_hybrid_prefix_for_disk_pressure",
            "available_bytes_before": host_disk.get("available_bytes"),
            "headroom_bytes": DISK_HEAVY_JOB_HEADROOM_BYTES,
            "task_count": len(targets),
            "stopped_task_count": len(stopped_ids),
            "stop_error_count": sum(bool(item.get("stop_error")) for item in stopped),
            **residual,
        }
    ]


def prune_scoped_inactive_runtime_streams(
    host_disk: dict[str, Any],
) -> list[dict[str, Any]]:
    """Remove rotated raw model streams from inactive lives under pressure.

    Scientific evidence lives in the campaign worktree, events, handoffs,
    ledgers, and proof artifacts. ``agent_io.jsonl.N`` is a bounded raw provider
    transcript and terminal-state fingerprints deliberately ignore it.  Limit
    cleanup to historical lives of the currently supervised campaigns/audits,
    and never unlink a file still open by any process.
    """
    try:
        available_bytes = int(host_disk.get("available_bytes") or 0)
        pressure_threshold = int(host_disk.get("pressure_threshold_bytes") or 0)
    except (TypeError, ValueError):
        available_bytes = 0
        pressure_threshold = 0
    if not (
        host_disk.get("pressure")
        or (
            pressure_threshold
            and available_bytes
            <= pressure_threshold + DISK_HEAVY_JOB_HEADROOM_BYTES
        )
    ):
        return []

    homes: list[Path] = []
    for campaign_id in CAMPAIGN_IDS:
        homes.extend(exact_campaign_homes(campaign_id))
    homes.extend(Path(str(spec["home"])) for spec in AUDIT_RUNTIMES.values())

    live_lives: set[Path] = set()
    for home in homes:
        projects = home / "projects"
        if not projects.is_dir():
            continue
        for status_path in projects.glob("*/daemon.status.json"):
            payload = load_json(status_path, {})
            if pid_alive(payload.get("pid")):
                try:
                    live_lives.add(status_path.parent.resolve())
                except OSError:
                    live_lives.add(status_path.parent)

    open_paths: set[str] = set()
    for proc in Path("/proc").iterdir():
        if not proc.name.isdigit():
            continue
        try:
            descriptors = list((proc / "fd").iterdir())
        except OSError:
            continue
        for descriptor in descriptors:
            try:
                target = os.readlink(descriptor)
            except OSError:
                continue
            if "agent_io.jsonl." in target:
                open_paths.add(target.removesuffix(" (deleted)"))

    removed_count = 0
    removed_bytes = 0
    errors: list[str] = []
    seen_homes: set[Path] = set()
    for home in homes:
        try:
            resolved_home = home.resolve()
        except OSError:
            resolved_home = home
        if resolved_home in seen_homes:
            continue
        seen_homes.add(resolved_home)
        projects = home / "projects"
        if not projects.is_dir():
            continue
        for life in projects.iterdir():
            if not life.is_dir():
                continue
            try:
                resolved_life = life.resolve()
            except OSError:
                resolved_life = life
            if resolved_life in live_lives:
                continue
            for path in life.glob("agent_io.jsonl.*"):
                if not path.is_file() or not path.name.rsplit(".", 1)[-1].isdigit():
                    continue
                if str(path) in open_paths:
                    continue
                try:
                    size = path.stat().st_size
                    path.unlink()
                    removed_count += 1
                    removed_bytes += size
                except OSError as error:
                    errors.append(f"{path}: {error}")
    if not removed_count and not errors:
        return []
    return [
        {
            "target": "runtime:inactive-rotated-agent-streams",
            "action": "prune_inactive_runtime_streams_for_disk_pressure",
            "removed_file_count": removed_count,
            "removed_bytes": removed_bytes,
            "error_count": len(errors),
            "errors": errors[:10],
        }
    ]


def disk_pressure_cado_jobs(
    campaigns: dict[str, dict[str, Any]],
    host_disk: dict[str, Any],
    state: dict[str, Any],
) -> list[dict[str, Any]]:
    """Pause the checkpointable 1243 GNFS job before it fills the workspace."""
    try:
        available_bytes = int(host_disk.get("available_bytes") or 0)
        pressure_threshold = int(host_disk.get("pressure_threshold_bytes") or 0)
    except (TypeError, ValueError):
        available_bytes = 0
        pressure_threshold = 0
    # GNFS sieving writes in bursts and free space was observed oscillating
    # across the exact 5% line between supervisor samples.  Pause this one
    # checkpointable job slightly early so a transient rebound cannot hide a
    # sustained downward trend.  Global host alerts retain their exact limit.
    cado_pressure = bool(host_disk.get("pressure")) or bool(
        pressure_threshold
        and available_bytes
        <= pressure_threshold + DISK_HEAVY_JOB_HEADROOM_BYTES
    )
    if not cado_pressure:
        return []
    campaign = campaigns.get("1243", {})
    jobs = list(campaign.get("external_jobs") or [])
    actions: list[dict[str, Any]] = []
    stopped_ids: set[str] = set()
    for job in jobs:
        command = str(job.get("command") or "")
        task_id = str(job.get("task_id") or "")
        if not (
            "cado-nfs.py" in command
            and "cado-h731-r498-work" in command
        ):
            continue
        key = f"disk-pressure:cado:{task_id}"
        if not restart_allowed(state, key):
            continue
        stopped = terminate_durable_job(job)
        mark_restart(state, key)
        actions.append(
            {
                "target": f"campaign:1243:{task_id}",
                "action": "pause_checkpointable_cado_for_disk_pressure",
                "available_bytes_before": host_disk.get("available_bytes"),
                "headroom_bytes": DISK_HEAVY_JOB_HEADROOM_BYTES,
                **stopped,
                **residual,
            }
        )
        if (
            not stopped.get("stop_error")
            and not residual.get("remaining_process_pids")
        ):
            stopped_ids.add(task_id)
    if stopped_ids:
        remaining = [
            job for job in jobs
            if str(job.get("task_id") or "") not in stopped_ids
        ]
        campaign["external_jobs"] = remaining
        campaign["external_job_active"] = bool(remaining)
    return actions


def recover_campaign(campaign_id: str, record: dict[str, Any], state: dict[str, Any]) -> dict[str, Any] | None:
    key = f"campaign:{campaign_id}"
    recoverable_states = {
        "dead",
        "missing",
        "stale",
        "idle_stalled",
        "route_mismatch",
        "procedural_loop",
        "role_error",
        "failed_mission_active_stall",
        "terminal_response_stall",
    }
    unhealthy = record.get("state") in recoverable_states
    terminal_stall = bool(record.get("terminal_response_stall"))
    if not unhealthy:
        return None
    # A replacement daemon may finish booting after the fleet snapshot was
    # assembled but before recovery runs.  Re-sample the exact campaign homes
    # before terminating or launching anything; otherwise the stale snapshot
    # can race a healthy new life and the launcher merely reports an existing
    # workdir lease.
    refreshed = runtime_record(
        campaign_id,
        exact_campaign_homes(campaign_id),
        expected_campaign_id=campaign_id,
        external_jobs=list(record.get("external_jobs") or []),
    )
    if refreshed.get("state") not in recoverable_states:
        record.clear()
        record.update(refreshed)
        return None
    if (
        terminal_stall
        and record.get("alive")
        and provider_release_allowed(state, key)
    ):
        released = terminate_provider_processes(record)
        if released.get("provider_pids"):
            mark_provider_release(state, key)
            return {
                "target": key,
                "action": "release_completed_provider_for_role_handoff",
                "daemon_pid": record.get("pid"),
                **released,
            }
    if not restart_allowed(state, key):
        return None
    prefix = f".argus-campaign-{campaign_id}"
    # Missing campaigns have no continuous objective to resume. A terminal
    # response stall has already crossed a persisted role boundary, so a new
    # life is safer than repeatedly reviving the wedged role session.
    fresh_run = record.get("state") in {
        "missing",
        "procedural_loop",
        "role_error",
        "failed_mission_active_stall",
        "terminal_response_stall",
    }
    if fresh_run:
        suffix = next_campaign_run_suffix(campaign_id)
    elif record.get("home"):
        home_name = Path(str(record["home"])).name
        suffix = home_name[len(prefix) :] if home_name.startswith(prefix) else ""
    else:
        homes = exact_campaign_homes(campaign_id)
        home_name = (
            max(homes, key=lambda path: path.stat().st_mtime).name
            if homes
            else prefix
        )
        suffix = home_name[len(prefix) :] if home_name.startswith(prefix) else ""
    env = os.environ.copy()
    env["ARGUS_CAMPAIGN_HOME_SUFFIX"] = suffix
    env["ARGUS_CAMPAIGN_RESUME_CONTINUOUS"] = "0" if fresh_run else "1"
    stop = terminate_runtime(record) if record.get("alive") else {}
    result = run_command([str(PYTHON), str(CAMPAIGN_LAUNCHER), campaign_id], env=env)
    handoff_recovery: dict[str, Any] = {}
    if (
        fresh_run
        and record.get("pending_reviewer_handoff")
        and result.get("exit_code") == 0
    ):
        handoff_recovery = queue_reviewer_handoff_recovery(
            campaign_id,
            WORKSPACE / f"{prefix}{suffix}",
            record,
        )
    mark_restart(state, key)
    return {
        "target": key,
        "action": (
            "restart_terminal_response_stall"
            if terminal_stall
            else f"restart_fresh_{record.get('state')}"
            if fresh_run
            else f"restart_{record.get('state', 'unhealthy')}"
        ),
        **stop,
        **result,
        **handoff_recovery,
    }


def recover_audit(shard: str, record: dict[str, Any], state: dict[str, Any]) -> dict[str, Any] | None:
    key = f"audit:{shard}"
    recoverable_states = {
        "dead",
        "missing",
        "stale",
        "idle_stalled",
        "route_mismatch",
        "procedural_loop",
        "role_error",
        "failed_mission_active_stall",
        "terminal_response_stall",
    }
    unhealthy = record.get("state") in recoverable_states
    terminal_stall = bool(record.get("terminal_response_stall"))
    if not unhealthy:
        return None
    spec = AUDIT_RUNTIMES[shard]
    refreshed = runtime_record(
        f"audit-{shard}",
        [Path(str(spec["home"]))],
        expected_audit_workdir=f"{shard}{spec['workdir_suffix']}",
        external_jobs=list(record.get("external_jobs") or []),
    )
    if refreshed.get("state") not in recoverable_states:
        record.clear()
        record.update(refreshed)
        return None
    if (
        terminal_stall
        and record.get("alive")
        and provider_release_allowed(state, key)
    ):
        released = terminate_provider_processes(record)
        if released.get("provider_pids"):
            mark_provider_release(state, key)
            return {
                "target": key,
                "action": "release_completed_provider_for_role_handoff",
                "daemon_pid": record.get("pid"),
                **released,
            }
    if not restart_allowed(state, key):
        return None
    env = os.environ.copy()
    env["ARGUS_AUDIT_WORKDIR_SUFFIX"] = str(spec["workdir_suffix"])
    env["ARGUS_AUDIT_HOME_SUFFIX"] = str(spec["home_suffix"])
    env["ARGUS_AUDIT_RESUME_CONTINUOUS"] = "1"
    stop = terminate_runtime(record) if record.get("alive") else {}
    result = run_command([str(PYTHON), str(AUDIT_LAUNCHER), shard], env=env)
    mark_restart(state, key)
    return {
        "target": key,
        "action": (
            "restart_terminal_response_stall"
            if terminal_stall
            else f"restart_{record.get('state', 'unhealthy')}"
        ),
        **stop,
        **result,
    }


def maintain_pending_daemon_upgrade(
    target: str,
    record: dict[str, Any],
) -> dict[str, Any] | None:
    """Resume a durable boundary upgrade after its original scheduler exits.

    ``schedule_project_daemon_upgrade`` runs its worker in a daemon thread.  A
    one-shot operator or timer process can therefore disappear while the target
    daemon is still inside a long mission.  The durable request remains, but a
    completed boundary may clear the stop request before the next-release
    daemon has taken over.  Reissue the official schedule only in that narrow
    state; current daemons use the same call to clear a stale request safely.
    """
    if not record.get("alive") or not record.get("life_dir") or not record.get("home"):
        return None
    life_dir = Path(str(record["life_dir"]))
    request = life_dir / "daemon.upgrade-request.json"
    stop_request = life_dir / "daemon.stop-request.json"
    if not request.is_file() or stop_request.exists():
        return None
    env = os.environ.copy()
    existing_pythonpath = str(env.get("PYTHONPATH") or "").strip()
    env["PYTHONPATH"] = (
        str(ARGUS_SOURCE)
        if not existing_pythonpath
        else os.pathsep.join((str(ARGUS_SOURCE), existing_pythonpath))
    )
    code = (
        "import sys,time; from pathlib import Path; "
        "from argus_skill.webapi import server; "
        "print(server.schedule_project_daemon_upgrade("
        "sys.argv[2], global_root=Path(sys.argv[1]))); time.sleep(1.5)"
    )
    result = run_command(
        [str(ARGUS_PYTHON), "-c", code, str(record["home"]), life_dir.name],
        env=env,
    )
    return {
        "target": target,
        "action": "resume_pending_boundary_upgrade",
        **result,
    }


def systemd_active(service: str) -> bool:
    result = subprocess.run(
        ["systemctl", "--user", "is-active", "--quiet", service],
        check=False,
    )
    return result.returncode == 0


def restart_service(service: str) -> dict[str, Any]:
    result = run_command(["systemctl", "--user", "restart", service])
    return {"target": service, "action": "restart", **result}


def http_check(url: str, *, parse_json: bool = False) -> dict[str, Any]:
    started = time.monotonic()
    try:
        request = urllib.request.Request(url, headers={"User-Agent": "argus-fleet-supervisor/1"})
        with urllib.request.urlopen(request, timeout=10) as response:
            body = response.read(HTTP_JSON_MAX_BYTES + 1 if parse_json else 1)
            if parse_json:
                if len(body) > HTTP_JSON_MAX_BYTES:
                    return {
                        "ok": False,
                        "status": response.status,
                        "error": (
                            "JSON response exceeds health-check limit "
                            f"({HTTP_JSON_MAX_BYTES} bytes)"
                        ),
                        "elapsed_seconds": round(time.monotonic() - started, 3),
                    }
                json.loads(body)
            return {
                "ok": 200 <= response.status < 400,
                "status": response.status,
                "elapsed_seconds": round(time.monotonic() - started, 3),
            }
    except (
        OSError,
        urllib.error.URLError,
        UnicodeDecodeError,
        json.JSONDecodeError,
    ) as error:
        return {
            "ok": False,
            "error": str(error),
            "elapsed_seconds": round(time.monotonic() - started, 3),
        }


def http_checks_parallel(
    checks: dict[str, tuple[str, bool]],
) -> dict[str, dict[str, Any]]:
    with ThreadPoolExecutor(max_workers=len(checks)) as executor:
        futures = {
            name: executor.submit(http_check, url, parse_json=parse_json)
            for name, (url, parse_json) in checks.items()
        }
        return {name: future.result() for name, future in futures.items()}


def render_browser_page(
    url: str,
    markers: tuple[str, ...],
) -> dict[str, Any]:
    """Render one page locally, isolating and retrying Chrome startup jitter."""
    last: dict[str, Any] = {"ok": False, "attempts": 0}
    for attempt, timeout_seconds in enumerate((20, 35), start=1):
        with tempfile.TemporaryDirectory(
            prefix="argus-open-browser-page-"
        ) as profile:
            command = [
                str(CHROME),
                "--headless=new",
                "--no-sandbox",
                "--disable-gpu",
                "--disable-dev-shm-usage",
                "--disable-background-networking",
                "--disable-extensions",
                "--disable-sync",
                "--no-first-run",
                "--no-default-browser-check",
                f"--user-data-dir={profile}",
                "--virtual-time-budget=6000",
                "--dump-dom",
                url,
            ]
            process: subprocess.Popen[str] | None = None
            try:
                process = subprocess.Popen(
                    command,
                    text=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    start_new_session=(os.name != "nt"),
                )
                stdout, stderr = process.communicate(timeout=timeout_seconds)
                completed = subprocess.CompletedProcess(
                    command,
                    process.returncode,
                    stdout,
                    stderr,
                )
            except subprocess.TimeoutExpired:
                if process is not None:
                    if os.name != "nt":
                        try:
                            os.killpg(process.pid, signal.SIGTERM)
                        except (ProcessLookupError, OSError):
                            pass
                    else:  # pragma: no cover - Windows supervisor host
                        process.terminate()
                    try:
                        process.communicate(timeout=2)
                    except subprocess.TimeoutExpired:
                        if os.name != "nt":
                            try:
                                os.killpg(process.pid, signal.SIGKILL)
                            except (ProcessLookupError, OSError):
                                pass
                        else:  # pragma: no cover - Windows supervisor host
                            process.kill()
                        process.communicate()
                last = {
                    "ok": False,
                    "timeout": True,
                    "attempts": attempt,
                    "timeout_seconds": timeout_seconds,
                }
                continue
            finally:
                # Chrome may leave utility children alive after its browser
                # process exits.  They inherit this private process group and
                # must be stopped before TemporaryDirectory removes profile.
                if process is not None and os.name != "nt":
                    try:
                        os.killpg(process.pid, signal.SIGTERM)
                    except (ProcessLookupError, OSError):
                        pass
        rendered = completed.stdout
        error_page = "This page couldn’t load" in rendered
        reconnecting = any(
            marker in rendered for marker in ("Reconnecting", "正在重连")
        )
        marker_found = any(marker in rendered for marker in markers)
        last = {
            "ok": (
                completed.returncode == 0
                and not error_page
                and not reconnecting
                and marker_found
            ),
            "exit_code": completed.returncode,
            "error_page": error_page,
            "reconnecting": reconnecting,
            "marker_found": marker_found,
            "attempts": attempt,
        }
        if last["ok"]:
            return last
    return last


def browser_render_check(state: dict[str, Any]) -> dict[str, Any]:
    now = time.time()
    cached = state.get("browser_render") or {}
    if (
        now - float(cached.get("checked_at_epoch") or 0)
        < BROWSER_RENDER_INTERVAL_SECONDS
        and isinstance(cached.get("result"), dict)
        and bool(cached["result"].get("ok"))
        and cached["result"].get("schema_version") == BROWSER_RENDER_SCHEMA_VERSION
    ):
        return dict(cached["result"])
    started = time.monotonic()
    try:
        page_specs = (
                (
                    "home",
                    "http://127.0.0.1:8810/#counterexample-live",
                    ("Counterexample campaigns", "正在找反例"),
                ),
                (
                    "catalog",
                    "http://127.0.0.1:8810/catalog",
                    (
                        "Every source record and its audit status",
                        "全部问题与逐条审计结论",
                    ),
                ),
                (
                    "result_2307015",
                    "http://127.0.0.1:8810/results/2307015",
                    (
                        "EXACT WITNESS",
                        "INTERPRETATION BOUNDARY EXPLICIT",
                        "RESULT 2307015",
                    ),
                ),
                (
                    "result_2813",
                    "http://127.0.0.1:8810/results/2813",
                    (
                        "EXPLICIT REPLAY OF A KNOWN THEOREM",
                        "既有定理的显式复算",
                        "RESULT 2813",
                        "核心障碍来自 Liu 论文",
                    ),
                ),
                (
                    "result_4600048",
                    "http://127.0.0.1:8810/results/4600048",
                    (
                        "LITERAL Q-EQUALITY REFUTED",
                        "字面 Q 等式被反驳",
                        "SCHMIDT Q(BETA) PROBLEM REMAINS OPEN",
                        "Schmidt 的 Q(β) 问题仍开放",
                    ),
                ),
                (
                    "result_3206",
                    "http://127.0.0.1:8810/results/3206",
                    (
                        "KNOWN COUNTEREXAMPLE RECONSTRUCTED",
                        "已知反例重构",
                        "CORE C",
                        "核为 C",
                    ),
                ),
                (
                    "result_11000263",
                    "http://127.0.0.1:8810/results/11000263",
                    (
                        "INTERNAL REVIEW PASSED",
                        "内部复核通过",
                        "SOURCE INDEXING ERROR IDENTIFIED",
                        "原文索引错误已识别",
                    ),
                ),
                (
                    "result_20000320",
                    "http://127.0.0.1:8810/results/20000320",
                    (
                        "LITERATURE COUNTEREXAMPLE",
                        "文献反例",
                        "ARTIN THICKENING",
                        "Artin 厚化",
                    ),
                ),
                (
                    "result_20000916",
                    "http://127.0.0.1:8810/results/20000916",
                    (
                        "LITERAL-CLAIM COUNTEREXAMPLE",
                        "字面命题反例",
                        "EXPLICIT FAMILY",
                        "显式构造",
                    ),
                ),
                (
                    "result_20001382",
                    "http://127.0.0.1:8810/results/20001382",
                    (
                        "LITERAL-SCOPE CORRECTION",
                        "字面范围纠正",
                        "NONCLOSED SUBGROUP",
                        "非闭子群",
                    ),
                ),
                (
                    "result_20001836",
                    "http://127.0.0.1:8810/results/20001836",
                    (
                        "PROJECT-PRODUCED EXACT COMPACT CONSTRUCTION",
                        "项目自产精确紧致构造",
                        "NOVELTY NOT INDEPENDENTLY VERIFIED",
                        "创新性未通过独立审计",
                    ),
                ),
                (
                    "result_20001068",
                    "http://127.0.0.1:8810/results/20001068",
                    (
                        "PROJECT-PRODUCED EXACT COUNTEREXAMPLE",
                        "项目自产精确反例",
                        "NOVELTY NOT INDEPENDENTLY VERIFIED",
                        "创新性未通过独立审计",
                        "26 VERTICES",
                        "26 个顶点",
                    ),
                ),
                (
                    "result_20001862",
                    "http://127.0.0.1:8810/results/20001862",
                    (
                        "KNOWN NEGATIVE STATUS",
                        "已知否定结论",
                        "RECORDED FALSE IN 2015",
                        "2015 年已记载为 FALSE",
                    ),
                ),
                (
                    "result_2884",
                    "http://127.0.0.1:8810/results/2884",
                    (
                        "PROJECT-PRODUCED PROBLEM-LIST SCOPE OBSERVATION",
                        "项目自产问题表范围发现",
                        "INDEPENDENT PRIORITY REVIEW REQUIRED",
                        "需要独立优先权审计",
                    ),
                ),
            )
        with ThreadPoolExecutor(max_workers=min(4, len(page_specs))) as executor:
            futures = {
                name: executor.submit(render_browser_page, url, markers)
                for name, url, markers in page_specs
            }
            pages = {
                name: futures[name].result()
                for name, _url, _markers in page_specs
            }
        result = {
            "schema_version": BROWSER_RENDER_SCHEMA_VERSION,
            "ok": all(page.get("ok") for page in pages.values()),
            "pages": pages,
            "elapsed_seconds": round(time.monotonic() - started, 3),
            "checked_at": datetime.fromtimestamp(now, UTC).isoformat(),
        }
    except (OSError, subprocess.TimeoutExpired) as error:
        result = {
            "ok": False,
            "error": str(error),
            "elapsed_seconds": round(time.monotonic() - started, 3),
            "checked_at": datetime.fromtimestamp(now, UTC).isoformat(),
        }
    state["browser_render"] = {"checked_at_epoch": now, "result": result}
    return result


def failure_recovery(
    state: dict[str, Any],
    key: str,
    ok: bool,
    threshold: int,
    service: str,
) -> dict[str, Any] | None:
    failures = state.setdefault("failure_counts", {})
    failures[key] = 0 if ok else int(failures.get(key, 0)) + 1
    if ok or failures[key] < threshold or not restart_allowed(state, service):
        return None
    result = restart_service(service)
    mark_restart(state, service)
    failures[key] = 0
    return result


def generated_age_seconds() -> int | None:
    payload = load_json(LIVE_DATA, {})
    generated_at = payload.get("generated_at")
    if not generated_at:
        return None
    try:
        generated = datetime.fromisoformat(str(generated_at).replace("Z", "+00:00"))
    except ValueError:
        return None
    return max(0, int((datetime.now(UTC) - generated.astimezone(UTC)).total_seconds()))


def host_memory_snapshot() -> dict[str, Any]:
    values: dict[str, int] = {}
    try:
        for line in Path("/proc/meminfo").read_text(encoding="ascii").splitlines():
            name, raw = line.split(":", 1)
            fields = raw.split()
            if fields:
                values[name] = int(fields[0]) * 1024
    except (OSError, ValueError):
        return {"available": False, "pressure": False}
    total = values.get("MemTotal", 0)
    available = values.get("MemAvailable", 0)
    threshold = max(32 * 1024**3, int(total * 0.08)) if total else 0
    return {
        "available": bool(total and available),
        "total_bytes": total,
        "available_bytes": available,
        "available_percent": round(100 * available / total, 2) if total else None,
        "pressure_threshold_bytes": threshold,
        "pressure": bool(total and available < threshold),
    }


def host_disk_snapshot(path: Path = WORKSPACE) -> dict[str, Any]:
    try:
        stat = os.statvfs(path)
    except OSError:
        return {"available": False, "pressure": False, "critical": False}
    block_size = stat.f_frsize or stat.f_bsize
    total = stat.f_blocks * block_size
    available = stat.f_bavail * block_size
    pressure_threshold = 32 * 1024**3 if total else 0
    critical_threshold = 16 * 1024**3 if total else 0
    return {
        "available": bool(total),
        "path": str(path),
        "total_bytes": total,
        "available_bytes": available,
        "available_percent": round(100 * available / total, 2) if total else None,
        "pressure_threshold_bytes": pressure_threshold,
        "critical_threshold_bytes": critical_threshold,
        "pressure": bool(total and available < pressure_threshold),
        "critical": bool(total and available < critical_threshold),
    }


def read_csv_rows(path: Path) -> list[dict[str, str]]:
    if not path.is_file():
        return []
    try:
        with path.open(encoding="utf-8-sig", newline="") as handle:
            return list(csv.DictReader(handle))
    except OSError:
        return []


def audit_workdirs(shard: str) -> list[Path]:
    if shard == "01":
        return [ROOT / "audit-shards" / "01"]
    return [
        ROOT / "audit-shards" / "02-retry1",
        ROOT / "audit-shards" / "02",
    ]


def audit_artifact_alerts(shard: str) -> list[str]:
    alerts: list[str] = []
    for workdir in audit_workdirs(shard):
        evidence = workdir / "evidence"
        if not evidence.is_dir():
            continue
        for readme in evidence.glob("*/README.md"):
            try:
                prefix = readme.read_text(encoding="utf-8-sig")[:2_000].lstrip()
            except OSError as error:
                alerts.append(f"{readme}: unreadable ({error})")
                continue
            if not prefix:
                alerts.append(f"{readme}: empty")
            elif prefix[0] in "{[":
                alerts.append(f"{readme}: looks like a JSON payload")
        for candidate in workdir.glob(".work/**/result.csv"):
            try:
                prefix = candidate.read_text(encoding="utf-8-sig")[:2_000].lstrip()
            except OSError as error:
                alerts.append(f"{candidate}: unreadable ({error})")
                continue
            if prefix and prefix[0] in "{[":
                alerts.append(f"{candidate}: staging CSV looks like a JSON payload")
    return alerts


def known_campaign_semantic_alerts(
    campaign_id: str,
    project_root: Path,
) -> list[str]:
    """Reject known withdrawn claims that schema-only validators cannot see."""
    if campaign_id != "11000263":
        return []
    alerts: list[str] = []
    state = load_json(project_root / "research" / "MATH_STATE.json", {})
    claims = state.get("claims") if isinstance(state, dict) else None
    q4_claims = [
        claim
        for claim in claims or []
        if isinstance(claim, dict) and claim.get("claim_id") == "C-Q4"
    ]
    if q4_claims:
        latest = max(q4_claims, key=lambda claim: int(claim.get("version") or 0))
        statement = str(latest.get("natural_statement") or "")
        if "dimension 178" in statement or "dimension 73" in statement:
            alerts.append(
                "semantic:withdrawn-C-Q4-remains-latest: replace the rejected "
                "178/73 semisimple claim with the reviewed characteristic-zero "
                "bounds and mark the historical claim refuted"
            )
        withdrawn_hashes = {
            str(claim.get("content_hash") or "")
            for claim in q4_claims
            if "dimension 178" in str(claim.get("natural_statement") or "")
            or "dimension 73" in str(claim.get("natural_statement") or "")
        }
        evidence = state.get("evidence") if isinstance(state, dict) else None
        for content_hash in sorted(withdrawn_hashes):
            verdicts = {
                str(item.get("verdict") or "")
                for item in evidence or []
                if isinstance(item, dict)
                and isinstance(item.get("subject"), dict)
                and item["subject"].get("subject_id") == "C-Q4"
                and item["subject"].get("content_hash") == content_hash
            }
            if "supports" in verdicts and "refutes" not in verdicts:
                alerts.append(
                    "semantic:withdrawn-C-Q4-still-supported: add an explicit "
                    "claim-level refutation judgement for the historical "
                    "178/73 content hash"
                )
                break
    state_routes = state.get("routes") if isinstance(state, dict) else None
    for route in state_routes or []:
        if not isinstance(route, dict):
            continue
        retired = str(route.get("retired_because") or "")
        if "additional M_8 block and dimension 73" in retired:
            alerts.append(
                "semantic:withdrawn-C-Q4-in-retirement-reason: a retired route "
                "still cites the rejected M8/73 conclusion as fact"
            )
            break

    graph = load_json(project_root / "research" / "PROOF_GRAPH.json", {})
    nodes = graph.get("nodes") if isinstance(graph, dict) else None
    q4_node = nodes.get("C-Q4") if isinstance(nodes, dict) else None
    if isinstance(q4_node, dict):
        statement = str(q4_node.get("statement") or "")
        status = str(q4_node.get("status") or "")
        if (
            ("dimension 178" in statement or "dimension 73" in statement)
            and status not in {"refuted", "withdrawn", "ruled_out"}
        ):
            alerts.append(
                "semantic:withdrawn-C-Q4-proof-node-active: the proof graph "
                "still presents the rejected 178/73 statement as active"
            )
    routes = graph.get("routes") if isinstance(graph, dict) else None
    for route in routes or []:
        if not isinstance(route, dict):
            continue
        evidence = str(route.get("evidence") or "")
        if "squared dimensions 9 and 64" in evidence:
            alerts.append(
                "semantic:stale-semisimple-Wa-route-evidence: replace the "
                "invalid M3/M8 block count with the singular W_a image and "
                "finite-field-only J4 module evidence"
            )
            break
    return alerts


def campaign_artifact_alerts(campaign_id: str) -> list[str]:
    """Return structural math-ledger/proof-graph failures without restarting.

    These failures are not runtime crashes, so they must not enter the daemon
    recovery path.  They are nevertheless review blockers: stale claim
    versions, ambiguous assumption IDs, nonstandard graph states, or proved
    nodes without Reviewer confirmation can make the public gap look smaller
    than the evidence warrants.
    """
    project_root = ROOT / "campaigns" / campaign_id
    checks = (
        (
            "math_state",
            [
                str(ARGUS_PYTHON),
                "-m",
                "argus_skill.verticals.math.math_state",
                "check",
                "--project-root",
                str(project_root),
            ],
        ),
        (
            "proof_graph",
            [
                str(ARGUS_PYTHON),
                "-m",
                "argus_skill.verticals.math.proof_graph_check",
                "check",
                "--project-root",
                str(project_root),
            ],
        ),
    )
    alerts: list[str] = []
    for label, command in checks:
        try:
            completed = subprocess.run(
                command,
                cwd=project_root,
                text=True,
                capture_output=True,
                timeout=30,
                check=False,
            )
        except (OSError, subprocess.TimeoutExpired) as error:
            alerts.append(f"{label}: check failed to run ({error})")
            continue
        if completed.returncode == 0:
            continue
        output = (completed.stdout + "\n" + completed.stderr).strip()
        if label == "math_state":
            try:
                payload = json.loads(completed.stdout)
            except json.JSONDecodeError:
                payload = {}
            issues = payload.get("issues") if isinstance(payload, dict) else None
            if isinstance(issues, list) and issues:
                for issue in issues[:20]:
                    if not isinstance(issue, dict):
                        continue
                    code = str(issue.get("code") or "invalid")
                    path = str(issue.get("path") or "")
                    alerts.append(f"{label}:{code}:{path}")
                continue
        lines = [line.strip() for line in output.splitlines() if line.strip()]
        for line in lines[:20]:
            alerts.append(f"{label}:{line[:500]}")
        if not lines:
            alerts.append(f"{label}: exited {completed.returncode} without output")
    alerts.extend(known_campaign_semantic_alerts(campaign_id, project_root))
    return alerts


def normalize_known_campaign_proof_graph_statuses(
    campaign_id: str,
) -> dict[str, Any] | None:
    """Repair a known recurring schema-only overwrite before validation.

    Campaign 8200002 repeatedly rewrites C43's judgement-tier equivalence
    evidence as the non-schema node status ``supported``.  The mathematical
    goal remains open; the support belongs in ``evidence_status``.  Keep this
    repair deliberately node-specific so the supervisor never guesses how to
    translate a new or unfamiliar mathematical status.
    """
    if campaign_id != "8200002":
        return None
    path = ROOT / "campaigns" / campaign_id / "research" / "PROOF_GRAPH.json"
    try:
        original = path.read_text(encoding="utf-8")
        graph = json.loads(original)
    except (OSError, json.JSONDecodeError):
        return None
    nodes = graph.get("nodes") if isinstance(graph, dict) else None
    node = nodes.get("C43") if isinstance(nodes, dict) else None
    if not isinstance(node, dict) or node.get("status") != "supported":
        return None
    node["status"] = "open"
    node.setdefault("evidence_status", "reviewer_supported_equivalence")
    replacement = json.dumps(graph, ensure_ascii=False, indent=2) + "\n"
    temporary = path.with_name(f".{path.name}.{os.getpid()}.normalize.tmp")
    try:
        temporary.write_text(replacement, encoding="utf-8")
        if path.read_text(encoding="utf-8") != original:
            return None
        temporary.replace(path)
    except OSError:
        return None
    finally:
        temporary.unlink(missing_ok=True)
    return {
        "target": f"campaign:{campaign_id}",
        "action": "normalize_known_proof_graph_status",
        "node": "C43",
        "from": "supported",
        "to": "open",
        "evidence_status": "reviewer_supported_equivalence",
    }


def queue_campaign_artifact_repair(
    campaign_id: str,
    record: dict[str, Any],
    alerts: list[str],
    state: dict[str, Any],
) -> dict[str, Any] | None:
    """Queue one repair notice whenever an idle campaign's alert set changes.

    Never queue a structural-gate inbox notice while a role/backend is actively
    running: mid-turn edits to MATH_STATE.json or PROOF_GRAPH.json can trigger
    transient check errors, and an inbox directive hijacks the next round into
    a structural-only repair turn instead of advancing the mathematical proof.
    """
    key = f"campaign:{campaign_id}"
    fingerprints = state.setdefault("artifact_alert_fingerprints", {})
    if not alerts:
        fingerprints.pop(key, None)
        return None
    if record.get("backend_active") or record.get("active_role"):
        return None
    if not record.get("life_dir"):
        return None
    fingerprint = hashlib.sha256("\n".join(alerts).encode("utf-8")).hexdigest()
    life = Path(str(record["life_dir"]))
    life_fingerprint = f"{life}:{fingerprint}"
    if fingerprints.get(key) == life_fingerprint:
        return None
    if not life.is_dir():
        return None
    try:
        source_path = str(ARGUS_SOURCE)
        if source_path not in sys.path:
            sys.path.insert(0, source_path)
        from argus_skill.apps._inbox import queue_inbox_message

        listed = "\n".join(f"- {alert}" for alert in alerts[:20])
        message = (
            f"Supervisor campaign-local structural gate for {campaign_id}: "
            "the official project-level math-state and/or proof-graph check "
            "currently fails. Preserve all mathematical artifacts and repair "
            "only the reported identifier, version, evidence-reference, "
            "status, or Reviewer-confirmation defects. Run both commands from "
            "this campaign workdir with PROJECT_ROOT=$(pwd -P):\n"
            f"{ARGUS_PYTHON} -m argus_skill.verticals.math.math_state check "
            "--project-root \"$PROJECT_ROOT\"\n"
            f"{ARGUS_PYTHON} -m argus_skill.verticals.math.proof_graph_check check "
            "--project-root \"$PROJECT_ROOT\"\n"
            "Do not hand off or accept the mission until both exit zero. "
            "Current failures:\n"
            f"{listed}"
        )
        queue_inbox_message(
            life,
            message,
            source="fleet-supervisor.campaign-local-structural-gate",
        )
    except Exception as error:  # noqa: BLE001 - keep repair observable
        return {
            "target": key,
            "action": "queue_structural_repair_failed",
            "error": str(error),
        }
    fingerprints[key] = life_fingerprint
    return {
        "target": key,
        "action": "queue_campaign_local_structural_repair",
        "alert_count": len(alerts),
        "fingerprint": fingerprint[:16],
    }


def audit_progress(shard: str) -> dict[str, Any]:
    workdirs = audit_workdirs(shard)
    final_by_id: dict[str, dict[str, str]] = {}
    staged_by_id: dict[str, dict[str, str]] = {}
    for workdir in workdirs:
        for row in read_csv_rows(workdir / "result.csv"):
            if row.get("ID"):
                final_by_id[row["ID"]] = row
        for path in workdir.glob(".work/**/result.csv"):
            status = path.parent / "validate_candidate.status"
            if not status.is_file() or status.read_text(encoding="utf-8").strip() != "0":
                continue
            if status.stat().st_mtime < path.stat().st_mtime:
                continue
            for row in read_csv_rows(path):
                if row.get("ID") and row["ID"] not in final_by_id:
                    staged_by_id.setdefault(row["ID"], row)
    return {
        "final_rows": len(final_by_id),
        "independently_verified": sum(
            row.get("review_status") == "independently_verified"
            for row in final_by_id.values()
        ),
        "staged_rows": len(staged_by_id),
    }


def candidate_signal(campaign_id: str) -> dict[str, Any] | None:
    path = ROOT / "campaigns" / campaign_id / "activity.jsonl"
    if not path.is_file():
        return None
    try:
        with path.open("rb") as handle:
            handle.seek(max(0, path.stat().st_size - 2_000_000))
            raw = handle.read()
    except OSError:
        return None
    if path.stat().st_size > len(raw):
        raw = raw.partition(b"\n")[2]
    positive = re.compile(
        r"(?i)(found|produced|materialized|obtained).{0,30}(exact |valid )?counterexample"
        r"|(exact |valid )?counterexample.{0,30}(found|verified|accepted|certified)"
        r"|(found|produced|materialized|obtained).{0,30}checker-accepted (integer )?witness"
    )
    negative = re.compile(
        r"(?i)no[- ](valid |exact )?(counterexample|witness)"
        r"|\bno\b.{0,60}\b(counterexample|witness)\b"
        r"|found no.{0,80}(counterexample|witness)"
        r"|zero[- ]candidate|candidate count (?:is )?zero"
        r"|\b(?:unrestricted )?witness\b.{0,40}\bremains? open\b"
        r"|without (a )?(counterexample|witness)|not a counterexample"
        r"|not counted as (a )?counterexample"
        r"|rather than (a )?counterexample|failed candidate|candidate-or|witness-or"
        r"|does not (?:claim|establish|provide|constitute|prove|yield).{0,80}counterexample"
        r"|counterexample[_ -]certified.{0,12}false"
        r"|counterexample.{0,24}uncertified"
        r"|\b(?:obj|objective|project|global (?:claim|goal|problem))\b.{0,40}\b"
        r"(?:remains?|is still) open\b"
    )
    reviewer_revocation = re.compile(
        r"(?i)replan|conditional|inconclusive|reject|refut|retir|failed"
        r"|ruled[_ -]?out|partial|route[_ -]?local|scoped|not[_ -]?certified"
        r"|not[_ -]?supported|\b(?:obj|objective|project|global (?:claim|goal|problem))\b"
        r".{0,40}\b(?:remains?|is still) open\b"
    )
    latest: dict[str, Any] | None = None
    for line in raw.decode("utf-8", "replace").splitlines():
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        action_text = str(event.get("action", ""))
        # Paths and adjacent JSON fields are not mathematical assertions.  In
        # particular, the repository name ``counterexample-batch-1`` followed
        # by a ``verified`` status used to satisfy the positive regex after the
        # fields were concatenated.  Keep status semantics structured and run
        # prose matching only inside the action field.
        semantic_action = action_text.replace(str(ROOT), "").replace(ROOT.name, "")
        status_text = str(event.get("status", ""))
        role_text = str(event.get("role", ""))
        # Candidate signals are a projection of the latest independent verdict,
        # not an append-only history.  A later Reviewer rejection/replan must
        # revoke an earlier positive signal from the same campaign; otherwise a
        # route-local acceptance remains visible after project-level review has
        # explicitly left the objective open.
        if latest is not None and (
            negative.search(semantic_action)
            or negative.search(status_text)
            or (
                role_text.lower() == "reviewer"
                and (
                    reviewer_revocation.search(semantic_action)
                    or reviewer_revocation.search(status_text)
                )
            )
        ):
            latest = None
            continue
        explicit_candidate_false = re.search(
            r"(?i)\b(?:is_?counterexample|counterexample_found|candidate_found"
            r"|checker_accepted_witness)\s*[:=]\s*false\b",
            f"{semantic_action}\n{status_text}",
        )
        explicit_candidate_true = re.search(
            r"(?i)\b(?:is_?counterexample|counterexample_found|candidate_found"
            r"|checker_accepted_witness)\s*[:=]\s*true\b",
            f"{semantic_action}\n{status_text}",
        )
        if explicit_candidate_false and not explicit_candidate_true:
            continue
        if re.search(
            r"(?i)replan|pending|continue|in_progress|running|uncertified"
            r"|ruled[_ -]?out|partial|route[_ -]?local|scoped|no_candidate|not_counterexample",
            status_text,
        ):
            continue
        structured_status = re.search(
            r"(?i)counterexample_(found|verified|accepted)"
            r"|verified_counterexample|checker_accepted_witness",
            status_text,
        )
        if (
            structured_status or positive.search(semantic_action)
        ) and not negative.search(semantic_action):
            latest = {
                "campaign_id": campaign_id,
                "ts": event.get("ts", ""),
                "role": event.get("role", ""),
                "status": event.get("status", ""),
                "action": event.get("action", ""),
                "artifact": event.get("artifact", ""),
                "requires_manual_verification": True,
            }
    return latest


def provisional_candidate_signals() -> list[dict[str, Any]]:
    signals: list[dict[str, Any]] = []
    for path in sorted((ROOT / "supervisor-evidence").glob("*/candidate.json")):
        payload = load_json(path, {})
        if not isinstance(payload, dict):
            continue
        if payload.get("status") not in {
            "pending_independent_review",
            "review_in_progress",
            "reviewer_accepted_pending_integration",
            "independently_verified",
        }:
            continue
        evidence = payload.get("evidence")
        if not isinstance(evidence, list) or not evidence:
            continue
        if not all((ROOT / str(item)).is_file() for item in evidence):
            continue
        signals.append(
            {
                "id": str(payload.get("id", path.parent.name)),
                "kind": str(payload.get("kind", "provisional_candidate")),
                "status": str(payload.get("status", "pending_independent_review")),
                "confidence": str(payload.get("confidence", "lead")),
                "audit_shard": str(payload.get("audit_shard", "")),
                "title": str(payload.get("title", "")),
                "title_en": str(payload.get("title_en", payload.get("title", ""))),
                "summary": str(payload.get("summary", "")),
                "summary_en": str(payload.get("summary_en", payload.get("summary", ""))),
                "evidence": [str(item) for item in evidence],
                "updated_at": str(payload.get("updated_at", "")),
                "project_produced": bool(payload.get("project_produced", False)),
                "requires_novelty_review": bool(
                    payload.get("requires_novelty_review", False)
                ),
                "novelty_status": str(payload.get("novelty_status", "")),
                "novelty_reviewer_status": str(
                    payload.get("novelty_reviewer_status", "")
                ),
                "requires_manual_verification": bool(
                    payload.get("requires_manual_verification", True)
                ),
            }
        )
    return signals


def professional_pdf_alerts(
    signals: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    alerts: list[dict[str, Any]] = []
    for signal_record in signals:
        if signal_record.get("status") != "independently_verified":
            continue
        result_id = str(signal_record.get("id", "")).strip()
        if not result_id or result_id in PROFESSIONAL_PDF_GRANDFATHERED_IDS:
            continue
        source = (
            WORKSPACE
            / "open-conjectures-live"
            / "reports"
            / result_id
            / f"ARGUS_RESULT_{result_id}_TECHNICAL_REPORT.tex"
        )
        public_pdf = (
            WORKSPACE
            / "open-conjectures-live"
            / "public"
            / "results"
            / result_id
            / f"ARGUS_RESULT_{result_id}_TECHNICAL_REPORT.pdf"
        )
        reasons: list[str] = []
        if not source.is_file():
            reasons.append("missing_english_ams_source")
        else:
            try:
                source_text = source.read_text(encoding="utf-8")
            except OSError:
                reasons.append("unreadable_report_source")
            else:
                if "amsart" not in source_text:
                    reasons.append("report_source_is_not_amsart")
                if re.search(r"[\u3400-\u4dbf\u4e00-\u9fff]", source_text):
                    reasons.append("report_source_contains_cjk_text")
                if re.search(
                    r"\\(?:url|urladdr|href)\b|https?://|www\.",
                    source_text,
                    re.IGNORECASE,
                ):
                    reasons.append("report_source_contains_raw_web_address")
                if re.search(r"sha-?256|audit[- ]root", source_text, re.IGNORECASE):
                    reasons.append("report_source_contains_pipeline_metadata")
        if not public_pdf.is_file():
            reasons.append("missing_public_pdf")
        else:
            try:
                if public_pdf.stat().st_size < 10_000:
                    reasons.append("public_pdf_is_too_small")
            except OSError:
                reasons.append("unreadable_public_pdf")
        if reasons:
            alerts.append(
                {
                    "id": result_id,
                    "reasons": reasons,
                    "report_source": str(source.relative_to(WORKSPACE)),
                    "public_pdf": str(public_pdf.relative_to(WORKSPACE)),
                }
            )
    return alerts


def main() -> None:
    global CAMPAIGN_IDS
    state = load_json(STATE, {})
    durable_jobs = external_durable_jobs_by_workdir()
    timebox_actions = retire_expired_campaigns(state, durable_jobs)
    CAMPAIGN_IDS, rotation_actions = select_active_campaign_ids(state)
    actions: list[dict[str, Any]] = [*timebox_actions, *rotation_actions]
    durable_jobs = external_durable_jobs_by_workdir()

    campaigns = {
        campaign_id: runtime_record(
            campaign_id,
            exact_campaign_homes(campaign_id),
            expected_campaign_id=campaign_id,
            external_jobs=external_jobs_under(
                durable_jobs,
                ROOT / "campaigns" / campaign_id,
            ),
        )
        for campaign_id in CAMPAIGN_IDS
    }
    for campaign_id in CAMPAIGN_IDS:
        if action := normalize_known_campaign_proof_graph_statuses(campaign_id):
            actions.append(action)
    with ThreadPoolExecutor(max_workers=min(8, len(CAMPAIGN_IDS))) as executor:
        campaign_artifacts = dict(
            zip(CAMPAIGN_IDS, executor.map(campaign_artifact_alerts, CAMPAIGN_IDS))
        )
    for campaign_id, record in campaigns.items():
        record["mission_contract_issues"] = mission_contract_issues(record)
        record["artifact_alerts"] = campaign_artifacts.get(campaign_id, [])
        actions.extend(
            enforce_mission_contract(f"campaign:{campaign_id}", record, state)
        )
        if action := abort_invalid_reviewer_mission(
            f"campaign:{campaign_id}",
            record,
            record["mission_contract_issues"],
            state,
        ):
            actions.append(action)
        if action := queue_campaign_artifact_repair(
            campaign_id,
            record,
            record["artifact_alerts"],
            state,
        ):
            actions.append(action)
    for campaign_id, record in campaigns.items():
        if action := recover_campaign(campaign_id, record, state):
            actions.append(action)
        if action := maintain_pending_daemon_upgrade(
            f"campaign:{campaign_id}",
            record,
        ):
            actions.append(action)

    audits = (
        {
            shard: runtime_record(
                f"audit-{shard}",
                [Path(str(spec["home"]))],
                expected_audit_workdir=f"{shard}{spec['workdir_suffix']}",
                external_jobs=external_jobs_under(
                    durable_jobs,
                    ROOT / "audit-shards" / f"{shard}{spec['workdir_suffix']}",
                ),
            )
            for shard, spec in AUDIT_RUNTIMES.items()
        }
        if bool(state.get("audits_enabled", True))
        else {}
    )
    for shard, record in audits.items():
        record["mission_contract_issues"] = mission_contract_issues(record)
        record["artifact_alerts"] = audit_artifact_alerts(shard)
        actions.extend(
            enforce_mission_contract(f"audit:{shard}", record, state)
        )
        if action := abort_invalid_reviewer_mission(
            f"audit:{shard}",
            record,
            record["mission_contract_issues"],
            state,
        ):
            actions.append(action)
    for shard, record in audits.items():
        if action := recover_audit(shard, record, state):
            actions.append(action)
        if action := maintain_pending_daemon_upgrade(f"audit:{shard}", record):
            actions.append(action)

    # Resource protection must run before browser rendering.  A full browser
    # pass starts four Chrome process groups and can briefly consume hundreds
    # of megabytes while a q384 proof stream is already crossing the disk
    # threshold.  Snapshot and stop heavy work first.
    host_memory = host_memory_snapshot()
    host_disk = host_disk_snapshot()
    concurrency_actions = limit_1417_hybrid_prefix_concurrency(campaigns)
    if concurrency_actions:
        actions.extend(concurrency_actions)
        if guidance := queue_1417_concurrency_cap_guidance(
            campaigns.get("1417", {}), state
        ):
            actions.append(guidance)
        if release := release_repeated_1417_concurrency_violator(
            campaigns.get("1417", {}), state
        ):
            actions.append(release)
    stream_cleanup_actions = prune_scoped_inactive_runtime_streams(host_disk)
    if stream_cleanup_actions:
        actions.extend(stream_cleanup_actions)
        host_disk = host_disk_snapshot()
    shard_disk_actions = disk_pressure_1417_jobs(campaigns, host_disk, state)
    if shard_disk_actions:
        actions.extend(shard_disk_actions)
        host_disk = host_disk_snapshot()
    raw_q384_actions = disk_pressure_q384_raw_proof_jobs(campaigns, host_disk)
    if raw_q384_actions:
        actions.extend(raw_q384_actions)
        host_disk = host_disk_snapshot()
    disk_actions = disk_pressure_q384_jobs(campaigns, host_disk, state)
    if disk_actions:
        actions.extend(disk_actions)
        host_disk = host_disk_snapshot()
    cado_disk_actions = disk_pressure_cado_jobs(campaigns, host_disk, state)
    if cado_disk_actions:
        actions.extend(cado_disk_actions)
        host_disk = host_disk_snapshot()

    services = {service: systemd_active(service) for service in SITE_SERVICES}
    for service, active in services.items():
        if not active and restart_allowed(state, service):
            actions.append(restart_service(service))
            mark_restart(state, service)

    cache_bust = time.time_ns()
    local_checks = http_checks_parallel(
        {
            "home": ("http://127.0.0.1:8810/", False),
            "live_data": (
                f"http://127.0.0.1:8810/open-data.json?t={cache_bust}",
                True,
            ),
            "workbench": ("http://127.0.0.1:8810/workbench/1417", False),
            "catalog": ("http://127.0.0.1:8810/catalog", False),
            "catalog_data": (
                f"http://127.0.0.1:8810/catalog-table.json?t={cache_bust}",
                True,
            ),
            "result_2307015": (
                "http://127.0.0.1:8810/results/2307015",
                False,
            ),
            "result_2813": (
                "http://127.0.0.1:8810/results/2813",
                False,
            ),
            "result_4600048": (
                "http://127.0.0.1:8810/results/4600048",
                False,
            ),
            "result_11000263": (
                "http://127.0.0.1:8810/results/11000263",
                False,
            ),
            "result_3206": (
                "http://127.0.0.1:8810/results/3206",
                False,
            ),
            "result_20000320": (
                "http://127.0.0.1:8810/results/20000320",
                False,
            ),
            "result_20000916": (
                "http://127.0.0.1:8810/results/20000916",
                False,
            ),
            "result_20001068": (
                "http://127.0.0.1:8810/results/20001068",
                False,
            ),
            "result_20001382": (
                "http://127.0.0.1:8810/results/20001382",
                False,
            ),
            "result_20001836": (
                "http://127.0.0.1:8810/results/20001836",
                False,
            ),
            "result_20001862": (
                "http://127.0.0.1:8810/results/20001862",
                False,
            ),
            "result_2884": (
                "http://127.0.0.1:8810/results/2884",
                False,
            ),
        }
    )
    public_checks = http_checks_parallel(
        {
            "home": ("https://open.argusbot.cn/", False),
            "live_data": (
                f"https://open.argusbot.cn/open-data.json?t={cache_bust}",
                True,
            ),
            "workbench": ("https://open.argusbot.cn/workbench/1417", False),
            "catalog": ("https://open.argusbot.cn/catalog", False),
            "catalog_data": (
                f"https://open.argusbot.cn/catalog-table.json?t={cache_bust}",
                True,
            ),
            "result_2307015": (
                "https://open.argusbot.cn/results/2307015",
                False,
            ),
            "result_2813": (
                "https://open.argusbot.cn/results/2813",
                False,
            ),
            "result_4600048": (
                "https://open.argusbot.cn/results/4600048",
                False,
            ),
            "result_11000263": (
                "https://open.argusbot.cn/results/11000263",
                False,
            ),
            "result_3206": (
                "https://open.argusbot.cn/results/3206",
                False,
            ),
            "result_20000320": (
                "https://open.argusbot.cn/results/20000320",
                False,
            ),
            "result_20000916": (
                "https://open.argusbot.cn/results/20000916",
                False,
            ),
            "result_20001068": (
                "https://open.argusbot.cn/results/20001068",
                False,
            ),
            "result_20001382": (
                "https://open.argusbot.cn/results/20001382",
                False,
            ),
            "result_20001836": (
                "https://open.argusbot.cn/results/20001836",
                False,
            ),
            "result_20001862": (
                "https://open.argusbot.cn/results/20001862",
                False,
            ),
            "result_2884": (
                "https://open.argusbot.cn/results/2884",
                False,
            ),
        }
    )
    local_http = {
        "ok": all(bool(check.get("ok")) for check in local_checks.values()),
        "checks": local_checks,
    }
    public_http = {
        "ok": all(bool(check.get("ok")) for check in public_checks.values()),
        "checks": public_checks,
    }
    try:
        disk_available = int(host_disk.get("available_bytes") or 0)
        disk_threshold = int(host_disk.get("pressure_threshold_bytes") or 0)
    except (TypeError, ValueError):
        disk_available = 0
        disk_threshold = 0
    skip_browser_for_disk = bool(host_disk.get("pressure")) or bool(
        disk_threshold
        and disk_available
        <= disk_threshold + BROWSER_RENDER_HEADROOM_BYTES
    )
    if skip_browser_for_disk:
        cached_browser = state.get("browser_render") or {}
        cached_result = cached_browser.get("result")
        browser_render = (
            dict(cached_result)
            if isinstance(cached_result, dict)
            else {"ok": False, "pages": {}}
        )
        browser_render["skipped"] = True
        browser_render["skip_reason"] = "disk_headroom_pressure"
        browser_render["skip_observed_at"] = now_iso()
    else:
        browser_render = browser_render_check(state)
    live_age = generated_age_seconds()
    for action in (
        failure_recovery(
            state,
            "local_http",
            bool(local_http.get("ok")),
            2,
            "argus-open-site.service",
        ),
        failure_recovery(
            state,
            "public_http",
            bool(public_http.get("ok")),
            2,
            "argus-open-tunnel.service",
        ),
        failure_recovery(
            state,
            "catalog_fresh",
            live_age is not None and live_age <= 120,
            3,
            "argus-open-catalog.service",
        ),
    ):
        if action:
            actions.append(action)

    provisional_signals = provisional_candidate_signals()
    authoritative_candidate_ids = {
        str(signal.get("id") or "").strip()
        for signal in provisional_signals
        if str(signal.get("id") or "").strip()
    }
    signals = [
        signal
        for campaign_id in CAMPAIGN_IDS
        if campaign_id not in authoritative_candidate_ids
        and (signal := candidate_signal(campaign_id)) is not None
    ]
    signals.extend(provisional_signals)
    confirmed_original_signals = [
        signal for signal in signals if novelty_gate_passed(signal)
    ]
    novelty_pending_signals = [
        signal
        for signal in signals
        if signal.get("project_produced") and not novelty_gate_passed(signal)
    ]
    publication_alerts = professional_pdf_alerts(signals)
    host_alerts: list[str] = []
    if host_memory.get("pressure"):
        host_alerts.append("memory_pressure")
    if host_disk.get("pressure"):
        host_alerts.append(
            "disk_critical" if host_disk.get("critical") else "disk_pressure"
        )
    campaign_alerts = [
        campaign_id
        for campaign_id, record in campaigns.items()
        if (
            record.get("state")
            in {
                "dead",
                "missing",
                "stale",
                "idle_stalled",
                "route_mismatch",
                "procedural_loop",
                "role_error",
                "failed_mission_active_stall",
                "role_error_external_task",
                "terminal_response_stall",
            }
            or record.get("artifact_alerts")
            or record.get("mission_contract_issues")
        )
    ]
    audit_alerts = [
        shard
        for shard, record in audits.items()
        if (
            record.get("state")
            in {
                "dead",
                "missing",
                "stale",
                "idle_stalled",
                "route_mismatch",
                "procedural_loop",
                "role_error",
                "failed_mission_active_stall",
                "role_error_external_task",
                "terminal_response_stall",
            }
            or record.get("artifact_alerts")
            or record.get("mission_contract_issues")
        )
    ]
    payload = {
        "schema_version": 1,
        "generated_at": now_iso(),
        "summary": {
            "campaigns_total": len(campaigns),
            "campaigns_alive": sum(
                bool(record.get("alive") or record.get("completed"))
                for record in campaigns.values()
            ),
            "campaign_alerts": campaign_alerts,
            "audits_total": len(audits),
            "audits_alive": sum(bool(record.get("alive")) for record in audits.values()),
            "audit_alerts": audit_alerts,
            "candidate_signals": len(signals),
            "confirmed_original_results": len(confirmed_original_signals),
            "novelty_pending_results": len(novelty_pending_signals),
            "publication_alerts": [
                alert["id"] for alert in publication_alerts
            ],
            "host_alerts": host_alerts,
            "actions_taken": len(actions),
        },
        "campaigns": campaigns,
        "audits": {
            shard: {**record, "progress": audit_progress(shard)}
            for shard, record in audits.items()
        },
        "site": {
            "services": services,
            "local_http": local_http,
            "public_http": public_http,
            "browser_render": browser_render,
            "live_data_age_seconds": live_age,
            "host_memory": host_memory,
            "host_disk": host_disk,
        },
        "candidate_signals": signals,
        "publication": {
            "policy_file": "PUBLICATION_POLICY.md",
            "effective_at": PROFESSIONAL_PDF_POLICY_EFFECTIVE,
            "english_only": True,
            "preferred_document_class": "amsart",
            "journal_style_only": True,
            "raw_urls_or_hashes_in_paper_forbidden": True,
            "grandfathered_ids": sorted(PROFESSIONAL_PDF_GRANDFATHERED_IDS),
            "alerts": publication_alerts,
        },
        "actions": actions,
    }
    write_json_atomic(OUTPUT, payload)
    write_json_atomic(STATE, state)
    print(
        f"campaigns={payload['summary']['campaigns_alive']}/{len(campaigns)} "
        f"audits={payload['summary']['audits_alive']}/{len(audits)} "
        f"alerts={len(campaign_alerts) + len(audit_alerts)} "
        f"actions={len(actions)}"
    )


if __name__ == "__main__":
    main()
