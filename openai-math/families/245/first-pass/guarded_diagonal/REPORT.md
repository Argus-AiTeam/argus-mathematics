# Guarded diagonal core: scope and conditional verification

## Scope settled before proof development

The target is the chain in the September 25, 2026 staged manuscript,
`build/sections/relational.tex`, from `rel-response-predicate` to
`rel-contradiction`, including `rel-shift`, `rel-ind-congruence`, and `rel-wf`.
The campaign's system-wide normalization claim `C9000245` remains open.

The source identifies this as an adaptation of Hurkens's well-foundedness
paradox, citing Hurkens (1995) and Geuvers (2007), Section 2. This observation
establishes provenance, not novelty or correctness. No external theorem from
either work will be assumed in the conditional proof. No publishability or
independent-review verdict is asserted here.

The exact upstream assumptions are the staged channel evaluation and data
cancellation laws, the lift/tag/rounding laws, the responsive pairing laws,
and the specialized query realization. These are local-source citations to
the dated manuscript, not independently verified literature results. Their
realization by the available PTS products is outside this node. The
observation interpretation, substitution bounds, erasure argument, and full
weak-to-strong normalization theorem are also outside this node.

The formal interface must retain separate predicate-code carriers, rounded
evaluation, restricted quantification over those carriers, and every response,
validity, and extensionality guard. In particular it must not assume validity
of WF, the induction builder, inductivity of the negative predicate, or the
terminal conclusion. The terminal is an arbitrary proposition representing
the designated formula F_b, not an assertion that F_b already means False.

The inherited Wiki index was searched for the guarded diagonal, Hurkens,
pure type systems, and campaign 9000245; no relevant prior result was found.
There is no earlier mathematical certificate in this campaign's initial
ledger or proof graph against which to claim a mathematical improvement.

## Cheap falsification before certification

The exact two-point/two-code Ind-congruence projection was enumerated over
all 64 pointwise-equivalent evaluation/observation tables. No counterexample
was found. A separate local response/pair-right/query projection checked
56 extensional-response tables and 56 valid-point instances, with 80 possible
observation-preserving rounding choices. It also found no counterexample.
These are finite local projections, not models or a verification of the full
channel construction.

The counterexample query for Ind-congruence has 12 Boolean variables and
23 clauses. Its source-to-CNF equivalence and absence of satisfying assignments
were checked on all 4096 assignments. The Jacobian adapter's initial request
was rejected because its clause ordering was not canonical; that rejection,
payload, and adapter exit status are retained as non-conclusions. Subsequent
canonicalization uses the inspected `sat.cnf.canonicalize` contract instead
of guessing its ordering. The solver request and answer are separately bound
to that source.

Deleting Valid from the local Ind or SB projection produces diagnostic
counterexamples, retained in the finite output. These are **not manuscript
counterexamples**: the manuscript includes the guard, and the diagnostics
do not realize every upstream hypothesis. They are sensitivity checks only.

## Conditional proof

`Main.lean` derives the whole requested chain from 14 explicit interface
laws. In particular, WF validity uses rounded probe evaluation for arbitrary
pointwise-equivalent codes, without Ext; the induction builder is proved;
and the negative code is proved extensional and inductive before use.
No predicate codes are replaced by all functions. All guards are supplied
at their original points. `terminal` proves the arbitrary designated
proposition B in minimal logic; `no_false_model` is its semantic False
specialization. The compiler's axiom audit reports no axioms for either.

`STATEMENT_FIDELITY.md` maps every interface premise and every derived
conclusion to manuscript labels, and separates metatheoretic open parameters
from the restricted logical quantifier domains. It also states the limitation:
this is a proof of the conditional logical chain in Lean Prop, not a quotation
or typing proof of the actual labelled PTS term.

Official source-bound mechanical evidence and campaign-local checks are
recorded by `verify.py`. Independent fidelity and mathematical review remain
pending; no flaw in a manuscript assertion has been established.

### Mathematical argument

Write i_v for the response code, S for the shift code, and
delta(x) = lift(tag_0(x)). All equivalences here are logical
biconditionals, never equalities of data.

For responsive v, rounding and tag congruence give exact evaluation of i_v
and Ext(i_v). The left-extraction code of Pair(Part(v),tag_0(x)) is
pointwise equivalent to i_v, including at the rounded argument. Pair-right
identifies its right observations with x equivalent to x'. In the R query,
forward evaluation at x supplies Ext of the extracted code and Valid(x).
Reverse evaluation transports le first along x equivalent to x', then
between equivalent predicate codes using Valid(x'). This proves SB with
exactly its original response and validity guards.

Lift validity and tag/lift congruence give delta validity and congruence.
For Ext(i), rounded shift evaluation becomes S(i)@x iff i@delta(x);
S(i) is extensional, and i_(z_i) is pointwise equivalent to S(i).
Raw lift cancellation, SB, and transport at Valid(x) then give
le(i,delta(x)) iff le(S(i),x).

Ind-congruence uses the Valid guard at each point to transport le, and
pointwise equivalence to transport its conclusion. Raw WF cancellation
gives le(i,WF) iff Ind(i_(z_i)). For arbitrary equivalent codes i,i',
rounded probe evaluation proves i_(z_i) equivalent to i_(z_i') without
Ext; hence Ind-congruence proves Valid(WF). With Ext(i), this also gives
le(i,WF) iff Ind(S(i)). Predecessor comparison and delta validity turn
Ind(i) into Ind(S(i)); evaluation at the now-proved-valid WF yields
the derived builder b(i): i@WF.

Define Q(x) exactly as in the source, quantifying only over Ext PX codes.
Delta congruence proves Q-congruence; rounded evaluation of the named
negative code j yields j@x iff (Q(x) -> B), and then Ext(j).
To prove Ind(j), fix Valid(x), le(j,x), and Q(x). Instantiating Q(x)
at j gives j@delta(x), hence Q(delta(x)) -> B. Conversely, for any
Ext(i) with le(i,delta(x)), predecessor comparison uses the original
Valid(x) to obtain le(S(i),x); Q(x) at the extensional code S(i),
followed by shift evaluation, proves i@delta(delta(x)). This constructs
Q(delta(x)), and therefore B, proving the required j@x.

Finally le(i,WF) gives Ind(S(i)); applying the derived b at S(i), then
shift evaluation, proves Q(WF). Applying b at j gives j@WF, hence
Q(WF) -> B. Application to Q(WF) proves B. Neither Ind(j), b,
Valid(WF), nor B was an input.

## Reproduction and exact outcome

Run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/guarded_diagonal/verify.py
```

This replays the archived Jacobian source bindings and finite truth tables,
then invokes the official Lean evidence producer with the claim and fidelity
document. No network solver call is needed for replay. The initial typed
Jacobian solve returned UNSAT in 466 ms; the independent exhaustive replay,
not that bare answer alone, establishes the finite exclusion.

The official Lean run used Lean 4.31.0, returned exit code 0 and
`proof_holes=[]`, and recorded
`certificates/C_GUARDED_DIAGONAL-d89005dc9a52596d.json`. The separate
Lean-evidence consistency check reports the source verified, with no issues.
The installed CLI takes the source as a positional argument, not `--source`;
`--no-lake` is appropriate because this proof imports Lean only, not Mathlib.
The tool's canonical lowercase fidelity copy is checked against the supplied
uppercase document on every replay.

Both official campaign-local checks returned 0 for
`campaigns/9000245`.
The derived ledger status is `conditional_kernel`, with four undischarged
upstream assumption groups. Their exact local-source labels are recorded;
the external-identifier citation subsystem calls these source-only references
`uncited`. No bibliographic lookup or independent source attribution is claimed.

The improvement over the initial state is an unbounded, kernel-checked
conditional logical theorem, rather than only an informal proof or bounded
search. It is not a new proof of system-wide normalization and does not
establish publication-level novelty. This is a bounded engineering milestone,
not completion of the publishable campaign. Independent Reviewer replay and
statement-fidelity assessment are the next required gate.
