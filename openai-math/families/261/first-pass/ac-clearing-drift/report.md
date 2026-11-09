# Fixed-ridge clearing drift: mathematical audit

## Scope and prior result

The target is `lem:leverage-drift`, lines 391--642 of the staged weak-disorder
manuscript's `build/06-clearing.tex`. The question is conditional on one
prestate, with the scalar ridge held fixed during the heat. It is not a
question about the entire spectral construction.

The literal hypotheses include a symmetric dissipative inverse
`g=(M-t diag(r))^{-1}`, real symmetric `M`, `p=Im(r)`, uniformly bounded
`g_ii,r_i`, uniformly positive bounded `p_i`, diagonal lag
`|g_ii-r_i| <= C t^beta`, and fourth-power row sums for `h=sqrt(t) g`
bounded by `H=t^(1+delta)`. The core size is at most `t^(-nu)`.
The predictable pivot maximizes the ridge leverage and has weight
`2 t^(1+e) <= m <= 4 t^(1+e)`. The real residual is centered, has
variance `t-eta`, is bounded by `C sqrt(t)`, and satisfies
`0 <= eta/t <= C t`. The exponents obey
`0 <= nu < (1+delta)/2`, `0 < e < delta-nu`, and
`e/2 < beta < 1/2`. The surrounding section supplies true-terminal
invertibility, so the stated elimination is defined.

There is **no** poststate cap, lower bound on a nonzero singular value,
bound on the condition number of the ridge Gram matrix, or bound on the
torus volume. A finite counterexample to an error estimate is not by itself
a refutation of an asymptotic conclusion.

The staged manuscript already claims both drift conclusions and supplies
a proof. A reconstruction alone is not a new mathematical theorem.
The current audit will separately check the noncommuting normalization,
the symmetric (not Hermitian) row update, the unitary cancellation, and
the uniform error estimates. At initial scope, no false assertion has been
established.

The other main statements are recorded in the shared proof graph:
the weak-disorder paper claims pure absolute continuity on its fixed
interval `I_d` in every fixed dimension at least three, and the planar
paper claims pure-point spectral type at every fixed positive uniform
disorder, with spectrum `[-4-h,4+h]`. Neither follows from certifying this
one heat lemma.

The primary comparator documentation was opened at
<https://raw.githubusercontent.com/openai/math/main/lean/docs/261.md>.
It states: "This selected statement identifies the spectral set. It does
not assert the pure-point spectral type claimed in the accompanying paper."
It supplies no verification of the present heat lemma or either spectral-type
claim. No unproved literature theorem is needed for the finite-dimensional
algebraic route selected here; all nontrivial identities and estimates used
below will be derived explicitly. The supplied Wiki index contained no
entry for this campaign or its clearing-drift question.

## Evidence boundary

Exact finite computations will be identified as checks of algebra, not as a
proof of an asymptotic theorem. The final analytic argument must supply
uniform, positive-power error bounds under all the stated hypotheses.
Independent Reviewer replay and statement-fidelity review remain required.

## Result: a quantitative stochastic row-deletion theorem

All norms in this section are Euclidean operator norms, except for the
trace norm `||.||_1` and Hilbert--Schmidt norm. All expectations are
conditional on the fixed data preceding a single update. Rows are complex
rows and `*` is conjugate transpose.

Let `U` have one distinguished row `a` and remaining rows `u_i`.
Assume `Q=U^*U <= I`, let

    m=||a||^2>0,  m_i=||u_i||^2<=m,  A=Tr Q,
    v=(v_i),  q=||v||^2<=L^2,  H_v=sum_i |v_i|^4,
    b=U_surv^* v,  ||b||<=B.

Let `c` be any bounded complex random variable, and take constants

    |c|<=K,  |E c|<=mu,  s=E|c|^2,
    alpha=|q s-1|,
    d=(K^2 q+1)m+2K B sqrt(m) <= 1/2,
    e_D=alpha m+2mu B sqrt(m),
    z=sqrt(m A H_v),
    J=(1+K L)^2,
    Z=2K L m sqrt(m)+K^2 L^2 m^2.

Define `w_i=u_i+c v_i a`, `W=(w_i)`,
`D=W^*W-Q`, `T=(I+D)^(-1)`, and `m_i'=w_i T w_i^*`.
Define `A'=sum_i m_i'`, `P'=sum_i (m_i')^2`,
and `P=m^2+sum_i m_i^2`. Then

    |E(A'-A)| <= e_D+2d^2,                              (T1)

    E(P'-P) <= -m^2
        +4mu L m sqrt(m)+18K^2 m z+2m e_D+2Z d
        +(6+12J)m d^2+4K^4 m^2 H_v.                    (T2)

These are finite, dimension-free inequalities, not asymptotic notation.
The only size parameter in `z` is the actual total leverage `A`,
not the ambient number of rows or columns. No post-update leverage
cap is assumed.

### Proof of (T1)--(T2)

Exact multiplication, retaining the nonconjugated row `a`, gives

    D=(|c|^2 q-1)a^*a+c b a+conj(c) a^* b^*.

The trace norm of a rank-one product is the product of its vector norms.
Consequently, pathwise,

    ||D||_1<=d,  ||E D||_1<=e_D,  Tr(D^2)<=d^2.         (1)

The matrix `D` is Hermitian. Thus `I+D>0`, `||T||<=2`,
and `||W||^2=||Q+D||<=1+d`. With `V=I-Q`, the exact
noncommutative identity is

    A'-A=Tr[(Q+D)T-Q]=Tr[V T D].                        (2)

Indeed `(Q+D)T-Q=(I-Q)TD` follows from both inverse
identities for `T` and `I+D`; no factors are interchanged.
Also `TD=D-D^2 T`, so (1), `0<=V<=I`, and `||T||<=2`
give (T1). The formal source certifies these algebraic identities
over every unital ring, not merely a fixed matrix size.

For (T2), put `d_i=m_i'-m_i`,

    d_i^0=||w_i||^2-m_i
         =2 Re(c v_i a u_i^*)+|c|^2 |v_i|^2 m.

Since `sum_i |a u_i^*|^2<=m`,
`sum_i m_i^2<=m A`, and Cauchy--Schwarz gives
`sum_i m_i |v_i|^2<=z`, we have

    |sum_i m_i E d_i^0| <= 2mu L m sqrt(m)+K^2 m z.    (3)

Write `R=T-I=-D+D^2T` and
`M=diag((m_i)_surv)`. The old-row matrix
`Z_0=U_surv^* M U_surv` has norm at most `m`.
Replacing these rows by `W` costs

    ||W^* M W-Z_0||_1
      <=2K ||U_surv^* M v|| sqrt(m)+K^2(v^* M v)m
      <=2K L m sqrt(m)+K^2 L^2 m^2=Z.

It follows that the conditional mean of the linear normalization term
has absolute value at most `m e_D+Z d`.
The quadratic normalization term is bounded by

    ||W^* M W|| Tr(D^2 T)
       <=m (1+d) d^2/(1-d)<=3m d^2.

Together with (3), this proves

    |sum_i m_i E d_i|
      <=2mu L m sqrt(m)+K^2 m z+m e_D+Z d+3m d^2.      (4)

For the squared increments, `(x+y)^2<=2x^2+2y^2`
and `|a u_i^*|^2<=m m_i` give, pathwise,

    sum_i |d_i^0|^2<=8K^2 m z+2K^4 m^2 H_v.           (5)

Also `||w_i||^2<=Jm` and, since `R` is Hermitian,

    |w_i R w_i^*|^2<=||w_i||^2 w_i R^2 w_i^*.

Using `||R||_HS^2<=d^2/(1-d)^2` and `||W||^2<=1+d`
therefore gives

    sum_i |d_i-d_i^0|^2<=6Jm d^2.                     (6)

Combining (5)--(6) once more with `(x+y)^2<=2x^2+2y^2`,
and using the exact deleted-pivot identity

    P'-P=-m^2+2sum_i m_i d_i+sum_i d_i^2,

proves (T2), with precisely the coefficients displayed above.
All sums are finite and `c` is bounded, so the exchanges of expectation
and sum require no additional integrability assumption.

## Structural extension: balanced matrix ridges

Let `S` be a finite symmetric unitary matrix, partitioned into `B,R`.
Write `S_B=S_BB`, `C=S_RB`, and `Gamma=C^*C=I-S_B^*S_B`.
Replace the scalar ridge by any fixed positive definite Hermitian
matrix `Lambda` on the core satisfying

    S_B^* conjugate(Lambda) S_B <= Lambda.             (B)

The condition is imposed at the prestate only. Define

    G=Gamma+Lambda,  U=C G^(-1/2),
    V=G^(-1/2) Lambda G^(-1/2)=I-U^*U.

Thus `0<=V<=I` even when `Gamma` and `Lambda` do not commute.
The matrix `Lambda` is held fixed during the heat.

### Unitary cancellation without a singular-value bound

Symmetry gives `conjugate(Gamma)=I-S_B S_B^*`, and hence

    S_B^* conjugate(Gamma) S_B=Gamma-Gamma^2<=Gamma.

Adding (B) proves `S_B^* conjugate(G) S_B<=G`. Therefore

    E_G=G^(-1/2) S_B^* conjugate(G)^(1/2)

is a contraction: `E_G E_G^*<=I`. Orthogonality of the
core columns and column `x` of `S` yields

    U^* S_Rx=-G^(-1/2) S_B^* C_x^T,
    ||conjugate(G)^(-1/2) C_x^T||^2=m_x.

The second equality is transposition of the scalar quadratic form,
not an assumption that `C_x` is real. It follows that
`||U^* S_Rx||<=sqrt(m_x)`. For
`v_i=h_ix sqrt(p_i/p_x)`, on the surviving exterior rows,

    b=U_surv^* v
      =(U^* S_Rx-u_x^* S_xx)/(2i sqrt(t) p_x),
    ||b||<=p_x^(-1) sqrt(m_x/t),                      (7)

because a unitary matrix has `|S_xx|<=1`.
No inverse of `Gamma` and no lower bound on its positive spectrum
has appeared.

### Normalization and strict extension of the scalar case

The symmetric resolvent formula gives exactly
`C'=C_surv+c v C_x`, hence `W=C' G^(-1/2)`.
Since the ridge is unchanged,

    Gamma'+Lambda=G^(1/2)(I+D)G^(1/2).

Its inverse has factors in the order
`G^(-1/2) T G^(-1/2)`, giving the row leverages used in
(T1)--(T2). This proves applicability of the abstract theorem for
balanced matrix ridges.

Every scalar ridge satisfies (B), because
`S_B^* (tau I) S_B<=tau I`. There are also arbitrarily
ill-conditioned nonscalar examples: if `S_B` is real diagonal
with diagonal entries in `[-1,1]`, every positive diagonal
`Lambda` satisfies (B), with unrestricted ratios of its diagonal
entries. More generally, at any fixed prestate with
`Gamma>0`, the scalar ridge has strictly positive balance slack
`tau Gamma`. Sufficiently small Hermitian perturbations of
`tau I` remain positive and balanced; they need not commute
with `Gamma`. The exact matrix replay includes such a
noncommuting example. These examples explain the genuinely larger
ridge class; they are not counterexamples to the manuscript.

## Full uniform application to the manuscript

Choose one constant `C>=2` dominating all its fixed broad, lag and
residual bounds, so `p_i in [1/C,C]`. Set `e=e_0`,
`beta=beta_w`, `H=t^(1+delta)` and `rstar=t^(-nu)`.
Take `t` sufficiently small that

    t<=1,  2C^2 sqrt(t)<=1/2,  C^2 t^beta<=1,
    4t^(1+e)<=1,  320C^2 t^(1/2+e)<=1/2.             (8)

These are explicit prestate-independent thresholds.

For `z_x=xi+t r_x` and `g_x=g_xx`, the heat coefficient is
`c=-z_x/[sqrt(t)(1+z_x g_x)]`. The denominator is at least
`1/2` in modulus by (8). The exact second-order expansion is

    E c=sqrt(t)(g_x-r_x)-(eta/sqrt(t))g_x
        +t^(3/2) g_x r_x^2
        -(g_x^2/sqrt(t)) E[z_x^3/(1+z_x g_x)].

Using only the specified moments and support gives

    |c|<=4C,
    |E c|<=20C^5 t^(1/2+beta),
    |E|c|^2-1|<=50C^4 sqrt(t).                        (9)

For completeness, `E|z_x|^2/t=1-eta/t+t|r_x|^2<=2`.
For `|y|<=1/2`,
`||1+y|^(-2)-1|<=10|y|`; applying this to `y=z_x g_x`
gives the last bound in (9). The cubic remainder is bounded
by `16C^5 t`; since `beta<1/2`, `t<=t^(1/2+beta)`.

Ward's identity, symmetry, and the omitted core/pivot entries give

    |q-1|<=C^2(t^beta+2rstar sqrt(H)),  q<=2,
    sum_i |v_i|^4<=C^4 H,  A<=|B|<=rstar.             (10)

In fact the full-column weighted square sum is
`Im(g_xx)/p_x=1+O(C^2 t^beta)`.
Each omitted entry contributes at most `C^2 sqrt(H)`,
and there are at most `|B|+1<=2rstar` of them.
Equation (7) supplies `B=C sqrt(m/t)`, for either a scalar
ridge or any balanced matrix ridge.

Here are explicit constants and errors, valid simultaneously for
all such prestates:

    D_0=80C^2,  E_0=250C^6,
    epsilon=t^beta+t^(1/2)+t^((1+delta)/2-nu),

    R_A=E_0 epsilon+8D_0^2 t^e,

    R_P=160C^5 t^(beta-e/2)
        +288C^4 t^((delta-e-nu)/2)
        +2E_0 epsilon
        +320C^2 D_0 t^(e/2)
        +3912C^2 D_0^2 t^e
        +1024C^8 t^(1+delta).

Then

    |E(A'-A)| <= m R_A(t),                            (U1)
    E(P'-P) <= -(1-R_P(t))m^2.                        (U2)

To check the constants directly, in (T1)--(T2) use
`K=4C`, `L=2`, `mu=20C^5 t^(1/2+beta)`,
`B=C sqrt(m/t)`. Equations (9)--(10) give

    d<=D_0 m/sqrt(t),  e_D<=E_0 m epsilon,
    z<=sqrt(m rstar C^4 H),
    J<=81C^2,  Z<=80C^2 m sqrt(m).

The last inequality uses `m<=1`. Substitution and
`2t^(1+e)<=m<=4t^(1+e)` give exactly (U1)--(U2).
The certificate checks this scalar bookkeeping independently.

Every power in `R_A,R_P` is strictly positive under the stated
exponent conditions. In particular

    beta-e/2>0,  (delta-e-nu)/2>0,
    (1+delta)/2-nu>0,  e/2>0.

Thus `R_A,R_P -> 0`, uniformly in matrix size, ridge condition
number, residual law within the stated class, and the poststate.
For the manuscript's selected exponents and each fixed `d>=3`,
the displayed bounds specialize to

    |E(A'-A)|/m=O(t^0.0036),
    E(P'-P)/m^2 <= -1+O(t^0.0014).

The constants are large and no practical finite-scale numerical
threshold is claimed. These powers certify convergence, not an
experimentally useful rate.

This is a full analytic verification of `lem:leverage-drift`,
including a heat that first violates a later cap. The proof never
inspects such a cap and does not condition on its holding after
the heat. The balanced-ridge theorem and (T1)--(T2) are a
structural extension, while the scalar-ridge asymptotic assertion
itself was already claimed in the staged manuscript.

## Certification and limitations

`verify.py` replays exact rational/complex matrix identities, rechecks
the Jacobian output by two-sided multiplication, detects intentionally
wrong conjugation and inverse-order substitutions, verifies the scalar
coefficient majorants, and checks exact exponent certificates. These
finite computations alone do not prove the uniform theorem; the
preceding argument is its mathematical proof.

The exact replay completed successfully: eight dissipative-matrix
checks (two residual values and four ridges), three stochastic
row-deletion checks, both mutation detections, and all scalar
majorants/exponent checks passed. The dissipative fixtures include
a full-rank old cross block becoming rank deficient and a balanced
ridge not commuting with the old Gram matrix. They are algebraic
fixtures, not families claimed to satisfy the small-`t` prestate
hypotheses.

`Main.lean` addresses the noncommuting algebra only, as specified
in `statement_fidelity.md`. Its compiler result is attached only
to `C_AC_NONCOMM`, not to the full drift claim. The analytic
inequalities require independent mathematical review.

The real compiler run completed in Lean 4.31.0 with `exit_code=0`,
`audit_exit_code=0` and `proof_holes=[]`. Its archived certificate is
`certificates/C_AC_NONCOMM-b0d10029dee07bbb.json`. The source and
statement-fidelity document have not been edited since that run.
This closes the formal ring-identity claim in the kernel ledger;
it does not close either analytic drift claim in the kernel.

From the campaign root, the standalone exact replay is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/ac-clearing-drift/verify.py
```

It compares the newly computed exact answer with `exact_certificate.json`
and fails on a mismatch. Python with SymPy is its only runtime dependency;
neither Jacobian nor Argus is required to replay the stored exact
mathematical answer. Re-executing the external adapter is not needed
to check its returned inverse.

To recompile the unchanged formal source and attach the real result:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/ac-clearing-drift/Main.lean --statement-fidelity research/ac-clearing-drift/statement_fidelity.md --artifact-dir research/ac-clearing-drift --project-root . --claim C_AC_NONCOMM
```

The initial broad web search did not return a matching primary
source for the balanced-ridge stochastic deletion theorem. Its generated
summary confused a unitary matrix with its contractive core block and
was not used as evidence. The primary abstract of El Alaoui and Mahoney,
*Fast Randomized Kernel Methods With Statistical Guarantees*,
arXiv:1411.0306v3, was opened; it concerns statistical sketching and
importance sampling, not this heat process. Neither a negative search
nor that abstract proves novelty. No literature theorem is imported
into the proof. Novelty and publishable significance remain questions
for independent review, not statuses inferred from exact arithmetic.

No false manuscript assertion has been established in this audit.
Accordingly there is no fabricated `F_` refutation claim. The
finite-volume certificate, clearing-trial concentration/geometry,
assembly/history, spectral readout and planar spectral-type proof
remain open in the graph. The present result must not close those nodes.
