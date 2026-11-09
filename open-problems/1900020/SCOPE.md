# Frozen Jacobi-Perron counterexample claim

## Standard recurrence and quantifiers

View a totally real cubic number field through a specified embedding
`iota : K -> R`.  For a positive homogeneous state

`s_n = (x_n, y_n, z_n)`,

the standard Jacobi-Perron step used in Karpenkov's Problem 1 is

```
a_n = floor(z_n / y_n)
b_n = floor(x_n / y_n)
d_n = (a_n, b_n)
s_(n+1) = (y_n, z_n - a_n y_n, x_n - b_n y_n).
```

The initial state is `(1, iota(y), iota(z))`.  Positive rescaling leaves the
ratios and digits unchanged.  Thus, after normalizing the first coordinate to
one, the same step is

```
F(u_n, v_n) = ({v_n / u_n}, {1 / u_n}),
d_n = (floor(v_n / u_n), floor(1 / u_n)).
```

Here `{r} = r - floor(r)`.  The step matrix

```
M(a,b) = [[0, 1, 0], [0, -a, 1], [1, -b, 0]]
```

has determinant one.  Consequently, an initially Q-linearly independent
triple remains independent.  Neither remainder can be zero, so every
admissible candidate has a positive, infinite orbit.

The universal proposition under test is:

> For every degree-three totally real `K/Q`, every real embedding `iota`, and
> every `y,z in K` such that `0 < iota(y),iota(z) < 1` and `(1,y,z)` is
> Q-linearly independent, the digit-pair sequence `(d_n)` is eventually
> periodic.

Eventually periodic means

`exists N >= 0, exists p >= 1, forall n >= N, d_(n+p) = d_n`.

Campaign success is exactly its negation: one explicit admissible tuple
`(K,iota,y,z)` for which

`forall N >= 0, forall p >= 1, exists n >= N, d_(n+p) != d_n`.

This campaign does not seek a proof of the universal proposition.

## Required candidate format

An admissible candidate must provide:

1. A monic irreducible cubic `f in Z[T]` with positive discriminant, rational
   isolating intervals for all three roots, and one interval designating
   `theta = iota(T mod f)`.  These data certify a totally real cubic field and
   identify the order used by every floor operation.
2. Exact expressions `y=q_y(theta)` and `z=q_z(theta)` with
   `q_y,q_z in Q[T]` of degree at most two.
3. Exact checks that `0 < y,z < 1` at the designated root and that the
   coefficient determinant of `(1,y,z)` relative to `(1,theta,theta^2)` is
   nonzero.  Decimal approximations may accompany, but cannot replace, these
   checks.
4. A deterministic command, all input files, and a finite certificate whose
   verifier uses rational/integer or certified real-algebraic arithmetic.

## Infinite-certificate postcondition

The certificate must check both candidate admissibility and an infinitary
statement that implies the quantified digit mismatch above.  Acceptable forms
include a mechanically checked parametric induction producing an unbounded
subsequence of exact digits, or a mechanically checked symbolic
word/substitution description together with a proof that its digit word is not
eventually periodic.  Any other form is acceptable only if its verifier checks
the same infinite conclusion rather than sampled iterations.

For example, exact identities and inequalities proving
`b_(n_k) >= g(k)` for all `k`, with `g(k)` unbounded, suffice: every eventually
periodic integer-pair sequence is bounded.  A finite prefix, failure to find a
cycle, nonrepetition of finitely many states, a timeout, floating-point
stability, a near-solution, or `UNKNOWN` does not suffice.  Even infinitely
many distinct states would require a separate argument about the digit word,
because eventual periodicity here is defined on the output digits.

## Reused evidence and closed dead ends

- The independently reviewed batch status at
  `/home/argustest/zimo/counterexample-batch-1/status-evidence/1900020/README.md`
  fixes the source alignment as exact and the problem as open, and rejects
  numerical nonperiodicity as a counterexample.
- `research/sources/karpenkov-2101.12627v2.pdf`, arXiv:2101.12627v2, p. 2
  supplies the recurrence; p. 3, Problem 1 and its following paragraph supply
  the quantifiers, open status, and numerical lead.
- `R_FINITE_ORBIT_PREFIX` is retired because no bounded orbit prefix proves the
  required infinite quantifier.
- `R_PURE_CUBIC_4_16` is retired.  The reported vector
  `(1,cuberoot(4),cuberoot(16))` lies in `Q(cuberoot(2))`; the polynomial
  `T^3-2` has discriminant `-108`, so this field has only one real embedding.
  The displayed last two coordinates also exceed one, and the cited claim is
  numerical.  It is not an admissible counterexample.  The exact discriminant
  operation and its complete typed record are in
  `research/jacobian/pure-cubic-discriminant.evidence.json`.
