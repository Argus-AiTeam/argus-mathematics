# Universal Fourier-field verification and a compact-character corollary

## Result and scope

**Theorem.** Every assertion `fields:unitary`, `fields:gram`, and
`fields:sparsity` in the staged manuscript's `build/sections/04-fields.tex`
holds with its stated hypotheses and its positive-phase Fourier convention.
In particular, for all integers n,k,s,L with k,s,L>=1 and k+s<=2^n, all
0<=r<1, and every complex unitary V=[A B; C D] with ||D||<=r, the
feedback F is unitary,

\[
 FE^*=R^*V,\qquad
 (1-r^{2L})I\preceq\mathcal E_L^*\mathcal E_L\preceq I,\qquad
 (1-r^{2L})I\preceq\mathcal R_L^*\mathcal R_L\preceq I.
\]

Both Fourier matrices have at most L nonzero entries per row, and

\[
 \|\widetilde F\mathcal E_L-\mathcal R_LV\|
 \le {2r^L\over1-r}.
\]

This is a universal proof, not an extrapolation from finite tests.
`Main.lean` formally certifies the load-bearing ordered algebra,
feedback identities, moment-code injectivity, and both signed full-row
support bounds. Its exact coverage and its analytic exclusions are stated
in `statement_fidelity.md`. The resolvent, character-orthogonality, norm,
and matrix-path bridges below are prose proofs requiring independent review.
No false literal manuscript assertion was found in these three results;
no `F_` refutation claim is warranted by this audit.

The initial ledger had no evidence and only an open campaign objective.
The advance is a source-matched universal verification of Section 04,
plus the compact-character corollary in Section 6 below. It does **not**
verify the full Boolean-oracle synthesis theorem: contraction, clean
encoding, recursion, and phase-sensitive compilation remain open.
Independent acceptance, significance, and novelty assessment are pending.

## 1. Stable feedback, with no reordered products

Fix any diagonal unitary Z; in fact the feedback argument only needs Z
unitary. Put X=(I-DZ)^(-1)C. The inverse exists because
||DZ||<=r<1: the norm-convergent geometric series is a two-sided inverse,
as multiplying either side leaves the remainder (DZ)^m tending to zero.
Its norm is at most 1/(1-r).

Set F=A+BZX, E=[I;ZX], O=[F;X]. Direct multiplication gives VE=O.
For every port vector u, unitarity of V and Z gives

\[
 \|u\|^2+\|Xu\|^2=\|Eu\|^2=\|Ou\|^2
 =\|Fu\|^2+\|Xu\|^2.
\]

Thus F*F=I. A square finite matrix with a left inverse is invertible,
so also FF*=I. Define R=OF*=[I;Y], Y=XF*.
The equation V*R=EF* follows by multiplying VE=O by V* and F*.
Its adjoint is exactly FE*=R*V, not its transpose or its conjugate.
The bottom block reads

\[
 B^*+D^*Y=ZY,\quad
 (I-Z^*D^*)Y=Z^*B^*,\quad
 Y=(I-Z^*D^*)^{-1}Z^*B^*.
\]

Here ||Z*D*||<=r makes the second inverse legitimate. No step moves Z
past D. `block_feedback_algebra` proves the whole algebraic argument
from the block feedback equation, and `backward_resolvent_algebra`
proves its last implication given the inverse.

## 2. Finite phase separation and the two exact Gram defects

Let q=ceil(log_2(L+1)), N=2^(nL+q), and write
z=(t,z'), with t in Z/N. Since 2^q>=L+1, N>L.
With omega=exp(+2 pi i t/N), the source's phases satisfy Z=omega Z'.
For integers a,b between 0 and L,

\[
 {1\over N}\sum_{t=0}^{N-1}\omega^{a-b}=\mathbf1_{a=b}.
\]

Indeed, for a!=b the ratio exp(2 pi i(a-b)/N) is not one;
multiplying its finite geometric sum by one minus the ratio gives
1-exp(2 pi i(a-b))=0. The same argument applies to the degrees
0,-1,...,-L. This is finite, exact orthogonality, not continuous
averaging or a sampling approximation.

Define W=DZ'. The forward lower coefficients at degrees j+1 are
Z'W^j C. The identity VV*=I gives CC*=I-DD*=I-WW*.
Consequently the common-phase Gram is block diagonal, with port block I
and internal block

\[
 Z'\left[\sum_{j=0}^{L-1}W^j(I-WW^*)(W^*)^j\right](Z')^*
 =I-Z'W^L(W^*)^L(Z')^*.
\]

The cancellation is term by term:
W^j(I-WW*)(W*)^j=W^j(W*)^j-W^(j+1)(W*)^(j+1).
It does not require W normal.

For the backward field use **W=(Z')*D*** and C0=(Z')*B*.
Its coefficients have degree -(j+1). Now V*V=I gives

\[
 C_0C_0^*=(Z')^*(I-D^*D)Z'=I-WW^*.
\]

Thus the internal Gram is I-W^L(W*)^L. Using W=D*(Z')*
instead would not justify this defect equation in general.
`forward_gram_defect` and `backward_gram_defect` formalize the distinct
ordered expressions, while `orthogonal_gram` formalizes the finite
orthogonal-coefficient expansion.

For either choice, Q=W^L satisfies ||Q||<=r^L. For every vector v,

\[
 0\le\langle v,QQ^*v\rangle=\|Q^*v\|^2
 \le r^{2L}\|v\|^2.
\]

Unitary conjugation by Z' preserves this inequality. Averaging over z'
preserves inequalities of quadratic forms. Finally, the field maps were
defined using E_L* and R_L*, so their Grams are averages of
E_L E_L* and R_L R_L*, respectively, with no transposition of the
claimed d-dimensional inequality. This proves both asserted bounds.

## 3. Integer lifts, Newton reconstruction, and no modular division

For any multiset M of m<=L indices in {1,...,s}, its degree-j integer
moment satisfies, for 0<=j<=L,

\[
 0\le p_j(M)\le L(2^n)^L=L2^{nL}
 <2^{nL+q}=N.
\]

The last strict inequality uses 2^q>=L+1, not 2^q>=L.
For j=0 the moment is m. Equality of code tuples modulo N therefore
implies equality of all the integer moments 0 through L. Lift **before**
applying Newton identities; division by j in Z/(2^b) is not used.

In the rational field, Newton's recurrence determines every elementary
symmetric function e_j for 1<=j<=m successively from the moments:

\[
 j e_j=\sum_{t=1}^j(-1)^{t-1}e_{j-t}p_t,\qquad e_0=1.
\]

Hence the monic product of linear factors with roots M is determined,
including multiplicity. Equal root polynomials have equal root multisets.
This proves injectivity for **all** multisets of length at most L,
including the empty one. The formal proof evaluates Mathlib's Newton
identities and takes polynomial root multisets; it does not assume this
injectivity. `manuscript_no_wrap` and `manuscript_code_injective` include
the actual binary modulus for arbitrary n,L,s.

## 4. Positive Fourier convention and the endpoint-support theorem

For q visits i0,...,i_(q-1), q between 1 and L, finite matrix-product
expansion gives the following coefficients in the lower columns:

\[
 \begin{array}{ll}
 R_L^*: &
 B_{a i_0}D_{i_0 i_1}\cdots D_{i_{q-2}i_{q-1}}\,
 \chi_{v_{i_0}+\cdots+v_{i_{q-1}}},\\[2pt]
 E_L^*: &
 (C^*)_{a i_0}(D^*)_{i_0 i_1}\cdots(D^*)_{i_{q-2}i_{q-1}}\,
 \chi_{-(v_{i_0}+\cdots+v_{i_{q-1}})} .
 \end{array}
\]

For q=1 the product of D entries is empty. The endpoint i_(q-1)
is the input column. This expansion follows inductively from the entry
formula (PQ)_(ai)=sum_j P_(aj)Q_(ji), starting with BZ and C*Z*.
It is exactly BZ(DZ)^(q-1) and C*(Z*D*)^(q-1)Z*.

The normalized positive Fourier ket is |what>=|G|^(-1/2)sum_z chi_w(z)|z>.
Taking its bra multiplies the sampled function by conjugate(chi_w).
Therefore a term chi_f contributes to frequency **f**, not -f.
The R paths above have positive frequencies and the E paths negative ones.
The normalizations cancel to the uniform character average 1/|G|.

Fix a nonzero row frequency and an output port. Negate the E frequency
first. Section 3 gives one multiset M for every contributing path.
Every nonzero internal input column belongs to M, even when different
path orderings or amplitudes cancel. Thus the number of such columns
is at most |supp M|<=|M|<=L (also at most s).
No internal path has zero frequency, since the first coordinate is its
length, between 1 and L<N. At frequency zero precisely the one identity
port column can be nonzero. L>=1 covers that row too.

`pathRow_support` proves existence of a contributing path for a nonzero
sum. `manuscript_fullRow_bound` proves the entire support statement,
ports included, for both signs and arbitrary complex path amplitudes.
The result is not merely a bound on the number of paths or frequencies.

## 5. Tails and the field operator norm

The omitted forward lower block is
Z sum_(j>=L)(DZ)^j C; its norm is at most
sum_(j>=L)r^j=r^L/(1-r). The backward expression is
sum_(j>=L)(Z*D*)^j Z*B* and obeys the same estimate, since every
block of a unitary is a contraction. This also covers r=0, where both
tails vanish for L>=1.

Use the exact identity from Section 1 and unitarity of F,V to obtain,
for every z,

\[
 \|F E_L^*-R_L^*V\|
 \le\|E_L-E\|+\|R_L-R\|\le 2r^L/(1-r).
\]

For any fixed input x, the squared norm of the field difference is the
uniform average of the squared pointwise norms. It is consequently at
most (2r^L/(1-r))^2 ||x||^2. Taking the supremum over unit x proves
the claimed operator norm. This is not an average of operator norms
mistaken for the norm of an average.

## 6. Structural extension: smaller prime-field character grids

The proofs of Sections 1, 2, 4, and 5 work on any grid
G_p=(Z/p)^(L+1) with phases v_i=(1,i,...,i^L), provided p is prime and
p>max(s,L). Orthogonality needs p>L. Code injectivity now follows
**inside the field F_p**, rather than from integer no-wrap bounds:
lengths 0,...,L are distinct modulo p, indices 1,...,s are distinct,
and each divisor j=1,...,L in Newton's recurrence is invertible.
Equal moment tuples again give equal root multisets in F_p, and the
injective index labelling recovers the original internal indices.

It follows that **all four conclusions of the theorem hold unchanged**
for these smaller grids. `prime_code_injective` and
`prime_fullRow_bound` formalize the new code and both support bounds.
`compact_code_exists` proves that one can choose

\[
 M=\max(s,L)<p\le2M.
\]

The logarithmic grid size is then

\[
 \log_2|G_p|=(L+1)\log_2p\le(L+1)\log_2(2\max(s,L)),
\]

in place of (L+1)(nL+ceil(log_2(L+1))). Encoding each p-ary coordinate
separately uses (L+1)ceil(log_2p) binary digits. This is an exact
field-space improvement, not a claim that the manuscript's binary
Fourier-slot compilation already implements a prime-dimensional Fourier
transform, or that its final synthesis complexity has been improved.
The classical ingredients are not claimed new; independent review must
assess the significance and novelty of this application.

## 7. Exact replay, source findings, and remaining dependencies

Run, from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/fourier-feedback-audit/verify.py

The verifier recompiles the formal source through `lean_evidence verify`
with claim `C_FOURIER_CORE`, requires Lean 4.31.0, exit code zero and
no proof holes, recomputes exact rational/complex diagnostic certificates,
checks the Jacobian inverse by two-sided multiplication, and compares
the recomputed result with `exact_certificate.json`. Any failed
conclusion or mismatched certificate is a nonzero exit.
These diagnostics include nonnormal anisotropic complex blocks,
noncommuting diagonal phases, r=0, L=1, both Fourier signs, and incorrect
order/sign negative controls. They do not replace the universal proof.

The single Jacobian operation is `matrix.inverse.compute`, applied to
25(I-DZ)=[[16,-12],[-12,34]] in a rational 4-dimensional unitary example.
`jacobian-payload.json` and `jacobian-result.json` retain its exact input,
typed output, server version, protocol, and adapter result. The inverse
is independently multiplied on both sides; no solver verdict is used
as mathematical proof.

The following contextual source findings were recorded as cited
assumptions before developing this proof:

* Fritzsche--Katsnelson--Kirstein, author version
  [arXiv:0805.4732v2](https://arxiv.org/abs/0805.4732v2),
  Section 3, Theorem 3.5 (p.16), and Theorem 3.10(2) (p.21).
  The obtained author source states in the scalar-port case:
  "Let U ... be a unitary matrix with block-decomposition (3.28) and let
  the function S(z) be defined in terms of U by (3.34). Then the function
  S(z) is a rational inner function with deg S<=n."
  The blocks have sizes 1x1, 1xn, nx1, nxn and
  S(z)=A+zB(I-zD)^(-1)C. The broader Theorem 3.5 concerns
  finite-dimensional unitary colligations.
  The publisher chapter DOI 10.1007/978-3-0346-0183-2_9 returned HTTP 406
  to the source reader; identity of that edition was not verified.
  This is a scalar-variable contextual citation, not evidence that a
  scalar theorem alone covers independent diagonal feedback.
  The present proof does not depend on it.
* Tropp, author version
  [arXiv:1504.05919v2](https://arxiv.org/abs/1504.05919v2),
  revised 3 August 2016, Lemma 6.1, Proposition 7.3, and Section 7.2.
  The obtained primary source supports the Gaussian integration-by-parts
  and trace-product **method** cited by Sections 6--7 in the manuscript's
  contraction section. The manuscript supplies its own Rademacher
  comparison and constants. Publisher full text for DOI
  10.1016/j.acha.2016.07.005 returned HTTP 403; identity to the published
  edition was not checked. No citation error is inferred.

These are source-reader findings, not independent ledger attribution
verdicts. Reviewer attribution remains outstanding. The inherited Wiki
search found no applicable prior unitary-feedback certification.
The finite-only proof route is explicitly retired because it cannot
establish universal quantifiers.

The proof graph records `thm:main` -> `rec:skeleton`, `compile:slots`;
recursion depends on contraction, field encoders, Section 04, and slot
interfaces. The encoder route depends on `encode:row-sparse`, the two
Fourier-field properties, and Fourier/state-preparation slots.
None of `contract:moment`, `contract:block`, `contract:depth`,
`encode:row-sparse`, `encode:implementation`, `rec:step`,
`rec:skeleton`, `compile:words`, `compile:slots`, or the slot resource
claims is certified by this report.
