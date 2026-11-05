# Full matching-defect packing by proper-reservation induction

This note submits a complete proof of the arbitrary-q matching theorem
and of donorless reconstruction P. Independent correctness review is
pending. Originality and publication significance are separate,
unverified questions. Neither star configuration is claimed solved.

## 1. Exact theorem and inherited results

**Theorem.** Let D be a finite digraph with nonnegative integral arc
capacities. Suppose the condensation of its full topology has at most
two missing source-sink pairs, and these pairs have disjoint endpoints.
For every integer q >= 1, if every original dicut has capacity at least
q, there are q capacity-feasible original dijoins.

All original arcs, including zero-capacity arcs, determine reachability,
condensation and dicuts. A zero-length path counts. A dicut is the
outgoing boundary of a nonempty proper predecessor-closed shore.
A packing member is an original arc set. Distinguished capacity units
are labels for reconstructing these sets, not new resources.

The proof uses the following independently accepted campaign results.
They are inherited inputs, not new assertions proved by the finite
calculations accompanying this note.

1. The arbitrary-terminal, arbitrary-integral-capacity one-defect
   theorem and its original-capacity reconstruction:
   `NATIVE_ALL_Q_PACKING3256`,
   `../single_defect/terminal_support/marked_boundary/native_trace_packing.md`,
   Sections 6-9; Host handoff `4bee83ab7629/round-0002.json`.
2. The fixed-q normal form, original exceptional-shore classification,
   tight-cut gluing and reverse capacity-unit reductions:
   `TWO_DEFECT_NORMAL_FORM3256`, `packing.md`, Sections 1-3.
   Matching-class quotient closure is also explained in
   `matching_augmentation.md`, Section 5.
3. The exact nonnegative core/contact formula, contact-cycle alignment
   and actual donor trichotomy:
   `compatibility.md`, Section 3; `contact_paths.md`, Sections 1-3;
   accepted in `2a54498e2aad/round-0005.json`.
4. Ambient weighted threshold-two packing for the matching class and
   universal actual-reserve R2:
   `full_reserve_r2.cores.md`, Section 7;
   accepted in `75022f23ac72/round-0005.json`.
   No part of that completed proof or its certificate is reopened.

The existing focused scope lookup obtained no verified primary
two-defect theorem or counterexample. That is not a novelty verdict.
No additional external proposition, unavailable source, paired
integrality assertion or binary-to-multicolor extrapolation is assumed.
The reviewed endpoint-incidence pinning obstruction remains valid:
the new construction can recolor nonendpoint units.

## 2. The actual minimum of a subpalette

Fix a strict q-normal form with matching defects (s_i,t_i),(s_j,t_j).
Its original units have an ordinary q-partition covering family j.
Every q-tight original terminal has exactly one unit in each color.
Every positive unit touches such a terminal. Every exceptional cut
has capacity at least q+1, since it is not a terminal cut.

Write C_i for the accepted nonnegative core, and

    d_a = number of color-a units in C_i.

For a capacity vector x the exact family-i minimum is

    m_i(x) = x(C_i) + nu_i(x),

where nu_i(x) is the maximum matching number in the free contact graph
expanded into distinguished input and output unit vertices. Free
contacts are of the opposite missing-pair type j. If any such contact
is active, s_j and t_j are q-tight. Consequently every old color has
at most one free input unit and at most one free output unit.

Take a maximum matching M for the full unit vector. Direct each
matching edge from its output unit's color to its input unit's color.
The resulting color graph has indegree and outdegree at most one:
its components are directed paths, directed cycles and isolated colors.
For X a set of old colors, write M[X] for its induced matching edges
and c_X for the sum of its original unit vectors. Restricting a unit
matching is still a unit matching, so

    m_i(c_X) >= sum_(a in X) d_a + |M[X]|.                 (1)

This is a lower bound on the minimum of the actual reserved union.
It is not a sum of individual exceptional minima.

Let F be a family-i bad color with no actual donor. Then d_F=0 and
nu_i(F)=0, so M has no loop at F. For every other color a, d_a <= 1:
if d_a >= 2, (1) gives m_i(F+a) >= 2, and ordinary and family-j
coverage give minimum two on every other original cut. That would
be an actual donor. Thus all d_a are zero or one. Full exceptional
slack gives

    sum_a d_a + |M| = m_i(c_full) >= q+1.                (2)

If there are no free contacts, donorlessness and (2) are already
incompatible. In the remaining case the color graph above is valid.

## 3. Proper-reservation lemma

**Lemma.** In the preceding donorless setting, suppose a path component
Q of M contains at least two colors with d_a=1. There is a proper
subpalette X containing F, with

    2 <= r = |X| <= q-1,
    m_i(c_X) >= r.

Moreover c_X has minimum at least r on **every original dicut**.

**Proof.** Regard Q as a linearly ordered path; directions do not
matter when restricting its matching edges.

If F belongs to Q, choose a nearest count-one color u along that
path, and let X be the interval between F and u, inclusive. It
contains exactly one count-one color and r-1 matching edges. Hence
(1) gives m_i(c_X) >= 1+(r-1)=r. At least one other count-one color
of Q is outside X, so X is proper. Also F != u, so r >= 2.

If F does not belong to Q, choose two consecutive count-one colors
u,v in the path order. Let I be their inclusive interval and set
X=I union {F}. The interval has exactly two count-one colors and
|I|-1 matching edges. Thus

    m_i(c_X) >= 2+(|I|-1) = |I|+1 = |X|.

Suppose X were the full palette. Then Q=I contains all q-1 colors
other than F and exactly two count-one colors. The only remaining
component is F, which is isolated, not a loop, since F is bad.
Therefore |M|=q-2 and sum_a d_a=2, contradicting (2).
So X is proper here as well.

Every old color covers every ordinary cut and family j. Summing
those actual cut counts over X gives at least r. Inequality (1)
gives the same lower bound for every cut of family i. In a matching
configuration these are all original dicuts. No topology arc,
unit occurrence or capacity has been changed. QED.

There is no palette-width constant in this lemma. In particular it
does not contradict the accepted sharp ceil(q/2) reservation family.
The essential inequality is r<q, not a bounded r.

## 4. Inductive donorless reconstruction

Let H(r) denote the theorem in Section 1 for capacity lower bound r,
quantified over the entire matching class, not merely strict forms.

**Induction-step assertion.** For q>=3, assume H(r) for every r<q.
In any strict q-normal form, every ordinary q-partition covering
family j and containing a family-i bad color admits a common
original-unit recoloring preserving ordinary and family-j coverage
and strictly decreasing the number of family-i bad colors.

Choose a bad color F.

If F has an actual donor, their full reserved vector has minimum two
on every original cut. Accepted R2 replaces the two colors by two
original dijoins, with every outside unit unchanged. This is a
strict bad-count improvement.

In the cycle alternative of the accepted trichotomy, align the
distinguished output units by its one common permutation. The cycle
colors become original dijoins. If a bad cycle color is repaired,
the count has strictly decreased. Otherwise a count-one cycle
color has family-i minimum at least two while F is unchanged; it
is an actual donor for F. Apply R2 to that actual union. No new bad
color is introduced, and the composite operation strictly decreases
the count.

In the path alternative, apply Section 3 to the component containing
the supplied path. Its proper palette X contains F and has actual
original minimum at least r=|X|<q. Keep the **full original topology**
and give each arc its number of reserved unit occurrences in X as
capacity. Unreserved arcs remain present with capacity zero. The
condensation and missing-pair matching therefore do not change.
This is a legitimate input to H(r), even if its r-tight cuts or
positive support do not satisfy the old strict q-normal form.

H(r) supplies r capacity-feasible original dijoins in that reserved
vector. Distinguish their arc occurrences among the reserved original
units and relabel them by the colors in X. Each q-tight original
terminal had exactly r reserved units; each of the r new colors
meets its terminal cut. Thus every new color uses exactly one of
those units, and all r units are exhausted. Every reserved unit
touches a q-tight original terminal, so every reserved unit is used
exactly once. No original arc is duplicated within a color, and
no original capacity is increased.

Keep every outside unit in its old color. This is one common
rebalancing of original units, including any necessary nonendpoint
incidences. Every new color in X meets every original dicut. The
outside colors remain ordinary and cover family j, and acquire
no new family-i failure. Since F was in X, the bad count strictly
decreases. Tight-terminal saturation is preserved. QED.

This proves P(q) under smaller-parameter hypotheses, not under an
assumption of H(q). It gives the strict-decrease branch of P, so no
unchanged-F donor postcondition is needed in the path case.

## 5. Strong induction, quotient closure and reverse reconstruction

For q=1 the positive original support is a dijoin. If there are no
original dicuts, q empty members solve every q. A condensation with
more than one vertex and an isolated component would have a zero
dicut and cannot satisfy a positive lower bound.

H(2) is the independently accepted ambient weighted threshold-two
theorem. Inputs with at most one missing pair satisfy every H(q)
by the independently accepted one-defect theorem.

For q>=3 assume H(r) for every r<q. If H(q) failed, choose a failure
with the fewest condensation vertices and then least total integral
capacity, within the matching class. The accepted fixed-q reduction
is legitimate within that class. To spell out the relevant closure,
in any vertex-identification quotient followed by strong-component
contraction, choose an original source in each quotient source
preimage and an original sink in each quotient sink preimage. An
original path projects to a quotient walk. Each missing quotient
pair therefore gives a missing original pair between the chosen
representatives. Distinct quotient terminals have disjoint preimages.
Thus there are at most two missing quotient pairs, and two cannot
share a source or sink when the original missing pairs form a
matching. Every quotient dicut lifts to its original preimage cut.
Neither star theorem is needed.

The reviewed tight-cut gluing, path-unit shortening, reachable-contact
shortcut and large-capacity-arc reductions then give a strict failing
q-normal form with exactly two matching defects. Add one missing arrow
with capacity zero and apply the accepted one-defect theorem. This
produces an original-unit ordinary q-partition covering the other
exceptional family j; the added arrow has no selectable unit.

If the partition has a family-i bad color, Section 4 strictly reduces
its bad count while preserving all ordinary and family-j coverage.
Repeat. The count is a nonnegative integer initially at most q, so
at most q such improvements give a full original-unit q-packing.
Every recursive reserved call has parameter r<q. The fixed-q reverse
reductions have decreasing vertex or capacity measures. There is
no circular call to H(q) on a full palette.

This contradicts the strict failure. Strong induction proves H(q)
for every q. The accepted reverse tight-boundary gluing, unit-path
expansions and strong-component expansion preserve each original
capacity and cover every original dicut. This proves Section 1's
theorem on the original finite digraph, not only its normal form.
For unit capacities the resulting members are pairwise arc-disjoint.

**Corollary (unconditional P).** The exact donorless postcondition in
`contact_paths.md`, Section 3, holds for every q>=2. For q>=3,
use the proper palette from Section 3 and the now proved H(r);
Section 4 gives the required common strict-decrease reconstruction.
For q=2, a path with two count-one colors cannot also contain a
zero-core bad color, so the donorless path antecedent is empty.

Correctness of this induction is separate from its publication
qualification. Its improvement over accepted R2 is the complete
arbitrary-q and original-capacity conclusion. R2 alone does not
imply that conclusion; the new proper-reservation lemma makes the
capacity parameter decrease in the missing path branch.

## 6. Exact finite evidence and its scope

`donorless_full_unit.py` and its source-bound JSON data exercise the
proper-reservation lemma and original-unit reconstruction. They do
not establish the universal theorem by a bounded search.

### A native closing rotation really fails

The new q=5 and q=7 instances start with `contact_paths.md`, Section
5's path family, with bad color f=floor((q-1)/2). Replace color
zero's unit 2->7 by 2->H, where H has ancestors 0,2 and descendants
6,7. Add color zero's unit L0->7, where L0 has ancestors 0,2,3
and descendants 5,7. The old L has descendants 5,6,7. Remove the
passive topology arrows P_f->6 and N_(f+1)->6. All other topology
arrows, including 2->7 now at capacity zero, remain present.

The full contact matching still has edges P_c->N_(c+1), its core
counts are one at colors zero and q-1, and only f is bad. The actual
proper reserve {0,...,f} has minimum f+1 on every original cut.
But closing the usual output rotation gives color zero P_f->5
while retaining L0->7. On the actual ordinary ideal

    U = V minus Desc({P_f,L0}),

that color has no crossing. Its old crossing was P_0->5, and the
full original capacity of this cut is 2q-1. Thus an endpoint
closing rotation cannot be presumed ordinary.

Exchange the distinguished L0->7 unit with the L->7 unit originally
in color f, in addition to the path rotation. The endpoint can now
reach its retained direct root at sink 6. Internal path colors have
their actual contact pairs; the last recipient's L0->7 can reach
sink 5 through its new contacting output. This is one simultaneous
original-unit construction, not separately chosen recolorings.
The arrow-reversed q=5 instance checks the input-side counterpart.

The replayer verifies all original proper ideals, both exceptional
families, every actual donor union, the actual reserved minimum,
original unit identities and tight-terminal saturation. The typed
SAT request permits every original unit in the adaptive reserve
to change color, including nonendpoint units; only the proved-safe
outside colors are left unchanged. The model is checked against
every original cut, not just inclusion-minimal SAT clauses.

### Measured exact replay

The three new inputs have respectively 2,006, 12,905 and 2,006
proper original ideals, totaling 16,917. Their smaller reserve
parameters are 3,4,3. Each has no actual two-color donor before
the reconstruction. Both the explicit unit exchange and the
independently checked typed SAT model give a full original packing.

An exact abstract diagnostic also checks all 128,664 eligible path
obligations among 15,123 partial-injective color graphs for
2<=q<=6, with zero-one core counts, zero-core F, no F loop and
full score at least q+1. It covers 79,260 F-on-path and 49,404
F-outside-path obligations. This is finite evidence for the new
lemma, not the proof of its arbitrary-size conclusion.

The combined SAT formula has 204 variables and 430 clauses.
All twelve targeted tests pass, including the full-palette
strict-slack corner, matching endpoint and core-count rejection,
arrow reversal, no-dicut encoding, exact positive-clause
subsumption and refusal of UNKNOWN, timeout and source mismatch.

The inspected sidecar contract is `sat.solve`, with its bounded
canonical CNF, typed SAT/UNSAT/UNKNOWN outcome and source-bound
assignment. Discovery and contract JSON files use this note's
prefix. Positive cut clauses are reduced only by duplicate removal
and exact subset subsumption: meeting a subset boundary meets every
superset. The maintained `sat.cnf.canonicalize` operation supplies
the required canonical ordering without changing this formula.
An initial ordering rejection and its exact payload and structured
error are preserved under the `jacobian_rejected` prefix; it is
not a mathematical conclusion. Adapter errors, timeout and UNKNOWN
are likewise non-conclusions. No Lean source or kernel certification
is claimed.

Both successful typed operations exit zero on Jacobian 0.14.0,
protocol 2025-11-25, with no timeout or structured error.
The exact source, payloads, outputs, statuses and initial rejected
request remain under the `donorless_full_unit` prefix.
The certificate can be replayed without a solver or sidecar:

```bash
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/two_defect/donorless_full_unit.py replay
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/two_defect/donorless_full_unit.test.py -q
```

For a fresh typed solve, run `prepare`, `canonicalize`, `bind`,
`solve`, then `replay` with the same interpreter and source.
No accepted R2, one-defect or prior endpoint certificate is rerun.

Independent Host review must read Sections 2-5, especially the
properness argument when F is outside the path and the use of the
ambient smaller-r theorem on the unchanged full topology.
Publication originality and significance remain unverified.
