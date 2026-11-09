# Quartic graphs of treewidth at most five

## Statement and status

**Theorem (independently accepted computer-assisted proof).**
Every finite simple 4-regular Hamiltonian graph of treewidth at most five
has at least two distinct undirected Hamiltonian cycles.

A Hamiltonian cycle means a spanning connected 2-regular edge set; rotation
and reversal do not create different cycles. Decompositions may branch
arbitrarily. There is no graph-order bound or restriction to pathwidth.

The finite closure certificate below completed with exit zero on
2026-11-04. The proof combines that certificate with the elementary
normal-form and completion-profile arguments in `normal_forms.md` and
`hamilton_liveness.md`. Host Reviewer `reviewer:5d2c5ac4181e` independently
accepted the all-orders exclusion and complete closure in the **done**
verdict at
`/home/argustest/zimo/.argus-campaign-3167-run6/projects/71e5fa67df17/handoffs/5d2c5ac4181e/round-0002.json`.
The existing ledger also contains that Reviewer's supporting judgements
for this theorem, completion-profile composition, proper-adhesion
normalization and the exact separating carrier. This is independent
correctness acceptance, not a Lean/kernel certificate or a publication
verdict. Originality and publishable significance remain unverified.

**Corollary.** Any finite simple 4-regular uniquely Hamiltonian graph,
if one exists, has treewidth at least six.

This follows immediately by contraposition. Neither the theorem nor
the corollary resolves the unrestricted quartic case or asserts an
exclusion at treewidth six.

## Certificate and its exact meaning

The input is
`profile_certificate/runs/batch-feedback2-full/frontier.snapshot.json`.
Its SHA-256 is
`e60b440f0cf4f67777e73cdc9854ced621b08decacd0fa89a4b2b278a57b657e`.
It is a stable read-only construction DAG, not a live producer checkpoint.
The recorded result is
`profile_certificate/runs/batch-feedback2-full/exact-result.json`, SHA-256
`372427e968302402e370c03326ed2350b5dff9fcaf3936bba084cd017df0680b`.
The durable task `tw5-batch-feedback2-full-scan`, run
`tw5-batch-feedback2-full-scan-1793795570247102595`, finished normally;
its original receipt and completion record are beside the result.

| Exact obligation | Completed result |
| --- | ---: |
| Construction rows, including inactive ancestors | 809,003 |
| Active pointed rows | 152,441 |
| Full positive entries replayed, including closed entries | 88,107,797 |
| Positive closed entries replayed | 4,511,409 |
| Legal unary operations | 1,879,078 |
| Same-boundary bundle pairs accounted | 209,969,712 |
| Required proper-adhesion pairs completed | 35,112,499 |
| Required relative boundary orders accounted | 25,209,843,635 |
| Uncovered unary or binary targets | 0 |
| Empty-boundary closed unit markers | 0 |

Leaf coverage also passes. The routing catalog sizes for zero through six
terminals are `2,3,6,15,44,143,500`. Every construction uses actual simple
boundary edges, degree-four forgetting and disjoint interiors at joins.
Clipped counts in `{0,1,2}` are independently reconstructed, not inferred
from producer flags. Here two means at least two. Every row's full positive
support and its genuine count-one marker are verified, including inactive
ancestors. No positive closed routing is discarded.

The largest witness graph has 19 vertices. This is a property of the
finite representatives, **not** a graph-order bound in the theorem.

The checker derives its own DSU routing tensor, unary images, completion
relation, coverage index, boundary actions and relative-order orbit covers.
It imports catalog descriptors, checking their validity, distinctness and
complete cardinalities, not producer transition or dominance routines.
Full-support symmetries transport individually realized unit markers;
they are not assumed to preserve a single witness's whole count vector.
Boundary-only and closed-marked operands remain in the binary domain.
All smaller-boundary unary feedback is unrestricted.

The required join domain contains every relative order whenever at least
one operand has an isolated boundary vertex. The other 174,857,213 bundle
pairs are dense pairs outside this sufficient operation domain, not
silently checked joins. Their sufficiency follows from the normal-form
lemma, not from a computational assertion about their outputs.
Within the required domain, illegal degrees and repeated actual edges
are explicitly accounted. Validated orbit representatives account for
every remaining order with its exact orbit size.

## All-orders deduction

Write a pointed state as `(g,A,q,S)`: underlying boundary degrees, actual
boundary edges, a routing of count one, and the full positive live support.
For exterior routing type `t`, let `K(q,t)` mean that the two routings
join into one spanning cycle. Put

    N(S) = union of {t : K(r,t)} over r in S,
    U(q,S) = {t : K(q,t) and not K(r,t) for every r in S except q}.

A representative at the same `g,q` has `A' subset A`,
`N(S') subset N(S)` and `U(q,S) subset U(q,S')`, up to boundary relabeling.
These are comparisons of full supports, not replacements of supports
by their completion masks.

For a nonnegative exterior count vector `w`, the marked continuation is
unique precisely when some `t in U(q,S)` has `w[t]=1` and every other
entry of `w` on `N(S)` is zero. Thus the representative relation preserves
every unique marked continuation. A missing original unique neighbor
or a new positive neighbor is detected by a singleton or two-entry
exterior vector, respectively, so this interpretation yields both
profile inclusions after composition.

More explicitly, at a unary operation or join with a unit marked output
having nonempty `U`, absorb the operation and any other operand into an
exterior vector for one input. Nonnegative edge-set counting forces a
unit input contribution. Replacing that input preserves every unique
marked completion; at a join, repeat for the other input. The original
marked routing contribution survives. A singleton unique exterior
forces its new coefficient to remain one. Varying the exterior gives
the output-profile inclusions. Fixed underlying degrees and actual-edge
inclusion preserve operation legality, and every contribution used by
a quartic completion survives the live projection. This is the
composition lemma proved in `hamilton_liveness.md`.

Suppose now that a graph in the theorem had exactly one Hamiltonian
cycle. Contract every decomposition edge whose bags are contained one
in the other. Adjacent remaining bags are incomparable. Lift a child
bag `Y` to its parent bag `X` by first forgetting `Y \ X`, then
introducing `X \ Y`. Running intersection makes the forgotten vertices
already degree four and the introduced vertices isolated. Since
`X \ Y` is nonempty, joining this child to the accumulated parent is a
proper-adhesion join. Assign graph edges once to containing bags and
combine children successively. Every bag has at most six vertices;
at the root, forget the remaining vertices at degree four. This is
an exact construction of the original graph, including arbitrary
branching, as proved in `normal_forms.md`.

At every construction subtree the restriction of the unique cycle has
count one and nonempty `U`: its actual exterior witnesses a unique
completion, and any second interior selection of the same routing
would yield a second full cycle. The leaf is covered. Inductively replace
child restrictions by carrier representatives using the composition
lemma; the certified unary or proper-adhesion join coverage supplies
the next representative. All boundary relabelings are accounted for.
At the root this supplies an empty-boundary closed unit marker in the
carrier. The exact certificate excludes that marker, a contradiction.
This proves the stated all-orders implication from the verified finite
certificate. QED.

## Reproduction

The actual successful checker command, run from
`profile_certificate/runs/batch-feedback2-full`, was:

```bash
ROOT=/home/argustest/zimo/counterexample-batch-1/campaigns/3167
PY=/home/argustest/zimo/argus-live-update/.venv/bin/python
PYTHONPATH="$ROOT" "$PY" -B -m research.treewidth_five.profile_certificate \
  --input frontier.snapshot.json --output exact-result.json \
  --collect-gaps 32768 --certify-if-closed
```

The optional gap collector certified only its fresh complete zero-gap
in-memory scan after all mandatory prerequisites. Its cap was not reached.
No old diagnostic was relabeled, no generator cursor was trusted, and no
unchanged full scan was repeated. Elapsed replay-plus-check time was
561.501 seconds; this is one scoped observation, not a performance bound.

For an independent rerun, preserve the original result and use a separate
run directory. The standard no-collection checker checks the same
mathematical obligations without the single-pass wrapper:

```bash
ROOT=/home/argustest/zimo/counterexample-batch-1/campaigns/3167
PY=/home/argustest/zimo/argus-live-update/.venv/bin/python
mkdir -p "$ROOT/research/treewidth_five/profile_certificate/runs/independent-final"
cd "$ROOT/research/treewidth_five/profile_certificate/runs/independent-final"
"$PY" -B -m argus_skill.tools.subagent submit \
  --task-id tw5-independent-final --mode direct --timeout 7200 --cwd "$PWD" \
  --command "PYTHONPATH=$ROOT $PY -B -m research.treewidth_five.profile_certificate --input ../batch-feedback2-full/frontier.snapshot.json --output exact-result.json"
```

Preserve the returned task/run/check-with receipt. A runner timeout or
unfinished schedule is not a mathematical conclusion. Exit zero requires
the full finite operation certificate, not an accepted theorem verdict.

The checked implementation SHA-256 values are:

| Source | SHA-256 |
| --- | --- |
| `profile_certificate/bulk.cpp` | `07f02f1de08a028c6792588604ef36948a9b59d40b898041595708604809c01b` |
| `profile_certificate/bulk.py` | `1ede33a1d47bd6d14a78a9b0cc62ec763d2070bc2d26dcbefec99b3c044feadd` |
| `profile_certificate/__main__.py` | `11caede1dcbcbb52a172b621e167d284426507cfd41da6261544b5d09deda6f1` |

## Improvement over the preceding accepted result

The preceding independently accepted campaign theorem excluded treewidth
at most four. The newly accepted argument raises that bound to five for arbitrary
branching, rather than only adding a pathwidth-five corollary. The 3-by-3
rook graph and arbitrarily large quartic chains in `pathwidth_five.md`
have exact treewidth five, showing that the added parameter class is
genuine; they are not counterexamples or novelty evidence.

The immediately preceding complete carrier scan found 58 distinct binary
gaps. Literal feedback for all 58, plus every consequent unary operation,
created 77 construction rows and produced this closed carrier. Earlier
marker 342 is covered; neither its numerical label nor insertion of one
marker was treated as closure of an entire output family.

The accepted treewidth-four proof and Reviewer verdicts remain unchanged.
The complete width-five closure and all-orders deduction have now also
passed Host independent correctness review. No further producer search,
snapshot regeneration or unchanged closure replay is needed for this
publication comparison.

## Primary-source comparison

The following comparison concerns exactly the unconditional, finite,
simple, quartic, arbitrary-branching theorem above. Literature baselines
are not external assumptions of its proof. The prior source ledger and
independent citation readings remain intact.

### Structural and bounded-width exclusions

| Inspected statement and source | Precise relationship to this theorem |
| --- | --- |
| Barish and Suyama, *Randomized Reductions and the Topology of Conjectured Classes of Uniquely Hamiltonian Graphs*, JIP 28 (2020), 876-888, [doi:10.2197/ipsjjip.28.876](https://doi.org/10.2197/ipsjjip.28.876), Theorem 1, p. 877; Theorem 5, p. 885, proof and Section 3, p. 887. Full journal text is archived in `../literature/barish-suyama-2020.pdf` and `.txt`. | Theorem 1 relates existence of a quartic uniquely Hamiltonian graph to a parsimonious reduction from #SAT to counting quartic Hamiltonian cycles; its target is not restricted to partial 5-trees. Theorem 5 begins "Unless NP = RP" and states a restriction on containment of hypothetical counterexample sets in polynomial-time recognizable classes with polynomial-time Hamiltonicity decision. Its proof discusses one or more counterexamples, and Section 3 explicitly applies the discussion to bounded treewidth. As published, specializing that conditional statement to treewidth at most five gives substantive conditional overlap. The present theorem is unconditional. This comparison neither independently endorses nor corrects that paper's proof and assumes no treewidth preservation by its reduction gadgets. |
| Bondy and Jackson, *Vertices of Small Degree in Uniquely Hamiltonian Graphs* (1998), doi:10.1006/jctb.1998.1845; inspected reproduction in [arxiv:1812.05650v2](https://arxiv.org/pdf/1812.05650v2), Introduction, p. 2, and [arxiv:2104.10020v2](https://arxiv.org/html/2104.10020v2), Section 1. | The known planar small-degree conclusion already excludes planar quartic uniquely Hamiltonian graphs, without a width restriction. It applies to the planar subclass here; the present theorem has no planarity hypothesis. The original paper remains unread, and the inspected reproductions are not relabeled as original-paper access. |
| Seamone, *On Uniquely Hamiltonian Claw-Free and Triangle-Free Graphs* (2015), [doi:10.7151/dmgt.1784](https://doi.org/10.7151/dmgt.1784), [journal abstract](https://eudml.org/doc/271097), pp. 207-214. | The previously inspected abstract excludes uniquely Hamiltonian claw-free graphs of minimum degree at least three. It already covers the claw-free quartic subclass at every width. No full-body or numbered-theorem verification was obtained; no broader triangle-free exclusion is inferred from the title. In particular, arxiv:1812.05650v2, Theorem 3.2, p. 8, includes a girth-five nearly cubic uniquely Hamiltonian graph, not a quartic counterexample. |
| Goedgebeur, Jooken, Lo, Seamone and Zamfirescu, [arxiv:2211.08105v1](https://arxiv.org/html/2211.08105v1), Section 4, Theorem 4, and Section 4.2; locally retained in `../literature/goedgebeur-et-al-2022.excerpts.txt`. | The reproduced Thomassen condition requires a vertex set independent on a fixed Hamiltonian cycle and dominating its edge complement. It guarantees another cycle, but the same source reports failure for prescribed cycles even in K5. It is not a universal bounded-width exclusion. No claim is made that the width-five class escapes the union of all known sufficient mechanisms. |
| Goedgebeur, Meersman and Zamfirescu, *Graphs with few hamiltonian cycles*, journal doi:10.1090/mcom/3465; inspected [arxiv:1812.05650v2](https://arxiv.org/pdf/1812.05650v2), 15 July 2019, Observation 3.9 and Table 3, p. 15. Full version is retained in `../literature/goedgebeur-meersman-zamfirescu-2020.pdf` and `.txt`. | The quartic verification through order 21, or order 26 with girth at least five, is finite verification, not the present all-orders implication. These are comparison bounds from the inspected version, not an assertion of the latest finite-search record. |
| Thomason (1978), original author scan `../literature/thomason-1978.pdf`, Corollary 1.2, p. 261; Haxell, Seamone and Verstraete (2007), doi:10.1002/jgt.20205, inspected reproduction in [arxiv:2304.08946v6](https://arxiv.org/html/2304.08946v6), Section 1. | Odd-degree parity and the regular-degree bound starting at 23 do not give the quartic theorem. The parity-derived sufficient condition when a fixed quartic Hamiltonian cycle has an all-even complementary 2-factor is established prior machinery, not a new exclusion claimed here. The original Haxell-Seamone-Verstraete access limitation remains unchanged. |

The scope is partial 5-trees, not only maximal 5-trees. For comparison,
a 5-tree on n >= 6 vertices has 5n-15 edges; quarticity would require
5n-15 = 2n, hence n = 5, outside that range. Thus there are no quartic
maximal 5-trees under this convention. That vacuity says nothing about
the quartic partial 5-trees covered by this theorem.

### Bounded-width algorithms and established proof machinery

| Primary statement and exact version | Attribution and implication boundary |
| --- | --- |
| Courcelle, *The monadic second-order logic of graphs III: tree-decompositions, minors and complexity issues* (1992), [doi:10.1051/ita/1992260302571](https://doi.org/10.1051/ita/1992260302571), [full text](https://www.numdam.org/item/ITA_1992__26_3_257_0.pdf), Section 3, Proposition 3.1, pp. 274-275. | Bounded-width model checking is prior work. An algorithm deciding a predicate for each input graph does not itself assert the universal quartic count-one exclusion. |
| Oliveira and Urmian, *From Width-Based Model Checking to Width-Based Automated Theorem Proving*, [arxiv:2205.10995v3](https://arxiv.org/pdf/2205.10995v3), 15 September 2024, Theorem 18, p. 12; Appendix F, Algorithm 1, p. 30; Appendix H.8, p. 38. Related earlier conference publication: doi:10.1609/aaai.v37i5.25775. | Universal bounded-width inclusion testing and Hamiltonian degree/pairing states are established. The theorem requires a finite, internally polynomial, coherent treelike DP-core. Its Hamiltonian local-witness multiplicity is not the number of Hamiltonian edge sets, and existence-preserving cleaning need not preserve cycle counts. The conference paper is not assigned the revised preprint's numbering. |
| Oliveira and Urmian, *State Canonization and Early Pruning in Width-Based Automated Theorem Proving*, [arxiv:2605.11025v1](https://arxiv.org/pdf/2605.11025v1), 10 May 2026, Section 5.4, Algorithm 1, pp. 22-23; Theorem 29, p. 24; Theorem 34, p. 30. | Canonization and relative-interface-permutation join saturation are prior methods. Theorem 29 has finiteness, coherence, interface, cleaning and witness-action hypotheses. Theorem 34 additionally requires a subgraph-closed premise; exact quarticity is not subgraph closed, so its premise-pruning conclusion cannot simply be substituted for the present liveness proof. |
| De Wulf, Doyen, Henzinger and Raskin, *Antichains: A New Algorithm for Checking Universality of Finite Automata* (2006), doi:10.1007/11817963_5, [author PDF](https://lsv.ens-paris-saclay.fr/~doyen/papers/antichains-universality-cav06.pdf), Section 3, Theorems 2-3, pp. 5-6; Bouajjani, Habermehl, Holik, Touili and Vojnar (2008), doi:10.1007/978-3-540-70844-5_7, [FIT-TR-2008-001, revised 17 July 2008](https://www.irif.fr/~haberm/Publications/bhhtv-nartmc-tr-08.pdf), Section 3, Theorem 1, p. 4, and Section 4, Theorem 2 and the (p,s) order, pp. 6-7. | Inclusion-extremal supports and distinguished-run/support antichains, including for branching tree automata, are established machinery. Their general inclusion theorems do not assert this language-specific quartic Hamiltonian-count conclusion. |

The proposed contribution for publication assessment is the **specific
unconditional width-five count-one exclusion and its exact separating
carrier**, improving the accepted width-four bound. Its proof uses the
full-support N/U completion-profile interpretation, legal actual-edge
inclusion, and proper-adhesion normalization to certify the necessary
six-terminal operation domain while retaining arbitrary branching and
all live closed entries. This identifies the mathematical specialization
and successful separating calculation; it does not assert that these
ingredients, individually or together, have verified priority.

No priority is claimed for tree-decomposition DP, path-pairing states,
automata inclusion, antichains, symmetry reduction, contracting comparable
bags, two-copy gluing or independent computer replay. Two-copy gluing
already appears, for example, in arxiv:1812.05650v2, Theorem 3.5,
pp. 11-12, and is not an additional breakthrough here.

### Unread sources and the remaining publication gate

The exact access record in `../treewidth_four_theorem.md` is preserved:
Sanders' 1996 recognition article (doi:10.1137/S0895480193243043) has only
an inspected deposited abstract; its publisher body returned HTTP 403.
His 1993 dissertation (hdl:1853/30061) supplied metadata but not text:
the advertised download returned HTML, and the original and extracted-text
content endpoints returned HTTP 401. Arnborg-Proskurowski's 1989
partial-k-tree paper (doi:10.1016/0166-218X(89)90031-0) supplied no inspected
body proposition after the previously recorded legal location attempts.
Their exact implications for multiplicity, degree constraints and width
therefore remain unexamined. Titles and recognition abstracts do not
establish either subsumption or non-subsumption.

This cycle's bounded source reader inspected the conditional bounded-width
statement and the primary propositions identified above, with **no
inspected matching unconditional all-orders width-five theorem found**.
That is the outcome of a focused comparison, not novelty verification.
Six distinct new public-source locations were requested, including the
primary method texts; a truncated extraction required one narrower fetch.
Two new lawful Seamone locations failed: the DMGT article endpoint
`https://www.dmgt.uz.zgora.pl/publish/article.php?doi=10.7151/dmgt.1784`
at transport level and `https://sciendo.com/pdf/10.7151/dmgt.1784` with
HTTP 404. None of the previously unsuccessful Sanders,
Arnborg-Proskurowski, Bondy-Jackson or Haxell-Seamone-Verstraete endpoints
was retried. Unread sources and failed retrieval neither establish nor
refute originality.

The Jacobian adapter's focused discovery returned bounded graph-existence,
exact-cover, Eulerian-decomposition, matrix-factorization and canonization
operations, not a source-comparison contract. Its exact discovery output
and adapter status are in
`../literature/tw5-jacobian-discovery.json`. No nearby finite operation was
forced onto the publication question; this discovery has no mathematical
or originality conclusion. Earlier theorem-relevant adapter evidence is
unchanged.

If original, the all-orders, arbitrary-branching exclusion and resulting
treewidth-at-least-six obstruction give a structural strengthening rather
than a larger finite search. That is the significance argument submitted
for assessment, not an independently awarded publication judgement.
**PUB3167-TW5 remains open:** the next required action is Host-invoked
independent assessment of `novelty_status=verified_new` and
`significance_status=publishable` or `doctoral` for the accepted theorem.
A literature report, a successful structural checker, or the already
accepted correctness verdict alone cannot discharge that gate.

### Reviewer-requested Arnborg-Proskurowski body comparison

The subsequent publication review remained inconclusive and requested
the actual partial-k-tree Hamiltonicity body statements before resubmission.
The accepted mathematical theorem and its certificate are unchanged.
The following continuation on 2026-11-04 tested newly identified public
source routes rather than replaying closure or repeating the earlier
failed KTH, DiVA, Academia, OpenAlex or Semantic Scholar requests.

| Newly inspected source or request | Decisive observation |
| --- | --- |
| [Publisher-deposited Crossref record](https://api.crossref.org/works/10.1016/0166-218X%2889%2990031-0) | Identifies the version of record, Discrete Applied Mathematics 23(1) (1989), 11-24, and advertises Elsevier article-retrieval links. Its open-archive license metadata is a source-location lead, not a body statement. |
| [Advertised publisher XML endpoint](https://api.elsevier.com/content/article/PII:0166218X89900310?httpAccept=text/xml) | Returns `coredata` with the correct DOI/title and `openaccessArticle=true`, but no article body. Open-access metadata does not establish that the text was obtained. |
| [Explicit full-body view](https://api.elsevier.com/content/article/PII:0166218X89900310?view=FULL&httpAccept=text/xml) and [official retrieval contract](https://dev.elsevier.com/documentation/ArticleRetrievalAPI.wadl) | The full view returns HTTP 401. The official contract distinguishes default metadata from `FULL` and requires an API key with applicable entitlement; a key alone does not grant content access. No key, token or entitlement was supplied or sought from unrelated resources, and no alternate format was used to evade the denial. |
| [Public ScienceDirect PDF route](https://www.sciencedirect.com/science/article/pii/0166218X89900310/pdfft?isDTMRedir=true&download=true) | This distinct PDF request returned HTTP 403. The earlier failed article-page request was not repeated. No PDF text was obtained. |
| Proskurowski's [research page](https://ix.cs.uoregon.edu/~andrzej/research.html), [treewidth page](https://ix.cs.uoregon.edu/~andrzej/treewidth.html) and [recent publications](https://ix.cs.uoregon.edu/~andrzej/pubs.html) | Public pages were read. They lead back to the previously examined older publication list, not to this paper's body. The separate public `pubs/` directory index returned HTTP 403; no file names were guessed to bypass that denial. |
| [Internet Archive metadata for the exact April 1989 issue](https://archive.org/metadata/sim_discrete-applied-mathematics_1989-04_23_1) | The journal, volume 23 and issue 1 match. Metadata marks `access-restricted-item=true`; both the issue PDF and its OCR text have `private=true`. No restricted PDF, OCR, image or alternate server was requested. This locates a scan, not lawfully available body text. |

Targeted source-location searches also supplied no body text; a citation
report and papers citing this article are not substituted for it. No
numbered Hamiltonicity proposition, recurrence or reduction from
Arnborg-Proskurowski has been read in this continuation.

**The requested comparison is therefore still blocked, not resolved.**
The missing reading is the actual Hamiltonicity algorithm and its
hypotheses: whether it only decides or constructs a cycle, computes
multiplicity or uniqueness, or includes structural reductions that
preserve the relevant degree, simplicity and cycle-count conditions.
Those are questions to put to the body, not claims about its unseen
contents. Neither an algorithmic title nor the unavailable text proves
that the present theorem is subsumed or original.

The reactivation condition is a lawful public or operator-provided body
copy, or access explicitly authorized for this project. The relevant
passage must then be read with its hypotheses and compared statement by
statement before Host independent originality/significance assessment.
The existing public publication judgements remain inconclusive.
Publication certification has **not** been completed, no mathematical
bound advanced in this continuation, and no unchanged retrieval or
closure replay should be launched to stand in for the missing source.
