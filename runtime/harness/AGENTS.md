# Project execution rules

- For every Argus Python module, math-state, proof-ledger, or proof-graph
  command, invoke `/home/argustest/zimo/argus-latest/.venv/bin/python`
  explicitly. Do not use bare `python -m argus_skill`; this host also contains
  a different development checkout whose schema is incompatible with the
  pinned public `main` used for this mission.
- Invoke Jacobian only through
  `/home/argustest/zimo/references/jacobian/.venv/bin/jacobian`.
- Do not modify `/home/argustest/zimo/argus-latest` or
  `/home/argustest/zimo/references/jacobian`.
- Before accepting or advancing any math-state artifact, run:
  `/home/argustest/zimo/argus-latest/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root /home/argustest/zimo/counterexample-batch-1`.
