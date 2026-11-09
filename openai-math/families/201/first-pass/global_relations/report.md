# Universal verification of common spectral relations

## Result, dependencies and scope

**Theorem (GLOBAL9000201 and its linkage prerequisites).** Under the original
spectral-case hypotheses of the staged manuscript and the reviewed
`ADMISS9000201`, `SPECTRAL9000201`, `RESPONSE9000201` and
`TRANSFER9000201`, the weighted active partition, functional linkage,
replication through every allowed partner size, and equal-size attainability
hold. There are arbitrarily large allowed sizes b and integers a, g such that

    a = a_b,  rho_b = a-g,  rho_(bM) <= Ma-g  for every M >= 1.

For any finite nonempty collection of independent generic size-b blocks,
the collective span of the selected-root Jacobian columns at **all**
strictly upper block-arrow inputs is exactly Ma-g dimensional. Its
annihilator is a g-dimensional compatible dual space. It projects
isomorphically to every loop-quotient dual, restricts isomorphically on
retaining any nonempty subcollection, and gives the exact annihilator of
every generic fixed-arrow pair map, in either orientation.

This does **not** say that the Jacobian at every individual arrow array
has rank Ma-g. At the diagonal array its rank is M(a-g), which can be
smaller. The assertion is about one common span, not a collection of
unrelated pointwise bounds.

The proof below is universal, not an extrapolation of the executable
experiments. It does not use cyclic compatibility, correction, lifting,
realization, generation, or the main division-ring theorem. Compared with
the strongest prior reviewed result, the conditional cyclic theorem, this
discharges its remaining global-relations premise rather than strengthening
or rerunning its certificate. Publication-level originality and the overall
campaign remain open. This Engineer submission still requires the normal
independent Reviewer.

The propositions read directly are `prop:active-partition` in
`responses.tex`, `prop:functional-linkage`, `prop:active-replication` and
`cor:equal-size-partners` in `linkage.tex`, and `lem:star-derivatives`,
`lem:tail-defect`, `lem:pair-quotient-surjectivity`, `lem:common-tangent`
and `prop:compatible-relations` in `global-defect.tex`. These files are
under the staged September 23, 2026 manuscript's `build/sections/`.
The reviewed foundation is `research/word_transfer/report.md`, particularly
Sections 2--4 and its simultaneous commuting-parameter transfer theorem.
No additional bibliography theorem is imported. The formal inverse,
implicit, and interpolation arguments needed here are proved below.
The project Wiki index had no relevant division-ring, linkage, or
constant-rank entry. No literature novelty claim is made.

The already retired separate-Jacobian-ranks route is not reopened:
F(x,u)=(x,xu) has a rank-one Jacobian everywhere on the isospectral set
x=0, but those columns collectively span a two-dimensional space.
Its unrestricted generic rank is two, so it is a counterexample only
to the weakened rank-on-the-fiber argument, not to the manuscript.

## 1. Objects and reviewed foundation

Let k have characteristic zero and all roots of unity; let A be a central
division k-algebra of degree d, and fix a splitting over an algebraic
closure K. Let w be a free series with coefficients in A commuting with
its letters, in the spectral case q_0(w) != 0. All input matrices and
arrows act on the input tensor factor, not on the coefficient factor.

Write S={pN:N>=1} for the reviewed stable progression, with root
multiplicity t and e_n=dn/t. Generic roots are nonconstant, have nonzero
differentials, avoid w(0), and are disjoint at independent generic points.
At an admissible maximal-root-count input they have scalar commuting
Taylor branches. Generic trace-rank bounds specialize there.

For a generic P, T_P is the span over its spectral field Omega_P of:

* all loop columns D(P;Y);
* every coefficient, in the formal coordinates of Q at zero, of the
  paired scalar tuple m(P,Q;U,V), for **every** partner size in S and
  all coordinate scalar-input arrows U,V.

The pair convention is P <-U- Q <-V- P. Its fixed-root Schur numerator
is the direct return minus the outgoing coupling times
(W(Q)-lambda_h)^(-1) times the incoming coupling. Let a_n=dim T_P and
rho_n=rank D_P. A constant direction v can be chosen with
d_h=D_h(P;v) nonzero for every root.

Reviewed response specialization has two essential consequences. First,
after clearing only the required resolvent determinants, a relation on
T_P survives admissible partner, Taylor and Laurent specialization.
Second, finitely many loops and paired **values** at independent small
generic partners attain T_P, although their partner sizes may differ.
The reason for the latter is a nonzero spanning minor: give each selected
coefficient column its own partner variables; multilinearity makes the
corresponding product coefficient of the determinant nonzero. Detection
of the cleared numerator at independent residues preserves this minor.

Whenever a coefficient in a Laurent parameter is taken below, membership
in a fixed finite-dimensional space means annihilation by its linear
annihilators. Such membership is preserved coefficientwise. No possibly
divergent geometric inverse is specialized.

## 2. The weighted partition is derived, not assumed

For two spanning response values a, b, use independent partner points.
Join two copies of P by a triangular chain through P'=P+xi v.
A direct first or second step represents a loop; an excursion through
an optional independent partner represents a paired response. Group
all internal positions as one partner C(xi). Its size is in S.

All selected inverses exist over E((xi)). The optional partners are
spectrally disjoint. Scalar branch separation at the middle block gives

    [xi (W(P+xi v)-lambda_h)^(-1)]_(xi=0) = pi_h/d_h.

Eliminate the optional blocks first. They leave the middle diagonal
unchanged. The two effective endpoint-to-middle couplings at xi=0,
compressed on the h-root space, are a_h pi_h and b_h pi_h. All terms
other than the middle inverse are regular. The minus sign in the Schur
formula therefore gives the Laurent residue

    (-a_h b_h/d_h)_h in T_P tensor E.

The partner may have repeated endpoint spectra at xi=0; it is the
invertible Laurent resolvent, not a false disjointness assertion at zero,
that licenses this calculation. The reviewed determinant-cleared response
specialization applies. Bilinearity, finite spanning sets, and faithful
scalar extension show that T_P is closed under
(a,b) -> (a_h b_h/d_h)_h.

Consequently U_P=diag(d_h)^(-1)T_P is a unital subalgebra of
Omega_P^(e_n) under coordinatewise multiplication. Define h~h' when
every element of U_P has equal h and h' coordinates. Choose an element
u of U_P distinguishing different classes: the finitely many forbidden
equalities are proper linear subspaces, and the field is infinite.
If its distinct class values are theta_1,...,theta_a, the polynomials

    product_(j != i) (u-theta_j)/(theta_i-theta_j)

are the class indicators. They belong to U_P, span all class-constant
functions, and prove

    T_P = {c : c_h/d_h is constant on each class}.

Thus a_n is the number of classes. Selecting one root from each class
is an isomorphism onto the entire selected coordinate space; its inverse
multiplies each selected coordinate by the corresponding d_h ratio.
No global relation or cyclic argument has been used.

## 3. Functional linkage, independent of adjoining blocks

Let h,h' be linked at P, and let R=diag(P,C_1,...,C_s), where
s=0 is permitted and the auxiliary blocks have arbitrary allowed sizes
and independent small generic entries. Write

    g_j(eta)=lambda_j(P+eta v)-lambda_j(P).

We prove for unrestricted commuting input perturbations Delta that

    Lambda_h^R(Delta)-lambda_h(P)
      = (g_h o g_h'^(-1))
          (Lambda_h'^R(Delta)-lambda_h'(P)).                 (1)

Here h' is the second root label, and the eta derivative of its series
g_(h') at zero is the nonzero scalar d_(h').
An inverse for composition exists by degreewise recursion: its degree-one
coefficient is d_h'^(-1), and at each subsequent degree the unknown
coefficient is multiplied by the same unit.

Transport first, then apply transfer. The Taylor map
P -> P+eta v on Frac K[[P]] reduces to the identity at eta=0.
It extends to Omega_P[[eta]]: a separable primitive element is lifted
recursively using its nonzero minimal-polynomial derivative. Nonzero
base-field and spectral-field elements have unit constant terms.
Apply this map to the linked response identity

    d_h' c_h - d_h c_h' = 0.                               (2)

It transports every loop and every coefficient for every partner size.
It therefore holds with the moved roots and moved d-factors. Required
auxiliary determinants are cleared before any triangular Laurent
specialization. This uses only the reviewed response and transfer results.

Put R(eta)=R+eta v_R, where v_R is supported at P. Write
H=u v_R+H_rest. On imposing

    Lambda_h'^(R(eta))(H)=lambda_h'(P+eta v),               (3)

the derivative in u at H=0 is the unit D_h'(P+eta v;v).
Solving for u coefficient by coefficient gives a unique series in
H_rest with coefficients in E[[eta]] and zero constant term in H_rest.
The quotient is E[[eta,H_rest]], a domain, and it injects into
E((eta))[[H_rest]].

On this quotient the fixed-root Schur expression S_h' is zero: its
scalar branch is fixed and its eigenspace is a rank-t graph over the
original target space. Induct on total H_rest degree to prove S_h=0
in the Laurent-field quotient. Suppose both Schur expressions vanish
below l. Simultaneous commuting-parameter word transfer says their
degree-l coefficients are scalar homogeneous tuples in the projected
active space. Transported (2) gives

    D_h'(P+eta v;v) [S_h]_l
      = D_h(P+eta v;v) [S_h']_l = 0.

The first factor is a unit, so the h coefficient is zero. This starts
in degree zero and proves every degree. This is a two-label transfer
argument, not an assumption that all other Schur expressions vanish.

Schur zero implies that the h branch is fixed. Indeed the complementary
block is invertible, and scalar branch separation writes the determinant
at the fixed root as a unit times the t-th power of its branch shift.
The quotient is a domain; that power can vanish only when the shift is
zero. Regularity and the quotient injection descend the equality back
from E((eta))[[H_rest]].

Finally use the invertible linear coordinates Delta=H+eta v_R.
Equation (3) eliminates eta as
g_h'^(-1)(Lambda_h'^R(Delta)-lambda_h'(P)). Substitution gives (1).
The same g-series was defined at P alone. Hence it is unchanged for
every choice, number, or size of auxiliary blocks. In particular this
argument is not circular through a common global dual space.

## 4. Replication over every allowed partner size

Let n=pN, take N independent size-p points P_i, and put
R_1=diag(P_1,...,P_N). The substitution x=R_1+Delta_1 embeds
K[[x]] into E[[Delta_1]]. All Taylor coefficients of a K-series at
the small R_1 are integral; reduction modulo the positive valuation
ideal recovers the original series in Delta_1, so the map is injective.
It extends to fraction fields. The maximal count e_n=N e_p and scalar
branches label all generic roots and embed their splitting field into
Frac E[[Delta_1]]. Branches and projectors are regular at Delta_1=0.

For linked h,h' in block i, choose a supported constant direction v_i
with every original d-factor nonzero. Functional linkage at R_1,
differentiated once, gives proportional loop responses at x. Adjoin
an independent generic Q of **any fixed** size q in S. Functional
linkage on diag(R_1,Q) uses exactly the same univariate function.
At diag(x,Q), put uU and zV in the opposite arrow blocks. Either
arrow alone is triangular, so both separate first branch derivatives
are zero. The mixed chain rule has no second-derivative cross term.
Together with the v_i derivative it gives

    D_h'(x;v_i) m_h(x,Q;U,V)
      - D_h(x;v_i) m_h'(x,Q;U,V) = 0.                     (4)

Both d-factors reduce to nonzero values at Delta_1=0.

Here is the coefficientwise step that a finite partner test cannot
replace. Cross multiplication has removed the ratio. Clear the finitely
many determinants W(Q)-lambda_h(x) and W(Q)-lambda_h'(x).
At each fixed Delta_1 degree, the resulting Q-series has coefficients
uniformly bounded below in the small parameter valuation. Its root and
projector scalars do not involve Q; entry expansions have two prescribed
arrow insertions and finitely many prescribed Taylor insertions.
The reviewed path-count estimate supplies the bound. Evaluate Q at
independent small residues constructed after the base spectral field.
Detection of the cleared numerator shows that (4) holds coefficientwise
in Q. Injectivity of the base spectral embedding descends it to Omega_x.
At Q=0 its clearing determinants are nonzero because generic roots
avoid w(0), so they can be canceled in Omega_x[[Q]].

The argument works separately for every q in S, with the same labeling
of x and the same d-factors. Every generator of T_x therefore satisfies
the old within-block normalized relations. There are N a_p old classes,
so a_n <= N a_p.

For the reverse inequality choose finite attaining response lists at
the P_i, with all partners independent. At R_1 support each loop,
outgoing arrow, and incoming arrow only at its chosen block. The
response tuple is its original tuple there and zero elsewhere, and
these tuples have rank N a_p. The same finite tuples at
R_1+Delta_1 are in the generic extended active space. Their branches,
projectors and partner inverses are regular at zero because the partner
spectra are disjoint. A generic rank bound smaller than N a_p would
make every such minor zero and hence zero at this reduction, contrary
to the witness. Thus

    a_(pN)=N a_p  for every positive N.                    (5)

Equality also identifies the extended generic active space with the entire
space defined by the old within-block constraints. Its partition classes
are therefore exactly the old classes. Representatives can be labeled
regularly at the direct-sum specialization; choosing a different representative
within a class only rescales that coordinate by a nonzero, regular ratio.
This justifies the selected-root minors at decomposed bases used below.

No limit on partner size, Taylor order, or word degree entered the proof.

## 5. Equal-size attainability in either orientation

Take a finite attaining list at size p, with partner sizes q_j in S.
Choose r=pN at least every q_j. Specialize a size-r base to N
independent size-p blocks, giving each block a fresh witness list.
Pad each partner q_j to size r by independent diagonal data of size
r-q_j; this is an allowed size when positive, and zero padding is
omitted. Give its arrows zero entries on the padding and on all other
base blocks. Responses are precisely the original supported witnesses.

Their rank is N a_p=a_r by (5). The specialization has maximal root
count and disjoint base/partner spectra, so the regular nonzero minor
persists at generic size-r base and partner data.

Assign a separate partner to each paired column. Fix its outgoing arrow
to the witness value and test the variable reverse arrow on the witness
value. The attaining minor is nonzero. Bilinearity makes it a nonzero
condition on the fixed arrows, so generic fixed outgoing arrows attain
the same rank with suitable reverse columns. Fixing the other
orientation has the identical argument. Use one r and the larger of
the two finite partner counts K_0; their nonzero generic conditions
hold simultaneously. If loops already span, include an unused partner
so that K_0>=1. Hence loops and K_0 independent size-r partners
attain the whole active space in either fixed-arrow orientation.

## 6. A bounded defect has an arbitrarily late tail minimum

At a leaf/hub star, all constant arrows go from a later hub to an
earlier leaf in matrix order. Closed paths contributing to a loop
derivative remain at that block. A reverse-arrow derivative must use
its matching forward arrow once; no other return is possible. Thus
loop columns are supported original loops, and reverse columns are
the two original paired tuples, with zero other entries. Trace-to-root
conversion is the invertible matrix (j t lambda_h^(j-1)).

Set g_N=N a_r-rho_(rN). By (5), g_N is a nonnegative integer.
For N>=K_0 take K_0 hubs and N-K_0 leaves. At each leaf the loops
and reverse columns attain its active space by Section 5. Different
leaves have independent reverse variables. Specialized rank is at
least (N-K_0)a_r and is bounded above by generic rank. Hence

    0 <= g_N <= K_0 a_r  for N >= K_0.

The smaller finitely many N also have a finite bound. Among the
finitely many possible values, let g be the least occurring infinitely
often. Values below g occur only finitely often. After their last
occurrence all g_N>=g; occurrences of g remain arbitrarily late.
Choose such an N_0>=K_0, as late as desired, and set

    b=rN_0,  a=N_0 a_r=a_b,  g=g_(N_0).

Then rho_b=a-g and g_(N_0 M)>=g for every M>=1, so
rho_(bM)=Ma-g_(N_0 M)<=Ma-g. This uses a tail minimum, **not**
eventual constancy of the sequence g_N.

Choose one root from each active class at size b. Its coordinate
space E_P has dimension a and the loop image L_P has rank a-g.
Thus H_P=E_P/L_P has dimension g.

## 7. Endpoint surjectivity before compatibility

Let P,Q be independent generic size-b points and fix a generic
outgoing arrow U. Specialize both to N_0 independent size-r little
blocks. At any little block of P, the N_0>=K_0 little blocks of Q,
with their independent fixed-arrow components, provide enough partners
to attain that block's active coordinates after adding loops.
Reverse entries touching distinct little blocks of P are independent;
the root compression at one block sees only its own reverse entries.
Loops and paired columns therefore attain all N_0 a_r=a coordinates
at the P-end.

Their nonzero minor persists at generic P,Q,U; all labeled root
data and partner inverses are regular at the disjoint diagonal
specialization. Since the generic loop image has rank a-g, the paired
map projects onto H_P. Interchanging endpoints proves onto H_Q.
Fixing the other arrow instead gives both assertions in that orientation.
The finitely many generic nonzero-minor conditions can hold simultaneously.

Nothing in this endpoint argument assumes a common dual relation.

## 8. One tangent graph, and polynomial descent to all arrays

Fix M independent size-b points, select their roots, and put R=Ma-g.
For M=1 loops give the assertion. For M>=2 take one block as hub.
At the one-hub star, loops have rank M(a-g). Modulo loops, reverse
columns project independently and surjectively onto the M-1 leaf
quotients by Section 7. Thus the selected Jacobian rank is at least

    M(a-g)+(M-1)g=R.

The trace-rank specialization bound rho_(bM)<=R gives the opposite
inequality. Therefore some R-minor is nonzero at a star and, in
particular, at a generic complete strictly upper-arrow array U.

Work over E(U), with E containing the fixed diagonal splitting data.
Let F(H) be the formal Taylor map of the Ma selected root shifts
under **unrestricted** input perturbations. F(0)=0. Scalar branches
exist at this maximal-count upper-triangular base. All (R+1)-minors
of dF vanish as series by the generic trace-minor identities and
reviewed admissible specialization. An R-minor at zero is a unit.

Choose its R input and output coordinates. The map consisting of
these R output shifts and the remaining original input coordinates
has invertible linear term. Its formal inverse is obtained recursively:
at degree one invert that linear term; at each higher homogeneous
degree subtract the already determined contribution and apply the same
inverse matrix. In its new source coordinates (y,z), after reordering
outputs,

    F(y,z)=(y,G(y,z)).

Each entry of G_z is, up to sign, an (R+1)-minor formed with the
R identity rows and columns. It is zero. For any coefficient of G
with positive exponent in a z-coordinate, the corresponding derivative
coefficient is that positive integer times the coefficient. Characteristic
zero implies the coefficient is zero. Therefore G(y,z)=G(y).

At every formal source point on F=0, necessarily y=0, and the chain
rule puts all derivative columns in the **fixed** graph

    Gamma={(v,dG(0)v):v in E(U)^R}.                       (6)

Its dimension is R. Shifting only upper arrows leaves every root
equal to its original diagonal root. Therefore J(U+S), the selected
Jacobian at any formal upper-arrow shift, has every column in (6).
Uniqueness of the labeled scalar branches, or the fixed trace-to-root
formula, identifies this nested Taylor Jacobian with that polynomial
Jacobian; no relabeling is involved.

It remains to descend from formal shifts over E(U) to arbitrary arrays
over the diagonal field E. This is the essential missing step in the
separate-rank argument.

**Polynomiality with a uniform degree bound.** In a trace derivative
there is exactly one marked, differentiated input step. Every other
off-diagonal block step is strictly increasing. Starting immediately
after the marked step, a closed path has at most M-1 increasing block
steps. Thus each trace derivative is a polynomial of total upper-arrow
degree at most M-1. The intervening diagonal sums converge by smallness.
This is also valid for tr(W^j): distribute the single marked derivative
among the finitely many factors. The invertible full trace-to-root
matrix uses only the fixed diagonal roots. Hence every entry of J(V)
is a polynomial over E in the upper-arrow coordinates V, of degree
at most M-1.

Let c be any covector over E(U) annihilating Gamma. Then
c J(U+S)=0 as a formal series in S. The expression is polynomial
in S, so it is a polynomial identity. Substitute S=V-U in that
identity, obtaining c J(V)=0 in E(U)[V]. Consequently c annihilates
every coefficient vector of J(V).

Let K_E be the E-span of those coefficient columns. Its scalar extension
lies in Gamma; faithful scalar extension preserves the rank of its
finite coefficient matrix, so dim_E K_E<=R. Every specialized
upper-arrow derivative lies in K_E. Loops occur at the diagonal.
Every joint two-block paired column occurs at a single-arrow star,
with one arrow fixed and the other differentiated. Both arrows may
range arbitrarily, so all joint paired columns lie in K_E. The
one-hub star supplies R independent loop and paired columns. Therefore

    K_E = span(all loops and all joint pairs)
        = span(all upper-arrow derivative columns),
    dim K_E = R.                                         (7)

The proof handles all finite M and all admissible arrow values. It
does not specialize an infinite Taylor series at S=V-U: only the
proved polynomial identity is specialized. Generic pointwise rank,
formal constant rank, polynomiality, and faithful descent are distinct
steps, all needed.

## 9. Compatible duals and exact negative graphs

Define G_I=K_E^perp for a finite nonempty collection I. Equation (7)
gives dim G_I=g. Loop annihilation identifies it with a subspace
of direct_sum_i H_i^*.

If a compatible covector has zero component at vertex i, pairing it
with columns on (i,j) and using onto-ness at j forces its component
at every j to be zero. Projection G_I -> H_i^* is injective.
Both sides have dimension g, so it is an isomorphism, denoted tau_i.

For a fixed generic arrow on (i,j), the reverse image B_ij in
H_i direct_sum H_j has dimension at least g because each endpoint
projection is onto. It is killed by the restriction
{(tau_i(c),tau_j(c)):c in G_I}, a g-dimensional space. The annihilator
of this restriction has dimension 2g-g=g. Hence B_ij is exactly that
annihilator and has dimension g. In particular its endpoint
projections are isomorphisms, not just onto.

Under finite-dimensional double-dual identifications, put
beta_i=tau_i^*:H_i -> G_I^*. These are isomorphisms. The exact
response graph, including its sign, is

    B_ij={(x, -beta_j^(-1) beta_i(x)):x in H_i}.             (8)

Its annihilator is exactly the compatible positive covector graph
{(tau_i(c),tau_j(c)):c in G_I}. The proof is unchanged with either
arrow fixed: Section 7 supplies endpoint surjectivity and (7) contains
every bilinear pair value. No fixed-arrow rank is silently substituted
for the span over all arrows.

On adjoining blocks, restriction of a larger compatible space kills
every retained loop and pair column. It is injective, since retaining
one vertex already gives an injective projection, and the two
compatible spaces have dimension g. It is therefore an isomorphism
onto the original space after scalar extension. This proves universal
compatibility, not just consistency for a chosen triple.

For a singleton, K_E=L_P and G_I=H_P^*. For g=0 all quotient and
dual spaces are zero, both graph equalities are equalities of zero
spaces, and restriction and endpoint statements still hold.

## 10. Certificate interpretation

`verify.py` is a deterministic exact replay, not an infinite search.
Its polynomial division-algebra model has genuine linked branches and
nonzero defect. Take k=Q(all roots of unity)(s,t) with independent symbol
parameters, A=(s,t)_2, a^2=s, b^2=t, ba=-ab, and

    C=z1*z2-z2*z1,   w=C+a C^2.

The symbol is division by the reviewed symbol-division construction,
and w(0)=0 while w is nonzero. In a splitting write a=diag(alpha,-alpha),
alpha^2=s. If C(P) has simple roots mu_i, the output roots are
f_+(mu_i),f_-(mu_i), where f_+(u)=u+alpha u^2 and
f_-(u)=u-alpha u^2. The normalized linked weights are
f_+'(mu_i)=1+2 alpha mu_i and f_-'(mu_i)=1-2 alpha mu_i.
Both are nonzero at the generic point.

The exact points use P1=epsilon X, P2=epsilon Y with X a cyclic shift
and Y a weighted reverse shift, so C(P)=epsilon^2 diag(lambda_i).
The lambda_i are explicit, distinct, nonzero rationals summing to zero.
The symbol parameter alpha and small parameter epsilon remain indeterminates:
neither the division algebra nor smallness is asserted after setting these
parameters to numerical values. The 2n roots f_+/- are distinct over
that field. Size 2 already has multiplicity one, so its positive multiples
are an allowed stable progression.

For any disjoint partner roots, the paired commutator response is

    m_i = A_ii - sum_j E_ij F_ji/(nu_j-mu_i).

Here A is the direct return, E the outgoing commutator block, and F
the incoming block. The polynomial output response is
f_+'(mu_i)m_i or f_-'(mu_i)m_i. Indeed its direct term is
f_+'(mu_i)A_ii+alpha(EF)_ii, its couplings are
E(1+alpha(C_Q+mu_i)) and (1+alpha(C_Q+mu_i))F, and its
resolvent factors as
(C_Q-mu_i)(1+alpha(C_Q+mu_i)); cancellation gives the formula.
The minus branch is identical with alpha replaced by -alpha.
This is a polynomial identity in an arbitrary partner matrix, not a
special assumption of the sampled sizes.

The unscaled commutator loop Jacobian has rank n-1 at the explicit
points. At size 2 the paired values attain the missing trace direction.
Thus a_2=2, and (5) gives a_n=n on the allowed progression. Alternatively
the displayed endpoint ranks attest full active dimension at the sampled
larger sizes. Generic commutator loop rank is n-1: a pair generating the
full matrix algebra has only scalar common centralizers; the trace-dual
kernel of its commutator differential consists of those centralizers.
Our explicit pair generates the full algebra because C is diagonal
with distinct entries and the cyclic shift connects all its coordinate
idempotents. Generic rank cannot exceed n-1 because trace(C)=0.
The linked partition therefore has n two-root parts and defect g=1.

For selected plus roots, the actual output Jacobian is the commutator
root Jacobian multiplied by the invertible diagonal weights
1+2 alpha epsilon^2 lambda_i. Factoring out that fixed diagonal and
the common epsilon factor preserves all ranks and coefficient-span
dimensions. Scaling upper input arrows by epsilon is an invertible
coordinate change over the valued field, not a bound on permitted arrows.
The recorded three-block Jacobian has 72 unrestricted input-direction
columns; its coefficient span has rank 5 while its diagonal pointwise
rank is 3. The inspected Jacobian adapter receives six explicitly
identified columns of this same polynomial matrix and returns exact
rank 5, rather than being asked about a synthetic unrelated map.

Finite checks cover base sizes 2,4,6, partner sizes 2,4,6,8, and both
fixed-arrow orientations. They audit every reverse coordinate column
for those pairs. They also check nonlinear compositional inversion,
weighted interpolation, singleton and zero-quotient cases, and the
Schur sign. The additional original model w=z1 has g=0 because its
diagonal loop root-response matrix is the identity. Negative controls
are explicitly counterexamples to weakened hypotheses only; they
are not admissible refutations of GLOBAL9000201.

`Main.lean` and `statement_fidelity.md` formalize identified algebraic
cores of the proof, not the original spectral foundation or the whole
free-series theorem. A real Lean 4.31.0 compiler run and axiom audit both
exited zero with no proof holes. Its claim-bound archived certificate is
`lean/certificates/GL-FORMAL9000201-472f721cbfdbddad.json`. The exact
replay checks both compiler source hashes against the delivered source
and fidelity document; it does not manufacture a compiler verdict.
The exact certificate states computational and formal scopes separately.
The universal quantifiers over partner sizes,
collection sizes and formal orders are discharged by the proof above
and still need independent human mathematical review.

From the campaign directory the exact replay is

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/global_relations/verify.py
```

The native fresh formal check, when required for a new review, is

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/global_relations/Main.lean --statement-fidelity research/global_relations/statement_fidelity.md --claim GL-FORMAL9000201 --project-root . --artifact-dir research/global_relations/lean
```

Lifting, all-order correction, realization, generation, the actual-center
argument, and publication-level originality remain unresolved by this
milestone. Neither a supporting Engineer judgment nor a small exact
experiment is represented as independent Reviewer acceptance.
