# Integer-order obstruction: Engineer evidence replay

**Unit:** `integer_order`. **Assessment:** the elementary assertion is correct;
the final formalization is supported, not a geometric descent proof.
**Novelty:** not applicable to this review. **Final acceptance:** native
independent Reviewer pending.

## Assertion, versions, and decisive argument

Old `C_DES_INTEGER_ORDER` versions 1, 2, and 3 have the same natural assertion:
for every natural `e >= 2` and integer `m`, `e*m != 1`; consequently, for
any monoid `A`, arbitrary `order : A -> Int`, and `z,t : A`, the hypotheses
`order(z^e) = (e:Int)*order(z)` and `order(t)=1` imply `z^e != t`.
There is no commutativity, valuation, field, or geometric hypothesis hidden
in the formal statement. The two conclusions in the final source are
propositional `Not`.

The proof is complete within that scope: `e*m=1` precludes `m<=0`, since
`e>=0`. Thus `m>=1`, so `e*m>=e>=2`, a contradiction. An equality `z^e=t`
and the two explicit order hypotheses would give `e*order(z)=1`.
This is known elementary arithmetic reproduced by the old Argus Engineer,
using Mathlib, not a new contribution or a theorem attributable here to
the reference manuscript.

- **v1:** natural assertion only; no formal source.
- **v2:** uses ASCII Boolean `!=`. The exact v2 source hashes to
  `a278637b50bced07f088d8de4549bdcb66f31cfada35eaccbd87cf52f9dd993b`,
  matching `initial_lean_check.json`. That genuine run exits 1: the integer
  goal is a Boolean equality to `true`, and the generic monoid comparison
  additionally requires an absent `BEq A`. Its `introN` failures and printed
  `sorryAx` do not disprove the intended mathematical assertion.
  Initial fidelity hash:
  `f9b8a305ab6057ae4777ec38fca8296593856b1eb6e2acf5ad95e04c3e0ea4ae`.
- **v3:** replaces those conclusions with `Not`. Claim content hash
  `2095267ee6d520e88e9cda56c5d0fe28fd5d93d00e704658544400319485b9c2`
  is the subject of both the old mechanical evidence and old independent
  judgment. The failed v2 source and fidelity hashes are both different.

## Old bindings and judgment reconciliation

Final source SHA-256:
`da7fec26e42591955da7e86c0505b0a10ea81864ba8aec3a1651ede0cbec040a`.
Final old fidelity SHA-256:
`4a3498242c13fd41fe833afa888340541cf90a3eb2bad00049f15412a17d9c55`.
The archived certificate `C_DES_INTEGER_ORDER-271cf98b692e2cbf.json`
contains those exact texts; its `lean_check` equals `lean_check.json`,
and `lean_verify_output.json` differs only by its kernel-recording wrapper.
These preserved-manifest bindings are distinct from a mere filename link.

`lean_submit.json` is a receipt, not another proof. The actual supplied
1398-byte `compile.log` records successful compilation and axiom audit,
not an import/workspace failure; the index's description of that log is
overbroad. All assigned compiler artifacts were read. Bindings and version
comparisons are in `old_artifact_bindings.json` and
`old_certificate_relations.json`; only old report sections 8–9 were
substantively read here.

Old independent judgment `judgement-C_DES_INTEGER_ORDER-6defe1c7950a`,
by `reviewer:copilot-cb07e28d5d45`, supports the same v3 subject and cites
the same archive as `lean-C_DES_INTEGER_ORDER-95270558e0f0`.
The graph's `open`/`reviewer_confirmed=false` and the certificate's
`pending` labels are stale, not grounds to discard that matching judgment.
The judgment binds a subject hash and artifact path, not an artifact digest;
preserved-manifest byte identity supplies a separate historical binding.
It is old review evidence, not current native acceptance.

## Fresh reproduction and actual environment

Current `CTX_REPLAY_INTEGER` and natural `C_REPLAY_INTEGER@1` were officially
recorded before creating the exact-copy `Main.lean`. Official revision 2
then attached its source, with content hash
`876f1490e78e155faab6b022f1035baab812b2180acec724bd578bd3c202a0dd`.
The final official verification exited **0**, compiled in **9.435 seconds**
(whole invocation 9.568 seconds), and recorded
`lean-C_REPLAY_INTEGER-75de5ffe3785` in the current root ledger.
Its archive is
`certificates/C_REPLAY_INTEGER-2a2b4bd4951a2bd8.json`.
Compiler and axiom audit both exit 0; there are no proof holes or
environment failures. Source and fidelity were unchanged during each run.
Final current fidelity hash:
`3864c97f3ce7e9b612900aa438ca98aeb49a2cdaadc756567030b1444ff8baa4`.

The initial current attempt also compiled and audited successfully, but
the official name gate rejected only namespace-qualified declaration names
in the note. Its wrapper exit 1 is retained in `lean_verify_run.json`.
Before the final run, the note was corrected to additionally name the two
unqualified declarations; no mathematics or source changed.
`lean_verify_run_final.json` retains the successful command and transcript.
The final source/note have not subsequently been edited.

Actual compiler command: `$WORKSPACE/.elan/bin/lake env lean` followed
by the absolute current source path; compiler cwd:
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
Lean is **4.31.0**, commit
`68218e876d2a38b1985b8590fff244a83c321783`, x86_64 Linux Release;
Lake **5.0.0-src+68218e8**; elan **4.2.3**, commit `b6cec7e10`.
The assigned workspace's non-`.git` manifest pins Mathlib to
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`; the package's
`lean-toolchain` is `leanprover/lean4:v4.31.0`.
`toolchain_provenance.json` preserves metadata and source/olean hashes.
This identifies current declared provenance, not authenticated historical
Mathlib checkout identity from the old certificate alone.
No lakefile was written and no dependency was installed.

Both declarations depend on `propext`, `Classical.choice`, and `Quot.sound`,
with no `sorryAx` or user-declared axioms. The verifier used a 30-second
timeout per compiler/audit phase. No durable job or unreclaimed receipt exists.

## Supported scope and remaining obligation

Only `C_REPLAY_INTEGER` earned fresh mechanical evidence. The old archive
is reading material, never mechanical evidence for `C_REVIEW_F062`.
Hashing the fidelity note does not prove its interpretation.
Constructing the monoid of germs, its integer order, the power equality,
and especially the order-one target requires independent geometric work;
none is supplied by these declarations. The graph's additional use of this
sublemma under `C_DES_UNRAMIFIED` must not erase the other geometric
dependencies. No arithmetic gap remains, but current native independent
review and the separately assigned geometric assessment remain required.

After the final current ledger write, both official checks ran with the
legacy Argus interpreter and explicit project root
`campaigns/9200062`:
`math_state check` exited 0 (`issues=[]`), and `proof_graph_check check`
exited 0 (`proof graph valid: 6 node(s)`). Both commands and outputs are in
the tool record; structural validity is not review acceptance.
