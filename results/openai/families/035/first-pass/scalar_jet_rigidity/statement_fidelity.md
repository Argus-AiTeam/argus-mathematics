# Statement fidelity: scalar/canonical jet rank rigidity

`Main.lean` formalizes a quantified discrete theorem, not algebraic geometry
or threefold abundance. All declarations are in `ScalarJetRigidity`.
There are no axioms specific to this project, finite search bounds, or
geometric existence assertions in the formal source.

## Finite ranks, with arbitrary collisions

`drops omit x` counts the endpoint lists that consume one dimension at
lift `x`. The lists are indexed by `Fin k`, the lifts by `Fin p`, and each
list omits exactly the lift specified by `omit`. Distinct lists may omit
the same lift. `omissions` counts with the complementary equality test.

`unused_lift` and `fiber_capacity` quantify over every pair of natural
numbers `k < p`, every omission function, and every natural initial rank
`n`. If each lift can accommodate all its drops, then `n >= k`.
Neither primality of `p` nor distinctness of the omitted lifts is assumed.

`euler_saturation` quantifies over an arbitrary finite residue type `A`,
natural ranks `n(a), m(a)`, natural `gamma`, and a positive period `M`.
Its hypotheses are `m(a) <= n(a)`, `sum m = k`, and
`sum n + M * gamma = k`. It proves `gamma = 0` and `n(a) = m(a)`.
In the geometric application `gamma` is an integer Euler characteristic;
its assumed nonnegativity permits representing it as a natural number.

`endpoint_rank_rigidity` combines these statements for every `k < p`,
with a separate omission function on the `m(a)` lists in each residue.
It proves saturation and that the final rank at every lift is exactly
the number of lists omitting that lift. It includes coincident centers
and distinct or coincident omitted lifts. It assumes the actual
capacity inequalities and Euler equality; it does not manufacture them
from a sheaf or a spectral sequence.

`pairCount a b x` is the multiplicity of `x` in the two-element multiset
`{a,b}`. `forced_pair_swap` assumes equality of these multiplicities for
all `x` and `a != c`, and proves the swapped matching `a=d, b=c`.
In particular, it does not silently replace a multiset by a set.

## Divisors and congruences: the arithmetic parts only

`coefficient_divisibility` proves, for arbitrary integers, that
`P | t` and `b-t*m=P*v` imply `P | b`. The geometric construction of
arbitrarily wide canonical jets, their power maps, and their valuation
identity is proved in `proof.md`, not in Lean.

`thickness_bounds` proves the coefficientwise inequalities
`(s-C)*m <= (s-h)*m-b <= s*m` from
`0 <= h*m+b <= C*m`. It allows signed `b` and `h`.
It does not assert the existence or triviality of a line bundle.

`small_multiple_zero`, `unique_positive_multiple`, and
`negative_residues_distinct` prove the exact integer lifting steps used
to pass from congruences to equalities, with their interval hypotheses.
`offset_stabilizes` proves equality of two offsets in `[0,C]` when
`C<N`, the first swapped sum is exactly `N`, and the second is divisible
by `N`. The eventual availability of these hypotheses is established
in the prose argument.

## Exact tail and genuine limit

`centered_step`, `alternating_of_step`, and `exact_width_tail` prove the
all-index identity

    2*(p+1)*d(n) - 2*p*M*p^n + (p+1)*c
      = (-1)^n * (2*(p+1)*d(0) - 2*p*M + (p+1)*c)

for every integer sequence satisfying
`d(n+1)+d(n)+c=M*p^(n+1)`. These theorems do not assume convergence.
`monotone_tail_bound` additionally proves
`abs(centered p M d c) <= (p-1)*c` from two consecutive recurrence
equalities and Frobenius-growth inequalities.

`real_tail_invariant` gives the same identity over the real numbers.
`width_limit` quantifies over every real `p>1`, `M>0`, constant `c`,
and real sequence satisfying the recurrence for every natural index.
Its conclusion is `Filter.Tendsto` of `d(n)/(M*p^n)` to `p/(p+1)`.
It is a topological limit theorem, not a check of a finite prefix or an
assumption that a limiting value exists. A tail starting at index `E`
uses `M=M_E` and reindexes `d(n)=d_(E+n)`.

## What remains outside the compiler

The interpretations as Cech page ranks, endpoint duality, the scalar
jet rule on a primitive nonreduced cycle, the nilpotent Picard-kernel
argument, formal inverse-limit trivializations, and the geometric
Euler formula are not encoded in Lean. `proof.md` supplies these
arguments and states the geometric hypotheses explicitly. The standard
duality and Riemann--Roch inputs are quoted with primary-source URLs in
`sources.md`. Strong semistability, absence of scalar polar parts, and
birational preparation are upstream inputs, not results of this work.

The formal certificate therefore verifies the rank/arithmetic bottleneck
and the exact-tail implication. It neither verifies the entire companion
manuscript nor proves log-canonical or terminal threefold abundance.
Independent review of this reading and the prose-to-formal bridge is
required.
