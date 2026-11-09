import Mathlib

namespace IntegralTwoSwitch

section Cyclic

variable {R : Type*} [CommRing R]

def cyclicDerivative (s : R) (n : ℕ) : R :=
  ∑ i ∈ Finset.range n, (i : R) * s ^ i

def cyclicNorm (s : R) (n : ℕ) : R :=
  ∑ i ∈ Finset.range n, s ^ i

theorem derivative_telescoping (s : R) (n : ℕ) :
    (s - 1) * cyclicDerivative s n + cyclicNorm s n - (n : R) =
      ((n : R) - 1) * (s ^ n - 1) := by
  induction n with
  | zero => simp [cyclicDerivative, cyclicNorm]
  | succ n ih =>
      simp only [cyclicDerivative, cyclicNorm, Finset.sum_range_succ,
        Nat.cast_add, Nat.cast_one, pow_succ] at *
      linear_combination ih

theorem cyclic_derivative_identity (s : R) (n : ℕ) (hs : s ^ n = 1) :
    (s - 1) * cyclicDerivative s n = (n : R) - cyclicNorm s n := by
  have h := derivative_telescoping s n
  rw [hs] at h
  linear_combination h

theorem exact_frobenius (f a ell : R) (hf : f * f - a * f + ell = 0) :
    (f - a) * (a * f - (ell + 1)) = a - (ell + 1) * f := by
  linear_combination a * hf

theorem two_by_two_volume
    (a b c d v₁ v₂ x₁ x₂ : R) :
    (a * v₁ + b * v₂) * (c * x₁ + d * x₂) -
        (c * v₁ + d * v₂) * (a * x₁ + b * x₂) =
      (a * d - b * c) * (v₁ * x₂ - v₂ * x₁) := by
  ring

end Cyclic

section Descent

variable {A B A' B' : Type*}
variable [AddCommGroup A] [AddCommGroup B]
variable [AddCommGroup A'] [AddCommGroup B']

theorem cleared_lifts_agree (r : A →+ B) (h : ℕ)
    (hker : ∀ a, r a = 0 → h • a = 0)
    {x y : A} (hxy : r x = r y) :
    h • x = h • y := by
  have hz : r (x - y) = 0 := by rw [map_sub, hxy, sub_self]
  have hk := hker (x - y) hz
  exact sub_eq_zero.mp (by simpa only [nsmul_sub] using hk)

noncomputable def clearedDescent (r : A →+ B) (h : ℕ)
    (hex : ∀ b, ∃ a, r a = h • b) (b : B) : A :=
  h • Classical.choose (hex b)

theorem clearedDescent_restrict (r : A →+ B) (h : ℕ)
    (hex : ∀ b, ∃ a, r a = h • b) (b : B) :
    r (clearedDescent r h hex b) = (h * h) • b := by
  simp only [clearedDescent, map_nsmul, Classical.choose_spec (hex b), mul_nsmul]

theorem clearedDescent_eq (r : A →+ B) (h : ℕ)
    (hex : ∀ b, ∃ a, r a = h • b)
    (hker : ∀ a, r a = 0 → h • a = 0)
    (b : B) (a : A) (ha : r a = h • b) :
    clearedDescent r h hex b = h • a := by
  unfold clearedDescent
  apply cleared_lifts_agree r h hker
  rw [Classical.choose_spec (hex b), ha]

theorem clearedDescent_add (r : A →+ B) (h : ℕ)
    (hex : ∀ b, ∃ a, r a = h • b)
    (hker : ∀ a, r a = 0 → h • a = 0)
    (b c : B) :
    clearedDescent r h hex (b + c) =
      clearedDescent r h hex b + clearedDescent r h hex c := by
  unfold clearedDescent
  rw [← nsmul_add]
  apply cleared_lifts_agree r h hker
  rw [Classical.choose_spec (hex (b + c)), map_add,
    Classical.choose_spec (hex b), Classical.choose_spec (hex c), nsmul_add]

theorem clearedDescent_natural
    (r : A →+ B) (r' : A' →+ B') (h : ℕ)
    (hex : ∀ b, ∃ a, r a = h • b)
    (hex' : ∀ b, ∃ a, r' a = h • b)
    (hker' : ∀ a, r' a = 0 → h • a = 0)
    (alpha : A →+ A') (beta : B →+ B')
    (hsquare : ∀ a, r' (alpha a) = beta (r a)) (b : B) :
    alpha (clearedDescent r h hex b) =
      clearedDescent r' h hex' (beta b) := by
  unfold clearedDescent
  rw [map_nsmul]
  symm
  apply cleared_lifts_agree r' h hker'
  rw [Classical.choose_spec (hex' (beta b)), hsquare,
    Classical.choose_spec (hex b), map_nsmul]

end Descent

theorem optimal_natural_clearing (h x q : ℤ) (hh : h ≠ 0)
    (hrestrict : h ^ 3 ∣ h * x - q) (hinvariant : h ^ 3 ∣ h ^ 2 * x) :
    h ^ 2 ∣ q := by
  obtain ⟨k, hk⟩ := hinvariant
  have hx : x = h * k := by
    apply mul_left_cancel₀ (pow_ne_zero 2 hh)
    calc
      h ^ 2 * x = h ^ 3 * k := hk
      _ = h ^ 2 * (h * k) := by ring
  obtain ⟨j, hj⟩ := hrestrict
  refine ⟨k - h * j, ?_⟩
  rw [hx] at hj
  linear_combination -hj

section Diamond

variable {R : Type*} [CommRing R]

def strictD (p : R) : Matrix (Fin 4) (Fin 2) R :=
  !![0, 0; 0, 0; 0, -p; p, 0]

def localBoundary (p : R) : Matrix (Fin 4) (Fin 4) R :=
  !![0, 0, 0, p; 0, p, 0, 0; 1, 0, 0, 0; 0, 0, -1, 0]

def relaxedD (p : R) : Matrix (Fin 4) (Fin 6) R :=
  !![0, 0, 0, 0, 0, p; 0, 0, 0, p, 0, 0;
     0, -p, 1, 0, 0, 0; p, 0, 0, 0, -1, 0]

def finiteD (p : R) : Matrix (Fin 4) (Fin 4) R :=
  !![0, 0, 0, 0; 0, 0, 0, p; 0, -p, 1, 0; p, 0, 0, 0]

def singularD (p : R) : Matrix (Fin 4) (Fin 4) R :=
  !![0, 0, 0, p; 0, 0, 0, 0; 0, -p, 0, 0; p, 0, -1, 0]

def finitePair : Matrix (Fin 4) (Fin 4) R :=
  !![0, 1, 0, 0; 1, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, -1]

def singularPair : Matrix (Fin 4) (Fin 4) R :=
  !![0, 1, 0, 0; 1, 0, 0, 0; 0, 0, 0, 0; 0, 0, 1, 0]

def relativeOne : Matrix (Fin 4) (Fin 6) R :=
  !![0, -1, 0, 0, 0, 0; -1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, -1; 0, 0, 0, 1, 0, 0]

def relativeTwo : Matrix (Fin 2) (Fin 4) R :=
  !![0, 1, 0, 0; 1, 0, 0, 0]

def inverseOne (p : R) : Matrix (Fin 6) (Fin 4) R :=
  !![0, -1, 0, 0; -1, 0, 0, 0; -p, 0, 0, 0;
     0, 0, 0, 1; 0, -p, 0, 0; 0, 0, -1, 0]

def inverseTwo : Matrix (Fin 4) (Fin 2) R :=
  !![0, 1; 1, 0; 0, 0; 0, 0]

def relativeHomotopy : Matrix (Fin 6) (Fin 4) R :=
  !![0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 1, 0;
     0, 0, 0, 0; 0, 0, 0, -1; 0, 0, 0, 0]

def localDualityLift : Matrix (Fin 4) (Fin 4) R :=
  !![0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, -1; 0, 1, 0, 0]

def localPair : Matrix (Fin 4) (Fin 4) R :=
  !![0, 0, 0, -1; 0, 0, -1, 0; 0, -1, 0, 0; -1, 0, 0, 0]

set_option maxHeartbeats 2000000 in
theorem coherent_diamond (p : R) :
    relativeTwo (R := R) * relaxedD p =
      (strictD p).transpose * relativeOne (R := R) ∧
    relaxedD p * inverseOne p =
      inverseTwo (R := R) * (strictD p).transpose ∧
    relativeOne (R := R) * inverseOne p = 1 ∧
    relativeTwo (R := R) * inverseTwo (R := R) = 1 ∧
    1 - inverseOne p * relativeOne (R := R) =
      relativeHomotopy (R := R) * relaxedD p ∧
    (1 : Matrix (Fin 4) (Fin 4) R) -
        inverseTwo (R := R) * relativeTwo (R := R) =
      relaxedD p * relativeHomotopy (R := R) ∧
    finitePair (R := R) * finiteD p +
      (finitePair (R := R) * finiteD p).transpose = 0 ∧
    singularPair (R := R) * singularD p +
      (singularPair (R := R) * singularD p).transpose = 0 ∧
    (localDualityLift (R := R)).transpose * localBoundary p +
      (localBoundary p).transpose * localDualityLift (R := R) =
        localPair (R := R) := by
  repeat' apply And.intro
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [strictD, localBoundary, relaxedD, finiteD, singularD,
        finitePair, singularPair, relativeOne, relativeTwo,
        inverseOne, inverseTwo, relativeHomotopy, localDualityLift,
        localPair, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

end Diamond

section Boundaries

variable {D₀ D₁ E₀ E₁ C₁ : Type*}
variable [AddCommGroup D₀] [AddCommGroup D₁]
variable [AddCommGroup E₀] [AddCommGroup E₁] [AddCommGroup C₁]

theorem transferred_boundary
    (d : D₀ →+ D₁) (d' : E₀ →+ E₁)
    (f₀ : D₀ →+ E₀) (f₁ : D₁ →+ E₁)
    (i : C₁ →+ D₁) (p : D₁ →+ C₁) (h : D₁ →+ D₀)
    (hsquare : ∀ x, f₁ (d x) = d' (f₀ x))
    (z : D₁) (hz : z - i (p z) = d (h z)) :
    f₁ z - f₁ (i (p z)) = d' (f₀ (h z)) := by
  rw [← map_sub, hz, hsquare]

end Boundaries

section Volumes

variable {K : Type*} [Field K]

theorem nonprimitive_volume (p a b r s : K) (hp : p ≠ 0)
    (hbezout : a * r + b * s = 1) :
    (p * a) * (r / p) - (p * b) * (-s / p) = 1 := by
  calc
    (p * a) * (r / p) - (p * b) * (-s / p) = a * r + b * s := by
      field_simp [hp] <;> ring
    _ = 1 := hbezout

end Volumes

section Iteration

variable {R G : Type*} [Monoid R] [AddCommMonoid G]

theorem unit_product_no_loss (v : R → G)
    (hmul : ∀ x y, v (x * y) = v x + v y) (hone : v 1 = 0)
    (units : List R) (hu : ∀ u ∈ units, v u = 0) :
    v units.prod = 0 := by
  induction units with
  | nil => simpa only [List.prod_nil] using hone
  | cons u us ih =>
      rw [List.prod_cons, hmul, hu u (by simp)]
      have hus : ∀ w ∈ us, v w = 0 := by
        intro w hw
        exact hu w (by simp [hw])
      rw [ih hus, add_zero]

theorem arbitrary_switch_count (v : R → G)
    (hmul : ∀ x y, v (x * y) = v x + v y) (hone : v 1 = 0)
    (initial : R) (units : List R) (hu : ∀ u ∈ units, v u = 0) :
    v (initial * units.prod) = v initial := by
  rw [hmul, unit_product_no_loss v hmul hone units hu, add_zero]

end Iteration

end IntegralTwoSwitch
