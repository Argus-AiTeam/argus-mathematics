# Coherent integral family and formal evidence

## Construction, attribution, and quantifiers

This is old report Part (C), the diamond part of CITS-ALG, and the
construction part of CITS-STRUCTURAL. The exact matrices are in the
inventoried `exact_certificate.json`, retained unchanged in `replay/`.
It is an old Argus algebraic construction with unverified novelty,
not an elliptic-curve realization or source counterexample.

The nine Lean matrix identities hold for every p in every commutative
ring. The cohomology, rank and fractional-coordinate conclusions
require a DVR O and **nonzero** p in O. In the mixed-characteristic
2-adic setting one may specialize p=2^d for every d>=0. That wording
must not be extended to p=2^d=0 in an equal-characteristic-2 DVR.

The strict differential has rows `(0,0),(0,0),(0,-p),(p,0)`.
The relaxed differential is its concatenation with the certificate's
local boundary; the finite and singular complexes use the specified
two local columns each. The actual cycles are A=(0,1,p,0) and
B=(1,0,p,0), with localizations p*e1 and J*p*e1 for
J=diag(1,-1). The actual duality functionals are
lambda_F=(-1,0,0,0) and lambda_S=(0,-1,0,0).

## Decisive checks beyond generic ranks

The retained relative chain maps K1,K2 and inverses I1,I2 satisfy
both chain-map equations, K1*I1=1, K2*I2=1 and the two homotopy
equations with H. These are integral deformation-retraction identities,
not a rational inverse obtained by dividing by p.

The finite/singular pairing maps satisfy their signed chain equations
and restrict from these same relative maps. The retained local defect
is `V^t*U+U^t*V=Q`. Its pure-plane blocks are zero and its cross
block is Omega*J, not Omega; det(Q)=1. Thus the orientations and
the exact comparison maps, rather than only a generic nonzero form,
are part of the checked data.

Unimodular integral row and column transformations give

    D_F ~ diag(0,p,p,1);   D_S ~ diag(0,-p,p,-1).

Their determinants are +/-1 as polynomial expressions, so the changes
remain invertible on every specialization. The transformed pairing
vanishes on the contractible unit-disk block and has a unimodular
three-by-three block on the remainder. Consequently the plane
pairings are perfect **derived** dualities. Their termwise matrices
need not be invertible; rejecting them merely because those matrices
have determinant zero would be incorrect.

The strict complex has H1=0 and H2=O^2+(O/p)^2. In particular its
torsion is not deleted. The plane generic ranks are one. Recomputing
the complete adjugates verifies

    u_F*adj(D_F)=A*lambda_F;  u_S*adj(D_S)=B*lambda_S,
    u_F=-p^(-2);             u_S=p^(-2).

The inverse-determinant convention agrees with cancellation in the
displayed diagonal forms: the two nonunit disks contribute p^(-2).
The ratio is -1, a unit, for every nonzero p. At p=2^d the two
2-adic valuations are -2d; at d=0 the torsion vanishes as expected.
This is an all-parameter symbolic construction, not extrapolation
from a finite numerical sample.

## Exact replay and negative controls

`replay/replay_algebra.py` loads the unchanged copied `verify.py` and
calls its mathematical routines. Its `algebra_replay.json` reports
PASS for the universal polynomial identities, all chain maps and
homotopies, normal forms, derived plane pairings, actual functionals,
full adjugate equations, and four deliberate invalid-certificate
rejections. The rejected mutations are an extra factor 2 in the
singular functional, deletion of a strict torsion factor, wrong J,
and replacement of a determinant coordinate by a cohomology-only proxy.
These are checker controls, not new arithmetic counterexamples.

The original path-bound `main()` was not run and is not reported as
having passed. Its manuscript-label/report-string checks are not
mathematical fidelity checks, and its `check_lean()` binds absolute
old paths and old archives. The driver deliberately does not call
them; fresh compilation is a separate real run below. The old
checker itself only reads/prints, but it was still copied so no
execution occurred in the old workspace.

The standalone checker uses the existing SymPy 1.14.0 environment.
The first legacy-interpreter attempt failed at importing SymPy,
before any mathematical check; using the existing working environment
resolved that execution issue without changing the checker or shared
installations. Argus modules themselves were invoked with the required
`$WORKSPACE/argus-latest/.venv/bin/python`.

The retained Jacobian operation is
`matrix.normal_form.smith.certified.compute`, server 0.14.0, protocol
2025-11-25. `jacobian_payload.json` and `jacobian_result.json` preserve
the exact typed input/output. Historical adapter exit=0,
status=completed, structured_error=null; output exactness is
EXACT_INTEGER and completeness FULL_MATRIX_TRANSFORMATIONS.
The replay independently checks D=U*A*V, det(U)=det(V)=1 and
diagonal (1,8,8,0) for the p=8 finite matrix. This is reuse of
unchanged retained evidence, not a claimed fresh adapter invocation,
and not the proof for arbitrary p.

## Lean versions, fresh compilation, and fidelity

The index distinguishes all five archived certificates. CITS-ALG v1
compiled a reduced source omitting `optimal_natural_clearing` and
`coherent_diamond`. Full v2/v3 had stuck CommRing instances; v4
exhausted elaboration heartbeats; v5 compiled the full package with
the larger explicit heartbeat allowance. Those failures are execution
facts, not mathematical refutations. Submission/status files and the
compile log duplicate the corresponding runs, not independent results.

The unchanged full source and unchanged `statement_fidelity.md` were
materialized by the official verifier in the owned active `replay/lean/`
directory and compiled there. The durable run
`old-draft-004-lean-replay-1794068249752084051` finished exit 0.
`lean/lean_check.json` records compiler exit 0, axiom-audit exit 0,
proof_holes=[], and duration 60412 ms. Source hash
`fa26070bff1b29331d143ecd7e810dffa9e991c27541ffef898ecc4b28dd9002`
and fidelity hash
`1245235871980bf9299645ea1e75327d9a7b56e89abda08a4375e88936fdde22`
match the successful final historical certificate and preserved manifest.
The actual tools are Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake 5.0.0-src+68218e8,
and elan 4.2.3. The built Mathlib workspace is
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
No new Lake project or dependency build was created.

The axiom audit detects source-added axioms; success is not a claim
that Lean/Mathlib uses no ordinary foundational axioms. The source
explicitly uses classical choice for descent. No additional arithmetic
axiom or local proof hole is introduced by this file.

Manual statement-fidelity checking assigns all 15 theorem declarations
and 17 definitions in the index. In particular `coherent_diamond`
proves nine displayed matrix identities, **not** normal forms,
perfectness of the plane pairings after contraction, determinant
coordinates, the intrinsic general theorem or arithmetic realization.
Those are separate symbolic/prose arguments examined above and in
unit 06. The fidelity note states these limits correctly.

No new kernel status for the active review conclusions is claimed.
The active claims are human review assessments, not a retranscription
of CITS-ALG. This replay used the verifier without `--claim`; the
historical claim-bound mechanical certificate is preserved as such,
not relabelled as evidence for the entire review. The ledger writer's
fixed sibling lock would also be outside the stated active write
boundary; no such out-of-scope file was created.

**Recommendation: support this algebraic construction and its exact
formal/symbolic scope.** It does not establish any of the arithmetic
inputs in units 03-05, novelty, significance, or native independent
acceptance.
