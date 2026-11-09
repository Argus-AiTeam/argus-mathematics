# Statement fidelity: C_FP_CORE

The source is `research/four_path_audit/Main.lean`, namespace
`FourPathAudit`, for Lean 4.31.0 with the installed Mathlib. The claim
certified by this source is the universal relaxed-pairing count and
coincidence-factorization core, not the full operator moment inequality
or the asymptotic circuit lower bound.

## Objects and the exact count

`w` and `n` are arbitrary natural numbers. `n` is the number of internal
vertices, so the number of layers is `d=n+1`. A pairing word is an
arbitrary function `tau : Fin (n+1) -> Bool`, with `false=N` and `true=D`.
There is no hypothesis `w=d`, no large-parameter hypothesis, and no
balanced-schedule hypothesis.

`Labels w` is the tuple `((P,Q),(R,S))` of four labels in `Fin w`.
`paired false` requires `P=Q` and `R=S`; `paired true` requires `P=R`
and `Q=S`. In particular D does not require distinct coordinates:
this is exactly the relaxed model, not the original disjoint N/D
classification.

`Vertex w a b` is the subtype of four labels satisfying both adjacent
pairings. `nnEquiv`, `ddEquiv`, `ndEquiv`, and `vertexSwap` explicitly
identify the four cases with two free labels or one free label.
`vertex_card` proves cardinality `w^2` when `a=b` and `w` otherwise.

`Assignments w tau` is the dependent product of these constrained vertex
types, one for each internal vertex. `switches tau` is the sum of the
0/1 indicators that adjacent pairing letters differ. Thus it is the
manuscript's switch count, not the number of N layers or V layers.
`exponent_identity` justifies the natural-number subtraction in
`2*n-switches tau`.

For `hw : 0<w`, `FixedQuadruples w n hw tau` consists of actual four-label
sequences at all `n+2` vertices. The first and last four-label tuples are
the fixed tuple with all entries `0 : Fin w`, corresponding to manuscript
label 1. For each layer, its pairing is required at both ends.
`assemble`, `assemble_valid`, and `fixedQuadruplesEquiv` construct the
two-sided inverse between this constrained path space and `Assignments`.
This includes the endpoint conditions; the path-to-product
correspondence is not assumed.

`fixed_quadruple_count` proves, for every `w,n,hw,tau`,

```
card (FixedQuadruples w n hw tau) = w^(2*n-switches tau).
```

The theorem also covers `n=0` (one layer and no internal vertices).
The formal path model uses every possible matrix edge; it is not a
statement about sparse or restricted-support matrices.

## Exact factorization on the actual path space

`average f` means `sum f / card(domain)` in the rational numbers.
`diagonal` compares P and R at a vertex. `layerCoincidence` requires
this equality at both end vertices of a layer, and hence is exactly
equality of the P and R matrix-entry coordinates. In an N layer those
are the two coordinates called `i,j` in the manuscript.

`NNSite tau` is the subtype of internal vertices for which both
adjacent pairing letters are N. `coincidenceSupport tau t` contains
exactly the NN vertices at positions `t` or `t+1`, when layers are
indexed from zero and internal vertex `j` has position `j+1`.
Its cardinality is the manuscript's `h_t`.

`vertex_diagonal_iff` proves that P=R is automatic at every other
internal vertex. The external vertices also satisfy it automatically.
`layerCoincidence_iff` proves that actual layer-coordinate coincidence
is equivalent to passing all diagonal tests in this support. This
equivalence is a theorem, not an additional fidelity assumption.

`nnSplit` and `nnSplit_quad_apply` split the actual assignment space
into its NN pair coordinates and an unused residual factor, preserving
the two tested labels. `diagonalEquiv` and `diagonal_sum` count all-diagonal
blocks rather than assuming a success probability. `regroup` explicitly
reindexes ungrouped site assignments by the fibers of an owner map.
`average_pi` proves finite Fubini using the product-of-sums identity.
`disjoint_support_factorization` derives the generating function for
arbitrary pairwise disjoint supports. `nonadjacent_supports` proves
that supports at endpoints of nonadjacent layers are disjoint.

The main factorization declaration is `fixed_quadruple_factorization`.
In addition to `w,n,hw,tau`, its parameters are:

- an arbitrary finite set `v` of selected natural-number layer indices;
- `hbound`, saying every selected index is less than `n+1`;
- `hv`, saying no selected index has its successor also selected;
- an arbitrary rational coefficient `c t` for each selected layer.

Its conclusion is exactly

```
average_(q in FixedQuadruples)
  prod_(t in v) (1+c_t*1_(layerCoincidence(q,t)))
 =
prod_(t in v) (1+c_t/w^card(coincidenceSupport(t))).
```

Empty supports and empty selections are included. Rational coefficients
may be negative, zero, or positive. Disjointness and independence are
not hypotheses of this theorem: they are derived from `hv`, the explicit
path-to-product equivalences, and finite summation. The theorem even
allows selecting D layers; their P/R coincidence is forced and their
support is empty. The manuscript application selects only N layers
that are in V and takes `c_t=alpha^(-1)>0`.

## Additional algebra and limits of the certification

`repeated_v_expansion`, `repeated_u_expansion`,
`normalized_v_repeated`, `normalized_v_different`,
`normalized_u_repeated`, and `normalized_u_different` certify the
displayed rational polynomial identities, with the nonzero-denominator
hypotheses written explicitly. These are algebraic identities, not a
formal construction of geometric random variables.

The Lean source does not define polynomial differentiation, factorial
Gram matrices, weak compositions, geometric laws, the trace expansion,
or the relaxed-weight upper inequality. Those parts are proved in
`report.md` and independently exercised by `verify.py`; they must not be
described as kernel-certified. The asymptotic parameter, word-sum, and
circuit-rank estimates are not certified by any declaration here.

The source uses no `sorry`, no `admit`, no new axiom, and no
computation-deciding oracle. It uses standard Mathlib finite-set algebra
and classical choice to select an owner for disjoint supports. Compiler
success verifies the encoded declarations, not this explanatory
translation; an independent Reviewer must check this document and the
link from the formal core to the complete prose reduction.
