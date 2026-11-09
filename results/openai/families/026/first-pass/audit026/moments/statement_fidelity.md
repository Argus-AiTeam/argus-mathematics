# Statement fidelity: universal local Euler algebra

The claim is `L026_EULER_CORE`. The namespace is `Audit026`.

`nonempty_subset_product` quantifies over every finite set `s` of a type
with decidable equality and every rational assignment `x`. It proves

    sum_{empty != u subset s} (-1)^|u| product_{a in u} x(a)
      = product_{a in s} (1-x(a)) - 1.

The summation includes all nonempty subsets, not only singleton subsets.
There is no bound on the size of `s`. This is the inclusion-exclusion
identity used within an occupied residue class.

`signedNonempty` specializes the summand to `(-1)^|u|`.
`fiber_sign` says that this sum is -1 when `s` is nonempty.
`fiber_sign_sum` quantifies over every finite family `c` of nonempty
finite fibers `f(i)` and says that the total is `-|c|`. The family need
not have disjoint fibers for this double-sum identity; the application
to Euler factors separately proves that actual residue fibers are
disjoint and represent the allowed subsets exactly once. Applying the
same identity to the exact equality fibers gives the net zeta exponent
`-t`. That analytic interpretation is not a Lean conclusion.

`occupied_local_density` translates that finite sign sum into the
rational expression `1-|c|/(p-d)`. This polynomial/division identity is
valid even at a zero denominator under Lean's totalized rational
division; its arithmetic application only uses primes `p>=2` and
`d=0` or `d=1`, so no denominator is zero.

`marked_normalization` quantifies over every rational `p` different
from 0 and 1, every rational `nu`, and every natural number `t`. It proves

    (1-(nu-1)/(p-1))/(1-1/p)^t
      = (1-nu/p)/(1-1/p)^(t+1).

There is deliberately NO hypothesis `nu != p`. In particular, both
sides are zero when `nu=p`. `marked_collision_normalization` combines
this formula with a family of allowed residue fibers: `nu=|c|+1`
includes the occupied residue of the prime mark, whereas `c` excludes
that residue. `marked_zero_factor` explicitly specializes to `nu=p`.

All coefficients and identities in this file live in the rational
numbers. The file neither represents complex Fourier variables nor
proves that a prime factorization exists, that its infinite product
converges, or that its value approximates a prime-weighted average.
Those analytic, number-theoretic, and statement-translation steps are
proved in `verification.md` and require independent mathematical
review. In particular this source does NOT formalize
`C026_UNIFORM_MOMENTS` or `C026_WEIGHT_MOMENTS`.

The only proof axioms permitted are Lean/Mathlib's ordinary foundational
axioms; the source introduces no axioms, placeholders, or additional
number-theoretic assumptions. A real Lean 4.31.0 compiler result is
required separately. Compilation establishes the displayed rational
identities, not this document's interpretation of them.
