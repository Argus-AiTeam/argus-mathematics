namespace QuantitativeProfile

noncomputable section
open scoped Classical
open OAI.Paper320

theorem constructed_majorants {M r : ℕ} (d : ℕ) (T : RegularTournament M)
    (A : GoodLabeling T.toTournament r) (hr : 0 < r) :
    ∀ n ≤ d,
      towerSide T.toTournament A.label (constructionBase d M) (d + 1) n false ≤
        (raw (d + 2) M r n).s0 ∧
      towerSide T.toTournament A.label (constructionBase d M) (d + 1) n true ≤
        (raw (d + 2) M r n).s1 ∧
      towerJoint T.toTournament A.label (constructionBase d M) (d + 1) n false ≤
        (raw (d + 2) M r n).j0 ∧
      towerJoint T.toTournament A.label (constructionBase d M) (d + 1) n true ≤
        (raw (d + 2) M r n).j1 := by
  have hstep (n : ℕ) (hn : n < d) := tower_four_recurrences T A (constructionBase d M)
    (d + 1) n (by omega) hr (construction_base_nested d M)
  apply raw_majorizes d (d + 2) M r
    (towerSide T.toTournament A.label (constructionBase d M) (d + 1))
    (towerJoint T.toTournament A.label (constructionBase d M) (d + 1))
  · simpa only [towerSide_zero, constructionBase, baseExtension_same] using initialFamily_side_zero d M
  · simpa only [towerSide_zero, constructionBase, baseExtension_same] using initialFamily_side_one d M
  · simpa only [towerJoint_zero, constructionBase, baseExtension_same] using initialFamily_joint d M false
  · simpa only [towerJoint_zero, constructionBase, baseExtension_same] using initialFamily_joint d M true
  · exact fun n hn => (hstep n hn).2.2.1
  · exact fun n hn => (hstep n hn).1
  · exact fun n hn => (hstep n hn).2.2.2
  · exact fun n hn => (hstep n hn).2.1

theorem actual_uniform_profiles (h : ℕ) (hh : 1 ≤ h)
    (T : RegularTournament (mDepth h)) (A : GoodLabeling T.toTournament (rDepth h))
    (n : ℕ) (hn : n ≤ 2 * h) :
    towerSide T.toTournament A.label (constructionBase (2 * h) (mDepth h))
        (2 * h + 1) n false ≤ 2 * (2 * h + 2) * mDepth h ^ n ∧
    towerSide T.toTournament A.label (constructionBase (2 * h) (mDepth h))
        (2 * h + 1) n true ≤ 2 * (2 * h + 2) * mDepth h ^ (n + 1) := by
  have hr : 0 < rDepth h := by dsimp [rDepth]; positivity
  have hc := constructed_majorants (2 * h) T A hr n hn
  have hb := raw_even_bound h (2 * h + 2) n hh hn
  exact ⟨hc.1.trans hb.1, hc.2.1.trans hb.2⟩

theorem improved_construction_labels (h : ℕ) :
    Nonempty (GoodLabeling (regularCyclicTournament (mDepth h)).toTournament (rDepth h)) := by
  have hp : 0 < 3 ^ (2 * h) := by positivity
  have hM : 3 ≤ mDepth h := by dsimp [mDepth]; omega
  exact goodLabeling_exists hM
    (le_of_eq (depth_parameter_identities h).2.2.symm) _

theorem construction_label_count (h : ℕ) :
    Nat.ceil (Real.sqrt (mDepth h : ℝ)) = rDepth h := by
  have he : (mDepth h : ℝ) = (rDepth h : ℝ) ^ 2 := by
    exact_mod_cast (depth_parameter_identities h).2.2.symm
  rw [he, Real.sqrt_sq (by positivity), Nat.ceil_natCast]

theorem seed_exists :
    ∃ (n : ℕ) (f : (Fin n → Bool) → Bool),
      0 < n ∧ f (fun _ => false) = false ∧ sensitivity f ≤ seedA ∧
        seedB ≤ blockSensitivityAt f (fun _ => false) ∧
        (∃ x y, f x ≠ f y) := by
  obtain ⟨A⟩ := improved_construction_labels 10
  let T := regularCyclicTournament seedM
  have hr : 0 < seedR := by norm_num [seedR, rDepth]
  have hm : 0 < seedM := by norm_num [seedM, mDepth]
  let f := finalWitness 20 T A
  have hc := constructed_majorants 20 T A hr 20 (le_refl _)
  have h0 : ∀ x, terminalPredicate 20 T A x = false →
      sensitivityAt (terminalPredicate 20 T A) x ≤ (raw 22 seedM seedR 20).s0 := by
    intro x hx
    exact (sensitivityAt_le_sideSensitivity _ false 0 x hx).trans hc.1
  have h1 : ∀ x, terminalPredicate 20 T A x = true →
      sensitivityAt (terminalPredicate 20 T A) x ≤ (raw 22 seedM seedR 20).s1 := by
    intro x hx
    exact (sensitivityAt_le_sideSensitivity _ true 0 x hx).trans hc.2.1
  have hs : sensitivity f ≤ seedA := by
    dsimp only [f]
    rw [finalWitness, sensitivity_reindex]
    have ho := sensitivity_orCopies_le (K := Fin seedM) (terminalPredicate 20 T A) _ _ h0 h1
    have hmax : max (seedM * (raw 22 seedM seedR 20).s0)
        (raw 22 seedM seedR 20).s1 ≤ seedA := max_le seed_raw_bound.1 seed_raw_bound.2
    have ho' : sensitivity (finalBoolean 20 T A) ≤
        max (seedM * (raw 22 seedM seedR 20).s0) (raw 22 seedM seedR 20).s1 := by
      simpa only [Fintype.card_fin, finalBoolean] using ho
    exact ho'.trans hmax
  have hb : seedB ≤ blockSensitivityAt f (fun _ => false) :=
    finalWitness_blockSensitivity 20 T A hr
  have hbpos : 0 < seedB := by dsimp [seedB]; positivity
  exact ⟨_, f, constructionDimension_pos hm hr, finalWitness_zero 20 T A hr,
    hs, hb, nonconstant_of_blockSensitivityAt_pos f _ (hbpos.trans_le hb)⟩

set_option maxRecDepth 8192 in
theorem rational_exponent_of_integer {a b : ℕ} (h : a ^ 161 ≤ b ^ 80) :
    (a : ℝ) ^ ((161 : ℝ) / 80) ≤ (b : ℝ) := by
  have hr : (a : ℝ) ^ 161 ≤ (b : ℝ) ^ 80 := by exact_mod_cast h
  have ht := Real.rpow_le_rpow (by positivity : 0 ≤ (a : ℝ) ^ 161) hr
    (by norm_num : 0 ≤ (1 : ℝ) / 80)
  rw [← Real.rpow_natCast_mul (by positivity : 0 ≤ (a : ℝ)),
    ← Real.rpow_natCast_mul (by positivity : 0 ≤ (b : ℝ))] at ht
  norm_num at ht
  exact ht

theorem infinite_family_161_80 :
    ∃ N : ℕ, 0 < N ∧
      ∃ (n : ℕ → ℕ) (F : ∀ m : ℕ, (Fin (n m) → Bool) → Bool),
        (∀ m : ℕ, n m = N ^ m ∧ 0 < n m ∧
          F m (fun _ => false) = false ∧
          (∃ x y, F m x ≠ F m y) ∧
          (sensitivity (F m) : ℝ) ^ ((161 : ℝ) / 80) ≤
            (blockSensitivityAt (F m) (fun _ => false) : ℝ)) ∧
        Filter.Tendsto
          (fun m : ℕ => (blockSensitivityAt (F m) (fun _ => false) : ℝ))
          Filter.atTop Filter.atTop := by
  obtain ⟨N, f, hN, hf, hs, hb, _⟩ := seed_exists
  have hB : 1 < seedB := by norm_num [seedB, seedM, mDepth]
  have hpos : 0 < blockSensitivityAt f (fun _ => false) :=
    (by omega : 0 < seedB).trans_le hb
  have hs' (m : ℕ) : sensitivity (iterateFin f m) ≤ seedA ^ m := by
    exact (sensitivity_iterateFin_le f m).trans (by gcongr)
  have hb' (m : ℕ) : seedB ^ m ≤ blockSensitivityAt (iterateFin f m) (fun _ => false) := by
    exact (show seedB ^ m ≤ blockSensitivityAt f (fun _ => false) ^ m by gcongr).trans
      (blockSensitivityAt_iterateFin_zero f hf m)
  have hpower (m : ℕ) :
      sensitivity (iterateFin f m) ^ 161 ≤
        blockSensitivityAt (iterateFin f m) (fun _ => false) ^ 80 := by
    calc
      _ ≤ (seedA ^ m) ^ 161 := by gcongr; exact hs' m
      _ = (seedA ^ 161) ^ m := by rw [← pow_mul, ← pow_mul, Nat.mul_comm m 161]
      _ ≤ (seedB ^ 80) ^ m := Nat.pow_le_pow_left seed_integer_exponent m
      _ = (seedB ^ m) ^ 80 := by rw [← pow_mul, ← pow_mul, Nat.mul_comm 80 m]
      _ ≤ _ := by gcongr; exact hb' m
  have hlimit : Filter.Tendsto
      (fun m : ℕ => (blockSensitivityAt (iterateFin f m) (fun _ => false) : ℝ))
      Filter.atTop Filter.atTop := by
    apply Filter.tendsto_atTop_mono
      (fun m => (show (seedB : ℝ) ^ m ≤
        (blockSensitivityAt (iterateFin f m) (fun _ => false) : ℝ) by exact_mod_cast hb' m))
    exact tendsto_pow_atTop_atTop_of_one_lt (by exact_mod_cast hB)
  refine ⟨N, hN, (fun m => Fintype.card (Fin N) ^ m), (fun m => iterateFin f m),
    ?_, hlimit⟩
  intro m
  refine ⟨by simp, by simpa using pow_pos hN m, iterateFin_zero f hf m,
    iterateFin_nonconstant f hf hpos m, rational_exponent_of_integer (hpower m)⟩

end

end QuantitativeProfile

#print axioms QuantitativeProfile.uniform_profiles
#print axioms QuantitativeProfile.actual_uniform_profiles
#print axioms QuantitativeProfile.seed_exists
#print axioms QuantitativeProfile.infinite_family_161_80
