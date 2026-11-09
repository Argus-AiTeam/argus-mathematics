# Exact cycle--clique Ramsey numbers: semantic certification and proof replay

## Abstract

We report a machine-checked verification of the full statement of
*Cycle--clique Ramsey numbers*, not a new Ramsey formula. For all integers
`m >= n >= 3`, the least order forcing a non-induced cycle on exactly `m`
vertices or an independent set of size `n` is `(m-1)(n-1)+1`, with value six
at `(3,3)`. The manuscript's public source already contains a complete
formalization. We reuse its proof and finite certificates, rebuild the
selected 183-module dependency closure in Lean 4.31.0, and supply an explicit
semantic bridge from injective vertex maps to its graph-containment
definitions. The bridge also establishes least forcing order, the integer
quantifiers, and the exceptional case. Separately proved compatibility
propositions permit the replay without changing the frozen mathematical
source. Both claim-bound compiler certificates have no proof holes and
only the permitted classical axioms. An earlier independent review accepted
the technical certification. Whether this independently authored bridge
and replay constitute a publishable verification contribution remains a
separate, unresolved scientific judgement.

## 1. Statement and mathematical meaning

For a finite simple graph `G`, let `Cyc(G,m)` mean that there is an injective
map `f : Fin m -> V(G)` such that

$$
 f(i)f(i+1\bmod m)\in E(G)\qquad(i\in\operatorname{Fin}(m)).
$$

There are exactly `m` distinct cycle vertices; chords are allowed. Let
`Ind(G,n)` mean that an injective map `g : Fin n -> V(G)` has pairwise
nonadjacent images. Define

$$
 P(m,n,N):=\forall G\text{ on }\operatorname{Fin}(N),\
               \operatorname{Cyc}(G,m)\ \lor\ \operatorname{Ind}(G,n).
$$

The complementary edges of `G` are the second color of a coloring of
`K_N`, so `Ind(G,n)` is precisely a complementary `K_n`. Write
`Least(m,n,N)` for `P(m,n,N)` together with
`not P(m,n,M)` for every natural `M < N`.

**Theorem 1 (the manuscript's theorem, verified here).** For every pair of
integers `m,n` with `n <= m` and `3 <= n`, put

$$
 A(m,n)=
 \begin{cases}
  6,&(m,n)=(3,3),\\
  (m-1)(n-1)+1,&\text{otherwise}.
 \end{cases}
$$

Then `Least(m,n,A(m,n))`. In particular `R(C_m,K_n)=A(m,n)`.
There is no upper bound on the quantified parameters. The theorem does
not assert the same formula for `m < n`, for cycles of length at most `m`,
or for induced cycles.

The formal declaration `Audit189.complete_integer_verification` proves
the least-order assertion on the natural images of these positive
integers and the displayed formula in integer arithmetic.
`Audit189.all_parameters` gives the natural-number version.

### 1.1 Independent semantic bridge

**Proposition 2 (checked correspondence).** For every vertex type, every
simple graph `G`, and every natural `m >= 3`,

$$
 \operatorname{Cyc}(G,m)
 \ \Longleftrightarrow\
 \texttt{cycleGraph}\ m\ \text{is contained in }G.
$$

For every natural `n`, without a lower-bound hypothesis,

$$
 \operatorname{Ind}(G,n)
 \ \Longleftrightarrow\
 K_n\ \text{is contained in }G^c.
$$

Here containment means an injective adjacency-preserving map, not an
induced embedding.

**Proof.** The edges of `cycleGraph m` join consecutive residues in either
direction. A witness for `Cyc` preserves these edges by symmetry of
adjacency; conversely a containment map preserves every successor edge,
including the closing edge. Its injectivity supplies distinct vertices.
For the second assertion, distinct images of distinct vertices are
adjacent in `G^c` exactly when they are not adjacent in `G`. Equal indices
introduce no extra condition because `G` is loopless. These arguments are
the proofs of `Audit189.cycle_copy_iff` and
`Audit189.independent_copy_iff`. They imply `Audit189.forcing_iff` for
every `N` and `n`, assuming only `m >= 3`. The compiled example
`Audit189.chorded_cycle_witness` exhibits a four-cycle in `K4`, making the
non-induced interpretation explicit.

Define `ramsey(m,n)` to be the natural infimum of forcing orders.
The preceding equivalences identify it with the upstream
`cycleCliqueRamsey`. The infimum of an empty subset of the naturals is
zero, so equality of infimum expressions alone would not prove least
forcing. Here the upstream formula gives the strictly positive value
`A(m,n)`. Consequently the set of forcing orders is nonempty;
`Nat.sInf_mem` proves forcing at that value, and `Nat.sInf_le` rules out
every smaller forcing order. This is the explicit proof in
`Audit189.least_forcing_nat`. Positivity of `m,n` also justifies
`Int.toNat` and removes any issue with truncated natural subtraction.
These are semantic and arithmetic bridges, not a second proof of the
upstream upper bound.

### 1.2 Lower bound and exceptional boundary

The graph consisting of `n-1` disjoint cliques of order `m-1` has
`(m-1)(n-1)` vertices. A cycle lies in one connected component and thus
cannot have `m` distinct vertices. An independent set takes at most one
vertex from each component and thus cannot have size `n`. Restrictions
of this graph witness failure of forcing at every smaller order.
The source declarations `ramsey_lower_counterexample` and
`ramsey_property_lower_bound` implement this standard lower bound.

For `(3,3)`, the five-cycle and its complement are triangle-free. On six
vertices, any vertex has three neighbors in one color. An edge of that
color within the chosen triple makes a monochromatic triangle with the
vertex; otherwise the triple is a triangle of the other color. Hence the
least order is six. The upstream declaration `exceptional` supplies the
formal proof. The independent Python enumeration is supplemental: the
numbers of labeled graphs avoiding both a triangle and an independent
triple at orders `0,...,6` are `1,1,2,6,18,12,0`.

## 2. Load-bearing correspondence for the upper bound

This section identifies the proof being checked; it does not claim that
the following outline replaces its formal source. All upstream
declarations below lie in namespace `OAI.CycleClique`.

Outside `(3,3)` the hypotheses imply `m >= 4`. Put `k=m-1 >= 3` and
`a_0=n-1`, so `2 <= a_0 <= k`. A failure of the proposed upper bound
has, by minimality, a counterexample for some `2 <= a <= k` on
`ka+1` vertices with no `C_(k+1)`, independence number at most `a`, and

$$
 |N_G[I]|\ge k|I|+1
 \quad\text{for every nonempty independent }I.
$$

The same hypotheses give a maximum clique of order
`max(3,floor(k/2)) <= t <= k`. The cases `k=3,4` are excluded
separately. For the other cases, optimal weighted path systems on the
clique have total outside amount `L <= k-t`. Their separation and
outside-path constraints lead either to the large-clique contradiction
when `t >= 9`, or to the finite range

$$
 5\le k\le17,\qquad
 \max(3,\lfloor k/2\rfloor)\le t\le\min(8,k).
$$

In the latter range there are 42 parameter pairs. The manuscript reports
3,099 parameter-pattern instances and no unresolved instance. These
counts describe the supplied computation; a matching count is not the
reason the upper bound is accepted. The proof needs both coverage of
optimal systems and soundness of every certificate rule.

| Obligation | Manuscript locator under `build/sections/` | Checked implementation |
|---|---|---|
| Minimality and closed-neighborhood expansion | `02-reduction.tex`, `red:smaller`, `red:expansion` | `Minimality.lean`: `expansion_of_minimality`, `minimal_expanding_counterexample` |
| Maximum-clique bounds | `03-clique-layers.tex`, `clq:bound` | `DenseCycles.lean`: `counterexample_clique_bound` |
| Cases `k=3,4` | `04-small.tex`, `small:cases` | `StructuralReduction.lean`: `reduced_small_impossible` |
| Size test, optimal path systems, and outside-path rules | `05-size.tex`, `size:test`; `06-paths.tex`, `path:interval`, `path:optimality`; `07-growth.tex` | `FiniteGraphs.lean`, `PathSystems.lean`, `OptimalSystems.lean`, and their imported path/frame lemmas |
| Terminal contradiction for `t >= 9` | `08-terminal.tex`, `terminal:classification`, `terminal:contradiction` | `LargeSystems.lean`: `LargeSystem.contradiction`; `StructuralReduction.lean`: `reduced_large_impossible` |
| Complete normalized pattern coverage | `09-finite-patterns.tex`, `finite:domain`, `finite:coverage` | `CertificateModel.lean`: `mem_patternChoices`; `PatternReduction.lean`: `finite_verified_of_patterns` |
| Certificate-rule soundness | `09-finite-rules.tex`, `09-finite-packing.tex`, `finite:procedure-soundness` | `CertificateModel.lean`: `FiniteCertificate.sound`; `PatternReduction.lean`: `PatternVerified.impossible` |
| Discharge of every finite case | `09-finite-results.tex`, `finite:results` | `Patterns*.lean`, `Certificates*.lean`; `FiniteRange.lean`: `finite_range_verified`, `finite_verification` |
| Assembly of the entire upper bound | `01-introduction.tex`, `thm:main` (target statement) | `FiniteRange.lean`: `reduced_counterexample_impossible`, `ramsey_upper`, `main`; `MainTheorem.lean`: `thm_main` |

`finite_range_verified` quantifies over every member of
`patternChoices t (k-t) []`. `finite_verified_of_patterns` obtains a
canonical realization of an optimal path system and applies a verified
certificate to it. `FiniteCertificate.sound` translates validity into
contradiction in an arbitrary graph satisfying `FiniteHyp`. Thus the
finite certificates are not being used as unverified yes/no answers.
`reduced_counterexample_impossible` assembles the small, large-clique,
and finite alternatives. Minimality then gives `ramsey_upper`; the
disjoint-clique lower bound gives `main`. The integer wrapper
`thm_main` and Proposition 2 give Theorem 1, including its exceptional
branch.

The persistent claim decomposition is `research/PROOF_GRAPH.json`.
Its overall objective remains open: technical certification and final
scientific acceptance are different obligations.

## 3. Provenance and the actual independent contribution

The implementation is pinned to public OpenAI/math commit
`4eaee87548250b2682affda7d05d947c05554bae`. Its `lean/docs/189.md`
already states the complete parameter range. Its comparator metadata
names `OAI.CycleClique.thm_main` and the three permitted axioms. The
intentionally incomplete comparator is not the solution. In particular,
the initial comparator-based description must not be interpreted as
evidence that the manuscript lacked a full formalization.

We select the transitive imports of
`OAI.Combinatorics.Ramsey.CycleClique.MainTheorem`, together with
`RamseyNumbers`. The solution entry module `Main` also imports an unused
second construction-based proof; that duplicate is not needed for this
theorem's dependency closure.

The strongest prior result is therefore already the full formula and
its formal proof, on upstream's declared Lean 4.34.1 toolchain. This
submission makes **no improvement to the numerical Ramsey bound or its
parameter range**. Its independently authored technical additions are:

1. The explicit vertex-map predicates and proved semantic equivalences,
   culminating in an unbounded integer least-order statement. Even the
   concept of least forcing order is not claimed as new: upstream
   `RamseyNumbers.lean` already defines `IsRamseyNumber`.
2. Separately proved compatibility interfaces that let the frozen proof
   compile on the required Lean 4.31.0/Mathlib environment. Each ported
   upstream source is exactly its frozen source preceded by
   `import compatibility.Main`; the theorem statements and proofs are
   otherwise unchanged.
3. A rerunnable verifier binding the selected sources, compatibility
   source, dependency artifacts, official compiler certificates, axiom
   reports, and explicitly limited boundary checks.

These are contributions to semantic certification and reproducibility,
not an independent combinatorial proof strategy or newly generated finite
certificates. The `cycleGraph_isContained_iff` compatibility proposition
is a backport from Mathlib, not original mathematics; its exact upstream
commit and source locator are acknowledged in
`compatibility/statement_fidelity.md`. Other compatibility propositions
are library facts proved locally. The unmodified older-toolchain failure
is preserved in `unmodified_build_result.json` and is a software-interface
obstruction, not a refutation.

No specific false assertion of the staged manuscript has been certified
by this submission. Absence of such a witness is not a theorem asserting
that every sentence of the manuscript is correct.

## 4. Mechanical evidence and independent reading

The existing `exact_certificate.json` records the successful selected
183-module build, the whole-statement and compatibility certifications,
the boundary checks, and campaign-local validation. The two official
claim-bound records are:

| Claim | Certificate under `research/verification_189/` | Recorded result |
|---|---|---|
| `C189_EXACT_VERIFICATION`, version 4 | `certificates/C189_EXACT_VERIFICATION-efab6f0e0cf3837d.json` | Lean 4.31.0; compiler and audit exit codes zero; `proof_holes=[]` |
| `C189_COMPATIBILITY`, version 2 | `compatibility/certificates/C189_COMPATIBILITY-a204bd712bc18ce5.json` | Lean 4.31.0; compiler and audit exit codes zero; `proof_holes=[]` |

The 20 explicitly reported upstream/bridge declarations have transitive
axiom sets contained in `propext`, `Quot.sound`, and `Classical.choice`.
The compatibility declarations are checked separately. No external
mathematical assumption remains on either current certified claim.
The historical graph-theory results discussed in the manuscript's
introduction are not assumed as unproved propositions here; the selected
formal proof dependencies supply the upper bound.

The Host-invoked review of mission `dc2de93c1b9a` accepted the complete
quantified statement correspondence, exact non-induced cycles, complement
correspondence, least forcing, exceptional value six, and fresh Lean
4.31.0 checks with permitted axioms. Its supporting ledger judgements
are by `reviewer:gpt-6.1-sol:dc2de93c1b9a` against both certificates.
The preserved review is
`$WORKSPACE/.argus-campaign-9000189/projects/4ec0f06bf561/handoffs/dc2de93c1b9a/round-0001.json`.
This is a technical acceptance, not an explicit decision on the
publishable target.

The report reuses that unchanged evidence. It does not report a new
183-module rebuild or new independent approval. The pending-review
wording in the original exact certificate and the old public Reviewer
progress file reflects their creation before that review; the later
supporting judgements are in `research/MATH_STATE.json`. Those historical
artifacts have not been rewritten to manufacture final acceptance.

The separate fidelity documents are
`statement_fidelity.md` and `compatibility/statement_fidelity.md`.
Compilation proves the encoded propositions; it does not by itself
validate their interpretation, attribution, novelty, or publishability.

## 5. Reproducibility and supplemental computation

From the campaign root, the complete replay command is

```bash
$WORKSPACE/argus-live-update/.venv/bin/python verify.py
```

The script deliberately performs a fresh selected-closure build by
default, then the exact boundary enumeration, then both official
claim-bound compiler checks and campaign-local checks. This is the
expensive independent replay entry point, not a command that was rerun
just to prepare this report. `--build` resumes a dependency-bound
development build, `--boundaries` replays only the small boundary checks,
and `--certify` validates existing build bindings before compiling the
two certification sources. Neither latter mode alone rebuilds the
entire closure. `--fetch` retrieves the pinned public sources without
Git; it is unnecessary when the archived sources are present.

The current verifier is host-environment-specific. It expects the
absolute Lean 4.31.0 binary, the prebuilt Mathlib workspace at
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`, and the Argus
interpreter named above. It does not bootstrap an arbitrary machine.
Mathlib itself and the Lean compiler are not independently rebuilt by
this certificate, and no second kernel implementation is used.

The stored Jacobian operation
`graph.invariant.independence_number.compute` has the exact five-cycle
payload in `jacobian_input.json` and typed result in
`jacobian_output.json`. It records server version `0.14.0`, protocol
`2025-11-25`, status `EXACT`, equal lower and upper bounds of two, and
witness vertices `["0","2"]`. The verifier independently checks all 32
vertex subsets and the response's exact input binding. It reuses that
record rather than requiring a live Jacobian server. This computation
and enumeration through six vertices certify only the stated boundary
facts, not the general Ramsey theorem.

## 6. Scientific scope and remaining decision

The established result is a formal verification with a checked semantic
bridge and a backwards-compatible compiler replay of an existing
complete proof. There is no certified manuscript refutation, improved
bound, structural generalization, or independently discovered proof of
the graph-theoretic theorem.

The remaining scientific question is whether these particular technical
additions, beyond the already available formal proof, amount to a
substantive publishable independent verification contribution under
OBJECTIVE.md's verification alternative. Neither a publication-level
significance decision nor a `verified_new` novelty decision has yet been
obtained. The mathematical equivalences and library facts alone do not
establish that judgement, and this report makes no priority claim for
them. If a genuinely new mathematical result is required in addition
to independent certification, the present submission does not supply
one; a new structural theorem, reduction, or refutation would be
additional scientific work, not a change of result label.

The target remains `research_target_level=publishable` and
`math_objective_mode=exploratory`. Final assessment must address this
complete scientific submission, including substantive contribution,
correctness, fidelity, significance, attribution, reproducibility, and
report quality. Existing technical acceptance can discharge unchanged
correctness obligations, but cannot supply that missing target-level
decision. Campaign completion is not asserted.

## Sources

- **Manuscript.** *Cycle--clique Ramsey numbers*, September 25, 2026,
  staged under
  `research/openai_manuscript/Cycle-clique-Ramsey-numbers-September-25-2026/`;
  `build/sections/01-introduction.tex`, `thm:main`, and the locators in
  Section 2 above. Its main theorem and proof construction are the source
  of the Ramsey result, not a result first obtained by this campaign.
- **Formal proof.** OpenAI/math, commit
  `4eaee87548250b2682affda7d05d947c05554bae`,
  `lean/OAI/Combinatorics/Ramsey/CycleClique/`;
  `lean/docs/189.md`,
  `lean/ComparatorChallenges/CycleCliqueRamsey.json`, and
  `lean/lean-toolchain`. Selected source copies and their existing
  manifest are in `.work/sources/openai-math/` and
  `upstream_manifest.json` beside this report.
- **Library backport.** Mathlib,
  `Mathlib/Combinatorics/SimpleGraph/CycleGraph.lean`, lines 167--186,
  commit `d13f23b723b8a846827a245b89c10fc7d3f11612`, Apache-2.0,
  as documented in `compatibility/statement_fidelity.md`. Correctness
  here rests on the local compiled backport, not an unchecked citation.
- **Campaign theorem and evidence.** `Main.lean`,
  `compatibility/Main.lean`, both fidelity documents, the two
  claim-bound certificates, root `verify.py` and
  `exact_certificate.json`, and the preserved independent technical
  review identified in Section 4.
