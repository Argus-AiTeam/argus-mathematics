# Statement fidelity: finite-dimensional quenched rigidity core

The declarations in `Main.lean`, namespace `QuenchedRigidity`, certify
finite-dimensional algebra used in the theorem in `report.md`. They do not
formalize probability densities, differential entropy, conditional laws, heat
flow, ergodicity, tree Green-function existence, or random-graph universality.
No theorem in this file identifies a probability law by itself.

## Tensor color blocks

`dot`, `tensor`, `pairing`, and `basis` are explicit real coordinate formulas.
`pairing_tensor` is their tensor-product pairing identity.
`block_pair_identity` follows from a self-adjoint real linear operator `H`
whose action on each subspace `a_i tensor R^C` is given by a color operator
`D_i`. `color_blocks_agree` proves that all `D_i` agree whenever every spatial
pairing `dot(a_i,a_j)`, including the diagonal pairings, is nonzero.
The spatial and color index types are arbitrary finite types, not fixed
dimensions. `common_block_on_sums` proves the resulting action on every finite
sum of these generating blocks. Spanning of the residual spatial subspace and
its identification with the tree reading directions are proved in prose,
not encoded as conclusions of this declaration.

## Precision and residual geometry

`one_sided_determinant` is the numerator determinant of the one-sided
precision. `one_sided_positive` proves strict positivity of its quadratic
form for every real `b>0` and nonzero coordinate pair.
`edge_determinant_scaled` proves the oriented edge determinant after
multiplication of the precision by `b*v`; the opposite endpoint uses the
reversed-coordinate precision, not a second copy in the same orientation.
`edge_discriminant_gap` and `edge_discriminant_positive` prove the exact
sum-of-squares lower bound and nondegeneracy for arbitrary `b,v>0`.

`residual_pair_gap`, `residual_pair_gap_positive`, and
`residual_off_diagonal_negative` are the unnormalized Gram identities.
For distinct incoming branches, `x,y` are their positive imaginary parts,
`B` is the total, and `B-x-y>0` follows from a third positive branch.
No bounded sample of degrees or potentials is involved.

`star_rank_one_scalar` simplifies the determinant-lemma expression for a
retained star. Here `S` is the sum of retained branch imaginary parts, `b`
is the omitted branch imaginary part, `P` is the product over retained
branches, and `t` is the real Schur denominator. It certifies this scalar
rational identity under the three stated nonzero denominators; it does not
itself prove a matrix determinant lemma.

## Zero-correlation-safe re-rooting

`edge_hessian_entry_constant` and `edge_hessian_constant` say that
`q^2 H(x)+r^2 B=D` with constant color blocks `B,D` and `q!=0`
forces `H` constant. These declarations require neither `r!=0` nor
`r^2+q^2=1`. In the probability argument, `r` is the endpoint correlation
and `q=sqrt(1-r^2)>0`; the displayed identity comes from the constant
complementary Hessian at the other endpoint.

`edge_covariance_swap_entry` and `edge_covariance_swap` assume
`r^2+q^2=1`, `q!=0`, and all three explicitly displayed compatible endpoint
covariance equations. They conclude `C_0=S_1` and `C_1=S_0`, for every
color entry, even when `r=0`. They do not conclude `S_0=S_1` without an
additional hypothesis.

`two_step_covariance` is the exact combinatorial consequence of this swap:
two neighbors of one vertex have the same root color covariance.
The further ergodic argument identifying both parity classes is in prose.
`covariance_normalization` identifies a color matrix entrywise from
`k*S=Sigma`, assuming only `k!=0`; the application has
`k=E Im(m_o)>0` and `Sigma=I_m` in the manuscript.

## Inherited and unverified parts

Applying these lemmas to the manuscript still assumes the source assertions
registered as `TREE_BOUNDARY_SOURCE`, `MARKED_LAW_SOURCE`, and
`CONDITIONAL_ENTROPY_SOURCE`. The independent Reviewer must check the
analytic proof and the reading from the formal declarations to that proof.
A compiler verdict on this file must not be reported as a compiler verdict
on `prop:gaussian-marks` or on either universality theorem.
