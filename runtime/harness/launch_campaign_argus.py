#!/usr/bin/env python3
"""Launch one autonomous Argus daemon for each campaign workdir."""

from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ARGUS = ROOT.parent / "argus-live-update" / ".venv" / "bin" / "argus"
ARGUS_BIN = ARGUS.parent
RUNNER = Path("/home/argustest/.local/bin/copilot")
RUNNER_PATH = "/home/argustest/.local/bin:/home/argustest/bin"
SPECIAL_PROMPTS = ROOT.parent / ".argus-counterexamples" / "special_prompts"
DEFAULT_MODEL = "gpt-6-astra"
IDS = (
    "1417", "1518", "1243", "1187", "8200002", "1900020", "2457", "20001578",
    "11000263", "20000786", "1994", "1285", "20000582", "2305027", "8", "1380", "2800203",
    "2338", "2662", "2669", "2862", "2248", "1921", "2775", "2813", "2884",
    "1465", "2307015", "6800022", "1413", "20001904",
)

MODEL_ENV = {
    "ARGUS_SKILL_VERTICAL": "math",
    "ARGUS_SKILL_RUNNER_BACKEND": "copilot",
    "ARGUS_SKILL_MANAGER_FAST_ROUTE": "1",
    "ARGUS_SKILL_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_FRONTDOOR_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_MANAGER_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_MANAGER_REPLY_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_PLAN_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_ENGINEER_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_REVIEWER_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_CURATOR_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_SUPERVISOR_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_BOUNDED_DAG_MODEL": DEFAULT_MODEL,
    "ARGUS_SKILL_RUNNER_BIN": str(RUNNER),
    "ARGUS_SKILL_MANAGER_REASONING_EFFORT": "max",
    "ARGUS_SKILL_PLANNER_REASONING_EFFORT": "max",
    "ARGUS_SKILL_ENGINEER_REASONING_EFFORT": "max",
    "ARGUS_SKILL_ENGINEER_INITIAL_REASONING_EFFORT": "max",
    "ARGUS_SKILL_REVIEWER_REASONING_EFFORT": "max",
    "ARGUS_SKILL_CURATOR_REASONING_EFFORT": "max",
    "ARGUS_SKILL_SUPERVISOR_REASONING_EFFORT": "max",
    "ARGUS_SKILL_SELF_REASONING_EFFORT": "max",
    "ARGUS_SKILL_CODEX_DAILY_CALL_CAP": "10000",
    "ARGUS_SKILL_JACOBIAN_MCP_BIN": str(ROOT.parent / "references" / "jacobian" / ".venv" / "bin" / "jacobian-mcp"),
}


def main() -> None:
    sys.path.insert(0, str(ROOT.parent / "argus-live-update"))
    from argus_skill.core.research_contract import resolve_research_target_level
    from argus_skill.skills.vertical_select import persist_vertical

    selected = tuple(sys.argv[1:]) or IDS
    unknown = {
        campaign_id
        for campaign_id in selected
        if not (ROOT / "campaigns" / campaign_id / "OBJECTIVE.md").is_file()
    }
    if unknown:
        raise SystemExit(f"unknown campaign IDs: {sorted(unknown)}")
    failed = False
    for campaign_id in selected:
        workdir = ROOT / "campaigns" / campaign_id
        # Preserve an operator/supervisor-raised completion bar across daemon
        # restarts.  Rewriting every campaign to ``exploratory`` made an exact
        # counterexample objective terminable by a finite negative report.
        target_level = resolve_research_target_level(workdir) or "exploratory"
        persist_vertical(
            workdir,
            "math",
            workflow_mode="staged",
            research_target_level=target_level,
        )
        env = os.environ.copy()
        env.update(MODEL_ENV)
        for name in (
            "CONDA_PREFIX",
            "CONDA_DEFAULT_ENV",
            "CONDA_PROMPT_MODIFIER",
            "CONDA_SHLVL",
        ):
            env.pop(name, None)
        env["VIRTUAL_ENV"] = str(ARGUS_BIN.parent)
        # Keep role-spawned `python -m argus_skill ...` checks on the exact
        # Argus build that owns this daemon.  Without the venv first, the host
        # may resolve an unrelated development checkout with incompatible
        # proof-ledger validation rules.
        env["PATH"] = f"{ARGUS_BIN}:{RUNNER_PATH}:{env.get('PATH', '')}"
        suffix = os.environ.get("ARGUS_CAMPAIGN_HOME_SUFFIX", "")
        env["ARGUS_SKILL_HOME"] = str(ROOT.parent / f".argus-campaign-{campaign_id}{suffix}")
        env["ARGUS_SKILL_SPECIAL_PROMPTS_DIR"] = str(SPECIAL_PROMPTS)
        command = [str(ARGUS), "--daemon"]
        if os.environ.get("ARGUS_CAMPAIGN_RESUME_CONTINUOUS") == "1":
            command.append("--resume-continuous")
        elif os.environ.get("ARGUS_CAMPAIGN_CONTINUOUS", "1") != "0":
            command.extend(["--continuous", "--objective-file", "LAUNCH.md"])
        command.extend(
            [
                "--bounded",
                "--mission-width",
                os.environ.get("ARGUS_CAMPAIGN_MISSION_WIDTH", "1"),
            ]
        )
        result = subprocess.run(
            command,
            cwd=workdir,
            env=env,
            text=True,
            capture_output=True,
            timeout=60,
            check=False,
        )
        output = result.stdout + result.stderr
        if result.returncode == 3 and env.get("ARGUS_CAMPAIGN_RESUME_CONTINUOUS") == "1":
            match = re.search(
                r"session workdir changed during daemon startup; retry with (.+)\.\s*$",
                output,
                re.MULTILINE,
            )
            if match:
                retry_workdir = Path(match.group(1)).resolve()
                projects_dir = (Path(env["ARGUS_SKILL_HOME"]) / "projects").resolve()
                if projects_dir in retry_workdir.parents:
                    result = subprocess.run(
                        command,
                        cwd=retry_workdir,
                        env=env,
                        text=True,
                        capture_output=True,
                        timeout=60,
                        check=False,
                    )
                    output = result.stdout + result.stderr
        message = output.strip().replace("\n", " | ")
        print(f"{campaign_id}\texit={result.returncode}\t{message}")
        failed = failed or result.returncode != 0
    if failed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
