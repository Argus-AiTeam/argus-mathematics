# Cumulative good-prime products and the combined mechanism

## Assessment and exact scope

**Engineer assessment: the constants, conditioning and cumulative-product
argument are supported.** Together with the finite-deletion, actual-kernels
and patch-height units, they support the old adaptive submechanism. This is
conditional on fixed stage degrees being available from the separately
stated residue-cut input; it is not a proof of that input, the counting tree,
or the density theorem. Independent acceptance remains outstanding.

The exact old claims are:

- **C_ADAPTIVE_PRODUCTS@1:** "With gamma, degree limits, B0, xi, T, zeta and
  finally X chosen in that order, the finite bound gives one block choice
  making at least half the points regular, and at every scheduled step i
  the good cumulative prime product is at least X^(delta_(h_i)+gamma/2),
  uniformly over points and other blocks."
- **C_ADAPTIVE_MECHANISM@1:** "The dependence-sensitive mechanism from the
  actual evaluation kernels through rank records, deletion and cumulative
  good-prime products is valid with the explicit finite-pool error
  D/(n-ell-T+2). This verifies that mechanism only, not the determinant cut,
  counting tree, large-prime tail or density theorem."

Sources are the Argus draft
`9000020/research/adaptive_prime_audit/report.md:321-423` and OpenAI's
*Squarefree values of quartics and power-free values of polynomials*,
September 24, 2026, `03-affine-counting.tex:298-406,473-485`. The separate
residue-cut statement is at lines 169-184. The reference revision is
`4eaee87548250b2682affda7d05d947c05554bae`, and the old draft matches the
preserved snapshot dated `2026-11-06T10:20Z`. This is a review of an existing
Argus reconstruction, not a claim of priority or novelty.

## Hypotheses and order of choices

Fix \(1\le r\le N\), \(\epsilon>0\), the weighted-box and initial geometric
data, and positive \(\delta_h\). Put
\[
h_i=r+1-i,\quad E_h=\max_{h\le s\le r}\delta_s,\quad E_{r+1}=0,\quad
a_i=E_{h_i}-E_{h_i+1}\ge0.
\]
The previous units establish, for any fixed ordinary stage degrees, an
integer record cap \(B_0=\prod_i(M_i+1)\), stable-path equality, and a
nonzero integer full-path product satisfying \(|m|\le X^K\), uniformly
over points and all block choices. In particular, the abstract finite
theorem's integral-\(B_0\) convention is satisfied here.

The old draft chooses
\[
\begin{split}
\gamma&=\min\{1,\epsilon/(16r(r+1))\},\\
\xi&=\min\{1/4,\gamma/[4(E_1+r\gamma)],
                \epsilon/[16N(E_1+2r\gamma)]\},\\
T&=\lfloor8rB_0/\xi\rfloor+1,\qquad
\zeta=\gamma/[2(T+1)],\\
\ell_i&=\lceil(a_i+\gamma)/\zeta\rceil .
\end{split}
\]
All are well-defined and positive. First choose \(\gamma\), then the
successive fixed cut degrees and hence \(B_0,K\); only then choose
\(\xi,T,\zeta,\ell_i\), and finally enlarge \(X\). The source's separate
residue-cut lemma asserts uniform degrees depending on a fixed margin
\(\nu\), patch degree and fixed data, not on prime choices or equation
heights. With \(\nu=\gamma/2\), this permits a finite stage-by-stage
degree schedule, **if that lemma is supplied**. This review does not
re-prove its determinant argument.

For \(\ell_i\le t_i\le\ell_i+T-1\), the ceiling gives
\[
a_i+\gamma\le\zeta t_i
<a_i+\gamma+\zeta T\le a_i+2\gamma.
\]
The strict middle inequality can be replaced by the draft's weak one.
Every size remains fixed as \(X\) grows.

The distinct-prime budget can be \(D=\lfloor K/\zeta\rfloor\). It may
depend on the late choice \(\zeta\), hence on \(T\); this is not a
circularity, because no claim makes \(D\) independent of those constants.
It is independent of \(X\), which is enlarged last.

## Growing pools: the elementary argument checks

The draft avoids relying on an unchecked prime-distribution citation.
For completeness, its stated estimates have the needed strength.
Primes in \((m,2m]\) divide \(\binom{2m}{m}\le4^m\).
Strong induction with \(m=\lceil n/2\rceil\), handling \(n=2\) directly,
gives \(\theta(x)\le4(\log2)x\): for integers \(n\ge3\), the induction
step is bounded by \(6m\log2\le4n\log2\).

For the other direction, the exponent of each prime in the central
binomial coefficient is at most the number of its powers at most \(2n\).
Thus
\[
2n\log2-\log(2n+1)
\le \log\binom{2n}{n}
\le \psi(2n)
=\theta(2n)+\sum_{k\ge2}\theta((2n)^{1/k}).
\]
The last sum is \(O(\sqrt n\log n)\) by the upper estimate, with only
\(O(\log n)\) nonzero terms. Monotonicity then gives the deliberately
weak bound \(\theta(x)\ge(\log2)x/4\) for sufficiently large real \(x\).
Consequently
\[
\theta(32x)-\theta(x)\ge4(\log2)x,\qquad
\#\{p:x<p\le32x\}\ge\frac{4(\log2)x}{\log(32x)}.
\]
Partition into the fixed number \(r\) of disjoint pools. At
\(x=X^\zeta\), every pool grows without bound; the common upper factor
32 suffices. No asymptotic uniformity as \(\zeta\) varies is needed.

Let \(m_{\max}=\max_i(\ell_i+T-1)\) and \(n_{\min}\) be the smallest pool
size. Since all preceding constants are fixed, sufficiently large \(X\)
ensures
\[
n_{\min}\ge m_{\max},\qquad
\frac D{n_{\min}-m_{\max}+1}\le\frac{\xi}{8r}.
\]
The denominator is positive and is exactly the minimum
\(n_i-\ell_i-T+2\), conservatively replaced by a common lower bound.

## Conditional expectation, simultaneous regularity and products

For a fixed point \(z\), let \(b_i\) be the fraction of block \(i\) primes
dividing **at least one of all its full-path minors**. Fixing every other
block, the finite theorem applies uniformly, so
\[
\mathbb E(b_i\mid\hbox{other blocks})
\le (B_0-1)/T+D/(n_i-\ell_i-T+2).
\]
The independent block sampling makes the remaining conditional law the
specified uniform-size/uniform-subset law. Averaging the conditioning
retains this bound; it does not make a full-path minor independent of
its selected primes.

Since \(T>8rB_0/\xi\), Markov and the union bound give
\[
\mathbb P(\exists i:b_i>\xi)
\le\frac r\xi\left((B_0-1)/T+
                         D/(n_{\min}-m_{\max}+1)\right)<\frac14.
\]
No independence between the bad events or between different points is
used. Summing over the original finite \(S\) gives a single block
choice with at least half its points regular. The set used to construct
the evaluation kernels is still the original \(S\), not the regular
subset.

For a regular point and stage \(i\), in each earlier block \(j\le i\)
at least \((1-\xi)t_j\) primes avoid the current parent minor
\(\Delta_{i-1}(z)\), because avoiding *every* path minor implies this.
Disjoint pools prevent double counting. Hence the product of those
distinct primes is at least
\[
\begin{split}
X^{(1-\xi)\zeta\sum_{j\le i}t_j}
&\ge X^{(1-\xi)(E_{h_i}+i\gamma)}\\
&\ge X^{\delta_{h_i}+\gamma/2}.
\end{split}
\]
Here \(\sum_{j\le i}a_j=E_{h_i}\), and
\(\xi(E_{h_i}+i\gamma)\le\xi(E_1+r\gamma)\le\gamma/4\).
In fact the margin is at least \(3\gamma/4\) for \(i\ge1\).
Earlier primes remain eligible even though they helped construct the
parent; the actual-kernel/deletion bridge is precisely what licenses
that adaptivity.

The two auxiliary estimates also follow directly:
\(\gamma r(r+1)\le\epsilon/16\) and
\(N\xi(E_1+2r\gamma)\le\epsilon/16\). They check the stated error
budget, not the unreviewed counting-tree derivation.

## Evidence and concrete boundaries

The single read-only Python replay in
`../finite-deletion/verify_replay.json` exited 0 and matched the entire
old certificate. Its three exact constant regressions, including
\(T=4,608,144,001\) in one case, are in
`../finite-deletion/regression_results.json`. These evaluate rational
formulas; they do not enumerate billions of subsets or replace the
all-parameter argument above. No second replay was performed.

The kernel unit matches the actual full kernels and deterministic
normalization; the height unit matches the manuscript's explicitly
total-component degree convention and derives the uniform budget.
The finite unit supplies the checked human probability bridge plus the
narrower Lean incidence/averaging declarations. Lean does not check the
prime-pool argument, geometric uniformity, actual block construction or
this constant schedule.

The supported conclusion is the dependence-sensitive mechanism with
explicit finite-pool error. A whole affine theorem additionally needs
the residue-cut proof, entire-class cut identification, dimension
induction, branching bounds, exceptional stopping and exponent
accounting. The tail and density need still more inputs. None is
certified by this unit. No novelty or mathematical strengthening over
the old mechanism theorem is established; this assessment clarifies
what its existing argument supports. Native independent review is
required.
