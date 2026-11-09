# Reading of `Main.lean`

The declarations are in namespace `TwistedLift`. The formal claim is
`V_FORMAL_CORE`, comprising the universal homotopy-extension theorem and
the symmetric-trace factorization theorem below. It is not a formalization
of either manuscript's complete counterexample.

## All-degree homotopy

`lift_to_range` uses actual `Module.Projective` and actual linear-map
ranges. It proves that a linear map from a projective module lifts through
another map whenever its image is contained in the latter's image.

`augmented_nullhomotopy` quantifies over an arbitrary, possibly
noncommutative ring `R`, arbitrary families of `R`-modules `P n,Q n` for
**all natural numbers** `n`, and projectivity of **every** `Q n`.
No finite-degree cutoff occurs. Its data are:

- `d n : P(n+1) -> P n`, with surjective `d 0` and
  `range(d(n+1)) = ker(d n)` for every `n`;
- `e n : Q(n+1) -> Q n`, with `e n * e(n+1)=0`;
- `f n : Q(n+1) -> P(n+1)`, satisfying the displayed chain equations;
- `z : Q 0 -> P 0`, satisfying `d 0 * f 0 = z * e 0`.

The conclusion is existence of a single coherent family
`G n : Q n -> P(n+1)` satisfying `d 0 * G 0=z` and
`d(n+1) * G(n+1) + G n * e n = f n` for **every** `n`.
Here `*` in this paragraph denotes composition, not scalar multiplication.

For AR Lemma `lift:G`, use `R=T^e`, set the formal `P 0=T`,
`P(n+1)=P_n` of the manuscript's untwisted augmented bar resolution,
and set formal `Q n` equal to the manuscript's twisted `Q_(n+1)`.
The formal `e n` is its differential `Q_(n+2)->Q_(n+1)`;
the formal `f n` is `(pB)_(n+2)`; and `z=z'`.
Thus formal `G n` is manuscript `G_(n+1)`. The original `G_0=0`
is added separately. The source boundary identity is exactly the formal
augmentation hypothesis. The bar resolution, its exactness/projectivity,
the comparison map `p`, the `B` homotopy, and their concrete identifications
are established outside Lean, not asserted to have been compiled.

## Stable nonfactorization core

`left_annihilator_kills_right` quantifies over a ring `R`, a function
`tr:R->K` to a type with zero, a cyclic trace identity, `tr(0)=0`,
and left nondegeneracy:
`(forall a, tr(a*u)=0) -> u=0`.
`J` is a predicate closed under right multiplication. The theorem proves
that if every element of `J` kills `u` on the left, then `u` kills every
element of `J` on the right. It does not assume commutativity.

`finite_free_factorization_vanishes` has the same trace hypotheses,
an `R`-module `M` annihilated by `J`, an arbitrary natural number `n`,
and actual `R`-linear maps
`alpha:M -> R^n` and `beta:R^n -> R` whose second image lies in `J`.
It proves `beta composed with alpha = 0`.
For the application take `R=A`, `J=rad(A)`, `M=X`, and include the
target `rad(A)(f tensor f)` into `A`. A factorization through a finite
projective becomes a finite-free factorization by taking a finite
projective complement. This last finite-projective reduction is proved
in the mathematical report, not encoded as another Lean declaration.

`twist_square_nonzero` states that `H*H` is nonzero for every nonzero
element of any field. It imposes no independence condition on `H`.

## Exact boundary of certification

The concrete 179-entry cochain, multiplication table, bar-word
calculations, tensor cones, tail construction, and actual value
`H^2(F tensor F)` are not encoded in Lean. They are checked by `verify.py`
or proved in `research/twisted_lift_report.md`. No compilation result is
to be described as a kernel proof of those translations or of either
manuscript's main theorem.

The original application retains characteristic two, algebraically
independent `q,H_1,H_2`, and every `H` in the resulting field's
multiplicative group. The formal theorems are general implication
theorems; no missing concrete hypothesis is discharged by pretending
that it was part of the compiled statement.
