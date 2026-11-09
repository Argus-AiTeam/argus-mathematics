# Root kernel and the failed diagonal shortcut

**Assessment:** the universal-commutator statement has a sound classical
argument under the stated representation-theoretic hypotheses. The explicit
diagonal obstruction is exactly reproducible, but refutes only a weakened
audit test. Neither is a refutation of the manuscript.

## Statement, version, and attribution

This unit covers `C_ROOT_KERNEL` versions 1-4 and
`C_DIAGONAL_OBSTRUCTION` version 1. The root statement does not change between
versions; versions 2, 3, and 4 add, respectively, Borel fixed point,
highest-weight theory, and root/sl2 dependencies. They are not four results.

For an integrally graded complex semisimple Lie algebra
\(\mathfrak g\), a compact-form adjoint reversing the grading, a graded
adjoint-stable ideal \(\mathfrak h\), and an irreducible finite-dimensional
compatibly graded representation \(V\), let \(E\) be the **whole** highest
graded piece. Require a positive metric for which representation adjoints
are the actions of Lie adjoints. For every \(0\ne s\in E\), the assertion is
\[
 \{x\in\mathfrak h_1:[x,y]s=0\text{ for every }y\in\mathfrak h_{-1}\}
       =\{x\in\mathfrak h_1:x^*E=0\}.
\]
The left kernel is independent of \(s\). With nonnegative simple-root
degrees, its root-block description is the sum of those degree-one blocks
\(B_\alpha^+\subset\mathfrak h_1\) whose component
\(C_\alpha\) in \(\Delta_0\cup\{\alpha\}\) pairs trivially with the highest
weight on every simple coroot.

The proof is Section 1 of the old Argus `research/higgs-tail-audit/report.md`,
authored in the ledger by `engineer:copilot`. It reconstructs and sharpens
`lem:degree-one-root` in OpenAI's *The reverse logarithmic Kodaira inequality
and additivity*, September 26, 2026, `build/sections/boundary-rank.tex`,
lines 723-740. The reference manifest reports revision
`4eaee87548250b2682affda7d05d947c05554bae`; all 10 TeX files of that package
match its manifest. This is not a verified originality claim.

## Decisive argument

The top module is \(E=U(\mathfrak g_0^-)v_\lambda\). A degree-one positive
root contains exactly one degree-one simple root, with coefficient one;
the other nodes have degree zero. Different such blocks have zero cross
bracket: a difference of their roots has both positive and negative simple
coefficients. An ideal is a sum of simple factors, so the same decomposition
applies inside \(\mathfrak h\).

For a nonzero component of \(x\), universal vanishing produces a nonempty
closed incidence in \(\mathbb P(B_\alpha^+)\times\mathbb P(E)\).
A degree-zero Borel has a fixed point there. The second coordinate is the
highest line; the first is a root line \(e_\rho\). This uses irreducibility
of \(E\), not an unjustified assertion that the root block is irreducible.
If the support of \(\rho\) missed an adjacent zero-degree node in
\(C_\alpha\), the negative root-coroot pairing and root string would give
a raising operator moving that line. Hence its support is all of
\(C_\alpha\). The equation
\([e_\rho,e_{-\rho}]v_\lambda=0\) then forces \(\lambda\) to vanish on
every simple coroot in that component: the coroot coefficients have the
same positive support as the root. Root-sl2 theory and commutation past
degree-zero lowerings give \(B_\alpha^-E=0\).

Conversely, if \(x^*E=0\), highest degree gives \(xE=0\).
For \(y\in\mathfrak h_{-1}\) and \(e,f\in E\),
\(\langle xye,f\rangle=\langle ye,x^*f\rangle=0\); since \(xye\in E\),
this proves \([x,y]E=0\). No single-vector-to-whole-space inference was
assumed in either direction.

## Exact obstruction and replay

In the adjoint representation of block-graded \(\mathfrak{sl}_4\), take
\[
 E=\langle e_{13},e_{14},e_{23},e_{24}\rangle,\quad x=e_{13},\quad s=e_{24}.
\]
Then \(x^*s=0\) and \([[x,x^*],s]=0\), whereas
\([[x,e_{32}],s]=e_{14}\ne0\).
In codomain basis \((e_{11}-e_{33},e_{34},e_{21})\),
\[
 \operatorname{ad}(x^*)|_E=
 \begin{pmatrix}-1&0&0&0\\0&1&0&0\\0&0&-1&0\end{pmatrix},
\]
of rank 3. Thus this example **fails the actual universal hypothesis**.
The historical `R_HIGGS_DIAGONAL_ONLY` was rightly retired for precisely
that reason, not because the original lemma was false.

The unchanged old `verify.py` was safely replayed with Python 3.13.5;
`../local-tail-kernel/replay.json` records its actual interpreter, command,
exit 0, and reconstructed matrix-unit calculation. A separate bounded
Argus-sidecar replay used `matrix.symbolic.rank.compute`, inspected first,
with a JSON payload equal to the old request. `jacobian-output.json` records
Jacobian 0.14.0, protocol `2025-11-25`, exact row reduction, rank 3 and pivots
`[0,1,2]`. `jacobian-status.json` records exit 0, no timeout and no structured
error. This checks an explicit linear map, not the general Lie theorem.

## Sources, receipt scope, and remaining limits

Borel's 1955 expose, archive 1956, Lemma 4.3 p. 233
(`url:https://www.numdam.org/item/SB_1954-1956__3__229_0/`) has exactly the
connected-solvable/nonempty-complete hypotheses used above. Milne,
*Algebraic Groups* (2017), `isbn:9781107167483`, Theorems 22.2 and 22.18,
supplies the irreducible highest-line statement. The retained independent
`literature/reviewer-source-excerpts.md` checks these hypotheses and also
derives the elementary root/coroot and zero-weight sl2 steps. The original
Humphreys sections 9-10 and 20-21 were not obtained; that source remains
explicitly uncited, not falsely reported as read. These standard steps
can be assessed directly from the displayed reasoning.

Historical receipts `judgement-C_ROOT_KERNEL-12192c21e294` and
`judgement-C_DIAGONAL_OBSTRUCTION-5489b6c35cd1` support the exact statement
hashes. The matching assumption receipts are catalogued in the index.
The receipts bind subject hashes and artifact paths, not artifact digests.
The report, certificate and checker match the preserved snapshot; the
later source-excerpt packet is not among its five Family-033 entries.
Positive receipts do not turn the old open proof graph into an acceptance.

No internal mathematical gap was identified in this bounded argument.
External standard theory is not checked by the Python certificate, no Lean
theorem is supplied, novelty is unverified, and current independent
acceptance remains the native Reviewer's decision.
