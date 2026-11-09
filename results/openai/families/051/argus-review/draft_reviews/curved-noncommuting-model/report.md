# Curved noncommuting local diagnostic

**Engineer assessment: supported as an explicit local construction and
finite exact diagnostic.** It is neither a compact-target counterexample
nor a certificate of the general bridge.

## Claim, source, and certificate identity

This is the two-dimensional part of old `BH-ALGEBRA@1`, preserved
`9000051/research/boundary-hessian/bridge.md`, section 7, (29)--(31).
The source/checker dependency is the old **root** `verify.py`; its expected
output is the old **root** `exact_certificate.json`, not a missing file
under `research/boundary-hessian/`. Their identities are in the index.
The certificate's `curved_noncommuting_model` and relevant `jacobian`
fields concern this unit. Its other model belongs to the square-root unit.
The construction is Argus diagnostic work, not an alleged contradiction
in OpenAI's manuscript.

On \(U=\{|w_1|^2<3/2,\ |w_2|<1/8\}\), let
\[
 \phi=\tfrac34|w_1|^2+\tfrac1{16}|w_1|^4+|w_2|^2
       +\tfrac18(|w_1|^2-1)^2(w_2+\bar w_2),\qquad h=dd^c\phi.
\]
For \(f(z)=(z,0)\), \(B=I\), and \(u=|z|^2\),
\[
 N=\begin{pmatrix}(3+u)/4&z(u-1)/4\\
                   \bar z(u-1)/4&1\end{pmatrix},\qquad
 D(u)=\det N=(12+3u+2u^2-u^3)/16.
\]
The family is \(F(t,z)=(z(1+t_1),zt_2)\), for a sufficiently small
parameter ball so that its image stays in \(U\).
The asserted values are
\[
 P_{R_h}=\log(3/4),\quad A_{R_h}=-1/4,\quad
 \mathcal LA_h=9/4,\quad \mathcal LP_h=2.
\]
The Blaschke specialization from the extension unit has central
multiplier \(1/4\) and area trace \(17/4\).

## Decisive mathematics, including non-computational conditions

Metric positivity is a statement on the **whole chart**, not two sample
points. Put \(v=w_2+\bar w_2\). Differentiating the potential in the
manuscript's column-vector convention gives
\[
 h_{22}=1,\quad h_{11}=(3+u)/4+(2u-1)v/4,\quad
 |h_{12}|^2=u(u-1)^2/16 .
\]
On \(U\), \(|v|<1/4\), \(0\le u<3/2\), and \(|2u-1|\le2\),
so \(h_{11}\ge5/8\). The coarser bound \(|u-1|\le1\) gives
\(|h_{12}|^2\le3/32\), hence
\(\det h\ge5/8-3/32=17/32>0\). This supplies the full-domain
positivity argument not obtainable from a pair of finite matrix tests.
The metric is closed because it is \(dd^c\phi\).

The displayed \(N\) follows by restriction; on \(u=1\) it is \(I\).
At \(z=1/2\) its diagonal is \((13/16,1)\) with off-diagonal
\(-3/32\), whereas at \(z=i/2\) its upper off-diagonal is
\(-3i/32\). The (1,1) entry of their commutator is
\(-9i/512\ne0\). Thus genuine complex noncommutation is present, and
the diagnostic is not simultaneous scalar diagonalization in disguise.

Writing \(L(u)=\log D(u)\), the pulled-back Ricci density is
\(-[uL'(u)]'\). Since \(D(0)=3/4\), \(D(1)=1\), and
\(D'(1)=1/4\), direct radial integration gives
\(A_{R_h}=-1/4\) and \(P_{R_h}=\log(3/4)\).
Independently differentiating the displayed family and potential gives
the Hessian density \(7/4+u\). Its normalized area integral is
\(7/4+1/2=9/4\); its normalized logarithmic integral is
\(7/4+1/4=2\). These checks do not need the analytic bridge as a premise.
The degree-two multiplier values agree with the separate boundary-degree
argument; one instance cannot establish that argument for all products.

## Checker audit and reuse

The source audit identified `check_exponents`, `check_curved_model`,
`check_square_root_model`, and `check_jacobian` in old `verify.py`.
The default entry point uses exact SymPy arithmetic, raises on failed
checks, compares results with `exact_certificate.json`, and prints.
It anchors evidence paths to its own file. It does not overwrite the
certificate or old ledger. The optional `--emit-jacobian-payload PATH`
is a writing branch and was not used. No old checker was executed here.

The historical 85-check receipt and
`judgement-BH-ALGEBRA-460a36b262af` by
`reviewer:copilot-4ea18baac059` apply to these unchanged diagnostics.
`judgement-BH-ALGEBRA-7d02f6e912ad` is the Engineer opinion.
The certificate's `analytic_theorem_kernel_checked: false` is accurate;
its `independent_review_status: pending` is stale relative to that later
ledger opinion. The opinion does not acquire an analytic or global scope
because it is independent. The historical SymPy package version is not
established by these receipts; no new local SymPy run is represented.

The old opinion binds the `BH-ALGEBRA` statement hash and certificate
path, not certificate bytes. Neither root diagnostic file is listed in
the preserved snapshot manifest. Their current identities and the
matching explicit construction were checked separately; historical
artifact-byte identity is not claimed. This provenance limit does not
turn the diagnostic into an unresolved mathematical claim: the decisive
formulas and analytic side conditions are exhibited above.

The checker verifies algebraic identities, primitives, sample matrices,
and selected inequalities. It is not a universal proof of positivity,
Sobolev regularity, frame/family existence, or arbitrary-dimensional
flux. The full-chart bound above is an analytic reading of the draft,
not a claim that the checker establishes all of it.

## Jacobian: old limitations and one bounded current operation

All old Jacobian JSON files are supporting artifacts of this same model.
The successful old operation `matrix.determinant.compute`, server
`0.14.0`, protocol `2025-11-25`, evaluates the rational **4x4 realification**
at \(x=y=1/2\), obtaining \(12321/16384=D(1/2)^2\).
It does not produce a symbolic formula or certify positivity.
The old request `matrix.symbolic.determinant.compute` for the larger
polynomial realification was rejected before execution with
`matrix.budget_exceeded`, `INVALID_REQUEST`, stage
`operation_validation`, adapter exit 2. That rejection is not a
mathematical negative result.

For this host's required bounded adapter use, discovery selected the
symbolic determinant operation and its exact typed contract was inspected
before execution. The smaller matrix over \(\mathbb Q(z,w)\) is
\[
 \begin{pmatrix}(3+zw)/4&z(zw-1)/4\\w(zw-1)/4&1\end{pmatrix}.
\]
The exact payload, transcribed validation contract, complete raw typed
response, and actual status are respectively `jacobian-payload.json`,
`jacobian-contract.json`, `jacobian-result.json`, and
`jacobian-status.json` in this directory. The isolated Argus adapter used
`$WORKSPACE/argus-live-update/.venv/bin/python`, never imported
Jacobian into the Argus environment, and returned exit 0 without timeout
or structured error. Server `0.14.0`, protocol `2025-11-25`, operation
`matrix.symbolic.determinant.compute`, method `SYMPY_BAREISS`, returned
\[
        -(zw)^3/16+(zw)^2/8+3zw/16+3/4 .
\]
Only after that algebraic calculation is \(w=\bar z\) substituted to
recover \(D(u)\). The server accepts independent algebraic variables,
not conjugation or Sobolev objects. This one smaller symbolic request
supplies no stronger analytic theorem and does not erase the old rejected
request. No unchanged 85-check replay or replacement snapshot was made.

## Assessment boundary

All conditions of the claimed **local** model have been accounted for.
The target chart \(U\) is not compact or Brody hyperbolic. Thus it is not
an admissible counterexample to canonical ampleness, nor a positive
verification of a compact target's global geometry. The retired
finite-tests-only route remains mathematically invalid. No Lean or
novelty certificate is supplied. Current family acceptance remains for
the native independent Reviewer.
