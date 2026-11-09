import Mathlib

namespace SparseCount

def Bounded {d : ℕ} (K : ℤ) (n : Fin d → ℤ) : Prop :=
  ∀ i, |n i| ≤ K

def dotShift {d : ℕ} (ζ : Fin d → ℝ) : (Fin d → ℤ) →+ ℝ where
  toFun n := ∑ i, (n i : ℝ) * ζ i
  map_zero' := by simp
  map_add' n m := by
    simp [Int.cast_add, add_mul, Finset.sum_add_distrib]

def Near {d : ℕ} (f : (Fin d → ℤ) →+ ℝ)
    (K : ℤ) (E x : ℝ) : Prop :=
  ∃ n, Bounded K n ∧ |x + f n| ≤ E

theorem bounded_add {d : ℕ} {K L : ℤ} {n m : Fin d → ℤ}
    (hn : Bounded K n) (hm : Bounded L m) :
    Bounded (K + L) (n + m) := by
  intro i
  exact (abs_add_le (n i) (m i)).trans (add_le_add (hn i) (hm i))

theorem bounded_neg {d : ℕ} {K : ℤ} {n : Fin d → ℤ}
    (hn : Bounded K n) : Bounded K (-n) := by
  intro i
  simpa using hn i

theorem bounded_sub {d : ℕ} {K L : ℤ} {n m : Fin d → ℤ}
    (hn : Bounded K n) (hm : Bounded L m) :
    Bounded (K + L) (n - m) := by
  simpa [sub_eq_add_neg] using bounded_add hn (bounded_neg hm)

theorem near_zero {d : ℕ} (f : (Fin d → ℤ) →+ ℝ)
    {K : ℤ} {E : ℝ} (hK : 0 ≤ K) (hE : 0 ≤ E) :
    Near f K E 0 := by
  refine ⟨0, ?_, ?_⟩
  · intro i
    simpa using hK
  · simpa using hE

theorem Near.add {d : ℕ} {f : (Fin d → ℤ) →+ ℝ}
    {K L : ℤ} {E F x y : ℝ}
    (hx : Near f K E x) (hy : Near f L F y) :
    Near f (K + L) (E + F) (x + y) := by
  rcases hx with ⟨n, hn, he⟩
  rcases hy with ⟨m, hm, hf⟩
  refine ⟨n + m, bounded_add hn hm, ?_⟩
  calc
    |x + y + f (n + m)| = |(x + f n) + (y + f m)| := by
      rw [map_add]
      congr 1
      ring
    _ ≤ |x + f n| + |y + f m| := abs_add_le _ _
    _ ≤ E + F := add_le_add he hf

theorem Near.neg {d : ℕ} {f : (Fin d → ℤ) →+ ℝ}
    {K : ℤ} {E x : ℝ} (hx : Near f K E x) :
    Near f K E (-x) := by
  rcases hx with ⟨n, hn, he⟩
  refine ⟨-n, bounded_neg hn, ?_⟩
  simpa only [map_neg, ← neg_add, abs_neg] using he

theorem Near.sub {d : ℕ} {f : (Fin d → ℤ) →+ ℝ}
    {K L : ℤ} {E F x y : ℝ}
    (hx : Near f K E x) (hy : Near f L F y) :
    Near f (K + L) (E + F) (x - y) := by
  simpa only [sub_eq_add_neg] using hx.add hy.neg

theorem anchor_sums_separated {d : ℕ}
    (f : (Fin d → ℤ) →+ ℝ) (A P : Set ℝ)
    (Q Kb Kl : ℤ) (S Eb El c : ℝ)
    (V : ℝ → Prop)
    (hV : ∀ x, V x → Near f Kb Eb x)
    (hK : Kb + Kl + Kl ≤ Q) (hE : Eb + El + El ≤ S)
    (hLocal : ∀ p ∈ P, Near f Kl El (p - c))
    (hAnchors : ∀ a ∈ A, ∀ a' ∈ A, a ≠ a' →
      ∀ n, Bounded Q n → S < |a - a' + f n|)
    (hPacking : ∀ p ∈ P, ∀ p' ∈ P, p ≠ p' →
      ¬ V (p - p'))
    {a a' p p' : ℝ} (ha : a ∈ A) (ha' : a' ∈ A)
    (hp : p ∈ P) (hp' : p' ∈ P)
    (hCollision : V ((a + p) - (a' + p'))) :
    a = a' ∧ p = p' := by
  have hd : Near f (Kb + Kl + Kl) (Eb + El + El) (a - a') := by
    convert ((hV _ hCollision).sub (hLocal p hp)).add (hLocal p' hp') using 1
    ring
  have haa : a = a' := by
    by_contra hne
    rcases hd with ⟨n, hn, he⟩
    have hnQ : Bounded Q n := fun i => (hn i).trans hK
    exact (not_lt_of_ge (he.trans hE)) (hAnchors a ha a' ha' hne n hnQ)
  refine ⟨haa, ?_⟩
  by_contra hpp
  apply hPacking p hp p' hp' hpp
  convert hCollision using 1
  rw [haa]
  ring

theorem anchor_sum_card (A P : Finset ℝ)
    (hUnique : ∀ a ∈ A, ∀ p ∈ P, ∀ a' ∈ A, ∀ p' ∈ P,
      a + p = a' + p' → a = a' ∧ p = p') :
    ((A ×ˢ P).image (fun ap : ℝ × ℝ => ap.1 + ap.2)).card =
      A.card * P.card := by
  classical
  have hinj : Set.InjOn (fun ap : ℝ × ℝ => ap.1 + ap.2)
      (↑(A ×ˢ P) : Set (ℝ × ℝ)) := by
    intro ap hap bp hbp heq
    rcases Finset.mem_product.mp hap with ⟨ha, hp⟩
    rcases Finset.mem_product.mp hbp with ⟨hb, hq⟩
    exact Prod.ext (hUnique ap.1 ha ap.2 hp bp.1 hb bp.2 hq heq).1
      (hUnique ap.1 ha ap.2 hp bp.1 hb bp.2 hq heq).2
  rw [Finset.card_image_of_injOn hinj, Finset.card_product]

theorem annular_not_near {d : ℕ}
    (f : (Fin d → ℤ) →+ ℝ) (Q Kw Kb : ℤ)
    (μ ν R big small raw E : ℝ) (n₀ : Fin d → ℤ)
    (hμ : 0 < μ) (hR : 0 < R) (hμν : μ ≤ ν)
    (hKw : Bounded Kw n₀) (hK : Kw + Kb ≤ Q)
    (hBigLower : μ * R ≤ |big|) (hBigUpper : |big| ≤ ν * R)
    (hSmall : |small| ≤ μ * R / 100) (hE : E ≤ μ * R / 100)
    (hResidual : raw + f n₀ = big + small)
    (hGap : ∀ n, Bounded Q n →
      ¬ (μ * R / 100 ≤ |f n| ∧ |f n| ≤ 100 * ν * R)) :
    ¬ Near f Kb E raw := by
  rintro ⟨n, hn, he⟩
  let e := raw + f n
  have he' : |e| ≤ μ * R / 100 := he.trans hE
  have hnQ : Bounded Q (n₀ - n) :=
    fun i => (bounded_sub hKw hn i).trans hK
  have hid : f (n₀ - n) = big + small - e := by
    rw [map_sub]
    dsimp [e]
    linarith
  have hReverse : |big| ≤ |f (n₀ - n)| + |small| + |e| := by
    calc
      |big| = |(f (n₀ - n) + -small) + e| := by
        congr 1
        linarith
      _ ≤ |f (n₀ - n) + -small| + |e| := abs_add_le _ _
      _ ≤ (|f (n₀ - n)| + |-small|) + |e| :=
        add_le_add (abs_add_le _ _) le_rfl
      _ = |f (n₀ - n)| + |small| + |e| := by rw [abs_neg]
  have hForward : |f (n₀ - n)| ≤ |big| + |small| + |e| := by
    calc
      |f (n₀ - n)| = |(big + small) + -e| := by rw [hid]; rfl
      _ ≤ |big + small| + |-e| := abs_add_le _ _
      _ ≤ (|big| + |small|) + |-e| := add_le_add (abs_add_le _ _) le_rfl
      _ = |big| + |small| + |e| := by rw [abs_neg]
  have hPos : 0 < μ * R := mul_pos hμ hR
  have hCompare : μ * R ≤ ν * R := mul_le_mul_of_nonneg_right hμν hR.le
  have hLower : μ * R / 100 ≤ |f (n₀ - n)| := by linarith
  have hUpper : |f (n₀ - n)| ≤ 100 * ν * R := by nlinarith
  exact hGap (n₀ - n) hnQ ⟨hLower, hUpper⟩

theorem auxiliary_balance (x : ℝ) :
    (x ^ 2) ^ 4 * (x ^ 3) ^ 24 * x = x ^ 81 := by ring

theorem growth_exponent_margin (D : ℕ) (hD : 1 ≤ D) :
    8 * D + 2 * D ^ 2 < 50 * D ^ 2 := by nlinarith

end SparseCount
