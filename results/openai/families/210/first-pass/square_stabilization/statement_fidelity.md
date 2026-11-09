# Statement fidelity: `C_POWER`

## Formal statement and quantifiers

`Main.lean` proves the actual operator theorem
`SquareStabilization.sl2_power_injective`. Universally quantified are an
arbitrary characteristic-zero field `K`, an arbitrary `K`-vector space `M`
(`AddCommGroup M`, `Module K M`), and three `K`-linear endomorphisms
`D E H : Module.End K M`. No finite-dimensionality, semisimplicity, or
injectivity hypothesis occurs.

The three operator hypotheses hold for **every** `u : M`, with this exact
orientation:

1. `E (D u) = D (E u) + H u`;
2. `H (D u) = D (H u) - (2 : K) • D u`;
3. `H (E u) = E (H u) + (2 : K) • E u`.

Thus `D` lowers the `H`-weight by two and `E` raises it by two.
For every `v : M` and natural numbers `w,L`, the remaining assumptions are
`L ≤ w`, `H v = (w : K) • v`, and the vector-specific local-nilpotence
condition `∃ N : ℕ, (E ^ N) v = 0`. The exact conclusion is

> `(D ^ L) v = 0 → v = 0`.

Powers are genuine endomorphism powers under composition; exponent zero
is the identity. In particular, both `L = 0` and nilpotence bound `N = 0`
are included. Local nilpotence on every vector of `M` is not assumed.

## Complete declaration inventory

All five declarations belong to namespace `SquareStabilization`.

- `weight_lowering_power`: for any scalar weight `w : K`, the `H,D`
  commutator implies
  `H ((D ^ n) v) = (w - 2 * (n : K)) • ((D ^ n) v)`.
- `raising_lowering_power`: for any scalar weight `w : K`, the first two
  commutators imply
  `E ((D ^ (n+1)) v) = (D ^ (n+1)) (E v) +
  (((n : K)+1) * (w-(n : K))) • ((D ^ n) v)`.
  These first two lemmas do not require characteristic zero.
- `primitive_power_injective`: in characteristic zero, the same kernel
  conclusion holds when `E v = 0` and `w,L` are natural with `L ≤ w`.
- `sl2_power_injective_of_nilpotent_bound`: the universal operator kernel
  theorem with a specified natural bound `N` and assumption `(E ^ N) v = 0`.
  Its proof inducts on `N`, applies the induction hypothesis to `E v` at
  weight `w+2` and exponent `L+1`, and then invokes the primitive case.
- `sl2_power_injective`: the preceding theorem with the existential
  vector-specific nilpotence assumption stated above.

Characteristic zero is used to prove that
`((n : K)+1) * ((w : K)-(n : K))` is nonzero when `n+1 ≤ w`;
the field inverse then cancels its action. This is an operator proof,
not a theorem about scalar inequalities standing in for injectivity.

## Prose identifications and exact limitation

For the intended polynomial application, take
`D = y · ∂/∂x`, `E = x · ∂/∂y`, and
`H = deg_x - deg_y`, with summation over coordinate pairs for vector
variables. On polynomials of bidegree `(d_x,d_y)`, the weight is
`w = d_x-d_y` when this is a nonnegative integer. The raising operator
`E` is locally nilpotent because it lowers total `y`-degree.
The displayed commutator signs agree with this orientation.

Constructing these polynomial endomorphisms, proving their derivative
rules and commutators, establishing their degree and nilpotence
properties, and identifying the manuscript's shared-vector differential
operators and their composition with these endomorphism powers remain
**prose**, not Lean declarations in this file. So do the manuscript's
invariant-tensor/symmetric-power identifications, normalization and
construction of the canonical Foulkes--Howe map, and the vanishing
induction/application to that map.

This file supplies the universal whole-power shift core for `C_POWER`.
It does **not** formalize the full polynomial calculus, the canonical
map, or the whole square-bound canonical-surjectivity theorem. Compiler
checking is Engineer implementation evidence, not independent Reviewer
acceptance or an official `lean_evidence` judgment.
