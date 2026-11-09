# Exact Gaussian collisions and unnormalized smoothing moments

## Statement under audit

The target is `h:proj:gaussian` in the staged *Memory and precision in
noiseless Gaussian regression*, September 27, 2026, `build/sections/projection.tex`,
together with `h:dv:gaussian-moment`. For integers d,m >= 1, k >= 2,
delta > 0, and arbitrary t_1,...,t_k in R^d, put q = k-1 and
D = [t_2-t_1,...,t_k-t_1]. The literal claimed value is

    E_A integral_y product_i phi_delta(y-A t_i)
      = (2 pi)^(-m q/2)
        det(D^T D + delta^2 (I_q + 11^T))^(-m/2).

Here A has independent standard real Gaussian entries and phi_delta is
the normalized m-dimensional Gaussian density of variance delta^2.
There is no full-rank hypothesis. The added noise matrix is strictly
positive definite even if every t_i is equal or q > d.

## Direct integral proof

Put v = delta^2, B = I_q + 11^T, and

    P = B^(-1) = I_q - 11^T/(q+1),
    R = D P D^T,                 Q = I_d + R/v.

B and P are positive definite, R is positive semidefinite, and Q is
positive definite for every rectangular D. In particular no tuple-rank
condition is used. Completing the square in the common scalar label,
with u = D^T a, gives

    integral_y phi_v(y) product_i phi_v(y-u_i)
      = sqrt(2*pi*v)^(-q) / sqrt(q+1)
        * exp(-(sum_i u_i^2 - (sum_i u_i)^2/(q+1))/(2v)).

Here phi_v denotes the scalar density with variance v. Its normalization
follows from the ordinary scalar Gaussian integral. The exponent is
-a^T R a/(2v), so integration against the actual normalized N(0,I_d)
density gives det(Q)^(-1/2). To justify that integral directly, for any
positive-definite H choose its symmetric positive square root S.
The change of variables w = S a has Jacobian |det S|, and

    integral exp(-a^T H a/2) da
      = (2*pi)^(d/2) / sqrt(det H).

Thus no Gaussian density of the possibly singular random vector D^T a
is needed. The determinant reduction is

    det(D^T D + v B) = v^q (q+1) det(I_d + D P D^T/v),

by Sylvester's determinant identity and det B = q+1. Combining the
constants gives the one-row value

    (2*pi)^(-q/2) det(D^T D + v B)^(-1/2).

Translation of the common label removes an arbitrary anchor, and the
independent rows factor the answer into its mth power. This direct
integration argument is the route proved in `Main.lean`. It uses
Mathlib's scalar Gaussian integral and volume change-of-variables
theorems, not the upstream collision upper bound or the desired identity.

## Stochastic interpretation and density at zero

It suffices first to consider one row. Translation of y by a.t_1
reduces to t_1 = 0 without requiring any independence between a.t_1
and a.D. Introduce independent scalar noises e_1,...,e_k of variance
delta^2, independent also of a. The vector

    Z_i = a.(t_(i+1)-t_1) + e_(i+1)-e_1,  i = 1,...,q

is centered Gaussian with covariance

    C = D^T D + delta^2 (I_q + 11^T).

For any nonzero v, v^T C v >= delta^2 ||v||^2 > 0.
In particular no density of the possibly singular vector a.D is used.
The determinant-one change of variables
(x_1,...,x_k) -> (x_1,x_2-x_1,...,x_k-x_1)
shows that the conditional density of Z at z is

    h_a(z) = integral_b phi_delta(b)
                       product_(i=1)^q phi_delta(b+z_i-a.D_i).

The functions h_a are continuous in z by dominated convergence: the
integrand is bounded by
phi_delta(b) (2 pi delta^2)^(-q/2), independently of a and z.
The same bound after integrating in b shows that E_a h_a is continuous.
Tonelli gives that E_a h_a is a density of Z. The nonsingular Gaussian
density is continuous as well. Two continuous densities equal almost
everywhere are equal everywhere, so evaluation at zero is legitimate,
not an evaluation of an arbitrary almost-everywhere density version.
The value is (2 pi)^(-q/2) det(C)^(-1/2).
The m rows are independent, and Tonelli factors the collision integral
into the mth power of its one-row value. This supplies an independent
prose interpretation of the shared-noise covariance; the Lean proof
uses the direct integration argument instead of assuming this law.

## Finite measures and the exact-label consequence

For any finite nonnegative Borel measure mu, not necessarily a
probability, nonnegative Tonelli gives

    integral_(A,y) (integral_s phi_delta(y-As) dmu(s))^p
      = (2 pi)^(-m(p-1)/2)
        integral_(s_1,...,s_p)
          det(V^T V + delta^2(I + 11^T))^(-m/2)
          dmu(s_1)...dmu(s_p).

The product measure is mu^p, not a normalized posterior law. Scaling mu
by c >= 0 scales both sides by c^p, including c=0. All the quantities
are finite for delta>0. More precisely, the full moment is at most

    p^(-m/2) (2*pi*delta^2)^(-m(p-1)/2) mu(R^d)^p.

The collision kernel is bounded by its coincident-tuple value because
its remaining Gaussian expectation is of exp(-a^T R a/(2v)), which is
at most one. Equality in the bound holds for every measure c times a
point mass, c >= 0. This establishes sharpness, including zero and
nonunit mass, without any ambient growth assumption. Its delta
dependence is essential: this is not the manuscript's uniform-in-delta
ambient-growth bound.

Under the manuscript's ambient growth assumption, full-rank tuples
hold mu^p-almost everywhere by `h:dv:ambient-gram`. On that set
det(V^T V + Q) >= det(V^T V), so its Gram integral bound yields exactly
the stated B^p with H^p R^(beta p-m(p-1)), without losing a mass factor.
For compactly supported continuous tests, the measures
F_delta lambda_m converge weakly to the exact image measure by bounded
convergence in the added Gaussian noise. Holder and L^p duality then
give the exact-label density and its norm bound. This last duality
step is a separate dependency, not a claim that smoothed densities
converge pointwise for every matrix. The present formal certificate
covers the exact moment expansion and its finite-mass bound, not
`h:dv:ambient-gram` or `h:proj:density-by-tests`. Consequently it does
not, by itself, certify the full exact-label density theorem.

## Boundary normalization

At D=0, det(I_q+11^T)=q+1=k. The exact collision value is therefore

    k^(-m/2) (2 pi delta^2)^(-m(k-1)/2).

Replacing the shared-noise covariance by delta^2 I_q would instead
miss the factor k^(-m/2). That is a counterexample to the altered
formula, not to the staged manuscript, which retains the term.

## Prior work and scope

The mission identifies an upstream `SharpGaussian` upper-bound proof.
No exact equality is inferred from that bound here. The present
parameter-uniform proof certifies the exact equality, including its
normalization and the finite-measure moment consequence, rather than
only an upper bound or a covariance computation. This improves the
local evidence over the inspected upstream bound, but is not a claim
of a new Gaussian integration formula or a proof of the full
memory-sample lower bound.

The formal library sources inspected are Mathlib at revision
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` in the host's Lean 4.31.0
workspace: `Analysis/SpecialFunctions/Gaussian/GaussianIntegral.lean`
(`integral_gaussian`), `Probability/Distributions/Gaussian/Real.lean`
(normalized scalar Gaussian density), and
`Probability/Distributions/Gaussian/Multivariate.lean`
(Gaussian laws and covariances).

## Formal and computational evidence

`Main.lean` proves the actual measure/integral identity, not merely a
determinant proxy. The principal results are
`manuscript_gaussian_identity`, `coincident_collision_rpow`,
`smoothing_moment_rpow`, and `smoothing_mass_bound`.
Both sides of the real-valued moment identity have proved integrability.
The source allows arbitrary finite coordinate sets and any finite
nonnegative Borel measure, hence includes all the requested positive
dimensions, repeated points, q>d, zero measure, and nonunit mass.
`statement_fidelity.md` gives the precise mathematical translation and
explicitly identifies what is not formalized.

The claim-bound compiler run is reproduced, from the campaign root, by

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/gaussian_collision/Main.lean --project-root . --claim GC_EXACT_VERIFICATION --statement-fidelity research/gaussian_collision/statement_fidelity.md --artifact-dir research/gaussian_collision --timeout 100
```

The installed interface takes the source positionally. The artifact
directory keeps `lean_check.json`, the compiler log, and the archived
claim certificate inside this mission's assigned subtree.

The official run succeeded on Lean 4.31.0 with exit code 0,
`proof_holes=[]`, and axiom-audit exit code 0. Its archived certificate is
`certificates/GC_EXACT_VERIFICATION-afee14e2d156531d.json`. The printed
axiom dependencies of the principal identities are only `propext`,
`Classical.choice`, and `Quot.sound`. The ledger derives `closed_kernel`
for `GC_EXACT_VERIFICATION`; that status does not establish statement
fidelity, independent review, or mathematical novelty.

`verify.py` replays exact SymPy algebra: 336 rational covariance cases,
including q>d and rank-zero/rank-one/repeated-column matrices, and
24 symbolic coincident Gaussian normalizations. It also checks
completed squares, product-measure scaling with zero and nonunit
mass, and the preserved typed Jacobian determinant computation.
These finite checks are not a parameter-uniform proof. The uniform
proof is the formal source and its real compiler evidence.
The script also checks that the official compiler and archived
claim-bound certificate match the current formal source and fidelity
document. It does not rerun Lean; the command above is the genuine
compiler replay.

No false assertion of the staged manuscript was identified in this
bounded audit, so there is no manuscript refutation claim. The
independent Reviewer has not yet assessed fidelity, significance,
novelty, or acceptance. The campaign's publishable/exploratory target
is unchanged; this Engineer handoff does not claim that target has
already been independently achieved.
