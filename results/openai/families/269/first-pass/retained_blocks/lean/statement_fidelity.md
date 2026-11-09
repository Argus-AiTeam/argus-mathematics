# Statement fidelity for `Main.lean`

The claim is `C_FORMAL_TRANSFER`, not the complete spherical retained-block
theorem. The source imports the host's Mathlib for Lean 4.31.0.

`RetainedBlocks.diagonalEnergyTransfer` quantifies over any finite index type
and real normed output space. Its inputs are vectors `a i`, `b i`, real
scalars `r i >= 1`, and a continuous linear contraction `D`. The exact
hypothesis is `r i * a i = D (b i)` (scalar multiplication). The conclusion
is the inequality between the sums of squared norms. In the mathematical
proof take `a i = B(v_i^*) Delta_q psi`, `b i = B_i psi`, and let `D` be
the output-sector diagonal `Delta_q`. The conjugation identity supplying
this hypothesis is established in the prose proof, not in Lean.

`RetainedBlocks.kernelSafeRelativeBound` quantifies over any real
inner-product space, an arbitrary continuous linear operator `R`, vector
`x`, and real numbers `L,h,hDelta,C,epsilon`. The assumptions are
`L >= 0`, `C >= 0`, `epsilon >= 0`, `norm R <= epsilon`,
`norm x ^ 2 <= C * hDelta`, and `hDelta <= h`. Its conclusion is
`L + inner x (R x) >= -epsilon*C*h`. In particular it assumes neither
positive semidefiniteness nor invertibility of `R` or any Gram matrix.
Apply it to the realification of the finite Hilbert direct sum of
annihilator outputs. Here `L` is the nonnegative limiting lifted form,
`R` is the coefficient/output-diagonal error, and `hDelta` and `h` are
the limiting conjugated and physical pair energies on a fixed vector.
The source does not prove that `norm R` tends to zero; that follows from
the explicit finite coefficient limits and diagonal formulas in the
prose theorem.

`RetainedBlocks.selectiveMargin` proves the exact rational coefficient
identity with allowance price 658. `strongerThanStagedCoefficient` proves
its strict comparison with the staged coefficient. Neither declaration
asserts that this gap coefficient improves the later literature.

Not formalized here: the CAR normal-ordering identity; SU(2) decomposition
and Haar averaging; reconstruction and PSD of the seven-row matrices;
singular compression equivalence; the local/spectator Fock
factorization; the infinite three-body tail; and the final eventually-in-q
operator theorem. Those obligations are separately proved in `theorem.md`
and, where finite and arithmetic, replayed by `verify.py`. A successful
Lean run certifies only the declarations identified above.
