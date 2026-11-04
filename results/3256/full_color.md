# Full-color extension on the original support

## Statement and source boundary

The live assertion is still unproved. Fix q>=3 and the reviewed
transitive, acyclic, capacity-minimal support/contact normal form in
`../packing.md`, Sections 4-6. All passive topology is retained. Let E
be the distinguished positive-capacity units, T the original q-tight
terminals, U* the reviewed canonical exceptional ideal, and B its actual
positive boundary units.

Every unit meets T, every terminal in T has q units, and |B|>q.
Schrijver, *Min-max relations for directed graphs* (1982),
DOI 10.1016/S0304-0208(08)72456-3, Theorem 4, printed page 271,
supplies a partition of E into q ordinary original-dicut covers after
adding only the passive arc s->t. The actual statement was read in
`../../../literature/schrijver1982-theorem4.txt` and its proof in
`../schrijver_theorem4_pages.txt`. It does not supply marked-color
preservation or the exchange assertion below.

Write b(J) for the number of colors of an ordinary completion partition
J that miss actual B. There are finitely many unit partitions and at
least one ordinary partition, so a global minimum b_min exists.

**Open full-color assertion.** For every such normal form, b_min=0.

This assertion permits arbitrary simultaneous recoloring among all q
colors. It imposes neither a prescribed bad/donor reservation nor a
prescribed assignment of B. Full native paired LP integrality remains
retired for the independently reviewed reason in `global_extension.md`.
The known weighted Schrijver counterexample has three missing pairs,
not one; its reviewed transcription does not refute this assertion.
No new source lookup is being claimed by rereading the saved excerpts.

## Conditional reconstruction, with no universal reserved-pair hypothesis

**Proposition.** If the open full-color assertion holds for every q>=3
normal form above, W(q) holds for every q>=3 and the original arbitrary-size
one-defect unit-capacity packing theorem follows.

**Proof.** Suppose W(q) fails. The reviewed minimum-counterexample,
fixed-topology splitting, contact and canonical-boundary reductions give
exactly a representative of the stated normal form. A minimizing ordinary
partition exists by the source theorem and finiteness.

By the asserted b_min=0 every color meets actual B. The reviewed canonical
dominance holds for each individual subset of original active arcs.
Consequently every color covers every exceptional original dicut as well
as every ordinary one.

At an original q-tight terminal the q colors cover its terminal dicut,
which has exactly q units. Hence each color uses exactly one unit there,
and all units of that terminal are used. Every positive unit touches such
a terminal, so all units are assigned. In particular, no color can use
two copies of the same original arc. Forgetting unit labels gives a
capacity-feasible original q-packing.

This contradicts the choice of a weighted counterexample. Equivalently,
reverse each reviewed splitting or shortcut operation with its original
unit identities; its all-original-ideal cut inequality supplies coverage,
and its two restored path capacities supply the required units. Tight-cut
gluing and strong-component expansion retain their reviewed meanings.
Apply this weighted conclusion to the original unit instance. The
zero-defect case is Schrijver's theorem, q<=1 is trivial, and q=2 in
the original unit class is the independently reviewed ACZ v3 P1 result.
No weighted q=2 conclusion is used. QED.

This is a conditional reduction, not a proof of its antecedent. It removes
universal prescribed-pair compatibility from the required route; it does
not establish an unconditional enlargement of the reviewed packing scope.

## Exact simultaneous permutation model

Fix any ordinary completion partition J and let c(e) be the old color of
unit e. At every v in T there is exactly one unit of each old color.

**Permutation lemma.** All partitions of E that cover every tight terminal
are exactly the following compatible terminal-permutation assignments.
Choose a permutation sigma_v of the q colors for each v in T. If unit e
has two endpoints u,v in T require

    sigma_u(c(e)) = sigma_v(c(e)).

Assign e the image of its old color at any incident terminal in T.
For every original ordinary ideal U the necessary and sufficient remaining
condition is

    sum_(e leaving U) [new_color(e)=i] >= 1    for each color i.

Actual B coverage is exactly

    sum_(e in actual B) [new_color(e)=i] >= 1  for each color i.

**Proof.** Compatibility makes the assigned color well-defined. A
permutation assigns all q colors once at each tight terminal. Conversely,
any terminal-covering partition assigns all q colors once there because
there are only q units, and therefore defines a unique sigma_v relative
to the old coloring. A doubly incident unit has one new color, so those
permutations agree on its old color. The displayed cut counts are the
definitions of the two remaining coverage requirements. Every unit is
assigned exactly once, and repeated copies of an original arc cannot
share a color because they meet a common tight terminal. QED.

Thus global minimization is over compatible permutations satisfying
**all** original ordinary inequalities, not merely terminal equations.
One terminal permutation can be fixed to the identity by relabeling all
new colors; this is a search symmetry, not an exchange theorem.

### Endpoint bookkeeping for genuinely multicolor exchanges

For a proposed compatible recoloring and color i, orient each newly
acquired unit forward and each lost unit backward. Unchanged units do
not occur. At a tight terminal either no unit changes membership in i,
or exactly one acquired and one lost unit occur. Its divergence is zero.
Pair those two incidences.

**Endpoint lemma.** Pairing at tight terminals decomposes the signed
units into alternating paths with endpoints outside T and cycles.
For each path P let a_P,z_P be its positive and negative divergence
endpoints. For every original ideal U,

    new_J_i(U)-old_J_i(U)
        = sum_(paths P) ([a_P in U]-[z_P in U]).

Cycles contribute zero. The sum of the color divergences at every
original vertex is zero.

**Proof.** On the positive support, tails have no positive incoming arcs
and heads have no positive outgoing arcs. Acquired and reversed lost
units therefore pair with the required directed incidence at a tight
terminal. Each signed unit has at most one paired continuation at each
end. Its component is a path ending at unpaired, non-tight incidences,
or a cycle. A path may have coincident original endpoints, in which
case its total divergence is zero. Summing the divergences along each
component telescopes to the stated endpoint vector.

For an original ideal, every original unit u->v has cut indicator
[u in U]-[v in U]. Summing signed unit indicators therefore gives the
displayed identity. Summing over colors cancels each unit's acquisition
against its loss. No passive arc is removed, and no endpoint transfer
is asserted to be an original topology arc. QED.

If old color i misses B, a path in this decomposition can acquire at
most one actual B unit: its signed contribution on U* is its number
of acquired B units, since there is no lost B unit, whereas its endpoint
contribution belongs to {-1,0,1}. Every acquired B unit of the bad color
therefore lies on a path from U* to its complement, not on a cycle.

The paths for different colors are **coupled** by the common assignment
of every original unit. This bookkeeping does not permit their independent
selection. To complete the proof one must construct a compatible coupled
selection preserving every ordinary lower bound and every previously good
B color while creating a new good color, or prove a global extremal
contradiction. No such selection or contradiction is established here.

`multicolor_exchange.md` now proves an arbitrary-size receiver-safety
lemma for internal B exchanges at a shared tight terminal. Donor safety
has an exact canonical-SCC test; every failure has a nonterminal
original ordinary blocking cut of capacity at least q+1, with surplus
in another color. That surplus is not a justified simultaneous exchange.

`terminal_path_exchange.md` extends receiver safety to all
terminal-feasible vertex-simple alternating B paths, each of at most
seven units, in arbitrary-size normal forms. Direct B units,
changes at s,t, non-tight endpoints and changed contact bits are
handled without kernels. Every failed donor has a canonical
smallest/largest ordinary blocker and strict surplus.

The new arbitrary-width q=3 family has **no** safe internal
alternative and **no** donor-safe single B path. A direct B path
and a non-B two-unit companion nevertheless pack it by seven
original-unit recolorings, preserving every original cut and all
passive topology. Width three is independently rerunnable with
an exhaustive exact low-cut deletion certificate and a dedicated
typed SCC comparison. Thus single-B-path-only descent is ruled
out as an unconditional local lemma, not as an argument additionally
using positive global minimality: this family's bad state is not
globally minimizing. Selecting compatible
companions across arbitrary donor blockers is still the exact
missing assertion; the reconstruction above remains conditional.

`companion_selection.md` now proves a necessary condition at a
**positive global minimum**. In each bad/multiple-B reserved pair,
all binary ordinary repartitions would have to equate every actual
B coordinate, even though no such equality follows from the entire
ordinary two-cut parity graph. Thus the integer hull would have
strictly smaller affine dimension than its real ordinary interval
polytope. The two-cut non-forcing proof uses the primary one-color
connector convex-hull theorem, not an assumed two-color theorem.

That note also exactly refutes **ordinary-only** paired integrality
on a new native q=3 original input: no actual-B inequality occurs
in the determinant-two active basis. This closes the weaker
integrality question left open in `global_extension.md`.
It does not refute binary existence or the weaker affine-spanning
criterion: all 128 compatible assignments of the new reserved
fiber are checked, 64 are ordinary and 32 split B, with full
integer affine dimension seven. Universal exclusion or removal
of a hidden B equality, possibly using additional colors, remains
unproved. No full-q reconstruction or publication certification
is inferred.
The accompanying complete finite classifications find two-unit repairs
for all 128 positive-bad contact partitions and all 240 eligible contact
reservations. The fork input has no bad ordinary partition at all.
Neither fact eliminates a positive minimum on arbitrary inputs or
completes the conditional reconstruction.

`boolean_quotient.md` strengthens the accepted two-cut separation:
**every actual B unit lies in its own two-cut component**, and every
prescribed B singleton extends to an original receiver dijoin preserving
all ordinary two-cuts and q-tight terminals. Exact Booleanization gives
integral one-color component polytopes with no nonautomatic ordinary
clause on fewer than three components. A positive minimum would require
their actual-B binary sets to have no antipodal pair.

With exactly three components and three B units, this forces precisely
the known Q6 odd-parity tetrahedron and three original ordinary reserved
three-cut facets. Exact rational classification of all 64 mixed-clause
systems agrees; seven prescribed-singleton witnesses on the two existing
native inputs are expanded to every original ideal. This does not realize
or exclude Q6 in the original one-defect topology, or justify treating a
component identification as a graph minor. Universal topological exclusion
or compatible multicolor descent is still missing, and all reconstruction
above remains conditional. The stronger new lemmas await independent review;
the independently certified full-packing scope is unchanged.

## Rank-four continuation

The Host accepted the native h<=3 theorem in round twelve.
`native_rank_four.md` now submits its computer-assisted extension to
h<=4. Complete exact four-variable classification leaves two
three-marked and four four-marked models. Original unit-shore
signatures, the threshold-two internal-footprint bound and actual
direct anchors exclude them, including the possible degree-three
non-tight terminal. Original tight-shore reconstruction is supplied
for this rank-bounded theorem.

If accepted, every bad/multiple-B reservation at a positive global
minimum must have h>=5, strengthening the reviewed h>=4 obstruction.
The independent anchor-incidence argument in `six_terminal_packing.md`
gives h<=|S|+|K|-2. Together these yield a submitted integral-capacity,
all-q packing theorem when the condensation has at most six sources
and sinks in total; that note separately justifies q=2 and closure
of the bounded-terminal class. Williams's earlier four-s-path theorem
is recorded as essential prior art, not ignored in the novelty claim.
Neither arbitrary larger-rank exclusion nor compatible multicolor
descent is established. The full-color assertion and unrestricted
reconstruction above remain unproved; independent correctness,
originality and publication-significance review is still required.

## Finite marked-pattern test

`full_color.py` encodes all original unit assignments on the saved
17-vertex q=3 contact input. The test retains the exact five-unit B
pattern whose prescribed two-color exposure extension was independently
excluded, but frees every original third-color unit. It asks for three
original dijoins, using no surrogate or new capacity.

The CNF enforces one color per distinguished unit, one unit per color at
every tight terminal, and every original ordinary cut plus actual B.
The returned assignment must be checked again against every original
proper ideal, including exceptional ideals, and against the compatible
permutations and original arc identities.

The inspected `sat.cnf.canonicalize` and `sat.solve` operations returned
a source-bound SAT witness for 60 Boolean variables and 1840 clauses.
The adapter server is 0.14.0, protocol 2025-11-25; both adapter exits were
zero, with no structured error or solver exhaustion. Dedicated JSON
files under `../../jacobian/full_color_*` retain the exact requests,
typed outputs and exit statuses.

The independently rerunnable assignment is
`full_color_certificate.json`. It retains all 57 original transitive
topology arcs, including the original p->n contact, and all 20 original
capacity units. All 579 original proper ideals, including 578 ordinary
ideals, have at least one unit of each new color. Actual B counts change
from (0,5,2) to (3,3,1). The fixed five-unit pattern is unchanged:

    J1:3 b->r1 : 1       J1:4 c->r2 : 0
    J1:5 PB->y : 0       J1:6 PB->z : 1       J1:7 PB->w : 1.

The old third-color units a->r1 and Q->w become color zero. At a the
terminal permutation is the genuine three-cycle (old 0,1,2)->(1,2,0).
The two distinguishable Q->w units and the two c->r2 units remain
separately assigned; no color repeats an original arc.

This contrasts with the reviewed **prescribed marked-pattern** extension
exclusion in `extension.md`, not with universal existential reserved-pair
infeasibility. The old reservation also has other reviewed feasible
packings. Its unchanged exclusion and those packings were not replayed.
The present result shows that freeing the third color can extend this
particular excluded pattern; it does not prove a universal marked extension.

Since the new partition has zero bad colors and the objective is
nonnegative, it certifies the global optimum b_min=0 **for this one input**.
It is a finite positive construction on a weighted active/passive input,
not an all-unit counterexample or an arbitrary-size packing theorem.

```bash
python3 -B research/single_defect/terminal_support/marked_boundary/full_color.py verify \
  --named research/single_defect/jacobian/full_color_named_payload.json \
  --certificate research/single_defect/terminal_support/marked_boundary/full_color_certificate.json
python3 -B -m unittest discover \
  -s research/single_defect/terminal_support/marked_boundary \
  -p test_full_color.py -q
```

UNSAT without an independently replayed refutation, UNKNOWN, adapter
failure and timeout would certify neither a theorem nor a counterexample.

## Why freeing all colors is not an LP-integrality proof

Let P_q be the natural full-color relaxation with nonnegative coordinates
y_(e,i), one color in total per unit, one unit of each color per tight
terminal, every ordinary original cut covered in each color, and actual
B covered in each color.

**Relaxation lemma.** The uniform point y_(e,i)=1/q is feasible for every
stated normal form, strictly satisfying every nonterminal original cut
and actual-B lower bound. Nevertheless P_3 on the saved contact input is
nonintegral.

**Proof.** Unit sums equal one, and each tight terminal has q units,
so its color sum is one. Every original dicut has at least q units;
every nonterminal one has at least q+1. In particular the actual B
color sum is |B|/q>1.

For the second assertion, take the face of P_3 fixing every original
J2 unit to color two and every other unit's color-two coordinate to
zero. These are coordinate faces of the nonnegative unit simplices.
The fixed J2 already covers every ordinary original cut and has two
actual B units. The color-two cut inequalities therefore impose no
additional restriction.

The other coordinates satisfy y_(e,1)=1-y_(e,0) on the fourteen exact
reserved units, their degree-two tight-terminal equations, every paired
ordinary interval and both reserved actual-B bounds. By the reviewed
endpoint equivalence this face is affinely isomorphic to the native
paired endpoint relaxation. Its independently reviewed vertex
(H,A,B,C,Z,W)=(1/2,1/2,1/2,0,0,0), with active determinant two,
is therefore a vertex of this face and of P_3. It is fractional.
Its full-color actual-B weights are (1,4,2). QED.

This uses the already reviewed exact fractional certificate, not a
repeat computation or a newly claimed binary obstruction. Freeing
third-color coordinates can supply integer solutions while retaining
this fractional face. Neither the uniform point nor nonintegrality
decides integer existence.

In particular, ordinary linear infeasibility/Farkas reasoning on P_q
cannot supply the missing integer step: P_q has the explicit uniform
feasible point. An extremal contradiction must use additional valid
consequences of integral compatible exchanges, not merely reassert the
original cut lower bounds or appeal to one-color integrality.

## Exact remaining gap

Round eleven accepted prescribed actual-B singleton selection and
the necessary three-component Q6 quotient, but not its native
exclusion. The new working `native_rank_three.md` proves paired
repair when the original ordinary reserved-two-cut graph has h<=3.
Its actual tight-shore component identity h=h_L+h_R-1 reduces a
smallest auxiliary failure to terminal paths. An analytic original
shore-mask argument excludes their Q6 configuration, independently
corroborated by all 978 relaxed path signatures. Reverse tight
gluing reconstructs that original pair without losing passive
topology, contacts or unit labels. This proof awaits independent
Host review; the known abstract Q6 model is not claimed new.

The resulting positive-global-minimum obstruction is **h>=4 for
every bad/multiple-B reservation**, not nonexistence of a positive
minimum. No argument excludes the larger native non-polar systems
or supplies a compatible actual multicolor bypass. There is no
proved reduction of those systems to Q6, and identifying arbitrary
two-cut components is not a graph-minor operation. The unrestricted
zero-bad-color theorem and full-q reverse reconstruction remain
unproved, with no original all-unit counterexample or verified
publication-level novelty and significance. The route remains open.
