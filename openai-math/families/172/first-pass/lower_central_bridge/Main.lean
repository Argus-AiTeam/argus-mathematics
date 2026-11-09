import research.endpoint_bridge.Main

set_option autoImplicit false

namespace LowerCentralBridge

open EndpointBridge
open scoped commutatorElement

universe u v w

variable {G : Type u} [Group G] {I : Type v}

theorem fraction_conjugate_rep {R : Grading I G} {x z : I → G} {m : ℕ}
    (hx : R.rep x m) (hz : HasFraction R z) :
    HasFraction R (x * z * x⁻¹) := by
  obtain ⟨n, a, b, p, q, ha, hb, he, _⟩ := hz
  refine ⟨(m + p) + (m + q), x * a, x * b, m + p, m + q,
    R.multiply hx ha, R.multiply hx hb, ?_, rfl⟩
  rw [he]
  group

theorem lower_inclusion_aux (N : Subgroup G) (n : ℕ) :
    ∀ (I : Type v) [Fintype I] (R : Grading I G),
      Fintype.card I = n → 2 ≤ n → PairHyp R N →
      ∀ i, N.lowerCentralSeries (n - 2) ≤ supportedSubgroup R i := by
  classical
  induction n using Nat.strong_induction_on with
  | h n ih =>
    intro I _ R hcard hn hp i
    have hlt : ({i} : Finset I).card < (Finset.univ : Finset I).card := by
      simp only [Finset.card_singleton, Finset.card_univ, hcard]
      omega
    obtain ⟨j, _, hji⟩ := Finset.exists_mem_notMem_of_card_lt_card hlt
    simp only [Finset.mem_singleton] at hji
    by_cases htwo : n = 2
    · rw [htwo]
      simpa [EndpointBridge.derived] using
        (derived_inclusion_aux N 2 I R (hcard.trans htwo) (by omega) hp i)
    · have hthree : 3 ≤ n := by omega
      have lift_at (a : G) (ha : a ∈ N.lowerCentralSeries (n - 3)) :
          ∃ z, HasFraction R z ∧ PairSupported z i j ∧ z i = a := by
        let J := {x : I // x ≠ j}
        let RJ := R.project (fun x : J => x.val)
        have hcJ : Fintype.card J = n - 1 := by
          simpa [J, hcard] using Fintype.card_subtype_compl (fun x : I => x = j)
        have hpJ : PairHyp RJ N := pairHyp_project hp _ Subtype.val_injective
        have hd : n - 1 - 2 = n - 3 := by omega
        have hai : a ∈ supportedSubgroup RJ (⟨i, Ne.symm hji⟩ : J) :=
          ih (n - 1) (by omega) J RJ hcJ (by omega) hpJ _
            (by simpa [hd] using ha)
        obtain ⟨m, u, v, p, q, hu, hv, he, _⟩ := hai
        obtain ⟨U, hU, eU⟩ := hu
        obtain ⟨V, hV, eV⟩ := hv
        refine ⟨U * V⁻¹, ⟨p + q, U, V, p, q, hU, hV, rfl, rfl⟩, ?_, ?_⟩
        · intro l hli hlj
          change U l * (V l)⁻¹ = 1
          rw [eU (⟨l, hlj⟩ : J), eV (⟨l, hlj⟩ : J)]
          have hne : (⟨l, hlj⟩ : J) ≠ ⟨i, Ne.symm hji⟩ :=
            fun h => hli (congrArg Subtype.val h)
          simpa [spike, hne] using (congrFun he (⟨l, hlj⟩ : J)).symm
        · change U i * (V i)⁻¹ = a
          rw [eU (⟨i, Ne.symm hji⟩ : J), eV (⟨i, Ne.symm hji⟩ : J)]
          simpa using (congrFun he (⟨i, Ne.symm hji⟩ : J)).symm
      have hd : n - 2 = (n - 3) + 1 := by omega
      rw [hd, Subgroup.lowerCentralSeries_succ]
      apply Subgroup.commutator_le.mpr
      intro a ha b hb
      obtain ⟨z, hf, hs, hz⟩ := lift_at a ha
      obtain ⟨x, m, hx, hxi, hxj⟩ :=
        hp.2 i j (Ne.symm hji) b hb 1 N.one_mem
      have hfi : HasFraction R z⁻¹ := by
        obtain ⟨k, hk⟩ := hf
        exact ⟨k, fraction_inv hk⟩
      have hconj := fraction_conjugate_rep hx hfi
      have hsconj : PairSupported (x * z⁻¹ * x⁻¹) i j := by
        intro l hli hlj
        simp [Pi.mul_apply, Pi.inv_apply, hs l hli hlj]
      have hprod := pair_multiply hp (Ne.symm hji) hsconj hf hconj
      have he : z * (x * z⁻¹ * x⁻¹) = spike i ⁅a, b⁆ := by
        ext l
        by_cases hli : l = i
        · subst l
          simp [Pi.mul_apply, Pi.inv_apply, hz, hxi, commutatorElement_def,
            mul_assoc]
        · by_cases hlj : l = j
          · subst l
            simp [Pi.mul_apply, Pi.inv_apply, hxj, spike, hji]
          · simp [Pi.mul_apply, Pi.inv_apply, hs l hli hlj, spike, hli]
      rwa [he] at hprod

theorem lower_inclusion [Fintype I] {N : Subgroup G} {R : Grading I G}
    (hs : 2 ≤ Fintype.card I) (hp : PairHyp R N) (i : I) :
    N.lowerCentralSeries (Fintype.card I - 2) ≤ supportedSubgroup R i :=
  lower_inclusion_aux N _ I R rfl hs hp i

def monoidGrading (M : Submonoid (I → G))
    (hd : ∀ g : G, (fun _ : I => g) ∈ M) : Grading I G where
  rep z n := z ∈ M ∧ n = 0
  diagonal g := ⟨hd g, rfl⟩
  multiply := by
    rintro a b m n ⟨ha, rfl⟩ ⟨hb, rfl⟩
    exact ⟨M.mul_mem ha hb, rfl⟩

def coordinatePair (i j : I) : (I → G) →* G × G where
  toFun z := (z i, z j)
  map_one' := rfl
  map_mul' _ _ := rfl

theorem monoid_pair_projection (M : Submonoid (I → G))
    (hd : ∀ g : G, (fun _ : I => g) ∈ M) (i j : I) :
    pairProjection (monoidGrading M hd) i j = M.map (coordinatePair i j) := by
  ext p
  constructor
  · rintro ⟨z, n, ⟨hz, _⟩, hi, hj⟩
    exact ⟨z, hz, Prod.ext hi hj⟩
  · rintro ⟨z, hz, hp⟩
    exact ⟨z, 0, ⟨hz, rfl⟩, congrArg Prod.fst hp, congrArg Prod.snd hp⟩

theorem actual_right_fraction [Fintype I] (N : Subgroup G) [N.Normal]
    (M : Submonoid (I → G)) (hd : ∀ g : G, (fun _ : I => g) ∈ M)
    (hs : 2 ≤ Fintype.card I)
    (hclosed : ∀ i j : I, i ≠ j → ∀ p ∈ M.map (coordinatePair i j),
      p⁻¹ ∈ M.map (coordinatePair i j))
    (hcontains : ∀ i j : I, i ≠ j → ∀ a ∈ N, ∀ b ∈ N,
      (a, b) ∈ M.map (coordinatePair i j))
    (i : I) (g : G) (hg : g ∈ N.lowerCentralSeries (Fintype.card I - 2)) :
    ∃ u ∈ M, ∃ v ∈ M, spike i g = u * v⁻¹ := by
  let R := monoidGrading M hd
  have hp : PairProjectionHyp R N := by
    intro k l hkl
    simpa only [R, monoid_pair_projection] using
      And.intro (hclosed k l hkl) (hcontains k l hkl)
  obtain ⟨n, u, v, a, b, ⟨hu, _⟩, ⟨hv, _⟩, he, _⟩ :=
    lower_inclusion hs (pairHyp_of_projections hp) i hg
  exact ⟨u, hu, v, hv, he⟩

theorem three_subgroups_le (A B C T : Subgroup G) [T.Normal]
    (h₁ : ⁅⁅B, C⁆, A⁆ ≤ T) (h₂ : ⁅⁅C, A⁆, B⁆ ≤ T) :
    ⁅⁅A, B⁆, C⁆ ≤ T := by
  let f := QuotientGroup.mk' T
  have kill (P : Subgroup G) (hP : P ≤ T) : P.map f = ⊥ := by
    apply le_antisymm ?_ bot_le
    apply Subgroup.map_le_iff_le_comap.mpr
    simpa [f] using hP
  have h := Subgroup.commutator_commutator_eq_bot_of_rotate
    (H₁ := A.map f) (H₂ := B.map f) (H₃ := C.map f)
    (by simpa only [Subgroup.map_commutator] using kill _ h₁)
    (by simpa only [Subgroup.map_commutator] using kill _ h₂)
  have h' : (⁅⁅A, B⁆, C⁆).map f = ⊥ := by
    simpa only [Subgroup.map_commutator] using h
  have hk := Subgroup.map_le_iff_le_comap.mp (le_of_eq h')
  simpa [f] using hk

theorem lower_commutator (N : Subgroup G) [N.Normal] (n : ℕ) :
    ∀ m, ⁅N.lowerCentralSeries m, N.lowerCentralSeries n⁆ ≤
      N.lowerCentralSeries (m + n + 1) := by
  induction n with
  | zero =>
    intro m
    simp only [Nat.add_zero, Subgroup.lowerCentralSeries_zero,
      Subgroup.lowerCentralSeries_succ, le_refl]
  | succ n ih =>
    intro m
    let T := N.lowerCentralSeries (m + n + 2)
    have h₁ : ⁅⁅N, N.lowerCentralSeries m⁆, N.lowerCentralSeries n⁆ ≤ T := by
      rw [Subgroup.commutator_comm N]
      change ⁅N.lowerCentralSeries (m + 1), N.lowerCentralSeries n⁆ ≤ T
      have he : (m + 1) + n + 1 = m + n + 2 := by omega
      simpa only [he] using ih (m + 1)
    have h₂ : ⁅⁅N.lowerCentralSeries m, N.lowerCentralSeries n⁆, N⁆ ≤ T := by
      have h := Subgroup.commutator_mono (ih m) (le_refl N)
      simpa only [T, ← Subgroup.lowerCentralSeries_succ, Nat.add_assoc] using h
    change ⁅N.lowerCentralSeries m, ⁅N.lowerCentralSeries n, N⁆⁆ ≤ T
    rw [Subgroup.commutator_comm]
    exact three_subgroups_le _ _ _ T h₁ h₂

theorem derived_le_lower_pow (N : Subgroup G) [N.Normal] (r : ℕ) :
    derived N r ≤ N.lowerCentralSeries (2 ^ r - 1) := by
  induction r with
  | zero => simp [derived]
  | succ r ih =>
    change ⁅derived N r, derived N r⁆ ≤ _
    have h := (Subgroup.commutator_mono ih ih).trans
      (lower_commutator N (2 ^ r - 1) (2 ^ r - 1))
    have hp : 0 < (2 : ℕ) ^ r := by positivity
    have he : 2 ^ r - 1 + (2 ^ r - 1) + 1 = 2 ^ (r + 1) - 1 := by
      rw [pow_succ]
      omega
    simpa only [he] using h

theorem derived_inclusion_of_pow [Fintype I] {N : Subgroup G} [N.Normal]
    {R : Grading I G} (hs : 2 ≤ Fintype.card I) (hp : PairHyp R N)
    (r : ℕ) (hr : Fintype.card I - 1 ≤ 2 ^ r) (i : I) :
    derived N r ≤ supportedSubgroup R i := by
  have hi : Fintype.card I - 2 ≤ 2 ^ r - 1 := by omega
  exact (derived_le_lower_pow N r).trans
    ((N.lowerCentralSeries_antitone hi).trans (lower_inclusion hs hp i))

noncomputable def depthCost [Fintype I] {N : Subgroup G} [N.Normal]
    {R : Grading I G} (hs : 2 ≤ Fintype.card I) (hp : PairHyp R N)
    (r : ℕ) (hr : Fintype.card I - 1 ≤ 2 ^ r) : InvariantCost (derived N r) where
  val g := maxCost R g
  nonneg g := Nat.cast_nonneg _
  one := by
    classical
    simp [maxCost]
  inv g hg := by
    classical
    congr 1
    apply Finset.sup_congr rfl
    intro i _
    exact singleCost_inv (derived_inclusion_of_pow hs hp r hr i hg)
  conj g hg k := by
    classical
    congr 1
    apply Finset.sup_congr rfl
    intro i _
    exact singleCost_conj (derived_inclusion_of_pow hs hp r hr i hg) k
  mul g hg h hh := by
    have hb : maxCost R (g * h) ≤ maxCost R g + maxCost R h := by
      classical
      apply Finset.sup_le
      intro i _
      exact (singleCost_mul (derived_inclusion_of_pow hs hp r hr i hg)
        (derived_inclusion_of_pow hs hp r hr i hh)).trans
          (Nat.add_le_add (single_le_max R i g) (single_le_max R i h))
    exact_mod_cast hb

section EndpointDepth

variable {H : Type w} [Group H] [Fintype H] {X : Type v}
  [Fintype X] [MulAction H X] [Fintype I]

theorem endpoint_bridge_depth (N : Subgroup G) [N.Normal]
    (A : Set (I → G)) (hs : 2 ≤ Fintype.card I) (hp : PairHyp (copyGrading A) N)
    (r : ℕ) (hr : Fintype.card I - 1 ≤ 2 ^ r)
    (seed : X → G) (hseed : ∀ a, At (H := H) N a seed)
    (f g : I → X) (hfg : ∀ i, Related (H := H) (f i) (g i))
    (hf : ∀ h : H, (fun i => seed (h • f i)) ∈ A)
    (q δ : ℝ) (hq : 0 < q) (hδ : 0 < δ) :
    ∃ w m u v a b,
      PermRep (H := H) seed w m ∧ 0 < m ∧ CopyRep A u a ∧ CopyRep A v b ∧
      (∀ x, AtBound (H := H) (depthCost hs hp r hr) δ m x w) ∧
      (fun i => w (f i)) * u = (fun i => w (g i)) * v ∧
      (a + b : ℝ) ≤ Fintype.card I * δ * m ∧
      WeightedPath A (scaledCopies (H := H) seed g) q
        ((fun i => w (f i)) * u) ((m : ℝ) + a) ∧
      WeightedPath A (scaledCopies (H := H) seed g) q
        ((fun i => w (g i)) * v) (q * m + b) ∧
      0 < (m : ℝ) + a ∧ 0 ≤ q * m + b ∧
      (q * m + b) / ((m : ℝ) + a) ≤ q + Fintype.card I * δ := by
  classical
  let R := copyGrading A
  let L := derived N r
  let c : InvariantCost L := depthCost hs hp r hr
  obtain ⟨w, m, hw, hm, hall⟩ := simultaneous_averaging N seed hseed r c δ hδ
  let Dp : I → G := fun i => w (f i)
  let Dm : I → G := fun i => w (g i)
  let z : I → G := Dp⁻¹ * Dm
  have hz : ∀ i, z i ∈ L ∧ c.val (z i) ≤ δ * m := by
    intro i
    obtain ⟨hd, hcd⟩ := hall (f i) (f i) (g i) (related_refl _) (hfg i)
    let d := w (f i) * (w (g i))⁻¹
    have hdinv := L.inv_mem hd
    have hc := (inferInstance : L.Normal).conj_mem d⁻¹ hdinv (w (f i))⁻¹
    have he : z i = (w (f i))⁻¹ * d⁻¹ * ((w (f i))⁻¹)⁻¹ := by
      dsimp [z, Dp, Dm, d]
      group
    refine ⟨by rwa [he], ?_⟩
    rw [he, c.conj _ hdinv, c.inv _ hd]
    exact hcd
  have hsingle : ∀ i, z i ∈ supportedSubgroup R i :=
    fun i => derived_inclusion_of_pow hs hp r hr i (hz i).1
  have hsum : ((∑ i, singleCost R i (z i) : ℕ) : ℝ) ≤ Fintype.card I * δ * m := by
    calc
      ((∑ i, singleCost R i (z i) : ℕ) : ℝ) =
          ∑ i, (singleCost R i (z i) : ℝ) := by simp
      _ ≤ ∑ _i : I, δ * m := by
        apply Finset.sum_le_sum
        intro i _
        have hle : (singleCost R i (z i) : ℝ) ≤ c.val (z i) := by
          change (singleCost R i (z i) : ℝ) ≤ (maxCost R (z i) : ℝ)
          exact_mod_cast single_le_max R i (z i)
        exact hle.trans (hz i).2
      _ = Fintype.card I * δ * m := by simp; ring
  obtain ⟨u, v, a, b, hu, hv, he, hab⟩ := tuple_fraction R z hsingle
  change CopyRep A u a at hu
  change CopyRep A v b at hv
  have hbudget : (a + b : ℝ) ≤ Fintype.card I * δ * m := by
    have hab' : (a : ℝ) + b = ((∑ i, singleCost R i (z i) : ℕ) : ℝ) := by
      exact_mod_cast hab
    rwa [hab']
  have hend : Dp * u = Dm * v := by
    calc
      Dp * u = Dp * (u * v⁻¹) * v := by group
      _ = Dp * z * v := by rw [he]
      _ = Dm * v := by dsimp [z]; group
  have hplus : WeightedPath A (scaledCopies (H := H) seed g) q Dp (m : ℝ) := by
    simpa [Dp] using perm_path hw f (fun h =>
      WeightedPath.unit (T := scaledCopies (H := H) seed g) (q := q) _ (hf h))
  have hminus : WeightedPath A (scaledCopies (H := H) seed g) q Dm (q * m) :=
    perm_path hw g (fun h => WeightedPath.scaled _ (Set.mem_range_self h))
  refine ⟨w, m, u, v, a, b, hw, hm, hu, hv, hall, hend, hbudget,
    WeightedPath.mul hplus (copy_path hu), WeightedPath.mul hminus (copy_path hv), ?_⟩
  exact weight_bound _ _ _ _ q δ (by positivity) (by exact_mod_cast hm)
    (by positivity) (by positivity) hq hδ hbudget

end EndpointDepth

#print axioms actual_right_fraction
#print axioms lower_inclusion
#print axioms derived_le_lower_pow
#print axioms endpoint_bridge_depth

end LowerCentralBridge
