# Statement fidelity: finite and algebraic core of two-color matching

`TwoColorMatching.endpoint_abs_det` is universally quantified over every
natural number `m` and arbitrary real vectors `g,x : Fin m -> Real`. Its
matrix has entry

    -g[p] * x[p]^(m-1-j) / (m-1-j)!

in row `j`, column `p`; row reversal is `Fin.rev`. The theorem states the
exact absolute determinant, not merely its nonvanishing:

    product_j (j!)^(-1) * product_p |g[p]|
      * product_(i<j) |x[j]-x[i]|.

For the manuscript's internal switching variables (numbered from one),
set `g[p]=U[p+1]-U[p]` and `x[p]=s-s[p]`. Then
`x[j]-x[i]=s[i]-s[j]`. Adjoining the final-time coordinate adds a unit
block and leaves this absolute determinant unchanged. No ordering of the
switching times is assumed. The zero-dimensional case also compiles.
`ascending_det` supplies the signed identity before row reversal.

`TwoColorMatching.adaptive_domination_from_fibers` is a separate finite
hidden-history theorem. `A` is any finite hidden-outcome type and `B` any
finite displayed-outcome type. The kernel `q` can depend on the complete
list of past hidden outcomes. It need not have total mass one, so killed
or subprobability kernels are included. `project : A -> B` reveals only
the displayed data. The same nonnegative reference weight `w` is used at
every history. The hypothesis bounds the total `q`-weight in each fiber
of `project` by `w[b]`. For every natural path length, every initial
hidden history, and every nonnegative test of the displayed history, the
theorem bounds the actual recursive hidden integral by the recursive
product-reference integral. There is no conditioning on final survival
and no independence hypothesis on `q`.

`fiber_implies_test` and `adaptive_domination` give the fiber-to-test
translation and the backward-iteration proof. Nonnegative reals are
used so the kernel/test positivity hypotheses are intrinsic.

These are precisely algebraic and finite-kernel components of
`a02:endpoint-jacobian` and the backward iteration following
`a02:full-past-kernel`, respectively. The compiler does **not** verify the
existence of the common control measure in the manuscript's continuous
experiment, Taylor errors, entropy selection, successful-path mass,
change of variables, target volumes, the scale limits, or the Kakeya
theorems. Those are proved in `../report.md` and require independent
mathematical review. In particular this source must not be recorded as
a formal proof of the complete matching lemma.
