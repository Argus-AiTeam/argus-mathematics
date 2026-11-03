# An equation-class-dependent negative status report for AIM Problem 1.2

**Result class:** source-grounded negative status report (`honest_final_report`),
independently accepted for the permitted correction or status-resolution
deliverable, with an explicit nonlinear relation and a proved-in-prose
all-orders linear obstruction.
**Not claimed:** a counterexample to AIM, a failure of its holomorphic anomaly
equation, a new theorem, a kernel-checked proof, or campaign completion.
The earlier independent bounded acceptance is preserved. The separate
campaign-scope mathematical correspondence ruling is also accepted, as recorded
in `roles/reviewer/progress.json:current_run_review` and
`final_submission_review`. Terminal Host admission remains uncertified and the
deployment decision remains pending; Section 8 records this distinction.

## 1. Exact source and proposed status correction

[AIM], Problem 1.2, is headed "Eta-products and root systems and holomorphic
anomaly equation". Its premise, including its original spelling, is:

> As it turns out mock modular forms (such as eta-products) do not satisfy the holomorphic anaomaly equation.

Its question is:

> Do they satisfy other differential equations?

The source specifies no eta-product family, mock-form convention, order,
linearity, coefficient field, or independent variable for these "other"
equations. **In particular, AIM does not impose homogeneous linear equations
over \(\mathbb C(q)\).** We introduce that class only as a contrast, not as
a transcription of the problem.

The concrete status annotation proposed for the original dataset is:

> Equation class unspecified. Nonlinear differential-algebraic existence is
> already known for level-one modular and quasimodular forms, including
> \(\eta^{24}\). For this same explicit eta-product there is no nonzero
> finite-order homogeneous linear equation over \(\mathbb C(q)\).
> The intended geometric equation, mock-form convention, and eta-product
> family in AIM remain unspecified; the original AIM inquiry is not thereby
> refuted or fully resolved.

This annotation has independent mathematical acceptance under the
**correction or status-resolution** allowance in `OBJECTIVE.md`, not its
source-counterexample branch. It establishes why
the missing equation class has mathematical consequences, rather than merely
observing vague wording. It would be wrong either to present unrestricted
nonlinear existence for this example as still unknown, or to present our
negative linear theorem as AIM's assertion. No original dataset or audit has
been edited.

The earlier input row was explicitly `search_snippet_reviewed`; its lead was
that eta-products being modular might conflict with the phrase "mock modular".
The structural graph repair was superseded by the independent acceptance of
this explicit function, sourced baseline, universal obstruction, and exact
algebraic replay in reviewed handoff `834882da492f/round-0001.json`.
The present record adds no mathematical result to that accepted work: it
reconciles the existing independent campaign-level correspondence ruling, not
terminal Host admission. The
convention-dependent modularity shortcut is retired, not promoted.

## 2. Objects, domain, and conventions

Put
\[
 \mathbb H=\{\tau\in\mathbb C:\operatorname{Im}\tau>0\},\qquad
 q=e^{2\pi i\tau},\qquad
 \eta(\tau)=e^{\pi i\tau/12}\prod_{n\geq1}(1-e^{2\pi i n\tau}).
\]
Our eta-product is
\[
 \Delta(\tau)=\eta(\tau)^{24},\qquad
 f(q)=q\prod_{n\geq1}(1-q^n)^{24}\quad (|q|<1).
\]
The product converges locally uniformly; \(f\) is holomorphic on the open
unit disk, is nonzero on the punctured disk, and \(f(q)=q+O(q^2)\).
There is no choice of a \(24\)-th root in the definition of \(f\).

By [Z], equation (22) and Proposition 7,
\[
 \Delta\!\left(\frac{a\tau+b}{c\tau+d}\right)
   =(c\tau+d)^{12}\Delta(\tau)
 \quad\left(\begin{pmatrix}a&b\\c&d\end{pmatrix}\in{\rm SL}_2(\mathbb Z)\right).
\]
Thus the group is the full modular group, the weight is \(12\), and the
multiplier of \(\Delta\) is trivial. It has no poles in \(\mathbb H\).
The cusp at infinity has width one and vanishing order one. Every rational
cusp is equivalent to infinity: for coprime \(a,c\), Bezout gives integers
\(b,d\) with \(ad-bc=1\). The slash transform is again \(\Delta\), so it
vanishes at each cusp. This supplies the cusp conditions, not merely a
transformation law.

Throughout,
\[
 \theta=q\frac{d}{dq}=\frac{1}{2\pi i}\frac{d}{d\tau},\qquad f_j=\theta^j f.
\]
By a nonzero finite-order homogeneous linear equation over \(\mathbb C(q)\)
we mean
\[
 \sum_{j=0}^{N}a_j(q)\frac{d^j f}{dq^j}=0,\quad
 N<\infty,\quad a_j\in\mathbb C(q),\quad \text{not all }a_j=0.
\]
An identity on any nonempty open subset avoiding the poles would suffice:
clearing denominators and the identity theorem extend it throughout the disk.
The coefficients are arbitrary complex rational functions, not just rational
numbers. Order zero is included. Replacing \(d/dq\) by \(\theta\) gives the same
class, as proved below. No assertion about linear equations over a different
coefficient field or in a different independent variable is intended.

## 3. Known nonlinear relation, made explicit

For the normalized series
\[
 E_2=1-24\sum_{n\geq1}\sigma_1(n)q^n,\quad
 E_4=1+240\sum_{n\geq1}\sigma_3(n)q^n,\quad
 E_6=1-504\sum_{n\geq1}\sigma_5(n)q^n,
\]
[Z], Proposition 15, equation (54), gives
\[
 \theta E_2=(E_2^2-E_4)/12,\quad
 \theta E_4=(E_2E_4-E_6)/3,\quad
 \theta E_6=(E_2E_6-E_4^2)/2.
\]
Equation (23) and the logarithmic derivative in Proposition 7's proof give
\[
 E_4^3-E_6^2=1728f,\qquad \theta f=fE_2.
\]
The derivative convention is exactly [Z], equation (51).
Moreover, [Z], **Proposition 16**, already states that every modular or
quasimodular form on the full modular group satisfies a nonlinear third-order
differential equation with constant coefficients. Thus nonlinear existence is
a cited baseline, not a novelty claim inferred from a few coefficients.

Applying the displayed derivation twice more yields
\[
 12f_2=f(13E_2^2-E_4),\qquad
 72f_3=f(91E_2^3-21E_2E_4+2E_6).
\]
Consequently, if
\[
 A=13f_1^2-12ff_2,\qquad
 B=91f_1^3-126ff_1f_2+36f^2f_3,
\]
then \(A=f^2E_4\) and \(B=f^3E_6\). We obtain the explicit equation
\[
 \boxed{(13f_1^2-12ff_2)^3
 -(91f_1^3-126ff_1f_2+36f^2f_3)^2-1728f^7=0.}                 \tag{N}
\]
It is a nonzero polynomial: its \(f_3^2\) coefficient is \(-1296f^4\).
It genuinely involves order three and is nonlinear. The coefficients are
integers in the \(\theta\) convention; expansion in ordinary \(q\)-derivatives
has polynomial, hence rational, coefficients in \(q\). No division by \(f\)
was used in this elimination, so (N) holds also at \(q=0\).

## 4. An exact obstruction at every root of unity

**Lemma.** For every root of unity \(\zeta\), the disk function \(f\) has no
holomorphic extension to a neighborhood of \(\zeta\).

Write \(\zeta=e^{2\pi i a/c}\), where \(a,c\) are coprime integers and \(c>0\).
Choose integers \(b,d\) with \(ad-bc=1\). For \(y>0\), set
\[
 \tau=\frac ac+iy,\qquad
 z=\frac{d\tau-b}{-c\tau+a}
   =-\frac dc+\frac{i}{c^2y},\qquad
 \gamma=\begin{pmatrix}a&b\\c&d\end{pmatrix}.
\]
Direct algebra gives \(\gamma z=\tau\), \(cz+d=i/(cy)\), and
\[
 w=e^{2\pi iz}=e^{-2\pi i d/c}\exp\!\left(-\frac{2\pi}{c^2y}\right).
\]
Modularity and \(i^{12}=1\) therefore give the exact identity
\[
 f(\zeta e^{-2\pi y})=(cy)^{-12}
       w\prod_{n\geq1}(1-w^n)^{24}.                         \tag{C}
\]
The certificate verifies the Mobius identities for indeterminate \(a,c,d,y\)
after substituting \(bc=ad-1\), not for a list of sampled cusps.
The side conditions \(c>0,y>0\) make every denominator used above nonzero.

Put \(A_c=2\pi/c^2>0\) and \(r=|w|=e^{-A_c/y}\). For sufficiently small
\(y>0\), \(r\leq1/2\). The elementary inequality \(1+t\leq e^t\) gives
\[
 \prod_{n\geq1}|1-w^n|^{24}
 \leq\exp\!\left(24\sum_{n\geq1}r^n\right)
 =\exp\!\left(\frac{24r}{1-r}\right)\leq e^{24}.
\]
This follows first for finite products and then by convergence. Hence
\[
 |f(\zeta e^{-2\pi y})|
 \leq e^{24}c^{-12}y^{-12}e^{-A_c/y}.                       \tag{B}
\]
For **each arbitrary integer \(m\geq0\)**, the positive exponential series
implies \(e^t\geq t^{m+13}/(m+13)!\) for \(t>0\). Applying this with
\(t=A_c/y\) to (B) gives the explicit bound
\[
 |f(\zeta e^{-2\pi y})|
 \leq e^{24}c^{-12}\frac{(m+13)!}{A_c^{m+13}}\,y^{m+1}
 =o(y^m).                                                  \tag{F}
\]
No limiting numerical estimate or finite order cutoff enters (F).

Suppose a holomorphic function \(F\) on a neighborhood of \(\zeta\) agreed
with \(f\) on the disk side. If its Taylor expansion had a first nonzero
coefficient of order \(m\), then
\[
 \frac{F(q)}{(q-\zeta)^m}\longrightarrow \alpha_m\ne0.
\]
But along \(q=\zeta e^{-2\pi y}\) we have
\(|q-\zeta|/y\longrightarrow2\pi\), so (F) makes this ratio tend to zero.
This is impossible. All Taylor coefficients must therefore vanish.
Holomorphicity then makes \(F\) identically zero near \(\zeta\), contradicting
the nonvanishing of \(f\) on the punctured disk. This proves the lemma.

The lemma concerns failure of holomorphic extension of a \(q\)-function at a
boundary point. It does **not** assert failure of modular holomorphicity at a
cusp; the cusp coordinate and the weight factor are different. It is also
not necessary to classify the boundary point as an isolated singularity.

## 5. The obstruction covers all finite linear orders

**Theorem.** The function \(f\) satisfies no nonzero finite-order homogeneous
linear differential equation over \(\mathbb C(q)\).

Suppose otherwise and take \(N\) to be the highest index with nonzero
coefficient. Clearing denominators gives
\[
 p_N(q)f^{(N)}+\cdots+p_0(q)f=0,\qquad
 p_j\in\mathbb C[q],\quad p_N\ne0.                          \tag{L}
\]
When \(N=0\), (L) contradicts the nonvanishing of \(f\) on a nonempty open
subset of the punctured disk.

For \(N\geq1\), the polynomial \(p_N\) has only finitely many zeros, whereas
there are infinitely many roots of unity. Choose a root of unity \(\zeta\)
with \(p_N(\zeta)\ne0\). In a sufficiently small disk \(U\) about \(\zeta\),
all the normalized coefficients \(p_j/p_N\) are holomorphic.
The equation for the vector
\[
 Y=(f,f',\ldots,f^{(N-1)})^{\mathsf T}
\]
is \(Y'=M(q)Y\), with a holomorphic companion matrix \(M\) on \(U\).

Here is the needed local continuation argument, rather than an unrecorded
appeal to a singularity-classification theorem. Choose \(q_0\in U\cap\{|q|<1\}\)
close enough to \(\zeta\) that a disk \(V\) centered at \(q_0\) contains \(\zeta\)
and has closure inside \(U\). Bound a matrix norm of \(M\) by \(K\) on that
closure. Define holomorphic matrix functions on \(V\) by
\[
 V_0(q)=I,\qquad V_{n+1}(q)=\int_{q_0}^{q}M(s)V_n(s)\,ds .
\]
The integrands are holomorphic and \(V\) is simply connected. Integration
along radial segments and induction give
\(\|V_n(q)\|\leq K^n|q-q_0|^n/n!\), taking \(\|I\|=1\).
Thus \(\Phi=\sum_{n\geq0}V_n\) converges locally uniformly, is holomorphic,
and satisfies \(\Phi'=M\Phi\), \(\Phi(q_0)=I\).
Consequently \(\widetilde Y=\Phi Y(q_0)\) is holomorphic across \(\zeta\).

Uniqueness on the disk side follows without an extra hypothesis:
the difference of two holomorphic solutions with the same value at \(q_0\)
has every derivative zero at \(q_0\), by differentiating \(Y'=MY\)
inductively. Its Taylor series is zero locally, and the identity theorem
extends equality throughout the connected intersection of the two disks.
The first component of \(\widetilde Y\) therefore extends \(f\) across
\(\zeta\), contradicting Section 4. This proves the theorem for arbitrary
finite \(N\), not for a searched range of \(N\) or coefficient degrees.

Finally, induction using the product rule shows
\[
 \theta^N=q^N(d/dq)^N+\sum_{j<N}b_{N,j}(q)(d/dq)^j,\qquad
 b_{N,j}\in\mathbb Z[q].
\]
The leading term at the induction step is multiplied by \(q\), so its
coefficient is \(q^{N+1}\). A highest nonzero coefficient \(a_N(q)\) in
a \(\theta\)-linear equation therefore gives highest ordinary-derivative
coefficient \(a_N(q)q^N\ne0\) in the field \(\mathbb C(q)\).
This proves the claimed equivalence and the same obstruction for \(\theta\).

## 6. Mock conventions and the anomaly equation are separate questions

We explicitly distinguish two possible terminologies. In an **inclusive**
usage, a mock modular form is a holomorphic part of a harmonic weak Maass
form with the stated modular transformation and cusp-growth conditions,
allowing zero shadow. In a **proper-mock** usage one additionally requires
nonzero shadow. Neither choice is attributed to AIM.

For this example the completion can be \(\widehat\Delta=\Delta\) itself.
It is holomorphic, so its weight-12 hyperbolic Laplacian vanishes and
\[
 \xi_{12}(\Delta)=2i(\operatorname{Im}\tau)^{12}
          \overline{\frac{\partial\Delta}{\partial\bar\tau}}=0.
\]
It satisfies the modular and cusp conditions in Section 2, hence also the
allowed exponential cusp-growth bound. It belongs to the inclusive class
and is excluded from the proper-mock class by definition.

[BF], Proposition 3.2, supports precisely this caution: in its stated
vector-valued spaces, for \(k\in\frac12\mathbb Z,\ k\ne1\),
\(\xi_k:H_{k,L}\to M^!_{2-k,L^-}\) has kernel \(M^!_{k,L}\).
The next page defines \(H^+\) as the preimage of cusp forms and explicitly
includes \(M^!\). Its unrestricted codomain is **not** the cusp space.
The paper is not being cited as choosing our terminology; the scalar
zero-shadow calculation above is direct. In particular, we do not silently
identify an unspecified vector representation with the scalar example.

The displayed equation in the AIM introduction is, as printed,
\[
 \bar\partial_i F^g=\tfrac12\bar C_i^{jk}
 \left(D_jD_kF^{g-1}+\sum_{h=0}^{g-1}D_jF^hD_kF^{g-h}\right),\qquad g>1.
\]
No assignment of \(\Delta\) to the genus-indexed \(F^g\), geometric variables,
covariant derivatives, or tensors in this equation has been established.
Zero shadow, or simply \(\bar\partial\Delta=0\), does not determine its
right-hand side. **This work makes no claim that \(\Delta\) fails this
equation.** Nor does it establish membership in an unspecified narrower
family of proper mock forms or geometric eta-products intended by AIM.

The retired route `R-modularity-only` in `research/MATH_STATE.json` records
exactly this obstruction to the earlier shortcut. The broader source
counterexample routes are not declared exhausted.

## 7. Exact replay and the remaining acceptance boundary

The inspected operation is `polynomial.ideal.normal_form.compute`, executed
through the approved pinned Jacobian CLI. The exact contract, payload, output,
version/transport metadata, and error/timeout status are in
`research/jacobian/normal-form.*.json`. The actual outcome was `COMPUTED`,
with zero remainder and `in_ideal=true`; it was not `UNKNOWN` or a timeout.
This direct CLI run has no MCP server version or negotiated MCP protocol.

The payload uses \(\mathbb Q[j_3,j_2,j_1,e_6,e_4,e_2,f]\), lexicographic order,
and these four generators:
\[
 j_1-fe_2,\quad 12j_2-f(13e_2^2-e_4),\quad
 72j_3-f(91e_2^3-21e_2e_4+2e_6),\quad e_4^3-e_6^2-1728f .
\]
Its target is precisely the polynomial in (N).
`certificates/eta_exact.py` independently uses only Python's standard-library
`Fraction` arithmetic, not Jacobian's CAS. It derives the three jets, checks
every payload polynomial, expands (N) to
\(f^6(e_4^3-e_6^2-1728f)\), and verifies the arbitrary-cusp algebra of (C)
after clearing nonzero denominators and reducing \(i^2+1=0\).
It also rejects a nonzero residual control.
The recorded run passed 21 exact identities, binding checks and controls.

From the campaign directory, a fresh independent replay is:

```bash
timeout 75s /home/argustest/zimo/references/jacobian/.venv/bin/jacobian run \
  polynomial.ideal.normal_form.compute \
  --file research/jacobian/normal-form.payload.json \
  > certificates/normal-form-replay.json
/home/argustest/zimo/argus-latest/.venv/bin/python certificates/eta_exact.py \
  --jacobian-output certificates/normal-form-replay.json
```

The saved engineering result is `certificates/eta_exact_result.json`.
An incomplete operation or wrong request is rejected, not interpreted as
support. The code is an exact algebraic certificate, **not** an automated
verification of the analytic proof or of source meaning. Sections 4-5 give
the universal analytic reduction that a finite symbolic computation alone
cannot supply. The independent Reviewer has already accepted the cited
hypotheses, flatness and continuation arguments, source annotation, and exact
replay. `roles/reviewer/progress.json` records six supporting published-source
attributions with none outstanding, the independently read AIM passage, and
21 passed exact checks against `certificates/reviewer-normal-form.output.json`.
The replay result is `certificates/reviewer-eta-exact-result.json`.

The reviewed handoff at
`/home/argustest/zimo/.argus-campaign-20000715-run2/projects/e0e09b96eff5/handoffs/834882da492f/round-0001.json`
states: "The source-grounded status-resolution candidate satisfies this mission:
the universal analytic proof is sound, the cited hypotheses apply, and the exact
algebraic certificate independently replays. Campaign completion is not
certified." Its bounded `partial_result` verdict is preserved. Nothing in this
handoff changes Sections 2-6, the claim statements, cited sources, or certificate,
and no named mathematical gap has been identified that warrants another replay.

## 8. Campaign-level acceptance mapping and recorded independent ruling

The exact objective permits a "rigorous counterexample, correction, or status
resolution with a rerunnable certificate." This submission invokes the
**correction or status-resolution** branch only. The independent Reviewer
accepted the Section 1 annotation as the permitted terminal negative-status
deliverable, not as an AIM counterexample. The rulings are
`roles/reviewer/progress.json:current_run_review`, reported by
`reviewer:copilot-cab62ebf8d1d` at `2026-09-05T11:21:40Z`, and
`roles/reviewer/progress.json:final_submission_review`, reported by
`reviewer:copilot-f0483b542081` at `2026-09-05T11:39:00Z`.
Both explicitly mark all four mathematical review items `satisfied`.
This records those rulings, not a reinterpretation of the preceding bounded
verdict or a new scientific review.

The accepted mathematical outcome maps to existing evidence as follows. The exact
source-aligned statement is the independently read AIM quotation in Section 1
and C4; the unspecified equation class is a source fact, not a new hypothesis
attributed to AIM. The explicit object is the eta-product
\(f(q)=q\prod_{n\geq1}(1-q^n)^{24}\), with its domain, group, multiplier, cusp
conditions, and convention limits stated in Sections 2 and 6. The substantive
negative witness is this same \(f\): equation (N) holds, but **every** nonzero
finite-order homogeneous \(\mathbb C(q)\)-linear equation fails. C2-C3 and
Sections 3-5 establish that contrast; the exact certificate and independent
replay support its algebraic steps. Thus the report supplies more than an
ambiguity observation or a bounded no-witness search. It gives a concrete
equation and a universal obstruction that justify the equation-class-dependent
status annotation.

The witness is negative for the expressly defined linear class, **not** for an
assertion made by AIM. Its all-orders exclusion is not exhaustion of the
eta-product families, mock conventions, or geometric anomaly equations in the
original inquiry. The permitted deliverable is the precise status
annotation, while that broader inquiry remains unresolved. No conclusion here
rests on a timeout, a finite coefficient cutoff, or numerical evidence.

The recorded objective mode remains `targeted`; the research target level
remains `exploratory`. These are different settings. An exploratory research
target removes no terminal goal obligation and does not automatically turn an
accepted partial result into campaign completion. Acceptance must instead rest
on the explicit status-resolution allowance above. No objective, target,
authoritative dataset, or source-audit record has been changed.

The table summarizes the existing independent rulings cited above; it is not
a new Engineer verdict.

| Review item | Recorded independent mathematical ruling |
| --- | --- |
| `review.goal-achieved` | **Satisfied for the permitted status-resolution deliverable.** The unchanged objective's explicit allowance and the Section 1 and Section 8 mapping discharge mathematical correspondence; bounded acceptance alone is not the basis. Terminal Host admission is separate. |
| `review.statement-fidelity` | **Satisfied.** The AIM quotation, object definitions, all finite orders including zero, arbitrary complex rational coefficients, equation-class distinction, and zero-shadow caveat are preserved. The terminal mathematical label does not mean solving or refuting AIM. |
| `review.argument-correct` | **Satisfied.** The independent C1-C5 findings, six source attributions, and saved exact replay support the unchanged report. The universal analytic argument is human-reviewed; the exact certificate supports its algebraic steps only. |
| `review.outcome-honest` | **Satisfied.** The accepted `honest_final_report` is not a new theorem, kernel proof, AIM counterexample, or exhausted campaign search space. The preceding bounded `partial_result` verdict and all scientific limitations are preserved. |

These explicit independent rulings discharge the unchanged
`eta-status-correspondence` statement and its accepted-candidate dependency in
`research/PROOF_GRAPH.json`. The original `eta-source-negative-witness` node
remains open and unconfirmed. Recording this correspondence does not certify
campaign completion, original-source refutation, or all-route exhaustion.

The latest `final_submission_review.status` is `replan_requested` because it
separately records the submission-contract restriction
`result_class_not_exploratory_terminal:honest_final_report`, not a mathematical
rejection. Its accepted classification remains `honest_final_report`; its
restriction was inspected and reproduced, not reported as an observed
current-mission Host rejection. Terminal Host admission is not certified, and
the pending operator deployment decision is unchanged. The current handoff
requires independent review of this record-only reconciliation, not another
scientific review, an unchanged terminal resubmission, or deployment.

## Sources actually obtained

- **[AIM]** AimPL, *Gromov-Witten invariants and number theory*, Section 1 and
  Problem 1.2, <http://aimpl.org/gromwitnumthry/1/>, retrieved 2026-09-05.
  Original HTML: `research/sources/aim-problem-1.html`; readable extraction:
  `research/sources/aim-problem-1.txt`, lines 59-119. HTTPS reported an expired
  certificate; retrieval used the originally cited HTTP URL. The ledger
  records the URL and locator without inventing a DOI or arXiv identifier.
- **[Z]** Don Zagier, *Elliptic Modular Forms and Their Applications* (2008),
  DOI **10.1007/978-3-540-74119-0_1**. Author-hosted PDF:
  <https://people.mpim-bonn.mpg.de/zagier/files/doi/10.1007/978-3-540-74119-0_1/fulltext.pdf>.
  Exact locators: pp. 20-22, equation (22), Proposition 7, its first displayed
  logarithmic derivative, equation (23), and the paragraph on the simple
  cusp zero; p. 48 equation (51); p. 49 Propositions 15-16 and equation (54).
  Full PDF/text and the cited-page excerpts are in `research/sources/modular/`.
- **[BF]** Jan Hendrik Bruinier and Jens Funke, *On Two Geometric Theta Lifts*,
  **arxiv:math/0212286v4**, <https://arxiv.org/pdf/math/0212286v4>.
  Exact locators in this version: Section 3 setup on PDF p. 8; Proposition
  3.2, equation (3.5), on PDF p. 10; definition of \(H^+\) and inclusion of
  \(M^!\) on PDF p. 11. Full PDF/text and the cited-page excerpt are preserved
  in `research/sources/modular/`. These are arXiv PDF page numbers, not
  asserted journal pagination.

All source dependencies are recorded as assumptions in the local ledger.
Independent Reviewer has attributed all six published-source propositions and
separately supported the exact AIM passage. No published-proposition attribution
remains outstanding; Engineer has not self-certified those findings.
