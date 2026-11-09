# Exact lc-skeleton penalization

## Statement being audited

The targets are Proposition `a:exact-penalization`, especially (A4), in
`Bounded-klt-complements-for-Fano-contractions-September-25-2026/build/sections/constrained-minimum.tex`,
and the rational exact-realization part of Theorem `thm:E-exact-minimizer`,
via Lemma `lem:E-log-jet` and Corollary `cor:E-all-functions`, in
`Uniform-Cartier-sections-for-Fano-type-contractions-September-25-2026/build/sections/E-lc-slices.tex`.
All paths above are relative to `research/openai_manuscript/`.

The assertion to establish is exact containment of an actual global
minimizer in the lc cone for every sufficiently small positive rational
parameter. Convergence of minimizers, or a bound on their defect tending to
zero, is not that assertion. Neither manuscript's final complement or
Cartier-section theorem is certified by resolving this bridge alone.

## Primary inputs and scope

A separate source reader checked the following retraction and
ordinary-klt sources; the Engineer additionally opened Cutkosky's
primary Theorem 1.1. These are external inputs, not results newly
proved here. The source reader was not the mission's independent
Reviewer.

| Input | Source and locator | Scope used here |
|---|---|---|
| Monomial retraction | Jonsson--Mustata, DOI `10.5802/aif.2746`, Lemma 4.7 and Corollary 4.8 | Retraction decreases regular-function values and preserves resolved ideal orders. |
| Discrepancy on a monomial cone | Same, Proposition 5.1; Corollary 5.4 | Linearity, birational transformation, and discrepancy decrease; the ambient scheme in that paper is regular. Here these facts are applied on the smooth resolution. |
| Log Izumi | Li, `arxiv:1511.08164v4`, Theorem 3.1 | On a fixed boundary-free complex Q-Gorenstein klt germ, `v(f) <= C A_X(v) ord_m(f)`. |
| Properness | Same, Theorem 1.1 and Corollary 4.3 | `A_X(v)^n vol(v) >= c A_X(v)/v(m)` for the bare klt germ, not with a signed pair discrepancy substituted. |
| Existence | Blum, `arxiv:1606.08894v3`, Main Theorem and Section 7.3 | Effective rational klt pairs over an uncountable algebraically closed characteristic-zero field. |
| Quasi-monomiality | Xu, `arxiv:1907.01114v2`, Theorem 1.2 | Every ordinary klt normalized-volume minimizer is quasi-monomial. |
| Uniqueness | Xu--Zhuang, `arxiv:2005.08303v1`, Theorem 1.1 | Unique ray for an effective-boundary klt singularity. |
| Finite generation | Xu--Zhuang, `arxiv:2205.10915v2`, Theorems 1.1--1.2 | Effective rational klt pairs; finite generation and stable degeneration of an actual minimizer. |
| Volume limits | Cutkosky, `arxiv:1508.01938v1`, Theorem 1.1 (= Theorem 5.5) | Graded families of maximal-ideal-primary ideals; the completed nilradical has dimension less than the ring. |

Primary URLs:

- <https://aif.centre-mersenne.org/item/10.5802/aif.2746.pdf>
- <https://arxiv.org/pdf/1511.08164v4>
- <https://arxiv.org/pdf/1606.08894v3>
- <https://arxiv.org/pdf/1907.01114v2>
- <https://arxiv.org/pdf/2005.08303v1>
- <https://arxiv.org/pdf/2205.10915v2>
- <https://arxiv.org/html/1508.01938v1>

The AIF landing page returned HTTP 403 to the source reader; its published
PDF was available. All six PDFs were accessible. A focused literature
lookup found no verified prior fixed-perturbation containment theorem.
That negative lookup does not establish originality. In particular,
Li--Xu's approximation by Kollar components is not the exact-containment
claim needed here.

The formal scalar certificate below will not certify these external
geometric theorems. Citation attribution and independent mathematical
review remain separate from compilation and exact arithmetic.

## A route that cannot prove exactness

The information `0 <= e(t) <= C t` alone permits `e(t)=t>0` for every
`t>0`. Thus a route using only convergence of the lc defect is invalid.
This is not a flaw attributed to either manuscript: both explicitly
distinguish convergence from exact realization.

## Verification theorem: a common threshold for a compact height family

Let `x in X` be a fixed positive-dimensional complex affine
Q-Gorenstein klt germ. Let `Psi` be an effective rational sum of
principal Cartier divisors, with `(X,Psi)` lc and with at least one
centred quasi-monomial zero-discrepancy valuation. Write
\[
 e(v)=A_X(v)-v(\Psi).
\]
Fix nonzero regular functions `g_1,...,g_t`. For a coefficient vector
`eta=(alpha,beta_1,...,beta_t)`, put
\[
 b_\eta(v)=\alpha A_X(v)+\sum_i\beta_i v(g_i).
\]
Let `K` be a compact set of coefficient vectors such that every `b_eta`
is strictly positive on **all** nonzero lc rays normalized by `A_X=1`,
including their noncentred faces. Assume that for some `lambda_eff>0`
the divisors
\[
 \Delta_{\lambda,\eta}
   =\frac{\Psi-\lambda\sum_i\beta_i\operatorname{div}(g_i)}
          {1+\lambda\alpha}
 \tag{1}
\]
are effective whenever `eta in K`, `0<lambda<lambda_eff`, and the
denominator is positive.
The empty-family case is vacuous; the proof below treats nonempty `K`.

**Theorem.** There is one positive rational `lambda_0` such that, for
every rational coefficient vector `eta in K` and every rational
`0<lambda<lambda_0`, (1) is klt and its actual global
normalized-volume minimizer is an lc place of `(X,Psi)`. For a fixed
`eta` its minimizing ray is independent of `lambda`, is the unique
minimizer of `b_eta(v)^n vol(v)` on centred lc rays, and has finitely
generated associated graded algebra.

The compact-family statement is stronger than choosing constants
separately for each height. It is not a claim that the constants are
uniform over different germs, resolutions, or sets of equations.
The theorem uses the ordinary klt inputs listed above. Its geometric
proof is not wholly formalized in Lean.

### 1. Degree-bounded algebraic leading exponents

Fix a smooth etale coordinate chart on a resolution, with coordinates
`z_1,...,z_s,y_1,...,y_(n-s)`, where the reduced snc boundary through the
valuation centre is `z_1...z_s=0`. There are finitely many such charts;
maxima of their constants will be taken. Closed specializations of
nonclosed centres can be chosen avoiding boundary components which do
not contain the centre. Both valuations are nonnegative on these
closed-point local rings, and their units have value zero. No choice
of a specialization changes the degree constants below.

For a polynomial `g` of degree at most `D` in the fixed affine
generators, there is a nonzero equation
\[
 \sum_{j=0}^q p_j(z,y)g^j=0,\qquad
 \deg p_j\le H_0(D+1).                         \tag{2}
\]
Here `q,H_0` are fixed independently of `g`, the point, and all
valuation weights. Indeed the chart's function field is a finite
extension of `C(z,y)`. In a fixed basis the affine generators act by
fixed rational matrices. A common denominator raised to power `D`
clears a degree-`D` polynomial in these matrices, with numerator
degrees linear in `D`. Taking a characteristic polynomial of fixed
matrix size preserves that linear bound. Translations of the
tangential coordinates do not increase degrees. Since `g` is
nonzero in a field, its multiplication matrix is invertible, so its
characteristic polynomial is nonzero and has nonzero constant term.

At a closed point give **all** coordinates positive rationally
independent real weights. If `gamma` is the leading exponent of `g`
and `delta_j` that of a nonzero `p_j`, cancellation in (2) forces two
different powers `j<k` to satisfy
\[
 \delta_j+j\gamma=\delta_k+k\gamma.
\]
All exponents are nonnegative. Taking total degrees gives
\[
 (k-j)|\gamma|=|\delta_j|-|\delta_k|
 \le H_0(D+1),\qquad |\gamma|\le H_0(D+1).       \tag{3}
\]
This is a universal exponent argument, not a finite numerical test.

Now give the normal coordinates their actual positive weights and
the tangential coordinates weight zero. The active normal exponents
of `g` form a finite set: positivity of the normal weights bounds
each coordinate of an exponent of bounded weight. Each vertex of
their convex hull is selected by a sufficiently small generic
perturbation of the normal weights. Terms outside the least face
remain excluded by a positive gap. Giving the tangential coordinates
sufficiently small positive generic weights then selects a full
leading exponent projecting to that vertex. Equation (3) bounds
every such vertex, so convexity bounds every active normal exponent
in total degree. This perturbation also supplies one active pair
`(a,beta)` with
\[
 |a|+|\beta|\le H_0(D+1).
 \tag{4}
\]
The perturbations may depend on the weights; the bound does not.
There has been no division by a smallest normal weight. When a
weight is zero it is instead treated as a tangential coordinate on
the corresponding face chart.

### 2. A uniformly bounded logarithmic operator

Let `L=ceil(H_0(D+1))`, and choose the pair `(a,beta)` in (4).
Apply the operator
\[
 T=\partial_y^\beta
    \prod_{i=1}^s\prod_{\substack{0\le j\le L\\j\ne a_i}}
          (z_i\partial_{z_i}-j).
 \tag{5}
\]
Its order is at most `(s+1)L`, hence at most
`(n+1)(H_0+1)(D+1)`. It kills all the other least normal terms,
multiplies the selected one by a nonzero integer, and makes its
coefficient a unit. Higher normal terms stay higher.

For `d_0=r_F(v)(g)`, let
`I_>=(z^a' : <a',v(z)> > d_0)`. This is a finitely generated
monomial ideal. In the completed local ring,
\[
 Tg=h z^a\pmod{I_>},\qquad h\text{ a unit}.       \tag{6}
\]
This congruence is a local-ring statement, not an assertion that
the valuation is continuous on an arbitrary completion. The
selected normal coefficient is the restriction of a regular
lifted normal derivative divided by `a!`; etaleness permits these
derivatives. Lift it to a regular local unit `h`. Multiplying any
additional normal term of this lift by `z^a` puts it in `I_>`.
Faithful flatness of completion descends (6) to the local ring.
Every generator of `I_>` has `v`-value strictly greater than `d_0`,
whereas `v(h z^a)=d_0`. Thus
\[
                   v(Tg)=d_0.                 \tag{7}
\]
The argument also works at a nonclosed centre by localization.
The size of the positive gap is never used in a constant.

For a regular logarithmic vector field `L_0` on `(P,F)` and
`d=A_(P,F)(v)`, one has
\[
               v(L_0 f)\ge v(f)-d.            \tag{8}
\]
Here is the discrepancy calculation, including its sign. Take a
local logarithmic top form `omega`. At a prime divisor `E` over
the chart, `ord_E(omega)=A_(P,F)(E)-1`. The identity
`(L_0 f) omega = f dlog(f) wedge i_(L_0) omega` has a right-hand
wedge with order at least `-1`: a top-degree wedge can have at
most one normal logarithmic pole along `E`. Regular coefficients
have no negative order. Consequently
`ord_E(L_0 f)+A_(P,F)(E)-1 >= ord_E(f)-1`, which is (8).
Rational monomial weights are divisorial after rescaling; their
approximation to real monomial weights on a higher adapted smooth
model proves (8) for quasi-monomial `v`. Only finitely many
functions occur in each use, and their values and discrepancy are
continuous on that monomial cone. Intermediate zero outputs cause
no exception to the valuation inequality.

Each Euler factor minus a scalar in (5) obeys the same loss bound,
since `d>=0`. Iterating (8) and using (7) proves
\[
 0\le v(g)-r_F(v)(g)\le K_{\rm jet}(D+1)A_{P,F}(v).
 \tag{9}
\]
This proves `L_LC_JET`, including face limits. The lower bound is
also the ordinary monomial-retraction inequality.

### 3. Simultaneous comparison on the entire local ring

Resolve `Psi`, all the `g_i`, and the maximal ideal. With `E` the
whole reduced snc support, write
\[
 e(v)=A_{P,E}(v)+\sum_i\delta_i v(E_i),\qquad
 \delta_i\ge0,\quad F=\bigcup_{\delta_i=0}E_i.
 \tag{10}
\]
Set `r=r_F(v)`. The finitely many positive `delta_i` have a
positive minimum, so
\[
 A_{P,F}(v)\le H e(v),\quad
 0\le A_X(v)-A_X(r)\le H e(v).                  \tag{11}
\]
For any one of the resolved ideals or functions its evaluation
at `v` minus its evaluation at `r` is nonnegative and at most
`H e(v)`, after enlarging `H`. This follows directly by subtracting
the component formulas. Klt of the bare germ makes the coefficients
`A_X(E_i)` strictly positive. In particular these statements
do not require the crepant pullback boundary to be effective.

Suppose `A_X(v),A_X(r)<=M` and `v(m),r(m)>=c_0>0`.
For a nonunit `f`, put `q=ord_m(f)>=1`. Choose once an integer
`L_0` with `L_0 c_0>C_I M`, where `C_I` is the bare-germ
Izumi constant, and put `N=L_0 q+1`. Represent `f` modulo `m^N`
by a polynomial `g` of degree less than `N` in fixed affine
generators vanishing at `x`. Such representatives exist for the
localized ring too: invert a unit denominator by its finite
geometric expansion modulo `m^N`. The error has value at least
`N c_0`, strictly greater than both `v(f)` and `r(f)` by Izumi.
Hence `v(g)=v(f)` and `r(g)=r(f)`. Applying (9) and (11) gives
\[
 v(f)-r(f)\le K_{\rm jet}N H e(v)
 \le K_{\rm jet}(L_0+1)H q e(v).
\]
Since `r(f)>=c_0 q`, one constant `C` gives
\[
        r(f)\le v(f)\le(1+C e(v))r(f)          \tag{12}
\]
**for every local regular function at once**. Units have value zero.
This proves `L_LC_ALL`. Inclusions of valuation ideals give
\[
 \operatorname{vol}(v)^{1/n}\ge
 \frac{\operatorname{vol}(r)^{1/n}}{1+C e(v)}. \tag{13}
\]
Volume limits exist by Cutkosky, `arxiv:1508.01938v1`, Theorem 1.1
(= Theorem 5.5); the excellent normal local rings here have reduced
completion, satisfying the nilradical hypothesis. Integer thresholds
and then squeezing give the same limit for real thresholds.

Equation (9) with `e=0` also proves that every quasi-monomial lc
valuation equals its retraction. The normalized zero-defect locus
`Q` is therefore a finite union of closed monomial simplices.
Each is compact because the coefficients `A_X(E_i)` are positive.
Retain the strata whose image closures contain `x`; this condition
is preserved on faces. Resolved function evaluations are linear
on each cone and agree on faces. Thus `Q` is compact and their
evaluations are continuous. In particular, compactness of `K`
and positivity in the theorem imply
\[
       0<\beta_0\le b_\eta(q)\le B_0
                  \quad(\eta\in K,\ q\in Q).  \tag{14}
\]
This includes noncentred faces, not just centred valuations.

### 4. Every relevant competitor has uniform bounds

The numerator of the discrepancy in (1) is `e+lambda b_eta`.
On the resolved model its residual coefficient is `1+lambda alpha`,
and its component coefficients are `delta_i+lambda b_eta(E_i)`.
For `delta_i=0`, (14) bounds `b_eta(E_i)` uniformly below by a
positive number. For positive `delta_i`, boundedness of the
height coefficients supplies a common small threshold preserving
positivity. There are finitely many components. Thus (1) is klt
for one common small parameter range; effectivity is the separate
hypothesis of the theorem.

Choose a fixed centred `q_* in Q` and a finite positive `M_0`
bounding `b_eta(q_*) vol(q_*)^(1/n)` for all `eta in K`.
Normalize a centred quasi-monomial competitor by `A_X(v)=1`.
It suffices to consider the **entire** sublevel set
\[
 (e(v)+\lambda b_\eta(v))\operatorname{vol}(v)^{1/n}
                         \le\lambda M_0.     \tag{15}
\]
Every actual minimizer belongs to it by comparison with `q_*`.

Izumi and Hilbert--Samuel growth give `vol(v)>=c>0` uniformly on
`A_X=1`. The fixed finite functions and bounded height coefficients
give `|b_eta(v)|<=H_1`. Consequently (15) implies
`0<=e(v)<=H_2 lambda`. Equations (11) give
`1-H e(v)<=A_X(r)<=1`; hence for small lambda, `r` is nontrivial
and `r/A_X(r) in Q`. By (14),
\[
 \beta\le b_\eta(r)\le B,\qquad
 |b_\eta(v)-b_\eta(r)|\le D e(v)               \tag{16}
\]
with fixed `beta>0,B,D`, simultaneously over `eta in K`.
Make lambda smaller so that `b_eta(v)>=beta/2`. Now (15) bounds
`vol(v)^(1/n)<=2M_0/beta`. Bare-germ properness with `A_X=1`
then gives `v(m)>=c_1>0`. The resolved-ideal comparison for `m`
gives `r(m)>=c_1/2` for small lambda. The assumptions of (12)
hold with constants independent of `eta,v,f,lambda`.

This proves `L_LC_SUBLEVEL` without assuming that a minimizer
already lies on the constraint and without using pointwise
convergence as a substitute for exactness.

### 5. One rational choice forces exactness

For any competitor in (15) put
\[
 e=e(v),\quad h=b_\eta(v),\quad b=b_\eta(r),\quad
 R=\operatorname{vol}(r)^{1/n},\quad
 V=\operatorname{vol}(v)^{1/n},\quad K_1=1+Ce.
\]
Equations (13) and (16) give `K_1 V>=R`,
`h>=b-De`, and `0<b<=B`. The following polynomial identity is
the exact universal arithmetic certificate:
\[
\begin{split}
 K_1[(e+\lambda h)V-\lambda bR]
 ={}&Re[1-\lambda(D+CB)]\\
 &+R\lambda Ce(B-b)
   +R\lambda(h-b+De)\\
 &+(e+\lambda h)(K_1 V-R).
\end{split}                                                    \tag{17}
\]
All terms on the right are nonnegative. If `e>0`,
`lambda(D+CB)<1`, and `R>0`, the first term is strictly positive.
Also `K_1>0`. Thus
\[
               (e+\lambda h)V>\lambda bR.     \tag{18}
\]
The positivity of `e+lambda h` follows already from klt; it is
also forced by the scalar hypotheses with the strict budget.

Choose one positive rational `lambda_0` below all preceding
thresholds and below `1/[2(1+D+CB)]`. This choice depends only on
the fixed data and `K`. For every smaller parameter,
`lambda(D+CB)<1/2`, so (18) strictly improves every positive-defect
competitor in (15) by retraction. The factor `1+lambda alpha` in
the pair discrepancy is constant across competing valuations and
does not affect minimization. A global minimizer exists and is
quasi-monomial by the cited ordinary theory. Its defect must be
zero. Competitors outside (15) cannot be minimizers, so this is a
statement about the actual global minimum, not a restricted
search.

On the lc cone the objective is `lambda b_eta vol^(1/n)`.
Ordinary klt uniqueness therefore implies constrained uniqueness
and independence of the ray from lambda. Stable degeneration
then gives finite generation of its associated graded.
This proves the verification theorem.

The proof of the rational-height bridge does **not** use the
manuscript's convex-domination lemma, multiplier-ideal summation,
or strict volume-gap lemma. In particular there is no need to
assume constrained attainment before constructing the ordinary
minimizer.

### 6. The two encodings really meet these hypotheses

**Complements.** Principalize `I_0,J,m` simultaneously. If
`I_0 O_P=O_P(-D_0)`, sufficiently many general elements have
divisors `D_0+M_i`, with residual free divisors meeting all
existing strata transversely and containing none of them.
Set `B_0=(c/N) sum div(f_i)`. Choose `N` so `c/N<1`.
Its crepant discrepancies on the old components are exactly
those of `I_0^c`; each new moving component has strictly positive
discrepancy. The snc component formula shows that `A_X-B_0>=0`
and its zero cone is exactly the original ideal-lc cone.

Similarly average sufficiently many general equations of `J`
with coefficient `c'` to obtain `B_J`. Choose their individual
coefficients at most `1/2`. The old component inequalities
`b_0 A_X-c'v(J)>=A_X`, the residual coefficient `b_0>=1`, and
the new moving-component inequalities give
`A_X/2<=a_D=b_0 A_X-B_J<=b_0 A_X` on every valuation.
General residual divisors have value zero at all monomial
zero-discrepancy strata, so `a_D=a` there. Empty residual
divisors and a unit ideal `J` cause no exception.

Use the theorem with `Psi=B_0`, `alpha=b_0`,
`b_eta=a_D`, and
`Delta_t=(B_0+t B_J)/(1+t b_0)`.
Effectivity is automatic, and `a_D>=A_X/2` supplies positivity
on all lc faces. This proves the claimed exactness and uniqueness.
The unique ray is preserved by any torus preserving the original
ideals and height; normalization by the positive maximal-ideal
value makes the valuation itself invariant. This verifies
Proposition `a:exact-penalization` in the complex local setting
in which the complements proof operates after its Section 2
reduction. Its separate field-descent theorem is not proved here.

**Cartier sections.** Set `b_j=(h^(m_j),F_j)` and choose positive
rational `theta_j` of sum less than one. The ideal discrepancy is
\[
 A_X(v)-v(h)+\sum_j\theta_j
       [v(h)-\min\{v(h),v(F_j)/m_j\}]\ge0.       \tag{19}
\]
Equality is precisely the common lc cone, since every summand
is nonnegative. After resolving the pencils, a general single
member `h^(m_j)+a_j F_j` has its fixed ideal divisor plus a
residual free divisor. Its moving coefficient `theta_j/m_j<1`
and snc transversality introduce no new lc strata. Thus
`Psi=(1-sum theta_j) div(h)+sum(theta_j/m_j) div(h^(m_j)+a_j F_j)`
is effective and lc with exactly the specified zero cone.
Its pencil values on that cone equal `m_j v(h)` because the
residual divisor contains no lc stratum.

For the allowed rational height
`b=b_0 v(h)-sum b_l v(G_l)`, take `alpha=0` in (1).
The coefficient of `div(h)` in `Psi` is positive. Taking
`lambda b_0<1-sum theta_j` preserves effectivity, and the theorem
gives the exact klt realization asserted in
`thm:E-exact-minimizer`. The same reasoning works for any fixed
compact positive family of such heights, with a bound on `b_0`.

This proves `L_LC_ENCODING` and verifies the rational exactness
part of the Cartier theorem. Its real-height continuity,
central-slice transfer, and later geometric uses are not asserted
as certified consequences of the scalar compiler result.

## An adversarial infinite family and a sharpness check

The most obvious way to break an all-function estimate is high-order
cancellation transverse to an lc stratum. It does not break (12), and
its exact arithmetic shows why the degree dependence in (9) is needed.

On `X=A^2` at the origin take `h=xy`. Set `z=y-x` and let `v_q` be
the monomial valuation in the regular coordinates `(x,z)` of weights
`(1,1+q)`, for any real `q>0`. On the first blowup, use coordinates
`t=x,s=y/x-1`; their weights are `(1,q)`. The lc boundary on that
model contains the exceptional divisor with coefficient one, and
the centre in question is its point `s=0`, away from the strict
transforms of the axes. Thus the lc-skeleton retraction is `r=ord_0`.
Directly,
\[
 A_X(v_q)=2+q,\quad v_q(xy)=2,\quad e(v_q)=q,\quad
 \operatorname{vol}(v_q)=\frac1{1+q}.
\]
For the volume formula, the monomials outside the threshold ideal
are the lattice points `i,j>=0` with `i+(1+q)j<T`.
Their number is `T^2/[2(1+q)]+O(T)`; multiplying by `2!/T^2`
gives the displayed limit, for irrational weights as well.
For **every** integer `m>=1`,
\[
 v_q((y-x)^m)=m(1+q),\quad r((y-x)^m)=m,\quad
 v_q((y-x)^m)-r((y-x)^m)=mq.
\]
Consequently one cannot replace the degree-linear jet loss by a
degree-independent constant. After `A_X=1` normalization, the
defect is `q/(2+q)` while the relative all-function excess is `q`;
as `q` tends to zero their ratio tends to `2`. A uniform `o(e)`
replacement of the multiplicative error is therefore false even
on this smooth germ. This is a sharpness assertion about a stronger
estimate, not a refutation of either manuscript.

The allowed Cartier height `b(v)=v(xy)` has value one on `Q`.
The effective klt pair is `(X,(1-lambda) div(xy))` for
`0<lambda<1`. Against `r`, this entire off-skeleton family has
the strictly positive normalized-volume excess
\[
 \frac{(q+2\lambda)^2}{1+q}-4\lambda^2
   =\frac{q[q+4\lambda(1-\lambda)]}{1+q}>0.
\]
`verify.py` checks the numerator identity symbolically for
independent indeterminates. There is no finite sampling of `q`
or `m`, and this family is not substituted for the general proof.

## Certificate boundaries and originality

`verify.py` replays (17) as an exact polynomial identity in
independent indeterminates, checks the manifest sign certificate,
and independently replays the retained Jacobian enclosure of
`1-t` for `0<=t<=1/2`. This is a universal reduction, not a finite
counterexample search. The geometric steps (2)--(16) and the
two encodings are the mathematical proof requiring human review.
No manuscript assertion has been established false by this route.

The compact-family extension and the removal of constrained
attainment/convex-domination inputs from the rational realization
argument are the precise improvements over the two staged proofs.
The bounded primary lookup did not settle originality.
Independent Reviewer replay and a significance/novelty decision
are required before calling this a publishable new result or
stopping the overall exploratory campaign.

The actual Lean 4.31.0 run succeeded with exit code zero and no
proof holes. Its official immutable claim certificate is
`certificates/C_LC_PENALTY_ALG-acb7dd6349d2d7b2.json`, relative to
this directory. The source and fidelity text remain unchanged
since that run. The graph deliberately does not mark the
geometric claims reviewer-confirmed.

The eight primary assumptions have been read as described above,
but their official `citation_check` attribution records are
still outstanding. In this mission the permitted write paths
do not include the tool's automatic `research/literature/`
archive. No archive-path workaround, fabricated reader identity,
or self-attribution has been used. This is a review-delivery
obligation, not a reason to reinterpret an unchecked citation
as a mathematical refutation or as a completed literature check.

## Reproduction

From the campaign root, run:

```sh
python3 research/lc-slice-audit/verify.py
```

This needs only Python's standard library and the retained
Jacobian and official Lean outputs. It does not silently rerun
network retrieval or a compiler. To obtain a fresh real compiler
record, the authoritative command is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/lc-slice-audit/Main.lean --statement-fidelity research/lc-slice-audit/statement_fidelity.md --claim C_LC_PENALTY_ALG --project-root .
```

Do not edit either formal source or statement fidelity during
that command. A new compile can produce a new official archive;
after a material change regenerate the arithmetic certificate
with `verify.py --write-certificate`. Independent review must
read the geometric proof as well as replay the arithmetic.
