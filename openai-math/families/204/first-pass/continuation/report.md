# Continuation of type-D schedules

## Scope and source contract

This investigation concerns `prop:continuation` in
`research/openai_manuscript/Tensor-Saturation-for-Even-Spin-Groups-September-24-2026/build/sections/03-lattice-continuation.tex`,
lines 332-490, including `int:half-kernel`, lines 233-280. The objective remains
exploratory and the research target remains publishable. The prior ledger
contained only the campaign goal, with no established mathematical result.

The schedule definition is `02-real-schedules.tex`, lines 38-54. A switch
changes the frame from `w` to `s_beta w`, requires
`y(t).beta >= 0` and `-beta.w.mu >= 0`, and has coefficient
`-beta.w.eta(t)`. Simultaneous switches have a specified order. Shapes have
dominant increments, not necessarily constant slope. Endpoints are Weyl
translates of the final label. Integral means every switch coefficient is
an integer; it does not mean a saturated Lakshmibai--Seshadri chain.

The continuation proposition is conditional on the standing absence of an
integral schedule. A qualifying local link must satisfy all three conditions
at lines 302-313: full root-lattice generation and half-integral base
coefficients; an orientation feasible in the modified cluster for every
sufficiently small positive parameter; and a forgetting operation at every
other cluster. An arbitrary lattice relation or arbitrary real schedule is
not, by itself, a counterexample to this proposition.

The half-kernel lemma asserts integral extrapolation, coordinate bounds for
both coefficient systems, and a common potential. Continuation additionally
requires strictness after deletions, admissible rank-two replacements,
termination of sorting, and closedness plus right extension at the supremum.
These are separate obligations, not consequences of passing a finite test.

## Main-theorem dependencies

The following are manuscript assertions being audited, not assumptions
accepted as theorems.

| Assertion | Source | Role |
|---|---|---|
| Type-D saturation, `thm:main` | `01-introduction.tex:33-42` | Campaign theorem |
| Basic real schedule, `prop:basic-schedule` | `02-real-schedules.tex:108-119` | Moment solution to rank-many switches |
| Schedule to moment, `lem:schedule-moment` | `02-real-schedules.tex:290-325` | Block restrictions and real feasibility |
| Integral schedules, `thm:integral-schedule` | `03-lattice-continuation.tex:19-31` | Arithmetic path construction |
| Combining blocks and exceptional case | `03-lattice-continuation.tex:54-161` | Reduction to two odd unbalanced components |
| Half-kernel and potential, `int:half-kernel` | `03-lattice-continuation.tex:233-280` | Bounded arithmetic direction |
| Continuation, `prop:continuation` | `03-lattice-continuation.tex:332-490` | Local feasibility to integral endpoint |
| Strict count, `prop:strict-count` | `04-moment-knots.tex:146-170` | Spectral inequality in exceptional case |
| Knot count, `prop:knot-count` | `04-moment-knots.tex:338-647` | Uses continuation to rule out losses |
| Fundamental columns, `prop:columns` | `05-columns.tex:9-19` | Integral schedule to tensor occurrence |
| Flag composition, `lem:flag-composition` | `02-real-schedules.tex:197-211` | Cartan-summand nonvanishing |
| Zero-tail reduction, `prop:zero-tail` | `06-zero-tail-completion.tex:19-32` | Smaller-rank doubled occurrence |
| Final assembly | `06-zero-tail-completion.tex:517-565` | Integral schedules, columns, zero tails |

Only the continuation branch is selected here. A result on that branch
does not certify moment counts, column intertwiners, zero-tail removal, or
the final saturation theorem. The rank induction and absence-of-integral-
schedule reduction must remain visible in any verification of continuation.

## External dependencies and failed routes

No external literature theorem is needed for Theorem A below. The source's
signed-graph references are background, not evidence that the asserted half-
kernel or sorting statements hold. The manuscript corollary alone assumes
its exceptional-case rank exclusion, explicitly recorded as
`C_CONTINUATION/A_EXCEPTIONAL_RANK_EXCLUSION` in the ledger. Its source is
the locally available manuscript lemma; its proof is not accepted here.
No previously retired route was present in the campaign ledger. A bounded
search with no witness will not be classified as verification or completion.

## Independent theorem: continuation or rank drop

Write `n` for the rank, `k=n+1`, and let `Q(D_n)` be the even-sum
integer lattice. Use exactly the schedule definition above.

**Theorem A (corank-one continuation alternative).** Let `n>=2`. Let the
labels have integral root pairings. Let the shape have slopes in the
relative interior of the smallest chamber face containing its endpoint.
The shape may have arbitrary finitely many breaks. Suppose there is an
exact admissible schedule with `k` switches whose position roots
`beta_1,...,beta_k` generate `Q(D_n)`. Suppose, for some `0<s0<1`,
its coefficients are

    m(s0) = a - (1-s0)d,

where `a` is an integer vector and `2d` is either primitive integer
generator of the one-dimensional relation space of the position roots.
Then at least one of the following exists for the same labels and shape:

1. an integral schedule;
2. a schedule with at most `n` switches and a proper position-root span.

At any interior continuation point, sorting at a fixed sufficiently nearby
parameter needs at most

    (n(n-1))^(n+1) - 1

rank-two replacements or orthogonal commutations.

The theorem assumes neither a moment solution, the rank induction, the
two-odd-component description, a bound on zero moving coordinates, nor
generic break values. It makes no claim that alternative 2 is impossible
without additional information. This distinction is essential.

### Proof 1: the integer relation and both derivative bounds

For a signed root graph, changing axis signs changes neither determinant
magnitudes nor parity of an integer coordinate sum. A connected balanced
component has rank one less than its number of vertices. A connected
unbalanced component has full rank and generates its even-sum lattice:
choose a spanning tree, use its signed identifications to turn its edges
into coordinate differences, and use an inconsistent cycle to obtain
twice one coordinate. The differences and that doubled coordinate generate
exactly the even-sum lattice. This argument also allows repeated edges
and unbalanced two-edge cycles.

Thus a root list generating `Q(D_n)` has a connected unbalanced graph.
Deleting one of its `n+1` edges leaves at most two connected components.
If the remaining square root matrix is nonsingular, each component must
be unbalanced and unicyclic: each needs at least as many edges as
vertices, and the total numbers are equal. Removing leaves contributes
unit factors to its determinant. On the cycle the last equation has
coefficient `2` or `-2`. Consequently every nonzero maximal minor of
the augmented matrix `B` has magnitude `2` or `4`.

The gcd of these minors is exactly two, without any saturation
assumption. Every column has even sum, so each minor is even. Conversely
the standard root-lattice basis `D` has determinant of magnitude two.
Since `B` generates the lattice, `D=B U` for an integer matrix `U`.
Expanding `det(B U)` by multilinearity expresses `det(D)` as an
integer combination of the maximal minors of `B`. Their gcd therefore
divides two. The signed cofactors divided by two give a primitive
integer kernel vector `c`, with

    Bc=0,    gcd(c_i)=1,    |c_i|<=2.

Put `d=c/2` or `-c/2`. Let `p_i=s_beta_i ... s_beta_1`,
`gamma_i=p_(i-1)^(-1) beta_i`, and let `Gamma` have columns `gamma_i`.
Each `gamma_i` is `beta_i` plus an integer combination of its
predecessors. This triangular change and its inverse are integral
unimodular, so `Gamma` generates the same root lattice.

For any real coefficient vector, set

    G_i = lambda.beta_i - sum_(j<i) m_j (beta_j.beta_i) - m_i.

Its linear part `H` is integral triangular with diagonal `-1`.
Here is a direct proof of the velocity balance, including its dependence
on arbitrary coefficients. Put `u_i=lambda-sum_(j<i) m_j beta_j`.
Then

    s_beta_i (u_i-m_i beta_i) = u_i-G_i beta_i.

Applying the preceding inverse frame and inducting gives

    p_k^(-1)(lambda-Bm) = lambda-Gamma G.

Taking linear parts gives `Gamma H = p_k^(-1) B`. Therefore `Hc` is
a primitive integer kernel vector for `Gamma`: it is nonzero and
primitive because `H` is unimodular. Applying the same minor argument
to `Gamma` proves `|(Hc)_i|<=2`. In particular

    |d_i|<=1,    |d_i^G|<=1,    d^G=Hd.

All extrapolated gaps `G_i(1)` are integers because `a` and the
root pairings of `lambda` are integers.

Individual root orientations cause no omitted algebraic cases. If `S`
is a diagonal matrix of column signs, then `B'=BS`, `Gamma'=Gamma S`,
`c'=Sc`, and `H'=SHS`. Thus both primitive-coordinate bounds and the
potential identity are unchanged. The bounded script can consequently
use one representative of each root line.

### Proof 2: common potential, without a spectral theorem

For each prefix,

    p_(i-1)-p_i = beta_i gamma_i^T.

Summing gives the exact telescoping identity

    B Gamma^T = I-p_k.

Write `P=p_k`. It is orthogonal and `det(P)=(-1)^(n+1)`. The identity

    (-P)(I-P)^T = I-P

implies

    det(I-P) = (-1)^n det(P) det(I-P) = -det(I-P).

Hence `I-P` is singular over the real field. Choose a nonzero fixed
vector `L0` of `P`. Since the velocity roots span, `Gamma^T L0` is
nonzero. Telescoping puts it in `ker(B)`, a line. Scaling `L0`
therefore gives `L` satisfying

    Gamma^T L = d.

The determinant identity and this one-dimensional-kernel scaling
argument are formalized by `orthogonal_parity_singularity` and
`common_potential_of_fixed_vector`. No eigenvalue-pairing assertion or
external reflection-group theorem is needed.

### Proof 3: a removable switch forces alternative 2

Assume for contradiction that neither alternative of Theorem A exists.
Consider an exact augmented state at `0<s<1`, with coefficient line
`m(s)=a-(1-s)d`.

If a switch has zero total, its coefficient is zero. At times zero
and one its coefficient is an integer, by integral root pairings of
the moving endpoint. Thus in either case `(1-s)d_i` is an integer
with magnitude strictly less than one. It is zero, so `d_i=0`.
Delete the zero-total switch or absorb the entire endpoint cluster.
For an endpoint cluster every removed direction coordinate is zero.
The surviving position roots still have a nonzero relation supported
on at most `n` roots. Their span is proper.

If a gap is zero, `(1-s)d_i^G=G_i(1)` is an integer of magnitude
less than one, and hence `d_i^G=0`. Reflect the suffix and delete
this switch, as permitted by the schedule definition. All other
velocity roots are unchanged: for a later prefix, both its position
root and its accumulated frame are left-multiplied by the same
reflection. The surviving velocity roots retain the nonzero relation
`d^G` with its deleted coordinate zero. There are at most `n` of
them, so their span, and hence the new position-root span, is proper.

All these operations keep the labels and shape and preserve an endpoint
in `W xi`. They would establish alternative 2. Thus every augmented
state with `0<s<1` is interior in time and has strictly positive
gaps and totals. The quantization step is exactly
`interior_integer_hit` in Lean.

### Proof 4: complete rank-two classification and preservation

At a collision at parameter `s*`, all switches in a cluster have time
`tau`. Throughout that cluster their coefficient functions are

    m_i(s) = gamma_i . (-b(tau)+(s-s*)L),    b=w_in eta.

Consequently the candidate time of a root line `gamma` is the zero of

    gamma . (b(t)-b(tau)+(s-s*)L).                     (1)

It is independent of the route used through the cluster.

Two orthogonal root reflections commute. A nonorthogonal pair of
different type-D root lines spans an `A_2` root system: their inner
product has absolute value one, and after signed coordinate changes
its lines are `i=e_1-e_2`, `j=e_2-e_3`, and `h=i+j`.
This classification uses only the explicit roots `+/-e_a+/-e_b`
and is independent of rank.

At the base time choose regular refinements of the position order and
the incoming moving order, retaining every strict comparison. The
two switches are downward reflection steps in the resulting `S_3`
order. A reflection changes inversion length by an odd number.
Two positive drops have sum at most three, so both drops are one.
Enumeration of the six permutations gives precisely these four
length-two diamonds, using successive right reflection labels:

| Lengths | Routes |
|---|---|
| 3 to 1 | `ij <-> jh` |
| 3 to 1 | `ih <-> ji` |
| 2 to 0 | `ji <-> hj` |
| 2 to 0 | `ij <-> hi` |

This is the entire classification, not a sample in a fixed rank.
The other route has the same product and is downward at both steps.
Forgetting the refinements gives nonnegative position and total
signs for the new base schedule. Consecutive identical reflection
lines are impossible: the first would negate the strictly positive
total required by the second.

Here is an exact coefficient argument rather than just an endpoint
comparison. In a common incoming frame, a route with right labels
`a,b` has position columns `(a,s_a b)` and velocity columns `(a,b)`.
Let these two matrices be `B_old,G_old`; use `B_new,G_new` for the
other route. Both position pairs are bases of the same `A_2` root
lattice. Thus

    B_new M = B_old,    M in GL_2(Z).

The pair telescoping identity and equality of products imply

    B_old G_old^T = B_new G_new^T,
    M G_old^T = G_new^T.

The second equality follows because `B_new` is injective on the
two-dimensional coefficient space. Therefore the SAME integral
unimodular map transports coefficients and derivatives:

    m_new=M m_old,    d_new=M d_old,    a_new=M a_old.

It also transports common-potential pairings. Exact displacement,
endpoint, the entire column lattice, primitivity of twice the
direction, and integral extrapolation are preserved. Prefixes and
suffixes outside the pair are unchanged because the reflection
product is unchanged. The half-kernel bounds reapply to the full new
list, including its gap coordinates.

At the base time the new route is an exact weakly admissible schedule.
Proof 3 excludes every newly weak sign or boundary switch before
inverting any new level function. Thus its gaps and totals are in
fact strict. This order of argument avoids assuming invertibility
of a zero-total root level.

`verify.py` enumerates all `S_3` two-step downward paths, checks
exactly the four diamonds above, and checks their integer matrices
and the two displayed coefficient identities in both directions.
The reduction to `A_2` or orthogonal pairs is the reason these finite
checks cover local replacements in every rank.

### Proof 5: time ordering, persistent ties, and shape breaks

For a root with positive total, face-regularity makes its level
strictly monotone on every segment, with the same sign on every
segment. It has a unique continuous local inverse near an interior
base time, including when that time is a shape break. Choose signs
of `i,j,h=i+j` so their functions in (1) are all strictly increasing.
The function for `h` is the sum of those for `i,j`.

Let their zeros at a fixed nearby parameter be `T_i,T_j,T_h`.
If `T_i<T_j`, at `T_i` the sum is negative and at `T_j` it is
positive; strict monotonicity puts

    T_i<T_h<T_j.

The opposite inequality reverses these three, and `T_i=T_j`
forces `T_h=T_i`. The Lean declarations
`root_sum_time_strict_between`, `root_sum_time_tie`, and
`root_sum_median_order` prove these statements for arbitrary
strictly increasing functions, not merely affine functions.

For the real-domain formal declarations, extend these finite positive-
slope piecewise-linear level functions affinely beyond their endpoint
segments. They remain strictly increasing on the real line, and every
candidate zero used in the proof remains in the unchanged interior.

In each of the four diamonds, if the current pair has decreasing
candidate times, the alternative starts strictly earlier. For
example, `ij` decreasing gives `T_j<T_i`, while `jh` decreasing
gives `T_i<T_h<T_j`. The other three rows give the other six
inequalities. They are all formalized in `a2_diamond_descent`.
Orthogonal commutation of an inverted pair also starts earlier.
An unchanged prefix makes every such replacement strictly decrease
the whole candidate-time list lexicographically
(`pair_replacement_lex`).

During this sorting the common potential, anchor time, and candidate
time for each root line stay fixed. Only the finite root word changes.
Type `D_n` has `n(n-1)` root lines. A word has length `n+1`, and
strict totals uniquely orient each velocity line. Thus there are
at most `(n(n-1))^(n+1)` possible words. Strict lexicographic descent
prevents repeats, proving the stated replacement bound.
`finite_sorting_normal_form` and `strict_descent_card_bound`
formalize the finite-descent and cardinality arguments.

Every base word reached in this way is strictly admissible by
Proof 3. There are finitely many such words. Taking the minimum
of their finitely many inverse-time neighborhoods and strict-sign
neighborhoods yields one common neighborhood of `s*`. Old distinct
clusters remain separated there. For each fixed nearby parameter,
sort adjacent inversions until none remains. The resulting weakly
ordered word is a genuine schedule. Persistent ties need no move;
simultaneous switches remain permitted in their specified order.
The argument requires neither differentiability at a break nor
distinct candidate times, and does not assert that a single sorted
word works on a whole interval.

### Proof 6: compactness and arrival at the integral endpoint

Fix the initial `s0>0`. Let `S` consist of the parameters in `[s0,1]`
for which any exact augmented state exists with full root-lattice
generation, primitive half-relation direction, and integer
extrapolation at one. It is nonempty by hypothesis.

This set is compact, not merely bounded. There are finitely many
root words, initial Weyl frames, and endpoint representatives.
Every coefficient of a realized state is a pairing of a root with
the compact shape, so its absolute value is bounded by a fixed `C`.
Since `|d_i|<=1`, each integer extrapolation has absolute value at
most `C+1`. There are finitely many such integer vectors. The
half-relation directions range over a finite set as well.

For each choice of these discrete data, take parameter and times in
the compact set `[s0,1]` times the closed ordered-time simplex.
Coefficient equalities, endpoint equalities, and weak sign
inequalities are closed because the shape is continuous.
Their solution set is compact, and its parameter projection is
compact. A finite union gives compactness of `S`.

If the largest point of `S` were below one, Proof 3 would make its
state strict, and Proofs 4-5 would extend it to a larger point of
`S`. This contradicts maximality. Thus `1` belongs to `S`; every
coefficient there is its integer extrapolation. This is alternative
1, completing the contradiction and the proof of Theorem A.
The topological final implication is checked by
`endpoint_of_compact_right_extension`.

## Consequence for the manuscript's local link

Under the manuscript's standing assumptions, `lem:hard-case` excludes
alternative 2: a schedule with at most `n` switches must have `n`
independent roots. This use of block reduction, schedule-to-moment,
and smaller-rank integral-schedule induction is an explicit dependency;
it has NOT been independently certified by this mission.

The half-kernel lemma's integral extrapolation follows directly from
the endpoint congruence, not from half-integrality alone. For any
integral-root-pairing label, a Weyl translate differs from it by a
root-lattice vector. Hence the position balance right side lies in
`Q(D_n)`. Choose an integer coefficient vector `z` with the same
balance. Then `z-m0=t c`. Primitivity and half-integrality imply
`2t` is an integer (take a Bezout combination of the coordinates).
If `m0` is not integral, `t` is not an integer, so `2t` is odd.
It follows that both `m0+c/2` and `m0-c/2` are integral.
An already integral augmented base is itself the desired integral
schedule. This proves all assertions of `int:half-kernel` in their
standing context, including the potential and both bounds.

For a nonintegral base local link, take the feasible orientation in
condition (b) and its integer extrapolation. Condition (b) handles
the modified cluster. At any unaffected base cluster, condition (c)
allows every product-preserving exact reordering to be forgotten.
Forgetting gives a schedule with the original `n` switches. If that
reordering had a zero sign or endpoint switch, simplifying it would
leave at most `n-1` switches, contrary to `lem:hard-case`. Thus all
reordered unaffected clusters are strict at the base.

The common-potential rank-two sorting of Proofs 4-5 therefore applies
at parameter zero to those unaffected clusters, while (b) supplies
the modified one. The forgetting operation persists because the
pair product is unchanged: conjugate back in the reflected-suffix
case; in the stabilizer case retain the same right discrepancy,
which fixes every shape increment. Distinct old clusters stay
separated for sufficiently small parameter. This constructs an
exact augmented state at some `0<s0<1`.

Theorem A now supplies an integral schedule or a forbidden rank-drop
schedule. Both contradict the standing assumptions. Thus
`prop:continuation` follows, with its precise external/inductive
dependency exposed. No moment-count, column, zero-tail, or final
saturation conclusion is inferred.

## What is and is not certified

The new mathematical output is the all-rank continuation-or-rank-drop
theorem, together with a finite sorting bound and a source-faithful
derivation of continuation conditional on the manuscript's exceptional-
case reduction. This is stronger than the source proposition: its
initial-state version needs no local-link forgetting condition, no
rank induction, and no zero-coordinate bound. Those hypotheses enter
only when applying it to exclude a manuscript local link.

The exact script checks complete rank-two algebraic tables, exact
piecewise-linear examples including a tied break, the adapter's
transformation-certified Smith calculation, and explicitly bounded
small-rank lattice cases. The last are adversarial calibration only;
they are not the all-rank proof. The all-rank reasoning is the proof
above. Lean checks the named universal core declarations, not the
whole signed-graph and geometric assembly. The separate fidelity
document states this limit declaration by declaration.

A targeted literature lookup found the source manuscript, but no
independently verified earlier statement of this precise alternative.
The search response's broad priority assertions and unrelated hits
are not mathematical evidence and are not adopted. No claim of
absolute literature priority is made. Publishability, novelty, the
geometric assembly, and statement fidelity require Host-invoked
independent Reviewer assessment; the Engineer does not assign that
assessment to itself.

## Reproduction

From the campaign root, run:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/continuation/verify.py
```

The script uses only the Python standard library. It checks the stored
certificate against newly computed exact data and checks the archived
Lean result against the current source, fidelity document, and latest
claim version. `--write-certificate` regenerates the JSON from these
checks; it does not manufacture a compiler result or an independent
review. The preserved compiler invocation is in
`lean_verify_output.json`, and the immutable successful certificate is
`certificates/C_CONT_CORE-79797aba77e19dc7.json`.

The lattice calibration includes 2,033 generating root multisets in
ranks two through four, repetitions allowed, and 237,684 ordered-index
tests (some represent the same ordered word when columns repeat).
The certificate keeps the per-rank counts rather than calling these
distinct witnesses. All four rank-two diamonds, both directions, the
all-equal time case, orthogonal commutation, and exact shape-break
examples are included. These finite calibrations and the all-rank
proof have deliberately different labels.
