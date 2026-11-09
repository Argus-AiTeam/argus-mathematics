# Universal rectangular thermal lifting

## Statement and scope

Let \(X,Y\in\mathbb C^{d\times r}\), where \(d,r\) are arbitrary positive
integers, and let \(\operatorname{Tr}(XX^*)=\operatorname{Tr}(YY^*)=1\).
Let \(\alpha,\beta,\eta,\delta,K\geq0\),
\(\alpha+\beta+\eta+\delta=1\), and
\(\alpha\delta-\beta\eta=K^2\). Set
\[
 T=\begin{pmatrix}
 \alpha XX^*+\beta YY^*&KXY^*\\
 KYX^*&\eta XX^*+\delta YY^*
 \end{pmatrix},\quad
 U_0=\alpha+\beta,\quad U_1=\eta+\delta,\quad
 u=U_0U_1-K^2.
\]
Then \(T\) is a density matrix, \(0\leq u\leq1/4\), and
\[
 S(T)\ \geq\ (\alpha+\eta)S(XX^*)+
                 (\beta+\delta)S(YY^*)+g(u),
 \qquad
 g(u)=h((1+\sqrt{1-4u})/2).
\]
Here \(S(P)=-\operatorname{Tr}(P\ln P)\), \(h\) uses natural logarithms,
and \(0\ln0=0\). No invertibility, orthogonality, or commutativity is
assumed. This is the precise claim in the staged manuscript's
`build/sections/thermal.tex`, Theorem `thm:thermal`, not a capacity
theorem or a numerical surrogate.

## Analytic inputs fixed before development

The inherited project Wiki index supplied no relevant thermal-channel or
amplitude-damping result. The scope therefore relies on the primary
propositions below, not on inherited campaign conclusions.

1. **Rectangular triangular entropy inequality.** Tang, Bai, and Wang,
   *Classical Capacity and Entanglement Cost of the Amplitude Damping
   Channel*, arXiv:2609.28592v1, Theorem 4.2, equations (4.4)--(4.5):
   \(A\in\mathbb C^{r_1\times c_1}\),
   \(B\in\mathbb C^{r_2\times c_1}\),
   \(D\in\mathbb C^{r_2\times c_2}\), with arbitrary positive integer
   dimensions, and squared Frobenius masses \(\alpha,\beta,\gamma\)
   summing to one, satisfy
   \[
   S_2\left(
     \begin{pmatrix}A&0\\B&D\end{pmatrix}
     \begin{pmatrix}A&0\\B&D\end{pmatrix}^{\!*}\right)
   \geq e(2\sqrt{\alpha\gamma})+
       \alpha S_2(AA^*/\alpha)+
       \beta S_2(BB^*/\beta)+
       \gamma S_2(DD^*/\gamma).
   \]
   Zero-weight terms are zero; singular blocks are permitted. The
   source uses bits and \(e(c)=h_2((1+\sqrt{1-c^2})/2)\).
   Multiplication by \(\ln2\) gives the nats convention here. Permuting
   block rows gives the manuscript's `thm:block`, with scalar term
   \(g(yz)\) for the off-corner masses \(y,z\).
   Primary source read: https://arxiv.org/html/2609.28592v1,
   Theorem 4.2. The manuscript's bibliography lists an additional
   author; this audit relies on the proposition and version actually
   obtained, not on the author string.
2. **Entropy concavity.** For density matrices \(P,Q\) and
   \(w\in[0,1]\),
   \(S(wP+(1-w)Q)\geq wS(P)+(1-w)S(Q)\).
   Watrous, *The Theory of Quantum Information* (2018),
   doi:10.1017/9781316848142, Theorem 5.23, equation (5.102),
   states this even for positive semidefinite, unnormalized operators.
   The author's chapter 5 PDF was obtained and the proposition read.
   The staged `thermal.tex`, equations `eq:diagonal` and
   `eq:concavity`, includes a proof: in a basis diagonalizing the
   mixture use classical Shannon concavity, then
   \(S(P)\leq H(\operatorname{diag}P)\) for each component.
3. **Finite-dimensional entropy invariance.** Unitary conjugation and
   adding zero eigenvalues preserve \(S\). These follow directly from
   the eigenvalue definition, including \(0\ln0=0\). A Gram matrix
   \(MM^*\) is positive semidefinite; its trace is the sum of squared
   entry moduli.
4. **Finite Kraus representation.** For the channel specialization,
   a finite-dimensional completely positive trace-preserving map has
   a finite family \(V_\ell\) with
   \(\mathcal N(P)=\sum_\ell V_\ell P V_\ell^*\) and
   \(\sum_\ell V_\ell^*V_\ell=I\).
   Watrous, doi:10.1017/9781316848142, Theorem 2.22, items 1,4,5,
   supplies the finite representation for nonzero completely positive
   maps. Theorem 2.26, items 1,5, supplies normalization for every such
   representation of a trace-preserving map. The nonzero hypothesis
   holds because the input space is nonzero and the map preserves trace.
   Both propositions were read in the author's chapter 2 PDF.
   The manuscript explicitly invokes this input in the proof of
   `lem:partner-branch`. The algebraic lifting itself does not use it.

Items 1--4 are analytic/background inputs, not conclusions of a finite
experiment or of a formal proof that treats entropy abstractly. Independent
citation attribution and independent review remain separate obligations.

## Algebraic proof

The determinant constraint gives
\[
 u=\beta U_1+\eta U_0.
\]
Consequently \(u\geq0\), \(u\leq U_0U_1\leq1/4\).
For \(u>0\), both row sums are positive. Define
\[
 (a_1,b_1,e_1,d_1)=(K^2/U_1,u/U_1,0,U_1),\qquad
 (a_2,b_2,e_2,d_2)=(U_0,0,u/U_0,K^2/U_0),
\]
\[
 w_1=\beta U_1/u,\qquad w_2=\eta U_0/u.
\]
All entries and weights are nonnegative. Both endpoint quadruples
have row sums \(U_0,U_1\), total mass one, and
\(a_i d_i=K^2\). The weights sum to one and recover all four
original coefficients. In particular, with the same cross coefficient
\(K\), \(T=w_1T_1+w_2T_2\).

For arbitrary rectangular \(X,Y\) the endpoint Gram factors are
\[
 M_1=\begin{pmatrix}\sqrt{a_1}X&\sqrt{b_1}Y\\
                      \sqrt{d_1}Y&0\end{pmatrix},\qquad
 M_2=\begin{pmatrix}\sqrt{a_2}X&0\\
                      \sqrt{d_2}Y&\sqrt{e_2}X\end{pmatrix}.
\]
Since \(K\geq0\), \(\sqrt{a_i}\sqrt{d_i}=K\), so
\(M_iM_i^*=T_i\). Normalization of \(X,Y\) makes their traces one.
The first analytic input applies directly to \(M_1\), and after a
unitary block-row interchange to \(M_2\). Their off-corner mass
products are respectively \(b_1d_1=u\) and \(e_2a_2=u\).
Thus both inequalities have exactly the same \(g(u)\), not an
average of different scalar arguments. Concavity and recovery of
the column sums give the asserted bound. Zero mixture weights are
allowed; neither they nor singular Gram products require a limit.

For completeness, \(u=0\) entails no singular division. If \(U_0=0\)
then \(\alpha=\beta=K=0\); the only nonzero diagonal block is
\(\eta XX^*+\delta YY^*\). If \(U_1=0\), the symmetric statement
holds. Ordinary entropy concavity and \(g(0)=0\) suffice. If both row
sums are positive, the nonnegative identity for \(u\) forces
\(\beta=\eta=0\). The single factor
\(\binom{\sqrt\alpha X}{\sqrt\delta Y}\) is a normalized Gram
factorization, and the triangular inequality with zero off-corner
mass gives the result. Equivalently, one may first handle
\(\beta=0\) or \(\eta=0\) by the triangular theorem and only use the
two-endpoint decomposition when both are positive. This latter case
split covers every zero-row and zero-\(u\) boundary without division.

## Channel substitution

For \(\gamma,\nu,p\in[0,1]\), put
\[
 a=1-\gamma\nu,\ b=\gamma(1-\nu),\
 c=\gamma\nu,\ d=1-\gamma(1-\nu),\
 k=\sqrt{1-\gamma},\ x=1-p,\ y=p .
\]
Then \(a+c=b+d=1\), \(ad-bc=k^2\), and the admissible substitution is
\[
 \alpha=ax,\quad\beta=by,\quad\eta=cx,\quad\delta=dy,\quad
 K=k\sqrt{xy}.
\]
Its column sums are \(x,y\), and
\[
 u=(ax+by)(cx+dy)-k^2xy
   =\gamma\nu(1-\nu)+\gamma(1-\gamma)(p-\nu)^2.
\]
For unit branches \(\psi_0,\psi_1\), define the columns of \(X,Y\)
as \(V_\ell\psi_0,V_\ell\psi_1\). Direct multiplication gives
\[
 XX^*=\mathcal N(|\psi_0\rangle\langle\psi_0|),\quad
 YY^*=\mathcal N(|\psi_1\rangle\langle\psi_1|),\quad
 XY^*=\mathcal N(|\psi_0\rangle\langle\psi_1|).
\]
Trace preservation gives both traces one. The common column index is
essential for the third identity; equal row and column dimensions or
orthogonal branches are not needed. Applying the theorem gives
`lem:partner-branch`, including \(p,\gamma,\nu\) at all endpoints.

## Classification

This is a universal analytic verification relative to the stated
triangular theorem and elementary entropy facts. It is not a
counterexample, nor is numerical survival a proof. No false
mathematical assertion in `thm:thermal` or its substitution has been
identified at this stage. The improvement over the supplied comparator
is a completed, compiler-checked universal lifting
argument, rather than a statement with a proof hole. Novelty,
significance, and final acceptance are reserved for the independent
Reviewer; none is inferred from a compiler exit code.

## Completed formal verification and its limits

`Main.lean`, declaration `ThermalLift.thermal_from_triangular`, proves the
entire lifting implication for arbitrary finite rectangular complex
matrices. Its explicit hypotheses are the specialized rectangular
triangular entropy input, concavity on states, and block-swap invariance.
The triangular endpoint bounds are **derived**, not assumed as the
thermal conclusion. `ThermalLift.thermal_state` proves positivity and
trace one without any entropy hypothesis. The channel specialization is
proved in `ThermalLift.kraus_channel_lift`, including arbitrary finite
input, output, and common Kraus index types and all parameter endpoints.
The separate `statement_fidelity.md` specifies every analytic hypothesis
and maps the formal declarations to the manuscript.

The prescribed `lean_evidence verify` run on this source and fidelity
document returned `status=success`, `exit_code=0`, `proof_holes=[]`,
with Lean 4.31.0 and a successful axiom audit. It recorded mechanical
support for **version 3 of `C_THERMAL_CORE`** in
`certificates/C_THERMAL_CORE-df31c719d7cfc0b6.json`.
The derived `closed_kernel` status belongs to this explicitly conditional
universal theorem, not to an independently formalized analytic theory of
von Neumann entropy or to the full capacity theorem. The prior failed
development certificate is an inconclusive, superseded compiler attempt,
not a mathematical refutation.

`verify.py` replays 21 universal rational/polynomial identities, exact
singular noncommuting rectangular Gram examples, the symbolic
common-Kraus cross/normalization identities, and the typed Jacobian
characteristic polynomial. It also checks the actual compiler result,
axiom audit, source/fidelity freshness, archived certificate, and current
claim-ledger binding. Run:

```
$WORKSPACE/argus-live-update/.venv/bin/python verify.py
```

For a fresh real compiler run, the exact supported interface is:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/thermal_lift/Main.lean --statement-fidelity research/thermal_lift/statement_fidelity.md --claim C_THERMAL_CORE --project-root .
```

The independent adversarial experiment tested 2,400 cases, including a
125-point boundary/near-boundary coefficient grid and six rectangular
shapes. It found no discrepancy at the declared `-1e-9` threshold;
the minimum computed gap was approximately `-3.97e-15`, consistent with
floating-point roundoff. This experiment supplies **no** universal
entropy certificate. `search_result.json` records its precise scope.

The Jacobian adapter's bounded operation
`matrix.symbolic.characteristic_polynomial.compute` returned the exact
polynomial
\(\lambda^2-(U_0+U_1)\lambda+U_0U_1-K^2\).
Its dedicated payload and typed output preserve server version `0.14.0`,
protocol `2025-11-25`, and successful adapter status. Its contribution is
only the scalar spectrum, not a substitute for the universal proof.

The four external citation attributions, independent statement-fidelity
review, and publishable-significance/novelty decisions remain for the
Host-invoked independent Reviewer. The Engineer read the primary
propositions and stored the mathematical passages, but cannot independently
confirm its own citations. No Reviewer acceptance is claimed, and no
`F_...` refutation claim is warranted by the inspected theorem or
substitution.
