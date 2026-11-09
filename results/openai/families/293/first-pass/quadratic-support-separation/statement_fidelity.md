# Statement fidelity: C_QSS_CORE

This document describes the declarations in `Main.lean`, namespace
`SupportSeparation`. It does not assert that a kernel-checked core is a
kernel formalization of the entire manuscript.

## Objects and conventions

`ConvexSeq F` means `2*F(n+1) <= F n+F(n+2)` for every natural `n`,
where `F : Nat -> Real`. `slope F n` is `F(n+1)-F n`; this is a
zero-based slope, so the manuscript's `alpha_m` is `slope A (m-1)`.
In particular the coefficient contact between `slope B (p-1)` and
`slope B p` is at the coefficient index `p`, not `p-1`.

`Minorant S f F` requires the exact anchor `F 0=0`, discrete convexity,
and `F n<=f n` only at `n in S`. The arbitrary set `S : Set Nat`
represents indices of actual finite obstacles. In the application,
positive nonzero coefficients give these indices; zeros are omitted,
so no finite logarithm of zero is encoded. The coefficient at zero
need not have modulus 1: the artificial envelope anchor is not that
coefficient. `GreatestMinorant` quantifies over every admissible
real-valued sequence with those same obstacles and anchor.

For a positive real sequence `v`, `ratio v n=v(n+1)/v n`, and
`kernel v q k=v(q+k)/(v q*v k)`. Positivity is quantified for every
natural index. `Antitone (ratio v)` is the multiplicative
log-concavity condition. `Summable (ratio v)` is summability of the
entire sequence, not a finite-prefix bound. Normalization at zero is
not needed by the kernel theorems.

## Envelope and slope declarations

* `greatest_minorant_exists`: if obstacles are nonnegative on `S`,
  `S` is cofinal, and one anchored convex minorant `G` exists, there
  exists a real-valued greatest anchored convex minorant `F>=G`.
  The supremum is proved bounded, not assumed finite.
* `envelope_contact`: every strictly positive curvature at a
  positive index of a greatest minorant forces membership in `S`
  and equality with the actual obstacle there. The proof constructs
  an admissible local upward perturbation and contradicts maximality.
* `slopes_monotone`: discrete convexity makes the zero-based slopes
  monotone. `slopes_cofinal` proves that an anchored sequence whose
  values exceed every linear upper bound has slopes cofinal in the
  reals. Convexity is not needed for this latter implication; combined
  with monotonicity it gives slopes tending to infinity.
* `slope_match` proves an adjacent threshold crossing from cofinality
  and a lower bound at index zero. `slope_match_above` additionally
  proves the crossing occurs above any prescribed index `K` when
  the target is at least `gamma K` and `gamma` is monotone.
* `quadratic_upper_of_curvature` and `curvature_or_quadratic_bound`
  prove the exact quadratic upper bound if discrete curvature is
  bounded by `2*ell`, including an arbitrary shifted starting index.
  The source's quadratic lower asymptotics contradict that upper
  bound in the application; those source asymptotics themselves
  are not assumed as a proved manuscript theorem by these declarations.

## Contacts and the whole finite middle

`matched_contacts` has two arbitrary greatest minorants, actual
positive indices `m,p`, `ell>0`, the strict curvature inequality
`2*ell < slope A m-slope A(m-1)`, and both threshold inequalities.
It concludes contact at **both** `m` and `p`. Thus the contact
conclusions are proved, not passed as hypotheses.

`finite_descent_exp`, `middle_bound`, and `matched_middle_bounds`
prove the geometric bounds for every natural displacement in both
finite directions. `middle A B p m n=-B(p+n)-A(m-n)` is used only
when `n<=m`; the opposite direction exchanges `A,B` and `m,p`.
The direction bounds are the two branches of the source's
integer interval `-p<=n<=m`. This is not a finite sample of that
inequality: the sequence functions, indices, and displacements
are universally quantified.

## Both infinite normalized tails

`kernel_step_le` proves monotonicity in the first kernel argument;
`kernel_comm` supplies symmetry. `kernel_le_ratio_right` proves
`kernel v q k <= ratio v k/v 1` when `q>=1`.
`kernel_le_ratio_left` proves the symmetric bound when `k>=1`.

`normalized_tail_summable` proves summability of
`k |-> kernel v q (k+1)` for **each** `q>=1`.
`normalized_tail_tendsto_zero` proves the actual limit

    Tendsto (q |-> sum' k, kernel v q (k+1)) atTop (nhds 0).

The summation index `k+1` represents all strictly positive integers.
The proof uses a summable majorant and Mathlib's kernel-checked
dominated convergence theorem for infinite series. There is no
truncation, numerical tolerance, or assumed tail limit.
At `q=0` the summand is constant and in general not summable;
no summability at zero is asserted. Lean's value of a nonsummable
`tsum` there has no bearing on the limit or on the application,
whose `q=m+p>=2`.

`both_normalized_tails` gives the sum of the two limits for arbitrary
independent positive sequences `v,w`. In the source application these
are `v_k=u_k=exp(-B_k)` and `w_k=1/u_{-k}=exp(-A_k)`.
These are different normalizations; the negative tail is not silently
normalized by the positive-side endpoint.

## Complex residual and zero-shift declarations

`central_margin` concerns arbitrary complex center, remaining middle,
positive-tail total, and negative-tail total. Given their stated norm
bounds it proves the reverse-triangle lower bound on the norm of
their sum; it does not assume the sum is nonzero.

`eventual_relative_margin` and `eventual_nonzero` combine this bound
with the two proved infinite-tail limits. An arbitrary function
`Q : Nat -> Nat` with `Tendsto Q atTop atTop` specifies the selected
contact shifts; no identity at all natural shifts is substituted
for an assertion only along those contacts. Centers have arbitrary
complex phases and positive norms `M`; the remaining middle has
norm at most `M*C`. Tail totals are bounded by `M` times the
respective normalized **infinite** sums at `Q n`.
The conclusions are an eventual relative norm margin for every
positive epsilon, and eventual nonvanishing when `C<1`.

`margin_identity` proves positivity and the exact expression
`1-2/(x-1)=(x-3)/(x-1)` for every real `x>3`.

`endpoint_strict_of_zero_pairing` concerns arbitrary bilateral
complex sequences with actual nonzero endpoints `t,h`, support
bounds, `t<=h`, and the zero-shift pairing equal to zero. It proves
`t<h` by reducing the possible endpoint equality to a single
nonzero product. In that case the infinite sum collapses to a
finite-support sum, so no nonsummable-tsum convention is used
to manufacture a zero pairing.

## What the compiler does not certify

The Lean file does not encode the entire functions `b,c,w` and every
step connecting their logarithms to the abstract envelopes; it does
not formalize the one-bounded-support case, complex-series
reindexing for the full manuscript correlation, the Hilbert-space
functional representation, or the complete invariant-subspace
classification. These are proved in Sections 1--6 of `report.md`
and require an independent mathematical reading.

In particular `C_QSS_SUPPORT` and `C_QSS_TAIL_CLASSIFICATION` must
not be promoted to `closed_kernel` from this file. Mechanical
evidence attaches only to the accurately scoped `C_QSS_CORE`.
The independent Reviewer, not the compiler and not this document,
must confirm the application fidelity and the complete prose proof.
