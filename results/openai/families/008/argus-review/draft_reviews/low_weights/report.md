# Exhaustive rational base cases

**Engineer assessment: supported by a complete elementary argument and exact
checker replay; no Lean formalization is claimed.**

## Claim, hypotheses, and source

`L_LOW_WEIGHTS` is `W_0=W_1=W_2=0` for the *ordinary* free Lie algebra on
two weight-one generators over `Q`, with the three equations stated in the
[endpoint report](../upper_bound_certificate/report.md). This is the
base-case argument in old `research/upper_bound_certificate/report.md`,
also implemented by `exact_boundary_checks` in its `verify.py` and used in
the pinned manuscript's `cor:dimension-bound`
(`05-image.tex:404-420`). It is an elementary reconstruction, not a claimed
original theorem.

## Decisive proof

In weight zero there is no bracket monomial: ordinary free Lie algebras have
no scalar unit and all generating weights are positive.

In weight one write `p=alpha*x+beta*y`. Substitution in the pentagon, with
left minus right as residual, gives

    -alpha*t12 - beta*t34.

The degree-one braid generators are independent. Indeed every defining
braid relation is a bracket, so assigning arbitrary scalar values to the
six generators defines a map to an abelian Lie algebra. The coordinate
maps detecting `t12` and `t34` force `alpha=beta=0`. Neither antisymmetry
alone nor an unproved assertion about higher braid degrees is needed here.

In weight two the complete bracket list is

    [x,x]=0, [x,y], [y,x]=-[x,y], [y,y]=0.

Thus `p=c[x,y]`. With `z=-x-y`, the three-term residual is

    c([x,y]+[y,z]+[z,x]) = 3c[x,y].

Its associative expansion has coefficient `3c` at `xy`; alternatively
evaluation at matrix units `x=E12`, `y=E23` detects a nonzero commutator.
Over `Q`, this forces `c=0`. This step must not be generalized without a
characteristic hypothesis; division by 3 is being used.

The odd-generator comparison space has no components of weights zero,
one or two, because every generator has weight at least three. These base
cases therefore combine with the theorem for every `n>2` to cover *all*
natural weights, not merely a sampled range.

## Replay and evidence limits

The current `../source_action_tables/replay.py` calls only the old checker's
pure `exact_boundary_checks` and `source_action_checks`, not its writing
`verify`, `prepare`, or restoration routines. Its generated
`algebra_replay.json` records the pentagon columns `{"12":-1}` and
`{"34":-1}`, all four degree-two brackets, and the residual
`{"xy":3,"yx":-3}`. Execution succeeded. This is exact symbolic integer
arithmetic, not floating-point agreement or an extended weight search.
The spanning and braid-coordinate arguments above supply the mathematical
exhaustiveness that output alone would not prove.

The GF(2) boundary matrix stored alongside the old base-case output concerns
`[B,[A,B]]` in the deletion argument. It is not the proof of these rational
base cases, despite the old package nesting both under one field.

The old ledger separately records Engineer and historical Reviewer support
for `L_LOW_WEIGHTS`. The current assessment neither promotes that prose
proof to kernel closure nor treats the stale graph's open label as a
refutation. There is no remaining mathematical gap in these three cases;
native independent acceptance of this mission is still pending.
