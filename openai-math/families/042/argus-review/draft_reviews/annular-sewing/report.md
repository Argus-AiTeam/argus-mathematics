# Annular sewing: assessment of the analytic reconstruction

## Disposition and exact scope

**Engineer assessment: supported as an analytic prose argument under the
stated transition hypotheses; current independent acceptance is pending.**
This is a reconstruction of a theorem already asserted, and substantially
proved by the same method, in the manuscript. It is not a verified new theorem,
a kernel proof, a counterexample, or a verification of the K3 manuscript.

The old draft is
`9000042/research/sewing-audit/report.md`, Sections 2-7. The source is OpenAI,
*Every complex K3 surface is Oka*, September 23, 2026,
`build/sections/sewing.tex`, lines 1-370, especially `sew:chain` at lines 24-64.
Here and in the other reports, `9000042/` denotes the absolute old workspace
`campaigns/9000042/`.
The source is bound to
`campaigns/9100042/MANUSCRIPTS.json`,
revision `4eaee87548250b2682affda7d05d947c05554bae`. All 13 listed TeX
files match their existing manifest digests, including `sewing.tex`; the
old staged directory resolves to the manifest's source directory. No source
revision discrepancy was found. This is a byte-correspondence measurement,
not mathematical certification.

The exact theorem being assessed has the following inputs.

* A complex surface \(M\) with nowhere-zero holomorphic two-form \(\omega\);
  \(0<h<1/8\), \(r>0\), and a finite derivative bound \(A\).
* For every \(j\in\mathbb Z\), \(L_j\geq1\) and a holomorphic map
  \(\phi_j:\{-2h<\operatorname{Im}w<L_j+2h\}\times\Delta_r\to M\)
  on the cylinder \(\mathbb C/\mathbb Z\), with
  \(\phi_j^*\omega=dw\wedge dp\). Injectivity of these original maps is
  not assumed or concluded.
* Holomorphic model shears \(J_j(w,p)=(w+a_j(p),p)\) satisfying
  \(|\operatorname{Im}a_j+L_j|<h/8\) and \(|a_j'|\leq A\).
  An admissible input necessarily has \(A\geq0\).
* Degree-one lifted, **exact** symplectic transitions on
  \(S_j(h,r)=\{|\operatorname{Im}w-L_j|<h,\ |p|<r\}\), with
  \(\phi_j=\phi_{j+1}\circ F_j\) and
  \(J_j^{-1}F_j=(w+u_j,p+v_j)\),
  \(\sup_j\|(u_j,v_j)\|\leq e\). Exact means that
  \(F_j^*(P\,dW)-p\,dw\) has zero cylinder period, not just that
  \(\det DF_j=1\).

For sufficiently small \(e\), depending only on \(h,r,A\) and fixed margins,
the conclusion is a period-one holomorphic symplectic immersion
\(\mathbb C\times\Delta_b\to M\), corrected shear transitions, and small
periodic symplectic coordinate changes on buffered subblocks. Their
coordinate norms and each fixed finite derivative order on further smaller
domains tend uniformly to zero with \(e\). Uniformity is in \(j\), all
lengths, and the number of blocks. It is **not** a uniform target-distance
estimate for the original maps \(\phi_j\), whose derivatives need not be
uniformly bounded. A finite chain has finite ends, not the entire-cylinder
conclusion. The separate explicit choice \(b=r/4\) and passive extension
are assessed in `../effective-passive/report.md`.

## 1. Exactness and linearization

The sign convention is \(\lambda=p\,dw\),
\(X_H=(H_p,-H_w)\). Then
\(\mathcal L_{X_H}\lambda=d(pH_p-H)\), so the correction flows are exact.
Also
\[
 J^*\lambda-\lambda=p a'(p)\,dp
   =d\left(p a(p)-\int_0^p a(\zeta)\,d\zeta\right).
\]
Thus \(E=J^{-1}F\) remains exact. No condition that \(a\) be independent
of \(p\) is needed.

For \(E=(w+u,p+v)\), symplecticity and the actual period condition give
\[
 u_w+v_p=-u_wv_p+u_pv_w,\qquad
 v_0=-\int_0^1 v u_w\,dw.
\]
The omitted term \(p u_w\) integrates to zero by periodicity. On a
buffered seam, coordinate Cauchy estimates give
\(\|v_0\|\leq e^2/\delta\) and, after another loss,
\(\|v_0'\|\leq e^2/\delta^2\).

For a mean-zero periodic holomorphic \(f\), the draft uses the explicit
operator
\[
 {\cal P}f(w,p)=\int_0^1 t f(w+t,p)\,dt.
\]
Integration by parts gives \(({\cal P}f)_w=f\); periodicity gives its
zero mean; and \(\|{\cal P}f\|\leq\|f\|/2\). These assertions hold on
horizontal period circles at every seam height, so no primitive grows
with \(L_j\). With \(H={\cal P}(-v+v_0)\),
\[
 (u-H_p-u_0)_w=-u_wv_p+u_pv_w-v_0',
 \qquad
 (u,v)=(u_0,0)+X_H+R,
 \quad \|H\|\leq e,\quad \|R\|\leq2\delta^{-2}e^2 .
\]
The right side of the differentiated identity has zero mean; applying
the same bounded primitive proves the remainder estimate. The zero
Fourier coefficient of \(v\), not that of \(u\), is quadratic.
This supports old `C_SEW_LINEARIZE` v1.

## 2. Infinite Fourier splitting and its uniformity

The relevant domains are the source's slanted domains
\[
 D_j(s,\rho)=
 \{L_{j-1}-s<Y-\operatorname{Im}a_{j-1}(p),\
   Y<L_j+s,\ |p|<\rho\}.
\]
The translated seam has exactly the required lower target inequality.
Writing \(T_j=-H_j\), continue \(w_{l+1}=w_l+a_l(p)\) and set
\[
 G_j=\sum_{l\geq j}T_l^-(w_l,p)-\sum_{l<j}T_l^+(w_l,p).
\]
Negative frequencies are evaluated below a coefficient line at
\(L_l+s-\delta/4\); positive frequencies above a line at
\(L_l-s+\delta/4\). The distances are at least
\[
 3\delta/4+(1-\kappa)(l-j),\qquad
 3\delta/4+(1-\kappa)(j-1-l),
\]
respectively, when \(|\operatorname{Im}a_l+L_l|\leq\kappa<1/4\).
The nearest terms follow from the two defining inequalities of \(D_j\).
Each further term adds a length at least one, less an error at most
\(\kappa\). Large lengths help decay instead of worsening it.

Summing the exponential Fourier bounds over both frequency and distance
gives \(44e/(81\delta)<e/\delta\), using
\((1-e^{-2\pi gn})^{-1}\leq11/9\) for \(g\geq3/4,n\geq1\)
and \((e^{3\pi\delta/2}-1)^{-1}\leq2/(9\delta)\).
This is an infinite absolutely and normally convergent majorant, not a
finite-mode experiment. The common tails cancel to give
\(G_j-G_{j+1}\circ J_j=-H_j\).

Joint holomorphicity is established before differentiating in \(p\).
In particular, the argument does not estimate derivatives of arbitrarily
long partial sums of the \(a_l\). A local polydisc of radius
\(\delta/N\), \(N=8(A+2)\), fits into the larger slanted domain:
its lower-boundary displacement is at most \(\delta/8\) when the
current derivative bound is \(A+1\). Cauchy's formula then yields
\[
 \|G_j\|\leq\delta^{-1}e,\quad
 \|X_{G_j}\|\leq N\delta^{-2}e,\quad
 \|DX_{G_j}\|\leq4N^2\delta^{-3}e .
\]
The factor four covers diagonal second derivatives and the induced
maximum-norm row sums. This supports `C_SEW_SPLIT` v1 with the required
uniformity, not merely pointwise splitting for fixed lengths.

## 3. Newton cancellation, flows, and actual domains

Put \(Q_j=G_{j+1}\circ J_j\). The correct identity is
\[
 (DJ_j)^{-1}(X_{G_{j+1}}\circ J_j)=X_{Q_j}.
\]
Its horizontal component includes \(a_j'G_{j+1,w}\circ J_j\).
Consequently \(J_j^{-1}K_{j+1}J_j\) is the time-one flow of \(Q_j\),
and the first-order term of
\[
 J_j^{-1}K_{j+1}^{-1}J_j\,E_j\,K_j
\]
is \((u_j,v_j)+X_{G_j}-X_{Q_j}=(u_{j,0},0)+R_j\).
The shear identity, also checked symbolically, is a genuine ingredient;
the failed attempt to omit it is not an independent proof of this step.

Let \(D=N\delta^{-2}e\), \(L=4N^2\delta^{-3}e\).
Under \(K\delta^{-7}e\leq1/1024\), \(K=1024N^6\), one has
\(D\leq\delta/(1024N)\) and \(L\leq1/256\).
Picard iteration in a reserved coordinate polydisc is a contraction;
its trajectories stay inside it. Positive and negative time give the
flow and inverse, with displacement at most \(D\) and nonlinear
remainder at most \(LD\). On a buffered seam \(Q_j\) has the same
supremum bound as \(G_{j+1}\); local Cauchy estimates on that seam
give the same flow bounds without an uncontrolled shear derivative.

The draft's remainder sum is legitimate: the two flow remainders,
the derivative of \(E_j-\mathrm{id}\) times a displacement, and
evaluation of \(X_{Q_j}\) at the displaced point total at most
\(17N^3\delta^{-5}e^2\). Adding the linearization remainder makes
this at most \(19N^3\delta^{-5}e^2\).
Normalizing by the updated shear \(a_j+u_{j,0}\) multiplies the
remainder by at most \(1+e/\delta\leq2\), because the extra term is
\(u_{j,0}(p)-u_{j,0}(p+R_p)\). Thus
\[
 e_{\rm new}\leq38N^3\delta^{-5}e^2
             \leq K\delta^{-6}e^2 .
\]

These are not estimates on unrestricted domains. The old draft reserves
64 losses of size \(\delta\): 6 for linearization, 2 for splitting,
4 for Cauchy estimates, 8 for flows, 4 for compositions, 4 for
moving edges, and 36 unused. The normalized composition's total
displacement \(2D+e\) is less than one reserved \(\delta/N\)
polydisc. A block edge changes by at most \((A+2)D+e<\delta/4\);
the change of \(a_j'\) is at most \(e/\delta\). The other seam edge
has the fixed separation \(1-\kappa-2s>1/2\).
Thus source, target, inverse, and moving-boundary restrictions fit
simultaneously. Only adjacent charts enter. Exactness persists under
these compositions and inverses. This supports `C_SEW_NEWTON` v1.

## 4. All-stage induction and moving limiting domains

The detailed constants are checked in the effective-parameter unit.
The qualitative issue here is that the proof does not infer convergence
from a finite run. With \(\delta_n=d2^{-n}\),
\(B=Kd^{-6}\), and \(\theta=64Be_0\), rescaling by
\(x_n=B2^{6(n+1)}e_n\) gives \(x_{n+1}\leq x_n^2\). Hence
\[
 e_n\leq B^{-1}2^{-6(n+1)}\theta^{2^n}.
\]
The bound on \(2^n\theta^{2^n}\) establishes the step hypothesis
at every \(n\), not after assuming infinitely many valid steps.
Every fixed differentiated series \(\sum\delta_n^{-k}e_n\)
converges. The total margin loss is bounded independently of lengths.
Translation changes and their derivatives are summable, keeping the
imaginary shifts below \(h/3\) and derivatives below \(A+1\).
This supports `C_SEW_MARGINS` v1.

The limiting lower edges move with \(a_{j-1}^{(n)}\). The draft
does address this: the remaining translation tail is at most
\(\delta_n/512\), whereas the remaining margin is \(2c_0\delta_n\).
The limiting domain defined using \(\widetilde a_{j-1}\) is therefore
contained in every stage domain, with buffer. It is not an unjustified
intersection of fixed domains.

The initial restriction is valid as well: \(D_j(h/2,r/2)\) has
lower edge above \(-5h/8>-2h\), upper edge \(L_j+h/2<L_j+2h\),
and transverse radius \(r/2<r\). Thus the first composition already
has fixed buffer inside the given chart, independently of \(L_j\).

For \(C_j^n=K_j^0\circ\cdots\circ K_j^{n-1}\),
the derivative product is bounded by \(e^S<2\), with
\(S=\sum8N^2\delta_n^{-3}e_n\leq1/120\).
Integrating along the final flow path bounds
\(\|C_j^{n+1}-C_j^n\|\leq2N\delta_n^{-2}e_n\).
Thus the composed maps converge, not just the individual corrections.
Local Cauchy integrals give convergence of derivatives and
\(\det DC_j=1\). The bound
\(\|DC_j-I\|\leq1/119\) gives injectivity on the convex lifted core
\(\{h/2<Y<L_j-h/2\}\times\Delta_{r/4}\); periodicity gives the
corresponding cylinder statement.

Passing to the limit in chart identities is local for each fixed chart.
It needs no uniform derivative bound on all original \(\phi_j\).
The limiting identity is
\(\phi_j C_j=\phi_{j+1}C_{j+1}\circ\widetilde J_j\) on the
surviving seams.

## 5. Full global coverage

Set \(\sigma_0=0\),
\(\sigma_{j+1}=\sigma_j+\widetilde a_j\) in both directions, and
\(B_j=L_j-\operatorname{Im}\sigma_j\).
Each \(\sigma_j\) is a finite sum; no uniform bound on its derivatives
as \(j\to\infty\) is needed. With
\(c_{j-1}=L_{j-1}+\operatorname{Im}\widetilde a_{j-1}\),
\[
 B_j-B_{j-1}=L_j-c_{j-1}\geq1-h/3.
\]
The translated limiting blocks are exactly
\[
 \Omega_j=\{B_{j-1}(p)-s_\infty<\operatorname{Im}w
                    <B_j(p)+s_\infty,\ |p|<\rho_\infty\}.
\]
The edges tend to both infinities uniformly on the common parameter
disc, giving a locally finite full-cylinder cover. Nonadjacent blocks
are disjoint because \(2s_\infty\leq h<1-h/3\). Adjacent intersections
are exactly the surviving seams. The limiting identities therefore
glue the maps without a missing triple-overlap or uniformization step.
The finite shears preserve \(dw\wedge dp\); the resulting pullback form
is nondegenerate, proving immersion. Periodicity descends from the
original cylinder maps and corrections. This supports `C_SEW_COVER`
and `C_SEW_CHAIN` v1.

## Evidence boundary and comparison with the prior result

The required unchanged checker replay passed **146 checks**, with exit
zero, after resolving its missing SymPy import through an existing
read-only dependency path. Exact command, dependencies, stdout, failed
attempt, and timing are in `../failed-attacks/checker-replay.json`.
The checker reads the certificate, saved Jacobian pair, and selected
source fragments; **it does not read or verify the analytic report**.
It cannot establish the domain arguments, normal convergence,
all-stage analytic induction, or the coverage proof just assessed.
There is no Lean source or compiler evidence in this inventory.

The strongest prior assertion was already a complete uniform analytic
proof with an explicit strengthening. This review does not improve the
mathematical theorem. It supports the stated sewing scope by examining
the decisive analytic argument, separates the shared calculations from
that argument, and refuses the unsupported jump to whole-manuscript
correctness or verified novelty. Final acceptance remains with the
native independent Reviewer.
