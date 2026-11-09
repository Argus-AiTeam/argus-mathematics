# Statement fidelity: exact reset-posterior lower-moment core

The claim is `C_POSTERIOR_SHARP_CORE`, not the RWRE first-contact
proposition and not the full probabilistic sharpness construction.

`PosteriorContact.sharp_moment_lower` quantifies over all natural numbers
`n`, `L`, and `J`, and every real `delta >= 0`. Its only additional
hypotheses are `J <= 2^L` and `2*L <= n`, with these two inequalities
taken in the natural numbers.

The real-valued definitions are exactly

\[
 \operatorname{peak}(n,s)
 =1+\sum_{i=0}^{n-1}\frac{2^i}{2}
           \left[1-\left(1-2^{-(i+1)}\right)^s\right],
\]
\[
 \operatorname{lowerMoment}(n,J,\delta)
 =\frac{\delta}{2}\sum_{s=0}^{J-1}\operatorname{peak}(n,s)
       +\delta\operatorname{peak}(n,J).
\]

The conclusion is

\[
 \operatorname{lowerMoment}(n,J,\delta)
       \ge \delta n J^2/64.
\]

In the report, `peak(n,s)` is the expected sum of coordinate posterior
maxima after `s` reset rounds on `2^n` equally likely labels.
When `delta=2^(-J)`, `lowerMoment` is a lower bound for `E[S H]` in the
finite capped-geometric construction. Neither that probability-space
interpretation nor the martingale property is a hypothesis or a
conclusion of this Lean theorem: both are proved separately in the report
and tested by exact rational enumeration in `verify.py`.

Supporting declarations `PosteriorContact.bonferroni_two` and
`PosteriorContact.hit_probability_half` prove the universal binomial
inequalities used for the reset construction.
`PosteriorContact.reset_peak_lower` proves
`peak(n,s) >= s*n/16` for every natural `s <= J` under the same
dimension constraints.

The formal source has no probability-space axioms, RWRE assumptions,
independence assertions, external theorem assumptions, or proof holes.
It does not encode the original stopped-law argument, shared-environment
transfer, martingale exponential moment, or upper contact bound.
A successful compiler run certifies the displayed algebraic inequalities
only; the infinite-environment proof and the probabilistic interpretation
still require independent mathematical review.
