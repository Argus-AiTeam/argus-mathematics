import research.certificates.hypergraph_influence.Model
import HypergraphBlockSupport.BlockOrbit
import HypergraphBlockSupport.BlockSymmetry

open scoped BigOperators Classical
open OAI.Problem313 OAI.Problem313.BiasedFourier

set_option maxHeartbeats 1500000

namespace HypergraphInfluence.Block

noncomputable section

theorem le_choose_of_one_le_lt {m j : ℕ} (hj : 1 ≤ j) (hjm : j < m) :
    m ≤ m.choose j := by
  induction m generalizing j with
  | zero => omega
  | succ m ih =>
      by_cases hjm' : j = m
      · subst j
        simp
      by_cases hj1 : j = 1
      · subst j
        simp
      obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (show j ≠ 0 by omega)
      rw [Nat.choose_succ_succ]
      change m + 1 ≤ m.choose j + m.choose (j + 1)
      have hrec := ih (show 1 ≤ j + 1 by omega) (show j + 1 < m by omega)
      have hpos := Nat.choose_pos (show j ≤ m by omega)
      omega

def orbitFamily {n r : ℕ} (B : Finset (Fin n)) (e : Edge n r) :
    Finset (Edge n r) :=
  Finset.univ.filter fun d => d.val \ B = e.val \ B

@[simp] theorem mem_orbitFamily {n r : ℕ} (B : Finset (Fin n))
    (e d : Edge n r) :
    d ∈ orbitFamily B e ↔ d.val \ B = e.val \ B := by
  simp [orbitFamily]

theorem orbitFamily_card {n r : ℕ} (B : Finset (Fin n)) (e : Edge n r) :
    (orbitFamily B e).card = B.card.choose (e.val ∩ B).card := by
  classical
  rw [← Finset.card_powersetCard]
  apply Finset.card_bij (fun d _ => d.val ∩ B)
  · intro d hd
    refine Finset.mem_powersetCard.mpr ⟨Finset.inter_subset_right, ?_⟩
    have hdout := (mem_orbitFamily B e d).mp hd
    have hdcard := Finset.card_sdiff_add_card_inter d.val B
    have hecard := Finset.card_sdiff_add_card_inter e.val B
    rw [hdout, d.property] at hdcard
    rw [e.property] at hecard
    omega
  · intro d hd d' hd' h
    apply Subtype.ext
    have hdout := (mem_orbitFamily B e d).mp hd
    have hdout' := (mem_orbitFamily B e d').mp hd'
    calc
      d.val = (d.val ∩ B) ∪ (d.val \ B) := by ext v; simp; tauto
      _ = (d'.val ∩ B) ∪ (d'.val \ B) := by rw [h, hdout, hdout']
      _ = d'.val := by ext v; simp; tauto
  · intro A hA
    obtain ⟨hAB, hAc⟩ := Finset.mem_powersetCard.mp hA
    have hdis : Disjoint A (e.val \ B) := by
      apply Finset.disjoint_left.mpr
      intro v hvA hvout
      exact (Finset.mem_sdiff.mp hvout).2 (hAB hvA)
    have hcard : (A ∪ (e.val \ B)).card = r := by
      rw [Finset.card_union_of_disjoint hdis, hAc]
      have h := Finset.card_sdiff_add_card_inter e.val B
      rw [e.property] at h
      omega
    refine ⟨⟨A ∪ (e.val \ B), hcard⟩, ?_, ?_⟩
    · apply (mem_orbitFamily B e _).mpr
      change (A ∪ (e.val \ B)) \ B = e.val \ B
      ext v
      simp only [Finset.mem_sdiff, Finset.mem_union]
      constructor
      · rintro ⟨hvA | hvout, hvB⟩
        · exact False.elim (hvB (hAB hvA))
        · exact hvout
      · intro hvout
        exact ⟨Or.inr hvout, hvout.2⟩
    · change (A ∪ (e.val \ B)) ∩ B = A
      ext v
      simp only [Finset.mem_inter, Finset.mem_union, Finset.mem_sdiff]
      constructor
      · rintro ⟨hvA | hvout, hvB⟩
        · exact hvA
        · exact False.elim (hvout.2 hvB)
      · intro hvA
        exact ⟨Or.inl hvA, hAB hvA⟩

theorem orbitFamily_card_lower {n r : ℕ} (B : Finset (Fin n))
    (hrB : r < B.card) (e : Edge n r) (he : Touches B e) :
    B.card ≤ (orbitFamily B e).card := by
  rw [orbitFamily_card]
  apply le_choose_of_one_le_lt
  · exact Finset.one_le_card.mpr he
  · have h := Finset.card_le_card (Finset.inter_subset_left : e.val ∩ B ⊆ e.val)
    rw [e.property] at h
    omega

theorem touches_blockPerm_iff {n r : ℕ} (B : Finset (Fin n))
    (σ : Equiv.Perm B) (e : Edge n r) :
    Touches B (edgePerm (extendBlockPerm B σ) e) ↔ Touches B e := by
  classical
  constructor
  · rintro ⟨v, hv⟩
    obtain ⟨hve, hvB⟩ := Finset.mem_inter.mp hv
    obtain ⟨u, hue, huv⟩ := Finset.mem_map.mp hve
    refine ⟨u, Finset.mem_inter.mpr ⟨hue, ?_⟩⟩
    apply (extendBlockPerm_mem_iff B σ u).mp
    change extendBlockPerm B σ u = v at huv
    rw [huv]
    exact hvB
  · rintro ⟨v, hv⟩
    obtain ⟨hve, hvB⟩ := Finset.mem_inter.mp hv
    refine ⟨extendBlockPerm B σ v, Finset.mem_inter.mpr ⟨?_, ?_⟩⟩
    · exact Finset.mem_map.mpr ⟨v, hve, rfl⟩
    · exact (extendBlockPerm_mem_iff B σ v).mpr hvB

theorem blockPerm_fixes_exterior {n r : ℕ} (B : Finset (Fin n))
    (σ : Equiv.Perm B) (e : Edge n r) (he : ¬ Touches B e) :
    edgePerm (extendBlockPerm B σ) e = e := by
  apply Subtype.ext
  apply extendBlockPerm_map_disjoint
  exact Finset.disjoint_iff_inter_eq_empty.mpr (Finset.not_nonempty_iff_eq_empty.mp he)

theorem restricted_influence_blockPerm {n r : ℕ} (B : Finset (Fin n))
    (σ : Equiv.Perm B) (p : ℝ) (f : Config n r → Bool) (hf : IsInvariant f)
    (y : {d : Edge n r // ¬ Touches B d} → Bool)
    (e : {d : Edge n r // Touches B d}) :
    Reindex.influence p (restrictCube (Touches B) f y)
        ⟨edgePerm (extendBlockPerm B σ) e.val,
          (touches_blockPerm_iff B σ e.val).mpr e.property⟩ =
      Reindex.influence p (restrictCube (Touches B) f y) e := by
  classical
  let π : Equiv.Perm (Edge n r) := edgePerm (extendBlockPerm B σ)
  let hP : ∀ i, Touches B i ↔ Touches B (π i) :=
    fun i => (touches_blockPerm_iff B σ i).symm
  apply Reindex.influence_config (π.subtypeEquiv hP)
  intro x
  exact restrictCube_invariant (Touches B) π hP
    (fun d hd => blockPerm_fixes_exterior B σ d hd) f (hf _) x y

theorem restricted_influence_eq_of_exterior_eq {n r : ℕ}
    (B : Finset (Fin n)) (p : ℝ) (f : Config n r → Bool) (hf : IsInvariant f)
    (y : {d : Edge n r // ¬ Touches B d} → Bool)
    (e d : {a : Edge n r // Touches B a})
    (hout : d.val.val \ B = e.val.val \ B) :
    Reindex.influence p (restrictCube (Touches B) f y) d =
      Reindex.influence p (restrictCube (Touches B) f y) e := by
  obtain ⟨σ, hσ⟩ := exists_blockPerm_map_of_sdiff_eq B e.val.val d.val.val
    (e.val.property.trans d.val.property.symm) hout.symm
  have hmap : edgePerm (extendBlockPerm B σ) e.val = d.val := Subtype.ext hσ
  simpa only [hmap] using restricted_influence_blockPerm B σ p f hf y e

theorem restricted_influence_le {n r : ℕ} (B : Finset (Fin n))
    (hrB : r < B.card) {p : ℝ} (hp : 0 ≤ p) (hp1 : p ≤ 1)
    (f : Config n r → Bool) (hf : IsInvariant f)
    (y : {d : Edge n r // ¬ Touches B d} → Bool)
    (e : {d : Edge n r // Touches B d}) :
    Reindex.influence p (restrictCube (Touches B) f y) e ≤
      (∑ d, Reindex.influence p (restrictCube (Touches B) f y) d) / B.card := by
  classical
  have htouch : ∀ d ∈ orbitFamily B e.val, Touches B d := by
    intro d hd
    obtain ⟨σ, hσ⟩ := exists_blockPerm_map_of_sdiff_eq B e.val.val d.val
      (e.val.property.trans d.property.symm) ((mem_orbitFamily B e.val d).mp hd).symm
    have hmap : edgePerm (extendBlockPerm B σ) e.val = d := Subtype.ext hσ
    rw [← hmap]
    exact (touches_blockPerm_iff B σ e.val).mpr e.property
  have hcard : (B.card : ℝ) ≤
      (((orbitFamily B e.val).subtype (Touches B)).card : ℝ) := by
    simpa only [Finset.card_subtype, Finset.filter_true_of_mem htouch] using
      (show (B.card : ℝ) ≤ ((orbitFamily B e.val).card : ℝ) by
        exact_mod_cast orbitFamily_card_lower B hrB e.val e.property)
  apply Reindex.influence_le_total_div hp hp1 _ e
    ((orbitFamily B e.val).subtype (Touches B))
    (by exact_mod_cast (show 0 < B.card by omega)) hcard
  intro d hd
  exact restricted_influence_eq_of_exterior_eq B p f hf y e d
    ((mem_orbitFamily B e.val d.val).mp (Finset.mem_subtype.mp hd))

end

end HypergraphInfluence.Block
