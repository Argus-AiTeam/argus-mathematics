# Fidelity of `Main.lean`

Claim: `L_TRANSPORT`. The source imports Mathlib, not the upstream OpenAI
Comparator files. It proves conditional algebraic theorems, not a formal
verification of all entries of the pencil or of the secret-key theorem.

`full_spark_over_extension` quantifies over fields F and K, a finite
column type N, any row type T, an evaluation matrix over F, a base ordered
square submatrix with nonzero determinant, and a field embedding F -> K.
Its essential hypothesis is that, for every injective ordered selection of
rows, an automorphism of F sends each entry of the base submatrix to the
corresponding selected entry. Its conclusion is nonzero determinant for
every selected submatrix after applying the embedding into K. In the
application, F is the splitting field, K is C, N has ten elements, T has
twenty, and the S20 Galois action supplies the stated automorphisms.
This explicitly separates algebraic equivariance from arbitrary complex
coefficients.

`zero_bound_of_full_spark` assumes that every ten-row submatrix of a
20-by-10 matrix over an arbitrary field is nonsingular. It proves that a
nonzero coefficient vector has zero dot product with at most nine rows.
There is no restriction to rational or algebraic coefficient vectors.

`product_free_of_kernel_bound` works over an arbitrary field, finite
coordinate type I and finite direction type T. It assumes a symmetric
matrix Z indexed by I x I, that every vector E(t) tensor E(t) is in its
kernel, that each nonzero coefficient vector has at most `bound` zero
evaluations, and that card(T) > 2*bound. It proves that if Z*w equals
u tensor v, then u=0 or v=0, for every u, v, w. Tensor coordinates are
u(i)*v(j). The pairing is bilinear, not Hermitian. This is intentional:
the certificate constructs a real symmetric integer Z0, so its transpose
kernel identity is valid after scalar extension to C. No false
identification of complex transpose with adjoint is used.

`dimensionTen_from_galois_equivariance` combines all these steps for
twenty rows, ten columns and bound nine, over every field extension. It
has the same automorphism, base-determinant, symmetric-matrix and
kernel-product hypotheses, and proves product exclusion for all
coefficient vectors in K. Instantiating K=C gives exactly the universal
complex-linear bridge needed by the written certificate.

The compiler checks these deductions. It does not check the supplied
integer matrices, the rational multiplication representation, the
Frobenius theorem, the S20 calculation, the existence of the initial
nonzero minor, the PPT/Kraus identities, or the instantiation of the
hypotheses with the twenty algebraic points. Those are proved in
`research/dimension_ten.md` using `verify.py` and the explicit certificate.
Neither significance nor novelty nor independent review is compiler
verified.
