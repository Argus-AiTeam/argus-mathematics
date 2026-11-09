# Pure initials, weighted slice growth and moments

**Engineer assessment: supported, conditional on the exposed standard
geometric and compact-set Brunn-Minkowski inputs.** The geometric construction
is prose mathematics; only its finite power-growth and telescoping algebra is
formalized. The finite fixtures are regressions, not the proof.

## Claim, hypotheses, version and attribution

For one nonzero admitted monomial test on a smooth projective birational model,
let its closed integral center have dimension \(d>0\). Fix one reference
degree \(m>0\), a smooth point of the center, one pulled-back frame, and one
additive Taylor order for all auxiliary degrees. The positive-support
coordinates have positive weights; fiber coordinates have old weight zero.
The assertions are
\[
 \#\Gamma_j=N_j,\quad
 \Gamma_j+\Gamma_h\subset\Gamma_{j+h},\quad
 \#G_0(h)\geq I_W(h),\quad
 \{0,1\}^d\subset G_0(kd),
\]
and, for old nonempty transverse slices and sufficiently large \(h\),
\[
 b_p(j+h)\geq b_p(j)+h-C'_d,\qquad
 B_{j+h}\geq B_j+(d+1)(h-C'_d)Q_j,
\]
where \(b_p(j)=(d!\#G_p(j))^{1/d}\),
\(Q_j=\sum_p e^{-\ell(p)/m}\#G_p(j)\),
\(B_j=(d!)^{-1}\sum_p e^{-\ell(p)/m}b_p(j)^{d+1}\).
The exact slice-moment comparison is
\[
 U_j+\frac d2Q_j\geq\frac d{d+1}B_j,\qquad
 U_j=\sum_{(p,\beta)\in\Gamma_j}e^{-\ell(p)/m}|\beta|.
\]
The constants are independent of the center, its degree, the model and the
auxiliary degree; the test and weights are fixed only within each reference
degree. These assertions do not require that the test minimize the objective.

`SG9000038` versions 1 and 2 have the same statement; version 2 records
`BM-compact`. The Argus proof is old `report.md`, lines 195-332, equations
(6)-(14). It reproduces OpenAI's `centers.tex`, the tangent and growth
subsections, especially `eq:center-semigroup`, `eq:center-pure-growth`,
`eq:center-cube`, `eq:discrete-bm`, `eq:center-b-growth`, and
`eq:center-moment`, at the manifest-bound September 23, 2026 revision.

## Decisive argument

At a very general smooth point \(y\in W\), choose a point of the open
positive-support stratum smooth over \(W\), away from other relative canonical
components. The fixed embedding supplies \(d\) tangent parameters pulled
back from \(W\); generic smoothness supplies fiber parameters. The local
order can be computed there without changing the old test, as explained in
the manuscript's `preliminaries.tex`, `lem:monomial-local`.

Finite-dimensional elimination of successive leading coefficients proves
the one-dimensional-leaf count directly. There is no reliance on the
Kaveh-Khovanskii comparison citation or semigroup finite generation.
The weighted/degree/tie-break order is additive and well-founded even with
zero-weight fiber variables: positive-coordinate exponents below a bounded
old weight form a finite set, and the remaining ties have a well-order.

After setting the positive coordinates to zero, a pulled-back section
restricts to a series in the tangent coordinates alone. A section in the
restriction kernel has strictly positive old weight. Thus elimination in
the actual restriction image lifts to distinct pure initials. It does not
extend arbitrary sections from a possibly singular center. Sections
\(\prod s_i^{\beta_i}s_0^{d-|\beta|}\) in degree \(kd\), with \(s_i(y)=0\)
and \(s_0(y)\ne0\), give the bounded cube exactly.

For nonempty finite lattice sets \(A,C\), their closed unit-cube thickenings
have volumes \(\#A,\#C\), and their Minkowski sum is
\(A+C+\{0,1\}^d+[0,1]^d\). Applying compact-set Brunn-Minkowski gives the
correct lower, not upper, cardinality inequality. Multiplicativity, the cube,
and the uniform restriction bound then give slice growth with
\(C'_d=C_d+kd\). Requiring \(h\geq C'_d\) ensures a nonnegative increment.
Multiplying convex power increments by the fixed positive weights and summing
old slices gives weighted growth; newly appearing slices contribute
nonnegatively.

For \(A\subset\mathbb N^d\), its cube thickening has the same volume as the
simplex \(\{\sum u_i\leq b\}\), where \(b=(d!\#A)^{1/d}\). The integral of
\((1_E-1_S)(\sum u_i-b)\) is nonnegative pointwise. The simplex integral is
\(db^{d+1}/((d+1)d!)\); the cube integral is
\(\sum_{\beta\in A}|\beta|+(d/2)\#A\). This proves the displayed moment
comparison slice by slice, including empty slices. The old draft retains
the exact \(d/2\) error where the manuscript enlarged it to \(d\).

## Evidence, execution and citation boundary

The retained Gardner PDF was actually read with `pdftotext`; the passage is
[`gardner_primary_excerpt.txt`](gardner_primary_excerpt.txt), with its reading
receipt. Theorem 4.1, printed page 362, requires nonempty bounded measurable
sets and measurability of their weighted sum. Finite unions of closed cubes
and their sums are compact, so the hypotheses hold without convexity.
The canonical citation is DOI `10.1090/S0273-0979-02-00941-2`, Theorem 4.1 and
homogeneous form (11). This reading is by the current Engineer, not an
independent citation attribution.

The unchanged old checker was freshly executed with no writing flags. Its
exact replay passed: 773 simplex-moment cases (7, 511, 255 in dimensions
1, 2, 3), 282 discrete cube-sum cases (49, 225, 4, 4 in dimensions 1-4),
and 39 weighted-growth cases. The higher-dimensional cube-sum cases are only
singleton/full-cube pairs, not all subsets. These counts are the original
bounded fixtures; none was enlarged.

`power_growth`, `weighted_growth`, `growth_telescope` and `moment_telescope`
check scalar algebra under their hypotheses. In particular
`moment_telescope` *assumes* its endpoint moment comparison. It does not
formalize Brunn-Minkowski, the cube construction, the simplex integration,
or the geometric interpretation of \(B,Q,U\).

## Remaining obligations and exclusions

No gap was found in this implication at its stated scope. The native Reviewer
must check the local image-to-pure-initial bridge and independently attribute
Gardner. The active canonical citation remains `unchecked`; a historical
`reviewer:copilot` judgement and an Engineer PDF reading are not substituted
for that independent attribution. This unit proves neither the upstream
specialization theorem nor Fujita's conjecture. Its exact \(d/2\) refinement
is not advertised as a novel theorem.
