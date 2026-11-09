import Mathlib.Tactic.Ring
import Mathlib.Tactic.Choose

namespace SharpCharacterComparison

universe uA

variable {A : Type uA} [CommRing A]

def CompanionImage (p : A) (t n : ℕ) (c0 : Aˣ) (c : Fin n → A)
    (x : A) (v : Fin n → A) : Prop :=
  ∃ q : A, ∃ w : Fin n → A,
    x = -p ^ (t + 1) * (c0 : A) * q ∧
    ∀ i, v i = p ^ t * w i - p ^ (t + 1) * q * c i

theorem companion_image_iff (p : A) (t n : ℕ) (c0 : Aˣ) (c : Fin n → A)
    (x : A) (v : Fin n → A) :
    CompanionImage p t n c0 c x v ↔ p ^ (t + 1) ∣ x ∧ ∀ i, p ^ t ∣ v i := by
  constructor
  · rintro ⟨q, w, hx, hv⟩
    constructor
    · refine ⟨-(c0 : A) * q, ?_⟩
      rw [hx]
      ring
    · intro i
      refine ⟨w i - p * q * c i, ?_⟩
      rw [hv i, pow_succ]
      ring
  · rintro ⟨⟨u, hu⟩, hv⟩
    choose w hw using hv
    let q : A := -(↑c0⁻¹ : A) * u
    refine ⟨q, (fun i => w i + p * q * c i), ?_, ?_⟩
    · calc
        x = p ^ (t + 1) * u := hu
        _ = -p ^ (t + 1) * (c0 : A) * q := by
          symm
          calc
            -p ^ (t + 1) * (c0 : A) * q =
                p ^ (t + 1) * ((c0 : A) * (↑c0⁻¹ : A)) * u := by
              dsimp [q]
              ring
            _ = p ^ (t + 1) * u := by rw [Units.mul_inv, mul_one]
    · intro i
      rw [hw i, pow_succ]
      ring

theorem scalar_class_annihilator (p : A) (t n : ℕ) (c0 : Aˣ) (c : Fin n → A)
    (x : A) :
    CompanionImage p t n c0 c x (fun _ => 0) ↔ p ^ (t + 1) ∣ x := by
  rw [companion_image_iff]
  simp only [dvd_zero, implies_true, and_true]

end SharpCharacterComparison

#print axioms SharpCharacterComparison.companion_image_iff
#print axioms SharpCharacterComparison.scalar_class_annihilator
