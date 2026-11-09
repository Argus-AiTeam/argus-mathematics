import Mathlib

open scoped BigOperators

namespace CatalogRows

def evolve {X S : Type*} (update : ℕ → X → S → S) (initial : S) :
    ℕ → X → S
  | 0, _ => initial
  | n + 1, x => update n x (evolve update initial n x)

theorem state_support_local {X P O S : Type*}
    (support : ℕ → X → P) (observe : ℕ → X → O)
    (observation_refines : ∀ n x y,
      observe n x = observe n y → support n x = support n y)
    (next_support_refines : ∀ n x y,
      support (n + 1) x = support (n + 1) y → observe n x = observe n y)
    (update : ℕ → X → S → S) (initial : S)
    (update_local : ∀ n x y, observe n x = observe n y →
      ∀ s, update n x s = update n y s) :
    ∀ n x y, support n x = support n y →
      evolve update initial n x = evolve update initial n y := by
  intro n
  induction n with
  | zero =>
      intro x y _
      rfl
  | succ n ih =>
      intro x y h
      have ho := next_support_refines n x y h
      have hs := observation_refines n x y ho
      simp only [evolve]
      rw [ih x y hs]
      exact update_local n x y ho _

section Buckets

variable {V : Type*} [NormedAddCommGroup V]

noncomputable def bucketStep (T : ℕ) (τ : ℝ) (s : ℕ × V) (a : V) :
    ℕ × V :=
  if s.1 < T then
    if τ < ‖s.2 + a‖ then (s.1 + 1, 0) else (s.1, s.2 + a)
  else (s.1, 0)

theorem bucketStep_mono (T : ℕ) (τ : ℝ) (s : ℕ × V) (a : V) :
    s.1 ≤ (bucketStep T τ s a).1 := by
  unfold bucketStep
  split_ifs <;> simp

theorem bucketStep_bound (T : ℕ) (τ : ℝ) (s : ℕ × V) (a : V)
    (h : s.1 ≤ T) : (bucketStep T τ s a).1 ≤ T := by
  unfold bucketStep
  split_ifs <;> simp_all <;> omega

theorem bucketStep_residual (T : ℕ) (τ : ℝ) (s : ℕ × V) (a : V)
    (hτ : 0 ≤ τ) : ‖(bucketStep T τ s a).2‖ ≤ τ := by
  unfold bucketStep
  split_ifs <;> simp_all

noncomputable def bucketState {X : Type*} (T : ℕ) (τ : ℝ)
    (a : ℕ → X → V) : ℕ → X → ℕ × V :=
  evolve (fun n x s => bucketStep T τ s (a n x)) (0, 0)

theorem bucketState_mono {X : Type*} (T : ℕ) (τ : ℝ)
    (a : ℕ → X → V) (x : X) :
    Monotone (fun n => (bucketState T τ a n x).1) := by
  apply monotone_nat_of_le_succ
  intro n
  exact bucketStep_mono T τ (bucketState T τ a n x) (a n x)

theorem bucketState_bound {X : Type*} (T : ℕ) (τ : ℝ)
    (a : ℕ → X → V) (n : ℕ) (x : X) :
    (bucketState T τ a n x).1 ≤ T := by
  induction n with
  | zero => simp [bucketState, evolve]
  | succ n ih => exact bucketStep_bound T τ _ _ ih

theorem bucketState_residual {X : Type*} (T : ℕ) (τ : ℝ)
    (a : ℕ → X → V) (hτ : 0 ≤ τ) (n : ℕ) (x : X) :
    ‖(bucketState T τ a n x).2‖ ≤ τ := by
  cases n with
  | zero => simpa [bucketState, evolve] using hτ
  | succ n => exact bucketStep_residual T τ _ _ hτ

theorem bucketState_support_local {X P O : Type*}
    (support : ℕ → X → P) (observe : ℕ → X → O)
    (observation_refines : ∀ n x y,
      observe n x = observe n y → support n x = support n y)
    (next_support_refines : ∀ n x y,
      support (n + 1) x = support (n + 1) y → observe n x = observe n y)
    (T : ℕ) (τ : ℝ) (a : ℕ → X → V)
    (a_local : ∀ n x y, observe n x = observe n y → a n x = a n y) :
    ∀ n x y, support n x = support n y →
      bucketState T τ a n x = bucketState T τ a n y := by
  apply state_support_local support observe observation_refines next_support_refines
  intro n x y h s
  simp only [a_local n x y h]

theorem whole_row_bucket {X P O I : Type*}
    (support : ℕ → X → P) (observe : ℕ → X → O)
    (observation_refines : ∀ n x y,
      observe n x = observe n y → support n x = support n y)
    (next_support_refines : ∀ n x y,
      support (n + 1) x = support (n + 1) y → observe n x = observe n y)
    (T : ℕ) (τ : ℝ) (a : ℕ → X → V)
    (a_local : ∀ n x y, observe n x = observe n y → a n x = a n y)
    (round : I → ℕ) (representative : I → X) (r : I) (x : X)
    (hx : support (round r) x = support (round r) (representative r)) :
    (bucketState T τ a (round r) x).1 =
      (bucketState T τ a (round r) (representative r)).1 := by
  exact congrArg Prod.fst
    (bucketState_support_local support observe observation_refines
      next_support_refines T τ a a_local (round r) x (representative r) hx)

end Buckets

section Prefix

variable {I V : Type*} [AddCommMonoid V]

theorem completed_bucket_no_future
    (b : ℕ → ℕ) (hb : Monotone b) (time owner : I → ℕ) (f : I → V)
    (compatible : ∀ r, f r ≠ 0 → owner r = b (time r))
    (r : I) (j : ℕ) (hf : f r ≠ 0) (ho : owner r < b j) :
    time r < j := by
  by_contra ht
  have h := hb (Nat.le_of_not_gt ht)
  rw [← compatible r hf] at h
  omega

theorem completed_prefix_identity
    (rows : Finset I) (b : ℕ → ℕ) (hb : Monotone b)
    (time owner : I → ℕ) (f : I → V)
    (compatible : ∀ r ∈ rows, f r ≠ 0 → owner r = b (time r))
    (j : ℕ) :
    (∑ r ∈ rows, if time r < j then f r else 0) =
      (∑ r ∈ rows, if owner r < b j then f r else 0) +
      ∑ r ∈ rows, if time r < j ∧ owner r = b j then f r else 0 := by
  classical
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro r hr
  by_cases hf : f r = 0
  · simp [hf]
  have ho := compatible r hr hf
  by_cases ht : time r < j
  · have hle : owner r ≤ b j := by
      rw [ho]
      exact hb (Nat.le_of_lt ht)
    by_cases hk : owner r < b j
    · have hne : owner r ≠ b j := ne_of_lt hk
      simp [ht, hk, hne]
    · have he : owner r = b j := by omega
      simp [ht, hk, he]
  · have hk : ¬owner r < b j := by
      have h := hb (Nat.le_of_not_gt ht)
      rw [← ho] at h
      omega
    simp [ht, hk]

end Prefix

section Energy

variable {I K V : Type*} [Fintype K] [DecidableEq K]
    [NormedAddCommGroup V]

theorem disjoint_mask_energy
    (rows : Finset I) (owner : I → Option K) (f : I → V) (w : I → ℝ)
    (hw : ∀ r ∈ rows, 0 ≤ w r)
    (subset_bessel : ∀ s : Finset I, s ⊆ rows →
      ‖∑ r ∈ s, f r‖ ^ 2 ≤ ∑ r ∈ s, w r) :
    (∑ k : K, ‖∑ r ∈ rows.filter (fun r => owner r = some k), f r‖ ^ 2) ≤
      ∑ r ∈ rows, w r := by
  classical
  calc
    (∑ k : K, ‖∑ r ∈ rows.filter (fun r => owner r = some k), f r‖ ^ 2)
        ≤ ∑ k : K, ∑ r ∈ rows.filter (fun r => owner r = some k), w r := by
          apply Finset.sum_le_sum
          intro k _
          exact subset_bessel _ (Finset.filter_subset _ _)
    _ = ∑ r ∈ rows, ∑ k : K, if owner r = some k then w r else 0 := by
          simp_rw [Finset.sum_filter]
          rw [Finset.sum_comm]
    _ ≤ ∑ r ∈ rows, w r := by
          apply Finset.sum_le_sum
          intro r hr
          cases ho : owner r with
          | none => simpa [ho] using hw r hr
          | some k => simp [ho]

end Energy

theorem improved_constant (L : ℝ) (hL : 6 ≤ L) :
    81 + (324 / 49 : ℝ) * L ^ 2 <
      (64 / 9 : ℝ) * (9 + L ^ 2) := by
  have hsq : 36 ≤ L ^ 2 := by nlinarith
  nlinarith

end CatalogRows

#print axioms CatalogRows.state_support_local
#print axioms CatalogRows.whole_row_bucket
#print axioms CatalogRows.completed_prefix_identity
#print axioms CatalogRows.disjoint_mask_energy
#print axioms CatalogRows.improved_constant
