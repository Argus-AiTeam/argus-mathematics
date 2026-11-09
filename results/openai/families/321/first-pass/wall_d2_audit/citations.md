# Primary-source applicability

The independent source reader `reader:primary-source-reader` read the staged
bibliography and its uses, then returned the judgments summarized below.
This was **citation reading, not the Host mathematical review**. The Engineer
subsequently retrieved the core sources at the supplied primary URLs and
checked the precise passages needed for the report. The local PDFs, relevant
text extractions, and image-only source pages are in `literature/`.
Search-generated summaries were not used as proposition evidence.

## Actual theorem uses

| Manuscript reference and locator | Source and primary-reader judgment | Applicability and limitation |
|---|---|---|
| Mannan09, Section 2 | [Published PDF](https://msp.org/agt/2009/9-3/agt-v9-n3-p06-s.pdf), DOI `10.2140/agt.2009.9.1399`; pp. 1401-1402, Lemmas 2.3-2.4, Corollary 2.5. **Supports.** | The kernel is perfect and *finitely normally generated*. The source treats finite presentation complexes, constructs finitely many two- and three-cells, and preserves all quotient-module homology. The report proves the arbitrary finite two-complex version directly. Mannan uses right cellular modules and left homology coefficients; the report supplies its own consistent opposite-sided convention. |
| Mannan09, Theorem 3.4 | Same source, p. 1406. **Supports.** | A finite connected three-complex with vanishing third cohomology for every coefficient bundle is homotopy equivalent to a plus construction of a finite presentation complex with a perfect finitely closed kernel. This converse is background, not used to construct the present example. |
| Howie81Pairs | [Original scan](https://gdz.sub.uni-goettingen.de/download/pdf/PPN243919689_0324/LOG_0010.pdf), DOI `10.1515/crll.1981.324.165`; Lemmas 3.1-3.2, pp. 170-171. **Supports the cited method, not the twisted lemma.** | Lemma 3.1 assumes a combinatorial map from a finite connected CW complex, with the allowed inclusion class containing finite connected subcomplexes. Lemma 3.2 concerns constant abelian-group coefficients and top-dimensional relative homology. The report proves its simplicial, possibly degenerate-map maximality and local-system preservation separately. |
| LouderWilton17, Section 3 | [Published PDF](https://www.cambridge.org/core/services/aop-cambridge-core/content/view/115BB5D868671F72D653D58E516958D8/S0008439500023158a.pdf/stackings-and-the-w-cycles-conjecture.pdf), DOI `10.4153/CMB-2016-078-3`; Definition 3.1 p. 609, Lemma 3.2 p. 610. **Supports.** | Towers are finite compositions of subcomplex inclusions and covers, with normal infinite cyclic covers in the cyclic version. The lemma gives a maximal lift of a cellular map of compact complexes. It does not assert the manuscript's twisted homology preservation. The correct preprint is `arxiv:1410.2540v1`, Lemma 14; a search response's `arxiv:1405.6572` was an unrelated paper and was rejected. This discovery error is not an error in the manuscript bibliography. |
| BridsonTweedale07, Proposition 3.3 and Sections 3-4 | [Version read](https://arxiv.org/pdf/math/0607671v2), `arxiv:math/0607671v2`, Prop. 3.3 p. 4, Lemma 4.2 and Prop. 4.3 p. 6. **Supports the analogy and conditional statement.** | Coprime \(q_m,q_n\), where \(q_n=(n+1)^n-1\), reduce the generating set of their particular relation module. Their D(2) counterexample conclusion is conditional on a relation gap. It is not a theorem about the present \(K\); no such inference is made here. |
| Hambleton18, Lemma 2.1 | [Version read](https://arxiv.org/pdf/1708.08532v1), `arxiv:1708.08532v1`, pp. 3-4. **Supports.** | Stabilization uses \(r=b_3(X)\), where the preceding text explicitly defines this as the **number of three-cells**, not a Betti number. The lemma has no finite-fundamental-group requirement. No stabilization result removes the unstabilized obstruction proved here. |
| Hambleton18, Theorem B | Same version, p. 2. **Supports.** | This is for fundamental groups that are finite subgroups of \(SO(3)\). The present \(G\) maps onto \(\mathbb Z\), so it is outside those hypotheses. |
| HofmannNicholson27, p. 254 and Theorem A | [Published PDF](https://eprints.gla.ac.uk/390608/2/390608.pdf), DOI `10.1016/j.jalgebra.2026.06.040`; pp. 254-255. **Supports.** | The formulation uses finite complexes and finitely generated coefficient modules. Theorem A covers \(Q_{4n}\) for \(6\leq n\leq8\), i.e. orders 24, 28, 32, and explains the earlier order-28 work. It does not apply to the present infinite group. The first page says available online 15 July 2026; the 2027 volume date is not itself an anachronism. |
| Wall65, Section 2 | [Original scan read by the source reader](https://webhomes.maths.ed.ac.uk/~v1ranick/papers/findom1.pdf), DOI `10.2307/1970382`; p. 62, Complement p. 64, Theorem F p. 66. **Supports with locator qualification.** | Wall says all coefficient bundles. The Complement supplies a three-dimensional model; the finite-model refinement uses Theorem F and the vanishing obstruction for finite \(X\). The report proves the finite-generated/all-module equivalence directly, so no change of coefficient quantifiers is hidden. |
| Wall79, Problem D3 | [Publisher chapter](https://www.cambridge.org/core/books/homological-group-theory/list-of-problems/EA342AEFE813EB716097204CB76EF151). **Primary text unavailable.** | The source reader reached the chapter page but the PDF redirected to an access page. No exact quotation or verification of Problem D3 is claimed. This historical citation is not a mathematical premise. |
| Fox53 | [Original scan](https://webhomes.maths.ed.ac.uk/~v1ranick/papers/fox1.pdf), DOI `10.2307/1969736`; p. 549 equations (1.2)' and (1.6), p. 550 equation (2.1). **Supports.** | These are the manuscript's left Fox product and inverse rules, not Mannan's opposite convention. They do not verify a particular matrix. The report derives the cellular edge rule and recomputes every entry independently. |
| Quillen71 | [Official ICM proceedings read by the source reader](https://www.mathunion.org/fileadmin/ICM/Proceedings/ICM1970.2/ICM1970.2.ocr.pdf), Section 3, p. 50. **Historical/contextual.** | Describes the perfect elementary subgroup and attaching two- and three-cells to obtain \(BGL(A)^+\). It does not explicitly state the full finite-normal-generation/arbitrary-coefficient proposition used here. Mannan is the precise cited source; Section 6 of the report is an independent proof. |
| Johnson03 | [Official introduction](https://assets.cambridge.org/97805215/37490/excerpt/9780521537490_excerpt.pdf), pp. 1-3, and [contents](https://assets.cambridge.org/97805215/37490/toc/9780521537490_toc.pdf), pp. vii-ix, read by the source reader. **Contextual.** | Supports the claimed algebraic-homotopy, cancellation, stabilization and realization background. No unexamined individual theorem from the full book is used. |
| Cohen78 | DOI `10.1090/pspum/032.2/520542`, pp. 221-223. **Primary text unavailable.** | Publisher requests returned 403. Hambleton Remark 1.1 attributes the stabilization result to Cohen's Theorem 1, but that is secondary attribution, not an independent reading of Cohen. The applicable stabilization statement was verified in Hambleton. |
| MannanPopiel21 | [Version read by the source reader](https://arxiv.org/pdf/1901.10786v4), `arxiv:1901.10786v4`, Theorem A, pp. 1-2. **Supports contextual attribution.** | Constructs an exotic balanced presentation of \(Q_{28}\), with nonstandard second homotopy module. It does not alone give the whole D(2) property. |
| Nicholson21 | [Version read by the source reader](https://arxiv.org/pdf/1905.12018v3), `arxiv:1905.12018v3`, p. 2 statement of Theorem 8.11. **Supports contextual attribution.** | Explicitly gives the D(2) property for \(Q_{28}\), combining the algebraic classification with Mannan-Popiel. The manuscript's joint attribution is supported. |

## Foundations used by the independent proof

Hatcher, *Algebraic Topology* (2002), ISBN `9780521795401`, was obtained from
the author's [Cornell PDF](https://pi.math.cornell.edu/~hatcher/AT/AT.pdf).
The Engineer read the statements of Proposition 1.33 (p. 61), Theorem 2C.1
(p. 177), Theorems 2.35 (p. 139), 4.8 (p. 349), 4.32 (p. 366), and the
module/local-coefficient conventions of Section 3.H, pp. 327-333.
Covering lifting is applied only to connected locally path-connected
complexes. Simplicial approximation is applied to a finite simplicial domain.
Degree-two Hurewicz is applied only to the simply connected universal cover
of \(B'\). No acyclicity hypothesis is substituted for simple connectivity.
These standard foundations are imported assumptions rather than purported
outputs of the finite verifier.

## Scope of the source judgments

The independent reader supported the first two prior-source claims now in
the ledger, and the bibliography applicability above. Source passages for
the central uses are preserved in `literature/*-excerpt.txt` alongside
the original documents. The reader did not certify the Engineer's proof.

The mission's write boundary permits `research/wall_d2_audit/` but not
`research/literature/`. The official `citation_check attribute` command
archives to the latter directory; it has therefore **not** been run across
that boundary. Inspection of the installed `record_citation_evidence`
implementation confirmed the fixed destination; this is not an inferred
tool limitation. No successful registry attribution is fabricated. Independent
source-reading opinions and their actual local artifacts can be recorded
with `math_state judge`; the canonical citation-attribution gate remains
explicitly pending for the Host's authorized review path. The mathematical
applicability findings above are not being replaced by an identifier-resolution
check.

The higher-rank statement proved in the report is stronger than the rank-one
manuscript formulation. Howie's Lemma 3.2 is a constant-coefficient
predecessor, and Louder-Wilton supplies the tower method. The bounded
source comparison did not locate the full finite-rank assertion, but
**does not establish novelty or priority**.
