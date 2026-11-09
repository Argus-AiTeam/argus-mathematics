# Statement fidelity: the complete shared mixed-trace inequality

The declaration described here is `SharedTrace.mixed_trace_estimate` in
`Main.lean`. Its conclusion is the full complex absolute-value inequality
labelled `lem:mixed-trace` in the maximal and annular manuscripts. The dyadic
manuscript's `prop:trace` is the real symmetric contraction specialization.
This document does not identify a proof of the matrix assertion with a proof
of any triangular Hilbert transform estimate.

## Objects and quantifiers

The theorem quantifies over three independently arbitrary types `n0`, `n1`,
and `n2`, each with `Fintype` and `DecidableEq`, and over

- `W0 : Matrix n0 n1 Complex`, `W1 : Matrix n1 n2 Complex`,
  `W2 : Matrix n2 n0 Complex`;
- square matrices `D0`, `D1`, `D2` on their respective vertex types;
- exactly the three hypotheses `D0.IsHermitian`, `D1.IsHermitian`,
  and `D2.IsHermitian`.

There is no assumption of equal cardinalities, nonempty index types,
invertibility, positive eigenvalues, diagonal insertions, real entries,
positive insertions, or a prescribed complex phase. A rectangular matrix
represents the map from its column space to its row space. Choosing
orthonormal coordinates identifies these objects with the finite-dimensional
complex Hilbert spaces and maps in the manuscripts. The formal theorem is
stated in coordinates, not using an additional quantifier over abstract
Hilbert spaces.

The three `let` bindings in the conclusion are exactly

\[
 R_0=[W_0,W_2^*],\qquad R_1=[W_1,W_0^*],\qquad R_2=[W_2,W_1^*].
\]

Their column types are respectively `n1 + n2`, `n2 + n0`, and `n0 + n1`
(disjoint sums of types). No padding or dimension identification is a
hypothesis of the theorem.

## Norm, cost, and conclusion

The left side is
`norm (Matrix.trace (D0 * W0 * D1 * W1 * D2 * W2))`.
For a complex scalar this norm is its modulus, not its real part.

Every operator norm on the right is explicitly the norm of
`Matrix.toEuclideanCLM Dv`, the induced norm on complex Euclidean space.
The default entrywise matrix norm is not substituted for it. The nested
`max` is precisely \(D_*=\max_v\|D_v\|_{\mathrm{op}}\).

For \(P=R^*R\), `SharedTraceHessian.b` is defined by a canonical
orthonormal spectral decomposition of \(P\):

\[
 b_P(K)=\frac32\sum_{i,j}
 \frac{|(U^*KU)_{ij}|^2}{\sqrt{p_i}+\sqrt{p_j}}.
\]

Real division by zero in this initial definition is zero.
This convention alone is **not** being used to reinterpret the manuscript's
supported Hessian. `SharedTraceHessian.supported_gram` proves that both
\(R^*DR\) and its adjoint annihilate \(\ker(R^*R)\), even for a
non-Hermitian \(D\). `SharedTraceHessian.b_spectral_positive` then proves
that, on these supported directions, the displayed sum equals exactly
the sum restricted to \(p_i>0,p_j>0\). In particular all entries touching
the kernel vanish, and \(b_0(0)=0\).
`SharedTraceAssembly.rowCost_spectral_positive` specializes this equality
to every term in the final theorem. Thus the costs are exactly the
manuscript's costs, not regularized or alternative quadratic forms.

The coefficient in the conclusion is the real number \(5/3\).
The complete right side is
\[
 \frac53D_*\left[
 b_{R_0^*R_0}(R_0^*D_0R_0)+
 b_{R_1^*R_1}(R_1^*D_1R_1)+
 b_{R_2^*R_2}(R_2^*D_2R_2)\right].
\]

## Load-bearing declarations actually proved

`SharedTraceHessian.sqrt_mono` proves finite-dimensional square-root order,
including singular endpoints. `b_antitone` proves order comparison for
arbitrary supported complex directions; `b_three` proves the three-vector
quadratic inequality. `common_metric_three` combines them.
`b_isometry` and `rowCost_isometry` prove the rectangular padding
identifications, which `triangle_common_metric` applies to the actual stars.

`SharedTraceAssembly.cubicSum_bound_unsorted` uses finite-set induction
choosing a largest absolute eigenvalue. It has no sorted-spectrum hypothesis.
`b_diagonal_square`, `hermitian_cubic_bound`, and
`hermitian_cubic_rowCost` supply the complete arbitrary-spectrum cubic bound.
They do not assume the disputed common-metric comparison.

`triangle_trace_cube` proves that the two orientations give
\(6\operatorname{Re}\tau\), where
\(\tau=\operatorname{tr}(D_0W_0D_1W_1D_2W_2)\).
`rowCost_fromCols_phase`, `exists_aligning_phase`, `tau_phase`, and
`energy_phase` prove the one-edge phase argument used by the final theorem.
The theorem does not assume \(\tau\) is real.

The local source dependencies, rebuilt by `verify.py`, are
`cubic/SpectralCubic.lean`, `hessian/Hessian.lean`,
`assembly/General.lean`, `assembly/Blocks.lean`, `assembly/Trace.lean`,
`assembly/Phase.lean`, and `assembly/Projections.lean`.
The final declaration's transitive axiom report must contain only
`propext`, `Classical.choice`, and `Quot.sound`.

## Limits of the certification

The compiler checks the encoded theorem and its proof, not this document's
interpretation. An independent Reviewer must check this interpretation.
The formalization does not prove that the algebraically defined cost is the
second derivative of \(\operatorname{tr}(P^{3/2})\) in an analytic calculus;
the manuscript defines the same cost by its spectral/inverse-Lyapunov formula.
It does not prove heat identities, mask bounds, dyadic conditional averaging,
frequency-block estimates, density statements, maximal estimates, or
annular variation bounds. It neither refutes the manuscripts nor establishes
novelty of their mathematical inequality or optimality of the constant.
The exact finite fixtures in `verify.py` are calibration checks, not the
universal proof.
