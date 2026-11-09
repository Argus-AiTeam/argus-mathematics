# Statement fidelity: deterministic mesh-tail core

This file describes only the five declarations in namespace `MeshTail` in
`Main.lean`. All real variables range over the actual real ordered field;
sequences range over every natural index, not a sampled finite set.

`envelope_step` quantifies over real values
`S A Snext Anext alpha C Lambda err`. It assumes `S >= 0`,
`0 <= alpha <= 1/2`, `C >= 0`, `Lambda >= 1`, `2*C <= Lambda`,
`err >= 0`, and the two displayed affine upper recurrences. Its conclusion
is exactly the upper recurrence for `max S (A/Lambda)`. No stochastic
recurrence, summability, or parameter choice is hidden in this declaration.
It does not require `A` to be nonnegative; that harmless strengthening
includes the manuscript's nonnegative case.

`scalar_product_bound` quantifies over real sequences `u a e`
and every natural `n`. Assuming nonnegative perturbations `a` and `e`
and the scalar one-step recurrence at every index, it bounds `u n` by
the initial value plus the partial error sum, times the finite product
of `1+a`. No boundedness of those products is assumed for this statement.

`uniform_scalar_bound` additionally assumes nonnegative `u 0`
and `E`, a common upper bound `E` for every partial error sum, and a
common real bound `B` for every finite product. It concludes the same
constant `(u 0 + E)*B` bounds `u n` for every natural `n`. The analytic
proof, not Lean, supplies these hypotheses using summable geometric
coefficients and summable inverse-square errors.

`fifth_power_bound` proves `(n+1)^5 <= 32^n` for every natural
`n`. `geometric_over_fourth` consequently proves
`n+1 <= B^n/(n+1)^4` for every real `B >= 32` and every natural `n`.
This is the universal index bound used to dominate the infinitely many
failure probabilities by a geometric series.

These are not formalizations of Brownian motion, SLE, the Green-kernel
identity, a stochastic Fubini theorem, the physical-disk rule, or either
Hausdorff theorem. Compilation certifies the deterministic recurrence
and infinite-index comparison only. The report proves the stochastic
inputs analytically and identifies the additional independent review
that neither this document nor a Lean compiler performs.
