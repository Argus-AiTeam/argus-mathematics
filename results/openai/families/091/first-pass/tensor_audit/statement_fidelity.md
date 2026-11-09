# Statement fidelity: universal finite-index tensor algebra

The declarations are in namespace `TensorAudit` in `Main.lean`.
The index type `iota` is arbitrary and has only a `Fintype` instance;
in particular there is no fixed dimension and no positive-dimension
restriction. An empty index type gives the trivial zero-sum instance.
A tensor is a real function of three indices. Every `normSq` is the
unweighted sum of squares over all ordered triples, and `pairing` is
the corresponding real bilinear sum.

The hypotheses are `symmetric3 S` (invariance under transpositions
(12) and (23), hence all permutations) and `lastSymmetric J`
(invariance under (23) only). They do not assert that J is fully
symmetric. `swap12 J` is J with its first two slots interchanged.
Under the last-slot symmetry, `sym J = (J_ijk+J_jik+J_kij)/3`
is full symmetrization. `fullSym` is explicitly the average over
all six permutations, without symmetry assumptions.

`defect S J` is exactly the ordered-triple sum of
`2 S_ijk^2 + 4 S_ijk J_ijk + J_ijk^2 + J_ijk J_jik`.
`tensor_squares` identifies this with
`2 normSq(S+sym J) + normSq(J-swap12 J)/6`.
This is the arbitrary-dimension algebra of manuscript
`eq:tensor-squares`, not just a scalar identity for one triple.
The preceding lemmas prove the required sum reindexings and the
symmetrization norm and pairing formulas.

`kernelTensor S J` is `K_ijk=S_ijk+J_jik`.
`fullSym_kernel` proves that its six-permutation symmetrization is
`S+sym J`. `invariant_derivative_form` proves the second exact
identity
`defect S J = normSq K/2 + 3 normSq(fullSym K)/2`.
`derivative_lower_bound` proves `normSq K/2 <= defect S J`;
`defect_nonnegative` proves `0 <= defect S J`.
These declarations together formalize exactly claim `C_TENSOR_ALGEBRA`.

In the manuscript frame with tau equal to the identity, the inputs
are `S_ijk=f_xixjxk`, `J_ijk=h_ia C_ajk`, and
`K_akl=partial_z_l P_ak`. The equality of this actual K with
`kernelTensor S J` is derived in `report.md` and checked by the
symbolic contraction verifier. It is not a hypothesis secretly
encoded as a conclusion of this Lean source.

This formal source does not encode measures, smooth functions,
Hessians, inverses, changes of variables, integrations by parts,
or compact support. Thus a successful compiler run establishes the
finite-index algebra for `C_TENSOR_ALGEBRA`, not analytic claims
`C_TENSOR`, `C_TENSOR_CALCULUS`, or `C_TENSOR_DEFECT`.
The latter have the independent mathematical proof in `report.md`
and await the Host's independent Reviewer. The compiler does not
establish novelty, publishability, or any global Brunn-Minkowski result.
