# Statement fidelity: C_LATENT_GENERIC_CORE

## Scope and source

`Main.lean` formalizes the parameter-uniform Boolean evaluation algebra
obstruction in the proof of Lemma `lem:latent-generic` in
`research/openai_manuscript/The-Unique-Games-Theorem-September-23-2026/build/sections/02-latent.tex`,
lines 256–354. It also proves coefficientwise extraction under an explicit
linear-independence hypothesis, and combines these results into a conditional
column-nonmembership theorem.

This is a formal certification of **C_LATENT_GENERIC_CORE only**. It is not a
formal proof of the manuscript's entire finite-field genericity theorem,
**C_LATENT_GENERIC**, or the latent theorem **C_LATENT**. No novelty or
independent-review judgment is asserted.

## Actual evaluation definitions and uniform quantifiers

All declarations below are in the namespace `LatentGenericity`.

* `coordinate point i` is the function on `E` taking the values `0` and `1`
  in an arbitrary field `K`, according to the Boolean coordinate `point e i`.
* `monomial point m` multiplies the coordinates in the list `m : List I`.
  Repeated indices are allowed. The empty list evaluates to the constant
  function `1`.
* `evaluationSpan point d` is the `K`-linear span of the evaluations of lists
  of length at most `d`, **excluding the empty list**. Thus it is exactly the
  span of positive-degree monomials of degree at most `d`, not an assumed
  copy of the whole function space.

`boolean_evaluation_obstruction` quantifies over every field `K` and every
pair of finite types `I` and `E`, with no fixed cardinality or characteristic.
Its hypotheses are:

1. `point : E → I → Bool` is injective, so the indexed Boolean points are
   distinct.
2. `∀ a, ∃ i, point a i = true`, so each point is nonzero.
3. `W : Submodule K (E → K)` satisfies
   `evaluationSpan point 3 ≤ W` and `W ≤ evaluationSpan point 2`.

Its conclusion is `W = ⊤`. These are arbitrary finite types, not checked
finite examples. Neither a dimension conclusion nor the presence of all
functions or of the constant function is assumed.

The proof establishes coordinate-multiplication invariance using the two
degree bounds. `all_positive_monomials_mem` separately proves that every
positive-degree monomial lies in `W`. `point_indicator_mem` constructs each
point indicator: start with a coordinate that is `1` at the chosen nonzero
point, and multiply by the coordinate selectors over `I`. Closure under
`1 - coordinate` follows by subtraction inside `W`; it does not require
`1 ∈ W`. The selectors are `1 - t_i` rather than the manuscript's `1 + t_i`,
which makes this argument valid in every characteristic. A finite linear
combination of point indicators represents every function on `E`.

`generator_card_lower_bound` has the same hypotheses and additionally takes
a finite type `J`, columns `J → E → K`, and the assumption
`W ≤ Submodule.span K (Set.range columns)`. Its conclusion is
`Fintype.card E ≤ Fintype.card J`. The spanning assumption even permits a
generating space initially larger than `W`.

`evaluationSpan_three_eq_cubic_span` identifies the degree-at-most-three
positive span with the span of `cubicEvaluation point`, indexed by
`I × I × I`. Here `cubicEvaluation point (i,j,k)` is the actual monomial
evaluation `t_i t_j t_k`. Boolean idempotence, proved in
`coordinate_mul_self`, recovers degree-one and degree-two evaluations by
repeating indices. This is not an assumption about cubic spanning.

## Coefficientwise extraction: explicit independence assumption

`coefficientwise_extraction` is independent of the Boolean argument. It
quantifies over:

* fields `K`, `A` and a `K`-algebra structure on `A`;
* arbitrary `E` (not even required finite here), finite radical index `R`,
  and finite column index `C`;
* `radicals : R → A`, explicitly assumed to satisfy
  **`LinearIndependent K radicals`**;
* coefficient vectors `coefficients : R → E → K`;
* columns `columns : C → E → K`.

`scalarExtend` maps a vector coordinatewise through `algebraMap K A`.
`radicalCombination radicals coefficients` evaluates at `e` to
`∑ j, coefficients j e • radicals j`, with scalar multiplication over `K`.

If this combination belongs to the **`A`-linear** span of the
scalar-extended columns, then each coefficient vector belongs to the
original **`K`-linear** column span. The column weights in the hypothesis
are arbitrary elements of `A`: they are not restricted to `K` or to the
span of the radicals. The proof extends a basis-coordinate functional on
the radical span to a `K`-linear functional on all of `A`, using Mathlib's
`LinearMap.exists_extend`, and applies it coordinatewise. It requires no
finite-dimensionality of `A` over `K`, no separability, and no
algebraic-closure assumption.

`cubic_radical_not_in_small_quadratic_column_span` combines the results.
For distinct nonzero Boolean points, columns explicitly assumed to lie in
`evaluationSpan point 2`, and fewer columns than points, the combination
of the cubic evaluation vectors with any `K`-linearly independent family
`radicals : I × I × I → A` is not in the extended column span. The number
of radical indices is therefore the manuscript's `r^3` when `|I| = r`.
This is a conditional, parameter-uniform nonmembership theorem.

## What remains outside this formalization

The manuscript applies the conditional result with
`K = F₂(x_ij)` and radicals `sqrt(x_1j x_2k x_3l)` in an extension.
Their `K`-linear independence is a **hypothesis**, not a proved
parity-vector or p-basis assertion in this file. No theorem here constructs
that rational-function field or establishes algebraic independence of its
parameters.

The following links to the full manuscript theorem are also not formalized:

* identifying the manuscript's square-root vector with
  `radicalCombination radicals (cubicEvaluation point)` in characteristic
  two;
* checking the particular columns `t_j z_i(t)` against the explicit
  quadratic-span hypothesis, and instantiating the column index with
  `3r` columns;
* passage from generic column nonmembership to a nonzero polynomial minor,
  preservation of rank by squaring, degree estimates, and specialization;
* the polynomial zero bound, random parametrizations, injectivity and
  nonproportionality probabilities, union bounds, and conditioning.

The injectivity and nonzero-point assumptions of the core theorem, the
quadratic-column assumption of the combined theorem, and the radical
independence assumption are all explicit in the Lean statements.

## Compiler evidence

The intended compiler is Lean **4.31.0**, using the existing Mathlib
workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
There are no `sorry`, `admit`, custom axioms, or `native_decide` shortcuts.
The four final `#print axioms` commands expose the dependencies of the
main declarations in the compilation log.

Official verification writes `evidence/Main.lean`,
`evidence/statement_fidelity.md`, `evidence/lean_check.json`, and
`evidence/compile.log`. The JSON certificate records the real compiler
exit code, proof-hole list, Lean version, and digests of the exact source
and fidelity document. Verification is evidence about the stated core
claim, not an independent reviewer judgment.
