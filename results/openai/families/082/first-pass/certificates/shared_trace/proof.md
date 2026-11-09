# Independent verification of the shared finite matrix estimate

## Statement and source scope

For finite-dimensional complex Hilbert spaces, arbitrary
\(W_v:H_{v+1}\to H_v\), and Hermitian \(D_v\), set
\(R_v=[W_v,W_{v-1}^*]\), \(T_v=R_v^*R_v\),
\(U_v=R_v^*D_vR_v\), and \(d=\max_v\|D_v\|_{\rm op}\).
The assertion verified here is
\[
 |\operatorname{tr}(D_0W_0D_1W_1D_2W_2)|
 \le {5\over3}d\sum_v b_{T_v}(U_v),
 \qquad
 b_P(K)={3\over2}\sum_{p_i,p_j>0}
 {|K_{ij}|^2\over\sqrt{p_i}+\sqrt{p_j}}.
\]
The sum is on the support of \(P\); \(b_0(0)=0\).

The literal sources under `research/openai_manuscript/` are:

| Manuscript directory | Source and label | Literal domain |
|---|---|---|
| `The-maximal-triangular-Hilbert-transform-at-the-symmetric-point-September-24-2026` | `build/sections/trace.tex`, `lem:mixed-trace` | Arbitrary complex maps and Hermitian insertions, coefficient \(5/3\) times \(d\) |
| `Annular-variation-of-the-triangular-Hilbert-transform-at-the-symmetric-point-October-5-2026` | `build/sections/matrix.tex`, `lem:mixed-trace` | The same complex assertion, explicitly allowing singular Grams |
| `An-L3-bound-for-the-dyadic-triangular-Hilbert-form-October-5-2026` | `build/sections/03-trace.tex`, `prop:trace` | Real maps and symmetric contractions |

This is a proof and formal verification of an assertion already stated in the
sources, not a counterexample, a new analytic transform bound, or a claim that
the coefficient is sharp. The initial campaign ledger contained no mathematical
verification evidence. The improvement is a complete kernel-checked proof of
the finite matrix assertion, rather than a scalar check or an assumed bridge.

Primary-source scope was also checked at
[`lean/docs/082.md`](https://github.com/openai/math/blob/main/lean/docs/082.md)
and its linked
[`ComparatorChallenges/TriangularHilbert.lean`](https://github.com/openai/math/blob/main/lean/ComparatorChallenges/TriangularHilbert.lean).
The latter encodes an analytic `MainEstimate`; the retrieved
`main_estimate` declaration ends with `by sorry`.
That observation concerns the retrieved comparator, not every file in that
repository and not the truth of the analytic estimate. It is not a refutation
of a staged manuscript assertion.

## A singular-safe comparison, without an external monotonicity theorem

Use the real Hilbert--Schmidt pairing
\(\langle X,Y\rangle=\operatorname{Re}\operatorname{tr}(X^*Y)\) and
\(\mathcal L_A(X)=AX+XA\).
For a supported \(K\), the spectral formula constructs a solution
\[
 Y_{ij}={K_{ij}\over\sqrt{p_i}+\sqrt{p_j}},\qquad
 Y_{ij}=0\ \hbox{on kernel entries},
 \qquad \mathcal L_{\sqrt P}Y=K.
\]
Completion of squares gives, on the full ambient matrix space,
\[
 {2\over3}b_P(K)=
 \sup_X\{2\langle K,X\rangle-
               \langle X,\mathcal L_{\sqrt P}X\rangle\}.
\]
Indeed the expression is
\(\langle K,Y\rangle-
\langle X-Y,\mathcal L_{\sqrt P}(X-Y)\rangle\).
The last term is nonnegative, and \(X=Y\) attains equality.
No inverse is taken on a zero eigenspace.

For completeness, square-root order has a short finite-dimensional proof.
If \(A=A^*\), \(B\ge0\), and \(A^2\le B^2\), let \(x\) be a unit eigenvector
of \(B-A\), with eigenvalue \(t\). If \(t<0\), then \(Ax=Bx-tx\) and
\[
 \langle(B^2-A^2)x,x\rangle
 =2t\langle Bx,x\rangle-t^2<0,
\]
contradicting the assumed order. Thus \(B-A\ge0\).
Apply this to \(A=\sqrt P\), \(B=\sqrt Q\) to obtain
\(P\le Q\Rightarrow\sqrt P\le\sqrt Q\).

This implies \(\mathcal L_{\sqrt P}\le\mathcal L_{\sqrt Q}\) as
quadratic forms. The variational identity proves \(b_P(K)\ge b_Q(K)\)
for \(K\) supported on \(P\); support inclusion follows from
\(\ker Q\subseteq\ker P\).
The more general manuscript comparison for \(P\le aQ\), \(a\ge1\),
follows also from
\(b_{aQ}(K)=a^{-1/2}b_Q(K)\), directly from the spectral denominators.
The formal proof of the main assertion only needs \(a=1\).
Thus neither the historical square-root citation nor a matrix derivative
theorem is an external assumption of this verification.

## Identifying the three costs

On \(H_0\oplus H_1\oplus H_2\), form the Hermitian matrix
\[
 M=\begin{pmatrix}0&W_0&W_2^*\\W_0^*&0&W_1\\W_2&W_1^*&0\end{pmatrix},
 \qquad D=\operatorname{diag}(D_0,D_1,D_2).
\]
Let \(B_v\) be its \(v\)-th rectangular block row.
Then \(Q=M^*M=\sum_v B_v^*B_v\), so
\(A_v=B_v^*B_v\le Q\), and
\(\sum_v K_v=M^*DM\) for \(K_v=B_v^*D_vB_v\).
Each insertion is supported on its Gram. Rectangular isometric inclusion
identifies each \((A_v,K_v)\) with the actual row star and insertion;
it changes neither cost.

The variational identity, or the quadratic three-vector inequality, yields
\[
 \mathcal E:=\sum_v b_{T_v}(U_v)
 \ge \sum_v b_{M^2}(K_v)
 \ge {1\over3}b_{M^2}(MDM).
\]
This argument works for arbitrary supported complex directions, a slightly
broader algebraic domain than the Hermitian directions needed here.

## Cubic estimate by maximal-eigenvalue induction

Diagonalize \(M\), with real eigenvalues \(m_i\), and put \(q_i=|m_i|\).
In this basis define
\[
 Q_D=\sum_{i,j}{q_i^2q_j^2\over q_i+q_j}|D_{ij}|^2,
\]
with zero-denominator terms zero. The previous comparison is
\(\mathcal E\ge Q_D/2\).

Here is an induction that does not require sorting the spectrum. In any
nonempty finite index subset choose \(a\) maximizing \(q_a\); let \(S\)
be the remaining indices. Put
\[
 \alpha=q_a^3|D_{aa}|^2,\qquad
 x_j=\mathbf1_S(j)m_jD_{ja},\qquad
 \eta=q_a\|x\|_2^2.
\]
Partition the cyclic cubic sum according to whether the index \(a\)
occurs zero, one, two, or three times. The part with no \(a\) is the
smaller induction problem. The other three parts have moduli bounded by
\[
 3d\eta,\qquad {3d\over2}(\alpha+\eta),\qquad d\alpha,
\]
respectively. For one occurrence use
\(|x^*Dx|\le d\|x\|^2\). For two occurrences use
\[
 \left|\sum_{j\in S}m_jD_{aj}D_{ja}\right|
 =|(Dx)_a|\le d\|x\|,
 \qquad
 2q_a^2|D_{aa}|\|x\|\le\alpha+\eta.
\]
For three occurrences use \(|D_{aa}|\le d\).
Hermitian symmetry is retained in each step.

The increase of \(Q_D\) upon adding \(a\) is
\[
 {\alpha\over2}
 +2\sum_{j\in S}{q_a^2q_j^2\over q_a+q_j}|D_{aj}|^2
 \ge {\alpha\over2}+\eta.
\]
The inequality uses \(q_j\le q_a\); the zero case has zero numerator.
The added cubic contribution is therefore at most
\[
 d\left({5\over2}\alpha+{9\over2}\eta\right)
 \le 5d\left({\alpha\over2}+\eta\right).
\]
Finite-set induction proves
\[
 |\operatorname{tr}((DM)^3)|\le5dQ_D\le10d\mathcal E.
\]
Repeated eigenvalues, zero eigenvalues, and repeated triple indices have
not been excluded.

## Complex phase and conclusion

Writing \(\tau=\operatorname{tr}(D_0W_0D_1W_1D_2W_2)\), the two orientations
of the three-cycle contribute \(3\tau+3\overline\tau\). Consequently
\(\operatorname{tr}((DM)^3)=6\operatorname{Re}\tau\).
If \(\tau\ne0\), take \(z=\overline\tau/|\tau|\) and replace \(W_0\)
by \(zW_0\). The stars at vertices 0 and 1 are right-multiplied by
\(\operatorname{diag}(zI,I)\) and
\(\operatorname{diag}(I,\overline zI)\), respectively.
Simultaneous unitary conjugation preserves their Grams, insertions,
and costs; the third star is unchanged. The new trace is \(|\tau|\).
The cubic estimate applied to the changed matrices thus gives
\(6|\tau|\le10d\mathcal E\), proving the assertion.
If \(\tau=0\), nonnegativity of the costs suffices.

`Main.lean` and its seven local dependency modules formalize this argument.
`verify.py` rebuilds every dependency, invokes the official Argus
`lean_evidence verify --claim C_SHARED_MIXED_TRACE` command, checks the
transitive axiom report, and runs both campaign-root validators.
The resulting `exact_certificate.json` records that actual run.
The rank-one rational-complex fixtures exercise singularity, unequal
dimensions, nonreal phase, and the zero case; they are not the proof.

Independent statement-fidelity review, novelty assessment, and any conclusions
about the three downstream analytic theorems remain separate obligations.
