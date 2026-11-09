# Statement fidelity: the finite operator-path core

The declarations in `Main.lean` are in namespace `EnergyBootstrap`.
They do not formalize a vertex operator algebra, an unbounded operator,
Zhu convergence, Mobius covariance, the contraction limits, or strong
locality. The analytic application of this core is a separate argument
in `report.md`; a compiler success does not certify that application.

`graphSchur` quantifies over arbitrary finite left and right types, any
bipartite relation, arbitrary real path weights, and natural row/column
degree bounds r,s. It proves that the square of the sum of products on
the edges is at most r*s times the product of the two sums of squares.
Neither orthogonality of paths nor a bound on Hilbert-space dimension
is a hypothesis. The degree hypotheses are counts, not the inequality
under audit.

`tupleSumCount` quantifies over every natural n,M and every integer target.
Among tuples of length n+1 with entries in {0,...,M}, at most (M+1)^n
have that target sum. Its proof deletes one coordinate and proves the
resulting map injective using the sum equation. Targets outside the
possible range and n=0 are included.

`modeSumSchur` combines those two statements for arbitrary tuple lengths
p+1,q+1, every common index bound M, and every integer target for the
difference of the two tuple sums. The squared count factor is
(M+1)^(p+q), namely (M+1)^(left_length+right_length-2).
The weights are arbitrary real numbers. For the manuscript, specialize
them to the norms of the two operator paths. Constants attached to a
fixed monomial and its binomial coefficients are handled outside Lean.

`iteratedColumns` is an all-length composition result, not a scalar
contraction assumption. It quantifies over any type X, any finite mode
index type J, a real-valued squared-size function, and any finite list
of families of actual maps J -> X -> X with nonnegative column-bound
constants. The hypothesis gives each one-factor sum-of-squared-size
bound at every vector. The conclusion bounds the sum over all composed
paths by the product of those constants times the initial squared size.
Taking X to be the fixed spectral-cutoff Hilbert subspace and squared
size to be the squared norm gives the path-square estimates. Linearity
of the maps is not needed for this stronger elementary statement.

`rightPrefixBudget` and `rightEnergyCutoff` quantify over lists of natural
pairs (c_i,j_i), all prefix lengths, and arbitrary real initial and cutoff
energies h,N with h<=N. The energy increments are c_i-j_i; every prefix
has energy at most N+sum(c_i), irrespective of the j_i. In the application,
c_i=d_i-1 for right modes. Left adjoints have nonpositive increments
and are the zero-budget specialization. Real, rather than integer,
energies include modules with nonintegral lowest conformal weight.

`oneModeIndexBound` uses real input/output energies and natural c,j.
From input<=M, output>=0, and output=input+c-j, it proves j<=M+c.
It supplies the index bound only on a nonzero, nonnegative-energy path.
It does not assume a finite-support property for a full Mobius transform.

`mixedExponentIdentity` is the integer exponent equality after the
path-square estimates, completion counts, and derivative factors are
combined. It is an auxiliary algebraic identity, not a proof of the
operator inequality in isolation.

The source introduces no new axioms and uses no proof placeholders.
Independent review still has to check this translation and its analytic
use in the manuscript audit.
