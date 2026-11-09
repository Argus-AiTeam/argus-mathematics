# Statement fidelity: the universal descent core

The claim is `S_MERIDIAN_KERNEL`, not the surface theorem. The source is
`Main.lean` in this directory, namespace `SurfaceGeometry`.

All three groups `G`, `Q`, and `P` are arbitrary groups, in arbitrary
universes. They are not assumed finite, abelian, topological, or realizable
as fundamental groups. `I` is an arbitrary index type and `A i` are
subgroups of `Q`. The maps `rho : G -> Q` and `p : Q -> P` are group
homomorphisms. `S` is an arbitrary set of elements of `G`.

`local_kernel_agreement` quantifies over an additional homomorphism
`f : G -> Q` and one subgroup `A`. Its hypotheses are that all `f g`
belong to `A` and that the restriction of `p` to `A` is injective.
Its conclusion is equality of the kernels of `p` composed with `f`
and of `f`, without any bound on orders or on the number of generators.

`conjugate_kernel_trivial` assumes injectivity on `A`, `a` in `A`,
an arbitrary conjugating element `g` of `Q`, and
`p(g*a*g^(-1))=1`. It concludes `g*a*g^(-1)=1`. Thus injectivity
on representatives suffices for arbitrary conjugates.

`normal_closure_killed` assumes injectivity of `p` on every `A i`.
For every `s` in `S` it assumes the existence of `i,a,g` with
`a` in `A i` and `rho(s)=g*a*g^(-1)`. It also assumes
`p(rho(s))=1` for every such `s`. It concludes that the normal
closure of `S` in `G` is contained in the kernel of `rho`.

`descent_exists` has exactly those hypotheses and constructs a
homomorphism from `G / normalClosure(S)` to `Q`, agreeing with
`rho` on every quotient representative.

In the geometric application `G=pi_1(U')`, `S` is the set of all
compactification meridians, including exceptional ones, and the
quotient is identified with `pi_1(X)` by a separate transversality
argument. The image of each meridian is local and is killed by the
finite quotient because its lift is closed. Those geometric facts,
the existence of the separating finite quotient, algebraization,
resolution, rationality, specialization, and holomorphic convexity
are **not** encoded or proved by this Lean source. They are proved
in `REPORT.md` and require independent mathematical review.

No unproved external proposition is assumed by these declarations.
The kernel checks standard group theory imported from Mathlib;
it does not check this document's identification with geometry.
