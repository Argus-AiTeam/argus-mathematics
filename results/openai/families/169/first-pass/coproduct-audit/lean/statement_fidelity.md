# Statement fidelity: actual coefficient lifts and polynomial descent

The ledger claim `K_POLYNOMIAL_IMAGE_DESCENT` is represented by
`CoproductAudit.polynomial_image_descent`.

The declaration names are `polynomial_image_descent`,
`constant_lift_unique`, `polynomial_kernel_cancellation`, and
`evaluated_kernel_cancellation`, all in namespace `CoproductAudit`.

`V` and `W` are arbitrary types with distinguished zeros. `T : V -> W`
preserves zero and is injective. This is stronger generality than the
claim's rational-linear setting. `c : Int -> V` is an **already
constructed** coefficient family. `q : Nat ->_0 W` is a finitely
supported family, hence the coefficient representation of a
`W`-valued polynomial in one extra variable. The hypothesis says that
`T(c_j)` is `q_j` when `j >= 0` and is zero otherwise.

The conclusion constructs a finitely supported nonnegative coefficient
family `p` in `V`, whose coefficient at every `n` is `c_n`, proves
`c_j=0` for every negative integer `j`, proves coefficientwise
`T(p)=q`, and includes the constant-coefficient identity. There is no
surjectivity assumption on `T` and no inference from polynomiality
alone: the actual lifts `c_j` are essential input.

For the coproduct application, `V` is the weight-`w` associated grade
of `B_a tensor B_b`; `W` is the family of independent refinement-symbol
targets, regarded as a vector space; `T` is their jointly injective
map; `c_j=[C_j(f)]`; and `q` is the coefficient polynomial of the
concatenated source symbol after shifting the first group of centers
by `Z`. There are finitely many refinement lists at fixed dimension.
The compiler does **not** establish that these particular manuscript
objects satisfy the hypotheses. Their construction, quotient descent,
filtration preservation, and matching of symbols are proved in
`report.md` and require independent mathematical review.

`CoproductAudit.constant_lift_unique` formalizes the uniqueness of
the constant coefficient under injective tests.

`CoproductAudit.polynomial_kernel_cancellation` additionally proves
`(-X)(-divX F) = F - C(coeff_0 F)` for every univariate polynomial
over every commutative ring, including rings with nilpotents.
`CoproductAudit.evaluated_kernel_cancellation` proves the same
identity after substituting any ring element for `X`. Taking the
coefficient ring to contain the other variables gives the exact
kernel cancellation used for the diagnostic's arbitrary polynomial
tail. These declarations do not formalize its destabilizing ideal,
the classification of all filtration pieces, or the full manuscript
coproduct theorem.

No theorem here states elementary positivity, novelty, or independent
Reviewer acceptance.
