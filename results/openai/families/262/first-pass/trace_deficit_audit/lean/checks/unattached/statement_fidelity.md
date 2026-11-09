# Finite complex-matrix algebraic certification

Claim: `C_TD_ALGEBRA`. Source: `Main.lean`.

## Quantification and notation

Every declaration below is in namespace `TraceDeficitCore`. Every square
matrix is an actual Mathlib `Matrix n n ℂ`, universally quantified over every
finite index type `n` with `Fintype n` and `DecidableEq n`, including the empty
type. In particular these theorems apply in every finite dimension, not just
to examples or to commuting matrices. The trace is the sum of diagonal
entries and is not an abstract trace axiom.

The scalar `i` is `Complex.I : ℂ`; `i • M` is complex scalar multiplication.
`1` denotes the identity matrix, `M ^ 2 = M * M`, `[B,M] = B*M-M*B`,
and `Mᴴ` is conjugate transpose. A Hermitian hypothesis means exactly
`Mᴴ = M`. All matrix products have their displayed order. There are no
unstated commutation, invertibility, positivity, or Hermitian hypotheses.
In particular `R*H^2` never means `H*R*H` as a matrix equality.

## Proved declarations and exact contracts

1. **`ordered_factorization`**. For every `s : ℂ` and all complex matrices
   `B,S`, without further hypotheses,
   \[
   (s1-B+iS)(s1-B-iS)=(s1-B)^2+S^2+i(BS-SB).
   \]
   The order of the two factors, and hence the commutator sign, is fixed.

2. **`riccati_averaging`**. For all `B,L,Z,W`, assume exactly
   \[
   W=(L+Z)^2+i[B,L+Z],\qquad
   W=(L-Z)^2-i[B,L-Z].
   \]
   Then both
   \[
   W=L^2+Z^2+i[B,Z],\qquad LZ+ZL+i[B,L]=0
   \]
   hold. No Hermitian hypotheses are required. The proof cancels scalar
   multiplication by `2 : ℂ`, explicitly proving that this scalar is
   nonzero; it makes no division by a matrix.

3. **`trace_deficit_sign`**. For all `B,L,Z,W,R`, assume exactly the
   two-sided inverse equations `R*L=1` and `L*R=1`, and the two matrix
   relations
   \[
   W=L^2+Z^2+i[B,Z],\qquad LZ+ZL+i[B,L]=0.
   \]
   Then
   \[
   \operatorname{tr}(RW)=\operatorname{tr}(L)
     -\operatorname{tr}(RZ^2).
   \]
   Neither this conclusion nor a trace contraction is a hypothesis.
   The proof multiplies the actual second matrix relation on the left
   and right by `R`, obtaining
   `ZR+RZ+i(RB-BR)=0`, and only then takes a trace after multiplying
   by `Z`. Cyclicity of the finite matrix trace supplies the negative
   commutator contribution. No factors are assumed to commute.

4. **`riccati_trace_deficit`**. For all `B,L,Z,W,R`, assume `R*L=1`,
   `L*R=1` and exactly the two Riccati equations in item 2. Then
   `tr(RW)=tr(L)-tr(RZ^2)`. This is the composition of items 2 and 3;
   the averaged relations are derived rather than assumed.

5. **`ordered_adjoint_square`**. For all `U,A,H,R,L`, assume that
   `U,A,H` are Hermitian, `U*A=1`, `A*U=1`, `A^2=R`, and `U^2=L`.
   Then the ordered matrix identity is
   \[
   (U-AH)^{\!H}(U-AH)=L+HRH-2H.
   \]
   Here `2H` is `(2 : ℂ) • H`. No commutation of `A,H` or `R,H`
   is assumed.

6. **`ordered_adjoint_square_trace`**. With precisely the hypotheses
   of item 5,
   \[
   \operatorname{tr}((U-AH)^{\!H}(U-AH))
     =\operatorname{tr}(L+RH^2-2H).
   \]
   Only trace cyclicity, not a reordering of the underlying matrices,
   changes `HRH` into `RH^2`.

7. **`gram_trace_identity`**. For all `A,Z,R`, assume `A,Z` Hermitian
   and `A^2=R`, with no commutation or inverse hypotheses. Then
   \[
   \operatorname{tr}(RZ^2)
     =\operatorname{tr}((AZ)^{\!H}(AZ)).
   \]
   In the proof the actual Gram matrix is `ZRZ`, not `RZ^2`.

8. **`gram_trace_re_nonneg`**. For every pair of finite index types
   `m,n` and every rectangular complex matrix `X : Matrix m n ℂ`,
   \[
   0\le \operatorname{Re}\operatorname{tr}(X^{\!H}X).
   \]
   This is elementary finite Gram positivity, proved from the sum of
   the nonnegative squared complex norms of all entries. No Hermitian,
   rank, or nonempty-dimension hypothesis is needed.

9. **`ordered_adjoint_square_trace_re_nonneg`**. With exactly the
   hypotheses of item 5,
   \[
   0\le \operatorname{Re}\operatorname{tr}(L+RH^2-2H).
   \]
   This is a finite-matrix corollary of items 6 and 8, not an analytic
   square-root existence or positivity assertion.

## Deliberate scope limits

This source does **not** formalize analytic half-line existence, analytic
positivity, integration, or the original full trace theorem. In particular
it does not assert existence of Riccati solutions, spectral or functional
calculus square roots, their positivity or invertibility, half-line
differential equations, boundary/asymptotic estimates, interchange of
integrals and traces, convergence, gapless extension, or any result about
infinite-dimensional operators. Matrices corresponding informally to
`U=R^(-1/2)`, `A=R^(1/2)`, or `H=(t1+D)^(1/2)` must independently
satisfy the displayed finite algebraic hypotheses. The only positivity
formalized here is the explicit finite Gram real-part inequality.

There are no local axioms, `sorry`, `admit`, or assumptions replacing any
of these conclusions. Certification is to be established by the actual
Lean 4.31.0 compiler via the official `lean_evidence verify` command.
