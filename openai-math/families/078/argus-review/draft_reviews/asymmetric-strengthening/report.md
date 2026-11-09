# Engineer review: asymmetric strengthening

**Assessment:** supported conditional structural extension of the existing proof. This exploratory review does not establish mathematical novelty, introduce a new route, or independently accept the unit.

## Contribution classification and attribution rationale

**Classification: `confirmed_original`.** This means original **relative
to the pinned manuscript**, not globally new in the literature.
OpenAI's `prop:directional-bootstrap` at `07-rate-transfer.tex:841-860`
uses one common child rate `s` and concludes that rate under either pin.
The old Argus report instead states the unequal-rate targets
`min{s_B,(s_A+s_B)/2}` and `min{s_A,(s_A+s_B)/2}`. Its checked
two-component clipped recurrence proves those targets under the same
explicit hypotheses with fixed positive unequal rates. The additional
statement is not the manuscript's symmetric proposition; its statement
and derivation are attributed to Argus, while the underlying symmetric
argument is OpenAI's and the external theorem is Ren-Wang's. A targeted
source comparison found no unequal-rate statement in the pinned TeX.
Literature novelty remains `not_established`, and no concrete upstream
asymmetric application or unconditional theorem is claimed.

## Exact sources, versions and contribution

The version/evidence authority is the read-only `research/DRAFT_REVIEW_INDEX.json`. `DB_ASYMMETRIC` has exactly **v1 and v2**, both with natural-statement hash `82ee6e6e03c92bc9ac5ed8130c87052be7bba045810e732cbfee6e03b996dd64`, in `DB_CTX` v1, hash `df998bc708f752f5c69865c573c82a008e6b9ec2baf0e1a0905d37bd8260eda8`. V1 registers no external assumption; v2 registers detailed `RW41`, hash `95d5f6fb8ffa3609af348397524a6ef9e63ceaad7add890ca4f5ecd22f839606`. The proof in both versions depends on that precise external theorem.

The old shared report is `families/078/first-pass/directional_bootstrap/report.md`, SHA-256 `c3eab989a35afcd706fad01623931037846c46544ffd7f6d9b527cb77cee6cbe`. The claim is stated in section 1, lines 71–107; the unequal-rate reciprocal derivation, recurrence and common-core argument are in sections 6–7, lines 293–403. The inspected dependency arguments occupy lines 172–292 and 404–473.

The exact manuscript comparison is the **symmetric** proposition/proof at `build/sections/07-rate-transfer.tex:841–993`, SHA-256 `74cabf96002ba34d49cd2cc0b79fa6141c15fbe1561c9ee535b10c3f46d0d910`, not a literally stated unequal-rate theorem. The projection source is `build/sections/03-projection.tex:23–206`, SHA-256 `265cf9b94bde9fc85fab47d26f05cab2fe5446f14a38ab8b2b59c85703fed217`. Both are at revision `4eaee87548250b2682affda7d05d947c05554bae` in `openai-math/preprints/Bochner-Riesz-Multipliers-in-Three-Dimensions-September-24-2026`, to which the old manuscript alias resolves. Hash/snapshot matches are reused from the index.

Attribution: this is the old Argus Engineer's proposed unequal-child-rate structural strengthening of the manuscript argument, with the planar discrete input attributed to Ren–Wang, arXiv:2308.08819v3, Theorem 4.1/Definition 3.1. It is an analytical consequence of the inspected interfaces, not a separate literature-verified priority claim. Old mathematical novelty is **not established**; review-level novelty is **not applicable**.

## Exact claim and hypotheses

Replace the two named conditional child rates in the literal directional-bootstrap hypotheses by fixed \(0<s_A,s_B\le1\). Keep bounded planar pair laws \(P\le K\mu_A\otimes\mu_B\) with subpower loss, no-strip decay for both named populations at every fixed positive width exponent, and one original subpower-mass event for every finite test carrying simultaneous original direction bins and tested good-parent fibers.

Named populations need not be actual marginals. Their child caps are on the full named conditional populations at the tested parents, available at every fixed relative depth needed by the finite mesh. Separations, original-bin errors and core retentions use a common subpower envelope. The two profiles refer throughout to the same original pair law. Fixed positive increments, a finite iteration count and output/input loss and mesh choices precede the precision limit; no uniform dependence on the profile, strip exponent or shrinking increment is claimed.

The target rates are exactly
\[
 u_A^*=\min\{s_B,(s_A+s_B)/2\}\quad\text{given full }A,
 \qquad
 u_B^*=\min\{s_A,(s_A+s_B)/2\}\quad\text{given full }B.
\]
For every finite tested depth list and fixed positive output error, one common subpower restriction makes both actual conditional direction caps uniform at every surviving full pin, with prefix dimension at least these targets. At positive depth \(d\) this means the limiting caps \(\rho^{u_A^*d-o(1)}\) and \(\rho^{u_B^*d-o(1)}\), interpreted through the ordered finite-tolerance statement. The same conclusion survives further subpower support restrictions satisfying the literal hypotheses after another quantified common trim.

## Decisive checks of the unequal-rate argument

**Seed and pin labels.** The two-pin proof conditions a rescaled \(A\) child on two \(B\) pins, so its \(s_A\) child cap gives \(F_B'\ge s_A/2\). Reversing the roles gives \(F_A'\ge s_B/2\). The initial rate vector, with coordinates “given \(A\), given \(B\),” is therefore
\[
 (x_0,y_0)=(s_B/2,s_A/2),
\]
not \((s_A/2,s_B/2)\). The retained child cap after two pins is justified by the star pin-pair likelihood check, and the absolute-sine no-strip argument includes antiparallel pins.

**Reciprocal step.** A current bound \(F_A(r)\ge xr\) transfers, by original-law averaging with the exact \((r_cv_c)^{-1}\) loss, to the actual pin-direction marginal in a fixed \(A_j\) parent. Recoring adds at most \(M^{-1}\), preserves the named \(s_A\) child cap, and supplies positive subpower product graph mass. The weighted tagged projection input then gives
\[
 F_B'\ge\min\{1,s_A,(s_A+x)/2\}
           =\min\{s_A,(s_A+x)/2\}.
\]
The reverse step gives the other coordinate. Accordingly the simultaneous vector update is
\[
 T_A(x,y)=\min\{s_B,(s_B+y)/2\},\qquad
 T_B(x,y)=\min\{s_A,(s_A+x)/2\}.
\]
The clip by the opposite child rate is indispensable. In this regime the extra clip by \(1\) is redundant because \(s_A,s_B\le1\).

**Convergence and targets.** Each coordinate is monotone in its argument and has Lipschitz constant at most \(1/2\). Thus \(T\) contracts maximum-coordinate distance by at most \(1/2\). Its first update is coordinatewise at least the seed, so all subsequent iterates increase monotonically.

If \(s_A\le s_B\), the proposed fixed point is
\[
 (x^*,y^*)=((s_A+s_B)/2,s_A).
\]
The first equation is immediate; in the second, \((s_A+x^*)/2=(3s_A+s_B)/4\ge s_A\), so clipping gives \(s_A\). If \(s_B\le s_A\), the symmetric calculation gives \((s_B,(s_A+s_B)/2)\). These are precisely the claimed two minima. Contraction supplies
\[
 \|(x_n,y_n)-(x^*,y^*)\|_\infty
 \le 2^{-n}\|(x_0,y_0)-(x^*,y^*)\|_\infty.
\]
Every fixed positive error therefore needs finitely many repetitions. The derivative inequalities integrate on the same original absolutely continuous profiles. When the rates coincide the update and target reduce exactly to the symmetric \(u\mapsto(s+u)/2\) bootstrap.

**One law, uniformity and heredity.** On the one original output event \(H\), the two target profile bounds give original per-pin bin numerators. The existing old-report common-core construction with references \(P_A,P_B\) and threshold \(m/4\), \(m=P(H)\), retains raw original mass at least \(m/2\). Row and column floors make both actual caps uniform at every surviving pin with cost \(4/m\), without identifying actual marginals with named populations. A later relative-mass \(z\) weighted restriction admits a further common core of raw relative mass at least \(z/2\) and cap cost at most \(4/z\).

The literal manuscript's final paragraph gives two typical-pin estimates, not an explicit normalized all-pin intersection. The old draft's existing common core supplies the stronger simultaneous formulation. Unequal rates do not change that construction and require neither separate good events nor manufactured per-fiber retention hypotheses.

## Evidence reuse and limitations

`judgement-DB_ASYMMETRIC-e9a9591e87fb` is an exact natural-statement-hash matching `reviewer:copilot-independent` supports judgement, reused for **both v1 and v2**. Historical pending/open prose is not evidence that it is absent.

Dependencies reuse the matching independent records `judgement-DB_RETAINED_MARGINAL-35c3badb8353`, `judgement-DB_GEOMETRY-97ac7ebced77`, `judgement-DB_TWO_PIN-cb2ce5a3b431`, and `judgement-DB_PROJECTION_INPUT-fbf8a583b9ce`. The precise detailed `RW41` has `citation-RW41-17b7e6e7b8e1`; finite-core v2 has `judgement-DB_FINITE_CORE-b195a60f0949` and mechanical record `lean-DB_FINITE_CORE-ae96dd262933`. These are historical supporting inputs, not fresh native acceptance, and a matching conclusion hash does not discharge dependencies. This unit does not borrow an automatic citation binding to `DB_MAIN` v2's distinct abbreviated `RW41` hash.

Supported scope is the fixed-rate analytical recurrence and conditional two-sided uniform target. No internal contradiction in the coordinate assignment, clipping, fixed point or contraction was found.

Concrete remaining scope-qualified gaps are:

1. **External-input scope:** the precise Ren–Wang theorem remains an external assumption, including its output-before-input admissible losses and thresholds. Literature retrieval was assigned elsewhere and not duplicated.
2. **Application scope:** availability of the simultaneous original-bin event and unequal named child/no-strip bounds for a concrete upstream population is unproved here. The extension is not a literally stated manuscript theorem and does not certify its downstream applications.
3. **Uniform-parameter scope:** rates are fixed positive constants; the proof supplies no uniform finite rate when dimensions, increments, mesh errors or strip exponents vary arbitrarily with precision.
4. **Novelty scope:** no priority search was performed; analytical derivability does not establish novelty of the strengthening.
5. **Formal scope:** both versions have no indexed formal source. Historical Lean 4.31.0/Mathlib certifies finite core/cap/mesh algebra, not this unequal-rate recurrence's geometric hypotheses, profile integration or full theorem.

The parent's shared existing finite replay supports only its finite examples/arithmetic; it is not the analytical proof. No `verify.py`, Lean, compiler or literature search was rerun by this worker. Old certificates are reading material, and only this unit's report and verdict were written.
