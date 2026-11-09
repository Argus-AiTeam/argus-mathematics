# Statement fidelity: C318H3ALG

`Main.lean` formalizes finite filtered comparison and the integer range
test used in the special degree-three sphere-lifting argument. It does
not formalize spectra or continuous group cohomology.

## Objects and quantifiers

`filtered_kernel`, `filtered_lifting`, and
`finite_filtered_bijective` quantify over every commutative ring R,
every pair of R-modules V,W with additive commutative group structures,
every R-linear map f:V->W, every nonnegative integer n, and every
pair of sequences of submodules F_i,G_i. No finite-dimensionality,
field hypothesis, topology, spectrum, or characteristic is assumed.

The combined theorem assumes F_0=G_0=0, F_n=V, G_n=W, and monotonicity
of F. Its two leading-layer conditions are stated elementwise:

1. For i<n and v in F_(i+1), if f(v) lies in G_i then v lies in F_i.
2. For i<n and w in G_(i+1), there is v in F_(i+1) such that
   w-f(v) lies in G_i.

Its conclusion is `Function.Bijective f`, for this same map f, not
the existence of another map or an equality of dimensions.
`filtered_kernel` and `filtered_lifting` prove the respective
inductive assertions at every i<=n.

For actual increasing filtrations preserved by f, the two elementwise
conditions follow from injectivity and surjectivity of the induced
successive-quotient maps. The formal theorem does not itself construct
these quotients or assume unexplained spectral basis maps. Application
to the decreasing residue filtration reverses a finite range and
applies this theorem to the underlying coefficient modules. The
filtered map, its finite exhaustive range, and its leading quotient
isomorphisms are proved in prose in `proof.md`, Section 6; the compiler
does not check those application hypotheses.

## Range declarations

`degree_three_differential_window` quantifies over each integer
r>=2, represented as a natural number, and proves either r-1<7 or
3+r>9. In the prose application the first alternative uses the
separately cited vanishing of the positive sphere stems below seven;
the second uses the separately established cohomological bound nine.
Neither vanishing theorem is encoded as an axiom in this file.

`degree_three_positive_row_outside` proves that r>=7 and s=r+3 imply
s>9, again purely as natural-number arithmetic.
`degree_one_boundary_is_not_excluded` records that the potential
degree-one differential with r=8 has target cohomological degree nine
and coefficient degree seven. Thus the range proof does not silently
assert that every degree-one class lifts. The actual degree-one lift
is constructed by the divided reduced norm in the prose.

## Not certified by this source

No construction of Morava E, completed cooperations, ordinary residue
smash, spherical representatives, geometric support comparison,
coheight-one coefficient theorem, rational local sphere, or eight-stage
filtration is formalized here. No spectral equivalence or publication
novelty is made a Lean hypothesis. The compiler certifies exactly the
universal algebra and arithmetic declarations described above.
