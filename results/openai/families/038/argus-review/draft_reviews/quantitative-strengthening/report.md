# Explicit discrepancy threshold

**Engineer assessment: supported as a quantitative consequence of the
conditional mechanism.** The sufficient threshold is not asserted optimal,
and its novelty has not been established.

## Exact strengthening and attribution

Under all hypotheses of the conditional geometric bridge, it is sufficient
to choose
\[
 t\in[t_0,n+1),\qquad t>n+1-\frac{a}{n+2}.
\]
For \(a>0\) and \(0<t_0<n+1\), one such positive parameter is the midpoint
of \(n+1\) and \(\max\{t_0,n+1-a/(n+2)\}\). This choice precedes all degree
sequences. The consequence is eventual point centers along every liminf
sequence, not an unqualified all-large-degrees assertion.

This is embedded in old `report.md`, its theorem and section 6,
equations (24)-(27), and the `exists_parameter` declaration.
`PC9000038` versions 2-4 and `PCBRIDGE9000038` versions 1-3 contain the scalar
criterion/bridge; they are not additional independent arguments. The
historical Argus draft derives the explicit threshold. The original OpenAI
`centers.tex` instead sets
\[
 I_*=\int_0^1s^n e^{(1-s)a_*/(n+1)}\,ds>1/(n+1)
\]
and chooses \(t\) close enough to \(n+1\) that \(1/t<I_*\).
This source is the manifest-bound September 23, 2026 revision. The
improvement is an explicit sufficient scalar inequality and error-controlled
closure in place of that qualitative choice, not a stronger unconditional
Fujita theorem.

## Decisive quantitative argument

For every natural \(q\) and positive partition length \(l\),
\(1/(q+1)-1/l\leq S_q(l)\leq1/(q+1)\). With \(u=a/t\geq0\), the
exponential tangent inequality gives
\[
 R_n(u,l)\geq(1+u)S_n(l)-uS_{n+1}(l)
 \geq\frac1{n+1}+\frac{u}{(n+1)(n+2)}-\frac{1+u}{l}.
\]
Combining with every per-partition upper bound and removing the explicit
\(1/l\) error yields \(t+a/(n+2)\leq n+1\). The opposite strict parameter
inequality is impossible for persistent positive-dimensional minimizers.
The final Lean source proves both the universal lower bound and parameter
existence, rather than checking a grid of possible dimensions.

All denominators are positive in the application. The denominator-cleared
moment margin is the polynomial
\[
 d\{\sigma[t(n+2)+a]-(n+1)(n+2)\}.
\]
Factoring this polynomial verifies the algebraic identity only. It does not
prove that the margin has a sign for all real inputs, the geometric moment
premises, or an optimized value of \(t\).

## Bounded computation actually replayed

The old sparse rational payload has five ordered variables
`[d,sigma,t,n,a]` and six nonzero terms. Using the required isolated Argus
adapter with `$WORKSPACE/argus-live-update/.venv/bin/python`, a
small candidate set was discovered and the exact contract inspected before
one fresh execution of `polynomial.multivariate.factor.compute`.
The inspected contract accepts bounded nonzero canonical QQ polynomials
in at least two variables (at most eight, at most 4,096 terms).
The existing six-term payload fits; it is not a nearby proxy for the claim.

The exact payload, typed output, adapter status and stderr are preserved as
`jacobian_payload.json`, `jacobian_output.json`, `jacobian_status.json`, and
`jacobian_stderr.txt`. Discovery/contract outputs are in the parent review
directory. The fresh result reports server 0.14.0, protocol 2025-11-25,
MCP stdio, `FACTORIZED`, `product_reconstruction:EXACT`, runtime 286 ms,
adapter exit 0, empty stderr and no structured error. The input/output
operation IDs and request payload match exactly.

`../input_checks.py` uses the old checker's exact rational polynomial
helpers to multiply the *fresh* factors independently; it does not rerun
the fixtures. The product equals the retained input polynomial. Factor
irreducibility is not needed for this identity. A timeout, transport failure,
`EXECUTION_FAILED`, incomplete output or budget-exceeded output would have
been a non-conclusion; none is reported here.

The old checker was also freshly executed once without writing flags. Its
160 rational partition fixtures cover \(n=1,\ldots,10\), four nonnegative
rational \(u\)'s, and lengths 2, 3, 7, 17. They check the polynomial tangent
lower comparison, not numerical exponential integrals or the universal
theorem. The actual universal exponential bound and error removal are in
the fresh scalar Lean certificate.

## Remaining obligations

No gap was found in the sufficient quantitative criterion at its conditional
scope. The native Reviewer must check its interpretation and the geometric
premises, and independently assess any proposed originality. The old draft
reports a bounded search with no independently established source for this
criterion; that negative search does not establish novelty. This review did
not perform a new novelty campaign and does not claim `verified_new`.
No optimal threshold, uniform center-degree slope, counterexample, or
unconditional manuscript theorem is certified by the factorization.
