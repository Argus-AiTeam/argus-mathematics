# Exact transport of oriented barrier partitions

## Scope and source

This work addresses only the deterministic implication inside
`lem:am-partition-coupling`, not the existence or probability of the coupling.
The source is the staged September 23, 2026 manuscript, `build/sections/amenability.tex`,
especially the subsection beginning at line 507, and `geometry.tex`.
Its tested assertions are:

> We prove the required equality deterministically on it.

and

> Thus active barriers inside $U$ translate exactly to the active barriers
> inside $V$ in every case.

The antecedent is success of BOTH field samples and transport of BOTH bits at
EVERY flagged site in EACH direction. Checking finitely many bits is not that
antecedent. Boolean polygons identify descriptions differing on finitely many
allowable segments; equality here is not equality of chosen boundary point sets.

The primary-source inputs are as follows.

* `geometry.tex`, `eq:four-forms`, defines the four forms over
  `O = Z[tau]`, with `tau = (1 + sqrt(5))/2` and `lambda = tau^a > 1`.
* `geometry.tex`, `lem:arithmetic`, supplies a common denominator for
  intersections and lattice finiteness. These elementary inputs will be
  proved directly below, rather than extending a claim about a fixed search.
* `geometry.tex`, Boolean polygons and translation tables, supplies the
  boundary quotient and finite chart model, including track labels.
* `amenability.tex`, `eq:am-core-equations` through the partition algorithm,
  defines forced marks, support, activation, and incoming versus outgoing
  square endpoints.
* `prop:am-field-covariance` is an OPEN input to the probabilistic coupling
  lemma. Nothing in the deterministic proof verifies that proposition or
  `lem:am-estimates`.

The rejected shortcut is that the rank-two translation group makes its full
group amenable. Elek--Monod, *On the topological full group of a minimal
Cantor Z^2-system*, Theorem 1, gives a free minimal Cantor Z^2-action whose
topological full group contains a nonabelian free group
(`arxiv:1201.0257v2`; published DOI `10.1090/S0002-9939-2013-11654-0`).
That is a known result, not a counterexample to this particular manuscript.
No novelty or publishable-campaign completion is claimed merely from
recovering the manuscript's deterministic implication.

## Uniform verification theorem

Let a finite union of labelled unit squares carry a bijective finite
piecewise translation. Refine its source and image pieces into open convex
polygonal charts, modulo their boundaries. Their edges and the square edges
belong to finitely many pairwise nonparallel direction families. In each
family fix an orientation and a transverse flag vector.

On every candidate line subdivide its square segment at its geometric
endpoints and at its marked interior sites. Activate a closed subdivision
interval using ONLY the bit at its initial endpoint; include every square
edge. Assume the following conditions for two samples.

1. The sets of marked sites on the bounded line segments are finite.
2. Both samples mark all transverse chart and square crossings needed in
   comparing a candidate line and its chartwise translate. An outgoing square
   endpoint need only be supplied geometrically.
3. Every source and image chart edge is a full barrier in both samples.
4. Both bits are transported on every flagged site by the given exchange.
5. Candidate lines absent on just one side of a chartwise comparison are
   inactive on the side where they are present.

Then every Boolean cell is chart-contained and the output Boolean partitions
are exactly transported, including their track labels. The assertion is
uniform over all finite chart systems, all finite subdivisions, all field
values satisfying these hypotheses, and every concurrency of chart edges.

For the manuscript, conditions 1--3 and 5 are consequences of success and the
specified core and cutoff, not additional probabilistic assumptions. The
proof below will verify that implication, including the flag convention.
The theorem also applies to other finite direction systems and other
candidate cutoffs with the same endpoint and inactivity conditions.

## Proof

### Arithmetic and finite subdivisions

For the four forms, the six pair determinants are
`1, 1, -lambda, lambda, -1, lambda^2 - 1`, in the order
`(1,2), (1,3), (1,4), (2,3), (2,4), (3,4)`.
They are nonzero for `lambda > 1`. The element `lambda` is a unit of `O`.
For `d = lambda^2 - 1`, its norm is a nonzero integer, and
`1/d = conjugate(d)/Norm(d)`. Thus `D = abs(Norm(d))` clears every
intersection denominator. Translation by `O^2` preserves `D^-1 O^2`.
For `z = (r + s*tau)/D`, bounds on both embeddings bound
`s = D*(z - conjugate(z))/sqrt(5)` and then the integer `r`.
There are finitely many such pairs. Applied coordinatewise, this proves
the needed lattice finiteness without an external theorem.

Fix the finite chart data. Each intersection of a line with
`abs(conjugate(c)) <= 4*N + Q` and a nonparallel chart-edge supporting
line has conjugate coordinate
`A^-1*(conjugate(c),conjugate(b))`. There are finitely many inverse
matrices, and the finitely many `conjugate(b)` are fixed. Their norms
give a fixed `R0` valid for every sufficiently large `N`. Square edges
are included, and passing to their flagged representatives adds only a
bounded integer correction. Enlarge `R0` for that correction. This is
a uniform linear bound, not a test of selected intersections.

Success forces the first bit to be one at every such core site and
zero wherever `abs(conjugate(z)) >= R1*N`. Every candidate has only
finitely many first marks by the preceding integer-coefficient bound.
Its incoming square endpoint is a core site whose positive tangent
flag enters the square. Its outgoing endpoint is supplied geometrically;
no bit at a different square representative is used to start the
preceding interval.

### Full chart barriers

For sufficiently large `N`, every fixed chart-edge level `b` satisfies
`abs(conjugate(b)) <= N` and is a candidate whenever its line meets
the square interior. Every subdivision start is either an interior
first mark with `abs(conjugate(z)) < R1*N`, or the incoming core
endpoint. The second signal is three at each such start on this
line, so success forces its activation bit to one. The final square
endpoint closes the last interval. The whole square segment is a
barrier. Square edges are barriers independently of the fields.
Apply this to BOTH the source and image chart data in BOTH samples.
All components therefore stay in individual open source, respectively
image, charts, modulo the boundary quotient.

### Local oriented-interval lemma

Here is the uniform combinatorial argument, proved in Lean as
`PartitionTransport.barrier_transport`.
Let `M,M'` be any two subsets of a linearly ordered set with endpoints
`a < b` in both sets. Suppose they agree on `[a,b]`, and the two
initial-endpoint activation predicates agree on `[a,b)`. Then their
barrier sets agree at every `x` with `a < x < b`, regardless of ANY
data outside the chart or of the activation bit at `b`.

Indeed, if a consecutive marked interval `[p,q]` contains such an `x`,
then `a <= p` and `q <= b`. Otherwise `a` or `b` would be a marked
point strictly between `p` and `q`. In particular `p < b`. The
agreement of marked sets on `[a,b]` transfers both endpoints and the
absence of intervening marks; the agreement of activation at `p`
transfers the barrier. Interchanging the sets proves equivalence.
This proof also covers `x` equal to an interior marked point.
There is no assumption that barrier crossings with OTHER candidates
are marked.

### Flags, vertices, and chartwise transport

Fix a source chart `U` translated by `u` onto an image chart `V`,
and a line `L` meeting `U`. If both `L` and `L+u` are candidates,
use the SAME oriented parameter on the two lines, pulled back by
translation. Convexity makes `L cap U` one open interval `(a,b)`.
Each endpoint lies on some nonparallel chart or square edge unless
the whole line lies in a boundary, in which case it does not meet
`U` and there is nothing to compare. The core forces the endpoints
as marks on each side, or they are already geometric square endpoints.
These are forced independently, not inferred from transport of their
outgoing flags.

Every strictly interior marked point is transported in BOTH directions
by the first-bit identity: its flag is in `U`, and the image flag is
in `V`. Together with the forced endpoints this gives agreement of
the closed-interval marked sets. The same field identity gives
activation agreement at each interior start. At the initial endpoint,
the positive tangent flag also selects `U`. To see this even at a
concurrent vertex, write each chart inequality along the line as
`d + t*s > 0`. At the endpoint `d >= 0`; if `d = 0`, entering the
open chart implies `s > 0`. Therefore the lexicographic flag is
positive for EVERY defining inequality. Apply this one inequality at
a time, with no bound on the number of concurrent edges. This is the
content of `tangent_flag_of_entry`. The transverse vector cannot
reverse any of these signs. If `d = s = 0`, the line is in that
boundary and cannot enter this open chart.

For the formal lemma, extend the activation predicate by false at
non-sites. Every actual initial endpoint is a site with the entering
representative; the outgoing square endpoint is not queried for the
preceding interval. The lattice is translation
invariant, so the extension agrees on non-sites as well. This supplies
the formal lemma's pointwise predicate hypothesis on the whole real
parameter interval without adding any untransported bits.

At the terminal endpoint, the positive tangent flag may select a
different chart, track, translation, or square representative. The
local lemma needs no activation identity there. It only needs the
independently forced geometric endpoint. Thus the original global
subdivision is not refined retrospectively after reading an
activation bit. The local lemma now proves exact equality of the
barriers inside `U` and `V`.

Parallel noncoincident edges introduce no crossing. A line coincident
with a chart edge is already part of a full chart barrier and has
empty intersection with that open chart. A line touching a vertex
without entering the chart likewise contributes nothing there.
Intersections of several active barriers INSIDE a chart are carried
by equality of their sets; they require no separate marking rule.
Square seam corrections are already among the chart translations.
At an incoming square corner the same inequality argument selects
the entering representative. The destination track is the track of
`V`; no argument suppresses track labels.

### Candidate mismatches

Write `c' = c + ell_j(u)` and
`abs(conjugate(c') - conjugate(c)) <= Q`.
If the source line is a candidate but its image is not, its image
still meets the open chart `V`, so absence cannot be due to missing
the square. It must have `abs(conjugate(c')) > 4*N`. For `N > Q`,
the triangle inequality gives

`abs(conjugate(c)) > 4*N - Q > 3*N`.

The second signal is minus three at EVERY start on that line,
regardless of the start's conjugate norm. Success makes every such
interval inactive. `inactive_cutoff_buffer` proves this inequality
for arbitrary real inputs, not merely for the illustrative scale in
the Python certificate. Reverse the comparison for a destination-only
candidate. If neither side is a candidate neither contributes.
Hence every direction contributes exactly transported barriers
inside each chart, including the cutoff cases.

### Boolean cells

Let `B,B'` be the finite closed barrier unions. The preceding steps
give `(B cap U)+u = B' cap V`. Translation is a homeomorphism of
the open charts and therefore bijects the connected components of
their barrier complements. Full chart barriers ensure these are
precisely the global components contained in the respective charts.
The source charts and image charts partition the squares modulo
their boundaries, so all source cells and all destination cells
occur exactly once. Components have finite Boolean descriptions:
the finite arrangement of all barrier-supporting full lines refines
them into finitely many open chambers. Their descriptions can differ
from the components only on the finitely many arrangement segments,
which the algebra discards. Consequently `P' = gP` as Boolean
partitions, with track labels. This proves the theorem.

## Interpretation of the result

This is a uniform verification of the deterministic proof implication,
and a structural generalization to any finite direction system satisfying
the stated endpoint and cutoff hypotheses. It is not a new proof of
`prop:am-field-covariance`, `lem:am-estimates`, amenability, or the main
theorem. The manuscript's sufficiently-large-`a` condition is not needed
for this deterministic argument beyond nonparallel directions.
No flawed manuscript assertion has been established in this dependency,
so no manuscript `F_` refutation claim is warranted here.

The strongest prior result for this dependency in the supplied campaign
ledger was the untested working hypothesis. The advance is the uniform
argument above, with a kernel-checkable interval, flag, and cutoff core,
not an increase in a finite search bound. Geometric reduction and
statement fidelity still require the independent Host Reviewer.

## Exact replay and formal coverage

Run from the campaign root:

```bash
python3 research/partition_transport/verify.py
```

The script uses only the Python standard library. The certificate records
24 exact intersection/conjugation/denominator checks, including powers
`lambda = tau^20` and `tau^37`; 2,048 finite interval fixtures with
independently varied exterior marks and outgoing activation; 24 extreme
core-bound checks; concurrent and opposite-tangent square-corner cases;
an exact candidate-cutoff mismatch; and equality of a two-track,
35-cell polygon partition with its independently constructed destination.
All arithmetic uses rational coefficients in `Q(sqrt(5))`, with signs
decided by integer/rational squared comparisons. The small geometric
fixture uses `lambda = tau^2`; it is not asserted to satisfy the
manuscript's separate large-`a` condition, nor to be a sample of its field
law. Neither these fixtures nor their exhaustion prove the uniform theorem.
That theorem is proved above, with its universal local core checked by Lean.

Before implementing the exact geometry, the installed Jacobian 0.14.0
contracts were inspected. The discovered projective arrangement operation
`geometry.projective_line_arrangement.flats.compute` accepts rational
coefficients ONLY, so it cannot certify this quadratic-field arrangement.
It was not passed irrational coefficients or used as if it could.
The suitable atomic operation `arithmetic.real_quadratic.order.compute`
was inspected and executed once through the authorized Argus adapter.
The dedicated `jacobian_payload.json` and `jacobian_output.json` retain
the exact request and typed answer, including server version and protocol.
For the illustrative `N=8, Q=3+sqrt(5)`, it returned
`29-sqrt(5) > 24`, with adapter exit zero and no timeout/error.
This is one supporting computation, not an arrangement solver or a proof
of the universal cutoff inequality.

The real compiler run of `Main.lean` used Lean 4.31.0 and returned
`exit_code=0`, `proof_holes=[]`, and axiom-audit exit zero. The official
`lean_evidence verify --claim C_INTERVAL` command archived its source,
statement fidelity, and result under `certificates/` and recorded mechanical
evidence in the campaign ledger. `verify.py` compares the current source
and fidelity text with that archive before accepting the certificate.
Only the universal ordered-interval, entering-flag, and cutoff lemmas
are formalized. The geometric reduction and connected-component argument
remain a mathematical prose proof requiring independent review.

`prop:am-field-covariance`, `lem:am-estimates`, the shape-matching lift,
simplicity, multiplier finiteness, the fixed-track central cover, and the
central-kernel finite-presentation deduction remain explicitly open in
`research/PROOF_GRAPH.json`. The Elek--Monod primary excerpt was obtained,
but its independent citation attribution is also left to the Host Reviewer;
the Engineer cannot self-certify that attribution. No publishability or
novelty determination, independent Reviewer approval, or campaign completion
is encoded by this deliverable.
