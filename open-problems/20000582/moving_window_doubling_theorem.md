# Moving difference-window Engel blocks

## Result and exact scope

Let \(E_k\) be the genuine radius-\(R_k=2^k\) word ball in the
reviewed Engel lattice, where \(k\geq 2\).  Put
\[
 \epsilon_k=\frac1k,\qquad s_k=1-\epsilon_k,\qquad
 \delta_k=\frac1{k(k+1)},\qquad \eta_k=\frac{\delta_k}{2},
\]
and, in the order \(r=0,2,3\),
\[
 (a_r)=(1,2,4),\qquad
 (\tau_r)=(1,1/16,1/4),\qquad T_{r,k}=\tau_rR_k^2.
\]
The moving difference window is the finite window
\[
 w_{r,k}(t)=a_rs_kt^{s_k-1}
 \left(1-\left(\frac{t}{T_{r,k}}\right)^{\eta_k}\right)^2
 {\bf 1}_{(0,T_{r,k})}(t).
 \tag{1}
\]
Thus the weight is nonnegative; it is not a signed spectral
subtraction.  The phrase "difference window" below always means (1),
extended by zero outside its displayed interval.

For the reviewed unit heat-derivative vectors \(q_{r,t}\), define
\[
 b_k(g)(r,t)=\sqrt{w_{r,k}(t)}
 \big(\lambda(g)q_{r,t}-q_{r,t}\big)
 \tag{2}
\]
in the direct sum of the three corresponding
\(L_2((0,T_{r,k});L_2(\mathbb E))\) spaces.  Then:

1. \(b_k\) is a well-defined injective Hilbert 1-cocycle on the Engel
   lattice.
2. Its pair metric \(\rho_k(g,h)=\|b_k(h^{-1}g)\|_2\) has the exact
   three-adjacent-power expansion in (8) below.
3. If \(V_k(r,t)=\sqrt{w_{r,k}(t)}q_{r,t}\), the full-vector horizontal
   correlation length, at one fixed threshold independent of \(k\),
   satisfies
   \[
     cR_k\leq M_k\leq R_k
     \tag{3}
   \]
   for a fixed \(c>0\).
4. There is a fixed \(K<\infty\), independent of \(k\), such that the
   genuine finite metric space \((E_k,\rho_k)\), equivalently its
   Hilbert image, is \(K\)-doubling at every intrinsic scale.
5. No scalar normalization makes these metrics uniformly comparable
   to the reviewed single homogeneous Engel gauge
   \[
     G_k(x)=|\pi(x)|^{s_k}
       +\sqrt{1-s_k}\,d_{CC}(e,x)^{s_k}.
     \tag{4}
   \]
   The best comparison distortion is at least \(c\sqrt{k}\).

This is a surviving finite-Hilbert-block candidate.  It proves no
Euclidean rank or distortion obstruction.  A complete all-pair
feasible-EDM analysis is therefore a subsequent obligation, not part
of this doubling gate.

The reviewed facts used here, without rebuilding them, are the Engel
group law and lattice ball-box bounds, the heat-kernel scaling, the
unit normalization and smooth-vector properties of \(q_{r,t}\), and
the trivial translation stabilizer of the \(r=0\) heat vector.  They
are recorded in:

- `research/routes/engel_heat_kernel/engel_heat_kernel_analysis.md`;
- `research/routes/engel_two_layer_notched_orbit/two_layer_notch_boundary.md`.

## Well-definedness, cocycle identity, and injectivity

Write
\[
 \Psi_r(x)=\|\lambda(x)q_{r,1}-q_{r,1}\|_2^2.
\]
The reviewed scaling identity gives
\[
 \|\lambda(x)q_{r,t}-q_{r,t}\|_2^2
   =\Psi_r(\delta_{t^{-1/2}}x).
 \tag{5}
\]
At \(t=0\), the last factor in (5) is at most \(4\), the window factor
in (1) is at most \(1\), and \(t^{s_k-1}\) is integrable because
\(s_k>0\).  At the other endpoint,
\[
 1-(t/T)^{\eta_k}
   =\eta_k(1-t/T)+O((1-t/T)^2),
\]
so the weight vanishes quadratically at \(t=T\).  This verifies both
integration endpoints.  In particular, the finite-energy vector
\(V_k\) is in the displayed Hilbert direct sum.

Let \(\Pi_k(g)\) act fiberwise by \(\lambda(g)\).  Equation (2) is
\(\Pi_k(g)V_k-V_k\), hence
\[
 b_k(gh)=b_k(g)+\Pi_k(g)b_k(h).
 \tag{6}
\]
If \(b_k(g)=0\), then the nonnegative \(r=0\) integral is zero.  Its
weight is strictly positive for almost every \(0<t<T_{0,k}\), so
\(\lambda(g)q_{0,t}=q_{0,t}\) at such a \(t\).  The reviewed trivial
stabilizer of the heat vector gives \(g=e\).  Thus \(b_k\), and every
restriction to \(E_k\), is injective.

## Exact pair integral and the adjacent powers

For \(x=h^{-1}g\), (5) gives the exact all-pair formula
\[
 \rho_k(g,h)^2
 =\sum_{r\in\{0,2,3\}}a_rs_k
   \int_0^{T_{r,k}}t^{s_k-1}
   \left(1-(t/T_{r,k})^{\eta_k}\right)^2
   \Psi_r(\delta_{t^{-1/2}}x)\,dt.
 \tag{7}
\]
Define the truncated homogeneous-power kernel
\[
 {\cal J}_{r,\alpha,T}(x)
  =\int_0^Tt^{\alpha-1}\Psi_r(\delta_{t^{-1/2}}x)\,dt.
\]
Expanding the square in (7), without separating it into signed
Hilbert weights, yields
\[
 \boxed{\begin{aligned}
 \rho_k(g,h)^2=\sum_r a_rs_k\big(&
   {\cal J}_{r,s_k,T_{r,k}}(x)\\
 &-2T_{r,k}^{-\delta_k/2}
   {\cal J}_{r,s_k+\delta_k/2,T_{r,k}}(x)\\
 &+T_{r,k}^{-\delta_k}
   {\cal J}_{r,s_k+\delta_k,T_{r,k}}(x)\big).
 \end{aligned}}
 \tag{8}
\]
These are exactly the three adjacent exponents requested by the
schema.  Notice that
\[
 s_k+\delta_k=1-\frac1{k+1}<1.
\]

The energy \(N_k=\|V_k\|_2^2\) is also exact.  For \(s=s_k\),
\(\eta=\delta_k/2\), and \(T=T_{r,k}\),
\[
 \begin{aligned}
 \int_0^Tt^{s-1}(1-(t/T)^\eta)^2\,dt
 &=T^s\left(\frac1s-\frac2{s+\eta}
                 +\frac1{s+2\eta}\right)\\
 &=T^s\frac{2\eta^2}{s(s+\eta)(s+2\eta)}.
 \end{aligned}
 \tag{9}
\]
With \(\epsilon=1/k\), one has
\[
 \delta_k=\frac{\epsilon^2}{1+\epsilon},\quad
 s+\delta_k=\frac1{1+\epsilon},\quad
 s+\frac{\delta_k}{2}
   =\frac{2-\epsilon^2}{2(1+\epsilon)}.
\]
Consequently,
\[
 \boxed{\quad
 N_k=\frac{\epsilon_k^4}{2-\epsilon_k^2}
       \sum_r a_rT_{r,k}^{s_k}.
 \quad}
 \tag{10}
\]
Since \(R_k^{2s_k}=R_k^2/4\), (10) implies
\[
 c_0\delta_k^2R_k^2\leq N_k
 \leq C_0\delta_k^2R_k^2
 \tag{11}
\]
with fixed positive constants.

## The exact horizontal profile

For the reviewed horizontal generator \(A\),
\(A^m=\delta_{|m|}A\), up to inversion when \(m<0\).  Substituting
\(t=T_{r,k}u\) in (7) gives the exact formula
\[
 \boxed{\quad
 \rho_k(e,A^m)^2
 =\sum_r a_rs_kT_{r,k}^{s_k}
   \int_0^1u^{s_k-1}(1-u^{\eta_k})^2
   \Psi_r\!\left(
     \delta_{\frac{|m|}{\sqrt{T_{r,k}u}}}A
   \right)\,du.
 \quad}
 \tag{12}
\]

There is also an exact limiting profile.  If \(m_k/R_k\to z\in[0,1]\),
dominated convergence in (12) and
\((1-u^{\eta_k})/\eta_k\to-\log u\) give
\[
 \frac{\rho_k(e,A^{m_k})^2}{2N_k}\longrightarrow
 {\cal P}(z):=
 \frac{\displaystyle
   \sum_r a_r\tau_r\int_0^1(\log u)^2
   \Psi_r\!\left(
      \delta_{\frac{z}{\sqrt{\tau_ru}}}A
   \right)\,du}
 {\displaystyle4\sum_r a_r\tau_r}.
 \tag{13}
\]
Here \(\sum_ra_r\tau_r=17/8\).  The function \({\cal P}\) is
continuous, \({\cal P}(0)=0\), and \({\cal P}(z)>0\) for every
\(z>0\).  Formula (13), rather than one sampled value, is the
correlation profile of the full finite-energy vector.

The uniform quantitative form of (12) is
\[
 c_1\delta_k^2m^2
   \left(1+\log\frac{R_k}{m}\right)^3
 \leq \rho_k(e,A^m)^2
 \leq
 C_1\delta_k^2m^2
   \left(1+\log\frac{R_k}{m}\right)^3
 \tag{14}
\]
for every integer \(1\leq m\leq R_k\).  This is proved as part of the
all-direction estimate below.

Define the normalized full-vector correlation
\[
 {\cal C}_k(m)=
 \frac{\operatorname{Re}
   \langle V_k,\Pi_k(A^m)V_k\rangle}{N_k}.
\]
Then
\[
 1-{\cal C}_k(m)=\frac{\rho_k(e,A^m)^2}{2N_k}.
 \tag{15}
\]
Let \(c_*,C_*\) be fixed constants in (11) and (14), and choose once
and for all a number
\[
 0<\theta<
 \frac{c_1}{4C_0}.
\]
Set
\[
 M_k=\min\{1\leq m\leq R_k:
             1-{\cal C}_k(m)\geq\theta\}.
 \tag{16}
\]
At \(m=R_k\), (11), (14), and the choice of \(\theta\) show that the
set in (16) is nonempty.  On the other hand,
\[
 \frac{\rho_k(e,A^m)^2}{2N_k}
 \leq C
 \left(\frac m{R_k}\right)^2
 \left(1+\log\frac{R_k}{m}\right)^3.
 \tag{17}
\]
The right side tends to zero with \(m/R_k\), uniformly in \(k\).
Choose a fixed \(c>0\) making it smaller than \(\theta\) on
\((0,c]\).  Equations (16)-(17) prove (3).  This is a correlation
length for the entire moving-window vector, not for an artificially
selected time band.

## Uniform logarithmic gauge

Normalize a homogeneous Carnot distance \(d=d_{CC}\) so that every
nonidentity lattice point has \(d(e,x)\geq1\).  This changes only fixed
constants.  Write
\[
 p(x)=|\pi(x)|,\qquad
 D_k(x)=\min\{d(e,x),R_k\},\qquad
 L_k(x)=1+\log\frac{R_k}{D_k(x)}.
\]

### Gauge theorem

There are constants \(0<c<C<\infty\), independent of \(k\), such
that every nonidentity difference \(x\in E_k^{-1}E_k\) satisfies
\[
 \boxed{\quad
 c\delta_k^2\big(p(x)^2L_k(x)^3+
                   D_k(x)^2L_k(x)^2\big)
 \leq \rho_k(e,x)^2
 \leq
 C\delta_k^2\big(p(x)^2L_k(x)^3+
                   D_k(x)^2L_k(x)^2\big).
 \quad}
 \tag{18}
\]

The first term is the near-critical horizontal tail.  The second is
the finite-scale Engel shell.  In particular, (18) is an all-pair
statement; it is not inferred from (14) or from pure commutator
layers.

### Orbit-kernel bounds

Only a standard smooth-vector lemma is needed.  On the compact Carnot
unit sphere write \(y\) for a point with \(d(e,y)=1\) and
\(\alpha=|\pi(y)|\).  Smoothness of the three fixed vectors and Taylor
expansion of \(x\mapsto\lambda(x)q_{r,1}\) at the identity give, for
\(u\geq1\),
\[
 \Psi_r(\delta_{u^{-1/2}}y)
 \leq C\left(\frac{\alpha^2}{u}+\frac1{u^2}\right).
 \tag{19}
\]
For \(r=0\), the differential on the first layer is injective.
Indeed, a nonzero first-layer derivative equal to zero would make the
nonzero \(L_2\) heat vector invariant along a noncompact one-parameter
subgroup.  Compactness therefore gives
\[
 \Psi_0(\delta_{u^{-1/2}}y)
 \geq c\frac{\alpha^2}{u}
 \quad\text{when}\quad
 u\geq C\max\{1,\alpha^{-2}\}.
 \tag{20}
\]
The reviewed trivial stabilizer and compactness also give
\[
 \inf_{\substack{d(e,y)=1\\1/2\leq u\leq2}}
 \Psi_0(\delta_{u^{-1/2}}y)>0.
 \tag{21}
\]
Finally, \(0\leq\Psi_r\leq4\).  These four bounds are uniform because
there are only three fixed channels.

### Scalar window calculation

It remains to integrate (19)-(21).  Suppress the index \(k\), put
\(s=1-\epsilon\), \(\eta=\delta/2\), and first assume
\(1\leq d(e,x)\leq R/8\).  Write \(x=\delta_dy\) and
\[
 U_r=\frac{T_r}{d^2},\qquad \ell_r=\log U_r.
\]
Then \(U_r\geq4\) for every channel.  Moreover
\[
 \eta=\frac{\epsilon^2}{2(1+\epsilon)},\qquad
 \epsilon\log R=\log2,
 \tag{22}
\]
so \(\eta\ell_r\) and \(\epsilon\ell_r\) are bounded uniformly.  For
\(0\leq v\leq\ell_r\),
\[
 c\eta v\leq1-e^{-\eta v}\leq\eta v.
 \tag{23}
\]
Changing variables \(t=d^2u\), the part \(0<u<1\) and the fixed shell
\(1/2<u<1\) satisfy
\[
 \begin{aligned}
 \int_0^1u^{-\epsilon}
       (1-(u/U_r)^\eta)^2\,du
 &\leq C\eta^2(1+\ell_r)^2,\\
 \int_{1/2}^1u^{-\epsilon}
       (1-(u/U_r)^\eta)^2\,du
 &\geq c\eta^2(1+\ell_r)^2.
 \end{aligned}
 \tag{24}
\]
For the two Taylor tails in (19),
\[
 \begin{aligned}
 I_1(U_r)&=\int_1^{U_r}u^{-\epsilon-1}
              (1-(u/U_r)^\eta)^2\,du\\
 &=U_r^{-\epsilon}
   \int_0^{\ell_r}e^{\epsilon v}(1-e^{-\eta v})^2\,dv
 \asymp\eta^2(1+\ell_r)^3,\\
 I_2(U_r)&=\int_1^{U_r}u^{-\epsilon-2}
              (1-(u/U_r)^\eta)^2\,du
 \leq C\eta^2(1+\ell_r)^2.
 \end{aligned}
 \tag{25}
\]
The harmless \(1+\ell_r\) notation absorbs the fixed lower bound
\(\ell_r\geq\log4\).  Also
\[
 d^{2s}\asymp d^2,\qquad
 1+\ell_r\asymp1+\log(R/d),
 \tag{26}
\]
uniformly on lattice differences, by (22).

Equations (19), (24)-(26) give the upper bound in (18).  The shell
(21) gives its \(d^2L^2\) lower term.  For the horizontal lower term,
put \(\alpha=p(x)/d\).  If \(\alpha^2L\) is bounded, then
\(p(x)^2L^3\) is already bounded by a fixed multiple of \(d^2L^2\).
Otherwise the lower Taylor range in (20) removes only
\[
 O(\log(1/\alpha))=O(\log L)
\]
from an interval of logarithmic length comparable to \(L\).
Integrating (20) on the remaining fixed fraction of that interval and
using the first identity in (25) gives
\[
 c\eta^2p(x)^2L^3.
\]
This proves both lower terms.

If \(d(e,x)\geq R/8\), then \(x\in E_k^{-1}E_k\) still has
\(d(e,x)\leq C_\Gamma R\).  On
\(t\in[R^2/4,R^2/2]\) the \(r=0\) scaled differences range in one
compact annulus disjoint from the identity.  More explicitly,
\(\delta_{1/R}x\) ranges in
\(\{y:1/8\leq d(e,y)\leq C_\Gamma\}\), and
\(\delta_{u^{-1/2}}y\), \(1/4\leq u\leq1/2\), ranges in another
fixed compact annulus.  The trivial stabilizer used in (21) therefore
gives a strictly positive minimum of \(\Psi_0\) on this larger
annulus.  This compact-annulus bound and (23) give a lower bound
\(c\eta^2R^{2s}\), while
\(\Psi_r\leq4\) and (9) give the matching upper bound.  Since
\(R^{2s}=R^2/4\), this is exactly the clipped part of (18).
The gauge theorem follows.

Taking \(x=A^m\) in (18) proves (14).

## All-scale intrinsic doubling

The scalar factor \(\delta_k\) in (18) does not affect doubling.
Replace \(L_k\) by the uniformly comparable
\[
 \Lambda_R(D)=4+\log(R/D),\qquad 0<D\leq R,
\]
and set
\[
 {\cal N}_R(x)=
 p(x)\Lambda_R(D_R(x))^{3/2}
 +D_R(x)\Lambda_R(D_R(x)).
 \tag{27}
\]
The square root of the right side of (18) is uniformly comparable to
\({\cal N}_R\).

For \(0<D\leq R\), define
\[
 f_R(D)=D\Lambda_R(D),\qquad
 H_R(D)=\frac{D}{\sqrt{\Lambda_R(D)}}.
 \tag{28}
\]
The function \(f_R\) is strictly increasing because
\[
 f_R'(D)=3+\log(R/D)\geq3.
\]
The Engel coordinate box at these two scales is
\[
 Q_R(D)=\left\{
 |x_1|,|x_2|\leq H_R(D),\
 |x_3|\leq D^2,\
 |x_4|\leq D^3
 \right\}.
 \tag{29}
\]

 Let \(0<\gamma\leq\Gamma<\infty\) be fixed comparison constants from
 (18), so that on all relevant lattice differences
\[
  \gamma\delta_k{\cal N}_R(x)
  \leq\rho_k(e,x)
  \leq\Gamma\delta_k{\cal N}_R(x).
  \tag{30}
 \]
 If \({\cal N}_R(x)\leq f_R(D)<f_R(R)=4R\), then the radial term in
 (27) gives \(d(e,x)\leq D\), and
 \[
  p(x)\leq
  \frac{f_R(D)}{\Lambda_R(D)^{3/2}}
  =H_R(D).
  \tag{31}
 \]
 The ordinary Carnot ball-box theorem therefore puts all such \(x\)
 in a fixed coordinate dilate of \(Q_R(D)\).  Conversely, the quotient
 bound \(p(x)\leq C d(e,x)\) and maximization of
\[
  u(4+\log(R/u))^{3/2}
 \]
 on \(0<u\leq D/\sqrt{\Lambda_R(D)}\) show that a relative box with
 \(p\leq H_R(D)\) and \(d\leq D\) has
 \({\cal N}_R\)-radius at most a fixed multiple of \(f_R(D)\).

 These boxes have a uniform product law.  The reviewed Engel
 coordinates satisfy
 \[
  (x*y)_3=x_3+y_3-x_2y_1
 \]
 and the fourth coordinate has only the terms
\[
  x_1y_3,\quad x_3y_1,\quad x_1x_2y_1
\]
 in addition to \(x_4+y_4\).  Since \(H_R(D)\leq D\),
\[
  H_R(D)^2\leq D^2,\qquad
  H_R(D)D^2\leq D^3,\qquad
  H_R(D)^3\leq D^3.
  \tag{32}
 \]
 Thus products and inverses of fixed coordinate dilates at scales
 \((H_R(D),D^2,D^3)\) stay in another fixed dilate.

 Now let \(B=B_{\rho_k}^{E_k}(g_0,r)\) be an intrinsic ball.  If
 \[
  r<\gamma\delta_k f_R(1),
 \]
 then (30) and the normalization of \(d\) show that \(B\) is a
 singleton.  Otherwise put
 \[
  \sigma=\frac{r}{\gamma\delta_k}.
 \]
 There are two remaining cases.

 - If \(\sigma<4R\), let \(D\in[1,R)\) be the unique solution of
   \(f_R(D)=\sigma\), and put \(H=H_R(D)\).  Equations (30)-(31) put
   every translated difference \(g_0^{-1}x\), \(x\in B\), in
   \[
     |x_1|,|x_2|\leq C H,\qquad
     |x_3|\leq CD^2,\qquad |x_4|\leq CD^3.
   \]
 - If \(\sigma\geq4R\), put \(D=R\) and \(H=R\).  The genuine
   word-ball relation \(E_k^{-1}E_k\subseteq B_{\rm word}(e,2R)\)
   and the reviewed lattice ball-box theorem put every translated
   difference in the same displayed box.  This is the separate
   clipped case; it does not infer \(d(e,x)\leq R\) from
   \(D_R(x)=R\).

 Denote the resulting fixed coordinate dilate by \(Q_{\rm big}\).
 An absolute-coordinate subdivision would not suffice: a large
 existing \(x_3\) coordinate and a small new \(x_1\) displacement
 produce an \(x_4\) relative-coordinate term.  Instead fix
 \(0<c_*<1\), to be chosen below, and use the relative box
 \[
  Q_{\rm small}=\left\{
  |x_1|,|x_2|\leq c_*H,\
  |x_3|\leq(c_*D)^2,\
  |x_4|\leq(c_*D)^3
  \right\}.
  \tag{33}
\]
 The product estimates (32), now applied only to relative
 coordinates, give
 \[
  Q_{\rm small}^{-1}Q_{\rm small}
  \ \cup\
  Q_{\rm small}Q_{\rm small}^{-1}
  \subseteq
  \left\{
  \begin{array}{l}
  |x_1|,|x_2|\leq C_1c_*H,\\
  |x_3|\leq(C_1c_*D)^2,\\
  |x_4|\leq(C_1c_*D)^3
  \end{array}
  \right\}.
  \tag{34}
 \]
 For the inner case, every relevant lattice point on the right side
 of (34) satisfies
 \[
  \frac{{\cal N}_R(x)}{\sigma}
  \leq C_2c_*
  \left(1+\frac{\log(1/c_*)+C_2}{\Lambda_R(D)}\right)^{3/2}.
 \]
 For the clipped case the same quotient is at most
 \[
  C_2c_*(1+\log(1/c_*))^{3/2},
 \]
 because \(\sigma\geq4R\).  Since
 \[
  \sup_{L\geq4}
  c_*\left(1+\frac{\log(1/c_*)+C_2}{L}\right)^{3/2}
  \longrightarrow0
  \quad\text{as }c_*\downarrow0,
  \tag{35}
\]
 we may choose \(c_*\), once and independently of \(R,D,k,r\), so
 that (34) has \({\cal N}_R\)-radius at most
 \(\gamma\sigma/(2\Gamma)\).  By (30), its \(\rho_k\)-radius is then
 at most
 \[
  \Gamma\delta_k\frac{\gamma\sigma}{2\Gamma}
  =\frac r2.
  \tag{36}
 \]

 Greedily choose a maximal set \(x_1,\ldots,x_m\in B\) for which the
 measurable left translates
 \((g_0^{-1}x_i)Q_{\rm small}\) are pairwise disjoint.  All these
 translates lie in a fixed dilate of \(Q_{\rm big}\): their translated
 centers lie in \(Q_{\rm big}\), and
 \(Q_{\rm big}Q_{\rm small}\) lies in another fixed dilate by (32).
 Haar measure is Lebesgue measure in the reviewed coordinates, and
 \[
  |Q_{\rm big}|\asymp H^2D^5,\qquad
  |Q_{\rm small}|\asymp c_*^7H^2D^5.
  \tag{37}
 \]
 Disjointness therefore gives
 \[
  m\leq
  \frac{|C_3Q_{\rm big}|}{|Q_{\rm small}|}
  \leq C_4c_*^{-7}=:K,
  \tag{38}
 \]
 where \(K\) is independent of \(k,R,D,r\).

 Maximality says that for every \(x\in B\), the translate
 \((g_0^{-1}x)Q_{\rm small}\) meets some
 \((g_0^{-1}x_i)Q_{\rm small}\).  Hence
 \[
  x_i^{-1}x\in Q_{\rm small}Q_{\rm small}^{-1},
 \]
 which has \(\rho_k\)-radius at most \(r/2\) by (34)-(36).  Thus the
 \(x_i\), which are actual points of \(E_k\), are intrinsic
 half-radius centers covering \(B\).  Every intrinsic ball is
 therefore covered by at most the fixed \(K\) in (38), without
 replacing a genuine word ball by a coordinate box.

## Direct comparison with the reviewed homogeneous gauge

The logarithmic gauge is not a scalar copy of (4).  This can be seen
on exact lattice words, not on coordinate-box substitutes.  For
large \(k\), let \(a=\lfloor R_k/20\rfloor\).  The words
\[
 x_H=A^a,
\]
\[
 x_2=[A^a,B^a][A^{-a},B^{-a}]
       =(0,0,4a^2,0),
 \tag{39}
\]
and
\[
 x_3=[[A^a,B^a],A^a]
       =(0,0,0,-4a^3)
 \tag{40}
\]
all lie in \(E_k\): their displayed word lengths are at most
\(a,8a,10a\), respectively.  The identities (39)-(40) follow
directly from the reviewed polynomial Engel law.  Moreover,
\[
 d(e,x_H)\asymp d(e,x_2)\asymp d(e,x_3)\asymp R_k,
\]
while \(\pi(x_2)=\pi(x_3)=0\).

Equation (18) gives
\[
 \rho_k(e,x_H)\asymp
 \rho_k(e,x_2)\asymp
 \rho_k(e,x_3)\asymp\delta_kR_k.
 \tag{41}
\]
Because \(R_k^{s_k}=R_k/2\), the homogeneous gauge gives
\[
 G_k(x_H)\asymp R_k,\qquad
 G_k(x_2)\asymp G_k(x_3)\asymp\frac{R_k}{\sqrt{k}}.
 \tag{42}
\]
Therefore
\[
 \frac{\rho_k(e,x_H)}{G_k(x_H)}\asymp k^{-2},
 \qquad
 \frac{\rho_k(e,x_j)}{G_k(x_j)}\asymp k^{-3/2}
 \quad(j=2,3).
 \tag{43}
\]
The ratio of the two normalization requirements is
\(\asymp\sqrt{k}\).  Thus no scalar normalization yields a uniform
comparison with (4), and the reviewed single-gauge Ryoo compression
cannot be transferred to this family by the prior gauge-comparison
argument.  This statement does not exclude a different
fixed-dimensional complete all-pair map.

## Jacobian boundary

The exact scalar identity in (9) was also reduced to the canonical
rational function
\[
 \frac{\epsilon^4}
 {(1-\epsilon)(2-\epsilon^2)}.
\]
After bounded discovery and inspection of the typed contract,
Jacobian operation
`rational_function.hermite_reduction.compute` accepted that exact
function over \(\mathbb Q(\epsilon)\).  Its complete payload and typed
output are in `jacobian/run_record.json`.  The operation had no
adapter error, operation error, timeout, domain failure, or incomplete
output.  It is an ancillary exact check of the scalar coefficient;
the analytic gauge and doubling theorem do not rely on it.
