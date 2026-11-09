# Backward charge: substantive Engineer assessment

**Status:** Engineer assessment of all **nine** assigned claim versions; conditional support, not acceptance. No new kernel proof or closed status is earned. Two subsequent native opinions are recorded against the active assessment claim, but their inherited-certificate pointers fail the current binding check. Native Host-invoked re-attestation of this report remains required; see Section 7.

## 1. Identity, attribution, and evidence reused

The read-only draft root is `campaigns/9000022`. Artifact paths below are relative to that root. The exact claim/version, evidence, and duplicate mappings are those in the active `research/DRAFT_REVIEW_INDEX.json`; the inherited column-only failed approach and conditional assumptions were read in the active `research/MATH_STATE.json`.

The source is *The weak inhomogeneous Duffin–Schaeffer conjecture*, September 25, 2026 version, **revision `4eaee87548250b2682affda7d05d947c05554bae`**. The old reference alias is `research/openai_manuscript/The-weak-inhomogeneous-Duffin-Schaeffer-conjecture-September-25-2026/build/sections/`. The index already verified its manifest/source bindings. This assessment reads the relevant `joins.tex`, `tables.tex`, and `prescriptions.tex` passages through that alias; it does not reconstruct a snapshot or inspect Git.

The central backward decomposition, original-grid omission averaging, and capacity/epoch assertions are already manuscript assertions (`join:backward-decomposition`, `join:later-omissions`, `join:capacity`). Their verification is a reproduction/formalization, not a manuscript refutation. The abstract digit-space and arbitrary preserved-mask-kernel formulations are proposed generalizations; their elementary algebra is supported below, but novelty and publication significance are **not assessed**.

### Historical formal binding—not a new compilation

The relevant archived independent judgement is **`judgement-C_BC-4e16cb0094e9`**, by **`reviewer:dd87d9144737`**, supporting **C_BC v2 only**, in context `CTX_BC@1`. Its artifact is `research/backward-charge/certificates/C_BC-a0a4835af61d31ec.json`; the mechanical record is `lean-C_BC-bc7c5105c661`.

* C_BC v2 claim hash: `e60317fe9e1f057df08ecbe4d094db6a32c637100dec581d3c1a6b60958c2dff`.
* Bound `Main.lean` SHA-256: `fbb6c353e52b6d687bb5729f0ff7b9afc2d0e9bbc9a90a225db285db2902158f`.
* Bound `statement_fidelity.md` SHA-256: `1d9945f740a58892822b6ab70478ed9c711c4559f812c4f1bd5aa20ffd62b34b`.
* Historical toolchain: **Lean 4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`; **Lake 5.0.0-src+68218e8**; elan 4.2.3. Mathlib workspace: `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
* Recorded compiler exit **0**, axiom-audit exit **0**, and `proof_holes: []`.
* The printed foundational axioms are `propext`, `Classical.choice`, and `Quot.sound` for `digit_average`, `correlated_covariance`, `projected_transport`, and `complete_backward_charge`; `first_epoch_preserved` prints only `propext`. These are foundational axioms, not external literature or construction assumptions.

The complete old `report.md`, `Main.lean`, and `statement_fidelity.md`, the exact ledger records, certificate/check/audit records, `verify.py`, and Jacobian artifacts were inspected. The index establishes that the v2 formal statement, certificate source text, and `Main.lean` are one identical formal source, not three proofs. The fidelity copy is likewise one document; compiler wrappers and `compile.log` describe the same historical check. The empty lock and development-submission receipt are not mathematical evidence.

C_BC v1 has the same natural statement but **empty formal statement and no directly recorded evidence**. It was not separately formal-source-bound or separately covered by that archived judgement. The seven subclaims have old Engineer judgements; the v2 certificate's subject must not be relabelled as seven independent mechanical certificates. The historical certificate hashes source and fidelity text, not the old report or manuscript revision. Present source correspondence is assessed separately below.

## 2. Exact finite implication and indispensable hypotheses

Let finite sets \(X,Y\) index origin labels, and \(A,B\) image labels. Let \(m_{xa},n_{yb}\geq0\), \(u_a,v_b\geq0\), and \(K(a,b)\geq0\), with
\[
 \sum_xm_{xa}\leq u_a,\qquad \sum_yn_{yb}\leq v_b.
\]
On \(T=(A\times B)\times(X\times Y)\), set \(W(t)=K(a,b)m_{xa}n_{yb}\). A static endpoint is allowed by using a diagonal identity transport weighted by its retained static weight.

For a finite product \(C=\prod_i D_i\) of finite additive commutative groups, let \(\chi:T\to C\). For every coordinate \(i\) and every increment \(d\in D_i\), require a **bijection of the expanded tuples** adding \(d\) to that digit, leaving other digits unchanged, and preserving \(W\). The selected bijections need not form a group action. The resulting statement is
\[
 \sum_{\chi(t)=0}W(t)=|C|^{-1}\sum_tW(t),\qquad
 \sum_{P(t),\,\chi(t)=0}W(t)
 \leq |C|^{-1}\sum_{a,b}K(a,b)u_av_b.                 \tag{F}
\]
Here \(P\) is arbitrary, not necessarily invariant. Fiber equality itself allows signed real weights; discarding \(P\) and applying capacities require nonnegativity. For \(D_i=\mathbb Z/q_i\mathbb Z\), every \(q_i\) must be positive, and \(|C|=\prod_iq_i\).

The other components have additional, explicit hypotheses:

* **Raw update:** nonnegative actual raw link masses, row sums at most the pre-weight, Boolean success indicators, and individual orbit means \(q=1/p\). Prefixes and transported link masses are constant on the pre-core orbit. The formal covariance identity needs only its two first-moment equalities; the upper bound also needs nonnegative total link masses. Calling the joint term nonnegative additionally uses the actual nonnegative indicators/masses.
* **Currency:** every nonzero link preserves its complete after-\(p\) mask, including later omissions and the current outer mask. Any nonnegative kernel of these tags is permitted; normalization or endpoint factorization is unnecessary.
* **Ancestors:** a finite **injective labelled** current-to-ancestor map and nonnegative ancestor weights. Geometric coincidence alone is not injectivity.
* **Epochs:** growing equivalence relations, an original first-sharing epoch \(J\), and replacements connected to the respective original endpoints at some common time \(t<J\).
* **Unrolling:** a finite trace, nonnegative continuation factors \(r_i\), and local inequalities \(Q_i\leq r_iQ_{i+1}+J_i\), where each \(J_i\) is the restricted zero-fiber loss of actual `ChargeData` satisfying the hypotheses of (F). Lean assumes these local inequalities; it derives their capacity charges, not the manuscript-to-trace correspondence.

The source instantiation is conditional on the specified operations: same-location row projections, actual nonnegative matching matrices with endpoint capacities, complete future-mask preservation, full unprocessed-prime core symmetry, growing components, the stated cell-span bound, and good masks in the sufficiently large retained bands. It does **not** assume the quantitative conclusions of the first-join, sparse, or partition inputs. Empty external-assumption arrays on the old claims do not erase these quantified/data hypotheses.

## 3. Decisive arguments and manuscript fidelity

### 3.1 Equal fibers before capacities

Compose the individual digit bijections to obtain a weight-preserving bijection translating \(\chi\) by any prescribed color. Reindexing takes the zero fiber to each color fiber with identical weight. Summing the fibers gives the first equality in (F), without freeness or success independence. Drop \(P\), then interchange the finite origin/image sums:
\[
 \sum_tW(t)=\sum_{a,b}K(a,b)
                  \Bigl(\sum_xm_{xa}\Bigr)\Bigl(\sum_yn_{yb}\Bigr).
\]
The two column bounds prove the inequality in (F). This checks the decisive content of `lift_individual_digits`, `digit_average`, `tupleWeight_sum`, and `projected_transport`. Column bounds **alone** cannot produce \(1/|C|\) or first-epoch uniqueness: the inherited rejected shortcut remains insufficient.

### 3.2 The digits are original-minus numerators, not image numerators

In `joins.tex:460–507` and `tables.tex:47–88`, a mapped side has \(d=d_{<p}b\), \(V_0=L/d_{<p}\), and
\[
 \frac{z+a\gamma}{V_0/b}
   =\frac{bz+ba\gamma}{V_0}.
\]
Thus its same-location full-minus ancestor has phase \(ba\gamma\) and numerator divisible by \(b\). This exact subgrid identity, not a mask probability, supplies the designated zero digits.

For \(l\mid b\), passing all larger bad-omission tests forces equal original centre exponents \(\nu_l\) and an unomitted partner at \(l\). Consequently the two mapped omission supports are disjoint. The good-mask excess-power condition and the adaptive-prime starting scale force each such deficit to be at most one (`prescriptions.tex:20–47`); hence the color cardinality is \(b_1b_2\), or \(b_1\) for one mapped side.

Translation by \(1/l^{\nu_l}\) adds \(V_0/l^{\nu_l}\), a unit modulo \(l\), to the designated **origin** numerator. It adds multiples of every other omission prime and of \(p\). Images in the earlier \(p\)-component have the same full \(l\)-power and full pre-success \(p\)-power; their success residues at \(p\) therefore remain unchanged. The full static partner grid is closed under the translation, and its factors through \(p\) are unchanged.

The pre-\(p\) core contains every later full \(l^{\nu_l}\). Tail exponent equality follows from the edge threshold along component paths, while only previously passed primes have had core exponents reduced (`tables.tex:20–29,98–153`). Thus actual pre-prefixes and labelled matching matrices transport equivariantly. Simultaneous translation also preserves the widened image-distance predicate, widths, mask tags, and any periodic near-lift multiplicity.

The unit may depend on the origin's row and below-\(p\) mask. Selecting its inverse separately on these translation-invariant row-tag blocks still gives a bijection of the entire tuple set, with a blockwise inverse. This supplies the needed individual digit lifts.

Crucially, the physical translation can have order \(l^{\nu_l}\), not \(l\). Neither the proof nor Lean presumes a splitting of that translation group onto the quotient digit group. The arbitrary positive-modulus extension is valid **when its analogous lifts exist**; it does not construct an enlarged actual table scheme permitting higher adaptive deficits.

Later clipping, partition tests, and survival predicates were discarded before this averaging, after extracting any needed cell-span bound. Therefore exact reciprocal factors belong to the **widened prefix-only expanded majorant**. They are not an equality asserting that actual final survivors occur with probability \(1/(b_1b_2)\). The old fidelity document states this distinction correctly.

### 3.3 Correlated covariance and actual residual currency

For \(M=\sum_\xi m_\xi\), \(D=\sum_\xi m_\xi I_\xi\), and \(q=1/p\), the actual complementary rule is
\[
 w^+=(w-M)(1-q)+\sum_\xi m_\xi(1-I_\xi)
     =(1-q)w-(D-qM).
\]
Row capacity and \(0\leq I_\xi\leq1\) give nonnegative retention. Transported link masses and the individual success means give \(\mathbb ED=qM\). On a second side write \(v,N,E\). Direct expansion, not independence, gives
\[
 \mathbb E(w^+v^+)=(1-q)^2wv+\mathbb E(DE)-q^2MN
                 \leq(1-q)^2wv+\mathbb E(DE).
\]
This is exactly `join:raw-covariance` (`joins.tex:230–291`). The joint loss is nonnegative for the actual masses/indicators, and the negative product-of-means subtraction may be discarded. A static forbidden residue uses one indicator with its retained smaller static weight; a scalar has zero centered part.

The plus capacity is its **residual-scaled** pre-weight: \(s_p=R_p^{[\nu_p\geq2]}\). For each fixed after-mask \(a\),
\[
 \pi_{p^\nu I'}(a)=R_p\pi_{I'}(a),\qquad
 \pi_{p^\nu I'}(pa)=\frac{s_p}{p}\pi_{I'}(a).
\]
These follow directly from the totient formula, including \(\nu=1\) with \(\phi(1)=1\). A residual matched portion \(m\) has before-currency masses \(m/p,mR_p\), and after masses \(mS,m(1-S)\). On success, matched and unpaired plus portions together equal the entire residual capacity (`tables.tex:221–277`).

When leaving an adaptive range, fix static anchor choices, keep one active hard exclusion per prime (or the prescribed scalar), and drop extra filters. This is a pointwise upper replacement **after** the anchor average. The adaptive multipliers remain those of the actual averaged tables, not plans recomputed for auxiliary anchors. Later projection multipliers are units at birth primes, so retained exclusions remain fixed residues. The prescriptions (`prescriptions.tex:169–192,301–311,407–412`) and the explicit clarification in `tables.tex:733–795` justify this use without importing a quantitative virtual-marginal estimate.

Only the product term is continued. No larger-prime success conditioning is inherited by it. An omitted current row is treated as its actual successful ancestor subgrid, not given an invented additional \(1/p\) probability.

### 3.4 Complete masks, common-law currency, and ancestors

Matching is separately by width and complete after-\(p\) mask (`tables.tex:221–240`). That tag fixes both the later omission portion and the outer mask at the current join. In each nonzero link product one can therefore replace origin tags by image tags without changing **any** kernel of those tags. In particular,
\[
 K_{\rm broad}(f,g)=\pi_I(a(f))\pi_I(a(g)),\qquad
 K_{\rm clip}(f,g)=\mathbf1_{a(f)=a(g)}\pi_I(a(f)).
\]
The clipping coefficient occurs once, not squared. Nonnegativity allows restricted origin pairs to be enlarged to the Cartesian product before multiplying column sums; no probability normalization is needed. This matches `tab:product-law`, `tab:one-law`, and `join:one-law-capacity` (`joins.tex:510–572`).

A current label records centre, original assigned row, and numerator. For that fixed row the ancestor numerator is \(bz\); it determines \(z\) uniquely. Different coincident labels remain different labels. The row also determines its complete original mask, so there is no independent future-mask choice to resummon after averaging. All below-\(p\) origin rows are already rows of the single actual matching matrix. Grouping by earlier components and preserved tags partitions image labels; it does not create repeated capacity budgets. The finite injective-map bound in `projection_no_multiplicity` is therefore applicable.

### 3.5 First-sharing epoch

Let \(E_s\) be the growing component equivalence relation, extending not-yet-born centres as isolated vertices. Suppose \(x,y\) first share at \(J\), and \(xE_ta,yE_tb\) for \(t<J\). They give \(aE_Jb\). If \(aE_sb\) at some \(s<J\), transitivity at \(\max(s,t)<J\) would give \(xE_{\max(s,t)}y\), a contradiction. This also proves uniqueness of the charged pair's first-sharing epoch.

Earlier matching links lie in the appropriate old child of the current join. A newborn static endpoint stays fixed; it is not replaced by a nonexistent earlier adaptive link. Nonadjacent newborn–newborn comparisons have empty adaptive ranges. These facts supply the hypotheses of `first_epoch_preserved` and agree with `joins.tex:561–572`. The result removes **comparison-epoch** multiplicity, not the intentional later sum over stopping primes or the finite choices of mapped sides.

### 3.6 Separately stopped finite unrolling

Induction on the trace, using \(r_i\geq0\) and (F) at each step, gives
\[
 Q_0\leq\Bigl(\prod_{i<n}r_i\Bigr)Q_n+
   \sum_{i<n}\Bigl(\prod_{j<i}r_j\Bigr)\operatorname{Charge}_i.
\]
`ChargeData` stores matrix, symmetry, restriction, and capacity hypotheses, **not** the conclusion \(J_i\leq\operatorname{Charge}_i\); that conclusion is proved. `BackwardTrace` does assume the local one-step bounds. The source/grid covariance argument supplies those bounds in prose. `chargedTerms_length` and nonnegativity prove one nonnegative stopped term per stage, not a covariance tree obtained by re-expanding stopped losses. No global summation over primes is established here.

### 3.7 C_BC_RESTORE: supported prose, not Lean

The exact contextual hypotheses are \(U,T\geq1\), \(B_i,B_j\geq0\),
\[
 H=B_i+B_j+\log(2UT),\quad P_0=\rho H,\quad
 0<d_0<\rho,\quad C\geq0,
\]
and the two good-mask bounds
\[
 \sum_{\substack{p\mid d\\p>d_0B_i}}\frac{(\log p)^{.3}}p\leq1,\qquad
 \sum_{\substack{p\mid e\\p>d_0B_j}}\frac{(\log p)^{.3}}p\leq1.
\]
Here \(U,T,d,e\) are positive integers and products are over distinct primes. The definition of \(H\) is from `joins.tex:120–164`; it is indispensable to the abbreviated ledger statement.

Since \(P_0>d_0B_i,d_0B_j\), each mask contributes at most \((\log2)^{-.3}\) to the relevant reciprocal-prime sum. Also
\[
 \sum_{\substack{p\mid UT\\p>P_0}}\frac1p
 \leq\frac{\sum_{p\mid UT}\log p}{P_0\log2}
 \leq\frac{\log(UT)}{\rho H\log2}
 \leq\frac1{\rho\log2}.
\]
For \(p\geq2\), \(-\log(1-1/p)\leq2/p\), so
\[
 \prod_{\substack{p>P_0\\p\mid UTde}}R_p^{-C}
 \leq
 \exp\!\left(2C\left[\frac1{\rho\log2}
                         +\frac2{(\log2)^{.3}}\right]\right).
\]
This proves the stated uniform restoration with dependence only on fixed cutoffs and \(C\). It uses neither prime independence nor an unproved analytic theorem. It is not a theorem in the archived Lean file. If \(H\) were treated as arbitrary, rather than inheriting the manuscript definition, the abbreviated claim would lack the necessary bounds \(H\geq B_i,B_j,\log(UT)\); that context must not be dropped.

## 4. Disposition of every assigned version

All nine use `CTX_BC@1`; their recorded external and retired assumption arrays are empty. Exact ledger natural statements and hashes are preserved in `verdict.json`. The hypotheses above remain active.

| Claim/version (old ledger pointer) | Exact supported scope and disposition |
|---|---|
| **C_BC v1** (`/claims/1`) | Universal finite projected-history implication: one continuing branch, separately stopped nonnegative joint losses, reciprocal squarefree later omissions on the expanded majorant, capacity transport preserving currency and first epoch, without success/history independence. Supported in the contextual sense proved above; **no separate v1 formal-source or historical independent-review binding**. |
| **C_BC v2** (`/claims/9`) | Same natural assertion, with the exact whole `Main.lean` formal statement. Historical mechanical/independent evidence reused for the finite implication; actual-grid instantiation is the checked prose argument, not kernel-certified LaTeX. No new compilation, proof, or closure. Depends on the six finite subclaims and the prose restoration needed for uniform ordinary-factor restoration. |
| **C_BC_DIGITS v1** (`/claims/2`) | Under the finite digit-bijection and weight-invariance hypotheses, all fiber sums are equal and the zero fiber is divided by the product of digit cardinalities. Supported; original-minus instantiation and non-action prime-power lifts checked in §3.2. General moduli remain conditional on lifts. |
| **C_BC_UPDATE v1** (`/claims/3`) | Actual complementary raw updates with individual orbit means \(1/p\) satisfy the exact covariance identity; dropping \(q^2MN\geq0\) leaves product continuation plus a nonnegative joint-success loss. Supported with row capacity and nonnegative indicators/masses; no independence. |
| **C_BC_MASKS v1** (`/claims/4`) | Support-preserving complete after-\(p\) tags carry any nonnegative mask kernel through the two capacities, including the single common law. Supported; generic correlated-kernel extension is algebraic, not a new mask-selection theorem. |
| **C_BC_ANCESTORS v1** (`/claims/5`) | Injective same-location assigned-row ancestors and nonnegative weights prevent extra ancestor, processed-mask, or capacity copies. Supported; not a claim that coincident distinct labels are identified. |
| **C_BC_EPOCHS v1** (`/claims/6`) | Earlier-connected replacements in growing equivalence relations preserve the original first epoch and its uniqueness. Supported with the strict \(t<J\) hypothesis; not a bound on the number of stopping primes. |
| **C_BC_UNROLL v1** (`/claims/7`) | Any finite sequence satisfying the local trace and transport hypotheses has terminal product plus exactly one separately stopped projected charge per stage. Supported; actual-grid local inequalities are prose instantiation, not automatically generated by the formal trace. |
| **C_BC_RESTORE v1** (`/claims/8`) | The displayed distinct-prime product bound follows from the two good-mask harmonic bounds, \(0<d_0<\rho\), and the manuscript definition of \(H\). Supported as an elementary prose derivation; not a separate compiled result. |

These are components/versions of one transport argument, not nine independent new research results.

## 5. Numerical and checker evidence: bounded, historical only

No unchanged reviewed validation, old `verify.py`, Lean compilation, or Jacobian operation was rerun. No Lean file was created or copied into the current project. This is deliberate evidence reuse, **not** a conclusion based on inaccessible tools.

Inspection of `verify.py` shows exact `Fraction` fixtures: 20 prime-power mask cases; 24 correlated-update cases (24 recorded nonzero covariances); 24 omission averagings with maximum translation period 3675 and 432 mask-weighted bounds; 60 four-vertex growing partition chains with 2748 transported first joins; and 81 four-step unrollings. These are the archived counts in `exact_certificate.json`, not new results. Product-coupled constant matrices and synthetic grids are not complete retained-centre histories. Source-label presence tests verify locators, not fidelity.

The default verifier invokes the historical Argus interpreter, recompiles/records Lean, and writes `lean-verification.json`; its optional payload/certificate modes also write legacy artifacts. Even `--recorded-only` reruns the fixtures and campaign checks. None was needed or invoked. The old `result_class: new_theorem` is not adopted as a novelty verdict.

The one Jacobian call is `probability.finite_distribution.condition.compute`, protocol `2025-11-25`, server `0.14.0`, archived adapter exit 0 with complete typed output. Its 70 atoms encode \(c\in\{0,\ldots,34\}\) and one common success bit \(s\), with value \(2c+s\) and masses \(2/105\) for \(s=0\), \(1/105\) for \(s=1\). Conditioning on values 0 and 1 therefore has mass \(3/105=1/35\) and conditional masses \(2/3,1/3\), exactly as recorded. This checks conditioning in a **chosen product color/bit distribution**, not invariance or independence in an arbitrary adaptive history. Payload, embedded request, output, and status are one bounded experiment, not separate proofs.

## 6. Supported conclusion and concrete remaining obligations

No substantive defect was identified in the **conditional finite implication**, its pinned-source original-minus/capacity/epoch instantiation, or the contextual restoration argument. This is not a finding that the whole source is correct. The real boundaries are:

1. Existence of histories with the stipulated equivariant cells, clipping/partition properties, and acceptable total losses is not proved by the finite implication. Partition construction/loss estimates and sparse-alignment estimates remain separate inputs.
2. Numerical reciprocal factors do not certify actual final-survivor densities. Applying the theorem outside the widened prefix-only domain requires new invariance information, not the old finite fixtures.
3. Endpoint periodic counts, analytic first-join estimates, roundoff and stopping-prime summations, and any W-sensitive RFJ bound are outside this unit; the parent's RFJ assessment must address them. The historical BC judgement does not certify RFJ.
4. Direct birth comparisons, block/partition selection, and the final finite-construction/second-moment reduction to the main conjecture remain outside this transport verification.
5. Generalized higher-deficit histories need their own operation/digit-lift realization; arbitrary correlated-kernel or prime-power-digit **quantitative** estimates are not supplied.
6. Native Host-invoked independent re-attestation of the present assessment remains outstanding because of the binding defects in Section 7; no novelty or family-completion decision is made here.

The original assessment recorded parent-supplied `math_state check` exit 0 and `proof_graph_check` exit 2. Those are historical results, not the current binding-check result. The campaign-local measurements in Section 7 supersede that administrative context; they do not justify creating a graph outside this mission's writable paths or weakening a claim.

Only this `report.md` and the adjacent `verdict.json` are produced by this unit. Old files, ledgers, manifests, the active MATH_STATE, and other review units are unchanged by this assessment.

## 7. Active assessment binding and native re-attestation

### Current subject, not a replacement formal theorem

From working directory `campaigns/9200022`, the supported command

```text
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.math_state show --claim C_REVIEW_BC
```

reports **C_REVIEW_BC v1**, in `CTX_OLD_DRAFT_REVIEW@1`, as `supported` by opinions, with no formal statement, no mechanical evidence and no open external assumptions. Its statement is:

> Under the stipulated core-equivariant finite projected-table histories, mask transitions, injective ancestors and growing chronology, the backward-charge implication has one continuing branch, separately stopped nonnegative losses, exact reciprocal later-omission factors and capacity bounds preserving independent or common outer currency without repeated first-sharing epochs. This is the finite assertion of old C_BC v2, not the analytic construction or the main conjecture.

The current claim content hash is `eca6582aff51ec697ee44fb6f514d5d169dca736109fbffbe4ca1f17ab2e7a2e`. All three active opinions name that exact subject hash. The archived certificate instead names **C_BC v2**, hash `e60317fe9e1f057df08ecbe4d094db6a32c637100dec581d3c1a6b60958c2dff`, in the old `CTX_BC@1`. These are different registered subjects, even though the present assessment concerns the historical finite assertion.

Sections 2-3 state the hypotheses and check the finite argument underlying the current assessment. In particular, reciprocal factors concern the widened prefix-only majorant; local trace inequalities and digit lifts remain hypotheses/data; complete mask tags preserve the chosen outer currency; ancestors are injective labelled ancestors; and chronology replacements occur strictly before the first-sharing epoch. Neither statement supplies the analytic construction or the main conjecture. This repair changes none of those hypotheses or conclusions.

### What the direct comparison establishes

The accessible old files were compared with the certificate's embedded text and compiler bindings, and the certificate bytes were compared with the existing coverage-index snapshot digest:

| Comparison | Measured result |
|---|---|
| Old `Main.lean` versus embedded source and recorded source SHA-256 | Exact match; the digest is the one in Section 1. |
| C_BC v2 ledger formal statement versus that `Main.lean` | Exact byte match. |
| Old `statement_fidelity.md` versus embedded fidelity and recorded fidelity SHA-256 | Exact match; the digest is the one in Section 1. |
| Archived certificate versus `historical_bc_review_binding.artifact_existing_snapshot_sha256` | Exact match (`aa8ee3c23935494aab1ae4c38c6397e790642e550899fa81bf2f80d302f46a3c`). |
| Current C_REVIEW_BC statement versus its three opinion subject bindings | All name the current v1 content hash. |

Thus the inspected bindings establish **no source, fidelity, certificate or current-claim change relative to those recorded references**. There is no new mathematical improvement over the strongest inherited result: the historical finite conditional theorem and its separate prose instantiation remain the support assessed here. The present change is an explicit account of which subject each artifact can support. No Lean compilation, fixture run or Jacobian operation was repeated.

### The two inapplicable active pointers, preserved as provenance

Both records below have tier `judgement`, verdict `supports`, and subject C_REVIEW_BC at the current v1 hash:

| Existing evidence id | Recorded producer |
|---|---|
| `judgement-C_REVIEW_BC-2eeb41080a38` | `reviewer:native-9200022` |
| `judgement-C_REVIEW_BC-c0c0627ca79f` | `reviewer:final-9200022` |

Both cite `families/022/first-pass/backward-charge/certificates/C_BC-a0a4835af61d31ec.json`. Their complete records are preserved in the adjacent `verdict.json`. They have **not** been superseded by Engineer. The historical C_BC judgement `judgement-C_BC-4e16cb0094e9` and all old inputs remain untouched.

The current check emits `judgement_certificate_retired` for these two records. Its explanatory message mentions a rewritten fidelity note and re-verification, but that history is **not established here**. Inspection of the actual condition in `argus_skill/verticals/math/math_state.py`, function `certificate_issues`, shows that it flags a judgement whose artifact is in a `certificates` directory but is absent from the current subject's non-judgement evidence. C_REVIEW_BC has no such certificate. The measured defect is therefore a **claim-to-artifact mismatch**, not evidence that the old proof or fidelity text changed. The `certificates` list printed by `show` includes judgement artifacts too; it does not turn them into mechanical evidence.

The applicable artifact for a fresh opinion on **C_REVIEW_BC** is this assessment, `research/draft_reviews/backward-charge/report.md`. The archived C_BC v2 certificate remains explicitly inherited evidence within it, not a current C_REVIEW_BC mechanical certificate. A native Reviewer must assess the objects, quantifiers, hypotheses and conclusion described above and choose its own verdict; merely changing the pointer without reading the assessment is not re-attestation.

The supported `judge` operation replaces an opinion only for the **same subject, tier and producer**, when the new artifact differs. Consequently each of the two recorded Reviewer producers needs its own Host-authorized native re-attestation using `judge --claim C_REVIEW_BC --artifact research/draft_reviews/backward-charge/report.md`, its actual verdict and its own `--by` identity. A new Engineer opinion or a different producer's opinion would not retire either rejected record. Engineer has not run either Reviewer command, deleted evidence, restated the claim, or invented a current certificate. The provenance above remains available after legitimate supersession.

### Actual campaign-local check result

Both commands used `$WORKSPACE/argus-latest/.venv/bin/python` and the exact project root `campaigns/9200022`:

```text
-m argus_skill.verticals.math.math_state check --project-root campaigns/9200022
exit 1: the two judgement_certificate_retired issues identified above

-m argus_skill.verticals.math.proof_graph_check check --project-root campaigns/9200022
exit 2: no research/PROOF_GRAPH.json at that campaign root
```

These are not passing checks or final acceptance. The missing graph is an administrative fact outside the owned paths, not a mathematical defect or an added old-draft-review obligation. The active ledger is unchanged, so the two binding issues remain pending native re-attestation. Host stage advancement and independent acceptance are not claimed.
