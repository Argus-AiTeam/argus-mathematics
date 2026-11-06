# Statement fidelity: the noncommutative averaging core

This document describes `research/gamma_core/Main.lean`, namespace
`GammaCore`. It does not claim that Lean formalizes strict comparison,
projection supply, nuclearity, ultrapowers, the conditional central limit
argument, or uniform property Gamma.

## Objects and hypotheses

`A` is an arbitrary unital ring with an `Algebra Real A` structure.
For the declarations involving `star`, it also has `StarRing A`.
`tr : A ->_l[Real] Real` is a real-linear map satisfying cyclicity
`tr (x*y) = tr (y*x)` for every pair of elements. When specified,
`tr 1 = 1`. A complex tracial state on a complex C*-algebra supplies
such a map by restricting scalars to the reals and taking real parts.

`c : Nat -> Real` and `r : Nat -> A` are arbitrary sequences.
`partialSum c r n` is the sum of `c i * r i` for `0 <= i < n`, with scalar
multiplication interpreted as real module scalar multiplication.
`comm x r` is `x*r-r*x`.

The sequence theorems assume `r i * r i = 1`. In the fourth-moment
theorems the `r i` and every indicated prefix are selfadjoint.
Prefix selfadjointness is an explicit hypothesis, not a theorem about
arbitrary real star algebras without a compatible scalar-star structure.
It is automatic for the C*-algebras to which the report applies.

The centering assumptions are precisely
`tr (partialSum c r i * r i) = 0` and
`tr ((partialSum c r i)^3 * r i) = 0`.
They are consequences of the manuscript's stronger condition
`tau(s*r_i)=0` for all `s` in the previously generated algebra.
No pairwise commutation of the symmetries is assumed.

## Formal conclusions

`trace_second_step` proves the exact weighted second-order expansion.
`trace_fourth_step` proves the full cyclic-trace fourth-order expansion
for one arbitrary ring element and one involution; its odd terms are
retained, not silently discarded.

`comm_square_trace` proves

    tr ([x,r]^* [x,r]) = 2 tr(x^2) - 2 tr(x r x r)

for selfadjoint `x,r` with `r^2=1`.

`centered_fourth_step` removes the two odd terms only under the explicit
centering hypotheses and gives the exact nonnegative-defect expression
when the trace is positive:

    tr((x+c r)^4)
      = tr(x^4) + 6 c^2 tr(x^2) + c^4
        - c^2 tr([x,r]^* [x,r]).

`prefix_second` and `prefix_fourth_defect` prove, for every natural
number `n`, the corresponding finite-sequence identities. In particular,

    tr(Z_n^4) = 3 (sum_{i<n} c_i^2)^2 - 2 sum_{i<n} c_i^4
                - sum_{i<n} c_i^2 tr([Z_i,r_i]^* [Z_i,r_i]).

`prefix_fourth_bound` additionally assumes
`tr(x^*x) >= 0` for every `x` and `sum_{i<n} c_i^2=1`. It proves
`tr(Z_n^4) <= 3 - 2 sum_{i<n} c_i^4`, universally in `n`, `A`,
`tr`, and the two sequences. Taking `c_i=sqrt(beta_i)` recovers the
manuscript's fourth-moment estimate and specifies its exact deficit.
For the represented C*-algebra, `tr([x,r]^*[x,r])` is the squared
tracial 2-seminorm of the commutator.

## Limits of this certificate

The formal centering hypotheses must still be obtained by the projection
and coefficient-centering construction. Real and imaginary parts are
needed for full complex coefficient identities, which are proved in
`report.md`, not in this Lean file. The report's analytic theorem requires
independent mathematical review; this compiler result certifies only the
declarations described above. Neither a finite matrix example nor this
algebraic formalization substitutes for that review.
