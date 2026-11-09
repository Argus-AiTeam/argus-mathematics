# Statement fidelity: the shared integer-signature core

The claim is `C_SIG_CORE`. All declarations below are in namespace
`IntegerSignature` in `Main.lean`. This document describes the actual encoded
theorems, not a sampling or counting theorem.

## Signature and its interpretation

`OnePositive B`, for a real bilinear form `B`, means

    for every u and v, B(u,u) > 0 implies
    B(u,u) B(v,v) <= B(u,v)^2.

For symmetric forms this is the projection characterization of positive index
at most one. `no_positive_plane` proves that this condition rules out *every*
positive-definite pullback along a linear map from R^2. The matrix forms used
here are symmetric: `weight_matrix_symmetric` proves this for arbitrary weight
functions because the two removals commute. Thus the usual spectral phrasing
"at most one positive eigenvalue" carries multiplicity, not merely distinct
eigenvalues. No numerical eigenvalue threshold is involved. The formal theorem
is the intrinsic positive-plane exclusion; finite-dimensional spectral
terminology is its ordinary mathematical interpretation.

## Exact integer model and quantifiers

`integer_signature` quantifies over:

* an arbitrary finite remaining coordinate type `iota`, including the empty
  type, with capacities `m : iota -> Int`;
* an arbitrary natural number `n` of eliminated pairs, including zero;
* an arbitrary function `width : Nat -> Nat`, constrained only by
  `0 < width k` for `k < n`;
* an arbitrary integer remaining total `r`;
* an arbitrary finite laminar family `L` of subsets of `Coordinates iota n`;
* arbitrary real-valued sequences `psi G : Int -> Real`, strictly positive at
  every integer and satisfying
  `psi G (a-1) * psi G (a+1) <= psi G a ^ 2` at every integer for every `G in L`.

`Coordinates iota 0 = iota` and
`Coordinates iota (n+1) = Coordinates iota n + Bool`. Each extra disjoint
two-point summand is a pair; its two capacities are both `width k`.
Consequently this is not a binary-capacity theorem. Any finite set with
arbitrarily labelled disjoint pairs is obtained by a coordinate bijection;
laminar sets are otherwise unrestricted and may meet either side of any pair.
The nested-sum notation chooses an elimination order, not a laminar restriction
on the pairs. Unused values of `width k`, `k >= n`, are irrelevant.

`Box m z` means `0 <= z i <= m i` at every coordinate. Allowing integer rather
than natural remaining capacities is a harmless strengthening: negative
capacities admit no box-valid display. The manuscript's nonnegative capacities
are included exactly.

`sliceWeight L psi cap R` is zero outside the integer box and total `R`;
inside it is `product_G psi G (sum_{i in G} z i)`. Its full total is
`r + widthSum width n`, where `widthSum` is the sum of the eliminated widths.
`contract M w z` is the ordinary, unweighted sum

    sum k=0,...,M of w(join z k (M-k)).

It has exactly one term per integer profile, with no binomial or factorial
multiplicity. `eliminate` applies this operation recursively to all `n` pairs.

The conclusion `SliceSignature m r Phi` quantifies over *every* box-valid
integer display `z` with sum `r+2`. It asserts `OnePositive` for the real matrix
with entry `Phi(remove z i j)`. `remove` subtracts two units, even if `i=j`;
it never uses truncated natural subtraction on the displayed coordinates.
All invalid removals therefore evaluate to zero by the support of the weight.
In particular `z i=0` gives a zero row and `z i=1` gives a zero diagonal.
Upper box constraints and the total slice are present in `sliceWeight` and
preserved by `contract_positive`; they are not implicit conventions.

## Proof obligations actually discharged

`laminar_nonpositive` proves the normalized laminar-product kernel is
nonpositive on the zero-sum hyperplane, by erasing a minimal laminar block and
subtracting a nonnegative block rank-one form. `factorization`,
`removal_form_identity`, and `initial_slice_signature` prove the equality to
the actual positive-factor integer weight, including the invalid-diagonal
correction. The initial signature is not an assumption.

`block_decomposition` proves equality of the actual old two-removal form,
pulled back through `splitMap`, and the block form used in the pair argument.
`pair_one` proves the local quadratic second-difference inequality from this
form's signature. `cumulative_product` and `cumulative_difference` construct
the common hyperplane and certify every interior division. `balanced_pair`
proves finite telescoping for every width at least two. `width_one` proves
the null-axis case; `contract_signature` proves that its nondegeneracy or
zero-matrix alternative follows from the actual positive model, rather than
assuming it. `iterated_closure` proves induction for arbitrarily many pairs.
None of these declarations assumes the signature of the contracted matrix.

`pair_weighted` is the companion weighted estimate. For arbitrary `D >= 2`,
the interior block forms at `1 <= k < D` must have the signature and the
interior `u k` must be positive; `u 0`, `u D`, `u (D+1)`, and `S D` are zero.
For every old vector `h` with `sum_{l<D} S l h = 0`, it proves

    2 sum_k u k * g k^2 <= -sum_k k(D-k) * V k h h.

Here `g` is the cumulative quotient and the formal sums range from `0` to
`D`, with zero endpoint contributions. In the sampler application
`D=B+1`, its hypotheses involve only the box-valid displays `1,...,B`.
There is no endpoint matrix assumption and no signature claim about this
weighted sum itself.

## Additions, reflection, and limits

`integer_addition_signature` has the same positive-factor and width
hypotheses as `integer_signature`. It proves the two-addition matrix
signature at every box-valid display of total `r-2`, for the *same*
eliminated weight. `slice_reflection`, `contract_reflection`,
`eliminate_reflection`, and `capacities_sum` establish its precise
reflection and total identities; positivity and log-concavity of the reversed
factors are proved in the theorem.

`limiting_signature` quantifies over any sequence of weights `W n`, each
having `SliceSignature m r`, converging at every integer profile to `w`.
It proves `SliceSignature m r w`. No positivity, nonzero interior entry, or
quotient is required in the limit. `matrix_limit` proves that finite
entrywise convergence suffices. Limits of the addition matrices follow by
the same theorem or by reflecting the limiting weights. Finite balanced
sums commute with these limits by finite-sum continuity. This does not claim
closure for infinite sums or an infinite coordinate set.

## What this compilation does not check

It does not encode the contingency-table graph, the forest interval lemma,
the definition of the manuscript's real penalty `D`, or a sampling/counting
algorithm. The report proves the weight-realization bijections and states
their hypotheses separately. Independent review must check those
bijections, the coordinate-relabeling interpretation, and this document's
faithfulness to the formal statements. The compiler does not verify
statement fidelity, publication significance, or novelty. The mathematical
core is already asserted in the manuscripts; this deliverable is an
independent formal verification, not a claim to have discovered that theorem.
