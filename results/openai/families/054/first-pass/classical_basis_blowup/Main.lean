import Mathlib

namespace BlowupReconstruction

def positiveCount : List Nat → Nat
  | [] => 0
  | a :: xs => (if a = 0 then 0 else 1) + positiveCount xs

theorem positiveCount_le_sum (xs : List Nat) :
    positiveCount xs ≤ xs.sum := by
  induction xs with
  | nil => simp [positiveCount]
  | cons a xs ih =>
      simp only [positiveCount, List.sum_cons]
      split_ifs <;> omega

theorem positiveCount_lt_of_merge (xs : List Nat)
    (h : ∃ a ∈ xs, 1 < a) : positiveCount xs < xs.sum := by
  induction xs with
  | nil => simp at h
  | cons a xs ih =>
      rcases h with ⟨b, hb, hbig⟩
      simp only [List.mem_cons] at hb
      rcases hb with hba | hb
      · subst b
        have hrest := positiveCount_le_sum xs
        have ha : a ≠ 0 := by omega
        simp only [positiveCount, if_neg ha, List.sum_cons]
        omega
      · have hrest := ih ⟨b, hb, hbig⟩
        simp only [positiveCount, List.sum_cons]
        split_ifs <;> omega

theorem positiveCount_rigidity (xs : List Nat)
    (h : positiveCount xs = xs.sum) : ∀ a ∈ xs, a ≤ 1 := by
  intro a ha
  by_contra hbig
  have hlt := positiveCount_lt_of_merge xs ⟨a, ha, by omega⟩
  omega

theorem length_le_sum_of_positive (xs : List Nat)
    (h : ∀ a ∈ xs, 0 < a) : xs.length ≤ xs.sum := by
  induction xs with
  | nil => simp
  | cons a xs ih =>
      have ha := h a (by simp)
      have ht : ∀ b ∈ xs, 0 < b := by
        intro b hb
        exact h b (by simp [hb])
      have hl := ih ht
      simp only [List.length_cons, List.sum_cons]
      omega

theorem restricted_contact (r k kp b : Nat)
    (hr : 0 < r) (hb : b < r)
    (hc : 0 ≤ (r : Int) * k - (r : Int) * kp + b) : kp ≤ k := by
  by_contra h
  have hkp : (k : Int) + 1 ≤ kp := by omega
  have hr' : (0 : Int) < r := by omega
  have hb' : (b : Int) < r := by omega
  nlinarith

theorem restricted_empty_tail (r kp : Nat) (hr : 2 ≤ r) (hk : 0 < kp) :
    1 - (r : Int) * kp < 0 := by
  have hr' : (2 : Int) ≤ r := by omega
  have hk' : (1 : Int) ≤ kp := by omega
  nlinarith

def divisorCodim (tail : List Nat × Nat) : Int :=
  (tail.1.sum : Int) - tail.1.length - tail.2 + 1

def inputContact (tails : List (List Nat × Nat)) : Nat :=
  (tails.map fun tail => tail.1.sum).sum

def inputLength (tails : List (List Nat × Nat)) : Nat :=
  (tails.map fun tail => tail.1.length).sum

def outputContact (tails : List (List Nat × Nat)) : Nat :=
  (tails.map fun tail => tail.2).sum

theorem divisor_balance (tails : List (List Nat × Nat)) :
    (tails.map divisorCodim).sum =
      (inputContact tails : Int) - inputLength tails -
        outputContact tails + tails.length := by
  induction tails with
  | nil => simp [inputContact, inputLength, outputContact]
  | cons tail tails ih =>
      simp only [List.map_cons, List.sum_cons, List.length_cons]
      simp only [inputContact, inputLength, outputContact, List.map_cons,
        List.sum_cons] at *
      simp only [Nat.cast_add, Nat.cast_one]
      unfold divisorCodim at *
      omega

theorem divisor_length_order (tails : List (List Nat × Nat))
    (hcontact : inputContact tails = outputContact tails)
    (hnonneg : 0 ≤ (tails.map divisorCodim).sum) :
    inputLength tails ≤ tails.length := by
  have hbalance := divisor_balance tails
  omega

theorem empty_divisor_tail (kp : Nat) (hk : 0 < kp)
    (hc : 0 ≤ divisorCodim ([], kp)) : kp = 1 := by
  simp [divisorCodim] at hc
  omega

def divisorMeasure (K L p : Nat) : Nat := (K - L) * (K + 1) + p

theorem divisor_measure_lt (K L t p pp : Nat)
    (hL : L ≤ K) (ht : t ≤ K) (hpp : pp ≤ t)
    (h : L < t ∨ (L = t ∧ pp < p)) :
    divisorMeasure K t pp < divisorMeasure K L p := by
  rcases h with hlength | ⟨rfl, hcount⟩
  · have hstep : K - t + 1 ≤ K - L := by omega
    have hmul := Nat.mul_le_mul_right (K + 1) hstep
    unfold divisorMeasure
    nlinarith
  · exact Nat.add_lt_add_left hcount _

def fibreCoefficient (r k j : Nat) : Rat :=
  1 / ((k : Rat) ^ (r - j) * (Nat.factorial (k - 1) : Rat) ^ r)

theorem fibreCoefficient_pos (r k j : Nat) (hk : 0 < k) :
    0 < fibreCoefficient r k j := by
  have hk' : (0 : Rat) < k := by exact_mod_cast hk
  have hf : (0 : Rat) < Nat.factorial (k - 1) := by
    exact_mod_cast Nat.factorial_pos (k - 1)
  unfold fibreCoefficient
  positivity

theorem labelled_tail_coefficient_pos (r k j m : Nat) (hk : 0 < k) :
    0 < (k : Rat) ^ (m + 1) * fibreCoefficient r k j := by
  have hk' : (0 : Rat) < k := by exact_mod_cast hk
  exact mul_pos (pow_pos hk' _) (fibreCoefficient_pos r k j hk)

theorem tensor_recover {V : Type*} [AddCommGroup V] [Module Rat V]
    (S : Submodule Rat V) (A B R : V) (c : Rat) (hc : c ≠ 0)
    (h : A = c • B + R) (hA : A ∈ S) (hR : R ∈ S) : B ∈ S := by
  have hscaled : c • B ∈ S := by
    simpa [h] using S.sub_mem hA hR
  have hdivided := S.smul_mem c⁻¹ hscaled
  simpa [smul_smul, hc] using hdivided

end BlowupReconstruction
