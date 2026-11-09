# Statement fidelity: the uniform divisor moment

The target is `build/divisors.tex::lem:divisor`, not the Egyptian-fraction
main theorem and not a finite numerical test.

`DivisorMomentAudit.manuscript_divisor_moment` quantifies over **real**
`D,r >= 1`. It asserts the existence of a **real** threshold `S0` before
quantifying over `S,X,Y,N`. Thus this threshold depends only on `D,r`.
For every real `S >= S0`, every real `X,Y`, and every natural `N`, its
hypotheses are exactly

- `0 < X`, the domain of the manuscript's real logarithm;
- `S/(2 log S) <= log X <= D*S`;
- `X^(1/2) <= Y <= X`, with real powers;
- `(N : real) <= exp(D*S)`, without any bound of `N` by `X` or `Y`.

The conclusion is

`sum_{h in Finset.Icc 1 floor_nat(Y)} d_X(N+h)^r
 <= Y * exp(S^(1/4))`.

Here `OAI.ShortEgyptian.truncatedDivisors X n` is
`n.divisors.filter (fun a => (a : real) <= X)`, and
`truncatedDivisorCount` is its natural cardinality. All evaluated `n=N+h`
are positive. Consequently this is exactly the manuscript's count of
positive integer divisors, irrespective of the convention for whether
`0` belongs to the natural numbers. The proof ensures `S>1` and `X>=1`
uniformly, as required by the manuscript's definition of `d_X`.

## Bridges checked by Lean

1. `DivisorMomentAudit.shifted_sum` proves the bijection `h -> N+h`
   between `Icc 1 H` and `Ioc N (N+H)` for **every** natural `N,H`,
   including `H=0`. There is no discarded boundary term.
2. `DivisorMomentAudit.one_le_count` uses the divisor `1` to prove
   `d_X(n)>=1` for positive `n` and `X>=1`.
3. `DivisorMomentAudit.uniform_divisor_moment_real` uses the natural
   ceiling `k=ceil_nat(r)` and the comparison `d^r <= d^k` for `d>=1`.
   The natural-moment theorem is invoked at this fixed `k`, not at a
   parameter that can vary with `S,X,Y,N`.
4. It substitutes `v=log X` into
   `OAI.ShortEgyptian.uniform_divisor_moment`. Positivity of `X` proves
   `exp(log X)=X` and `exp(v/2)=X^(1/2)`. The real upper bound `Y<=X`
   and the full shift bound are unchanged.
5. Real endpoints are represented by `floor_nat(Y)`. For positive
   `Y`, the natural integers `1<=h<=Y` are precisely
   `Icc 1 floor_nat(Y)`. The natural theorem already uses
   `Ioc N (N+floor_nat(Y))`, so no replacement of `Y` by an integer
   occurs on the right-hand side.
6. `Filter.eventually_atTop` turns eventual validity into the displayed
   single-threshold quantifiers.

## Proof provenance and scope

The natural-moment theorem is an existing OpenAI solution theorem at
revision `4eaee87548250b2682affda7d05d947c05554bae`, in
`lean/OAI/NumberTheory/ShortEgyptian/MomentAsymptotics.lean`.
The original source targets Lean **4.34.1**. The local `Main.lean`
textually incorporates the nine relevant modules from `PrimeReciprocals`
through `MomentAsymptotics`, with their proofs, rather than importing a
precompiled OpenAI theorem or postulating the moment estimate.
Their original Apache-2.0 sources and license are retained under
`upstream/` and `LICENSE.upstream`. The earlier, unrelated modules in
the upstream import chain are not needed by these declarations.

The local compiler run must use Lean **4.31.0** and the host's built
Mathlib v4.31.0. All non-Mathlib moment dependencies are included in the
same compilation. The printed axiom reports for the natural and final
theorems must contain no unproved moment assumption or `sorryAx`.
The only permitted foundational axioms are `propext`, `Classical.choice`,
and `Quot.sound`.

This certifies the full mathematical assertion by an upstream proof
variant; it is not a line-by-line certification of every displayed
estimate in the manuscript. The finite Python checks and the bounded
Jacobian divisor-count operation are separate sanity checks, not
evidence for the asymptotic quantifiers. No false manuscript assertion
has been identified here. Rechecking an existing theorem and supplying
its real-parameter bridge does not by itself establish novelty or the
campaign's publishable-result gate. Statement fidelity still requires
independent human/Reviewer reading; the compiler alone does not certify
this document's interpretation.
