# Universal height-one lattice reduction

**Assessment:** the elementary argument supports its stated universal scope,
not merely the computed example. This agrees with the existing independent
judgement of reviewer `e8b2ab07d537`; it is not a new acceptance or novelty claim.

## Statement, source and attribution

The reviewed assertion is `C_LATTICE_064`, version 1, in the unchanged old
ledger. The argument is `model_derivation.md:48-90`, SHA-256
`30392cdfc90961859bc9e7a02ca2eb805e9427025fb90929983ff40e15dcdfdd`.
The corresponding manuscript argument is the proof of
`prop:marked-monomial-reduction` in `build/sections/15-local-numerical.tex`,
reference revision `4eaee87548250b2682affda7d05d947c05554bae`.

For **every** integer \(1\leq k\leq3\), positive integers \(a_i\), and positive
integer \(b\) divisible by each \(a_i\), set
\[
 N=\{d\in\mathbb Z^k:b\mid\textstyle\sum_i a_id_i\},\qquad
 \ell(d)=\textstyle\sum_i a_id_i/b .
\]
Successively star-subdividing the positive orthant at all its height-one
lattice points gives regular simplicial cones with height-one primitive
generators. The statement concerns the congruence lattice \(N\), not the
ambient lattice \(\mathbb Z^k\).

The old draft reconstructs and expands an argument already present in the
identified manuscript. The empty-triangle fact is elementary. No claim of an
original theorem, new bound, or independently checked historical priority is
made.

## Decisive argument checked

The primitive generators \((b/a_i)e_i\) belong to \(N\) and have height one.
The height-one section is compact, so the set of insertion points is finite.
A height-one vector cannot be a nontrivial integer multiple in \(N\), since
\(\ell\) is integer-valued there. Star subdivision in the smallest containing
cone preserves simpliciality. After all insertions, a maximal cone's
height-one simplex has no nonvertex lattice point: any such point would
already be a ray, and a ray contained in a fan cone must be a face.

In dimension three, translate one vertex \(p\) of this triangle and let
\(u,v\) be its edge vectors in \(L=\ker\ell\). They span a full-rank
sublattice of the rank-two lattice \(L\). A nonzero coset, if the index
exceeded one, has a representative \(w=\alpha u+\gamma v\), with
\(0\leq\alpha,\gamma<1\). If \(\alpha+\gamma\leq1\), \(p+w\) is a
nonvertex lattice point of the triangle. Otherwise both coefficients are
positive and \(p+u+v-w\) is such a point. This also handles points on edges:
the excluded coset is not zero, and coefficients strictly below one cannot
describe another vertex. Thus \(u,v\) form a basis of \(L\).

Since \(\ell(p)=1\), every \(n\in N\) decomposes as
\((n-\ell(n)p)+\ell(n)p\). Adjoining \(p\) gives a basis of \(N\);
replacing \((p,u,v)\) by the triangle's three vertices is an integral
determinant-one basis change. The cone is regular. An empty segment is
primitive in the rank-one height-zero lattice, and the rank-one cone case
is immediate. Faces of these regular maximal cones are regular as well.

This is a proof argument for arbitrary allowed coefficients, not a finite
enumeration. The dimension bound is used at exactly the empty-triangle step;
no analogous assertion about empty tetrahedra or higher-dimensional
height-one sections is established.

## Evidence, dependencies and limits

The old ledger binds the independent supporting judgement
`judgement-C_LATTICE_064-0c355d478701` to the same claim hash and proof file.
The source and its archived copy match the existing preserved manifest.
The old graph's `open` label is bookkeeping, not a contrary mathematical
judgement. No change of statement or dependency was found that would justify
discarding the inherited opinion.

Tools used here were direct source reading, JSON/manifest comparison and
SHA-256 matching; no numerical search or extra lattice experiment is needed
to assess this universal proof. The separate `local-toric` replay illustrates
only one parameter choice and is not a premise of this argument.

There is no Lean source, formal statement or compiler certificate in this
draft. This assessment is mathematical reading, not mechanical verification.
It establishes neither globalization nor relative MMP existence on its own.
The old claim has supported scope under its explicit hypotheses; its novelty
is not established, and independent acceptance of this review remains pending.
