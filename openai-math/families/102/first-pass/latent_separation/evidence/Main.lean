import Mathlib

namespace LatentSeparation

open Finset

noncomputable section

def expectation {Ω : Type*} [Fintype Ω] (w : Ω → ℚ) (f : Ω → ℚ) : ℚ :=
  ∑ ω, w ω * f ω

def indicator {Ω : Type*} (P : Ω → Prop) (ω : Ω) : ℚ := by
  classical
  exact if P ω then 1 else 0

def probability {Ω : Type*} [Fintype Ω] (w : Ω → ℚ) (P : Ω → Prop) : ℚ :=
  expectation w (indicator P)

lemma expectation_const {Ω : Type*} [Fintype Ω] (w : Ω → ℚ)
    (hw : ∑ ω, w ω = 1) (c : ℚ) :
    expectation w (fun _ => c) = c := by
  simp only [expectation, ← Finset.sum_mul, hw, one_mul]

lemma expectation_sub {Ω : Type*} [Fintype Ω] (w f g : Ω → ℚ) :
    expectation w (fun ω => f ω - g ω) = expectation w f - expectation w g := by
  simp [expectation, mul_sub, Finset.sum_sub_distrib]

lemma expectation_mul {Ω : Type*} [Fintype Ω] (w f : Ω → ℚ) (c : ℚ) :
    expectation w (fun ω => c * f ω) = c * expectation w f := by
  simp only [expectation, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ω _
  ring

lemma expectation_mono {Ω : Type*} [Fintype Ω] (w f g : Ω → ℚ)
    (hw : ∀ ω, 0 ≤ w ω) (hfg : ∀ ω, f ω ≤ g ω) :
    expectation w f ≤ expectation w g := by
  exact Finset.sum_le_sum fun ω _ => mul_le_mul_of_nonneg_left (hfg ω) (hw ω)

lemma expectation_sum {Ω : Type*} [Fintype Ω] (w : Ω → ℚ)
    (f : ℕ → Ω → ℚ) (s : ℕ) :
    expectation w (fun ω => ∑ j ∈ Finset.range s, f j ω) =
      ∑ j ∈ Finset.range s, expectation w (f j) := by
  simp only [expectation, Finset.mul_sum]
  exact Finset.sum_comm

lemma telescoping (f : ℕ → ℚ) (s : ℕ) :
    ∑ j ∈ Finset.range s, (f j - f (j + 1)) = f 0 - f s := by
  induction s with
  | zero => simp
  | succ s ih =>
    rw [Finset.sum_range_succ, ih]
    ring

def harmonic (r : ℕ) : ℚ := ∑ j ∈ Finset.range r, 1 / ((j : ℚ) + 1)

lemma harmonic_zero : harmonic 0 = 0 := by simp [harmonic]

lemma harmonic_succ (r : ℕ) :
    harmonic (r + 1) = harmonic r + 1 / ((r : ℚ) + 1) := by
  simp [harmonic, Finset.sum_range_succ]

lemma harmonic_nonneg (r : ℕ) : 0 ≤ harmonic r := by
  exact Finset.sum_nonneg fun j _ => by positivity

lemma harmonic_monotone : Monotone harmonic := by
  apply monotone_nat_of_le_succ
  intro r
  rw [harmonic_succ]
  have : 0 ≤ 1 / ((r : ℚ) + 1) := by positivity
  linarith

lemma harmonic_positive {r : ℕ} (hr : 0 < r) : 0 < harmonic r := by
  have h := harmonic_monotone (show 1 ≤ r by omega)
  have h1 : harmonic 1 = 1 := by norm_num [harmonic]
  rw [h1] at h
  linarith

theorem generic_harmonic_drop {Ω : Type*} [Fintype Ω]
    (w : Ω → ℚ) (hw : ∀ ω, 0 ≤ w ω)
    (r : ℕ) (hr : 0 < r) (nextRank : Ω → ℕ)
    (hnext : ∀ ω, nextRank ω ≤ r ∧ r ≤ nextRank ω + 1)
    (θ : ℚ) (hloss : probability w (fun ω => nextRank ω < r) ≤ 3 * (r : ℚ) * θ) :
    expectation w (fun ω => harmonic r - harmonic (nextRank ω)) ≤ 3 * θ := by
  classical
  have hrq : (r : ℚ) ≠ 0 := by exact_mod_cast (Nat.ne_zero_of_lt hr)
  have hpoint : (fun ω => harmonic r - harmonic (nextRank ω)) =
      (fun ω => (1 / (r : ℚ)) * indicator (fun ω => nextRank ω < r) ω) := by
    funext ω
    by_cases hlt : nextRank ω < r
    · have heq : r = nextRank ω + 1 := by obtain ⟨_, h⟩ := hnext ω; omega
      simp only [indicator, if_pos hlt, mul_one]
      rw [heq, harmonic_succ]
      push_cast
      ring
    · have heq : nextRank ω = r := by obtain ⟨h, _⟩ := hnext ω; omega
      simp [indicator, heq]
  rw [hpoint, expectation_mul]
  change (1 / (r : ℚ)) * probability w (fun ω => nextRank ω < r) ≤ 3 * θ
  calc
    _ ≤ (1 / (r : ℚ)) * (3 * (r : ℚ) * θ) :=
      mul_le_mul_of_nonneg_left hloss (by positivity)
    _ = _ := by field_simp

theorem arbitrary_harmonic_drop {Ω : Type*} [Fintype Ω]
    (w : Ω → ℚ) (hw : ∀ ω, 0 ≤ w ω) (r r₀ : ℕ) (hr : r ≤ r₀)
    (nextRank : Ω → ℕ) (hnext : ∀ ω, nextRank ω ≤ r)
    (θ : ℚ)
    (hloss : probability w (fun ω => nextRank ω < r) ≤ (2 : ℚ) ^ r₀ * θ) :
    expectation w (fun ω => harmonic r - harmonic (nextRank ω)) ≤
      harmonic r₀ * (2 : ℚ) ^ r₀ * θ := by
  classical
  have hpoint (ω : Ω) :
      harmonic r - harmonic (nextRank ω) ≤
        harmonic r₀ * indicator (fun ω => nextRank ω < r) ω := by
    by_cases hlt : nextRank ω < r
    · simp only [indicator, if_pos hlt, mul_one]
      have h := harmonic_monotone hr
      have hn := harmonic_nonneg (nextRank ω)
      linarith
    · have heq : nextRank ω = r := by have := hnext ω; omega
      simp [indicator, heq]
  calc
    _ ≤ expectation w
        (fun ω => harmonic r₀ * indicator (fun ω => nextRank ω < r) ω) :=
      expectation_mono _ _ _ hw hpoint
    _ = harmonic r₀ * probability w (fun ω => nextRank ω < r) := expectation_mul _ _ _
    _ ≤ harmonic r₀ * ((2 : ℚ) ^ r₀ * θ) :=
      mul_le_mul_of_nonneg_left hloss (harmonic_nonneg r₀)
    _ = _ := by ring

theorem adaptive_rank_survival {Ω : Type*} [Fintype Ω]
    (w : Ω → ℚ) (hw : ∀ ω, 0 ≤ w ω) (hnorm : ∑ ω, w ω = 1)
    (rank : ℕ → Ω → ℕ) (H : ℕ → ℚ) (r₀ s : ℕ)
    (hH : Monotone H) (hzero : H 0 = 0) (hpos : 0 < H r₀)
    (hroot : ∀ ω, rank 0 ω = r₀) (hterminal : ∀ ω, rank s ω ≤ r₀)
    (bad : ℕ → Ω → Prop) (θ K ε : ℚ)
    (hθ : 0 ≤ θ) (hK : 0 ≤ K) (hε : K * ε ≤ 1)
    (hbad : ∀ j < s, probability w (bad j) ≤ ε)
    (hdrop : ∀ j < s,
      expectation w (fun ω => H (rank j ω) - H (rank (j + 1) ω)) ≤
        3 * θ + K * θ * probability w (bad j))
    (hdepth : 8 * (s : ℚ) * θ ≤ H r₀)
    (detect : Ω → ℚ)
    (hleaf : ∀ ω, (if rank s ω = 0 then (0 : ℚ) else 1 / 2) ≤ detect ω) :
    probability w (fun ω => rank s ω = 0) ≤ 1 / 2 ∧
      1 / 4 ≤ expectation w detect := by
  classical
  have hstep (j : ℕ) (hj : j < s) :
      expectation w (fun ω => H (rank j ω) - H (rank (j + 1) ω)) ≤ 4 * θ := by
    have hb := mul_le_mul_of_nonneg_left (hbad j hj) (mul_nonneg hK hθ)
    have he := mul_le_mul_of_nonneg_right hε hθ
    nlinarith [hdrop j hj]
  have hsum :
      expectation w (fun ω => H r₀ - H (rank s ω)) ≤ (s : ℚ) * (4 * θ) := by
    have heq : (fun ω => H r₀ - H (rank s ω)) =
        (fun ω => ∑ j ∈ Finset.range s, (H (rank j ω) - H (rank (j + 1) ω))) := by
      funext ω
      rw [telescoping, hroot]
    rw [heq, expectation_sum]
    calc
      _ ≤ ∑ _j ∈ Finset.range s, (4 * θ) :=
        Finset.sum_le_sum fun j hj => hstep j (Finset.mem_range.mp hj)
      _ = _ := by simp
  have hloss :
      H r₀ * probability w (fun ω => rank s ω = 0) ≤
        expectation w (fun ω => H r₀ - H (rank s ω)) := by
    rw [probability, ← expectation_mul]
    apply expectation_mono _ _ _ hw
    intro ω
    by_cases hr : rank s ω = 0
    · simp [indicator, hr, hzero]
    · simp only [indicator, if_neg hr, mul_zero]
      exact sub_nonneg.mpr (hH (hterminal ω))
  have hext : probability w (fun ω => rank s ω = 0) ≤ 1 / 2 := by
    nlinarith
  refine ⟨hext, ?_⟩
  have hle := expectation_mono w
    (fun ω => if rank s ω = 0 then (0 : ℚ) else 1 / 2) detect hw hleaf
  have heq : (fun ω => if rank s ω = 0 then (0 : ℚ) else 1 / 2) =
      (fun ω => (1 / 2 : ℚ) * ((1 : ℚ) - indicator (fun ω => rank s ω = 0) ω)) := by
    funext ω
    by_cases hr : rank s ω = 0 <;> simp [indicator, hr]
  rw [heq, expectation_mul, expectation_sub, expectation_const w hnorm] at hle
  change (1 / 2 : ℚ) * (1 - probability w (fun ω => rank s ω = 0)) ≤
    expectation w detect at hle
  linarith

theorem probability_union_bound {Ω I : Type*} [Fintype Ω] [Fintype I]
    (w : Ω → ℚ) (hw : ∀ ω, 0 ≤ w ω) (P : I → Ω → Prop) :
    probability w (fun ω => ∃ i, P i ω) ≤ ∑ i, probability w (P i) := by
  classical
  have hpoint (ω : Ω) :
      indicator (fun ω => ∃ i, P i ω) ω ≤ ∑ i, indicator (P i) ω := by
    by_cases he : ∃ i, P i ω
    · obtain ⟨i, hi⟩ := he
      have h := Finset.single_le_sum (f := fun i => indicator (P i) ω)
        (fun j _ => by simp [indicator]; split_ifs <;> norm_num) (Finset.mem_univ i)
      calc
        indicator (fun ω => ∃ i, P i ω) ω = 1 := by
          simp only [indicator, if_pos (show ∃ i, P i ω from ⟨i, hi⟩)]
        _ = indicator (P i) ω := by simp only [indicator, if_pos hi]
        _ ≤ _ := h
    · simp only [indicator, if_neg he]
      exact Finset.sum_nonneg fun i _ => by
        split_ifs <;> norm_num
  calc
    _ ≤ expectation w (fun ω => ∑ i, indicator (P i) ω) :=
      expectation_mono _ _ _ hw hpoint
    _ = _ := by
      simp only [expectation, probability, Finset.mul_sum]
      exact Finset.sum_comm

theorem injection_failure_bound {Ω I : Type*} [Fintype Ω] [Fintype I]
    (w : Ω → ℚ) (hw : ∀ ω, 0 ≤ w ω) (P : I → Ω → Prop)
    (b : ℕ) (hcard : Fintype.card I ≤ 2 ^ b)
    (hmarginal : ∀ i, probability w (P i) ≤ 1 / (4 * (2 : ℚ) ^ b)) :
    probability w (fun ω => ∃ i, P i ω) ≤ 1 / 4 := by
  have hpow : 0 < (2 : ℚ) ^ b := by positivity
  have hcount : (Fintype.card I : ℚ) ≤ (2 : ℚ) ^ b := by exact_mod_cast hcard
  calc
    _ ≤ ∑ i, probability w (P i) := probability_union_bound w hw P
    _ ≤ ∑ _i : I, 1 / (4 * (2 : ℚ) ^ b) :=
      Finset.sum_le_sum fun i _ => hmarginal i
    _ = (Fintype.card I : ℚ) * (1 / (4 * (2 : ℚ) ^ b)) := by simp
    _ ≤ (2 : ℚ) ^ b * (1 / (4 * (2 : ℚ) ^ b)) :=
      mul_le_mul_of_nonneg_right hcount (by positivity)
    _ = 1 / 4 := by field_simp

theorem copy_average_detection {Ω : Type*} [Fintype Ω]
    (w : Ω → ℚ) (hw : ∀ ω, 0 ≤ w ω) (hnorm : ∑ ω, w ω = 1)
    (bad : Ω → Prop) (detect : Ω → ℚ)
    (hbad : probability w bad ≤ 1 / 4)
    (hdetect : ∀ ω, (1 / 4 : ℚ) * (1 - indicator bad ω) ≤ detect ω) :
    3 / 16 ≤ expectation w detect := by
  classical
  have hle := expectation_mono w
    (fun ω => (1 / 4 : ℚ) * (1 - indicator bad ω)) detect hw hdetect
  rw [expectation_mul, expectation_sub, expectation_const w hnorm] at hle
  change (1 / 4 : ℚ) * (1 - probability w bad) ≤ expectation w detect at hle
  linarith

section LinearFactorization

variable {F S T X B : Type*} [Field F]
  [AddCommGroup S] [Module F S] [AddCommGroup T] [Module F T]
  [AddCommGroup X] [Module F X] [AddCommGroup B] [Module F B]

theorem common_extension_map
    (aX : T →ₗ[F] X) (aB : T →ₗ[F] B) (haX : Function.Surjective aX)
    (characters : S →ₗ[F] (B →ₗ[F] F)) (forms : S →ₗ[F] (T →ₗ[F] F))
    (hcompatible : ∀ z t, aX t = 0 → forms z t = characters z (aB t)) :
    ∃ γ : S →ₗ[F] (X →ₗ[F] F),
      ∀ z t, forms z t = γ z (aX t) + characters z (aB t) := by
  obtain ⟨sec, hsec⟩ := aX.exists_rightInverse_of_surjective (LinearMap.range_eq_top.mpr haX)
  have hsec' : ∀ x, aX (sec x) = x := LinearMap.ext_iff.mp hsec
  let γ : S →ₗ[F] (X →ₗ[F] F) :=
    { toFun := fun z => (forms z - (characters z).comp aB).comp sec
      map_add' := by intros; ext; simp; ring
      map_smul' := by intros; ext; simp; ring }
  refine ⟨γ, ?_⟩
  intro z t
  have hk : aX (t - sec (aX t)) = 0 := by simp [hsec']
  have h := hcompatible z (t - sec (aX t)) hk
  simp only [map_sub] at h
  change forms z t =
    (forms z (sec (aX t)) - characters z (aB (sec (aX t)))) +
      characters z (aB t)
  linear_combination h

end LinearFactorization

section Quotients

variable {P V B R : Type*} [AddCommGroup P] [AddCommGroup V]
  [AddCommGroup B] [AddCommGroup R]

theorem shift_kernel_descent
    (q : P →+ V) (embed : B →+ V) (ι : R →+ P) (lam : R →+ B)
    (hq : Function.Surjective q) (hlam : Function.Surjective lam)
    (hinclude : Function.Injective ι)
    (hker : ∀ n, q n = 0 ↔ ∃ h, ι h = n ∧ lam h = 0)
    (hcompat : ∀ h, q (ι h) = embed (lam h))
    (C : P → B) (hequiv : ∀ x h, C (x + ι h) = C x + lam h) :
    Function.Injective embed ∧
      ∃ Cbar : V → B, (∀ x, Cbar (q x) = C x) ∧
        ∀ v b, Cbar (v + embed b) = Cbar v + b := by
  classical
  have hczero (b : B) (hb : embed b = 0) : b = 0 := by
    obtain ⟨h, rfl⟩ := hlam b
    obtain ⟨k, hk, hkzero⟩ := (hker (ι h)).mp ((hcompat h).trans hb)
    have hkh : k = h := hinclude hk
    simpa [hkh] using hkzero
  have hinj : Function.Injective embed := by
    intro a b hab
    apply sub_eq_zero.mp
    apply hczero
    simpa using congrArg (fun x => x - embed b) hab
  have hfibre (x y : P) (hxy : q x = q y) : C x = C y := by
    have hkq : q (x - y) = 0 := by simp [hxy]
    obtain ⟨h, hdiff, hzero⟩ := (hker (x - y)).mp hkq
    have heq := hequiv y h
    have hxyadd : y + ι h = x := by rw [hdiff]; abel
    rw [hxyadd, hzero, add_zero] at heq
    exact heq
  let Cbar : V → B := fun v => C (Classical.choose (hq v))
  have hbar (x : P) : Cbar (q x) = C x :=
    hfibre _ _ (Classical.choose_spec (hq (q x)))
  refine ⟨hinj, Cbar, hbar, ?_⟩
  intro v b
  obtain ⟨x, rfl⟩ := hq v
  obtain ⟨h, rfl⟩ := hlam b
  rw [← hcompat, ← map_add, hbar, hbar, hequiv]

end Quotients

#print axioms adaptive_rank_survival
#print axioms generic_harmonic_drop
#print axioms arbitrary_harmonic_drop
#print axioms injection_failure_bound
#print axioms copy_average_detection
#print axioms common_extension_map
#print axioms shift_kernel_descent

end

end LatentSeparation
