# Statement fidelity: four-value recovery

## Claim and declarations

This document describes claim `C_RECOVERY_CORE` and the declarations in
`Main.lean`, namespace `FourValueRecovery`. The principal declaration is
`four_value_recovery`. Its supporting, independently meaningful declarations
are `infinite_oracle_substitution`, `bounded_local_programs_compute_branches`,
`infinite_confinement`, `telescope`, `decoding_terminates`,
`branches_compute_cut`, and `recovery_core`.

The claim is an infinite computability assertion. It is not a finite orbit
check, a comparison rule supplied with a branch oracle, or a proof conditional
on the branch sequence being computable.

## Objects and quantifiers

`Stream` is `Nat -> Nat`. The manuscript uses characteristic functions, which
are a special case. Allowing natural-valued streams is a genuine relaxation:
the branch rule only compares one output with a fixed natural number `h`.

`F : Real -> Stream`, the real parameters `u,v,t,rho,lo,hi`, the rational
step `d`, the natural constants `j,h`, and the two finite codes `p,q` are
universally quantified in `four_value_recovery`. There are no Borel or
countable-fiber hypotheses in this declaration. Those hypotheses are used by
the separate human category proof to establish the local hypotheses below.

`rationalSpan t s` means exactly that there exist rational `a,b` with
`s = a + b*t`. The orbit starts at zero and obeys

    r_n = if F(u+s_n)(j)=h then 1 else 0,
    s_(n+1) = s_n + d*(t-r_n).

`orbit` and `choices` define these objects, rather than taking either sequence
or its computability as a hypothesis.

The dynamical assumptions are `Irrational t`, `0<t<1`,
`0<d<rho<1`, `-rho<lo<0<hi<rho`, and the two endpoint rules on
`rationalSpan t`: the tested value differs from `h` in `[lo,lo+d]`
and equals `h` in `[hi-d,hi]`. The proof establishes confinement for *every*
natural stage and membership in the rational span. It does not impose
conditions on the intervening bit values. The manuscript's additional
`3*d<hi-lo` is not needed by this conditional dynamical theorem.

## Exact local-program interface

`p,q : Nat.Partrec.Code` are ordinary partial-recursive codes for verifying
finite oracle halting transcripts. They are not codes for functions that have
access to `F` or the orbit as extra oracles.

For a finite table `qs : List (Nat * Nat)`, `Accepts p j b k qs` means the
ordinary bounded universal evaluator `Nat.Partrec.Code.evaln k p` returns
`some 0` on the effective encoding of `(j,b,qs)`. An even table query reads
the first joined stream and an odd query the second. `tableMatches` requires
every proposed answer to agree with the specified stream.

`Runs p A B C` asserts, for every input `j` and proposed output `b`, that
a finite accepted table consistent with `A join B` exists if and only if
`C(j)=b`. This describes total local oracle computation, not a purported
computable orbit. The two local hypotheses are:

    Runs p F(u+s) F(v-u+a) F(v+s+a)

for all `s,a` in the rational span with `|s|,|a|<rho`, and

    Runs q F(v+s) F(u-v) F(u+s)

for all such `s` with `|s|<rho`. The return hypothesis is applied at
the *new* offset, after confinement has been proved.

The effective translation of an ordinary oracle-machine index into this
finite-transcript verifier representation is proved in prose in
`recovery.md`, under "Transcript representation and the formal boundary".
That translation, and the category choice of the local programs, are not
Lean declarations. This is an explicit human-proof boundary, not an
assumption of effective state or branch computation.

## What is actually proved computable

`Relative T f` is an abbreviation for Mathlib's
`Nat.RecursiveIn {oracle T} f`, where `oracle T(n)=Part.some(T(n))`.
It is the standard inductively generated partial-recursive-in-an-oracle
predicate, with pairing, composition, primitive recursion, and unbounded
minimization. It is not a new predicate defined to mean that the desired
algorithm succeeds.

`fourOracle F u v t d` contains exactly the four streams

    F(u), F(u-v), F(v-u+d*t), F(v-u+d*(t-1)).

It uses `Nat.pair(component,input)` for addressing. Component labels zero,
one, and two select the first three streams; every label at least three
duplicates the fourth. This is computably equivalent to a usual fourfold
interleaving and contains no fifth stream.

`infinite_oracle_substitution` proves uniform relative computability of
`(n,i) -> X_n(i)` for any stream sequence obtained by the two fixed
programs. `all_stage_proofs` constructs finite certificates from the local
`Runs` hypotheses by induction on the stage. `valid_sound` rules out false
certificates. `relative_search` proves the certificate search is genuinely
recursive in the single oracle `T`. No certificate existence or uniformity
assertion about the orbit is a premise of the final theorem.

`four_value_recovery` concludes both

    Relative T (n -> Part.some(r_n))
    Relative T (z -> Part.some(strictCut t z)).

The second conclusion includes totality on all rational queries.
The numerical real states occur in the correctness proof only.

## Cut encoding and termination

A natural query `z` codes a triple `(a,b,c)` by nested `Nat.unpair`.
`rationalQuery z = (a-b)/(c+1)`, interpreted in the reals.
Every rational has such an encoding; repetitions are harmless.
`strictCut t z` is exactly `1` when this rational is strictly below `t`,
and `0` otherwise. A fixed effective rational listing, as in the
manuscript, translates effectively to these triples.

The semantic definitions `rationalQuery` and `strictCut` are marked
`noncomputable`; this does not assert an executable real comparison.
The relative-recursion theorem proves that the same cut is computed instead
by the natural-number inequalities in `lower`, `upper`, and
`decodedAnswer`. For a finite integer `K >= 1/d`, they compare the query
with `S_N/N +/- K/N` by cross-multiplication. `recovery_core` handles an
arbitrary such bound, and `four_value_recovery` supplies one by the
Archimedean property. Since `d` is a positive rational, this integer can
also be obtained by rational arithmetic and adds no independent real data.

`decoding_terminates` proves existence of a successful search stage for
every query distinct from `t`. `irrational_query_ne` supplies that fact for
all coded rationals. Soundness and termination are separate lemmas.

## What compilation does not establish

Compilation does not prove that Borel maps have continuous comeager
restrictions, that the auxiliary-pair set is comeager, or that countable
fibers yield the distinguishing endpoints. Those arguments are provided
in `recovery.md`; the category inputs are separately recorded in the ledger.
Compilation also does not verify the human translation from arbitrary
oracle-machine indices to finite-transcript verifier codes, publication-level
novelty, any Slaman--Woodin citation, or the manuscript's unrestricted
rigidity theorem.

There are no user-declared axioms or proof holes in the formal source.
The printed axiom reports for the main declarations should contain only
the standard logical axioms `propext`, `Classical.choice`, and `Quot.sound`.
Independent Reviewer reading is required for statement fidelity and the
explicit human-proof boundaries.
