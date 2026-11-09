# A two-scale verification of bounded-tuple reversal

## Result and scope

Let K be an AEC, in the precise sense of `main:aec` in the staged
manuscript, categorical in unboundedly many cardinals. For every fixed
infinite cardinal theta there is b such that, if kappa >= b is a
categoricity cardinal, M has size kappa, f:M -> M is strong, and
a=(a_i) has length at most theta, there is a strong g:M -> M with
g(f(a_i))=a_i for every i.

The argument below verifies `found:reversal`. It does not impose
amalgamation, cf(kappa)>theta, or kappa^theta=kappa. Its use of a
second, larger categoricity size is essential: a^theta is paid for at
that larger size, not at a. All constructions and choices below have
set length. The only background foundations used are ZFC and the AEC
axioms; no unrestricted syntactic-characterization theorem is imported.

This is a mathematical proof audit of a theorem already stated in the
staged manuscript, not a claim to have discovered a new theorem or
verified the entire eventual-categoricity manuscript. `Main.lean`
checks the coefficient-code transport and abstract orbit-elimination
core. It does not encode the AEC axioms or all of the set-theoretic
construction below. Those parts require independent mathematical
review. In particular, a successful compiler run alone is not being
called a formal proof of `found:reversal`.

## 1. The order presentation really is available

The chain axioms give directed unions. Here is the needed reduction,
including smoothness. Induct on the cardinality kappa of a directed
family. Finite families have a common maximum, and countable families
have a cofinal increasing omega-sequence. At uncountable kappa, fix a
binary operation choosing upper bounds on its index set. Exhaust that
set by cf(kappa) many increasing, continuous, nonempty subsets of size
less than kappa closed under the operation. Closing an infinite set
under one binary operation takes only countably many iterations and
preserves its cardinality. The subsets can therefore be chosen below
kappa, including when kappa is singular. Their unions are strong
models by induction and form a strong chain, by the inductive
common-upper-bound clause. The chain axioms finish both assertions.
The usual quotient of a directed system of injective strong maps has
these models as a directed family of images, so the same proof gives
coherent strong direct limits.

For completeness, the finite partition input to the presentation is
proved by induction on arity. If arity k has source bound alpha, the
residual-set tree for arity k+1 has at most
b=xi^|alpha| nodes through height alpha. A node names its least point
and partitions its remainder by all colors on k-subsets of the
already named sequence. There are at most b possible profiles at each
node and at most b^|alpha|=b nodes, including limit branches. In a
source of cardinality greater than b, a point never removed as a node
label determines a branch of length alpha, including all its limit
intersections. Colors on increasing (k+1)-tuples on this branch depend
only on the first k entries. The arity-k assertion finishes. Iterating
this argument handles any specified finite list of arities.

Inside arbitrarily large models choose strong models M_s of size at
most ell=LS(K) on each nonempty finite skeleton subset s, containing
all M_t for nonempty t properly contained in s. Enumerate M_s by ell
names, with the skeleton entries designated. Color s by the complete
atomic diagram, with negations, of all these enumerations on its
nonempty subsets. There are at most 2^ell colors at a fixed arity.
Successive finite-arity thinning and pigeonhole over this *set* of
colors choose coherent colors d_n, each finite initial list of which
has arbitrarily large realizations. No infinite simultaneous
homogeneous set is needed.

On any nonempty order I, quotient the names (s,eta), eta<ell, by
the equalities in d_|s union t|. Interpret functions and relations in
a color containing the finitely many relevant supports. Every finite
instance is realized in an actual sample, so equivalence, independence
of representatives, and the structure laws follow. The names on s
form a copy of an actual M_s. For s contained in t their pair is a
copy of an actual strong pair. Directed unions give E(I) in K and
strong subpresentations. Position substitution gives strong maps and
is functorial. The distinct designated skeleton gives
|I| <= |E(I)| <= |I|+ell. This discharges the presentation dependency,
rather than assuming an unproved infinitary characterization.

## 2. Finite-support orders and balanced cuts

For an infinite limit ordinal d put G_d=Z^(d) and H_d=Q^(G_d),
both with finite support and greatest-differing-coordinate order.
The integer group has least positive element e_0; in particular each
g has immediate predecessor g-e_0. Its two end cofinalities are
cf(d): basis vectors on cofinally many ordinal positions witness the
upper bound, and fewer than cf(d) finite supports are bounded in d.
Consequently H_d has size |d|, is dense without endpoints, and each
point has character cf(d) on both sides. For the last assertion,
positive basis vectors at ranks coinitial in G_d approach zero; fewer
than cf(d) ranks have a strict lower bound.

Translations identify rays. To identify positive vectors, first
translate their G_d indices until the leading rank is the same g.
Write them as a*u_g+v and b*u_g+w with a,b positive rationals and
lower-rank v,w. The linear substitution

    u_g |-> (b/a)*u_g + (w-v)/a

fixing the other basis vectors is invertible and preserves the sign
of every nonzero vector. It sends the first vector to the second.
Thus any increasing pair can be sent to any other increasing pair;
bounded open intervals are isomorphic.

Every interior nonprincipal cut of G_d is balanced. Choose the least
ordinal rank alpha of a difference across the cut, and a crossing
pair of that rank. In their common head above alpha, each fixed
integer-coefficient fiber lies on only one side, since crossing inside
it would lower the rank. The coefficient cut is between adjacent
integers. The two bordering fibers are cofinal and coinitial in the
original sides, and have tails Z^(alpha), whose end characters agree
by negation. Alpha=0 would make both sides principal and is excluded.

For a nonprincipal cut (L,R) in H_d, let
T={rank(r-l): l in L, r in R}. Subtracting a positive basis vector
at a larger rank from l shows that T is a final segment of G_d.
If T has least member g, the cut within a common head is a cut of
the rational coefficients. An irrational coefficient cut has
characters (omega,omega). If a coefficient side has an endpoint,
its whole fiber is on that side. The lower-rank tail has greatest
available index g-e_0 and therefore both end characters omega,
as witnessed by integer multiples of u_(g-e_0). The opposite
coefficient side has a countable approximation. This case is balanced.

Suppose T has no least member, and write epsilon=ci(T), S=G_d\T.
If, for some l in L, the ranks of r-l, r in R, are coinitial in T,
the coset l+H_S lies in L and is cofinal there: a point above the
whole coset would differ from l at rank h in T, while a crossing
rank below h would put an upper point below it. Nonprincipality
forces S nonempty. S has no greatest member, since otherwise its
successor would be the least member of T. Balance in G_d gives
cf(S)=epsilon, and hence cf(L)=cf(H_S)=epsilon.

Otherwise each l has t_l in T strictly below every crossing rank
from l. Choose crossing pairs (l_i,r_i) with ranks coinitial in T,
indexed by epsilon. A pair of rank at most t_l must have l_i>l:
if l_i<=l, then 0<r_i-l<=r_i-l_i, contradicting the choice of t_l.
The l_i are thus cofinal. Fewer than epsilon proposed cofinal points
have bounds t_l with a common strict lower bound in T; a crossing
pair below that bound lies above all of them. Thus cf(L)=epsilon.
Negate and exchange the sides. Difference ranks, and therefore T,
are unchanged, so the same proof gives ci(R)=epsilon. This covers
every case and proves balance in H_d.

## 3. Short order orbits, with no saturation shortcut

In a dense order with the interval homogeneity and balance just
proved, and point character kappa, a half-open segment approaching
a nonprincipal cut of regular character epsilon<kappa depends only
on epsilon, its direction, and its displayed endpoint. Prove the two
directions simultaneously by induction on infinite regular epsilon.
Use a strictly cofinal epsilon-sequence starting at the endpoint.
Successor blocks are bounded intervals with one endpoint adjoined.
At a nonzero limit i<epsilon, the cut generated by the preceding
sequence has character cf(i) on its lower side. Its upper side
cannot have a first point, since that point would have character
cf(i)<kappa. Balance supplies the other character. The opposite-
direction induction assertion at cf(i)<epsilon identifies this
limit block. These blocks partition the segment: take the least
index whose chosen point is above a given point. Decreasing
sequences give the reverse-direction assertion. At epsilon=omega
there are no nonzero limit blocks, so the induction starts.

Now let theta<cf(d). A sequence of at most theta entries in H_d
is classified up to order automorphism by its order/equality diagram
and the occupancies of all strict slots over its distinct entries.
To prove sufficiency, match the entries and work slot by slot.
Choose an interior point of an occupied slot. Each half is a ray,
a bounded interval with endpoint, or a segment approaching the cut
generated by a side of the parameter set without an endpoint.
That cut has character at most theta; it is nonprincipal because
all point characters exceed theta, and it is balanced by Section 2.
The preceding segment classification identifies the two halves with
their shared interior point matched. Glue all these maps and the
entry map. Empty slots agree by hypothesis, and the entries and
slots partition the order. The resulting map is an order
automorphism. This proves the claimed orbit classification, not a
finite analogue of it.

A theta-tuple in E(H_d) has a record consisting of its labels, the
order/equality pattern of its flattened finite index lists, and all
slot occupancies. A fixed record set R_theta of size at most

    B = 2^(2^(ell+theta))

suffices. There are at most 2^(ell+theta) label/arity assignments,
at most 2^theta diagrams, and at most 2^(2^theta) occupancy choices.
Equal records yield an order automorphism, hence a model
automorphism. For any categoricity cardinal kappa>=max(ell,theta^+),
use d=kappa+theta^+ in ordinal addition. It has size kappa and
cofinality theta^+, even when kappa is singular. Thus the
theta-tuple model-orbit bound B holds at every such kappa.

Name each orbit injectively in B. Names are independent of the
isomorphism chosen from a copy to the fixed model. A profile is the
named strong-self-map arrow relation R, together with the partial
map F:R_theta -> B sending each realized record to its orbit name.
The latter is well-defined by the orbit argument. There are at most
2^B profiles. In particular, equality of profiles includes equality
of *both* realized-record domains and their name values.

## 4. Support closure and appended-segment occupancy

Let theta^+<=a<cf(beta). Starting with S of size at most a, build
S_i, i<theta^+, increasingly. At each successor, consider every
strict slot over the whole well-order S_i. There are at most
|S_i|+1 slots. Add all points of each finite slot and countably
many points of each infinite slot. This realizes every *finite*
pattern over S_i that occurs in beta, including repetitions and
equalities with S_i. At limits take unions. All stages and
T0=union S_i have size at most a.

Every at-most-theta subset P of T0 is contained in some S_i:
the supremum of its at-most-theta entry stages is below the regular
cardinal theta^+. Match any finite tuple over S_i at the next stage.
This proves the required finite-pattern property over P. Since
|T0|<=a<cf(beta), T0 is bounded in beta. At each stage the slot
above S_i is infinite, since beta has cofinality greater than a.
The next stage adds a point above the whole stage. Thus every
at-most-theta subset of T0 has a strict upper bound in T0, and
cf(T0)>theta. This explicitly discharges support closure.

Assume beta is additively indecomposable. Choose alpha<beta
strictly above T0. For an indecomposable delta<beta with
otp(T0)<delta and cf(delta)>theta, the consecutive interval
J=[alpha,alpha+delta) lies in beta, since alpha+delta<beta.
Set T=T0 union J. Its order type is delta because
otp(T0)+delta=delta.

Here is the complete pattern-matching check. Fix P subset T of
size at most theta and a finite tuple from beta. Match its part
below alpha into T0 over P intersect T0, keeping all order and
equality relations in that finite part. Keep its part in J fixed.
The points of P intersect J, together with the retained finite
part in J, are bounded in J. Match all tuple coordinates at or
beyond alpha+delta by enough distinct points of J above that
bound, respecting their order and repetitions. The three parts
remain in the right mutual order and have the correct comparisons
with every parameter in P. This includes the potentially dangerous
final slot after the appended segment.

For any at-most-theta sequence of points of H(T), collect all
ordinal positions in its finite codes into P, still of size at
most theta. A witness in H(beta) for an occupied strict slot uses
only finitely many additional positions Q. The pattern property
gives a strictly increasing injection on P union Q into T fixing
P. Keep every integer and rational coefficient. Both levels of
greatest-differing-coordinate comparison are preserved, so all
strict inequalities to all sequence entries remain true. Distinct
integer rank codes remain distinct, so no rational coefficients
are accidentally merged. The transported point belongs to H(T)
and witnesses the same slot. Inclusion gives the converse.
`leadingLT_transport`, `nestedLT_transport`, and `slot_transport`
in `Main.lean` verify this coefficient-code implication for
arbitrary index sets, not just for finitely enumerated examples.
This discharges appended-segment occupancy.

## 5. Alignment and a common profile at two sizes

Suppose a<mu are categoricity sizes, a>=max(ell,theta^+).
Suppose an indecomposable beta of size mu and cf(beta)>a
has a profile also occurring cofinally on indecomposable ordinals
delta<a^+ of size a and cofinality greater than theta.
Represent a prescribed at-most-a subset of E(H(beta)) by labels
and collect its ordinal positions. Section 4 gives T0 of size at
most a, whose order type is below a^+. Choose a profile occurrence
delta>otp(T0) from that cofinal set. Since
delta<a^+<=cf(beta)<=beta, the appended construction applies.

A=E(H(T)) is strong, has size a, and contains the prescribed set.
Every theta-tuple of A has a presentation using indices in H(T).
Its record agrees with the ambient record by occupancy reflection.
The order isomorphism delta -> T identifies it with the same
record in E(H(delta)). Equality of the profile maps F then gives
equality of its small and large orbit names. This is simultaneous
for *every* tuple of A, not a choice of A depending on one tuple.

To obtain the hypotheses, note first that, for every infinite
regular tau<=kappa, indecomposable ordinals of size kappa and
cofinality tau are cofinal below kappa^+. Given eta<kappa^+,
take a limit rho>eta of size kappa and cofinality tau, and put
delta=omega^rho. Finite Cantor normal forms give
|delta|=kappa, and continuity plus boundedness of fewer than
cf(rho) exponents gives cf(delta)=tau.

Suppose irreversible orbit arrows occur at unboundedly many
categoricity sizes. Let P=2^B. Choose P^+ increasing such
sizes kappa_i>P with

    kappa_i > kappa_j^theta (j<i),
    ell,theta,kappa_j < tau_i <= kappa_i (j<i),

where tau_i is infinite regular. This is possible by bounding the
set of earlier sizes and their powers, choosing a regular successor
above it, and then a larger failing categoricity size.

At each size, a profile occurs cofinally among the indecomposable
ordinals of cofinality tau_i: otherwise at most P bounded fibers
would cover a cofinal subset of the regular cardinal kappa_i^+.
Two of the P^+ sizes have the same recurring profile. Call them
a<mu. Then a^theta<mu, tau_mu>a, and their common relation has
p R r but not r R p. Both names occur at both sizes, since
the named relation contains the identity on every occurring name.
Alignment applies inside *any* mu-model after choosing a copy of
one of its recurring presentations. This discharges common-profile
selection without a restriction on cf(a) or cf(mu).

## 6. Elimination, including every limit

The carrier of R here is the set Q of *occurring* orbit names, not
all of the bounding cardinal B. It is recovered from a profile as
Q={q:(q,q) belongs to R}, so equal profiles have exactly the same
carrier. The named arrow relation on Q is reflexive and transitive.
For transitivity, align the middle representative by an
automorphism before composing strong maps. If q cannot reach p
and q R q', then q' cannot reach p. Otherwise transitivity
gives q R p. In particular, r cannot regain reachability to p.

We spell out the limit point, rather than assuming that a property
preserved at successors survives arbitrary unions. An inclusion
from *any earlier* mu-model into a later mu-model is a strong
map between copies of the same categoricity model. It gives a
direct R-arrow between the two names of the tuple. At a limit,
the AEC union axiom supplies exactly this inclusion into the
union. As long as that union has size mu, the same statement
applies. Exclusion therefore persists at limits by transitivity,
not by a topological or compactness assertion.

Now carry out theta^+ rounds of an increasing chain of mu-models.
At the start of round i choose an aligned a-submodel A_i containing
all earlier A_j. Their union has size at most a because i<theta^+
and theta^+<=a. Coherence makes all earlier A_j strong in A_i.
Process all a^theta tuples of A_i. If a tuple's current name
cannot reach p, leave the model unchanged. Otherwise compose
its arrow to p with p R r, and realize that composite by a
strong self-map, aligning representatives by automorphisms.
Rename its codomain along that injection so that it becomes an
extension by inclusion of the old model. Its old underlying tuple
now has name r. It is henceforth excluded from reaching p.

Take strong unions at limit steps. The number of stages has
cardinality at most theta^+ * a^theta = a^theta <= mu.
Every stage and every such union therefore has size exactly mu.
No regularity of mu is used. The direct transition argument above
proves that each processed tuple stays excluded at all later
large stages. This discharges limit persistence.

Let A=union_(i<theta^+) A_i. It is strong-chain union of size a.
Every theta-tuple of A is contained in one A_i, because theta
coordinates have entry stages bounded below the regular theta^+.
After that round the tuple cannot reach p in the large model.
At the next aligned A_(i+1), its small name equals its current
large name and is also excluded. The strong inclusion A_(i+1)->A
gives an R-arrow *at size a* from that name to its final name.
The relations at size a and mu are the same by the common profile,
so transitivity excludes the final name too. We have used equality
of names only at aligned stages, not an unjustified cross-size
arrow.

But A is a copy of C_a, so its tuples include the orbit named p,
and p reaches itself by the identity. Contradiction. Thus failing
categoricity sizes are bounded.

For a particular f and tuple a, symmetry gives an arrow from the
orbit of f(a) back to the orbit of a. Precompose its witnessing
map with an automorphism carrying f(a) to the chosen source
representative, and postcompose with one carrying the target
representative to a. The resulting strong g satisfies g(f(a))=a.
Pad nonempty shorter tuples by repetitions. For the empty tuple
the identity suffices. This proves the stated theorem.

## What remains outside the conclusion

The proof graph leaves both manuscripts' principal conclusions open.
In particular, none of the later bounded-placement, calculus,
isolation, geometric boundary, common-level, or cardinal-transfer
arguments is certified by this audit. The CH construction is
decomposed but not verified here.

The independent Reviewer must check this infinite argument, the
translation from genuine finite-support vectors to the formal code
lemmas, and the statement-fidelity document. No literal manuscript
assertion has been identified as false in this route, so there is
no F_ claim to refute. The historical forcing gap is not promoted
to a new manuscript counterexample. Novelty and publishability are
not established by the compiler or by the bounded source lookup.

## Exact replay

From the campaign root run:

    python3 research/reversal_audit/verify.py

The script recomputes finite sign/transport and preorder sanity checks,
replays the archived Jacobian Horn closure, and runs the real Lean
4.31.0 compiler and axiom audit through the authorized Argus interpreter.
It attaches mechanical evidence only to `C240_FORMAL_CORE`, runs both
campaign-local structural checks, and writes `exact_certificate.json`.
Its output explicitly distinguishes the formal core from the full
mathematical argument and from any unestablished novelty claim.
