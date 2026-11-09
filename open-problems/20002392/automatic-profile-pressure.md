# Automatic pressure recovery and the H1-only alignment exclusion

This note proves automatic pressure recovery (`CWP_AUTO_PRESSURE`) and states
and proves the complete H1-only alignment corollary (`CWP_ALIGN_H1`).
These are analytic arguments submitted for independent review, not
formal-kernel certificates or independently certified new originality.

## 1. Statement and accepted inputs

Let `H={y in R^3:y_3>0}`, `r=|y|`, `nu>0`, and `a>0`. Suppose `U,P`
solve the backward Leray system

    -nu Delta U + a(U+y dot grad U) + (U dot grad)U + grad P = 0,
    div U=0,                 U|_(y_3=0)=0.                       (1)

Assume `U` is smooth up to the wall and satisfies precisely

    |grad^j U(y)| <= C_j (1+r)^(-1-j),       j=0,1,2.             (H1)

No canonical-pressure condition, finite kinetic energy, or global
integrability of `U+y dot grad U` is imposed. The equation determines
`grad P` locally up to the wall; only an additive constant in `P` is
irrelevant. Write `Pi_H` for the **unweighted L2** Helmholtz projection.

**Automatic pressure theorem.** Under (1) and H1,

    grad P = nu(I-Pi_H)Delta U
                 - (I-Pi_H)((U dot grad)U).                     (H2)

In particular, no extra homogeneous-Neumann harmonic pressure gradient is
possible in this class. This does not discard the canonical Stokes-pressure
component, which is generally nonzero.

For `norm_r(F)=(integral_H r|F|^2 dy)^(1/2)` and `Omega=curl U`, the
**H1-only alignment corollary** is

    U != 0  implies
    norm_r(U cross Omega) / norm_r(Delta U)
       >= nu sqrt(2/3)(1-sqrt(999/1000)) > nu/2500.               (2)

Consequently, under (1) and H1 alone, the alignment inequality

    norm_r(U cross Omega) <= (nu/2500) norm_r(Delta U)             (3)

forces `U=0` and `grad P=0`. Both norms in (2)--(3) are finite under H1.
The denominator in (2) is positive whenever `U` is nonzero.

The accepted input is `CWP_ALIGN`, version 1, in
[`critical-alignment-exclusion.md`](critical-alignment-exclusion.md),
Theorem and sections 1--4: it proves (2)--(3) under H1 **and H2**.
Its inputs are the weighted projection bound `CWP_HELMHOLTZ`, the
critical drift sign `CWP_DRIFT`, and the radial pressure theorem `CWP_999`.
The latter's H1 extension is section 6 of
[`radial-pressure-upper-bound.md`](radial-pressure-upper-bound.md).
These claims and their independent supporting reviews already exist in
`MATH_STATE.json`; they are unchanged dependencies, not new assumptions
about the pressure of the profile in (1). The route `RWP_AUTOMATIC_H1`
records the two obligations `CWP_AUTO_PRESSURE` and `CWP_ALIGN`.

The pressure-recovery proof below is self-contained at the level of
Hilbert-space projection, local Sobolev approximation, and elementary
integration. In particular it proves, rather than cites, the needed harmonic
uniqueness statement. No new external literature theorem is imported.

## 2. Integrability and the weak boundary identity

Set

    F=(U dot grad)U,     G=nu Delta U-F,     W=U+y dot grad U.

H1 gives

    |G(y)| <= C(1+r)^(-3),     |W(y)| <= C(1+r)^(-1).

Thus `G in L2(H) intersect L2(H,r dy)` and `W in L4(H)`. Indeed the
relevant radial tails are bounded by integrals of
`r^2(1+r)^(-6)`, `r^3(1+r)^(-6)`, and `r^2(1+r)^(-4)`.
Smoothness handles bounded sets. This does **not** yet assert `W in L2`.

Differentiation and solenoidality give the exact identity

    div W = 2 div U + y dot grad(div U) = 0.                     (4)

Since the wall trace of every component of `U` is identically zero,
its tangential derivatives vanish there. The term `y_3 partial_3 U`
also vanishes there. Hence `W|_(y_3=0)=0`; no zero normal derivative
of `U` is assumed.

Here and below, `C_c^infinity(closure H)` means restrictions of smooth
compactly supported functions on `R^3`; their wall traces need **not**
vanish. Integrating (4) on a half-ball containing the support of such a
test function gives

    integral_H W dot grad phi = 0
                  for every phi in C_c^infinity(closure H).     (5)

There is no boundary term at infinity because the test is compactly
supported, and the wall flux is zero. This argument only uses local
integrability of `W`.

For clarity, the unweighted Helmholtz decomposition used here is the
orthogonal decomposition with gradient subspace

    G_2 = closure in L2(H;R^3) of
          {grad phi : phi in C_c^infinity(closure H)}.

Thus `I-Pi_H` projects onto `G_2`, and

    integral_H Pi_H G dot grad phi = 0
                  for every phi in C_c^infinity(closure H).     (6)

The gradient part has a potential

    (I-Pi_H)G = grad p,      p in W^(1,2)_loc(closure H).         (7)

Here the local Sobolev notation includes every bounded half-ball meeting
the wall. One can obtain (7) directly from the definition: choose
`grad phi_n -> (I-Pi_H)G` in `L2`, subtract from each `phi_n` its average
over `B_1^+`, and apply Poincare's inequality on each `B_R^+`, `R>=1`.
The fixed-mean version needed is

    ||v||_(L2(B_R^+)) <= C_R ||grad v||_(L2(B_R^+))
                          if integral_(B_1^+) v=0.

It follows from the usual mean-subtracted inequality on `B_R^+` by
bounding the difference of the two averages on `B_1^+`. The normalized
`phi_n` are therefore Cauchy in `W^(1,2)(B_R^+)`. Their compatible
limits give `p`, with no trace or pointwise Neumann condition imposed
on `grad p`.

Equation (1) reads

    grad P = G-aW.

Its right side is bounded on every bounded half-ball. A pressure
representative consequently belongs to `W^(1,2)` there: its bounded
gradient gives a Lipschitz representative on that convex half-ball,
after fixing one additive constant. Hence `q=P-p` is locally
`W^(1,2)` up to the wall and

    h=grad q=grad P-(I-Pi_H)G=Pi_H G-aW
                                   in L2(H)+L4(H).              (8)

Combining (5) and (6) now gives the **full weak Neumann identity**

    integral_H grad q dot grad phi = 0
                  for every phi in C_c^infinity(closure H).     (9)

In particular `q` is harmonic in the interior, and (9) is its homogeneous
weak Neumann condition. Restricting (9) to tests supported away from the
wall would not suffice. No pointwise normal trace of `Pi_H G` or `grad p`
has been taken, and H2 has not been used.

## 3. Harmonic gradients in L2+L4 with zero weak Neumann data

**Lemma.** Suppose `q in W^(1,2)_loc(closure H)`, (9) holds, and

    grad q = f_2+f_4,       f_2 in L2(H),       f_4 in L4(H).

Then `grad q=0`.

**Proof.** Extend the potential evenly:

    q_e(y',z)=q(y',|z|).

Its traces from the two sides agree, so the elementary Sobolev reflection
rule gives `q_e in W^(1,2)_loc(R^3)`. Its weak gradient `K` has even
tangential components and an odd normal component:

    K_parallel(y',z)=(grad q)_parallel(y',|z|),
    K_3(y',z)=sign(z) (partial_3 q)(y',|z|).                     (10)

For `psi in C_c^infinity(R^3)`, take

    phi(y',t)=psi(y',t)+psi(y',-t),       t>=0.

This is an allowed test in (9). Changing variables in the lower half-space
and using (10) gives

    integral_R3 grad q_e dot grad psi
      = integral_H grad q dot grad[psi(y',t)+psi(y',-t)] = 0.    (11)

For the normal derivative, the bracket differentiates as
`partial_3 psi(y',t)-partial_3 psi(y',-t)`, exactly the minus sign from
the odd normal component. Thus (11) proves `Delta q_e=0` as a
distribution on **all** of `R^3`, without a wall-supported residual.
Consequently each component of `K=grad q_e` is distributionally harmonic.

Extend `f_2` and `f_4` with the same componentwise parity as (10).
Call the extensions `K_2,K_4`. Then

    K=K_2+K_4,
    ||K_2||_2=2^(1/2)||f_2||_2,
    ||K_4||_4=2^(1/4)||f_4||_4.                                (12)

Let `rho_epsilon` be a nonnegative smooth compactly supported mollifier
of integral one. For every fixed `epsilon>0`,
`K_epsilon=K*rho_epsilon` is a smooth harmonic vector field on `R^3`.
Young's inequality bounds the `L2` and `L4` norms of the two mollified
summands by the corresponding norms in (12).

The ball mean-value identity for `K_epsilon`, followed by Holder's
inequality for each summand, yields, for every `x in R^3` and `R>0`,

    |K_epsilon(x)|
      <= |B_R|^(-1/2) ||K_2||_2
             + |B_R|^(-1/4) ||K_4||_4.                         (13)

Only the **sum** `K_epsilon` is asserted harmonic; no mean-value property
is used for either summand separately. For completeness, the mean-value
identity for a smooth harmonic scalar `v` follows by differentiating
its spherical mean: its derivative is
`(4pi R^2)^(-1) integral_(B_R(x)) Delta v=0`. The mean at radius zero
is `v(x)`, and radial integration gives the ball identity.

Since `|B_R|=(4pi/3)R^3`, the two terms in (13) tend to zero respectively
as `R^(-3/2)` and `R^(-3/4)`. Thus `K_epsilon(x)=0` for every `x`.
Letting `epsilon` tend to zero in local `L1` gives `K=0` and hence
`grad q=0`. This proves the lemma. No growth condition on `q` itself,
global `L2` bound on `grad q`, or formal Weyl-lemma invocation is needed.

Apply the lemma to (8), with `f_2=Pi_H G` and `f_4=-aW`.
It follows that

    grad P=(I-Pi_H)G,

which is exactly H2. Substitution back into the original equation gives

    aW=Pi_H G.                                                  (14)

Only **now**, since `G in L2` and `a>0`, does `W in L2` follow.
At no point has the unweighted projection been applied to `W`.
This completes the proof of `CWP_AUTO_PRESSURE`.

## 4. Complete quantitative exclusion

We have now verified all hypotheses of the unchanged accepted theorem
`CWP_ALIGN`: the same equation, no slip, positive `nu,a`, H1, and the
newly derived H2. Therefore that theorem already proves (2)--(3).
The following spells out the implication, including its zero-denominator
case and the point at which the drift becomes integrable.

Set

    D=norm_r(Delta U),       L=norm_r(U cross Omega),
    beta=999/1000,           grad p_S=(I-Pi_H)Delta U.

Since `G in L2 intersect L2(H,r dy)`, (14) and the accepted weighted
projection estimate give `W in L2(H,r dy)`. Equivalently, the recovered
equation is

    -nu Delta U + nu grad p_S + Pi_H F + aW = 0.                 (15)

The accepted estimates, with their original hypotheses now established,
are

    norm_r(grad p_S) <= sqrt(beta) D,                            (16)
    norm_r(Pi_H F) <= sqrt(3/2) L,                              (17)
    I=integral_H r W dot Delta U <= 0.                          (18)

For (17), `F=grad(|U|^2/2)-U cross Omega`, and the scalar gradient
is in unweighted `L2`; thus `Pi_H F=-Pi_H(U cross Omega)`.
Equation (18) is exactly the accepted logarithmic-shell argument in
section 3 of `critical-alignment-exclusion.md`. Its required weighted
`W` integrability has just been deduced, not assumed. Its nonpositive
outer angular term is retained; no divergent Hardy terms are subtracted.

All pairings in the `r Delta U` test of (15) are absolutely integrable.
Using `a>0`, (16)--(18) and weighted Cauchy--Schwarz gives

    nu D^2
      = nu integral_H r grad p_S dot Delta U
          + integral_H r Pi_H F dot Delta U + a I
      <= nu sqrt(beta) D^2 + sqrt(3/2) L D.                     (19)

If `D=0`, each component of `U` is harmonic. On a half-ball of radius
`R` it vanishes on the flat boundary and is bounded on the hemispherical
boundary by `C_0/(1+R)`. Applying the scalar maximum principle to both
signs and sending `R` to infinity gives `U=0`. The equation then gives
`grad P=0`.

Otherwise divide (19) by `D^2` to obtain

    L/D >= nu sqrt(2/3)(1-sqrt(beta)).

The unchanged exact constant certificate establishes

    1-sqrt(999/1000) > 1/2000,        sqrt(2/3) > 4/5.

Thus `L/D>nu/2500`, proving (2), and (3) is impossible unless `D=0`.
This proves the full H1-only corollary `CWP_ALIGN_H1`.
The same scale invariance is retained: under
`U_lambda(y)=lambda U(lambda y)`, both weighted norms scale by `lambda`,
and the similarity coefficient becomes `lambda^2 a>0`.

## 5. Improvement, evidence, and limits

The strongest preceding profile result was `CWP_ALIGN` under H1 and H2.
The improvement here is the proved implication **(profile equation + H1)
implies H2**, including the wall condition and the possible critical tail.
Pressure admissibility is no longer an independently imposed hypothesis.
In fact, for solutions of (1) in this H1 class the two formulations are
equivalent; this is not evidence that a strictly larger set of actual
profiles has been excluded.

The new proof is the weak identity (9), its reflected form (11), and the
global vanishing estimate (13). These statements are analytic and
independently checkable; there is no finite-search or numerical assertion
substituting for them. The algebraic and interval inputs in (16)--(19) are
the unchanged accepted artifacts
`pressure-constants-certificate.json` and
`axisymmetric-pressure-certificate.json`, with their existing replay
programs. They are reused without a new run because neither those
constants nor their hypotheses have been changed.

In particular the proof never assumes `W in L2` before (14), never applies
`Pi_H` to `W`, and never uses H2 to prove itself. Omitting the wall tests
from (9) would leave the reflection unjustified; merely knowing an
interior harmonic discrepancy would not prove pressure recovery.

No new profile is constructed. Without the alignment inequality this
note does not prove `U=0`. It does not settle unrestricted half-space
Liouville questions, exterior-domain pressure recovery, optimal constants,
or Millennium regularity. Independent review of the new argument is
pending; the earlier pressure theorem's originality certification is not
inherited as a new originality claim for this corollary.
