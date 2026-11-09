# A quadratic-exponent signed-rectangle bound

## Statement

Let \(r\geq1\), let \(T\geq5\) be real, and let \(p_1,\ldots,p_r\)
be distinct rational primes in \([T,2T]\), each congruent to \(1\)
modulo \(4\). Choose Gaussian integers \(\alpha_i\) of norm \(p_i\),
and let \(\pi_i\), independently and fairly, be \(\alpha_i\) or
\(\overline{\alpha_i}\). Associates do not affect the assertion.
Put \(P=\prod_i p_i\). For any **fixed** origin-centered rectangle
\(Q\), with arbitrary real orientation and half-lengths
\(R\geq W\geq1\), suppose
\[
 RW\leq P^{1-d},\qquad 0<d<1/4.
\]
Then
\[
 \boxed{\quad
 \Pr\{Q\cap(\prod_i\pi_i)\mathbb Z[i]\ne\{0\}\}
 \leq \min\{1,\;3\exp(-d^2r/32)\}.
 \quad}                                                     \tag{T}
\]
The constants are independent of every displayed parameter, the chosen
factors, and the orientation. There is no lower-size hypothesis.

This improves the \(C\exp(-cd^3r)\) estimate in the staged
`geometry.tex`, `lem:rectangle`, to a quadratic exponent. In particular
the manuscript's conclusion holds with \(C=3,c=1/32,C_0=1\).
This is not a proof of the finite sieve obstruction or of the Gaussian
moat theorem. No false assertion in the rectangle lemma has been found.

## 1. Elementary Gaussian arithmetic

The following standard facts are included to identify every arithmetic
input, rather than assuming an anti-concentration result.
Gaussian division is Euclidean: round the real and imaginary parts of
\(z/w\) to obtain \(q\) with
\(N(z-qw)\leq N(w)/2<N(w)\) for \(w\ne0\).
The Euclidean algorithm gives Bezout identities. Consequently an
irreducible Gaussian integer is prime, and divisibility by pairwise
nonassociate primes implies divisibility by their product.
Norm-\(p_i\) factors are irreducible by multiplicativity of the
integer-valued norm. Factors over distinct rational primes are
nonassociate by their norms.

The two conjugate factors over \(p_i\) are nonassociate. Indeed, if
\(\alpha_i=a+bi\), then \(a,b\ne0\); an association with its conjugate
by \(1\) or \(-1\) would force a coordinate to vanish, while an
association by \(i\) or \(-i\) would force \(|a|=|b|\) and
\(p_i=2a^2\), impossible for \(p_i\geq5\).

For a rational integer \(a\),
\[
 \pi_i\mid a\quad\Longleftrightarrow\quad p_i\mid a.           \tag{1}
\]
The forward implication follows from \(p_i\mid N(a)=a^2\) and
rational primality; the reverse implication uses \(\pi_i\mid p_i\).

A line containing a nonzero Gaussian integer has a primitive integer
direction \(v\), unique up to sign, and its integer points are exactly
\(av\), \(a\in\mathbb Z\). To see the latter, write
\(v=(x,y)\), choose integers \(u,t\) with \(ux+ty=1\), and apply this
identity to a real multiple of \(v\) with integer coordinates.
Both conjugate factors over a single \(p_i\) cannot divide primitive
\(v\): their product would imply \(p_i\mid x,y\).
Thus, if \(I(v)\) is the set of indices for which one of the two
factors divides \(v\), then
\[
 \prod_{i\in I(v)}p_i\leq N(v).                              \tag{2}
\]
Here the product of the eligible factors divides \(v\), so its norm
divides \(N(v)\). No information about the angular distribution of
Gaussian primes is used.

## 2. Fair-bit exponential moment

For all real \(x\),
\[
 \cosh x\leq e^{x^2/2}.                                     \tag{3}
\]
For each integer \(k\geq0\),
\((2k)!\geq2^k k!\): the base case is equality and the inductive
multiplier inequality is
\[
 (2k+2)(2k+1)-2(k+1)=4k(k+1)\geq0.
\]
Comparing the nonnegative terms of the two convergent power series
proves (3) for every real \(x\), not just for finitely many \(k\).

For independent fair bits \(B_i\) and real weights \(a_i\), (3) gives
\[
 \mathbb E e^{\lambda\sum_i a_i(B_i-1/2)}
 =\prod_i\cosh(\lambda a_i/2)
 \leq\exp\left(\lambda^2\sum_i a_i^2/8\right).               \tag{4}
\]
For \(\sum_i a_i^2\leq rL^2\), \(L>0,t>0\), Markov's inequality
and \(\lambda=4t/(rL^2)\) imply
\[
 \Pr\{\textstyle\sum_i a_i(B_i-1/2)\geq t\}
 \leq\exp(-2t^2/(rL^2)).                                   \tag{5}
\]
This proves the fair-bit case of the Hoeffding estimate needed here;
it is not an unverified appeal to a literature theorem.

## 3. Uniform fixed-line tail

Write \(q=d^2r\). For now suppose \(q\geq1\), so
\(dr=q/d>4\). Fix a primitive direction \(v\). Put
\[
 L_\sigma(v)=\sum_{\pi_i\mid v}\log p_i.
\]
By (2) and the fair independent choices,
\[
 \mathbb E L_\sigma(v)
   =\tfrac12\sum_{i\in I(v)}\log p_i\leq\log|v|.             \tag{6}
\]
If \(av\ne0\) is a witness on that line, primality and (1) show
that every missing chosen factor forces \(p_i\mid a\).
Distinctness then gives
\[
 |av|\geq |v|P e^{-L_\sigma(v)}.
\]
But every point in \(Q\) has length at most \(\sqrt2R\), and
\(R\leq P^{1-d}\) because \(W\geq1\). Hence a witness forces
\[
 L_\sigma(v)\geq \log|v|+d\log P-\tfrac12\log2.              \tag{7}
\]
Since \(dr>4\) and \(\log P\geq r\log T\),
\(d\log P>\log2\). Thus (7) exceeds the mean by at least
\[
 t=\tfrac12d\log P\geq\tfrac12dr\log T.
\]
The centered variable in (6) is of the form (4), with weights either
\(\log p_i\) or zero. Take \(L=\log(2T)\leq2\log T\) in (5).
Uniformly in \(v\),
\[
 \Pr\{\text{a witness on }\mathbb Rv\}
 \leq \exp(-d^2r/8).                                      \tag{8}
\]
The direction has not been counted or randomized.

## 4. Nearby bad signs have one common line

Let two bad sign vectors have Hamming distance
\(h\leq dr/4\). The common Gaussian product \(c_*\) has norm
\[
 N(c_*)\geq P/(2T)^h.
\]
For any respective witnesses \(w=c_*u,w'=c_*v\),
\[
 \det(w,w')=N(c_*)\det(u,v)\in N(c_*)\mathbb Z.              \tag{9}
\]
This is the determinant identity for multiplication by a complex
number; its matrix is \(\begin{pmatrix}a&-b\\b&a\end{pmatrix}\).
Rotation of the rectangle preserves the absolute determinant, so
\[
 |\det(w,w')|\leq2RW\leq2P^{1-d}.
\]
As \(2T\leq T^2\), monotonicity of positive real powers gives
\[
 \frac{N(c_*)}{2P^{1-d}}
 \geq\frac{P^d}{2(2T)^h}
 \geq\tfrac12 T^{dr-2h}
 \geq\tfrac12 T^{dr/2}>25/2>1.                             \tag{10}
\]
We used \(dr>4\), \(T\geq5\). Equations (9)--(10) force the
integer determinant to vanish. The same argument for two witnesses
of one sign vector (\(h=0\)) proves that each bad vector has a
unique witness line.

Consequently the bad set is partitioned into finitely many classes
\(S_\ell\), one for each witness line. Finiteness follows because a
bounded rectangle contains finitely many integer points.
By (8) each class has cube mass at most \(e^{-q/8}\), and distinct
classes have Hamming distance strictly greater than \(dr/4\).

## 5. Dimension-free aggregation of separated classes

We prove the stronger replacement for the manuscript's edge-boundary
amplification. Let \(\mu\) be uniform measure on \(\{0,1\}^r\),
\(r\geq1\).

**Two-set inequality.** If nonempty \(A,B\) have Hamming distance at
least \(s>0\), then
\[
 \mu(A)\mu(B)\leq e^{-s^2/r}.                               \tag{11}
\]
Here is a self-contained proof. For a 1-Lipschitz function \(f\)
on the cube, expose its bits in order and let \(M_j\) be its
conditional expectation after \(j\) bits. For each fixed prefix,
pairing equal suffixes shows that the two possible next conditional
expectations differ by at most 1. The increment
\(M_j-M_{j-1}\), conditional on that prefix, is therefore a fair
choice of \(a_j/2,-a_j/2\), with \(|a_j|\leq1\).
Conditional application of (3) followed by the tower property yields
\[
 \mathbb E e^{\lambda(f-\mathbb Ef)}\leq e^{r\lambda^2/8}
 \quad(\lambda\in\mathbb R).                               \tag{12}
\]
This argument does not assume the martingale increments independent.

Take \(f(x)=\operatorname{dist}_H(x,A)\). It is 1-Lipschitz by
the triangle inequality, equals zero on \(A\), and is at least
\(s\) on \(B\). For every \(\lambda>0\), (12) in both directions
gives
\[
 \mu(A)e^{\lambda\mathbb Ef}\leq e^{r\lambda^2/8},\qquad
 \mu(B)e^{\lambda(s-\mathbb Ef)}\leq e^{r\lambda^2/8}.
\]
Multiply and set \(\lambda=2s/r\) to get (11).
The exact optimization identity is
\[
 r\lambda^2/4-\lambda s
   =-s^2/r+(r\lambda-2s)^2/(4r).
\]

**Many-class inequality.** Suppose a finite collection of disjoint
classes \(S_j\) has pairwise distance at least \(s>0\), and
\(\mu(S_j)\leq m\). Let \(b=\sum_j\mu(S_j)\). Then
\[
 b\leq3\max\{m,\ e^{-s^2/(2r)}\}.                          \tag{13}
\]
The case \(b=0\) is immediate. If one class has mass at least
\(b/3\), then \(b\leq3m\). Otherwise accumulate whole classes
until their mass first reaches \(b/3\). Their union \(A\)
has mass in \([b/3,2b/3)\), since the last added class has
mass \(<b/3\). The union \(B\) of all remaining classes has
mass \(>b/3\). Every cross-pair remains at distance at least
\(s\); therefore (11) gives
\[
 b^2/9\leq\mu(A)\mu(B)\leq e^{-s^2/r},
\]
which is the other case of (13).
This is a finite greedy argument for an arbitrary number of classes,
not an enumeration of dimensions or directions.

## 6. Conclusion and small-parameter case

Apply (13) with \(s=dr/4\) and \(m=e^{-q/8}\). Then
\[
 e^{-s^2/(2r)}=e^{-q/32},\qquad e^{-q/8}\leq e^{-q/32},
\]
which proves (T) when \(q\geq1\). If \(0<q<1\), then
\(3e^{-q/32}>1\). For example \(e^x\leq(1-x)^{-1}\) for
\(0\leq x<1\), by termwise comparison with the geometric series,
so \(e^{1/32}\leq32/31<3\). The probability bound is then
the trivial bound 1. Thus (T) holds for every permitted parameter.
Finally \(d^2r\geq d^3r\) because \(0<d<1\), so (T)
implies the manuscript's asserted existential constants.

## Scope, provenance, and limitations

The source being checked is the staged September 26, 2026 manuscript,
`build/geometry.tex`, lines 84--230. Its fixed-line argument and
nearby-witness determinant argument are retained with explicit constants.
The new contribution relative to that source is (13) in their
combination: it replaces the weaker edge-neighborhood iteration and
improves the exponent from cubic to quadratic in \(d\).
The fair-bit and Lipschitz concentration facts themselves are standard,
not claimed as new. Global priority of the Gaussian-prime application
has not been established by the preliminary literature search.

The original proof's edge-boundary iteration is not needed for this
verification. Its use of a fixed-line tail alone would not justify
summing over all primitive directions; that inadequate route is not
used here. No quantitative angular equidistribution, prime-density
theorem, entropy-enrichment conclusion, or Gaussian-moat result is an
assumption of this proof.

The original edge-boundary argument is consistent with the conclusion:
its one-step growth rate is of order \(d^2\), iterated over order \(dr\)
steps. The present two-union argument instead uses the square of the
separation distance divided by the dimension, and so loses no additional
factor of \(d\). There is no claim here that the manuscript's weaker
amplification is invalid.

The guarantee is uniform **for each rectangle fixed before the signs
are sampled**, not simultaneous over all rectangles. The latter is
false even deterministically: for each outcome the product itself has
length \(\sqrt P\); a rectangle whose long axis follows that product,
with \(R=\sqrt P,W=1\), is admissible and contains a nonzero witness.
That observation does not refute the actual manuscript's quantifiers.

The preliminary lookup found standard bounded-differences literature
but no verified prior statement of this particular strengthened
Gaussian-prime bound. A search result is not a priority certificate.
The DOI landing page for Hoeffding's original article returned HTTP 403;
we do not rely on that unread theorem, since (3)--(5) prove the exact
case needed. Gaussian Euclidean arithmetic was proved above; Conrad's
notes are an expository comparator, not an additional hypothesis.
The obtained source is Keith Conrad, *The Gaussian Integers*,
<https://kconrad.math.uconn.edu/blurbs/ugradnumthy/Zinotes.pdf>
(accessed November 5, 2026), retained as
`conrad_gaussian_integers.pdf` with a text extraction alongside it.
Corollary 7.9 states invertibility of nonzero residues modulo a Gaussian
prime; Theorem 7.14 states that the quotient by nonzero \(\alpha\)
has \(N(\alpha)\) elements; Theorem 9.7(ii) states the split
factorization into two nonassociate conjugate primes for \(p\equiv1\bmod4\);
Theorem 9.9 classifies Gaussian primes. These inspected propositions
match the elementary arithmetic used here. No canonical version
identifier for the mutable notes is asserted.
The separately reported public Lean comparator ending in `sorry` was
not inspected in this mission and supplies no evidence here.

`verify.py` and `exact_certificate.json` check the universal algebra
and rational inequalities used in this proof, and explicitly separate
those checks from bounded arithmetic regression examples. They do not
turn this prose proof into a Lean/kernel formalization. Independent
review must check the stated probabilistic and arithmetic arguments,
their quantifiers, and the improvement and priority claims.
