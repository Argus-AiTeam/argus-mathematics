# Exact-rate chamber comparison

## Statement under audit

The source is OpenAI, *A positive resolution of De Giorgi's conjecture in
dimension eight*, September 26, 2026, staged locally under
`research/openai_manuscript/De-Giorgis-conjecture-in-dimension-eight-September-26-2026/`.
The immediate target is `build/sections/04-interface.tex`, Proposition
`prop:interface-exact-comparison`, equation `eq:L9` (lines 657-665).

Let \(v\) be the manuscript's bounded entire stable solution of
\(\Delta v=v^3-v\) in \(\mathbb R^7\). Write
\(g(s)=\tanh(s/\sqrt2)\), \(U=\sqrt2\,\operatorname{arctanh}v\),
\(D=1-|\nabla U|^2\), and \(\Sigma=\{v=0\}\).
The penalty \(\Gamma\), its plateau value \(G_1\), and the dimension are fixed.
For \(0<\delta\le1/4\), set \(X=\{z\in\Sigma:D(z)\ge\delta\}\),
\(\bar a=1\) on \(X\) and \(\bar a=|A|\) elsewhere, and
\[
 J_0(0)=\sup_{y\in\Sigma}e^{-\lambda|y|}\bar a(y)^2,\quad
 E(0)=e^{-\sqrt2 d(0)/G_1},\quad
 B=J_0(0)+E(0),\quad P_0=A_0\log(1/B).
\]
Normalize the base zero to \(0\) with normal \(e_n\).
In the manuscript's small-adjacent-intercept case, \(\ell\) is the
shortest distance from \(0\) to the adjacent graph, not its vertical
intercept. Its tangent plane at a minimizing foot is
\(n'\cdot x=\ell\), with \(n'\) close to \(e_n\).
The artificial solution \(v_+^*\) is the small perturbation of \(g(t)\)
above the very same extended base graph \(x_n=h(y)\), with zero trace.

The requested conclusion, with constants independent of \(\delta\), \(B\),
and the solution, is
\[
 |\partial_n(v-v_+^*)(0)|
 \le C\bigl(e^{-\sqrt2\ell}+e^{-cP_0}\bigr).
\]
Without a small adjacent intercept the conclusion is \(Ce^{-cP_0}\).
The constants \(c,C\) must be fixed before \(A_0\), then \(\lambda\),
then the small upper threshold for \(B\).

## Scope and completion bar

A symbolic identity, finite experiment, conditional comparison theorem, and
verification of (L9) for the actual manuscript objects are distinct results.
A calculation using arbitrary surface jets or an unstable solution is not a
counterexample to the manuscript's stable-solution assertion. Verifying this
comparison does not verify stable rigidity or De Giorgi's conjecture.

The comparison depends on the ordered-sheet geometry in Step 1, the common
base-graph extension and artificial-solution construction in Step 3, and the
classical gradient bound. These dependencies are recorded as assumptions, not
silently treated as certified results. The intended calculation separates the
shifted one-dimensional identity, tilted Euclidean operator, lower bound on
the difference potential, boundary comparison, and boundary-slope transfer.

The local source references are:

* `04-interface.tex`, lines 459-532: ordered graphs, gap, and buffers.
* `04-interface.tex`, lines 575-655: graph extension and artificial solutions.
* `03-reach.tex`, Lemma `lem:reach-half-line-barrier`: positive comparison
  function.
* `03-reach.tex`, Lemma `lem:reach-phase-ball`: fixed-depth tangent-ball limit.
* `00-classical.tex`: classical gradient bound.

These are references to the staged unpublished manuscript, not externally
checked literature assumptions. No novelty or publication-level significance
is asserted before independent mathematical review.

## Result and its exact logical strength

The analytic implication needed in Step 4 is valid: a uniformly small,
exponentially decaying loss of potential and a sufficiently small fixed tilt
can be absorbed without changing the exponent \(\sqrt2\). The theorem below
proves that implication, including all comparison boundaries and the transfer
to a boundary derivative. Its algebraic core and explicit uniform constants
have an exact, offline-replayable certificate.

This is **not** an unconditional certification of the actual manuscript's
(L9). The ledger retains the ordered-sheet geometry, the actual artificial
solution construction, and the classical gradient bound as upstream
assumptions. The proof below derives the middle-chamber estimate, the potential
bound, and the comparison from precisely stated inputs; it does not certify
those two constructions by quoting their conclusions back to themselves.
No literal manuscript assertion has been refuted. In particular, a valid
conditional comparison is not a counterexample, a proof of the whole
manuscript, or a novelty certificate.

## 1. Uniform exact-rate transfer theorem

Write \(x=(y,s)\in\mathbb R^6\times\mathbb R\),
\(a=\sqrt2\), \(V_g(s)=3\tanh^2(s/\sqrt2)-1\), and
\(s_*=-\log(2)/a\). Fix \(0<\gamma<a\). There are positive constants
\(\eta_*,\tau_*,C\), depending on this fixed \(\gamma\) but not on the
chamber height, with the following property.

Let \(\ell>0\), \(P>0\), \(R>2\), let \(n'\) be a unit vector,
and set \(c'=n'\cdot e_n\) and
\[
 t_2=\ell-n'\cdot x,\qquad
 \Omega=\{|y|_\infty<R,\ h(y)<s<t_2\}.
\]
Assume:

1. \(h\) is \(C^2\) on the box, \(h(0)=0\), \(\nabla h(0)=0\),
   \(h\ge s_*\), and
   \(\|D^2h\|_{\mathrm{op}}\le1\) near the unit ball.
   The top and lateral boundaries are outside \(B_2(0)\).
2. \(u\) is \(C^2\) inside and \(C^1\) up to the base near \(0\),
   continuous on the remaining boundary, and
   \((-\Delta+V)u=0\). Its trace is zero on \(s=h(y)\).
3. Throughout \(\Omega\),
   \[
   V\ge-2,\qquad
   V\ge V_g(s)-\eta e^{-\gamma s},\qquad
   0\le\eta\le\eta_*,\qquad |1-c'|\le\tau_*.
   \]
4. On the lateral boundary \(|u|\le M\). On the midpoint \(s=t_2\),
   \[
   |u|\le M\bigl(e^{-as}+e^{-bP}\bigr)
   \]
   for fixed \(M,b>0\). Here \(R=rP\), with fixed \(r>0\).

Then
\[
 |\partial_su(0)|\le C M
 \left(e^{-a\ell}+e^{-cP}\right),\qquad
 c=\min(b,r/2048)>0.
 \tag{T}
\]
The constant also depends on the fixed dimension and the local normalization,
not on \(\ell,P,\eta\), or the particular solution.

There is a second version. Replace the midpoint by the horizontal top \(s=H\),
assume \(|u|\le M\) there, and let \(H=qP\), \(q>0\) fixed. There is then no
exact-rate term:
\[
 |\partial_su(0)|\le C M e^{-\min(r,q)P/2048}.
 \tag{T0}
\]
No upper bound on \(V\) is needed in this theorem.

### 1.1 Positive scalar barriers with uniform bounds

Put \(G=g'\), and, for \(s\ge s_*\), define
\[
 \begin{split}
 Y(s)&=G(s)\left(1+\int_{s_*}^sG(t)^{-2}\,dt\right),\\
 v_0(s)&=G(s)\left(1+\int_{s_*}^sG(t)^{-2}(1-g(t))\,dt\right).
 \end{split}
 \tag{1}
\]
Since \(G''=V_gG\), differentiation gives
\[
 (-\partial_s^2+V_g)Y=0,\qquad
 (-\partial_s^2+V_g)v_0=1.
 \tag{2}
\]
Both functions are strictly positive. To avoid a compactness or sampled
positivity argument, write \(z=e^{-as}\), so \(0<z\le2\). Then
\[
 G=\frac{2az}{(1+z)^2},\qquad 1-g=\frac{2z}{1+z},
 \qquad
 \frac{2a}{9}e^{-as}\le G\le2ae^{-as},\quad
 \frac23e^{-as}\le1-g\le2e^{-as}.
 \tag{3}
\]
The only denominator bound here is
\(9-(1+z)^2=(2-z)(4+z)\ge0\). These inequalities are uniform on the
whole half-line, not a finite grid.

Integrating the two exponential bounds for \(G^{-2}\) in (1) gives
\[
 m:=\frac1{72}\le\psi(s):=e^{-as}Y(s)\le32=:M_Y.
 \tag{4}
\]
For example, the lower bound is
\[
 \frac{2a}{9}\left[
 e^{-2as}+\frac{1-e^{-2a(s-s_*)}}{16a}\right]\ge\frac1{72};
 \]
set \(r=e^{-2a(s-s_*)}\in[0,1]\), use \(e^{-2as_*}=4\), and
minimize the resulting affine function of \(r\).
The upper bound is at most \(8a+81/8<32\).
Likewise,
\[
 \frac1{54}\le v_0\le64,\qquad |v_0'|\le128.
 \tag{5}
\]
For the lower bound replace the bracket by
\(e^{-as}+(1-e^{-a(s-s_*)})/(12a)\).
For the upper bound use \(4a+81/2<64\).
Finally
\[
 v_0'=(G'/G)v_0+(1-g)/G,\qquad
 |G'/G|\le a,\quad (1-g)/G=a/(1+g)\le3a/2,
 \]
which proves the stated derivative bound.

Here is also a quantitative derivative bound for \(\psi\).
Equation (2) implies
\[
 (e^{2as}\psi')'=-3e^{2as}(1-g^2)\psi.
 \]
At \(s_*\), formula (1) gives
\(|\psi'(s_*)|\le16\).
Use \(1-g^2\le4e^{-as}\), (4), and integrate this equation. For every
\(0<\gamma<a\),
\[
 |\psi'(s)|\le1024e^{-\gamma s}.
 \tag{6}
\]
Indeed, the initial term is at most \(32e^{-\gamma s}\) and the
integral term at most \(24M_Ye^{-\gamma s}\); their sum is \(800\),
strictly below \(1024\). These deliberately generous constants avoid any
asymptotic-only estimate.

### 1.2 The shifted identity and the tilt

Set
\[
 Q=(M_Y/m)^2=5308416,\qquad K_0=1+2Q/\gamma,
 \]
and define
\[
 k(s_*)=K_0,\qquad
 k'(s)=-Y(s)^{-2}\int_{s_*}^sY(t)^2e^{-\gamma t}\,dt,\qquad
 \phi(s)=e^{-as}Y(s)k(s).
 \tag{7}
\]
Equations (4) and \(2a-\gamma>a>1\) imply
\[
 |k'(s)|\le Qe^{-\gamma s},\quad
 \int_{s_*}^\infty|k'|\le2Q/\gamma,\quad 1\le k\le K_0.
 \]
Consequently, with
\[
 F=32K_0,\qquad D_\phi=1024K_0+32Q,
 \]
we have
\[
 m\le\phi\le F,\qquad |\phi'|\le D_\phi e^{-\gamma s}.
 \tag{8}
\]
Differentiating \(Y^2k'\) gives, with the sign as printed in the
manuscript,
\[
 -\phi''-2a\phi'+(V_g-2)\phi
   =e^{-as}Y(s)e^{-\gamma s}
   =\psi(s)e^{-\gamma s}\ge m e^{-\gamma s}.
 \tag{9}
\]
In particular, the negative sign in front of \(2a\phi'\) is essential.

The exact Euclidean calculation, using \(|n'|=1\), is
\[
 (-\Delta+V)\bigl(e^{-at_2}\phi(s)\bigr)
 =e^{-at_2}\left[-\phi''-2ac'\phi'+(V-2)\phi\right].
 \tag{10}
\]
There is no flattening-coordinate approximation in (10). The cross term is
negative because \(\nabla t_2=-n'\).
Subtracting (9), the unfavorable errors are bounded by
\[
 \left(2a|1-c'|D_\phi+\eta F\right)e^{-\gamma s}.
 \]
Thus the explicit choices
\[
 \tau_*=\frac{m}{12D_\phi},\qquad
 \eta_*=\min\left(\frac1{256},\frac{m}{4F}\right)
 \tag{11}
\]
leave a residual at least \((m/2)e^{-\gamma s}\), because \(2a<3\).
This proves that the exact \(e^{-\sqrt2t_2}\) barrier is a supersolution.
Neither error has been divided by \(e^{-a\ell}\).

### 1.3 Coarse faces and the maximum principle

The same hypotheses imply
\[
 (-\Delta+V)v_0
 \ge1-\eta e^{-\gamma s}v_0\ge\frac12,
 \tag{12}
\]
using \(e^{-\gamma s}\le2\), (5), and (11).
For any inward affine unit distance \(l\), direct differentiation gives
\[
 (-\Delta+V)(v_0(s)e^{-dl})
 =e^{-dl}\left[
 1+(V-V_g)v_0+2d(\partial_sl)v_0'-d^2v_0\right].
 \tag{13}
\]
Take \(d=1/2048\). The bracket is at least
\[
 \frac12-256d-64d^2>\frac14.
 \tag{14}
\]
Hence every coarse face barrier is a supersolution, including horizontal
top faces; a constant multiple \(e^{-bP}v_0\) is one as well.

For (T), use a sufficiently large, fixed multiple of
\[
 W=e^{-at_2}\phi(s)
   +e^{-bP}v_0(s)
   +v_0(s)\sum_{j=1}^6
     \left(e^{-d(R-y_j)}+e^{-d(R+y_j)}\right).
 \tag{15}
\]
On a lateral face the corresponding summand is \(v_0\ge1/54\).
On the midpoint, \(s=t_2\) and \(\phi\ge m\), so the first two
terms dominate the prescribed data. On the base \(u=0\) and \(W>0\).
This checks every face, including their intersections.

Comparison is valid even if \(V\) is negative. Division by \(v_0\)
conjugates the operator to
\[
 -\Delta-2\nabla\log v_0\cdot\nabla
       +\frac{(-\Delta+V)v_0}{v_0},
 \]
whose last coefficient is strictly positive by (12).
The elementary maximum principle on the bounded domain applies to
both \(u-W\) and \(-u-W\).
In \(B_1(0)\cap\Omega\), \(|n'\cdot x|\le1\) and
\(R\pm y_j\ge R-1\); (15) therefore gives
\[
 \sup_{B_1\cap\Omega}|u|
 \le C M(e^{-a\ell}+e^{-dR}+e^{-bP}).
 \tag{16}
\]
For (T0), omit the first two terms of (15) and add
\(v_0(s)e^{-d(H-s)}\). Its trace controls the horizontal top.

### 1.4 Explicit boundary-gradient transfer

No unquantified boundary Schauder constant is necessary. Let
\(r_0=1/2\), \(z_0=-r_0e_n\), \(K=8(n+1)=64\),
\(\rho(x)=|x-z_0|\), and
\[
 \Psi(x)=1-e^{-K(\rho(x)-r_0)}.
 \]
The Hessian bound and the base normalization imply
\(h(y)\ge-|y|^2/2\), whereas the upper hemisphere of
\(B_{r_0}(z_0)\) lies below \(-|y|^2\).
That ball is outside the graph epigraph.
The cap
\[
 \mathcal D=\Omega\cap B_{r_0+1/K}(z_0)
 \]
is contained in \(B_1(0)\). For instance \(|y|\le9/16\) and
\(-81/512\le s\le1/16\) in the cap.
It has only a base boundary and an outer spherical boundary.

In the cap, \(r_0\le\rho\le r_0+1/K\) and \(V\ge-2\). Since
\(e^{-1}>1/3\),
\[
 (-\Delta+V)\Psi
 \ge\frac{K^2-2K(n-1)}3-2
 =\frac{3322}{3}>0.
 \tag{17}
\]
Write \(M_1=\sup_{B_1\cap\Omega}|u|\).
On the outer sphere, \(2M_1\Psi\ge M_1\), since \(e>2\).
On the base, \(\pm u=0\le2M_1\Psi\).
The same divided maximum principle gives \(|u|\le2M_1\Psi\).
Along the inward vertical ray at \(0\), \(\partial_s\Psi(0)=K\).
Therefore
\[
 |\partial_su(0)|\le128M_1.
 \tag{18}
\]
Combining (16) and (18) proves (T), and proves (T0) with the other
barrier. This also explains precisely why an estimate of the function
near the base, rather than a nonzero boundary trace of the global
supersolution, suffices.

## 2. Deriving the analytic inputs in the actual chamber

This section assumes `UP_GEOMETRY`, `UP_ARTIFICIAL`, and `UP_MODICA`
as recorded in the ledger. It does not assume (L9), (L5), or an energy
density bound. It derives the remaining comparison hypotheses.

### 2.1 Phase clearing with an explicit positive rate

Only a fixed subcritical decay rate is needed here.
If \(0<v\le1\) in a ball of large radius \(R\), place the cube of
half-width \(R/(2\sqrt n)\) at its center. The product cosine
Dirichlet eigenfunction \(f\), normalized to one at the center,
satisfies
\(-\Delta f=\lambda f\), \(\lambda=n^2\pi^2/R^2\).
For \(\lambda<3/4\), \(f/2\) is a strict subsolution of
\(\Delta w+w-w^3=0\). Its small multiples lie below \(v\), since
the cube closure is inside the positive phase. Increasing the
multiple to \(1/2\) cannot give a first interior contact, by the
strict differential inequality. Thus \(v\ge1/2\) at any point at
least a fixed distance \(R_*\) from the phase boundary.

For \(w=1-v\), on that inner region
\[
 \Delta w=v(1+v)w\ge(3/4)w.
 \]
At a point at distance \(d>R_*+1\), compare on the cube of
half-width \((d-R_*)/\sqrt n\) with the sum of its \(2n\) inward
exponentials at rate \(\sqrt3/2\). The sum is at least one on
every boundary face and solves \((-\Delta+3/4)W=0\).
This gives
\[
 1-v(x)\le C e^{-c_{\rm cl}d},\qquad
 c_{\rm cl}=\frac{\sqrt3}{2\sqrt n}>0.
 \tag{19}
\]
This argument works for the artificial solution in its positive
epigraph as well. It is not a stability assumption.

### 2.2 The exact-rate middle-chamber bound

Let \(\epsilon_B=o(1)\) bound the signed affine errors of the base
and adjacent graphs on the wider buffered box. Use its \(k=14\)
inward unit affine distances: \(s-\epsilon_B\),
\(t_2-\epsilon_B\), and its twelve lateral face distances.
Their positive intersection is inside the true positive phase and
the artificial epigraph. In the smaller polytope \(l_j\ge M_*\),
(19) makes both deficits \(w=1-v\), \(1-v_+^*\) uniformly small.
Each satisfies
\[
 (-\Delta+2)w=3w^2-w^3.
 \]
Choose \(\eta_0>0\) with \(k\eta_0<1/8\), then choose \(M_*\)
large enough that clearing gives \(w\le\eta_0/2\) on this whole
inner polytope. Set
\[
 r_j=\eta_0 e^{-a(l_j-M_*)},\qquad
 \mathcal W=\sum_j(r_j-k r_j^2).
 \]
Every summand is nonnegative, and on a boundary face
\(\mathcal W\ge\eta_0-k\eta_0^2\ge\eta_0/2\).
The exact identities are
\[
 (-\Delta+2)\mathcal W=6k\sum_jr_j^2,\qquad
 k\sum_jr_j^2-\left(\sum_jr_j\right)^2
   =\sum_{i<j}(r_i-r_j)^2.
 \tag{20}
\]
Thus \((-\Delta+2)\mathcal W\ge3\mathcal W^2\).
For the difference \(w-\mathcal W\), the zeroth coefficient
\(2-3(w+\mathcal W)\) is positive. Comparison gives
\(w\le\mathcal W\le\sum_jr_j\).
At the midpoint in the central box the lateral distances are at least
a fixed positive multiple of \(P_0\), and
\(e^{a\epsilon_B}\) is uniformly bounded. Consequently
\[
 1-v,\ 1-v_+^*\le
 C\left(e^{-as}+e^{-at_2}+e^{-c_mP_0}\right)
 \tag{21}
\]
there, with \(c_m>0\) fixed after the box fractions.
All constants are uniform in \(B\) and \(\delta\).

### 2.3 Fixed-depth convergence without the strong phase-ball lemma

Only the elementary fixed-depth portion of the manuscript's
`reach-phase-ball` lemma is needed, not its improved mean-curvature
conclusion. It can be rederived as follows.
For \(s\ge0\) put
\[
 w_1(s)=G(s)\int_0^sG(t)^{-2}\int_t^\infty G(r)^2\,dr\,dt.
 \]
Then \(w_1(0)=0\), \(L_gw_1=G\), and
\[
 |w_1|+|w_1'|\le C(1+s)G(s).
 \tag{22}
\]
For (22), (3) on \(s\ge0\) bounds
\(G(t)^{-2}\int_t^\infty G^2\) by a constant; differentiate once
and use \(|G'/G|\le a\).

In the annulus of inward depth \(0<s<Q_r=\sqrt r\) in a positive
ball of radius \(r\), set \(z_r=g-C_0w_1/r\).
Its radial equation is
\[
 \mathcal F_r(z)=z''-\frac{n-1}{r-s}z'+z-z^3.
 \]
The linear correction in \(\mathcal F_r(z_r)\) is \(C_0G/r\);
the leading unfavorable drift is \(-(n-1)G/(r-s)\).
Choose \(C_0>2(n-1)+1\). Equation (22) bounds the drift correction
relative to \(G/r\) by \(C(1+\sqrt r)/r=o(1)\).
The quadratic and cubic errors are also \(o(G/r)\), since
\(\sup_{s\ge0}(1+s)^2G(s)<\infty\).
Therefore \(z_r>0\) and \(\mathcal F_r(z_r)>0\) for large \(r\).

Choose fixed \(0<c<c_{\rm cl}\) and multiply by
\(1-e^{-c\sqrt r}\). This preserves the strict subsolution
inequality: for \(0<A<1\),
\(\mathcal F_r(Az)=A\mathcal F_r(z)+(A-A^3)z^3>0\).
Its inner-boundary value is below the true solution by (19);
its outer trace is zero. Sliding the amplitude gives comparison.
The start is justified by positivity on the compact inner annulus
and the Hopf estimate at any outer zero. Boundary obstruction at
first contact is excluded by the strict comparison and Hopf lemma.
Hence, uniformly at bounded inward depths,
\[
 v(x+sN)\ge g(s)-O_T(r^{-1})-e^{-c\sqrt r},
 \qquad 0\le s\le T.
 \tag{23}
\]
`UP_MODICA` gives \(U(x+sN)\le s\) and thus the opposite inequality
\(v(x+sN)\le g(s)\). It follows that \(v\to g\) uniformly on every
fixed depth interval. This proof discharges `UP_PHASE_BALL` for
the limited purpose for which it was recorded.

For the actual graph bases, the geometry permits tangent balls of radius
\[
 r_B=\left[\min\{c_1P_0,H_B,B^{-1/4}\}\right]^{1/2},\qquad
 H_B=\ell\ \text{or}\ c_1P_0.
 \tag{24}
\]
These radii tend uniformly to infinity; \(r_BB^{1/4}\to0\)
keeps the balls above the base, while \(r_B=o(H_B)\) and
\(r_B=o(P_0)\) keep them below the adjacent sheet and inside the
lateral buffer. The vanishing base height and slope and the
Lipschitz bound for \(U\) transfer (23) to the vertical coordinate
\(s\), uniformly over all bases in the smaller box. The artificial
solution has the same fixed-depth convergence by `UP_ARTIFICIAL`.

### 2.4 Uniformly decaying error of the difference potential

The difference \(u=v-v_+^*\) satisfies
\[
 (-\Delta+V_*)u=0,\qquad
 V_*=v^2+vv_+^*+(v_+^*)^2-1\ge-1.
 \tag{25}
\]
This is the actual Euclidean difference equation, with identical
zero traces on the bottom.
On the lower-half chamber \(t_2\ge s\). The geometric buffers give,
at every point with \(s\ge1\), a positive ball of radius
\(c_{\rm ball}s\), where \(c_{\rm ball}>0\) is independent of
the later choice of the angular parameter. The ball remains in
the wider box even for a center on a smaller-box lateral face.
The no-adjacent-sheet case uses the same ball below the larger
empty-chamber height.
By (19),
\[
 (1-v)+(1-v_+^*)\le C e^{-c_3s},\qquad
 c_3=c_{\rm cl}c_{\rm ball}>0.
 \]
For \(s\ge1\), direct algebra now bounds
\[
 |V_*-V_g(s)|
 \le3\bigl((1-v)+(1-v_+^*)\bigr)+12e^{-as}.
 \tag{26}
\]
Choose \(0<\gamma<\min(c_3,a)\), before choosing the angular
parameter, and define the actual weighted error
\[
 \eta(B)=\sup_{\Omega_B}
       e^{\gamma s}\bigl(V_g(s)-V_*(x)\bigr)_+.
 \tag{27}
\]
At bounded depths its supremum tends to zero by the uniform
fixed-depth convergence proved above and `UP_ARTIFICIAL`.
At \(s\ge T\), (26) bounds it by
\(C e^{-(\min(c_3,a)-\gamma)T}\), uniformly in \(B\).
First let \(B\to0\), then \(T\to\infty\). This proves
\(\eta(B)\to0\) and precisely the potential inequality required
by the transfer theorem, without inferring an exact rate from
fixed-depth convergence alone.

### 2.5 Boundary matching and the order of choices

Equation (21) implies the midpoint hypothesis of (T), since
\[
 |v-v_+^*|\le(1-v)+(1-v_+^*),\qquad s=t_2.
 \]
Both solutions lie in \((0,1]\) inside, so their difference is
bounded by one at every lateral or artificial top face.
They vanish on the identical base, as required in (25).
The actual smaller box has \(R=c_2P_0\). Without an adjacent
sheet it has \(H=c_2P_0\). Thus (T) and (T0) yield exactly (L9)
under the retained construction assumptions.

The noncircular order is:

1. Fix the profile, the phase-clearing constant \(c_{\rm cl}\),
   the geometric \(c_{\rm ball}\), and then
   \(0<\gamma<\min(c_3,a)\). Construct \(\phi,v_0\) and (11).
2. Fix the angular parameter small enough that the unit-normal
   tilt meets (11) and the penalty plateau condition. The identity
   \(1-c'=|n'-e_n|^2/2\) makes the required tilt quantitative.
   Fix the proportional box fractions \(c_1,c_2\).
3. The coarse exponent \(c=\min(c_m,c_2/2048)\) is now fixed.
   Choose \(A_0\) large enough for \(cA_0>1\) and the realizing-contact
   argument. Choose \(\lambda\) afterwards so
   \(10\lambda A_0<1/2\) and \(10\lambda<b_0\).
4. Only then make \(B\) small, to enforce (11), the graph bounds,
   and the growing local neighborhoods.

In particular \(e^{-cP_0}=B^{cA_0}\le B\).
The sole use of the defect threshold in the geometric input is that
every zero in the large box is good, hence its gradient is at least
\(\sqrt{3/8}\), since \(\delta\le1/4\). No analytic comparison
constant above depends on \(\delta\).

## 3. An excluded shortcut, not a manuscript refutation

Replacing (27) by a small constant loss of potential cannot prove
the desired exact rate. For any \(0<\epsilon<2\), let
\(\mu=\sqrt{2-\epsilon}<a\) and
\[
 u_L(s)=\frac{\sinh(\mu s)}{\sinh(\mu L)},\quad 0\le s\le L.
 \]
Then \((-\partial_s^2+2-\epsilon)u_L=0\),
\(u_L(0)=0\), \(u_L(L)=1\), and
\[
 u_L'(0)=\frac{\mu}{\sinh(\mu L)}
 =\frac{2\mu e^{-\mu L}}{1-e^{-2\mu L}}.
 \]
Its ratio to \(e^{-aL}\) diverges as \(L\to\infty\).
This is an exact obstruction to the constant-potential-loss route.
It does not satisfy the exponentially decaying error hypothesis of
the theorem and is **not** a counterexample to (L9), to a stable
Allen--Cahn solution, or to a literal manuscript assertion.
The corresponding route is retired with this reason in the ledger.

## 4. What the executable certificate proves

Run, from any working directory:

```text
$WORKSPACE/argus-live-update/.venv/bin/python \
  families/375/first-pass/exact-rate-chamber/verify.py
```

`--write-certificate` regenerates `exact_certificate.json`; without
that option the script recomputes and compares its result with the
saved certificate. SymPy is the only non-standard Python dependency.
There are no random tests, floating-point tolerances, or network
requirements during replay.

The checks cover the profile equations, the homogeneous and forced
reduction-of-order identities, the shifted barrier identity, the
tilted cross term, the fourteen-face Cauchy identity, polynomial
interval factorizations, and strict rational margins for all the
displayed uniform scalar constants. Reversed drift signs are
negative controls, not proposed alternative proofs.

The Jacobian adapter was discovered and its exact typed contract
inspected before custom computation. One bounded operation,
`polynomial.sos.decomposition.check`, returned `is_valid=true`
using `EXACT_COEFFICIENT_IDENTITY`. Its saved payload and typed output
are `jacobian_payload.json` and `jacobian_result.json`, including
server version `0.14.0`, protocol `2025-11-25`, and the operation id.
The adapter exited zero; there was no timeout or structured error.
Its mathematical role is deliberately small: under
\(z=2u^2/(1+u^2)\),
\[
 9(1+u^2)^2-(1+3u^2)^2=8+12u^2
   =2^2+2^2+(2u)^2+(2u)^2+(2u)^2.
 \]
Together with the endpoint \(z=2\), this certifies the denominator
inequality in (3). The verifier independently replays the
coefficient identity and checks the exact request/output binding.
It does not interpret Jacobian's answer as certification of a PDE.

The integration, maximum-principle, geometric, limiting, and
statement-fidelity arguments are mathematical prose for independent
review, not mechanically checked by this Python program. No Lean
file is included: the decisive uncertainty is analytic applicability,
not an algebraic identity for which a second formal encoding would
close the actual manuscript claim.

## 5. Remaining implication and comparison with the prior state

The initial ledger had no evidence for this bridge. The present result
is stronger than finite sign or positivity tests: it proves the full
uniform comparison theorem (T), with explicit whole-half-line bounds,
and derives its analytic hypotheses from the stated construction inputs.
It also eliminates reliance on the *strong* phase-ball lemma for the
fixed-depth limit and rules out the constant-loss shortcut.

What remains for an unconditional judgement on `C_L9` is independent
certification that the actual objects in Steps 1 and 3 supply all of
the simultaneously uniform geometric and artificial-solution inputs
used here. In particular, the wider-box ordered chamber and uniform
tangent-ball containment must be checked for the actual adjacent
sheet, and the same-base artificial solution must be shown to exist
with its stated convergence uniformly in the chosen parameter order.
The classical gradient bound is an explicitly retained known input.
None of these is declared false merely because it remains an input.

The claim `C_EXACT_TRANSFER` names the proved abstract theorem.
`C_L9` stays open/conditional on the retained inputs; the campaign's
stable and monotone rigidity goals also stay open. Independent
Reviewer acceptance, novelty, and publication-level significance
remain unclaimed. This is a reviewable mathematical reduction,
not terminal completion of the continuous counterexample campaign.
