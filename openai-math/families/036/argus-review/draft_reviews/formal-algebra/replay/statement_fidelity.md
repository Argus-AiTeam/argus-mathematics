# What Main.lean certifies

Claim `C9000036-FROB` is the algebraic core of the audit, **not** a Lean
formalization of the geometric finite-data theorem or of any of the four
manuscript main theorems. All declarations are in namespace `FrobeniusCore`.
No new axioms or proof holes are allowed.

`weight_reduction` holds for every commutative monoid, every natural p,j and
every relation z^p=c. It proves the quotient/remainder power formula.
`constant_weight_projection` computes the constant basis coordinate of the
reduced monomial for p>0 over any coefficient type with zero and powers:
only p-divisible weights contribute. `coordinate_surjective` proves that a
surjection onto p-tuples remains surjective after selecting coordinate zero.
This models the torus step over an arbitrary, potentially nonreduced base
algebra; it does not assert that a geometric jet map is surjective.

`complement`, `complement_involutive`, `exponent_pair`, `degree_pair` and
`truncated_rank` formalize the complement permutation and cardinality of
exponents (Fin n -> Fin p). `coordinate_exponent_sum` proves over the
rationals that twice the sum of any coordinate exponent equals
p^n(p-1). This is the character-weight arithmetic underlying the total
first-Chern-class identity; the identification with Chern classes is in the
report, not Lean.

`jet_threshold` proves for all natural n,k,p with k>0 and
p >= (2n+2)(k-1) that (2n+1)(p-1) <= (2n+2)k floor(p/k).
It does not assume p prime.

`product_chord` proves, for every finite index set, nonnegative rational
a_i,b_i, and 0<=t<=1,

    product(a_i+b_i t) <= A+t(B-A),
    A=product(a_i), B=product(a_i+b_i).

`explicit_uniform_error` substitutes t=1/p for every rational p>=1.
`explicit_rank_threshold` derives the strict bound product(a_i+b_i/p)<L
from A<L and p>(B-A)/(L-A). Thus the uniform O(1/p) budget is proved,
not postulated. The geometric specialization uses the n factors
(a,c_0+1) and (a/d_i,1+c_0/d_i), with a=7 Lambda H^n and
d_i=l_i Lambda H^n. Establishing these factors from slopes and a flag
is a separate geometric proof in REPORT.md.

`filtration_sum_bound` is the exact finite weighted-sum inequality; it does
not introduce an extra factor for the number of graded pieces.
`evaluation_dimension_bound` bounds the dimension of a finite-dimensional
K-vector space with an injective linear evaluation into
Fin e -> Fin m -> K by e*m, for every field K and every natural e,m.
It does not construct the geometric evaluation map.

`evaluated_filtration_dimension_bound` takes an injective linear map from
V into a finite product of piece spaces and injective maps from piece j
into Fin(e_j) -> Fin(m) -> K. It derives finrank(V)<=sum(e_j)*m.
`floor_count_factor` and `flag_count_bound` derive the integer evaluation
counts, rather than assuming a polynomial upper bound for them.
For all positive natural p, nonnegative rational a_i and rational b_i>=1,
`flagCount` is the product of floor(p*a_i+b_i-1)+1.
`rank_from_evaluations` assumes sum(e_j)=p^n and the stated linear
injections with m=flagCount, and **derives**, without a numerical rank
hypothesis, finrank(V)<=p^(2n)*product(a_i+b_i/p).
The geometric factors above have b_i>=1. The geometric construction of
these injections, including choices of linear splittings for section
filtrations, remains in REPORT.md; it is not an implicit Lean axiom.

`product_mem_ideal_power` and `det_mem_power_of_columns/rows` hold in
every commutative ring, without a reducedness or characteristic assumption.
If the entries of all rows in a specified finite set Z belong to an ideal I,
the determinant belongs to I^(card Z). The ideal-power conclusion, not an
undefined valuation function, is what Lean proves. Existence of constant row
operations killing R-rank rows after residue-field reduction and the
identification of maximal-ideal powers with vanishing order at a smooth point
are explained in the report.

`explicit_order_threshold` proves the strict upper order budget from
80 epsilon<3/4 and p>2E/(3/4-80 epsilon). The finite-set product threshold
and this order threshold feed `multiplicity_contradiction` and
`finite_data_algebraic_obstruction`.

The final scalar contradiction theorem has explicit hypotheses bounding a rational variable
`rank` by R times the product and a rational variable `order` between
R-rank and R(80 epsilon+2E/p). They are interfaces to the geometric
arguments, not new axioms. For the finite evaluation model,
`rank_from_evaluations` supplies this rank inequality from linear
injections and exact integer counts. The scalar contradiction theorem
alone is therefore **not** a certification of the geometric target. In particular,
neither Langer's theorem, openness/spreading, the Frobenius filtration,
the flag section injection, the determinant line bundles, nor the
external-product upper-order argument is encoded in it. The complete
geometric proof must stand or fall on REPORT.md and independent review.
The source contains no axiom encoding the disputed uniformity or rank bound.

The formal scalars are rational. The report's error constants are rational
intersection data. The original epsilon and r are real and may be
irrational; applying rational algebra to them uses a rational budget
eta>epsilon with 80 eta<3/4 (and (14 eta)^n<1/4 if desired).
Existence follows from the strict real inequalities. No rationality
hypothesis is added to the geometric theorem.
