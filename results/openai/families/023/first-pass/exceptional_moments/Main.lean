import Mathlib

open scoped BigOperators

namespace ExceptionalMoments

variable {I : Type*} [Fintype I] [DecidableEq I]

def weight (k : I → ℕ) (x : I → ℝ) : ℝ :=
  ∑ i, (k i : ℝ) * x i

lemma weight_one (x : I → ℝ) : weight (fun _ => 1) x = ∑ i, x i := by
  simp [weight]

lemma weight_add (k l : I → ℕ) (x : I → ℝ) :
    weight (fun i => k i + l i) x = weight k x + weight l x := by
  simp [weight, Nat.cast_add, add_mul, Finset.sum_add_distrib]

lemma weight_single (i : I) (k : ℕ) (x : I → ℝ) :
    weight (fun j => if j = i then k else 0) x = (k : ℝ) * x i := by
  classical
  simp [weight, ite_mul]

lemma weight_drop (i : I) (x : I → ℝ) :
    weight (fun j => if j = i then 0 else 1) x = (∑ j, x j) - x i := by
  classical
  calc
    _ = ∑ j, (x j - if j = i then x i else 0) := by
      apply Finset.sum_congr rfl
      intro j _
      by_cases h : j = i <;> simp [h]
    _ = _ := by simp [Finset.sum_sub_distrib]

lemma weight_defect (k : I → ℕ) (a v : I → ℝ) :
    weight k (fun i => v i - (5 / 6 : ℝ) * a i) =
      weight k v - (5 / 6 : ℝ) * weight k a := by
  unfold weight
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib, Finset.mul_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  ring

lemma nonpos_sum_zero (d : I → ℝ) (hd : ∀ i, d i ≤ 0)
    (hs : ∑ i, d i = 0) : ∀ i, d i = 0 := by
  intro i
  have hi := Finset.single_le_sum
    (fun j (_ : j ∈ (Finset.univ : Finset I)) => neg_nonneg.mpr (hd j))
    (Finset.mem_univ i)
  rw [Finset.sum_neg_distrib, hs, neg_zero] at hi
  exact le_antisymm (hd i) (by linarith)

lemma positive_short (a : I → ℝ) (ha : ∀ i, 0 ≤ a i)
    (hs : ∑ i, a i = 1) (hlt : ∀ i, a i < 1) :
    ∃ i, 0 < a i ∧ a i ≤ 1 / 2 := by
  have hex : ∃ i, 0 < a i := by
    by_contra! h
    have hn := Finset.sum_nonpos (fun i (_ : i ∈ (Finset.univ : Finset I)) => h i)
    linarith
  obtain ⟨i, hi⟩ := hex
  by_cases hsmall : a i ≤ 1 / 2
  · exact ⟨i, hi, hsmall⟩
  have hlarge : 1 / 2 < a i := lt_of_not_ge hsmall
  have herase := Finset.sum_erase_add (Finset.univ : Finset I) a (Finset.mem_univ i)
  have hrest : 0 < ∑ j ∈ (Finset.univ : Finset I).erase i, a j := by
    linarith [hlt i]
  have hexrest : ∃ j ∈ (Finset.univ : Finset I).erase i, 0 < a j := by
    by_contra! h
    have hn := Finset.sum_nonpos h
    linarith
  obtain ⟨j, hj, hjpos⟩ := hexrest
  have hjle := Finset.single_le_sum
    (fun k (_ : k ∈ (Finset.univ : Finset I).erase i) => ha k) hj
  exact ⟨j, hjpos, by linarith⟩

theorem multiple_in_uniform_interval (a : ℝ) (ha : 0 < a) (hshort : a ≤ 1 / 2) :
    ∃ k : ℕ, (7 / 5 : ℝ) ≤ (k : ℝ) * a ∧ (k : ℝ) * a < 19 / 10 := by
  let k := ⌈(7 / 5 : ℝ) / a⌉₊
  have hlo : (7 / 5 : ℝ) / a ≤ (k : ℝ) := Nat.le_ceil _
  have hhi : (k : ℝ) < (7 / 5 : ℝ) / a + 1 :=
    Nat.ceil_lt_add_one (by positivity)
  have hlo' := (div_le_iff₀ ha).mp hlo
  have hhi' := mul_lt_mul_of_pos_right hhi ha
  rw [add_mul, div_mul_cancel₀ _ (ne_of_gt ha), one_mul] at hhi'
  exact ⟨k, hlo', by linarith⟩

theorem uniform_gram_gap (z : ℝ) (hzlo : 7 / 5 ≤ z) (hzhi : z ≤ 19 / 10) :
    max (z - 2 / 3)
      ((z + max 1 (2 - 2 * z / 3) - 2 / 3) / 2) ≤
      2 * z / 3 - 1 / 30 := by
  apply max_le
  · linarith
  · by_cases h : z ≤ 3 / 2
    · rw [max_eq_right (by linarith : (1 : ℝ) ≤ 2 - 2 * z / 3)]
      linarith
    · rw [max_eq_left (by linarith : 2 - 2 * z / 3 ≤ (1 : ℝ))]
      linarith

theorem interval_gap_optimal (l u g : ℝ)
    (hwidth : 1 / 2 ≤ u - l)
    (hdiag : u + 3 * g ≤ 2) (hoff : -3 * l + 6 * g ≤ -4) :
    g ≤ 1 / 30 := by
  linarith

def MultiplicityBounds (a d : I → ℝ) (r : ℝ) : Prop :=
  ∀ k : I → ℕ, 1 / 2 ≤ weight k a → weight k a ≤ 2 →
    r ≤ 2 / 3 - 2 * weight k d

theorem extremal_forcing (a d : I → ℝ) (r : ℝ)
    (ha : ∀ i, 0 ≤ a i) (hs : ∑ i, a i = 1) (hlt : ∀ i, a i < 1)
    (hlower : 2 / 3 - 2 * (∑ i, d i) ≤ r)
    (hm : MultiplicityBounds a d r) :
    (∀ i, d i = 0) ∧ r = 2 / 3 := by
  have hnonpos (i : I) : d i ≤ 0 := by
    let k : I → ℕ := fun j => 1 + if j = i then 1 else 0
    have hka : weight k a = 1 + a i := by
      simp [k, weight_add, weight_one, weight_single, hs]
    have hkd : weight k d = (∑ j, d j) + d i := by
      simp [k, weight_add, weight_one, weight_single]
    have h := hm k (by rw [hka]; linarith [ha i])
      (by rw [hka]; linarith [hlt i])
    rw [hkd] at h
    linarith
  have hshortzero (i : I) (hi : a i ≤ 1 / 2) : d i = 0 := by
    let k : I → ℕ := fun j => if j = i then 0 else 1
    have hka : weight k a = 1 - a i := by rw [weight_drop, hs]
    have hkd : weight k d = (∑ j, d j) - d i := weight_drop i d
    have h := hm k (by rw [hka]; linarith)
      (by rw [hka]; linarith [ha i])
    rw [hkd] at h
    exact le_antisymm (hnonpos i) (by linarith)
  obtain ⟨i, hipos, hishort⟩ := positive_short a ha hs hlt
  obtain ⟨k, hklo, hkhi⟩ := multiple_in_uniform_interval (a i) hipos hishort
  have hka : weight (fun j => if j = i then k else 0) a = (k : ℝ) * a i :=
    weight_single i k a
  have hkd : weight (fun j => if j = i then k else 0) d = 0 := by
    rw [weight_single, hshortzero i hishort, mul_zero]
  have hrle := hm (fun j => if j = i then k else 0)
    (by rw [hka]; linarith) (by rw [hka]; linarith)
  rw [hkd] at hrle
  have hsle : (∑ i, d i) ≤ 0 :=
    Finset.sum_nonpos (fun i _ => hnonpos i)
  have hszero : ∑ i, d i = 0 := by linarith
  exact ⟨nonpos_sum_zero d hnonpos hszero, by linarith⟩

theorem first_endpoint_impossible (a v : I → ℝ) (r : ℝ)
    (ha : ∀ i, 0 ≤ a i) (hs : ∑ i, a i = 1) (hlt : ∀ i, a i < 1)
    (hlarge : 7 / 3 - 2 * (∑ i, v i) ≤ r)
    (hcubic : ∀ k : I → ℕ, 1 / 2 ≤ weight k a → weight k a ≤ 2 →
      r + 2 * weight k v ≤ 2 / 3 + (5 / 3 : ℝ) * weight k a)
    (hgram : ∀ (i : I) (k : ℕ),
      7 / 5 ≤ (k : ℝ) * a i → (k : ℝ) * a i ≤ 19 / 10 →
      2 * ((k : ℝ) * v i) - (k : ℝ) * a i ≤
        max ((k : ℝ) * a i - r)
          (((k : ℝ) * a i +
            max 1 (2 - 2 * ((k : ℝ) * a i) / 3) - r) / 2)) : False := by
  let d : I → ℝ := fun i => v i - (5 / 6 : ℝ) * a i
  have hdsum : (∑ i, d i) = (∑ i, v i) - 5 / 6 := by
    simp [d, Finset.sum_sub_distrib, ← Finset.mul_sum, hs]
  have hm : MultiplicityBounds a d r := by
    intro k hklo hkhi
    have h := hcubic k hklo hkhi
    rw [show weight k d = weight k v - (5 / 6 : ℝ) * weight k a from
      weight_defect k a v]
    linarith
  have hlower : 2 / 3 - 2 * (∑ i, d i) ≤ r := by
    rw [hdsum]
    linarith
  obtain ⟨hd, hr⟩ := extremal_forcing a d r ha hs hlt hlower hm
  obtain ⟨i, hipos, hishort⟩ := positive_short a ha hs hlt
  obtain ⟨k, hklo, hkhi⟩ := multiple_in_uniform_interval (a i) hipos hishort
  have hvi : v i = (5 / 6 : ℝ) * a i := by
    have h := hd i
    dsimp [d] at h
    linarith
  have hval : (k : ℝ) * v i = (5 / 6 : ℝ) * ((k : ℝ) * a i) := by
    rw [hvi]
    ring
  have hg := hgram i k hklo (le_of_lt hkhi)
  rw [hr, hval] at hg
  have hgap := uniform_gram_gap ((k : ℝ) * a i) hklo (le_of_lt hkhi)
  linarith

theorem second_endpoint_forcing (r v : ℝ)
    (hlarge : 7 / 3 - 2 * v ≤ r) (hcard : r ≤ 2 / 3)
    (hfourth : r + 4 * v ≤ 4) : r = 2 / 3 ∧ v = 5 / 6 := by
  constructor <;> linarith

lemma exists_high_value (a v : I → ℝ) (ha : ∀ i, 0 ≤ a i)
    (hs : ∑ i, a i = 1) (hv : ∀ i, v i ≤ a i)
    (hvsum : ∑ i, v i = 5 / 6) :
    ∃ i, 0 < a i ∧ (5 / 6 : ℝ) * a i ≤ v i := by
  by_contra! h
  let d : I → ℝ := fun i => v i - (5 / 6 : ℝ) * a i
  have hd (i : I) : d i ≤ 0 := by
    by_cases hi : 0 < a i
    · have hlt := h i hi
      dsimp [d]
      linarith
    · have hz : a i = 0 := by linarith [ha i]
      dsimp [d]
      rw [hz]
      simpa [hz] using hv i
  have hdsum : ∑ i, d i = 0 := by
    simp [d, Finset.sum_sub_distrib, ← Finset.mul_sum, hs, hvsum]
  have hdzero := nonpos_sum_zero d hd hdsum
  have hex : ∃ i, 0 < a i := by
    by_contra! hn
    have hsum := Finset.sum_nonpos
      (fun i (_ : i ∈ (Finset.univ : Finset I)) => hn i)
    linarith
  obtain ⟨i, hi⟩ := hex
  have hlt := h i hi
  have hz := hdzero i
  dsimp [d] at hz
  linarith

theorem ordinary_interior_gap (z : ℝ) (hlo : 1 < z) (hhi : z < 2) :
    max (4 / 3) z - 2 * z / 3 < 2 / 3 := by
  by_cases h : z ≤ 4 / 3
  · rw [max_eq_left h]
    linarith
  · rw [max_eq_right (le_of_not_ge h)]
    linarith

theorem second_endpoint_impossible (a v : I → ℝ) (r : ℝ)
    (ha : ∀ i, 0 ≤ a i) (hs : ∑ i, a i = 1) (hlt : ∀ i, a i < 1)
    (hv : ∀ i, v i ≤ a i)
    (hlarge : 7 / 3 - 2 * (∑ i, v i) ≤ r)
    (hcard : r ≤ 2 / 3) (hfourth : r + 4 * (∑ i, v i) ≤ 4)
    (hrepeat : ∀ i, 0 < a i →
      r + 2 * ((∑ j, v j) + v i) ≤
        (1 + a i) + max (4 / 3) (1 + a i)) : False := by
  obtain ⟨hr, hvsum⟩ := second_endpoint_forcing r (∑ i, v i) hlarge hcard hfourth
  obtain ⟨i, hipos, hiv⟩ := exists_high_value a v ha hs hv hvsum
  have h := hrepeat i hipos
  rw [hr, hvsum] at h
  have hgap := ordinary_interior_gap (1 + a i) (by linarith) (by linarith [hlt i])
  linarith

noncomputable def firstFullUpper (a : ℝ) : ℝ :=
  2 - a + max 1 (max (87 / 50 - a) ((2 / 3) * (1 + (87 / 50 - a))))

noncomputable def secondFullUpper (a : ℝ) : ℝ :=
  4 / 3 + 37 / 50 + 2 * (1 - a)

theorem dominant_full_first (a : ℝ) (hlo : 19 / 20 ≤ a) (hhi : a ≤ 1) :
    firstFullUpper a ≤ 7 / 3 - 9 / 100 := by
  unfold firstFullUpper
  rw [max_eq_right (by linarith :
    87 / 50 - a ≤ (2 / 3 : ℝ) * (1 + (87 / 50 - a)))]
  rw [max_eq_right (by linarith :
    (1 : ℝ) ≤ (2 / 3 : ℝ) * (1 + (87 / 50 - a)))]
  linarith

theorem dominant_full_second (a : ℝ) (hlo : 19 / 20 ≤ a) :
    secondFullUpper a ≤ 7 / 3 - 4 / 25 := by
  unfold secondFullUpper
  linarith

theorem first_endpoint_universal (a v : I → ℝ) (r : ℝ)
    (ha : ∀ i, 0 ≤ a i) (hs : ∑ i, a i = 1)
    (hlarge : 7 / 3 - 2 * (∑ i, v i) ≤ r)
    (hfull : ∀ i, a i = 1 → 7 / 3 ≤ firstFullUpper (a i))
    (hcubic : ∀ k : I → ℕ, 1 / 2 ≤ weight k a → weight k a ≤ 2 →
      r + 2 * weight k v ≤ 2 / 3 + (5 / 3 : ℝ) * weight k a)
    (hgram : ∀ (i : I) (k : ℕ),
      7 / 5 ≤ (k : ℝ) * a i → (k : ℝ) * a i ≤ 19 / 10 →
      2 * ((k : ℝ) * v i) - (k : ℝ) * a i ≤
        max ((k : ℝ) * a i - r)
          (((k : ℝ) * a i +
            max 1 (2 - 2 * ((k : ℝ) * a i) / 3) - r) / 2)) : False := by
  have hlt (i : I) : a i < 1 := by
    have hle := Finset.single_le_sum
      (fun j (_ : j ∈ (Finset.univ : Finset I)) => ha j) (Finset.mem_univ i)
    rw [hs] at hle
    by_contra h
    have heq : a i = 1 := le_antisymm hle (le_of_not_gt h)
    have hf := hfull i heq
    have hg := dominant_full_first (a i) (by rw [heq]; norm_num) hle
    linarith
  exact first_endpoint_impossible a v r ha hs hlt hlarge hcubic hgram

theorem second_endpoint_universal (a v : I → ℝ) (r : ℝ)
    (ha : ∀ i, 0 ≤ a i) (hs : ∑ i, a i = 1) (hv : ∀ i, v i ≤ a i)
    (hlarge : 7 / 3 - 2 * (∑ i, v i) ≤ r)
    (hfull : ∀ i, a i = 1 → 7 / 3 ≤ secondFullUpper (a i))
    (hcard : r ≤ 2 / 3) (hfourth : r + 4 * (∑ i, v i) ≤ 4)
    (hrepeat : ∀ i, 0 < a i →
      r + 2 * ((∑ j, v j) + v i) ≤
        (1 + a i) + max (4 / 3) (1 + a i)) : False := by
  have hlt (i : I) : a i < 1 := by
    have hle := Finset.single_le_sum
      (fun j (_ : j ∈ (Finset.univ : Finset I)) => ha j) (Finset.mem_univ i)
    rw [hs] at hle
    by_contra h
    have heq : a i = 1 := le_antisymm hle (le_of_not_gt h)
    have hf := hfull i heq
    have hg := dominant_full_second (a i) (by rw [heq]; norm_num)
    linarith
  exact second_endpoint_impossible a v r ha hs hlt hv hlarge hcard hfourth hrepeat

end ExceptionalMoments

#print axioms ExceptionalMoments.first_endpoint_universal
#print axioms ExceptionalMoments.second_endpoint_universal
#print axioms ExceptionalMoments.uniform_gram_gap
