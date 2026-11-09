# Growing moments of shifted truncated divisors

Put \(d_X(n)=\#\{a\in\mathbb N:1\le a\le X,\ a\mid n\}\).
All logarithms below are natural. The fixed-order manuscript lemma and its
approved certificate are not new results. The following strengthens its
quantifier order, not its range of shifts.

## Upper theorem

Let \(c=1/200000\). For every fixed real \(D\ge1\) there is one
\(S_0(D)>e\) such that, simultaneously for all real
\[
 S\ge S_0(D),\qquad 1\le r\le c\frac{\log S}{\log\log S},
\]
all real \(X>0,Y\), and all natural \(N\) satisfying
\[
 \frac{S}{2\log S}\le\log X\le DS,\qquad
 X^{1/2}\le Y\le X,\qquad N\le e^{DS},
\]
one has
\[
 \sum_{1\le h\le Y}d_X(N+h)^r\le Y\exp(S^{1/4}).
\]
In particular, the threshold is chosen before the moment order.

We use the proved **finite** inequality
`OAI.ShortEgyptian.divisor_moment_numeric` from the approved dependency
slice, not `uniform_divisor_moment` at an \(S\)-dependent integer.
Write \(L=\log S\), \(l=\log L\), and
\[
 A_k=\sum_{j\ge0}(j+2)^k(3/4)^j,\qquad
 H=A_0\,\texttt{smallSmoothConst}.
\]
The latter is a finite, nonnegative absolute constant. Its convergence,
and the finite moment inequality, have full proofs in the reused slice.

### An explicit local-factor constant

For every natural \(k\), including zero,
\[
 A_k\le16(4k)^k,                                      \tag{1}
\]
with the usual convention \(0^0=1\). Indeed,
\[
 (j+2)^k\le(j+2)(j+3)\cdots(j+k+1)
           =k!\binom{j+k+1}{k}.
\]
For \(q=3/4\), the nonnegative binomial series is
\(\sum_{j\ge0}\binom{j+k}{k}q^j=(1-q)^{-k-1}=4^{k+1}\).
Deleting its zeroth term gives
\[
 q A_k\le k!4^{k+1}\le k^k4^{k+1}.
\]
Consequently \(A_k\le(16/3)(4k)^k\le16(4k)^k\).
These are inequalities of convergent infinite series, not a finite
numerical extrapolation.

If \(L\ge4000\), \(l\ge1\), and
\[
 1\le k\le\frac{L}{100000l},                          \tag{2}
\]
then \(k\le L\), \(4k\le L^2\), and
\[
 k\log(4k)\le2kl\le L/50000.
\]
Also \(\log16\le15\le L/200\). Taking the exponential in
(1) therefore gives
\[
 A_k\le S^{1/100}.                                   \tag{3}
\]

### Uniform satisfaction of the finite inequality

Its order-dependent hypotheses are exactly
\[
\begin{split}
1600k(1+L)^2&\le S^{1/2},\\
51200 A_k&\le S^{1/20},\\
3200k(1+\log(2(D+1)L))&\le L,\\
8kD(1+L)&\le S^{1/8},\\
128 A_k(1+L)&\le S^{1/4}.                            \tag{4}
\end{split}
\]
All remaining hypotheses depend only on \(D,S\) and fixed constants.
There is a single sufficiently large threshold depending only on \(D\)
for which \(L\ge4000\), \(l\ge1+\log(2(D+1))\), the remaining
hypotheses hold, and
\[
\begin{split}
1600(1+L)^3&\le S^{1/2},&
51200&\le S^{1/25},\\
8D(1+L)^2&\le S^{1/8},&
128(1+L)&\le S^{6/25}.
\end{split}
\]
Such a threshold exists because every fixed power of \(\log S\)
is smaller than every positive power of \(S\) eventually.

Now \(k\le L\) proves the first and fourth inequalities in (4).
Equation (3), together with
\(1/25+1/100=1/20\) and \(6/25+1/100=1/4\), proves the second
and fifth. For the third, use
\[
1+\log(2(D+1)L)\le2l,\qquad
6400kl\le(6400/100000)L\le L.
\]
Thus the finite inequality applies to **every** integer \(k\) in
(2), with no dependence of the threshold on \(k\).

Finally let \(k=\lceil r\rceil\). Since \(r\ge1\),
\(k\le r+1\le2r\), so the asserted range of real \(r\) implies
(2). For each positive \(N+h\), the divisor \(1\) shows
\(d_X(N+h)\ge1\); hence \(d_X(N+h)^r\le d_X(N+h)^k\).
The bijection \(h\mapsto N+h\) identifies the finite intervals
exactly, including real endpoints through \(\lfloor Y\rfloor\).
This proves the upper theorem.

## Infinite obstruction theorem

For \(t=2^m\) with \(m\) tending to infinity, define
\[
 P(t)=\prod_{p\le t}p,\quad S=2t,\quad
 v=\frac{S}{2\log S}=\frac{t}{\log(2t)},\quad
 X=e^v,\quad Y=e^{v/2},\quad N=P(t)-1.
                                                               \tag{5}
\]
Take \(D=1\). For every fixed \(C>1/2\), all sufficiently large
members of (5) violate the upper bound at
\[
 r=C\frac{\log S}{\log\log S}.
                                                               \tag{6}
\]
Thus, in particular, \(C=4\) supplies the requested obstruction.
This does not refute the manuscript, whose order is explicitly fixed.

Here is an elementary proof, including the prime estimates needed for
an infinite family. It invokes no prime number theorem.

First, every prime \(n<p\le2n\) divides \(\binom{2n}{n}\).
For \(t=2^m\), summing over the disjoint dyadic prime bands gives
\[
 \log P(t)\le\sum_{j=1}^m2^{j-1}\log4
             =(t-1)\log4<2t=S.                     \tag{7}
\]
This includes the band containing \(2\). Thus \(N<e^S\).
The remaining admissibility conditions in (5) are immediate for
large \(S\): \(v\) is the exact lower endpoint, \(v\le S\),
and \(Y=\sqrt X\le X\).

Second, for an even integer \(t=2n\), the successive ratios
\(\binom t{j+1}/\binom tj=(t-j)/(j+1)\) show that the central
coefficient is the largest of the \(t+1\) coefficients. Their sum
is \(2^t\), so
\[
 \binom{t}{t/2}\ge\frac{2^t}{t+1}.
\]
Counting multiples of \(p,p^2,\ldots\) in a factorial gives
\(v_p(a!)=\sum_{b\ge1}\lfloor a/p^b\rfloor\): an integer divisible
by \(p^j\) is counted once for each of its \(j\) prime occurrences.
Subtracting the two denominator valuations, the central binomial
coefficient therefore has valuation
\[
 \sum_{a\ge1}
 \left(\lfloor t/p^a\rfloor-2\lfloor(t/2)/p^a\rfloor\right).
\]
Each summand is zero or one and vanishes when \(p^a>t\).
The prime-power contribution to the binomial coefficient is
therefore at most \(t\), whence
\[
 \binom{t}{t/2}\le t^{\pi(t)},\qquad
 \pi(t)\ge\frac{t\log2-\log(t+1)}{\log t}
          \ge a\frac t{\log t}                     \tag{8}
\]
eventually, for the explicit constant \(a=(\log2)/2>0\).
This proves all prime-distribution input used here.

Let \(M=\pi(t)\) and \(k=\lfloor v/\log t\rfloor\).
Each product of \(k\) distinct primes at most \(t\) is a divisor of
\(P(t)\) of size at most \(t^k\le e^v=X\). These products are
distinct: if two were equal, any prime in one subset would divide
the other product and hence one of its prime factors, forcing that
same prime into the other subset. Applying this in both directions
makes the subsets equal. For all sufficiently
large \(t\), \(1\le k\le M\), and
\[
 d_X(P(t))\ge\binom Mk\ge(M/k)^k.                    \tag{9}
\]
The last inequality follows by writing the binomial coefficient as
\(\prod_{i=0}^{k-1}(M-i)/(k-i)\) and comparing each factor
with \(M/k\).

Put \(u=\log t\). Since \(v=t/\log(2t)\),
\[
 \frac{ku}{v}\longrightarrow1,\qquad
 \frac Mk\ge a\log(2t),\qquad
 \liminf_{t\to\infty}
 \frac{\log(M/k)}{\log\log(2t)}\ge1.                \tag{10}
\]
The first limit is the floor error \(0\le v/u-k<1\), with
\(u/v\to0\); the second follows directly from (8) and \(k\le v/u\).
Combining (9)--(10) with \(\log(2t)/u\to1\) gives
\[
 \liminf_{m\to\infty}
 \frac{\log d_X(P(t))}{v\,\log\log S/\log S}\ge1.
                                                               \tag{11}
\]
For (6), this yields
\(\liminf r\log d_X(P(t))/v\ge C>1/2\).
On the other hand,
\[
 \frac{\log(Y\exp(S^{1/4}))}{v}
 =\frac12+\frac{S^{1/4}}{v}\longrightarrow\frac12.
                                                               \tag{12}
\]
The \(h=1\) term alone is therefore strictly larger than the
entire proposed right-hand side eventually. Since \(S=2^{m+1}\)
is unbounded, this proves infinitely many admissible failures,
not merely a list of finite witnesses.

## Scope and comparison

The universal upper theorem and (1) compile under Lean 4.31.0 with
only the standard foundational axioms. The claim-bound replay is
`verify.py`; its persistent compiler record is in `exact_certificate.json`.
The infinite obstruction proof above is a mathematical proof with an
elementary prime-counting argument; finite Python witnesses are separate
checks of its construction, not a substitute for (7)--(12).

The strongest retrieved applicable framework is Nair--Tenenbaum,
*Short sums of certain arithmetic functions*, Theorem 1
(doi:10.1007/BF02392880). Its constants depend on the growth-class and
positive-power interval parameters. Henriot, arXiv:1102.1643v1,
Theorems 1 and 3, makes polynomial-discriminant dependence explicit
but retains these other dependencies. Here even
\(\log Y/\log N\) can be of order \(1/\log S\), while the class
parameter for \(d_X^r\) grows at least as \(2^r\).
Neither displayed theorem supplies the needed simultaneous uniformity.
See `literature/comparison.md` for precise scopes and retrieval limits.

Relative to the approved result, the mathematical improvement is one
threshold for an unbounded interval of moment orders, complemented by
an infinite obstruction on the same growth scale. The constants above
are not asserted optimal. A bounded comparison with retrieved sources
does not establish novelty or publishable significance; these remain
for independent review.

## Replay and finite witnesses

From the campaign root, run

```
$WORKSPACE/argus-live-update/.venv/bin/python research/growing_divisor_moments/verify.py
```

This performs a fresh claim-bound compiler run, the official two
campaign-local checks, and exact rational/integer sanity checks.
`--finite-only` runs only the latter and confers no universal certification.
The finite witnesses round \(X,Y\) to powers of two rather than claiming
to be literal members of (5). They satisfy every manuscript-admissibility
inequality at \(D=1\) and \(r=4\log S/\log\log S\).
At \(S=32,X=128,Y=16,N=30029\), direct divisor enumeration gives
\(\sum d_X(N+h)^8=378054191044\), whereas
\(Y\exp(S^{1/4})<512\) and \(r>8\).
The larger witness uses \(S=512,X=2^{60},Y=2^{30}\) and
\(N=P(256)-1\); its 54 primes yield
\(\binom{54}{7}=177100560\) distinct divisors below \(X\).
The script proves the logarithmic comparisons with exact rational
atanh-series enclosures and a geometric tail bound, not floating point.
