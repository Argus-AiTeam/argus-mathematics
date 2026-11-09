# Fixed-order divisor moment: Engineer assessment

**Assessment:** supported in the precise fixed-order scope below. This is a reproduction of an upstream natural-order proof plus an Argus real-order/endpoint bridge, not a novelty claim or current independent Reviewer acceptance. No material mathematical gap was found in that scope. Whole-family native Reviewer acceptance remains pending.

## Sources and scope

All historical paths below are read-only and relative to `campaigns/9000025/`. Write `B = research/divisor_moment/`, `U = B/upstream/OAI/NumberTheory/ShortEgyptian/`, and `M = research/openai_manuscript/Short-Egyptian-fractions-September-25-2026/build/divisors.tex`. Line numbers refer to those actual files, not a reconstructed source.

I read the complete fixed-order `B/Main.lean`, its bridge and fidelity document, preparation/checker code, archived certificate and compiler output, operational receipts, relevant root-ledger records, and `M:1–273`. The source reconstruction and arithmetic checks were performed in memory with no old-workspace writes, network calls, old-script execution, or fresh Lean source/compilation. `replay.json` binds the measured bytes and results.

## 1. Exact assertion and domain

For positive integers `n`, the relevant count is

\[
d_X(n)=\#\{a\in\mathbb Z_{>0}:a\mid n,\ a\le X\}.
\]

The manuscript defines this for `X >= 1` (`M:3–8`). Lean defines `truncatedDivisors X n = n.divisors.filter (fun a => (a : ℝ) <= X)` and its cardinality (`B/Main.lean:306–310`). For positive `n`, these are precisely the positive divisors; zero is not a divisor of positive `n`. No convention about counting divisors of zero enters the sum.

The supported statement, matching `M:22–35`, is

\[
\begin{aligned}
&\forall D,r\in\mathbb R,\ D,r\ge1,\quad
\exists S_0=S_0(D,r)\in\mathbb R,\quad
\forall S\ge S_0,\ \forall X,Y\in\mathbb R,\ N\in\mathbb N,\\
&X>0,\quad S/(2\log S)\le\log X\le DS,\quad
X^{1/2}\le Y\le X,\quad N\le e^{DS}\\
&\hspace{25mm}\Longrightarrow
\sum_{1\le h\le Y} d_X(N+h)^r\le Y e^{S^{1/4}}.
\end{aligned}
\]

The parameters `D,r` really are real, and `N` is an arbitrary nonnegative integer in the displayed exponential range, **not** restricted by `X` or `Y`. The threshold precedes all choices of `S,X,Y,N`; uniformity in those variables is substantive. There is no single threshold uniform in an unbounded order `r=r(S)`.

The manuscript's ordinary real logarithm implicitly requires `X>0`; its eventual range then forces `X>1`. Lean's `Real.log` is total: `log 0 = 0`, and on negative arguments it agrees with the logarithm of the absolute value. Thus its logarithmic inequalities alone must not be used to infer `X>0`. The explicit `0 < X` in `B/bridge.lean.txt:30,68` is the manuscript's real-log-domain convention, not a new restriction on conventionally admissible manuscript inputs. With the chosen eventual condition `S>1`, the lower bound makes `log X>0`, hence `X>=1`, `Y>0`, and every `N+h` in the sum is positive (`bridge.lean.txt:35–45,55–59`).

## 2. Decisive natural-order proof, not just compiler status

The natural-order theorem is `OAI.ShortEgyptian.uniform_divisor_moment`, with fixed `k : ℕ`, real `D>=1`, and the same ranges expressed using `v` and `X=exp v` (`B/Main.lean:1439–1460`). Its proof closes through explicit finite estimates, not an assumed moment theorem.

### Combinatorial and analytic inputs

* **Product inequality without coprimality.** `truncatedDivisors_mul` (`Main.lean:312–328`) covers every divisor `a` of `de` by a pair `b|d`, `c|e`, `bc=a`, with `c<=a<=X`, and bounds the cardinality of the image of the product set. Repeated primes shared by `d,e` are allowed. The manuscript's equivalent injection uses `b=gcd(a,d)`, `c=a/b` (`M:123–136`): the prime-adic inequality `v_p(c)=max(v_p(a)-v_p(d),0)<=v_p(n)-v_p(d)` proves `c|n/d`. Thus no unjustified coprimality cancellation is present.
* **Rough divisor count.** `Main.lean:330–473` bounds the prime-factor count by `log n/log z`, proves the weighted divisor generating bound `sum_{a|n} q^Omega(a) <= (1+q)^Omega(n)` by induction on prime factors (including multiplicities), and uses `0<q<1`. Substituting `q=v/W` gives `d_{exp v}(n) <= exp(Bv/log z)`, where `B=1+log(W/v)` (`819–833`). This is the weighted-subset argument of `M:51–63`, not a squarefree-only argument.
* **Genuine convergent constants.** Put `A_k = sum_{j>=0}(j+2)^k(3/4)^j`. Summability and the local exponential bound are proved at `Main.lean:145–182`. Multiplicativity and a Mathlib Euler-product theorem then give finite smooth-number weight bounds (`184–293`). There is no assumption that a divergent series has a finite value. For primes and `sigma>=1/2`, `p^(-sigma)<=3/4`, which is sufficient for these estimates.
* **Shift-uniform occurrence bound.** `multiples_interval_bound` (`639–678`) injects multiples into their quotients and obtains `# <= Y/d+1 <= 2Y/d` when `0<d<=Y`. `sum_le_divisor_cover` (`680–721`) explicitly overcounts a nonnegative cover and interchanges finite sums. Neither statement depends on the distance `N` of the interval from zero.

### Exhaustive finite cover and decay

The finite theorem `divisor_moment_finite` (`Main.lean:934–1093`) uses a prime prefix with `d<=R=sqrt Y<dp`. The prefix split is proved by induction on `n` (`572–620`). Integers `n<=R`, including `n=1`, are handled separately, so the prefix construction is never applied where there is no next prime.

In the numeric specialization (`Main.lean:1255–1437`), set

\[
W=(D+1)S,\quad B=1+\log(W/v),\quad z=S^{1/2},
\quad T=S^4,\quad L=S^{7/8}.
\]

The interval hypotheses imply `n<=N+Y<=2 exp(DS)` and therefore `log n<=W` uniformly (`Main.lean:1351–1363`). The cover has:

1. the small integers and prefixes whose next prime has `log p>=L`;
2. prefixes with next prime `p<=T`, using an unweighted smooth-prefix estimate and a pointwise moment bound;
3. all remaining prefixes, indexed by `t=floor(log p)`, where `log T/2<=t<=L`, `p<=exp(2t)`, and `d>=exp(v/5)`.

These are actual covering cases in `Main.lean:974–1044`, not a probabilistic model for the integers in the interval. Positivity and `d<=sqrt Y<=Y` justify the multiples estimate throughout.

For a middle band, write `Q=v/t` and `lambda=log Q/(10t)`. `moment_band_nonpos` (`Main.lean:1120–1185`) proves `0<=lambda<=1/2` and bounds the two positive exponent terms by `Q log Q/200` each, against the negative term `Q log Q/50`. Its hypotheses are derived uniformly using

\[
S^{1/16}\le Q\le S^2,\quad
kB\le\log S/3200,\quad
A_k H(e^{2S})\le S^{1/20}\log S/3200,
\]

where `H(T)=8+4 log(1+log T/log 2)`. For the small-prime case the pointwise exponent and the smooth correction are each at most `v/200`; the Rankin penalty is `-v/50` (`Main.lean:1326–1355`). Thus the non-large cover weights have total reciprocal mass at most one per index.

Consequently the finite proof gives

\[
2Y\left(\exp(kBv/L+A_k H(\sqrt Y))+\lfloor L\rfloor+1\right).
\]

The two parts of the large-case exponent are each bounded by `S^(1/4)/8`, the index count is absorbed into `exp(S^(1/4)/2)`, and the remaining factor four is absorbed at the same fixed threshold (`Main.lean:1390–1437`). This yields exactly `Y exp(S^(1/4))`, not an unspecified multiplicative constant in front.

Finally `Main.lean:1204–1234,1439–1460` proves the needed eventual logarithm-versus-power estimates and intersects finitely many eventual conditions **before** introducing `v,Y,N`. Constants such as `A_k` are fixed here. This establishes the required threshold dependence only on `D,k`. Substituting an unbounded `k(S)` into this fixed-order intersection would not establish a uniform threshold.

### Relation to the manuscript's written argument

The manuscript uses the same weighted rough-factor count, divisor-prefix injection, shift-uniform multiples bound, and Rankin weighting. Its large/very-small/intermediate contributions are at `M:154–164`, `176–200`, and `203–260`; the uniform final absorption is at `M:262–273`. The decisive comparisons are sound in the fixed-order regime: `v>=S/(2 log S)` makes `S^(2/5)=o(v)`; `Q>=v^(1/16)` makes the positive middle-band terms negligible against `Q log Q`; and the final logarithmic loss is `o(S^(1/4))`.

The formal proof is nevertheless a **variant**, not certification of every displayed manuscript constant. It uses a Chebyshev/dyadic prime-reciprocal bound rather than the manuscript's zeta bound; a cruder small-smooth correction `O(S^(1/2))` rather than `O(S^(2/5))`; and integer log-prime bands up to `L=S^(7/8)` rather than dyadic bands up to `v^(15/16)`. The larger number of formal bands is still absorbed exponentially. These differences preserve the stated lemma and explain why compiler success must not be advertised as line-by-line verification of the manuscript.

## 3. Real-order and endpoint bridge

`B/bridge.lean.txt:1–78` is exactly the tail of `Main.lean:1466–1543`.

1. **Fixed ceiling and valid bases.** Choose `k=ceil_nat(r)` once, before the eventual statement (`bridge.lean.txt:35`). For `n=N+h>0`, divisor `1` witnesses `d_X(n)>=1` when `X>=1` (`21–26,55–59`). The natural cardinality is nonnegative, and, more importantly, its real cast is at least **one**. Thus `d^r<=d^k` follows from exponent monotonicity and `r<=k` (`60–61`). Mere nonnegativity would not suffice: exponent monotonicity is reversed for bases between zero and one.
2. **Exact logarithmic substitution.** `v=log X`, `exp(log X)=X`, and `exp(log X/2)=X^(1/2)` use `X>0` (`38–50`). The upper bound on `Y` and full bound on `N` pass unchanged.
3. **Exact endpoints.** For the positive `Y` in the eventual range, natural `1<=h<=Y` is exactly `Icc 1 floor_nat(Y)`. Only the summation endpoint is floored; the right side is still the original real `Y`, and so is the hypothesis on `Y`.
4. **No boundary loss under shifting.** `shifted_sum` proves the bijection `h -> N+h` from `Icc 1 H` to `Ioc N (N+H)` for every natural `N,H` (`6–19`). Its inverse is `n-N`, justified by `n>N`; it remains valid for `H=0` when both sets are empty.
5. **Threshold order.** The natural theorem at this fixed ceiling is intersected with `S>1` before introducing `X,Y,N`. `Filter.eventually_atTop.mp` then supplies the single real threshold (`66–73`). The conclusion has exactly the quantifier order in Section 1.

The compiler's unused-`hr` warning is harmless: the proof uses the stronger base-at-least-one comparison without needing `r>=1` internally, while its declared manuscript-facing statement still has that hypothesis.

## 4. Upstream inventory and compatibility port

Archived attribution is `openai/math`, revision **`4eaee87548250b2682affda7d05d947c05554bae`**, recorded in `B/prepare.py:10–11`, `Main.lean:5–7`, and `statement_fidelity.md:55–64`. `LICENSE.upstream` is Apache-2.0. No fresh remote provenance/novelty search was made.

**Count correction:** the actual archive contains **28** files in `U/*.lean.txt`, not 27. There are 27 non-`Model` modules plus the 19-line `Model.lean.txt` base reference; equivalently the original chain has 27 OAI-import edges and a Mathlib-importing leaf. No file is silently omitted.

The nine incorporated proof modules, in bundling order, are:

| Upstream file in `U/` | Original lines | Incorporated `B/Main.lean` section |
|---|---:|---:|
| `PrimeReciprocals.lean.txt` | 1–109 | 22–133 |
| `DivisorWeights.lean.txt` | 1–157 | 134–294 |
| `TruncatedDivisors.lean.txt` | 1–176 | 295–474 |
| `PrimeSplitting.lean.txt` | 1–147 | 475–625 |
| `DivisorCover.lean.txt` | 1–97 | 626–726 |
| `SmoothBounds.lean.txt` | 1–156 | 727–886 |
| `DivisorMoments.lean.txt` | 1–208 | 887–1098 |
| `MomentDecay.lean.txt` | 1–88 | 1099–1190 |
| `MomentAsymptotics.lean.txt` | 1–272 | 1191–1465 |

The other **19 reference-only modules**, in original import order, are:

`Model`, `Basic`, `GreedyExistence`, `LowerBound`, `FiniteFourier`, `Distinctness`, `FirstDerivative`, `SecondDerivative`, `ReciprocalDifferences`, `IntervalDifferencing`, `IteratedDifferencing`, `ReciprocalEstimates`, `ParameterBounds`, `FourierDiscrepancy`, `WindowSpectrum`, `WindowDiscrepancy`, `EmpiricalDiscrepancy`, `DeterministicMean`, `ResidueDiscrepancy` (each with suffix `.lean.txt` in `U/`).

Their import references are at line 1 of each file. They belong to the broader Egyptian-fraction/Fourier/discrepancy chain. They are **not incorporated in, or certified as standalone results by, this compilation**. The first incorporated file originally imports `ResidueDiscrepancy`, but its divisor-moment declarations do not need that earlier chain after flattening. `Main.lean` imports only Mathlib; all nine non-Mathlib moment sections and the bridge are textually present. These files, the flattened copies, and the NAT/BRIDGE claim decomposition are dependencies/copies of one unit, not 28 Argus draft units or novel Argus results.

The upstream toolchain record is `leanprover/lean4:v4.34.1` (`B/upstream-toolchain.txt:1`). The compatibility port targets actual Lean 4.31.0:

* `compatibility.lean.txt:1–11` proves the missing real-list lower-sum lemma by induction; it does not postulate it.
* Imports are flattened; two `prod_le_prod₀` uses become `prod_le_prod`, four `ite_eq_left` and seven `ite_eq_right` uses become `if_pos` and `if_neg`, and one `Real.log_pow` tactic sequence is adjusted (`prepare.py:49–64`).
* Reimplementing precisely those text operations in memory reproduces `Upstream.lean.txt` byte-for-byte; appending the existing bridge reproduces `Main.lean` byte-for-byte. There are no unexplained source changes in that reconstruction.

## 5. Exact historical evidence binding

### Claim versions

These are ledger **claim-content identifiers**, not source-file SHA-256 values:

| Claim/version | Exact recorded content hash | Root ledger lines |
|---|---|---:|
| `C_DIVISOR_MOMENT_REAL` v1 | `0ce79e218a17fe7efd7b10e516250bea96534fe2d7f4423b48a2be6d1eea8eff` | `research/MATH_STATE.json:51–63` |
| `C_DIVISOR_MOMENT_REAL` v2 | `f59449f2a9554053f0a4cc5aadc3161c67cd61013da5b728b5e05c1d4f32238d` | `93–105` |
| `C_DIVISOR_MOMENT_NAT` v1 | `5bd3963d0356435090d6af4ecb6359bdcfcf4a5a4e107d7e7219b829bf4936e6` | `65–77` |
| `C_DIVISOR_MOMENT_BRIDGE` v1 | `4efcc546d65621bb5fca9f9c6a5ca014e535dba2781641d100ca424bdd34c459` | `79–91` |

REAL v1 and v2 have the same natural-language assertion; v1 has an empty formal statement, whereas v2's decoded `formal_statement` (`MATH_STATE.json:101`) equals the actual `Main.lean` bytes after UTF-8 encoding. They are predecessor/source-bound versions, not two results.

Mechanical evidence **`lean-C_DIVISOR_MOMENT_REAL-453fe5a3901e`** (`MATH_STATE.json:264–274`) cites `B/certificates/C_DIVISOR_MOMENT_REAL-fc7c571de81c7bb9.json`. Its subject is exactly REAL v2's hash, not v1. The certificate's actual file SHA-256 is `dd35aee239af191c99aedc55dcde4403c0668ec712d6722ab02bbebed8bb947a`; its filename suffix is not being treated as that digest.

Measured bindings:

| Bytes checked | Bytes | SHA-256 |
|---|---:|---|
| Actual `B/Main.lean` and certificate `lean_source.text` encoded as UTF-8 | 73628 | `38ffc99695cb756c8d1542920481c5a921a128ad9bca6045443c4bcea956e84b` |
| Actual `B/statement_fidelity.md` and certificate `statement_fidelity.text` encoded as UTF-8 | 4133 | `45cda5e779cf64854c0342de3b2683e6b4d97f282e3f75d1a6211929b22a8002` |
| Actual `M` | 9599 | `51edf294338d1a7206ea8c967d39fec9331cf7f91db0c4e9356e8d37aa0949d2` |

The embedded-text equalities are exact, not merely matching reported hashes (`certificate:29–31,54–67`). The certificate's entire `lean_check` object equals `B/lean_check.json`; `exact_certificate.json:31–40` matches the root mechanical record, and the archived compiler stdout occurs verbatim in `compile.log`. Thus the archived reviewed/compiler evidence is reusable for these unchanged bytes. **This review did not run Lean anew.**

### Real tools, result, and inherited assumptions

The actual old execution was `$WORKSPACE/.elan/bin/lake env lean <old B/Main.lean>`, with working/library directory `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0` (`B/lean_check.json:6–30`). It records:

* Lean **4.31.0**, `x86_64-unknown-linux-gnu`, release commit `68218e876d2a38b1985b8590fff244a83c321783`;
* Lake `5.0.0-src+68218e8` and elan `4.2.3 (b6cec7e10 2026-06-08)`;
* compiler exit `0`, proof-hole audit exit `0`, empty `proof_holes`, no stderr, and duration `84561 ms`.

The archived `#print axioms` output is exactly:

```text
'OAI.ShortEgyptian.uniform_divisor_moment' depends on axioms: [propext, Classical.choice, Quot.sound]
'DivisorMomentAudit.manuscript_divisor_moment' depends on axioms: [propext, Classical.choice, Quot.sound]
```

See `Main.lean:1542–1543`, `lean_check.json:31–44`, and `compile.log:16–17`. These inherited Lean/Mathlib foundations are real assumptions, notwithstanding the ledger's empty list of theorem-specific external assumptions. The printed name is `propext`; no `sorryAx` or unproved moment axiom appears. The archive identifies the Mathlib v4.31.0 workspace but does not record an immutable Mathlib Git commit/content digest; this review does not invent one or claim a fresh external-library rebuild.

### Historical judgement versus present acceptance

The root ledger has exact supporting judgement **`judgement-C_DIVISOR_MOMENT_REAL-640ce90b565a`**, produced by **`reviewer:gpt-6.1-sol`**, for REAL v2 (`research/MATH_STATE.json:312–322`). This is substantive historical independent-review evidence for the combined claim and must not be omitted.

In contrast, NAT's `judgement-C_DIVISOR_MOMENT_NAT-9a33a9381246` and BRIDGE's `judgement-C_DIVISOR_MOMENT_BRIDGE-770a0559ed51` are both produced by **`engineer:gpt-6.1-sol`** (`288–310`). They are not separate independent Reviewer acceptances. The additional REAL judgement `...-b4bce24e9226` is Engineer evidence too (`276–286`). This Engineer report does not mint a new independent acceptance or infer whole-family completion from the historical combined judgement.

### Routes and operational receipts

`R_DIVISOR_MOMENT_PORT` is retired for source-version supersession, **not theorem failure** (`MATH_STATE.json:530–549`). There is a metadata wrinkle: its retirement text calls its goal reference source-free/stale, but the extant goal hash at line 534 is already REAL **v2**, not v1. The exact stored fields take precedence over that description.

`R_DIVISOR_MOMENT_CERTIFIED_SOURCE` (`551–570`) has goal REAL v2 `f59449…`, NAT obligation `5bd396…`, and BRIDGE obligation `4efcc5…`, all resolving to the versions in the table; its retirement field is empty. No dangling/mismatched hash was found in this route in the actual root old ledger. Graph labels alone are not this finding's basis.

`source_receipt.json`, `port_receipt.json`, `port_compat_receipt.json`, `certify_receipt.json`, and `certify_checked_receipt.json` each contain a submitted durable-task receipt at line 1. They document provenance of attempted operations, not successful proofs by themselves. `campaign_checks.json:4–30` records historical structural checks with exit zero (including a four-node graph at that stage), not statement fidelity or present family acceptance. `research/PROOF_GRAPH.json:15–49` likewise supplies scope/status metadata rather than proof.

## 6. Safe finite replay

Inspection preceded execution. `prepare.py:23–29,61–64` can download and write in the old workspace. `verify.py:105–125,129–141,186` writes structural reports, removes/replaces the certificate, and invokes ledger-writing verification. Neither script nor its `main`/`record_checks` was executed.

Instead, an independent bounded implementation used prime factorization to enumerate divisors and exact `Fraction`/integer comparisons. It matched the archived finite-check counts (`verify.py:39–102`, `exact_certificate.json:42–57`):

* **525** shifted-moment identities: five shifts `0,1,17,100,10^6`, seven endpoints `0,1/2,1,3/2,7/3,10,101/10`, five cutoffs `1,3/2,17/3,12,25/2`, and natural orders `1,2,4`.
* **3225** product inequalities for `1<=n<=128`, every divisor `d|n`, and those five cutoffs; additionally **8360** explicit gcd factor-pair witnesses were checked for membership, reconstruction, and injectivity.
* **320** exact ceiling comparisons for `r=1,3/2,7/3,16/5,101/10` and integer bases `1..64`, comparing `d^a <= d^(ceil(r)*b)` for `r=a/b`. No floating real-power approximation was used.
* **120** shifted multiples-count comparisons, also checking `# <= Y/d+1 <= 2Y/d` on the endpoint/shift grid and `1<=d<=floor(Y)`.

The archived Jacobian contract allows `integer.compute.divisor_count` only on one positive integer up to 10000 (`jacobian_contract.json:20–30`). Its payload is `360`, its typed output is `"24"`, and the recorded server/protocol are `0.14.0`/`2025-11-25` (`jacobian_payload.json:1–3`, `jacobian_output.json:1`). Independent arithmetic reproduced **tau(360)=24** and checked the request/payload binding. No adapter was called. This verifies one bounded count, not the moment theorem or its asymptotic quantifiers.

## 7. Verdict boundaries and remaining obligations

* **Supported:** the full fixed-real-order, real-endpoint, shift-uniform lemma, with `S_0(D,r)` and the exact displayed right side; the upstream natural-order proof closure; and the explicit real-order/floor/shift bridge. Support combines a mathematical inspection, exact archived-source binding, reused historical kernel evidence, and separate finite sanity checks.
* **No material mathematical defect identified in that scope.** The concrete count discrepancy (28 physical files versus “27”) and stale wording in the retired route are provenance/metadata qualifications, not counterexamples or missing steps in the supported theorem.
* **Not established by this unit:** the entire Egyptian-fraction manuscript or its descent/main theorem; all excluded upstream modules; line-by-line formal verification of every displayed manuscript estimate; any growing-order uniform threshold obtained by substituting `r(S)`; novelty or publishable significance; or external authentication/rebuilding of the upstream repository and complete Mathlib installation.
* **Acceptance remains separate:** the current native Host-invoked independent Reviewer must assess the coverage index and all units, including growing order. Neither this Engineer verdict nor the old REAL v2 judgement self-accepts the current whole-family review.
