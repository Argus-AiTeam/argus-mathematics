# Fidelity of the finite minimax formalization

The claim is `A_MINIMAX`. The source proves the finite-game implication
used at each value of `r` in the manuscript, in the stronger form of an
arbitrary finite real payoff matrix.

The row type `P` and column type `Q` are arbitrary finite nonempty
types. They stand for the `s`-element sampling sets and the finite
allowed list patterns, respectively. Their sizes are not fixed or
bounded by the formal theorem. The payoff `b : P -> Q -> Real` is
arbitrary; in the manuscript it is the bad-set indicator.

`stdSimplex Real P` and `stdSimplex Real Q` are the actual finite
probability simplices: all coordinates are nonnegative and their sum
is one. `payoff b x y` is the bilinear expected payoff under the two
mixed strategies.

The principal declaration `randomized_adversary` has hypothesis

    forall x in stdSimplex Real P,
      exists q, xi < sum p, x p * b p q.

This is exactly failure of a sampling law that bounds every pure
pattern's badness expectation by `xi`, not a statement with the two
players interchanged. Its conclusion is

    exists y in stdSimplex Real Q,
      forall p, xi < sum q, y q * b p q.

Thus one random pattern law works against **every** pure sampled set.
The conclusion is strict, and in particular implies the manuscript's
lower bound `>= xi`. There is no hidden restriction on `xi`; taking
`xi > 0` gives the application in the source.

The proof applies Mathlib's kernel-proved
`Sion.exists_isSaddlePointOn`. It proves continuity and the required
quasiconvexity/quasiconcavity of the finite bilinear payoff, and uses
the compactness, convexity, and nonemptiness of both actual
probability simplices. `payoff_single_left` and
`payoff_single_right` explicitly identify pure strategies, fixing the
orientation of the final two saddle-point inequalities.

For each `r >= s`, the manuscript's finite pattern space is nonempty
(the empty-list family is allowed), and the sampling space is
nonempty. Specializing the arbitrary finite types therefore gives
the claimed implication for every `r`. The theorem does not impose
an upper bound on the label universe or choose a pattern after the
sampled set.

There are no project-defined axioms or assumed minimax propositions.
The formerly recorded external `FINITE_MINIMAX` dependency is
discharged by this formal theorem, rather than by a self-attributed
literature citation. The source does not prove Ramsey homogenization,
countable extension, invariant cuts, or the final alignment theorem.
