# Statement fidelity: signed continuation core

`SignedContinuation.Matched` represents actual positive-length
nonbacktracking walks of oriented edge incidences. Its constructors
require compatible initial and terminal states, the closed state-step
relation, matching source/target vertices, and exclusion of precisely the
reverse incidence. No distinctness of states or vertices is required.

`Incidences` represents a regular finite multigraph by its outgoing
incidences `V x Fin degree` and a fixed-point-free reversal involution.
A loop reverses to a different incidence with the same first coordinate.
Parallel edges remain different incidences. No simple-graph hypothesis
is present.

`Good`, `record`, and `Exceptional` are definitions, not assumed
exceptional sets. The record is the greatest realized length below `n`,
defaulting to zero. `Matched.take_length` and `matched_lt` show that at a
good vertex this truncated definition is exactly the manuscript's
untruncated maximum. `exceptional_cover` derives the covering property
from actual walks. `exceptional_unique` proves at most one exceptional
direction at a good vertex; tied and zero records are not selected
unless there is genuinely a unique strict maximum.

`BumpData` supplies a finite state set inside an arbitrary metric space
`X`, a pseudometric label space `Z`, state labels which are 1-Lipschitz,
source labels at distance at most one across incidences, and real bumps
in `[0,L]` which are 1-Lipschitz. Positive bumps require label distance
strictly below `K`. `compatible` uses membership in the finite support
and label distance at most `K+2L+1`; `near` means state distance at most
`2L`. `label_transfer` derives compatibility at the opposite end from
these label hypotheses; it is not assumed as a covering axiom.

`opposing_cross`, `prescribed_lipschitz`, and `opposing_tests` derive
consistent opposing scalar prescriptions and extend them to all of
`X`, with Lipschitz constant one and range `[-L,L]`. The extension uses
Mathlib's proved real-valued Lipschitz extension theorem followed by
clipping. In particular, the statement is not only about values on the
finite support.

`signed_loss`, `edge_bound`, `good_loss_sum`, `total_loss`, and
`signed_continuation` use arbitrary real
coefficients `mu x j`, summed over the finite state set, with
`sum |mu x j| <= V`. Neither positivity nor mass one is assumed.
The per-edge bound is an upper bound on the absolute pairing of the
constructed opposing tests; no optimality or maximizing-test
assumption is needed. `reverse_sum` proves reversal invariance of the
uniform incidence sum. The normalized obstruction in
`BumpData.signed_continuation` is
`2*a0 - 4*L*V*(1/degree + beta) <= Lambda`, with `beta` equal to the
fraction of bad source vertices.

For the staged manuscript, take the label space to be its finite
sup-norm label space, source labels `h(x)`, state labels `h(j)`,
and its label bumps. The block-geometry and bump lemmas supply all
`BumpData` fields. The signed-measure lemma supplies `a0=3*L/4`
and the total-variation bound `V`; the operator norm supplies
`Lambda=2*p`. The parameter choice is `L=10*p`, `p>=1`.
The two small error terms are **`V/degree < 1/20` and
`V*beta < 1/20`**, not `1/degree` and `beta` alone.
`manuscript_margin` proves the numerical specialization:
`4*L*V*(1/degree+beta) < 2*L/5`, so the lower bound is
strictly greater than `11*L/10=11*p`, impossible for `Lambda=2*p`.

This formalization does not certify the existence or local limit of
the colored graph sequence, the adaptive-support selection of `n,m`,
the anchor metric construction, the finite-support operator
perturbation, the measure bounds, or the infinite-dimensional wedge
reduction. Those are separate open nodes in `PROOF_GRAPH.json`.
No finding about comparator Lean holes is a mathematical refutation,
and no full-manuscript or verified-novelty claim is made here.
