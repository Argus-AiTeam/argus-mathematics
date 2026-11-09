# Statement fidelity: ordered residual recovery and endpoints

`Main.lean` is a formalization of the finite combinatorial core, not a
formalization of the analytic collision proposition.

`allocations k ps` distributes the entries of an arbitrary finite list `ps`
among **k labeled slots** and multiplies each slot. Slots with no entries
have product 1. Different occurrences of an equal prime remain separate
entries in `ps`; taking a finite-set image removes duplicate resulting
factorizations. No squarefreeness or bound on k or list length is assumed.

`card_allocations_le` proves for all natural k and all lists ps that the
number of resulting ordered factorizations is at most k to the length of
ps. `allocations_sound` proves that every resulting tuple has total product
`ps.prod`. `allocations_complete` proves the converse for any list of primes:
every function from `Fin k` to the natural numbers with that total product
is present. Its proof extracts one prime occurrence from one divisible
coordinate at a time; it does not identify repeated occurrences.

`factorizations k n` uses `n.primeFactorsList`, including all multiplicities.
For **n nonzero**, `mem_factorizations_iff` proves that its members are
exactly all k-tuples of natural numbers with total product n. Their entries
are therefore positive. The nonzero hypothesis is essential: this file
does not identify the finite set with all factorizations of zero.
`ordered_factorizations_bound` bounds this finite set by
`k ^ n.primeFactorsList.length`. For nonzero n, the exponent is exactly
Omega(n). In particular n=1 and zero prime occurrences are included.

`two_residuals_bound` simultaneously bounds the **Cartesian product** of
the ordered factorizations of arbitrary n and n', in k1 and k2 slots, by
`k ^ (Omega(n)+Omega(n'))`, provided k1 <= k and k2 <= k. The formal bound is
for all natural n,n'; its interpretation as all multiplicative
factorizations is restricted to nonzero n,n' by the preceding equivalence.
For the manuscript use k=h+1. The proof in `proof.md` shows that each pair
of missing tuple tails maps injectively into the corresponding pair of
factorizations. Prime entries are recovered from their shifts by adding 1.
That source-specific injection is a prose proof, not a Lean theorem here.

`collisionPairs` counts ordered pairs of **unequal** elements of a finite
set having equal values under F. `collisionPairs_mono` proves inclusion
under restricting the tuple set. `endpoint_restriction_bound` proves the
corresponding cardinality inequality for the closed value condition
F(a) <= t. Beta can be any linearly ordered type, including the reals.
The source-specific assertion that good tuple membership is unchanged
when the endpoint moves from x to x/c (parameters still formed from x)
is proved separately in prose.

No axioms about Ford, primes in progressions, real logarithms, asymptotic
uniformity, or the manuscript's main theorem are introduced into this file.
Compilation establishes these named declarations only. Independent review
must still assess the interpretation and the analytic argument.
