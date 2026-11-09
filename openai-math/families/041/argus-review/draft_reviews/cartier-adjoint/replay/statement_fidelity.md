# Statement fidelity: explicit Cartier-adjoint clearing

Claim: `C_ADJOINT`.

`CartierClearing.cartier_clearing` universally quantifies over a field `K`,
natural characteristic parameter `p`, finite number `n` of coordinates,
and a finite type `J` of operator terms. The intended instantiation is every
prime `p` and every finite p-basis field. `PBasisCartier K p n` explicitly
carries coordinates, integer-linear coordinate derivations, their values on
the coordinates, a p-monomial spanning expansion for every element of K,
an additive Cartier map, and its coefficient-extraction rule on every
p-monomial times every p-th power. These are the p-basis/Cartier data, not an
assumption that Cartier annihilates derivatives or that clearing works.
Uniqueness of the expansion is unnecessary for the theorem.

`cartier_partial_zero` proves from those data and `CharP K p` that Cartier
annihilates every coordinate derivative, including derivatives of rational
elements. `monomial_derivative` and `pth_power_derivative_zero` supply its
algebraic calculation. No specific prime, dimension, polynomial degree, or
finite search bound is encoded.

`applyWord d [i1,...,ir] x` means
`d i1 (d i2 (... (d ir x)))`. `adjointCoeff` moves the outermost derivative
first onto the coefficient with a minus sign, and consequently reverses
the derivative order. `word_adjoint` proves the Cartier integration-by-parts
identity for every finite word; it is not assumed. Derivations need not
commute for this statement. In the coordinate application they do commute,
so the coefficient is `(-1)^|alpha| partial^alpha c`.

The theorem takes arbitrary subrings `A <= R <= K`. The base coefficient
ring A is assumed stable under the coordinate derivatives. R is not
assumed stable, smooth, normal, complete, or unramified. The coefficients
`c j` belong to A, the multiplier g and the factors `t j` belong to R,
and s is an arbitrary element of K, not an element of R.

The scalar identity is exactly
`s = sum j, c j * applyWord partial (w j) (g * t j * s)`.
The additive map `psi : R ->+ R` is assumed to satisfy, after the injective
subring inclusion into K, `psi r = Cartier(s*r)` for every r in R.
This is the manuscript's `bc:relative-cartier` formula. The theorem does
not assume the desired unit test, trace detection, regularity of s, or any
normalization-degree bound.

The conclusion supplies an actual T in R, identifies its image in K with
`sum j, t j * adjointCoeff partial (w j) (c j)`, and proves
`psi (g*T) = psi 1`. `cartier_clearing_noncontainment` then proves that for
every ideal I not containing `psi 1`, the image `psi(g*R)` is not contained
in I. Taking I to be the maximal ideal at any closed point and
`psi 1 = delta` a nonzero constant gives the exact conclusion of
`bc:clearing-test`.

Not formalized here: construction of the geometric p-basis and Cartier
data, existence of retained reductions, the relative geometric trace
formula, generation of the differential identity by Hodge modules,
or any upstream/downstream manuscript theorem. Those geometric inputs
are explicitly distinguished in `proof.md`; they are not consequences
claimed from compiling this source. The separate completion/field-trace
audit is a prose proof, not a Lean theorem in this file.
