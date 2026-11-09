# Publication triage of retired mathematical campaigns

Date: 2026-09-05 UTC

## Executive verdict

The retired campaigns did not all end as empty searches. They contain several
exact intermediate theorems, but most are route-specific obstructions rather
than solutions of the original open problems.

The publication order is:

1. **Campaign 2338 is the strongest immediate paper candidate.** Its clean
   paper is about necessary conditions for a value to occur exactly five times
   in the left half of Pascal's triangle. It should not include the entire
   later Selmer/Runge research log.
2. **Campaigns 1243 and 6800022 are serious paper projects after one focused
   completion or specialist novelty audit.**
3. **Campaigns 2800203, 1285, 1187, and 20000582 contain publishable seeds, but
   their present statements are too tied to a custom proof architecture or
   miss the decisive final implication.**
4. **Campaign 2457 is suitable as a correction note, public technical comment,
   or correspondence to the author, not as a normal research article.**
5. The remaining campaigns should be preserved as negative evidence and
   reusable lemmas, but should not presently be submitted as standalone
   papers.

This is a publication-readiness assessment, not a global originality
certificate. Public exact-phrase and topic searches did not find the displayed
2338 statements, but a number theorist must still perform a complete priority
check before submission.

## Tier A: prepare a paper now

### 1. Campaign 2338 — multiplicity five in Pascal's triangle

Recommended working title:

> Necessary conditions for multiplicity five among binomial coefficients

Use the convention

\[
P(a)=\{(n,k):1\le k\le n/2,\ \binom nk=a\},\qquad m(a)=|P(a)|,
\]

and let \(K(a)\) be the largest lower index among the nontrivial
representations.

The clean independently reviewed results are:

1. \(m(a)=5\Rightarrow K(a)\ge8\).
2. \(m(a)=5\Rightarrow\omega(a)\ge7\), where \(\omega(a)\) is the number of
   distinct prime divisors.
3. In the surviving four-column \(\{5,6,7,8\}\) system, every solution has a
   coherent primary-cell tensor with at least fourteen occupied cells; hence
   \(\omega(a)\ge14\) on that branch.
4. The exact \(K=8\) reduction leaves only the two lower-index systems
   \(\{3,5,7,8\}\) and \(\{5,6,7,8\}\).

The first three decisive verifiers were rerun on 2026-09-05:

- `research/k7_total_exclusion_synthesis_certificate.py`: passed and returned
  `m(a)=5 implies K(a)>=8`;
- `research/support_capacity_seven_certificate.py`: verified all 4,060 exact
  factorizations and returned minimum support seven;
- `research/k8_5678_full_system_certificate.py`: returned `ok=true`.

Why this is potentially publishable:

- Problem 849 is still publicly listed as open, with no known example for
  multiplicity at least five.
- The statements are global implications, not finite search misses.
- The proof combines classical complete Diophantine classifications with new
  numerator-window and prime-support reductions.
- The project has exact replay and independent internal review for the key
  claims.

Required before submission:

1. Rewrite the proof from scratch in normal mathematical prose, using only the
   four or five indispensable lemmas.
2. Human-check every imported classification and all changes of variables.
3. Replace internal terms such as “campaign domain”, “cell tensor”, and
   certificate hashes by standard definitions and propositions.
4. Perform a publication-level MathSciNet/zbMATH and author-preprint search.
5. Put the computation only in an appendix or repository; the main theorem
   should read as a number-theory argument.

Likely level in its present form: a legitimate short specialist number-theory
paper. If either remaining \(K=8\) system is excluded, the significance rises
substantially.

Primary local artifacts:

- `campaigns/2338/research/k7_total_exclusion_synthesis.md`
- `campaigns/2338/research/lower_index_six.md`
- `campaigns/2338/research/support_capacity_seven.md`
- `campaigns/2338/research/k8_lower_index_overlap_reduction.md`
- `campaigns/2338/research/k8_5678_full_system_classification.md`

Do **not** use the enormous later theta/Selmer log as the main paper. The
extension-stable Runge obstruction can be a separate appendix or future note.

## Tier B: serious projects, not submission-ready

### 2. Campaign 1243 — an explicit Cassels--Tate pairing

Current exact result:

\[
\langle936,1304\rangle_{\mathrm{CT}}=\frac12
\]

for the recorded residual classes, obtained from an explicit global norm
preimage and six local Hilbert-symbol calculations.

This is substantive arithmetic, but the result needed for the original
application is still conditional on proving that the displayed local
intersection is the complete global \(2\)-Selmer group. Without that upper
bound, the work does not prove rank one, classify the rational points, or
settle the square-magic branch.

Publication route:

- Complete the global Selmer/class-unit certification and rational-point
  classification. A complete result could form a serious computational
  arithmetic paper.
- If completion fails, the pairing by itself is more naturally a worked
  computational example or an appendix, unless it exhibits a genuinely new
  pairing algorithm.

Current external-status caution: a 2025 arXiv preprint initially claimed
nonexistence of a 3-by-3 square magic square, but its latest 2026 revision
explicitly says its arithmetic-progression result does not imply that
nonexistence. The problem therefore still requires a careful current-status
audit rather than treating either version as settled.

Primary artifact:

- `campaigns/1243/research/r2-category3-k3-second-iterate-genus2-covers/d1-cassels-tate/PAIRING_RESULT.md`

### 3. Campaign 6800022 — embeddedness obstructions for minimal surfaces

The report contains four exact scoped results:

- nonembeddedness of Costa's stated genus-one four-end family;
- a genus/end lower bound in Traizet's balanced layered small-neck regime;
- exclusion of the authenticated CCCC period locus by end crossing;
- an Arf/spin obstruction for the Kato--Muroya zero-spin genus-one four-noid
  class.

These form a plausible thematic paper:

> Embeddedness obstructions in genus-one four-ended minimal-surface families

The obstacle is not proof completeness but originality and source alignment.
Each result must be checked by a minimal-surface specialist to determine
whether it is new, implicit in the original constructions, or already known.
If at least two are genuinely new, the collection is paper-shaped.

Primary artifact:

- `campaigns/6800022/research/EXPLORATORY_NEGATIVE_REPORT.md`

### 4. Campaign 2800203 — limitations of a scalar planted-clique cavity method

Exact reviewed content:

- a collision-Gram-only nonlinear transfer cannot close;
- one explicit admissible rooted-\(C_4\), depth-three scalar schedule has
  root-in/root-out threshold discrepancy

  \[
  O(1/\log n+n^{-1/2}),
  \]

  and therefore cannot produce the required candidate list at
  \(k=\lceil\sqrt n/\log n\rceil\).

Both core verifiers were rerun successfully on 2026-09-05.

This is currently too narrow for a standalone paper because it excludes one
proof state and one explicit schedule, not the whole scalar AMP/cavity class.
It becomes publishable if upgraded to a natural theorem covering all bounded
scalar denoisers through a stated depth, or if connected to a recognized
low-degree/AMP barrier.

Primary artifact:

- `campaigns/2800203/research/EXPLORATORY_NEGATIVE_REPORT.md`

### 5. Campaign 1285 — lower bounds for restricted factoring controllers

The strongest theorem gives an infinite counterfamily against a frozen class
of one-gcd CRT-local controllers with equality and Jacobi-symbol feedback, with
success at most \(5/8+o(1)\). A second theorem gives exponential failure for a
low-\(L_1\) product-difference class. These are asymptotic theorems, not finite
search results.

The difficulty is the model: its grammar, constants, and restrictions were
designed inside the campaign and are not yet a standard computational model.
The one fixed SQUFOF tuple failure is not independently interesting.

Publication route:

- extract a simple oracle/query model recognizable to complexity and number
  theory readers;
- state an invariant lower bound without campaign-specific constants;
- explain why the model captures an existing family of proposed factoring
  algorithms.

Until that recasting is done, this is a strong internal theorem but a weak
paper proposition.

Primary artifact:

- `campaigns/1285/research/NEGATIVE_REPORT.md`

### 6. Campaign 1187 — collapse of a Nielsen-torsion quotient

Exact theorem:

\[
\mathcal D_{\mathrm{AC3}}=\mathcal R_U
\]

for \(G_{4,3}=F_4/[F_4^3,F_4]\), so the selected component-conjugation quotient
kills every realizable generating-tuple torsion class.

The verifier was rerun successfully on 2026-09-05. This is an all-tuple group
theorem, not a finite search. It could become a short group-theory note if the
quotient is used in the literature or if the result extends to a natural
family \(G_{n,p}\). For the single group alone, the theorem may be viewed as a
fairly direct consequence of known AC-equivalence results for nilpotent
groups, so novelty is presently uncertain.

Primary artifact:

- `campaigns/1187/research/experiments/periodic-central-ac3-torsion-lift/THEOREM.md`

### 7. Campaign 20000582 — finite Hilbert blocks for the Lang--Plaut route

The moving-window Engel construction gives injective Hilbert cocycles whose
finite balls are uniformly doubling, have an exact logarithmic gauge, and
incur at least \(c\sqrt{k}\) distortion against one homogeneous Engel gauge.

This is substantial technical infrastructure. It does **not** prove that the
blocks require unbounded Euclidean dimension or distortion, which is the
central missing implication for the Hilbert-space Lang--Plaut problem. The
correct publication strategy is to retain it as the construction section of a
future paper, not submit it alone.

Primary artifact:

- `campaigns/20000582/research/routes/engel_moving_difference_window/moving_window_doubling_theorem.md`

## Tier C: circulate as notes or corrections

### Campaign 2457 — exact correction of a printed heat-trace implication

The all-\(N\) diagonal family

\[
H_N=\operatorname{diag}(0_K,(3/10)I_{N-K})
\]

shows that the heat-trace bounds in `viXra:2506.0023v1` do not imply an
unbounded kernel. The verifier was rerun successfully on 2026-09-05.

This is mathematically correct and useful as an error report, but the target
is an unrefereed viXra manuscript and the countermodel is elementary. Send it
to the author or post a concise correction note; do not build a normal journal
submission around it.

### Campaign 2862 — corrected realization boundary

The report carefully distinguishes an abstract integral scissors-to-homology
lift from an effective bar-chain inverse and an irrational Chern--Simons
value. This is valuable expository cleanup, but no irrational value or new
candidate was obtained. It is not a research paper in its present form.

## Tier D: preserve, but do not submit now

The following contain exact local obstructions or finite certificates, but no
standalone theorem of adequate breadth at present:

| Campaign | Best retained content | Publication assessment |
|---|---|---|
| 1900020 | finite grouped-completion identities and refuted monotone energy clocks | method diagnostic only |
| 20000786 | \(k=3\) forces zero Hasse--Witt matrix and carry cancellation | lemma without target exclusion |
| 20001578 | exact row/layer reductions and width-zero obstruction in \(F\) | too far from amenability conclusion |
| 2305027 | signed flux identity and all-scale derivative estimate | necessary condition only |
| 2662 | exclusions for specified mutant-knot constructions | bounded family, no new knot pair |
| 2669 | Kirby/BP route obstructions and partial bands | incomplete topology |
| 1413 | finite Hall-core and matching-prefix certificates | finite experiment |
| 1465 | four scoped analytical lemmas | all-parameter construction missing |
| 1921 | 12.5 million coloring constraints without UNSAT | no theorem |
| 1994 | runtime/gate blockage | no new mathematics |
| 2248 | structural synchronization and unresolved signed incidence | no theorem |
| 1380 | finite box refinement | no family result |
| 8200002 | finite-field and characteristic-zero timeouts | no witness or exclusion |
| 8 | a 96-digit mandatory-factor obstruction in one search root | no exhaustion theorem |
| 1417, 1518 | still inside their five-day windows at the audit cutoff | assess only after termination |

## Recommended work order

1. Freeze campaign 2338 and write a 12--18 page clean draft containing only
   the multiplicity-five theorems.
2. Commission an independent human number-theory audit of the three imported
   Diophantine classifications and the complete \(K=7\) synthesis.
3. In parallel, finish or decisively fail the 1243 global Selmer upper bound.
4. Ask a minimal-surface specialist to assess the originality of the four
   6800022 obstructions before spending time typesetting them.
5. Keep 2800203, 1285, 1187, and 20000582 as theorem banks for future
   generalization rather than submitting bespoke negative-route papers.

## Literature boundary checked on 2026-09-05

- Erdős Problem 849 is still listed as open; no example with \(t\ge5\) is
  recorded, and the 2022 interior theorem only controls sufficiently deep
  indices.
- Public searches found no source stating the campaign's implications
  \(m(a)=5\Rightarrow K(a)\ge8\), \(m(a)=5\Rightarrow\omega(a)\ge7\), or the
  fourteen-prime condition on the \(\{5,6,7,8\}\) branch.
- The classical complete curve results used in the low-index proof are real
  published sources: Bugeaud--Mignotte--Siksek--Stoll--Tengely (2008),
  Avanesov (1966/67), and Mordell (1963).
- The Hilbert-space Lang--Plaut problem remains delicate; a claimed 2017
  counterexample was withdrawn, and current work still distinguishes the
  Hilbert case from the solved \(L_p\), \(p>2\), analogue.
- The latest revision of the 2025 magic-square preprint no longer claims that
  its arithmetic-progression result proves nonexistence of a square magic
  square.

