# Lean/Mathlib 4.31.0 compatibility port

## Provenance and scope

See `ATTRIBUTION.md`, `source_manifest.json`, and `upstream/LICENSE`.
The pinned upstream toolchain is `leanprover/lean4:v4.34.1`; this port is
compiled with the existing host Lean/Mathlib 4.31.0 workspace. The 67 OAI source
modules are exactly the recursive import closure of `TreeProducer.lean`.
`upstream/lean/` contains the unmodified retrieved sources, not certified 4.31.0
builds. Only the local `OAI/` copies are used as producer modules.

Compatibility changes restore older equivalent names:

* `Mathlib.Basic.Real.Basic` → `Mathlib.Data.Real.Basic`;
* `Set.ofPred_and`, `Set.ofPred_forall` → `Set.setOf_and`,
  `Set.setOf_forall`;
* `mem_ofPred_eq` → `mem_setOf_eq`;
* `ite_eq_left`, `ite_eq_right` → `if_pos`, `if_neg`;
* `dite_eq_left`, `dite_eq_right` → `dif_pos`, `dif_neg`.

The exact local diff is regenerated as `build/port_changes.diff`. No normalized
data field, tree output field, mathematical definition, or theorem statement is
weakened. The build independently requires that the non-import, non-comment
contents of `Basic`, `OrderedTree`, `WeightedTree`, `TreeEvaluation`,
`SwitchingTreeData`, and `TreeProducer` equal their pinned upstream originals.

`Producer.lean` adds two convenience theorems:
`SwitchingTreeData.terminalDefect_tendsto`, obtained by twice applying the proved
finite-sum convergence theorem to the actual generated node maps, and
`TreeEvaluation.pathDisplacement_eq_sum`, an induction converting the recursive
proper-ancestor displacement to an indexed finite sum. Neither adds any
analytic or combinatorial assumption.

## Dependency and signature inspection

The closure contains neither `Main`, `Reduction`, `NormalizedContradiction`,
nor `BranchContradiction`, nor any final fixed-point or switching-contradiction
module. `Model` only **defines** `HasNonexpansiveFixedPointProperty`; no theorem
of that property is an input.

The producer argument remains the original one:

1. Construct resolvents by the ordinary Banach **contraction** theorem on the
   original norm subtype. Prove generation and quantitative displacements.
2. Obtain an idempotent from the compact semigroup of actual resolvent tail
   maps, using simultaneous finite norm approximations rather than weak
   continuity of nonlinear maps. Derive the anchor and its tail-set
   closed-convex-hull property.
3. Prove the diameter lemma from minimality and weak compactness; construct
   compact prediction families and Hahn–Banach detectors.
4. Prove a pre-map threshold and actual legal transition for every completed
   finite candidate history. Adaptive selection and positive-support
   extraction produce each finite extension; discarded candidates remain in
   the history.
5. Natural-number recursion constructs all stages. Extract the infinite
   ordered weighted tree, injective global labels, ancestor displacement,
   tolerances, actual evaluated prediction limits, and detectors.
6. `exists_switchingTreeData` chooses the **proved** anchor and an ultrafilter
   above the ordinary tail filter, then invokes the actual constructor.

The five explicit `False.elim` occurrences are confined to
`GlobalCandidateOrdinals` (two unequal-level branches of injectivity) and
`OrderedGroupConcat` (two unequal-parent branches of injectivity and one
impossible parent-order branch of strict monotonicity). They do not derive
`False` from normalized data or manufacture an anchor, a selection, a detector,
or an infinite tree. Other local contradiction proofs are ordinary proofs of
inequalities or closure membership, not a final switching contradiction.

`build/dependency_inspection.json` records the actual local import graph,
unmodified critical declarations, and explicit false eliminations.
`build/logs/Producer.log` contains real compiler `#check`/`#print` signatures
and `#print axioms` results for both principal producer declarations.

## Rebuilding

No lakefile, installation change, network access, third-party Python package,
or upstream compiled artifact is required for a rebuild. `build.py` uses only
Python's standard library and the existing host `lake env lean`. It compiles
every OAI module in dependency order, then compiles `Producer.lean`, and stops
immediately and nonzero on any compiler or inspection failure.

For a complete rebuild, run `build.py` **without** `--resume`. `--resume`
is an incremental porting aid with compiler/source/dependency fingerprints.
The compiler version, measured elapsed time, every source/object hash, principal
axioms, and success/failure status are written to `build/result.json`.
All module outputs and logs stay under this producer directory.

Commands expected to exceed two minutes must be submitted to the operator's
durable runner. From the campaign root, first enter the assigned subtree:

```sh
cd research/tree_construction/producer
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.tools.subagent submit \
  --task-id tree-producer-rebuild \
  --mode direct --timeout 7200 \
  --cwd "$PWD" \
  --command '$WORKSPACE/argus-live-update/.venv/bin/python build.py' \
  --run-dir "$PWD/run/rebuild"
```

The producer working directory also confines the runner's automatic local
bookkeeping to this subtree. Retain the returned durable receipt. Use the
receipt's `check_with` command from that same producer working directory.

## Importing from another source root

The top-level import is `import Producer`. Its modules are in
`research/tree_construction/producer/build/lib/lean`; prepend that absolute
directory to the existing `LEAN_PATH`, **retaining** host Mathlib and any local
bridge-module paths. For example, from the host Mathlib workspace:

```sh
BASE="$(lake env printenv LEAN_PATH)"
LEAN_PATH="$PRODUCER/build/lib/lean:$LOCAL_BRIDGE_OLEANS:$BASE" \
  lake env lean --root="$MAIN_SOURCE_ROOT" \
  -o "$ASSIGNED_OUTPUT/Main.olean" "$MAIN_SOURCE_ROOT/Main.lean"
```

This library performs no claim-bound `lean_evidence` certification. It makes no
novelty, publishability, or original-norm transport claim.
