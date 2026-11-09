import OAI.Combinatorics.InfiniteMatroid.Main

open Set Filter Matroid
open OAI.InfiniteMatroidCounterexample

namespace Manuscript185Global

local notation "DensitySmall" => OAI.InfiniteMatroidCounterexample.Small

theorem concrete_rank_certificate :
    ∃ U : Ultrafilter D,
      (∀ N, KSmall N → N ∉ U) ∧
      (∀ t, GColumn t ∈ U) ∧
      (∀ X, X ∈ U → {t | KIdeal.ModSubset X (GColumn t)}.Finite) ∧
      ∃ R : RankModel D, R.ideal = KIdeal ∧ R.ultra = U := by
  obtain ⟨U, hUK, hG, hfinite⟩ :=
    exists_rank_ultrafilter KIdeal GColumn Gpattern_kPositive
  exact ⟨U, hUK, hG, hfinite,
    exists_rankModel KIdeal GColumn U hUK hG hfinite⟩

theorem reservation_certificate {ι : Type}
    (hι : Cardinal.mk ι < Cardinal.continuum)
    (S : ι → Set E0) (hS : ∀ i, ¬ DensitySmall (S i)) :
    ∃ t : CIndex,
      Disjoint (HCell t false) (HCell t true) ∧
      KSmall0 (HCell t false) ∧ KSmall0 (HCell t true) ∧
      ∀ i k, ¬ DensitySmall (S i ∩ HCell t k) := by
  obtain ⟨t, ht⟩ := simultaneous_reservations hι S hS
  exact ⟨t, hCell_disjoint t, hCell_kSmall0 t false, hCell_kSmall0 t true, ht⟩

theorem unconditional_local_matroid :
    ∃ R : RankModel D, R.ideal = KIdeal ∧
    ∃ S : BasisSystem E0,
      (∀ B ∈ S.bases, R.Admissible B) ∧
      S.matroid.dual = S.matroid ∧
      (∀ I Y : Set E0, S.matroid.Indep I → I ⊆ Y →
        ∃ J, I ⊆ J ∧ J ⊆ Y ∧ S.matroid.Indep J ∧
          ∀ K, S.matroid.Indep K → K ⊆ Y → J ⊆ K → K ⊆ J) ∧
      (∀ B, S.matroid.IsBase B → slice B false ∈ R.ultra →
        (slice B true)ᶜ ∈ R.ultra ∧
          R.rank (slice B true)ᶜ < R.rank (slice B false)) := by
  obtain ⟨U, _, _, _, R, hK, _⟩ := concrete_rank_certificate
  obtain ⟨S, hS⟩ := R.exists_basisSystem hK
  refine ⟨R, hK, S, hS, S.self_dual, ?_, ?_⟩
  · intro I Y hI hIY
    obtain ⟨J, hIJ, hJ⟩ := S.exists_maximal hI hIY
    exact ⟨J, hIJ, hJ.1.2, hJ.1.1, fun K hK hKY hJK ↦ hJ.2 ⟨hK, hKY⟩ hJK⟩
  · intro B hB hl
    rcases hS B ((S.isBase_iff B).mp hB) with ha | ha
    · exact ha.2
    · exact (ha.1 hl).elim

theorem contraction_onto_bridge {α : Type*} (M : Matroid α)
    (hE : M.E = univ) (C : Set α) :
    M.contract (univ \ C) = contractOnto M C := by
  simp only [Matroid.contract, Matroid.delete_eq_restrict, Matroid.dual_ground,
    hE, ← Set.compl_eq_univ_sdiff, compl_compl, contractOnto]

def ManuscriptPackingCovering {α : Type*} (M₀ M₁ : Matroid α) : Prop :=
  ∃ P C S₀ S₁ I₀ I₁ : Set α,
    Disjoint P C ∧ P ∪ C = univ ∧
    S₀ ⊆ P ∧ S₁ ⊆ P ∧ Disjoint S₀ S₁ ∧
    (M₀ ↾ P).closure S₀ = P ∧ (M₁ ↾ P).closure S₁ = P ∧
    I₀ ⊆ C ∧ I₁ ⊆ C ∧
    (M₀.contract (univ \ C)).Indep I₀ ∧
    (M₁.contract (univ \ C)).Indep I₁ ∧ I₀ ∪ I₁ = C

theorem packing_covering_bridge {α : Type*} (M₀ M₁ : Matroid α)
    (hE₀ : M₀.E = univ) (hE₁ : M₁.E = univ) :
    ManuscriptPackingCovering M₀ M₁ ↔ HasPackingCovering M₀ M₁ := by
  constructor
  · rintro ⟨P, C, S₀, S₁, I₀, I₁, hd, hPC, hS₀P, hS₁P, hdS,
      hS₀, hS₁, hI₀C, hI₁C, hI₀, hI₁, hIC⟩
    rw [contraction_onto_bridge M₀ hE₀ C] at hI₀
    rw [contraction_onto_bridge M₁ hE₁ C] at hI₁
    exact ⟨P, C, S₀, S₁, I₀, I₁, hd, hPC.trans hE₀.symm, hE₁.trans hE₀.symm,
      hS₀P, hS₁P, hdS,
      ((M₀ ↾ P).spanning_iff_closure_eq hS₀P).mpr hS₀,
      ((M₁ ↾ P).spanning_iff_closure_eq hS₁P).mpr hS₁,
      hI₀C, hI₁C, hI₀, hI₁, hIC⟩
  · rintro ⟨P, C, S₀, S₁, I₀, I₁, hd, hPC, _, hS₀P, hS₁P, hdS,
      hS₀, hS₁, hI₀C, hI₁C, hI₀, hI₁, hIC⟩
    rw [← contraction_onto_bridge M₀ hE₀ C] at hI₀
    rw [← contraction_onto_bridge M₁ hE₁ C] at hI₁
    exact ⟨P, C, S₀, S₁, I₀, I₁, hd, hPC.trans hE₀, hS₀P, hS₁P, hdS,
      ((M₀ ↾ P).spanning_iff_closure_eq hS₀P).mp hS₀,
      ((M₁ ↾ P).spanning_iff_closure_eq hS₁P).mp hS₁,
      hI₀C, hI₁C, hI₀, hI₁, hIC⟩

theorem orientation_bridge :
    (∀ n : ℤ, n ≤ -1 → bundleAt n false = n ∧ bundleAt n true = n - 1) ∧
    (∀ n : ℤ, 0 ≤ n → bundleAt n false = n - 1 ∧ bundleAt n true = n) ∧
    bundleAt (-1) false = -1 ∧ bundleAt 0 false = -1 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro n hn
    simp [bundleAt, show n < 0 by omega]
  · intro n hn
    simp [bundleAt, not_lt.mpr hn]
  · norm_num [bundleAt]
  · norm_num [bundleAt]

theorem manuscript_main :
    Countable E ∧ Infinite E ∧
    ∃ M₀ M₁ : Matroid E,
      M₀.E = univ ∧ M₁.E = univ ∧
      M₀.dual = M₀ ∧ M₁.dual = M₁ ∧
      (∀ I₀ I₁ : Set E, M₀.Indep I₀ → M₁.Indep I₁ → I₀ ∪ I₁ ≠ univ) ∧
      ¬ ManuscriptPackingCovering M₀ M₁ := by
  obtain ⟨R, _, S, _, hQ, _, hb⟩ := unconditional_local_matroid
  let Q := S.matroid
  have hE : Q.E = univ := S.ground
  have hanti : ∀ ⦃X Y : Set D⦄, X ∈ R.ultra → Y ∈ R.ultra → X ⊆ Y →
      R.rank Y ≤ R.rank X :=
    fun _ _ hX hY hXY ↦ R.antitone hX hY (R.ideal.modSubset_of_subset hXY)
  have hno : ∀ I J : Set E, (rayMatroid Q false).Indep I →
      (rayMatroid Q true).Indep J → I ∪ J ≠ univ :=
    no_independent_cover Q R.ultra R.rank hanti hb
  have hE₀ := rayMatroid_ground Q hE false
  have hE₁ := rayMatroid_ground Q hE true
  have hM₀ := rayMatroid_selfDual Q hE hQ false
  have hM₁ := rayMatroid_selfDual Q hE hQ true
  refine ⟨inferInstance, inferInstance, rayMatroid Q false, rayMatroid Q true,
    hE₀, hE₁, hM₀, hM₁, hno, ?_⟩
  intro h
  obtain ⟨I, J, hI, hJ, hIJ⟩ := independent_cover_of_packing_covering
    _ _ hE₀ hE₁ hM₀ hM₁ ((packing_covering_bridge _ _ hE₀ hE₁).mp h)
  exact hno I J hI hJ hIJ

end Manuscript185Global

#print axioms Manuscript185Global.concrete_rank_certificate
#print axioms Manuscript185Global.reservation_certificate
#print axioms Manuscript185Global.unconditional_local_matroid
#print axioms Manuscript185Global.contraction_onto_bridge
#print axioms Manuscript185Global.packing_covering_bridge
#print axioms Manuscript185Global.orientation_bridge
#print axioms Manuscript185Global.manuscript_main
#print axioms OAI.InfiniteMatroidCounterexample.finite_union_small
#print axioms OAI.InfiniteMatroidCounterexample.columns_pattern
#print axioms OAI.InfiniteMatroidCounterexample.exists_rank_ultrafilter
#print axioms OAI.InfiniteMatroidCounterexample.ordinalRank_thinning
#print axioms OAI.InfiniteMatroidCounterexample.simultaneous_reservations
#print axioms OAI.InfiniteMatroidCounterexample.RankModel.exists_complete_prototypes
#print axioms OAI.InfiniteMatroidCounterexample.BasisSystem.exists_maximal
#print axioms OAI.InfiniteMatroidCounterexample.independent_rank_step
#print axioms OAI.InfiniteMatroidCounterexample.no_independent_cover
#print axioms OAI.InfiniteMatroidCounterexample.independent_cover_of_packing_covering
