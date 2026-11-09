# Statement fidelity: Proposition prop:intersection

The declaration `CharPIntersection.prop_intersection` formalizes the
entire proposition in `03-intersection.tex`, not just the integration
identity or a bounded list of characteristics. Its parameters are an
arbitrary field `F`, an arbitrary natural prime `p` (`Fact p.Prime`),
and `CharP F p`. In particular `p = 2` is included.

## Objects and hypotheses

`CharPIntersection.PthPowers F p` is the actual subfield
`(frobenius F p).fieldRange` of `F`. Thus the formal coefficient field
is exactly `C = F^p`; it is not an unrelated perfect or algebraically
closed field. Its algebra map to `F` is its inclusion.

`FiniteDimensional (PthPowers F p) F` retains the source's finiteness
hypothesis `[F:C] < infinity`. The hypothesis `hdegree` is
`Module.finrank C (IntermediateField.adjoin C {X,Y}) = p^2`,
the manuscript's definition of p-independence. A monomial basis is
constructed from this degree equality; it is not an additional input
of `prop_intersection`.

The four elements `X,Y,U,V : F` are explicitly nonzero.
`hU` and `hV` say `U in C(X)` and `V in C(Y)`, using the actual
intermediate-field adjoin operation.

`Nonmonomial X U` means that for every `m : Fin p` and every `c : C`,
`U` is not `c * X^m`. Because `U` is nonzero, allowing `c=0`
changes nothing. This is equivalent to the manuscript's
`[U] notin F_p[X]` in the multiplicatively written exponent-p
quotient `F^x/C^x`: its scalar multiples have the representatives
`c * X^m`, `0 <= m < p`, `c in C^x`. The same definition is used
for `Y,V`. No condition on algebraic independence over an original
constant field is substituted for p-independence.

The elements `Z,s,t : F` encode the nonzero intersection witness.
All three are explicitly nonzero; `s in C(Y/X)`, `t in C(V/U)`,
`Z = X*s`, and `Z = U*t`. These are exactly the two memberships
in the displayed intersection of multiplicative translates. The
nonzero conditions on `s,t` are redundant given `Z != 0`, but are
retained in the source-facing theorem.

## Conclusion and declarations

`ExponentConclusion X Y U V` supplies a natural integer `n` with
`0 < n` and `n < p`. For both variables it supplies coefficients
in `C`, each explicitly nonzero, with
`U^n = a+b*X^n` and `V^n = c+d*Y^n`.

Its last conjunct quantifies over every natural `r` with
`0 < r < p`. If **either** `AffinePower X U r` **or**
`AffinePower Y V r` holds, then `r=n`. `AffinePower` permits zero
coefficients, so this is uniqueness from either unqualified
inclusion `U^r in C+C*X^r` or `V^r in C+C*Y^r`, not a weaker
uniqueness statement restricted in advance to nonzero coefficients.
Existence plus this last conjunct implies uniqueness of the common
exponent as well. Coefficient nonvanishing for the valid exponent
is included explicitly.

`intersection_exponent` proves a slightly more general theorem:
the coefficient field may be any embedded field containing every
p-th power of the ambient field, and the ambient extension need not
be finite. `prop_intersection` specializes it to the actual
p-th-power subfield with the original finiteness hypothesis.
No novelty or publishability claim is encoded.

The proof constructs `coordinateField`, proves it is `C(X,Y)`,
and constructs its p-squared-element `Basis` from `hdegree`.
`euler` proves the product rule for diagonal coordinate operators,
and `joint_eigenvector` proves their joint eigenspace
classification. `common_logarithmic_weight` eliminates the
witness derivatives to force a shared logarithmic derivative;
`Chart.common_weight` derives its constant value and the common
nonzero monomial weight. None of those eigenvalues, weights, or
monomial conclusions is assumed in the source-facing theorem.
`integrate_correction` constructs `n=p-m`, proves the relevant
denominator nonzero, and gives both nonzero coefficients.
`affine_forces_weight` and `unique_exponent` prove uniqueness
without assuming the answer.

## Verification boundary

The kernel checks the full field-algebra argument, including the
basis construction, Euler derivations, common weight, integration,
and uniqueness. The final declaration prints its axioms so a replay
can reject an accidental `sorryAx` dependency. The intended logical
axioms are only Mathlib's standard `propext`, `Classical.choice`,
and `Quot.sound`.

The compiler cannot verify that this English reading matches the
manuscript, the translation of multiplicative quotient notation
into `Nonmonomial`, or a judgement of novelty. Those require the
host-invoked independent Reviewer. Nothing here formalizes
Milnor K-theory, recovery of projective lines across different
pairs, or the manuscript's reconstruction theorem.
