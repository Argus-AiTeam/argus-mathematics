# Statement fidelity: compiler execution and transport ingredients

This document describes `CompilerProof.lean`. It does not relabel that file as
a formalization of the entire literal-word evaluator.

The types in every theorem are arbitrary, unless a datatype is explicitly
finite. All list lengths, machine traces, budgets and cell contexts are
universally quantified. There is no finite search bound in the theorems.

## Components and source entries

`Edge`, `Reach`, and `Weak` use an arbitrary partial deterministic successor
function. `weak_reaches_terminal` and `weak_terminal_unique` prove terminal
attraction and uniqueness even without finiteness. `weak_join` and
`reverse_chain_unique` prove the forward-join and predecessor-chain facts.
`component_entry_unique` states its hypotheses explicitly: preservation of a
key, source entries, unique incoming edges in a predecessor-closed validator
set, uniqueness of clean entries per key, and the clean-or-failed-validator
dichotomy. It proves entry uniqueness under those conditions. This theorem
alone does not assert that a particular compiler satisfies the conditions.
Sections 2--4 of `compiler_theorem.md` supply their source-specific proof.

## Literal validator

`VCell.anchor`, `cutC`, `cutD`, and `workspace` are completely clean cells.
`VCell.dirty D` retains an arbitrary dirty cell as a value of an arbitrary type;
validator predicates do not inspect its contents. Thus no dirty tag can pass
a clean-cell test. A left stack is head-nearest first, right cells in word order.
The two boundary flags are independently arbitrary.

`vnext` is exactly the ten validator instructions, stopping at `q_start`.
`vprev` is their inverse on images; `validator_inverse` proves that inverse
property. `validator_good_step` and `validator_good_reach` prove the displayed
language invariant for every validator state, not just for entries.
`accepted_entry_clean` proves clean-entry necessity for every path from an
arbitrary entry to a proper handoff. `validator_decreases` and
`validator_terminates` prove termination with the explicit phase-and-gap
measure. `entry_no_predecessor` proves the source property. These theorems do
not include subsequent machine-phase states.

## Scan and array semantics

`Zipper.left` is a reversed stack. `Rewind` and `AcrossRight` are actual
one-cell crossings. `rewind_exact`, `right_exact`, `seek_match`, and `seek_none`
prove their finite-scan effects on arbitrary lists. `seek` stops before the
stationary match update. `copyInput_exact` gives the effect of filling successive
unused workspace slots with the input in order. `markAnchors` is the same
operation on unused output slots. `readOutput` includes a blank delimiter and
the anchor capacity; `cleanMarks` drops unused slots. These functions are the
rank-level copy/output loops. The equivalence of the interleaved physical
rewind/find phases with those rank loops is the explicit invariant argument in
section 3 of `compiler_theorem.md`, not an additional kernel theorem here.

## Arbitrary source machine and bounded pipeline

`Config` has an arbitrary machine state, a natural-number head, and an
unbounded tape function. `execute` writes exactly the current cell and moves
left by truncated subtraction, stays, or moves right. `machineStep` uses any
supplied partial deterministic transition table. `boundedStep` permits only
source and destination heads below the workspace capacity. Literal compiled
right-move overflow can additionally visit one stuck gap configuration; the
successful macro traces are the same, as the source-translation proof explains.

`bounded_step_sound`, `bounded_step_complete`, and `bounded_trace_sound`
check the update correspondence. `finite_trace_quota` proves that every finite
source trace fits all sufficiently large finite capacities, including its
final head. `padded_input` proves initial-workspace agreement at all accessible
indices.

`Symbol` separates blank, alphabet letters, and all other work symbols.
`spells` is the first-blank returned-word convention. `readTape` rejects
invalid symbols, lack of a delimiter, or exhausted anchor capacity.
`readTape_sound`, `readTape_complete`, and `spells_unique` prove its exact
behavior. `ProgramResult` uses an actual source trace, a declared halting state,
and that returned-word convention. `PipelineSuccess` uses a bounded source
trace after the rank-level copy stage, a halting state, and bounded output
reading. `pipeline_sound`, `pipeline_complete`, and
`pipeline_computes_program` prove genuine output and sufficient quota.
`program_result_unique` assumes no outgoing transition from a declared halt;
that is the supplied deterministic machine-table convention, not reversibility.

## Arbitrary original-word contexts

`wordGrade` is any nonnegative additive letter grade. `WordStep` puts a defining
equation into an arbitrary two-sided list context; `BoundedPath` includes every
intermediate word's grade. `arbitrary_word_context` proves bounded contextual
compatibility from the two explicitly supplied facts: one-step answer
invariance within the ball, and a normalization derivation within the input
grade. It does not assume that sector cuts survive context attachment.
The source-specific proofs of those two facts, including zero and nonpaths,
are sections 5--8 of `compiler_theorem.md`.

The mechanical claim is `C_COMPILER_EXECUTION_THEOREMS`, limited to these
declarations. The complete manuscript-level claim `C_COMPILER_CONTEXT` is
supported by the ordinary proof plus these certificates and requires
independent source-fidelity review. It is not claimed to be kernel-closed by
compiling this file.
