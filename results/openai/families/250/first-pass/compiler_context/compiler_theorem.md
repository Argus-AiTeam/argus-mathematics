# Verification of the bounded compiler, with the source-translation boundary explicit

## Statement

Fix the alphabet and the deterministic, nonnegative-tape machine in
`build/compiler.tex`. Let `f` be its partial returned-word function. A return
is the consecutive string of alphabet symbols starting at tape index zero,
terminated by the first blank. The supplied table computes `f`; this is the
input convention, not an additional assumption about the table's reversibility
or running time.

Let `K`, `gamma`, and `N` be **the presentation, grade, and evaluator actually
specified in that appendix**. If at an integer `m >= 0`

    f(w) is defined and |f(w)| <= |w|                 for |w| <= m,
    f(x f(w) y) = f(x w y)                          for |xwy| <= m,

then `N` terminates on every word of grade at most `m`, every such word has
a derivation to its literal answer that never raises grade, and every defining
equation in every context with both endpoints in that ball preserves `N`.
Consequently equal answers remain equal in every context whose two inputs
stay in the ball. Unconditionally, the empty word, zero, and every full raw
singleton are fixed, and the only program calls have input length at most
the original grade. If the hypotheses hold for all budgets, `N` decides the
presented monoid's equality and has the stated raw-product rule.

This is an ordinary parametric proof. The Lean sources check its algebraic,
validator, tape-trace, component, and context-transport ingredients. The
translation from the prose scan instructions to those definitions is justified
below, and is also implemented as local rules in `scan_runtime.py`. This
document does **not** claim that Lean has parsed the LaTeX or proved the full
Python implementation correct.

## 1. Exact interpretation of the scan instructions

A cell's five tag fields are independent; every test of a bare base tests the
**entire** clean tag. Its immutable base is never changed by an internal rule.
Store the cells immediately left of a head in reverse order, and those on the
right in ordinary order. A rewind step is exactly

    (b :: l, r) -> (l, b :: r).

The rightward counterpart is exactly its inverse. Neither changes the ordered
cell row `reverse(l) ++ r`. At the appropriate boundary, a stationary rule
changes only the phase. If the boundary is absent, that rule is absent.

For a rightward first-match scan, write the right row as `p ++ b :: r` where
the predicate fails throughout `p` and holds at `b`. Its unchanged crossings
end at `(reverse(p) ++ l, b :: r)`. The specified stationary update is then
performed at `b`; no other cell is updated. If no match exists, exactly the
prescribed end continuation is available, and only if `omega` is present.
The scan traverses at most the number of cells before that event. These claims
are inductions on the crossed list, not finite search observations:
`rewind_exact`, `right_exact`, `seek_match`, and `seek_none` encode them.

Every invocation has its own phase states. Each state's cases have one reading
side, disjoint predicates, and at most one continuation at a matched cell or
boundary. Registers carry only an alphabet letter or machine state. Thus the
literal expansion is finite, effective without running `f`, and deterministic
on **all** sectors, not just reachable ones. Dirty tags can make a test fail,
but cannot introduce a second forward choice. Each local update preserves the
base and outer boundary flags. The runtime represents this expansion, including
the separate intermediate phase for each left move, without identifying
different invocations' states.

## 2. Validator: arbitrary entries, not a clean-input promise

For a list of cells, use the following languages, with `A` denoting completely
clean anchors and `W,C,D` the completely clean special cells:

    A*;       L = W* C A*;       R = W* D A*;       H = A* C W* D A*.

These are languages of **literal tagged cells**, not just of their bases.
In the left stack the head-nearest cell is first. Define an acceptance
predicate on validator configurations as follows, always requiring `omega`:

| Phase | Additional condition |
|---|---|
| I | `alpha`, left stack in `L`, right row in `R` |
| J | `alpha`, left stack in `A*`, right row in `H` |
| J' | right row in `H` |
| N | right row in `R` |
| V | right row in `A*` |
| start | empty right row |

Substituting each of the ten displayed validator instructions shows that this
predicate has the same truth value before and after the instruction. In
particular an arbitrary `J'`, `N`, or `V` configuration need not have `alpha`;
the predicate does not accidentally reject such sectors. An entry, however,
starts in `I`, so any path from it to the handoff does force `alpha`.
`validator_good_step` checks all ten substitutions; `validator_good_reach`
extends them to every finite path.

Number the phases `I,J,J',N,V,start` by `5,4,3,2,1,0`. For a configuration with
`k` cells, the quantity

    (k+1) * phase_number + cells_on_the_phase's_reading_side

strictly decreases at every validator step (use zero for `start`).
Thus every validator run ends or hands off in finitely many steps, independently
of the input tags. `validator_decreases` and `validator_terminates` verify this
well-founded argument for arbitrary lists and boundary flags.

At an entry the right row begins with clean `D`. Its acceptance predicate
therefore says exactly that its ordinary row and head gap are

    alpha x_L C_L W_L^s I D_R y_R omega,

with all tags clean. Conversely, from every such word the prescribed sweeps
do reach the handoff: the `I` loop crosses its `s` workspace cells, the `J`
loop crosses `x`, the boundary changes to `J'`, and the three rightward sweeps
cross `x,C,W^s,D,y`. At that point every cell is left of the head. This
constructs the path, including `x=y=empty` and `s=0`; it does not assert that
the subsequent computation succeeds with zero workspace.

The inverse of a validator step is unique. For `I` its immediately right cell
must be `W`; for `J` it is either `C` (from `I`) or an anchor (from `J`).
For `J'` the immediately left object is either `alpha` or an anchor; for `N`
it is `C` or `W`; for `V` it is `D` or an anchor. The incoming handoff to
`start` is unique. `vnext`, `vprev`, and `validator_inverse` implement and
prove these exact statements. An entry has immediate right cell `D`, so it
has no internal predecessor (`entry_no_predecessor`). There are no machine
continuations into any validator phase.

## 3. Simulation and sufficient quota: a rank invariant for each scan loop

Put `u = xy`, `n = |u|`. Consider a passing entry with quota `s`.
Rewinds and first-match scans have the exact effects proved in section 1.
The following invariants therefore establish their interpretation at loop
boundaries; intermediate crossings merely change the head gap.

### Input-copy loop

After `j` successful iterations, the first `j` anchors, in their original
order across both anchor blocks, have their read bits set; the remaining
anchors have them unset. The first `j` workspace cells are filled and their
work track spells `u[0:j]`; every remaining workspace cell is clean and blank.
All output-read bits and all output marks are still unset. The two cuts and
the other tag fields are unchanged.

This holds at `j=0`. The first unread anchor is exactly the next input letter,
and the first unfilled workspace is exactly the next workspace slot. The two
stationary updates change just those two fields at those ranks. If no such
slot exists the run is stuck, not a success. This proves the induction step.
There are `n` anchors, so the end of the anchor search occurs exactly at
`j=n`. The additional unfilled-workspace test succeeds exactly when `s>n`.
On success the workspace is `u` followed by `s-n` blanks, and the simulation
starts at its first cell. `copyInput_exact` gives this universally quantified
array identity; the head-motion realization is the first-match lemma, not an
assumption that a scan somehow chooses an available cell.

### Machine phase

Identify workspace rank `i` with tape index `i`. At every ordinary simulation
state with a workspace cell on the right, the supplied machine state, index,
and work symbols agree with the source computation at all indices `<s`.
The other tag fields do not affect its transition tests and are not changed.
A stationary move updates the same work symbol and state. A right move
updates rank `i` and advances to `i+1`; if that rank is outside the workspace
the simulation cannot take another machine step or recognize a halt.
A left move first writes at `i`, then in its dedicated intermediate state
crosses rank `i-1` if `i>0`; at `i=0` it tests the immediately preceding base
`C` and stays. Thus the index becomes `max(0,i-1)` in precisely the required
convention. This checks every direction, including the boundary degeneracy.

`execute`, `machineStep`, `boundedStep`, `bounded_step_sound`, and
`bounded_step_complete` encode these updates for an **arbitrary** transition
table and arbitrary work-symbol type. A move leaving the workspace may have
one extra stuck literal configuration; treating it as a failed bounded macro
step cannot create or remove a successful computation. `padded_input` checks
agreement of the actual finite initial workspace with the unbounded input
tape at every accessible index.

### Output loop and cleanup

After `j` successful output iterations, exactly the first `j` workspace cells
have their output-read bits set, and exactly the first `j` anchors have marks.
Those marks spell the first `j` source output letters in order. Other marks
are none. This starts with `j=0` because neither copying nor simulation changes
these fields. The next first-match scan reads workspace rank `j`.
A blank finishes without adding a letter; an alphabet letter is carried to
the first unmarked anchor, at rank `j`; an invalid work symbol, no anchor slot,
or no remaining workspace gets stuck. Thus success has a blank at rank
`|out|<s`, a genuine output prefix `out`, and `|out|<=n`.
`readTape_sound`, `readTape_complete`, `spells_unique`, and `markAnchors_exact`
certify these exact prefix/capacity assertions, including invalid symbols and
the empty output. `cleanMarks_exact` and the previously checked cleanup
theorems show that cleanup leaves precisely `raw(out)`, with clean tags.

No temporal or space bound has been assumed. Given any finite source
halting trace returning a word of length at most `n`, its finitely many visited
indices have a maximum. Choose `s` larger than that maximum, `n`, and the
output length. All the above scans terminate and all its simulation steps
stay in bounds; a blank after the output is present. `finite_trace_quota`
proves this for every finite trace, and `pipeline_complete` combines that
bound with the copy and output capacities. Conversely `pipeline_sound` turns
every successful bounded macro trace into the genuine source result.
`program_result_unique` and `pipeline_computes_program` prove that the result
equals `f(u)`, not merely some halting output. No reversible-machine
hypothesis is used.

## 4. Internal weak components, including dirty sources

Fix the ordered base row and the two boundary flags of a sector. With `k`
cells, `h` internal states and at most `c` tags per cell, the internal graph
has at most `(k+1)h c^k` vertices. The presentation table determines all its
edges effectively. Workspace insertion is **not** an internal edge, so this
bound is independent of literal word grade zero. Searching the whole component
therefore terminates even when the source computation does not.

We use two elementary deterministic-graph facts, checked without any finiteness
restriction in `CompilerProof.lean`:

1. If a weak component contains a terminal vertex `t`, every vertex of that
   component reaches `t` by forward steps. For one backward weak edge,
   cancel the first forward edge on the existing path to `t`; determinism
   makes it the required successor. Induction over the weak path proves
   `weak_reaches_terminal`. In particular terminal vertices are unique.
2. In a predecessor-closed set whose incoming edges are unique, two vertices
   without predecessors cannot have forward paths to the same vertex unless
   they are equal. Cancel the last edges of the two finite paths; if one path
   is empty, the alleged last edge contradicts that endpoint's absence of
   predecessors. This is `reverse_chain_unique`.

An entry that fails validation ends at a terminal validator vertex, by section
2. The validator set is predecessor-closed in the **whole** internal graph:
no machine rule returns to it. Its incoming edges are unique. Hence any other
entry in its weak component would also reach that same failed terminal and
would equal the first entry by fact 2.

Otherwise an entry passes validation. Its fixed base row has exactly one `C`,
one `D`, workspace between them, and anchors elsewhere; its two boundary flags
are present, its tags are all clean, and its head is immediately before `D`.
The fixed base row therefore determines that entry literally and uniquely.
Consequently two passing entries in the same component coincide. If either
entry fails, the preceding paragraph already proves uniqueness. This is the
full argument behind `component_entry_unique`, not the functional-graph
observation alone.

A sector with `q_ok` immediately before its final `omega` is terminal. Thus
there is at most one in a component. If an entry is also present, fact 1 says
that the entry's **forward** computation reaches it. Sections 2 and 3 then
give the entirely clean input form and genuine output `f(xy)`. A component
with no entry may have a spurious successful terminal from dirty machine
data; the evaluator correctly uses that terminal's literal cleanup and makes
no assertion that it computed `f` on a clean input.

## 5. All preprocessing equations

Apply the exact preprocessing rules sector by sector. They preserve the
outer boundaries, and only unmerge creates interior `omega alpha`.
Internal weak paths preserve every base and hence grade. Moving to the
selected entry or terminal is therefore a grade-preserving presentation
derivation; choosing the least member when neither exists has the same
property. The component choices are unique by section 4.

Here is the complete list of defining equation families and their effect
before the final raw-run stage:

| Equation family | Comparison of preprocessing outputs |
|---|---|
| raw slide | identical leftmost reachable raw-head gap |
| quota insertion/removal | identical trimmed quota sector |
| merge/unmerge | identical pair of normalized raw-head sectors |
| quota-to-entry `P D_R = I D_R` | identical: the entry's component selects that same entry, then reverts to `P` |
| internal validator/machine equation | identical: its two endpoints have the same weak component |
| cleanup of any tagged cell | identical continuation of deterministic cleanup |
| `alpha Z = alpha Q` | identical raw sector, already at its leftmost gap |
| successful exit without an entry | identical cleanup of the unique terminal |
| successful exit with an entry | the pair `raw(x),raw(y)` versus the singleton `raw(f(xy))` |

The first three and both cleanup families are universally verified in
`Preprocess.lean`, with arbitrary tags, cells, and optional boundaries.
The quota-to-entry case does not assume validation succeeds: an entry is a
source, and section 4 proves it is its component's only entry even when
malformed. The internal-equation case does not assume either endpoint is
forward reachable from a well-formed input.

The exceptional successful-exit case is now justified, rather than posited:
section 4 makes its entry a genuine passing computation. Reversal of quota
and merge splits it into the two **full** raw sectors for `x,y`; terminal
cleanup gives the full raw singleton for `f(xy)`. Both outer boundaries
are forced by validation. Arbitrary incomplete outer sectors therefore
cannot occur in this exceptional comparison.

## 6. Raw runs and the exact budgets

Write `u * v = f(uv)`. If `|uvw|<=m`, the contextual budget identity gives

    f(u f(vw)) = f(uvw) = f(f(uv) w).

Length nonincrease keeps every argument inside the original concatenated
payload budget. Consequently a run of at least two raw sectors can be
contracted in any bracketing to `raw(f(u1...ut))`. A singleton is left literal;
it need not be an `f`-fixed payload. Both features are part of the proof.
`Main.lean` checks this algebra for arbitrary payloads, barrier types, budgets,
and contexts, including call safety and all contraction grades.

For an original word of grade `g`, preprocessing never increases grade.
Each anchor contributes one, so the total payload length of every resulting
raw run is at most `g`. Hence every program call is on a word of length at
most `g`; no budget value is used to define the algorithm. Under the
hypotheses at `m>=g` all these calls halt.

In the exceptional exit comparison, let `a,b` be the concatenated full raw
neighbors on the two sides. With no neighbors, the two raw sectors contract
to the other side's literal singleton. With at least one neighbor, the
answers are `raw(f(axyb))` and `raw(f(a f(xy) b))`. The anchor count
`|axyb|` is at most the **entry side's original contextual grade**, so the
contextual hypothesis applies at the stated `m`. The other argument is no
longer, and both endpoints' outputs agree. These facts cover arbitrary
neighboring raw runs, not just clean isolated products.

## 7. Original presentation words, zero, and nonpaths

There are three vertices `O,L,R`; every nonzero generator is an arrow of the
specified quiver. Every nonzero defining side is a nonempty path, and the two
sides have the same first and last vertices. For cell deletion the retained
`Z` still has source `L` and target `R`; for merge both sides have source `L`
and target `R`. All scan and boundary cases have this property by construction.

Consider a replacement in an arbitrary context `p(-)q`. The interior of each
replaced side is a path. Compatibility with the last arrow of nonempty `p`
depends only on its common initial vertex; compatibility with the first arrow
of nonempty `q` depends only on its common terminal vertex. Every other
adjacent pair is unchanged. Thus either both whole words are paths or both
are nonpaths. This also covers empty contexts and missing external boundaries.
Nonpaths contain an incompatible adjacent pair, whose equation produces zero;
absorbing equations then give `Omega`. A word already containing `Omega`
likewise evaluates and derives to `Omega`. Zero and incompatible-pair equations
preserve that answer in every context. All those reductions decrease or
preserve grade because `gamma(Omega)=0`.

On a path, cut at every interior `omega alpha`. Returning from `R` to `L`
requires this pair, so every resulting sector has at most one head.
An equation in a context consequently changes just the sector(s) described
in section 5. A merge removes one such cut; an unmerge creates just that cut.
No other preprocessing operation changes the outer flags or another sector.
Headless sectors remain literal barriers. The local comparisons in section
5 therefore apply to the **whole contextualized path**, not to an isolated
subword whose boundaries might change on attachment. Section 6 proves equality
of the final answers. This exhausts every defining equation family.

## 8. Derivations, contexts, and global equality

Raw slides, quota removal, entry reversal, and unmerge preserve grade.
Unmerge checks exactly

    gamma(C_L P D_R) = 2+1+1 = 1+1+1+1 = gamma(Q omega alpha Q).

Workspace insertion has grade zero. Internal forward or backward steps
preserve bases and grade. Cleanup never raises grade, including on dirty
tags. Thus all preprocessing paths stay within the original grade.

For a pair of full raw sectors, use their clean merge, insert a sufficient
quota from section 3, validate, simulate, and clean. This derives their
contraction without any grade increase. Iterate these contractions in a
longer run. Section 6 identifies their answer with the evaluator's single
call on the concatenated payload, and bounds every intermediate call by the
original payload length. Consequently every input of grade at most `m`
has the asserted presentation derivation to its literal output. Each source
of possible nontermination has been addressed: sector processing is finite,
component search has the explicit finite bound, and the only remaining
program calls are covered by the exact budget.

Finally suppose `N(u)=N(v)` and both `puy,pvy` have grade at most `m`.
Lift the derivations from `u,v` to their common literal output into `p(-)y`.
Additivity bounds every intermediate contextual word by its input's grade.
The equation invariance just proved therefore identifies each contextual
input's answer with the answer of the same middle literal word. The answers
coincide. `arbitrary_word_context` formally proves this transport theorem
for every presentation alphabet, additive grade, contextual equation relation,
and bounded normalization derivation. It makes no sector-boundary assumption.

If the hypotheses hold at every budget, a finite presentation derivation has
a finite maximum grade. Invariance at that budget proves that equal monoid
words have equal answers. Conversely their derivations to equal literal
answers prove equality. Literal full raw singletons have no preprocessing
change and no raw run of length two, so they are fixed unconditionally and
are pairwise distinct answers, also distinct from zero and the empty word.
The raw-product formula is exactly the length-two raw-run rule. This proves
all the stated conclusions of `lem:compiler` for its specified construction.

## Scope of certification and comparison with the prior checkpoint

The earlier result stopped before the actual scan/component and exit bridge.
The new proof supplies the validator-language invariant, scan rank invariants,
source-tape correspondence with a sufficient finite quota, failed-entry chain
argument, successful-exit comparison, and the original-word/nonpath lift.
The runtime implements the supplied local program, including dirty fields and
optional boundaries; its finite tests are diagnostics, not the proof.

The kernel-checked declarations in `CompilerProof.lean` are universal theorems
about the explicit validator, list scans, copy/output arrays, arbitrary tape
tables and traces, component-entry criterion, and whole-word transport.
The theorem above still has a human-checked source-translation and composition
boundary: the program's interleaved literal scan phases and complete word
evaluator are not definitions in that Lean file. The certificate must retain
this limitation. A claim of a fully kernel-closed literal compiler would be
stronger than the evidence.

No false manuscript assertion or admissible counterexample is asserted.
This verification addresses only the compiler. It proves neither of the
downstream group-embedding theorems nor the independent universal-group result.
Publication-level novelty and statement fidelity require independent review.
