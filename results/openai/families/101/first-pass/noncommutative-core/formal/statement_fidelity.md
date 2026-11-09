# Statement fidelity: full real matrix commutator inequality

The final declaration is
`Commutator9000101.real_matrix_commutator_inequality` in `Main.lean`.
It formalizes claim `C9000101_NC` in context `CTX9000101NC`.

## Quantifiers and exact conclusion

For arbitrary finite index types `n` and `ι`, with a decidable equality on `n`,
let `X, w : ι → Matrix n n ℝ` and `b : Matrix n n ℝ`.
The only mathematical hypotheses are that every `X r` and `b` are symmetric
(`Matrix.IsSymm`, meaning equality with their transpose).
There is **no** symmetry assumption on `w r`.
Define, using matrix multiplication in exactly the indicated order,

- `B = ∑ r, X r * X r`;
- `S = 40 • (37 • I + 3 • B)⁻¹`;
- `T = S - I`;
- `F = ∑ r, X r * w r`;
- `P = trace (T * b * B * b - T * B * b * b)`.

Here `•` denotes real scalar multiplication, `I` is the identity matrix,
`⁻¹` is Mathlib's matrix nonsingular inverse, and `trace` is the ordinary
unnormalized real matrix trace. The theorem proves

```text
-P - 2 * trace ((T * b - b * T) * F)
   - trace (T * (∑ r, (w r)ᵀ * w r))
≤ (42 / 37) * ∑ r, trace ((w r)ᵀ * w r).
```

In particular, take `n = Fin m` and `ι = Fin m` for every integer `m ≥ 1`
to obtain the complete requested arbitrary-dimensional statement.
Allowing the family size and matrix dimension to be independent, and allowing
empty finite types, is a harmless strengthening.
No commutation hypothesis on `b`, `w r`, or `X r` with `B` is present.

## Full matrix proof, not a scalar-only reduction

`full_deficit_nonneg` proves the nonnegativity of the entire matrix deficit.
It invokes Mathlib's proved real Hermitian spectral theorem for the symmetric
Gram matrix `B`, conjugates **all** matrices by the resulting orthogonal
change of basis, and proves trace invariance and transpose compatibility.
The basis and its diagonalization are constructed inside the proof, not
assumed in the theorem statement.
The diagonal entries of the conjugated Gram matrix are proved nonnegative
from the family of symmetric squares.
`mapped_inverse` constructs a left inverse and uses
`Matrix.inv_eq_left_inv` to show that the actual manuscript inverse becomes
the diagonal matrix with entries `(37 + 3 * β i)⁻¹`.
Thus there is no unproved spectral-basis or inverse-equation hypothesis.

In that basis, `gram_sum` proves the full matrix row-Gram contraction
using `∑ r, X r * X r = B`, with all factor orders retained.
`skew_trace` handles the sign of the commutator cross term for arbitrary
residual matrices. `weighted_young` proves the weighted completion of
squares entrywise. `trace_defect_commutator` establishes the exact
two-index expression for `P`, using symmetry of `b`.
`gram_le_defect` symmetrizes and bounds the contracted Gram term by `P`.
Its scalar bound follows by rational algebra from
`u*v*(u+v-3/4)+1/64 ≥ 0` for all `u,v ≥ 0`.
The latter is proved by two cases on the sign of `u+v-3/4`, using products
of squares; it needs no restriction `u,v ≤ 1` and no numerical sampling.
The final theorem rewrites the weighted deficit using
`S + (5/37)I = T + (42/37)I` and rearranges the exact traces.

## Scope and trust limits

This is a Lean 4.31.0 proof of the complete finite-dimensional **real matrix
commutator inequality only**. It does not formalize or establish the
manuscript's entropy theorem, analytic transport arguments, equality
classification, or other dependency claims.
It makes no novelty claim and records no independent-review acceptance.
The proof uses Mathlib and Lean's standard foundations; it introduces no
extra axioms, proof holes, unsafe trust shortcuts, or assumed scalar-to-matrix
lifting. The source prints the final theorem's axiom dependencies.
