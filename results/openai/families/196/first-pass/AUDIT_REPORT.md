# Exact occurrence-to-stage counting and conditional cone topology

## Entropy result and scope

The three targeted mechanisms in the staged September 23, 2026 manuscript
survive this audit: `entropy-propagation`, `entropy-stage-labels`, and
`entropy-product-bound`. The result below is a **universal finite counting
theorem with an explicit error budget**, not an inference from a finite search.
It covers repeated traversals, parallel links, nonzero translation self-links,
inverse-reflection comparisons, and minimum-bin roots that are inactive in a
stage. It gives the explicit choice

$$\boxed{\varepsilon=1/57600}$$

using the manuscript's stated squared-word constant. The application remains
conditional on the prescribed-type squared-word and matching-prescription
inputs. This does **not** certify planar localization, cone surgery,
torsion-freeness, or the proposed zero divisors. No false manuscript assertion
has been identified; there is therefore no `F_<LABEL>` refutation to register.
Independent Reviewer acceptance and an assessment of publishability/novelty
are pending. No claim of a new general entropy inequality is made.

The campaign's initial ledger contained no prior mathematical result beyond
the objective. Searching the inherited Wiki index and relevant terms found
no directly applicable occurrence-to-stage theorem. A discovery query returned
general word-equation literature, but no proposition resolving this finite
counting problem; none is used. Ollivier's density-counting viewpoint is
motivational in the manuscript, not an external theorem used here. All finite
counting arguments below are self-contained.

## 1. Exact finite theorem

Let the alphabet have cardinality \(Q\), with a fixed-point-free involution.
Block \(i\) has \(h_i\) ordered positions and \(m_i\ge1\) distinct occurrences.
An actual partial matching of these occurrences produces a block-link
multigraph. Each link carries an interval bijection of length \(\ell_e\);
it equates letters for a translation and equates inverse letters for a
reflection. A self-comparison never compares a position with itself. Words
are reduced at consecutive positions. Additional constraints are allowed.

Write \(\mathcal F\) for the finite set of full feasible word assignments,
including any specified weight bins. For a link component \(\mathcal U\), put
\[
 S_{\mathcal U}=\sum_{i\in\mathcal U}m_i,\quad
 z_{\mathcal U}=\max_{i\in\mathcal U}m_i,\quad
 b_{\mathcal U}=\#\{\text{unmatched occurrences owned by }\mathcal U\}.
\]
At stage \(j\), the active blocks are those with \(m_i\ge j\).

**Finite propagation theorem.** Choose any root \(r\) of \(\mathcal U\)
and a rooted spanning tree of its non-self links. If edge \(e(i)\) leads
from the parent to child \(i\), define
\[
 G_{\mathcal U}=\sum_{i\ne r}(h_i-\ell_{e(i)}).
\]
If \(D_r\) is any dictionary containing all feasible root words, then,
for every stage having an active block in this component,
\[
 \#\pi_j(\mathcal F|_{\mathcal U})
 \le \#(\mathcal F|_{\mathcal U})
 \le |D_r|\,Q^{G_{\mathcal U}}.                 \tag{1}
\]
Here \(\mathcal F|_{\mathcal U}\) may instead be any larger set satisfying
only that component's constraints; this only enlarges the bound.

**Proof.** Record the root word and, at each child, just the letters outside
the target substring of its tree comparison. Once the parent word is known,
that comparison determines every other child letter, including when the
comparison reverses and inverts. Induction on tree depth proves the code is
injective. There are exactly \(G_{\mathcal U}\) recorded non-root letters.
Projection cannot increase cardinality. The root is chosen before projecting:
no part of this proof requires the root to be active or the inactive graph
to have an embedding. This proves (1).

This is the coordinate construction formalized by `root_code_bound` and
`projection_code_bound`. It works for arbitrary injective partial comparisons,
not just intervals, and for arbitrary functional letter transformations in
the direction of the tree.

**Moment version, without an assumed dictionary count.** Suppose root words
have nonnegative weights \(p\), their full squared sum is at most \(A\), and
every feasible root word has weight at least \(c>0\). Then
\[
 \#\pi_j(\mathcal F|_{\mathcal U})\,c^2
 \le A\,Q^{G_{\mathcal U}}.                    \tag{2}
\]
Indeed, take the dictionary of all root words with weight at least \(c\).
Its cardinality times \(c^2\) is at most the full squared sum. This proves
(2) from the actual comparison equations, rather than positing an extension
count. It is formalized by `projected_moment_bound`.

### Self-links

For a translation self-link, the common-block coordinates satisfy
\(W(x)=W(x+t)\), with \(t\ne0\). Direct all equality edges from the larger
position to the smaller one. Their target positions are distinct, and rank
strictly decreases by \(|t|\). There are \(\ell_e\) constrained positions,
so recording the other \(h_r-\ell_e\) letters determines the whole root word.
Thus there are at most \(Q^{h_r-\ell_e}\) root words. Contiguity of the
domain is not required for this bound. This is `translation_self_bound`;
both signs of the shift are covered by orienting the equality accordingly.

A reflection self-link of length \(\ell_e>h_r/2\) has no reduced word.
Reindex positions by \(0,\ldots,h_r-1\), and write its map as \(x\mapsto a-x\).
The domain and image are intervals of length more than half the block.
Their overlap is reflection-invariant and contains the center. If \(a\)
is even, its central letter is its own inverse. If \(a\) is odd, its two
central adjacent letters are inverse. Both are impossible. The full
interval/endpoint/parity argument is `nearly_full_reflection_impossible`.
In manuscript half-integer coordinates the parity names are exchanged,
exactly as in its proof.

Consequently, a feasible component with a self-link can be rooted at a
translation self-link. Redefine
\[
 G_{\mathcal U}=h_r-\ell_{\rm self}
                 +\sum_{i\ne r}(h_i-\ell_{e(i)}).
\]
Its full assignment count, and every stage projection, are at most
\(Q^{G_{\mathcal U}}\). Extra self-links or other comparisons only decrease
these sets. All reflection self-links must have length greater than half
their block for this conclusion; nearly full manuscript links meet that
hypothesis for all sufficiently large \(L\).

### Actual matching balance, not an entropy hypothesis

If a component has no self-link, select a block with \(z_{\mathcal U}\)
occurrences. Its matched occurrences have distinct partner occurrences
outside that block. At most \(S_{\mathcal U}-z_{\mathcal U}\) such partners
exist. Its unmatched occurrences number at most \(b_{\mathcal U}\).
Therefore
\[
 2z_{\mathcal U}\le S_{\mathcal U}+b_{\mathcal U}.       \tag{3}
\]
This includes isolated blocks and parallel links. The Lean theorem
`occurrence_balance` derives (3) from a partner involution on an actual
matched subset of occurrences. `matched_component_exponent` uses these same
owner-fiber cardinalities, not arbitrary supplied multiplicity inequalities.

## 2. Bins and all stages

Assume the word weights satisfy the squared-word estimate
\(\sum_{W\in T^h}P(W)^2\le e^{-2\delta h}\). In a bin
\(d=\lfloor-\log P(W)\rfloor\), every word has
\[
 e^{-d-1}<P(W)\le e^{-d}.
\]
Hence the bin cardinality is at most
\[
 e^{2d+2-2\delta h}.                            \tag{4}
\]
Also each individual \(P(W)\le e^{-\delta h}\), giving
\(d\ge\delta h-1\). These follow directly from the squared mass;
`squared_mass_bin_bound` is the finite weighted-counting step.

Suppose \(s-1\le h_i\le s+1\), and \(s\) is sufficiently large. If every
positive turn weight is at least \(w_0>0\), equations (4) and the preceding
pointwise bound give constants \(a_0\) depending only on the alphabet weights,
with
\[
 \delta s/2\le d_i\le a_0s,\qquad
 |D_i(d_i)|\le e^{2d_i-\delta s}.                \tag{5}
\]
In a component without self-links choose a root attaining
\(d_{\min}=\min_{i\in\mathcal U}d_i\), irrespective of its multiplicity.
Equation (1) now bounds each nonempty stage projection by
\[
 \exp(2d_{\min}-\delta s+G_{\mathcal U}\log Q).
                                                               \tag{6}
\]
For a self-linked component the corresponding exponent is just
\(G_{\mathcal U}\log Q\).

Each component has an active block in exactly \(z_{\mathcal U}\) stages.
Each block's word-weight cost \(d_i\) is paid in exactly \(m_i\) stages.
Thus the non-error component exponent in the product of stage bounds is
\[
 F_{\mathcal U}
 =-\sum_i m_id_i+2z_{\mathcal U}d_{\min}
                         -\delta s z_{\mathcal U}               \tag{7}
\]
without self-links. If \(2z_{\mathcal U}\le S_{\mathcal U}\), then
\[
 F_{\mathcal U}\le
 -(S_{\mathcal U}-2z_{\mathcal U})\,\delta s/2
                   -\delta s z_{\mathcal U}
 =-\delta sS_{\mathcal U}/2.
\]
If \(2z_{\mathcal U}>S_{\mathcal U}\), (3) and (5) instead give
\[
 F_{\mathcal U}\le
 (2z_{\mathcal U}-S_{\mathcal U})a_0s
                      -\delta s z_{\mathcal U}
 \le a_0s b_{\mathcal U}-\delta sS_{\mathcal U}/2.       \tag{8}
\]
For a self-linked component its non-error exponent is
\(-\sum_i m_id_i\le-\delta sS_{\mathcal U}/2\).
These real inequalities are proved in `component_exponent`,
`self_component_exponent`, and, with the actual matching included,
`matched_component_exponent`.

Writing \(b_*=\sum_{\mathcal U}b_{\mathcal U}\), the exact finite label/weight
contribution over all stages is therefore bounded in logarithm by
\[
 -\frac{\delta}{2}s\sum_i m_i+a_0s b_*
        +(\log Q)\sum_{\mathcal U}z_{\mathcal U}G_{\mathcal U}.
                                                               \tag{9}
\]
If a feasible set is empty, the realization bound is zero, so no logarithm
of zero is needed. Equations (1)--(9) are universal statements about the
finite objects, with no asymptotic or randomness assumption.

## 3. Explicit error budget and the order of quantifiers

Here is the remaining deterministic application to the manuscript's blocks.
Let \(J\) be the number of marked chains, \(M\) a bound on multiplicities,
\(N_b\) the number of full underlying blocks, and \(T\) the number of distinct
edge positions in chain end fragments. Let \(E\) bound the exceptional
unmatched block occurrences near comparison cuts and chain endpoints.
These \(J,M,E\) are bounded for fixed \(K,C,I\). Suppose every selected link
has target deficit at most \(\eta\). The common grid gives
\[
 N_b=O(L/s),\quad T\le J(s+1),\quad
 \eta\le sR/N+O(1)=o(s).
                                                               \tag{10}
\]
Here \(N,R\) are the manuscript's simultaneous-approximation parameters,
not the block count \(N_b\). The alignment assertion in (10) holds for
reflections too: their endpoint convention loses at most a bounded number
of half-integer positions.

For clarity, the mass estimates can be made finite before taking limits.
Since each block length differs from \(s\) by at most one, and its
multiplicity is at most \(M\),
\[
 s\sum_i m_i\ge H-M(N_b+T).                       \tag{11}
\]
Every nonexceptional unmatched block occurrence has only unpaired positions,
at least \(s-1\) of them. There are at most \(MN_b\) total full-block
occurrences. Consequently
\[
 s b_*\le b+Es+MN_b.                             \tag{12}
\]
Both estimates count repeated traversals, not only distinct edges.
The tree definitions imply
\[
 \sum_{\mathcal U}z_{\mathcal U}G_{\mathcal U}\le M\eta N_b.
                                                               \tag{13}
\]

Let \(\rho_j\ge0\) be the explicit non-label error in the fixed-label
expectation bound at stage \(j\), with \(\sum_j\rho_j=o(L)\).
The unblocked end-fragment letters cost at most \(T\log Q\) per stage.
The vertex-incidence bound gives a nonpositive total power of \(n\).
Combining (9)--(13) proves
\[
 \log\prod_{j=1}^{m_*}B_j
 \le-\delta H/2+a_0b+\mathcal E,                 \tag{14}
\]
where one valid finite upper error is
\[
 \boxed{\mathcal E=
 \frac{\delta M}{2}(N_b+T)+a_0(Es+MN_b)
       +M(\log Q)(T+\eta N_b)+\sum_j\rho_j.}     \tag{15}
\]
This is an error bound derived from actual comparison deficits, rather than
an assumption that the desired counting inequalities hold.

For fixed \(K,C,I\), the grid construction has \(s\to\infty\), \(s/L\to0\)
and \(R/N\to0\); indeed \(s\) grows at least as a positive power of \(L\).
Every term in (15) is therefore \(o(L)\), uniformly over those fixed
patterns. The simultaneous-approximation dimension can depend on \(K,C,I\);
only the threshold for \(L\), not \(\varepsilon\), changes. Bin-pattern
enumeration costs \(O((L/s)\log(s+1))=o(L)\).

For completeness, the vertex-incidence argument used in (14) is independent
of word propagation. At each vertex, pair traversal half-edge incidences
into immersed passages, except for at most two interval-path endpoints
globally. A half-edge of maximum multiplicity must be paired with a
different half-edge unless it is an endpoint. Summing
\[
 2\max_{e\ni v}m_e
 \le \sum_{\text{half-edges at }v}m_e+a(v)
\]
gives \(\sum_jV_j\le H+\iota\); loops are counted by their two half-edges.
Since \(\sum_jE_j=H\) and only the stage-one prescribed root saves a
vertex choice, \(\sum_j(V_j-E_j-k_j)\le0\).

The remaining probabilistic input is exactly the manuscript's uniform
fixed-label matching-prescription estimate. Nothing here assumes independent
stages or extends an inactive graph embedding. Multiplication is only of
numerical upper bounds. If their product is at most \(e^{-\delta H/4}\),
one of at most \(M\) stages has bound at most \(e^{-\delta H/(4M)}\).
Realization requires every stage, so Markov's inequality at that one stage
and the \(\exp(o(L))\) pattern count give the required decay.

### An explicit type-only epsilon

The staged `types.tex` gives \(\delta=1/600\) and \(w_0=1/129\).
Since \(h_i-1\le s\), the upper bin bound holds with
\(a_0=5>\log129\). The latter strict inequality is certified in Lean using
\((21/20)^{100}>129\) and \(1+x\le e^x\).
For \(s\ge3003\), all the invoked length thresholds and the two relaxed
bin estimates in (5) hold. Thus the manuscript's choice can be made
\[
 \min\{1/4,\delta/[16(1+a_0)]\}=1/57600.
\]
For all sufficiently large \(L\), the error (15) is at most
\(\delta H/8=H/4800\). With \(b\le H/57600\), (14) gives
\[
 \log\prod_j B_j\le-H/2400.
\]
`manuscript_epsilon_budget` certifies this final numerical implication;
`uniform_epsilon_budget` proves its type-independent version.

## 4. Rerunnable evidence and its limits

Run `python3 verify.py` from this directory. It checks that the original proof,
fidelity text, latest claim version, and archived successful compiler evidence
still agree, then recomputes and compares the exact finite summary in
`exact_certificate.json`, using only integers and fractions. It does not claim
to perform a fresh Lean compilation. The bounded domain is completely
specified in that certificate:
289 labeled partial matchings with 1--3 blocks, multiplicities 1--3 and at
most five occurrences; all products of allowed length-three/four interval
annotations; 11,171 annotated systems; 22,968 feasible bin groups; and
52,042 stage projections. Connected components are checked separately.
The sample systems are genuine repeated cyclic path traversals on disjoint
underlying four-cycles, not fabricated multiplicity inequalities.

An independent direct tuple enumeration cross-checks the signed-constraint
solver on eight cases. All 790 reduced self-link interval configurations
at lengths 2--8 are also checked directly, including both shift signs.
Negative controls show exactly why zero shift and omission of immersion
would invalidate the self-link argument; these violate manuscript hypotheses
and are **not** counterexamples to its assertions.

One recorded inactive-root example has multiplicities \((1,2)\), bins
\((6,7)\), and a length-three translation comparison. The minimum-bin
root is absent at stage two, but both stage projections have eight members.
This tests the projection interpretation rather than embedding extension.
The toy alphabet and dyadic turn weights used for this finite sweep are
not the manuscript's 16,516-letter alphabet. The sweep is adversarial
finite evidence, not the proof of (1)--(15).

The Argus Jacobian adapter was discovered and its exact typed rank contract
inspected before a single bounded execution. The retained operation is
`matrix.rank.compute`, server `0.14.0`, protocol `2025-11-25`.
Its matrix has rows \(e_{i+2}-e_i\), \(i=0,\ldots,5\), on eight positions,
so it tests the translation arithmetic-chain constraint. It returned exact
rank six, with adapter exit zero. The exact payload, typed output, server
metadata and error status are retained in `exact_certificate.json`, and
`verify.py` independently recomputes the rank with rational elimination.
This local example is not used as a proof for arbitrary lengths.

`Main.lean` formalizes the load-bearing coordinate encoding, arbitrary
projection and squared-moment bound, self-link obstructions, actual
occurrence-matching balance, matched-component exponent, and explicit epsilon
arithmetic. `research/statement_fidelity.md` specifies all formal hypotheses
and the remaining human constructions. The formal compiler certificate must
be read together with that document: it is not a formalization of the
whole random graph or topological construction.

The official Lean 4.31.0 verifier returned `exit_code=0`, `proof_holes=[]`,
and axiom-audit exit zero. The current record is
`research/lean/certificates/C_ENTROPY_FINITE-f354a99be95a8413.json`;
the claim ledger derives `closed_kernel` for the precisely stated finite core.
The original source and fidelity text match their compiler-canonical copies
byte for byte. To replay the compiler rather than only check its existing
record, run:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify Main.lean \
  --project-root . --claim C_ENTROPY_FINITE \
  --statement-fidelity research/statement_fidelity.md \
  --artifact-dir research/lean --timeout 100
```

Compiler artifacts and canonical copies under `research/lean/` are generated
by that official command, not separately maintained proof drafts. No local
Lake workspace was created; the host's built Mathlib workspace was used.

## 5. Remaining dependencies and review

For the finite theorem, no external mathematical result is assumed beyond
the foundational library. For the manuscript application, the squared-word
and conditional matching estimates are explicit inputs, not independently
certified conclusions of the entropy mission. Their statements and local sources
are recorded as assumptions of `C_ENTROPY_APPLICATION`. The bounded-chain
and grid hypotheses have been checked for compatibility with the finite
error argument, but are not part of the Lean compiler theorem.

The strongest prior result in this campaign was only an untested planning
hypothesis. The improvement is an exact word-level encoding and a partner
involution proof, their formal certification, a finite quantitative error
bound (15), and the explicit uniform constant above. It is not a new
counterexample to Kaplansky's conjecture, nor an independent proof of the
manuscript's main theorem.

Reviewer must replay `verify.py`, check the formal statement fidelity and
the tree-to-coordinate interpretation, and confirm the conditional
asymptotic application before accepting this milestone. The publishability
and novelty fields must remain unassessed until that review; a successful
finite search alone is not campaign completion.

## 6. Conditional topology: all four band incidences

`research/topology/proof.md` proves the deterministic implication
`C_TOPOLOGY_UNIVERSAL`: for any finite graph immersed edgewise into a finite
rose, absence of the manuscript's specified reduced arrangements implies
\(\pi_2(X)=0\), separation from any prescribed root to every distinct
graph vertex, contractibility of the universal cover, and torsion-freeness.
Specializing the root set gives `C_TOPOLOGY`. No degree, girth, diameter,
entropy or small-cancellation assumption is used in this implication.
The manuscript's **arrangement-exclusion hypothesis is not proved here**.

The proof handles two inner disks, inner/exterior, inner self-bands, and
exterior self-bands separately. For exterior self-bands the retained
interval is \(ac:r\to y\), not the other boundary loop \(b\); the marked
break and its actual graph endpoints are preserved. For an inner
self-band, both new caps use the **same lifted cone**. The residual
annulus-and-caps cycle is closed in that cone, so the original universal-
cover homology class is the sum of the two capped classes. A nonzero
original class leaves at least one essential sphere. Minimality is
applied only after this preservation argument, not assumed in it.
The torsion corollary includes the integer cyclic-resolution calculation
and a proof of the required comparison-of-resolutions argument.

`research/topology/Main.lean` formalizes the actual augmented graph-cone
chain complex, its integral exactness, the injective top differential,
and residual-cycle conservation with a nonzero surviving summand.
The official Lean 4.31.0 compiler and axiom audit returned exit zero with
`proof_holes=[]`; the current claim is `C_CONE_CHAIN_CORE` and its archive is
`research/topology/certificates/C_CONE_CHAIN_CORE-78ea3bb8a3bd663d.json`.
This is **not** a formalization of surface surgery, covering-space lifting,
or the full topology implication. Those parts require independent reading
of the universal proof.

Run `python3 research/topology/verify.py`. The standalone replay uses only
the standard library, checks the exact source/fidelity/compiler/claim
binding, and recomputes 909 multigraph cone complexes, 22,365 integral
cycle primitives and 5,460 immersed graph splices across all four
incidences. It includes break-adjacent and loop-edge cases, explicit
torsion examples that violate arrangement exclusion, and negative controls
for omitting immersion, choosing the wrong boundary, and checking
closedness only after pushforward. These finite computations do not
replace the universal geometric proof.

One inspected, bounded Jacobian operation,
`chain_complex.homology.compute`, independently gives Betti numbers
\((1,0,0)\) for the triangle cone over \(\mathbb Q\). Its exact payload,
typed output, protocol/server metadata and adapter exit zero are retained
separately under `research/topology/`. No timeout or unknown answer is used.

An independent source-reader checked Hatcher's degree-two Hurewicz,
homological Whitehead, and covering-space propositions in the author's
primary PDF. The relevant passages and exact locators are transcribed in
`research/topology/literature/`. The reader also checked the cited Gruber
and Bereznyuk author versions: their results are prior art, not imported
without their small-cancellation hypotheses. The bounded comparison does
not establish novelty. The manuscript's Hatcher Theorem 4.37 citation
supports its specialization; it is not a refutation finding.

The new mathematical contribution relative to the earlier entropy result
is a proof of the **separate deterministic topology implication**, with a
formally checked cone-chain core. No literal false manuscript assertion
has been identified, so no `F_<LABEL>` judgement is warranted.
Independent mathematical review, statement-fidelity approval, novelty and
publishability remain pending. The entropy artifacts are unchanged, and
the random-model, planar-exclusion and final factor dependencies remain
open; this is not campaign completion.

The three Hatcher citations are still `unchecked` in the official citation
ledger, despite the independent source reading. `citation_check attribute`
unconditionally archives to `research/literature/`, which is outside this
mission's authoritative writable paths; no such write was attempted.
Source attribution must be completed through the normal Reviewer/authorized
archive path before review acceptance. This limitation is recorded rather
than hiding the citations or mislabelling a self-check as independent.
