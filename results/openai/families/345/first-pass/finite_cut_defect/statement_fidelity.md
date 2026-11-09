# Statement fidelity: the finite-cut algebraic implication

The source is `Main.lean`, namespace `FiniteCut`, checked with Lean
4.31.0 and the host's built Mathlib. This document describes the entire
formal claim `C_FCD_EXACT`. It does not assert that the manuscript's
geometric constructions satisfy the hypotheses.

## Objects and hypotheses

`Fixed k V W V'` consists of three vector spaces over an arbitrary field
`k`, an exact cyclic fragment

```
V --delta--> W --f--> V' --i--> V --delta--> W,
```

and three idempotent linear projections `p,pw,pp`. Exactness means the
literal equalities of ranges with kernels in the fields
`exact_df`, `exact_fi`, and `exact_id`. The fields `f_cut` and `i_cut`
say that `f` and `i` commute with the corresponding projections.
**There is no field saying that `delta` commutes with them.**

`Comparison F C A' A D` consists of the actual fragment

```
C --left--> A' --middle--> A --right--> D,
```

exact at `A'` and `A`, with restrictions `localLeft,eNew,e,localRight`
to `W,V',V,W`. Its three square fields assert literal commutativity.
`Comparison.image` and `imageNew` are ranges of the *composites*
`p e` and `pp eNew`. Neither unprojected actual image is assumed to be
stable under a projection or a root-degree splitting.

`Comparison.Far` adds injectivity of both local restrictions, equality
of each local restriction range with `range(pw)`, and
`pw delta = delta p`. These are the algebraic contents of
`bud:far-local` and its no-crossing-edge consequence.

All dimension arguments impose finite-dimensionality on the relevant
spaces. `sdim` is ordinary `Module.finrank` cast to the integers; all
subtractions in the conclusions are integer subtractions, not truncated
natural subtraction.

## Declarations and conclusions

`projected_exact` proves exactness after cutting a fixed exact pair,
from exactness, compatible projections, and idempotence. `map_dim`
derives the subspace rank-nullity identity from Mathlib rank-nullity.
No dimension identity from the manuscript occurs as a hypothesis.

`Comparison.mixed_image_exact` proves

```
i(imageNew) = image intersect ker(delta).
```

Its proof uses the actual connecting class and local injectivity to
produce an actual lift. `Comparison.mixed_image_kernel` proves

```
imageNew intersect ker(i) = f(range(pw)).
```

Local surjectivity supplies the actual left lift. These are precisely
the mixed-image and kernel claims preceding `bud:deficit-change`.

`Fixed.low_dimensions`, `Comparison.mixed_image_dimensions`,
`Comparison.connecting_rank`, and `Comparison.actual_dimension`
derive the dimension changes. `Comparison.deficit_change` is
`bud:deficit-change` at an arbitrary compared degree.

`potential p ePrev e` is the sum of the four original terms:
the two low-image deficits, `dim(range(e) intersect ker(p))`, and
`dim(ker(e))`. Thus it is not defined by the shorter arithmetic
formula used at the end of the manuscript's proof.
`potential_formula` proves that shorter formula by rank-nullity;
`potential_nonneg` proves nonnegativity.

`far_event` takes two consecutive comparisons sharing the actual
local space `C`. Its hypotheses additionally identify the repeated
local restriction and impose exactness at `C`. Both comparisons are
far. Its two conclusions are exactly

```
potential_new - potential_old = -(r-r_J),
potential_new - potential_old <= 0,
```

where `r=dim(delta(range(p)))` and
`r_J=dim(delta(range(p e)))`. In the manuscript the two comparisons
are at `q=J-1,J`, with `J=2j`. The algebra does not otherwise need
the numerical equation `J=2j`, nor an assumption about multiplication
by `v`; those belong to deriving the far hypotheses from geometry.

`Fixed.low_dimension_bound`, `Comparison.image_dimension_bound`,
and `Comparison.actual_dimension_bound` prove the individual
dimension-change bounds. `exceptional_event` takes two comparisons
and an integer `M` bounding `dim W`, `dim C`, and `dim D`. It proves
the absolute potential change is at most `6*M`. It has **no**
`Far` hypothesis, no injectivity hypothesis on a restriction map,
and no hypothesis that `delta` commutes with the cut. In fact this
bound needs less gluing data than the far identity.

## Grading and event count

`rootCut` is the ordinary cutoff projection on a finite coordinate
space with integer root labels; `rootCut_idem` proves idempotence.
`degree_zero_cut` proves cut compatibility for every matrix preserving
labels. `degree_one_cut` proves it for every degree-one matrix whose
target has no coordinate in degree `j+1`. A finite graded vector space
has a homogeneous basis, so a zero homogeneous summand has no basis
coordinates. These declarations give the coordinate version of the
manuscript-to-projection translation. They do not assume that actual
restriction matrices preserve root labels.

`one_event_bound` proves the summed one-event estimate over an arbitrary
finite set of cutoffs. `event_sum` quantifies over arbitrary natural
event count `N`, exceptional-count bound `K`, integer increment bound
`b>=0`, integer-valued potentials, and a finite set `S`. Starting at
zero, nonpositive far increments and exceptional increments at most `b`
give `sum_S Phi_N <= b*K*N`. Applying the proved exceptional theorem
sets `b=6*M`. Finite support at each stage of the manuscript permits
`S` to be their finite union; no common global support bound is assumed.

`window_card` bounds the number of cutoffs in one index window by
`2*c+1`. `window_union_card` proves the bound
`number_of_labels*(2*c+1)` for an arbitrary finite prime-label set,
integer indices, natural window radius, and finite cutoff set.
These are uniform theorems, not bounded enumeration.

The reduction from geometric event lengths to
`N(a)<=sum floor(2a/ell_i)<=2a sum 1/ell_i` is an elementary
counting argument proved in `report.md`, not an encoded theorem about
geodesic critical values. The existence of the uniform index windows,
localization, geometric exact maps, finite-prime event list, and
fixed-cut finite support remains an explicit manuscript input in
`C_FCD_APPLICATION`.

## What the compiler does not certify

The compiler checks these universal linear-algebra and counting
theorems. It does not check this explanatory document's truth, its
identification of the manuscript's maps, the geometric inputs,
literature novelty, publishability, or any infinitude theorem.
Those identifications and limitations require the independent
Reviewer's reading. No Reviewer judgement is supplied by the Engineer.
