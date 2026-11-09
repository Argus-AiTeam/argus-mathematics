# Statement fidelity: C183_ZOOM_RADIAL

## Encoded objects and theorem

The source is the standalone `research/noncollapse/Main.lean`, using
Lean 4.31.0 and the host's built Mathlib. All campaign-specific helper
proofs are in this same source; there are no imported campaign oleans.

`ThreeDirection.Plane` is `Real x Real` with its standard product
max norm. `RankRadial.eucNorm (x,y)` is `sqrt(x^2+y^2)`. Every circle,
radius, and norm in the final radial conclusion is Euclidean.
Max norms are used only for intermediate compactness and error bounds;
their conversion is proved, not silently identified with Euclidean norms.

The foundational declarations, named here also without their namespace,
are `Plane`, `seg`, `SameLine`, `Turning`, and `Defect`. `Plane` is the
real product just specified. `seg x y t` is (1-t)x+t y. `SameLine x y`
means equality of the second coordinates, equality of the first
coordinates, or equality of first-minus-second coordinates; these are
exactly the horizontal, vertical, and slope-one families. `Turning f H`
bounds the image displacement at each segment parameter 0<=t<=1 by
H times the endpoint image displacement. `Defect f R epsilon` bounds
the corresponding second-coordinate, first-coordinate, or
first-minus-second-coordinate image differences by epsilon for every
pair in the relevant family whose two image max norms are at most R.
`VanishingDefect` quantifies this over all R,epsilon>0 eventually in the
sequence index. The proved equivalence with `MovingDirections` is what
allows either formulation; finite-stage exact line preservation is
not assumed.

`RankRadial.NormalizedRankData` describes one selected point p, inverse
rank maps L_j, normalized forward zooms F_h,j, their left inverses
G_h,j, one fixed continuous linear equivalence B, linear normalizers
A_h,j, positive physical scale factors, and an arbitrary cutoff N(h,k).
It includes a positive radius and a positive projective separation.

Its hypotheses are exactly:

- On every sufficiently small positive h and every j, F_h,j is
  continuous, fixes zero, and has max-unit image of e1. Each coordinate
  of B^{-1}F_h,j has the intermediate-segment control following from
  monotonicity on horizontal, vertical and slope-one lines.
- G_h,j(F_h,j(x))=x and the physical scale is positive. For max-unit
  ball inputs w, the physical rank increment equals
  scale_h,j A_h,j(G_h,j(Bw)), exactly.
- For EVERY diagonal h_k>0 with h_k -> 0,
  j_k>=k and j_k>=N(h_k,k), the forward zooms have the full
  moving-point directional condition. This condition quantifies over
  every further increasing subsequence, every moving pair on a common
  source line, and both finite image limits. The line and base points
  need not be fixed or bounded.
- On every such diagonal and every fixed bounded rank ball, eventually
  each coordinate of w -> G_h,j(Bw) is coordinatewise monotone after
  independently reversing the input axes. Different coordinates and
  indices may use different signs.
- On every such diagonal, eventually A_h,j has operator norm one
  and sends a triple of max-unit, uniformly determinant-separated
  input directions projectively to e1,e2,e1+e2.

There is NO input of equicontinuity, bounded images on source compact
sets, nonlinear noncollapse, affine compact limits, inverse convergence,
linear lower singular bounds, or a uniform configuration convergence rate.
The cutoff has no monotonicity or regularity assumption.

## Exact quantified conclusion

`RankRadial.NormalizedRankData.iterated_radial` proves

    exists C>0,
    for every natural T with T>=2,
    exists delta>0,
    for every fixed real h with 0<h<delta,
    eventually in configuration index j,
    for ALL offsets u,v with |u|_2=h and |v|_2=h/T:

    |L_j(p+u)-L_j(p)|_2/(C T) <= |L_j(p+v)-L_j(p)|_2
    and
    |L_j(p+v)-L_j(p)|_2 <= C |L_j(p+u)-L_j(p)|_2/T.

The same C works for all T. The eventual j may depend on p,T,h;
there is no eventual bound uniform over h. The universal pair of
circle points precedes no hidden limit or choice of radius.
For the actual continuous inverse rank map, taking the attained
maximum and minimum on its two compact circles gives exactly
`zoom.tex`, `eq:radial-comparison`. Offsets u,v are not rank points;
the rank arguments are p+u,p+v.

`iterated_radial_with_constant` proves the explicit admissible value
C=16 b K^2/a, where b=1, K=||B||+||B^{-1}||+1 and a>0 is obtained
from projective compactness. Neither a nor C is assumed.

## Load-bearing declarations

`ThreeDirection.sequential_compactness_of_moving` proves sequence-level
noncollapse: every subsequence of continuous, normalized, bounded-turning
maps with moving-point direction preservation has a further subsequence
converging locally uniformly to sigma id, sigma=-1 or 1.
It does NOT assume a homeomorphism, expanding target domains, a pre-existing
pointwise limit, boundedness on compact source sets, or equicontinuity.

`ThreeDirection.movingDirections_iff_vanishingDefect` proves that its
bounded-image uniform-defect formulation is equivalent to the full
moving-limit condition; this is not an unannounced strengthening.

`RankGeometry.turning_of_coordinates` derives bounded turning from
the original-coordinate segment control.

`RankGeometry.normalized_triple_bounds` proves a positive uniform lower
singular bound from projective separation and operator normalization.
It includes the singular-case argument and Cramer's identity.

`RankRadial.inverse_comp_locallyUniform_of_pointwise` derives local
uniform inverse convergence from forward pointwise convergence,
the exact left-inverse identities, and inverse rank order. It does
not assume inverse tightness, inverse continuity or global surjectivity.

`RankRadial.iterated_of_diagonal_subsequence` proves the exact
fixed-radius/eventual-index quantifier principle with an arbitrary cutoff.

`RankRadial.identity_cutoff_example` shows that all normalized geometric
hypotheses are simultaneously inhabited for EVERY cutoff; the main
theorem is not certified solely by an inconsistent hypothesis package.

## Connection to the actual manuscript, and what is not encoded

`proof.md`, sections 1--6, constructs F,G,B,A and the positive scale
from the actual rank homeomorphisms and physical normalizations.
It derives the segment control from the two original rank coordinates,
the moving directions from differentiability and all directional
gradient tests, inverse rank order from the A/B level-graph chord
slopes, and eventual determinant separation from the compact,
pairwise projectively disjoint D_p(t_i) sets and the proved forward
compactness theorem. It also constructs the cutoff using a finite
bracketing grid; it does not assume uniform convergence to a
possibly discontinuous f_C.

Those source identifications, selection of the good rank point,
the graph-family rank construction, and the differentiability/allowed-set
results preceding `zoom.tex` are ordinary mathematical arguments,
not Lean encodings in this file. The compiler checks the fully stated
normalized analytic bridge; it does not verify that a prose document
correctly reads the staged LaTeX. Independent review must inspect
the source identification in `proof.md`, not approve it from compilation
alone. No assertion is made about the rest of the halving-line proof.

## Trust and review

The verifier requires a fresh real compiler exit 0, an empty
`proof_holes` list, and transitive axiom reports containing exactly
`propext`, `Classical.choice`, and `Quot.sound` for the designated
theorems. No campaign-specific axiom or `sorryAx` is allowed.
The official result binds this source and this document by their
compiler-recorded hashes. The independent Reviewer has not yet
endorsed source fidelity, significance, or novelty.
