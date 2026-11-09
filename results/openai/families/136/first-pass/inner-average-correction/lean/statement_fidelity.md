# Statement fidelity: IAC_FORMAL_CORE

This note describes the declarations in `Main.lean`, namespace
`InnerAverageCorrection`. It certifies only the universal analytical and
finite-index core used in Sections 1, 2, and 5 of `../proof.md`.

## `mixing_contraction`

The objects `theta, x, y, lambda` are arbitrary real numbers. Hypotheses are
`x >= 0`, `y >= 0`, `theta >= 1/8`, `x <= theta/2`,
`lambda <= 1/64`, and
`theta*y <= x*y + lambda*sqrt(x*y)`. The conclusion is `y <= x/16`.
Unlike the manuscript application, the formal statement does not need
`lambda >= 0` or fractions bounded above by one. This is a stronger
real-variable implication. The source application supplies these additional
conditions anyway. The proof explicitly handles y=0 and does not square
an inequality without checking its sign.

## `product_support_accounting`

For arbitrary real delta and strictly positive real s, this declaration
proves the exact identity
`2*(s*delta/4)/s + delta/2 = delta`. In the support proof, s is 1/256
and delta is positive. The formal identity needs only s>0.

## `weighted_exceptional_mass`

X is an arbitrary finite nonempty type. It represents the COMPLETE outer
index, including both coordinates of a product request; no theorem
replaces it by separate marginal indices. The real functions q and R
are weights and residual scores. C is nonnegative, every R(x) is
nonnegative, `q(x) <= C/card(X)`, and
`sum_x R(x) <= card(X)*T*delta`. T and delta are real parameters.
The conclusion bounds the unnormalized weighted mass of
`{x : R(x)>1/8}` by `8*C*T*delta`.

Neither nonnegative q nor normalization of q is needed for this upper
bound. In the application q is a probability law or a subdistribution
and has those additional properties. No conditioning or renormalization
is present in the declaration.

## `common_exceptional_set`

The preceding objects and hypotheses are retained. Forms is an arbitrary
type, not necessarily finite, and p(x,f) is a real score satisfying
`p(x,f) <= 1/32 + R(x)` for EVERY x and EVERY requested form f.
There exists a set E with the explicit membership equivalence
`x in E <-> R(x)>1/8`. For all x outside E and all f, the conclusion
is `p(x,f) <= 5/32`. The same E has q-mass at most `8*C*T*delta`.

The membership equivalence makes E independent of f, p, q, and C once
R is fixed. It is the same complete-index exceptional set for arbitrary
form choices, not a separate set chosen after each form. The source's
bad-column and cone-simulation budgets supply the term 1/32. The
construction of R from group shifts and support envelopes is NOT
formalized here.

## `fixed_radius_before_accuracy`

B, T, nu, and zeta are arbitrary strictly positive real numbers. The
conclusion chooses a strictly positive rho equal to
`nu*zeta/(64*B*T)` BEFORE universally quantifying over the later
real density C>=1 and real accuracy eta>0. For every such C and eta
it then chooses a strictly positive delta and proves
`T*B*rho/(nu*zeta)=1/64` and `8*C*T*delta=eta/2`.
The proof uses `delta=eta/(16*T*C)`. Row rounds and amplification
counts do not appear in rho or in its quantifier scope.

## Limits of this formalization

These are universal real and finite-sum theorems, not finite experiments.
They do not construct the affine expander, parity matrices, canonical
polynomial arrays, tensor row decoder, flags, bit simulator, or independent
majority trials. Those constructions and the support-to-score reduction
are proved or explicitly hypothesized in `../proof.md`, not by Lean.
No assertion of `thm:port-gadget`, `thm:main`, novelty, publication-level
significance, or independent Reviewer approval is encoded.

Reading this note against the actual source is an independent human
obligation. Compilation checks the declarations, not the truth of this
description.
