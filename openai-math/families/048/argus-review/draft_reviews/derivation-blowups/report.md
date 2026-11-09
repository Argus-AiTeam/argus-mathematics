# Iteration of derivation-module blowups

**Engineer assessment: the conditional implication is supported. Native
independent review remains pending.** A free derivation module makes the
module blowup trivial. A characteristic-zero singular example still depends
on the main affine existence claim; this corollary is not another example.

## Exact objects, version and attribution

For the normal integral complex affine surface \(X=\operatorname{Spec}A\)
asserted in `thm:main`, let \(M=\operatorname{Der}_{\mathbb C}(A)\simeq A^2\).
The claim is that every finite iteration of blowing up at the derivation
module is isomorphic to \(X\); the same is true if normalization is inserted
after each step. Thus neither iteration resolves its singular point.

The original claim is OpenAI's September-23-2026 manuscript,
`build/06-algebraization.tex`, `algebra:derivation-blowups`, with context in
`build/01-introduction.tex`. The supplied reference revision is
`4eaee87548250b2682affda7d05d947c05554bae`; all eight supplied TeX
identities match that reference manifest. Original paths are under the
read-only directory
`families/048/first-pass/openai_manuscript/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`.
No separate audit directory assessed this consequence.

The universal module blowup here means the proper birational modification
making pullback modulo torsion locally free of the generic rank, universal
for this property. It is not a blowup at the Jacobian ideal, a Nash blowup,
or an arbitrarily chosen Rees construction.

## Decisive proof, including both inverse identities

Write \(f:B\to X\) for the universal blowup at \(M\).
Since \(M\) is already free, \(\operatorname{id}_X\) is admissible.
Universality gives a unique \(s:X\to B\) with \(fs=\operatorname{id}_X\).
Use universality again for the admissible morphism \(f:B\to X\).
Both \(\operatorname{id}_B\) and \(sf\) are lifts of \(f\), so uniqueness
gives \(sf=\operatorname{id}_B\). Thus \(f\) is an isomorphism, not just
a morphism with a section.

Derivation modules are preserved under the resulting algebra isomorphism.
Induction therefore makes every subsequent blowup the identity. Normality
of \(A\) also makes its normalization the identity at every stage. The
singular point is retained because isomorphisms preserve regularity.
Normality is needed for the normalization-interspersed assertion, not for
the first free-module argument. The implication itself is not specific
to characteristic zero; only the claimed instance and its significance are.

## Primary proposition and exact hypotheses

Read directly: Barajas--Chavez-Martinez--Romano-Velazquez,
*The blow-up of a singularity at the module of derivations*,
**arxiv:2510.07607v2**, **section 1.6, Theorem 1.17**,
<https://arxiv.org/html/2510.07607v2>. The theorem is attributed there to
Villamayor's Theorem 3.3. Its setting is a domain \(R\) and a finite module
\(M\) of generic rank \(r\); it gives the locally free pullback and the
unique-factorization universal property used above. The immediately
following paragraph identifies its blowup as proper birational in this
setting. The hypothesis-bearing passage is preserved in
`module_blowup_excerpt.txt`.

The hypothetical \(A\) is a domain, and its derivation module is finite
because algebraic differentials have a finite presentation; in fact it is
assumed free of rank two. Both applications of the universal property
therefore meet the stated hypotheses. The introduction after Question 1
already explains that a Lipman-Zariski counterexample would give a negative
answer to the iteration question. The nearby Theorem 2.1 assumes the
Lipman-Zariski conjecture: it is **not** used to infer smoothness or
nontriviality here. The paper's positive log-canonical cases also do not
give a theorem for every normal surface.

The original Villamayor article was not separately retrieved. The exact
proposition cited by the manuscript is present in the actually read,
version-matched source. This checks that application, not an attribution
to an uninspected theorem number in the original article.

## Complete historical coverage and verdict

| Old record | Assessment |
|---|---|
| `M_derivation_blowups` v1 | Same iteration assertion with no explicit external annotation; the conditional universal-property proof supports it, not its bare status. |
| `M_derivation_blowups` v2 | Adds the explicitly unexamined `Module_blowup_input`. Its substantive universal-property dependency has now been checked against the primary v2 statement. |
| `A_blowup_literature` v1 | Historical bibliographic obligation, not a second construction. The exact Theorem 1.17 and introduction passage have been read; Villamayor's original article is not claimed read. |
| `R_M_derivation_blowups` | Correct AND dependency on `M_main` and the universal-property input. A free **analytic** tangent stalk is not itself the global algebraic example required here. |

The graph's open flags and unexamined-source prose do not refute this
elementary implication. Conversely no old accepted curve/jet/analytic
receipt accepts the main affine example or this corollary. Current
independent native review remains required.

No concrete gap was found in the conditional argument. It reproduces a
standard consequence already noted by the cited authors and the manuscript;
it has no independently verified novelty. There is no symbolic, Lean or
kernel evidence for this unit, and no computation was needed. No old
input was changed.
