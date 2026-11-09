# Original-response comparison for the conformal Euler system

## Status and dependencies

This is an author proof submitted for independent review, not a recorded
independent verification or a claim of verified originality. It addresses
the energy assumption left open in (F18) of `conformal_feedback.md`.
It does not replace the Chen--Hou kernels by local Taylor lifts.

The imported quantitative result is **the particular certified profile,
weights, response kernels and pointwise comparison bounds** of Chen--Hou,
arXiv:2210.07191v4, (4.10)--(4.22), (5.67)--(5.89), (5.121), (6.75),
Appendices C and D. The two new source assumptions are recorded under
`CH-ORIGINAL-RESPONSE-PACKAGE` and `CH-FLAT-INVERSE-AND-TAIL` in
`MATH_STATE.json`; their attribution still requires an independent reader.
Part II, arXiv:2305.05660v3, supplies the rigorous numerical construction.
No new interval calculation or recomputation of that numerical certificate
is asserted here.

The standard local smooth Euler input used in Section 7 is also recorded
as an external assumption. The publisher confirms Ebin--Marsden,
Annals of Mathematics 92 (1970), 102--163, DOI 10.2307/1970699.
The full primary theorem text was not obtained in this continuation;
the precise boundary-local-existence attribution is pending rather than
represented as a completed source check.

The previously reviewed local inputs are Theorems 1' and 2 of
`conformal_reduction.md` and Theorems 3--5 of `conformal_transport.md`.
In particular their inverse is the actual global, zero-flux physical
inverse, including the axis and periodic exterior. Their unspecified
constants are uniform for \(|\kappa|\leq1/10\). Only new algebra is checked
by `conformal_response_closure.py`; the analytic argument below is not
certified by that script.

Write \(Q=\{x,y>0\}\), \(r=|(x,y)|\). The physical cylindrical radius is
always \(R\), not \(r\). All time variables in this note are normalized
time \(\tau\).

## 1. The energy and the reference package

Let \(\bar W=(\bar\omega,\bar\eta,\bar\xi)\), with
\(\bar\eta=\bar\theta_x,\bar\xi=\bar\theta_y\), be the fixed reference.
Put
\[
 p=\bar\omega_x(0)>0,\quad T=\bar\theta_{xx}(0)>0,\quad
 \lambda=T/p,\quad c_l=\bar c_l=2\lambda,\quad
 \bar a=\mathcal A(\bar\omega),\quad \bar c_\omega=\lambda-\bar a,
 \qquad
 \mathcal A(f)=\frac4\pi\int_Q\frac{xy}{r^4}f.
 \tag{R1}
\]
The flat functional is \(c(f)=-\mathcal A(f)\).
The scalar reference jets are
\(\bar q=\bar\omega_{xy}(0)\) and
\(\bar d=\bar\theta_{xxy}(0)\).
Do not substitute the rounded profile parameters for exact enclosures.

Take a smooth cutoff \(\chi_\nu\), equal to one on \(r\leq\nu\) and
zero on \(r\geq2\nu\), with its usual derivative bounds. Set
\[
 B_\nu=(\chi_\nu\bar\omega,\,
       \partial_x[\chi_\nu(M_\nu+\bar\theta)],\,
       \partial_y[\chi_\nu(M_\nu+\bar\theta)]).
 \tag{R2}
\]
Here \(M_\nu=O(\nu^{1/3})\). Its value does not enter the inner gradient
or any origin jet. A square cutoff will be used for smooth swirl data.
The estimates of the reference cutoff use its derivative bounds and
support, not a new numerical profile.

For the actual total vector \(W^{\rm tot}=(\omega,\theta_x,\theta_y)\),
write
\[
 W=W^{\rm tot}-B_\nu=W_1+\widehat W_2,\qquad
 W_1=(w_1,\eta_1,\xi_1).
 \tag{R3}
\]
The letters \(q,d\) below mean perturbation jets
\(q=\omega_{xy}(0)-\bar q=\partial_{xy}w(0)\) and
\(d=\theta_{xxy}(0)-\bar d\).

Use the original energy, not an equivalent norm with altered constants:
\[
\begin{split}
 E=\max\{&
 \|w_1\varphi_1\|_\infty,\|\eta_1\varphi_2\|_\infty,
 \|\xi_1\varphi_{3,m}\|_\infty,
 \tfrac{\sqrt2}{5}\|w_1\varphi_4\|_\infty,\\
 &\mu_{h,i}[W_{1,i}\psi_i]_{C^{1/2}_{g_i}}\ (1\leq i\leq3),\\
 &\mu_{g,1}\|w_1\varphi_{g,1}\|_\infty,
 \mu_{g,2}\|\eta_1\varphi_{g,2}\|_\infty,
 \mu_{g,3}\|\xi_1\varphi_{g,3,m}\|_\infty,\\
 &|c(w_1\chi_{\rm ode})|/61,\ |c(\eta_1\chi_{\rm ode})|/15,\
 |c(w)|/61,\ |c(\eta_1)|/35.88,\ |d|/9.5,\ |q|/4.5\}.
 \tag{R4}
\end{split}
\]
Here \(w\) is the first component of \(W\),
\(\mu_h=(1,.668,1.336)/5\),
\(\mu_g=(.23\cdot.065,.23,.23)\),
\(E_*=5\cdot10^{-6}\), and all terminating decimals denote rationals.
The modified third weights agree with the original weights for
\(r<\nu/2\) and have the radial exterior pieces in (6.74).
There are sixteen comparison components: ten field components and
six scalar components. In particular
\[
 |c(w)|\leq61E,\quad |c(w_1)|\leq76E,\quad
 |q|\leq4.5E,\quad |d|\leq9.5E.
 \tag{R5}
\]
The second bound is the original moment estimate, not the much less
sharp estimate obtained from the sum norm \(X_1\).

Here is precise notation for the imported pointwise bounds.
For each normalized row \(i\), let
\[
 B_i^0(s;z,z',\tau)=\sum_{j\ne i}
 (A_{ij}(z,z',\tau)s+A_{ij,2}(z,z',\tau)s^2+A_{ij,3}(z,z',\tau))
 \tag{R6}
\]
be the nonnegative majorant in the cited proof, with its original
piecewise choices and time-history suprema. Let \(a_i^0\) be that
row's diagonal damping. These are the bounds in the following table,
not global maxima substituted for the original pointwise estimates.

| Rows in (R4) | Original damping and forcing bound |
|---|---|
| Three \(\varphi_i\) rows | \(-d_{i,L}^{\rm num}(\varphi_i)\), \(L_i(\varphi_i)+\mathcal{NF}_i(\varphi_i)\), (D.2)--(D.4) |
| The \(\varphi_4\) row | \(-d_{1,L}^{\rm num}(\varphi_4)\), \((\sqrt2/5)(L_1+\mathcal{NF}_1)(\varphi_4)\), (D.5)--(D.6) |
| Three growing rows | \(-d_{i,L}^{\rm num}(\varphi_{g,i})\), \(\mu_{g,i}(L_i+\mathcal{NF}_i)(\varphi_{g,i})\), (D.7)--(D.10) |
| Three two-point rows | \(-d_{i,L}^{\rm num}(p_{z,z'})-d_{g_i,\mathbf U}\), with the damping-difference, local, nonlocal and nonlinear increment terms of (D.12)--(D.16) |
| \(c(w_1\chi_{\rm ode})/61\) | \(-\bar c_\omega^N\), \(\big((4/\pi)|\langle\Gamma_{1,M},\chi_{\rm ode}f_*\rangle|+N(c(w_1\chi_{\rm ode}))+15s\big)/61\), (D.17) |
| \(c(\eta_1\chi_{\rm ode})/15\) | \(-2\bar c_\omega^N\), \(\big((4/\pi)|\langle\Gamma_{2,M},\chi_{\rm ode}f_*\rangle|+N(c(\eta_1\chi_{\rm ode}))\big)/15\), (D.17) |
| \(c(\eta_1)/35.88\) | \(-2\bar c_\omega^N\), the same uncut second-moment bound divided by \(35.88\), (D.17) |
| \(c(w)/61\) | \(-\bar\lambda_c\), the uncut first-moment bound plus \(35.88s+N_{\widehat W_2,\rm ode}\), divided by \(61\), (5.78), Appendix D.1.3 |
| \(q/4.5,d/9.5\) | The two explicit rows (R31) below, Appendix D.1.3 |

All the numerical stream errors in (5.92)--(5.103) remain included in
these bounds. No identity \(V_y=-U_x\) is used for the curved velocity.
It is used only for the flat velocity in the imported calculation.

The reference certificate gives fixed numbers
\(\epsilon_0,M_0,\epsilon_{1,q},\epsilon_{1,d},\lambda_\infty>0\)
such that, uniformly in the arguments of every applicable row,
\[
 a_i^0E_*-B_i^0(E_*)>\epsilon_0,\qquad
 B_i^0(E_*)<M_0,
 \tag{R7}
\]
\[
\begin{split}
 \epsilon_{1,q}
 &=5\mu_6E_*-\mu_6\mu_8E_*-|r_q|>0,\\
 \epsilon_{1,d}
 &=10\mu_6E_*-\mu_6\mu_7E_*-|r_d|>0,
 \qquad(\mu_6,\mu_7,\mu_8)=(61,9.5,4.5),\\
 r_q&=(-2c_l+\bar c_\omega)\bar q+\bar d-p^2,\\
 r_d&=(-3c_l/2+\bar c_\omega)\bar d-2pT.
 \tag{R8}
\end{split}
\]
The deliberately coarser products in (R8) are those actually certified
in (5.83); the true products in the energy rows are quadratic in \(E\).
Also (D.11), with the numerical stream residual retained, gives
strict exterior damping for powers \(1/7\) and
\(\alpha=1/3+10^{-8}\).
The reference has \(c_l>2\) and
\[
 \sigma_{\rm rate}:=-\tfrac12-\bar c_\omega-61E_*>0.
 \tag{R9}
\]
These are qualitative strict inequalities from the certified reference,
not deductions from rounded printed decimals.

## 2. Exact defect and the original response coefficients

Let \(a_\kappa=h_{xy}(0)\) be the actual strain and let \(E_\ell\)
be the effective Poisson-source error of the reviewed full-source
inverse theorem. Introduce the fixed profile tail
\(\mathcal T_\nu=\bar W-B_\nu\), and set
\[
 e_\ell=E_\ell-\mathcal T_{\nu,1},\qquad
 \zeta=-\mathcal A(e_\ell).
 \tag{R10}
\]
Linearity of the flat inverse and the reviewed global identity give
the exact, instantaneous comparison
\[
 a_\kappa=\bar a+\mathcal A(w)+\mathcal A(e_\ell),\qquad
 c_{\omega,\kappa}=\lambda-a_\kappa
                   =\bar c_\omega+c(w)+\zeta .
 \tag{R11}
\]
It is not a comparison with another evolution having a prescribed
strain.

It is useful to specify the entire perturbation, rather than only its
jets. For fixed velocity \(v=(u,v_2)\), rate \(c\), and source
coefficients \(A_s,B_s\), define
\[
\begin{split}
 \mathscr T_{v,c,A_s,B_s}(Z)_1
   &=-(c_lz+v)\cdot\nabla Z_1+cZ_1+A_sZ_2+B_sZ_3,\\
 \mathscr T_{v,c,A_s,B_s}(Z)_2
   &=-(c_lz+v)\cdot\nabla Z_2+(2c-u_x)Z_2-(v_2)_xZ_3,\\
 \mathscr T_{v,c,A_s,B_s}(Z)_3
   &=-(c_lz+v)\cdot\nabla Z_3+(2c-(v_2)_y)Z_3-u_yZ_2 .
 \tag{R12}
\end{split}
\]
The symbols in the two scalar-gradient rows are independent
components. Their use does not assert that every response is a gradient.

Put \(Z=\bar W+W=W^{\rm tot}+\mathcal T_\nu\).
Let \(v^0=\nabla^\perp(-\Delta)^{-1}Z_1\),
\(c^0=\bar c_\omega+c(w)\), and let \(v^\kappa\) denote the
actual velocity on the support. Off the support use the tangent
extension supplied by the reviewed transport theorem:
\[
 v^\kappa=\nabla^\perp H+
  (2\kappa\ell a_\kappa xy\chi,\,
    (\tfrac12-2\kappa)\ell a_\kappa y^2\chi)+\widehat V_{\rm rem}.
 \tag{R13}
\]
This changes a coefficient off the support, not the physical inverse.
All source-coefficient extensions likewise agree with the physical
coefficients on the support. The exact additional forcing is
\[
 \mathcal D=
 (\mathscr T_{v^\kappa,c_{\omega,\kappa},A_s,B_s}
       -\mathscr T_{v^0,c^0,1,0})Z
       -\mathscr T_{v^\kappa,c_{\omega,\kappa},A_s,B_s}\mathcal T_\nu .
 \tag{R14}
\]
In particular the velocity difference, including the exterior
source, is
\[
 \delta v=\nabla^\perp(-\Delta)^{-1}e_\ell+
 (2\kappa\ell a_\kappa xy\chi,\,
  (\tfrac12-2\kappa)\ell a_\kappa y^2\chi)+\widehat V_{\rm rem}.
 \tag{R15}
\]
Its linear part is \((\zeta x,-\zeta y)\).
Equations (R12)--(R15) specify every geometric, normalization,
source and cutoff term in \(\mathcal D\).

Let \(J=(\partial_{xy},\partial_{xy},\partial_{xx})|_0\).
Subtracting the flat jet equations from the reviewed full conformal
jet equations gives
\[
\begin{split}
 j_1:=J_1\mathcal D_1
  &=\zeta(\bar q+q)
       +\ell\{(4-\kappa)T-2\kappa a_\kappa p\},\\
 j_2:=J_2\mathcal D_2
  &=\zeta(\bar d+d)-4\kappa\ell a_\kappa T,\\
 j_3:=J_3\mathcal D_3&=j_2.
 \tag{R16}
\end{split}
\]
For example the curvature velocity contributes
\(-2\kappa\ell a_\kappa p\,xy\) in the first equation and
\(-4\kappa\ell a_\kappa T\,xy\) in the second.
The source contributes \((4-\kappa)\ell T\,xy\) in the first.
The linear strain and normalization contributions cancel at the
fixed \(p,T\) jets and give precisely the \(\zeta\) terms in (R16).

Use the **original** shapes
\[
 F_{\chi,1}=(\Delta(xy^3\chi_{\rm NF}/6),0,0),\quad
 F_{\chi,2}=(0,xy\chi_{\rm NF},0),\quad
 F_{\chi,3}=(0,0,x^2\chi_{\rm NF}/2).
 \tag{R17}
\]
They have \(J_iF_{\chi,i}=1\). They are not raw Taylor lifts.
Their normalization uses only the unit constant jet of \(\chi_{\rm NF}\).
In particular \(\Pi\mathcal D:=\mathcal D-\sum_i j_iF_{\chi,i}\)
has zero quadratic jets. Its singularly weighted norms are estimated
only after this subtraction.

Keep the original flat linear coefficients \(a_i(W_1)\), including
\(a_1(W_1)=c(w_1)\). Define all response coefficients by
\[
 b_i=a_i(W_1)\quad(1\leq i\leq n_{\rm lin}),\qquad
 b_{\chi,1}=c(w)q+r_q+j_1,\quad
 b_{\chi,2}=c(w)d+r_d+j_2,\quad b_{\chi,3}=b_{\chi,2}.
 \tag{R18}
\]
The alternative cylinder convention \(a_i(\Omega(w_1))\) is not
silently used: its entire difference is already in (R14).

Let \(\mathcal L_0\) be the full original flat linearization,
\(\mathcal K\) its original linear finite-rank part, and
\(\mathcal N_0(W)\) its original nonlinear part. With the convention
for residuals below, the exact remainder equation is
\[
 \partial_\tau W_1=(\mathcal L_0-\mathcal K)W_1+
 \mathcal N_0(W)+\bar{\mathcal F}
 -\sum_i(c(w)J_iW+r_i)F_{\chi,i}
 +\Pi\mathcal D-\mathcal R[b].
 \tag{R19}
\]
Here \(r_1=r_q,r_2=r_3=r_d\).
The full actual transport of \(W_1\), including \(\delta v\), is
kept on the left when deriving energy estimates; (R19) is an operator
identity, not a request to bound \(\delta v\cdot\nabla W_1\) in \(X_i\).
In particular, put \(q_1=\partial_{xy}w_1(0)\),
\(d_{1,2}=\partial_{xy}\eta_1(0)\) and
\(d_{1,3}=\partial_{xx}\xi_1(0)\). The original corrected-kernel
jet equations, (R16), and the cubic residual property give
\[
 q_1'=(-2c_l+\bar c_\omega)q_1+d_{1,2},\qquad
 d_{1,2}'=(-3c_l/2+\bar c_\omega)d_{1,2},\qquad
 d_{1,3}'=(-3c_l/2+\bar c_\omega)d_{1,3}.
 \tag{R19a}
\]
The reference-strain jet terms are removed by the original
\(\mathcal K_1W_1\); \(\mathcal K_2W_1\) has zero quadratic jet.
The nonlinear, profile-error, geometric and response-residual
quadratic jets cancel in (R19). Thus all three jets remain zero
when initially zero. Only total \(W\), not its two summands, is
required to satisfy \(\eta_y=\xi_x\).

## 3. Coefficient, stream, source-error and residual histories

All histories are retained:
\[
\begin{split}
 \widehat W_2[b](\tau)&=\sum_i\int_0^\tau
                         b_i(\tau-s)\widehat G_i(s)\,ds,\\
 \widehat\phi^N[b](\tau)&=\sum_i\int_0^\tau
                         b_i(\tau-s)\widehat\phi_i^N(s)\,ds,\\
 \widehat\varepsilon[b](\tau)&=\sum_i\int_0^\tau b_i(\tau-s)
             (\widehat G_{i,1}+\Delta\widehat\phi_i^N)(s)\,ds .
 \tag{R20}
\end{split}
\]
The last line uses the first, vorticity component of \(\widehat G_i\).
For piecewise-time kernels it is clearest to regard
\[
 d\mathcal R_i=
   (\widehat G_i(0^+)-F_i)\delta_0+
   (d_s\widehat G_i-\mathcal L_0\widehat G_i\,ds)|_{s>0},
 \qquad
 \mathcal R[b](\tau)=\sum_i\int_{[0,\tau]}b_i(\tau-s)\,d\mathcal R_i(s).
 \tag{R21}
\]
Here \(F_i\) is the original rank-one source, including (R17).
Thus a kernel jump contributes its jump times \(b_i(\tau-T_i)\).
It is not dropped or replaced by a smooth density.
This convention gives
\(\partial_\tau\widehat W_2=\mathcal L_0\widehat W_2+
 \sum_i b_iF_i+\mathcal R[b]\), proving (R19).

For compatibility with the actual numerical residual bounds, each
component of (R21) also has the original splitting
\[
 \mathcal R_k=\sum_i b_i*\mathcal R_{{\rm num},i,k}
 -\big(\mathcal B_{{\rm op},k}(u(\bar\varepsilon),\widehat W_2)
                  -J_k\mathcal B_{{\rm op},k}(u(\bar\varepsilon),\widehat W_2)
                         \chi_{k2}\big)
 -\big(\mathcal B_{{\rm op},k}(u(\widehat\varepsilon),\bar W)
                  -J_k\mathcal B_{{\rm op},k}(u(\widehat\varepsilon),\bar W)
                         \chi_{k2}\big).
 \tag{R22}
\]
The difference between \(\chi_{k2}\) and \(F_{\chi,k}\) remains in
the local residual as in (5.87). Equation (R22) is not replaced by
an unqualified error estimate for a numerically inverted stream.

For each fixed kernel choose \(K_i<\infty\) containing its time-integrated
spatial bounds from (5.86): derivatives of \(\widehat G_i\) through
order five, of the represented stream as used there, of the corrected
source error, and of the cubic residual through order two; include
the initial errors, jump masses and the relevant strain moments.
Taylor subtraction is made before taking any singular norm.
These are fixed original constants. The analytic tail corrections
are included in the integrals to infinity, even when the raw numerical
part stops at \(T_i\).
For any additional coefficients \(h_i\),
\[
 \|\widehat W_2[h]\|_{\rm jet+reg}
 +\|\widehat\phi^N[h]\|_{\rm stream}
 +\|\widehat\varepsilon[h]\|_{\rm source}
 +\|\mathcal R[h]\|_{Y_1\times X_2\times X_{3,m}}
 \leq\sum_i K_i\sup_{s\leq\tau}|h_i(s)|.
 \tag{R23}
\]
Here the first norm records the finite quadratic jets separately
and applies the stated weights only to their cubic remainders.
The other norms mean exactly the derivative and weighted quantities
in (5.85)--(5.89), not an uncorrected quadratic \(X_i\) norm.
Inequality (R23) follows directly from (R20)--(R22) by the triangle
inequality for integrals and total variation for the atomic terms.
Its constants do not depend on \(\nu,\ell,S\).

For emphasis, the full-strain ODE has a distinct history. Put
\(k_i(s)=c(\widehat F_{i,1}(s))\) and
\(\bar\lambda_c=\bar c_\omega+k_1(0)\). The analytic tail correction
has zero \(c\)-moment, so \(k_i\) is supported on \([0,T_i]\).
If \(\Gamma_1\) denotes the complete non-damping first-moment forcing
in (R19), including the added projected error, then
\[
\begin{split}
 c(w)'={}&\bar\lambda_c c(w)-\frac4\pi\langle\Gamma_1,f_*\rangle
 -\frac4\pi\langle\eta_1,f_*\rangle
 +\sum_{i\geq2}b_i(\tau)k_i(0)\\
 &+\sum_i\left\{-{\bf1}_{\tau\geq T_i}b_i(\tau-T_i)k_i(T_i)
  +\int_0^{\tau\wedge T_i}b_i(\tau-s)
                   (k_i'(s)-\bar\lambda_c k_i(s))\,ds\right\},
 \quad f_*=\frac{xy}{r^4}.
 \tag{R24}
\end{split}
\]
This follows by differentiating \(c(w)=c(w_1)+c(\widehat W_{2,1})\),
not by estimating those two terms independently. An increment \(h_i\)
in a coefficient costs at most
\[
 \sup|h_i|\left(
 {\bf1}_{i\geq2}|k_i(0)|+|k_i(T_i)|
 +\int_0^{T_i}|k_i'-\bar\lambda_c k_i|\,ds\right).
 \tag{R25}
\]
In particular the endpoint term is present even after the numerical
evolution of a response has stopped.

The Volterra definition itself is noncircular. For a given smooth total
solution the last three coefficients in (R18) are known. In the first
\(n_{\rm lin}\) equations insert \(W_1=W-\widehat W_2[b]\).
This is a finite linear Volterra system with locally integrable
kernels \(a_i(\widehat G_j)\). Successive Volterra iteration on a
short interval, then continuation on any finite interval, gives the
unique decomposition. It does not construct a second Euler solution.

## 4. Uniform perturbation bounds for all row types

This section supplies the analytic step needed to transfer (R7).
Set
\[
 \delta(\tau)=\ell(\tau)(1+S(\tau)),\qquad
 \gamma=10^{-8},\qquad
 \eta_*=\delta_*+\nu^{-\gamma}+\nu^{-1/32}.
 \tag{R26}
\]
The bootstrap assumptions are \(E<E_*\), \(\delta<\delta_*\), and
the three coefficient caps \(5\mu_6E_*,10\mu_6E_*,10\mu_6E_*\)
in (R18). No sign assumption on the actual strain is made.

First obtain a source bound from these assumptions. The flat linear
coefficient bounds are the original bounds \(L_iE_*\); the last
three caps are fixed. Equation (R23) bounds the response, its jets,
and its projected remainder by a fixed constant
\[
 K_*=\sum_{i\leq n_{\rm lin}}K_iL_iE_*
       +\mu_6E_*(5K_{\chi,1}+10K_{\chi,2}+10K_{\chi,3}).
 \tag{R27}
\]
The cutoff reference, after removal of \(px\chi+\bar qxy\chi\),
has a uniform \(X_1\) bound by its decay. Its scalar-gradient
derivatives have the uniform coarse bounds in (29) of
`conformal_transport.md`. Subtracting the actual two vorticity jets,
(R4), (R23), and (R27) therefore give
\[
 N_1(\omega-px\chi-(\bar q+q)xy\chi)
        +|p|+|\bar q+q|\leq M_*,
 \tag{R28}
\]
where \(M_*\) is fixed before \(\nu,\delta_*,\ell(0)\) are chosen.
For example choose twice the sum of the reference bound, the
energy-to-sum-norm constant times \(E_*\), the projected kernel
bound in (R27), and the fixed jet bounds. This is a consequence
of the energy and coefficient bootstrap, not the assumption (F18).
The reviewed inverse theorem now gives
\[
 |a_\kappa|\leq33M_*,\quad
 \|e_\ell\|_{X_1}\leq C(\delta+\nu^{-\gamma}),\quad
 |\zeta|\leq11\|e_\ell\|_{X_1},\quad
 |j_1|+|j_2|+|j_3|\leq C\eta_*.
 \tag{R29}
\]
There is no use of positive actual strain in these estimates.

We prove that the additional term in every **normalized** comparison
row is bounded by
\[
                         C_i\eta_*(1+E_{\max})^2.
 \tag{R30}
\]
Constants below depend on \(M_*\), the fixed profile, weights and
kernel bounds only.

**Independent response components.** In (R12) the geometric
velocity terms acting on a prescribed vector \(G\) are
\(-\delta v\cdot\nabla G_1\),
\(-\delta v\cdot\nabla G_2-\delta u_xG_2-\delta v_{2,x}G_3\),
and
\(-\delta v\cdot\nabla G_3-\delta u_yG_2-\delta v_{2,y}G_3\).
These formulas need no relation \(G_{2,y}=G_{3,x}\).
Every corrected response is \(C^{4,1}\), compactly supported in a
fixed box of size \(L_2\), with \(G_1,G_2\) odd in \(x\),
\(G_3\) even and \(G_3(0,y)=0\), and \(G=O(r^2)\).
Consequently \(G_2=O(x)\), \(G_3=O(x^2)\);
the same trace estimates hold after a \(y\) derivative.
Apply Taylor's formula to \(G\) and to the explicit polynomial
velocity pieces before subtracting the quadratic forcing jets.
For the other velocity pieces use the cubic value bounds and the
weighted half-Holder bounds in the next paragraph, not a third
derivative norm of the inverse. The resulting odd forcing is
\(O(|x|r^2)\); its even component has the trace-compatible cubic
gain needed by the third weight. The half-Holder product rule
then bounds the weighted remainders using the prescribed
\(C^{3,1}\) bounds for \(G\) on the fixed box and the stated
velocity bounds. The time integrals are bounded by (R23).
Thus the proof of the prescribed-field estimates extends to
independent response components; it does not manufacture a scalar
potential for them.

**The flat inverse error.** Apply Lemmas 6.11--6.12 to \(e_\ell\).
Subtract its linear strain velocity and retain its quartic harmonic
stream coefficient. The resulting velocity is \(O(\|e_\ell\|_{X_1}r^3)\);
its derivative is \(O(\|e_\ell\|_{X_1}r^2)\) near zero.
The quartic harmonic term is treated as an explicit smooth cubic
velocity, not placed alone in a singular Hessian norm.
The normalized weighted half-Holder estimate in Lemma 6.12 controls
the rest. At large radius its local derivative seminorm is at most
\(C\|e_\ell\|_{X_1}r^{1/6}\). Multiplication by a scalar-gradient
remainder costs \(CEr^{1/6-\alpha}\); hence the largest power is
\(r^{1/3-\alpha}=r^{-10^{-8}}\). For the geometric velocity remainder
the corresponding power is instead
\(\ell r^{7/6+1/6-\alpha}=\ell r^{1-10^{-8}}\), bounded by
\(C\delta\). These are the required product estimates, not an
unsupported weighted Hessian bound.

The separate linear strain velocity is \((\zeta x,-\zeta y)\).
Together with the rate change it gives the generator
\[
 \zeta(-x\partial_x+y\partial_y+1),\quad
 \zeta(-x\partial_x+y\partial_y+1),\quad
 \zeta(-x\partial_x+y\partial_y+3)
\]
on the three components. Its linear \(p,T\) jets cancel; its
quadratic jets are the \(\zeta\) terms of (R16).
For a remainder it changes only transport and multiplication
coefficients. In a two-point row, its logarithmic weight coefficient
may have derivative \(C|\zeta|/r\), so a global unweighted Holder
bound for that coefficient is not used. Locally it is multiplied by
\(|W_{1,i}\psi_i|\leq CE r^{1/2}\) near zero; the half-Holder
product is therefore bounded by \(C|\zeta|E\).
Nonlocal pairs use the value bound divided by the square root of
the separation, exactly as in the original strain transport estimate.
This proves the same bound at the singular corner.

**The remaining field and transport terms.** Theorems 3--5 of the
reviewed transport note apply to the cubic remainder in (R15).
Its quadratic polynomial is kept until its jets have been
subtracted as in (R16)--(R17). On a fixed annulus changing from the
local Taylor cutoff to \(F_{\chi,i}\) costs \(C|j_i|\); near zero
their difference has cubic or higher order. This is small because
the *coefficient* is \(O(\eta_*)\), not because a raw lift was small.
The source terms are exactly
\((A_s-1)Z_2+B_sZ_3\); their linear profile jet and remainder are
(35)--(37) of that note. Its (20)--(28) control all four matrix
products, the \(\varphi_4\) row, every logarithmic weight derivative,
and both points of each Holder transport equation.
The term \(\delta v\cdot\nabla W_1\) stays in the transport.
No derivative norm of the evolving remainder is introduced.

For a fixed profile use its decay and the prescribed-field estimates.
For a response use the independent-component argument above and (R23).
For the tail term in (R14), apply the cutoff estimates (6.82),
(6.106)--(6.110). Their worst remaining factor is
\(\nu^{-(\alpha-1/3)}=\nu^{-\gamma}\), not a constant.
The same bounds follow for a square cutoff since its derivatives
have the same scale bounds and \(M_\nu=O(\nu^{1/3})\).
The exterior even-\(\xi\) supremum is treated separately below.

**Changed histories.** Write \(b=b^0+h\), where \(b^0\) retains
the same flat linear coefficients and has the last three
coefficients \(c(w)q+r_q,c(w)d+r_d,c(w)d+r_d\);
\(h\) has only the last three entries \(j_i\).
This is an identity along the actual evolution, not a reference
Euler solution. Equations (R23), (R25), and (R29) bound every
added response, stream, Poisson residual, operator residual and
strain history by \(C\eta_*\).
In nonlinear expressions use the exact product difference and
project its quadratic jet before estimating. One factor is the
added response with its finite jets and fixed spatial derivative
bounds; the other is either a prescribed field, a bounded response,
or an evolving remainder. In the last case, transport stays on the
left and the matrix products are precisely those just estimated.
Thus each added product is at most
\(C\eta_*(1+E_{\max})^2\), including products with the original
profile and stream residuals. There is no assumption that the
quadratic added response itself belongs to \(X_i\).

**Moment rows.** For \(q_0=1,\chi_{\rm ode}\), integrating the
additional transport gives exactly
\[
 -\langle\delta v\cdot\nabla W_{1,i},q_0f_*\rangle
 =\langle W_{1,i},
       \delta v\cdot\nabla(q_0f_*)+
                         (\nabla\cdot\delta v)q_0f_*\rangle .
\]
The second term is essential: only \(RJv^\kappa\) is divergence-free.
Tangency and the derivative bounds give
\(|\delta u/x|+|\delta v_2/y|+|\delta v|/r+
 |\nabla\cdot\delta v|\leq C\eta_*\).
Since \(\nabla\log f_*=(1/x,1/y)-4z/r^2\), the integral is bounded
by \(C\eta_*\int|W_{1,i}|f_*\), plus a fixed-annulus cutoff term.
These integrals are bounded by \(CE\): near zero the remainders
are cubic, and at infinity the growing weights give positive
decay. Boundary terms vanish by tangency; a circle of radius
\(\epsilon\) contributes \(O(\epsilon^{29/10})\).
The added cubic forcings are integrable by the same calculation.
This proves (R30) for all three moment rows and the moment forcing
in (R24). The remaining part of that strain row is (R25).

**Taylor rows.** Their full comparison equations are
\[
\begin{split}
 q'&=(-2c_l+\bar c_\omega)q+d+c(w)\bar q+c(w)q+r_q+j_1,\\
 d'&=(-3c_l/2+\bar c_\omega)d+c(w)\bar d+c(w)d+r_d+j_2.
 \tag{R31}
\end{split}
\]
The corresponding normalized forcing bounds are
\[
\begin{split}
 B_q^\kappa(s)&\leq
 \frac{(\mu_7+\mu_6|\bar q|)s+\mu_6\mu_8s^2+|r_q|+C\eta_*}{\mu_8},\\
 B_d^\kappa(s)&\leq
 \frac{\mu_6|\bar d|s+\mu_6\mu_7s^2+|r_d|+C\eta_*}{\mu_7},
 \qquad s=E_{\max}.
 \tag{R32}
\end{split}
\]
Their diagonals are \(2c_l-\bar c_\omega\) and
\(3c_l/2-\bar c_\omega\), respectively.
This completes the proof of (R30) for every row in the table.

## 5. Both (A.11) bounds and the separate mode conditions

Let \(C_*=\max\{1,\max_iC_i\}\), increasing it to include (R29), (R32),
the separate mode conditions below, and the exterior comparison.
Keep \(a_i^\kappa=a_i^0\); coefficient changes multiplying the
row variable can be placed in its forcing.
For each row choose any different index \(j(i)\) and add
\[
 (2C_i\eta_*,\,C_i\eta_*,\,C_i\eta_*)
\]
to \((A_{i,j(i)},A_{i,j(i),2},A_{i,j(i),3})\), respectively.
Then the complete new majorant is
\[
 B_i^\kappa(s)=B_i^0(s)+C_i\eta_*(1+s)^2 .
 \tag{R33}
\]
This explicitly realizes the form (A.10), rather than invoking
an unspecified perturbation theorem.
Choose parameters so that
\[
 C_*\eta_*(1+E_*)^2<\epsilon_0/2.
 \tag{R34}
\]
The two distinct uniform inequalities are
\[
 a_i^\kappa E_*-B_i^\kappa(E_*)>\epsilon_0/2,\qquad
 B_i^\kappa(E_*)<
 M:=\max\{M_0+C_*\eta_*(1+E_*)^2,\epsilon_0\}<\infty .
 \tag{R35}
\]
The second is a genuine uniform bound, not an inference from
positive damping. The original spatially local margins in (R7)
are preserved pointwise.

The independent coefficient bootstrap also improves. By (R5),
(R8), (R16), and (R29),
\[
\begin{split}
 |b_{\chi,1}|&\leq\mu_6\mu_8E_*^2+|r_q|+C_*\eta_*
              <5\mu_6E_*-\epsilon_{1,q}/2,\\
 |b_{\chi,2}|=|b_{\chi,3}|
             &\leq\mu_6\mu_7E_*^2+|r_d|+C_*\eta_*
              <10\mu_6E_*-\epsilon_{1,d}/2,
 \tag{R36}
\end{split}
\]
provided \(C_*\eta_*<\min(\epsilon_{1,q},\epsilon_{1,d})/2\).
Here \(E_*^2<E_*\) justifies use of the certified coarser gaps.
These conditions are not substitutes for the two Taylor energy rows.

For completeness, the convention of (6.91) separates the error on
the response from the profile error. Let
\(\mathcal L_\kappa=D\mathscr F_\kappa(B_\nu)\) be the actual
linearization at the cutoff profile, at the current fixed \(\ell\).
The two quantities in that convention are
\[
 c_\kappa(w)q+J_1\bar{\mathcal F}_\kappa+
              J_1[(\mathcal L_\kappa-\mathcal L_0)\widehat W_2],
 \qquad
 c_\kappa(w)d+J_2\bar{\mathcal F}_\kappa+
              J_2[(\mathcal L_\kappa-\mathcal L_0)\widehat W_2].
 \tag{R37}
\]
Here \(c_\kappa(w)\) is the perturbation part of the actual
normalization functional; the subscript does not mean \(c(w)\).
The scalar inverse and the finite jets in (R23) give separately
\[
\begin{split}
 |c_\kappa(w)-c(w)|&\leq C_*\eta_*,\\
 |J_i\bar{\mathcal F}_\kappa-r_i|&\leq C_*\eta_*,\\
 |J_i[(\mathcal L_\kappa-\mathcal L_0)\widehat W_2]|
                                                    &\leq C_*\eta_* .
 \tag{R38}
\end{split}
\]
To see the last two estimates without a jet continuity assumption
in \(X_i\), differentiate (R12) at zero: only the fixed first and
second field jets, the strain, the explicit quadratic velocity
and the first source-coefficient derivatives occur. Those quantities
are bounded by (R23), (R28)--(R29); their changes are exactly the
linear and profile parts of (R16). No uncontrolled derivative of
the evolving remainder occurs. Increase \(C_*\) to cover the sum
in (R38). Equations (R36) then hold for (R37) too. Thus both
inequalities corresponding to (6.91), including its response term,
have their own strict margins.

All hypotheses needed for Lemma A.2 are as follows. On each finite
smooth time interval the extended transport is spatially Lipschitz,
has at most linear growth, and is tangent on \(x=0,y=0\).
The two-point rows use that transport at both points and scalar
rows have zero transport. The kernels and coefficients are locally
integrable in time; jump terms in a kernel are retained as in
(R21), (R24). The weighted row quantities are finite, and the
energy is locally Lipschitz. This follows on a finite interval
from smoothness of the total solution, the \(C^{4,1}\) kernel
bounds, and the preserved cubic remainder jets. No value at the
punctured corner or at coincident Holder points is required:
the characteristic inequality holds at every interior distinct
pair and then passes to the supremum. Tangent Lipschitz flows
cannot hit those deleted sets in finite time.
The applicable inner third-component traces and the outgoing
weight interface are verified in Section 6, not assumed as extra
boundary data.

With \(E(0)<E_*\), (R35) gives the strict comparison
\[
 E(\tau)\leq
 \max\left(E(0),\left(1-\frac{\epsilon_0/2}{M+\epsilon_0/2}\right)E_*\right)
 <E_*.
 \tag{R39}
\]
For the exterior third-component supremum use the separate
characteristic estimate in Section 6 and combine it with the
inner comparison. Thus the discontinuous definition of the
modified supremum weight is not differentiated in (R39).

## 6. Actual strain, exterior comparison, support and trace

After imposing \(C_*\eta_*<\sigma_{\rm rate}/2\), (R5), (R11),
and (R29) imply
\[
 c_{\omega,\kappa}
 \leq\bar c_\omega+61E_*+C_*\eta_*<-\tfrac12,\qquad
 a_\kappa=c_l/2-c_{\omega,\kappa}>\tfrac32,\qquad c_l>2 .
 \tag{R40}
\]
This is derived from the invariant energy, not imposed as the
bootstrap strain condition (F18). A finite lower bound on
\(c_{\omega,\kappa}\) follows from the same formulas. No sign
condition on \(c_l+3c_{\omega,\kappa}\) is asserted.

The scalar inverse and the first-derivative velocity estimate give,
on the support,
\[
 |v^\kappa(z)|\leq C_vM_*r^{1-\beta}\quad(r\geq1),
 \qquad \beta=1/16 .
 \tag{R41}
\]
The logarithmic Hessian estimate also gives
\(|Dv^\kappa|\leq CM_*r^{-1/32}\) at large radius.
Choose \(\nu>4L_2\), large enough that on \(r=\nu/2\)
\((c_lz+v^\kappa)\cdot z/r>c_lr/2\).
For the two exterior radial weights of \(\xi_1\), the characteristic
damping is the original (D.11) damping plus a quantity bounded by
\(C_*\eta_*\); the mixed forcing is bounded by
\(C_*\nu^{-1/32}(1+E_{\max})\).
Indeed outside the response box the equation contains only the
total scalar-gradient transport, the cutoff-profile terms, and
\(-u_y\eta_1\); (R41) and the displayed derivative bound control
the last term after multiplying by either radial weight.
The profile terms have the stronger decay in (29) of the
reviewed transport note. For \(C_*\eta_*\) sufficiently small this
gives, for each normalized exterior quantity \(F\),
\[
 |F(\tau)|\leq
 \max\{\text{initial value},\text{value at entry through }r=\nu/2,
                   2C_*\nu^{-1/32}(1+E_*)/\lambda_\infty\}.
 \tag{R42}
\]
The entry value is at most the inner value since the exterior
weight is no larger there. Choose the last term below \(E_*/2\).
Our choice \(M\geq\epsilon_0\) makes the interior threshold in
(R39) at least \(2E_*/3\), so this exterior floor does not weaken
the stated joint bound.
This is the separate exterior maximum estimate of (6.93), not
an assertion of an angular trace in the exterior.

Use a support envelope satisfying
\[
 S'=c_lS+C_vM_*S^{1-\beta},\qquad \ell'=-c_l\ell.
 \tag{R43}
\]
It contains the supports of the transported scalar and vorticity,
the fixed profile cutoff and the fixed response box. The first
two supports propagate with the total transport; the other
supports are fixed and start strictly inside the envelope.
Exact integration gives
\[
 (\ell S)^\beta
 =\ell_0^\beta\left[S_0^\beta+
            \frac{C_vM_*}{c_l}(1-e^{-c_l\beta\tau})\right].
 \tag{R44}
\]
Thus \(\ell(1+S)\leq\ell_0+\ell_0
 (S_0^\beta+C_vM_*/c_l)^{1/\beta}\) for all time.
It is the decay of \(\ell^\beta\) that is integrated; a bounded
quantity \(\ell S\) has not been declared integrable.

For the inner trace \(\xi=\theta_y\), parity gives
\(\eta(0,y)=0\) and \(u_y(0,y)=0\). Restricting (R12) to \(x=0\)
therefore gives the homogeneous equation
\[
 \xi_\tau+(c_ly+v_2^\kappa(0,y))\xi_y
             =(2c_{\omega,\kappa}-(v_2^\kappa)_y(0,y))\xi .
 \tag{R45}
\]
The initial trace is zero for \(y<\nu/2\); the interface there
is outgoing, and \(y=0\) is tangent. A backward characteristic
from that inner segment cannot enter from \(y>\nu/2\).
Hence the trace stays zero there. The cutoff profile has that
trace and each response has zero trace on the whole line, so
\(\xi_1(0,y)=0\) in the inner region. This proves the trace
hypothesis used in the angular weights.

An explicit sufficient smallness budget, after enlarging \(C_*\)
to include every constant just used, is
\[
 \eta_0=\min\left\{
 \frac{\epsilon_0}{8C_*(1+E_*)^2},
 \frac{\epsilon_{1,q}}{8C_*},\frac{\epsilon_{1,d}}{8C_*},
 \frac{\sigma_{\rm rate}}{8C_*},\frac{\lambda_\infty}{8C_*},
 \frac{\lambda_\infty E_*}{16C_*(1+E_*)},2^{-13}\right\}>0.
 \tag{R45a}
\]
The order of choices is noncircular:

1. Fix the cited profile, exact weights, kernels, their integral
   bounds, the original gaps, and \(E_*\). Form \(M_*\) from (R27).
2. Obtain the constants in Sections 4--6, including the separate
   mode, rate, exterior and velocity bounds. They are uniform
   in \(\nu,\ell,S,\kappa\) in the stated range.
3. Choose
   \(\nu>\max\{4,4L_2,2(4C_vM_*/c_l)^{1/\beta}\}\) with
   \(\nu^{-\gamma}+\nu^{-1/32}<\eta_0/2\).
4. Choose \(0<\delta_*<\eta_0/2\), decreasing it if necessary to
   satisfy every previously reviewed coordinate restriction.
5. Construct the smooth data below, choose \(S_0>4\nu\), and only
   then choose
   \[
   0<\ell_0<
   \frac{\delta_*}{2[1+(S_0^\beta+C_vM_*/c_l)^{1/\beta}]}.
   \]

The energy, three coefficient caps, support inequality and trace
then improve simultaneously on their common existence interval.
The constants used to derive the strain do not depend on a
previously assumed favorable sign of that strain.

## 7. Smooth data and the physical consequence

This section explains how to enter the invariant neighborhood,
including the square-root and axis issues.
Choose a smooth radial \(\zeta_\nu\) equal to one on \(r\leq\nu\)
and zero on \(r\geq2\nu\), and take \(\chi_\nu=\zeta_\nu^2\)
in (R2). Smooth the \(C^{4,1}\) reference on a fixed neighborhood
of this support. Preserve oddness of \(\omega\), evenness of
\(\theta\), and the constant inner scalar trace. One explicit
trace correction after symmetric smoothing subtracts
\(\chi_x(x)\chi_y(y)(\Theta_{\rm sm}(0,y)-\bar\theta(0,y))\)
on a smaller region where the reference trace is constant.
The cutoffs are one on the required inner segment and supported
where that trace is still constant. Correct the finitely many
origin jets by compactly supported parity-compatible monomials.
In particular preserve \(p,T,\bar q,\bar d\) exactly.

For clarity, this approximation is strong enough for the
singular norms. The vorticity error tends to zero in \(C^3\)
and the scalar error in \(C^4\) on the fixed compact set.
After the matching jets are removed their vector errors are
cubic. Odd components have a factor \(x\); the even component
has a factor \(x^2\) because its inner trace is zero.
Taylor's formula bounds all inner weighted suprema by the
corresponding small derivative bounds. Multiplication by the
Holder weights gives functions of size \(O(\epsilon r^{1/2})\)
with their local half-Holder seminorms \(O(\epsilon)\).
On the remaining compact annulus the weights are fixed, and the
outer even component uses the modified radial weights.
The scalar moments follow by integrating \(f_*\).
Thus \(E(0)\) can be made \(<E_*/4\), not merely small in an
unweighted norm.

Take \(M_\nu\) strictly larger than one plus the supremum of the
absolute value of the smoothed scalar on its fixed compact extension. The profile decay
allows \(M_\nu\leq C(1+\nu^{1/3})\) uniformly.
Define
\[
 \theta_0=\zeta_\nu^2(M_\nu+\Theta_{\rm sm}),\qquad
 \Gamma_0=\zeta_\nu\sqrt{M_\nu+\Theta_{\rm sm}} .
 \tag{R46}
\]
The radicand is strictly positive wherever needed.
Therefore \(\Gamma_0\) is smooth and \(\Gamma_0^2=\theta_0\).
No assertion that an arbitrary nonnegative smooth function
has a smooth square root is used.
The vorticity is the correspondingly smoothed cutoff reference,
with its jets preserved.
Since \(\widehat W_2(0)=0\), these are precisely the initial
remainders in (R4). The strict coefficient caps initially follow
from (R8), (R29) after the parameter choices above.

Fix \(C_\omega(0)=1\) and pull these fields to the physical pipe
\[
 \mathcal P_\kappa=\{(R,\vartheta,Z):Z\in\mathbb R/2\pi\mathbb Z,\
                  0\leq R<1+\kappa(1-\cos Z)\}.
 \tag{R47}
\]
Put \(\widetilde\omega_0=\omega_0\) and
\(\widetilde\Gamma_0=\sqrt{\ell_0}\Gamma_0\),
so \(\widetilde\theta_0=\ell_0\theta_0\).
All scalar and vorticity supports lie in a small smooth wall
patch and away from the physical axis and periodic seam.

There is a direct smooth zero-flux velocity construction.
For physical source \(\widetilde\omega_0\), solve
\[
 -(\partial_{RR}+3R^{-1}\partial_R+\partial_{ZZ})b
       =\widetilde\omega_0,\qquad b|_{R=a(Z)}=0 .
 \tag{R48}
\]
This is the ordinary Dirichlet Poisson problem on the smooth
five-dimensional domain with four radial variables and periodic
\(Z\). The source extends smoothly at the axis because it is
zero nearby. Uniqueness and rotational symmetry give a smooth
solution \(b=b(R^2,Z)\). Set
\[
 \mathcal P=R^2b,\qquad u^R=-Rb_Z,\quad
 u^Z=2b+Rb_R,\quad u^\vartheta=\widetilde\Gamma_0/R.
 \tag{R49}
\]
Then
\(-(\partial_{RR}-R^{-1}\partial_R+\partial_{ZZ})\mathcal P
 =R^2\widetilde\omega_0\).
The resulting velocity is divergence-free, smooth in Cartesian
coordinates at the axis, tangent to the physical wall, and has
zero axial flux. Its swirl is zero near the axis.
It is smooth on a compact periodic domain and consequently has
finite kinetic energy.
Physical reflection in \(Z\) makes \(u^Z\) odd and \(u^R,u^\vartheta\)
even. Euler preserves that symmetry. Incompressibility makes
the cross-sectional flux constant in \(Z\), and oddness makes
that constant zero for all time. Thus the zero-flux inverse is
not lost to a generated harmonic through-flow.

Local smooth Euler existence is used in the usual classical sense
on this smooth compact domain with impermeable boundary.
There is also a direct continuation argument in these variables.
On every finite normalized time interval (R28) and the original
Holder components bound the physical vorticity in a Holder space;
\(\ell,C_\omega\) and their inverses are finite on such an interval.
The support stays away from the axis and seam. Elliptic estimates
for (R48) therefore bound the meridional velocity gradient.
The physical swirl momentum \(\widetilde\Gamma\) is transported,
so its gradient stays finite by the differentiated transport
equation and Gronwall. Since its support is away from \(R=0\),
the full velocity gradient stays finite.
For higher smoothness one may differentiate the coupled
vorticity and swirl-momentum equations: \(k\) derivatives of
vorticity and \(k+1\) of swirl momentum form a closed estimate
because the meridional inverse gains one velocity derivative.
The top-order terms are linear in these two norms, with finite
lower-order coefficients. Induction and Gronwall prevent loss
of smoothness on a finite normalized interval. This is a
continuation argument, not an additional uniform higher-derivative
bootstrap norm. In particular no derivative of a square root is
inferred from a bound on \(\nabla\theta\).

The improved inequalities in Sections 5--6 therefore hold for
all normalized time. With
\[
 \frac{dt}{d\tau}=C_\omega,\qquad
 \frac{C_\omega'}{C_\omega}=c_{\omega,\kappa},\qquad
 \ell'=-c_l\ell ,
 \tag{R50}
\]
(R40) gives
\[
 T_{\rm phys}=\int_0^\infty C_\omega(\tau)\,d\tau<2C_\omega(0)<\infty .
 \tag{R51}
\]
At the distinguished wall point the conformal derivative is one,
the physical radius is one and the meridional velocity vanishes.
Consequently its physical axial strain is exactly
\[
                 \partial_Zu^Z=-a_\kappa/C_\omega .
 \tag{R52}
\]
By (R40) its magnitude tends to infinity. This is a genuine
physical velocity-gradient singularity, not a numerical
near-solution or just a shrinking coordinate scale.

Subject to independent verification of the argument and the
stated imported quantitative package, this establishes the
claimed extension for every fixed \(0<|\kappa|\leq1/10\).
It does not assert a whole-space Euler theorem.

## 8. Comparison with the preceding result and remaining review

The previous supported result obtained a strain/support comparison
only after assuming an evolving small remainder norm in (F18).
Here the source bound (R28) comes from the original sixteen-component
energy and original coefficient caps; (R35)--(R39) and (R36)
close those quantities together. In particular the linear
reference-strain histories are retained in the original kernels,
not estimated as small geometry.

The exact script checks the new jet projections, response
normalizations, coefficient identities, atomic endpoint
calculus, margin allocations and the physical inverse algebra.
It does not prove the uniform analytic bound (R30), the imported
numerical inequalities, or the Euler theorem. Those are the
principal targets for Host-invoked independent review.
The manuscript is therefore an author-level closure argument,
not an independently accepted milestone or a publishable-acceptance
record. The bounded literature comparison found no verified
prior inclusion of this specific variable-radius smooth pipe;
absence of a retrieved example does not certify novelty.
The closest verified source statement here is Chen--Hou's
constant-radius periodic-cylinder theorem, not a theorem for
arbitrary smooth nonconstant-radius pipes. Their 2026 finite-rank
correction note, arXiv:2607.15256v1, describes the analytic
correction method; that method is prior work, not the novelty
claimed for a possible curved-wall application.
