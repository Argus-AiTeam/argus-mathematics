# Statement fidelity: C_LATENT_RADICAL

## Exact field and scalar field

`LatentRadicals.RootPolynomial σ` is `MvPolynomial σ (ZMod 2)`.
`LatentRadicals.RootField σ` is its `FractionRing`: the explicit rational-function
field over F₂ in the independent indeterminates indexed by `σ`. There is no
specialization of these indeterminates and no algebraic-independence hypothesis
on some externally supplied family.

`LatentRadicals.squareSubfield σ` is the actual image subfield of the Frobenius
ring homomorphism `q ↦ q²` on that fraction field, not an arbitrary smaller
coefficient ring. `mem_squareSubfield_iff` proves that its elements are exactly
the squares of rational functions. The module structure in the conclusion is
the usual multiplication action of this subfield on the whole fraction field.

## Main formal statements

`LatentRadicals.squarefree_linearIndependent` proves, for **every type `σ`**,
linear independence over that square subfield of the monomials with exponent
vectors `d : σ →₀ ℕ` satisfying `∀ i, d i < 2`. Thus the exponents are finitely
supported and each is zero or one; all distinct squarefree monomials are
included, including the constant monomial. The polynomial monomials are mapped
into the rational-function field by its injective localization map.

`LatentRadicals.triple_linearIndependent` specializes this theorem, for
**every `r : ℕ`**, to the variables `Fin 3 × Fin r` and the family

    T_(0,j) T_(1,k) T_(2,l),   (j,k,l) ∈ Fin r × Fin r × Fin r.

This is the manuscript's three-row family after changing from one-based to
zero-based row and column indices. There is no upper bound, nonzero assumption,
or computational enumeration on `r`; `r = 0` is also covered. The proof that the
three row positions differ uses the fixed three-element row type only.

`squareVariable i` is the element `x_i = T_i²` of the square subfield.
`LatentRadicals.tripleRadical_sq` proves that each displayed product has square
`x_(0,j) x_(1,k) x_(2,l)` in the ambient field. This realizes the radicals as
actual roots, rather than adding formal square-root symbols.

## What proves the algebraic hypothesis

`even_add_squarefree_injective` proves uniqueness of the decomposition
`2a + u` with squarefree `u`, coordinate by coordinate. The coefficient theorem
`coeff_expand_mul_squarefree` and `polynomial_parity_separation` then extract
the coefficient of each parity class in a polynomial relation. Over F₂,
`MvPolynomial.expand_zmod` identifies expansion by two with squaring, giving
`polynomial_square_separation`.

The main theorem does **not** stop at polynomial coefficients. From any finite
linear relation whose coefficients lie in the square subfield, it selects
rational square roots of those coefficients. `IsLocalization.exist_integer_multiples`
clears their denominators using one nonzero polynomial. Multiplying the relation
by the square of that denominator yields the polynomial relation just proved
impossible. Injectivity of the polynomial-to-fraction-field map and nonvanishing
of the denominator recover the vanishing of every original field coefficient.

No linear-independence, p-basis, finite-degree, or genericity assertion is
assumed. The only axioms printed for the main declarations are Lean's standard
`propext`, `Classical.choice`, and `Quot.sound`; there are no proof holes or
user-supplied axioms.

The conclusion is stated directly over the requested square subfield; it does
not require identifying that field with a separately defined copy of F₂(x).
No coefficient-extraction or Boolean-evaluation closure theorem from another
file is imported or reproved, and no integration with the parent's separate
formalization is claimed here.
