# Statement fidelity: D_CORE_257

## Declarations and conclusion

The principal declarations in `Main.lean` are
`DiagramDeficit.fragment_bound` and `DiagramDeficit.manuscript_fragment`.
They quantify over **arbitrary natural numbers** `nt, nf, ne, np, nh`, over
real parameters `alpha, beta, delta`, and over every
`DiagramDeficit.RankedFragment alpha beta delta nt nf ne np nh`.
There is no bound on these numbers, on any face multiplicity, on the number
of fan-apex instances, or on the number of rank-filtration levels.

The finite types index top occurrences, fan occurrences, decoration
occurrences, field positions, and internal letter contacts, respectively.
They do not index bounded-size diagrams. The only exhaustive finite
classification concerns a **single normalized fan link**, whose at most five
distinct radial labels come from the fixed manuscript template.

Write `T`, `Q`, `E` for the selected top, fan-triangle, and decoration counts,
and `Braw`, `Brad` for the two boundary counts. The first theorem proves

    4 min(beta - 7 alpha, alpha/4, delta) (T + Q + E)
      <= 2 Braw + 3 Brad <= 3 (Braw + Brad).

Its algebraic inequality only requires `alpha > 0`. Under the manuscript's
additional hypotheses `beta > 7 alpha` and `delta > 0`,
`DiagramDeficit.kappa4_pos` proves that its constant is positive. Thus the
meaningful strengthened filling bound is
`A <= 3 B/(4 kappa4)`. The second theorem assumes all three positivity
hypotheses and proves the precise manuscript conclusion

    T + Q + E <= (Braw + Brad) / min(beta - 7 alpha, alpha/5, delta).

The upper parameter bounds in `02-model.tex`, `eq:model-parameters`, are not
needed for this deterministic implication. The theorems permit arbitrary
nonnegative integral decoration half-lengths; the manuscript's values two
and three are special cases.

## Local-link hypotheses are structural, not the desired inequalities

`DiagramDeficit.LocalPattern` records a full cyclic list of distinct radial
labels, the kind of each step, and an arbitrary nonempty Boolean selection
mask of the same length. `validLink` checks the actual three fan templates:

* type zero is `K_{2,3}`, with point labels zero and one and line ports
  two, three, four;
* type one is `K_{2,2}`, with point labels zero and one, line ports two and
  three, and exceptional port zero (`X_D`);
* type two is the three-edge star, with point label zero and line ports
  one, two, three.

A step of kind zero is a fan edge, kind one a turn of one designated
dominant top occurrence, and kind two a turn of another top occurrence.
Every turn joins distinct ports. Two consecutive dominant turns, including
across the cyclic join, are forbidden by equal-index same-occurrence top
cancellation. A two-step triangle-only backtrack is likewise forbidden.
Kind-two turns are allowed to have mutually different occurrence identities;
their other cancellation restrictions are dropped. This **enlarges** the
class checked, rather than assuming any additional cancellation.

The exceptional-port payment counts selected turns incident to `X_D`.
Its two possible incidences are separate payments, just as the source counts
loose-side copies. The partial flag is computed from the mask, not supplied
as an adjustable error term. The transition count is the actual cyclic
selected/unselected transition count.

`words_complete`, `distinctWords_complete`, and `cases_complete` prove that
every such labeled circuit and every selection mask occurs in the finite
classification. `local_certificate` checks that classification with `decide +kernel`, not a
native-computation oracle.
`local_sound` and the `LocalPattern` lemmas derive, rather than assume,
the ordinary and dominant local deficit bounds, at most four fan triangles,
at most one dominant turn, at least one selected step, and at most one use of
each indexed fan field. In particular, a selected subset need not be one run.

## Arbitrary multiplicities and shared prerequisites

`DiagramDeficit.Incidence` records nonnegative integral selected
multiplicities and, for each fan occurrence, an arbitrarily long list of
represented `LocalPattern`s. In an application the kind-one color refers
to one top occurrence chosen once for that entire fan occurrence.

`uses` is the prerequisite incidence relation. Each top has exactly seven
distinct prerequisite fans (`seven_slots`), including fans not visited by
its selected polygons. `turns a b` counts its selected turns at that fan.
`turn_budget` says a simple polygon visits a given fan at most once.
`turns_total` identifies those counts with the selected local turns.
`three_turns` is the structural fact that each simple macro polygon visits
at least three points.

The fan weight dominates the number of represented links and every requiring
top multiplicity. If it exceeds the number of links, it is attained by a
requiring top, whose local dominant count is identified with `turns`.
`Incidence.weight_is_max` proves that these structural conditions force
**the exact source weight**

    w_b = max(r_b, max_{a -> b} t_a).

No apex inequality is a field of either structure.
`Incidence.apex` derives the strengthened per-fan inequality. `slot_sum`
derives `sum S_b = 7T`; `nominal_apex` and `capacities` sum the result.
`local_population`, `fan_support`, `occurrence_bound`, and `layer_size` prove
the actual `8A` size bound for every layer, rather than postulating it.

## Letter contacts, unsigned classes, and the rank hypothesis

`owner` assigns each field position to a loose top field, a fan occurrence,
or a decoration occurrence. `fieldWeight` then gives it weight `t_a`, `w_b`,
or `t_e`, respectively. The abstract theorem allows arbitrary finite field
fibers; for the source application use the source's full field sets, including
unvisited prerequisite fan fields.

The idempotent map `root` chooses a maximum-weight representative of each
unsigned field-value class. Equal class values are represented by equal roots.
This is finite bookkeeping, not a probabilistic independence assertion.
`rank_is_coincidence_rank` proves that deleting the representative at each
level gives exactly positions minus unsigned classes.

The two ends of each contact are distinct field positions with equal roots.
`side` additionally assigns them distinct actual side-copy indices below
their position's weight, injectively across **all** contact ends. This is
the usual disjoint-side-pairing/capacity condition. For a normalized source
picture its fan capacity follows from `LocalPattern.field_capacity` and
`w_b >= r_b`; its top and decoration capacities follow from one use of each
indexed field in a simple polygon or one decoration copy. Orientation
conditions are not needed for this unsigned upper bound.

`contacts_charge` proves the charging bound for arbitrary contact multigraphs;
it does not assume a forest. `layer_sum`, `layerRank_sum`, and `weighted_rank`
prove the unbounded layer integration. None assumes the manuscript's weighted
contact inequality as an input.

The **remaining substantive premise** `rank_bound` is exactly the conditional
occurrence-rank hypothesis: every prerequisite-closed collection of at most
`8A` distinct occurrences obeys

    R <= (p - 7f) s + f u + sum_e (h_e - delta).

`fieldsOf` retains complete owner fibers. `collectionRank` is their cardinality
minus the cardinality of their unsigned-class image. `layer_prerequisites`
and `RankedFragment.layer_rank` prove eligibility and apply that hypothesis to
each threshold collection, including shared fans only once.
Lean indexes the levels by nonnegative `j` with `j < weight`; this is the
source's positive level `j + 1`, not an additional zero-weight layer.

The other global inputs are literal side-count identities:
`raw_count` says `Braw + 2I = Q + P* + 2 sum h_e t_e`;
`radial_count` bounds the computed fan-link transition count by `Brad`.
They are not deficit or filling estimates. `weighted_contacts`,
`boundary_deficit`, and `deficit_controls_area` derive the final inequality.

## Translation and explicit limits

The source locators are `02-model.tex`, `def:template`, the cone construction,
and `03-diagrams.tex`, `diagram:normal-form`, `diagram:weighted-rank`,
`diagram:apex`, and `diagram:fragment`. The prose proof in
`fragment_theorem.md` explains the source-to-incidence translation. The
standalone Python replay independently reconstructs the binary projective
plane, fan edges, ports, finite local cases, and macro-cycle properties.

The formal theorem is a theorem **about normalized finite incidence data**.
It is not a formalization of arbitrary CW maps or the normalization process.
Human independent review must check that a manuscript normal picture supplies
these data, in particular its side-copy indexing, simple macro polygons, and
literal rank premise. The compiler does not perform that reading.

The following are deliberately not asserted: existence of a normal picture,
preservation of a prescribed lifted two-cycle, the random occurrence-rank
event, planar separator globalization, asphericity, sampling, the CAT(0)
obstruction, the main theorem, publication-level significance, or originality
relative to all existing literature. Those claims remain open in the ledger.
