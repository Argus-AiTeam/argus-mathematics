# Statement fidelity: finite occurrence-to-stage verification

`Main.lean` uses Lean 4.31.0 and Mathlib. All declarations are in namespace
`OccurrenceEntropy`. This document describes the encoded statements, not an
assertion that the entire manuscript has been formalized.

## Coordinate encoding and arbitrary stage projections

`root_code_bound` quantifies over finite types `V` of letter positions and `A`
of letters; a finite set `F` of complete assignments `V -> A`; sets `root` and
`seed` of positions; a finite dictionary `D` of assignments on `root`; a
natural-valued rank; a parent position; and a letter transformation at every
position. `root` is contained in `seed`. Outside `seed`, the parent has strictly
smaller rank and every assignment in `F` satisfies the stated parent-letter
equation. The restriction of every member of `F` to `root` belongs to `D`.
The conclusion is

`|F| <= |D| * |A|^(|seed \ root|)`.

No cardinality bound on `F` or extension fibers is assumed. The proof constructs
an injective code and proves its injectivity by strong induction on rank.
`projection_code_bound` gives the same bound on the image of `F` under **any**
map, with any decidable-equality target type. In particular, a map may forget
the whole root block. `acyclic_code_bound` specializes to an empty root.

For a rooted spanning tree of block comparisons, `V` is the disjoint union of
the actual block positions, `root` is the entire root block, and `seed` adds
the uncovered positions of each child comparison. Rank is tree depth; parent
is the compared position in the preceding block; the transformation is
identity or inverse. Establishing these data from interval comparisons is the
finite construction in the report, not a Lean theorem about graph libraries.

## Self-links and actual occurrence matching

`translation_self_bound` quantifies over every length `h`, positive integer
shift `t`, target subset of `Fin h` all of whose positions are at least `t`,
and finite family of words satisfying equality with the position `t` places
earlier. Its bound is `|A|^(h-|target|)`. The target subset need not be an
interval. Negative shifts are represented by reversing the direction of each
equality. Thus the formal statement does not silently allow zero shift.

`nearly_full_reflection_impossible` quantifies over a letter map `inv` with
no fixed point, a word `w : Nat -> A`, and natural numbers `h,l,k,a`. The
domain is `[l,l+k)`, contained in `[0,h)`; its reflected image under
`i -> a-i` is also in `[0,h)`. The latter is expressed by
`l+k-1 <= a` and `a-l < h`. The domain length satisfies `h < 2*k`.
The word has no adjacent inverse letters on `[0,h)` and satisfies the inverse
reflection equations on the domain. The conclusion is `False`. The hypotheses
imply a nonempty domain, so natural subtraction is not hiding an empty or
negative-index case. On reindexing manuscript half-integers by `i+1/2`,
the manuscript reflection parameter becomes `a+1`. The proof checks both
parities explicitly. Involutivity is not needed for this stronger statement.

`occurrence_balance` uses an actual finite occurrence type `O`, an owner-block
map, a matched subset, and a partner map. On matched occurrences the partner
stays matched, is involutive, and has a different owner. For **every** block
`r`, the theorem proves

`2 * |owner^-1(r)| <= |O| + |unmatched|`.

Repeated occurrences, parallel links, and isolated blocks are permitted.
This is not a hypothesis restating the desired multiplicity inequality.

## Squared mass and the exponent

`squared_mass_bin_bound` quantifies over any nonnegative real weight on a
finite word type. A finite dictionary's weights are all at least `c >= 0`,
and the full squared-weight sum is at most `Q`. It proves
`|dictionary| * c^2 <= Q`.

`projected_moment_bound` combines this fact with the coordinate construction.
It assumes only the actual rank-decreasing equations, a squared-weight bound
on all root words, and a lower weight cutoff on the root words of feasible
assignments. For any projection it proves

`|projection(F)| * c^2 <= Q * |A|^(|seed \ root|)`.

In particular it does not assume the manuscript's stage-label count, and it
does not require the root to remain in the projection.

`component_exponent` is the real-algebra inequality for arbitrary nonnegative
multiplicities `m`, costs `d`, a minimum-cost block `r`, and real `z,b,delta,upper`.
It assumes `delta >= 0`, `b >= 0`, `delta/2 <= d_i <= upper`,
`d_r <= d_i`, and `2*z <= sum m_i + b`. Its conclusion is

`-sum(m_i*d_i) + 2*z*d_r - delta*z
 <= -(delta/2)*sum m_i + upper*b`.

Here formal `delta` is manuscript `delta*s`, and formal `upper` is `a0*s`.
`self_component_exponent` proves the corresponding negative-cost bound for a
self-linked component. These two algebra statements alone would not verify
the mechanism.

`matched_component_exponent` supplies the missing connection: it takes the
actual occurrence matching above, defines all multiplicities by owner-fiber
cardinalities, proves their sum is `|O|`, obtains the balance from the partner
involution, and concludes the exponent inequality with unmatched cardinality.
Its `rmax` may be any block; choosing a maximum-multiplicity block gives the
stage count used in the report. Minimum-cost and maximum-multiplicity blocks
need not be the same.

`uniform_epsilon_budget` is the real error-budget implication for
`epsilon <= delta/(16*(1+a))`, `b <= epsilon*H`, and
`error <= delta*H/8`, with `delta>0`, `a,H>=0`.
`log129_lt_five` proves the exact inequality needed to take `a0=5` for the
manuscript's positive turn weights; its exponential comparison uses the exact
rational inequality `(21/20)^100 > 129`.
`manuscript_epsilon_budget` verifies the resulting constants
`delta=1/600`, `epsilon=1/57600`, and total error at most `H/4800`.

## What remains a human mathematical obligation

The report constructs the ordered coordinate system from each actual link
tree, combines the component bounds over the multiplicity filtration, and
controls the explicit error terms as `L -> infinity` for fixed `K,C,I`.
Those constructions, asymptotic limits, bin logarithms, and the graph-embedding
expectation bound are not encoded as one Lean theorem. The Lean source does
not formalize the random matching distribution, planar localization, cone
surgery, torsion-freeness, or the existence of nonzero group-ring factors.
The finite Python sweep is separate executable evidence, not a proof of
universal quantifiers. Independent Reviewer confirmation of this reading and
of the report is still required.
