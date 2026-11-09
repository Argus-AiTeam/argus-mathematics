# Statement fidelity: C167_PV_CORE

The source is `Main.lean`, namespace `PrivateValuations`, compiled with
Lean 4.31.0 and the host's built Mathlib. The natural-language claim concerns
only the following finite algebra. It does not claim that Lean checks
the manuscript's geometric genericity or its main theorems.

## Private-order parity

`private_orders_exclude_squares` quantifies over any index type `I` with
decidable equality, any commutative group `G`, radicands `D : I -> G`,
and maps `v i : G ->* Multiplicative Z`. The hypothesis prescribes
`toAdd(v i (D j))` to be 1 for `i=j` and 0 otherwise.
For every nonempty finite set of indices, its radicand product is not
`x*x` for any `x : G`.

For application take `G=M^*`, the multiplicative group of nonzero elements
of the **final** field `M=K_0(V_1)`, and `v i` its order map.
The valuation triangle inequality is not needed for this parity implication.
The theorem does not construct an order map or allow it to be transferred
from a smaller field.

## Sign separation and linear systems

All remaining algebraic theorems quantify over a field `E` of
characteristic zero. Each `sigma i : E equiv+* E` is an actual field
automorphism. These maps are explicit hypotheses, not postulated
declarations or an implicit assumption that smaller-field independence
survives a field enlargement.

`sign_changes_separate` has an arbitrary finite index type. It assumes
each `r i` is nonzero, every automorphism fixes every coefficient `c k`,
and `sigma i` negates just `r i` and fixes all other `r k`.
It proves that a vanishing sum of the single radicals with those
coefficients has every coefficient zero.

`unused_sign_forces` assumes one automorphism fixes `q,A,t`, negates
the nonzero `r`, and `q=r*(A-t)`. It concludes `A=t`.
`delta3` is the negative determinant of the three rows
`[a_i,b_i,-r_i]`. `three_rows_unique` and `two_rows_unique` prove
the associated homogeneous-system uniqueness under their explicit
nonzero-determinant hypotheses.

`rank_two_obstruction` uses exactly four rows, indexed by `Fin 4`.
The automorphisms fix all entries of `a,b,d,t`; their only prescribed
nontrivial action is the corresponding sign on the nonzero `r`.
At least one two-by-two minor of the first three position rows is nonzero.
For **any** `x,y,A : E` satisfying all four equations
`a_k*x+b_k*y-r_k*A = d_k-r_k*t_k`, the additional hypothesis
`A != t_3` yields `False`. It derives the three-row determinant from
sign separation and proves the solution fixed by the unused automorphism.
It does not assume those unknowns fixed.

`rank_one_obstruction` has exactly three rows, indexed by `Fin 3`.
It assumes the analogous fixed coefficients and single-radical signs,
nonzero radicals, and at least one of the first two coefficients `a`
nonzero. A solution to `a_k*x-r_k*A=d_k-r_k*t_k` with
`A != t_2` yields `False`.

In the manuscript application, `E` is the actual radical field, the
rank-two coefficients are `a_k=2(p-r_k)_x`, `b_k=2(p-r_k)_y`,
`d_k=2(p-r_k).U_k`, `t_k=A'_k`, and the scalar `r_k` in the
formal source denotes the radical `R_k`, **not** an anchor point.
In rank one `x` is `v.H`, `a_k=2*s_k`, and
`d_k=2*s_k*(v.U_k)`. Indices 0,1,2,3 in Lean correspond to
manuscript columns 1,2,3,4.

The proof in `report.md` first uses Cramer's rule to put the actual
unknowns into `E`. Existence of the geometric private valuations,
square-class independence in the final field, the elementary Kummer
construction of these automorphisms, the placement of unknowns into
`E`, and the exhaustive geometric rank alternatives are mathematical
arguments in that report, not formal conclusions of these declarations.

## Boundary identities

`fractional_discriminant` proves the exact polynomial identity
`(4-2*b)^2-4*b*b=16*(1-b)` for every `b : E`.
`excluded_unit_circle_square` proves the square identity at the
explicitly excluded value `b=1`, for nonzero `z : E`.
It is a boundary check and is not a counterexample under the manuscript
hypotheses. These two identities do not assert root existence or private
orders on an arbitrary curve.
