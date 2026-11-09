# The original curve inequality

**Assessment:** the report supports the literal original branch-summed inequality under all three original sigma inequalities. It neither replaces those hypotheses by a stronger unstated condition nor extrapolates the finite examples.

## Statement and attribution

OpenAI's September 24, 2026 manuscript, revision `4eaee87548250b2682affda7d05d947c05554bae`, interpolation section lines 169-474, contains `geom:curve-inequality`. The old verification is A04 section 4; A01 records successive versions of `C_GEOM_CURVE`, adding explicit curve-model and curve-degree assumptions. The current claim uses the same ID, not the old judgements.

Let `m,K>=1`, `0<theta<1`, `W=(w0,...,wm)` and `V=(v0,w1/theta,...,wm/theta)` with positive rational entries. Centers are `(1,cj1,...,cjm)`, and for each `i` the `K` numbers `cji` are pairwise distinct. Choose positive rational `sigma` satisfying

    (1+3sigma)^(m+1) K (w0/v0) theta^m < 1,
    (1+3sigma)^m K theta^m < 1,
    (1+sigma) theta < 1,

and impose the complete successive product separation for `L0=m+2` and `C*=max_(1<=k<=m) 2k!(L0/sigma)^k`.

For every irreducible affine algebraic curve, take its complete smooth model. Let `D` be the sum, over all points, of the maximum of zero and each coordinate pole order divided by its `W`-weight. At each branch `P` through center `j`, put

    hP = min(ordP(Y-1)/v0,
             ordP(Xi-cji-log Y)/vi for all i).

Identically zero functions have infinite order. Let `S` sum `hP` over **all branches at all centers**. The conclusion is `D >= (1+sigma) S`.

## Decisive argument and quantifiers

If `S=0`, the conclusion is immediate. Otherwise assume `D<(1+sigma)S`. For every sufficiently large auxiliary integer `N`, coefficient counting produces a nonzero `F_N` of `W`-degree at most `N` and `V`-order at least `(1+3sigma)N` at every center. The ratio of the number of imposed conditions to available coefficients tends to the first displayed left side. This establishes existence even when the conditions are dependent; it is not a rank-independence assumption.

The commuting logarithmic frame preserves the degree bound. In local coordinates it is `(1+t) partial_t, partial_ui`; a derivative of cost at most `sigma N` lowers weighted order by at most that cost. Every surviving monomial restricts to each branch with order at least its weight times `hP`, including the constant-coordinate cases. Thus all these derivatives have total zeros at least `(1+2sigma)NS`. A nonzero restriction has total poles at most `ND`, so zero-pole equality forces it to vanish identically.

Set `delta=sigma N/L0` and form zero sets of derivatives of cost at most `r delta`, for `r=0,...,L0`. Select nested irreducible components containing the curve, backwards from the last level. They are proper and have dimensions from 1 through `m`. There are `m+3` levels, so some adjacent selected components have the same dimension and hence coincide. Equations at the earlier level, followed by every derivative of cost **less than** `delta`, vanish on that common component.

The multiplicity result applies with `epsilon=sigma/L0`; its uniformity is essential because both component and equations may change with `N`. The all-bases inequalities and the geometric normal-basis lemma force `Y` constant. Since the curve has positive contact with a prescribed center, this constant is 1.

Run the persistence/counting argument again in that fiber, now with polynomials in `m` variables. Its existence condition is exactly the second sigma inequality. For `m=1`, a nonzero polynomial cannot vanish on an algebraic curve in the affine line. For `m>1`, the proper persistent component lies in a coordinate flat. A fixed coordinate can take its prescribed value at at most one center, by coordinatewise distinctness.

For that one center, choose a nonconstant coordinate `Xl`. The nonzero rational function `Xl-cjl` has pole degree at most `wl D` and zeros of total order at least `(wl/theta)S`. Hence `D>=S/theta>(1+sigma)S`, contradicting the assumption by the third sigma inequality. This explicitly covers the one-dimensional endpoint and does not omit branches at a node.

## External assumptions and assessment boundary

Smooth models use A27/A28, Stacks `0BY1` and `0BY3` (perfection over `C`). The pole/zero argument uses Stacks degree under birational pullback (`0AYU`), effective-divisor length (`0AYY`), and nonnegative degree for a nonzero section (`0B40`), supplied as A23-A25. Additivity of line-bundle degree applied to a principal divisor gives equal zero and pole degrees. These inputs are recorded as `A_PROJECTIVE_CURVE_MODEL` and `A_CURVE_DEGREES`; multiplicity separately depends on Mondal.

The replay in [exact-examples/replay.json](../exact-examples/replay.json) verifies both supplied curve examples and all their center preimages and poles. It is an illustration of this theorem, not a proof for every curve. The old Lean theorem does not encode this statement.

No concrete mathematical gap was found in this written chain under the stated hypotheses and external inputs. The native independent Reviewer must still assess that chain and its citations. This is verification of the original interpolation ingredient only, not a refutation of the manuscript or a proof of the final irrationality theorem.
