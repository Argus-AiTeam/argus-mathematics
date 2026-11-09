# Exact cycle--clique Ramsey verification

The target is the main theorem in the staged manuscript, Section 1: for every
pair of integers `m >= n >= 3`, the cycle--clique Ramsey number is
`(m-1)(n-1)+1`, except at `(3,3)`, where it is six. This document describes
`Audit189.all_parameters`, `Audit189.integer_formula`,
`Audit189.complete_integer_verification`, and their semantic
bridges in `Main.lean`. A successful compilation is required separately; this
document does not assert that a compilation or independent review succeeded.

## Objects and exact correspondence

All graphs are `SimpleGraph`, hence undirected and loopless. `Forcing m n N`
quantifies over **every** simple graph on `Fin N`; there is no restriction
to the finite patterns enumerated in the manuscript. A graph is the red
edge set of a coloring of the complete graph, and its simple-graph complement
is the blue edge set.

`cycleNext i` is `(i+1) mod m`, with its bound proved from `i : Fin m`.
`HasExactCycle G m` requires an injective map `f : Fin m -> V` and all `m`
successive cycle edges, including the closing edge. Thus there are exactly
`m` distinct cycle vertices. No condition forbids chords: containment is
**not induced**. `cycle_copy_iff`, under `3 <= m`, proves equivalence to
Mathlib's `cycleGraph m` containment `SimpleGraph.IsContained`, whose witness
is an injective adjacency-preserving graph homomorphism, not an induced
embedding. `chorded_cycle_witness` explicitly exhibits a four-cycle in `K4`.

`HasIndependent G n` requires an injective map from `Fin n` whose images
have no internal edges. Quantifying also over equal indices adds no
restriction because the graph is loopless. `independent_copy_iff` proves
its equivalence to a copy of the complete graph on `Fin n` in `G`'s
complement, for every natural `n`. `forcing_iff` therefore relates the
independently stated coloring predicate to the upstream `RamseyProperty`,
for all `N` and all `n`, assuming only `3 <= m`.

`ramsey m n` is the natural infimum of all forcing orders.
`ramsey_eq_upstream` proves equality with the upstream definition by
equality of these sets. An infimum alone could be zero for an empty set;
`least_forcing_nat` does not assume nonemptiness silently. It derives
nonemptiness from the strictly positive proved value, then applies
`Nat.sInf_mem` and `Nat.sInf_le`. Its conclusion `LeastForcing` includes both
the forcing property at the proposed order and its failure at **every**
smaller natural order, not merely an upper bound or an equality of formal
symbols.

## Quantifiers and boundary

`answer m n` is six when `m = 3` and `n = 3`, and
`(m-1)*(n-1)+1` otherwise. `formula_nat` uses the actual upstream proofs
`main` and `exceptional`, not the comparator. `all_parameters` has the
unbounded quantifiers `forall m n : Nat`, with precisely `n <= m` and
`3 <= n`, and proves both least forcing and the numerical equality.
Natural subtraction is harmless on this domain.

`integer_formula` states the manuscript's integer quantifiers explicitly.
The conversion through `Int.toNat` is valid because the hypotheses imply
`3 <= n <= m`; its nonexceptional equation has its right-hand side in the
integers, not truncated arithmetic. `exceptional_least` separately proves
least forcing at six. `complete_integer_verification` combines the least-order
conclusion and the integer-valued conditional formula under precisely the
unbounded integer hypotheses `n <= m` and `3 <= n`, including `(3,3)`.
Supplemental Python exhaustion of graphs on at most
six vertices and the exact five-cycle independence check are boundary
checks only, not replacements for the all-parameter theorem.

## Dependency and provenance boundary

The imported implementation is
`OAI.Combinatorics.Ramsey.CycleClique.MainTheorem`, at public OpenAI/math
commit `4eaee87548250b2682affda7d05d947c05554bae`, together with
`RamseyNumbers`. This is the actual proof of `OAI.CycleClique.thm_main`.
The solution entry module `Main` also imports a second construction-based
proof; replaying that unused duplicate is not needed to check the
transitive proof of `thm_main`. The comparator's intentionally incomplete
proof is not imported.

The frozen implementation's 183-module source closure contains the
minimal-counterexample expansion, clique bound, small cases, optimal
path systems, large-clique terminal contradiction, finite-rule soundness,
pattern coverage, and kernel-checkable finite certificate proofs.
`FiniteRange.ramsey_upper` combines these before `main` proves the exact
value using the disjoint-clique lower construction. The supplied proof
certificates are reused; the search is not regenerated. A source scan is
only a preliminary guard. The decisive dependency test is compilation
of the entire selected closure and transitive axiom collection on the
upstream and bridge theorems. Separate axiom reports are also required for
`minimal_expanding_counterexample`, `counterexample_clique_bound`,
`reduced_small_impossible`, `reduced_large_impossible`,
`finite_range_verified`, `finite_verification`,
`reduced_counterexample_impossible`, `ramsey_upper`,
`ramsey_lower_counterexample`, and `exceptional`, all in
`OAI.CycleClique`. These connect the manuscript dependency graph to the
checked proof rather than treating a matching finite-case count as evidence
for the reductions.

Upstream's declared toolchain is Lean 4.34.1. The requested certificate
must instead be earned on this host's Lean 4.31.0 and prebuilt Mathlib;
compatibility is an obligation, not an assumption. The unmodified replay
failed on missing library interfaces, with its logs preserved. The
backward port prepends only `import compatibility.Main` to each frozen
upstream source, supplying separately proved library propositions;
the original sources and all mathematical statements are unchanged.
Permitted transitive
axioms are exactly `propext`, `Quot.sound`, and `Classical.choice`.
Neither a build failure nor an unavailable library refutes the mathematics.
The verifier obtains `LEAN_PATH` from the existing prebuilt Lake workspace
and adds the freshly compiled proof modules. It then invokes the absolute
Lean 4.31.0 binary with `--no-lake` for the official check, so the upstream
4.34.1 toolchain file cannot silently select a different compiler.

This work certifies a statement bridge and replays an existing proof; it
does not claim to have discovered the Ramsey formula or established a new
graph-theoretic result. The historical results discussed in the manuscript's
introduction are not assumed by this verification. Independent assessment
of this document's mathematical reading and of publishability/novelty
belongs to the Host-invoked Reviewer, not the compiler or the Engineer.

## Independent replay

From the campaign root, run
`$WORKSPACE/argus-live-update/.venv/bin/python verify.py`.
The default performs a fresh compilation of every selected upstream module,
replays the boundary checks, runs both claim-bound official Lean checks,
checks the printed transitive axiom sets, and regenerates
`exact_certificate.json` only if all required gates pass. It does not need
Git or a new Lake workspace. `--build` resumes an interrupted development
build using source-, compiler-, and dependency-bound artifacts; `--certify`
checks those artifacts before the official whole-statement compilation.
The installed `lean_evidence` CLI takes the source as a positional argument;
its `verify --claim` operation, not a handwritten verdict, records the kernel
evidence. The older `--source` spelling in the mission text is not supported
by the installed CLI.
