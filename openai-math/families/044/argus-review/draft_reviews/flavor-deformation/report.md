# ENGINEER source-fidelity assessment: flavor-deformation

Assessment: the source gives coherent conditional reductions by flavor
lifting, added-loop localization with homogeneous descent, and regular
stability comparison. These preserve the coefficient map and full
quotient ideals; they are not consequences of the old local arithmetic
certificate.

## Exact claims, hypotheses, and old disposition

C_DEFORM@1 asserts that flavor lifting, homogeneous descent after loop
removal, and regular-stability Betti independence extend the loop case.
C_FULL_TORUS@1 asserts the resulting canonical graded \(R\)-algebra
isomorphism
\[
B_F=A_F/\langle A_F^{(d)}:d\ne0\rangle
 \xrightarrow{\ \sim\ }H_F^*(X).
\]
Here \(Q\) is any finite quiver, loops and multiple arrows are allowed,
\(G=\prod_i GL(V_i)\), the matter is the arrow/framing representation,
\(F\) is any commuting algebraic torus, and \(\nu\) is regular: every
semistable point of the zero complex moment fiber is stable and has
trivial gauge stabilizer. Complex coefficients and the commutative
BFN algebra without loop rotation are used. Empty quotients are included.
\(B_F\) is independent of \(\nu\).

Both historical versions are source-only and open in the old graph.
There is no independent deformation proof or certificate for them in
the eighteen-item inventory. The conclusion concerns the full
topological torus, not yet the stability-cocharacter fixed scheme.

## Attribution and provenance

OpenAI, *The equivariant cohomological Hikita conjecture for arbitrary
quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`.
Source root:
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.

Relevant precise locators:

- `build/sections/deformations.tex`: `lem:betti-independence`,
  `eq:rotation-affine-fiber`, `lem:flavor-lift`,
  `prop:loop-removal`, `eq:loop-local-ring`,
  `eq:loop-coulomb-localization`, `eq:loop-higgs-localization`,
  `thm:full-torus`;
- `build/sections/preliminaries.tex`: `lem:trivial-summands`,
  `lem:flavor-base-change`, `lem:local-stability`,
  `prop:minuscule`, and the Kirwan-surjectivity paragraph;
- `build/sections/counting.tex`: `cor:loop-isomorphism`;
- `build/sections/stable-pairs.tex`: `prop:kernel-inclusion`.

The reference manifest is
`campaigns/9100044/MANUSCRIPTS.json`.
The deformation and preliminary file hashes match, respectively,
`8aa324440a174355a94e3cee448b338223befef3c32d10ca3e4cb500161db4bb`
and
`df4c190cc73d4b4c371adf57681f1c7236b780d751711f8f2930fcdc88761949`.
All ten source digests and all nine existing snapshot digests matched
read-only. The old source reference is a symlink to this source version;
it supplies no independent historical source freeze. Full measurements
are recorded in bfn-laurent-generation/report.md.

## Decisive arguments

### Flavor lifting is a kernel argument, not assumed flatness of \(B_F\)

The source's base-change lemma filters truncated BFN spaces by orbit
strata. The strata have even, free flavor-equivariant homology and free
successive quotients, so change of flavor commutes with the algebra and
its charge decomposition. For \(B_F\), taking the quotient by nonzero
charges commutes with this base change by right exactness; flatness of
the quotient is not assumed.

Fix a regular stability at which \(B_0\simeq H^*(X)\) is already known.
Put \(S=\mathbb C[\mathfrak f]\) and let \(S_+\) be its positive-degree
ideal. Kirwan surjectivity makes \(H^*(X)\) finite and even. Its
tautological representatives lift equivariantly; Leray--Hirsch gives
an \(S\)-free target \(H_F^*(X)\) with reduction \(H^*(X)\).
For the kernel \(J\) of the specified surjection
\(B_F\to H_F^*(X)\), target freeness gives
\[
0\longrightarrow J/S_+J
 \longrightarrow B_F/S_+B_F
 \longrightarrow H^*(X)\longrightarrow0.
\]
Base change identifies the middle map with the known no-flavor
isomorphism. Therefore \(J=S_+J\).
Because \(B_F\), as a coefficient quotient, is nonnegatively graded,
a nonzero homogeneous element of least degree in \(J\) is impossible.
This proves \(J=0\). The argument requires neither flatness of \(B_F\)
nor a nonnegative grading on the entire Coulomb algebra. It also works
for the zero module when \(X\) is empty.

### Added loops are removed at a specified central coefficient point

Add one \(\operatorname{End}(V_i)\) loop at every positive-rank vertex.
Give every added loop weight one under \(H=\mathbb C^\times\), with
degree-two mass \(z\), and let \(H\) act trivially on the original
matter. The looped determinant comparison and the flavor lift identify
the two enlarged coefficient quotients over \(R_0[z]\).

The source localizes at
\[
\Lambda=R_0[z]_{(\mathfrak m_0,z-1)},
\]
where \(\mathfrak m_0\) is the graded-origin ideal of \(R_0\).
For a subset coweight the added minuscule factor is
\[
E_\lambda(x,z)=
 \prod_{i,a,b}(z+x_{ib}-x_{ia})^{(\lambda_{ia}-\lambda_{ib})_+}.
\]
It is stabilizer-invariant and equals 1 at \((x,z)=(0,1)\).
Its Weyl norm is an invariant coefficient unit there, so \(1/E_\lambda\)
is an allowed localized dressing. Minuscule generation then identifies
the original and enlarged localized Coulomb algebras with the same
coefficient map and full charge grading. All inverted coefficients have
charge zero, so this also identifies their full fixed quotients.
This is not an assertion that the factor is a polynomial unit globally.

On the Higgs side the source localizes the **prequotient** stable locus
\(D^+\) with \(G\times H\)-equivariance. This distinction is essential:
fixed points of a quotient could otherwise admit compensating gauge
transformations. Subgroup localization for \(T\times H\), at the central
Lie element \((0,1)\), inverts only characters nontrivial on \(H\).
Their Weyl norms remain nonzero there, allowing descent to \(G\times H\).
The actual fixed locus \((D^+)^H\) sets added loops and their duals to
zero and is exactly the original \(D\); moment equations and stability
restrict along the closed equivariant inclusion. The resulting
cohomology comparison respects the same coefficient map over \(\Lambda\).
The cited subgroup localization does not require compactness.

### Homogeneous descent preserves the full ideal scheme

Let \(I_B,I_X\subset R_0\) be the actual coefficient kernels for the
original no-flavor theories. The enlarged isomorphism and the two
localized comparisons give \(I_B\Lambda=I_X\Lambda\).
Setting \(z=1\) gives equality after localization at \(\mathfrak m_0\).
For homogeneous \(h\in I_B\), this means that \(sh\in I_X\) for some
\(s\) with \(s(0)\ne0\). Its component of degree \(\deg h\) is
\(s(0)h\in I_X\), so \(h\in I_X\). Reversing the ideals proves
\(I_B=I_X\) globally.

This is equality of homogeneous ideals, including their nilpotent
structure. Equality at generic masses, equality of radicals, or agreement
on closed fixed points alone would not have justified the conclusion.
The source supplies the additional graded-origin descent that is needed.

### Regular-stability Betti comparison and final assembly

The local-stability lemma perturbs a regular character while preserving
the entire stable and semistable loci, quotient, and principal gauge
bundle. It does not assume the original character avoids every bounded
dimension hyperplane.

Flat hyperkahler rotation and affine Kempf--Ness identify the quotient
at real level \(\theta\), complex level zero, with the affine quotient
at complex central level \(c\theta\), real level zero, for one common
normalization \(c\ne0\). In the finite-type affine family of central
moment fibers, taking invariants commutes with specializing the
invariant central parameters by the Reynolds operator. Constructibility
of \(R\pi_!\mathbb C\) makes compactly supported Betti numbers constant
on a dense Zariski open. Each real regularity ball is Zariski dense and
contains rational perturbations meeting that open. No properness of
the moment-map family is asserted or needed for this constructibility
argument.

All nonempty regular quotients are smooth of the same complex dimension
\(2(\dim N-\dim G)\), so Poincare duality compares ordinary Betti numbers.
If one is empty, the common compactly supported Betti numbers force all
regular quotients to be empty. Ineffective actions are therefore not
silently treated as free nonempty examples.

At determinant stability, loop removal gives finite-dimensional \(B_0\).
For another regular stability, the same \(B_0\) surjects by the kernel
unit onto cohomology with the same total dimension. That surjection is
an isomorphism; the flavor lift proves `thm:full-torus`. General
commuting torus actions use diagonalization on gauge-isotypic
multiplicity spaces and removal/addition of gauge-trivial summands.

## Supported scope and concrete remaining gaps

The target-flatness argument, Weyl-norm unit calculation, homogeneous
ideal descent, and final dimension argument are algebraically supported.
Their geometric premises remain conditional:

1. The looped determinant comparison still needs C_KERNEL, the geometric
   cut-symbol application, and counting; none is supplied by the
   deformation step itself.
2. Minuscule generation and flavor base change must hold over the
   coefficient rings before localizing or specializing; the old
   certificate does not establish these geometric BFN facts.
3. The application of Brion's subgroup localization to the invariant
   locally closed prequotient, and the equivariant identifications after
   taking Weyl invariants, have not been independently certified here.
   The manuscript cites Brion, Lemma 4, and Dumanski--Krylov,
   Proposition 2.3; their theorem-level texts were not separately audited.
4. The rotation/Kempf--Ness, local-stability, Kirwan, and constructibility
   interfaces used for arbitrary quivers are substantive source/standard
   inputs, not old formal results. This source reading explains their
   required hypotheses rather than assuming generic stability.

No contradiction in the assigned versions was found. The result remains
the full-torus comparison; identifying the cocharacter quotient requires
the separate root argument.

Classification: source-only proposed reductions and conditional assembly,
using established localization, GIT, and equivariant-cohomology methods;
originality unverified. Native Host-invoked independent review remains
required and pending, without engineer self-acceptance.
