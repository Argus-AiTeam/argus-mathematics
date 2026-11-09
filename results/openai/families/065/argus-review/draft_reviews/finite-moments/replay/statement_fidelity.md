# Statement fidelity: finite joint moments

Claim: `C_LOC_JET`. Namespace: `FamilyOrbitLocalization`.

`finite_geometric_remainder` quantifies over every commutative ring `A`,
every element `x`, and every natural number `N`, including zero. It proves
the exact finite geometric-series remainder, without a convergence claim.

`nilpotent_resolvent_inverse` and `nilpotent_resolvent_unique` quantify over
every commutative ring, all elements `t,u,nu`, and every natural number `N`.
Their hypotheses are `t*u=1` and `nu^N=0`. The inverse is the explicitly
defined finite series `u * sum_{0 <= j < N} (-nu*u)^j`. The uniqueness
theorem additionally assumes `(t+nu)*v=1` and identifies `v` with that
series. For a localization flag, `t=a0-s`, `u=1/(a0-s)`, and `nu` is the
ordinary even tangent class. The theorem does not assert that a particular
geometric class is nilpotent; that is supplied by the finite dimension of
the proper leg stack in the mathematical report.

`joint_moment_naturality` quantifies over a commutative scalar ring `K`,
three arbitrary `K`-modules, a finite joint-index type `J`, two linear
maps `P,L`, scalars `c_j`, and vectors `h_j`. It proves
`L(sum_j c_j P(h_j)) = sum_j c_j (L compose P)(h_j)`.
The index `J` may be a whole tuple of flag orders. No factorization or
independence of these joint data is assumed.

`joint_dressing_naturality` allows a different linear dressing `D_j` at
each joint index and proves commutation with any subsequent linear map.
Its `h_j` may already be the pushforward of an entire connected
correspondence into a tensor-product state space. It does not replace
joint moments by products of marginal moments.

`all_flag_contraction` quantifies over every finite flag type `I`, a finite
index type `J_i` at every flag, arbitrary modules `V_i,W`, and an arbitrary
multilinear map `F`. It expands contraction of weighted sums into the sum
over all choices of indices, with the product of their scalar weights.
There is no bound on the number of flags or truncation orders. Thus it
applies to any finite graph after its contractions are written as linear
or multilinear maps.

The commutative-ring assertions model the *even* tangent classes. They do
not formalize super permutation signs; those are carried by the fixed
categorical contraction maps in the report. Nor does this source define
Gromov--Witten moduli, perfect obstruction theories, virtual pullbacks,
ancestor classes, `S`, `R`, or quantization. It is an all-orders
certification of the finite-moment algebra used in that geometric proof,
not a kernel proof of Proposition `loc:factorization`.
