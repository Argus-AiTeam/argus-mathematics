# Surviving-seed localization

## Exact scope

The target is the universal assertion preceding `pack:near-path` and the
counting conclusion of `pack:bound` in the staged planar manuscript,
September 23, 2026, `build/sections/main-packing.tex`.
Neither the planar embedding theorem nor the bounded-treewidth embedding
theorem is assumed independently verified. Their dependency skeletons are
recorded separately in `research/PROOF_GRAPH.json`.

The source hypotheses include a finite cyclic column order, noncrossing
links, a single terminal switch for each non-neighbor link, genuine old
distance fields, radius-5 eligibility in both old chart systems, both
descending witness paths in the broad band, all field and height cutoffs,
radially padded cells, and exclusion of every applicable low-tip barrier.
An example omitting any of these is not a counterexample to the manuscript.

The proof route isolates the more general metric/combinatorial implication:
a connected low column set, short center paths avoiding that set, descending
witness paths ending in that set, and no sufficiently low separating switch
force localization near two extreme center paths. The translation from the
manuscript's distance field and eligibility to those inputs is a separate
obligation. This distinction prevents a proof of a conditional counting
lemma from being represented as a proof of the complete embedding theorem.

## Source inputs and existing knowledge

The definitions and constants are read directly from planar
`geometry.tex`, `scale-setup.tex`, `sets.tex`, and `main-packing.tex`.
The geometric source inputs are `geo:geodesics`, `geo:chord-separation`,
`geo:gap`, `geo:sublevel`, and `geo:padding`. They are manuscript assertions,
not independent certificates. Their elementary proofs are available in
the staged source; no external theorem is needed for the localization
argument itself.

The bounded-treewidth skeleton additionally records CKR's symmetric
Markov-flow bound as an unverified source input in this mission. It is not
a premise of the localization result. The supplied planner reports an
earlier citation match; this engineer does not manufacture a new source
reading or inherit a reviewer verdict from that report.

A targeted search of the inherited project Wiki found no relevant
surviving-seed, noncrossing-column, or bounded-treewidth localization
result. The superficially matching handle-packing page concerns
symplectic embeddings and is irrelevant.

Replacing the distance field by arbitrary scalar labels is not an
admissible refutation route: it loses connectedness of the low column
sublevel. Likewise, bounded enumeration cannot establish the assertion
for an arbitrary number of columns.

The bounded literature lookup did not identify a prior theorem with these
hypotheses. Its suggested arXiv:2410.05580v2 was checked at the primary
abstract and concerns longest Euclidean spanning structures, not this
localization question. It is not a premise or evidence of novelty.
Mathematical priority and publishability remain for independent review.

## General localization theorem

Let columns have a cyclic noncrossing link graph. Cut the cyclic order at
a column of a connected nonempty low set and label the cut column zero.
Let `d_old` be a finite metric on the relevant old component. In the
broad band use the relation

    Near(u,v,r) := a band path of length at most r joins u to v.

It is crucial that `Near` is not replaced by a finite intrinsic metric
on all the data: a witness partner can lie in a different broad-band
component. The relation has reflexivity, symmetry, concatenation and
radius monotonicity; a permitted step gives a `Near` witness, and
`Near(u,v,r)` implies `d_old(u,v) <= r`.

Assume each broad column has `Near`-diameter at most `a`. A finite path
is represented by its vertical/switch word, with vertical length costs
and zero-cost switches. Let `s` be 1-Lipschitz for `d_old`, and suppose
there is a low profile `S_t` such that:

1. Every `S_t` is connected to column zero by finite link paths inside
   `S_t`, whenever nonempty.
2. `s(v)+a <= t` implies `col(v) in S_t`.
3. `col(v) in S_t` implies `s(v) <= t+a`.

Let `F` be any finite nonempty family of seeds. For each seed `w` take
a witness partner `w'`, paths from a common center `z` to `w` of length
at most `L` in the narrow band, and descending broad-band paths from
both `w,w'`. Their lengths lie in `[dmin,T]`, their endpoint fields are
at most their initial fields minus their lengths plus `err`, and
`s(w') <= s(w)+E`. Suppose

    d_old(w,w') >= sep,
    2L + E + err + a < dmin/2,
    2L + a + T < sep,
    j >= 0, E >= 0, err >= 0.

At every narrow-band switch strictly skipping `w` and strictly separating
its witness representatives, assume a switch point within `2L` of `w`
does not have field below `s(w)-j`. This is a geometric exclusion
condition, not an assumed localization conclusion.

**Theorem.** Two of the given center-to-seed paths, each of length at most
`L`, place every seed of `F` within `rho = j+err+2a` in `Near`.
No bound on the number of columns or path segments occurs in the theorem.
If the chosen seeds are pairwise broad-band separated by at least `b`
and `b>2rho`, then

    |F| <= 2 + 2L/(b-2rho).

The localization assertion does not require the pairwise separation;
separation is used only for the subsequent counting assertion.
The theorem also allows nonterminal links with multiple switch heights
if the exclusion condition is imposed at every relevant separating
switch. It does not assert that the manuscript's label construction
supplies that stronger exclusion in such models.

### Proof

Fix `w_* in F` and `t=s(w_*)-dmin/2`. Every seed has
`s(w) <= s(w_*)+2L`. Its descending terminal has field at most
`s(w_*)+2L-dmin+err`; its partner's terminal has field at most
`s(w_*)+2L+E-dmin+err`. The strict smallness inequality and property
2 put both terminal columns in `S_t`. Thus `S_t` is nonempty.

A visit `v` to any center path satisfies `s(v)>=s(w_*)-2L`. If
its column were in `S_t`, property 3 would give
`s(v)<=s(w_*)-dmin/2+a`, contradicting the same strict inequality.
All center words therefore avoid `S_t`.

An edge `ab` with endpoints outside `S_t`, ordered `a<b`, cannot
have a low column strictly between its endpoints. A link path in
`S_t` from that column to zero would have to hit `a` or `b`:
otherwise its first edge leaving `(a,b)` crosses `ab`. This
contradicts noncrossing and the endpoints' exclusion from `S_t`.
This is the connected-gap argument, proved without an assumed
interval-convexity property.

Choose seeds of minimum and maximum column indices and retain their
center paths. The endpoint indices of one of these paths bracket any
given seed's index. A finite word between bracketing indices either
visits that index or makes an actual switch strictly across it.
A visited column gives a broad path to the seed of length at most `a`.

In the skipped case write the switching columns as `a<b` and its
point as `e`. The column zero is outside `(a,b)` and the seed is
strictly inside; consequently this is not a cyclic-neighbor link.
If `w'` were inside `(a,b)`, its descending path to `S_t` would
hit `a` or `b`. A prefix of length at most `T`, a vertical transfer
of length at most `a`, and two center paths give

    d_old(w,w') <= T+a+2L < sep,

a contradiction. If `w'` were itself on either endpoint column,
the same contradiction omits the descending prefix. Thus `w'`
is strictly outside `[a,b]`.

The switch point has `d_old(w,e)<=2L`, so exclusion gives
`s(e)>=s(w)-j`. The descending path from `w` also hits an endpoint
column, at a point `v` and prefix length `p`. The endpoint drop
and Lipschitz comparison on the remaining suffix give

    s(v) <= s(w)-p+err,
    s(v) >= s(e)-a >= s(w)-j-a.

Therefore `p<=j+err+a`. Concatenating that *broad-band* prefix
and the vertical transfer to `e` proves
`Near(w,e,j+err+2a)`. This is not an inference from small old
metric distance to small band distance.

Assign each separated seed to a located point on one of the two paths.
On the same path, two assignment times differ by at least
`delta=b-2rho`, since the intervening path and the two locating
paths give a broad path of length `2rho+|time difference|`.
The map `time -> floor(time/delta)` is injective on each assigned
family in `[0,L]`. Thus each family has at most `1+L/delta`
points, giving the stated bound. The formal proof includes the
finite-cardinality argument, not only its final algebra.

## Genuine distance fields supply the profile

For the old band `I`, use its actual metric and source `o`, and choose
height `H` in the broad band. Define `S_t` by the reference points
`(i,H)` whose old distances from `o` are at most `t`.
The broad-to-old inclusion is nonexpansive. Reference transfer on
a column costs `|h-H|<=a`, proving profile properties 2 and 3.

For a low reference point `v=(i,H)`, choose an old shortest path
from `o` to `v`. At a visit `u` of prefix length `p`, its remaining
length is at least `|h(u)-H|`. The path from `o` to `u`, followed
vertically to `(col(u),H)`, therefore costs no more than the full
shortest path to `v`. Every visited column is low. Projection and
reversal of this word connect `i` to the source column through
low columns. This proves property 1, including the low status of
the source column whenever any low column exists.

`distanceProfile` formalizes this argument from geodesic attainment,
the height Lipschitz bound, and the column vertical-transfer inequality.
It does not assume connected distance sublevels.

## Faithful specialization to the manuscript

Use the common old system-A component metric as `d_old`, not the
possibly infinite broad intrinsic distance. Use actual paths in `J1`
for `Near`, actual center paths in `J2`, and

    L=4R, T=0.02, sep=1, dmin=10^-5,
    E=E_A=10^-27, err=epsilon=10^-24,
    j=10^-20, R=10^-8, g=10^-14, b=0.01g,
    0<a=a1<=10^-33.

Here are the source-to-model obligations, without silently verifying the
surrounding embedding construction:

| Source hypothesis | Role in the specialization |
|---|---|
| Finite cyclic noncrossing links | Rotate at the old source column; instantiate `Model.noncrossing`. |
| Closed switch sets; `geo:geodesics` | Give finite attained shortest words in both bands. This analytic realization is an explicit upstream input. |
| Radius-5 eligibility and partitioned old charts | The center belongs to every seed's witness-pair chart in both systems, so the identifiers coincide. `common_chart_from_eligibility` proves this elementary inference. |
| Ordinary field `s=d_I(o,.)` | Supplies the genuine old metric, nonexpansive inclusion, reference points and `distanceProfile`. |
| Narrow/broad heights and eligibility | Keep center words, descending words, and short vertical transfers in the stated old band and the correct old chart. In particular `J1` is contained in the old height interval. |
| Both descending witnesses and field cutoff | Supply both endpoint drops, lengths in `[10^-5,0.02]`, and the partner comparison `<=E_A`. |
| Terminal non-neighbor switches | A skipped switch is its link's actual tip, at a narrow-band height. `skipping_is_nonneighbor` excludes both linear and wrap-around neighbors. |
| Exclusion of every applicable low-tip barrier | Supplies the no-low-switch condition. The original ambient distance is no larger than the old metric; `barrier_from_ambient_exclusion` justifies the nearby-tip implication. No label-mass conclusion is assumed. |
| Width-g grouping and radial padding | Common bands, common band component and both common old identifiers leave distinct chosen groups in distinct cells; `geo:padding` supplies pairwise broad separation `>=0.01g`. Padding itself is an explicit upstream input. |

This instantiation allows the witness partner and its descending path
to occupy another `J1` component. It does not require a finite
`d_J1(w,w')`, or substitute an arbitrary scalar field for `s`.
All actual interior and cutoff conditions remain part of the source
seed definition, even when the general implication uses fewer of them.
The main raise theorem and the barrier's label-mass estimate are not
reproved: the localization implication begins with the defined retained
witnesses and exclusions.

For localization take `F` to be all the finitely many surviving seeds,
using `profile_localization` without a padding assumption. For packing
take one seed per group, using `profile_localization_and_packing`.
If there are no seeds, the packing count is zero.

The exact parameter margins are positive for every
`0<a1<=10^-33`. Keeping the actual spacing `b-2rho` instead of weakening
it to `b/2` gives the stronger sufficient integer bound

    number of groups <= 800160050,

versus the manuscript's `1600000002`. This is an improvement of this
restricted packing constant, not an optimality claim or a new estimate
for the final embedding distortion.

## Certification and limitations

`Main.lean` contains a universal proof, not a bounded experiment.
`statement_fidelity.md` describes its objects, hypotheses and named
declarations. `verify.py` reruns the official Lean evidence producer
against claim `L89_CORE`, independently replays the small typed Jacobian
output, checks the exact rational margins, and runs both campaign-local
ledger checks. `exact_certificate.json` is generated from that run.

The six-vertex Jacobian computation is an exact unweighted active-graph
sanity check only. It is not weighted column geometry, a counterexample,
or a proof of the universal theorem.

No false assertion of the staged manuscript has been identified here.
The earlier *audit formalization* route that imposed one finite broad
intrinsic metric was abandoned because witness partners need not be
in the same broad component; the bounded-path formulation repairs
that audit-side omission.

Independent statement-fidelity review, the source-to-model reading,
and the significance/novelty decision remain with the Host's Reviewer.
This deliverable does not certify the full planar embedding theorem,
the treewidth embedding theorem, interpolation, secondary success, or
chart persistence.
