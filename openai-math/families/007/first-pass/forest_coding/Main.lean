import Mathlib

open Function

namespace ForestCoding

section Linear

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

theorem dependent_pair_saturates (e w : V) (he : e ≠ 0)
    (hmax : ¬ LinearIndependent K ![e, w]) :
    ∃ c : K, w = c • e := by
  by_contra h
  apply hmax
  apply (LinearIndependent.pair_iff' he).2
  intro c hc
  exact h ⟨c, hc.symm⟩

theorem maximal_pair_saturates {ι : Type*} (old : ι → V)
    (hold : LinearIndependent K old) (e w : V)
    (he : (Submodule.span K (Set.range old)).mkQ e ≠ 0)
    (hmax : ¬ LinearIndependent K (Sum.elim old ![e, w])) :
    ∃ c : K, (Submodule.span K (Set.range old)).mkQ w =
      c • (Submodule.span K (Set.range old)).mkQ e := by
  let D := Submodule.span K (Set.range old)
  apply dependent_pair_saturates (D.mkQ e) (D.mkQ w) he
  intro hpair
  apply hmax
  apply (linearIndependent_span hold).sumElim_of_quotient ![e, w]
  have hfun : (D.mkQ ∘ ![e, w]) = ![D.mkQ e, D.mkQ w] := by
    funext i
    fin_cases i <;> rfl
  change LinearIndependent K (D.mkQ ∘ ![e, w])
  rw [hfun]
  exact hpair

theorem regular_run_nonzero {ι : Type*} (u : ι → V)
    (hu : LinearIndependent K u) (z : ι) (c : K) (hc : c ≠ 0) :
    c • u z ≠ 0 := by
  exact smul_ne_zero hc (hu.ne_zero z)

theorem independent_balance {ι : Type*} [Fintype ι]
    (u : ι → V) (hu : LinearIndependent K u) (c : ι → K)
    (hbalance : ∑ i, c i • u i = 0) :
    ∀ i, c i = 0 := by
  exact Fintype.linearIndependent_iff.mp hu c hbalance

theorem independent_polygon_impossible {ι : Type*} [Fintype ι] [Nonempty ι]
    (u : ι → V) (hu : LinearIndependent K u)
    (start finish : ι → V) (c : ι → K)
    (hstep : ∀ i, finish i - start i = c i • u i)
    (hclosed : ∑ i, (finish i - start i) = 0)
    (hnonzero : ∀ i, c i ≠ 0) : False := by
  have hbalance : ∑ i, c i • u i = 0 := by
    simpa only [hstep] using hclosed
  obtain ⟨i⟩ := ‹Nonempty ι›
  exact hnonzero i (independent_balance u hu c hbalance i)

end Linear

section Paths

variable {Vertex : Type*}

noncomputable def endpointDecoder (G : SimpleGraph Vertex) (a b : Vertex) :
    Option (List Vertex) := by
  classical
  exact if h : G.Reachable a b then some h.some.toPath.val.support else none

theorem endpointDecoder_correct (G : SimpleGraph Vertex) (hG : G.IsAcyclic)
    {a b : Vertex} (p : G.Walk a b)
    (hp : List.IsChain (· ≠ ·) p.edges) :
    endpointDecoder G a b = some p.support := by
  classical
  have hpath : p.IsPath := (hG.isPath_iff_isChain p).2 hp
  have heq := hG.path_unique p.reachable.some.toPath ⟨p, hpath⟩
  simp only [endpointDecoder, dif_pos p.reachable]
  exact congrArg (fun q : G.Path a b => some q.val.support) heq

theorem nonbacktracking_walk_unique (G : SimpleGraph Vertex) (hG : G.IsAcyclic)
    {a b : Vertex} (p q : G.Walk a b)
    (hp : List.IsChain (· ≠ ·) p.edges)
    (hq : List.IsChain (· ≠ ·) q.edges) : p = q := by
  exact congrArg Subtype.val
    (hG.path_unique ⟨p, (hG.isPath_iff_isChain p).2 hp⟩
      ⟨q, (hG.isPath_iff_isChain q).2 hq⟩)

theorem endpointDecoder_labels (G : SimpleGraph Vertex) (hG : G.IsAcyclic)
    {a b : Vertex} (p : G.Walk a b)
    (hp : List.IsChain (· ≠ ·) p.edges) (isLine : Vertex → Bool) :
    (endpointDecoder G a b).map (List.filter isLine) =
      some (p.support.filter isLine) := by
  rw [endpointDecoder_correct G hG p hp]
  rfl

end Paths

def recordBudget (r B I : ℕ) := (6 * r - 4) * B + I

abbrev Code (n r B I : ℕ) :=
  (Fin (4 * n) → Bool) × Fin (2 ^ (6 * n + 3)) ×
    (Fin (recordBudget r B I) → Fin (2 * n))

abbrev Pattern (n : ℕ) := Fin n → Fin n

theorem record_budget {r d B I actualI S O : ℕ} (hr : 1 ≤ r)
    (hd : d ≤ 2 * r - 2) (hS : S ≤ (d + 1) * B)
    (hO : O ≤ d * B) (hI : actualI ≤ I) :
    2 * S + O + actualI ≤ recordBudget r B I := by
  have hcoeff : 3 * d + 2 ≤ 6 * r - 4 := by omega
  calc
    2 * S + O + actualI ≤ (3 * d + 2) * B + I := by nlinarith
    _ ≤ (6 * r - 4) * B + I :=
      Nat.add_le_add_right (Nat.mul_le_mul_right B hcoeff) I

theorem code_card (n r B I : ℕ) :
    Fintype.card (Code n r B I) =
      2 ^ (10 * n + 3) * (2 * n) ^ recordBudget r B I := by
  simp only [Code, Fintype.card_prod, Fintype.card_fun, Fintype.card_fin,
    Fintype.card_bool]
  rw [← mul_assoc, ← pow_add]
  have he : 4 * n + (6 * n + 3) = 10 * n + 3 := by omega
  rw [he]

theorem coefficient_uniform_injection {Witness : Type*}
    (n r B I : ℕ) (valid : Witness → Pattern n → Prop)
    (emit : ∀ w p, valid w p → Code n r B I)
    (decode : Code n r B I → Option (Pattern n))
    (hdecode : ∀ w p h, decode (emit w p h) = some p) :
    ∃ encode : {p : Pattern n // ∃ w, valid w p} → Code n r B I,
      Injective encode := by
  classical
  let encode : {p : Pattern n // ∃ w, valid w p} → Code n r B I :=
    fun p => emit (Classical.choose p.property) p.val (Classical.choose_spec p.property)
  refine ⟨encode, ?_⟩
  intro p q heq
  apply Subtype.ext
  have hp : decode (encode p) = some p.val := hdecode _ _ _
  have hq : decode (encode q) = some q.val := hdecode _ _ _
  exact Option.some.inj (hp.symm.trans ((congrArg decode heq).trans hq))

theorem coefficient_uniform_card {Witness : Type*}
    (n r B I : ℕ) (valid : Witness → Pattern n → Prop)
    (emit : ∀ w p, valid w p → Code n r B I)
    (decode : Code n r B I → Option (Pattern n))
    (hdecode : ∀ w p h, decode (emit w p h) = some p) :
    Nat.card {p : Pattern n // ∃ w, valid w p} ≤
      2 ^ (10 * n + 3) * (2 * n) ^ recordBudget r B I := by
  classical
  obtain ⟨encode, hinj⟩ := coefficient_uniform_injection n r B I valid emit decode hdecode
  calc
    Nat.card {p : Pattern n // ∃ w, valid w p} ≤ Nat.card (Code n r B I) :=
      Nat.card_le_card_of_injective encode hinj
    _ = 2 ^ (10 * n + 3) * (2 * n) ^ recordBudget r B I := by
      rw [Nat.card_eq_fintype_card, code_card]

end ForestCoding
