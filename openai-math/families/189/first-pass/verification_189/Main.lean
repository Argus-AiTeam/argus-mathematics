import OAI.Combinatorics.Ramsey.CycleClique.MainTheorem
import OAI.Combinatorics.Ramsey.CycleClique.RamseyNumbers

namespace Audit189

open scoped SimpleGraph

def cycleNext {m : ℕ} (i : Fin m) : Fin m :=
  ⟨(i.val + 1) % m, Nat.mod_lt _ (Nat.zero_lt_of_lt i.isLt)⟩

def HasExactCycle {V : Type*} (G : SimpleGraph V) (m : ℕ) : Prop :=
  ∃ f : Fin m → V, Function.Injective f ∧
    ∀ i, G.Adj (f i) (f (cycleNext i))

def HasIndependent {V : Type*} (G : SimpleGraph V) (n : ℕ) : Prop :=
  ∃ f : Fin n → V, Function.Injective f ∧ ∀ i j, ¬ G.Adj (f i) (f j)

def Forcing (m n N : ℕ) : Prop :=
  ∀ G : SimpleGraph (Fin N), HasExactCycle G m ∨ HasIndependent G n

def LeastForcing (m n N : ℕ) : Prop :=
  Forcing m n N ∧ ∀ M < N, ¬ Forcing m n M

noncomputable def ramsey (m n : ℕ) : ℕ :=
  sInf {N : ℕ | Forcing m n N}

def answer (m n : ℕ) : ℕ :=
  if m = 3 ∧ n = 3 then 6 else (m - 1) * (n - 1) + 1

theorem cycle_copy_iff {V : Type*} {G : SimpleGraph V} {m : ℕ} (hm : 3 ≤ m) :
    HasExactCycle G m ↔ SimpleGraph.cycleGraph m ⊑ G := by
  obtain ⟨k, rfl⟩ : ∃ k, m = k + 2 := ⟨m - 2, by omega⟩
  have hnext (i : Fin (k + 2)) : cycleNext i = i + 1 := by
    apply Fin.ext
    simp [cycleNext, Fin.val_add]
  constructor
  · rintro ⟨f, hf, he⟩
    refine ⟨⟨⟨f, ?_⟩, hf⟩⟩
    intro i j hij
    rcases SimpleGraph.cycleGraph_adj.mp hij with hij | hij
    · have h : i = j + 1 := (sub_eq_iff_eq_add').mp hij
      rw [h]
      exact (hnext j ▸ he j).symm
    · have h : j = i + 1 := (sub_eq_iff_eq_add').mp hij
      rw [h]
      exact hnext i ▸ he i
  · rintro ⟨f⟩
    refine ⟨f, f.injective, fun i => f.toHom.map_adj ?_⟩
    rw [hnext]
    exact SimpleGraph.cycleGraph_adj.mpr (Or.inr (add_sub_cancel_left i 1))

theorem independent_copy_iff {V : Type*} {G : SimpleGraph V} {n : ℕ} :
    HasIndependent G n ↔ (⊤ : SimpleGraph (Fin n)) ⊑ Gᶜ := by
  constructor
  · rintro ⟨f, hf, he⟩
    refine ⟨⟨⟨f, ?_⟩, hf⟩⟩
    intro i j hij
    exact ⟨fun h => hij (hf h), he i j⟩
  · rintro ⟨f⟩
    refine ⟨f, f.injective, ?_⟩
    intro i j
    by_cases hij : i = j
    · subst j
      exact G.loopless.irrefl _
    · exact (f.toHom.map_adj hij).2

theorem forcing_iff {m n N : ℕ} (hm : 3 ≤ m) :
    Forcing m n N ↔ OAI.CycleClique.RamseyProperty m n N := by
  simp only [Forcing, OAI.CycleClique.RamseyProperty, cycle_copy_iff hm,
    independent_copy_iff]

theorem ramsey_eq_upstream {m n : ℕ} (hm : 3 ≤ m) :
    ramsey m n = OAI.CycleClique.cycleCliqueRamsey m n := by
  unfold ramsey OAI.CycleClique.cycleCliqueRamsey
  congr 1
  ext N
  exact forcing_iff hm

theorem formula_nat {m n : ℕ} (hnm : n ≤ m) (hn : 3 ≤ n) :
    OAI.CycleClique.cycleCliqueRamsey m n = answer m n := by
  by_cases he : m = 3 ∧ n = 3
  · obtain ⟨rfl, rfl⟩ := he
    simpa [answer] using OAI.CycleClique.exceptional
  · have hne : (m, n) ≠ (3, 3) := by
      intro hp
      exact he ⟨congrArg Prod.fst hp, congrArg Prod.snd hp⟩
    simpa [answer, he] using OAI.CycleClique.main m n hnm hn hne

theorem least_forcing_nat {m n : ℕ} (hnm : n ≤ m) (hn : 3 ≤ n) :
    LeastForcing m n (answer m n) := by
  have hm : 3 ≤ m := by omega
  have he := formula_nat hnm hn
  have hp : 0 < answer m n := by
    unfold answer
    split_ifs <;> omega
  have hnonempty : {N : ℕ | OAI.CycleClique.RamseyProperty m n N}.Nonempty := by
    by_contra h
    have hs : {N : ℕ | OAI.CycleClique.RamseyProperty m n N} = ∅ :=
      Set.not_nonempty_iff_eq_empty.mp h
    have hz : OAI.CycleClique.cycleCliqueRamsey m n = 0 := by
      unfold OAI.CycleClique.cycleCliqueRamsey
      rw [hs]
      simp
    omega
  have hmem := Nat.sInf_mem hnonempty
  change OAI.CycleClique.RamseyProperty m n
    (OAI.CycleClique.cycleCliqueRamsey m n) at hmem
  refine ⟨(forcing_iff hm).mpr ?_, ?_⟩
  · simpa only [he] using hmem
  · intro M hM hforcing
    have hle : OAI.CycleClique.cycleCliqueRamsey m n ≤ M :=
      Nat.sInf_le ((forcing_iff hm).mp hforcing)
    omega

theorem all_parameters :
    ∀ m n : ℕ, n ≤ m → 3 ≤ n →
      LeastForcing m n (answer m n) ∧ ramsey m n = answer m n := by
  intro m n hnm hn
  exact ⟨least_forcing_nat hnm hn,
    (ramsey_eq_upstream (by omega)).trans (formula_nat hnm hn)⟩

theorem integer_formula :
    (∀ m n : ℤ, n ≤ m → 3 ≤ n → (m, n) ≠ (3, 3) →
      (ramsey m.toNat n.toNat : ℤ) = (m - 1) * (n - 1) + 1) ∧
    ramsey 3 3 = 6 := by
  constructor
  · intro m n hnm hn he
    rw [ramsey_eq_upstream (by omega)]
    exact OAI.CycleClique.thm_main.1 m n hnm hn he
  · rw [ramsey_eq_upstream (by omega)]
    exact OAI.CycleClique.thm_main.2

theorem exceptional_least : LeastForcing 3 3 6 := by
  simpa [answer] using least_forcing_nat (m := 3) (n := 3) (by omega) (by omega)

theorem complete_integer_verification :
    ∀ m n : ℤ, n ≤ m → 3 ≤ n →
      LeastForcing m.toNat n.toNat (answer m.toNat n.toNat) ∧
      (ramsey m.toNat n.toNat : ℤ) =
        if m = 3 ∧ n = 3 then 6 else (m - 1) * (n - 1) + 1 := by
  intro m n hnm hn
  refine ⟨least_forcing_nat (by omega) (by omega), ?_⟩
  by_cases he : m = 3 ∧ n = 3
  · obtain ⟨rfl, rfl⟩ := he
    change (ramsey 3 3 : ℤ) = 6
    exact_mod_cast integer_formula.2
  · rw [if_neg he]
    apply integer_formula.1 m n hnm hn
    intro hp
    exact he ⟨congrArg Prod.fst hp, congrArg Prod.snd hp⟩

theorem chorded_cycle_witness : HasExactCycle (⊤ : SimpleGraph (Fin 4)) 4 := by
  refine ⟨id, Function.injective_id, ?_⟩
  intro i
  change i ≠ cycleNext i
  fin_cases i <;> decide

end Audit189

#print axioms OAI.CycleClique.thm_main
#print axioms OAI.CycleClique.minimal_expanding_counterexample
#print axioms OAI.CycleClique.counterexample_clique_bound
#print axioms OAI.CycleClique.reduced_small_impossible
#print axioms OAI.CycleClique.reduced_large_impossible
#print axioms OAI.CycleClique.finite_range_verified
#print axioms OAI.CycleClique.finite_verification
#print axioms OAI.CycleClique.reduced_counterexample_impossible
#print axioms OAI.CycleClique.ramsey_upper
#print axioms OAI.CycleClique.ramsey_lower_counterexample
#print axioms OAI.CycleClique.exceptional
#print axioms Audit189.cycle_copy_iff
#print axioms Audit189.independent_copy_iff
#print axioms Audit189.forcing_iff
#print axioms Audit189.ramsey_eq_upstream
#print axioms Audit189.all_parameters
#print axioms Audit189.integer_formula
#print axioms Audit189.exceptional_least
#print axioms Audit189.complete_integer_verification
#print axioms Audit189.chorded_cycle_witness
