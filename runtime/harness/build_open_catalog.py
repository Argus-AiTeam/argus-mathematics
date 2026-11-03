#!/usr/bin/env python3
"""Build a fail-closed catalogue containing only currently verified open problems."""

from __future__ import annotations

import csv
import json
import os
import re
from collections import Counter
from datetime import UTC, datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "inputs" / "POSSIBLE_COUNTEREXAMPLES_ALL.csv"
AUDIT_DIR = ROOT / "audits" / "status"
AUDIT_SHARD_DIR = ROOT / "audit-shards"
OUTPUT_DIR = ROOT / "outputs"
LIVE_DATA = ROOT.parent / "open-conjectures-live" / "public" / "open-data.json"
FULL_CATALOG_DATA = ROOT.parent / "open-conjectures-live" / "public" / "catalog-table.json"
FULL_CATALOG_CSV = ROOT.parent / "open-conjectures-live" / "public" / "catalog-table.csv"
LIVE_WORKBENCH_DIR = ROOT.parent / "open-conjectures-live" / "public" / "workbench-data"
FLEET_STATUS = ROOT / "outputs" / "fleet-supervisor.json"
TRANSLATIONS = ROOT / "translations" / "en.json"
AS_OF = "2026-08-27"

AUDIT_FIELDS = [
    "ID",
    "resolution_status",
    "claim_alignment",
    "evidence_level",
    "resolution_date",
    "source_urls",
    "source_location",
    "audit_notes",
    "review_status",
]

ORIGINAL_TABLE_FIELDS = [
    "分类",
    "ID",
    "题目",
    "具体描述",
    "可能有反例的依据",
    "命题对齐",
    "来源等级",
    "验证级别",
    "参考链接",
    "UnsolvedMath题目页",
    "原始来源网页",
    "题目展示编号",
    "题目页编号冲突",
]

RESOLVED = {"proved", "refuted", "superseded"}
CANONICAL_DUPLICATES = {
    "1108": "1187",
    "1308": "1187",
    "3017": "1187",
    "1496": "8",
    "3350": "8",
    "1171": "8",
    "1279": "1994",
}
DECISIVE_EVIDENCE = {
    "primary_source_fulltext",
    "multiple_primary_full_texts",
    "multiple_primary_full_text_status_statements",
    "primary_full_text_peer_reviewed",
    "formal_artifact",
    "exact_computational_certificate",
    "direct_counterexample_proof_with_exact_symbolic_corroboration",
}
WORKBENCH_ALLOWED_SUFFIXES = {
    ".c",
    ".cpp",
    ".csv",
    ".h",
    ".hpp",
    ".json",
    ".jsonl",
    ".lean",
    ".md",
    ".py",
    ".sh",
    ".toml",
    ".tsv",
    ".txt",
    ".yaml",
    ".yml",
}
WORKBENCH_EXCLUDED_DIRS = {
    ".argus_subagents",
    ".git",
    ".venv",
    "__pycache__",
    "build",
    "cache",
    "command-evidence",
    "dist",
    "logs",
    "node_modules",
    "sources",
    "toolchain",
}
WORKBENCH_IMPORTANT_NAMES = {
    "activity.jsonl",
    "aggregate.json",
    "candidate.json",
    "math_state.json",
    "objective.md",
    "proof_graph.json",
    "progress.json",
    "report.md",
    "readme.md",
    "result.json",
    "verification.json",
}
WORKBENCH_MAX_FILES = 160
WORKBENCH_MAX_PREVIEW_BYTES = 6_000_000
WORKBENCH_LOW_SIGNAL_ACTIVITY_KINDS = {"command_execution", "file", "tool_use"}
_FLEET_CAMPAIGNS_CACHE: dict[str, dict[str, object]] | None = None

# Public result pages separate mathematical correctness from novelty. A
# project-produced result is not displayed as original until a distinct
# novelty Reviewer has accepted the literature-priority audit.
# Result 2884 is rendered directly by the site because it is an editorial
# observation rather than a fleet candidate signal.
PUBLIC_RESULT_ORDER = (
    "2307015",
    "2813",
    "20001836",
    "20001068",
    "11000263",
    "20001036",
    "2338",
    "20000816",
    "1465",
    "20000278",
    "20001274",
    "20001352",
    "20001516",
    "20001602",
    "20001849",
    "20000715",
    "4600048",
    "20000916",
    "20000320",
    "20001382",
    "20001862",
    "3206",
    "1100101",
    "1100501",
    "1200029",
    "1350",
    "20001760",
)
PUBLIC_RESULT_IDS = frozenset(PUBLIC_RESULT_ORDER)
PUBLIC_PROJECT_PRODUCED_RESULT_IDS = frozenset(
    {"11000263", "20001068", "20001836", "20001036", "2338", "20000816"}
)
CONFIRMED_NOVELTY_STATUS = "independent_novelty_review_passed"


def public_result_display_class(result_id: str, lead: dict[str, object]) -> str:
    if (
        bool(lead.get("project_produced"))
        and lead.get("novelty_status") == CONFIRMED_NOVELTY_STATUS
        and lead.get("novelty_reviewer_status") == "accepted"
    ):
        return "original"
    if result_id in PUBLIC_PROJECT_PRODUCED_RESULT_IDS:
        return "novelty_pending"
    return "correction"


def read_csv(path: Path, *, encoding: str = "utf-8-sig") -> list[dict[str, str]]:
    if not path.is_file():
        return []
    with path.open(encoding=encoding, newline="") as handle:
        return list(csv.DictReader(handle))


def write_text_atomic(path: Path, content: str) -> None:
    """Publish a complete file in one rename so readers never see partial JSON."""
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    try:
        temporary.write_text(content, encoding="utf-8")
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)


def public_event_timestamp(value: object, fallback: str) -> str:
    """Keep malformed future agent timestamps from corrupting live ordering."""
    raw = str(value or "").strip()
    if not raw:
        return fallback
    try:
        parsed = datetime.fromisoformat(raw.replace("Z", "+00:00"))
        if parsed.tzinfo is None:
            parsed = parsed.replace(tzinfo=UTC)
    except ValueError:
        return fallback
    if parsed.timestamp() > datetime.now(UTC).timestamp() + 60:
        return fallback
    return raw


def write_csv(path: Path, rows: list[dict[str, str]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def load_audits(source_ids: set[str]) -> dict[str, dict[str, str]]:
    audits: dict[str, dict[str, str]] = {}
    audit_paths = [*AUDIT_DIR.glob("*.csv"), *AUDIT_SHARD_DIR.glob("*/result.csv")]
    for path in sorted(audit_paths):
        rows = read_csv(path)
        for row in rows:
            item_id = row.get("ID", "").strip()
            if not item_id or item_id not in source_ids:
                raise SystemExit(f"invalid audit ID {item_id!r} in {path}")
            if path.name == "result.csv" and path.parent.parent == AUDIT_SHARD_DIR:
                evidence = path.parent / "evidence" / item_id / "README.md"
                if not evidence.is_file():
                    continue
            missing = [field for field in AUDIT_FIELDS if field not in row]
            if missing:
                raise SystemExit(f"missing audit columns {missing!r} in {path}")
            if item_id in audits:
                raise SystemExit(f"duplicate audit ID {item_id} in {path}")
            audits[item_id] = {field: row.get(field, "").strip() for field in AUDIT_FIELDS}
            audits[item_id]["audit_file"] = str(path.relative_to(ROOT))

    # A shard keeps independently reviewed rows in its top-level result.csv,
    # but may stage a fully validated producer batch under .work while the
    # Reviewer is still checking it. Count those rows as provisional audit
    # progress without allowing them to affect the open/resolved catalogue.
    staged_paths = sorted(
        AUDIT_SHARD_DIR.glob("*/.work/**/result.csv"),
        key=lambda candidate: candidate.stat().st_mtime,
        reverse=True,
    )
    for path in staged_paths:
        validation_status = path.parent / "validate_candidate.status"
        if not validation_status.is_file() or validation_status.read_text(encoding="utf-8").strip() != "0":
            continue
        if validation_status.stat().st_mtime < path.stat().st_mtime:
            continue
        rows = read_csv(path)
        for row in rows:
            item_id = row.get("ID", "").strip()
            if not item_id or item_id not in source_ids:
                raise SystemExit(f"invalid staged audit ID {item_id!r} in {path}")
            if item_id in audits:
                continue
            missing = [field for field in AUDIT_FIELDS if field not in row]
            if missing:
                raise SystemExit(f"missing staged audit columns {missing!r} in {path}")
            shard_root = path.parents[3]
            evidence = shard_root / "evidence" / item_id / "README.md"
            if not evidence.is_file():
                continue
            audits[item_id] = {field: row.get(field, "").strip() for field in AUDIT_FIELDS}
            audits[item_id]["audit_file"] = str(path.relative_to(ROOT))
    return audits


def decision(audit: dict[str, str]) -> str:
    exact = audit.get("claim_alignment", "").startswith("exact")
    decisive = audit.get("evidence_level") in DECISIVE_EVIDENCE
    reviewed = audit.get("review_status") == "independently_verified"
    status = audit.get("resolution_status")
    if exact and decisive and reviewed and status == "open_confirmed":
        return "keep_open"
    if exact and decisive and reviewed and status in RESOLVED:
        return "remove_resolved"
    return "hold_uncertain"


def public_audit_status(row: dict[str, str]) -> tuple[str, str, str]:
    """Return stable key plus Chinese/English labels for the two added columns."""
    if not row.get("audit_file"):
        return "not_reviewed", "尚未审计", "Not yet reviewed"
    if row.get("review_status") != "independently_verified":
        return "awaiting_review", "待独立复核", "Awaiting independent review"
    if row.get("ID") in CANONICAL_DUPLICATES:
        return "duplicate", "重复条目", "Duplicate entry"
    if row.get("catalog_decision") == "keep_open":
        return "confirmed_open", "确认仍开放", "Confirmed open"
    if row.get("catalog_decision") == "remove_resolved":
        labels = {
            "proved": ("已证明", "Proved"),
            "refuted": ("已反驳", "Refuted"),
            "resolved": ("已解决", "Resolved"),
            "superseded": ("已失效/被取代", "Superseded"),
        }
        zh, en = labels.get(row.get("resolution_status", ""), ("已解决", "Resolved"))
        return "resolved", zh, en
    if row.get("resolution_status") == "partially_resolved":
        return "partially_resolved", "部分解决", "Partially resolved"

    alignment = row.get("claim_alignment", "").casefold()
    mismatch_tokens = (
        "variant",
        "mismatch",
        "ambiguous",
        "inverted",
        "underspecified",
        "truncated",
        "malformed",
        "framework_dependent",
        "non_truth_apt",
        "open_ended",
    )
    if any(token in alignment for token in mismatch_tokens):
        return "scope_mismatch", "变体/版本不一致", "Variant or version mismatch"
    return "insufficient_evidence", "证据不足", "Insufficient evidence"


def public_audit_reason(
    row: dict[str, str],
    status_key: str,
) -> tuple[str, str]:
    detail = row.get("audit_notes", "").strip()
    prefixes = {
        "not_reviewed": (
            "尚未开始完整的当前状态审计，因此不会默认标为仍开放或已解决。",
            "A complete current-status audit has not started, so the entry is not presumed open or resolved.",
        ),
        "awaiting_review": (
            "已有初步审计材料，但独立 Reviewer 尚未完成复核，暂不定案。",
            "Provisional audit evidence exists, but an independent Reviewer has not completed verification.",
        ),
        "confirmed_open": (
            "精确命题、可靠全文来源与截止日期状态均已核对，并通过独立复核。",
            "The exact claim, reliable full-text sources, and cutoff status were checked and independently reviewed.",
        ),
        "resolved": (
            "已有与原命题精确对齐的决定性证明、反例或失效记录，并通过独立复核。",
            "A decisive proof, counterexample, or supersession record exactly matches the claim and passed independent review.",
        ),
        "duplicate": (
            "该编号与另一条记录对应同一数学问题；保留原始行，但不重复计入开放问题总数。",
            "This ID duplicates the same mathematical problem under another record; the source row is retained but not double-counted.",
        ),
        "partially_resolved": (
            "原条目包含多个分支、维数或参数范围；现有结果只解决其中一部分，其余部分仍未定。",
            "The row bundles multiple branches, dimensions, or parameter ranges; existing work settles only part of it.",
        ),
        "scope_mismatch": (
            "现有结果处理的是相邻变体、不同量词、不同对象或不同版本，逻辑上不能直接回答原表中的精确命题。",
            "The available result concerns a nearby variant, different quantifiers, objects, or version and does not decide the exact row.",
        ),
        "insufficient_evidence": (
            "已找到相关线索，但缺少能直接确定当前数学状态的可靠全文、精确命题对齐或可复核证书。",
            "Related evidence was found, but reliable full text, exact claim alignment, or a checkable certificate is still missing.",
        ),
    }
    zh, en = prefixes[status_key]
    if detail and detail != "Awaiting current-status review.":
        zh = f"{zh} 审计原注：{detail}"
        en = f"{en} Audit note: {detail}"
    return zh, en


def compact_title(value: str) -> str:
    return re.sub(r"（.*?ID\s*\d+.*?）", "", value).strip()


def public_mission_title(value: object) -> str:
    """Hide daemon bootstrap instructions from the public live surface."""
    title = str(value or "").strip()
    if title.startswith("This is daemon bootstrap context."):
        return "规划下一条反例路线 / Plan next counterexample route"
    return title


def fleet_campaign_record(campaign_id: str) -> dict[str, object]:
    global _FLEET_CAMPAIGNS_CACHE
    if _FLEET_CAMPAIGNS_CACHE is None:
        try:
            payload = json.loads(FLEET_STATUS.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            payload = {}
        raw = payload.get("campaigns", {}) if isinstance(payload, dict) else {}
        _FLEET_CAMPAIGNS_CACHE = (
            {
                str(key): value
                for key, value in raw.items()
                if isinstance(value, dict)
            }
            if isinstance(raw, dict)
            else {}
        )
    return _FLEET_CAMPAIGNS_CACHE.get(campaign_id, {})


def load_argus_runtime(campaign_id: str) -> dict[str, object]:
    fleet_record = fleet_campaign_record(campaign_id)
    home_prefix = f".argus-campaign-{campaign_id}"
    campaign_homes = [
        path
        for path in ROOT.parent.iterdir()
        if path.is_dir()
        and (path.name == home_prefix or path.name.startswith(f"{home_prefix}-"))
    ]
    project_roots = [path / "projects" for path in campaign_homes]
    candidates = sorted(
        (
            path
            for project_root in project_roots
            if project_root.is_dir()
            for path in project_root.glob("*")
            if (path / "daemon.status.json").is_file()
        ),
        key=lambda path: (path / "daemon.status.json").stat().st_mtime,
        reverse=True,
    )
    if not candidates:
        return {
            "tracks": [],
            "activity": [],
            "runtime": {
                "state": fleet_record.get("state", ""),
                "artifact_alerts": fleet_record.get("artifact_alerts", []),
            },
        }
    life_dir = candidates[0]
    status = json.loads((life_dir / "daemon.status.json").read_text(encoding="utf-8"))
    mission_path = life_dir / "mission-view.json"
    mission = json.loads(mission_path.read_text(encoding="utf-8")) if mission_path.is_file() else {}
    mission_record = mission.get("mission", {})
    if isinstance(mission_record, dict):
        mission_record = dict(mission_record)
        mission_record["title"] = public_mission_title(mission_record.get("title", ""))
    else:
        mission_record = {}
    role_work = mission.get("role_work", [])
    tracks: list[dict[str, object]] = []
    for role in mission.get("roles", []):
        role_name = str(role.get("role", "worker"))
        latest = next((item for item in reversed(role_work) if item.get("role") == role_name), {})
        updated = float(role.get("updated_at") or latest.get("ts") or 0)
        status_name = str(role.get("status", "waiting"))
        progress = 100 if status_name == "done" else 55 if status_name == "active" else 0
        tracks.append(
            {
                "role": role_name.title(),
                "agent": f"Argus-{campaign_id}",
                "track": role.get("label") or latest.get("title") or role_name.title(),
                "status": "running" if status_name == "active" else status_name,
                "progress": progress,
                "current_activity": latest.get("detail") or latest.get("title") or role.get("label", ""),
                "updated_at": datetime.fromtimestamp(updated, UTC).isoformat() if updated else "",
                "artifacts": [],
                "path": f"argus-runtime/{campaign_id}/{role_name}",
            }
        )
    activity = [
        {
            "ts": datetime.fromtimestamp(float(item.get("ts", 0)), UTC).isoformat() if item.get("ts") else "",
            "role": str(item.get("role", "Argus")).title(),
            "agent": f"Argus-{campaign_id}",
            "kind": item.get("kind", "activity"),
            "action": item.get("detail") or item.get("title") or "Argus activity",
            "status": item.get("status", ""),
            "artifact": public_mission_title(item.get("mission_title", "")),
        }
        for item in role_work[-120:]
    ]
    return {
        "tracks": tracks,
        "activity": activity,
        "runtime": {
            "pid": status.get("pid"),
            "mission_width": status.get("mission_width"),
            "life_dir": str(life_dir),
            "active_role": mission.get("active_role", ""),
            "mission": mission_record,
            "stage": mission.get("stage", {}),
            "state": fleet_record.get("state", ""),
            "artifact_alerts": fleet_record.get("artifact_alerts", []),
        },
    }


def load_proof_campaigns() -> list[dict[str, object]]:
    translations = json.loads(TRANSLATIONS.read_text(encoding="utf-8")) if TRANSLATIONS.is_file() else {}
    campaign_translations = translations.get("campaigns", {})
    role_by_directory = {
        "construction": "Planner",
        "sat-search": "Engineer",
        "verification": "Reviewer",
        "planner": "Planner",
        "prime-search": "Engineer",
        "magic-search": "Engineer",
        "reviewer": "Reviewer",
    }
    campaigns: list[dict[str, object]] = []
    for path in sorted((ROOT / "proof-campaigns").glob("*.json")):
        campaign = json.loads(path.read_text(encoding="utf-8"))
        campaign_id = str(campaign.get("id", "")).strip()
        english = campaign_translations.get(campaign_id, {})
        campaign["title_en"] = english.get("title", campaign.get("title", ""))
        campaign["objective_en"] = english.get("objective", campaign.get("objective", ""))
        campaign["why_selected_en"] = english.get("why_selected", campaign.get("why_selected", ""))
        campaign["known_boundary_en"] = english.get("known_boundary", campaign.get("known_boundary", ""))
        tracks: list[dict[str, object]] = []
        for progress_path in sorted((ROOT / "proofs" / campaign_id).glob("*/progress.json")):
            progress = json.loads(progress_path.read_text(encoding="utf-8"))
            progress["path"] = str(progress_path.parent.relative_to(ROOT))
            progress.setdefault("role", role_by_directory.get(progress_path.parent.name, "Worker"))
            progress.setdefault("agent", "Argus")
            tracks.append(progress)
        argus = load_argus_runtime(campaign_id)
        tracks.extend(argus["tracks"])
        campaign["tracks"] = tracks
        campaign["argus_runtime"] = argus["runtime"]
        campaign["argus_activity"] = argus["activity"]
        campaign["progress"] = round(
            sum(float(track.get("progress", 0)) for track in tracks) / len(tracks)
        ) if tracks else 0
        campaign["updated_at"] = max(
            (str(track.get("updated_at", "")) for track in tracks),
            default=str(campaign.get("started_at", "")),
        )
        campaigns.append(campaign)
    return campaigns


def public_text_file(path: Path) -> dict[str, object] | None:
    if not path.is_file() or path.name.startswith(".") or path.stat().st_size > 500_000:
        return None
    try:
        raw = path.read_bytes()
        content = raw.decode("utf-8")
    except (OSError, UnicodeDecodeError):
        return None
    limit = 120_000
    truncated = len(content) > limit
    if truncated:
        content = content[:limit] + "\n\n[public preview truncated]\n"
    return {
        "path": str(path.relative_to(ROOT)),
        "name": path.name,
        "size": len(raw),
        "updated_at": datetime.fromtimestamp(path.stat().st_mtime, UTC).isoformat(),
        "content": content,
        "truncated": truncated,
    }


def iter_workbench_files(root: Path):
    if not root.is_dir():
        return
    for directory, dirnames, filenames in os.walk(root):
        dirnames[:] = [
            name
            for name in dirnames
            if not name.startswith(".") and name not in WORKBENCH_EXCLUDED_DIRS
        ]
        parent = Path(directory)
        for filename in filenames:
            path = parent / filename
            if filename.startswith(".") or path.suffix.lower() not in WORKBENCH_ALLOWED_SUFFIXES:
                continue
            yield path


def iter_workbench_activity_files(root: Path):
    """Find activity logs without traversing private media or toolchains."""
    if not root.is_dir():
        return
    for directory, dirnames, filenames in os.walk(root):
        dirnames[:] = [
            name
            for name in dirnames
            if not name.startswith(".") and name not in WORKBENCH_EXCLUDED_DIRS
        ]
        if "activity.jsonl" in filenames:
            yield Path(directory) / "activity.jsonl"


def workbench_file_priority(path: Path) -> tuple[int, float, int, str]:
    name = path.name.casefold()
    score = 0
    if (
        name == "report.md"
        and "low-order-pzktupel-actual-prime" in path.parts
    ):
        score += 240
    if name in WORKBENCH_IMPORTANT_NAMES:
        score += 100
    if any(token in name for token in ("result", "verif", "candidate", "proof", "state")):
        score += 40
    if path.suffix.lower() in {".md", ".py", ".lean", ".cpp"}:
        score += 20
    try:
        updated_at = path.stat().st_mtime
    except OSError:
        updated_at = 0.0
    return (-score, -updated_at, len(path.parts), str(path))


def write_workbench_data(campaigns: list[dict[str, object]]) -> None:
    LIVE_WORKBENCH_DIR.mkdir(parents=True, exist_ok=True)
    for campaign in campaigns:
        campaign_id = str(campaign.get("id", "")).strip()
        candidates = [
            ROOT / "proof-campaigns" / f"{campaign_id}.json",
            ROOT / "status-evidence" / campaign_id / "README.md",
        ]
        proof_root = ROOT / "proofs" / campaign_id
        if proof_root.is_dir():
            candidates.extend(iter_workbench_files(proof_root))
        campaign_root = ROOT / "campaigns" / campaign_id
        if campaign_root.is_dir():
            candidates.extend(iter_workbench_files(campaign_root))
        ranked_candidates = sorted(set(candidates), key=workbench_file_priority)
        files: list[dict[str, object]] = []
        preview_bytes = 0
        for path in ranked_candidates:
            if len(files) >= WORKBENCH_MAX_FILES:
                break
            record = public_text_file(path)
            if record is None:
                continue
            record_bytes = len(str(record["content"]).encode("utf-8"))
            if preview_bytes + record_bytes > WORKBENCH_MAX_PREVIEW_BYTES:
                continue
            files.append(record)
            preview_bytes += record_bytes
        tracks = list(campaign.get("tracks", []))
        activity: list[dict[str, object]] = []
        activity.extend(
            {**event, "_source_priority": 1}
            for event in campaign.get("argus_activity", [])
        )
        for track in tracks:
            for milestone in track.get("milestones", []):
                activity.append(
                    {
                        "_source_priority": 1,
                        "ts": milestone.get("recorded_at") or track.get("updated_at", ""),
                        "role": track.get("role", "Worker"),
                        "agent": track.get("agent", "Argus"),
                        "kind": "milestone",
                        "action": milestone.get("activity", "Milestone recorded."),
                        "status": track.get("status", ""),
                        "artifact": ", ".join(milestone.get("evidence_files", [])),
                    }
                )
        activity_paths = {
            activity_path
            for activity_root in (proof_root, campaign_root)
            for activity_path in iter_workbench_activity_files(activity_root)
        }
        for activity_path in sorted(activity_paths):
            fallback_ts = datetime.fromtimestamp(activity_path.stat().st_mtime, UTC).isoformat()
            track = next(
                (
                    item
                    for item in tracks
                    if str(activity_path.parent.relative_to(ROOT)).startswith(str(item.get("path", "")))
                ),
                {},
            )
            for line in activity_path.read_text(encoding="utf-8", errors="replace").splitlines()[-200:]:
                try:
                    event = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if not isinstance(event, dict):
                    continue
                activity.append(
                    {
                        "_source_priority": 0,
                        "ts": public_event_timestamp(event.get("ts"), fallback_ts),
                        "role": event.get("role") or track.get("role", "Worker"),
                        "agent": event.get("agent") or track.get("agent", "Argus"),
                        "kind": event.get("kind", "activity"),
                        "action": event.get("action", "Activity recorded."),
                        "status": event.get("status") or track.get("status", ""),
                        "artifact": event.get("artifact", ""),
                    }
                )
        for file_record in files:
            track = next(
                (
                    item
                    for item in tracks
                    if str(file_record["path"]).startswith(str(item.get("path", "")))
                ),
                {},
            )
            activity.append(
                {
                    "_source_priority": 2,
                    "ts": file_record["updated_at"],
                    "role": track.get("role", "Argus"),
                    "agent": track.get("agent", "Argus"),
                    "kind": "file",
                    "action": f"Updated {file_record['path']}",
                    "status": track.get("status", ""),
                    "artifact": file_record["path"],
                }
            )
        activity.sort(key=lambda event: str(event.get("ts", "")), reverse=True)
        activity.sort(key=lambda event: int(event.get("_source_priority", 1)))
        activity.sort(
            key=lambda event: str(event.get("kind", ""))
            in WORKBENCH_LOW_SIGNAL_ACTIVITY_KINDS
        )
        public_activity = []
        for event in activity[:120]:
            public_event = dict(event)
            public_event.pop("_source_priority", None)
            public_activity.append(public_event)
        workbench = {
            "schema_version": 1,
            "generated_at": datetime.now(UTC).isoformat(),
            "read_only": True,
            "campaign": campaign,
            "activity": public_activity,
            "files": files,
            "files_discovered": len(ranked_candidates),
            "files_truncated": len(files) < len(ranked_candidates),
        }
        destination = LIVE_WORKBENCH_DIR / f"{campaign_id}.json"
        write_text_atomic(
            destination,
            json.dumps(workbench, ensure_ascii=False, indent=2) + "\n",
        )


def main() -> None:
    source_rows = read_csv(SOURCE)
    source_ids = {row["ID"].strip() for row in source_rows}
    audits = load_audits(source_ids)
    fields = [*source_rows[0].keys(), *AUDIT_FIELDS[1:], "audit_file", "catalog_decision"]
    all_rows: list[dict[str, str]] = []
    for source in source_rows:
        item_id = source["ID"].strip()
        audit = audits.get(
            item_id,
            {
                "ID": item_id,
                "resolution_status": "unreviewed",
                "claim_alignment": source.get("命题对齐", "") or "unknown",
                "evidence_level": "none",
                "resolution_date": "",
                "source_urls": "",
                "source_location": "",
                "audit_notes": "Awaiting current-status review.",
                "review_status": "provisional",
                "audit_file": "",
            },
        )
        merged = {**source, **{key: value for key, value in audit.items() if key != "ID"}}
        merged["catalog_decision"] = decision(audit)
        all_rows.append(merged)

    open_rows = [
        row
        for row in all_rows
        if row["catalog_decision"] == "keep_open"
        and row["ID"] not in CANONICAL_DUPLICATES
    ]
    removed_rows = [row for row in all_rows if row["catalog_decision"] == "remove_resolved"]
    uncertain_rows = [
        row
        for row in all_rows
        if row["catalog_decision"] == "hold_uncertain"
        or (
            row["catalog_decision"] == "keep_open"
            and row["ID"] in CANONICAL_DUPLICATES
        )
    ]

    write_csv(OUTPUT_DIR / f"status_audit_{AS_OF}.csv", all_rows, fields)
    write_csv(OUTPUT_DIR / f"open_problems_{AS_OF}.csv", open_rows, fields)
    write_csv(OUTPUT_DIR / f"resolved_removed_{AS_OF}.csv", removed_rows, fields)
    write_csv(OUTPUT_DIR / f"status_uncertain_{AS_OF}.csv", uncertain_rows, fields)

    status_counts = Counter(row["resolution_status"] for row in all_rows)
    independently_verified_total = sum(
        audit.get("review_status") == "independently_verified"
        for audit in audits.values()
    )
    catalog_rows: list[dict[str, object]] = []
    catalog_csv_rows: list[dict[str, str]] = []
    public_status_counts: Counter[str] = Counter()
    for row in all_rows:
        status_key, status_zh, status_en = public_audit_status(row)
        reason_zh, reason_en = public_audit_reason(row, status_key)
        canonical_id = CANONICAL_DUPLICATES.get(row["ID"], "")
        if canonical_id:
            reason_zh = f"{reason_zh} 规范条目：#{canonical_id}。"
            reason_en = f"{reason_en} Canonical entry: #{canonical_id}."
        public_status_counts[status_key] += 1
        catalog_rows.append(
            {
                "id": row["ID"],
                "audit_status_key": status_key,
                "audit_status": status_zh,
                "audit_status_en": status_en,
                "audit_reason": reason_zh,
                "audit_reason_en": reason_en,
                "review_status": row.get("review_status", ""),
                "resolution_status": row.get("resolution_status", ""),
                "claim_alignment": row.get("claim_alignment", ""),
                "evidence_level": row.get("evidence_level", ""),
                "audit_file": row.get("audit_file", ""),
                "original": {
                    field: row.get(field, "")
                    for field in ORIGINAL_TABLE_FIELDS
                },
            }
        )
        catalog_csv_rows.append(
            {
                **{
                    field: row.get(field, "")
                    for field in ORIGINAL_TABLE_FIELDS
                },
                "审计状态": status_zh,
                "审计说明": reason_zh,
            }
        )
    full_catalog_payload = {
        "schema_version": 1,
        "as_of": AS_OF,
        "generated_at": datetime.now(UTC).isoformat(),
        "source_total": len(source_rows),
        "original_columns": ORIGINAL_TABLE_FIELDS,
        "added_columns": ["审计状态", "审计说明"],
        "status_counts": dict(sorted(public_status_counts.items())),
        "rows": catalog_rows,
    }
    write_text_atomic(
        FULL_CATALOG_DATA,
        json.dumps(full_catalog_payload, ensure_ascii=False, indent=2) + "\n",
    )
    write_csv(
        FULL_CATALOG_CSV,
        catalog_csv_rows,
        [*ORIGINAL_TABLE_FIELDS, "审计状态", "审计说明"],
    )
    translations = json.loads(TRANSLATIONS.read_text(encoding="utf-8")) if TRANSLATIONS.is_file() else {}
    item_translations = translations.get("open_items", {})
    category_en = {
        "具名专家负面意见": "Named expert negative assessment",
        "广泛认为为假": "Widely believed false",
        "强负面证据": "Strong negative evidence",
        "疑似已反驳，待全文确认": "Possible refutation under full-text review",
    }
    campaigns = load_proof_campaigns()
    fleet_snapshot: dict[str, object] = {}
    if FLEET_STATUS.is_file():
        try:
            fleet = json.loads(FLEET_STATUS.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            fleet = {}
        summary = fleet.get("summary") if isinstance(fleet, dict) else {}
        site = fleet.get("site") if isinstance(fleet, dict) else {}
        if isinstance(summary, dict) and isinstance(site, dict):
            public_candidate_by_id = {
                str(lead.get("id", "")): lead
                for lead in fleet.get("candidate_signals", [])
                if isinstance(lead, dict)
                and str(lead.get("id", "")) in PUBLIC_RESULT_IDS
            }
            public_candidate_leads = []
            for result_id in PUBLIC_RESULT_ORDER:
                lead = public_candidate_by_id.get(result_id)
                if not lead:
                    continue
                public_candidate_leads.append(
                    {
                        **lead,
                        "display_class": public_result_display_class(result_id, lead),
                        "originality_review_status": (
                            "confirmed"
                            if public_result_display_class(result_id, lead) == "original"
                            else "pending"
                            if public_result_display_class(result_id, lead) == "novelty_pending"
                            else "not_claimed"
                        ),
                    }
                )
            fleet_snapshot = {
                "generated_at": fleet.get("generated_at", ""),
                "campaigns_total": summary.get("campaigns_total", 0),
                "campaigns_alive": summary.get("campaigns_alive", 0),
                "campaign_alerts": summary.get("campaign_alerts", []),
                "audits_total": summary.get("audits_total", 0),
                "audits_alive": summary.get("audits_alive", 0),
                "audit_alerts": summary.get("audit_alerts", []),
                "candidate_signals": len(public_candidate_leads),
                "confirmed_original_results": sum(
                    lead.get("display_class") == "original"
                    for lead in public_candidate_leads
                ),
                "novelty_pending_results": sum(
                    lead.get("display_class") == "novelty_pending"
                    for lead in public_candidate_leads
                ),
                "candidate_leads": public_candidate_leads,
                "publication_alerts": summary.get("publication_alerts", []),
                "host_alerts": summary.get("host_alerts", []),
                "host_memory": site.get("host_memory", {}),
                "host_disk": site.get("host_disk", {}),
                "site_healthy": all(bool(value) for value in site.get("services", {}).values())
                and bool(site.get("local_http", {}).get("ok"))
                and bool(site.get("public_http", {}).get("ok"))
                and bool(site.get("browser_render", {}).get("ok")),
                "live_data_age_seconds": site.get("live_data_age_seconds"),
            }
    payload = {
        "schema_version": 1,
        "as_of": AS_OF,
        "generated_at": datetime.now(UTC).isoformat(),
        "source_total": len(source_rows),
        "reviewed_total": len(audits),
        "independently_verified_total": independently_verified_total,
        "provisional_audit_total": len(audits) - independently_verified_total,
        "confirmed_open_total": len(open_rows),
        "removed_resolved_total": len(removed_rows),
        "uncertain_total": len(uncertain_rows),
        "status_counts": dict(sorted(status_counts.items())),
        "method": "Only exact claims backed by decisive evidence and independent review are shown as open.",
        "fleet_supervisor": fleet_snapshot,
        "campaigns": campaigns,
        "items": [
            {
                "id": row["ID"],
                "title": compact_title(row["题目"]),
                "title_en": item_translations.get(row["ID"], {}).get("title", compact_title(row["题目"])),
                "description": row["具体描述"],
                "description_en": item_translations.get(row["ID"], {}).get("description", row["具体描述"]),
                "category": row.get("分类") or row.get("\ufeff分类", ""),
                "category_en": category_en.get(row.get("分类") or row.get("\ufeff分类", ""), "Open problem"),
                "source_grade": row["来源等级"],
                "status": row["resolution_status"],
                "source_urls": row["source_urls"],
                "source_location": row["source_location"],
                "audit_notes": row["audit_notes"],
            }
            for row in open_rows
        ],
    }
    write_text_atomic(
        LIVE_DATA,
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
    )
    write_workbench_data(campaigns)
    print(
        f"source={len(source_rows)} reviewed={len(audits)} open={len(open_rows)} "
        f"removed={len(removed_rows)} uncertain={len(uncertain_rows)}"
    )


if __name__ == "__main__":
    main()
