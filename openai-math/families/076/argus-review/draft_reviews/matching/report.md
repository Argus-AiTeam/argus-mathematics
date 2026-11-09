# From two moments to a near-perfect matching

## Claim and external dependency

`C_PACK_MATCH@1` and v2 have the same natural statement and subject hash.
V2 explicitly attaches `PS_EDGE_COLORING`; v1's omission is not an
unconditional proof. The claim fixes the forms and positive odd slot
lengths, and as admissible `q -> infinity` asserts that deleting at most
`q^(7/8)` vertices leaves an almost-regular simple r-partite hypergraph,
degree `(1+O(q^(-1/8)))p^(r-1)q^(b-1)`, codegree at most `q^(b-2)`,
and a matching `H=(1+o(1))q/(2L)`.

The proof is in the snapshot-bound old `research/packing-audit/report.md`.
The source proposition is Pippenger--Spencer as formulated in
N. Alon and R. Yuster, *On a hypergraph matching problem*, Graphs and
Combinatorics **21** (2005), 377-384,
**doi:10.1007/s00373-005-0628-x, Lemma 2.1**.
It is a known external input, not an Argus discovery or Lean theorem.
The old reading at
`families/076/first-pass/packing-audit/literature/alon-yuster-lemma-2.1.md`
identifies the author copy
<https://web.math.princeton.edu/~nalon/PDFS/ayhyper2.pdf>, numbered page 3,
with the definition of the edge-chromatic quantity on page 2.

In the formulation used, for fixed `r>=2` and every `gamma>0` there is
a useful positive tolerance `beta` such that an r-uniform hypergraph
with all degrees strictly between `(1-beta)D` and `(1+beta)D`, and
distinct-vertex codegrees below `beta D`, has an edge partition into
at most `(1+gamma)D` matchings. The archived transcription says
"a real beta" rather than explicitly "beta>0"; its useful positive
tolerance is the stated standard interpretation, not a stronger result
proved by this review. A nonpositive tolerance would make that printed
existential formulation vacuous for positive `D`. This wording caveat
must remain visible. No large-`D` threshold is printed in that excerpt;
the application has `D -> infinity` in any event.

The old independent source reader and `reviewer:65ff03c5a5e8` both
supported the exact assumption binding. The same reviewer supported
matching in `judgement-C_PACK_MATCH-65a2b667d328`. These are
human judgements. The source note's official literature-archive limitation
was **not** erased by them: old evidence rows are `judgement`, not
`literature`. No official citation-attribution archive was created in
this review outside its owned paths, and no new primary-source reading
is falsely claimed. The present assessment retains the stated external
input, with its source and wording caveat, rather than independently
proving or discharging it.

## Decisive moment-to-degree argument

Put `A=r-1`, `t=p^A>0` and `D_q=t q^(b-1)`. The first two raw
moment errors imply, by expanding the square rather than equating a
raw second moment with variance,

    E[(Z-t)^2 | V] <= delta_2 + 2t delta_1
                    <= (32LA+18A^2)/sqrt(q).

Here `R>=sqrt(q)/2`, `K<=sqrt(q)+1` give
`delta_u <= (8Lk+3k^2)/sqrt(q)`. Conditional Markov/Chebyshev
at threshold `t q^(-1/8)` gives conditional outlier probability at
most `(32LA+18A^2)t^(-2)q^(-1/4)`.

The actual deletion event also requires the center to be present, so
unconditional outlier probability is no larger. Zero-probability
conditioning events contribute no vertices. Each signed relation
contributes at most `2R+1` exceptional centers; hence
`|E_i|<=2 binom(A,2)(2R+1)`. Summing the outliers and exceptions
over at most `r(q-1)` candidates gives expected deletions at most

    r((32LA+18A^2)/t^2 + 6 binom(A,2)) q^(3/4).

For all sufficiently large admissible primes this is below `q^(7/8)`,
so at least one slot realization needs fewer than that many deletions.
No separate concentration of the total vertex count is needed: the
number of retained slots of each type is deterministically
`q/(2L)+O(K)`, since each chunk's shift changes it by bounded error
and each slot gets exactly one orientation.

## Multiplicity, deletion and edge coloring

Edges are distinct compatible center tuples, not generating vectors
with multiplicity. A rank-b form matrix has `q^(m-b)` preimages
for every compatible tuple. Dividing the constrained vector counts
by that multiplicity gives

    degree(i,s)=q^(b-1)Z_i,s.

Two types fix two independent equations, so their codegree is at
most `q^(m-2)/q^(m-b)=q^(b-2)`; same-type codegrees vanish.
This handles `b<m` and `r>m` and is why treating the generators as
distinct edges would be wrong.

Deleting fewer than `q^(7/8)` vertices removes at most
`q^(7/8)q^(b-2)` incident edges from any surviving vertex.
Its retained degree therefore lies between

    (1-(1+t^(-1))q^(-1/8))D_q and (1+q^(-1/8))D_q,

and relative codegree is at most `1/(tq)`. All errors vanish with
fixed input data, and `D_q -> infinity` since `b>=2`. The strict
tolerances of the external theorem are eventually satisfied for
each fixed `gamma`.

Summing degrees and dividing by at most `(1+gamma)D_q` color
classes yields a matching of size at least
`(1-o(1))|V|/[r(1+gamma)]`. Use the **maximum** matching size
and then take the lower limit for every fixed `gamma>0`;
do not interchange a q-dependent tolerance without justification.
The per-type vertex upper bound supplies the matching upper bound,
giving `H=(1+o(1))q/(2L)`.

## Assessment and limits

The reduction is supported conditional on the explicit edge-coloring
input, including its useful-positive-tolerance interpretation.
It reproduces the manuscript's matching strategy with explicit
error/deletion accounting; no new matching theorem or publication
novelty is established. `verify.py` checks relevant finite counts,
rank-below-ambient fixtures and one small two-edge construction, but
does not run or certify a general Pippenger--Spencer algorithm.
The asymptotic matching argument remains prose and is not covered
by the archived Lean certificate. Stale graph labels do not erase
the bound old independent judgement, and that judgement is not
acceptance of the present review.
