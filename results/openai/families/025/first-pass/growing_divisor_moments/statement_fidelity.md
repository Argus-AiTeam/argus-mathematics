# Statement fidelity: one threshold for growing real moments

This note describes
`GrowingDivisorMoments.growing_divisor_moment_real` and
`GrowingDivisorMoments.momentSeriesConst_explicit` in `Main.lean`.
The former is a new quantifier strengthening, not the previously approved
fixed-order claim `C_DIVISOR_MOMENT_REAL`.

The upper theorem quantifies over each fixed **real** `D >= 1`, then
produces a **real** threshold `S0 > exp(1)`. It subsequently quantifies
over every real `S >= S0`, every real
`1 <= r <= log(S)/(200000*log(log(S)))`, every real `X,Y`, and every
natural `N`. Thus the threshold depends only on `D`, not on `r`, `S`,
`X`, `Y`, or `N`. Its range has the requested explicit positive constant
`c = 1/200000`.

Its remaining hypotheses are exactly

- `0 < X`, the real logarithm domain;
- `S/(2*log(S)) <= log(X) <= D*S`;
- `X^(1/2) <= Y <= X`, with real powers;
- `(N : real) <= exp(D*S)`, without averaging or restricting the shift
  to the length of the interval.

The conclusion is

`sum_{h in Icc 1 floor_nat(Y)} d_X(N+h)^r
 <= Y*exp(S^(1/4))`.

Here the count is literally the cardinality of
`n.divisors.filter (fun a => (a : real) <= X)`.
Every evaluated `n=N+h` is positive. The interval bijection and the
natural floor encode precisely the natural integers `1 <= h <= Y`,
without replacing the real `Y` on the right-hand side. Eventual
positivity gives `X >= 1`; the divisor `1` justifies the real-to-natural
exponent comparison.

The series theorem quantifies over **every natural** `k`, including
zero, and proves
`sum' j, (j+2)^k*(3/4)^j <= 16*(4*k)^k`.
The formal natural powers give `0^0 = 1`.
It bounds a convergent infinite series, not a sampled finite sum.

## Proof dependencies and evidence boundary

`prepare.py` textually reuses the already approved source up to, but
excluding, `OAI.ShortEgyptian.uniform_divisor_moment`. This slice
contains the full proofs of the prime, Euler-product, prefix-cover,
finite moment, and elementary asymptotic lemmas, including
`divisor_moment_numeric`. It also reuses only the two approved elementary
bridge helpers `shifted_sum` and `one_le_count`. The provenance and
Apache-2.0 license remain at `../divisor_moment/statement_fidelity.md`
and `../divisor_moment/LICENSE.upstream`.
No new statement about the old fixed-order certificate is requested.

The new proof derives a simultaneous natural-order range from the
**finite** inequality, bounding every order-dependent premise explicitly.
Only after that does it set `k=ceil_nat(r) <= 2*r`. It never substitutes
an order depending on `S` into a theorem quantified only for fixed
orders. The final statement contains no assumption postulating the
desired moment bound or the explicit series estimate.

The compiler version must be Lean 4.31.0 with the host's built Mathlib.
The axiom reports must contain only `propext`, `Classical.choice`,
and `Quot.sound`, and no proof holes.

The infinite primorial obstruction is proved in `proof.md`, not by
these Lean declarations. Its elementary prime-counting proof and
asymptotic floor argument require independent mathematical reading.
The exact finite witnesses in `verify.py` do not prove an infinite
obstruction. Neither a successful compiler run nor the limited literature
comparison establishes novelty, optimal constants, publishable
significance, or the Egyptian-fraction main theorem.
