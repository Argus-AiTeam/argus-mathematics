# Statement fidelity: the actual-image filtered-ring reduction

This document describes `PrimeFiveKernel` in `Main.lean`. It does not claim
that Lean defines spectra, Morava localization, homotopy fixed points,
the sphere element beta_1, or any of the cited topological theorems.

`MultiplicativeFiltration R` is a decreasing sequence of additive subgroups
of an arbitrary, possibly noncommutative, ring. It contains 1 at index zero,
multiplies index i and index j into index i+j, and is separated: an element
belonging to every level is zero. This last assertion is a hypothesis, not a
consequence inferred from convergence by Lean.

`zero_of_constant_tail` proves that an element of level N is zero if all
levels from N onward equal their successors. Vanishing successive quotients
in the topological application imply these equalities; the construction of
those quotients is outside the formalization.

`power_mem` proves membership of x^m in level f*m from membership of x in
level f, for every natural m, including zero.
`power_vanishes` combines that fact with a constant tail and N <= f*m.
`nonzero_of_nonzero_graded` proves nonvanishing from nonmembership in the
next additive subgroup. It does not construct an associated-graded ring.
`smaller_power_nonzero` proves, for every monoid with zero, that a nonzero
kth power forces every mth power with m <= k to be nonzero.

`canonical_kernel_of_detection` quantifies over five arbitrary rings and
five specified ring homomorphisms:

- i: A -> V, the lower sphere/completion/localization image;
- upper: A -> B, the upper sphere-unit image;
- j: B -> W, the further upper completion/localization image;
- canonical: V -> W, the specified map being audited;
- detector: V -> D, the actual lower detector.

It assumes the equality canonical.comp i = j.comp upper, nonzero detected
mth power, and zero upper mth power. It proves that the mth power in V is
nonzero and its image under the *specified* canonical map is zero. The
commutative square is a hypothesis; no arbitrary kernel map is substituted.
The topological completion/naturality argument constructs precisely this
square. Forgetting the grading by taking the total homotopy ring is
legitimate for these associative products; the formal theorem itself
does not encode grading.

`prime_five_kernel_interval` assumes the same maps and square, a separated
multiplicative filtration on B with constant tail from 26, membership of
upper(x) at index two, and nonzero sixteenth detected power. For every
natural m with 13 <= m <= 16, it proves nonzero mth power in V and zero
image under canonical. These hypotheses are NOT assumed conclusions of the
prime-five topological claim: their construction and literature inputs are
proved or exposed individually in `proof.md` and the proof graph.

`prime_five_degrees` checks the exact degree and threshold arithmetic.
It makes no assertion about homotopy groups.

The compiler therefore certifies an unconditional abstract algebraic
reduction with explicitly quantified hypotheses, not a closed-kernel
formalization of the topological theorem. External topological assumptions
remain in `research/MATH_STATE.json`; they are not discharged by this file.
