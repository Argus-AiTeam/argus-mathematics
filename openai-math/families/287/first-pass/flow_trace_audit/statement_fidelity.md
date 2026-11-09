# Statement fidelity: the algebraic core, not the operator-algebra theorem

`Main.lean` uses Lean 4.31.0 and Mathlib. It contains no claim that the
whole flow theorem, freeness, an analytic ODE, or a free-group-factor
isomorphism has been formalized.

## `FlowTraceAudit.variation_split`

`R` is an arbitrary (possibly noncommutative) unital ring. `y : R`
and `w : List (Bool x R)` are arbitrary. A Boolean marks whether a
position belongs to the selected component. `wordValue w` is the
ordered product of its ring elements, including the empty product.
`variation true y w` is the sum of products obtained by replacing
one selected entry `x` by `y*x - x*y`, retaining all factor orders.
`variation false y w` does the same at the complementary positions.
The theorem states that their sum is
`y * wordValue w - wordValue w * y`, for every finite list.

There is no bound on length, no commutativity assumption on `R`,
and no test enumeration hidden in the theorem.

## `FlowTraceAudit.selected_trace_zero`

`K` is any additive commutative group. `tr : R ->+ K` is an additive
homomorphism satisfying `tr(a*b) = tr(b*a)` for every `a,b : R`.
For every `y,w`, **if** the complementary variation has trace zero,
the selected variation has trace zero. `trace_comm_zero` proves the
full commutator has trace zero and `variation_split` supplies the
decomposition.

The complementary zero-trace hypothesis is explicit. It is not the
desired selected zero-trace conclusion. In the mathematical report it
is discharged on alternating centered words: complementary factors
lie in `B`, `y` lies in `B`, their commutators remain centered in `B`,
and freeness kills each resulting alternating centered product.
The reduction of arbitrary polynomials to those words and that
freeness argument are prose mathematics, not Lean declarations.

For the manuscript, use `R = M`, `K = C` as an additive group,
`tr = tau`, and select the factors in a fixed conjugate component.
The omitted scalar `i` is restored by complex linearity. Real
coefficient sums are handled by finite linearity in the report.
No stronger claim of formal coverage is intended.

## Additional checked declarations

`all_positive_iterates` quantifies over arbitrary types, an
endomorphism `d`, a functional `tr`, every natural number `r > 0`,
and every input `p`. From `tr(d(q)) = 0` for every `q`, it proves
zero for the recursively defined `r`-fold iterate. Polynomial
finiteness and identification of this iterate with `delta^r` are
established in the report.

`growth_bound` quantifies over all natural numbers `l,J,r`,
including zero, and proves
`prod_(v=0)^(r-1) (l+v*J) <= (l+J)^r * r!`.
Here `growth` defines the product recursively. This is the integer
coefficient-counting inequality used in the analytic Taylor estimate;
norm inequalities, convergence, and real-analytic continuation
are established in prose, not formalized.

The compiler certifies exactly these algebraic and arithmetic
declarations. The complete operator-algebra application remains
subject to independent human-style mathematical review.
