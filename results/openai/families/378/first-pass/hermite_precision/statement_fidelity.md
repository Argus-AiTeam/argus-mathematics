# Statement fidelity: C9000378-HERMITE

`Main.lean` is a universal arithmetic and modular-stability core of the
tapered Hermite proof. It is not a formalization of the entire manuscript,
nor a kernel proof of all the grid instantiation and interpolation arguments.
The full recovery theorem is the separate written claim
`C9000378-HERMITE-FULL` in `proof.md`.

## Objects and quantifiers

All parameters are universally quantified natural numbers unless specified
otherwise. Rational numbers use Mathlib's exact `Rat` type. `bounded b x`
means `padicNorm 2 x <= 2^b`, with the exponent `b` an integer; it is not the
ordinary absolute value. Thus `bounded (-p) x` is precisely rational
coordinate error of 2-adic valuation at least `p`, with zero included.

`loss n k` is defined by a finite recurrence. `loss_sum` proves that it is
the sum of `j min(j,k) 2^(n-j)` for `0 <= j <= n`; the zero term vanishes.
It is the `B(n,k)` in the written proof.

`loss_closed` proves

    B(n,k) + (2k+6)2^(n-k) + k(n+2) = 6*2^n

under the sole hypothesis `k <= n`. The natural subtraction in `n-k`
is therefore exact. `loss_le` proves `B(n,k) <= 6*2^n` for every `n,k`,
including `k>n`. `loss_saturated`, `loss_diagonal`, and `loss_closed_add`
are the finite identities used to prove those statements.

`ceilThree M u` is `(3M+u-1)/u`, using natural integer division.
`multiplicity_bound` proves `ceilThree M u * u <= 4M` under `1<=u<=M`.
The lower bound on the number of jets is in the written proof, not this
declaration.

## Integral reciprocals and the exact recovery functional

`integral_inverse` quantifies over arbitrary rational sequences `e,b`.
Its hypotheses are integrality of all `e_j`, `b_0=1`, and the usual
unit-constant inverse recurrence

    b_(n+1) = -sum_{j=0}^n e_(n+1-j) b_j.

It proves integrality of every `b_j`. It does not assert existence of
these sequences or prove the convolution inverse identity. Those
elementary algebraic points are supplied in `proof.md`.

`node E x q b f` is exactly

    E * sum_{0<=j<q} (sum_{0<=r<=j} f_r b_(j-r)) x^j.

Here `E` is the rational scalar `E_t(0)`, `x=-t/alpha`, `b` the
reciprocal coefficient sequence, and `f` the error in the raw local
Taylor coefficients. `node_linear` proves that applying this expression
to the difference of two data sequences is the difference of the
expressions. It is ordinary linear algebra over `Q`.

`node_precision_exact` has hypotheses

    |E|_2 <= 2^s, |x|_2 <= 2^v, |b_j|_2 <= 1,
    |f_r|_2 <= 2^(-(p+s+(q-1)v)) for r<q.

It proves `|node E x q b f|_2 <= 2^(-p)`. For a retained manuscript
node one instantiates `s=hB(a-i,u-i)` and `v=a+1-i`. There is no
assumption about the desired output error among the hypotheses.

`node_precision_paper` instantiates the loss bound with `s=hB(n,k)`
and `v=a+1`. Under `q<=4M`, the scalar norm bound
`|E|_2<=2^(hB(n,k))`, `|x|_2<=2^(a+1)`, and integral `b_j`,
it proves that errors of precision

    p + 8h2^n + 8M(a+1)

produce error of precision `p`. In particular it checks the actual
constants 8 and 8, not merely an unspecified asymptotic bound.

`coordinatewise_precision` quantifies over an arbitrary finite node
set of an arbitrary type, and an arbitrary coordinate index type.
All the node hypotheses are as above, with node-dependent `n,k,q`,
and the input bound is required for every coordinate. It proves the
same output precision for every coordinate of the sum of all nodes.
No dimension bound, field multiplication on the coefficient module,
or reducedness hypothesis is assumed.

## What remains a written mathematical argument

The compiler does not verify that the concrete grid has the claimed
translated shell counts, that its rational product `E_t(0)` has
valuation `-hB(a-i,u-i)`, or that the Hermite identity reconstructs
`F(0)` when its degree is below the total multiplicity. These are
proved explicitly in `proof.md`. Finite exact checks in `verify.py`
are useful regressions for them, not universal formal proofs.

Likewise, the identification of the original
`Z_(2)[U,V]/(f,V^ell)` with its free coordinate module, and its embedding
in the rational scalar extension, is the monic-normal-form argument in
`proof.md`. Once identified, it is covered by the universal coordinate
index in `coordinatewise_precision`; no field theorem is applied to
that ring. The bit complexity and the downstream conditional
asymptotic deductions are also written arguments.

No independent statement-fidelity approval, novelty determination,
or Reviewer acceptance is claimed by this document or by successful
compilation. The mechanical evidence belongs only to
`C9000378-HERMITE`, whose statement explicitly has this core scope.
