# Statement fidelity: Gaussian propeller obstruction

## Public declarations and quantifiers

The declarations are in namespace `GaussianPropellerAudit` in `Main.lean`.
`scalar_determinant_obstruction` quantifies over every natural number
`m >= 5` and every two functions `r P : Nat -> Real`. Only their values on
`0,...,m-1` are constrained or used. They represent the manuscript's
ordered radii and probabilities, with a zero-based index shift:
`r 0,r 1,r 2` are its first three radii, and `r (m-1)` is its minimum.

The hypotheses are exactly:

1. Every relevant radius is strictly positive and at most `2/3`.
2. The relevant radii are nonincreasing.
3. Their squared sum is one, and the sum of the probabilities is one.
4. For every cell, `P_i >= A r_i^2` and
   `P_i >= (83/200)r_i+(3/20)r_i^2`, with
   `A=929/1000` when `m=5` and `A=221/250` otherwise.
5. Writing `u=r 2`, `t=r (m-1)`, and `L=(r 0)^2+(r 1)^2`, the two
   determinant bounds hold with coefficient `23/25`:
   `(u^2-t^2)(L-u^2-2t^2)<=8(23/25)t^2` and
   `(3/2)(u^2-t^2)^2<=10(23/25)t^2`.

The conclusion is `False`. These hypotheses do **not** assume any of the
intermediate minimum-radius bounds, tail bounds, probability-excess
budgets, or the desired contradiction. All such intermediate facts are
proved from the finite sums and the displayed hypotheses.

The formal statement does not require `P_i<=1/2` or explicit positivity
of `P_i`. The quadratic bound already implies positivity; omitting the
upper bound strengthens the theorem and does not restrict its application.
Every terminating decimal in the Lean source is an exact real rational,
not a floating-point approximation.

`manuscript_obstruction` has the same quantifiers and hypotheses except
that its two determinant bounds use the manuscript's exact coefficient
`(3/Real.pi)^2`. It derives the relaxed bounds using
`manuscript_constant_bound`, which proves
`(3/Real.pi)^2<=23/25` from Mathlib's kernel-proved `Real.pi_gt_d2`.
Thus this declaration proves the literal universally quantified
scalar-determinant obstruction, not a sampled or bounded instance.

`relaxed_data_obstruction` is a stronger auxiliary formulation. Its
`RadiusData m A` contains the positive ordered radii, the radius cap,
energy normalization, nonnegative cell excesses, their pointwise
linear-quadratic lower bounds, and their exact total `1-A`.
The theorem allows `A=.929` for **any** `m>=5`, or `A=.884` for any
`m>=6`, rather than merely the manuscript's single switch at five cells.
The public scalar theorem constructs these data explicitly from `r,P`;
they are not an extra assumption on the manuscript's arrays.

## Proof and translation boundaries

The proof contains no `sorry`, `admit`, user axiom, probabilistic oracle,
or numerical decision procedure. The two public theorem declarations
print their axiom dependencies so the compiler output exposes any
unexpected axiom; the standard classical Mathlib foundations are allowed.

The Lean theorem is an algebraic and finite-sum result over the real
numbers. It does not formalize Gaussian integration, measurable
partitions, compactness of extremizers, Ehrhard's inequality, or HJN's
three-dimensional theorem. Those ingredients and their application to
arbitrary partitions are justified separately, step by step, in
`research/geometric_verification.md`. The two non-elementary external
inputs are explicit assumptions in the ledger with independently read
primary-source excerpts. No kernel-clustering claim is made.

Consequently a successful compiler run certifies the universal
obstruction, not the entire measure-theoretic partition theorem by
itself. Statement fidelity and the analytic bridge still require
independent mathematical review; this document does not assert that
the Host-invoked Reviewer has accepted them.
