# Exact tensor verification and an invariant defect identity

## Result and scope

Under precisely the hypotheses of `tensor.tex`, `lem:tensor`, both
`eq:tensor-estimate` and `eq:tensor-energy` follow from the identity below,
in every positive dimension and for every real compact smooth test. No
evenness of the test or potentials, commutativity of matrices, convexity
of V, or uniform lower bound on the source Hessian is added.

This is a proof of the tensor lemma, not of `thm:main`. The existence
theorem `lem:moment`, the range-closure theorem `lem:density`, and the
downstream variance and volume arguments are separate, unresolved audit
obligations. No false manuscript assertion has been established here.
In particular there is no invented `F_` refutation claim.

The strongest prior result actually read for this step is the staged
manuscript's inequality and its normalized sum of squares. The extension
here is a globally invariant exact defect, a coercive derivative
remainder, and its compact-support equality case. Novelty relative to
the external literature is **not established**; this bounded mission
does not declare the publishable campaign complete. The background
citations to Bakry--Emery and Kolesnikov--Livshyts--Rotem are not used
as assumptions: all the identities needed here are derived below.

## The exact verification theorem

Retain the manuscript definitions, including its **matrix square**:

\[
 \tau=D_z^2\varphi,\quad M=\tau^{-1},\quad
 h=D_x^2f,\quad P=\tau h,\quad B=\tau h\tau,\quad
 W=\delta_\mu B,\quad u=\delta_\mu W,\quad H=D_x^2V.
\]

Put \(R=D_zW-B\) and define the covariant three-tensor

\[
 K_{abl}=\tau_{bk}\partial_l P_{ak}.
\]

It is symmetric in its first and third slots. For any covariant
three-tensor \(L\), use the positive definite norm

\[
 |L|_M^2=M_{aa'}M_{bb'}M_{ll'}L_{abl}L_{a'b'l'}.
\]

Here \(\operatorname{Sym}\) is full symmetrization over three slots.
Then

\[
\boxed{
\begin{aligned}
 \mathbb E[\operatorname{tr}((D_xW)^2)-\operatorname{tr}(MBHB)]
 &=\mathbb E[u^2-W^THW-\operatorname{tr}(MBHB)]\\
 &=\mathbb E\left[\operatorname{tr}(MRMR)
       +\tfrac12|K|_M^2+\tfrac32|\operatorname{Sym}K|_M^2\right].
\end{aligned}}
\tag{T}
\]

In particular each manuscript inequality holds, with the additional
nonnegative remainder \(\frac12\mathbb E|K|_M^2\).
Equality in either manuscript inequality holds exactly when \(f=0\).
The coefficient \(1/2\) is not asserted to be an optimal *integrated*
constant.

## Complete derivation

### 1. Support, adjoints, and the gradient identity

The inverse diffeomorphism sends the compact support of f to a compact
set in source coordinates. Every differentiated test field is supported
there. The smooth positive matrix M and all coefficients are bounded
on that set. Thus all integrals below exist; local positive
definiteness is sufficient.

Write \(\partial_k=\partial_{z_k}\). Since
\(\nabla_z\varphi=x\), the compact weighted adjoint is
\(\partial_k^*=x_k-\partial_k\). The chain rule
\(\partial_k g=\tau_{ik}g_{x_i}\) and weighted integration by parts
give the manuscript's `eq:row-adjoint`:

\[
 \partial_k^*P_{ak}=(\delta_\mu(P\tau))_a.
\]

This follows first by testing against arbitrary compact g, and then
pointwise because both fields are smooth. In particular
\(W_a=\partial_k^*P_{ak}\).

Let \(C_{ijk}=\varphi_{ijk}\), a fully symmetric tensor. Direct expansion,
without commuting matrices, gives

\[
 W_a=x_k\tau_{ai}h_{ik}-C_{aik}h_{ik}
       -\tau_{ai}\tau_{jk}f_{x_ix_kx_j}.
\]

For \(A=x\cdot\nabla_x-\tau:D_x^2\), differentiating
\(((A-1)f)(x(z))\) gives the same expression. This proves
`eq:W-gradient` and makes \(D_zW\) symmetric. Also
\([\partial_l,\partial_k^*]=\tau_{kl}\), whence

\[
 D_zW=B+R,\qquad R_{al}=\partial_k^*\partial_lP_{ak}.
\tag{1}
\]

B is symmetric, so R is symmetric. This is the essential symmetry
that justifies \(\operatorname{tr}(MRMR)\ge0\), not an assumption
that \(D_xW\) itself is symmetric.

For arbitrary compact W, differentiate \(u=V_jW_j-\partial_jW_j\)
and integrate by parts once to obtain the exact weighted identity

\[
 \mathbb E u^2=\mathbb E W^THW+
       \mathbb E(\partial_{x_j}W_i)(\partial_{x_i}W_j).
\tag{2}
\]

This is `eq:bochner`. Its last term is a matrix-square trace, not
the Frobenius norm of \(D_xW\).

### 2. Inverse derivatives and the twice-differentiated moment equation

The pushforward Jacobian gives
\(V(x(z))=\varphi+\log\det\tau-\log Z\).
Differentiation of \(M\tau=I\) gives

\[
 \partial_iM=-MC_iM,\qquad
 \partial_j\partial_iM
 =MC_jMC_iM+MC_iMC_jM-M(\partial_jC_i)M.
\tag{3}
\]

Both orders of the noncommuting product are retained.
With \(c_i=\operatorname{tr}(MC_i)\), the first and second
moment derivatives are

\[
 \tau_{ik}V_k=x_i+c_i,\qquad
 (\tau H\tau)_{ij}
 =\tau_{ij}+M_{kl}\varphi_{klij}
       -\operatorname{tr}(MC_iMC_j)-C_{ijk}V_k.
\tag{4}
\]

The inverse derivative and the full symmetry of C imply

\[
 \partial_dM_{dk}=-c_bM_{bk},\qquad
 \partial_dM_{dk}-x_dM_{dk}=-V_k.
\]

Full symmetry of \(D_z^4\varphi\), applied to (4), now gives exactly
`eq:twice-moment`:

\[
 (\tau H\tau-\tau)_{ij}
 =(\partial_d-x_d)(M_{dk}C_{ijk})
       -\operatorname{tr}(MC_iMC_j).
\tag{5}
\]

### 3. Original contractions and the divergence correction

Since \(D_xW=(B+R)M\) and \(MBM=h\), expansion and one compact
source integration by parts give `eq:trace-expansion`:

\[
 \mathbb E\operatorname{tr}((D_xW)^2)
 =\mathbb E\operatorname{tr}(MBMB)
  +2\mathbb E(\partial_kh_{al})(\partial_lP_{ak})
  +\mathbb E\operatorname{tr}(MRMR).
\tag{6}
\]

Cyclic trace, rather than matrix commutativity, makes the coefficient
of \(\tau H\tau\) in \(\operatorname{tr}(MBHB)\) equal to
\(Q=MBMBM=h\tau h\). Substitute (5) and integrate its divergence:

\[
 \mathbb E\operatorname{tr}(MBHB)
 =\mathbb E\operatorname{tr}(MBMB)
 -\mathbb E(\partial_dQ_{ij})M_{dk}C_{ijk}
 -\mathbb E Q_{ij}\operatorname{tr}(MC_iMC_j).
\tag{7}
\]

This is `eq:H-expansion`, including both minus signs.
For a pointwise check of the two integrations by parts define

\[
 U_k=2h_{al}\partial_lP_{ak}+Q_{ij}M_{kr}C_{ijr}.
\]

Equations (1) and (5), using the ordinary product rule, give

\[
\begin{split}
 \operatorname{tr}((D_xW)^2)-\operatorname{tr}(MBHB)
 ={}&\operatorname{tr}(MRMR)
   +2(\partial_kh_{al})(\partial_lP_{ak})\\
 &+(\partial_dQ_{ij})M_{dk}C_{ijk}
   +Q_{ij}\operatorname{tr}(MC_iMC_j)
   +(x_k-\partial_k)U_k.
\end{split}
\tag{8}
\]

U is compact, so the expectation of the final term is exactly zero.
This identifies the boundary term explicitly; no finite pointwise
test of the raw difference is being passed off as an integrated
counterexample or proof.

### 4. Constant-coordinate normalization

At a fixed point choose the constant \(T=\tau^{-1/2}\) evaluated
at that point, and set
\(z=Tz'\), \(x'=T^Tx\), \(f'(x')=f(T^{-T}x')\).
The probability potentials transform as

\[
 \varphi'(z')=\varphi(Tz')-\log|\det T|,\quad
 V'(x')=V(T^{-T}x'),\quad Z'=|\det T|Z.
\]

They preserve the moment equation and both probabilities. The
transformation laws are precisely those listed in `tensor.tex`:
\(\tau,B,R\) transform by \(T^T(\cdot)T\);
\(M,h,H,Q\) by \(T^{-1}(\cdot)T^{-T}\);
\(P,D_xW\) by \(T^T(\cdot)T^{-T}\); and W by \(T^T\).
Every source derivative and every slot of C transforms covariantly.

Consequently each repeated index in (6)--(8) pairs one covariant
with one contravariant index. All displayed scalar contractions are
invariant. In particular \(K'_{abl}=T_{ia}T_{jb}T_{kl}K_{ijk}\),
so its norm and its full symmetrization have invariant meanings.
This is a constant coordinate change after the integrations by parts,
not a differentiated moving frame.

### 5. All three normalized contractions and positivity

In the resulting frame \(\tau=M=I\), put
\(S_{ijk}=f_{x_ix_jx_k}\), \(J_{ijk}=h_{ia}C_{ajk}\), and
\(J^{12}_{ijk}=J_{jik}\). S is fully symmetric; J is symmetric
in its last two slots. Direct index expansion gives

\[
\begin{aligned}
 2(\partial_kh_{al})(\partial_lP_{ak})
     &=2|S|^2+2\langle S,J\rangle,\\
 (\partial_dQ_{ij})C_{ijd}
     &=2\langle S,J\rangle+\langle J,J^{12}\rangle,\\
 Q_{ij}\operatorname{tr}(C_iC_j)&=|J|^2 .
\end{aligned}
\tag{9}
\]

These are `eq:normalized-cross`, `eq:normalized-derivative`, and
`eq:normalized-cubic`. For example the middle-factor derivative in
\(Q=h\tau h\) is
\(h_{ia}C_{abd}h_{bj}C_{ijd}\), exactly
\(\langle J,J^{12}\rangle\), not \(|J|^2\).
The two derivatives of h each give \(\langle S,J\rangle\).

Dummy-index permutations, with only the stated symmetries, give

\[
 |\operatorname{Sym}J|^2
   =\frac{|J|^2+2\langle J,J^{12}\rangle}{3},\qquad
 \langle S,\operatorname{Sym}J\rangle=\langle S,J\rangle.
\]

Thus the sum of (9) is exactly `eq:tensor-squares`:

\[
 2|S|^2+4\langle S,J\rangle+|J|^2+\langle J,J^{12}\rangle
 =2|S+\operatorname{Sym}J|^2+\tfrac16|J-J^{12}|^2.
\tag{10}
\]

In the same frame the actual derivative tensor is
\(K_{akl}=S_{akl}+J_{kal}\). Hence

\[
 |K|^2=|S|^2+2\langle S,J\rangle+|J|^2,\quad
 |\operatorname{Sym}K|^2
 =|S|^2+2\langle S,J\rangle+
       \frac{|J|^2+2\langle J,J^{12}\rangle}{3}.
\]

The value in (10) is therefore
\(\frac12|K|^2+\frac32|\operatorname{Sym}K|^2\).
Invariance, (8), and compact weighted adjunction prove (T).
Finally
\(\operatorname{tr}(MRMR)
=\|M^{1/2}RM^{1/2}\|_{\mathrm{HS}}^2\ge0\)
because R is symmetric. No replacement of the original
matrix-square trace has occurred.

### 6. Equality

If either manuscript inequality is equality, (T) forces
\(\mathbb E|K|_M^2=0\). The density is everywhere positive and K
is continuous, so K is identically zero. Since tau is invertible,
\(\partial_lP_{ak}=0\) everywhere. Thus P is constant on the connected
source space and is zero by compact support. Then h is zero, so f
is affine and compactly supported, hence identically zero. The converse
is immediate.

## Evidence boundaries and replay

`verify.py` checks the contraction algebra with dummy-index
canonicalization (not dimension sampling), inverse identities in a
noncommutative word algebra, covariance by dual-index balance, and
the complete pointwise flux identity on exact noncommuting polynomial
jets as a separate diagnostic. It also checks the saved typed Jacobian
result and the freshness and source binding of the genuine Lean
certificate. The original W-gradient, weighted commutator, and Bochner
divergence correction also have universal index checks. Finite jet
checks are never the all-dimensional proof.

`Main.lean` and `statement_fidelity.md` describe the universally
quantified finite-index algebra only. The real compiler certificate
does **not** formalize change of variables, differentiation, integration
by parts, smooth support, or the analytic statement (T). Those are
proved above and require the independent Reviewer. The full lemma is
not to be labelled `closed_kernel` merely because its algebra compiles.

The official Lean 4.31.0 run returned exit code 0, an empty proof-hole
list, and a successful axiom audit. Its archived claim certificate is
`certificates/C_TENSOR_ALGEBRA-44a88876aacc1067.json`.
No lakefile was created; the supplied built Mathlib workspace was used.

Jacobian 0.14.0, protocol `2025-11-25`, computed the inertia of the
orbit-averaged four-scalar Gram matrix using
`matrix.inertia.compute`. The exact payload, inspected contract, typed
output, and adapter status are separate JSON files. The verifier
independently reconstructs its Gram decomposition and rank, obtaining
inertia (3,0,1). An initial payload listing both triangles was rejected
as `INVALID_REQUEST`; its exact payload and structured error are
preserved under `jacobian_rejected_*`. That rejection has no mathematical
verdict. The successful payload lists the upper triangle once.

Replay from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/tensor_audit/verify.py
```

The certified run passed 12 dimension-free contraction identities,
7 noncommutative/product-rule identities, 7 dual-index covariance
checks, and 3 separately classified exact finite jet diagnostics,
each with 8 additional nonorthogonal-coordinate scalar residuals zero.

Only Python and SymPy are needed for this replay; it checks, rather
than resubmits, the archived Jacobian and Lean results. A fresh kernel
run, if desired by the independent Reviewer, is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/tensor_audit/Main.lean --project-root . --statement-fidelity research/tensor_audit/statement_fidelity.md --claim C_TENSOR_ALGEBRA
```
