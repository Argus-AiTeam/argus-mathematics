import Mathlib
import Mathlib.LinearAlgebra.BilinearForm.Basic
import Mathlib.LinearAlgebra.Matrix.BilinearForm

open scoped BigOperators
open LinearMap (BilinForm)

namespace IntegerSignature

noncomputable section

variable {E : Type*} [AddCommGroup E] [Module ℝ E]

def OnePositive (B : BilinForm ℝ E) : Prop :=
  ∀ u v, 0 < B u u → B u u * B v v ≤ (B u v) ^ 2

theorem from_kernel (B : BilinForm ℝ E) (sym : ∀ x y, B x y = B y x)
    (l : E →ₗ[ℝ] ℝ) (hn : ∀ x, l x = 0 → B x x ≤ 0) :
    OnePositive B := by
  intro u v hu
  have hlu : l u ≠ 0 := by
    intro h
    exact (not_le_of_gt hu) (hn u h)
  have orth : ∀ w, B u w = 0 → B w w ≤ 0 := by
    intro w hw
    have hz := hn (l u • w - l w • u) (by simp; ring)
    have hwu : B w u = 0 := by rw [sym, hw]
    simp only [BilinForm.sub_left, BilinForm.sub_right,
      BilinForm.smul_left, BilinForm.smul_right, hw, hwu] at hz
    have ha : 0 < (l u) ^ 2 := sq_pos_of_ne_zero hlu
    have hb : 0 ≤ (l w) ^ 2 * B u u := mul_nonneg (sq_nonneg _) hu.le
    have : (l u) ^ 2 * B w w ≤ 0 := by nlinarith [hz]
    by_contra hp
    have hh := mul_pos ha (lt_of_not_ge hp)
    linarith
  have hq : B u (v - (B u v / B u u) • u) = 0 := by
    simp only [BilinForm.sub_right, BilinForm.smul_right]
    field_simp
    <;> ring
  have hz := orth _ hq
  have hvu := sym v u
  simp only [BilinForm.sub_left, BilinForm.sub_right,
    BilinForm.smul_left, BilinForm.smul_right] at hz
  have hid :
      B u u * B (v - (B u v / B u u) • u)
        (v - (B u v / B u u) • u) =
        B u u * B v v - (B u v) ^ 2 := by
    simp only [BilinForm.sub_left, BilinForm.sub_right,
      BilinForm.smul_left, BilinForm.smul_right]
    rw [hvu]
    field_simp [ne_of_gt hu]
    <;> ring
  have := mul_nonpos_of_nonneg_of_nonpos hu.le (orth _ hq)
  rw [hid] at this
  linarith

theorem orthogonal_nonpositive (B : BilinForm ℝ E) (hB : OnePositive B)
    (u v : E) (hu : 0 < B u u) (h : B u v = 0) : B v v ≤ 0 := by
  have := hB u v hu
  rw [h] at this
  nlinarith

theorem no_positive_plane (B : BilinForm ℝ E) (hB : OnePositive B)
    (L : (ℝ × ℝ) →ₗ[ℝ] E) :
    ¬ (∀ x : ℝ × ℝ, x ≠ 0 → 0 < B (L x) (L x)) := by
  intro hp
  have he : ((1, 0) : ℝ × ℝ) ≠ 0 := by
    intro h; have := congrArg Prod.fst h; norm_num at this
  have hu := hp (1, 0) he
  let t := B (L (1, 0)) (L (0, 1)) / B (L (1, 0)) (L (1, 0))
  have hv : ((-t, 1) : ℝ × ℝ) ≠ 0 := by
    intro h; have := congrArg Prod.snd h; norm_num at this
  have hvp := hp (-t, 1) hv
  have hL : L (-t, 1) = L (0, 1) - t • L (1, 0) := by
    rw [← map_smul, ← map_sub]
    congr 1
    ext <;> simp
  have ho : B (L (1, 0)) (L (-t, 1)) = 0 := by
    rw [hL, BilinForm.sub_right, BilinForm.smul_right]
    dsimp [t]
    field_simp [ne_of_gt hu] <;> ring
  have hn := orthogonal_nonpositive B hB (L (1, 0)) (L (-t, 1)) hu ho
  linarith

theorem null_axis (B : BilinForm ℝ E) (sym : ∀ x y, B x y = B y x)
    (hB : OnePositive B) (e w v : E) (he : B e e = 0)
    (hew : B e w ≠ 0) (hev : B e v = 0) : B v v ≤ 0 := by
  by_contra hv
  have hv : 0 < B v v := lt_of_not_ge hv
  let t := (1 - B w w + (B v w) ^ 2 / B v v) / (2 * B e w)
  let z := t • e + w - (B v w / B v v) • v
  have hve : B v e = 0 := by rw [sym, hev]
  have hvz : B v z = 0 := by
    dsimp [z]
    simp only [BilinForm.sub_right, BilinForm.add_right, BilinForm.smul_right, hve]
    field_simp [ne_of_gt hv]
    <;> ring
  have hzz : B z z = 1 := by
    dsimp [z, t]
    simp only [BilinForm.sub_left, BilinForm.sub_right, BilinForm.add_left,
      BilinForm.add_right, BilinForm.smul_left, BilinForm.smul_right]
    rw [he, hev, hve, sym w e, sym w v]
    field_simp [hew, ne_of_gt hv]
    <;> ring
  have hh := orthogonal_nonpositive B hB v z hv hvz
  rw [hzz] at hh
  norm_num at hh

def rankOne (l : E →ₗ[ℝ] ℝ) : BilinForm ℝ E := l.smulRight l

@[simp] theorem rankOne_apply (l : E →ₗ[ℝ] ℝ) (x y : E) :
    rankOne l x y = l x * l y := rfl

theorem rank_one_minus_squares {ι : Type*} (s : Finset ι)
    (l : E →ₗ[ℝ] ℝ) (f : ι → E →ₗ[ℝ] ℝ) (c : ι → ℝ)
    (hc : ∀ i ∈ s, 0 ≤ c i) :
    OnePositive (rankOne l - ∑ i ∈ s, c i • rankOne (f i)) := by
  refine from_kernel _ ?_ l ?_
  · intro x y
    simp only [BilinForm.sub_apply, rankOne_apply, LinearMap.sum_apply,
      LinearMap.smul_apply, smul_eq_mul]
    congr 1
    · ring
    · apply Finset.sum_congr rfl
      intro i hi
      ring
  · intro x hx
    simp only [BilinForm.sub_apply, rankOne_apply, hx, zero_mul,
      LinearMap.sum_apply, LinearMap.smul_apply, smul_eq_mul]
    have : 0 ≤ ∑ i ∈ s, c i * (f i x * f i x) := by
      apply Finset.sum_nonneg
      intro i hi
      exact mul_nonneg (hc i hi) (mul_self_nonneg _)
    linarith

def pairForm (V : BilinForm ℝ E) (s t : E →ₗ[ℝ] ℝ) (a b c : ℝ) :
    BilinForm ℝ (E × ℝ × ℝ) where
  toFun x :=
    { toFun := fun y =>
        V x.1 y.1 + s x.1 * y.2.1 + t x.1 * y.2.2 +
        x.2.1 * s y.1 + x.2.2 * t y.1 +
        a * x.2.1 * y.2.1 + b * (x.2.1 * y.2.2 + x.2.2 * y.2.1) +
        c * x.2.2 * y.2.2
      map_add' := by intros; simp [map_add]; ring
      map_smul' := by intros; simp [map_smul, smul_eq_mul]; ring }
  map_add' := by intros x y; apply LinearMap.ext; intro z; simp [map_add]; ring
  map_smul' := by intros r x; apply LinearMap.ext; intro z; simp [map_smul, smul_eq_mul]; ring

theorem pairForm_symm (V : BilinForm ℝ E)
    (hs : ∀ x y, V x y = V y x) (s t : E →ₗ[ℝ] ℝ) (a b c : ℝ) :
    ∀ x y, pairForm V s t a b c x y = pairForm V s t a b c y x := by
  intro x y
  dsimp [pairForm]
  rw [hs x.1 y.1]
  ring

theorem positive_projection (B : BilinForm ℝ E) (hB : OnePositive B)
    (u v : E) (hu : 0 < B u u) :
    B v v ≤ (B u v) ^ 2 / B u u := by
  apply (le_div_iff₀ hu).mpr
  simpa [mul_comm] using hB u v hu

theorem pair_one (V : BilinForm ℝ E) (s t : E →ₗ[ℝ] ℝ)
    (a b c gm g gp : ℝ) (ha : 0 ≤ a) (hc : 0 ≤ c)
    (cover : 0 < a ∨ 0 < c ∨ (a = 0 ∧ c = 0 ∧ 0 < b))
    (hM : OnePositive (pairForm V s t a b c))
    (h : E) (hs : s h = b * g - a * gm) (ht : t h = c * gp - b * g) :
    V h h + 2 * b * g ^ 2 - a * gm ^ 2 - c * gp ^ 2 ≤ 0 := by
  let B := pairForm V s t a b c
  let x : E × ℝ × ℝ := (h, g, -g)
  let ea : E × ℝ × ℝ := (0, 1, 0)
  let eb : E × ℝ × ℝ := (0, 0, 1)
  have haa : B ea ea = a := by simp [B, ea, pairForm]
  have hbb : B eb eb = c := by simp [B, eb, pairForm]
  have hax : B ea x = a * (g - gm) := by
    simp [B, ea, x, pairForm, hs] <;> ring
  have hbx : B eb x = c * (gp - g) := by
    simp [B, eb, x, pairForm, ht] <;> ring
  have bound : B x x ≤ a * (g - gm) ^ 2 + c * (g - gp) ^ 2 := by
    rcases cover with ha' | hc' | ⟨ha', hc', hb'⟩
    · have hp := positive_projection B hM ea x (by rwa [haa])
      rw [haa, hax] at hp
      have he : (a * (g - gm)) ^ 2 / a = a * (g - gm) ^ 2 := by
        field_simp [ne_of_gt ha'] <;> ring
      rw [he] at hp
      nlinarith [mul_nonneg hc (sq_nonneg (g - gp))]
    · have hp := positive_projection B hM eb x (by rwa [hbb])
      rw [hbb, hbx] at hp
      have he : (c * (gp - g)) ^ 2 / c = c * (g - gp) ^ 2 := by
        field_simp [ne_of_gt hc'] <;> ring
      rw [he] at hp
      nlinarith [mul_nonneg ha (sq_nonneg (g - gm))]
    · have he : B (ea + eb) (ea + eb) = 2 * b := by
        simp [B, ea, eb, pairForm, ha', hc']; ring
      have hex : B (ea + eb) x = 0 := by
        rw [BilinForm.add_left, hax, hbx, ha', hc']
        ring
      have hp := orthogonal_nonpositive B hM (ea + eb) x (by rw [he]; positivity) hex
      simpa [ha', hc'] using hp
  have identity :
      B x x - a * (g - gm) ^ 2 - c * (g - gp) ^ 2 =
        V h h + 2 * b * g ^ 2 - a * gm ^ 2 - c * gp ^ 2 := by
    simp [B, x, pairForm, hs, ht]
    ring
  linarith

theorem width_one (V₀ V₁ : BilinForm ℝ E) (S : E →ₗ[ℝ] ℝ)
    (hv₀ : ∀ x y, V₀ x y = V₀ y x) (hv₁ : ∀ x y, V₁ x y = V₁ y x)
    (h₀ : OnePositive (pairForm V₀ 0 S 0 0 0))
    (h₁ : OnePositive (pairForm V₁ S 0 0 0 0))
    (nondegenerate : (∃ w, S w ≠ 0) ∨ (V₀ = 0 ∧ V₁ = 0)) :
    OnePositive (V₀ + V₁) := by
  refine from_kernel _ (by intro x y; simp [hv₀ x y, hv₁ x y]) S ?_
  intro h hh
  rcases nondegenerate with ⟨w, hw⟩ | ⟨rfl, rfl⟩
  · have hn₀ := null_axis (pairForm V₀ 0 S 0 0 0)
      (pairForm_symm V₀ hv₀ _ _ _ _ _) h₀
      (0, 0, 1) (w, 0, 0) (h, 0, 0)
      (by simp [pairForm]) (by simpa [pairForm] using hw)
      (by simpa [pairForm] using hh)
    have hn₁ := null_axis (pairForm V₁ S 0 0 0 0)
      (pairForm_symm V₁ hv₁ _ _ _ _ _) h₁
      (0, 1, 0) (w, 0, 0) (h, 0, 0)
      (by simp [pairForm]) (by simpa [pairForm] using hw)
      (by simpa [pairForm] using hh)
    simp only [pairForm, map_zero, zero_mul, mul_zero, add_zero, zero_add] at hn₀ hn₁
    simpa using add_nonpos hn₀ hn₁
  · simp

theorem linear_pullback {D : Type*} [AddCommGroup D] [Module ℝ D]
    (B : BilinForm ℝ E) (hB : OnePositive B) (L : D →ₗ[ℝ] E) :
    OnePositive (B.compl₁₂ L L) := by
  intro u v hu
  exact hB (L u) (L v) hu

theorem limit_closed (B : ℕ → BilinForm ℝ E) (A : BilinForm ℝ E)
    (hB : ∀ n, OnePositive (B n))
    (ht : ∀ x y, Filter.Tendsto (fun n => B n x y) Filter.atTop (nhds (A x y))) :
    OnePositive A := by
  intro x y hx
  have he : ∀ᶠ n in Filter.atTop, 0 < B n x x :=
    (tendsto_order.mp (ht x x)).1 0 hx
  have hi : ∀ᶠ n in Filter.atTop, B n x x * B n y y ≤ (B n x y) ^ 2 := by
    filter_upwards [he] with n hn
    exact hB n x y hn
  exact le_of_tendsto_of_tendsto ((ht x x).mul (ht y y)) ((ht x y).pow 2) hi

theorem sum_second_difference (M : ℕ) (a : ℕ → ℝ)
    (h₀ : a 0 = 0) (hM : a M = 0) (hM₁ : a (M + 1) = 0) :
    ∑ k ∈ Finset.range (M + 1), (2 * a k - a (k - 1) - a (k + 1)) = 0 := by
  have hp : ∑ k ∈ Finset.range (M + 1), a (k - 1) =
      ∑ k ∈ Finset.range (M + 1), a k := by
    rw [Finset.sum_range_succ', Finset.sum_range_succ]
    simp [h₀, hM]
  have hn : ∑ k ∈ Finset.range (M + 1), a (k + 1) =
      ∑ k ∈ Finset.range (M + 1), a k := by
    have h := Finset.sum_range_succ' a (M + 1)
    rw [Finset.sum_range_succ] at h
    simp only [h₀, hM₁, add_zero, zero_add] at h
    exact h.symm
  simp only [Finset.sum_sub_distrib, ← Finset.mul_sum]
  rw [hp, hn]
  ring

def cumulative (M : ℕ) (u : ℕ → ℝ) (S : ℕ → E →ₗ[ℝ] ℝ)
    (h : E) (k : ℕ) : ℝ :=
  if 0 < k ∧ k < M then (∑ l ∈ Finset.range k, S l h) / u k else 0

theorem cumulative_product (M : ℕ) (u : ℕ → ℝ) (S : ℕ → E →ₗ[ℝ] ℝ)
    (hp : ∀ k, 0 < k → k < M → 0 < u k)
    (h : E) (balance : (∑ l ∈ Finset.range M, S l h) = 0)
    (k : ℕ) (hk : k ≤ M) :
    u k * cumulative M u S h k = ∑ l ∈ Finset.range k, S l h := by
  by_cases hk₀ : k = 0
  · subst k; simp [cumulative]
  by_cases hkM : k = M
  · subst k; simp [cumulative, balance]
  have hki : 0 < k ∧ k < M := by omega
  dsimp [cumulative]
  rw [if_pos hki]
  field_simp [ne_of_gt (hp k hki.1 hki.2)]

theorem cumulative_difference (M : ℕ) (u : ℕ → ℝ)
    (S : ℕ → E →ₗ[ℝ] ℝ)
    (hp : ∀ k, 0 < k → k < M → 0 < u k)
    (huM : u M = 0) (huM₁ : u (M + 1) = 0) (hSM : S M = 0)
    (h : E) (balance : (∑ l ∈ Finset.range M, S l h) = 0)
    (k : ℕ) (hk : k ≤ M) :
    S k h = u (k + 1) * cumulative M u S h (k + 1) -
      u k * cumulative M u S h k := by
  by_cases he : k = M
  · subst k; simp [huM, huM₁, hSM]
  have hi : k < M := by omega
  rw [cumulative_product M u S hp h balance (k + 1) (by omega),
    cumulative_product M u S hp h balance k hk, Finset.sum_range_succ]
  ring

theorem balanced_pair (M : ℕ) (hM : 2 ≤ M)
    (V : ℕ → BilinForm ℝ E) (S : ℕ → E →ₗ[ℝ] ℝ) (u : ℕ → ℝ)
    (sym : ∀ k x y, V k x y = V k y x)
    (hu₀ : u 0 = 0) (huM : u M = 0) (huM₁ : u (M + 1) = 0)
    (hp : ∀ k, 0 < k → k < M → 0 < u k) (hSM : S M = 0)
    (hsig : ∀ k, k ≤ M →
      OnePositive (pairForm (V k) (if k = 0 then 0 else S (k - 1)) (S k)
        (u (k - 1)) (u k) (u (k + 1)))) :
    OnePositive (∑ k ∈ Finset.range (M + 1), V k) := by
  refine from_kernel _ ?_ (∑ l ∈ Finset.range M, S l) ?_
  · intro x y
    simp only [LinearMap.sum_apply]
    exact Finset.sum_congr rfl (fun k _ => sym k x y)
  · intro h hh
    have bal : (∑ l ∈ Finset.range M, S l h) = 0 := by
      simpa only [LinearMap.sum_apply] using hh
    let g := cumulative M u S h
    have hnonneg : ∀ k, k ≤ M + 1 → 0 ≤ u k := by
      intro k hk
      by_cases h₀ : k = 0
      · simp [h₀, hu₀]
      by_cases he : k = M
      · simp [he, huM]
      by_cases he₁ : k = M + 1
      · simp [he₁, huM₁]
      exact (hp k (by omega) (by omega)).le
    have hlocal : ∀ k ∈ Finset.range (M + 1),
        V k h h + 2 * u k * g k ^ 2 -
          u (k - 1) * g (k - 1) ^ 2 - u (k + 1) * g (k + 1) ^ 2 ≤ 0 := by
      intro k hk
      have hk : k ≤ M := Nat.le_of_lt_succ (Finset.mem_range.mp hk)
      have ha := hnonneg (k - 1) (by omega)
      have hc := hnonneg (k + 1) (by omega)
      have cover : 0 < u (k - 1) ∨ 0 < u (k + 1) ∨
          (u (k - 1) = 0 ∧ u (k + 1) = 0 ∧ 0 < u k) := by
        by_cases ha' : 0 < u (k - 1)
        · exact Or.inl ha'
        by_cases hc' : 0 < u (k + 1)
        · exact Or.inr (Or.inl hc')
        have hk₀ : k ≠ 0 := by
          intro he; subst k
          exact hc' (hp 1 (by omega) (by omega))
        have hkM : k ≠ M := by
          intro he; subst k
          exact ha' (hp (M - 1) (by omega) (by omega))
        exact Or.inr (Or.inr ⟨le_antisymm (le_of_not_gt ha') ha,
          le_antisymm (le_of_not_gt hc') hc, hp k (by omega) (by omega)⟩)
      apply pair_one _ _ _ _ _ _ _ _ _ ha hc cover (hsig k hk) h
      · by_cases hk₀ : k = 0
        · subst k; simp [g, cumulative, hu₀]
        · rw [if_neg hk₀]
          have hd := cumulative_difference M u S hp huM huM₁ hSM h bal
            (k - 1) (by omega)
          have he : k - 1 + 1 = k := by omega
          simpa only [he] using hd
      · exact cumulative_difference M u S hp huM huM₁ hSM h bal k hk
    have hsum := Finset.sum_nonpos hlocal
    have htel := sum_second_difference M (fun k => u k * g k ^ 2)
      (by simp [hu₀]) (by simp [huM]) (by simp [huM₁])
    have heq : (∑ k ∈ Finset.range (M + 1),
        (V k h h + 2 * u k * g k ^ 2 -
          u (k - 1) * g (k - 1) ^ 2 - u (k + 1) * g (k + 1) ^ 2)) =
        (∑ k ∈ Finset.range (M + 1), V k h h) +
        ∑ k ∈ Finset.range (M + 1),
          (2 * (u k * g k ^ 2) - u (k - 1) * g (k - 1) ^ 2 -
            u (k + 1) * g (k + 1) ^ 2) := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intros; ring
    rw [heq, htel, add_zero] at hsum
    simpa only [LinearMap.sum_apply] using hsum

theorem weighted_second_difference (D : ℕ) (a w : ℕ → ℝ)
    (h₀ : a 0 = 0) (hD : a D = 0) (hD₁ : a (D + 1) = 0) :
    (∑ k ∈ Finset.range (D + 1), w k * (2 * a k - a (k - 1) - a (k + 1))) =
      ∑ k ∈ Finset.range (D + 1), (2 * w k - w (k - 1) - w (k + 1)) * a k := by
  have hp : (∑ k ∈ Finset.range (D + 1), w k * a (k - 1)) =
      ∑ k ∈ Finset.range (D + 1), w (k + 1) * a k := by
    rw [Finset.sum_range_succ', Finset.sum_range_succ]
    simp [h₀, hD]
  have hn : (∑ k ∈ Finset.range (D + 1), w k * a (k + 1)) =
      ∑ k ∈ Finset.range (D + 1), w (k - 1) * a k := by
    rw [Finset.sum_range_succ, Finset.sum_range_succ']
    simp [h₀, hD₁]
  have hm : (∑ k ∈ Finset.range (D + 1), w k * (2 * a k)) =
      ∑ k ∈ Finset.range (D + 1), 2 * w k * a k := by
    apply Finset.sum_congr rfl
    intros; ring
  simp only [mul_sub, sub_mul, Finset.sum_sub_distrib]
  rw [hp, hn, hm]
  ring

def parabola (D k : ℕ) : ℝ := (k : ℝ) * ((D : ℝ) - k)

theorem parabola_identity (D : ℕ) (a : ℕ → ℝ)
    (h₀ : a 0 = 0) (hD : a D = 0) (hD₁ : a (D + 1) = 0) :
    (∑ k ∈ Finset.range (D + 1),
      parabola D k * (2 * a k - a (k - 1) - a (k + 1))) =
        2 * ∑ k ∈ Finset.range (D + 1), a k := by
  rw [weighted_second_difference D a (parabola D) h₀ hD hD₁, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro k hk
  by_cases hk₀ : k = 0
  · simp [hk₀, h₀]
  have hcast : ((k - 1 : ℕ) : ℝ) = (k : ℝ) - 1 := by
    rw [Nat.cast_sub (by omega)]
    norm_num
  dsimp [parabola]
  rw [hcast]
  push_cast
  ring

theorem pair_weighted (D : ℕ) (hD : 2 ≤ D)
    (V : ℕ → BilinForm ℝ E) (S : ℕ → E →ₗ[ℝ] ℝ) (u : ℕ → ℝ)
    (hu₀ : u 0 = 0) (huD : u D = 0) (huD₁ : u (D + 1) = 0)
    (hp : ∀ k, 0 < k → k < D → 0 < u k) (hSD : S D = 0)
    (hsig : ∀ k, 0 < k → k < D →
      OnePositive (pairForm (V k) (S (k - 1)) (S k)
        (u (k - 1)) (u k) (u (k + 1))))
    (h : E) (balance : (∑ l ∈ Finset.range D, S l h) = 0) :
    2 * (∑ k ∈ Finset.range (D + 1), u k * cumulative D u S h k ^ 2) ≤
      -(∑ k ∈ Finset.range (D + 1), parabola D k * V k h h) := by
  let g := cumulative D u S h
  have hlocal : ∀ k ∈ Finset.range (D + 1),
      parabola D k * (V k h h + 2 * u k * g k ^ 2 -
        u (k - 1) * g (k - 1) ^ 2 - u (k + 1) * g (k + 1) ^ 2) ≤ 0 := by
    intro k hk
    have hk : k ≤ D := Nat.le_of_lt_succ (Finset.mem_range.mp hk)
    by_cases hk₀ : k = 0
    · simp [hk₀, parabola]
    by_cases hkD : k = D
    · simp [hkD, parabola]
    have hki : 0 < k ∧ k < D := by omega
    have ha : 0 ≤ u (k - 1) := by
      by_cases he : k = 1
      · simp [he, hu₀]
      exact (hp (k - 1) (by omega) (by omega)).le
    have hc : 0 ≤ u (k + 1) := by
      by_cases he : k + 1 = D
      · simp [he, huD]
      exact (hp (k + 1) (by omega) (by omega)).le
    have cover : 0 < u (k - 1) ∨ 0 < u (k + 1) ∨
        (u (k - 1) = 0 ∧ u (k + 1) = 0 ∧ 0 < u k) := by
      by_cases ha' : 0 < u (k - 1)
      · exact Or.inl ha'
      by_cases hc' : 0 < u (k + 1)
      · exact Or.inr (Or.inl hc')
      exact Or.inr (Or.inr ⟨le_antisymm (le_of_not_gt ha') ha,
        le_antisymm (le_of_not_gt hc') hc, hp k hki.1 hki.2⟩)
    have hl := pair_one (V k) (S (k - 1)) (S k)
      (u (k - 1)) (u k) (u (k + 1)) (g (k - 1)) (g k) (g (k + 1))
      ha hc cover (hsig k hki.1 hki.2) h
      (by
        have he : k - 1 + 1 = k := by omega
        simpa only [he] using cumulative_difference D u S hp huD huD₁ hSD
          h balance (k - 1) (by omega))
      (cumulative_difference D u S hp huD huD₁ hSD h balance k hk)
    have hw : 0 ≤ parabola D k := by
      apply mul_nonneg (Nat.cast_nonneg _)
      exact sub_nonneg.mpr (by exact_mod_cast hk)
    exact mul_nonpos_of_nonneg_of_nonpos hw hl
  have hsum := Finset.sum_nonpos hlocal
  have htel := parabola_identity D (fun k => u k * g k ^ 2)
    (by simp [hu₀]) (by simp [huD]) (by simp [huD₁])
  have heq : (∑ k ∈ Finset.range (D + 1),
      parabola D k * (V k h h + 2 * u k * g k ^ 2 -
        u (k - 1) * g (k - 1) ^ 2 - u (k + 1) * g (k + 1) ^ 2)) =
      (∑ k ∈ Finset.range (D + 1), parabola D k * V k h h) +
      ∑ k ∈ Finset.range (D + 1),
        parabola D k * (2 * (u k * g k ^ 2) -
          u (k - 1) * g (k - 1) ^ 2 - u (k + 1) * g (k + 1) ^ 2) := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intros; ring
  rw [heq, htel] at hsum
  linarith

section Laminar

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def blockLinear (G : Finset ι) : (ι → ℝ) →ₗ[ℝ] ℝ :=
  ∑ i ∈ G, LinearMap.proj i

@[simp] theorem blockLinear_apply (G : Finset ι) (x : ι → ℝ) :
    blockLinear G x = ∑ i ∈ G, x i := by
  simp [blockLinear]

@[simp] theorem blockLinear_single (G : Finset ι) (i : ι) :
    blockLinear G (Pi.single i 1) = if i ∈ G then 1 else 0 := by
  simp [blockLinear, Pi.single_apply, eq_comm]

def kernelEntry (L : Finset (Finset ι)) (γ : Finset ι → ℝ) (i j : ι) : ℝ :=
  ∏ G ∈ L, if i ∈ G ∧ j ∈ G then γ G else 1

def kernelForm (L : Finset (Finset ι)) (γ : Finset ι → ℝ) :
    BilinForm ℝ (ι → ℝ) :=
  Matrix.toBilin' (kernelEntry L γ)

def Laminar (L : Finset (Finset ι)) : Prop :=
  ∀ G ∈ L, ∀ H ∈ L, G ⊆ H ∨ H ⊆ G ∨ Disjoint G H

theorem kernel_symmetric (L : Finset (Finset ι)) (γ : Finset ι → ℝ) :
    ∀ x y, kernelForm L γ x y = kernelForm L γ y x := by
  have hm : (kernelForm L γ).IsSymm := by
    apply Matrix.isSymm_toBilin'_iff_isSymm.mpr
    ext i j
    simp [kernelEntry, and_comm]
  exact hm.eq

theorem minimal_block_difference (L : Finset (Finset ι)) (γ : Finset ι → ℝ)
    (hl : Laminar L) (G : Finset ι) (hG : G ∈ L)
    (hmin : ∀ H ∈ L, H ⊆ G → H = G) :
    kernelForm L γ = kernelForm (L.erase G) γ -
      ((1 - γ G) * ∏ H ∈ L.erase G, if G ⊆ H then γ H else 1) •
        rankOne (blockLinear G) := by
  classical
  apply BilinForm.ext_basis (Pi.basisFun ℝ ι)
  intro i j
  simp only [Pi.basisFun_apply, kernelForm, Matrix.toBilin'_single,
    BilinForm.sub_apply, LinearMap.smul_apply, smul_eq_mul, rankOne_apply,
    blockLinear_single]
  have hsplit : kernelEntry L γ i j =
      (if i ∈ G ∧ j ∈ G then γ G else 1) * kernelEntry (L.erase G) γ i j := by
    unfold kernelEntry
    conv_lhs => rw [← Finset.insert_erase hG,
      Finset.prod_insert (by simp)]
  by_cases hp : i ∈ G ∧ j ∈ G
  · have hc : kernelEntry (L.erase G) γ i j =
        ∏ H ∈ L.erase G, if G ⊆ H then γ H else 1 := by
      apply Finset.prod_congr rfl
      intro H hH
      have hHL : H ∈ L := (Finset.mem_erase.mp hH).2
      have hHG : H ≠ G := (Finset.mem_erase.mp hH).1
      have hh : (i ∈ H ∧ j ∈ H) ↔ G ⊆ H := by
        constructor
        · intro hi
          rcases hl G hG H hHL with h | h | h
          · exact h
          · exact False.elim (hHG (hmin H hHL h))
          · exact False.elim (Finset.disjoint_left.mp h hp.1 hi.1)
        · intro h
          exact ⟨h hp.1, h hp.2⟩
      simp only [hh]
    rw [hsplit, if_pos hp, hc, if_pos hp.1, if_pos hp.2]
    ring
  · rw [hsplit, if_neg hp]
    by_cases hi : i ∈ G
    · have hj : j ∉ G := by tauto
      simp [hi, hj]
    · simp [hi]

theorem laminar_nonpositive (L : Finset (Finset ι)) (γ : Finset ι → ℝ)
    (hl : Laminar L) (hγ : ∀ G ∈ L, 0 ≤ γ G ∧ γ G ≤ 1) :
    ∀ x : ι → ℝ, (∑ i, x i) = 0 → kernelForm L γ x x ≤ 0 := by
  classical
  induction L using Finset.strongInductionOn with
  | _ L ih =>
    intro x hx
    by_cases he : L = ∅
    · subst L
      simp [kernelForm, kernelEntry, Matrix.toBilin'_apply, ← Finset.mul_sum,
        ← Finset.sum_mul, hx]
    obtain ⟨G, hG, hmincard⟩ := L.exists_min_image Finset.card (Finset.nonempty_iff_ne_empty.mpr he)
    have hmin : ∀ H ∈ L, H ⊆ G → H = G := by
      intro H hH hHG
      exact Finset.eq_of_subset_of_card_le hHG (hmincard H hH)
    have hl' : Laminar (L.erase G) := by
      intro A hA B hB
      exact hl A (Finset.mem_of_mem_erase hA) B (Finset.mem_of_mem_erase hB)
    have hγ' : ∀ H ∈ L.erase G, 0 ≤ γ H ∧ γ H ≤ 1 := by
      intro H hH
      exact hγ H (Finset.mem_of_mem_erase hH)
    have hr := ih (L.erase G) (Finset.erase_ssubset hG) hl' hγ' x hx
    have hc : 0 ≤ (1 - γ G) *
        ∏ H ∈ L.erase G, if G ⊆ H then γ H else 1 := by
      apply mul_nonneg (by linarith [(hγ G hG).2])
      apply Finset.prod_nonneg
      intro H hH
      split_ifs
      · exact (hγ' H hH).1
      · norm_num
    rw [minimal_block_difference L γ hl G hG hmin]
    simp only [BilinForm.sub_apply, LinearMap.smul_apply, rankOne_apply, smul_eq_mul]
    have := mul_nonneg hc (mul_self_nonneg (blockLinear G x))
    linarith

theorem laminar_signature (L : Finset (Finset ι)) (γ : Finset ι → ℝ)
    (hl : Laminar L) (hγ : ∀ G ∈ L, 0 ≤ γ G ∧ γ G ≤ 1) :
    OnePositive (kernelForm L γ) :=
  from_kernel _ (kernel_symmetric L γ) (blockLinear Finset.univ)
    (by simpa only [blockLinear_apply] using laminar_nonpositive L γ hl hγ)

def diagonalMap (a : ι → ℝ) : (ι → ℝ) →ₗ[ℝ] (ι → ℝ) where
  toFun x i := a i * x i
  map_add' := by intros; ext; simp [mul_add]
  map_smul' := by intros; ext; simp [smul_eq_mul]; ring

def correctedForm (L : Finset (Finset ι)) (γ : Finset ι → ℝ)
    (a δ : ι → ℝ) (W : ℝ) : BilinForm ℝ (ι → ℝ) :=
  W • (kernelForm L γ).compl₁₂ (diagonalMap a) (diagonalMap a) -
    ∑ i, δ i • rankOne (LinearMap.proj i)

theorem corrected_signature (L : Finset (Finset ι)) (γ : Finset ι → ℝ)
    (hl : Laminar L) (hγ : ∀ G ∈ L, 0 ≤ γ G ∧ γ G ≤ 1)
    (a δ : ι → ℝ) (W : ℝ) (hW : 0 ≤ W) (hδ : ∀ i, 0 ≤ δ i) :
    OnePositive (correctedForm L γ a δ W) := by
  refine from_kernel _ ?_ ((blockLinear Finset.univ).comp (diagonalMap a)) ?_
  · intro x y
    simp only [correctedForm, BilinForm.sub_apply, LinearMap.smul_apply,
      LinearMap.sum_apply, rankOne_apply, smul_eq_mul]
    change W * kernelForm L γ (diagonalMap a x) (diagonalMap a y) -
      ∑ i, δ i * (x i * y i) =
        W * kernelForm L γ (diagonalMap a y) (diagonalMap a x) -
          ∑ i, δ i * (y i * x i)
    rw [kernel_symmetric L γ (diagonalMap a x) (diagonalMap a y)]
    congr 1
    apply Finset.sum_congr rfl
    intros; ring
  · intro x hx
    have hs : (∑ i, (diagonalMap a x) i) = 0 := by
      simpa only [LinearMap.comp_apply, blockLinear_apply] using hx
    have hn := laminar_nonpositive L γ hl hγ (diagonalMap a x) hs
    have hd : 0 ≤ ∑ i, δ i * (x i * x i) :=
      Finset.sum_nonneg (fun i _ => mul_nonneg (hδ i) (mul_self_nonneg _))
    have hq := mul_nonpos_of_nonneg_of_nonpos hW hn
    simp only [correctedForm, BilinForm.sub_apply, LinearMap.smul_apply,
      LinearMap.sum_apply, rankOne_apply, smul_eq_mul]
    change W * kernelForm L γ (diagonalMap a x) (diagonalMap a x) -
      ∑ i, δ i * (x i * x i) ≤ 0
    linarith

def localFactor (p q r : ℝ) (i j : Prop) [Decidable i] [Decidable j] : ℝ :=
  if i then (if j then r else q) else (if j then q else p)

theorem local_factorization (p q r : ℝ) (hp : p ≠ 0) (hq : q ≠ 0)
    (i j : Prop) [Decidable i] [Decidable j] :
    localFactor p q r i j =
      p * (if i then q / p else 1) * (if j then q / p else 1) *
        (if i ∧ j then p * r / q ^ 2 else 1) := by
  by_cases hi : i <;> by_cases hj : j <;>
    simp [localFactor, hi, hj] <;> field_simp [hp, hq] <;> ring

def factorEntry (L : Finset (Finset ι)) (p q r : Finset ι → ℝ) (i j : ι) : ℝ :=
  ∏ G ∈ L, localFactor (p G) (q G) (r G) (i ∈ G) (j ∈ G)

def factorScale (L : Finset (Finset ι)) (p q : Finset ι → ℝ) (i : ι) : ℝ :=
  ∏ G ∈ L, if i ∈ G then q G / p G else 1

theorem factorization (L : Finset (Finset ι)) (p q r : Finset ι → ℝ)
    (hp : ∀ G ∈ L, 0 < p G) (hq : ∀ G ∈ L, 0 < q G) (i j : ι) :
    factorEntry L p q r i j =
      (∏ G ∈ L, p G) * factorScale L p q i * factorScale L p q j *
        kernelEntry L (fun G => p G * r G / q G ^ 2) i j := by
  unfold factorEntry factorScale kernelEntry
  rw [← Finset.prod_mul_distrib, ← Finset.prod_mul_distrib, ← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intro G hG
  exact local_factorization _ _ _ (ne_of_gt (hp G hG)) (ne_of_gt (hq G hG)) _ _

def removalEntry (L : Finset (Finset ι)) (p q r : Finset ι → ℝ)
    (z : ι → ℤ) (i j : ι) : ℝ :=
  if 0 < z i ∧ 0 < z j ∧ (i = j → 1 < z i) then factorEntry L p q r i j else 0

def removalScale (L : Finset (Finset ι)) (p q : Finset ι → ℝ)
    (z : ι → ℤ) (i : ι) : ℝ :=
  if 0 < z i then factorScale L p q i else 0

def invalidDiagonal (L : Finset (Finset ι)) (p q r : Finset ι → ℝ)
    (z : ι → ℤ) (i : ι) : ℝ :=
  if z i = 1 then factorEntry L p q r i i else 0

theorem removal_form_identity (L : Finset (Finset ι)) (p q r : Finset ι → ℝ)
    (hp : ∀ G ∈ L, 0 < p G) (hq : ∀ G ∈ L, 0 < q G) (z : ι → ℤ) :
    Matrix.toBilin' (removalEntry L p q r z) =
      correctedForm L (fun G => p G * r G / q G ^ 2)
        (removalScale L p q z) (invalidDiagonal L p q r z) (∏ G ∈ L, p G) := by
  classical
  apply BilinForm.ext_basis (Pi.basisFun ℝ ι)
  intro i j
  simp only [Pi.basisFun_apply, Matrix.toBilin'_single, correctedForm,
    BilinForm.sub_apply, LinearMap.smul_apply, LinearMap.sum_apply,
    rankOne_apply, LinearMap.proj_apply, smul_eq_mul]
  have hdiag : diagonalMap (removalScale L p q z) (Pi.single i 1) =
      removalScale L p q z i • Pi.single i 1 := by
    ext k
    by_cases hk : k = i <;> simp [diagonalMap, Pi.single_apply, hk, eq_comm]
  have hdiag' : diagonalMap (removalScale L p q z) (Pi.single j 1) =
      removalScale L p q z j • Pi.single j 1 := by
    ext k
    by_cases hk : k = j <;> simp [diagonalMap, Pi.single_apply, hk, eq_comm]
  change removalEntry L p q r z i j =
    (∏ G ∈ L, p G) *
      kernelForm L (fun G => p G * r G / q G ^ 2)
        (diagonalMap (removalScale L p q z) (Pi.single i 1))
        (diagonalMap (removalScale L p q z) (Pi.single j 1)) -
      ∑ k, invalidDiagonal L p q r z k *
        ((Pi.single i 1 : ι → ℝ) k * (Pi.single j 1 : ι → ℝ) k)
  rw [hdiag, hdiag', BilinForm.smul_left, BilinForm.smul_right]
  simp only [kernelForm, Matrix.toBilin'_single]
  by_cases hij : i = j
  · subst j
    simp only [Pi.single_apply, ite_mul, mul_ite, mul_one, mul_zero,
      Finset.sum_ite_eq', Finset.mem_univ, if_true]
    rw [removalEntry, removalScale, invalidDiagonal]
    by_cases hz : 0 < z i
    · rw [if_pos hz]
      by_cases h₁ : z i = 1
      · simp [hz, h₁]
        rw [factorization L p q r hp hq]
        ring
      · have h₂ : 1 < z i := by omega
        simp only [hz, h₂, implies_true, and_self, if_true, h₁, if_false, sub_zero]
        rw [factorization L p q r hp hq]
        ring
    · have h₁ : z i ≠ 1 := by omega
      simp [hz, h₁]
  · have hs : (∑ k, invalidDiagonal L p q r z k *
      ((Pi.single i 1 : ι → ℝ) k * (Pi.single j 1 : ι → ℝ) k)) = 0 := by
      apply Finset.sum_eq_zero
      intro k _
      by_cases hi : k = i
      · subst k; simp [Pi.single_apply, hij]
      · simp [Pi.single_apply, hi, Ne.symm hi]
    rw [hs, sub_zero]
    simp only [removalEntry, removalScale, hij, false_implies, and_true]
    by_cases hi : 0 < z i <;> by_cases hj : 0 < z j
    · simp only [hi, hj, and_self, if_true]
      rw [factorization L p q r hp hq]
      ring
    · simp [hi, hj]
    · simp [hi, hj]
    · simp [hi, hj]

theorem positive_factor_signature (L : Finset (Finset ι))
    (p q r : Finset ι → ℝ) (z : ι → ℤ) (hl : Laminar L)
    (hp : ∀ G ∈ L, 0 < p G) (hq : ∀ G ∈ L, 0 < q G)
    (hr : ∀ G ∈ L, 0 < r G)
    (hlc : ∀ G ∈ L, p G * r G ≤ q G ^ 2) :
    OnePositive (Matrix.toBilin' (removalEntry L p q r z)) := by
  rw [removal_form_identity L p q r hp hq z]
  apply corrected_signature L _ hl
  · intro G hG
    exact ⟨(div_pos (mul_pos (hp G hG) (hr G hG))
      (sq_pos_of_pos (hq G hG))).le,
      (div_le_one (sq_pos_of_pos (hq G hG))).mpr (hlc G hG)⟩
  · exact (Finset.prod_pos hp).le
  · intro i
    unfold invalidDiagonal
    split_ifs
    · apply Finset.prod_nonneg
      intro G hG
      by_cases hi : i ∈ G
      · simpa [localFactor, hi] using (hr G hG).le
      · simpa [localFactor, hi] using (hp G hG).le
    · exact le_rfl

def remove (z : ι → ℤ) (i j : ι) : ι → ℤ :=
  fun k => z k - (if k = i then 1 else 0) - (if k = j then 1 else 0)

theorem sum_remove (G : Finset ι) (z : ι → ℤ) (i j : ι) :
    (∑ k ∈ G, remove z i j k) =
      (∑ k ∈ G, z k) - (if i ∈ G then 1 else 0) - (if j ∈ G then 1 else 0) := by
  simp [remove, Finset.sum_sub_distrib, Finset.sum_ite_eq', eq_comm]

def productWeight (L : Finset (Finset ι)) (ψ : Finset ι → ℤ → ℝ)
    (z : ι → ℤ) : ℝ :=
  ∏ G ∈ L, ψ G (∑ i ∈ G, z i)

def positiveRemoval (L : Finset (Finset ι)) (ψ : Finset ι → ℤ → ℝ)
    (z : ι → ℤ) (i j : ι) : ℝ :=
  if 0 < z i ∧ 0 < z j ∧ (i = j → 1 < z i) then
    productWeight L ψ (remove z i j) else 0

theorem product_removal_identity (L : Finset (Finset ι))
    (ψ : Finset ι → ℤ → ℝ) (z : ι → ℤ) :
    positiveRemoval L ψ z =
      removalEntry L (fun G => ψ G (∑ k ∈ G, z k))
        (fun G => ψ G ((∑ k ∈ G, z k) - 1))
        (fun G => ψ G ((∑ k ∈ G, z k) - 2)) z := by
  funext i j
  unfold positiveRemoval removalEntry
  congr 1
  unfold productWeight factorEntry
  apply Finset.prod_congr rfl
  intro G hG
  rw [sum_remove]
  by_cases hi : i ∈ G <;> by_cases hj : j ∈ G <;>
    simp [localFactor, hi, hj, sub_sub]

theorem laminar_product_signature (L : Finset (Finset ι))
    (ψ : Finset ι → ℤ → ℝ) (z : ι → ℤ) (hl : Laminar L)
    (hp : ∀ G ∈ L, ∀ a, 0 < ψ G a)
    (hc : ∀ G ∈ L, ∀ a, ψ G (a - 1) * ψ G (a + 1) ≤ ψ G a ^ 2) :
    OnePositive (Matrix.toBilin' (positiveRemoval L ψ z)) := by
  rw [product_removal_identity]
  apply positive_factor_signature _ _ _ _ _ hl
  · intro G hG; exact hp G hG _
  · intro G hG; exact hp G hG _
  · intro G hG; exact hp G hG _
  · intro G hG
    have h := hc G hG ((∑ k ∈ G, z k) - 1)
    have h₁ : (∑ k ∈ G, z k) - 1 - 1 = (∑ k ∈ G, z k) - 2 := by ring
    have h₂ : (∑ k ∈ G, z k) - 1 + 1 = (∑ k ∈ G, z k) := by ring
    simpa only [h₁, h₂, mul_comm] using h

def Box (m z : ι → ℤ) : Prop := ∀ i, 0 ≤ z i ∧ z i ≤ m i

def sliceWeight (L : Finset (Finset ι)) (ψ : Finset ι → ℤ → ℝ)
    (m : ι → ℤ) (R : ℤ) (z : ι → ℤ) : ℝ := by
  classical
  exact if Box m z ∧ (∑ i, z i) = R then productWeight L ψ z else 0

theorem box_remove (m z : ι → ℤ) (hz : Box m z) (i j : ι) :
    Box m (remove z i j) ↔ 0 < z i ∧ 0 < z j ∧ (i = j → 1 < z i) := by
  constructor
  · intro h
    have hi := (h i).1
    have hj := (h j).1
    by_cases hij : i = j
    · subst j
      simp [remove] at hi
      omega
    · simp [remove, hij, Ne.symm hij] at hi hj
      exact ⟨by omega, by omega, by tauto⟩
  · rintro ⟨hi, hj, he⟩ k
    have hk := hz k
    by_cases hki : k = i <;> by_cases hkj : k = j
    · subst k; subst j; simp [remove]; have := he rfl; omega
    · subst k; simp [remove, hkj]; omega
    · subst k; simp [remove, hki]; omega
    · simp [remove, hki, hkj]; exact hk

theorem slice_removal_identity (L : Finset (Finset ι))
    (ψ : Finset ι → ℤ → ℝ) (m z : ι → ℤ) (R : ℤ)
    (hz : Box m z) (ht : (∑ i, z i) = R + 2) (i j : ι) :
    sliceWeight L ψ m R (remove z i j) = positiveRemoval L ψ z i j := by
  have hs : (∑ k, remove z i j k) = R := by
    rw [sum_remove]
    simp only [Finset.mem_univ, if_true]
    omega
  simp only [sliceWeight, hs, and_true, box_remove m z hz, positiveRemoval]

theorem initial_slice_signature (L : Finset (Finset ι))
    (ψ : Finset ι → ℤ → ℝ) (m z : ι → ℤ) (R : ℤ)
    (hl : Laminar L) (hp : ∀ G ∈ L, ∀ a, 0 < ψ G a)
    (hc : ∀ G ∈ L, ∀ a, ψ G (a - 1) * ψ G (a + 1) ≤ ψ G a ^ 2)
    (hz : Box m z) (ht : (∑ i, z i) = R + 2) :
    OnePositive (Matrix.toBilin' (fun i j => sliceWeight L ψ m R (remove z i j))) := by
  have he : (fun i j => sliceWeight L ψ m R (remove z i j)) =
      positiveRemoval L ψ z := by
    funext i j
    exact slice_removal_identity L ψ m z R hz ht i j
  rw [he]
  exact laminar_product_signature L ψ z hl hp hc

theorem matrix_limit (A : Matrix ι ι ℝ) (B : ℕ → Matrix ι ι ℝ)
    (hB : ∀ n, OnePositive (Matrix.toBilin' (B n)))
    (ht : ∀ i j, Filter.Tendsto (fun n => B n i j) Filter.atTop (nhds (A i j))) :
    OnePositive (Matrix.toBilin' A) := by
  apply limit_closed (fun n => Matrix.toBilin' (B n)) _ hB
  intro x y
  simp only [Matrix.toBilin'_apply]
  apply tendsto_finsetSum
  intro i _
  apply tendsto_finsetSum
  intro j _
  exact (tendsto_const_nhds.mul (ht i j)).mul tendsto_const_nhds

def reflect (m z : ι → ℤ) : ι → ℤ := fun i => m i - z i

theorem reflect_involutive (m z : ι → ℤ) : reflect m (reflect m z) = z := by
  funext i; simp [reflect]

theorem reflect_remove (m z : ι → ℤ) (i j : ι) :
    reflect m (remove (reflect m z) i j) =
      fun k => z k + (if k = i then 1 else 0) + (if k = j then 1 else 0) := by
  funext k
  simp only [reflect, remove]
  ring

theorem reflect_box (m z : ι → ℤ) (hz : Box m z) : Box m (reflect m z) := by
  intro i
  have := hz i
  dsimp [reflect]
  omega

theorem reflect_total (m z : ι → ℤ) :
    (∑ i, reflect m z i) = (∑ i, m i) - ∑ i, z i := by
  simp [reflect, Finset.sum_sub_distrib]

theorem balanced_reflection (M : ℕ) (f : ℕ → ℝ) :
    (∑ k ∈ Finset.range (M + 1), f (M - k)) = ∑ k ∈ Finset.range (M + 1), f k := by
  refine Finset.sum_bij (fun k _ => M - k) ?_ ?_ ?_ ?_
  · intro k hk
    simp only [Finset.mem_range] at hk ⊢
    omega
  · intro k hk l hl hkl
    simp only [Finset.mem_range] at hk hl
    omega
  · intro k hk
    simp only [Finset.mem_range] at hk
    exact ⟨M - k, by simp only [Finset.mem_range]; omega, by omega⟩
  · intros; rfl

end Laminar

section IntegerContraction

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def down (z : ι → ℤ) (i : ι) : ι → ℤ :=
  fun k => z k - if k = i then 1 else 0

def join (z : ι → ℤ) (a b : ℤ) : ι ⊕ Bool → ℤ :=
  Sum.elim z (fun t => if t then b else a)

theorem sum_join (z : ι → ℤ) (a b : ℤ) :
    (∑ i, join z a b i) = (∑ i, z i) + a + b := by
  simp [join, Fintype.sum_sum_type, Fintype.sum_bool]
  ring

theorem box_join (m z : ι → ℤ) (M a b : ℤ) :
    Box (join m M M) (join z a b) ↔
      Box m z ∧ (0 ≤ a ∧ a ≤ M) ∧ (0 ≤ b ∧ b ≤ M) := by
  constructor
  · intro h
    exact ⟨fun i => h (Sum.inl i), h (Sum.inr false), h (Sum.inr true)⟩
  · rintro ⟨h, ha, hb⟩ i
    rcases i with i | b'
    · exact h i
    · cases b' <;> assumption

def SliceSignature (m : ι → ℤ) (R : ℤ) (w : (ι → ℤ) → ℝ) : Prop :=
  ∀ z, Box m z → (∑ i, z i) = R + 2 →
    OnePositive (Matrix.toBilin' (fun i j => w (remove z i j)))

def PositiveModel (m : ι → ℤ) (R : ℤ) (w : (ι → ℤ) → ℝ) : Prop :=
  (∀ z, ¬ (Box m z ∧ (∑ i, z i) = R) → w z = 0) ∧
  (∀ z, Box m z → (∑ i, z i) = R → 0 < w z)

def contract (M : ℕ) (w : ((ι ⊕ Bool) → ℤ) → ℝ) (z : ι → ℤ) : ℝ :=
  ∑ k ∈ Finset.range (M + 1), w (join z (k : ℤ) ((M : ℤ) - k))

theorem invalid_pair (m : ι → ℤ) (M : ℕ) (R : ℤ)
    (w : ((ι ⊕ Bool) → ℤ) → ℝ)
    (hw : PositiveModel (join m M M) R w) (z : ι → ℤ) (a b : ℤ)
    (bad : a < 0 ∨ b < 0) : w (join z a b) = 0 := by
  apply hw.1
  intro h
  have hb := (box_join m z M a b).mp h.1
  rcases bad with ha | hb'
  · omega
  · omega

theorem contract_positive (m : ι → ℤ) (M : ℕ) (r : ℤ)
    (w : ((ι ⊕ Bool) → ℤ) → ℝ)
    (hw : PositiveModel (join m M M) (r + M) w) :
    PositiveModel m r (contract M w) := by
  constructor
  · intro z hz
    apply Finset.sum_eq_zero
    intro k hk
    apply hw.1
    intro h
    have hb := (box_join m z M k ((M : ℤ) - k)).mp h.1
    have ht := h.2
    rw [sum_join] at ht
    exact hz ⟨hb.1, by omega⟩
  · intro z hz ht
    apply Finset.sum_pos
    · intro k hk
      have hk : k ≤ M := Nat.le_of_lt_succ (Finset.mem_range.mp hk)
      apply hw.2
      · apply (box_join m z M k ((M : ℤ) - k)).mpr
        exact ⟨hz, ⟨by omega, by omega⟩, ⟨by omega, by omega⟩⟩
      · rw [sum_join, ht]; ring
    · exact ⟨0, Finset.mem_range.mpr (by omega)⟩

def splitMap : ((ι → ℝ) × ℝ × ℝ) →ₗ[ℝ] (ι ⊕ Bool → ℝ) where
  toFun x := Sum.elim x.1 (fun b => if b then x.2.2 else x.2.1)
  map_add' := by
    intro x y; funext i; rcases i with i | b
    · rfl
    · cases b <;> rfl
  map_smul' := by
    intro r x; funext i; rcases i with i | b
    · rfl
    · cases b <;> rfl

theorem remove_comm (z : ι → ℤ) (i j : ι) :
    remove z i j = remove z j i := by
  funext k; dsimp [remove]; ring

theorem weight_matrix_symmetric (w : (ι → ℤ) → ℝ) (z : ι → ℤ) :
    ∀ x y, Matrix.toBilin' (fun i j => w (remove z i j)) x y =
      Matrix.toBilin' (fun i j => w (remove z i j)) y x := by
  have hs : (Matrix.toBilin' (fun i j => w (remove z i j))).IsSymm := by
    apply Matrix.isSymm_toBilin'_iff_isSymm.mpr
    ext i j
    exact congrArg w (remove_comm z j i)
  exact hs.eq

theorem remove_join_old (z : ι → ℤ) (a b : ℤ) (i j : ι) :
    remove (join z a b) (Sum.inl i) (Sum.inl j) = join (remove z i j) a b := by
  funext k
  rcases k with k | c
  · simp [remove, join]
  · cases c <;> simp [remove, join]

theorem remove_join_left (z : ι → ℤ) (a b : ℤ) (i : ι) :
    remove (join z a b) (Sum.inl i) (Sum.inr false) = join (down z i) (a - 1) b := by
  funext k
  rcases k with k | c
  · simp [remove, join, down]
  · cases c <;> simp [remove, join]

theorem remove_join_right (z : ι → ℤ) (a b : ℤ) (i : ι) :
    remove (join z a b) (Sum.inl i) (Sum.inr true) = join (down z i) a (b - 1) := by
  funext k
  rcases k with k | c
  · simp [remove, join, down]
  · cases c <;> simp [remove, join]

theorem remove_join_ll (z : ι → ℤ) (a b : ℤ) :
    remove (join z a b) (Sum.inr false) (Sum.inr false) = join z (a - 2) b := by
  funext k
  rcases k with k | c
  · simp [remove, join]
  · cases c <;> simp [remove, join]; ring

theorem remove_join_lr (z : ι → ℤ) (a b : ℤ) :
    remove (join z a b) (Sum.inr false) (Sum.inr true) = join z (a - 1) (b - 1) := by
  funext k
  rcases k with k | c
  · simp [remove, join]
  · cases c <;> simp [remove, join]

theorem remove_join_rr (z : ι → ℤ) (a b : ℤ) :
    remove (join z a b) (Sum.inr true) (Sum.inr true) = join z a (b - 2) := by
  funext k
  rcases k with k | c
  · simp [remove, join]
  · cases c <;> simp [remove, join]; ring

def Vblock (M : ℕ) (w : ((ι ⊕ Bool) → ℤ) → ℝ) (z : ι → ℤ) (k : ℕ) :
    BilinForm ℝ (ι → ℝ) :=
  Matrix.toBilin' (fun i j => w (join (remove z i j) k ((M : ℤ) - k)))

def Sblock (M : ℕ) (w : ((ι ⊕ Bool) → ℤ) → ℝ) (z : ι → ℤ) (k : ℕ) :
    (ι → ℝ) →ₗ[ℝ] ℝ :=
  ∑ i, w (join (down z i) k ((M : ℤ) - 1 - k)) • LinearMap.proj i

def ublock (M : ℕ) (w : ((ι ⊕ Bool) → ℤ) → ℝ) (z : ι → ℤ) (k : ℕ) : ℝ :=
  w (join z ((k : ℤ) - 1) ((M : ℤ) - 1 - k))

theorem block_decomposition (M : ℕ) (m z : ι → ℤ) (R : ℤ)
    (w : ((ι ⊕ Bool) → ℤ) → ℝ) (hw : PositiveModel (join m M M) R w)
    (k : ℕ) :
    (Matrix.toBilin' (fun i j => w (remove (join z k ((M : ℤ) - k)) i j))).compl₁₂
      splitMap splitMap =
      pairForm (Vblock M w z k)
        (if k = 0 then 0 else Sblock M w z (k - 1)) (Sblock M w z k)
        (ublock M w z (k - 1)) (ublock M w z k) (ublock M w z (k + 1)) := by
  have hleft (i : ι) : w (join (down z i) ((k : ℤ) - 1) ((M : ℤ) - k)) =
      (if k = 0 then 0 else w (join (down z i) ((k - 1 : ℕ) : ℤ)
        ((M : ℤ) - 1 - ((k - 1 : ℕ) : ℤ)))) := by
    by_cases hk : k = 0
    · subst k
      simp only [Nat.cast_zero, zero_sub, if_true]
      exact invalid_pair m M R w hw _ _ _ (Or.inl (by norm_num))
    · rw [if_neg hk]
      have hc : ((k - 1 : ℕ) : ℤ) = (k : ℤ) - 1 := by omega
      rw [hc]
      congr 2 <;> ring
  have hll : w (join z ((k : ℤ) - 2) ((M : ℤ) - k)) = ublock M w z (k - 1) := by
    by_cases hk : k = 0
    · subst k
      rw [invalid_pair m M R w hw _ _ _ (Or.inl (by norm_num))]
      unfold ublock
      symm
      exact invalid_pair m M R w hw _ _ _ (Or.inl (by norm_num))
    · have hc : ((k - 1 : ℕ) : ℤ) = (k : ℤ) - 1 := by omega
      unfold ublock
      rw [hc]
      congr 2 <;> ring
  have hlr : w (join z ((k : ℤ) - 1) ((M : ℤ) - k - 1)) = ublock M w z k := by
    unfold ublock; congr 2 <;> ring
  have hrr : w (join z k ((M : ℤ) - k - 2)) = ublock M w z (k + 1) := by
    unfold ublock; push_cast; congr 2 <;> ring
  apply BilinForm.ext
  intro x y
  simp only [LinearMap.compl₁₂_apply, Matrix.toBilin'_apply,
    Fintype.sum_sum_type, Fintype.sum_bool, splitMap, LinearMap.coe_mk, AddHom.coe_mk,
    Sum.elim_inl, Sum.elim_inr, Bool.false_eq_true, if_false, if_true]
  simp_rw [remove_join_old, remove_join_left, remove_join_right,
    remove_comm _ (Sum.inr true) (Sum.inl _),
    remove_comm _ (Sum.inr false) (Sum.inl _),
    remove_join_left, remove_join_right, remove_join_ll, remove_join_lr,
    remove_comm _ (Sum.inr true) (Sum.inr false), remove_join_lr, remove_join_rr]
  simp_rw [hleft, hll, hlr, hrr]
  by_cases hk : k = 0 <;>
    simp [pairForm, Vblock, Sblock, hk, Matrix.toBilin'_apply,
      Finset.sum_add_distrib, Finset.mul_sum, Finset.sum_mul,
      mul_comm, mul_left_comm, mul_assoc] <;> ring

theorem sum_down (z : ι → ℤ) (i : ι) :
    (∑ k, down z i k) = (∑ k, z k) - 1 := by
  simp [down, Finset.sum_sub_distrib, Finset.sum_ite_eq', eq_comm]

theorem down_box (m z : ι → ℤ) (hz : Box m z) (i : ι) (hi : 0 < z i) :
    Box m (down z i) := by
  intro k
  have hk := hz k
  by_cases he : k = i
  · subst k; simp only [down, if_true]; omega
  · simpa [down, he] using hk

theorem invalid_old_removal (m z : ι → ℤ) (M : ℕ) (R : ℤ)
    (w : ((ι ⊕ Bool) → ℤ) → ℝ) (hw : PositiveModel (join m M M) R w)
    (i j : ι) (hi : z i = 0) (a b : ℤ) :
    w (join (remove z i j) a b) = 0 := by
  apply hw.1
  intro h
  have hb := ((box_join m (remove z i j) M a b).mp h.1).1 i
  have hn := hb.1
  by_cases hij : i = j
  · subst j; simp [remove, hi] at hn
  · simp [remove, hi, hij] at hn

theorem contracted_matrix (M : ℕ) (w : ((ι ⊕ Bool) → ℤ) → ℝ) (z : ι → ℤ) :
    Matrix.toBilin' (fun i j => contract M w (remove z i j)) =
      ∑ k ∈ Finset.range (M + 1), Vblock M w z k := by
  apply BilinForm.ext_basis (Pi.basisFun ℝ ι)
  intro i j
  simp [Vblock, contract, LinearMap.sum_apply]

theorem contract_signature (m : ι → ℤ) (M : ℕ) (hM : 0 < M) (r : ℤ)
    (w : ((ι ⊕ Bool) → ℤ) → ℝ)
    (hw : PositiveModel (join m M M) (r + M) w)
    (hs : SliceSignature (join m M M) (r + M) w) :
    SliceSignature m r (contract M w) := by
  intro z hz ht
  let V := Vblock M w z
  let S := Sblock M w z
  let u := ublock M w z
  have hu₀ : u 0 = 0 := by
    exact invalid_pair m M (r + M) w hw z _ _ (Or.inl (by norm_num))
  have huM : u M = 0 := by
    apply invalid_pair m M (r + M) w hw
    exact Or.inr (by omega)
  have huM₁ : u (M + 1) = 0 := by
    apply invalid_pair m M (r + M) w hw
    exact Or.inr (by omega)
  have hp : ∀ k, 0 < k → k < M → 0 < u k := by
    intro k hk hkM
    apply hw.2
    · apply (box_join _ _ _ _ _).mpr
      exact ⟨hz, ⟨by omega, by omega⟩, ⟨by omega, by omega⟩⟩
    · rw [sum_join, ht]
      omega
  have hSM : S M = 0 := by
    apply LinearMap.ext
    intro x
    change (∑ i, w (join (down z i) M ((M : ℤ) - 1 - M)) • LinearMap.proj i) x = 0
    simp only [LinearMap.sum_apply, LinearMap.smul_apply, LinearMap.proj_apply, smul_eq_mul]
    apply Finset.sum_eq_zero
    intro i _
    rw [invalid_pair m M (r + M) w hw _ _ _ (Or.inr (by omega)), zero_mul]
  have hsig : ∀ k, k ≤ M →
      OnePositive (pairForm (V k) (if k = 0 then 0 else S (k - 1)) (S k)
        (u (k - 1)) (u k) (u (k + 1))) := by
    intro k hk
    have hb : Box (join m M M) (join z k ((M : ℤ) - k)) :=
      (box_join _ _ _ _ _).mpr ⟨hz, ⟨by omega, by omega⟩, ⟨by omega, by omega⟩⟩
    have htotal : (∑ i, join z k ((M : ℤ) - k) i) = (r + M) + 2 := by
      rw [sum_join, ht]; ring
    have hh := linear_pullback _ (hs _ hb htotal) (splitMap (ι := ι))
    rw [block_decomposition M m z (r + M) w hw k] at hh
    exact hh
  have hv : ∀ k x y, V k x y = V k y x := by
    intro k
    exact weight_matrix_symmetric (fun a => w (join a k ((M : ℤ) - k))) z
  rw [contracted_matrix]
  by_cases h₁ : M = 1
  · have hn : (∃ x, S 0 x ≠ 0) ∨ (V 0 = 0 ∧ V 1 = 0) := by
      by_cases hpos : ∃ i, 0 < z i
      · obtain ⟨i, hi⟩ := hpos
        left
        refine ⟨Pi.single i 1, ?_⟩
        have he : S 0 (Pi.single i 1) = w (join (down z i) 0 0) := by
          simp [S, Sblock, h₁, Pi.single_apply, eq_comm]
        rw [he]
        apply ne_of_gt
        apply hw.2
        · apply (box_join _ _ _ _ _).mpr
          exact ⟨down_box m z hz i hi, ⟨by omega, by omega⟩, ⟨by omega, by omega⟩⟩
        · rw [sum_join, sum_down, ht]
          omega
      · right
        have hz₀ : ∀ i, z i = 0 := by
          intro i
          have := (hz i).1
          have hn : ¬ 0 < z i := fun hi => hpos ⟨i, hi⟩
          omega
        have hzV : ∀ k, V k = 0 := by
          intro k
          apply BilinForm.ext_basis (Pi.basisFun ℝ ι)
          intro i j
          simp only [V, Vblock, Pi.basisFun_apply, Matrix.toBilin'_single, BilinForm.zero_apply]
          exact invalid_old_removal m z M (r + M) w hw i j (hz₀ i) _ _
        exact ⟨hzV 0, hzV 1⟩
    have hh₀ := hsig 0 (by omega)
    have hh₁ := hsig 1 (by omega)
    have hu₁ : u 1 = 0 := by simpa [h₁] using huM
    have hu₂ : u 2 = 0 := by simpa [h₁] using huM₁
    have hS₁ : S 1 = 0 := by simpa [h₁] using hSM
    have hres := width_one (V 0) (V 1) (S 0) (hv 0) (hv 1)
      (by simpa [hu₀, hu₁] using hh₀)
      (by simpa [hu₀, hu₁, hu₂, hS₁] using hh₁) hn
    simpa [V, h₁, Finset.sum_range_succ, add_assoc] using hres
  · exact balanced_pair M (by omega) V S u hv hu₀ huM huM₁ hp hSM hsig

theorem slice_positive (L : Finset (Finset ι)) (ψ : Finset ι → ℤ → ℝ)
    (m : ι → ℤ) (R : ℤ) (hp : ∀ G ∈ L, ∀ a, 0 < ψ G a) :
    PositiveModel m R (sliceWeight L ψ m R) := by
  classical
  constructor
  · intro z hz
    simp [sliceWeight, hz]
  · intro z hz ht
    have hcond : Box m z ∧ (∑ i, z i) = R := ⟨hz, ht⟩
    simp only [sliceWeight, if_pos hcond, productWeight]
    exact Finset.prod_pos (fun G hG => hp G hG _)

theorem limiting_signature (m : ι → ℤ) (r : ℤ)
    (w : (ι → ℤ) → ℝ) (W : ℕ → (ι → ℤ) → ℝ)
    (hs : ∀ n, SliceSignature m r (W n))
    (ht : ∀ z, Filter.Tendsto (fun n => W n z) Filter.atTop (nhds (w z))) :
    SliceSignature m r w := by
  intro z hz hsum
  apply matrix_limit _ _ (fun n => hs n z hz hsum)
  intro i j
  exact ht (remove z i j)

theorem addition_from_reflection (m : ι → ℤ) (r : ℤ) (w : (ι → ℤ) → ℝ)
    (hs : SliceSignature m ((∑ i, m i) - r) (fun z => w (reflect m z)))
    (z : ι → ℤ) (hz : Box m z) (ht : (∑ i, z i) = r - 2) :
    OnePositive (Matrix.toBilin' (fun i j =>
      w (fun k => z k + (if k = i then 1 else 0) + (if k = j then 1 else 0)))) := by
  have hr : (∑ i, reflect m z i) = ((∑ i, m i) - r) + 2 := by
    rw [reflect_total, ht]; ring
  have hh := hs (reflect m z) (reflect_box m z hz) hr
  simpa only [reflect_remove] using hh

theorem contract_reflection (m : ι → ℤ) (M : ℕ)
    (w : ((ι ⊕ Bool) → ℤ) → ℝ) (z : ι → ℤ) :
    contract M (fun v => w (reflect (join m M M) v)) z =
      contract M w (reflect m z) := by
  have he (k : ℕ) (hk : k ∈ Finset.range (M + 1)) :
      reflect (join m M M) (join z k ((M : ℤ) - k)) =
        join (reflect m z) ((M - k : ℕ) : ℤ) ((M : ℤ) - ((M - k : ℕ) : ℤ)) := by
    have hk : k ≤ M := Nat.le_of_lt_succ (Finset.mem_range.mp hk)
    have hc : ((M - k : ℕ) : ℤ) = (M : ℤ) - k := by omega
    rw [hc]
    funext i
    rcases i with i | b
    · rfl
    · cases b <;> simp [reflect, join]
  unfold contract
  calc
    _ = ∑ k ∈ Finset.range (M + 1),
        w (join (reflect m z) ((M - k : ℕ) : ℤ) ((M : ℤ) - ((M - k : ℕ) : ℤ))) := by
      apply Finset.sum_congr rfl
      intro k hk
      exact congrArg w (he k hk)
    _ = _ := balanced_reflection M (fun k =>
      w (join (reflect m z) (k : ℤ) ((M : ℤ) - k)))

theorem slice_reflection (L : Finset (Finset ι)) (ψ : Finset ι → ℤ → ℝ)
    (m : ι → ℤ) (R : ℤ) (z : ι → ℤ) :
    sliceWeight L ψ m R (reflect m z) =
      sliceWeight L (fun G a => ψ G ((∑ i ∈ G, m i) - a))
        m ((∑ i, m i) - R) z := by
  classical
  have hb : Box m (reflect m z) ↔ Box m z := by
    constructor
    · intro h; simpa only [reflect_involutive] using reflect_box m (reflect m z) h
    · exact reflect_box m z
  have ht : (∑ i, reflect m z i) = R ↔ (∑ i, z i) = (∑ i, m i) - R := by
    rw [reflect_total]; omega
  simp only [sliceWeight, hb, ht]
  congr 1
  unfold productWeight
  apply Finset.prod_congr rfl
  intro G hG
  simp [reflect, Finset.sum_sub_distrib]

end IntegerContraction

universe u

@[reducible] def Coordinates (ι : Type u) : ℕ → Type u
  | 0 => ι
  | n + 1 => Coordinates ι n ⊕ Bool

@[reducible] instance coordinatesFintype {ι : Type*} [Fintype ι] :
    (n : ℕ) → Fintype (Coordinates ι n)
  | 0 => inferInstanceAs (Fintype ι)
  | n + 1 => @instFintypeSum (Coordinates ι n) Bool (coordinatesFintype n) inferInstance

@[reducible] instance coordinatesDecidableEq {ι : Type*} [DecidableEq ι] :
    (n : ℕ) → DecidableEq (Coordinates ι n)
  | 0 => inferInstanceAs (DecidableEq ι)
  | n + 1 => @instDecidableEqSum (Coordinates ι n) Bool
      (coordinatesDecidableEq n) inferInstance

section Iteration

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def capacities (m : ι → ℤ) (width : ℕ → ℕ) :
    (n : ℕ) → Coordinates ι n → ℤ
  | 0 => m
  | n + 1 => join (capacities m width n) (width n) (width n)

def widthSum (width : ℕ → ℕ) (n : ℕ) : ℤ :=
  ∑ k ∈ Finset.range n, (width k : ℤ)

def eliminate (width : ℕ → ℕ) :
    (n : ℕ) → ((Coordinates ι n → ℤ) → ℝ) → (ι → ℤ) → ℝ
  | 0, w => w
  | n + 1, w => eliminate width n (contract (width n) w)

theorem iterated_closure (n : ℕ) (m : ι → ℤ) (width : ℕ → ℕ) (r : ℤ)
    (w : (Coordinates ι n → ℤ) → ℝ)
    (hp : ∀ k, k < n → 0 < width k)
    (hw : PositiveModel (capacities m width n) (r + widthSum width n) w)
    (hs : SliceSignature (capacities m width n) (r + widthSum width n) w) :
    PositiveModel m r (eliminate width n w) ∧ SliceSignature m r (eliminate width n w) := by
  induction n with
  | zero => simpa [eliminate, capacities, widthSum] using And.intro hw hs
  | succ n ih =>
    have hwt : PositiveModel (join (capacities m width n) (width n) (width n))
        ((r + widthSum width n) + width n) w := by
      simpa [capacities, widthSum, Finset.sum_range_succ, add_assoc] using hw
    have hst : SliceSignature (join (capacities m width n) (width n) (width n))
        ((r + widthSum width n) + width n) w := by
      simpa [capacities, widthSum, Finset.sum_range_succ, add_assoc] using hs
    exact ih (contract (width n) w) (fun k hk => hp k (by omega))
      (contract_positive _ _ _ _ hwt)
      (contract_signature _ _ (hp n (by omega)) _ _ hwt hst)

theorem integer_signature (n : ℕ) (m : ι → ℤ) (width : ℕ → ℕ) (r : ℤ)
    (L : Finset (Finset (Coordinates ι n))) (ψ : Finset (Coordinates ι n) → ℤ → ℝ)
    (hl : Laminar L) (hp : ∀ G ∈ L, ∀ a, 0 < ψ G a)
    (hc : ∀ G ∈ L, ∀ a, ψ G (a - 1) * ψ G (a + 1) ≤ ψ G a ^ 2)
    (hwidth : ∀ k, k < n → 0 < width k) :
    SliceSignature m r (eliminate width n
      (sliceWeight L ψ (capacities m width n) (r + widthSum width n))) := by
  apply (iterated_closure n m width r _ hwidth
    (slice_positive L ψ _ _ hp) ?_).2
  intro z hz ht
  exact initial_slice_signature L ψ _ z _ hl hp hc hz ht

theorem capacities_sum (n : ℕ) (m : ι → ℤ) (width : ℕ → ℕ) :
    (∑ i, capacities m width n i) = (∑ i, m i) + 2 * widthSum width n := by
  induction n with
  | zero => simp [capacities, widthSum]
  | succ n ih =>
    rw [capacities, sum_join, ih]
    simp only [widthSum, Finset.sum_range_succ]
    ring

theorem eliminate_reflection (n : ℕ) (m : ι → ℤ) (width : ℕ → ℕ)
    (w : (Coordinates ι n → ℤ) → ℝ) (z : ι → ℤ) :
    eliminate width n (fun v => w (reflect (capacities m width n) v)) z =
      eliminate width n w (reflect m z) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    change eliminate width n
      (contract (width n) (fun v => w (reflect (join (capacities m width n) (width n) (width n)) v))) z =
        eliminate width n (contract (width n) w) (reflect m z)
    have he : contract (width n)
        (fun v => w (reflect (join (capacities m width n) (width n) (width n)) v)) =
        fun v => contract (width n) w (reflect (capacities m width n) v) := by
      funext v
      exact contract_reflection _ _ _ _
    rw [he]
    exact ih (contract (width n) w)

theorem integer_addition_signature (n : ℕ) (m : ι → ℤ) (width : ℕ → ℕ) (r : ℤ)
    (L : Finset (Finset (Coordinates ι n))) (ψ : Finset (Coordinates ι n) → ℤ → ℝ)
    (hl : Laminar L) (hp : ∀ G ∈ L, ∀ a, 0 < ψ G a)
    (hc : ∀ G ∈ L, ∀ a, ψ G (a - 1) * ψ G (a + 1) ≤ ψ G a ^ 2)
    (hwidth : ∀ k, k < n → 0 < width k) (z : ι → ℤ)
    (hz : Box m z) (ht : (∑ i, z i) = r - 2) :
    OnePositive (Matrix.toBilin' (fun i j =>
      eliminate width n (sliceWeight L ψ (capacities m width n) (r + widthSum width n))
        (fun k => z k + (if k = i then 1 else 0) + (if k = j then 1 else 0)))) := by
  let cap := capacities m width n
  let ψr := fun G a => ψ G ((∑ i ∈ G, cap i) - a)
  have hpr : ∀ G ∈ L, ∀ a, 0 < ψr G a := fun G hG a => hp G hG _
  have hcr : ∀ G ∈ L, ∀ a, ψr G (a - 1) * ψr G (a + 1) ≤ ψr G a ^ 2 := by
    intro G hG a
    have h := hc G hG ((∑ i ∈ G, cap i) - a)
    dsimp [ψr]
    have h₁ : (∑ i ∈ G, cap i) - (a - 1) = ((∑ i ∈ G, cap i) - a) + 1 := by ring
    have h₂ : (∑ i ∈ G, cap i) - (a + 1) = ((∑ i ∈ G, cap i) - a) - 1 := by ring
    rw [h₁, h₂]
    simpa [mul_comm] using h
  have hs := integer_signature n m width ((∑ i, m i) - r) L ψr hl hpr hcr hwidth
  have he : (fun v => sliceWeight L ψ cap (r + widthSum width n) (reflect cap v)) =
      sliceWeight L ψr cap (((∑ i, m i) - r) + widthSum width n) := by
    funext v
    rw [slice_reflection]
    have htotal : (∑ i, cap i) - (r + widthSum width n) =
        ((∑ i, m i) - r) + widthSum width n := by
      rw [capacities_sum]
      ring
    rw [htotal]
  have hfun :
      (fun v => eliminate width n (sliceWeight L ψ cap (r + widthSum width n)) (reflect m v)) =
      eliminate width n (sliceWeight L ψr cap (((∑ i, m i) - r) + widthSum width n)) := by
    funext v
    rw [← he, eliminate_reflection]
  apply addition_from_reflection m r _ ?_ z hz ht
  rw [hfun]
  exact hs

end Iteration

#print axioms integer_signature
#print axioms integer_addition_signature
#print axioms pair_weighted
#print axioms limiting_signature
#print axioms no_positive_plane

end
end IntegerSignature
