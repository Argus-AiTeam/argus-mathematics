# Ordinary transfer cutoff and connected corestriction at height one

This continues the independently reviewed reductions in `proof.md`.
Those reductions and their compiler source have not been changed.
The new step is the actual lattice-to-localized stable-image map, followed
through connected corestriction. It is not a second finite-rank model.

## 1. The finite stable-cutoff theorem

Let M and X be finite-dimensional vector spaces over a field. Let S and T
be endomorphisms, and let f:M -> X satisfy fS=Tf. Suppose:

1. Every element of ker(f) is killed by some power of S.
2. There is an a such that im(T^a) is contained in im(f).

Write M_inv for the intersection of im(S^r), and X_inv similarly.
Then the **restriction of f** is an isomorphism M_inv -> X_inv.

Here is a proof without a choice of new generators. The Fitting
decompositions are

    M = M_nil + M_inv,       X = X_nil + X_inv,

with direct sums, nilpotent transfer on the first summands and invertible
transfer on the second. Intertwining preserves both summands. The
restriction to M_inv is injective: an element in its kernel is locally
S-nilpotent by hypothesis, whereas S is invertible there. For x in X_inv,
write x=T^a y with y in X_inv. Lift T^a y through f, and decompose a lift
as m_nil+m_inv. Its nilpotent contribution has zero X_inv component,
so f(m_inv)=x. This proves surjectivity.

All maps are the original maps. Any commuting square of intertwining
maps restricts to the same square on stable images. This includes maps
between different cohomological degrees. No dimension agreement is
being used to choose an isomorphism after the fact.

### The multiplicative-height strengthening

Suppose in addition that T has a linear right inverse Phi:

    T Phi = identity_X.

Since X is finite-dimensional, T is bijective. Thus X_inv=X, and the
same actual restriction gives

    M_inv --f--> X.

The new Lean source `ordinary/Main.lean` proves this statement over an
arbitrary field. It includes the locally nilpotent kernel and uniform
absorption hypotheses, and proves naturality on stable images.
It does not prove finite-dimensionality of coefficient cohomology.

## 2. Application to the literal coefficient cochains

Fix one sufficiently deep finite joint frame level U. Put

    C = C_cts(P_3,P),       D = C_cts(P_3,B_U),
    P = x^(-b)L,           f = the coefficient inclusion.

These are the manuscript's bounded-pole complexes, not analytic
completions. A finite projective resolution can compute them. In this
model the compact coefficient complex has compact terms and closed
images. This assertion is not made about the unrestricted bar cochain
space, whose continuous-function terms need not be compact.

For the application in a fixed degree, the two finite-dimensionality
inputs are precisely compact finiteness for H^i(C) and pole removal for
H^i(D), namely `prop:compact-finiteness` and `prop:pole-removal`.
They are hypotheses of this comparison argument, not consequences of
the new finite linear-algebra theorem.

The absorption hypothesis has an explicit common-bound justification.
The transfer estimate in `lem:compact:stable-lattices` is

    S(x^(-c)L) subset x^(-ceil(c/Q)-c0)L.

If c_(r+1)=ceil(c_r/Q)+c0, then

    c_r <= Q(c0+1)/(Q-1)
           + (c_0 - Q(c0+1)/(Q-1))/Q^r.

Choose the fixed lattice exponent b strictly larger than the fixed
point on the right. Every one fixed pole lattice enters P after
finitely many transfers. This exponent may depend on the pole bound,
which is exactly what is allowed. It does not depend on a point of the
compact cochain source.

For a class in ker(H^i(C)->H^i(D)), choose its primitive in D. The
primitive has one finite pole bound at this same frame level. Transfer
it into P. Its differential is the corresponding iterate of the
original cocycle, so that iterate is a boundary in C. This proves
local nilpotence of the kernel.

Next choose representatives of a finite basis of H^i(D). Their finitely
many pole bounds have a maximum. One transfer exponent sends all these
cocycles into P, establishing uniform image absorption. This is the
only use of the target's finite-dimensionality in this step.

At t=1 the root/lift torsor is diagonalizable. Its normalized Hopf
integration is projection onto the constant character, and it fixes 1.
After the stationary powering identification its actual maps satisfy

    S Phi_Q = identity,       Phi_Q(f)=f^Q.

This is the coefficient identity stated in the height-one part of
`lem:cartier-transfer` and used in 08-compact. It can also be checked
after a finite faithfully flat trivialization of the torsor: inclusion
is the character-zero inclusion, and projection retracts it. The
identity descends because the two maps are defined before that
trivialization. Q is chosen to fix k.
For the admissible example k=F_(5^6), Q=5^6 is allowed. After
almost scalar extension these are S tensor identity_R and
Phi_Q tensor identity_R; absolute Frobenius on R is not being
silently substituted for either map.

Both maps preserve the stipulated cochain convention. Phi_Q multiplies
a finite pole bound by Q and is continuous on the parameter-adic
lattice. It need not preserve P; it is only required on D. S divides
the bound up to the fixed loss above. Each operation stays at one
finite stationary frame problem. No cochain using infinitely many
root stages has been inserted.

Consequently S is surjective, hence invertible, on each finite H^i(D).
Section 1 therefore proves the actual map

    intersection_r S^r H^i(P_3,P) -> H^i(P_3,B_U)

is an isomorphism. In particular, in this height-one application the
target stable image is the **whole ordinary coefficient group**.

### Cochain actions, rather than replacement generators

Let c be any ordinary constant k-valued stabilizer cochain. In the bar
model the cup formula is a finite sum of scalar multiplications and
group actions on the coefficient value. S and Phi_Q are k-linear and
P_3-equivariant, so

    S(c cup z)=c cup S(z),       Phi_Q(c cup z)=c cup Phi_Q(z).

All terms have one common stage and pole bound. In particular this
holds for the fixed F_5-valued representatives underlying the xi_i.
Transporting the formula to a bounded resolution gives the same
degree-shifted maps in the derived category. It does not require
choosing a new exterior basis or a strict cup algebra on that bounded
resolution.

Take continuous duals on C and algebraic duals on D. The natural zigzag

    D^* -> C^* <- C^vee

commutes with transpose transfer and with the graded transpose of
these actual cup maps. Continuous duality on the compact bounded
complex and algebraic vector-space duality are exact. After the
transpose-transfer colimit, the first arrow is a quasi-isomorphism
by the stable-cutoff theorem; the second is one because H^i(C) is
finite. Moreover the stage-zero map

    D^* -> colimit_(S^*) D^*

is now a quasi-isomorphism: S acts invertibly on the finite H^i(D).
Thus an available compact-lattice transpose comparison gives a
comparison for **D itself**, retaining its actual constant-cochain
action. The auxiliary direct limit proves this statement about D;
it has not replaced D by a perfected coefficient.

This settles the linear-algebra and bounded-pole argument of
`full:stable-cutoff`, including its height-one ordinary strengthening.
It supplies no proof of either of the two finiteness inputs or of the
geometric compact-lattice comparison.

## 3. Finite frame descent and the direction of the maps

One must not identify transpose frame pullback with restriction.
Let U' be normal open in U, let H=U/U', and consider the finite
frame torsor B' over B. At one finite stage write

    i:B -> B',       tr:B' -> B.

After faithfully flat trivialization B' is a regular B[H]-module.
Its projectivity descends, so it is projective as a k[H]-module.
The norm identifies coinvariants and invariants on this module;
there is no division by |H|. In particular, before and after the
bounded finite projective P_3-resolution,

    sum_(h in H) h = i tr.

Dualizing gives the exact formula

    sum_(h in H) h = tr^* i^*.

Here tr^* is the lower-level inclusion into the dual deck invariants.
Thus i^*, the transpose of the actual coefficient pullback, is the
corestriction map. Conversely tr^* corresponds to restriction.
This is a norm computation at the finite torsor nerve, not an
inference from matching ranks or just from res cor=|H|.

Projectivity of the cochain terms also makes their duals acyclic for
deck invariants. Therefore this finite descent works even when |H|
is divisible by five. It passes from the sufficiently deep matrix
levels used for the free lattice to V=G by the same finite torsor
calculation. Every finite trace and every cup map in this argument
uses finitely many matrices and denominators. A compact parameter
therefore retains one common finite level and pole bound.

To apply this calculation to compact supports, the finite-lattice
comparison must be the natural common-torsor/residue comparison, not
an arbitrary isomorphism of its cohomology groups. This is the extra
content of `prop:transpose-comparison` that remains a separate input.
When it is supplied, the calculation above determines the frame
transition as actual corestriction on its supported complex.

## 4. Connected corestriction, including derived coefficient maps

At height one, P_1=Z_5^times. Take the cofinal normal subgroups

    K_r = <gamma_r>,       gamma_r=6^(5^r),       r>=0.

They are isomorphic to Z_5, and gamma_(r+1)=gamma_r^5. For a finite
smooth coefficient M the continuous resolution is the two-term
complex

    [ M --(gamma_r-1)--> M ],       group degrees 0,1.

From K_(r+1) to K_r the actual corestriction chain map is

    (N_r, identity),       N_r=1+gamma_r+...+gamma_r^4.

Indeed

    (gamma_r-1) N_r = gamma_r^5-1,

and the degree-zero norm is the sum over the actual five cosets.
Restriction is (identity,N_r). Both formulas are natural for
coefficient maps commuting with the action. The index-five
polynomial identity and its characteristic-five specialization
are included in the new Lean source.

For sufficiently deep r, K_r acts trivially on M. The corestriction
on H^0 is then multiplication by five, hence zero, and on H^1 it
is the identity. Thus the inverse limit is zero in group degree
zero and M in group degree one. There is no higher group degree.

Now let E be a bounded smooth P_1-complex with finite-dimensional
cohomology, without assuming its derived P_1-action is split.
The two-column hypercohomology spectral sequence gives canonical
short exact sequences

    0 -> H^1(K_r,H^(ell-1)(E))
      -> H^ell(RGamma(K_r,E))
      -> H^0(K_r,H^ell(E)) -> 0.

The systems are finite, so Mittag--Leffler applies. After shrinking
K_r to trivialize the finitely many cohomology representations,
corestriction on the left is identity and on the right is zero.
An inverse-limit element must therefore lie in the canonical left
subobject at every stage, where its compatibility means it is a
single element of H^(ell-1)(E). This proves the natural isomorphism

    limit_(K,cor) H^ell(RGamma(K,E)) = H^(ell-1)(E).

This argument also proves naturality for E -> E'[s]. Such a derived
map induces the actual map on the canonical left edge. Possible
off-diagonal extension terms do not require an equivariant splitting:
the right coordinates of an inverse-limit element are already zero.
This is the necessary justification for retaining degree-shifted
constant-class actions.

## 5. What follows, and exactly what is still an input

Let Y=RGamma_c(Z,mathscr A) tensor <eta>. If the finite-lattice
transpose comparison and finite-dimensionality inputs of Sections
2 and 3 are supplied, those sections give, at finite frame level,

    Hom_k(H^i(P_3,B_(K,G)),k) tensor R
       = H^(11-i)(K x G,Y).

The central contraction already reviewed removes every proper
support term after G-cohomology. The ambient complex is a line in
degree six with trivial G-character, after exactly one volume line.
Its remaining connected character is a smooth finite character:
the natural constant-F_5 ambient support comparison has a single
one-dimensional F_5-cohomology group. A deep pro-five K_r kills it.
No assertion that the whole derived connected action splits is used.

There is a scalar-extension issue to check here. Tensoring with R
does not in general commute with an infinite inverse limit. In the
present situation the ambient two-column calculation bounds the
sum of the k-dimensions of H^*(P_3,B_(K,G)) by eight, uniformly in
all sufficiently deep K: the G-cohomology dimension is four and
K has two trivial-coefficient degrees. The bound descends by the
faithful almost-length argument, at finite K before taking a limit.

A system of finite-dimensional k-spaces with a uniform dimension
bound has an inverse limit computed by an eventually constant
system of stable images. For each fixed stage, its later images
stabilize. These stable-image spaces have surjective transition
maps; their dimensions are bounded and nondecreasing along a
cofinal sequence, so are eventually constant and the transitions
then are isomorphisms. The discarded system is Mittag--Leffler
zero. Exact scalar extension preserves the finite-stage images and
their stabilization. It therefore commutes with this particular
inverse limit. This proves the needed commutation; it is not being
assumed for arbitrary products.

The uniform bound is essential to this justification. For the
Mittag--Leffler system k^r with coordinate projections, the inverse
limit is a product. With R=k[t], the element (1,t,t^2,...) of the
product of copies of R is not in (product k) tensor_k R: a finite
tensor expression has a uniform degree bound in t. Thus
Mittag--Leffler alone would not justify the interchange above.

The primal connected coefficient complex is, by its literal
definition, the algebraic filtered colimit of the finite-frame
bounded-pole complexes. Filtered colimits are exact, and

    Hom_k(colimit_K H^i(P_3,B_(K,G)),k)
      = limit_K Hom_k(H^i(P_3,B_(K,G)),k).

This is algebraic vector-space duality. It introduces no completion
of the primal coefficient and no cochains with an unbounded frame
stage. Apply Section 4, using the corestriction direction proved in
Section 3. The surviving group degree is one, so

    Hom_k(H^i(P_3,B_conn,G),k) tensor R
      = H^(4-i)(G,k) tensor R,

up to the fixed one-dimensional orientation bases. The shift is
11-6-1=4. All retained constant-class maps are the actual graded
transpose maps. Nothing in this argument changes the xi_i.
Identifying their remaining action with block restriction is still
the separate assertion C318CO2ACTION.

This is a complete proof of the **bridge from the stated
finite-lattice inputs to the ordinary connected comparison**.
It avoids the infinite translation representation complex, its
deep-translation triviality, and the top-edge construction at t=1.
It does not independently establish its finite-lattice inputs.
In particular:

- finite ordinary coefficient cohomology still needs the actual
  pole-removal argument, not just compact finiteness;
- the compact-lattice support comparison must retain its actual
  torsor, trace, residue, and cup maps, not just its dimensions.

These are explicitly exposed as C318ORD_FIN and C318ORD_SUPPORT.
Until they are independently certified, the live ordinary target
is not recorded as proved. The point now settled is the previously
unproved stable-cutoff/corestriction bridge, not the whole manuscript.

## 6. A decisive negative control for the finite-dimensionality input

Let X be the direct sum of k e_j for j>=0. Define

    T e_0=0,       T e_(j+1)=e_j,       Phi e_j=e_(j+1).

Then T Phi=identity and T is surjective, but T has a nonzero kernel.
Every vector is locally T-nilpotent and the stable image of T is
all of X. Thus split transfer alone cannot remove ordinary
cohomology, nor can pointwise absorption replace a uniform
finite-dimensional argument. This is an exact infinite-dimensional
counterexample to that weakened inference, **not** to the manuscript:
the manuscript explicitly invokes pole-removal finiteness.

The exact verifier also checks nontrivial smooth coefficient
complexes before and after the actual norm/identity corestriction.
It includes a complex whose action is nontrivial on its terms but
trivial on its cohomology. These tests are checks of the displayed
formulas and of failure controls. The all-dimensional cutoff proof,
the common-bound argument, and the connected inverse-limit proof
are Sections 1--5, not a conclusion drawn from the tests.
