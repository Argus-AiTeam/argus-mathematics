# Exact correction: analytic verification and extension

A self-contained proof verifies the scoped exact-correction proposition and
extends it to polynomially degenerating second forms, varying smooth target
metrics, arbitrary ambient dimension at least four, and any prescribed
polynomial `C^2` proximity. The exact algebra replay passes. Lean 4.31.0
compiled the universal scalar waiting/transfer core with exit code zero and
no proof holes. **Independent mathematical review remains pending.**

The active target is Proposition `prop:exact-correction`, not the complete
closed-surface immersion theorem. All source references below mean the staged
September 23, 2026 manuscript in `research/openai_manuscript/`.

The strongest prior project result was an untested mission statement: there
was no mathematical certificate or reviewed mathematical claim in the ledger.
The proof graph now records the manuscript's mathematical dependencies instead
of treating the audit mission as a theorem.

## Scope settled before the proof

The crucial distinction is between the retained order `r(k)=40(k+1)` and
an arbitrary fixed observation order `m`. The step must control the latter
linearly without putting its uncontrolled input norm into a smallness
threshold. Checking the six exponents alone would not establish this.

The scoped dependencies are positive good phases, quantitative phase data,
the **unperturbed** finite small-mode construction, moment-cancelling
smoothing, the quadratic tail identity, initialization, and finite waiting.
The polynomial perturbations used in primitive realization are a separate
open assertion; they are not silently assumed in the exact-correction audit.
The velocity-loop, global preparation, and boundary-normal propagation
arguments remain outside the present certification.

A bounded primary-literature lookup found no exact match for the stated
finite-input correction under only a nonzero second fundamental form. This
is not a literature-wide novelty claim. The actual comparisons were:

* Hamilton (1982), DOI `10.1090/S0273-0979-1982-15004-2`,
  III.1.1.3, printed p. 172: "Suppose DP is surjective with a smooth tame
  family of right inverses VP." III.3.3.1, pp. 211-212, also permits a
  smooth tame approximate inverse satisfying
  `D_f A V h = h + Q{A,h}` near a base zero. Thus "no exact inverse" alone
  is not a new feature. The complete publisher scan was read through its
  July 24, 2020 archival capture; direct publisher access returned 403.
* Kallen (1978), DOI `10.1007/BF02385981`, Lemma 3.3, printed p. 43,
  constructs smooth compactly supported amplitudes within the preceding
  high-codimension iteration. Section 3, pp. 38-39, has limiting
  `H^alpha` regularity with `1 < alpha < 1+beta/2 < 2`, not the smooth
  four-dimensional conclusion here. The published Tsinghua scan was read.
* Gunther, ICM Kyoto 1990 proceedings (published 1991), vol. II,
  Theorem 1, printed p. 1139, assumes a smooth **free** map and a finite
  Holder-norm smallness condition involving its solver `E(u)`; it includes
  a smooth conclusion. For a surface, freedom requires five pointwise
  independent first/second derivative vectors and is impossible in R^4.
  The official IMU proceedings were read.
* An attempted Nash (1956) comparison at DOI `10.2307/1969989` was
  inaccessible through JSTOR. No assertion here relies on that unread
  passage.

These are scope comparisons, not external hypotheses used to prove the
correction theorem. The proposed analytic proof must derive its local
solver and smoothing estimates directly; no Nash-Moser theorem is being
invoked. Replacing nonzero second form by "free immersion" would change
the question and cannot certify this manuscript.

## Mathematical outcome

The theorem and proof are in
[`exact_correction_audit/theorem.md`](exact_correction_audit/theorem.md).
They retain exactly `R=440` derivatives of the normalized defect and map
jets through order `442`. For any `a,b,d >= 0` and `L>0`, an adequately
high **finite** defect power `N` suffices when
`||f_z||C(j+2)=O(z^(-a-b*j))` and the second-form lower bound is
`c*z^d`. The target can vary with `z`, with no parameter regularity
and no uncontrolled higher-derivative bounds. The output displacement
is at most `z^L`. The staged proposition is the case
`a=2,b=1,d=0,D=4,h_z=h_*`.

The proof discharges the unperturbed small-increment dependency directly.
It eliminates the transverse normal equation, uses a finite geometric
parametrix, adjusts the quadratic mean by a fixed finite number of
substitutions, and cancels the nonzero quadratic modes. The **same**
increment works at every observation order. Domain restrictions use
only finitely many smoothed norms; differentiating the already valid
finite formulas introduces no new domain restriction.

The important analytic point is not the exponent table. Smoothing
bounds every required slow weighted input norm from the finite cap.
The exact metric-transfer identity is linear in the unsmoothed tail:
the other factor is the smoothed-input increment. For a varying target,
the proof smooths that target too and explicitly retains its additional
linear tail. Thus all uncontrolled higher derivatives remain in the
displayed linear true-input norm, never in the step threshold.

The recurrence has arbitrarily late finite hitting times even for
arbitrarily large higher initial norms. Once its coefficient is at
most `1/4`, the explicit comparison is
`x_n <= 2B/3 + 4^(-n)*x_0`. This proves finite waiting, rather than
assuming a uniform bound on waiting times. Increasing retained orders
then gives smooth convergence and a summable total `C^2` displacement.
The existence and constant-independence of `N` are proved by the
first block's finite list of positive-power inequalities.

## Exact and formal evidence

Run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/exact_correction_audit/verify.py
```

The script and
[`exact_certificate.json`](exact_correction_audit/exact_certificate.json)
replay the normal-elimination signs, positive tensor basis, parametrix
induction algebra, exact metric transfer, and universal affine exponent
margins. Integer moment cancellation is replayed through the actual
initial order `440`. The all-order moment construction is proved in
the theorem, not inferred from that finite replay.

The Jacobian adapter's operation was
`matrix.rational_linear_system.solve`, server `0.14.0`, protocol
`2025-11-25`. Discovery, typed contract, exact payload, output, and
adapter status are preserved separately in the audit directory. Its
bounded order-four smoothing system has the independently replayed
solution `[5,-10,10,-5,1]`; it is not claimed to prove the analytic
theorem or all-order convergence.

[`Main.lean`](exact_correction_audit/Main.lean) and
[`statement_fidelity.md`](exact_correction_audit/statement_fidelity.md)
have a genuine Lean 4.31.0 result: `exit_code=0`, `proof_holes=[]`,
and axiom-audit exit code zero. The archived certificate is attached
to `C_FINITE_WAIT_CORE`, not to the full analytic theorem.
It proves the universal scalar recurrence/hitting-time mechanism,
persistence, the increment exponent margin, and bilinear transfer
algebra. Analytic interpretation and the remaining estimates require
independent mathematical reading.

## Status and remaining boundary

The previous project had no proved mathematical claim. This result
replaces the untested analytic choke point with a complete candidate
proof and a stronger quantitative theorem, together with a real formal
certificate for its scheduling core. Engineer supporting judgements
are opinions, not independent Reviewer acceptance.

No false literal manuscript assertion was established in this scope;
no `F_` refutation claim is manufactured. The perturbed small-increment
assertion, primitive realization, velocity-loop geometry, boundary
propagation, and main global theorem remain open in the dependency
graph. Literature-wide novelty and publishability are **unverified**.
The Host-invoked Reviewer must replay the certificate, assess the
analytic proof and statement fidelity, and decide significance before
any campaign-completion claim.
