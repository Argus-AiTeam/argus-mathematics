# Statement fidelity: characteristic-wall algebra

`EnergyBridge.boundary_null_pairing` quantifies over every finite index type,
with no fixed dimension, and genuine Mathlib quaternions over the real numbers.
`pair v q` is the quaternionic Hermitian pairing sum conjugate(v_i) q_i;
`act B q` is left matrix action. Scalars of columns act on the right, exactly
as in the October manuscript. No commutation of quaternionic factors is used.

The matrices `B,R` are arbitrary quaternionic matrices. The vectors `nu,w,q,v`
are arbitrary quaternionic columns and `t` is an arbitrary real number.
The hypotheses are `Bq=Rq=0`, `nu^*q=0`, and `v^*nu=0`. The conclusion is

    v^* [B+tR+nu w^*+w nu^*] q = 0.

For the manuscript, at the wall take `B=H(B0)`, `R=H(r)`,
`nu=G(r)/|grad r|`, `w=theta |grad r| G(rho)`, and `t=theta rho`.
The Hessian product rule for `u=r rho` supplies precisely this displayed
matrix. Thus the theorem verifies the compression-kernel algebra even when
the full Hessian is indefinite. Hermitian symmetry, positive semidefiniteness,
the existence of a nonzero `q`, and the relation between the Moore determinant
and compression are NOT assumed silently or established by this declaration.
They are established in the accompanying mathematical proof.

`EnergyBridge.fiber_null_vector` proves the two differential identities for
the October holomorphic chart in every finite transverse dimension. The
auxiliary complex plane C_k is identified with Mathlib's ordinary complex
field, a commutative field isomorphism for this subclaim only. `squareSum W`
is the BILINEAR sum of the squares, not the Hermitian squared norm.
The vector is `(1,W,-sum W_i^2/2)` in `(Y,P,S1)` order. Its first component
is one; `EnergyBridge.null_vector_nonzero` separately proves it is not zero.
`ratioDifferential` is `Y dW`, and `passiveDifferential` is `dPhi` when
`P=YW`. The derivative identities here have no division by `Y`; their use as
chart differentials requires `Y!=0`, proved for the manuscript's fibers in
the mathematical proof rather than by this declaration.

`EnergyBridge.scaled_spatial_jacobian_det` proves, for EVERY finite index
type, the ordinary complex determinant identity

    det [[I,-W],[W^t,1-sum W_i^2/2]] = 1+sum W_i^2/2.

At fixed `sqrt(2) tau`, the spatial coordinates can be `(P,Y)`. This is the
Jacobian of `(W,Phi)` with its first rows multiplied by `Y`, in that order.
It is a complex determinant, NOT the Moore determinant of a general
quaternionic matrix. `EnergyBridge.chart_denominator_nonzero` proves that
the right side is nonzero whenever the complex number `S=sum W_i^2`
has norm less than two. The actual bound follows from
`|sum W_i^2|<=sum |W_i|^2<=w0^2=1/100`.

`EnergyBridge.real_compression_singular` is the real-matrix fact that a
nonzero null vector forces determinant zero, in every finite dimension.
It does not itself construct a real representation of a quaternionic
compression or prove the Moore determinant's fourth-power identity.

The helper declarations `pair_right_mul` and `act_wall` prove the ordered
finite-sum expansions used by `boundary_null_pairing`.

This formal source certifies the load-bearing finite-dimensional algebra,
not the analytic moving-domain Green identity, cofactor-divergence theorem,
Dirichlet solvability, smooth parameter dependence, scale estimates,
September entropy argument, or the local-smoothing theorem. Those distinctions
are part of the claim, not omissions to be filled by the compiler.
