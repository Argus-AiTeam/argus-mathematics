# Local scarcity: analytic verification and parameter extension

The argument in [local_scarcity/proof.md](local_scarcity/proof.md) proves the
complete `can:local-scarcity` statement for actual standard sine-map orbits,
uniformly over central positions, base coordinates, sufficiently large
parameters, and unbounded selected indices. It preserves the permission for
the witnessing common normalized solution to depend on the rescaled point.
There is no endpoint-smallness or rematching assumption at those points.

The stronger theorem obtained is:

> For every fixed \(2/3<c<1\) and \(\alpha\geq0\) with
> \(2\alpha<3c-1\), the same uniform neighborhood-scarcity conclusion holds
> with good-index threshold \(c\) and base logarithmic matching window
> \(\alpha\).

This includes the manuscript's \(c=99/100,\alpha=3/5\). The improvement is
the all-depth Green inverse-chain estimate
\[
H\leq n-(2n-1)c-\frac1n\sum_i p_i(d_i-1),
\qquad c\geq\frac{n+2}{2n-1},\quad c<1.
\]
At order eight it makes the degree-seven boundary Taylor remainder
\(O(M^{9-15c})=o(M^{-1})\) for every \(c>2/3\).
Both opposite-cosine cancellation and every vanishing-second-slope regime
are proved in the mathematical argument. At order four the estimate gives
\(M^{-293/100}\) at the manuscript's threshold, verifying its weaker
fourth-derivative bound.

**Exact support.** `python3 research/verify.py` replays universal
inverse/reciprocal derivative algebra, weighted-path coefficients, all 4,428
finite cut reductions, and the determinant-16 alternating-quadratic
obstruction. These are reductions supporting an all-depth proof, not a finite
parameter search offered as a uniform theorem.
The exact result is `research/exact_certificate.json`.
The original Jacobian payload and typed output are retained under
`research/local_scarcity/`; its inspected matrix contracts do not decide
universal sine dynamics or analytic compactness.

**Formal scope.** `research/local_scarcity/Main.lean` has a real Lean 4.31.0
compiler run with `exit_code=0`, `proof_holes=[]`, and a successful axiom
audit, recorded on C_FORMAL_ALGEBRA. Its archived certificate is
`research/local_scarcity/certificates/C_FORMAL_ALGEBRA-03b6c46e613a2098.json`.
It proves the unrestricted real-depth expanded eighth-chain inequality and
three algebraic obstructions, not the whole scarcity theorem. The exact
translation boundary is in `statement_fidelity.md`.

To reproduce the compiler evidence, run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/local_scarcity/Main.lean --statement-fidelity research/local_scarcity/statement_fidelity.md --artifact-dir research/local_scarcity --project-root . --claim C_FORMAL_ALGEBRA --timeout 100
```

**Review boundary.** No false manuscript assertion or counterexample has been
established, so there is no invented F_ claim or `refutes` judgment.
The independent Reviewer has not yet read or replayed this result. The full
analytic proof, statement fidelity, novelty, and publishable significance
remain for that review. The Wiki/literature lookup supplied no verified prior
source for the parameter extension; absence of such a source is not a novelty
certificate. The main entropy theorem, bridge estimate, and multiscale
dependencies are recorded as open, not claimed proved.
