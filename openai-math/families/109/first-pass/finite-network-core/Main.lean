import Mathlib

namespace FiniteNetworkCore

section Restoration

variable {X Y A C : Type*}
variable [AddCommGroup X] [AddCommGroup Y] [AddCommGroup A] [AddCommGroup C]

def forward (V : X →+ A) (G : X →+ C) (J : A →+ Y) (R : C →+ Y)
    (x : X) (y : Y) (a : A) (c : C) : X × Y × A × C :=
  let y₀ := y - J a
  let y₁ := y₀ - R c
  let a₁ := a + V x
  let c₁ := c + G x
  let y₂ := y₁ + R c₁
  let y₃ := y₂ + J a₁
  let c₂ := c₁ - G x
  let a₂ := a₁ - V x
  (x, y₃, a₂, c₂)

theorem transparent_restoration
    (V : X →+ A) (G : X →+ C) (J : A →+ Y) (R : C →+ Y)
    (x : X) (y : Y) (a : A) (c : C) :
    forward V G J R x y a c =
      (x, y + (J (V x) + R (G x)), a, c) := by
  simp only [forward, map_add, add_sub_cancel_right]
  congr 1
  abel

theorem signed_exchange (x y : X) :
    let y₁ := y + x
    let x₂ := x - y₁
    let y₃ := y₁ + x₂
    (x₂, y₃) = (-y, x) := by
  dsimp
  apply Prod.ext <;> simp only [Prod.fst, Prod.snd] <;> abel

end Restoration

section Frames

variable {R V ι : Type*}
variable [Semiring R] [AddCommMonoid V] [Module R V] [Fintype ι]

theorem common_frame_gate (D : V →ₗ[R] V) (c : ι → R) (x : ι → V) :
    D (∑ j, c j • x j) = ∑ j, c j • D (x j) := by
  simp

theorem edge_frame_change (D E : V ≃ₗ[R] V) (x : V) :
    E (D.symm (D x)) = E x := by
  simp

end Frames

section ProjectionAlgebra

variable {S : Type*} [Ring S]

theorem nested_projection_difference
    (p q : S) (hp : p * p = p) (hq : q * q = q)
    (hpq : p * q = p) (hqp : q * p = p) :
    (q - p) * (q - p) = q - p ∧
      p * (q - p) = 0 ∧ (q - p) * p = 0 ∧ q = p + (q - p) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · simp only [sub_mul, mul_sub, hp, hq, hpq, hqp, sub_self, sub_zero]
  · simp only [mul_sub, hpq, hp, sub_self]
  · simp only [sub_mul, hqp, hp, sub_self]
  · abel

theorem orthogonal_sum_projector
    (p q : S) (hp : p * p = p) (hq : q * q = q)
    (hpq : p * q = 0) (hqp : q * p = 0) :
    (p + q) * (p + q) = p + q := by
  simp only [add_mul, mul_add, hp, hq, hpq, hqp, add_zero, zero_add]

end ProjectionAlgebra

section ResidualImage

variable {V : Type*} [AddCommGroup V]

theorem residual_image
    (p q : V →+ V)
    (hp : ∀ x, p (p x) = p x)
    (hq : ∀ x, q (q x) = q x)
    (hpq : ∀ x, p (q x) = p x)
    (hqp : ∀ x, q (p x) = p x)
    (z : V) :
    (∃ x, q x - p x = z) ↔ ((∃ x, q x = z) ∧ p z = 0) := by
  constructor
  · rintro ⟨x, rfl⟩
    constructor
    · refine ⟨x - p x, ?_⟩
      simp only [map_sub, hqp]
    · simp only [map_sub, hpq, hp, sub_self]
  · rintro ⟨⟨x, hx⟩, hpz⟩
    have hqz : q z = z := by
      calc
        q z = q (q x) := congrArg q hx.symm
        _ = q x := hq x
        _ = z := hx
    exact ⟨z, by rw [hqz, hpz, sub_zero]⟩

end ResidualImage

section NonzeroScalarImage

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

theorem nonzero_scalar_image (p : V →ₗ[K] V) (c : K) (hc : c ≠ 0) (z : V) :
    (∃ x, c • p x = z) ↔ ∃ x, p x = z := by
  constructor
  · rintro ⟨x, hx⟩
    exact ⟨c • x, by simpa only [map_smul] using hx⟩
  · rintro ⟨x, hx⟩
    refine ⟨c⁻¹ • x, ?_⟩
    simpa only [map_smul, smul_smul, mul_inv_cancel₀ hc, one_smul] using hx

end NonzeroScalarImage

section BinaryWeight

variable {ι : Type*} [Fintype ι]

def bit (b : Bool) : ℤ := if b then 1 else 0

def weight (v : ι → Bool) : ℤ := ∑ j, bit (v j)

def overlap (v w : ι → Bool) : ℤ := ∑ j, bit (v j) * bit (w j)

def xorVector (v w : ι → Bool) : ι → Bool := fun j => Bool.xor (v j) (w j)

theorem bit_xor (b c : Bool) :
    bit (Bool.xor b c) = bit b + bit c - 2 * (bit b * bit c) := by
  cases b <;> cases c <;> norm_num [bit]

theorem weight_xor (v w : ι → Bool) :
    weight (xorVector v w) = weight v + weight w - 2 * overlap v w := by
  simp only [weight, xorVector, bit_xor, overlap, Finset.sum_sub_distrib,
    Finset.sum_add_distrib, Finset.mul_sum]

theorem orthogonal_weight_additivity
    (v w : ι → Bool) (orthogonal : ∃ k : ℤ, overlap v w = 2 * k) :
    ∃ k : ℤ, weight (xorVector v w) = weight v + weight w + 4 * k := by
  obtain ⟨k, hk⟩ := orthogonal
  refine ⟨-k, ?_⟩
  rw [weight_xor, hk]
  ring

theorem odd_line_endpoint_phase (w r b : ℤ) (odd : ∃ k : ℤ, r = 2 * k + 1) :
    ∃ k : ℤ, w - 2 * r * b = w + 2 * b + 4 * k := by
  obtain ⟨k, hk⟩ := odd
  refine ⟨-(k + 1) * b, ?_⟩
  rw [hk]
  ring

end BinaryWeight

end FiniteNetworkCore
