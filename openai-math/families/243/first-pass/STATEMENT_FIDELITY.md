# Family 243: interpretation and full-model correspondence

## Result and evidential boundary

The interpretation convention in the first manuscript agrees with Section 6,
Theorem 18 of **Deep Weisfeiler Leman, arXiv:2003.10935v1**, including generated
equivalence classes, existential saturation of relations, the first halt test
after initialization, and the sum-of-state-sizes cost. That source explicitly
uses CPT **with counting**. It does not impose a fixed bound on HF rank.

The upstream separation theorem concerns `FullCPT.EvaluationDefinable`, not
literally the interpretation-program syntax. The one-way simulation proved
below supplies the needed mathematical implication. It accounts for temporary
objects as well as stored states; identifying the two models by their names
would not supply that implication. The simulation is a **prose proof awaiting
independent review**, not a Lean-certified compiler.

All upstream references below are pinned to openai/math commit
`4eaee87548250b2682affda7d05d947c05554bae`. Its existing proofs receive credit
as prior work, not as this campaign's novelty. No upstream Lean dependency
closure has been compiled in this mission. No manuscript assertion has been
shown false here; there is consequently no justified `F_` refutation claim.
This scope result does **not** complete the publishable campaign.

## Sources and retrieval

`P1` means
`research/openai_manuscript/Choiceless-polynomial-time-with-counting-does-not-capture-polynomial-time-September-23-2026/build/sections/`.
`P2` means
`research/openai_manuscript/Witnessed-symmetric-choice-is-strictly-stronger-than-choiceless-polynomial-time-with-counting-September-24-2026/build/sections/`.
`U` means `lean/OAI/ModelTheory/Choiceless/` at the pinned commit.
Paths and lemma labels, not theorem numbering guessed from another version,
identify the manuscript assertions.

The primary PDF at <https://arxiv.org/pdf/2003.10935v1> was obtained and its
actual interpretation definitions and Theorem 18 read. The relevant text is
preserved in `certificates/C243_MODEL_FIDELITY/gsw-v1-section6.txt`.
Theorem 18 is the external characterization used here; its proof is not
reconstructed. Its attribution to GKPS15, Theorem 1, is provenance, not a
second independently established theorem in this audit. An independent
Reviewer must still attribute the ledger's GSW18 assumption against the
primary passage. A successful retrieval is not that independent attribution.

Pinned upstream source was read through GitHub's contents API. Semantic search
reported the same indexed commit. Relevant sources are:

| Source | Proposition actually inspected | Evidence level |
|---|---|---|
| `U/Model.lean:13-49` | Eight input relations; coefficient, incidence, normalization and consistency equations | Definition comparison |
| `U/Model.lean:386-484,502-561` | Full HF terms/rules, stores, runs, evaluation roots, `occurring`, `EvaluationDefinable` | Definition comparison |
| `U/Interpretations.lean:16-108` | FO+H, two-dimensional generated quotients, total polynomial IL decisions | Definition comparison |
| `U/Interpretations.lean:228-318` | Whole-class payloads, injective tagged codes, size bounds and transitivity | Existing proof source; not locally compiled |
| `U/Interpretations.lean:873-974` | Formula invariance and induced interpretation isomorphisms | Existing proof source; not locally compiled |
| `U/Grid.lean:89-210` | `subgroup_support_edges`, `small_orbit_support_edges` | Existing proof source; not locally compiled |
| `U/FullLanguage.lean:146-208` | Compilation to operational machines; **stored/cumulative-active** acceptance | Existing proof source; not the final resource predicate |
| `U/Evaluation.lean:26-83,98-166` | Collection of evaluation roots, `observed_compile`, `evaluationAccepts_compile`, `query_not_evaluationDefinable` | Existing proof source; not locally compiled |
| `U/Separation.lean:7-24` | Query invariance, ordinary polynomial time, and non-`EvaluationDefinable` | Existing proof source; not locally compiled |

`lean/docs/243.md` is descriptive coverage text, not the mathematical
statement used for any implication here. No library port, project lakefile,
or new `.lean` source was created. Therefore there is no new compiler
certificate to misrepresent as verification of these declarations.

The inherited Wiki index was searched for choiceless counting, Weisfeiler
Leman, witnessed choice, and this campaign; no relevant page was found.
The authoritative mission write boundary excludes Wiki edits.

## Source-faithful dependency map

Every mathematical assertion in this table is registered separately in
`MATH_STATE.json`; source mapping does not endorse all its proofs.

| Claim | Literal source anchor and mathematical obligation | Immediate mathematical dependencies |
|---|---|---|
| C243_CPT_MAIN | P1 `00-introduction.tex`, `thm:main`; all finite eight-relation inputs, invariant PT query outside full counting CPT | QUERY_PTIME, LOWER |
| C243_QUERY_PTIME | P1 `00-introduction.tex`, `prop:query-ptime`; at most `2n` unknowns and `n+n^2` equations | Specified query, finite-field elimination |
| C243_GRID_PAIR | P1 `02-structures.tex`, `lem:universe-size`, `prop:opposite-answers`; equal-size zero/unit-charge pair for every `L>=2`, opposite query answers | Signed incidence cancellation, normalization |
| C243_GRID_ACTION | P1 `03-support.tex`, `lem:H-automorphisms`, equations H-product/H-commutator | Alternating cocycle and face cycles |
| C243_SPARSE_COCHAIN | P1 `03-support.tex`, `lem:sparse-cochain`; curl on `t` faces implies a representative on at most `2Lt` edges, including `t=0` | Explicit three prefix sums |
| C243_SUPPORT | P1 `03-support.tex`, `prop:small-orbit-support`, `cor:transitive-support`; orbit `<=N^q` implies support `<=2L(q log_3 N)^2`, with no rank hypothesis | GRID_ACTION, SPARSE_COCHAIN, stabilizer isotropy/duality |
| C243_BASE_EQUIV | P1 `04-base-logic.tex:120-201`, `prop:base-equivalence`; sufficiently large grids agree in `C^floor(L^(7/4))` | Giant-component boundary estimate, defect-moving bijections |
| C243_HOMOGENEITY | P1 `04-base-logic.tex:232-354`, `prop:base-homogeneity`; `7r+7(6r/c)^(3/2)+1<=M` identifies the K-orbit of equal-type r-tuples | Partial-flow extension, component balance, class predicates |
| C243_HF_TRANSFER | P1 `05-hf-transfer.tex:25-46`, `thm:hf-transfer`; nonempty bases, `max(4,m+1)s<=M`, base equivalence and orbit homogeneity imply supported-HF `C^m` equivalence | Extension counts, forms, representation, equality/membership/count transfer |
| C243_CHARACTERIZATION | P1 `06-coding.tex:15-62`; every full counting CPT property has a total polynomial FO+H interpretation decision | GSW18 external assumption |
| C243_TRACE | P1 `06-coding.tex:71-132`, `lem:trace-size`; codes and all constituents form an invariant transitive family of size `<=9B^3` | Whole-class Kuratowski coding, polynomial state/stage bounds |
| C243_STATE_EXACT | P1 `06-coding.tex:141-297`, `lem:state-exactness`; common formulas define precisely the actual states through halt, including empty states | TRACE, transitive extensionality, bounded H translation, generated reachability |
| C243_WIDTH | P1 `06-coding.tex`, `lem:substitution-width` and following application; fixed program gives one stage-independent variable-name bound | Capture avoidance, exposed arguments only, `fw` renaming |
| C243_LOWER | P1 `07-separation.tex:7-45`; every fixed program agrees on the pair for sufficiently large L | GRID_PAIR, SUPPORT, BASE_EQUIV, HOMOGENEITY, HF_TRANSFER, CHARACTERIZATION, TRACE, STATE_EXACT, WIDTH |
| C243_WSC_MAIN | P2 `00-introduction.tex:38-51`, `thm:main`; a fixed one-WSC Boolean sentence on all finite inputs defines a non-CPT class | WSC_BOOLEAN, WSC_GRID, WSC_LOWER |
| C243_WSC_SEMANTICS | P2 `01-formalism.tex:70-115`; **every** first-stabilization path is witnessed, witnesses fix parameters and the whole previous history, polynomial annotation includes temporary objects | Definition, not a theorem inferred from syntax |
| C243_WSC_BOOLEAN | P2 `03-sentence.tex:532-711`, `sen:all-input`, `sen:polynomial`; guarded sentence is Boolean with one fixed polynomial on every input | WSC_SEMANTICS, filtering of full-input automorphisms, monotone-state history argument |
| C243_WSC_WITNESS | P2 `04-grid-behavior.tex:106-236`, `grid:transitivity`; for every resolving parameter and compatible prefix, every ordered candidate pair has a filtered history-fixing automorphism | Local face translations, bounded moved atoms, tree-return circulation |
| C243_WSC_GRID | P2 `04-grid-behavior.tex:283-318`, `grid:separation`; all terminal paths accept zero charge and reject unit charge without dagger | WSC_WITNESS, divergence solvability/cancellation |
| C243_WSC_TRACE | P2 `08-cpt-lower-bound.tex:56-116`, `eval:trace`; whole deterministic trace is polynomial, invariant and membership-transitive, including rejected and stationarity candidates | Fixed annotated term evaluation semantics |
| C243_WSC_DESCRIPTION | P2 `08-cpt-lower-bound.tex:128-430`, `eval:description`; bounded-width descriptions exact at actual activations, unique over the whole supported domain | WSC_TRACE, fixed evaluation templates, empty/default cases |
| C243_WSC_LOWER | P2 `08-cpt-lower-bound.tex:430-505`, `eval:pair-equivalence`; every fixed CPT sentence agrees on the pair for sufficiently large L | P2 `sup:small-orbit`, `sup:hereditary`, `base:equivalence`, `base:homogeneity`, `hf:transfer`, WSC_TRACE, WSC_DESCRIPTION |

The P2 map is a read-only source worker's inventory, not independent review.
P2 explicitly credits and re-presents the shared grid/support/transfer
arguments (its introduction, lines 133-147). The extra all-path witnessing,
history stabilization, all-input guard and evaluation-description obligations
remain distinct. The P1 interpretation simulation below does not discharge
them.

The shared-claim P2 anchors are `05-support.tex:141-275`
(`sup:small-orbit`, `sup:hereditary`), `06-base-counting.tex:159-234,283-414`
(`base:equivalence`, `base:homogeneity`), and `07-hf-transfer.tex:44-66`
(`hf:transfer`). Their corresponding proof obligations are represented by
SUPPORT, BASE_EQUIV, HOMOGENEITY and HF_TRANSFER, rather than counted as four
new results merely because the proofs appear in a second manuscript.

## Exact comparison of the interpretation models

1. **Counting and parameters.** GSW Section 6 calls CPT choiceless polynomial
   time with counting, describes `Card` as a von Neumann ordinal, and uses
   FO+H. A counted variable is bound, but other displayed variables remain
   free. `Interpretations.Formula.hartig` has precisely this behavior:
   it compares the cardinalities of two subtype sets with the same outer
   environment. Parameter-free interpretations forbid an extra distinguished
   input tuple; they do not forbid the displayed argument variables.

2. **Generated quotient, not a well-definedness assumption.** GSW's
   "finest equivalence relation" containing identification edges is the
   smallest equivalence relation containing them. P1 uses that convention,
   as does `Relation.EqvGen.setoid` in `Interpretation.classSetoid`.
   All three restrict the generating relation to the domain. For each
   output relation, all three quantify existentially over representatives;
   they do not require the raw defining formula to be class-invariant.
   No defective quotient invocation has been found.

3. **Stages and cost.** GSW and P1 use `A_1=init(A)` and first test halt
   there. The upstream `Program.state A 0` is that same `A_1`.
   Its `cost A j=(j+1)+sum_{k<j+1}|state A k|` is exactly P1's
   `h+sum_{i=1}^h |A_i|` with `h=j+1`.
   The upstream `c(n+1)^d` is a harmless polynomial majorant, also at `n=0`.
   These statements are about a deciding program: both outcomes halt.

4. **No fixed-rank truncation.** Upstream HF is the quotient of finite
   hereditary lists, not an HF domain cut off at a constant rank.
   The support theorem even quantifies over an arbitrary group action
   `X`, not merely a bounded-rank universe. Here upstream box parameter
   `n` corresponds to manuscript side length `L=n+1`.
   The stronger subgroup bound `L*faceCodim*flowCodim` is compatible with
   the weaker stated orbit bound `2L(q log_3 N)^2`.

5. **The full resource predicate.** `FullLanguage.Program.accepts` bounds
   cumulative **stored** active objects. `Model.Program.evaluationAccepts`
   instead bounds `occurring`: the active-family union plus the hereditary
   closure of `stepRoots` of every executed pre-halt step. Roots include
   every comprehension guard candidate, even rejected candidates; bodies
   contribute only when their guard is true. Selected conditional branches
   contribute their roots. `Evaluation.observed_compile` proves equality
   with the operational observer family, not merely an inequality.
   `Separation.main` uses the latter predicate.

The eight-relation query matches as well: `Input.Edge` and `Input.Config`
are separate subtypes even if their underlying atoms overlap; all applicable
Z-relation contributions are summed; incidence is directed from configurations
to edge atoms. Thus the comparison is not restricted to promised well-formed
grid inputs.

## One-way simulation theorem (C243_IL_SIMULATION)

**Statement.** Let P be any fixed, total, polynomial-cost interpretation
program in the binary input vocabulary `Symbol`, with the generated-quotient
semantics above. If P decides Q, then Q is `FullCPT.EvaluationDefinable`.
The conclusion concerns this fixed eight-symbol vocabulary; the same
construction works for any fixed finite binary input vocabulary using the
corresponding generalized definition. No converse is needed or asserted.

**Proof.** Fix an integer polynomial majorant B(n)>=max(2,n) for P's
number of stages and every state size. This exists from its stated cost
bound. The simulating program uses finitely many **nullary** dynamic symbols:
phase, stage tag, current universe, one relation register per state relation,
and finitely many scratch registers. These are allowed `FullCPT.Program`
functions. Its variables are the finitely many names in the fixed templates
constructed below.

Write `op(a,b)={{a},{a,b}}`. This is a fixed `Term` using unordered `pair`.
An ordered pair's two projections are fixed terms too: take its union,
filter for the intersection of its members, and use `unique` for the first
coordinate; the second is the unique element of the union different from
the first, or the first if there is none. Bounded universal tests are
negated bounded existential tests. This uses only the listed primitives,
including on the diagonal pair `op(a,a)`.

Store a relational structure as its HF set U of vertex codes and, for each
relation, a set of `op(a,b)` codes. At stage zero U is `atoms` and input
relations are comprehensions guarded by `input r a b`. Compile FO+H
formulas recursively to Boolean terms. Equality and relation membership
are the corresponding primitive tests. Existential quantification is the
nonemptiness of `{1 : x in U : compiled_body}`. H compares
`card({x : x in U : compiled_left})` and
`card({x : x in U : compiled_right})`.
Negation and conjunction give the remaining Boolean operations.
This proves formula correctness by structural induction, with free
parameters retained. Empty U causes no exception: existential witnesses
are empty and the two zero cardinalities compare equal.

For an interpretation form the set D of ordered pairs satisfying its
compiled domain formula. Form E0 on D from equality, identification and
reverse identification. Starting at E0, repeatedly replace E by
`E union (E compose E0)` until equality holds. Each operation is a fixed
nest of comprehensions and unions over D; membership tests use pair codes.
If m=|D|, every connected pair has a simple path of length at most m-1.
Hence this loop reaches the generated equivalence relation in at most m
updates and one final equality test, also when m=0. It uses no choice.

For each p in D, form `S_p={q in D : E(p,q)}` and
`v_p=op([j],S_p)`. The set `{v_p:p in D}` deduplicates all representatives
of each class automatically. Classes are nonempty and disjoint, and
Kuratowski coding is injective, so these are exactly the injective
vertex codes of P1. Define each new relation as
`{op(v_p,v_q):p,q in D, compiled_rho(p,q)}`.
This is exactly existential representative saturation, including when
rho is not invariant on classes. The tag is advanced by ordinal successor,
which is a fixed union/pair term. Check the compiled halt sentence after
initialization and each completed step, and set the accept flag to the
compiled output at the first halt.

All these are literal operations of `Model.lean:386-454`. A finite
control graph is a fixed nest of rule conditionals on the phase register.
Each edge writes distinct nullary locations using parallel updates; a
back-edge implements the equivalence-closure loop. Thus updates are
consistent and this construction defines a `FullCPT.Program`, rather
than requiring an additional iteration primitive in its terms. A simple
induction on interpreted stages proves the stored structure is isomorphic
to P's actual state and preserves its first halt and Boolean output.

It remains to bound **all occurring objects**. The m above is at most B^2,
and E has at most B^4 pairs. There are at most B interpreted stages and
only constantly many other control edges per stage. The simulated number
of steps is therefore at most `C_P(B+1)^3`.
P1's whole-class vertex-code constituents total at most 9B^3. Relation
wrappers and relation-register sets across all completed stages add
`O_P((B+1)^3)` objects.

For clarity, let r be the maximum nesting depth of comprehensions in
any of the finitely many **microstep terms**, including the compiled
FO+H formulas and pair-projection templates. Every iteration domain in
these terms has at most `C_P(B+1)^4` elements: it ranges over a stored
universe, D, an E relation, a class payload, a pair wrapper, or a subset
of one of these. Nested images and their flattening unions in the
templates have the same polynomial bound; no powerset operation is used.
Every term subexpression is evaluated under at most
`C'_P(B+1)^(4r)` assignments. Each value and each pair wrapper is
therefore one of polynomially many evaluation roots. Its hereditary
members are preceding vertex-code constituents or values/wrappers at
these subexpressions. Cardinality results contribute only the initial
segment of ordinals of length `C_P(B+1)^4`.
This is a structural count, independent of the ranks of those constituents.

Consequently one microstep adds at most
`C''_P(B+1)^(4r+4)` objects to the union of hereditary evaluation families.
Multiplication by the polynomial number of microsteps bounds the
cumulative `occurring` family by `C'''_P(B+1)^(4r+8)`.
Choose natural-coefficient time and space polynomials majorizing these
two expressions after substitution of B(n). Both accepting and rejecting
runs satisfy the bounds. Therefore guarded `evaluationAccepts` agrees
with P's acceptance on every input, as claimed. QED.

The proof uses an arbitrary program-dependent exponent, not one constant
shared by all programs. Code rank may increase with every interpreted
stage. It establishes expressiveness inclusion; it does not claim
same-step execution, a linear overhead, exact equality of resource
annotations, or a kernel-checked compiler.

**Consequence (C243_MODEL_FIDELITY).** GSW18 followed by this simulation
embeds the manuscript's full counting formalism into the model excluded
by the upstream `query_not_evaluationDefinable`. Thus **if the pinned
upstream separation proof is accepted**, it covers the unrestricted-rank
claim; a missing fixed-rank assumption is not the obstruction. The remaining
certification gap is genuine but different: this mission has not replayed
the upstream Lean proof closure, the prose simulation awaits independent
review, and the external characterization awaits independent attribution.
Neither a version mismatch nor these unperformed checks refutes the paper.

## Failed reduction, finite checks, and remaining frontier

The fixed-rank shortcut is invalid: for an atom a let `x_0=a` and
`x_(t+1)={x_t}`. Induction gives rank t and exactly t+1 distinct hereditary
objects in the trace through t. Polynomially many occurring objects
therefore do not imply a rank bound independent of input size.
This is the reason recorded on retired route `R243_FIXED_RANK`; it is not
a false assertion made by either manuscript.

`certificates/C243_MODEL_FIDELITY/verify.py` replays:

- injectivity of Kuratowski coding on an explicit finite mixed atom/set pool;
- generated quotient and existential relation saturation for every binary
  identification relation on up to three domain elements, including the
  empty domain, and equivariance under their relabelings; output relations
  are checked on the empty/singleton basis, not exhaustively on all subsets;
- all bounded H comparisons on that domain, including zero;
- associativity and the signed commutator on the one-face F3 Heisenberg
  groups, exhaustively, and the exact 27-point action used for one bounded
  Jacobian orbit call;
- the exact polynomial identity
  `9B^3-[B(3B^2+4B)+2B+1]=6u^3+32u^2+54u+27`, `B=u+2`,
  whose positive coefficients prove the stated size inequality for all
  integer B>=2.

The last identity is a universal algebraic check of that inequality.
The finite quotient and group checks are **finite experiments**, not
certification of the simulation, support theorem, HF transfer, or either
manuscript conclusion. Their certificate says so explicitly.
Jacobian supplied one exact finite orbit calculation, not a proof strategy.
Its exact payload, inspected typed contract, server/protocol identifiers,
typed result, adapter exit code and timeout status are retained as
dedicated JSON files in that certificate directory.

The strongest prior result relevant to this scope is the existing upstream
arbitrary-action support proof and full evaluation-model lower bound.
The improvement here is the explicit convention/resource comparison and
one-way simulation proof, rather than a new support proof or a novel
separation theorem. A genuinely new publishable result and independent
Reviewer replay are still open campaign obligations.
