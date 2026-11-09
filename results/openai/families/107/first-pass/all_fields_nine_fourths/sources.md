# Source comparison

The source-comparison research thread retrieved public `openai/math` sources at
commit `4eaee87548250b2682affda7d05d947c05554bae`. Its comparison found that the
relevant staged comparator sources match that public version. This is source
inspection, not independent compilation of the public solution.

## Every-field comparator

The statement at `thm:main`, lines 3--10 of
`preprints/Staggered-extraction-for-exact-matrix-multiplication-over-every-field-September-24-2026/build/sections/introduction.tex`,
is:

> Over every fixed field \(\mathbb F\) ...
> \(\omega_{\mathbb F}<2.371054886006746<2.371054887\).

The field is fixed, including in positive characteristic. This is an exact
scalar-arithmetic result, not a bit-complexity assertion. Lines 57--69 explain
the field scope. `prop:numerical-certificate`, lines 177--188 of
`build/sections/parameters.tex`, encloses the ratio between
`2.371054886006745684` and `2.371054886006745685`.

[Versioned main statement](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/preprints/Staggered-extraction-for-exact-matrix-multiplication-over-every-field-September-24-2026/build/sections/introduction.tex#L3-L10).

## Complex comparator

`thm:main`, lines 72--88 of
`preprints/Complex-Matrix-Multiplication-Below-2.258-and-Rectangular-Bounds-September-24-2026/build/introduction.tex`,
begins "Over \(\mathbb C\)" and asserts
`omega < 2.258`, `alpha > 0.465`, and `w(0.709) < 2.092`.

Its `cor:characteristic-transfer`, lines 318--328 of
`build/rectangular/08-comparison.tex`, assumes characteristic zero or a prime
outside one finite exceptional set. Only the strict square and `k = 0.709`
bounds are transferred there. Lines 419--424 and 457--459 give a separate
characteristic-zero dual transfer, not an all-positive-characteristic claim.

[Versioned transfer statement](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/preprints/Complex-Matrix-Multiplication-Below-2.258-and-Rectangular-Bounds-September-24-2026/build/rectangular/08-comparison.tex#L318-L328).

## Public formal sources

At lines 13--16 of
`lean/OAI/LinearAlgebra/MatrixMultiplication/Main.lean` the headline is:

```lean
theorem complex_omega_le_nine_quarters :
    Arithmetic.omega ℂ ≤ (9 : ℝ) / 4
```

`AuxiliarySeparation/Main.lean`, lines 19--29, also states its arithmetic and
exponent results over the complex numbers. In contrast,
`FieldConstruction/Conditional.lean`, lines 11--41, has arbitrary-field
declarations assuming `NumericalConditions`, but concludes only
`omega_F < 2371054887 / 10^9`. It does not supply an all-field nine-fourths
theorem.

[Versioned headline](https://github.com/openai/math/blob/4eaee87548250b2682affda7d05d947c05554bae/lean/OAI/LinearAlgebra/MatrixMultiplication/Main.lean#L13-L16).

The public source specifies Lean `4.34.1`, not this campaign's `4.31.0`.
No public solution compilation or axiom-closure check has been performed here.
The comparator JSON mapping to solution declarations is not a compiler result.

## Priority limit

The bounded primary-source check did not retrieve a published theorem giving
every-field `omega_F <= 9/4`. That negative retrieval is not evidence of
originality. Novelty and publishable significance remain questions for
independent assessment.
