# Three-chart spectral rigidity, with finite-error stability

## Result and its status

**Theorem.** The spectral implication in the weighted manuscript, from
`plane:lem:mixture` through `plane:lem:unique`, is valid under its stated
spectral hypotheses. The corresponding two-arc argument gives the same
implication. In particular, the coefficient is unique, not just unique
within a selected subsequence. Here is a complete independent analytic
proof, including the exceptional lines, reciprocal alias, dispersion
summability, and noncompact cutoff limit.

The proof also establishes a stronger statement: each exact positive
Cauchy mixture can be replaced by a positive Cauchy mixture **plus an
arbitrary finite signed error**, including atomic errors. This does not
assume that one common finite correction restores all three exact
mixtures. A finite exceptional-line counterterm is then necessary in
the coefficient formula. Section 9 gives both an infinite-mass example
outside the exact-mixture class and an exact atomic example proving
the necessity of this counterterm.

The finite identities and rational inequalities are replayed by
`verify.py` against `exact_certificate.json`, including an independently
reconstructed Jacobian factorization. The measure-theoretic proof below
is a mathematical proof, **not a Lean/kernel-checked proof**. Neither
novelty nor independent Reviewer acceptance is claimed by the Engineer.
There is no counterexample to a manuscript claim in this deliverable.

## 1. Source-grounded scope

Paths in this section are relative to `research/openai_manuscript/`;
all contain an additional `build/` directory before the displayed file.

| Manuscript directory prefix | Exact source | Assertion under audit |
|---|---|---|
| `Gaussian-free-field-limits-of-weighted-integer-Lipschitz-heights-October-6-2026` | `sections/04-plane.tex`, `plane:lem:mixture`, `plane:lem:defect`, `lem:endcaps`, `plane:lem:subsequences`, `plane:lem:unique` | Positive mixtures and annular control force one inverse-Laplacian spectral tangent. |
| `The-Gaussian-free-field-limit-of-integer-Lipschitz-heights-with-two-arc-boundary-data-October-6-2026` | `sections/05-spectral.tex`, `prop:cauchy-mixture`, `lem:angular-poisson`, `prop:dispersion-defect`, `lem:endcap`, `lem:spectral-subsequences`, `prop:angular-sum` | The same mechanism, with an absolutely convergent dyadic angular sum determining the coefficient. |
| `Uniform-real-Lipschitz-surfaces-on-the-triangular-lattice-October-6-2026` | `paper.tex`, `thm:main` | A different real-valued surface/interface theorem, not a consequence of this spectral implication. |

The three main claims and their dependency spines are recorded separately
in the existing mathematical ledger and proof graph:

* `W232-MAIN`: weighted zero-boundary integer heights, fixed
  \(x\in[1/\sqrt2,1]\), converge after a positive normalization to the
  Dirichlet GFF, with mixed moments. Its additional obligations include
  plane-law construction and moment bounds, nondegeneracy, pin-bracket
  transfer, collision coefficients, and Wick recursion.
* `T232-MAIN`: odd integer heights with adjacent differences 0 or 2 and
  marked \(+1/-1\) boundary arcs converge to the harmonic extension plus
  a positively normalized GFF. Positive normalization, bounded-domain
  transfer, tightness, and higher moments remain separate obligations.
* `R232-MAIN`: uniform real-valued 1-Lipschitz surfaces have the stated
  GFF and SLE_4 limits. The reflected coupling, tangent response,
  conditional covariance, geometry, and height-gap arguments remain
  outside this mission.

In the original exact-mixture case we retain every relevant hypothesis:
the positive locally finite punctured reciprocal-torus measure, all
lattice rotations and reflections, the uniform small-annulus bound,
all three row charts, both mixture endpoints, and the two-sheet
projection. We do not assume a density for a tangential mixing measure,
a pre-existing scaling limit, strict positivity of its coefficient,
or a Gaussian field. The model-to-spectrum inputs are explicitly
unproved assumptions when applying this result to either main theorem.

**Known results and prior routes.** The ordinary positive-transfer
representation is not a new claim. The primary source
[Usui, arXiv:1201.3415v3, Theorem 2.1](https://arxiv.org/html/1201.3415v3#S2.ThmThm1)
was opened: its hypotheses (A1)--(A4) concern Hermiticity, translation
invariance, link reflection positivity, and polynomial boundedness; its
conclusion represents odd-time two-point functions by a positive
energy-momentum measure. That theorem alone is not the three-direction
rigidity or coefficient-uniqueness assertion here. We start with the
manuscripts' mixtures as explicit hypotheses, and import no application
of Usui's theorem into the proof below. A bounded literature/Wiki lookup
located no prior finite-error formulation; this is a search limitation,
not verified novelty. The retired route `S232-CLASSIFY-ONLY` incorrectly
tries to infer coefficient uniqueness from tangent classification alone;
Section 10 gives its exact obstruction.

## 2. Precise strengthened theorem

Let
\[
 T=\mathbb Z(1,0)+\mathbb Z(1/2,\sqrt3/2),\quad
 P=2\pi/\sqrt3,\quad
 T^*=\{(2\pi m,P(2n-m)):m,n\in\mathbb Z\}.
\]
Let \(C\) be a positive locally finite measure on
\((\mathbb R^2/T^*)\setminus\{0\}\), invariant under the lattice
rotations and reflections. Suppose that, for some \(\rho,K>0\),
\[
 C\{r\le |p|\le2r\}\le K\qquad(0<r<\rho).                 \tag{H1}
\]
All small disks use physical Euclidean representatives.

In each of the three row charts project to the reciprocal rectangle
\(\mathcal R=[-\pi,\pi)\times[-P/2,P/2)\). The covering has degree
two, with preimages of its origin \(0\) and \(a_*=(0,P)\) in the
horizontal chart. The omitted physical origin has mass zero by
convention. Suppose that on \(k\ne0\)
\[
 C'(dk,dl)=\int_{[0,\infty]}Q_s(dl)\,\nu(dk,ds)+E(dk,dl), \tag{H2}
\]
where \(\nu\ge0\) is finite on horizontal bands away from zero,
\[
 q_s(l)=\sum_{n\in\mathbb Z}
          \frac{s}{\pi(s^2+(l+nP)^2)},\quad
 Q_0=\delta_0,\quad Q_\infty=dl/P,
\]
and \(E\) extends to a finite signed measure on the rectangle.
The errors and mixtures may differ between the three charts.
Atoms and singular errors are allowed; no diffuseness is assumed.
The exact manuscript hypotheses are the case \(E=0\).

Then the image \(C_\delta\) of the physical measure near zero under
\(p\mapsto p/\delta\) converges vaguely on the entire punctured plane to
\[
                   c\,|p|^{-2}\,dp,\qquad
             0\le c\le \frac{K}{2\pi\log2}.               \tag{T}
\]
The coefficient is determined by the full scalar limit (12) below:
\(c=-2(L+B_0)/\pi\), where
\(B_0=\int_{\{k=0\}}Q(p)\,C(dp)\) is finite. For \(E=0\) one has
\(B_0=0\), recovering the manuscript formula exactly. Its endcap
bound is uniform; for general \(E\) the finite-error version (7)
and removal of the finite exceptional-line measure suffice.

## 3. Exceptional sets and weighted mixing mass

For a compact physical segment of \(k=0\) avoiding zero, rotation by
\(\pi/3\) maps \((0,l)\) to \((-\sqrt3 l/2,l/2)\). In the small chart
this is a graph, with both coordinates nonzero. Its section at fixed
tangential coordinate is a singleton with nonzero normal coordinate.
Every \(Q_s\) gives that section mass zero: finite positive \(s\) and
\(s=\infty\) are nonatomic, and \(Q_0\) is supported at zero. Tonelli's
theorem gives zero mixture mass to the graph. Projection only adds
positive physical mass. The \(C\) mass of any union of these segments
is therefore at most the total variation of \(E\) on their rotated
graph. Exhausting the small punctured line proves that its **total
mass is finite**. It is zero when \(E=0\), exactly as the weighted
manuscript requires. Repeat in the other two charts. Finite line
mass disappears under scaling on every compact punctured annulus.

Rotation maps \(a_*\) to \((-\pi,P/2)\). Its rectangular coordinates,
including the centered boundary representative, have both coordinates
nonzero. The same section argument gives
\(C\{a_*\}\le |E|\{(-\pi,P/2)\}\), interpreted on the rectangle.
In particular \(C\{a_*\}=0\) when \(E=0\). For the extended theorem
the alias is finite by local finiteness; its possible atom is excluded
by every rescaled set avoiding the rectangular origin. No two distinct
physical boundary representatives are identified in this argument.

Dyadic summation of (H1) gives
\[
              \int_{0<|p|<\rho}|p|^t\,dC<\infty
                         \quad(t>0).
\]
Using that each \(Q_s\) has mass one in (H2), for sufficiently small
\(\kappa>0\),
\[
 \int_{0<|k|<\kappa}|k|\,d\nu
 \le \int_{0<|k|<\kappa}|k|\,dC'
                         +\kappa\|E\|_{\rm TV}<\infty.   \tag{1}
\]
The physical-origin part is bounded by the \(t=1\) estimate; the
remaining physical preimage, including the alias neighborhood, has
finite mass. This does not presuppose a horizontal-band bound.

## 4. Exact harmonic identity and summable defect

Set
\[
 \chi(k,l)=1-\frac{8k^2l^2}{(k^2+l^2)^2},\qquad
 D(k,s)=\left(\frac{|k|-s}{|k|+s}\right)^2,\quad D(k,\infty)=1.
\]
The sixfold rotation sum of \(\chi\) is zero and \(|\chi|\le1\).
For \(a,s>0\),
\[
 \int_{\mathbb R}\chi(a,l)\frac{s\,dl}{\pi(s^2+l^2)}
                       =\frac{(a-s)^2}{(a+s)^2}.         \tag{2}
\]
An elementary derivation, not an appeal to a reconstruction theorem,
starts with partial fractions:
\[
 \int_{\mathbb R}\frac{l^2\,dl}{(l^2+a^2)(l^2+s^2)}
    =\frac{\pi}{a+s}.
\]
At \(a=s\) this follows by continuity. Differentiating with respect to
\(a>0\), justified by an integrable majorant on compact parameter
neighborhoods, gives
\(\int l^2/((l^2+a^2)^2(l^2+s^2))\,dl
 =\pi/(2a(a+s)^2)\). Substitution proves (2), including \(a=s\).
The elementary integral used here is the difference of the limits of
\(a^{-1}\arctan(l/a)\).

For clarity, the periodization error is uniform in \(s\), not merely
uniform on compact scale ratios. Write
\(f_a=1-\chi(a,\cdot)\). Then
\[
 \int_{\mathbb R}f_a\,dl=4\pi a,\qquad
 0\le f_a(l)\le8a^2/l^2.
\]
The omitted folded tails obey \(M_P\le2/P\): for the decreasing
function \(p_s(x)=s/(\pi(s^2+x^2))\), bound
\[
 \sum_{n\ne0}p_s(l+nP)
 \le 2\sum_{n\ge1}p_s(P(n-\tfrac12))
 \le 2p_s(P/2)+\frac2P\int_{P/2}^\infty p_s(x)\,dx
 \le \frac{2/\pi+1}{P}\le\frac2P .
\]
Consequently, for \(0<a<P/8\),
\[
 \left|\int\chi(a,l)Q_s(dl)-D(a,s)\right|
 \le 8\pi a/P+32a^2/P^2
 \le (8\pi+4)a/P.                                      \tag{3}
\]
For \(s=0\) the error is zero. For \(s=\infty\), use
\(P^{-1}\int f_a\le4\pi a/P\). Thus both endpoints are covered.

Integrate (3) over \(\epsilon<|k|<\kappa\). The error is uniformly
bounded by (1). The contribution of \(E\) is bounded by
\(\|E\|_{\rm TV}\). Replacing the rectangular integral by the physical
disk \(|p|<\kappa\) changes it by bounded finite outer and alias mass.
The full radial annulus has zero \(\chi\) integral by rotation.
The remaining signed integral is bounded above by the negative part
of the deleted cap \(|k|\le\epsilon\).

This negative part is confined to \(\epsilon<|p|<3\epsilon\):
the numerator of \(\chi\) is
\[
 N=k^4-6k^2l^2+l^4
   =(k^2-2kl-l^2)(k^2+2kl-l^2).
\]
If \(l^2\ge6k^2\), then
\(N=l^2(l^2-6k^2)+k^4\ge0\). Thus \(N<0\) implies
\(|p|^2<7k^2<9\epsilon^2\). Two annular bounds control this
negative cap. Since \(D\ge0\), monotone convergence now yields
\[
                  F:=\int_{0<|k|<\kappa}D\,d\nu<\infty. \tag{4}
\]
There is no assumption here that the positive part of the deleted
cap is small.

On \(r\le|k|\le2r\), the portion with
\(s\notin[r/2,4r]\) has \(D\ge1/9\), hence mass at most \(9F\).
On the remaining portion
\[
 Q_s\{|l|\le2r\}\ge(2/\pi)\arctan(1/2)\ge1/5
\]
for small \(r\), using the central unfolded term. Its \(\nu\) mass
is at most five times the \(C'\) mass of the indicated rectangle
plus five times \(\|E\|_{\rm TV}\). That physical rectangle lies
in two scale-\(r\) annuli on the origin sheet; the other sheet has
bounded finite mass. We obtain
\[
                  \nu\{r\le|k|\le2r\}\le B<\infty.       \tag{5}
\]
All constants may depend on the fixed measure and its error norms.

## 5. Endcaps, including the stability error

Let \(A_{b,h}=\{b<|p|\le2b,\ |k|\le h\}\), \(h<b/10\).
For sufficiently small \(b\), rotate by \(\pi/3\). In the new chart,
\[
       2b/3\le|k'|\le2b,\qquad b/3\le|l'|\le6b/5.       \tag{6}
\]
For example \(|l|\ge19b/20\) and
\(5/6\le\sqrt3/2\le7/8\) prove these loose rational bounds.
For fixed \(k'\), the old cap condition restricts \(l'\) to an
interval of length \(4h/\sqrt3\le3h\). On that interval the central
Cauchy density is at most \(1/(2\pi|l'|)\); the folded tails are at
most \(2/P\). With \(b<P/8\), their sum is at most \(1/b\).
The uniform endpoint satisfies the same bound, and the \(s=0\)
atom misses the interval. Two bands from (5) cover the tangential
range in (6). Positivity and (H2) give
\[
 C(A_{b,h})\le6B\,h/b+|E_{\rm rot}|(R A_{b,h}).           \tag{7}
\]
Here the rotated small physical disk is embedded in its rectangle.
For \(E=0\), this is exactly the required uniform endcap estimate.

For arbitrary errors apply the same bound to \(A_{b,h}\setminus L_0\),
where \(L_0=\{k=0\}\). Its error term is
\(|E_{\rm rot}|(R(A_{b,h}\setminus L_0))\). For disjoint dyadic caps
these terms sum to at most the error mass in a corridor of width
\(O(h)\), **excluding its central line**. These decreasing corridors
have empty intersection, so their mass tends to zero by finiteness,
even for atomic errors. Likewise, error mass in shrinking punctured
disks tends to zero even if there is an atom at their omitted origin.
The finite \(C\)-mass on \(L_0\), established in Section 3, vanishes
on rescaled compact annuli. A finite error is not incorrectly asserted
to obey a uniform \(h/b\) estimate or to have no atoms.

## 6. Classification of every spectral tangent

The annular bound gives vague sequential compactness on the punctured
plane, by exhaustion with compact annuli. Fix
\(0<a<b<\infty\) and the horizontal band
\(a\le|k|/\delta\le b\). Its rescaled mixing masses are bounded by
(5). Their integrals of \(D\) tend to zero by (4), because the
unscaled bands shrink to zero while excluding it.

For \(0<\epsilon<1\), outside
\(|s/|k|-1|<\epsilon\), including \(s=\infty\),
\[
                     D(k,s)\ge\epsilon^2/(2+\epsilon)^2. \tag{8}
\]
Hence all mixing mass away from the graph \(s=|k|\) disappears.
This proves tightness in the rescaled normal scale, rather than
assuming it. Uniformly on compact positive scale intervals and
compact normal coordinates,
\[
 \delta q_{\delta t}(\delta l)
          =\frac{t}{\pi(t^2+l^2)}+O(\delta).              \tag{9}
\]
This follows from the same folded-tail bound. Mixing mass outside
such intervals contributes at most its mass times the supremum of
the test and tends to zero by (8).

Extract the bounded tangential marginals on compact horizontal
bands. Testing (9) first near the graph and then letting its width
go to zero shows that every vague spectral tangent has, on \(k\ne0\),
\[
 M(dk,dl)=\frac{|k|}{\pi(k^2+l^2)}\,\eta(dk)\,dl          \tag{10}
\]
for a locally finite positive \(\eta\). This is a measure identity:
no density of \(\eta\) is presumed. A diagonal extraction makes
these descriptions agree on overlapping bands. Finite errors on
the shrinking bands vanish. The other physical preimage of a
bounded rescaled set shrinks to the nonzero alias; its mass
vanishes by local finiteness: the rescaled band excludes the alias
point itself. This remains true in the presence of an alias atom,
as correctly noted by the two-arc manuscript. In the exact-mixture
case Section 3 also removes that atom outright.

Multiplying (10) by \(|p|^2\) gives a measure with zero
distributional derivative in the chart-normal direction. At each
nonzero point at least two of the three tangential coordinates
are nonzero; their corresponding normals are independent.
On a sufficiently small ball both constant directional derivatives
of \(|p|^2M\) therefore vanish.

For completeness, convolve on a smaller ball with a smooth compact
approximate identity. The convolution has both derivatives zero,
hence is constant. Pairing with one test of integral one shows
that these constants converge as the approximate identity shrinks.
Thus the original distribution is constant on the smaller ball.
Constants agree on overlaps. The punctured plane is connected,
so
\[
                         M=c\,|p|^{-2}dp.               \tag{11}
\]
This argument covers the tangential zero lines using the other
charts, without extending an almost-everywhere formula across an
unchecked exceptional set. Positivity gives \(c\ge0\). Applying
the annular bound to the open annulus \(1<|p|<2\) in the vague
limit gives \(2\pi c\log2\le K\).

## 7. A full scalar limit fixes the coefficient

Choose any even smooth \(q\), \(0\le q\le1\), equal to one on
\([-1/2,1/2]\) and zero outside \((-1,1)\). Choose a smooth radial
\(Q\), \(0\le Q\le1\), equal to one near zero and supported in
a sufficiently small physical disk. Put
\[
 J(h)=\int Q(p)\chi(p)
                 [q(|p|/h)-q(k/h)]\,C(dp).
\]
The integrand vanishes near zero, so this is finite for every \(h>0\).
Subtracting the radial zero integral gives
\(J(h)=\int Q\chi[1-q(k/h)]\,dC\).
Replace the physical cutoff by \(0<|k|<\kappa\) in the rectangle.
The difference is supported on finite physical outer/alias mass
and has a limit by dominated convergence. The factor at \(k=0\)
is identically zero.

Write \(A(k,s)=\int\chi(k,l)Q_s(dl)\). Equations (1), (3), (4)
give \(\int|A|\,d\nu<\infty\). Dominated convergence therefore
applies to
\(\int(1-q(k/h))A(k,s)\,d\nu\).
The finite error term also has a limit by dominated convergence.
Consequently the full, non-subsequential scalar limit exists:
\[
                           L=\lim_{h\downarrow0}J(h).   \tag{12}
\]

In the extension a finite line counterterm must be retained. Put
\[
 B_0=\int_{L_0}Q\,dC<\infty,\qquad
 J^\circ(h)=\int_{k\ne0}Q\chi[q(|p|/h)-q(k/h)]\,dC .
\]
On \(L_0\), \(\chi=1\) and \(q(k/h)=1\). Dominated convergence
against its finite measure gives \(J(h)-J^\circ(h)\to-B_0\);
thus \(\lim J^\circ(h)=L+B_0\). For exact mixtures \(B_0=0\).

Take any sequence for which \(C_h\) converges to (11). Removing
the finite line measure does not change this vague limit. In the
rescaled \(J^\circ\), the difference is \(q(|p|)-q(k)\), zero for
\(|p|\le1/2\). On a dyadic annulus \(R<|p|\le2R\), \(R>10\),
its support is in \(|k|\le1\). Apply (7) at \(b=hR\), width
\(h\), with the central line deleted, and sum the disjoint annuli.
The geometric part sums to
at most \(12B/R\). The summed error is bounded by the mass of
one shrinking corridor excluding its central line and tends to zero
as \(h\downarrow0\).
Thus
\[
 \limsup_{h\downarrow0}\left|\text{rescaled tail beyond }R\right|
                         \le12B/R.                     \tag{13}
\]
There is no uncontrolled exchange of an infinite-frequency tail
with vague convergence.

Vague convergence on compact annuli followed by (13) gives
\[
 L+B_0=c\int_0^{2\pi}\cos(4u)
       \int_0^\infty[q(r)-q(r|\cos u|)]\,\frac{dr}{r}\,du.
\]
For \(0<t\le1\), changing variables with finite radial endpoints
and then taking their limits gives
\[
 \int_0^\infty[q(r)-q(tr)]\,dr/r=\log t.
\]
The absolute radial integral is at most \(\log(2/t)\), since the
bracket is bounded by one and supported in \([1/2,1/t]\).
This bound is integrable for \(t=|\cos u|\); its zero values occur
at only two angles and cause no Fubini problem. No monotonicity
of \(q\) is needed.

Integration by parts, with the vanishing endpoint term
\(\sin(4u)\log(\cos u)\), gives
\[
 \begin{split}
 \int_0^{2\pi}\cos(4u)\log|\cos u|\,du
 &=4\int_0^{\pi/2}\sin^2u\cos(2u)\,du\\
 &=-\pi/2.
 \end{split}
\]
Therefore \(L+B_0=-\pi c/2\). Because (12) was obtained before
selecting any spectral subsequence, every subsequence has the
same coefficient. Vague compactness now proves full convergence
in (T), completing the theorem.

## 8. Comparison with the two-arc angular series

For the exact-mixture case, set
\(w_j(k)=q(2^jk)-q(2^{j+1}k)\) and
\(I_j=\int q(4|p|)\chi(p)w_j(k)\,dC\), exactly as in
`prop:angular-sum`. The supports have bounded overlap and
\(\sum_j|w_j(k)|\le3\). The absolute sums of the comparison
errors are finite because they are bounded by finite outer and
alias mass, by \(\int |k|\,d\nu\), and by \(\int D\,d\nu\).
This proves \(\sum_j|I_j|<\infty\), not just convergence of the
signed partial sums.

Telescoping gives the same cutoff difference as \(J(2^{-N})\),
with \(Q=q(4|p|)\). The full-limit argument of Section 7 also
handles arbitrary \(h\downarrow0\); it does not interpolate
dyadic subsequences without an estimate. Consequently
\(\sum_j I_j=L=-\pi c/2\), independently of \(q\). Finite
errors have summable contributions by the same bounded-overlap
argument. For arbitrary errors the corresponding formula is
\(\sum_j I_j+B_0=-\pi c/2\); the exact case has \(B_0=0\).

## 9. The extension is a genuine weakening, even when \(c>0\)

Consider the explicit triangular Gaussian spectrum
\[
 C_G(dp)=\frac{dp}{D_G(p)},\qquad
 D_G(k,l)=6-2\cos k-4\cos(k/2)\cos(\sqrt3 l/2).
\]
It is a positive locally finite punctured-torus measure, since
\(D_G\) is the sum of the three squared nearest-neighbor
difference moduli. It has all the lattice symmetries and
\[
 D_G(\delta p)/\delta^2\longrightarrow(3/2)|p|^2.
\]
In particular it has the annular bound and coefficient \(c=2/3\).
This conclusion follows directly from Taylor's formula as well.

Its two-sheet projection is an exact positive Cauchy mixture.
Indeed, write \(A=6-2\cos k\), \(B=4\cos(k/2)\) and
\(z=\cos(\sqrt3 l)\). For \(k\ne0,\pi\), \(A>|B|>0\) and
\[
 C'_G(k,l)=\frac{2A}{A^2-B^2(1+z)/2}
           =\frac{4A/B^2}{(2A^2/B^2-1)-z}.
\]
Let \(\cosh(\sqrt3s(k))=2A^2/B^2-1>1\).
The elementary periodized-Cauchy Fourier series is
\[
 q_s(l)=P^{-1}
       \frac{\sinh(\sqrt3s)}{\cosh(\sqrt3s)-\cos(\sqrt3l)}.
\]
 Indeed, its Fourier coefficients are \(e^{-\sqrt3s|j|}\), obtained
 by the elementary Cauchy Fourier integral; summing
 \(1+2\sum_{j\ge1}t^j\cos(j\sqrt3l)\), \(t=e^{-\sqrt3s}<1\),
 gives the displayed formula by the convergent geometric series.
Thus the mixing weight is
\(4PA/[B^2\sinh(\sqrt3s(k))]>0\) times \(dk\).
The \(B=0\) endpoint is uniform, and the excluded \(k=0\)
is not an additional hypothesis. The same argument applies
in each rotated chart.

Now add the finite invariant density
\[
 F(dp)=\mathbf1_{\{1/4<|p|<1/3\}}\,dp
\]
in the small physical disk, and set \(C=C_G+F\).
This is covered by (H2) with the same positive mixture as \(C_G\)
and error \(E=\pi_*F\), which is finite and line-diffuse.
All symmetries and the small-annulus bound are retained.

It does **not** have an exact positive mixture even in the
horizontal chart. Every finite positive \(Q_s\) density is
nonincreasing on \(0<l<P/2\): this follows from the displayed
formula; \(Q_\infty\) is constant and \(Q_0\) contributes only
at zero. For almost every \(0<k<1/8\), the added density has
an upward jump at \(l=\sqrt{1/16-k^2}>0\), while \(C'_G\) is
continuous there. Such a density has no nonincreasing version.
An exact positive mixture cannot reproduce it. Formally, its
tangential marginal is absolutely continuous, so disintegration
of a proposed positive mixture gives the prohibited
nonincreasing conditional density for almost every such \(k\).

Nevertheless (T) applies and its coefficient is still \(2/3\);
the finite perturbation vanishes in a shrinking disk. This
demonstrates strict enlargement of the admissible infinite-mass
class, not a counterexample to the manuscript or to an integer
height model.

**Why the line counterterm cannot be dropped.** Add instead the
six equal atoms at \(p_j=R_{\pi/3}^j(0,1/8)\), and choose \(Q=1\)
on their radius. Their \(\chi\)-values are
\(1,-1/2,-1/2,1,-1/2,-1/2\), with sum zero. Once \(h\) is
sufficiently small, their contribution to \(J(h)\) is exactly
\(-2\): only the two atoms on \(k=0\) survive the horizontal
cutoff difference. Their contribution to \(B_0\) is \(2\).
Their scaling limit is zero. Thus using the manuscript's
**uncorrected** formula for this broader hypothesis class would
give the wrong coefficient, by \(4/\pi\). The corrected formula
gives zero for these atoms, and \(2/3\) for \(C_G\) plus the atoms.
This is an exact counterexample to the naive extension without a
line correction, not to the manuscript: those atoms violate its
exact positive-mixture hypothesis.

## 10. Exact obstruction to the classification-only route

For \(0<r<e^{-1}\), the radial density
\[
 [2+\sin(\log\log(1/r))]\,r^{-2}\,dp
\]
is positive and has a uniform annular mass bound. For fixed
\(t\), put \(\delta_n(t)=\exp[-\exp(2\pi n+t)]\). On every
compact punctured annulus its rescaling converges to
\((2+\sin t)|p|^{-2}dp\), because the phase difference is
\(\log(1+\log(1/|p|)\exp[-2\pi n-t])\), uniformly tending
to zero. Every sequence has further subsequences of this
form of tangent, but \(t=\pi/2\) and \(t=-\pi/2\) give
different coefficients 3 and 1.

This construction does not assert or satisfy the three positive
mixture hypotheses. It is not a refutation of `plane:lem:unique`.
It proves exactly why annular control plus classification is
insufficient, and why the summable-defect scalar argument cannot
be omitted.

## 11. Reproducibility, boundaries, and review

Run from the campaign root:

```text
$WORKSPACE/argus-live-update/.venv/bin/python research/spectral_rigidity/verify.py
```

The verifier checks symbolic identities for all positive parameters,
not a finite numerical sweep. It checks the coincident Cauchy poles,
the exact fourth-harmonic factorization and rotation cancellation,
the cap/dispersion rational certificates, the Gaussian projection
algebra, the Hessian, and the scalar angular coefficient. It also
checks the exact staged source labels and saved typed Jacobian
request/result. The Jacobian operation is
`polynomial.multivariate.factor.compute`, server 0.14.0, protocol
2025-11-25; its input/output and adapter status are separate JSON
files. That operation checks only the harmonic numerator, not an
infinite-scale measure theorem.

The independent Reviewer must assess the analytic proof, the
statement-to-source fidelity, and the significance/novelty of the
finite-error extension and its necessary line correction. No
external citation is an unproved
dependency of (T): the positive-mixture property is a hypothesis,
and the elementary integral, distribution, compactness, and limit
arguments used above are supplied explicitly. Strict positivity of
the height-model normalization, Gaussian higher moments,
bounded-domain pin transfer, and the real interface theorem remain
open in the graph. Completion of this Engineer milestone is not
acceptance or completion of the full campaign.
