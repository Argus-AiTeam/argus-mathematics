# Sheehan's conjecture at treewidth four

**Status:** the exact computer-assisted proof and statement fidelity were
independently accepted by `reviewer:e04396ae5d6f` on 2026-11-03 at 15:29:48Z.
The five supporting ledger judgements and read-only certificate replay are
recorded in `roles/reviewer/progress.json`. Verified novelty and publishable
significance have not been awarded. This is not a resolution of Sheehan's
conjecture without the width restriction.

## Statements

**Theorem 1 (two-terminal exclusion).** Let H be a finite simple graph with
distinct nonadjacent vertices u,v of degree two, at least one other vertex,
and degree four at every other vertex. Suppose H has a tree decomposition
of width at most four with a bag containing both u and v. Then the number
of undirected spanning u-v paths is zero or at least two.

**Theorem 2 (quartic exclusion).** Every finite simple 4-regular Hamiltonian
graph of treewidth at most four has at least two distinct undirected
Hamiltonian cycles.

Paths and cycles are selected edge sets. Reversal, rotation and a choice of
starting vertex create no additional objects.

## The counting algebra

Use the reviewed algebra of `routing_signatures.md`. A partial graph has a
labeled boundary B with at most five vertices, underlying degrees g at most
four, and degree-four interior. A signature records g, the actual boundary
edge set A, and the counts N, truncated at two, of every open path-pairing
type and every single-cycle type. At boundary size five there are 143 types.
Closed types are not removed merely because they are irrelevant to a
particular terminal completion.

The operations are introduction of an isolated boundary vertex, introduction
of a new boundary edge, forgetting a degree-four boundary vertex, relabeling,
and arbitrary legal binary joins with disjoint interiors and boundary edges.
The underlying degrees and A enforce quartic capacity and simplicity.
Counting uses nonnegative sums and products, and truncation at two commutes
with these operations.

After each operation keep only live types with

    h(v) <= g(v),    g(v)-h(v) <= 2.

The reviewed backward-liveness proof shows that a live parent can use only
live children. Thus this projection preserves every count used below.

## A full-signature invariant from pointed supports

For a live-projected signature N let S be its support. A pointed support
`(g,A,q,S)` additionally asserts that the distinguished count `N(q)` is one.
Other positive counts need not be unique.

A distinguished output is unique precisely when its distinguished input
choice contributes and no other supported choice contributes to the same
output. At a join the input choice is a pair of child types; for edge
introduction it also specifies whether the edge is selected. This follows
because the distinguished contribution is one and every alternative
contributes a positive integer.

Consequently, at fixed g,A,q, replacing S by a smaller support containing q
preserves every distinguished unique continuation and only shrinks its
output support. This applies to every unary operation and to either or both
operands of an arbitrary join. Relabeling transports support inclusion.
Full proofs are in `marked_support.md`.

Let R consist of the 3643 active pointed supports in
`marked_support.frontier.json` and all their boundary relabelings. Define

    I_R(g,A,N):
      every live count-one entry q of N has a representative
      (g,A,q,T) in R with T contained in supp(N).

This predicate is on full counting signatures, including all their closed
entries. It does not assert that every unique routing is impossible.
On an unprojected vector, additionally require zero counts for types with
selected degree exceeding g and apply I_R to the live projection. Degree
compatibility is preserved by the operations, and backward liveness makes
this an operation-closed full-signature predicate as well.

The certificate establishes leaf inclusion and coverage of all pointed
successors of R. Therefore I_R is an invariant: any count-one parent has a
unique contributing choice of count-one child entries; replace their
supports by the covering representatives, use dominance, and then use the
certificate's coverage of that distinguished successor. Signatures with no
live count-one entry satisfy I_R vacuously.

For completeness, joins with a boundary-only operand are covered by unary
closure. Introduce the operand's boundary edges successively into the other
child. All introductions are legal, and the resulting graph is the join.
A unique final routing restricts to unique intermediate routings, since two
intermediate choices could be extended by the same remaining selected edges.
Backward liveness preserves those intermediate entries. Dominance then
permits using the representative supplied after each unary step. No other
joins are omitted.

## Exact finite certificate

The separately implemented checker `verify_marked_closure.py` does not import
the pointed-support search. It first reconstructs all 3917 construction-DAG
rows using the reviewed full counting algebra and checks every support and
distinguished count. Its join enumeration recursively generates all
bijections satisfying the selected- and rejected-degree capacities, then
checks edge disjointness and the routing-type join. These capacity tests
are exactly selected degree at most two and live rejected degree at most
two; together they imply underlying degree at most four.

It verifies one leaf, 26062 unary operations and all 590439 admissible
relative joins of non-boundary-only operands. The 11234 unique unary outputs
and 9076 unique join outputs are all covered by R. Another 677130 operand
pairs are discharged by the boundary-only composition proof. Coverage is
checked up to every boundary permutation.
Testing unordered representative pairs is sufficient: commutativity and
a common output relabeling reduce any two relabeled operands to one such
pair with a tested relative bijection.

Finally, R has neither:

    g=(2,2), A empty, q=the open u-v path;

nor an empty-boundary closed marker. The support at a terminal obstruction
is not required to have its other entries zero.

The complete exact replay exited zero and is recorded in
`marked_support.closure.json`. Its durable terminal record is
`marked_support.replay_status.json`. Active boundary-size counts are
`1,1,3,16,289,3333`. Representatives have order at most twelve, but this is
**not** an exhaustion of input graphs up to twelve vertices. Operation closure
and the invariant, not a finite graph-order search, supply the induction over
graphs of arbitrary order and arbitrarily branching decompositions.

## Deducing the theorems

Root a decomposition of H from Theorem 1 at a bag containing u,v. Convert
it to the reviewed nice construction, retaining u,v at the root and forgetting
every other vertex only after its full degree four is present. If necessary
forget other vertices of the root bag to leave boundary exactly `{u,v}`.
Every bag still has size at most five. Thus all such H are covered, with
arbitrary binary joins.

Its terminal signature has `g=(2,2)` and A empty. The spanning terminal-path
count is precisely the open entry with selected degrees `(1,1)`. It is live.
If that count were one, I_R would require a representative with the first
forbidden structural-marker data, regardless of the closed counts. There
is no such representative. This proves Theorem 1.

For Theorem 2 take a nice decomposition with empty boundary at the root.
The closed entry is exactly the undirected Hamiltonian-cycle count truncated
at two. Count one would require the other forbidden representative, again
contradicting I_R. Equivalently, Theorem 2 follows from Theorem 1 and the
independently reviewed width-preserving two-terminal equivalence in
`two_pole_reduction.md`.

## Improvement, scope and reproducibility

The strongest preceding accepted results were signature soundness,
completion-live projection and a width-preserving equivalence; none excluded
an additional graph class. The new ingredient that completes the mathematical
argument is an exact closed separating collection. It does not reuse the
refuted deficit threshold, boundary-only safety predicate or terminal parity.
The reachable I6 obstruction and terminal examples with 19 and 21 paths
remain admissible.

The width restriction is the first nonvacuous one for quartic graphs: a
nonempty graph of treewidth k has a vertex of degree at most k. The class
is unbounded and includes nonplanar graphs such as K5 and K4,4, so it is
not a restatement of the known planar exclusion.

A focused literature lookup did not locate a verified primary source giving
this exact width-four theorem. This is not verification of novelty.
In particular arxiv:2506.23790v1 concerns precedence-constrained Hamiltonian
paths and cycles, not a structural exclusion of ordinary unique cycles.
The known planar theorem remains identified in the existing source ledger.
No new external theorem is needed for the proof above.

## Publication comparison (2026-11-03)

Here C means Theorem 2 and P means Theorem 1, with exactly the hypotheses
stated above. This comparison does not revise either statement or the accepted
proof. The additional literature below supplies comparison baselines, not
external assumptions of C or P. The accepted ledger judgements remain at the
`judgement` tier; `math_state show --claim C3167-TW4` reports `supported`,
with no undischarged assumptions or stale evidence, not `closed_kernel`.

### Structural results and the two-terminal quantifiers

| Inspected proposition and locator | What follows, and what does not |
|---|---|
| Thomason (1978), *Hamiltonian Cycles and Uniquely Edge Colourable Graphs*, original [author scan](https://www.dpmms.cam.ac.uk/~agt2/HC.pdf), Corollary 1.2, p. 261; the original scan and independent reading are already archived locally. All vertices other than the prescribed path endpoints have odd degree. | This excludes unique cycles in odd-degree graphs, and implies the familiar even-complementary-2-factor sufficient condition in quartic graphs. It does not apply to P's degree-four interiors. The independently accepted 19- and 21-path examples rule out replacing P by an evenness assertion. |
| Bondy and Jackson (1998), *Vertices of Small Degree in Uniquely Hamiltonian Graphs*, doi:10.1006/jctb.1998.1845. The original full text remains inaccessible. Its planar conclusion is reproduced in [arxiv:2104.10020v2](https://arxiv.org/html/2104.10020v2), Section 1, and [arxiv:1812.05650v2](https://arxiv.org/html/1812.05650v2), Introduction, p. 2. | The known planar exclusion proves C only for its planar subclass. P has neither planarity nor a cofacial-terminal requirement. A common decomposition bag is not an embedding condition; one cannot invoke the planar theorem on a double without establishing that the double is planar. This is an inspected reproduction, not a newly obtained original-paper theorem locator. |
| Ben Seamone (2015), *On Uniquely Hamiltonian Claw-Free and Triangle-Free Graphs*, doi:10.7151/dmgt.1784, [journal abstract archived by EuDML](https://eudml.org/doc/271097), pp. 207-214. The read abstract states: "claw-free graphs with minimum degree at least 3 are not uniquely Hamiltonian." | This is an all-orders exclusion stronger than C on claw-free quartic graphs, with no width bound. It already covers K5. Width four does not imply claw-freeness: K4,4 has an induced claw. P's terminals violate the minimum-degree hypothesis, and doubling does not automatically preserve claw-freeness. Full text and a numbered theorem locator were not obtained. The search summary's attribution to Fouquet (1994) was not supported by this source and is not used. |
| Haxell, Seamone and Verstraete (2007), *Independent dominating sets and Hamiltonian cycles*, doi:10.1002/jgt.20205; previously independently checked reproduction in [arxiv:2304.08946v6](https://arxiv.org/html/2304.08946v6), Section 1. | The regular-degree exclusion starts at degree 23. Neither C nor a quartic double of P satisfies it. The original-paper retrieval limitation and the fact that the ledger cites a reproduction are preserved. |
| Goedgebeur, Jooken, Lo, Seamone and Zamfirescu, [arxiv:2211.08105v1](https://arxiv.org/html/2211.08105v1), Section 4, Theorem 4 and Section 4.2; these propositions already have independent citation attributions. A set independent on the fixed Hamiltonian cycle and dominating its edge complement gives another cycle. | This is a sufficient condition, not a universal exclusion of the width-four class. The same source reports its failure for a prescribed cycle of K5. It does not give P merely from the terminals' degrees or common bag. No claim is made that every width-four graph escapes this or the other known sufficient conditions. |
| Goedgebeur, Meersman and Zamfirescu, *Graphs with few hamiltonian cycles*, doi:10.1090/mcom/3465; inspected [arxiv:1812.05650v2](https://arxiv.org/html/1812.05650v2), Section 3.1.4, Observation 3.9 and Table 3, p. 15. It verifies Sheehan through order 21, and through order 26 for girth at least five. | This finite verification does not imply C at arbitrary order. Via the accepted doubling bijection it excludes a unique path in P only when the double lies in the checked range: a terminal graph of order n doubles to order 2n-2, so the general order-21 result gives n <= 11, not all n. The cited bound is an inspected comparison baseline, not a claim to be the latest finite-search record. |
| The same version, Section 3.4, Observation 3.17, p. 20, and Theorem 3.18(1), p. 21. Unique traceability means exactly one spanning path over **all** endpoint pairs. Its unique path has degree-one endpoints; the size bound at order N is floor((N-1)^2/4)+1. | P concerns uniqueness for one prescribed pair, so its degree-two terminals do not contradict the degree-one conclusion. Adding one pendant vertex to each terminal turns prescribed-pair uniqueness into unique traceability, but then the two new endpoints do have degree one. The augmented graph has N=n+2 and 2n edges; the size bound allows this for every n >= 6. Thus neither observation supplies P. |

The 2019 version of the Goedgebeur-Meersman-Zamfirescu paper was obtained
from arXiv after the AMS accepted-manuscript endpoint returned HTTP 403.
The exact version and text are retained in
`literature/goedgebeur-meersman-zamfirescu-2020.pdf` and `.txt`; locators
above refer to that version, not to potentially different journal numbering.
Its Section 3.1.2, Theorem 3.5, pp. 11-12, also uses two-copy gluing in
equivalent formulations of the planar Bondy-Jackson conjecture. Two-terminal
gluing itself is therefore not presented as a novel technique. That theorem
is an equivalence involving planar counterexamples, not the degree-four,
common-bag path exclusion P.

### Partial 4-trees are not just maximal 4-trees

The target includes all partial 4-trees satisfying the degree and Hamiltonicity
conditions, not just maximal 4-trees, path decompositions or serial joins.
For comparison, a 4-tree on n >= 5 vertices has 4n-10 edges: start with K5
and add four edges with each new vertex. If that graph is quartic it has
2n edges, forcing n=5. An exclusion restricted to quartic **maximal**
4-trees would consequently cover only K5; it cannot replace C.

The bounded source reader followed the Sanders citation chain rather than
repeating the Planner's generic width-four exclusion search:

| Primary document and inspected locator | Access and implication boundary for C and P |
|---|---|
| Daniel P. Sanders, *On Linear Recognition of Tree-Width at Most Four* (1996), doi:10.1137/S0895480193243043, pp. 101-117; [publisher-deposited abstract](https://api.crossref.org/works/10.1137/S0895480193243043). | The abstract supplies width-preserving reductions and a recognition algorithm, not preservation of quartic degrees, unique cycles, prescribed-terminal paths or the common-terminal bag. The publisher full text returned 403. The prior abstract-only assessment is retained; the unseen reduction rules are not declared irrelevant or uniqueness-preserving. |
| Arnborg and Proskurowski, *Linear time algorithms for NP-hard problems restricted to partial k-trees* (1989), doi:10.1016/0166-218X(89)90031-0, pp. 11-24; [registry record](https://api.crossref.org/works/10.1016/0166-218X(89)90031-0), Sanders reference R7. | Metadata was obtained, but no deposited abstract or full theorem text; publisher access returned 403. No Hamiltonian section or counting/uniqueness theorem was verified. Implications for C and P remain unexamined, not refuted by a failed retrieval. |
| Sanders, *Linear algorithms for graphs of tree-width at most four* (1993 dissertation), [hdl:1853/30061](https://hdl.handle.net/1853/30061), Sanders reference R23. | Catalogue and bitstream metadata only: the advertised download did not yield the dissertation, and both the original-PDF and extracted-text content endpoints returned HTTP 401 in the targeted follow-up below. There is no inspected theorem/page locator. This remains a primary-source gap, not novelty evidence. |
| Courcelle, *The monadic second-order logic of graphs III: tree-decompositions, minors and complexity issues* (1992), doi:10.1051/ita/1992260302571; [full text](https://www.numdam.org/item/ITA_1992__26_3_257_0.pdf), Section 3, Proposition 3.1, printed pp. 274-275, Sanders reference R11. | This constructs bounded-width model-checking algorithms with fixed logical and source parameters; the surrounding discussion includes Hamiltonian-circuit existence. Being able to decide a predicate on each graph establishes neither the universal implication C nor the prescribed-pair implication P. |

These access limitations prevent an exhaustive exclusion of earlier
partial-4-tree reduction arguments. No absent theorem was inferred from
metadata, a search result, or an inaccessible PDF.

#### Targeted primary-text follow-up and exact blocker

On 2026-11-03, after the independent publication comparison, retrieval was
narrowed to the unexamined Sanders and Arnborg-Proskurowski body propositions.
The accepted theorem/certificate was not replayed, and the generic
width-four novelty search was not repeated.

The [current Georgia Tech dissertation record](https://repository.gatech.edu/entities/publication/bfd3eb76-f322-45be-94cb-e498a08b977c)
and its [public bundle metadata](https://repository.gatech.edu/server/api/core/items/bfd3eb76-f322-45be-94cb-e498a08b977c/bundles)
were accessible. They identify the original file
`sanders_daniel_p_199308_phd_373649.pdf` and an extracted-text companion.
The following actual requests distinguish finding a file from reading it:

| Repository-advertised resource | Measured outcome |
|---|---|
| [Original download link](https://repository.gatech.edu/bitstreams/f8f9f6f4-1a51-4471-9481-3c52ae717c8b/download) | Returned an HTML page rather than a PDF; PDF parsing failed. The mislabelled temporary download was removed, not retained as a source. |
| [Original PDF content](https://repository.gatech.edu/server/api/core/bitstreams/f8f9f6f4-1a51-4471-9481-3c52ae717c8b/content) | HTTP 401; curl exited 22. No dissertation text obtained. |
| [Extracted-text content](https://repository.gatech.edu/server/api/core/bitstreams/666c2ebd-c995-4685-9802-2a4bba8f939a/content) | HTTP 401; curl exited 22. The public metadata describing this file does not expose its contents. |

An independent author-copy search supplied no accessible Sanders manuscript.
The [OpenAlex location record](https://api.openalex.org/works/https://doi.org/10.1137/S0895480193243043)
listed only the publisher location and no PDF. Robin Thomas's historical
publication-page link redirected to a missing page (404). These are source
location outcomes, not evidence that an author copy or an earlier theorem
does not exist. No credentials or access-control workarounds were used.
A search response proposed a Sanders "Proposition 2.1" while citing only
bibliographic pages; no such numbered proposition was opened, so neither
the number nor its alleged statement is used.

A bounded primary-source reader tried five distinct legal location routes
for Arnborg-Proskurowski without repeating the denied ScienceDirect request:

| Location route | What was actually obtained |
|---|---|
| [Proskurowski's author publication list](https://ix.cs.uoregon.edu/~andrzej/pkt_pubs.html) | Read the matching 1989 citation, but it has no full-text link. |
| [Arnborg's historical KTH author site](https://www.csc.kth.se/~stefan/) | HTTP 403; a KTH profile request also failed at transport level. |
| [OpenAlex location record](https://api.openalex.org/works/https://doi.org/10.1016/0166-218X(89)90031-0) | No PDF or repository full text listed. Semantic Scholar returned 429. Neither registry response is a body proposition. |
| [KTH DiVA exact-title lookup](https://kth.diva-portal.org/smash/resultList.jsf?searchType=SIMPLE&query=Linear+time+algorithms+for+NP-hard+problems+restricted+to+partial+k-trees) | HTTP 403; no record attachment inspected. |
| [Academic-upload candidate](https://www.academia.edu/77279922/Linear_time_algorithms_for_NP_hard_problems_restricted_to_partial_k_trees) | HTTP 403; neither provenance nor contents could be verified. |

Consequently **proposition-level implication and non-subsumption remain
unestablished for both C and P** against these papers. For C the missing
reading concerns the exact reduction hypotheses and any preservation of
quartic degrees and Hamiltonian multiplicity, not just treewidth. For P it
also concerns prescribed endpoints, the common-terminal bag, and arbitrary
closed-routing entries. The earlier algorithm/recognition titles or abstracts
cannot replace those readings. No mathematical proof route is retired on
the basis of a failed source retrieval.

As a separate logical illustration, the diamond graph with edges
`ab,ac,bc,bd,cd` has bags `{a,b,c}` and `{b,c,d}` and exactly one undirected
Hamiltonian cycle, `a,b,d,c,a`: the degree-two vertices a,d force those four
cycle edges. Its degrees are 2,3,3,2, so it is **not quartic** and is no
counterexample to C or P. This only shows why recognizing width at most
four, on its own, cannot exclude unique Hamiltonian cycles.
The inspected Jacobian operation `graph.tree_decomposition.width.compute`
returned width two and bag sizes 3,3 for this explicit decomposition. Its
discovery, contract, exact payload and typed output are preserved in
`jacobian/partial-four-decomposition.*.json`: server 0.14.0, protocol
2025-11-25, adapter exit zero, no timeout or structured error. Edge coverage,
the two-node decomposition and the unique cycle were separately checked.
This bounded illustration is not a replacement for the missing primary
propositions or for publication certification.

The substantive outcome of this follow-up is a **primary-source access
blocker**, not a new theorem or a certified novelty claim. Further progress
requires a legally obtained body text containing the relevant propositions
and a statement-specific comparison, followed by Host independent originality
and significance assessment. Until then the accepted correctness result
stands and `PUB3167-TW4` remains open for Planner replanning.

### A stronger claimed complexity consequence is not this proof

Barish and Suyama, *Randomized Reductions and the Topology of Conjectured
Classes of Uniquely Hamiltonian Graphs* (2020), doi:10.2197/ipsjjip.28.876,
[original journal PDF](https://www.jstage.jst.go.jp/article/ipsjjip/28/0/28_876/_pdf/-char/en),
Theorem 1, p. 877, Theorem 5, p. 885 with proof on p. 887, and Section 3,
p. 887, is a particularly relevant comparison. The full source is archived
as `literature/barish-suyama-2020.pdf` and `.txt`.

Theorem 1 states a parsimonious-reduction equivalence for the unrestricted
quartic conjecture. Theorem 5 begins "Unless NP = RP" and claims a restriction
on containment of hypothetical counterexample sets in recognizable classes
with tractable Hamiltonian-cycle decision. Section 3 explicitly discusses
bounded treewidth. Thus it is not appropriate to report that the literature
contains no bounded-width-related obstruction at all.

Even the strongest reading of that published conditional claim does not
supply the unconditional C or P: NP != RP is not an established premise of
this proof. In addition, invoking its reduction on a seed of width four would
require establishing the relevant property for the satisfiable reduction
images; neither seed treewidth nor a polynomial recognition algorithm alone
establishes width preservation by its gadgets. This is a scope comparison
and a proof-reading question for the independent Reviewer, not a new
complexity theorem, an accepted correction of the paper, or an assumption
used in the separating invariant.

### Attribution of the computer-assisted machinery

The following primary texts were opened by the bounded literature reader.
Their locators refer to the exact linked versions. None reports C or P in
the propositions inspected.

| Primary source and locator | Established machinery versus this submission |
|---|---|
| *From Width-Based Model Checking to Width-Based Automated Theorem Proving*, [arxiv:2205.10995v3](https://arxiv.org/pdf/2205.10995v3), Theorem 18, p. 12; Appendix F, Algorithm 1, p. 30; Appendix H.8, p. 38. Related AAAI 2023 publication: doi:10.1609/aaai.v37i5.25775. | Universal bounded-width testing and degree/pairing Hamiltonian DP states are precedents, not innovations claimed here. The Hamiltonian core is existence-preserving; its witness-set multiplicity is not a count of edge-set Hamiltonian cycles. A theorem that decides inclusion does not assert that the particular inclusion C or P holds. Numbering and authorship of the revised arXiv text are not silently assigned to the earlier conference version. |
| Oliveira and Urmian, *State Canonization and Early Pruning in Width-Based Automated Theorem Proving*, [arxiv:2605.11025v1](https://arxiv.org/pdf/2605.11025v1), Section 5.4, Algorithm 1, pp. 22-23; Theorem 29, p. 24; Theorem 34, p. 30. | State canonization and exhaustive joins under relative interface permutations are prior methods. The premise-pruning theorem requires a subgraph-closed premise. Exact quartic regularity and P's exact degree constraints are not subgraph-closed, so that theorem does not by itself justify this live projection or establish this separating invariant. |
| De Wulf, Doyen, Henzinger and Raskin, *Antichains: A New Algorithm for Checking Universality of Finite Automata* (2006), doi:10.1007/11817963_5, [author PDF](https://lsv.ens-paris-saclay.fr/~doyen/papers/antichains-universality-cav06.pdf), Section 3, Theorems 2-3, PDF pp. 5-6. | Keeping minimal state subsets in a fixed-point universality test is standard antichain machinery. This word-automaton theorem has no quartic graph, binary-join or Hamiltonian-count conclusion. The author PDF is not internally version-dated. |
| Bouajjani, Habermehl, Holik, Touili and Vojnar, *Antichain-based Universality and Inclusion Testing over Nondeterministic Finite Tree Automata* (2008), doi:10.1007/978-3-540-70844-5_7; [FIT-TR-2008-001, modified 17 July 2008](https://www.irif.fr/~haberm/Publications/bhhtv-nartmc-tr-08.pdf), Section 3, Theorem 1, report p. 4; Section 4, Theorem 2 and the (p,s) order, report pp. 6-7. | A distinguished run paired with a support, ordered by support inclusion at fixed distinguished run, is a particularly close precedent. Branching tree-automaton inclusion is not a new general idea here. Its theorem still requires the language-specific semantics and successful separating calculation needed to obtain C or P. |

Accordingly the proposed contribution is the **specific exact count-one
exclusion theorem and its closed separating collection**, with the
degree-aware liveness and support interpretation proved for this algebra.
It is not priority for tree-decomposition DP, pairing states, automata
inclusion, antichains, symmetry reduction, two-copy gluing, or independent
computer replay. P is equivalent to the quartic obstruction at this width
through the accepted reduction; it is not counted as an independent second
breakthrough simply because it has a different statement.

### Significance and the remaining publication requirement

The positive mathematical improvement over the preceding accepted campaign
result is already established: sound reductions and failed predicates have
become an exact all-orders exclusion. If original, C gives an unconditional
structural obstruction at the first feasible treewidth, hence any hypothetical
simple quartic uniquely Hamiltonian graph must have treewidth at least five.
The induction covers arbitrarily branching decompositions and unbounded
order. That is qualitatively different from the inspected order-21 check
and from a theorem requiring planarity or claw-freeness.

This is a significance argument for review, not an independently awarded
publication judgement. In particular, the earlier nonplanarity examples
alone overstate no priority: K5 is already covered by Seamone's claw-free
theorem, and K4,4 by the parity-derived sufficient condition.

A further checked illustration also shows why hypothesis failure is not
enough. Form a graph on u,v, A1,...,A4, B1,...,B3, C1,...,C4 with all edges
of K4,3 between A and B, all edges of the clique on C, and

    uA1, uA2, vA3, vA4, uC1, uC2, vC3, vC4.

It is simple quartic of order 13 and width four: it glues split-K4,4 and
split-K5 along their degree-two terminals using the accepted common-bag
construction. It contains K3,3 and an induced claw, and odd order forces
an odd complementary-2-factor component. Its explicit Hamiltonian cycle is

    u,A1,B1,A2,B2,A3,B3,A4,v,C4,C3,C2,C1,u.

Nevertheless `{A1,A2,A3,A4,C1,C4}` is independent on that cycle and
dominates its edge complement. Thus this illustration, too, is covered by
a known sufficient mechanism. It is not evidence of coverage outside the
union of known mechanisms or of verified novelty.

The separately inspected Jacobian contract `graph.cycle.fixed_length.decide`
was used once, with length four on K4,4, solely to illustrate that the target
does not impose chordality. It returned `a1,b1,a2,b2`; all four edges and both
absent diagonals were checked against the exact payload. Discovery, contract,
payload and typed output are in `jacobian/publication-*.json`, with server
0.14.0, protocol 2025-11-25, adapter exit zero and no timeout or structured
error. This is a finite induced-cycle illustration, not multiplicity,
all-orders evidence, or a new exclusion theorem. No nearby adapter operation
was used to stand in for the invariant or publication assessment.

The Planner's earlier focused search found no matching inspected primary
theorem; that limitation is retained, not reinterpreted as novelty
verification. The Sanders article/thesis and Arnborg-Proskurowski full texts
remain unexamined after the targeted source-access attempts documented above,
and the Seamone numbered theorem was not obtained.
The exact open acceptance requirement is a **Host-invoked independent
Reviewer judgement of originality and publishable or doctoral significance
for C and P**, considering the comparisons and access limitations above.
Neither corrected status labels, this Engineer assessment, a bounded search
miss, nor the standard machinery discharges it. `PUB3167-TW4` records that
sole open frontier in the proof graph. Unrestricted Sheehan remains open.

To replay the certificate, with only the campaign's Python sources:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/verify_marked_closure.py research/marked_support.frontier.json \
  --output research/marked_support.closure.json
```

For the newly checked membership of the previously accepted reachable
examples:

```sh
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/marked_support.py examples research/marked_support.frontier.json \
  --output research/marked_support.examples.json
```

This is an independently accepted computer-assisted finite-certificate proof
using exact integer arithmetic, not a Lean formalization or an earned kernel
verdict. The proof, certificate and checker are unchanged. The next gate is
Host independent assessment of originality and publishable significance;
the accepted correctness and statement-fidelity checks are not repeated.
