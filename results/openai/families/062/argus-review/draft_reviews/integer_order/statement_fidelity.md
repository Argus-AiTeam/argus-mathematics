# Statement fidelity: exact arithmetic reproduction C_REPLAY_INTEGER

This note accompanies only `research/draft_reviews/integer_order/Main.lean`
and current claim `C_REPLAY_INTEGER` in `CTX_REPLAY_INTEGER`. The context and
natural claim were recorded before this source was created. This is a
reproduction, not new mathematics and not the current review claim
`C_REVIEW_F062`.

The source is an exact copy of the final old
`9000062/research/contact_value_descent/Main.lean`, recorded as
`C_DES_INTEGER_ORDER` version 3. Its SHA-256 is
`da7fec26e42591955da7e86c0505b0a10ea81864ba8aec3a1651ede0cbec040a`.
This new fidelity note is intentionally different from the old note; a fresh
official compiler record must bind this exact source and this exact note.

## Exact statements and hypotheses

The unqualified declaration names are `exponent_mul_integer_ne_one` and
`power_order_obstruction`; the full names below include their namespace.

1. `ContactValueDescent.exponent_mul_integer_ne_one` quantifies over every
   `e : Nat`, a proof `he : 2 <= e`, and every `m : Int`. It proves
   `Not ((e : Int) * m = 1)`.
2. `ContactValueDescent.power_order_obstruction` quantifies over an arbitrary
   universe-polymorphic type `A` with `[Monoid A]`, an arbitrary function
   `order : A -> Int`, `e : Nat`, a proof `he : 2 <= e`, and `z t : A`.
   Its two additional hypotheses are exactly
   `order (z ^ e) = (e : Int) * order z` and `order t = 1`.
   It proves `Not (z ^ e = t)`.

The monoid need not be commutative. The function is not assumed to be a
valuation or a homomorphism, and compatibility is assumed only for this
particular power. No additional positivity hypothesis on `order z` is
assumed. Both conclusions use propositional `Not`, never Boolean `!=`;
there is no `BEq A` hypothesis. The condition `2 <= e` is essential to
the stated obstruction.

## Argument and trust boundary

If `e*m=1`, nonnegative `e` forces `m>=1`: otherwise the product is at
most zero. Then `e*m>=e>=2`, a contradiction. For the second declaration,
an equality `z^e=t` and the two order hypotheses would give
`e*order(z)=1`, contradicting the first declaration.

`import Mathlib.Tactic` supplies the arithmetic infrastructure and tactics.
There are no user-declared axioms or admitted proof terms in this source.
The old successful run printed the foundational axioms `propext`,
`Classical.choice`, and `Quot.sound` for both declarations. The fresh
compiler and axiom-audit results, including the actual installed toolchain,
are recorded separately by the official verifier, not asserted by this note.
Hash binding prevents later text substitution; it does not mechanically
establish the truth of this natural-language translation.

Neither declaration constructs analytic germs, vanishing orders,
transversality, a degree-one sheet, finite maps, purity, or geometric
descent. Supplying any such application is an independent mathematical
obligation. This reproduction neither proves the geometric descent
proposition nor certifies a manuscript or this retrospective review.
