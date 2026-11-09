# Finite core: exact formal scope and replay

**Assessment: supported finite algebra, not an analytical or whole-paper
certificate.** This unit covers `DB_FINITE_CORE` v1 and v2. It reviews
existing work and reproduces its formal source; it asserts no new
mathematics or verified novelty. Native independent acceptance of this
review remains pending.

## Contribution classification and attribution rationale

**Classification: `confirmed_reproduction`.** The load-bearing content
re-proves the paper's finite marginal-core argument
(`02-entropy.tex:369-409`, `lem:marginal-core`) in its two-factor case,
and its elementary retention and mesh algebra
(`07-rate-transfer.tex:951-967,1007-1021`). The paper already charges each
removed factor value once and obtains the same degree floors and mass
loss. Argus supplies a potential-maximization proof, explicit scalar
lemmas and a Lean artifact; different proof presentation and broader
algebraic parameter conventions are not counted as an original
load-bearing result. The manuscript's mathematics remains attributed to
OpenAI, and the finite proof/code to the old Argus Engineer. This label
does not equate the four Lean declarations with the paper's more general
multi-observation lemma or certify its analytical applications.

## Claim, source versions and attribution

The old claim asserts universal finite two-sided core existence with raw
mass at least `m-2*delta`, surviving row/column floors, conditional-cap
transfer at positive thresholds, retained-parent normalization with loss
`(r*v)^(-1)`, and mesh exponent loss at most four mesh widths.

The source is the old Argus Engineer's `research/directional_bootstrap/`
draft in campaign `9000078`, specifically report section 2, lines
108-171, `Main.lean`, and `statement_fidelity.md`. The argument and
formalization are attributed to `engineer:copilot`; the pre-existing
independent reading remains attributed to `reviewer:copilot-independent`.
This is formal verification of an elementary finite argument, not a
literature-verified claim of priority.

The preserved snapshot is `2026-11-06T10:20Z`. The current old source and
its reading match its manifest:

| Object | SHA-256 |
|---|---|
| `Main.lean` | `b1f3528bd130d4aa6d707a73e1d8a1c62bc9696c1645754a5484fe6a637714b0` |
| `statement_fidelity.md` | `e38799d7e98f47e951b21b674b877f3404ce03e6ed6b3887f5213cc0ae59b85f` |
| v1 claim, prose only | `13ca541c285f79719ba888f35ab73aa0d67e8cd95705ee3dad83e13f1eaa2a7a` |
| v2 claim, including formal source | `fe58b4e6f691b08ff253c0cb79aa9211302c60a2f6e365cb5cabd031fc91e58b` |

These are two claim versions, not two mathematical results. The old
mechanical certificate and independent judgement bind **v2**, not the
different v1 hash. V1's same mathematical assertion is assessed from the
prose argument and its v2 formal counterpart; no v1 compiler certificate
is invented.

The manuscript comparison is revision
`4eaee87548250b2682affda7d05d947c05554bae`: the reciprocal normalization
in `07-rate-transfer.tex:951-967` and unchanged-tree interpolation in
lines 1007-1021. The finite lemmas justify algebra used there, not the
geometrical premises needed to apply that algebra.

## Exactly what the four declarations prove

All declarations are in namespace `DirectionalBootstrap`.

| Declaration / source start | Objects, hypotheses and conclusion |
|---|---|
| `two_sided_core`, line 11 | Arbitrary finite row/column types; entrywise nonnegative real matrix; nonnegative reference weights summing separately to one; real `delta>=0`. There exist finite subsets `I,J` with nonnegative retained mass, mass at least the original total minus `2*delta`, and the two raw degree floors. The original matrix need not be a probability or a product. |
| `reciprocal_retained_cap`, line 81 | A finite parent row set, finite column type, arbitrary real matrix and weights, positive parent weight, positive `r,v`, and per-row sum at most `cap*mu(a)`. Summing and dividing by `parentWeight*r*v` gives at most `cap/(r*v)`. The source does not require a nonnegative matrix, normalized weights, or nonnegative cap for this algebraic implication. |
| `fiber_cap_from_core`, line 101 | Real event, row and reference masses; positive row mass and threshold; nonnegative cap; a row floor and an event upper bound. It proves `eventMass/rowMass<=cap/delta`. It is a scalar implication, reusable for each positive-mass row or column and each tested event. |
| `mesh_exponent_loss`, line 114 | Real parameters, `0<=s<=1`, and each of three errors at most `mesh`. It proves `s*a-4*mesh<=s*(a+eLeft-eChild)-2*(eLeft+eRight)`. It does not require the errors or mesh to be nonnegative. Probability, nesting and logarithmic-loss premises are not encoded. |

Empty subsets are allowed when the lower mass bound is nonpositive.
For original mass `m>0`, choosing `delta=m/4` gives positive retained
mass at least `m/2`. Zero-reference or zero-mass indices cause no
existence problem. A conditional cap concerns **positive-mass fibres**:
`fiber_cap_from_core` explicitly requires positive row mass. Zero-mass
indices possibly included in the finite sets are not actual conditional
pins and can be omitted without changing the law.

## Decisive proof and fidelity checks

The potential
`p(I x J)-delta*mu(I)-delta*nu(J)` has a maximizer over the finite
rectangle choices. Deleting a deficient row or column would increase
it, giving both floors on the same rectangle. Comparison with the full
rectangle gives `m-2*delta`; nonnegative weights and threshold let its
mass dominate its potential. This is the argument encoded in
`two_sided_core`, including zero entries and zero reference weights.

The parent normalization sums the **original per-row** cap first. Its
numerator is at most `cap*parentWeight`, so the parent weight cancels
after division by `parentWeight*r*v`. The cap-transfer lemma similarly
uses the raw row floor: total core normalization cancels from each
within-fibre conditional probability.

The mesh inequality's exact nonnegative decomposition is
`(2-s)*(mesh-eLeft)+2*(mesh-eRight)+s*(mesh-eChild)`.
Its sum equals the difference of the displayed sides. Additional
`o(1)` losses and the nesting of physical tree atoms require separate
analytical arguments.

The prose's actual-product corollary is also correct. For a probability
matrix `g<=D*mu*nu`, the threshold `1/4` core has mass `M>=1/2`.
With its normalized actual marginals `alpha,beta`, the floors imply
`mu<=4*M*alpha`, `nu<=4*M*beta`; consequently
`q<=16*D*M*alpha*beta<=16*D*alpha*beta`.
Summing the original named-product comparison instead gives
`alpha<=(D/M)*mu`, `beta<=(D/M)*nu`. This corollary is a checked
elementary consequence, **not a separately encoded Lean declaration**.

Likewise, using the raw event law `1_E P`, original marginals as
references, and threshold `P(E)/4` supplies one core on which every
original event cap costs at most `4/P(E)` under both pins. The source
formalizes the existence and scalar division ingredients, not an
explicit probability-family theorem or an entropy-profile theorem.
The unchanged statement-fidelity document accurately separates these
applications from its encoded objects and hypotheses.

## Historical support, fresh compiler and finite computations

The v2 records are reused at their exact claim hash:
`lean-DB_FINITE_CORE-ae96dd262933` and
`judgement-DB_FINITE_CORE-b195a60f0949`. The old certificate's embedded
source and fidelity agree with the files. Its compiler and axiom-audit
exit codes are zero with `proof_holes=[]`. The old log, receipt,
`lean_check.json` and verify output describe that **one** 15,363 ms run;
they are not additional formal results. Their pending-fidelity prose
does not erase the later matching independent judgement.

A fresh compiler reproduction copied only the unchanged source and
reading to `replay/`; no old file or Argus runtime was modified.
The official `lean_evidence verify` ran with `--claim
DB_FINITE_CORE_REPLAY` and the explicit campaign `9200078` project root.
The durable task `old-draft-core-replay-9200078` completed with exit
zero; the compiler duration was **15,189 ms**, `proof_holes=[]`, and
the real axiom audit also exited zero. The new certificate is
`replay/certificates/DB_FINITE_CORE_REPLAY-a30a1307850c6b12.json`,
evidence `lean-DB_FINITE_CORE_REPLAY-595265683ec8`. It supports only
the reproduction claim, never `OLD_DRAFT_REVIEW`.

Both runs used Lean **4.31.0**, commit
`68218e876d2a38b1985b8590fff244a83c321783`; Lake
`5.0.0-src+68218e8`; elan `4.2.3`; and the installed workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
The fresh audit used the Argus-latest audit source. No new lakefile,
dependency fetch or workspace build was introduced. Compilation checks
the encoded declarations; its certificate still correctly says that
statement fidelity is not mechanically verified.

The existing `verify.py` was inspected in full before execution: it
reads its certificate, fixtures, ledger and manuscript anchors and
prints JSON; it does not write files or initiate an attack. It was
executed in place with the prescribed interpreter and `-B`. Output is
preserved in `replay/existing_verify_output.json`: **15 core cases,
128 conditional-cap checks, 192 rate updates, 81 mesh cases**, all
successful. It checks the *old* compiler record rather than compiling.
Its unchanged pending-review strings are historical labels, not fresh
negative judgements.

One bounded Jacobian operation was discovered, its exact contract
inspected, and its original six-atom payload replayed through the
mandated isolated adapter:
`probability.finite_distribution.condition.compute`. The preserved
contract, payload, typed output and execution record are separate
`replay/jacobian_condition_*.json` files. Server **0.14.0**, protocol
**2025-11-25**, adapter exit **0**, timeout **false**, structured error
**null**; the payload and typed mathematical output match the old
records. The event mass is `5/9`, with conditioned atom masses
`3/10,1/10,2/5,1/5`. This is an exact finite computation, not a
universal proof or an analytical limit.

## Supported scope and concrete exclusions

No unresolved step was identified in the four encoded finite
implications. Their hypotheses, zero-mass boundaries and elementary
applications are explicit above. The universal finite theorem is
supported by real compilation, not by extrapolating fixture counts.

There is **no** formal declaration for planar Taylor approximation,
the projection theorem, no-strip, homogeneous-profile extraction,
differentiation/integration, the asymmetric analytical theorem,
the one-label construction or Bochner-Riesz. Ren-Wang and the
application's upstream assumptions remain external to this source.
The current review's human fidelity and exhaustive-assessment claims
still require native independent review. Mathematical novelty was not
verified. These are scope boundaries, not compiler failures or
refutations of the excluded statements.
