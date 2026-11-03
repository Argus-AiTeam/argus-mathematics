#!/usr/bin/env python3
"""Launch two independent continuous Argus daemons for audit shards."""

from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ARGUS_ROOT = ROOT.parent / "argus-live-update"
ARGUS = ARGUS_ROOT / ".venv" / "bin" / "argus"
ARGUS_BIN = ARGUS.parent
RUNNER = Path("/home/argustest/.local/bin/copilot")
RUNNER_PATH = "/home/argustest/.local/bin:/home/argustest/bin"
SPECIAL_PROMPTS = ROOT.parent / ".argus-counterexamples" / "special_prompts"
DEFAULT_MODEL = "gpt-6-astra"


def main() -> None:
    sys.path.insert(0, str(ARGUS_ROOT))
    from argus_skill.skills.vertical_select import persist_vertical

    selected = tuple(sys.argv[1:]) or ("01", "02")
    unknown = set(selected) - {"01", "02"}
    if unknown:
        raise SystemExit(f"unknown audit shards: {sorted(unknown)}")
    workdir_suffix = os.environ.get("ARGUS_AUDIT_WORKDIR_SUFFIX", "")
    home_suffix = os.environ.get("ARGUS_AUDIT_HOME_SUFFIX", workdir_suffix)
    failed = False
    for shard in selected:
        workdir = ROOT / "audit-shards" / f"{shard}{workdir_suffix}"
        if not workdir.is_dir():
            raise SystemExit(f"missing audit workdir: {workdir}")
        persist_vertical(
            workdir,
            "math",
            workflow_mode="staged",
            research_target_level="exploratory",
        )
        env = os.environ.copy()
        for name in (
            "CONDA_PREFIX",
            "CONDA_DEFAULT_ENV",
            "CONDA_PROMPT_MODIFIER",
            "CONDA_SHLVL",
        ):
            env.pop(name, None)
        env.update({
            # Match every role subprocess to the Argus build that launched
            # the daemon, including bare `python -m argus_skill ...` checks.
            "PATH": f"{ARGUS_BIN}:{RUNNER_PATH}:{env.get('PATH', '')}",
            "VIRTUAL_ENV": str(ARGUS_BIN.parent),
            "ARGUS_SKILL_HOME": str(ROOT.parent / f".argus-audit-shard-{shard}{home_suffix}"),
            "ARGUS_SKILL_SPECIAL_PROMPTS_DIR": str(SPECIAL_PROMPTS),
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
            "ARGUS_SKILL_BOUNDED_DAG_MODEL": DEFAULT_MODEL,
            "ARGUS_SKILL_RUNNER_BIN": str(RUNNER),
            "ARGUS_SKILL_MANAGER_REASONING_EFFORT": "max",
            "ARGUS_SKILL_PLANNER_REASONING_EFFORT": "max",
            "ARGUS_SKILL_ENGINEER_REASONING_EFFORT": "max",
            "ARGUS_SKILL_ENGINEER_INITIAL_REASONING_EFFORT": "max",
            "ARGUS_SKILL_REVIEWER_REASONING_EFFORT": "max",
            "ARGUS_SKILL_SELF_REASONING_EFFORT": "max",
            "ARGUS_SKILL_CODEX_DAILY_CALL_CAP": "10000",
            "ARGUS_SKILL_JACOBIAN_MCP_BIN": str(ROOT.parent / "references" / "jacobian" / ".venv" / "bin" / "jacobian-mcp"),
        })
        command = [str(ARGUS), "--daemon"]
        if os.environ.get("ARGUS_AUDIT_RESUME_CONTINUOUS") == "1":
            command.append("--resume-continuous")
        else:
            command.extend(["--continuous", "--objective-file", "LAUNCH.md"])
        command.extend(["--bounded", "--mission-width", "4"])
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
        if result.returncode == 3 and env.get("ARGUS_AUDIT_RESUME_CONTINUOUS") == "1":
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
        print(f"{shard}\texit={result.returncode}\t{output.strip()}")
        failed = failed or result.returncode != 0
    if failed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
