# Overarching affine-surface claim and dependency composition

**Engineer assessment: the stated affine existence conclusion is supported
by the reviewed prose dependency chain, conditional on its explicitly
recorded external propositions. It is not currently accepted by the native
independent Reviewer.** There is no new counterexample construction,
kernel proof or novelty claim in this review.

## Exact theorem and version

The asserted theorem is
\[
\exists A,\mathfrak m:\quad
A\text{ is a finitely generated normal integral }\mathbb C\text{-algebra},
\quad\dim A=2,\quad
\mathfrak m\in\operatorname{MaxSpec}A,\quad
\operatorname{Der}_{\mathbb C}(A)\simeq A^2,\quad
A_{\mathfrak m}\text{ is not regular}.
\]
Freeness is on the **whole selected affine surface**, not only its smooth
locus, a completed stalk, an analytic puncture or a generic point.
The construction also retains a smooth complement of the marked point.

Attribution: **OpenAI**, *A singular normal affine surface with free
tangent sheaf*, **September 23, 2026**, `build/01-introduction.tex`,
`thm:main`, and the final main-theorem proof in
`build/06-algebraization.tex`. Original files are under the read-only root
`families/048/first-pass/openai_manuscript/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`.
The reference manifest names revision
`4eaee87548250b2682affda7d05d947c05554bae`. All eight supplied TeX identities
match it. All 14 family-048 core artifacts match the preserved November 6
snapshot; the other 97 manifest inputs are present and size-matched, not
silently called snapshot-authenticated.

The four Argus reports are attributed by the old ledger to
`engineer:gpt-6-astra`. This review assesses those existing arguments,
their strengthenings and their source applications. It does not attribute
the existence theorem to the current Engineer.

## Interface-by-interface composition

The detailed argument assessments are in the linked unit reports.
This section checks the **matching hypotheses**, not merely the existence
of a checker or an approved label.

| Interface | Required output and actual use | Assessment |
|---|---|---|
| [Curve/trace](../curve-trace/report.md) to [jets](../coupled-jets/report.md) | One smooth connected complex curve of genus 21, \(\deg L=10\), the specified \(L^4=K_C\), six simple common zeros, spanning derivative rows, required section counts and all-order evaluation surjectivity; **one global** \(P\), all six determinant normalizations and total \(-90\). | Exact hypotheses match. Separate locally chosen rows or scalar residue sums alone would not suffice; the curve proof supplies the global object. |
| Jets to [analytic realization](../analytic-realization/report.md) | The universal finite theorem at \(N=7\) supplies actual finite overlap-flow germs fixing the conormal, logarithmic coefficients through degree eight, hence sections of \(IF/I^9F\), and \(A\wedge B=t^2(1+O(t))\) everywhere on \(C\). | Correct index and ideal powers; the formal all-order strengthening is unnecessary here. No convergence of the infinite construction is inserted. |
| Realization to full analytic tangent module | A separated smooth neighborhood is contracted properly; uniform \(I^a\subseteq J\subseteq I\), pro-zero maps and corrected formal functions give actual lifting. The ordinary wedge has order five with unit coefficient. Fields descend, and the depth-two finite-colength argument saturates the **entire** analytic derivation module. | A frame of a submodule or of the puncture alone would be insufficient; the saturation proof is present. Adjunction \(K_Y.C=50\) contradicts effectiveness if the contracted point were smooth. |
| Analytic germ to [affine algebraization](../affine-algebraization/report.md) | The input is an isolated normal analytic germ of dimension two with the full analytic tangent module free of rank two. The finite conormal-dual Jacobian cokernel has finite length. | All hypotheses of the general algebraization implication match; genus/discrepancy are not needed for this interface. The standard local analytic zero-set input is recorded explicitly rather than hidden in coherence. |
| [Determinacy](../fixed-relation-determinacy/report.md) to exact approximation | The **original** \(D\) generates all syzygies; Artin supplies exact \(gB=0\) in the henselization, sufficiently high equation precision and one fixed relation precision. | Full approximating syzygies are not required. The equations-only perturbation fails the exact zero-product hypothesis and does not refute this route. |
| Completed stalk to one affine neighborhood | Finite algebraic versus continuous Jacobian kernels are compared before faithful-flat descent. A single principal neighborhood carries the whole chosen tangent basis, is normal integral of dimension two, retains the nonregular closed localization and has smooth complement. | This is the missing logical content of a bare claim that the completion algebraizes; the detailed argument checks all these properties simultaneously. |

Composition proves the stated existence implication once those prose results
and external propositions are granted. There is no circular use of
`M_main` to obtain its own analytic input or algebraization lemma. The two
subsidiary corollaries depend **on** this result and provide no support
in the reverse direction.

The invariant unit separately checks a genuine meromorphic dual volume,
discrepancy \(-5\), and \(33\leq p_g\leq39\). These establish the
advertised numerical scope, not an exact genus. In particular
\(p_g=39-\operatorname{rank}\delta_2-\operatorname{rank}\delta_3-
\operatorname{rank}\delta_4\); the ranks are not evaluated. Their absence
is a concrete limitation of a stronger exact-genus claim, not a missing
hypothesis in the main existence implication.

## Historical records and exact disposition

| Record | Current assessment |
|---|---|
| `M_main` v1 | Supported as the composed prose existence theorem under the listed external propositions. Its old empty external-assumption field does not mean the dependency chain is assumption-free. The old graph kept this node open. |
| `C9000048` v1 | **Excluded as a mathematical theorem, fully mapped as historical context.** It is the former instruction to audit/refute or verify identities in family 048. It is not an independent quantified assertion and does not override the present old-draft review objective. |
| `R_M_main` | Correct AND of the analytic counterexample and algebraization propositions. Source and field/category fidelity are checked above. |
| `R_048_coupled_verification` | A historical route from the former audit objective to conditional jets, not a decomposition proving `M_main`. Its bounded success cannot be substituted for the affine theorem. |
| `J_significance` (graph only) | Historical campaign-level novelty/significance obligation, still open and not assessed as true. It is not the exploratory review-completion criterion. |

Three historical native receipts accept respectively the bounded jet,
joint-input and analytic results:
`bf979be90014/round-0001.json`, `70d65f383197/round-0001.json`, and
`8ba02f2780af/round-0001.json`, under
`$WORKSPACE/.argus-campaign-9000048/projects/46e84e6fea35/handoffs/`.
They were read in the corresponding assessments. Their pending submission
summaries coexist with `review.status=done` because the summary is the
earlier Engineer submission. Component graph nodes remain open despite
accepted endpoints. Neither discrepancy is a mathematical disproof or
automatic independent closure of all dependencies.

**There is no applicable native determinacy/algebraization or full-family
acceptance receipt.** Nominal reviewer labels in the old ledger reference
the same algebraization report; they do not supply the missing native
receipt. The analytic receipt explicitly leaves algebraization,
originality and campaign significance open. `AG_independent_review` and
`M_main` remain historically open. Current reports are Engineer
assessments awaiting the Host-invoked independent Reviewer, not a way to
rewrite that history.

## External assumptions, evidence and known limitations

The active ledger records the actual Serre, Cartan, Grauert and correction,
normal-depth, dualizing, Artin--Rees, approximation, completion,
excellence, henselization, etale and finite-type propositions used by the
component proofs. Their exact hypotheses and available primary passages
are enumerated in each unit's `verdict.json` and report. Hironaka/Artin
prior art establishes that the equation-and-relation method is known;
it is not a replacement for checking tangent descent or a novelty claim.
The broad Bertini/splitting and unavailable Demailly citation routes
were replaced by explicit special arguments, not assumed silently.

The historical Bergner--Graf excerpt in
`OLD/research/literature/reviewer_lipman_zariski_baseline.txt`
states the restricted \(p_g-g-b\leq2\) positive criterion. The proposed
germ lies outside it since \(g=21,b=0,p_g\geq33\). A restricted
positive criterion neither proves the general conjecture nor refutes
this example merely by its existence. This review does not certify
all the contextual claims in the manuscript introduction, undertake an
exhaustive novelty search, or assert that all later literature was read.

All four old checkers are exact Python/SymPy support, not kernel proofs.
Unchanged, historically reviewed curve/jet/analytic computations were
reused. The absence of an applicable native algebraization receipt
justified one fresh **finite-support** replay: 107 assertions and 13
universal inequality certificates passed, all 18 mutations were rejected,
and the separate invalid-certificate CLI exited 1. That checks the
preserved finite assertions, not general analytic or algebraization
theorems. Its real interpreter and SymPy version are recorded unit-locally.
One current typed Jacobian determinant confirms the ordinary-wedge
factor \(t^3(A_1B_2-A_2B_1)\), hence the order-five convention given the
jet determinant; its full payload/output/status are in the realization
unit. Neither calculation produces the asserted affine \(A\) explicitly.

No Lean source, compiler run, statement-fidelity certificate or kernel
closure is present in the assigned evidence. No such result is claimed.
The proof remains prose relying on explicit external theorems.

## Conclusion

No additional concrete gap was found at the hypothesis interfaces of the
existing affine proof chain. This is a justified **Engineer assessment**,
not the delivery of a new Lipman--Zariski counterexample or a publishable
novelty verdict. The strongest historically accepted result is the analytic
germ; the strongest downstream existing draft is the algebraization
implication and its main-theorem application. This review's improvement
is complete, scope-qualified adjudication of that stronger draft and its
dependencies, not a new mathematical theorem.

Native independent review of the nine-unit coverage and substance is the
remaining acceptance authority. Structural campaign-check limitations are
reported in `research/OLD_ROUND_REVIEW.md`; no absent, unowned graph is
fabricated to manufacture a passing gate.
