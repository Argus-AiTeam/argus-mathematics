# The boundary-Sobolev frame and Hessian bridge

## Result and scope

**Theorem 1 (the literal bridge).** Let \(X\) have exactly the hypotheses
in the staged manuscript: it is compact, connected, Kahler, of complex
dimension \(n\geq1\), and has no nonconstant entire curve. Let
\(f:\overline D\to X\) be continuous, holomorphic on \(D\), and
\(W^{1,p}\), for a finite \(p>2\). Let \(h\) be a smooth Kahler metric.
There is a single continuous, everywhere nonsingular holomorphic frame
\(B\) of \(f^*T^{1,0}X\), boundary \(h\)-unitary, such that
\[
 B\in W^{1,\rho}(D)\quad\text{for every }2<\rho<\frac{4p}{p+2}.
 \tag{1}
\]
For each such \(\rho\) there is a centered holomorphic family \(F(t,z)\),
continuous on a parameter ball times \(\overline D\), with
\[
 F(0,z)=f(z),\qquad F(t,0)=f(0),\qquad F_{t_j}(0,z)=zb_j(z).
 \tag{2}
\]
In fixed local target charts it is holomorphic in \(t\) with values in
\(W^{1,\rho}\). With exactly the manuscript's normalizations
\[
 A_q=\pi^{-1}\int_D q(f',f')\,dS,\quad
 P_q=2\pi^{-1}\int_D\log(1/|z|)q(f',f')\,dS,\quad
 R_h=-i\partial\bar\partial\log\det h,
 \tag{3}
\]
and \(\mathcal L=\sum_j\partial_{t_j}\partial_{\bar t_j}|_0\),
putting \(N=B^*h(f)B\) gives
\[
\begin{split}
 \log\det N(0)&=P_{R_h}(f),\\
 \mathcal Ld(F_t)&=\operatorname{tr}(B(0)^*k(f(0))B(0)),\\
 \mathcal LP_q(F_t)&=\langle\operatorname{tr}_h q\circ f\rangle_1,\\
 \mathcal LA_h(F_t)&=n-A_{R_h}(f).
\end{split}\tag{4}
\]
Here \(q\) is **any smooth closed real \((1,1)\)-form**, not necessarily
positive. All differentiations of integrals in (4) are justified below.
No holomorphic continuation, differentiable boundary values, scalar
spectral factorization, or simultaneous diagonalization is assumed.
If the given Sobolev exponent is infinity, use any finite \(p>2\);
this already supplies the frame and family required by the literal claim.

The proof actually works on an arbitrary complex manifold, with compact
image of the closed disc, for any smooth Hermitian metric in the frame
step and any smooth Kahler metric in the area identity. This is a
consequence, not a weakening of the stated hypotheses.

This is an analytic proof, conditional only on the explicit standard
inputs below, accompanied by exact symbolic diagnostics. It is **not**
a Lean/kernel verification of the analytic theorem. It does not certify
`ex:maximizer`, `ex:regularity`, `nef:disc-bound`,
`prop:volume-lower-bound`, or canonical ampleness.

## Scope findings and external inputs

The starting campaign ledger had no earlier mathematical result, only
the open objective. The inherited Wiki index had no directly matching
Hessian/Sobolev/Kobayashi entry. The current proof therefore improves
on no earlier campaign theorem; it supplies the first complete proposed
bridge proof here. A bounded web search found no directly matching
independent trace-area statement. That search is not a novelty proof.
The source manuscript already states (4), so those formulas themselves
are not claimed as new discoveries.

Compared with the staged proof, the additions are the explicit interval
(1), a direct holomorphic contraction replacing the Banach
implicit-function citation, the conditional critical-\(W^{1,2}\)
identity theorem, and the finite Blaschke multiplier formula.
The last two are structural extensions, not evidence that the full
ampleness argument has been checked.

The external propositions actually used are:

* **A-CG:** the solid Cauchy-Green operator is a bounded right inverse
  \(L^r(D)\to W^{1,r}(D)\), \(1<r<\infty\). Sukhov--Tumanov,
  *Symplectic nonsqueezing in Hilbert space and discrete Schrodinger
  equations*, arXiv:1411.3989v4, Section 4.1, the paragraph after the
  definition of \(T\), printed p. 11.
* **A-OKA:** Theorem 1.3 of Forstneric--Prezelj,
  *Oka's principle for holomorphic fiber bundles with sprays*,
  Math. Ann. 317 (2000), 117--154,
  DOI `10.1007/s002080050361`, printed p. 118, together with Example
  (A), p. 119. A locally trivial holomorphic bundle over a Stein base
  whose fiber admits a dominating spray has the section Oka principle;
  complex Lie groups admit such sprays. We apply this to the
  **frame bundle with fiber \(GL_n(\mathbb C)\)**, not to the target \(X\).
  The disc is Stein, for example by its strictly subharmonic exhaustion
  \(-\log(R^2-|z|^2)\).
* **A-MORREY:** the planar embedding
  \(W^{1,r}\hookrightarrow C^{0,1-2/r}\), \(r>2\), as explicitly
  recorded in Sukhov--Tumanov, Section 2.4, (8) and the following
  paragraph, printed p. 8.

The two primary PDFs and their searchable text are local. Short
transcribed passages are in `literature/cauchy-morrey-excerpt.txt` and
`literature/oka-excerpt.txt`. The Engineer has read them; their independent
attribution is reserved for the Reviewer. The citation tool's
`attribute` command unconditionally archives in `research/literature/`,
outside this mission's writable paths. It has not been used to bypass
that boundary, and no independent citation verdict is claimed.

Weak product and smooth-chain rules follow by smooth approximation in
\(W^{1,r}\) and uniform convergence from Morrey. For example,
\(D(uv)=uDv+vDu\) follows by taking limits in \(L^r\); the same
argument gives \(D(G(u))=DG(u)Du\) when the ranges lie in a compact
subset of \(G\)'s domain. The norm
\(\|u\|_\infty+\|Du\|_r\) is an equivalent algebra norm. Taylor's formula,
followed by this chain rule, gives the smooth composition maps used below.
No matrix spectral-factorization theorem, disc-spray existence theorem,
or Banach implicit-function theorem is being imported.

The tempting route "verify finitely many matrices, therefore the
analytic bridge holds" is retired in the claim ledger. Its obstruction
is mathematical, not lack of testing: it cannot establish a frame,
integrate a section, or control a weak boundary flux.

## 1. An initial Sobolev holomorphic frame

First obtain a nonsingular \(W^{1,p}\) frame \(v\) of the continuous
pullback bundle. Here is an explicit justification of the topological
step. A finite local trivialization and smooth source cutoffs give an
embedding of the bundle into a fixed \(\mathbb C^M\), with continuous
\(W^{1,p}\) orthogonal projection \(P(z)\) onto its image. One may
use cutoffs \(\chi_i\) with \(\sum_i\chi_i^2=1\); the embedding sends
a vector to its chart coefficients multiplied by the \(\chi_i\).
The formula \(J(J^*J)^{-1}J^*\) in each trivialization proves the
claimed regularity of \(P\).

Uniform continuity of \(P(tz)\) allows a finite subdivision
\(0=t_0<\cdots<t_m=1\) such that
\(\|P(t_{j+1}z)-P(t_jz)\|<1/2\) for all \(z\).
The restriction of \(P(t_{j+1}z)\) to the range of \(P(t_jz)\)
is an isomorphism: a vector in its kernel would have norm at most
half its norm. Transport a fixed basis of \(\operatorname{ran}P(0)\)
through these finitely many projections. The resulting frame is
continuous and \(W^{1,p}\). Indeed each \(P(t_jz)\), \(t_j>0\), is
\(W^{1,p}\) by change of variables, while \(P(0)\) is constant.
Undoing the embedding preserves the same regularity.

In the frame \(v\), the holomorphic structure is
\(\bar\partial+a\), \(a\in L^p\). Extend \(a\) by zero to \(D_R\),
\(R>1\). On a sufficiently small disc \(U\), solve
\[
 U_i=I-T_U(aU_i).
 \tag{5}
\]
The kernel and Holder's inequality give
\(\|T_U g\|_\infty\le C_p r^{1-2/p}\|g\|_p\);
A-CG gives the \(W^{1,p}\) bound, by scaling. Choose the radius so
that the fixed-point operator has norm less than \(1/3\).
It is a contraction on the sup-norm ball of radius \(1/2\) about
\(I\), so its solution is continuous, invertible, \(W^{1,p}\),
and satisfies \(\bar\partial U_i=-aU_i\).

On overlaps, \(U_i^{-1}U_j\) is weakly holomorphic, hence
holomorphic by the scalar Weyl lemma. These matrices define a
holomorphic vector bundle on \(D_R\), topologically trivial:
the local maps \(U_i\) identify its underlying continuous bundle
with \(D_R\times\mathbb C^n\). Its frame bundle has a continuous
section and fiber \(GL_n(\mathbb C)\). A-OKA supplies a holomorphic
section, i.e. a holomorphic frame. In the local gauges it has
holomorphic coefficients, hence in the original coordinates it is
\(W^{1,p}\) on compact subsets of \(D_R\).
Restriction to the closed unit disc and multiplication by \(v\)
give the required initial frame \(e\).

## 2. Matrix factorization with an explicit exponent

Set \(M=e^*h(f)e\). Then \(M\in W^{1,p}\cap C^0(\overline D)\)
and \(mI\le M\le CI\). On vector Hardy space \(H^2\), use the
equivalent norm \(\|u\|_M^2=\int u^*Mu\,d\theta/(2\pi)\).
Multiplication by \(z\) is an isometry, and \(zH^2\) has
codimension \(n\). Choose an orthonormal basis \(s_a\) of
\(W=H^2\ominus_M zH^2\), and set \(S=(s_1,\ldots,s_n)\).

The shifts \(z^js_a\) form an orthonormal basis: iteration of
\(H^2=W\oplus_M zH^2\) leaves only \(\bigcap_jz^jH^2=\{0\}\).
Taking all their scalar products identifies every Fourier coefficient
of \(S^*MS\), so
\[
 S^*MS=I\quad\text{a.e. on }S^1.
 \tag{6}
\]
Consequently \(S\) has bounded boundary values and is holomorphically
bounded inside. It is invertible at every interior point: otherwise
a nonzero covector annihilating the range at that point would
annihilate the evaluations of every \(z^js_a\), hence, by density
and bounded evaluation, of every \(H^2\) function. Constants
contradict this. No bound on \(S^{-1}\) has yet been assumed.

For \(|\theta|<1/4\), radial integration and Holder's inequality
give
\[
 \|M_\theta-M\|_{L^p(S^1)}
 \le C|\theta|^{1-1/p}.
 \tag{7}
\]
For clarity, choose \(\rho\in[1-2t,1-t]\), \(t=|\theta|\),
with \(\|M_\alpha(\rho,\cdot)\|_p\le Ct^{-1/p}\|DM\|_p\).
Integrating radially from \(\rho\) to \(1\), then translating
through angle \(\theta\) at radius \(\rho\), proves (7).
The weights \(\rho\,d\rho\) and \(d\rho\) are comparable here.
Approximation proves the assertion for the given Sobolev matrix.
Thus \(M|_{S^1}\in H^s(S^1)\) for every \(s<1-1/p\),
by integrating squared \(L^2\) translation differences.

Let \(\Pi\) be the Hardy projection and \(T_Mv=\Pi(Mv)\).
This self-adjoint operator is bounded below by \(mI\), so its
range is closed and dense and it has a bounded inverse.
Each column \(v\) of \(S\) satisfies \(T_Mv=c\), a constant.
Rotate and subtract:
\[
 T_M(v_\theta-v)=\Pi((M-M_\theta)v_\theta),\qquad
 \|v_\theta-v\|_2\le C\|M_\theta-M\|_2.
 \tag{8}
\]
The already proved \(H^\infty\) bound on \(v_\theta\) justifies
the second assertion. It follows that \(v\in H^s\) for all
\(s<1-1/p\).

For \(s>1/2\), its Taylor series is absolutely uniformly
convergent on \(\overline D\). If \(v=\sum_{\ell\ge0}v_\ell z^\ell\),
Parseval and Cauchy--Schwarz give, for \(r>1/2\),
\[
 \|v'(r\cdot)\|_2\le C(1-r)^{s-1}\|v\|_{H^s},\quad
 \|v'(r\cdot)\|_\infty\le C(1-r)^{s-3/2}\|v\|_{H^s}.
 \tag{9}
\]
Interpolation bounds the \(\rho\)-th power of its \(L^\rho\)
circle norm by \(C(1-r)^{\rho(s-3/2)+1}\).
It is radially integrable precisely when
\(\rho<2/(3/2-s)\).
For every \(\rho\) in (1), choose
\[
 \max(1/2,\,3/2-2/\rho)<s<1-1/p.
 \tag{10}
\]
This proves (1) for the *same* \(S\), not a different factor
for every exponent. Continuity upgrades (6) to every boundary
point, where it also gives invertibility. Interior invertibility
and compactness now give a uniformly bounded inverse. Finally
\(B=eS\) has all the asserted properties.

## 3. Centered families: a direct holomorphic contraction

We prove the stronger assertion that any finite list of holomorphic,
continuous \(W^{1,\rho}\) sections \(V_a\), with \(V_a(0)=0\),
is integrable in the required class. Write \(V_a=e\,v_a\).

Choose finitely many fixed source patches, target charts \(\phi_i\),
and a smooth source partition \(\rho_i\). Put
\[
 A_i=D\phi_i(f)e,\quad
 C_i(z,y)=A_i(z)^{-1}(\phi_i(y)-\phi_i(f(z))),\quad
 \Phi(z,y)=\sum_i\rho_i(z)C_i(z,y).
 \tag{11}
\]
Supports are compactly contained in the relevant source patches.
Near each graph point every participating target chart is defined
on a common neighborhood. Finiteness and compactness make these
neighborhoods uniform after shrinking. The maps \(C_i\) are
holomorphic in \(y\) and in the interior source variable at fixed \(y\).
Also \(\Phi(z,f(z))=0\) and \(D_y\Phi(z,f(z))e(z)=I\).

Uniformly in \(z\), normalize in a fixed target chart by
\(K_z(v)=\Phi(z,\psi^{-1}(c(z)+e_\psi(z)v))\).
For a common radius \(R\), \(K_z(0)=0\) and
\(\|DK_z-I\|\le1/4\) on the radius-\(R\) ball.
The contraction \(v=\xi-(K_z(v)-v)\), \(|\xi|<R/2\),
defines a continuous inverse \(E(z,\xi)\), holomorphic in
\(\xi\), satisfying
\[
 E(z,0)=f(z),\quad E_\xi(z,0)=e(z),\quad
 \Phi(z,E(z,\xi))=\xi.
 \tag{12}
\]
Local inverses agree by uniqueness in the graph neighborhood;
uniformly shrinking the fiber radius makes these a single map.

Here are the regularity details that a purely continuous tubular
neighborhood would not supply. In each chart the inverse is a
smooth finite-dimensional function of the coefficient list
\((\rho_i,A_i^{-1},\phi_i(f),c,e_\psi)_i\) and of \(\xi\).
The inverse-function estimates are uniform on the compact range
of that list and a smaller closed fiber polydisc. The weak source
derivatives of \(E(\cdot,\xi)\) are therefore bounded by one
\(L^\rho\) function, uniformly in \(\xi\). Fiber derivatives
satisfy the same bound on a still smaller polydisc, by Cauchy's
formula. In the expansion \(E(z,\xi)=\sum_\alpha E_\alpha(z)\xi^\alpha\)
one consequently has
\[
 \|E_\alpha\|_\infty+\|DE_\alpha\|_\rho\le Cr^{-|\alpha|}.
 \tag{13}
\]
Weak source differentiation under the fiber Cauchy integrals is
justified by that common \(L^\rho\) bound. The algebra norm and
the polynomial number of multiindices at each degree imply normal
convergence of \(\sum E_\alpha u^\alpha\) for small
\(u\in W^{1,\rho}\). Thus substitution into \(E\) is a
holomorphic map into each local \(W^{1,\rho}\) coordinate space.

The condition that \(E(z,u(z))\) be holomorphic is
\[
 \bar\partial u+Q(z,u)=0,\quad
 Q=E_\xi^{-1}\bar\partial_zE
   =-\sum_i(\bar\partial\rho_i)\,C_i(z,E(z,\xi)).
 \tag{14}
\]
The formula is invariant under holomorphic target coordinate
changes. In particular \(Q\) is continuous, uniformly bounded
on a smaller fiber polydisc, and holomorphic in \(\xi\).
Equations (11)--(12) give
\[
 Q(z,0)=0,\qquad Q_\xi(z,0)=
       -\sum_i(\bar\partial\rho_i)I=0.
 \tag{15}
\]
Its fiber series and the sup-norm embedding imply that
\(\mathcal Q:u\mapsto Q(\cdot,u)\) is holomorphic
\(W^{1,\rho}\to L^\rho\), with
\(\|\mathcal Q(u)\|_\rho=O(\|u\|_{W^{1,\rho}}^2)\) and
\(\|D\mathcal Q(u)\|=O(\|u\|_{W^{1,\rho}})\).

By A-CG and A-MORREY,
\(Hg=Tg-(Tg)(0)\) is bounded \(L^\rho\to W^{1,\rho}\),
\(\bar\partial Hg=g\), and \(Hg(0)=0\).
Solve
\[
 g=-\mathcal Q\left(\sum_a v_at_a+Hg\right).
 \tag{16}
\]
For a fixed sufficiently small \(L^\rho\) ball and small
parameter ball the right side maps the ball to itself and has
Lipschitz constant less than \(1/2\), by (15).
Its iterations starting at zero are holomorphic in \(t\) and
converge uniformly on the parameter ball, so their limit \(g(t)\)
is Banach-holomorphic. The quadratic bound gives \(g(t)=O(|t|^2)\).
Consequently
\[
 u(t)=\sum_a v_at_a+Hg(t),\qquad F(t,z)=E(z,u(t,z))
 \tag{17}
\]
has exactly the prescribed first derivatives and the fixed center.
Substitution gives the stated \(W^{1,\rho}\) parameter dependence.
The equation implies weak, hence ordinary, holomorphy in \(z\).
Bounded point evaluation gives holomorphy in \(t\); local separate
holomorphy gives joint holomorphy. Sobolev embedding gives joint
continuity up to the boundary. All sufficiently small parameters
stay in the fixed chart neighborhoods and have finite area.
Taking \(V_j=zb_j\) proves (2).

## 4. Differentiating the functionals and the local identity

In each fixed chart, \(t\mapsto F\) is holomorphic into
\(W^{1,\rho}\), hence smooth as a real Banach map.
For any smooth tensor \(q\), smooth composition and multiplication
\(L^\rho\cdot L^\rho\to L^{\rho/2}\) show that
\[
 t\longmapsto q(F_z,F_z)
 \quad\text{is }C^2\text{ into }L^{\rho/2}.
 \tag{18}
\]
Every parameter derivative has only two first source derivatives;
all other factors are bounded smooth functions or continuous
Sobolev parameter derivatives. A fixed source partition gives
(18) globally. Because \(\rho/2>1\), integration against \(1\)
or \(\log(1/|z|)\) is a bounded linear functional on this space,
by Holder's inequality. This proves differentiation under both
integrals without a moving target chart or a boundary derivative.

A smooth closed real \((1,1)\)-form has a local real potential.
For completeness, write \(q=d\alpha\) locally by the radial
Poincare homotopy. Its type gives
\(\bar\partial\alpha^{0,1}=0\); the local Dolbeault primitive
(obtained on a smaller polydisc by the Cauchy-Green homotopy)
gives \(\alpha^{0,1}=\bar\partial g\).
Since \(\alpha\) is real,
\(q=\partial\bar\partial(g-\bar g)=i\partial\bar\partial(2\operatorname{Im}g)\).
Thus \(q=dd^c\phi\).
In matrix notation compatible with column vectors \(v^*qv\),
the entry \(q_{ab}\) is \(\phi_{w_b\bar w_a}\).
Joint holomorphy and interior smoothness now imply
\[
 \mathcal L q(F_z,F_z)
   =\partial_z\partial_{\bar z}
       \left(|z|^2\operatorname{tr}(B^*q(f)B)\right).
 \tag{19}
\]
There are no mixed holomorphic/antiholomorphic parameter derivatives
of \(F\) itself. Both sides of (19) are in \(L^{\rho/2}\), by (18).

For the central term, Cauchy's formula on a smaller source circle
makes \(t\mapsto F_z(t,0)\) holomorphic in \(T_{f(0)}X\).
Its first parameter derivatives are \(b_j(0)\).
Differentiating its squared \(k(f(0))\) norm gives the second
identity in (4).

## 5. Determinant and Poisson identities

Set \(U=\log\det N\). Smoothness inside, continuity, uniform positive
definiteness, and the weak chain rule give \(U\in W^{1,\rho}\).
In a holomorphic chart,
\[
 \partial_z\partial_{\bar z}U
 =\partial_z\partial_{\bar z}\log\det h(f)
 =-R_h(f',f'),
 \tag{20}
\]
because the other summand is \(\log|\det B|^2\), harmonic.
The right side is \(L^{\rho/2}\). The normalized planar Green
identities are
\[
\begin{split}
 \langle u\rangle_r-u(0)
 &=\frac2\pi\int_{|z|<r}\log(r/|z|)
                  \partial_z\partial_{\bar z}u\,dS,\\
 \pi^{-1}\int_{|z|<r}\partial_z\partial_{\bar z}u\,dS
 &=\frac r2\langle u_r\rangle_r .
\end{split}\tag{21}
\]
These follow directly from the divergence theorem and
\(\Delta=4\partial_z\partial_{\bar z}\); Holder and continuity
pass the first identity to \(r=1\).
Since \(U=0\) on the boundary, (20)--(21) give
\(\log\det N(0)=P_{R_h}(f)\), with a **plus** sign.

Apply the first identity of (21) to
\(|z|^2\operatorname{tr}(B^*qB)\).
Its central value is zero and its boundary value is
\(\operatorname{tr}_h q\circ f\).
Equations (18)--(19) prove the third identity in (4).

## 6. The weak boundary flux, including the critical exponent

**Lemma 2.** Suppose a positive Hermitian matrix \(N\) is smooth in
\(D\), continuous and uniformly positive definite on \(\overline D\),
\(W^{1,2}\), and equal to \(I\) on \(S^1\). There is a sequence
\(r_\nu\uparrow1\) such that
\[
 \left\langle(\operatorname{tr}N)_r-
                      (\log\det N)_r\right\rangle_{r_\nu}\longrightarrow0.
 \tag{22}
\]
No commutativity assumption is needed.

Indeed, Jacobi's determinant formula and trace cyclicity give
\[
 (\operatorname{tr}N)_r-(\log\det N)_r
       =\operatorname{tr}((I-N^{-1})N_r).
 \tag{23}
\]
This formula does not differentiate individual eigenvectors.
In every dimension Jacobi's formula follows by differentiating the
Leibniz determinant polynomial to obtain
\((\det N)'=\operatorname{tr}(\operatorname{adj}(N)N')\), and using
\(\operatorname{adj}(N)=(\det N)N^{-1}\). Thus the argument is not
an extrapolation from the two-dimensional diagnostic.
Let \(g(r)=\|N_r(r,\cdot)\|_2^2\) and
\(E(r)=\int_r^1g(s)\,ds\). Radial absolute continuity for
Sobolev functions and the boundary value \(I\) give, for \(r>1/2\),
\[
 \|N(r,\cdot)-I\|_2\le\sqrt{1-r}\sqrt{E(r)}.
 \tag{24}
\]
The equality of the radial trace with the continuous boundary value
follows on almost every ray. Interior smoothness then identifies
the same circle functions at every \(r<1\).
Uniform boundedness of \(N^{-1}\), Cauchy--Schwarz, and (23) bound
the absolute value of the mean in (22) by
\[
 C\sqrt{(1-r)g(r)E(r)}.
 \tag{25}
\]
Here \(g\in L^1(1/2,1)\) and \(E(r)\to0\).
There are arbitrarily large radii with \((1-r)g(r)\le1\):
otherwise \(g(r)>1/(1-r)\) on a terminal interval, contradicting
integrability. Choose such an increasing sequence. Equation (25)
proves (22).

For Theorem 1, set \(T=\operatorname{tr}N\). Integrate (19) with
\(q=h\) on an interior disc, using \(h\)'s closedness:
\[
 \pi^{-1}\int_{|z|<r}\mathcal Lh(F_z,F_z)\,dS
       =r^2\langle T\rangle_r+\frac{r^3}{2}\langle T_r\rangle_r .
 \tag{26}
\]
Its left side has a unique limit by (18), and
\(\langle T\rangle_r\to n\).
Equations (20)--(21) give for **every** interior radius
\[
 \frac r2\langle U_r\rangle_r=-A_{R_h,r}(f)
                      \longrightarrow-A_{R_h}(f).
 \tag{27}
\]
Substitute (22) into (26) along its sequence. The second term
converges to \(-A_{R_h}(f)\).
The left side's sequence-independent limit proves the last
identity in (4). This completes the proof of Theorem 1.

**Theorem 3 (conditional critical-regularity extension).**
If the frame is already given in \(C^0\cap W^{1,2}\), nonsingular
on the closure and boundary-unitary, and the centered family is
holomorphic in parameters into the local Banach algebra
\(C^0\cap W^{1,2}\), with the prescribed derivatives, all of (4)
still holds. This theorem **does not assert** existence of the
frame or family at \(p=2\).

To prove it, products in (18) are \(C^2\) into \(L^1\).
On a fixed smaller central disc, Cauchy's formula and parameter
holomorphy also give \(C^2\) dependence of the densities in the
uniform norm. Integration against the logarithmic weight is
continuous on the space with norm
\(\|u\|_{L^1(D)}+\|u\|_{C^0(|z|\le1/2)}\).
Similarly (21) passes to \(r=1\) for an interior-smooth function
whose Laplacian is \(L^1\): split at radius \(1/2\), where the
weight is bounded outside and the Laplacian is bounded inside.
Dominated convergence applies to both pieces.
The determinant chain rule and Lemma 2 need only \(W^{1,2}\).
These observations repeat the preceding proof at the endpoint.

**Theorem 4 (finite Blaschke multipliers).**
Let \(\psi\) be a finite Blaschke product of degree \(m\), with
\(\psi(0)=0\). Under Theorem 1 replace \(zb_j\) by \(\psi b_j\).
The family still exists, and the Poisson formula is unchanged,
whereas
\[
 \mathcal Ld=|\psi'(0)|^2\operatorname{tr}(B(0)^*kB(0)),\qquad
 \mathcal LA_h=mn-A_{R_h}(f).
 \tag{28}
\]
The determinant formula is unchanged as well.
The general section construction proves existence. In (19) replace
\(|z|^2\) by \(|\psi|^2\). This function vanishes at the center,
equals one on the boundary, and is smooth past the boundary.
Its boundary radial derivative has mean \(2m\): each factor
\((z-a)/(1-\bar a z)\) contributes
\(2(1-|a|^2)/|e^{i\theta}-a|^2\), whose mean is two.
In the area flux the term differentiating \(|\psi|^2\)
therefore tends to \(mn\).
The remaining term is \((r/2)\langle|\psi|^2T_r\rangle_r\).
Replacing \(|\psi(r e^{i\theta})|^2\) by one contributes at most
\(C(1-r)\|N_r(r,\cdot)\|_2\), which tends to zero along
the sequence used in Lemma 2. Equations (22), (27) prove (28).
Theorem 3 also applies conditionally to these multipliers.
No claim of literature-verified novelty is made for this extension.

## 7. Exact diagnostics and their boundaries

`verify.py` uses exact SymPy arithmetic, not random tests or floating
point quadrature. Its machine claims are only those enumerated in
`exact_certificate.json`.

### A genuinely complex, noncommuting curved model

On the chart domain
\(U=\{|w_1|^2<3/2,\ |w_2|<1/8\}\subset\mathbb C^2\), set
\[
 \phi=\tfrac34|w_1|^2+\tfrac1{16}|w_1|^4+|w_2|^2
        +\tfrac18(|w_1|^2-1)^2(w_2+\bar w_2),\qquad h=dd^c\phi .
 \tag{29}
\]
The Hermitian coefficient \(h_{22}=1\);
\(h_{11}\ge5/8\), \(|h_{12}|^2\le3/32\), so
\(\det h\ge17/32>0\). Thus this is a smooth Kahler metric.
For \(f(z)=(z,0)\) and \(B=I\),
\[
 N=\begin{pmatrix}(3+u)/4&z(u-1)/4\\
              \bar z(u-1)/4&1\end{pmatrix},\qquad
 D(u)=\det N=\frac{12+3u+2u^2-u^3}{16},\quad u=|z|^2.
 \tag{30}
\]
It is boundary-unitary. The matrices at \(z=1/2\) and \(z=i/2\)
have a nonzero commutator. Its Ricci pullback is
\(-[u(\log D)'(u)]'\), not zero. The exact values are
\[
 P_{R_h}=\log(3/4),\quad A_{R_h}=-1/4,\quad
 \mathcal LA_h=9/4,\quad \mathcal LP_h=2.
 \tag{31}
\]
The family \(F(t,z)=(z(1+t_1),zt_2)\) realizes (2).
The verifier differentiates the potential and the family independently
of the trace formula, checks (19), and checks the rational curvature
primitive and its endpoints. This is a local curved diagnostic,
**not a compact target or an admissible counterexample to the manuscript**.
The Blaschke choice \(\psi=z(z-1/2)/(1-z/2)\) separately gives
degree two, central multiplier \(1/4\), and area trace \(17/4\).

The symbolic Jacobian operation accepts rational-function fields, not
complex conjugation or Sobolev objects. Its term-budget estimator
rejected the \(4\)-by-\(4\) polynomial realification of (30), with
\(z=x+iy\), before execution (`matrix.budget_exceeded`, adapter exit 2).
The rejected payload and structured error are preserved. This is a
capability limitation and **no mathematical verdict**.
The replay checks that realification's determinant
\(D(x^2+y^2)^2\) locally with exact symbolic arithmetic.
For Jacobian's narrower rational operation we use the exact
specialization \(x=y=1/2\), whose determinant is \(12321/16384\).
Both inspected contracts, the exact typed payloads, and typed responses
are in `jacobian/`. A specialized determinant check does not check the
analytic proof, the choice of complex orientation, or positivity.

### A curved example with no boundary holomorphic extension

Fix a compact Brody-hyperbolic Riemann surface \(X\) and a chart
\(|w|<1\). Choose a smooth positive metric that equals
\(h(w)=\exp(256|w|^4)|dw|^2\) for \(|w|\le1/2\).
It extends to \(X\) by a positive smooth interpolation; in complex
dimension one every such Hermitian metric is Kahler.
In that chart put
\[
 f(z)=\tfrac14\sqrt{1-z},\qquad B(z)=e^{z-1},\qquad
 F(t,z)=f(z)+tzB(z),\quad |t|<1/16 .
 \tag{32}
\]
The branch is continuous on the closed disc. Its image, and those of
the displayed small variations, lie in \(|w|<1/2\).
Here \(|f'|^2=1/(64|1-z|)\), and a polar
integral at \(z=1\) proves \(f\in W^{1,p}\) exactly for \(1\le p<4\).
There is no holomorphic extension across \(1\): the equation
\(f(z)^2=(1-z)/16\) would make an even-order zero equal a
simple zero.
Despite this, directly
\[
 \log N=|z|^2-1,\quad R_h(f',f')=-1,\quad
 P_{R_h}=A_{R_h}=-1,\quad \mathcal LA_h=2,\quad
 \mathcal LP_h=1.
 \tag{33}
\]
With \(k=h\), the central Hessian is \(e^{-1}\).
The verifier checks these scalar identities, the radial primitives,
the singular integrability exponent, and the image-size bound.
The construction and the zero-order argument are analytic proofs,
not outcomes inferred from finite sampling.

## What remains unverified

The primary-source applicability and every analytic step above require
independent human mathematical review. SymPy and Jacobian certify
neither arbitrary-dimensional analysis nor novelty. No Lean file is
offered: a routine scalar/matrix formalization would not check the
load-bearing Sobolev construction or the limiting argument.
The claim ledger records supporting Engineer judgments only, not a
kernel closure or an independent Reviewer verdict. In particular this
report cannot be used as evidence that the whole ampleness conjecture
has been settled.
