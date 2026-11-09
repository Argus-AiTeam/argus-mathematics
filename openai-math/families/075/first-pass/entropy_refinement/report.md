# Adaptive entropy-refinement search

## Exact question and scope

The target is Proposition `entropy-refinement:search` in the staged manuscript,
Section 04. Its conclusion is the existence of a finite context refinement
`W` and an index `j` for which

    G_1(empty) - G_1(W) <= C D_*^2 / (E h^2),
    K_{m_{j,1}}(W; r_j) <= K_{m_{j,0}}(W; r_j) + E.

The constant must be numerical and uniform in the finite set of letters.
Neither a finite unsuccessful search nor an arbitrary monotone-array
countermodel refutes this statement.

The following scope facts come directly from the definitions, rather than
from an assertion of the Fourier-convergence theorem.

* Section 03, `entropy-foundations:G-definition`: the copies used in `G_s`
  are independent copies of the *current pair* `(X,W)`.
* Section 03, `entropy-foundations:I-definition` and
  `entropy-foundations:K-definition`: rows in the optimization can be
  arbitrarily coupled, but each row has its prescribed pair marginal.
* Section 03, `entropy-foundations:context-bounds`: the monotonicity and
  uniform bounds on `G_s` and `I_r` are inputs to the finite search, not
  consequences of the search theorem.
* Section 04, `entropy-refinement:gluing`: a Bernoulli partial observation
  gives an *at least* prescribed decrease of `I_r`; equality is not asserted.
* Although each endpoint of an interval decreases under refinement, its
  width need not decrease. Any argument using decreasing widths would need
  a separate hypothesis that the manuscript does not supply.

The campaign ledger initially contained only the overall audit objective,
with no supporting mathematical evidence. The report will separate the
finite combinatorial theorem from its entropy-theoretic inputs and from the
still unverified analytic chain to Fourier convergence. Independent review
is pending.

The official OpenAI scope page `lean/docs/075.md` was obtained from its
primary repository. It names `lean/ComparatorChallenges/FourierLLogL.lean`
as the comparator. A scope-page description is not a compiler certificate;
the actual comparator was inspected at revision
`301488868beec11bfd897168433b0a64f5258559`. Its `paperMain` proof consists
of `sorry`. It is therefore a statement of the target theorem, not a
proof that this audit may use. The primary-source links are:

* <https://github.com/openai/math/blob/301488868beec11bfd897168433b0a64f5258559/lean/ComparatorChallenges/FourierLLogL.lean>
* <https://github.com/openai/math/blob/301488868beec11bfd897168433b0a64f5258559/lean/docs/075.md>

The new formalization below concerns the nonroutine finite-search core,
not the comparator's Fourier theorem. No novelty or publishability verdict
is inferred from the existence of a compiling file.

Jacobian discovery found no matching operation for adaptive refinement
search. Its exact multivariate factorization operation does match the
algebraic substep

    a^2 d + a c + 2 a d x + 2 c x = (a + 2x)(c + a d).

This is the shifted multiplicative recurrence behind the index-cost
estimate, not a verification of the search theorem. The discovery,
inspected typed contract, and exact payload are preserved as JSON beside
this report. The bounded operation returned `FACTORIZED` with `EXACT`
reconstruction, server version `0.14.0`, protocol `2025-11-25`, and no
adapter error. It establishes only the displayed identity.

## Verification theorem

The deliverable is an exact verification theorem for the finite search,
including an explicit-parameter specialization, not a counterexample and
not a proof of Fourier convergence. Independent review is pending.

Here is the abstract theorem proved by `EntropyRefinement.finite_search`.
A state space has a preorder `s <= v` representing further refinement, an
accumulated cost `c(s)` nondecreasing along that preorder, and coordinates
`a_j(s), H_j(s), L_j(s)` with the following properties:

1. `0 <= a_j <= 1`, `a_j` increases with `j`, and it decreases under
   refinement.
2. `0 <= L_j <= H_j <= 1`; both endpoints decrease under refinement; and
   `H_k(s) <= L_j(s)` whenever `j < k`.
3. There is a fixed `eta > 0`. If `good(s,j)` fails, then, for every
   `0 < x <= eta`, a further state `v` is available with

       a_j(s) - a_j(v) >= x,
       c(v) - c(s) <= 2 (H_j(s) - L_j(s)) x.

The predicate `good` need not be monotone. No hypothesis says that interval
widths decrease, or that target decreases are attained exactly.

Let `0 < alpha_0 < alpha_1`, `u > 0`, `delta_0,delta_1 >= 0`, and
`0 <= epsilon <= 1`. Let `n,q,N` be natural numbers satisfying

    n delta_0 >= 1,     N delta_1 >= 1,     q u > 1,
    delta_0 exp(2u/alpha_0) <= epsilon,
    (delta_1 + epsilon) (R^q - 1) <= 1,
    R = alpha_1 / (alpha_1 - alpha_0).

Then from every state `s` there are a further state `v` and a zero-based
index `j < N q n` such that

    good(v,j),
    c(v) - c(s) <= 2 alpha_1 + 2 alpha_0 <= 4 alpha_1.

All three levels of this conclusion are proved in Lean: finite index
termination with overshoots, the reverse-order subblock argument, and the
outer ordered sweep. The state updates can be chosen adversarially within
the offer contract.

### Proof

**One index.** Fix its entry state `s` and current state `v`. Put
`p = H_j(s)-L_j(v)` and `c_0=c(v)-c(s)`. Stop working at the index when
`p > c_0/alpha_0 + delta_0`; otherwise the current width is at most that
threshold. Stop successfully if `good` holds or the actual decrease of
`a_j` since entry is at least `u`. For another update choose

    x = min(eta, u - (a_j(s)-a_j(v))).

This is a permissible smaller partial offer than the manuscript's
`min(d_m, remaining target)`. It proves the same existential proposition;
it does not assert that every observation decreases `a_j` by exactly `x`.

If `b` is the sum of targets used, then `b` never exceeds the actual
decrease, and it never exceeds `u`. The offer and failed skip test give

    c_0,new + alpha_0 delta_0
      <= (c_0,old + alpha_0 delta_0) (1 + 2x/alpha_0).

Induction using `1+y <= exp(y)` yields

    c_0 + alpha_0 delta_0
      <= alpha_0 delta_0 exp(2b/alpha_0).

Thus every index attempt costs at most `alpha_0 epsilon`. Termination is
proved by induction on a natural-number bound for the remaining target
divided by `eta`: an unclipped update reduces that bound, and a clipped
update finishes the target even if the actual decrease overshoots.

**An increasing sweep.** For skipped indices in increasing order, let
`U_i` be the upper endpoint on entry and `V_i` the lower endpoint on exit.
Endpoint ordering and intervening refinement give `U_{i+1} <= V_i`.
Consequently their entry/exit losses telescope, with no assumption about
the behavior of instantaneous widths. A skip costs at most
`alpha_0 (U_i-V_i)` and has `U_i-V_i > delta_0`. Their total span is at
most one, so `n delta_0 >= 1` forbids skipping all `n` indices.
Adding the one terminal or active attempt gives the subblock estimate

    subblock cost <= alpha_0 (P + epsilon),

where `P` can be the enclosing macroblock's upper endpoint at entry minus
its lower endpoint at the present state. `ordered_sweep` proves the
entry/exit telescope by induction, including arbitrary intervening
decreases.

**A reverse macroblock.** Set `A_k(v)=a_{b+kn}(v)` at subblock boundaries.
A completed target in the subblock `[b+kn,b+(k+1)n)` implies

    A_{k+1}(entry) - A_k(exit) >= u.

Processing `k` in descending order telescopes these actual decreases.
Completing all `q` subblocks would give `q u <= 1`, a contradiction.
At each boundary, skip the macroblock if
`P > c_1/alpha_1 + delta_1`. For a completed subblock after which that
test fails, its cost bound gives

    c_1,new <= c_1,old
      + alpha_0 (c_1,new/alpha_1 + delta_1 + epsilon).

Writing `D=alpha_1(delta_1+epsilon)` gives
`c_1,new+D <= R(c_1,old+D)`. After any prefix of at most `q` continuing
subblocks, the scalar geometric hypothesis bounds `c_1 <= alpha_1`.
One final partial or discovering subblock costs at most `2 alpha_0`.
This deliberately uses `q`, rather than the manuscript's sharper `1/u`,
in the scalar recurrence; the explicit parameters below satisfy this
slightly stronger sufficient condition.

**The outer increasing sweep.** Apply the same ordered-sweep lemma to
whole macroblock intervals. Skipped macroblocks have telescoping total
span at most one, cost at most `alpha_1` in total, and individual span
greater than `delta_1`. Since `N delta_1 >= 1`, they cannot all be
skipped. A discovering macroblock costs at most
`alpha_1+2 alpha_0`, proving the stated total bound.

## Exact manuscript parameters

`EntropyRefinement.manuscript_search` also proves the nonroutine scalar
specialization. Write `t=log N`, `ell=log n`. Its explicit hypotheses are

    t >= 1,   exp(t) >= 4,   ell >= 5t,
    N = exp(t),   n = exp(ell),
    2t^2 <= q <= 2t^2 + 1.

These are identities or inequalities between the natural counts and real
parameters, not asymptotic substitutes. It uses precisely

    u = 1/t^2,
    alpha_0 = 100/(t^2 ell),
    alpha_1 = 100000/(ell t),
    delta_0 = exp(-ell/2),
    delta_1 = exp(-t/2),
    epsilon = exp(-2ell/5).

They are the manuscript's parameters, with the auxiliary
`epsilon=n^(-2/5)` from its subblock estimate. In particular:

* `delta_0 exp(2u/alpha_0) = exp(-12ell/25) <= epsilon`.
* `beta=alpha_0/alpha_1=1/(1000t) <= 1/2`.
  Hence `R <= 1+2beta <= exp(2beta)`, and
  `R^q <= exp(3t/500)`.
* Multiplying the last bound by `delta_1+epsilon` gives at most
  `exp(-247t/500)+exp(-997t/500)`. This is at most
  `exp(-t/4)+exp(-t) <= 3/4+1/4 = 1`:
  `exp(t)>=4` gives `exp(-t)<=1/4`, and
  `exp(-t/4)^4=exp(-t)`, whereas `(3/4)^4>1/4`.

Thus even the stronger `q`-step geometric hypothesis holds. These
inequalities are kernel-proved for all the displayed parameters, not
inferred from the finite numerical examples in `verify.py`.

For the manuscript's counts, `n=floor(sqrt M)` and `N=floor(M^(1/10))`
give `n >= N^5`: the integer `N^5` is at most `sqrt M`, hence at most
its floor. Therefore `ell>=5t`. The condition `N>=4` gives `t>1`.
Finally `q=q_*=ceil(2/u)=ceil(2t^2)` has the displayed bracket.

## Transfer to the contextual costs

Use zero-based index `j` for the manuscript's `j+1`. The model coordinates
are

    a_j(W) = I_{r_{j+1}}(W)/D_*,
    H_j(W) = G_{m_{j+1,1}}(W)/D_*,
    L_j(W) = G_{m_{j+1,0}}(W)/D_*,
    c(W) = (E/D_*) (G_1(empty)-G_1(W))/D_*,
    good(W,j) = [K_{m_{j+1,1}}(W;r_{j+1})
                 <= K_{m_{j+1,0}}(W;r_{j+1}) + E].

The refinement preorder is **finite further context refinement**, so
finitely many oracle calls really produce a finite-valued context.
To give the formal model coordinates at all natural indices, extend
`a_j=1`, `H_j=L_j=0`, and `good=true` after the manuscript's last
index. This preserves every required ordering. The conclusion lies in
the first `Nq_*n<=M` indices and therefore never uses this extension.

The recorded contextual-bound input supplies all model monotonicities
and bounds. Disjoint descending ranges supply endpoint separation, and
increasing row counts supply the ordering of `a_j`.

For completeness, the reduction from the block-observation lemma to the
formal offer contract is as follows. At a failed index, telescope the
full observations *separately from the same current context*. Their
decreases `d_m` and costs `c_m` satisfy

    sum d_m > tau,     sum c_m = tau p_j,     tau=E/D_*.

If `p_j>0`, the offers with `c_m>2 p_j d_m` account for less than
`tau/2` of the total decrease. At most `m_*` offers remain, so one has
`d_m>=eta=tau/(2m_*)` and `c_m<=2 p_j d_m`. If `p_j=0`, all costs
vanish and the same selection follows from `sum d_m>tau`.
For every `0<x<=eta`, mark that observation independently with
probability `x/d_m`. The entropy loss is exactly scaled by that
probability, while the actual `a_j` decrease is **at least** `x`.
This supplies precisely the formal offer, including all adaptive effects
on the other coordinates. No equality for the optimized refined cost
is used.

The finite theorem consequently yields the desired noisy-cost inequality
and entropy loss at most `4 alpha_1 D_*^2/E`, **conditional on the
recorded contextual-bound and block-gluing inputs**.

The remaining conversion to the proposition's notation is elementary and
uniform. Since
`M=floor(w^2/6-w/3)+1`, for `w>=12` one has
`w^2/12<=M<=w^2` and `log M>=log w`. For sufficiently large `M`,

    log n >= (log M)/4,     log N >= (log M)/20.

These follow from `floor x>=x/2` for `x>=2`; for example
`log M>=20 log 2` suffices for both displayed logarithmic bounds.
As `h=4 log w`,

    4 alpha_1 = 400000/(log n log N)
      <= 512000000/h^2.

The numerical constant is intentionally loose. The partition fits
because
`Nq_*n <= M^(3/5)(1+(log M)^2/50) <= M` eventually.
The manuscript's range construction gives the required endpoint and
row-count domains for sufficiently large `d`. Neither threshold depends
on the finite letter set.

Here are the rounding details of that last assertion. The highest
unrounded lower endpoint is at most `exp(w^3/2)`, whereas
`T_0` has order `d/h^5`; thus `T_0/(2m_{j,0})` tends to infinity
uniformly. The floor defining `r_j` is consequently between
`T_0/(4m_{j,0})` and `T_0/(2m_{j,0})`. Hence

    m_{j,1}/m_{j,0} <= 4L/T_0 + 1/m_{j,0} <= exp(2w)

eventually. Adjacent lower endpoints have ratio at least
`exp(3w)/(1+exp(-w^2))>exp(2w)`. This proves disjointness and descending
order of the complete integer ranges, not just of their lower endpoints.
The floor row counts increase strictly, because their unrounded ratio
is bounded below by the same divergent lower-endpoint ratio and the
smaller unrounded count tends to infinity. Also

    r_j <= T/(8m_{j,0}) <= T exp(-w^2)/8,
    2r_j m_{j,0} <= T_0,
    L <= r_j m_{j,1} < L+r_j < 2L < d^2.

The high endpoints are at most
`2 exp(w^3/2+2w) <= floor(exp(w^3))=m_*` eventually, and the low
endpoints are at least `exp(w^2)`. Finally `m_{j,1}>m_{j,0}` because
`L/r_j >= 2L m_{j,0}/T_0` and `2L/T_0` diverges. All estimates are
uniform in the indices and in the finite set of letters.

## What is and is not certified

The Lean source proves the universal finite search and the displayed
scalar specialization with only the standard axioms `propext`,
`Classical.choice`, and `Quot.sound`. It assumes neither the desired
search conclusion nor an entropy realization of an arbitrary array.
`statement_fidelity.md` identifies the exact declarations and limits of
this reading.

The Section 03 contextual entropy bounds and the Section 04 gluing lemma
remain explicit, locally cited inputs in `MATH_STATE.json`; they are not
silently promoted to Lean-verified assertions. The range/asymptotic
translation is proved above in prose and awaits independent reading.
The low-end noisy bound, common-phase extraction, thermal/spectral
updates, capture, delayed-path estimates, kernel transfer, and endpoint
summation remain open in the proof graph. In particular, the full
`L log L` Fourier-convergence theorem is **not** certified by this work.

No false literal manuscript assertion has been established here, so no
`F_<LABEL>` refutation is manufactured. The retired decreasing-width
route is a rejected audit shortcut, not an error attributed to the
manuscript. The improvement over the prior comparator is an actual
machine-checked proof of a load-bearing, adaptively quantified core,
instead of a theorem statement ending in `sorry`. Whether this
independent formal verification is publishable or new in the literature
is reserved for independent review.

## Reproduction

The official Lean 4.31.0 compiler and its axiom audit returned
`exit_code=0` and `proof_holes=[]` for both named declarations. The
current claim-bound certificate is
`certificates/C_ER_FINITE-fe02f05b69bc51fe.json`; its source and fidelity
document are the working `Main.lean` and `statement_fidelity.md` in this
directory. A first verifier invocation put the result on a copied source
in `lean_certificates/`; the campaign checker correctly refused to count
that as a record for the working source. A second invocation corrected
the artifact placement. The old native archive is retained as a
superseded compiler record, not as the claim's current certificate.

From the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/entropy_refinement/verify.py
```

The script checks exact rational factor reconstruction, interval-certified
logarithmic parameter samples, adaptive rational traces, and native
compiler-record freshness. Its traces deliberately include increasing
widths, actual-decrease overshoots, clipped last targets, both skip rules,
and equality at the strict skip thresholds. They are diagnostics of the
abstract model, **not entropy-realized counterexamples**.

For an independent real compiler and axiom-audit replay, add `--compile`.
That option uses the prescribed Argus verifier with
`--artifact-dir research/entropy_refinement`, then runs both official
campaign-local structural checks. It does not substitute arithmetic
examples or a saved success flag for a compiler run.
