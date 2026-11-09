# Statement fidelity: actual Boolean cut compression

## Claim and certification boundary

This source certifies `G157_CUT_COMPRESSION`, a source-specific dependency
delta. It does **not** close `G157_REALIZATION` or independently prove either
manuscript's graph-theoretic conclusion.

Unlike the earlier protected-channel reduction, compression closure,
quotient naturality, residual invariance, the quotient rank bound, and the
numerical channel inequality are derived here, not assumed as a compatible
diagram. The construction uses the actual affine binary point-moment spans
and their cut-map image, rather than an arbitrary profile space.

The strongest prior result relevant to this delta was the independently
reviewed `G157_ANNIHILATOR`, together with the conditional
`ProtectedChannels.protected_realization`. Both sources are imported without
editing their proofs or statement-fidelity documents. Rebuilding their
`.olean` files is dependency compilation, not a new annihilator development.

The remaining end-to-end gap is explicit: the source does not construct
the routed target matrices of rank `15 r0 + 14 J |E|` from the literal
gradient formula, nor extract a single tuple of quotient forms and allowed
derivative maps from the reviewed response-span conclusion and identify its
post-derivative residual with the retained matrix representation. These are
not consequences of a passing compression certificate.

## Literal coordinates and allowed points

The ground field is exactly `BooleanCutAnnihilator.F = ZMod 2`.
There are `p` selector coordinates, `m` ordinary base blocks, and `n`
coordinates per block. The definitions are

    Base m n = Option (Fin m x Fin n) -> F,
    Primal p m n = (Fin p x Option (Fin m x Fin n)) -> F.

`none` is the constant base coordinate. `embed selectors s v` has entries
`selectors s a * v q`, so it is precisely the selector tensor base-vector
embedding. The literal manuscript specializes `p` to `p_*`,
`m` to `g^2+3`, and the selector entries to their squarefree monomial
evaluations. A chosen indexing of the ordinary blocks identifies
`O_{d,t}, S, #, Z` with `Fin (g^2+3)`.

`allowed blocked t s v` requires every coordinate in every block with
`blocked t b` to be zero. In the literal instance, these are exactly
the `O_{d,t}` with `t` outside `I_d`; the three exceptional blocks are
never blocked. The theorem quantifies over *all* such block predicates.
It does not assume that compression preserves an arbitrary allowed-point
predicate.

`moments` is the span of squares of embedded allowed points with
constant coordinate one. `cuts` is the reviewed definition
`cutSpace moments`: `x(a,b)=w(a)+w(b)` with `w(t)` in the corresponding
tag moment span. Ordered pairs redundantly encode the manuscript's
unordered components; response evaluation below sums only over the supplied
component index, not over both orders.

## Constructed compression and exact rank

`blockwise_compression` takes finite families of primal vectors and dual
forms. It expands both along selector coordinates and ordinary base blocks.
For every block, it applies the reviewed elementary compression theorem to
the span of the expanded vectors and their combined observation map.
It constructs block maps fixing all expanded vectors and preserving all
expanded forms. No idempotence claim is needed.

`compressPrimal` uses the same block map in every selector slice, fixes
each constant coordinate, and never mixes distinct ordinary blocks.
`compress_embed` proves that an embedded point is mapped to the point
with the same selector and compressed base coordinates.
`compress_allowed`, `preserves_moments`, and `preserves_cuts` consequently
derive closure of the actual affine point, moment, and cut domains.
There is one map per endpoint, used at every component and in both modes.

`finite_spanning_family` pads a basis of a subspace of dimension at most
`d` to a family indexed by `Fin d`. `pin_key_generators` applies it to
every projected-pin-plus-key space. Thus pin dimensions at most `K` and
key dimensions at most fourteen produce, per endpoint, a single family
indexed by

    PinIndex E K = Bool x Fin E x Fin (K+14).

This is the manuscript's `2 |E| (K+14)` vector count, not a hypothesis
that a low-rank map fixing the pins already exists. The residual row and
column families are indexed by

    FormIndex E K = Bool x Fin E x Fin (Rres K).

`manuscript_cut_compression` derives

    Blin K = 3 K + 28,
    Rres K = 14 K + 140,
    Dblk p E K = 2 p E (K+14+Rres K),
    Dquo p g E K = 2 p (1+(g*g+3) Dblk p E K) + 2 K.

`primal_rank` proves the selector multiplicity is `p`, not the number
of labels. It factors the compressed primal map through
`Fin p -> F x (product of block images)`. The rank bound is
`p (1+m Dblk)`, not a square of this quantity.

## Mixed frozen directions and private-channel quotients

The nominal space is exactly

    (Fin 2 -> Primal) x (Fin 2 -> H).

The pin subspaces may mix both endpoints, primal coordinates, and channel
coordinates. The hypotheses on the constructed vector family concern
the *projections* of these subspaces, never their pure-primal intersections.
`fixes_nominal` and `fixes_frozen` prove that fixing those primal
projections while acting identically on channels fixes each full mixed pin,
every selected key, and every private-channel direction.

The denominator of each quotient is the reviewed `frozen` definition:
pins plus primal keys plus private channels. `quotientCompression` is the
actual induced quotient map. `quotient_natural` proves its commutation
with the quotient projection. `quotient_tensor_natural` and
`combined_natural` prove the induced tensor diagram, including the sum
over both source endpoints.

`product_channel_quotient_bound` derives the combined channel quotient
dimension at most `2K` from the two literal private/protected complements
and protected dimensions at most `K`. `quotient_rank` removes the entire
private channel contribution before estimating rank. Applying it to the
constructed maps proves `Dquo`; identity on all `H` coordinates is not
incorrectly counted as a bounded-rank nominal map.

## Residual and response preservation

The retained residual representation is explicit. For each endpoint,
component, and index in `Fin (Rres K)`, it supplies two dual primal forms
`f` and `h`. `residual` sums their rank-one tensor contractions.
`residual_atom_invariant` and `residual_invariant` prove preservation
because the constructed compression preserves *both* retained forms.
They do not assert preservation of the original gradient, every tester,
or arbitrary target matrices.

`contraction` is trace contraction of a curried bilinear form with a
tensor. `contraction_rankOne` proves that it agrees with `f(M h)`.
`contraction_natural` proves the push/pull identity by cyclicity of trace.
`quotientResponse` is the sum, over actual components, of contraction
with the shared combined-endpoint tensor.
`actual_response_natural` derives its commutation from the two actual
quotient diagrams and the endpoint-wise tensor push. Thus no independent
endpoint response is substituted for the shared response.

`bounded_pure_solution` combines these constructions. Given an
*existing* unrestricted quotient-form solution of the explicitly
represented residual on all paired cuts, it constructs quotient forms of
rank at most `Dquo` with the same response on every paired cut. It derives
the generator families from the pin/key dimension bounds. Its solvability
premise is not a new proof of the response-parameter extraction mentioned
in the certification boundary above.

## Target agreement, derivative reduction, and channel exactification

`recipe_target_in_response` invokes the unchanged reviewed annihilator
theorem. The recipe input is `T(r)=a(r)+actual(r)` on effective profiles,
and table agreement identifies the baseline there with `actual`.
Characteristic two then gives `(a+T-baseline)(r)=0`. For each individual
selected atom, the binary prescriptions and the baseline matched-key law
are supplied as equality to the same explicit `keyValue`. Linearity
derives vanishing on all selected-atom sums. The theorem proves a target
in the reviewed response span; it does not re-prove the raw-frame or
binary-prescription assertions from upstream geometry.

`reduce_derivative` constructs a reduced derivative in its original
allowed value subspace, of rank at most the opposite baseline rank,
preserving every observed baseline pairing. It does not merely assume
the derivative rank reduction. The bound `Blin` on the original baseline
primal maps is still a primitive input from the source baseline construction.

`protectedValues` is the kernel of the three actual observations against
the opposite protected channel space, baseline primal image, and reduced
derivative primal image. `protected_value_codimension` derives codimension
at most `K+2 Blin`; `protected_value_vanishes` derives both required
orthogonality conditions.

`manuscript_channel_budget` derives the sufficient channel inequality
from the literal strict `970 r0` inequality. With a fixed pure form of
rank at most `30 r0+28 J E` and a compressed form of rank at most `Dquo`,
`manuscript_budget_exactification` constructs actual factors, orthogonal to
both adjusted opposite primal maps and the opposite protected channels.
The numerical rank bound on the fixed pure form is an explicit input,
not the missing target-routing theorem secretly assumed proved.

Finally `nominal_gram_completion` instantiates the reviewed simultaneous
Gram theorem on the actual two-endpoint nominal products, quotient
correction maps, and frozen pin/key spaces. It derives the channel
Kronecker identities and source/opposite frozen compatibility rather than
assuming them as an abstract coordinate system. Its single new Gram block
preserves every full frozen row and column and every forward/reciprocal
primal-channel increment simultaneously. The same theorem applies to the
other cross block. This does not supply the still-unconstructed correction
families from literal recipes by itself.

## Native verification and supplemental computation

From the campaign root, after compiling the two unchanged imported modules
with that root as Lean's `-R` package root, the authoritative command is

```sh
LEAN_PATH="$PWD" $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/gradient-realization/composition/Main.lean --statement-fidelity research/gradient-realization/composition/statement_fidelity.md --claim G157_CUT_COMPRESSION --project-root .
```

`verify.py` binds the real compiler record, the two unchanged reviewed
dependencies, and both manuscripts' existing source anchors. Its new exact
specimen enumerates allowed affine generators on an explicitly identified
active subspace, checks quotient descent, residual preservation, full
bilinear factor identities, and simultaneous frozen Gram rows and columns.
It is not a manuscript-admissible counterexample, a full exhaustion of the
manuscript parameter regime, or evidence of novelty or publishability.

No false assertion of either manuscript has been established by this delta.
