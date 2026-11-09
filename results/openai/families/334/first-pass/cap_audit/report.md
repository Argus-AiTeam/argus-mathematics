# Uniform cap regularity: independent proof and structural extension

## Result and scope

**The scoped answer is affirmative:** Proposition `cap` follows under its
stated hypotheses, including uniformity over the families in the manuscript.
Below is a complete analytic proof of the free-edge estimate and nonlinear
bootstrap, not an inference from a finite search or an algebra check.
Independent Reviewer acceptance is still required.

The proof also establishes a structural extension. Replace the prescribed
curvature outside the perturbation square by
\[
 K=\kappa(x^{2m}-h(y)),\qquad m\in\mathbb N,\quad m\ge1.
\]
The same cap proposition holds, with constants allowed to depend on \(m\).
The linear estimate holds more generally for drift
\(C=\mu A_s+Ar\), any fixed \(\mu>1/2\), bounded \(r\), and an additional
bounded zeroth-order coefficient. The auxiliary weight exponent can be
any fixed real \(p\ge4\), rather than \(p=8\).
No sharpness assertion about either threshold is made.

The full analytic theorem is proved in this report. `verify.py` checks its
exact algebraic ingredients and derivative-count inequalities.
`Main.lean` formalizes the indicated algebra/coercivity subclaim only.
Neither checker formalizes integration, compactness, Sobolev embedding,
ODE theory, or the nonlinear analytic induction. Those parts require the
independent reader's mathematical review; they are not represented as a
kernel-checked PDE theorem.

This mission does **not** verify the pulse comparison, the category argument,
the boundary-disk lemma, or the final assembly. Theorem A remains open in the
audit graph. No false assertion in the scoped source has been established,
and consequently there is no invented `F_...` refutation claim.

## 1. Literal hypotheses and source scope

The source is the staged September 24, 2026 manuscript, under
`research/openai_manuscript/`, in particular:

| Source | Assertion used here |
|---|---|
| `build/sections/model.tex`, equations `h`, `model-curvature`, `negative-box`, `admissible` | Fixed even profile, compactly supported metric perturbations, strictly negative perturbation box, actual metric Darboux equation |
| `build/sections/caps.tex`, equations `low-bounds`, `flow` | Uniform \(C^8\), positivity/nondegeneracy, small \(q\), and the precise solution-dependent chart |
| `build/sections/caps.tex`, Proposition `cap` | All-orders bounds on images of **every compact cap rectangle**, not a prescribed smaller observation region alone |
| `build/sections/caps.tex`, Lemmas `drift`, `high-equation`, `gradient` | The three analytic steps independently proved below |

Concretely, \(S=[-3,3]^2\), \(P=[-1/10,1/10]^2\),
\(g\) is a positive perturbation of fixed \(g_0\) supported in \(P\), and
\(K<-\kappa/2\) on \([-1/5,1/5]^2\). Outside \(P\),
\(K=\kappa(x^2-h(y))\). The profile is smooth and even, equals one on
\([-1/2,1/2]\), is nonincreasing for \(y\ge0\), has the stated strict
signs on either side of \(|y|=1\), and \(h'(1)<0\).
For the extension replace \(x^2\) by \(x^{2m}\) and make the identical
strict-negative-box assumption. Fix \(m\), not a family \(m\to\infty\).

Write
\[
 H_{ij}=z_{ij}-\Gamma^r_{ij}z_r,\quad
 E=\det g(1-|dz|_g^2),\quad q=H_{xy}/H_{yy},\quad
 G=E/H_{yy}^2 .
\]
Admissibility means \(\det H=KE\), \(E>0\), \(H_{yy}\ne0\),
and \(|q|\le1/100\) throughout \(S\).
The uniform low bounds are exactly
\[
 \|g\|_{C^8(S)}+\|z\|_{C^8(S)}\le M,\qquad
 g\ge cI,\quad |H_{yy}|\ge c,\quad E\ge c.
\]
All functions are individually smooth on a neighborhood of \(S\).
The extra metric hypothesis is exactly the one in Proposition `cap`:
for each compact rectangle \(R\) in
\((-2,2)\times(-2,b_*)\), every ordinary derivative of \(g\) is
uniformly bounded on \(\Phi_z(R)\), where \(-1/4<b_*\le0\).
No uniform high derivatives of \(z\), of \(\Phi_z\), or of a top-edge
trace are assumed.

### Literature and unsuccessful routes settled at scope

The shared Wiki index has no matching Darboux/Tricomi/campaign-334 entry.
A bounded literature search did not identify a usable existing theorem
with these exact free-edge hypotheses. Its generated suggestions were not
accepted as sources or as evidence of priority.

The actual primary source Khuri, *On the local solvability of Darboux's
equation*, DCDS Supplement 2009, 451--456,
DOI `10.3934/proc.2009.2009.451`, was obtained from the author's site.
Theorem 1 on page 452 is a conditional reduction for a particular
accumulating-square curvature construction to
\(u_{tt}+Ku_{ss}=Kf\), \(f>0\); it is not the free-cap estimate.
The following discussion leaves the nonsolvable-curvature construction
open. The source and a short scope excerpt are retained beside this report.
No theorem from that paper is assumed in the proof below.

A generic nonsolvable Monge--Ampere example does not produce a metric
and admissible heights satisfying these hypotheses. That route is explicitly
retired in the ledger with this reason. Nor would failure on one small
rectangle refute the gradient lemma: its quantifiers allow a larger
rectangle containing the integration sets and their top edge.
No such finite exclusion is offered as the result.

There are no unproved external PDE regularity theorems imported here.
The local Sobolev/product fact used below is proved by the Fourier
Cauchy--Schwarz argument in section 7. The chart estimates, commutation
identity, energy identities, and boundary limits are derived below.
Foundational smooth calculus and the elementary local existence theorem
for an ODE are used in their usual senses.

Priority and publishability are not certified by a failed search.
The target remains `publishable` and the mode `exploratory`; the structural
extension is a proved candidate for independent assessment, not an assertion
that literature novelty has already been verified.

## 2. Chart bounds and uniform integration geometry

Let \(D=\partial_x-q\partial_y\), and solve
\[
 x=t,\qquad y_t=-q(t,y),\qquad y(0,s)=s.
\]
For \(|t|,|s|\le2\), the solution stays within \(|y-s|\le1/50\);
thus it remains strictly inside \(S\). The bounded, smooth vector field
has a unique flow on this interval. Differentiating its integral equation
gives
\[
 y_s=\exp\left(-\int_0^t q_y(r,y(r,s))\,dr\right)>0.
\]
The \(C^8\) low bounds imply a uniform \(C^6\) bound for \(q\), in
particular the finite derivative bounds needed here. Differentiating
the ODE two and three times and applying the integrating-factor formula
gives uniform bounds for the chart through order three. The positive
upper and lower bounds for \(y_s\) give the same low-order bounds for
the inverse. Set \(v=s_y=1/y_s\); it is uniformly positive and bounded.
In particular \(D=\partial_t\), \(\partial_y=v\partial_s\), and
the two area measures are uniformly comparable.

Fix \(R_0\Subset(-2,2)\times(-2,b_*)\).
Choose \(b\) above its top edge with \(b<b_*\).
Choose a symmetric interval \((-T,T)\), \(T<2\), containing its
horizontal projection, and a bottom \(s_0>-2\) below its bottom.
Enlarge these choices as necessary to permit two nested smooth cutoffs
at the other three edges. Each cutoff is identically one on \(R_0\)
and on
\[
 \{|t|\le3/2,\ s\ge-3/2,\ s\le b\};
\]
its derivatives are supported where \(3/2<|t|<2\) or
\(-2<s<-3/2\). Choose \(T,s_0\) and the nested transition intervals
with positive margins from \(R_0\); they are fixed for the family.

Both edge collars have uniform positive curvature. On the lateral
ones \(t^{2m}-h(y)\ge(3/2)^{2m}-1>0\).
On the lower one \(y\le-3/2+1/50<-1\), so
\(-h(y)\) has a fixed positive lower bound there. These collars avoid
\(P\). Denote a common positive lower bound by \(k_e\).
Choose a compact larger rectangle \(R_1\) whose interior contains the
closed integration rectangle
\(\Omega=[-T,T]\times[s_0,b]\), all cutoff supports, \(t=0\),
and a margin above \(s=b\). This is possible since \(b<b_*\).

Only these fixed label margins enter \(R_1\). There is no
solution-dependent choice of its edges.

## 3. An independent linear free-edge theorem

Consider on a neighborhood of \(R_1\)
\[
 Lu=u_{tt}+Au_{ss}+Bu_t+Cu_s+Vu=f,\qquad
 A=\alpha K,\qquad C=\mu A_s+Ar ,
\]
where \(K\) is the pullback of a curvature with the geometry in section 1,
\(\mu>1/2\) is fixed, \(\alpha\) has uniform positive lower and upper
bounds and bounded first derivatives, and
\[
 A,A_t,A_s,B,B_s,C,r,V
\]
have fixed uniform bounds. All coefficients involved in the integrations
are smooth; no derivatives of \(r,V\) are used.
The flow has the bounds of section 2. Then
\[
 \|\nabla_{t,s}u\|_{L^2(R_0)}
 \le C_{R_0}\bigl(\|u\|_{L^2(R_1)}+\|f\|_{L^2(R_1)}\bigr).
 \tag{L}
\]
Constants depend only on the specified bounds and fixed geometry,
including \(m,\mu,\kappa,h\) and the label margins.
There is no uniformity assertion as \(\kappa\downarrow0\).
Replacing \(f\) by \(F=f-Vu\) reduces the proof to \(V=0\).

### 3.1 Exact directed identity

Put \(d=b-s\), fix \(p\ge4\), and define
\[
 I(t,s)=\int_0^tB(r,s)\,dr,\quad
 W=d^p e^{-\lambda s+I},\quad H=\lambda+p/d,\quad
 m_0=-W,\quad n=\epsilon tW.
\]
Here \(I_s\) is uniformly bounded solely by \(B_s\).
For any multipliers \(m_0,n\), direct product differentiation gives
\[
 (u_{tt}+Au_{ss}+Bu_t+Cu_s)(m_0u_s+nu_t)
 =Q+\partial_t F_t+\partial_s F_s,
 \tag{1}
\]
where \(Q=T u_t^2+S u_s^2+J u_tu_s\) and
\[
 \begin{split}
 T&=(m_{0,s}-n_t)/2+Bn,\\
 S&=-(Am_0)_s/2+(An)_t/2+Cm_0,\\
 J&=-m_{0,t}+Bm_0-(An)_s+Cn,\\
 F_t&=m_0u_tu_s+n u_t^2/2-An u_s^2/2,\\
 F_s&=-m_0u_t^2/2+Am_0u_s^2/2+Anu_tu_s .
 \end{split}
 \tag{2}
\]
In particular the sign of \(m_0\) is not a convention left to intuition.
Since \(W_t=BW\) and \(W_s=(-H+I_s)W\), the exact normalized
coefficients are
\[
 \begin{split}
 T/W&=(H-I_s-\epsilon+\epsilon tB)/2,\\
 S/W&=-(\mu-\tfrac12)A_s+\epsilon tA_t/2-HA/2
       +A\bigl((I_s+\epsilon+\epsilon tB)/2-r\bigr),\\
 J/W&=\epsilon t\bigl((\mu-1)A_s+A(H-I_s+r)\bigr).
 \end{split}
 \tag{3}
\]
For \(\lambda\) sufficiently large and \(0<\epsilon\le1\),
\[
 T/W\ge H/4,\qquad
 |J|/W\le C_J\epsilon(1+H|A|).
 \tag{4}
\]
All constants here are independent of \(d,u\) and the family member.

### 3.2 Uniform coercivity, including the zeros with \(K_y=0\)

For \(|K|\) sufficiently small we are outside \(P\).
In the lower cap \(y\le b+1/50\le1/50\), hence \(K_y\le0\):
for \(y\le0\) this follows from evenness and monotonicity of \(h\);
for \(0\le y\le1/50\), \(h=1\).
Using subscripts \(x,y\) for the physical curvature derivatives,
\[
 K_s=K_y/v,\quad
 K_t=2m\kappa t^{2m-1}-qK_y .
\]
Consequently, modulo a uniformly bounded multiple of \(A\), the
geometric part of \(S/W\) is
\[
 {\cal E}
 =\alpha\left[
 -\left(\frac{\mu-1/2}{v}+\frac{\epsilon tq}{2}\right)K_y
 +\epsilon m\kappa t^{2m}\right].
 \tag{5}
\]
First choose \(\epsilon>0\) so small that the coefficient of \(-K_y\)
in brackets is at least
\(a_*=(\mu-1/2)/(2v_{\max})>0\).
This can be done from the uniform bounds for \(t,q,v\).
The physical set
\[
 Z_m=\{(t,y)\in[-2,2]\times[-101/50,1/50]:
                         t^{2m}=h(y)\}
\]
is fixed and compact. At its points with \(t=0\), necessarily \(y=-1\)
and \(-K_y=\kappa h'(-1)>0\).
At every other point \(t^{2m}>0\).
Thus
\[
 \beta_0=\min_{Z_m}\alpha_{\min}
           [a_*(-K_y)+\epsilon m\kappa t^{2m}]>0 .
 \tag{6}
\]
Continuity, the fixed physical box, and the negative perturbation box
give \(\delta>0\), fixed for the family, such that
\({\cal E}\ge\beta_0/2\) on \(|K|\le\delta\).
This uses only fixed physical functions and low uniform bounds,
not compactness of the family of high-order charts.

Here are compatible choices for the remaining constants. The square
completion, valid for \(T>0\), is
\[
 Q\ge (T/2)u_t^2+\left(S-\frac{J^2}{2T}\right)u_s^2 .
 \tag{7}
\]
Equations (3)--(4) give constants \(C_*,C_r\), uniform also for
\(0<\epsilon\le1\), such that
\[
 \frac{J^2}{2TW}\le
 C_*\epsilon^2(H^{-1}+HA^2),\qquad
 |S/W-{\cal E}+HA/2|\le C_r|A|
 \tag{8}
\]
where (5) applies. Away from that fixed near-zero set the same
decomposition has a uniformly bounded geometric term.
Further decrease \(\epsilon\), before fixing \(\beta_0,\delta\),
so \(C_*\epsilon^2\sup|A|\le1/8\).
Choose \(\lambda\) large enough for (4), for \(\lambda\ge8C_r\),
and for \(C_*\epsilon^2/\lambda\le\beta_0/8\).
On \(K\le0\), the \(HA^2\) and \(C_r|A|\) losses then use at most
\(H|A|/4\). Near \(K=0\), (7) has a uniformly positive transverse
coefficient. On \(K\le-\delta\), increase \(\lambda\) further so
\(\lambda\alpha_{\min}\delta/4\) dominates the bounded geometric
term and the remaining constant loss. This treats the arbitrary
negative perturbation region too.

Now fix \(\epsilon,\lambda\). Write \(D_0=b-s_0\).
On \(0<K\le c_1d\),
\[
 |A|\le\alpha_{\max}c_1D_0,\qquad
 HA\le\alpha_{\max}c_1(\lambda D_0+p).
 \tag{9}
\]
Choose \(c_1>0\) small enough that this region is in \(|K|\le\delta\)
and the adverse terms \(HA/2+C_r|A|+
C_*\epsilon^2HA^2\) sum to at most \(\beta_0/8\).
Also require \(c_1D_0<k_e\), using the smaller collar lower bound
if necessary. It follows that for some uniform \(c_2>0\)
\[
 Q\ge c_2W(u_t^2+u_s^2)
       \quad\hbox{on }N=\{K\le c_1d\}.
 \tag{10}
\]
The choice order is \(\epsilon\), then \(\lambda\), then \(c_1\).
In particular no choice depends on the solution's high derivatives
or on how close \(d\) is to zero.

### 3.3 Weighted elliptic estimate, with all cutoff costs

Let \(\chi\) be the outer of the nested cutoffs of section 2,
equal to one on the support of the directed cutoff to be used below.
Let \(\phi\) be smooth, zero for \(r\le c_1/2\), one for \(r\ge c_1\),
and between zero and one. Put
\[
 v_0=d^{p-2}\chi^2\phi(K/d)^2 .
\]
On \(v_0>0\), \(A\ge a_0d>0\). On the support of \(\phi'\),
\(K=O(d)\), and \(K,K_t,K_s\) have fixed bounds. Hence
\[
 |v_{0,t}|+|v_{0,s}|
 \le C\sqrt{v_0}\left(d^{(p-2)/2}+d^{(p-4)/2}\right),
 \qquad 0\le v_0\le d^{p-2}.
 \tag{11}
\]
The squares on both cutoffs are essential for this bound at their zeros.
Testing \(Lu=F\), \(V=0\), against \(-v_0u\) gives the positive
integral
\[
 P_0=\int v_0(u_t^2+Au_s^2)
\]
and the error
\[
 \int u\{(v_{0,t}-Bv_0)u_t+
                [(Av_0)_s-Cv_0]u_s\}.
 \tag{12}
\]
In particular \((Av_0)_s-Cv_0=Av_{0,s}+(A_s-C)v_0\);
no derivative of \(C\) is being assumed.
By (11), the boundedness of \(A,A_s,B,C\), and \(A\ge a_0d\),
\[
 \frac{(v_{0,t}-Bv_0)^2}{v_0}
 \le C(d^{p-2}+d^{p-4}),
 \tag{13}
\]
\[
 \frac{[(Av_0)_s-Cv_0]^2}{Av_0}
 \le C(d^{p-2}+d^{p-4}+d^{p-3}).
 \tag{14}
\]
Ratios at \(v_0=0\) can be assigned zero: both corresponding
numerators vanish and the displayed upper bounds persist.
All powers on the right are bounded on \(0<d\le D_0\) for \(p\ge4\).
Young's inequality absorbs half of \(P_0\).
The remaining error is at most \(C\|u\|_2^2\), and
\(|\int v_0Fu|\le C(\|F\|_2^2+\|u\|_2^2)\).
It follows that
\[
 \int_{\{K\ge c_1d\}\cap\{\chi=1\}}
       d^{p-1}(u_t^2+u_s^2)
 \le C(\|u\|_{L^2(R_1)}^2+\|F\|_{L^2(R_1)}^2).
 \tag{15}
\]
Indeed there \(v_0=d^{p-2}\ge D_0^{-1}d^{p-1}\) and
\(Av_0\ge a_0d^{p-1}\).
The weaker \(p=8\) version in the manuscript therefore suffices;
(13)--(14) show directly why \(p=4\) already works.

### 3.4 Boundary terms and combination

Let \(\theta\) be the inner nonnegative cutoff, equal to one on
\(R_0\) and the nonelliptic core, and replace \(m_0,n\) in
(1)--(2) by \(\theta m_0,\theta n\).
All terms in which a derivative hits \(\theta\) lie in the positive
edge collars. By the choice \(c_1D_0<k_e\), these lie in
\(E_+=\{K>c_1d\}\), where (15) applies and \(\chi=1\).
Moreover \(N\subset\{\theta=1\}\).
Every coefficient in (2), and every cutoff error, has magnitude
at most \(Cd^{p-1}\), since \(W\asymp d^p\),
\(H=\lambda+p/d\), and the remaining coefficients are bounded.
Thus (15) controls all adverse contributions on \(E_+\).

For completeness first integrate on \(s\le b-\eta\).
At the top the directed flux in (2) is
\[
 -m_0u_t^2/2+Am_0u_s^2/2+Anu_tu_s=O(\eta^p)
\]
times bounded, individual solution derivatives.
The elliptic top flux is \(-Av_0u u_s=O(\eta^{p-2})\)
times bounded, individual solution values and derivatives.
At the other three sides the cutoffs vanish in neighborhoods.
For each fixed smooth solution all these top fluxes tend to zero.
Its derivatives are bounded there because \(s=b\) is strictly
inside its smooth domain. The constants for those *individual*
bounds never enter an estimate. After taking the limit the
identities have no trace terms at all. The integrands are integrable
up to \(d=0\) by (11)--(14) and smoothness, justifying passage to
the limit without a family-uniform trace bound.

Integrating (1), using (10), and absorbing the source on \(N\) yields
\[
 \int_N W|\nabla u|^2
 \le C\left(\int_{E_+\cap\{\chi=1\}}
                 d^{p-1}|\nabla u|^2+\|F\|_2^2\right).
 \tag{16}
\]
For the source on \(E_+\) use Cauchy--Schwarz and
\(W^2/d^{p-1}\le Cd^{p+1}\), then (15).
This costs only \(C(\|u\|_2^2+\|F\|_2^2)\).
Since \(d\) is bounded below on \(R_0\), both \(W\) and
\(d^{p-1}\) are bounded below there. Combining (15)--(16) proves
(L), and \(\|F\|_2\le\|f\|_2+\|V\|_\infty\|u\|_2\)
handles the zeroth-order term.

This is the full linear theorem, including its freedom to choose \(R_1\).

## 4. Curvature drift, derived from the actual metric equation

Put \(Y=\partial_y\), \(a=KG\), and solve the Darboux equation for
\(z_{xx}\):
\[
 P=\Gamma^r_{xx}z_r+(H_{xy}^2+KE)/H_{yy}.
\]
With the metric jets held as prescribed arguments,
\[
 P_{z_{xy}}=2q,\quad P_{z_{yy}}=-q^2-a,
\]
\[
 P_{z_i}=\Gamma^i_{DD}
       +K\left(E_{z_i}/H_{yy}+E\Gamma^i_{yy}/H_{yy}^2\right).
 \tag{17}
\]
Here \(\Gamma^i_{DD}=\Gamma^i_{xx}-2q\Gamma^i_{xy}
+q^2\Gamma^i_{yy}\) is a contraction, not a differentiation.
All displayed remainders divided by \(K\) are bounded under the low bounds.

The Darboux equation implies
\[
 H(Y,D)=0,\qquad H(D,D)=KE/H_{yy}.
\]
In particular \(H(D,X)=O(K)\) for bounded coordinate vectors \(X\).
For a scalar Hessian, commuting its third covariant derivatives
gives a curvature tensor contracted with \(dz\). In dimension two
the curvature tensor is \(K\) times a tensor made from \(g\);
hence
\[
 (\nabla_DH)(Y,D)=(\nabla_YH)(D,D)+O(K).
 \tag{18}
\]
This follows as well by commuting
\(\nabla_D\nabla_Y dz-\nabla_Y\nabla_D dz-\nabla_{[D,Y]}dz\);
the possible curvature sign convention changes only the \(O(K)\)
coefficient, not the \(K_yG\) term.

Differentiate \(H(Y,D)=0\) along \(D\).
The \(\nabla_DY\) term is \(O(K)\), and
\(\nabla_DD=\Gamma^i_{DD}\partial_i-(Dq)Y\).
Thus the left side of (18) is
\[
 H_{yy}(Dq-q\Gamma^x_{DD}-\Gamma^y_{DD})+O(K).
\]
On the right, differentiating \(H(D,D)=KE/H_{yy}\) along \(Y\)
gives \(K_yE/H_{yy}+O(K)\).
Both connection terms are \(O(K)\): their second argument is \(D\)
and the connection vectors, including \(q_yY\), are low-order bounded.
Divide by \(H_{yy}\) and use (17) to obtain the exact assertion
\[
 Dq-P_{z_x}q-P_{z_y}=K_yG+Kr_0,
 \qquad \|r_0\|_\infty\le C.
 \tag{19}
\]
This uses actual metric curvature compatibility, not a generic
Monge--Ampere substitution.

## 5. High derivative equation and its uniform coefficients

Assume all ordinary derivatives of \(z\) through order \(l\ge8\)
have uniform \(L^2\) bounds on the images of every compact cap rectangle.
On a smaller image, section 7 gives uniform supremum bounds through
order \(l-2\). Do the following differentiations in physical coordinates,
not by differentiating a high-order flow chart.

For \(u=\partial_y^l z\), differentiate \(z_{xx}=P\) \(l\) times.
The direct linearization contains
\[
 2q\,u_{xy}-(q^2+a)u_{yy}+P_{z_x}u_x+P_{z_y}u_y.
\]
The other factors of order \(l+1\) come precisely from a second-jet
argument receiving \(l-1\) derivatives and one other differentiation:
\[
 l\{2q_yu_x-(q^2+a)_yu_y\}.
 \tag{20}
\]
These are total coefficient derivatives, including the explicit
metric dependence. The factor \(l\) counts which differentiation
is assigned elsewhere. A first-jet argument with all \(l\)
derivatives has already been included in the direct linearization.
For \(l\ge8\) the high argument is unique, so (20) is not
double-counted.

Every factor left in the remainder has solution order at most \(l\).
A factor of order at least \(l-1\) has consumed at least \(l-3\)
of the \(l\) differentiations, since \(P\) depends on solution
jets only through order two. Two such factors are impossible:
\(2(l-3)>l\). All but at most one solution factor therefore have
order at most \(l-2\) and use their supremum bounds. The remaining
one uses its \(L^2\) bound. Factors with inverse \(H_{yy}\) are
bounded by the nondegeneracy assumption. Explicit metric factors
use only finitely many of the assumed metric derivative bounds.
This proves a uniform \(L^2\) bound for the remainder \(R_l\)
on any smaller compact image.

Using
\[
 D^2u=u_{xx}-2qu_{xy}+q^2u_{yy}-(Dq)u_y
\]
and \(u_x=Du+qu_y\), equations (19)--(20) give
\[
 [D^2+a\partial_y^2+B D+
            (K_yG+Kr_0+la_y)\partial_y]u=R_l,
 \quad B=-P_{z_x}-2lq_y .
 \tag{21}
\]
Transform only this already differentiated equation:
\(\partial_y=v\partial_s\) and
\(\partial_y^2=v^2\partial_s^2+v_y\partial_s\).
It becomes
\[
 u_{tt}+Au_{ss}+Bu_t+Cu_s=R_l,\qquad A=KGv^2 .
\]
In fact there is an explicit bounded remainder:
\[
 C-(l+1)A_s
   =K\{v r_0-vG_y-(2l+1)Gv_y\}.
 \tag{22}
\]
To see this, \(A_s=GvK_y+KG_yv+2KGv_y\), whereas
\(C=KGv_y+v(GK_y+Kr_0+l(K_yG+KG_y))\).
Since \(Gv^2\) is uniformly bounded below, (22) proves
\[
 C=(l+1)A_s+Ar_l,\qquad \|r_l\|_\infty\le C_l .
\]
Here the subscript \(r_l\) denotes a bounded coefficient, not the
source \(R_l\). The coefficients \(A,A_t,A_s,B,B_s,C\), and the
first derivatives and positive bounds for \(\alpha=Gv^2\),
are controlled by the original \(C^8\) bounds and low chart
derivatives. No inductively uncontrolled chart derivative occurs.

Apply section 3 with \(\mu=l+1>1/2\), \(V=0\), and \(p=4\)
(or the manuscript's \(p=8\)). This is precisely Lemma `gradient`
in the required metric situation.

## 6. Completion of Proposition cap under its literal quantifiers

Induct on the ordinary \(H^l\) bounds on images of **all** compact cap
rectangles. The initial case \(l=8\) follows from the uniform \(C^8\)
bound and bounded areas. Given the assertion at \(l\), fix \(R_0\).
The linear theorem selects a larger compact \(R_1\) in the same cap.
Choose a further compact \(R_2\) with a positive margin around \(R_1\).
The inductive assertion and metric hypothesis apply on \(R_2\);
the product argument in section 5 bounds \(R_l\) on \(R_1\).
The comparable measures transfer those bounds to flow coordinates.
The linear theorem gives \(u_t,u_s\) in \(L^2(R_0)\), and hence
\[
 \partial_y^{l+1}z=vu_s,\qquad
 \partial_x\partial_y^l z=u_t+qvu_s .
 \tag{23}
\]

Recover the remaining derivatives without another PDE estimate.
For \(2\le k\le l+1\), apply
\(\partial_x^{k-2}\partial_y^{l+1-k}\) to \(z_{xx}=P\).
The two right-hand terms of order \(l+1\) are
\[
 P_{z_{xy}}\partial_x^{k-1}\partial_y^{l+2-k}z,\qquad
 P_{z_{yy}}\partial_x^{k-2}\partial_y^{l+3-k}z .
 \tag{24}
\]
Both have fewer \(x\) indices than the derivative being recovered.
All other solution factors have order at most \(l\).
The same product argument applies, now with only \(l-1\)
differentiations; two factors of order \(l-1\) would consume
\(2(l-3)>l-1\). The coefficients in (24) are uniformly bounded.
Starting with (23) and increasing \(k\) proves the full \(H^{l+1}\)
bound on the fixed image. No inversion of a derivative estimate
and no boundary Cauchy data are involved.

This proves the induction on every compact rectangle. For any requested
ordinary derivative order \(j\), apply section 7 to an \(H^{j+2}\)
bound on a slightly larger image (or \(H^8\) when larger).
The resulting \(C^j\) bound is uniform on \(\Phi_z(R_0)\).
Only finitely many metric derivatives and intermediate compact margins
are used for each fixed \(j\); for example bounds through
\(\max(8,j+4)\) suffice.
The hypotheses provide those bounds for each of the finitely many
larger rectangles selected in this induction. Thus there is no
loss caused by the freedom to enlarge the rectangle.

Reflecting physical \(y\) and flow \(s\) changes the upper cap into the
lower cap, preserves the even profile, low bounds and admissibility,
and changes \(q\) to its reflected negative. This proves the upper
assertion too. The argument also proves the stated \(x^{2m}\) extension.

## 7. The local Sobolev/product fact and chart-order accounting

A fixed inner flow rectangle has a fixed positive physical distance
from the boundary of the image of a fixed larger one. This follows
from \(x=t\), monotonicity of \(y(t,\cdot)\), and the uniform upper
and lower bounds for \(y_s\) and the inverse first derivatives.
Therefore each point of the smaller image has an ordinary-coordinate
ball of a fixed radius contained in the larger image.
Use translations of a single smooth cutoff on those physical balls;
their derivatives of each fixed order have uniform bounds independent
of the chart.

For a compactly supported smooth \(w\) on \(\mathbb R^2\), Fourier
inversion and Cauchy--Schwarz imply, for \(|\gamma|\le l-2\),
\[
 \|\partial^\gamma w\|_\infty
 \le C_l\left(\int_{\mathbb R^2}
       (1+|\xi|^2)^{-2}\,d\xi\right)^{1/2}\|w\|_{H^l}.
 \tag{25}
\]
The integral is finite: in polar coordinates it is
\(2\pi\int_0^\infty r(1+r^2)^{-2}\,dr=\pi\).
The estimate follows by inserting the factor
\((1+|\xi|^2)^{l/2}\) in the Fourier integral and using
\(|\xi|^{2|\gamma|}(1+|\xi|^2)^{-l}
\le(1+|\xi|^2)^{-2}\).
Multiplication by the fixed physical cutoff bounds its \(H^l\)
norm by the ordinary \(H^l\) norm on the ball.
Taking the supremum of this same uniform estimate over all centers
proves the local \(C^{l-2}\) bound used in the induction.

This also proves the tame product estimate actually needed here:
in each differentiated term put the at most one factor of order
at least \(l-1\) in \(L^2\), and every other solution factor in
\(L^\infty\) using (25). All bounded inverse factors and metric
jets are coefficients. There is no appeal to a product theorem
whose constants hide chart derivatives.

The only chart derivatives used anywhere are low ones: the flow
and inverse through order three, \(v,v_y\), and first derivatives
of \(Gv^2\) and \(B\). The high differentiations and the Sobolev
cutoffs remain in physical coordinates throughout.

## 8. Exact and formal evidence, and what remains

Jacobian discovery returned no typed PDE-estimate operation. The inspected
operation `polynomial.sos.decomposition.check` was used only for the
square-completion polynomial in (7), not as a substitute for the analytic
theorem. `jacobian_payload.json` is the exact typed request;
`jacobian_result.json` preserves the full response, protocol, server
version, operation id, output, and runtime. It reports an exact coefficient
identity, not a PDE verdict. Discovery and inspection preceded custom
certificate code. The run succeeded; no timeout, transport failure,
incomplete result, or `UNKNOWN` is treated as mathematical evidence.

`verify.py` is a deterministic symbolic checker, not a finite numerical
scan. It verifies (1)--(3), the square-completion identity, (17), the
original-coordinate operator conversion, (22), the finite-type tangential
identity, and the all-\(l\ge8\) derivative-count inequalities. It checks
the archived Jacobian response against its exact request.
`exact_certificate.json` records those outputs and the explicit division
between analytic proof and machine-checked algebra.

The associated `Main.lean` declares and proves the normalized multiplier
identities, square completion, quantitative quadratic coercivity, the
scaled Young inequality, (22), and the derivative-count bounds.
`statement_fidelity.md` gives their exact quantifiers and exclusions.
Only a successful fresh claim-linked `lean_evidence verify` run counts as
formal evidence. Its generated certificate and compiler log, not this
paragraph, determine that status.

A real compiler run has now succeeded with Lean 4.31.0,
`exit_code=0`, `audit_exit_code=0`, and `proof_holes=[]`.
The ledger derives `closed_kernel` for **C_CAP_ALGEBRA only**.
The archived record is
`certificates/C_CAP_ALGEBRA-27a6e833cfbb4d3f.json`;
`lean_verification.json` contains the actual compiler result and
statement-fidelity binding. Neither source nor fidelity document was
edited during or after that run.
Six separate negative controls rejected a false adapter verdict, an
inexact method, a wrong operation, a changed payload, a wrong exact sum,
and an adapter timeout. They test the certificate reader, not the PDE.

Compared with the initial empty audit decomposition, this supplies a
complete independent cap proof, explicit artificial-edge and uniformity
arguments, the bounded remainder (22), and the structural extensions
above. It does not shorten the separate open pulse/assembly obligations.
An independent Reviewer must read the analytic proof, replay the exact
checker and formal certificate, and assess statement fidelity,
significance and novelty before campaign acceptance.
