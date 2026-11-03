# Campaign 1380 Exploratory Negative Report

## Outcome

No exact witness was found. In particular, this campaign did not produce eleven
pairwise distinct exact points in the unit square for which all 165 triangle
areas are strictly greater than \(1/27\). Claim `C1` therefore remains open.

This is an **exhausted-boundary report**, not a counterexample and not a proof
that `C1` is false. It records only the independently reviewed finite or
structurally declared classes below. The candidate-or-exhausted-boundary
stopping contract is satisfied through this bounded negative branch;
independent certification of this consolidated report is recorded below.

## Independently reviewed exact exclusions

1. **Uniform rational grids through denominator 9.** For every integer
   \(1\leq D\leq9\), complete lexicographic backtracking enumerated every
   11-point subset of
   \(G_D=\{(i/D,j/D):0\leq i,j\leq D\}\). A triple passes the strict threshold
   exactly when
   \(27|\det_{\mathbb Z}|>2D^2\). No enumerated subset passed all 165 strict
   tests. The complete class and per-denominator artifacts are consolidated in
   `research/EXHAUSTED_BOUNDARY.json`.

2. **Polynomial perturbations through the equality baseline.** The exact
   certificate in `research/nonuniform/tangent_analysis.json` gives a positive
   normalized stress on the 28 active triangles, zero weighted gradient on all
   14 free velocity coordinates, strictly negative weighted gradient on all
   eight inward-normal coordinates, and a nonzero exact 14-by-14 gradient
   minor. Consequently, the nonnegative square-tangent face is \(\{0\}\), so
   no nonconstant square-feasible polynomial perturbation branch through that
   particular \(1/27\) baseline can improve every active triangle.

3. **One declared minimum-cover horizontal-slide family.** The exact interval
   certificate and independent QF_LRA replay in
   `research/nonuniform/hitting_set_horizontal_family.json` exclude the full
   five-dimensional family obtained by moving the \(x\)-coordinates of cover
   \(\{0,4,5,9,10\}\) while holding its \(y\)-coordinates and all six
   complementary points fixed. This does not exclude arbitrary two-coordinate
   motion of those points or the other minimum-cover orbit.

These exclusions do not cover all rational configurations, certified real
algebraic configurations, non-polynomial deformations, or disconnected global
configurations.

## Empirical search result

The numerical record in `research/EXHAUSTED_BOUNDARY.json` comprises 656 saved
runs. Its best floating minimum area was
`0.03703703703703697`, not a value strictly above \(1/27\), and the saved
rational reconstruction is exactly the published equality configuration with
minimum area \(1/27\).

This 656-run threshold miss is candidate-discovery evidence only. It is not an
exact exclusion, a complete enumeration, or evidence of global infeasibility.

## Runs with no conclusion

The attempted exact grid searches for \(D=10\), \(D=11\), and \(D=12\) did not
complete. They yielded no mathematical conclusion and are not included in the
uniform-grid exhausted boundary.

## Review provenance and certification

`research/MATH_STATE.json` records independent Reviewer refutations of the
existential bounded-search claims `N1`, `E1`, `X1`, `T1`, `T2`, and `H1`, and
an inconclusive verdict on global witness claim `C1`. Those verdicts bind the
reviewed artifacts named above to their exact statements and limitations.

Sealed Reviewer mission `2d211f438a68` independently certified that this report
accurately consolidates those reviewed results without promoting any bounded
exclusion or numerical miss into a global claim. The supporting verdict is
recorded in `research/MATH_STATE.json` as
`judgement-F1-d0180cceba26`, bound to the current `F1` content hash. This
certification closes the selected exhausted-boundary completion branch.
It does not prove or refute `C1`.
