# A projective strengthening of the primitive-prime obstruction

This is a proposed unconditional theorem with a complete prose proof, awaiting
independent Reviewer verification. It is not a composite counterexample, a
kernel-checked formalization, or verified publication qualification. The
finite-logarithm equations, sparse cyclotomic coefficient principle, and real
cross-ratio expansion theorem are classical inputs, not novelty claims.

## 1. Statement and local reduction

For an odd prime p, define

    F_p(X) = (X-1)^p-X^p+1 in Z[X],
    L_p(X) = sum_(k=1)^(p-1) X^k/k in F_p[X].

**Theorem.** There is an absolute constant c>0 such that, for every prime r>=37
and every odd prime p with ord_r(p)=r-1,

    F_p = 0 in (Z/p^2 Z)[X]/(X^r-1)

implies

    p >= max{r^2+2, 1+c*(r-1)^(24/11)}.                 (1)

**Repeated-prime corollary.** If n>=2, gcd(n,r)=1, and

    (X-1)^n = X^n-1 in (Z/nZ)[X]/(X^r-1),

and such a p satisfies p^2|n, then

    n >= max{r^2+2, 1+c*(r-1)^(24/11)}^2
      >= c^2*(r-1)^(48/11).                            (2)

There is no restriction on the other factors or their multiplicities. These
statements do not cover nonprimitive repeated primes, split cyclotomic factors,
or squarefree n, and do not settle Agrawal's conjecture.

Let zeta be a primitive r-th root in an algebraic closure of F_p, and let
H={zeta^j:0<=j<r}. Since p is primitive modulo r, p does not divide r, so these
are r distinct nonzero elements. Every coefficient of F_p is divisible by p,
and

    F_p/p = [1-X^p-(1-X)^p]/p = L_p(X) modulo p.

Division of these integer coefficients by p commutes with reduction by the
monic polynomial X^r-1. The local hypothesis therefore implies L_p(h)=0 for
every h in H. The polynomial L_p is nonzero of degree p-1, so already

    p-1 >= r >= 37,                                    (3)

and in particular p>16. This elementary preliminary bound, not the quadratic
theorem, supplies the characteristic restriction needed below.

## 2. Triangle ratios are zeros

The classical extension-field four-term identity is

    L_p(x)-L_p(y)+x^p L_p(y/x)
      +(1-x)^p L_p((1-y)/(1-x)) = 0,                   (4)

when x!=0,1. It holds in every characteristic-p field, not just F_p
[EVG, Proposition 4.9(2)].

For any three distinct u,v,w in H, put x=v/w and y=u/w. Then x,y,y/x
belong to H, x!=0,1, and the three corresponding logarithms vanish. Since
(1-x)^p!=0, (4) gives

    L_p((u-w)/(v-w)) = 0.                              (5)

Every denominator in this substitution is nonzero. Neither x^p nor (1-x)^p
has been replaced by a base-field weight.

## 3. The strong five-term identity propagates to every cross-ratio

Use the EVG convention

    cr(a,b,c,d) = (a-c)(b-d)/((a-d)(b-c)),
    D(a,b,c,d) = (a-d)(b-c).

For five indeterminates x_1,...,x_5, omit an entry without changing the order
of the others. Write q_i for the cross-ratio and D_i for its denominator after
omitting x_i. The strong classical identity is

    sum_(i=1)^5 (-1)^i x_i^p D_i^p L_p(q_i) = 0        (6)

as a polynomial identity over every characteristic-p field for odd p
[EVG, Proposition 4.9(3)]. The weak identity lacks the factor x_i^p and is
not the coefficient extraction used here.

To interpret (6) without undefined rational substitutions, write

    Q_p(N,D) = sum_(k=1)^(p-1) N^k D^(p-k)/k.

This is homogeneous of degree p, and equals D^p L_p(N/D) whenever D!=0.
Thus (6) means its denominator-cleared polynomial identity, including at
values where a displayed rational cross-ratio would not be defined.

Fix distinct a,b,c,d in H, and substitute

    (x_1,x_2,x_3,x_4,x_5) = (a,b,c,d,t).

For i<=4, let (u_i,v_i,w_i) be the ordered remaining triple of finite entries.
Then

    N_i(t) = (u_i-w_i)(v_i-t),
    D_i(t) = (u_i-t)(v_i-w_i).

Both are linear in t. Homogeneity gives the exact coefficient

    [t^p] Q_p(N_i(t),D_i(t))
       = -(v_i-w_i)^p L_p((u_i-w_i)/(v_i-w_i)),         (7)

because p is odd. Each v_i-w_i is nonzero. The omitted-t term of (6) is
-t^p D(a,b,c,d)^p L_p(cr(a,b,c,d)). Taking the coefficient of t^p in the
polynomial identity consequently gives

    D(a,b,c,d)^p L_p(cr(a,b,c,d))
      =  a^p(c-d)^p L_p((b-d)/(c-d))
        -b^p(c-d)^p L_p((a-d)/(c-d))
        +c^p(b-d)^p L_p((a-d)/(b-d))
        -d^p(b-c)^p L_p((a-c)/(b-c)).                  (8)

All four logarithms on the right vanish by (5), and D(a,b,c,d)!=0. Hence

    L_p(cr(a,b,c,d)) = 0                               (9)

for every ordered distinct quadruple from H. This is coefficient extraction
from a polynomial, not an unlicensed evaluation at a point at infinity.

## 4. Exact transfer of cross-ratio collisions

The following statement does not need the local logarithm hypothesis.

**Collision-transfer lemma.** Let r>32 be prime, p>16 be prime, and
ord_r(p)=r-1. Let omega be a primitive r-th root over C and zeta a primitive
r-th root in characteristic p. For any two ordered quadruples of distinct
indices modulo r, their EVG cross-ratios at omega are equal if and only if
their EVG cross-ratios at zeta are equal.

For indices (i,j,k,l) and (i',j',k',l'), equality is equivalent to vanishing
of the following denominator-cleared expression:

    E(T) =
       (T^i-T^k)(T^j-T^l)(T^i'-T^l')(T^j'-T^k')
      -(T^i'-T^k')(T^j'-T^l')(T^i-T^l)(T^j-T^k).

Reduce every exponent modulo r, giving

    E_bar(T) = sum_(s=0)^(r-1) e_s T^s in Z[T].

Each of the two products has sixteen signed contributions, eight positive
and eight negative. Their difference therefore has at most thirty-two
contributions in total, at most sixteen of either sign. Consequently

    |support(E_bar)| <= 32,       |e_s| <= 16.           (10)

Since r>32, at least one coefficient is zero.

In characteristic p the Frobenius orbit of zeta has length r-1, so its minimal
polynomial is Phi_r(T)=1+T+...+T^(r-1). If E_bar(zeta)=0, its degree bound
forces all e_s to be equal modulo p. The zero coefficient forces every e_s
to be zero modulo p. By |e_s|<=16<p, all are zero as integers, and thus
E_bar(omega)=0.

Conversely, Phi_r is the minimal polynomial of omega over Q. For prime r,
its irreducibility follows, for example, by Eisenstein at r after replacing
T by T+1. If E_bar(omega)=0, the same degree bound forces all its rational
coefficients to be equal; the zero coefficient forces them all to be zero.
It follows that E_bar(zeta)=0.

All denominators are products of differences of roots with distinct indices,
and are nonzero in both fields. Clearing them introduces no false equality.
This proves the lemma.

In particular, for any fixed collection of allowed index quadruples, the
equivalence relation "has the same cross-ratio" is identical in both fields.
The two cross-ratio sets therefore have exactly the same cardinality.
No embedding of a positive-characteristic field into C is asserted. The
underlying sparse coefficient principle is classical; the proof above spells
out the support and coefficient thresholds required by this application.

## 5. A finite real set, not a finite-field incidence theorem

Let H_0={omega^j:1<=j<r}, excluding the root 1. The Mobius map

    M(z) = i*(1+z)/(1-z)

is defined on H_0. For |z|=1, z!=1,

    conjugate(M(z)) = -i*(1+z^(-1))/(1-z^(-1)) = M(z),

so A=M(H_0) is a finite subset of R. Its size is exactly r-1, since the map
has determinant 2i!=0 and is injective where defined. Also

    M(z)-M(w) = 2i*(z-w)/((1-z)(1-w)),

which proves cross-ratio invariance directly by cancelling the four
denominator factors. Thus the EVG cross-ratio sets of H_0 and A coincide.

Rudnev uses the convention

    [a,b,c,d] = (a-b)(c-d)/((a-c)(b-d))

and C[A] contains all values from ordered pairwise distinct quadruples.
Precisely,

    cr_EVG(a,b,c,d) = [a,c,d,b]_Rudnev.

Permuting all allowed ordered quadruples therefore identifies the two
cross-ratio sets. Since |A|=r-1>=36, Rudnev's real Theorem 1 applies and gives
an absolute c>0 with

    |C[A]| >= c*|A|^(24/11) = c*(r-1)^(24/11).          (11)

This real bound has no logarithmic loss. The complex version in that source
has a logarithmic loss and is not the estimate used here. No real incidence
theorem has been applied directly over a finite field.

## 6. Degree bound and repeated-prime transfer

Apply the collision-transfer lemma to index quadruples excluding 0.
Its hypotheses hold by r>=37, primitivity, and (3). Equations (9) and (11)
therefore provide at least c*(r-1)^(24/11) distinct roots of L_p in the single
field F_p(zeta). The nonzero degree-p-1 polynomial satisfies

    p-1 >= c*(r-1)^(24/11).                            (12)

The independently accepted local obstruction gives p>=r^2+2 under the same
hypotheses [Baseline]. Combining it with (12) proves (1). Its proof is not
rerun or reclassified here.

The independently accepted arbitrary-cofactor necessary lifting implication
says that the full identity for n with p^2|n forces the stated local identity
for p [Baseline, Section 6; Kayal-Saxena's necessary lifting is known prior
art]. Hence n>=p^2 and (1) prove (2). This does not remove the repeated-prime
or primitive-residue restrictions.

## 7. Improvement, classical overlap, and remaining publication boundary

Relative to the strongest accepted primitive-branch baseline p>=r^2+2, the
new contribution proposed here is an exponent increase from 2 to 24/11 at p,
and from 4 to 48/11 at n. For fixed c>0 the second term eventually exceeds
the quadratic term, since

    c*(r-1)^(24/11)/r^2 ~ c*r^(2/11) -> infinity.

No numerical value for Rudnev's absolute constant or crossover is asserted.
The result retains the old bound at every admissible r, rather than asserting
an improvement for small r from an unspecified constant.

EVG already proves the extension-field four- and five-term identities.
Lam-Leung already supplies the classical cyclotomic coefficient-equality
foundation; this manuscript does not claim that principle as new. Grohmann's
finite-logarithm ratio-counting methodology and Kayal-Saxena's necessary
lifting are also known. Rudnev already supplies the exponent 24/11 for
real cross-ratios. The proposed research contribution is their specific
projective zero-set and faithful collision-transfer coupling for this
primitive-prime local obstruction, not a new incidence theorem.

The bounded primary-source reader identified no proposition applying real
cross-ratio expansion to these cyclotomic finite-logarithm zeros in the
passages read. That is not verified novelty. The complete Hegde-Devaraj
chapter, DOI 10.1007/978-981-33-4646-8_42, including pp.540-541, remains unread.
Independent originality comparison and publishable-significance assessment
are still required. An exponent improvement is a mathematical comparison,
not a substitute for either publication verdict.

### References actually used

- [EVG] P. Elbaz-Vincent and H. Gangl, *On Poly(ana)logs I*,
  arXiv:math/0008089v1, Proposition 4.9(2)-(3), preprint p.21.
- [Rudnev] M. Rudnev, *On distinct cross-ratios and related growth problems*,
  arXiv:1705.01830v1, definition (1) and Theorem 1, preprint pp.1-2,
  specifically the real bound.
- [Baseline] `search/cyclotomic-zero-propagation/zero_propagation.md`,
  independently accepted theorem and necessary lifting, Sections 1-6.
  Prior-art limitations and the accepted D(r) comparison are recorded in
  its Section 7 and `literature/prior_art_comparison.md`.

The accompanying exact algebra controls check the new identity (8), reject
base-field substitution for its p-th-power weights, and check collision
relations under the actual support and characteristic thresholds. These
finite controls are not the universal proof above and are not witnesses.

From the campaign directory, rerun them with:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 search/projective-cross-ratio/verify_projective.py
```

The first run exited 0: equation (8) was checked as an exact polynomial
identity over F_p[a,b,c,d] for p=3,5,7,11, including rejection of the incorrect
base-field weights. The 7,560 cleared collision controls use (r,p)=(37,17),
(41,17),(43,19); they test the collision lemma, not the local lifting
hypothesis. There are 5,040 specified equal pairs and 2,520 specified unequal
pairs. Five invalid-parameter or undefined-cross-ratio controls were rejected.
These finite parameter choices do not certify any local solution.

The bounded Jacobian operation `polynomial.multivariate.factor.compute`
independently factors the minor N-D=(a-b)(c-d). Its exact payload and typed
output are `jacobian_minor_payload.json` and `jacobian_minor_output.json`;
the verifier reconstructs the factors using rational arithmetic without
invoking Jacobian again. The adapter exited 0 with status `FACTORIZED`,
server 0.14.0, protocol 2025-11-25, and runtime 283 ms. This atomic algebra
check is not the universal obstruction proof. The new controls are recorded
in `projective_checks.json`; unchanged baseline controls were not rerun.
