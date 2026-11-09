# Weak boundary flux

**Engineer assessment: supported as a subsequential boundary-flux lemma.**
This is an arbitrary-dimensional analytic argument, not an extrapolation
from the two-dimensional diagnostic.

## Exact claim and source

Old `BH-FLUX@1` is Lemma 2, equations (22)--(25), of the preserved
`9000051/research/boundary-hessian/bridge.md`. Let \(N\) be a positive
Hermitian matrix, smooth in \(D\), continuous and uniformly positive
definite on \(\overline D\), with \(N\in W^{1,2}\) and \(N=I\) on \(S^1\).
There are \(r_\nu\uparrow1\) such that
\[
 \left\langle(\operatorname{tr}N)_r-
                      (\log\det N)_r\right\rangle_{r_\nu}\longrightarrow0.
\]
The average is \(d\theta/(2\pi)\), and derivatives are at interior radii.
There is no assertion of a boundary derivative, convergence at every
radius, or a common eigenbasis.

The same trace/log-determinant comparison and radial argument occur in
OpenAI's September 23, 2026 manuscript, revision
`4eaee87548250b2682affda7d05d947c05554bae`,
`build/sections/hessian.tex`, proof of `hes:trace`, equations
`eq:trace-logdet-error` and `eq:radial-trace-estimate`.
The draft isolates its \(W^{1,2}\) hypotheses as a reusable lemma.
No independent originality claim is justified by that packaging.

## Decisive argument

Jacobi's determinant identity, derived from the determinant polynomial and
the adjugate, gives
\[
 (\operatorname{tr}N)_r-(\log\det N)_r
       =\operatorname{tr}((I-N^{-1})N_r).
\]
This formula is valid without commuting \(N\) and \(N_r\). Uniform
positivity bounds \(N^{-1}\), so the absolute value of the mean is at most
\[
                    C\|N-I\|_{L^2(S^1)}\|N_r\|_{L^2(S^1)} .
\]
Set \(g(r)=\|N_r(r,\cdot)\|_2^2\) and \(E(r)=\int_r^1g(s)\,ds\).
The polar area factor is comparable to one on \(r>1/2\), hence
\(g\in L^1(1/2,1)\). Sobolev absolute continuity on almost every radial
line, its boundary trace \(I\), and Cauchy--Schwarz give
\[
                 \|N(r,\cdot)-I\|_2\le\sqrt{1-r}\sqrt{E(r)}.
\]
Continuity identifies the Sobolev trace with the stated boundary value;
interior smoothness identifies these circle functions at the interior
radii. Thus the error is bounded by
\[
                         C\sqrt{(1-r)g(r)E(r)} .
\]
There are arbitrarily large radii with \((1-r)g(r)\le1\); otherwise
\(\int g\) would dominate the divergent integral \(\int dr/(1-r)\)
on a terminal interval. Select an increasing sequence of such radii.
Since \(E(r)\to0\), the displayed bound tends to zero.

The proof uses only first radial derivatives, trace cyclicity, finite
matrix norms, and the radial Sobolev theorem. It does not differentiate
eigenvectors or use finite numerical tests. The distinction between a
subsequence and all radii is essential: the bridge's area integral
already has a unique limit before this lemma is applied.

## Evidence, dependencies, and limits

The old independent support is
`judgement-BH-FLUX-7f908726a4f4` by
`reviewer:copilot-4ea18baac059`, targeting `BH-FLUX@1` and the same draft.
`judgement-BH-FLUX-89c969ce4952` is the separate Engineer opinion.
The draft's closing assertion that it has no independent Reviewer verdict
is therefore stale for this lemma; it remains true that there is no
kernel proof or current family acceptance.

No external research theorem beyond the elementary Sobolev calculus
explained in the argument is imported, and no new citation is required.
No computation or unchanged checker was rerun, because it would not
test the arbitrary-dimensional limiting assertion. No Lean file exists.

No gap was found in the stated lemma. Removing continuity/trace control,
uniform positivity, or the \(W^{1,2}\) estimate removes specific steps
of this proof; those stronger statements are not certified. In particular,
this result does not construct \(N\), a frame, or a holomorphic family.
It is a component of the literal bridge and its two extensions, not
evidence of canonical ampleness.
