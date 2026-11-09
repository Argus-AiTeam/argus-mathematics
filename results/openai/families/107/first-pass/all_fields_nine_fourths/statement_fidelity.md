# Statement fidelity: finite-extension restriction descent

Claim: `AF_DESCENT_CORE`. Source: `Main.lean`. Lean version: 4.31.0.

The principal declaration is
`AllFieldsNineFourths.finite_extension_restriction_descent`.
`F` and `E` are arbitrary fields with an `F`-algebra structure on `E`.
`D` is a finite index type and `b : Basis D F E` is an actual basis.
Thus the extension degree is `card D`; separability, characteristic zero,
and nonvanishing trace are NOT hypotheses.

`I,J,K` are arbitrary finite source-leg index types. `X,Y,Z` are arbitrary
target-leg index types. The source coefficient array is
`a : I x J x K -> F`. The target coefficient array is
`target : X -> Y -> Z -> F`. The three substitution arrays `u,v,w`
have values in `E` and depend only on their own source and target leg.
The hypothesis `h` states, at EVERY target coordinate, that these
substitutions take the source to the target after embedding `F` in `E`.
Embedding is written as scalar multiplication of `1 : E`.

The conclusion constructs an `F`-linear functional `ell : E -> F` with
`ell(1)=1`. For every target coordinate it gives the explicit sum over
`(s,t) : D x D` of restrictions of the SAME source array. The first map
is the `s` basis coordinate of `u`, the second the `t` basis coordinate
of `v`, and the third is `ell(b(s)b(t)w)`. In particular the third map
does not depend on either of the first two source indices. This is the
independence needed to interpret each summand as one tensor restriction,
not merely an unrestricted sum of coordinate identities.

`AllFieldsNineFourths.number_of_source_copies` proves that this index
set has exactly `(card D)^2` elements. The usual direct-sum substitution
identifies each pair's target legs; this interpretation is explained in
the mathematical report. The source does NOT introduce an abstract tensor
restriction relation or a rank function: it proves the full coefficient
formula from which the direct-sum restriction follows.

The formal quantifiers allow arbitrary source and target dimensions, so
the same theorem applies to each tensor power with the SAME `E` and
the SAME `D`. Consequently the number of copies remains `e^2`, not
`e^(2j)`. There is no separate formal tensor-power construction.

Supporting declarations are `normalized_functional`,
`functional_product_expansion`, `restriction_descent_formula`, and
`sum_three_swap`. The normalization existence theorem works for any
field extension; its finite basis is needed only for the finite sum.

`AllFieldsNineFourths.mismatch_weight_identity` is additionally proved
over every commutative ring. It identifies the separation weight minus
the square mismatch with the Fourier-relation multiple. Positivity of
integer weights is a separate argument in the report, not a notion of
order on a finite field.

The full tensor restriction interpretation is claim `AF_DESCENT`.
The complete all-field matrix-multiplication theorem, interpolation
limits, character existence, entropy counting, profile inequalities,
and arithmetic recursion are proved in prose in `report.md`; they are
NOT claimed to be formalized by this file. Compiler acceptance verifies
the stated coefficient identities, not the prose interpretation,
originality, significance, or the entire exponent theorem.
