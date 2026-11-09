# Statement fidelity: symmetric-memory restoration core

The Lean source is `Main.lean`, namespace `MemoryStability`, for claim
`C_MS_FORMAL_CORE`. It formalizes the following quantified algebraic core of
the proof in `restoration.md`. It does not formalize the full conditional
operator theorem or any prime-distribution theorem.

## Objects and quantifiers

`choice_sum_equivariant` quantifies over arbitrary state types X,Y, a finite
choice type I, a state transformation g, a bijection e of choices, complex
weights and choice multipliers, a target-state map, and a complex test
function. Its hypotheses say that the weight, multiplier, and tested target
are unchanged when g and e are applied together. Its conclusion is equality
of the two complete choice sums. Invalid choices may have zero weight, so a
single finite choice type can encode a truncated ghost or edge formula.
This certifies the reindexing argument; it does not itself construct the
permutation bijections for the manuscript's deletion and promotion sets.
Those constructions are proved in Sections 1-3 of `restoration.md`.

`reindex` is the bijection x -> x composed with s on tuples Fin n -> Z, for
an arbitrary permutation s of Fin n. No injectivity of the tuple x is
assumed. This is why numerical repetitions and permutation stabilizers
are included, rather than silently excluded.

`density` is the product over all n coordinates of arbitrary complex
masses nu(x_i). `density_reindex` proves its permutation invariance.
Positivity is not needed for this identity; positive real masses are a
special case of the complex statement.

`batch_integral_reindex` quantifies over all n, all finite particle types Z,
all product masses nu, arbitrary complex multipliers phi, and test functions
f invariant under every tuple permutation. It says that replacing phi by
phi composed with any fixed permutation leaves the full weighted tuple sum
unchanged. The n=0 case and tuples with repetitions are included.

`batchAverage` averages over the whole permutation group, dividing by its
cardinality, not by the size of the tuple's orbit. `birth_batch_averaging`
says that inserting this average leaves the same weighted sum unchanged
under exactly the symmetry hypothesis above. Multiplying both sides by the
existing scalar 1/n! therefore preserves the manuscript's ghost integral
without inserting a second transition-counting factorial.

`bounded_average` says that a finite nonempty average of complex numbers
of norm at most one again has norm at most one. `batchAverage_bounded`
specializes this to every ordered batch and every batch length, without
requiring Z to be finite for the pointwise norm bound.

## Factorial measures

`ghost_factorial` is the identity

    choose(k+t,t)/(k+t)! = 1/(k! t!)

in every characteristic-zero field for all natural k,t.
`ghost_joint_swap` quantifies over all natural survivor, deleted and born
multiplicities k,t,b and every nu in that field, and proves equality of the
two source-measure times
deletion-count times birth-measure factors. This is the coordinatewise
factor in formula (4) of `restoration.md`. In particular no multiplicity
is restricted to zero or one. Multiplying these scalar identities over
all residue coordinates gives the finite occupancy-vector identity; that
product step and the ghost signs/coefficients are written in prose, not
encoded as a complete ghost operator in Lean.

`edge_factorial` states descendingFactorial(k+a,a)/(k+a)! = 1/k! for all
natural k,a, in every characteristic-zero field. Thus both factorial
identities include irrational real tilted masses, not just rational models.
Applying the edge identity for both a and b gives
the ordered-promotion/ordered-store reversal identity. The residue
translation, active-coordinate product measures, factor V^(b-a), and the
actual edge kernel are not defined in Lean. They are checked algebraically
in the prose and on exact finite matrices by `verify.py`.

## Rank-dependent loss

`fresh_block_atom_bound` quantifies over every finite label type P, every
nonnegative real mass function nu bounded pointwise by delta, and every
natural r. It proves

    sum_p nu(p)^(r+1) <= (sum_p nu(p)) delta^r.

This is the exact common-value mass of a block of r+1 fresh integrations,
including multiple coordinates born within one batch. The full
chronological conditioning argument for a history is still a prose proof,
not encoded by this scalar block inequality.

`touched_le_twice_rank` quantifies over any finite set of blocks and natural
block sizes at least two. It proves sum(size) <= 2 sum(size-1). Disjointness
and assignment of addresses to operations are not its hypotheses; the
prose uses them to turn this count into a bound on affected edges.

`rank_loss` quantifies over all natural N,r,affected with
affected <= N and affected <= 2r, and real norm upper bounds 0<S<=K.
It proves

    S^(N-affected) K^affected <= S^N (K/S)^min(N,2r).

This includes r=0, N=0, and 2r>N without a negative natural exponent.
The whole operator-norm product argument and the Fourier equality
integral are not encoded in Lean; the inequality is the exact scalar
loss used after those arguments.

## What the compiler does not certify

No axiom asserts an analytic saving. No theorem states that the raw
arbitrary-old-index formula is symmetric. No theorem asserts the three
manuscripts' conclusions or novelty. The maximal-atom conditioning
argument, partition identity, weighted Schur proof, cutoff limit and
analytic parameter specialization are proved in `restoration.md`, not
relabelled as Lean results. Independent review must read that proof and
this translation. The compiler result must have zero proof holes and
must match this document and the actual source bytes.
