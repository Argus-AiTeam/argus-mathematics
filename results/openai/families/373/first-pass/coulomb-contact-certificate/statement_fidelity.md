# Statement fidelity: full image-measure selection obstruction

The declarations are in namespace `CoulombContact` in `Main.lean`.
The associated ledger claim is `C_CC_SELECTOR`.

## Objects and quantifiers

`weightedMixture nu H w` is the actual finite sum of measures
`sum_i (w i) * (H i)#nu`, not an assumed collection of scalar mass
identities. The index type is any finite decidable type; the weights
are finite nonnegative reals. The source and target are arbitrary
measurable spaces. In the two nonexistence theorems, `nu` is a
probability measure and the target has measurable equality
(`MeasurableEq`). The latter holds for the Euclidean Borel space in
the application. No nonatomicity of `nu` is assumed.

Each `H i` is a `MeasurableEmbedding`: it is measurable, injective,
and sends every measurable set to a measurable set. The ranges of
distinct embeddings are pairwise disjoint. The distinguished
embedding `H i0` parametrizes the central component. In the manuscript
application, the source is the Borel subtype B, `H 0` is its inclusion
in R^3, and the other four embeddings are Y_1,W_1,Y_2,W_2.

## Precisely what the compiler proves

`component_image_measure` derives the pushforward mass of `H j '' s`
from injectivity and disjointness: it is `nu s` for the matching
component and zero for any other component.

`mixture_image_measure` derives the exact image-mass identity
`weightedMixture nu H w (H j '' s) = w j * nu s` for every measurable
source set s. Thus image-mass identities are conclusions, not hidden
hypotheses.

`no_weighted_preserving_selector` quantifies over every measurable
map `T : target -> target`. Suppose every noncentral weight is strictly
smaller than the central weight, T preserves the actual mixture
measure, and for nu-almost every source x its output at the central
point is one of the noncentral points with the same source x.
The conclusion is `False`.

The proof constructs the coincidence selection sets, proves them
measurable using measurable equality, proves their image/preimage
inclusion, applies preservation and the derived image-mass identity,
uses finiteness of nu to deduce each selection set is null, and
contradicts their almost-everywhere finite cover. This is the complete
measurable-selection obstruction, not just the scalar inequality
`t/3 <= t/6 -> t=0`.

`no_coulomb_preserving_selector` specializes to five embeddings and
weights 1/3 on index 0 and 1/6 on the other four indices. It concludes
that T cannot preserve this mixture under the almost-everywhere
selection condition. The weights sum to one, though their normalization
is not needed for the nonexistence argument. T is not assumed
continuous, cyclic, injective, differentiable, or to send points outside
the central component in any prescribed way.

## What remains outside this formalization

No declaration in this source asserts the existence of the Coulomb
branches, their analytic bounds, the global supporting inequality,
the smooth density, optimality, or the full Riesz extension.
Those analytic assertions are proved in `report.md` using its named
standard analytic dependencies and exact rational replay.

Identifying the source subtype probability with `g^2 dx`, showing that
the four smooth diffeomorphisms are measurable embeddings, and extracting
the almost-everywhere selection condition from contact-set optimality
are application steps in the prose proof, not compiler-checked here.
They introduce no extra restriction on the Borel maps being excluded.
The compiler checks the encoded theorem; independent review must check
this reading and these application steps. A successful compiler run
does not certify novelty or independent Reviewer acceptance.
