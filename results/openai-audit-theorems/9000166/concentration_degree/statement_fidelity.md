# Statement fidelity

The bare declaration names are `coefficient_nonnegative` and
`symmetry_skew_vanish`, both in namespace `ConcentrationDegree`.

`Main.lean` imports the installed Mathlib and contains two universally
quantified algebraic theorems. Neither theorem formalizes a variety,
intersection number, incidence, Pfaffian classification, or the
distinct-distances conjecture.

`ConcentrationDegree.coefficient_nonnegative` quantifies over **every** table
`c : Nat -> Nat -> Int`. Its hypotheses are exactly

* `c(p,0)=1`;
* `c(p,1)=p-2`, with the subtraction in the integers;
* `c(p+2,u+2)=choose(p,u+2)+c(p,u)`.

Its conclusion is `c(p,u)>=0` for all natural `u,p` with `u+1<=p`.
Thus it certifies the unrestricted induction behind the nonnegative
Segre coefficients, not merely a finite table. The identification of the
manuscript coefficient `[z^u](1+z)^p/(1+2z)` with a table satisfying these
recurrences is proved in the report from an exact generating-function
identity. That identification is **not** a Lean theorem in this file.
Claim `C166_COEFF` refers to this recurrence-to-positivity theorem.

`ConcentrationDegree.symmetry_skew_vanish` quantifies over any field `K`
of characteristic zero, any index type `I` (not only a finite type), and
any tensor `T : I -> I -> I -> K`. Symmetry of the first two positions
and antisymmetry of the last two positions force every entry to vanish.
The theorem applies in particular to `K = Complex`. It checks the
pointwise algebra used for the Hessian/Gram tensor in the null-graph
rigidity argument. The analytic existence of the graph, equality of mixed
partials, and passage from a zero Hessian to a global projective linear
space remain mathematical arguments in the report.
Claim `C166_NULL_TENSOR` refers only to the universally quantified tensor
theorem, not to that geometric passage.

The compiler checks these declarations and their proofs. No mathematical
claim about all complex varieties, no numerical experiment, and no
literature attribution is being relabelled as kernel verification.
