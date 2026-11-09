# Statement fidelity: noncrossing surviving-seed localization

## Claim and declarations

Claim `L89_CORE` is the universally quantified localization-to-packing
theorem in `PackingAudit.profile_localization`,
`PackingAudit.profile_localization_and_packing`, and
`PackingAudit.manuscript_core_certified`. Its genuine-distance-field
profile constructor is `PackingAudit.distanceProfile`. The numerical
corollaries are `PackingAudit.manuscript_integer_bound` and
`PackingAudit.sharper_integer_bound`.

The source is `research/packing_audit/Main.lean`, using Lean 4.31.0
and the host's built Mathlib. There are no additional axioms or proof
holes. Classical choice, propositional extensionality, and quotient
soundness are standard Lean/Mathlib foundations, not geometric inputs
silently proved by the compiler.

## Objects and quantifiers

`Model N X` quantifies over an arbitrary representative type `N` and
pseudometric space `X`. The point metric is a finite **old-component**
metric, not the broad intrinsic metric. The natural-number column
labels give a cyclic order cut at a low source column numbered zero.
Any finite cyclic column order can be rotated and numbered this way;
the formal theorem places no upper bound on the labels or columns.

`Model.Near u v r` means that a broad-band path of length at most `r`
joins the represented points. Its explicit hypotheses are reflexivity
at zero, symmetry, monotonicity in the radius, concatenation, domination
of the old metric, a witness for each permitted step, and a zero-length
witness for each actual switch. No finite distance between different
broad components is assumed. In a column model it can be instantiated
by the actual bounded-path relation, or equivalently by finite
intrinsic distance `<=r` where geodesics attain it.

The link graph is symmetric and noncrossing: two oriented links cannot
have endpoints `a<c<b<d`. `Model.switch` is an actual switch relation,
not merely equality of two old-metric points whose columns are linked.
It is symmetric and implies an edge of the link graph and equality
of the point values. A permitted step either stays on one column or
is such a switch. Its real cost bounds the old distance. In the column
instantiation the costs are vertical variations, with zero-cost switches.

`Trace` is an arbitrary finite word of permitted steps. `Trace.length`
is the sum of its costs; `Trace.At` records a visit together with its
prefix length. The formal argument proves prefix and suffix distance
bounds, bounded broad paths, the same-path difference-of-times bound,
and the descending-prefix inequality. It is not restricted to any
enumerated number of steps or rational edge lengths.

## Distance profile and its construction

`Profile M a` explicitly supplies a real field `s`, a family of column
sets `low t`, a 1-Lipschitz comparison in the old metric, connectedness
of nonempty low sets to column zero, and the two vertical comparison
implications:

    s(point n)+a <= t  => col n in low t,
    col n in low t    => s(point n) <= t+a.

`distanceProfile` derives these properties for
`s(x)=dist(old_source,oldMap(x))`. Its input data are an old model,
the source's column being zero, a 1-Lipschitz height, vertical old
column transfers bounded by absolute height change, reference nodes
at a common height `H` on every represented old column, attained
finite old geodesic traces to those reference nodes, a nonexpansive
broad-to-old map with matching column representatives, and broad
height deviation at most `a`. Old links must be included among the
common noncrossing links. Connected sublevels are a **conclusion** of
this constructor, not one of its assumptions.

Geodesic attainment and the realization of the manuscript's quotient
as these model data are upstream geometric inputs. This file does not
formalize compactness of arbitrary closed switch sets, construct the
metric quotient, or prove `geo:geodesics` from that quotient definition.

## Surviving witnesses

`RawSurvivor` for a seed `w` supplies a witness partner, a narrow center
trace from `z` of length at most `L`, and broad descending traces from
both witness endpoints. Both descending lengths are between `dmin`
and `T`; both satisfy the endpoint field drop with error `err`.
The old-metric endpoint distance is at least `sep`, and the partner
field is at most the seed field plus `E`.

Its barrier hypothesis excludes a low actual narrow-band switch when
the ordered switching columns strictly enclose the seed column,
the partner is strictly outside the closed interval, the lower
switching column is positive, and the switch point has old distance
at most `2L` from the seed. It asserts field at least `s(w)-j`,
not the desired localization.

For the manuscript the positivity and strict skipped index exclude
linear neighbors and the cyclic wrap-around neighbor. Non-neighbor
links are terminal single switches, so the actual switch is their tip.
The ambient metric is contracted by the old band metric.
`barrier_from_ambient_exclusion` converts the actual excluded strict
drop at ambient distance at most one to the needed weak field bound
when `2L<=1`. The label-mass estimate of `pack:barrier` is not encoded
as an extra theorem.

The main numerical hypotheses are

    2L+E+err+a < dmin/2,  2L+a+T < sep,
    E>=0, j>=0, err>=0.

`survivorsFromProfile` proves that all center words avoid a connected
low set and both descending endpoints belong to it. Chord separation,
connected-gap separation, visiting/skipping, the partner-outside
argument, and the prefix bound are all proved in Lean.

## Conclusions

For every finite nonempty `Finset N` of seeds with these data,
`profile_localization` gives two center-to-seed traces such that every
seed has a `Trace.At` visit on one of them with

    Model.Near seed visit (j+err+2a).

Both chosen traces have length at most `L` by their supplied center
bounds. The proof chooses minimum and maximum seed column indices.
When no seed is on one side of the center, the unused path can be
replaced by the constant center path, as in the manuscript.
No pairwise seed separation is needed for this conclusion.

For counting, the additional hypothesis is that every broad path
joining two distinct chosen seeds has length at least `b`.
If `L>=0` and `b>2(j+err+2a)`,
`profile_localization_and_packing` proves the real cardinality bound

    card F <= 2+2L/(b-2(j+err+2a)).

It includes finite-cardinality counting by injecting assignment times
into two families of floor bins. The bound is not an assumed path
packing axiom. Empty families have cardinality zero; the more primitive
`survivor_packing` also handles this case.

With the exact manuscript constants, `0<=a<=10^-33`, `L=4*10^-8`,
`T=0.02`, `sep=1`, `dmin=10^-5`, `E=10^-27`, `j=10^-20`,
`err=10^-24`, and `b=10^-16`, `manuscript_core_certified` proves
localization, `card F<=800160050`, and the manuscript's
`card F<=2+ceil(1600R/g)=1600000002`.
The smaller integer is a sufficient bound, not an optimality assertion.

## Boundary of the certification

All real parameters, models, finite traces, witness choices and finite
seed families satisfying the hypotheses are universally quantified.
There is no bounded column enumeration. The structural theorem allows
nonterminal switches if every relevant separating switch satisfies the
stated exclusion; the manuscript's terminal condition suffices to
derive that exclusion from its specific tip test.

The manuscript specialization uses radius-5 eligibility to identify
both old chart identifiers and to evaluate the relevant words in their
common old field. `common_chart_from_eligibility` proves the common-ID
inference; the actual chart partition and band membership are read
from the manuscript, not constructed in Lean.
For packing, radial padding of distinct cells is supplied as the
separation hypothesis; `geo:padding` itself is not formalized.

Thus the kernel checks the localization-to-packing implication and the
distance-profile argument with their explicit geometric inputs.
Independent review must check the source-to-model instantiation.
This is not a formalization of the full planar or treewidth embedding
theorem, the interpolation hierarchy, or the update history.
