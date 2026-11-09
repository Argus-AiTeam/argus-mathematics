# Statement fidelity: universal finite-family algebra

`Main.lean` formalizes the algebraic core, not the Gibbs integral or the
annular analytic theorem. It uses Mathlib over the complex and real
numbers. No theorem assumes the manuscript family inequality.

`gram` is the manuscript kernel T, for every finite index type I, every
edge type E (not necessarily finite), and every array u : I -> E -> C.
`kernel` is the sum over two independently labeled family indices of
u_i(e1) conj(u_i(e2)) conj(u_j(e3)) u_j(e4).
`kernel_factor` proves its factorization T(e1,e2) T(e4,e3).
`gram_swap` proves Hermitian symmetry. `contraction_table` gives the
eleven manuscript contractions, with l and m denoting the edges in the
remaining current factors. The last four H3X rows and the H4 row are
specializations with repeated edges. The local J coefficients and
subsequent sums over current edges are not encoded; distributivity
applies the pointwise identities before those sums.

`row_gradient` is the exact finite-sum identity expressing each kernel
row as the difference of its potential at the two endpoints. It
assumes arbitrary complex arrays, not probabilistic gradient bounds.

`wedge` is S(f,g) at one oriented edge. `wedge_skew`, `wedge_star`,
`diagonal_wedge_star`, `cross_pairing_star`, and
`gradient_adjustments` prove the antisymmetry, conjugations in the
response pairings, and the two gradient corrections without any
reality assumption on the test potentials.

`parity_cancellation` proves that three real coefficients fixed under
both indicated half-turn actions vanish. The mathematical report
establishes equivariance of the local logarithm and identifies its
fourth coefficient with those coordinates. Lean does not encode the
matrix logarithm or prove that analytic identification.

`eleven_term_lower` is the exact real accounting lemma: a nonnegative
square p, six errors bounded below by -t^4 c, four by -t^3 c, and one
by -t^2 c imply the stated total lower bound. It quantifies over all
real p,t,c and errors; in application t=sqrt(beta) and c=||T||_HS^2.
The error hypotheses are established using the Ward gradient
identity and Cauchy-Schwarz in the report, not by this formal source.

The compiler therefore certifies the universal conjugation and
contraction algebra. Universal differentiability, integration,
operator norm estimates, Fourier orthogonality, Taylor remainders,
the response transfer, and the periodic ODE argument require
independent mathematical review of `report.md`. A successful run
must not be described as a formalization of the whole annular theorem.
