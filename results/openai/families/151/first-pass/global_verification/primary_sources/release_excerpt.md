# Exact released theorem and historical acceptance

OpenAI revision: `fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`.
Primary source:
https://github.com/openai/math/blob/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/OAI/Dynamics/EntropyCounterexample/Counterexample.lean

The declaration `OAI.Problem340.exists_C1_entropy_counterexample` asserts
existence of `q > 0`, a self-map of `CounterexampleManifold q`, and
`hf : IsC1SelfMap q f`, with all the following conjuncts:
`coverEntropy f Set.univ = 0`, a nonzero second-real-singular-homology
eigenvector of eigenvalue `2`, `0 < log 2`, `log 2 <= log` of the
defined total homology spectral radius, `not Function.Bijective f`,
and `5 <= 2*q+3`. Its proof is
`exact CounterexampleAssembly804.exists_counterexample`.
The complete statement, including its quantifiers and hypotheses, is
preserved verbatim in `../upstream/Counterexample.lean.txt`.

The frozen challenge configuration requests exactly this declaration,
no definition holes, and only `propext`, `Quot.sound`, and
`Classical.choice`.

Published primary evidence:
https://github.com/nealmcb/openai-math-lean-tooling/tree/a64864be75cc48d1e21d6d02198b3fa231c888e4

`MANIFEST.txt`, lines 3-8, gives the full OpenAI revision above,
`leanprover/lean4:v4.34.1`, and Mathlib revision
`d13f23b723b8a846827a245b89c10fc7d3f11612`.
`results/cmp-all/all.jsonl`, line 296, records
`"config": "C1EntropyCounterexample"`,
`"solution": "OAI.Dynamics.EntropyCounterexample.Counterexample"`,
`"theorem_count": 1`, `"build_exit": 0`, `"outcome": "accepted"`,
`"nanoda": false`, and `"build_skipped": true`.

This is the publisher's historical acceptance record, not a fresh
campaign run, an additional nanoda check, or evidence about mutable
`main`. Interpretation of the theorem's definitions is a separate
mathematical obligation addressed in `../report.md`.
