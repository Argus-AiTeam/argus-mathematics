# Buffered terminal separation

## Exact question and scope

The target is `lem:buffered-witnesses` in the staged October 6, 2026
manuscript, `build/sections/03-spatial.tex:1322-1616`, not the joint
scaling-limit theorem. Fix `t in [1/2,1)`, a positive compatibility
threshold, a terminal bound, and macroscopic boxes `Q < Q' < B`.
The conditional data are a complete `(s,W)` pattern in `Q'` and allowed
exterior `(s,W)` prescriptions outside a larger buffer. Here `N` is
the selected current and `W` its exact dual complement, not the other
current. Every complementary `N` component has a free transverse color.
No transverse colors are conditioned on.

The requested conclusion is a lower bound uniform in mesh, microscopic
pattern, and enclosing flat domain for actual monochromatic `W` loops
inside `B` separating all oppositely assigned terminal marks.

The starting ledger contains no prior certified result about this lemma.
The manuscript gives a proposed proof via a minimal enclosing marked set,
full complement-of-minus explorations, a uniform rough-wall collar
estimate, and monotone replacement of temporary path alternatives.
These are obligations to check, not established inputs.

An unspecified positive constant cannot be refuted by a small probability
at one mesh. A refutation must exhibit persistent impossibility with
positive compatibility, or a family with compatibility bounded below and
local-witness probability tending to zero. A finite experiment is not a
universal theorem. Any conditional verification must explicitly retain
its analytic dependencies.

The project wiki index has no Ashkin--Teller or buffered-witness entry.
No relevant prior result was found there.

## Result submitted for independent review

The proof below verifies buffered terminal separation and strengthens its
iteration: **at most `k-1` successful localization layers suffice**, rather
than one layer per opposite pair. More generally the proof applies to a
square-lattice colored cut model with the three properties specified below.
It does not assert the manuscript's main theorem, a new scaling limit, or
verified novelty. Independent mathematical review and independent citation
attribution are still pending.

The finite certificate is complementary evidence, not a machine proof of
the uniform collar estimate. There is no Lean formalization.

## Imported propositions and identification of the law

The only non-elementary inputs are from Duminil-Copin, Kozlowski, Lammers,
and Manolescu, **arXiv:2603.06268v1**, 6 March 2026:

1. Definition 15.1, Definition 15.3, and Proposition 15.4: positive
   association in `(s,W-plus,-W-minus)` survives a positive-probability
   cylinder fixing spins and edge states, provided the fixed spins include
   every endpoint of a fixed edge.
2. Theorem 16.4 and Corollary 16.6: a circuit of either color in a buffered
   annulus has a uniformly positive probability, at lattice radius at least
   four, for `c in [1,2]`. Corollary 16.6 permits arbitrary same-parity
   spins and edges outside the buffered ball.

The source was actually obtained and the propositions, including their
hypotheses, were read. Complete extracted statements are in
`S16.counterEnvDefault4.txt`, `S16.counterEnvDefault6.txt`,
`source_model_and_fkg.txt`, and
`source_exact_model_and_lattice_events.txt`. The title's narrower range for
the GFF result is **not** the range of Theorem 16.4: that theorem explicitly
states `c in [1,2]`. A focused search found no separate source establishing
the terminal-localization or arbitrary-wall-collar assertion. That search
is not a novelty certification.

Here is the exact identification; it does not identify `W` with the other
current. On an interior edge pair the joint `(s,W,d)` factors are

```
W open:    t * 1[s endpoints agree],
W closed:  (t * 1[s disagree] + (1-t) * 1[s agree]) * 1[d agree].
```

Divide all factors by `t`. A monochromatic open edge then has factor `1`,
a monochromatic closed edge factor `(1-t)/t`, and a disagreeing closed
edge factor `1`; every closed edge requires agreement of its two `d`
spins. These are precisely Definition 14.5's factors
`c^(number of monochromatic edges) * (1/c)^(number open) *
(1-1/c)^(number monochromatic closed)`, with `c=1/t`, and its spin
constraints. Summing `d` gives `2^(number of N components)`, with isolated
vertices included. This calculation holds on every finite graph, not just
on the enumerated examples.

An open monochromatic perimeter has no factor involving transverse
spins across it. Fixing its `s` value therefore separates the product
weight on its two sides. A matching-wall chamber, including a chamber
with several boundary components, is realized by conditioning a larger
ordinary flat domain on these perimeter edges and then taking its
interior marginal. Thus the pin-FKG input applies to the actual chambers
and to their endpoint-compatible stopping cylinders, not just to regular
outer polygons.

For clarity, the unpinned-buffer circuit bound can also be transferred
without extending the source's domain convention by assertion. Inside an
unused buffer, pin a regular surrounding circuit to the color opposite
the requested one. This is unfavorable conditioning in the FKG order.
The exact cut factorization makes its sealed interior a regular flat
law, to which Theorem 16.4 applies. Removing the unfavorable pin can
only increase the requested circuit probability. Pins of the requested
color inside a buffer are favorable. A fixed finite cover and FKG give
the corresponding fixed-aspect annulus and tube bounds. All these
comparisons concern only `(s,W)`.

## A general localization theorem

**Theorem.** Consider finite square-lattice colored cut laws with these
properties, uniformly in mesh:

* Both endpoints of an open edge have the same color. Its dual complement is the graph
  whose marked connections are tested, and a matching cut has no
  transverse interaction. Replacing the removed side by matching spins
  and open edges preserves one selected accessible marginal.
* Every endpoint-compatible spin/edge pin cylinder is positively
  associated in the colored order, with the reflected assertion as well.
* Unpinned buffered circuit tests of either color have a common positive
  lower bound above a fixed lattice cutoff, conditional on arbitrary
  allowed same-parity data outside their buffers.

Fix `n <= k` marked terminals and a sign assignment, and compactly nested
boxes `Q < Q' < B` with fixed positive gaps. The marks and all initially
fixed data lie in the one-mesh closed-core convention of `Q'`. If the
assignment's compatibility probability is at least `p>0`, there is a
constant `c>0`, uniform in the microscopic pattern, mesh, and enclosing
flat domain, such that actual monochromatic loops in `B` separate every
opposite pair with probability at least `c`. For `n >= 2`, one may choose
only `n-1` intervening localization gaps; for zero or one mark the
assertion is vacuous with probability one.

The three properties hold for the manuscript's exact-complement law by
the preceding product-factor calculation and the two imported results.
The theorem therefore applies for every fixed `t in [1/2,1)`. It asserts
no uniformity as `t` tends to one.

### 1. Minimal target disks

At finite mesh, compatibility gives an actual monochromatic simple
cycle separating each required pair, possibly using part of the actual
matching outer perimeter. This is ordinary planar cut-cycle duality in
the uncontracted drawing: the matching perimeter closes the exterior
face; no abstract wire is drawn as an edge.

Fix a complete old-core pattern `g`, and call a required pair missing
if no actual loop in that core separates it. On compatibility choose a
separating loop whose enclosed marked set `I` is inclusion-minimal among
loops witnessing missing pairs. It is nonempty and proper.

No missing pair can lie wholly in its disk. Indeed let `a,b` be such a
pair and let `D` be a witness for it. If `D` is disjoint from the target
`C`, its disk must lie inside `C`: the alternatives of disjoint disks or
`D` containing `C` cannot separate `a,b`. If `D` meets `C`, their colors
agree. The finite graph formed by `C` and the portions of `D` inside
`C` separates `a,b` even in the full plane. A path leaving `C` crosses
`C`; a path staying in its disk crosses `D`. A finite planar separating
graph contains a simple separating cycle: take the boundary of the
component reachable from one marked dual vertex and remove repeated
vertices from the separating boundary walk. This cycle is contained in
the closed disk of `C` and encloses one of `a,b` but not the other.
Its marked set is a nonempty proper subset of `I`, a contradiction.
Shared edges or tangent vertices cause no exception to this graph
argument.

For each missing pair wholly outside `I`, select a witness and record
its color. Reflect the description if necessary so the target is plus.
An opposite-color witness cannot meet the target. Its disk is either
disjoint from the target disk or contains it. Record the endpoint on
the side away from the target disk.

The resulting data are a finite type: target color, `I`, and, for each
missing outside pair, either "plus" or "minus with this away endpoint."
For `k>=2` the number is at most

```
L(k) = 2 * (2^k - 2) * 3^floor(k^2/4).
```

The pair count is at most `floor(k^2/4)` because the assignment is binary.
The tie rules and the particular loop shapes are not part of the type.

### 2. Full complement-of-minus histories and exact completion

Fix a type. From its away endpoints, explore the full components of the
underlying dual graph after deleting edges crossing actual open minus
edges. Plus edges are **not** barriers for this exploration. Reveal
endpoint spins before any previously unqueried edge state. Exhaust each
component, and use deterministic queue and tie rules. At most `k`
distinct marked sources occur.

A realized transcript is exactly the cylinder of queried values.
Induction over queries proves both implications: the cylinder produces
the same next query and answer, including the final exhaustion decision;
the transcript plainly supplies those values. Thus its residual law
`mu_h` is a pin-FKG law. No event saying that the previously selected
target loop was minimal is conditioned on.

Let `F0` be the raw union of the explored dual cells, with no pockets
filled. Every interior frontier edge of a full component is an actual
open minus edge; otherwise the search would have crossed it. All queried
edge segments and endpoint spins lie in the closed source cells.
Equivalently, if a plus vertex were on this frontier, all dual cells
around it would be connected through edges not crossing minus edges,
contradicting exhaustion. This also accounts for the lattice boundary
layer.

On the selected type event, the chosen minus loops keep every source
on its away side. Hence `F0`, including its frontier, misses the closed
target disk. The other endpoint of each protected minus pair is outside
the explored component. The fixed minus frontier blocks every future
`N` path, since every `N` edge belongs to the complement-of-minus
graph. These are permanent history certificates, denoted `C(h)`.

Fix a marked `i0 in I`. In a retained history choose the component `U`
of the complement of `F0` containing it. Any proposed target disk
missing `F0` lies wholly in this same `U`. Only now fill every other
complementary pocket, obtaining `F`, the complement of this selected
accessible component on the removed side.

This is an exact **marginal** operation. Across every new interface
facing `U` the prescribed edge is open minus, so its factor is the
constant `t`, independent of the two transverse spins. The product
weight on `U`, with its existing core pins, separates from all removed
variables. Replacing the latter by minus spins and open matching edges
changes only a normalizing constant. If `U` is bounded, the remote outer
boundary can be put on the matching removed side as well; if `U` reaches
the original outer boundary, that boundary is retained.

For one connected source, `U` faces one boundary walk. Repeated entrances
are not independent wires. Filling pockets can merge source labels, not
split them. Every local filled piece connects to an original source
mark in the old core or to the outer boundary, so it is anchored in
each band window whose buffer misses those locations. Exact completion,
not a repeated density penalty per entrance, is available here.

The full residual law `mu_h` has not been changed: other actual witness
loops may lie in discarded pockets. Completion will be used only to
bound a marginal event in `U`.

### 3. Uniform anchored-collar exclusion, proved from circuit tests

We give the uniformity argument because a circuit estimate alone does
not imply it without this step. Fix a working rectangle, an intermediate
enlargement and a larger buffer. A traversal is a left-to-right dual
path with a fixed top/bottom margin. Rotate windows when necessary.
Let `F` be a prescribed matching cell region, anchored in the buffer:
each local piece meeting the intermediate rectangle has a path in `F`
to the buffer boundary. Use the exact completed law of the selected
accessible component.

Augment actual matching edges on the accessible side by the matching
one-skeleton inside `F`. This is a geometric graph, not a collection of
abstract wires. A path disjoint from `F` can cross an augmented matching
circuit only through an actual matching edge.

Let `X(delta,eta)` mean that a traversal lies within distance `eta` of
`F` while avoiding `F` and every augmented matching circuit attached to
it. Then

```
lim_(eta -> 0) limsup_(delta -> 0) sup_allowed_histories P[X(delta,eta)] = 0.    (C)
```

First, repeated separated-scale tests imply an attached-arm bound
`C*((r+delta)/R)^alpha`. A matching circuit between scales `r` and `R`
intersects every anchored piece crossing that annulus. Conditional
failure probabilities multiply after revealing earlier disjoint test
buffers; independence is not asserted. Matching pins in the completion
are favorable, so every test retains the same positive lower bound.

Trim a candidate traversal from its last left hit before its first right
hit and erase loops. It is a proper crosscut, with exactly a lower and
an upper side in the rectangle. Assign each disjoint local obstacle
piece to that side; include top and bottom as virtual barriers.

Here is a uniform finite reduction of these assignments. In a fixed
left end strip choose one proper left-to-right representative arm for
each distinct obstacle piece reaching the central rectangle from that
side. Arms are chosen deterministically and ordered bottom to top.
Pieces reaching top or bottom already have their fixed barrier
assignment. Additional entrances of a piece only impose consistency.
Do the same at the other sides as needed.

For consecutive representative arms let `g_j(x)` be their topmost
height gap on a fixed middle horizontal interval of length `ell`.
Disjoint proper crosscuts are ordered even if they are not graphs:
the upper crosscut separates the lower one from the top of the strip.
Consequently their topmost heights are ordered. Put
`d_j = integral(g_j)/ell`. Then `sum_j d_j <= H`, the strip height,
and on a subset of length at least `ell/2` their gap is at most `2*d_j`.
The resolved lattice convention gives `d_j >= a*delta`.

Put `h_j=d_j+delta`, so `h_j <= beta*d_j`. If `d_j` is small,
pack at least `c/d_j` horizontally separated annular tests centered
between such close arm encounters. Their inner and outer radii are
fixed large multiples of `h_j`, above the lattice cutoff; their doubled
buffers are disjoint and stay in the larger window. Both proper arms
meet the inner disk and leave the outer disk. Every successful matching
circuit joins the two arms geometrically. In fact the arc from the last
lower-arm hit before a first upper-arm hit lies in the middle component
between the two proper arms, hence in the end strip. A traversal with
opposite assignments cannot avoid this joining arc.

Thus the probability that a given gap can carry an assignment change is
at most `C*exp(-c/d_j)`. Uniformly in the number of pieces,

```
sum_(d_j <= u) C*exp(-c/d_j)
 <= C*H*sup_(0<d<=u) exp(-c/d)/d  -> 0.
```

There are at most `H/u` remaining gaps. Along one side the traversal's
endpoint position gives a single rank among the ordered representative
arms; its assignments cannot alternate along that side. After excluding
the small-gap error, only finitely many rank vectors remain, uniformly
in the mesh and the number of source fingers. Connections between sides
can forbid a vector, but cannot create extra choices.

Suppose (C) fails. Choose deterministic allowed histories with
`delta_l -> 0`, `eta_l -> 0`, and traversal probability at least
`epsilon>0`. Fix `u` so the preceding small-gap error is less than
`epsilon/4`; pass to a subsequence and one rank vector of fixed positive
event mass. **Do not condition on that event.** The lower- and
upper-assigned closed obstacle unions, including virtual barriers,
are deterministic. In a central compact rectangle pass to Hausdorff
limits. Compactness here follows by successively taking subsequences
on finite finer grids.

If the limits touch at an interior point, deterministic oppositely
assigned pieces approach within `r_l -> 0`. Anchoring makes both cross
annuli from scale `r_l+O(delta_l)` to a fixed outer scale. An attached
matching circuit joins them and blocks the crosscut. The attached-arm
bound sends the retained event's probability to zero. A virtual barrier
cannot cause an exception: the fixed traversal margin precludes an
oppositely assigned piece approaching that barrier in the central test.

Otherwise the two limits are disjoint there. On a central vertical line
choose consecutive lower and upper encounters `a,b`; such a transition
exists because of the virtual bottom and top. The open segment between
them avoids the entire limiting obstacle union. Fix an integer `m`.
At each actual endpoint choose `m` separated circuit radii, all below
`|a-b|/8` and the buffer clearance; call the smallest `r_m>0`.
Only after that choice trim the segment by less than `r_m/2` at its
ends, obtaining a compact segment `J_m`.

The whole `J_m` has positive distance from the limiting obstacle union,
and therefore from `F_l` for large `l`. It lies outside the shrinking
collar. At discrete points tending to either actual endpoint, a
successful attached circuit at any of the chosen radii meets both that
endpoint's anchored obstacle and `J_m`: the latter starts inside its
inner disk and extends beyond its outer disk. A virtual endpoint uses a
short connector in the forbidden traversal margin instead.

Successes at the two actual endpoints, joined by `J_m`, produce a
lower-to-upper connected obstruction inside the rectangle. A proper
left-to-right crosscut must meet it. It cannot meet the obstacles or
their attached circuits by definition, or `J_m` by the collar condition.
The retained event is therefore contained in the failure of one of
these endpoint tests, with probability at most `2*C*(1-rho)^m`.
Take first the large-mesh-index limit and then `m -> infinity`.
This contradicts its positive mass and proves (C).

A fixed finite family of such rectangles detects every full traversal
of a prescribed annular band: cover it by smaller rectangles and stop
on the first exit from a fixed enlargement. Hence (C) also applies to
band crossings. Its uniform double limit gives a fixed `eta>0` and a
single sufficiently-small-mesh threshold for any requested error.

Finally the assertion is simultaneous over all closed target disks
bounded by an actual opposite-color loop and missing `F`. A connected
matching circuit attached to `F` cannot enter any such disk: its
artificial part is outside, and its actual matching part cannot cross
or share a vertex with the opposite-color boundary. Every underlying
dual path inside the disk automatically avoids all these attached
circuits. No union bound over target disks is needed.

### 4. A one-step positive localization bound

Assume under the original law conditional only on the complete old-core
pattern `g` that compatibility has probability at least `a>0`, and some
pair is missing. One finite type `T` has probability at least
`a/L(k)`. Fix that type but do not condition the sampling law on it.
Run its source exploration as above and let `nu_g` be the transcript
law.

For a fixed transcript define `U_h` to be the event of an actual plus
target loop enclosing exactly `I`, with closed disk missing `F0`,
together with actual plus witnesses for all specified outside pairs
of plus type. Minimality and the original loop choices are dropped.
Existence of a loop with a fixed geometric enclosed set is increasing;
it imposes no negative spin conditions on the rest of the configuration.
Thus `U_h` is increasing in the full residual pin law.

The type event implies `C(h)` and `U_h`, so

```
integral 1[C(h)] * mu_h(U_h) d nu_g(h) >= a/L(k).
```

Put `b=a/(2*L(k))`. Histories with `C(h)` and `mu_h(U_h)>=b`
have `nu_g` mass at least `b`: outside them the displayed integrand is
at most `b`, and everywhere it is at most one. No FKG is applied to
the law conditioned on this retained family.

Fix one such history. Apply (C) in its selected component to make the
probability of an underlying full band crossing in the `eta`-collar at
most `b/2`. The width and mesh threshold are uniform in histories.
In the full `mu_h` law subtract this marginal error from `U_h`; do not
condition on its absence.

Take an enlarged core `K`, its middle band `A`, and a wider band `A+`
strictly between old and new cores. Fix a regular outer underlying dual
graph `R` containing `K` with a complete connected shell outside `K`.
Every edge of this graph is available in the following path tests,
regardless of its `N` or `W` state.

For every required pair across `I`, orient every simple underlying path
from its `I` endpoint. Require either that it crosses an actual plus edge
in `K`, or that it has a full inner-to-outer band subpath visiting a point
at distance greater than `eta` from `F`. Intersect these requirements
with the specified actual outside plus witnesses and call the event `V_h`.
The path family and `F` are fixed; only the first alternative can improve
with plus edges. In particular **minus edges and artificial fill are not
barriers in this definition**. The event is increasing.

On `U_h` outside the collar event these requirements hold. A path avoiding
actual plus edges in `K` must exit `K` before its first crossing of the
target. Its prefix to that crossing is inside the target disk. A segment
from the last inner-band hit before its first subsequent outer-band hit
is a full band subpath inside that disk. The closed-core edge convention
counts crossings on the boundary of `K`. The subpath avoids `F` and all
attached minus circuits; outside the collar event it reaches distance
greater than `eta`. Consequently `mu_h(V_h)>=b/2`.

Choose a fixed grid much finer than `eta` and the band width. Request a
plus circuit around each grid cell whose filled buffer misses `F` and
lies in `A+`. Choose the cells and buffers so that every point of `A`
at distance greater than `eta` from `F` lies strictly inside one requested
circuit's inner cell, and every circuit disk has diameter smaller than
the distance between the two band boundary curves. All buffers miss
old-core and source queries. Their number is bounded by a fixed
`M(eta)`, and each requested **actual** plus circuit has probability at
least `rho_1>0` under `mu_h`. FKG in this fixed residual law gives

```
mu_h(V_h and all requested plus circuits) >= (b/2) * rho_1^M.
```

A path avoiding actual plus edges in `K` cannot satisfy the temporary
alternative on this intersection. Its full band subpath visits the
strict interior of one requested circuit. A connected path avoiding
that circuit must stay in its disk, but its two band-boundary endpoints
cannot both fit in that disk by the diameter choice.

Thus actual plus edges of `K` block every across-`I` path in `R`.
Any more distant exterior excursion could be replaced by a walk in the
complete shell outside `K`, then loop-erased. Separation in `R` is
therefore separation in the full underlying dual graph by these actual
plus edges alone. Planar cut-cycle duality extracts a simple actual plus
loop in `K` for every across pair. A boundary-to-boundary cut is excluded
because all blocking edges lie strictly inside `R`.

The fixed source frontiers preserve the outside minus pairs; `V_h`
preserves the outside plus pairs. No missing pair was wholly inside
`I`, and every previously local loop remains fixed in `g`. Hence
compatibility is preserved and at least one missing pair becomes locally
separated. Integrating the retained histories gives the uniform bound

```
r(a,k) = (b^2/2) * rho_1^M > 0,       b=a/(2*L(k)).                         (S)
```

At no point was a transverse color fixed or an actual plus event
intersected with a decreasing history-selection or collar-avoidance
event using FKG.

### 5. Linear-depth iteration, not one layer per pair

For each complete core pattern `g`, give a mark its membership signature
in all actual monochromatic loops in the core. Declare two marks
equivalent when their signatures agree, and let `v(g)` be the number of
equivalence classes. This is a partition for purely set-theoretic
reasons; it does not presume a particular pairing of loop boundaries.
Enlarging the core only refines it.

An opposite pair is missing exactly when its two marks are in the same
signature class. Any new local loop separating a missing pair therefore
strictly increases `v`. This is stronger progress than an increase in the
number of separated opposite pairs: there can be only `n-1` strict
increases, however many such pairs there are.

Set `f(g)=n` if every opposite pair is locally separated, and otherwise
`f(g)=v(g)`. For `n>=2`, this is an integer in `[1,n]`,
is nondecreasing under core enlargement, and reaches `n` exactly at
success. Statement (S) increases it by at least one whenever it is below
`n`, while preserving compatibility.

Choose cores `K0=Q' < K1 < ... < K_(n-1) < B` beforehand. Under the
original law conditional on the initial pattern let

```
G_j = {compatibility and f(P_j) >= j+1}.
q_0 = p.
```

If `P(G_j)>=q_j`, disintegrate this original law **only by the new
complete core pattern**. Patterns with `f>=j+1` and posterior
compatibility at least `q_j/2` have total mass at least `q_j/2`.
Those already at the next level contribute at least `q_j/2`
conditionally; for the others apply (S). Thus one may take

```
q_(j+1) = (q_j/2) * min(q_j/2, r(q_j/2,k)) > 0.
```

The earlier source histories and type events have been integrated out.
The next conditional law is again an allowed core pin law with unused
buffers. At `j=n-1`, `f=n` forces all required local loops. The constants,
collar widths, grid sizes and finitely many mesh thresholds were chosen
from `p,k,t` and the predetermined gaps, never from a microscopic pattern
or a future outcome. Take the minimum over the finitely many gaps.
This proves the theorem.

For uniformity over all terminal counts `n<=k`, fix `k-1` gaps in
advance and use their first `n-1` gaps. Counts zero and one and
assignments with no opposite pair need no step. Thus the geometry is
not secretly chosen from the shapes of the pattern's components.

## Exact finite core and how to replay it

Run from the campaign root:

```
python3 research/full_spin_witness/verify.py
```

The standard-library script recomputes and compares
`exact_certificate.json`; it makes no network requests.

The first experiment exhausts all **5,488** admissible configurations on
a `4x4` `W`-vertex domain with open plus perimeter and four free interior
spins. It explicitly sums all **2,809,856** transverse-spin assignments.
It checks the free-component color factor, actual monochromatic
cut-cycle separation against `N` connectivity for all **43,904**
three-mark assignments, and **11,450** minimal-target/rank steps.
Every one of the underlying grid's **213** simple cycles is accounted
for. The certificate gives exact polynomial coefficient vectors for
the total, compatibility and central-core-witness weights in the basis
`t^(12-j)*(1-t)^j`, not numerical approximations.

This tiny grid has no retained opposite-color outside-pair source case;
the certificate explicitly reports zero instead of implying coverage.
The second, **256-state**, `7x4` pin-law fixture supplies that test. There
are two disjoint four-edge squares, one minus and one plus, all other
interior edges closed, all spins pinned and transverse colors free.
The two interior marks have one assigned sign and an outside mark the
opposite sign. Compatibility is exactly the event that both actual
circuits are open. All pins are endpoint-compatible and have positive
weight for every `t in [1/2,1)`. This is a lawful finite pin experiment,
not a claimed mesh family of geometric `Q'` patterns.

After cancelling the common fixed-edge factor, its partition function
is `2*(1+t^4)^2`. A single square is fully open with probability

```
q(t)=2*t^4/(1+t^4).
```

The full complement-of-minus exploration from its inside source has
one retained cylinder with **16** possible future plus-edge completions.
It queries no edge of the future plus circuit. The script checks
**61,696** transcript-cylinder membership comparisons and **768**
residual lattice-FKG inequalities. It explicitly exhibits states in
which complement-of-minus reaches across an open plus circuit but `N`
does not, so substituting `N` in the exploration would fail this check.
Conditional on the retained minus history, the actual plus-loop
probability is still `q(t)`, while compatibility has probability `q(t)^2`.
The four unnormalized joint masses are checked coefficient by coefficient
as `2*(1-t^4)^2`, `4*t^4*(1-t^4)`, `4*t^4*(1-t^4)` and `8*t^8`.
The conditional-probability identity is also checked after exact polynomial
cross-multiplication. These identities hold for every allowed `t`, not
merely the three displayed rational parameter values.

At `t=2/3` these are respectively `32/97` and `1024/9409`. This finite
normalization was also run through the inspected Jacobian operation
`probability.finite_distribution.condition.compute`, version `0.14.0`,
protocol `2025-11-25`, with adapter exit status zero. The exact payload,
typed result and adapter status are in their dedicated `jacobian_*.json`
files. The script reconstructs that payload from the model's exact
weights and independently replays the output. Jacobian did not prove
the collar estimate or supply a spatial verdict.

Finally all partitions of up to seven marks and **5,856** binary
refinements are checked against the signature-rank invariant. The
universal `n-1` bound is proved above, not inferred from that finite
partition enumeration.

## Scope of the conclusion and remaining obligations

This is a universal mathematical verification proof, plus a linear-depth
structural strengthening, supported by exact finite-core checks. It is
not a counterexample, a Lean/kernel certificate, or a deduction of a
uniform estimate from a finite experiment. Compared with the strongest
starting evidence, it supplies the explicit anchored-collar derivation,
checks the exact allowed histories and marginal completion, and replaces
pair-count iteration by partition-rank iteration.

Independent Reviewer reading is still required, especially of the
finite-rank reduction in the collar proof and the product-factor
identification of the completed accessible marginal. The canonical
literature assumptions remain recorded for independent attribution;
the Engineer's reading does not satisfy that independence requirement.
The citation tool's archive directory `research/literature/` is outside
this mission's writable paths, so the Engineer has not invoked an
attribution command that would write there. The read source excerpts
are instead preserved inside the owned directory. An authorized
independent Reviewer must resolve that archival boundary rather than
silently bypass it or relabel the Engineer as an independent reader.

Even acceptance of this proof leaves one-parity pattern comparison,
terminal-count tails, screening, Gaussian identification and the joint
cluster-limit identification outside this mission's verification.
In particular `prop:full-contiguity` and `thm:main` remain open in the
proof graph; no new result in this directory closes them.
