# Logarithmic Kodaira-dimension corollary

**Engineer assessment: supported as a conditional consequence of the affine
endpoint. Native independent review is pending.** The source application
matches; this is not an independent construction of the asserted surface.

## Statement, hypotheses and attribution

Let \(A\) be the finitely generated normal integral complex algebra of
dimension two asserted by `thm:main`, with
\(\operatorname{Der}_{\mathbb C}(A)\simeq A^2\) and a nonregular maximal
localization. Set \(X=\operatorname{Spec}A\) and \(U=X_{\rm reg}\).
The claim is \(\overline\kappa(U)=2\), with logarithmic Kodaira dimension
defined by the Iitaka dimension of \(K_{\overline U}+D\) on a smooth
projective compactification with reduced simple-normal-crossing boundary.
It is a statement about this global affine \(X\), not just the previously
constructed analytic germ.

The original assertion and argument are OpenAI's September-23-2026
manuscript, `build/06-algebraization.tex`,
`algebra:log-kodaira`, and the introduction. Its supplied reference revision
is `4eaee87548250b2682affda7d05d947c05554bae`. All eight supplied TeX
identities match the reference manifest. Paths for original files are
relative to
`families/048/first-pass/openai_manuscript/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`.
There is no separate old audit directory for this corollary.

## Decisive implication and primary-source application

The finite algebraic differential presentation makes derivations localize.
Consequently the globally free derivation sheaf restricts to
\(\mathcal T_U\simeq\mathcal O_U^2\). The field is algebraically closed
of characteristic zero, \(X\) is an affine algebraic surface (indeed
normal and integral), and \(U\) is exactly its smooth locus.

Read directly: Biswas--Gurjar--Kolte, *On the Zariski-Lipman conjecture for
normal algebraic surfaces*, **arxiv:1403.5613v1**, introduction, field
convention and **Theorem 0.1(1)**,
<https://arxiv.org/html/1403.5613v1>. The hypothesis-bearing passage is
preserved in `biswas_gurjar_kolte_excerpt.txt` beside this report. The theorem
states that triviality of the tangent bundle of the smooth locus and
\(\overline\kappa(U)\leq1\) force an affine algebraic surface to be smooth.
It does not require the surface to be projective; the adjacent projective
parts of Theorem 0.1 are not used.

If \(\overline\kappa(U)\leq1\), this result would make \(X\) smooth,
contradicting its nonregular closed localization over \(\mathbb C\).
The Iitaka dimension of a divisor on a surface, when nonnegative, is an
integer at most two: the defining rational maps have images of dimension
at most two. The other possibility is \(-\infty\), already included in
the excluded inequality. Thus the remaining value is exactly two.
No numerical computation or conjectural classification is being used.

The manuscript also cites journal DOI `10.1112/jlms/jdu021`. This assessment
attributes the proposition to the **actually read v1**, not to uninspected
journal pagination. There was no prior primary passage for this theorem in
the 111 listed artifacts; the targeted lookup fills that specific source
gap, not a new manuscript-error or novelty search.

## Every old claim and route

| Record | Disposition |
|---|---|
| `M_log_kodaira` v1 | Same mathematical conclusion, initially with no explicit assumption annotation. Supported conditionally by the implication above; empty metadata was not a proof without an external theorem. |
| `M_log_kodaira` v2 | Same conclusion, with the explicitly unexamined `Kodaira_input`. The present primary passage supports the needed theorem and its application; it does not retroactively turn the historical label into a reading. |
| `A_kodaira_literature` v1 | A then-unexamined bibliographic obligation, not a second result. Its exact substantive input is now checked against Theorem 0.1(1). |
| `R_M_log_kodaira` | The AND of `M_main` and `A_kodaira_literature` is the correct dependency structure. It is not discharged by analytic realization alone. |

Both mathematical graph nodes were historically open. No old receipt accepts
this corollary or the affine endpoint. The accepted curve, jet and analytic
receipts do not close this extra global implication automatically.

This is a reproduction of the manuscript's short corollary using an
established external theorem. No original contribution or verified novelty
is claimed. No Lean file, symbolic certificate or kernel evidence exists for
this unit; none is needed to interpret the elementary conditional argument.

## Boundary and verdict

No concrete gap was found in the corollary **conditional on the main affine
existence theorem**. It cannot provide evidence for that existence theorem:
the dependency runs in the other direction. The main unit and native
independent review remain necessary. No new counterexample is asserted by
this assessment.
