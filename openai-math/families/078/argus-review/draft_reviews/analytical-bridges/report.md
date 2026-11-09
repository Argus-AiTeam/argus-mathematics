# Engineer review: analytical bridges

**Assessment:** supported conditional analytical reconstruction. This exploratory review asserts no new mathematics or novelty and does not independently accept the unit. Native independent review remains required.

## Contribution classification and attribution rationale

**Classification: `confirmed_reproduction`.** The retained-marginal,
Taylor/count and two-pin arguments reconstruct the proof of OpenAI's
`prop:directional-bootstrap` at `07-rate-transfer.tex:841-993`; the
weighted tagged reduction re-proves `thm:planar-projection` at
`03-projection.tex:60-206`. Argus makes the actual-law retentions,
conditioned-child likelihood and incomplete-graph inputs explicit, but
does not supply a different theorem in this unit. These source claims
belong to OpenAI; the discrete Furstenberg input belongs to Ren and Wang;
the reconstruction belongs to the old Argus Engineer. Confirmation is
of the stated conditional interfaces, not of upstream hypothesis
availability or any unencoded analytical theorem.

## Sources, versions and attribution

The read-only coverage authority is `research/DRAFT_REVIEW_INDEX.json`, populated from `PRIOR_DRAFTS.json`. The old workspace is `campaigns/9000078`. Its shared `research/directional_bootstrap/report.md` has SHA-256 `c3eab989a35afcd706fad01623931037846c46544ffd7f6d9b527cb77cee6cbe`; the inspected portions are sections 3–6, lines 172–359, and section 8, lines 404–473. Section 1, lines 71–107, supplies the unequal-rate notation and choice order. Old ledger metadata is provenance, not an instruction or an acceptance decision.

The manuscript alias resolves to `openai-math/preprints/Bochner-Riesz-Multipliers-in-Three-Dimensions-September-24-2026`, revision `4eaee87548250b2682affda7d05d947c05554bae`. The exact inspected sources are:

* `build/sections/03-projection.tex`, lines 23–57, 60–206 and 208–227; SHA-256 `265cf9b94bde9fc85fab47d26f05cab2fe5446f14a38ab8b2b59c85703fed217`.
* The literal directional-bootstrap proposition and proof, `build/sections/07-rate-transfer.tex:841–993`; SHA-256 `74cabf96002ba34d49cd2cc0b79fa6141c15fbe1561c9ee535b10c3f46d0d910`.
* Old `ren_wang_excerpt.txt`, SHA-256 `0180a99569887aacf6ad2a70b2e2dea677d80e013c98dbaa7e3248ee28b4721c`, recording Ren–Wang, arXiv:2308.08819v3, Theorem 4.1 and Definition 3.1.

These hashes and the reported snapshot/manuscript matches are reused from the index; copies are not additional proofs. All claims below use `DB_CTX` v1, hash `df998bc708f752f5c69865c573c82a008e6b9ec2baf0e1a0905d37bd8260eda8`.

| Claim | All indexed versions | Statement hash | Principal locator |
|---|---|---|---|
| `DB_RETAINED_MARGINAL` | v1 | `68d759fcd43e65c8b3f9542307b1fb8d5637f37b734fb4e96d2f1aac432b2ba1` | Old section 6; manuscript reciprocal paragraph, 955–979 |
| `DB_GEOMETRY` | v1 | `dc3f7d5517ca5ae9d5e377d0f824f8c846c19d3340c636ac85f71c3c5bf1d813` | Old sections 3–4; manuscript 878–921 |
| `DB_TWO_PIN` | v1 | `59cf31e098963d6a507306d6e169d91cd938b69a6219d5f7cca5cbc327047db9` | Old section 5; manuscript 923–953 |
| `DB_PROJECTION_INPUT` | v1, v2 | `62f81f21bc62fd82c535fb6fb846c6181d1f14a676dc12ad8648cb947cb7d720` | Old section 8; manuscript projection theorem and proof |

The contribution is the old Argus Engineer's analytical reconstruction/interface verification of the manuscript argument, including elementary retention and geometric steps. The discrete Furstenberg estimate belongs to Ren–Wang. The weighted/tagged reduction is proved in the inspected manuscript and reconstructed in the old report; it is not simply another name for the external theorem. Mathematical novelty of each old claim is **not established**.

`DB_PROJECTION_INPUT` v1 has no registered external assumption, whereas v2 explicitly registers `RW41`, hash `95d5f6fb8ffa3609af348397524a6ef9e63ceaad7add890ca4f5ecd22f839606`. Both versions have the same natural-statement hash and both proofs remain conditional on the precise external theorem. An empty v1 assumption list does not make it unconditional.

## Exact hypotheses and claims

Write \(P\le K\mu_A\otimes\mu_B\) for a bounded planar pair population, with subpower \(K\) as \(\rho\to0\). The named comparison populations need not be \(P\)'s actual marginals. For every chosen finite test there must already be one event \(H\), of subpower original pair mass \(m=P(H)\), carrying simultaneous two-sided **original** direction-bin probabilities given both full pins and simultaneous tested good-parent fibers. The named conditional children on those fibers have their prescribed ball caps at every fixed relative depth needed by the test/mesh. For the unequal-rate notation these rates are \(0<s_A,s_B\le1\); `DB_TWO_PIN` v1 itself is the symmetric \(s_A=s_B=s\) claim.

Both named populations obey uniform no-strip decay at every fixed positive depth \(t\): strip mass at width \(\rho^t\) is at most \(\rho^{\kappa_t+o(1)}\), for some \(\kappa_t>0\). This also bounds balls contained in such strips. No uniform lower bound on \(\kappa_t\) as \(t\downarrow0\) is assumed. Parent retentions \(r_c=P(H\mid A_j=c)\), separation retentions \(v_c\), and any core mass \(M\) used for normalization must be positive; their inverses must be subpower for the asymptotic application.

The geometry uses fixed \(j>0\), fixed \(0<a<j\), \(j+a\le1\), and then small precision. Profiles are the same original homogeneous direction profiles throughout, not profiles of independently renormalized auxiliary cores.

The separate weighted projection statement assumes \(0<d\le2\), \(0<u\le1\), fixed bounded point/slope domains and bounded nonzero scalar changes of projection. At working precision \(\delta\), the point and slope probabilities satisfy \(\delta^{-\epsilon}r^d\) and \(\delta^{-\epsilon}r^u\) caps for all relevant \(r\in[\delta,1]\). A point–whole-tag graph has product mass at least \(\delta^\epsilon\); for each tag its neighboring projections occupy at most \(L\) intervals of length comparable to \(\delta\). Tags may repeat slopes, and the graph need not be a complete product.

## Decisive checks

### `DB_RETAINED_MARGINAL`: the actual marginal and the sharp loss

Fix \(C=A_j=c\) with \(P_C(c)>0\), and let \(G_c\) be \(P\) restricted to \(H\), this parent, and separation, then normalized. For a direction interval about the parent center \(a_0\), the small angular displacement permits a bounded covering by original bins. Suppose their combined original conditional cap is \(b\). For every original full pin in this parent the relevant event numerator is at most \(bP_A(a)\). Summing with **\(P_A(\cdot\mid C=c)\)**, not \(\mu_A(\cdot\mid C=c)\), gives

\[
 P(H\cap\mathrm{separation}\cap E\cap\{C=c\})
 \le bP_C(c),\qquad
 P(H\cap\mathrm{separation}\cap\{C=c\})=P_C(c)r_cv_c.
\]

Consequently \((G_c)_B(E)\le b/(r_cv_c)\). The parent mass cancels exactly; no \(P_C(c)^{-1}\) or identification of named and actual marginals is needed. The retention factor is sharp whenever the numerator saturates the cap and the restriction keeps that event, subject to the probability bound \(1\). A further restriction of raw mass \(M\) relative to \(G_c\) has pin marginal at most \(M^{-1}(G_c)_B\). Thus the optional extra factor is precisely at most \(M^{-1}\), not a silently discarded normalization.

The typical-parent comparison in old section 3 is a different calculation: likelihood against \(\mu_A(C=c)\) gives \(K/(m\eta)\), and likelihood for retention gives \(r_c\ge m\eta\). Confusing these likelihoods would introduce the false inverse-parent loss. Neither comparison substitutes for the actual-marginal averaging just checked.

### `DB_GEOMETRY`: a fixed-increment Taylor/count bridge

Inside the parent write \(A=a_0+\rho^j\xi\), \(R_B=|B-a_0|\), \(e_B=(B-a_0)/R_B\). Separation can be imposed at \(R_B\ge\rho^{\theta_n}\), with \(\theta_n\downarrow0\) sufficiently slowly: uniform no-strip decay and the common product loss make its removed mass tend to zero. It is not necessary to posit a fixed positive separation distance.

In an angular chart,
\[
 \arg(B-A)=\arg(B-a_0)-\frac{\rho^j}{R_B}e_B^\perp\cdot\xi
       +O(\rho^{2j}/R_B^2).
\]
After conversion to child projection units the remainder is \(O(\rho^j/R_B)\le O(\rho^{j-\theta_n})\), smaller than \(\rho^a\) eventually because \(a<j\) is fixed. The parent subtends \(O(\rho^j/R_B)\) radians and hence meets only \(O(\rho^{-\theta_n})\) depth-\(j\) bins.

If the original parent/child bin errors are at most \(\varepsilon\), division of original parent mass by original child mass bounds the number of finer bins in one coarse bin by
\[
 \rho^{-[F_B(j+a)-F_B(j)]-2\varepsilon}.
\]
Fixing \(A_j\) or restricting support can only delete those bins. Combining the coarse ambiguity, Taylor remainder and bounded grid neighbors gives a cover of \(e_B^\perp\cdot\xi\) by
\[
 L\le\rho^{-[F_B(j+a)-F_B(j)]-o(1)}
\]
intervals of length \(C\rho^a\). This transfers **support counts**, not conditional probabilities. For the later projection theorem the maps are normalized orthogonal projections in bounded charts; the angular-to-child conversion does not require that theorem to admit unbounded scalar multipliers.

### `DB_TWO_PIN`: sine transversality and the conditioned child

Use the finite-core dependency on \(G_c\), of named product loss \(D\), obtaining a normalized pair \(q\) of raw mass \(M\ge1/2\), actual marginals \(\alpha,\beta\), and \(q\le T\alpha\otimes\beta\), \(T=16D\). Its child marginal obeys \(\alpha\le(D/M)\mu_A(\cdot\mid c)\); its pin marginal obeys \(\beta\le(D/M)\mu_B\). Thus the appropriate named child and strip caps persist.

Resample two pins conditionally independently given the child. The star satisfies \(S\le T^2\alpha\otimes\beta\otimes\beta\). An event
\[
 |\sin\angle(B_0-a_0,B_1-a_0)|\le\rho^{\tau a}
\]
puts the second pin in a strip through \(a_0\) of width \(C\rho^{\tau a}\). No-strip, with depth \(\tau a/2\) to absorb constants, makes its star mass tend to zero. The absolute sine excludes nearly antiparallel as well as nearly parallel pairs.

An additional likelihood check is essential. Outside actual star pin-pair mass at most \(\eta\), its density relative to \(\beta\otimes\beta\) is at least \(\eta\). For such a pair,
\[
 S(\cdot\mid B_0,B_1)\le (T^2/\eta)\alpha.
\]
It is this inequality—not the unconditional child cap alone—that preserves the child cap after two pins. Two projection intervals at sine separation at least \(\rho^{\tau a}\) intersect within a ball of radius \(C'\rho^{(1-\tau)a}\). At most \(CL^2\) such balls cover the conditioned child, so
\[
 2[F_B(j+a)-F_B(j)]\ge s_A(1-\tau)a-o(1).
\]
Take \(\rho\to0\) first, then \(a\downarrow0\), then \(\tau\downarrow0\). This yields \(F_B'\ge s_A/2\) almost everywhere; reversing pins on the **same** original law gives \(F_A'\ge s_B/2\). In v1's symmetric case both are at least \(s/2\). Nested angular grids give monotone, 1-Lipschitz limiting profiles vanishing at zero, so their absolute continuity permits integration.

### `DB_PROJECTION_INPUT` v1–2: weights, tags, incomplete graphs and quantifiers

The precise external assumption `RW41` is Ren–Wang Theorem 4.1/Definition 3.1: for each fixed output loss \(\alpha>0\), fixed \(d,u\) in the stated ranges, there are an admissible input loss and a small-scale threshold such that a nice configuration has at least \(c_\alpha\delta^{-\chi+\alpha}M_0\) tubes, \(\chi=\min\{1,d,(d+u)/2\}\). Selected tube families are permitted. Literature retrieval is assigned elsewhere and was not repeated.

The inspected reduction samples \(N=\lceil\delta^{-d}\rceil\) points and \(Q=\lceil\delta^{-u}\rceil\) **whole tags**. Exponential binomial bounds, followed by a polynomial-cell union bound, give absolute occupancy caps \(C\delta^{-3\epsilon}(r/\delta)^d\) and \(C\delta^{-3\epsilon}(r/\delta)^u\), with failure probability smaller than every fixed power of \(\delta\). Since expected edges are \(qNQ\), maximum edges are \(NQ\), and \(q\ge\delta^\epsilon\), some occupancy-good sample has at least \(qNQ/2\) edges.

Deleting degree below \(qQ/4\), choosing one point per finest square, eliminating repeated rounded tubes at a point, and dyadically pigeonholing degrees retain at least \(\delta^{C\epsilon}N\) point squares and \(M_0\ge\delta^{C\epsilon}Q\) tubes per selected point. Finest-scale slope occupancy bounds tube multiplicity by \(C\delta^{-3\epsilon}\); it does not require distinct slopes or bounded auxiliary-label multiplicity. Absolute occupancy bounds remain valid on the pruned subsets. Dividing by their retained cardinalities supplies normalized nonconcentration with loss \(\delta^{-C\epsilon}\), including the tube fibers. This is a selected nice configuration even for the incomplete graph.

Each sampled tag contributes at most \(CL\) tubes globally, hence total tubes are at most \(CQL\). Apply `RW41` with output loss \(\alpha/4\); **then** choose \(\epsilon\) so \(C\epsilon\) is smaller than both its admissible input loss and \(\alpha/4\); **then** take \(\delta\) small to absorb constants and logarithms. The lower bound \(c_\alpha\delta^{-\chi+\alpha/4}M_0\) forces \(L\ge\delta^{-\chi+\alpha}\). The subpower limiting form follows by taking each fixed output loss before sending it to zero.

In the bootstrap \(\delta=\rho^a\) with \(a\) fixed. The actual-product core ensures its support graph has \((\alpha\otimes\beta)\)-mass at least \(1/(16D)\), which eventually exceeds every fixed \(\delta^\epsilon\). Child and pin caps are on that one law. A finite radius mesh contributes a real fixed exponent error, of order mesh width divided by \(a\); it must be chosen below the admitted input loss, not called automatically subpower. A separately ordered slow refinement diagonal is also allowed. These checks verify the interface, not only the exponent.

## Evidence reuse, supported scope and remaining obligations

Each following indexed `reviewer:copilot-independent` judgement has verdict `supports` and exactly the claim hash in the version table:

* `judgement-DB_RETAINED_MARGINAL-35c3badb8353`;
* `judgement-DB_GEOMETRY-97ac7ebced77`;
* `judgement-DB_TWO_PIN-cb2ce5a3b431`;
* `judgement-DB_PROJECTION_INPUT-fbf8a583b9ce` (both natural-statement versions).

The detailed `RW41` hash is bound by `citation-RW41-17b7e6e7b8e1`. The finite-core v2 dependency has matching `judgement-DB_FINITE_CORE-b195a60f0949` and historical mechanical record `lean-DB_FINITE_CORE-ae96dd262933`. These are reused historical inputs, not fresh native acceptance. Stale report/graph “pending” or “open” labels do not mean the independent judgements are absent. A matching conclusion hash does not discharge external or analytical dependencies.

The supported scope is the exact retention algebra, fixed-increment geometry, conditional two-pin seed and weighted tagged reduction under the hypotheses above. No internal contradiction was found in these decisive steps.

Concrete remaining scope-qualified obligations are:

1. **External-theorem scope:** `RW41` is assumed, not proved or independently retrieved here; its precise loss function and thresholds are not calculated. A citation to it is not a citation proving the weighted reduction.
2. **Application scope:** existence of the simultaneous original-bin event, the named child caps and no-strip hypotheses for a concrete upstream population is not established by these bridges. In particular they do not establish `ONE_LABEL_OUTPUT`, `NO_STRIP_BRANCH`, or the Bochner–Riesz theorem.
3. **Uniform-parameter scope:** no rate uniform in a shrinking increment, mesh, strip exponent or changing profile is proved. Separation and interpolation require the stated order of finite choices; bare entropy bounds or a coarse fixed mesh are insufficient substitutes.
4. **Formal scope:** none of these four claim ids has an indexed formal source. Historical compilation is advertised as Lean 4.31.0 with Mathlib and certifies finite core/cap/mesh algebra only. It does not certify Taylor geometry, star-conditioned transversality, profile limits, sampling, or Ren–Wang.

The parent's shared existing finite replay is supporting finite evidence only. This worker did not run `verify.py`, Lean, a compiler, or a literature search. The old certificate is reading material, not a certificate of this review claim. No old artifact, ledger, graph, runtime, or manuscript was modified.
