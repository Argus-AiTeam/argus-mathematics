# Literal boundary-Sobolev/Hessian bridge

**Engineer assessment: supported under the three stated analytic inputs.**
This is a review of a prose proof, not a kernel certificate or current
independent acceptance. No mathematical gap was identified in the literal
statement. The existence and regularity of maximizing discs, and canonical
ampleness, are not conclusions of this unit.

## Statement, version, and attribution

The source is old campaign `9000051`, `research/boundary-hessian/bridge.md`,
Theorem 1, sections 1--5, and the final application in section 6. Its exact
source identity is recorded in `research/DRAFT_REVIEW_INDEX.json`. The old
claim is `BH-BRIDGE`, current version 4, with components `BH-INITIAL`,
`BH-FRAME`, `BH-SPRAY`, `BH-DIFF`, `BH-DET`, and `BH-TRACE`, all version 1.
The successive bridge versions record additional assumptions, not different
theorems or four separate results.

Let \(X\) be compact, connected, Kahler, of dimension \(n\geq1\), without
nonconstant entire curves. Let \(f:\overline D\to X\) be continuous,
holomorphic inside, and \(W^{1,p}\), \(2<p<\infty\). Let \(h\) be smooth
Kahler; the manuscript's \(k\) is a fixed smooth Kahler metric. For every
smooth closed real \((1,1)\)-form \(q\), use
\[
 A_q=\pi^{-1}\int_Dq(f',f'),\quad
 P_q=(2/\pi)\int_D\log(1/|z|)q(f',f'),\quad
 R_h=-i\partial\bar\partial\log\det h,\quad
 d(f)=|f'(0)|_k^2 .
\]
There is **one** continuous, nonsingular holomorphic frame \(B\), boundary
\(h\)-unitary, belonging to every \(W^{1,\rho}\) with
\[
                     2<\rho<4p/(p+2).
\]
For each such \(\rho\) there is a centered family, holomorphic in parameters
into the local \(W^{1,\rho}\) spaces, with
\(F(0,z)=f(z)\), \(F(t,0)=f(0)\), and \(F_{t_j}(0,z)=zb_j(z)\).
The family need not be the same for all \(\rho\). Writing
\(N=B^*h(f)B\) and \(\mathcal L=\sum_j\partial_{t_j}\partial_{\bar t_j}|_0\),
the conclusions are
\[
\begin{split}
 \log\det N(0)&=P_{R_h}(f),\\
 \mathcal Ld(F_t)&=\operatorname{tr}(B(0)^*k(f(0))B(0)),\\
 \mathcal LP_q(F_t)&=\langle\operatorname{tr}_h q\circ f\rangle_1,\\
 \mathcal LA_h(F_t)&=n-A_{R_h}(f).
\end{split}
\]
Positivity of \(q\), boundary differentiability, and holomorphic continuation
across the boundary are not hypotheses. If \(f\) is \(W^{1,\infty}\), each
finite \(p>2\) is available; this does not assert an attained limiting exponent.

These are not new manuscript identities. The reference is **OpenAI,
Canonical ampleness of compact hyperbolic Kahler manifolds, September 23,
2026**, source revision `4eaee87548250b2682affda7d05d947c05554bae`.
`build/sections/preliminaries.tex` fixes the same \(dd^c\), signs, \(d,A,P\),
and circle means. `frames-variations.tex` labels `var:initial-frame`,
`var:frame`, and `var:spray`, and `hessian.tex` labels `hes:determinant`
and `hes:trace`, contain the corresponding arguments and formulas.
The draft makes the exponent interval explicit and replaces the final
Banach implicit-function step by a holomorphic contraction. The manuscript's
own inequalities for \(s,p_0\) already imply this interval; its expression
here is not a priority or novelty certificate. The finite-list version of
the section construction is a useful formulation, not an ampleness theorem.

## Component-by-component decisive review

| Old component | Assessment and load-bearing point |
|---|---|
| `BH-INITIAL` | Supported: regular topological trivialization, small local gauges, then Oka on the frame bundle. |
| `BH-FRAME` | Supported: weighted Hardy factorization, coercive Toeplitz rotation estimate, then strict radial integrability. |
| `BH-SPRAY` | Supported: uniform fiber inverses with Sobolev coefficient estimates, followed by a quadratic centered contraction. |
| `BH-DIFF` | Supported: two source derivatives in \(L^\rho\), all other factors bounded; closedness supplies the local potential. |
| `BH-DET` | Supported: harmonic holomorphic-frame determinant and normalized Green identity, with the displayed plus sign. |
| `BH-TRACE` | Supported: central Cauchy formula, Poisson identity, and area identity using the separately reviewed flux lemma. |

### Initial frame

The continuous \(W^{1,p}\) projection \(P\) obtained from finitely many
trivializations permits a finite radial transport from \(P(0)\) to \(P(z)\).
At each step \(\|P(t_{j+1}z)-P(t_jz)\|<1/2\), so projection restricted
to the previous range is injective and hence an isomorphism between
equal-dimensional spaces. Scaling preserves \(W^{1,p}\) for each fixed
positive \(t_j\); \(P(0)\) is constant. Thus the resulting frame \(v\) has
the required regularity, without assuming a differentiable boundary frame.

In that frame the coefficient \(a\) of \(\bar\partial+a\) is \(L^p\).
Zero extension to \(D_R\), \(R>1\), is an extension of this coefficient,
**not** an extension of \(f\). The estimate
\(\|T_Ug\|_\infty\le C_pr^{1-2/p}\|g\|_p\) makes
\(U_i=I-T_U(aU_i)\) a contraction near \(I\) on small discs. The solutions
are invertible \(W^{1,p}\) matrices. On overlaps \(U_i^{-1}U_j\) is
weakly holomorphic, hence holomorphic. These matrices give a locally
trivial holomorphic bundle over \(D_R\), with a continuous trivialization.
Oka is applied to its **\(GL_n(\mathbb C)\) frame bundle**, not to \(X\).
The global holomorphic frame has \(W^{1,p}\) coefficients on the compact
closed unit disc in the local gauges. Multiplication by \(v\) finishes
this step. No Oka property of a hyperbolic target is asserted.

### Boundary-unitary factor and its exponent

Uniform positivity of \(M=e^*h(f)e\) makes the weighted Hardy norm equivalent
to the usual one. The shift is pure: the intersection of its images
\(z^jH^2\) is zero. Consequently its \(n\)-dimensional wandering space
generates all of \(H^2\), and orthogonality of all shifts identifies every
Fourier coefficient of \(S^*MS\), giving \(I\) almost everywhere.
This first supplies an \(H^\infty\) bound for \(S\). Its interior
invertibility follows from density and bounded point evaluation, not from
an unproved bound for \(S^{-1}\).

The radial/angular estimate for the boundary trace of \(M\) is
\(\|M_\theta-M\|_p\le C|\theta|^{1-1/p}\). Its squared \(L^2\) differences
give every fractional exponent \(s<1-1/p\). The coercive self-adjoint
Toeplitz operator \(T_M\) is onto: its range is closed by the lower bound
and dense because its adjoint has zero kernel. Since \(T_Mv\) is constant
for a column of \(S\), rotation yields
\[
 \|v_\theta-v\|_2\le C\|M_\theta-M\|_2.
\]
The previously established \(H^\infty\) bound is exactly what makes this
estimate valid for a matrix symbol; scalar factorization or simultaneous
diagonalization is unnecessary.

For \(s>1/2\), absolute convergence of the Taylor series gives boundary
continuity. The two derivative estimates in draft (9), interpolated for
\(\rho>2\), give the radial power
\(\rho(s-3/2)+1\). This is integrable precisely when
\(\rho<2/(3/2-s)\). A choice
\[
 \max(1/2,3/2-2/\rho)<s<1-1/p
\]
exists exactly throughout the asserted strict range. The same \(S\) works
for every such choice. Boundary continuity upgrades its almost-everywhere
normalization to every boundary point and supplies invertibility there;
compactness then gives the uniform inverse bound. Also
\(4p/(p+2)<p\), so multiplication by the original \(W^{1,p}\) frame
preserves \(W^{1,\rho}\).

### Centered integration of sections

The patched map \(\Phi(z,y)=\sum\rho_i(z)C_i(z,y)\) has fiber derivative
equal to \(e^{-1}\) at the graph. The finite cover, subordinate supports,
and compact graph allow a uniform inverse radius; no single target chart
or linear structure on \(X\) is assumed. The finite coefficient list in
draft (11)--(13) has compact range and Sobolev first derivatives. Uniform
finite-dimensional inverse estimates and fiber Cauchy estimates therefore
give
\(\|E_\alpha\|_\infty+\|DE_\alpha\|_\rho\le Cr^{-|\alpha|}\).
The Sobolev algebra estimate makes substitution into \(E\) holomorphic
in the local Banach spaces.

Differentiating \(\Phi(z,E(z,\xi))=\xi\) gives
\[
 Q(z,\xi)=-\sum_i(\bar\partial\rho_i)C_i(z,E(z,\xi)).
\]
Its constant and linear fiber terms vanish, the latter because
\(\sum_i\bar\partial\rho_i=0\). Thus \(\mathcal Q\) is quadratic at zero.
The centered right inverse \(Hg=Tg-(Tg)(0)\) is bounded for \(\rho>2\).
For any finite list of holomorphic coefficients \(v_a\) vanishing at zero,
\(g=-\mathcal Q(\sum v_at_a+Hg)\) is a contraction on one fixed small
ball, with holomorphic iterates and \(g(t)=O(|t|^2)\).
The solution preserves the center and the prescribed first variations.
The resulting weak holomorphy in \(z\), ordinary holomorphy in parameters,
and Sobolev continuity give the asserted family. This checks the
load-bearing Sobolev substitution step, not just pointwise fiber inversion.

### Differentiation, determinant, and trace

Smooth composition on \(W^{1,\rho}\), followed by multiplication of two
\(L^\rho\) source derivatives, gives a \(C^2\) density in \(L^{\rho/2}\).
Both weights are continuous integration functionals there because
\(\rho/2>1\). Fixed charts and a fixed partition avoid a moving-chart
differentiation problem. Locally \(q=i\partial\bar\partial\phi\);
the local Poincare/Dolbeault calculation in the draft uses closedness,
not positivity. Joint holomorphy then gives the intrinsic identity
\[
 \mathcal Lq(F_z,F_z)
 =\partial_z\partial_{\bar z}
       (|z|^2\operatorname{tr}(B^*qB)).
\]
Central Cauchy differentiation gives the \(d\) identity.

For \(U=\log\det N\),
\(\partial_z\partial_{\bar z}U=-R_h(f',f')\).
Since \(U=0\) on the boundary, the normalized Green formula gives
\(0-U(0)=-P_{R_h}\), confirming the **plus** sign. Applying it to
\(|z|^2\operatorname{tr}(B^*qB)\) gives the boundary trace identity.

Finally \(T=\operatorname{tr}N\) satisfies
\[
 \pi^{-1}\int_{|z|<r}\mathcal Lh(F_z,F_z)
 =r^2\langle T\rangle_r+(r^3/2)\langle T_r\rangle_r.
\]
The left side has a unique limit. The separately assessed flux lemma
permits replacement of the derivative mean by that of \(U\) along a
sequence. For every interior radius
\((r/2)\langle U_r\rangle_r=-A_{R_h,r}\).
The right side therefore tends to \(n-A_{R_h}\). A subsequence suffices
because the integral already has a sequence-independent limit.

## External assumptions and receipts

The three propositions were checked against the locally available primary
texts, not merely their paper titles. `A-CG` is Sukhov--Tumanov,
`arxiv:1411.3989v4` (header dated 5 April 2016), section 4.1, printed p. 11,
text lines 473--480: the scalar right inverse is bounded for finite \(p>1\).
Entrywise use gives the finite-dimensional form needed here. `A-MORREY`
is section 2.4, (8) and following paragraph, printed p. 8, lines 325--328:
\(\alpha=(p-2)/p\). Taking finite-dimensional values avoids any additional
Hilbert-scale compactness claim. The product and smooth-chain rules are
explained by approximation in the draft, not attributed to this excerpt.

`A-OKA` is Forstneric--Prezelj, *Math. Ann.* 317 (2000), 117--154,
`doi:10.1007/s002080050361`, Theorem 1.3 p. 118, Definition 1.1 p. 117,
and Example (A) p. 119. The local text lines 21--29, 47--50, and
112--113 explicitly supply the continuous-section conclusion, Stein-base
hypothesis, and complex-Lie-group example. The disc is Stein and the
constructed frame bundle has the required continuous section.

Applicable old independent evidence is
`judgement-BH-BRIDGE-49dcc0b9a77b`,
`judgement-A-CG-63ebea47f928`,
`judgement-A-MORREY-9367605ca4c5`, and
`judgement-A-OKA-10ebbc6ffa33`, all produced by
`reviewer:copilot-4ea18baac059`. The component Engineer opinions are indexed
separately. The bridge statement digest is unchanged when assumptions are
added; that does not make the assumptions dispensable. No independent
receipt specifically targeting the two extension claims is inferred.

The old opinions bind their subject digests and relative artifact paths;
they do not store artifact-byte digests. The ledger, graph, and bridge
match the preserved snapshot manifest. Other old supporting files are
identified and inspected separately. A path-only receipt is not presented
as a cryptographic record of which certificate bytes a Reviewer read.

## Limits, replay decision, and unresolved overclaims

No unchanged exact checker was rerun: the prior diagnostic receipt is
applicable and the decisive work here is analytic. There is no Lean source
or real compiler certificate to replay. SymPy and Jacobian cannot certify
this construction.

The broader observation that the argument works for a compact disc image
in a general complex manifold is consistent with the proof: compactness
and hyperbolicity of the whole target are not used in the construction.
A Hermitian \(h\) suffices for the frame, but its closedness is used in
the area identity. This is not a result about arbitrary nonclosed tensors.

The concrete gap in any attempted inference to the manuscript's main
theorem is the missing supply of appropriate maximizing discs and the
subsequent global positivity arguments. Neither follows from identities
for a **given** regular disc. This does not refute those manuscript
arguments; they were not supplied or certified by this Argus draft.
Novelty remains unassessed. The current native Reviewer must decide
acceptance of this assessment and the complete family.
