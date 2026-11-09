# Toroidal volume metrics: verification and two structural extensions

## Result and scope

This report gives an independent proof of the complete statement
`g:toroidal-volume`, including `g:volume-subklt`, in *Metric descent and
rank-preserving contractions* (OpenAI, September 26, 2026). No false
assertion in that theorem or its proof has been established. In particular,
there is no refutation of anticanonical nonvanishing here.

The proof also gives two extensions:

1. The metric theorem remains true with an arbitrary equidimensional
   morphism from a normal variety **locally of klt type**, without a
   toroidal-morphism hypothesis.
2. On toroidal boundary primes with exceptional total pullback, the
   constructed metric has an **exact simultaneous perturbation chamber**
   for unweighted integrability. The endpoints fail already at divisors
   on the intermediate model, not only at higher valuations.

The complete geometry and analysis are proved below, relative to the
explicitly cited smooth direct-image theorem and curvature formula.
`Main.lean` formalizes the universal determinant, correction, and
discrepancy arithmetic, not the analytic theorem. `verify.py` independently
replays the exact Jacobian output, symbolic identities, adversarial
rational tests, and freshness of the real compiler record. None of those
finite tests is substituted for the proof.

The original theorem is already a claim of the staged manuscript.
The extensions are independently derived here, but their novelty and
publication-level significance have **not** been established. In
particular, the log-canonical-threshold ingredients are classical.
No independent campaign Reviewer has yet accepted these results.

## 1. Exact target and dependencies

The source is

`research/openai_manuscript/Metric-descent-and-rank-preserving-contractions-September-26-2026/build/source/sections/toroidal-volume.tex`,

Theorem `g:toroidal-volume`, Lemma `g:volume-subklt`, and their proofs.
The source explicitly assumes:

- smooth connected projective complex varieties \(X,Y\), with
  \(n=\dim X\), \(d=\dim Y>0\);
- a smooth semipositive Hermitian metric \(h\) on \(L=-K_X\), of
  curvature \(\alpha\);
- a normal integral \(W\), projective birational \(p:W\to X\), and
  projective surjective equidimensional \(f:W\to Y\), toroidal for
  strict toroidal embeddings;
- a smooth projective resolution \(\rho:Z\to W\),
  \(\pi=p\rho\), \(g=f\rho\), \(E_Z=K_{Z/X}\), and the **full**
  generic rank condition
  \(\operatorname{rk}g_*\mathcal O_Z(E_Z)=1\).

For a prime \(Q\subset Y\), and a prime \(E\subset W\) dominating it,
write
\[
a_E=\operatorname{ord}_E K_{W/X},\qquad
e_E=\operatorname{ord}_E f^*Q,\qquad
\lambda_Q=\min_{E\mapsto Q}\frac{1+a_E}{e_E}.
\]
There are finitely many such components, and at least one: pull back
the Cartier divisor \(Q\) under a surjective equidimensional map.
The correction is
\[
a_Q=\max(0,\lambda_Q-1),\qquad A_0=\sum_Q a_QQ.
\]
The literal main conclusions include:

> Then \(A_0\) is an effective rational divisor with finite support, and
> \(f^*A_0\) is \(p\)-exceptional.

and

> The rational line bundle \(-K_Y+A_0\) has a singular Hermitian metric
> of semipositive curvature whose squared frame norms are locally
> integrable without a divisor weight.

The metric is smooth on a nonempty Zariski open. The additional
strictness premise is
\[
\pi^*\alpha\geq c\,g^*\omega_Y
\]
on a nonempty ordinary open patch in the smooth base-change locus,
disjoint from \(E_Z\), with \(c>0\). Its conclusion is strict
positivity on a nonempty **ordinary** base open, not a global lower
curvature bound.

The analytic input is Berndtsson, *Curvature of vector bundles associated
to holomorphic fibrations*, Annals of Mathematics 169 (2009), 531-560,
doi:10.4007/annals.2009.169.531, Theorem 1.2, Proposition 4.2, and
formula (4.8). An independent primary-source reader checked these
passages. The primary PDF, its extracted text, and the short attributed
excerpt are in `literature/`. The source requires a Kähler total space;
that holds here because \(Z\) is projective. Its later product-family
and fiberwise-strict assumptions are not premises of formula (4.8).

The other background facts used are resolution of singularities,
the codimension-one criterion for regularity on a normal variety,
the one-variable removable-singularity theorem for bounded-above
subharmonic functions, and change of variables/Tonelli for nonnegative
measures. The only toroidal discrepancy calculation needed is proved
directly in section 3.

### Seven-manuscript dependency boundary

The ledger and proof graph now contain the principal statements of all
seven manuscripts, not just the headline sentence:

| Manuscript | Principal claims and relevant alternative dependencies |
|---|---|
| Smooth semipositivity (H) | `C_H_MAIN`, finite-volume theorem `C_H_FINITE_VOLUME`, invariant orbit transfer, compact-monodromy structure, and finite-etale norm. The H transfer argument does not depend on the G volume theorem being audited. |
| Invariant indices (I) | `C_I_INDEX` retains the actual value at exponent zero for the natural linearization; `C_I_CONVERSION` is ordinary pseudoeffective-error conversion. These are different mechanisms. |
| Bounded klt metrics (B) | `C_B_KLT` retains effective boundary, Q-factoriality, bounded metric and nonzero resolution Euler characteristic. `C_B_INVARIANT` uses a stable quotient, not the G volume construction. |
| Cohomological transfer (C) | `C_C_TRANSFER` is character-sensitive transfer for any anticanonical linearization; `C_C_HARMONIC` is a separate smooth-coefficient/continuous-base-twist mechanism. |
| Metric descent (G) | `C_G_VOLUME`, its four analytic/algebraic obligations, controlled-pole transfer, and `C_G_CONTRACTION`, which must preserve both its generic section and invariant ranks. |
| Controlled boundary (E) | `C_E_BOUNDARY`, `C_E_RING`, and conversion. The smooth unweighted/toroidal route and the singular globally-strict route are alternatives. The ring theorem itself assumes its metric; the volume theorem supplies that premise only in applications. |
| Exact orders (V) | `C_V_EXACT` depends on the null-polar model/rank/strictness interface, `C_G_VOLUME`, the E correction ring, and the finite-generation endpoint argument. Its invariant consequence is `C_V_INVARIANT`. |

This report verifies the G theorem, not the model/rank hypotheses in
every E or V application, the invariant-index theorem, the correction-ring
theorem, or any of the independent proofs of headline nonvanishing.

## 2. Correction arithmetic and exceptional support

At the generic point of every prime of \(W\), normality makes \(W\)
smooth. The Jacobian of its morphism to smooth \(X\) is holomorphic,
so \(a_E\geq0\). At a nonexceptional prime, a proper birational morphism
to normal \(X\) is an isomorphism at the generic point; hence \(a_E=0\).
Also \(e_E\) is a positive integer.

Every vertical prime of \(W\) dominates a prime of \(Y\). Indeed, if
the relative dimension is \(r=n-d\), a divisor mapped into
codimension at least two would have dimension at most
\(r+d-2=n-2\), contrary to dimension \(n-1\).

If \(a_Q>0\), every branch over \(Q\) has
\((1+a_E)/e_E>1\), hence \(a_E>0\). Thus every component of \(f^*Q\)
is \(p\)-exceptional. There are finitely many \(p\)-exceptional
divisors on the fixed model \(W\), so only finitely many such \(Q\)
can occur. This proves finite rational effective support and
exceptionality of \(f^*A_0\).

Put
\[
\Theta_0=-K_{W/X}+f^*A_0,\qquad K_W+\Theta_0=p^*K_X+f^*A_0.
\]
The latter equality also proves rational Cartierness; it does not
assume that \(K_W\) is rationally Cartier.
If \(a_Q>0\), then
\[
-a_E+e_Ea_Q\leq 1-e_E\leq0.
\]
If \(a_Q=0\), or \(E\) is horizontal, the coefficient is \(-a_E\leq0\).
Consequently \(\Theta_0\leq0\).

The exact algebra, including the branch \(a_Q=0\), is formalized in
`correction_bounded_by_jacobian` and
`nonexceptional_branch_forces_zero`. A minimum without the clipping
at zero would be a different correction.

## 3. Every divisorial valuation, not merely toric valuations

Let \(D_W\) be the full reduced toroidal boundary. Locally on a toric
chart, a basis \(\chi_1,\ldots,\chi_n\) of the character lattice gives
the rational logarithmic top form
\[
\omega=d\log\chi_1\wedge\cdots\wedge d\log\chi_n.
\]
Its divisor is \(-D_W\); thus \(K_W+D_W\) is locally Cartier.
The same calculation is unchanged by the étale/local charts defining
a strict toroidal embedding.

Here is a direct check of log canonicity **for an arbitrary divisorial
valuation**. On a smooth model at the generic point of its prime
divisor \(F=(t=0)\), write
\(\chi_i=t^{m_i}u_i\), with \(m_i\in\mathbb Z\) and \(u_i\) regular
units after shrinking that generic neighborhood. Then
\[
d\log\chi_i=m_i\,dt/t+d\log u_i.
\]
In their wedge product at most one \(dt/t\) can occur, since
\(dt\wedge dt=0\). The coefficient matrix has only one potentially
polar row. Its determinant therefore has at worst a simple pole:
\(\operatorname{ord}_F(\omega)\geq-1\).
This proves \(A_{W,D_W}(F)\geq0\), without assuming \(F\) is toric.
On the smooth complement of \(D_W\), the logarithmic form is a
regular nonvanishing top form and its birational pullback is
holomorphic; a centered valuation there has positive discrepancy.
The determinant cancellation is formalized in every finite dimension
by `at_most_simple_logarithmic_pole`.

Now set
\[
B_0=D_W-\Theta_0
    =(K_W+D_W)-(K_W+\Theta_0).
\]
It is a rational Cartier divisor, is effective, and its support
contains \(D_W\). For any divisorial valuation \(v\) centered on \(W\),
the definition of crepant pullback gives
\[
A_{W,\Theta_0}(v)=A_{W,D_W}(v)+v(B_0).                 \tag{1}
\]
The two summands are nonnegative. For clarity, an effective rational
Cartier divisor has nonnegative value at every centered valuation:
an integral Cartier multiple has a regular local equation.
If the center lies in its support, that equation lies in the maximal
ideal of the dominated local ring, and its value is strictly positive.

If the first summand in (1) is zero, the center lies in \(D_W\),
hence \(v(B_0)>0\). Otherwise the first summand is already positive.
Therefore \(A_{W,\Theta_0}(v)>0\) for **every** divisorial \(v\).
This also deals with valuations over intersections and with
non-toroidal Jacobian components. No unsupported reduction from
codimension-one checks to all valuations is being made.

For every smooth model \(\tau:Z'\to W\), the crepant boundary is
\[
\Theta_{0,Z'}=(f\tau)^*A_0-K_{Z'/X}.
\]
Thus every exponent
\[
\gamma_F=\operatorname{coeff}_F(K_{Z'/X}-(f\tau)^*A_0)
\]
is greater than \(-1\). This proves the complete `g:volume-subklt`.

## 4. The integral is the metric of the entire adjoint line

Let \(\Omega_h\) be the smooth positive volume form on \(X\)
determined by the smooth metric on \(-K_X\).
Its pullback to \(Z\) includes the squared holomorphic Jacobian,
with zero divisor \(E_Z\).
The adjoint identity is
\[
K_{Z/Y}+\pi^*L=E_Z+g^*(-K_Y).
\]
On a smaller nonempty smooth base-change open \(U\), the nonzero
canonical section \(s_{E_Z}\) generates the entire rank-one
sheaf \(g_*\mathcal O_Z(E_Z)\). Consequently
\[
g_*(K_{Z/Y}+\pi^*L)|_U\simeq(-K_Y)|_U.
\]
In local base coordinates write
\[
g_*\pi^*\Omega_h=H(y)\,dV_y.
\]
The equality of integrands under this adjoint identity says exactly
that \(H\) is the squared \(L^2\) norm of the displayed line frame.
It is smooth and positive on \(U\). Berndtsson's Theorem 1.2 therefore
makes \(-\log H\) plurisubharmonic.

This uses the full generic rank at exponent zero. It does not infer
positivity by restricting a positive vector-bundle metric to an
arbitrary subline. It does not replace full rank by invariant rank
without an additional quotient/projection argument.

For relative dimension \(r>0\), restrict to a base disc and choose a
holomorphic adjoint section Chern-normal at its center. Proposition
4.2 and formula (4.8), with \(h_{\mathcal L}=e^{-\phi}\), give
\[
-i\partial\bar\partial\|u\|^2
\ \geq\
g_*\!\left(i^{r^2}\widehat u\wedge\overline{\widehat u}
               h_{\mathcal L}\wedge i\Theta_{\mathcal L}\right).
                                                               \tag{2}
\]
The omitted term is a nonnegative primitive-form norm. An
\((r,0)\)-form in complex dimension \(r+1\) is decomposable, so
semipositive coefficient curvature gives a nonnegative integrand.
On the stipulated patch, replacing the coefficient curvature by its
lower bound \(c\,g^*\omega_Y\) bounds the right side below by the
positive fiber integral of \(|u|^2\) on that patch, multiplied by the
positive base-direction form. The relative section is nonzero
there because the patch avoids \(E_Z\).

The image of a smaller patch is open because \(g\) is a submersion.
Testing (2) on every base tangent direction gives positive definite
line curvature at an image point. For a line, Chern normalization
means its curvature at that point is
\(-i\partial\bar\partial\|u\|^2/\|u\|^2\), so the sign is positive.
Smoothness then gives strict positivity on an ordinary neighborhood.
Shrinking \(U\) algebraically does not lose the patch: a nonempty
ordinary open cannot be contained in a proper algebraic subset.

If \(r=0\), the full adjoint rank one means that the smooth fibers
have one point. The map on this open is an isomorphism and the
metric is the coefficient metric. The same strictness conclusion
follows directly. This handles the dimension boundary explicitly.

## 5. Boundary extension and unweighted integrability

Choose local equations \(t_Q\) for the finitely many components of
\(A_0\). On \(U\), set
\[
\Phi_0=-\log H+\sum_Q a_Q\log|t_Q|^2.                 \tag{3}
\]
This is the weight on \(-K_Y+A_0\), with squared frame norm
\(H\prod_Q|t_Q|^{-2a_Q}\). The plus sign in the weight is essential.
Off the divisors the added terms are pluriharmonic.

For an omitted base prime \(Q\), choose a component \(E\) attaining
\(\lambda_Q\). At general smooth points of \(E,Q\), generic
smoothness of \(E\to Q\) and characteristic zero give local
coordinates
\[
(u_1,\ldots,u_n)\longmapsto
(u_1^{e_E},u_2,\ldots,u_d),
\]
after absorbing a unit in the transverse coordinate. A resolution
can be chosen to be an isomorphism there. On a smaller polydisc the
pulled-back volume is bounded below by
\(C|u_1|^{2a_E}dV_u\). The real transverse Jacobian is
\(e_E^2|u_1|^{2(e_E-1)}\). Integrating a fixed fiber-coordinate
polydisc, even on a single inverse branch, yields
\[
H(y)\geq C'|y_1|^{2(\lambda_Q-1)}.                  \tag{4}
\]
Nonnegative contributions from other branches cannot spoil this
lower bound. It holds almost everywhere, and hence on the smooth
open by continuity.

Since \(\lambda_Q-1-a_Q\leq0\), (4) makes (3) bounded above near
a general point of \(Q\). A bounded-above psh function extends across
such a divisor: on transverse discs it is a bounded-above subharmonic
function on a punctured disc, whose upper-limit extension satisfies
the submean inequality; limits of transverse discs give the remaining
complex-line tests. The one-variable assertion follows by taking a
harmonic majorant of the outer-circle values and comparing on annuli
after adding \(\epsilon\log(|z|/R)\) to the subharmonic function.
Its uniform upper bound makes the comparison hold at a sufficiently
small inner circle. The maximum principle, followed by
\(\epsilon\downarrow0\), gives the harmonic-majorant inequality at
the puncture as well.

After these divisorial extensions the remaining omitted analytic set
has codimension at least two. To see the required upper bound, choose
a generic coordinate direction and a small polydisc whose circle
boundary misses that set. Its projection to the transverse parameters
has measure zero. For parameters outside the projection the whole
disc is available, so the submean inequality bounds the function by
its uniform bound on that circle boundary. At other points of its
domain, a small-ball submean inequality gives the same bound, since
the exceptional parameter set has measure zero. The upper-limit
extension is psh and unique. Frame transitions in (3) are
pluriharmonic, so the extensions glue.

The integrability question has the **opposite** inequality direction
from the extension question. It is not answered by (4).
Instead use the projection formula before integrating:
\[
e^{-\Phi_0}dV_y
 =g_*\!\left(\prod_Q|t_Q\circ g|^{-2a_Q}\pi^*\Omega_h\right)
                                                               \tag{5}
\]
off the omitted base locus. On a log resolution of the Jacobian and
the pulled-back correction, the upstairs density has the form
\[
u(z)\prod_j|z_j|^{2\gamma_j}dV_z,\qquad
0<c_1\leq u(z)\leq c_2,\quad \gamma_j>-1,
\]
on a relatively compact chart. The inequalities were proved for all
valuations in section 3. Each radial integral
\[
2\pi\int_0^\varepsilon r^{2\gamma_j+1}\,dr
 =\frac{\pi\varepsilon^{2(\gamma_j+1)}}{\gamma_j+1}
\]
is finite. Finitely many such charts cover the inverse image of a
compact base set; properness therefore makes (5) locally finite.
The extension changes the weight only on a Lebesgue-null analytic set.
It has the same unweighted \(L^1_{\rm loc}\) frame norm.
Sections 2-5 prove every conclusion of the original theorem.

## 6. Extension beyond toroidal morphisms

**Theorem A (locally-klt-type source).** In the full target statement,
replace the toroidal assumption by: every point of the normal integral
source \(W\) has a neighborhood admitting an effective rational
boundary \(\Delta\) with \(K_W+\Delta\) rationally Cartier and
\((W,\Delta)\) klt. Retain all other hypotheses, including
equidimensionality and the full generic rank at exponent zero.
The identical correction formula and every metric and conditional
strictness conclusion remain valid. In particular, this applies to
normal Q-Gorenstein klt \(W\) with arbitrary \(f\).

This includes the original source-singularity hypothesis. On an affine
toric chart with primitive rays \(u_j\), choose a rational character
\(m\) strictly positive on all rays, scaled so that
\(0<\langle m,u_j\rangle<1\). Such a character exists because the
cone is strongly convex and rational polyhedral. The effective boundary
\[
\Delta=\sum_j(1-\langle m,u_j\rangle)D_j
\]
has \(K_W+\Delta=-\operatorname{div}(\chi^m)\) rationally Cartier.
Moreover \(D_W-\Delta=\operatorname{div}(\chi^m)\) is effective
rational Cartier with full boundary support. The argument (1) proves
that \((W,\Delta)\) is klt. A chart with no rays is already smooth.
This construction is local and is preserved by the charts defining a
toroidal embedding. The new theorem permits arbitrary \(f\), and also
locally-klt-type sources that are not given any toroidal structure.

*Proof.* Section 2 used neither toroidality of \(f\) nor toroidal
singularities. It still gives \(\Theta_0\leq0\) and rational
Cartierness of \(K_W+\Theta_0\). Locally,
\[
B=\Delta-\Theta_0
 =(K_W+\Delta)-(K_W+\Theta_0)
\]
is effective rational Cartier. For every centered divisorial \(v\),
\[
A_{W,\Theta_0}(v)=A_{W,\Delta}(v)+v(B)>0.
\]
Thus all the exponents used in section 5 are greater than \(-1\).
The direct-image argument, the generic transverse coordinate
calculation, removability, and proper projection in sections 4-5
do not use a toroidal morphism. They apply unchanged. This proves
all the asserted conclusions, not merely their codimension-one
version. \(\square\)

This is a genuine change of model hypothesis, not a conclusion that
an arbitrary normal model is of klt type. The statement does not
construct an equidimensional model. It must not be used by silently
discarding the source-singularity condition.

## 7. Sharp simultaneous boundary perturbations

Return to the original toroidal model and let \(D_Y\) be its reduced
toroidal base boundary. Let \(S\) be any finite collection of prime
components \(Q\) of \(D_Y\) whose **entire** pullbacks \(f^*Q\) are
\(p\)-exceptional. For rational \(b_Q\geq0\), put
\[
C_b=A_0+\sum_{Q\in S}b_QQ,\qquad
\varepsilon_Q=\lambda_Q-a_Q=\min(\lambda_Q,1)>0.
\]

**Theorem B (exact correction chamber).** The constructed density
metric on \(-K_Y+C_b\) extends with semipositive curvature for all
such \(b\), has exceptional correction pullback, and retains the
original smooth-open and conditional ordinary-open strictness
conclusions. Its squared frame norms are locally integrable at
every point if and only if
\[
                         b_Q<\varepsilon_Q
                         \quad\text{for every }Q\in S.          \tag{6}
\]
When (6) holds, \((W,-K_{W/X}+f^*C_b)\) is sub-klt at every
divisorial valuation. There are no additional constraints imposed
by intersections of these boundary primes.

*Proof.* Add \(\sum b_Q\log|t_Q|^2\) to the extended weight (3).
These are psh divisor weights, so this always gives a semipositive
metric on the stated line. Its smooth curvature is unchanged off
the correction. Exceptionality follows from the definition of \(S\).

Write \(\Theta_b=-K_{W/X}+f^*C_b\). For \(E\) over \(Q\in S\),
\[
\operatorname{coeff}_E\Theta_b
 =-a_E+e_E(a_Q+b_Q)<1
\]
holds at every such \(E\) exactly when
\[
a_Q+b_Q<\min_{E\mapsto Q}(1+a_E)/e_E=\lambda_Q.
\]
This is equivalent to (6), including its strict endpoint.
Every other coefficient of \(\Theta_b\) is nonpositive.
Because \(Q\) is a toroidal boundary prime, every component of
\(f^*Q\) lies in \(D_W\). Thus, under (6),
\(D_W-\Theta_b\) is effective rational Cartier and its support still
contains all of \(D_W\): its coefficients there are strictly positive.
The all-valuation argument (1) applies verbatim. It proves sub-klt
and then unweighted integrability by (5).

Conversely, if (6) fails, choose an \(E\) attaining \(\lambda_Q\).
At its general smooth point the upstairs density in (5), now
corrected by \(C_b\), is a positive smooth factor times
\[
|u_1|^{2(a_E-e_E(a_Q+b_Q))}dV_u
\]
with exponent at most \(-1\). Its mass is infinite in every
transverse neighborhood. Tonelli and the projection formula make
the base frame norm nonintegrable in a neighborhood of a general
point of \(Q\). At equality the divergence is logarithmic.
This proves the converse, not just sufficiency. \(\square\)

The restriction to toroidal boundary perturbations matters. Adding
positive coefficients on arbitrary non-toroidal divisors can create
non-log-canonical singular intersections; the full-support argument
would no longer follow from the listed coefficients.

### A global sharpness family satisfying every original hypothesis

For every integer \(c\geq2\) and \(r\geq0\), let
\[
\beta:Y=\operatorname{Bl}_{x_0}\mathbb P^c\longrightarrow\mathbb P^c,
\quad W=Y\times\mathbb P^r,\quad X=\mathbb P^c\times\mathbb P^r,
\quad p=\beta\times\operatorname{id},\quad f=\operatorname{pr}_Y,
\]
where \(x_0\) is a coordinate torus-fixed point. Let \(D\) be the
exceptional divisor on \(Y\), take \(\rho=\operatorname{id}_W\),
and use the product Fubini-Study metric on
\(-K_X=\mathcal O(c+1,r+1)\).

All varieties are smooth connected projective. The maps are projective;
\(p\) is birational; \(f\) is surjective, smooth, equidimensional and
toroidal for the standard toric embeddings. The relative canonical
divisor is \((c-1)(D\times\mathbb P^r)\), and
\[
f_*\mathcal O_W(K_{W/X})=\mathcal O_Y((c-1)D)
\]
has full generic rank one. On any small patch away from \(D\),
the positive coefficient metric dominates a positive base form.
For \(D\), \(a_E=c-1\), \(e_E=1\), hence \(A_0=(c-1)D\) and
\(\varepsilon_D=1\); all other correction coefficients vanish.
The pullback of \(D\) is \(p\)-exceptional.

In a blowup chart
\(\beta(u,z_2,\ldots,z_c)=(u,uz_2,\ldots,uz_c)\), the Jacobian is
\(u^{c-1}\). The pushed-forward density is a positive smooth factor
times \(|u|^{2(c-1)}\). The correction \(A_0+sD\) leaves precisely
\(|u|^{-2s}\). It is integrable exactly for \(s<1\), and fails
logarithmically for \(s=1\). This is an all-dimension geometric
sharpness construction, not a counterexample to the original
theorem, whose prescribed correction is \(s=0\).

## 8. Prior art, failed shortcut, and what remains unverified

The logarithmic-pole calculation and the threshold interpretation
belong to classical toroidal/log-canonical geometry. The proof does
not claim them as new results in isolation.

A primary-source novelty check located Dano Kim, *Canonical bundle
formula and degenerating families of volume forms*,
**arXiv:1910.06917v5**, August 22, 2025, Theorems 1.1 and 1.2.
The actual source was opened at
https://arxiv.org/html/1910.06917v5. Theorem 1.1 assumes Kawamata's
condition, simple-normal-crossing data, a log-Calabi-Yau line-bundle
relation, a divisor-defined coefficient metric, and an effective
horizontal boundary. Theorem 1.2 treats the integrated singular
volumes under the same Kawamata setup and distinguishes the original
volume from the volume with the rounded horizontal correction.

These are substantive precedents for a discriminant description of
fiber-integral singularities. The full generic rank-one hypothesis
here does not, by itself, supply that entire line-bundle and boundary
setup. Thus a direct invocation as a replacement for sections 3-5
has not been justified and is not used. This is a retired citation
shortcut, not a refutation of Kim or of the manuscript.
The search service's suggested arXiv:2112.10665 was rejected after
opening the primary record: it is a paper about semigroup word
problems, not a source on volume metrics. Search summaries are not
evidence of novelty or theorem applicability.

The important improvement over the initial project skeleton is a
complete, hypothesis-faithful proof of the geometric bridge, plus
the two explicit extensions. It is not merely a bounded no-witness
report. Nevertheless, **novelty is unverified**, and publication-level
adequacy must be decided by the independent Reviewer rather than
inferred from a successful Lean run.

The formalization does not verify complex geometry or analysis.
The primary-source reader checked the Berndtsson attribution, not
the entire proof. The family-wide source statements are registered
as audit targets, not accepted theorems. The model construction,
generic-rank, and curvature-patch premises in the E and V
applications remain distinct obligations in the graph.

The two Berndtsson assumptions retain their canonical DOI and exact
locators in the ledger. Their independent reading is preserved in
the owned `literature/` subtree. The official `citation_check
attribute` command has no archive-directory option and writes into
`research/literature/`, outside this mission's authoritative writable
paths. It has therefore not been run by the Engineer; those
official citation-attribution records remain outstanding rather
than being silently relabeled or fabricated.

The campaign is not declared complete by this report. The host-invoked
Reviewer must replay the certificate, assess statement fidelity and
the complete proof, settle the citation-recording boundary, and judge
novelty/significance. No Reviewer verdict is manufactured here.

## 9. Reproduction and measured scope

The completed real Lean 4.31.0 run returned `exit_code=0` and
`proof_holes=[]`. Its archived certificate binds all twelve declarations
to the current source and the unchanged statement-fidelity document.
The exact replay also passed 8,820 rational threshold cases and
12,348 sampled intersection-weight cases. These counts describe the
finite adversarial tests, not the extent of the proved quantifiers.

From the campaign root, the standalone, standard-library-only replay is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/toroidal_volume_audit/verify.py
```

It fails if the adapter payload/result differ, if a tested identity
fails, if the real compiler record is unsuccessful or stale, or if
the exact certificate differs from its recomputation. To obtain a
fresh compiler replay of the same source, use:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/toroidal_volume_audit/Main.lean --statement-fidelity research/toroidal_volume_audit/statement_fidelity.md --claim C_TV_FORMAL_CORE --project-root . > research/toroidal_volume_audit/lean_verification.json
```

The initial compilation used the required durable runner; its receipt
is `lean_submission.json`. It completed with a type error in a
positive-factor cancellation lemma, not a mathematical counterexample.
After replacing that lemma by its positive-factor version, the fresh
official compiler run succeeded. The failed run remains an
inconclusive certificate of the superseded source, never refuting
evidence. The successful compiler run took seconds, so no long-running
session-owned process was left behind.
