# Statement fidelity for C374_CORE

`Main.lean` uses Lean 4.31.0 and Mathlib. All index types in the declarations
are arbitrary finite types, not fixed examples. Scalars are real. A vector
is a real-valued function on the finite coordinate type D, and `normSq` is
its Euclidean squared norm. `avg p f` is a finite weighted sum, not an
integral or a claim that the source body is discrete.

## Energy and finite coupling

`quadratic_identity` proves the exact vector identity, for a+b nonzero,

    |a x-b z|^2/h + 2a Phi(x) + 2b Phi(z)
      - (4ab/h) Phi((x+z)/2) = ((a-b)^2/h) R2,

where h=(a+b)/2 and Phi(x)=R2-|x|^2. The parameter R2 represents the
analytic source radius squared. `geometric_mean_coefficient` proves
ab/h <= g from a,b>0, g>=0, and g^2=ab. `midpoint_norm_identity` and
`sample_energy_bound` justify the signs of the midpoint defect and derive
the sample energy inequality; no moment-contraction conclusion is a hypothesis.

`weighted_jensen_scalar` and `weighted_jensen_vector` prove the finite
probability Jensen step from nonnegative weights summing to one.
`finite_midpoint_contraction` quantifies over all finite cell sets I,
all finite coupling sample sets J, and all finite coordinate sets D.
Each cell has positive masses a_i,b_i, a nonnegative g_i satisfying
g_i^2=a_i b_i, and its own probability weights p_i. Endpoint vectors
x_ij,z_ij satisfy squared norm at most R2. The only summed geometric input
is the midpoint quadratic-energy inequality:

    sum_i g_i E_i Phi((X_i+Z_i)/2)
      <= (sum_i [a_i E_i Phi(X_i)+b_i E_i Phi(Z_i)])/2.

The conclusion is

    sum_i |E_i(a_i X_i-b_i Z_i)|^2/h_i
      <= R2 sum_i (a_i-b_i)^2/h_i.

Thus the formalization includes the nontrivial vector quadratic identity,
probability averaging, and the complete finite-dimensional energy argument.
It does not posit the desired bound or prove only the manuscript's final
scalar estimate with constant 162.

## Symmetric face duality and intercept energy

`lap g q i` is sum_j g_ij(q_i-q_j).
`symmetric_green` proves its Green identity from symmetry of g.
`face_duality` uses arbitrary symmetric scalar face coefficients g and
symmetric vector face coefficients b (written coordinate first), together
with the actual fixed-mass equations

    lap g r i + sum_k lap (b k) (v_coordinate_k) i = 0.

It concludes sum_i r_i lap g q i =
-sum_ik v_ik lap (b k) q i, for every q.
No connectedness, nonnegative face coefficients, or inverse bound is
needed for this algebraic identity.

`weighted_cauchy` proves the weighted squared Cauchy--Schwarz inequality
for arbitrary positive weights. `intercept_energy_transfer` uses duality
and a moment-energy bound, with R2 nonnegative, to prove the weighted
intercept-energy bound.
`fixed_mass_intercept_energy` combines this with the proved symmetric face
duality, positive m_i, nonnegative R2, the qualitative solvability witness
lap g q i=m_i r_i, and the derivative moment bound for that q. Its
conclusion is sum_i m_i r_i^2 <= R2 sum_i m_i |v_i|^2.
This last theorem assumes the derivative bound exactly where the analytic
derivative limit supplies it; it does not pretend to derive that limit
inside Lean.

## Deliberate analytic boundary

The conditional-quantile coupling, Lebesgue measure domination, integration
of the identity for non-atomic couplings, differentiability of cell masses
and moments, connectedness and Laplacian range, prescribed-mass intercept
existence, and time/endpoint arguments are proved in
`sharp_moment_theorem.md`. They are not encoded as Lean theorems here.
Passing compilation certifies C374_CORE's finite-dimensional energy and
duality core only, not an end-to-end formalization of the universal analytic
theorem C374_MECHANISM or a formal literature-novelty claim.
