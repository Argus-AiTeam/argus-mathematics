# Statement fidelity of the finite weighted likelihood core

Claim: `V_LPT_L2_STEP`. Source: `Main.lean`, namespace
`LatePrefixTransfer`. Scalar objects are real numbers; indices are
arbitrary types restricted to an arbitrary finite set. Every displayed
hypothesis is universally quantified. No probability-space or
independence assumption is hidden in the Lean declarations.

`quadratic_identity` proves the exact expansion of the updated
likelihood square `(r*z)^2` into the previous square, its linear
increment, and its quadratic increment.

`pointwise_step` assumes `(z-1)^2 <= a^2 + M^2*e` and the
exception-local barrier `r^2*e <= B^2*e`. It concludes the precise
pointwise second-moment bound. There is deliberately no global
assumption `r<=B`, since a previously stopped path may have overshot.

`barrier_on_live_exception` proves that exception-local barrier
from `e>=0` and either `e=0` or `0<=r<=B`. Thus a frozen path
can have any likelihood value while its live-exception weight is
zero.

`integrated_step` takes finite nonnegative weights `p`, the
pointwise variance and exception-local barrier inequalities, a
zero **integrated** linear term
`sum p*r^2*(z-1)=0`, and only the integrated exception bound
`sum p*e<=eps`. Its conclusion is

    sum p*(r*z)^2 <= (1+a^2)*sum p*r^2 + B^2*M^2*eps.

The weights need not sum to one. In the report they contain the
raw state probability, the uniform witness probability, and the
allowed-witness indicator. Here `r` is the previously stopped
likelihood, `z` its next stopped multiplier, and `e` is the
indicator of a live next exception. The martingale property
supplies the zero integrated linear term. No hypothesis bounds
the conditional exception probability at individual histories.

`iterated_bound` takes a real sequence `v`, `q>=1`, `c>=0`,
`v(0)<=1`, and the recurrence `v(t+1)<=q*v(t)+c`. For every
natural `t` it proves `v(t)<=q^t*(1+t*c)`. Substitution
`q=1+a^2`, `c=B^2*M^2*eps`, and `t=L` gives the report's
stopped second-moment bound `H_*`.

These declarations formalize the algebraic integration and iteration
needed in Theorem 1 of `report.md`. They do not encode the
conditional-probability definitions, the proof that adaptive
transcripts are cylinders, the survival estimates, discrepancy,
the geometric simulation, Cauchy--Schwarz, or the main Ramsey
theorem. Those are proved in the report or explicitly left as
upstream assumptions. Compiler success must not be described as
formal verification of those unencoded statements.
