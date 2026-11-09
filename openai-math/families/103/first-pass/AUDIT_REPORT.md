# Adaptive block coupling audit

## Scope and current status

The target is `prop:fp-coupling` in the staged September 23, 2026 manuscript,
not the equality of complexity classes. The present route checks whether the
actual recursive estimator satisfies the escape and collision accounting.
The result is a universal verification theorem for the adaptive accounting
implication, with a Lean formalization and exact sharpness/necessity
constructions. Independent review, statement-fidelity approval, and
publication-level significance/novelty assessment are still required.
No literal assertion of the manuscript has been refuted.

The local Wiki index has no entry matching logarithmic-space
derandomization, fingerprints, hashing, or this campaign. No prior local
verification of this junction was available in the initial claim ledger.
The manuscript itself is the primary source for its algorithm and interfaces.
No external theorem is needed for the finite counting inequalities under
investigation; external literature has not yet been used as a proof premise.

## Scoped dependencies

All source paths below are relative to
`research/openai_manuscript/Exact-Derandomization-of-Logarithmic-Space-L-equals-RL-equals-BPL-September-23-2026/build/sections/`.

| Obligation | Manuscript source | What must be established |
|---|---|---|
| Clean independence | `fingerprints.tex`, `lem:fp-clean`; environment and controller interfaces | Every structural operation, not just numerical output, ignores the current effective block salt in the clean calculation. |
| Unit witnesses and caps | `atoms.tex`, `lem:atom-margins`, `lem:atom-ports` | Exposed zero-weight ports have a unit witness; the actual correction relation, not its numerical support alone, has capped incoming multiplicity. |
| Common right task | `atoms.tex`, actual-port interface; `estimation.tex`, `lem:est-paths` | After a fixed variant and copy part, the right task and its environment do not retain the old source. |
| Escape charge | `fingerprints.tex`, `lem:fp-escape`, `eq:fp-actual-incoming` | Retain transformed memberships until changing variables and summing out the old source. |
| Bucket update | `fingerprints.tex`, `lem:fp-buckets` | Salt-dependent representative selection aliases only increments and does not move or add stored values. |
| Collision charge | `fingerprints.tex`, `lem:fp-envelope`, `lem:fp-direct` | The clean endpoint envelope and clean increment heights are salt independent; no conditioning on the adaptive stay-inside event is permitted. |
| Propagation and precision | `compression.tex`, `lem:buf-update`, `eq:buf-propagation`; `estimation.tex`, `eq:est-child-precision` | Uniform full-array Lipschitz propagation and the precision gain pay for the source-release factor. |
| Coupled induction | `fingerprints.tex`, `prop:fp-coupling` | Every actual dependency satisfies the interfaces above, with constants selected in the stated order. |

The main theorem `thm:main` additionally requires the exact hierarchy,
clean-estimator reserve, finite arithmetic, controller implementation, and
final decision argument. A result about the scoped junction alone will not
be reported as verification or refutation of that theorem.

## Routes excluded before solving

A fixed-pair hash collision estimate alone does not justify an adaptively
chosen endpoint set. Likewise a bounded search finding no counterexample
does not prove a universal accounting assertion. Neither is an acceptable
substitute for the live objective; the stable-envelope route is being
examined instead.

## Universal adaptive accounting theorem

Fix all effective environment coordinates except the current block salt.
Let `S` be a finite salt space with nonnegative weights `p_s`; when it is
a probability space their sum is one. Let `X,Z,Y` denote actual source,
midpoint, and terminal IDs. All sets and sums below are over actual IDs,
never padding dummies. Write `[P]` for an indicator and use eighth-root
witnesses as the input functions.

For each salt let `D_s(x,y), L_s(x,z), R_s(z,y)` be actual exposed
relations. They may depend arbitrarily on the salt and may contain
zero-weight entries. Suppose:

1. The actual root witness is one on each corresponding exposed port.
   The direct, midpoint, and right-terminal membership masks hold at
   those ports.
2. Clean witnesses `c_D,c_L,c_R` define an envelope `E_x`: it contains the
   support of `c_D(x,.)` and every endpoint in the support of
   `c_R(z,.)` whenever `c_L(x,z)` is nonzero.
3. The **actual exposed** left relation satisfies
   `sum_x [X(x)] [L_s(x,z)] <= K_c` for every salt and midpoint.
   The right energy is one common function of `s,z`, not of the discarded
   old source.
4. `E_x`, a collision height `H_x`, and the outer source mask are fixed
   as the current salt varies. Every distinct fixed pair of IDs has
   weighted collision probability at most `delta`.

Define `e_D,e_L,e_R` as the corresponding masked sums of absolute
root-witness discrepancies to power eight. If `F_s(x)` means some
valid direct or two-factor actual candidate leaves `E_x`, then

```text
sum_x [X(x)] [F_s(x)]
 <= sum_x [X(x)] (e_D(s,x) + e_L(s,x))
    + K_c sum_z [Z_s(z)] e_R(s,z).                    (1)
```

In particular, after division by `N*u`, the last term is exactly
`K_c*(f/u)` times the right child's power metric with normalization
`1/(N*f)`. No conditional distribution of an adaptively chosen path
is used.

For any salt-dependent powered losses `Q_s(x)` and numerical remainder
`P_s(x)` satisfying the pointwise decomposition

```text
Q_s(x) <= A [F_s(x)] + P_s(x) + [C_s(E_x)] H_x^8,
```

where `A >= 0` and `C_s(E_x)` is a key collision inside the fixed envelope,
one has

```text
sum_s p_s sum_x [X(x)] Q_s(x)
 <= A sum_s p_s {
       sum_x [X(x)] (e_D(s,x)+e_L(s,x))
       + K_c sum_z [Z_s(z)] e_R(s,z)}
    + sum_s p_s sum_x [X(x)] P_s(x)
    + delta sum_x [X(x)] |E_x|^2 H_x^8.              (2)
```

The theorem is universal in the cardinalities, salt weights, actual
relations, discrepancies, keys, and adaptive choices. It is not inferred
from the finite examples in the certificate. Equation (1) is
`witness_escape_charge` followed by `integrate_escape_charge` in
`Main.lean`. Equation (2) is their specialization into
`adaptive_accounting`. All hypotheses of that last theorem, including
its pointwise loss decomposition, are explicit; it does not manufacture
such a decomposition for an unspecified estimator.

### Proof of the escape charge

A direct escaped port has actual root witness 1 and clean witness 0.
Its masked discrepancy power is therefore 1. For a two-factor escaped
path, either the clean left witness is zero, giving the same unit charge
to the left child, or it is nonzero. In the latter case the envelope
definition forces the clean right witness at that endpoint to be zero,
so the right discrepancy power is 1. Existence of an offending path is
bounded by the sum of these nonnegative unit charges. All masks at the
offending ports remain in the corresponding sums. This argument never
uses the numerical increment or a positive lower bound on it.

For the right-factor term reverse the finite source and midpoint sums.
The coefficient of a fixed nonnegative right energy is the number of
actual left ports entering that midpoint from retained sources, at most
`K_c`. This proves (1). In particular, salt dependence of the actual
relation does not matter: the argument is pointwise in the salt.
`capped_transport` and `normalized_source_release` formalize the reversal
and its exact normalization.

### Transformed masks and a fixed variant

A guessed variant is held fixed before changing variables. Apply its
full-environment bijection to the **whole integrand**, including the
source, midpoint, terminal, and wrap-validity guards. Only after this
change may surplus guards be dropped. `fixed_variant_reindex` proves
the sum identity for an arbitrary integrand and fixed bijection.
It supplies no identity for a variant selected from the environment.

After this reindexing, the manuscript's candidate tests retain the
transformed `X_u(x)`, `Z_f(z)`, and `Y_a'(y)` memberships in
`eq:fp-actual-incoming`. The left relation's cap is applied with that
same transformed source mask. The right energy is queried at `z` in
the same transformed environment and fixed copy part. This is precisely
the type `r : Z -> Real` in the formal transport theorem.

### Buckets, arbitrary representatives, and defaults

Let `C` be the set of actual candidate addresses after combining
increments at equal actual IDs. A bucket has either all its old
representatives or its first valid new representative. Thus every
candidate key has a representative. Outside the escape event both
candidates and carried representatives are in `E_x`, including
default-valued representatives.

If envelope keys are injective, coverage forces a candidate's
representative to be that candidate's actual ID, so bucket distribution
is exact. With a collision, every representative receives a sum of
at most `|C|` unaliased address increments. If their actual-clean
supremum discrepancy is `e` and the clean height is `h`, then

```text
|bucket_actual(y) - increment_clean(y)|
 <= (|C|+1) (e + [C_s(E_x)] h).
```

The old full-array values are added separately. The triangle inequality
therefore gives their old discrepancy with coefficient **one**, not
with a key-dependent multiplier. `only_increments_aliased` proves
exactly this statement for arbitrary old arrays and arbitrary
representative selection satisfying key coverage. In particular a
zero-increment candidate may be selected first and receive another
candidate's nonzero increment. No continuity of representative
selection and no equality of stored lists is assumed.

New representatives start at the actual old default because their
addresses were absent from the actual old list. This is the actual old
full-array value at that address. Compression/clamping can subsequently
be compared as maps on full arrays and defaults; retained default-valued
slots are presentations, not an additional error term.

### Collision averaging without adaptive conditioning

For a fixed envelope, its collision indicator is bounded by the sum of
the collision indicators over ordered distinct pairs in the envelope.
Weighted summation gives `|E_x|^2 delta`. Because `H_x` and `E_x` are
fixed with respect to the current salt, the same inequality can be
multiplied by `H_x^8`. It is integrated on the entire salt space,
**not** conditionally on no escape. This is
`fixed_envelope_collision` and `stable_height_collision`.
Summing the pointwise loss decomposition, applying (1), and then this
collision bound proves (2).

## Specialization to the staged estimator

The following are source-level verifications, distinct from Lean
checking the abstract inequalities.

**Unit witnesses and exposed caps.** In `atoms.tex`,
`eq:atom-exposed-class` uses errors at most `theta/10000`, an entry
test above `3 theta/8`, and a rank test below `theta/200`.
These imply an actual entry above `theta/4` and a rank below
`theta/100`, so `I_theta=1` on every exposed entry, including numerical
zeros. For the auxiliary class the analogous margins imply `J_theta=1`.
The Kth-rank argument bounds their row sizes, for arbitrary inaccurate
arrays. Default positions cannot pass an entry threshold exceeding
the rank threshold because at least K dummies share their default.

For corrections and preparations, the explicit deletion
`eq:atom-port-cap` removes **all** precursor entries at an overfull
column, not only positive-weight entries. This yields the cap required
by (1). At an overfull column at least K_c auxiliary scores are 1,
so the incoming gate is already zero there. Deletion consequently
preserves values. The broader auxiliary-score class is not the left
factor and does not need an incoming cap.

**Common tuple.** `atoms.tex` specifies vertices as table arguments,
not retained parameters; `estimation.tex`, `lem:est-paths` specifies a
right tuple independent of the discarded source, after a fixed copy
part and guessed variant. A separate read-only implementation trace
found the same invariant in `implementation.tex` lines 1-20, 49-64,
and 1098-1107, and same-tuple inverse/rollback requirements at lines
92-104 and 678-687. This is not a claim that arbitrary source-indexed
right task families satisfy the transport theorem.

**Salt independence.** The clean calculation replaces comparisons
throughout the current block, including access classes and port
orders. By budget induction, lower-block actual children and same-block
clean children use only earlier effective salts. Fixed own variants
freeze the current and later effective salts. Exact grouping,
finite-accuracy tests with fixed tie rules, compression, and completed
incoming queries are functions of those earlier operands. Thus clean
witness supports, their union over fixed variants, and the clean
increment heights depend on outside coordinates but not the current
salt. The implementation trace identified the structural-access rule
at lines 1086-1094, 1139-1153, and 1161-1179; paired-path validity is
checked at lines 654-674 and 920-944. The required transformed masks
are explicitly specified by `estimation.tex`, `lem:est-paths`, and
`fingerprints.tex`, `eq:fp-actual-incoming`.

**Envelope and height.** At slack d there are `2^(O(d))` fixed
descriptors. Each direct witness has bounded support; each two-factor
descriptor contributes boundedly many clean left midpoints and
boundedly many clean right endpoints for each. The boundary list has
`2^(O(h_*))` entries. Their union has size `2^(C_E h_*)`, independently
of the current salt. An escaped candidate is therefore exactly of
the kind covered by (1). A zero-weight candidate is not omitted.

The clean true-ID increments are combined at the same endpoint within
each paired budget difference before any norm bound is applied.
The stated `lem:est-raw-difference` hypotheses give clean row-height
norm at most `2^(-p+O(d))`. A descriptor with zero increment only
increases the finite candidate count. The bucket bound, uniform
full-array Lipschitz compression, common nonexpansive clamps, and
root-Lipschitz final functions then provide the manuscript's pointwise
loss decomposition, with numerical remainder from child discrepancies.
Bounded final support converts row suprema to output metrics.

The resulting height satisfies
`||H||_row <= 2^(-p+C_0 h_*)`. Applying (2) conditionally on outside
coordinates with the manuscript's fixed-pair bound yields
`2^(-p) 2^(C h_*) B^(-1/16)` in norm. The source-release factor
is paid by the precision identity: with `r=f/u>=1`, a child gain
`r^(-1/2)` dominates the cost `r^(1/8)`. The powered version is
`precision_pays_reset`.

These are universal accounting implications under the stated child
norm estimates, not evidence that every upstream target estimate has
been established. In particular the clean reserve and the full
controller space analysis remain separate obligations in the graph.

### Consequence for the block induction

Under those upstream induction hypotheses the charges have exactly
the recurrence written in the manuscript:

```text
coupling(M) <= 2^(-p) {
  lambda_M sum_(d>=1) 2^(-(D_2-C)d)
  + 2^(C h_*) B^(-1/16) }.
```

For example `D_2-C>=3` makes the infinite child sum at most `1/7`.
Choose `D_1>D_2+1` and a positive rational epsilon with
`1/(16 epsilon)>C+D_1+2`; then the direct term is at most
`lambda_M/4` after the permitted fixed minimum-size padding.
The precision identity and common-tuple cap introduce no hidden
source-count factor. This verifies the escape/collision induction
step; it does not certify the clean reserve on which its hypotheses
depend or the final complexity-class equality.

## Exact constructions and adapter evidence

`verify.py` replays the following exact rational constructions. They
are **not counterexamples to the manuscript**, whose definitions
exclude the weakened interfaces involved:

1. Two exposed zero-weight left ports enter one midpoint. Left witness
   errors are zero, the right witness error power is one, and the
   escape/source-release charge saturates the cap. A cap on numerical
   nonzero support instead would give a false zero bound.
2. With n salts and n source-indexed right tasks, each fixed task can
   have mean error `1/n` while selecting the matching source task gives
   error 1, despite pointwise incoming cap one. The common-tuple
   hypothesis is essential.
3. Six keys on four IDs, one colliding pair per salt, have fixed-pair
   probability `1/6`; selecting the colliding pair as the envelope makes
   collision certain, contradicting the invalid bound `4/6`.
4. A height supported only on a fixed pair's collision violates the
   attempted salt-independent-height factorization.
5. A salt-selected permutation need not preserve uniform averages,
   even when each fixed permutation does. Retaining an untransformed
   source mask during a fixed change of variables also changes the sum.
6. A zero-increment first candidate can receive another candidate's
   increment; the proved bucket bound covers it. Combining old stored
   heights by key, which the actual rule does not do, would fail that
   bound even with zero new increments.

The Jacobian adapter's two initial LP submissions were rejected by
its simplex-basis admission bound. Their exact payloads and structured
errors are preserved as non-conclusions in `exact_certificate.json`.
The final smaller LP retains the exposed incoming-cap equation and
relaxes individual unit upper bounds. An exact dual bound for this
relaxation applies to every actual unit incidence vector; the separate
two-unit-port construction attains the bound. The LP is auxiliary
sharpness evidence, not the universal verification.

## What remains unverified

The compiler checks the encoded universal inequalities, not their
specialization to a particular recursive program. The source-level
translation above, its upstream norm hypotheses, publication-level
significance, and novelty require independent review. No external
literature theorem was used as a new proof premise. The ledger's
source-only assumptions identify locally staged propositions rather
than pretending to have registry-resolved citations.

The strongest prior project record had only the global audit goal and
no scoped evidence. The improvement is a universal kernel-checkable
accounting certificate, not a bounded negative search. No
`verified_new` or campaign-final acceptance is claimed. There is no
`F_<LABEL>` claim because none of the constructions violates the
literal manuscript with all its stated hypotheses.
