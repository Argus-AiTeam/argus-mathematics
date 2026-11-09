# Box mean: supported self-contained fixed-dimension proof

**Assessment.** `L026_BOX_MEAN` v1 is supported by its truncation argument, including vanishing local factors. The elementary cutoff modification removes the manuscript proof's use of the PNT; it does not refute that proof or establish novelty.

## Exact assertion and source

Context: `CTX026_MOMENTS` v1. For each fixed integer \(s\ge0\) and fixed \(K\ge1\), let \(I_1,\ldots,I_s\) be intervals of \(h\) consecutive integers contained in an interval of diameter at most \(Kh\). As integer \(h\to\infty\),
\[
 h^{-s}\sum_{\substack{a_i\in I_i\\a_1,\ldots,a_s\ {\rm distinct}}}
 \mathfrak S(\{a_1,\ldots,a_s\})
 =1+O_{s,K}(1/\log\log h)
   +O_s(h^{-1/2}(\log\log h)^{A_s}).
\]
Here \(A_s\) is finite and depends only on \(s\); the bound is uniform over the intervals. The normalization is by \(h^s\), not a conditional distribution chosen after removing repeated tuples. Cases \(s=0,1\) are exact. No uniformity for increasing \(s\) or \(K\) is claimed.

Inherited source: `families/026/first-pass/audit026/moments/verification.md`, section 6. Compare manifest-matched OpenAI revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/03-moments.tex`, `lem:singular-average`. The manuscript calls this a box form of Gallagher's mean and gives its own proof. This assessment relies on the displayed proof, not an unchecked theorem citation to Gallagher.

## Decisive argument

Use \(y=(\log h)/16\) and \(Q=\prod_{p\le y}p\). The binomial estimate
\(\theta(2n)-\theta(n)\le2n\log2\), summed dyadically, gives \(\theta(y)\le4(\log2)y\). Consequently
\[
 Q\le h^{(\log2)/4}\le h^{1/2}
\]
for large \(h\), without prime-distribution asymptotics. The manuscript instead uses \(y=(\log h)/4\) and PNT to get the same needed bound. Changing the cutoff by a fixed factor does not change the stated error.

Define the truncated series on **all** tuples, keeping exponent \(-s\) even if numerical coordinates coincide:
\[
 S_y(\mathbf a)=\prod_{p\le y}(1-\nu_p(\mathbf a)/p)(1-1/p)^{-s}.
\]
For independent uniform residues and an independent uniform \(x\bmod p\),
\[
 \mathbb E(1-\nu_p/p)
 =\Pr(a_i\ne x\text{ for every }i)=(1-1/p)^s.
\]
CRT therefore gives exact truncated mean one modulo \(Q\). A length-\(h\) interval differs from uniform modulo \(Q\) in total variation \(O(Q/h)\); the product of fixed \(s\) distributions differs by \(O_s(Q/h)\). Since
\(0\le S_y\ll_s(\log y)^{A_s}\), the discrepancy is at most
\(O_s(h^{-1/2}(\log y)^{A_s})\). At most \(O_s(h^{s-1})\) tuples have equal coordinates, so removing them costs only
\(O_s(h^{-1}(\log y)^{A_s})\) after normalization.

For distinct coordinates set \(\Delta=\prod_{i<j}|a_i-a_j|\), so
\(\log\Delta\le\binom{s}{2}\log(Kh)\). For \(y>2s\), all tail factors are positive. Collision-free primes have logarithms \(O_s(p^{-2})\); collision primes divide \(\Delta\) and contribute \(O_s(1/p)\). Thus
\[
 |\log T_y|
 \ll_s\frac1y+\sum_{\substack{p>y\\p\mid\Delta}}\frac1p
 \le C_s\left(\frac1y+\frac{\log\Delta}{y\log y}\right)
 =O_{s,K}(1/\log\log h).
\]
The middle inequality follows by bounding \(1/p\le\log p/(y\log y)\) and summing \(\log p\le\log\Delta\). Therefore \(T_y=1+O_{s,K}(1/\log\log h)\), uniformly.

Finally \(S=S_yT_y\), including when a small-prime factor makes \(S_y=0\). There is no division by \(S_y\). Its nonnegative truncated mean transfers the uniform tail estimate to the asserted full mean. Absolute translations of the intervals are irrelevant; only differences and their common diameter enter.

## Evidence and limitations

Inherited reviewer judgement `judgement-L026_BOX_MEAN-be770cb1e4d2` supports the current claim identity and the snapshot-matched prose. There is no Lean formalization or numerical experiment purporting to prove this result; its decisive estimates were checked directly here.

When the weight proof uses an internal prime mark, its ordered \((j+1)\)-tuple sum is over the original interval \(I\). It must not invoke this lemma on the punctured noninterval \(I\setminus\{a\}\) without that reformulation; the inherited prose explicitly supplies it.

**Remaining obligations.** No mathematical gap was identified for fixed \(s,K\). Growing-dimensional means, prime counts in the intervals, literature novelty, and the full prime-gap theorem are outside this result. Native independent assessment of this prose remains required.
