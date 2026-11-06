# Statement fidelity: the universal Fox torsion theorem

The claim is **`C-TORSION-FOX-CERT`**. The final declaration is

    FoxTower.universal_torsion_statement :
      TorsionFox.UniversalTorsionStatement

This is a proved theorem, not just the earlier proposition definition.
Its unfolded statement is: for every natural `n,m`, every relator family
`r : Fin m -> FreeGroup (Fin n)`, every character
`rho : GroupOf r ->* Complex units`, injectivity of `boundary r rho`
implies that for every `g : GroupOf r` and every natural `q`,
`0 < q` and `g^q = 1` imply `rho g = 1`.

## Objects, hypotheses and conclusion

- Both `n` and `m` may be zero. Repeated and identity relators are allowed.
- `TorsionFox.GroupOf r` is literally `PresentedGroup (Set.range r)`,
  the free group modulo the normal closure of the given relators.
  `quotient r` is its canonical quotient homomorphism.
- `rho` is an arbitrary character of that actual quotient. Its image need
  not be finite, cyclic, faithful, real, or unitary.
- `q` is any positive exponent killing `g`, not necessarily its exact order.
- `boundary r rho : (Fin m -> Complex) ->_Complex (Fin n -> Complex)`
  has the actual relator Fox derivatives as its columns. It is not a
  freely chosen matrix or a boundary supplied by an extra hypothesis.
- The conclusion is equality to the identity in `Complex units`, not
  vanishing of one selected relation coefficient.

There are no asphericity, residual-finiteness, finite-image, torsion-free,
cover-transfer, nongradient-voltage, or bounded-growth assumptions in the
final theorem. The auxiliary statements have explicit inputs, all discharged
by `universal_torsion_statement` and its source-derived tower proof.

## Quotient and Fox-map construction

`TorsionFox.path` is the free-group lift sending generator `i` to the pair
`(basis i, quotient r (FreeGroup.of i))` in the character semidirect product.
`fox` is its additive-vector coordinate. `path_right` identifies its group
coordinate with the actual quotient.
`fox_generator`, `fox_mul`, `fox_inv`, and `fox_pow` prove the Fox rules.
`boundary_basis` identifies each actual boundary column with `fox (r j)`.
The number of columns remains `m` even when relator words coincide.

The conventions are `d(uv)=d(u)+rho(pi(u))*d(v)` and
`d(u^-1)=-rho(pi(u^-1))*d(u)`. Positive letters carry their preceding
prefix weight; inverse letters carry the negative weight of the prefix
including that inverse. `fox_fundamental` and `firstBoundary_boundary`
prove the first-boundary identity and chain condition.

`witnessSubgroup`, `witnessSubgroup_normal`, and `exists_witness` prove that
every word in the quotient kernel is a finite product of signed conjugates
of the actual relators. `torsion_has_certificate` applies this to `w^q`.
The final theorem obtains `w` using surjectivity of the presented-group
quotient. Neither a word representative nor its normal-closure certificate
is an additional final hypothesis.

## Actual finite-source tower

`FoxTower.RightAction` is a right action of the free group on a vertex type.
The one-vertex `roseAction` is the initial graph. Each subsequent action
is constructed by `RightAction.lift` on the product with the rationals.
The action need not factor through the quotient: selected relator loops
are proved closed at their actual source-image vertices.

`sourcePaths r w fs` is the fixed list consisting of the word `w`, each
conjugator stem, and each positive relator path at its stem endpoint.
`walkEdges`, `sourceEdges`, `edgeSet`, `vertexSet`, and `faceSet` compute
the actual image cells, identifying equal image edges or faces.
The face labels retain the original relator indices.
`sourceBudget` is one plus twice the sum of those fixed path lengths.
`vertexSet_bound` applies to every image of these same paths.

`RightAction.voltage` is generator-derived. Its product and inverse rules
construct the lifted action

    (v,h) * u = (v * u, h + voltage a u v).

`lift_relator_fixed`, `lift_factor_fixed`, and `lift_witness_fixed` use
the actual signed-conjugate certificate. `torsion_voltage_zero` uses
the positive integer `q` in the rational field, and `torsion_lifts`
proves the original source loop closes in the new action.
This is a proof of lifting, not an imported lifting field.

## Source-derived local maps and voltage existence

`Weights.integral` is a free-group construction from generator cochains
and a multiplicative local weight system. Its product, inverse, locality,
and gradient-telescoping formulas are proved. `Weights.ofCharacter` supplies
the vertex-independent weight system of `rho.comp (quotient r)`.

`constraints` integrates an extended-by-zero finite edge cochain around
each selected actual relator word at its actual vertex.
`gradientMap` is the corresponding weighted vertex-to-edge gradient.
`source_gradient_injective` uses the nontrivial source-loop holonomy and
the concrete source paths. `source_constraints_gradient_zero` uses the
proved closed relator loops and their unit character values.
Together with constraint surjectivity, `source_count_inequality` proves

    number of faces + number of vertices <= number of edges.

Over the rationals with trivial weights, the nonzero constant vertex
cochain is in the gradient kernel. Rank-nullity then gives a vector in
the actual rational constraint kernel outside the actual gradient image.
`source_voltage_exists` constructs it, including its zero relator
voltages and nongradient property; neither is an unexplained assumption.

## Cover transfer and strict growth

`DeckRing` is Mathlib's `AddMonoidAlgebra Complex Rational`: finite sums
of rational-exponent monomials, not infinite series.
`coeff`, `monomial`, and `augmentation` are the constant embedding,
deck monomials, and specialization sending every monomial to one.
Mathlib supplies the integral-domain instance; no user axiom asserts it.

`deckWeights` multiplies each original character value by the monomial
of its actual voltage. `constraintMatrix_map` proves specialization of
the actual finite word-integral matrix.
`specialization_injective` proves injectivity over a domain from the
specialized injectivity, using a lifted left inverse and the adjugate
of a square matrix whose determinant specializes to one.

`integral_lift_monomial` and `lifted_constraint_column` derive the
intertwining identity from the actual lifted words and cochains.
`source_constraints_lift_surjective` uses this identity and specialization
to prove that the new actual constraint map is surjective.
The proof extracts monomial coefficients after
`projectFace_height_injective`: projection plus starting height determines
a lifted face. It requires injectivity of the face-placement map only on
embedded complex coefficient vectors, and does not falsely assert that map
is injective on arbitrary deck-ring coefficients.

This is a rational-voltage realization of the tower, not a formalization
of a simplicial covering-space API. No cyclic-height normalization is
assumed. It proves the same universal target without an additional
hypothesis on the presentation or character.

`vertexSet_natural` proves surjectivity of the actual projection.
`equal_count_implies_gradient` proves that equal vertex counts would
produce a potential from the unique lift height of each old vertex.
`voltage_strict_growth` contradicts the nongradient voltage and therefore
proves strict growth on the actual source image.

## Initial Fox identification and final theorem

`rose_integral_functional` identifies each one-vertex word integral with
a linear functional of the already constructed `TorsionFox.fox`.
`initial_constraints_surjective` uses a linear left inverse of the
actual `TorsionFox.boundary`, extends prescribed selected-face values
to the original relator family, and restricts generator cochains to
the actual source edges. Locality proves this restriction is legitimate.

`finite_source_tower_contradiction` constructs a new state at each
inductive step using the voltage-existence, lifting, transfer, and growth
theorems above. It proves that arbitrary iteration would give
`k + vertexCount <= sourceBudget`, then takes `k = sourceBudget + 1`.
It is not a generic termination theorem with uninstantiated transition
or growth hypotheses.

`universal_torsion_statement` supplies the actual quotient character,
torsion word, certificate, unit relator values, nontrivial loop value
under contradiction, and initial surjectivity. Its only remaining
assumptions are precisely those in the requested universal theorem.

## Preserved partial result and interpretation limits

The original `TorsionFox.Cancellation` example is retained. It proves the
exact sixth-root relation-coefficient cancellation and
`boundary_not_injective`, so it is not a manuscript counterexample.
The new proof never assumes arbitrary-witness nonzeroness.
The independently reviewed calculus version-2 certificate remains archived
with its original source and narrower fidelity text.

`proof.md`, Section 1, identifies the Fox boundary with the cellular
boundary for the actual finite presentation complex, with left deck chains
and the right coefficient action `z*g = rho(g)*z`. Van Kampen,
maximal-tree collapse and homotopy invariance are prose topology, not Lean
declarations in this file. Section 4 gives the mathematical proof of the
formal algebraic theorem. Higher-rank local systems, publication novelty,
and campaign completion are not conclusions of this certificate.

There are no user axioms, `sorry`, `admit`, or deliberately contradictory
extra assumptions. The native compiler and axiom audit must bind this
source and this reading to `C-TORSION-FOX-CERT`; a successful compiler run
does not itself perform the independent statement-fidelity review.
