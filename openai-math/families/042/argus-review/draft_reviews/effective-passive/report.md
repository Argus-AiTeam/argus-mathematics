# Effective bounds and passive holomorphic parameters

## Disposition and source

**Engineer assessment: the proposed quantitative and passive-holomorphic
strengthening is supported by the same prose construction, conditional on
the sewing hypotheses; independent acceptance is pending.** It is not a
second independent sewing proof or a verified original contribution.

The old assertions are `C_SEW_EFFECTIVE_PARAMETRIC` v1 and
`C_SEW_PASSIVE_HOLO` v1, in the old sewing report's Precise theorem and
Sections 3-8. Their base assertion is OpenAI's `sew:chain`, September 23,
2026. The manifest, revision and complete source hypotheses are recorded
in `../annular-sewing/report.md`; there is no manuscript-version mismatch.
The manuscript already asserts a uniform positive radius, arbitrary
fixed-order derivative approximation on smaller domains, the Fourier
method, and a quadratic iteration. The old draft makes constants,
moving-domain estimates and the passive extension explicit. That is a
proposed strengthening/reconstruction, not a novelty determination.

## Exact strengthened statement

Use the full bi-infinite exact, degree-one, compatible, symplectic chart
hypotheses of `sew:chain`, not merely a bound on transition Jacobians.
In maximum vector norm and its induced matrix norm, set
\[
\begin{split}
 N&=8(A+2),& K&=1024N^6,& c_0&=64,\\
 s_0&=h/2,&\rho_0&=r/2,&
 d&=\min\{1/4,h/(32c_0),r/(32c_0)\},\\
 e_*&=d^7/(1024K),&&&b&=r/4.
\end{split}
\]
Then \(0\leq e<e_*\) suffices. These quantities depend on \(h,r,A\),
not on individual lengths, their upper bound, or chain cardinality.
The zero-error case glues directly.

For the relative statement, \(T\) is any complex manifold and the given
charts, shears and lifted transition data depend jointly holomorphically
on \(t\in T\), with the same active-coordinate domains, lengths and
uniform bounds for every \(t\). The conclusion is a jointly holomorphic
\(\Phi:\mathbb C\times\Delta_{r/4}\times T\to M\), periodic in
the first variable. Symplecticity and immersion are on active
\((w,p)\)-slices. This does not assert a symplectic form or immersion
in all variables of the higher-dimensional product, uniform bounds on
passive derivatives, or a conclusion from independently chosen,
non-holomorphic slice-wise data.

## Numerical and all-index assessment

The Newton step supplies
\[
 e_{\rm new}\leq38N^3\delta^{-5}e^2
                    \leq K\delta^{-6}e^2
\]
provided \(K\delta^{-7}e\leq1/1024\). The bound follows from the
analytic estimates assessed in the sewing unit, not just from testing
that \(K\) is a large number. Since \(N\geq16\), the inequalities
used by the old checker even hold on its larger comparison range
\(N\geq1\).

Let \(\delta_n=d2^{-n}\), \(B=Kd^{-6}\), and
\(\theta=64Be_0<d/16\leq1/64\). Direct rescaling gives
\[
 x_n=B2^{6(n+1)}e_n,\quad x_{n+1}\leq x_n^2,\qquad
 e_n\leq B^{-1}2^{-6(n+1)}\theta^{2^n}.
\]
This is an induction for all \(n\). In particular,
\[
 K\delta_n^{-7}e_n
 \leq\frac{2^n\theta^{2^n}}{64d}
 \leq\frac{\theta(2\theta)^n}{64d}
 \leq1/1024,
\]
using \(2^n\geq n+1\). Thus the initial threshold actually enforces
the step's domain hypothesis at every stage; there is no missing
iteration-dependent threshold.

The quantitative margins are consistent:
\[
 c_0\sum\delta_n=2c_0d\leq\min(h,r)/16,\qquad
 s_\infty\geq7h/16,\quad\rho_\infty\geq7r/16>r/4.
\]
Using the stage smallness bound,
\[
 \sum_{m\geq n}e_m\leq\delta_n/512,\qquad
 \sum_n e_n/\delta_n\leq d^6/(1008K)<1.
\]
The former is much smaller than the remaining moving-edge margin
\(2c_0\delta_n\); the latter preserves the derivative bound \(A+1\).
Together with \(d\leq h/(32c_0)\), they preserve
\(|\operatorname{Im}a_j^{(n)}+L_j|<h/3<1/4\), which is the
Fourier-splitting hypothesis. These are inequalities on the full
domains, not a sample over a few \(p\) or \(j\).

The flow derivative product satisfies
\[
 S=\sum8N^2\delta_n^{-3}e_n
   \leq N^2d^4/(120K)\leq1/120,\qquad
 e^S\leq120/119.
\]
Hence the composed coordinate changes converge and stay close to the
identity. For any fixed derivative order \(k\), the majorant for
\(\sum\delta_n^{-k}e_n\) has successive ratio
\(2^{k-6}\theta^{2^n}\to0\); alternatively one can apply Cauchy's
formula on a fixed smaller limiting domain. No separate shrinking of
\(e_*\) for every derivative order is being silently asserted.

The geometric part of the estimate also has room: a local
\(\delta/N\) polydisc changes the slanted edge by at most
\(\delta/8\); the combined normalized displacement is less than that
polydisc; and \((A+2)N\delta^{-2}e+e<\delta/4\) controls the
moving edges. The 64-loss allocation in the old report leaves unused
buffer after the finitely many primitive, Cauchy, flow and composition
restrictions. This is why the particular constants can be supported,
rather than just an unspecified smaller threshold.

## Passive parameters: why arbitrary dimension does not add a loss

The input's uniform active bounds, not compactness of \(T\), do the
work. The mean-zero primitive is a fixed horizontal integral.
Fourier coefficients are fixed period integrals. Both preserve joint
holomorphicity. The double Fourier majorant is uniform in \(t\);
therefore its sums are normally convergent on local charts of
the product with \(T\). No derivative of a long translation sum
is estimated.

Hamiltonians have canonical means and primitives, and the time-one
flows and inverses are selected by the same small Picard contraction.
Those iterates and their normally convergent limits are jointly
holomorphic in the initial coordinates and \(t\). The active Cauchy
and displacement estimates are unchanged. Uniform convergence of the
composed corrections gives a jointly holomorphic limit locally on \(T\).

Each accumulated shear \(\sigma_j(p,t)\) is a finite holomorphic
sum. The lower edge spacing \(B_j-B_{j-1}\geq1-h/3\) holds
uniformly in \(t\). The translated blocks consequently give an open,
locally finite cover also on the product with local parameter charts;
their holomorphic maps agree on the same adjacent seams. This supplies
joint holomorphicity of the global map, not just separate slice-wise
solutions selected after the fact. Relative symplecticity only uses
active derivatives. No passive cohomology class or derivative estimate
is required by that conclusion.

The construction presupposes the jointly holomorphic input data in the
old statement's phrase "all hypotheses." Merely asserting that some
charts or lifts exist for each \(t\), with no compatible holomorphic
dependence, would be a different claim and would require a holomorphic
selection/descent argument. It is not the extension assessed here.

## Mechanical boundary and strongest-prior comparison

`../failed-attacks/checker-replay.json` records the successful unchanged
checker replay and its actual dependencies. It verifies scalar
identities and rational comparisons supporting the preceding estimates.
It does not prove a Cauchy estimate, a domain inclusion, normal
convergence, or holomorphic dependence over a manifold. Those conclusions
rest on the prose analysis above and in the old draft, pending native
independent review.

The old report already claimed these same constants and the arbitrary
passive-parameter extension. This assessment supplies no stronger
mathematical result. It distinguishes the effective claim from the
manuscript's existential one, checks its dependence on the sewing route,
and makes the relative meaning and uniformity explicit. The saved
certificate's `new_theorem` label is not accepted as a verified novelty
or publishability verdict.
