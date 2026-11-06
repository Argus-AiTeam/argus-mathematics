# Primary propositions used or scoped

## Donaldson: local deformation and Stokes are known

Reader: `engineer:copilot`, directly read
<https://arxiv.org/html/math/0607083v1>, Section 2, Proposition 1 and
equation (3). Canonical document: `arxiv:math/0607083v1`.

For compact \(X\), the proposition assumes a constraint with negative
tangents and a solution with the stated cohomological transverse
condition \([\omega]\in C+H^2_+\), with \(H^2_+\) maximal positive.
It gives local uniqueness and existence under a sufficiently small
smooth parameter deformation. In the proof, the elliptic operator is
\(d^*\oplus d^+\), modulo harmonic one-forms and the corresponding
target spaces. The exact displayed identity at (3) is
\[
 0=\int_X da\wedge da
   =\int_X |d^+a|^2-|d^-a|^2.
\]
This supports the manuscript's local framework and exact-form identity,
not a family-uniform inverse estimate. It is not a new identity of the
audit.

## Gross--Wilson: the integrable K3 scope is explicit

Reader: `engineer:copilot`, directly read
<https://arxiv.org/html/math/0008018v3>, Section 0 (Introduction),
the geometric hypotheses and equations before the account of Theorem
5.6. Canonical document: `arxiv:math/0008018v3`; displayed revision
date April 2, 2001.

The introduction fixes a complex elliptic K3 fibration; its generic
case has 24 type-\(I_1\) singular fibers. The global correction is a
Kahler potential in
\[
 (\omega_\epsilon+i\partial\bar\partial u_\epsilon)^2
        =e^{F_\epsilon}\omega_\epsilon^2,\qquad
 \int_X u_\epsilon\omega_\epsilon^2=0.
\]
It describes exponential local-model tails and control of degenerating
Sobolev constants. Its hypotheses do not supply a complex structure
for the pair in the current auxiliary construction. No theorem from
this paper is being used as the missing almost-complex global inverse.

## Taylor: fixed-metric Hodge decomposition

Independent source reader: `taylor-source-reader`, a research agent,
not the mission Reviewer. The reader inspected the author PDF
<https://mtaylor.web.unc.edu/wp-content/uploads/sites/16915/2018/04/hodge.pdf>
in memory. Page 1 says revised August 2010; the URL's 2018 date is
not a revision claim. The following transcription is preserved from
that reader's returned result; the parent did not repeat the lookup.

The setup is a compact manifold without boundary, smooth metrized
bundle and first-order \(d\) with \(d^2=0\), and
\(L=dd^*+d^*d\). There is a hypoellipticity assumption; in Section 2
the subelliptic estimate (1.2) is assumed. The ordinary smooth de Rham
Laplacian in this audit is elliptic and has that property.
On PDF page 4 the actual equations are
\[
 I=P_j+L_jG_j \quad\hbox{on }L^2(M,E_j),                         \tag{2.1}
\]
\[
 u=dd^*G_ju+d^*dG_ju+P_ju.                                    \tag{2.2}
\]
The short defining passage says \(P_j\) is the orthogonal projection
onto \(\ker L_j\), and \(G_j\) the inverse on \(\ker P_j\).
The same passage says hypoellipticity makes the harmonic space
finite-dimensional and smooth, and \(G_j\) maps smooth sections to
smooth sections.

Scope qualifications: these displayed equations do not explicitly
state a Sobolev gain \(G:H^r\to H^{r+2}\), nor star commutation.
We use classical elliptic regularity for the smooth de Rham operator
for the former and derive the de Rham star algebra for the latter.
The identity \(L_{j+1}d=dL_j\) also follows directly from \(d^2=0\).
No polynomial family bound for \(G\) is cited.

## Taylor: first-order systems and endpoint Hölder regularity

Independent source reader: `taylor-source-reader`; author PDF
<https://mtaylor.web.unc.edu/wp-content/uploads/sites/16915/2020/08/nlellip.pdf>.
The title page is undated. The reader observed PDF creation metadata
2019-04-07, not a stated mathematical revision date. There is no
invented canonical version identifier for this author excerpt.

Section 4 treats an order-\(m\) elliptic operator \(A(x,D)\) with
\(C^s\) coefficients, \(s>0\) nonintegral, solving \(Au=f\).
On PDF page 31, Theorem 4.2 assumes
\(A(x,\xi)\in C^sS^m_{1,0}\) elliptic and gives
\[
 u\in C^{m-s+\eta},\quad f\in C_*^r
       \ \Longrightarrow\ u\in C_*^{m+r},
 \qquad \eta>0,\quad -s<r<s.
\]
Theorem 4.3, under those hypotheses, gives the endpoint
\[
 u\in C^{m-s+\eta},\quad f\in C_*^s
       \ \Longrightarrow\ u\in C_*^{m+s}.                       \tag{4.17}
\]
This is not restricted to scalar equations. The source explicitly
allows vector-valued \(u\) after (3.2), PDF page 22. PDF page 33
discusses a completely nonlinear elliptic **system** \(F(x,D^mu)=f\)
and applies these theorems to \(u_j=\partial_j u\), with equation
\[
 \sum_{|\alpha|\le m}F_{\zeta_\alpha}(x,D^mu)D^\alpha u_j
       =-F_{x_j}(x,D^mu)+\partial_j f.                           \tag{4.35}
\]
The audit uses \(m=1\), \(s=3+\alpha\), \(0<\alpha<1\), and
\(u=\partial_j a\in C^{3,\alpha}\). Take \(\eta=s\); the initial
requirement is then only \(C^1\). Coefficients and right side in
\(C^{3,\alpha}\) give \(u\in C^{4,\alpha}\). Ellipticity of the
actual four-equation system including the gauge, not mere equation
counting, is proved in the argument.

## Recording boundary

These are source readings and mathematical locators, not an invented
independent mission acceptance. The official `citation_check attribute`
command necessarily archives to `research/literature/`, outside this
mission's writable paths. It has not been run under a different root
or with a fabricated reader identity. Canonical attribution of the
Donaldson and Gross--Wilson assumptions remains for an authorized host
Reviewer; the Taylor reader's actual source opinion can be recorded
as an opinion without claiming an official literature certificate.
