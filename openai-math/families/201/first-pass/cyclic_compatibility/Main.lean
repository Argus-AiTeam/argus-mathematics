import Mathlib

open scoped BigOperators

namespace CyclicCompatibility

abbrev Vertex (I R : Type*) := Sum I (Option R)

variable {K I H R G : Type*} [Field K] [Fintype R] [DecidableEq R]
  [AddCommGroup G] [Module K G]

structure HubNull
    (loopAnn : Vertex I R → (H → K) → Prop)
    (pairAnn : I → Option R → (H → K) → (H → K) → Prop)
    (X : I → R → R → H → K) (ν : Option R → H → K) : Prop where
  leaf_loop : ∀ i r s, loopAnn (.inl i) (X i r s)
  hub_loop : ∀ q, loopAnn (.inr q) (ν q)
  individual : ∀ i s r,
    pairAnn i (some s) (X i r s) (if r = s then ν (some s) else 0)
  common : ∀ i r, pairAnn i none (fun h => ∑ s, X i r s h) (ν none)

theorem hub_entry_rigidity [Nonempty I] [Nonempty R]
    (p : Vertex I R → G →ₗ[K] (H → K))
    (p_inj : ∀ v, Function.Injective (p v))
    (loopAnn : Vertex I R → (H → K) → Prop)
    (loop_zero : ∀ v, loopAnn v 0)
    (pairAnn : I → Option R → (H → K) → (H → K) → Prop)
    (pair_exact : ∀ i q x y,
      loopAnn (.inl i) x → loopAnn (.inr q) y →
      (pairAnn i q x y ↔ ∃ c : G, x = p (.inl i) c ∧ y = p (.inr q) c))
    {X : I → R → R → H → K} {ν : Option R → H → K}
    (hn : HubNull loopAnn pairAnn X ν) :
    ∃! c : G,
      (∀ i r s, X i r s = if r = s then p (.inl i) c else 0) ∧
      (∀ q, ν q = p (.inr q) c) := by
  classical
  have off : ∀ i r s, r ≠ s → X i r s = 0 := by
    intro i r s hrs
    have hp : pairAnn i (some s) (X i r s) 0 := by
      simpa [hrs] using hn.individual i s r
    obtain ⟨c, hx, hz⟩ :=
      (pair_exact i (some s) _ _ (hn.leaf_loop i r s)
        (loop_zero (.inr (some s)))).mp hp
    have hc : c = 0 := p_inj _ (by simpa using hz.symm)
    simpa [hc] using hx
  have sum_diag : ∀ i r, (fun h => ∑ s, X i r s h) = X i r r := by
    intro i r
    funext h
    calc
      ∑ s, X i r s h =
          ∑ s, if s = r then X i r r h else 0 := by
        apply Finset.sum_congr rfl
        intro s _
        by_cases hsr : s = r
        · subst s
          simp
        · simp [hsr, off i r s (Ne.symm hsr)]
      _ = X i r r h := by simp
  have diag : ∀ i r, ∃ c : G,
      X i r r = p (.inl i) c ∧ ν none = p (.inr none) c := by
    intro i r
    apply (pair_exact i none _ _ (hn.leaf_loop i r r) (hn.hub_loop none)).mp
    simpa only [sum_diag i r] using hn.common i r
  let i₀ : I := Classical.choice inferInstance
  let r₀ : R := Classical.choice inferInstance
  obtain ⟨c, _, hν⟩ := diag i₀ r₀
  have diag_all : ∀ i r, X i r r = p (.inl i) c := by
    intro i r
    obtain ⟨d, hx, hdν⟩ := diag i r
    have hd : d = c := p_inj _ (hdν.symm.trans hν)
    simpa [hd] using hx
  have hubs : ∀ q, ν q = p (.inr q) c := by
    intro q
    cases q with
    | none => exact hν
    | some r =>
        have hp : pairAnn i₀ (some r) (X i₀ r r) (ν (some r)) := by
          simpa using hn.individual i₀ r r
        obtain ⟨d, hx, hdν⟩ :=
          (pair_exact i₀ (some r) _ _ (hn.leaf_loop i₀ r r)
            (hn.hub_loop (some r))).mp hp
        have hd : d = c := p_inj _ (hx.symm.trans (diag_all i₀ r))
        simpa [hd] using hdν
  refine ⟨c, ⟨?_, hubs⟩, ?_⟩
  · intro i r s
    by_cases hrs : r = s
    · subst s
      simpa using diag_all i r
    · simp [hrs, off i r s hrs]
  · intro d hd
    exact p_inj (.inr none) ((hd.2 none).symm.trans (hubs none))

theorem canonical_hub_null
    (p : Vertex I R → G →ₗ[K] (H → K))
    (loopAnn : Vertex I R → (H → K) → Prop)
    (loop_p : ∀ v c, loopAnn v (p v c))
    (pairAnn : I → Option R → (H → K) → (H → K) → Prop)
    (pair_p : ∀ i q c, pairAnn i q (p (.inl i) c) (p (.inr q) c))
    (c : G) :
    HubNull loopAnn pairAnn
      (fun i r s => if r = s then p (.inl i) c else 0)
      (fun q => p (.inr q) c) := by
  classical
  constructor
  · intro i r s
    by_cases hrs : r = s
    · simpa [hrs] using loop_p (.inl i) c
    · simpa [hrs] using loop_p (.inl i) 0
  · intro q
    exact loop_p (.inr q) c
  · intro i s r
    by_cases hrs : r = s
    · simpa [hrs] using pair_p i (some s) c
    · simpa [hrs] using pair_p i (some s) 0
  · intro i r
    have hs :
        (fun h => ∑ s, (if r = s then p (.inl i) c else 0) h) =
          p (.inl i) c := by
      funext h
      calc
        (∑ s, (if r = s then p (.inl i) c else 0) h) =
            ∑ s, if r = s then p (.inl i) c h else 0 := by
          apply Finset.sum_congr rfl
          intro s _
          split_ifs <;> rfl
        _ = p (.inl i) c h := by simp
    rw [hs]
    exact pair_p i none c

theorem orthogonal_weights_unique
    {J : Type*} [Fintype J] [DecidableEq J]
    (P : J → Matrix R R K)
    (orth : ∀ j k, P j * P k = if j = k then P k else 0)
    (nonzero : ∀ j, P j ≠ 0)
    (μ : J → K) (c : K)
    (hs : ∑ j, μ j • P j = c • (1 : Matrix R R K)) :
    ∀ j, μ j = c := by
  classical
  intro k
  have key : (∑ j, μ j • P j) * P k = μ k • P k := by
    rw [Finset.sum_mul]
    simp_rw [smul_mul_assoc, orth]
    simp
  have heq : μ k • P k = c • P k := by
    calc
      μ k • P k = (∑ j, μ j • P j) * P k := key.symm
      _ = (c • (1 : Matrix R R K)) * P k := congrArg (fun A => A * P k) hs
      _ = c • P k := by simp
  have hz : (μ k - c) • P k = 0 := by
    rw [sub_smul, heq, sub_self]
  exact sub_eq_zero.mp ((smul_eq_zero.mp hz).resolve_right (nonzero k))

theorem hub_projector_rigidity [Nonempty I] [Nonempty R]
    {J : Type*} [Fintype J] [DecidableEq J]
    (p : Vertex I R → G →ₗ[K] (H → K))
    (p_inj : ∀ v, Function.Injective (p v))
    (loopAnn : Vertex I R → (H → K) → Prop)
    (loop_zero : ∀ v, loopAnn v 0)
    (pairAnn : I → Option R → (H → K) → (H → K) → Prop)
    (pair_exact : ∀ i q x y,
      loopAnn (.inl i) x → loopAnn (.inr q) y →
      (pairAnn i q x y ↔ ∃ c : G, x = p (.inl i) c ∧ y = p (.inr q) c))
    (P : I → H → J → Matrix R R K)
    (orth : ∀ i h j k, P i h j * P i h k = if j = k then P i h k else 0)
    (nonzero : ∀ i h j, P i h j ≠ 0)
    (μ : I → H → J → K) (ν : Option R → H → K)
    (hn : HubNull loopAnn pairAnn
      (fun i r s h => (∑ j, μ i h j • P i h j) r s) ν) :
    ∃! c : G,
      (∀ i h j, μ i h j = p (.inl i) c h) ∧
      (∀ q, ν q = p (.inr q) c) := by
  classical
  obtain ⟨c, hc, _⟩ :=
    hub_entry_rigidity p p_inj loopAnn loop_zero pairAnn pair_exact hn
  refine ⟨c, ⟨?_, hc.2⟩, ?_⟩
  · intro i h j
    have hs : ∑ j, μ i h j • P i h j =
        (p (.inl i) c h) • (1 : Matrix R R K) := by
      ext r s
      have hh := congrFun (hc.1 i r s) h
      by_cases hrs : r = s
      · simpa [hrs, Matrix.smul_apply, Matrix.one_apply] using hh
      · simpa [hrs, Matrix.smul_apply, Matrix.one_apply] using hh
    exact orthogonal_weights_unique (P i h) (orth i h) (nonzero i h)
      (μ i h) (p (.inl i) c h) hs j
  · intro d hd
    exact p_inj (.inr none) ((hd.2 none).symm.trans (hc.2 none))

end CyclicCompatibility
