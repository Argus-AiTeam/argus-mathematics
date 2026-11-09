# Statement fidelity: the nontrivial pruning algebra

`Main.lean` imports the host's built Mathlib on Lean 4.31.0. All the
declarations below are in namespace `PruningAudit`. They are universal
theorems, not computations on the supplementary Python instance.

## Objects and hypotheses

The scalar `K` is any field. Function spaces are coordinate vector spaces
over `K`. All indices that are summed over, and all spaces whose finite
dimension is used, have explicit finiteness assumptions. Empty types
are allowed; no `Nonempty` assumption is present.

`Supported T D` means every entry outside the predicate `T` is zero.
An entry inside `T` is allowed to be zero. The maximum-support-rank
hypothesis compares `D` with *all* matrices having this support
restriction, not merely with matrices obtained from a globally shared
array. This is the manuscript's local maximum-support property, which
section 1 of `pruning_theorem.md` establishes simultaneously by one
explicit shared assignment.

## Declarations and conclusions

`perturbation_kernel_product` concerns a linear map `D : U -> V`,
a coordinate-like functional `q : U -> K`, a vector `z : V`, a
functional `y : V -> K`, and `x : U`. If `D x = 0`, `y` annihilates
the image of `D`, and the rank of `D + q.smulRight z` is at most
the rank of `D`, it proves `q x * y z = 0`. Its dimension hypothesis
is on `V`. This is a proved perturbation argument, not an axiom.

`support_maximal_kernel` specializes that result to a finite matrix
`D : Matrix S J K`, right kernel vector `x`, left kernel vector `y`,
and an allowed position `(s,j)`. With the maximum-support-rank
hypothesis above, it proves `x j * y s = 0`. The rank is the finite
dimension of the range of `Matrix.toLin' D`.

`H` and `Z` use four possibly different coordinate types `P,I,S,J`,
relations `first : P -> I -> Prop`, `second : S -> J -> Prop`,
and families `R : P -> J -> Prop`, `C : I -> S -> Prop`.
Their existential definitions are exactly the two opposite conflict
corners, `(p,s)` and `(i,j)`, respectively. In the manuscript
application all four coordinate types are `X` and both relations are
the given arrow relation. No orientation, irreflexivity, or disjointness
of the coordinate sets is imposed.

`localMatrix R C b p i` is the full `S x J` array `b`, zeroed outside
`C i s AND R p j`. It is the zero-padded version of the restricted
matrix `D^{p,i}`; deleting the padded zero rows and columns preserves
rank and both restricted kernel equations.

`conflict_kernel` assumes that `b s j` vanishes off `second`,
that `u p j` and `v i s` vanish off their respective families, that
the full `B` sum is zero for each coordinate *present in H*, and
that the full transpose-`N` sum is zero for each coordinate
*present in Z*. It also assumes maximum support rank of each
`localMatrix` for `first p i`. It proves

    u p j * v i s = 0

for every `R p j`, `C i s`, `first p i`, `second s j`.
It derives the zero equations for absent `H` rows and `Z` columns;
it does not assume those coordinates exist. The theorem quantifies
over all such `u,v`, not just the particular lifts. The interpretation
as actual global kernels is justified by the exact row equations and
zero extensions in sections 3-4 of `pruning_theorem.md`.

`lift_images_independent` concerns arbitrary maps `B` and `Nt` and
endpoint functions `r,c` indexed by finite `M`. The control hypothesis
is the preceding universal product-zero assertion on the two kernels
at all these endpoints. It assumes `Nt(v m)=0`, `v m(c m)=1`,
and `u m(r n)` equal to the Kronecker delta. It concludes the linear
independence of `B(u m)`, not merely of `u m`.

`kernel_lifts_dimension` adds maps `L,N,A`, the identity `A.comp B =
N.comp L`, and `L(u m)=0`. It proves

    Fintype.card M <= finrank K A.ker.

`Nt` is an arbitrary map in these abstract lift theorems; in the
manuscript it is chosen to be the transpose of `N`. No property
relating `Nt` to `N` is needed beyond the explicit control hypothesis,
which the concrete `conflict_kernel` theorem supplies.

`composition_rank_bound` proves the Sylvester-type inequality

    rank L + rank N <= dim V + rank(N.comp L)

for maps `L : U -> V`, `N : V -> W` with finite-dimensional `V`.
Its proof constructs the injection of the restricted kernel into
`ker N`.

`augmented_rank_bound` combines the lift and composition theorems.
With the same explicitly listed map, control, and lift hypotheses,
it proves

    |M| + rank L + rank N <= |H| + |Z|.

**Here Lean's `M` indexes only the `k` original--original matching
edges. It is not the whole matching called `mathcal M` in the
manuscript.** The application uses `rank L = ell`, `rank N = t`;
hence the left side becomes the full matching size `k+ell+t`.
`R,C,H,Z` in this last theorem are finite coordinate-index types,
not sets automatically identified when displayed coordinates agree.

## What is and is not certified by the compiler

The compiler checks maximum-support kernel orthogonality, the full
nontrivial kernel transfer, lift-image independence, the kernel
dimension bound, and the final dimension inequality. None assumes
the desired augmented matching bound or the pruning conclusion.

The explicit positive integer assignment, its structural determinant
argument, the choice and properties of the graph matching, the
construction of the basis lifts from it, identification of concrete
zero-extended row equations with the four maps, and the
alternating-path cover and retention argument are proved in
`pruning_theorem.md`, but are not encoded as Lean declarations.
Thus this is a formal certification of the load-bearing algebraic
core paired with a complete universal mathematical proof, not a
claim of end-to-end formalization of graph pruning.

Only the field and the explicitly stated theorem hypotheses are
assumed in the formal source. It contains no added axioms, proof
holes, native decision procedures, or unproved imported manuscript
claims. The final axiom reports expose the usual Mathlib foundations.
Independent review must still verify this reading and the prose
bridge to the manuscript; compilation alone cannot do either.
