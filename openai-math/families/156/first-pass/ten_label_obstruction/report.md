# The abstract ten-label obstruction

## Exact question and source

Let \(V=\{0,\ldots,9\}\), let \(F\subseteq\binom V4\), and define
\[
 T(F)=\{t\in\binom V3:\text{some }s\in F\text{ contains }t\}.
\]
The question is whether a nonempty \(F\) satisfies both:

1. For every \(t\in\binom V3\), the number of \(s\in F\) containing
   \(t\) is even.
2. For every \(s\in F\), put \(C=V\setminus s\). Exactly one of \(t\)
   and \(C\setminus t\) belongs to \(T(F)\), for every
   \(t\in\binom C3\); every pair in \(C\) lies in exactly two members
   of \(T(F)\cap\binom C3\).

Counting all triples in condition 1 is equivalent to counting only triangles
in the downward closure: the omitted triples have incidence zero. Purity
means only that the complex is the downward closure of its four-element
facets; it is built into this formulation, not an additional topological
assumption. Neither a complete one-skeleton nor a triangulation is assumed.

The staged source is OpenAI, *A nine-dimensional counterexample to Borsuk's
covering assertion*, September 23, 2026, directory
`research/openai_manuscript/A-nine-dimensional-counterexample-to-Borsuks-covering-assertion-September-23-2026/build/`.
The definition above is exactly `sections/six-labels.tex`,
Definition `def:six-system`, applied to facet complements as in
`sections/ten-labels.tex`, Lemma `lem:facet-complement`.
The finite argument is Lemmas `lem:two-tetrahedra`, `lem:short-links`,
`lem:partner-blocks`, and the proof of Theorem `thm:no-ten-labels`.

The intended conclusion is \(F=\varnothing\). This is a finite-core
verification, not verification of the existence, regularity, or degree
properties of an admissible map.

## Source findings and mathematical dependencies

The source's elementary six-label argument has four relevant consequences:
vertex links are five-cycles; a four-subset contains at least one but not all
four triangles; the links at two labels differ on every three-subset of the
other four labels; and restriction to five labels determines the system.
These are proof obligations here, not imported external theorems.

The manuscript then transports complementary systems across a shared
triangle. A third facet at that triangle would transport a system around a
loop inducing a transposition, which is forbidden. Triangle parity therefore
gives degree exactly two. A five-vertex path in an edge link similarly makes
two restricted links identical, so edge-link components have length three or
four. The partner map at one facet then gives invariant disjoint blocks.
All omission choices give facets; disjoint facets are forbidden by the
six-label condition. Every facet must consequently contain two vertices of
some block. Counting unused labels leaves exactly three blocks of sizes
three, two, two. A pair of unused labels belongs to two complementary
triangles, at least one involving a size-two block; that triangle can extend
to only one facet, contradicting degree two.

No external literature proposition is needed for this finite theorem. The
shared Wiki index has no matching six-label, ten-label, or Borsuk entry; its
unrelated inherited topics are not dependencies. No false literal manuscript
assertion has been identified in this scoped reading.

## Remaining continuum dependencies

For the projector-cover theorem, the reduction from a diameter cover to a
smooth admissible map, the equality-case facet-cycle theorem in
`sections/topology.tex`, and the derivation of the exact complement system
from an admissible map remain separate manuscript premises. A proof of the
finite statement cannot discharge them. In particular, finite computation
does not prove `thm:equality-complex`.

## Exact propositional certificate

The full model has 210 facet variables, 120 triangle variables, and 240 parity
auxiliaries. The 32,761 clauses are generated from the definitions, without
symmetry breaking, sampled complexes, or a facet-count bound:

- One clause asserts that at least one of the 210 possible facets is present.
- For each of the 120 triples, eight clauses assert that its triangle variable
  is equivalent to the disjunction of its seven containing facets.
- For each triple, two auxiliaries are the XORs of the first three and next
  three incident facet bits. Eight clauses define each auxiliary; four more
  make the XOR of those auxiliaries and the seventh facet bit false.
- For each possible facet, 140 clauses, guarded by its negation, assert the
  six-system on its complement. Twenty enforce complementary exclusivity
  and exhaustiveness. For each of fifteen pairs, the four possible containing
  triangles have exactly two true bits: all three-subsets have at least one
  true bit and at least one false bit.

Thus a family satisfying the question extends to a satisfying assignment:
set triangle variables to its downward closure and the auxiliaries to the
specified XORs. Conversely, every satisfying assignment restricts to exactly
such a nonempty family. The encoding covers the entire ten-label model.

`refutation.drat` was produced by Glucose 4 through PySAT, with a 200,000
conflict budget. The successful run used 3,970 conflicts. The solver's UNSAT
answer is not used as a proof. `verify.py --replay` regenerates the original
clauses and checks each of 3,970 proof additions by reverse unit propagation;
the last contradiction is a derived empty clause. It ignores 4,388 deletion
instructions, which is sound: retaining clauses already proved to follow
from the original formula cannot invalidate the implication induction.

The checker uses only Python's standard library. To justify its proof rule,
negate every literal of a proposed added clause and propagate unit clauses.
A contradiction proves that the previous formula implies the new clause.
Induction over additions proves that every retained clause follows from the
original formula. A derived empty clause therefore proves that the original
formula has no satisfying assignment.

The bounded Jacobian operation concerns the local six-label definition, not
the ten-label conclusion. Its 20-variable, 140-clause instance returned SAT.
The first request was rejected for noncanonical clause order; that structured
error is retained and has no mathematical verdict. The corrected request was
canonicalized through the inspected operation, with its exact named clause
set preserved, before submission.

## Kernel certification and its second encoding

The formal encoding eliminates the XOR auxiliaries and forbids each of the
64 odd assignments at every seven-facet triangle incidence. It keeps both
orders of complementary-triple tests, so no clause-canonicalization theorem
is needed. It has 330 variables and 42,241 clauses:
1 nonempty clause, 960 downward-closure clauses, 7,680 parity clauses,
8,400 complementary-triple clauses, and 25,200 pair-incidence clauses.
There is still no symmetry breaking, family-size cutoff, or topological
premise.

The corresponding solver proof has 5,299 RUP additions, all replayed during
generation. The ordered unit-propagation hints give an LRAT proof. Removing
additions outside the dependency closure of the final empty clause and
renumbering all references leaves 4,939 additions and 551,738 hints.
`formal.py --replay` checks this proof using a direct, hint-guided
unit-propagation implementation, independent of the watched-literal checker
for the original certificate. It also checks 555 primitive Boolean
assignments. A deliberately invalid empty-clause certificate is rejected.
Both replay implementations use only the standard library.

Slicing each propagation trace backward from its actual conflict removes
irrelevant assignments as well as irrelevant learned clauses. The resulting
`core_refutation.lrat` uses 19,189 of the original 42,241 input clauses,
4,695 additions, and 113,449 hints. The direct checker replays this entire
renumbered certificate against exactly the selection in `core_indices.json`.
This is a proof compression, not a restriction on the families being ruled
out: omitting input clauses weakens the formula.
`formal.py --slice-core` deterministically regenerates this selection and
certificate; `formal.py --replay-core` checks it without a solver.

`Main.lean` represents an arbitrary family and triangle indicator by an
arbitrary assignment `Nat -> Bool`: positions 0 through 209 are facets;
positions 210 through 329 are triangles. Exhaustive mask lists and three
table-completeness theorems bind every incidence row to actual subset
operations. Shape and index theorems exclude missing rows, out-of-range
indices, and malformed-row shortcuts.

The five gate kinds express nonemptiness, exact downward closure, even
triangle incidence, guarded complementary exclusivity, and guarded
pair-incidence two. `encode_correct` proves each encoding generically.
`disj_correct` translates Boolean clause evaluation into a literal
disjunction. Each selected input clause is derived from its actual gate,
with kernel-checked membership in the gate's encoding.

The current backend reconstructs individual logical proofs instead of
evaluating a large checker state. `Inputs` is a balanced conjunction of the
19,189 selected clauses, and `model_entails_inputs` proves that every model
assignment satisfies it. Each `input_*` theorem projects one conjunct.
Generic `unit_*` and `conflict_*` lemmas perform ordinary disjunction
elimination. The 4,695 `step_*` declarations use only these lemmas, Boolean
incompatibility, earlier clauses, and classical contradiction.
`core_unsat` derives the final empty disjunction for every assignment.
Composing it with `model_entails_inputs` proves the finite obstruction.
Neither clause-selection transport nor proof-step soundness is assumed.
`statement_fidelity.md` specifies the exact objects and quantifiers.

Earlier whole-model unfolding and definitional-equality attempts exhausted
budgets, including an official 600-second timeout. A pure table reduction
was interrupted after 192.6 seconds without a verdict. A native-evaluation
prototype introduced auxiliary result axioms and was not accepted as formal
certification. A hash-free bridge to Std's checker compiled without new
axioms, but the version-3
official claim-bound run timed out after 1,808.659 seconds at its 1,800-second
compiler limit: compiler exit -9, with no environment-axiom audit run. This is
an inconclusive record, not a verification. Both campaign-local structural
checks subsequently passed against the actual campaign root.

A subsequent proof-producing `cbv` prefix diagnostic also timed out at
600 seconds. The selected route now uses direct proof-term reconstruction.
A real Lean 4.31 microtest checked transport for all five gate kinds and
multiple reconstructed propagation steps, with only the usual foundational
axioms. Version 4 of the complete source also timed out at the 1,800-second
compiler limit (1,808.205 seconds recorded, compiler exit -9, no audit).
That is another inconclusive record.

An instrumented prefix containing all 6,784 used gate theorems compiled in
129.9 seconds. After replacing membership searches by indexed proofs, the
entire selected-input transport and all 19,189 clause projections compiled
in 355.6 seconds (8,175,704 KB peak memory). Physical timings in
`input_elaboration_timings.csv` separate 122.9 seconds before input blocks,
125.9 seconds constructing the blocks, and 100.2 seconds projecting them.
The transport used only `propext` and `Quot.sound`; the last projection
used no axioms. This verifies the actual input prefix, not the refutation.
Expanded microtests also cover final row indices, nonzero encoded-clause
positions, a multiblock input tree, and explicit proposition arguments.

Version 5 uses typed `let` proof terms and explicit proposition arguments
for every propagation rule, avoiding their previous implicit inference.
Its official claim-bound Lean 4.31.0 compilation and environment-axiom audit
both succeeded: compiler exit 0, audit exit 0, and `proof_holes=[]`.
The combined recorded duration was 2,414.361 seconds; the enclosing durable
run completed in 2,425.6 seconds. Both principal declarations depend only on
`propext`, `Classical.choice`, and `Quot.sound`.
The immutable evidence is
`certificates/C9000156_COMB-3e41b9605d2fdf73.json`, recorded on claim version 5
as `lean-C9000156_COMB-1b1a02aa986e`.
The source SHA-256 is
`6993bfc5530ba13dc49b2883138cffa3803ecb22e22dbf7b3789e56d1f9dd6f7`;
the fidelity-document SHA-256 is
`0f6fbb23651e5078ba1a6a6d39a59c826681b598426a96759bf79ce6c7202b38`.
Neither file changed during verification.

The complete default `verify.py` subsequently passed with exit 0 in
8.7 seconds. This checks the actual Lean result and both hashes, regenerates
the complete source, and replays the original full proof, the auxiliary-free
full proof, and the compressed core. Thus the finite theorem now has a
successful kernel certificate, not merely a solver answer or prefix test.

Compared with the staged proof, this route replaces reliance on the
transport, short-link, and partner-block deductions by a complete
propositional certificate. Those structural assertions remain separate
ledger claims; they are not prerequisites of the exact-CNF proof route.
The mathematical hypotheses and the ten-label universe are unchanged.

Independent Reviewer replay and statement-fidelity review remain required
through the normal Host-invoked path. No acceptance, publishability, or novelty
verdict is asserted by the Engineer. The abstract obstruction is already
argued in the staged manuscript; the completed Engineer contribution is an
independently replayable exact certificate and faithful kernel formalization,
not a claim to have newly discovered the underlying combinatorial observation.

## Reproduction and review boundary

From the campaign root, run:

```sh
python3 research/ten_label_obstruction/verify.py
```

The default verifier uses only the standard library. It regenerates both
complete encodings, replays both proofs and the compressed core, checks all
local six-systems and primitive encoding truth tables, checks the Jacobian
source bindings, and
requires a genuine successful Lean record whose source and fidelity hashes
still match. It does not substitute a bare solver verdict for a proof.
`--replay` replays the propositional proof alone. `--search` is an optional
proof-regeneration command using the already installed PySAT package; replay
does not require that package.

A fresh formal replay uses the official command:

```sh
LEAN_NUM_THREADS=1 $WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/ten_label_obstruction/Main.lean \
  --statement-fidelity research/ten_label_obstruction/statement_fidelity.md \
  --claim C9000156_COMB --project-root . --timeout 3600 \
  --lean-bin $WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean \
  --no-lake
```

The source imports only the installed Lean/Std environment; `--no-lake`
therefore avoids an unnecessary shared Mathlib workspace invocation.

Independent review must judge the finite theorem, its encoding fidelity,
and the explicit clause and proof-step transports. It must not infer the remaining
continuum premises from this certificate.
