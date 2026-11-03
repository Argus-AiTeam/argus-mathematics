# Argus Counterexample Runtime & `math` Vertical Reference

This directory archives the exact **Argus runtime version**, **`math` vertical implementation**, **role skills**, **proof-ledger / proof-graph checkers**, **Jacobian MCP adapter**, **special prompts**, and **fleet supervision harness** used across the Argus Live Counterexample Lab campaigns (August–September 2026).

Full standalone runtime repository: **<https://github.com/Argus-AiTeam/argus-counterexample-runtime>**

---

## 1. Exact Versions Used

| Component | Checkout Path on Host | Branch / Commit | Purpose |
|---|---|---|---|
| **Argus Live Runtime** (`argus-skill 0.1.2`) | `/home/argustest/zimo/argus-live-update` | Branch `feature/counterexample-lab-jacobian-update` (`60a7a2b6` + `argus-live-update-working-tree.patch`) | Autonomous daemon runtime (`Manager`, `Planner`, `Engineer`, `Reviewer`), Jacobian MCP adapter, Lean 4 evidence checker, and terminal-state settlement |
| **Argus Pinned Baseline** (`argus-skill 0.1.2`) | `/home/argustest/zimo/argus-latest` | `main` @ `33da786bbc6787a2eeb63a5f492498eae87c78c7` | Pinned schema validator for `python -m argus_skill.verticals.math.math_state check` and `proof_graph_check` |
| **Jacobian Symbolic/Exact Engine** (`0.14.0`) | `/home/argustest/zimo/references/jacobian` | `7df85cac75e3a249cb69c6bae685c42b75a31390` | Typed exact mathematical operations (Farkas certificates, SMT `QF_LIA`, Smith normal form, resultants, graph domination/cuts/isomorphism) |

---

## 2. Directory Layout

```text
runtime/
  verticals/
    math/                        Active `math` vertical from argus-live-update
      __init__.py
      stages.py                  Staged workflow (scope -> solve -> review), checklists & completion gates
      math_state.py              Claim/assumption/route/judgment ledger (`MATH_STATE.json`)
      proof_graph.py             Directed proof dependency graph engine (`PROOF_GRAPH.json`)
      proof_graph_check.py       CLI verifier for proof-graph completeness and gap analysis
      citation_check.py          Primary-source citation & attribution verifier
      lean_evidence.py           Lean 4 formal-artifact compiler & axiom-audit verifier
      lean_async.py              Asynchronous Lean build runner
      context_projection.py      Role context projection for mathematical state
      objective_mode.py          Targeted vs. exploratory math objective mode resolution
      skills/                    Role-specific Markdown skill prompts
        manager/math-research-manager.md
        planner/math-research-planning.md
        engineer/math-research-execution.md
        reviewer/math-research-review.md
        scientist/math-research-adaptation.md
        scientist/math-research-distillation.md
    math_baseline_33da786/       Pinned baseline `math` vertical from argus-latest (33da786)
  proof_ledger/                  Underlying proof-ledger kernel store and models
  tools/
    jacobian.py                  Argus <-> Jacobian MCP / CLI typed operation adapter
  core/
    research_contract.py         Research target level contract (`exploratory`, `publishable`, `doctoral`)
  life/
    terminal_state.py            Terminal completion & exploratory/targeted admission gates
    supervisor/
      _mission_execution_settlement.py
  skills/
    role_library.py
    vertical_select.py           Vertical persistence (`.argus/PIPELINE_STATE.json`)
  webapi/
    counterexample_dashboard.py  Live counterexample dashboard state projection
  special_prompts/               Injected operator rules (`ARGUS_SKILL_SPECIAL_PROMPTS_DIR`)
    10-house-rules.md
    20-jacobian-adapter-path.md
    30-continuous-counterexample-search.md
    40-campaign-local-validation.md
  harness/                       Campaign launcher, fleet supervisor, and policy contracts
    launch_campaign_argus.py
    supervise_argus_fleet.py
    build_open_catalog.py
    validate_open_catalog.py
    validate_outputs.py
    COUNTEREXAMPLE_SWARM_OBJECTIVE.md
    NOVELTY_REVIEW_POLICY.md
    PUBLICATION_POLICY.md
    RESULT_CLASSIFICATION_POLICY.md
  argus-live-update-working-tree.patch
  argus-live-update-commits.txt
```

---

## 3. How Campaigns Were Configured and Launched

Each campaign directory (`campaigns/<ID>/`) was initialized with `.argus/PIPELINE_STATE.json`:

```json
{
  "current_stage": "scope",
  "math_objective_mode": "targeted",
  "research_target_level": "exploratory",
  "vertical": "math",
  "workflow_mode": "staged"
}
```

And launched via `harness/launch_campaign_argus.py` with:
- `ARGUS_SKILL_VERTICAL=math`
- `ARGUS_SKILL_RUNNER_BACKEND=copilot` (or `codex` in Batch 001)
- `ARGUS_SKILL_MODEL=gpt-6-astra` (or `gpt-5.5` / `gpt-5.6-sol` in Batch 001)
- `ARGUS_SKILL_*_REASONING_EFFORT=max` across Manager, Planner, Engineer, Reviewer, Curator, and Supervisor
- `ARGUS_SKILL_SPECIAL_PROMPTS_DIR=/home/argustest/zimo/.argus-counterexamples/special_prompts`
- `ARGUS_SKILL_JACOBIAN_MCP_BIN=/home/argustest/zimo/references/jacobian/.venv/bin/jacobian-mcp`
