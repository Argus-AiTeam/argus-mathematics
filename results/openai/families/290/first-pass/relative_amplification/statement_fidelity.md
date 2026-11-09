# Statement fidelity: C_RA_CORE

`Main.lean`, namespace `RelativeAmplification`, formalizes the dimension-free
loss-and-capture core, not the complete spectral operator implication `C_RA`.
Every theorem is universally quantified; no terminal length or dimension is
fixed by evaluation. There are no additional axioms or admitted proofs.

## Interval capture and Hilbert-space loss

`captureLength e B b` is the length
`max 0 (min B (e+b) - max (-B) (e-b))` of the intersection of two real
intervals. `capture_probability_le` assumes `B>0` and `b>=0` and bounds this
length divided by `2B` by `b/B` for **every real e**. In particular it has no
bounded-spectrum hypothesis. `capture_probability_eq` adds `|e|+b<=B` and
proves equality. These are scalar geometric statements; lifting them through
a projection-valued spectral measure is proved in the report, not encoded.

`norm_sub_sq_le_two` holds in any real-valued seminormed additive group.
`averaging_loss` holds in an arbitrary real inner-product space, for all
vectors `v,u,d` with `norm u<=norm v` and `norm d=norm v`. It proves
`norm(u-d)^2 <= 4*(norm v^2 - norm((u+d)/2)^2)`.
A complex Hilbert space is regarded as a real inner-product space. No
finite-dimensional, spectral, or commutation hypothesis is present.

## Arbitrary finite experiments

In `weighted_error_floor`, `m` is any natural number, including zero.
The six functions of a natural index denote the capture weight, expected
**squared** prefix error, captured ideal squared defect, captured error
squared defect, actual captured squared defect, and expected squared-norm
loss. `prefixError` is already a squared norm, not its square root.
The hypotheses are exactly

```
alpha*c^2*w_j <= ideal_j
capturedError_j <= 4*w_j*prefixError_j
ideal_j <= 2*defect_j + 2*capturedError_j
defect_j <= 4*loss_j
sum_(j<m) loss_j <= 1.
```

The conclusion is

```
(alpha*c^2/8)*sum_(j<m) w_j - 1
  <= sum_(j<m) w_j*prefixError_j.
```

The scalar implication needs no extra nonnegativity hypotheses: its displayed
inequalities suffice. In the operator interpretation all these data are
nonnegative expectations.

`nonsummable_budget_obstruction` permits a different `prefixError m j`
for **each terminal length m**. Nonnegative, nonsummable weights and a
uniform upper bound `eta<gamma` contradict the finite lower bounds
`gamma*sum w - 1 <= sum w*prefixError`. `arbitrary_terminal_amplification`
combines this with the preceding five hypotheses, allowing all five
experiment arrays to depend on `m`. Its strict hypothesis is
`eta<alpha*c^2/8`. Neither a single infinite random experiment nor
consistency between different terminal lengths is assumed.

## The actual nonsummable weights

`captureWeight b A l j = b^2/(2*A*(b+1+(j+1)*l))`, with zero-based `j`.
`capture_weight_harmonic_lower` proves domination of
`[b^2/(2*A*(b+1+l))]/(j+1)`. `capture_weight_not_summable` proves
nonsummability from `b>0`, `A>0`, and `l>=0`, using Mathlib's harmonic-series
theorem. The case `l=0` is included, not divided away.
`affine_capture_amplification` specializes the fully quantified obstruction
to these weights.

## Boundary of the compiler's answer

The operator direct integrals, tensor-word disintegration, Fourier/Plancherel
localization, measurability and integration of the random experiment, spectral
lifting of interval capture, and the extraction of a nonzero local defect are
not encoded. The report proves these analytically and identifies the ledger's
background assumptions. The compiler does not prove that the manuscript's
uniform energy estimate holds, does not formalize bicentralizers, and does not
check novelty or this translation document. `C_RA_CORE` must not be relabelled
as a formal proof of `C_RA` or of the manuscript's main theorem.
