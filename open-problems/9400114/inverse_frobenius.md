# Inverse-Frobenius identities in the full cyclotomic quotient

This is a candidate theorem, not a counterexample or an independent review
verdict. The original identity remains

    F_n = (X-1)^n - X^n + 1 = 0 modulo (n, X^r-1),
    gcd(n,r)=1.

The earlier finite logarithm and residual-content searches did not settle
unrestricted inverse-Frobenius identities. Those finite routes are not
reopened here. The norm identity itself is classical; the proposed new
contribution is the full-quotient order classification, its unrestricted
cofactor consequence, and a compatible positive-density construction.

## 1. Notation and the two factors

Let r >= 7 be prime, r = 3 modulo 4, and let p be an odd prime with
ord_r(p)=h=(r-1)/2. Thus h is odd. Put q=p^h and

    A = F_p[X]/(1+X+...+X^(r-1)),
    b = X-1, c = -X^(-1), U = 2-X-X^(-1).

The subgroup H=<p> of (Z/rZ)^* has order h and does not contain -1.
The roots indexed by H and -H give the two irreducible degree-h factors.
Consequently A is a product of two copies of F_q, not a field.

The involution tau(X)=X^(-1) exchanges those factors. Its fixed algebra
A^tau is one copy of F_q. The relevant identities in the entire algebra are

    tau(b)=cb, tau(c)=c^(-1), tau(U)=U, b^2*c=U.

All three elements are units; c has exact order 2r. Let m=ord_A(U),
equivalently the order of U in (A^tau)^*. In particular m divides q-1.
Write g=gcd(r,m).

**Norm convention.** The norm meant by Norm(U)=r is the degree-h norm
from A^tau to F_p. The degree-(r-1) algebra norm from A to F_p is r^2.
These are different assertions and must not be conflated.

Indeed, choosing a primitive r-th root zeta, H selects exactly one member
of each pair {a,-a}. Therefore

    Norm_(A^tau/F_p)(U)
      = product_(a in H) (1-zeta^a)(1-zeta^(-a))
      = product_(a=1,...,r-1) (1-zeta^a) = r.

The last identity is Phi_r(1)=r and remains valid modulo p.

There is a useful exact scalar reduction of the sign obstruction. With
S=1+p+...+p^(h-1), the norm identity is U^S=r, and S is odd. Hence

    v_2(m)=v_2(ord_(F_p^*)(r)).                 (0)

Taking a norm therefore loses no two-primary information, although it
can lose the r-primary information because r divides S.

## 2. Exact inverse-target classification

**Theorem 1.** For every j >= 0, there is an integer k satisfying

    b^k = X^(-p^j)-1 in A

if and only if

    gcd(r,m)=1 and v_2(m) != 1.

Negative exponents are interpreted in the unit group. All integer
solutions, and hence all positive solutions, are as follows.

* If m is odd and g=1, choose t by
  t=0 modulo 2 and r*t=p^j modulo m. Then
  k=2r*t-p^j modulo 4rm.
* If 4 divides m and g=1, choose t by
  (r-m/2)*t=p^j modulo m. Then
  k=2r*t-p^j modulo 2rm.
* If g>1 or v_2(m)=1, there are no solutions.

The t classes in the first two cases are unique modulo 2m and m,
respectively. In the second case t is automatically odd.

**Proof.** The target is c^(p^j)*b^(p^j), so the identity is equivalent to

    b^(k-p^j)=c^(p^j).

Apply tau to this equality and divide the resulting equality by it.
Since c has order 2r, necessarily k+p^j=0 modulo 2r. Thus write

    k=2r*t-p^j, d=(k-p^j)/2=r*t-p^j.

Using b^2=U*c^(-1), the original equation is now equivalent, in both
factors simultaneously, to

    U^(r*t-p^j)=(-1)^t.                         (1)

If m is odd, the only possibility is t even, followed by
m dividing r*t-p^j. The two congruences have a solution precisely when
g=1, because gcd(p,m)=1 and gcd(p,r)=1.

If m is even, U^(m/2) is -1 in the fixed copy of F_q: that field has
only one element of order two. Equation (1) becomes

    (r-m/2)*t=p^j modulo m.                     (2)

For v_2(m)=1, its left coefficient is even and its right side is odd,
so (2) is impossible. For 4 dividing m, the coefficient is odd and

    gcd(m,r-m/2)=gcd(m,r)=g.

This proves both necessity and sufficiency and the stated exponent
classes. No equality in just one field factor has been used. QED.

## 3. The period and every local exponent class

**Theorem 2.** The exact order T=ord_A(b) is

    T = 4rm/g       if m is odd;
    T = rm/g        if v_2(m)=1;
    T = 2rm/g       if v_2(m)>=2.

In particular r divides T, T is even, and p does not divide T.

For every positive n coprime to r, the full r-coefficient identity
F_n=0 modulo (p,X^r-1) holds exactly in these classes modulo T:

    n=p^j modulo T,                  0 <= j < h,

and, when Theorem 1 is admissible, the additional h inverse classes
k_j given there. These classes are distinct. There are h classes when
the inverse criterion fails and r-1 classes when it holds.

**Proof.** If b^k=1, applying tau first gives c^k=1. Write k=2r*l.
Then b^k=1 is equivalent to

    U^(r*l)=(-1)^l.

For m odd the smallest positive l is 2m/g. For m even it is

    m/gcd(m,r-m/2).

If v_2(m)=1 that gcd is 2g; if 4 divides m it is g.
This gives the three periods. They are multiples of r, including when
g=r because then r divides m.

Every nonzero residue modulo r is p^j or -p^j for exactly one j in
[0,h). A positive exponent whose residue is p^j has target
X^(p^j)-1=b^(p^j), hence is a solution exactly modulo T as stated.
The inverse residues are covered by Theorem 1. Distinctness follows
already from reduction modulo r.

Finally X^r-1=(X-1)*Phi_r with coprime factors over F_p, since p != r.
At X=1 the residual is zero for every n>0. Thus the classification
in A is equivalent to the full cyclic identity, not merely a primitive
root test. QED.

## 4. Arbitrary-cofactor exclusion

**Corollary 3.** Let n>1 be coprime to r and satisfy the original
identity modulo n. If an odd prime p dividing n has ord_r(p)=h, all
classes and exclusions of Theorem 2 apply to that actual exponent n.
There is no restriction on the other prime divisors of n, on their
number, or on their multiplicities.

In particular, if gcd(r,m)>1 or v_2(m)=1, then

    n modulo r belongs to H.

Thus every composite n containing such a p and having a quadratic
nonresidue modulo r is excluded, even when n is squarefree.
For an admissible p, every inverse residue also requires its unique
class modulo T; merely belonging to -H is insufficient.

**Proof.** Reduce the given full identity modulo p and apply Theorem 2.
The unique subgroup H of index two is the subgroup of quadratic
residues. This argument never replaces n by a prime power, restricts
its cofactor, or asserts that a passing modulo-p identity lifts modulo
n. QED.

An explicit infinite obstruction family follows without computing m.
If p=3 modulo 4, put

    w=X^((r+1)/2)-X^(-(r+1)/2).

Then U=-w^2. In either degree-h field factor, -1 is a nonsquare because
p^h=3 modulo 4. Thus U is a nonsquare, v_2(m)=1, and the nonresidue
cofactor families of Corollary 3 are excluded. For example, for r=7
this includes every prime p=11 or 23 modulo 28. It excludes actual
full solutions in those families, not just a bounded list of integers.

## 5. An unconditional positive-density theorem for r=7

**Theorem 4.** There is a set of rational primes of positive natural
density at least 1/230496 for which

    p=2 modulo 49, p=9 modulo 16,
    ord_7(p)=3, 7 does not divide m, v_2(m)=2.

Here m is the order in the entire Phi_7 quotient, as above. In
particular inverse-Frobenius identities are admissible for every prime
in this set. The target -p modulo 7 is 5, whose square is 4, not 1.
This is a local existence and classification theorem; it supplies no
composite solution of the identity modulo its full n.

### 5.1 The real Kummer classes and the cyclotomic class

Let zeta be a primitive seventh root in characteristic zero, and put

    F0=Q(zeta),
    U_i=2-zeta^i-zeta^(-i), i=1,2,3,
    E=F0(U_1^(1/7),U_2^(1/7),U_3^(1/7)).

Each U_i is a nonzero positive real algebraic number. Their product
is 7. They satisfy

    T^3-7T^2+14T-7=0.

Thus the characteristic-zero real-field norm is also 7, with the
same sign as the finite-field norm. The polynomial is Eisenstein at
7, so the real field has degree three.

The field E is Galois over Q: automorphisms of F0 permute the U_i,
and all seventh roots of unity already belong to F0. The group
Gal(E/F0) is elementary abelian of order 7^d for some d<=3.
No independence of the three radicands is assumed.

Let V be the span of [U_i] in F0^*/F0^(*)7. Complex conjugation
fixes V pointwise and sends [zeta] to -[zeta]. The class [zeta] is
nonzero, since a seventh root of zeta would be a primitive 49th
root, and [Q(zeta_49):Q]=42>6. As 2 is invertible modulo 7,
[zeta] cannot belong to V.

The Kummer correspondence now gives

    E intersect Q(zeta_49)=F0.                 (3)

Indeed Q(zeta_49)/F0 has prime degree seven, so a nontrivial
intersection would contain zeta_49 and force [zeta] into V.
The Kummer result used here is Milne, *Fields and Galois Theory*,
version 5.10, Theorem 5.30 and its proof, pp.75-76.

### 5.2 The two-primary extension and its exact intersections

Put alpha=7^(1/4)>0, and define

    D=Q(i,alpha),
    B=Q(zeta,zeta_16)=Q(zeta_112),
    L2=B*D.

The splitting field D of T^4-7 has dihedral group of order eight.
Its maximal abelian subfield is

    D_ab=Q(i,sqrt(7)).

For completeness, rotation alpha -> i*alpha and complex conjugation
generate the dihedral group; their commutator subgroup is generated
by alpha -> -alpha, i -> i. Its fixed field is exactly D_ab.

The quadratic subfield of F0 is Q(sqrt(-7)). One can see the
required square root directly:

    theta=zeta+zeta^2+zeta^4-zeta^3-zeta^5-zeta^6,
    theta^2=-7.

Thus B contains both i and sqrt(7)=plus or minus i*theta.
Because B/Q is abelian, D intersect B is an abelian subextension
of D, and consequently

    D intersect B=D_ab, [L2:Q]=48*8/4=96,
    [L2:F0]=16.                               (4)

In particular E intersect L2=F0, because its degree divides both a
power of seven and 16.

The extra two-primary field cannot destroy (3). Suppose that
[zeta] belonged to the span of the [U_i] in L2^*/L2^(*)7.
Taking the norm to F0 would give 16[zeta] in V. Since 16 is
invertible modulo 7, this contradicts [zeta] not in V. Applying
the same Kummer correspondence over L2 proves

    E*L2 intersect L2(zeta_49)=L2.             (5)

Also L2 intersect Q(zeta_49)=F0 by the coprime degree argument.
These are the intersections actually needed for compatibility;
no blanket field-disjointness assertion is made.

### 5.3 An explicit compatible automorphism

Define an automorphism of B by

    zeta -> zeta^2, zeta_16 -> zeta_16^9.

It fixes theta, since multiplication by 2 permutes the quadratic
residues {1,2,4}, and it fixes i because 9=1 modulo 4.
It therefore fixes D_ab. The automorphism

    alpha -> -alpha, i -> i

of D fixes D_ab as well. By (4), these two restrictions extend to
an automorphism sigma_2 of L2.

Choose any lift gamma in Gal(E/Q) of zeta -> zeta^2. Its cube is
in Gal(E/F0), whose exponent divides seven. Hence

    sigma_E=gamma^7, sigma_E^3=1,
    sigma_E(zeta)=zeta^2.                     (6)

Thus sigma_E has order exactly three. Since E intersect L2=F0,
sigma_E and sigma_2 extend jointly to E*L2.

On Q(zeta_49) choose zeta_49 -> zeta_49^2. Its restriction to
F0 is again zeta -> zeta^2, so it extends jointly with sigma_2
to L2(zeta_49). Finally (5) joins these automorphisms into an
actual automorphism sigma of the finite Galois field

    F=E*L2*Q(zeta_49).

This proves nonemptiness of the required Frobenius condition before
using any density theorem.

### 5.4 Frobenius, valuations, and the entire quotient

Let C be the conjugacy class of sigma in Gal(F/Q). All its elements
have the same restrictions to B and Q(zeta_49), which are abelian.
The chosen element of Gal(D/Q) is central, so its restriction to D
is also unchanged by conjugation. Restrictions to E still have
order three.

For an unramified rational prime p with Frobenius class C:

* The cyclotomic restrictions give p=2 modulo 49 and p=9 modulo 16.
  Therefore v_7(p^3-1)=1 and v_2(p^3-1)=3.
* The residue degree in F0 is three. Frobenius cubed is the identity
  on E by (6), so a prime of F0 over p splits completely in E/F0.
  The seventh roots of every U_i therefore reduce into F_(p^3).
  Consequently U is a seventh power in both conjugate factors of
  A. Since v_7(p^3-1)=1, its entire-quotient order m is prime to 7.
* Frobenius fixes i and sqrt(7), but negates alpha. Hence 7 is a
  square but not a fourth power modulo p. As v_2(p-1)=3, its
  multiplicative order in F_p has two-adic valuation two.
  Equation (0) gives v_2(m)=2.

In the third step no sign was dropped: for p=1 modulo 4 all four
roots of T^4-7 are in F_p precisely when Frobenius fixes alpha.
Negating alpha fixes its square but fixes none of those four roots.
In the second step the prime is not 7, so the U_i and their radical
reductions are nonzero. Any other ramified primes form a finite
exceptional set and are omitted.

Finally (4)-(5) give

    [F:Q]=96*7*[E:F0] <= 96*7^4=230496.

Chebotarev's unconditional natural-density theorem gives the set
just used density |C|/[F:Q], at least 1/230496. Its hypotheses are
a finite Galois extension and a nonempty conjugacy class, both
established above. The cited statement is Milne, *Algebraic Number
Theory*, version 3.08, Definition 8.30 and Theorem 8.31, p.147.
No GRH, independence heuristic, or search result enters the proof.
QED.

## 6. What this changes, and what it does not

The earlier accepted cubic obstructions concern a repeated prime and
a local identity modulo p^2. Corollary 3 instead excludes full
solutions containing a specified prime already modulo p, with
unrestricted cofactors, and can apply to squarefree integers.
It is a different family exclusion, not a larger numerical version
of the accepted repeated-prime threshold.

Theorem 4 proves that the inverse-Frobenius branch is genuinely
populated locally with positive prime density. An argument forbidding
all inverse local logarithms is therefore false. A full integer
counterexample would still have to satisfy the local conditions of
every prime divisor and every prime-power lift. None is asserted here.

The classical norm and recurrence reduction already occur in
Granville 2005, Proposition 8.6 and Section 8.6/Proposition 8.9.
The inversion multiplier already occurs in Popovych, ePrint
2009/008, Section 4. Popovych's Proposition 3.1 uses full-order,
not odd half-order, primes. Bernstein 2007 uses Kummer extensions
for a different primality criterion. These inputs are not claimed
as new. The candidate novelty is the combined exact period/sign
classification and explicitly compatible positive-density
inverse-target theorem; see `literature/comparison.md`.

The independent source reader did not locate this combined statement
in the three inspected primary texts. That bounded observation is
not verified originality. The unread Hegde-Devaraj chapter is not
silently treated as a non-overlap certificate, and its failed access
routes have not been repeated. Normal independent Reviewer assessment
of correctness, original-statement fidelity, novelty, and publication
significance remains required.

## 7. Independently rerunnable exact controls

Run from the campaign root:

    PYTHONDONTWRITEBYTECODE=1 python3 search/inverse-frobenius-norm-kummer/verify_inverse_frobenius.py

The verifier imports the unchanged whole-Phi quotient arithmetic and the
separate native schoolbook full-cyclic coefficient checker. It records
exact factor-stripped orders and strict order-minimality vectors, paired
and full norms, and all predicted exponent classes. Four small periods
are replayed completely in the full cyclic ring. Across fourteen p,r
controls, 136 predicted full-coefficient identities are checked.
These finite controls support, but do not replace, the universal prose
proof. They do not declare it mechanically verified.

The two admissible branches have the following exact controls:

| p | r | m | v_2(m) | ord_A(b) |
|---|---|---|---|---|
| 30137 | 7 | 1955113698668 | 2 | 27371591781352 |
| 37781 | 7 | 1926026751805 | 0 | 53928749050540 |

For p=30137, all conditions of Theorem 4's specified prime class hold.
Jacobian's inspected scalar `modular.compute.multiplicative_order`
operation gives ord_p(7)=15068=4*3767, agreeing with independent
integer arithmetic. Its exact payload and typed output are retained
in `jacobian-norm-order.payload.json` and
`jacobian-norm-order.output.json`. This scalar check is not presented
as a Kummer proof or a whole-quotient logarithm calculation.

The actual composite exponents

    n=176763784610302685, p=30137,
    n=436603300259706011, p=37781

are divisible by the stated p and lie in the j=1 inverse classes.
For each, n=5 modulo 7, n^2=4 modulo 7, and all seven residual
coefficients are zero modulo p. The unchanged native verifier also
checks them modulo their entire n: both fail, with first residual
coefficients 175430875438736525 and 214570380892708711 respectively.
Neither is an original counterexample.

A separate negative control makes the two-factor requirement visible.
At p=23, the factors of Phi_7 are

    X^3+10X^2+9X+22, X^3+14X^2+13X+22.

For the target X^5-1, the first factor has no logarithm and the second
has logarithm 892. The entire cyclic target residual at exponent 892 is

    [9,6,6,8,0,17,0] modulo 23,

so the single-factor logarithm cannot be promoted to a whole-quotient
identity. Also 892=3 modulo 7, not 5: it is a relation to a specified
target in one factor, not even a candidate full Agrawal exponent for
that target. The positive controls above, in contrast, obey the actual
exponent's target and test all coefficients.

The generated `exact_controls.json` contains these arithmetic objects.
Replaying the verifier does not write role progress, activity, the
mathematical ledger, or a Reviewer verdict.
