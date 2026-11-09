# A finite-level proof of the Tate-coordinate differential

This is an ordinary mathematical proof, not a fully formalized theorem about
p-divisible groups. Independent mathematical review is outstanding. The
algebraic checks accompanying it certify only the statements specified in
`exact_certificate.json`; computations on finite fields are not evidence for
the universal quantifiers by themselves. No novelty or publication verdict is
asserted here.

## Statement and conventions

Fix any prime p and integers 1 <= h < n. Put r = n-h, q = p^h, and Q = p^n.
Let C be an algebraically closed complete nonarchimedean field of characteristic
p, with a fixed coefficient-field embedding of k_n = F_(p^n).
Let H be the universal marked deformation of the height-n Honda formal group
over R_0 = k_n[[u_1,...,u_(n-1)]], and let G be its algebraic p-divisible group.
The height-at-least-h locus is u_1 = ... = u_(h-1) = 0. Take a small point x
on this locus with u_h(x) != 0. All the remaining parameters have norm < 1.

Write P_y(T) = [p]_(H_y)(T) = f_y(T^q). Its coefficients are integral analytic
functions, and f_x'(0) != 0. Use the specialization map Theta_y from
`def:transport`, with its analytic dependence on y. Set

    T_x = ker(Theta_x) = T_p(G_x^et),
    theta_i(y) = Theta_y(z_i),
    s_i(y) = Theta_y(p^(-1) z_i),
    t_i = s_i(x),

where z_1,...,z_r is any Z_p-basis of T_x. The images of t_i in G_x^et[p]
are consequently an F_p-basis. The coordinate of each t_i is small.

**Theorem.** For every such p, n, h, x, and basis,

    (D theta_x)_(i,j)
      = (partial P_y(T) / partial u_(h+j-1)) evaluated at (x,t_i)
      = M_(i,j),

and det(M) != 0.

This verifies the differential assertion of Proposition `def:coordinates`.
It does not verify `orb:density`, the invariant-prime classification, or the
Hovey--Strickland theorem: those have additional, unreviewed obligations.

## External inputs and their exact scope

1. Lubin--Tate, *Formal moduli for one-parameter formal Lie groups* (1966),
   DOI 10.24033/bsmf.1633, Proposition 1.1, Proposition 2.6, Theorem 3.1,
   and Section 3.2: marked universality, its tangent space, and successive
   height parameters. Here a marked isomorphism reduces to the identity
   as an entire power series, not merely in its linear coefficient.
2. Lau, *Tate modules of universal p-divisible groups*, published version
   (2010), DOI 10.1112/S0010437X09004242, p. 226, Theorem 5.1 and (5.1):
   square-zero lifts over an arbitrary ring where p is nilpotent form the
   torsor Hom(omega_(G^dual), J tensor Lie G). The Kodaira--Spencer
   comparison is functorial for arbitrary ring maps. This includes p = 2.
   It does not itself construct an analytic evaluation map.
3. Gabriel, SGA 3, Expose VII_A, corrected editor-hosted version dated
   2024-10-13, Sections 4.1.1, 4.3, and 4.3.2: relative Frobenius and
   Verschiebung for flat commutative group schemes in characteristic p,
   base-change compatibility, and VF = [p], FV = [p].
   Applying these functorially at each finite flat level gives the same
   identities for p-divisible groups over the nonreduced base used below.
4. The connected-etale sequence over a henselian local ring and its
   canonical splitting over a perfect field; faithful-flat exactness of
   multiplication by p on a p-divisible group. Accessible statements are
   Hong, *Lecture notes on p-adic Hodge theory*, pp. 46-47, Lemma 2.1.6
   and Propositions 2.1.7, 2.1.8, 2.1.12; and Morrow, *p-Divisible Groups*,
   Bonn WS2015/16 final notes, p. 28, Definition 5.3 and Example 5.4,
   and p. 38, Proposition 7.7 for dim G + dim G^dual = height G.
   Surjectivity here is sheaf-surjectivity, not surjectivity on arbitrary
   A-valued points.
5. Stacks Project, Tags 025H and 039R, Theorems 41.15.1-2, retrieved
   2026-11-05: etale schemes and their morphisms lift uniquely across a
   nilpotent thickening. Thus the etale quotient over C[epsilon]/epsilon^2
   is its constant lift, with its given residue marking.

The source-retrieval record in `literature/` distinguishes precise statements
from their applications here. These are external mathematical inputs, not
Lean-verified facts. In particular no infinite torsion-lifting conclusion from
`def:coordinates` is an input.

## Analytic chain rule

Choose a closed parameter polydisc, centered at the origin and strictly
inside the open unit polydisc, whose interior contains x. If delta < 1
bounds its coordinate radii, the finite approximants defining Theta_y(w)
for any fixed small Honda point w satisfy the uniform Gauss-norm bound

    ||Theta_(m+1)(w) - Theta_m(w)|| <= delta^(q^m).

Indeed P_y(T) - T^Q has coefficients of norm at most delta; factoring
P_y through T^q makes m compositions q^m-Hölder, and the inputs remain
in the open unit ball. Each approximant belongs to the polydisc's
complete Tate algebra. Their limit is analytic. Partial differentiation
on this Tate algebra is bounded by the inverse of the corresponding
coordinate radius: integer coefficients introduced by differentiating
have norm at most one. Thus the limits can be differentiated.

For our finitely many w = z_i and p^(-1)z_i, shrink around x so that
all s_i(y) remain in a fixed ball of radius < 1. Evaluation of the integral
series P_y(s_i(y)), and its differentiated series, is then convergent.
The compatibility identity from the universal cover gives

    P_y(s_i(y)) = theta_i(y).

The ordinary T-derivative of P_y is identically zero: every T-exponent
is divisible by q, which is zero in C. The analytic chain rule therefore
gives

    D theta_i,x(v) = (D_y P_y)(x,t_i)(v) + P_x'(t_i) D s_i,x(v)
                  = sum_j M_(i,j) v_j.

There is no sign change or invariant-differential factor in this formula:
the output is the chosen formal coordinate at theta_i(x) = 0.
No derivative bound uniform over all torsion levels is being used.

For completeness, the fixed-point cover identification used to recognize the
Tate basis does not require deformation-theoretic lifting. For a compatible
sequence (a_m) of small points with P_y(a_(m+1)) = a_m, the inverse is

    z = lim_m a_m^(Q^m).

Successive differences have norm <= delta^(Q^m), and
|z-a_m^(Q^m)| <= delta^(Q^m). Conversely the limit defining Theta gives
|Theta_y(p^(-m)z)-z^(1/Q^m)| <= delta. Applying sufficiently many
q-power contractions proves that the two constructions are inverse.
Comparison of H_y with the Honda law gives the group-homomorphism
identity by the same contraction estimate. Thus ker Theta_x is the
inverse limit of G_x[p^m](C); since the connected factor has only its
identity as a C-point, this is Z_p^r and reduction modulo p gives the
basis of G_x^et[p](C) used above.

## Finite-p splitting lemma

**Lemma.** Let A = C direct-sum J be a local Artin C-algebra with J^2 = 0,
where C is a perfect field of characteristic p. Let G/A be a p-divisible
group, with special fiber G_0 and constant etale quotient
E = (Q_p/Z_p)^r over A. Suppose
G_0 has a splitting of its etale quotient. If the images of a generating
set of E_0[p] lift to points of G[p](A), then G -> E splits, compatibly
with that special-fiber splitting. Over algebraically closed C and
E_0 = (Q_p/Z_p)^r, it suffices to lift one F_p-basis at level p.

**Proof.** Frobenius of A kills J. Its factorization through C identifies
G^(p) with the constant base extension of G_0^(p). Thus the given
special-fiber etale section gives a constant homomorphism

    i: E^(p) -> G^(p).

Relative Frobenius on E is an isomorphism; identify E^(p) with E by it.
Let W = V_G i: E -> G. On the etale quotient, W induces [p].

If a in G[p](A) lifts an etale p-basis point e, then F_G(a) is exactly
the constant point F_(G_0)(e) in G^(p). This equality is stronger than
an equality on residues: on A-valued coordinates, Frobenius kills every
element of J. Hence

    W(e) = V_G(F_G(a)) = [p]a = 0.

The group scheme E[p] is constant etale. Vanishing on its basis therefore
implies W|_(E[p]) = 0 as a morphism of group schemes. The exact fppf
sequence

    0 -> E[p] -> E --[p]--> E -> 0

now makes W descend uniquely to a homomorphism s: E -> G with
W = s [p]. This descent is a sheaf quotient, so it requires no choices
of p-division on A-valued points. It is a morphism of p-divisible
groups, since a homomorphism of their torsion sheaves restricts at each
finite level. If pi: G -> E is the quotient, then

    (pi s)[p] = pi W = [p].

Sheaf-surjectivity of [p] permits cancellation on the right, giving
pi s = id. Reduction gives the originally specified special-fiber
section by the same uniqueness argument. This proves the lemma.

The proof also works when every element of J has p-th power zero, if
the stated connected-etale sequence exists. The square-zero case above
is all that is needed for the differential theorem.

## Why the deformation hypotheses give full rank

We spell out the two deformation-theoretic comparisons rather than assuming
that a Jacobian has the needed rank.

**Full Kodaira--Spencer map.** Algebraize the finite kernels over R_0:
Weierstrass preparation gives

    [p^m]_H(T) = U_m(T) W_m(T),

where W_m is distinguished monic of degree Q^m and U_m is a unit.
The finite free algebras R_0[T]/W_m, with the formal operations reduced
in them, form G. Applying preparation also to [p](T)-V shows finite
faithful-flat exactness of the transition maps.

The factorization through T^q also holds before specializing to a field.
For a homomorphism a:F->F', differentiating its homomorphism identity at
the second input zero gives

    a'(T) partial_2 F(T,0) = partial_2 F'(a(T),0) a'(0).

Both formal-group derivative factors are units. Thus a'(0)=0 implies
a'(T)=0 and factors a through Frobenius over any characteristic-p
coefficient ring, including a nonreduced one. The successive vanishing
height parameters allow this argument to be repeated h times, on the
successive Frobenius twists. Consequently the factorization used for
G_v is valid over the square-zero base, not only on its residue field.

Compare the constant and universal first-order parameter substitutions.
Lau's equivariance gives an R_0-linear map

    K: R_0^(n-1) -> Hom(omega_(G^dual), Lie G).

The deformation-theory cotangent and Lie modules are finite locally free.
The module omega_(G^dual) has rank n-1 by the dual-dimension formula just cited;
Lie G has rank one in the chosen coordinate. Both displayed modules
are therefore free of rank n-1. At the closed point, a marked
isomorphism of p-divisible deformations gives compatible marked
isomorphisms of all finite kernels. These reconstruct a marked
formal-group isomorphism. Explicitly, over an Artin ring B with maximal
ideal N, N^a = 0, the defining kernel ideals obey

    ([p^m](T)) subset (T^(p^m)),
    T^(a Q^m) in ([p^m](T)).

For the second assertion, preparation makes T^(Q^m) lie in N in the
quotient. The two inclusions prove cofinality with the T-adic topology.
Taking inverse limits reconstructs the formal group and its marking.
Lubin--Tate tangent universality now makes the closed-point map
injective; its equal-dimensional target comes from the torsor and the
dual-dimension formula.
Consequently det K is a unit of the local ring R_0.

Only injectivity is needed below, and it has a useful independent
finite-minor proof that avoids even the target-rank count. Choose finitely
many sections of omega_(G^dual) whose reductions span its closed-fiber
cotangent space. Evaluating K on them gives a finite matrix B with n-1
columns over R_0. Closed-point tangent injectivity says B modulo the
maximal ideal has full column rank. An (n-1)-square minor is therefore
a unit in R_0. It remains a unit after every actual evaluation R_0->C,
so K_x is injective at every such point. This uses naturality of the
pairing, not a purported isomorphism between intrinsic differentials
of the perfect field C and the parameter differentials.

This is an algebraic isomorphism over R_0, so its base change along
the actual evaluation map R_0 -> C is still an isomorphism. The
first-order substitution

    a -> a(x) + epsilon sum_i v_i partial_i a(x)

is a ring map, since the power series and derivatives converge at the
small point x. Lau's arbitrary-ring-map equivariance identifies its
deformation class with K_x(v). No claim that Omega_(C/F_p) is nonzero
is needed: the relevant module is Omega_(R_0/F_p) tensor C.
Indeed the finite p-basis decomposition

    a = sum_(0 <= e_i < p) u^e a_e^p

shows that Omega_(R_0/F_p) is free on du_i.

The proof consistently uses the natural torsor and equivariance in
Lau's Theorem 5.1 and (5.1). It does not identify a separately chosen
crystalline torsor action with the cotangent construction. The source
explicitly notes a missing reference for that comparison, which is not
needed for this argument.

**Connected height rigidity.** For a marked first-order deformation
F of a height-h formal group over C, Lubin--Tate gives parameters
a_1,...,a_(h-1). Successively modulo the preceding parameters, the
coefficient of T^(p^i) in [p]_F is a_i times a unit. One can see the
unit directly in the p-fold sum of the leading law term a_i C_(p^i):

    sum_(k=1)^(p-1) ((k+1)^(p^i) - k^(p^i) - 1)/p
       = p^(p^i-1) - 1 = -1 modulo p.

The integral binomial form is legitimate because every intermediate
binomial coefficient of a p-power is divisible by p. If [p]_F factors
through T^(p^h), each of these coefficients is zero. Successive
elimination makes every a_i zero. Thus F is the constant marked
deformation. For h = 1 there are no such parameters. This argument
does not exclude p = 2.

**Apply the finite obstruction.** Let v be any vector of the r-dimensional
height-stratum tangent space with Mv = 0. Form the actual algebraic
deformation G_v over A = C[epsilon]/epsilon^2 by the preceding Taylor
map, with preceding parameters still zero. For each of the r points t_i,

    P_(x+epsilon v)(t_i) = P_x(t_i) + epsilon (Mv)_i = 0.

These are legitimate p-torsion points of the algebraic group, not
unjustified substitutions into an abstract formal group. To see this,
evaluate the preparation identity U_1 W_1 = P in a small analytic
neighborhood of (x,t_i) and then Taylor-evaluate. The reduced value of
U_1 is nonzero, so W_(1,v)(t_i) = 0. Polynomial finite-level group
operations agree with these evaluated operations. A norm
max(|a|,s|b|) on a+epsilon b, with s sufficiently small, makes the
finitely many parameter and torsion coordinates small and justifies
all these convergent evaluations.

Their etale images reduce to a basis of E_0[p], so they are exactly
the unique lifted basis of E[p]. The finite-p splitting lemma gives

    G_v = G_v^0 times E

with its residue marking. The identity factor has formal group H_v:
completion of A[T]/W_(m,v) at its identity is
A[[T]]/([p^m]_(H_v)). Since b(x) != 0 and the preceding parameters
remain zero, [p^m]_(H_v) is T^(q^m) times a unit. These completions
are therefore the connected finite kernels, and recover H_v.
Connected height rigidity makes this factor the constant marked
deformation of H_x. The etale factor is already constant. Hence the
entire marked deformation G_v is constant.

The full Kodaira--Spencer isomorphism forces the full parameter
direction, and therefore v, to be zero. Thus ker M = 0. Since M is
r by r over C, det M != 0. This proves the theorem for every specified
prime, height, point, and Tate basis.

## Comparison with the manuscript and limits

The manuscript lifts the Taylor values of Theta_y(p^(-m)z_i) at every
m and then splits the etale quotient. The proof here needs only the
r constant-coordinate lifts t_i at the single finite level p.
Frobenius--Verschiebung descent supplies the compatible section
algebraically. It neither assumes the manuscript's infinite compatible
lifting conclusion nor assumes nondegeneracy of an obstruction pairing.

The remaining certification obligations are independent checking of the
ordinary deformation-theoretic proof and its source readings, and any
publication/novelty assessment. The algebraic formalization must not be
misreported as a Lean formalization of all the geometric inputs.

## Replaying the accompanying exact evidence

Run `python3 research/tate_jacobian/verify.py` from the campaign root, or
`python3 verify.py` from this directory. The script uses only the standard
library. It checks the preserved typed Jacobian result, the current
external-assumption list, and the actual Lean 4.31.0 compiler certificate
and its official source/fidelity freshness bindings. It also replays
208 square-zero Frobenius values, 3084 synthetic first-order polynomial
identities, 15 p-fold sums with 2055 integral binomial coefficients,
24 finite quotient models with 9 negative controls, and 503 block
matrices. These finite computations are explicitly not a replacement
for either the universal Lean statements or the geometric proof.

Five universal algebraic declarations compiled with exit code zero,
an empty proof-hole list and a successful axiom audit; their only
printed foundational axioms were propext, Classical.choice and Quot.sound.
The source and its fidelity note have not been edited since that run.

Eight cited assumptions still need official independent citation
attribution and mathematical review. Their passages and source-reader
qualifications are local to `literature/`. The official attribution
command writes an archive in `research/literature/`, outside this
mission's writable paths, so that command has not been used to cross
the boundary. No Reviewer acceptance, verified novelty, or campaign
completion is asserted by this report or the replay script.
