import Mathlib

namespace TransportedEdgeRigidity

variable {ι : Type*} [DecidableEq ι]

def transfer (a b : ι) (t : ℝ) (v : ι → ℝ) (i : ι) : ℝ :=
  v i + if i = a then t * v b else 0

theorem transfer_mono (a b : ι) (t : ℝ) (ht : 0 ≤ t)
    {v w : ι → ℝ} (h : ∀ i, v i ≤ w i) :
    ∀ i, transfer a b t v i ≤ transfer a b t w i := by
  intro i
  by_cases hi : i = a
  · simp only [transfer, if_pos hi]
    exact add_le_add (h i) (mul_le_mul_of_nonneg_left (h b) ht)
  · simpa only [transfer, if_neg hi, add_zero] using h i

theorem no_hidden_deficits
    (r : ℕ) (D U : ℕ → ι → ℝ) (a b : ℕ → ι) (t : ℕ → ℝ)
    (ht : ∀ k, k < r → 0 ≤ t k)
    (hinit : D 0 = U 0)
    (hexact : ∀ k, k < r →
      U (k + 1) = transfer (a k) (b k) (t k) (U k))
    (hactual : ∀ k, k < r → ∀ i,
      D (k + 1) i ≤ transfer (a k) (b k) (t k) (D k) i)
    (hfinal : D r = U r) :
    (∀ k, k ≤ r → D k = U k) ∧
      (∀ k, k < r →
        D (k + 1) = transfer (a k) (b k) (t k) (D k)) := by
  have dom : ∀ k, k ≤ r → ∀ i, D k i ≤ U k i := by
    intro k
    induction k with
    | zero =>
        intro _ i
        exact le_of_eq (congrFun hinit i)
    | succ k ih =>
        intro hk i
        have hkr : k < r := by omega
        calc
          D (k + 1) i ≤ transfer (a k) (b k) (t k) (D k) i :=
            hactual k hkr i
          _ ≤ transfer (a k) (b k) (t k) (U k) i :=
            transfer_mono (a k) (b k) (t k) (ht k hkr) (ih (by omega)) i
          _ = U (k + 1) i := (congrFun (hexact k hkr) i).symm
  have gapStep (k : ℕ) (hk : k < r) (i : ι) :
      U k i - D k i ≤ U (k + 1) i - D (k + 1) i := by
    have hD := hactual k hk i
    have hU := congrFun (hexact k hk) i
    have hmul := mul_nonneg (ht k hk)
      (sub_nonneg.mpr (dom k (Nat.le_of_lt hk) (b k)))
    by_cases hi : i = a k
    · simp only [transfer, if_pos hi] at hD hU
      nlinarith
    · simp only [transfer, if_neg hi, add_zero] at hD hU
      linarith
  have gapMono : ∀ m, m ≤ r → ∀ k, k ≤ m → ∀ i,
      U k i - D k i ≤ U m i - D m i := by
    intro m
    induction m with
    | zero =>
        intro _ k hk i
        have hk0 : k = 0 := by omega
        subst k
        exact le_rfl
    | succ m ih =>
        intro hm k hk i
        by_cases hkm : k ≤ m
        · exact le_trans (ih (by omega) k hkm i) (gapStep m (by omega) i)
        · have hkeq : k = m + 1 := by omega
          subst k
          exact le_rfl
  have states (k : ℕ) (hk : k ≤ r) : D k = U k := by
    funext i
    apply le_antisymm (dom k hk i)
    have hgap := gapMono r (le_refl r) k hk i
    have hend := congrFun hfinal i
    linarith
  constructor
  · exact states
  · intro k hk
    calc
      D (k + 1) = U (k + 1) := states (k + 1) (by omega)
      _ = transfer (a k) (b k) (t k) (U k) := hexact k hk
      _ = transfer (a k) (b k) (t k) (D k) := by
        rw [states k (Nat.le_of_lt hk)]

end TransportedEdgeRigidity
