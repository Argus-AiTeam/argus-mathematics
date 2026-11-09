import Mathlib

open scoped BigOperators

namespace ConePicture

variable {A B C T : Type*}
variable [AddCommGroup A] [AddCommGroup B] [AddCommGroup C] [AddCommGroup T]

def coneD2 (δ : A →+ B) (a : A) : A × B :=
  (a, -δ a)

def coneD1 (δ : A →+ B) (ε : B →+ C) (x : A × B) : B × C :=
  (δ x.1 + x.2, -ε x.2)

def coneD0 (ε : B →+ C) (x : B × C) : C :=
  ε x.1 + x.2

theorem coneD2_injective (δ : A →+ B) : Function.Injective (coneD2 δ) := by
  intro a b h
  exact congrArg Prod.fst h

theorem coneD2_zero_iff (δ : A →+ B) (a : A) :
    coneD2 δ a = 0 ↔ a = 0 := by
  constructor
  · intro h
    exact congrArg Prod.fst h
  · rintro rfl
    simp [coneD2]

theorem coneD1_coneD2 (δ : A →+ B) (ε : B →+ C)
    (hεδ : ∀ a, ε (δ a) = 0) (a : A) :
    coneD1 δ ε (coneD2 δ a) = 0 := by
  simp [coneD1, coneD2, hεδ]

theorem coneD0_coneD1 (δ : A →+ B) (ε : B →+ C)
    (hεδ : ∀ a, ε (δ a) = 0) (x : A × B) :
    coneD0 ε (coneD1 δ ε x) = 0 := by
  simp [coneD0, coneD1, map_add, hεδ]

theorem cone_exact_one (δ : A →+ B) (ε : B →+ C)
    (hεδ : ∀ a, ε (δ a) = 0) (x : A × B) :
    coneD1 δ ε x = 0 ↔ ∃ a, coneD2 δ a = x := by
  constructor
  · intro h
    have hb : δ x.1 + x.2 = 0 := congrArg Prod.fst h
    refine ⟨x.1, Prod.ext rfl ?_⟩
    change -δ x.1 = x.2
    calc
      -δ x.1 = -δ x.1 + (δ x.1 + x.2) := by rw [hb]; simp
      _ = x.2 := by abel
  · rintro ⟨a, rfl⟩
    exact coneD1_coneD2 δ ε hεδ a

theorem cone_exact_zero (δ : A →+ B) (ε : B →+ C)
    (hεδ : ∀ a, ε (δ a) = 0) (z : B × C) :
    coneD0 ε z = 0 ↔ ∃ x, coneD1 δ ε x = z := by
  constructor
  · intro h
    refine ⟨(0, z.1), Prod.ext ?_ ?_⟩
    · simp [coneD1]
    · change -ε z.1 = z.2
      change ε z.1 + z.2 = 0 at h
      calc
        -ε z.1 = -ε z.1 + (ε z.1 + z.2) := by rw [h]; simp
        _ = z.2 := by abel
  · rintro ⟨x, rfl⟩
    exact coneD0_coneD1 δ ε hεδ x

theorem cone_augmentation_surjective (ε : B →+ C) :
    Function.Surjective (coneD0 ε) := by
  intro c
  exact ⟨(0, c), by simp [coneD0]⟩

def graphIncidence {V E : Type*} [Fintype E] [DecidableEq V]
    (source target : E → V) : (E → ℤ) →+ (V → ℤ) where
  toFun a v := ∑ e, ((if target e = v then a e else 0) -
    (if source e = v then a e else 0))
  map_zero' := by
    funext v
    simp
  map_add' a b := by
    funext v
    simp only [Pi.add_apply]
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro e _
    split_ifs <;> ring

def graphAugmentation {V : Type*} [Fintype V] : (V → ℤ) →+ ℤ where
  toFun a := ∑ v, a v
  map_zero' := by simp
  map_add' a b := by simp [Finset.sum_add_distrib]

theorem graph_augmentation_incidence {V E : Type*}
    [Fintype V] [Fintype E] [DecidableEq V]
    (source target : E → V) (a : E → ℤ) :
    graphAugmentation (graphIncidence source target a) = 0 := by
  classical
  change (∑ v, ∑ e, ((if target e = v then a e else 0) -
    (if source e = v then a e else 0))) = 0
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro e _
  rw [Finset.sum_sub_distrib]
  simp

theorem graph_cone_exact {V E : Type*}
    [Fintype V] [Fintype E] [DecidableEq V]
    (source target : E → V) :
    Function.Injective (coneD2 (graphIncidence source target)) ∧
      (∀ a, coneD1 (graphIncidence source target) graphAugmentation
        (coneD2 (graphIncidence source target) a) = 0) ∧
      (∀ x, coneD1 (graphIncidence source target) graphAugmentation x = 0 ↔
        ∃ a, coneD2 (graphIncidence source target) a = x) ∧
      (∀ z, coneD0 graphAugmentation z = 0 ↔
        ∃ x, coneD1 (graphIncidence source target) graphAugmentation x = z) ∧
      Function.Surjective (coneD0 (graphAugmentation (V := V))) := by
  have hεδ := graph_augmentation_incidence source target
  exact ⟨coneD2_injective _, coneD1_coneD2 _ _ hεδ,
    cone_exact_one _ _ hεδ, cone_exact_zero _ _ hεδ,
    cone_augmentation_surjective _⟩

theorem residual_conservation (δ : A →+ B) (push : A →+ T)
    (z z₁ z₂ : T) (q : A)
    (hclosed_in_cone : coneD2 δ q = 0)
    (hcut : z - z₁ - z₂ = push q) :
    z = z₁ + z₂ := by
  have hq : q = 0 := (coneD2_zero_iff δ q).mp hclosed_in_cone
  rw [hq, map_zero] at hcut
  calc
    z = (z - z₁ - z₂) + (z₁ + z₂) := by abel
    _ = z₁ + z₂ := by rw [hcut]; simp

theorem essential_split (δ : A →+ B) (push : A →+ T)
    (z z₁ z₂ : T) (q : A)
    (hclosed_in_cone : coneD2 δ q = 0)
    (hcut : z - z₁ - z₂ = push q)
    (hessential : z ≠ 0) :
    z₁ ≠ 0 ∨ z₂ ≠ 0 := by
  have hsum := residual_conservation δ push z z₁ z₂ q hclosed_in_cone hcut
  by_contra h
  push_neg at h
  exact hessential (by simpa [h.1, h.2] using hsum)

theorem strict_split_descent (old left right rest : ℕ)
    (h : old = left + right + rest + 2) :
    left + rest < old ∧ right + rest < old := by
  omega

end ConePicture
