# Uniform finite-range attraction comparison

## Result and its scope

**The quantitative assertion of algebraic-decay Theorem `k:range` is valid.**
The proof below works for every reference allowed there, including countably
many preceding ranges, reference coexistence parameters, and arbitrarily
small positive added mass. It also proves the stronger estimate

\[
 \sup_{\lambda\in\mathcal D}
 |Q_{\varphi_0-ta w_R}(\lambda)-T_aQ_{\varphi_0}(\lambda)|
 \le C_{\mathcal D,t}\min\{a,\sqrt{aR_0/R}\}.
 \tag{1}
\]

Both statements are mathematical proof conclusions of this report, pending
independent Reviewer assessment. The executable certificate checks the stated
algebra, exact finite examples, source correspondence, and the real Lean
compiler record. It does **not** mechanically prove the continuum integration
or thermodynamic-limit arguments. No false literal manuscript assertion has
been established, and no `F_...` refutation claim is being invented.

Relative to the manuscript's strongest stated range bound, (1) additionally
vanishes as \(a\to0\) at fixed range ratio and is \(O(a)\) throughout
\(a\le R_0/R\). This is the mathematical improvement, not a novelty verdict.

The original uniform square-root estimate and its proof are already in the
staged manuscript. Their reconstruction here is independent verification,
not a claim of a newly discovered result. Estimate (1) is a strengthening
proved here; priority and publishable novelty have not been independently
established. Neither a finite search nor this bounded bottleneck audit closes
the entire publishable/exploratory campaign.

### Exact source and quantifiers

Write `ALG` for
`research/openai_manuscript/A-radial-continuum-phase-transition-with-algebraic-decay-September-24-2026/build`.
The target is `ALG/sections/range.tex:12-33`, Theorem `k:range`.
Fix the manuscript's kernel, an admissible finite construction parameter
\(t\), and a compact \(\mathcal D\subset(0,\infty)\times\mathbb R\).
Put \(\bar A=A+1\), where \(A=3/(2p)\). For every

\[
 R_0\ge2,\quad
 \varphi_0=\psi_t-t\sum_j\alpha_jw_{R_j},\quad
 1\le R_j\le R_0,\quad \alpha_j\ge0,\quad
 a>0,\quad\sum_j\alpha_j+a\le\bar A,
 \tag{2}
\]

the theorem asserts an error at most \(C_{\mathcal D,t}\sqrt{R_0/R}\)
when \(R/R_0\ge K_{\mathcal D,t}\). The reference index set may be empty,
finite, or countable. Neither constant may depend on \(R_0\), those indices,
their ranges or masses, or \(a\). Dependence on the one fixed kernel is
implicit in the manuscript's notation and in ours. Empty \(\mathcal D\)
is vacuous; below assume it is nonempty.

The normalization is important:
\[
 Z_{L,n}^{\varphi}(\beta)=\frac1{n!}\int_{[0,L]^{3n}}
             e^{-\beta U^\varphi}\,dX,\qquad
 \Xi_L^\varphi(\beta,h)=\sum_{n\ge0}e^{thn}Z_{L,n}^\varphi(\beta),
 \qquad Q_\varphi=\lim_{L\to\infty}\frac{\log\Xi_L^\varphi}{tL^3}.
 \tag{3}
\]
Thus insertion of \(-ta w_R\) gives exponent \(+\beta ta W_R\),
and the correct reference field shift is \(h+\beta au\), not \(h+au\).

### Inputs and knownness boundary

The only model-specific upstream ingredients are the small-cell quadratic
core bound and the thermodynamic functions of this same family. Section 2
derives the required estimates; the appendix explains the limit construction
without using a Kac theorem. In particular, we do not assume the conclusion
of `k:range`, a rate of convergence of canonical free energies, a quantitative
selection of a coexisting phase, or a limiting density for a deleted system.

Lebowitz--Penrose (1966), DOI `10.1063/1.1704821`, and Gerardi et al. (1973),
DOI `10.1007/BF01645248`, are cited in the staged introduction to locate the
classical qualitative Kac theory. Neither paper is an assumption of this
proof, and their citations are not represented as checked propositions.
The appendix instead supplies the physical pressure limits needed here.
The exact scientific inputs read from the staged sources are:

| Input | Staged locator | Use |
|---|---|---|
| Core, row bound, admissible \(t\), canonical bounds | `foundations.tex`, `f:core`, `f:row-bound`, `f:t-requirements`, `f:canonical-bounds` | Coercivity and the cell estimates below |
| Grand count tail | `foundations.tex:270`, `f:grand-tail` | Re-derived before enlarging the parameter compact |
| Physical limits and density duality | `foundations.tex:307`, `f:thermodynamics` | Explained independently in the appendix; no deleted-system limit assumed |
| Occupation and absolute interpolation | `local_bounds.tex:30,149`, `f:moments`, `f:perturbation` | Re-derived for precisely the interpolations used |
| Active shifts and \(O(a)\) transform increment | `transform.tex:24`, `k:transform-properties` | Re-derived by density square completion |
| Deletion and kernel rows | `range.tex:49,75,139` | Detailed estimates below |
| Product lower bound and square | `range.tex:319,361,370` | Arbitrary finite-box mean, with the favorable square retained |

These are local proved inputs, not hidden external literature assumptions.
The ledger and graph separately expose the main theorem dependencies of
both manuscripts. Untested main-theorem nodes are not certified by the
present report.

## 2. Uniform prerequisites, with no range estimate as input

Use the fixed microscopic cell side \(b=1/4\). The manuscript's shell graph
has clique number at most four: five almost-equidistant points would give
a rank-four positive definite Gram matrix of four vectors in \(\mathbb R^3\).
The reference \(4\times4\) Gram matrix has least eigenvalue \(1/2\), and
the perturbation norm is at most \(4(2\Delta+\Delta^2)<1/2\).
The weighted clique maximization argument then bounds shell edges on \(m\)
vertices by \(3m^2/8\). In a small cell all distances are less than one,
so at least \(m^2/8-m/2\) pairs pay the full core height \(t^2\).
Consequently, with
\[
 D_0=t^2/8,\quad B_0=t^2/2,\quad
 M=c_b t\bar A,\quad c_b=\|w\|_\infty(2/b+5)^3,
\]
every permitted interpolation has
\[
 U\ge(D_0-M/2)\sum_i n_i^2-B_0N.                 \tag{4}
\]
Indeed its intra-small-cell core is retained, and a symmetric nonnegative
attraction matrix \(J\) with row sums at most \(M\) contributes at most
\(M\sum_i n_i^2/2\). The admissibility conditions include
\(D_0\ge8M\) and \(ct>4\bar A\), with \(c=1/3456\).
For cubes of side at least one, there are at most \(216L^3\) cells.
Equation (4) therefore also gives
\[
 U\ge ct^2 N^2/L^3-B_0N.                         \tag{5}
\]

All attraction rows obey the same bound: a cell sees at most
\((2R/b+5)^3\) cells through a kernel bounded by \(R^{-3}\|w\|_\infty\),
and \(R\ge1\). Summing masses yields \(M\), not a bound proportional
to the number of kernels. A countable attraction converges uniformly by
the summable mass bound. Supremum-of-sum bounded by sum-of-suprema gives
the same row estimate directly for that countable interaction.

### Uniform local moments, including inhomogeneous interpolations

Fix a compact parameter rectangle with
\(\beta_-\le\beta\le\beta_+\), \(|h|\le H\).
For any finite collection of possibly cropped small cells let
\[
 F_i=\mathbb E e^{\beta D_0n_i^2/4},\qquad F=\max_iF_i.
\]
These numbers are finite before any maximum is estimated: inserting the
exponential into the grand sum and using (4) leaves quadratic coefficient
\(3D_0/4-M/2\ge11D_0/16>0\) in cell \(i\), and positive quadratic
coefficients in all other cells. The resulting product of one-dimensional
grand series converges. The vacuum bounds the denominator below by one.

Condition on the entire outside configuration. With
\(G_i=\sum_{j\ne i}J_{ij}n_j\), the inside energy is at least
\[
 (D_0-J_{ii}/2)n_i^2-B_0n_i-n_iG_i.
\]
The empty-cell term in the conditional denominator is one. Using
\(n_iG_i\le D_0n_i^2/4+G_i^2/D_0\) in its numerator gives
\[
 \mathbb E[e^{\beta D_0 n_i^2/4}\mid\text{outside}]
 \le C_2 e^{\beta G_i^2/D_0},                   \tag{6}
\]
where
\[
 C_2=\sum_{n\ge0}\frac{b^{3n}}{n!}
  e^{-7\beta_-D_0n^2/16+(tH+\beta_+B_0)n}<\infty.
\]
The remaining inside quadratic coefficient is at least \(7D_0/16\).
Weighted Cauchy--Schwarz gives
\(G_i^2\le M\sum_{j\ne i}J_{ij}n_j^2\).
Put \(\theta_j=J_{ij}/M\), add the unused row weight at zero, and set
\(\nu=4M^2/D_0^2\le1/16\). Convexity of the exponential and then
concavity of \(x^\nu\) give
\[
 \mathbb E e^{\beta G_i^2/D_0}
 \le1-\sum_{j\ne i}\theta_j+
      \sum_{j\ne i}\theta_j F_j^\nu\le F^\nu.
\]
Taking expectations and maxima in (6) proves
\(F\le C_2F^\nu\), hence \(F\le C_2^{1/(1-\nu)}\).
Thus, uniformly over volumes, reference kernels, and permitted deletions,
\[
 \mathbb E[n_i n_j]\le C_{\rm occ}.             \tag{7}
\]
Only nonnegative core terms across cells were discarded. No translation
invariance or independence of the cells is required.

For two such interactions with common interpolation and absolute difference
majorant \(J^{\rm diff}_{ij}\), finite-volume differentiation gives
\[
 |\log\Xi_1-\log\Xi_0|
 \le\frac{\beta C_{\rm occ}}2\sum_{i,j}J^{\rm diff}_{ij}. \tag{8}
\]
To justify differentiation, in a fixed region of \(k\) cells (4) gives
\(U_\theta\ge(D_0-M/2)N^2/k-B_0N\), while a bounded pair difference
has derivative at most a fixed multiple of \(N^2\). The differentiated
grand series is dominated by a summable Gaussian-in-\(N\) series uniformly
in \(\theta\). This domination need not be volume independent; (7) makes
the resulting estimate (8) volume independent.

### Grand tail and active shifts are fixed before local constants

The canonical lower bound from (5) and \(n!\ge(n/e)^n\) gives
\[
 H_{L,n}\ge\beta t(cd^2-d/2)+(d\log d-d)/t,\qquad d=n/L^3.
 \tag{9}
\]
For auxiliary coefficient \(0\le\zeta\le2\bar A\), the logarithm of
the \(n\)-th grand summand with extra weight
\(e^{\beta t\zeta n^2/(2L^3)}\), for \(d\ge1\), is at most
\[
 -\kappa n^2/L^3+B_*n,\quad
 \kappa=\beta_-ct^2/2,\quad B_*=tH+\beta_+t^2/2+1.
\]
Choose \(D_{\rm cut}\ge\max(1,2B_*/\kappa)\).
The tail above \(D_{\rm cut}L^3\) is bounded by the geometric series
with exponent \(-(\kappa D_{\rm cut}/2)n\), and so is at most one
for \(L^3\ge V_0\), uniformly in every reference and \(\zeta\).
Neither local moments nor an enlarged shifted compact have been used.

Physical density duality and completion of the square give
\[
 Q_0(\beta,h+\beta au)-\beta au^2/2
 =\sup_{d\ge0}\left\{hd-H_0(\beta,d)+\beta ad^2/2
                       -\beta a(u-d)^2/2\right\}.       \tag{10}
\]
For \(0<a\le2\bar A\), (9) makes the density objective bounded above by
\[
 -\beta ct\,d^2/2+(|h|+\beta t/2)d+1/t.
 \tag{11}
\]
The objective at zero is zero. Its upper semicontinuity and the uniform
coercivity (11) give a maximizing density in one fixed interval \([0,U]\).
The equality of suprema in (10), and attainment of the shifted reference
density supremum, show that active shifts are exactly these maximizing
densities. In particular
\[
 0\le T_aQ_0-Q_0\le(\beta_+U^2/2)a.              \tag{12}
\]

Now, and only now, fix one compact rectangle \(\mathcal D'\) containing
all \((\beta,h+\beta av)\) for \((\beta,h)\in\mathcal D\),
\(0\le a\le\bar A\), and \(0\le v\le\max(U,D_{\rm cut})\).
Fix (7), (8), and the deletion constants on that rectangle.
Thus no local constant depends on a cutoff chosen using that same local
constant. This resolves the possible circular-constant issue.

## 3. Signed reference deletion

Let \(s\ge R_0\) with \(s/b\) a positive integer. Tile a cube of side
\(L=ms\) into \(m^3\) aligned boxes. Delete the reference interaction
between distinct boxes, leaving the new attraction intact.
During interpolation the intra-small-cell core remains full, and the
attraction is bounded by
\[
 S_0+ta w_R,\qquad S_0=t\sum_j\alpha_jw_{R_j}.
\]
It has row sums at most \(M\), so (7)--(8) apply.

On a deleted pair the absolute difference is at most
\((\psi_t+S_0)\), **not** a signed version of \(S_0\).
Its row sum over small cells is bounded by a fixed
\(C_b t^2+c_b t\bar A\). A nonzero difference row lies within
\(R_0+\sqrt3b\) of a large-box boundary. There are at most
\(C_b s^2R_0\) such cells per large box. If the strip fills the box,
the same estimate follows from \(s^3\le C s^2R_0\).
Thus (8), divided by \(tL^3\), proves
\[
 \left|\frac{\log\Xi_L^{\rm full}}{tL^3}
              -\frac{\log\Xi_L^{\rm del}}{tL^3}\right|
 \le B_{\rm del}R_0/s.                          \tag{13}
\]
This bound is uniform in \(m,s,R,a\), and all reference data.

For \(a=0\) the deleted grand sum is exactly
\((\Xi_s^0)^{m^3}\). With prescribed counts, \(N!/\prod_z n_z!\)
assignments of labels cancel the global \(1/N!\), leaving
\(\prod_z1/n_z!\); summation is legitimate by nonnegativity.
Taking \(m\to\infty\) in (13) therefore gives
\[
 |Q_0^s-Q_0|\le B_{\rm del}R_0/s
 \quad\hbox{on }\mathcal D'.                    \tag{14}
\]
This uses only the full reference pressure limit. We never postulate a
thermodynamic limit of a deleted system with the new attraction present.

Deleting positive reference pairs and deleting negative reference pairs
have opposite pressure orientations. Equation (13) handles both with an
absolute majorant; it does not rely on pressure monotonicity under signed
deletion.

## 4. Kernel rows

For boxes \(B_z\) on the \(s\)-grid define
\[
 K^+_{zz'}=\sup_{B_z\times B_{z'}}w_R(x-y),\qquad
 K^-_{zz'}=\inf_{B_z\times B_{z'}}w_R(x-y).
\]
Both are symmetric and nonnegative. Put \(G=\|\nabla w\|_\infty\).
For fixed \(y\in B_{z'}\), any displacement used in either extremum
is within \(3s\) of \(z-y\), so its kernel value differs from
\(w_R(z-y)\) by at most \(3GsR^{-4}\).
At most \(C(R/s)^3\) second boxes contribute when \(s\le R\).
Integration in \(y\) and summation, using \(\int w_R=1\), give
\[
 s^3\sum_{z'}K^+_{zz'}\le1+\eta,\qquad \eta=C_ws/R. \tag{15}
\]
For a center at distance greater than \(R+4s\) from the outside boundary,
the infinite-grid lower estimate is unchanged by restricting to the
finite collection. Dropping \(z'=z\) costs at most
\(\|w\|_\infty(s/R)^3\), which is at most \(\|w\|_\infty s/R\).
Increasing the same \(C_w\) yields
\[
 s^3\sum_{z'\ne z}K^-_{zz'}\ge1-\eta.            \tag{16}
\]
Zeros inside the support, the support boundary, and lack of radial
monotonicity cause no exception: the Lipschitz estimate is global.

## 5. Upper pressure bound

Require \(s\ge R_0\), \(s/b\in\mathbb N\), \(s^3\ge V_0\),
\(s\le R\), and \(\eta=C_ws/R\le1\).
For box counts \(N_z\), symmetry and \(2N_zN_{z'}\le N_z^2+N_{z'}^2\)
give
\[
 W_R\le\tfrac12\sum_{zz'}K^+_{zz'}N_zN_{z'}
       \le\frac{1+\eta}{2s^3}\sum_zN_z^2.
 \tag{17}
\]
The first inequality adds nonnegative diagonal self terms.
Splitting labels and using (17),
\[
 \Xi_L^{\rm del}\le\left[\sum_{n\ge0}B_n\right]^{m^3},\quad
 B_n=e^{thn}Z_{s,n}^0
      e^{\beta ta(1+\eta)n^2/(2s^3)}.            \tag{18}
\]
Here \(a(1+\eta)\le2\bar A\), so the entire tail above
\(D_{\rm cut}s^3\) is at most one.

For a remaining count put \(d=n/s^3\). Its canonical summand at the
shifted field is one term of the nonnegative reference grand sum, hence
\[
 \frac{\log B_n}{ts^3}
 \le Q_0^s(\beta,h+\beta ad)-\beta ad^2/2+\beta a\eta d^2/2
 \le T_aQ_0+B_{\rm del}R_0/s+\beta_+a\eta D_{\rm cut}^2/2.
 \tag{19}
\]
All shifted fields lie in \(\mathcal D'\), so (14) applies.
The last upper bound is nonnegative, including at the vacuum count.
There are \(\lfloor D_{\rm cut}s^3\rfloor+1\) retained counts.
Taking the logarithm of (18), adding (13), and using the full physical
pressure limit gives
\[
 Q_{\rm full}-T_aQ_0
 \le2B_{\rm del}R_0/s+\beta_+a\eta D_{\rm cut}^2/2+
 E_s,\qquad
 E_s=\frac{\log(\lfloor D_{\rm cut}s^3\rfloor+2)}{ts^3}.
 \tag{20}
\]
No individual count was assumed typical, and no estimate was divided by
the positive mass.

## 6. Product-ensemble lower bound at coexistence

Choose any active shift \(u\in[0,U]\). Give each whole box its reference
grand ensemble at \((\beta,h+\beta au)\), independently between boxes.
Call the product measure \(\Pi\), and put \(d_s=s^{-3}\mathbb E_\Pi N_z\).
Equation (7) gives
\[
 0\le d_s\le D_{\rm box}:=b^{-3}\sqrt{C_{\rm occ}}. \tag{21}
\]
There is no assertion that \(d_s=u\), or even that \(d_s\) has a limit.

Changing the field and inserting the attraction is the exact identity
\[
 \Xi_L^{\rm del}(\beta,h)=
    [\Xi_s^0(\beta,h+\beta au)]^{m^3}
       \mathbb E_\Pi e^{\beta ta(W_R-uN)}.        \tag{22}
\]
The factorial cancellation is the same one used in (18).
The exponential moment is finite by (4); its exponent has finite
expectation by (7). Jensen's inequality is therefore applicable.
It gives
\[
 \frac{\log\Xi_L^{\rm del}}{tL^3}
 \ge Q_0^s(\beta,h+\beta au)-\beta au d_s+
                       \frac{\beta a}{L^3}\mathbb E_\Pi W_R.
 \tag{23}
\]

Drop only nonnegative **new** attraction terms from within single boxes.
For distinct boxes their whole configurations are independent, even when
particles within a box are highly correlated. Thus
\[
 \mathbb E_\Pi W_R\ge
     \tfrac12s^6d_s^2\sum_{z\ne z'}K^-_{zz'}.
\]
If \(m_{\rm int}\) boxes have centers satisfying the boundary condition,
(16) gives
\[
 \mathbb E_\Pi W_R/L^3\ge
   (m_{\rm int}/m^3)(1-\eta)d_s^2/2.
 \tag{24}
\]
For fixed \(s,R\), \(m_{\rm int}/m^3\to1\).
Take only \(m\to\infty\) in (13), (23), and (24). Then
\[
 Q_{\rm full}\ge Q_0^s(\beta,h+\beta au)+
    \beta a[-u d_s+(1-\eta)d_s^2/2]-B_{\rm del}R_0/s.
\]
The decisive identity, with its sign, is
\[
 -u d_s+(1-\eta)d_s^2/2
 =-u^2/2+(d_s-u)^2/2-\eta d_s^2/2
 \ge-u^2/2-\eta D_{\rm box}^2/2.                \tag{25}
\]
Use (14) and the active-value identity to conclude
\[
 Q_{\rm full}-T_aQ_0\ge
      -2B_{\rm del}R_0/s-\beta_+a\eta D_{\rm box}^2/2.
 \tag{26}
\]
The square discarded in (25) is nonnegative. An attempt to obtain a
quantitative rate by identifying a free-box mean with a chosen phase
would introduce an unnecessary unproved input. The ledger records that
route as retired for this reason, not as a false manuscript assertion.
Reference nonsmoothness in either parameter does not alter (22)--(26).

## 7. Uniform error and mass-sensitive strengthening

For \(s\ge1\),
\[
 E_s\le\frac{\log(D_{\rm cut}+2)+3\log s}{ts^3}
       \le\frac{\log(D_{\rm cut}+2)+3}{ts},
\]
using \(\log s\le s\). Since \(R_0\ge2\), this can be absorbed into
a fixed multiple of \(R_0/s\).
Equations (20) and (26) therefore prove the following unoptimized
all-parameter estimate for every admissible intermediate side:
\[
 |Q_{\rm full}-T_aQ_0|
       \le B_1R_0/s+B_2a\,s/R,                 \tag{27}
\]
where \(B_1,B_2\) depend only on \(\mathcal D,t,w\).
This is the analytic comparison proved above, not an assumption inferred
from an experiment or a square identity alone.

Put \(q=R/R_0\) and \(s=b\lfloor R_0\sqrt q/b\rfloor\).
A fixed lower bound on \(q\) ensures
\[
 R_0\le s\le R,\quad
 R_0\sqrt q/2\le s\le R_0\sqrt q,\quad
 s^3\ge V_0,\quad C_ws/R\le1.
 \tag{28}
\]
For example \(q\ge\max(4,C_w^2,V_0^{2/3})\) suffices here.
Consequently \(R_0/s\le2/\sqrt q\), \(s/R\le1/\sqrt q\),
and (27), with \(a\le\bar A\), proves precisely `k:range`.
The rounding and all thresholds are uniform in \(R_0\ge2\).

For completeness, (8) applied to insertion of just the new attraction
gives \(0\le Q_{\rm full}-Q_0\le C_{\rm phys}a\).
Together with (12) this yields
\[
 |Q_{\rm full}-T_aQ_0|\le B_3a.                 \tag{29}
\]
Let \(\epsilon=R_0/R\), \(L_*=\max(1,C_w^2)\).
If \(a\ge L_*\epsilon\), choose instead
\[
 s=b\left\lfloor \sqrt{R_0R/a}/b\right\rfloor .
\]
For \(q\ge\max(4\bar A,\bar A V_0^{2/3})\) this side is at least
\(R_0\), has volume at least \(V_0\), and is at least half the unrounded
side. Since \(a\ge L_*\epsilon\), it also has \(s\le R\) and
\(C_ws/R\le1\). Now
\[
 R_0/s\le2\sqrt{a\epsilon},\qquad
 a\,s/R\le\sqrt{a\epsilon}.
\]
Equation (27) gives the large-mass regime of (1). For
\(a<L_*\epsilon\) use (29): if \(a\le\epsilon\) the minimum in (1)
is \(a\); otherwise \(a\le\sqrt{L_*}\sqrt{a\epsilon}\).
Enlarging the one constant proves (1) uniformly over all positive masses.
At \(a=0\), define \(T_0Q_0=Q_0\); both sides are exactly zero.
This extension uses no claim that the degenerate shift representation
has a compact active set at zero mass.

## 8. Evidence, falsification attempts, and unresolved scope

`Main.lean` has seven declarations, compiled by Lean 4.31.0 through
`lean_evidence` with `--claim C_RANGE_CORE`, compiler exit code zero,
no proof holes, and no ledger-recording refusals. `statement_fidelity.md`
states the quantifiers and analytic premises of each declaration.
In particular, the formal core includes symmetric-kernel domination,
the retained-count-plus-tail bound, the constant-density pair estimate,
arbitrary-density lower transfer, and two-sided scale balancing, not
just square completion. `small_mass_crossover` formalizes the regime
combination used in (1). Continuum probability, integration, and physical
limits remain prose mathematics.

`verify.py` checks `exact_certificate.json`, replays polynomial identities
over exact rationals, checks the factorial cancellation, stresses arbitrarily
unequal density/shift values, examines a piecewise-linear coexistence model
at very small positive masses, and checks representative rounded scale
conditions. Those finite tests are explicitly not substitutes for (27).
It also verifies the source/fidelity binding of the successful Lean record.

The bounded Jacobian operation was `matrix.inertia.compute`, through the
required Argus adapter, server 0.14.0, protocol 2025-11-25.
Its exact payload and typed output are preserved as
`jacobian_payload.json` and `jacobian_result.json`, with adapter exit zero.
The matrix is the weighted path Laplacian arising from the unnormalized
sample kernel \((1-r^2)_+^2\) at points \(0,1/2,1\); its exact eigenvalues
are \(0,9/16,27/16\). This independently checks one finite quadratic-form
instance, not a continuum row-sum theorem. A first payload redundantly
supplied both triangular halves; the adapter rejected it at validation.
That exact rejected payload, structured error, and exit status 2 are
preserved under `jacobian_rejected_*`. The rejection is a non-conclusion,
not mathematical evidence. The accepted payload uses one triangular half.

The dependency map for the divergent-core companion has a separate
qualitative Kac node `D_KAC`. Its construction fixes each mass before
choosing a sufficiently large range for a fixed finite reference. It does
not require `C_RANGE` or its uniform rate. Therefore even a hypothetical
failure of the latter would not, by itself, refute the companion.

No independent Reviewer verdict, novelty verdict, or publication-level
significance verdict is asserted here. The Host must invoke that Reviewer.
The initial-triple, persistence, full multiscale construction, and main
canonical-singularity claims of both manuscripts remain separately open
in the graph; this report settles the stated quantitative bottleneck only.

## Appendix: physical thermodynamics without a circular Kac input

Here are the upstream limits used in Sections 2--6, including why no
quantitative finite-volume rate is being smuggled into them.
For every member of (2) and the full physical family, the core is zero
beyond distance two and the remaining interaction there is nonpositive.
Equations (5) and Jensen applied to independent uniform positions give
\[
 \beta t(cd^2-d/2)+(d\log d-d)/t
 \le H_{L,n}(\beta)
 \le\beta Ctd^2+d\log d/t.                      \tag{30}
\]
The upper estimate uses
\(\mathbb E U^\varphi\le Ct^2n^2/L^3\) and \(n!\le n^n\).
These bounds hold for countable sums directly. They give the zero-density
limit and bounded canonical costs on every fixed density interval.

Fix \(\beta>0,d>0\), and choose \(s_j\to\infty\) and integer \(n_j\)
with \(n_j/s_j^3\to d\) realizing the joint lower limit \(H_*\).
In a large cube of arbitrary side \(L\) put
\(k=\lfloor L/(s_j+2)\rfloor^3\) boxes of side \(s_j\), with gaps two.
For any counts \(m_i\) totaling the target \(n\), nonpositive inter-box
energy and exact label cancellation give
\[
 Z_{L,n}\ge\prod_{i=1}^k Z_{s_j,m_i}.           \tag{31}
\]
Start with \(n_j\) particles per box. Let
\(q_j=\lfloor(4d+4)s_j^3\rfloor\) and \(c_d=\min(d/2,1)>0\).
For sufficiently large \(j\), both \(n_j\) and \(q_j-n_j\) are
at least \(c_ds_j^3\).
If the target exceeds \(kn_j\), fill successive boxes up to \(q_j\);
if it is smaller, empty successive boxes. One final box handles the
integer remainder. For fixed large \(j\) and sufficiently large \(L\),
the target lies in \([0,kq_j]\). At most a fraction
\[
 r/k\le c_d^{-1}|n/(ks_j^3)-n_j/s_j^3|+1/k
\]
of boxes changes. Their costs in (30) are bounded uniformly in \(j\).
Taking logarithms of (31), then \(L\to\infty\) with \(j\) fixed, gives
an upper limit at most
\[
 (s_j/(s_j+2))^3
 \left[H_{s_j,n_j}
 +2Kc_d^{-1}|d(1+2/s_j)^3-n_j/s_j^3|\right].
\]
Letting \(j\to\infty\) yields \(H_*\). Every competing sequence has
lower limit at least \(H_*\) by its definition. This proves the
all-sequence canonical limit, not a rate.

Mixing two densities among separated boxes and using this already
established all-sequence limit proves density convexity. Finite convexity
gives continuity at positive density; (30) gives continuity at zero.
Hölder's inequality and the limit give concavity in \(\beta\).
The grand-tail estimate from (9) leaves only \(O(L^3)\) retained counts.
A maximizing retained count has a subsequential limiting density, and
the canonical all-sequence limit bounds the pressure upper limit by
\(\sup_d(hd-H(\beta,d))\). Each single count with density tending to
a prescribed \(d\) bounds the lower limit in the other direction.
The logarithm of the number of counts divided by \(L^3\) vanishes.
This proves (3) and its density duality. Conversely a supporting slope
of the finite convex function \(H(\beta,\cdot)\) at \(d>0\) yields
the reverse partial duality. Joint pressure convexity follows by Hölder
on the disjoint union of configuration spaces.

This argument works for each reference and full physical potential
before any deletion estimate is used. It invokes neither a Kac limit,
local moment bounds, convergence of reference densities, nor a
thermodynamic limit for the deleted interaction.
