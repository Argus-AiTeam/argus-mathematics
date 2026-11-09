import Mathlib

/-!
Finite-profile partition compression. The greedy, label, grouping, and rounding
arguments adapt the MIT-licensed OpenAI MetricEntropy implementation at commit
4eaee87548250b2682affda7d05d947c05554bae. Radii and profile weights here are
arbitrary; the only profile hypothesis is the displayed extended-distance
dilation inequality.
-/

namespace SparseProfileCompression

universe uX uY uK uι uLabel uI

noncomputable section

open scoped BigOperators Classical

namespace PartitionGraph

variable {X : Type uX} {ι : Type uι} {Label : ι → Type uLabel}
variable (L : (i : ι) → X → Label i) (T : Finset ι)

def graph : SimpleGraph X where
  Adj x y := x ≠ y ∧ ∃ i ∈ T, L i x = L i y
  symm := by
    constructor
    rintro x y ⟨hxy, i, hi, heq⟩
    exact ⟨hxy.symm, i, hi, heq.symm⟩
  loopless := by
    constructor
    intro x hx
    exact hx.1 rfl

def distance (x y : X) : ℕ∞ := (graph L T).edist x y

def near (j : ℕ) (x y : X) : Prop := distance L T x y ≤ (j : ℕ∞)

@[simp] theorem distance_self (x : X) : distance L T x x = 0 :=
  SimpleGraph.edist_self

theorem near_symm {j : ℕ} {x y : X} (h : near L T j x y) :
    near L T j y x := by
  change distance L T y x ≤ (j : ℕ∞)
  change (graph L T).edist y x ≤ (j : ℕ∞)
  rw [SimpleGraph.edist_comm]
  exact h

theorem near_triangle {j k : ℕ} {x y z : X}
    (hxy : near L T j x y) (hyz : near L T k y z) :
    near L T (j + k) x z := by
  change (graph L T).edist x z ≤ ((j + k : ℕ) : ℕ∞)
  simpa only [Nat.cast_add] using
    (SimpleGraph.edist_triangle (G := graph L T) (u := x) (v := y) (w := z)).trans
      (add_le_add hxy hyz)

theorem near_one_of_label_eq {i : ι} {x y : X}
    (hi : i ∈ T) (heq : L i x = L i y) : near L T 1 x y := by
  by_cases hxy : x = y
  · subst y
    simp [near]
  · have hadj : (graph L T).Adj x y := ⟨hxy, i, hi, heq⟩
    exact (SimpleGraph.edist_eq_one_iff_adj.mpr hadj).le

theorem pivot_replacement {i : ι} {j : ℕ} {v z z' : X}
    (hi : i ∈ T) (heq : L i z' = L i z) (hvz : near L T j v z) :
    near L T (j + 1) v z' :=
  near_triangle L T hvz (near_one_of_label_eq L T hi heq.symm)

theorem pivot_forward {i : ι} {j : ℕ} {v z z' x : X}
    (hi : i ∈ T) (heq : L i z' = L i z) (hvz : near L T j v z)
    (hxv : near L T j x v) : near L T (2 * j + 1) x z' := by
  have h := near_triangle L T hxv (pivot_replacement L T hi heq hvz)
  simpa only [two_mul, add_assoc] using h

theorem pivot_backward {i : ι} {j : ℕ} {v z z' x : X}
    (hi : i ∈ T) (heq : L i z' = L i z) (hvz : near L T j v z)
    (hxz' : near L T (2 * j + 1) x z') : near L T (3 * j + 2) x v := by
  have h := near_triangle L T hxz'
    (near_symm L T (pivot_replacement L T hi heq hvz))
  have hradius : (2 * j + 1) + (j + 1) = 3 * j + 2 := by omega
  rwa [hradius] at h

end PartitionGraph

theorem sum_omitted_mass {Y : Type uY} [Fintype Y] {u : ℕ}
    (T : Y → Finset (Fin u)) (μ : Y → ℝ) :
    (∑ i : Fin u, ∑ y ∈ Finset.univ.filter (fun y => i ∉ T y), μ y) =
      ∑ y, μ y * ((Finset.univ \ T y).card : ℝ) := by
  simp_rw [Finset.sum_filter]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro y _
  rw [← Finset.sum_filter]
  have hfilter : Finset.univ.filter (fun i : Fin u => i ∉ T y) =
      Finset.univ \ T y := by
    ext i
    simp
  rw [hfilter, Finset.sum_const, nsmul_eq_mul, mul_comm]

theorem exists_common_index {Y : Type uY} [Fintype Y] {u : ℕ}
    (hu : 0 < u) (T : Y → Finset (Fin u)) (μ : Y → ℝ)
    (hμ : ∀ y, 0 ≤ μ y) (hmass : ∑ y, μ y ≤ 1)
    {θ : ℝ} (hθ : 0 ≤ θ)
    (hcomp : ∀ y, ((Finset.univ \ T y).card : ℝ) ≤ θ * (u : ℝ)) :
    ∃ i : Fin u, (∑ y ∈ Finset.univ.filter (fun y => i ∉ T y), μ y) ≤ θ := by
  have hsum :
      (∑ i : Fin u, ∑ y ∈ Finset.univ.filter (fun y => i ∉ T y), μ y) ≤
        ∑ _i : Fin u, θ := by
    calc
      _ = ∑ y, μ y * ((Finset.univ \ T y).card : ℝ) := sum_omitted_mass T μ
      _ ≤ ∑ y, μ y * (θ * (u : ℝ)) := by
        exact Finset.sum_le_sum fun y _ => mul_le_mul_of_nonneg_left (hcomp y) (hμ y)
      _ = (∑ y, μ y) * (θ * (u : ℝ)) := by rw [Finset.sum_mul]
      _ ≤ 1 * (θ * (u : ℝ)) :=
        mul_le_mul_of_nonneg_right hmass (mul_nonneg hθ (Nat.cast_nonneg u))
      _ = ∑ _i : Fin u, θ := by simp [nsmul_eq_mul, mul_comm]
  obtain ⟨i, _, hi⟩ := Finset.exists_le_of_sum_le
    (show (Finset.univ : Finset (Fin u)).Nonempty from
      ⟨⟨0, hu⟩, Finset.mem_univ _⟩) hsum
  exact ⟨i, hi⟩

namespace GreedyPivots

variable {X : Type uX} {Y : Type uY}

def mass (μ : Y → ℝ) (U : Finset Y) : ℝ := ∑ y ∈ U, μ y

theorem mass_mono (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y)
    {U V : Finset Y} (hUV : U ⊆ V) : mass μ U ≤ mass μ V :=
  Finset.sum_le_sum_of_subset_of_nonneg hUV (fun y _ _ => hμ y)

variable [Nonempty X] [DecidableEq Y]

def choosePivot (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) (U : Finset Y) : X := by
  exact if h : ∃ x, θ < mass μ (I x \ U) then h.choose else Classical.choice inferInstance

theorem choosePivot_spec (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) (U : Finset Y)
    (h : ∃ x, θ < mass μ (I x \ U)) :
    θ < mass μ (I (choosePivot μ I θ U) \ U) := by
  simpa only [choosePivot, dif_pos h] using h.choose_spec

def covered (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) : ℕ → Finset Y
  | 0 => ∅
  | n + 1 => covered μ I θ n ∪ I (choosePivot μ I θ (covered μ I θ n))

@[simp] theorem covered_zero (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) :
    covered μ I θ 0 = ∅ := rfl

theorem covered_succ (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) (n : ℕ) :
    covered μ I θ (n + 1) =
      covered μ I θ n ∪ I (choosePivot μ I θ (covered μ I θ n)) := rfl

theorem covered_subset_succ (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) (n : ℕ) :
    covered μ I θ n ⊆ covered μ I θ (n + 1) := Finset.subset_union_left

omit [Nonempty X] in
theorem bad_of_subset (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ)
    (hμ : ∀ y, 0 ≤ μ y) {U V : Finset Y} (hUV : U ⊆ V)
    (hV : ∃ x, θ < mass μ (I x \ V)) : ∃ x, θ < mass μ (I x \ U) := by
  obtain ⟨x, hx⟩ := hV
  refine ⟨x, hx.trans_le (mass_mono μ hμ ?_)⟩
  intro y hy
  obtain ⟨hyI, hyV⟩ := Finset.mem_sdiff.mp hy
  exact Finset.mem_sdiff.mpr ⟨hyI, fun hyU => hyV (hUV hyU)⟩

theorem mass_union (μ : Y → ℝ) (U V : Finset Y) :
    mass μ (U ∪ V) = mass μ U + mass μ (V \ U) := by
  calc
    mass μ (U ∪ V) = mass μ (U ∪ (V \ U)) :=
      congrArg (mass μ) Finset.union_sdiff_self_eq_union.symm
    _ = mass μ U + mass μ (V \ U) := Finset.sum_union Finset.disjoint_sdiff

theorem mass_covered_succ (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) (n : ℕ) :
    mass μ (covered μ I θ (n + 1)) = mass μ (covered μ I θ n) +
      mass μ (I (choosePivot μ I θ (covered μ I θ n)) \ covered μ I θ n) :=
  mass_union μ _ _

theorem mass_lt_of_bad (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ)
    (hμ : ∀ y, 0 ≤ μ y) (n : ℕ) :
    (∃ x, θ < mass μ (I x \ covered μ I θ n)) →
      n = 0 ∨ (n : ℝ) * θ < mass μ (covered μ I θ n) := by
  induction n with
  | zero =>
      intro _
      exact Or.inl rfl
  | succ n ih =>
      intro hbad
      have hprev := bad_of_subset μ I θ hμ (covered_subset_succ μ I θ n) hbad
      have hlower : (n : ℝ) * θ ≤ mass μ (covered μ I θ n) := by
        rcases ih hprev with hzero | hlt
        · subst n
          simp [mass]
        · exact hlt.le
      have hgain := choosePivot_spec μ I θ (covered μ I θ n) hprev
      right
      calc
        ((n + 1 : ℕ) : ℝ) * θ = (n : ℝ) * θ + θ := by
          simp only [Nat.cast_add, Nat.cast_one, add_mul, one_mul]
        _ < mass μ (covered μ I θ n) +
            mass μ (I (choosePivot μ I θ (covered μ I θ n)) \ covered μ I θ n) :=
          add_lt_add_of_le_of_lt hlower hgain
        _ = mass μ (covered μ I θ (n + 1)) := (mass_covered_succ μ I θ n).symm

theorem residual_le [Fintype Y] (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ)
    (hμ : ∀ y, 0 ≤ μ y) (hmass : ∑ y, μ y ≤ 1) (s : ℕ)
    (hs : 1 ≤ (s : ℝ) * θ) (x : X) :
    mass μ (I x \ covered μ I θ s) ≤ θ := by
  have hs0 : s ≠ 0 := by
    intro hz
    subst s
    simp only [Nat.cast_zero, zero_mul] at hs
    exact (not_le_of_gt (zero_lt_one : (0 : ℝ) < 1)) hs
  apply le_of_not_gt
  intro hbad
  have hlower := mass_lt_of_bad μ I θ hμ s ⟨x, hbad⟩
  have hstrict := hlower.resolve_left hs0
  have hupper : mass μ (covered μ I θ s) ≤ 1 :=
    (mass_mono μ hμ (Finset.subset_univ _)).trans hmass
  exact (not_lt_of_ge hs) (hstrict.trans_le hupper)

theorem mem_covered_iff (μ : Y → ℝ) (I : X → Finset Y) (θ : ℝ) (n : ℕ) (y : Y) :
    y ∈ covered μ I θ n ↔
      ∃ k < n, y ∈ I (choosePivot μ I θ (covered μ I θ k)) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [covered_succ, Finset.mem_union, ih]
      constructor
      · rintro (⟨k, hk, hy⟩ | hy)
        · exact ⟨k, Nat.lt_succ_of_lt hk, hy⟩
        · exact ⟨n, Nat.lt_succ_self n, hy⟩
      · rintro ⟨k, hk, hy⟩
        rcases Nat.lt_or_eq_of_le (Nat.le_of_lt_succ hk) with hlt | rfl
        · exact Or.inl ⟨k, hlt, hy⟩
        · exact Or.inr hy

end GreedyPivots

theorem exists_greedy_pivots {X : Type uX} {Y : Type uY}
    [Fintype X] [Nonempty X] [Fintype Y]
    (μ : Y → ℝ) (I : X → Finset Y) (hμ : ∀ y, 0 ≤ μ y)
    (hmass : ∑ y, μ y ≤ 1) (θ : ℝ) (s : ℕ) (hs : 1 ≤ (s : ℝ) * θ) :
    ∃ centers : Fin s → X, ∃ assigned : Y → Option (Fin s),
      (∀ y t, assigned y = some t → y ∈ I (centers t)) ∧
      (∀ y, (∃ t, y ∈ I (centers t)) ↔ assigned y ≠ none) ∧
      (∀ x, ∑ y ∈ (I x).filter (fun y => assigned y = none), μ y ≤ θ) := by
  let centers : Fin s → X := fun t =>
    GreedyPivots.choosePivot μ I θ (GreedyPivots.covered μ I θ t.val)
  let assigned : Y → Option (Fin s) := fun y =>
    if h : ∃ t, y ∈ I (centers t) then some h.choose else none
  have hmem : ∀ y t, assigned y = some t → y ∈ I (centers t) := by
    intro y t ht
    by_cases hy : ∃ j, y ∈ I (centers j)
    · have heq : hy.choose = t := by
        apply Option.some.inj
        simpa only [assigned, dif_pos hy] using ht
      exact heq ▸ hy.choose_spec
    · simp only [assigned, dif_neg hy] at ht
      cases ht
  have hsupport : ∀ y, (∃ t, y ∈ I (centers t)) ↔ assigned y ≠ none := by
    intro y
    by_cases hy : ∃ t, y ∈ I (centers t) <;> simp [assigned, hy]
  have hcovered : ∀ y, y ∈ GreedyPivots.covered μ I θ s ↔
      ∃ t, y ∈ I (centers t) := by
    intro y
    rw [GreedyPivots.mem_covered_iff]
    constructor
    · rintro ⟨t, ht, hy⟩
      exact ⟨⟨t, ht⟩, hy⟩
    · rintro ⟨t, hy⟩
      exact ⟨t.val, t.isLt, hy⟩
  have hnone : ∀ y, assigned y = none ↔ y ∉ GreedyPivots.covered μ I θ s := by
    intro y
    constructor
    · intro hn hy
      exact ((hsupport y).mp ((hcovered y).mp hy)) hn
    · intro hy
      by_cases hn : assigned y = none
      · exact hn
      · exact (hy ((hcovered y).mpr ((hsupport y).mpr hn))).elim
  refine ⟨centers, assigned, hmem, hsupport, ?_⟩
  intro x
  have hfilter : (I x).filter (fun y => assigned y = none) =
      I x \ GreedyPivots.covered μ I θ s := by
    ext y
    simp only [Finset.mem_filter, Finset.mem_sdiff, hnone]
  rw [hfilter]
  exact GreedyPivots.residual_le μ I θ hμ hmass s hs x

theorem exists_profile_pivots {X : Type uX} {Y : Type uY}
    [Fintype X] [Nonempty X] [Fintype Y]
    {u k : ℕ} {Label : Fin u → Type uLabel}
    (L : (i : Fin u) → X → Label i) (v : Y → X) (T : Y → Finset (Fin u))
    (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y) (hmass : ∑ y, μ y ≤ 1)
    (hu : 0 < u) (θ : ℝ) (hθ : 0 < θ) (s : ℕ) (hs : 1 ≤ (s : ℝ) * θ)
    (hcomp : ∀ y, ((Finset.univ \ T y).card : ℝ) ≤ θ * (u : ℝ))
    (r : Fin k → ℕ) :
    ∃ i : Fin u, ∃ centers : Fin k → Fin s → X,
      ∃ assigned : Fin k → Y → Option (Fin s),
        (∑ y ∈ Finset.univ.filter (fun y => i ∉ T y), μ y) ≤ θ ∧
        (∀ j y t, assigned j y = some t →
          i ∈ T y ∧ PartitionGraph.near L (T y) (r j) (centers j t) (v y)) ∧
        (∀ j x, (∑ y ∈ Finset.univ.filter (fun y =>
          i ∈ T y ∧ PartitionGraph.near L (T y) (r j) x (v y) ∧
            assigned j y = none), μ y) ≤ θ) := by
  obtain ⟨i, hi⟩ := exists_common_index hu T μ hμ hmass hθ.le hcomp
  let incidence : Fin k → X → Finset Y := fun j x =>
    Finset.univ.filter (fun y => i ∈ T y ∧ PartitionGraph.near L (T y) (r j) x (v y))
  have hgreedy (j : Fin k) :=
    exists_greedy_pivots μ (incidence j) hμ hmass θ s hs
  let centers : Fin k → Fin s → X := fun j => (hgreedy j).choose
  let assigned : Fin k → Y → Option (Fin s) := fun j => (hgreedy j).choose_spec.choose
  refine ⟨i, centers, assigned, hi, ?_, ?_⟩
  · intro j y t hy
    have hyI : y ∈ incidence j (centers j t) :=
      (hgreedy j).choose_spec.choose_spec.1 y t hy
    exact (Finset.mem_filter.mp hyI).2
  · intro j x
    have hres : (∑ y ∈ (incidence j x).filter (fun y => assigned j y = none), μ y) ≤ θ :=
      (hgreedy j).choose_spec.choose_spec.2.2 x
    simpa only [incidence, Finset.filter_filter, and_assoc] using hres

structure FixedLabels {X : Type uX} {u : ℕ} {Label : Fin u → Type uLabel}
    (L : (i : Fin u) → X → Label i) (q : ℕ) where
  encode : Fin u → X → Fin q
  representative : Fin u → Fin q → X
  encode_eq_iff : ∀ i x y, encode i x = encode i y ↔ L i x = L i y
  label_representative_encode : ∀ i x,
    L i (representative i (encode i x)) = L i x

namespace FixedLabels

def rangeEmbedding {X : Type uX} {Y : Type uY} [Finite X] (f : X → Y) (q : ℕ)
    (hcard : Nat.card (Set.range f) ≤ q) : Set.range f ↪ Fin q :=
  (Finite.equivFin (Set.range f)).toEmbedding.trans (Fin.castLEEmb hcard)

def ofCardBound {X : Type uX} {u q : ℕ} {Label : Fin u → Type uLabel}
    [Finite X] [Nonempty X] (L : (i : Fin u) → X → Label i)
    (hcard : ∀ i, Nat.card (Set.range (L i)) ≤ q) : FixedLabels L q := by
  let enc : Fin u → X → Fin q := fun i x =>
    rangeEmbedding (L i) q (hcard i) ⟨L i x, ⟨x, rfl⟩⟩
  have heq : ∀ i x y, enc i x = enc i y ↔ L i x = L i y := by
    intro i x y
    constructor
    · intro h
      exact congrArg Subtype.val ((rangeEmbedding (L i) q (hcard i)).injective h)
    · intro h
      exact congrArg (rangeEmbedding (L i) q (hcard i)) (Subtype.ext h)
  let rep : Fin u → Fin q → X := fun i => Function.invFun (enc i)
  have hrep : ∀ i x, L i (rep i (enc i x)) = L i x := by
    intro i x
    apply (heq i _ _).mp
    exact Function.invFun_eq ⟨x, rfl⟩
  exact ⟨enc, rep, heq, hrep⟩

theorem normalization_graph {X : Type uX} {u q : ℕ}
    {Label : Fin u → Type uLabel} {L : (i : Fin u) → X → Label i}
    (E : FixedLabels L q) (T : Finset (Fin u)) :
    PartitionGraph.graph (fun i => E.encode i) T = PartitionGraph.graph L T := by
  ext x y
  simp only [PartitionGraph.graph, E.encode_eq_iff]

theorem normalization_distance {X : Type uX} {u q : ℕ}
    {Label : Fin u → Type uLabel} {L : (i : Fin u) → X → Label i}
    (E : FixedLabels L q) (T : Finset (Fin u)) (x y : X) :
    PartitionGraph.distance (fun i => E.encode i) T x y =
      PartitionGraph.distance L T x y := by
  unfold PartitionGraph.distance
  rw [E.normalization_graph]

end FixedLabels

theorem fin_labels_card_bound {X : Type uX} {u q : ℕ}
    (L : Fin u → X → Fin q) : ∀ i, Nat.card (Set.range (L i)) ≤ q := by
  intro i
  simpa only [Nat.card_eq_fintype_card, Fintype.card_fin] using
    (Fintype.card_le_of_injective
      (fun z : Set.range (L i) => (z : Fin q)) Subtype.val_injective)

section GroupedWeights

variable {Y : Type uY} {K : Type uK} {T : Type uι} [Fintype Y]

def groupedWeight (assignment : Y → Option K) (tag : Y → T) (μ : Y → ℝ)
    (t : K) (a : T) : ℝ :=
  ∑ y, if assignment y = some t ∧ tag y = a then μ y else 0

theorem groupedWeight_nonneg (assignment : Y → Option K) (tag : Y → T)
    (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y) (t : K) (a : T) :
    0 ≤ groupedWeight assignment tag μ t a := by
  unfold groupedWeight
  apply Finset.sum_nonneg
  intro y _
  split_ifs
  · exact hμ y
  · exact le_rfl

theorem groupedWeight_le_one (assignment : Y → Option K) (tag : Y → T)
    (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y) (hmass : ∑ y, μ y ≤ 1)
    (t : K) (a : T) : groupedWeight assignment tag μ t a ≤ 1 := by
  apply le_trans _ hmass
  unfold groupedWeight
  apply Finset.sum_le_sum
  intro y _
  split_ifs
  · exact le_rfl
  · exact hμ y

theorem sum_groupedWeight_mul [Fintype K] [Fintype T]
    (assignment : Y → Option K) (tag : Y → T)
    (μ : Y → ℝ) (B : K → T → ℝ) :
    (∑ t, ∑ a, groupedWeight assignment tag μ t a * B t a) =
      ∑ y, μ y * (match assignment y with
        | none => 0
        | some t => B t (tag y)) := by
  simp_rw [groupedWeight, Finset.sum_mul]
  rw [Finset.sum_comm_cycle]
  apply Finset.sum_congr rfl
  intro y _
  cases assignment y with
  | none => simp
  | some slot => simp [ite_and, ite_mul]

end GroupedWeights

def weightCodeSize (δ : ℝ) : ℕ := Nat.floor (1 / δ) + 1

theorem weightCodeSize_pos (δ : ℝ) : 0 < weightCodeSize δ := Nat.succ_pos _

def roundWeight (δ w : ℝ) : ℝ := δ * (Nat.floor (w / δ) : ℝ)

def decodeWeight (δ : ℝ) (c : Fin (weightCodeSize δ)) : ℝ := δ * (c.val : ℝ)

def weightCode (δ w : ℝ) (hδ : 0 < δ) (_hw0 : 0 ≤ w) (hw1 : w ≤ 1) :
    Fin (weightCodeSize δ) :=
  ⟨Nat.floor (w / δ), Nat.lt_succ_of_le
    (Nat.floor_mono ((div_le_div_iff_of_pos_right hδ).2 hw1))⟩

@[simp] theorem decodeWeight_weightCode (δ w : ℝ) (hδ : 0 < δ) (hw0 : 0 ≤ w)
    (hw1 : w ≤ 1) :
    decodeWeight δ (weightCode δ w hδ hw0 hw1) = roundWeight δ w := rfl

theorem roundWeight_le {δ w : ℝ} (hδ : 0 < δ) (hw0 : 0 ≤ w) :
    roundWeight δ w ≤ w := by
  have hf := Nat.floor_le (div_nonneg hw0 hδ.le)
  have hm := (le_div_iff₀ hδ).mp hf
  simpa only [roundWeight, mul_comm] using hm

theorem roundWeight_sub_lt {δ w : ℝ} (hδ : 0 < δ) :
    w - roundWeight δ w < δ := by
  have hf := Nat.lt_floor_add_one (w / δ)
  have hm := (div_lt_iff₀ hδ).mp hf
  dsimp [roundWeight]
  nlinarith

theorem roundWeight_mul_error {δ w b : ℝ} (hδ : 0 < δ) (hw0 : 0 ≤ w)
    (hb0 : 0 ≤ b) (hb1 : b ≤ 1) :
    0 ≤ w * b - roundWeight δ w * b ∧
      w * b - roundWeight δ w * b ≤ δ := by
  rw [← sub_mul]
  have herr : 0 ≤ w - roundWeight δ w ∧ w - roundWeight δ w < δ :=
    ⟨sub_nonneg.mpr (roundWeight_le hδ hw0), roundWeight_sub_lt hδ⟩
  exact ⟨mul_nonneg herr.1 hb0,
    (mul_le_of_le_one_right herr.1 hb1).trans herr.2.le⟩

theorem roundWeight_sum_error {I : Type uI} [Fintype I]
    (δ : ℝ) (hδ : 0 < δ) (w b : I → ℝ)
    (hw0 : ∀ i, 0 ≤ w i) (hb0 : ∀ i, 0 ≤ b i) (hb1 : ∀ i, b i ≤ 1) :
    0 ≤ (∑ i, w i * b i) - ∑ i, roundWeight δ (w i) * b i ∧
      (∑ i, w i * b i) - ∑ i, roundWeight δ (w i) * b i ≤
        (Fintype.card I : ℝ) * δ := by
  constructor
  · rw [← Finset.sum_sub_distrib]
    exact Finset.sum_nonneg fun i _ => (roundWeight_mul_error hδ (hw0 i) (hb0 i) (hb1 i)).1
  · calc
      (∑ i, w i * b i) - ∑ i, roundWeight δ (w i) * b i =
          ∑ i, (w i * b i - roundWeight δ (w i) * b i) :=
        (Finset.sum_sub_distrib (s := Finset.univ)
          (fun i : I => w i * b i)
          (fun i : I => roundWeight δ (w i) * b i)).symm
      _ ≤ ∑ _i : I, δ := Finset.sum_le_sum fun i _ =>
        (roundWeight_mul_error hδ (hw0 i) (hb0 i) (hb1 i)).2
      _ = (Fintype.card I : ℝ) * δ := by simp

def roundingStep (θ : ℝ) (s u : ℕ) : ℝ := θ / ((s : ℝ) * 2 ^ u)

theorem roundingStep_pos {θ : ℝ} {s u : ℕ} (hθ : 0 < θ) (hs : 0 < s) :
    0 < roundingStep θ s u :=
  div_pos hθ (mul_pos (Nat.cast_pos.mpr hs) (pow_pos (by norm_num) _))

theorem card_mul_roundingStep (θ : ℝ) {s u : ℕ} (hs : 0 < s) :
    (Fintype.card (Fin s × Finset (Fin u)) : ℝ) * roundingStep θ s u = θ := by
  have hc : (Fintype.card (Fin s × Finset (Fin u)) : ℝ) = (s : ℝ) * 2 ^ u := by simp
  rw [hc, roundingStep]
  exact mul_div_cancel₀ θ
    (ne_of_gt (mul_pos (Nat.cast_pos.mpr hs) (pow_pos (by norm_num) _)))

theorem weightCodeSize_roundingStep (θ : ℝ) (s u : ℕ) :
    weightCodeSize (roundingStep θ s u) =
      Nat.floor (((s : ℝ) * 2 ^ u) / θ) + 1 := by
  simp only [weightCodeSize, roundingStep, one_div_div]

theorem roundWeight_level_error {θ : ℝ} {s u : ℕ} (hθ : 0 < θ) (hs : 0 < s)
    (w b : Fin s → Finset (Fin u) → ℝ)
    (hw0 : ∀ t T, 0 ≤ w t T) (hb0 : ∀ t T, 0 ≤ b t T)
    (hb1 : ∀ t T, b t T ≤ 1) :
    0 ≤ (∑ t, ∑ T, w t T * b t T) -
        ∑ t, ∑ T, roundWeight (roundingStep θ s u) (w t T) * b t T ∧
      (∑ t, ∑ T, w t T * b t T) -
        ∑ t, ∑ T, roundWeight (roundingStep θ s u) (w t T) * b t T ≤ θ := by
  have herr := roundWeight_sum_error (roundingStep θ s u) (roundingStep_pos hθ hs)
    (fun i : Fin s × Finset (Fin u) => w i.1 i.2)
    (fun i : Fin s × Finset (Fin u) => b i.1 i.2)
    (fun i => hw0 i.1 i.2) (fun i => hb0 i.1 i.2) (fun i => hb1 i.1 i.2)
  rw [card_mul_roundingStep θ hs] at herr
  simpa only [Fintype.sum_prod_type] using herr

abbrev CompressionCode (u q k s N : ℕ) :=
  Fin u × (Fin k → Fin s → Fin q) ×
    (Fin k → Fin s → Finset (Fin u) → Fin N)

theorem card_compressionCode (u q k s N : ℕ) :
    Fintype.card (CompressionCode u q k s N) =
      u * q ^ (k * s) * N ^ (k * s * 2 ^ u) := by
  simp only [CompressionCode, Fintype.card_prod, Fintype.card_fun,
    Fintype.card_finset, Fintype.card_fin]
  simp only [← pow_mul, Nat.mul_assoc, Nat.mul_comm]

namespace CompressionLevels

variable {X : Type uX} {Y : Type uY} {K : Type uK}
variable {ι : Type uι} {Label : ι → Type uLabel}

def ballIndicator (L : (i : ι) → X → Label i) (T : Finset ι) (j : ℕ)
    (x v : X) : ℝ := if PartitionGraph.near L T j x v then 1 else 0

theorem ballIndicator_nonneg (L : (i : ι) → X → Label i) (T : Finset ι)
    (j : ℕ) (x v : X) : 0 ≤ ballIndicator L T j x v := by
  unfold ballIndicator
  split_ifs <;> simp

theorem ballIndicator_le_one (L : (i : ι) → X → Label i) (T : Finset ι)
    (j : ℕ) (x v : X) : ballIndicator L T j x v ≤ 1 := by
  unfold ballIndicator
  split_ifs <;> simp

def assignedIndicator (L : (i : ι) → X → Label i) (T : Y → Finset ι)
    (rep : K → X) (assignment : Y → Option K) (j : ℕ) (x : X) (y : Y) : ℝ :=
  match assignment y with
  | none => 0
  | some t => ballIndicator L (T y) (2 * j + 1) x (rep t)

theorem assignedIndicator_nonneg (L : (i : ι) → X → Label i) (T : Y → Finset ι)
    (rep : K → X) (assignment : Y → Option K) (j : ℕ) (x : X) (y : Y) :
    0 ≤ assignedIndicator L T rep assignment j x y := by
  unfold assignedIndicator
  cases assignment y with
  | none => exact le_rfl
  | some t => exact ballIndicator_nonneg _ _ _ _ _

theorem ballIndicator_le_assignedIndicator_add
    (L : (i : ι) → X → Label i) (v : Y → X) (T : Y → Finset ι)
    (i : ι) (j : ℕ) (centers rep : K → X) (assignment : Y → Option K)
    (hassign : ∀ y t, assignment y = some t →
      i ∈ T y ∧ PartitionGraph.near L (T y) j (centers t) (v y))
    (hrep : ∀ t, L i (rep t) = L i (centers t)) (x : X) (y : Y) :
    ballIndicator L (T y) j x (v y) ≤
      assignedIndicator L T rep assignment j x y +
        (if i ∉ T y then 1 else 0) +
        (if i ∈ T y ∧ PartitionGraph.near L (T y) j x (v y) ∧
          assignment y = none then 1 else 0) := by
  have ha := assignedIndicator_nonneg L T rep assignment j x y
  by_cases hx : PartitionGraph.near L (T y) j x (v y)
  · by_cases hi : i ∈ T y
    · cases hass : assignment y with
      | none => simp [ballIndicator, assignedIndicator, hx, hi, hass]
      | some t =>
          have ht := hassign y t hass
          have hf := PartitionGraph.pivot_forward L (T y) ht.1 (hrep t)
            (PartitionGraph.near_symm L (T y) ht.2) hx
          simp [ballIndicator, assignedIndicator, hx, hi, hass, hf]
    · simp only [ballIndicator, if_pos hx, hi, not_false_eq_true, ite_true,
        false_and, ite_false]
      linarith
  · simp only [ballIndicator, hx, and_false, false_and, ite_false]
    split_ifs <;> linarith

theorem assignedIndicator_le_ballIndicator
    (L : (i : ι) → X → Label i) (v : Y → X) (T : Y → Finset ι)
    (i : ι) (j : ℕ) (centers rep : K → X) (assignment : Y → Option K)
    (hassign : ∀ y t, assignment y = some t →
      i ∈ T y ∧ PartitionGraph.near L (T y) j (centers t) (v y))
    (hrep : ∀ t, L i (rep t) = L i (centers t)) (x : X) (y : Y) :
    assignedIndicator L T rep assignment j x y ≤
      ballIndicator L (T y) (3 * j + 2) x (v y) := by
  cases hass : assignment y with
  | none =>
      simpa [assignedIndicator, hass] using
        ballIndicator_nonneg L (T y) (3 * j + 2) x (v y)
  | some t =>
      by_cases hx : PartitionGraph.near L (T y) (2 * j + 1) x (rep t)
      · have ht := hassign y t hass
        have hb := PartitionGraph.pivot_backward L (T y) ht.1 (hrep t)
          (PartitionGraph.near_symm L (T y) ht.2) hx
        simp [assignedIndicator, hass, ballIndicator, hx, hb]
      · simpa [assignedIndicator, hass, ballIndicator, hx] using
          ballIndicator_nonneg L (T y) (3 * j + 2) x (v y)

variable [Fintype Y]

def levelValue (L : (i : ι) → X → Label i) (v : Y → X) (T : Y → Finset ι)
    (μ : Y → ℝ) (j : ℕ) (x : X) : ℝ :=
  ∑ y, μ y * ballIndicator L (T y) j x (v y)

def assignedValue (L : (i : ι) → X → Label i) (T : Y → Finset ι)
    (rep : K → X) (assignment : Y → Option K) (μ : Y → ℝ) (j : ℕ) (x : X) : ℝ :=
  ∑ y, μ y * assignedIndicator L T rep assignment j x y

theorem levelValue_sub_two_mul_le_assignedValue
    (L : (i : ι) → X → Label i) (v : Y → X) (T : Y → Finset ι)
    (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y) (i : ι) (j : ℕ)
    (centers rep : K → X) (assignment : Y → Option K)
    (hassign : ∀ y t, assignment y = some t →
      i ∈ T y ∧ PartitionGraph.near L (T y) j (centers t) (v y))
    (hrep : ∀ t, L i (rep t) = L i (centers t)) {θ : ℝ}
    (homit : (∑ y ∈ Finset.univ.filter (fun y => i ∉ T y), μ y) ≤ θ)
    (hrem : ∀ x, (∑ y ∈ Finset.univ.filter (fun y =>
      i ∈ T y ∧ PartitionGraph.near L (T y) j x (v y) ∧
        assignment y = none), μ y) ≤ θ) (x : X) :
    levelValue L v T μ j x - 2 * θ ≤ assignedValue L T rep assignment μ j x := by
  have hsum : levelValue L v T μ j x ≤ assignedValue L T rep assignment μ j x +
      (∑ y ∈ Finset.univ.filter (fun y => i ∉ T y), μ y) +
      (∑ y ∈ Finset.univ.filter (fun y =>
        i ∈ T y ∧ PartitionGraph.near L (T y) j x (v y) ∧
          assignment y = none), μ y) := by
    calc
      _ ≤ ∑ y, μ y * (assignedIndicator L T rep assignment j x y +
          (if i ∉ T y then 1 else 0) +
          (if i ∈ T y ∧ PartitionGraph.near L (T y) j x (v y) ∧
            assignment y = none then 1 else 0)) := by
        exact Finset.sum_le_sum fun y _ => mul_le_mul_of_nonneg_left
          (ballIndicator_le_assignedIndicator_add L v T i j centers rep assignment
            hassign hrep x y) (hμ y)
      _ = _ := by
        simp [assignedValue, mul_add, Finset.sum_add_distrib, Finset.sum_filter, mul_ite]
  linarith [hrem x]

theorem assignedValue_le_levelValue
    (L : (i : ι) → X → Label i) (v : Y → X) (T : Y → Finset ι)
    (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y) (i : ι) (j : ℕ)
    (centers rep : K → X) (assignment : Y → Option K)
    (hassign : ∀ y t, assignment y = some t →
      i ∈ T y ∧ PartitionGraph.near L (T y) j (centers t) (v y))
    (hrep : ∀ t, L i (rep t) = L i (centers t)) (x : X) :
    assignedValue L T rep assignment μ j x ≤ levelValue L v T μ (3 * j + 2) x := by
  exact Finset.sum_le_sum fun y _ => mul_le_mul_of_nonneg_left
    (assignedIndicator_le_ballIndicator L v T i j centers rep assignment
      hassign hrep x y) (hμ y)

end CompressionLevels

def radialIndicator (d : ℕ∞) (r : ℕ) : ℝ := if d ≤ (r : ℕ∞) then 1 else 0

def finiteProfile {k : ℕ} (r : Fin k → ℕ) (γ : Fin k → ℝ) (d : ℕ∞) : ℝ :=
  ∑ j, γ j * radialIndicator d (r j)

def DilationBound {k : ℕ} (r : Fin k → ℕ) (γ : Fin k → ℝ) (θ : ℝ) : Prop :=
  ∀ d : ℕ∞,
    (∑ j, γ j * (radialIndicator d (3 * r j + 2) - radialIndicator d (r j))) ≤ θ

namespace ProfileMixtures

open CompressionLevels

variable {X : Type uX} {Y : Type uY} {ι : Type uι}
variable {Label : ι → Type uLabel} [Fintype Y] {k : ℕ}

def profileMixture (L : (i : ι) → X → Label i) (v : Y → X) (T : Y → Finset ι)
    (r : Fin k → ℕ) (γ : Fin k → ℝ) (μ : Y → ℝ) (x : X) : ℝ :=
  ∑ y, μ y * finiteProfile r γ (PartitionGraph.distance L (T y) x (v y))

theorem ballIndicator_eq_distance (L : (i : ι) → X → Label i)
    (T : Finset ι) (j : ℕ) (x v : X) :
    ballIndicator L T j x v = radialIndicator (PartitionGraph.distance L T x v) j := by
  by_cases hd : PartitionGraph.distance L T x v ≤ (j : ℕ∞)
  · simp [ballIndicator, PartitionGraph.near, radialIndicator, hd]
  · simp [ballIndicator, PartitionGraph.near, radialIndicator, hd]

theorem sum_weighted_levels {J : Type uI} [Fintype J]
    (α : J → ℝ) (μ : Y → ℝ) (b : J → Y → ℝ) :
    (∑ j, α j * ∑ y, μ y * b j y) =
      ∑ y, μ y * ∑ j, α j * b j y := by
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro y _
  apply Finset.sum_congr rfl
  intro j _
  ring

theorem profileMixture_eq_sum (L : (i : ι) → X → Label i) (v : Y → X)
    (T : Y → Finset ι) (r : Fin k → ℕ) (γ : Fin k → ℝ) (μ : Y → ℝ) (x : X) :
    profileMixture L v T r γ μ x = ∑ j, γ j * levelValue L v T μ (r j) x := by
  unfold profileMixture levelValue finiteProfile
  rw [sum_weighted_levels]
  simp only [ballIndicator_eq_distance]

theorem dilated_level_sum_le (L : (i : ι) → X → Label i) (v : Y → X)
    (T : Y → Finset ι) (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y)
    (hmass : ∑ y, μ y ≤ 1) (r : Fin k → ℕ) (γ : Fin k → ℝ) {θ : ℝ}
    (hθ0 : 0 ≤ θ) (hprofile : DilationBound r γ θ) (x : X) :
    (∑ j, γ j * levelValue L v T μ (3 * r j + 2) x) ≤
      profileMixture L v T r γ μ x + θ := by
  unfold levelValue
  rw [sum_weighted_levels]
  calc
    (∑ y, μ y * ∑ j, γ j * ballIndicator L (T y) (3 * r j + 2) x (v y)) ≤
        ∑ y, μ y * (finiteProfile r γ (PartitionGraph.distance L (T y) x (v y)) + θ) := by
      apply Finset.sum_le_sum
      intro y _
      apply mul_le_mul_of_nonneg_left _ (hμ y)
      have hd := hprofile (PartitionGraph.distance L (T y) x (v y))
      simp only [mul_sub, Finset.sum_sub_distrib] at hd
      simp only [ballIndicator_eq_distance]
      unfold finiteProfile
      linarith
    _ = profileMixture L v T r γ μ x + (∑ y, μ y) * θ := by
      simp only [profileMixture, mul_add, Finset.sum_add_distrib, Finset.sum_mul]
    _ ≤ profileMixture L v T r γ μ x + θ := by
      apply add_le_add (le_refl _)
      simpa only [one_mul] using mul_le_mul_of_nonneg_right hmass hθ0

theorem rounded_level_sum_bounds (L : (i : ι) → X → Label i) (v : Y → X)
    (T : Y → Finset ι) (μ : Y → ℝ) (hμ : ∀ y, 0 ≤ μ y)
    (hmass : ∑ y, μ y ≤ 1) (r : Fin k → ℕ) (γ : Fin k → ℝ)
    (hγ : ∀ j, 0 ≤ γ j) (hγsum : ∑ j, γ j = 1) {θ : ℝ}
    (hθ0 : 0 ≤ θ) (hprofile : DilationBound r γ θ)
    (x : X) (assigned rounded : Fin k → ℝ)
    (hlower : ∀ j, levelValue L v T μ (r j) x - 2 * θ ≤ assigned j)
    (hupper : ∀ j, assigned j ≤ levelValue L v T μ (3 * r j + 2) x)
    (hround : ∀ j, 0 ≤ assigned j - rounded j ∧ assigned j - rounded j ≤ θ) :
    profileMixture L v T r γ μ x - 3 * θ ≤ (∑ j, γ j * rounded j) ∧
      (∑ j, γ j * rounded j) ≤ profileMixture L v T r γ μ x + θ := by
  constructor
  · calc
      profileMixture L v T r γ μ x - 3 * θ =
          ∑ j, γ j * (levelValue L v T μ (r j) x - 3 * θ) := by
        rw [profileMixture_eq_sum L v T r γ μ x]
        simp only [mul_sub, Finset.sum_sub_distrib, ← Finset.sum_mul, hγsum, one_mul]
      _ ≤ ∑ j, γ j * rounded j := by
        apply Finset.sum_le_sum
        intro j _
        apply mul_le_mul_of_nonneg_left _ (hγ j)
        have hlj := hlower j
        have hrj := (hround j).2
        linarith
  · calc
      (∑ j, γ j * rounded j) ≤
          ∑ j, γ j * levelValue L v T μ (3 * r j + 2) x := by
        apply Finset.sum_le_sum
        intro j _
        apply mul_le_mul_of_nonneg_left _ (hγ j)
        have huj := hupper j
        have hrj := (hround j).1
        linarith
      _ ≤ profileMixture L v T r γ μ x + θ :=
        dilated_level_sum_le L v T μ hμ hmass r γ hθ0 hprofile x

end ProfileMixtures

section Decoder

variable {X : Type uX} {u q k : ℕ} {Label : Fin u → Type uLabel}

def compressionDecode (L : (i : Fin u) → X → Label i) (E : FixedLabels L q)
    (r : Fin k → ℕ) (γ : Fin k → ℝ) (s : ℕ) (θ : ℝ)
    (code : CompressionCode u q k s (weightCodeSize (roundingStep θ s u))) : X → ℝ :=
  fun x => ∑ j, γ j *
    ∑ t : Fin s, ∑ T : Finset (Fin u),
      decodeWeight (roundingStep θ s u) (code.2.2 j t T) *
        CompressionLevels.ballIndicator L T (2 * r j + 1) x
          (E.representative code.1 (code.2.1 j t))

/-- This is fixed before any coefficient vector is supplied. -/
def compressionList (L : (i : Fin u) → X → Label i) (E : FixedLabels L q)
    (r : Fin k → ℕ) (γ : Fin k → ℝ) (s : ℕ) (θ : ℝ) : Finset (X → ℝ) :=
  Finset.univ.image (compressionDecode L E r γ s θ)

theorem compressionDecode_mem_compressionList
    (L : (i : Fin u) → X → Label i) (E : FixedLabels L q)
    (r : Fin k → ℕ) (γ : Fin k → ℝ) (s : ℕ) (θ : ℝ)
    (code : CompressionCode u q k s (weightCodeSize (roundingStep θ s u))) :
    compressionDecode L E r γ s θ code ∈ compressionList L E r γ s θ :=
  Finset.mem_image_of_mem _ (Finset.mem_univ code)

theorem compressionList_nonempty
    (L : (i : Fin u) → X → Label i) (E : FixedLabels L q)
    (r : Fin k → ℕ) (γ : Fin k → ℝ) (s : ℕ) (θ : ℝ)
    (hu : 0 < u) (hq : 0 < q) : (compressionList L E r γ s θ).Nonempty := by
  let code : CompressionCode u q k s (weightCodeSize (roundingStep θ s u)) :=
    ⟨⟨0, hu⟩, (fun _ _ => ⟨0, hq⟩),
      fun _ _ _ => ⟨0, weightCodeSize_pos _⟩⟩
  exact ⟨compressionDecode L E r γ s θ code,
    compressionDecode_mem_compressionList L E r γ s θ code⟩

theorem compressionList_card_le
    (L : (i : Fin u) → X → Label i) (E : FixedLabels L q)
    (r : Fin k → ℕ) (γ : Fin k → ℝ) (s : ℕ) (θ : ℝ) :
    (compressionList L E r γ s θ).card ≤
      u * q ^ (k * s) *
        (Nat.floor (((s : ℝ) * 2 ^ u) / θ) + 1) ^ (k * s * 2 ^ u) := by
  calc
    (compressionList L E r γ s θ).card ≤
        Fintype.card (CompressionCode u q k s (weightCodeSize (roundingStep θ s u))) := by
      simpa only [compressionList, Finset.card_univ] using
        (Finset.card_image_le
          (s := (Finset.univ :
            Finset (CompressionCode u q k s (weightCodeSize (roundingStep θ s u)))))
          (f := compressionDecode L E r γ s θ))
    _ = _ := by
      rw [card_compressionCode, weightCodeSize_roundingStep]

end Decoder

section Compression

open CompressionLevels ProfileMixtures

variable {X : Type uX} {Y : Type uY}
variable [Fintype X] [Nonempty X] [Fintype Y]
variable {u q k s : ℕ} {Label : Fin u → Type uLabel}

set_option maxHeartbeats 2000000 in
theorem exists_compressionCode
    (L : (i : Fin u) → X → Label i) (E : FixedLabels L q)
    (v : Y → X) (T : Y → Finset (Fin u)) (μ : Y → ℝ)
    (hμ : ∀ y, 0 ≤ μ y) (hmass : ∑ y, μ y ≤ 1)
    (hu : 0 < u) (hs : 0 < s) (θ : ℝ) (hθ : 0 < θ)
    (hsθ : 1 ≤ (s : ℝ) * θ)
    (r : Fin k → ℕ) (γ : Fin k → ℝ)
    (hγ : ∀ j, 0 ≤ γ j) (hγsum : ∑ j, γ j = 1)
    (hprofile : DilationBound r γ θ)
    (hcomp : ∀ y, ((Finset.univ \ T y).card : ℝ) ≤ θ * (u : ℝ)) :
    ∃ code : CompressionCode u q k s (weightCodeSize (roundingStep θ s u)),
      ∀ x, profileMixture L v T r γ μ x - 3 * θ ≤
          compressionDecode L E r γ s θ code x ∧
        compressionDecode L E r γ s θ code x ≤ profileMixture L v T r γ μ x + θ := by
  obtain ⟨i, centers, assignment, homit, hassign, hrem⟩ :=
    exists_profile_pivots L v T μ hμ hmass hu θ hθ s hsθ hcomp r
  let rep : Fin k → Fin s → X := fun j t =>
    E.representative i (E.encode i (centers j t))
  have hrep (j : Fin k) (t : Fin s) :
      L i (rep j t) = L i (centers j t) :=
    E.label_representative_encode i (centers j t)
  let w : Fin k → Fin s → Finset (Fin u) → ℝ := fun j =>
    groupedWeight (assignment j) T μ
  have hw0 (j : Fin k) (t : Fin s) (a : Finset (Fin u)) : 0 ≤ w j t a :=
    groupedWeight_nonneg (assignment j) T μ hμ t a
  have hw1 (j : Fin k) (t : Fin s) (a : Finset (Fin u)) : w j t a ≤ 1 :=
    groupedWeight_le_one (assignment j) T μ hμ hmass t a
  let δ := roundingStep θ s u
  have hδ : 0 < δ := roundingStep_pos hθ hs
  let code : CompressionCode u q k s (weightCodeSize δ) :=
    ⟨i, (fun j t => E.encode i (centers j t)),
      fun j t a => weightCode δ (w j t a) hδ (hw0 j t a) (hw1 j t a)⟩
  refine ⟨code, ?_⟩
  intro x
  let A : Fin k → ℝ := fun j => assignedValue L T (rep j) (assignment j) μ (r j) x
  let R : Fin k → ℝ := fun j =>
    ∑ t, ∑ a, roundWeight δ (w j t a) * ballIndicator L a (2 * r j + 1) x (rep j t)
  have hgroup (j : Fin k) :
      (∑ t, ∑ a, w j t a * ballIndicator L a (2 * r j + 1) x (rep j t)) = A j := by
    exact sum_groupedWeight_mul (assignment j) T μ
      (fun t a => ballIndicator L a (2 * r j + 1) x (rep j t))
  have hlower (j : Fin k) : levelValue L v T μ (r j) x - 2 * θ ≤ A j := by
    refine levelValue_sub_two_mul_le_assignedValue L v T μ hμ i (r j)
      (centers j) (rep j) (assignment j) (hassign j) (hrep j) (θ := θ) ?_ ?_ x
    · refine le_trans (le_of_eq ?_) homit
      apply Finset.sum_congr
      · ext y
        simp only [Finset.mem_filter]
      · intro y _
        rfl
    · intro z
      refine le_trans (le_of_eq ?_) (hrem j z)
      apply Finset.sum_congr
      · ext y
        simp only [Finset.mem_filter]
      · intro y _
        rfl
  have hupper (j : Fin k) : A j ≤ levelValue L v T μ (3 * r j + 2) x := by
    exact assignedValue_le_levelValue L v T μ hμ i (r j)
      (centers j) (rep j) (assignment j) (hassign j) (hrep j) x
  have hround (j : Fin k) : 0 ≤ A j - R j ∧ A j - R j ≤ θ := by
    have he := roundWeight_level_error hθ hs (w j)
      (fun t a => ballIndicator L a (2 * r j + 1) x (rep j t)) (hw0 j)
      (fun t a => ballIndicator_nonneg L a (2 * r j + 1) x (rep j t))
      (fun t a => ballIndicator_le_one L a (2 * r j + 1) x (rep j t))
    rw [hgroup] at he
    exact he
  have hdecode : compressionDecode L E r γ s θ code x = ∑ j, γ j * R j := by
    rfl
  rw [hdecode]
  exact rounded_level_sum_bounds L v T μ hμ hmass r γ hγ hγsum hθ.le hprofile
    x A R hlower hupper hround

end Compression

abbrev Columns (X : Type uX) {u : ℕ} (𝒯 : Finset (Finset (Fin u))) :=
  X × {T : Finset (Fin u) // T ∈ 𝒯}

def column {X : Type uX} {u k : ℕ} {Label : Fin u → Type uLabel}
    (L : (i : Fin u) → X → Label i) (𝒯 : Finset (Finset (Fin u)))
    (r : Fin k → ℕ) (γ : Fin k → ℝ) (y : Columns X 𝒯) (x : X) : ℝ :=
  finiteProfile r γ (PartitionGraph.distance L y.2.val x y.1)

/-- An actual nonempty, coefficient-independent finite family, with the exact
integer code count and the asymmetric pointwise approximation interval. Ambient
label types may be infinite: only their realized labels are counted. -/
theorem general_finite_profile_partition_compression
    {X : Type uX} [Fintype X] [Nonempty X]
    {u q k s : ℕ} {Label : Fin u → Type uLabel}
    (L : (i : Fin u) → X → Label i)
    (hlabels : ∀ i, Nat.card (Set.range (L i)) ≤ q)
    (𝒯 : Finset (Finset (Fin u)))
    (hu : 0 < u) (hq : 0 < q) (_hk : 0 < k) (hs : 0 < s)
    (θ : ℝ) (hθ : 0 < θ) (hsθ : 1 ≤ (s : ℝ) * θ)
    (r : Fin k → ℕ) (γ : Fin k → ℝ)
    (hγ : ∀ j, 0 ≤ γ j) (hγsum : ∑ j, γ j = 1)
    (hprofile : DilationBound r γ θ)
    (hcomp : ∀ T ∈ 𝒯, ((Finset.univ \ T).card : ℝ) ≤ θ * (u : ℝ)) :
    ∃ A : Finset (X → ℝ), A.Nonempty ∧
      A.card ≤ u * q ^ (k * s) *
        (Nat.floor (((s : ℝ) * 2 ^ u) / θ) + 1) ^ (k * s * 2 ^ u) ∧
      ∀ μ : Columns X 𝒯 → ℝ, (∀ y, 0 ≤ μ y) → (∑ y, μ y ≤ 1) →
        ∃ a ∈ A, ∀ x,
          (∑ y, μ y * column L 𝒯 r γ y x) - 3 * θ ≤ a x ∧
            a x ≤ (∑ y, μ y * column L 𝒯 r γ y x) + θ := by
  let E := FixedLabels.ofCardBound L hlabels
  refine ⟨compressionList L E r γ s θ,
    compressionList_nonempty L E r γ s θ hu hq,
    compressionList_card_le L E r γ s θ, ?_⟩
  intro μ hμ hmass
  obtain ⟨code, hc⟩ := exists_compressionCode L E
    (fun y : Columns X 𝒯 => y.1) (fun y => y.2.val) μ hμ hmass
    hu hs θ hθ hsθ r γ hγ hγsum hprofile
    (fun y => hcomp y.2.val y.2.property)
  exact ⟨compressionDecode L E r γ s θ code,
    compressionDecode_mem_compressionList L E r γ s θ code, hc⟩

def differenceList {X : Type uX} (A : Finset (X → ℝ)) : Finset (X → ℝ) :=
  (A.product A).image (fun ab => ab.1 - ab.2)

theorem differenceList_card_le {X : Type uX} (A : Finset (X → ℝ)) :
    (differenceList A).card ≤ A.card ^ 2 := by
  calc
    (differenceList A).card ≤ (A.product A).card := Finset.card_image_le
    _ = A.card ^ 2 := by rw [Finset.product_eq_sprod, Finset.card_product, pow_two]

theorem differenceList_nonempty {X : Type uX} (A : Finset (X → ℝ))
    (hA : A.Nonempty) : (differenceList A).Nonempty := by
  obtain ⟨a, ha⟩ := hA
  exact ⟨a - a, Finset.mem_image.mpr
    ⟨(a, a), Finset.mem_product.mpr ⟨ha, ha⟩, rfl⟩⟩

theorem differenceList_approximation
    {X : Type uX} {Y : Type uY} [Fintype Y]
    (g : Y → X → ℝ) (θ : ℝ) (A : Finset (X → ℝ))
    (hA : ∀ μ : Y → ℝ, (∀ y, 0 ≤ μ y) → (∑ y, μ y ≤ 1) →
      ∃ a ∈ A, ∀ x, (∑ y, μ y * g y x) - 3 * θ ≤ a x ∧
        a x ≤ (∑ y, μ y * g y x) + θ)
    (lam : Y → ℝ) (hlam : ∑ y, |lam y| ≤ 1) :
    ∃ b ∈ differenceList A, ∀ x, |(∑ y, lam y * g y x) - b x| ≤ 4 * θ := by
  let p : Y → ℝ := fun y => max (lam y) 0
  let n : Y → ℝ := fun y => max (-lam y) 0
  have hp0 (y : Y) : 0 ≤ p y := le_max_right _ _
  have hn0 (y : Y) : 0 ≤ n y := le_max_right _ _
  have hp1 : ∑ y, p y ≤ 1 := by
    apply le_trans _ hlam
    exact Finset.sum_le_sum fun y _ =>
      max_le (le_abs_self (lam y)) (abs_nonneg (lam y))
  have hn1 : ∑ y, n y ≤ 1 := by
    apply le_trans _ hlam
    exact Finset.sum_le_sum fun y _ =>
      max_le (neg_le_abs (lam y)) (abs_nonneg (lam y))
  have hparts (y : Y) : p y - n y = lam y := by
    dsimp [p, n]
    by_cases h : 0 ≤ lam y
    · simp [max_eq_left h, max_eq_right (neg_nonpos.mpr h)]
    · have hle : lam y ≤ 0 := le_of_lt (lt_of_not_ge h)
      simp [max_eq_right hle, max_eq_left (neg_nonneg.mpr hle)]
  obtain ⟨a, ha, hpa⟩ := hA p hp0 hp1
  obtain ⟨b, hb, hnb⟩ := hA n hn0 hn1
  refine ⟨a - b, Finset.mem_image.mpr
    ⟨(a, b), Finset.mem_product.mpr ⟨ha, hb⟩, rfl⟩, ?_⟩
  intro x
  have hcomb : (∑ y, lam y * g y x) =
      (∑ y, p y * g y x) - ∑ y, n y * g y x := by
    rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro y _
    rw [← sub_mul, hparts y]
  change |(∑ y, lam y * g y x) - (a x - b x)| ≤ 4 * θ
  rw [hcomb]
  apply abs_le.mpr
  have hpax := hpa x
  have hnbx := hnb x
  constructor <;> linarith

/-- The same coefficient-independent positive list gives an actual nonempty
signed list of at most the square of the exact code bound. -/
theorem general_finite_profile_partition_signed_compression
    {X : Type uX} [Fintype X] [Nonempty X]
    {u q k s : ℕ} {Label : Fin u → Type uLabel}
    (L : (i : Fin u) → X → Label i)
    (hlabels : ∀ i, Nat.card (Set.range (L i)) ≤ q)
    (𝒯 : Finset (Finset (Fin u)))
    (hu : 0 < u) (hq : 0 < q) (hk : 0 < k) (hs : 0 < s)
    (θ : ℝ) (hθ : 0 < θ) (hsθ : 1 ≤ (s : ℝ) * θ)
    (r : Fin k → ℕ) (γ : Fin k → ℝ)
    (hγ : ∀ j, 0 ≤ γ j) (hγsum : ∑ j, γ j = 1)
    (hprofile : DilationBound r γ θ)
    (hcomp : ∀ T ∈ 𝒯, ((Finset.univ \ T).card : ℝ) ≤ θ * (u : ℝ)) :
    ∃ B : Finset (X → ℝ), B.Nonempty ∧
      B.card ≤ (u * q ^ (k * s) *
        (Nat.floor (((s : ℝ) * 2 ^ u) / θ) + 1) ^ (k * s * 2 ^ u)) ^ 2 ∧
      ∀ lam : Columns X 𝒯 → ℝ, (∑ y, |lam y| ≤ 1) →
        ∃ b ∈ B, ∀ x, |(∑ y, lam y * column L 𝒯 r γ y x) - b x| ≤ 6 * θ := by
  obtain ⟨A, hA, hcard, happrox⟩ :=
    general_finite_profile_partition_compression L hlabels 𝒯 hu hq hk hs
      θ hθ hsθ r γ hγ hγsum hprofile hcomp
  refine ⟨differenceList A, differenceList_nonempty A hA, ?_, ?_⟩
  · calc
      (differenceList A).card ≤ A.card ^ 2 := differenceList_card_le A
      _ ≤ _ := by gcongr
  · intro lam hlam
    obtain ⟨b, hb, hbapprox⟩ :=
      differenceList_approximation (column L 𝒯 r γ) θ A happrox lam hlam
    refine ⟨b, hb, ?_⟩
    intro x
    have hx := hbapprox x
    linarith

end

end SparseProfileCompression

namespace SparseProfile

noncomputable section
open scoped BigOperators Classical

def radius (l : ℕ) : ℕ := 3 ^ l - 1

theorem radius_add_one (l : ℕ) : radius l + 1 = 3 ^ l := by
  have hp : 0 < 3 ^ l := pow_pos (by decide) l
  unfold radius
  omega

@[simp] theorem radius_zero : radius 0 = 0 := by norm_num [radius]

theorem radius_succ (l : ℕ) : radius (l + 1) = 3 * radius l + 2 := by
  have h0 := radius_add_one l
  have h1 := radius_add_one (l + 1)
  rw [pow_succ] at h1
  omega

theorem radius_strictMono : StrictMono radius := by
  apply strictMono_nat_of_lt_succ
  intro l
  rw [radius_succ]
  omega

theorem radius_mono : Monotone radius := radius_strictMono.monotone

def indicator (d : ℕ∞) (j : ℕ) : ℝ := if d ≤ (j : ℕ∞) then 1 else 0

def delta (d : ℕ∞) (j : ℕ) : ℝ :=
  indicator d (3 * j + 2) - indicator d j

theorem delta_eq (d : ℕ∞) (j : ℕ) :
    delta d j = if (j : ℕ∞) < d ∧ d ≤ ((3 * j + 2 : ℕ) : ℕ∞) then 1 else 0 := by
  have hle : (j : ℕ∞) ≤ ((3 * j + 2 : ℕ) : ℕ∞) := by
    exact_mod_cast (show j ≤ 3 * j + 2 by omega)
  by_cases hsmall : d ≤ (j : ℕ∞)
  · have hlarge := hsmall.trans hle
    unfold delta indicator
    rw [if_pos hlarge, if_pos hsmall]
    rw [if_neg (fun h => (not_lt_of_ge hsmall) h.1)]
    norm_num
  · by_cases hlarge : d ≤ ((3 * j + 2 : ℕ) : ℕ∞)
    · unfold delta indicator
      rw [if_pos hlarge, if_neg hsmall, if_pos ⟨lt_of_not_ge hsmall, hlarge⟩]
      norm_num
    · unfold delta indicator
      rw [if_neg hlarge, if_neg hsmall, if_neg (fun h => hlarge h.2)]
      norm_num

theorem delta_nonneg (d : ℕ∞) (j : ℕ) : 0 ≤ delta d j := by
  rw [delta_eq]
  split_ifs <;> norm_num

theorem active_unique {d : ℕ∞} {l m : ℕ}
    (hl : (radius l : ℕ∞) < d ∧ d ≤ (radius (l + 1) : ℕ∞))
    (hm : (radius m : ℕ∞) < d ∧ d ≤ (radius (m + 1) : ℕ∞)) : l = m := by
  rcases lt_trichotomy l m with h | h | h
  · have hr : (radius (l + 1) : ℕ∞) ≤ (radius m : ℕ∞) := by
      exact_mod_cast radius_mono (Nat.succ_le_of_lt h)
    exact ((not_le_of_gt hm.1) (hl.2.trans hr)).elim
  · exact h
  · have hr : (radius (m + 1) : ℕ∞) ≤ (radius l : ℕ∞) := by
      exact_mod_cast radius_mono (Nat.succ_le_of_lt h)
    exact ((not_le_of_gt hl.1) (hm.2.trans hr)).elim

theorem sparse_delta_sum_le (k : ℕ) (d : ℕ∞) :
    (∑ l : Fin k, delta d (radius l.val)) ≤ 1 := by
  simp_rw [delta_eq, ← radius_succ]
  by_cases hex : ∃ l : Fin k,
      (radius l.val : ℕ∞) < d ∧ d ≤ (radius (l.val + 1) : ℕ∞)
  · obtain ⟨l, hl⟩ := hex
    have heq : (∑ m : Fin k,
        if (radius m.val : ℕ∞) < d ∧ d ≤ (radius (m.val + 1) : ℕ∞)
        then (1 : ℝ) else 0) = 1 := by
      rw [Finset.sum_eq_single l]
      · simp [hl]
      · intro m _ hml
        have hn : ¬((radius m.val : ℕ∞) < d ∧
            d ≤ (radius (m.val + 1) : ℕ∞)) := by
          intro hm
          exact hml (Fin.ext (active_unique hm hl))
        simp [hn]
      · simp
    exact heq.le
  · have hn (l : Fin k) : ¬((radius l.val : ℕ∞) < d ∧
        d ≤ (radius (l.val + 1) : ℕ∞)) := fun h => hex ⟨l, h⟩
    simp [hn]

theorem uniform_sum (k : ℕ) (hk : 0 < k) :
    (∑ _l : Fin k, (1 / (k : ℝ))) = 1 := by
  have hk0 : (k : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hk)
  simp [hk0]

theorem sparse_dilation (k : ℕ) (hk : 0 < k) (d : ℕ∞) :
    (∑ l : Fin k, (1 / (k : ℝ)) * delta d (radius l.val)) ≤ 1 / (k : ℝ) := by
  rw [← Finset.mul_sum]
  have hc : 0 ≤ 1 / (k : ℝ) := by positivity
  simpa only [mul_one] using
    mul_le_mul_of_nonneg_left (sparse_delta_sum_le k d) hc

theorem sparse_attains (k : ℕ) (hk : 0 < k) :
    (∑ l : Fin k, (1 / (k : ℝ)) * delta 1 (radius l.val)) = 1 / (k : ℝ) := by
  have hr (l : Fin k) : delta 1 (radius l.val) = if l.val = 0 then 1 else 0 := by
    rw [delta_eq]
    by_cases hz : l.val = 0
    · simp [hz]
    · have hp : 1 ≤ radius l.val := by
        exact le_trans (by norm_num [radius] : 1 ≤ radius 1)
          (radius_mono (show 1 ≤ l.val by omega))
      have hcast : (1 : ℕ∞) ≤ (radius l.val : ℕ∞) := by exact_mod_cast hp
      simp [hz, not_lt_of_ge hcast]
  simp_rw [hr]
  rw [Finset.sum_eq_single (⟨0, hk⟩ : Fin k)]
  · simp
  · intro l _ hl
    have hz : l.val ≠ 0 := fun h => hl (Fin.ext h)
    simp [hz]
  · simp

theorem exists_band {k j : ℕ} (hj : j < radius k) :
    ∃ l : Fin k, radius l.val ≤ j ∧ j < radius (l.val + 1) := by
  induction k with
  | zero => simp at hj
  | succ k ih =>
    by_cases hsmall : j < radius k
    · obtain ⟨l, hl⟩ := ih hsmall
      exact ⟨⟨l.val, Nat.lt_succ_of_lt l.isLt⟩, hl⟩
    · exact ⟨⟨k, Nat.lt_succ_self k⟩, ⟨le_of_not_gt hsmall, hj⟩⟩

theorem band_delta_one {l j : ℕ}
    (hj : radius l ≤ j ∧ j < radius (l + 1)) :
    delta (radius (l + 1) : ℕ∞) j = 1 := by
  rw [delta_eq]
  have hleft : (j : ℕ∞) < (radius (l + 1) : ℕ∞) := by exact_mod_cast hj.2
  have hn : radius (l + 1) ≤ 3 * j + 2 := by
    rw [radius_succ]
    omega
  have hright : (radius (l + 1) : ℕ∞) ≤ ((3 * j + 2 : ℕ) : ℕ∞) := by
    exact_mod_cast hn
  rw [if_pos ⟨hleft, hright⟩]

def loss {H : ℕ} (w : Fin H → ℝ) (d : ℕ∞) : ℝ :=
  ∑ j, w j * delta d j.val

theorem minimax_lower {H k : ℕ} (hH : H < 3 ^ k) (hk : 0 < k)
    (w : Fin H → ℝ) (hw : ∀ j, 0 ≤ w j) (hnorm : ∑ j, w j = 1) :
    ∃ l : Fin k, 1 / (k : ℝ) ≤ loss w (radius (l.val + 1) : ℕ∞) := by
  have hcut : H ≤ radius k := by
    have hr := radius_add_one k
    omega
  have hcover (j : Fin H) :
      1 ≤ ∑ l : Fin k, delta (radius (l.val + 1) : ℕ∞) j.val := by
    obtain ⟨l, hl⟩ := exists_band (lt_of_lt_of_le j.isLt hcut)
    have hsingle := Finset.single_le_sum
      (fun m (_ : m ∈ (Finset.univ : Finset (Fin k))) =>
        delta_nonneg (radius (m.val + 1) : ℕ∞) j.val) (Finset.mem_univ l)
    simpa only [band_delta_one hl] using hsingle
  have htotal :
      1 ≤ ∑ l : Fin k, loss w (radius (l.val + 1) : ℕ∞) := by
    unfold loss
    rw [Finset.sum_comm]
    calc
      1 = ∑ j, w j * 1 := by simpa using hnorm.symm
      _ ≤ ∑ j, ∑ l : Fin k, w j * delta (radius (l.val + 1) : ℕ∞) j.val := by
        apply Finset.sum_le_sum
        intro j _
        rw [← Finset.mul_sum]
        exact mul_le_mul_of_nonneg_left (hcover j) (hw j)
  have hsum : (∑ _l : Fin k, (1 / (k : ℝ))) ≤
      ∑ l : Fin k, loss w (radius (l.val + 1) : ℕ∞) := by
    rw [uniform_sum k hk]
    exact htotal
  obtain ⟨l, _, hl⟩ := Finset.exists_le_of_sum_le
    (show (Finset.univ : Finset (Fin k)).Nonempty from
      ⟨⟨0, hk⟩, Finset.mem_univ _⟩) hsum
  exact ⟨l, hl⟩

theorem support_admissible {H k : ℕ} (hk : 0 < k)
    (hH : 3 ^ (k - 1) ≤ H) (l : Fin k) : radius l.val < H := by
  have hl : l.val ≤ k - 1 := by omega
  have hm := radius_mono hl
  have hr := radius_add_one (k - 1)
  omega

def radiusEmbedding {H k : ℕ} (hk : 0 < k) (hH : 3 ^ (k - 1) ≤ H) :
    Fin k ↪ Fin H where
  toFun l := ⟨radius l.val, support_admissible hk hH l⟩
  inj' := by
    intro l m h
    exact Fin.ext (radius_strictMono.injective (congrArg Fin.val h))

def embeddedWeights {H k : ℕ} (e : Fin k ↪ Fin H) (j : Fin H) : ℝ :=
  ∑ l : Fin k, if e l = j then 1 / (k : ℝ) else 0

theorem embeddedWeights_nonneg {H k : ℕ} (e : Fin k ↪ Fin H) (j : Fin H) :
    0 ≤ embeddedWeights e j := by
  apply Finset.sum_nonneg
  intro l _
  split_ifs <;> positivity

theorem embeddedWeights_sum {H k : ℕ} (hk : 0 < k) (e : Fin k ↪ Fin H) :
    (∑ j, embeddedWeights e j) = 1 := by
  unfold embeddedWeights
  rw [Finset.sum_comm]
  simpa only [Finset.sum_ite_eq, Finset.mem_univ, if_true] using uniform_sum k hk

theorem embeddedWeights_loss {H k : ℕ} (e : Fin k ↪ Fin H) (d : ℕ∞) :
    loss (embeddedWeights e) d =
      ∑ l : Fin k, (1 / (k : ℝ)) * delta d (e l).val := by
  unfold loss embeddedWeights
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro l _
  simp [ite_mul, eq_comm]

theorem minimax_exact {H k : ℕ} (hk : 0 < k)
    (hlo : 3 ^ (k - 1) ≤ H) (hhi : H < 3 ^ k) :
    ∃ w : Fin H → ℝ, (∀ j, 0 ≤ w j) ∧ (∑ j, w j = 1) ∧
      (∀ d : ℕ∞, loss w d ≤ 1 / (k : ℝ)) ∧
      loss w 1 = 1 / (k : ℝ) ∧
      (∀ z : Fin H → ℝ, (∀ j, 0 ≤ z j) → (∑ j, z j = 1) →
        ∃ d : ℕ∞, 1 / (k : ℝ) ≤ loss z d) := by
  let e := radiusEmbedding hk hlo
  refine ⟨embeddedWeights e, embeddedWeights_nonneg e,
    embeddedWeights_sum hk e, ?_, ?_, ?_⟩
  · intro d
    rw [embeddedWeights_loss]
    exact sparse_dilation k hk d
  · rw [embeddedWeights_loss]
    exact sparse_attains k hk
  · intro z hz hnorm
    obtain ⟨l, hl⟩ := minimax_lower hhi hk z hz hnorm
    exact ⟨(radius (l.val + 1) : ℕ∞), hl⟩

def value (k : ℕ) (d : ℕ∞) : ℝ :=
  ∑ l : Fin k, (1 / (k : ℝ)) * indicator d (radius l.val)

theorem value_nonneg (k : ℕ) (d : ℕ∞) : 0 ≤ value k d := by
  unfold value
  apply Finset.sum_nonneg
  intro l _
  unfold indicator
  split_ifs <;> positivity

theorem value_le_one (k : ℕ) (hk : 0 < k) (d : ℕ∞) : value k d ≤ 1 := by
  rw [← uniform_sum k hk]
  unfold value
  apply Finset.sum_le_sum
  intro l _
  unfold indicator
  split_ifs
  · simp
  · simp only [mul_zero]
    positivity

theorem value_at_zero (k : ℕ) (hk : 0 < k) : value k 0 = 1 := by
  simpa [value, indicator] using uniform_sum k hk

theorem value_zero_of_cutoff {H k : ℕ} (hk : 0 < k)
    (hlo : 3 ^ (k - 1) ≤ H) {d : ℕ∞} (hd : (H : ℕ∞) < d) :
    value k d = 0 := by
  unfold value
  apply Finset.sum_eq_zero
  intro l _
  have hr : (radius l.val : ℕ∞) < (H : ℕ∞) := by
    exact_mod_cast support_admissible hk hlo l
  have hn : ¬d ≤ (radius l.val : ℕ∞) := not_le_of_gt (hr.trans hd)
  simp only [indicator, if_neg hn, mul_zero]

theorem value_at_infinity (k : ℕ) : value k ⊤ = 0 := by
  simp [value, indicator]

end
end SparseProfile

namespace SparseProfileCompression

universe vX vLabel
noncomputable section
open scoped BigOperators Classical

theorem sparse_profile_dilation (k : ℕ) (hk : 0 < k) {θ : ℝ}
    (hθ : 1 / (k : ℝ) ≤ θ) :
    DilationBound (fun l : Fin k => SparseProfile.radius l.val)
      (fun _ => 1 / (k : ℝ)) θ := by
  intro d
  exact (SparseProfile.sparse_dilation k hk d).trans hθ

theorem sparse_profile_partition_compression
    {X : Type vX} [Fintype X] [Nonempty X]
    {u q k s : ℕ} {Label : Fin u → Type vLabel}
    (L : (i : Fin u) → X → Label i)
    (hlabels : ∀ i, Nat.card (Set.range (L i)) ≤ q)
    (𝒯 : Finset (Finset (Fin u)))
    (hu : 0 < u) (hq : 0 < q) (hk : 0 < k) (hs : 0 < s)
    (θ : ℝ) (hθ : 0 < θ) (hsθ : 1 ≤ (s : ℝ) * θ)
    (hkθ : 1 / (k : ℝ) ≤ θ)
    (hcomp : ∀ T ∈ 𝒯, ((Finset.univ \ T).card : ℝ) ≤ θ * (u : ℝ)) :
    ∃ A : Finset (X → ℝ), A.Nonempty ∧
      A.card ≤ u * q ^ (k * s) *
        (Nat.floor (((s : ℝ) * 2 ^ u) / θ) + 1) ^ (k * s * 2 ^ u) ∧
      ∀ μ : Columns X 𝒯 → ℝ, (∀ y, 0 ≤ μ y) → (∑ y, μ y ≤ 1) →
        ∃ a ∈ A, ∀ x,
          (∑ y, μ y * column L 𝒯
            (fun l : Fin k => SparseProfile.radius l.val)
            (fun _ => 1 / (k : ℝ)) y x) - 3 * θ ≤ a x ∧
          a x ≤ (∑ y, μ y * column L 𝒯
            (fun l : Fin k => SparseProfile.radius l.val)
            (fun _ => 1 / (k : ℝ)) y x) + θ := by
  exact general_finite_profile_partition_compression L hlabels 𝒯 hu hq hk hs
    θ hθ hsθ (fun l : Fin k => SparseProfile.radius l.val)
    (fun _ => 1 / (k : ℝ)) (fun _ => by positivity)
    (SparseProfile.uniform_sum k hk) (sparse_profile_dilation k hk hkθ) hcomp

theorem sparse_profile_partition_signed_compression
    {X : Type vX} [Fintype X] [Nonempty X]
    {u q k s : ℕ} {Label : Fin u → Type vLabel}
    (L : (i : Fin u) → X → Label i)
    (hlabels : ∀ i, Nat.card (Set.range (L i)) ≤ q)
    (𝒯 : Finset (Finset (Fin u)))
    (hu : 0 < u) (hq : 0 < q) (hk : 0 < k) (hs : 0 < s)
    (θ : ℝ) (hθ : 0 < θ) (hsθ : 1 ≤ (s : ℝ) * θ)
    (hkθ : 1 / (k : ℝ) ≤ θ)
    (hcomp : ∀ T ∈ 𝒯, ((Finset.univ \ T).card : ℝ) ≤ θ * (u : ℝ)) :
    ∃ B : Finset (X → ℝ), B.Nonempty ∧
      B.card ≤ (u * q ^ (k * s) *
        (Nat.floor (((s : ℝ) * 2 ^ u) / θ) + 1) ^ (k * s * 2 ^ u)) ^ 2 ∧
      ∀ lam : Columns X 𝒯 → ℝ, (∑ y, |lam y| ≤ 1) →
        ∃ b ∈ B, ∀ x, |(∑ y, lam y * column L 𝒯
          (fun l : Fin k => SparseProfile.radius l.val)
          (fun _ => 1 / (k : ℝ)) y x) - b x| ≤ 6 * θ := by
  exact general_finite_profile_partition_signed_compression L hlabels 𝒯 hu hq hk hs
    θ hθ hsθ (fun l : Fin k => SparseProfile.radius l.val)
    (fun _ => 1 / (k : ℝ)) (fun _ => by positivity)
    (SparseProfile.uniform_sum k hk) (sparse_profile_dilation k hk hkθ) hcomp

theorem code_bound_real (u q k s : ℕ) {θ : ℝ} (hθ : 0 < θ) :
    ((u * q ^ (k * s) *
      (Nat.floor (((s : ℝ) * 2 ^ u) / θ) + 1) ^ (k * s * 2 ^ u) : ℕ) : ℝ) ≤
      (u : ℝ) * (q : ℝ) ^ (k * s) *
        (1 + (s : ℝ) * 2 ^ u / θ) ^ (k * s * 2 ^ u) := by
  have hx : 0 ≤ ((s : ℝ) * 2 ^ u) / θ := by positivity
  have hf := Nat.floor_le hx
  push_cast
  have he : (1 : ℝ) + (s : ℝ) * 2 ^ u / θ =
      (s : ℝ) * 2 ^ u / θ + 1 := by ring
  rw [he]
  gcongr

theorem sparse_profile_separates {H k : ℕ} (hk : 0 < k)
    (hlo : 3 ^ (k - 1) ≤ H) {d : ℕ∞} (hd : (H : ℕ∞) < d) :
    SparseProfile.value k 0 - SparseProfile.value k d = 1 := by
  rw [SparseProfile.value_at_zero k hk, SparseProfile.value_zero_of_cutoff hk hlo hd]
  norm_num

end
end SparseProfileCompression

#print axioms SparseProfile.minimax_exact
#print axioms SparseProfileCompression.general_finite_profile_partition_compression
#print axioms SparseProfileCompression.sparse_profile_partition_compression
#print axioms SparseProfileCompression.sparse_profile_partition_signed_compression
#print axioms SparseProfileCompression.code_bound_real
#print axioms SparseProfileCompression.sparse_profile_separates
