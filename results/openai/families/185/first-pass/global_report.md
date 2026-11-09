# Unconditional global verification of manuscript 185

The target is the original `thm:main`: two actual infinite matroids on one
countably infinite ground set, each equal to its dual on the same labels,
admitting neither an independent covering nor a mixed packing/covering
partition. No restriction to bases, disjoint covering sets, finite sets,
or a conditional rank model is substituted.

The source-level adversarial audit found no mathematical flaw in the
ultrafilter rank, simultaneous reservations, or continuum recursion.
The complete unconditional theorem now passes the official Lean 4.31.0
check: compiler and audit exit statuses are zero, `proof_holes=[]`,
there are no undischarged assumptions, and all 17 transitive axiom
reports contain only the standard axioms `propext`, `Classical.choice`,
and `Quot.sound` (or no axioms). The exact result is recorded in
`research/verification/global/exact_certificate.json` and the archived
official certificate
`research/verification/global/lean/certificates/C_MAIN_COUNTEREXAMPLE-2b0206953d415214.json`.
Independent Reviewer replay and statement-fidelity acceptance remain required.

## What improves on the prior certificate

The independently approved `C_LOCAL_INTERVALS` certificate established the
two local rules with the original infinite quantifiers and strict boundary
conventions. It did not establish the rank model, the transfinite assembly,
an actual matroid, or the double-ray obstruction. Those analytic artifacts
are preserved, not recompiled or reassessed here.

The primary implementation at `openai/math` commit
`4eaee87548250b2682affda7d05d947c05554bae` already contains a complete
unconditional proof, not merely a conditional `RankModel` interface.
The present work checks that global proof closure and adds explicit
certification statements exposing the constructed witnesses, maximal
extension, literal closure-and-contraction packing/covering convention,
and both coordinate orientations. This is a formal verification of an
existing mathematical result, not a new counterexample or a claim of
new mathematical novelty.

## The unresolved construction arguments

For a finite collection of distinct binary-string columns, sufficiently
long prefixes are distinct. Evaluation of the full truth table on those
arguments is exactly uniform. Consequently, every consistent finite
positive A-pattern and signed G-pattern has positive density, even
after intersection with any further finitely many positive A-columns.
This proves positivity for the concrete larger ideal K, not just for
the density-zero ideal J.

To construct the ultrafilter, exclude every set contained modulo K in
infinitely many G-columns. In a finite intersection of these exclusions,
choose one witnessing G-index per forbidden set outside the finitely
many required positive indices. The signed G-pattern is K-positive;
its intersections with the forbidden sets are K-small. Removing these
and the finitely many other K-small exclusions leaves a nonempty set.
The ultrafilter extension therefore avoids K and every forbidden set.
There is no countable-completeness assumption.

Enumerate the large sets on the initial continuum ordinal and take the
least index whose enumerated set is contained modulo K in X. Rank is
antitone under inclusion modulo K and invariant under K-small symmetric
differences. For thinning between a small s and a large X, each
`F_xi intersect (X \ s)`, for `xi <= gamma`, rules out only finitely
many G-indices. Their union has cardinal at most
`max(aleph_0, |gamma+1|) < continuum`. A remaining G-column gives
`s union (X intersect G_t)` of rank exceeding gamma. This argument
does not replace a singular continuum by a regular one.

For reservations, one failing cell from each of q distinct bad indices
can be avoided on exactly the fraction `(3/4)^q` of each sufficiently
late block. If all q failing intersections with S tend to density zero,
the positive upper density of S is bounded by `(3/4)^q`. Thus a fixed
positive S has only finitely many bad indices. A family of cardinal
lambda below the continuum again excludes at most
`max(aleph_0, lambda)` indices. The two remaining cells are disjoint,
K0-small, and meet every family member J0-positively. Arbitrary S,
including sets with no density limit, are covered.

At stage alpha of the recursion there are at most two prototypes per
predecessor, hence fewer than continuum many. Reservations in the gap
preserve the two endpoints' zones modulo K0, while enforcing positive
directed differences modulo J0 from every old prototype. Rank-raising
thinning crosses the remaining Lower-to-Upper interval. Adding the new
prototype and its complemented, oppositely ruled partner preserves all
old bases and complement closure. Taking unions at limit stages is
legitimate because every pair of old prototypes already occurs below
a common later stage; there is no supremum-of-small-cardinals step.

## Actual matroids and the obstruction

The assembled family is nonempty, an antichain, complement-closed,
invariant under a single balanced swap, and meets every required
interval. Independent sets are subsets of bases. For finite gaps,
the family of possible independent extensions is finite and has a
maximal member. For infinite gaps, a basis below I forces I itself
to be a basis; a basis between I and Y is a maximal extension; a
basis above Y makes Y independent. This is the complete (IM) axiom,
not just finite exchange or existence of a maximal set on the whole
ground set. `BasisSystem.matroid` constructs a Mathlib `Matroid`.
Complement closure then gives literal equality with its dual.

The ray component maps preserve the bundle's D-label. For negative
vertices L is e_n and R is e_(n-1); for nonnegative vertices L is
e_(n-1) and R is e_n. Both middle L-coordinates are e_(-1). The
two parity component families each partition the same ground set.
Their direct sums are actual matroids, and their self-dualities are
equalities, not isomorphisms.

For any independent covering, remove overlap to obtain a partition.
Exactly one central label set belongs to the ultrafilter. On its
outward ray, extending a vertex's assignment to a local basis gives

    rank(x_k) >= rank(u_k) > rank(y_k) >= rank(x_(k+1)).

All four sets evaluated by rank are large. The next vertex receives
the complement of the previous vertex's outward assignment. This is
an infinite descending chain in a well-order, a contradiction.

For a mixed packing/covering partition, self-duality makes complements
of the independent contraction sets spanning on C. Combining those
with the disjoint spanning sets on P gives disjoint spanning sets on
the whole ground set. Their complements would be an independent
covering. The new bridge proves that the implementation's
`(M.dual restricted to C).dual` is precisely the actual contraction
of `univ \ C`; its other bridge identifies spanning with the literal
closure-equals-P condition in the manuscript.

## Evidence and boundaries

`research/verification/global/verify.py` binds the construction sources
to the pinned primary implementation and builds the 17 global modules,
reusing the eight approved analytic modules. Compiler copies disclose
the proof-only API compatibility changes needed for Lean 4.31.0, including
the explicit well-foundedness argument of the minimum-bound lemma; the
original sources and all mathematical statements are retained.
A fresh official `lean_evidence verify` run checks the
global source and records evidence on `C_MAIN_COUNTEREXAMPLE`.
All 17 transitive axiom reports pass this standard-axiom requirement.
The fresh source-bound official result closes `C_MAIN_COUNTEREXAMPLE`
mechanically; the earlier unsuccessful compiler run is retained as
inconclusive evidence on the superseded source version, not a refutation.
Both official campaign-local checks pass at
`campaigns/9000185`.

The exact finite cell counts and the saved typed Jacobian
`sat.assignment.check` result are supplementary finite experiments.
They are not substitutes for the infinite proof. The Jacobian operation
checks the actual membership pattern `a=false, b=true` of the second
reservation cell against its A-complement predicate. Its exact payload,
typed output, protocol, server version, and adapter status are preserved
in dedicated JSON files.

The proof uses no external literature theorem left as an assumption:
the matroid criterion and mixed reduction are proved in the compiled
closure. The manuscript's unrelated intersection and separate universal
conjecture consequences are outside this mission. No literal manuscript
assertion has been demonstrated false, so no `F_` refutation claim or
refutation judgement is manufactured. Publishable significance and
novelty are questions for the independent Reviewer; compiler success
alone does not settle them or terminate the larger campaign.
