# Campaign 1465: exact exhausted boundary

## Verdict

This campaign has reached an exact exhausted boundary for the mechanisms that
were actually tested. It has not proved the unrestricted negative claim, found
a positive witness, or produced a counterexample certificate. No candidate is
advanced.

Write

\[
E_0(x)=x,\qquad E_{n+1}(x)=\exp(E_n(x)).
\]

The unresolved question is whether an o-minimal expansion of the actual real
ordered field can define \(T:\mathbb R\to\mathbb R\) such that, for every
standard \(n\), there is \(N_n\) with

\[
T(x)>E_n(x)\qquad(x\geq N_n).
\]

The independently reviewed source audit remains current through 2026-08-27 and
classifies this exact question as open. The accepted campaign target is the
unconditional negation over every o-minimal expansion and every definable
\(T\); conditional, restricted, non-Archimedean, and finite-fragment results do
not meet that target.

## Established results used in this boundary

The following are established at the cited-source or independently reviewed
mathematical-judgement tier. None is presented as a mechanically closed formal
theorem.

1. **Common consequences of a hypothetical witness.** Such a \(T\) tends to
   \(+\infty\), is eventually continuous and strictly increasing, makes its
   structure non-polynomially bounded, and therefore makes the standard real
   exponential definable. This is recorded as
   `C_1465_WITNESS_COMMON_CONSEQUENCES` and proved in
   `research/routes/hardy-germ-obstruction/REPORT.md`.
2. **Uniform finiteness for a fixed family.** In a fixed o-minimal real-field
   structure, every fixed definable family has a uniform finite bound on the
   connected components of its fibers. The exact contract of van den Dries and
   Miller, Theorem 4.4, was independently checked and is recorded as
   `A_1465_VDDM_UNIFORM_FIBERS` supporting
   `C_1465_UNIFORM_FIBER_BOUND`.
3. **Exact finite-fragment countermodels.** For every \(m\geq0\), the
   definitional expansion of \(\mathbb R_{\exp}\) by
   \(T_m=E_{m+1}\) is o-minimal and satisfies every domination instance of
   depth at most \(m\). Thus no consequence using only finitely many
   domination instances can force an infinite-component unary definable set.
   This is `C_1465_FINITE_DOMINATION_COUNTERMODELS`, with proof in
   `research/routes/direct-discreteness-obstruction/REPORT.md`.
4. **All tested fixed families stay uniformly simple in the exact models.**
   The translation-conjugacy formulas F1-F6 and the tested logarithmic
   derivative, pre-Schwarzian, Schwarzian, inverse-curvature, displacement, and
   power families have at most two connected components per unary fiber,
   uniformly in \(m\). The later all-\(m\) symbolic proof also shows that the
   normalized third-derivative ratio is strictly unimodal, so
   \[
   T_m'''(x)T_m'(x)-c(T_m''(x))^2=0
   \]
   has at most two points for \(m\geq1\), and at most one connected component
   for \(m=0\). These results are
   `C_1465_TM_TESTED_FIXED_FORMULA_BOUNDS` and
   `C_1465_NORMALIZED_THIRD_DERIVATIVE_UNIMODAL`, proved in
   `research/routes/uniform-family-obstruction/REPORT.md` and
   `research/routes/normalized-third-derivative/REPORT.md`. The latter report
   supersedes only the earlier report's statement that the normalized
   third-derivative family was unresolved.

## Routes exhausted, with their exact boundaries

| Route | Exact result | What the result does not establish | Evidence |
|---|---|---|---|
| Hardy-germ finite height | The proposed finite-height lemma is equivalent to universal exponential boundedness; finite global Hardy rank is false already in \(\mathbb R_{\exp}\). | It does not disprove finite height or settle universal exponential boundedness. | `research/routes/hardy-germ-obstruction/REPORT.md` |
| Crossing, threshold, orbit, and log-tower discreteness | Every tested unbounded construction needs an external iterate index or transitive closure, and every finite domination fragment has an explicit o-minimal countermodel. | It does not exclude a different non-indexed first-order construction using the full scheme. | `research/routes/direct-discreteness-obstruction/REPORT.md` |
| Translation-conjugacy formulas F1-F6 | Exact all-\(m\) reductions give an \(m\)-independent bound of at most two components per fiber. | It is not a normal-form theorem for every formula involving the flow and gives no transfer to arbitrary \(T\). | `research/routes/uniform-family-obstruction/REPORT.md` |
| Tested derivative families | Every tested family, including the normalized third-derivative family after the later symbolic proof, has an \(m\)-independent bound of at most two components in \(T_m\). | It does not bound every fixed first-order family and does not transfer the special \(T_m\) identities to an arbitrary full-scheme witness. | `research/routes/uniform-family-obstruction/REPORT.md`; `research/routes/normalized-third-derivative/REPORT.md` |
| Restricted transfer theorems | Fu regularity, rigid functional equations, polynomially bounded or Pfaffian hypotheses, and non-Archimedean results all require assumptions absent from the target. | None proves the unrestricted actual-real-field negation. | Retired routes in `research/MATH_STATE.json` |

These are route-local closures. They do not say that every possible
counterexample strategy has been exhausted.

## Remaining proof gap

The uniform-finiteness implication itself is exact: if the full domination
scheme yielded one fixed finite first-order formula \(\phi(x;y)\), with syntax
and parameter arity independent of \(k\), whose fibers realize at least \(k\)
components for every \(k\), then uniform finiteness would give an immediate
contradiction.

The missing implication is exactly
`C_1465_FIXED_FORMULA_UNBOUNDED_FIBERS`:

\[
\text{full domination by one arbitrary definable }T
\Longrightarrow
\text{unbounded fiber complexity in one fixed formula}.
\]

No tested construction proves this implication. Eventual domination compares
\(T(x)\) with \(E_n(x)\) at a common argument. It does not by itself provide
an internal iterate index, orbit reachability, comparisons between \(T(u+s)\)
and functions of \(T(u)\), derivative control, or the commutation identities
special to \(T_m\).

Accordingly, both `C_1465_FIXED_FORMULA_UNBOUNDED_FIBERS` and the unrestricted
goal `C_1465_UNRESTRICTED_NEGATIVE` remain open. The proof graph records the
former as the sole unproved frontier proposition on the current
uniform-finiteness route.

## Why no exact candidate is advanced

The functions \(T_m=E_{m+1}\) witness only finite domination fragments, never
the full scheme. The finite numerical derivative probe and the bounded
Jacobian operations were discovery or consistency checks, not universal
certificates; the later symbolic derivative theorem proves low complexity
rather than the required complexity growth. The conditional and restricted
literature results use hypotheses excluded by the objective.

Therefore the available evidence supplies neither a full-scheme definable
witness nor an unconditional contradiction from o-minimality alone. Advancing
either would overstate the exact reviewed record.
