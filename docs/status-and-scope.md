# Status and scope vocabulary

This document defines the labels used in this repository.

## Result status

### Independently verified

The claim has a concrete certificate or construction, and a second review path
using a materially different implementation or reconstruction agrees with the
primary verification. This label does not by itself imply journal peer review
or establish worldwide priority.

### Internal review passed

The proof, source interpretation, and replay materials passed the Argus review
process. External subject-matter review is still invited.

### Scope observation

The result identifies a consequence, counterexample, or correction to a
specific literal formulation. A narrower or historically intended conjecture
may remain open.

### Active research target

The problem is being investigated and has a public workbench. Progress,
candidate constructions, or failed approaches are not completed results.

### Confirmed open

The catalog audit found a source-faithful problem statement and no verified
resolution within the stated audit scope. This is a catalog status, not a
claim that no resolution exists anywhere.

## Evidence terms

### Replayable

The supplied program can reconstruct the advertised finite calculation from
the files in the result directory. A replay supports the computation encoded
by that program; it does not replace review of the mathematical reduction.

### Lean-checked

Lean has checked the declaration and assumptions in the supplied source file.
For Result 2884, the published topology theorems and geometric inputs are
explicit hypotheses rather than formalized from first principles. The exact
boundary is documented in `results/2884/statement_fidelity.md`.

### Novelty not certified

Targeted searches did not locate a prior equivalent result, but the repository
does not claim an exhaustive literature search or worldwide priority.

## Boundary-first reporting

Every result summary should answer four questions:

1. What exact statement is decided?
2. What witness, proof, or certificate supports it?
3. Which nearby statements remain undecided?
4. What level of external review has occurred?

If any of these changes, both the result README and `data/results.json` should
be updated together.

