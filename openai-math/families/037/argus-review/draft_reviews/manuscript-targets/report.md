# Manuscript-target entries: scope and unsupported obligations

**Engineer disposition: the old draft supports a narrowly defined adjoint
step, not completion of its umbrella audit or the two manuscript theorems.**
The eleven manuscript-target propositions below are not established by the
listed Argus drafts. This is a coverage/scope assessment, not a judgement that
the propositions are false or an initiation of a new manuscript-wide audit.
No novelty is claimed; native independent review remains required.

## Sources, versions, and grouping

All twelve records in this unit have version 1 in the read-only
`9000037/research/MATH_STATE.json`; they are distinct from the versioned
GENERAL, POLYHEDRAL and FACET_KERNEL claims assigned to other units.
The old `research/PROOF_GRAPH.json` states dependencies but leaves all
seventeen nodes open and `reviewer_confirmed=false`.
The old adjoint report expressly excludes the companion fourfold theorem
and main normalized-volume theorem in its opening and dependency sections.
There is no separate Argus proof, formal source or computational certificate
for these target propositions among the 22 inventory artifacts.

They form one scope unit because their only old Argus artifacts are the shared
target ledger and graph. Counting eleven unproved target labels as eleven
finished mathematical drafts would invent results; silently omitting them
would lose coverage. Each receives its own exact statement and mathematical
obligation below and in `verdict.json`.

The reference bundle consists of two read-only symlinks to the OpenAI
September 24, 2026 preprints:

* *The ordinary-double-point gap in every dimension*.
* *The normalized-volume gap in dimension four*.

The supplied `9100037/MANUSCRIPTS.json` identifies source revision
`4eaee87548250b2682affda7d05d947c05554bae`. All eleven inventoried
TeX files of the first manuscript and the one TeX file of the second match
that manifest's hashes. The 15 accessible reference files are twelve TeX
sources, two bibliographic READMEs and one bibliography, not fifteen extra
Argus mathematical drafts. No `paper.pdf` is present in this bundle, despite
the README links; this does not obstruct assessment of the old Argus work.
The reference papers are attributed to OpenAI, not to the Argus worker.

Here `ODP/` and `Four/` denote their respective `build/` directories.
Source references identify the propositions the old ledger targets. They
are not a claim that those source arguments have now been independently
audited. The concrete gap is always between the supplied **Argus evidence**
and that proposition, not a manufactured flaw in an unreviewed paper.

## Per-entry dispositions

### C9000037@1: historical umbrella objective, not a theorem

The exact ledger text is reproduced in `verdict.json`. It asks either for
an explicit certified mathematical flaw/counterexample/fidelity gap, or for
independent verification, repair or generalization of the manuscript's core
theorem with a standalone machine-checkable certificate and Reviewer
certification. It also labels the manuscript Lean status UNFORMALIZED.

The old report instead proves/assesses the specific adjoint lifting and
saturation step, proposes stronger formulations, and formalizes its
conditional finite-facet arithmetic. The failed mixed-index attack supplies
no counterexample. These are substantive partial results, not a certificate
of either full volume-gap theorem. The `complete_solution` string in the
exact certificate must not enlarge its arithmetic or algebraic scope.
Historical Reviewer opinions about these narrow claims do not imply
acceptance of the present inventory-wide review.

### C_GAP_MAIN@1

> For every singular boundary-zero klt complex algebraic n-fold germ, n>=2,
> normalized volume is at most 2(n-1)^n, with equality exactly at the ordinary
> double point.

Source: `ODP/sections/01-introduction.tex`. The universal germ/dimension
quantifiers and the equality classification require the fourfold base case,
cone reduction, branch classification/interiority, filtrations and bootstrap
in the old graph. No such chain is certified by an integer halfspace theorem.
**Disposition:** not established by the listed Argus drafts; no correctness
verdict on the main manuscript theorem.

### C_GAP_CONE@1

> Under the induction and density hypotheses, stable degeneration gives a
> singular K-polystable Gorenstein cone with smooth puncture, preserving
> volume and controlling embedding dimension; primitive integral gradings
> approximate its minimizing Reeb ray.

Source: `ODP/sections/02-cone-reduction.tex`; the graph also depends on the
fourfold base. The missing Argus argument must establish the degeneration,
smooth puncture and Gorenstein conclusions, the volume/embedding-dimension
transfer, and the precise integral approximations. The lifting proof starts
with orbifold jet data; it does not construct these data from every germ.
**Disposition:** target only, not established here.

### C_GAP_SMALL@1

> The small-stabilizer branch is classified as projective space or a smooth
> quadric for sufficiently far gradings, including an exact rational grading.

Source: `ODP/sections/03-small-stabilizers.tex`, under the inherited fixed-cone
and grading setup. Computing one quadric's complete section semigroup cannot
exclude other orbifolds or prove the asserted eventual classification.
The branch inequalities and the rational-ray case need their own argument.
**Disposition:** target only, not established here.

### C_GAP_INTERIOR@1

> Under the fixed-cone density hypothesis and m>=r/N, the canonical vector
> (r,1,...,1) lies in the interior for sufficiently far gradings, or for the
> exact rational minimizing grading.

Source: `ODP/sections/04-jet-interiority.tex`. Exact lifting intentionally
does not assume this conclusion. Saturation does assume it. Therefore
neither may be used circularly to supply it. The unreviewed task is to
derive strict canonical support inequalities from the stated density and
stabilizer assumptions, including the rational-ray case.
**Disposition:** target only, not established here.

### C_GAP_FILTRATIONS@1

> The saturated Taylor semigroup gives the normal Gorenstein first
> degeneration and the second filtration and stabilizer data required by the
> bootstrap.

Source: `ODP/sections/06-filtrations.tex`; graph inputs are saturation and
canonical interiority. Even with the conditional semigroup identities
supported, one still needs the actual geometric/filtered-algebra
construction, its required flatness/finite-generation properties, and the
second filtration's stabilizer and character data. The Lean predicate Gamma
does not encode a section ring, a Rees algebra or either degeneration.
**Disposition:** target only; the narrower semigroup input is assessed
elsewhere, not this entire consequence.

### C_GAP_BOOTSTRAP@1

> The second-stabilizer and character-length bootstrap yields the
> higher-dimensional bound and identifies its equality cone;
> embedding-dimension control transfers equality to the original germ.

Sources: `ODP/sections/07-bootstrap.tex` and `08-conclusion.tex`.
One needs the numerical second-stabilizer/character-length inequalities,
their equality analysis and the transfer back to the original singularity.
None is an integer-shift equivalence or a Taylor-prefix rank computation.
**Disposition:** target only, not established here.

### C_FOURFOLD_MAIN@1

> For every singular boundary-zero klt normal complex algebraic fourfold germ
> with Q-Cartier canonical class, normalized volume is at most 162, with
> equality exactly at the ordinary double point.

Source: `Four/paper.tex`. All four following fourfold subclaims are open
targets in the historical graph, not lemmas proved by the adjoint draft.
The germ-level bound and equality classification require that entire chain.
**Disposition:** target only, not established here.

### C_FOURFOLD_CONE@1

> At volume at least 162 stable degeneration gives a Gorenstein fourfold cone
> with smooth puncture, embedding-dimension control, and primitive divisors at
> the vertex of discrepancy at least three.

Source: `Four/paper.tex`. The missing Argus proof is the threshold-dependent
cone reduction and its discrepancy/embedding-dimension conclusions. The
explicit smooth projective quadric is not a construction for every germ
meeting the volume threshold.
**Disposition:** target only, not established here.

### C_FOURFOLD_SHORT@1

> With canonical weight 5/2 the Hilbert-series argument gives a nonzero
> homogeneous function of weight between zero and 5/3, also on the required
> low-dimensional graded centers.

Source: `Four/paper.tex`, under its cone/center hypotheses. The old quadric
Hilbert series only describes that particular graded ring. It cannot provide
uniform short-weight nonvanishing for every cone or its graded centers;
both the open weight interval and the center cases need a separate proof.
**Disposition:** target only, not established here.

### C_FOURFOLD_THRESHOLD@1

> Short-weight nonvanishing and affine subadjunction imply
> lct_o(C;m_o)>3/2.

Source: `Four/paper.tex`. The missing Argus implication must control the
relevant log discrepancies/vanishing orders and prove the **strict**
threshold via subadjunction; no lct or valuation infimum is encoded by
`Main.lean` or the Taylor coefficient matrix.
**Disposition:** target only, not established here.

### C_FOURFOLD_SECTION@1

> A general hyperplane section is a terminal Gorenstein threefold, giving
> embedding dimension at most five, after which the known lci gap theorem
> applies.

Source: `Four/paper.tex`. One must justify general-section terminality and
Gorensteinness, the embedding-dimension bound, and the precise applicability
and equality information of the invoked lci gap result. These are not
conclusions of the old section-lifting argument. The external lci theorem
is mentioned as an unreviewed target dependency, not used as a proved input
of this review, so no unchecked new theorem citation is adopted.
**Disposition:** target only, not established here.

## Dependency and attribution limits

The old ledger's `R_AJL_GENERAL` points to the common statement hash of
GENERAL versions 1-4, not the strengthened version 5. Its `R_AJL_SAT`
points to POLYHEDRAL and FACET_KERNEL version 1 hashes, not their later
version 2 hashes. The final report and later historical judgements do bind
the strongest versions. This review explicitly reads those strongest
formulations instead of treating old versionless graph edges as automatic
version upgrades. The old ledger and graph are not repaired or rewritten.

`R_GAP_MAIN` and `R_FOURFOLD_MAIN` are decompositions, not evidence that
their obligations are discharged. The source-manuscript claims are not
adopted as assumptions to manufacture a proof of themselves. Conversely
the rejection of `R_AJL_QUADRIC_MIXED` is a failure of an Argus attack, not
a refutation of an original manuscript.

The index assigns every target version to this unit and each substantive
adjoint argument to its own unit. Coverage of the eleven mathematical
targets is complete as a scope disposition; their independent mathematical
verification remains outside the authorized old-draft review. That is a
specific evidence gap for each target, not a run failure or an access-based
claim of unresolved mathematics.
