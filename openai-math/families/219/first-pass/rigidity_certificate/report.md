# Quenched entropy rigidity, including zero edge correlations

## Result and scope

The conditional Gaussian-rigidity implication in the weak-Anderson manuscript
has a direct proof under its stated tree regularity, marked-law, and conditional
entropy inputs. No literal manuscript assertion is refuted here.

The theorem below strengthens the equality case: nonzero endpoint correlation
and an atomless potential distribution are unnecessary. Parity-preserving
ergodicity suffices, and only a logarithmic inverse-covariance moment is needed
in the heat-flow argument. The conclusion holds for every finite color
dimension and an arbitrary finite annealed color covariance, including singular
ones. An explicit two-phase construction shows why ordinary ergodicity cannot
replace parity-preserving ergodicity in this more general statement.

This is a proof in ordinary mathematics with exact symbolic checks and a
separately formalized finite-dimensional core. It is not a Lean formalization
of entropy, disintegration, ergodicity, or universality. Independent review,
including literature-wide novelty and publishable significance, is pending.

### Source boundaries

The seed campaign context and its main goal are preserved in `MATH_STATE.json`.
The following are source assertions, not conclusions of this audit:

| Source in the staged weak-Anderson build | Input or boundary |
|---|---|
| `01-introduction.tex`, `thm:main` | Fixed-energy GOE point-process universality at every fixed degree, sufficiently small fixed positive uniform disorder, and every energy in a compact clean bulk interval. This theorem remains open in this audit. |
| `02-tree.tex`, `prop:tree-stability`, `lem:tree-log`, `cor:tree-density` | Equivariant positive boundary messages; covariance convergence and logarithmic integrability; `E Im(m_o)=pi rho`. |
| `04-marked-entropy.tex`, `prop:marked-limits`, `lem:conditional-mean` | A fixed invariant empirical marked law; deterministic iid potential marginal; the exact tree equation; conditional centering; exact annealed second moments. |
| `04-marked-entropy.tex`, `prop:conditional-entropy` | The environment-conditioned positive-height entropy inequality. Its finite-graph counting derivation is not certified here. |
| `05-rigidity.tex`, `prop:gaussian-marks` | The implication being verified, rather than an input. |

These inputs were recorded as `TREE_BOUNDARY_SOURCE`, `MARKED_LAW_SOURCE`,
and `CONDITIONAL_ENTROPY_SOURCE` before implementation. They cite the dated,
locally staged unpublished manuscript, with their literal proposition labels.
The ledger context distinguishes this iid source environment from the
more general invariant environment quantified below, and from the augmented
non-iid phase environment used only for sharpness. Source-specific hypotheses
are not silently imposed on, or removed from, the generalized theorem.

The clean companion's `01-introduction.tex`, `thm:main`, is recorded separately
as `C_CLEAN_MAIN`. Its quantitative entropy and insertion argument is neither
used nor verified here. He--Huang--Wang, *Bulk universality of random regular
graphs*, arXiv:2610.08127v1, states a separate clean fixed-energy point-process
theorem in its introduction; its unfolding `n*pi*rho_d` targets intensity
`1/pi`, whereas the staged clean manuscript uses `n*rho_d` and intensity one.
That external source does not prove the disorder-specific bridge here.

For comparison, the primary source Backhausz--Szegedy,
arXiv:1607.04785v1, Definition 11.1, Theorem 8, and Proposition 11.1,
treats a scalar homogeneous symmetric star with prescribed covariances.
Its Section 12, equation (27) and Lemmas 12.2--12.3, discusses Gaussian
smoothing and finite-variance entropy. These passages were read from the
downloaded primary source, not inferred from search summaries. The numbering
of that arXiv version is not asserted to be the numbering of the published
version cited by the manuscript. None of its extremal theorems is invoked
to infer the quenched result below. A focused literature search did not
identify this zero-correlation/parity formulation; that is not proof of
literature-wide novelty.

## Theorem: parity-ergodic quenched entropy rigidity

Let `d>=3`, let `m>=1` be finite, and let an environment on the infinite
`d`-regular tree have a tree-automorphism-invariant distribution. Assume its
action under the subgroup preserving each bipartition class is ergodic.
The environment may contain correlated labels; iid labels of any law,
including an atomic law or a point mass, are particular cases.

Suppose the environment carries equivariant real potentials and compatible
boundary Green covariances, as follows. Incoming cavity messages
`g_{i->o}=c_i+i beta_i`, `beta_i>0`, satisfy the real-energy tree recursion.
Their star and edge covariances are the imaginary parts of the associated
Green matrices. In particular every retained star and every edge is positive
definite. Put `k_o=Im(m_o)` and assume

    0 < kappa := E_environment k_o < infinity,
    E_environment log(1+||(K_o^ret)^(-1)||) < infinity.             (T1)

Let `U_v` be an `R^m`-valued marked field in one fixed invariant joint law
with that environment, satisfying

    (V_v-E) U_v + sum_{u~v} U_u = 0,
    E[U_v | environment] = 0,
    E U_o U_o^T = Sigma,                                         (T2)

where `Sigma` is any finite positive semidefinite matrix. Invariance includes
re-rooting across every edge, not just neighbor permutations at one root.

For a retained star, use spatial-then-color coordinates and define

    L_o = ((K_o^ret)^(-1/2) tensor I_m) U_o^ret,
    R_{oi} = (K_{oi}^(-1/2) B_i (K_o^ret)^(1/2)) tensor I_m,

where `B_i` reads the actual edge, reconstructing the forgotten neighbor
using the tree equation. Let independent standard Gaussian noises be
understood conditionally on the environment. Assume the finite entropy bound

    D(1) := E_environment [
        h(L_o+gamma) - (1/2) sum_{i~o} h(R_{oi}L_o+gamma)
    ] >= 0.                                                     (T3)

Then, almost surely in the environment,

    Law(U_o^ret | environment)
        = N(0, K_o^ret tensor (Sigma/kappa)),                     (T4)
    Law(U_o | environment)
        = N(0, (k_o/kappa) Sigma).

No nonzero-correlation assumption is imposed on any edge. No higher mark
moments, inverse precision-share moments, or disorder threshold depending on
`m` are needed. The theorem does not identify joint laws of arbitrarily many
spatially separated vertices.

### Corollary for the manuscript

The inherited tree estimates imply (T1), and the inherited marked-law and
centering assertions imply (T2) with `Sigma=I_m`. The entropy-limit argument
below turns the inherited positive-height inequality into (T3).
An iid potential environment is parity-preserving ergodic. Therefore

    Law(U_o | environment)
        = N(0, Im(m_o)/(pi rho) I_m)

for every finite `m`, exactly as asserted in `prop:gaussian-marks`.
For every new disorder law contemplated by the general theorem, positivity,
the entropy input, and (T1)--(T2) still have to be established; no new
universality or disorder regime follows automatically.

## Proof

### 1. Precision, orientation, and coordinate volume

Write `a=V_o-E`, `B=sum_i beta_i>0`, `t=a-sum_i c_i`, and
`m_o=(t-iB)^(-1)`. On the constraint `a z+sum_i x_i=0`, put
`y_i=x_i+c_i z`. The constraint becomes `t z+sum_i y_i=0`.
Condition independent Gaussians of variances `beta_i` and a root Gaussian
of variance `1/B` on this equation. The resulting precision is

    sum_i [(x_i+c_i z)^2 + beta_i^2 z^2]/beta_i
      = sum_i y_i^2/beta_i + B z^2.                              (1)

Its covariance has root variance `B/(t^2+B^2)` and root-neighbor covariance
`-(t beta_i+B c_i)/(t^2+B^2)`. Conditional on the root, its neighbor
residual covariance is

    W = diag(beta_i) - (beta_i)_i (beta_i)_i^T/B.                  (2)

These are exactly the imaginary parts of `m_o`, `-m_o g_i`,
and `delta_ij g_i+g_i m_o g_j`.

For completeness, omit neighbor `d` and use coordinates
`(z,y_1,...,y_{d-1})`. The change from retained original coordinates has
determinant one. Its precision is

    D + u u^T/beta_d,
    D=diag(B,1/beta_1,...,1/beta_{d-1}),  u=(t,1,...,1)^T.

Multilinearity of the determinant gives
`det(D+u u^T/beta_d)=det(D)(1+u^T D^(-1)u/beta_d)`:
every term using two rank-one columns is zero, and each term using one is
the corresponding diagonal contribution. Thus

    det(K_o^ret) = product_i beta_i/(t^2+B^2).                    (3)

This is retained-coordinate volume, equivalently
`delta(a z+sum_i x_i) dz product_i dx_i`. It is not Euclidean
surface volume; there is no missing constraint-normal length.

On an oriented edge use `g=c+i b` incoming at the root and
`g'=u+i v` incoming at the neighbor, with `b,v>0`. The precision is

    P = Q(g) + J Q(g') J,
    Q(c+i b) = (1/b) [[c^2+b^2,c],[c,1]],
    J = [[0,1],[1,0]].                                         (4)

The reversal matrices in (4) are essential. Put

    Delta = (1-cu+bv)^2 + (cv+bu)^2.

Direct multiplication gives

    det(bv P)=bv Delta,
    Delta=4bv+(1-cu-bv)^2+(cv-bu)^2 > 0,
    det(K_edge)=bv/Delta.                                       (5)

Each `Q` is positive definite: its quadratic form is
`((x+cz)^2+(bz)^2)/b`, positive off zero.
Equations (3)--(5) are exact identities, not small-disorder expansions.
The Jacobian adapter computed the polynomial determinant in (5) over
`QQ(b,c,u,v)`; `verify.py` independently checks its typed answer.

### 2. Whitened shares and re-rooting compatibility

Use the positive square roots `H=(K_o^ret)^(1/2)` and
`E_i=K_{oi}^(1/2)`. Then `R_i=E_i^(-1)B_i H`, so
`R_i R_i^T=I`. Define `A_{oi}=E_i Q(g_i) E_i`, tensored with
`I_m`. In the same oriented edge coordinates the opposite share is
`A_{io}=E_i J Q(g') J E_i`. Equations (1) and (4) imply

    sum_i R_i^T A_{oi} R_i = I,
    A_{oi}+A_{io}=I,             0<A_{oi}<I.                     (6)

For example `R_i^T A_{oi}R_i=H B_i^T Q(g_i) B_i H`;
only adjacent inverse square roots cancel. No noncommuting square roots
are interchanged. The actual conditional edge law plus Gaussian noise of
covariance `s K_edge tensor I_m` is the same when read from either
endpoint. Changing the endpoint orientation conjugates covariance,
whitening, score, and precision share together by `J tensor I_m`.
Consequently (6) pairs the correct random weights under re-rooting.
Replacing `K` by its environment average would not prove this identity.

### 3. Heat flow needs logarithmic, not inverse-weight, moments

At a fixed environment put `M=E[||U_o^ret||^2 | environment]`.
It is finite almost surely and integrable, by (T2) and invariance.
If `M_L=E[||L_o||^2 | environment]`, then

    log(1+M_L)
       <= log(1+||(K_o^ret)^(-1)||)+log(1+M).                    (7)

Thus `log(1+M_L)` is integrable; `M_L` itself need not be.
For a `q`-dimensional finite-second-moment random variable `X`,

    0 <= h(X+sqrt(s)gamma)-h(sqrt(s)gamma)
       <= (q/2) log(1+E||X||^2/(q s)).                          (8)

The lower bound follows by conditioning on `X` and nonnegativity of
mutual information; the upper bound is the Gaussian entropy bound with
the trace of the covariance bounded by the second moment.
These bounds and (7) make all entropies defining `D(s)` integrable.
Since `R_i` is a coisometry, the same bound applies to each edge.
Dimensions cancel, `dm=(1/2)d(2m)`, and dominated convergence in (8)
gives `D(s)->0` as `s->infinity`.

Let `rho_o` and `rho_i` be the scores of
`X=L_o+sqrt(s)gamma` and `R_i X`, conditional on the environment.
Differentiation of a marginal gives

    E[R_i rho_o(X) | R_i X] = rho_i(R_i X).

Weighted conditional variance and (6) give the exact nonnegative deficit

    I_o - sum_i E[rho_i^T A_{oi} rho_i]
      = sum_i E[(R_i rho_o-rho_i)^T A_{oi}
                    (R_i rho_o-rho_i)] =: delta_o >= 0.          (9)

Re-rooting and the second identity of (6) give

    E_environment sum_i E[rho_i^T A_{oi}rho_i]
       = (1/2) E_environment sum_i I_{oi}.                      (10)

For Gaussian smoothing, conditioning the noise score proves `I<=q/s`.
On a compact positive-time interval, convolution has a smooth positive
density, and a fixed positive mass of the input in a ball bounds
`|log p(x)|` by `C(1+||x||^2)`. Integrating the heat equation against
`log p` with spatial cutoffs, and removing the cutoffs using the finite
second moment and Gaussian derivative bounds, proves the integrated
de Bruijn identity. The bound `q/s` then justifies environment integration.
Equations (9)--(10) yield

    D(b)-D(a) = (1/2) integral_a^b E_environment delta_o(s) ds
                 >= 0                  (0<a<b).               (11)

In particular (T3), (8), and (11) force `D(s)=0` for all `s>=1`.
Choose one `s>=1` outside the null sets for all countably many vertices.
Every summand in (9) vanishes almost surely. Strict positivity of
`A_{oi}` gives

    R_i rho_o(x) = rho_i(R_i x)                                  (12)

everywhere, since smoothed densities are positive and smooth.
There is no use of `A_{oi}^(-1)` or its moments anywhere in this argument.

### 4. All residual color blocks coincide

Differentiating (12) shows that the symmetric log-density Hessian
commutes with every edge projection `P_i=R_i^T R_i`.
For one spatial color the reading space is
`span(w_c,a_i)`, where `w_c` is the standardized root direction
and `a_i` is the normalized neighbor residual direction.
From (2),

    <a_i,a_j> = -sqrt(beta_i beta_j/
                       ((B-beta_i)(B-beta_j)))       (i!=j).    (13)

These values are nonzero and lie strictly between `-1` and `0`:

    (B-beta_i)(B-beta_j)-beta_i beta_j
       = B(B-beta_i-beta_j)>0.

The last strict inequality uses a third positive branch.
Writing `w_i=sqrt(beta_i)` expresses (2) as
`diag(sqrt(beta_i)) (I-ww^T/B) diag(sqrt(beta_i))`.
The middle factor is a projection of rank `d-1`, so the residual
directions span a space of dimension `d-1`.
Their lines are distinct, so the intersection of all edge reading
spaces is exactly the central color space.

The Hessian consequently preserves that central space and its
orthogonal complement. On the complement it preserves every
`a_i tensor R^m`, acting there as a color matrix `D_i`.
Self-adjointness gives, for every pair of color vectors `u,v`,

    <a_i,a_j> <D_i u,v> = <a_i,a_j> <u,D_j v>.

The diagonal case makes each `D_j` self-adjoint. Cancellation in the
off-diagonal case forces all `D_i` equal. This conclusion is proved in
Lean for arbitrary finite spatial and color index sets, not just for
one or two colors.

Vanishing central/residual mixed derivatives first splits the log density.
In an orthonormal residual spatial basis, its residual Hessian is spatial
identity tensored with one color matrix. Its zero off-diagonal blocks split
the residual log density into a sum of functions of separate color vectors.
There are at least two such independent spatial variables, since `d-1>=2`.
Their identical diagonal Hessians must therefore be constant.
Integrability makes this constant negative definite: a null or positive
eigendirection would make the exponential quadratic nonintegrable.
Thus, at every star, the smoothed law is the product of an arbitrary
central law and a centered Gaussian residual law with one positive
definite color covariance.

### 5. The reverse complementary Hessian fixes the central law

This step removes the manuscript's use of almost-surely nonzero edge
correlation. On a common whitened edge, let `z` be the first standardized
endpoint and `y` its standardized residual. The second endpoint and
its residual are

    z'=r z+q y,       y'=q z-r y,       q=sqrt(1-r^2)>0.          (14)

Here `r` can be zero; `q>0` follows from (5).
From the first star the edge log Hessian is
`diag(H_c(z),D_o)`, where `D_o` is constant by Step 4.
From the second star its complementary block is a constant `D_i`.
Conjugating by the orthogonal matrix in (14) gives

    q^2 H_c(z)+r^2 D_o = D_i.                                   (15)

Since `q!=0`, (15) makes `H_c` constant, entry by entry in the color
coordinates. No cancellation by `r` is performed.
Integrability now makes the central law Gaussian as well.
This argument works equally at `r=0`, when the central direction at
one endpoint is the complementary direction at the other.

Write `S_o` for the color covariance of the standardized smoothed
central law and `T_o` for its residual color covariance. Compatibility
of the same edge from both endpoints gives

    r S_o = r S_i,
    S_i = r^2 S_o+q^2 T_o,
    S_o = r^2 S_i+q^2 T_i.                                      (16)

Multiplying the first equation by `r` and using `r^2+q^2=1` in
the other two proves the universal swap

    T_o=S_i,       T_i=S_o.                                     (17)

This is true even for zero endpoint correlation. Both the Hessian
constancy in (15) and the covariance swap in (17) are formalized
for arbitrary color index types in `Main.lean`.

### 6. Parity ergodicity and exact normalization

By (17), any two neighbors of a vertex have the same `S`.
Hence `S` is constant on each of the two parity classes of the tree.
The standardized root covariance is a measurable function of the
environment, since it comes from disintegration of the fixed joint law.
Equivariance and the two-step identity make this function invariant
under parity-preserving automorphisms. Ergodicity makes it a deterministic
matrix `S`, the same at every root. In particular `T_o=S_i=S`.

For iid labels this ergodicity has a short direct proof. Approximate
an invariant event by a cylinder event on a finite ball. Move that ball
to a disjoint ball by an automorphism moving the root an even distance.
The two cylinder events are independent, while their approximation errors
are unchanged. Letting those errors tend to zero makes the invariant
event independent of itself. This proof includes deterministic and atomic
iid distributions. Only a countable collection of such moves and
re-rootings is needed for simultaneous almost-sure statements.

The smoothed root in physical coordinates is the mark plus noise
of covariance `s k_o I_m`. Thus

    kappa S = Sigma+s kappa I_m,
    S = Sigma/kappa+s I_m.                                     (18)

The smoothed retained star consequently has covariance
`K_o^ret tensor (Sigma/kappa+s I_m)`. Divide its characteristic
function by the nonvanishing characteristic function of its independent
Gaussian noise `N(0,s K_o^ret tensor I_m)`. This gives (T4), including
singular `Sigma`. Conditional means are zero by (T2).
For the manuscript `Sigma=I_m` and `kappa=pi rho`, proving the stated
covariance and conditional color independence.

If sampled roots are additionally independent samples from the empirical law,
as in the source construction, their limiting marked-environment law is its
product conditional on that empirical law and the retained positions.
The one-root kernel just obtained depends on neither of those extra variables.
Its product therefore gives the sampled-root and position-independence
conclusion too. This is independence of sampled roots, not a claim that the
entire spatial marked field has independent vertices.

## Passing from the manuscript's positive-height entropy input to (T3)

The following inherited analytic inputs are used here, not concealed in the
finite-dimensional certificate: covariance convergence in the common
environment, uniform integrability of edge and retained-star log
determinants, bounded mean noise traces, and the tree spectral
representation. They are among the recorded `TREE_BOUNDARY_SOURCE`
assertions.

Change full-star coordinates to retained coordinates and the residual
`C=(V_o-E)U_o+sum_i U_i`, for each color. The determinant is one.
The mark residual vanishes. For resolvent noise,

    (H_tree-E) Im(H_tree-E-i eta)^(-1) (H_tree-E) <= eta I

by scalar spectral calculus. Its residual variance is therefore at most
`eta`, without a constraint-normal length. The entropy chain rule gives

    h(F_star^eta|environment)
       <= h(F_ret^eta|environment)
                       +(m/2)log(2 pi e eta).                   (19)

Insert (19) in `prop:conditional-entropy`. The divergent terms cancel,
leaving

    E[h(F_ret^eta|environment)
            -(1/2)sum_i h(F_edge_i^eta|environment)] >= -m U(E+i eta).

Along an almost-sure covariance-convergence subsequence the convolved
retained and edge densities converge in `L^1`, with bounded densities
and uniformly integrable second moments at each fixed environment.
Their entropies converge by splitting into a bounded box and its tail.
For environment integration, the Gaussian entropy upper bound is controlled
by `log(1+M+trace K_eta)`; its positive parts are uniformly integrable,
since `log(1+x)^2<=C(1+x)` and the traces have bounded means.
The entropy lower bound is the independent Gaussian noise entropy,
whose negative parts are controlled by the inherited uniformly integrable
log determinants. Thus the entropy limit is legitimate without mixed
mark/inverse-covariance moments.

The Gaussian constant can also be evaluated directly. At positive height,
differentiate

    F(zeta)=E log|m_o|+(d/2)E log|1-g_i g'|.

In analytic logarithms, the first derivative is
`E[m_o(1+sum_i partial_zeta g_i)]`. Edge reversal makes the
second derivative term
`-E[m_o sum_i partial_zeta g_i]`, using
`m_o=g'/(1-g_i g')`. The derivative is therefore `E m_o`,
the derivative of `-U`. Positive-height resolvent bounds justify this
calculation; the common `-log|zeta|` asymptotic on the imaginary axis
fixes the integration constant. Boundary passage uses the inherited
logarithmic bounds.

Inserting (3) and (5) in the Gaussian entropy formula, the Gaussian
dimension constants cancel. The branch `log beta` terms cancel in
expectation by edge reversal. The remaining Gaussian retained-star-minus-
half-edge entropy is exactly `-U(E)`. Subtracting it and whitening
therefore gives (T3). This step uses actual conditional covariances,
not the annealed covariance.

## Sharpness: full ergodicity alone does not suffice in the extension

This is not a counterexample to the manuscript: the environment below
contains an extra bipartite phase and is not an iid potential environment.

Take the clean tree of degree five at energy zero. Its boundary cavity
message is `i/2`, its root Green function is `2i/5`, and put `k=2/5`.
Let `G` be the centered canonical Gaussian reference field with covariance
`Im(H_tree-i0)^(-1)`. Existence follows, for example, by taking limits of
the positive finite-dimensional covariances at positive height.
The diagonal covariance is `k`, adjacent covariance is zero, and
`sum_{u~v}G_u=0` almost surely. More generally opposite-parity covariances
are zero: bipartite conjugation sends `H` to `-H`, so
`Im(H-i eta)^(-1)=eta(H^2+eta^2)^(-1)` preserves parity.
The two Gaussian parity restrictions are consequently independent.

Adjoin a uniformly random proper two-coloring of the tree to the
environment. There are exactly two such colorings. A parity-preserving
automorphism fixes each, and a parity-reversing automorphism swaps them.
This two-state environment is ergodic under the full automorphism group
but not under its parity-preserving subgroup.

Set `U_v=G_v` on phase zero and `U_v=2G_v` on phase one.
The eigen-equation is preserved, because all neighbors of a vertex use
the same multiplier. Conditional means vanish, all moments are finite, and

    E U_o^2 = (1/2)(2/5+8/5)=1.

Conditionally on the phase, the whitened smoothed star has covariance
`diag(s+1,(s+4)I_4)` or `diag(s+4,(s+1)I_4)`.
Every edge has determinant `(s+1)(s+4)`. Thus, for every `s>0`,

    det(star_phase0) det(star_phase1) = det(edge)^5,
    D(s)=0.

Nevertheless the conditional root variances are `2/5` and `8/5`,
not the normalized value one predicted if only full ergodicity had
been assumed. This is an exact construction for all times and every
finite number of independent colors, not a finite numerical experiment.
It isolates the parity obstruction left by zero edge correlations.
The manuscript's iid environment has no such obstruction.

## Exact and formal evidence

`verify.py` checks universal rational/polynomial identities, the exact typed
Jacobian determinant, the all-time determinant identity of the two-phase
construction, and the binding to the actual Lean compiler result.
It does not sample potentials, degrees, Hessians, or color dimensions.

`Main.lean` certifies the arbitrary-finite-color tensor block argument,
zero-correlation-safe Hessian constancy and covariance swap, and associated
precision, residual, parity-propagation, and normalization algebra.
`statement_fidelity.md` states its exact boundary. A successful compiler run
does not check the analytic proof above or the inherited source inputs.

Reproduction from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/rigidity_certificate/Main.lean --statement-fidelity research/rigidity_certificate/statement_fidelity.md --claim C_QGR_FINITE_CORE --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python research/rigidity_certificate/verify.py
```

The symbolic script needs SymPy, present in the authorized environment.
The independent Reviewer must replay the certificate, read the analytic proof
and statement fidelity, and decide novelty and significance. Neither main
universality theorem nor the finite-graph entropy input is closed by this work.
