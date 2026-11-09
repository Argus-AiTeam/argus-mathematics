# Exact realization of the capped one-tape epoch construction

## Result and scope

We prove the source-derived total raw local-visit construction realizes a
supplied-cap deterministic one-tape evolution, including speculative raw
controllers. Local replay characterizes the unique complete raw transcript;
this yields the semantic sum-product identity of the actual epoch graph.
The graph then instantiates the independently reviewed arithmetic evaluator.
An actual offset-averaging and padding argument identifies its final
controller slice with the capped machine outcome.

The evidence is `Main.lean`, the paired `statement_fidelity.md`, and the
claim-bound compiler certificate referenced by `exact_certificate.json`.
`verify.py` replays the source bindings and deterministic diagnostics and can
obtain a fresh official Lean 4.31.0 certificate. This is a semantic and
explicit resource-model verification theorem. It is not a compiled
Turing-machine theorem and does not by itself establish publishability or a
new complexity-class inclusion.

The official run archived
`certificates/certificates/C137_REALIZATION-7bf8bb22564d2f07.json`
with compiler exit zero, axiom-audit exit zero, and `proof_holes=[]`.
The verifier's source and fidelity snapshots under `certificates/`
match the original files by hash. Both campaign-local checks also exited
zero against this campaign root. These facts do not supply independent
statement-fidelity or publication approval.

No false assertion was identified in the examined manuscript conventions.
In particular, its speculative-controller acceptance rule, raw equality,
epoch-start replay, and departure-step ownership already contain the
conditions used below. There is therefore no manuscript-refutation claim
or counterexample certificate in this result.

The strongest preceding campaign result was `C137_WEIGHTED` version 4:
correct arithmetic register scheduling and its weighted model charge,
conditional on appropriate semantic word rules and on a uniform bit
implementation for a bit-space interpretation. The present improvement is
the concrete realization of those semantic rules and their relation to
capped machine output, not another proof of the register schedule.

## 1. Total local visits without reachability assumptions

Let a controller contain finite control, time `tau`, head positions
`q_0,...,q_rho`, and a terminal flag. Accept it only when its raw encoding is
canonical, `0 <= tau <= T`, and `|q_h| <= tau` for every head. Every other
raw string selects the origin block and produces the fixed zero-time,
zero-position terminal dummy, leaving the incoming block unchanged.
Accepted terminal controllers preserve both raw arguments.

Partition the tape into blocks
`[a+v*b, a+(v+1)*b-1]`, using signed floor division. Each transition reads
and writes the incoming writable position, then moves and updates time.
If the writable head leaves the selected block, stop WITHOUT reading the
destination. A halted state is recognized before timeout; reaching a
halting state on the cap transition is therefore halting, not timeout.

After `s` active transitions from any accepted speculative controller,

`|q_h(s)| <= |q_h(0)| + s <= tau+s <= T`.

This needs no assertion that the controller is reachable from the real
initial state. It proves that all input accessor calls remain in the
original radius-`T` domain. Invalid symbol codes are decoded only when
accessed; unused raw entries are not normalized. The source proofs include
exact whole-tape agreement and exterior-entry preservation.

Controller canonicality and safe-output re-decoding are distinct laws.
The first identifies an accepted raw encoding with its encoded decoded
controller; the second permits iteration after a produced safe controller.
Both are explicit in the formal interface. The symbol roundtrip law is
explicit in the separate bridge to ordinary symbol-tape semantics.

## 2. Raw replay is an exact deterministic characterization

Write `V(z,B)=(z',B')` for any total local visit and `s(z)` for its selected
block. Starting from arbitrary raw `z` and block family `A`, serial visits
give a reference transcript `z_1,...,z_m`.

Each block replays the proposed sequence using the PROPOSED incoming
controller to select ownership. It compares every owned outgoing raw
controller bit-for-bit with the proposal and continues scanning even if an
earlier comparison failed. By induction on proposal length:

1. If all flags pass, the selected block forces the first proposal to be
   the serial visit's actual output. The updated block families agree, so
   the induction hypothesis applies to the remaining proposal.
2. The reference transcript passes, and every replay buffer equals its
   serial counterpart.

Thus all flags pass exactly for the unique raw transcript of that length.
Malformed controllers and blocks cause no exception: the visit is total.
Decoded-state equality would NOT establish this statement; the proof uses
literal raw controller equality.

For a round after a correct prefix, replay the prefix together with the
candidate suffix from the epoch-start blocks. The same theorem gives a
unique suffix of length `k`. Replacing those blocks with round-start
blocks would execute the prefix twice; the construction does not do that.

## 3. Factored semantic history and the actual graph

Let `b=k^2`. Pad an epoch's initial controller followed by its first `j*k`
outgoing raw controllers into a `d`-bit word. Pad each raw block into the
same width, with

`d >= max(1, b*ellSigma, (b+1)*c)`.

The guess space consists of ALL `2^(k*c)` raw suffixes. The raw replay
theorem makes precisely one candidate pass every block predicate.
Multiplying the Boolean flags therefore selects exactly that candidate
in any field; the output sum is the next padded semantic history word.
The augmentation coordinate is also included and equals one.

This identity is proved only at reference Boolean histories and
epoch-start arrays. No off-Boolean identity and no identity for arbitrary
malformed prefixes is needed. The total Boolean kernels on such inputs
are subsequently extended algebraically by the accepted evaluator.

The formal `epochRules` builds base arrays, history rounds, next-epoch
block checkpoints, and controller-extraction nodes. It proves every rule's
reference value and every dependency's membership in the reviewed epoch
edge relation. Checkpoint replay again uses epoch-start arrays. Raw-bit
packing and the increasing finite relabeling of represented physical
blocks are proved to commute with reference execution, rather than
assumed as an additional simulation oracle.

## 4. Actual offset averaging and completion

A right unit move crosses the shifted partition only for
`a = q_new mod b`; a left unit move uses `a = q_old mod b`. These are the
same formula `a = max(q_old,q_new) mod b`. A stationary move crosses none.
The proof uses integer floor division and nonnegative residues, so
negative tape coordinates do not change the orientation.

All offset trials refer to the SAME whole-tape capped computation.
Summing its crossing counts over offsets charges at most one per actual
transition. Hence some offset has at most `floor(T/b)` crossings.

A conditional statement that counted crossings imply completion would
not finish this argument. Instead we prove directly that every
nonterminal local visit spends at least one crossing of the remaining
capped execution, and that a local visit preserves that execution's full
remaining outcome. Induction on the visit budget then shows completion
whenever that budget exceeds the remaining crossing count. In particular,

`R = 1 + ceil(T/b)`

visits suffice for the good offset, and their outcome equals the complete
capped run. Terminal visits are absorbing. Since
`E = ceil(R/b)` satisfies `E*b >= R`, padding to complete epochs preserves
this outcome. Other offsets may finish too; any completed genuine
initial-state trial has the same capped outcome.

The finite initial array contains exactly the blocks meeting `[-T,T]`.
Cells outside the interval, including exterior coordinates in boundary
blocks, use canonical filler. Replacing the exterior of an initial tape by
that filler cannot change a capped controller outcome: the proof preserves
agreement of all tape cells within the accessible radius at every step.
This closes the initialization-to-final-controller connection in
`capped_epoch_output_correct`.

## 5. Composition with the reviewed evaluator

The unchanged imported evaluator, with its finite-field stencils and
three register slots, is called on the actual rules just constructed.
For every scalar and every arbitrary entry pool, the result translates
only the selected target by that scalar times the augmented semantic
word and restores all other slots. The proved charge is

`(5*(d+1) + E*(k+k*c+2))*unitBits`.

For `k,c >= 1` and `T <= k^5`, it is at most

`(5*(d+1) + 4*k^2*(c+1))*unitBits`.

Taking the source's `k=ceil(T^(1/5))`, fixed finite alphabets and head
count, and `c=O(log T)` gives the intended two-fifths scale in this model.
Interpreting the charge as actual work bits still requires the uniform
bit-cost obligations below. The proof does not allocate the semantic
tape or the entire reference array as a work-space object. Their role is
to specify the values evaluated by the charged recursive program.

The final semantic epoch word contains the encoded capped controller
for at least one offset, and a completed trial preserves that controller
under further padding. Initializing a target register to zero and
translating by scalar one yields that augmented word. Only its finite
control and halt/timeout fields are the manuscript's requested output;
there is no claim to materialize the final tape within this space.

## 6. What remains unproved at the implementation level

The formal theorem quantifies over codec interfaces and interpolation
stencils. It proves the simulation, replay, history, and navigation
semantics; it does not compile their bit implementation. The remaining
boundary includes:

- Fixed finite-control and symbol encoding layouts, their size estimates,
  and their uniform bit implementation.
- Radius-bounded initial/input access at the manuscript's stated bit cost.
- A low-space binary enumerator for suffixes, instruction generation for
  Boolean lookup extensions, and the arithmetic/field operations.
- Concrete graph address arithmetic, navigation instruction generation,
  and the interpretation of `unitBits` as sufficient local bit storage.

The finite candidate equivalence in Lean is not an efficient enumerator
by fiat. The arbitrary functions specifying a machine, its encodings,
and its initial data are not an extracted bit machine. The ledger keeps
this boundary separate from the now-proved semantic simulation kernels.
No accepted evaluator source, certificate, or claim is modified.

## 7. Adversarial finite diagnostics and Jacobian

`verify.py` separately exercises rejected and accepted speculative
controllers, terminal/cap/halting priorities, invalid symbol codes,
negative offsets and positions, departure ownership, exterior
preservation, raw transcript mismatch, complete suffix selection, and
actual capped offset trials. The diagnostics are FINITE experiments,
not the universal proof. Their exact counts are in `diagnostics.json`.

The Jacobian adapter's bounded operation
`integer.counting.floor_sum.compute` was discovered and its typed
contract inspected before invocation. Payload
`{"n":7,"m":7,"a":1,"b":24}` returned `{"value":"24"}` with adapter exit
zero and no timeout. The dedicated payload, output, and status JSONs
preserve server version `0.14.0` and protocol `2025-11-25`. This is only
an arithmetic cross-check, not evidence for a simulation or a
universally quantified averaging theorem.

## 8. Comparison with the strongest relevant prior sources

Ryan Williams, *Simulating Time With Square-Root Space*,
[arXiv:2502.17779v1](https://arxiv.org/pdf/2502.17779v1), Theorem 1.1 and
Sections 3.2 and 5, proves the multitape square-root-space simulation,
uses guessed computation graphs with local consistency rejection, and
asks about a one-tape exponent below one half. Consequently, local
guessed-graph checking is not a new principle supplied by this work.

Cook and Mertz, *Tree Evaluation Is in Space O(log n log log n)*,
STOC 2024, [DOI 10.1145/3618260.3649664](https://doi.org/10.1145/3618260.3649664),
provide the clean additive-register evaluation framework. The theorem
text consulted was the
[revised author copy](https://iuuk.mff.cuni.cz/~iwmertz/papers/cm25.tree_evaluation_is_in_space_lognloglogn.pdf),
specifically Definition 2.3, Proposition 2.5, Theorem 1.3, and Lemma 5.1.
These locators are for THAT revised copy, not asserted to identify the
frozen proceedings text. Its uniform-instruction accounting and its
reported correction to earlier large-fan-in/small-alphabet asymptotics
make it particularly important not to infer bit costs from a semantic
lookup interface alone. An attempted ECCC retrieval failed; no
proposition is attributed to that unavailable copy.

Hennie, *One-Tape, Off-Line Turing Machine Computations*,
Information and Control 8 (1965), 553-578,
[DOI 10.1016/S0019-9958(65)90399-2](https://doi.org/10.1016/S0019-9958(65)90399-2),
Sections II.A-II.B and Theorem 1, treats crossing interfaces and
deterministic finite-segment reconstruction. The
[primary scan](https://www.eecs.tufts.edu/~aloupis/comp260/lectures/hennie-1965.pdf)
supports treating transcript uniqueness and crossing interfaces as
established ideas, not a novelty claim.

These are comparisons, not unproved theorem dependencies of `Main.lean`.
The formal result's proposed contribution is the precise arbitrary-raw,
radius-safe realization and its source-derived composition with a
certified evaluator. A new formalization alone does not establish a
publishable new mathematical result. Independent review must assess
statement fidelity, the remaining implementation boundary, and
significance/novelty against these stronger precedents.

## Reproduction

Use the assigned campaign root and approved interpreter:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/audit137_simulation/verify.py
```

`diagnostics` regenerates finite experiment results; `prepare` rebuilds
the byte-identical accepted dependency import; `certify` invokes the
official claim-bound compiler and both campaign-local checks; `seal`
binds their actual results into `exact_certificate.json`. The default
replay does not claim to be a fresh compiler run. A Reviewer wanting
one runs `certify` as well. A long certification command must be
submitted through this host's durable direct runner. Compiler results,
not this report's wording, determine whether the formal source is
currently certified. `validate` refreshes just the two campaign-local
checks after a ledger or proof-graph change, without recompiling
unchanged Lean source.
