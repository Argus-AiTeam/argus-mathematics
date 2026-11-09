# Toroidal volume theorem: mathematical assessment

**Assessment:** supported relative to the stated smooth direct-image inputs
and ordinary characteristic-zero geometry and measure theory. The decisive
geometric and analytic bridges are present; the arithmetic certificate alone
would not establish them. This is an Engineer assessment for native independent
review, not acceptance or a new theorem.

## Statement, version, and attribution

The source is the September 26, 2026 manuscript *Metric descent and
rank-preserving contractions*, revision
`4eaee87548250b2682affda7d05d947c05554bae`, file
`build/source/sections/toroidal-volume.tex`, Theorem `g:toroidal-volume`
and Lemma `g:volume-subklt`. The actual statements and proofs, including
the analytic continuation and projection-formula portions, were read.
The source in the old workspace agrees with the existing manuscript
manifest. The old report's sections 1-5 are a proposed independent
reproduction, not an original claim of anticanonical nonvanishing.

For **every** smooth connected projective complex \(X,Y\), with
\(n=\dim X\), \(d=\dim Y>0\), assume:

- \(L=-K_X\) has a smooth Hermitian metric \(h\) with curvature
  \(\alpha\geq0\).
- \(W\) is normal integral, \(p:W\to X\) is projective birational, and
  \(f:W\to Y\) is projective, surjective, equidimensional, and toroidal
  for strict toroidal embeddings.
- A smooth projective resolution \(\rho:Z\to W\) gives
  \(\pi=p\rho\), \(g=f\rho\), \(E_Z=K_{Z/X}\), and the **full**
  generic rank \(\operatorname{rk}g_*\mathcal O_Z(E_Z)=1\).

For every prime \(Q\subset Y\), take all prime \(E\subset W\) dominating
\(Q\), set \(a_E=\operatorname{ord}_E K_{W/X}\),
\(e_E=\operatorname{ord}_E f^*Q\), and define
\[
 \lambda_Q=\min_{E\to Q}(1+a_E)/e_E,\quad
 a_Q=\max(0,\lambda_Q-1),\quad A_0=\sum_Qa_QQ.
\]
The conclusion is finite effective rational \(A_0\), exceptional
\(f^*A_0\), and a semipositive singular metric on the rational line
\(-K_Y+A_0\), with **unweighted root-frame squared norms**
locally integrable at every point, smooth on a nonempty Zariski open.
The lemma additionally asserts sub-klt for
\(\Theta_0=-K_{W/X}+f^*A_0\), hence the strict exponent inequality
on **every prime on every smooth model over \(W\)**.

Strictness has an extra premise: on one nonempty ordinary open patch
in the smooth base-change locus, disjoint from \(E_Z\),
\(\pi^*\alpha\geq c\,g^*\omega_Y\) for \(c>0\).
The conclusion is positive definite curvature on a nonempty
**ordinary** base open. No global strict lower bound is claimed.
The lemma needs neither the metric nor the rank assumption.

## Decisive geometric checks

1. **Orders, clipping, and support.** Normality makes \(W\) smooth at
   the generic point of a prime. The morphism to smooth \(X\) has
   holomorphic Jacobian there, so \(a_E\geq0\); a nonexceptional prime
   has \(a_E=0\). Surjectivity supplies components of \(f^*Q\), and
   their multiplicities are positive integers. Equidimensionality
   prevents a vertical prime from mapping into codimension at least
   two: its dimension would be at most \(n-2\). Thus every relevant
   prime is counted. If \(a_Q>0\), every branch over \(Q\) has
   \(a_E>0\) and is exceptional. A fixed birational morphism has only
   finitely many exceptional divisors, proving finiteness of the
   correction. If \(a_Q>0\),
   \(-a_E+e_Ea_Q\leq1-e_E\leq0\); otherwise the coefficient is
   \(-a_E\leq0\). The clipping at zero is used, not omitted.

2. **Cartierness before discrepancies.**
   \(K_W+\Theta_0=p^*K_X+f^*A_0\) is rationally Cartier without
   assuming \(K_W\) rationally Cartier. The full reduced toroidal
   boundary \(D_W\) has \(K_W+D_W\) locally Cartier. Therefore
   \(B=D_W-\Theta_0\) is effective rational Cartier and its support
   contains all of \(D_W\). These properties, not just numerical
   coefficients on \(W\), permit valuation comparison.

3. **All divisorial valuations.** On a toric chart the logarithmic
   top form has divisor \(-D_W\). On a smooth model at a prime
   \(F=(t=0)\), write each character as \(t^{m_i}u_i\), with \(u_i\)
   a unit. Each logarithmic differential is
   \(m_i\,dt/t+d\log u_i\); two \(dt/t\) factors wedge to zero.
   The pulled-back top form has order at least \(-1\), establishing
   \(A_{W,D_W}(F)\geq0\), including nontoric valuations. The
   calculation is local under the toroidal charts; discrepancies
   and this assertion are unchanged under their etale local maps.
   Outside \(D_W\), smoothness gives strictly positive discrepancy.
   An effective rational Cartier divisor has nonnegative value at
   a centered valuation, and positive value when its center is in
   its support: a Cartier multiple has a regular local equation,
   which is a nonunit in the latter case. Consequently
   \[
    A_{W,\Theta_0}(v)=A_{W,D_W}(v)+v(B)>0.
   \]
   If the first term vanishes, the center is in \(D_W\), where the
   second is positive. This covers intersections and exceptional
   primes on higher models. Checking only the existing primes on
   \(W\) would not have sufficed.

For a smooth model \(\tau:Z'\to W\), the crepant boundary is
\((f\tau)^*A_0-K_{Z'/X}\). The preceding assertion therefore gives
\(\gamma_F=\operatorname{coeff}_F(K_{Z'/X}-(f\tau)^*A_0)>-1\).
The numerical sign lemmas in the shared formal unit are faithful
to this last implication, but do not construct its geometric inputs.

## Decisive analytic checks

**Entire-line identification.** The adjoint identity is
\[
 K_{Z/Y}+\pi^*L=E_Z+g^*(-K_Y).
\]
On a smaller smooth base-change open the nonzero generic Jacobian
section trivializes the rank-one sheaf \(g_*\mathcal O_Z(E_Z)\).
It thus identifies the entire adjoint direct image with \(-K_Y\).
The coefficient metric on \(\pi^*L\), the relative canonical form,
and this Jacobian section give exactly the density
\(g_*\pi^*\Omega_h=H(y)dV_y\) as its squared \(L^2\) frame norm.
The base canonical twist and the squared Jacobian are both retained.
No restriction-to-an-arbitrary-subline argument is used.

**Positivity and strictness.** The independently read passages are
Berndtsson, *Annals of Mathematics* 169 (2009), 531-560,
doi:10.4007/annals.2009.169.531, Theorem 1.2, Proposition 4.2,
and (4.8). See `source-reading.md` and `source-attribution.json`
for standing hypotheses, formulas, source locations, and limitations.
The application is to the smooth resolved total space \(Z\), not
normal \(W\); projectivity supplies Kahlerness. Smooth semipositivity
is preserved by pullback. The theorem applies on the smooth
base-change open and makes \(-\log H\) psh there.

For relative dimension \(r>0\), on a base disc and at a Chern-normal
point, the primitive-representative formula says
\[
 -i\partial\bar\partial\|u\|^2
 \geq g_*(i^{r^2}\widehat u\wedge\overline{\widehat u}
                   h_{\pi^*L}\wedge i\Theta_{\pi^*L}).
\]
The discarded primitive norm is nonnegative. An \((r,0)\)-form in
dimension \(r+1\) is decomposable, so wedging with semipositive
coefficient curvature has the asserted sign. On the stipulated patch,
the lower bound by \(c g^*\omega_Y\) gives a positive integral of
the nonzero relative density. At a fixed point in the image of that
patch the same patch meets the fiber in a relative open set; testing
every tangent direction gives a positive multiple of
\(\omega_Y(v,\bar v)\), not positivity at unrelated points for
different directions. Smoothness then gives an ordinary neighborhood.
Shrinking by algebraic bad loci cannot remove the whole ordinary
patch. If \(r=0\), full adjoint rank one means one-point smooth
fibers; the resulting isomorphism identifies the metric with the
coefficient metric directly. Later product-family/fiberwise-strict
assumptions in Berndtsson are not imported.

The source extraction has a sign-word inconsistency immediately
after (4.8); (2.5), (4.8), and Theorem 1.2 consistently give the
sign just used. The independent reading did not retrieve a new PDF.
This textual limitation does not reverse the displayed curvature
calculation.

**Divisorial extension uses a lower bound for \(H\).** At a general
point of a minimizing branch \(E\to Q\), normality, characteristic
zero generic smoothness, and a local root of a unit give the map
\((u_1,\ldots,u_n)\mapsto(u_1^{e_E},u_2,\ldots,u_d)\).
Away from other Jacobian components the volume density is
\(|u_1|^{2a_E}\) times a positive bounded unit. Integrating a fixed
fiber polydisc and dividing by the real transverse Jacobian
\(e_E^2|u_1|^{2(e_E-1)}\) gives
\(H(y)\geq C|y_1|^{2(\lambda_Q-1)}\).
Since \(\lambda_Q-1-a_Q\leq0\), the weight
\[
 \Phi_0=-\log H+\sum_Qa_Q\log|t_Q|^2
\]
is bounded **above** near a general point of each omitted divisor.
Its plus sign is the frame rule for \(-K_Y+A_0\).
Other correction factors are units at that general point.
The usual psh removability theorem gives extension there.
The remaining set has codimension at least two; the report's
transverse-circle/Hartogs argument supplies the upper bound.
The projected exceptional parameter set has measure zero, and
submean inequalities propagate the bound. Uniqueness and
pluriharmonic frame transitions give gluing.

**Integrability is a different inequality.** The preceding lower
bound for \(H\) cannot prove an upper bound on \(e^{-\Phi_0}\).
The proof instead uses the nonnegative-measure identity
\[
 e^{-\Phi_0}dV_y
   =g_*\bigl(\prod_Q|t_Q\circ g|^{-2a_Q}\pi^*\Omega_h\bigr)
\]
off the omitted locus. A projective log resolution gives a bounded
positive unit times \(\prod_j|z_j|^{2\gamma_j}dV_z\), with every
\(\gamma_j>-1\) by the all-valuation argument. Each radial integral
is finite. Properness makes the inverse image of a compact base
set compact, so finitely many integrable charts suffice.
The extended weight changes values only on a Lebesgue-null analytic
set. This proves unweighted local integrability, rather than a
weighted substitute.

## Historical versions and failed route

| Old claim | Versions and assessment |
|---|---|
| `C_G_VOLUME` | v1: the sourced theorem above, conditionally supported; reproduction, not verified-new mathematics. |
| `C_G_SUBKLT` | v1 target; v2 adds the toroidal-resolution assumption; v3 retires it in favor of the all-valuation logarithmic calculation. The mathematical statement is unchanged. |
| `C_G_POSITIVITY` | v1 target; v2 adds the precise Theorem 1.2 assumption. Attribution is supported by the present independent source reading. |
| `C_G_STRICTNESS` | v1 target; v2 adds Proposition 4.2/(4.8). The patch conclusion, including \(r=0\), is supported, not global strictness. |
| `C_G_EXTENSION` | v1 target; v2 assumes psh removability; v3 substitutes the local argument; v4 explicitly records projective log resolution. Same conclusion, with foundations visible. |
| `C_TV_AUDIT` | v1 is a research task, not an additional theorem. This unit supplies an assessment, not native acceptance. |
| `C_TV_COUNTEREXAMPLE` | v1 is an untried witness obligation, expressly not a claim that a counterexample exists. No witness is in the inventory. |
| `C_TV_KIM_PREMISES` | v1 is the unproved applicability obligation on the retired Kim shortcut. It is not a theorem proved by generic rank one. |

Kim, *Canonical bundle formula and degenerating families of volume
forms*, arXiv:1910.06917v5, Theorems 1.1-1.2 and Definition 4.1,
was actually inspected by the source reader. Its Kawamata setup
includes SNC and connected-fiber data, a log-Calabi-Yau pullback
relation, a particular rounded horizontal-boundary rank, and
prescribed divisor metrics/volume poles. Theorem 1.1 adds an
effective horizontal boundary; Theorem 1.2 distinguishes raw from
rounded-horizontal volumes. Full rank one alone does not supply
these data or identify the metric \(H\). Retirement is justified
as an unsupported application, not as a refutation of Kim or of
the manuscript. No missing hypotheses were constructed in this review.

## Supported scope and concrete boundaries

No invalid step in the retained direct proof was identified under
the inputs just specified. Foundational resolution, normality,
generic smoothness, and psh/measure-theoretic results remain external,
not kernel-certified. Source attribution has a fresh independent
reading, but official literature-tier archiving is still blocked by
the current writable-path boundary; a reading judgement is not
silently relabeled as such a record.

The proof assumes, and does not construct, the equidimensional
toroidal model, full rank, or strictness patch needed in a particular
application. Invariant rank is not a replacement for full rank.
It proves neither the E correction-ring theorem nor the V model
interface, invariant-index results, or headline nonvanishing.
The source's adjacent `g:correction-iitaka-zero` corollary is a
reference statement, not an additional result attempted by the
old report or ledger; it is not silently claimed as reviewed here.
Novelty of the original manuscript is not determined. The only
current research result is this review (`not_applicable` novelty).
