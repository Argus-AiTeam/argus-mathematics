# Scalar and canonical jet rigidity, with an exact width tail

## Result and scope

This is a proof of the shared jet implication, conditional on its
explicit geometric inputs, together with an all-parameter formal
verification of its rank/arithmetic core. It is not a counterexample,
not an existence construction of a prepared cycle, and not a proof of
threefold abundance. No false manuscript assertion is claimed.

**Geometric theorem.** Let V be a smooth projective integral threefold
over an algebraically closed field of characteristic p>2. Let
D=sum m_alpha D_alpha be a nonzero effective Cartier divisor with
connected support, positive primitive multiplicities, and
O(D)|_(D_alpha) numerically trivial for every component. Suppose:

1. D^2 A=0 for every divisor A and K_V^2 D=0;
2. O_D(D) has finite order r;
3. H^0(V,O(iD)/O)=0 for every positive integer i;
4. gamma=D*c2(V)/12 is nonnegative;
5. on a neighborhood of D, omega_V^P is isomorphic to O(B_*),
   where P=p^b and B_*=sum b_alpha D_alpha is integral.

Then P divides every b_alpha; for B_0=B_*/P,
the completed omega_V is isomorphic to the completed O(B_0);
gamma=0; and the last widths d_e of O(r p^e D) satisfy
d_e/(r p^e) -> p/(p+1).

In fact, for the canonical irregular widths d'_e defined below,
there are E, an integer epsilon in [0,C_0], and an integer K such that,
putting c=q+epsilon and M_E=r p^E, for all n>=0,

    d'_(E+n) - d_(E+n) = epsilon,
    d_(E+n+1) + d_(E+n) + c = M_E p^(n+1),
    2(p+1)d_(E+n) - 2p M_E p^n + (p+1)c = (-1)^n K.

Thus the canonical offset stabilizes and the widths have an exact
affine-alternating tail. The manuscript proves only the limiting ratio
at this point; the displayed tail is a stronger consequence of its
two swapped congruences. Necessarily c>=0 and |K|<=(p-1)c.

The original p>3 hypotheses imply the characteristic hypothesis here.
Uncountability, simple normal crossings, and maximal nef dimension are
not used anew: they belong to the upstream production of these inputs.
Standard duality and Riemann--Roch, in arbitrary characteristic, are
the external results stated in `sources.md`.

## 1. Scalar rigidity, including nilpotents

Let xi be a nonzero section of O(iD)/O(uD), u<i. On affine charts take
rational lifts f_lambda. Valuations along the D_alpha detect membership
in each divisor lattice, since V is normal. Among the pole ratios
-ord_(D_alpha)(f_lambda)/m_alpha exceeding u, let t be the maximum.
Such ratios do not depend on changing a lift by a section of O(uD).
All lifts have pole ratios at most t, with equality somewhere.

Choose a positive integer N with Nt integral. The f_lambda^N are
sections of O(NtD). A difference of their powers has pole ratio at most
(N-1)t+u. After normalizing in O(NtD), its order along every component
is at least (t-u)m_alpha>0. Consequently these powers agree on D_red.
Their section of O(NtD)|_(D_red) is nonzero on at least one component.

On an integral projective surface a nonzero section of a numerically
trivial invertible sheaf is nowhere zero: a nonempty Cartier zero
divisor has strictly positive degree against an ample divisor.
At an intersection its value is therefore nonzero on the next
component. Connectedness propagates this to the whole reduction.
Hence every original lift has order exactly -t m_alpha along every
component, and it is a unit after that normalization everywhere on D.
All t m_alpha are integral. Primitivity and an integer Bezout
combination of the m_alpha show that t itself is integral.

The original sections, not their Nth powers, now glue to a unit section
of O(tD) on (t-u)D. This uses the full Cartier thickening, not just its
reduction: their differences are in the original lower lattice O(uD).

It follows that the image of
H^0(O(iD)/O((i-s)D)) in H^0(O(iD)/O((i-1)D))
is nonzero exactly when O(iD)|_(sD) is trivial. Its dimension is one.
Indeed two normalized units are proportional on the connected reduced
projective scheme D_red; after canceling their constant ratio, a
nonzero leading image would again have to be a unit on D_red, a
contradiction. This argument also excludes nilpotent leading images.

For M_e=r p^e let d_e be the last trivialization width. It exists:
width one is available, whereas triviality on M_e D would produce
a nonzero scalar polar part. Thus 1<=d_e<M_e. Frobenius gives
d_(e+1)>=p d_e. In particular d_e tends to infinity. The case r=1
already contradicts 1<=d_0<1.

If a line bundle on sD is trivial on D, its class has p-power order.
Choose local trivializations lifting the one on D; its transitions
are in 1+J for a nilpotent ideal J. A sufficiently large pth power
kills these transitions. Multiplication by an integer coprime to p
is consequently injective on the kernel of Pic(sD)->Pic(D).
Therefore at every nonzero index i=j M_e with p not dividing j,
the last scalar width is exactly d_e. This includes negative j.
Indices not divisible by r have no leading entry at width one;
the entry at zero persists at every width. This is a classification
on all thickenings, not a reduced-normal-bundle substitute.

## 2. Finite pages and the signs of the rank recurrence

Fix a finite affine cover of V on which D is principal and the vector
bundles in use are free. All intersections are affine because V is
separated. For the finite-page argument one can use the algebraic
Cech cochains C_i^a(E) of E(iD) on this cover. They form an increasing
filtration of the cochains with finite poles along D. Its quotient
C_i/C_(i-s) computes the algebraic coherent sheaf
P_i^s(E)=E(iD)/E((i-s)D). These are the same finite page data as for
the manuscript's completed cochains: any of the conditions below
uses only finitely many layers, and local sections of their
finite coherent quotients lift on affine opens. No convergence
statement about an infinite spectral sequence is needed.

In the leading cochain space C_i^a/C_(i-1)^a define

    Z_s^(i,a) = {[x] : partial x is in C_(i-s)^(a+1)},
    U_s^(i,a) = {[partial y] : y is in C_(i+s-1)^(a-1),
                                partial y is in C_i^a},
    E_s^(i,a) = Z_s^(i,a)/U_s^(i,a).

An exact representative is closed, so U_s is contained in Z_s.
The map on representatives partial x induces

    d_s: E_s^(i,a) -> E_s^(i-s,a+1)

and next pages equal to their cohomology. Here is the representative
check: changing x by a lower cochain changes its differential by a
boundary with primitive upper cut i-1, precisely the allowed target
cut (i-s)+s-1. If its differential class vanishes, subtract such a
lower cochain to improve closedness by one layer. Incoming images
enlarge the allowed primitive cut from i+s-1 to i+s. These are
exactly Z_(s+1) and U_(s+1), proving the next-page assertion.
The identity partial^2=0 proves that consecutive maps compose to zero.
Page one is H^a(P_i^1).
Since D is a projective surface scheme, only rows a=0,1,2 remain.
There is no incoming map to row zero, so its rank is the leading
image of H^0(P_i^s). The top row is the image of
H^2(P_i^1)->H^2(P_(i+s-1)^s).

Dualizing the two-term Cartier presentation of P_j^s(E) gives
sheaf Ext^1 equal to P_(s-j)^s(E^!), E^!=E^dual tensor omega_V,
with all other sheaf Ext zero. Functorial duality therefore gives

    g_s^2(i;E) = g_s^0(1-i;E^!).

In particular the reflection is 1-i, not -i. Writing
delta_s^a(i)=g_s^a(i)-g_(s+1)^a(i) for the two outer rows, the
middle recurrence is

    g_(s+1)^1(i)
      = g_s^1(i) - delta_s^0(i+s) - delta_s^2(i-s).

Both losses must be added if they address the same middle entry,
even on the same page. This is legitimate because d_s^2=0: the
incoming image is contained in the outgoing kernel.

If O(MD) is trivial on sD, all ranks through page s are M-periodic.
The alternating period sum is unchanged, since the four loss terms
are translates of the same two periodic functions. Riemann--Roch
and the intersection vanishings give chi(P_i^1)=gamma at every i.
Thus, whenever there are k outer entries counted with multiplicity
per period, the middle ranks obey

    sum n(a) + M gamma = k.

Here gamma is an integer, as it is an Euler characteristic, so
the formal theorem's natural gamma loses no hypothesis.

## 3. Forced canonical jets and coefficient divisibility

Suppose all leading canonical jets vanish above some width S,
uniformly over their upper weights. The scalar top row then vanishes.
For large e take s_e=d_(e-1)+1>=S. At that page the scalar bottom
row is one at multiples of M_e and zero elsewhere. The period sum
of the middle ranks is 1-M_e gamma<=1.

At length d_e, bottom entries at j M_e, p not dividing j, drop.
Their target middle positions are -d_e+j M_e. At least one lift
of this residue is hit; periodicity forces its initial rank to be
at least one. The budget forces gamma=0 and exactly this one
middle entry per period. Between s_e and s_(e+1) these are the
only drops. Modulo p M_e they leave exactly the unshifted lift
-d_e. Applying the same argument at e+1 leaves -d_(e+1).
But 0<d_e<d_(e+1)<M_(e+1), so these cannot be the same residue.
This contradiction proves that arbitrarily wide nonzero leading
canonical jets exist. It does not assert that a fixed upper weight
has them.

Raise local representatives of a width-s canonical jet at weight l
to the Pth power and use omega^P=O(B_*). The resulting scalar
numerators and differences have divisor bounds

    PlD+B_*  and  P(l-s)D+B_*.

Put beta_alpha=b_alpha/m_alpha and choose an integer c_*>=max beta.
Embedding both bounds into the corresponding uniform multiples of
D gives a scalar jet with lower cut P(l-s)+c_*.
A component detecting the original leading layer has powered scalar
pole ratio greater than P(l-1)+min beta. For all sufficiently large
s this exceeds the new lower cut, uniformly in l.

Section 1 supplies a common integral pole ratio t for these powered
sections, and a unit trivialization of O(tD) to width
t-P(l-s)-c_*. The preceding lower estimate and the uniform upper
cut Pl+c_* imply, for a fixed integer C,

    |t-Pl| <= C,    available scalar width >= Ps-C.

For every fixed J, a scalar width greater than d_(J-1) occurs
only at a multiple of M_J, including zero. Along the chosen jets
we may therefore take J tending to infinity with M_J dividing t.

At a component D_alpha the valuation identity, with its sign, is

    b_alpha - t m_alpha = P ord_(D_alpha)(f_lambda).

Indeed the scalar rational generator of O(B_*) has order
-b_alpha. Eventually P divides t, hence P divides b_alpha.
This is the identity formalized by `coefficient_divisibility`.
There is no cancellation modulo a nonreduced divisor in this step.

Write B_*=P B_0 and h_0=t/P. The original representatives are unit
sections of omega(-B_0+h_0 D). Their differences are still in
omega((l-s)D), so they trivialize this bundle on

    (h_0-l+s)D - B_0.

Since h_0-l is bounded, this thickness contains nD with n tending
to infinity. Also M_(J-b) divides h_0 for J>=b, so O(h_0D) is
trivial on d_(J-b)D. Removing that twist on the smaller of these
two growing thickenings makes L=omega(-B_0) trivial on arbitrarily
large nD.

For completeness, these possibly incompatible trivializations can
be made compatible. Let A_n=H^0(nD,L|_(nD)), including restriction
to D_red. The stable images of A_t in A_n are attained because
A_n is finite dimensional. Taking a stage beyond stabilization at
both n and n+1 makes the maps between stable images surjective.
The stable image on D_red contains a unit and is its whole
one-dimensional section space. Lift a fixed nonzero section there
through these surjections. Every lift is a unit, by reduction and
Nakayama. The inverse limit is the required formal trivialization.

## 4. Canonical endpoints on the actual irregular thickenings

Set

    beta_min = min_alpha b_(0,alpha)/m_alpha,
    h = -floor(beta_min),   q = 1-h,
    C_0 = h + ceil(max_alpha b_(0,alpha)/m_alpha).

The formal isomorphism just proved respects multiplication by every
divisor lattice and hence descends to algebraic maps on finite
quotients. A canonical width-s leading jet at weight l has, after
the same uniform enlargement as above, one scalar pole ratio t.
Fitting in the upper lattice but not its preceding layer means

    l-1+beta_min < t <= l+beta_min.

For integral t this is exactly t=l-h. The local normalized units
glue on the divisor

    T_s = (s-h)D - B_0.

Conversely a unit trivialization of O((l-h)D) on T_s includes
in the canonical quotient and has nonzero leading image.
For sufficiently large s, this gives exactly one leading dimension
when that line bundle is trivial, and zero otherwise.

For every component,
0<=h m_alpha+b_(0,alpha)<=C_0 m_alpha. Thus

    (s-C_0)D <= T_s <= sD.

This is a coefficientwise statement on the nonreduced cycles;
neither side is being replaced by its reduction. It proves that
the last irregular width d'_e satisfies

    d_e <= d'_e <= d_e+C_0

for large e. The nilpotent-kernel argument from Section 1 applies
once T_s contains D, so nonzero ratios j M_e with p not dividing
j have this same last width. All other nonzero last-width
indices eventually disappear as s grows; ratio zero persists.
The top row therefore has its single endpoint at q modulo M_e.

## 5. Collision-safe rank saturation and the swapped matching

For large e put s_e=max(d_(e-1),d'_(e-1))+1.
Frobenius growth and the bounded offset ensure
s_e<=min(d_e,d'_e), with s_e strictly increasing.
At this page the two outer entries are at 0 and q modulo M_e.
Between s_e and s_(e+1), only last-width index e drops.
By Section 2 their middle targets are

    A_e+j M_e,  A_e=-d_e,
    B_e+j M_e,  B_e=q+d'_e,          p not dividing j.

Consider one residue a modulo M_e. If it contains m of these
centers, m is 0, 1, or 2, counting repetitions. Its initial
middle rank n is the same at all p lifts modulo p M_e. Each
drop list omits exactly one lift, its own unshifted center.
Even when the centers collide modulo M_e, the omitted lifts
may differ. Since p>2>=m, some lift is omitted by none of
the lists. Capacity at that lift gives n>=m.

The Euler budget is sum n=2-M_e gamma and sum m=2.
Consequently gamma=0 and n=m in every residue. After the
drops, the surviving rank at each lift is exactly the number
of lists omitting it. This proves equality of the two-element
multisets

    {-d_e, q+d'_e} = {-d_(e+1), q+d'_(e+1)} mod M_(e+1).

This is the all-parameter theorem `endpoint_rank_rigidity`,
specialized to k=2, followed by `forced_pair_swap`.
The more general formal result permits any k<p lists.
At p=k=2 the capacity conclusion is false: two lists omitting
different lifts consume only one rank at each lift. That is a
sharpness example outside the manuscript's characteristic range,
not a refutation of it.

The two negative centers are distinct modulo M_(e+1), so
the multiset matching must swap them. Both congruences follow:

    d_(e+1)+q+d'_e = 0 mod M_(e+1),
    d_e+q+d'_(e+1) = 0 mod M_(e+1).

The first sum is positive and less than 2M_(e+1) for large e:
d_(e+1)<M_(e+1), d'_e<M_e+C_0, q is fixed, and the
widths grow without bound. Hence it is exactly M_(e+1).
Dividing this equality by M_(e+1), using the bounded offset
and the monotone bounded scalar ratios, already recovers
a_*+a_*/p=1 and a_*=p/(p+1), as in the manuscript.

## 6. Stronger conclusion: an exact tail, without assuming a limit

Write epsilon_e=d'_e-d_e, so 0<=epsilon_e<=C_0. Subtract
the first swapped equality from the second congruence:

    M_(e+1) divides epsilon_(e+1)-epsilon_e.

For M_(e+1)>C_0 the difference has absolute value less than
the modulus and must vanish. Thus epsilon_e is eventually a
constant epsilon. This uses the second swapped congruence,
which is not needed for the manuscript's limit calculation.

Set c=q+epsilon and reindex at such an E. Then

    d_(E+n+1)+d_(E+n)+c = M_E p^(n+1)

holds for every n>=0. Direct subtraction at consecutive
indices shows that

    K_n=2(p+1)d_(E+n)-2p M_E p^n+(p+1)c

satisfies K_(n+1)=-K_n. Induction gives K_n=(-1)^n K_0
and therefore

    d_(E+n) = p M_E p^n/(p+1) - c/2
                + (-1)^n K_0/(2(p+1)).

In particular the absolute normalized error is at most

    (|c|/2 + |K_0|/(2(p+1))) / (M_E p^n).

This proves the limit without assuming it exists.
`width_limit` formalizes the actual real topological limit.
The finite-prefix Python and Jacobian calculations are only
replayable diagnostics; the quantified proof is not inferred
from them.

Frobenius growth at two consecutive indices gives
K_n<=(p-1)c and -K_n<=(p-1)c. Hence
|K_0|<=(p-1)c and c>=0. Conversely, for integer p>1, M_E>0,
and integers c,K with

    K = (p+1)c - 2p M_E mod 2(p+1),
    |K| <= (p-1)c,

the displayed formula defines an integral recurrence tail:
the congruence makes its initial term integral, and the integer
recurrence propagates integrality. The bound is equivalent
to Frobenius growth at both parities. The widths are positive
and strictly below M_E p^n for sufficiently large n.
This classifies these numerical recurrence tails, not geometric
realizations of them.

For example p=5, M_E=2, c=1, K=-2 gives
1, 8, 41, 208, ... and is an abstract admissible width tail.
It is not a constructed threefold. The preserved Jacobian
operation evaluates the equivalent order-three recurrence
d_(n+3)=5d_(n+2)+d_(n+1)-5d_n for twelve terms; its exact
result agrees with the independent rational replay.

## Certification boundary

`Main.lean` proves the generalized rank saturation, multiplicity-safe
matching, integer divisibility and thickness arithmetic, offset
stabilization, the exact tail, its growth bound, and the genuine
limit for all parameters in their stated domains.
The geometric constructions in Sections 1--4 and their interpretation
as the formal hypotheses are a prose proof requiring independent
mathematical review. The certificate does not close the upstream
geometric assumptions, the Laurent/Cartier arguments, or either
abundance theorem. Publishability and novelty require independent
assessment; they are not consequences of a compiler exit code.
