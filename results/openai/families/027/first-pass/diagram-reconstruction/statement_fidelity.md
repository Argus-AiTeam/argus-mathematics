# Formal statement fidelity

This source certifies two algebraic cores, not the entire surface-diagram
theorem. The ledger claim is `C_FORMAL_RECONSTRUCTION_CORE`.

## Complementary swap

`DiskReconstruction.swapP`, `swapI`, `swapR`, and `swapS` are the following
maps, universally quantified over five arbitrary additive commutative groups
`A`, `B`, `H`, `X`, and `Y`:

```
U = A x B x H
M = (A x H x X) x (B x H x Y)
Q = H x X x Y
P(a,b,h) = ((a,h,0),(b,h,0))
I((a,hA,x),(b,hB,y)) = (hA-hB,x,y)
R((a,hA,x),(b,hB,y)) = (a,b,hB)
S(h,x,y) = ((0,h,x),(0,0,y))
```

`swap_ip`, `swap_rp`, `swap_is`, and `swap_contraction` assert respectively
`I P = 0`, `R P = id`, `I S = id`, and `P R + S I = id`.
`swap_p_add` and `swap_i_add` assert additivity. `swap_p_injective`,
`swap_i_surjective`, and `swap_exact` assert injectivity, surjectivity,
and `I(z)=0` if and only if `z=P(u)` for some `u`.
There is no nonzero-rank assumption, field assumption, division by 2, or
finite-cardinality assumption. These statements therefore apply to the
underlying additive groups of modules over every commutative ring, including
zero modules and characteristic 2. They check the manuscript's displayed
swap exact sequence in its stated split coordinates.

The source does NOT prove that arbitrary lower-diagram data admit these
coordinates. That normalization, its preservation of the identified
quotients, and the two different restriction stabilizers are proved in
`report.md`, not inferred from `swap_exact`.

## Finite propagation and closure

For arbitrary type families `X : Nat -> Type` and `E : Nat -> Type`,
`incoming i : E i -> X i` and `outgoing i : E i -> X (i+1)` are arbitrary
functions. `LiftPath` records actual event choices with the incoming
compatibility equation at every step. `path_exists` says that for every
natural number `n`, surjectivity of `incoming i` for every `i<n` extends
every starting state to such a path of length `n`.

`anchored_closure` additionally assumes that `X 0` is a subsingleton and
is given a function `close : X n -> X 0`. Its conclusion includes
`close last = start` for the reached terminal state. The length may be
zero. The function `close` is essential: it is NOT silently inferred
from an equality of dimensions or from merely isomorphic endpoints.
For the disk application, parallel transport back to the starting interval
supplies this function and the prefix lift makes `X 0` a singleton.

The source does NOT prove the geometric event surjectivity, the prefix
singleton property, scalar cancellation in `Hom(Q,U)`, or the existence
of the endpoint transport. The report proves these separate hypotheses
for the manuscript construction. No two interval lifts are prescribed
independently, and no theorem about the entire integral-density claim
is encoded here.
