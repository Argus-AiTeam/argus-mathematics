# Statement fidelity for GL-FORMAL9000201

The declarations in `Main.lean` certify three algebraic steps, not the entire
manuscript or the entire GLOBAL9000201 theorem. They have no `sorry`, custom
axioms, or imported manuscript hypotheses. Standard Mathlib definitions and
theorems are used.

## Characteristic-zero coefficient step

`GlobalRelations.coefficient_zero_of_vertical_derivative` quantifies over a
characteristic-zero field K, an index type with decidable equality, an arbitrary
coefficient function c from exponent arrays to K, a set of vertical indices,
an exponent array beta, and a vertical index j with beta(j) nonzero.

Its hypothesis is the exact coefficient formula for a zero partial derivative:
for every exponent array gamma and vertical j,

    (gamma(j)+1) c(update gamma j (gamma(j)+1)) = 0.

Its conclusion is c(beta)=0. The companion
`coefficients_supported_on_horizontal_coordinates` says that every nonzero
coefficient has exponent zero at every vertical index. For a finite index type
this is precisely the coefficientwise step from G_z=0 to G=G(y) in report
Section 8. The formal statement does not construct a power-series ring, a
formal coordinate inverse, a Jacobian, or a scalar eigenvalue branch. Those
identifications and the derivation of the zero partials are proved in prose.
Using arbitrary arrays does not add a hidden support or convergence assumption;
the formal assertion is algebraic, and the application uses finite coordinates.

## Polynomial translation step

`GlobalRelations.translate` is the polynomial substitution X_i -> X_i+a_i
over an arbitrary commutative ring. `translate_inverse` proves that translating
by -a after translating by a recovers every multivariate polynomial.
`translate_zero_iff` proves that a translated polynomial is zero exactly when
the original polynomial is zero. `polynomial_identity_at_every_array` says that
such a polynomial identity then evaluates to zero at every array of ring
elements.

In report Section 8 the ring is the field E(U), a is the generic upper-arrow
array U, and p is one covector applied to one column of J(V). The formal theorem
justifies polynomial descent by S=V-U; it is not a theorem permitting arbitrary
substitution into an infinite Taylor series. It does not prove that the
manuscript's Jacobian is polynomial, that formal-series embedding is injective,
or that coefficient-matrix rank is preserved by scalar extension. Those are
separate steps in the universal prose proof.

## Exact response graph

`GlobalRelations.exact_negative_pair_graph` quantifies over a field K and
arbitrary K-modules V, P, Q, C, two K-linear maps from V to the endpoint spaces,
and linear equivalences betaP:P->C and betaQ:Q->C. It assumes that the left
endpoint map is onto and that betaP(left(v))+betaQ(right(v))=0 for every v.
It proves that the joint image consists exactly of

    (p, -betaQ^{-1}(betaP(p))).

`other_endpoint_surjective` derives that the right endpoint is onto as well.
Neither finite dimension nor a positive dimension is required. Zero modules
are included, which covers the g=0 graph case.

In report Section 9 the common module C is G_I^*, the equivalences are the
duals of compatible covector projections, and V is the reverse-arrow
parameter space after quotienting the loop images. The common space,
equivalences, and endpoint onto-ness are established in Sections 5--9, not
assumed as the conclusion of GLOBAL9000201. The compiler checks the resulting
linear-algebra implication; the universal manuscript-to-module translation
and the independent mathematical review remain outside its verdict.
