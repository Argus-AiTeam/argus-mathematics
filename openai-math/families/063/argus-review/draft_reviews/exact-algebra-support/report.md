# Exact algebra supporting the geometric draft

## Assessment and replay

**`CEXACT@1` is supported at its stated algebraic scope.** The original
read-only verifier returned
`{"certificate_kind":"exact_algebra_supporting_geometric_proof","exact_checks":9,"ok":true}`
with exit **0**, empty stderr, no timeout, and elapsed time **0.289100 s**.
The exact command, stdout, dependencies and side-effect assessment are in
[verifier_replay.json](verifier_replay.json).

The command used
`$WORKSPACE/argus-latest/.venv/bin/python -B`
on the original absolute `9000063/research/descendant_bound/verify.py`,
from the current campaign root. Python was **3.13.5**; the venv interpreter
resolved to `$WORKSPACE/miniconda3/bin/python3.13`. Imports were only
`copy`, `fractions`, `itertools`, `json`, `math`, `pathlib`, `re`, `sys`.
There were no third-party dependencies and no live Jacobian requirement for
this retained replay. The full script was read before execution: it reads
five JSON inputs, computes in memory and prints; it neither rewrites the
certificate nor calls external processes/network. Bytecode writes were
disabled. Size/mtime metadata of all fourteen old inputs was unchanged.

The old verifier and exact-certificate files match their preserved-snapshot
manifest entries. The retained typed payload/contract/output/status are
separate supporting files, not additional mathematical drafts.

## What the nine groups actually check

| Group | Actual scope | What does not follow from it |
|---|---|---|
| `jacobian_smith` | Exact integer \(UA V=D\), unimodularity, Smith factors \(1,2,12\), maximal-minor gcd 24, generic gcd 2, stack-degree arithmetic 48 | No construction of stack pushforward or proof of the geometric interpretation |
| `rooted_tree_twist` | Symbolic degree-coefficient identities on 874 increasing-labelled rooted trees with at most seven vertices | No universal family, descent, or proof from extrapolating finite shapes |
| `boundary_gap` | Exact formal identity after \(\delta=2+s,\ u=1+t,\ d=d_0+\delta u+r\): gap \(1+s+t+st+r\geq1\) for \(s,t,r\geq0\) | No proof that geometric strata satisfy the input dimension and degree inequalities |
| `coefficient_charts` | 60 exact rational tests, degrees 1-10, a specified coefficient family, three scales and two translations | Not all coefficient tuples or the global cotangent line bundle |
| `constant_root` | 16 two-attachment cases with both multiplicities 1-4 | Not all boundary trees or stability in families |
| `stabilizers` | Eight degree-\(k\) covers followed by the quadratic Veronese; active-weight gcd \(k\) | Not a general stack-isomorphism or automorphism-group proof |
| `weighted_degrees` | 1,554 ordered tuples of 1-4 weights, each 1-6, checking lattice indices and product inequalities | Not arbitrary weights/dimensions, Groebner flatness, or stack intersection theory |
| `projective_space_calibration` | 32 weight-product checks, \(N=1,\ldots,4\), \(b=1,\ldots,8\) | Not an independent Gromov--Witten calculation |
| `negative_tests` | Rejection of one corrupted transformation matrix and one operation error flag | Not exhaustive adversarial validation of all malformed certificates |

The boundary-polynomial calculation is an exact coefficient identity with a
universal implication on its stated nonnegative domain. It is not just a grid
search. The tree and other sampling groups remain bounded finite tests.
The prose proof, not either kind of calculation, supplies the quantified
geometric inputs.

For weights \((2,4,6)\), the actual matrix is
\[
 A=\begin{pmatrix}2&0&0&1\\0&4&0&2\\0&0&6&3\end{pmatrix}.
\]
The retained matrices satisfy \(D=UAV\), \(\det U=1\), \(\det V=-1\),
and \(D=\operatorname{diag}(1,2,12)\) with one zero column.
The coarse lattice degree is \(24\); multiplying by the target generic
stabilizer order \(2\) gives stack degree \(48\), hence weighted degree
\(1/48\) **under the geometric power-map/projection-formula interpretation**.
The factor 2 must not be dropped.

The projective-space identity
\(\langle\tau_{(N+1)b-2}(\mathrm{pt})\rangle_b^{\mathbb P^N}
=1/(b!)^{N+1}\) is derived in the old prose from the coefficient-stack
geometry. The script checks only the factorial weight product. It is not
an independently implemented invariant computation.

## One bounded live adapter replay

The role-required live use was restricted to the same 3 by 4 integer matrix,
not a new error search. Discovery returned five candidates; the
transformation-certified Smith operation was selected and its exact typed
input/output contract inspected before running it once:
`matrix.normal_form.smith.certified.compute`. Its bound is at most 16 by
16 integer entries encoded as canonical decimal strings. The adapter was
invoked only with
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`.

The complete records are `jacobian_find.json`, `jacobian_contract.json`,
`jacobian_payload.json`, `jacobian_output.json` and
`jacobian_replay_status.json`. Discovery, inspection and execution each
exited **0**. Server **0.14.0**, protocol **2025-11-25**,
`EXACT_INTEGER`, `FULL_MATRIX_TRANSFORMATIONS`, no structured error and no
timeout were returned. Execution took **3.198016 s**. The preserved checker
function locally rechecked the new transformations, payload identity and
server/contract consistency; it returned the same factors and degree
arithmetic. This was an additional replay of an old exact instance, not a
new mathematical result or an independent proof implementation.

## Attribution and status reconciliation

The transformations come from the retained Jacobian operation; the
standard-library verifier is the old Argus replay implementation associated
with `engineer:gpt-6.1-sol`. Smith theory, degree-product arithmetic and
these finite checks do not establish original research novelty. The old
claim has `novelty_status=not_established`; this review's own novelty is
`not_applicable`. No Lean source or Lean certificate occurs in this inventory.

The old ledger has one Engineer and one independent-reviewer supporting
judgment for `CEXACT`, both citing the same certificate. They are two opinions
about one artifact, not two computations or a kernel certificate.
Meanwhile the old proof graph still says `open` with
`reviewer_confirmed=false`, and the immutable exact-certificate metadata
still says `independent_review=pending`. These are three different record
systems: reading support, manual graph flags, and a frozen certificate
manifest. The verifier explicitly expects the historical `pending` field;
rewriting it would both alter an input and break replay. No old record was
changed to make those labels agree.

There is no remaining arithmetic discrepancy in the nine-group replay.
The construction/descent, cotangent identity, full stabilizers, all geometric
boundary estimates, virtual classes, rational pushforward, Groebner
degeneration and manuscript-wide arguments are **not certified by this unit**.
They must not be promoted from this finite/exact support to machine-verified
geometry. Final acceptance of the review remains with the Host Reviewer.
