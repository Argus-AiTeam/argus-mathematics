# Statement fidelity: universal residue/characteristic bridge

The claim recorded for this source is `C_UNIVERSAL_BRIDGE`. It is an
algebraic bridge, **not** a Lean formalization of the entire complexity
proposition.

## Arbitrary-ring residue bridge

`ResidueBridge.residue_trace` and `ResidueBridge.residue_power_trace`
quantify over every commutative ring S, every commutative S-algebra A,
every finite index type iota, every S-basis b of A, every S-linear
functional L, every family w indexed by iota, and every generating
family g indexed by an arbitrary type sigma. The hypotheses are:

1. `Algebra.adjoin S (Set.range g) = top`.
2. `sum_i L(w_i) * b_i = 1`, with scalar action understood.
3. For every generator g_j and coordinate i,
   `g_j*w_i = sum_k repr(g_j*b_k)_i * w_k`.

The third is precisely the first-coordinate expression of the diagonal
annihilation of `W = sum_i b_i tensor w_i`; it is not an assumed
trace-residue identity or an assumed dual-basis identity.

`diagonalElement b w` is the actual finite sum `sum_i b_i*w_i`.
The conclusions identify the trace of the multiplication matrix, and
every power trace including k=0, with
`L(v^k * diagonalElement b w)`. In particular the functional L is not
silently replaced by an abstract trace.

`residueOperator_commutes`, `operator_eq_self_of_generators`, and
`residue_coordinates` derive the reproducing and dual-coordinate
identities from those three hypotheses. No nondegeneracy of a trace
pairing, separability, reducedness, or field hypothesis is used.

For the manuscript's actual pure-power quotient, the basis, Laurent
functional, Bezoutian coefficients, generator condition, normalization,
diagonal annihilation, and identification `diagonalElement = J` are
proved in Sections 2-3 of `report.md`. Those identifications are
**ordinary unbounded mathematical proofs, not kernel-checked definitions
of multivariate Laurent series or polynomial quotients in this file**.
The formal theorem retains the displayed structural hypotheses
explicitly. This limitation must accompany any use of its certificate.

## Matrix characteristic bridge

`CharacteristicBridge.charpolyRev_newton` proves the Newton recurrence
over every commutative ring, for every finite square matrix and every
nonnegative recurrence index. It derives it from the determinant
derivative and adjugate identity rather than assuming it.

`characteristicExponential D A` is exactly

```
sum_{j=0}^D (j!)^-1 *
  (-sum_{k=1}^D trace(A^k)/k * X^k)^j.
```

`characteristic_coefficient_bridge` proves equality of all coefficients
through degree D with `det(I-X*A)`, whenever the integers 1,...,D are
nonzero in the coefficient field. D need not equal the matrix dimension.
`factorial_ne_zero_of_denominators` verifies the factorial denominators
under the same condition.

For D equal to the matrix dimension,
`universal_charpoly_bridge_charZero` and
`universal_charpoly_bridge_largeChar` prove the characteristic coefficient
identity for every index d with `d <= D`, in characteristic zero and
characteristic p>D respectively. The matrix is arbitrary: it need not
split or be diagonalizable. Both endpoint indices are included. In a
field, `CharP K p` with p>D supplies exactly the needed denominator
condition; applying the result to a prime field requires no stronger
prime cutoff.

## Combined bridge and numerical cutoff

`DeterminantCore.residue_characteristic_coefficient` combines the two
bridges. Its polynomial `residueExponential` uses
`L(v^k * diagonalElement b w)` itself, not trace inputs. It assumes
exactly the three structural residue hypotheses above and the
nonvanishing of 1,...,D. Its large-characteristic corollary
`residue_characteristic_largeChar` replaces the denominator condition by
`CharP K p` and D<p.

`stated_prime_exceeds_dimension` proves that the manuscript's exact
numerical cutoff implies `ell^n < p`, with no additional bound.
`flattened_level` checks only the natural-number identity
`max(a+1,4)+1 = max(a+2,5)`: it does **not** encode counting machines or
certify their complexity by itself.

The finite-field grids, actual Laurent coefficient functional and
quotient basis construction, source-to-structural-hypothesis
identifications, uniform bit lengths, hierarchy-machine constructions,
prespecialization norm bounds, and base-change argument are proved in
`report.md`, not represented as fully formal Lean computations.
`verify.py` additionally performs finite adversarial probes; they are
not the proof of the unbounded statements.

## Trust and review boundary

No new axioms or proof holes are allowed. The source prints the axioms
of the principal theorems; only Lean's standard `propext`,
`Classical.choice`, and `Quot.sound` are used. The official compiler
record pins this document and `Main.lean`. It does not certify that this
reading is faithful, assess novelty or significance, or establish the
manuscript's main complexity conclusion. Those remain independent
Reviewer responsibilities.
