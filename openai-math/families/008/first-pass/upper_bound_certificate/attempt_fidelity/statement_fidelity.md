# Statement fidelity: Audit9000008.upper_bound_gt_two

`Audit9000008.upper_bound_gt_two` quantifies over every natural number n
and assumes only `2 < n`. Its conclusion is

    Module.finrank Q (OAI.DeligneDrinfeld.Wn n)
      <= Module.finrank Q (OAI.DeligneDrinfeld.Fn n).

There is no maximum weight, no bounded search, and no hypothesis providing
a generating family or asserting the desired dimension inequality.
Finite-dimensionality is supplied by the imported coordinate/graded-piece
proofs, not an additional mathematical assumption.

The left object is the weight-n subspace of the full ordinary rational
free Lie algebra on two generators satisfying exactly the three staged
equations. `Audit9000008.manuscriptSolution` writes out antisymmetry, the
three-term relation with third argument -x-y, and the five-term pentagon.
Its strand numbers 0,1,2,3 are the manuscript's 1,2,3,4.
`Audit9000008.solution_fidelity` identifies this predicate with the
implementation's `IsSolution`; `Audit9000008.membership_fidelity` identifies
it with membership in `W`. Both equalities must be checked by the compiler.
The printed definitions of `braidRelations`, `braidIdeal`, `T4`, and `t`
make the infinitesimal-braid quotient and the chord conventions inspectable.
There is no extra special-identity assumption on the rational solution space.

`Wn n` is `W` intersected with `Ln n`; `Ln n` is the span of ordinary
bracket monomials with each of the two generators assigned weight one.
The right object `Fn n` is the weight-n piece of the ordinary rational
free Lie algebra indexed by natural numbers, where the k-th generator
has weight `2*k+3`. Thus it is exactly the manuscript's free Lie algebra
on e_3,e_5,e_7,... with those weights. `WeightedWord` uses generator and
bracket constructors and `weightPiece` takes their linear span.
Length in the odd generators is not substituted for weight.

The proof reuses the upstream declaration
`OAI.DeligneDrinfeld.RationalBound.finrank_Wn_le`; it does not reimplement
the proof or admit it as an axiom. A valid certificate requires the actual
transitive OAI import closure to have compiled and requires
`#print axioms Audit9000008.upper_bound_gt_two` to contain no axioms beyond
`propext`, `Classical.choice`, and `Quot.sound`. No arbitrary characteristic-two
primitive is identified with an ordinary Lie element, and no lifting of
arbitrary modular solutions is assumed.

The staged corollary also includes n=0,1,2. The declaration above DOES NOT
formalize these three cases or their combination with n>2.
`verify.py` separately checks the exact degree-one pentagon columns and the
degree-two three-term residual; weight zero is empty by the positive-weight
ordinary free-Lie definition. The all-weight result is the combination of
that finite base-case proof with this universally quantified n>2 theorem.
Only the n>2 claim is eligible for mechanical Lean evidence from this file.

This document states the intended interpretation. The compiler does not
verify that interpretation, the provenance of the upstream source revision,
or the mathematical novelty or publishability of the audit.
