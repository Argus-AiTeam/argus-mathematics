# Balanced splitting and universal adaptive Fourier transfer

## Result and scope

The assertions `eq:new-frequency-overlap`, `eq:smoothing-squares`,
`eq:smoothing-potential`, and `eq:smoothing-coefficients` in
`sections/fourier-smoothing.tex` are valid. The proof below also proves their
noncommutative splitting dependency, without assuming `lem:splitting`.
No counterexample or false manuscript assertion is claimed.

Here is a quantitative strengthening. Coordinate alphabets may have different
sizes \(L_i=2^{a_i}\), \(a_i\geq1\), variance constants \(\theta_i\geq0\),
and frequency weights \(\lambda_i>1\). Retain exactly the marginal and
scalar variance hypotheses of the manuscript, coordinate by coordinate.
Put
\[
 N_i=\prod_{j\leq i}L_j,\qquad
 d_i=L_i/4,\qquad
 g_i=1+(L_i-1)\lambda_i^2d_i\theta_i,\qquad
 M_0=\mathbb E_x\|F(x)\|_F^2.
\]
There is **no smallness hypothesis** on the \(\theta_i\) for the following
general bound. For every finite-dimensional real PSD-valued \(F\), there
are finite-row, \(r\)-column functions \(H_q^m\) with
\[
 \overline F_m(y)=\sum_q H_q^m(y)^{\mathsf T}H_q^m(y).
 \tag{T1}
\]
With
\[
 w(q,p)=\prod_i\lambda_i^{\mathbf1_{\{q_i\ne p_i\}}},\qquad
 C_q^m=[\sqrt{w(q,p)}\,\widehat H_{q,p}^m]_p
       [\sqrt{w(q,p)}\,\widehat H_{q,p}^m]_p^{\mathsf T},
\]
the **universal potential and mass bounds** are
\[
 \mathbb E_m\sum_q\|C_q^m\|_F^2
 \leq M_0\prod_i g_i,
 \tag{T2}
\]
and, for at least one \(m\),
\[
 \sum_{q,p}w(q,p)\|\widehat H_{q,p}^m\|_F^2
 \leq N_t\sqrt r\,\sqrt{M_0\prod_i g_i}.
 \tag{T3}
\]
The row dimension can be taken to be
\(R_t=r\prod_i(L_i|X_i|)\). It need not be bounded in terms of \(r,t\)
alone. This causes no additional factor in (T3).

For identical coordinates, the manuscript's \(2^tB^2\) potential bound
already follows from the weaker condition
\[
 (L-1)\lambda^2(L/4)\theta\leq1.
 \tag{T4}
\]
Compared with its sufficient condition
\(L\lambda^2 2^{L-1}\theta\leq1\), the permitted upper bound on
\(\theta\) increases by \(2^{L+1}/(L-1)\).
Under the manuscript's **unchanged** sufficient condition one also obtains
the sharper potential bound \(B^2(9/8)^t\), and hence Fourier mass at most
\(L^t\sqrt r\,B(9/8)^{t/2}\), in place of its factors \(2^t\) and
\(2^{t/2}\). Indeed
\[
 g\leq1+\frac{L-1}{2^{L+1}}\leq\frac98.
\]
The last inequality is equivalent to \(L-1\leq2^{L-2}\), valid for every
integer \(L\geq2\): equality holds at \(L=2\), and
\[
 2^{(L+1)-2}-L
 =2\bigl(2^{L-2}-(L-1)\bigr)+(L-2)\geq0
\]
gives the induction step.
The strengthened splitting bound is dimension-free, not commutative.
The manuscript's main matching PSD-rank theorem has other dependencies
and is **not** certified here.

## 1. Noncommutative spectral splitting

All sums of overlaps below are ordered unless otherwise specified.
For PSD matrices \(S,T\), \(\operatorname{tr}(ST)\geq0\), since this
trace is \(\|S^{1/2}T^{1/2}\|_F^2\). For any rectangular \(V\),
\(\|VV^{\mathsf T}\|_F^2=\|V^{\mathsf T}V\|_F^2\), by cyclicity
of trace. No simultaneous diagonalization is used.

**Binary estimate.** For PSD \(A,B\), take the spectral projection \(P\)
of \(A-B\) onto its nonnegative eigenspaces, and \(Q=I-P\).
In the corresponding orthogonal block coordinates,
\[
 A_{12}=B_{12},\quad A_{11}-B_{11}\succeq0,\quad
 B_{22}-A_{22}\succeq0.
\]
Consequently
\[
\begin{split}
 \operatorname{tr}(AB)-\|PBP\|_F^2-\|QAQ\|_F^2
 ={}&\operatorname{tr}((A_{11}-B_{11})B_{11})\\
 &+\operatorname{tr}(A_{22}(B_{22}-A_{22}))
   +2\|A_{12}\|_F^2\ \geq0.
\end{split}
\tag{S1}
\]
This proves the binary splitting constant \(1/2\) when the overlap
sum is ordered. It is optimal: in dimension one, \(A=B=[1]\) forces
loss \(1\), whereas the ordered overlap is \(2\).

The only spectral existence fact needed here is the real symmetric
spectral theorem. It can be obtained in finite dimension as follows:
maximize \(v^{\mathsf T}Dv\) over the unit sphere; differentiation in
every tangent direction gives an eigenvector of \(D\); its orthogonal
complement is invariant by symmetry; induction gives an orthonormal
eigenbasis. Applying this to \(D=A-B\) constructs \(P,Q\), including
zero eigenvalues in \(P\). The same argument supplies all PSD square
roots used in this proof.

**Balanced splitting theorem.** For \(L=2^a\geq2\) and any real PSD
matrices \(A_1,\ldots,A_L\) on the same finite-dimensional space, there
are mutually orthogonal projections summing to \(I\) with
\[
 \sum_z\sum_{s\ne z}\|P_sA_zP_s\|_F^2
 \leq \frac L4\sum_{z\ne z'}\operatorname{tr}(A_zA_{z'}).
 \tag{S2}
\]
For one label the constant is zero. Zero-dimensional subspaces and
zero projections are allowed.

Here is an induction that keeps all compression losses. Split the labels
into equal groups \(I,J\), put \(A=\sum_{i\in I}A_i\),
\(B=\sum_{j\in J}A_j\), and use (S1) to obtain \(P,Q\).
Recursively split \(PA_iP\) on \(\operatorname{ran}P\) for \(i\in I\)
and \(QA_jQ\) on \(\operatorname{ran}Q\) for \(j\in J\). Extend these
projections by zero to the full space. Let
\[
 a_0=\operatorname{tr}(AB),\quad
 b_0=\sum_{\substack{i\ne i'\\i,i'\in I}}\operatorname{tr}(A_iA_{i'})
     +\sum_{\substack{j\ne j'\\j,j'\in J}}\operatorname{tr}(A_jA_{j'}),
 \quad e=\|QAQ\|_F^2+\|PBP\|_F^2\leq a_0.
\]
The full ordered overlap is \(2a_0+b_0\).
The loss assigned to a projection in the opposite group is at most \(e\):
first discard off-diagonal blocks of each compression, and then use the
nonnegative trace products of the PSD summands of \(QAQ\) or \(PBP\).

For \(i\ne i'\) in \(I\), the squared triangle inequality gives
\[
\begin{split}
 \operatorname{tr}(A_iPA_{i'}P)
 &=\|A_i^{1/2}(I-Q)A_{i'}^{1/2}\|_F^2\\
 &\leq2\operatorname{tr}(A_iA_{i'})
      +2\operatorname{tr}(A_iQA_{i'}Q).
\end{split}
\tag{S3}
\]
The sum of the second trace products over distinct \(i,i'\) is at most
\(\|QAQ\|_F^2\). The analogous bound in \(J\) uses \(P\).
Thus the sum of the two recursively encountered ordered overlaps is at
most \(2b_0+2e\).

For \(L=2\), the children have no within-group loss, so (S1) gives (S2).
For \(L\geq4\), the child constant is \(d=(L/2)/4\geq1/2\), and the
total loss is at most
\[
 e+d(2b_0+2e)
 \leq (1+2d)a_0+2db_0
 \leq 2d(2a_0+b_0).
\tag{S4}
\]
The last difference is exactly \((2d-1)a_0\geq0\).
Since \(2d=L/4\), the induction proves (S2). In particular it proves
the manuscript's weaker \(C_L=2^{L-1}\) splitting bound.

## 2. Exact tagged reconstruction and overlaps

Maintain the manuscript's partial square invariant after \(i\) coordinates.
All branches use the same \(R_i\) rows and \(r\) columns, even when their
projection ranks vary with the remaining inputs. Fourier transforms are
only in processed \(y\)-variables, with probability normalization.

Fix \(m_{\leq i},q,x_{>i+1}\). Write \(X,Y,m\) for the next coordinate
data, \(L=|Y|\), and let \(U(x)\) be the old weighted coefficient
concatenation. Its shape is \(R_i\)-by-\(rN_i\), and set
\(Z(x)=U(x)^{\mathsf T}U(x)\).

On the row space indexed by \((y',x,\alpha)\), form
\[
 H'(y_{\leq i},y)_{(y',x)}
  =\mathbf1_{\{y'=y\}}\sqrt{\pi_y^m(x)}\,
     H_q^{(i)}(y_{\leq i};x,x_{>i+1}).
\tag{F1}
\]
Distinct \(y'\)-tags occupy orthogonal coordinate blocks. Therefore
\[
 H'(y_{\leq i},y)^{\mathsf T}H'(y_{\leq i},y)
 =\sum_x\pi_y^m(x)H_q^{(i)}(\cdots;x)^{\mathsf T}
                                  H_q^{(i)}(\cdots;x).
\tag{F2}
\]
The next row dimension is exactly \(L|X|R_i\).
For a new frequency \(z\), the old-weighted coefficient matrix \(V_z\)
has block
\[
 (V_z)_{(y',x)}
    =L^{-1}\chi_z(y')\sqrt{\pi_{y'}^m(x)}\,U(x).
\]
Hence, as an equality of \(rN_i\)-by-\(rN_i\) matrices,
\[
 V_z^{\mathsf T}V_{z'}
 =L^{-2}\sum_y\chi_z(y)\chi_{z'}(y)T_yZ(m).
\tag{F3}
\]
There is no product between distinct tags, and no use of
\(U(x)U(x')^{\mathsf T}\) for \(x\ne x'\).
`tagged_overlap_entry` in `Main.lean` proves this identity for arbitrary
finite row, column, input, and tag types and arbitrary real entries.
The square roots, character signs, and normalization are substitutions,
not extra hypotheses of the identity.

## 3. Conditional overlap bounds

Applying the scalar variance hypothesis entrywise proves the matrix
variance inequality in **every rectangular dimension**, with exactly
the same \(\theta\). No independence among the entries is required.
Also \(\|Z(x)\|_F^2=\|U(x)U(x)^{\mathsf T}\|_F^2\).

Put \(A_z=V_zV_z^{\mathsf T}\) and
\(M=\mathbb E_x\|Z(x)\|_F^2\) for the fixed history. Since
\(\operatorname{tr}(A_zA_{z'})=\|V_z^{\mathsf T}V_{z'}\|_F^2\),
Jensen's inequality, (F3), and the channel marginal give
\[
 \mathbb E_m\operatorname{tr}(A_z^2)\leq M/L^2.
\tag{F4}
\]
For \(z\ne z'\), character orthogonality allows subtraction of
\(\mu=\mathbb E_xZ(x)\) inside (F3). Jensen and the matrix variance
inequality give
\[
 \mathbb E_m\operatorname{tr}(A_zA_{z'})
 \leq \theta M/L^2.
\tag{F5}
\]
Explicitly, (F3) is \(L^{-1}\mathbb E_y[\chi_z\chi_{z'}T_yZ]\);
squaring contributes \(L^{-2}\), not \(L^{-1}\).

Earlier projections can depend on the current \(x\). This only makes
\(Z:X\to\mathbb R^{rN_i\times rN_i}\) an arbitrary matrix function.
After the displayed history is fixed, it does not depend on the new
parameter \(m\). The product law makes this new \(m\) uniform and
independent of the history and \(x_{>i+1}\). Thus (F4)-(F5) are valid
conditional bounds. They are **not** claimed conditional on a projection
chosen using that same new \(m\).

## 4. Splitting, exact squares, and potential

For each fixed new \(m\), apply the proved (S2) to \(A_z\) and choose
projections \(P_s\). They may depend on the fixed history, the current
\(m\), and \(x_{>i+1}\), but not on any processed \(y\) or future
averaging parameter. Finite sets permit all such choices simultaneously.
Define \(H_{(q,s)}^{(i+1)}=P_sH'\), retaining all \(R_{i+1}\) rows.
The projection resolution implies
\[
 \sum_s(P_sH')^{\mathsf T}(P_sH')=H'^{\mathsf T}H',
\]
so (F2), summed over the old branches, preserves the exact square invariant.

Because \(P_s\) is independent of every processed \(y\), it commutes with
taking these Fourier coefficients. Adding the new distance weight gives
\[
 C_{(q,s)}^{(i+1)}
    =\sum_z\lambda^{\mathbf1_{\{s\ne z\}}}P_sA_zP_s.
\]
Frobenius Cauchy-Schwarz for \(L\) summands, contraction by an orthogonal
projection, and (S2) give the deterministic inequality
\[
 \sum_s\|C_{(q,s)}^{(i+1)}\|_F^2
 \leq L\left(\sum_z\|A_z\|_F^2+
       \lambda^2(L/4)\sum_{z\ne z'}\operatorname{tr}(A_zA_{z'})\right).
\tag{F6}
\]
There are \(L\) diagonal and \(L(L-1)\) ordered off-diagonal terms.
Taking expectation in (F6) and using (F4)-(F5) gives exactly
\[
 \mathbb E_m\sum_s\|C_{(q,s)}^{(i+1)}\|_F^2
 \leq [1+(L-1)\lambda^2(L/4)\theta]\,M.
\tag{F7}
\]
No estimate has conditioned on the adaptively chosen new projections.
Now sum over \(q\) and average the fixed history. This proves
\(\Phi_{i+1}\leq g_{i+1}\Phi_i\).
At stage zero take \(H^{(0)}=F^{1/2}\); then
\(\Phi_0=M_0\). Induction proves (T1)-(T2).

## 5. Dimension accounting and Fourier mass

After \(i\) coordinates each coefficient matrix still has \(r\) columns.
There are \(N_i\) frequencies in a concatenation and \(N_i\) branches,
so \(U_q^{(i)}\) has exactly \(rN_i\) columns. Its row dimension is
irrelevant to the bound \(\operatorname{rank}C_q^{(i)}\leq rN_i\).

For completeness the needed rank-trace estimate can avoid any rank
formalism: for \(U\) with \(n\) columns, put \(D=U^{\mathsf T}U\).
Then
\[
 (\operatorname{tr}UU^{\mathsf T})^2
 =\left(\sum_{j=1}^nD_{jj}\right)^2
 \leq n\sum_jD_{jj}^2
 \leq n\|D\|_F^2=n\|UU^{\mathsf T}\|_F^2.
\]
Choose \(m\) with final potential at most its expectation. Applying this
inequality to every branch and Cauchy-Schwarz to the \(N_t\) branches gives
\[
 \left(\sum_q\operatorname{tr}C_q^m\right)^2
 \leq N_t\sum_q(\operatorname{tr}C_q^m)^2
 \leq rN_t^2\sum_q\|C_q^m\|_F^2.
\]
Finally
\(\operatorname{tr}C_q^m=\sum_pw(q,p)\|\widehat H_{q,p}^m\|_F^2\).
This proves (T3). If \(\operatorname{tr}F\leq B\), PSD implies
\(M_0\leq B^2\), and (T4) gives the original potential and mass bounds.
For the original hypothesis, \(L/4\leq2^{L-1}\) for all powers of two
\(L\geq2\), so its hypothesis is sufficient as well.

## Prior art, evidence, and certification boundary

The manuscript sources are the exact local targets, not external
assumptions of this proof. The finite-dimensional spectral construction,
trace inequalities, and all conditional induction steps have been
proved above. No unresolved research-literature assumption is needed.

A bounded primary-source lookup found relevant, but distinct, known
results. Audenaert et al., *The Quantum Chernoff Bound*,
arXiv:quant-ph/0610027, Theorem 1 (4), implies the binary constant.
Audenaert and Mosonyi, arXiv:1401.7658v3, Theorem 3.5 (43), pp. 16-17,
bound the error of **POVMs**, not same-space orthogonal projections, by
ordered square-root overlaps. De la Salle, arXiv:2103.14126, Theorem 1.2,
rounds a **normalized POVM** under a near-projectivity hypothesis.
None of these is assumed here. The exact general-\(L\) projection
inequality (S2) was not located by this bounded lookup; this is **not**
a verified novelty claim. In particular known POVM bounds might yield
an even stronger Fourier theorem if one changes the splitting instrument.

`Main.lean` certifies universal finite-dimensional tagged multiplication,
exact square reconstruction, the noncommutative block-trace algebra,
the squared triangle estimate, and scalar balanced and potential recurrences.
It does **not** encode the entire spectral construction or the probability
and Fourier argument. Those parts are the universal mathematical proof
above and require independent mathematical review.

`verify.py` and `exact_certificate.json` check that the successful native
Lean certificate still carries the exact current formal source and
statement-fidelity text, and replay exact rational
noncommuting splitting and rectangular tagged-channel examples, the full
channel covariance hypotheses, ordered overlap counts, and row/column
dimensions. These finite replays are regression evidence, **not** a
substitute for the universal proof. Jacobian's separately preserved exact
PSD decision checks one input matrix only.

Relative to the prior project state, which had no evidence bound to
`C9000126`, this establishes the full analytic transfer and a sharper
quantitative theorem for arbitrary parameters and rectangular dimensions.
Independent Reviewer approval and the significance/novelty assessment
remain pending; the broader campaign is not declared complete.
