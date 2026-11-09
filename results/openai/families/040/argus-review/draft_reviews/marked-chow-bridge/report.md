# marked-chow-bridge

**Assessment: supported within the stated rational-Chow scope, conditional
on the disclosed standard geometry.** It does not prove the whole manuscript.

## Exact statement and attribution

`C40_BRIDGE`, version 1:

> Proposition prop:universal: the actual fiber expression for all n_1,n_2
> >= 0 is c_*[Delta_X] plus external products, with the fixed selected c_*
> determined by rel:numerical-data and zero at (0,0), including irregular
> surfaces with chi(O_X)=1.

The source is OpenAI, *Bloch's conjecture for surfaces with \(p_g=0\)*,
September 24, 2026, `relation.tex`, `prop:universal`, at manifest revision
`4eaee87548250b2682affda7d05d947c05554bae`. The assessed Argus draft is old
`REPORT.md`, Sections 1 and 3-8. The manuscript already contains the
retained-output recursion, closure argument and graph selection. This is
a reconstruction/verification with computational supplements, not a
verified-new theorem or a novelty claim.

Let \(X\) be smooth connected projective over \(\mathbb C\), with
\(\chi(\mathcal O_X)=1\). For all \(n_1,n_2,p\geq0\), use exactly the
specified lines, \(D_1=T,D_2=H\), \(m_i=D_i(D_i-K)/2\), Euler convention,
weights \(w_1=1/2,w_2=-1/2\), and coefficient-extraction order. Put
\[
R_X=\mathbb Q[1,K,c_2(T_X),L_1,L_2,T,H]\subset CH^*(X)_{\mathbb Q}.
\]
Then the literal `rel:fiber-contribution` has
\[
C_*(T,H;n_1,n_2)=c_*[\Delta_X]+\Gamma_*,
\qquad \Gamma_*\in\sum_{a+b=2}R_X^a\boxtimes R_X^b.
\]
The fixed selected \(c_*\) depends only on the integer parameters, weights,
\(\int c_2(T_X)\), and the listed line-pair intersections. Negative \(m_i\)
mean zero. Effectivity is needed to realize a virtual contribution, not
to form this expression. Uniqueness on a particular surface is not claimed.

## Why the proof supplies arbitrary lengths

`ext-integrand-closure` proves that the complete displayed expression
becomes a finite admissible polynomial after the precise extraction and
intrinsic-degree truncation. It includes both ordered relative Ext
denominators, the fixed Euler factors, and both insertions.

`marked-reduction`, based on `nested-pushdown` and `chow-calculus`, lowers
the actual sum of lengths by one per step. It leaves both outputs
unintegrated, uses perfect derived operations on collisions, and closes in
the same input class. It terminates for every pair of nonnegative lengths,
not merely the tested pairs.

`graph-coefficient` evaluates the resulting decorated equality graphs,
including all excess edges. Separated outputs give external products;
connected outputs give a scalar times the diagonal in codimension two.
The scalar is selected formally before surface relations are evaluated.
At \(n_1=n_2=0\) there are no residual slots or incidence edges joining the
outputs, so the selected scalar is zero, even if the external class is
nonzero for other parameters.

No step requires \(p_g=q=0\), the diagonal to be independent of external
products, or cohomological projectors. Irregular surfaces with
\(\chi(\mathcal O_X)=1\) are therefore genuinely included. The proof does
not derive a retained-output Chow identity from scalar numerical EGL
universality.

## Strongest prior evidence and acceptance boundary

The strongest legacy result is the mature prose proof with Engineer and
Reviewer `supports` judgements on this claim and its five prerequisites.
It is stronger than the old report's pending label or the graph's still
open labels suggest. Those labels are reconciled as different records,
not silently rewritten. The exact certificate's pending-review field is
hardcoded metadata that the verifier compares, not a live acceptance flag.

The current review adds exhaustive coverage, exact source/version
comparison, qualified source readings and a fresh unchanged nine-case
replay. It does not mathematically strengthen the already supported
arbitrary-length claim. Source precision is improved at the general
projection formula, and the selected/unique coefficient distinction is
made explicit.

The executable checks finite arithmetic; no listed Lean source or kernel
formalization exists. Neither it nor this bridge supplies compatible
based-determinant obstruction theories, fixed virtual classes and
multipliers, positivity, or the integral Bloch conclusion. Those precise
obligations are assessed in `manuscript-frontier`. The present family
acceptance belongs only to the Host-invoked independent Reviewer.
