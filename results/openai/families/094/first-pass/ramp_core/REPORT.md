# A signed-dyadic energy theorem, its ramp application, and an exact sharpness family

## Result and scope

All three estimates `above-energy`, `above-projection-error`, and
`above-relative-error` in the staged manuscript follow for **every real
\(p>2\)** under their original hypotheses. We give an explicit constant
in the bound \(C_pH^{p-2}\ell\).
The proof below neither presupposes that estimate nor uses a finite search
as its justification. A general finite-taper theorem follows from the same
argument. An exact example on three actual input points shows that linear
error energy and relative error of order \(1/\ell\) cannot be improved
uniformly for this ramp.

This is a proof of the ramp mechanism, not of the entire dimension-reduction
theorem. The fixed-point choice of weights, the range \(1<p<2\), the
weighted-moment minimax argument, and the later Poisson and clipping
constructions remain outside this result. Independent Reviewer replay,
statement-fidelity review, and any novelty/publication assessment remain
required. No mathematical refutation of these three equations is asserted.

## Hypotheses

Let \(E\) be finite and nonempty, \(\sigma_e>0\), \(\sum_e\sigma_e=1\),
and \(P:\mathbb R^E\to\mathbb R^E\) the orthogonal projection for
\(\langle x,y\rangle_\sigma=\sum_e\sigma_ex_ey_e\).
Assume its maximum absolute row sum is at most \(H\ge1\).
Let \(v:\Omega\to\mathbb R^E\) be measurable, \(Pv=v\), and assume
\[
 \nu(|v_e|>a)=a^{-p}\qquad(e\in E,\ a>0).
\]
The manuscript's finite angular construction
\(v_e(r,t)=rg_e(t)\), \(\sum_t|g_e(t)|^p=1\), with measure
\(p r^{-p-1}dr\) on each angular copy, satisfies these hypotheses.
Zero angular coordinates are allowed. All constants below are independent
of \(|E|\), angular dimension, the ratios of the positive weights, the
input configuration, and the test probability.

The marginal assumption implies, on \((0,\infty)\), magnitude measure
\(p s^{-p-1}ds\): the measures agree on each interval \((a,b]\), since
both give \(a^{-p}-b^{-p}\), and these intervals determine the measure
on each \((1/j,j]\). Any mass at zero is irrelevant. In particular,
\[
 \int |v_e|^2\,1_{\{|v_e|>a\}}\,d\nu
   =\frac p{p-2}a^{2-p}.                                      \tag{1}
\]
No global \(L_2\) assumption on \(v\) or on its lower truncations is made.

Write \(\rho=\sigma\otimes\nu\), and set
\[
 q_p=2^{2-p},\quad
 K_p=\frac{4^{p-1}}{1-q_p},\quad
 D_p=\frac p{p-2},\quad
 C_p=2^{p-1}K_pD_p
     =\frac{8^{p-1}p}{(p-2)(1-2^{2-p})}.                     \tag{2}
\]
These numbers are finite and positive for each fixed \(p>2\); no
endpoint-uniform bound is claimed.

## 1. Universal signed-dyadic cap inequality

For any \(B>0\), \(N\ge0\), and real \(a_0,\ldots,a_{N-1}\) satisfying
\(|a_k|\le B2^k\),
\[
 \left|\sum_{k=0}^{N-1}a_k\right|^p
 \le K_pB^{p-2}\sum_{k=0}^{N-1}2^{(p-2)k}|a_k|^2.            \tag{3}
\]
There are no restrictions on signs or on dependence among the summands.

Here is a full proof, including the small-amplitude boundary. Put
\(S=\sum_k|a_k|\), \(W=\sum_k2^{(p-2)k}|a_k|^2\).
Choose a cut \(m\in\{0,\ldots,N\}\) with
\[
 L:=\sum_{k<m}|a_k|\le S/2,\qquad S\le4B2^m.                 \tag{4}
\]
If \(S\le4B\), take \(m=0\). Otherwise choose \(m\ge0\) with
\(2^m\le S/(2B)<2^{m+1}\).
The geometric cap gives \(L\le B(2^m-1)\le S/2\), and the upper
inequality gives \(S<4B2^m\). Such \(m\) is at most \(N\):
otherwise \(S\le B(2^N-1)<B2^m\le S/2\), a contradiction.

Let \(T=\sum_{m\le k<N}|a_k|\). Then \(T\ge S/2\). Weighted
Cauchy--Schwarz and the geometric sum give
\[
 T^2
 \le\left(\sum_{k=m}^{N-1}2^{(2-p)k}\right)
     \left(\sum_{k=m}^{N-1}2^{(p-2)k}|a_k|^2\right)
 \le\frac{2^{(2-p)m}}{1-q_p}W.                              \tag{5}
\]
Since \(S^{p-2}\le(4B)^{p-2}2^{(p-2)m}\),
\[
 S^p=S^{p-2}S^2
 \le\frac{4(4B)^{p-2}}{1-q_p}W=K_pB^{p-2}W.
\]
The signed sum is at most \(S\) in absolute value. This proves (3),
including \(S=0\) and \(N=0\).

Integrating (3) proves the corresponding theorem on **any measure
space**, including an infinite measure space:
\[
 \int\left|\sum_{k<N} f_k\right|^p d\mu
 \le K_pB^{p-2}\sum_{k<N}2^{(p-2)k}\int |f_k|^2d\mu          \tag{6}
\]
for measurable \(f_k\) with \(|f_k|\le B2^k\).
Finite summation and nonnegative integration justify every exchange;
no integrability of an untruncated increment is needed.

## 2. Checked reduction from the actual projection to (6)

For \(k\ge0\), define exactly as in the manuscript
\[
 A_k=(P-I)v_{\le2^k}.
\]
Since \((P-I)v=0\),
\[
 A_k=(I-P)v_{>2^k}.                                         \tag{7}
\]
The first representation, the row-sum bound, and \(H\ge1\) give
\[
 |A_{k,e}|\le(H+1)2^k\le2H2^k.                              \tag{8}
\]
The second representation and orthogonal contraction of \(I-P\) give
pointwise
\(\sum_e\sigma_e|A_{k,e}|^2\le
  \sum_e\sigma_e|v_e|^2 1_{\{|v_e|>2^k\}}\).
Integrating (1), and using \(\sum_e\sigma_e=1\), proves
\[
 \int |A_k|^2\,d\rho\le D_p2^{(2-p)k}.                     \tag{9}
\]
For completeness, contraction is an algebraic consequence of weighted
orthogonality:
\[
 \|x\|_{2,\sigma}^2
 =\|Px\|_{2,\sigma}^2+\|(I-P)x\|_{2,\sigma}^2.
\]
Thus (9) does not assume the disputed \(L_p\) estimate. In particular,
using the potentially non-\(L_2\) lower truncation to *define* \(A_k\)
does not invalidate the argument.

Linearity and reindexing the finite ramp sum give the exact identity
\[
 Pu-u=\sum_{k=\ell}^{2\ell-1}A_k-\sum_{k=0}^{\ell-1}A_k.     \tag{10}
\]
Apply (6) to these \(2\ell\) signed functions, with \(B=2H\).
Equations (8)--(9) give
\[
 \begin{split}
 \|Pu-u\|_{L_p(\rho)}^p
 &\le K_p(2H)^{p-2}
       \sum_{k=0}^{2\ell-1}2^{(p-2)k}D_p2^{(2-p)k}\\
 &= C_pH^{p-2}\ell.                                       \tag{11}
 \end{split}
\]
All dimensions and weight ratios have disappeared before this step.
This proves `above-projection-error`. For \(\ell\ge1\), replacing
\(\ell+1\) by \(\ell\) alone is not an asymptotic improvement.

## 3. Exact common energy and relative error

On the bin \((2^j,2^{j+1}]\), the multiplicity in \(u_e\) counts the
integers \(k\) with \(0\le k<\ell\), \(k\le j<k+\ell\).
For \(j=0,\ldots,2\ell-2\) these counts are
\(1,2,\ldots,\ell-1,\ell,\ell-1,\ldots,1\); outside these bins the
count is zero. Thus every edge has the same energy
\[
 b=p\log2\left(\ell^p+2\sum_{j=1}^{\ell-1}j^p\right).        \tag{12}
\]
There is no endpoint correction: the magnitude marginal has no atom at
any positive endpoint. Each nonzero bin of multiplicity \(m\) contributes
\(p m^p\int_{2^j}^{2^{j+1}}ds/s=p\log2\,m^p\).
The right Riemann sum for \(x^p\) on \([0,\ell]\), and the trivial
upper bound of \(2\ell\) bins of height at most \(\ell\), give
\[
 \frac{p\log2}{p+1}\ell^{p+1}
 \le b\le2p\log2\,\ell^{p+1}.                              \tag{13}
\]
In particular \(b\ge p\log2>1\), also for \(\ell=1\).
Combining (11)--(13), and recalling that \(\sigma\) is a probability,
\[
 \frac{\|Pu-u\|_{L_p(\rho)}}{b^{1/p}}
 \le\left(\frac{C_p(p+1)}{p\log2}\right)^{1/p}
       \frac{H^{1-2/p}}{\ell}.                             \tag{14}
\]
This proves the exact requested relative-error exponent and rate.

## 4. General finite-taper theorem

Let \(c=(c_j)_{j\in\mathbb Z}\) be any finitely supported real sequence,
extended by zero, and let \(d_k=c_{k-1}-c_k\).
Define
\[
 u_c=v\sum_jc_j1_{\{2^j<|v|\le2^{j+1}\}}
\]
coordinatewise. Then each edge has energy
\[
 p\log2\sum_j|c_j|^p,
\]
and, with \(M=\|d\|_\infty\),
\[
 \|Pu_c-u_c\|_{L_p(\rho)}^p
 \le 2^{p-2}K_pD_p\,H^{p-2}M^{p-2}\sum_k|d_k|^2.           \tag{15}
\]
Indeed finite summation by parts gives
\((P-I)u_c=\sum_kd_k A_k\).
If \(M=0\), finite support forces \(c=0\). Otherwise apply (6) to
\(d_kA_k\), whose caps are \(2HM2^k\) and whose quadratic integrals
are at most \(d_k^2D_p2^{(2-p)k}\).
If the smallest index is negative, shift indices before applying (6).
The factors \(2^{s(p-2)}\) and \(2^{s(2-p)}\) cancel, so the bound is
translation invariant in the scale index. For the triangular ramp,
\(M=1\) and \(\sum_kd_k^2=2\ell\), recovering (11).

## 5. Exact order-sharpness within the manuscript's normalized gradients

Take the actual three points \((0,0),(1,0),(1,1)\) in \(\ell_p^2\).
Orient their three increments along the two consecutive sides and their
sum. Put
\[
 a=2^{1/p},\quad
 g_1=(1,0),\quad g_2=(0,1),\quad g_3=(1/a,1/a),\quad
 n=(1,1,-a),\quad d=2+a^2.
\]
Their normalized-gradient space is \(n^\perp\). Let
\(\sigma_e=1/3\), \(P=I-nn^\top/d\), and use the original two-copy
homogeneous measure \(p r^{-p-1}dr\).
Each row has \(p\)-energy one since \(a^p=2\), and \(Pg(t)=g(t)\).
The displayed \(P\) is exactly the required weighted orthogonal
projection. Its maximum row sum is
\[
 H_p=1+\frac a{2+a^2},
\]
since \(1<a<\sqrt2\); in particular \(H_p\) is bounded independently
of \(\ell\).

Write \(m_\ell(s)\) for the ramp multiplicity. On either angular copy,
\[
 n^\top u(r,t)=r\bigl(m_\ell(r)-m_\ell(r/a)\bigr).
\]
The successive jumps of \(m_\ell\) at
\(1,2,\ldots,2^{2\ell-1}\) are \(2\ell\) jumps of size \(+1\)
or \(-1\). Because \(1<a<2\), the difference
\(m_\ell(r)-m_\ell(r/a)\) is supported on the disjoint intervals
\((2^j,a2^j]\), \(0\le j<2\ell\), and has absolute value one there.
Consequently
\[
 \int_0^\infty|m_\ell(r)-m_\ell(r/a)|^p\frac{dr}{r}
     =2\ell\log a.
\]
Since \(\sum_e\sigma_e|n_e|^p=(2+a^p)/3=4/3\), both angular
copies together give the **exact identity**
\[
 \|Pu-u\|_{L_p(\rho)}^p
   =\frac{16\ell\log2}{3(2+2^{2/p})^p}.                    \tag{16}
\]
Together with the upper bound in (13), this implies
\[
 \frac{\|Pu-u\|_{L_p(\rho)}}{b^{1/p}}
 \ge \left(\frac8{3p(2+2^{2/p})^p}\right)^{1/p}\frac1\ell. \tag{17}
\]
Thus (11) and (14) are order-sharp as functions of \(\ell\), even
on three fixed points and with uniformly bounded \(H\). This does
**not** assert optimality of the power of \(H\), an optimal value of
the constant, or an extremal profile for a fixed support.

### A barrier for every finite dyadic taper, not just the triangular one

The same fixed three points give an exact formula for **every** finitely
supported real profile \(c\):
\[
 \|Pu_c-u_c\|_{L_p(\rho)}^p
   =\frac{8\log2}{3(2+2^{2/p})^p}
       \sum_j|c_j-c_{j-1}|^p.                              \tag{18}
\]
To see this, on \((2^j,a2^j]\) the two coefficient values in
\(n^\top u_c/r\) are \(c_j\) and \(c_{j-1}\); on the complement of
these disjoint intervals they agree. Each interval has logarithmic
length \(\log a\). The calculation giving (16) now gives (18), with
no sign restriction on \(c\). Only finitely many differences are
nonzero, so there is no convergence issue, even for negative scale
indices.

Suppose \(c\ne0\) is supported on \(N\ge1\) consecutive bins.
Starting at the zero value immediately before its support, telescope
each \(c_j\) in at most \(N\) first differences. Finite Holder gives
\[
 |c_j|^p\le N^{p-1}\sum_k|c_k-c_{k-1}|^p.
\]
Sum over the at most \(N\) occupied bin locations to obtain
\[
 \sum_j|c_j|^p\le N^p\sum_j|c_j-c_{j-1}|^p.
\]
Divide (18) by the exact common input energy
\(b_c=p\log2\sum_j|c_j|^p>0\). For this one fixed, admissible
weighted projection,
\[
 \frac{\|Pu_c-u_c\|_{L_p(\rho)}}{b_c^{1/p}}
 \ge \left(\frac8{3p(2+2^{2/p})^p}\right)^{1/p}\frac1N.     \tag{19}
\]
Conversely a triangular profile of support at most \(N\) has
\(\ell=\lfloor(N+1)/2\rfloor\ge N/2\), so (14) gives the matching
order \(O_p(H^{1-2/p}/N)\). Thus a uniform \(o_p(1/N)\) relative
error is impossible for the whole class of finite dyadic scale
multiplier methods on any projection class containing this
\(H=H_p\) example. This is a method barrier, not a lower bound for
arbitrary nonlinear dimension-reduction maps, and not a lower bound
for the special class \(H=1\).

## Evidence boundaries and prior-source comparison

The staged manuscript already asserts the ramp upper bounds. The additions
here are a dimension-free pointwise signed-dyadic certificate that replaces
its tail-integration step, the finite-taper formulation (15), the exact
three-point rate lower bound (16)--(17), and the all-profile identity and
finite-scale method barrier (18)--(19).

The required surrounding electrical localization theorem was read in its
primary version: arXiv:2605.24130v1, Theorem 1.3. See
`LOCALIZATION_SOURCE.md`; its weighted symmetrized statement has exactly
the required \(2\log n\) bound. This does not certify the manuscript's
fixed-point argument, and localization is not an assumption of our ramp
proof once \(P\) is supplied.

A targeted literature lookup also returned arXiv:2610.19010v1. Its
Theorem 1 is an \(\ell^1\)-versus-\(\ell^2\) discrete Poincare inequality
for finite scalar sequences and their higher differences. The primary
statement does not mention homogeneous increments, weighted projections,
or the present exact ramp error. The search service's suggestion that it
already settles this particular sharpness question is not supported by
that statement. It is not used as an assumption here. This bounded lookup
does not establish worldwide novelty; no `verified_new` assessment is
claimed before independent review.

## Reproduction and certification

From the campaign directory:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/ramp_core/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/ramp_core/Main.lean --project-root . --claim C_RAMP_AMPLIFICATION --statement-fidelity research/ramp_core/STATEMENT_FIDELITY.md --timeout 110
```

The installed certification CLI takes its source as a positional argument;
its `verify --help` does not provide `--source`. The actual successful run
used the compatible positional form above. It returned `exit_code=0`,
`proof_holes=[]`, and a successful axiom audit under Lean 4.31.0, and
recorded the mechanical evidence on `C_RAMP_AMPLIFICATION` version 2.
The immutable claim-bound certificate is
`certificates/C_RAMP_AMPLIFICATION-b72ce5d596d27d52.json`.
The tool also publishes `lean_check.json`, the compilation log, and its
canonical lowercase `statement_fidelity.md` alongside the source.
The uppercase input document and canonical document were identical at
certification. Neither document nor `Main.lean` was edited during the run.

`verify.py` uses exact rational arithmetic, prime-factor representations
of logarithms, and symbolic algebra; it does not depend on floating-point
quadrature or a random seed. Its 81 original-hypothesis configurations
include a narrow normalized-gradient triangle with edge probability
\(10^{-24}\) and row-sum bound greater than \(4\cdot10^{11}\).
It also checks all eight edge orientations for one nontrivial case,
zero angular copies, and finite signed taper profiles. The generated
`exact_certificate.json` records these bounded checks separately from
the universal theorem. `--write` regenerates that arithmetic certificate;
the default command independently reconstructs and compares it.

The Jacobian adapter's exact typed discovery, inspected contract, payload,
and output are retained in the four dedicated `jacobian_*.json` files.
The one executed operation was
`matrix.symmetric.rational_spectrum_claim.check`, server 0.14.0,
protocol 2025-11-25. It returned `VALID` for the symmetric rational test
projection \(I-J/3\), with nullities 1 at zero and 2 at one, without an
adapter error or timeout. This certifies only that finite algebraic
operation. The inspected contract does not supply the required
real-exponent integration theorem, so no such capability was inferred
or forced onto it.

The surrounding localization assumption remains independently unchecked
in the citation ledger. It is not a dependency of any ramp proof above,
and no full-manuscript or independent Reviewer acceptance is recorded.
