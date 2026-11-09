# Sharp two-center projection: conditional analytic audit

## Exact scope

The target is `pi:sharp-projection` in the staged `pinching.tex`, with its
dependency `pi:radial-transport`. The requested estimate is

    |b| <= C,
    ||grad(v - b.U)||_{L2(B_(2L+4)(y))} <= C s,
    s^2 = E_i(x) + E_i(z).

Here R = 16(L + C_sep + 2), S = 32R, and all quantities use the dyadic
rescaled metric and Hausdorff measure. The constant and sufficiently-late
threshold must not depend on the center configuration or the dyadic index.
The main ambient-open bi-Lipschitz theorem is not the assertion certified
by this bounded mission.

## Imported dependencies

The following are hypotheses, not conclusions of this audit.

1. `coordinates.tex`, `co:flat-setup`, `co:harmonic-normalization`: along
   every increasingly late sequence of admissible centers and scales the
   rescaled spaces tend in measured GH sense to Euclidean space, and the
   centered harmonic columns U tend, up to rotation, locally uniformly and
   strongly in interior W1,2 to the coordinate column. Their values and
   gradients have fixed bounds; the affine span is uniformly nondegenerate
   on the fixed balls used here.
2. `pinching.tex`, `pi:poisson-pinching`, `pi:poisson-units`,
   `pi:shifted-triangle`: v is harmonic on B_8R(z);
   grad(v), grad(f^z) are bounded; the L2 norms of Hess(v),
   Hess(f^z)-g, and grad(f^z)-grad(d_z^2/2) are at most C s on the
   respective working balls. Delta(f^z) = a lies in [n,n+1].
3. `pinching.tex`, `pi:radial-invariance`: L_z U = A_z U + rho on
   B_8R(z), with ||rho||_W1,2 <= C s and a uniformly bounded matrix A_z.
   The summable budgets satisfy E_i >= P_i and are positive.
4. `coordinates.tex`, `co:local-calculus`: weak product and chain rules,
   uniform Poincare, harmonic Caccioppoli, interior boundedness and
   Lipschitz estimates, and local harmonic stability on strictly nested
   balls.

The gradient identity `pi:constant-direction`, proved by the two-center
commutator, is NOT an input to sharp projection. Only the harmonicity,
gradient bounds and Hessian bounds at the start of that lemma are needed.

The local Wiki index was searched for this RCD/projection problem and its
analytic dependencies; no relevant prior project result was found.
Ambrosio--Honda, *Local spectral convergence in RCD*(K,N) spaces*,
**arXiv:1703.04939v1**, Theorems 4.2, 4.4 and 4.6(2), and
Corollary 4.5, provide the precise interior compactness and pairing
statements. Their hypotheses and conclusions were read at the primary
source and are transcribed in `ah18-excerpts.md`. They are recorded as
assumptions on C_SP, not silently promoted to internally verified
theorems. Independent citation attribution remains for the Reviewer.

## 1. Result and its quantifiers

**Conditional verification theorem (Engineer proof; independent review
pending).** Fix n >= 2, L,C_sep > 1, and the uniform bounds in the imported
dependencies above. In the stated uniform almost-Euclidean regime there
are C and a sufficiently-late threshold such that every admissible
center configuration and every dyadic scale satisfy sharp projection.
Neither C nor the threshold is chosen separately for a center or scale.
If the imported constants depend only on n,L,C_sep, the constant here
does also; the late threshold is the one required for that fixed regime.

In fact, the argument needs only a uniformly bounded A_z in radial
invariance, not A_z -> Id. It also works with nonnegative s, without a
positive floor, because normalization occurs only when alpha > 0.
These are logical weakenings of inputs, not claims of mathematical novelty.

The proof below establishes the full conditional analytic implication,
not merely polynomial tests or a finite family of harmonic modes. It
does **not** prove uniform harmonic normalization, the summability
construction, the commutator conclusion, or the value-space iteration.
Consequently it is not a verification of the main chart theorem and
does not close the publishable campaign.

## 2. Affine projection, Euler error and forcing coefficients

Subtract v(z). A gradient bound on B_8R(z), integrated along radial
geodesics from z, bounds v there. U(z) = 0 gives the analogous value
bound for U.

Let Z = (1,U_1,...,U_n)^T. The matrix

    Q_r = int_{B_r(z)} Z Z^T dm

is uniformly positive definite for r = R and r = R/2. To justify the
uniformity, take a contrary increasingly flat sequence of configurations
and unit coefficient vectors. Rotating U if necessary, uniform convergence
to X and measured convergence on the ball give the Euclidean Gram
matrix in the limit. The Euclidean sphere has zero measure, and the
functions 1,X_1,...,X_n are linearly independent on an open ball.
The limit Gram matrix is positive definite, a contradiction. This
argument does not assume pointwise nondegeneracy of the metric Gram
field or a lower bound for alpha.

Take the orthogonal projection of v on this span on B_R(z), writing it
as c0 + b.U, and put w = v - c0 - b.U and
alpha = ||w||_{L2(B_R(z))}. Projection decreases the L2 norm, so
Q_R coercivity and the bound for v give

    |c0| + |b| <= C,    alpha <= C.

Thus w is harmonic, with uniformly bounded values and gradients on
B_8R(z). Its exact orthogonality identities are

    int_{B_R} w dm = 0,    int_{B_R} w U_j dm = 0.

Put G = L_z v - v. The product rule gives, as an identity of L2
one-forms,

    grad G = (Hess f^z - g)(grad v,.) + Hess v(grad f^z,.).

Both terms have norm at most C s. Poincare, using the gradient on
B_8R(z), supplies a scalar k_v such that

    ||G - k_v||_{L2(B_4R(z))} <= C s.

Writing rho = L_z U - A_z U and subtracting the affine projection
therefore gives

    L_z w = w + ell.U + k + e,
    ell^T = b^T(Id-A_z),    k = k_v + c0,
    ||e||_{L2(B_4R(z))} <= C s.                         (2.1)

There is no differentiation of a normalized residual here.

For completeness, Caccioppoli follows by testing harmonicity with
chi^2 w and applying Cauchy--Schwarz:

    int chi^2 |grad w|^2 <= 4 int w^2 |grad chi|^2.

A cutoff supported inside B_R and equal to one on B_R/2 yields
||grad w||_{L2(B_R/2)} <= C alpha. Since grad f^z is bounded, (2.1)
then implies

    ||ell.U + k||_{L2(B_R/2)} <= C(alpha+s).

The already established coercivity of Q_R/2 proves

    |ell| + |k| <= C(alpha+s).                         (2.2)

This is the needed coefficient estimate. Smallness of Id-A_z alone
would not give an estimate relative to alpha, and is not substituted
for (2.2).

## 3. Radial transport, with the squared defect retained

We prove this for any bounded Sobolev w satisfying (2.1)-(2.2), not
only the projection residual. Let M be its fixed L-infinity bound,
q = d_z^2/2, a = Delta f^z in [n,n+1], and t = d_z.
The weak product rule gives

    div(w^2 grad f^z) = (a+2)w^2 + w F,
    F = 2(ell.U + k + e),
    ||F||_{L2(B_3R)} <= C(alpha+s).                    (3.1)

The products are legitimate: w is bounded Sobolev, grad f^z is
bounded and its Laplacian is constant. The weak identity may be
tested with the compactly supported Lipschitz cutoff used below.

Set A0 = 2(n+4)/(R-1). Define phi(t) to be one on [0,R],
exp(-A0(t-R)) on (R,2R], and
exp(-A0(t-R))(3R-t)/R on (2R,3R), and zero beyond 3R.
This is continuous Lipschitz and has support compactly inside B_4R.
Its derivative is nonpositive, -phi' >= A0 phi for R < t < 3R,
and phi >= exp(-A0 R) > 0 for t <= 2R.
For almost every t in the annulus,

    -t phi' - (a+2)phi >= |phi'| + phi.                (3.2)

Indeed the difference is

    (t-1)(-phi') - (a+3)phi
    >= [(t-1)A0-(a+3)]phi
    >= [2(n+4)-(n+4)]phi >= 0.

This includes both pieces of the annulus; the three joining spheres
cause no extra term because phi is continuous and Lipschitz.

Put e_f = <grad d_z,grad f^z> - d_z. Since |grad d_z| = 1 almost
everywhere off z and grad q = d_z grad d_z,

    ||e_f||_{L2(B_3R)} <= C s.

Let

    A = int_{R<d_z<3R} (|phi'|+phi) w^2 dm.

Testing (3.1) against phi(d_z) gives the exact sign convention

    int [-t phi'-(a+2)phi] w^2 dm
      = int phi w F dm + int phi' e_f w^2 dm.

On the inner ball the integrand on the left is -(a+2)w^2.
Moving that contribution to the right and applying (3.2) yields

    A <= (a+2)alpha^2
         + |int phi w F dm| + |int_annulus phi' e_f w^2 dm|.  (3.3)

The crucial last term is estimated **before division by alpha**:

    |int_annulus phi' e_f w^2|
      <= M (int_annulus |phi'|w^2)^(1/2)
           (int_annulus |phi'|e_f^2)^(1/2)
      <= C s sqrt(A)
      <= A/4 + C s^2.                                (3.4)

The last step is the exact identity

    t^2/4 - m s t + m^2 s^2 = (t/2-m s)^2 >= 0

with t = sqrt(A) and a fixed m absorbing the uniform constants.
There is no coefficient depending on 1/alpha.

For the other term, the inner ball contributes at most
C alpha(alpha+s), and the annulus contributes at most
C sqrt(A)(alpha+s), since phi <= |phi'|+phi and phi <= 1.
The same Young inequality, together with
(alpha+s)^2 <= 2(alpha^2+s^2), gives

    |int phi w F| <= A/4 + C(alpha^2+s^2).

Consequently (3.3) implies

    A <= C(alpha^2+s^2),
    ||w||_{L2(B_2R)}^2
      <= alpha^2 + exp(A0 R) A
      <= C(alpha^2+s^2).                              (3.5)

All constants depend only on fixed bounds, n and R. Taking square
roots gives the claimed radial transport bound C(alpha+s).
The argument includes alpha = 0 and s = 0. No inverse power of
either parameter was used.

## 4. Uniform normalized compactness

Suppose the asserted uniform alpha <= C s were false in arbitrarily
late configurations. Choosing the flatness/coordinate errors at most
1/j and the ratio larger than j gives a sequence with

    alpha_j > j s_j,    alpha_j <= C.

Here alpha_j is positive, s_j/alpha_j < 1/j, and s_j -> 0.
This formulation also handles s_j = 0 and does not rely on the
positive floor in E_i.

Set h_j = w_j/alpha_j. Equations (3.5) and (2.2) imply

    ||h_j||_{L2(B_R)} = 1,
    ||h_j||_{L2(B_2R)} <= C(1+s_j/alpha_j) <= 2C,
    |ell_j|/alpha_j + |k_j|/alpha_j <= 2C.             (4.1)

For the cited convergence theorems the curvature-dimension parameters
can be fixed: eventually kappa r_i^2 <= 1, so the spaces are
RCD*(-1,n), and n > 1. The imported fixed-ball volume bounds and
measured convergence exclude a degenerate reference-measure limit.
Thus Section 4 of AH18 applies with a common K,N; there is no
boundary-value or Dirichlet spectral-convergence hypothesis here.

Caccioppoli bounds the H1,2 norms on B_7R/4. Theorem 4.2 of AH18
gives an L2-strong subsequence there, Theorem 4.4 gives strong
interior energy convergence, and Corollary 4.5 gives a harmonic
Euclidean limit h on B_7R/4. Interior boundedness and gradient
estimates give local uniform convergence and uniform interior
Lipschitz bounds, in particular on B_3R/2.

There is no illicit eightfold-domain requirement here: when an
interior estimate is stated with an eightfold enlargement, cover
the smaller ball with balls of radius at most R/128. Their
eightfold enlargements still lie strictly inside B_2R. All radii
and covering/volume constants are fixed independently of j.

We give a separate justification for the radial coefficient in
the limiting equation. This avoids assuming a convergence rule
for arbitrary pointwise gradient representatives. Let q_j=d_z^2/2.
Poincare applied to f_j^z-q_j on B_2R, using the gradient error
on B_4R, supplies constants c_j with

    ||f_j^z-q_j-c_j||_{L2(B_2R)} <= C s_j.

Distances converge uniformly under the measured-GH approximations,
so F_j=f_j^z-c_j converges L2-strongly to q_infinity=|X|^2/2.
Its gradient and L2 norms and its constant Laplacian a_j are bounded.
Theorem 4.4 of AH18 therefore gives strong H1,2 convergence on
B_7R/4. On B_3R/2 both grad(F_j) and grad(h_j) are uniformly
bounded. Theorem 4.6(2), with p=2, now applies to the pair F_j,h_j
and gives weak convergence of their scalar products to

    <grad(|X|^2/2),grad h> = X.grad h.

After rotation U_j -> X. Passing to subsequences in the bounded
vectors ell_j/alpha_j and scalars k_j/alpha_j, and using
||e_j/alpha_j||_2 <= C/j, the normalized equation (2.1) becomes

    X.grad h = h + ell_infinity.X + k_infinity.       (4.2)

This is first an identity against compactly supported interior
tests; smoothness of the Euclidean harmonic limit makes it a
classical identity.

The normalization and the affine orthogonality also pass to the
limit:

    ||h||_{L2(B_R(0))} = 1,
    int_{B_R(0)} h = 0,    int_{B_R(0)} h X_j = 0.    (4.3)

To see this without an unproved boundary assertion, h_j and U_j
converge uniformly on a neighborhood of the closed ball, and the
Euclidean sphere has zero measure. Thus restricting the convergent
measures to B_R preserves these bounded integrals.

## 5. Exact Euler rigidity, without truncating harmonic modes

The following elementary statement is stronger than needed.

**Rigidity.** If h is C2 on a Euclidean ball about zero and
X.grad h = h + ell.X + k, then h is affine.

At zero the equation gives h(0)=-k. Differentiating once and
evaluating at zero gives, in each direction,

    partial_j h(0) = partial_j h(0) + ell_j,

so ell=0. Put H=h-h(0); then X.grad H=H. For any X in the ball
and 0<t<=1,

    d/dt [H(tX)/t] = [t grad H(tX).X - H(tX)]/t^2 = 0.

Differentiability at zero gives
lim_{t downarrow 0} H(tX)/t = Dh(0).X. It follows that
H(X)=Dh(0).X throughout the ball. This proves rigidity for all
C2 functions, not just for polynomials or finitely many Taylor
coefficients.

Apply it to (4.2). If h=c+b.X, (4.3) implies

    int_{B_R} h^2 = c int_{B_R} h + sum_j b_j int_{B_R} h X_j = 0,

contradicting its unit norm. This proves alpha<=C s.

The contradiction selects data with arbitrarily small *common*
flatness and coordinate errors. It therefore supplies one
smallness threshold and one constant for the entire class with
the fixed bounds, rather than a constant chosen after fixing a
center or scale. In the manuscript the common errors tend
uniformly to zero in the initial rescaling, so a single
sufficiently-late threshold works simultaneously for every
dyadic index and center configuration. An effective numerical
value or convergence rate is not asserted by this compactness proof.

## 6. The requested gradient estimate

Caccioppoli, now applied on the unnormalized projection ball, gives

    ||grad(v-b.U)||_{L2(B_R/2(z))}
      = ||grad w||_{L2(B_R/2(z))}
      <= C alpha <= C s.

Since d(y,z)<=C_sep and

    R/2 - (2L+4+C_sep) = 6L+7C_sep+12 > 0,

B_(2L+4)(y) lies strictly inside B_R/2(z). The projection already
gave |b|<=C. This is exactly the requested estimate, with the
specified integral L2 convention and squared defect s^2.

## 7. Executable evidence and limits of certification

`verify.py` replays universal symbolic identities, not sampled
configurations: the cutoff-sign certificate for arbitrary admissible
parameters, both cutoff derivatives and joining values, the Young
square identity, normalization algebra, both domain margins, and
the scalar quotient differentiation used in Euler rigidity. It also
binds the two audited lemma statements to the staged source and
independently replays the retained typed Jacobian SOS result.

The Jacobian operation was discovered and its exact input/output
contract inspected before use. `jacobian_payload.json` is the exact
request for `polynomial.sos.decomposition.check`; `jacobian_output.json`
retains the adapter's full typed answer, including server version and
protocol. This operation certifies the Young polynomial identity
only. It does not certify an RCD compactness theorem.

The exact algebra is supporting evidence for the complete analytic
proof above, not a machine proof of the analytic theorem. The latter
still rests on the explicitly recorded imported hypotheses and the
primary-source local convergence results. No Lean source or finite-mode
formalization is substituted for it. `statement_fidelity.md` separates
these scopes.

No false literal manuscript assertion was established in this audit.
Accordingly there is no invented F_ claim or refutation judgement.
The previous project ledger contained only the open campaign objective;
the improvement here is a full conditional proof of this specific
load-bearing implication, not a refutation, a novelty determination,
or a certification of the downstream chart construction.

The exact replay exited **0** with seven groups of checks and zero
sampled parameters. The inspected Jacobian operation returned
`EXACT_COEFFICIENT_IDENTITY`, `is_valid=true`, adapter exit 0; its
reported operation runtime was 17 ms. These observations refer to
the retained request and answer, not to an analytic compiler run.

`citation_check status` exited **1** because the three AH18
assumptions still have no independent recorded attribution. This
is a review/delivery obligation, not a mathematical refutation or
a failure to obtain the primary source. The local excerpts are
available for the Host-invoked Reviewer. This Engineer has not
written a Reviewer verdict or used a second identity to self-check
a citation.
