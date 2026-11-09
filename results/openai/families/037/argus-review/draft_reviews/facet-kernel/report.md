# Finite-facet kernel: exact statement and archived formal evidence

**Engineer disposition: supported for the conditional integer-algebra theorem.**
The archived compiler result does not prove global lifting, the existence of
facets, canonical interiority, cone rigidity, or either volume-gap theorem.
This assessment is not native independent Reviewer acceptance. No novelty is
claimed.

## Source, versions, and attribution

Here `old/` means the read-only workspace
`campaigns/9000037/`.
The source is `old/research/adjoint_jet_lifting/Main.lean`, interpreted by the
adjacent `statement_fidelity.md` and the finite-facet discussion in
`report.md:514-551`. The old ledger attributes this work to
`engineer:adjoint-jet`. It is an elementary algebraic sublemma extracted from
the geometric argument, not a formalization of that argument.

Both `C_AJL_FACET_KERNEL@1` and `@2` have the exact natural statement:

> For finitely many integral additive support forms of value one at c, strict
> shifted lifting and containment imply equality with the closed lattice
> halfspaces and exact translation of their strict lattice halfspaces.

Version 1 has no formal statement. Version 2 adds exactly the 1,508-byte Lean
source; the mathematical assertion does not become stronger. Its content hash
is `7cdedc0713c9f33176a8688c4da60422128fab1883aea45d3aa816b37469fedb`.
The mechanical certificate is bound to this version, not retroactively to a
proof of the surrounding manuscript. The earlier version's hash is
`17bd8d5fb86def1d1208db95ed81108e863b585453aa1f7ef6e24a0df4278597`.

## Exact quantified statement and decisive proof

Let `A` be any additive commutative group, `I` a finite index type,
`forms : I -> A ->+ Z`, `c : A`, and `Gamma : A -> Prop` any predicate.
No topology, real vector space, degree coordinate, additive closure of Gamma,
finite generation, or prior saturation of Gamma is an input.

Define `Closed(q)` by `forms_i(q)>=0` for every `i` and `Strict(q)` by
`forms_i(q)>0` for every `i`. The hypotheses of
`AdjointJetLifting.exact_saturation` are exactly:

1. `forms_i(c)=1` for every `i`.
2. `Gamma(q)` implies `Closed(q)` for every `q`.
3. `Strict(q+c)` implies `Gamma(q)` for every `q`.

Its conclusion is, for every `q`,

```
Gamma(q) <=> Closed(q),
Strict(q) <=> exists g, Gamma(g) and q=c+g.
```

For closed `q`, additivity and height one give
`forms_i(q+c)=forms_i(q)+1>=1`; shifted lifting gives Gamma. The reverse
implication is containment. For strict `q`, each integral value is at least
one, so `forms_i(q-c)>=0`. The first equivalence gives `Gamma(q-c)`, and
`q=c+(q-c)`. Conversely `q=c+g` with Gamma gives every value at least one.
These are precisely the `simp`, `omega`, and `abel` steps in the source.
In particular this is an exact integer subtraction argument, not real
rounding or an asymptotic approximation.

`AdjointJetLifting.height_one_surjective` separately states that an additive
integer-valued form with `form(c)=1` is surjective: any integer `z` is the
image of the group element `z` times `c`. This is primitivity on the
application lattice, not a proof that a cone has an integral support.

The compiler warning that `[Fintype I]` is unused in `exact_saturation` is
mathematically accurate: the argument also works for an arbitrary indexed
family. The encoded statement nevertheless includes the finite-type input.
An empty family causes no contradiction: shifted lifting then forces
Gamma to be all of A, exactly as the conclusion states.

## Statement fidelity and the geometric interface

The saved fidelity document correctly names both declarations, their objects,
quantifiers, three hypotheses, conclusions, and the role of integrality and
subtraction. Reading source and document separately found no mistranslation.
The compiler itself does not verify this interpretation.

For the geometric application one must separately provide:

* `A` is the full congruence lattice in original section degrees, not a
  substituted integer lattice after degree rescaling.
* The full-dimensional cone is cut out by the supplied nonzero facet forms,
  so all strict inequalities really describe ordinary interior.
* The forms are integral and have value one at the canonical vector.
* Actual section initials are contained in the closed halfspaces, and exact
  global shifted lifting holds for every lattice point.

The lattice-strip unit proves the facet existence/height conclusion from
its own hypotheses. The adjoint-lifting unit assesses the last global
implication. Neither input can be recovered from this Lean theorem.
In particular the theorem assumes, rather than produces, finite facets and
height one. All algebraic hypotheses in this unit are explicit; no external
geometric theorem is imported as an axiom of the Lean statement.

## Receipt consistency, reuse, and actual toolchain

The archived certificate is
`old/research/adjoint_jet_lifting/certificates/C_AJL_FACET_KERNEL-1ade0225935d5908.json`.
Its embedded source and fidelity text match the current old files byte for
byte. Their SHA-256 values match both the receipt and the existing snapshot
manifest:

```
Main.lean:
69a2b845e8195bdc40feae8bd53f0eade466aa589a22d1b166d1c4fc64394be7
statement_fidelity.md:
0828813289361b98348fe6201ea8580c3ccd7c439b95ed7fcaff57ddd520b5e5
```

The certificate's `lean_check` equals the adjacent `lean_check.json`.
Its subject hash equals version 2's ledger hash, and version 2's formal
statement equals the source. All nine receipt/source consistency tests
passed. The archived compiler and axiom-audit exits are both zero, the
receipt reports no proof holes or environment failure, and the source has
no `sorry` or `admit`. The only compiler diagnostic is the unused-section-
variable warning above. The reported 14,716 ms is the **archived** duration,
not a newly measured compilation.

The archived toolchain is Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake
`5.0.0-src+68218e8`, elan 4.2.3, using the existing
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0` workspace.
A fresh read-only probe of that workspace returned the same Lean commit and
Lake version; `lean-toolchain` is `leanprover/lean4:v4.31.0`.
The dependency lock has version 1.2.0 and includes Mathlib.

The receipt does not hash every imported compiled dependency. Version
agreement is not represented as a dependency-by-dependency freshness proof.
There is no observed source, fidelity, or toolchain conflict requiring a new
compile. In accordance with the task's unchanged-receipt reuse rule, the
historical compilation is reused, not repeated or relabelled as a fresh run.
No Lean source was created or edited in this project, no archived submission
handle was reclaimed, and no new kernel status was written into the active
ledger. `compile.log` and `lean_submission.json` are supporting transcript
and submission metadata for this same run, not extra proofs.

The old ledger also contains supporting Engineer and historical Reviewer
opinions about this certificate. They are historical judgements with the same
scope, not native acceptance of the present coverage review.

### Active review-ledger archival binding

The active ledger's existing
`judgement-C_AJL_FACET_KERNEL-6c9c9ea978df` remains a `judgement` with verdict
`supports`, attributed to `reviewer:e02db4aca413`. Its original artifact was
`families/037/first-pass/adjoint_jet_lifting/certificates/C_AJL_FACET_KERNEL-1ade0225935d5908.json`.
That unchanged receipt records mechanical evidence
`lean-C_AJL_FACET_KERNEL-5b4cd16907bc`, produced by
`lean_evidence/lean 4.31.0`, for the **old version-2 formal claim**.
The native historical review receipt is
`$WORKSPACE/.argus-campaign-9200037/projects/6b8f4b2d7ab2/handoffs/e02db4aca413/round-0001.json`;
it accepts the scoped assessments, expressly distinguishing conditional facet
algebra from geometry.

The current Engineer corrected only the imported judgement's active artifact
pointer to this report, which contains the reviewed argument and archival
receipt assessment. The current version-1 claim has no formal statement or
mechanical evidence. Its original judgement id, subject, tier, verdict and
Reviewer attribution are unchanged; the original artifact is preserved above.
Neither the old certificate nor either historical ledger was changed. This is
an administrative provenance correction, not a new verdict by that Reviewer,
a fresh compilation, or an approval of this correction. Native independent
review of the correction remains required.

## Remaining obligations

No internal algebraic or statement-fidelity gap was identified. Independent
review must assess the interpretation and the legitimate use of the archived
receipt. The geometric interface obligations belong to the separately
assessed units; unreviewed cone, degeneration, and volume-gap propositions
remain outside this certificate.
