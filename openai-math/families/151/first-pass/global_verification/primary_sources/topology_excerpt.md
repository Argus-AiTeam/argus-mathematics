# Primary topology propositions used

Allen Hatcher, *Algebraic Topology* (2002), ISBN 9780521795401.
Source opened: https://pi.math.cornell.edu/~hatcher/AT/AT.pdf.
The following short transcriptions normalize mathematical typography.

Theorem 2.10, page 111:

> If two maps f, g: X -> Y are homotopic, then they induce the same
> homomorphism f_* = g_*: H_n(X) -> H_n(Y).

Proposition 2.30, page 136, in the preceding setup of a map
`f:S^n -> S^n`, `n>0`, with a point whose preimage is finite:

> deg f = sum_i deg f|_(x_i).

Lemma 2.49, page 154:

> If f: S^k -> S^k has degree m, then f_*: H_k(S^k; G) -> H_k(S^k; G)
> is multiplication by m.

Corollary 3B.7, page 276:

> If F is a field and X and Y are CW complexes, then the cross product
> map h: direct_sum_i H_i(X; F) tensor_F H_(n-i)(Y; F) -> H_n(X x Y; F)
> is an isomorphism for all n.

The preceding Theorem 3B.6 states naturality for maps of the two factors;
its proof identifies the product cellular chain complex with the tensor
product. Here every factor is a finite CW complex and the coefficient
ring is the field of real numbers, so no Tor hypothesis is omitted.
