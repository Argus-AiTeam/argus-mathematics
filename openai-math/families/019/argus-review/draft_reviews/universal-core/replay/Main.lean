import Mathlib

open Set

namespace CollarRootAudit

theorem rational_collar_capture
    {X : Type*} [TopologicalSpace X] [CompactSpace X]
    (N : Set X) (hN : IsOpen N) (v : X → ℝ) (hv : Continuous v)
    (hbad : ∀ x, x ∉ N → ∃ q : ℚ, v x = (q : ℝ))
    {a lower upper : ℝ} (ha : Irrational a)
    (hlower : lower < a) (hupper : a < upper) :
    ∃ r R : ℚ,
      lower < (r : ℝ) ∧ (r : ℝ) < a ∧
      a < (R : ℝ) ∧ (R : ℝ) < upper ∧
      ∀ x, (r : ℝ) < v x → v x < (R : ℝ) → x ∈ N := by
  let F : Set ℝ := v '' Nᶜ
  have hF : IsClosed F := (hN.isClosed_compl.isCompact.image hv).isClosed
  have haF : a ∉ F := by
    rintro ⟨x, hx, hxa⟩
    obtain ⟨q, hq⟩ := hbad x hx
    exact ha ⟨q, hq.symm.trans hxa⟩
  have hopen : IsOpen (Fᶜ ∩ Ioo lower upper) :=
    hF.isOpen_compl.inter isOpen_Ioo
  have hmem : a ∈ Fᶜ ∩ Ioo lower upper := ⟨haF, hlower, hupper⟩
  obtain ⟨l, u, hlu, hI⟩ :=
    mem_nhds_iff_exists_Ioo_subset.mp (hopen.mem_nhds hmem)
  obtain ⟨r, hlr, hra⟩ := exists_rat_btwn hlu.1
  obtain ⟨R, haR, hRu⟩ := exists_rat_btwn hlu.2
  have hrmem : (r : ℝ) ∈ Fᶜ ∩ Ioo lower upper :=
    hI ⟨hlr, lt_trans hra hlu.2⟩
  have hRmem : (R : ℝ) ∈ Fᶜ ∩ Ioo lower upper :=
    hI ⟨lt_trans hlu.1 haR, hRu⟩
  refine ⟨r, R, hrmem.2.1, hra, haR, hRmem.2.2, ?_⟩
  intro x hxL hxU
  by_contra hx
  have hxF : v x ∈ F := ⟨x, hx, rfl⟩
  exact (hI ⟨lt_trans hlr hxL, lt_trans hxU hRu⟩).1 hxF

theorem circuit_genus_balance (n g : ℤ) :
    2 * (n * g) - 2 = n * (2 * g - 2) + 2 * (n - 1) := by
  ring

theorem circuit_stability_balance (n g val : ℤ) :
    2 * (n * g) - 2 + (2 + n * (val - 2)) =
      n * (2 * g - 2 + val) := by
  ring

theorem unramified_stability_balance (d g gp val valp : ℤ)
    (hgenus : 2 * gp - 2 = d * (2 * g - 2))
    (hval : valp = d * val) :
    2 * gp - 2 + valp = d * (2 * g - 2 + val) := by
  rw [hgenus, hval]
  ring

theorem stable_tree_side_impossible (N total : ℕ)
    (hpositive : 0 < N) (htree : total + 1 = 2 * N)
    (hstable : 3 * N ≤ total) : False := by
  omega

end CollarRootAudit
