# Ordinary-klt and valuation inputs: all ten historical versions

**Assessment:** these are known external results, not original Argus
proofs. The corrected v10 package has applicable prior independent
source-reading evidence with the necessary field, boundary and
smooth-model restrictions. v9 contains a normalization transcription
that must not inherit support for the corrected assumption.

## Exact claim and version reconciliation

`L_LC_ORDINARY` says that ordinary effective rational klt
normalized-volume minimization has existence, quasi-monomiality,
uniqueness up to rescaling and finite generation; bare klt germs have
log Izumi and properness; and monomial retraction/discrepancy formulas
hold on a smooth adapted model. It explicitly calls these external
inputs. Its natural-statement hash
`5bc4b8aec257604ee851b12613a5213bcc6c7c63c141bc9f82b5f04178e76d70`
is the same in v1-v10, but its dependency records are **not** identical.

| Version | Change and assessment |
|---|---|
| v1 | Natural package asserted without recorded external assumptions; not a self-contained proof. |
| v2 | Adds `A_JM_RETRACTION`. |
| v3 | Adds `A_LI_IZUMI`. |
| v4 | Adds `A_LI_PROPERNESS`. |
| v5 | Adds `A_BLUM_EXISTENCE`. |
| v6 | Adds `A_XU_QM`. |
| v7 | Adds `A_XZ_UNIQUE`. |
| v8 | Adds `A_XZ_FG`. |
| v9 | Adds `A_VOLUME_LIMIT`, but writes dimension `n` and “length/n^n” without a separate filtration parameter. This is not the correctly stated normalization. |
| v10 | Replaces that assumption text by `length(R/I_m)/m^n`; all eight assumption IDs remain. |

For v9 the volume-assumption hash is
`d4a688ac5824dff4a08043624afb90f20c104569a352997461d2d1e9ec4ca259`;
for v10 it is
`0d5a6393b29adeaaf1da7cee136d93a39cce8541fae255c95ef5f2e60e22d6a0`.
The prior supporting assumption judgment cites **only the latter**.
The unchanged parent claim hash does not erase this distinction.
There is no recorded retirement of assumptions in the old ledger.

If `n` in v9 is read literally as the fixed ring dimension, the
normalization is wrong: in `R=C[t]_(t)`, dimension one and
`I_m=(t^m)`, the length is `m`, not a quantity with a finite limit
after division by `1^1`. Division by `m^1` gives the correct limit.
This identifies a historical ledger transcription/variable collision,
not a flaw in Cutkosky or either manuscript. The proof note itself
uses the correct filtration-index normalization. v10 is the operative
corrected assumption.

## Proposition-level attribution and applicable hypotheses

The source below is the preserved independent reading
`reviewer_primary_excerpts.md`, by `reviewer:dccb8f343ba8`, read
2026-11-06, SHA-256
`150cb183455495cae54819eeebdc67d8a86009745ffe79303bb79e1358bab2bf`.
The exact historical assumption hashes, source IDs, locators and
version ranges are mapped in the coverage index.

| Input | Exact primary reference | Scope actually usable here |
|---|---|---|
| Retraction/discrepancy | Jonsson--Mustata, *Valuations and asymptotic invariants for sequences of ideals*, DOI `10.5802/aif.2746`, Lemma 4.7, Corollary 4.8, Proposition 5.1, Corollary 5.4 | Retraction decreases regular-function values and discrepancy; resolved monomial orders are preserved; discrepancy is linear on cones and obeys birational transformation. The paper's regular ambient setting is used on the smooth resolution, not by calling the singular germ regular. |
| Log Izumi | Li, *Minimizing normalized volumes of valuations*, `arxiv:1511.08164v4`, Theorem 3.1 | On a fixed complex Q-Gorenstein klt germ, finite bare discrepancy and centering give `v(m)*ord_m <= v <= C*A_X(v)*ord_m`. |
| Properness | Same version, Theorem 1.1 and Corollary 4.3 | `A_X(v)^n*vol(v)>=c*A_X(v)/v(m)` for the bare germ. It does not authorize replacing `A_X` by an arbitrary signed discrepancy. |
| Existence | Blum, *Existence of valuations with smallest normalized volume*, `arxiv:1606.08894v3`, Main Theorem and Section 7.3 | Existence for the effective rational klt pairs over the uncountable algebraically closed characteristic-zero field used here, namely `C`; Section 7.3 supplies the pair extension. |
| Quasi-monomiality | Xu, *A minimizing valuation is quasi-monomial*, `arxiv:1907.01114v2`, Theorem 1.2 | Every actual ordinary normalized-volume minimizer of a klt singularity, in the algebraically closed characteristic-zero setting, is quasi-monomial. This does not identify an unrelated constrained minimizer. |
| Uniqueness | Xu--Zhuang, *Uniqueness of the minimizer of the normalized volume function*, `arxiv:2005.08303v1`, Theorem 1.1 | Uniqueness up to positive scaling for the ordinary effective-boundary klt minimizer. Constrained uniqueness requires the exact realization first. |
| Finite generation | Xu--Zhuang, *Stable degenerations of singularities*, `arxiv:2205.10915v2`, Theorems 1.1-1.2 and the opening of Section 2 | For a normal affine effective rational klt pair and its actual ordinary minimizer, the associated graded is finitely generated and gives the stated stable degeneration. It is not a theorem that limits of finitely generated valuations remain finitely generated. |
| Volume limit | Cutkosky, *Asymptotic multiplicities of graded families of ideals and linear series*, `arxiv:1508.01938v1`, Theorem 1.1 (= Theorem 5.5) | For a Noetherian local ring of dimension `d`, the normalized length limit for every graded family of maximal-ideal-primary ideals exists under `dim N(R-hat)<d`. In this application excellent normal local rings have reduced completion; integer and real thresholds are squeezed. |

The old note records six accessible primary PDFs and Cutkosky's HTML.
Its source reader is distinguished from the later independent Reviewer;
the preserved excerpt file records the latter's own reading. This
round reuses that specific, unchanged independent evidence rather than
claiming a new primary-source retrieval or repeating a literature search.

The construction units additionally assume a fixed characteristic-zero
log resolution/principalization and sufficiently general transverse
members for finitely many strata. Those standard geometric setup
inputs are not among the eight explicit old assumptions, are not
Lean results, and have no newly retrieved primary attribution in this
review. Their use is exposed rather than hidden in the scalar certificate.

## What the old judgments do and do not establish

Each corrected assumption has a `supports` judgment from
`reviewer:dccb8f343ba8` tied to its exact assumption hash and the
preserved excerpt file. The package also has
`judgement-L_LC_ORDINARY-6b060a9bbf84`. These are applicable human
reading evidence for the propositions above and their stated use.
They do not give independent novelty or prove the external theorems
inside this project.

The old ledger classifies these as `judgement`, not `literature`
attribution records. The old proof explicitly says official
`citation_check attribute` records are still outstanding because that
command automatically archives outside its permitted write paths.
This review neither edits the old ledger nor fabricates that formal
status. Current scope assumptions cite the actual unpublished archival
reading as their source; the original canonical paper citations and
their outstanding metadata remain visible here and in the index.

No new mathematical proof is being delivered that replaces these
external assumptions. The review conclusion is that the cited package
is applicable evidence under the displayed restrictions, with v9's
transcription superseded by v10. Formal citation-bookkeeping completion
is distinct from substantive source-reading evidence and from the
native Reviewer's acceptance of this coverage review.

## Open status and novelty

These are known results, not open claims of novelty. v1-v8 have an
incompletely recorded dependency inventory, not demonstrated false
mathematics. v9's volume-assumption wording is malformed literally and
is not supported by the corrected excerpt. v10 states the intended
input correctly. No supported conclusion here extends the old route
to signed boundaries, arbitrary base fields without reduction, or
irrational-height finite-generation assertions.
