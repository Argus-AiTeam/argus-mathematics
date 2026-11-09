# Statement fidelity: the forward implication of Theorem `thm:main`

The target is the staged September 23, 2026 manuscript
`Nontrivial Markov Type Forces Superreflexivity`, Theorem `thm:main`,
Lemma `lem:ordered-norm` with Appendix A, and Lemma `lem:edge-labels`.
This is verification of existing mathematics, not a novelty claim.

## Main statement: `CMain`

`Campaign9000327.MainTheorem.main_implication` quantifies over every real
Banach space `X`, represented by a real normed vector space and
`CompleteSpace X`. Its sole mathematical premise is
`HasNontrivialMarkovType X`: there exist real `p > 1` and real `K > 0`
such that ordinary Markov type holds with that exponent and constant.
Neither exponent nor constant is fixed independently of `X`.

`FiniteReversibleChain` contains a finite-state transition matrix with
nonnegative entries, row sums one, a nonnegative probability vector with
sum one, and detailed balance. Detailed balance and row normalization
imply stationarity. `stateCost` is the finite sum over all state paths of
length `n`, with weight `pi(initial) * product(transition probabilities)`,
of the `p`th real power of the endpoint distance. `MarkovTypeWith`
requires its inequality for every `Fin m` chain, every map into `X`, and
every natural `n >= 1`. Reindexing through `Fintype.equivFin` in
`MarkovTypeWith.bound` proves the same statement for every finite state
type. There are no irreducibility, positive stationary mass, aperiodicity,
laziness, special-start, integer-exponent, or martingale assumptions.
These are ordinary stationary reversible chains, not Markov convexity.

The conclusion `HasEquivalentUCNorm X` means that a real seminorm `q`
has positive comparison constants `a,b` with
`a * norm(x) <= q(x) <= b * norm(x)` for all `x`, and satisfies the
unit-ball midpoint definition of uniform convexity for every real
`0 < epsilon <= 2`. The positive lower bound makes it a genuine norm.
`main_explicit` exposes exactly these constants, both norm bounds, and
all epsilon/delta quantifiers without relying on the abbreviation.
The norm and convexity modulus may depend on `X`. No `Nontrivial X`
instance occurs; `zero_space_case` explicitly includes the zero space.

## Ordered norm: `COrdered`

`ordered_norm_construction` starts from `not HasEquivalentUCNorm X`,
not from failure of a stronger renorming property. It returns an
`OrderedNorm N` and explicitly displays positive definiteness, spreading
invariance under every strictly increasing finite placement, contractive
adjacent merging for arbitrary real coefficients, and
`CoordinatesRepresentable X N`. `C00` is `Nat ->0 Real` (Lean's
finitely supported functions); adding one to coordinate indices identifies
it with the manuscript's one-based sequences. Its real seminorm field
already supplies homogeneity, the triangle inequality, and nonnegativity.
No unconditionality or normalized basis is assumed.

`mergeAt i` adds coefficients at `i` and `i+1` and shifts subsequent
coordinates down. The contractive inequality has no same-sign or
nonzero-sum hypothesis. The subdivision proof treats same-sign pairs first;
`Subdivision.merge_context_le` handles opposite signs and the zero-sum
case by convexity and continuity. `averaged_prefix_lower` and
`averaged_coordinate_lower` retain a positive lower bound and prove
definiteness; they are not assumptions added to the lemma.

For every natural dimension `m`, including zero, and every real
`eta > 0`, `CoordinatesRepresentable` supplies a linear map on
`Fin m -> Real` with
`N(a) <= norm(T a) <= (1+eta)*N(a)` for every real coefficient array.
Definiteness forces injectivity. This is equivalent to distortion
arbitrarily close to one: choosing a smaller positive eta gives the
manuscript's strict distortion inequality. The embedding may depend on
both `m` and `eta`. Uniform relative approximation, subdivision
factorization, and composition with finite representations are proved
in the import cone.

The James--Enflo structural implication is part of the proof dependencies,
not an extra premise of these declarations. In particular
`exists_nonreflexive_finitelyRepresentable_of_not_hasEquivalentUCNorm`
constructs a completed, nonreflexive, finitely representable triangular
limit space. Completeness needed for the nonreflexive-space construction
is discharged on that space. The transitive axiom report for this
declaration is printed separately. The ledger's earlier James--Enflo
working assumption must be retired only after this dependency compiles.

## Odd labels and transfer: `CEdgeTransfer`

`odd_edge_transfer` quantifies over every finite state and marked-edge
type, every `FiniteMarkedChain C`, every real normed target `V` of
`MarkovTypeWith p K`, every label on every edge satisfying
`g(reverse e) = -g(e)`, and every `n >= 1`. It proves
`markedSumCost <= K^p * n * stationaryEdgeCost` with the identical
`p` and `K`. `markedSumCost` uses the full stationary marked-path law;
invalid paths have zero weight. `stationaryEdgeCost` weights each
one-step label by `pi(source e)*q(e)`. Parallel edges and nonzero labels
on nonfixed self-loops are retained.

`finite_representation_transfer` preserves exactly the same exponent
and constant on finitely representable normed spaces.
`odd_edge_transfer_span` proves the manuscript's more precise last
assertion: only the finite linear span of the labels needs embeddings
in a Markov-type target with arbitrarily small distortion. It restricts
labels to that actual span, not to an assumed enlargement of the target.
Neither transfer requires completeness.

The lift uses one integer coordinate per two-element reversal orbit.
A reversal-fixed edge has zero label over the real scalars and zero
displacement. In `latticeLift` a rejected move stays at the same full
state and its lifted mark reverses to itself. Accepted moves reverse
with their opposite displacement and preserve
`pi times uniform cube mass`. The potential increment is exactly the
original label on accepted moves and zero on rejections.
`centralLiftPath` injects every original marked path and an independent
initial point of the smaller cube into a wholly accepted lifted path.
Its exact path-weight factorization proves the lower cost comparison.
The cube-density factor tends to one for fixed time and finite orbit
dimension; `odd_edge_bound` takes this limit without enlarging `K`.

## Reused proof and trust boundary

The import cone uses the same public `finiteWalk`, its `OrderedNorm`,
and its finite-chain definitions that support reviewed `CWalk`,
certificate `research/finite_walk_certificate/certificates/CWalk-d0a6fb48b124f143.json`.
No accepted finite-walk source, object file, certificate, claim version,
or Reviewer judgement is changed or recompiled by this mission.
The forward moment bound combines its exact constants `3/20` and
`1/24` with the label-transfer bound, for every positive integer time.
`not_all_walk_moment_bounds` uses real-power growth for every real
`p > 1`; it is not a finite numerical check.

Additional public sources are from OpenAI revision
`4eaee87548250b2682affda7d05d947c05554bae`, preserved unmodified in
`public_sources/`. The explicitly recorded compatibility port targets
Lean 4.31.0 and the host's built Mathlib. The original source toolchain
is 4.34.1. The public monolithic build configuration and converse theorem
entrypoints are not executed. Compiler evidence, together with the
complete import closure and this reading of the declarations, determines
the certification; the bounded Python and Jacobian calculations are
only adversarial supplements.

The ordinary Lean foundational axioms `propext`, `Classical.choice`,
and `Quot.sound` are allowed. No additional mathematical axiom, proof hole,
unverified literature theorem, or changed definition is licensed by this
document. A successful compiler run verifies the encoded statements;
independent Reviewer confirmation of this translation is still required.
