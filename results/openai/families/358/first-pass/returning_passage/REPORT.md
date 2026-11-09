# Returning passages: exact endpoint reduction and a uniform certificate

## Result and scope

For the actual cometric family in the September 24, 2026 staged manuscript,
Proposition `prop:turning-index` holds. The proof below treats every smooth
field, not just endpoint-zero fields, and uses one positive parameter interval
for both ends, all incidence angles, and all finite excursion lengths.
It also gives an exact endpoint criterion in every torus dimension and
identifies the nullspace for the staged two-dimensional family.

This is a mathematical proof with an executable exact-algebra certificate,
not a finite search or a formalization of the differential geometry. Independent
Reviewer acceptance and publication-level novelty assessment remain pending.
No flaw in the manuscript is asserted. The main global existence theorem and
the topological obstruction are not certified by this local result.

## Primary sources and prior-result boundary

All source paths below are relative to
`research/openai_manuscript/A-Three-Manifold-Without-Conjugate-Points-and-Without-a-Nonpositively-Curved-Metric-September-24-2026/build/`.

| Source | Locators used |
|---|---|
| `sections/cometric.tex`, lines 22-82 | `eq:cometric-cutoff`, `eq:cometric-path`, `eq:end-frames`, `eq:end-cometric-slope`: defining data only |
| `sections/cometric.tex`, lines 87-185 | `lem:cometric-bounds`: estimate to be independently established below, not assumed |
| `sections/variations.tex`, lines 31-163 | `eq:index-definition`, `eq:normal-index-definition`, `eq:neck-geodesic`, `lem:coordinate-index`: conventions and identities rederived below |
| `sections/variations.tex`, lines 166-238, 313-370 | `lem:neck-passages`, `lem:turning-gauge`: returning data and unrestricted gauge, rederived below |
| `sections/turning.tex`, lines 11-17, 42-305 | `prop:turning-index`, `lem:turning-time`, `lem:turning-S-bounds`, `eq:turning-gain`: the claim and strongest prior proof |
| `sections/global.tex`, `sections/introduction.tex` | `prop:global-assembly`, `lem:index-criterion`, `thm:main`: downstream dependencies, not certified here |

The manuscript already proves nonnegativity using a Hilbert-space relaxation
and a strict timing margin. The improvement here is an *attained*, necessary
and sufficient endpoint reduction, a quantitative normal-energy gap, a complete
nullspace description, and an explicit admissible interval for a fixed smooth
cutoff. Neither the general Schur-complement method nor the manuscript's
nonnegativity statement is claimed as new.

A targeted literature search for this specialized endpoint criterion and
nullspace theorem returned no usable primary-source match. Its secondary
suggestions were not adopted as mathematical premises. This negative retrieval
does not establish novelty. No external theorem is needed without a proof:
the one scalar boundary-value problem used below is justified directly.
The source citations identify the dated staged release and exact local locators;
no DOI or arXiv identifier was supplied for it. The ledger consequently reports
these source-definition records as `uncited`, not registry-verified. Their
statement fidelity must be read independently, rather than inferred from the
algebra certificate.

## 1. The source family and a nonempty uniform parameter interval

Fix a smooth nondecreasing function chi, independent of delta, equal to zero
on `(-infinity,5/12]` and to one on `[7/12,infinity)`. Set

\[
 a(u)=\begin{cases}\exp(-1/(2/3-u)),&u<2/3,\\0,&u\geq2/3,\end{cases}
 \quad A(u)=\int_0^u a(y)\,dy,\quad
 d_1=1+\delta A(t),\quad d_2=1+\delta A(1-t),\quad s=\delta^2\chi(t).
\]
\[
 P_x(t)=B_s\operatorname{diag}(d_1,d_2)B_s^{\mathsf T},\qquad
 B_s=\begin{pmatrix}1&s\\0&1\end{pmatrix},\qquad
 g=dt^2+dx^{\mathsf T}P_x^{-1}dx.
\]

Write `M1 = sup |chi'|`, `M2 = sup |chi''|`, and define the explicit constants

\[
 m=144/3^{12}=16/59049,\quad
 K_1=1+3M_1,\quad K_2=1+2M_1+M_1^2+3M_2,\quad
 B=2(1+M_1),\quad C_0=3+2B^2/m,
\]
\[
 \delta_*=\min\{1/2,\ m/(2K_2),\ 9/(1820C_0)\}>0.                 \tag{1}
\]

Every assertion below holds for every fixed source-admissible chi and every
`0 < delta <= delta_*`. In particular chi is never chosen as a function of
delta.

### Both frames, with their actual orientation

Let epsilon = delta squared. The left frame is `x=y, tau=t`. The right is

\[
 x=T_2y,\quad T_2=\begin{pmatrix}\epsilon&1\\1&0\end{pmatrix}
             =B_\epsilon J,\quad
 J=\begin{pmatrix}0&1\\1&0\end{pmatrix},\quad \tau=1-t.
\]

Thus `p_y = T_2^T p_x` and

\[
 P_y(\tau)=T_2^{-1}P_x(1-\tau)T_2^{-\mathsf T}
 =J B_{s(1-\tau)-\epsilon}
       \operatorname{diag}(d_1(1-\tau),d_2(1-\tau))
       B_{s(1-\tau)-\epsilon}^{\mathsf T}J.
                                                               \tag{2}
\]

Equivalently this is the same diagonal family in reversed order, conjugated by
a *lower* shear of absolute size at most delta squared. Its first two derivative
bounds are the same as those of the left-frame upper shear. In both inward
frames, for `0 <= tau <= 1/4` (in fact through `1/3`),

\[
 P_i(\tau)=\operatorname{diag}(1+\delta A(\tau),b),\quad
 b=1+\delta A(1),\quad P_i'(0)=\kappa ee^{\mathsf T},\quad
 e=(1,0)^{\mathsf T},\quad \kappa=\delta e^{-3/2}>0.              \tag{3}
\]

Consequently `-Q_i'(0)=kappa ee^T`. In the original x,t frame the signs are
`P_x'(0)=kappa e e^T`, `P_x'(1)=-kappa h h^T`, where
`h=(epsilon,1)^T`; likewise `Q_x'(0)=-kappa ee^T` and
`Q_x'(1)=kappa e2 e2^T`. Reversing t at the right boundary is essential.

### Verification of the geometric estimates, not an assumption of them

For `0 <= u < 2/3`, let `h(u)=-a'(u)`. Then
`0 <= a <= 1`, `0 <= h <= 1`, and `a^2 <= h`.
Indeed `h=x^2 exp(-x)` with `x=1/(2/3-u) >= 3/2`, its maximum is
`4 exp(-2)<1`, and `a^2/h = (2/3-u)^2 a <= 4/9`.
These inequalities extend over the flat zero part by smoothness.
More explicitly, every derivative at that cutoff is a polynomial in x times
`exp(-x)` as x tends to infinity, and all such limits vanish; the exponential
series bounds `exp(x)>=x^(k+1)/(k+1)!` prove this for each power k.
On the shear-transition interval `[5/12,7/12]`, both `h(t)` and `h(1-t)`
are at least `144 exp(-12)>m`; here `x` ranges from 4 to 12 and
`x^2 exp(-x)` is decreasing. The elementary series bounds `2<exp(1)<3`
justify all rational replacements.
For example `exp(1)>2` by its positive series, while
`n!>=2^(n-1)` for n>=1 bounds that series strictly below 3.

In either frame write `P=D+E`, where D is its diagonal family.
The possibly nonzero entries of E are `d s^2` and `d s` (or their
lower-shear counterparts), with `d<=3/2`, `|d'|,|d''|<=delta`,
`|s|<=delta^2`, `|s'|<=delta^2 M1`, `|s''|<=delta^2 M2`.
Differentiation and `delta<=1/2` give

\[
 \|E'\|\leq\delta^2(5/8+9M_1/4)\leq K_1\delta^2,\qquad
 \|E''\|\leq\delta^2(5/8+3M_1/2+3M_1^2/4+9M_2/4)
              \leq K_2\delta^2.                               \tag{4}
\]

For a symmetric matrix `[[alpha,beta],[beta,0]]`, its operator norm is at
most `|alpha|+|beta|`, explaining these entrywise estimates.
On the transition interval this proves

\[
 -P''\succeq(m\delta/2)I,\quad \|P'\|\leq B\delta,\quad
 |P'p|^2\leq(2B^2/m)\delta\,p^{\mathsf T}(-P'')p.              \tag{5}
\]

Off that interval the shear is constant, of norm and inverse norm at most
`5/4`. There `P=B_s D B_s^T` with constant B_s, so `a^2<=h` gives
`|P'p|^2 <= (25/16) delta p^T(-P'')p`, and `||P'||<=25delta/16`.
Also, everywhere `I/2 <= P <= 3I`, since `1<=d_i<=3/2`.
Thus, uniformly in both frames,

\[
 P''\preceq0,\quad \|P\|\leq C_0,\quad\|P'\|\leq C_0\delta,\quad
 |P'p|^2\leq C_0\delta\,p^{\mathsf T}(-P'')p.                 \tag{6}
\]

This proves every cometric hypothesis used below for the actual source family.
No substitute matrix path or sampled concavity test is used.

For a fully numerical example, fix
`rho(u)=exp(-1/u)` for u>0 and zero otherwise,
`theta(u)=rho(u)/(rho(u)+rho(1-u))` on `[0,1]`, extended by 0 and 1, and
`chi(t)=theta(6t-5/2)`. This is a fixed smooth source-admissible cutoff.
On `[0,1]`, `|rho'|<=1`, `|rho''|<=23`, the denominator is greater than
`1/9`, its first derivative has absolute value at most 1, and its second
at most 46. Differentiating `D theta=rho` gives `|theta'|<=18`,
`|theta''|<=945`. Hence `M1<=108`, `M2<=34020`.
For these upper bounds, `K2=113941` and `C0=701561175/2`.
Exact rational comparisons in `verify.py` prove that

\[
                         0<\delta\leq10^{-12}                 \tag{7}
\]

is contained in (1). This is an existence example, not a restriction replacing
the arbitrary fixed cutoff in the theorem.

## 2. Intrinsic signs and the unrestricted gauge

Lift a finite passage to the torus cover. Conservation of cyclic momentum and
unit speed give

\[
 p=Q\dot x,\quad F(t)=p^{\mathsf T}P(t)p,\quad
 v=\dot t,\quad v^2=1-F,\quad \dot v=-F'/2.
\]

For a returning passage in its inward frame, `t(0)=t(L)=0`,
`v(0)=-v(L)=v0>0`, and there is a unique maximum `t_*<1`.
Concavity gives `0<F'(t_*)<=F'(t)<=kappa p1^2` on `[0,t_*]`.
To justify these statements independently: an interior zero of v with F'=0
would be an equilibrium by scalar ODE uniqueness. Every other zero is a
strict extremum; concavity rules out another zero before the boundary.
Time reversal and uniqueness give symmetry. At an endpoint with v=0,
`t''=-kappa p1^2/2` either points out of the open neck on both sides or,
if p1=0, uniqueness keeps the geodesic on the boundary. Thus actual finite
passage endpoints are transverse. In particular p1 is nonzero and

\[
 v_0^2=\int_0^{t_*}F'(t)\,dt\leq\kappa p_1^2.                 \tag{8}
\]

For `V=(w,z)`, direct coordinate differentiation of the energy, using
`Q'=-QP'Q` and `Q''=2QP'QP'Q-QP''Q`, gives

\[
 E(V)=\int_0^L\{|\dot z-P'p\,w|_Q^2+\dot w^2-F''w^2/2\}\,ds,
 \quad I(V)=E(V)-[\langle T,\Gamma(V,V)\rangle]_0^L.          \tag{9}
\]

The sign in (9) also follows by differentiating the first variation:
the second energy derivative is `I(V)+[<T,D_r V>]_0^L`, and the
coordinate-linear variation has `D_r V=Gamma(V,V)`.
The nonzero Christoffel types are
`Gamma^t_ij=-Q'_ij/2` and `Gamma^i_tj=(PQ')^i_j/2`.
If w vanishes at a boundary, (3) therefore gives
`<T,Gamma(V,V)> = v kappa z1^2/2`.
It is positive at entry and negative at exit. Subtraction of the final-minus-
initial bracket adds BOTH endpoint squares.

For any original V put `q=<V,T>`, choose
`h0=-w(0)/v0`, `hL=w(L)/v0`, and let ell be affine with endpoint values
`q(0)+h0`, `q(L)+hL`. The change `V -> V+(ell-q)T` is smooth, kills
both endpoint values of w, and makes q affine. Since T is parallel,
`Iperp(V+hT)=Iperp(V)` pointwise, without endpoint conditions.
Write
`X=z(L)-z(0)`, `C=z(L)+z(0)`, and `mu=kappa v0/4`. Equation (9) becomes

\[
 I^\perp(V)=E(V)+\mu X_1^2+\mu C_1^2-(p^{\mathsf T}X)^2/L.   \tag{10}
\]

This is an equality, including the endpoint-center square discarded in the
manuscript's inequality. No arbitrary endpoint data have been removed.

## 3. Exact endpoint theorem in arbitrary torus dimension

The following statement is not restricted to the staged small-parameter family.
Let P be a smooth positive definite n by n cometric along a returning passage,
with `P''<=0`, endpoints `v=+/-v0`, and `P'(0)>=0`. Define

\[
 H(s)=-F''(t(s))/2\geq0,\quad r_q(s)=q^{\mathsf T}P'(t(s))p,
 \quad -u_q''+Hu_q=r_q,\quad u_q(0)=u_q(L)=0,
\]
\[
 S(q,r)=\int_0^L q^{\mathsf T}Pr\,ds+
              \int_0^L(u_q'u_r'+Hu_qu_r)\,ds,\qquad
 M=(v_0/4)Q(0)P'(0)Q(0).                                   \tag{11}
\]

The scalar boundary-value problem has a unique smooth solution. Uniqueness
follows by integrating `u(-u''+Hu)`. For existence, solve the initial-value
problem and adjust its initial slope by the homogeneous solution y with
`y(0)=0,y'(0)=1`; since `y''=Hy` it stays positive and `y(L)>0`.
S is positive definite because its first integral is.

For a gauged field set `lambda=S^{-1}X`, `xi=z'-P'p w`, and

\[
 R=\int_0^L|\xi-P\lambda|_Q^2\,ds+
       \int_0^L\{(w'-u_\lambda')^2+H(w-u_\lambda)^2\}\,ds .
\]

Integration by parts in (11), followed by completing squares, gives the
EXACT identity

\[
 I^\perp(V)
 =R+X^{\mathsf T}(S^{-1}+M-pp^{\mathsf T}/L)X+C^{\mathsf T}MC. \tag{12}
\]

In particular the passage is nonnegative for all smooth fields if and only if

\[
                    p^{\mathsf T}(S^{-1}+M)^{-1}p\leq L.     \tag{13}
\]

For completeness, this is attained, not merely a relaxed necessary condition.
Given ANY X take `lambda=S^{-1}X`, `w=u_lambda`,
`z'=P lambda+P'p u_lambda`, and `z(0)=-X/2`.
The definition of S gives `z(L)=X/2`, so C=0 and R=0.
Moreover for this field

\[
 q'=p^{\mathsf T}P\lambda+v u_\lambda'+F'u_\lambda/2,\qquad
 q''=v(r_\lambda+u_\lambda''+F''u_\lambda/2)=0.
\]

It is therefore already in the required affine gauge, even at the turn.
This proves attainment of the endpoint quadratic. Finally
`A=S^{-1}+M` is positive definite, and
`(p^T X)^2 <= (p^T A^{-1}p)(X^T A X)`, with equality for
`X=A^{-1}p`. This proves both directions of (13).
For rank-one `M=mu ee^T`, its left side is exactly

\[
                    S(p,p)-S(p,e)^2/(S(e,e)+\mu^{-1}).        \tag{14}
\]

The factors Q(0) in (11) are indispensable in a general frame; they disappear
in the staged endpoint frames only because `Q(0)e=e`.

## 4. Universal bounds for the actual family

All quantities here are attached to a genuine returning geodesic, not free
matrix variables. Put `beta0=61/70` and `eta=9/140`.
On `[0,L/2]`, `v''=-F''v/2>=0`, so the chord bound yields

\[
 \int_0^L v^2\,ds\leq Lv_0^2/3.                              \tag{15}
\]

If `t_*>1/4`, concavity of t gives `t(s)>=1/8` on
`[L/4,3L/4]`. The endpoint germ and concavity of F give

\[
 4v_0=\int_0^L F'(t(s))\,ds
 \leq \beta\kappa p_1^2 L,\quad
 \beta=(1+e^{-9/26})/2\leq61/70=\beta_0<1.                  \tag{16}
\]

Here `a(1/8)/a(0)=exp(-9/26)` exactly and
`exp(-9/26)<=1/(1+9/26)=26/35`.
These inequalities impose no upper bound on L or positive lower bound on v0.

We now PROVE, rather than assume, the three estimates on S. For every
zero-boundary test function w,
`integral F'w=2 integral v w'`. Therefore (11) gives
`||u_p||_H^2<=4 integral v^2`, whence

\[
 S(p,p)\leq L+3\int v^2\leq L(1+v_0^2).                     \tag{17}
\]

Equation (6) gives `|r_e|<=sqrt(2C0 delta H)` pointwise, including at
H=0. Cauchy--Schwarz gives
`||u_e||_H^2<=2C0 delta L`. Thus

\[
 S(e,e)\leq3C_0L.                                          \tag{18}
\]

For the mixed term, `D(t)=P'(0)-P'(t)>=0` has norm at most
`2C0 delta`, and
`0<=p^T Dp=kappa p1^2-F'(t)<=kappa p1^2`. PSD Cauchy--Schwarz,
which remains valid when D is singular, gives
`|e^T Dp|<=sqrt(2C0 a(0)) delta |p1|`.
Integrating `e^T P'p` in t and using `e^T P(0)p=p1` bounds the
first mixed integral by
`[a(0)+sqrt(2C0 a(0))] delta L |p1|`.
The other mixed integral is at most
`2 sqrt(2C0 a(0)/3) delta L |p1|`, by (8), (15), and (18)'s proof.
Since `C0>=1` and `a(0)<=1`, their sum is at most `5C0`. Hence

\[
                   |S(p,e)-Lp_1|\leq5C_0\delta L|p_1|.      \tag{19}
\]

The error scales with |p1|, not |p|. No division by H or by p1 was used in
establishing (17)-(19).

For a deep return let `r=v0^2/p1^2>0` and `z=C0 delta`.
By (8), `r<=delta`; (16) and `mu=kappa v0/4` give
`L mu>=r/beta0`. Equations (18)-(19) and monotonicity of
`x/(1+3C0 x)` imply

\[
 \frac{S(p,e)^2}{S(e,e)+\mu^{-1}}
 \geq Lv_0^2\frac{(1-5z)^2}{\beta_0+3z}.                    \tag{20}
\]

For `0<=z<=z0=9/1820`, all denominators and `1-5z` are positive, and

\[
 (1-5z)^2-(\beta_0+3z)-\eta=13(z_0-z)+25z^2\geq0,
 \qquad 0<\beta_0+3z\leq1613/1820<1.
\]

Thus the factor in (20) is at least `1+eta`. Substitution in (14) proves

\[
 p^{\mathsf T}(S^{-1}+\mu ee^{\mathsf T})^{-1}p
       \leq L(1-\eta v_0^2)<L.                              \tag{21}
\]

In detail, put `A=S^{-1}+mu ee^T`. Matrix Cauchy--Schwarz and the square
completion in Section 3 give
`(p^T X)^2 <= (p^T A^{-1}p)(X^T A X)` and
`X^T A X <= E+mu X1^2`. Equation (21) therefore gives
`(p^T X)^2 <= L(1-eta v0^2)(E+mu X1^2)`.
Combining with the EXACT identity (10) yields the strengthening

\[
 I^\perp(V)\ \geq\
 \frac9{140}v_0^2(E+\mu X_1^2)+\mu C_1^2\ \geq\ 0.          \tag{22}
\]

This proves the proposition uniformly for every deep return in both frames.

## 5. Shallow returns and the exact nullspace

If `t_*<=1/4`, the metric is the product of the flat fiber with the surface
metric `dt^2+ell(t)^2 dx1^2`, where `ell=(1+delta A)^(-1/2)`.
Direct differentiation gives

\[
 \ell''=-\frac{\delta a'}{2(1+\delta A)^{3/2}}
          +\frac{3\delta^2a^2}{4(1+\delta A)^{5/2}}>0.
\]

The surface curvature is `-ell''/ell<0`, so its product has nonpositive
sectional curvature. The perpendicular index integrand is pointwise
nonnegative. This handles every shallow return without (16).

For every return, equality has the exact characterization

\[
 I^\perp(V)=0\quad\Longleftrightarrow\quad
 V(s)=c\,\partial_{y_2}+h(s)T(s)
 \quad\text{for a constant c and a smooth scalar h}.          \tag{23}
\]

For a deep return, (22) forces `E=0`, hence `w=0` and `z'=0`, and
`C1=0` then forces `z1=0`. Conversely such a constant fiber field has
zero coordinate energy, zero boundary term, and constant q.
For a shallow return, equality in the pointwise index integrand forces
the normal field to be parallel and its surface component to be collinear
with the nonzero surface component of T. The latter is nonzero because
p1 is nonzero. The parallel fields T and the constant fiber field span
this two-plane; their coefficients must be constant. Orthogonal projection
then gives (23), and tangential invariance finishes the argument.

## 6. What the executable certificate does and does not check

`verify.py` checks exact symbolic identities for the actual cometric and its
inverse, both coordinate frames, endpoint orientation, all derivative
majorants, the square completion and the affine-gauge Euler identity, the
rank-one inverse formula, and the universal rational gain (not a grid).
It also checks the fixed cutoff's explicit interval (7).
`exact_certificate.json` is regenerated deterministically by that script.
Replay from the campaign root with
`$WORKSPACE/argus-live-update/.venv/bin/python research/returning_passage/verify.py`.
It replays the archived typed Jacobian result without requiring another server
call. The symbolic matrix calculations are two-dimensional; the arbitrary-
dimension theorem in Section 3 is proved in prose, not by finite sampling.
The Jacobian adapter's bounded symbolic determinant calculation independently
checks the universal polynomial endpoint determinant. It is not used as a
proof of an analytic hypothesis or as a positivity oracle.
Specifically, for `S=[[a,b],[b,c]]` and `D=ac-b^2`, its polynomial matrix is
`N=L adj(S)+L mu D ee^T-D pp^T`, whose determinant is
`L D [L(1+mu a)-a p1^2-2b p1 p2-c p2^2-mu D p2^2]`.

Smooth ODE existence/uniqueness, integration by parts, Cauchy--Schwarz, and
the differential-geometric derivation in this document are ordinary
mathematical proof obligations for the independent Reviewer. The script
does not claim to quantify over smooth functions or geodesics by computation.
The proof above discharges the geometric hypotheses for the staged family;
none is left as an unchecked cometric estimate.
