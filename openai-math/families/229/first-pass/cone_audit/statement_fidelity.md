# Statement fidelity: rational sign-certificate soundness

This file describes only the declarations in `Main.lean`, namespace
`FourStateConeAudit`. It does not claim that Lean executes the C++ traversal
or proves the full four-state product inequalities.

All scalar variables are arbitrary real numbers. `remainder1` and
`remainder5` are polynomial identities without hypotheses. `taylor1` and
`taylor5` are precisely the degree-five Taylor polynomials at z=1 of
z^(-1) and z^(-5), respectively; their expanded coefficients are checked
separately against the binomial formula in `verify.py`. The remainder
identities give `reciprocal1_lower` and `reciprocal5_lower` for every z>0,
not merely for |z-1|<1. `quotient5` has coefficients [1,6,21,56,126].

`shifted_reciprocal_lower` quantifies over arbitrary N,z,m,t and natural k.
Its hypotheses are z>0, N+m*z^(k+1)>=0, and t<=1/z^k. Its conclusion is
the exact summand inequality used by Type T. It does not assume m>=0:
the stated nonnegative-factor hypothesis is what the proof needs.

`corrected_remainder_lower` quantifies over arbitrary N,z,J,c and natural k.
If z>0 and N-z^k*J+c*z^k>=0, it proves J-c<=N/z^k. No bound on J, and no
interpolation or truncation accuracy hypothesis, is needed. This is the
logical core of Type P; the executable separately checks the actual
coefficient remainder for its chosen interpolants.

`coefficient_nonnegative` concerns an arbitrary finite sum of real
coefficient-times-monomial values. Both families must be nonnegative
on the indexing finset. Its conclusion is nonnegativity of that sum.
Its application to homogeneous polynomial coefficients requires the
external identification of the stored arrays with monomials in
nonnegative barycentric coordinates.

`finite_certificate` sums arbitrary pointwise lower bounds over an
arbitrary finset. `typeT_sound` and `typeP_sound` combine the corresponding
summand lemmas with this finite-sum principle. Their index type is arbitrary,
so they apply in particular to the 24 permutations of four states.
The exact number and weight of the permutations are checked by the
executable and described in the mathematical report, not enumerated in Lean.
`average_normalization` removes the positive factor 24 from a real slack.

For the manuscript, row a uses k=1, m=3 and N=-|LU|^2; row b uses k=5,
m=1/2 and N=z^6*H(U/z). The Type T nonnegative-factor hypotheses follow
from A<=3 and H>=-1/2. For Type P, coefficientwise nonnegativity of
O+cQ supplies `hrem`, and the final coefficient test supplies `hbase`.
These identifications, scalar coefficient computations, midpoint coverage,
and zero-denominator continuous extension remain mathematical/executable
obligations outside this Lean source. The compiler result must not be
represented as a formalization of those unencoded obligations.
