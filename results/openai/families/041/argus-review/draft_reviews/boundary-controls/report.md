# Boundary controls: exact examples, not manuscript counterexamples

**Engineer assessment: the controls are valid for the proposed extensions
they exclude. They are inadmissible attacks on the manuscript's actual
hypotheses.** This substantive unit was not a separate legacy claim ID.
It occurs in `proof.md:274-294`, `exact_certificate.json`, and `verify.py`
and must not disappear merely because it lacks a `C_` label.

## Exact all-prime construction

For any prime \(p\), take \(K=\mathbb F_p(u)\),
\(R=\mathbb F_p[u]\), or its local ring at \((u)\), and let
\[
 s=u^{p-1},\quad g=u^p,\quad \psi(r)=C_u(sr).
\]
The Cartier extraction rule gives \(\psi(1)=1\) and
\[
 \psi(gr)=C_u(u^p sr)=u C_u(sr)=u\psi(r).
\]
Hence \(\psi(gR)\subset(u)\), so no regular multiplier produces a unit.
For the local ring the map is indeed regular: for a denominator \(h\)
with \(h(0)\ne0\), write \(f/h=f h^{p-1}/h^p\) and apply Cartier
semilinearity. The resulting denominator \(h\) is still a unit.
Thus the local example is not an illicit map out of \(R\).

If an **unrestricted nonregular coefficient** were allowed, the
order-zero identity \(s=u^{-p}gs\) would satisfy the displayed scalar
equation while clearing would fail. But \(u^{-p}\notin R\); it cannot
belong to any coefficient subring \(A\subset R\).
This refutes dropping coefficient regularity, not the retained theorem.

If the **p-th Hasse derivative** were allowed instead of ordinary
derivative words, then
\[
 \partial^{[p]}(gs)=\binom{2p-1}{p}u^{p-1}=s.
\]
Indeed
\(\binom{2p-1}{p}=\prod_{i=1}^{p-1}(p+i)/i\equiv1\pmod p\).
This operator is not an ordinary derivation or an allowed retained
ordinary word. In particular
\(C_u(\partial^{[p]}u^{2p-1})=1\), so it violates the derivative
annihilation step on which the adjoint proof depends.
Ordinary p-fold differentiation is not interchangeable with Hasse
differentiation in characteristic p.

These are elementary parameter-uniform proofs. The finite loops are not
the argument that they hold for every prime or every local rational
function. The examples establish neither a false intermediate lemma
under all its hypotheses nor a flaw in either global manuscript.

## Executable inspection and isolated replay

The old `verify.py` was read in full before execution. It uses standard
library exact sparse Laurent arithmetic and subprocesses for Lean;
its normal entrypoint also recompiles the source. It was copied with
its input dependencies into `../cartier-adjoint/replay/`. Only its
`check_jacobian` and `exact_diagnostics` functions were called.
Its `main` and `replay_lean` functions were deliberately not called,
because the official fresh compiler check is performed once in the
adjoint unit. Import bytecode writes were disabled.

`../cartier-adjoint/diagnostics.json` records the successful replay:
10 derivative-annihilation checks, 75 word-adjoint checks,
208 complementary coefficient-extraction checks, 3,158 tame monomial
trace checks, and 10 reported excluded-hypothesis control groups.
The characteristics are \(2,3,5,7,11\); the word checks use two
coordinates and lengths at most three. For every tested \(2\le e<p\),
the trace loop uses exponents \(-2pe\le m\le2pe\).
It also tests particular polynomial monomials in the control image.

Despite the old counter name `rational_coefficient_extraction`, the
implemented extraction tests use specified Laurent polynomials, a subclass
of rational functions. They do not exhaust arbitrary rational denominators,
dimensions, fields, coefficients, completions, or ramified extensions.
The tame tests check a specific monomial trace formula, not all the
completion and normality hypotheses of the completed-trace argument.

## Exact Jacobian contract and one bounded replay

The three old Jacobian JSON files describe a successful derivative over
**QQ**, not a characteristic-p Cartier solver. Their contract, payload,
operation ID, server/protocol and output consistency were checked by
the inspected old checker.

The current prescribed adapter was then used, never a Jacobian import in
the legacy Argus environment:
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`.
Discovery returned a bounded five-operation candidate set.
`polynomial_field.scalar.directional_derivative.compute` was inspected
before execution. Its typed input is one sparse rational polynomial in
1-8 named variables with at most 4,096 terms and a matching rational
direction vector; it does not accept a rational p-basis field or a
completion.

The exact preserved payload is the old one:
\(u^3v^2+v\) over QQ, variables `[u,v]`, direction `[1,0]`.
One run returned \(3u^2v^2\), method
`SYMPY_DIRECTIONAL_DERIVATIVE`, runtime 21 ms.
Server version was 0.14.0, protocol `2025-11-25`;
adapter exit was 0 with no structured error or timeout.
Discovery, inspected schemas, exact payload, raw typed result, and execution
status are dedicated `jacobian_*.json` files in this directory.

This replay reproduces the old bounded diagnostic and no more. It proves
no adjoint-sign identity, no finite-characteristic Cartier assertion, no
geometric normalization, and no completion theorem. The nearby operation
has not been forced into a role its contract cannot fill.

## Attribution and disposition

The controls are old Argus examples and the diagnostics reproduce existing
work. No originality or manuscript-error finding is asserted.
Their failure as manuscript attacks was recorded in the active ledger
before substantive assessment. They are counted once here, not as two
new counterexamples and not as additional evidence that either manuscript
theorem is true. Native independent review is still required.
