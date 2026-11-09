# Failed attacks and the exact local calculations

## Disposition

**The two documented attacks do not refute the exact sewing theorem.**
The shear-omission objection uses the wrong pullback of a Hamiltonian
vector field. A constant transverse drift is symplectic but not exact.
The surviving evidence consists of local universal identities and an
excluded nonexact boundary case, not a counterexample, an exhaustive
search, or a proof that the manuscript is correct.

This unit covers Section 1 of the old
`9000042/research/sewing-audit/report.md`, its `verify.py`,
`exact_certificate.json`, and the saved Jacobian input/output pair.
It has no separate old ledger claim: the same calculations support the
sewing and effective units. The eight inventory files are not eight
mathematical results.

The target hypotheses and source revision are those of
`../annular-sewing/report.md`. In particular transitions are degree-one
maps of a cylinder times a disc with zero Liouville period and actual
compatible maps into one surface. These are stronger conditions than
the local determinant test performed here.

## The shear objection

For \(J(w,p)=(w+a(p),p)\), \(Q=G\circ J\), and
\(X_G=(G_p,-G_w)\),
\[
 (DJ)^{-1}(X_G\circ J)
   =(G_p\circ J+a'G_w\circ J,-G_w\circ J)=X_Q.
\]
The extra horizontal term is supplied by the chain rule, not left over
as an obstruction. The source actually uses the Hamiltonian of the
conjugated flow; it does not merely evaluate \(X_G\) at \(J\).
The splitting equation \(G_j-G_{j+1}\circ J_j=-H_j\) consequently
cancels the full first-order Hamiltonian error, including that term.

The symbolic probe takes
\[
 z=e^{kw},\quad k=2\pi i n,\quad n\in\mathbb Z\setminus\{0\},\quad
 E=(w,p+\epsilon z),\quad J=(w+a_0+sp^2,p).
\]
For \(F=J\circ E=(W,P)\), its exact identities are
\[
 \det DF=1,\qquad
 F^*\lambda-\lambda
   =d\left(\frac{2s}{3}(p+\epsilon z)^3+\frac{\epsilon z}{k}\right).
\]
The checker uses the derivation
\(\partial_w=\partial/\partial w+kz\,\partial/\partial z\),
so its polynomial/rational identities respect the exponential chain
rule. Periodicity and the nonzero \(k\) needed by the primitive come
from the stated integer-mode restriction, not a symbolic assertion
that an arbitrary \(k\) is periodic.

This family confirms a local cancellation in the potentially troublesome
transverse-dependent case. It does not construct an entire admissible
chain, supply compatible surface charts on all blocks, or violate the
sewing conclusion. The corresponding historical route is retired for
the concrete reason that the alleged first-order residual disappears
under the correct Hamiltonian pullback.

## Constant drift and accumulated periods

For \(E(w,p)=(w,p+c)\),
\[
 E^*\lambda-\lambda=c\,dw,\qquad
 \int_{\text{period circle}}c\,dw=c.
\]
Thus \(c\neq0\) fails exactness, even though its active determinant is
one. It cannot be an admissible counterexample to `sew:chain`.

For degree-one symplectic maps, periods add under composition and change
sign under inversion. If a transition has period \(D_j\) and coordinate
changes have periods \(c_j\), a zero-period normalized transition
requires
\[
 c_{j+1}-c_j=D_j.
\]
For uniformly small coordinate changes on fixed buffered circles, these
periods are uniformly bounded: expanding their Liouville integral and
using one coordinate Cauchy bound gives a constant times their
displacement plus its quadratic correction. Nonzero constant \(D_j\)
would force \(c_j=c_0+jD_j\), contradicting that boundedness.
This is a valid obstruction to a **different nonexact** problem.

It does not refute `sew:centers`: that lemma explicitly permits
accumulated center displacement, conditional on continued uniform
buffered charts around the new centers. A one-step period identity does
not prove that geometric condition. Both the inadmissible-drift route
and the proposed bounded-period repair of a nonzero constant drift
are closed as attacks on the stated exact theorem.

## Saved Jacobian evidence and fresh checker replay

The existing operation is `polynomial.map.jacobian`, server `0.14.0`,
protocol `2025-11-25`, transport `mcp-stdio`. The exact dedicated payload
and output remain read-only at:

* `families/042/first-pass/sewing-audit/jacobian-payload.json`
* `families/042/first-pass/sewing-audit/jacobian-output.json`

The payload is the polynomial map \((w,p,s)\mapsto(w+sp^2,p)\) over
\(\mathbb Q\). Its complete typed row-major derivative matrix is
\[
 \begin{pmatrix}1&2ps&p^2\\0&1&0\end{pmatrix}.
\]
Only the active \((w,p)\) submatrix has the symplectic determinant
interpretation. The parameter derivative is not a proof of arbitrary
passive holomorphic dependence.

The saved certificate records exit zero, no timeout, and null transport
and typed errors; the output contains all six typed entries, not
`UNKNOWN` or an incomplete result. The current replay checks the exact
payload binding, serialization invariants and all six derivatives
independently with SymPy. It does **not** re-observe the old server
execution or establish its historical runtime from a new invocation.
No conflicting input or relevant mathematical dependency change was
found, so the operator's reuse rule applies. No custom exact computation
or replacement operation was introduced.

The first actual replay with the required
`$WORKSPACE/argus-latest/.venv/bin/python` failed at line 9:
SymPy was absent from that environment. This was an environment failure,
not evidence against any mathematical claim. The installed live-update
environment was then probed and found to use the same Python 3.13.5,
with SymPy 1.14.0 and mpmath 1.3.0. Exposing those existing pure-Python
packages through `PYTHONPATH` let the **required interpreter** execute
the **unchanged old script**:

```bash
PYTHONDONTWRITEBYTECODE=1 \
PYTHONPATH=$WORKSPACE/argus-live-update/.venv/lib/python3.13/site-packages \
$WORKSPACE/argus-latest/.venv/bin/python \
families/042/first-pass/sewing-audit/verify.py --json
```

It exited zero in 0.262347 seconds with 146 checks and no stderr.
`checker-replay.json` preserves the actual command, environment,
dependencies, failed attempt, exact successful stdout and verification
limits. No packages were installed and no shared environment or old
input was modified.

The script's labels and literal-fragment tests do not establish full
statement fidelity or version identity. Its scalar checks do not prove
the analytic domain estimates. It never reads the analytic report.
The independent manifest comparison and prose assessments supply
different kinds of evidence; neither is a Lean/compiler certificate.

## What remains, and what does not follow

These two attacks have definite mathematical dispositions, not merely
missing runs. A genuinely different counterexample would have to meet
every exactness, degree, compatibility, uniform-bound and chart-domain
hypothesis and still violate the conclusion. Constructing or searching
for one is outside this review and has not been started.

Relative to the strongest prior result, this unit adds no new algebraic
theorem. It replays and scope-checks the existing evidence and records
why the attempted objections fail. The broader analytic theorem relies
on the full argument in the sewing unit, not the fact that these attacks
failed. Native independent review remains pending.
