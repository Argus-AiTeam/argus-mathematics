# Conditional structural extension below alpha = 1/5

**Engineer assessment: supported as a conditional structural strengthening.**
It is not a stronger Jacobsthal bound and does not extend the upstream
regular-box or analytic sampling construction.

## Exact claim, source, and comparison

Historical `C_INVERSE_EXTENDED` v1 is the final "Structural extension and
comparison with the prior result" argument in
`9000021/research/inverse_certificate/REPORT.md`. Its dependencies are the
polynomial, cubic nonlinear and finite-rigidity units, not an unproved
claim that the source's analytic construction already works in this wider
range. The active claim is `R_EXTENSION`.

For every fixed range

```
0<alpha_min<=alpha<=alpha_max<1/5,
```

suppose the same rich-configuration outputs are supplied:
`R=z^alpha`, `S=z^(2-alpha+o(1))`,
`n` comparable to `xi*R/log R`,
`|X|>=S/Z^4`, pointwise incidence threshold `c5*n`, and
`K<=n*R/L^6`, with the same modular/CRT setting, fixed positive constants
and original order of choices. Then the structural polynomial/line/list
contradiction still works.

The original September 25, 2026 manuscript, revision
`4eaee87548250b2682affda7d05d947c05554bae`, states its inverse proposition
only at `alpha_max=1/100`. Its displayed quartic global degree estimate
gives exponent `(13*alpha-2)/3`. The componentwise proof, however, already
contains the cubic improvement explained in
[nonlinear-cubic](../nonlinear-cubic/report.md). The old report exploits
that improvement and makes a wider conditional range explicit.
No novelty or significance conclusion follows from this comparison alone.

## Decisive exponent check

Retain `d=floor(R/L^2)` and `m=ceil(S/(R*Z^6))`. The necessary strict power
inequalities are

```
(10*alpha-2)/3 < 0,    3*alpha-2 < 0,    2-2*alpha > 0.
```

They respectively make the cubic nonlinear loss negligible, the
small-line collision term negligible, and `S/(R*Z^6)` grow. All hold
uniformly with a positive margin when `alpha<=alpha_max<1/5`.
The nonlinear term without `S^(2/3)` has exponent `4*alpha-2`,
also negative on this range.

The short-line loss is still `S/(L^2*Z^6)=o(S/Z^4)`.
Coefficient-height/value logarithms remain `O(R/L^4)` and `O(R/L)`,
while richness supplies a fixed-`xi` positive multiple of `R` in
the prime-product logarithm. The fixed divisor-count integers can be
chosen with

```
alpha_min*(e+1)>alpha_max,
alpha_min*(C+1)>2,
alpha_min*(B+1)>2+alpha_max.
```

Thus the height, collision, and list-packing conditions retain their
rounding room and fixed-width quantifier order. No step requires
`alpha_max=1/100` once the rich configuration is assumed.

The endpoint `alpha=1/5` is **not** proved: the main power exponent
becomes zero and the remaining `Z` factors cannot be discarded.
Nor is there uniformity for `alpha_max(z)` approaching that endpoint,
or for `xi` tending to zero with `z`.

## Formal and computational boundaries

`structural_exponent_margin` in the unchanged `Main.lean` proves these
three linear inequalities for rational `alpha<1/5`. It does not encode
real-valued `alpha=log R/log z`, asymptotic limits, uniform error terms,
or rich-configuration existence. The same algebra establishes the real
inequalities in prose, but the distinction matters for fidelity.

The shared exact replay checks the illustrative rational
`alpha_max=19/100`, giving cubic exponent `-1/30`, and the manuscript
value `1/100`, giving `-19/30`. Those examples do not establish the
universal conditional range; the argument above does.
The fresh Lean run, Python environment, and reusable evidence are recorded
in [finite-rigidity/report.md](../finite-rigidity/report.md), not rerun
unchanged for this unit.

No concrete gap was identified in this conditional implication.
An unconditional extension would need new regular-box and sampling inputs
on the enlarged range. A stronger Jacobsthal theorem would also need all
the global dependencies. Those are concrete outstanding obligations,
not consequences of this exponent computation. Native independent review
of the conditional claim and its attribution remains pending.
