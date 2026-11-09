# Statement fidelity: CutSymbol

The source `Main.lean` formalizes the arithmetic and finite-set core of
`C_CUT_CORE`, not the complete BFN theorem or the complete symbol-surjection
argument. There are no assumptions about bounded ranks or bounded exponents.

All declarations are in the namespace `CutSymbol`. Their unqualified source
names are `rootExcess`, `framingExcess`, `excess_nonnegative`,
`root_excess_disjoint`, `framing_excess_disjoint`, `support_length`,
`overlap_strictly_lowers_length`, `oriented_root_sign`,
`finite_sign_product`, and `finite_root_excess`.

`CutSymbol.rootExcess ad ae bd be` is the integer
`max(ad-ae,0)+max(bd-be,0)-max(ad+bd-ae-be,0)`. In the manuscript these are
the excess exponents for one arrow, after splitting sizes into `a` and `b`.
The common shift by minus one in `alpha=a-1` cancels in arrow differences.
`CutSymbol.framingExcess a b` is
`max(a-1,0)+max(b,0)-max(a+b-1,0)`, the framing excess.

`CutSymbol.excess_nonnegative` quantifies over every pair of integers and
proves that the positive-part excess is nonnegative. Thus all multiplication
coefficients under discussion are polynomials, not rational functions.

`CutSymbol.root_excess_disjoint` quantifies over all four nonnegative
integers `ad, ae, bd, be` subject to `ad=0 or bd=0` and `ae=0 or be=0`.
It proves the exact equality of the root excess to
`min(ad,be)+min(bd,ae)`. A selected/unselected cross pair gives the minimum
of its two positive sizes; all same-side or zero-size pairs give zero.
This includes both directions of an arrow and same-color pairs.

`CutSymbol.framing_excess_disjoint` quantifies over all nonnegative integer
sizes `a,b` with at least one zero. It proves that the framing excess is
one exactly when `b>0`, otherwise zero. It does not assume that a zero-sized
slot is selected.

`CutSymbol.support_length` proves the union/intersection cardinality
identity for every two finite sets of an arbitrary type.
`CutSymbol.overlap_strictly_lowers_length` adds the hypothesis that their
intersection is nonempty and concludes that the union cardinality is
strictly smaller than the sum of their cardinalities. Applied to the two
nonnegative size supports, this is the strict support-length drop used in
the filtration; there is no use of reduced algebraic loci here.

`CutSymbol.oriented_root_sign` holds in every commutative ring, for every
two elements `x,y` and every two natural exponents `u,v`. It states
`(y-x)^u (x-y)^v = (-1)^u (x-y)^(u+v)`. In the manuscript `u` counts the
remaining arrows whose source is the selected slot, multiplied by the
minimum size, and `v` counts reverse arrows. This is the orientation
convention in the literal formula for `epsilon_S`.

`CutSymbol.finite_sign_product` holds for every finite indexing set,
every function of natural exponents and every family of ring elements.
It proves that the product of the signed factors has sign `(-1)` to the
sum of the exponents and the product of the unsigned factors. It covers
arbitrary numbers of arrows and framing weights, not a tested finite list.

`CutSymbol.finite_root_excess` sums the root identity over an arbitrary
finite indexing set with the same nonnegativity and disjointness
hypotheses at each index. Indices may encode directed gauge-slot arrows,
with repetitions distinguished, so there is no restriction on arrow
multiplicities. Empty finite sets are allowed.

The compiler does not prove that disjoint decompositions are the cosets
`H/H_S`, does not prove the generation or derivation argument, does not
formalize Reynolds averaging, and does not identify this abstract algebra
with BFN convolution. Those statements and their hypotheses are given in
`../proof.md` and require independent mathematical review. In particular a
successful compiler result for `C_CUT_CORE` is not a kernel proof of
`C_CUT_SYMBOL` or of the manuscript's main theorem.
