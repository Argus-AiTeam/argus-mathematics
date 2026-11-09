# All-orders audit of the shared chronological transfer construction

## Result and precise scope

The specified history kernel gives the literal identities in periodic
`build/transfer.tex`, Proposition `prop:transfer`, and boundary
`build/sections/transfer.tex`, Proposition `tr:boundary`. The proof below
holds for every stated temperature, length, and group element. No false
manuscript assertion was identified in this construction.

The periodic statement is
\[
 Z_n(b,g)=\operatorname{Tr}(X_b^nU_g),
 \qquad b>0,\quad n\geq4,\quad g\in\mathcal G_{\rm per},
\]
where \(\mathcal G_{\rm per}\) consists of all 24 proper signed
permutation matrices, the seam is conjugated on site **0**, and
\(a=700741/500000\) is the shift **per site**. Although the physical
Hamiltonian is defined for all of \(SO(3)\), the manuscript proposition
and this audit's representation \(U_g\) are restricted to this finite
group.

For the boundary statement \(h=3/5\), \(b>0\), \(n\geq2\), and
\(\mathcal G_{\rm bdry}=\langle D_2,C\rangle\) has 12 elements. Its
pairing represents
\[
 H_n(g)=\sum_{j=0}^{n-2}S_j\cdot S_{j+1}
              -hS_0^z+hS_{n-1}^{g e_z}.
\]
Thus \(g=I\) gives opposite fields and \(g=P=\operatorname{diag}(1,-1,-1)\)
gives the stated same fields. In both cases the power is \(X_b^n\),
not \(X_b^{n-1}\).

`Main.lean` proves the unrestricted finite-word tensor-trace
factorization used below. The official compiler and axiom audit returned
exit code 0 and `proof_holes=[]` with Lean 4.31.0. Its claim is
`C_TRANSFER_CORE`; the separate `statement_fidelity.md` specifies exactly
what it formalizes. Infinite-dimensional analysis and physical
partition functions are proved here in prose, not in Lean.

This is a reconstruction/verification of the manuscripts' construction,
not a novelty claim or a proof of either uniform spectral gap. The
thermal/trial seeds, sector/bootstrap estimates, boundary recurrence,
and final length coverage remain open campaign obligations. Independent
Reviewer approval has not been issued.

## 1. Settled source findings and background

The exact sources are the staged September 24, 2026 versions:

* Periodic `build/model.tex`, equations `eq:cartesian-bond`,
  `eq:twisted-hamiltonian`, and `eq:shift`.
* Periodic `build/transfer.tex`, Proposition `prop:transfer`, including
  `eq:twisted-kernel` and `eq:cycle-integral`.
* Boundary `build/sections/transfer.tex`, equations `tr:Hopp`,
  `tr:Hsame`, `tr:operator`, `tr:rotations`, and `tr:vector`, and
  Proposition `tr:boundary`.

The literature cited in both transfer sections was obtained and read:
Aizenman and Nachtergaele, *Geometric Aspects of Quantum Spin States*,
arXiv:cond-mat/9310009v1, Section 2.2, equations (2.10)--(2.12),
<https://arxiv.org/html/cond-mat/9310009v1>.
Those equations give a Poisson ordered expansion for a finite collection
of sites, self-adjoint local operators, and nonnegative couplings. The
probability measure in that version includes a compensating exponential
factor. Our unnormalized simplex measures include no Poisson probability
normalization. In addition, equation (2.12) uses latest time on the left,
whereas the audited kernel uses earliest time on the left.

These are conventions, not a contradiction: Section 4 below derives the
earliest-left expansion directly for the autonomous generator. It never
reverses an individual noncommutative word. The positivity assumption
introduced in that paper's Section 2.3 is not used. No gap theorem,
positive-integrand representation, or spin-one bilinear conclusion is
imported from that reference. This prior expansion is not new.

The functional-analysis background is Tonelli/Fubini, Bessel/Parseval,
and the compact self-adjoint spectral theorem. The relevant statements
were read in the installed Mathlib dependency pinned by the host Lake
manifest to revision `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`.
For Fubini, `Mathlib/MeasureTheory/Integral/Prod.lean`,
`MeasureTheory.integral_prod` and
`MeasureTheory.integral_integral_swap` require integrability and
s-finite product measures. For nonnegative sum/integral interchange,
`Mathlib/MeasureTheory/Integral/Lebesgue/Add.lean`,
`MeasureTheory.lintegral_tsum` requires a countable index and
almost-everywhere measurable summands. Finite history measures,
countably many event words, and the explicit bounds (5)--(6) verify
these hypotheses. The precise spectral completeness and
nonzero-eigenspace assertions were read in
`Mathlib/Analysis/InnerProductSpace/Spectrum.lean`,
`ContinuousLinearMap.orthogonalComplement_iSup_eigenspaces_eq_bot`
and `ContinuousLinearMap.finite_dimensional_eigenspace`.
Their hypotheses are completeness, a compact continuous linear
operator, and symmetry for the completeness assertion; the dimension
assertion explicitly excludes eigenvalue zero. Our space is complex
\(L^2\), and compactness and self-adjointness are proved in Section 3.
These precise library propositions are explicit source-only background
assumptions on `C_TRANSFER_ANALYTIC` in the ledger, not unidentified
analytic obligations or claims that the entire transfer theorem was
formalized. They use code-document references, not invented DOI/arXiv
identifiers. The independent Reviewer must check their application.

Attempts to fetch the Encyclopedia of Mathematics Hilbert--Schmidt,
nuclear, and compact-operator pages returned HTTP 502. An MIT OCW
Lecture 22 landing page was obtained, but the suggested legacy PDF URL
returned HTTP 404. Neither unavailable source supports a citation here.

The known-invalid candidate shortcut is termwise word reversal:
\[
 \operatorname{tr}(G_xG_yG_z)=1,\qquad
 \operatorname{tr}(G_zG_yG_x)=-1.
\]
That route is retired in the ledger. **It is not an assertion made by the
staged manuscripts**, which explicitly avoid it; it does not warrant an
`F_...` refutation claim.

## 2. Arbitrary-word algebra, not finite-order evidence

Let \(I\) be any finite site set, \(D\) any finite local basis, and \(R\)
any commutative semiring. For local matrices \(A_i\), define the actual
matrix in the product basis by
\[
 T(A)_{\mathbf r,\mathbf s}=\prod_{i\in I}(A_i)_{r_i,s_i}.
\]
Finite distributivity gives
\[
 \begin{split}
 [T(A)T(B)]_{\mathbf r,\mathbf s}
 &=\sum_{\mathbf u\in D^I}\prod_i
       (A_i)_{r_i,u_i}(B_i)_{u_i,s_i}\\
 &=\prod_i\sum_{u_i\in D}(A_i)_{r_i,u_i}(B_i)_{u_i,s_i}
 =T((A_iB_i)_i)_{\mathbf r,\mathbf s}.
 \end{split}
\]
Also \(T((1)_i)=1\) and
\(\operatorname{tr}T(A)=\prod_i\operatorname{tr}A_i\).
Induction on an arbitrary finite ordered list \(w=(e_1,\ldots,e_k)\)
therefore proves
\[
 \operatorname{tr}\left(\prod_{\ell=1}^k T(A(e_\ell))\right)
   =\prod_i\operatorname{tr}
       \left(A_i(e_1)\cdots A_i(e_k)\right).                 \tag{1}
\]
The empty list is included. Assign identity at nonincident sites and
delete those identities. This retains precisely the chronological
subsequence at each site. Neither commutativity of local matrices nor
any reversal is used.

The formal declaration `TransferAudit.trace_supported_word` proves this
filtered form for every list length, finite site and local basis type,
and commutative semiring. The supporting declarations prove multiplication,
identity, trace, arbitrary-list factorization, and identity filtering.
In particular (1) is not inferred from the bounded Taylor tests.

In the Cartesian coordinates of the manuscripts,
\[
 G_\alpha=iS^\alpha,\qquad
 (G_\alpha)_{ij}=\varepsilon_{\alpha i j},\qquad
 -S\cdot S=\sum_\alpha G_\alpha\otimes G_\alpha.
\]
Exact matrix arithmetic in `verify.py` checks the bond identity
\(\sum G_\alpha\otimes G_\alpha=|\Omega\rangle\langle\Omega|-F\)
entry by entry, and
\[
 G_\alpha^TG_\alpha=I-|e_\alpha\rangle\langle e_\alpha|.
\]
This last projection is nonzero, proving \(\|G_\alpha\|=1\).
The script also checks covariance for every label and every one of the
24 signed rotations. These are exhaustive finite algebraic
verifications of those particular matrices, distinct from testing a
bounded number of physical lengths.

## 3. Analytic operator construction and legitimate cycle traces

Fix \(b>0\). For \(d\) events and fixed labels, the strictly ordered
simplex has volume \(b^d/d!\). Including empty-history mass one,
\[
 M:=\mu(\Omega_b)=\sum_{d\geq0}3^d b^d/d!=e^{3b}<\infty.
\]
The kernel is measurable: on each pair of labeled simplexes it is
constant on the finitely many cells defined by the joint ordering.
Cross-history collisions are finite unions of coordinate hyperplanes
on each such component, hence null; taking the countable union remains
null. The empty-history atom creates no collisions.

Each merged product is real and has operator norm at most one, so
\(|k(x,y)|\leq3\). Swapping the two histories preserves the merged
list, not its reverse. Thus \(k(x,y)=k(y,x)\). The kernel belongs to
\(L^2(\mu\otimes\mu)\), and its integral operator is real and
self-adjoint. The usual orthonormal-basis calculation (Bessel followed
by Parseval) gives
\[
 \|K\|_{\rm HS}^2=\int |k(x,y)|^2\,d\mu(x)d\mu(y)\leq9M^2.
\]
Equivalently, approximating the kernel in \(L^2\) by finite sums of
rectangle indicators gives finite-rank operators converging in
Hilbert--Schmidt, hence operator, norm. This also proves compactness.
Scaling \(X=e^{-ab}K\) yields
\[
 \|X\|_{\rm HS}^2\leq9e^{(6-2a)b}.
\]
No positivity of \(K\) or \(X\) is needed.

For clarity, the trace-class step does not use a diagonal-kernel
formula. If \(A,B\) are Hilbert--Schmidt and \((u_j)\) is an
orthonormal basis, the rank-one expansion
\[
 ABf=\sum_j (Au_j)\langle B^*u_j,f\rangle
\]
has summable rank-one norms, since their sum is at most
\(\|A\|_{\rm HS}\|B\|_{\rm HS}\) by Cauchy--Schwarz. This proves that
\(AB\) is trace class. Finite-rank approximation, followed by that same
bound, gives for square-integrable kernels
\[
 \operatorname{Tr}(AB)
    =\int a(x,y)b(y,x)\,d\mu(x)d\mu(y).                     \tag{2}
\]
Indeed this holds for rectangle kernels by direct rank-one evaluation;
both sides are continuous in the two \(L^2\)/Hilbert--Schmidt norms.
Absolute integrability in (2) follows from Cauchy--Schwarz.

The iterated kernel for \(K^m\) is bounded by \(3^mM^{m-1}\) for
\(m\geq1\). Its construction is justified by finite-measure Fubini.
Thus, for \(n\geq2\), both \(K^{n-1}\) and \(KU_g\) are
Hilbert--Schmidt. Section 5 establishes that the latter kernel is
\(k(x,\sigma_g y)s_g(y)\). Apply (2), and then Fubini to its bounded
integrand, to obtain exactly
\[
 \operatorname{Tr}(K^nU_g)=
 \int\prod_{j=0}^{n-2}k(x_j,x_{j+1})\,
       k(x_{n-1},\sigma_gx_0)s_g(x_0)\,d\mu^n.             \tag{3}
\]
The integral is absolutely bounded by \(3^nM^n\). This argument
deliberately does not assert that \(K\) itself is trace class.

Compact self-adjoint spectral theory now gives real eigenvalues.
Bessel/Parseval on an eigenbasis gives square summability, and for
every integer \(k\geq2\),
\[
 \sum_i|\lambda_i(X)|^k
 \leq \|X\|^{k-2}\|X\|_{\rm HS}^2<\infty.
\]
Since \(X^k=X\,X^{k-1}\) is a product of Hilbert--Schmidt operators,
it is trace class. Computing its trace in the eigenbasis gives the
ordinary moment formula used in the periodic proposition.

## 4. Chronological expansions and every interleaving

For any finite family of matrices \(A_c\), including complex scalar
event coefficients, put \(A=\sum_c A_c\). Direct finite distributivity
in the exponential series gives
\[
 e^{bA}=\sum_{k\geq0}\sum_{c_1,\ldots,c_k}
   \int_{0<t_1<\cdots<t_k<b}
          A_{c_1}\cdots A_{c_k}\,dt_1\cdots dt_k.          \tag{4}
\]
Each integrand is constant in time; its volume is \(b^k/k!\).
Consequently (4) has exactly the manuscript's increasing-left-to-right
convention. It would also be valid with the reversed product because
all words are summed, but this is not equality for each fixed word.

Here is the all-orders regrouping, including its normalization.
Fix any finite tuple of history counts \(d_1,\ldots,d_q\), with total
\(k\). Outside coordinate-equality hyperplanes, sorting all times
uniquely specifies a shuffle preserving each history's internal order.
The product of the \(q\) ordered simplexes is the disjoint union of
these shuffle cells up to those null hyperplanes. On a cell the map to
the global ordered simplex is a coordinate permutation and has absolute
Jacobian one. Conversely the sorted global times and the shuffle
recover all component times. Labels are merely carried along.
There are \(k!/\prod_r d_r!\) shuffles; their volumes sum to
\[
 \frac{k!}{\prod_r d_r!}\frac{b^k}{k!}
       =\prod_r\frac{b^{d_r}}{d_r!}.
\]
This proves the regrouping for **every** count tuple, including zero
counts, without introducing an extra factorial.

For the periodic chain the alphabet has \(3n\) norm-at-most-one
two-site events. The sum of absolute traced contributions in (4) is at
most
\[
 3^n\sum_{k\geq0}(3nb)^k/k!=3^n e^{3nb}.                 \tag{5}
\]
For the open chain there are \(3(n-1)\) unit-norm bond terms and two
field terms of norm \(h\), giving
\[
 3^n e^{b(3(n-1)+2h)}.                                  \tag{6}
\]
These explicit summable majorants justify exchanging all sums,
integrals, and history regroupings in Sections 6--7 by Tonelli on
absolute values and Fubini on the original terms. There is no
unresolved convergence assumption at high order or large \(b\).

## 5. Rotations, representation, and twisted-kernel orientation

Write \(ge_\alpha=\epsilon_g(\alpha)e_{\sigma_g(\alpha)}\).
Preservation of the epsilon tensor by determinant-one orthogonal
matrices gives
\[
 gG_\alpha g^{-1}=\epsilon_g(\alpha)G_{\sigma_g(\alpha)}.
\]
The exhaustive exact finite check is an independent verification for
the complete stated group. For every history,
\[
 s_{gh}(x)=s_g(\sigma_hx)s_h(x).
\]
This follows separately for each mark and hence for arbitrary history
length, not just for the short words in the script. Relabeling preserves
Lebesgue measure and the empty atom, and \(|s_g|=1\). Therefore
\[
 (U_gf)(x)=s_g(\sigma_g^{-1}x)f(\sigma_g^{-1}x)
\]
is a real unitary representation.

Conjugating all matrices in a trace gives
\[
 k(\sigma_gx,\sigma_gy)=s_g(x)s_g(y)k(x,y).
\]
Changing integration variable \(y=\sigma_g z\) consequently proves
both commutation with \(K\) and
\[
 (KU_g)(x,y)=k(x,\sigma_gy)s_g(y),                        \tag{7}
\]
with \(g\), not an unjustified inverse, in this kernel. This is the
kernel used in (3).

## 6. Periodic physical identity, with the specified seam

Name the seam history \(e_0\); history \(e_j\), \(1\leq j<n\), is on
the bond from site \(j-1\) to site \(j\). In (4) each internal event
inserts \(G_\alpha\) at its two incident sites. A seam event inserts
\(G_\alpha\) at site \(n-1\), and
\(\epsilon_g(\alpha)G_{\sigma_g(\alpha)}\) at site 0.
Apply the arbitrary-word identity (1), then the shuffle decomposition.
The physical integrand is exactly
\[
 s_g(e_0)\,k(\sigma_ge_0,e_1)\,
       k(e_1,e_2)\cdots k(e_{n-1},e_0).                  \tag{8}
\]
Set \(x_0=e_0,x_1=e_{n-1},\ldots,x_{n-1}=e_1\) in (3).
Kernel symmetry changes its scalar factors into (8).
Only the **spatial enumeration** was reversed; none of the chronological
site products was reversed. Absolute convergence is already supplied by
(5). Hence
\[
 \operatorname{Tr}e^{-bH_n(g)}=\operatorname{Tr}(K^nU_g).
\]
There are \(n\) site kernels. Multiplication by \(e^{-abn}\) gives the
claimed shifted identity, and \(g=I\) gives its eigenvalue moment
version. The zero-event coefficient is \(3^n\), as required by the
physical Hilbert-space dimension.

The script includes a pointwise orientation control, stronger than
merely comparing twisted partition functions. On four sites take two
seam \(x\)-events followed by two bond-\((0,1)\) \(z\)-events.
For \(g=C\), the site-0 word is \(G_y^2G_z^2\), giving integrand 12.
Replacing \(C\) by \(C^{-1}\) makes it \(G_z^4\), giving 24. Both values
are also checked by direct physical tensor-matrix multiplication.
Thus the control detects an inverse accidentally placed on the seam;
it does not rely on the generally insufficient scalar comparison
\(Z_n(b,g)=Z_n(b,g^{-1})\).

## 7. Open physical identity, conjugation, and site normalization

The vector supported on all-\(z\) histories has values \((ih)^d\), so
\[
 \|v_b\|^2=\sum_{d\geq0}b^d h^{2d}/d!=e^{bh^2}.
\]
With the specified conjugate-linear first argument, the left endpoint
coefficient is \((-ih)^d\). At the right, changing variable from the
rotated history \(\sigma_ge_n\) back to \(e_n\) gives coefficient
\(s_g(e_n)(ih)^d\). Thus the one-event insertions are
\[
 (-ih)G_z=+hS^z,\qquad
 (ih)\epsilon_g(z)G_{\sigma_g(z)}=-hS^{g e_z}.            \tag{9}
\]
They are precisely the two endpoint terms in the **negative**
Hamiltonian with fields \(-hS_0^z,+hS_{n-1}^{g e_z}\).

There are \(n-1\) internal bond histories, as well as a left and a
right field history. After (1) and the all-orders shuffle decomposition,
the site traces are
\[
 k(e_0,e_1)\,k(e_1,e_2)\cdots
       k(e_{n-1},\sigma_ge_n).
\]
Integrate with the two coefficients just specified. This is exactly
\(\langle v_b,K^nU_gv_b\rangle\). There is no bond closing the two
endpoints. Bound (6) justifies all integrations; independently the
pairing exists because \(v_b\in L^2\) and \(K\) is bounded.
Scaling the **\(n\) site kernels** gives \(e^{-abn}\), which is the
open-chain shift used in `tr:partitions`. Therefore
\[
 \operatorname{Tr}e^{-b(H_n(g)+anI)}
     =\langle v_b,X_b^nU_gv_b\rangle.
\]
Choosing \(I\) and \(P\) proves both displayed manuscript pairings.
Evenness is unnecessary for this identity; it is needed only when
replacing a signed power by a positive moment later in the manuscripts.

For a sign-sensitive exact control on two sites, use, in order, a left
\(z\)-field event, a \(z\)-bond event, and a right \(z\)-field event.
Its unscaled trace is \(4h^2=36/25\) for opposite fields and
\(-4h^2=-36/25\) for same fields. Both history and direct physical-word
calculations agree. Omitting conjugation at the left endpoint would
fail this control.

## 8. Replay, proof boundary, and remaining obligations

From the campaign root, run

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/transfer_audit/verify.py
```

The standard-library replay verifies the stored exact certificate,
the literal source fragments, all finite spin/group identities,
the order-sensitive controls, the preserved typed Jacobian result,
and the source/fidelity freshness of the real Lean certificate.
Its bounded Taylor comparisons are independent consistency checks:
four-site periodic generators through degree four for all 24 rotations
and two-/three-site open generators through degree four for all 12
boundary rotations, totaling 608448 ordered words. They do not prove the
all-orders analytic statement; Sections 2--7 do.

The Jacobian adapter was discovered and its exact typed contract
inspected before execution. The only operation executed was
`matrix.partial_trace.compute`, over the rationals, on
\((G_xG_yG_z)\otimes(G_zG_yG_x)\), tracing out its first three-dimensional
factor. The returned matrix is
\(\operatorname{diag}(0,-1,0)\), independently replayed entry by entry.
`jacobian_payload.json`, `jacobian_result.json`, and
`jacobian_execution.json` preserve the exact request, typed output,
server version 0.14.0, protocol 2025-11-25, adapter exit code 0, and
absence of timeout. This one contraction is not represented as a
strategy solver or an all-orders proof.

All analytic hypotheses used above are checked for every finite \(b>0\);
none of the physical transfer identities is left as an assumption.
The independent Reviewer still needs to check this prose proof,
statement fidelity, and the mathematical use of the standard
functional-analysis background. The formal certificate alone does not
perform that reading.

Compared with the initially empty evidence ledger, the new result is
an arbitrary-word formal proof plus an explicit all-orders physical
identification, including the seam and the endpoint phases. It does
not improve a spectral-gap bound or establish publication novelty.
`C_PERIODIC_FINITE`, `C_PERIODIC_PROPAGATION`, `C_BOUNDARY_FINITE`, and
`C_BOUNDARY_PROPAGATION` remain unresolved. The publishable campaign
must continue on those distinct dependencies after this bounded
transfer mission is reviewed.
