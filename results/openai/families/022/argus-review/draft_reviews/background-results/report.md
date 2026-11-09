# Engineer assessment: background-results

**Family:** 022. **Date:** 2026-11-07.  
**Actual source reader:** `reader:background-assessor-9200022`.  
**Disposition:** source-faithful, attributed external background within the scopes below; historical dependency-registration gaps in v1/v2. This is an Engineer assessment, not the native independent Reviewer or family acceptance. Independent review remains required and incomplete.

## 1. Scope and provenance

The contract is `OBJECTIVE.md`, with inventory `PRIOR_DRAFTS.json` and the background-results metadata in `research/DRAFT_REVIEW_INDEX.json`. Only `C_BHV_BACKGROUND` versions **1, 2, and 3** are assessed here. No backward-charge or RFJ mathematical argument is reassessed.

The external source is Victor **Beresnevich**, Manuel **Hauke**, and Sanju **Velani**, *Borel–Cantelli, zero-one laws and inhomogeneous Duffin–Schaeffer*, canonical identifier **`arxiv:2406.19198v1`**. These are their results, not original Argus contributions.

The index supplies manuscript comparison context at pinned revision **`4eaee87548250b2682affda7d05d947c05554bae`**, for *The weak inhomogeneous Duffin–Schaeffer conjecture* (September 25, 2026). That hash is **not a BHV revision**. This assessment did not independently inspect the manuscript manifest, manuscript proofs, Git history, or `.git`; the revision is reported from the index.

### Sources actually read

The following legacy paths were read, without modification, under `campaigns/9000022/`:

| Input | Actual use |
|---|---|
| `research/literature/4c68c425b2a7066d1f2b713f8a452757.json` | Complete archived BHV14 citation/excerpt and provenance note. |
| `research/literature/5a44deb09066d92fb9ae017c06177b94.json` | Complete archived BHV18 citation/excerpt and provenance note. |
| `research/remaining-first-joins/Thmtheorem14.txt` | Complete archived Theorem 14 statement. |
| `research/remaining-first-joins/Thmtheorem18.txt` | Complete archived Theorem 18 statement, including both lower bounds. |
| `research/remaining-first-joins/BHV-equations.txt` | Complete archived equations (52) and (76). |
| `research/remaining-first-joins/report.md`, §8, lines 756–769 | Background-only attribution, strict-inequality argument, quantifier limitation, and explicit exclusion from RFJ premises. |
| `research/MATH_STATE.json` | Exact `/contexts/3`, `/claims/26`, `/claims/27`, `/claims/28`, `/evidence/17`, `/evidence/18`, and `/evidence/26`; not the other mathematical claims. |

### Live primary-source retrieval

External access **succeeded**. An initial fetch of `https://arxiv.org/html/2406.19198v1#Thmtheorem14` returned the beginning of the article, truncated before the target; that response alone was not a theorem check. Subsequent direct retrieval of **`https://arxiv.org/html/2406.19198v1` returned HTTP 200 with the same final URL**. Its HTML was parsed in memory to read these exact targets:

| Locator | Source-read URL |
|---|---|
| Theorem 14 | <https://arxiv.org/html/2406.19198v1#Thmtheorem14> |
| Equation (52) | <https://arxiv.org/html/2406.19198v1#S4.E52> |
| Equation (76) | <https://arxiv.org/html/2406.19198v1#S5.E76> |
| Equation (78) | <https://arxiv.org/html/2406.19198v1#S5.E78> |
| Theorem 18 | <https://arxiv.org/html/2406.19198v1#Thmtheorem18> |
| Equation (88) | <https://arxiv.org/html/2406.19198v1#S5.E88> |
| The unnumbered alternative in Theorem 18 | <https://arxiv.org/html/2406.19198v1#S5.Ex59> |

A further successful HTTP 200 retrieval checked Theorem 18's display identifiers and the immediately preceding explanation that the shift is independent of \(\psi\), at the cost of extra divergence. The formulas below retain the source's `\Log` notation; no alternative logarithm convention is silently substituted.

Thus this is an actual targeted primary-source read by the reader named above, **not merely adoption of the archived reader's assertion and not an archive-only fallback**. The BHV theorem proofs and their internal dependencies were not audited or formally replayed. No literature survey or new proof search was performed. No citation archival/attribution action occurred, and no new literature record was written.

## 2. Exact old claim and all three versions

The natural statement is identical in all three exact ledger records:

> BHV prove the weak conjecture for every rational shift, with shift-adapted coprimality; their Theorem 18 instead constructs one Liouville shift from a prescribed divergent auxiliary function and assumes extra divergence. The latter is not a theorem for every prescribed irrational shift.

All three have an empty `formal_statement`, no retired assumptions, context `CTX_BHV_BACKGROUND@1` at `/contexts/3`, and common claim hash `dbff64705204d89c4bc205406e5900eb257e47cc3bd1e84eb0a741f94c49d9d4`. The context explicitly makes this cited background, not RFJ premises.

| Claim/version | Exact old ledger pointer | Registered external assumptions | Assessment |
|---|---|---|---|
| `C_BHV_BACKGROUND@1` | `/claims/26` | `[]` | Its attributed mathematical summary matches the primary source. Registration is incomplete for both external results; an empty assumption list does not make them self-proved. |
| `C_BHV_BACKGROUND@2` | `/claims/27` | `["BHV14"]` | Same supported summary. BHV14 is registered, but the Theorem 18 part still has no registered BHV18 assumption in this version. |
| `C_BHV_BACKGROUND@3` | `/claims/28` | `["BHV14", "BHV18"]` | Same supported summary, now with both background dependencies explicitly registered. No source-fidelity mismatch found within its stated scope. |

These are three assumption-list states of **one composite background claim**, not three independent mathematical results.

### Archived evidence bindings

* `citation-BHV14-bd70262d4369`, `/evidence/17`, supports the BHV14 assumption hash `99beece5d0d5eb2ee4b8037a6dbd957064d3966157152abdb1fcdb0426896c2d`; its artifact is the first literature JSON above. The assumption first appears at `/claims/27/external_assumptions/0`.
* `citation-BHV18-e8b02df535a3`, `/evidence/18`, supports the BHV18 assumption hash `4636c5b805785d7902aaad4412dfcf5e13506402fda573cf03f6a664618e67a3`; its artifact is the second literature JSON. The assumption first appears at `/claims/28/external_assumptions/1`.
* `judgement-C_BHV_BACKGROUND-51e6731df8c4`, `/evidence/26`, is one `supports` judgement linked to the old RFJ report by claim ID and the common hash, **without a version field**. It is not three separate judgements or explicit evidence that each assumption-list state was reviewed.

All three archived evidence records name **`reviewer:copilot-rfj`**. The literature notes assert an earlier independent primary-source read; these are archived provenance assertions, **not native Host-invoked independent review**. This assessment supplies a fresh, separately identified source read but does not promote either reader label to native Reviewer acceptance.

The parent task reports active pairs `C_REVIEW_BHV14`/`BHV14` and `C_REVIEW_BHV18`/`BHV18`, filed by `engineer:copilot-9200022`. This reader neither inspected nor modified that active ledger and did not perform a citation archival action on those pairs.

## 3. BHV14: exact hypotheses, inequalities, and matching argument

For **every rational** \(\gamma=A/B\), with \(A,B\in\mathbb Z\), \(B>0\), and \(\gcd(A,B)=1\), let \(\psi:\mathbb N\to\mathbb R_{\geq0}\) be arbitrary. There is **no monotonicity assumption on \(\psi\)**. Equation (52) is

\[
\sum_{q=1}^{\infty}\frac{\varphi(q)\psi(q)}{q}=\infty.
\tag{52}
\]

Theorem 14 says that, for almost every \(x\in[0,1]\), there are infinitely many integer pairs \((a,q)\in\mathbb Z\times\mathbb N\) satisfying the actual approximation and coprimality conditions

\[
|qx-\gamma-a|\leq\psi(q),
\qquad \gcd(A+aB,q)=1.
\tag{78}
\]

If (52) does not hold, it gives only finitely many such adapted-coprime pairs for almost every \(x\). The coprimality is **not** silently replaceable by \(\gcd(a,q)=1\). This pair-count convergence assertion should not be transferred to the unrestricted norm inequality merely by dropping coprimality.

Its divergence consequence is the weak approximation inequality

\[
\|qx-\gamma\|\leq\psi(q)
\quad\text{for infinitely many }q\in\mathbb N,
\tag{76}
\]

for almost every \(x\in[0,1]\), where the norm denotes distance to the nearest integer. The quantifiers are \(\forall\gamma\in\mathbb Q\,\forall\psi\) satisfying (52), followed by almost every \(x\); this is not a common full-measure set asserted simultaneously for all \(\psi\).

**Strictness check.** Apply Theorem 14 to \(\widetilde\psi=\psi/2\): its nonnegative domain is unchanged and its totient sum still diverges. Remove the countable, hence null, set

\[
E_\gamma=\{(a+\gamma)/q:a\in\mathbb Z,\ q\in\mathbb N\}.
\]

For \(x\notin E_\gamma\), a solution at a zero of \(\psi\) is impossible. Every remaining solution satisfies

\[
0<\|qx-\gamma\|\leq|qx-\gamma-a|
\leq\psi(q)/2<\psi(q).
\]

Each fixed denominator has only finitely many possible \(a\), so infinitely many pairs yield infinitely many denominators. The adapted coprimality is preserved by applying the theorem, not discarded from its hypotheses. This justifies the old strict weak conclusion, including the edge case of zeros of \(\psi\); merely changing the source's \(\leq\) sign to \(<\) without this argument would not.

The archived theorem, equation excerpt, BHV14 assumption, and background paragraph agree with these primary targets. This establishes citation/statement fidelity and the elementary rescaling implication, not a new Argus proof of BHV14.

## 4. BHV18: the two precise extra-divergence conditions

Theorem 18 fixes **any monotone \(f\)** with

\[
\lim_{Q\to\infty}f(Q)=+\infty.
\]

It then supplies an **explicitly constructible Liouville number \(\gamma=\gamma(f)\) depending only on \(f\)**. For this single shift, all nonnegative approximation functions \(\psi\) satisfying **either** of the following conditions have conclusion (76):

\[
\exists\varepsilon>0:\quad
\liminf_{Q\to\infty}\frac{1}{f(Q)}
\sum_{q\leq Q}
\frac{\psi(q)\varphi(q)}
{q\,\Log q\,(\Log\Log q)^{1+\varepsilon}}>0,
\tag{88}
\]

or

\[
\exists\varepsilon>0:\quad
\liminf_{Q\to\infty}\frac{1}{f(Q)}
\sum_{q\leq Q}
\frac{\psi(q)}
{\Log q\,(\Log\Log q)^{2+\varepsilon}}>0.
\tag{Theorem 18 alternative; S5.Ex59}
\]

In particular, the second condition has **no \(\varphi(q)/q\) factor** and its iterated-log power is **\(2+\varepsilon\)**, not \(1+\varepsilon\). These are positive **liminf** lower bounds relative to \(f(Q)\), not just an unnormalised divergent sum or a positive limsup. The existential \(\varepsilon\) is a witness for the relevant condition; the selected \(\gamma\) does not depend on \(\psi\) or that witness.

The conclusion is: for each such \(\psi\), for almost every \(x\in\mathbb R\), infinitely many \(q\in\mathbb N\) satisfy (76). Its order is

\[
\forall f\ [f\text{ monotone},\ f(Q)\to\infty]\quad
\exists\gamma(f)\text{ Liouville}\quad
\forall\psi\ [\text{(88) or its alternative}]
\quad\text{for almost every }x\in\mathbb R.
\]

The exceptional null set may depend on \(\psi\). This neither chooses a single full-measure set for all approximation functions nor allows replacing the existential shift with **an arbitrary prescribed irrational**, every Liouville number, or a shift independent of \(f\). The source and archived description explicitly distinguish independence from \(\psi\) from independence from \(f\).

If a strict weak inequality is wanted here too, replacing \(\psi\) by \(\psi/2\) divides either positive liminf by two and leaves the same \(f\)-dependent shift available. Removing \(E_\gamma\) gives the strict conclusion as above. No weakening to the bare hypothesis (52) follows from this rescaling.

Both displayed conditions, their quantifier order, explicit-constructibility assertion, and almost-everywhere domain match the archived Theorem 18 excerpt, citation record, and BHV18 assumption. The construction and proof of BHV's theorem itself were not independently reconstructed.

## 5. Dependencies, counting, and remaining gaps

1. **Supported scope:** two externally attributed propositions: the rational-shift theorem and the \(f\)-dependent existential Liouville-shift theorem with extra divergence. Their excerpt files, citation JSONs, ledger entries, and repetitions in the RFJ report are representations of these same two results. **Argus novelty credit: zero.**
2. **No RFJ premise:** `CTX_BHV_BACKGROUND@1`, the index's BHV14/BHV18 exclusion lists for `C_RFJ_QUANT@1`–`@5`, and the old report's explicit “not as a premise” statement agree. These citations are background comparisons, not analytic inputs or certificates for `C_RFJ_QUANT`. Their source fidelity neither verifies nor invalidates that separate draft.
3. **Concrete historical metadata gaps:** v1 does not register either external dependency; v2 registers BHV14 but not BHV18. Both still make the composite two-theorem statement. Preserve those historical states and the single hash-bound judgement; do not silently read v3's complete assumption list back into v1/v2. This report provides explicit source links for assessment without repairing any old ledger.
4. **No remaining statement-fidelity mismatch found in v3's stated scope.** No source-access gap remains: the exact primary targets were successfully read. This is not a blanket claim that BHV's proofs, the manuscript, or other Argus units have been verified.
5. **Unsupported enlargement:** proving the weak result for an arbitrary prescribed irrational from only (52) would require a distinct argument not present in this background unit. Neither theorem supplies it. That is a concrete missing implication if such an enlargement is attempted, not a defect found in BHV.
6. **Procedural gap:** the native Host-invoked independent Reviewer must judge this assessment, its source-read provenance, and family-wide coverage. `independent_review_required=true`; `independent_review_completed=false`. No family acceptance or completion is asserted.

Only this report and its sibling `verdict.json` are produced by this assessment; old inputs, snapshots, manifests, the active ledger, and wiki are unchanged.
