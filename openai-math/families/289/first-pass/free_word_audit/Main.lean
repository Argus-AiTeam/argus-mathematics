import Mathlib

noncomputable section

open scoped BigOperators

namespace FreeWordAudit

variable {α : Type*}

theorem missing_left_unique {A A' B W : Multiset α} {a : α}
    (h : A + B + {a} = W) (h' : A' + B + {a} = W) : A = A' := by
  exact add_right_cancel (add_right_cancel (h.trans h'.symm))

theorem missing_right_unique {A B B' W : Multiset α} {a : α}
    (h : A + B + {a} = W) (h' : A + B' + {a} = W) : B = B' := by
  exact add_left_cancel (add_right_cancel (h.trans h'.symm))

theorem missing_label_unique {A B W : Multiset α} {a b : α}
    (h : A + B + {a} = W) (h' : A + B + {b} = W) : a = b := by
  have hs : ({a} : Multiset α) = {b} := add_left_cancel (h.trans h'.symm)
  simpa using hs

theorem missing_energy_le [DecidableEq α]
    (W : Multiset α)
    (s : Finset (Multiset α × (Multiset α × α)))
    (I : Finset (Multiset α × α))
    (hs : ∀ e ∈ s, e.1 + e.2.1 + {e.2.2} = W)
    (hI : ∀ e ∈ s, e.2 ∈ I)
    (w : (Multiset α × α) → ℝ)
    (hw : ∀ i ∈ I, 0 ≤ w i) :
    (∑ e ∈ s, w e.2) ≤ ∑ i ∈ I, w i := by
  classical
  have hinj : Set.InjOn
      (fun e : Multiset α × (Multiset α × α) => e.2) s := by
    intro e he f hf h
    have hB : e.2.1 = f.2.1 := congrArg Prod.fst h
    have ha : e.2.2 = f.2.2 := congrArg Prod.snd h
    have hfe : f.1 + e.2.1 + {e.2.2} = W := by
      simpa only [hB, ha] using hs f hf
    exact Prod.ext (missing_left_unique (hs e he) hfe) h
  calc
    (∑ e ∈ s, w e.2) =
        ∑ i ∈ s.image (fun e => e.2), w i := by
      symm
      exact Finset.sum_image hinj
    _ ≤ ∑ i ∈ I, w i := by
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro i hi
        obtain ⟨e, he, rfl⟩ := Finset.mem_image.mp hi
        exact hI e he
      · intro i hi _
        exact hw i hi

theorem all_ones_energy_bound (m n : ℕ) (x : Fin n → ℝ) :
    (m : ℝ) * (∑ j, x j) ^ 2 ≤
      (m : ℝ) * (n : ℝ) * (∑ j, (x j) ^ 2) := by
  have h := Finset.sum_mul_sq_le_sq_mul_sq
    (Finset.univ : Finset (Fin n)) x (fun _ => (1 : ℝ))
  have hc : (∑ j, x j) ^ 2 ≤ (n : ℝ) * (∑ j, (x j) ^ 2) := by
    simpa [mul_comm] using h
  calc
    (m : ℝ) * (∑ j, x j) ^ 2 ≤
        (m : ℝ) * ((n : ℝ) * (∑ j, (x j) ^ 2)) :=
      mul_le_mul_of_nonneg_left hc (Nat.cast_nonneg m)
    _ = _ := by ring

theorem all_ones_constant_attains (m n : ℕ) (c : ℝ) :
    (m : ℝ) * (∑ _j : Fin n, c) ^ 2 =
      (m : ℝ) * (n : ℝ) * (∑ _j : Fin n, c ^ 2) := by
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  ring

theorem middle_tail_algebra (m : ℝ) (hm : 5 ≤ m) :
    (m - 3) ^ 2 ≤ (m - 1) * (m - 4) := by
  nlinarith

theorem weighted_cauchy_identity (u v : ℝ) :
    3 * (u ^ 2 + v ^ 2 / 2) - (u + v) ^ 2 =
      (2 * u - v) ^ 2 / 2 := by
  ring

theorem scalar_tail_lt_two (u v : ℝ)
    (h : u ^ 2 + v ^ 2 / 2 ≤ 1) : u + v < 2 := by
  have hs := sq_nonneg (2 * u - v)
  have ht := sq_nonneg (u + v - 2)
  nlinarith

theorem product_step (s x : ℝ) (hs : 0 ≤ s) (hx : 0 ≤ x) :
    (1 + x) * (1 - s - x) ≤ 1 - s := by
  nlinarith [mul_nonneg hs hx, sq_nonneg x]

theorem product_defect_bound {ι : Type*} (s : Finset ι) (x : ι → ℝ) :
    (∀ i ∈ s, 0 ≤ x i) →
      (∏ i ∈ s, (1 + x i)) * (1 - ∑ i ∈ s, x i) ≤ 1 := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
      intro hx
      have hxa : 0 ≤ x a := hx a (by simp)
      have hxs : ∀ i ∈ s, 0 ≤ x i := by
        intro i hi
        exact hx i (by simp [hi])
      have hsum : 0 ≤ ∑ i ∈ s, x i := Finset.sum_nonneg hxs
      have hprod : 0 ≤ ∏ i ∈ s, (1 + x i) :=
        Finset.prod_nonneg (by
          intro i hi
          linarith [hxs i hi])
      have hstep := product_step (∑ i ∈ s, x i) (x a) hsum hxa
      rw [Finset.prod_insert ha, Finset.sum_insert ha]
      calc
        (1 + x a) * (∏ i ∈ s, (1 + x i)) *
            (1 - (x a + ∑ i ∈ s, x i)) =
            (∏ i ∈ s, (1 + x i)) *
              ((1 + x a) * (1 - (∑ i ∈ s, x i) - x a)) := by ring
        _ ≤ (∏ i ∈ s, (1 + x i)) * (1 - ∑ i ∈ s, x i) :=
          mul_le_mul_of_nonneg_left hstep hprod
        _ ≤ 1 := ih hxs

theorem through_twenty_six (P s : ℝ) (hP : 0 ≤ P)
    (hs : s ≤ 1 / 26) (h : P * (1 - s) ≤ 1) : 25 * P ≤ 26 := by
  have hm : 0 ≤ P * (1 / 26 - s) := mul_nonneg hP (by linarith)
  nlinarith

end FreeWordAudit
