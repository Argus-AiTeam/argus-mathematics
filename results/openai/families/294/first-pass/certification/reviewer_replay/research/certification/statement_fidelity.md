# Statement fidelity: Certification294.main

`Certification294.main` has exactly the type `OAI.Kaplansky.MainTarget`
and applies `OAI.Kaplansky.kaplansky_quasitrace_counterexample`.
It is a wrapper around the actual upstream proof, not an independent
replacement proof and not the comparator's placeholder.

The intended reading of `MainTarget` is the following, with no numerical
or finite-dimensional restriction on the algebra or its quasitraces:
there exist a type `A` with its unital complex `CStarAlgebra` structure,
a proof of `TopologicalSpace.SeparableSpace A`, at least one normalized
`OneQuasitrace A` satisfying `IsTwo`, and a single fixed pair `a b : A`
of positive contractions, such that every normalized `OneQuasitrace A`
satisfying `IsTwo` has real defect at least `(1 : Real) / 144`.
The existential pair is chosen before the universal quasitrace.

`OneQuasitrace` must carry positivity on every square, invariance between
`star x * x` and `x * star x`, compatibility with real and imaginary
self-adjoint parts, and complex linearity on every closed commutative
nonunital C*-subalgebra. It does not impose global additivity.
`Normalized` means value one at the algebra unit. `IsTwo` means that
there exists a `OneQuasitrace` on the usual C*-matrix algebra at size
two whose restriction along the upper-left corner is the given map.
The extension is not separately normalized to value one; its value on
the matrix identity is two.

`PositiveContraction x` must mean that `x` is a positive element
(equivalently, a square `star y * y` in a C*-algebra) and `norm x <= 1`.
Positivity of the quasitrace on positive elements makes the defect at
the displayed pair real. The real-part inequality therefore expresses
the real inequality in the manuscript, not a weakening of it.
Normalization also excludes a zero algebra.

The upstream construction chooses the algebra as a 48-by-48 matrix
amplification of its actual 24-generator shift algebra. The internal
bundle tests must cover all positive matrix sizes and polynomial degree
bounds, and the proof must separately establish existence of the
corner-compatible 2-quasitrace. A proof of the conditional defect
estimate alone does not establish this statement.

There are no additional mathematical premises on `Certification294.main`.
For certification, its complete dependency closure must compile under
Lean 4.31.0, have no proof holes, and use only `propext`, `Quot.sound`,
and `Classical.choice` as transitive axioms. The source prints both the
main target and matrix-extension definition and prints the main theorem's
transitive axioms to expose these obligations.

This document states the translation that independent Reviewer must
check against the acquired definitions and staged source. Its existence
does not assert successful compilation or Reviewer approval.
