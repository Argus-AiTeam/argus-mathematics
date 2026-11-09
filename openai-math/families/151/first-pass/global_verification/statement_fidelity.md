# Exact scope of the real-pair spectral bridge

This document describes only claim `C_PAIR_BRIDGE`, not the complete
entropy-counterexample theorem.

`GlobalSpectralBridge.real_pair_iff_complex_eigen` quantifies over every
finite index type, every square matrix `A` over the real numbers, every
real `a,b`, and every pair of real coordinate vectors `u,v`. Empty index
types are allowed; both sides then exclude the zero vector.

`complexMatrix A` applies the actual embedding of the real numbers into
the complex numbers entrywise. `combine u v` is the vector `u + i v`.
The theorem equates exactly:

* `(u != 0 or v != 0)`, `Au = au - bv`, and `Av = bu + av`;
* a nonzero vector `u + iv` satisfying
  `A_C (u + iv) = (a + ib)(u + iv)`.

The sign in the eigenvalue is **plus**. The second displayed paired
equation is exactly the one in the frozen OpenAI
`Definitions.totalRealHomologySpectralRadius`. No independence of `u`
and `v` is assumed, so real eigenvalues and degenerate real pairs are
included, not discarded.

`GlobalSpectralBridge.paired_modulus` quantifies over all real `a,b` and
identifies the ordinary complex norm of `a+ib` with the nonnegative
square root of `a^2+b^2`, including zero.

These are universal finite-dimensional algebraic identities, not finite
experiments. Passing from one coordinate matrix to a finite-dimensional
real linear map is a choice of basis. Passing from the union over
homological degrees to the total spectral radius additionally uses
finite-dimensionality and vanishing above the manifold dimension;
those topological facts and the finite-union argument are proved or
explicitly cited in `report.md`, not asserted to be formalized here.
The source does not prove regularity, entropy, homology comparison, a
specific characteristic polynomial, novelty, or independent acceptance.
