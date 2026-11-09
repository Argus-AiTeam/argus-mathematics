import OAI.Combinatorics.InfiniteMatroid.BasisExtension

open Set Filter
open scoped Topology symmDiff
open OAI.InfiniteMatroidCounterexample

namespace Manuscript185

abbrev Ground := ((m : ℕ) × ((Fin m → Bool) → Bool)) × Bool

local notation "BlockSmall" => OAI.InfiniteMatroidCounterexample.Small

theorem ground_bridge : Ground = E0 := rfl

def W (m : ℕ) : Set Ground := {x | x.1.1 = m}
def V (n : ℕ) : Set Ground := {x | x.1.1 < n}

theorem prefix_union (n : ℕ) : V n = ⋃ m ∈ Set.Iio n, W m := by
  ext x
  simp only [V, W, Set.mem_setOf_eq, Set.mem_iUnion, Set.mem_Iio]
  constructor
  · intro hx
    exact ⟨x.1.1, hx, rfl⟩
  · rintro ⟨m, hm, hx⟩
    simpa only [hx] using hm

noncomputable def blockCount (X : Set Ground) (m : ℕ) : ℕ := (X ∩ W m).ncard
noncomputable def prefixCount (X : Set Ground) (n : ℕ) : ℕ := (X ∩ V n).ncard
noncomputable def blockSize (m : ℕ) : ℕ := (W m).ncard
noncomputable def prefixSize (n : ℕ) : ℕ := (V n).ncard

theorem block_set_bridge (m : ℕ) : W m = (wBlock m : Set E0) := by
  ext x
  simp only [W, Set.mem_setOf_eq, Finset.mem_coe, mem_wBlock]

theorem prefix_set_bridge (n : ℕ) : V n = (blockPrefix n : Set E0) := by
  ext x
  simp only [V, Set.mem_setOf_eq, Finset.mem_coe, mem_prefix]

theorem block_count_bridge (X : Set Ground) (m : ℕ) :
    blockCount X m = (traceFinset (wBlock m) X).card := by
  have he : X ∩ W m = (traceFinset (wBlock m) X : Set E0) := by
    ext x
    simp only [Set.mem_inter_iff, block_set_bridge, Finset.mem_coe, mem_traceFinset]
    tauto
  unfold blockCount
  rw [he]
  simp

theorem prefix_count_bridge (X : Set Ground) (n : ℕ) :
    prefixCount X n = (traceFinset (blockPrefix n) X).card := by
  have he : X ∩ V n = (traceFinset (blockPrefix n) X : Set E0) := by
    ext x
    simp only [Set.mem_inter_iff, prefix_set_bridge, Finset.mem_coe, mem_traceFinset]
    tauto
  unfold prefixCount
  rw [he]
  simp

theorem block_size_bridge (m : ℕ) : blockSize m = (wBlock m).card := by
  simp [blockSize, block_set_bridge]

theorem prefix_size_bridge (n : ℕ) : prefixSize n = (blockPrefix n).card := by
  simp [prefixSize, prefix_set_bridge]

theorem literal_block_size (m : ℕ) : blockSize m = 2 * 2 ^ (2 ^ m) := by
  rw [block_size_bridge, card_wBlock]

noncomputable def blockDensity (X : Set Ground) (m : ℕ) : ℝ :=
  (blockCount X m : ℝ) / blockSize m

def densityZero (X : Set Ground) : Prop :=
  Tendsto (blockDensity X) atTop (𝓝 0)

def sliceBlock (X : Set Ground) (b : Bool) (m : ℕ) : Set D :=
  {d | d.1 = m ∧ (d, b) ∈ X}

noncomputable def sliceDensity (X : Set Ground) (b : Bool) (m : ℕ) : ℝ :=
  ((sliceBlock X b m).ncard : ℝ) / (2 ^ (2 ^ m) : ℕ)

def sliceIdeal (X : Set Ground) : Prop :=
  Tendsto (sliceDensity X false) atTop (𝓝 0) ∧
  Tendsto (sliceDensity X true) atTop (𝓝 0)

theorem slice_count_bridge (X : Set Ground) (b : Bool) (m : ℕ) :
    (sliceBlock X b m).ncard = ((X ∩ W m) ∩ {x | x.2 = b}).ncard := by
  have he : (fun d : D ↦ (d, b)) '' sliceBlock X b m =
      (X ∩ W m) ∩ {x | x.2 = b} := by
    ext x
    constructor
    · rintro ⟨d, hd, rfl⟩
      exact ⟨⟨hd.2, hd.1⟩, rfl⟩
    · intro hx
      rcases x with ⟨d, c⟩
      have hcb : c = b := hx.2
      subst c
      exact ⟨d, ⟨hx.1.2, hx.1.1⟩, rfl⟩
  rw [← he, Set.ncard_image_of_injective _ (fun _ _ h ↦ (Prod.mk.inj h).1)]

theorem block_count_slices (X : Set Ground) (m : ℕ) :
    blockCount X m = (sliceBlock X false m).ncard + (sliceBlock X true m).ncard := by
  let F := (X ∩ W m) ∩ {x | x.2 = false}
  let G := (X ∩ W m) ∩ {x | x.2 = true}
  have hw : (W m).Finite := by
    rw [block_set_bridge]
    exact Finset.finite_toSet _
  have hX : (X ∩ W m).Finite := hw.subset Set.inter_subset_right
  have hd : Disjoint F G := Set.disjoint_left.mpr (by
    intro x hx hy
    have h : false = true := hx.2.symm.trans hy.2
    cases h)
  have he : X ∩ W m = F ∪ G := by
    ext x
    constructor
    · intro hx
      cases hb : x.2 with
      | false => exact Or.inl ⟨hx, hb⟩
      | true => exact Or.inr ⟨hx, hb⟩
    · rintro (hx | hx)
      · exact hx.1
      · exact hx.1
  unfold blockCount
  rw [he, Set.ncard_union_eq hd (hX.subset Set.inter_subset_left)
    (hX.subset Set.inter_subset_left)]
  rw [slice_count_bridge X false m, slice_count_bridge X true m]

theorem density_average (X : Set Ground) (m : ℕ) :
    blockDensity X m = (sliceDensity X false m + sliceDensity X true m) / 2 := by
  unfold blockDensity sliceDensity
  rw [block_count_slices, literal_block_size, Nat.cast_add, Nat.cast_mul, Nat.cast_ofNat]
  ring

theorem slice_density_nonneg (X : Set Ground) (b : Bool) (m : ℕ) :
    0 ≤ sliceDensity X b m := by
  unfold sliceDensity
  positivity

theorem slice_density_bound (X : Set Ground) (b : Bool) (m : ℕ) :
    sliceDensity X b m ≤ 2 * blockDensity X m := by
  have he := density_average X m
  have hfalse := slice_density_nonneg X false m
  have htrue := slice_density_nonneg X true m
  cases b <;> linarith

theorem slice_ideal_bridge (X : Set Ground) : sliceIdeal X ↔ densityZero X := by
  constructor
  · rintro ⟨hf, ht⟩
    have he : blockDensity X =
        fun m ↦ (sliceDensity X false m + sliceDensity X true m) / 2 :=
      funext (density_average X)
    unfold densityZero
    rw [he]
    simpa only [zero_add, zero_div] using (hf.add ht).div_const 2
  · intro h
    have htwice : Tendsto (fun m ↦ 2 * blockDensity X m) atTop (𝓝 0) := by
      simpa only [mul_zero] using h.const_mul 2
    have hs (b : Bool) : Tendsto (sliceDensity X b) atTop (𝓝 0) :=
      tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds htwice
        (fun m ↦ slice_density_nonneg X b m) (fun m ↦ slice_density_bound X b m)
    exact ⟨hs false, hs true⟩

def prototypeClass (T X : Set Ground) : Prop := sliceIdeal (X ∆ T)

noncomputable def prefixDifference (T X : Set Ground) (n : ℕ) : ℝ :=
  (prefixCount X n : ℝ) - (prefixCount T n : ℝ)

noncomputable def blockDifference (T X : Set Ground) (m : ℕ) : ℝ :=
  ((blockCount X m : ℝ) - (blockCount T m : ℝ)) / blockSize m

noncomputable def probe (T : Set Ground) (n : ℕ) (X : Set Ground) : ℝ :=
  prefixDifference T X n + (prefixSize n : ℝ) *
    (sSup (blockDifference T X '' Set.Ici n) +
     sInf (blockDifference T X '' Set.Ici n))

noncomputable def lowerLimit (T X : Set Ground) : EReal :=
  liminf (fun n : ℕ ↦ (probe T (n + 1) X : EReal)) atTop

noncomputable def upperLimit (T X : Set Ground) : EReal :=
  limsup (fun n : ℕ ↦ (probe T (n + 1) X : EReal)) atTop

def basesMinus (T : Set Ground) : Set (Set Ground) :=
  {X | prototypeClass T X ∧ -1 < lowerLimit T X ∧ lowerLimit T X ≤ 0}

def basesPlus (T : Set Ground) : Set (Set Ground) :=
  {X | prototypeClass T X ∧ 0 ≤ upperLimit T X ∧ upperLimit T X < 1}

def bases (upper : Bool) (T : Set Ground) : Set (Set Ground) :=
  if upper then basesPlus T else basesMinus T

theorem density_bridge (X : Set Ground) : blockDensity X = density X := by
  funext m
  simp [blockDensity, density, finiteDensity, block_count_bridge, block_size_bridge]

theorem density_zero_bridge (X : Set Ground) : densityZero X ↔ BlockSmall X := by
  simp only [densityZero, density_bridge, OAI.InfiniteMatroidCounterexample.Small]

theorem class_bridge (T X : Set Ground) : prototypeClass T X ↔ SameClass T X := by
  exact (slice_ideal_bridge (X ∆ T)).trans (density_zero_bridge (X ∆ T))

theorem prefix_difference_bridge (T X : Set Ground) :
    prefixDifference T X = pProbe T X := by
  funext n
  simp [prefixDifference, pProbe, prefix_count_bridge]

theorem block_difference_bridge (T X : Set Ground) :
    blockDifference T X = dProbe T X := by
  funext m
  simp [blockDifference, dProbe, density, finiteDensity,
    block_count_bridge, block_size_bridge, sub_div]

theorem probe_bridge (T : Set Ground) (n : ℕ) (X : Set Ground) :
    probe T n X = fProbe T n X := by
  simp only [probe, fProbe, prefix_difference_bridge, prefix_size_bridge,
    block_difference_bridge, tailSup, tailInf]

theorem lower_limit_bridge (T X : Set Ground) :
    lowerLimit T X = probeLiminf (fProbe T) X := by
  unfold lowerLimit
  simp only [probe_bridge]
  change liminf ((fun n : ℕ ↦ (fProbe T n X : EReal)) ∘
    (fun n : ℕ ↦ n + 1)) atTop = _
  rw [liminf_comp, map_add_atTop_eq_nat]
  rfl

theorem upper_limit_bridge (T X : Set Ground) :
    upperLimit T X = limsup (fun n ↦ (fProbe T n X : EReal)) atTop := by
  unfold upperLimit
  simp only [probe_bridge]
  change limsup ((fun n : ℕ ↦ (fProbe T n X : EReal)) ∘
    (fun n : ℕ ↦ n + 1)) atTop = _
  rw [limsup_comp, map_add_atTop_eq_nat]

theorem lower_rule_bridge (T X : Set Ground) :
    X ∈ basesMinus T ↔ X ∈ LocalLower T := by
  simp only [basesMinus, LocalLower, Set.mem_setOf_eq, LowerBasis,
    class_bridge, lower_limit_bridge]

theorem upper_rule_bridge (T X : Set Ground) :
    X ∈ basesPlus T ↔ X ∈ LocalUpper T := by
  simpa only [basesPlus, Set.mem_setOf_eq, class_bridge, upper_limit_bridge] using
    (localUpper_iff T X).symm

theorem rule_bridge (s : Bool) (T X : Set Ground) :
    X ∈ bases s T ↔ X ∈ LocalRule s T := by
  cases s with
  | false => exact lower_rule_bridge T X
  | true => exact upper_rule_bridge T X

theorem probe_complement (T X : Set Ground) (n : ℕ) :
    probe Tᶜ n Xᶜ = -probe T n X := by
  simp only [probe_bridge, fProbe_compl]

theorem complement_limits (T X : Set Ground) :
    lowerLimit Tᶜ Xᶜ = -upperLimit T X := by
  rw [lower_limit_bridge, upper_limit_bridge]
  simp only [probeLiminf, fProbe_compl, EReal.coe_neg]
  exact EReal.liminf_neg

theorem lower_neg_one_boundary (T X : Set Ground) (h : lowerLimit T X = -1) :
    X ∉ basesMinus T := by
  intro hx
  have hh := hx.2.1
  rw [h] at hh
  exact (lt_irrefl _ hh)

theorem lower_zero_boundary (T X : Set Ground) (h : lowerLimit T X = 0) :
    X ∈ basesMinus T ↔ prototypeClass T X := by
  simp [basesMinus, h]

theorem upper_zero_boundary (T X : Set Ground) (h : upperLimit T X = 0) :
    X ∈ basesPlus T ↔ prototypeClass T X := by
  simp [basesPlus, h]

theorem upper_one_boundary (T X : Set Ground) (h : upperLimit T X = 1) :
    X ∉ basesPlus T := by
  intro hx
  have hh := hx.2.2
  rw [h] at hh
  exact (lt_irrefl _ hh)

theorem concrete_finite_shift (T I Y : Set Ground) :
    IntervalFiniteShift (fProbe T) I Y := by
  intro A B _ hAB _ hfin
  simpa only [EReal.coe_natCast] using
    probeLiminf_finite_change (finite_change_eventually (T := T) hAB hfin)

theorem finite_lower_branch {T I Y : Set Ground} (hIY : I ⊆ Y)
    (hI : prototypeClass T I) (hY : prototypeClass T Y)
    (hlo : lowerLimit T I ≤ -1) (hhi : 0 < lowerLimit T Y)
    (hfinite : lowerLimit T I ≠ ⊥) :
    ∃ B, I ⊆ B ∧ B ⊆ Y ∧ B ∈ basesMinus T := by
  rw [class_bridge] at hI hY
  rw [lower_limit_bridge] at hlo hhi hfinite
  obtain ⟨B, hIB, hBY, hB⟩ := finite_lower_interpolation hIY
    (concrete_finite_shift T I Y) hlo hhi hfinite
  exact ⟨B, hIB, hBY, (lower_rule_bridge T B).mpr
    ⟨sameClass_interval hI hY hIB hBY, hB⟩⟩

theorem finite_upper_branch {T I Y : Set Ground} (hIY : I ⊆ Y)
    (hI : prototypeClass T I) (hY : prototypeClass T Y)
    (hlo : lowerLimit T I = ⊥) (hhi : 0 < lowerLimit T Y)
    (hfinite : lowerLimit T Y ≠ ⊤) :
    ∃ B, I ⊆ B ∧ B ⊆ Y ∧ B ∈ basesMinus T := by
  rw [class_bridge] at hI hY
  rw [lower_limit_bridge] at hlo hhi hfinite
  obtain ⟨B, hIB, hBY, hB⟩ := finite_upper_interpolation hIY
    (concrete_finite_shift T I Y) hlo hhi hfinite
  exact ⟨B, hIB, hBY, (lower_rule_bridge T B).mpr
    ⟨sameClass_interval hI hY hIB hBY, hB⟩⟩

theorem opposite_infinite_branch {T I Y : Set Ground} (hIY : I ⊆ Y)
    (hI : prototypeClass T I) (hY : prototypeClass T Y)
    (hlo : lowerLimit T I = ⊥) (hhi : lowerLimit T Y = ⊤) :
    ∃ B, I ⊆ B ∧ B ⊆ Y ∧ B ∈ basesMinus T := by
  rw [class_bridge] at hI hY
  rw [lower_limit_bridge] at hlo hhi
  obtain ⟨B, hIB, hBY, hBT, hB⟩ := fProbe_interpolation hI hY hIY
    (by rw [hlo]; exact bot_le) (by rw [hhi]; exact EReal.coe_lt_top 0)
  exact ⟨B, hIB, hBY, (lower_rule_bridge T B).mpr ⟨hBT, hB⟩⟩

theorem alternative_of_left_small (s : Bool) {T I Y : Set Ground}
    (hT : ¬ BlockSmall T) (hTc : ¬ BlockSmall Tᶜ) (hIY : I ⊆ Y)
    (hsmall : BlockSmall (T \ I)) :
    ∃ B ∈ LocalRule s T, B ⊆ I ∨ (I ⊆ B ∧ B ⊆ Y) ∨ Y ⊆ B := by
  by_cases hI : SameClass T I
  · by_cases hgap : BlockSmall (Y \ I)
    · have hY : SameClass T Y := by
        apply sameClass_trans hI
        change BlockSmall (Y ∆ I)
        apply OAI.InfiniteMatroidCounterexample.small_subset hgap
        intro x hx
        rcases Set.mem_symmDiff.mp hx with hh | hh
        · exact hh
        · exact (hh.2 (hIY hh.1)).elim
      exact localRule_interval s hT hTc hIY hI hY
    · obtain ⟨B, hB, hBI | hbetween⟩ :=
        localRule_lower_endpoint s hT hTc hIY hI hgap
      · exact ⟨B, hB, Or.inl hBI⟩
      · exact ⟨B, hB, Or.inr (Or.inl hbetween)⟩
  · have hX : SameClass T (T ∩ I) := by
      change BlockSmall ((T ∩ I) ∆ T)
      apply OAI.InfiniteMatroidCounterexample.small_subset hsmall
      intro x hx
      rcases Set.mem_symmDiff.mp hx with hh | hh
      · exact (hh.2 hh.1.1).elim
      · exact ⟨hh.1, fun hi ↦ hh.2 ⟨hh.1, hi⟩⟩
    have hpositive : ¬ BlockSmall (I \ T) := by
      intro hh
      apply hI
      change BlockSmall (I ∆ T)
      apply OAI.InfiniteMatroidCounterexample.small_subset (small_union hh hsmall)
      intro x hx
      simp only [Set.mem_symmDiff, Set.mem_sdiff, Set.mem_union] at hx ⊢
      exact hx
    have hgap : ¬ BlockSmall (I \ (T ∩ I)) := by
      have he : I \ (T ∩ I) = I \ T := by
        ext x
        constructor
        · intro hx
          exact ⟨hx.1, fun ht ↦ hx.2 ⟨ht, hx.1⟩⟩
        · intro hx
          exact ⟨hx.1, fun hti ↦ hx.2 hti.1⟩
      rwa [he]
    obtain ⟨B, hB, hBX | hbetween⟩ := localRule_lower_endpoint s hT hTc
      (Set.inter_subset_right : T ∩ I ⊆ I) hX hgap
    · exact ⟨B, hB, Or.inl (hBX.trans Set.inter_subset_right)⟩
    · exact ⟨B, hB, Or.inl hbetween.2⟩

theorem native_interval_alternative (s : Bool) {T I Y : Set Ground}
    (hT : ¬ BlockSmall T) (hTc : ¬ BlockSmall Tᶜ) (hIY : I ⊆ Y)
    (hsmall : BlockSmall (T \ I) ∨ BlockSmall (Y \ T)) :
    ∃ B ∈ LocalRule s T, B ⊆ I ∨ (I ⊆ B ∧ B ⊆ Y) ∨ Y ⊆ B := by
  rcases hsmall with hleft | hright
  · exact alternative_of_left_small s hT hTc hIY hleft
  · have hc : BlockSmall (Tᶜ \ Yᶜ) := by
      have he : Tᶜ \ Yᶜ = Y \ T := by
        ext x
        simp only [Set.mem_sdiff, Set.mem_compl_iff, not_not, and_comm]
      rwa [he]
    obtain ⟨B, hB, hBY | ⟨hYB, hBI⟩ | hIB⟩ :=
      alternative_of_left_small (!s) hTc (by simpa using hT)
        (Set.compl_subset_compl.mpr hIY) hc
    · refine ⟨Bᶜ, ?_, Or.inr (Or.inr ?_)⟩
      · simpa only [Bool.not_not, compl_compl] using localRule_compl hB
      · simpa only [compl_compl] using Set.compl_subset_compl.mpr hBY
    · refine ⟨Bᶜ, ?_, Or.inr (Or.inl ⟨?_, ?_⟩)⟩
      · simpa only [Bool.not_not, compl_compl] using localRule_compl hB
      · simpa only [compl_compl] using Set.compl_subset_compl.mpr hBI
      · simpa only [compl_compl] using Set.compl_subset_compl.mpr hYB
    · refine ⟨Bᶜ, ?_, Or.inl ?_⟩
      · simpa only [Bool.not_not, compl_compl] using localRule_compl hB
      · simpa only [compl_compl] using Set.compl_subset_compl.mpr hIB

theorem proposition_local_intervals (s : Bool) (T I Y : Set Ground)
    (hT : ¬ sliceIdeal T) (hTc : ¬ sliceIdeal Tᶜ) (hIY : I ⊆ Y)
    (hsmall : sliceIdeal (T \ I) ∨ sliceIdeal (Y \ T)) :
    ∃ B ∈ bases s T, B ⊆ I ∨ (I ⊆ B ∧ B ⊆ Y) ∨ Y ⊆ B := by
  simp only [slice_ideal_bridge, density_zero_bridge] at hT hTc hsmall
  obtain ⟨B, hB, halt⟩ := native_interval_alternative s hT hTc hIY hsmall
  exact ⟨B, (rule_bridge s T B).mpr hB, halt⟩

end Manuscript185

#print axioms Manuscript185.proposition_local_intervals
#print axioms Manuscript185.slice_ideal_bridge
#print axioms Manuscript185.density_average
#print axioms Manuscript185.finite_lower_branch
#print axioms Manuscript185.finite_upper_branch
#print axioms Manuscript185.opposite_infinite_branch
#print axioms Manuscript185.lower_rule_bridge
#print axioms Manuscript185.upper_rule_bridge
#print axioms Manuscript185.lower_zero_boundary
#print axioms Manuscript185.lower_neg_one_boundary
#print axioms Manuscript185.upper_zero_boundary
#print axioms Manuscript185.upper_one_boundary
#print axioms OAI.InfiniteMatroidCounterexample.local_interpolation
#print axioms OAI.InfiniteMatroidCounterexample.fProbe_interpolation
#print axioms OAI.InfiniteMatroidCounterexample.positive_pool_add
