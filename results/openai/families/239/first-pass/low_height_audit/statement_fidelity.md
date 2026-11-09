# Statement fidelity: exact flag amortization

This file describes only claim `L_FLAG_AMORTIZATION`, not the complete
low-height cover or either singularity theorem.

All real variables range over Mathlib's real numbers. `flagBlockCount`
quantifies over an arbitrary finite index type and finite set `s`. For every
index in `s`, `u i` is a block length (a real number at least one), and
`w i` is its total logarithmic excess above the baseline `a`.
The hypotheses are `a >= 0`, `q > 0`, total length at most `c`, total
excess at most zero, excess at least `u i / 5` for blocks with `u i <= q`,
and excess at least `-4*a*u i` for the other blocks. The conclusion is
`s.card <= (20*a + 1/q)*c`. No bound on `w i` is omitted.
`flagBlockCount21` additionally assumes `c >= 0` and `1/q <= a`
and concludes `s.card <= 21*a*c`.

In the mathematical proof, the indices are the consecutive ranges starting
at expensive positions in a shortest projected flag, `q=N^(2/5)`, and
`c` is the transition's dimension drop. Constructing that partition, proving
the suffix inequalities from primitive normal lattices, and deriving the
normalized logarithmic interval bounds from Minkowski's theorem are prose
obligations in `quantitative_cover.md`; they are not Lean hypotheses silently
discharged by a compiler.

`shortBlockBound` and `longBlockBound` verify the exact interval arithmetic
used to obtain those two excess bounds: they assume `u >= 0` and
`w >= u*(1/2 - 4*a - b/2)`. The short conclusion `u/5 <= w`
requires `a <= 1/40` and `b <= 2/5`; the long conclusion
`-4*a*u <= w` requires `b <= 1`. Here `b` stands for
`log_N(block length)`, not the height parameter named `b` in the
quantitative covering theorem.

`singleFlagInexpensive` proves that `y <= a <= 1/40` implies
`y <= 1/2 - 3*a`. `multiDropBudget` proves the stated real
inequality `s <= 4*h/a` from `z <= h/a`,
`theta >= -h/a`, and `s <= 2*(z-theta)`; geometric provenance and
positivity of `a` belong to its prose application.
`squaresBudget` proves, for every finite family of nonnegative reals,
`sum(x_i^2) <= (sum x_i)^2`.

`entropySubstitution` and `logHeightSubstitution` prove the two displayed
rational-function identities in their declarations, with nonzero
denominators explicitly assumed. They certify cancellation of the
multi-drop and logarithmic-height substitutions, not an enumeration of
rational subspaces or a proof of an asymptotic limit.

The source contains no axioms, placeholder proofs, finite-only replacement
of these quantifiers, or invocation of the Reverse Minkowski theorem.
The compiler verifies these formal declarations. Whether this reading
faithfully connects them to the manuscript is an independent review question.
