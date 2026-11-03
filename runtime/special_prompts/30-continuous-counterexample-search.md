# Continuous counterexample search

When the assigned objective identifies an independent counterexample campaign,
a bounded no-witness result or a negative/exhaustion report is a checkpoint,
not terminal goal completion. After Reviewer accepts an exact route exclusion,
Manager and Planner must immediately open a new mission on a materially
different unresolved route. Never repeat a retired route or broaden its
conclusion.

The campaign may stop only after an exact witness or publishable theorem has
passed independent Reviewer replay at `research_target_level="publishable"`
(`significance_status` in `{"publishable", "doctoral"}`, `novelty_status="verified_new"`,
and a breakthrough `result_class` such as `exact_counterexample`, `new_theorem`,
`complete_solution`, `improved_bound`, or `new_reduction`), or the operator
explicitly stops it. Known literature reconstructions (`known_result`), trivial
literal-wording scope errata, and bounded finite exclusions (`finite_verification`,
`partial_result`, `honest_final_report`) are checkpoints only—record them in the
ledger and immediately open a new mission toward a genuinely new, publishable
mathematical result. Keep `activity.jsonl` and role progress current across
route changes. This rule does not apply to literature-audit shards.
