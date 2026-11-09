import Mathlib

open scoped BigOperators
open Finset

namespace FourierAudit

section OrderedAlgebra

variable {R : Type*} [Ring R] [StarRing R]

theorem defect_telescope (W : R) (L : ℕ) :
    ∑ j ∈ range L, W ^ j * (1 - W * star W) * star W ^ j =
      1 - W ^ L * star W ^ L := by
  induction L with
  | zero => simp
  | succ L ih =>
      rw [sum_range_succ, ih, pow_succ W L, pow_succ' (star W) L]
      noncomm_ring

theorem forward_defect (D Z : R) (hZ : Z * star Z = 1) :
    1 - D * star D = 1 - (D * Z) * star (D * Z) := by
  simp only [star_mul, mul_assoc]
  rw [← mul_assoc Z, hZ]
  simp

theorem backward_defect (D Z : R) (hZ : star Z * Z = 1) :
    star Z * (1 - star D * D) * Z =
      1 - (star Z * star D) * star (star Z * star D) := by
  simp only [star_mul, star_star]
  noncomm_ring [hZ]

theorem forward_gram_defect (D Z : R) (L : ℕ) (hZ : Z * star Z = 1) :
    Z * (∑ j ∈ range L, (D * Z) ^ j * (1 - D * star D) * star (D * Z) ^ j) *
        star Z =
      1 - Z * (D * Z) ^ L * star (D * Z) ^ L * star Z := by
  rw [forward_defect D Z hZ, defect_telescope]
  noncomm_ring [hZ]

theorem backward_gram_defect (D Z : R) (L : ℕ) (hZ : star Z * Z = 1) :
    (∑ j ∈ range L,
      (star Z * star D) ^ j * (star Z * (1 - star D * D) * Z) *
        star (star Z * star D) ^ j) =
      1 - (star Z * star D) ^ L * star (star Z * star D) ^ L := by
  rw [backward_defect D Z hZ, defect_telescope]

end OrderedAlgebra

section OrthogonalCoefficients

variable {J I : Type*} [Fintype J] [Fintype I] [DecidableEq I]

omit [Fintype I] in
theorem orthogonal_pair (u : J → I → ℂ)
    (hu : ∀ i j, ∑ z, u z i * star (u z j) = if i = j then 1 else 0)
    (i j : I) (a b : ℂ) :
    (∑ z, (u z i * a) * star (u z j * b)) =
      if i = j then a * star b else 0 := by
  calc
    _ = (∑ z, u z i * star (u z j)) * (a * star b) := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro z _
      simp only [star_mul]
      ring
    _ = _ := by rw [hu]; split_ifs <;> simp

theorem orthogonal_gram (u : J → I → ℂ)
    (hu : ∀ i j, ∑ z, u z i * star (u z j) = if i = j then 1 else 0)
    (a b : I → ℂ) :
    (∑ z, (∑ i, u z i * a i) * star (∑ i, u z i * b i)) =
      ∑ i, a i * star (b i) := by
  simp only [star_sum, Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_comm]
  simp_rw [orthogonal_pair u hu]
  simp

end OrthogonalCoefficients

section FeedbackAlgebra

variable {P Q : Type*} [Fintype P] [Fintype Q] [DecidableEq P] [DecidableEq Q]

theorem feedback_from_conservation
    (V : Matrix Q Q ℂ) (E O : Matrix Q P ℂ) (F H : Matrix P P ℂ)
    (hV : V.conjTranspose * V = 1) (hVE : V * E = O)
    (hE : E.conjTranspose * E = 1 + H)
    (hO : O.conjTranspose * O = F.conjTranspose * F + H) :
    F.conjTranspose * F = 1 ∧ F * F.conjTranspose = 1 ∧
      F * E.conjTranspose = (O * F.conjTranspose).conjTranspose * V := by
  have hGram : O.conjTranspose * O = E.conjTranspose * E := by
    calc
      _ = (V * E).conjTranspose * (V * E) := by rw [hVE]
      _ = E.conjTranspose * (V.conjTranspose * V) * E := by
        simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
      _ = _ := by rw [hV, Matrix.mul_one]
  have hF : F.conjTranspose * F = 1 := by
    apply add_right_cancel (b := H)
    rw [← hO, hGram, hE]
  refine ⟨hF, mul_eq_one_comm.mp hF, ?_⟩
  calc
    F * E.conjTranspose = F * (E.conjTranspose * (V.conjTranspose * V)) := by
      rw [hV, Matrix.mul_one]
    _ = F * ((V * E).conjTranspose * V) := by
      simp only [Matrix.conjTranspose_mul, Matrix.mul_assoc]
    _ = (O * F.conjTranspose).conjTranspose * V := by
      simp only [hVE, Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose,
        Matrix.mul_assoc]

end FeedbackAlgebra

section BlockFeedback

variable {P S : Type*} [Fintype P] [Fintype S] [DecidableEq P] [DecidableEq S]

theorem block_feedback_algebra
    (A : Matrix P P ℂ) (B : Matrix P S ℂ) (C : Matrix S P ℂ)
    (D Z : Matrix S S ℂ) (X : Matrix S P ℂ)
    (hV : (Matrix.fromBlocks A B C D).conjTranspose *
      Matrix.fromBlocks A B C D = 1)
    (hZ : Z.conjTranspose * Z = 1)
    (hX : C + D * Z * X = X) :
    let F := A + B * Z * X
    let E := Matrix.fromRows (1 : Matrix P P ℂ) (Z * X)
    let R := Matrix.fromRows (1 : Matrix P P ℂ) (X * F.conjTranspose)
    F.conjTranspose * F = 1 ∧ F * F.conjTranspose = 1 ∧
      F * E.conjTranspose = R.conjTranspose * Matrix.fromBlocks A B C D ∧
      B.conjTranspose + D.conjTranspose * (X * F.conjTranspose) =
        Z * (X * F.conjTranspose) := by
  let V := Matrix.fromBlocks A B C D
  let F := A + B * Z * X
  let E := Matrix.fromRows (1 : Matrix P P ℂ) (Z * X)
  let O := Matrix.fromRows F X
  let R := Matrix.fromRows (1 : Matrix P P ℂ) (X * F.conjTranspose)
  have hVE : V * E = O := by
    dsimp [V, E, O, F]
    rw [Matrix.fromBlocks_mul_fromRows]
    simp only [Matrix.mul_one, ← Matrix.mul_assoc, hX]
  have hE : E.conjTranspose * E = 1 + X.conjTranspose * X := by
    dsimp [E]
    rw [Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
      Matrix.fromCols_mul_fromRows, Matrix.conjTranspose_one, Matrix.one_mul,
      Matrix.conjTranspose_mul, Matrix.mul_assoc,
      ← Matrix.mul_assoc Z.conjTranspose Z X, hZ, Matrix.one_mul]
  have hO : O.conjTranspose * O =
      F.conjTranspose * F + X.conjTranspose * X := by
    dsimp [O]
    rw [Matrix.conjTranspose_fromRows_eq_fromCols_conjTranspose,
      Matrix.fromCols_mul_fromRows]
  have hf := feedback_from_conservation V E O F (X.conjTranspose * X) hV hVE hE hO
  have hR : O * F.conjTranspose = R := by
    dsimp [O, R]
    rw [Matrix.fromRows_mul, hf.2.1]
  have hVO : V.conjTranspose * O = E := by
    rw [← hVE, ← Matrix.mul_assoc, hV, Matrix.one_mul]
  have hVR : V.conjTranspose * R = E * F.conjTranspose := by
    rw [← hR, ← Matrix.mul_assoc, hVO]
  have hback : B.conjTranspose + D.conjTranspose * (X * F.conjTranspose) =
      Z * (X * F.conjTranspose) := by
    ext i j
    have hb := congrArg (fun M : Matrix (P ⊕ S) P ℂ => M (Sum.inr i) j) hVR
    simpa only [V, R, E, Matrix.fromBlocks_conjTranspose,
      Matrix.fromBlocks_mul_fromRows, Matrix.fromRows_mul, Matrix.mul_one,
      Matrix.fromRows_apply_inr, Matrix.mul_assoc] using hb
  exact ⟨hf.1, hf.2.1, by simpa only [hR] using hf.2.2, hback⟩

omit [Fintype P] [DecidableEq P] in
theorem backward_resolvent_algebra
    (D Z T : Matrix S S ℂ) (B : Matrix P S ℂ) (Y : Matrix S P ℂ)
    (hZ : Z.conjTranspose * Z = 1)
    (hY : B.conjTranspose + D.conjTranspose * Y = Z * Y)
    (hT : T * (1 - Z.conjTranspose * D.conjTranspose) = 1) :
    Y = T * Z.conjTranspose * B.conjTranspose := by
  have hsys : (1 - Z.conjTranspose * D.conjTranspose) * Y =
      Z.conjTranspose * B.conjTranspose := by
    rw [Matrix.sub_mul, Matrix.one_mul]
    apply (sub_eq_iff_eq_add).mpr
    have h := congrArg (fun M => Z.conjTranspose * M) hY
    simpa only [Matrix.mul_add, ← Matrix.mul_assoc, hZ, Matrix.one_mul] using h.symm
  calc
    Y = 1 * Y := (Matrix.one_mul Y).symm
    _ = (T * (1 - Z.conjTranspose * D.conjTranspose)) * Y := by rw [hT]
    _ = T * Z.conjTranspose * B.conjTranspose := by
      rw [Matrix.mul_assoc, hsys, ← Matrix.mul_assoc]

end BlockFeedback

section PowerSums

def fieldPowerSum {K : Type*} [CommSemiring K] (s : Multiset K) (j : ℕ) : K :=
  (s.map (fun x => x ^ j)).sum

theorem multiset_newton {K : Type*} [CommRing K] (s : Multiset K) (j : ℕ) :
    (j : K) * s.esymm j =
      (-1) ^ (j + 1) *
        ∑ a ∈ (Finset.antidiagonal j).filter (fun a => a.1 < j),
          (-1) ^ a.1 * s.esymm a.1 * fieldPowerSum s a.2 := by
  classical
  have hsum (k : ℕ) : (∑ x : s, (x : K) ^ k) = fieldPowerSum s k := by
    simpa only [Finset.sum_map_val, fieldPowerSum] using
      congrArg Multiset.sum (Multiset.map_univ s (fun x : K => x ^ k))
  have h := congrArg (MvPolynomial.aeval (R := K) (fun x : s => (x : K)))
    (MvPolynomial.mul_esymm_eq_sum s K j)
  simpa only [map_mul, map_pow, map_neg, map_one, map_natCast, map_sum,
    MvPolynomial.aeval_esymm_eq_multiset_esymm, Multiset.map_univ_coe,
    MvPolynomial.psum, MvPolynomial.aeval_X, hsum] using h

theorem power_sums_determine_multiset
    {K : Type*} [Field K]
    (s t : Multiset K) (L : ℕ) (hcard : s.card = t.card)
    (hsize : s.card ≤ L)
    (hchar : ∀ j, 1 ≤ j → j ≤ L → (j : K) ≠ 0)
    (hp : ∀ j, 1 ≤ j → j ≤ L → fieldPowerSum s j = fieldPowerSum t j) :
    s = t := by
  classical
  have he : ∀ j, j ≤ L → s.esymm j = t.esymm j := by
    intro j
    induction j using Nat.strong_induction_on with
    | h j ih =>
        intro hj
        by_cases hzero : j = 0
        · subst j
          simp [Multiset.esymm]
        have hcast : (j : K) ≠ 0 := hchar j (by omega) hj
        apply mul_left_cancel₀ hcast
        rw [multiset_newton, multiset_newton]
        congr 1
        apply Finset.sum_congr rfl
        intro a ha
        obtain ⟨ha, hlt⟩ := Finset.mem_filter.mp ha
        have hab := Finset.mem_antidiagonal.mp ha
        rw [ih a.1 hlt (by omega), hp a.2 (by omega) (by omega)]
  have hprod :
      (s.map (fun x => Polynomial.X - Polynomial.C x)).prod =
        (t.map (fun x => Polynomial.X - Polynomial.C x)).prod := by
    rw [Multiset.prod_X_sub_X_eq_sum_esymm, Multiset.prod_X_sub_X_eq_sum_esymm,
      ← hcard]
    apply Finset.sum_congr rfl
    intro j hj
    rw [he j (by have := Finset.mem_range.mp hj; omega)]
  have hr := congrArg Polynomial.roots hprod
  simpa only [Polynomial.roots_multiset_prod_X_sub_C] using hr

def naturalPowerSum (s : Multiset ℕ) (j : ℕ) : ℕ :=
  (s.map (fun x => x ^ j)).sum

theorem cast_naturalPowerSum (s : Multiset ℕ) (j : ℕ) :
    fieldPowerSum (s.map (fun x : ℕ => (x : ℚ))) j =
      (naturalPowerSum s j : ℚ) := by
  simp [fieldPowerSum, naturalPowerSum, Multiset.map_map, Nat.cast_multiset_sum]

def frequency (N L : ℕ) (s : Multiset ℕ) : Fin (L + 1) → ZMod N :=
  fun j => (naturalPowerSum s j.val : ZMod N)

theorem bounded_frequency_injective
    (N L : ℕ) (s t : Multiset ℕ) (hs : s.card ≤ L) (_ht : t.card ≤ L)
    (hbs : ∀ j, j ≤ L → naturalPowerSum s j < N)
    (hbt : ∀ j, j ≤ L → naturalPowerSum t j < N)
    (hfreq : frequency N L s = frequency N L t) : s = t := by
  have hp : ∀ j, j ≤ L → naturalPowerSum s j = naturalPowerSum t j := by
    intro j hj
    have h := congrArg ZMod.val (congrFun hfreq ⟨j, by omega⟩)
    change (naturalPowerSum s j : ZMod N).val =
      (naturalPowerSum t j : ZMod N).val at h
    simpa only [ZMod.val_natCast_of_lt (hbs j hj),
      ZMod.val_natCast_of_lt (hbt j hj)] using h
  have hc : s.card = t.card := by
    simpa [naturalPowerSum] using hp 0 (Nat.zero_le L)
  have hQ : s.map (fun x : ℕ => (x : ℚ)) = t.map (fun x : ℕ => (x : ℚ)) := by
    apply power_sums_determine_multiset _ _ L
    · simpa using hc
    · simpa using hs
    · intro j hj _
      exact_mod_cast (show j ≠ 0 by omega)
    · intro j _ hj
      rw [cast_naturalPowerSum, cast_naturalPowerSum, hp j hj]
  exact Multiset.map_injective (fun a b h => Nat.cast_injective h) hQ

theorem power_sum_bound
    (s : Multiset ℕ) (S L j : ℕ) (hS : 1 ≤ S)
    (hs : s.card ≤ L) (hi : ∀ i ∈ s, i ≤ S) (hj : j ≤ L) :
    naturalPowerSum s j ≤ L * S ^ L := by
  have hb : ∀ x ∈ s.map (fun x => x ^ j), x ≤ S ^ L := by
    intro x hx
    obtain ⟨i, his, rfl⟩ := Multiset.mem_map.mp hx
    exact (Nat.pow_le_pow_left (hi i his) j).trans (Nat.pow_le_pow_right hS hj)
  calc
    naturalPowerSum s j ≤ (s.map (fun x => x ^ j)).card • S ^ L :=
      Multiset.sum_le_card_nsmul _ _ hb
    _ = s.card * S ^ L := by simp
    _ ≤ L * S ^ L := Nat.mul_le_mul_right _ hs

theorem manuscript_no_wrap
    (s : Multiset ℕ) (n L j : ℕ) (hs : s.card ≤ L)
    (hi : ∀ i ∈ s, i ≤ 2 ^ n) (hj : j ≤ L) :
    naturalPowerSum s j < 2 ^ (n * L + Nat.clog 2 (L + 1)) := by
  have hb := power_sum_bound s (2 ^ n) L j (Nat.one_le_pow n 2 (by decide)) hs hi hj
  have hL : L < 2 ^ Nat.clog 2 (L + 1) :=
    lt_of_lt_of_le (Nat.lt_succ_self L) (Nat.le_pow_clog (by decide) (L + 1))
  calc
    naturalPowerSum s j ≤ L * (2 ^ n) ^ L := hb
    _ < 2 ^ Nat.clog 2 (L + 1) * (2 ^ n) ^ L :=
      Nat.mul_lt_mul_of_pos_right hL (by positivity)
    _ = 2 ^ (n * L + Nat.clog 2 (L + 1)) := by
      rw [← pow_mul, mul_comm, ← pow_add]

def phaseCode (N L s : ℕ) (m : Multiset (Fin s)) : Fin (L + 1) → ZMod N :=
  frequency N L (m.map (fun i : Fin s => i.val + 1))

theorem manuscript_code_injective
    (n L s : ℕ) (hs : s ≤ 2 ^ n)
    (m t : Multiset (Fin s)) (hm : m.card ≤ L) (ht : t.card ≤ L)
    (hcode : phaseCode (2 ^ (n * L + Nat.clog 2 (L + 1))) L s m =
      phaseCode (2 ^ (n * L + Nat.clog 2 (L + 1))) L s t) : m = t := by
  have hb (u : Multiset (Fin s)) (hu : u.card ≤ L) :
      ∀ j, j ≤ L →
        naturalPowerSum (u.map (fun i : Fin s => i.val + 1)) j <
          2 ^ (n * L + Nat.clog 2 (L + 1)) := by
    intro j hj
    apply manuscript_no_wrap _ n L j (by simpa using hu) _ hj
    intro i hi
    obtain ⟨x, _, rfl⟩ := Multiset.mem_map.mp hi
    exact (Nat.succ_le_of_lt x.isLt).trans hs
  have hmap := bounded_frequency_injective
    (2 ^ (n * L + Nat.clog 2 (L + 1))) L
    (m.map (fun i : Fin s => i.val + 1)) (t.map (fun i : Fin s => i.val + 1))
    (by simpa using hm) (by simpa using ht) (hb m hm) (hb t ht) (by exact hcode)
  exact Multiset.map_injective (fun a b h => Fin.ext (by omega)) hmap

theorem prime_code_injective
    (p L s : ℕ) [Fact p.Prime] (hL : L < p) (hs : s < p)
    (m t : Multiset (Fin s)) (hm : m.card ≤ L) (ht : t.card ≤ L)
    (hcode : phaseCode p L s m = phaseCode p L s t) : m = t := by
  let label : Fin s → ZMod p := fun i => ((i.val + 1 : ℕ) : ZMod p)
  have hlabel : Function.Injective label := by
    intro a b hab
    have hv := congrArg ZMod.val hab
    change ((a.val + 1 : ℕ) : ZMod p).val =
      ((b.val + 1 : ℕ) : ZMod p).val at hv
    rw [ZMod.val_natCast_of_lt (by omega), ZMod.val_natCast_of_lt (by omega)] at hv
    exact Fin.ext (by omega)
  have hc : m.card = t.card := by
    have h0 := congrFun hcode ⟨0, by omega⟩
    have h0' : (m.card : ZMod p) = (t.card : ZMod p) := by
      simpa [phaseCode, frequency, naturalPowerSum] using h0
    have hv := congrArg ZMod.val h0'
    simpa only [ZMod.val_natCast_of_lt (hm.trans_lt hL),
      ZMod.val_natCast_of_lt (ht.trans_lt hL)] using hv
  have hsum (u : Multiset (Fin s)) (j : ℕ) :
      fieldPowerSum (u.map label) j =
        (naturalPowerSum (u.map (fun i : Fin s => i.val + 1)) j : ZMod p) := by
    simp [label, fieldPowerSum, naturalPowerSum, Multiset.map_map,
      Nat.cast_multiset_sum]
  have hmap : m.map label = t.map label := by
    apply power_sums_determine_multiset _ _ L
    · simpa using hc
    · simpa using hm
    · intro j hj hjL hzero
      have hv := congrArg ZMod.val hzero
      rw [ZMod.val_natCast_of_lt (hjL.trans_lt hL)] at hv
      have : j = 0 := by simpa using hv
      omega
    · intro j _ hj
      rw [hsum, hsum]
      exact congrFun hcode ⟨j, by omega⟩
  exact Multiset.map_injective hlabel hmap

theorem compact_code_exists (s L : ℕ) (hL : 1 ≤ L) :
    ∃ p, p.Prime ∧ max s L < p ∧ p ≤ 2 * max s L ∧
      ∀ m t : Multiset (Fin s), m.card ≤ L → t.card ≤ L →
        phaseCode p L s m = phaseCode p L s t → m = t := by
  obtain ⟨p, hp, hlow, hhigh⟩ :=
    Nat.exists_prime_lt_and_le_two_mul (max s L) (by omega)
  letI : Fact p.Prime := ⟨hp⟩
  exact ⟨p, hp, hlow, hhigh,
    prime_code_injective p L s ((le_max_right s L).trans_lt hlow)
      ((le_max_left s L).trans_lt hlow)⟩

end PowerSums

section PathSupport

variable {I F : Type*} [Fintype I] [DecidableEq I] [DecidableEq F]

def pathBag {m : ℕ} (p : Fin (m + 1) → I) : Multiset I :=
  Finset.univ.val.map p

def pathRow (code : Multiset I → F) (L : ℕ)
    (weight : (m : Fin L) → (Fin (m.val + 1) → I) → ℂ) (w : F) (i : I) : ℂ :=
  ∑ m : Fin L, ∑ p : Fin (m.val + 1) → I,
    if code (pathBag p) = w ∧ p ⟨m.val, by omega⟩ = i then weight m p else 0

theorem pathRow_support
    (code : Multiset I → F) (L : ℕ)
    (weight : (m : Fin L) → (Fin (m.val + 1) → I) → ℂ)
    (w : F) (i : I) (h : pathRow code L weight w i ≠ 0) :
    ∃ m : Multiset I, m.card ≤ L ∧ code m = w ∧ i ∈ m := by
  classical
  obtain ⟨m, _, hm⟩ := Finset.exists_ne_zero_of_sum_ne_zero h
  obtain ⟨p, _, hp⟩ := Finset.exists_ne_zero_of_sum_ne_zero hm
  have hcond : code (pathBag p) = w ∧ p ⟨m.val, by omega⟩ = i := by
    by_contra hn
    simp [hn] at hp
  refine ⟨pathBag p, ?_, hcond.1, ?_⟩
  · simp only [pathBag, Multiset.card_map, Finset.card_val, Finset.card_univ,
      Fintype.card_fin]
    omega
  · rw [← hcond.2]
    exact Multiset.mem_map_of_mem p (by simp)

omit [DecidableEq F] in
theorem unique_multiset_row_bound
    (code : Multiset I → F) (L : ℕ)
    (hinj : ∀ m t, m.card ≤ L → t.card ≤ L → code m = code t → m = t)
    (row : I → ℂ) (w : F)
    (hrow : ∀ i, row i ≠ 0 →
      ∃ m : Multiset I, m.card ≤ L ∧ code m = w ∧ i ∈ m) :
    (Finset.univ.filter (fun i => row i ≠ 0)).card ≤ L := by
  classical
  by_cases hex : ∃ m : Multiset I, m.card ≤ L ∧ code m = w
  · obtain ⟨m, hm, hmw⟩ := hex
    have hsub : (Finset.univ.filter (fun i => row i ≠ 0)) ⊆ m.toFinset := by
      intro i hi
      obtain ⟨t, ht, htw, hit⟩ := hrow i (Finset.mem_filter.mp hi).2
      have htm := hinj t m ht hm (htw.trans hmw.symm)
      simpa [htm] using hit
    exact (Finset.card_le_card hsub).trans ((Multiset.toFinset_card_le m).trans hm)
  · have hempty : Finset.univ.filter (fun i => row i ≠ 0) = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro i hi
      obtain ⟨m, hm, hw, _⟩ := hrow i (Finset.mem_filter.mp hi).2
      exact hex ⟨m, hm, hw⟩
    simp [hempty]

theorem pathRow_card_bound
    (code : Multiset I → F) (L : ℕ)
    (hinj : ∀ m t, m.card ≤ L → t.card ≤ L → code m = code t → m = t)
    (weight : (m : Fin L) → (Fin (m.val + 1) → I) → ℂ) (w : F) :
    (Finset.univ.filter (fun i => pathRow code L weight w i ≠ 0)).card ≤ L :=
  unique_multiset_row_bound code L hinj _ w (pathRow_support code L weight w)

theorem manuscript_pathRow_bound
    (n L s : ℕ) (hs : s ≤ 2 ^ n)
    (weight : (m : Fin L) → (Fin (m.val + 1) → Fin s) → ℂ)
    (w : Fin (L + 1) → ZMod (2 ^ (n * L + Nat.clog 2 (L + 1)))) :
    (Finset.univ.filter (fun i =>
      pathRow (phaseCode (2 ^ (n * L + Nat.clog 2 (L + 1))) L s)
        L weight w i ≠ 0)).card ≤ L :=
  pathRow_card_bound _ L (manuscript_code_injective n L s hs) weight w

variable {P : Type*} [Fintype P] [DecidableEq P] [Zero F]

def fullRow (code : Multiset I → F) (L : ℕ)
    (weight : (m : Fin L) → (Fin (m.val + 1) → I) → ℂ) (w : F) (a : P) :
    P ⊕ I → ℂ
  | Sum.inl j => if w = 0 ∧ a = j then 1 else 0
  | Sum.inr i => pathRow code L weight w i

theorem fullRow_card_bound
    (code : Multiset I → F) (L : ℕ) (hL : 1 ≤ L) (hzero : code 0 = 0)
    (hinj : ∀ m t, m.card ≤ L → t.card ≤ L → code m = code t → m = t)
    (weight : (m : Fin L) → (Fin (m.val + 1) → I) → ℂ) (w : F) (a : P) :
    (Finset.univ.filter (fun i => fullRow code L weight w a i ≠ 0)).card ≤ L := by
  classical
  by_cases hw : w = 0
  · have hinternal : ∀ i, pathRow code L weight w i = 0 := by
      intro i
      by_contra hi
      obtain ⟨m, hm, hmw, him⟩ := pathRow_support code L weight w i hi
      have hm0 : m = 0 := hinj m 0 hm (by simp) (hmw.trans (hw.trans hzero.symm))
      simp [hm0] at him
    have hsub : (Finset.univ.filter (fun i => fullRow code L weight w a i ≠ 0)) ⊆
        {Sum.inl a} := by
      intro i hi
      have hn := (Finset.mem_filter.mp hi).2
      cases i with
      | inl j =>
          simp only [fullRow, hw, true_and, ne_eq, ite_eq_right_iff, one_ne_zero,
            imp_false, not_not] at hn
          simp [hn]
      | inr i => exact False.elim (hn (hinternal i))
    exact (Finset.card_le_card hsub).trans (by simpa using hL)
  · let internal := Finset.univ.filter (fun i => pathRow code L weight w i ≠ 0)
    have hsub : (Finset.univ.filter (fun i => fullRow code L weight w a i ≠ 0)) ⊆
        internal.image (Sum.inr : I → P ⊕ I) := by
      intro i hi
      have hn := (Finset.mem_filter.mp hi).2
      cases i with
      | inl j => simp [fullRow, hw] at hn
      | inr i => exact Finset.mem_image.mpr ⟨i, by simpa [internal, fullRow] using hn, rfl⟩
    exact (Finset.card_le_card hsub).trans
      ((Finset.card_image_le).trans (pathRow_card_bound code L hinj weight w))

theorem manuscript_fullRow_bound
    (n L s : ℕ) (hs : s ≤ 2 ^ n) (hL : 1 ≤ L)
    (weight : (m : Fin L) → (Fin (m.val + 1) → Fin s) → ℂ)
    (w : Fin (L + 1) → ZMod (2 ^ (n * L + Nat.clog 2 (L + 1)))) (a : P) :
    let code := phaseCode (2 ^ (n * L + Nat.clog 2 (L + 1))) L s
    (Finset.univ.filter (fun i => fullRow code L weight w a i ≠ 0)).card ≤ L ∧
      (Finset.univ.filter (fun i => fullRow (fun m => -(code m)) L weight w a i ≠ 0)).card ≤ L := by
  dsimp only
  constructor
  · apply fullRow_card_bound _ L hL
    · ext j
      simp [phaseCode, frequency, naturalPowerSum]
    · exact manuscript_code_injective n L s hs
  · apply fullRow_card_bound _ L hL
    · ext j
      simp [phaseCode, frequency, naturalPowerSum]
    · intro m t hm ht hmt
      exact manuscript_code_injective n L s hs m t hm ht (neg_injective hmt)

theorem prime_fullRow_bound
    (p L s : ℕ) [Fact p.Prime] (hLp : L < p) (hsp : s < p) (hL : 1 ≤ L)
    (weight : (m : Fin L) → (Fin (m.val + 1) → Fin s) → ℂ)
    (w : Fin (L + 1) → ZMod p) (a : P) :
    (Finset.univ.filter (fun i =>
      fullRow (phaseCode p L s) L weight w a i ≠ 0)).card ≤ L ∧
      (Finset.univ.filter (fun i =>
        fullRow (fun m => -(phaseCode p L s m)) L weight w a i ≠ 0)).card ≤ L := by
  constructor
  · apply fullRow_card_bound _ L hL
    · ext j
      simp [phaseCode, frequency, naturalPowerSum]
    · exact prime_code_injective p L s hLp hsp
  · apply fullRow_card_bound _ L hL
    · ext j
      simp [phaseCode, frequency, naturalPowerSum]
    · intro m t hm ht hmt
      exact prime_code_injective p L s hLp hsp m t hm ht (neg_injective hmt)

end PathSupport

end FourierAudit

#print axioms FourierAudit.defect_telescope
#print axioms FourierAudit.forward_gram_defect
#print axioms FourierAudit.backward_gram_defect
#print axioms FourierAudit.orthogonal_gram
#print axioms FourierAudit.feedback_from_conservation
#print axioms FourierAudit.block_feedback_algebra
#print axioms FourierAudit.backward_resolvent_algebra
#print axioms FourierAudit.power_sums_determine_multiset
#print axioms FourierAudit.manuscript_fullRow_bound
#print axioms FourierAudit.prime_code_injective
#print axioms FourierAudit.compact_code_exists
#print axioms FourierAudit.prime_fullRow_bound
