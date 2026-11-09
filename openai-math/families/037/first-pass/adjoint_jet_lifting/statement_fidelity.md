# Statement fidelity: the exact finite-facet saturation kernel

`AdjointJetLifting.exact_saturation` quantifies over an arbitrary additive
commutative group `A`, an arbitrary finite index type `I`, a family
`forms : I -> A ->+ Int`, a vector `c : A`, and an arbitrary membership
predicate `Gamma : A -> Prop`. In the application, `A` is the congruence
lattice of original section degrees and Taylor exponents, expressed as
an additive group, and `I` indexes all facets of the cone.

`ClosedHalfspaces forms q` means every integral form is nonnegative at
`q`; `StrictHalfspaces forms q` means every form is strictly positive.
The hypotheses are exactly:

1. Every form has value one at `c`.
2. `Gamma` is contained in the closed halfspaces.
3. If `q+c` satisfies all strict inequalities, then `Gamma q`.

The conclusion is both exact equality of `Gamma` with the closed lattice
halfspaces, and equivalence of strict membership of `q` with existence
of `g` in `Gamma` satisfying `q=c+g`. Subtraction in `A` is essential:
the proof considers `q-c`, not a rounded real point. Integrality of the
form values is essential: a strictly positive integer is at least one.
There is no assumption of semigroup finite generation or saturation.

`AdjointJetLifting.height_one_surjective` quantifies over any integral
additive form with value one at `c` and proves that it maps onto all
integers, by evaluating at integer multiples of `c`. This is precisely
the primitivity of that form on the lattice.

The formal source does not identify strict inequalities with topological
interior by itself. That identification is made in the report only
after proving that the full-dimensional cone is cut out by finitely many
nonzero facet forms. The compiler does not verify cone rigidity,
orbifold geometry, local multiplier ideals, restriction surjectivity,
global lifting, rational polyhedrality, or the cited geometric theorems.
Those are separate mathematical arguments in the report. The theorem
does not claim the full volume-gap theorem and makes no novelty claim.
