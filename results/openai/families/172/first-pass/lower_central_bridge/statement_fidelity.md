# Statement fidelity: lower-central actual-fraction corrections

The principal declaration is
`LowerCentralBridge.actual_right_fraction` in `Main.lean`.
`lower_inclusion` is its representation-aware, slightly stronger core.
This document describes those declarations and the derived-depth
consequence in the same source. It does not claim that Lean formalizes
the parametric sharpness construction or the full Ramsey classification.

## Objects and literal hypotheses

`G` is an arbitrary group in an arbitrary universe. There is no
commutativity, torsion, finite-generation, or nilpotency hypothesis.
`I` is an arbitrary finite coordinate type; `2 <= Fintype.card I`.
Thus there is no upper bound or fixed value for s.

In the principal theorem, `N : Subgroup G` is normal in G.
`M : Submonoid (I -> G)` is an actual submonoid of the direct power.
`hd` says every constant tuple is in M. `coordinatePair i j` is the
literal projection homomorphism to `G x G`; `M.map (coordinatePair i j)`
is its actual image. `hclosed` says this image is closed under inversion
for every i!=j. A submonoid of a group with this property is a group.
`hcontains` says every pair (a,b), with a,b in N, lies in that image.
Neither hypothesis asserts any supported fraction or any lower-central
inclusion.

Mathlib's `N.lowerCentralSeries 0 = N` and
`N.lowerCentralSeries (k+1) = [N.lowerCentralSeries k,N]`.
Consequently `N.lowerCentralSeries (s-2)` is exactly the question's
`gamma_(s-1)(N)`, with gamma_1=N. This index shift is essential.

The conclusion quantifies over every i and every g in that subgroup,
and produces actual u,v in M with

    spike i g = u * v^-1.

The imported `EndpointBridge.spike` has value g at i and identity at
every other coordinate. No generated-subgroup membership is substituted
for this conclusion; there is no Ore assumption.

## Reuse of the accepted bridge

The source imports `research.endpoint_bridge.Main`, not a replacement
axiom file. The unchanged accepted source is built to
`lower_central_bridge/imports/research/endpoint_bridge/Main.olean`.
Building that import writes no accepted source or accepted evidence.
Mathlib and this actual compiled module provide the imported definitions
and proved fraction operations.

`monoidGrading M hd` realizes the ungraded monoid as the accepted
`Grading`: a represented tuple is exactly a member of M, represented
at degree zero. `monoid_pair_projection` proves that its projection
equals the actual image under `coordinatePair`. The artificial degree
zero in this ungraded interpretation is not a cost claim for manuscript
copy expressions.

`lower_inclusion_aux` and `lower_inclusion` instead work for any accepted
`Grading`, with its actual expressions and arbitrary finite degrees.
They use only the proved projection, inversion, pair multiplication,
and supported-subgroup operations from the accepted module.
`fraction_conjugate_rep` proves from actual represented factors that
conjugation by a represented positive tuple preserves a fraction.
The induction lifts a gamma_(s-2) fraction supported on two coordinates,
and commutes it with an actual positive tuple taking values (b,1) on
that pair. It does not assume the desired lower-central conclusion or
replace b in N by an inductively stronger input.

Normality of N is not needed for `lower_inclusion`; it is retained in
the principal theorem and used for the subsequent quotient arguments.

## Derived-depth and endpoint declarations

`three_subgroups_le` obtains the relative three-subgroups lemma by
mapping to the quotient by an explicitly normal target and invoking
Mathlib's Hall-Witt-based theorem. `lower_commutator` proves

    [gamma_p(N),gamma_q(N)] <= gamma_(p+q)(N),

with the same zero-based convention for `lowerCentralSeries`.
`derived_le_lower_pow` proves
`EndpointBridge.derived N r <= N.lowerCentralSeries (2^r-1)`.
The imported `derived N 0=N`, with each successor the self-commutator.
`derived_inclusion_of_pow` derives supported membership whenever
`s-1 <= 2^r`; it takes neither that membership nor the exponential
derived/lower-central comparison as a hypothesis.

`depthCost` uses the actual minimum costs in the grading and their
finite maximum over coordinates. The inversion, conjugation, and
subadditivity fields follow from the imported cost theorems and the
new membership result. Outside the represented subgroup no minimum
representability assertion is made.

`endpoint_bridge_depth` retains the accepted endpoint theorem's
objects: arbitrary finite group H acting on arbitrary finite X,
arbitrary seed whose within-orbit differences are in N, actual
unit-copy set A, same-orbit maps f,g, and all their H-reindexings
at f in A. The real parameters q and delta are positive.
No inverse copy or negative-weight constructor is added.

For any r with `s-1 <= 2^r` it constructs an expression w of positive
degree m. Its conclusion explicitly includes the simultaneous
`AtBound` statement on every orbit for `derived N r` with `depthCost`.
The proof invokes the accepted `simultaneous_averaging` at this r,
not at s-2. The actual `CopyRep A` corrections u,v have natural degrees
a,b, make the endpoints equal in the displayed order, and satisfy
`a+b <= s*delta*m`. The two `WeightedPath` conclusions assign weights
`m+a` and `q*m+b`, with positivity and ratio at most `q+s*delta`.

The manuscript free-group-letter seed satisfies the seed hypothesis
by the accepted `letter_difference` theorem. The geometric production
of copies and its pair hypotheses remain separate.

## Boundaries of certification

The exact sharpness construction for every s>=3 is proved in
`theorem.md`, with rerunnable arithmetic instances in `verify.py`.
It is not a declaration in this Lean file. The source-grounded
comparison in `literature/comparison.md` expressly excludes novelty of
the known subgroup case and does not establish worldwide priority.

Compiler success certifies the encoded declarations, not the truth
of this English reading or publication significance. The four
printed axiom reports cover the principal inclusion, representation
core, exponential comparison, and endpoint theorem. Independent
Reviewer fidelity and publication-level assessment remain required.
