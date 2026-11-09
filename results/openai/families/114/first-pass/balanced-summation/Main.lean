import Mathlib

noncomputable section

open Finset

namespace BalancedSummation

variable {X : Type*} [AddCommGroup X] [Module ℝ X]

abbrev Form (X : Type*) [AddCommGroup X] [Module ℝ X] :=
  LinearMap.BilinForm ℝ X

def Symmetric (B : Form X) : Prop := ∀ x y, B x y = B y x

def Signature (B : Form X) : Prop :=
  ∀ u v, 0 < B u u → B v u = 0 → B v v ≤ 0

theorem signature_of_kernel (B : Form X) (hB : Symmetric B)
    (L : X →ₗ[ℝ] ℝ) (hL : ∀ v, L v = 0 → B v v ≤ 0) :
    Signature B := by
  intro u v hu hv
  have hLu : L u ≠ 0 := by
    intro h
    have := hL u h
    linarith
  let c := L v / L u
  have hc : L (v - c • u) = 0 := by
    simp only [map_sub, map_smul, smul_eq_mul]
    dsimp [c]
    field_simp
    <;> ring
  have hn := hL (v - c • u) hc
  have huv : B u v = 0 := by rw [hB, hv]
  simp only [map_sub, map_smul, LinearMap.sub_apply,
    LinearMap.smul_apply, smul_eq_mul, hv, huv] at hn
  nlinarith [sq_nonneg c]

theorem projection (B : Form X) (hB : Symmetric B)
    (hS : Signature B) (u v : X) (hu : 0 < B u u) :
    B v v ≤ (B v u) ^ 2 / B u u := by
  let c := B v u / B u u
  have hc : B (v - c • u) u = 0 := by
    simp only [map_sub, map_smul, LinearMap.sub_apply,
      LinearMap.smul_apply, smul_eq_mul]
    dsimp [c]
    field_simp
    <;> ring
  have hn := hS u (v - c • u) hu hc
  have he : B (v - c • u) (v - c • u) =
      B v v - (B v u) ^ 2 / B u u := by
    simp only [map_sub, map_smul, LinearMap.sub_apply,
      LinearMap.smul_apply, smul_eq_mul]
    rw [hB u v]
    dsimp [c]
    field_simp
    <;> ring
  rw [he] at hn
  linarith

theorem signature_iff_no_positive_plane (B : Form X) (hB : Symmetric B) :
    Signature B ↔
      ∀ u v, 0 < B u u → B u u * B v v ≤ (B v u) ^ 2 := by
  constructor
  · intro h u v hu
    simpa only [mul_comm] using (le_div_iff₀ hu).mp (projection B hB h u v hu)
  · intro h u v hu hv
    have hp := h u v hu
    rw [hv, zero_pow (by decide : (2 : ℕ) ≠ 0)] at hp
    nlinarith

theorem null_axis (B : Form X) (hB : Symmetric B)
    (hS : Signature B) (e w v : X)
    (hee : B e e = 0) (hew : B e w ≠ 0) (hve : B v e = 0) :
    B v v ≤ 0 := by
  by_contra hn
  have hv : 0 < B v v := lt_of_not_ge hn
  let c := B w v / B v v
  let w' := w - c • v
  have hwv : B w' v = 0 := by
    dsimp [w']
    simp only [map_sub, map_smul, LinearMap.sub_apply,
      LinearMap.smul_apply, smul_eq_mul]
    dsimp [c]
    field_simp
    <;> ring
  have hwe : B w' e ≠ 0 := by
    dsimp [w']
    simp only [map_sub, map_smul, LinearMap.sub_apply,
      LinearMap.smul_apply, smul_eq_mul, hve, mul_zero, sub_zero]
    simpa only [hB w e] using hew
  let t := (1 - B w' w') / (2 * B w' e)
  have ho : B (w' + t • e) v = 0 := by
    simp only [map_add, map_smul, LinearMap.add_apply,
      LinearMap.smul_apply, smul_eq_mul, hwv]
    rw [hB e v, hve]
    ring
  have hp := hS v (w' + t • e) hv ho
  have he : B (w' + t • e) (w' + t • e) = 1 := by
    simp only [map_add, map_smul, LinearMap.add_apply,
      LinearMap.smul_apply, smul_eq_mul, hee]
    rw [hB e w']
    dsimp [t]
    field_simp
    <;> ring
  rw [he] at hp
  norm_num at hp

def block (V : Form X) (S T : X →ₗ[ℝ] ℝ) (p q r : ℝ) :
    Form (X × ℝ × ℝ) :=
  LinearMap.mk₂ ℝ
    (fun x y => V x.1 y.1 + S x.1 * y.2.1 + S y.1 * x.2.1 +
      T x.1 * y.2.2 + T y.1 * x.2.2 +
      p * x.2.1 * y.2.1 + q * (x.2.1 * y.2.2 + x.2.2 * y.2.1) +
      r * x.2.2 * y.2.2)
    (by intros; simp [map_add, add_mul, mul_add]; ring)
    (by intros; simp [map_smul, smul_eq_mul]; ring)
    (by intros; simp [map_add, add_mul, mul_add]; ring)
    (by intros; simp [map_smul, smul_eq_mul]; ring)

theorem block_symmetric (V : Form X) (hV : Symmetric V)
    (S T : X →ₗ[ℝ] ℝ) (p q r : ℝ) :
    Symmetric (block V S T p q r) := by
  intro x y
  simp only [block, LinearMap.mk₂_apply]
  rw [hV x.1 y.1]
  ring

theorem local_energy (V : Form X) (S T : X →ₗ[ℝ] ℝ)
    (p q r g₀ g g₁ : ℝ) (a : X)
    (hN : Signature (block V S T p q r))
    (hp : 0 ≤ p) (hr : 0 ≤ r)
    (hpos : 0 < p ∨ 0 < r ∨ 0 < q)
    (hS : S a = q * g - p * g₀)
    (hT : T a = r * g₁ - q * g) :
    V a a + 2 * q * g ^ 2 - p * g₀ ^ 2 - r * g₁ ^ 2 ≤ 0 := by
  by_cases hpp : 0 < p
  · have hs : block V S T p q r (0, 1, 0) (0, 1, 0) = p := by
      simp [block]
    have ho : block V S T p q r (a, g₀, -g) (0, 1, 0) = 0 := by
      simp [block, hS]
    have hn := hN (0, 1, 0) (a, g₀, -g) (by rwa [hs]) ho
    simp only [block, LinearMap.mk₂_apply] at hn
    rw [hS, hT] at hn
    nlinarith [mul_nonneg hr (sq_nonneg (g - g₁))]
  · by_cases hrr : 0 < r
    · have hs : block V S T p q r (0, 0, 1) (0, 0, 1) = r := by
        simp [block]
      have ho : block V S T p q r (a, g, -g₁) (0, 0, 1) = 0 := by
        simp [block, hT]
      have hn := hN (0, 0, 1) (a, g, -g₁) (by rwa [hs]) ho
      simp only [block, LinearMap.mk₂_apply] at hn
      rw [hS, hT] at hn
      nlinarith [mul_nonneg hp (sq_nonneg (g - g₀))]
    · have hp0 : p = 0 := le_antisymm (le_of_not_gt hpp) hp
      have hr0 : r = 0 := le_antisymm (le_of_not_gt hrr) hr
      have hq : 0 < q := by rcases hpos with h | h | h <;> linarith
      subst p
      subst r
      have hs : 0 < block V S T 0 q 0 (0, 1, 1) (0, 1, 1) := by
        simpa [block] using (show 0 < 2 * q by linarith)
      have ho : block V S T 0 q 0 (a, g, -g) (0, 1, 1) = 0 := by
        simp [block, hS, hT]
      have hn := hN (0, 1, 1) (a, g, -g) hs ho
      simp only [block, LinearMap.mk₂_apply] at hn
      rw [hS, hT] at hn
      nlinarith

theorem sum_energy (E : ℕ → ℝ) (M : ℕ)
    (h0 : E 0 = 0) (hM : E M = 0) (hM1 : E (M + 1) = 0) :
    ∑ k ∈ range (M + 1), (2 * E k - E (k - 1) - E (k + 1)) = 0 := by
  have hp : (∑ k ∈ range (M + 1), E (k - 1)) =
      ∑ k ∈ range (M + 1), E k := by
    rw [sum_range_succ', sum_range_succ]
    simp [h0, hM]
  have hn : (∑ k ∈ range (M + 1), E (k + 1)) =
      ∑ k ∈ range (M + 1), E k := by
    have hs := sum_range_succ' E (M + 1)
    rw [sum_range_succ, hM1, h0] at hs
    linarith
  simp only [sum_sub_distrib]
  rw [← mul_sum, hp, hn]
  ring

theorem chain_closure (M : ℕ) (hM : 2 ≤ M)
    (V : ℕ → Form X) (hV : ∀ k, Symmetric (V k))
    (S : ℕ → X →ₗ[ℝ] ℝ) (u : ℕ → ℝ)
    (hu0 : u 0 = 0) (huM : u M = 0) (huM1 : u (M + 1) = 0)
    (hupos : ∀ k, 0 < k → k < M → 0 < u k)
    (hSM : S M = 0)
    (hN : ∀ k, k ≤ M →
      Signature (block (V k) (if k = 0 then 0 else S (k - 1)) (S k)
        (u (k - 1)) (u k) (u (k + 1)))) :
    Signature (∑ k ∈ range (M + 1), V k) := by
  apply signature_of_kernel _ (by
    intro a b
    simp only [LinearMap.sum_apply]
    exact sum_congr rfl fun k _ => hV k a b) (∑ l ∈ range M, S l)
  intro a ha
  have htotal : (∑ l ∈ range M, S l a) = 0 := by
    simpa only [LinearMap.sum_apply] using ha
  let g : ℕ → ℝ := fun k => (∑ l ∈ range k, S l a) / u k
  have hcum : ∀ k, k ≤ M → u k * g k = ∑ l ∈ range k, S l a := by
    intro k hk
    by_cases h0 : k = 0
    · subst k
      simp [g, hu0]
    · by_cases hm : k = M
      · subst k
        simp [g, huM, htotal]
      · have hp := hupos k (Nat.pos_of_ne_zero h0) (lt_of_le_of_ne hk hm)
        dsimp [g]
        field_simp
  have hright : ∀ k, k ≤ M →
      S k a = u (k + 1) * g (k + 1) - u k * g k := by
    intro k hk
    by_cases hm : k = M
    · subst k
      simp [hSM, huM, huM1]
    · rw [hcum (k + 1) (by omega), hcum k hk, sum_range_succ]
      ring
  have hleft : ∀ k, k ≤ M →
      (if k = 0 then 0 else S (k - 1)) a =
        u k * g k - u (k - 1) * g (k - 1) := by
    intro k hk
    by_cases h0 : k = 0
    · subst k
      simp [hu0]
    · simp only [if_neg h0]
      have hh := hright (k - 1) (by omega)
      rw [show k - 1 + 1 = k by omega] at hh
      exact hh
  have hunonneg : ∀ k, k ≤ M + 1 → 0 ≤ u k := by
    intro k hk
    by_cases h0 : k = 0
    · simpa [h0, hu0]
    by_cases hm : k = M
    · simpa [hm, huM]
    by_cases hm1 : k = M + 1
    · simpa [hm1, huM1]
    exact le_of_lt (hupos k (by omega) (by omega))
  have henergy : ∀ k, k ≤ M →
      V k a a + 2 * u k * g k ^ 2 -
        u (k - 1) * g (k - 1) ^ 2 -
        u (k + 1) * g (k + 1) ^ 2 ≤ 0 := by
    intro k hk
    apply local_energy _ _ _ _ _ _ _ _ _ a (hN k hk)
      (hunonneg (k - 1) (by omega)) (hunonneg (k + 1) (by omega))
      _ (hleft k hk) (hright k hk)
    by_cases h0 : k = 0
    · right; left
      subst k
      exact hupos 1 (by omega) (by omega)
    by_cases hm : k = M
    · left
      subst k
      exact hupos (M - 1) (by omega) (by omega)
    right; right
    exact hupos k (by omega) (by omega)
  have hs := sum_nonpos fun k hk => henergy k (Nat.le_of_lt_succ (mem_range.mp hk))
  let E : ℕ → ℝ := fun k => u k * g k ^ 2
  have hcancel := sum_energy E M (by simp [E, hu0])
    (by simp [E, huM]) (by simp [E, huM1])
  have heq : (∑ k ∈ range (M + 1),
      (V k a a + 2 * u k * g k ^ 2 -
        u (k - 1) * g (k - 1) ^ 2 -
        u (k + 1) * g (k + 1) ^ 2)) =
      (∑ k ∈ range (M + 1), V k a a) +
        ∑ k ∈ range (M + 1), (2 * E k - E (k - 1) - E (k + 1)) := by
    rw [← sum_add_distrib]
    apply sum_congr rfl
    intro k hk
    dsimp [E]
    ring
  rw [heq, hcancel, add_zero] at hs
  simpa only [LinearMap.sum_apply] using hs

theorem capacity_one_closure (V₀ V₁ : Form X)
    (hV₀ : Symmetric V₀) (hV₁ : Symmetric V₁)
    (S : X →ₗ[ℝ] ℝ)
    (hN₀ : Signature (block V₀ 0 S 0 0 0))
    (hN₁ : Signature (block V₁ S 0 0 0 0))
    (hzero : S = 0 → V₀ = 0 ∧ V₁ = 0) :
    Signature (V₀ + V₁) := by
  by_cases hS : S = 0
  · obtain ⟨h0, h1⟩ := hzero hS
    subst V₀
    subst V₁
    intro u v hu hv
    simpa using hu
  · have hw : ∃ w, S w ≠ 0 := by
      by_contra hn
      apply hS
      ext w
      simpa using not_exists.mp hn w
    obtain ⟨w, hw⟩ := hw
    apply signature_of_kernel _ (by
      intro a b
      simp only [LinearMap.add_apply, hV₀ a b, hV₁ a b]) S
    intro a ha
    have h0 := null_axis (block V₀ 0 S 0 0 0)
      (block_symmetric _ hV₀ _ _ _ _ _) hN₀ (0, 0, 1) (w, 0, 0) (a, 0, 0)
      (by simp [block]) (by simpa [block] using hw) (by simpa [block] using ha)
    have h1 := null_axis (block V₁ S 0 0 0 0)
      (block_symmetric _ hV₁ _ _ _ _ _) hN₁ (0, 1, 0) (w, 0, 0) (a, 0, 0)
      (by simp [block]) (by simpa [block] using hw) (by simpa [block] using ha)
    simp only [block, LinearMap.mk₂_apply] at h0 h1
    simp only [LinearMap.add_apply]
    nlinarith

section Boxes

variable {I : Type*} [Fintype I] [DecidableEq I]

abbrev Profile (I : Type*) := I → ℤ

def Box (m : I → ℕ) (z : Profile I) : Prop :=
  ∀ i, 0 ≤ z i ∧ z i ≤ m i

def remove (z : Profile I) (i : I) : Profile I :=
  fun j => z j - if j = i then 1 else 0

theorem remove_comm (z : Profile I) (i j : I) :
    remove (remove z i) j = remove (remove z j) i := by
  funext k
  simp only [remove]
  ring

theorem total_remove (z : Profile I) (i : I) :
    ∑ j, remove z i j = (∑ j, z j) - 1 := by
  simp [remove, sum_sub_distrib]

theorem box_remove (m : I → ℕ) (z : Profile I) (hz : Box m z)
    (i : I) (hi : 0 < z i) : Box m (remove z i) := by
  intro j
  by_cases hj : j = i
  · subst j
    have := hz i
    simp only [remove, if_pos rfl]
    omega
  · simpa only [remove, if_neg hj, sub_zero] using hz j

def test (F : Profile I → ℝ) (z : Profile I) : Form (I → ℝ) :=
  Matrix.toBilin' (fun i j => F (remove (remove z i) j))

theorem test_symmetric (F : Profile I → ℝ) (z : Profile I) :
    Symmetric (test F z) := by
  intro a b
  simp only [test, Matrix.toBilin'_apply]
  rw [sum_comm]
  apply sum_congr rfl
  intro j hj
  apply sum_congr rfl
  intro i hi
  rw [remove_comm z i j]
  ring

def column (c : I → ℝ) : (I → ℝ) →ₗ[ℝ] ℝ where
  toFun a := ∑ i, a i * c i
  map_add' a b := by simp [add_mul, sum_add_distrib]
  map_smul' c a := by simp [smul_eq_mul, ← mul_sum, mul_assoc]

theorem column_single (c : I → ℝ) (i : I) :
    column c (Pi.single i 1) = c i := by
  simp [column, Pi.single_apply]

def RemovalSignature (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) : Prop :=
  ∀ z, Box m z → (∑ i, z i) = r + 2 → Signature (test F z)

def PairValid (m : I → ℕ) (M : ℕ) (r : ℤ)
    (z : Profile I) (x y : ℤ) : Prop :=
  Box m z ∧ 0 ≤ x ∧ x ≤ M ∧ 0 ≤ y ∧ y ≤ M ∧ (∑ i, z i) + x + y = r

def PairPositive (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) : Prop :=
  ∀ z x y, PairValid m M r z x y → 0 < F z x y

def PairSupported (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) : Prop :=
  ∀ z x y, ¬ PairValid m M r z x y → F z x y = 0

def pairTest (F : Profile I → ℤ → ℤ → ℝ) (z : Profile I) (x y : ℤ) :
    Form ((I → ℝ) × ℝ × ℝ) :=
  block (test (fun w => F w x y) z)
    (column (fun i => F (remove z i) (x - 1) y))
    (column (fun i => F (remove z i) x (y - 1)))
    (F z (x - 2) y) (F z (x - 1) (y - 1)) (F z x (y - 2))

def PairRemovalSignature (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) : Prop :=
  ∀ (z : Profile I) (x y : ℤ), Box m z → 0 ≤ x → x ≤ M → 0 ≤ y → y ≤ M →
    (∑ i, z i) + x + y = r + 2 → Signature (pairTest F z x y)

def balanced (F : Profile I → ℤ → ℤ → ℝ) (M : ℕ) (z : Profile I) : ℝ :=
  ∑ k ∈ range (M + 1), F z k ((M : ℤ) - k)

def oldBlock (F : Profile I → ℤ → ℤ → ℝ) (z : Profile I) (M k : ℕ) :=
  test (fun w => F w k ((M : ℤ) - k)) z

def crossColumn (F : Profile I → ℤ → ℤ → ℝ) (z : Profile I) (M l : ℕ) :=
  column (fun i => F (remove z i) l ((M : ℤ) - 1 - l))

def interiorWeight (F : Profile I → ℤ → ℤ → ℝ) (z : Profile I) (M k : ℕ) :=
  F z ((k : ℤ) - 1) ((M : ℤ) - 1 - k)

theorem supported_left (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hs : PairSupported F m M r)
    (z : Profile I) (x y : ℤ) (hx : x < 0) : F z x y = 0 := by
  apply hs
  intro ⟨_, h, _, _, _, _⟩
  omega

theorem supported_right (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hs : PairSupported F m M r)
    (z : Profile I) (x y : ℤ) (hy : y < 0) : F z x y = 0 := by
  apply hs
  intro ⟨_, _, _, h, _, _⟩
  omega

theorem chain_boundaries (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hs : PairSupported F m M r)
    (z : Profile I) :
    interiorWeight F z M 0 = 0 ∧ interiorWeight F z M M = 0 ∧
      interiorWeight F z M (M + 1) = 0 ∧ crossColumn F z M M = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact supported_left F m M r hs z _ _ (by simp)
  · exact supported_right F m M r hs z _ _ (by omega)
  · exact supported_right F m M r hs z _ _ (by omega)
  · have hh : ∀ i, F (remove z i) M ((M : ℤ) - 1 - M) = 0 :=
      fun i => supported_right F m M r hs _ _ _ (by omega)
    apply LinearMap.ext
    intro a
    change (∑ i, a i * F (remove z i) M ((M : ℤ) - 1 - M)) = 0
    simp only [hh, mul_zero, sum_const_zero]

theorem pairTest_chain (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hs : PairSupported F m M r)
    (z : Profile I) (k : ℕ) :
    pairTest F z k ((M : ℤ) - k) =
      block (oldBlock F z M k)
        (if k = 0 then 0 else crossColumn F z M (k - 1))
        (crossColumn F z M k)
        (interiorWeight F z M (k - 1))
        (interiorWeight F z M k) (interiorWeight F z M (k + 1)) := by
  have hl : column (fun i => F (remove z i) ((k : ℤ) - 1) ((M : ℤ) - k)) =
      (if k = 0 then 0 else crossColumn F z M (k - 1)) := by
    by_cases hk : k = 0
    · subst k
      have hh : ∀ i, F (remove z i) (-1) M = 0 :=
        fun i => supported_left F m M r hs _ _ _ (by norm_num)
      simp only [Nat.cast_zero, zero_sub, sub_zero, if_pos rfl]
      apply LinearMap.ext
      intro a
      change (∑ i, a i * F (remove z i) (-1) M) = 0
      simp only [hh, mul_zero, sum_const_zero]
    · have hpred : ((k - 1 : ℕ) : ℤ) = (k : ℤ) - 1 := by omega
      rw [if_neg hk]
      unfold crossColumn
      congr 1
      funext i
      rw [hpred]
      congr 1
      ring
  have ht : column (fun i => F (remove z i) k ((M : ℤ) - k - 1)) =
      crossColumn F z M k := by
    unfold crossColumn
    congr 1
    funext i
    congr 1
    ring
  have hp : F z ((k : ℤ) - 2) ((M : ℤ) - k) =
      interiorWeight F z M (k - 1) := by
    by_cases hk : k = 0
    · subst k
      rw [supported_left F m M r hs z _ _ (by norm_num)]
      exact (supported_left F m M r hs z _ _ (by norm_num)).symm
    · have hpred : ((k - 1 : ℕ) : ℤ) = (k : ℤ) - 1 := by omega
      unfold interiorWeight
      rw [hpred]
      congr 1 <;> ring
  have hq : F z ((k : ℤ) - 1) ((M : ℤ) - k - 1) =
      interiorWeight F z M k := by
    unfold interiorWeight
    congr 1
    ring
  have hr : F z k ((M : ℤ) - k - 2) =
      interiorWeight F z M (k + 1) := by
    unfold interiorWeight
    push_cast
    congr 1 <;> ring
  unfold pairTest
  rw [hl, ht, hp, hq, hr]
  rfl

theorem balanced_test (F : Profile I → ℤ → ℤ → ℝ)
    (z : Profile I) (M : ℕ) :
    test (balanced F M) z = ∑ k ∈ range (M + 1), oldBlock F z M k := by
  simp only [test, balanced, oldBlock]
  have hh : ((fun i j => ∑ k ∈ range (M + 1),
      F (remove (remove z i) j) k ((M : ℤ) - k)) : Matrix I I ℝ) =
      ∑ k ∈ range (M + 1),
        (fun i j => F (remove (remove z i) j) k ((M : ℤ) - k)) := by
    ext i j
    simp
  rw [hh]
  exact map_sum (Matrix.toBilin' : Matrix I I ℝ ≃ₗ[ℝ] Form (I → ℝ))
    (fun k : ℕ => (fun i j => F (remove (remove z i) j) k ((M : ℤ) - k) :
      Matrix I I ℝ)) (range (M + 1))

theorem one_pair_removal (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hM : 1 ≤ M)
    (hpos : PairPositive F m M r) (hs : PairSupported F m M r)
    (hSig : PairRemovalSignature F m M r) :
    RemovalSignature (balanced F M) m (r - M) := by
  intro z hz htotal
  have hn : ∀ k, k ≤ M →
      Signature (block (oldBlock F z M k)
        (if k = 0 then 0 else crossColumn F z M (k - 1))
        (crossColumn F z M k)
        (interiorWeight F z M (k - 1))
        (interiorWeight F z M k) (interiorWeight F z M (k + 1))) := by
    intro k hk
    rw [← pairTest_chain F m M r hs z k]
    apply hSig z k ((M : ℤ) - k) hz <;> omega
  obtain ⟨hu0, huM, huM1, hSM⟩ := chain_boundaries F m M r hs z
  rw [balanced_test]
  by_cases htwo : 2 ≤ M
  · apply chain_closure M htwo (oldBlock F z M)
      (fun k => test_symmetric _ _) (crossColumn F z M) (interiorWeight F z M)
      hu0 huM huM1 _ hSM hn
    intro k hk0 hkM
    apply hpos
    refine ⟨hz, ?_, ?_, ?_, ?_, ?_⟩ <;> omega
  · have hMone : M = 1 := by omega
    subst M
    have hN0 := hn 0 (by omega)
    have hN1 := hn 1 (by omega)
    simp only [show (1 + 1 : ℕ) = 2 from rfl, sum_range_succ, sum_range_zero,
      zero_add]
    have hN0' : Signature (block (oldBlock F z 1 0) 0 (crossColumn F z 1 0)
        0 0 0) := by
      simpa [hu0, huM] using hN0
    have hN1' : Signature (block (oldBlock F z 1 1) (crossColumn F z 1 0) 0
        0 0 0) := by
      simpa only [if_neg (by decide : (1 : ℕ) ≠ 0), Nat.sub_self, hu0, huM,
        huM1, hSM] using hN1
    apply capacity_one_closure _ _ (test_symmetric _ _) (test_symmetric _ _)
      (crossColumn F z 1 0) hN0' hN1'
    intro hcol
    have hcoeff : ∀ i, F (remove z i) 0 0 = 0 := by
      intro i
      have hh := congrArg (fun L : (I → ℝ) →ₗ[ℝ] ℝ => L (Pi.single i 1)) hcol
      simpa only [crossColumn, column_single, Nat.cast_zero, Int.cast_ofNat_Int,
        sub_self, sub_zero, LinearMap.zero_apply] using hh
    have hz0 : ∀ i, z i = 0 := by
      intro i
      by_contra hi
      have hip : 0 < z i := lt_of_le_of_ne (hz i).1 (Ne.symm hi)
      have hp : 0 < F (remove z i) 0 0 := by
        apply hpos
        refine ⟨box_remove m z hz i hip, by omega, by omega,
          by omega, by omega, ?_⟩
        rw [total_remove]
        omega
      rw [hcoeff i] at hp
      linarith
    have hzero : ∀ k, oldBlock F z 1 k = 0 := by
      intro k
      have hentry : ∀ i j, F (remove (remove z i) j) k ((1 : ℤ) - k) = 0 := by
        intro i j
        apply hs
        intro hv
        have hh := (hv.1 i).1
        simp only [remove, hz0, if_pos rfl] at hh
        split_ifs at hh <;> omega
      have hm : ((fun i j => F (remove (remove z i) j) k ((1 : ℤ) - k)) :
          Matrix I I ℝ) = 0 := by
        ext i j
        exact hentry i j
      change Matrix.toBilin' ((fun i j => F (remove (remove z i) j) k
        ((1 : ℤ) - k)) : Matrix I I ℝ) = 0
      rw [hm]
      exact (Matrix.toBilin' : Matrix I I ℝ ≃ₗ[ℝ] Form (I → ℝ)).map_zero
    exact ⟨hzero 0, hzero 1⟩

theorem balanced_positive (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hp : PairPositive F m M r)
    (z : Profile I) (hz : Box m z) (ht : (∑ i, z i) = r - M) :
    0 < balanced F M z := by
  apply sum_pos
  · intro k hk
    apply hp
    have hk' := mem_range.mp hk
    refine ⟨hz, ?_, ?_, ?_, ?_, ?_⟩ <;> omega
  · exact ⟨0, mem_range.mpr (by omega)⟩

theorem balanced_supported (F : Profile I → ℤ → ℤ → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hs : PairSupported F m M r)
    (z : Profile I) (hz : ¬ (Box m z ∧ (∑ i, z i) = r - M)) :
    balanced F M z = 0 := by
  apply sum_eq_zero
  intro k hk
  apply hs
  intro hv
  apply hz
  exact ⟨hv.1, by have := hv.2.2.2.2.2; omega⟩

def join {A : Type*} (z : I → A) (x y : A) : (I ⊕ Bool) → A :=
  Sum.elim z (fun b => if b then y else x)

theorem total_join (z : Profile I) (x y : ℤ) :
    (∑ i, join z x y i) = (∑ i, z i) + x + y := by
  simp [join, Fintype.sum_sum_type, Fintype.sum_bool]
  ring

theorem box_join (m : I → ℕ) (M : ℕ) (z : Profile I) (x y : ℤ) :
    Box (join m M M) (join z x y) ↔
      Box m z ∧ 0 ≤ x ∧ x ≤ M ∧ 0 ≤ y ∧ y ≤ M := by
  constructor
  · intro h
    exact ⟨fun i => h (Sum.inl i), (h (Sum.inr false)).1,
      (h (Sum.inr false)).2, (h (Sum.inr true)).1, (h (Sum.inr true)).2⟩
  · rintro ⟨hz, hx0, hxM, hy0, hyM⟩ i
    rcases i with i | b
    · exact hz i
    · cases b
      · exact ⟨hx0, hxM⟩
      · exact ⟨hy0, hyM⟩

@[simp] theorem remove_join_old (z : Profile I) (x y : ℤ) (i : I) :
    remove (join z x y) (Sum.inl i) = join (remove z i) x y := by
  funext j
  rcases j with j | b
  · simp [remove, join]
  · cases b <;> simp [remove, join]

@[simp] theorem remove_join_false (z : Profile I) (x y : ℤ) :
    remove (join z x y) (Sum.inr false) = join z (x - 1) y := by
  funext j
  rcases j with j | b
  · simp [remove, join]
  · cases b <;> simp [remove, join]

@[simp] theorem remove_join_true (z : Profile I) (x y : ℤ) :
    remove (join z x y) (Sum.inr true) = join z x (y - 1) := by
  funext j
  rcases j with j | b
  · simp [remove, join]
  · cases b <;> simp [remove, join]

theorem test_join (F : Profile (I ⊕ Bool) → ℝ) (z : Profile I) (x y : ℤ)
    (a b : (I → ℝ) × ℝ × ℝ) :
    pairTest (fun w p q => F (join w p q)) z x y a b =
      test F (join z x y) (join a.1 a.2.1 a.2.2) (join b.1 b.2.1 b.2.2) := by
  have hr (c v : I → ℝ) (t : ℝ) :
      (∑ i, v i * c i * t) = column c v * t := by
    change (∑ i, v i * c i * t) = (∑ i, v i * c i) * t
    rw [sum_mul]
  have hl (c v : I → ℝ) (t : ℝ) :
      (∑ i, t * c i * v i) = column c v * t := by
    change (∑ i, t * c i * v i) = (∑ i, v i * c i) * t
    rw [sum_mul]
    apply sum_congr rfl
    intro i hi
    ring
  simp only [pairTest, block, LinearMap.mk₂_apply, test, Matrix.toBilin'_apply,
    Fintype.sum_sum_type, Fintype.sum_bool, remove_join_old, remove_join_true,
    remove_join_false]
  simp only [show x - 1 - 1 = x - 2 by ring, show y - 1 - 1 = y - 2 by ring]
  simp only [join, Sum.elim_inl, Sum.elim_inr, Bool.false_eq_true,
    if_false, if_true]
  simp only [mul_add, sum_add_distrib, hl, hr]
  ring

def Positive (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) : Prop :=
  ∀ z, Box m z → (∑ i, z i) = r → 0 < F z

def Supported (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) : Prop :=
  ∀ z, ¬ (Box m z ∧ (∑ i, z i) = r) → F z = 0

theorem balanced_removal_box (F : Profile (I ⊕ Bool) → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hM : 1 ≤ M)
    (hp : Positive F (join m M M) r)
    (hs : Supported F (join m M M) r)
    (hSig : RemovalSignature F (join m M M) r) :
    Positive (balanced (fun w x y => F (join w x y)) M) m (r - M) ∧
      Supported (balanced (fun w x y => F (join w x y)) M) m (r - M) ∧
      RemovalSignature (balanced (fun w x y => F (join w x y)) M) m (r - M) := by
  let G := fun w x y => F (join w x y)
  have hGp : PairPositive G m M r := by
    rintro z x y ⟨hz, hx0, hxM, hy0, hyM, ht⟩
    apply hp _ ((box_join _ _ _ _ _).mpr ⟨hz, hx0, hxM, hy0, hyM⟩)
    rwa [total_join]
  have hGs : PairSupported G m M r := by
    intro z x y hv
    apply hs
    rintro ⟨hb, ht⟩
    obtain ⟨hz, hx0, hxM, hy0, hyM⟩ := (box_join _ _ _ _ _).mp hb
    apply hv
    exact ⟨hz, hx0, hxM, hy0, hyM, by rwa [total_join] at ht⟩
  have hGr : PairRemovalSignature G m M r := by
    intro z x y hz hx0 hxM hy0 hyM ht
    have h := hSig (join z x y)
      ((box_join _ _ _ _ _).mpr ⟨hz, hx0, hxM, hy0, hyM⟩) (by rwa [total_join])
    intro a b ha hb
    have ha' : 0 < test F (join z x y)
        (join a.1 a.2.1 a.2.2) (join a.1 a.2.1 a.2.2) := by
      rw [← test_join F z x y a a]
      exact ha
    have hb' : test F (join z x y)
        (join b.1 b.2.1 b.2.2) (join a.1 a.2.1 a.2.2) = 0 := by
      rw [← test_join F z x y b a]
      exact hb
    have hc := h _ _ ha' hb'
    rwa [← test_join F z x y b b] at hc
  exact ⟨fun z hz ht => balanced_positive G m M r hGp z hz ht,
    fun z hz => balanced_supported G m M r hGs z hz,
    one_pair_removal G m M r hM hGp hGs hGr⟩

def boxTotal (m : I → ℕ) : ℤ := ∑ i, (m i : ℤ)

def reflectProfile (m : I → ℕ) (z : Profile I) : Profile I :=
  fun i => (m i : ℤ) - z i

def reflectWeight (F : Profile I → ℝ) (m : I → ℕ) : Profile I → ℝ :=
  fun z => F (reflectProfile m z)

@[simp] theorem reflect_involution (m : I → ℕ) (z : Profile I) :
    reflectProfile m (reflectProfile m z) = z := by
  funext i
  simp [reflectProfile]

theorem reflect_box (m : I → ℕ) (z : Profile I) :
    Box m (reflectProfile m z) ↔ Box m z := by
  constructor <;> intro h i <;> have := h i <;> dsimp [reflectProfile] at * <;> omega

theorem reflect_total (m : I → ℕ) (z : Profile I) :
    (∑ i, reflectProfile m z i) = boxTotal m - ∑ i, z i := by
  simp [reflectProfile, boxTotal, sum_sub_distrib]

theorem positive_reflection (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) :
    Positive (reflectWeight F m) m (boxTotal m - r) ↔ Positive F m r := by
  constructor
  · intro h z hz ht
    have hh := h (reflectProfile m z) ((reflect_box m z).mpr hz)
      (by rw [reflect_total, ht])
    simpa [reflectWeight] using hh
  · intro h z hz ht
    apply h _ ((reflect_box m z).mpr hz)
    rw [reflect_total]
    omega

theorem supported_reflection (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) :
    Supported (reflectWeight F m) m (boxTotal m - r) ↔ Supported F m r := by
  constructor
  · intro h z hz
    have hh := h (reflectProfile m z) (by
      intro ⟨hb, ht⟩
      apply hz
      refine ⟨(reflect_box m z).mp hb, ?_⟩
      rw [reflect_total] at ht
      omega)
    simpa [reflectWeight] using hh
  · intro h z hz
    apply h
    intro ⟨hb, ht⟩
    apply hz
    refine ⟨(reflect_box m z).mp hb, ?_⟩
    rw [reflect_total] at ht
    omega

def addUnit (z : Profile I) (i : I) : Profile I :=
  fun j => z j + if j = i then 1 else 0

def additionTest (F : Profile I → ℝ) (z : Profile I) : Form (I → ℝ) :=
  Matrix.toBilin' (fun i j => F (addUnit (addUnit z i) j))

def AdditionSignature (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) : Prop :=
  ∀ z, Box m z → (∑ i, z i) = r - 2 → Signature (additionTest F z)

theorem reflect_remove (m : I → ℕ) (z : Profile I) (i : I) :
    reflectProfile m (remove z i) = addUnit (reflectProfile m z) i := by
  funext j
  simp only [reflectProfile, remove, addUnit]
  ring

theorem reflection_test (F : Profile I → ℝ) (m : I → ℕ) (z : Profile I) :
    test (reflectWeight F m) z = additionTest F (reflectProfile m z) := by
  unfold test additionTest
  congr 1
  ext i j
  simp only [reflectWeight, reflect_remove]

theorem signature_reflection (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) :
    RemovalSignature (reflectWeight F m) m (boxTotal m - r) ↔
      AdditionSignature F m r := by
  constructor
  · intro h z hz ht
    have hh := h (reflectProfile m z) ((reflect_box m z).mpr hz)
      (by rw [reflect_total]; omega)
    simpa only [reflection_test, reflect_involution] using hh
  · intro h z hz ht
    rw [reflection_test]
    apply h _ ((reflect_box m z).mpr hz)
    rw [reflect_total]
    omega

theorem reflect_join (m : I → ℕ) (M : ℕ) (z : Profile I) (x y : ℤ) :
    reflectProfile (join m M M) (join z x y) =
      join (reflectProfile m z) ((M : ℤ) - x) ((M : ℤ) - y) := by
  funext i
  rcases i with i | b
  · rfl
  · cases b <;> rfl

theorem boxTotal_join (m : I → ℕ) (M : ℕ) :
    boxTotal (join m M M) = boxTotal m + 2 * M := by
  simp [boxTotal, join, Fintype.sum_sum_type, Fintype.sum_bool]

theorem balanced_reflection (F : Profile (I ⊕ Bool) → ℝ)
    (m : I → ℕ) (M : ℕ) :
    reflectWeight (balanced (fun w x y => F (join w x y)) M) m =
      balanced (fun w x y => reflectWeight F (join m M M) (join w x y)) M := by
  funext z
  unfold reflectWeight balanced
  apply sum_bij (fun k _ => M - k)
  · intro k hk
    exact mem_range.mpr (by omega)
  · intro k hk l hl hkl
    have := mem_range.mp hk
    have := mem_range.mp hl
    omega
  · intro k hk
    have hk' := mem_range.mp hk
    refine ⟨M - k, mem_range.mpr (by omega), ?_⟩
    omega
  · intro k hk
    have hk' := mem_range.mp hk
    dsimp only
    rw [reflect_join]
    have hc : ((M - k : ℕ) : ℤ) = (M : ℤ) - k := by omega
    rw [hc]
    congr 1
    congr 1 <;> ring

theorem balanced_addition_box (F : Profile (I ⊕ Bool) → ℝ)
    (m : I → ℕ) (M : ℕ) (r : ℤ) (hM : 1 ≤ M)
    (hp : Positive F (join m M M) r)
    (hs : Supported F (join m M M) r)
    (hSig : AdditionSignature F (join m M M) r) :
    Positive (balanced (fun w x y => F (join w x y)) M) m (r - M) ∧
      Supported (balanced (fun w x y => F (join w x y)) M) m (r - M) ∧
      AdditionSignature (balanced (fun w x y => F (join w x y)) M) m (r - M) := by
  have hr := balanced_removal_box (reflectWeight F (join m M M)) m M
    (boxTotal (join m M M) - r) hM
    ((positive_reflection F _ r).mpr hp) ((supported_reflection F _ r).mpr hs)
    ((signature_reflection F _ r).mpr hSig)
  have ht : boxTotal (join m M M) - r - M = boxTotal m - (r - M) := by
    rw [boxTotal_join]
    ring
  rw [ht, ← balanced_reflection F m M] at hr
  exact ⟨(positive_reflection _ m (r - M)).mp hr.1,
    (supported_reflection _ m (r - M)).mp hr.2.1,
    (signature_reflection _ m (r - M)).mp hr.2.2⟩

end Boxes

universe u

def PairIndex (I : Type u) : List ℕ → Type u
  | [] => I
  | _ :: Ms => PairIndex I Ms ⊕ Bool

instance pairIndexFintype (I : Type u) [Fintype I] :
    (Ms : List ℕ) → Fintype (PairIndex I Ms)
  | [] => inferInstanceAs (Fintype I)
  | _ :: Ms => by
    letI := pairIndexFintype I Ms
    exact inferInstanceAs (Fintype (PairIndex I Ms ⊕ Bool))

instance pairIndexDecidableEq (I : Type u) [DecidableEq I] :
    (Ms : List ℕ) → DecidableEq (PairIndex I Ms)
  | [] => inferInstanceAs (DecidableEq I)
  | _ :: Ms => by
    letI := pairIndexDecidableEq I Ms
    exact inferInstanceAs (DecidableEq (PairIndex I Ms ⊕ Bool))

def pairCaps {I : Type u} (m : I → ℕ) :
    (Ms : List ℕ) → PairIndex I Ms → ℕ
  | [] => m
  | M :: Ms => join (pairCaps m Ms) M M

def sumPairs {I : Type u} (Ms : List ℕ) :
    (Profile (PairIndex I Ms) → ℝ) → Profile I → ℝ :=
  match Ms with
  | [] => fun F => F
  | M :: Ms => fun F => sumPairs Ms (balanced (fun w x y => F (join w x y)) M)

theorem balanced_pairs_removal {I : Type u} [Fintype I] [DecidableEq I]
    (m : I → ℕ) (Ms : List ℕ) (hMs : ∀ M ∈ Ms, 1 ≤ M) :
    ∀ (F : Profile (PairIndex I Ms) → ℝ) (r : ℤ),
    Positive F (pairCaps m Ms) r →
    Supported F (pairCaps m Ms) r →
    RemovalSignature F (pairCaps m Ms) r →
    Positive (sumPairs Ms F) m (r - Ms.sum) ∧
      Supported (sumPairs Ms F) m (r - Ms.sum) ∧
      RemovalSignature (sumPairs Ms F) m (r - Ms.sum) := by
  induction Ms with
  | nil =>
    intro F r hp hs hSig
    refine ⟨?_, ?_, ?_⟩
    · intro z hz ht
      apply hp z hz
      change (∑ i : I, z i) = r
      simpa using ht
    · intro z hz
      apply hs z
      change ¬ (Box m z ∧ (∑ i : I, z i) = r)
      simpa using hz
    · intro z hz ht
      apply hSig z hz
      change (∑ i : I, z i) = r + 2
      simpa using ht
  | cons M Ms ih =>
    intro F r hp hs hSig
    have hM : 1 ≤ M := hMs M (by simp)
    have htail : ∀ N ∈ Ms, 1 ≤ N := fun N hN => hMs N (by simp [hN])
    have h := balanced_removal_box F (pairCaps m Ms) M r hM hp hs hSig
    have ht := ih htail _ (r - M) h.1 h.2.1 h.2.2
    have he : r - (M : ℤ) - (Ms.sum : ℤ) = r - ((M :: Ms).sum : ℤ) := by
      simp
      ring
    simpa only [sumPairs, he] using ht

theorem balanced_pairs_addition {I : Type u} [Fintype I] [DecidableEq I]
    (m : I → ℕ) (Ms : List ℕ) (hMs : ∀ M ∈ Ms, 1 ≤ M) :
    ∀ (F : Profile (PairIndex I Ms) → ℝ) (r : ℤ),
    Positive F (pairCaps m Ms) r →
    Supported F (pairCaps m Ms) r →
    AdditionSignature F (pairCaps m Ms) r →
    Positive (sumPairs Ms F) m (r - Ms.sum) ∧
      Supported (sumPairs Ms F) m (r - Ms.sum) ∧
      AdditionSignature (sumPairs Ms F) m (r - Ms.sum) := by
  induction Ms with
  | nil =>
    intro F r hp hs hSig
    refine ⟨?_, ?_, ?_⟩
    · intro z hz ht
      apply hp z hz
      change (∑ i : I, z i) = r
      simpa using ht
    · intro z hz
      apply hs z
      change ¬ (Box m z ∧ (∑ i : I, z i) = r)
      simpa using hz
    · intro z hz ht
      apply hSig z hz
      change (∑ i : I, z i) = r - 2
      simpa using ht
  | cons M Ms ih =>
    intro F r hp hs hSig
    have hM : 1 ≤ M := hMs M (by simp)
    have htail : ∀ N ∈ Ms, 1 ≤ N := fun N hN => hMs N (by simp [hN])
    have h := balanced_addition_box F (pairCaps m Ms) M r hM hp hs hSig
    have ht := ih htail _ (r - M) h.1 h.2.1 h.2.2
    have he : r - (M : ℤ) - (Ms.sum : ℤ) = r - ((M :: Ms).sum : ℤ) := by
      simp
      ring
    simpa only [sumPairs, he] using ht

section Fixing

variable {I J : Type*} [Fintype I] [Fintype J] [DecidableEq I] [DecidableEq J]

@[simp] theorem remove_sumElim (z : Profile I) (w : Profile J) (i : I) :
    remove (Sum.elim z w) (Sum.inl i) = Sum.elim (remove z i) w := by
  funext k
  rcases k with k | k <;> simp [remove]

@[simp] theorem add_sumElim (z : Profile I) (w : Profile J) (i : I) :
    addUnit (Sum.elim z w) (Sum.inl i) = Sum.elim (addUnit z i) w := by
  funext k
  rcases k with k | k <;> simp [addUnit]

theorem fixing_test (F : Profile (I ⊕ J) → ℝ)
    (z : Profile I) (w : Profile J) (a b : I → ℝ) :
    test (fun v => F (Sum.elim v w)) z a b =
      test F (Sum.elim z w) (Sum.elim a (fun _ => 0)) (Sum.elim b (fun _ => 0)) := by
  simp [test, Matrix.toBilin'_apply, Fintype.sum_sum_type]

theorem fixing_addition_test (F : Profile (I ⊕ J) → ℝ)
    (z : Profile I) (w : Profile J) (a b : I → ℝ) :
    additionTest (fun v => F (Sum.elim v w)) z a b =
      additionTest F (Sum.elim z w)
        (Sum.elim a (fun _ => 0)) (Sum.elim b (fun _ => 0)) := by
  simp [additionTest, Matrix.toBilin'_apply, Fintype.sum_sum_type]

theorem fixing_box (m : I → ℕ) (n : J → ℕ)
    (z : Profile I) (w : Profile J) (hz : Box m z) (hw : Box n w) :
    Box (Sum.elim m n) (Sum.elim z w) := by
  intro i
  rcases i with i | i
  · exact hz i
  · exact hw i

theorem fixing_positive (F : Profile (I ⊕ J) → ℝ)
    (m : I → ℕ) (n : J → ℕ) (w : Profile J) (r : ℤ)
    (hw : Box n w) (hp : Positive F (Sum.elim m n) r) :
    Positive (fun z => F (Sum.elim z w)) m (r - ∑ j, w j) := by
  intro z hz ht
  apply hp _ (fixing_box m n z w hz hw)
  simp only [Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr]
  omega

theorem fixing_supported (F : Profile (I ⊕ J) → ℝ)
    (m : I → ℕ) (n : J → ℕ) (w : Profile J) (r : ℤ)
    (hs : Supported F (Sum.elim m n) r) :
    Supported (fun z => F (Sum.elim z w)) m (r - ∑ j, w j) := by
  intro z hz
  apply hs
  rintro ⟨hb, ht⟩
  apply hz
  refine ⟨fun i => hb (Sum.inl i), ?_⟩
  simp only [Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr] at ht
  omega

theorem fixing_removal_signature (F : Profile (I ⊕ J) → ℝ)
    (m : I → ℕ) (n : J → ℕ) (w : Profile J) (r : ℤ)
    (hw : Box n w) (hSig : RemovalSignature F (Sum.elim m n) r) :
    RemovalSignature (fun z => F (Sum.elim z w)) m (r - ∑ j, w j) := by
  intro z hz ht
  have h := hSig (Sum.elim z w) (fixing_box m n z w hz hw) (by
    simp only [Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr]
    omega)
  intro a b ha hb
  have hc := h (Sum.elim a (fun _ => 0)) (Sum.elim b (fun _ => 0))
    (by rwa [← fixing_test F z w a a]) (by rwa [← fixing_test F z w b a])
  rwa [← fixing_test F z w b b] at hc

theorem fixing_addition_signature (F : Profile (I ⊕ J) → ℝ)
    (m : I → ℕ) (n : J → ℕ) (w : Profile J) (r : ℤ)
    (hw : Box n w) (hSig : AdditionSignature F (Sum.elim m n) r) :
    AdditionSignature (fun z => F (Sum.elim z w)) m (r - ∑ j, w j) := by
  intro z hz ht
  have h := hSig (Sum.elim z w) (fixing_box m n z w hz hw) (by
    simp only [Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr]
    omega)
  intro a b ha hb
  have hc := h (Sum.elim a (fun _ => 0)) (Sum.elim b (fun _ => 0))
    (by rwa [← fixing_addition_test F z w a a])
    (by rwa [← fixing_addition_test F z w b a])
  rwa [← fixing_addition_test F z w b b] at hc

end Fixing

theorem signature_comp_equiv {Y : Type*} [AddCommGroup Y] [Module ℝ Y]
    (B : Form Y) (L : X ≃ₗ[ℝ] Y) :
    Signature (B.comp L.toLinearMap L.toLinearMap) ↔ Signature B := by
  constructor
  · intro h u v hu hv
    have hh := h (L.symm u) (L.symm v)
      (by simpa using hu) (by simpa using hv)
    simpa using hh
  · intro h u v hu hv
    exact h (L u) (L v) hu hv

section Spectral

variable {I : Type*} [Fintype I] [DecidableEq I]

theorem diagonal_eval (d : I → ℝ) (a b : I → ℝ) :
    Matrix.toBilin' (Matrix.diagonal d) a b = ∑ i, a i * d i * b i := by
  simp [Matrix.toBilin'_apply, Matrix.diagonal]

theorem diagonal_symmetric (d : I → ℝ) :
    Symmetric (Matrix.toBilin' (Matrix.diagonal d)) := by
  intro a b
  rw [diagonal_eval, diagonal_eval]
  apply sum_congr rfl
  intro i hi
  ring

theorem diagonal_signature (d : I → ℝ) :
    Signature (Matrix.toBilin' (Matrix.diagonal d)) ↔
      ∀ i j, 0 < d i → 0 < d j → i = j := by
  constructor
  · intro h i j hi hj
    by_contra hij
    have huu : 0 < Matrix.toBilin' (Matrix.diagonal d) (Pi.single i 1) (Pi.single i 1) := by
      simpa [diagonal_eval, Pi.single_apply] using hi
    have huv : Matrix.toBilin' (Matrix.diagonal d) (Pi.single j 1) (Pi.single i 1) = 0 := by
      simp [diagonal_eval, Pi.single_apply, hij, Ne.symm hij]
    have hn := h _ _ huu huv
    have hjj : Matrix.toBilin' (Matrix.diagonal d) (Pi.single j 1) (Pi.single j 1) = d j := by
      simp [diagonal_eval, Pi.single_apply]
    rw [hjj] at hn
    linarith
  · intro h
    by_cases hex : ∃ i, 0 < d i
    · obtain ⟨i, hi⟩ := hex
      apply signature_of_kernel _ (diagonal_symmetric d) (LinearMap.proj i)
      intro a ha
      change a i = 0 at ha
      rw [diagonal_eval]
      apply sum_nonpos
      intro j hj
      by_cases hji : j = i
      · subst j
        simp [ha]
      · have hd : d j ≤ 0 := by
          by_contra hn
          exact hji (h j i (lt_of_not_ge hn) hi)
        have hh := mul_nonpos_of_nonpos_of_nonneg hd (sq_nonneg (a j))
        nlinarith
    · apply signature_of_kernel _ (diagonal_symmetric d) 0
      intro a ha
      rw [diagonal_eval]
      apply sum_nonpos
      intro j hj
      have hd : d j ≤ 0 := le_of_not_gt (fun h => hex ⟨j, h⟩)
      have hh := mul_nonpos_of_nonpos_of_nonneg hd (sq_nonneg (a j))
      nlinarith

theorem matrix_bilin_mulVec (A : Matrix I I ℝ) (x y : I → ℝ) :
    Matrix.toBilin' A x y = dotProduct x (A.mulVec y) := by
  simp [Matrix.toBilin'_apply, Matrix.mulVec, dotProduct, mul_sum, mul_assoc]

theorem signature_iff_eigenvalues (A : Matrix I I ℝ) (hA : A.IsHermitian) :
    Signature (Matrix.toBilin' A) ↔
      ∀ i j, 0 < hA.eigenvalues i → 0 < hA.eigenvalues j → i = j := by
  let e := hA.eigenvectorBasis.toBasis.map (EuclideanSpace.equiv I ℝ).toLinearEquiv
  let L : (I → ℝ) ≃ₗ[ℝ] (I → ℝ) := e.equivFun.symm
  have hL : ∀ i, L (Pi.single i 1) = (hA.eigenvectorBasis i).ofLp := by
    intro i
    dsimp [L]
    rw [Module.Basis.equivFun_symm_apply]
    simp [Pi.single_apply, e, Module.Basis.map_apply, EuclideanSpace.equiv]
    rfl
  have hinner : ∀ i j,
      (∑ k, (hA.eigenvectorBasis i).ofLp k * (hA.eigenvectorBasis j).ofLp k) =
        if i = j then 1 else 0 := by
    intro i j
    have hh := (orthonormal_iff_ite.mp hA.eigenvectorBasis.orthonormal) j i
    simpa [EuclideanSpace.inner_eq_star_dotProduct, dotProduct, eq_comm] using hh
  have hb : ∀ i j,
      Matrix.toBilin' A (hA.eigenvectorBasis i).ofLp (hA.eigenvectorBasis j).ofLp =
        if i = j then hA.eigenvalues i else 0 := by
    intro i j
    rw [matrix_bilin_mulVec, hA.mulVec_eigenvectorBasis j]
    simp only [dotProduct, Pi.smul_apply, smul_eq_mul]
    have he : (∑ k, (hA.eigenvectorBasis i).ofLp k *
        (hA.eigenvalues j * (hA.eigenvectorBasis j).ofLp k)) =
        hA.eigenvalues j *
          ∑ k, (hA.eigenvectorBasis i).ofLp k * (hA.eigenvectorBasis j).ofLp k := by
      rw [mul_sum]
      apply sum_congr rfl
      intro k hk
      ring
    rw [he, hinner]
    by_cases hij : i = j
    · subst j
      simp
    · simp [hij]
  have hdiag : (Matrix.toBilin' A).comp L.toLinearMap L.toLinearMap =
      Matrix.toBilin' (Matrix.diagonal hA.eigenvalues) := by
    apply LinearMap.BilinForm.ext_basis (Pi.basisFun ℝ I)
    intro i j
    simp only [LinearMap.BilinForm.comp_apply, Pi.basisFun_apply,
      LinearEquiv.coe_coe]
    rw [hL, hL, hb]
    by_cases hij : i = j
    · subst j
      simp [diagonal_eval, Pi.single_apply]
    · simp [diagonal_eval, Pi.single_apply, hij, Ne.symm hij]
  have hc := signature_comp_equiv (Matrix.toBilin' A) L
  rw [hdiag] at hc
  exact hc.symm.trans (diagonal_signature hA.eigenvalues)

theorem removal_matrix_hermitian (F : Profile I → ℝ) (z : Profile I) :
    Matrix.IsHermitian (fun i j => F (remove (remove z i) j) : Matrix I I ℝ) := by
  change Matrix.conjTranspose _ = _
  ext i j
  simp [Matrix.conjTranspose_apply, remove_comm z i j]

theorem addUnit_comm (z : Profile I) (i j : I) :
    addUnit (addUnit z i) j = addUnit (addUnit z j) i := by
  funext k
  simp only [addUnit]
  ring

theorem addition_matrix_hermitian (F : Profile I → ℝ) (z : Profile I) :
    Matrix.IsHermitian (fun i j => F (addUnit (addUnit z i) j) : Matrix I I ℝ) := by
  change Matrix.conjTranspose _ = _
  ext i j
  simp [Matrix.conjTranspose_apply, addUnit_comm z i j]

def SpectralRemovalSignature (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) : Prop :=
  ∀ z, Box m z → (∑ i, z i) = r + 2 →
    ∀ (i j : I), 0 < (removal_matrix_hermitian F z).eigenvalues i →
      0 < (removal_matrix_hermitian F z).eigenvalues j → i = j

def SpectralAdditionSignature (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) : Prop :=
  ∀ z, Box m z → (∑ i, z i) = r - 2 →
    ∀ (i j : I), 0 < (addition_matrix_hermitian F z).eigenvalues i →
      0 < (addition_matrix_hermitian F z).eigenvalues j → i = j

theorem removal_signature_spectral_iff (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) :
    RemovalSignature F m r ↔ SpectralRemovalSignature F m r := by
  constructor
  · intro h z hz ht
    exact (signature_iff_eigenvalues _ (removal_matrix_hermitian F z)).mp (h z hz ht)
  · intro h z hz ht
    exact (signature_iff_eigenvalues _ (removal_matrix_hermitian F z)).mpr (h z hz ht)

theorem addition_signature_spectral_iff (F : Profile I → ℝ) (m : I → ℕ) (r : ℤ) :
    AdditionSignature F m r ↔ SpectralAdditionSignature F m r := by
  constructor
  · intro h z hz ht
    exact (signature_iff_eigenvalues _ (addition_matrix_hermitian F z)).mp (h z hz ht)
  · intro h z hz ht
    exact (signature_iff_eigenvalues _ (addition_matrix_hermitian F z)).mpr (h z hz ht)

end Spectral

theorem balanced_pairs_removal_spectral {I : Type u} [Fintype I] [DecidableEq I]
    (m : I → ℕ) (Ms : List ℕ) (hMs : ∀ M ∈ Ms, 1 ≤ M)
    (F : Profile (PairIndex I Ms) → ℝ) (r : ℤ)
    (hp : Positive F (pairCaps m Ms) r) (hs : Supported F (pairCaps m Ms) r)
    (hSig : SpectralRemovalSignature F (pairCaps m Ms) r) :
    Positive (sumPairs Ms F) m (r - Ms.sum) ∧
      Supported (sumPairs Ms F) m (r - Ms.sum) ∧
      SpectralRemovalSignature (sumPairs Ms F) m (r - Ms.sum) := by
  have h := balanced_pairs_removal m Ms hMs F r hp hs
    ((removal_signature_spectral_iff F _ r).mpr hSig)
  exact ⟨h.1, h.2.1, (removal_signature_spectral_iff _ _ _).mp h.2.2⟩

theorem balanced_pairs_addition_spectral {I : Type u} [Fintype I] [DecidableEq I]
    (m : I → ℕ) (Ms : List ℕ) (hMs : ∀ M ∈ Ms, 1 ≤ M)
    (F : Profile (PairIndex I Ms) → ℝ) (r : ℤ)
    (hp : Positive F (pairCaps m Ms) r) (hs : Supported F (pairCaps m Ms) r)
    (hSig : SpectralAdditionSignature F (pairCaps m Ms) r) :
    Positive (sumPairs Ms F) m (r - Ms.sum) ∧
      Supported (sumPairs Ms F) m (r - Ms.sum) ∧
      SpectralAdditionSignature (sumPairs Ms F) m (r - Ms.sum) := by
  have h := balanced_pairs_addition m Ms hMs F r hp hs
    ((addition_signature_spectral_iff F _ r).mpr hSig)
  exact ⟨h.1, h.2.1, (addition_signature_spectral_iff _ _ _).mp h.2.2⟩

theorem fixing_removal_spectral {I J : Type*} [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J] (F : Profile (I ⊕ J) → ℝ)
    (m : I → ℕ) (n : J → ℕ) (w : Profile J) (r : ℤ)
    (hw : Box n w) (hSig : SpectralRemovalSignature F (Sum.elim m n) r) :
    SpectralRemovalSignature (fun z => F (Sum.elim z w)) m (r - ∑ j, w j) := by
  apply (removal_signature_spectral_iff _ _ _).mp
  exact fixing_removal_signature F m n w r hw
    ((removal_signature_spectral_iff _ _ _).mpr hSig)

theorem fixing_addition_spectral {I J : Type*} [Fintype I] [Fintype J]
    [DecidableEq I] [DecidableEq J] (F : Profile (I ⊕ J) → ℝ)
    (m : I → ℕ) (n : J → ℕ) (w : Profile J) (r : ℤ)
    (hw : Box n w) (hSig : SpectralAdditionSignature F (Sum.elim m n) r) :
    SpectralAdditionSignature (fun z => F (Sum.elim z w)) m (r - ∑ j, w j) := by
  apply (addition_signature_spectral_iff _ _ _).mp
  exact fixing_addition_signature F m n w r hw
    ((addition_signature_spectral_iff _ _ _).mpr hSig)

end BalancedSummation

#print axioms BalancedSummation.balanced_pairs_removal_spectral
#print axioms BalancedSummation.balanced_pairs_addition_spectral
#print axioms BalancedSummation.fixing_removal_spectral
#print axioms BalancedSummation.fixing_addition_spectral
