# Statement fidelity: V_HYPERGRAPH_CAPTURE

The declaration `HypergraphCapture.hypergraph_capture` formalizes exactly
`lem:capture` in the staged October 5, 2026 hypergraph manuscript's
`build/restriction.tex`. This is a universal finite combinatorial theorem,
not a claim about a tested range and not a formalization of the full
influence or sharp-threshold theorem.

## Objects and quantifiers

`n`, `r`, and `m` range over all natural numbers, with hypotheses
`3 <= r`, `r <= n`, `1 <= m`, and `m <= n`. The vertex type is `Fin n`;
the bijection `i -> i+1` identifies it with the manuscript's `[n]`.
`k` is an arbitrary positive **real number**, not a natural or rational.
`S : Finset (Finset (Fin n))` is a nonempty finite set of finite vertex
sets. The hypothesis `forall e in S, e.card = r` makes it an arbitrary
simple `r`-uniform support: finsets exclude repeated vertices and repeated
edges. No vertex symmetry, graph property, Fourier coefficients, degree
witness, or capture conclusion is assumed.

The real expression
`(k / (r : Real)) ^ ((r : Real) / ((r : Real) - 1))` is the manuscript's
`L = (k/r)^alpha`, with `alpha = r/(r-1)`. It uses real exponentiation.
The support-size hypothesis is `(S.card : Real) <= L`, and the block
hypothesis is `(r : Real)*L*((m : Real)-1)/((n : Real)-1) <= 1/2`.
These are real subtractions; the sample size may equal one.

## Sampling and conclusion

`blocks n m` is `Finset.univ.powersetCard m`, the set of **all**
`m`-element vertex subsets. `captured S B` filters `S` by
`(e intersect B).Nonempty`. Since every `e in S` is an `r`-edge, this is
exactly `S intersect F_B`, for `F_B` the full set of edges meeting `B`.
It does not mean only crossing edges, only internal edges, or a single edge.

`goodBlocks m k S` filters this sample space by
`1 <= (captured S B).card` and `((captured S B).card : Real) <= k`.
The theorem concludes

`(m : Real)/(2*n) <= (goodBlocks m k S).card / (blocks n m).card`.

The denominator is positive under `m <= n`, as proved in
`uniform_isolation`. Thus the right side is the event probability under
the uniform fixed-size sampling law, not under independent Bernoulli
vertex sampling. Literal real comparison preserves noninteger cutoffs.

## Load-bearing declarations

`support_bounds` proves `|S| <= |V|^r` and `|V| <= r*|S|` from
simplicity and uniformity, where `vertices S` is the union `V`.
`degree_sum` proves the incidence identity `sum_(u in V) d(u) = r*|S|`.
`real_cutoff` proves `r*s <= k*v` from `0<s`, `s<=v^r`, and `s<=L`.
It explicitly applies monotonicity of real powers with exponents `1/r`
and `(r-1)/r`, proves their product/exponent identities with positive
bases, and never replaces `L` by an integer-power surrogate.
`low_degree_vertex` uses this bound and the incidence identity to
**derive** `exists u in V, 1<=d(u) and (d(u):Real)<=k`.

`containing_card`, `pair_card`, and `pair_incidence` derive the singleton
and pair counts in the fixed-size sample space. `pairCount n 1 = 0`
is proved rather than using the invalid formula
`choose(n-2,m-2)` at `m=1`.
`isolation_count` proves a finite union bound.
`uniform_isolation` then proves the stronger intermediate inequality

`Pr(B intersect V = {u}) >= (m/n)*(1-(|V|-1)*(m-1)/(n-1))`

for all `n>=2`, `1<=m<=n`, and every `u in V`.
`captured_at_isolated` identifies the retained support cardinality with
`degree S u`. These lemmas, plus the original cutoff hypothesis, prove
`hypergraph_capture`.

## Boundary cases and trust

There is no hidden assumption `m>=2`, `m>=r+1`, `n>r`, or `k>=1`;
`m=1`, `n=r`, and noninteger real `k` are included in the universal
statement. `HypergraphCapture.empty_support_range` additionally proves
that `L<1` and `|S|<=L` force `S` to be empty, so the manuscript's
nonempty-support quantifier is vacuous in that range.

Both named conclusions have their axiom dependencies printed by the
source. The permitted standard Lean axioms are `propext`,
`Classical.choice`, and `Quot.sound`; no extra mathematical axiom or
proof placeholder is introduced. Mathlib supplies checked finite-set,
binomial, ordered-field, and real-power theorems. There is no unproved
external literature premise. The compiler checks the encoded theorem;
the manuscript-to-definition correspondence in this document still
requires independent human/Reviewer inspection.
