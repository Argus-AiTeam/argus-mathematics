# Bounded independent analytic source reading

Reader: `analytic-source-reader`. This is a source-attribution assessment,
not native Host Reviewer acceptance, a review of the original manuscript, or
a new mathematical result. Applicability comments below use only the current
context supplied by the parent.

## Sources and reading boundary

The read-only source directory is
`families/068/first-pass/toroidal_volume_audit/literature/`.

* **Berndtsson:** Bo Berndtsson, *Curvature of vector bundles associated to
  holomorphic fibrations*, Annals of Mathematics **169** (2009), 531–560,
  **doi:10.4007/annals.2009.169.531**. I read `berndtsson2009.txt`, the supplied
  journal-text extraction, rather than independently retrieving the PDF.
  Decisive locations: introduction, pp. 532–533, text lines 74–122;
  Theorem 1.2, p. 533, lines 121–122; Section 2, pp. 537–539, especially
  (2.5), lines 390–418; Section 4 setup, pp. 541–542, lines 516–570;
  Proposition 4.2, p. 547, lines 794–809, with proof through p. 549;
  (4.7)–(4.8), pp. 549–550, lines 910–953. The later assumptions begin
  on p. 550, lines 979–985. Appendix Theorem 8.1, p. 557, lines 1284–1302,
  explains the extension input used to construct the vector bundle.
* **Kim:** Dano Kim, *Canonical bundle formula and degenerating families of
  volume forms*, **arxiv:1910.06917v5**. I read
  `kim1910.06917v5.html`, including its TeX annotations for mathematical
  formulas. Its abstract/PDF links explicitly specify `1910.06917v5`.
  Stable locators are the HTML element identifiers cited below; the source
  URL is `https://arxiv.org/html/1910.06917v5`.
* `berndtsson_excerpt.md` was inspected as a prior reader's account only.
  Neither its claimed independent reading nor any old status was used as
  mathematical evidence.

`OBJECTIVE.md` and `PRIOR_DRAFTS.json` were read as the current contract and
input inventory. No other old mathematical draft or manuscript was read.
No official `citation_check attribute` was run: its
`research/literature` output is outside this reader's two-file write boundary.

<a id="berndtsson-nakano"></a>
## Berndtsson: the Nakano input

### Statement and all relevant standing hypotheses

The displayed Theorem 1.2 reads:

> If the total space \(X\) is Kähler and \(L\) is (semi)positive over
> \(X\), then \((E,\|\cdot\|)\) is (semi)positive in the sense of Nakano.

This sentence imports the preceding setup. The source has complex manifolds
\(X,Y\), \(\dim X=n+m\), \(\dim Y=m\), a holomorphic fibration
\(p:X\to Y\) with surjective differential everywhere, compact nonsingular
fibers \(X_t\), and a holomorphic line bundle \(L\) with a **smooth**
Hermitian metric of nonnegative curvature on the **whole total space**.
The introduction takes \(Y\) connected; Section 4 works locally over a ball
or polydisc. A proper holomorphic submersion is within this setting.
Fiber connectedness is not an explicit hypothesis of this theorem.

To avoid confusion with the parent's birational map \(p\) and discrepancy
divisor \(E\), write the source's fibration, coefficient line and vector
bundle below as \(q,F,\mathscr E\). Then
\[
 \mathscr E_t=H^0(X_t,K_{X_t}\otimes F|_{X_t}),\qquad
 \mathscr E=q_*(K_{X/Y}\otimes F),
\]
with its fiberwise integral metric
\[
 \|u_t\|^2=\int_{X_t}c_n\,u_t\wedge\overline{u_t}\,e^{-\phi},
 \qquad c_n=i^{n^2},\qquad h_F=e^{-\phi}.
\]
The integrand is understood in a local trivialization of \(F\) and is
invariant under changing that trivialization; see (4.2), p. 544.
The curvature convention is
\(\Theta^F=\partial\bar\partial\phi\), so positivity means
\(i\Theta^F\geq0\).

**Verdict for `C_REVIEW_TV/A_BERNDTSSON_NAKANO`: supports.**
The attribution is valid with these standing hypotheses. It is not a
statement about an arbitrary rank-one coherent direct image, a singular
coefficient metric, or a family with singular fibers. No product
trivialization, ample coefficient line, or strict positivity along fibers
is needed for its semipositive conclusion.

### Constant rank and base change

The source does not merely declare a possibly jumping collection of spaces
to be a bundle. Before Theorem 1.2, and again on pp. 542–543, it explains
extension of every fiber section and obtains local holomorphic frames.
For semipositive \(F\), Appendix Theorem 8.1 supplies the extension input.
Together with the usual upper semicontinuity/base-change reasoning for a
proper family, this gives locally constant \(h^0\) and the displayed
fiber identification under the theorem's standing assumptions.

Consequently, a separate constant-rank hypothesis is not missing from
Berndtsson's stated smooth semipositive setting. But **generic rank one
alone**, outside that setting, does not identify a sheaf's fibers with
all the fiberwise \(H^0\)'s, establish local freeness everywhere, or
provide a smooth \(L^2\) metric across singular fibers.

<a id="berndtsson-primitive"></a>
## Berndtsson: normal representative and curvature lower bound

### Proposition 4.2, p. 547

Under the Section 4 standing hypotheses just recorded, let \(u\) be a
section of \(\mathscr E\) over an open base neighborhood \(U\ni0\), with
\[
 D^{0,1}u=0\quad\hbox{on }U,\qquad
 D^{1,0}u=0\quad\hbox{at }0.
\]
The proposition supplies a **smooth \(F\)-valued \((n,0)\)-form
representative** \(\widetilde u\) on the total space such that
\[
 \bar\partial\widetilde u=\sum_k\eta^k\wedge dt_k,\tag{4.5}
\]
\[
 (\eta^k\wedge\omega)|_{X_0}=0,\qquad
 \partial^\phi\widetilde u\wedge\widehat{dt_j}=0
 \quad(t=0,\ \hbox{all }j).\tag{4.6}
\]
Here \(\eta^k\) has bidegree \((n-1,1)\), \(\omega\) is the
total-space Kähler form, \(\widehat{dt_j}\) omits \(dt_j\) with the
source's wedge-order convention, and
\(\partial^\phi=e^\phi\partial e^{-\phi}\).
The word **primitive** refers to \(\eta^k|_{X_0}\), not to a newly
asserted holomorphic total-space representative. Primitivity and (4.6)
are required on the central fiber, not on every nearby fiber.

On a disc, \(\widehat{dt_1}=1\). Thus (4.6) says that the
coefficient of \(dt\) in \(\partial^\phi\widetilde u\) vanishes along
the central fiber. It is not the tautological pullback of an
\((n+1,0)\)-form to an \(n\)-fold. Section 2, p. 539, also explains
that any prescribed fiber vector can be extended to a local holomorphic
section satisfying this Chern-normal condition at \(0\).

### Formula (4.8), pp. 549–550: signs and interpretation

For base dimension \(m\), the proof uses a normal holomorphic \(m\)-tuple
\((u_j)\), and defines
\[
 N=n+m-1,\qquad
 \widehat u=\sum_j\widetilde u_j\wedge\widehat{dt_j},\qquad
 T_u=\sum_{j,k}(u_j,u_k)\widehat{dt_j\wedge d\bar t_k}.
\]
The last hats include the phases making \(T_u\) positive.
Write \(\bar\partial\widehat u=\eta\wedge dt\).
In a notation that makes the weighted fiber norm explicit, (4.8) is
\[
 i\partial\bar\partial T_u\big|_0
 =-c_Nq_*\!\left(
   \widehat u\wedge\overline{\widehat u}
   \wedge i\partial\bar\partial\phi\,e^{-\phi}\right)\Big|_0
  -\|\eta\|^2_{L^2(X_0,\omega,h_F)}\,dV_t. \tag{4.8}
\]
The supplied text writes the last term as
\(-\int_{X_0}|\eta|^2\,dV_t\); its preceding computation includes the
fiber metric and the factor \(e^{-\phi}\). Here \(dV_t\) is the
positive **base** volume form from (2.5), not the fiber measure.
The sign follows from the primitive-form identity
\(c_n\eta\wedge\bar\eta=-|\eta|^2\) with the fiber volume understood.

In the source's conventions,
\[
 \Theta^{\mathscr E}_{j\bar k}
       =[D_{t_j},\bar\partial_{t_k}],\qquad
 i\partial\bar\partial T_u\big|_0
       =-\sum_{j,k}(\Theta^{\mathscr E}_{j\bar k}u_j,u_k)\,dV_t.
       \tag{2.5}
\]
Thus a **negative** Hessian of \(T_u\) at a normal point is
**positive** curvature of \(\mathscr E\).
The supplied journal-text extraction says “seminegative” immediately
after (4.8). Taken literally, that word conflicts with (2.5),
Theorem 1.2, and the same paragraph's strict-positive conclusion.
The formulas, not that sign-word slip, determine the attribution;
I have not separately checked the PDF's typography.

In particular, on a disc \(T_u=\|u\|^2\), \(N=n\), and at the normal point
\[
 \begin{split}
 \langle i\Theta^{\mathscr E}u,u\rangle
 &=-i\partial\bar\partial\|u\|^2\\
 &=c_nq_*\!\left(\widetilde u\wedge\overline{\widetilde u}
                   \wedge i\Theta^F e^{-\phi}\right)
     +\|\eta\|^2_{L^2}\,dV_t\\
 &\geq c_nq_*\!\left(\widetilde u\wedge\overline{\widetilde u}
                   \wedge i\Theta^F e^{-\phi}\right).
 \end{split}
\]
This is the asserted coefficient-curvature fiber-integral lower bound.
It uses the representative supplied by Proposition 4.2. In a nonproduct
family it must not be silently replaced by the integral of a scalar
\(\phi_{t\bar t}|u|^2\) computed from an arbitrary horizontal splitting;
the total-space representative may have \(dt\)-components and the
curvature may have mixed components.

**Verdict for `C_REVIEW_TV/A_BERNDTSSON_PRIMITIVE`: supports.**
The construction and bound occur in the general Kähler-fibration proof.
Only **after** (4.8), in Section 5, p. 550, lines 979–985, does the source
say “from now on” and impose a one-dimensional base, a locally
holomorphically trivial product \(X=U\times Z\), and fiberwise strict
positivity of \(\Theta^F\). Those additional equality-case hypotheses
are not prerequisites for Proposition 4.2 or (4.8).

## Boundary between these source results and the present application

With the parent's notation, the possible smooth-locus application has
total space \(Z\), map \(g\), and coefficient line \(F=\pi^*L\), not the
normal space \(W\). Projectivity gives Kählerness, and pulling back the
given smooth semipositive metric preserves semipositivity. One must work
over an open set of regular values of \(g\), with the corresponding
base-change identification. The relevant sheaf identity is
\[
 g_*(K_{Z/Y}\otimes\pi^*L)
   =g_*\mathcal O_Z(E)\otimes K_Y^{-1},
 \qquad K_Z+\pi^*L=E.
\]
On this smooth locus the source supplies the bundle structure and
constant fiber dimension; the given full generic rank one then makes
it a line bundle on the relevant connected locus. This is not a claim
of local freeness or base change over all singular fibers.

If the parent's volume \(H\) is indeed the squared \(L^2\) norm of the
claimed nonvanishing holomorphic frame, its metric weight is
\(-\log H\), with curvature \(-i\partial\bar\partial\log H\).
That frame/volume identification, including any base canonical twist,
is an application obligation, not a clause of Theorem 1.2.

Likewise, a domination \(\pi^*\alpha\geq c\,g^*\omega_Y\) on an ordinary
patch is compatible with the lower bound above without any fiberwise
strict-positivity assumption: conditional on the frame having nonzero
fiber density on a relative open part of the patch, it gives a strictly
positive contribution to the fiber integral in the corresponding base
directions. The parent must verify that domination, nonvanishing,
fiber intersection, and the passage to the desired strictness statement.
This reader has not checked the manuscript's argument for them.

Neither Berndtsson statement itself supplies the numbers \(a_Q\), proves
that \(-\log H+\sum_Qa_Q\log|t_Q|^2\) extends as a semipositive metric
across the discriminant, or verifies its global gluing. Away from the
divisors these logarithms are pluriharmonic; their distributional
contribution across the divisors is a separate issue.

<a id="kim-kawamata"></a>
## Kim v5: hypotheses, conclusions, and the retired inference

### Kawamata setup actually required

Section 4.1, **Definition 4.1**, HTML `S4.Thmtheorem1`, source lines
894–936, starts with pairs of complex manifolds and snc
\(\mathbb Q\)-divisors \((X,R),(Y,B)\), and a surjective projective
morphism \(f:X\to Y\) with **connected fibers**.
Write \(R=R_h+R_v\) for its horizontal and vertical parts.
The definition imposes all eight conditions:

1. \(B=\sum B_i\) is reduced snc.
2. \(\operatorname{red}(R)+f^*B\) is snc.
3. \(f\) is a submersion over \(Y\setminus B\).
4. \(f(\operatorname{Supp}R_v)\subset B\).
5. \(R_h\) is relative snc over \(Y\setminus B\).
6. Every horizontal coefficient belongs to \((-\infty,1)\).
7. \(\operatorname{rank}f_*\mathcal O_X(\lceil-R_h\rceil)=1\).
8. \(K_X+R\) is \(\mathbb Q\)-linearly equivalent to a pullback of a
   \(\mathbb Q\)-Cartier divisor on \(Y\).

The last condition is the **log-Calabi–Yau condition**. In the metric
notation fixed immediately after the definition, (8)–(9),
HTML `S4.E8`, `S4.E9`, lines 996–1020, it becomes
\[
 L=\mathcal O(R),\quad H_{\rm Kim}=\mathcal O(B_R),\quad
 M=J+H_{\rm Kim},\qquad
 K_X+L=f^*(K_Y+M).
\]
Here \(H_{\rm Kim}\) is a line bundle, not the parent's scalar volume
\(H\). Remark 4.2, `S4.Thmtheorem2`, explicitly warns that the
horizontal boundary is constrained by this log-Calabi–Yau condition.

### Theorem 1.1: the particular divisor metric

Exact locator: **Theorem 1.1**, HTML `S1.Thmtheorem1`, lines 253–290,
with preceding `S1.SS1.p1.1` and following `S1.SS1.p3.1`.
It assumes the entire setup above and, additionally, \(R_h\geq0\);
thus its horizontal coefficients lie in \([0,1)\).
It takes \(\lambda\) to be the singular Hermitian metric on
\(L=\mathcal O(R)\) **given by a defining meromorphic section of
the divisor \(R\)**, and \(\mu\) to be its induced \(L^2\) metric
on the \(\mathbb Q\)-line bundle \(M\), as defined in Definition 3.5.
Its conclusion is
\[
 \mu=\eta+\psi,\qquad e^{-\mu}=e^{-\eta}e^{-\psi},
\]
where \(\eta\) is the divisor metric of \(B_R\), while \(\psi\)
is a metric on \(J=M-\mathcal O(B_R)\) with semipositive curvature
current and zero Lelong number at **every** point of \(Y\).
The source immediately notes that \(R,B_R\) need not be effective,
so \(\lambda,\mu,\eta\) need not themselves have semipositive
curvature. The divisor-metric hypothesis cannot be replaced without
argument by “some smooth semipositive metric on a coefficient line.”

### Theorem 1.2: modified volume versus raw volume

Exact locator: **Theorem 1.2**, HTML `S1.Thmtheorem2`, lines 309–349,
with the following explanation `S1.SS1.p6.1`.
It assumes Kawamata's condition but does **not** add effectiveness
of \(R_h\). It takes singular volume forms \(\alpha_{\rm Kim}\) and
\(\beta_{\rm Kim}\) with divisorial poles respectively along
\[
 R,\qquad R+\lceil-R_h\rceil.
\]
“Divisorial poles” means, in adapted local coordinates, a density
\[
 b(z)\prod_i|z_i|^{-2r_i},
\]
where \(b\) is positive continuous and locally bounded both above
and below: Section 2.3(1), HTML `S2.I3.i1` / `S2.E1`, lines 595–608.
Fiberwise integration is first performed over the regular-value locus
\(Y_0\).

The theorem gives equivalent singularities for \(f_*\beta_{\rm Kim}\),
not necessarily \(f_*\alpha_{\rm Kim}\), with a volume form
\[
 \theta(w)=b(w)\prod_{i=1}^{m}|w_i|^{-2c_i}
                    e^{-\psi(w)}|dw_1\wedge\cdots\wedge dw_m|^2,
 \qquad \sum_i c_i\operatorname{div}(w_i)=B_R,
\]
on relatively compact coordinate sets adapted to \(B\).
Here the statement calls \(b\) positive and bounded and \(\psi\)
plurisubharmonic with zero Lelong number everywhere. The conclusion
for \(f_*\alpha_{\rm Kim}\) is only **less singular than** \(\theta\).
Section 2.3, `S2.SS3.p3.1`, defines equivalent singularities by an
\(O(1)\) difference of negative logarithms, and less singular by
the corresponding one-sided inequality. Neither is an identity of
the specific densities. If \(R_h\geq0\), the rounding term vanishes
and the two input pole divisors coincide; otherwise the distinction
is substantive.

The associated \(L^2\) construction also keeps track of its domain:
Definition 3.2 and Theorem 3.7, HTML `S3.Thmtheorem2` and
`S3.Thmtheorem7`, use \(Y_0\cap Y_{1,\mathrm{free}}\), where
\(f_*A\) is locally free of rank one, with
\(A=\mathcal O(\lceil-R_h\rceil)\). Theorem 3.7 separately assumes
the pullback equality, a psh metric on \(L+A\), and trivial
multiplier ideal on a general fiber. Rank one is not a substitute
for these hypotheses or for identifying the induced metric.

### Discriminant signs and comparison with the proposed correction

Section 4.1, HTML `S4.Ex9`, source lines 938–960, defines
\[
 c_Q=1-\sup\{c:(X,R+c f^*Q)
                  \text{ is log canonical over the general point of }Q\}.
\]
In its snc setup, if \(r_D\) is the coefficient of \(R\) at a
component \(D\) dominating \(Q\), and \(e_D=\operatorname{ord}_D(f^*Q)\),
this threshold is \(\min_{D\to Q}(1-r_D)/e_D\).
There is **no positive-part truncation** in Kim's definition.
The divisor metric has local weight
\(\eta=\sum_Q c_Q\log|t_Q|^2\); the residual weight is
\(\psi=\mu-\eta\).

Only as a **formal sign comparison**, if one could justify
\(r_D=-a_D\) for the parent's discrepancies and
\(\mu=-\log H\), then, writing
\(\tau_Q=\min_{D\to Q}(1+a_D)/e_D\), Kim would have
\(c_Q=1-\tau_Q\). The draft's number is instead
\[
 a_Q=\max(0,\tau_Q-1)=\max(0,-c_Q).
\]
Thus the draft's plus sign would match subtraction of a nonpositive
discriminant coefficient, but its clipped correction is not in general
the full subtraction \(-c_Q\). This comparison establishes neither
the candidate boundary nor the required metric/volume identification.

### Retirement rationale and limited prior-art conclusion

The retired inference
“\(\operatorname{rank}g_*\mathcal O_Z(E)=1\), therefore Kim 1.1/1.2
directly identifies the present \(H\)” is **not licensed** by either
theorem:

* The rank in Kawamata's condition concerns the particular rounded
  horizontal boundary sheaf, not an arbitrary rank-one direct image.
* One-dimensional spaces of sections do not by themselves establish
  the log-Calabi–Yau pullback relation for the underlying adjoint line.
  In the supplied context \(K_Z+\pi^*L=E\); generic rank one of its
  direct image does not assert that this line bundle is a pullback
  from \(Y\).
* No boundary \(R\) satisfying the full setup, divisor metric
  identification, or identification of \(H\) with the prescribed
  fiber-integrated volume was supplied. Any connected-fiber and snc
  identifications also have to be verified or derived in an application,
  not assumed from the name “toroidal.”
* Without effectiveness of \(R_h\), Theorem 1.2 distinguishes the
  rounded-boundary volume from the raw volume and generally provides
  only a one-sided conclusion for the latter.

This is an insufficiency of the proposed **application**, not a
refutation of Kim's results and not a proof that no additional
construction could ever make them applicable.

The limited prior-art conclusion is that Kim v5 proves a
discriminant/residual-zero-Lelong metric description and a related
fiber-volume singularity description **in the stated Kawamata
log-Calabi–Yau setting**. It is relevant background, but the inspected
sources and supplied context do not establish that it already covers
the present corrected toroidal volume \(H\). No novelty determination
or acceptance of the old draft follows from this bounded reading.
