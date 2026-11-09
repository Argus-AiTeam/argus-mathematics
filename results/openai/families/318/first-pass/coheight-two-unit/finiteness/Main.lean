import Mathlib

namespace OrdinaryFiniteness

local instance : Fact (Nat.Prime 5) := ⟨by decide⟩

section NilpotentSection

variable {E S : Type*} [CommRing E] [CommRing S]
  [CharP E 5] [CharP S 5]

theorem power_eq_of_equal_image
    (π : E →+* S) (r : ℕ)
    (nilpotent : ∀ z, π z = 0 → z ^ (5 ^ r) = 0)
    {a b : E} (h : π a = π b) :
    a ^ (5 ^ r) = b ^ (5 ^ r) := by
  apply sub_eq_zero.mp
  rw [← sub_pow_char_pow]
  apply nilpotent
  simpa only [map_sub, h, sub_self]

noncomputable def liftedSection
    (π : E →+* S) (r : ℕ)
    (nilpotent : ∀ z, π z = 0 → z ^ (5 ^ r) = 0)
    (root : S →+* S) (root_spec : ∀ z, (root z) ^ (5 ^ r) = z)
    (lift : S → E) (lift_spec : ∀ z, π (lift z) = z) : S →+* E where
  toFun z := lift (root z) ^ (5 ^ r)
  map_one' := by
    change lift (root 1) ^ (5 ^ r) = 1
    calc
      _ = (1 : E) ^ (5 ^ r) := power_eq_of_equal_image π r nilpotent (by
        rw [lift_spec, map_one, map_one])
      _ = 1 := one_pow _
  map_mul' a b := by
    change lift (root (a * b)) ^ (5 ^ r) =
      lift (root a) ^ (5 ^ r) * lift (root b) ^ (5 ^ r)
    calc
      _ = (lift (root a) * lift (root b)) ^ (5 ^ r) :=
        power_eq_of_equal_image π r nilpotent (by
          rw [map_mul, lift_spec, map_mul, lift_spec, lift_spec])
      _ = _ := mul_pow _ _ _
  map_zero' := by
    change lift (root 0) ^ (5 ^ r) = 0
    calc
      _ = (0 : E) ^ (5 ^ r) := power_eq_of_equal_image π r nilpotent (by
        rw [lift_spec, map_zero, map_zero])
      _ = 0 := zero_pow (pow_pos (by decide : 0 < (5 : ℕ)) r).ne'
  map_add' a b := by
    change lift (root (a + b)) ^ (5 ^ r) =
      lift (root a) ^ (5 ^ r) + lift (root b) ^ (5 ^ r)
    calc
      _ = (lift (root a) + lift (root b)) ^ (5 ^ r) :=
        power_eq_of_equal_image π r nilpotent (by
          rw [map_add, lift_spec, map_add, lift_spec, lift_spec])
      _ = _ := add_pow_char_pow _ _ 5 r

theorem liftedSection_splits
    (π : E →+* S) (r : ℕ)
    (nilpotent : ∀ z, π z = 0 → z ^ (5 ^ r) = 0)
    (root : S →+* S) (root_spec : ∀ z, (root z) ^ (5 ^ r) = z)
    (lift : S → E) (lift_spec : ∀ z, π (lift z) = z) (z : S) :
    π (liftedSection π r nilpotent root root_spec lift lift_spec z) = z := by
  change π (lift (root z) ^ (5 ^ r)) = z
  rw [map_pow, lift_spec, root_spec]

theorem section_unique
    (π : E →+* S) (r : ℕ)
    (nilpotent : ∀ z, π z = 0 → z ^ (5 ^ r) = 0)
    (root : S →+* S) (root_spec : ∀ z, (root z) ^ (5 ^ r) = z)
    (σ τ : S →+* E)
    (hσ : ∀ z, π (σ z) = z) (hτ : ∀ z, π (τ z) = z) :
    σ = τ := by
  ext z
  calc
    σ z = σ ((root z) ^ (5 ^ r)) := by rw [root_spec]
    _ = σ (root z) ^ (5 ^ r) := map_pow σ _ _
    _ = τ (root z) ^ (5 ^ r) :=
      power_eq_of_equal_image π r nilpotent (by rw [hσ, hτ])
    _ = τ ((root z) ^ (5 ^ r)) := (map_pow τ _ _).symm
    _ = τ z := by rw [root_spec]

theorem exists_unique_section
    (π : E →+* S) (r : ℕ)
    (nilpotent : ∀ z, π z = 0 → z ^ (5 ^ r) = 0)
    (root : S →+* S) (root_spec : ∀ z, (root z) ^ (5 ^ r) = z)
    (surjective : Function.Surjective π) :
    ∃! σ : S →+* E, ∀ z, π (σ z) = z := by
  classical
  let lift : S → E := fun z => Classical.choose (surjective z)
  have hlift : ∀ z, π (lift z) = z :=
    fun z => Classical.choose_spec (surjective z)
  refine ⟨liftedSection π r nilpotent root root_spec lift hlift,
    liftedSection_splits π r nilpotent root root_spec lift hlift, ?_⟩
  intro τ hτ
  exact section_unique π r nilpotent root root_spec τ _ hτ
    (liftedSection_splits π r nilpotent root root_spec lift hlift)

end NilpotentSection

section OneVariable

variable {R : Type*} [CommSemiring R]

theorem koszul_comparison (x : R) {s q : ℕ} (h : s ≤ q) :
    x ^ s * x ^ (q - s) = x ^ q := by
  rw [← pow_add, Nat.add_sub_of_le h]

theorem koszul_top_is_identity (x : R) {s q : ℕ} (h : s ≤ q) (v : R) :
    x ^ s * (x ^ (q - s) * v) = x ^ q * v := by
  rw [← mul_assoc, koszul_comparison x h]

theorem top_augmentation_unit {A : Type*} [CommSemiring A]
    (ε : R →+* A) : ε (1 : R) = 1 := map_one ε

theorem wrong_top_augmentation_zero {A : Type*} [CommSemiring A]
    (ε : R →+* A) (x : R) (hx : ε x = 0) : ε (x * 1) = 0 := by
  simp [hx]

theorem root_corestriction_on_trivial_row
    {A : Type*} [CommSemiring A] (ε : R →+* A)
    (x : R) (hx : ε x = 0) {s q : ℕ} (h : s < q) :
    ε (x ^ (q - s)) = 0 ∧ ε (1 : R) = 1 := by
  constructor
  · rw [map_pow, hx, zero_pow (Nat.sub_pos_of_lt h).ne']
  · exact map_one ε

end OneVariable

end OrdinaryFiniteness
