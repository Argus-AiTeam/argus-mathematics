# Family-255 interface replay: statement fidelity

This is a small compatibility replay of the author's concrete cyclic-series,
coarse-equivalence and self-quasi-isometry interfaces, not of recognition or
bounded height. The unmodified sources and Git blob identities are in
`upstream/lean/` and `closure.json`, pinned to openai/math commit
`4eaee87548250b2682affda7d05d947c05554bae`.

Run `python3 guide/evidence/family-255/lean/replay_interfaces.py`, then
`math-lean-verify guide/evidence/family-255/lean/InterfaceReplay.lean`.
The generated file concatenates complete coarse-interface modules in dependency order,
removes their imports, and imports the installed Mathlib umbrella instead.
Every source's SHA-256 is checked before bundling; `interface-replay.json`
records the module order, exact declaration-extraction boundaries, and substitutions.
The cyclic-series part includes the exact defining declarations and the
`CyclicStep.bot`, `CyclicSeries.refl`, `CyclicSeries.cons` and
`isPolycyclic_of_isCyclic` constructors. Their unrelated later declarations
are not included. No retained theorem hypothesis or body is changed.

`InterfaceWitnesses.lean` is a tail fragment for that bundle, not a standalone
module. It instantiates the author's *actual* definitions on the infinite cyclic
group `Multiplicative ℤ`: its one-step subnormal cyclic series, finite-generation
witness, and the identity coarse equivalence. It also instantiates the actual
`SelfQuasiIsometry` record on the ordinary metric real line and applies its
proved inverse-error bound. The
definitions are not replaced by a custom finite or vacuous model.

On 2026-11-10 the final replay passed `math-lean-verify` (exit 0): 51 theorems
and lemmas, no `sorry`, only Lean's standard axioms. The adjacent
`verify-interface.log` is that tool's actual output. `interface-axioms.log`
also retains the explicit `#print axioms` output for the four task-local
witness theorems and the author's coarse/metric bridge, finite-generation
transfer, and inverse-upper-bound lemmas.

Neither these witnesses nor any successful interface replay establishes
`group_recognition`, `main_uniform_bounded_height` or `lattice_recognition`.
The original entry's verifier exit 2 is recorded separately in
`verify-original.log`: locally installed Lean 4.31.0 cannot find an `OAI` compiled
module. This is not a theorem failure and does not measure its transitive axioms.
The exact command was
`math-lean-verify guide/evidence/family-255/lean/upstream/lean/OAI/GroupTheory/PolycyclicRecognition/Recognition.lean`.
The author's pinned stack is Lean 4.34.1, Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`, with an explicitly patched external
Gromov package. The full 2679-module source graph was retained but not rebuilt.

The first reconstruction of the three Gromov boundary files was a no-op:
`git apply --directory=... --include=Gromov/...` selected no files. The earlier
claim that patched entries had been retained was therefore incorrect.
On 2026-11-10 this was repaired using include paths with the directory prefix.
The original base files are unchanged; the reconstructed
`FormalConjecturesCheck.lean`, `Gromov.lean` and newly created
`PolynomialGrowth.lean` match the patch's output blob prefixes
`52e4b65`, `bfc3ce3` and `43f2bfe`, respectively.
`gromov/patch-check.log` records their full blob hashes, the import and moved
definition checks, and a successful reverse-application check.
`gromov/patch-application.log` records the actual application command.
These are source-reconstruction checks, not compilation of the Gromov package.

The initial 14-module attempt additionally included the complete cyclic-series
length API and `FiniteWordMetric`. It failed in Lean 4.31.0: among other changed
APIs, `MonoidHom.domRestrict`, `ite_eq_left`, and `Group.Generators` are absent.
`InterfaceReplay-initial.lean.txt`, `interface-replay-initial.json`,
`verify-interface-initial.log` and `interface-compiler.log` preserve that attempt.
In particular, diagnostic `sorryAx` following those elaboration failures is
not an axiom audit of the author's source. The final replay deliberately makes
no word-metric existence claim. That full construction remains source-level
evidence in the unchanged `Analysis/FiniteWordMetric.lean`.
