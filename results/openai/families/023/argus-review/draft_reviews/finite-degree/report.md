# Finite-degree observation: assessment

## Disposition and exact claim

**Supported as a prose construction and numerical refinement.** The
bounded-degree selection is not itself formalized in the old Lean source;
the two dominant-full numerical bounds are formalized. Neither fact proves
the analytic full-sum estimates without their separate justification.

The attribution is the old Argus report
`families/023/first-pass/exceptional_moments/report.md`,
the paragraph after Theorem 3 and the end of Section 6. This is the further
observation expressly mentioned beside the three headline theorems, not
an omitted fourth experiment or a new theorem supplied by this review.

Let `M>=1` be a fixed integer, and let at most `M` nonnegative real lengths
`a_i` have sum one. Zero lengths are allowed. There are two overlapping
alternatives:

* A length is at least `19/20`; in the actual prime-factor reduction such a
  factor is genuinely full, and its conditional analytic upper bounds have
  gaps at least `9/100` and `4/25` at the respective endpoints.
* If all lengths are at most `19/20`, a length
  `a in [1/(20*M),1/2]` exists. The multiplicity
  `k=ceil((7/5)/a)` is at most `28*M` and has
  `k*a in [7/5,19/10)`.

Thus, for fixed `M`, the first-endpoint raising, omitting and single-copy
vectors needed by the old exponent argument all belong to a finite family
with coordinates at most `28*M`. This is a bound on the required degree,
not an enumerated search over real exponent vectors and not an explicit
final power saving.

## Decisive construction and boundary cases

If every length is at most `1/2`, one is at least `1/M`, since their
sum is one; this is stronger than the claimed lower bound.
Otherwise there is exactly one length greater than `1/2`.
When it is at most `19/20`, its complementary total is at least `1/20`.
All complementary lengths are short, and there are at most `M` of them.
At least one is therefore at least `1/(20*M)`.
This argument retains zero entries; it does not divide by an unknown minimum
length. For `M=1`, the only possible length is one, so the near-full
alternative applies and the short alternative is unnecessary.

For the selected positive short length,
`(7/5)/a <= 28*M`. The right side is an integer; monotonicity of the
ceiling therefore gives `k<=28*M`, without adding an erroneous extra one.
The coverage argument gives `7/5<=k*a<19/10`.
The raised all-ones vectors have coordinates at most two, and omitted
vectors at most one, so they obey the same degree bound.
The union of `{0,...,28*M}^m` for `1<=m<=M` is finite.
Nothing asserts that every vector in that family is necessary.

At the threshold `a=19/20` both alternatives may be used, which is
harmless. No length region is omitted between the near-full and short
arguments. The finite-degree observation removes the potential objection
that a required multiplicity becomes arbitrarily large across a
fixed-factor-count family after near-full factors have been separated.
It is not needed to prove the unrestricted finite-family theorem, where
a multiplicity can instead be chosen after taking a limiting vector.

## Full-factor arithmetic versus its analytic hypothesis

The old source defines, at the internal height exponent `37/100`,

```
j = 87/50-a
E1(a) = 2-a + max(1,j,2*(1+j)/3)
E2(a) = 4/3+37/50+2*(1-a).
```

On `19/20<=a<=1`, the third term in the first maximum dominates the other
two. Hence

```
E1(a) = 287/75 - 5*a/3
E2(a) = 611/150 - 2*a.
```

Both decrease with `a`. At the lower threshold their differences from
`7/3` are exactly `9/100` and `4/25`; at `a=1` the exponents are
`54/25` and `311/150`. These endpoint computations prove the asserted
bounds throughout the closed near-full interval.
The formal declaration `dominant_full_second` even omits an upper bound
on `a`, valid for its decreasing affine expression; the physical simplex
still has `a<=1`.

The implication "near-full implies genuinely full" is not a theorem about
arbitrary polynomials. In the stated short-Mobius prime decomposition there
are at most `4*k0` factors and every truncated Mobius factor has length
exponent at most `1/2`. Only the remaining full smooth factors can be
near-full. Applying their functional equation additionally needs
nonprincipality, primitive conductors, all missing Euler factors and common
Mellin shifts. These are assessed explicitly by the analytic-dual unit.
The numerical gap alone cannot supply them.

## Evidence, dependencies and remaining limits

The finite-degree pigeonhole/ceiling argument above is a complete elementary
prose proof, not a claim of finite experimental verification or Lean
formalization. The shared source `../Main.lean` proves the interval coverage
and both dominant-full numerical bounds. Its fresh Lean 4.31.0 compile
and axiom audit exit `0`, with no proof holes, are recorded in
`../universal-exponents-lean-verification.json` and
`../certificates/C_EXPONENTS-17c57f67c7fcda79.json`.
The shared default exact replay also exited `0`, checking the relevant
rational affine identities; see `../verification_result.json`.
Neither run checks the unencoded pigeonhole statement.

Mathematical dependencies are the interval construction, the existing
first-endpoint defect argument, and, for arithmetic application only,
the genuinely-full-factor classification and analytic full-sum estimates.
The numerical parameters belong to the old report and its exact certificate;
no separate literature result is claimed for this elementary refinement.
Its novelty and publication significance are not asserted.

No concrete gap was found in the stated observation. It establishes a finite
collection for **fixed** `M`, not for `M` growing with `Y`, and no explicit
uniform neighborhood size or moment saving. The compactness argument to such
neighborhoods must still use the correct analytic coefficient class and
continuous estimates, as the analytic-dual assessment does.
Native independent Reviewer acceptance remains pending.
