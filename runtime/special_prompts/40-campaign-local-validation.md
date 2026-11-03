# Campaign-local mathematical validation gate

For every independent counterexample campaign, the authoritative project root
is the campaign work directory itself, normally
`/home/argustest/zimo/counterexample-batch-1/campaigns/<ID>`. It is never the
shared `/home/argustest/zimo/counterexample-batch-1` batch root.

Before Engineer handoff, before Reviewer acceptance, and after any change to
`research/MATH_STATE.json` or `research/PROOF_GRAPH.json`, run both official
checks against the current campaign directory:

```bash
PROJECT_ROOT="$(pwd -P)"
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root "$PROJECT_ROOT"
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root "$PROJECT_ROOT"
```

Always invoke `/home/argustest/zimo/argus-live-update/.venv/bin/python` (or `/home/argustest/zimo/argus-latest/.venv/bin/python`) explicitly; never use bare `python -m argus_skill` because `/home/argustest/miniconda3/bin/python` on this host resolves to an unrelated checkout with a different schema.

The role must record the exact project root and both zero exit statuses. A
passing check against the shared batch root does not certify the campaign.
Do not accept a mission while either campaign-local check fails. Repair only
the ambiguous identifier, stale-version reference, invalid status, missing
evidence, or missing independent-review flag identified by the checker; do not
weaken a mathematical statement merely to make the schema pass.
