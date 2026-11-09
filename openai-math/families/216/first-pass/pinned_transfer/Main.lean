import Mathlib

open scoped BigOperators

namespace PinnedTransfer

noncomputable def gram {M : Type*} [DecidableEq M] (x y : M) : ℝ :=
  if x = y then 1 else 0

theorem two_sample_gram
    {I M : Type*} [Fintype I] [DecidableEq I] [DecidableEq M]
    (old fresh : I → M)
    (ho : Function.Injective old) (hf : Function.Injective fresh)
    (hsep : ∀ i j, fresh i ≠ old j) (a : I → ℝ) :
    (∑ i, ∑ j, a i * a j *
      (gram (fresh i) (fresh j) - gram (fresh i) (old j) -
        gram (old i) (fresh j) + gram (old i) (old j))) =
      2 * ∑ i, a i ^ 2 := by
  classical
  have kernel (i j : I) :
      gram (fresh i) (fresh j) - gram (fresh i) (old j) -
        gram (old i) (fresh j) + gram (old i) (old j) =
        if i = j then 2 else 0 := by
    by_cases hij : i = j
    · subst j
      have hos : old i ≠ fresh i := Ne.symm (hsep i i)
      norm_num [gram, hsep, hos]
    · have hfo : fresh i ≠ fresh j := fun h => hij (hf h)
      have hoo : old i ≠ old j := fun h => hij (ho h)
      have hos : old i ≠ fresh j := Ne.symm (hsep j i)
      simp [gram, hij, hfo, hoo, hos, hsep]
  simp_rw [kernel]
  have inner (i : I) :
      (∑ j, a i * a j * (if i = j then (2 : ℝ) else 0)) =
        2 * a i ^ 2 := by
    calc
      _ = a i * a i * 2 := by
        rw [Finset.sum_eq_single i]
        · simp
        · intro j _ hji
          simp [Ne.symm hji]
        · simp
      _ = 2 * a i ^ 2 := by ring
  simp_rw [inner]
  exact (Finset.mul_sum _ _ _).symm

def oldMask {C : Type*} [DecidableEq C] (s : Finset C) :
    Finset (C × Bool) :=
  s.image (fun c => (c, false))

def freshMask {C : Type*} [DecidableEq C] (large s : Finset C) :
    Finset (C × Bool) :=
  s.image (fun c => (c, decide (c ∈ large)))

theorem oldMask_injective {C : Type*} [DecidableEq C] :
    Function.Injective (@oldMask C _) := by
  intro s t h
  have hp := congrArg (Finset.image Prod.fst) h
  simpa [oldMask, Finset.image_image, Function.comp_def] using hp

theorem freshMask_injective {C : Type*} [DecidableEq C] (large : Finset C) :
    Function.Injective (freshMask large) := by
  intro s t h
  have hp := congrArg (Finset.image Prod.fst) h
  simpa [freshMask, Finset.image_image, Function.comp_def] using hp

theorem resampled_masks_separated
    {C I : Type*} [DecidableEq C] (large : Finset C)
    (pairs : I → Finset C)
    (htouch : ∀ i, ∃ c ∈ pairs i, c ∈ large) :
    ∀ i j, freshMask large (pairs i) ≠ oldMask (pairs j) := by
  intro i j h
  obtain ⟨c, hc, hl⟩ := htouch i
  have hm : (c, true) ∈ freshMask large (pairs i) := by
    apply Finset.mem_image.mpr
    exact ⟨c, hc, by simp [hl]⟩
  rw [h] at hm
  simp [oldMask] at hm

theorem sign_resampling_exact
    {C I : Type*} [DecidableEq C] [Fintype I] [DecidableEq I]
    (large : Finset C) (pairs : I → Finset C)
    (hpairs : Function.Injective pairs)
    (htouch : ∀ i, ∃ c ∈ pairs i, c ∈ large) (a : I → ℝ) :
    (∑ i, ∑ j, a i * a j *
      (gram (freshMask large (pairs i)) (freshMask large (pairs j)) -
        gram (freshMask large (pairs i)) (oldMask (pairs j)) -
        gram (oldMask (pairs i)) (freshMask large (pairs j)) +
        gram (oldMask (pairs i)) (oldMask (pairs j)))) =
      2 * ∑ i, a i ^ 2 := by
  exact two_sample_gram
    (fun i => oldMask (pairs i)) (fun i => freshMask large (pairs i))
    (oldMask_injective.comp hpairs) ((freshMask_injective large).comp hpairs)
    (resampled_masks_separated large pairs htouch) a

theorem cubic_reach
    (c p e s M m H : ℝ)
    (hc : 0 ≤ c) (hp : 0 ≤ p) (hM : 0 ≤ M)
    (he : c * p ≤ e)
    (hinterp : e ^ 3 ≤ M * s ^ 2)
    (hbias : c ^ 2 * s ^ 2 ≤ m * M * H) :
    c ^ 5 * p ^ 3 ≤ m * M ^ 2 * H := by
  have hcp : 0 ≤ c * p := mul_nonneg hc hp
  have he3 : (c * p) ^ 3 ≤ e ^ 3 := by gcongr
  calc
    c ^ 5 * p ^ 3 = c ^ 2 * (c * p) ^ 3 := by ring
    _ ≤ c ^ 2 * e ^ 3 := mul_le_mul_of_nonneg_left he3 (sq_nonneg c)
    _ ≤ c ^ 2 * (M * s ^ 2) :=
      mul_le_mul_of_nonneg_left hinterp (sq_nonneg c)
    _ = M * (c ^ 2 * s ^ 2) := by ring
    _ ≤ M * (m * M * H) := mul_le_mul_of_nonneg_left hbias hM
    _ = m * M ^ 2 * H := by ring

theorem cubic_slack_identity (c p e s M m H : ℝ) :
    m * M ^ 2 * H - c ^ 5 * p ^ 3 =
      M * (m * M * H - c ^ 2 * s ^ 2) +
      c ^ 2 * (M * s ^ 2 - e ^ 3) +
      c ^ 2 * (e - c * p) * (e ^ 2 + e * c * p + (c * p) ^ 2) := by
  ring

end PinnedTransfer
