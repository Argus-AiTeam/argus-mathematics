import Mathlib

namespace NullLayerAudit

section Linear

variable {K E M A H : Type*} [Field K]
  [AddCommGroup E] [Module K E]
  [AddCommGroup M] [Module K M]
  [AddCommGroup A] [Module K A]
  [AddCommGroup H] [Module K H]

theorem middleExact
    (D : E →ₗ[K] E) (i : M →ₗ[K] E)
    (p : E →ₗ[K] M) (p₀ : E →ₗ[K] A) (a : A →ₗ[K] M)
    (unit token : E) (f g : E →ₗ[K] K)
    (span : ∀ z, D z = 0 →
      ∃ (r s : K) (u : E), z = r • unit + s • token + D u)
    (funit : f unit = 1) (ftoken : f token = 0)
    (gunit : g unit = 0) (gtoken : g token = 1)
    (fD : ∀ u, f (D u) = 0) (gD : ∀ u, g (D u) = 0)
    (fi : ∀ x, f (i x) = 0) (gi : ∀ x, g (i x) = 0)
    (pi : ∀ x, p (i x) = x)
    (pD : ∀ u, p (D u) = a (p₀ u))
    (x : M) (hx : D (i x) = 0) :
    ∃ y, a y = x := by
  obtain ⟨r, s, u, hu⟩ := span (i x) hx
  have hr : r = 0 := by
    have h := congrArg f hu
    simpa [funit, ftoken, fD, fi] using h.symm
  have hs : s = 0 := by
    have h := congrArg g hu
    simpa [gunit, gtoken, gD, gi] using h.symm
  have hu' : i x = D u := by simpa [hr, hs] using hu
  refine ⟨p₀ u, ?_⟩
  calc
    a (p₀ u) = p (D u) := (pD u).symm
    _ = p (i x) := congrArg p hu'.symm
    _ = x := pi x

theorem middleExactAcyclic
    (D : E →ₗ[K] E) (i : M →ₗ[K] E)
    (p : E →ₗ[K] M) (p₀ : E →ₗ[K] A) (a : A →ₗ[K] M)
    (exact : ∀ z, D z = 0 → ∃ u, D u = z)
    (pi : ∀ x, p (i x) = x)
    (pD : ∀ u, p (D u) = a (p₀ u))
    (x : M) (hx : D (i x) = 0) :
    ∃ y, a y = x := by
  obtain ⟨u, hu⟩ := exact (i x) hx
  refine ⟨p₀ u, ?_⟩
  calc
    a (p₀ u) = p (D u) := (pD u).symm
    _ = p (i x) := congrArg p hu
    _ = x := pi x

theorem secondaryKernelZero
    (D : E →ₗ[K] E) (i₀ : M →ₗ[K] E) (i₁ : H →ₗ[K] E)
    (p₀ : E →ₗ[K] M) (N : Submodule K E)
    (i₀mem : ∀ x, i₀ x ∈ N) (i₁mem : ∀ y, i₁ y ∈ N)
    (exactN : ∀ z, z ∈ N → D z = 0 → ∃ u, D u = z)
    (pi₀ : ∀ x, p₀ (i₀ x) = x) (pi₁ : ∀ y, p₀ (i₁ y) = 0)
    (pD : ∀ u, p₀ (D u) = 0)
    (x : M) (y : H) (himage : D (i₀ x) = D (i₁ y)) :
    x = 0 := by
  have hclosed : D (i₀ x - i₁ y) = 0 := by
    rw [map_sub, himage, sub_self]
  obtain ⟨u, hu⟩ :=
    exactN (i₀ x - i₁ y) (N.sub_mem (i₀mem x) (i₁mem y)) hclosed
  have h := congrArg p₀ hu
  simpa [pi₀, pi₁, pD] using h.symm

end Linear

section Separation

variable {J W : Type*} [Fintype J]

theorem strictChamberDetect
    (ρ : W → (J → ℝ) →ₗ[ℝ] (J → ℝ))
    (e : J → ℝ) (s : W → J → ℝ)
    (η : (J → ℝ) →ₗ[ℝ] ℝ)
    (cover : η ≠ 0 → ∃ (w : W) (a : J → ℝ),
      (∀ j, 0 ≤ a j) ∧ (∃ j, 0 < a j) ∧
      ∀ v, η v = - ∑ j, a j * (ρ w v) j)
    (strict : ∀ w j, 0 < (ρ w (e - s w)) j)
    (hne : η ≠ 0) :
    ∃ w, η (e - s w) < 0 := by
  obtain ⟨w, a, ha, ⟨j, hj⟩, hη⟩ := cover hne
  have hsum : 0 < ∑ k, a k * (ρ w (e - s w)) k := by
    exact Finset.sum_pos'
      (fun k _ => mul_nonneg (ha k) (le_of_lt (strict w k)))
      ⟨j, Finset.mem_univ j, mul_pos hj (strict w j)⟩
  refine ⟨w, ?_⟩
  rw [hη]
  linarith

theorem finiteSeparation [Nonempty W]
    (ρ : W → (J → ℝ) →ₗ[ℝ] (J → ℝ))
    (e : J → ℝ) (s : W → J → ℝ)
    (η : (J → ℝ) →ₗ[ℝ] ℝ) (B H : ℝ)
    (cover : η ≠ 0 → ∃ (w : W) (a : J → ℝ),
      (∀ j, 0 ≤ a j) ∧ (∃ j, 0 < a j) ∧
      ∀ v, η v = - ∑ j, a j * (ρ w v) j)
    (strict : ∀ w j, 0 < (ρ w (e - s w)) j)
    (hB : B ≤ 0) (hH : 0 ≤ H)
    (ineq : ∀ w, H ≤ B + η (e - s w)) :
    η = 0 ∧ B = 0 ∧ H = 0 := by
  have hη : η = 0 := by
    by_contra hne
    obtain ⟨w, hw⟩ := strictChamberDetect ρ e s η cover strict hne
    have hi := ineq w
    linarith
  have hi := ineq (Classical.choice (inferInstance : Nonempty W))
  simp only [hη, LinearMap.zero_apply, add_zero] at hi
  exact ⟨hη, by linarith, by linarith⟩

theorem topVanishes {S : Type*} [Fintype S] [DecidableEq S]
    (C : S → S → ℝ) (j : S) (m m' : S → ℝ) (t : ℝ)
    (diag : C j j = 2)
    (outside : ∀ i, i ≠ j → m' i = m i)
    (oldrow : ∑ i, C j i * m i = 0)
    (newrow : ∑ i, C j i * m' i = 0)
    (count : m' j = m j - (∑ i, C j i * m i) + t) :
    t = 0 := by
  have point (i : S) :
      C j i * m' i = C j i * m i +
        if i = j then 2 * (m' j - m j) else 0 := by
    by_cases h : i = j
    · subst i
      rw [if_pos rfl, diag]
      ring
    · rw [if_neg h, outside i h, add_zero]
  have rows :
      (∑ i, C j i * m' i) =
        (∑ i, C j i * m i) + 2 * (m' j - m j) := by
    calc
      (∑ i, C j i * m' i) =
          ∑ i, (C j i * m i +
            if i = j then 2 * (m' j - m j) else 0) := by
              exact Finset.sum_congr rfl (fun i _ => point i)
      _ = (∑ i, C j i * m i) + 2 * (m' j - m j) := by
        rw [Finset.sum_add_distrib]
        simp
  rw [oldrow] at count
  linarith

end Separation

inductive MovePath {State : Type*} (R : State → State → Prop) :
    ℕ → State → State → Prop
  | nil (s : State) : MovePath R 0 s s
  | cons {n : ℕ} {s t u : State} :
      R s t → MovePath R n t u → MovePath R (n + 1) s u

theorem MovePath.append {State : Type*} {R : State → State → Prop}
    {n m : ℕ} {s t u : State}
    (p : MovePath R n s t) (q : MovePath R m t u) :
    MovePath R (n + m) s u := by
  induction p generalizing m u with
  | nil => simpa using q
  | cons h p ih =>
    simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
      MovePath.cons h (ih q)

theorem rankStage {State : Type*}
    (R : State → State → Prop) (Good Done : State → Prop)
    (rank : State → ℕ) (L : ℕ)
    (bound : ∀ s, rank s ≤ L)
    (step : ∀ s, Good s → ¬ Done s →
      ∃ t, R s t ∧ rank t = rank s + 1)
    (fuel : ℕ) :
    ∀ s, rank s + fuel = L →
      ∃ n t, n ≤ fuel ∧ MovePath R n s t ∧ (¬ Good t ∨ Done t) := by
  induction fuel with
  | zero =>
    intro s hs
    by_cases stop : ¬ Good s ∨ Done s
    · exact ⟨0, s, by omega, MovePath.nil s, stop⟩
    · have hg : Good s := by tauto
      have hd : ¬ Done s := by tauto
      obtain ⟨t, _, ht⟩ := step s hg hd
      have hb := bound t
      omega
  | succ fuel ih =>
    intro s hs
    by_cases stop : ¬ Good s ∨ Done s
    · exact ⟨0, s, by omega, MovePath.nil s, stop⟩
    · have hg : Good s := by tauto
      have hd : ¬ Done s := by tauto
      obtain ⟨t, hst, ht⟩ := step s hg hd
      have hf : rank t + fuel = L := by omega
      obtain ⟨n, u, hn, hp, hu⟩ := ih t hf
      exact ⟨n + 1, u, by omega, MovePath.cons hst hp, hu⟩

theorem boundedStagesEscape {State : Type*}
    (R : State → State → Prop) (Good : State → Prop)
    (Inv : ℕ → State → Prop) (N L : ℕ)
    (stage : ∀ d, d < N → ∀ s, Inv d s → Good s →
      ∃ n t, n ≤ L ∧ MovePath R n s t ∧
        (¬ Good t ∨ Inv (d + 1) t))
    (boundary : ∀ s, Inv N s → ¬ Good s)
    (s₀ : State) (initial : Inv 0 s₀) :
    ∃ n t, n ≤ N * L ∧ MovePath R n s₀ t ∧ ¬ Good t := by
  have aux : ∀ k d s, d + k = N → Inv d s →
      ∃ n t, n ≤ k * L ∧ MovePath R n s t ∧ ¬ Good t := by
    intro k
    induction k with
    | zero =>
      intro d s hd hi
      have hd' : d = N := by omega
      subst d
      exact ⟨0, s, by simp, MovePath.nil s, boundary s hi⟩
    | succ k ih =>
      intro d s hd hi
      by_cases hg : Good s
      · obtain ⟨n, t, hn, hp, ht⟩ := stage d (by omega) s hi hg
        rcases ht with hbad | hnext
        · refine ⟨n, t, ?_, hp, hbad⟩
          rw [Nat.succ_mul]
          omega
        · obtain ⟨m, u, hm, hq, hu⟩ := ih (d + 1) t (by omega) hnext
          refine ⟨n + m, u, ?_, hp.append hq, hu⟩
          rw [Nat.succ_mul]
          omega
      · exact ⟨0, s, Nat.zero_le _, MovePath.nil s, hg⟩
  exact aux N 0 s₀ (by omega) initial

#print axioms middleExact
#print axioms middleExactAcyclic
#print axioms secondaryKernelZero
#print axioms strictChamberDetect
#print axioms finiteSeparation
#print axioms topVanishes
#print axioms rankStage
#print axioms boundedStagesEscape

end NullLayerAudit
