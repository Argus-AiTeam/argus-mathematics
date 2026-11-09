# Deletion-stable raw-length transfer through copied forests

## Result and scope

**Theorem.** Under the literal geometric, deletion, terminal-promotion, and
bounded-assignment hypotheses of the staged manuscript's one-level
construction, its raw-length quality reduction and shared-arm lift are
valid. In fact, with

```
beta = 17(p+1),     Z = 40(p+1),     A = A_*,
X = ||ell Delta_s||_1,             Y = ||ell Delta_n||_1,
L = L_best,                       O = OPT(J),
```

every current nonloop circulation satisfies the stronger estimate

```
|gamma^T Delta|
  <= 2 Z A X L + ((6 beta + 3) A X + Y) O.                 (1)
```

Consequently, if `Delta` is nonzero,

```
|gamma^T Delta| / (X+Y)
  <= (2 Z + 6 beta + 3) A max{L,O}
  <= 5 Z A max{L,O}.                                    (2)
```

The manuscript states the weaker bound `2ZA L + 12ZA O`, hence
`14ZA max{L,O}`, and uses the guard `20ZA <= b^2`.
Equation (1) keeps new-edge norm separate and improves those constants.
The canonical operation that completes a fixed copied vector by unit null
hub edges has a sharp factor-three norm bound.

These are general statements over real coefficients, not conclusions from
the finite experiments below. They apply simultaneously to all deletion
states and all current circulations once the stated input properties hold.
Returned lists are measured before cancellation. Only existential comparison
vectors are measured by their net coefficient norms.

This verifies a substantive quality interface, **not** the entire matching
algorithm, the availability/cost of the assignments, the construction cost
or probability of the covers, occurrence budgets, or persistent recourse.
No false literal manuscript assertion is claimed by this report.
Independent mathematical review, novelty assessment, and a decision about
publishable significance remain outstanding.

## Sources and prior scope

All local citations refer to the unmodified September 24, 2026 source in
`research/openai_manuscript/Almost-Linear-Time-Maximum-Cardinality-Matching-in-Sparse-General-Graphs-September-24-2026/build/sections/`.

| Source | Exact input or assertion being checked |
|---|---|
| `05-engine.tex`, `lem:flat-cycle`, `engine:flat-quality` | The denominator `V` counts every mapped traversal, with repetitions; null forest traversals cost zero. |
| `07-backend-quality.tex`, `back:helper-parameters`--`back:guards` | Positive integer lengths; `a >= 1000` when used by the engine; `u > 0` divisible by `2a^2`; `S^(1/a) <= M=2^u <= S^2`; `P_* <= b`; `20 Z_* A_* <= b^2`. |
| `07-backend-quality.tex`, `back:covers`, `back:forest-family` | Verified padding/radii and simultaneous OUT choices at two distinct lower slots. |
| `07-backend-quality.tex`, `back:frozen-decomposition`, `back:clipped-identity` | Fixed marginals, coefficient and raw-residual bounds, and deletion of every mapped copy. |
| `07-backend-quality.tex`, `back:correction`--`back:remainder` | Live legs, bounded selected-support paths, local raw corrections, and compressed remainders. |
| `07-backend-quality.tex`, `back:child-vector`--`back:quality-induction` | Physical balancing through hubs and the score recurrence. |
| `08-backend-updates.tex`, `update:flat-lift` | Shared-arm substitution and reduction to one public forest path. |

The source explicitly says: "Raw length counts every actual traversal with
multiplicity" and distinguishes the norm using the absolute **net**
coefficient. The local correction formula is explicitly "a traversal list,
not a cancellation rule for its denominator." Thus identifying these two
notions would not be a source-faithful refutation.

A separate bounded primary-source lookup inspected Chen et al.,
arXiv:2311.18295v1, Definition 2.3, Definition 3.1, and Theorem 3.5, and
Kyng--Meierhans--Probst Gutenberg, arXiv:2311.06402v1, Lemma 3.21 and
Algorithm 5. Chen's ratio uses the projected circulation norm `||Lc||_1`;
the number of forest paths in its representation is a separate bound.
The second paper already proves mapped terminal-path length domination
under its own hypotheses and uses preallocated tree copies. Those results
do not alone establish the stronger raw-ratio interface audited here.
They are context, not premises of this proof. Exact locators and short
source excerpts are in `literature.md`. This two-document lookup does not
establish novelty of (1), (2), or the sharp canonical-completion constant.

The project Wiki index had no page on this raw-length/copy/hub interface.
No prior campaign certificate was present in the seed ledger.

## Precise hypotheses

Consider a finite frozen nonloop multigraph with reference orientations and
lengths at least one. Gradients may be any real numbers; the source's integer
case is included. Each layered tree edge maps with a specified orientation
to one frozen physical edge, or is null between equal physical images.
Construction length is inherited for actual edges and is one for null
links. A hole deletes **all** copies of one dead physical edge in both
the family forests and the unduplicated raw forests. Surviving prices and
identities are immutable; every insertion is a distinct new edge.

At layer `j=1,...,r`, `R_j=b^j`. There are `K=K_h` verified partitions.
Here `r,K` are positive integers and `Gamma>=1`.
Each cell has a shortest-path tree of radius at most `Gamma R_j`, and at
every vertex some cell contains the closed `R_j`-ball. Assume `b>=2`,
`Gamma R_(j-1)<R_j/2`, and `R_r/2` exceeds every finite frozen component
diameter. The source's guarded parameters imply all of these. In
particular,

```
R_r = M^(1210a+3),
n_i M^G_i <= M^(1204a-4) < R_r/2
```

for `i<=d=2a-4`, `M>=2`; we used the deliberately loose bound
`n_i<=M`, `G_i<=1204a-8`. The gap in exponents is at least `6a+7`.
Also the second guard implies `b>2 Gamma`, since
`A=64r Gamma K b` and `Z>=40`. Set `A=64r Gamma K b >=1`.

The finite family contains the source's copies of the layered trees, their
IN links, and one OUT option per lower slot. It can prescribe arbitrary
options at any two **distinct** lower slots at every layer. Its chords
are the frozen physical edges and the null pair chords, retained when
their endpoints are connected. Width `W_f` is the least dyadic number
not below full frozen fundamental-cycle length `w_f`; hence
`w_f<=W_f<=2w_f`.

Use the source's portal and fragment rules. Every active chord has live
legs of length at most `8W_f`. Its assigned logical path uses live
selected chords of that same forest and bucket and has at most `p` hops.
Here `p` is a nonnegative integer.
An inactive chord's fundamental cycle is intact. These are precisely the
assignment hypotheses in `lem:backend-reduction`, not an assumption of
the disputed coefficient or quality inequalities.

The child contains the specified terminal Steiner compressions, live
selected chords on their original tree-node endpoints, unit null
connectors from each compressed vertex to its physical hub, and all
new physical edges between their hubs. Its terminals include portals,
hole endpoints, class targets, selected-chord endpoints, and both endpoints
of every possible raw cell-tree leg starting at a new-edge endpoint.
Extra promoted terminals do not hurt the argument.

For lifting, the child public representation is any forest with valid
child-edge or null maps. Each occurrence receives a distinct arm slot.
The copied incident-segment paths are disjoint except at that slot's center.
Connectors are installed exactly as in `update:flat-lift`. Dormant slots
have no connectors. Nothing in the proof assumes that physical vertex
images are injective, or that different represented traversals avoid
the same physical edge.

## Deriving the frozen decomposition, including its residual bound

For a cell `C` at layer `j`, put

```
a_C(v) = max{0, min{R_j, dist(v,V\C)} - R_j/2}.
```

These functions are one-Lipschitz. A padding cell has weight `R_j/2`, so
the sum of weights is at least `R_j/2`. At the endpoints `v,w` of an
edge, only the cells containing one endpoint can have a nonzero weight:
at most `2K` cells. The sum of absolute changes of weights is at most
`2K ell_e`. Normalizing gives

```
TV(L_j(v), L_j(w)) <= 4K ell_e/R_j.                       (3)
```

For completeness, if nonnegative vectors have sums `s<=t`, their
normalized l1 difference is at most
`||a-b||_1/s + (t-s)/s <= 2||a-b||_1/s`; total variation is half
this. This proves (3) without an external coupling theorem beyond the
elementary finite construction that matches mass `min{p_i,q_i}` first.

Choose layer cells independently using the law indexed by the **starting**
vertex. After layer `j-1` the representative is within
`Gamma R_(j-1)` of that start. Every positive next cell contains the
start's closed `R_j/2`-ball, so it contains this representative.
The upward route `P(v)` is therefore well defined.

Couple the two endpoint choices maximally at each layer and independently
between layers. At the top, every positive cell contains the entire
component, and the two laws are identical, including partition identity.
Their last choices can be made equal. Retain the arms through one layer
after their last disagreement; if there is none, retain layer one.
The remaining final suffix is identical as a vector on the raw copies.
The retained two arms at layer `j` have full length at most
`4 Gamma R_j`, including their null links. For `j>=2`, (3) bounds
the probability that this layer is retained by

```
sum_(l>=j-1) 4K ell_e/R_l <= 8K ell_e/R_(j-1).
```

The expected full length of the edge and trimmed arms is at most

```
ell_e + 4 Gamma b + 32(r-1) Gamma K b ell_e
  <= 64r Gamma K b ell_e = A ell_e.                       (4)
```

Here `ell_e>=1`, `K>=1`, and the guarded scales also absorb the unit
null links in the arm estimate.

Split a coupled closed walk at its common `V_j` representatives.
Before the first common representative the simultaneous lower slots
are distinct, so a family member contains both specified arms.
Their input chord and the resulting tree path form a fundamental cycle.
Between successive common representatives, equal first options give
identical paths and cancel; different first options can be replaced
by their null pair chord. Thereafter the two lower slots are again
distinct until the next common representative, so another family
member realizes the two arms. Reducing tree backtracks preserves the
signed vector and does not increase full length. Replacing two unit
OUT links by one unit pair chord also cannot increase it.

Multiply this decomposition by each signed surviving coefficient and
take expectations. Collecting like chords and using (4) gives

```
sum_f alpha_f pi C_f^0 = Delta_s + pi z,
sum_f |alpha_f| w_f <= A X,       ||z||_length <= A X.     (5)
```

The raw-tree residual is exactly

```
z = raw-tree part of
    sum_v (in_Delta_s(v)-out_Delta_s(v)) E[P(v)].
```

To see its norm bound, use for each edge the same coupling as above.
The signed difference of the two raw routes is unchanged by deleting
their identical final suffix. Its raw-copy l1 norm is at most the full
length of the retained arms. Summation, expectation, and the triangle
inequality prove the second bound in (5). This does **not** charge the
uncanceled lengths of two separately chosen full routes.

Fixed per-start marginals cancel at every conserved physical vertex
even though incident edges use different couplings. Since
`Delta_s+Delta_n` is conserved, only new-edge endpoints remain in the
displayed description of `z`.

For a live physical coordinate `e`, restricting any copied vector
retains exactly all terms projecting to `e`. For a dead coordinate,
every such term is removed. Thus projection and restriction commute
coefficientwise, regardless of opposite signs or cancellations between
different copies. Restricting (5) gives the literal clipped identity

```
sum_f alpha_f pi C_f^clip - pi z_L = Delta_s.             (6)
```

`RawLength.projection_clip` formalizes this fact for arbitrary finite
copy maps, null images, signs, live sets, and real coefficients.
Deleting just one representative would be insufficient; the source
explicitly deletes every mapped copy.

## Raw corrections and exact compression

An oriented logical hop `L_f` comprises the reversed tail leg, the
chord, and the head leg. Its full traversal length is at most
`8W+W+8W=17W`. Substituting at most `p` selected hops costs at most
`17pW`. Hence the actual **traversal list**

```
B_f = L_f - L_(Pi_f)
```

is a current physical circulation with raw actual length at most
`beta W`, `beta=17(p+1)`. A minus means reversal, not deletion of
canceling traversals. Both incidences of a logical loop are counted;
its assigned path may be empty. A direct intact cycle has raw length
at most `w_f<=W_f`. Since `beta<=Z`, `|gamma^T pi B_f|/(ZW_f)`
is a certified score whenever its numerator is positive.

Subtracting `B_f` from an active clipped cycle cancels its original
chord as a vector. The remaining forest vector is its clipped tree
path minus its two legs, plus the selected routed walk. Original
chord-endpoint divergences cancel, including when a hole is adjacent
to an endpoint. Remaining divergences are only at hole endpoints,
targets, and selected-chord endpoints, all of which are terminals.
Its norm is at most

```
W_f + 16W_f + 17pW_f = beta W_f.                         (7)
```

If a forest edge separates off a terminal-free side, summing divergences
on that side forces its coefficient to be zero. At an internal
degree-two nonterminal, conservation forces the consistently oriented
coefficients to be equal. Thus terminal Steiner compression preserves
the vector's gradient and its weighted net norm **exactly**.
This proves existence of a child vector `J_f` with

```
pi J_f = pi(C_f^clip-B_f),       ||ell^J J_f||_1 <= beta W_f.
```

In the direct case `J_f=0`. The same compression applies to `z_L`:
each raw leg's endpoints are promoted, and clipping adds divergence only
at promoted hole endpoints. It is the net raw-forest vector being
compressed, not a purported collection of disjoint route realizations.
Write its compression as `zhat_L`.

## Null-hub completion, its sharpness, and the improved inequality

Put `Q=sum_f alpha_f J_f-zhat_L` on the compressed old-edge part of
the child, and put `N=Delta_n` on its hub-to-hub new edges. By (5)--(7),

```
||ell^J Q||_1
  <= beta sum_f |alpha_f| W_f + ||z_L||_length
  <= (2 beta+1) A X.                                    (8)
```

Equation (6) gives

```
pi(Q+N) = Delta - sum_f alpha_f pi B_f,
```

a physical circulation. New edges touch hubs only. At a compressed
copy `q`, let `d(q)` be incoming minus outgoing divergence of `Q`.
Give its null connector oriented from `q` to its physical hub
coefficient `d(q)`. This cancels that copy's divergence. At a hub,
the new-edge divergence plus the sum of `d(q)` over its physical
fiber is zero by physical conservation. Internal vertices of mapped
segment walks contribute no extra divergence because each expansion
telescopes to its endpoint difference.

The connector cost is exactly `sum_q |d(q)|`. Counting both incidences
of every edge, including parallel copies, gives

```
sum_q |d(q)| <= 2 sum_e |Q_e| <= 2 ||ell^J Q||_1.
```

The last step uses lengths at least one. Null connectors have length
one, gradient zero, and zero physical projection. The resulting child
circulation `Xi` therefore obeys

```
||ell^J Xi||_1 <= 3 ||ell^J Q||_1 + Y
                <= (6 beta+3) A X + Y.                  (9)
```

Keeping `N` separate matters: it has no incidence at a compressed copy
and does not require the extra factor three.
`RawLength.linear_mass_le`, `incidence_mass_le`, and
`completion_cost_le` prove the norm argument for arbitrary finite
real vectors.

**Sharpness of the canonical completion.** Take two disjoint copied
edges `a_0 -> b_0` and `a_1 -> b_1`, both mapping to one physical
edge `a -> b`, with unit lengths and coefficients `1,-1`.
Their physical projection is zero and their old-edge norm is two.
Each of the four copied vertices has divergence of magnitude one.
Retaining those edge coefficients and balancing with their individual
unit hub connectors costs exactly `2+4=6`. Thus no universal constant
smaller than three bounds this specified completion operation.
This is **not** a lower bound on every child representation of the
same physical projection: its zero projection also has the zero
representation. `verify.py` checks this distinction's concrete witness.

The coefficient one on `Y` in (1) is also necessary in this generality.
If the frozen part is empty and the only current edges form one new
triangle, then `Q=0`, `Xi=N`, and
`|gamma^T Delta|=Y OPT(J)` for its unit cycle. The exact example has
`Y=10`, absolute gradient six, and zero connector cost. Thus it would
be incorrect to claim any coefficient below one for the new-edge term.
Conservation on this triangle forces its three coefficients to agree,
so its optimum is exactly `6/10`, not merely bounded below by that value.

Finally the local scores and (5) imply

```
|sum_f alpha_f gamma^T pi B_f|
  <= Z L sum_f |alpha_f| W_f <= 2 Z A X L.
```

The child part has numerator at most `O ||ell^J Xi||_1`, including
the case `Xi=0`. The triangle inequality and (9) prove (1).
Let `T=max{L,O}`. All scores are nonnegative and
`(2Z+6beta+3)A>=1`; replacing the two scores by `T` in (1)
proves (2). The arithmetic is

```
2Z+6beta+3 = 182(p+1)+3 <= 200(p+1) = 5Z.
```

For the source's first inequality, use `X<=X+Y`,
`(6beta+3)A <= 12ZA`, and `1<=12ZA` in (1).
For its second inequality use `5ZA<=20ZA<=b^2`.
No disputed inequality has been assumed to get these bounds.

## Shared-arm lifting is raw-length nonexpansive

Contract each arm-slot tree to its center. The connector quotient on
assigned slots is exactly the active child forest; dormant slots are
isolated trees. A forest of tree-shaped bags over a forest quotient
is a forest: a component with `t` bags has `t-1` connectors and
`sum_b(|V_b|-1)` internal edges, hence one fewer edge than vertices
and is connected. This also covers child-null edges between distinct
occurrences of the same child slot.

Expand an oriented child forest path by its prescribed segment arms
and connectors. Every actual parent traversal is charged to its
child edge length with multiplicity. Child-null traversals expand
to physical nulls and cost zero raw actual length; construction
nulls on a segment only enlarge the child's length. The expansion
has the correct signed projection and total parent raw length at
most the child raw length.

Connectors for several child edges may use the **same** arm. Their
concatenation can therefore backtrack, even for a simple child path.
Deleting an adjacent public edge and its reverse preserves the
signed count of every public edge, and removes twice that edge's
nonnegative mapped raw weight. In a finite forest the reduced walk
is the unique path between its endpoint centers. Otherwise a
repeated vertex would give a nonempty reduced closed subwalk,
which would contain a cycle. Therefore returning those two centers
preserves projection and cannot increase raw length.

`RawLength.cancel_pair` proves signed-count preservation and the
exact raw decrease for arbitrary prefixes, suffixes, repetitions,
and edge weights. `raw_score_preserved` proves the score transfer.
The forest/bag argument above is a mathematical proof, not a claim
that Lean encoded the entire graph construction.

An individual compressed child edge lifts in a full live forest
copy; a nonsegment actual edge lifts directly, and a null
realization can be omitted. Expansions preserve endpoint divergence,
so any sum projecting to a child circulation still projects to a
parent circulation. Positive child numerator is preserved, and
forces positive parent raw length. Unit multiplicities are retained;
repeated pieces are listed and charged separately.

An inactive child slot is isolated in `J`. Every child forest component
over it therefore consists entirely of null edges over that same slot
and may be omitted, with zero signed projection and zero child raw length.
A child path produces at most one parent path; a single child edge produces
at most one piece or is omitted if null. A local correction uses at most
`3(p+1)` pieces, or two in the direct case. This gives the source's piece
bound conditional on its bounded assignments and bottom-level answer;
it does not assert an unproved running-time bound.

## Conditional recursion and exact parameter scope

If the child returns raw score at least `eta OPT(J)` with `eta<=1`,
the better of its lift and the best local score is at least
`eta max{L,OPT(J)}`. The one-level reduction loses at most `b^2`.
The bottom factor `1/2` needs no external optimization theorem.
Orient a nonzero circulation by its coefficient signs, negate it if
necessary, and decompose the resulting nonnegative flow into simple
directed cycles by repeatedly removing a cycle's minimum coefficient.
Both gradient and raw length add, so some cycle has ratio at least
the original circulation's ratio. Conversely a positive-gradient cycle
projects to a nonzero physical circulation and its net norm is at most
its raw length; thus the optimum is attained by such a cycle.
Under the source's bottom-level integer prices its positive value lies
between `1/(n_d M^G_d)` and `M^G_d`. The stated dyadic thresholds cover
this interval. A negative closed walk for arc costs
`rho ell - gamma` exists exactly when some cycle has ratio above `rho`;
minimum-cost walk tables up to the number of vertices detect it.
The largest successful threshold is at least half the optimum, including
when the optimum is exactly dyadic, and its witness has still larger
raw ratio. This establishes the quality factor, without certifying the
table implementation's charged running time.
The bottom factor and the one-level induction give

```
eta_i = (1/2) b^(-2(d-i)).
```

Current loops are independent coordinates and are compared exactly.
For `d=2a-4`, the outer coefficient is
`(1/2) M^(-(4a-8)/a^2)`. Its comparison with `M^(-10/a)`
is equivalent, in base-two exponents, to

```
(6a+8)u >= a^2.
```

This holds because positive divisibility gives `u>=2a^2`.
The guarded range in the engine is much stronger.
`recursive_choice` and `outer_exponent_margin` check the algebraic
parts; monotonicity of exponentiation gives the stated comparison.
This conditional recurrence is not a proof of the remaining running-time,
reliability, lifetime, or occurrence claims.

The finite examples deliberately use small geometric diagrams and
do **not** purport to meet the astronomical source parameter guards.
They test identities and implementations only. No small example is
reported as a literal counterexample, and no embedding argument is
needed for the universally quantified theorem proved above.

## Reproducible evidence and limitations

Run `python3 research/raw-length-core/verify.py`. It uses exact rational
arithmetic from the standard library, independently checks the typed
Jacobian result, replays a frozen triangle with holes and two kinds of
new-edge imbalance, checks canonical hub completion and its sharpness,
checks terminal compression, and exhausts small child forests with
shared arms, repeated physical images, dormant slots, and null maps.
Its finite exhaustion is corroboration, not the proof of the theorem.
The successful replay checked 972 deletion identities, 125 hub-completion
vectors, 19 current circulations in the frozen-hole diagram, 3,648 exact
terminal compressions, and 263,056 oriented lifted paths in 19,968 public
forests. Among these were 17,292 positive-child-raw paths reducing to zero
parent raw length. These are exact coverage counts, not asymptotic claims.

Jacobian operation `matrix.nullspace.compute` was discovered and its
typed contract inspected before custom certificate code was written.
`jacobian_payload.json` and `jacobian_output.json` retain the exact
request and typed result, server version, protocol, and runtime.
It returned rank three and the all-ones cycle basis for a four-copy
incidence matrix with two physical null connectors and opposite
physical traversals. It does not expose a contract proving the
general weighted norm or forest-lifting argument. The exact local
calculation and Lean proof cover those different obligations.

`Main.lean` and `statement_fidelity.md` encode and delimit the general
algebraic core. Only a fresh successful real Lean 4.31.0 compiler
record with no proof holes counts as formal evidence. The ledger
attaches that evidence only to `C_RAW_ALGEBRA`. The complete theorem
`C_RAW_TRANSFER` additionally depends on the geometric and graph
proofs in this report and must be read by the independent Reviewer.
Its statement is not substituted for the seed claim `C9000120`.
