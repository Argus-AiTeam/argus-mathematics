# Strong SYZ: full cylinder, coordinate torus, and marked seed

## Exact target and source

**Engineer assessment: unresolved for the complete geometric construction, with supported conditional rotation and marking implications.** `C_SYZ@1` identifies the smooth-cylinder and angular-marking obligations outside the old clearing argument. This review checks the reference route and its precise prerequisites; it neither accepts the manuscript theorem nor supplies a new error search.

The reference is OpenAI, *The strong hyperkähler SYZ conjecture*, September 23, 2026, at **revision `4eaee87548250b2682affda7d05d947c05554bae`**. I read the theorem/setup, `metric_estimates.tex`, `completion.tex`, `rotation.tex`, and the necessary `polarized_family.tex` and `finiteness.tex` context. Paths are under `build/sections/` in `openai-math/preprints/The-Strong-Hyperkahler-SYZ-Conjecture-September-23-2026`. The old staging symlink reaches that declared root. These are manifest-matched **reference manuscript versions, not preserved Argus snapshot members**.

`thm:main` assumes a compact IHS Kähler \(X\) of complex dimension \(2n\), \(n\geq1\), and a holomorphic line bundle \(L\) with nonzero nef isotropic \(c_1(L)\). It concludes global generation of a positive power on the **given** \(X\), and a connected holomorphic Lagrangian fibration to a normal projective \(n\)-fold. There is no dimension, deformation-type, or \(b_2\) restriction. The \(b_2\geq5\) condition belongs instead to `cor:finiteness`: `finiteness.tex` uses Meyer to find an isotropic vector when one is not supplied, then invokes the main theorem and an external boundedness input. It cannot be imported into the main hypotheses.

## The family must retain the prescribed class

Write \(c_1(L)=m_0e\), with \(e\) primitive integral and its positive nef sign fixed. `prop:family` requires an actual algebraic polarized semistable degeneration of IHS manifolds in the marked component of \(X\), not merely an abstract degeneration with some isotropic monodromy line. Here \(e\) need not remain of type \((1,1)\): it is a labelled lattice vector, not already a holomorphic bundle on every intermediate fiber. Its smooth total space has reduced SNC central fiber. The polarization extends as a line bundle, ample on smooth fibers but not necessarily relatively ample at zero.

In the **full second-cohomology lattice**, it prescribes rational \(P=\langle e,f,v\rangle\), \(q(e,f)=1\), \(q(v)=a>0\), and
\[
p(\tau)=f+\tau v-\tfrac a2\tau^2e,\qquad
Me=e,\quad Mv=v-aw e,\quad Mf=f+w v-\tfrac{aw^2}2e.
\]
Thus \((M-1)P=\langle e,v\rangle\), with the original labelled \(e\). A ray \(\tau=\lambda+iy\), \(\lambda\notin\mathbb Q\), is retained after finite base changes.

The source normalizes \(\sigma_t\) by \(q([\sigma_t],e)=1\), derives \(\int|\sigma_t^n|^2\asymp(-\log|t|)^{2n}\), extends the logarithmic top form, and forces a nonzero maximal residue. The latter argument is specific: lesser crossings contribute \(O(s^{d-1})\); a maximal crossing whose coefficient vanishes contributes \(o(s^d)\) by dominated convergence on a rescaled simplex. These deductions require the prescribed family and normalization first. `lem:polarized-family-construction` additionally requires a free finite-index period quotient and a submersive local marked period lift; document existence or a lattice formula does not realize those data.

## Metric estimates do not stop at a generic regular region

`thm:torus` is a Calabi–Yau statement with complex dimension \(d\geq2\). Besides smooth projective fibers with trivial canonical bundle, it assumes a nowhere-zero volume form extending logarithmically,
\(cs^d\leq I_t=\int|\eta_t|^2\leq Cs^d\), and a crossing
\[
z_0\cdots z_d=t,\qquad
\eta_t=f(z)\,d\log z_1\wedge\cdots\wedge d\log z_d,\quad f(o)\ne0.
\]
It asserts an embedded special Lagrangian real \(d\)-torus **isotopic to an angular coordinate torus**, for every sufficiently small nonzero \(t\).

The scale is \(g_t=s g_t^{(0)}\), with \(s=-\log|t|\). The actual logarithmic model is
\(\gamma=\sum(dx_j^2+dy_j^2)\), \(x_j=\log|z_j|\), \(y_j=\arg z_j\), on interior-simplex tubes with all angular variables. Coordinate volume densities are uniformly comparable and converge subsequentially to a positive constant.

`lem:mixed-estimates` bounds both \(\int\operatorname{tr}_\gamma g_t\) and \(\int\operatorname{tr}_{g_t}\gamma\) by \(Cs^d\), using a fixed resolution of rational coordinate maps and averaged Fubini–Study forms. They have different jobs: many noncollapsed centers versus logarithmic gradient control. Curvature and projective-map energies are \(O(s^{d-2})\) and \(O(s^{d-1})\); their normalized averages tend to zero. `lem:many-noncollapsed-centers` and the maximal-function selection `eq:good-center` must produce one center with a uniform unit-ball volume lower bound and the energy/gradient estimates on **every radius**.

Einstein-limit theory then supplies a complete noncollapsed limit \(Z\), a smooth flat regular part \(G\), and \(\dim_{\rm H}(Z\setminus G)\leq N-4\), \(N=2d\). The source does not infer full coordinate convergence from concentration in measure alone: `lem:small-energy` and the projective embedding put regular compact subsets in the crossing chart, after which harmonic estimates improve the actual logarithmic coordinates.

## Exact completion and extension obligations

In `completion.tex`, the limiting map is
\[
F=(u_j+i\vartheta_j):G\longrightarrow
H=\mathbb C^d/(2\pi i\mathbb Z^d).
\]
It must be injective, locally biholomorphic, and have constant positive real Jacobian. `lem:capacity-extension` uses zero-capacity cutoffs across the singular set to extend the \(u_j\) weakly harmonically on the full \(\mathrm{RCD}(0,N)\) limit. The all-radius \(L^2\) growth then gives global derivative bounds; the Jacobian gives inverse derivative bounds. Merely having harmonic functions on \(G\) would not justify that estimate.

`lem:regular-paths` identifies intrinsic regular-set distance with ambient limit distance. `lem:full-cylinder` continues local inverses along paths avoiding \(F(Z\setminus G)\), uses completeness to prevent finite termination, and completes the dense inverse to a bi-Lipschitz homeomorphism \(Z\simeq H\). The next removal step uses simply connected complements in small complex balls, bounded parallel holomorphic coframes, distributional Cauchy–Riemann extension, and nonsingularity of the extended matrix. Only after showing every point has Euclidean tangent cones can smooth Einstein convergence be applied everywhere.

These are actual arguments in the reference, not omitted proof paragraphs. They specify the mathematical bridges requiring independent justification: weak harmonic extension, global distance/path lifting, smooth removal, and recovery of convergence in the **original** logarithmic charts. Flatness of a regular region alone does not establish them, and no old algebraic executable checks them. No decisive invalid argument is established by this review.

`lem:actual-log-convergence` requires every fixed tube \(Q_r=\{|\operatorname{Re}w|<r\}\), including its entire angular torus, to have inverse charts with smooth convergence of metric, Kähler form, and nonzero normalized volume form. It expressly retains \(\arg z_j\), not an arbitrary Cheeger–Gromov marking. The polarization's extension makes \(\omega_t\) exact on this tube. The perturbation uses that exactness and a phase with zero imaginary period; McLean's operator \(\alpha\mapsto(d\alpha,c\,d(*\alpha))\) is inverted on one-forms orthogonal to harmonic forms with exact-form targets. Small normal graphs yield an embedded torus and an explicit coordinate isotopy. An arbitrary topological torus or a fibration on a high-volume open subset would not meet this requirement.

## Conditional marking, rotation, and return

The angular marking has a concrete test. The loop embeddings keep \(z_j=r_je^{iy_j}\) fixed and set \(z_0=t e^{i\theta}/\prod z_j\). At \(2\pi\) they return as the **same parameterized map**. Given the coordinate isotopy just constructed, this proves \(i^*M=i^*\), hence \(i^*(M-1)=0\) in degree two. The prescribed periods put
\([\omega_K]=cy(v-a\lambda e)\) in that image.

`lem:rotation-criterion` correctly states the needed condition cohomologically: a compact embedded special Lagrangian \(T\) with \(i^*[\omega_K]=0\). Its proof uses Stokes, the calibrated period, and equality in Wirtinger's inequality to obtain pointwise \(J\)-complex tangency; it does not improperly identify exactness with pointwise zero. For a topological real torus, the Kähler Albanese argument then gives a complex torus.

Irrational \(\lambda\) makes rational \((1,1)\)-classes orthogonal to \(e,v\); the Lorentzian form forces every isotropic such class onto \(\mathbb Qe\) and excludes projectivity after rotation. Conditional on the constructed torus, Greb–Lehn–Rollenske supplies a fibration, whose nonzero semiample pullback has class \(ke\), \(k>0\). Injectivity of \(c_1\) makes the prescribed primitive bundle semiample. The retained component and positive sign then meet Soldatenkov–Verbitsky's **nonempty** semiample-locus hypothesis and return semiampleness to \(X\).

Accordingly, the unresolved obligation is to establish this marked seed through the specified family and full-cylinder construction, not to reprove known propagation. Absence of a verified seed does not show that no seed exists or that SYZ is false. No novelty or family completion is asserted. Native independent review is required and pending.
