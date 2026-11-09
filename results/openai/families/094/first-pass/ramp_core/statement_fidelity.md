# Statement fidelity for C_RAMP_AMPLIFICATION

Source: `research/ramp_core/Main.lean`, namespace `RampCore`.
Target compiler: Lean 4.31.0 with the host's built Mathlib workspace.

## What is formally proved

`RampCore.signed_dyadic_cap` quantifies over **every real** `p > 2`,
every real `B > 0`, every natural `N` (including zero), and every real
sequence `a : Nat -> Real`. Its only size hypothesis is
`abs (a k) <= B * 2^k` for `k < N`. Its conclusion is

\[
 |\sum_{k<N}a_k|^p
 \le K_p B^{p-2}\sum_{k<N}(2^k)^{p-2}a_k^2,\qquad
 K_p=4^{p-1}/(1-2^{2-p}).
\]

`RampCore.weight p k` denotes `(2^k)^(p-2)`, not a probability.
`RampCore.capConstant p` denotes the displayed \(K_p\).
The signs of the summands are unrestricted. The statement has no
dimension, independence, nonvanishing, equal-weight, or bounded-weight-ratio
hypothesis. Powers with real exponents are `Real.rpow`; the bases in the
conclusion are nonnegative. The proof establishes the positivity of the
geometric denominator from `p > 2`; it is not an extra assumption.

`RampCore.signed_dyadic_lintegral` is the nonnegative-integral version of
this inequality. It quantifies over any type with any measurable space,
any measure `mu` (not assumed finite or a probability), and a family of
measurable real functions `f k`. Its pointwise caps are the same dyadic
caps. Its conclusion bounds the integral of the power of the signed sum by

\[
 \operatorname{ofReal}(K_pB^{p-2})
 \sum_{k<N}\operatorname{ofReal}((2^k)^{p-2})
       \int^- \operatorname{ofReal}(f_k^2)\,d\mu.
\]

Here `ofReal` is Mathlib's map from a real number to the extended
nonnegative reals. All displayed integrands are nonnegative. These are
genuine Lebesgue lower integrals, not a finitely supported substitute.
The family is measurable at every natural index; unused indices can be
extended by zero. `RampCore.signed_dyadic_energy_bound` specializes the
quadratic terms to a common upper bound `D : ENNReal` and proves a bound
with factor `N * D`.

`RampCore.ramp_error_energy` is the checked signed-cutoff application.
For every real `p > 2`, real `H >= 1`, natural `ell` (even allowing zero),
measure `mu`, and measurable family `A k`, it assumes precisely

\[
 |A_k(x)|\le 2H2^k,\qquad
 (2^k)^{p-2}\int |A_k|^2\,d\mu\le p/(p-2)
 \quad(k<2\ell).
\]

The second hypothesis is expressed using `ofReal` and nonnegative
integrals. The theorem proves

\[
 \int |\sum_{k=\ell}^{2\ell-1}A_k-\sum_{k=0}^{\ell-1}A_k|^p\,d\mu
 \le C_p H^{p-2}\ell,
\]

where `RampCore.errorConstant p` is
`2^(p-1) * capConstant p * (p/(p-2))`, equal to
\(8^{p-1}p/((p-2)(1-2^{2-p}))\).
`RampCore.signedCutoff` puts the negative sign on the first `ell`
terms and the positive sign on the next `ell` terms.
`RampCore.rampError` sums those `2*ell` terms.
`RampCore.rampError_eq_blocks` proves, for every `ell`, that this
definition is the block difference displayed above. The theorem does
**not** assume an \(L_p\) bound on that difference.

## Checked algebraic pieces of the actual projection reduction

`RampCore.weighted_quadratic_contraction` quantifies over an arbitrary
finite coordinate type, arbitrary nonnegative real weights `sigma`, and
real vectors `x,y`. From
`sum_e sigma_e*y_e*(x_e-y_e)=0`, it proves
`sum_e sigma_e*(x_e-y_e)^2 <= sum_e sigma_e*x_e^2`.
For the manuscript use `y=P x`. The orthogonality hypothesis is a
defining property of its weighted orthogonal projection. There is no
lower bound on a positive weight.

`RampCore.row_cutoff_cap` quantifies over an arbitrary finite coordinate
type and a matrix row whose sum of absolute values is at most `H >= 1`.
For every coordinate vector bounded by `T >= 0`, it proves
`abs (row*x - x_e) <= 2*H*T`.

`RampCore.projection_tail_identity` quantifies over every real module,
every linear endomorphism `P`, and vectors `v,w` with `P v = v`. It
proves `P w - w = (v-w) - P (v-w)`. Substitution
`w=v_{<=2^k}` is the exact passage from a possibly non-\(L_2\) lower
truncation to an \(L_2\) upper tail.

`RampCore.linear_ramp_identity` is the finite reindexing identity for
`P u-u` with
`u=sum_{k<ell}(T(k+ell)-T(k))`. It holds for every linear map on every
real module, without an orthogonality assumption.

`RampCore.multiplicity_formula` proves for all naturals `ell,j` the
exact count of indices `k < ell` with `k <= j < k+ell`:

`min ell (j+1) - (j+1-ell)`, with natural subtraction.

`RampCore.multiplicity_rising` and `RampCore.multiplicity_falling`
extract the two sides of the triangular profile. These are universal
counting theorems, not tests of selected ramp lengths.

## What remains a mathematical reading rather than a compiler verdict

The source does not encode the original input points, the construction
of `sigma` and `P`, or the law of `v`. For the actual ramp, the
substitution `mu=sigma tensor nu` and
`A_k=(P-I)v_{<=2^k}` is justified in REPORT.md, Sections 1--3.
The row cap, weighted contraction, tail identity, and finite
reindexing are the checked algebra above. The common tail law gives
the magnitude density and the exact large-jump second moment
`p/(p-2)*2^((2-p)k)`; its elementary integration identity is checked
symbolically in `verify.py` with `p=2+alpha`, `alpha>0`.
Thus the quadratic hypothesis of `ramp_error_energy` is derived from
the original hypotheses, not postulated as the desired ramp estimate.

The measure-uniqueness argument turning the common tail into magnitude
density, the real-variable bin integration giving the exact common
energy \(b\), the Riemann-sum energy lower bound, and the final
relative-error arithmetic are written out in REPORT.md. Those
measure-theoretic identifications are not separately encoded in Lean.
The compiler also does not verify the exact three-point sharpness
interval argument or the general finite-taper application in that
report; their exact symbolic and finite arithmetic replays are
supporting evidence, not replacements for their all-parameter proofs.

This formal certification is of the signed-dyadic analytic core and
the named reduction identities. It is not a formalization of the
whole dimension-reduction theorem, a counterexample to the manuscript,
a novelty certificate, or an independent Reviewer approval. A human
reviewer must still check this translation and the explicit remaining
analytic substitutions.
