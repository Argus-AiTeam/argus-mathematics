# A uniform outgoing trace theorem with rough channel coupling

## Statement

Let \(0<a_j\le1\), \(|b_j|\le B\),
\(-1/32\le\sigma_j\le4\), \(\omega_j\ge0\), and
\(\ell_j\in\mathbb N_0\). The coefficients \(P_j,\phi_j\) are real on
\([r_b,\infty)\), and, for every fixed \(s\),
\[
 |D^s(P_j/a_j)|\le C_s r^{-2},\qquad
 |D^s e^{2i\phi_j}|\le C_s.                           \tag{1}
\]
All constants are independent of \(j\). Consider exactly the circular equation
`spec:circular` in the staged manuscript, with
\(\lambda_j=\sigma_j+i\omega_j\).
An outgoing solution means that, for every fixed \(s\),
\(D^s v_h=O(r^{-2(a_j+\sigma_j)})\) as \(r\to\infty\), separately
for \(h=+1,-1\). Constants in this definition need not be uniform.

Suppose either
\[
 {\rm I}:\quad\ell_j/\sqrt{1+\omega_j}\longrightarrow\infty ,
 \qquad\hbox{or}\qquad
 {\rm II}:\quad\omega_j\longrightarrow\infty,\quad
 \ell_j/\sqrt{\omega_j}\le M.                         \tag{2}
\]
Fix \(B_0>r_b\), \(B_1=B_0+1\); in II increase \(B_0\), if needed,
so that \(L_{\ell_j}/B_0^2<\omega_j/2\) eventually. Set
\[
\begin{split}
 q_h&=r^{11/2}e^{hi r^2/8}v_h,&
 L_\ell&=(\ell+5)^2-\tfrac14,\\
 F_h&=r^2/16+b-h\omega-L_\ell/r^2,&
 n&=\max(1+\ell,\sqrt\omega),\\
 S&=\max(1+\ell,\omega),&
 E&=16\sqrt S,\\
 B_h(R)&=-\sqrt{-F_h(R)}\quad(F_h(R)<0),&
 B_h(R)&=hi\sqrt{F_h(R)}\quad(F_h(R)>0).
\end{split}
\]

**Theorem.** Under (1)-(2), for all sufficiently late \(j\), evaluation
at every \(R\in[B_0,B_1]\) identifies the two-dimensional outgoing
space with \(\mathbb C^2\). Its derivative is a linear map \(T_j(R)\)
and
\[
 \sup_{B_0\le R\le B_1}
 \frac{\|T_j(R)-\operatorname{diag}(B_+(R),B_-(R))\|}{n_j}
 \longrightarrow0.                                  \tag{3}
\]
There is no selection of outgoing data in this statement and no
subsequence is necessary. It includes sequences \(a_j\to0\), but
does not require that limit once (1) is assumed.

**Rough-coupling extension.** On \([R,E]\) the same conclusion holds
with arbitrary measurable matrix coefficients \(V_{hk}\) in the
gauged equation, provided
\[
 \delta_j=\max_h\sum_k\int_R^E
       \frac{|V_{hk}(t)|}{\sqrt{K_h(t)K_k(t)}}\,dt
       +\frac{\|M_j\|}{E}\longrightarrow0,             \tag{4}
\]
and the right boundary condition is
\(q'_h(E)-hi\sqrt{F_h(E)}q_h(E)=(M_jq(E))_h\).
Here the scalar weights \(K_h\) are defined below. The assertion
extends to any fixed finite number of copies of these scalar channels.
More precisely, if
\[
 \epsilon_j=\sup_{R,h}
 |U'_h(R)/U_h(R)-B_h(R)|/n_j ,
\]
then, for a constant \(C\) independent of \(j,R,V,M_j\),
\[
 \frac{\|T_j(R)-\operatorname{diag}B_h(R)\|}{n_j}
 \le\epsilon_j+\frac{C\delta_j}{1-C\delta_j}
 \quad\hbox{when }C\delta_j<1.                        \tag{5}
\]
In particular (3) is a full matrix operator estimate, not a scalar
asymptotic or a finite-frequency experiment.

## Exact source boundary and prior results

The audited source is the September 24, 2026 staged OpenAI manuscript,
`build/sections/spectrum.tex`: the circular equation is at lines 53-61;
the outgoing definition at 30-33; and the active bridge is at 227-593.
The relevant labels are `spec:remote-data`, `spec:scalar-turn`, and
`spec:boundary-estimate`. The conditional profile input is precisely
the exterior Euler-symbol part of `profile:existence`, especially
`profile:exterior-pressure` in `build/sections/profiles.tex:120-124`.
This proof does not verify existence of those profiles.

The manuscript already asserts the two-channel conclusion after
subselection. The improvement here is an independent proof of the
uniform full-family statement and the explicit rough matrix stability
bound (5), separating exterior symbols from the derivative-free
finite-interval coupling. It is not a new blowup theorem.

The bounded free-root certificates do not address (2). The
finite-count-only route is therefore retired in the claim ledger,
not reused as evidence for (3). The shared Wiki index contained no
relevant outgoing-turning-point result. A targeted external lookup
located no independent correction or proof of this particular bridge;
this is not evidence that none exists. The primary-source background
NIST DLMF Section 2.8 explains Liouville transformations and simple
turns, but no theorem from it is invoked here: the varying shape and
the uniform growing-branch margin are proved below. Thus there is no
unchecked external special-function theorem in this argument.

## 1. Gauge, remote data, and outgoing dimension

Write
\[
 g_h=11/(2r)+hi r/4,\qquad
 p_h=11/r+hi r/2,\qquad v_h=r^{-11/2}e^{-hi r^2/8}q_h .
\]
Then \(p_h-2g_h=0\) and
\[
 b+hi(a+\sigma+i\omega)-\ell(\ell+10)/r^2
       +g_h^2-g_h'-p_hg_h=F_h+hi\gamma,\quad
 \gamma=\sigma+a-3 .
\]
Consequently the exact equation is
\[
 q_h''+(F_h+hi\gamma)q_h=\sum_k V_{hk}q_k,\qquad
 V_{hh}=P(1+1/(2a)),\quad
 V_{h,-h}=(P/(2a))e^{hi(2\phi+r^2/4)}.              \tag{6}
\]
In particular \(|V_{hk}|\le Cr^{-2}\). The rapid off-diagonal phase
in (6) is not an Euler symbol; no derivative of it is used in
Sections 2-4.

For the remote calculation use the *ungauged* coordinates
\((v_h,v'_h/r)\). Their \(D\)-system is
\[
 D Z_h=r^2
 \begin{pmatrix}0&1\\c_h&-hi/2\end{pmatrix}Z_h
 \begin{pmatrix}0&0\\-b-hi(a+\sigma)&-12\end{pmatrix}Z_h
 \text{the original pressure terms},\quad
 c_h=h\omega/r^2+\ell(\ell+10)/r^4.                  \tag{7}
\]
Dividing the second coordinate by \(hi\) makes the leading matrix
\(hi\begin{pmatrix}0&1\\-c_h&-1/2\end{pmatrix}\).
Its real matrix has characteristic polynomial
\(\eta^2+\eta/2+c_h\). Hence its leading eigenvalues are
\[
 hi\left(-\tfrac14\pm
       \sqrt{1/16-h\omega/r^2-\ell(\ell+10)/r^4}\right).
                                                               \tag{8}
\]
For \(r\ge E\) the square root is bounded away from zero, its fixed
Euler derivatives are bounded, and the eigenvector matrices with
first entries one and their inverses have uniform symbol bounds.
For example, eventually \(S\ge\max(8,2B)\),
\(L_\ell\le(9/4)S^2\), and the square-root argument is at least
\[
 1/16-1/256-9/262144=15351/262144>1/32.
 \]
The two plus signs form one outgoing block. Each minus sign is an
incoming block, separated from it and from the other incoming block.
No separation of the two outgoing eigenvalues is assumed. The same
bounds give \(14S<F_h(E)<18S\), so all square roots at \(E\) are real
and positive.

Here are the normal-form details needed for uniformity. In the
diagonal leading coordinates an off-block term \(b_{uv}=O(r^{-s})\)
is eliminated to the next two orders by an entry
\(-r^{-2}b_{uv}/(\Lambda_u-\Lambda_v)\). Its Euler derivative and
products with bounded terms are \(O(r^{-s-2})\). Finite iteration
therefore leaves an \(O_m(r^{-m})\) off-block remainder, with fixed
Euler derivatives, and changes each bounded diagonal-block part by
\(O_m(r^{-2})\).

Choose \(C\) above the Hermitian-part bounds of the initial full
system and its blocks by a fixed margin. Next choose a fixed integer
\(m>2C+4\). Only then take \(j\) sufficiently late that all of this
finite normal form's corrections are smaller than the margin on
\(r\ge E_j\). As the leading diagonal is imaginary, both full and
block propagators obey
\[
 \|\Phi(r,t)\|\le(\max(r,t)/\min(r,t))^C.             \tag{9}
\]
This follows by differentiating the squared Euclidean norm in
\(\log r\), and also applies backwards.

All fixed Euler derivatives of an individual outgoing solution in
these coordinates are \(O(r^\rho)\), where
\(\rho=-2(a+\sigma)\le1/16<1\). In an incoming equation, multiplication
by the inverse of its \(r^2\) leading coefficient improves the
incoming coordinate and each of its fixed Euler derivatives by two
powers, until the \(O_m(r^{-m})\) forcing is reached. More explicitly
the successive exponents are
\(\max(\rho-2k,\rho-m-2)\).
Thus the incoming coordinate is \(O(r^{\rho-m-2})\).
Its terminal term vanishes after backward propagation using (9).
Variation of constants now gives, at \(E\),
\[
 |Z_{\rm in}(E)|\le
 C_m|Z(E)|\int_E^\infty(r/E)^{2C}r^{-m}\,\frac{dr}{r}
 =\frac{C_mE^{-m}}{m-2C}|Z(E)|.                     \tag{10}
\]
Constants in the qualitative outgoing bounds have disappeared from
this quantitative estimate.

The first-entry-one normalization and (10) imply
\(|Z(E)|\le C|v(E)|\). Undoing the transformations in (7), then
undoing the scalar gauge, proves
\[
 q'_h(E)-hi\sqrt{F_h(E)}q_h(E)=(M_jq(E))_h,
 \qquad \|M_j\|\le C/E.                             \tag{11}
\]
Indeed the transformation errors in \(v'/r\) are \(O(E^{-2})|v|\).
The gauge contributes \(11/(2E)\), and replacing the leading
square root by \(\sqrt{F_h(E)}\) changes the slope by \(O(E^{-1})\):
the squared frequencies differ by \(b-99/(4E^2)\).

For completeness the outgoing space has dimension two, not merely
dimension at most two. At any fixed parameter, continue (7) to a
sufficiently late half-line and use the same finite reduction to
arbitrarily high order. At infinity its slow exponents are
\(\nu_h=-2(a+\lambda)+2hib\), and its fast factors are
\(e^{-hi r^2/4}r^{-12-\nu_h}\).
The diagonal errors are \(O(r^{-2})\) in \(D\). After extracting
these four factors, the remaining off-block errors are integrable
by choosing the reduction order larger than the fixed differences
of real exponents. Integration from infinity is a contraction on
bounded factored vectors, with arbitrary four limiting constants.
The two zero fast constants give two independent symbol-outgoing
solutions. A nonzero fast constant fails the outgoing condition
after sufficiently many Euler derivatives, since each such
derivative multiplies its leading factor by order \(r^2\).
This argument concerns each fixed parameter, not a purported
parameter-uniform fixed-radius basis.

## 2. All turning shapes and scalar transfer

The derivative \(F'_h=r/8+2L_\ell/r^3\) is positive. Both channels
turn in I; only \(h=+1\) turns in II. Any turn \(r_0\in[R,E]\)
has the exact parameterization
\[
\begin{split}
 A&=r_0^2/16,\quad H=L_\ell/r_0^2,\quad T=A+H,\\
 z&=h\omega-b=A-H,\quad
 T=\sqrt{z^2+L_\ell/4},\quad r_0^2=8(T+z),\\
 F(r)&=A(x^2-1)+H(1-x^{-2})
      =T(x^2-1)(\alpha+(1-\alpha)x^{-2}),\\
 x&=r/r_0,\qquad \alpha=A/T\in(0,1).
\end{split}                                                     \tag{12}
\]
Eventually \(S/4\le T\le2S\). In particular \(r_0\le4\sqrt T<E/2\).
For the negative-channel turn in I,
\(r_0^2=2L_\ell/(T+\omega+b)\asymp\ell^2/(\omega+\ell)\to\infty\).
For the positive-channel turn,
\(r_0^2\asymp\omega+\ell\to\infty\).
Define
\[
 d=(r_0/(2T))^{1/3},\quad
 K(r)=\sqrt{|F(r)|+d^{-2}},\quad
 H_f(r)=\int_{\min(r,r_0)}^{r_0}\sqrt{-F(t)}\,dt.     \tag{13}
\]
Then \(F'(r_0)d^3=1\), \(d^6\le4/T\), \(d\to0\),
\(d/r_0\to0\), and \(d^{-2}=o(S)\).
In a no-turn channel set \(K=\sqrt F\) and \(H_f=0\);
there \(F\asymp S=\omega\) throughout \([R,E]\).
On the fixed shell in I, \(\omega=o(\ell^2)\) implies
\(F_h(R)=-L_\ell/R^2(1+o(1))\) for both signs. In II the chosen
\(B_0\) gives \(F_-(R)\asymp\omega\) and
\(-F_+(R)\asymp\omega\), while \(n\asymp\sqrt\omega\).
Always \(K(R)\asymp n\), \(K(E)\asymp E\), and
\(\min_{h,r}K_h(r)\to\infty\).

We give the uniform outer-interval estimates rather than invoking a
turning-point theorem whose constants might depend on \(\alpha\).
Put \(f_\alpha(x)=(x^2-1)(\alpha+(1-\alpha)x^{-2})\).
Uniformly for \(0\le\alpha\le1\),
\[
\begin{array}{ll}
 3/8\le f_\alpha(x)/(x-1)\le12,&1/2\le x\le2,\\
 |f_\alpha(x)|\ge3/4,\quad
 |xf_\alpha'(x)|\le8|f_\alpha(x)|,\quad
 |x^2f_\alpha''(x)|\le8|f_\alpha(x)|,
       &x\le1/2\ \hbox{or}\ x\ge2.
\end{array}                                                     \tag{14}
\]
These inequalities follow directly from the factorization; the
verifier also gives coefficientwise rational positivity
certificates for their derivative and central bounds. Dependence
on \(\alpha\) is affine, so these are universal endpoint
certificates, not tests of finitely many shapes.

Remove \(|r-r_0|<Md\), with \(M\) large and fixed. From (12)-(14),
on the two remaining intervals,
\[
\begin{split}
 \int |F|^{-1/2}\,dr&\le C,\\
 \sup\frac{|F'|}{|F|^{3/2}}+
 \int\left(\frac{|F''|}{|F|^{3/2}}
             +\frac{|F'|^2}{|F|^{5/2}}\right)dr
 &\le C M^{-3/2}+o_j(1).                            \tag{15}
\end{split}
\]
Here \(C\) is independent of \(M\) and the shape. To see the
integral bounds explicitly, near the turn use
\(|F|\asymp |r-r_0|/d^3\),
\(|F'|\le C/d^3\), \(|F''|\le C/(d^3r_0)\).
The squared-first-derivative integral is \(O(M^{-3/2})\);
the second-derivative integral is
\(O((d/r_0)M^{-1/2})=o_j(1)\).
Outside \([r_0/2,2r_0]\) the residual integral and the supremum
are \(O((\sqrt T R)^{-1})\) by (14).
The first integral in (15) is bounded by
\(C(r_0/\sqrt T+E/\sqrt T)\), which is bounded.
In the no-turn case \(F\asymp\omega\),
\(F'=r/8+2L/r^3\), and \(F''=1/8-6L/r^4\).
With \(L=O(\omega)\), the residual integral and supremum are
\(O(\omega^{-1/2})\), while \(\int F^{-1/2}\,dr\le C\).

Choose \(\operatorname{Re}p>0\) with
\(p^2=\operatorname{sign}(F)(F+hi\gamma)\). Approximate solutions
are
\(p^{-1/2}\exp(\pm\int p)\) on \(F<0\), and
\(p^{-1/2}\exp(\pm i\int p)\) on \(F>0\).
Their Wronskians are the nonzero constants \(-2\) and \(-2i\).
Their residual potential is exactly
\[
 Q_p=\tfrac34(p'/p)^2-\tfrac12p''/p.                 \tag{16}
\]
Moreover \(K\asymp |p|\) outside the removed interval and
\(\int |p-\sqrt{|F|}|\,dr\le C\), since \(\gamma\) is bounded
and the first integral in (15) is bounded.

Use the data norm
\(N_r(u)=K(r)^{1/2}|u|+K(r)^{-1/2}|u'|\).
The approximate transfer has norm at most
\(C e^{|H_f(r)-H_f(t)|}\). Replacing its equation by the exact
equation adds a potential \(Q_p\), with
\(\int |Q_p|/K\le C M^{-3/2}+o_j(1)\).
Variation of constants therefore bounds the exact transfer by
the same action exponential, and the difference by
\[
 (C M^{-3/2}+o_j(1))e^{|H_f(r)-H_f(t)|}.             \tag{17}
\]
For precision, in the integral inequality divide the transfer by
that exponential. For ordered \(r,s,t\), the two action differences
add to the full difference because \(H_f\) is nonincreasing.
The remaining scalar integral inequality gives the factor
\(\exp(C\int |Q_p|/K)\); subtracting one proves (17).
This argument is valid in either direction of transfer.

With \(\xi=(r-r_0)/d\), \(Y(\xi)=d^{-1/2}u(r_0+d\xi)\), set
\(\varepsilon=d/r_0\). The exact scaled real potential is
\[
 G_{\alpha,\varepsilon}(\xi)=
 \frac{\alpha((1+\varepsilon\xi)^2-1)
          +(1-\alpha)(1-(1+\varepsilon\xi)^{-2})}{2\varepsilon},
\]
and its exact defect is
\[
 G_{\alpha,\varepsilon}(\xi)-\xi
 =\frac{\varepsilon\xi^2
 [4\alpha-3+(4\alpha-2)\varepsilon\xi+
                       \alpha\varepsilon^2\xi^2]}
              {2(1+\varepsilon\xi)^2}.             \tag{18}
\]
Thus on every fixed \([-M,M]\) the scaled equation converges,
uniformly in the entire closed shape interval \(0\le\alpha\le1\),
to \(Y''+\xi Y=0\); the subprincipal term is \(hi\gamma d^2=o(1)\).
Its transfer in the scaled norm is uniformly bounded for fixed
\(M\), by the integral inequality for a bounded first-order matrix
on a finite interval. Combining it with the outer transfers gives,
for every homogeneous scalar solution and all \(r,t\in[R,E]\),
\[
 N_r(u)\le C e^{|H_f(r)-H_f(t)|}N_t(u).             \tag{19}
\]
Here one sufficiently large \(M\) is fixed once. The statement
also holds in the no-turn channel, with zero action.

## 3. Uniform relative growing-branch margin

Let \(U\) solve the scalar equation with
\[
 U(E)=F(E)^{-1/4},\qquad U'(E)=hi\sqrt{F(E)}U(E).
 \]
At \(E\) these data differ from the outgoing approximate branch
by \(o_j(1)\) in normalized data. On the allowed outer interval,
(15)-(17) show, for any sufficiently large fixed \(M\),
\[
 c\le F^{1/4}|U|\le C,\qquad
 U'/(\sqrt F\,U)=hi+O(M^{-3/2})+o_j(1).             \tag{20}
\]
The constants \(c,C\) can be chosen independently of \(M\):
the imaginary phase action is bounded by the first integral in
(15). In a no-turn channel the error is just \(o_j(1)\), proving
the necessary value and slope estimates directly.

In a turning channel fix \(M_0\) so large that the error in (20)
is less than half its positive amplitude margin. At \(\xi=M_0\)
the scaled data have uniformly bounded norm, and their flux has
sign \(h\) and magnitude at least \(c>0\). There is no missing
power of \(d\):
\[
 \operatorname{Im}(\overline Y Y')
       =\operatorname{Im}(\overline U U').           \tag{21}
\]
Every convergent subsequence of these bounded data therefore
gives an Airy-equation solution with nonzero constant flux.

Here is an elementary construction of the real forbidden-side
basis, so no Airy connection formula is being assumed.
For \(y''-ty=0\), choose at a large fixed \(T_0\) the growing
approximate data
\(t^{-1/4}\exp(2t^{3/2}/3)\). The residual integral from \(T_0\)
to infinity is \(O(T_0^{-3/2})\), by the same calculation as (16).
The forward version of (17) shows that the resulting real solution
\(g\), and its derivative, are positive and comparable to these
growing scales on the whole half-line.
Its logarithmic slope \(z=g'/(\sqrt t\,g)\) obeys
\[
 z'=\sqrt t(1-z^2)-z/(2t).
\]
For every fixed \(0<\eta<1\), at sufficiently large \(t\) this
field points into \([1-\eta,1+\eta]\), and outside that interval
points toward it with magnitude bounded below by \(c_\eta\sqrt t\).
Positivity and the growing comparison bounds exclude escape;
integration forces eventual entry. Hence \(z\to1\).
The independent solution
\[
 d_*(t)=g(t)\int_t^\infty g(s)^{-2}\,ds
\]
has Wronskian \(-1\) with \(g\) and is negligible, together with
its derivative, relative to \(g\). This follows by bounding the
integral by \(C t^{-1/2}g(t)^{-2}\), using the growing comparison
bounds and the increasing derivative of \(2t^{3/2}/3\).
Both solutions extend across every finite interval.

Expand an Airy limit, with \(t=-\xi\), in this real basis:
\(Y=a_g g+a_d d_*\). The flux is
\(\operatorname{Im}(\overline{a_g}a_d)\) times the nonzero real
Wronskian (with the sign changed by \(t=-\xi\)).
The coefficients are uniformly bounded, since the data at the
fixed \(M_0\) are bounded and the basis matrix there is invertible.
By (21), \(|a_g|\) is therefore bounded below uniformly.
This is stronger than merely saying that each individual growing
coefficient is nonzero.

Consequently, uniformly on the compact set of possible Airy-limit
data, as \(M\to\infty\) the growing component dominates at \(-M\)
and
\[
 Y'(-M)/(\sqrt M\,Y(-M))\longrightarrow-1.           \tag{22}
\]
For every sufficiently large fixed \(M\), convergence of the
scaled equations transfers this margin to the original equations
at \(r_-=r_0-Md\). In the normalized approximate basis referenced
at \(r_-\), the left-growing coefficient is at least \(cN_{r_-}(U)\),
with \(c>0\) independent of \(M\). Also
\(N_{r_-}(U)\ge c e^{H_f(r_-)}\), with the same interpretation
of first fixing \(M\) and then taking late indices. These uniform
claims follow by compactness: a failing sequence of data at
\(M_0\) would have an Airy limit contradicting the coefficient
bound just proved.

On transfer from \(r_-\) to \(R\), the growing term is at least
\(cN_{r_-}(U)e^{H_f(R)-H_f(r_-)}\). The decaying term is negligible:
the action difference tends to infinity uniformly on the shell.
For example a fixed interval just to the right of \(B_1\) lies
below \(r_-\) eventually and has \(-F\ge c n^2\).
Relative to the growing term, (17) still has error at most
\(C M^{-3/2}+o_j(1)\), with \(C\) independent of \(M\).
Choose one sufficiently large fixed \(M\) for the value bound.
For the slope, take the upper limit in \(j\) for each fixed \(M\)
and then let \(M\to\infty\), using (22). This proves
\[
 \begin{split}
 N_r(U)&\le C e^{H_f(r)},\\
 |U(R)|&\ge cK(R)^{-1/2}e^{H_f(R)},\\
 U'(R)/U(R)&=B_h(R)+o(n).
 \end{split}                                                     \tag{23}
\]
At the shell, \(p'/p^{3/2}=o(1)\) and
\(p/\sqrt{|F|}=1+o(1)\), so the approximate slopes give exactly
the displayed slopes, with no phase or sign change.

All constants and compactness arguments allowed \(R\) to move
in \([B_0,B_1]\). If uniformity failed at moving \(R_j\), the same
argument would apply to those endpoints. Similarly, no subsequence
of parameters was fixed in deriving (23): every possible
convergent data subsequence has the same positive margin, so the
contradiction argument proves the estimates along the full family.

## 4. The coupled Green operator and the full outgoing graph

For each channel let \(D_h(R)=0\), \(D'_h(R)=K_h(R)^{1/2}\).
By (19) and (23),
\[
 N_r(D_h)\le C e^{H_h(R)-H_h(r)},\quad
 N_r(U_h)\le C e^{H_h(r)},\quad
 |W_h|=|W(D_h,U_h)|\ge c e^{H_h(R)}.                \tag{24}
\]
The Wronskian is constant, since there is no first derivative.
The mixed-boundary Green kernel is exactly
\[
 G_h(r,t)=D_h(\min(r,t))U_h(\max(r,t))/W_h.
 \]
Its derivative jump is \(+1\), not \(-1\), and (24) yields
\[
 N_r(G_h(r,t))\le C K_h(t)^{-1/2}
 \begin{cases}
 e^{H_h(t)-H_h(r)},&r<t,\\
 e^{H_h(r)-H_h(t)},&r>t.
 \end{cases}                                                     \tag{25}
\]
Both exponents are nonpositive. This is a separate monotonicity
statement in each channel. No difference \(H_h-H_k\) occurs.
The solution with zero left data and unit right Robin error is
\(-U_h(E)D_h/W_h\); its \(N_r\) norm is at most \(CK_h(E)^{-1/2}\).

Put \(\mathcal N(q)=\max_h\sup_{R\le r\le E}N_r(q_h)\).
Equation (25) shows that the matrix forcing has operator norm
at most
\[
 C\max_h\sum_k\int_R^E
      |V_{hk}(t)|/\sqrt{K_h(t)K_k(t)}\,dt
 \]
in this *one joint norm*, even when the channel actions are very
different. The right error \(M_jq(E)\) has operator norm at most
\(C\|M_j\|/E\), since \(K_h(E)\asymp E\).
Thus their sum has norm at most \(C\delta_j\).
For arbitrary left data \(\xi\), the uncoupled extension
\(q_h^0(r)=\xi_h U_h(r)/U_h(R)\) has
\[
 \mathcal N(q^0)\le C n^{1/2}|\xi|.
 \]
The integral equation \(q=q^0+\mathcal A_jq\) is a contraction
when \(C\delta_j<1\). It has a unique solution, and
\[
 \mathcal N(q-q^0)
       \le\frac{C\delta_j}{1-C\delta_j}n^{1/2}|\xi|.
 \]
Taking its derivative at \(R\) costs \(K_h(R)^{1/2}\asymp n^{1/2}\).
Combining with (23) proves (5).

For the manuscript coefficients in (6), if
\(\kappa_j=\min_{h,r}K_h(r)\), the first term of (4) is at most
\[
 C\int_R^E t^{-2}\,dt/\kappa_j
       \le C/(R\kappa_j)=o(1).
 \]
The second term is \(O(E^{-2})\) by (11).
At a turn \(\kappa_h=d_h^{-1}\), with
\(\kappa_h^6\ge T_h/4\ge S/16\); in the no-turn channel
\(\kappa_h\asymp\sqrt S\). Thus the smallness holds on the
whole interval, not just at a chosen finite set of points.

Finally the two-dimensional outgoing space, evaluated at \(E\),
is a graph by (10)-(11) and the first-entry-one normalization.
The finite-interval mixed problem just solved has exactly that
right graph. Continuing a solution at \(E\) therefore gives an
outgoing solution, and every outgoing solution restricts to it.
Arbitrary \(\xi\) are realized uniquely at \(R\); the derivative
map is linear and obeys (3). This proves both the original bridge
and the rough-coupling extension.

## What is and is not certified

`verify.py` uses exact SymPy algebra and rational positivity
certificates; it makes no floating-point or finite-frequency
inference. It independently replays the saved, bounded Jacobian
operation. The script does **not** check the Volterra, compactness,
or asymptotic arguments in Sections 1-4. Those form the analytic
proof and require independent mathematical review.

No false assertion was identified in the three audited bridge
lemmas. No refutation of the blowup theorem, no verification of
profile existence, and no verification of the later interior flux,
bounded-spectrum, linear, or nonlinear arguments is claimed.
Novelty and publishable significance remain for independent
assessment; they are not inferred from a search finding no source.
