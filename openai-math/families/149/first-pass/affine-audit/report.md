# The arbitrary-tolerance affine lemma

## Scope and exact target

The target is `lem:affine`, September 25, 2026,
`build/sections/02-affine.tex`, and the same lemma in the October 5,
2026 manuscript, `build/sections/affine.tex`. Both staged statements
quantify over every positive function E on [a,b]^m, without regularity.
They require one finite nonempty family, with slopes fixed independently
of h, offsets o(h^a), strict error less than E evaluated at the slope,
and the conclusion for every tied minimizer. Convergent exponent
sequences may approach the cube from outside.

The common dependency chain is:

1. Fixed-minimum construction by induction on the coordinate dimension.
2. Closedness of limiting activity, compactness of the bad-limit set,
   and extension to an open interval of minimum exponents.
3. Finite interval selection with closed cut cells and offset shifts.
4. Sequential affine lemma, then its uniform small-h corollary.

The September chain continues through sign-compatible monomial order,
return-path cut flux, invariance of a compact positive plateau, and
global boundedness/persistence. The October chain adds strict increase
outside the stoichiometric orthogonal complement, finite entry at a
fixed scale, and finitely many square-root scale changes to obtain one
absorbing set per class. Proving the affine lemma alone does not certify
these downstream dynamical arguments.

## Prior knowledge and exclusions

The October manuscript explicitly attributes its affine lemma and
uniform corollary to September, Lemma 2.1 and Corollary 2.2. The two
staged proofs use the same construction. Thus a reconstruction of that
construction is not a new unformalized mathematical theorem.

The primary `openai/math` page `lean/docs/149.md` describes a boundedness
and persistence formalization. Its linked
`lean/ComparatorChallenges/MassAction.lean`, read on November 5, 2026,
contains a `sorry` at the comparator's final theorem. That comparator
alone is not a kernel certificate of either the affine lemma or the
permanence theorem.

The strongest relevant prior result is more substantial: at repository
commit `4eaee87548250b2682affda7d05d947c05554bae`,
`lean/OAI/Analysis/MassAction/AffineExistence.lean`,
`OAI.Problem326.Affine.exists_fullCertificate`, states the complete
universal affine lemma. Its `FullCertificate` includes nonemptiness,
cube slopes, little-o offsets, and sequential strict approximation;
`SequentialApproximation` allows exponent sequences outside the cube.
This primary source was obtained and read, not inferred from the
comparator. Its non-Mathlib dependency closure comprises 19 modules.
The source repository requests Lean 4.34.1; the assigned host requires
an actual Lean 4.31.0 replay. The project is therefore attempting an
independent re-elaboration and statement-fidelity audit of an existing
complete proof, not claiming to invent the affine theorem.

A bounded web lookup for the exact affine statement returned the staged
September paper and secondary discussions, but supplied no independently
verified earlier proposition with all the stated quantifiers. Its
generated description incorrectly equated o(h^a) with decay faster than
every power and incorrectly omitted the manuscript's discontinuity
permission. Neither description is used as mathematical evidence or a
novelty certificate.

Elementary inputs to the construction are finite-dimensional
Heine--Borel compactness, finite subcovers, continuity of a finite
minimum, and strict power separation: for h -> 0+, u(h) -> u > q
implies h^(u(h))/h^q -> 0; a limit u < q gives divergence to +infinity.
Convergence of exponents does NOT justify replacing h^(u(h)) by h^u.
Neither a positive infimum of E on the whole cube nor continuity of
the offsets in h is available.

The following approaches cannot settle the target: sampled tolerances,
fixed-dimensional enumeration, checking only unique minimizers,
restricting approximating sequences to the cube, conditional flux
certification, and checking the local construction without global
selection. These exclusions are requirements, not unsuccessful
counterexample searches.

## Current mathematical assessment

Direct reading found no counterexample in the two threshold comparisons,
the diagonal closedness argument, or the adjacent-family comparison.
This is an assessment, not a proof certificate. In particular, failure
to find a flaw is not evidence that the universal statement is verified.
The development route is complete universal certification. The
licensed pinned proof is dependency-ordered into `Main.lean`, with an
independently authored adapter whose tolerance really has the cube as
its domain. The replay must re-elaborate the entire proof, inspect the
final axiom dependencies, and record a fresh Argus compiler certificate.
Its analytic, inductive, and finite-selection obligations remain open
to independent review until that happens. There is no mathematical
improvement over the strongest prior existence result; the additional
deliverable is a reproducible 4.31.0 verification and literal-domain
statement check. It cannot honestly be labeled `verified_new`.

## Mathematical proof audit

The following is a verification of the existing argument, not a claim of
new mathematics. Write mu(p) = min_i p_i and X_h(p)_i = h^(p_i).

### Fixed minimum

Fix t in [a,b]. Include the baseline (t*1,0). In positive dimension
one, or at t=b, the baseline alone handles every cube point with
mu(p)=t.

Otherwise build types k=1,...,m-1. A type-k slope has precisely k
coordinates above t. Before constructing type k choose beta_k in (t,b),
strictly below beta_(k-1) when k>1, with
beta_k-t < E(r) for every already constructed type-(k-1) slope.
Only finitely many strictly positive values are involved. For each
k-element coordinate set U, invoke the lower-dimensional theorem on
[beta_k,b]^U with tolerance E evaluated at the slope extended by t
outside U. Replace each resulting offset d by -h^beta_k+d.
This yields a finite family; all its nonzero offsets have a leading
negative power with exponent strictly greater than t.

Suppose a fixed type-k label stays active along a sequence converging
to p in the cube with mu(p)=t. For k>0, comparison with the baseline is

    sum_(i in U) (r_i-t) h^(p_i^n) <= h^beta_k - d(h).

Every coefficient is at least beta_k-t>0. If p_i<beta_k, a fixed
positive exponent gap makes the left-hand side divided by h^beta_k
unbounded, whereas the right-hand side tends to 1. Thus
p_i>=beta_k on U. Activity restricts to the subfamily associated with
this U; its common terms cancel exactly. The induction hypothesis
therefore gives strict error <E(r) on U. This invocation is valid even
when the projected sequence approaches beta_k or b from outside.

If k<m-1 and some off-support coordinate p_j>beta_(k+1), use a
type-(k+1) competitor raised on U union {j}. All of its raised
coordinates have limiting exponent strictly above beta_(k+1):
on U this follows from beta_k>beta_(k+1). Its relative value against
the baseline is -h^beta_(k+1)+o(h^beta_(k+1)). The active label's
relative value is at least -h^beta_k+o(h^beta_k), or zero for k=0.
The competitor is strictly smaller, a contradiction. Hence every
off-support error is at most beta_(k+1)-t, which is strictly below
that label's E(r). When k=m-1 the unique off-support coordinate is
exactly t because the minimum is t. This proves all coordinate
errors strictly, without asserting strictness at a threshold.

The formal obligations are discharged by
`typeFamily_layerCertificate`,
`layerUnion_approximatesAtMinimum`, and
`localCertificate_of_layers`, together with the dimension induction in
`fullCertificate_of_local_and_glue`.

### Closed activity limits and local bands

For each fixed label let A_L be its limiting activity set in the cube,
allowing all approximating exponents in the ambient space. To show
closedness, take z_n in A_L with z_n -> z. From each realizing sequence
choose an actual active exponent u_n within 1/n of z_n, at an actual
parameter 0<h_n<1/n. Then u_n -> z, so z lies in A_L.
No continuity of an offset was used.

For each label the set of its bad limits,

    A_L intersect {p : norm(p-r_L)_infinity >= E(r_L)},

is closed in the compact cube. The union over the finite family is
compact, and the fixed-minimum result makes it disjoint from mu(p)=t.
Continuity of mu gives a positive open band I_t around t containing
no bad minimum. Here E(r_L) is a fixed real number for each label,
not a continuous function of p.

The radius can also be chosen with t+rho_t below every nonzero
leading local offset exponent. Thus each offset is o(h^(t+rho_t)).
This stronger statement is indispensable for the next comparison;
o(h^t) alone would not justify it. The formal source retains this
power margin in `LocalCertificate.decayExponent` and uses
`LocalCertificate.exists_radius` and
`exists_local_band_of_approximatesAtMinimum`.

### Global selection

Take a finite subcover by the symmetric open intervals I_t and remove
contained intervals. Ordering their centers also orders their two
endpoints strictly. Consecutive intervals overlap, or their intervening
gap would be uncovered. One can choose each transition cut q_j strictly
between the adjacent centers and strictly inside both adjacent
intervals. Consequently each closed cell [q_(j-1),q_j] lies inside the
open interval assigned to its family, including both endpoints.

Shift every offset in family j by -sum_(ell<j) h^q_ell. These shifts
preserve local activity. All q_ell>a, and all local decay exponents
are greater than a, so every global offset is o(h^a).

If a globally active label from family j had limiting minimum
mu(p)>q_j, compare it with the shifted baseline of family j+1.
The label's value minus that baseline is

    (r-t_(j+1)*1) dot X_h(p^n) + c(h) + h^q_j
      = h^q_j + o(h^q_j) > 0.

The local offset comparison uses q_j<t_j+rho_(t_j), not merely
q_j>t_j. If instead mu(p)<q_(j-1), comparison with the previous
shifted baseline gives

    (r-t_(j-1)*1) dot X_h(p^n) + c(h) - h^q_(j-1).

All coefficients in the scalar product are at least
t_j-t_(j-1)>0. At least one coordinate has limiting exponent below
q_(j-1), so division by h^q_(j-1) tends to positive infinity;
the local offset is negligible at that scale. Both cases contradict
activity. Therefore the minimum lies in the assigned closed cell,
and hence in the local family's valid open band. Restricting global
activity to that family proves the required strict approximation.
The comparisons produce strict competitors, so every tied minimizer
is covered. The formal source implements these steps in
`exists_approximating_family_of_local_families`,
`gluedFamily_approximates`, and `glue_localCertificates`.

The usual uniform corollary follows by taking a sequence of putative
violations on the compact cube, extracting a constant label subsequence
and a convergent exponent subsequence, and passing the non-strict
opposite inequality to the limit. The strict sequential conclusion is
a contradiction. This argument again fixes E at the chosen slope.

## Bounded computational check and limitations

Jacobian 0.14.0, protocol 2025-11-25, was inspected through the authorized
Argus adapter. The exact payload and typed response for operation
`optimization.linear.rational_general_optimum.compute` are retained in
the dedicated `jacobian-cut-*.json` files. One initial, redundantly
bounded payload was refused at admission with a simplex-basis limit;
its original payload and structured error are retained and imply
nothing mathematically.

Removing redundant variable bounds gives a two-variable illustration:
maximize d subject to q-d>=1/4, q+d<=3/4, and d>=0. The typed solution
is q=1/2, d=1/4. The verifier checks exact rational primal inequalities
and dual multipliers (-1/2,1/2), whose sum bounds the objective by 1/4.
This demonstrates a strict interior cut for that one cover. It is
explicitly NOT evidence for the universal affine theorem; only the
complete kernel proof can supply that evidence.

The first full-source replay on Lean 4.31.0 found two API-name
incompatibilities with the upstream 4.34.1 toolchain:
`IsLittleO.fun_sum` and `dite_eq_left`. Their 4.31 counterparts are
`IsLittleO.sum` and `dif_pos`. These are compatibility changes, not
false mathematical manuscript assertions. The unsuccessful compiler
answer was recorded as inconclusive, never as a refutation.

## Measured result and review boundary

The corrected complete source was re-elaborated on Lean **4.31.0**.
The prescribed Argus verifier returned **exit_code=0, proof_holes=[]**,
and its separate axiom audit returned zero. The measured Lean-plus-audit
duration was 25.110 seconds. Both the literal cube-domain theorem and
the upstream complete existence theorem depend only on `propext`,
`Classical.choice`, and `Quot.sound`.

The current mechanical certificate is
`certificates/C149_AFFINE-83bb1636a8e68c29.json`, relative to this
directory. `exact_certificate.json` records its actual evidence reference,
scope, source pin, and bounded Jacobian replay. To independently replay:

    $WORKSPACE/argus-live-update/.venv/bin/python research/affine-audit/verify.py

No network access or source acquisition is needed for replay. Do not
pass `--acquire` when replaying; that flag deliberately regenerates the
licensed source and is not a verification command.

After retiring the prior-result assumption with the reason that its
entire proof is now kernel-checked, `math_state show --claim C149_AFFINE`
reports **closed_kernel**, with no undischarged assumptions. Citation
status has no outstanding items. Both official checks returned zero
against the exact campaign root
`campaigns/9000149`.

This settles the complete affine lemma at the proof-kernel level,
including discontinuous positive cube-domain tolerances, fixed finite
slopes, little-o offsets, strict error, every tied label, and exponent
sequences outside the cube. It does not merely check a sampled
tolerance, a flux consequence, or a conditional gluing assertion.
No false mathematical assertion in the staged manuscripts was
established, so no artificial `F_` refutation claim has been filed.

**Independent review remains pending.** In particular, the English
statement-fidelity document still needs an independent reading, and no
proof-graph node has been marked proved without Reviewer confirmation.
`C9000149` is retained and is not declared complete.

**Campaign-level novelty remains open.** The result is `known_result`
(a complete independent replay), not `verified_new`; there is no
mathematical improvement over the strongest pinned prior theorem.
Accordingly this is not authority to terminate the publishable
counterexample/new-theorem campaign. After Reviewer assessment, Planner
must choose a genuinely unresolved route if that larger goal remains
in force. The downstream permanence claims remain unverified here.
