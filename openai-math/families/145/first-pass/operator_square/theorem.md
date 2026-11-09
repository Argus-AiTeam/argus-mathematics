# Square locality forces exact common factors

## Result and scope

**Theorem (C_OP_CORE).** Let k >= 3. Fix a probability law on a k by k
array of standard-Borel cell spaces satisfying all the square-locality
hypotheses below. At every cell the row-active and column-active orthogonal
projections commute. Their common range D is the closed linear span of the
unimodular lines exact simultaneously for the full k-coordinate row and
column laws. In fact D is L2 of a compact metrizable abelian group factor
with Haar distribution. Each conditional row or column Markov operator,
restricted to the common ranges at its endpoints, is almost surely unitary.
Consequently their positive polar parts on these ranges are the identity.

This is a proof of the full standard-Borel implication, not an inference
from the finite experiment. It verifies the implication in
`lem:contraction-completeness` and `prop:common-exact-lines` of the staged
`build/sections/04-operators.tex`. The Haar-factor and unitary-transport
conclusions make additional consequences explicit. No false assertion in
that section has been established. In particular there is no justified
`F_...` refutation claim.

The hypothesis that the square has these kernels is not proved here.
Saturation, rolling, parameter geometry, subsequent label selection and
orbit cancellation, and the full multiple-mixing theorem remain outside
this result. A pointwise proof at a fixed typical parameter array E does
not select reference unitaries or bases measurably in E.

The companion Lean proof certifies only the typed operator identities,
totality-to-fixed-square step, fixed-square injectivity, dense-range
cancellation and algebra of the contraction projection identity.
The conditional-probability, support and completeness arguments below
require independent mathematical review. `verify.py` additionally gives
an exact adversarial finite experiment and checks the actual compiler
certificate; neither is represented as a kernel proof of this whole theorem.

## Hypotheses, without an axis interchange

These are the fixed-E assertions of `prop:square-locality` in
`build/sections/03-arrays.tex`, with its inherited proper coordinate
marginals.

1. Each proper family of full rows has the product of its row laws, and
   each proper family of full columns has the product of its column laws.
   Each proper coordinate marginal within a row or column is the product
   of its cell marginals.
2. For every set R of at most k-2 parent rows, conditional on their full
   states every proper family of columns is independent. A column's
   conditional law is its original column law conditioned only on its
   entries in R.
3. If a is not in R, the law of cell (a,j), conditional on the parent rows
   and all columns other than j, is the own-row kernel given the remaining
   entries of row a.

We also use precisely the grouped form included in that proposition.
Partition the rows into ordered nonempty groups P,A,B and the columns
into ordered nonempty groups r,s,t. Each grouped row and column has a
pairwise independent three-cell law. Given the whole grouped row P, any
two grouped columns are independent with their own column laws conditioned
only on their entries in P. Given that row and the full grouped columns
r,s, the law of Y[A,t] is its own grouped-row kernel given Y[A,r],Y[A,s].
These statements hold for every ordering within each axis. They do not
assert that the axes are interchangeable.

One can either take this grouped assertion as an inherited hypothesis,
as we do, or use its derivation in the square-locality proposition.
Nothing in this proof asserts that mere pairwise independence of all
row and column triples suffices.

## 1. Rectangle identities and the reducing spaces

Write z=Y[P,r], c=Y[P,s], d=Y[P,t], x=Y[A,r], y=Y[B,r].
The triples (z,c,d) and (z,x,y) are pairwise independent, and
(c,d) and (x,y) are conditionally independent given z. Indeed the
conditional law of column r given the entire row P uses only z.
Thus each single variable of either pair is independent of the entire
opposite pair: for example

    E[f(x) g(c,d)]
      = E[E[f(x)|z] E[g(c,d)|z]]
      = E[f(x)] E[g(c,d)].

In particular (c,x,d), (c,y,d), (x,d,y), (x,c,y) all have product law.
This is stronger than simply knowing pairwise independence of five cells.

Use the four Hilbert spaces H1=L2(Y[A,s]), H2=L2(Y[A,t]),
H3=L2(Y[B,s]), H4=L2(Y[B,t]). Define

    F(x): H2 -> H1,       G(y): H4 -> H3,
    K(c): H3 -> H1,       N(d): H4 -> H2

as the conditional row A, row B, column s and column t Markov operators,
respectively. Pairwise independence makes their source and target
marginals fixed, so they and their adjoints are contractions.

Here is a direct derivation of the two identities, including the reversed
orientation. Condition on z,c,d,x,y. The joint spaces for the remaining
two cells in columns s and t have the original column laws conditioned
on c and d. This follows from the conditional independence of either
column from column r given row P. Let Q map the column-t joint L2 space
to the column-s joint L2 space by conditional expectation; let i[A,s],
i[B,s],i[A,t],i[B,t] be the four coordinate isometries.
The own-row kernel and its version with s,t reversed give

    Q i[A,t] = i[A,s] F,       Q i[B,t] = i[B,s] G,
    Q* i[A,s] = i[A,t] F*,     Q* i[B,s] = i[B,t] G*.

Since K=i[A,s]* i[B,s] and N=i[A,t]* i[B,t], composition yields

    F N = K G,                F* K = N G*.                 (1)

All equalities are almost sure. Countably many dense vector tests make
them simultaneous; none requires choosing an exceptional set separately
for every vector.

For each cell let V be its row-active space and W its column-active space.
The essential closed span of the ranges of an incident row family F(x)
is V at its target. To see this, row product tests give exactly the vectors

    integral w(x) F(x)h dmu(x).

Varying bounded w and a countable dense family of h shows that the
orthogonal complement of their span is precisely the set orthogonal to
F(x)h for almost every x and every h. The reverse row family has the
analogous property. Column families similarly have essential range span W.
Each edge maps into its own-direction active space and kills the
orthogonal complement of that space at its source.

Equation (1) puts K(c)G(y) in the target row-active space. Independence
of (c,y) and totality of the G ranges imply K(c)V_source is contained
in V_target for almost every c. The adjoint of the second identity
gives the reverse containment for K(c)*, using independence of (c,x).
Consequently

    P[V_target] K = K P[V_source].                         (2)

The first identity and independence of (x,d), and then the second and
independence of (x,c), give

    P[W_target] F = F P[W_source].                         (3)

These are reducing-space statements, not one-way invariance assertions.
They hold at every edge by permuting row groups and column groups.

Equation (2) says that P[V] preserves the essential range span W of the
column family. Since P[V] is self-adjoint it also preserves W-perp.
It therefore commutes with P[W]. Define

    D = V intersect W,        P[D] = P[V] P[W].

The active spaces, their projections and D are invariant under conjugation.
Combining (2),(3) with the own-direction reductions shows that every edge
intertwines P[D] at its endpoints. Projecting the total range spans onto
D shows that each restricted edge family and each reverse family has
essential range span equal to the full D at its target.

## 2. Positive parts: dense cancellation, never bounded inversion

Now restrict F,G,K,N to the four D spaces. Their types remain the four
distinct types above. Associativity and the adjoints of (1) give

    KK* F = F NN*,           K* K G = G N* N,
    F* F N = N G* G,         FF* K = K GG*.                (4)

These are the four universally quantified identities proved in
`OperatorSquare.rectangle_squares`; the exact word-rewrite certificate
checks the arrow type of each intermediate composition.

The parameter triples in the four equations of (4), in order, are the
four product-law triples identified above. Compare two independent c
values in the first equation, keeping x,d fixed. Fubini gives

    (K(c)K(c)* - K(c')K(c')*) F(x) = 0

for almost all (c,c',x). Totality of the F ranges implies the difference
is zero. Taking adjoints and comparing d values similarly makes NN*
fixed, using totality of the F* ranges. The second equation makes K* K
and N* N fixed; the third makes F* F and G* G fixed; the fourth makes
FF* and GG* fixed. These arguments use essential totality, not the
existence of a single surjective edge. The formal theorem
`fixed_target_squares` checks the total-range algebraic step; the
Fubini reduction itself is part of this probability proof.

If v is in the kernel of the common source square F(x)*F(x), then
F(x)v=0 for almost every x. Hence v is orthogonal to the ranges of
almost every F(x)* and is zero by totality. All source and target
squares are injective by the same reasoning. This is the formal
`total_adjoint_fixed_square_injective` argument, with almost-everywhere
totality in place of its parameter-set formulation.

Put A=|F| and B=|G|, both fixed positive contractions. Write
F=U_F A, G=U_G B. Since each edge and its adjoint have zero kernel,
the polar parts are unitaries, even when A or B has no bounded inverse.
From A^2 N=N B^2, uniform polynomial approximation to the square root
on [0,1] gives A N=N B. Thus FN=KG implies

    (U_F N - K U_G) B = 0.

An injective self-adjoint operator B has dense range, so cancellation
is valid by continuity; it does not mean multiplication by B^{-1}.
`cancel_dense_range` formalizes exactly this distinction. The two sides
of U_F N=K U_G have polar decompositions with polar parts U_F U_N and
U_K U_G. Uniqueness gives

    U_F U_N = U_K U_G.                                    (5)

For completeness, the elementary Hilbert facts used here can be obtained
without an external classification theorem. A positive contraction S
has a positive square root given by the uniformly convergent binomial
series for sqrt(1-(1-S)); its coefficients after the constant have one
sign and absolutely summable absolute values. The finite sums are
polynomials, their squares converge to S, and positivity follows from
0 <= (1-S)^n <= 1. A positive square root commutes with every operator
intertwining S, by those same polynomials. If two positive roots of S
exist, the polynomial root commutes with either; their difference
annihilates the range of their sum and vanishes on its kernel, proving
uniqueness. For T with both kernels zero, the map |T|v -> Tv is an
isometry between dense ranges and extends to its polar unitary.
This also proves the uniqueness just used. The approximations
T(T*T+epsilon I)^(-1/2), bounded for each epsilon, converge strongly
to that unitary and show measurability of the polar families.

## 3. The normalized polar group and its corner ratio

Write the polar variables in (5) as a(x), b(y), c0(c), d0(d).
They obey a d0=c0 b. Given almost every z, the pair (a,b) is independent
of the pair (c0,d0); each individual marginal equals its unconditional
marginal. Give unitary operators the strong topology, in which
multiplication and inversion are continuous. These are Polish spaces.

Fix one such value z0. The continuous equation holds throughout the
product of the two conditional pair supports. Choose one reference
point from each support. Their equation makes compatible unitary
identifications of the four vertex spaces with one Hilbert space H.
After these fixed identifications both reference pairs equal (I,I).
Fixing this pair on either side shows that the first conditional pair
is supported on a=b and the second on c0=d0. Hence a,b have a common
unconditional law rho, and c0,d0 a common law tau; both supports contain I.
Substituting arbitrary supported diagonal pairs shows that the supports
of rho and tau commute elementwise.

For general z, fix a typical actual pair (u,v)=(c0,d0).
Conditional independence and a=u b v^{-1} give

    rho = u rho v^{-1}.

Unconditionally c0,d0 are independent. Continuity of translation on
probability measures therefore extends this equality to every
u,v in supp(tau). The symmetric argument gives tau=u tau v^{-1}
for every u,v in supp(rho).

Take v=I. Each support is invariant under left translation by every
element of the other support. Since both contain I, they contain each
other. Their common closed support G satisfies gG=G for every g in G.
It is a group: closure under products follows from gG=G, and
I in gG supplies g^{-1} in G. It is abelian by the previously proved
cross-commutation. Both rho and tau are left invariant.

Here is a direct compactness/diagonalization argument; no local
compactness of the entire unitary group is being assumed. Choose a
positive injective compact Q on the separable H, diagonal in any basis
with summable strictly positive entries. The map U -> U Q U* is
norm-continuous on the strong unitary group, by finite-rank approximation.
Its norm integral

    Q0 = integral U Q U* drho(U)

is positive and compact, as a norm limit of finite sums of compact
operators. It is injective because its quadratic form on any nonzero
vector is an integral of strictly positive numbers. Left invariance of
rho makes Q0 commute with G.

An injective positive compact self-adjoint operator has an orthonormal
basis of eigenvectors with finite-dimensional positive eigenspaces.
One elementary proof is as follows. For a positive operator S, its
positive quadratic form satisfies Cauchy--Schwarz, so
||Sv||^2 <= ||S|| <v,Sv>. Taking the supremum also gives
sup_{||v||=1}<v,Sv> = ||S|| when S is nonzero.
A unit sequence maximizing <v,Sv> then
satisfies (S-||S||I)v -> 0. Compactness supplies a convergent subsequence
of Sv and thus a unit eigenvector with eigenvalue ||S||. Repeat on the
orthogonal complement. Each positive eigenspace is finite dimensional,
and eigenvalues in an infinite list tend to zero by compactness.
The norm of the remaining restriction is bounded by every preceding
maximal eigenvalue, so it is zero after an infinite list tending to zero.
Injectivity then rules out a nonzero residual space. The finite-list case
ends in the same way, since a nonzero positive restriction would supply
another eigenvector. This proves the asserted spectral fact.
It agrees with the independently consulted primary statement in
Axler, *Measure, Integration & Real Analysis*, Theorem 10.106,
printed page 329; it is not the erroneous theorem number returned by
an initial secondary search.

Each finite-dimensional eigenspace of Q0 reduces all the commuting
unitaries in G. Simultaneous diagonalization there (split by a nonscalar
member and induct on the dimension) gives an orthonormal basis (e_n)
of common eigenvectors. Write Ue_n=gamma_n(U)e_n. The gamma_n are
continuous circle-valued characters. On diagonal unitaries, strong
convergence is exactly coordinatewise convergence, by finite basis
truncation of vectors. Thus G is a closed subgroup of the compact
countable product of circles, hence is compact metrizable.
Its invariant probability is Haar probability; uniqueness, and in
particular rho=tau, follows here directly by integrating f(uv) against
rho(du)tau(dv) in the two orders and using commutativity and invariance.

The two ratios a b^{-1} and c0 d0^{-1} are equal and conditionally
independent given z. Their conditional law is a point mass: the product
of their conditional supports lies in the diagonal, so each support
is a singleton. The Dirac embedding of the compact metric G into its
probability measures is a measurable isomorphism onto its image.
Consequently, for a measurable G-valued h,

    a(x) b(y)^{-1} = c0(c) d0(d)^{-1} = h(z).              (6)

Since a,b are independent with Haar laws, h(z) also has Haar law.
For every finite monomial gamma in the gamma_n and their conjugates,

    gamma(h(z)) = gamma(a(x)) conjugate(gamma(b(y)))
                = gamma(c0(c)) conjugate(gamma(d0(d))).   (7)

This is an exact tuple in column r and an exact tuple in row P.
The monomials span L2(sigma(h)). Indeed their coordinate characters
generate the Borel sigma-field of G, and trigonometric polynomials
are dense for the actual law of each finite coordinate tuple.
One can see the latter without assuming that law is Lebesgue measure:
a function orthogonal to all monomials defines a finite complex measure
with all Fourier coefficients zero. Convolution with each product
Fejer kernel is zero; the approximate-identity property on continuous
functions makes that measure zero. Continuous functions are dense in
L2 of a finite Borel measure on a compact metric space, by regularity.
Density over the increasing finite-coordinate fields gives the claim.

## 4. The reverse inclusion: all L2 contractions, not an assumed algebra

In a grouped row let

    C_r(g,h) = E[g(Y_s) h(Y_t) | Y_r].

Pairwise independence gives

    ||C_r(g,h)||_2 <= ||g||_2 ||h||_2.                     (8)

For bounded g,h and the row edge L_{r<-t}(v) conditioned on Y_s=v,

    C_r(g,h) = integral g(v) L_{r<-t}(v)h dmu_s(v).

This is a Bochner integral in the fixed target Hilbert space.
Intertwining of the common-active projections, already proved in
Section 1, permits moving P_r through this integral:

    P_r C_r(g,h) = C_r(g,P_t h).

Using the edge from s to r conditioned on Y_t instead gives
P_r C_r(g,h)=C_r(P_s g,h). Bound (8) extends both identities to
arbitrary L2 inputs, even when the projected inputs are unbounded.
Idempotence then gives the full formula

    P_r C_r(g,h) = C_r(g,P_t h)
                = C_r(P_s g,h) = C_r(P_s g,P_t h).        (9)

The last algebraic step is `contraction_projection` in Lean.
Unrestricted contractions span the row-active space by product-test
density. Projecting this dense span onto D_r and using (9) shows that
the restricted contractions lie in D_r and span it. The identical
argument, applied to the already established column intertwining,
gives the column assertion. This does not exchange the array axes.

In row A, for g in D[A,s], h0 in D[A,t],

    C_{A,r}(g,h0)(x) = <conjugate(g), F(x)h0>.

The space D[A,s] is conjugation invariant and F(x)=a(x)A0 with fixed A0.
Every coefficient in this display is therefore measurable in a(x)
alone. Since restricted contractions span D[A,r], and a factor L2
space is closed,

    D[A,r] is contained in L2(sigma(a(x))).

Similarly D[B,r] is contained in L2(sigma(b(y))).
Now apply restricted contraction spanning in column r. Given z,
b has its unconditional Haar law rho and a=h(z)b by (6), so for bounded
measurable f,g

    E[f(a)g(b)|z] = integral f(h(z)u) g(u) drho(u).

This is a function of h(z). Bounded approximation in the two marginal
L2 spaces and (8) extend the inclusion to all contractions of the two
D spaces. They span D[P,r]. Hence

    D[P,r] is contained in L2(sigma(h(z))).

Conversely (7) gives simultaneous exact unimodular functions in D[P,r],
and they span L2(sigma(h(z))). We have proved equality. No intermediate
step assumed closure of D under products: that closure follows only
now, for its bounded elements, from the factor description.
Permuting groups makes this conclusion valid at every grouped cell.

## 5. From every split to all individual coordinates

We first need the exact-line rigidity fact. In an m-coordinate law,
m>=3, with every m-1 coordinates independent, an exact tuple
product chi_i=c satisfies

    a_i = product_{j != i} a_j,       a_i = |integral chi_i| in [0,1].

If one a_i vanishes, at least two vanish and the equations force all
to vanish. Otherwise -log(a_i) satisfies 2b_i=sum b_j, forcing all
b_i=0. Thus the tuple is either constant in every coordinate or
zero mean in every coordinate. Quotients of exact tuples are exact.
It follows that distinct exact lines at a coordinate are orthogonal,
and that each line has a unique tuple of partner lines. Products and
conjugates give their abelian group structure; separability makes the
set of lines countable.

Isolate row a and column j as singleton groups, and split each
complement into two nonempty groups. The active spaces at (a,j)
are the full individual-row and individual-column active spaces,
regardless of these splits. Their projections commute by Section 1.
For each pair of splits, Section 4 supplies all lines simultaneously
exact for its split row and split column, with closed span the same D.

Hold the row-group partition fixed and vary the column partition.
Every family is a subset of the orthogonal exact-line family of the
same fixed split column law. Two subsets of an orthogonal family with
the same closed span are equal. Now hold a column partition fixed and
vary the row partition; the analogous argument uses the fixed split
row law. Thus each line from an initial family is exact for every
split in both directions. This is not an intersection of arbitrary
nonorthogonal spanning sets.

For k=3 these are already full-coordinate exact tuples. For k>3 fix
a unimodular representative chi at (a,j). For each split S of the other
row coordinates, exactness supplies unimodular factors a_S,b_S whose
product, after absorbing a scalar, equals conjugate(chi(Y[a,j])).
They define the same function phi of the other k-1 coordinates:
equality under the full row law implies equality under that product
marginal. For each singleton split, phi lies in one fixed
one-dimensional coordinate factor tensored with all the remaining
L2 spaces. The orthogonal projections onto these coordinate factors
commute; their product has one-dimensional tensor-product range and
fixes phi. Hence phi is a product of the individual unimodular factors,
up to a modulus-one scalar. This proves full row exactness.
The full column proof uses its own product marginal, not an axis symmetry.
Every line exact for both full laws is active for both, proving equality
of the asserted spanning space.

## 6. Unitary transport and the compact factor at an individual cell

For an individual row edge, use singleton column groups s,t and put all
remaining columns in the third group; isolate the row and split the
remaining rows into two nonempty groups. Section 1 then gives exactly
the intertwining for that edge conditioned on all other row entries.
The full column edge follows by isolating its two rows within the
original ordered axes, not by transposing the law.

For a row exact tuple product chi_j=c, the conditional edge from t to s,
given the other entries v, satisfies exactly

    L_{s<-t}(v) chi_t
      = c product_{j != s,t} conjugate(chi_j(v_j))
          conjugate(chi_s).                              (10)

The scalar has modulus one. Intertwining of the column-active
projections with this edge, and their conjugation invariance, implies:
if the source partner line is in its common space then the target
partner line is too. The reverse edge gives the converse.

Each D now has an orthonormal basis of the simultaneous exact lines.
Uniqueness of row partners makes (10) a bijection between the source
and target bases, up to modulus-one scalars and conjugation of the
representatives. There are only countably many basis lines, so on one
conull set of v the restricted edge is a unitary. The same proof applies
to a column edge using row-active intertwining. In particular all the
fixed positive parts from Section 2 are actually I.

Finally the compact Haar-factor construction of Sections 3--4 applies
to a grouping isolating any chosen individual cell; its D is independent
of that grouping. Thus P[D] is the conditional-expectation projection
onto that factor. Different reference choices or groupings describe
the same completed sigma-field because they give the same L2 subspace.
No canonical choice of group origin is asserted.

All the grouping choices and orientations are finite for fixed k;
Hilbert and kernel equalities were imposed by countable determining
tests. The pointwise conclusion is intrinsic to the original row and
column laws and therefore holds simultaneously at all cells on the
original conull set of E, without a measurable family of chosen bases.
This completes the proof of C_OP_CORE.

## Adversarial experiment and literature comparison

The exact model in `verify.py` is a product of five binary squares:
a row-and-column parity square U, two row-only parity squares R1,R2,
a column-only parity square C, and an independent square N. Their
respective support sizes are 16,64,64,64,512. The full product has
2^31 atoms but need not be enumerated: all the conditional laws split
componentwise under the observed cell coordinates. The script exhausts
each component's inherited kernels, then computes the product's active
spaces and contractions in its full 32-character Walsh basis.
The row-active, column-active and common dimensions are 8,4,2.
This deliberately distinguishes the two axes and gives proper active
subspaces rather than testing only a noiseless group square.

A separate full-support softened-parity law has pairwise independent
coordinates within each row and column, full two-dimensional active
spaces, and no nonconstant exact line. It is NOT a counterexample:
two column parities have product expectation 0 but the product of
their expectations is 1/64, violating proper-column independence.
The exact test rejects this tempting weakening of the hypotheses.

The primary literature retrieved in scope does not justify a novelty
claim for this theorem. De la Rue, arXiv:math/0603154v1, Definition 3.4
and Theorem 3.5, concern finite-alphabet stationary 3-dot self-joinings
and the periodicity/positive-entropy alternative, not this general
square-locality implication. Janvresse--de la Rue,
doi:10.1017/S0143385707000958, publisher abstract, concerns the additional
continuity/determinism condition on a stationary-process self-joining.
Ryzhikov, arXiv:2103.07435v1, abstract, describes Markov intertwinings
and outstanding joining questions; it is not a theorem asserting the
present conclusion. None of these is used as an unproved mathematical
input above. An initial secondary search overstated these sources
and gave incorrect Axler theorem numbers; those summaries are not
evidence. The author-hosted Axler PDF was actually opened at Theorem
10.106, but its needed positive-injective specialization was proved
directly above.

Relative to the initial ledger, which contained only the open audit
objective, the improvement is a complete proof of the requested
implication and its Haar/unitary consequences, plus a real formal
certificate for the load-bearing operator core. Novelty, publishable
significance and independent acceptance remain for the Host-invoked
Reviewer; this is not a claim that the full mixing manuscript is verified.
