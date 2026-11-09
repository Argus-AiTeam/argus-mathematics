# C_PACK_COUNT: exact counting on an affine fiber

Source: `research/packing-audit/formal/Main.lean`. All declarations below are in
namespace `PackingAudit` and import the supplied Mathlib for Lean 4.31.0.
This document describes only the formal counting core, not a manuscript review.

## Objects and hypotheses

`K`, `V`, and `W` range over arbitrary types, with instances
`[Field K] [AddCommGroup V] [Module K V] [AddCommGroup W] [Module K W]`.
Thus `V` and `W` are vector spaces over the commutative field `K`.
The counting conclusions additionally assume `[Finite K] [Finite V]`.
There is no fixed field order, characteristic, dimension, or enumeration.
No finiteness assumption on `W` is needed.

`F : V →ₗ[K] W` and `g : V →ₗ[K] K` are arbitrary linear maps,
`s : W` is any target, and `B : Finset K` is any finite subset, including
the empty subset and the whole field. A `Finset` has no repeated elements.
`Nat.card {x : V // P x}` is the cardinality of the subtype satisfying `P`;
since `V` is finite, it is the ordinary finite count, equivalently
`(Finset.univ.filter P).card` under a classical `Fintype` enumeration.
`Nat.card K` is the field cardinality and `B.card` is the subset cardinality.
All displayed equalities of counts are in `ℕ`, not in `K`.

## Main declarations and exact signatures

Implicit type and instance parameters are as above. All remaining arguments
displayed here are universally quantified.

```lean
PackingAudit.uniform_fiber_count [Finite K] [Finite V]
    (F : V →ₗ[K] W) (g : V →ₗ[K] K)
    (hw : ∃ v : V, F v = 0 ∧ g v = 1) (s : W) (B : Finset K) :
    Nat.card K * Nat.card {x : V // F x = s ∧ g x ∈ B} =
      B.card * Nat.card {x : V // F x = s}
```

The only additional algebraic hypothesis is the normalized kernel witness
`hw`. Neither `F` nor the joint map `(F,g)` is assumed surjective. No
nonemptiness of the fiber is assumed: an empty fiber has both counts zero.
This is the requested exact uniform-fiber counting identity, with subtype
cardinalities instead of finset-filter notation.

```lean
PackingAudit.exists_kernel_normalized_of_not_scalar_multiple
    (f g : V →ₗ[K] K) (hf : f ≠ 0)
    (hnon : ∀ c : K, g ≠ c • f) :
    ∃ v : V, f v = 0 ∧ g v = 1
```

This theorem needs neither `[Finite K]` nor `[Finite V]`.
Here `hnon` means exactly that `g` is not a scalar multiple of `f`, including
the scalar zero. The proof first normalizes a vector `w` with `f w = 1`.
If `g` vanished on `ker f`, applying it to `x - f x • w` would give
`g = (g w) • f`, contradicting `hnon`. A vector with nonzero `g` value in
`ker f` is then normalized by that value's inverse.

```lean
PackingAudit.nonparallel_forms_uniform_count [Finite K] [Finite V]
    (f g : V →ₗ[K] K) (hf : f ≠ 0)
    (hnon : ∀ c : K, g ≠ c • f) (s : K) (B : Finset K) :
    Nat.card K * Nat.card {x : V // f x = s ∧ g x ∈ B} =
      B.card * Nat.card {x : V // f x = s}
```

This is the two-nonparallel-forms consequence, obtained by supplying the
preceding theorem's witness to `uniform_fiber_count`.

```lean
PackingAudit.constant_on_fiber
    (f g : V →ₗ[K] K) (c s : K)
    (hg : g = c • f) {x : V} (hx : f x = s) :
    g x = c * s
```

The constant branch requires no finiteness or nonzero-form assumption.
Scalar multiplication of linear maps is pointwise, so `(c • f) x = c * f x`.

## Constructive splitting and auxiliary declarations

`fiberEquiv F g s v hvF hvg` is an explicit equivalence

```lean
{x : V // F x = s} ≃ K × {x : V // F x = s ∧ g x = 0}
```

under `hvF : F v = 0` and `hvg : g v = 1`. It sends
`x` to `(g x, x - g x • v)` and has inverse `(a,y) ↦ y + a • v`.

`selectedFiberEquiv F g s B v hvF hvg` gives the restricted equivalence

```lean
{x : V // F x = s ∧ g x ∈ B} ≃
  ↥B × {x : V // F x = s ∧ g x = 0}
```

with the same formulas. Neither equivalence requires finiteness.

`fiber_card_factorization F g s v hvF hvg` proves

```lean
Nat.card {x : V // F x = s} =
  Nat.card K * Nat.card {x : V // F x = s ∧ g x = 0}
```

`selected_fiber_card_factorization F g s B v hvF hvg` proves

```lean
Nat.card {x : V // F x = s ∧ g x ∈ B} =
  B.card * Nat.card {x : V // F x = s ∧ g x = 0}
```

These auxiliary `Nat.card` identities follow directly from the equivalences
and also do not require finiteness. Only their finite-carrier specialization
is used to interpret the main theorem as exact counting. Multiplication and
commutativity yield the main identity without division or cancellation.

## Scope and exclusions

The general theorem can be instantiated with any finite product vector space
and any linear constraint map `F`, provided its stated normalized kernel
witness is supplied. No product decomposition or independence is an
unstated hypothesis. The formalization makes no claim of joint independence
of multiple forms solely from pairwise nonproportionality.

Random sampling, chunks, probabilistic union bounds, packings, matching,
intervals, boundary/interior geometry, and any parameters `r` and `m` are
not encoded. In particular there is no assumption `r ≤ m` and no
interior-center assumption. This file does not register claims, modify the
ledger, or produce an official Lean evidence certificate.

## Local validation

The source is checked with the supplied built Mathlib workspace using
`timeout 110s lake env lean` on its absolute path. Compiler transcripts
are kept beside the source as `compiler-*.log`. The final check recorded in
`compiler-final.log` exited with code `0`, with no errors or warnings.
The source contains no `sorry`, `admit`, or added axioms. There is no remaining
local compilation issue; the parent is responsible for the official
`lean_evidence` verification bound to `C_PACK_COUNT`.
