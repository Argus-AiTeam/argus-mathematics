# Failed shortcuts: Milne §5.21 and Kisin Proposition 1.4.15

## Assessment and scope

**The two graph-only citation shortcuts are invalid as proofs of the
prescribed, fixed-marking realization assertion.** This assessment follows
from the supplied primary texts, not from their historical `refuted` labels.
It rejects Argus proof shortcuts; it does **not** refute Milne's proposed
strategy, Kisin's actual proposition, or the manuscript's realization lemma.

There is an important version qualification: the available Milne text is
**v2.4, October 9, 2026**, not the **v2.2, November 2, 2025** named in the
manuscript bibliography and in the old graph claim. This review does not
pretend to have inspected v2.2.

This is an **Engineer contribution**, with
`independent_review = pending_native_reviewer` and
`novelty_status = not_claimed`. Its contribution type is source criticism and
rejection of unsuccessful Argus inference routes, not an original geometric
theorem or a manuscript counterexample.

Line numbers are one-based in the immutable historical root
`campaigns/9000001`.
Write **A** for `research/prescribed-filtration-audit` and **M** for
`research/openai_manuscript/Milnes-rationality-conjecture-for-abelian-varieties-October-7-2026/build`.
Only the assigned extracts, old source discussion, and relevant manuscript
context were used. Native skill descriptions were considered before source
exploration; no source-specific skill fit the existing-text task. No agents,
external research, Git, wiki edits, or new manuscript-error search were used.

## 1. F001_MILNE_521_LIFTING_CITATION

### Exact old assertion and source identity

The graph-only claim in `research/PROOF_GRAPH.json:330–338` says:

> “Section 5.21 of Milne's SVp.pdf (v2.2, cited in OpenAI Family 001)
> proves the required lifting theorem with additional Hodge structure
> needed for lem:admissible-realization.”

It has no separate claim version in the old ledger. The old draft's
correction is `A/realization_proof.md:25–49`.

The supplied `A/sources/SVp.txt:1–5` identifies J. S. Milne,
*Abelian motives and Shimura varieties in nonzero characteristic*:

> “October 9, 2026, v2.4; added two sections on AI.” (`5`)

The preserved HTTP receipt `SVp.headers.txt:1–6` includes:

> “last-modified: Fri, 09 Oct 2026 19:28:01 GMT” (`2`)

and a response date of November 5, 2026 (`6`). These are historical retrieval
metadata, not a new check of the live URL or mathematical evidence.
`M/references.tex:220–224`, by contrast, says:

> “preprint, version~2.2, 2 November 2025.” (`223`, TeX retained)

The version discrepancy is real. A mutable `SVp.pdf` URL does not make the
retrieved v2.4 into the v2.2 named there. Statements below, particularly
§12, belong to v2.4; there is no retroactive assignment to v2.2.

### What §5.21 actually supplies

The immediate setup is `SVp.txt:3508–3513`, printed p.52: abelian motives
with visibly good reduction, and statement 5.20 for an abelian variety
\(A/\overline{\mathbf Q}\) with good reduction at \(w\), asserting that
Hodge classes specialize to rational Tate classes. Under **“First approach”**,
§5.21 says:

> “As in §6 of Deligne 1982, embed \((A,\gamma)\) in a family of abelian
> varieties with additional structure over \(\mathbf C\). In particular,
> \(\gamma\) extends to a global section of the family.” (`3516–3517`;
> mathematical symbols rendered)

The decisive continuation is:

> “Complete the proof by showing that \(A_0\) lifts to a CM abelian variety
> in the family (this seems to be more general than known, or even
> conjectured, results).” (`3518–3520`)

This explicitly leaves a mathematical task open. The missing task is not
merely lifting the underlying abelian variety somewhere: it is obtaining a
CM lift **inside the family carrying the additional structure and the
extended Hodge tensor**. Neither an arbitrary CM lift nor a lift preserving
only divisors proves that statement.

There is no prescribed-filtration assertion, integral tensor-frame
construction, exact crystalline marking, or theorem covering \(p=2\) in
this paragraph. No such prime extension may be read into it. The next
“Second approach” refers to Theorem 6.19 **“under some hypotheses”**
(`3522–3523`); that reference does not turn the unfinished first approach
into an unconditional extra-Hodge lifting theorem. This review does not
investigate or reject Theorem 6.19.

**Conclusion:** the actual retrieved passage contradicts using §5.21 as a
completed proof of the required extra-structure lifting statement. The
Argus citation inference is rejected. A stronger textual claim about the
exact wording or numbering of the unavailable v2.2 is not certified here.
The known version mismatch is reported rather than silently repaired.

### §12 is relevant prior discussion, not independent realization verification

The actual section begins at `SVp.txt:5271–5276`, not at the start of the
file named `SVp-section12.txt`. It explicitly names:

> “Milne's rationality conjecture for abelian varieties, September 23, 2026.”

Thus its labels **AI 5.2**, **AI §6**, and **AI 3.4** are September-23
manuscript labels; they cannot be silently assigned to the October-7
`lem:admissible-realization` or its current numbering.

For provenance and attribution:

* §12.1, `5282–5288`, takes a Weil triple with good reduction and describes
  the orthogonal-versus-Lefschetz dichotomy as a “new and interesting idea.”
* §12.2, `5289–5297`, says the Weil-to-CM reduction is “not new” and
  attributes its ingredients to Deligne/André and Milne. These comments
  are antecedent/source attribution, not an Argus novelty determination.
* §12.3, `5298–5315`, says “this should be proved by lifting”
  (`5301`), then **“OpenAI claims the following statement”**: for
  \(A/\overline{\mathbf Q}\) with good reduction at \(w\) and an absolute
  Hodge class \(\gamma\), transport through a power to a CM abelian variety
  carrying an absolute Hodge class (`5302–5307`). It explains that this
  claimed statement would imply 12.3 using 2.5; it does not prove the
  transport assertion there.
* It adds: “I don't know how original OpenAI's claim is (cf. 5.21)”
  (`5309`) and “seems more general than anything I've seen, but I'm not
  an expert” (`5314–5315`).
* The conclusion begins **“If OpenAI's proof of the rationality conjecture
  is correct”** (`5322–5325`), and asks for verification of AI 5.2
  (`5316–5319`).

These are not an independent check of finite descent, the chosen integral
tensors, the exact quasi-isogeny, or the \(p=2\) realization argument.
They neither accept nor refute the later realization lemma.

`SVp-section12.txt:48–111` repeats `SVp.txt:5271–5334`; it is not an
additional witness or result. Its lines `1–46` are the tail of the preceding
conversation, before the §12 heading at `48`. They must not be attributed
to §12's mathematical commentary. In particular, this review does not use
that preceding chatbot conversation as an external theorem.

## 2. F001_KISIN_SEPARATE_ISOGENY_SHORTCUT

### Exact old assertion and original hypotheses

The graph-only assertion, `research/PROOF_GRAPH.json:340–348`, is:

> “Kisin (2017) Proposition 1.4.15 alone suffices to establish
> lem:admissible-realization without proving that a single fixed-marking
> algebraic quasi-isogeny simultaneously realizes the prescribed crystalline
> filtration and preserves all prime-to-p structure tensors.”

The old draft's correction appears at `A/realization_proof.md:100–105`.
The source is Mark Kisin, *Mod \(p\) points on Shimura varieties of abelian
type*, the preserved author-version `A/sources/Kisin-2017.txt`.
`M/references.tex:106–110` attributes it to *J. Amer. Math. Soc.*
**30** (2017), no.3, 819–914 and explicitly uses the author version `lr.pdf`
for locators. Proposition (1.4.15) is on **printed author-version p.28**,
not asserted to be journal p.28.

Its inherited setting is important:

* §1.1 says “In this section we assume that \(p>2\)”
  (`Kisin-2017.txt:261–262`); the footnote says this is “likely to soon be
  unnecessary” (`264–266`), not that it has been removed.
* The introduction's main Theorem (0.3) explicitly assumes \(p>2\)
  (`125`).
* For the remainder of §1.3, there is a Hodge-type embedding
  \((G,X)\hookrightarrow(\mathrm{GSp},S^\pm)\) (`1002–1003`), and
  \(K_p\) is **hyperspecial**, from a reductive model
  (`1004–1007`); the prime-to-\(p\) level is sufficiently small
  (`977–979`).
* §1.4 continues this notation (`1183–1189`). Definition (1.4.14) calls
  the image of the isogeny-class map the isogeny class, and includes the
  weak polarization and the prime-to-\(p\) tensor/level data
  (`1481–1488`).

Although Proposition (1.4.15) does not repeat \(p>2\) in its first line,
its proof invokes (1.1.19) (`1513–1514`) and belongs to this original
framework. It is not a standalone theorem here for general parahoric
level or a source for a \(p=2\) extension.

### Actual proposition and the quantifier mismatch

Proposition (1.4.15), `Kisin-2017.txt:1492–1495`, states:

> “Let \(x,x'\in\mathcal S_{K_p}(G,X)(\overline{\mathbf F}_p)\).
> Then \(x,x'\) lie in the same isogeny class if and only if there is a
> quasi-isogeny \(A_x\to A_{x'}\) respecting weak polarizations such that
> the induced maps \(D(\mathcal G_x)\to D(\mathcal G_{x'})\) and
> \(\widehat V^p(A_x)_{\mathbf Q}\to\widehat V^p(A_{x'})_{\mathbf Q}\)
> take \(s_{\alpha,0,x}\) to \(s_{\alpha,0,x'}\), and
> \((s_{\alpha,\ell,x})_{\ell\ne p}\) to
> \((s_{\alpha,\ell,x'})_{\ell\ne p}\) respectively.”

The quote renders the extracted notation and rejoins the line-broken word
“polarizations.” It asserts the existence of **one simultaneously
tensor-preserving quasi-isogeny**, not merely separate local maps.
That is genuine, useful support for an isogeny-class characterization.

It does **not**, however, take a previously chosen crystalline marking
as an input and assert that this precise marking is induced by its
existential quasi-isogeny. Nor does it mention a prescribed Hodge
filtration or lift.

The missing implication is substantive. Suppose an actual quasi-isogeny
\(b_0:C_x\to C_y\) already satisfies
\(b_0^*\operatorname{Fil}_y=\mathcal F\). If the proposition provides
another map \(b_1\) preserving the tensor families, write
\(u=b_0^{-1}b_1\), a self-quasi-isogeny of \(C_x\). Then
\[
 b_1^*\operatorname{Fil}_y=u^*\mathcal F.
\]
Preserving defining crystalline tensors does not imply stabilizing a
particular flag \(\mathcal F\). The proposition says neither
\(u^*\mathcal F=\mathcal F\) nor \(b_{1,\rm cris}=b_{0,\rm cris}\).
If the initial marking was only an isocrystal isomorphism, rather than an
algebraic \(b_0\), even its algebraicity remains an extra obligation.

The proof itself adjusts endpoints within their isogeny classes to
arrange prime-to-\(p\) compatibility (`1506–1508`, `1516–1518`).
It is a proof of the existential characterization, not a statement that
such adjustments preserve an independently specified period marking.

The manuscript target is stronger in exactly this respect:
`M/sections/02_transport.tex:323–327` defines the tensor isogeny class using
a single **actual** quasi-isogeny, and `330–348` additionally requires
that its actual crystalline pullback produce the prescribed filtration.
The proof explicitly discusses identity of these markings in `545–557`.
Whether the separate geometric construction justifies those sentences
belongs to the `realization` unit and is not decided by this source review.

**Conclusion:** Kisin (1.4.15) alone is insufficient for the graph claim,
even in its original odd-prime hyperspecial setting. No implication for
\(p=2\) follows by assertion. This does not deny Kisin's proposition or
prove that a compatible fixed marking cannot be constructed using further
geometry.

## Supported scope, remaining obligations, and historical opinions

The supported result of this unit is a **refutation of the two proposed
Argus citation inferences**, with a version qualification for the literal
v2.2 attribution. These are failed shortcuts, not counterexamples to the
original manuscript. No new manuscript error, global correct-proof claim,
or novelty claim follows.

Concrete obligations for anyone using these routes remain:

1. For the Milne citation: use a verified version and actually prove a lift
   in the family preserving the added Hodge structure; a proposed step or
   the conditional §12 commentary is not that proof. The exact v2.2 text
   has not been supplied/checked here.
2. For the Kisin citation: check the original hypotheses and supply an
   argument identifying the **same algebraic quasi-isogeny's crystalline
   marking**, with the prescribed filtration and all the prime-to-\(p\)
   tensors. A \(p=2\) version needs separate applicable input, not a
   speculative footnote.
3. Rational admissibility from CF is distinct from integral tensor control.
   The arbitrary-stable-lattice route is treated by
   `research/draft_reviews/lattice-obstruction/report.md`; its calculation
   is intentionally not repeated here. See also the `weak-admissibility`
   unit for exactly what CF does establish.

The graph's `status: refuted` and `reviewer_confirmed: true`
(`PROOF_GRAPH.json:332–335`, `342–345`) are preserved **prior opinions**,
not independent acceptance of this report. The old source discussion is
also evidence to review, not an authority that decides its own correctness.
The claimed “improvement” in `realization_proof.md:47–49` is not a novelty
assessment supplied by this unit. Native independent review remains pending.
