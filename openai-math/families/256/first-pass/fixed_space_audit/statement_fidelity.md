# Fidelity of the universal algebraic core

This document describes claim `L_FS_FORMAL`, not a formalization of the
topological fixed-space theorem `C_FS`. All formal declarations are in
namespace `FixedSpaceAudit` in `Main.lean`. Scalars are exactly the rational
numbers. No assertion here is inferred from a finite numerical test.

## Objects and quantifiers

`LayerIndex t` is the disjoint union of `Fin (t a)` over `a : Fin m`, for
arbitrary natural `m` and arbitrary natural layer sizes `t a`. Empty layers
and an empty set of layers are allowed. Its cardinality is the number `N`
of exterior generators. There are no positivity, equal-size, genericity,
or bounded-size assumptions.

`layerFiberEquiv` identifies one layer with the corresponding fiber of the
disjoint-union projection. `det_layers` states, for every family `M a` of
square rational matrices of these possibly unequal sizes, that the determinant
of `Matrix.blockDiagonal' M` is the product of their determinants.
`orderedLayers` reindexes BOTH axes of this matrix by the SAME equivalence
with `Fin N`; `orderedLayers_det` proves that this does not change the
determinant. The equivalence need not be order-preserving.

`coordinateVolume N` is the canonical pairing with the wedge of the `N`
coordinate covectors on `Fin N -> Q`. `topValue N` first projects the exterior
algebra onto exterior LENGTH `N`, then applies that covector. It is not a
projection by the weighted cohomological degrees `2a-1`.
`volume_wedge` and `topValue_wedge` prove that evaluating this functional on
the exterior product of the ROW vectors of any `N` by `N` matrix gives its
ordinary determinant.

## Main conclusions

`filtered_coefficient` identifies the actual exterior top coefficient of
the rows of the block-diagonal matrix with the product of all layer
determinants. `filtered_coefficient_nonzero` proves this coefficient is
nonzero if EVERY layer determinant is nonzero.
`filtered_wedge_nonzero` also proves that the exterior product itself is
nonzero. `weighted_filtered_nonzero` allows multiplication by any finite
family `c : Fin n -> Q` of nonzero rational coefficients. This family may
also be empty.

`prefixMinor t ht B a` is the initial `t a` by `t a` square submatrix of an
arbitrary rational `r` by `r` matrix `B`; its only size hypothesis is
`ht : forall a, t a <= r`. `nested_minor_nonzero` instantiates the universal
coefficient theorem with these submatrices, assuming their determinants
are nonzero. In the manuscript application, first restrict the original
rectangular matrix to the chosen `r` columns IN PIVOT ORDER, then take
`t a = |{i : k_i >= a+1}|`. The formal theorem assumes the required minors;
it does not construct the pivot columns or prove row rank.
The manuscript's factor vectors have coefficient matrices equal to the
TRANSPOSES of these minors. Apply `filtered_coefficient` to those transposed
layer matrices; their determinants are unchanged. Equivalently, apply
`nested_minor_nonzero` to the transpose of the selected square matrix.
The identification with the original occurrence lists, including this
transpose, is proved in the report rather than encoded in Lean.

`topValue_homogeneous` annihilates ANY homogeneous exterior-length `s`
element when `s < N`. `homogeneous_product` proves that a finite ordered
product of homogeneous elements has length equal to the sum of their
lengths. `shorter_products_vanish` combines these facts: every such ordered
product with total length strictly below `N` has top coefficient zero.
This is the algebraic reason shorter incidence terms cannot contribute.
The theorem does not assume commutativity of the exterior multiplication.

## What remains mathematical rather than formal

The report proves the identification of the manuscript's exterior factors
with the layer matrices. Moving the original column-ordered factors and
the source generators into layer order introduces orientation signs;
the formal equalities use the SAME reindexing on both matrix axes and
therefore do not assert an unsigned equality in arbitrary original
orientations. The report gives the precise sign for its stated convention.

The formal source does NOT encode unitary groups, rational singular
cohomology, primitive generators, incidence manifolds, Poincare duality,
transversality, arbitrary fixed unitary matrices, or the existence of an
intersection. It does NOT prove the arbitrary-group nonsingular-system
theorem. Those are distinguished explicitly in the report and claim
ledger. A successful Lean run supports `L_FS_FORMAL`, not those topological
claims by itself.
