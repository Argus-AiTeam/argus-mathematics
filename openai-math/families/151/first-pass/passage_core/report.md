# A fully quantified nonlinear passage theorem

## Result

For every complete passage of the staged simultaneous recurrence, with
finite main coordinate and **arbitrary finite duration**, clock predictions
agree with the actual clock at all possible readouts. Each channel is read
at most once; its register stays in the identity disk until its own
readout without any phase assumption. All additions then align with the
current main square, and escape past radius one is compulsory.

More precisely, translate the clock so its initial reading is in `[0,1)`,
write `N` for the first index with reading at least `100`, and set

    W = sum_(i=8)^11 alpha(s_i) chi(z_i).

The exact update for every `8<=n<N` is

    |z_(n+1)| = |z_n|^2 + 2 W sum_l beta_l(s_n)^2,
    phase(z_(n+1)) = phase(z_n)^2.

Every `z_n`, `8<=n<=N`, is nonzero, and some `8<=n<N` has `|z_n|>1`.
The squared readout coefficient, physical-time compensation `L^(1-m)`,
and exponent `2^(m+1)` are retained, not replaced by a comparator.

`Main.lean`, declaration `PassageCore.Orbit.complete_passage`, is the
formal theorem. Its `Data` and `Orbit` inputs contain only the raw update,
support, cutoff, reset, gain, and completion conditions.
`statement_fidelity.md` gives the full source-application argument.
`verify.py` is the rerunnable certification entry point; it runs the real
Lean checker, records the mechanical evidence against `C_PASSAGE_CORE`,
checks both campaign-local ledgers, and writes `exact_certificate.json`
only after these succeed.

This is an exact verification/structural generalization theorem, not a
counterexample to the manuscript, a finite experiment, a proof of the
entire entropy counterexample, or an independently accepted publication.
Independent source-fidelity and significance review remain required.

## Proof

**Early indices and reset.** Clock increments lie in `[0,1]`.
Since the passage spans a full period, `N>=100`. Before time `48` the
clock reads `s_0+n`. Thus preparation is confined to the four indices
`8,9,10,11`, time `9` has `alpha=1`, and the update at time `2`
erases every register. Inputs vanish until preparation, so all registers
at time `8` are zero. This improves the source's harmless bound of five
preparation indices.

**The barrier, including its endpoint.** If `i<12` and `|z_i|<=1/2`,
the clock is below `50`. There is no readout, the main coordinate squares,
`e=0`, and `s+b(s)<=50`. Induction preserves both `s<=50` and
`|z|<=1/2` until time `N`, contradicting `s_N>=100`. Hence every
preparation radius is strictly greater than `1/2`; equality is excluded.

**Arbitrary-delay prediction.** Let `r` and `R` be the first actual
crossings of `70` and `82`. They exist by completeness, irrespective of
how long the orbit waits near `50`. Before `r` there are no readouts,
so both coordinates agree exactly with iterates of `G`. From `r` through
`R` the clock increment is one, even when actual and predicted main
coordinates differ after an addition. Clock agreement therefore
continues. Beyond `R` the predicted clock is nondecreasing and already
at least `82`, so it cannot return to a support in `(74,80)`.

At any positive value of one `beta_l`, the next clock reading is larger
by exactly one. Two such readings cannot lie in the same interval of
length less than one. Each channel consequently has at most one actual
or predicted hit. Different channels may overlap without restriction.

**Linear registers without aligned phases.** Fix a channel read at time
`j`. For `i` in `{8,9,10,11}`, let

    c_i = beta_l(s_j) alpha(s_i) chi(z_i)
          phase(z_i)^(2^(j-i+1)) / 10.

Prediction shows its input at `i` is exactly `L^(1+i-j)c_i`; the infinite
sum has only its single possible nonzero term. At every `8<=u<=j` form

    w_u = L^(u-j) sum_(i<u) c_i.

Each `|c_i|<=1/10`, and there are at most four signals, so
`|w_u|<=2/5<=1/2`. The old-state input enters at `i+1` and receives exactly
`j-i-1` intervening gains. At every such intervening update the clock
lies in `[7,90]`, so `a=L`. The candidate satisfies the true register
recurrence because `S(w_u)=w_u`; induction from the reset gives
`v_(u,l)=w_u`. In particular `v_(j,l)=sum_i c_i`.
There is no premise about phases or the actual register norm.
An earlier-read register may subsequently behave nonlinearly: its
coefficient is zero thereafter, and it cannot influence other registers.

**Alignment from the actual recurrence.** Put `theta=phase(z_8)`.
All preparation precedes every readout, hence
`phase(z_i)=theta^(2^(i-8))`. At time `j` each signal's phase is

    (theta^(2^(i-8)))^(2^(j-i+1)) = theta^(2^(j-8+1)).

It is the same for every contributing preparation index and channel.
The readout supplies another factor `beta_l(s_j)`, in addition to the
one in the input. Thus its contribution is
`2 beta_l(s_j)^2 W` in the direction of the main square. Induction
through **every actual update**, not only the first readout, proves the
displayed exact radial equality, phase doubling, and nonvanishing.
This also proves the square lower bound.

**Escape and cutoffs.** If `|z_9|>1`, escape has already occurred.
Otherwise the barrier gives `1/2<|z_9|<=1`, including the endpoint one,
so `chi(z_9)=1` and `alpha(s_9)=1`. All other weights are nonnegative,
so `W>=1`. The first crossing of `76` lies in `[76,77)`, where some
`beta_l=1`. At that readout `sum_l beta_l^2>=1`, so the next radius is
at least `|z_j|^2+2>2`. Its clock is below `78`, hence this update is
strictly before the end of the passage. No upper bound on `j` in terms
of a prescribed delay was used.

The source phrases its conclusion from `min I` rather than time `8`.
The latter is an earlier index. If an escape before `min I` were used,
the square lower bound propagates radius greater than one to `min I`.
Thus the formal statement implies the exact source passage-escape lemma.

## Exact algebra and adversarial scope

Before writing the custom checker, the installed Jacobian catalog was
queried and its typed recurrence and ideal-normal-form contracts inspected.
The bounded linear-recurrence operation is unsuitable for nonlinear
passages or arbitrary delays. The matching elementary algebra operation
is `polynomial.ideal.normal_form.compute`.

Its preserved request and result are `jacobian_payload.json` and
`jacobian_result.json`, with server `0.14.0`, protocol `2025-11-25`,
and adapter exit code zero. It returned `COMPUTED`, `in_ideal=true`,
and the zero remainder for

    P = z^2 + 20 b v - (r^2 + 2 b^2 c) w
      = (z^2-r^2 w) + 2 b (10 v-b c w).

`verify.py` independently checks this exact rational polynomial
decomposition. The Jacobian calculation certifies only this coefficient
identity; the nonlinear theorem is certified by Lean, not by treating
this calculation or a finite orbit sample as a proof.

The formalization deliberately permits overlapping channel supports,
arbitrary nonlinear saturation outside the unit disk, arbitrary
nonnegative cutoff shapes satisfying the displayed plateaus, zero clock
increments, and arbitrary physical waiting times. Closed-disk endpoint
conditions and the readout support endpoints are respected.
No false manuscript assertion was found in this bounded analysis;
therefore no invented `F_` refutation claim is registered.

## Prior result and remaining obligations

The initial campaign ledger contained no certified passage result.
No relevant theorem was found in the inherited project Wiki.
The primary public comparator
`https://github.com/openai/math/blob/main/lean/ComparatorChallenges/C1EntropyCounterexample.lean`
was read on November 5, 2026: it declares
`exists_C1_entropy_counterexample` and ends its proof with `sorry`.
The associated `lean/docs/151.md` describes the intended scope, not a
checked passage proof. This is not a refutation of the mathematical paper.

The improvement here is a real kernel-checked derivation of the central
nonlinear mechanism, whereas that comparator supplies only its desired
global conclusion. The theorem also weakens the source's regularity and
saturation hypotheses for this discrete mechanism: no smoothness,
global bound on `S`, or radial monotonicity of `S` is used.
Publication-level novelty is a Reviewer question, not inferred from
compilation or from absence of a local prior result.

The route of finite delay truncation or assumed aligned/linear
comparators was recorded as noncertifying and retired in the claim ledger.
The full input is essential when the actual waiting time is unbounded.

Global `C^1` regularity, bounded-clock attraction, persistence across later
passages, entropy localization and register entropy, and the homological
eigenvalue remain open nodes of `research/PROOF_GRAPH.json`. The present
certificate does not close the entire entropy-conjecture audit.
The Host must invoke an independent Reviewer for statement fidelity,
source application, theorem significance, and acceptance.
