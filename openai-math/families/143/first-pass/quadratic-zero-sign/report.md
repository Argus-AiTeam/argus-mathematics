# Exact endpoint obstruction for quadratic Riccati arcs

## Result and scope

We derive an exact, universally quantified endpoint-obstruction theorem that
implies Lemma `model:zero-sign` of the staged **Two limit cycles for quintic
Lienard systems** (September 24, 2026), once its actual-arc analytic
constraints are supplied. The theorem includes the diagonal, unit endpoint
derivative, vanishing auxiliary polynomial and zero-radicand boundaries.
It is not a finite-sample assertion or an inference from arbitrary endpoint
jets. No false manuscript assertion has been established by this work.

The independent contribution is a denominator-cleared real-algebraic
formulation of the *entire* sign obstruction, with a formal proof and exact
rational reductions connecting it to the arc quantities. The strongest
previously persisted state contained only the campaign objective, not a
certificate for this obstruction. This advances that state to an explicit
unbounded verification theorem. Literature novelty, publishable significance,
the analytic fidelity bridge and independent replay remain questions for the
Host-invoked Reviewer; they are not Engineer-certified novelty claims.

In particular, this does **not** verify the quintic cycle bound, its global
quadratic inverse, characteristic propagation of the model inequality, or
any absolute-zero, packet, geometric-template or projection assertion in
**Uniform bounds for planar polynomial limit cycles**. Their dependencies are
recorded as unaudited in `../PROOF_GRAPH.json`.

## 1. Actual arcs and derivative conventions

Consider a positive arc of

\[
 u_y=du+bu^2-y,\qquad b>0,
\]

with base-zero endpoints \(-m,n\), peak \(t>0\), half-width \(r\), and
midpoint \(H\). Thus
\[
 m=r-H>0,\quad n=r+H>0,\quad
 m_r=1-H_r>0,\quad n_r=1+H_r>0.
\]
Throughout, \(r\)-derivatives of model quantities fix \(d\) and \(b\);
\(m\)-derivatives fix the same profile and use \(m\) as local coordinate.
They are not derivatives along a fixed-peak characteristic. Set
\[
 \ell=n_m>0,\quad w=\ell_m/\ell,\quad
 {\cal S}=\ell_{mm}/\ell-\tfrac32w^2,\quad
 w_m={\cal S}+\tfrac12w^2.
\]
Write \(\kappa=2b\), \(P=H_d\), \(Q=H_\kappa\), \(R=P_r\),
\(S=Q_r\), and \({\cal W}=RS_r-SR_r\). In this report, \({\cal S}\)
is the Schwarzian, and \(S\) without calligraphic type is \(Q_r\).

Here are the analytic facts used below, and their justifications.

* **Smooth transverse arc families.** Every critical point of an arc has
  \(u_{yy}=-1\), hence is a strict maximum. On either side of a fixed peak,
  the solution must reach a given lower level at finite \(y\): while its
  height remains in the compact level interval, the profile is bounded,
  and \(\phi(u)-y\) has an outward sign and eventually magnitude exceeding
  one. There is no finite-coordinate continuation failure in that compact
  strip. At base zero \(u_y(-m)=m\), \(u_y(n)=-n\), giving transversality.
  The peak variation solves \(\xi_y=\phi'(u)\xi\), \(\xi(\phi(t))=1\),
  so \(\xi>0\), both endpoints move strictly outward with peak height,
  \(t_r>0\), and \(|H_r|<1\). These are the local/global arc inputs in
  `arcs.tex`, Lemma `lem:arc-data`.
* **Small-width regularity.** The scaling \(u=r^2s\), \(y=r\zeta\)
  turns the profile into \(drs+br^3s^2\), a smooth finite-parameter
  perturbation of a regular parabolic width-one arc. Transversality and
  local implicit inversion give differentiable expansions through width
  zero, as in `lem:arc-scaling`. For a finite peak slope \(z_0\),
  \(\theta=z_0r/3+O(r^2)\), \(L=2z_0r/3+O(r^2)\).
* **Positive parameter variations.** The endpoint variation formula has a
  positive denominator and integrates a positive weight times the profile
  variation. For variations \(u\) and \(u^2/2\), the integrands are strictly
  positive in the arc interior, hence \(P,Q>0\).
  To obtain the only further parameter sign needed here, \(R>0\), let
  \(L=\operatorname{arctanh}H_r\), and let
  \({\cal L}_\kappa(r,z_0)\) be its reference-characteristic value.
  The reference slope satisfies \(j_{z_0}>0\): translate the fixed profile
  \(\kappa u^2/2\), and use
  \(h_t|_r=-r_t/r_h>0\), where \(r_h=-r/(r^2-H^2)<0\).
  The linearized angle equation has positive forcing \(j_{z_0}\),
  initial \(\theta_{z_0}=r/3+O(r^2)>0\), and a positive integrating
  factor. Thus \(\theta_{z_0}>0\), and the differentiated integral for
  \({\cal L}_\kappa\) gives \(\partial_{z_0}{\cal L}_\kappa>0\).
  Since \(z_0=d+\kappa t(r)\),
  \[
   L_r|_{d,\kappa}=\frac{2H}{r^2-H^2}
        +\kappa t_r\,\partial_{z_0}{\cal L}_\kappa.
  \]
  Differentiating the width identity below gives
  \[
   R=\frac{r(1-H_r^2)}{r^2-H^2}
          t_r\,\partial_{z_0}{\cal L}_\kappa>0.
  \]
  This uses only the reference facts of `fitting.tex`, `fit:references`
  and `fit:positive-derivatives`, not the global inverse or \(G>0\).

These are classical analytic arguments, not Lean-checked ODE theorems.
They remain explicit analytic premises in the claim ledger rather than
being silently promoted to kernel evidence.

For orientation, fixed-peak transport is instead
\[
 {\cal D}=\kappa\partial_d-\alpha\partial_r,\qquad
 \alpha=r/(r^2-H^2)>0.
\]
Its outward-width derivative is \(-{\cal D}/\alpha\). No equality between
that derivative and a fixed-model partial derivative is used here.

## 2. Endpoint determinant and gamma reduction

Define
\[
 X=\frac{\ell/m-1/n}{1+\ell},\quad
 Z=\frac{\ell m-n}{1+\ell},\quad
 \gamma=\frac{\ell/m^2+1/n^2}{1+\ell}.
\]
Base-height transport and width scaling, respectively, give
\[
 X=\kappa P+d,\qquad Z=dP+3\kappa Q.
\]
For completeness, translation of the quadratic profile to base height
\(h\) changes its slope to \(d+\kappa h\), so the arc transport formula
gives \(\kappa P+d=(rH_r+H)/(r^2-H^2)\).
Scaling \(H(d,\kappa,r)=rH(dr,\kappa r^3,1)\) gives
\(rH_r-H=dP+3\kappa Q\). Substituting \(m,n,\ell\) gives \(X,Z\).

Put
\[
 D_*=(m-n){\cal S}
 +[1-2n/m+\ell(2m/n-1)]w+\tfrac12(m+n)w^2
\]
and
\[
 w_*=\frac{2(\ell m^4-2\ell m^3n+2mn^3-n^4)}
                {m^2n^2(m+n)}.
\]
Exact differentiation, using \(n_m=\ell\), \(\ell_m=\ell w\), and
\(w_m={\cal S}+w^2/2\), yields
\[
 Z_m=\frac{w\ell(m+n)}{(1+\ell)^2},\qquad
 X_m=\frac{\ell(1/n^2-1/m^2)}{1+\ell}+\frac{Z_m}{mn},
\]
\[
 X_mZ_{mm}-Z_mX_{mm}
 =\frac{\ell^2(m+n)^2}{m^2n^2(1+\ell)^3}D_*
 =\frac{3\kappa^2}{m_r^3}{\cal W}.                 \tag{1}
\]
The last equality follows first by differentiating \(X,Z\) at fixed
model parameters with respect to \(r\), then applying the coordinate
chain rule. In particular,
\(X_m=\kappa R/m_r>0\), even when \(Z_m=0\) or \(w=0\).

At \({\cal W}=0\), let \(\sigma_0=R_r/R\) and
\(\sigma=X_{mm}/X_m\). The determinant gives
\(Z_{mm}=\sigma Z_m\), without division by \(Z_m\). The chain rule gives
\[
 \sigma m_r^2=\sigma_0m_r-m_{rr},\qquad
 \gamma_{rr}-\sigma_0\gamma_r
       =m_r^2(\gamma_{mm}-\sigma\gamma_m).           \tag{2}
\]
When \(m\ne n\), exact elimination of \({\cal S}\) from \(D_*=0\)
in the differentiated gamma expression gives
\[
 \gamma_{mm}-\sigma\gamma_m
 =\frac{\ell(m+n)^2}{(1+\ell)m^2n^2}
                      \frac{w_*-w}{m-n}.          \tag{3}
\]

`verify.py` independently constructs the rational functions and their
derivatives. It checks (1) identically and checks (3) after multiplying by
\(X_m\) and substituting the consequence of \(D_*=0\).
The only eliminated denominator newly requiring \(m\ne n\) is \(m-n\);
\(X_m>0\) is supplied by the actual-arc variation. The diagonal is
excluded separately below, before this division.

## 3. What genuine quadratic arcs add

### Schwarzian and positive linearization

On the compact actual arc define
\[
 V(y)=\exp\left(-\int_{-m}^y(bu(s)+d/2)\,ds\right)>0,\qquad U=uV.
\]
Direct differentiation gives the regular system
\[
 U'=(d/2)U-yV,\qquad V'=-bU-(d/2)V.
\]
Complete \((U,V)\) to a fundamental pair. Its determinant \(\Omega\)
is a nonzero constant because the matrix has trace zero. At both
endpoints \(U_1=0,V_1>0\), whence \(U_2=-\Omega/V_1\ne0\).
Thus the *same* ratio \(f=U_1/U_2\) is regular near both endpoints,
with \(f'=y\Omega/U_2^2\ne0\) there. Nearby arcs have endpoint relation
\(f(n(m))=f(-m)\). No scalar solution or ratio is asserted to be
regular throughout the intervening interval.

Locally away from \(y=0\), eliminating \(V\), then dividing \(U\) by
\(\sqrt{|y|}\), gives
\[
 \widetilde U''=
 \left(by+d^2/4-d/(2y)+3/(4y^2)\right)\widetilde U.
\]
For two independent solutions of \(a''=Qa\), their ratio has
Schwarzian \(-2Q\): its logarithmic derivative is \(-2c'/c\),
so the Schwarzian is \(-2c''/c\). Differentiating
\(f(n(m))=f(-m)\) three times gives the Schwarzian chain rule and hence
\[
 {\cal S}=2b(m+n\ell^2)+\tfrac12d^2(\ell^2-1)
 -d(1/m+\ell^2/n)+\tfrac32(\ell^2/n^2-1/m^2).       \tag{4}
\]
This derives the classical ratio and chain identities instead of relying
on an unopened literature theorem.

### Riccati upper bound, including the zero radicand

The initial-endpoint variation is
\[
 u_m(y)=mV(-m)^2/V(y)^2.
\]
Endpoint differentiation and logarithmic differentiation therefore give
\[
 \ell=\frac{mV(-m)^2}{nV(n)^2},\quad
 w=\frac1m-\frac{\ell}{n}+d(1+\ell)
       +2bmV(-m)^2\int_{-m}^nV^{-2}\,dy.           \tag{5}
\]
These formulas account for both moving endpoints; the boundary terms
from \(2bu\) vanish because \(u=0\) there.

If \(d<0\), \(d^2\ge4bm\), put \(\nu^2=d^2/4-bm\), \(\nu\ge0\).
The positive function \(v_0(s)=V(-m+s)/V(-m)\) solves
\[
 v_0''=(\nu^2+bs)v_0,\quad v_0(0)=1,\quad v_0'(0)=-d/2.
\]
Compare it with
\[
 f_\nu(s)=\cosh(\nu s)-\frac{d}{2\nu}\sinh(\nu s)
 \quad(\nu>0),\qquad f_0(s)=1-ds/2.
\]
Variation of constants has kernel \(\sinh(\nu s)/\nu\), or \(s\)
when \(\nu=0\). Its nonnegativity and the known positivity of \(v_0\)
give \(v_0\ge f_\nu>0\) over the actual finite interval. Consequently
\[
 V(-m)^2\int_{-m}^nV^{-2}\,dy
 \le\int_0^\infty f_\nu^{-2}\,ds
 =\frac1{\nu-d/2}.
\]
For \(\nu>0\), substitute \(q=\tanh(\nu s)\); for \(\nu=0\),
integrate \((1-ds/2)^{-2}\) directly. The denominator is strictly
positive in both cases. Since
\(2bm/(\nu-d/2)=-d-2\nu\), (5) gives
\[
 w\le1/m-\ell/n+d\ell-2\nu.                        \tag{6}
\]
Thus the equality case \(d^2=4bm\) is genuine, not removed by dividing
by \(\nu\).

### Three analytic branch constraints

Let \(\theta=\operatorname{arctanh}(H/r)\) and
\(L=\operatorname{arctanh}H_r\). On a finite-peak characteristic,
\[
 j'=-s\kappa\operatorname{sech}^2\theta<0,\quad
 \theta'=j-\sinh(2\theta)/s,\quad
 L(r)=\int_0^r\sinh(2\theta(s))/s\,ds,\quad \ell=e^{2L}.
\]
These identities give the following actual-arc information:

1. If \(m\le n\), the final angle is nonnegative. The peak slope must
   be positive; a nonpositive peak slope would make the forcing negative
   at all positive widths. The angle starts positive and cannot cross
   zero before the final point, since a first crossing would have
   \(j\le0\), with \(j<0\) thereafter. Hence its interior is positive,
   \(L>0\), and \(\ell>1\).
   The fixed-model derivative formula in Section 1 has a nonnegative
   first term and a strictly positive second term, so
   \(w=2L_r|_{d,\kappa}/m_r>0\).
2. If \(m>n\), then \(d<0\). Otherwise the decreasing driving slope
   would be positive at every earlier width, forcing a positive final
   angle, a contradiction.
3. If \(m>n\) and \(\ell\ge1\), then \(w\ge0\). Here (4) gives
   \({\cal S}>0\). Along the fixed-profile family the \(m\)-domain is
   \((0,M_*)\), possibly with finite \(M_*\), and initially
   \(\ell=1+(4/3)dr+O(r^2)<1\).
   On any component of \(\{m-n>0,\ell>1\}\),
   \((m-n)_m=1-\ell<0\). Its left endpoint is interior, has \(m-n>0\),
   and must enter through \(\ell=1\), with \(w\ge0\).
   Since \(w_m={\cal S}+w^2/2>0\), one has \(w>0\) throughout.
   At a point with \(m>n,\ell=1,w<0\), points just to the left
   contradict that result. If \(w=0\), then
   \(\ell_{mm}={\cal S}>0\), again giving \(\ell>1,w<0\) just to the
   left. This also excludes the zero-derivative boundary.

Finally \(X=d+\kappa P\) and \(P>0\) give the strict endpoint constraint
\[
 d<\frac{\ell/m-1/n}{1+\ell}.                       \tag{7}
\]
Arbitrary endpoint jets need not satisfy any of (4), (6), (7) or these
branch conditions; their failures are not manuscript counterexamples.

## 4. Endpoint normalization is at a point, not along a curve

Fix \(N=n>0\) at the point being tested. The constant transformation
\(y=N\widetilde y\), \(u=N^2\widetilde u\) gives
\[
 \widetilde d=Nd,\quad \widetilde b=N^3b,\quad
 \widetilde m=m/N,\quad \widetilde n=1,\quad
 \widetilde\ell=\ell,\quad \widetilde w=Nw,\quad
 \widetilde{\cal S}=N^2{\cal S},\quad
 \widetilde D_*=ND_*,\quad \widetilde w_*=Nw_*.
\]
This is a constant change of coordinates for nearby arcs. It is
**not** the invalid instruction to impose \(n(m)\equiv1\) while
differentiating. `verify.py` checks the scaling identities, including
the \(N^{-4}\) scaling of (3).

Below suppress tildes, so the endpoint is \(n=1,m=z>0\), and \(d,b,w\)
are the scaled quantities. Put
\[
 \begin{split}
 K&=z^2(z+1),& v&=Kw,\\
 W_0&=2[\ell z^3(z-2)+2z-1],&
 B_0&=z-2+\ell z(2z-1),\\
 s&=z^2{\cal S},&
 s_0&=\tfrac32(\ell^2z^2-1),\\
 T&=2\ell z^3-\ell z^2-z+2,&
 A&=2\ell z^3-3\ell z^2+3z-2,\\
 J&=W_0+zB_0,&
 F&=v^2+2zB_0v+2z^2(z^2-1)s.
 \end{split}
\]
In Lean these are `K`, `v`, `W`, `B`, `schwarzian`, `S0`, `T`, `A`,
`J` and `F`. The polynomial `W` is **not** the manuscript's
Wronskian \({\cal W}\). Exactly,
\[
 F=2z^4(z+1)D_*,\qquad w_* = W_0/K.                \tag{8}
\]

## 5. Universal algebraic verification theorem

**Theorem.** For every real \(z,\ell,d,b,v\) with \(z,\ell,b>0\),
let \(s\) be (4) multiplied by \(z^2\), with \(n=1,m=z\).
Assume (7), the three branch constraints above (with \(v\) replacing
the same-sign \(w\)), and the following cleared version of (6):
if \(d<0\) and \(d^2\ge4bz\), there exists \(\rho\ge0\) such that
\[
 \rho^2=d^2-4bz,\qquad
 v\le z(z+1)+(d\ell-\ell-\rho)K.                   \tag{9}
\]
If \(F=0\), then
\[
 z\ne1,\qquad \frac{W_0-v}{z-1}>0.                \tag{10}
\]
No arc-realizability assumption is needed beyond these explicit
constraints. This is a structural real-algebraic theorem about all tuples
satisfying them, not only tuples obtained from ODE solutions.

**Proof.**
When \(z<1\), the branch conditions give \(\ell>1,v>0\), whereas
\[
 W_0/2=-(1-z)^3(z+1)-(\ell-1)z^3(2-z)<0.
\]
Both numerator and denominator of (10) are negative.
At \(z=1\), before forming that quotient, (8) becomes
\[
 F=v[v+2(\ell-1)]>0,
\]
contradicting \(F=0\).
When \(z>1,\ell\ge1\), one has \(d<0,v\ge0\).
Every group in the expression defining \(s\) is nonnegative, and
several are positive; also
\[
 B_0=(\ell-1)z(2z-1)+2(z^2-1)>0.
\]
Thus \(F>0\), excluding this case, including \(\ell=1\).

It remains to show that \(z>1,0<\ell<1,v\ge W_0\) forces \(F>0\).
First \(W_0>0\), since
\[
 W_0/2=(1-\ell)(2z-1)+\ell(z-1)^3(z+1)>0.
\]
The affine-in-\(\ell\) polynomials \(A,J\) are positive. Writing
\(x=z-1>0\), their values at \(\ell=0,1\) are
\[
 A_0=3x+1,\quad A_1=x(2x^2+3x+3),\quad
 J_0=x^2+4x+1,\quad J_1=2x(x+2)(x^2+x+1).
\]
Exact identities give
\[
 \begin{split}
 \Delta&:=z(z+1)-\ell K-W_0=-(z-1)T,\\
 F(v)-F(W_0)&=(v-W_0)(v-W_0+2J)\ge0,\\
 F(W_0)&=(z^2-1)AT+2z^2(z^2-1)(s-s_0),\\
 s-s_0&=-\tfrac12(d^2-4bz)z^2
          +\ell^2z^2(2b+d^2/2-d)-dz.             \tag{11}
 \end{split}
\]
If the discriminant is nonnegative, (9), \(v\ge W_0\), \(d<0\)
and \(\ell>0\) give the strict inequality
\(\rho K<\Delta\).

If \(T\ge0\), then \(\Delta\le0\), so this is impossible for
\(\rho\ge0\). Consequently \(d^2<4bz\), and (11) gives
\(s-s_0>0\). Hence \(F(W_0)>0\) and \(F(v)>0\).
This includes \(T=0\) and excludes the discriminant-equality boundary
without taking a limit.

If \(T<0\), then
\[
 z-2>\ell z^2(2z-1)>0.
\]
In particular \(z>2\), and \(z^2(2z-1)>3\), giving \(z>2+3\ell\).
The cleared form of (7),
\(dz(1+\ell)<\ell-z\), now implies \(-dz>2\).
Rewrite (4) as
\[
 s=-\tfrac12(d^2-4bz)z^2+
   \ell^2z^2(2b+d^2/2-d+3/2)-dz-3/2.             \tag{12}
\]
If \(d^2\le4bz\), this is positive immediately.
Otherwise (9) gives
\(\rho K<\Delta<z(z+1)\), so \(0\le\rho z<1\).
Thus \((d^2-4bz)z^2<1\); (12) is again strictly positive.
As \(z>2\), \(B_0>0\), and \(v\ge W_0>0\), one obtains \(F>0\).
All possibilities under \(v\ge W_0\) have been excluded, proving
\(v<W_0\), hence (10). QED.

This proof is the substantive content of `Main.lean`,
`endpoint_zero_sign`, especially the declaration `obstruction`.
It does not replace the required implication by an isolated identity,
a collection of samples, or positivity assumed as a premise.

## 6. Fidelity bridge to `model:zero-sign`

At a genuine point with \(\kappa>0,{\cal W}=0\), (1) gives \(D_*=0\).
Sections 1 and 3 supply every hypothesis of the algebraic theorem.
Section 4 and (8) identify its zero condition correctly.
The theorem excludes \(m=n\) *before* (3) is used. Combining (2), (3)
and the normalization gives, with \(a=m_r/N^2>0\),
\[
 \gamma_{rr}-\sigma_0\gamma_r
 =a^2\frac{\ell(z+1)^2}{(1+\ell)z^2K}
                  \frac{W_0-v}{z-1}>0.
\]
The positive expression is also the conclusion of the Lean declaration
`endpoint_gamma_positive`. This establishes the requested endpoint
implication, conditional on the explicitly stated smooth-arc analytic
facts. The sign of a first-zero *outward characteristic derivative* would
then be \(G(\gamma_{rr}-\sigma_0\gamma_r)/\alpha>0\), but global use of
that fact is outside this certification target.

## 7. Exact evidence and replay

From the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/quadratic-zero-sign/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/quadratic-zero-sign/Main.lean --project-root . --claim V_QUADRATIC_ZERO_SIGN --statement-fidelity research/quadratic-zero-sign/statement-fidelity.md
```

The installed verifier takes the source as a positional argument.
No project Lake file is created; the host's built Lean 4.31.0 Mathlib
workspace supplies the library. `statement-fidelity.md` specifies all
quantifiers, cleared variables, hypotheses and nonformal analytic inputs.
The successful real compiler run returned exit code **0**, `proof_holes=[]`,
and axiom lists containing only `propext`, `Classical.choice` and
`Quot.sound` for both principal theorems. Its source-bound archive is
`certificates/V_QUADRATIC_ZERO_SIGN-599e35625443b276.json`.
The verifier also maintains the identical canonical copy
`statement_fidelity.md`; neither reading is relabeled after compilation.

`verify.py` needs only Python and SymPy. It reconstructs the rational
derivatives rather than trusting stored coefficients, checks the exact
polynomial factorizations and positivity decompositions, and compares its
deterministic output with `exact_certificate.json`. Boundary regressions
and a bounded search of rational determinant-zero tuples are separately
identified as **finite regressions, not the proof and not actual-arc
witnesses**. The universal sign proof is in Lean and in Section 5.
The script also compares the current formal source and fidelity text with
the successful compiler archive; that comparison is not described as a new
compiler run.

Before that computation, the isolated Argus adapter discovered Jacobian
0.14.0, protocol `2025-11-25`. Inspection showed that a rational box
enclosure cannot establish the unbounded implication. The exact symbolic
matrix-product contract does match the row-by-column endpoint determinant.
The one bounded call with the retained exact payload was rejected:
`INVALID_REQUEST`, `matrix.budget_exceeded`, 256-term exact-result budget;
adapter exit code 2, no external timeout. This is **no mathematical
conclusion**. The full discoveries, inspected contracts, payload, structured
error and statuses are retained in `jacobian/`. SymPy supplies the exact
identity replay; the Lean kernel supplies the universal sign proof.

## 8. Source and review limitations

The primary source is the staged September 24, 2026 quintic manuscript:
`build/sections/model.tex` (`model:endpoint-algebra`, `model:Riccati`,
`model:zero-sign`), together with `arcs.tex` (`lem:arc-data`,
`lem:variation`, `lem:arc-scaling`), `fitting.tex` (`fit:references`,
`fit:positive-derivatives`, `lem:fit-transport`) and `transport.tex`
(`prop:third-derivative`, where fixed-model and fitted derivatives meet).
No external theorem is needed for the algebraic core; the classical
Schwarzian identities are derived above. External literature claims and
novelty were not verified.

`MATH_STATE.json` keeps the actual-arc analytic dependencies attached to
`Q_ZERO_SIGN`; `V_QUADRATIC_ZERO_SIGN` concerns the explicit universal
algebraic theorem only. Unaudited manuscript theorems are not marked proved.
No `F_` refutation claim is appropriate merely because a strengthened
criterion or an arbitrary endpoint tuple fails; no such failure is
reported as a refutation here. Independent Reviewer confirmation has not
been supplied by Engineer and must be obtained through the Host.
