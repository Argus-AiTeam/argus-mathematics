# Original-frontier negative report: campaign 2457

## Result

**No exact counterexample candidate was obtained.** More precisely, no
candidate meeting any original Problem 1055 negative quantifier exists in the
campaign's recorded evidence. The following all remain open:

1. whether every exact class contains infinitely many primes;
2. whether the least-prime roots \(p_r^{1/r}\) tend to infinity, under the
   separate assumption that every exact class is nonempty; and
3. whether \(p_r^{1/r}\) is bounded, again under that nonemptiness assumption.

This is an exploratory negative report. It records exact, independently
reviewed route failures and proved reductions; it is not a proof that a
counterexample is impossible. It makes no novelty claim, no completeness claim
about possible constructions or the literature, and no claim that Problem
1055, the Erdos prediction, the Selfridge prediction, or every-class
infinitude has been resolved.

The earlier finite result is preserved separately in
`research/FINAL_NEGATIVE_REPORT.md`: the campaign verified
\(A005113(17)=1833174628057\), so that particular finite counterexample target
was exhausted. Nothing in this report replaces or enlarges that finite result.

## The sourced Problem 1055 frontier

The archived reading of T. F. Bloom's *Erdos Problem #1055* states that a prime
\(p\) is in class 1 when the only prime divisors of \(p+1\) are 2 or 3, and in
class \(r\) when every prime factor of \(p+1\) lies in a class at most \(r-1\),
with at least one in class \(r-1\). It then asks:

> Are there infinitely many primes in each class? If \(p_r\) is the least
> prime in class \(r\), then how does \(p_r^{1/r}\) behave?

The same source marks the problem **OPEN**, says it cannot be resolved by a
finite computation, and reports that Erdos expected \(p_r^{1/r}\to\infty\)
while Selfridge thought it likely to be bounded. The exact archived passage is
`research/literature/fc0d5ddc792e9f3e8c39550e1fb6395d.json`.

The fixed `formal-conjectures` source corroborates that class membership is
exact rather than cumulative and records the every-class infinitude and the
two growth variants with proof holes. It is a statement artifact, not a proof;
see `research/literature/ec7101a7031e1b9314b06f43ab50bef2.json`.
The weaker assertion that every positive exact class is nonempty is also
unproved in this campaign and is used only to make \(p_r\) a total sequence;
see `research/literature/c752698c417b80596859d5a2506bbe17.json`.

| Original branch | Exact negative bar | Campaign status |
|---|---|---|
| Every class contains infinitely many primes | Exhibit one fixed class \(r\) together with an exact proof that its class-prime set is finite (possibly empty). A finite list or finite search is not such a proof. | Open. The class-17 certificate proves one least element, not infinitude or finiteness of the class. No qualifying negative witness was obtained. |
| Erdos: \(p_r^{1/r}\to\infty\) | Under every-class nonemptiness, prove `C-NEG-ERDOS-DIVERGENCE`, equivalently a fixed bound attained at unbounded class indices. | Open. `C-BOUNDED-EXACT-CLASS-FAMILY` was not established. |
| Selfridge: \(p_r^{1/r}\) is bounded | Under every-class nonemptiness, prove that the roots are unbounded; the attempted sufficient target was `C-SELFRIDGE-UNIVERSAL-CHAIN-EXCLUSION`. | Open. The universal exclusion and its all-word zero-count remain unproved. |

The growth alternatives are incompatible, but the reviewed results do not
make them exhaustive. In particular, unboundedness alone refutes Selfridge
without proving convergence to infinity, and failure to tend to infinity is
weaker than a uniform bound. The every-class nonemptiness caveat remains in
force throughout.

## Reviewed reductions, not goal conclusions

Three reductions connect the attempted routes to the sourced questions:

- Under every-class nonemptiness, a fixed \(C\) and exact-class primes
  \(q_j\le C^{r_j}\) at unbounded indices imply that \(p_r^{1/r}\) fails to
  tend to infinity. This is the reviewed
  `C-FAMILY-IMPLIES-NEGATED-LIMIT`; the required family itself is open.
- A fixed-exponential exact-class family is equivalent, up to replacing the
  base by at most \(C^3\) in one direction, to strictly increasing
  negative-residue prime chains of unbounded length,
  \(q_i\mid q_{i+1}+1\) and \(q_L\le C^L\). This is the reviewed
  `C-INCREASING-NEGATIVE-CHAIN-EQUIVALENCE`; existence of the chains is open.
- Under every-class nonemptiness, exclusion of some length-\(r\) such chain
  below \(C^r\) for every fixed \(C\) would make \(p_r^{1/r}\) unbounded and
  refute Selfridge boundedness. This is the reviewed
  `C-SELFRIDGE-EXCLUSION-REFUTES-BOUNDEDNESS`; the universal exclusion is
  open.

The exact statements, assumptions, judgements, and retirement reasons are in
`research/MATH_STATE.json`.

## Attempted routes and exact retirement boundaries

| Route | Strongest independently reviewed result | Exact boundary and input required for a materially different reopening |
|---|---|---|
| `R-FINITE-A005113-EXTENSION` | The finite equality \(A005113(17)=1833174628057\) is proved by the reviewed target and strict-lower-bound certificates. | A fixed index cannot meet an unbounded-index limit quantifier or decide infinitude in a fixed class. More table extension, recertification, or repackaging does not reopen this route. An original-frontier attack needs a parametric exact certificate or structural theorem carrying the required infinite quantifier. |
| `R-SEVEN-MULTIPLIER-BOUNDED-LIFT` | For the root \(q_2=13\) and alphabet \(\{2,8,10,12,14,32,92\}\), the corrected lift bound is \(q_r\le13\cdot92^{r-2}<92^r\). Exact reconstruction covers 47 live sources and 329 edges, leaves the class-18 frontier \(\{3666349256113\}\), and proves all seven class-19 children composite. | The class-19 frontier is exactly empty, so this frozen tree has no infinite prime path. The broader bounded-family claim is untouched. Reopening that branch requires an infinite certified construction outside this exhausted root/alphabet mechanism, not a longer search inside it. |
| `R-LOGARITHMIC-PLUS-PRIME-CHAINS` | The increasing-chain equivalence is proved. Xylouris supplies correct-sign chains of every finite length, but only with \(q_L\le\exp(D\,5.2^{L-1})\). | Every obtained primary theorem misses at least one required feature: Ford--Konyagin--Luca have the opposite sign; Xylouris has a double-exponential rather than \(C^L\) endpoint; Jones and Bhardwaj--Degen--Petkov--Stanbury leave arbitrary numerical lengths conjectural; Stones proves obstructions rather than existence. This retires only those applications. Reopening requires an unconditional correct-sign, unbounded-length theorem with one uniform exponential endpoint, or a direct exact-class family. |
| `R-EVENTUALLY-PERIODIC-LIFTS` | Every eventually periodic positive-integer multiplier tail forces a later block-phase term to be a proper multiple of an earlier prime; deterministic autonomous finite-state multiplier generators are included. | The existence obligation for this route is refuted. A bounded-family construction must use a genuinely non-eventually-periodic mechanism unless an error is found in the reviewed modular argument. |
| `R-UNIFORMLY-RECURRENT-APERIODIC-LIFTS` | No uniformly recurrent finite-alphabet multiplier tail can generate the required infinite increasing prime chain. Separately, any exponential chain forces one fixed even multiplier \(m\) to occur infinitely often, hence infinitely many prime pairs \(q,mq-1\). | Uniform recurrence is exhausted, but sparse nonrecurrent words and unbounded alphabets remain open. A reopening needs an explicit all-index prime construction with bounded cumulative logarithmic multiplier cost and a nonrecurrent mechanism. The fixed-\(m\) prime-pair infinitude is necessary but not sufficient. |
| `R-UNIFORM-FINITE-CHAIN-ROWS` | Even unrelated rows under one \(C^L\) endpoint would force, for every finite \(k\), one fixed even \(k\)-multiplier word having infinitely many all-prime affine trajectories; \(k=1\) already forces infinitely many \(p,mp-1\) pairs for one fixed even \(m\). | No constructor or unconditional existence theorem was obtained. Reopening requires the fixed affine prime-pattern input in every finite dimension together with effective control strong enough to construct every row under one global \(C\); isolated pairs or finite rows do not suffice. |
| `R-DUBBE-GROWING-DIMENSION-SIEVE` | Every length-\(r\) chain has an admissible all-even suffix of length \(K\ge\lfloor r/2\rfloor\), with multiplier product below \(C^r/r\). The exact full-chain tuple \(2,3,5,19,37,73\) shows why deleting the small-start prefix is necessary. | Dubbe's explicit sieve is outside its stated range in the required growing dimension, and no aggregate all-word singular-series zero-count was proved. Reopening needs either a different structural exclusion or both a growing-dimension prime-tuple bound valid in the actual short intervals and an explicit aggregate estimate over every allowed multiplier word. |

These are route-specific exhaustions. None is evidence that all routes to any
original branch are impossible.

## The Dubbe obstruction in the required scale

For an admissible suffix word with terminal multiplier product \(A\), the
available start interval satisfies

\[
Y_{\mathbf m}<\frac{C^r}{A}+1
\le \frac{C^r}{2^{K-1}}+1,
\qquad K\ge\left\lfloor\frac r2\right\rfloor.
\]

Thus, for each fixed \(C\),
\(\log Y_{\mathbf m}=O_C(r)\), uniformly over the allowed words. Dubbe's
Theorem 1 instead assumes

\[
\log Y>1.1922\cdot10^{15}K^2\log K.
\]

Because \(K\ge\lfloor r/2\rfloor\), its required lower bound is
\(\Omega(r^2\log r)\). The theorem therefore gives no estimate in the eventual
fixed-\(C\) regime needed for universal chain exclusion.

Removing only that threshold would still not close the route. The theorem's
bound retains \(2^K K!\) and the exact word-dependent singular series. The
missing conclusion is one bound below 1 after summing over every
\(K\in[\lfloor r/2\rfloor,r]\), every admissible even multiplier word with
product below \(C^r/r\), every associated short start interval, and every
local factor. No reviewed theorem or derivation supplies this all-word
singular-series estimate or the resulting zero-count.

The primary theorem pages and exact calculation are available without
regeneration in
`research/selfridge_chain_exclusion/dubbe_2409.04261v1_pages_1_3.txt` and
`research/selfridge_chain_exclusion/README.md`.

## Open frontier after the reviewed routes

- **Every-class infinitude:** no class-specific global finiteness certificate
  exists in the campaign evidence. A qualifying negative result must control
  all primes in one fixed exact class, not merely a finite range.
- **Negated Erdos divergence:** `C-BOUNDED-EXACT-CLASS-FAMILY` and
  `C-NEG-ERDOS-DIVERGENCE` remain open. Sparse nonrecurrent or
  unbounded-alphabet chains are not ruled out, but no exact constructor is
  available.
- **Selfridge boundedness branch:** `C-SELFRIDGE-UNIVERSAL-CHAIN-EXCLUSION`,
  `C-GROWING-DIMENSION-SIEVE-UNIFORM-BOUND`, and
  `C-ALL-MULTIPLIER-WORD-ZERO-COUNT` remain open. The Dubbe mismatch retires
  one sieve application, not universal exclusion.

Accordingly, the campaign reaches an **exhausted attempted-route boundary**,
not an exact-candidate boundary and not a global impossibility theorem.

## Evidence index for independent review

All material assertions above can be checked from existing artifacts; no
certificate, search, snapshot, or manifest needs to be regenerated.

| Scope | Project artifact | Sealed independent review |
|---|---|---|
| Original source, exact-class reading, and nonemptiness caveat | `research/MATH_STATE.json`; `research/literature/fc0d5ddc792e9f3e8c39550e1fb6395d.json`; `research/literature/ec7101a7031e1b9314b06f43ab50bef2.json`; `research/literature/c752698c417b80596859d5a2506bbe17.json` | Reviewer literature judgements embedded in `research/MATH_STATE.json` |
| Frozen finite equality and why finite extension is retired | `research/FINAL_NEGATIVE_REPORT.md` | `/home/argustest/zimo/.argus-campaign-2457-run3/projects/90f44b3681b7/handoffs/f22df7861ba4/round-0001.json` |
| Original negative target and certificate bar | `research/MATH_STATE.json`, context `ctx-2457-erdos-divergence-negative` | `/home/argustest/zimo/.argus-campaign-2457-run4/projects/90f44b3681b7/handoffs/b8303c809ff3/round-0001.json` |
| Corrected seven-multiplier exhaustion | `research/bounded_lift_family/README.md`; `research/bounded_lift_family/certificate.json` | `/home/argustest/zimo/.argus-campaign-2457-run4/projects/90f44b3681b7/handoffs/cfb17a3a9424/round-0002.json` |
| Increasing-chain equivalence and primary-source mismatches | `research/plus_prime_chains/README.md`; `research/plus_prime_chains/primary_source_excerpts.md` | `/home/argustest/zimo/.argus-campaign-2457-run4/projects/90f44b3681b7/handoffs/37a9fec16984/round-0001.json` |
| Eventually periodic obstruction | `research/eventually_periodic_chains/README.md` | `/home/argustest/zimo/.argus-campaign-2457-run4/projects/90f44b3681b7/handoffs/0795e7b24968/round-0001.json` |
| Aperiodic necessary condition and uniform-recurrence obstruction | `research/aperiodic_bounded_family/README.md` | `/home/argustest/zimo/.argus-campaign-2457-run4/projects/90f44b3681b7/handoffs/c38804cb223a/round-0001.json` |
| Unrelated finite-row obstruction | `research/uniform_finite_chain_family/README.md` | `/home/argustest/zimo/.argus-campaign-2457-run4/projects/90f44b3681b7/handoffs/c21271bd63ce/round-0001.json` |
| Selfridge implication, admissible suffix, Dubbe mismatch, and open zero-count | `research/selfridge_chain_exclusion/README.md`; `research/selfridge_chain_exclusion/dubbe_2409.04261v1_pages_1_3.txt` | `/home/argustest/zimo/.argus-campaign-2457-run4/projects/90f44b3681b7/handoffs/aa8376c34477/round-0001.json` |

This report itself still requires the normal independent Reviewer decision
against the exploratory campaign target. It does not self-certify campaign completion.
