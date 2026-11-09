# Verification of the probabilistic-comparison tournament

## Result and scope

We verify `lem:amplification` and `prop:tournament` of the staged
`build/sections/03-quantum.tex`. No false assertion in those results was
established. In particular, arbitrary nonwinner probabilities, retained
comparison garbage, adaptive sampler failures, and zero-weight stopping
do not invalidate this proof.

The main independent certification is an all-parameter theorem, formalized
over **arbitrary real** probabilities in Lean 4.31.0:

**Finite-horizon search theorem.** Let `I` be a finite nonempty set of size
`m`, and let `a_ij in [0,1]`, `a_ii=0`, and `a_ij+a_ji=1` for `i != j`.
Suppose `a_*j >= 1-epsilon` for `j != *`, where `epsilon >= 0`.
Start every weight at one. At each positive-weight history, either stop
with conditional probability `q_h`, or sample `p` with conditional law
`w_p/W`, append it, and replace `w_i` by `w_i a_ip`. Zero total weight
is absorbing. The values `q_h in [0,1]` may depend arbitrarily on the
complete history. Assume only `q_h <= eta` at histories without `*`
and with `W >= 1/2`, where `eta >= 0`. For every integer `T >= 0`,

    T epsilon <= 1/2  ==>  Pr[* is missing after at most T stages]
                           <= 2m/2^T + T eta.

This is a theorem about the missing-candidate event of the actual finite
stochastic search, not just its drift. The quantum implementation bridge
below is an ordinary mathematical proof, not a Lean formalization.
Independent Reviewer approval and statement-fidelity review are pending.
This component does not certify the full quartic separation.

Relative to the strongest relevant prior result, namely the staged
proposition, the theorem separates comparison error `epsilon` from sampler
error `eta`, allows every horizon satisfying the displayed condition, and
provides a kernel-checked finite-tree proof. The mechanism and its essential
argument already occur in the manuscript. No independently checked claim of
novelty or publishable significance is made for this component alone.

## Scope and known inputs

The convention in `01-introduction.tex` is **base-two logarithms**. Thus
`T=ceil(log_2(1000m))` gives `2^T >= 1000m`. Changing to a natural logarithm
in this exact parameter expression would not be a faithful reading.

The quantum model allows arbitrary input-independent unitaries between
standard bit-oracle queries. Exact uniform preparation on `[m]` and exact
query-free reflections are permitted; no finite universal gate set or
time/space complexity bound is asserted.

We read the primary amplitude-amplification source, Brassard--Hoyer--Mosca--
Tapp, arXiv:quant-ph/0005055v1, Section 2, equations (1), (5), and (8).
`amplitude_source.txt` identifies the passage and its hypotheses. It concerns
the entire good-subspace projection of a measurement-free unitary, not an
erased-garbage index state, nor a uniform worst-case unknown-success cap.
The rotation is rederived below, so the verification does not need to
assume an external search theorem.

The Forrelation input and universal quartic upper bound are separate cited
assumptions in the campaign ledger. They are not used in this theorem.
Their independent source attribution, the construction, the classical
coupling, and the final separation remain outside this mission.
The inherited Wiki index has no tournament or amplification topic.

Two known failed shortcuts were retired in the ledger. First, without a gap
around `1/2`, one cannot uniformly cheaply orient arbitrary comparison
probabilities into a reliable fixed tournament. Second, the drift identity
alone does not prove a candidate-hit probability or control adaptive
termination. Neither shortcut is an assertion made by the staged manuscript.

## 1. Complementarity, survival, and the ideal process

For `w_i >= 0` and `W=sum_i w_i > 0`, write

    S = sum_{p,i} w_p w_i a_ip.

Swap `i,p`, add the two expressions, remove the diagonal, and use
complementarity off the diagonal:

    2S = sum_{i != p} w_i w_p = W^2 - sum_i w_i^2.
    E[W_new | w] = S/W <= W/2.

The diagonal is zero, not one-half. At `W=0`, every nonnegative weight
is zero and stays zero, so the same contraction inequality applies.
Consequently `E W_T <= m/2^T`.

Along any history of length `t` omitting `*`,

    w_* = product_b a_{*,p_b} >= (1-epsilon)^t >= 1-t epsilon

in the relevant range `epsilon <= 1`. Alternatively the additive bound
follows directly by induction: weights stay in `[0,1]` and
`u a_{*,p} >= u(1-epsilon) >= u-epsilon`.
This latter proof works for every nonnegative `epsilon` and is what Lean
uses. If `T epsilon <= 1/2`, an omitted `*` has final weight at least
`1/2`, and no prehit history can have zero total weight. Thus

    Pr[ideal miss] <= Pr[W_T >= 1/2] <= 2 E W_T <= 2m/2^T.

The boundary `T epsilon=1/2` is allowed. No strict inequality is needed.
For `T=0` the theorem is the valid, possibly vacuous bound `1 <= 2m`.

## 2. Arbitrary adaptive failures: the formally checked argument

For a complete pivot history `h`, let `M(n,h)` be the probability of a
miss after at most `n` more stages. It is zero if `* in h`, one if there
are no stages left and no hit, and one at a zero-weight no-hit history.
Otherwise the exact recursion is

    M(n+1,h) = q_h + (1-q_h) sum_p (w_p/W) M(n,p::h).

This is precisely `miss` in `Main.lean`. Lists store the newest pivot
first; multiplication of scalar weights makes this representation immaterial.
The normalized probabilities and `0 <= M <= 1` are proved separately.

The induction statement is stronger than the root theorem:

    w_*(h) >= 1/2+n epsilon
       ==> M(n,h) <= 2W(h)/2^n + n eta.

At `n=0`, `W>=w_*>=1/2` proves it. At `n+1`, the positive margin
excludes zero total weight. A child selecting `*` has miss probability
zero. Every other child has

    w_*(p::h) >= w_*(h)-epsilon >= 1/2+n epsilon.

Apply the induction hypothesis to each child, sum under `w_p/W`,
and use normalization and the half-drift bound. The resulting child
average is at most `2W/2^(n+1)+n eta` and is nonnegative. Hence
`q_h+(1-q_h) child_average <= eta+child_average`.
The root margin follows from `w_*([])=1` and `T epsilon<=1/2`.
This proves the announced inequality directly for the adaptive process.

For comparison, the manuscript's coupling is also valid. At any agreeing
prehit history sample a stop flag of probability `q_h` and, independently,
an ideal pivot with law `w/W`. The joint law of a successful actual pivot
is exactly `(1-q_h)w_p/W`. There are at most `T` prehit chances to stop,
each bounded by `eta`; union bound gives the additional `T eta`.
No history-independent failure assumption is involved.

If the sampler also has hidden or discarded classical outcomes, average
over them conditional on the pivot history. Because each successful
conditional pivot law is the same `w/W`, the averaged law still has the
displayed factorization. After the first hit, termination cannot remove
the candidate already appended to the list.

## 3. Exact conditional sampling with all garbage retained

Fix a classical pivot history `p_1,...,p_t`. The comparison circuit is
controlled by the index and uses a fresh workspace for every comparison.
For a fixed index `i`, write its complete normalized comparison state
as `phi(i,p_b)`. Compute a success bit equal to the AND of its victory
bits, with a self-comparison always false. Before that flag is computed,
the state is

    (1/sqrt(m)) sum_i |i> tensor_b |phi(i,p_b)>.

For a fixed `i`, projection onto all victories has squared norm
`product_b a_{i,p_b}=w_i`. This is a tensor-product statement about
fresh registers, not an independence assertion about discarded quantum
garbage. Distinct indices are orthogonal. Therefore success has probability
`W/m`, and measuring the index **conditional on success** has exactly
probability `w_i/W`.

The good state is the full normalized projected vector, including index,
result bits, and garbage. It need not factor as an index state tensor a
common garbage state. Attempting to erase the comparison workspace or
amplify a reduced index state would not be this construction.
The retained coherent circuit is a unitary with an inverse; its inverse
reverses each ordinary bit query, since the bit oracle is self-inverse.

## 4. Distribution-preserving bounded amplification

Let `psi=A|0>`, let `Pi` project onto the designated success bit, and
put `p=||Pi psi||^2`. For `0<p<1`, write
`psi=s g+c b`, where `s=sqrt(p)`, `c=sqrt(1-p)`, and `g,b` are the
normalized good and bad projections. They are orthonormal even when they
contain arbitrary garbage.

On their span, the product

    Q = (2|psi><psi|-I)(I-2Pi)

has matrix

    [[1-2s^2,  2sc],
     [ -2sc,  2c^2-1]]
      = [[cos(2theta), sin(2theta)],
         [-sin(2theta), cos(2theta)]],

where `s=sin(theta)`, `c=cos(theta)`. Matrix multiplication and the
angle-addition identities give, by induction,

    Q^ell psi = sin((2ell+1)theta) g + cos((2ell+1)theta) b.

Consequently every nonzero successful projection is a scalar multiple
of the **same full vector g**. The reflection about `psi` is
`A(2|0><0|-I)A^-1`, using one call to each of `A,A^-1`;
the success reflection is query free.

Put `M=ceil(10/sqrt(gamma))`. A trial chooses the direct state (`ell=0`)
with probability one-half, otherwise a uniform `ell in [0,M-1]`.
If `p>=1/2`, the direct part alone succeeds with probability at least
`1/4`. For `gamma<=p<=1/2`,

    sin(2theta)=2sqrt(p(1-p)) >= sqrt(gamma).

The elementary telescoping identity

    2 sin(2theta) cos((4ell+2)theta)
       = sin((4ell+4)theta)-sin(4ell theta)

gives the exact average

    (1/M) sum_{ell=0}^{M-1} sin^2((2ell+1)theta)
       = 1/2 - sin(4Mtheta)/(4M sin(2theta)).

It implies the manuscript's weaker lower bound
`1/2-1/(2M|sin(2theta)|) >= 9/20`.
Thus every trial succeeds with probability at least `9/40` for
`p>=gamma`. Repeat

    R=ceil(log(1/eta)/log(40/31))

fresh trials, stopping on the first success. The all-failure probability
is at most `(31/40)^R<=eta`. Each trial uses `2ell+1<=2M-1` calls to
`A` or its inverse, including the initial preparation. Hence the cap
`R(2M-1)` holds on every branch and for every `p`, even `0<p<gamma`.
For `p=0` there is never a successful projection; for `p=1` every
trial succeeds. Neither endpoint requires dividing by a zero norm.

Randomizing the length and stopping on the first success preserve `g`:
for each classical trial history producing success, the output factors
as a phase times `g`. Tracing out or retaining that classical history
therefore leaves the same pure-state density operator. This establishes
the state/distribution claim of `lem:amplification`, not just its
success-probability claim.

## 5. Recovering the manuscript and every-branch query bound

Choose `gamma=1/(2m)` and let the sampler error be `eta=epsilon`.
On any prehit history with at most `T` pivots, survival gives `W>=1/2`,
so `W/m>=gamma` and the preceding amplification gives `q_h<=eta`.
Conditional success has exactly the required pivot law by Sections 3--4.
At `W=0`, the amplifier always fails, matching absorbing termination;
the algorithm need not calculate or test the weights.

For the manuscript's `T=ceil(log_2(1000m))` and
`epsilon=1/(1000T)`, we have `T epsilon=1/1000<=1/2`. The formal
theorem gives precisely

    Pr[miss] <= 2m/2^T + T epsilon <= 3/1000.

There are at most `T` stages and at most one appended index per stage.
At stage `t`, preparation compares against `t` old pivots and costs
at most `ct` bit queries; its inverse costs the same. Stage zero
costs zero queries. Thus, writing

    M=ceil(10sqrt(2m)), R=ceil(log(1/eta)/log(40/31)),

the explicit branchwise bit-query cap is

    c R (2M-1) sum_{t=0}^{T-1} t
       = c R (2M-1) T(T-1)/2.

If a lower-level implementation charges an additional fixed controlled-query
factor, include it in the premise's cost `c`; it is not an uncounted oracle.
The manuscript explicitly supplies controlled coherent comparisons.
The cap is independent of every weight, success probability, failure
outcome, and the existence of any dominant candidate. Since
`M=O(sqrt(m))`, `R=O(log(1/eta))`, and here
`log(1/eta)=log(1000T)=O(log T)` (`m>=2` implies `T>=11`), this is
`O(c sqrt(m) T^2 log T)`.

## Evidence and replay

`Main.lean` proves the real-probability finite-horizon theorem;
`statement_fidelity.md` specifies exactly its hypotheses and formal boundary.
The official `lean_check.json`, `compile.log`, and archived certificate
are generated by `lean_evidence verify --claim C284_FINITE_SEARCH`;
the archived certificate is referenced by the campaign claim ledger.
No mathematical status is inferred from a failed compiler attempt.
The recorded official run returned **exit code 0, `proof_holes=[]`,
and axiom-audit exit code 0**, using Lean 4.31.0 and the prebuilt Mathlib
workspace. The ledger derives `closed_kernel` for `C284_FINITE_SEARCH`;
it does not assert that a person has checked statement fidelity.

Run the standalone exact arithmetic replay with:

    python3 research/tournament/verify.py

It independently recomputes rational branching laws, exact drift identities,
zero-weight and no-winner cases, history-sensitive failures, retained-good-state
rotation regressions, and exact integer/rational parameter and query caps,
then compares them with `exact_certificate.json`. It also checks that the
recorded genuine compiler result binds the current source and fidelity text,
has exit code zero and no proof holes, and is the mechanical certificate
actually cited by the claim. These finite regressions are not the proof of
the all-real theorem.
The saved-certificate replay returned exit code zero: 40 rational matrices,
199 dominant-candidate/horizon cases, 597 adaptive branching laws,
1,160 exact drift checks, and 4,676 survival checks. It also reproduces
the 21 exact retained-good-state rotations and six parameter/cap cases,
including the exact `T epsilon=1/2` boundary in the finite tests.

For a fresh kernel replay, from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/tournament/Main.lean --statement-fidelity research/tournament/statement_fidelity.md --claim C284_FINITE_SEARCH --project-root . --timeout 110

Jacobian 0.14.0, MCP protocol 2025-11-25, was queried for applicable bounded
operations before bespoke certificate code was written. We inspected
`probability.finite_distribution.condition.compute` and ran it on the
exact payload in `jacobian_payload.json`. Its typed response, server
metadata, exact request, and result are in `jacobian_output.json`;
the adapter returned exit code zero with no error or timeout.
It confirms the event mass `3/5` and conditional masses `1/3,2/3` for
that example only. Its rational finite-distribution contract does not
state a theorem about arbitrary real probabilities, coherent garbage,
or adaptive tournament histories, and is not substituted for one.

The main dependency graph and campaign ledger retain the separate
unresolved construction, classical lower-bound, literature-attribution,
and main-theorem obligations. No `F_<LABEL>` refutation is filed because
no false manuscript assertion was confirmed in this component.
The citation queue still names `BS21_LOWER` on `C284_FORRELATION` and
`ABKRT_QUARTIC` on `C284_UNIVERSAL` as unchecked. These are not dependencies
of `C284_FINITE_SEARCH` or `C284_TOURNAMENT`; they remain genuine open
obligations for the broader campaign, not defects hidden by this handoff.
