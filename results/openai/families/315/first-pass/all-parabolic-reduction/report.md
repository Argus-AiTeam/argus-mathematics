# The all-parabolic finite-interval reduction

## Scope and baseline

The assertion under audit is Lemma `pret:invariant-class` in the staged
`build/pretree.tex`: under the section's hypotheses, Gamma preserves a
finite-interval class of the original completed cut-point pretree Phi.
The hypotheses are a nondegenerate compact metric continuum with a minimal
convergence action of a finitely presented, torsion-free, one-ended group,
with no nontrivial splitting over a finite or two-ended subgroup.

The decisive internal step is at a first invariant class of successor
rank beta+1 with beta >= 1. An infinite-order element preserving an edge
of the intervening simplicial tree fixes its facing point p. The manuscript
claims it also fixes a point outside the facing class, using the endpoint
of an increasing union of intervals. This is an assertion about arbitrary
complete median pretrees and infinite sequences, not a finite-enumeration
problem. The conclusions below resolve this step affirmatively; they do not
deduce anything about the rest of the Singer proof.

At the initial baseline, the staged source was available but the original Bowditch
papers had not yet been obtained or read. The manuscript's references are
Bowditch, *Treelike structures arising from continua and convergence
groups*, Memoirs AMS 139 (662), 1999, DOI 10.1090/memo/0662, and
*Connectedness properties of limit sets*, Transactions AMS 351 (1999),
3673--3686. Citation metadata alone is not evidence that the quoted
propositions have the required hypotheses. Both original author-posted
papers have now been obtained and read at the needed locators. The saved
PDFs, readable text and precise version limitations are in
`sources/locators.md`. The publisher versions were not separately obtained.

The manuscript explicitly distinguishes its all-parabolic argument from
Bowditch's Theorem 6.1. Consequently, treating that theorem as already
proving the desired invariant class is not an available route. No flaw or
refutation has been established at this baseline, and the main Singer
theorem is not being declared verified or false.

## Result: a fixed-class criterion

**Theorem.** Let G be a finitely generated one-ended group containing no
infinite torsion subgroup, acting minimally as a convergence group on a
nondegenerate compact metric continuum B. Let P be a nonempty invariant
set of global cut points, and let Phi be its complete median flow
completion. Let D_P(B) be the canonical dendritic quotient relative to P.
Then the following are equivalent:

1. D_P(B) consists of one point.
2. G preserves a finite-interval equivalence class of the original Phi.

Here a torsion subgroup means a subgroup all of whose elements have
finite order, not a subgroup with some finite-order elements. No
finite-generation hypothesis on cut-point stabilizers, local finiteness
of a graph, or local connectivity of B is imposed.

In particular, the manuscript's Lemma `pret:invariant-class` is valid.
Its finite presentation and absence of finite/two-ended splittings give
D(B) a single point by Bowditch's dendrite obstruction. Torsion-freeness
supplies the theorem's no-infinite-torsion hypothesis.

The criterion separates the actual reduction from the hypotheses used
to produce D(B). Once D(B) is known to be a point, finite presentation
and the no-splitting conditions are unnecessary for this reduction.
Torsion-freeness can be weakened to absence of infinite torsion subgroups.
This is a structural generalization of the stated lemma, not a
counterexample. Novelty and publishable significance remain questions
for independent review; they are not consequences of compilation.

## An intrinsic infinite fixed-point lemma

**Order lemma.** Let T be a meet semilattice such that:

- any two elements below a common upper bound are comparable; and
- every monotone sequence indexed by all natural numbers has a least
  upper bound in T, whether or not a bound was specified in advance.

Let f be an order automorphism. Suppose U is nonempty, meet-closed and
forward invariant under f, V is downward closed, and U and V are
disjoint. Then f has a fixed point outside V.

**Proof.** Choose y in U and put x=y meet f(y). Meet closure and forward
invariance give x in U. Both x and f(x) lie below f(y): respectively
x <= f(y) and f(x) <= f(y) follow from the two meet inequalities.
Hence x and f(x) are comparable.

First suppose x <= f(x). Put c_n=f^n(x) for every n in N, and let
z=sup{c_n : n in N}, which exists by the stated sequential completeness.
Each f(c_n)=c_(n+1) is <= z, so c_n <= f^(-1)(z). Leastness gives
z <= f^(-1)(z), and thus f(z) <= z. Conversely f(z) bounds c_0,
since x <= f(x) <= f(z), and it bounds every c_(n+1) by monotonicity.
Leastness now gives z <= f(z). Therefore f(z)=z and x <= z.

If f(x) <= x, apply this same argument to f^(-1); applying the inverse
order isomorphism to the inequality gives x <= f^(-1)(x). The resulting
z is fixed by f as well and still satisfies x <= z.

In either case z cannot belong to V: downward closure would put x in V,
contrary to x in U and disjointness. This proves the lemma.

This proof uses an entire infinite orbit, not a finite-prefix
calculation. It is formalized in `increasing_orbit_fixed`,
`fixed_above_meet`, and `second_fixed_point_outside` in `Main.lean`.
The proof is the classical orbit-supremum method; it is not being
advertised as a new general fixed-point principle.

### Translation to the manuscript's complete median pretree

Fix the facing point p and root Phi there: define a <=_p b exactly when
a belongs to [p,b]. This is a partial order with least point p.
Its meet is med(p,a,b), and each principal ideal [p,c] is linearly
ordered. An automorphism fixing p is an order automorphism.

For completeness, here is why every monotone sequence has a least
upper bound in this rooted order. The union A of the intervals
[p,c_n] is a full directed arc with first point p. If it has a last
point z, that z is its supremum. Otherwise Bowditch's definition of
completeness and Lemma 3.13 give an actual point z of Phi with
A=[p,z). Medianity makes that endpoint unique. It is a least upper
bound, not merely a chosen endpoint: if w bounds every c_n, put
m=med(p,z,w). If z were not in [p,w], then m != z, and
A would be contained in [p,m]. But m belongs to [p,z)=A, giving A
a last point, a contradiction. Thus z <=_p w.

A full U is closed under rooted meets, because med(p,a,b) belongs to
[a,b]. A full V containing p is downward closed. Thus the order lemma
applies to disjoint full U,V whenever U is invariant and p is fixed.
It proves exactly the second fixed point required by the manuscript.
Neither U nor V needs to be complete, and the second fixed point need
not belong to U, to their union, or to the chosen higher-stage class.
It does belong to the ambient Phi and lies outside V, which is all
that the subsequent separation argument needs.

This is genuinely weaker than full completeness for the local
fixed-point step: the first uncountable ordinal, with its usual order,
has suprema for every increasing countable sequence but lacks an
endpoint for its whole unbounded directed arc. Full completeness is
still used separately for the facing-point construction and the
source's quotient machinery.

## Dynamics: why an infinite fixed interval forces terminal endpoints

The following consequence of Bowditch's fixed-point analysis is needed
for arbitrary invariant cut sets P, not only a cut set chosen to be
nonparabolic.

If an infinite-order element g is parabolic with fixed point a in P,
every compact nonempty invariant region R_B(q) contains a. For a fixed
q in P this forces q=a. For a fixed q outside P the identity
R_B(q)=phi^(-1)(q) union Lambda(q), together with phi(a)=a != q,
forces a to be adjacent to q. Consequently the interval between any
two fixed points is contained in the union of their intervals to a
and has at most three points. This is also the remark immediately
following Lemma 6.10 in the original source.

If the parabolic fixed point a is outside P, Lemma 6.10 gives only one
fixed point in Phi. An infinite-order element fixing p,q with [p,q]
infinite is therefore not parabolic. The convergence-action
classification makes it loxodromic, and Lemma 6.9 makes both p and q
terminal in Phi.

The compactness argument uses convergence of the positive iterates of
a parabolic element away from its unique fixed point; it does not
assume local connectivity or a geometrically finite action.

## Proof of the fixed-class criterion

Use Bowditch's increasing invariant full equivalences E_alpha:
E_0 is equality, E_(beta+1) collapses the finite-interval classes of
Phi/E_beta, and E_lambda is the union of E_beta for beta<lambda at
limits. Lemmas 4.2 and 4.4 ensure complete median quotients and
stabilization. The terminal quotient is D_P(B).

Suppose first that D_P(B) is a point. Choose the least ordinal alpha
for which Phi/E_alpha has a G-fixed point. Such an ordinal exists
because the terminal quotient is a point. It is not zero, by Lemma
6.11. This choice needs no bound on cofinality and no countability
of Phi.

**No first fixed class at a limit.** Let Xi be an invariant E_alpha
class, choose x in Xi, and choose a finite generating set S. For each
s in S, the union definition gives beta_s<alpha such that
E_(beta_s)(x,sx). A common beta<alpha is the maximum of these finitely
many ordinals (or any earlier stage for an empty family). At this
stage the set H={g : E_beta(x,gx)} is a subgroup: transitivity and
invariance prove closure under products; invariance by g^(-1) and
symmetry prove closure under inverses. It contains S and hence all
G. The E_beta class of x is therefore invariant, a contradiction.

`finite_eventual_stage`, `relationStabilizer`, `generators_fix_class`,
and `no_first_fixed_at_limit` formalize this argument for every linearly
ordered stage set, so in particular for ordinals of any cofinality.

**No first fixed class at a successor greater than one.** Write
alpha=beta+1 with beta>=1. Let Xi be the invariant E_alpha class.
Its E_beta classes form a simplicial tree Sigma, since its intervals
in the quotient are finite. A G-fixed vertex of Sigma would be an
earlier invariant class, so there is none.

For adjacent vertices U,V of Sigma, the fibers U and V are disjoint,
nonempty full subsets of the original Phi with full union.
Lemma 6.13 supplies a facing point on at least one side. If both
facing points existed, they would be adjacent in Phi and hence
E_1-equivalent. Since beta>=1, they would be E_beta-equivalent, a
contradiction. Thus exactly one side has a facing point. An
automorphism swapping U and V would swap this intrinsic distinction,
so no edge is inverted.

Now let an edge UV have infinite stabilizer K, and label its unique
facing point p in V. Absence of infinite torsion subgroups ensures
that K contains an infinite-order element g: otherwise K itself
would be an infinite torsion subgroup. The element g preserves both
fibers and fixes their uniquely determined p. Apply the order lemma
rooted at p to obtain q outside V fixed by g.

The point q is not in the E_beta class V of p. Because beta>=1,
it is not E_1-equivalent to p either. Thus [p,q] is infinite in the
original Phi. The dynamical consequence above makes p terminal.
For u in U and v in V the facing identity gives p in [u,v].
As p != u, terminality forces v=p. Therefore V={p}; this precise
inference is also formalized by `facing_terminal_class_singleton`.
If V had two neighbors in Sigma, representatives of them would have
p strictly between them in Phi, again contradicting terminality.
So the edge has a leaf endpoint.

Remove all infinite-stabilizer edges with their leaf endpoints.
This selection is invariant: infinite stabilizers are preserved by
conjugacy, and the facing side is intrinsic. The surviving vertex
set is nonempty. If every vertex had been removed, every vertex
would have degree at most one; a nonempty connected tree of that
kind has at most two vertices. An action on it without inversions
fixes a vertex, already excluded. Paths between surviving vertices
also survive, since an internal path vertex cannot be a leaf.
Hence the remaining graph is a nonempty invariant subtree.

All its edge stabilizers are finite, and a fixed vertex in it would
also be fixed in Sigma. Bowditch's Lemma 6.6, the fixed-vertex
theorem for finitely generated one-ended groups acting without
inversions on trees with finite edge stabilizers, gives the
contradiction. No local finiteness, finite quotient, or minimality
of Sigma was needed.

Only alpha=1 remains, proving the forward implication.

Conversely, an invariant E_1 class maps to a fixed point of the
terminal quotient D_P(B). The induced action there is minimal:
the quotient map from B is continuous, equivariant and surjective.
A minimal action with a fixed point has a singleton space. This
proves the reverse implication.

For the original manuscript hypotheses, Connectedness Lemma 1.4
applies because finite presentation and one-endedness are assumed,
torsion-freeness excludes infinite torsion subgroups, and absence
of two-ended splittings makes the peripheral condition vacuous.
It gives D(B) a point. Treelike Theorem 6.1 then also verifies the
separate assertion that each cut point is parabolic. This latter
classification is not an extra premise needed by the fixed-class
criterion once D(B) is known.

## Adversarial boundary case and exact replay

Dropping ambient sequential completeness really can destroy the
second fixed point. Take Phi=[0,infinity) with its usual median
betweenness, p=0, U=(0,infinity), V={0}, and g(t)=2t. All these
subsets are full, their union is full, p is the unique facing
point, and g preserves them. Its only fixed point is 0, so no
fixed point outside V exists. The unbounded directed arc has no
endpoint in Phi. Adding an actual point infinity repairs this
example and g fixes that endpoint.

There is a second useful boundary check against an overstrong reading:
on the already complete interval [0,1], let g(t)=2t/(1+t),
U=(0,1), and V={0}. This is an order automorphism with inverse
t/(2-t); its only fixed points are 0 and 1. Thus the guaranteed second
fixed point may lie outside U as well as outside V. The fixed-point
numerator is exactly t(1-t), which `verify.py` checks as a polynomial
identity. The two fractional-linear matrices multiply in either
order to 2I; both determinants are positive and both affine
denominators are positive at 0 and 1, hence throughout [0,1].
The maps fix the endpoints, so they preserve [0,1] and its interior.
The determinant identity gives strict monotonicity on that interval.
These exact matrix and sign checks certify the inverse and every
construction hypothesis, not merely sampled values. The manuscript
correctly asks only for a point outside V.

This is a counterexample to an intentionally weakened statement,
not to the manuscript: the manuscript explicitly assumes the
complete ambient flow completion. The algebraic fixed-point
equation (2-1)t=0 was checked by one bounded Jacobian nullspace
operation. The exact typed contract, payload, output, server
version and protocol are in the dedicated `jacobian_*.json`
files. Its status is successful, not timeout or UNKNOWN. The same
rational identity is formally proved by `doubling_fixed_iff`.
This tiny computation certifies only the boundary example's
linear equation; it is not being used to prove an infinite or
transfinite theorem.

`verify.py` checks the exact recorded formal certificate and its
source/fidelity freshness, the typed Jacobian result, and exhaustive
small-tree regression cases. Its `--replay-lean` option reruns the
real Lean compiler through the approved adapter and both official
campaign-local checks. The finite cases are regression experiments
only. The unbounded-sequence assertions are supplied by the actual
formal proof and the source-faithful mathematical argument above.

The actual Lean 4.31.0 compiler run succeeded with exit code zero,
an empty proof-hole list and a successful axiom audit. Its archived
certificate is
`certificates/C_APR_FORMAL_CORE-b8e2a3b647052f1e.json`.
The independent reading of statement fidelity is explicitly still
pending; the compiler does not supply it.

## Status and comparison with prior work

The prior source explicitly proves the nonparabolic-cut-point case
and uses its special stage-one argument in Lemma 6.12. We do not
import that argument. The present proof stops at stage one and
uses the source's parabolic fixed-set remark to justify the
higher-successor mechanism for the full cut set. It also isolates
the countable order-completeness needed for the second fixed point
and weakens torsion-freeness in the final criterion.

A narrow literature lookup found no directly matching formalization
or separately stated general all-parabolic criterion. That is a
bounded negative retrieval result, not verification of novelty;
the intrinsic order lemma is a standard fixed-point argument and
the higher-successor method is explicitly Bowditch's. No claim
of `verified_new` or campaign-final publishability is made here.

No false literal manuscript assertion was demonstrated in this
mission, so no `F_...` or `refutes` judgement is warranted. The
independent Host-invoked Reviewer must check the source readings,
the rooted-order translation, the full transfinite proof, and
statement fidelity. The complete Singer theorem, the block
construction and path-pushing arguments remain outside this
mission and unverified by this result.
