import Mathlib

namespace ProfiniteRigidity

-- n is one less than the lattice rank.
def lattice (p : ℕ) : ℕ → ℕ → ℤ
  | 0, _ => 1
  | n + 1, j =>
      ∑ k ∈ Finset.range (j + 1), (p : ℤ) ^ ((n + 1) * k) * lattice p n (j - k)

def denominator (p : ℕ) : ℕ → ℤ
  | 0 => 1
  | n + 1 => (1 - (p : ℤ) ^ (n + 1)) * denominator p n

def denominatorInverse (p : ℕ) : ℕ → ℕ → ℤ
  | 0, _ => 1
  | n + 1, k =>
      (∑ j ∈ Finset.range k, ((p : ℤ) ^ (n + 1)) ^ j) *
        denominatorInverse p n k

def graphCount (p n b h : ℕ) (s : ℕ → ℤ) : ℤ :=
  ∑ i ∈ Finset.range (b + 1), s i * lattice p n (h - i)

theorem power_dvd {p a b : ℕ} (hab : a ≤ b) :
    (p : ℤ) ^ a ∣ (p : ℤ) ^ b :=
  pow_dvd_pow _ hab

theorem geometric (q : ℤ) (m : ℕ) :
    (1 - q) * (∑ k ∈ Finset.range m, q ^ k) = 1 - q ^ m := by
  induction m with
  | zero => simp
  | succ m ih =>
      rw [Finset.sum_range_succ, mul_add, ih, pow_succ]
      ring

theorem lattice_stabilization (p n j : ℕ) :
    (p : ℤ) ^ (j + 1) ∣ denominator p n * lattice p n j - 1 := by
  induction n generalizing j with
  | zero => simp [denominator, lattice]
  | succ n ih =>
      let S : ℤ := ∑ k ∈ Finset.range (j + 1), (p : ℤ) ^ ((n + 1) * k)
      have hsum : (p : ℤ) ^ (j + 1) ∣
          denominator p n * lattice p (n + 1) j - S := by
        have heq : denominator p n * lattice p (n + 1) j - S =
            ∑ k ∈ Finset.range (j + 1),
              (p : ℤ) ^ ((n + 1) * k) *
                (denominator p n * lattice p n (j - k) - 1) := by
          simp only [lattice, S, Finset.mul_sum, ← Finset.sum_sub_distrib]
          apply Finset.sum_congr rfl
          intro k hk
          ring
        rw [heq]
        apply Finset.dvd_sum
        intro k hk
        have hkj : k ≤ j := by simpa using Finset.mem_range.mp hk
        have hexp : j + 1 ≤ (n + 1) * k + (j - k + 1) := by
          simp only [Nat.add_mul, one_mul]
          omega
        apply dvd_trans (power_dvd hexp)
        rw [pow_add]
        exact mul_dvd_mul_left _ (ih (j - k))
      have hgeom : (p : ℤ) ^ (j + 1) ∣
          (1 - (p : ℤ) ^ (n + 1)) * S - 1 := by
        have hs : S = ∑ k ∈ Finset.range (j + 1),
            ((p : ℤ) ^ (n + 1)) ^ k := by
          simp only [S, pow_mul]
        rw [hs, geometric]
        have he : j + 1 ≤ (n + 1) * (j + 1) := by
          simp only [Nat.add_mul, one_mul]
          omega
        simpa only [sub_sub_cancel_left, ← pow_mul, dvd_neg] using power_dvd (p := p) he
      have heq : denominator p (n + 1) * lattice p (n + 1) j - 1 =
          (1 - (p : ℤ) ^ (n + 1)) *
            (denominator p n * lattice p (n + 1) j - S) +
            ((1 - (p : ℤ) ^ (n + 1)) * S - 1) := by
        simp only [denominator]
        ring
      rw [heq]
      exact dvd_add (dvd_mul_of_dvd_right hsum _) hgeom

theorem denominator_inverse (p n k : ℕ) :
    (p : ℤ) ^ k ∣ denominator p n * denominatorInverse p n k - 1 := by
  induction n with
  | zero => simp [denominator, denominatorInverse]
  | succ n ih =>
      let T : ℤ := ∑ j ∈ Finset.range k, ((p : ℤ) ^ (n + 1)) ^ j
      have hgeom : (p : ℤ) ^ k ∣ (1 - (p : ℤ) ^ (n + 1)) * T - 1 := by
        dsimp [T]
        rw [geometric]
        have he : k ≤ (n + 1) * k := by
          simp only [Nat.add_mul, one_mul]
          omega
        simpa only [sub_sub_cancel_left, ← pow_mul, dvd_neg] using power_dvd (p := p) he
      have heq : denominator p (n + 1) * denominatorInverse p (n + 1) k - 1 =
          ((1 - (p : ℤ) ^ (n + 1)) * T) *
            (denominator p n * denominatorInverse p n k - 1) +
            ((1 - (p : ℤ) ^ (n + 1)) * T - 1) := by
        simp only [denominator, denominatorInverse, T]
        ring
      rw [heq]
      exact dvd_add (dvd_mul_of_dvd_right ih _) hgeom

theorem cancel_denominator (p n k : ℕ) (c : ℤ)
    (hc : (p : ℤ) ^ k ∣ denominator p n * c) :
    (p : ℤ) ^ k ∣ c := by
  have h₁ := dvd_mul_of_dvd_right hc (denominatorInverse p n k)
  have h₂ := dvd_mul_of_dvd_right (denominator_inverse p n k) c
  have heq : denominatorInverse p n k * (denominator p n * c) -
      c * (denominator p n * denominatorInverse p n k - 1) = c := by ring
  have ht := dvd_sub h₁ h₂
  rwa [heq] at ht

theorem weighted_stabilization (p n b h : ℕ) (s : ℕ → ℤ) (hbh : b ≤ h) :
    (p : ℤ) ^ (h - b + 1) ∣
      denominator p n * graphCount p n b h s -
        ∑ i ∈ Finset.range (b + 1), s i := by
  unfold graphCount
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
  apply Finset.dvd_sum
  intro i hi
  have hib : i ≤ b := by simpa using Finset.mem_range.mp hi
  have hexp : h - b + 1 ≤ h - i + 1 := by omega
  have hdiv := dvd_trans (power_dvd (p := p) hexp) (lattice_stabilization p n (h - i))
  convert dvd_mul_of_dvd_left hdiv (s i) using 1
  ring

theorem no_next_power (p k : ℕ) (hp : 2 ≤ p) :
    ¬ (p : ℤ) ^ (k + 1) ∣ (p : ℤ) ^ k := by
  intro h
  have hpos : 0 < (p : ℤ) ^ k := pow_pos (by omega) _
  have hle := Int.le_of_dvd hpos h
  rw [pow_succ] at hle
  have hpz : (2 : ℤ) ≤ p := by exact_mod_cast hp
  nlinarith

theorem scaled_obstruction (p B r : ℕ) (D c : ℤ) (hp : 2 ≤ p)
    (hc : (p : ℤ) ^ (B + 1) ∣ D * c - (p : ℤ) ^ B) :
    ¬ (p : ℤ) ^ (B + r + 1) ∣ (p : ℤ) ^ r * c := by
  intro h
  have herr : (p : ℤ) ^ (B + r + 1) ∣
      (p : ℤ) ^ r * (D * c - (p : ℤ) ^ B) := by
    have ht := mul_dvd_mul_left ((p : ℤ) ^ r) hc
    have he : r + (B + 1) = B + r + 1 := by omega
    simpa only [← pow_add, he] using ht
  have hmain : (p : ℤ) ^ (B + r + 1) ∣ D * ((p : ℤ) ^ r * c) :=
    dvd_mul_of_dvd_right h D
  have hpower : (p : ℤ) ^ (B + r + 1) ∣ (p : ℤ) ^ (B + r) := by
    have ht := dvd_sub hmain herr
    have heq : D * ((p : ℤ) ^ r * c) -
        (p : ℤ) ^ r * (D * c - (p : ℤ) ^ B) = (p : ℤ) ^ (B + r) := by
      rw [pow_add]
      ring
    rwa [heq] at ht
  exact no_next_power p (B + r) hp hpower

theorem effective_power_bounds (p n b h : ℕ) (s : ℕ → ℤ)
    (hp : 2 ≤ p) (hlarge : b * (n + 2) ≤ h)
    (htotal : (∑ i ∈ Finset.range (b + 1), s i) = (p : ℤ) ^ (b * (n + 1))) :
    (p : ℤ) ^ (b * (n + 1)) ∣ graphCount p n b h s ∧
      ¬ (p : ℤ) ^ (b * (n + 1) + 1) ∣ graphCount p n b h s := by
  have hbh : b ≤ h := by nlinarith
  have hc := weighted_stabilization p n b h s hbh
  rw [htotal] at hc
  have he : b * (n + 1) + 1 ≤ h - b + 1 := by
    nlinarith [Nat.sub_add_cancel hbh]
  have hnext := dvd_trans (power_dvd (p := p) he) hc
  constructor
  · apply cancel_denominator p n (b * (n + 1))
    have hlower := dvd_trans (power_dvd (p := p) (Nat.le_succ (b * (n + 1)))) hnext
    have ht := dvd_add hlower (dvd_refl ((p : ℤ) ^ (b * (n + 1))))
    simpa only [sub_add_cancel] using ht
  · simpa only [Nat.add_zero, pow_zero, one_mul] using
      scaled_obstruction p (b * (n + 1)) 0 (denominator p n)
        (graphCount p n b h s) hp hnext

theorem effective_obstruction (p n b r : ℕ) (s : ℕ → ℤ)
    (hp : 2 ≤ p) (hr : r ≤ b)
    (htotal : (∑ i ∈ Finset.range (b + 1), s i) = (p : ℤ) ^ (b * (n + 1))) :
    ¬ (p : ℤ) ^ (b * (n + 2) + 1) ∣
      (p : ℤ) ^ r * graphCount p n b (b * (n + 2)) s := by
  have hbh : b ≤ b * (n + 2) := by nlinarith
  have hc := weighted_stabilization p n b (b * (n + 2)) s hbh
  rw [htotal] at hc
  have he : b * (n + 2) - b + 1 = b * (n + 1) + 1 := by
    nlinarith [Nat.sub_add_cancel hbh]
  rw [he] at hc
  have hnot := scaled_obstruction p (b * (n + 1)) r
    (denominator p n) (graphCount p n b (b * (n + 2)) s) hp hc
  intro h
  apply hnot
  apply dvd_trans (power_dvd (p := p) (show b * (n + 1) + r + 1 ≤ b * (n + 2) + 1 by nlinarith))
  exact h

theorem fiber_total {α ι : Type*} [Fintype α] [Fintype ι] [DecidableEq ι]
    (d : ℕ) (label : (Fin d → α) → ι) :
    (∑ i : ι, (Finset.univ.filter (fun x => label x = i)).card) =
      Fintype.card α ^ d := by
  classical
  calc
    _ = ∑ i : ι, ∑ x : Fin d → α, if label x = i then 1 else 0 := by simp
    _ = ∑ x : Fin d → α, ∑ i : ι, if label x = i then 1 else 0 := Finset.sum_comm
    _ = _ := by simp

end ProfiniteRigidity
