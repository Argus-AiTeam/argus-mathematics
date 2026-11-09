# Finite models and excluded shortcuts — Engineer evidence assessment

## Verdict and attribution

**Supported as bounded exact finite checks and constructive rejections of two
proof shortcuts; not a universal transfer proof or a manuscript refutation.**
This is the Engineer's assessment, pending the Host-invoked independent
Reviewer. It does not accept a finding or declare family completion.

The sources are the preserved campaign `9000012` files
`research/adaptive-cut-transfer/verify.py` and `exact_certificate.json`, both
read completely. These are old Argus experiments and illustrative constructions,
not independent results each time their outputs are serialized. No novelty is
established. The source digests are:

- `verify.py`: `5b2826c36e1bc3213432ebaff0d179ea7f55e42645e397855d477fe0fdb392e4`.
- `exact_certificate.json`: `276203847e2f1ae5e3f348ae0a004bf29a99676b6805df94c05f7c603e9c3ac4`.

The retired routes `R_EXCLUDED_OPTIMIZER_CONDITIONING` and
`R_EXCLUDED_CONDITIONAL_MOMENTS` concern unavailable shortcuts. The old draft
does not attribute either shortcut to the original manuscript. Their failure
does not refute the transfer theorem, its proposed strengthening, or the joint
Dickman manuscript.

## Real replay and write safety

Before execution, the entire checker was inspected. Its only explicit write is
`HERE/exact_certificate.json` inside `main()` when `--write-certificate` is
passed. The replay instead imports the unchanged source with bytecode writes
disabled and invokes its original `certify()` function; neither `main()` nor
the write option is invoked. `HERE` and `ROOT` retain their old values for
read-only input resolution. New mathematical-result files are confined to this
unit's `finite_replay/`.

The real run used `$WORKSPACE/argus-latest/.venv/bin/python`, Python
3.13.5, with exact integers and `fractions.Fraction`, and exited **0**.
`finite_replay/submission.json` preserves the durable submitted receipt;
`durable_status.json` records completion. Its task is
`review012-finite-models-replay-20261107`.

Artifacts:

- `finite_replay/replay.py`: the read-only import/replay harness.
- `finite_replay/finite_result.json`: the freshly computed seven finite fields.
- `finite_replay/comparison.json`: **all seven finite fields match** the old
  certificate, not merely selected counts.
- `finite_replay/replay_status.json`: runtime, original assertion success,
  input digests, and the unchanged-before/after input check.
- `finite_replay/jacobian_link.json`: independent linkage of the lead's current
  typed moment replay to the rare-positive triangle.

The original `lean_core()` assertions also passed, but they inspect the
**historical** source/run/certificate/ledger. They are not another Lean
compilation. The real fresh compilation is assessed in `../finite-cut-core/`.
Comparison deliberately excludes historical Lean provenance and top-level
labels such as `result_class`, `theorem`, and `universal_probability_proof`.
In particular, replaying the old assertion “Complete prose proof” is not an
independent verification of that assertion.

## 1. The 729 deterministic four-by-four matrices

The exact finite domain is all symmetric, zero-diagonal `4 × 4` matrices
whose six unordered edge values lie in `{-1,0,1}`: `3^6 = 729` matrices.
It is not the domain of every real matrix, and rectangular matrices are not
enumerated. The checker exhausts:

| Check | Recorded/replayed count |
|---|---:|
| Matrices | 729 |
| Full bilinear row/column sign pairs | 186624 |
| Without-replacement row-moment checks | 139968 |
| Scalar sign-loss checks | 653184 |
| Skeleton subset/sign assignments | 46656 |
| Adaptive skeleton-family bounds | 2187 |

For each matrix it enumerates all `16` column-sign vectors, all `16` row-sign
vectors, all subsets of sizes `m=1,2,3`, and all signs on each skeleton. Thus
the actual two-sided adaptive optimum, not a prescribed test vector alone, is
checked. Endpoint deletion costs at most `2 m d` in the unnormalized response,
where `d` is the maximum absolute row sum.

For a fixed row let `x_j=A_ij delta_j`, `r=sum_j x_j`, and let `J` be uniformly
chosen among size-`m` subsets. The integer-scaled errors are
`e_J=m r-4 sum_(j in J) x_j`. The code checks

\[
 \mathbb E_J e_J=0,\qquad
 3\mathbb E_J e_J^2=m(4-m)\bigl(4\sum_j x_j^2-r^2\bigr),
\]

as well as the stated variance upper bound. These are exact checks of
without-replacement unbiasedness and variance on this domain, not Monte Carlo.
The low-loss-skeleton existence inequality and its bound for the full adaptive
maximum are also checked for every enumerated matrix. This provides substantial
finite regression evidence, not a universal proof of the variance identity,
concentration, or the surrounding probability theorem. The Lean unit proves
some universal deterministic response inequalities separately.

## 2. Three independent binary-site models and all fixed assignments

Each model has three independent binary variables and zero diagonal. For
`i<k`, a `2 × 2` table specifies `E_ik(u,v)`; reverse edges use its transpose,
and the envelope is `H=|E|`.

- **Signed fair:** all site probabilities are `1/2`; every edge table is
  `((1,1),(1,-1))`.
- **Signed nonidentical:** probabilities are `(1/2,1/3,1/4)`, with tables
  `01: ((1,-1),(1,1))`, `02: ((-1,1),(1,-1))`,
  `12: ((1,1),(-1,1))`. Independence, not identical distribution, is used.
- **Rare positive:** probabilities are all `1/16`; every edge table is
  `((0,0),(0,2))`.

Here `A=(1/3) sum_(i,k)|E_ik|`, and the cut uses the manuscript's `1/3`
normalization, not `1/9`.

| Model | `C0` | integrated `q` | integral `beta` | expected adaptive cut | `E A²` |
|---|---:|---:|---:|---:|---:|
| signed fair | 2 | 2 | 1 | 2 | 4 |
| signed nonidentical | 2 | 2 | 4/3 | 2 | 4 |
| rare positive | 1/4 | 1/32 | 1/64 | 1/64 | 3/128 |

`C0` is the maximum every-type expected absolute row mass; `q` is the maximum
integrated squared row mass. Integral `beta` is computed by exhausting the
single-site sign tests and optimizing the other side by absolute column sums.
For these finite bilinear boxes, extrema occur at sign tests. The signed
examples therefore genuinely exhibit an adaptive gap; the nonnegative rare
example does not.

All eight site configurations and all row/column sign pairs are checked per
model. Every deterministic skeleton of sizes one and two, every sign assignment,
and every frozen skeleton type is examined: **18 assignments and 60 frozen-type
cases per model; 54 assignments and 180 cases in total.** All remaining site
configurations retain their original product probabilities. The checker verifies
the fixed-assignment mean bound `(E Z-beta)_+² <= q`, the induced degree-failure
bound at `d=2 C0+1`, the total-mass second-moment bound, and equality of direct
integration with integration over the frozen types. This does not condition
probability estimates on a randomly selected optimizer.

## 3. What the two shortcut examples actually reject

**Optimizer conditioning.** In the signed-fair model, the recorded selected
optimizing row and column signs are both `(-1,-1,-1)`. The event has probability
`1/2`, and site zero's posterior rare probability is `1/4`, versus prior `1/2`.
The selection is the checker's deterministic first-maximizer tie rule. This is
enough to disprove an argument that conditions on a selected optimizer while
silently retaining the original independent-site laws. It does not say that
every deterministic assignment changes the laws, or that a transfer argument
avoiding this conditioning fails.

**Integrated versus uniform conditional second moments.** In the old triangle
family, `P(U_i=1)=r^-2` and
`H_ik=E_ik=(r/2) U_i U_k` for `i != k`. Direct calculation gives

\[
 C_0=1/r,\qquad q=1/(2r^2),\qquad
 \sum_{k\ne i}\mathbb E[H_{ik}^2\mid U_i=1]=1/2.
\]

The replay explicitly checks `r=2,4,8`, yielding integrated `q` values
`1/8,1/32,1/128` while the conditional value stays `1/2`. The displayed formulas
also explain the old parametric example: the ratio is `r²`, so an integrated
bound cannot simply be substituted as a uniform conditional bound with an
absolute constant. The expected cut equals the integral test value `r^-3`;
this example is not a failure of transfer. Disjoint copies preserve the local
moment distinction, but the finite checks do not themselves establish an
arithmetic/asymptotic specialization.

## 4. Disconnected good-set extension

The separate fair-site triangle uses the table
`((0,2),(2,1/4))`, row signs `1-2 U_i`, degree threshold `d=1/2`,
Lipschitz constant `c=4d/3=2/3`, and cap `L=1/3`.
The good set is exactly `{000,111}`; its endpoints have Hamming distance three
and no one-site path staying in the good set. The capped infimum extension is
zero at `000` and `1/3` at the other seven configurations:

\[
 \mathbb E Z=2,\qquad \mathbb E\widetilde Z=7/24,\qquad
 \mathbb P(G^c)=3/4.
\]

The checker verifies agreement with **capped** response on the good set,
including `Z(111)=1/2 > L`; it does not assert uncapped agreement. It verifies
all-pair Hamming Lipschitz bounds, the mean-shift inequality, threshold agreement
at `1/4<L`, and every binary-prefix Doob conditional range bound. This is a
valid disconnected example, not a proof that adjacency bounds alone suffice
on arbitrary disconnected good sets. Its cap is smaller than `c`, so the
extension's finite Lipschitz test is conservative, not a sharp concentration
test. No universal tail bound is checked here.

## 5. Exact linkage to the lead's Jacobian replay

The lead's `jacobian/{payload,output,status}.json` were read, not modified or
rerun. The operation is
`probability.finite_distribution.raw_moment.compute`, server `0.14.0`,
protocol `2025-11-25`, exit **0**, no timeout or error.

For the rare-positive model put `K=sum_i U_i`, so
`K~Binomial(3,1/16)`. Each active unordered edge contributes twice to the
ordered sum, and hence `A=(4/3) binom(K,2)`. Independently grouping these four
binomial cases gives precisely the submitted atoms:

| `A` | Probability | Contribution to `E A²` |
|---:|---:|---:|
| 0 | 2025/2048 | 0 |
| 4/3 | 45/4096 | 5/256 |
| 4 | 1/4096 | 1/256 |

Thus `E A²=3/128`, the same finite mass moment as the rare-positive checker
model. `jacobian_link.json` checks the current request/payload binding and every
typed contribution. This is duplicate support for one illustrative moment,
not a separate probabilistic theorem, a concentration computation, or evidence
for the entire transfer.

## 6. Rational powers and huge-parameter nonvacuity

The rational exponent arithmetic is reproduced exactly, separately from any
claim that the manuscript kernels satisfy its hypotheses:

| Quantity | Power of `B` |
|---|---:|
| degree failure | -3/100 |
| squared-mass failure | -1/100 |
| threshold skeleton | -1/100 |
| expected skeleton | -3/200 |
| deletion | -11/100 |
| fixed mean | -21/200 |
| entropy | 7/50 |
| concentration scale before logarithms | -1/50 |
| exceptional expectation | -3/200 |

The last comparison `-1/50 < -3/200` records a power margin, not by itself a
full asymptotic proof including logarithms or unspecified arithmetic remainders.

The finite-size example takes `B=2^2000`, `M=2^640`, `m=2^280`, `d=2^140`,
`q=2^-420`, `t=2^-400`, `delta=2^-60`, and illustrative
`C0=C1=K=beta=1`. Exact rational inequalities bound the cap by four and the
**additive** expected sampling error by `10*2^-30`. The entropy estimate uses
an analytic envelope for the binomial count, not enumeration at this enormous
size. This is a nonvacuous parameter illustration, not constants established
for the arithmetic kernels or a test of their gigantic matrix.

Crucially, the old displayed equation (3) multiplies `2md/M` by
`sqrt((C0²+q)(p+delta))`, whereas the ledger and the prose derivation have these
as separate additive terms. The nonvacuity checker itself budgets them
**additively**. Neither its success nor the finite regressions certify the
printed universal inequality. The lead owns the probabilistic reconciliation
and asymptotic specialization; no further error search was undertaken here.

## Remaining boundary

Every requested finite replay succeeded and matched its old finite output.
The unavailable uniform-conditional-moment and optimizer-conditioning
shortcuts have concrete witnesses. Universal probability, independence
arguments, concentration, the arithmetic hypotheses, novelty, and the full
joint Dickman conclusion are not certified by these finite checks. Independent
review and the separate unit assessments remain necessary.
