# Raynaud, SGA1 XII: primary-source scope

Source-reading note only; no campaign geometric proof or independent manuscript review.
Accessed 2026-11-05. Quotations normalize mathematical typography and line breaks.

## Identity, exact accessed edition, and numbering

- Original work ID: `doi:10.1007/BFb0058667`, SGA1, LNM 224 (1971).
- Original work URL: https://doi.org/10.1007/BFb0058667
- **Accessed source ID:** `arXiv:math/0206203v2`, dated **4 January 2004**.
- Version record: https://arxiv.org/abs/math/0206203v2
- Actual PDF: https://arxiv.org/pdf/math/0206203v2
- Saved PDF/text: `sga1_math0206203v2.pdf`,
  `sga1_math0206203v2.txt`.
- This is the **recomposed and annotated SMF edition**, not a scan of the
  1971 Springer printing. Its preface, PDF pp. 3–4 (printed pp. v–vi),
  describes the edition as slightly corrected, explains the Michel Raynaud
  updates, and says original page numbers are retained in the margins.
  The 1971 printing itself was not inspected; no identity of its wording
  with the accessed edition is asserted.
- Exposé XII opens on revised p. 239, PDF p. 255. Its heading credits
  “Mme M. Raynaud”, with the footnote “D'après des notes inédites de
  A. Grothendieck.” The author is Michèle Raynaud, not the Michel Raynaud
  responsible for the later updating remarks.
- **Numbering verified in the accessed PDF:** Corollary 4.3 and Theorem
  4.4 both begin on revised p. **249**, PDF p. **265**, after the
  original-pagination margin marker **329**:
  https://arxiv.org/pdf/math/0206203v2#page=265
  The proof of 4.4 continues on revised p. 250, PDF p. 266.

## Corollary 4.3

**Brief exact excerpt:** “Soient \(X\) un \(\mathbb C\)-schéma propre,
\(F\) un \(\mathcal O_X\)-Module cohérent.”

**Faithful paraphrase, revised p. 249:** For every integer \(p\geq0\), the
canonical comparison
\[
H^p(X,F)\longrightarrow H^p(X^{an},F^{an})
\]
is an isomorphism. The scan confirms **\(p\geq0\)**, including global
sections; the text extraction can misread the inequality. This is a
cohomology comparison, not by itself a theorem algebraizing a family.

## Theorem 4.4

**Brief exact excerpt:** “Soit \(X\) un \(\mathbb C\)-schéma propre.”
The theorem concludes that the coherent-module analytification functor
“est une équivalence de catégories.”

**Faithful paraphrase, revised pp. 249–250:** The functor
\[
\operatorname{Coh}(X)\longrightarrow\operatorname{Coh}(X^{an}),
\qquad F\longmapsto F^{an},
\]
is an equivalence for a proper complex scheme \(X\). The proof separately
establishes full faithfulness and essential surjectivity. No reducedness,
smoothness, flatness, or projectivity assumption on \(X\) is added.
Projective schemes are included as a special case.

## Nonreduced fibers and line bundles

**Faithful supporting-source paraphrases:** XII.1.1, revised
pp. 239–240, PDF pp. 255–256, constructs analytification for arbitrary
complex schemes locally of finite type. It explicitly treats closed
subschemes through their coherent ideals and the corresponding quotient
structure sheaves. It gives the local-ring completion isomorphisms and
flatness of the analytification map. XII.1.2, p. 241, PDF p. 257, says
analytification commutes with fiber products; XII.1.3.1, pp. 241–242,
PDF pp. 257–258, records exactness, faithfulness, and conservativity.

**Deduction, not verbatim 4.4:** For a possibly nonreduced projective
scheme fiber \(X_t\), 4.4 applies to \(X_t\) itself, not just
\((X_t)_{\mathrm{red}}\). Every coherent analytic sheaf on \(X_t^{an}\)
therefore algebraizes, and the usual faithfully flat local test for finite
presentation and rank-one local freeness identifies analytic line bundles
with algebraic line bundles on the **whole scheme fiber**. Replacing the
fiber by its reduction is neither required nor justified by this citation.

## Analytic-family algebraization: exact limitation

**What these numbered results do not state:** Neither XII.4.3 nor XII.4.4
asserts that an arbitrary proper analytic family over a projective curve
is algebraizable. In 4.4, the proper algebraic scheme \(X\) is an input.
Even XII.4.2, revised p. 248, PDF p. 264, is a relative comparison theorem
for an **already algebraic** proper morphism of complex schemes.

**Conditional deduction available to the parent:** If a projective
analytic family has already been placed as a closed analytic subspace
of the analytification of a proper algebraic projective-bundle ambient
space over the curve, 4.4 applies to its coherent ideal there; full
faithfulness algebraizes the ideal inclusion and its algebra structure.
A projective bundle originally formed from a holomorphic vector bundle
on the proper algebraic curve can likewise be treated by 4.4 on the
curve and descent of local freeness. These are deductions using a
specified global projective presentation, not an unconditional
proper-family existence assertion, and not a claim that mere local
projectivity supplies that presentation.

The source itself, at the beginning of XII §4, revised p. 247,
PDF p. 263, distinguishes its results from more general theorems about
proper relative schemes over an analytic space. No unexamined theorem
from that further reference is being substituted here.

Visual verification: `sga1_math0206203v2_p265.png`.
Access limitation: only the explicitly identified revised edition was read;
the original 1971 Springer printing was not independently obtained.
