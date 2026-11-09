# Source readings for the nine descent inputs

On 2026-11-07, `reader:source-attribution-062` independently read the nine
propositions filed by `engineer:review062` in `C_REVIEW_DESCENT@10`
(`628dafda75cb1f727f1085d27b45cdc4abc85942f2691c21552b2cc4dc157fc0`).
These are source-attribution judgments, not verification that the geometric
argument satisfies the hypotheses, and not native independent Reviewer
acceptance.

1. **`A_NAGATA` — supports.** [Stacks, tag 035B](https://stacks.math.columbia.edu/tag/035B),
   Lemma 29.18.2(1): “Any scheme locally of finite type over a field”
   is among the schemes stated to be Nagata. Both the scheme and
   locally-finite-type-over-a-field qualifications match.
   Current evidence:
   [`citation-A_NAGATA-34486417d27e`](../../literature/9e811f89e51e427144a8ab2171eef3cc.json).

2. **`A_NORMALIZATION_FINITE` — supports.**
   [Stacks, tag 035S](https://stacks.math.columbia.edu/tag/035S),
   Lemma 29.55.11: “Let \(X\) be a Nagata scheme. The normalization
   \(\nu:X^\nu\to X\) is a finite morphism.”
   The complete primary theorem article was read; neither reducedness
   nor prior normality of \(X\) is an additional hypothesis.
   Current evidence:
   [`citation-A_NORMALIZATION_FINITE-2f54123a38a6`](../../literature/19023ff0e5559084d3bdae4777a576c4.json).

3. **`A_GOING_DOWN` — supports.**
   [Stacks, tag 00H8](https://stacks.math.columbia.edu/tag/00H8),
   Proposition 10.38.7: for an inclusion of domains \(R\subset S\),
   with \(R\) normal and \(S\) integral over \(R\), primes
   \(\mathfrak p\subset\mathfrak p'\) and any
   \(\mathfrak q'\) over \(\mathfrak p'\) admit
   \(\mathfrak q\subset\mathfrak q'\) over \(\mathfrak p\).
   This is exactly going down, not by itself the old argument's
   further height calculation.
   Current evidence:
   [`citation-A_GOING_DOWN-573b4b27b1ec`](../../literature/5b042ddfc0a3be82472adf84aa8d968c.json).

4. **`A_PURITY` — supports, with every stated hypothesis retained.**
   [Stacks, tag 0BMB](https://stacks.math.columbia.edu/tag/0BMB),
   Lemma 58.21.4, complete primary theorem article: \(f:X\to Y\) is
   a morphism of locally Noetherian schemes; at \(x\), with \(y=f(x)\),
   \(\mathcal O_{X,x}\) is normal, \(\mathcal O_{Y,y}\) regular,
   \(f\) quasi-finite, and
   \(\dim\mathcal O_{X,x}=\dim\mathcal O_{Y,y}\geq1\).
   It also requires unramifiedness at **every**
   \(x'\leadsto x\) with \(\dim\mathcal O_{X,x'}=1\).
   Then \(f\) is étale at \(x\). The specialization condition includes
   \(x'=x\) when the local dimension is one; “generization” must not
   mean only strict generization. The statement does not cover dimension
   zero or remove the scheme hypotheses.
   Current evidence:
   [`citation-A_PURITY-8523a6663474`](../../literature/2beddf26662a02044c892aab2f572d91.json).

5. **`A_FINITE_BIRATIONAL` — supports.**
   [Stacks, tag 0AB1](https://stacks.math.columbia.edu/tag/0AB1),
   Lemma 29.55.8: “A finite (or even integral) birational morphism”
   of integral schemes with normal target “is an isomorphism.”
   Both schemes must be integral; source normality is not required.
   Current evidence:
   [`citation-A_FINITE_BIRATIONAL-e0cd294ecc61`](../../literature/e1fc57ee37b849743edc09d1a52972e2.json).

6. **`A_AFFINE_FINITE` — supports.**
   [Stacks, section tag 01WG](https://stacks.math.columbia.edu/tag/01WG),
   specifically [01WM](https://stacks.math.columbia.edu/tag/01WM),
   Lemma 29.45.7, and [01WJ](https://stacks.math.columbia.edu/tag/01WJ),
   Lemma 29.45.4. For morphisms of schemes, integral is equivalent to
   “affine and universally closed”; “An integral morphism which is
   locally of finite type is finite.” Both constituent primary tags
   were opened, including the complete equivalence statement.
   Neither universal closedness nor local finite type can be dropped.
   Current evidence:
   [`citation-A_AFFINE_FINITE-417901764151`](../../literature/238d977f762430558a30b8550b7a0aa5.json).

7. **`A_P1_SPLITTING` — supports; pagination correction required.**
   Araujo–Kollár, *Rational Curves on Varieties*,
   [arXiv:math/0203173v2](https://arxiv.org/abs/math/0203173v2),
   §3, paragraph immediately before Definition 8, **printed p. 8**:
   “Every vector bundle on \(\mathbf P^1\) splits into a direct sum of
   line bundles.” This includes the recorded algebraic case over
   \(\mathbf C\). The supplied text, lines 326–327, and corresponding
   PDF passage were read. Both ledgers' p. 7 locator is inaccurate;
   the section and paragraph unambiguously identify the assertion.
   No assumption was silently edited.
   Current evidence:
   [`citation-A_P1_SPLITTING-2531a6b6a4eb`](../../literature/542f0ac474574e55dc8910186eaec5be.json).

8. **`A_HOM_SMOOTHNESS` — supports.** The same v2 source,
   Theorem 5(1)–(2), **printed p. 6**, supplied text lines 265–274:
   \(Y,X\) are schemes over a field \(k\), \(Y\) projective without
   embedded points, \(X\) smooth and quasi-projective, and \(f:Y\to X\)
   a morphism. The theorem identifies
   \(T_{[f]}\operatorname{Hom}(Y,X)\) with \(H^0(Y,f^*T_X)\);
   if \(H^1(Y,f^*T_X)=0\), Hom is smooth at \([f]\), of dimension
   \(h^0(Y,f^*T_X)\). The primary PDF statement was also read.
   These clauses alone are not a statement that evaluation is smooth.
   Current evidence:
   [`citation-A_HOM_SMOOTHNESS-8a88fb938713`](../../literature/b70a2ce19c7dbe3f1113dcd9a27875c7.json).

9. **`A_GAGA_H0` — supports despite a broken filed URL.**
   Serre, *Géométrie algébrique et géométrie analytique*,
   *Annales de l'Institut Fourier* **6** (1956), 1–42,
   DOI [10.5802/aif.59](https://doi.org/10.5802/aif.59),
   §12, Théorème 1, **printed p. 19** (PDF page 20).
   The preceding hypothesis makes \(X\) a closed subvariety of complex
   projective space. For every coherent algebraic sheaf \(\mathcal F\)
   and \(q\geq0\), the comparison
   \(H^q(X,\mathcal F)\to H^q(X^h,\mathcal F^h)\) is bijective.
   The following sentence explicitly specializes to \(q=0\).
   The original local PDF passage and text lines 788–800 were read;
   OCR corrupts some glyphs, not that explicit specialization.
   The filed `/article/AIF_1956__6__1_0/` URL returned **404**.
   The [canonical item record](https://numdam.org/item/AIF_1956__6__1_0/)
   was reached and identifies the same original article. Support does
   not assert that the broken URL works.
   Current evidence:
   [`citation-A_GAGA_H0-fb8903f5c158`](../../literature/0cdace06093e55ed3195b9e7e2eb75fe.json).

**Historical reconciliation.** The index's nine old `judgement-A_*`
records, by `reviewer:copilot-cb07e28d5d45`, were checked against the
read-only old ledger: each binds exactly the corresponding assumption
hash present in `C_DES_DESCENT@10`, and each says `supports`.
Their mathematical statements, source identifiers and locators also match
the current nine inputs. Thus the old `citation_status.json`'s nine
`unchecked` labels are a stored backlog, not evidence that these matching
judgments are absent or adverse. Their observation order is not established
by that undated status file. These old judgments are reused as qualified
historical assessments, not reissued under the old reviewer's identity.
The current filing changes assumption hashes through its provenance and
filer fields, so old evidence is not automatically current evidence.

**Retrieval and provenance limits.** All eight requested Stacks pages
(six inputs, with 01WG/01WM/01WJ for the combined input) were reached.
Their displayed numerical locators agree with those listed above; stable
tags, not mutable numbering, identify the content. The arXiv v2 metadata
was reached and gives the revision date 13 November 2002. The supplied
copy explicitly bears that v2 label but internally prints “May 28, 2018”;
no live-PDF byte comparison or explanation of that internal date is claimed.
The local PDFs/texts and the old excerpt compilation are supplementary
inputs without preserved-manifest digests, as the index records.

For each new attribution, the official citation module archived the
actually read and verified quotations from the old
`research/contact_value_descent/reviewer_source_excerpts.txt`
(under old workspace `9000062`; measured SHA-256
`bc770a8dde3e5cf7ee72a20c4cfbc09b031aec4a10b1cf2bf547dd68c66a9570`).
The compilation's old reader header and application paragraphs remain
historical text: only the relevant source passage is attributed here,
not the surrounding geometric application. The old ledger binds the
artifact path, not a historical digest of that supplementary file.
No whole paper was copied. All nine current official attributions are
`supports`, and the final citation status reports all nine `confirmed`
under `reader:source-attribution-062`. The pagination and broken-URL
corrections above are reported rather than silently rewriting assumptions.

## Current source-identity corrections — 2026-11-07

The nine attribution entries above are retained as historical records of
the inputs then filed in `C_REVIEW_DESCENT@10`. The parent has officially
retired **`A_P1_SPLITTING`**, whose filed printed-page locator was wrong,
and **`A_GAGA_H0`**, whose filed article URL was broken. Their unchanged
mathematical inputs are now filed by `engineer:review062` as
`A_P1_SPLITTING_P8` and `A_GAGA_H0_DOI` in `C_REVIEW_DESCENT@13`.
No mathematical dependency was dropped. Evidence for the retired
assumptions does **not** automatically transfer to these new identities.
The other seven attributions remain intact and were not rechecked here.

`reader:corrected-source-reader-062` independently read the following
two actual primary passages, not merely the preceding review or the
canonical record's abstract:

1. **`A_P1_SPLITTING_P8` — supports; official status `confirmed`.**
   Source identity **`arxiv:math/0203173v2`**, Araujo–Kollár,
   *Rational Curves on Varieties*, **§3, printed p. 8, paragraph
   immediately before Definition 8**. The supplied primary PDF's
   physical page 8 says: “Every vector bundle on \(\mathbf P^1\)
   splits into a direct sum of line bundles.” The section opening on
   printed p. 7 and matching supplied text were also read. This
   statement covers every finite-rank algebraic vector bundle on
   \(\mathbf P^1_{\mathbf C}\), with no positivity condition on the
   summand degrees. The surrounding deformation setup is not an
   extra hypothesis on this general bundle statement, nor is its
   geometric application assessed here.
   New official evidence:
   [`citation-A_P1_SPLITTING_P8-c36612d71262`](../../literature/891cc73de5585ec16bb204738425bc6d.json),
   bound to assumption hash
   `e1cd7bd1a92e4961c7ae26a3c0c7f1b5e97145a367756de5fa169c8b926b62a0`.

2. **`A_GAGA_H0_DOI` — supports; official status `confirmed`.**
   Source identity **`doi:10.5802/aif.59`**, Serre,
   *Géométrie algébrique et géométrie analytique*, AIF **6** (1956),
   1–42, **§12, Théorème 1, printed p. 19, \(q=0\)**.
   The actual supplied PDF's physical page 20 and matching text were
   read, including the preceding hypothesis: \(X\) is a Zariski-closed
   subvariety of complex projective space. For **every coherent
   algebraic sheaf** \(\mathcal F\) on \(X\) and **every integer
   \(q\geq0\)**, the canonical comparison
   \(H^q(X,\mathcal F)\to H^q(X^h,\mathcal F^h)\) is bijective.
   The next sentence explicitly specializes to \(q=0\), giving the
   isomorphism of global sections. Projectivity, the complex base
   field, and coherence are retained; no nonprojective or
   noncoherent extension is attributed.
   The reached [canonical Numdam item record](https://numdam.org/item/AIF_1956__6__1_0/)
   explicitly identifies this article and DOI, matching the supplied
   PDF title page. The DOI redirected to an AIF landing page that
   returned **403** in this reading; it was the accessible canonical
   Numdam record, not that denied page, which verified the DOI identity.
   This is distinct from the historically broken `/article/` URL.
   New official evidence:
   [`citation-A_GAGA_H0_DOI-3c58ca4b3b98`](../../literature/a8f4ac66263d12a19f3cde4174c46456.json),
   bound to assumption hash
   `7b0685fe43142a0e2fb5d50d09328e6fce1d39081ce4d776126cd092caa05cb5`.

**Verified excerpts and remaining provenance limits.** Both official
commands used the actual read-only
`9000062/research/contact_value_descent/reviewer_source_excerpts.txt`
compilation only after checking its relevant quotation against the
primary PDF and text at the corrected locator. The official archives
preserve that compilation; its historical reader header and application
paragraphs are not new attributions or endorsements. No old source or
ledger was edited. Neither supplied primary PDF, its text, nor this
supplementary compilation is preserved-manifest byte-authenticated.
The Araujo–Kollár PDF bears the v2 / 13 November 2002 label but internally
prints **May 28, 2018**; no explanation of that date or live-PDF hash
identity has been established. No live-PDF byte identity is asserted
for Serre either. These qualifications remain despite the corrected
source identities.

There is no remaining statement/locator mismatch in these two
attributions. These are new source-support judgments only: they neither
assess the descent geometry nor constitute native independent Reviewer
acceptance or an acceptance decision for the old-draft review.
