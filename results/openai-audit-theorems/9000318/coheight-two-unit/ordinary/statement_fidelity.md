# Statement fidelity: ordinary transfer cutoff and procyclic norm

This source belongs to the new claim `C318CUTALG`, not the already reviewed
`C318CO2ALG`. It does not encode the deformation rings, compact supports,
or Morava stabilizer cohomology. It certifies the exact algebraic step
needed at `full:stable-cutoff`, with the hypotheses exposed.

The field F is arbitrary. M and X are vector spaces; the main theorem
assumes both are finite-dimensional. S is a linear endomorphism of M,
T and Phi are linear endomorphisms of X, and f is a linear map M -> X.
`stable S` is the intersection of the images of every nonnegative
power of S, including power zero. `nilpotentPart S` is the sum of the
kernels of those powers.

`intertwines_pow` and `preserves_stable` prove naturality of iterates
and stable images for an intertwining linear map. `split_transfer_bijective`
proves that T Phi = identity makes T bijective on a finite-dimensional
space. This conclusion is false for infinite-dimensional spaces and
the finite-dimensionality assumption is not omitted.

`stable_cutoff_of_split` assumes:

- f S = T f;
- T Phi = identity;
- every m in the kernel of f is killed by some power of S, with the
  exponent allowed to depend on m;
- there is one exponent n such that the image of T^n is contained in
  the image of f.

It proves that the actual restriction of f to `stable S` is bijective
onto the whole X, not a replacement module with the same dimension.
The proof uses the Fitting decomposition supplied by Mathlib.
Linearity of the restricted map is inherited from f; the theorem's
conclusion expresses bijectivity as a function. It neither derives
finite-dimensionality of ordinary cohomology nor supplies the
compact-lattice support comparison.

`stable_action_naturality` concerns a second pair M', X', an
intertwining map a between transfer modules, and a commuting square
with a map b between targets. It proves that the stable restriction
retains that same square. In the application a and b may be the maps
in different cohomological degrees induced by an actual constant
cochain class. The formal theorem does not construct those cup maps;
their cochain-level naturality is proved in the accompanying prose.

`norm_chain_identity` proves the integral group-ring identity
(g-1)(1+g+g^2+g^3+g^4)=g^5-1 over every commutative ring.
`characteristic_five_norm` proves that this norm is (X-1)^4 in
F_5[X]. `trivial_character_corestriction` checks that the norm at
the trivial character is zero. These certify the algebraic formula
for the degree-zero part of the actual index-five corestriction;
the degree-one part is the identity.

The procyclic continuous resolution, common finite frame and pole
conditions, passage to connected corestriction, its naturality for
degree-shifted derived maps, and the geometric comparison are prose
arguments, not additional compiler results. No theorem here asserts
that a perfected or completed coefficient is the ordinary one.
