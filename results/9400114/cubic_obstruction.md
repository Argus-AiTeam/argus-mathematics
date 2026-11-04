# An explicit cubic primitive-prime obstruction

This is an unconditional prose theorem candidate, submitted for normal
independent Reviewer verification. The new work is the universal short-arc
collision classification, its exact count, and the resulting explicit
threshold. It is not a composite counterexample or a kernel-checked proof.
Originality and publishable significance are not yet independently certified.
The accepted proof artifacts cited below are unchanged.

## 1. Exact statement

For a positive integer a and an odd prime p, write

    F_a(X) = (X-1)^a-X^a+1 in Z[X],
    L_p(X) = sum_(k=1)^(p-1) X^k/k in F_p[X].

For an integer M>=3 define

    N(M) = (binom(M,3)+floor((M-1)^2/4))/2.

**Theorem.** Let r>=37 be prime, let p be an odd prime, and suppose
ord_r(p)=r-1. Put M=floor((r-1)/4). If

    F_p = 0 in (Z/p^2 Z)[X]/(X^r-1),

then

    p >= max{r^2+2, 1+N(M)}.                          (1)

**Arbitrary-cofactor repeated-prime corollary.** Suppose r>=37 is prime,
n>=2, gcd(n,r)=1, and

    F_n = 0 in (Z/nZ)[X]/(X^r-1).

If an odd prime p with ord_r(p)=r-1 satisfies p^2|n, then

    n >= max{r^2+2, 1+N(floor((r-1)/4))}^2.          (2)

There is no restriction on the other prime factors or their multiplicities.
Neither statement covers nonprimitive repeated primes or squarefree n, and
neither settles Agrawal's conjecture.

## 2. Universal rational-function classification

For positive integers x,y,z put S=x+y+z and define

    A(T) = (1-T^(x+y))(1-T^(y+z)),
    B(T) = (1-T^S)(1-T^y),
    R_(x,y,z)(T) = A(T)/B(T) in Q(T).

All denominator factors are nonzero polynomials and have constant term 1.

**Lemma 1.** For any two positive integer triples,

    R_(x,y,z) = R_(x',y',z')

if and only if (x',y',z') is (x,y,z) or (z,y,x).

**Proof.** Use primes on A,B,S for the second triple. Suppose first that
the rational functions are equal, so A B'=A' B as polynomials.
If S>S', take a complex root eta of exact order S. Since

    1 <= x+y,y+z,y < S,     1 <= y' < S' < S,

A(eta) and B'(eta) are nonzero, while B(eta)=0. Evaluating the polynomial
equality contradicts A(eta)B'(eta)!=0. The symmetric argument excludes
S'>S, so S=S'. This argument remains valid when other binomial factors
cancel: the primitive-S factor itself cannot cancel.

Direct expansion gives

    A(T)-B(T) = T^y(1-T^x)(1-T^z),
    R_(x,y,z)(T)-1
      = T^y(1-T^x)(1-T^z)/((1-T^S)(1-T^y)).         (3)

The four factors other than T^y are units of Q[[T]] with constant term 1.
Thus the first nonzero term of R-1 is exactly T^y, with coefficient 1.
Equality of the rational functions therefore gives y=y'.

With S and y fixed, equation (3) permits cancellation in Q(T), giving

    (1-T^x)(1-T^z) = (1-T^x')(1-T^z').

Also x+z=x'+z'=S-y. Expanding and cancelling the common constant and
highest-degree terms yields

    T^x+T^z = T^x'+T^z'.

Equality of monomial coefficients over Q identifies the unordered pairs
{x,z} and {x',z'}, with multiplicity included when x=z. This proves the
necessity. The converse follows immediately from the displayed definition
of R, which is symmetric in x and z. QED.

The proof is universal, not an inference from a finite collision search.
It uses neither a trigonometric approximation nor unique factorization of
specialized numerical cross-ratios.

## 3. Cyclotomic specialization and the exact count

Let omega be a complex root of exact order the prime r>=37 and let

    G_M = {(x,y,z): x,y,z positive integers, x+y+z<=M},
    M = floor((r-1)/4).

For a triple in G_M the four indices satisfy

    0 < x < x+y < S=x+y+z <= M < r.

They are distinct modulo r. For the EVG convention

    cr(a,b,c,d) = (a-c)(b-d)/((a-d)(b-c)),

cancelling the common nonzero factor omega^x gives

    cr(1,omega^x,omega^(x+y),omega^S)
      = (1-omega^(x+y))(1-omega^(y+z))
          /((1-omega^S)(1-omega^y))
      = R_(x,y,z)(omega).                            (4)

The denominator factors are nonzero because 1<=y<S<=M<r. The numerator
factors are nonzero as well. Equation (3) also shows that these cross-ratios
are not 1.

**Lemma 2.** Two cross-ratios in (4) are equal if and only if their gap
triples agree modulo the reversal (x,y,z)->(z,y,x).

**Proof.** Equality at omega implies E(omega)=0 for

    E(T) = A(T)B'(T)-A'(T)B(T) in Z[T].

Since deg A=deg B=S+y and y<=S-2,

    deg E <= S+y+S'+y'
           <= 4M-4
           <= r-5
           < r-1.                                   (5)

For prime r the minimal polynomial of omega over Q is
Phi_r(T)=1+T+...+T^(r-1), of degree r-1. Its irreducibility follows by
Eisenstein at r after replacing T with T+1: the nonleading coefficients
are divisible by r and the constant term is r, not divisible by r^2.
Consequently (5) forces E=0, not just a congruence after specialization.
The rational functions are equal, so Lemma 1 applies. Conversely, reversal
already gives equality in Q(T), hence equality at omega with all
denominators nonzero. QED.

There are exactly binom(M,3) triples in G_M: the map

    (x,y,z) -> (x,x+y,x+y+z)

is a bijection with increasing triples from {1,...,M}. Reversal is an
involution. Its fixed triples have x=z=a and satisfy 2a+y<=M, so their
number is

    sum_(a=1)^floor((M-1)/2) (M-2a)
      = floor((M-1)^2/4).                            (6)

For M=2k the sum is k(k-1); for M=2k+1 it is k^2. Each nonfixed orbit
has two elements and each fixed orbit one. Lemma 2 therefore gives exactly

    (|G_M|+|Fix|)/2 = N(M)                           (7)

distinct cross-ratios. In particular the stated formula is an integer.

## 4. Proof of the local obstruction

The primitive-residue hypothesis implies p does not divide r. Let zeta
have exact order r in an algebraic closure of F_p and let

    H = {zeta^j: 0<=j<r}.

These are r distinct nonzero elements. Every coefficient of F_p is
divisible by p, and for odd p

    F_p/p = [1-X^p-(1-X)^p]/p = L_p(X) modulo p.

For 1<=k<p the coefficient equality follows from
binom(p,k)/p=binom(p-1,k-1)/k and
binom(p-1,k-1)=(-1)^(k-1) modulo p.
Division of integer coefficients by p commutes with taking the remainder
by the monic polynomial X^r-1. Thus the full local hypothesis gives

    L_p(h)=0 for every h in H.                       (8)

The polynomial L_p is nonzero, of degree p-1. Already (8) gives
p-1>=r>=37, hence p>16. This preliminary degree bound supplies the
characteristic threshold below without circular use of (1).

Reuse the following independently accepted results, with their hypotheses
unchanged:

1. Projective zero propagation: for odd p, vanishing of L_p on H implies
   vanishing at the EVG cross-ratio of every ordered distinct quadruple
   from H [P, Sections 2-3].
2. Exact collision transfer: for prime r>32, prime p>16, and
   ord_r(p)=r-1, the collision relation for any fixed collection of ordered
   distinct root-index quadruples is identical at omega and zeta
   [P, Section 4].
3. The quadratic obstruction under the present local hypotheses is
   p>=r^2+2 [Q, Sections 1-6].

The first two results apply here: odd p is assumed, r>=37>32, p>16 was
just proved, and primitivity is assumed. The index collection in Section 3
is allowed to include the index 0; both accepted lemmas allow every root
of H, including 1. At zeta every denominator remains nonzero by the same
order-r argument used in Section 3. No extension-field argument is replaced
by a prime-field-only identity.

By (7) and collision transfer, the short-arc collection has exactly N(M)
distinct cross-ratios in F_p(zeta). Projective propagation makes all of
them zeros of the single polynomial L_p. The degree bound gives

    p-1 >= N(M).

Combining this with the accepted quadratic obstruction proves (1).
There is no claim that these new zeros are disjoint from any earlier zero
set; no unsupported additive zero count is used.

## 5. Arbitrary cofactors

Under the hypotheses of the corollary, reduction of the full identity
modulo p^2 is valid because p^2|n. The independently accepted necessary
prime-power lifting implication [L, Theorem 1 and Section 3] gives

    F_p = 0 modulo (p^2,X^r-1).

Its hypotheses are p|n, gcd(n,r)=1 and r>=2; it imposes no conditions on
other factors of n. Applying (1), followed by n>=p^2, proves (2).
Necessary arbitrary-cofactor lifting itself is known Kayal-Saxena prior
art, not part of the proposed new contribution.

## 6. Improvement over the strongest accepted bound

The exact count may also be written

    N(M) = (2M^3-3M^2-2M)/24          for even M,
    N(M) = (2M^3-3M^2-2M+3)/24        for odd M.

Since M=r/4+O(1),

    N(M) = r^3/768+O(r^2).                           (9)

Writing B_new(r)=max{r^2+2,1+N(floor((r-1)/4))}, it follows that

    B_new(r) = r^3/768+O(r^2),
    B_new(r)^2 = r^6/589824+O(r^5).                  (10)

These describe necessary thresholds, not existence of solutions attaining
them. Relative to the strongest accepted projective estimate

    B_old(r) = max{r^2+2,1+c*(r-1)^(24/11)}

for its fixed absolute c>0, the threshold ratios satisfy

    B_new(r)/B_old(r) ~ r^(9/11)/(768*c) -> infinity,
    B_new(r)^2/B_old(r)^2
      ~ r^(18/11)/(589824*c^2) -> infinity.           (11)

Thus the prime exponent increases from 24/11 to 3 and the repeated-prime
integer exponent from 48/11 to 6. The new constant is explicit; no value
of Rudnev's c or finite crossover against B_old is assumed. The quadratic
maximum is retained for every r. The unchanged old theorem remains
available in addition to the new bound, so no accepted result is lost.

## 7. Scope, attribution and publication boundary

The scope inputs were the already independently reviewed projective
propagation/collision lemmas, the quadratic obstruction and the general
necessary lift. They are recorded as internal accepted dependencies in
research/MATH_STATE.json. Their original citations and settled independent
attributions remain in their existing claims rather than being re-filed
as new unchecked citations.

The finite-logarithm functional identities are classical EVG results.
The sparse cyclotomic coefficient principle and necessary lifting are
classical inputs. Elementary rational rigidity, monomial coefficient
comparison and involution counting are not claimed independently novel.
The candidate contribution is the explicit cubic one-length obstruction
obtained by counting this faithfully specialized short-arc family. Unlike
the earlier estimate, its new counting step does not use Rudnev's real
cross-ratio expansion theorem.

This is a genuine mathematical improvement over the strongest accepted
campaign bound, not a verified literature originality conclusion. The
prior unresolved comparison with Hegde-Devaraj,
DOI 10.1007/978-981-33-4646-8_42, pp.537-543, especially unread pp.540-541,
is preserved. No new primary access or source-wide non-overlap is inferred.
Independent correctness, statement-fidelity and publishable-significance
assessment of this delta, plus verified originality, remain required for
campaign completion.

### Accepted proof references

- [P] `search/projective-cross-ratio/projective_obstruction.md`, Sections
  2-4; claims `agrawal-projective-zero-propagation` and
  `agrawal-projective-collision-transfer`, version 1, independently accepted
  by `reviewer:copilot-projective-round1`. The cited classical equations
  there are P. Elbaz-Vincent and H. Gangl, *On Poly(ana)logs I*,
  arXiv:math/0008089v1, Proposition 4.9(2)-(3), preprint p.21.
- [Q] `search/cyclotomic-zero-propagation/zero_propagation.md`, Sections
  1-6; claim `agrawal-cyclotomic-zero-obstruction`, version 1, with settled
  independent correctness and statement fidelity in
  `roles/reviewer/progress.json#cyclotomic_zero_propagation_review`.
- [L] `search/non-frobenius-cofactor/obstruction_theorem.md`, Theorem 1 and
  Section 3; claim `agrawal-prime-power-reduction`, version 1, independently
  accepted by `reviewer:copilot-1440c9ee6fc1`. Necessary lifting is credited
  there to Kayal-Saxena, April 2002, Section 5, Lemmas 5.2-5.3.
- The comparison in (11) is with [P], Sections 1 and 5-7, whose real
  cross-ratio input is M. Rudnev, *On distinct cross-ratios and related
  growth problems*, arXiv:1705.01830v1, Theorem 1.

## 8. Exact algebra controls

From the campaign directory, run

    PYTHONDONTWRITEBYTECODE=1 python3 search/short-arc-cubic/verify_short_arc.py

The verifier checks bounded integer-polynomial collision comparisons,
reversal counts, the exact characteristic-zero and characteristic-p
specializations for specified primitive parameters, and the parity
formulas in Section 6. Its finite controls are not a substitute for
Lemmas 1-2 or the universal theorem and do not certify a local solution.

The first run exited 0 in 0.502930 seconds. It checked all 13,332 unordered
pairs including diagonals for M=3,...,10 in the integer polynomial ring,
and all 18,090 such pairs for (r,p)=(37,17),(41,17),(43,19) in the exact
cyclotomic quotients. The respective specialized counts were 50,70,70.
All specialized denominators were nonzero. The exact parity formula was
checked for every M=3,...,10000, and three nonpositive-gap controls were
rejected. No local lifting hypothesis is claimed for these test parameters.
The detailed measured output is `short_arc_checks.json`.

A deliberate boundary control confirms why the arc restriction matters:
at a primitive 37th root, the triples (1,1,1) and (1,34,1) give equal
cross-ratios although their rational functions differ in Q(T). The second
triple has total 36, outside M=9, with its denominator still nonzero.
This is not a counterexample to Lemma 2 and must not be used to broaden
that lemma to unrestricted arcs.

The isolated Argus Jacobian adapter executed the inspected bounded
operation `polynomial.multivariate.factor.compute` on

    (1-a*b)(1-b*c)-(1-a*b*c)(1-b) = b*(1-a)*(1-c).

The exact typed payload and output are `jacobian_gap_payload.json` and
`jacobian_gap_output.json`. The adapter exited 0, with output status
`FACTORIZED`, server version 0.14.0, protocol 2025-11-25, and runtime
283 ms. Substituting a=T^x, b=T^y, c=T^z gives the numerator identity
in (3). The verifier reconstructs the reported factors with exact
rational arithmetic without rerunning the unchanged Jacobian operation.
This atomic algebra result is not the universal classification proof.
