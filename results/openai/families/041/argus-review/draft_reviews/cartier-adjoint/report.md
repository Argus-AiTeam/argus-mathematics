# Cartier-adjoint clearing: exact conditional theorem

**Engineer assessment: supported at the stated conditional algebraic scope.**
This is a reproduction and scope review of `C_ADJOINT@1-4`, not a new
counterexample or an originality claim. Native independent review is pending.

## Statement, provenance, and hypotheses

The old `proof.md:16-97`, final `Main.lean`, and
`statement_fidelity.md` describe the same implication. They are among the
eleven Family 041 members verified against the read-only snapshot of
2026-11-06T10:20Z. Their current old-workspace bytes match that snapshot.
The three compiler certificates are versions of this one argument.

Let \(K\) have characteristic \(p>0\), finite p-basis \(u\), coordinate
derivations \(d_i\), and additive top-coefficient Cartier map \(C\).
Let \(A\subset R\subset K\) be subrings, with only **A** assumed stable
under every \(d_i\). For a finite family of words \(w_j\), take
\(c_j\in A\), \(g,t_j\in R\), \(s\in K\), and an additive
\(\psi:R\to R\) satisfying \(\psi(r)=C(sr)\) after inclusion in \(K\).
Assume the exact identity
\[
 s=\sum_j c_j d_{w_j}(g t_j s).
\]
Then, writing \(a_j=d_{w_j}^{*}(c_j)\) for reversed derivative order
with a minus sign at each transfer,
\[
 T=\sum_j t_j a_j\in R,\qquad \psi(gT)=\psi(1).
\]
For an ideal \(I\) with \(\psi(1)\notin I\), this supplies an element
of \(\psi(gR)\) outside \(I\). Without this additional ideal hypothesis,
the equality alone does not assert nonvanishing.

Neither regularity of \(s\), derivative-stability of \(R\), normality,
completion, nor an extension-degree bound occurs in this implication.
The regular output map \(\psi:R\to R\), its field formula, and the scalar
identity are substantial hypotheses, not conclusions of the theorem.

## Decisive argument and statement fidelity

Expand every \(x\in K\) as
\(\sum_{\alpha<p} a_\alpha^p u^\alpha\). Derivations kill the
p-th powers. A nonzero differentiated monomial has its differentiated
coordinate exponent at most \(p-2\), so top-coefficient extraction kills it.
Thus \(C(d_i x)=0\), including for rational \(x\).
Applying this to \(d_i(cx)\) gives
\[
 C(c\,d_i x)=C((-d_i c)x).
\]
Induction transfers an arbitrary finite derivative word to its coefficient
in reversed order. Applying \(C\) to the scalar identity yields
\[
 C(s)=C\left(sg\sum_j t_j a_j\right).
\]
Stability of \(A\), not stability of the possibly singular ring \(R\),
puts every \(a_j\) in \(A\) and hence \(T\) in \(R\).
No commutation of derivatives is needed for the word argument.

The actual Lean statement quantifies over `[Field K]`, `[CharP K p]`,
natural `p,n`, finite `J`, and a supplied `PBasisCartier K p n`.
That structure carries coordinates, integer-linear derivations with their
coordinate values, spanning p-monomial expansions, and an additive Cartier
map with its extraction rule for every coefficient p-th power.
It does **not** assume derivative annihilation or the clearing conclusion.
Spanning is enough; uniqueness is unused. It also does not construct this
bundle from Mathlib's notion of a p-basis, or prove that a geometric chart
has such data. The intended prime-characteristic interpretation is faithful
as a **conditional data theorem**, not a formal existence theorem for all
geometric inputs.

`integration_by_parts`, `word_adjoint`, `adjoint_mem`,
`cartier_partial_zero`, `cartier_clearing`, and
`cartier_clearing_noncontainment` match the argument. `hpsi` and
`hidentity` remain explicit assumptions. The old fidelity document's
`C_ADJOINT` label is retained verbatim; `RV_ADJOINT` is the current ledger
alias of that same statement, not a relabelled theorem.

## Compiler history and fresh replay

`C_ADJOINT@1` had no formal statement. The certificate
`C_ADJOINT-557d2cc04626a0fd.json` binds version 2 and reports exit 1,
`syntax_error`, and an inconclusive verdict; its diagnostics include a
rewriting-created goal and the old `partial` field syntax.
`C_ADJOINT-b8972c806a5e9469.json` binds version 3 and reports exit 1,
`type_error`, with unresolved monomial-derivative goals. Neither is evidence
against the mathematical theorem, nor a successful proof.
The final version-4 certificate
`C_ADJOINT-f51e1ae321822ae4.json` succeeds. The old `compile.log` and
`lean_check.json` summarize that success; the submission JSON is only a
receipt, not an additional proof.

The inspected old executable was copied into `replay/`, along with its
required inputs. Its `main()` and `replay_lean()` were **not** called:
finite diagnostics were called separately, and the unchanged source was
compiled once through the official Argus `lean_evidence verify --claim`
path. This avoids repeating the same compiler check. All potentially
written Lean artifacts and the isolated runtime ledger are under this unit.
The isolated ledger began with the exact current context and `RV_ADJOINT`
reference; its actual compiler-produced record is reused in the active
ledger without inventing a mechanical verdict.

Fresh certificate:
`replay/fresh/certificates/RV_ADJOINT-5c13ad9f38695718.json`.
The source and fidelity hashes are respectively
`114d168e06f29b72aa2472ef1303deebcfa3bb75c5145c17c5997b8157cce36e`
and `b8d511e2daa453ff6140f83c0756174156653aa1b930cdb72e769880ebb09056`,
exactly the old final certificate's values. Nothing was edited during the
run or afterwards.

The real toolchain is Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake
`5.0.0-src+68218e8`, and elan 4.2.3. The prebuilt workspace was
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`;
no Lake project was initialized and no old workspace was rebuilt.
Compilation and axiom audit both exited 0 in a recorded 16,695 ms,
with `proof_holes=[]`. Both concluding declarations report only
`propext`, `Classical.choice`, and `Quot.sound`. These foundational axioms
are distinct from the explicit mathematical hypotheses carried by
`PBasisCartier`, `hpsi`, and `hidentity`. One existing unnecessary-sequence
linter warning does not represent a proof hole.

The durable submission receipt was `state=submitted`,
`task_id=review-041-cartier-compiler`,
`run_id=review-041-cartier-compiler-1794075586005019356`.
Its prescribed reclaim command was
`$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.tools.subagent status --task-id review-041-cartier-compiler`;
the retrieved outcome was `state=done`, exit 0, elapsed 16.9 seconds,
`live=false`. The direct runner used no LLM supervision.

## Scope and comparison with the strongest prior result

The fresh result reproduces the strongest supplied result, the final
version-4 conditional theorem. It does not improve its mathematical bound
or certify new geometry. The meaningful improvement here is evidential:
all failed and successful versions are reconciled, statement reading and
axioms are distinguished, and a fresh official run confirms the unchanged
source rather than inheriting an old success label.

The degree-free, pole-tolerant implication is stronger than the old
completed-trace *argument's* requirements. It is not a proof that degree
bounds can be removed from constructing the retained reductions, nor that
the entire manuscript can be generalized. Formal adjunction and Cartier
extraction are standard ingredients; no novelty search establishing an
original theorem was performed or is claimed.

Geometric p-basis construction, Hodge-module generation, simultaneous
arithmetic retention, horizontal duality, the Cartier normalization, ordinary
coefficient base change, and both manuscript theorems remain separate
assessments. The finite diagnostics and one rational-polynomial Jacobian
derivative are supplementary experiments, not this proof.
