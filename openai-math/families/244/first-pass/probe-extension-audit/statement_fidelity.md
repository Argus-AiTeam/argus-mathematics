# Statement fidelity: the actual probe presentation

## Claim and declarations

Claim `C_PROBE_CORE` concerns the algebraic core of
`lem:mono-probe-algebra` in the staged manuscript's
`build/sections/monoid.tex`, lines 168--338.

The principal declaration is
`ProbeAudit.Source.probe_algebra_core`. Its construction is identified
with the manuscript presentation by `ProbeAudit.Source.p_step`,
`ProbeAudit.Source.p_close`, and
`ProbeAudit.Source.presentation_universal`. All these declarations are
in `Main.lean`; they are not axioms.

## Objects and quantifiers

`M` is an arbitrary type in an arbitrary universe with a monoid structure.
`lc` states left cancellation for every three elements of `M`.
`Conical M` states that a product equal to `1` has both factors `1`.
`ConditionalJoins M` states that any two elements with a common right
multiple have an element generating exactly the intersection of their
principal right cones. `RDiv x y` means `exists z, x*z=y`; it never
means left divisibility.

The source-specialized theorem quantifies over all `a,b,e` in `M` with
`b != 1`, `e != 1`, and over all sequences `n,d,c : Nat -> M` with

    n(0)=1,    n(i)*d(i)=n(i+1),    n(i)*c(i)=a.

These are the manuscript path equations, including repetitions. The
theorem `coherence` derives `d(i)*c(i+1)=c(i)` by left cancellation.
There is no right-cancellation hypothesis, no injectivity hypothesis
on `x -> x*d(i)`, and no finiteness hypothesis.

Heights, costs, and cardinality are not encoded: the theorem proves the
algebraic conclusion under weaker hypotheses than the manuscript, so
every base satisfying those additional conditions is included. The more
general `Source.algebra_core` needs only coherence of `d,c`, not a
particular common upper bound or the condition `b != 1`.

## The constructed extension is the presented extension

`Source.Letters d` is the set direct limit of copies of `M` under right
multiplication by the finite products of the `d(i)`. Mathlib's
`DirectLimit` uses equality at a finite common stage; its component maps
are not required to be injective. `Source.act_inj` cancels an old left
multiplier at that common stage.

`Source.k` is `[x,i] -> x*c(i)`. The map `h` in `Source.data` is
`s -> k(s)*e`. Head separation is proved from equivariance, conicality,
left cancellation, and `e != 1`. The two fields of `ConeData` are
proved in `Source.cone_data` using `Source.common_stage`; they are not
extra premises of either source theorem.

`ActData.NF` is an explicitly constructed monoid of reduced finite
strings of direct-limit letters ending in an old element. Its monoid
laws, reduction compatibility, cancellation, and conicality are proved.
In particular, no normal-form uniqueness theorem is assumed.

`Source.p(i)` is the letter `[1,i]`. The declarations `p_step` and
`p_close` prove exactly

    p(i) = old(d(i))*p(i+1),
    p(i)*old(b) = old(c(i)*e).

For any target monoid `N`, any monoid homomorphism `f:M -> N`, and
any sequence `q(i)` satisfying these two relations with `old` replaced
by `f`, `presentation_universal` proves existence and uniqueness of a
homomorphism from `NF` extending `f` and sending `p(i)` to `q(i)`.
The base map into `N` is not required to be injective. Thus `NF`
has the universal property of the actual presentation over `M`;
the theorem is not just about a model satisfying some of its equations.

## Conclusions

`probe_algebra_core` proves left cancellation, conicality, and
conditional joins for `NF`. It proves `Conservative old`, which includes
injectivity of the base map, reflection and preservation of old
comparisons with their exact old right factors, preservation of old
joins, and preservation of old disjoint right cones.

It also proves `GateCore old`. For every new `x` with an old right
multiple, this gives old elements `g,c` such that

    x*old(c)=old(g);
    for every old a, x divides old(a) implies g divides a in M;
    for every old d, old(g) divides x*old(d) implies
                    x*old(d)=old(a) for some a in M.

The first two conditions say that `g` is a least old right multiple,
not merely a minimal one. The third is exactly
`eq:mono-gate-old`. Divisibility in that condition is tested in the
constructed extension.

The stronger internal theorem `ActData.all_exits` constructs old-rooted
exit cones; it is proved recursively rather than assumed.
`ActData.append_old_shape` proves the separate old-factor assertion.
The conditional-join conclusion permits repeated algebraic extensions;
no claim about extending the real margins is encoded.

## Limits of this certification

This formalization does not certify the full probe divisor-profile
display, the extension of height and cost functions, conservative
simulation over a larger base, the countable-base rearrangement, the
forcing argument, or either main consistency theorem. It does not prove
the manuscript correct as a whole or establish a set-theoretic
independence result.

The compiler checks the encoded statements and proofs. This document's
translation from the manuscript and the identification by universal
property remain matters for independent human mathematical review.
