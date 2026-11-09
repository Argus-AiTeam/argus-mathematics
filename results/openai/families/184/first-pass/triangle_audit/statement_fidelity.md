# Statement fidelity: universal algebraic core

`Main.lean` uses Lean 4.31.0 and Mathlib. All declarations below are in
namespace `TriangleAudit`. It proves the following universally quantified
statements, not sampled instances.

* `reversible_swap` concerns every finite index type and
  real functions `pi`, `K`, and `f`. Detailed balance is an explicit
  hypothesis. Its conclusion exchanges both coordinates in the
  expectation. It does not derive detailed balance for graph kernels.
* `averaged_cutoff` and
  `averaged_cutoff_probability` concern every finite
  probability vector and real-valued observable with a specified lower
  bound and mean bound. The latter requires a positive denominator.
  Their conclusion bounds the mass of the strict upper-tail event.
  In the graph proof the observable is the reversed-row log density,
  the lower shift is `log x`, and the threshold is `sqrt x`.
* `halving_sum` concerns every nonnegative real sequence
  satisfying the displayed halving inequality and every finite length.
  It bounds its partial sum by twice its first term.
* `telescoping_loss` and
  `bounded_mass_iteration` concern arbitrary real
  sequences. The latter assumes nonnegative initial masses and losses,
  upper bounds by initial masses, the one-step mass recurrence, total
  losses at most `1/2` and `1`, and the terminal estimate `3*T n<=L*M 0`.
  It concludes `T 0<=2*(1+L/3)*M 0`. There is no graph-order bound or
  assumption about a minimum vertex weight.
* `small_endpoint_bound` concerns every nonnegative real
  `n,x`, every real `ell>=1/2`, and every natural exponent. It proves
  the power inequality used to verify the small endpoint of the
  strict-hierarchy construction.
* `profile_separation` concerns every nonnegative real
  `n`, every real `ell<=1` with `n+n*ell>=0`, and natural exponents
  `q<=p`. It proves the power inequality giving the lower-exponent
  obstruction. The graph application takes `ell=log 2`; the logarithm
  bounds and set eligibility are proved separately in `proof.md`.

The file does **not** encode a finite graph, prove the entropy support
estimate, construct the shared coupling, or formalize the entire
polynomial-profile triangle theorem. Those arguments are provided in
`proof.md` and require independent mathematical review. A compiler
success for this file must be attached only to `C_TRIANGLE_UNIVERSAL_CORE`,
not used to mark either manuscript's complete main theorem, or the full
graph-theoretic generalization, as kernel-verified.

There are no additional axioms, placeholder proofs, finite-search
oracles, or assumptions taken from the manuscript comparator.
