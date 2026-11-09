# Entropy loss and prediction of the initial relative score

**Engineer result.** The comparison has a universal proof, reproduced
below with all adaptive and limiting steps made explicit. Moreover,
the exponential-square moment hypothesis on the alternative can be
removed entirely. The discarded-space estimate remains valid for
arbitrary adaptive ranks `ell_N=o(N)`, not just rank one. These are
analytic theorems with executable exact algebraic checks, not a
numerical search or a kernel-checked formalization. Independent Reviewer
acceptance and assessment of novelty are still outstanding.

## Statement fidelity and scope

The target is `lem:entropy-loss`, equation
`eq:prediction-entropy-loss`, in
`research/openai_manuscript/A-dimension-free-logarithmic-Sobolev-inequality-for-subgaussian-log-concave-measures-September-23-2026/build/sections/04-prediction.tex`,
lines 185 onward. Here Gaussian variance is heat time (generator
`Delta/2`), not the stationary-diffusion time convention.

The manuscript assumes smooth strictly positive probability densities
`p,q` on `R^d`, log-concavity of `q`,
`H(p|q)<infinity`, `I=E_p|grad log(p/q)|^2<infinity`, and
`E_p exp(c|Y|^2)<infinity` for some `c>0`. For independent standard
Gaussian `G`, it asserts, for every `z>0`,

    2[H(p|q)-H(p*gamma_z|q*gamma_z)]
      <= integral_0^z E_p|E_p[grad log(p/q)(Y)|Y+sqrt(r)G]|^2 dr.

The posterior conditional expectations on the right use `p`, not `q`.
They are not identified with the positive-time relative score.

The main theorem asserts a dimension-independent logarithmic Sobolev
bound for linearly subgaussian log-concave measures. Its dependency chain
passes through the critical-law construction, efficient probes and this
comparison, the prediction curve, the symmetric tensor hierarchy, the
frozen matrix law, and the integrated information contradiction. This
audit certifies only the comparison and its stated extension; none of
those other steps is thereby verified.

## Known inputs and routes excluded at scope

The only substantive external analytic input is the positive-curvature
logarithmic Sobolev inequality: if a probability density has potential
with Hessian at least a constant positive matrix `B`, then

    2 H(alpha|beta) <= E_alpha[grad log(alpha/beta)^T B^-1
                                              grad log(alpha/beta)].

This is the anisotropic Bakry--Emery criterion, obtained from its
isotropic form by a linear change of variables. The staged manuscript
also proves it as `lem:curvature` in `02-calculus.tex`. Entropy chain
rules, Gaussian square completion, conditional Jensen, and orthogonal
projection identities will be derived explicitly where used.

A search for the exact non-Gaussian comparison did not identify an
earlier exact statement; this is not a proof of novelty. The literature
source for the curvature criterion must be checked at its proposition,
not inferred from a search summary.

Gaussian-reference counterexample searches are excluded analytically:
for `q=N(0,v Id)`, the positive-time relative score is
`v/(v+r)` times the conditional initial relative score. Common-heat
entropy dissipation therefore proves the comparison in that subclass.
Finite matrix tests, or absence of a witness, cannot settle the target.

The route pursued here is universal verification of the adaptive
finite-observation argument, followed by Gaussian damping of `p` to
remove its exponential-square moment assumption. The latter is a
strict extension to alternatives with only finite entropy and relative
Fisher information, and requires continuity of the predicted-score
functional, not merely lower semicontinuity.

## 1. The theorem

Let \(p,q\) be smooth strictly positive probability densities on
\(\mathbb R^d\), where \(q\) is log-concave. Assume only
\[
 H_0=H(p\mid q)<\infty,\qquad
 w=\nabla\log(p/q),\qquad I=\int |w|^2p<\infty.
\]
For \(r>0\), set \(p_r=p*\gamma_r,\ q_r=q*\gamma_r\) and
\[
 J_p(r)=\int p_r(x)
       \left|\mathbb E_p[w(Y)\mid Y+\sqrt rG=x]\right|^2\,dx.
\]
Then, for every \(z>0\),
\[
 \boxed{\quad 2\{H_0-H(p_z\mid q_z)\}
                 \le \int_0^z J_p(r)\,dr.\quad}                 \tag{T}
\]
In particular \(0\le J_p(r)\le I\); the right side is a finite
Lebesgue integral. No moment of \(Y\) is assumed in this theorem.
First we prove (T) with the manuscript's exponential-square moment,
then remove that assumption in Section 8.

## 2. Curvature input, including its scope

The classical input used at Gaussian posteriors is
\[
 \nabla^2(-\log\beta)\succeq B\succ0
 \quad\Longrightarrow\quad
 2H(\alpha\mid\beta)
 \le\int \nabla\log(\alpha/\beta)^TB^{-1}
                       \nabla\log(\alpha/\beta)\,d\alpha.       \tag{C}
\]
Here \(B\) is a constant matrix for each *fixed* posterior history;
it need not be constant as the history varies. We give a proof so
that application to arbitrary smooth log-concave \(q\), with no upper
Hessian bound, is not an implicit extra hypothesis.

The substitution \(y=B^{1/2}x\) reduces to
\(\beta\propto\exp(-|y|^2/2-U(y))\), \(U\) convex. If \(U\) is
smooth with bounded Hessian, the diffusion
\(dX_t=\sqrt2\,dB_t-\nabla(|x|^2/2+U)(X_t)dt\)
has globally Lipschitz drift, invariant law \(\beta\), and derivative
flow of norm at most \(e^{-t}\). Consequently, for smooth bounded
\(h>0\) bounded away from zero,
\[
 \frac{|\nabla P_th|^2}{P_th}
       \le e^{-2t}P_t\!\left(\frac{|\nabla h|^2}{h}\right).
\]
This follows by differentiating the flow and applying weighted
Cauchy--Schwarz. Invariance follows by integration by parts.
The same-noise coupling contracts distances by \(e^{-t}\).
The affine lower bound on convex \(U\) gives Gaussian tails of
\(\beta\), so coupling to a stationary initial point proves
\(P_th\to\int h\,d\beta\) and convergence of its entropy to zero
for bounded Lipschitz \(h\). Integration by parts gives
\[
 \frac d{dt}\operatorname{Ent}_\beta(P_th)
      =-\int\frac{|\nabla P_th|^2}{P_th}\,d\beta.
\]
Integrating yields
\(\operatorname{Ent}_\beta(h)\le
\tfrac12\int|\nabla h|^2/h\,d\beta\).
Insert \(h=f^2+\varepsilon\) and let \(\varepsilon\downarrow0\).

For general convex \(U\), use the Moreau envelopes
\[
 U_k(y)=\inf_v\{U(v)+k|y-v|^2/2\},
\]
then mollify. They are convex with bounded Hessian after mollification
and tend locally to \(U\). An affine minorant
\(U(v)\ge a\cdot v+c\) gives
\(U_k(y)\ge a\cdot y+c-|a|^2/(2k)\). Thus their normalized
densities have one integrable Gaussian majorant and converge in
\(L^1\). The compact-test inequality passes to the limit.
Value truncation, spatial cutoffs and local smoothing extend it to
every \(f\) with finite weighted Sobolev energy: the energies converge,
and the entropy is lower semicontinuous by its bounded-test
variational formula. Applying this to
\(f=\sqrt{d\alpha/d\beta}\) proves (C).

Linearization gives \(\operatorname{Cov}(\beta)\preceq B^{-1}\).
Herbst's argument gives, if \(B\succeq b\mathrm{Id}\),
\[
 \mathbb E_\beta e^{v\cdot(X-\mathbb E_\beta X)}
                    \le e^{|v|^2/(2b)}.                       \tag{SG}
\]
For completeness, apply the scalar logarithmic Sobolev inequality to
\(e^{tu/2}\), where \(u\) is bounded and 1-Lipschitz. With
\(\psi(t)=\log\mathbb E e^{tu}\) this gives
\(t\psi'(t)-\psi(t)\le t^2/(2b)\); integrate the derivative of
\(\psi(t)/t\). Truncation proves (SG) for linear forms.

The primary source is Bakry--Emery (1985),
DOI `10.1007/BFb0075847`, Corollaire 2, equation (23), p. 199,
with \(\lambda=2\kappa\); Proposition 5, equation (20), supplies
the entropy normalization. The original pages 198--199 and a short
transcription are included locally. This is a known result, not a
novelty claim.

## 3. Adaptive observations: likelihood and entropy cost

In this section assume \(\mathbb E_p e^{c|Y|^2}<\infty\).
Fix \(b=1/z>0\), \(N\ge1\), \(u>0\), and a mesh
\(\delta=u/m\). Write \(D=Nd\) and use independent copy arrays
\[
 Y=(Y_1,\ldots,Y_N),\quad W=(w(Y_1),\ldots,w(Y_N)),\quad
 Z_0=\sqrt bY+G_0,\quad Z_{i+1}=\sqrt\delta Y+G_{i+1}.
\]
The two priors are \(p^{\otimes N},q^{\otimes N}\).
All expectations and Hilbert-space norms below use the first prior.

After observing \(Z_0\), the entropy chain rule gives remaining
average posterior entropy \(N(H_0-H_z)\). At each step let
\(\mathcal H_i\) be the retained history, and let \(P_i\) project
onto the span of the difference of the two posterior means, with
\(P_i=0\) if that difference is zero. Retain
\(Q_i Z_{i+1}\), \(Q_i=\mathrm{Id}-P_i\).
Posterior means are measurable integral formulas. Positivity and the
initial precision \(b\) make all their defining moments finite.
The rule uses both priors but is the *same history function* under
either law.

There is a useful exact likelihood argument even for singular \(Q_i\).
Relative to centered Gaussian measure on \(\operatorname{ran}Q_i\),
the density of a projected output \(x\) conditional on signal \(y\)
is
\[
       \exp\{\sqrt\delta\,x\cdot y-\delta y^TQ_i y/2\}.
\]
Use these centered, history-dependent Gaussian transition kernels
as a common reference law of the retained experiment. The chain rule
for likelihoods multiplies precisely these factors. There is no
additional probability factor for choosing \(P_i\): the choice is
already a deterministic function of the past. For a fixed retained
history, the two posterior densities therefore have the common factor
\[
 \exp\{a\cdot y-y^TBy/2\},\qquad
       B=b\mathrm{Id}+\delta\sum_{i=0}^{m-1}Q_i\succeq b\mathrm{Id}.
                                                                    \tag{B}
\]
The base posterior has curvature at least \(B\), and the relative
posterior score is exactly \(W\). Neither assertion differentiates
the history as a function of \(y\).

We next check uniformly small entropy cost, rather than assuming
zero information from equality of means. Conditional on a retained
history, the projected means agree. Subtract their common projected
mean and denote either centered projected signal by \(X\).
By (SG) and Gaussian integration, the base signal satisfies
\[
 \mathbb E_q[e^{\kappa|X|^2}\mid\mathcal H_i]
             \le (1-2\kappa/b)^{-D/2},\qquad 0<2\kappa<b.      \tag{Qm}
\]
Indeed, write \(e^{\kappa|x|^2}\) as
\(\mathbb E_Ve^{\sqrt{2\kappa}\,V\cdot x}\), where \(V\) is
standard Gaussian in the observed subspace, and apply (SG).

Under \(p\), write \(a_i=\mathbb E_p[Y\mid\mathcal H_i]\). Since
\(|Q_i(Y-a_i)|^2\le2|Y|^2+2|a_i|^2\), conditional Jensen gives
\[
 M_i:=\mathbb E_p[e^{\kappa|X|^2}\mid\mathcal H_i]
       \le\{\mathbb E_p[e^{2\kappa|Y|^2}\mid\mathcal H_i]\}^2,
 \qquad
       \mathbb E_p M_i^2\le\mathbb E_p e^{8\kappa|Y|^2}.       \tag{Pm}
\]
For the second inequality use conditional Jensen on the fourth
power, then average. Choose \(\kappa>0\) so that \(8\kappa<c\)
and \(2\kappa<b\). This choice is independent of every mesh and
history; \(N\) is fixed here.

Let \(h\) be the density of \(\sqrt\delta X+G\) in the observed
subspace and \(\phi\) its centered standard Gaussian density.
For conditionally independent centered copies \(X,X'\), direct
Gaussian integration and Tonelli give
\[
 \|h/\phi-1\|_{L^2(\phi)}^2
          =\mathbb E[e^{\delta X\cdot X'}\mid\mathcal H_i]-1.   \tag{G}
\]
For \(\delta\le\kappa\), the Taylor remainder and
\(|X\cdot X'|\le(|X|^2+|X'|^2)/2\) imply
\[
 \|h/\phi-1\|_2^2
 \le \frac{2\delta^2}{\kappa^2}
       \{\mathbb E[e^{\kappa|X|^2}\mid\mathcal H_i]\}^2.
                                                                    \tag{G2}
\]
To see the constant explicitly, bound the remainder by
\(\delta^2|X|^2|X'|^2
e^{\delta(|X|^2+|X'|^2)/2}/2\) and use
\(s e^{\delta s/2}\le(2/\kappa)e^{\kappa s}\).
The vanished linear term in (G) uses centering under each prior
separately.

Jensen and the covariance bound give
\[
 h_q(x)/\phi(x)\ge
 \exp\{-\delta\mathbb E_q|X|^2/2\}
                   \ge e^{-\delta D/(2b)}.
\]
Using \(\log t\le t-1\), hence \(H\le\chi^2\), now gives
\[
 \mathbb E H(h_p\mid h_q)
 \le2e^{\delta D/(2b)}
      \mathbb E\{\|h_p/\phi-1\|_2^2+\|h_q/\phi-1\|_2^2\}
 \le C_{N,b,p}\delta^2.                                      \tag{E}
\]
The zero-dimensional subspace has cost zero. All bounds are averaged
over the actual \(p\)-history and are uniform over its sigma-field.
Thus adaptivity cannot accumulate an unaccounted entropy cost.
Summing (E) gives loss at most \(C_{N,b,p}u\delta\).
Apply (C) to the final posterior pair and average:
\[
 2N(H_0-H_z)\le \mathbb E[W^TB^{-1}W]
                         +2C_{N,b,p}u\delta.                 \tag{P}
\]
Conditional entropy and energy are finite almost everywhere by the
chain rule and \(\mathbb E|W|^2=NI\), respectively.

## 4. The nested-projection minimum

On the real Hilbert space of square-integrable vector fields of the
signal and *all full observations*, define
\[
 \begin{split}
 M&=\min_v\{b\|W-v\|_2^2+
                         \delta\sum_i\|Q_i v\|_2^2\},\\
 \mathcal F_i&=\sigma(Z_0,\ldots,Z_i),\qquad
 e_i v=\mathbb E[v\mid\mathcal F_i],\\
 M_0&=\min_v\{b\|W-v\|_2^2+
                         \delta\sum_i\|(\mathrm{Id}-e_i)v\|_2^2\}.
 \end{split}
\]
Here \(P_i\) is \(\mathcal F_i\)-measurable because the retained
history is a function of the full history. Square completion in
each signal/history outcome proves
\[
 M=bNI-b^2\mathbb E[W^TB^{-1}W],\qquad
 v_*=bB^{-1}W,\quad \|v_*\|_2\le\sqrt{NI}.                    \tag{V}
\]
Measurability and square integrability of \(v_*\) follow from
\(B\succeq b\mathrm{Id}\).

The \(e_i\) are nested orthogonal projections. Put
\(\alpha_k=b/(b+k\delta)\), \(0\le k\le m\). Their orthogonal
increment decomposition gives
\[
 v_0=\alpha_mW+
             \sum_{k=0}^{m-1}(\alpha_k-\alpha_{k+1})e_kW.      \tag{v0}
\]
Indeed a component first seen at step \(k\) has \(k\) unpredicted
penalties and multiplier \(b/(b+k\delta)\); the component never
seen before step \(m\) has multiplier \(\alpha_m\).
This also proves existence and uniqueness of the minimizer \(v_0\).
All displayed weights are nonnegative and sum to one.

Let \(g_i=(\mathrm{Id}-e_i)v_0\). Then
\[
 g_i=\alpha_m(W-e_iW)+
       \sum_{k=i+1}^{m-1}(\alpha_k-\alpha_{k+1})(e_kW-e_iW).
                                                                    \tag{g}
\]
The weights in (g) sum to \(\alpha_{i+1}\le1\), and
\[
                  b(W-v_0)=\delta\sum_i g_i.                 \tag{N}
\]
These are identities for every finite mesh, not asymptotic
commutation statements.

## 5. Conditional independence and mesh-uniform discarded cost

Under \(p^{\otimes N}\), the arrays consisting of \(Y_j\) and
every full noise for copy \(j\) are independent. Conditioning on
\(\mathcal F_i\) conditions each array only on its own observed
past. The resulting conditional kernel is therefore a product:
this follows directly by integrating products of bounded functions
of the independent arrays against bounded functions of their
individual pasts, then applying the defining property of conditional
expectation.

For every \(k\), \(e_kW_j\) is a function only of copy \(j\)'s
observations through step \(k\). Thus (g) makes \(g_{i,j}\)
conditionally independent across \(j\) and centered given
\(\mathcal F_i\), even though it also uses future full observations.
No independence of retained histories is asserted.

Conditional Jensen and the tower property give
\[
 Z_{i,j}:=\operatorname{tr}\operatorname{Cov}(g_{i,j}\mid\mathcal F_i)
 \le \mathbb E[|W_j-e_iW_j|^2\mid\mathcal F_i]
 \le \mathbb E[|W_j|^2\mid\mathcal F_i].                       \tag{Z}
\]
For example,
\(\mathbb E[|e_kW_j-e_iW_j|^2\mid\mathcal F_i]\)
is at most the first conditional second moment in (Z).
Weighted Cauchy--Schwarz applied to (g), whose weights sum to
at most one, proves (Z) also for their sum.

Here is the required uniform integrability argument. For every
nonnegative integrable \(A\), any sigma-field \(\mathcal F\),
and \(K>0\), with \(T=\mathbb E[A\mid\mathcal F]\),
\[
 \mathbb E[T1_{\{T>K\}}]
       \le2\mathbb E[A1_{\{A>K/2\}}].                         \tag{UI}
\]
Indeed \(T\le K/2+\mathbb E[A1_{\{A>K/2\}}\mid\mathcal F]\);
on \(T>K\) the last term is at least \(T/2\).
This proves (UI) uniformly over *all* sigma-fields, including
those changing with the mesh.

The conditional covariance of \(g_i\) is block diagonal. Since
\(P_i\) is \(\mathcal F_i\)-measurable and has rank at most one,
\[
 \begin{split}
 \mathbb E|P_i g_i|^2
 &\le\mathbb E\max_j Z_{i,j}\\
 &\le K+\sum_j\mathbb E[Z_{i,j}1_{\{Z_{i,j}>K\}}]\\
 &\le K+2N\mathbb E_p[|w|^21_{\{|w|^2>K/2\}}].
 \end{split}                                                \tag{R}
\]
Define
\[
 q_N=\inf_{K>0}
   \left\{\frac K N+
                   2\mathbb E_p[|w|^21_{\{|w|^2>K/2\}}]\right\}.
\]
Then \(\mathbb E|P_i g_i|^2\le Nq_N\), uniformly in \(i,m\).
First choose \(K\) large using integrability of \(|w|^2\), and
then \(N\) large: \(q_N\to0\). No fourth score moment or
mesh-dependent tail estimate is being assumed.

## 6. The dual comparison

For every \(v\), orthogonality of \(P_i,Q_i\) gives
\[
 \|Q_i v\|_2^2
   \ge2\langle v,Q_i g_i\rangle-\|g_i\|_2^2.                 \tag{D}
\]
The difference is exactly
\(\|Q_i(v-g_i)\|_2^2+\|P_i g_i\|_2^2\ge0\).
By (N), the quadratic functional
\[
 F(v)=b\|W-v\|_2^2+
             2\delta\sum_i\langle v,g_i\rangle
                          -\delta\sum_i\|g_i\|_2^2
\]
has minimizer \(v_0\) and minimum \(M_0\).
In fact \(\langle v_0,g_i\rangle=\|g_i\|_2^2\), so
\[
                         F(v)-M_0=b\|v-v_0\|_2^2.           \tag{DC}
\]
Apply (D) at \(v_*\), then (R) and Cauchy--Schwarz:
\[
 M\ge M_0-2\delta\sum_i|\langle v_*,P_i g_i\rangle|
       \ge M_0-2uN\sqrt{I q_N}.                             \tag{DM}
\]
This comparison does not assert an ordering between the geometric
projection \(P_i\) and the conditional expectation \(e_i\).

## 7. Exact minimum, Gaussian sufficiency, and order of limits

The same orthogonal increments as in Section 4 show
\[
 \frac{M_0}{N}
   =\sum_{i=0}^{m-1}
       \frac{b^2\delta}{(b+i\delta)(b+(i+1)\delta)}
                     \{I-\|e_iW_1\|_2^2\}.                 \tag{S}
\]
For a component first seen after \(j\) observations, its minimized
coefficient is \(bj\delta/(b+j\delta)\), and
\[
 \frac{bj\delta}{b+j\delta}
  =\sum_{i=0}^{j-1}
          \frac{b^2\delta}{(b+i\delta)(b+(i+1)\delta)}.
\]
This also handles \(j=0\) and \(j=m\).

Completing the likelihood square of the *full* observations through
step \(i\) gives the sufficient statistic
\[
 \frac{\sqrt b\,Z_0+\sqrt\delta\sum_{k=1}^iZ_k}{b+i\delta}
       =Y+\frac{\widetilde G}{\sqrt{b+i\delta}}.
\]
The orthogonal Gaussian combinations are independent of this
statistic and of \(Y\). Consequently
\(\|e_iW_1\|_2^2=J_p(1/(b+i\delta))\), with the original
one-copy \(p\)-posterior.
The function \(J_p(1/t)\) is nondecreasing in precision \(t\):
one can realize a weaker observation by adding independent noise
to a stronger one and use conditional Jensen. It is bounded by \(I\).
Thus the sum (S) converges, without any continuity assumption, to
\[
 b^2\int_0^u
        \frac{I-J_p(1/(b+t))}{(b+t)^2}\,dt.                  \tag{SI}
\]
For example the coefficient of each cell in (S) is exactly the
integral of \(b^2/(b+t)^2\) over that cell; a bounded monotone
integrand has convergent tagged sums.

Combining (P), (V), and (DM) before any limit gives
\[
 2(H_0-H_z)
 \le \frac I b-\frac{M_0}{Nb^2}
       +\frac{2u}{b^2}\sqrt{Iq_N}
       +\frac{2C_{N,b,p}u\delta}{N}.                         \tag{F}
\]
Take \(m\to\infty\) at fixed \(N,u\), removing the last term
and using (SI). Next let \(N\to\infty\) at fixed \(u\).
There is no need to bound \(C_{N,b,p}\) uniformly in \(N\)
because its term has already vanished. The mesh-uniform (R)
removes the rank error. We obtain
\[
 \begin{split}
 2(H_0-H_z)
 &\le \frac I b-
               \int_0^u\frac{I-J_p(1/(b+t))}{(b+t)^2}\,dt\\
 &=\frac{I}{b+u}+
               \int_{1/(b+u)}^{1/b}J_p(r)\,dr.              \tag{L}
 \end{split}
\]
Finally let \(u\to\infty\). Since \(0\le J_p\le I\) and
\(1/b=z\), (L) proves (T) under the moment hypothesis.
This is the manuscript's prescribed order: mesh, copies, precision.
No adaptive process at an infinite mesh has to be constructed.

## 8. Removal of every moment assumption on the alternative

Keep only finite \(H(p\mid q)\) and \(I\). For \(\varepsilon>0\)
define
\[
 h_\varepsilon(y)=e^{-\varepsilon|y|^2},\quad
 a_\varepsilon=\mathbb E_ph_\varepsilon,\quad
 p^\varepsilon=h_\varepsilon p/a_\varepsilon,\quad
 w^\varepsilon=w-2\varepsilon y.
\]
These densities are smooth and strictly positive and have an
exponential-square moment, since
\(\mathbb E_{p^\varepsilon}e^{\varepsilon|Y|^2/2}
\le1/a_\varepsilon\).
They also have finite initial entropy and Fisher information.
Indeed, for \(s\ge0\), \(s e^{-s}\le1\), hence
\[
 \varepsilon^2|y|^2h_\varepsilon(y)\le\varepsilon,\qquad
 I(p^\varepsilon\mid q)
     \le\frac{2I+8\varepsilon}{a_\varepsilon}.                \tag{Ib}
\]

Put \(\ell=\log(p/q)\). Its absolute value is \(p\)-integrable:
the negative part is at most \(\int q/e=1/e\), and the
positive part is finite by the entropy hypothesis. The identity
\[
 H(p^\varepsilon\mid q)
 =\frac{\mathbb E_p[h_\varepsilon\ell]}{a_\varepsilon}
  -\frac{\mathbb E_p[\varepsilon|Y|^2h_\varepsilon]}
         {a_\varepsilon}
  -\log a_\varepsilon
\]
shows convergence to \(H_0\). Dominated convergence applies to
the middle expectation because
\(\varepsilon |y|^2e^{-\varepsilon|y|^2}\le1\) and it
tends pointwise to zero. This argument needs no first or second
moment.

For fixed \(r>0\), condition under the original \(p\)-experiment
on \(U=Y+\sqrt rG\), and let
\[
 A_\varepsilon(U)=\mathbb E_p[h_\varepsilon(Y)\mid U].
\]
The output density ratio is
\(p^\varepsilon_r/p_r=A_\varepsilon/a_\varepsilon\).
It converges pointwise almost everywhere to one and is eventually
at most two. Data processing gives \(H(p_r\mid q_r)\le H_0\),
so \(\log(p_r/q_r)\) is \(p_r\)-integrable. Splitting
the output entropy into the expectation of this log ratio and the
expectation of
\((A_\varepsilon/a_\varepsilon)
\log(A_\varepsilon/a_\varepsilon)\)
therefore proves
\[
                     H(p^\varepsilon_r\mid q_r)\to H_r.     \tag{He}
\]
The second term converges to zero by bounded convergence on
\([0,2]\), with \(0\log0=0\).

It remains to pass the *right side*, where lower semicontinuity
would be insufficient. Bayes' formula gives exactly
\[
 J_{p^\varepsilon}(r)
 =\frac1{a_\varepsilon}\mathbb E_{p_r}
   \frac{\left|
    \mathbb E_p[h_\varepsilon(w-2\varepsilon Y)\mid U]
                          \right|^2}{A_\varepsilon(U)}.     \tag{Je}
\]
Conditional dominated convergence gives
\(\mathbb E_p[h_\varepsilon w\mid U]\to
\mathbb E_p[w\mid U]\).
The other numerator term tends to zero, since
\[
 |\mathbb E_p[2\varepsilon Yh_\varepsilon\mid U]|^2
 \le4\varepsilon^2
       \mathbb E_p[|Y|^2h_\varepsilon\mid U]A_\varepsilon
 \le4\varepsilon A_\varepsilon.
\]
Also \(A_\varepsilon\to1\). By conditional Cauchy--Schwarz
the quotient in (Je) is at most
\[
 \mathbb E_p[h_\varepsilon|w-2\varepsilon Y|^2\mid U]
           \le2\mathbb E_p[|w|^2\mid U]+8\varepsilon.        \tag{Jb}
\]
This is an integrable majorant for fixed \(r\), so (Je) converges
to \(J_p(r)\). For small \(\varepsilon\), (Ib) also bounds
all \(J_{p^\varepsilon}(r)\) by the same constant
\(4I+16\), independently of \(r\) on every finite interval.
The Gaussian integral formulas make these functions measurable.
Dominated convergence in time gives
\[
       \int_0^zJ_{p^\varepsilon}(r)\,dr
                           \longrightarrow\int_0^zJ_p(r)\,dr. \tag{Ji}
\]
Apply the already proved moment version to \(p^\varepsilon,q\),
then use (He), (Ji), and initial entropy convergence.
This proves Theorem (T) in its stated moment-free form.

## 9. Robustness under sublinear adaptive discarded rank

There is a useful strengthening of the finite-moment proof in
Sections 3--7. In that proof \(p\) still has the manuscript's
exponential-square moment; the residual estimate (SR) itself uses only
\(I<\infty\). At each step allow *any*
\(\mathcal H_i\)-measurable orthogonal projection
\(P_i\) whose range contains the posterior-mean difference and whose
rank is at most \(\ell_N\), where \(\ell_N/N\to0\).
The likelihood, entropy-cost and Hilbert-space arguments are unchanged.
Only (R) needs an improved truncation.

For a block diagonal positive matrix \(C=\operatorname{diag}(C_j)\)
with \(Z_j=\operatorname{tr}C_j\), write
\[
 C\preceq K\mathrm{Id}
               +\operatorname{diag}(C_j1_{\{Z_j>K\}}).
\]
Thus, for *every* projection of rank at most \(\ell_N\),
\[
 \operatorname{tr}(PC)
       \le K\ell_N+\sum_jZ_j1_{\{Z_j>K\}}.
\]
Taking conditional covariances as in Section 5 and using (UI) gives
\[
 \mathbb E|P_i g_i|^2\le Nq_{N,\ell},\qquad
 q_{N,\ell}=\inf_{K>0}\left\{
  \frac{\ell_N K}{N}
             +2\mathbb E_p[|w|^21_{\{|w|^2>K/2\}}]\right\}\to0. \tag{SR}
\]
Choose \(K\) first, then \(N\); no decay rate of the score tail
is needed. Multiplying a rank-one maximum bound by \(\ell_N\)
would incorrectly multiply the tail term and would not prove this.
Equations (DM)--(L) now hold with \(q_{N,\ell}\).
This proves full robustness to sublinear-rank adaptive exclusions,
not just finite-dimensional examples of it.

## 10. The moment-free extension is strictly stronger

In dimension one take
\[
 p(x)=\frac{2}{\pi(1+x^2)^2},\qquad
 q(x)=Z^{-1}e^{-\sqrt{1+x^2}}.
\]
Both densities are smooth and strictly positive.
\[
 \frac{d^2}{dx^2}\sqrt{1+x^2}=(1+x^2)^{-3/2}>0,
 \qquad 2/e\le Z\le2,
\]
where the normalization bounds follow from
\(|x|\le\sqrt{1+x^2}\le1+|x|\).
The exact identities
\(\int p=1\) and \(\int|x|p=2/\pi\) show that
\(H(p\mid q)<\infty\):
\(\sqrt{1+x^2}\le1+|x|\) and
\(\log(1+x^2)\le2|x|\) bound the absolute log density ratio
by a constant plus \(5|x|\).
Furthermore
\[
 w(x)=-\frac{4x}{1+x^2}+\frac{x}{\sqrt{1+x^2}},
 \qquad |w(x)|\le3,\qquad I\le9.
\]
For every \(c>0\) and \(x\ge1\),
\[
 p(x)e^{cx^2}
 \ge\frac{2}{\pi}\frac{c^3x^6}{6(1+x^2)^2}
 \ge\frac{c^3x^2}{12\pi}.
\]
Hence \(\int e^{cx^2}p(x)\,dx=\infty\) for *every* \(c>0\).
This exact construction lies outside the manuscript's hypothesis
and inside Theorem (T). It is not a counterexample to the manuscript.

## 11. What is and is not certified

`verify.py` checks the dimension-independent algebra behind the
variational and dual identities, general-index telescoping and
the change of variables, the exact heavy-tail construction, and
the retained bounded Jacobian result. It uses exact rationals and
symbolic identities, with no numerical integration. Its
`exact_certificate.json` explicitly separates those checks from
the measure-theoretic proof in Sections 2--9.

The analytic argument above covers all dimensions, arbitrary adaptive
projections, conditional independence given full histories, uniform
integrability with only a second score moment, and the required order
of limits. Its independent mathematical reading is the Reviewer's
job; a successful script run is not described as automatically
checking those analytic statements. No Lean certificate is claimed.

No false assertion was established in the targeted manuscript
argument, so there is no invented `F_...` refutation claim.
The moment-free and sublinear-rank conclusions improve on the exact
staged statement; their global literature novelty is not established
by a search engine's absence of an exact match.
The classical curvature theorem is separately reproved here.
The function-preserving localization papers cited in the manuscript
provide context, not premises of this finite-observation proof.

The strongest prior result in scope was the staged lemma with an
exponential-square moment and rank-one exclusions. The precise
improvements here are (i) (T) with no moment assumption on \(p\),
proved by entropy and predicted-score *continuity*, and
(ii) the mesh-uniform bound (SR) for \(\ell_N=o(N)\).
The main dimension-free logarithmic Sobolev theorem and the other
dependency nodes remain unaudited by this work.
