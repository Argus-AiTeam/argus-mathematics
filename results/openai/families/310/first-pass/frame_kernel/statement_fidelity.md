# Statement fidelity: weighted factor marking

The declarations are in namespace `FrameKernel` in `Main.lean`.
The source is intended for Lean 4.31.0 with the host's built Mathlib.

`Factor` and `Label` are arbitrary types with decidable equality. A
`Monomial` is a finite set of distinct factors paired with one relation
label. An `Input` is a proposed appended factor paired with a monomial.
This models GOOD supporting-subspace components only: even factors
cannot repeat there either, because repeating a nonzero support is
not a direct decomposition. It does not purport to model every
monomial in the full supercommutative algebra.

`insertFactor` inserts the input factor and preserves the label.
`mark` constructs the output together with that very factor as a mark.
`mark_injective_on_fresh` PROVES injectivity on inputs for which the
factor was absent. Its inverse argument erases the marked factor
and reads the unchanged relation label. No injection, dimension
inequality, choice of bounded slots, or cardinal comparison is
assumed as a hypothesis.

`weighted_marking` quantifies over arbitrary FINITE input and output
families and arbitrary natural-number factor weights. Its two
hypotheses are freshness of every input and closure of every inserted
output in the output family. Its conclusion bounds the sum of input
factor weights by the sum of all factor weights in the output family.
It constructs the injection above, sums over its image, and embeds
that image in the finite family of output/factor pairs.

`weighted_capacity` adds a uniform bound on the total factor weight
of each output, and concludes input weight <= capacity * output count.
`homogeneous_relation_bound` replaces that hypothesis by the exact
homogeneity equation

    sum(output factor weights) + relationDimension = dimension.

It quantifies over ALL natural dimensions and relation dimensions,
not a finite tested range, and concludes the bound with capacity
`dimension - relationDimension` (natural subtraction).
`manuscript_bound` specializes the relation dimension to two and
deduces the manuscript's weaker capacity `dimension`.

The manuscript instantiation is specified and proved in `REPORT.md`.
Factors are homogeneous PBW basis elements of P(A), their weights
are dim(A), labels are the actual plane labels r_Q, outputs are the
leading module monomials of gr C(W), and inputs run over all independent
p in P(A), m in I(B) with W=A direct-sum B. Supporting subspaces recover
A and B uniquely. Freshness, insertion closure, homogeneity, and the
dimension/leading-term identifications are MATHEMATICAL bridge claims,
not Lean declarations in this file. In particular, this formalization
does not construct the manuscript's Lie superalgebra, formalize PBW,
compute C in all dimensions, or formalize finite-field isometry groups.

`logarithmic_coefficient_step` is the rational ordered-arithmetic step
after taking one coefficient of the formal-series identity. It assumes
that identity, the nonnegativity of the convolution coefficient, and
the marked-factor inequality for that coefficient. It proves dj <= dp.
The formal differentiation, completion, and convolution interpretation
are supplied in the mathematical report, not formalized here.

Thus a successful compiler run is an ALL-DIMENSIONS formal verification
of the constructed weighted-marking core and the scalar comparison,
not a formal proof of every bridge premise or of Quillen's conjecture.
Independent review of those premises and this reading remains necessary.
