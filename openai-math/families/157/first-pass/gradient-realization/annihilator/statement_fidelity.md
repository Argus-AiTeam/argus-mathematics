# Paired Boolean cut-profile annihilator

## Certified statements

`Main.lean` proves the universal algebraic implication recorded as
`G157_ANNIHILATOR`. Its principal declarations are
`BooleanCutAnnihilator.PairedBooleanData.paired_boolean_annihilator`,
`response_kernel_exact`, and `target_in_response`.

The conclusion is **derived** from the moment, sparse-label, interpolation,
pin-budget, and injecting-table hypotheses. No field of `PairedBooleanData`
assumes annihilator containment, isolation, solvability, or effective-space
membership of a response-annihilating profile. This is the improvement over
the earlier `ProtectedChannels.protected_realization` theorem, which assumed
the annihilator implication.

This certification does not prove the full gradient-realization theorem:
cut-preserving compression, its residual invariance, and composition with
protected-channel exactification remain separate obligations.

## Objects and quantifiers

The ground field is exactly `ZMod 2`. The endpoint index `J` is any finite
type; the manuscript specialization is `Fin 2`. The tag type is any
nontrivial type, and is finite in `target_in_response`. Labels form any
type with decidable equality. The base coordinate type is finite, with a
distinguished constant coordinate `origin`. The primal space `B` is any
finite-dimensional vector space over the ground field. The channel space
`H` is arbitrary; the actual manuscript takes it to be `F_2^h`.

A tensor is the linear map `Dual B -> B` corresponding to its two-factor
tensor. A point square maps `phi` to `phi(v) v`. Its pushforward along an
embedding `E_s` is `E_s M E_s^dual`. This identification is faithful in
finite dimension and uses no positivity, transpose-sign convention, or
division by two.

`momentSpace` is the span of **actual affine point squares**
`square(E_s v)`, with `v(origin)=1`. `tagMomentSpace` restricts those
generators by an arbitrary tag-dependent predicate `allowed`. Thus it is
not an arbitrary substitute profile space: specializing `allowed` to the
manuscript's forbidden `O`-block zero conditions gives precisely `W_l`.
`cutSpace` is the image of the cut map

    x(a,b) = w(a) + w(b),  w(a) in W_a.

Ordered pairs are a redundant encoding of unordered components. Cut
profiles have zero diagonal and symmetric off-diagonal entries. Response
tests are imposed componentwise, not summed over both orders; consequently
no duplicate test cancels in characteristic two. Restricting to unordered
distinct pairs gives the literal manuscript domain.

The nominal space is `(J -> B) x (J -> H)`, linearly identical to the
manuscript's finite direct sum of primal and channel endpoint blocks.
`Dplus` and `Dminus` are arbitrary nominal pin subspaces, allowed to mix
primal directions, channels, and both endpoints. They may vary with the
component. `S_i` always means the **projection** of `D` to primal block
`i`, not its intersection with that block.

The selected label set at endpoint `i` has at most fourteen members.
Each has one tag and one admissible affine point. The component key space
is the span of those point vectors whose selected tag is incident with
that component. Distinctness is encoded by a finite set of labels with
one point per label.

`frozen` is `D + keys + private channels`. `Tplus` and `Tminus` are
disjoint from the corresponding pin-channel projections. The baseline
maps evaluate full nominal vectors against the fixed opposite endpoint's
channels. Their only injection requirement is on the **actual**
intersection of a pin space with an individual pure primal block,
modulo the opposite protected channel space. It does not impose
injectivity on all projected pins.

## The actual shared response

`combined` pushes each endpoint tensor into its own nominal primal block
and sums the resulting tensors. Its sum is tested by one shared pure
form; the proof does not give the endpoints independent pure solutions.

`responses` is the span of these permitted rank-one tests, independently
at every component:

1. `alpha(combined(x) beta)`, where `alpha` and `beta` annihilate the
   respective frozen/private spaces;
2. `c(baselinePlus(combined(x) beta))`, where `c` annihilates the opposite
   protected plus channel space and `beta` annihilates the minus frozen
   space;
3. the reciprocal minus derivative test.

These are exactly the pure quotient-form and derivative tests of the
linear relaxation. Over the actual finite-dimensional nominal spaces,
rank-one forms span all quotient bilinear forms and all derivative maps
with values in the allowed protected-channel annihilators.

`response_kernel_exact` proves that annihilating this response span is
equivalent to `kernel` membership. Thus the response-annihilation premise
is not replaced by a stronger endpointwise isolation assumption.

## Hypotheses retained from the manuscript

The following are explicit hypotheses, with ledger assumption identifiers.
The new source proves their annihilator consequence; it does not
re-prove the entirety of the manuscript's moment theory.

| Formal field | Source and ledger assumption |
|---|---|
| `label_support` | `04-moments.tex`, `lem:label-support`; `A157_LABEL_SUPPORT`. A matrix in the affine point-moment span of rank at most `Rstar` has a decomposition on at most `Rstar` labels into Boolean moment blocks. Blocks are extended by zero off their finite support. The unused stronger sum-of-block-ranks bound is not required. |
| `interpolation` | `04-moments.tex`, `lem:base-moments`, `eq:moment-parameters`; `A157_LOCAL_INTERPOLATION`. Label embeddings on at most `3 Rstar` distinct labels have injective direct-sum map. |
| `sparsePlus`, `sparseMinus` | `04-moments.tex`, `lem:sparse-pin-labels` and its following exclusion paragraph; `A157_SPARSE_PINS`. In an expansion of a projected pin on at most `Rstar + selected.card` labels, every selected-label coefficient is zero. This follows from the literal `Rstar+14` exclusion since `selected.card <= 14`. |
| `pinPlus`, `pinMinus`, `selected_count`, `rank_parameter` | Pin budget, paired-list definitions, and `Rstar=2(K+20)`; `A157_ADMISSIBLE_CUT_DATA`. The component rank bound is proved in `rank_budget` and `rank_from_quotients`, not assumed. |
| `affine`, `admissible` | Affine point evaluation and tag-dependent permitted point generators; `A157_ADMISSIBLE_CUT_DATA`. |
| `privatePlus`, `privateMinus`, `injectingPlus`, `injectingMinus` | `05-realization.tex`, `def:small-table`, `eq:table-injection`, and the baseline construction; `A157_TABLE_INJECTION`. |

These source anchors occur in both staged counterexample manuscripts.
No characteristic-zero literature theorem is substituted for their
finite-field moment assertions.

For literal specialization take labels `s in F_2^b`, base coordinate
type `Fin(1+d_b)`, `origin=0`, and `E_s(v)=p_s tensor v`. Use the source
zero-coordinate predicate for `allowed`; use the literal selected
points, nominal pin spaces, private complements, baseline maps, and
opposite protected projections for the remaining fields.
Selector interpolation gives `interpolation` because the stated
`jstar` exceeds `3 Rstar-1`. The selected points avoid every sparse-pin
label. The dimensions of `S_i` are at most `K`; key dimensions are at
most fourteen; `rank_budget` proves the needed bound
`2K+28 <= 2(K+20)`. Baseline agreement on stored pins transfers the
literal small-table injection to `injectingPlus` and `injectingMinus`.
This supplies every field without using the desired containment.

## Derived conclusion and proof boundary

For every paired cut profile annihilating all the shared response tests,
`paired_boolean_annihilator` constructs coefficients `c` and a remainder
`r` such that:

    x = r + sum of c-scaled selected endpoint atoms,
    r is still a paired cut profile,
    range(r_i,e) is contained in both projected pin spaces S_i,e^+ and S_i,e^-.

Cut tensors are symmetric, so the two range conditions give both-factor
support in `S_i,e^+ tensor S_i,e^-`, precisely the source effective space.
The proof first derives the rank bound from pure quotient annihilation.
Sparse-label extraction and the Boolean diagonal identities force each
selected block to be a scalar point square. Three-edge interpolation
transfers the cut triangle identities to individual label blocks.
`star_coefficients` proves that the coefficient is constant along its
selected tag star. Subtraction is therefore by genuine selected atoms
and preserves the cut domain.

For the remainder, `key_unselected_disjoint` derives key separation from
sparse exclusion; it is not a new structural assumption. `strip_nominal`
removes keys and private channels while retaining the original mixed
pin subspace. `unselected_effective` uses the derivative tests and the
injecting-table condition to kill the resulting pure-primal pinned
contractions. The reciprocal argument yields both required supports.

Finally `target_in_response` proves: every linear target that vanishes
on the effective paired cut profiles and selected atoms agrees, on all
paired cut profiles, with an element of the **defined** relaxed response
span. The target's two vanishing conditions are exactly the inputs used
at this stage of the manuscript argument; their derivation from recipes
and matched keys is outside this annihilator claim. A target originally
defined only on the cut subspace can be extended linearly to the full
profile space; only its restriction appears in the conclusion.

This is a universal Lean theorem, not an extrapolation from the finite
specimen in `verify.py`. The specimen is an additional exact check with
two endpoints, tag-dependent allowed points, and genuinely mixed pins.
It is not a manuscript-admissible counterexample and does not have the
manuscript's enormous parameter sizes.

Independent Reviewer assessment of this statement mapping and of the
retained manuscript lemmas is still required. No false manuscript
assertion has been established.
