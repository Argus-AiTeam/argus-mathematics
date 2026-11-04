# Statement fidelity: Gallinger's pinned main theorem

The source is the unmodified `KusnerL1/Main.lean` at commit
`7f3a7fe3bd7341ed6fa331737138dc0ab295b5c2` of
`https://github.com/kusner-l1/kusnerl1-lean`.

`KusnerL1.L1 n` abbreviates `PiLp 1 (fun _ : Fin n => Real)`.
`KusnerL1.l1_dist` identifies its distance with the sum of absolute coordinate
differences. It is not the supremum metric on the function space.
`KusnerL1.Equilateral S` requires a positive common distance for all distinct
members of the arbitrary set `S`. `equilateralDimension` is the supremum of
the extended cardinalities of such sets, so infinite sets are not silently
assigned cardinality zero.

The declarations `KusnerL1.equilateralDimension_five` and
`KusnerL1.equilateralDimension_six` assert, without additional hypotheses,
that these suprema equal 10 and 12, respectively. Their upper-bound dependency
is `no_unit_equilateral`: for every natural number `n` with `2 <= n <= 6`
and every indexed family `Fin (2*n+1) -> L1 n`, not all distinct-index
distances can equal one. This includes arbitrary real coordinates and ties.
The lower bounds are supplied by the signed coordinate vectors.

These are the statements of Theorem 1.1 and Corollary 6.2 in
DOI `10.5281/zenodo.22984024`, not an aspect-ratio theorem. Their proof passes
through terminal clipping, positive reciprocal radii, cut energies, the span
and endpoint inequalities, scalar reduction, and the dimension-six scalar
exclusion. The source's definitions of `a`, `b`, `Phi`, `G`, `alpha`, and
`Admissible` match equations (5.5), (5.7), (5.8), and (5.11) in that paper.

The README warns that the formalization predates later manuscript revisions.
The direct dimension-five argument in Remark 6.3 and the surviving
dimension-seven scalar pair in Proposition 7.1 do not appear as declarations
in the pinned main theorem dependency chain. They are not certified by a
successful build of the two main theorems.

The upstream toolchain is Lean 4.33.1 with Mathlib commit
`0df444a360eaa60ab8c11dca51a86af692955474`.
An alternate-environment replay, if successful, checks the unchanged source
with the installed Lean 4.31.0 and its installed Mathlib. It must not be
described as reproduction of the pinned upstream build.

The compiler checks the encoded statements and their imported proof terms.
It does not check this reading of the paper, its novelty, or any assertion
about the exact eleven-point minimum aspect ratio.
