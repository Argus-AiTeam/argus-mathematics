# Formal statement fidelity: C_OP_ALGEBRA

`Main.lean` formalizes part of the Hilbert-space core of the operator-square
argument, not the entire probability theorem C_OP_CORE. All four spaces are
arbitrary complete complex inner-product spaces, with no finite-dimensionality,
surjectivity, inverse bound, or identification between the four spaces.

The arrow types are H2 -> H1 for F, H4 -> H3 for G, H3 -> H1 for K,
and H4 -> H2 for N. Thus they agree with the manuscript's restricted row A,
row B, column s, and column t operators, respectively. Composition is read
right to left, and the dagger is the Hilbert-space adjoint.

All the following declarations are in the namespace `OperatorSquare`.

* `rectangle_squares` assumes exactly FN = KG and F* K = N G*.
  It proves the four typed identities KK* F = F NN*, K* K G = G N* N,
  F* F N = N G* G, and FF* K = K GG*. It assumes no positivity or
  invertibility beyond what an adjoint square automatically has.
* `fixed_target_squares` quantifies over arbitrary parameter
  types X, C, D, with D nonempty. If the F ranges have dense linear span
  and KK* F = F NN* for every parameter triple, all target squares KK*
  agree. The probability proof must still justify the passage from
  almost-everywhere independent parameter triples to this totality argument.
* `total_adjoint_fixed_square_injective` assumes F_i* F_i = S
  for every i, and that only the zero vector is orthogonal to every adjoint
  range. It proves injectivity of S. This does not assert a bounded inverse.
* `cancel_dense_range` proves S A = T A implies S = T
  when A has dense range. Dense range is an explicit hypothesis, not a
  consequence of mere injectivity for a general operator.
* `contraction_projection` concerns a bounded complex-bilinear map C
  (no bound of one on its norm is assumed), three bounded maps P0, P1, P2,
  and idempotence of P2.
  From the two one-input projection identities it proves the two-input
  identity P0 C(g,h) = C(P1 g,P2 h). The conditional-integral formulas and
  the two one-input identities are proved in the accompanying mathematical
  argument; they are not proved by Lean.

There are no added axioms, proof holes, conditional probability definitions,
almost-everywhere quantifiers, polar decompositions, compact-group
classification, tensor-span completeness, or passage to full k-coordinate
exactness in this formal source. Those analytic and measurable steps are
claims for independent mathematical review in
`research/operator_square/theorem.md`. Neither the finite experiment nor
this compiler run is advertised as a formal proof of C_OP_CORE or of
Rokhlin's multiple-mixing conjecture.
