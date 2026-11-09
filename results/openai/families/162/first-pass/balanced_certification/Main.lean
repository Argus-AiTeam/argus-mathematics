import Mathlib

open scoped BigOperators

namespace Audit162

section Budgets

variable {X L : Type*} [DecidableEq X] [DecidableEq L]

def BlocksCover (blocks : L → Finset X) (C : Finset L) : Prop :=
  ∀ x, ∃ l ∈ C, x ∈ blocks l

theorem capacity_bound (U Z : Finset X) (T : Finset L)
    (blocks : L → Finset X) (a m : ℕ)
    (hcover : U ⊆ Z ∪ T.biUnion blocks)
    (hZ : Z.card ≤ a) (hblocks : ∀ l ∈ T, (blocks l).card ≤ m) :
    U.card ≤ a + T.card * m := by
  calc
    U.card ≤ (Z ∪ T.biUnion blocks).card := Finset.card_le_card hcover
    _ ≤ Z.card + (T.biUnion blocks).card := Finset.card_union_le _ _
    _ ≤ Z.card + ∑ l ∈ T, (blocks l).card :=
      Nat.add_le_add_left Finset.card_biUnion_le _
    _ ≤ a + ∑ _l ∈ T, m := Nat.add_le_add hZ (Finset.sum_le_sum hblocks)
    _ = a + T.card * m := by simp

theorem residual_coverage (blocks : L → Finset X) (C F : Finset L)
    (U Z : Finset X) (hcover : BlocksCover blocks C)
    (hforced : ∀ l ∈ F, ∀ x ∈ U, x ∈ blocks l → x ∈ Z) :
    U ⊆ Z ∪ (C \ F).biUnion (fun l => U ∩ blocks l) := by
  intro x hx
  obtain ⟨l, hl, hxl⟩ := hcover x
  by_cases hf : l ∈ F
  · exact Finset.mem_union_left _ (hforced l hf x hx hxl)
  · exact Finset.mem_union_right _ (Finset.mem_biUnion.mpr
      ⟨l, Finset.mem_sdiff.mpr ⟨hl, hf⟩, Finset.mem_inter.mpr ⟨hx, hxl⟩⟩)

theorem occupancy_forces_label (blocks : L → Finset X) (C P : Finset L)
    (U : Finset X) (v : L) (q B : ℕ) (rho : ℝ)
    (hsize : 2 * (1 + (B : ℝ)) < rho * q)
    (houtside : ((C \ P).card : ℝ) ≤ rho * q / 4)
    (hoccupancy : rho * q ≤ (U.card : ℝ))
    (homitted : v ∉ C → ∃ Z : Finset X,
      Z.card ≤ 1 + B ∧
      U ⊆ Z ∪ (C \ P).biUnion (fun l => U ∩ blocks l) ∧
      ∀ l ∈ C \ P, (U ∩ blocks l).card ≤ 2) :
    v ∈ C := by
  by_contra hv
  obtain ⟨Z, hZ, hcover, hblocks⟩ := homitted hv
  have h := capacity_bound U Z (C \ P) (fun l => U ∩ blocks l)
    (1 + B) 2 hcover hZ hblocks
  have hreal : (U.card : ℝ) ≤ 1 + B + ((C \ P).card : ℝ) * 2 := by
    exact_mod_cast h
  linarith

theorem parallel_pencil_impossible (blocks : L → Finset X)
    (q : ℕ) (C F : Finset L) (U Z : Finset X)
    (hF : F ⊆ C) (hbudget : C.card ≤ q) (hcount : F.card + 3 = q)
    (hU : U.card = 8) (hZ : Z.card = 0)
    (hforced : ∀ l ∈ F, ∀ x ∈ U, x ∈ blocks l → x ∈ Z)
    (hblocks : ∀ l ∈ C \ F, (U ∩ blocks l).card ≤ 2) :
    ¬ BlocksCover blocks C := by
  intro hcover
  have hcard := Finset.card_sdiff_add_card_eq_card hF
  have hextra : (C \ F).card ≤ 3 := by omega
  have h := capacity_bound U Z (C \ F) (fun l => U ∩ blocks l)
    0 2 (residual_coverage blocks C F U Z hcover hforced)
    (by omega) hblocks
  omega

theorem affine_pencil_impossible (blocks : L → Finset X)
    (q b : ℕ) (C F : Finset L) (U Z : Finset X)
    (hF : F ⊆ C) (hbudget : C.card ≤ q) (hcount : F.card + b = q + 1)
    (hforced : ∀ l ∈ F, ∀ x ∈ U, x ∈ blocks l → x ∈ Z)
    (hone : b = 1 → U.card = 4 ∧ Z.card ≤ 3)
    (htwo : b = 2 → U.card = 8 ∧ Z.card ≤ 2 ∧
      ∀ l ∈ C \ F, (U ∩ blocks l).card ≤ 4)
    (hlocal : 3 ≤ b → ∀ T : Finset L, T.card ≤ b - 1 →
      ¬ U ⊆ Z ∪ T.biUnion (fun l => U ∩ blocks l)) :
    ¬ BlocksCover blocks C := by
  intro hcover
  have hcard := Finset.card_sdiff_add_card_eq_card hF
  have hres := residual_coverage blocks C F U Z hcover hforced
  by_cases hzero : b = 0
  · omega
  by_cases h1 : b = 1
  · obtain ⟨hU, hZ⟩ := hone h1
    have hextra : (C \ F).card = 0 := by omega
    have h := capacity_bound U Z (C \ F) (fun l => U ∩ blocks l)
      3 U.card hres hZ (fun _ _ => Finset.card_le_card Finset.inter_subset_left)
    simp only [hextra, zero_mul, add_zero] at h
    omega
  by_cases h2 : b = 2
  · obtain ⟨hU, hZ, hblocks⟩ := htwo h2
    have hextra : (C \ F).card ≤ 1 := by omega
    have h := capacity_bound U Z (C \ F) (fun l => U ∩ blocks l)
      2 4 hres hZ hblocks
    omega
  · exact hlocal (by omega) (C \ F) (by omega) hres

theorem four_cycle_repair :
    ∀ i j : Fin 4, i.val % 2 = j.val % 2 ∨
      (i.val + 1) % 4 = j.val ∨ (j.val + 1) % 4 = i.val := by
  decide

end Budgets

structure PartiteHypergraph (r n : ℕ) where
  edges : Finset (Fin r → Fin n)

namespace PartiteHypergraph

abbrev Vertex (r n : ℕ) := Fin r × Fin n

def Covers {r n : ℕ} (H : PartiteHypergraph r n)
    (C : Finset (Vertex r n)) : Prop :=
  ∀ e ∈ H.edges, ∃ i, (i, e i) ∈ C

def Intersecting {r n : ℕ} (H : PartiteHypergraph r n) : Prop :=
  H.edges.Nonempty ∧ ∀ e ∈ H.edges, ∀ f ∈ H.edges, ∃ i, e i = f i

def Nonisolated {r n : ℕ} (H : PartiteHypergraph r n) : Prop :=
  ∀ i v, ∃ e ∈ H.edges, e i = v

def HasCoverNumber {r n : ℕ} (H : PartiteHypergraph r n) (k : ℕ) : Prop :=
  (∃ C : Finset (Vertex r n), H.Covers C ∧ C.card = k) ∧
    ∀ C : Finset (Vertex r n), H.Covers C → k ≤ C.card

def edgeGraph {r n : ℕ} (e : Fin r → Fin n) : Finset (Vertex r n) :=
  Finset.univ.image (fun i => (i, e i))

theorem mem_edgeGraph {r n : ℕ} (e : Fin r → Fin n) (i : Fin r) (v : Fin n) :
    (i, v) ∈ edgeGraph e ↔ e i = v := by
  simp [edgeGraph]

theorem edgeGraph_card {r n : ℕ} (e : Fin r → Fin n) :
    (edgeGraph e).card = r := by
  rw [edgeGraph, Finset.card_image_of_injective _ (fun _ _ h => congrArg Prod.fst h)]
  simp

theorem edgeGraph_injective {r n : ℕ} :
    Function.Injective (edgeGraph : (Fin r → Fin n) → Finset (Vertex r n)) := by
  intro e f h
  funext i
  have hi : (i, e i) ∈ edgeGraph f := by
    rw [← h]
    exact (mem_edgeGraph e i (e i)).mpr rfl
  exact ((mem_edgeGraph f i (e i)).mp hi).symm

def ordinaryEdges {r n : ℕ} (H : PartiteHypergraph r n) :
    Finset (Finset (Vertex r n)) :=
  H.edges.image edgeGraph

theorem ordinary_cover_iff {r n : ℕ} (H : PartiteHypergraph r n)
    (C : Finset (Vertex r n)) :
    (∀ E ∈ H.ordinaryEdges, (E ∩ C).Nonempty) ↔ H.Covers C := by
  constructor
  · intro h e he
    obtain ⟨⟨i, v⟩, hv⟩ := h (edgeGraph e) (Finset.mem_image.mpr ⟨e, he, rfl⟩)
    obtain ⟨hE, hC⟩ := Finset.mem_inter.mp hv
    have hv := (mem_edgeGraph e i v).mp hE
    exact ⟨i, by simpa [hv] using hC⟩
  · intro h E hE
    obtain ⟨e, he, rfl⟩ := Finset.mem_image.mp hE
    obtain ⟨i, hi⟩ := h e he
    exact ⟨(i, e i), Finset.mem_inter.mpr ⟨(mem_edgeGraph e i (e i)).mpr rfl, hi⟩⟩

end PartiteHypergraph

section Partitions

variable {X : Type*} {r n : ℕ}

def IsPartition (blocks : Fin r → Fin n → Finset X) : Prop :=
  ∀ i x, ∃! v, x ∈ blocks i v

noncomputable def code (blocks : Fin r → Fin n → Finset X)
    (hp : IsPartition blocks) (x : X) (i : Fin r) : Fin n :=
  Classical.choose (hp i x)

theorem code_mem (blocks : Fin r → Fin n → Finset X)
    (hp : IsPartition blocks) (x : X) (i : Fin r) :
    x ∈ blocks i (code blocks hp x i) :=
  (Classical.choose_spec (hp i x)).1

theorem code_eq (blocks : Fin r → Fin n → Finset X)
    (hp : IsPartition blocks) (x : X) (i : Fin r) (v : Fin n)
    (hx : x ∈ blocks i v) : code blocks hp x i = v :=
  ((Classical.choose_spec (hp i x)).2 v hx).symm

variable [Fintype X]

noncomputable def realize (blocks : Fin r → Fin n → Finset X)
    (hp : IsPartition blocks) : PartiteHypergraph r n := by
  classical
  exact ⟨Finset.univ.image (code blocks hp)⟩

theorem code_mem_edges (blocks : Fin r → Fin n → Finset X)
    (hp : IsPartition blocks) (x : X) :
    code blocks hp x ∈ (realize blocks hp).edges := by
  classical
  exact Finset.mem_image.mpr ⟨x, Finset.mem_univ _, rfl⟩

theorem covers_iff_blocks (blocks : Fin r → Fin n → Finset X)
    (hp : IsPartition blocks) (C : Finset (PartiteHypergraph.Vertex r n)) :
    (realize blocks hp).Covers C ↔ BlocksCover (fun l => blocks l.1 l.2) C := by
  classical
  constructor
  · intro h x
    obtain ⟨i, hi⟩ := h (code blocks hp x) (code_mem_edges blocks hp x)
    exact ⟨(i, code blocks hp x i), hi, code_mem blocks hp x i⟩
  · intro h e he
    obtain ⟨x, _, rfl⟩ := Finset.mem_image.mp he
    obtain ⟨⟨i, v⟩, hv, hx⟩ := h x
    exact ⟨i, by simpa [code_eq blocks hp x i v hx] using hv⟩

theorem balanced_realization (q : ℕ)
    (blocks : Fin (q + 1) → Fin (q + 1) → Finset X)
    (hp : IsPartition blocks)
    (hne : ∀ i v, (blocks i v).Nonempty)
    (hint : ∀ x y, ∃ i v, x ∈ blocks i v ∧ y ∈ blocks i v)
    (hbudget : ∀ C : Finset (PartiteHypergraph.Vertex (q + 1) (q + 1)),
      BlocksCover (fun l => blocks l.1 l.2) C → q + 1 ≤ C.card) :
    ∃ H : PartiteHypergraph (q + 1) (q + 1),
      H.Intersecting ∧ H.Nonisolated ∧ H.HasCoverNumber (q + 1) := by
  classical
  refine ⟨realize blocks hp, ?_, ?_, ?_⟩
  · refine ⟨?_, ?_⟩
    · obtain ⟨x, _⟩ := hne 0 0
      exact ⟨code blocks hp x, code_mem_edges blocks hp x⟩
    · intro e he f hf
      obtain ⟨x, _, rfl⟩ := Finset.mem_image.mp he
      obtain ⟨y, _, rfl⟩ := Finset.mem_image.mp hf
      obtain ⟨i, v, hx, hy⟩ := hint x y
      exact ⟨i, (code_eq blocks hp x i v hx).trans (code_eq blocks hp y i v hy).symm⟩
  · intro i v
    obtain ⟨x, hx⟩ := hne i v
    exact ⟨code blocks hp x, code_mem_edges blocks hp x, code_eq blocks hp x i v hx⟩
  · constructor
    · refine ⟨Finset.univ.image (fun v : Fin (q + 1) => ((0 : Fin (q + 1)), v)),
        ?_, ?_⟩
      · intro e _
        exact ⟨0, Finset.mem_image.mpr ⟨e 0, Finset.mem_univ _, rfl⟩⟩
      · rw [Finset.card_image_of_injective _ (fun _ _ h => congrArg Prod.snd h)]
        simp
    · intro C hC
      exact hbudget C ((covers_iff_blocks blocks hp C).mp hC)

end Partitions

#print axioms occupancy_forces_label
#print axioms parallel_pencil_impossible
#print axioms affine_pencil_impossible
#print axioms balanced_realization
#print axioms PartiteHypergraph.ordinary_cover_iff

end Audit162
