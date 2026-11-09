# Finite ordered greedy determinant bridge

Source: `Greedy.lean`. Import: `Mathlib`. Namespace: `LSGenericGreedy`.
Lean: **4.31.0**.

## Mathematical scope

Let `K` be any field, `ι` any finite linearly ordered type, and
`row : ι → Fin n → K` any spanning candidate family. Repeated or zero
candidate vectors are allowed; candidate labels need not be natural numbers.
A finite ordered list is covered by taking `ι = Fin list.length`.
The case `n = 0` is included.

The actual selected indices are defined, not supplied:

```lean
def greedySet (row : ι → V) : Set ι :=
  {i | row i ∉ Submodule.span K (row '' Set.Iio i)}
```

Here the general definition allows any `K`-module `V` with an additive
commutative group. The test uses **all earlier candidates**. The proofs show
that these have exactly the span of earlier selected candidates.

## Primary construction theorem: exact declaration

The ambient quantifiers for this declaration are:

```lean
variable (K : Type u) [Field K]
variable {ι : Type v} [LinearOrder ι] [Fintype ι] {n : ℕ}
```

```lean
theorem ordered_greedy_construction (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) :
    Fintype.card (greedySet K row) = n ∧
    ∃ g : Fin n ↪o ι,
      StrictMono g ∧
      Set.range g = greedySet K row ∧
      LinearIndependent K (row ∘ g) ∧
      Submodule.span K (Set.range (row ∘ g)) = ⊤ ∧
      Matrix.det (fun i j => row (g i) j) ≠ 0 ∧
      ∀ k j, j < g k →
        row j ∈ Submodule.span K ((row ∘ g) '' Set.Iio k)
```

`hspan` is the only substantive initial assumption. No independence,
nonzero determinant, chosen basis, replacement coefficients, or triangular
factorization is assumed. The order embedding gives distinct selected indices.
Its range is exactly the actual greedy set, not merely some basis subset.

The witness is the defined `greedyEnumeration K row hspan`, obtained by the
increasing order isomorphism `monoEquivOfFin` on the selected subtype.
`greedy_card` supplies the necessary cardinality proof. Before this
enumeration is defined, `greedy_linearIndependent` and `greedy_span` prove
independence and span equality directly from the greedy test; `greedyBasis`
is then constructed from these proved facts.

The stronger prefix-span equality is also exposed:

```lean
theorem greedyEnumeration_prefix_span (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤) (k : Fin n) :
    Submodule.span K ((row ∘ greedyEnumeration K row hspan) '' Set.Iio k) =
      Submodule.span K (row '' Set.Iio (greedyEnumeration K row hspan k))
```

Its general precursor, `greedy_prefix_span`, holds without a spanning
assumption and for arbitrary `V`.

## Weights

The candidate order can be any prescribed total ordering, including a
weight ordering with a tie-breaker. Selection introduces no new candidates:

```lean
theorem greedyEnumeration_weight_bound (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    {W : Type*} [Preorder W] (weight : ι → W) (bound : W)
    (hweight : ∀ i, weight i ≤ bound) (k : Fin n) :
    weight (greedyEnumeration K row hspan k) ≤ bound
```

No separate minimum-total-weight optimization claim is made or needed.

## Derived triangular coefficients: exact declaration

Here the ambient quantifiers are:

```lean
variable (K : Type u) [Field K]
variable {ρ : Type v} [LinearOrder ρ] [Fintype ρ] {κ : Type w}
```

Columns `κ` need not be finite for the factorization theorem:

```lean
theorem exists_strictLowerTriangular_replacement (A B : Matrix ρ κ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    ∃ C : Matrix ρ ρ K, (∀ i j, i ≤ j → C i j = 0) ∧ B = (1 + C) * A
```

The coefficients are explicitly defined by `replacementCoefficients K A B h`.
`earlierReplacementCoefficients` extracts a finite linear-combination
representation from the assumed span membership. The extension is

```lean
fun i j => if hj : j < i then
  earlierReplacementCoefficients K A B h i ⟨j, hj⟩ else 0
```

Thus `C` is constructed from span membership, not assumed. This theorem
does not require `A` to be independent, square, or invertible.
`replacementCoefficients_mul` proves `C * A = B - A`;
`replacement_factorization` proves `B = (1 + C) * A`.

For square matrices:

```lean
theorem replacement_det (A B : Matrix ρ ρ K)
    (h : ∀ i, B i - A i ∈ Submodule.span K (A '' Set.Iio i)) :
    B.det = A.det
```

The intermediate theorem `det_one_add_replacementCoefficients` proves
`det (1 + C) = 1`, using the actual lower-triangular orientation.

## Combined bridge: exact declaration

With the same ambient quantifiers as the primary construction:

```lean
theorem greedy_replacement_bridge (row : ι → Fin n → K)
    (hspan : Submodule.span K (Set.range row) = ⊤)
    (B : Matrix (Fin n) (Fin n) K)
    (hB : ∀ i, B i - row (greedyEnumeration K row hspan i) ∈
      Submodule.span K (row '' Set.Iio (greedyEnumeration K row hspan i))) :
    ∃ C : Matrix (Fin n) (Fin n) K,
      (∀ i j, i ≤ j → C i j = 0) ∧
      B = (1 + C) * Matrix.of (row ∘ greedyEnumeration K row hspan) ∧
      B.det = Matrix.det (fun i j => row (greedyEnumeration K row hspan i) j) ∧
      B.det ≠ 0
```

In particular, `hB` need only give span membership in **earlier candidate
rows**, not earlier selected rows. The prefix-span theorem derives the
latter and constructs `C`. No determinant hypothesis occurs.
Monomial evaluation rows are a direct specialization of the arbitrary
candidate family in this statement.

## Proof strategy and fidelity boundary

1. Finset induction by greatest index proves that any finite family whose
   vectors escape all earlier spans is independent.
2. Well-founded induction on candidate order shows each candidate belongs
   to the span of selected candidates at most its own index.
3. This yields global span equality and every prefix-span equality.
4. The resulting basis has cardinality `finrank K (Fin n → K) = n`.
5. Increasing enumeration and the standard coordinate basis give a unit,
   hence nonzero, evaluation determinant.
6. Finite span representations give the explicit strict lower-triangular
   replacement coefficients. Matrix multiplication and the triangular
   determinant formula prove factorization and determinant preservation.

There is **no remaining gap in this finite linear-algebra bridge**.
Projected-box interpolation must separately establish `hspan` for the
manuscript's candidates. A concrete replacement construction must separately
establish `hB`; prime divisibility and manuscript-specific weight bounds
are outside this bounded subtask.

## Validation

The following command completed with **exit code 0**, with no warnings or
errors:

```sh
cd $WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0 &&
$WORKSPACE/.elan/bin/lake env lean \
  families/003/first-pass/ls-uniform-determinant-core/Greedy.lean
```

Compiler output is in `greedy_compile.log` (empty on success). No `sorry`,
`admit`, user axioms, or unsafe declarations occur in the source.
`greedy_axioms.log` records kernel dependency checks for the three main
theorems; all three depend only on `[propext, Classical.choice, Quot.sound]`.
That additional check also completed with exit code 0.
