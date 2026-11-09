# Universal verification of the finite-law pair bound

## Result and scope

For every finitely supported real probability law `nu`, every integer `k >= 1`,
and every real `rho > 0`, the following bound holds, with entropies in bits:

\[
 k(H(\nu)-H^0_\rho(\nu))
 \leq \log_2|k\,\operatorname{supp}\nu|
   +1000k^4\sum_{\ell:\,2^{-\ell}\leq2\rho}c_\ell(\nu).
\]

In particular, this verifies the manuscript's constant `60000*k^4`.
The capacities are the manuscript's fractional unordered-pair capacities,
with inclusive lower and exclusive upper distance endpoints. There is no
minimum-separation hypothesis. The proof below also explains why the number
of separating refinement levels does not enter the constant.

`Main.lean` contains the complete refinement-to-capacity argument and both
final statements, `PairBoundCertificate.pair_bound_1000` and
`PairBoundCertificate.pair_bound_60000`. The official Lean 4.31.0 run returned
`exit_code=0`, `proof_holes=[]`, and a successful axiom audit. Both final
declarations use only `propext`, `Classical.choice`, and `Quot.sound`.
The source-and-statement-fidelity-bound compiler certificate is
`certificates/C_PAIR_BOUND-6724e437dd6bbb81.json`.

The adapted source and elementary upstream support carry the upstream
Apache-2.0 license in `LICENSE`; modified files identify the adaptation.

This is a **universal machine-checked verification**, not a counterexample,
not a conclusion from a finite search, and not a novelty claim.
Independent Reviewer approval remains outstanding. The full self-similar
dimension formula is not certified here.

## Complete proof

It is convenient to use natural-logarithm entropies until the last step.
Write `H_n` for such entropy, so `H_n = ln(2) H`.
Put

\[
 s_\ell=2^{-\ell},\qquad
 D_\nu(R)=\sum_{\ell:s_\ell\leq R}2s_\ell c_\ell(\nu).
\]

Only finitely many capacities are nonzero: a nonzero capacity requires an
actual support pair, and every positive pair distance belongs to exactly one
half-open dyadic band. The Lean declaration
`capacity_zero_outside_bands` proves the omission of all other indices is
legitimate.

### A fine grid after observing the sum

First fix any current partition whose cells have diameter at most `R`.
Condition on a positive-probability tuple of current cells for independent
samples `X_1,...,X_k`. The resulting coordinate laws remain independent.
Let `m_i` be their respective means, and put `delta = R/4`.
Each conditional support lies within distance `4 delta` of its mean.

For a translation parameter `u` on the real circle of length one, use the
fine-grid label

\[
 C_i=\lfloor X_i/\delta+u\rfloor.
\]

Let `a` be the minimum, over the coordinates, of the distance from the mean
to a fine-grid boundary. Define the exceptional events and their probabilities
by

\[
 \mathcal A_i=\{|X_i-m_i|\geq a/(4k)\},\qquad
 p_i=\mathbb P(\mathcal A_i),\qquad t=\sum_i p_i.
\]

Let `E` mean that at least two coordinates are exceptional, write `q=P(E)`,
and put

\[
 Y=\sum_iX_i,\quad
 B=\{|Y-\sum_i m_i|\geq a/2\},\quad b=\mathbb P(B).
\]

Independence is used under the current-cell conditional law, **before
conditioning on `Y`**, to give

\[
 q\leq t^2,\qquad q\leq t.
\]

Also `b <= t`: if every coordinate is nonexceptional, the sum deviation is
less than `a/4`. On `E^c` and `B^c`, every fine label is the mean's label.
Indeed, a changed label forces a displacement of at least `a`, whereas the
other coordinates, of which at most one could be exceptional in total,
cannot cancel enough displacement to keep the sum within `a/2`.
This is the deterministic assertion formalized using `no_large_coordinate`.
The argument remains valid when `a=0`: then `B^c` is empty. No removal of
boundary parameters is required.

Each label lies between its mean's label minus five and that label plus five.
There are at most `11^k <= 16^k` joint labels, so their log-cardinality is at
most `4k ln(2)`. Reveal the flag of `E` in addition to the already observed
sum. The event `B` is determined by that sum and costs no additional flag.
The rare-flag entropy estimate gives

\[
 H_n(\mathbf C\mid Y,\text{current cells})
 \leq h_n(q)+4k\ln(2)(q+b)
 \leq 11k\,t\,\ln(2).
\]

For the second inequality use `h_n(q)/ln(2) <= 3 sqrt(q)`, `sqrt(q) <= t`,
`q+b <= 2t`, and `k>=1`. This is `flag_bound`.

For fixed sample values, the event `a <= 4k |X_i-m_i|` requires a grid boundary
to be within that distance of at least one of the `k` means. In normalized
circle coordinates, it is covered by `k` closed balls of radius
`4k |X_i-m_i|/delta`. A closed ball of radius `r` has normalized measure
`min(1,2r) <= 2r`. Therefore averaging the preceding entropy bound over a
uniform translation gives a cost at most

\[
 \frac{88k^3}{\delta}\sum_i\mathbb E|X_i-m_i|\,\ln(2).
\]

The code selects one translation using the integral of a finite sum of
explicit ball indicators. It does not assume measurability of an
unconstructed entropy process. Crucially, the translation is selected
**after averaging over all current-cell tuples**. It is one global
translation, so it defines a genuine partition of the line, not different
incompatible cuts chosen for different sample tuples.

When the original coordinates are identically distributed, averaging out
their current cells makes all `k` deviation contributions equal. If `g`
denotes the current label map and `m_g(x)` the mean in the cell of `x`, the
increment in entropy is consequently at most

\[
 \frac{88k^4}{\delta}
       \sum_x\nu(x)|x-m_g(x)|\,\ln(2).
 \tag{1}
\]

The declarations `cellwise_refinement`, `disintegrated_refinement`, and
`choose_refinement` prove these statements from the actual finite product
law. Appending the new grid label to the old label makes the partitions
nested, as proved by `append_refinement`.

### Converting deviation into fractional capacity

For the fixed current partition, define the same-cell coupling

\[
 \pi(x,y)=
 \begin{cases}
 \nu(x)\nu(y)/\nu(A),&x,y\in A,\\
 0,&\text{otherwise}.
 \end{cases}
\]

It is nonnegative, symmetric, and its row sums are exactly `nu(x)`.
Its nonzero pairs have distance at most `R`. The finite conditional Jensen
estimate, proved in `center_jensen`, gives

\[
 \sum_x\nu(x)|x-m_g(x)|
 \leq\sum_{x,y}\pi(x,y)|x-y|.
 \tag{2}
\]

For a particular dyadic band, assign weight `w_{x,y}=2 pi(x,y)` to its
unordered pair represented by `x<y`. Half the incident weight at `x` is
precisely its row mass from that band, and hence is at most `nu(x)`.
The total pair weight is the full ordered coupling mass in the band.
It follows that

\[
 \sum_{x,y:\,s_\ell\leq|x-y|<2s_\ell}\pi(x,y)
 \leq c_\ell(\nu).
 \tag{3}
\]

This is an actual feasible **fractional** witness, not a matching of disjoint
edges; `fractional_band_witness` constructs it and proves all constraints.
Equations (2) and (3), together with the band's upper distance bound, imply

\[
 \sum_x\nu(x)|x-m_g(x)|\leq D_\nu(R).
\]

Combining this with (1) and `delta=R/4` proves a single refinement of diameter
at most `R/4` whose entropy increment after observing the sum is at most

\[
 \frac{352k^4}{R}D_\nu(R)\ln(2).
 \tag{4}
\]

This is the complete one-step statement `capacity_refinement`.

### Eliminating the terminal depth

Start with `g_0(x)=[floor(x/rho)]`, whose cells have diameter at most `rho`,
and iteratively apply (4) at `R_h=rho/4^h`. Finite induction gives arbitrarily
fine nested partitions. Because the support is finite, some finite `J`
separates it. Existence of this `J` is the only use of positive distances
between distinct support atoms; the theorem does not assume a specified
separation or a bound on `J`. The singleton case is included vacuously.

For each fixed band, (4) charges

\[
 \sum_{\substack{0\leq h<J\\s_\ell\leq R_h}}
 \frac{2s_\ell}{R_h}\leq\frac83.
\]

The summands grow by four and the largest is at most two. The finite
geometric-series identity proves the bound for every finite `J`.
Thus the total refinement cost is at most

\[
 \frac{2816}{3}k^4\ln(2)\sum_{s_\ell\leq\rho}c_\ell(\nu)
 \leq1000k^4\ln(2)\sum_{s_\ell\leq2\rho}c_\ell(\nu).
 \tag{5}
\]

This is `total_charge`; the factor `J` has disappeared.

The entropy of the independent tuple is `k H_n(nu)`. Its initial label
entropy is `k H_n^0_rho(nu)`. The terminal labels determine the tuple, and
the sum `Y` takes values in the actual finite sumset `kF`, so
`H_n(Y) <= ln|kF|`. The finite conditional-entropy chain and (5) now give

\[
 kH_n(\nu)\leq
 \ln|kF|+kH^0_{n,\rho}(\nu)
 +1000k^4\ln(2)\sum_{s_\ell\leq2\rho}c_\ell(\nu).
\]

Divide by the positive number `ln(2)`. This proves the claimed theorem and
then, by monotonicity of the nonnegative capacity sum, the manuscript's
`60000*k^4` version.

## Exact adversarial diagnostics

`verify.py` additionally checks six explicit finite laws, their exact
primal/dual capacity certificates in every nonempty band, and 36 entropy
inequalities. Entropy comparisons use rational enclosures from the positive
artanh series with an explicit rational remainder, not floating-point
evaluation. These computations are diagnostics only; universality comes from
the Lean proof.

The laws include a singleton, negative and exact-grid endpoints, exact dyadic
distance endpoints, weights as skew as `1-2^(-60)` and `2^(-60)`, and separation
`2^(-80)`. They also include the uniform law on `{0,1,3/2,2,3}`. Its band
`[1,2)` is a five-cycle with fractional capacity `1`, witnessed by weight
`1/5` on each edge and dual vertex weights `1/2`. Disjoint integral pair
matching has value only `4/5` there. Thus the certificate would detect the
prohibited replacement of fractional capacity by integral matching.

The typed Jacobian conditioning operation was executed on the four equally
likely encodings `2X_1+X_2` of independent fair bits and conditioned on
`X_1+X_2=1`. It correctly returns the two off-diagonal atoms of mass `1/2`;
conditional independence fails. This confirms why independence must be used
before conditioning on the sum. It does not refute the manuscript, whose
argument observes precisely this distinction.

The inspected rational LP operation rejected the five-cycle standard-form
payload because its internal simplex-basis bound was exceeded. Its original
typed error and exact payload are preserved. That adapter outcome is not
mathematical evidence for or against the lemma. The explicit primal/dual
certificates are checked independently by rational arithmetic instead.

## Relation to the prior record and the full manuscript

The cited upstream revision
`4eaee87548250b2682affda7d05d947c05554bae` already contains substantive Lean
proof implementations, including `SumsetBound.lean`; its toolchain is
Lean 4.34.1. The stronger numerical constant above is already implicit in
that route's estimates. Neither a new literature theorem nor a
`verified_new` novelty verdict is claimed.

The improvement to this campaign's evidence is specific: a pointer to an
upstream implementation has been replaced by a fresh Lean 4.31.0 compiler
certificate for the full universal technical core. This reconstruction
imports none of the upstream `GridCoupling`, `FiniteRefinement`, or
`SumsetBound` modules. Its declared elementary support consists only of
`Model`, `Basic`, `FiniteEntropy`, `FairPairs`, and `ProductLaw`, compiled from
the supplied source. The build tool narrows one unused import and performs
statement-preserving identifier renames for Lean 4.31 compatibility.
The nontrivial refinement, conditioning, fractional conversion, and charging
proofs are in the current `Main.lean`, not postulated as hypotheses.

For the main dimension theorem, the manuscript's dependency chain is:
exact dimensionality and entropy calculus; nonsaturation;
block-type entropy deficit; this finite-law bound; pair-band selection;
conditional entropy gains; disjoint-window telescoping and contradiction.
Those other nodes remain open in `PROOF_GRAPH.json`. The Feng-Hu Theorem 2.8
assumption is recorded on `L_EXACT_DIMENSION` as a main-theorem input, with
DOI `10.1002/cpa.20276`; its independent citation attribution is still
outstanding. It is **not** an assumption of `C_PAIR_BOUND` or of this proof.

No false literal manuscript assertion was identified in this bounded
mission, so no refutation claim is asserted and no `F_` entry is warranted.
The compile checks encoded mathematics; an independent Reviewer still needs
to assess statement fidelity, replay the certificate, and decide significance.
The campaign's publishability/novelty and full-theorem gates remain open.

## Replay

From the campaign directory:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/pair-bound/verify.py
```

The default command performs the real official compiler-and-axiom audit,
records the mechanical result against `C_PAIR_BOUND`, writes
`exact_certificate.json`, and runs both official campaign-local checks.
`--exact-only` deliberately runs only finite arithmetic diagnostics and
does not write or claim a universal certificate.

The source and its fidelity document must not be edited during that run.
To restore the declared elementary source dependencies from the pinned
primary repository before replaying, use `build_support.py --fetch --build`.
No new Lake workspace, Mathlib download, or Git operation is needed.
