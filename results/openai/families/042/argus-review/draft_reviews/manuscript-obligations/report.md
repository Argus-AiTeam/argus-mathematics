# Broader manuscript obligations and source attribution

## Disposition

**The old audit establishes a sewing argument, not the broader K3 theorem.**
Its dependency map is substantially source-faithful, but the broader claims
remain separate, concrete mathematical obligations. Their absence from a
sewing-only proof is neither a source counterexample nor a reason to launch
a new error search. This unit is a substantive scope/dependency assessment,
not an attempted replacement proof of the manuscript.

The old inputs are the report's Scope and source facts, all versions of
`C_SCOPE_EXTERNAL`, the other broader ledger entries, and the proof graph.
The source is OpenAI, *Every complex K3 surface is Oka*, September 23, 2026,
bound to revision `4eaee87548250b2682affda7d05d947c05554bae` by the
manuscript reference manifest. The exact local sewing argument and
its input hypotheses are assessed separately.

The read-only inventory has 19 distinct old claim identifiers and 22 claim
versions, including four versions of the same external-scope assertion.
The graph has 19 open nodes; every `reviewer_confirmed` flag is false.
Historical engineer and `reviewer:independent-L2` judgements do not convert
those records into compiler evidence or substitute for this mission's
native independent Reviewer.

## Exact claims, source hypotheses, and missing obligations

The following are statements attributed to the old draft/source, not
theorems established by this review. Paths are relative to the manifest's
`build/` directory.

| Old claim | Source assertion and essential hypotheses | Concrete obligation outside the old sewing proof |
|---|---|---|
| `C_K3_OKA` v1 | `sections/introduction.tex`, `thm:main`, lines 7-34: for every complex K3 \(X\), Hermitian distance, \(m\geq1\), nonempty compact convex \(K\subset\mathbb C^m\), neighborhood \(U\), holomorphic \(f:U\to X\), and \(\epsilon>0\), an entire \(F:\mathbb C^m\to X\) approximates \(f\) on \(K\). | **Universal K3/CAP obligation:** obtain property L at every point for every K3 period type, justify transfer by the period/dynamics and Torelli arguments, and establish the all-dimensional convex approximation implication. Neither an exact annular chain nor density of Oka periods implies this universal assertion. |
| `C_GEOMETRIC_L` v1 | The geometric/period argument must supply the two-family/property-L hypotheses at every K3 point. Source branches include `sections/projective.tex` lines 5-29, 229-265, `deg:open`, `rat:open`, and `sections/dynamics.tex` lines 134-166. | **Geometric supply/transfer obligation:** construct the relevant strip families on the stated projective, degeneration and rational open regions; prove transversality, point coverage and the needed period-orbit intersection/transfer. A conditional sewing theorem supplies none of those inputs by itself. |
| `C_DEG_SEAMS` v1 | `sections/degeneration.tex`, `deg:seams`, lines 303-370: after choosing small \(d\), then small nonzero \(\alpha\), normalized core/neck charts have fixed buffered widths, degree-one symplectic transitions and uniform derivative bounds, with error at most \(Cd+\epsilon(d,\alpha)\); exactness is not yet asserted. | **Core/neck obligation:** verify the exit/entrance expansions, residue normalization, inverse branches, cuts/origins, and uniform buffered domain/image estimates; then supply exactness by allowable center adjustments. Testing an arbitrary already-exact transition does not establish this construction. |
| `C_RATIONAL_STRIPS` v1 | `sections/rational.tex`, `rat:strips`, lines 270-345: compact regular-torus data, safe primitive cycles and a positive forbidden-action margin yield, after sufficiently small deformation in the prescribed period locus, periodic symplectic immersed strips of positive width; on any prescribed finite initial cells there is uniform \(C^1\) approximation to the models. | **Safe-action/deformation obligation:** produce the finite buffered atlas and safe cycles, control their action changes and updated centers throughout the infinite continuation, and prove the deformation estimates needed by sewing. A finite initial-cell approximation is not automatically a uniform infinite-chain model estimate. |
| `C_SEW_CENTERS` v1 | `sections/sewing.tex`, `sew:centers`, lines 371-436: charts and models exist on larger transverse discs, are uniformly close, and transitions at model matching positions are close to degree-one shears; period correction can repeat **whenever updated centers retain uniform buffered choices**. | **Moving-center obligation:** a one-step correction \(P_{\rm new}=P-D\) removes the period because \(\int dW=1\), but the applications must keep supplying charts and models at every new center with the same buffers and bounds. Small individual corrections do not bound their accumulated displacement. The lemma explicitly permits unbounded accumulated displacement only under this continuing geometric hypothesis. |
| `C_TWO_FAMILIES_L` v1 | `sections/local.tex`, `loc:criterion`, lines 34-60: maps \(\sigma_1:\mathbb C\times\Delta_b\to X\), \(\sigma_2:\Delta_b\times\mathbb C\to X\), locally biholomorphic at \((0,0)\), have the common germ \(\sigma_1(z,0)=\sigma_2(z,0)\). If \(\sigma_2\) is locally biholomorphic at \((0,c)\), L holds at \(\sigma_2(0,c)\). There is also the precise long-disc alternative described below. | **Local approximation obligation:** prove the planar attached-disc approximation with every passive polydisc dimension from these family hypotheses, and verify exact common-axis agreement and nondegenerate endpoint germs in each application. Sewing a single family does not give the second family or this approximation theorem. |
| `C_PROPERTY_L_CAP` v1 | `sections/gluing.tex`, `ana:cap`, lines 1-27: a complex surface with complete compatible distance and property L at every point has CAP in every source dimension. | **Globalization obligation:** prove the face-extension/removal and approximation induction for arbitrary convex source data, including passive variables, small-error control, and existence of a holomorphic limiting map. It requires the polydisc and trace-gluing machinery, not just active two-dimensional symplectic sewing. |
| `C_POLYDISC` v1 | `sections/gluing.tex`, `ana:polydisc`, lines 327-355: under the L/CAP setup, a map near the unit closed polydisc can be approximated there by maps near every finite larger polydisc and, through the stated iteration, by entire maps. | **All-dimensional enlargement obligation:** justify the planar operation for \(m=1\), the nonlinear source-coordinate concentration and passive-variable extension for \(m\geq2\), and compatible finite-radius iteration with error control. The separate reduction from arbitrary convex compact sets is still needed for CAP. |
| `C_TRACE_GLUE` v1 | `sections/globalization.tex`, `glue:trace`, lines 483-542: for sprays on the two open sides and a small \(C^\alpha\) transition on the real interface, holomorphic in tangential variables and fiber, the open-gluing conclusion holds without an assumed positive complex-normal thickness of smallness. | **Trace analytic obligation:** obtain the bounded trace-splitting operators in the asserted norms, quadratic nonlinear improvement with shrinking tangential/fiber margins, convergence of corrections and matching traces, and holomorphic extension across the interface. An annular Fourier estimate on a positive open complex strip does not supply estimates without such normal thickness. |

These are mathematical obligations, not access or execution failures.
The old sewing report does not contain their proofs. No invalidity of their
source proofs is inferred from that fact.

### The local criterion's exact compatibility is important

The common germ in `loc:criterion` is the first strip's central curve
and the second strip's **starting section**:
\(\sigma_1(z,0)=\sigma_2(z,0)\) for small \(z\). It is not
agreement of both complete central curves, and it is not equality
on a bidisc. Such substitutions change the hypothesis.

The long-disc alternative uses long-coordinate radii tending to infinity
and bounded-coordinate radii bounded below. Each pair has exact axis
agreement. There is convergence near \((0,0)\), and for the second
maps near a fixed \((0,c)\), to the required nondegenerate germs.
The conclusion is L at the limiting second germ's endpoint. Global
convergence along the long coordinates is not asserted.

Property L itself (`sections/local.tex`, lines 10-26) uses **one**
neighborhood \(V\) of the target point for every \(q\geq0\),
special attached-disc pair \(D\subset D'\), and closed passive
polydiscs \(P_0\Subset\operatorname{int}P\subset\mathbb C^q\).
A map near \(D\times P\) with values in \(V\) is to be approximated
on \(D\times P_0\) by maps near \(D'\times P_0\) with values in
the whole target \(X\), not necessarily \(V\). Arbitrary passive
holomorphic dependence of a sewn immersion is not this approximation
property.

### The old mission goal is not another theorem

`C9000042` v1 was an adversarial audit objective, allowing a flaw,
counterexample, fidelity gap, or verified/repaired/generalized core
result. Its route through `C_SEW_CHAIN` does not turn the sewing
result into a universal manuscript verification. It is inventoried as
a historical goal, not counted as an independent mathematical result
or adopted as current instructions.

## External-source scope, actual lookup, and versions

`C_SCOPE_EXTERNAL` has the same assertion in versions 1-4: the external
genus-one and period/dynamics propositions are separate manuscript
dependencies, not black boxes used in the sewing proof. Version 2 adds
`A_SCOPED_SOURCE`, version 3 adds `A_GENUS_ONE_ATTRIBUTION`, and version 4
adds `A_DENSE_PERIOD_ATTRIBUTION` (with reordered assumption storage).
These are dependency-record changes, not four theorems.

The source attribution was checked against the manifest-bound local
passages and by a bounded primary-source lookup by the separate
`citation-source-fidelity` research reader. All three specified external
documents were obtained; there was no missing-source conclusion.

| Citation and exact version | Proposition scope actually obtained | Boundary relevant to this review |
|---|---|---|
| Chen-Gounelas, *Curves of maximal moduli on K3 surfaces*, [DOI 10.1017/fms.2022.24](https://doi.org/10.1017/fms.2022.24), Theorem A | On a projective K3 over an algebraically closed characteristic-zero field, for each integer \(g>0\), integral geometric-genus-\(g\) curves with self-intersections tending to infinity have normalizations in smooth families of curve-to-surface morphisms over irreducible \(g\)-dimensional bases with \(g\)-dimensional moduli images. For \(g=1\) this supplies nonconstant moduli variation. The source's phrase is "with maximal variation in moduli." | This is projective curve/family input. Turning it into the ambient strip families, complete flows, dominant evaluation, proper-family interpretation and independent tangent directions still requires the source's geometric arguments. It supplies no exact sewing transitions or CAP conclusion. |
| Xie-Zhao, *Periods of Oka K3 surfaces are dense*, [arXiv:2608.24392v2](https://arxiv.org/html/2608.24392v2), Theorems A, B, E | A gives dense \(G_\delta\) Oka fibers, also with \(\operatorname{NS}=0\), in every local Kuranishi family of a K3. B says "Every Wehler Calabi-Yau manifold is Oka," for the smooth multidegree-\((2,\ldots,2)\) manifolds in the stated class, dimension \(m\geq2\). E gives dense \(G_\delta\) Oka periods in the K3 and Kummer period domains, including the specified Neron-Severi lattice conditions. | These are density or particular-class results, not every-K3 Oka. B is a geometric Oka theorem, not itself an orbit-density proposition. The manuscript's universal conclusion needs additional steps. |
| Verbitsky, *Ergodic complex structures on hyperkahler manifolds: an erratum*, [arXiv:1708.05802v1](https://arxiv.org/pdf/1708.05802v1), Theorem 2.5 | For an integral lattice of signature \((a,b)\), \(a>2,b>0,a+b>4\), and finite-index \(\Gamma\subset SO(V_{\mathbb Z})\) on positive oriented planes, rational planes have closed orbits, planes with no nonzero rational vector have dense orbits, and there is a separate rank-one rational-direction alternative. | The printed theorem concerns the full \(\Gamma\)-orbit. Density under the subgroup fixing a given vector is not automatically the same assertion. The manuscript separately argues that stabilizer statement in `dynamics.tex`, lines 108-131; that argument is not checked by the sewing audit. |

The local manuscript itself names Chen-Gounelas Theorem A and
Xie-Zhao Theorems A, B, E (`introduction.tex`, lines 115-132;
`projective.tex`, lines 24-39). The old audit did **not** invent these
theorem letters. `dynamics.tex`, lines 8-28, cites Xie-Zhao and the
Verbitsky erratum at work level and states its own orbit lemma.
The introduction separately uses Section 4 of the erratum for the
Kobayashi-pseudodistance correction. Conflating those locators or
attributing the manuscript's stabilizer lemma verbatim to Theorem 2.5
would be a source-scope mismatch; this assessment does neither.

The bibliography also records the specified DOI/arXiv versions.
`references.bib` is **not** one of the manifest's 13 hashed TeX entries,
so no byte-binding claim is made for it. The theorem-letter attribution
is present in the bound manuscript body, and the external versions were
looked up directly. The CAP/Oka characterization and survey/problem
citations mentioned by the manuscript are contextual dependencies,
not external results imported into the old sewing proof.

No correctness proof of these external papers is claimed. Looking up
their statements checks attribution and scope; accepting their results
as known inputs to a broader proof would still leave the explicit
geometric and analytic transfer obligations in the table.

## Dependency reconciliation and review limit

The old AND/OR structure is retained in the coverage index. Sewing
depends on its five analytic obligations. The effective statement
depends on sewing and passive holomorphicity. The broader K3 node
depends on geometric L and L-to-CAP; the former includes seam supply,
rational strips, center correction, sewing, the two-family criterion
and external scope, while the latter includes polydisc approximation
and trace gluing. A dependency edge is not evidence that its obligation
has been discharged.

The old `exact_certificate.json` calls the result `new_theorem` while
also saying novelty is not established and host review is pending.
This review retains the latter limits and does not inherit the stronger
classification. The strongest old supported mathematical result remains
the conditional sewing reconstruction and proposed strengthening.
There is no new mathematical improvement to the K3 theorem here.

The active ledger records current review scope assumptions and the
documented failed approaches, rather than modifying or treating the old
ledger as authoritative. This unit's unresolved entries are a completed
negative/scope assessment of what the old draft supplies, not a claim
that the corresponding source mathematics has been resolved. Acceptance
of the entire exploratory review is reserved for the native Reviewer.
