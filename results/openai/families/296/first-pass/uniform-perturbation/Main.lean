import Mathlib

noncomputable section

open scoped BigOperators

namespace UniformPerturbation

def gPrefix : ℕ → FreeGroup ℕ
  | 0 => 1
  | n + 1 => gPrefix n * FreeGroup.of n

def label (k j : ℕ) : FreeGroup ℕ := gPrefix k * (gPrefix j)⁻¹

def moments : FreeGroup ℕ →* Multiplicative (ℤ × ℤ) :=
  FreeGroup.lift fun n => Multiplicative.ofAdd (1, 2 * (n : ℤ) + 1)

theorem prefix_moments (n : ℕ) :
    (moments (gPrefix n)).toAdd = ((n : ℤ), (n : ℤ) ^ 2) := by
  induction n with
  | zero => simp [gPrefix, moments]; rfl
  | succ n ih =>
      rw [gPrefix, map_mul, toAdd_mul, ih]
      have hgen : (moments (FreeGroup.of n)).toAdd = (1, 2 * (n : ℤ) + 1) := by
        simp [moments]
      rw [hgen]
      ext <;> simp [Nat.cast_add] <;> ring

theorem label_moments (k j : ℕ) :
    (moments (label k j)).toAdd =
      ((k : ℤ) - (j : ℤ), (k : ℤ) ^ 2 - (j : ℤ) ^ 2) := by
  simp [label, prefix_moments, sub_eq_add_neg]

theorem label_eq_iff (k j a b : ℕ) :
    label k j = label a b ↔ (k = j ∧ a = b) ∨ (k = a ∧ j = b) := by
  constructor
  · intro h
    have hm := congrArg (fun x => (moments x).toAdd) h
    rw [label_moments, label_moments] at hm
    have h₁ := congrArg Prod.fst hm
    have h₂ := congrArg Prod.snd hm
    dsimp only at h₁ h₂
    by_cases hkj : k = j
    · left
      constructor
      · exact hkj
      · omega
    · right
      have hne : (k : ℤ) - j ≠ 0 := by omega
      have hp : ((k : ℤ) - j) * ((k : ℤ) + j - a - b) = 0 := by
        nlinarith
      have hs : (k : ℤ) + j - a - b = 0 :=
        (mul_eq_zero.mp hp).resolve_left hne
      constructor <;> omega
  · rintro (⟨rfl, rfl⟩ | ⟨rfl, rfl⟩) <;> simp [label]

theorem label_eq_one_iff (k j : ℕ) : label k j = 1 ↔ k = j := by
  constructor
  · intro h
    have hh : label k j = label 0 0 := by simpa [label] using h
    rcases (label_eq_iff k j 0 0).mp hh with h | h
    · exact h.1
    · omega
  · rintro rfl
    simp [label]

theorem finite_label_eq_iff {n : ℕ} (k j a b : Fin n) :
    label (k.val + 1) (j.val + 1) = label (a.val + 1) (b.val + 1) ↔
      (k = j ∧ a = b) ∨ (k = a ∧ j = b) := by
  rw [label_eq_iff]
  simp only [Nat.add_right_cancel_iff, Fin.val_inj]

def collisionEnergy (n : ℕ) : ℕ :=
  ∑ k : Fin n, ∑ j : Fin n, ∑ a : Fin n, ∑ b : Fin n,
    if label (k.val + 1) (j.val + 1) = label (a.val + 1) (b.val + 1)
      then 1 else 0

theorem collision_energy (n : ℕ) : collisionEnergy n = 2 * n ^ 2 - n := by
  have pairCount (k j : Fin n) :
      (∑ a : Fin n, ∑ b : Fin n,
        if label (k.val + 1) (j.val + 1) = label (a.val + 1) (b.val + 1)
          then 1 else 0) = if k = j then n else 1 := by
    by_cases h : k = j
    · subst j
      have hd (a b : Fin n) :
          label (k.val + 1) (k.val + 1) = label (a.val + 1) (b.val + 1) ↔
            a = b := by
        rw [finite_label_eq_iff]
        aesop
      simp_rw [hd]
      simp
    · have hn (a b : Fin n) :
          label (k.val + 1) (j.val + 1) = label (a.val + 1) (b.val + 1) ↔
            k = a ∧ j = b := by
        simp [finite_label_eq_iff, h]
      simp_rw [hn, ite_and]
      simp [h]
  simp only [collisionEnergy, pairCount]
  cases n with
  | zero => simp
  | succ n =>
      have rowCount (k : Fin (n + 1)) :
          (∑ j : Fin (n + 1), if k = j then n + 1 else 1) = 2 * n + 1 := by
        have he (j : Fin (n + 1)) :
            (if k = j then n + 1 else 1) = (if k = j then n else 0) + 1 := by
          split_ifs <;> omega
        simp_rw [he, Finset.sum_add_distrib]
        simp
        omega
      simp_rw [rowCount]
      simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul]
      have hpoly : (n + 1) * (2 * n + 1) + (n + 1) = 2 * (n + 1) ^ 2 := by ring
      omega

section PrefixOrientation

variable {G : Type*} [Group G]

def conjugates (a q : G) : List G → List G
  | [] => []
  | x :: xs => (a * q * a⁻¹) :: conjugates (a * x) q xs

theorem prefix_factorization (a q : G) (xs : List G) :
    a * (xs.map (fun x => q * x)).prod =
      (conjugates a q xs).prod * (a * xs.prod) := by
  induction xs generalizing a with
  | nil => simp [conjugates]
  | cons x xs ih =>
      simp only [List.map_cons, List.prod_cons, conjugates]
      calc
        a * (q * x * (xs.map (fun x => q * x)).prod) =
            (a * q * a⁻¹) * ((a * x) *
              (xs.map (fun x => q * x)).prod) := by group
        _ = (a * q * a⁻¹) * ((conjugates (a * x) q xs).prod *
              (a * x * xs.prod)) := by rw [ih]
        _ = _ := by group

end PrefixOrientation

section NoncommutativeExpansion

variable {I G : Type*} [Fintype I] [Group G]

def word {d : ℕ} (atom : I → G) (q : Fin d → I) : G :=
  (List.ofFn fun i => atom (q i)).prod

def positiveTotal (atom : I → G) (a : I → ℝ) : MonoidAlgebra ℝ G :=
  ∑ i, MonoidAlgebra.single (atom i) (a i)

theorem group_ring_expansion (atom : I → G) (a : I → ℝ) (d : ℕ) :
    positiveTotal atom a ^ d =
      ∑ q : Fin d → I, MonoidAlgebra.single (word atom q) (∏ i, a (q i)) := by
  classical
  induction d with
  | zero => simp [word, MonoidAlgebra.one_def]
  | succ d ih =>
      rw [pow_succ', ih, positiveTotal, Finset.sum_mul_sum]
      rw [← (Fin.consEquiv (fun _ : Fin (d + 1) => I)).sum_comp]
      rw [Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro i hi
      apply Finset.sum_congr rfl
      intro q hq
      simp [Fin.consEquiv, word, List.ofFn_succ,
        Fin.prod_univ_succ, MonoidAlgebra.single_mul_single]

def filteredCoefficient {d : ℕ} (atom : I → G) (b : I → ℝ)
    (P : (Fin d → I) → Prop) (D : (Fin d → I) → ℕ) (w : G) : ℝ := by
  classical
  exact ∑ q : Fin d → I,
    if P q ∧ word atom q = w then (∏ i, b (q i)) / (D q : ℝ) else 0

theorem coefficient_majorization {d : ℕ} (atom : I → G) (a b : I → ℝ)
    (ha : ∀ i, 0 ≤ a i) (hb : ∀ i, |b i| ≤ a i)
    (P : (Fin d → I) → Prop) (D : (Fin d → I) → ℕ)
    (hD : ∀ q, 1 ≤ D q) (w : G) :
    |filteredCoefficient atom b P D w| ≤ (positiveTotal atom a ^ d) w := by
  classical
  rw [filteredCoefficient, group_ring_expansion]
  change |∑ q : Fin d → I,
    if P q ∧ word atom q = w then (∏ i, b (q i)) / (D q : ℝ) else 0| ≤
      (∑ q : Fin d → I,
        MonoidAlgebra.single (word atom q) (∏ i, a (q i)) : G →₀ ℝ) w
  simp only [Finsupp.finsetSum_apply, MonoidAlgebra.single_apply]
  apply (Finset.abs_sum_le_sum_abs _ _).trans
  apply Finset.sum_le_sum
  intro q hq
  have hprod : 0 ≤ ∏ i : Fin d, a (q i) := Finset.prod_nonneg fun _ _ => ha _
  have habs : |∏ i : Fin d, b (q i)| ≤ ∏ i : Fin d, a (q i) := by
    rw [Finset.abs_prod]
    exact Finset.prod_le_prod (fun _ _ => abs_nonneg _) (fun _ _ => hb _)
  have hden : (1 : ℝ) ≤ D q := by exact_mod_cast hD q
  by_cases hw : word atom q = w
  · simp only [hw, ite_true, and_true]
    by_cases hp : P q
    · simp only [hp, ite_true, abs_div, abs_of_nonneg (by positivity : 0 ≤ (D q : ℝ))]
      exact (div_le_div_of_nonneg_right habs (by positivity)).trans
        (div_le_self hprod hden)
    · simpa [hp] using hprod
  · simp [hw]

end NoncommutativeExpansion

abbrev Token (n : ℕ) := Fin n × Fin n × Bool

def tokenLabel {n : ℕ} (t : Token n) : FreeGroup ℕ :=
  label (t.1.val + 1) (t.2.1.val + 1)

def tokenAtom {n : ℕ} (t : Token n) : FreeGroup (FreeGroup ℕ) :=
  if t.2.2 then FreeGroup.of (tokenLabel t) else (FreeGroup.of (tokenLabel t))⁻¹

def signedWeight {n : ℕ} (c : ℝ) (t : Token n) : ℝ :=
  if t.2.2 then c else -c

def rowFactorial {n d : ℕ} (q : Fin d → Token n) : ℕ :=
  ∏ k : Fin n, (Finset.univ.filter fun i : Fin d => (q i).1 = k).card.factorial

theorem rowFactorial_pos {n d : ℕ} (q : Fin d → Token n) : 1 ≤ rowFactorial q := by
  apply Nat.succ_le_of_lt
  exact Finset.prod_pos fun _ _ => Nat.factorial_pos _

def orderedCoefficient (n d : ℕ) (c : ℝ) (w : FreeGroup (FreeGroup ℕ)) : ℝ :=
  filteredCoefficient tokenAtom (signedWeight c)
    (fun q : Fin d → Token n => Monotone fun i => (q i).1) rowFactorial w

def majorant (n : ℕ) (c : ℝ) : MonoidAlgebra ℝ (FreeGroup (FreeGroup ℕ)) :=
  positiveTotal (tokenAtom (n := n)) (fun _ => c)

theorem all_degree_majorization (n d : ℕ) (c : ℝ) (hc : 0 ≤ c)
    (w : FreeGroup (FreeGroup ℕ)) :
    |orderedCoefficient n d c w| ≤ (majorant n c ^ d) w := by
  apply coefficient_majorization
  · exact fun _ => hc
  · intro t
    cases h : t.2.2 <;> simp [signedWeight, h, abs_of_nonneg hc]
  · exact rowFactorial_pos

theorem identity_label_is_a_generator :
    (FreeGroup.of (1 : FreeGroup ℕ) : FreeGroup (FreeGroup ℕ)) ≠ 1 := by
  intro h
  have hh := congrArg (FreeGroup.lift (fun _ : FreeGroup ℕ =>
    Multiplicative.ofAdd (1 : ℤ))) h
  norm_num at hh

end UniformPerturbation
