import Mathlib

open scoped BigOperators

namespace QuenchedRigidity

def dot {A : Type*} [Fintype A] (x y : A → ℝ) : ℝ :=
  ∑ a, x a * y a

def tensor {S C : Type*} (a : S → ℝ) (u : C → ℝ) : S → C → ℝ :=
  fun s c => a s * u c

def pairing {S C : Type*} [Fintype S] [Fintype C]
    (x y : S → C → ℝ) : ℝ :=
  ∑ s, ∑ c, x s c * y s c

def basis {C : Type*} [DecidableEq C] (c : C) : C → ℝ :=
  fun j => if j = c then 1 else 0

theorem dot_basis {C : Type*} [Fintype C] [DecidableEq C]
    (u : C → ℝ) (c : C) : dot u (basis c) = u c := by
  simp [dot, basis, mul_ite]

theorem pairing_tensor {S C : Type*} [Fintype S] [Fintype C]
    (a b : S → ℝ) (u v : C → ℝ) :
    pairing (tensor a u) (tensor b v) = dot a b * dot u v := by
  unfold pairing tensor dot
  calc
    (∑ s, ∑ c, (a s * u c) * (b s * v c)) =
        ∑ s, ∑ c, (a s * b s) * (u c * v c) := by
      apply Finset.sum_congr rfl
      intro s _
      apply Finset.sum_congr rfl
      intro c _
      ring
    _ = (∑ s, a s * b s) * (∑ c, u c * v c) := by
      simp_rw [← Finset.mul_sum]
      rw [Finset.sum_mul]

theorem block_pair_identity {S C I : Type*} [Fintype S] [Fintype C]
    (H : (S → C → ℝ) →ₗ[ℝ] (S → C → ℝ))
    (a : I → S → ℝ)
    (D : I → (C → ℝ) →ₗ[ℝ] (C → ℝ))
    (hsym : ∀ x y, pairing (H x) y = pairing x (H y))
    (hblock : ∀ i u, H (tensor (a i) u) = tensor (a i) (D i u))
    (i j : I) (u v : C → ℝ) :
    dot (a i) (a j) * dot (D i u) v =
      dot (a i) (a j) * dot u (D j v) := by
  have h := hsym (tensor (a i) u) (tensor (a j) v)
  rw [hblock i u, hblock j v, pairing_tensor, pairing_tensor] at h
  exact h

theorem color_blocks_agree {S C I : Type*} [Fintype S] [Fintype C]
    [DecidableEq C]
    (H : (S → C → ℝ) →ₗ[ℝ] (S → C → ℝ))
    (a : I → S → ℝ)
    (D : I → (C → ℝ) →ₗ[ℝ] (C → ℝ))
    (hsym : ∀ x y, pairing (H x) y = pairing x (H y))
    (hblock : ∀ i u, H (tensor (a i) u) = tensor (a i) (D i u))
    (hnonzero : ∀ i j, dot (a i) (a j) ≠ 0) :
    ∀ i j, D i = D j := by
  intro i j
  apply LinearMap.ext
  intro u
  funext c
  have hij := block_pair_identity H a D hsym hblock i j u (basis c)
  have hjj := block_pair_identity H a D hsym hblock j j u (basis c)
  have h₁ := mul_left_cancel₀ (hnonzero i j) hij
  have h₂ := mul_left_cancel₀ (hnonzero j j) hjj
  simpa only [dot_basis] using h₁.trans h₂.symm

theorem common_block_on_sums {S C I : Type*}
    [Fintype S] [Fintype C] [Fintype I] [DecidableEq C]
    (H : (S → C → ℝ) →ₗ[ℝ] (S → C → ℝ))
    (a : I → S → ℝ)
    (D : I → (C → ℝ) →ₗ[ℝ] (C → ℝ))
    (hsym : ∀ x y, pairing (H x) y = pairing x (H y))
    (hblock : ∀ i u, H (tensor (a i) u) = tensor (a i) (D i u))
    (hnonzero : ∀ i j, dot (a i) (a j) ≠ 0)
    (i₀ : I) (u : I → C → ℝ) :
    H (∑ i, tensor (a i) (u i)) =
      ∑ i, tensor (a i) (D i₀ (u i)) := by
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [hblock i (u i), color_blocks_agree H a D hsym hblock hnonzero i i₀]

def edgeDiscriminant (b c u v : ℝ) : ℝ :=
  (1 - c * u + b * v) ^ 2 + (c * v + b * u) ^ 2

theorem one_sided_determinant (b c : ℝ) :
    (c ^ 2 + b ^ 2) * 1 - c * c = b ^ 2 := by
  ring

theorem one_sided_positive (b c z x : ℝ) (hb : 0 < b)
    (hnonzero : z ≠ 0 ∨ x ≠ 0) :
    0 < ((x + c * z) ^ 2 + (b * z) ^ 2) / b := by
  apply div_pos _ hb
  by_cases hz : z = 0
  · have hx : x ≠ 0 := hnonzero.resolve_left (not_not.mpr hz)
    simpa [hz] using sq_pos_of_ne_zero hx
  · exact add_pos_of_nonneg_of_pos (sq_nonneg _)
      (sq_pos_of_ne_zero (mul_ne_zero (ne_of_gt hb) hz))

theorem edge_determinant_scaled (b c u v : ℝ) :
    (v * (c ^ 2 + b ^ 2) + b) * (v + b * (u ^ 2 + v ^ 2)) -
      (v * c + b * u) ^ 2 = b * v * edgeDiscriminant b c u v := by
  unfold edgeDiscriminant
  ring

theorem edge_discriminant_gap (b c u v : ℝ) :
    edgeDiscriminant b c u v =
      4 * b * v + (1 - c * u - b * v) ^ 2 + (c * v - b * u) ^ 2 := by
  unfold edgeDiscriminant
  ring

theorem edge_discriminant_positive (b c u v : ℝ)
    (hb : 0 < b) (hv : 0 < v) : 0 < edgeDiscriminant b c u v := by
  rw [edge_discriminant_gap]
  positivity

theorem residual_pair_gap (B x y : ℝ) :
    (B - x) * (B - y) - x * y = B * (B - x - y) := by
  ring

theorem residual_pair_gap_positive (B x y : ℝ)
    (hB : 0 < B) (hrest : 0 < B - x - y) :
    0 < (B - x) * (B - y) - x * y := by
  rw [residual_pair_gap]
  positivity

theorem residual_off_diagonal_negative (B x y : ℝ)
    (hB : 0 < B) (hx : 0 < x) (hy : 0 < y) : -(x * y) / B < 0 := by
  exact div_neg_of_neg_of_pos (neg_neg_of_pos (mul_pos hx hy)) hB

theorem star_rank_one_scalar (S b P t : ℝ)
    (hB : S + b ≠ 0) (hb : b ≠ 0) (hP : P ≠ 0) :
    (S + b) / P * (1 + (t ^ 2 / (S + b) + S) / b) =
      (t ^ 2 + (S + b) ^ 2) / (P * b) := by
  field_simp [hB, hb, hP]
  ring

theorem edge_hessian_entry_constant {X : Type*}
    (r q : ℝ) (hq : q ≠ 0) (H : X → ℝ) (B D : ℝ)
    (h : ∀ x, q ^ 2 * H x + r ^ 2 * B = D) :
    ∀ x y, H x = H y := by
  intro x y
  have heq : q ^ 2 * H x = q ^ 2 * H y := by
    linarith [h x, h y]
  exact mul_left_cancel₀ (pow_ne_zero 2 hq) heq

theorem edge_hessian_constant {X C : Type*}
    (r q : ℝ) (hq : q ≠ 0)
    (H : X → C → C → ℝ) (B D : C → C → ℝ)
    (h : ∀ x i j, q ^ 2 * H x i j + r ^ 2 * B i j = D i j) :
    ∀ x y, H x = H y := by
  intro x y
  funext i j
  exact edge_hessian_entry_constant r q hq (fun z => H z i j)
    (B i j) (D i j) (fun z => h z i j) x y

theorem edge_covariance_swap_entry (r q S₀ C₀ S₁ C₁ : ℝ)
    (hq : q ≠ 0) (hnorm : r ^ 2 + q ^ 2 = 1)
    (hcross : r * S₀ = r * S₁)
    (hleft : S₀ = r ^ 2 * S₁ + q ^ 2 * C₁)
    (hright : S₁ = r ^ 2 * S₀ + q ^ 2 * C₀) :
    C₀ = S₁ ∧ C₁ = S₀ := by
  have h₀ : q ^ 2 * C₀ = q ^ 2 * S₁ := by
    linear_combination - hright - S₁ * hnorm - r * hcross
  have h₁ : q ^ 2 * C₁ = q ^ 2 * S₀ := by
    linear_combination - hleft - S₀ * hnorm + r * hcross
  exact ⟨mul_left_cancel₀ (pow_ne_zero 2 hq) h₀,
    mul_left_cancel₀ (pow_ne_zero 2 hq) h₁⟩

theorem edge_covariance_swap {C : Type*}
    (r q : ℝ) (hq : q ≠ 0) (hnorm : r ^ 2 + q ^ 2 = 1)
    (S₀ C₀ S₁ C₁ : C → C → ℝ)
    (hcross : ∀ i j, r * S₀ i j = r * S₁ i j)
    (hleft : ∀ i j, S₀ i j = r ^ 2 * S₁ i j + q ^ 2 * C₁ i j)
    (hright : ∀ i j, S₁ i j = r ^ 2 * S₀ i j + q ^ 2 * C₀ i j) :
    C₀ = S₁ ∧ C₁ = S₀ := by
  constructor
  · funext i j
    exact (edge_covariance_swap_entry r q (S₀ i j) (C₀ i j) (S₁ i j)
      (C₁ i j) hq hnorm (hcross i j) (hleft i j) (hright i j)).1
  · funext i j
    exact (edge_covariance_swap_entry r q (S₀ i j) (C₀ i j) (S₁ i j)
      (C₁ i j) hq hnorm (hcross i j) (hleft i j) (hright i j)).2

theorem two_step_covariance {V A : Type*} (adj : V → V → Prop)
    (S C : V → A)
    (hswap : ∀ u v, adj u v → C u = S v)
    (u v w : V) (huv : adj u v) (huw : adj u w) : S v = S w := by
  exact (hswap u v huv).symm.trans (hswap u w huw)

theorem covariance_normalization {C : Type*}
    (k : ℝ) (hk : k ≠ 0) (S Sigma : C → C → ℝ)
    (h : ∀ i j, k * S i j = Sigma i j) :
    S = fun i j => Sigma i j / k := by
  funext i j
  apply (eq_div_iff hk).2
  simpa [mul_comm] using h i j

end QuenchedRigidity
