# Statement fidelity: conditional deficit rigidity

Claim: `C_DEFICIT_RIGIDITY`.

The declarations are in namespace `TransportedEdgeRigidity`.
`transfer a b t v` is the real vector whose coordinate `i` is
`v i + (if i=a then t*v b else 0)`. Thus it is exactly the elementary
operator `id + t E_ab` used for an edge transition in the manuscript.
`transfer_mono` proves pointwise monotonicity when `t` is nonnegative.

`no_hidden_deficits` quantifies over an arbitrary index type `iota`
with decidable equality, an arbitrary finite schedule length `r`, two
sequences `D,U` of real vectors, arbitrary endpoint-index sequences
`a,b`, and arbitrary real weights `t`. No finiteness of `iota`,
acyclicity, distinctness of `a,b`, positivity of the state vectors, or
strict positivity of the weights is required.

Its hypotheses are exactly:

- For every `k<r`, `t k >= 0`.
- `D 0 = U 0`.
- For every `k<r`, `U (k+1) = transfer (a k) (b k) (t k) (U k)`.
- For every `k<r` and coordinate `i`, the actual value `D (k+1) i`
  is at most that transfer applied to `D k`.
- `D r = U r`.

It concludes both `D k = U k` for every `k<=r` and exact attainment
of each transfer bound for every `k<r`. All comparisons and equalities
are of actual real-valued functions, not numerical approximations.
The proof uses no axioms beyond those of Lean/Mathlib and no `sorry`.

This formalizes the uniform no-hidden-deficit implication in
`05-comparison.tex`, subsection "Equality forces all edge images".
It does NOT formalize Bruhat intervals, reflection-order realizability,
BMP sheaves, the edge-image inclusion, the normalization of their
Hilbert series, positivity of the Hilbert series of a nonzero quotient,
KL invariance, or the simultaneous freeness induction. In particular,
the required local step inequalities and endpoint equality are explicit
hypotheses, not proved for every actual BMP sheaf by this source.
The formal certificate must not be reported as a proof of
`C_IMAGE_EQUALITY` or as completion of the campaign.
