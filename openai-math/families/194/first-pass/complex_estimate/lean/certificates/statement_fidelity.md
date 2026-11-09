# Statement fidelity: the finite algebraic core of the complex estimate

The ledger claim is `C_COMPLEX_STABILIZATION`. `Main.lean` uses Lean and
Mathlib, with no user axioms, `sorry`, `admit`, or computational oracles.
The official compiler certificate, not this document, determines whether
the source actually compiles without proof holes.

The declarations described are `descend`, `descend_mem`, `descend_eq_zero`,
`stabilized_range`, `stabilized_unique`, and `normalize_error`, all in the
namespace `ComplexEstimate`.

`ComplexEstimate.descend` is the composite of `n` consecutive maps from
`M (a+n)` to `M a`. The family `M` ranges over arbitrary modules over an
arbitrary commutative ring. The modules at different indices need not be
the same, finite, finitely generated, Noetherian, separated, or complete.

`ComplexEstimate.descend_mem` assumes a family `fil i k` of submodules
and that each transition maps filtration level `k+1` into level `k`.
Its conclusion is that an `n`-fold composite maps level `k+n` into
level `k`. `ComplexEstimate.descend_eq_zero` adds that every level zero
is bottom and every level `n` is top; it concludes that each `n`-fold
composite is the zero linear map. Monotonicity of the filtration is not
needed for these conclusions, so it is not an implicit hypothesis.
In the manuscript application the filtration is the induced finite
homology filtration, and zero associated-graded transition maps supply
the stated lowering condition. Deriving that condition from the Cech or
Koszul spectral sequence remains in the prose proof.

`ComplexEstimate.stabilized_range` quantifies over arbitrary modules
`H`, `BN`, `BM`, `T` and linear maps `iN`, `iM`, `t`, `delta`. It assumes
`t` composed with `iN` equals `iM`, the image of `iM` is the kernel of
`delta`, and `delta` composed with `t` is zero. It concludes the exact
equality of submodules `range t = range iM`. No injectivity of `iN` or
surjectivity of `delta` is assumed or required.
`ComplexEstimate.stabilized_unique` additionally assumes `iM` is
injective and concludes that every element of `range t` has a unique
preimage in `H`. This is the canonical stabilized-image identification,
not an inverse-limit assertion.

For the geometric tower, `H` is one degree of the hyperhomology of
`F_Y`; `BN` and `BM` are the corresponding thickening groups, and
`delta` is the connecting map in the thickening exact triangle.
For the algebraic Koszul tower, `H=H_k(F)`, `BN=H_k(F tensor K_b)`,
`BM=H_k(F tensor K_a)`, and `T=H_k(Q_a)`. The zero-transition and
injectivity hypotheses are established in Sections 1, 3, and 4 of
`../proof.md`. These module assertions apply before passing to the
Serre quotient. Cofinality of the two ideal towers and image comparison
modulo length zero are proved in prose, not encoded as a theorem about
an arbitrary abelian category.

`ComplexEstimate.normalize_error` is an additional universal real
algebra identity. If `lead>0`, `mu>=0`, `power>=0`, the positivity
inequality holds, and `error<=lead*budget`, then
`mu*power*(rank0-budget)<=length`. In equation (30) of `../proof.md`,
`lead=(h-1)!`, `power=s^h`, `rank0=b_0`, and `budget` is the sum-of-ranks
error after dividing by `(h-1)!`. This verifies the coefficient-one
normalization, not the analytic bound on the error.

The compiler does not verify the scheme construction, the additive
length hypotheses, spectral-sequence convergence, the Serre-quotient
argument, root-bundle flatness, Rolle's theorem application, Riemann-sum
bound, or the full complex estimate. Those are asserted and proved in
`../proof.md` and require mathematical review. In particular a kernel
verdict on this source alone must not be assigned to
`C_COMPLEX_ESTIMATE` or to the main Lech inequality.
