# Differentiated conformal errors in the Chen--Hou transport norms

## Result and scope

This note proves uniform differentiated remainder estimates and their
linear, bilinear, and transport-weight bounds in the functionals of
Chen--Hou (5.4), (5.25), (5.32), (6.74)--(6.79), and (6.83).
It uses the actual global zero-flux inverse, not a local replacement.
The previously reviewed scalar inverse and full-profile mode results in
`conformal_reduction.md` are not reproved.

The important distinction is between a weighted norm of a Hessian
alone and its norm **after multiplication by the transported field**.
The latter is needed in (A.10). The exponent
\(\alpha=1/3+10^{-8}\) in the actual growing scalar-gradient weight
controls the potentially largest Holder product exactly; see (22).
No derivative of an evolving vorticity or scalar-gradient perturbation
is assumed bounded independently of its stated norm.

These are author proofs awaiting independent review. This note does not
assert that every row of the complete stability comparison, the
separate finite-mode inequalities, or the Euler blowup consequence has
been closed.

## 1. Objects, quantifiers, and the actual norms

Write \(z=(x,y)\), \(r=|z|\), \(Q=\{x>0,y>0\}\).
The physical cylindrical radius remains \(R\), as in (M2).
Take
\[
 0<|\kappa|\leq1/10,\quad \nu\geq4,\quad S\geq\nu,\quad
 0<\delta:=\ell(1+S)<2^{-11}.
 \tag{1}
\]
The estimates also hold at \(\kappa=0\). Constants below depend only
on the fixed cutoff and the displayed weights, not on
\(\kappa,\ell,S,\nu\).
For the small-support cases \(1\leq S<4\), take \(S'=4,\nu=4\):
\(\ell(1+S')\leq(5/2)\ell(1+S)\). Thus the fixed-time operator
estimates also cover those cases under
\(\ell(1+S)<2^{-13}\), with a changed universal constant.
This padding is not used to change the physical support of the data.

Let
\[
 \omega=p\,x\chi+q\,xy\chi+f,\qquad
 M=|p|+|q|+N_1(f),\qquad \operatorname{supp}\omega,
                   \operatorname{supp}f\subset\{r\leq S\},
 \tag{2}
\]
with smooth odd-in-\(x\) sources. Here \(\chi\) and \(N_1=X_1\)
are the cutoff and sum norm in the reviewed scalar theorem.
Let \(h\) be its actual global physical inverse, \(a=h_{xy}(0)\),
and \(H\) the **full-profile** correction (8) of that theorem:
\[
 H=\chi_Rh+b_4xy^3\chi,\quad
 b_4=(2\kappa-3/2)\ell p/6-\ell^2a/8 .
 \tag{3}
\]
In particular \(p\) is not set to zero.

For clarity, the additional weights used here are specified completely.
Put \(\beta=1/16\), \(\alpha=1/3+10^{-8}\), and
\[
 b_j=\frac{917}{1000}
       \left(\frac{42}{100},\frac{144}{1000},\frac{198}{1000},
                    \frac{172}{1000},\frac{383}{10000}\right)_j,
 \quad
 c_j=\left(\frac52,2,\frac{19}5,\frac{171}{100},
                                      \frac{239}{100}\right)_j b_j.
 \tag{4}
\]
Then
\[
\begin{split}
 \varphi_2&=|x|^{-1/2}
       (b_1r^{-5/2}+b_2r^{-3/2}+b_3r^{-1/6})
                         +b_4^{\,w}r^{-1/4}+b_5r^{1/7},\\
 \varphi_3&=|x|^{-1/2}
       (c_1r^{-5/2}+c_2r^{-3/2}+c_3r^{-1/6})
                         +c_4r^{-1/4}+c_5r^{1/7},\\
 \varphi_{g,2}&=\varphi_2+\frac7{100}r^{1/4}
                                  +\frac1{500}r^\alpha,\\
 \varphi_{g,3}&=\varphi_3+\frac{77}{500}r^{1/4}
                                  +\frac{11}{2500}r^\alpha .
\end{split}                                                    \tag{5}
\]
Here \(b_4^{\,w}\) denotes the fourth weight coefficient from (4),
not the stream coefficient \(b_4\) in (3).
For \(r\geq\nu/2\), replace \(\varphi_3,\varphi_{g,3}\) by
\(c_5r^{1/7},(11/2500)r^\alpha\), respectively. Denote the
resulting weights by \(\varphi_{3,m},\varphi_{g,3,m}\).

The Holder weights and angular kernels are
\[
\begin{split}
 \psi_2=\psi_3&=\frac{23}{50}r^{-5/2}+\frac{49}{200}r^{-1}
                       +\frac3{10}r^{-1/2}+\frac{14}{125}r^{1/6},\\
 g_i(h)&=g_{i0}(h)/g_{i0}(1,0),\\
 g_{20}(h)=g_{30}(h)
   &=\left(\sqrt{|h_1|+\tfrac7{50}|h_2|}
        +\tfrac{27}{100}\sqrt{|h_2|+\tfrac1{200}|h_1|}\right)^{-1}.
\end{split}                                                    \tag{6}
\]
Use the already recorded \(\varphi_1,\varphi_{g,1},\psi_1,g_1\),
and set \(\varphi_4=|x|^{-1/2}\psi_1\). As in (6.76),
\[
\begin{split}
 N_2(v)&=\|v\varphi_2\|_\infty+\|v\varphi_{g,2}\|_\infty
                                      +[v\psi_2]_{1/2,g_2},\\
 N_3(v)&=\|v\varphi_{3,m}\|_\infty+\|v\varphi_{g,3,m}\|_\infty
                                      +[v\psi_3]_{1/2,g_3},\\
 Y_1(v)&=N_1(v)+\|v\varphi_4\|_\infty .
\end{split}                                                    \tag{7}
\]
The seminorm is \(\sup_{z\ne w}|v(z)-v(w)|g_i(z-w)\) on the
upper half-plane, with the appropriate odd or even \(x\)-extension.
All these kernels are bounded above and below by fixed positive
multiples of \(|z-w|^{-1/2}\); their one-sided logarithmic
derivatives obey \(|h||\nabla\log g_i(h)|\leq C\).

Let \(\eta_1,\xi_1\) be smooth, supported in \(r\leq S\), odd and
even in \(x\), respectively, with finite \(N_2,N_3\). These are
remainders **after** removing the background and evolving finite
Taylor modes. In particular \(\xi_1(0,y)=0\) for \(y<\nu/2\).
This trace follows from finiteness of the inner angular weight;
evenness alone would not give it. Its dynamical propagation is
addressed in Section 6, rather than silently assumed forever.

## 2. Differentiated remainder theorem

Set
\[
 W=(W^1,W^2)=
 \left(U+H_y-2\kappa\ell axy\chi,\
       V-H_x-(\tfrac12-2\kappa)\ell ay^2\chi\right).
 \tag{8}
\]
This is exactly (28c), with the full-profile \(H\).
For taking global seminorms, use
\(\widehat W(z)=\chi(z/(2S))W(z)\).
It agrees with \(W\) throughout the support of every field in (2)
and (7), is supported in \(r\leq4S\), and is defined inside
\(\chi_R=1\). The choice (1) leaves a larger local-estimate
neighborhood inside the same physical wall patch.
This extension concerns a coefficient in the transport equation;
it does not alter the inverse or set its physical exterior to zero.

**Theorem 3.** For every choice in (1)--(2), the following bounds
hold, with \(W\) or \(\widehat W\) as applicable:
\[
\begin{array}{c|c|c|c}
 & |W|&|DW|&[DW]_{1/2;B(z,r/32)\cap\{y\geq0\}}\\ \hline
 0<r\leq1&
 C\ell Mr^3&C\ell Mr^2&C\ell Mr^{3/2}\\
 r\geq1&
 C\ell Mr^{2-\beta}&
 C\ell Mr^{1-\beta}(1+\log r)&C\ell Mr^{7/6}.
\end{array}                                                    \tag{9}
\]
For the extended field the second line is needed only up to \(4S\)
and its transition neighborhoods. In particular,
\[
 \|D\widehat W\|_\infty+
       \sup_{z\ne0}\frac{|\widehat W(z)|}{r}
       +\sup_{x\ne0}\frac{|\widehat W^1(x,y)|}{|x|}
                                             \leq C\delta M .
 \tag{10}
\]
The last component vanishes on \(y=0\), the first on \(x=0\), and
\(\partial_x\widehat W^2\) is odd in \(x\).
Near \(x=0\), the last column of (9) therefore also gives
\[
 |\partial_x\widehat W^2|\leq
 \begin{cases}
 C\ell M|x|^{1/2}r^{3/2},&r\leq1,\\
 C\ell M|x|^{1/2}r^{7/6},&r\geq1,
 \end{cases}\qquad |x|<r/64 .
 \tag{11}
\]
Bounds for larger \(x/r\) follow directly from the middle column.
The factor \(r^{7/6}\) in the local Holder estimate is deliberate:
it is compensated by the actual transported-field weights, not
misstated as a decaying Holder norm of the Hessian alone.

### Proof of Theorem 3

On the physical patch, the already reviewed estimates give
\[
 |h|\leq CM\min(r^2,r^{2-\beta}),\quad
 |\nabla h|\leq CM\min(r,r^{1-\beta}),\quad
 |h-axy|\leq CMr^3\quad(r\leq1).
 \tag{12}
\]
Here the first two minima indicate the corresponding small/large
radius bounds, not a tail asymptotic. The sharper source-free tail
bound from (16) of the scalar proof implies the displayed large
radius bound also outside the source support.
The global comparison at the physical axis and the exterior cutoff
are already part of that proof.

For \(G=-\Delta h=m\omega-\ell^2vh\), on balls of radius comparable
to \(r\) in this patch,
\[
\begin{array}{c|c|c}
 &\|G\|_\infty &[G]_{1/2}\\ \hline
 r\leq1&CMr&CMr^{1/2}\\
 r\geq1&CMr^{-\beta}&CMr^{1/6}.
\end{array}                                                    \tag{13}
\]
Indeed for the \(f\) part,
\[
 [f]_{1/2;B}\leq C
 \left(\sup_B\psi_1^{-1}[f\psi_1]_{1/2;B}
             +\sup_B|f\psi_1|[\psi_1^{-1}]_{1/2;B}\right).
 \tag{14}
\]
At small radius this is at most \(CMr^2\), while the compact
linear profile term has bound \(C|p|r^{1/2}\).
At large radius (14) is at most \(CMr^{1/6}\).
Coefficient differentiation and (12) control the remaining terms;
\(\ell r\) is uniformly small. No input derivative is used.

We spell out the local elliptic estimates involved, so that a
derivative assumption is not hidden in the notation. If
\(-\Delta u=g\) on a radius-\(r\) disk or Dirichlet half-disk,
\(\|g\|_\infty\leq A\), \([g]_{1/2}\leq B\), then on a fixed
smaller concentric disk or half-disk
\[
\begin{split}
 \|D^2u\|_\infty
 &\leq C\left(r^{-2}\|u\|_\infty+
       A\left[1+\log_+\left(r^{1/2}B/A\right)\right]\right),\\
 [D^2u]_{1/2}
 &\leq C\left(r^{-5/2}\|u\|_\infty+
                        r^{-1/2}A+B\right).
\end{split}                                                    \tag{15}
\]
The zero-source case is the harmonic estimate. To prove the first
inequality, subtract the local Newton potential and estimate its
second-derivative kernel by cancellation. At kernel distances
\(t\leq d=\min(r,(A/B)^2)\), integrate \(Bt^{1/2}/t\); from \(d\)
to \(r\), integrate \(2A/t\). The two contributions are bounded
by \(CA\) and the displayed logarithm. The harmonic remainder is
bounded by the differentiated mean-value formula. For the second,
split a kernel difference at the point separation \(d_0\):
the near integral is \(CBd_0^{1/2}\) and the far integral is bounded
by \(CBd_0\int_{d_0}^r t^{-3/2}\,dt\).
The cutoff and harmonic terms have the displayed scaling.
For a half-disk use the Dirichlet image kernel. Subtract the
constant forcing polynomial \(-g(z_0)y^2/2\) at the boundary
center before these cancellation estimates; its Hessian costs
only \(CA\). This removes any spurious logarithm caused by an
odd extension of a nonzero boundary trace.

At \(x=0\) reflect \(h\) and its source oddly. The equation and
the coefficient bounds respect that reflection. At the corner
this reduces to the same Dirichlet half-disk with boundary \(y=0\),
not a smooth odd extension of \(G\) across \(y=0\).
Consequently (12)--(15), applied to \(h-axy\) at small radii,
give
\[
\begin{array}{c|c|c}
 &\text{Hessian value}&\text{local Hessian Holder bound}\\ \hline
 r\leq1&
 |D^2(h-axy)|\leq CMr&CMr^{1/2}\\
 r\geq1&
 |D^2h|\leq CMr^{-\beta}(1+\log r)&CMr^{1/6}.
\end{array}                                                    \tag{16}
\]
For the logarithm, the relevant ratio is at most
\(C r^{2/3+\beta}\); the amplitude in (15) is \(CMr^{-\beta}\).

Write
\[
 L=(\sqrt R\,J)^{-1},\quad
 C_0=\frac{\ell A}{2R^{3/2}J},\quad
 D_0=\frac{\ell B}{2R^{3/2}J}.
\]
The exact remainder formulas on this patch are
\[
\begin{split}
 W^1&=(1-L)h_y+C_0h+b_4\partial_y(xy^3\chi)
                                      -2\kappa\ell axy\chi,\\
 W^2&=(L-1)h_x+D_0h-b_4\partial_x(xy^3\chi)
                         -(\tfrac12-2\kappa)\ell ay^2\chi .
\end{split}                                                    \tag{17}
\]
Here \(1-L=-(1/2-2\kappa)\ell y+O(\ell^2r^2)\),
\(C_0=\ell/2+O(\ell^2r)\), \(D_0=O(\ell^2|x|)\), with the
corresponding differentiated bounds. The degree-two terms cancel
exactly in (17). Substituting \(h=axy+(h-axy)\) and (16) proves
the first line of (9), including its local Holder estimate.
For \(r\geq1\), the largest Holder contribution is
\[
     |1-L|[D^2h]_{1/2}\leq C\ell Mr^{7/6}.
 \tag{18}
\]
All coefficient-difference and first-derivative terms are smaller
by (12), (16), and \(|D^jL|\leq C\ell^j\), \(j=1,2\).
The fixed cutoff terms live in \(1\leq r\leq2\).
Derivatives of the extension cutoff at \(r\asymp S\) have sizes
\(C/S,C/S^2\) and satisfy the same bounds. This proves (9).

Since
\(\sup_{r\geq1}r^{-\beta}(1+\log r)<\infty\) and
\(\ell r\leq4\delta\) on the extension support, (10) follows.
The \(x\)-quotient uses the vanishing trace and the derivative
bound. Parity and the wall trace prove (11) and tangency.

As an independent algebraic check on which jets were subtracted,
the cubic Taylor polynomials of (17) are
\[
\begin{split}
 [W^1]_3={}&(\kappa/4+\kappa^2)\ell^2a x^3\\
 &+\big((\kappa/4-3\kappa^2)\ell^2a
                         -(\kappa+1/2)\ell p\big)xy^2,\\
 [W^2]_3={}&(\kappa/4-\kappa^2)\ell^2a x^2y\\
 &+\big((1/2-3\kappa/4+3\kappa^2)\ell^2a
                              +(2\kappa/3)\ell p\big)y^3 .
\end{split}                                                    \tag{19}
\]
The undetermined quartic harmonic stream jet cancels from these
formulas. Thus the theorem did not impose a profile vanishing
condition to obtain the cubic remainder.

The quadratic velocity modes themselves have Euclidean divergence
\((1-2\kappa)\ell ay\). This is not set to zero: the linear
term of the physical density \(RJ\) is
\((2\kappa-1)\ell y\), whose transport by \((-ax,ay)\)
cancels this divergence in \(\nabla\cdot(RJ(U,V))=0\).
In particular (20) retains \(W^2_y\) independently of \(-W^1_x\);
an unweighted incompressibility identity has not been imposed on
the curved-coordinate error.

## 3. Bilinear differentiated transport: the actual cross weights

**Theorem 4.** For the remainders in (7), define the actual two
matrix products appearing in (6.79):
\[
 P_2=-(\widehat W^1_x\eta_1+\widehat W^2_x\xi_1),\qquad
 P_3=-(\widehat W^1_y\eta_1+\widehat W^2_y\xi_1).
 \tag{20}
\]
Then, uniformly also in the modified-weight parameter \(\nu\),
\[
 N_2(P_2)+N_3(P_3)
       \leq C\delta M\{N_2(\eta_1)+N_3(\xi_1)\}.
 \tag{21}
\]
Thus the Hessian loss does not produce a nonvanishing coefficient
in these nonlinear (A.10) functionals.

**Proof.** Write \(E=N_2(\eta_1)+N_3(\xi_1)\).
Both fields obey
\[
 |v|\leq CE r^3\ (r\leq1),\qquad |v|\leq CE r^{-\alpha}\ (r\geq1).
\]
Also \(\sup|v\psi_i|\leq CE\).
The two unmodified angular weights are comparable by fixed constants,
and the modified third weight is no larger. Three of the four
weighted supremum products in (20) therefore follow from (10).

For the remaining product \(\widehat W^2_x\xi_1\), only
\(r\geq\nu/2\) needs care: there \(\xi_1\) need not vanish at \(x=0\).
The radial terms follow from (10). For \(|x|<r/64\), (11) cancels
the angular singularity and gives, for its largest far-field power,
\[
 |\widehat W^2_x\xi_1|\,|x|^{-1/2}r^{-1/6}
     \leq C\ell ME r^{1-\alpha}\leq C\delta ME .
 \tag{22a}
\]
For larger \(|x|\), the ordinary derivative bound in (9) suffices.
The more rapidly decaying angular powers in (5) are smaller.
This verifies the cross-weight estimate instead of treating
\(\xi_1\) as an odd \(X_2\) field.

For the Holder products use the exact equality \(\psi_2=\psi_3\).
On a comparable-radius ball at \(r\geq1\), the product inequality
has two terms. The first is at most \(C\delta ME\) by (10).
The second, by (9), is
\[
 [D\widehat W]_{1/2;B}\sup_B|v\psi_2|
     \leq C\ell ME r^{7/6+1/6-\alpha}
     = C\ell ME r^{\,1-10^{-8}}
     \leq C\delta ME .
 \tag{22}
\]
This is the actual critical exponent calculation. At small radii
the two terms are at most \(C\ell ME r^2\), using
\(|v\psi_2|\leq CE r^{1/2}\) and the first line of (9).
For nonlocal pairs use the value estimate: below radius one,
\(|P_i\psi_i|/r^{1/2}\leq C\ell ME r^2\); above it,
\[
 |P_i\psi_i|/r^{1/2}
 \leq C\ell ME r^{2/3-\beta-\alpha}(1+\log r)
 \leq C\delta ME .
 \tag{23}
\]
Pairs whose separation is less than a fixed fraction of the smaller
radius are covered by the local bounds; for the other pairs both
radii are bounded by a fixed multiple of their separation.
This proves the global seminorm, including pairs across the support
boundary. Equivalence of the explicitly specified \(g_i\) kernels
with the ordinary seminorm proves (21).

## 4. Transport weights and the anisotropic Holder equation

These estimates concern the transport term itself, which (6.79)
retains in the left-hand transport operator; a bound on
\(\widehat W\cdot\nabla\eta_1\) in \(X_2\) is neither assumed nor
needed. That would demand derivatives not supplied by \(E_{4,m}\).

For any of the smooth pieces of
\(\varphi_1,\varphi_{g,1},\varphi_2,\varphi_{g,2},
\varphi_{3,m},\varphi_{g,3,m},\varphi_4\), set
\[
 T_w^{\widehat W}=\widehat W\cdot\nabla\log w.
 \tag{24}
\]
Every such weight is a positive sum of powers
\(|x|^{-1/2}r^b\) and \(r^b\). Its logarithmic derivative is a
convex combination of those of its summands. Therefore
\[
 \|T_w^{\widehat W}\|_\infty\leq C\delta M .
 \tag{25}
\]
The interface of the modified third weight is treated separately
in Section 6; (25) does not differentiate its indicator functions.

For a Holder field \(F_i=v_i\psi_i\), the increment caused by
changing the transport velocity by \(\widehat W\) consists of:
\[
 c_i(z)=\widehat W(z)\cdot\nabla\log\psi_i(z),\qquad
 k_i(z,w)=
 \frac{(\widehat W(z)-\widehat W(w))\cdot\nabla g_i(z-w)}
                                      {g_i(z-w)} .
 \tag{26}
\]
At coordinate kinks one uses the appropriate one-sided derivatives.
Equations (9)--(10) give
\[
 \|c_i\|_\infty+[c_i]_{1/2}+\|k_i\|_\infty\leq C\delta M .
 \tag{27}
\]
In detail \(|\nabla c_i|\leq C\ell Mr\) below radius one and
\(C\ell Mr^{-\beta}(1+\log r)\) above it, including the cutoff
transition. Thus \(\|\nabla c_i\|_\infty\leq C\ell M\).
Interpolation of this Lipschitz bound and (25) proves the Holder
bound; \(k_i\) follows directly from (10) and the logarithmic
derivative bound for \(g_i\). Also
\[
 [c_iF_i]_{1/2,g_i}\leq C\delta M
          \bigl(\|F_i\|_\infty+[F_i]_{1/2,g_i}\bigr).
 \tag{28}
\]
For \(i=1,2,3\), \(\|F_i\|_\infty\leq CN_i(v_i)\) by the displayed
weights, so (28) is a bound by the actual energy components.
The increment equation for \(F_i(z)-F_i(w)\), multiplied by
\(g_i(z-w)\), has exactly \(c_i(z)F_i(z)-c_i(w)F_i(w)\)
and \(k_i(z,w)(F_i(z)-F_i(w))\). Equations (27)--(28) therefore
control the complete extra Holder transport coefficient and
commutator, not only a same-point weight derivative.

## 5. Full-profile linear terms and the vorticity source

This section does not place the background in \(X_1\).
Let \(G_\omega,G_\theta\) be a fixed smooth background plus
smooth compactly supported lifts of the evolving \(p,q,T,d\) modes.
Assume the same parity and wall/trace conditions as above and
\[
\begin{array}{ll}
 |D^jG_\omega|\leq B &(r\leq2,\ 0\leq j\leq3),\\
 |D^{j+1}G_\theta|\leq B &(r\leq2,\ 0\leq j\leq3),\\
 |D^jG_\omega|\leq B r^{-1/3-j} &(r\geq1,\ 0\leq j\leq3),\\
 |D^{j+1}G_\theta|\leq B r^{-2/3-j} &(r\geq1,\ 0\leq j\leq3).
\end{array}                                                    \tag{29}
\]
Their relevant derivatives are supported in \(r\leq S\);
\(G_{\theta,x}(0)=G_{\theta,y}(0)=0\) and
\(G_{\theta,y}(0,y)=0\) for \(y<\nu/2\).
The scalar value at the origin is unrestricted.
These are bounds on a prescribed smooth profile and explicit
finite-dimensional lifts, not extra norms of the evolving
perturbation. The Chen--Hou profile decay
\(\bar\alpha_1\in[-0.343,-0.342]\) is stronger than the powers
used here; the cutoffs in their (6.64)--(6.66), with the accompanying
derivative estimates, preserve these coarse powers.
One can alternatively read (29) as the exact hypotheses of the
following operator estimate, without using that identification.

**Theorem 5.** The linear remainder terms in (6.77) corresponding
to (8) satisfy
\[
\begin{split}
 L_1&=-\widehat W\cdot\nabla G_\omega,\\
 L_2&=-\partial_x(\widehat W\cdot\nabla G_\theta),\qquad
 L_3=-\partial_y(\widehat W\cdot\nabla G_\theta),\\
 Y_1(L_1)+N_2(L_2)+N_3(L_3)&\leq C\delta MB .
\end{split}                                                    \tag{30}
\]
The nonzero profile derivative \(G_{\omega,x}(0)\) and
\(G_{\theta,xx}(0)\) are retained.

**Proof.** Near zero, oddness gives
\(|G_{\omega,y}|\leq B|x|\).
The scalar trace and parity give
\(|\nabla G_\theta|\leq CB|x|\),
\(|G_{\theta,xy}|+|G_{\theta,yy}|\leq CB|x|\).
Equations (9)--(10) therefore give
\[
 |L_i|\leq C\ell MB|x|r^2\quad(i=1,2,3).
 \tag{31}
\]
This bounds all the small-radius supremum weights, including
\(\varphi_4\). For the Holder part of \(L_2,L_3\), expand the
derivative in (30): use the local Holder bound for \(D\widehat W\)
on the \(D\widehat W\,\nabla G_\theta\) terms, and the Lipschitz
bound for \(\widehat W\) on
\(\widehat W D^2G_\theta\). After multiplying by \(\psi_2\),
each local seminorm is at most \(C\ell MB\).
In particular one does not differentiate \(D\widehat W\) again.
For \(L_1\psi_1\), the first derivative already suffices and gives
the stronger local bound \(C\ell MB r^{1/2}\).

For \(r\geq1\), the value bound for the scalar-gradient forcing is
\[
 |L_2|+|L_3|\leq
       C\ell MB r^{1-\beta-2/3}(1+\log r).
 \tag{32}
\]
Multiplication by the radial growing weight \(r^\alpha\) is at
most \(C\delta MB\), because \(\alpha<2/3+\beta\).
For angular weights the only unsupplied trace is the
\(\widehat W^2_xG_{\theta,y}\) term in \(L_2\) outside
\(r=\nu/2\). Equation (11) bounds it by
\(C\ell MB r^{1-2/3}\) after the largest angular weight.
All other terms use the odd trace or the scalar trace, with
\(|G_{\theta,x}|\leq CB\min(r^{-2/3},|x|r^{-5/3})\).
Inside the modified region the trace also supplies this gain
for \(G_{\theta,y}\) and its tangential derivatives.

For the Holder estimate the largest local term is
\[
 [D\widehat W]_{1/2;B}\sup_B|\nabla G_\theta\,\psi_2|
          \leq C\ell MB r^{4/3-2/3}
          =C\ell MB r^{2/3}\leq C\delta MB .
 \tag{33}
\]
The remaining product terms, and the value bound divided by
\(r^{1/2}\), are bounded by
\(C\ell MB r^{-\beta}(1+\log r)\) or a smaller power.
For \(L_1\), the far-field weighted supremum and Holder bounds
follow from \(|\nabla G_\omega|\leq Br^{-4/3}\);
the \(\varphi_4\) estimate has power \(r^{-\beta}\).
The same local/nonlocal pair argument as in Theorem 4 completes
(30).

For the remaining vorticity source put
\[
 A_s=\frac{A}{JR^4},\qquad B_s=\frac{B}{JR^4},\qquad
 \mathcal S(\eta,\xi)=(A_s-1)\eta+B_s\xi .
 \tag{34}
\]
On the support patch,
\[
 |A_s-1|\leq C\ell r,\quad |B_s|\leq C\ell|x|,\quad
 A_s-1=(4-\kappa)\ell y+O(\ell^2r^2),\quad
 B_s=\kappa\ell x+O(\ell^2r^2),
 \tag{35}
\]
with the differentiated versions of these bounds. Then
\[
 Y_1(\mathcal S(\eta_1,\xi_1))
              \leq C\delta\{N_2(\eta_1)+N_3(\xi_1)\},
 \tag{36}
\]
and, writing \(T=G_{\theta,xx}(0)\),
\[
 Y_1\!\left(\mathcal S(G_{\theta,x},G_{\theta,y})
                         -(4-\kappa)\ell T\,xy\chi\right)
                                                   \leq C\delta B .
 \tag{37}
\]
To check (36), near zero the ratio \(\psi_1/\psi_2\) is \(O(r^{1/2})\);
at infinity it is \(O(r^{-1/3})\). Apply the product inequality to
\((A_s-1)(\psi_1/\psi_2)(\eta_1\psi_2)\), and similarly to \(\xi_1\).
The largest far-field coefficient-difference contribution is
\(C\ell E r^{1/3-\alpha}\), which is bounded by \(C\delta E\).
The factor \(B_s=O(\ell|x|)\) cancels the unsupplied far-field
angular trace of \(\xi_1\), including the \(\varphi_4\) term.
The remaining supremum comparisons use the positive summands
of (5). For (37), the subtraction removes the exact degree-two
jet; the residual is \(O(\ell B|x|r^2)\) near zero.
Away from zero, (29), (35), and the same product estimates apply.
The removed mode is already part of the full Euler equation for
\(q\) in (31) of the reviewed mode theorem; it is not placed in
\(X_1\) or declared absent.

The explicit quadratic velocities removed in (8) are also retained.
They have a fixed compact support and coefficients bounded by
\(C\ell M\). Their differentiated products with \(\eta_1,\xi_1\),
and their transport-weight coefficients, have the same bounds
as (21), (25), and (28). Their products with the full profile
have degree-two jets in the \(q,d\) rows. Removing exactly those
jets, as prescribed by the reviewed equations (31), leaves
remainders satisfying (30). This follows by the same product
estimates on \(r\leq2\): the explicit polynomial factors are
smooth, odd/even as required, and the profile Taylor remainder
is bounded by (29). It is not a new profile normalization.

## 6. Trace and interface propagation under the norm bootstrap

The norm bounds above are fixed-time statements. Here is the
dynamical condition needed for the modified third weight; it
does not follow from evenness or from two origin jets.

Suppose on a time interval the full decomposition (2) obeys
\(M(\tau)\leq M_0\), the parameter gate (1) holds, and
\(c_l=2\lambda>0\) is the normalization in the reviewed mode
theorem. The value estimates of the actual inverse give a
constant \(C_v\), independent of the four parameters in (1), with
\[
 |(U,V)(z)|\leq C_vM_0 r^{1-\beta}\quad(r\geq1)
 \tag{38}
\]
through the source patch. Choose
\[
          \nu\geq\max\left(4,\,
                3(C_vM_0/\lambda)^{1/\beta}\right).
 \tag{39}
\]
Then the full rescaled transport velocity \(2\lambda z+(U,V)\)
has radial component at least \(\lambda r>0\) throughout
\(\nu/3\leq r\leq\nu\).

At \(x=0\), reflection gives \(U=U_y=\theta_x=0\).
Consequently \(g(y,\tau)=\theta_y(0,y,\tau)\) obeys exactly
\[
 g_\tau+(2\lambda y+V(0,y))g_y
             =(2c_\omega-V_y(0,y))g .
 \tag{40}
\]
If \(g=0\) initially on \(0\leq y\leq\nu/2\), it stays zero
there: the wall characteristic is tangent and the upper endpoint
is strictly outgoing by (39), so there is no nonzero incoming
boundary value. This proves the trace condition on the bootstrap
interval without assuming a higher derivative bound.

The change from \(\varphi_3,\varphi_{g,3}\) to their smaller
radial weights is a downward jump at \(r=\nu/2\).
Under (39) a characteristic crosses this interface only outward;
the weighted absolute value therefore has no positive jump.
Equivalently, smooth the switch monotonically in the outward
annulus. The extra derivative of the switching function in
the full transport equation is nonpositive and can only improve
the diagonal damping. The bounds above apply to the remaining
smooth pieces with constants independent of that smoothing.
This justifies the use of (25) for the modified-weight maximum
comparison; it does not pretend that a derivative of an indicator
is a bounded small coefficient.

Condition (39) is nonempty and compatible with (1), since \(\ell\)
may be chosen arbitrarily small after \(\nu\) and \(S\) are chosen.
It is a consequence under an explicit norm bootstrap, not a proof
that this bootstrap holds for all time.

## 7. Exact contribution to (A.10), and the remaining closure

The matrices in (20) are exactly the differentiated nonlinear
remainders in (6.79); (30) is the corresponding profile-advection
part of (6.77)/(6.83); (36)--(37) handle the conformal vorticity
source. Equations (25)--(28) control their weighted pointwise
and anisotropic Holder transport contributions.
Their norms cover the \(X_i\), \(\varphi_4\), and Holder portions
of the energy, not an easier substituted isotropic energy.

On a bootstrap in which the source and smooth mode lifts satisfy
\(M\leq C_0(1+E_{\max})\) and \(B\leq C_0(1+E_{\max})\),
these results give, for every **such added row contribution**,
\[
       |\text{weighted added forcing or damping loss}|
           \leq C\delta(1+E_{\max}+E_{\max}^2).
 \tag{41}
\]
The constants absorb the fixed positive energy multipliers
\(\mu_i,\tau_1\). Thus these contributions admit finite uniform
increments to the actual linear, quadratic, and residual
coefficients of (A.10). They tend to zero uniformly as the
physical support parameter \(\delta\) tends to zero,
independently of \(\ell,S,\nu\). If inserted into an already
verified comparison row, their total margin cost at \(E_*\) is
at most \(C\delta(1+E_*+E_*^2)\); their increment to the second,
finite-\(M_{\rm stab}\) inequality is finite as well.

This is not yet a verification of both inequalities of (A.11)
for the **entire augmented system**. In particular, the following
work is not supplied by a row bound for the terms in this note:
the full assembly of the main Poisson-source correction with
the existing coefficient matrix and its exterior-profile
cutoff errors; the exact separate finite-mode comparison
functionals and their strict margins after the evolving mode
lift; and the simultaneous strain and physical-support
bootstraps. The same-strain auxiliary ODE estimate from the
previous note does not discharge those obligations.
No noncylindrical Euler solution with a certified singularity is
claimed here.

Compared with the preceding reviewed result, the advance is
the missing differentiated estimate and its actual weighted
products, including the far-field even \(\xi\) cross term and
the origin/profile distinction. The previous logarithmic
Cartesian inverse obstruction is neither repeated nor
misinterpreted as a conformal transport obstruction.
The conformal route remains active.

## Sources and exact replay

The norm and transport specifications above are from Chen--Hou,
[arXiv:2210.07191v4](https://arxiv.org/abs/2210.07191v4),
(5.4), (5.25), (5.32), (6.72)--(6.79), (6.83), and
Appendix C (C.1), (C.3)--(C.4). The fixed-profile decay used to
identify (29) is their Decay property and the estimates following
(6.81). These statements do not identify their straight-cylinder
theorem as a curved-wall theorem. In particular, (6.69)'s
vanishing statements are for perturbations, not the background.

The analytic inequalities (9)--(41) are the proof, not symbolic
software output. The bounded replay

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python research/curved_wall/conformal_transport.py
```

checks the new cubic remainders (19), their trace/derivative
orders, the quadratic weighted-divergence identity, and the
exact exponent inequalities in the weighted-product arguments.
The dedicated `research/jacobian/conformal-transport-*.json`
files retain the inspected contract, exact payload, and typed
output of the authorized bounded Jacobian operation. Its
divergence calculation certifies only that polynomial identity.
