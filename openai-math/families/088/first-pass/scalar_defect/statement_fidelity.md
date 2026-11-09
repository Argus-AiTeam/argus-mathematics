# Reading of `Main.lean`

The source is an independent formalization of the scalar algebra in
`04_norm.tex` of the staged OpenAI Petty preprint dated September 24, 2026.
It is not a formalization of the entire geometric theorem.

## Principal declarations

`ScalarDefect.scalar_defect` quantifies over **every** `n : Nat` with
`4 <= n` and **every** `z : Real` with `0 < z`. Its conclusion is

```text
(41/360 : Real) * (z-1)^2 / (max 1 z)^(2*n) <= 2*W n z - L n z
```

No desired positivity, coefficient sign, dimension bound above four,
finite-enumeration oracle, or unproved analytic lemma is a hypothesis.
The split at `z <= 1` is exhaustive and includes `z = 1`.

`ScalarDefect.scalar_equality` has the same quantifiers and hypotheses and
concludes `2*W n z = L n z` if and only if `z = 1`.

`ScalarDefect.scalar_mean` quantifies over every natural `n >= 4` and
proves the manuscript's other scalar estimate:

```text
meanCoefficient n <= (2*k n-1)/(k n)^2
```

Here `meanCoefficient` is exactly
`spec n * (2*n*(beta n)^2/(weight n*(2*n+8)) -
           (1-beta n)^2/(1-weight n))`.

`ScalarDefect.double_power_tail` quantifies over every natural `n`
(including zero) and real `x >= 0` and proves
`8 * tail3 n x <= tail3 (2*n) x`.
`tail3_nonneg` proves nonnegativity of each tail, where

```text
tail3 n x = (1+x)^n - 1 - (n:Real)*x
              - (n:Real)*((n:Real)-1)/2*x^2.
```

These are real subtractions, not truncated natural subtractions.
The universal proof is by exact power recurrences (`cubic_le_pow` and
`doubleTail_nonneg`), not by checking finitely many dimensions.

## Objects and normalization

All scalar arithmetic is in `Real`. Natural numbers are coerced to reals
in coefficients; natural powers are used only for the integer exponents.
`k`, `beta`, `weight`, and `spec` are exactly the manuscript's piecewise
values. `k` is real-valued because it occurs only in scalar coefficients.
The integer powers \(z^k\) are written separately as `phi n z`, equal
to `z` in dimension four and `z^2` otherwise.

`e`, `M`, `W`, `G`, and `D` reproduce the definitions in the source.
In particular `G` is zero at and below one, not the untruncated formula.
`W` is `z-1+e` for dimension four and `z^2-z+e` otherwise.
`spec` denotes \(c_{n,k}\), not a newly optimized spectral constant.
`weight` is `3/14`, `1/3`, or `1/2` in precisely the original dimension
split. The factor \(p\) in `L` is `(n:Real)-1` and \(d_*\) is `2*n+8`.
No normalization is rescaled in the principal theorem.

The source uses `zI n z` for the product \(zI(z)\). For positive `z`,
write `a = z^n`. In dimension four its nonzero branch is

```text
z^2-z - 2*(z-z/a)/n + (z-1/a^2)/(2*n+1).
```

For dimensions at least five it is

```text
4*((z^4-z)/3 - 2*(z-z^2/a)/(n-1)
                    + (z-1/a^2)/(2*n+1)).
```

These follow by multiplying the manuscript's displayed closed form for
`I` by `z`, using positive `z` and integer `n`. At and below one `zI` is
zero. The exact verifier independently checks that the original closed
form has derivative \(M'^2\) and value zero at one, including arbitrary
dimension for \(k=2\). The Lean theorem is algebraic: it does not assert
a theorem about integration or differentiation of `I`.

`L` is the manuscript's formula with `zI` substituted for the product
`z*I`. `defect n z` abbreviates `2*W n z-L n z`.
Thus the formal statement does not introduce an abstract defect with
the desired bound as an assumption.

## Coverage of the dimension branches

`invTaylor_scaled`, `W1_left`, and `defect_left` cover all `n >= 4`
on the full interval `0 < z <= 1`.
`small_scaled4`, `small_scaled5`, and `small_scaled6` derive the
three printed polynomials from the defining rational expressions.
Their lower bounds are proved using exact quadratic square
certificates, not values sampled at points.

`large_scaled` derives the large-dimension polynomial identity for
every natural `n >= 7`. `large_bridge_lower` handles exactly `7,8,9`
by expanding the defining polynomials and proving nonnegative
coefficients. `large_signs`, `large_cancellations`, and
`large_power_lower` cover every natural `n >= 10` using the universal
power-tail theorem. `defect_right` combines all cases. These statements
retain the original constants, powers, and equality at one.

## What this compiler run does not establish

The formalization does not contain spherical measure, norms on
\(\mathbb R^n\), the projection `Q`, the curvature bound, a norm's
normalization, or the integration step in the quantitative norm theorem.
Those are addressed in `report.md`, which explicitly retains the
manuscript's curvature/projection reduction as an analytic input.
Compilation alone does not establish that this reading is faithful,
that the strengthening has literature priority, that it meets a
publishability threshold, or that an independent Reviewer has approved it.
