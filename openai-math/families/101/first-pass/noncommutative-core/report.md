# Exact verification of the noncommutative commutator lemma

**Result.** Lemma `mat:commutator` is valid, including its constant
`42/37`, without any extra commutation assumptions. The pointwise theorem
is proved below and in Lean 4.31.0 for arbitrary finite matrix dimension
and arbitrary finite family size. The manuscript's entropy theorem and
other analytic dependencies are **not** established by this result.
Independent Reviewer acceptance remains pending; no novelty or
campaign-level publishability claim is made.

## Statement and source fidelity

Let \(X_1,\ldots,X_k,b\) be symmetric real \(n\)-by-\(n\) matrices and
let \(w_1,\ldots,w_k\) be arbitrary real matrices of that size. Define
\[
 B=\sum_rX_r^2,\quad S=40(37I+3B)^{-1},\quad T=S-I,\quad
 F=\sum_rX_rw_r,\quad P=\operatorname{tr}(TbBb-TBb^2).
\]
Then
\[
 -P-2\operatorname{tr}((Tb-bT)F)
 -\operatorname{tr}\!\left(T\sum_rw_r^Tw_r\right)
 \le {42\over37}\sum_r\operatorname{tr}(w_r^Tw_r).                 \tag{1}
\]
Taking \(k=n=m\) gives the manuscript's pointwise statement.

The source is
`research/openai_manuscript/A-sharp-entropy-bound-and-the-simplex-inequality-for-isotropic-constants-October-5-2026/build/manuscript/matrix.tex`,
specifically `mat:chaos`, `mat:dual-constants`, `mat:dual-matrices`,
`mat:P-definition`, and `mat:commutator-bound`. In that source
\(\alpha=3/40\), \(s=40/37\), and \(1+s/8=42/37\).
In particular, \(w_r\) is not assumed symmetric.

## Universal square-completion proof

Put \(h=5/37\), \(C=Sb-bS=Tb-bT\), and \(D=S+hI\).
For every real vector \(v\),
\(v^TBv=\sum_r\|X_rv\|_2^2\ge0\). Thus \(37I+3B\), \(S\), and \(D\)
are positive definite, and \(C^T=-C\).
The right side of (1) minus its left side equals
\[
 R=P+2\operatorname{tr}(CF)+\sum_r\operatorname{tr}(w_r^Tw_rD),
                                                               \tag{2}
\]
because \(D=T+(42/37)I\).

Set \(E_r=w_r-X_rCD^{-1}\). Direct expansion, transposition, and trace
cyclicity give the exact identity
\[
 R=\sum_r\operatorname{tr}(E_r^TE_rD)
       +P-\operatorname{tr}(C^TBCD^{-1}).                       \tag{3}
\]
The two cross terms in the expansion are each
\(\operatorname{tr}(CX_rw_r)\), not its negative.
The contraction of the last square uses
\(\sum_r(X_rC)^T(X_rC)=C^TBC\).
No factor is commuted across \(X_r\), \(w_r\), or \(b\).

Choose an orthogonal eigenbasis of the real symmetric matrix \(B\),
and conjugate **all** matrices into that basis. This preserves traces,
products, transposes, symmetry, and the actual inverse defining \(S\).
Write
\[
 B=\operatorname{diag}(\beta_i),\quad
 \sigma_i={40\over37+3\beta_i}>0,\quad d_i=\sigma_i+h,\quad
 u_i={37\sigma_i\over40}>0.
\]
In these coordinates \(C_{ij}=(\sigma_i-\sigma_j)b_{ij}\), and symmetry
of \(b\) yields
\[
 \begin{split}
 P&={1\over2}\sum_{i,j}{40/3\over\sigma_i\sigma_j}\,C_{ij}^2,\\
 \operatorname{tr}(C^TBCD^{-1})
   &={1\over2}\sum_{i,j}
      \left({\beta_i\over d_j}+{\beta_j\over d_i}\right)C_{ij}^2.
 \end{split}                                                   \tag{4}
\]
Indeed, the paired coefficient of \(b_{ij}^2\) is
\((\sigma_i-\sigma_j)(\beta_j-\beta_i)\), and
\[
 \beta_j-\beta_i={40\over3}\,
             {\sigma_i-\sigma_j\over\sigma_i\sigma_j}.
 \]
These formulas also cover repeated eigenvalues and diagonal entries;
no division by an eigenvalue difference occurs.

Define \(G(u,v)=uv(u+v-3/4)+1/64\). Exact rational algebra gives
\[
 \begin{split}
 K_{ij}
 &:={40/3\over\sigma_i\sigma_j}
       -{\beta_i\over d_j}-{\beta_j\over d_i}\\
 &={64000\over4107}\,
 {G(u_i,u_j)\over\sigma_i\sigma_jd_id_j}.                         \tag{5}
 \end{split}
\]
For \(u,v\ge0\), \(G\ge0\) has this rational, two-region certificate:
if \(u+v\ge3/4\), its defining expression is a sum of nonnegative
terms. If \(u+v\le3/4\), use the exact identity
\[
 G(u,v)=
 (u+v-\tfrac12)^2\left({u+v\over4}+{1\over16}\right)
 +{(u-v)^2\over4}\left(\tfrac34-u-v\right).                      \tag{6}
\]
Every displayed weight is nonnegative on its stated region. An
alternative single identity, for \(a,b\ge0\), is
\[
 G(a^2,b^2)=(ab-\tfrac14)^2(2ab+\tfrac14)+(ab)^2(a-b)^2.
 \]
Only positivity of \(u,v\) is needed; the further restriction \(u,v\le1\)
is unnecessary.

Combining (3)--(6) gives the universal exact certificate
\[
 R=\sum_{r,i,j}d_j(E_r)_{ij}^2+
                {1\over2}\sum_{i,j}K_{ij}C_{ij}^2\ge0.          \tag{7}
\]
This proves (1) in every dimension and for every finite family size.
The finite sums and the spectral reduction, not a finite experiment,
justify the passage from scalar coefficients to the matrix statement.

For the manuscript's matrix fields, apply (1) pointwise and integrate.
All terms are integrable: \(X_r,B,S,T\) are constant finite matrices,
\(b^2,w_r^Tw_r\) are integrable, and mixed products are integrable by
Cauchy--Schwarz. This gives exactly `mat:commutator-bound`.
The Lean theorem formalizes the full pointwise matrix statement; this
last integration step is a prose consequence, not a claimed Lean theorem.

## The coefficient is optimal

Already in dimension two, take \(x\ne y\) and
\[
 X_1=\operatorname{diag}(x,y),\quad X_2=0,\quad
 b=\begin{pmatrix}0&(y-x)^{-1}\\(y-x)^{-1}&0\end{pmatrix},\quad
 w_1=\begin{pmatrix}0&1\\-1&0\end{pmatrix},\quad w_2=0.
 \]
The energy is \(2\). The left side of (1), divided by this energy, is
\[
 q(x,y)=1+{40(3xy-37)\over(37+3x^2)(37+3y^2)}.
 \]
The exact identity
\[
 {42\over37}-q(x,y)=
 {5\{9(xy-37)^2+111(x-y)^2\}\over
           37(37+3x^2)(37+3y^2)}
 \]
is checked by `verify.py` directly from the matrix traces.
Letting \(x,y\to\sqrt{37}\) with \(x\ne y\) proves that no smaller
universal coefficient is possible. This continuity argument is proved
here in prose; it is not part of the final Lean declaration.
It is a mathematical sharpness observation, not a verified novelty claim.
The ledger records it separately as `C9000101_NC_SHARP`, supported by an
Engineer judgement rather than mechanical evidence of the limit.

A particularly simple exact noncommuting example has
\(x=152/25\), \(y=609/100\), and \(b_{12}=b_{21}=100\). Its ratio is
\[
 {155571470991\over137051070991}>
 {113513\over100000},\qquad q(x,y)<{42\over37}.
 \]

## Replay and formal evidence

Run, from the campaign root, using Python 3 with SymPy
(the executed environment used SymPy 1.14.0):

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/noncommutative-core/verify.py
```

The verifier checks (5)--(6), the square-completion scalar identity,
the sharpness identities, and universal noncommutative trace identities.
Its trace checker works in cyclic transpose-word algebra with only
explicit inverse cancellations; it never replaces noncommuting matrix
letters by scalar variables. It also checks that the actual successful
Lean record and archive still match the source and fidelity text.
It does **not** pretend that inspecting a compiler record is a new compile.

As separate falsification probes, it checks 48 deterministic rational
inputs in dimensions 1, 2, and 3. The executed probes had 32 cases with
\([S,b]\ne0\), and no violations. These probes are a finite experiment,
not the proof; the exact near-saturation input is an additional case.

The full theorem is
`Commutator9000101.real_matrix_commutator_inequality`, in
`formal/Main.lean`. Its only mathematical hypotheses are symmetry of
\(X_r\) and \(b\). It constructs the spectral basis and checks the actual
matrix inverse internally. `formal/statement_fidelity.md` describes
its quantifiers, conclusion, and limits.
The real compiler run returned **exit code 0**, **proof_holes=[]**,
Lean **4.31.0**, and a successful axiom audit. The printed dependencies
are only `propext`, `Classical.choice`, and `Quot.sound`.
The registered claim is `C9000101_NC` version 2, with archive
`formal/certificates/C9000101_NC-708ad59885bf1d98.json`.

For an independent real compiler replay:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/noncommutative-core/formal/Main.lean --statement-fidelity research/noncommutative-core/formal/statement_fidelity.md --claim C9000101_NC --project-root campaigns/9000101
```

## Known inputs, scope, and manuscript impact

The standard spectral theorem was source-checked in the installed
Mathlib `Analysis/Matrix/Spectrum.lean`, specifically
`Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary` and
`Matrix.IsHermitian.spectral_theorem` at the installed v4.31.0 revision.
The formal proof invokes the former proved declaration. Positivity of
the Gram diagonal, inverse transport, trace invariance, and all
noncommutative contractions are proved inside `Main.lean`.
There is **no unproved external mathematical assumption** in the
certified matrix claim. The Wiki index search found no relevant
entropy/isotropic/commutator result. No literature novelty search is
claimed, and no analytic literature theorem is borrowed to certify (1).

The dependency ledger and graph retain their original root claims.
The broader source extraction records normalization (`tr:normalization`),
transport energy/surplus (`tr:energy`, `tr:surplus`), covariance completion,
the noncommuting expansion, the block/weighted completions, scalar
absorption, the two-eigenvalue estimate, approximation, rigidity, and the
cone reduction. Those are manuscript assertions still awaiting their
own mathematical audit, not source citations being treated as proofs.
The manuscript's external transport and regularization references were
identified but are not assumed as verified results of this mission.

The strongest prior campaign state contained only an unaudited root
claim. This work adds a complete arbitrary-dimensional verification
of a substantive algebraic dependency and an optimality argument for
its coefficient. In particular, it justifies replacing the last line
of `mat:expanded-bound` by the coefficient used in `mat:pre-pair`.
It does not certify that the preceding expansion is correct or that
the remaining estimates close the entropy proof.

The proof graph deliberately leaves even the selected node
`in_progress`, with `reviewer_confirmed=false`, until the independent
Reviewer reads and replays the artifacts. The ledger's
`closed_kernel` status describes the compiler result, not independent
acceptance or statement-fidelity approval.
