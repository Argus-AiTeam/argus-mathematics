# A primitive-residue obstruction from finite-logarithm zeros

This is a self-contained theorem with independently accepted correctness and
statement fidelity, not a counterexample or a kernel certificate. The settled
review is `roles/reviewer/progress.json#cyclotomic_zero_propagation_review`.
Novelty and publication significance remain unverified. The bounded computations
below challenged the collision count before this proof was developed; they do
not prove the universal assertion.

## 1. Exact statement

For an odd prime p, put

    F_p(X) = (X-1)^p-X^p+1 in Z[X],
    L_p(X) = sum_(k=1)^(p-1) X^k/k in F_p[X].

**Theorem.** Let r>=7 be prime and p be an odd prime such that
`ord_r(p)=r-1`. If

    F_p = 0 in (Z/p^2 Z)[X]/(X^r-1),

then

    p >= r^2+2.                                           (1)

**Corollary.** Suppose n>=2, gcd(n,r)=1 and

    (X-1)^n = X^n-1 in (Z/nZ)[X]/(X^r-1).

If p^2 divides n for an odd prime p with `ord_r(p)=r-1`, then

    n >= (r^2+2)^2.                                       (2)

Neither assertion addresses repeated primes of smaller residue order, split
cyclotomic factors, or squarefree n. In particular it does not prove Agrawal's
conjecture or provide a composite counterexample.

Since r>=7 is prime, r^2+2 is divisible by 3 and exceeds 3. Primality and oddness
therefore round (1) to p>=r^2+4. The proof and comparison use the unrounded
threshold (1).

## 2. Classical identities, with a direct derivation

The finite logarithm and its functional equations are classical, not new
ingredients. The source comparison is Elbaz-Vincent and Gangl, *On
Poly(ana)logs I*, arXiv:math/0008089v1, Proposition 4.9(1)-(2), preprint p.21.
Here is a direct proof of the exact extension-field identities required.

For odd p define the integer polynomial

    D_p(T) = [1-T^p-(1-T)^p]/p.

The numerator has zero constant and leading coefficient and all remaining
coefficients are divisible by p. For 1<=k<p,

    binom(p,k)/p = (-1)^(k-1)/k modulo p,

so D_p reduces to L_p. The numerator is unchanged by T -> 1-T, proving

    L_p(x) = L_p(1-x).                                    (3)

Replacing k by p-k in the defining sum gives, for x!=0,

    L_p(x) = -x^p L_p(1/x).                               (4)

For x not in {0,1}, expand the numerators of

    D_p(x)-D_p(y)
      +x^p D_p(y/x)
      +(1-x)^p D_p((1-y)/(1-x)).

After multiplication by p, every term cancels except
`-(x-y)^p-(y-x)^p`, which is zero because p is odd. Both weighted
substitutions are integer polynomials after clearing their displayed
denominators. Reducing this integer identity modulo p proves

    L_p(x)-L_p(y)+x^p L_p(y/x)
      +(1-x)^p L_p((1-y)/(1-x)) = 0.                      (5)

These identities hold in every characteristic-p field, not merely at arguments
in F_p. In particular the coefficients in (4)-(5) are x^p and (1-x)^p:
they must not be replaced by x and 1-x in an extension field.

## 3. The cyclotomic sparse-relation lemma

Choose a primitive r-th root zeta in an algebraic closure of F_p, and set

    K = F_p(zeta),       H = {1,zeta,...,zeta^(r-1)}.

The Frobenius orbit of zeta has length `ord_r(p)=r-1`: its f-th iterate fixes
zeta exactly when r divides p^f-1. Thus the minimal polynomial of zeta has
degree r-1 and is

    Phi_r(T) = 1+T+...+T^(r-1).

In particular K is a field and contains all of H.

For a polynomial of degree at most r-1, evaluation at zeta is zero if and only
if all of its coefficients are equal in F_p. Indeed it must be a scalar
multiple of Phi_r, and the converse is immediate.

Consider a relation with at most six terms, each a signed element of H.
Collect exponents modulo r to give such a polynomial. There are at most six
occupied positions, so r>=7 leaves an unoccupied position with coefficient
zero. If the relation holds in K, the preceding criterion forces every
coefficient to be zero in F_p.

Consequently an equality of two multisets of at most two elements of H is an
equality of the integer multiplicities at every element: differences lie in
[-2,2], and p is odd. For two multisets of three elements the same statement
holds when p>=5. The sole additional possibility at p=3 is that one whole
triple is concentrated at one element and the other whole triple at a different
element. Section 4 rules out precisely this possibility where it matters.

## 4. Complete collision classification

Define

    A = H,
    B = {1-a : a in H},
    C = {1/(1-a) : a in H, a!=1},
    E = {(1-b)/(1-a) : a,b in H, a!=1, b!=1, a!=b}.

All denominators are nonzero in K. The maps defining A, B and C are injective,
so their sizes are r, r and r-1. Elements of C and E are nonzero; elements
of E are also different from 1.

The following are all six types of cross-set intersection. Each displayed
relation has at most four signed H terms, so the sparse-relation lemma applies
in every odd characteristic.

| Intersection | Necessary relation in H | Why it is impossible |
|---|---|---|
| A and B | 1=a+c | Integer multiplicities cannot match: one term versus two. |
| A and C | 1+ca=c | Again two terms versus one. |
| B and C | ab=a+b | Again one term versus two. |
| E and A | 1+ca=b+c | Since b!=1, matching multisets forces c=1 and then a=b. |
| E and B | b+ac=a+c | Since b!=a, matching forces b=c and then c=1, contrary to b!=1. |
| E and C | a+bc=b+c | Since a!=b, matching forces a=c and then c=1, contrary to the definition of C. |

Here a,b denote the denominator and numerator indices of E, respectively;
c denotes the H index of the other set. In the B-and-C row, a belongs to
the B index and b to the C index.

It remains to classify all collisions inside E. Suppose

    (1-b)/(1-a) = (1-d)/(1-c),

where a,b,c,d are in H excluding 1, a!=b and c!=d. Cross-multiplication gives

    a+d+bc = b+c+ad.                                     (6)

For p>=5 this is an equality of integer multisets. The term a cannot match
b because a!=b, and cannot match ad because d!=1. Therefore a=c. Cancelling
that occurrence leaves

    {d,bc} = {b,ad}.

Since a!=1, d cannot equal ad, so d=b. The ordered pairs are identical.

For p=3, either the same integer-multiset argument applies, or (by the sparse
lemma and the equal total multiplicities) all three left terms coincide at
some x and all three right terms coincide at a different y. The latter means

    a=d=bc=x,       b=c=ad=y.

Thus x=y^2 and y=x^2, whence y^3=1. But y belongs to H, and gcd(3,r)=1,
so y=1. This contradicts b!=1. There is no characteristic-3 collision.

This proves injectivity of the ordered-ratio map and pairwise disjointness of
all four sets, without the local lifting hypothesis. Therefore

    |A union B union C union E|
      = r+r+(r-1)+(r-1)(r-2)
      = r^2+1.                                          (7)

## 5. Propagation and the degree obstruction

All integer coefficients of F_p are divisible by p. Its integer quotient
F_p/p is exactly D_p, so Section 2 gives

    F_p/p = L_p modulo p.

Reduction by the monic polynomial X^r-1 commutes with division of these
coefficients by p. The full-ring hypothesis modulo p^2 consequently implies

    L_p = 0 modulo (p,X^r-1).

Evaluating in K gives L_p(a)=0 for every a in H. By (3), every point of B is
also a zero. For a!=1, the nonzero element 1-a and identity (4) then show that
1/(1-a) is a zero, proving the assertion for C.

Finally take x=a and y=b in (5), with the indices of E. Both are nonzero and
a!=1, so every substitution is legitimate. The three arguments a, b and b/a
belong to H and have zero logarithm. Since (1-a)^p is nonzero, (5) forces

    L_p((1-b)/(1-a)) = 0.

The union in (7) consists of distinct roots of the single polynomial L_p in
the field K. This is not a count of roots in a product ring. Its leading
coefficient is 1/(p-1)=-1, so it is nonzero and has degree p-1. The elementary
field root bound now gives

    p-1 >= r^2+1,

which is (1).

## 6. Transfer to repeated primes: known necessary lifting

This transfer is the previously accepted necessary prime-power implication,
not a novelty claim. See
`search/non-frobenius-cofactor/obstruction_theorem.md`, Theorem 1 and Section 3,
and the already independently read Kayal-Saxena April 2002 report, Section 5,
Lemmas 5.2-5.3. For completeness its short unit-order argument is included.

Let e=v_p(n)>=2 and put

    R = (Z/p^e Z)[X]/Phi_r,       u = X-1.

Since Phi_r(1)=r is a unit, u is a unit in this finite commutative ring.
For gcd(k,r)=1, substitution X -> X^k is an automorphism sigma_k of R:
it permutes 1,X,...,X^(r-1), so Phi_r(X^k)=Phi_r(X)=0 after cyclic reduction,
and its inverse is given by the inverse of k modulo r. The full identity
for n gives u^n=sigma_n(u).

Let t be the order of u. Automorphisms preserve orders, whereas u^n has
order t/gcd(t,n); hence gcd(t,n)=1 and p does not divide t. The two units
u^p and sigma_p(u) have orders dividing t and equal reductions modulo p.
Their quotient has order prime to p and lies in the kernel 1+pR of reduction,
a finite p-group. It must be the identity. Thus F_p is zero in R.

The factors X-1 and Phi_r are comaximal over Z/p^e Z, and F_p(1)=0, so
Chinese remaindering gives F_p=0 in the full cyclic ring modulo p^e, in
particular modulo p^2. The theorem applies, and n>=p^2 proves (2).

## 7. Improvement over the strongest reviewed baseline

The independently reviewed single-length endpoint theorem gives, for these
odd primes r>=7,

    D(r) = r+3+(r-1)*ceil((r+4)/2)
         = (r^2+6*r+1)/2.

The comparison is to D(r), not to the weaker B(r). Under the stated
primitive-residue restriction, writing A(r)=r^2+2, the improvement is

    A(r)-D(r) = (r*(r-6)+3)/2 > 0,
    A(r)/D(r) -> 2,
    A(r)^2/D(r)^2 -> 4.

The exact difference of the unrounded integer thresholds is

    A(r)^2-D(r)^2
      = (3*r^4-12*r^3-22*r^2-12*r+15)/4.

At r=7, D(r)=46 and A(r)=51: the squared thresholds are 2116 and 2601.
Prime rounding gives p>=47 and p>=53, respectively. The new leading quartic
coefficient is 1 rather than 1/4, but only on the specified repeated-primitive-
prime branch. The endpoint theorem's universal coverage remains stronger in
scope, and is retained unchanged.

Equivalently, for a fixed repeated prime p the respective real length cutoffs
are

    D(r)<=p  iff  r<=sqrt(2*p+8)-3,
    A(r)<=p  iff  r<=sqrt(p-2).

For a fixed n on this branch they are

    D(r)^2<=n  iff  r<=sqrt(2*sqrt(n)+8)-3,
    A(r)^2<=n  iff  r<=sqrt(sqrt(n)-2).

Here r>=7 and the square roots are real; integer or prime rounding is a
separate restriction. In both comparisons the new cutoff divided by the old
one tends to 1/sqrt(2). Thus the improvement removes a proportional length
range on this branch, rather than the constant limiting cutoff shift of the
earlier endpoint refinement. This is not a count or density of admissible
primitive prime pairs and does not imply a search-complexity improvement.

There is also a uniform finite-length version. For r>=19, putting t=1/r,

    (A(r)-(3/2)*D(r))/r^2
      = (5/4)*t^2-(9/2)*t+1/4
      >= 1/4-9/38
      = 1/76 > 0.

Hence the unrounded prime threshold is more than 3/2 times the old one, and
the corresponding n threshold is more than 9/4 times the old one, throughout
this restricted range. The dedicated Jacobian rational-enclosure request
checks this last inequality on 0<=t<=1/19; it is an arithmetic comparison,
not a publication verdict or a new obstruction proof.

The inspected operation `polynomial.box.enclosure.compute` completed with
exit 0 through the live Argus adapter, under Jacobian 0.14.0 and protocol
2025-11-25. Its exact payload and typed output are preserved in
`publication_jacobian_payload.json` and `publication_jacobian_output.json`.
The returned sound enclosure is [1/76,183/722], not a claim of the exact range.
Its positive lower endpoint confirms the displayed comparison. A targeted
local check verified source binding, both rational endpoints and the new
cutoff algebra; the unchanged collision and functional-equation controls
were not rerun.

The new `verify_comparison()` function in the native verifier checks the exact
rational polynomial coefficients and leading ratios, with 23 prime-length
samples as controls. Its separate run is recorded in `comparison_checks.json`;
the unchanged collision experiments were not rerun.

## 8. Exact controls and their limits

Run

    PYTHONDONTWRITEBYTECODE=1 python3 search/cyclotomic-zero-propagation/verify_zero_propagation.py

The first run verified 17 primitive cases for prime ring lengths 7 through 31,
including p=3, and 658 extension-field functional-equation substitutions.
Every union had exactly r^2+1 elements. The verifier also checks the original
full cyclic coefficient relation F_p/p=L_p, not just one cyclotomic factor.
Every tested lifting hypothesis was false; there is no witness in this test.

In the split negative control p=43,r=7,zeta=4 in F_43, the union has only 35
elements, not 50. The distinct index pairs (a,b)=(4,41) and (41,4) both give
the ratio 42=-1. This explicitly prevents transporting the collision theorem
to split factors.

The inspected Jacobian operation is `modular.polynomial_identity.compute`.
Its dedicated payload compares (1-z^2)^2 and (1-z)^2 modulo 3, the cross
products of the reversed ordered pairs at r=7. Its scope is formal coefficient
equality, not a universal field or theorem certificate. The residual has degree
less than deg(Phi_7), so a nonzero residual also separates these pairs in
F_3[z]/Phi_7. The initial uppercase variable name was rejected before execution
with INVALID_REQUEST; its payload and exact error remain in
`jacobian_payload.json` and `jacobian_output.json`. The corrected request uses
the canonical lowercase name in `jacobian_canonical_payload.json` and has its
own output file. Adapter errors are not mathematical conclusions. No bounded
adapter result independently verifies Sections 3-6. The corrected run exited 0
under Jacobian 0.14.0, protocol 2025-11-25, and returned
`FORMAL_COEFFICIENTWISE_IDENTITY`, `identical=false`, with residual 2*z+z^4
modulo 3. That degree-4 residual is nonzero in F_3[z]/Phi_7, whose defining
polynomial has degree 6.

## 9. Publication qualification: the residual mathematical contribution

### 9.1. Primary overlap

The comparison in `literature/prior_art_comparison.md` now includes a primary
reading of Lam and Leung, *On vanishing sums of mth roots of unity in finite
fields*, arXiv:math/9605216v1, Theorem 2.6 (printed p.4), its proof and
Remark 2.7 (printed p.5). Under prime-power order and irreducibility modulo p,
they classify unsigned vanishing-sum weights and minimal unsigned sums.
Their proof explicitly derives equality of the cyclotomic coefficients
modulo p. Specializing to m=r supplies precisely the coefficient-equality
ingredient of Section 3. The p identical terms in their minimal-sum
classification explain the characteristic-3 concentrated triples; excluding
those triples for the ratio indices is the particular deduction in Section 4.

Consequently this work cannot claim a new general sparse cyclotomic
relation or minimal-vanishing-sum classification. The possible residual
contribution is the arrangement of the four sets, the collision-free
ordered-ratio map, and its finite-logarithm application yielding (1).
Equivalently, {1-a : a in H, a!=1} has distinct ordered quotients away from
the diagonal. These incidence conclusions are not stated in the Lam-Leung
passages read, but their short derivation from a classical relation theorem
must be assessed as such, not presented as a new cyclotomic foundation.

Elbaz-Vincent-Gangl's extension-field identities and Grohmann's quadratic
ratio-counting methodology are also classical. Grohmann starts from an
initial integer interval in F_p, not H in an extension field; this work does
not improve his theorem on its own hypotheses. Necessary repeated-prime
lifting is already in Kayal-Saxena. None of these known ingredients is
reclaimed as new.

The outstanding chapter is correctly identified as Hegde-Devaraj,
*Heuristics for the Construction of Counterexamples to the Agrawal
Conjecture*, *Mathematical Analysis and Computing* (2021), pp.537-543,
DOI **10.1007/978-981-33-4646-8_42**. The older book/year label in the
comparison note was incorrect. No complete primary chapter was obtained.
In particular pp.540-541 remain unread. An isolated squarefree hypothesis
in Proposition 2 cannot rule out another chapter statement about collisions,
local lifting or a subsuming bound.

### 9.2. What the factors change, and what they do not

The structural scope is an obstruction at one specified cyclotomic length,
with no restriction on the other factors or their multiplicities in n.
Thus it applies to arbitrary mixed cofactors whenever a repeated prime is
primitive modulo prime r>=7, not merely to pure prime powers. On this branch,
the exact quadratic zero count doubles the leading prime threshold and
quadruples the leading integer threshold relative to the strongest reviewed
D(r). Section 7 quantifies the resulting proportional cutoff reduction and
a uniform gain for r>=19. This is a genuine mathematical improvement over
that baseline; it is not just prime rounding or a lower-order endpoint gain.

It does not provide a global nonsquarefree theorem with that leading
constant, say anything about squarefree solutions, establish branch density
or nonemptiness, prove sharpness, improve an algorithm's complexity, or
settle Agrawal's conjecture. The collision statement alone is an incidence
corollary of a classical relation theorem, so the size of the numerical gain
does not itself establish field-level significance.

### 9.3. Exact remaining acceptance deficit

Publication qualification still needs an actual-primary-text comparison with
the complete correctly identified Hegde-Devaraj chapter, and an independent
assessment that the residual incidence corollary plus its restricted
obstruction is an original, field-significant contribution beyond the
Lam-Leung, functional-equation and ratio-counting ingredients. No identical
statement was located in the newly read passages; this is not evidence of
literature-wide absence. Missing source text and the leading factors cannot
be substituted for that assessment.

The accepted correctness and statement-fidelity verdicts remain unchanged.
Neither verified-new novelty, publishable significance nor campaign completion
is asserted. Further unchanged source-access attempts or arithmetic replays
will not close this mathematical publication gap.
