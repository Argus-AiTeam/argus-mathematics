# Identification, anabelian inputs and the main theorem

**Assessment: not certified by the old bridge.** This reconciles `C_ANABELIAN_INPUTS@v1`, `C_IDENTIFICATION@v1`, and `C_MAIN@v1`. It also accounts for the excluded historical audit objective `C9000031@v1` without adopting it as the present task.

## Exact manuscript and attribution

The reference is OpenAI, *Open Homomorphisms of Global Solvably Closed Galois Groups*, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`. Its files are available and version-matched, not reconstructed from a citation summary.

In `identification.tex`, `prop:identify-normalized` asserts an \(a\in P\) with
\(\beta=\operatorname{Ad}(a)\circ\sigma\) on \(T\), where \(\sigma\) is ordinary restriction. `thm:prosolvable-rigidity` then asserts that **every** continuous open \(G_F\to P\), for a number field \(F\subset\overline{\mathbb Q}\), is conjugate in \(P\) to ordinary restriction.

In `introduction.tex`, `thm:main` states: for number fields \(F_1,F_2\) and possibly infinite solvably closed Galois extensions \(E_i/F_i\), **every continuous open**
\[
 \alpha:\operatorname{Gal}(E_1/F_1)\to\operatorname{Gal}(E_2/F_2)
\]
is induced by a unique field embedding \(j:E_2\hookrightarrow E_1\) (in the equivariant sense used in the paper). The theorem and abstract impose no extra kernel or cyclotomic-compatibility hypothesis.

These are substantially stronger than a missed-prime estimate for a map already assumed logarithmically compatible.

## External propositions: distinct, not interchangeable

The manuscript's `preliminaries.tex` and bibliography identify the following separate inputs:

| Manuscript use | Cited identity and locator | Status in this review |
|---|---|---|
| Isomorphism rigidity and uniqueness, then the centralizer consequence | Uchida 1979, DOI `10.2748/tmj/1178229803`, the theorem; `thm:uchida-isomorphism` and `lem:centralizer` | Not verified by the supplied bridge evidence; needed for the normalizer/rigidity chain. |
| Odd-prime local decomposition/inertia correspondence | Uchida 1981, DOI `10.2969/jmsj/03340595`, Section 1, pp. 595-596 | Exact local proposition inspected and reused for the bridge only. |
| Global cofinite target coverage at a fixed auxiliary prime | Uchida 1981, Proposition 1 | Not an input to the reviewed uniform-bound proof; do not smuggle it into that proof. |
| Uniqueness of a resulting embedding | Uchida 1981, Proposition 2 | Separate applicability obligation, not established by the local case. |
| Existence criterion for a field embedding under full cyclotomic compatibility | Hoshi 2025, DOI `10.2748/tmj.20230414`, Theorem 3.4; `thm:hoshi` | The manuscript states an iff criterion for the indicated open maps between solvably closed Galois groups. Its application has not been certified by this review. |

The 1979 and Hoshi entries above identify **what the manuscript cites**, not source attributions filed as verified theorems here. They are not adopted as trusted assumptions of the conditional Kummer proof. The actual bridge inputs, whose archived primary passages and old reviewer attributions were read, are recorded separately in the current ledger.

## Concrete outstanding obligations

For `C_ANABELIAN_INPUTS`, verify the exact hypotheses and directions of the isomorphism and embedding theorems, the centralizer uniqueness consequence, and the solvable-closure reductions for the original \(E_i/F_i\). Checking the local 1981 trichotomy is not checking this list.

For `C_IDENTIFICATION`, prove equality up to one conjugation with ordinary restriction, using the actual character-detection, signed-representation and same-characteristic arguments. The old graph explicitly lists these and normalization as dependencies. The saved certificate contains no field embeddings, no conjugating element and no equality of maps on \(T\).

For `C_MAIN`, connect that rigidity argument to the original solvably closed extensions, establish the required **full adelic cyclotomic equality**, and justify existence, equivariance and uniqueness. Hoshi's stated criterion asks for equality in \(\widehat{\mathbb Z}^{\times}\), not equality of selected odd-prime logarithms. Indeed the reviewed bridge permits \(\epsilon\ne1\), so logarithmic equality alone cannot supply that stronger input. This is a concrete boundary of the old evidence, not an assertion that the manuscript's separate identification argument fails.

## Ledger and completion boundary

All three old claim versions remain without supports judgements or mechanical evidence. The graph's open labels are consistent for these claims. The old active main-construction and main-verification routes remain unfinished; the supports judgements for the bridge do not close them.

`C9000031@v1` is an old adversarial-audit mission, not a theorem. Its demanded new error search or full machine-checkable main-theorem certificate is excluded from the current objective and cannot silently govern acceptance of this review. It is nevertheless explicitly mapped in the coverage index, along with its dependency on `C_MAIN`.

No Lean source or certificate for these claims was supplied. The algebraic verifier and the fresh Jacobian product do not compile or formalize their statements, so they provide neither compilation evidence nor statement-fidelity evidence for the main theorem. This review reaches no blanket verdict that the manuscript is correct, false, novel or publishable. The native independent Reviewer must decide whether the complete, scope-qualified old-draft review meets the present objective.
