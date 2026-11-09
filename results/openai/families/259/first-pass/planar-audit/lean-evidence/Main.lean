import Mathlib

open scoped BigOperators

namespace PlanarAudit

def gapCost (h : ℕ) (bigon : Bool) : ℕ :=
  if bigon then 0 else if h = 0 then 2 else h + 1

theorem bad_gap_cost (h : ℕ) : 2 ≤ gapCost h false := by
  simp only [gapCost, Bool.false_eq_true, ↓reduceIte]
  split_ifs <;> omega

theorem gap_classification {I : Type*} [Fintype I] [DecidableEq I]
    (h : I → ℕ) (b : I → Bool)
    (empty : ∀ i, b i = true → h i = 0)
    (small : ∑ i, gapCost (h i) (b i) < 4) :
    (∀ i, b i = true) ∨
      ∃ j, b j = false ∧ (∀ i, i ≠ j → b i = true) ∧
        h j ≤ 2 ∧ (∑ i, h i) = h j := by
  classical
  by_cases all : ∀ i, b i = true
  · exact Or.inl all
  · right
    push Not at all
    obtain ⟨j, hj⟩ := all
    have bj : b j = false := by cases e : b j <;> simp_all
    have cj : 2 ≤ gapCost (h j) (b j) := by
      rw [bj]
      exact bad_gap_cost _
    have others : ∀ i, i ≠ j → b i = true := by
      intro i hij
      by_contra hi
      have bi : b i = false := by cases e : b i <;> simp_all
      have ci : 2 ≤ gapCost (h i) (b i) := by
        rw [bi]
        exact bad_gap_cost _
      have pair :
          gapCost (h i) (b i) + gapCost (h j) (b j) ≤
            ∑ k, gapCost (h k) (b k) := by
        have hs := Finset.sum_le_sum_of_subset_of_nonneg
          (Finset.subset_univ ({i, j} : Finset I))
          (fun k _ _ => Nat.zero_le (gapCost (h k) (b k)))
        simpa [hij] using hs
      omega
    have single : gapCost (h j) (b j) ≤ ∑ i, gapCost (h i) (b i) :=
      Finset.single_le_sum
        (fun i _ => Nat.zero_le (gapCost (h i) (b i))) (Finset.mem_univ j)
    have hj2 : h j ≤ 2 := by
      have form : gapCost (h j) (b j) = if h j = 0 then 2 else h j + 1 := by
        simp only [gapCost, bj, Bool.false_eq_true, ↓reduceIte]
      split_ifs at form <;> omega
    refine ⟨j, bj, others, hj2, ?_⟩
    apply Finset.sum_eq_single j
    · intro i _ hij
      exact empty i (others i hij)
    · simp

structure GapData (V : Type*) where
  degree : V → ℕ
  outer : V → ℕ
  inner : (v : V) → Fin (outer v) → ℕ
  bigon : (v : V) → Fin (outer v) → Bool
  bigon_empty : ∀ v i, bigon v i = true → inner v i = 0
  degree_eq : ∀ v, outer v ≠ 0 → degree v = outer v + ∑ i, inner v i

def GapData.cost {V : Type*} (G : GapData V) (v : V) : ℕ :=
  if G.outer v = 0 then G.degree v
  else ∑ i, gapCost (G.inner v i) (G.bigon v i)

def Full {V : Type*} (G : GapData V) (v : V) : Prop :=
  0 < G.outer v ∧ ∀ i, G.bigon v i = true

def Long {V : Type*} (G : GapData V) (v : V) : Prop :=
  ∃ j : Fin (G.outer v),
    G.bigon v j = false ∧ (∀ i, i ≠ j → G.bigon v i = true) ∧
      (∑ i, G.inner v i) ≤ 2 ∧
      G.degree v ≤ G.outer v + 2 ∧ 2 ≤ G.outer v

theorem positive_vertex {V : Type*} (G : GapData V)
    (degree : ∀ v, 4 ≤ G.degree v) (v : V) (positive : G.cost v < 4) :
    Full G v ∨ Long G v := by
  classical
  have outer : G.outer v ≠ 0 := by
    intro h
    simp only [GapData.cost, h, ↓reduceIte] at positive
    have := degree v
    omega
  have small : ∑ i, gapCost (G.inner v i) (G.bigon v i) < 4 := by
    simpa [GapData.cost, outer] using positive
  rcases gap_classification (G.inner v) (G.bigon v)
      (G.bigon_empty v) small with all | ⟨j, bj, others, hj, total⟩
  · exact Or.inl ⟨Nat.pos_of_ne_zero outer, all⟩
  · right
    have deq := G.degree_eq v outer
    have dmin := degree v
    refine ⟨j, bj, others, ?_, ?_, ?_⟩ <;> omega

theorem cost_lower {V : Type*} (G : GapData V)
    (degree : ∀ v, 4 ≤ G.degree v) (noFull : ∀ v, ¬ Full G v) :
    ∀ v, 2 ≤ G.cost v := by
  classical
  intro v
  by_cases outer : G.outer v = 0
  · simp only [GapData.cost, outer, ↓reduceIte]
    have := degree v
    omega
  · have notall : ¬ ∀ i, G.bigon v i = true := by
      intro hall
      exact noFull v ⟨Nat.pos_of_ne_zero outer, hall⟩
    push Not at notall
    obtain ⟨i, hi⟩ := notall
    have bi : G.bigon v i = false := by cases e : G.bigon v i <;> simp_all
    have lower : 2 ≤ gapCost (G.inner v i) (G.bigon v i) := by
      rw [bi]
      exact bad_gap_cost _
    have single : gapCost (G.inner v i) (G.bigon v i) ≤
        ∑ j, gapCost (G.inner v j) (G.bigon v j) :=
      Finset.single_le_sum
        (fun j _ => Nat.zero_le (gapCost (G.inner v j) (G.bigon v j)))
        (Finset.mem_univ i)
    simpa [GapData.cost, outer] using lower.trans single

theorem two_positive {V : Type*} [Fintype V] (cost : V → ℕ)
    (lower : ∀ v, 2 ≤ cost v)
    (curvature : 4 ≤ ∑ v, (4 - (cost v : ℤ))) :
    ∃ v w, v ≠ w ∧ cost v < 4 ∧ cost w < 4 := by
  classical
  have first : ∃ v, cost v < 4 := by
    by_contra h
    push Not at h
    have bound : ∑ v, (4 - (cost v : ℤ)) ≤ ∑ _v : V, (0 : ℤ) := by
      apply Finset.sum_le_sum
      intro v _
      have := h v
      omega
    simp only [Finset.sum_const_zero] at bound
    omega
  obtain ⟨v, hv⟩ := first
  have second : ∃ w, v ≠ w ∧ cost w < 4 := by
    by_contra h
    push Not at h
    have bound : ∑ w, (4 - (cost w : ℤ)) ≤
        ∑ w : V, (if w = v then (2 : ℤ) else 0) := by
      apply Finset.sum_le_sum
      intro w _
      by_cases hw : w = v
      · simp only [hw, ↓reduceIte]
        have := lower v
        omega
      · simp only [hw, ↓reduceIte]
        have hcost : 4 ≤ cost w := h w (Ne.symm hw)
        omega
    simp only [Finset.sum_ite_eq', Finset.mem_univ, ↓reduceIte] at bound
    omega
  obtain ⟨w, hvw, hw⟩ := second
  exact ⟨v, w, hvw, hv, hw⟩

theorem gap_dichotomy {V : Type*} [Fintype V] (G : GapData V)
    (degree : ∀ v, 4 ≤ G.degree v)
    (curvature : 4 ≤ ∑ v, (4 - (G.cost v : ℤ))) :
    (∃ v, Full G v) ∨ ∃ v w, v ≠ w ∧ Long G v ∧ Long G w := by
  classical
  by_cases full : ∃ v, Full G v
  · exact Or.inl full
  · have noFull : ∀ v, ¬ Full G v := by simpa using full
    obtain ⟨v, w, hvw, hv, hw⟩ :=
      two_positive G.cost (cost_lower G degree noFull) curvature
    have lv : Long G v := (positive_vertex G degree v hv).resolve_left (noFull v)
    have lw : Long G w := (positive_vertex G degree w hw).resolve_left (noFull w)
    exact Or.inr ⟨v, w, hvw, lv, lw⟩

def faceUpper (length outer : ℕ) : ℕ :=
  if length = 2 then 0
  else if outer ≤ 1 then length - outer else 2 * (length - outer)

theorem face_bound (length outer : ℕ) (length_min : 2 ≤ length)
    (outer_le : outer ≤ length)
    (bipartite : outer = 0 → length ≠ 2 → 4 ≤ length) :
    (faceUpper length outer : ℤ) ≤ 2 * (length : ℤ) - 4 := by
  unfold faceUpper
  split_ifs with htwo hone
  · omega
  · have four := bipartite
    omega
  · omega

theorem no_inner_triangle (a b c : Bool)
    (ab : a ≠ b) (bc : b ≠ c) (ca : c ≠ a) : False := by
  cases a <;> cases b <;> cases c <;> simp_all

theorem no_closed_component {V F : Type*} [Fintype V] [Fintype F]
    (degree : V → ℤ) (length : F → ℤ) (edges : ℤ)
    (vertex_min : ∀ v, 4 ≤ degree v)
    (face_min : ∀ f, 4 ≤ length f)
    (vertex_darts : ∑ v, degree v = 2 * edges)
    (face_darts : ∑ f, length f = 2 * edges)
    (euler : (Fintype.card V : ℤ) - edges + Fintype.card F = 2) : False := by
  have vertices : 4 * (Fintype.card V : ℤ) ≤ ∑ v, degree v := by
    calc
      _ = ∑ _v : V, (4 : ℤ) := by simp; ring
      _ ≤ _ := Finset.sum_le_sum (fun v _ => vertex_min v)
  have faces : 4 * (Fintype.card F : ℤ) ≤ ∑ f, length f := by
    calc
      _ = ∑ _f : F, (4 : ℤ) := by simp; ring
      _ ≤ _ := Finset.sum_le_sum (fun f _ => face_min f)
  linarith

theorem curvature_from_faces {V F : Type*} [Fintype V] [Fintype F]
    (cost : V → ℤ) (weight length : F → ℤ) (edges : ℤ)
    (partition : ∑ v, cost v = ∑ f, weight f)
    (darts : ∑ f, length f = 2 * edges)
    (euler : (Fintype.card V : ℤ) + 1 - edges + Fintype.card F = 2)
    (face : ∀ f, weight f ≤ 2 * length f - 4) :
    4 ≤ ∑ v, (4 - cost v) := by
  have faceSum : ∑ f, weight f ≤
      2 * (∑ f, length f) - 4 * (Fintype.card F : ℤ) := by
    calc
      _ ≤ ∑ f, (2 * length f - 4) :=
        Finset.sum_le_sum (fun f _ => face f)
      _ = _ := by simp [Finset.sum_sub_distrib, Finset.mul_sum]; ring
  have vertexSum : ∑ v, (4 - cost v) =
      4 * (Fintype.card V : ℤ) - ∑ v, cost v := by
    simp [Finset.sum_sub_distrib]
    ring
  rw [vertexSum, partition]
  linarith

def cutOrder {n : ℕ} (j : Fin n) : Equiv.Perm (Fin n) :=
  finCycle (finRotate n j)

theorem cutOrder_ne_cut {n : ℕ} (j k : Fin n) (hk : k.val + 1 < n) :
    cutOrder j k ≠ j := by
  letI : NeZero n := j.neZero
  intro h
  have heq : (k + 1) + j = 0 + j := by
    simpa [cutOrder, finCycle_apply, finRotate_apply,
      add_assoc, add_comm, add_left_comm] using h
  have hz : k + 1 = 0 := add_right_cancel heq
  have hval := congrArg Fin.val hz
  rw [Fin.val_add_one_of_lt' hk] at hval
  simp only [Fin.val_zero] at hval
  omega

theorem cutOrder_next {n : ℕ} (j k : Fin n) (hk : k.val + 1 < n) :
    cutOrder j ⟨k.val + 1, hk⟩ = finRotate n (cutOrder j k) := by
  letI : NeZero n := j.neZero
  have hnext : (⟨k.val + 1, hk⟩ : Fin n) = k + 1 := by
    apply Fin.ext
    exact (Fin.val_add_one_of_lt' hk).symm
  simp [cutOrder, finCycle_apply, finRotate_apply, hnext,
    add_comm, add_left_comm]

structure BoundaryData {V : Type*} (G : GapData V)
    (Ω Λ H : Type*) [Group H] where
  endpoint : (Σ v, Fin (G.outer v)) → Ω
  endpoint_injective : Function.Injective endpoint
  position : (v : V) → Fin (G.outer v) → Fin (G.degree v)
  position_injective : ∀ v, Function.Injective (position v)
  next : Ω → Ω
  wordLetter : Ω → Λ
  wordGap : Ω → H
  relatorLetter : (v : V) → Fin (G.degree v) → Λ
  relatorGap : (v : V) → Fin (G.degree v) → H
  letters : ∀ v i,
    wordLetter (endpoint ⟨v, i⟩) = relatorLetter v (position v i)
  outer_next : ∀ v i, G.bigon v i = true →
    next (endpoint ⟨v, i⟩) = endpoint ⟨v, finRotate (G.outer v) i⟩
  inner_next : ∀ v i, G.bigon v i = true →
    finRotate (G.degree v) (position v i) =
      position v (finRotate (G.outer v) i)
  face_equation : ∀ v i, G.bigon v i = true →
    relatorGap v (position v i) * (wordGap (endpoint ⟨v, i⟩))⁻¹ = 1

def Matches {V Ω Λ H : Type*} [Group H] {G : GapData V}
    (B : BoundaryData G Ω Λ H) (v : V)
    (q : Equiv.Perm (Fin (G.outer v))) : Prop :=
  Function.Injective (fun i => B.endpoint ⟨v, q i⟩) ∧
  Function.Injective (fun i => B.position v (q i)) ∧
  (∀ i, B.wordLetter (B.endpoint ⟨v, q i⟩) =
    B.relatorLetter v (B.position v (q i))) ∧
  ∀ (i : Fin (G.outer v)) (hi : i.val + 1 < G.outer v),
    B.next (B.endpoint ⟨v, q i⟩) =
        B.endpoint ⟨v, q ⟨i.val + 1, hi⟩⟩ ∧
    finRotate (G.degree v) (B.position v (q i)) =
        B.position v (q ⟨i.val + 1, hi⟩) ∧
    B.wordGap (B.endpoint ⟨v, q i⟩) =
        B.relatorGap v (B.position v (q i))

theorem ordered_match {V Ω Λ H : Type*} [Group H] {G : GapData V}
    (B : BoundaryData G Ω Λ H) (v : V) (j : Fin (G.outer v))
    (bigons : ∀ i, i ≠ j → G.bigon v i = true) :
    Matches B v (cutOrder j) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro i k h
    have hs := B.endpoint_injective h
    have hi : cutOrder j i = cutOrder j k := by simpa using hs
    exact (cutOrder j).injective hi
  · exact (B.position_injective v).comp (cutOrder j).injective
  · intro i
    exact B.letters v _
  · intro i hi
    have hb := bigons (cutOrder j i) (cutOrder_ne_cut j i hi)
    have hn := cutOrder_next j i hi
    refine ⟨?_, ?_, ?_⟩
    · simpa only [hn] using B.outer_next v (cutOrder j i) hb
    · simpa only [hn] using B.inner_next v (cutOrder j i) hb
    · exact (mul_inv_eq_one.mp (B.face_equation v (cutOrder j i) hb)).symm

theorem endpoint_disjoint {V Ω Λ H : Type*} [Group H] {G : GapData V}
    (B : BoundaryData G Ω Λ H) {v w : V} (different : v ≠ w) :
    ∀ (i : Fin (G.outer v)) (j : Fin (G.outer w)),
      B.endpoint ⟨v, i⟩ ≠ B.endpoint ⟨w, j⟩ := by
  intro i j h
  exact different (congrArg Sigma.fst (B.endpoint_injective h))

theorem coefficient_sensitive_core
    {V F Ω Λ H : Type*} [Fintype V] [Fintype F] [Group H]
    (G : GapData V) (B : BoundaryData G Ω Λ H)
    (weight length : F → ℤ) (edges : ℤ)
    (degree : ∀ v, 4 ≤ G.degree v)
    (partition : ∑ v, (G.cost v : ℤ) = ∑ f, weight f)
    (darts : ∑ f, length f = 2 * edges)
    (euler : (Fintype.card V : ℤ) + 1 - edges + Fintype.card F = 2)
    (face : ∀ f, weight f ≤ 2 * length f - 4) :
    (∃ v, Full G v) ∨
      ∃ v w, v ≠ w ∧ G.degree v ≤ G.outer v + 2 ∧
        G.degree w ≤ G.outer w + 2 ∧ 2 ≤ G.outer v ∧ 2 ≤ G.outer w ∧
        (∃ j, Matches B v (cutOrder j)) ∧
        (∃ j, Matches B w (cutOrder j)) ∧
        (∀ (i : Fin (G.outer v)) (j : Fin (G.outer w)),
          B.endpoint ⟨v, i⟩ ≠ B.endpoint ⟨w, j⟩) := by
  classical
  have curvature := curvature_from_faces
    (fun v => (G.cost v : ℤ)) weight length edges partition darts euler face
  rcases gap_dichotomy G degree curvature with full | ⟨v, w, hvw, lv, lw⟩
  · exact Or.inl full
  · obtain ⟨j, _, bj, _, dv, nv⟩ := lv
    obtain ⟨k, _, bk, _, dw, nw⟩ := lw
    exact Or.inr ⟨v, w, hvw, dv, dw, nv, nw,
      ⟨j, ordered_match B v j bj⟩, ⟨k, ordered_match B w k bk⟩,
      endpoint_disjoint B hvw⟩

theorem sandwich_eq_iff {H : Type*} [Group H] (p q h k : H) :
    p * h * q = p * k * q ↔ h = k := by
  constructor
  · intro eq
    exact mul_left_cancel (mul_right_cancel eq)
  · rintro rfl
    rfl

theorem conjugate_one_iff {H : Type*} [Group H] (p h : H) :
    p * h * p⁻¹ = 1 ↔ h = 1 := by
  have eq := sandwich_eq_iff p p⁻¹ h 1
  simpa only [mul_one, mul_inv_cancel] using eq

end PlanarAudit
