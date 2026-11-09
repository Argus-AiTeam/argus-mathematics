# Critical dependent weights: verification and a logarithmic-tail principle

## 1. Result, scope, and prior knowledge

**Verification theorem.** For every integer \(d\ge3\), put \(b=d-1\),
\(\theta=b^{-1/2}\), and \(\beta=\operatorname{atanh}\theta\). Give
\(X_v(t)=t\sigma_v+B_v(t)\) the planted free-Ising observation law, with
independent Brownian noises independent of the broadcast spins. Let two
copies be sampled independently given the **entire** innovation array,
as in (5.1) of the staged manuscript. Then Proposition `weighted-paths`
in `07-path-averages.tex` holds, in both orientations, with its stated
length restriction. Proposition `critical-uniqueness` in
`08-critical-comparison.tex` follows: \(V(t)=0\) for every \(t\ge0\).
Neither observation recovery nor an FIID construction is an input.

The weighted estimate is in fact valid for **any** invariant joining
of these observation marginals having a deterministic bound \(H\) on
the site-field difference at the time in question. Compatibility with
common innovations is needed for the evolution and its bound \(H_T\),
not for the invariant weighted averaging itself.

**Generalization.** The same critical comparison closes whenever the
log-factor derivative has any positive local flatness exponent and the
marginal exceptional-field probability decays as
\(\exp[-c\log^q(1/t)]\) for any \(q>1\). More generally, moment bounds
\(\mathbb E|Y(t)|^p\le \exp(Kp^s)t^{ap}\), with \(a>0\) and any finite
\(s>1\), supply a suitable exponent \(q=s/(s-1)>1\). Section 9 states
the estimate-level theorem precisely and gives an exact \(q=1\)
nonuniqueness construction for that abstract system. The construction
is **not** an Ising joining or a manuscript counterexample.

No false assertion was identified in the two audited propositions.
This is a proof and partial formal certification, not a claim that
finite experiments prove an infinite law. Independent Reviewer
acceptance and publication-level novelty assessment remain pending.

The inherited Wiki search returned no directly relevant reusable
critical-comparison result. An independent bounded primary-source
lookup found:

| Source | Proposition actually consulted | Relevance and limit |
|---|---|---|
| [Nam--Sly--Zhang, arXiv:2012.09484v2](https://arxiv.org/abs/2012.09484v2) | Section 1, Theorem 1 and final introductory paragraph | Absolute \(c,d_0>0\), FIID for \(d\ge d_0,\ \theta\le c/\sqrt b\); the inclusive sharp bound for every \(d\ge3\) is explicitly conjectured. |
| [Lyons, arXiv:1401.4197v4](https://arxiv.org/abs/1401.4197v4) | Section 3, Theorem 3.1, Corollaries 3.2--3.3 | The strict obstruction above \(b^{-1/2}\), and the fact that weak limits of FIIDs need not be FIID, are prior results. |
| [Backhausz--Szegedy--Virag, arXiv:1305.6784v1](https://arxiv.org/abs/1305.6784v1) | Theorems 1.2, 2.1, 3.1 | Correlation/spectral machinery is prior art; its FIID hypotheses cannot simply be assumed for the process being constructed. |
| [Backhausz--Gerencser--Harangi--Vizer, arXiv:1603.08423v2](https://arxiv.org/abs/1603.08423v2) | Theorems 1.1, 4.1--4.2 | Distant-region and directed-edge correlation bounds, including the nonbacktracking operator, are prior art. The region separation concerns convex hulls. |

These are scope comparisons, not premises used to infer FIID or the
path-variance bound below. In particular we rederive the latter on
the closed space of **marginal differences**, rather than cite a theorem
whose hypothesis is the desired factor property. The NSZ scope fact is
recorded as `C_CE_PRIOR/A_NSZ_PRIOR`; formal citation attribution is for
the independent Reviewer. No earlier complete critical construction
was established by this bounded lookup; this is not an exhaustive
novelty search.

The only standard background used without reproving it is conditional
expectation convergence/disintegration, bounded self-adjoint spectral
calculus, elementary stochastic calculus (Levy characterization,
Ito, isometry, Doob), and the absolutely continuous real chain rule.
These inputs and their exact uses are exposed in
the claim ledger. In particular no infinite innovation martingale
representation, strong-solution theorem, or unproved comparator is
assumed.

## 2. Infinite components and the information input

Write \(T_{v\to w}\) for the infinite component rooted at \(v\) after
deleting \(vw\), and let
\[
 Y=h_{v\to w}(t)=\operatorname{atanh}
       \mathbb E[\sigma_v\mid X_u(s):u\in T_{v\to w},\,s\le t].
\]
Finite connected broadcast marginals have free-boundary Ising density.
Multiplication by their Gaussian likelihood gives
\(\pi_x(\eta)\propto\exp(\beta\sum_{ij}\eta_i\eta_j+
\sum_i x_i\eta_i)\). Thus finite component fields obey the cavity
recursion and differ from their own observation by at most \(b\beta\).
Increasing finite observation sets exhaust the component history
sigma-field. Upward conditional-expectation convergence and the field
bound pass the recursion to finite-valued infinite fields:
\[
 h_{v\to w}=X_v+\sum_{u\sim v,\ u\ne w}\psi(h_{u\to v}),\qquad
 \psi(z)=\operatorname{atanh}(\theta\tanh z).
\]
The same argument gives the site version and the path response
\[
 c_{vu}=\theta^r\prod_{i=1}^r a(h_{v_i\to v_{i-1}}),\qquad
 C_{vu}=(1-m_v^2)c_{vu},\qquad
 a(z)=\frac{1-\tanh^2z}{1-\theta^2\tanh^2z}.
\]
Here \(m_v=\tanh h_v\), \(c_{vv}=1\), \(0<a\le1\),
\(|\psi|\le\beta\), and \(0<\psi'=\theta a\le\theta\).
One way to check the orientation is to compute the slope of
\(\mathbb E[\sigma_{v_i}\mid\sigma_{v_{i-1}},X]\):
it is \(\theta a(h_{v_i\to v_{i-1}})\), not its reversed field.
Its product times \(1-m_v^2\) is the covariance.

Centered finite-ball limsups give causal Borel component-local raw
versions. Limits here are used to identify the actual infinite posterior,
**not** to assert a finite-tree square-root attenuation estimate.
Section 5 explains continuous versions retaining this locality.

Here is the conditional-independence fact used throughout. Root the
broadcast on a fixed path or above a cut. Each side component consists
of its attaching-edge multiplier, its internal edge multipliers, and
its independent Brownian paths. Given its attaching path spin these
groups are mutually independent and are independent of all remaining
observations. Likewise, after conditioning on all cut-root spins,
the descendants and noises (including each cut root's noise) are
independent across cut components. This proves the fact on arbitrary
finite cylinders. A monotone-class extension gives it for the full
history sigma-fields. The cut spins themselves need not be independent.

This factorization is proved under a **single planted marginal**.
One does not condition the actual joined law on its common innovations
and then assert branch independence. After proving a marginal event
bound, its unconditional probability transfers to either joined
coordinate because that coordinate has the same marginal law.

For completeness the information scale can be obtained without any
factor assumption. Set \(M=\mathbb E\tanh^2Y\). On the rooted \(b\)-ary
component take
\(Z_n=\sum_{|u|\le n}\theta^{|u|}X_u(t)\). Broadcast covariance gives
\[
 \mathbb E[\sigma_v Z_n]=t(n+1),\qquad
 \mathbb E Z_n^2\le t(n+1)+t^2(n+1)^3.
\]
For the second inequality, vertices at depths \(k,\ell\) and
last-common-ancestor depth \(j\) have weight
\(b^{-(k+\ell-j)}\), while their ordered-pair count is at most
\(b^{k+\ell-j}\). Summing over \(j\le\min(k,\ell)\) yields the bound.
Since \(Z_n\) is measurable for the **infinite** posterior,
Cauchy--Schwarz gives
\[
 M\ge\frac{t(n+1)}{1+t(n+1)^2}.
\]
Take \(n=\lfloor t^{-1/2}\rfloor\) for \(t\le1\), and \(n=0\) for
\(t\ge1\). Consequently \(M\ge\omega(t)/5\), where
\(\omega(t)=\min(\sqrt t,1)\).

For the upper bound combine two symmetric, conditionally independent
binary signals with posterior means \(U,V\). Their joint marginal
density relative to the product of their marginals is \(1+UV\).
The combined information is
\[
 \mathbb E U^2+\mathbb E V^2-
 \mathbb E_{\rm prod}
 \frac{U^2V^2(2-U^2-V^2)}{1-U^2V^2}.
\]
If \(|U|,|V|\le\theta\), the loss is at least
\(2(1-\theta^2)\mathbb EU^2\mathbb EV^2\). Two infinite child
signals about their parent have information \(\theta^2 M\).
Combine these first, then add all remaining child signals and the
own observation by subadditivity. Since \(b\theta^2=1\),
\[
 2(1-\theta^2)\theta^4 M^2\le
 q_0(t):=\mathbb E\tanh^2X_v(t)\le t+t^2.
\]
Thus \(M\le C\omega(t)\); the site information is also at most
\(q_0+d\theta^2 M\le C\sqrt t\) for \(t\le1\).
The fusion identities and their signs are checked in both exact
symbolic arithmetic and Lean.

The spin-tilt formulas are
\[
 \mathbb E[f(Y)\mid\sigma_v=s]=\mathbb E[f(Y)(1+s\tanh Y)],
 \quad
 \mathbb E[f(Y)\mid\sigma_w=s]=\mathbb E[f(Y)(1+s\theta\tanh Y)].
\]
They follow by conditioning the corresponding spin indicator on the
component history. Symmetry of \(Y\) means every integrable even
function has the same expectation under either conditioning.
Put \(G=\psi(Y)\). Under \(\sigma_w=s\),
\[
 \operatorname{Var}G\ge(1-\theta^2)\mathbb E G^2
       \ge(1-\theta^2)\theta^2M.
\]
The first inequality uses the tilt formula and Cauchy--Schwarz;
the second uses \(|\psi(Y)|\ge\theta|\tanh Y|\).
For any \(G\in[-\beta,\beta]\), uniformly in \(z\in\mathbb R\),
\[
 \mathbb E\tanh^2(z+G)\ge c_\beta\operatorname{Var}G.
\]
Indeed for \(|z|\le\beta+1\), the derivative of tanh is at least
\(\operatorname{sech}^2(2\beta+1)\) between zero and \(z+G\).
For \(|z|>\beta+1\), use \(|z+G|>1\) and
\(\operatorname{Var}G\le\beta^2\). One possible constant is
\[
 c_\beta=\min\{\operatorname{sech}^4(2\beta+1),
                         \tanh^2(1)/\beta^2\}>0.
\]
Since \(a(h)^2\le1-(1-\theta^2)\tanh^2h\), this proves
\[
 \mathbb E[a(z+\psi(Y))^2\mid\sigma_w=s]
       \le1-c_0\omega(t),\quad
 c_0=\min\{1/2,c_\beta(1-\theta^2)^2\theta^2/5\}.
 \tag{A}
\]
It is a statement about one intact infinite branch, uniform in every
shift and both attaching spins. A depth-zero branch instead has
\(M(t)\le t+t^2=o(\sqrt t)\); fixed finite truncations cannot
replace this input.

## 3. Cut localization, both orientations, and concentration

On a descendant path \(y=w_0,\ldots,w_L\) below a cut edge \(py\),
the inward fields \(H_i=h_{w_i\to w_{i+1}}\) include an entering
message from above the cut. Delete it at \(w_0\), and propagate this
deletion through \(\psi\), leaving the side messages unchanged.
Explicitly,
\[
 \widetilde H_0=X_y+
   \sum_{u\in\operatorname{Ch}(y)\setminus\{w_1\}}\psi(h_{u\to y}),
\]
\[
 \widetilde H_i=X_{w_i}+\psi(\widetilde H_{i-1})+
   \sum_{u\in\operatorname{Ch}(w_i)\setminus\{w_{i+1}\}}
                                      \psi(h_{u\to w_i}).
\]
These are functions only of the **original infinite-component**
observations below \(y\). No interpretation as a finite-tree
posterior is used. Because \(|\psi'|\le\theta\),
\(|H_i-\widetilde H_i|\le\beta\theta^i\). Differentiation gives
\[
 (\log a)'(z)=
  -\frac{2(1-\theta^2)\tanh z}{1-\theta^2\tanh^2z},
 \qquad |(\log a)'(z)|\le2|\tanh z|\le2.
\]
Therefore the squared-product log cost is at most
\(4\beta\sum_{i<L}\theta^i\le4\beta/(1-\theta)\). Write
\(C_{\rm cut}=\exp(4\beta/(1-\theta))\).

Given the path spins, select one intact off-path child at every
factor. There are \(b-1=d-2\ge1\), including at the cut root after
deleting its parent. This covers \(d=3,L=1\).
For the outward product integrate these independent selected
components **near to far**: every remaining factor excludes the
component just integrated. For the modified inward product integrate
them **far to near**: after removing factor \(i\), all remaining
factors have smaller indices and do not use its selected child.
The shift in (A) is fixed by the other observations in each step.
Both conditional product expectations are consequently at most
\((1-c_0\omega)^L\le e^{-c_0\omega L}\).

For a path average of length \(\ell\), with no first-step exclusion
or one forbidden neighbor, take \(k=\lfloor\ell/2\rfloor\) and
\(L=\ell-k\). The allowed cut level has
\(N=(d-|F|)b^{k-1}\ge b^k\) vertices. Every cut component has
\(b^L\) descendant continuations. Delete the first \(k\) squared
factors, and for inward continuations pay \(C_{\rm cut}\). The
average \(G_\ell^\varepsilon\), for \(\varepsilon=+,-\), is at most
\[
 \frac{C_{\rm cut}}{N}\sum_y Z_y^\varepsilon,
 \quad 0\le Z_y^\varepsilon\le1,\qquad
 \mathbb E[Z_y^\varepsilon\mid\sigma_y]\le e^{-c_0\omega L}.
\]
The \(Z_y^\varepsilon\) use only their own infinite cut components;
given **all** cut spins they are independent. This is precisely where
localization is necessary for the inward orientation.

Here is a self-contained bounded-sum concentration input. For a
variable in \([0,1]\), the second derivative of its log moment
generating function is a tilted variance, at most \(1/4\) because
\(\mathbb EZ^2\le\mathbb EZ\) and \(m-m^2\le1/4\).
Integrating twice gives
\(\log\mathbb E e^{\lambda(Z-\mathbb EZ)}\le\lambda^2/8\).
Multiplication for independent variables and optimizing the Chernoff
bound at \(\lambda=4a\) gives
\(\mathbb P(N^{-1}\sum(Z_i-\mathbb EZ_i)>a)\le e^{-2Na^2}\).
The same proof applies to each conditional product law.

Set
\[
 \eta=\min(c_0/4,\log b/8),\quad
 C_0=\max(2,4\log2/c_0),\quad
 \ell_*=\lceil C_0/\omega\rceil.
\]
For \(\ell\ge\ell_*\), put \(\tau=e^{-\eta\omega\ell}\).
Every conditional mean is at most \(\tau/2\), and
\(N\tau^2\ge b^{\ell/4}/b\). Thus in either orientation, uniformly
in the vertex and allowed exclusion,
\[
 \mathbb P(G_\ell^\varepsilon>C_{\rm cut}e^{-\eta\omega\ell})
 \le\varepsilon_\ell:=
                    \exp[-b^{\ell/4}/(2b)].
 \tag{B}
\]
The constants depend only on \(d\), not on \(t,\ell\). Integrating the
conditional bound removes the cut-spin conditioning.

In any extension of this marginal probability space, any bounded
nonnegative weight \(\zeta\), however dependent on either copy, obeys
\[
 \mathbb E[\zeta G_\ell^\varepsilon]
 \le C_{\rm cut}e^{-\eta\omega\ell}\mathbb E\zeta
                                      +\|\zeta\|_\infty\varepsilon_\ell.
 \tag{C}
\]
Split on the event in (B), and use \(G\le1\) on that event.
No conditional variance estimate and no independence from \(\zeta\)
is used.

## 4. The path-variance prerequisite without a factor assumption

This verifies the exact spectral input to the weighted proposition.
The observation law \(\nu\) includes all continuous paths. A
square-integrable centered vertex assignment, measurable from the
full histories in a radius-\(R\) ball, satisfies
\[
 |\mathbb E_\nu f_u f_v|\le b^R\|f\|_2^2 b^{-\operatorname{dist}(u,v)/2}.
 \tag{D}
\]
For distance greater than \(2R\), condition on the two endpoint
spins of the connecting segment between the balls. Its length is
\(\operatorname{dist}(u,v)-2R\). The two ball histories are
conditionally independent, their centered conditional means are
\(\alpha_u\sigma,\alpha_v\sigma'\), and \(|\alpha_u|,|\alpha_v|
\le\|f\|_2\). Their correlation is \(\theta^{\operatorname{dist}-2R}\).
For shorter distances Cauchy--Schwarz gives (D).

The neighbor average \(\mathsf A\) on equivariant vertex assignments
is self-adjoint: interchange adjacent vertices by an automorphism
in the edge inner product. Put \(\rho=2\sqrt b/(b+1)<1\).
For simple random walk \(P\), the positive function
\(q(v)=b^{-\operatorname{dist}(o,v)/2}\) satisfies \(Pq\le\rho q\)
(equality away from \(o\)). Therefore (D) implies
\[
 \|\mathsf A^n f\|_2^2
   =\sum_v p_{2n}(o,v)\mathbb E f_o f_v
   \le b^R\|f\|_2^2\rho^{2n}.
\]
The self-adjoint spectral-measure theorem, followed by \(n\to\infty\),
puts the spectral measure of every such local \(f\) inside
\([-\rho,\rho]\). Local conditional expectations on growing balls
are equivariant and dense in the centered assignment space, so the
same holds throughout that space.

For an arbitrary invariant self-joining \(\pi\), let
\(\delta f=f(X)-f(X')\). It is bounded as a map between assignment
spaces: \(\|\delta f\|_\pi\le2\|f\|_\nu\), and commutes with the
neighbor average. On the closure \(\mathcal K\) of vertex
differences, the joined neighbor average is self-adjoint and has
norm at most \(\rho\). To see this without an inverse norm bound,
apply the preceding spectral-measure argument to
\[
 \|\mathsf A_\pi^n\delta f\|_\pi
       \le2\rho^n\|f-\mathbb Ef\|_\nu,
\]
then close the range of the spectral projection. The constant may
depend on the preimage; only the exponential rate is needed.
This does not say that the whole joining is FIID or tempered.

On directed-edge differences let \(\mathsf F,\mathsf H\) be the
tail and head lifts, \(\mathsf J\) reversal, and \(\mathsf N\) the
forward nonbacktracking average. Direct finite-sum calculation gives
\[
 \mathsf F^*\mathsf H=\mathsf H^*\mathsf F=\mathsf A,\quad
 \mathsf N=(d/b)\mathsf H\mathsf F^*-b^{-1}\mathsf J,\quad
 \mathsf N\mathsf F=\mathsf H,\quad
 \mathsf N\mathsf H=(d/b)\mathsf H\mathsf A-b^{-1}\mathsf F.
\]
All these maps commute with \(\delta\) and preserve the relevant
closed difference spaces. For
\(\mathsf R(f,g)=\mathsf Ff+\mathsf Hg\),
\[
 (1-\rho)(\|f\|^2+\|g\|^2)
 \le\|\mathsf R(f,g)\|^2
 \le(1+\rho)(\|f\|^2+\|g\|^2).
\]
Thus its range \(\mathcal L\) is closed and \(\mathsf R\) is an
isomorphism onto it. On the orthogonal complement of this range both
lift adjoints vanish and \(\mathsf N=-b^{-1}\mathsf J\). On its
range the conjugate is
\[
 \mathsf T=\begin{pmatrix}0&-b^{-1}I\\I&(d/b)\mathsf A_{\mathcal K}\end{pmatrix}.
\]
Set \(\mathsf Z=\sqrt b\,\mathsf T\) and let
\(\mathsf B\) be the diagonal operator with both blocks
\(d\mathsf A_{\mathcal K}/(2\sqrt b)\). Then
\(\|\mathsf B\|\le1\), \(\mathsf B\) is self-adjoint,
\(\mathsf Z\mathsf B=\mathsf B\mathsf Z\), and
\(\mathsf Z^2-2\mathsf B\mathsf Z+I=0\).
Consequently
\(\mathsf Z^n=U_{n-1}(\mathsf B)\mathsf Z-U_{n-2}(\mathsf B)\)
for \(n\ge1\), with \(U_{-1}=0\). The identity
\(U_m(\cos s)=\sum_{j=0}^m e^{i(m-2j)s}\) gives
\(\|U_m(\mathsf B)\|\le m+1\), endpoints included.
Also \(\|\mathsf Z\|\le\sqrt b+2\). Hence on the closed edge
difference space \(\mathcal D\),
\[
 \|\mathsf N^n\|\le C_d(n+1)b^{-n/2}.
 \tag{E}
\]
The orthogonal complement decays as \(b^{-n}\); reversal gives the
adjoint estimate. No spectral theorem is applied to \(\mathsf N\).
In scalar fibers the normalized matrix is similar to
\(\left(\begin{smallmatrix}0&-1\\1&2x\end{smallmatrix}\right)\).
At \(x=1\) its \(n\)-th power has entries \(1-n,-n,n,1+n\).
Discarding this linear endpoint growth would be erroneous; the
present proof retains it. Lean checks the all-\(n\) formula.

For edge differences \(D=\delta g\), invariance makes a fixed
lag-\(n\) path correlation equal to
\(\langle D,\mathsf N^nD\rangle\). A finite average of
nonbacktracking continuations proves this identity. Expanding the
square and using (E) yields, in either path direction,
\[
 \mathbb E_\pi\left(\sum_{i=1}^rD_{e_i}\right)^2
 \le rS\left[1+2C_d\sum_{n\ge1}(n+1)b^{-n/2}\right]
 =C_{\rm var}rS. \tag{F}
\]
For \(g_{(i,j)}=\log a(h_{j\to i}(t))\), square integrability follows
from \(|\log a(Y)|\le2|Y|\le2(|X_j(t)|+b\beta)\).
This establishes the required input at every finite time for the
actual joined marginals without assuming their desired factor map.

## 5. Infinite innovations and the actual conditional copies

Here are the prerequisites connecting the marginal inequalities to
the actual joining, rather than a hypothetical pair of fields.

First, \(W_v=X_v-\int m_v\) is a continuous square-integrable
martingale in the observation filtration by the conditional increment
calculation
\(\mathbb E[X_v(t)-X_v(s)\mid\mathcal F_s]=(t-s)m_v(s)\).
Its quadratic covariations are \([W_v,W_u]_t=\mathbf1_{u=v}t\).
Levy characterization therefore makes every finite subvector Brownian.
Passage to usual augmentation follows by reverse conditional
expectation and \(L^2\) continuity. A cylinder argument makes the
whole future increment array independent of the observation past.

It is important not to infer martingale representation merely from
this Brownian property. In a finite observation ball \(D\), Ito applied
to the explicit finite posterior gives
\[
 \mathbb E[m_v^D(t)^2]
       =\mathbb E\int_0^t\sum_{u\in D}(C_{vu}^D)^2\,ds.
\]
No energy escapes on passing to infinite volume. For \(s\ge\delta>0\)
and every finite boundary shape, integrate the own Gaussian noise of
successive path targets to obtain
\(\mathbb E(C_{vu}^D(s))^2\le\theta^{2r}(1-\kappa_\delta)^r\).
A Gaussian of variance \(s\ge\delta\) has at most half its mass in a
sufficiently short fixed interval, uniformly in its mean; the bound
on \(a\) in Section 2 then supplies \(\kappa_\delta>0\). Later
outward fields exclude the noise just integrated, including at a leaf.
Near zero, conditional Jensen and the site information bound give
\[
 \sup_D\mathbb E\int_0^\delta\sum_u(C_{vu}^D)^2\,ds
       \le\mathbb Em_v(\delta)^2\le C\sqrt\delta.
\]
Thus the integrated spatial tail is bounded by
\(C\sqrt\delta+(d/b)T\sum_{r>L}(1-\kappa_\delta)^r\).
First send \(L\to\infty\), then \(\delta\downarrow0\).
Coordinatewise conditional-expectation convergence and this uniform
tail bound imply the exact infinite energy identity
\[
 \mathbb Em_v(t)^2=\mathbb E\int_0^t\sum_uC_{vu}^2\,ds.
\]

For a bounded observation-adapted elementary process \(G\), direct
testing in the planted filtration gives
\[
 \mathbb E\left[m_v(t)\int_0^tG\,dW_u\right]
       =\mathbb E\int_0^t G C_{vu}\,ds.
\]
Replace \(m_v(t)\) by \(\sigma_v\) in the left expectation and use
\(dW_u=dB_u+(\sigma_u-m_u)\,ds\); the Brownian term has mean zero,
and conditioning the other term on the observation history gives
the covariance. Finite posterior coefficients, sampled at left
mesh endpoints, approximate \(C_{vu}\) in \(L^2(ds\,dP)\).
Isometry passes the test to \(G=C_{vu}\). For a finite set \(F\),
orthogonality of distinct Brownian coordinates now gives the residual
identity
\[
 \mathbb E\left(m_v(t)-\sum_{u\in F}\int_0^tC_{vu}\,dW_u\right)^2
      =\sum_{u\notin F}\mathbb E\int_0^tC_{vu}^2\,ds.
\]
It tends to zero; Doob gives maximal \(L^2\) convergence on compact
horizons. This proves a continuous posterior modification and
excludes an orthogonal residual martingale.

The field bound keeps this continuous mean strictly inside \((-1,1)\)
on every compact horizon. For adjacent site fields \(H,K\), the
equations \(x+\psi(y)=H,\ y+\psi(x)=K\) have a unique solution by
the contraction \(x\mapsto H-\psi(K-\psi(x))\), with constant
\(\theta^2<1\). The solution is continuous in \(H,K\) and at each
fixed time equals the raw component fields. This supplies continuous
component modifications. To retain pointwise component locality,
select the limit of each raw component field at
\(q_n(t)=2^{-n}\lfloor2^nt\rfloor\), using zero on failure.
The whole sequence and failure decision use only its own component
past. Countably many dyadic-time identities and continuity make this
selector the continuous modification simultaneously at all times,
almost surely. The same selection for site means is causal and
equivariant. This construction does not use \(W\) to recover \(X\).

The infinite-side attenuation in Section 2 also implies
\[
 \mathbb E\sum_uc_{vu}(t)^2
 \le1+(d/b)\sum_{r\ge1}e^{-c_0\omega(t)r}
 \le C/\omega(t).
\]
Since \(1/\omega\) is time-integrable at zero, Ito applied to atanh,
stopped away from \(\pm1\), and then removal of stopping yield
\[
 dh_v=\sum_uc_{vu}\,dW_u+m_v A_v\,dt,\qquad A_v=\sum_uc_{vu}^2.
 \tag{G}
\]
Brownian sums converge in maximal \(L^2\); the drift is absolutely
integrable. Setting \(A_v=0\) on its product-measure null infinite
set changes no integral. The critical infinite value at time zero
does not enter an integral.

Now disintegrate \((X,W)\) and form the actual conditionally
independent copies given the entire \(W\). For any bounded past
function \(F\), independence of future innovation increments in the
original law gives
\[
 \mathbb E[F(X_{\le t})\mid W]
       =\mathbb E[F(X_{\le t})\mid W_{\le t}].
\]
Conditional independence of the copies makes the expectation of a
product of two past functions the product of these two functions of
\(W_{\le t}\). Product Wiener increments are independent of it.
Monotone classes and usual augmentation therefore make \(W\)
Brownian also in the joined filtration. This is compatible
conditioning on the whole future, not an assumption that it reveals
no future information.

Transport (G) using bounded causal elementary observation
approximations of its coefficients. Their stochastic integrals are
explicit Borel path functions. The pair laws \((X^j,W)\) are the
original pair law, and isometry/Doob hold in the joined filtration.
Thus the elementary limits agree with the joined Ito integrals.
Integrated row-energy tails transport the infinite sums; rational
times and continuity transport the equations. Invariance of the
original pair law and uniqueness of disintegration give joined-law
invariance for each fixed automorphism. All path averages below are
finite, so they require only finitely many of these identities, never
one simultaneous exceptional set for the whole automorphism group.

Subtracting the innovation identities gives
\(|\Delta X_v(t)|\le2t\), and hence, on \([0,T]\),
\[
 |\Delta h_v|\le H_T=2T+2d\beta,\qquad
 |\Delta h_{j\to i}|
 \le\frac{|\Delta h_j|+\theta|\Delta h_i|}{1-\theta^2}.
 \tag{H}
\]
The second bound comes from substituting the two cavity difference
inequalities. In particular it is at most \(H_T/(1-\theta)\) and
its squared expectation is at most \(V/(1-\theta)^2\).
Ito applied to \((\Delta h_o)^2\), with the integrated row energy and
the deterministic bound \(H_T\), gives absolute continuity, \(V(0)=0\),
and
\[
 V'=\sum_u\mathbb E(\Delta c_{ou})^2+
       2\mathbb E[\Delta h_o(m_oA_o-m'_oA'_o)]
 \quad\text{a.e.} \tag{I}
\]
The martingale term has mean zero by its integrable bracket. These
are proved prerequisites of the comparison, not recovery assumptions.

## 6. Invariant averaging with the discrepancy weights

At a fixed time define, exactly as in the manuscript,
\[
 D_{(i,j)}=\log a(h_{j\to i})-\log a(h'_{j\to i}),\quad
 S=\mathbb E D_e^2,\quad V=\mathbb E(\Delta h_v)^2,
\]
\[
 P_r=\prod_{i=1}^r a(h_{v_i\to v_{i-1}}),\quad
 Q_r=\mathbb E[(P_r^2+(P'_r)^2)(\sum_iD_{e_i})^2],\quad
 L_r=\mathbb E[(\Delta h_{v_0})^2P_r^2].
\]
Equation (H) and the global log derivative bound imply
\[
 |D_e|\le D_T:=2H_T/(1-\theta),\qquad
 S\le4V/(1-\theta)^2.
 \tag{J}
\]
Dropping products and using (F) gives, for **every** \(r\ge1\),
\(Q_r\le2C_{\rm var}rS,\ L_r\le V\).

For long paths put \(p=\lfloor r/2\rfloor,\ q=r-p\), and split
the discrepancy sum as \(U+Z\) on the prefix and suffix. Fix the
prefix and average all \(q\)-step outward extensions. Its pointwise
stabilizer is transitive on those extensions. The indexed edges in
\(U\) stay fixed, even though their component fields need not be
local to that prefix. Invariance and deletion of prefix product
factors give
\[
 \mathbb E[P_r^2U^2]\le
       \mathbb E[U^2G_q^+(v_p;\{v_{p-1}\})].
 \tag{K}
\]
For the other half fix the **suffix** and vary reversed prefixes
\(w_0=v_p,w_1,\ldots,w_p\), avoiding \(v_{p+1}\). The complete path
is \((w_p,\ldots,w_1,w_0,v_{p+1},\ldots,v_r)\).
Its prefix product is
\(\prod_{i=1}^p a(h_{w_{i-1}\to w_i})^2\), the inward product,
not the outward one. The suffix stabilizer is transitive on these
prefixes; it is allowed to move the original starting vertex.
The indexed edges in \(Z\) stay fixed. Thus
\[
 \mathbb E[P_r^2Z^2]\le
       \mathbb E[Z^2G_p^-(v_p;\{v_{p+1}\})].
 \tag{L}
\]
These are finite invariant averages of expectations. They do not
assert a pointwise equality of a fixed path and its path average.

If \(r\ge2\ell_*(t)\), both half lengths meet the concentration
threshold. Apply (C), with (F) and the deterministic discrepancy
bound, to obtain
\[
 \mathbb E[P_r^2U^2]\le C_{\rm cut}C_{\rm var}
       e^{-\eta\omega q}pS+D_T^2p^2\varepsilon_q,
\]
and the analogous estimate for \(Z\), with \(p,q\) exchanged.
Apply the same argument to the second marginal. Using
\((U+Z)^2\le2U^2+2Z^2\), \(p,q\ge r/3\), gives the explicit bound
\[
 Q_r\le4C_{\rm cut}C_{\rm var}e^{-\eta\omega r/3}rS+
       4D_T^2r^2\exp[-b^{r/12}/(2b)].
 \tag{M}
\]
For \(L_r\), the root stabilizer fixes the vertex discrepancy and
is transitive on full paths, giving the **expectation** identity
\(L_r=\mathbb E[(\Delta h_{v_0})^2G_r^+(v_0;\varnothing)]\).
For \(r\ge\ell_*(t)\), (C) yields
\[
 L_r\le C_{\rm cut}e^{-\eta\omega r}V+
       H_T^2\exp[-b^{r/4}/(2b)].
 \tag{N}
\]
Choosing a sufficiently small positive \(c=c(d)\) in (M),(N)
is exactly the stated weighted proposition. Its common restriction
is \(r\ge2\ell_*\), and
\(\ell_*\le(C_0+1)/\omega\). There is no hidden assertion at shorter
lengths; those use the unweighted bounds.

## 7. All moments, small fields, and a discrepancy-sensitive loss

The second moment satisfies \(A_2(t)=\mathbb E|Y|^2\le C\sqrt t\)
at small times. On \(|X_v|\le1\), \(Y\) is in a fixed compact
interval and \(Y^2\le C\tanh^2Y\). On its complement use
\(Y^2\le2X_v^2+2b^2\beta^2\) and a Gaussian
\(Ce^{-c/t}\) tail. Cauchy--Schwarz gives
\(A_1\le C^{1/2}t^{1/4}\). All higher moments are finite before
induction by the same field bound.

Condition on \(\sigma_v=+1\). The own observation
\(t+\sqrt t G\) and the \(b\) child observations are independent.
Their absolute child moments are unchanged by this conditioning:
the neighbor-spin tilt integrates to zero against the even
function \(|\psi(Y)|^r\). Thus each is at most
\(\theta^r A_r\). Also
\(\mathbb E|t+\sqrt tG|^r\le e^{K_0r^2}t^{r/4}\) for
integer \(r\ge1,\ t\le1\), by elementary Gaussian moments.

Suppose \(A_r\le e^{Kr^2}t^{r/4}\) for all integers \(r<p\).
Expand the \(p\)-th power of the sum of absolute values in the
cavity equation. Single-child terms total \(b\theta^p A_p\).
The single-own term is at most \(e^{Kp^2/2}t^{p/4}\) if \(K\ge2K_0\).
Every other exponent vector has at least two positive entries,
all below \(p\), and
\(\sum r_i^2\le(p-1)^2+1=p^2-2(p-1)\).
Merge positive entries until two remain; for two positive integer
parts the remaining assertion is
\[
 (p-1)^2+1-r^2-(p-r)^2=2(r-1)(p-r-1)\ge0.
\]
The sum of all multinomial coefficients is \((b+1)^p\). Hence
\[
 (1-b\theta^p)A_p
 \le e^{Kp^2}t^{p/4}
    [e^{-Kp^2/2}+(b+1)^p e^{-2K(p-1)}]. \tag{O}
\]
For every integer \(p\ge3\),
\(1-b\theta^p\ge\kappa_b:=1-b^{-1/2}>0\).
Choose a **single** \(K\) covering the base cases, \(2K_0\), and
\(\log(b+1)+\log(2/\kappa_b)+1\). The bracket at \(p=3\) is at
most \(\kappa_b\), and both terms decrease thereafter:
the second has ratio \((b+1)e^{-2K}<1\). This closes induction
uniformly over all integer \(p\) and \(t\le t_0\).
The all-order critical gap is formalized, not just sampled.

Set \(L=\log(1/t)\). For \(L\ge32K\), choose the integer
\(p=\lfloor L/(16K)\rfloor\). Then
\(L/(32K)\le p\le L/(16K)\), and Markov gives
\[
 \mathbb P(|Y|>t^{1/8})
 \le e^{Kp^2-pL/8}
 \le e^{-pL/16}\le e^{-L^2/(512K)}. \tag{P}
\]
Evenness and the tilt identities give the same moment and tail
bounds conditional on either component-root or deleted-neighbor
spin. For two copies, a union bound uses only their marginals.

Choose \(K_T>\max(1,H_T^2)\) and put
\(I=1+\log(K_T/V)>1\) when \(V>0\).
On \(|Y|,|Y'|\le t^{1/8}\), the log derivative is at most
\(2t^{1/8}\); (H) bounds this contribution to \(S\) by
\(Ct^{1/4}V\). On the complementary event, (J) gives \(CV\),
while (P) and the deterministic bound give \(C_Te^{-cL^2}\).
Thus the exceptional contribution is
\(\min(CV,C_Te^{-cL^2})\).
If \(V\le e^{-cL^2/2}\), then \(I\ge cL^2/2\), so use its first
bound. Otherwise divide its second bound by \(V\) and use
\(L^2e^{-cL^2/2}\le C\). In either case
\[
 S\le C_TV[t^{1/4}+I/L^2]. \tag{Q}
\]
The \(I\)-dependence is essential when \(V\) is much smaller than
the exceptional probability; no positive lower bound on \(V\) is
assumed.

## 8. Exceptional path tails and the actual critical closure

From (M),(N), decrease constants to write their exceptional terms
as \(C_T r^2e^{-\alpha b^{\gamma r}}\) and
\(C_Te^{-\alpha b^{\gamma r}}\), valid for \(r\ge C'_0/\omega\).
Choose \(C_1\ge C'_0\) so that
\(\gamma C_1\log b\ge1\) and
\((\alpha/2)b^{\gamma C_1}\ge2\), and take
\[
 R=\left\lceil C_1(\omega^{-1}+\log I)\right\rceil.
\]
For \(r>R\), \((\alpha/2)b^{\gamma r}\ge2I\), and hence
\[
 e^{-\alpha b^{\gamma r}}
 \le e^{-2I}e^{-(\alpha/2)b^{\gamma r}}
 =e^{-2}(V/K_T)^2e^{-(\alpha/2)b^{\gamma r}}
 \le V^2e^{-(\alpha/2)b^{\gamma r}}. \tag{R}
\]
This also holds for \(V\ge1\); \(K_T>H_T^2\) ensures \(I>1\).
An arbitrary cutoff depending only on \(t\) would not suffice
uniformly as \(V\downarrow0\).

For \(r\le R\) use the unweighted bounds. For \(r>R\), use (R),
\(\sqrt{x+y}\le\sqrt x+\sqrt y\), and
\(\sum r^p e^{-c\omega r}\le C_{p,c}\omega^{-p-1}\)
for \(p=0,1/2,1\). The latter follows by comparison with the
integral of \((x+1)^p e^{-c\omega x}\) and rescaling. All remaining
double-exponential series converge. This gives
\[
 \sum Q_r\le C_T[S(\omega^{-2}+(\log I)^2)+V^2],
\]
\[
 \sum\sqrt{Q_r}\le C_T[\sqrt S(\omega^{-3/2}
                                    +(\log I)^{3/2})+V],
\]
\[
 \sum L_r\le C_T[V(\omega^{-1}+\log I)+V^2]. \tag{S}
\]
In the middle expression the square root of the absorbed \(V^2\)
is **\(V\)**, not a discrepancy-independent constant.

To check the evolution reduction, use
\(\log P_r-\log P'_r=\sum D_{e_i}\) and the mean-value bounds
\[
 \mathbb E(P_r-P'_r)^2\le2Q_r,\quad
 |P_r^2-(P'_r)^2|\le2(P_r^2+(P'_r)^2)|\sum D_{e_i}|.
\]
There are \(n_r=db^{r-1}\) vertices in shell \(r\), and
\(n_r\theta^{2r}=d/b\).
The noise in (I) is bounded by \(2\sum n_r\theta^{2r}Q_r\).
Split the drift as
\((m-m')A+m'(A-A')\). The first part contributes at most
\(V+\sum n_r\theta^{2r}L_r\), using the 1-Lipschitz tanh.
Weighted Cauchy--Schwarz bounds the second by
\(2\sqrt{2V}\sum n_r\theta^{2r}\sqrt{Q_r}\).
These bounds may first be applied to finite spatial sums; (S)
then makes their extended right sides finite for \(V>0,t>0\).
Consequently
\[
 V'\le C[V+\sum Q_r+\sum L_r+\sqrt V\sum\sqrt{Q_r}]
 \quad\text{a.e. on }\{t>0,V(t)>0\}. \tag{T}
\]

Insert (S). Use \(S\le CV\) everywhere except \(S\omega^{-2}\),
and use \(V\le H_T^2\) to absorb \(V^2,V^{3/2}\).
For \(I\ge1\), \((\log I)^p\le C_p I\) for \(0<p\le2\).
The worst drift term is
\(\sqrt{VS}\omega^{-3/2}\le CVt^{-3/4}\) at small times.
For the remaining noise term (Q) gives
\[
 S\omega^{-2}=S/t
 \le C_TV[t^{-3/4}+I/(t\log^2(1/t))].
\]
Thus for \(t\le t_*\le e^{-1}\),
\[
 V'\le k_T(t)VI,\quad
 k_T(t)=C_T[1+t^{-3/4}+1/(t\log^2(1/t))].
 \tag{U}
\]
For \(t>t_*\), bounded-away-from-zero \(\omega\) and (J) give a
bounded \(k_T\). Crucially
\[
 \int_0^{t_*}t^{-3/4}\,dt=4t_*^{1/4},\quad
 \int_0^{t_*}\frac{dt}{t\log^2(1/t)}
       =1/\log(1/t_*).
\]

Here is the absolutely continuous endpoint argument. If \(V(t)>0\),
let \(a<t\) be the left endpoint of its positivity component.
Continuity and \(V(0)=0\) imply \(V(a)=0\).
For \(a<u<t\), \(V\) stays bounded away from zero on \([u,t]\).
The chain rule for an absolutely continuous function composed with
a function having bounded derivative on its range gives
\[
 (\log I)'=-V'/(VI)\ge-k_T,\quad
 \log I(u)\le\log I(t)+\int_a^t k_T(s)\,ds<\infty.
\]
The bound is independent of \(u\). But \(V(u)\to0\) as
\(u\downarrow a\), forcing \(\log I(u)\to\infty\), a contradiction.
There is no division by \(V\) at its zeros. Therefore \(V=0\)
on every finite horizon and at all times. Equality of observations
then follows from the innovation identity, not conversely.

## 9. General logarithmic-tail comparison principle and its boundary

Here is a standalone estimate-level generalization. Fix
\(T,H,K>0\), with \(K>\max(1,H^2)\), and let
\(V:[0,T]\to[0,H^2]\) be absolutely continuous, \(V(0)=0\).
Let \(S,Q_r,L_r\) be nonnegative measurable functions, indexed by
integers \(r\ge1\). Suppose, with fixed positive constants, that
\(S\le CV\), \(Q_r\le CrS\), \(L_r\le V\), and, whenever
\(r\ge C'_0/\omega(t)\),
\[
 Q_r\le Ce^{-c\omega r}rS+C_T r^2e^{-\alpha b^{\gamma r}},
 \quad L_r\le Ce^{-c\omega r}V+C_Te^{-\alpha b^{\gamma r}}.
\]
Assume the a.e. variance reduction (T) on the positive set of \(V\).
For some \(\delta>0,\ q>1,\ t_*\in(0,e^{-1}]\), suppose also
\[
 S(t)\le C_TV(t)\left[t^\delta+
   \frac{1+\log(K/V(t))}{\log^q(1/t)}\right]
 \quad(0<t\le\min(t_*,T),\ V(t)>0). \tag{V}
\]
Then \(V\equiv0\).

**Proof.** The same discrepancy cutoff gives (S). Its reduction is
(U), now with the integrable coefficient
\[
 C_T[1+t^{-3/4}+t^{\delta-1}
                       +1/(t\log^q(1/t))].
\]
Besides the earlier power integral, the new integrals are
\[
 t_*^\delta/\delta,\qquad
 \log^{1-q}(1/t_*)/(q-1).
\]
The preceding positivity-component argument proves the assertion.
This theorem does not need fields, a tree, or a conditional-copy
construction once its explicit numerical hypotheses have been met.

To derive (V) from fields it is enough to have a derivative bound
\(|\ell'(z)|\le C|z|^m\) near zero, for any \(m>0\), the global
discrepancy comparison (H), a deterministic log discrepancy bound,
and
\(\mathbb P(|Y|>t^a)\le A e^{-c\log^q(1/t)}\) in both marginals
for some \(a>0\). Split at this field threshold just as in Section 7.
The good contribution is \(Ct^{2am}V\); the bad contribution is
\(\min(CV,C_Te^{-c\log^q(1/t)})\).
The same two-case comparison proves (V) with \(\delta=2am>0\).
No independence between the fields or the discrepancy is required.

For the moment-growth variant in Section 1, choose any threshold
exponent \(a'\in(0,a)\), and write \(D=a-a'>0\).
Markov bounds the tail by \(e^{Kp^s-DpL}\).
Take \(p=\lfloor(DL/(2K))^{1/(s-1)}\rfloor\); for large \(L\)
this integer is at least half the quantity inside the floor.
Then \(Kp^{s-1}\le DL/2\), and the exponent is at most
\(-cL^{1+1/(s-1)}=-cL^{s/(s-1)}\).
Thus every finite \(s>1\) gives \(q>1\). The actual Ising
application is \(s=2,a=1/4,a'=1/8,m=1\), proved above.

**Sharp boundary of this method, not of the Ising theorem.**
The assertion is false for the abstract numerical hypotheses if
\(q>1\) is replaced by \(q=1\). On \(0<t\le1/4\), set
\[
 V(t)=S(t)=t,\quad K=2,\quad H=1,\quad
 Q_r(t)=rt\,e^{-\sqrt t\,r},\quad L_r(t)=0,
\]
and take value zero for these functions at time zero.
All the unweighted and weighted path bounds hold, with no
exceptional term needed. Since \(I=\log(1/t)+1+\log2\),
(V) with \(q=1\) holds for every \(\delta>0\), with constant one.
The exact noise sum is
\[
 \sum_{r\ge1}Q_r
       =\frac{t e^{-\sqrt t}}{(1-e^{-\sqrt t})^2}\ge\frac12.
\]
Indeed put \(x=\sqrt t\le1/2\); \(1-e^{-x}\le x\) and
\(e^{-x}\ge1-x\ge1/2\). Thus (T) holds with constant two
while \(V'=1\) and \(V\not\equiv0\).
This exhibits a genuine obstruction to deriving uniqueness from
those estimates at logarithmic-tail exponent one. It says nothing
about whether such numerical data arise from Ising copies.

## 10. Exact evidence and what remains human mathematics

Run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/critical_endpoint/verify.py
```

`verify.py --write-certificate` regenerates `exact_certificate.json`.
The verifier checks rational identities, sign-sensitive factorizations,
the all-natural-number endpoint-power induction step, reverse-prefix
indices, exact series/antiderivatives, the recorded typed Jacobian
result, literal manuscript statement fragments, and freshness of the
real Lean run. A 16-case rational broadcast-cylinder calculation is
explicitly classified as a finite diagnostic. It does not certify
conditional independence of infinite histories by itself.

`Main.lean` formalizes the finite-dimensional kernel specified in
`statement_fidelity.md`, including the uniform all-order critical
moment gap and the endpoint matrix power for **all** natural indices.
The prescribed `lean_evidence verify --claim C_CE_ALGEBRA` compiler
record is the authority for that kernel. Its use is deliberately
narrow: no field law or probability space is encoded in Lean here.

The archived Jacobian operation is
`matrix.symbolic.characteristic_polynomial.compute`, on the exact
payload in `jacobian_payload.json`; `jacobian_output.json` retains
the server version, protocol, request, and typed output, and
`jacobian_status.json` records adapter completion. Its conclusion is
only \(\det(\lambda I-M(x))=\lambda^2-2x\lambda+1\), independently
replayed by SymPy. It is not treated as a proof of (E), (F), or
the critical theorem.

The genuinely infinite-law and analytic arguments in Sections 2--9
are mathematical proofs requiring independent reading. In particular
the script and the compiler are not substitutes for reviewing the
monotone-class extensions, spectral transfer, stochastic transport,
expectation induction, and absolutely continuous comparison. The proof
graph keeps these obligations separate and unconfirmed until that
review. The report does not claim an already completed independent
Reviewer verdict, global novelty certification, or a refutation.
