import Mathlib

noncomputable section

open scoped BigOperators Pointwise
open Finset Matrix

set_option maxHeartbeats 800000

namespace LSLatticeGeometry

abbrev Z4 := Fin 4 → ℤ
abbrev E4 := EuclideanSpace ℝ (Fin 4)

def intBox (N : ℕ) : Finset Z4 :=
  Fintype.piFinset fun _ => Finset.Ico (0 : ℤ) (N : ℤ)

@[simp] theorem mem_intBox (N : ℕ) (n : Z4) :
    n ∈ intBox N ↔ ∀ i, 0 ≤ n i ∧ n i < (N : ℤ) := by
  simp [intBox, Fintype.mem_piFinset]

def enlargedBox (N : ℕ) : Finset Z4 := intBox (4 * (N - 1) + 1)

theorem mem_enlargedBox (N : ℕ) (n : Z4) :
    n ∈ enlargedBox N ↔
      ∀ i, 0 ≤ n i ∧ n i ≤ ((4 * (N - 1) : ℕ) : ℤ) := by
  simp only [enlargedBox, mem_intBox, Nat.cast_add, Nat.cast_one, Int.lt_add_one_iff]

def intDot (r n : Z4) : ℤ := ∑ i, r i * n i

def toE (n : Z4) : E4 := WithLp.toLp 2 fun i => (n i : ℝ)

@[simp] theorem toE_apply (n : Z4) (i : Fin 4) : toE n i = (n i : ℝ) := rfl

@[simp] theorem toE_add (a b : Z4) : toE (a + b) = toE a + toE b := by
  ext i
  simp [toE]

@[simp] theorem toE_sub (a b : Z4) : toE (a - b) = toE a - toE b := by
  ext i
  simp [toE]

theorem toE_injective : Function.Injective toE := by
  intro a b h
  funext i
  have hi : (a i : ℝ) = (b i : ℝ) := congrArg (fun x : E4 => x i) h
  exact_mod_cast hi

theorem isClosedEmbedding_toE : Topology.IsClosedEmbedding toE := by
  exact (PiLp.homeomorph 2 (fun _ : Fin 4 => ℝ)).symm.isClosedEmbedding.comp
    (Topology.IsClosedEmbedding.piMap fun _ : Fin 4 => Int.isClosedEmbedding_coe_real)

/-- Compactness of one factor and discreteness of the lattice give a global nearest pair. -/
theorem nearest_lattice_pair (K : Set E4) (hK : IsCompact K) (hKne : K.Nonempty)
    (F : Z4 → ℂ) (hF : ∃ m, F m ≠ 0) :
    ∃ (m : Z4) (y : E4), F m ≠ 0 ∧ y ∈ K ∧
      ∀ m' : Z4, F m' ≠ 0 → ∀ y' ∈ K, ‖toE m - y‖ ≤ ‖toE m' - y'‖ := by
  let T : Set E4 := toE '' {m | F m ≠ 0}
  have hT : IsClosed T :=
    isClosedEmbedding_toE.isClosedMap _ (isClosed_discrete _)
  have hTne : T.Nonempty := by
    obtain ⟨m, hm⟩ := hF
    exact ⟨toE m, m, hm, rfl⟩
  obtain ⟨y, hy, hmin⟩ :=
    hK.exists_isMinOn hKne (Metric.continuous_infDist_pt T).continuousOn
  obtain ⟨a, ha, hea⟩ := hT.exists_infDist_eq_dist hTne y
  obtain ⟨m, hm, rfl⟩ := ha
  refine ⟨m, y, hm, hy, ?_⟩
  intro m' hm' y' hy'
  rw [← dist_eq_norm, dist_comm (toE m) y, ← hea, ← dist_eq_norm,
    dist_comm (toE m') y']
  exact (hmin hy').trans
    (Metric.infDist_le_dist_of_mem (s := T) (x := y') (y := toE m') ⟨m', hm', rfl⟩)

theorem supporting_inequality {K : Set E4} (hK : Convex ℝ K)
    {a y : E4} (hy : y ∈ K)
    (hmin : ∀ z ∈ K, ‖a - y‖ ≤ ‖a - z‖) :
    ∀ z ∈ K, inner ℝ (a - y) (z - y) ≤ 0 := by
  letI : Nonempty K := ⟨⟨y, hy⟩⟩
  apply (norm_eq_iInf_iff_real_inner_le_zero hK hy).mp
  apply le_antisymm
  · exact le_ciInf fun z : K => hmin z z.property
  · exact ciInf_le (show BddBelow (Set.range fun z : K => ‖a - z‖) from
      ⟨0, by rintro _ ⟨z, rfl⟩; exact norm_nonneg _⟩) ⟨y, hy⟩

/-- An integral Gram matrix avoids any assumption that the real normal is rational. -/
theorem integer_normal_of_real_normal {ι : Type*} [Fintype ι]
    (A : Matrix ι (Fin 4) ℤ) (h : Fin 4 → ℝ) (hh : h ≠ 0)
    (hAh : (A.map (Int.castRingHom ℝ)).mulVec h = 0) :
    ∃ r : Z4, r ≠ 0 ∧ A.mulVec r = 0 := by
  classical
  let B : Matrix (Fin 4) (Fin 4) ℤ := A.transpose * A
  have hBh : (B.map (Int.castRingHom ℝ)).mulVec h = 0 := by
    simp only [B, Matrix.map_mul, Matrix.transpose_map, ← Matrix.mulVec_mulVec,
      hAh, Matrix.mulVec_zero]
  have hdetR : (B.map (Int.castRingHom ℝ)).det = 0 :=
    Matrix.exists_mulVec_eq_zero_iff.mp ⟨h, hh, hBh⟩
  have hdet : B.det = 0 := by
    change (B.map fun z : ℤ => (z : ℝ)).det = 0 at hdetR
    rw [← Int.cast_det] at hdetR
    exact_mod_cast hdetR
  obtain ⟨r, hr, hBr⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr hdet
  refine ⟨r, hr, ?_⟩
  have heq : A.transpose.mulVec (A.mulVec r) = 0 := by
    simpa only [B, Matrix.mulVec_mulVec] using hBr
  have hz := congrArg (dotProduct r) heq
  rwa [dotProduct_mulVec, dotProduct_zero, vecMul_transpose,
    dotProduct_self_eq_zero] at hz

def hull (S : Finset Z4) : Set E4 := convexHull ℝ (toE '' (S : Set Z4))

def fourHull (S : Finset Z4) : Set E4 := (4 : ℝ) • hull S

theorem toE_mem_hull {S : Finset Z4} {n : Z4} (hn : n ∈ S) : toE n ∈ hull S :=
  subset_convexHull ℝ _ ⟨n, hn, rfl⟩

theorem convex_fourHull (S : Finset Z4) : Convex ℝ (fourHull S) :=
  (convex_convexHull ℝ _).smul 4

theorem compact_fourHull (S : Finset Z4) : IsCompact (fourHull S) := by
  have hp : IsCompact (hull S) :=
    ((S.finite_toSet).image toE).isCompact_convexHull ℝ
  exact hp.image (continuous_const.smul continuous_id)

theorem nonempty_fourHull {S : Finset Z4} (hS : S.Nonempty) :
    (fourHull S).Nonempty := by
  obtain ⟨u, hu⟩ := hS
  exact ⟨4 • toE u, toE u, toE_mem_hull hu, rfl⟩

theorem hull_coordinate_bounds {N : ℕ} (hN : 1 ≤ N) {S : Finset Z4}
    (hS : S ⊆ intBox N) {x : E4} (hx : x ∈ hull S) :
    ∀ i, 0 ≤ x i ∧ x i ≤ ((N - 1 : ℕ) : ℝ) := by
  have hbox : Convex ℝ {x : E4 | ∀ i, 0 ≤ x i ∧ x i ≤ ((N - 1 : ℕ) : ℝ)} := by
    intro x hx y hy a b ha hb hab i
    change 0 ≤ a * x i + b * y i ∧
      a * x i + b * y i ≤ ((N - 1 : ℕ) : ℝ)
    constructor
    · exact add_nonneg (mul_nonneg ha (hx i).1) (mul_nonneg hb (hy i).1)
    · calc
        a * x i + b * y i ≤
            a * ((N - 1 : ℕ) : ℝ) + b * ((N - 1 : ℕ) : ℝ) :=
          add_le_add (mul_le_mul_of_nonneg_left (hx i).2 ha)
            (mul_le_mul_of_nonneg_left (hy i).2 hb)
        _ = ((N - 1 : ℕ) : ℝ) := by nlinarith [hab]
  apply convexHull_min (t := {x : E4 | ∀ i, 0 ≤ x i ∧ x i ≤ ((N - 1 : ℕ) : ℝ)})
    ?_ hbox hx
  rintro _ ⟨n, hn, rfl⟩ i
  have hi := (mem_intBox N n).mp (hS hn) i
  have hcast : ((N - 1 : ℕ) : ℤ) = (N : ℤ) - 1 := by
    rw [Nat.cast_sub hN]
    norm_num
  change 0 ≤ (n i : ℝ) ∧ (n i : ℝ) ≤ ((N - 1 : ℕ) : ℝ)
  constructor
  · exact_mod_cast hi.1
  · have hh : n i ≤ ((N - 1 : ℕ) : ℤ) := by omega
    exact_mod_cast hh

theorem integer_mem_fourHull {N : ℕ} (hN : 1 ≤ N) {S : Finset Z4}
    (hS : S ⊆ intBox N) {m : Z4} (hm : toE m ∈ fourHull S) :
    m ∈ enlargedBox N := by
  obtain ⟨p, hp, heq⟩ := hm
  rw [mem_enlargedBox]
  intro i
  have hip := hull_coordinate_bounds hN hS hp i
  have hieq : (m i : ℝ) = 4 * p i := by
    simpa only [toE_apply, PiLp.smul_apply, smul_eq_mul] using
      congrArg (fun x : E4 => x i) heq.symm
  constructor
  · have hi0 : (0 : ℝ) ≤ (m i : ℝ) := by linarith
    exact_mod_cast hi0
  · have hi1 : (m i : ℝ) ≤ ((4 * (N - 1) : ℕ) : ℝ) := by
      push_cast
      linarith
    exact_mod_cast hi1

theorem support_card_le_four {ι : Type*} [Fintype ι]
    (z : ι → E4) (hz : AffineIndependent ℝ z) (h : E4) (hh : h ≠ 0)
    (c : ℝ) (hface : ∀ i, inner ℝ h (z i) = c) : Fintype.card ι ≤ 4 := by
  classical
  rcases isEmpty_or_nonempty ι with hι | hι
  · letI := hι
    simp
  letI := hι
  let i₀ : ι := Classical.choice hι
  let W : Submodule ℝ E4 := (innerₗ E4 h).ker
  have hW : W ≠ ⊤ := by
    intro htop
    have hm : h ∈ W := by rw [htop]; trivial
    have hzero : inner ℝ h h = 0 := hm
    exact hh (inner_self_eq_zero.mp hzero)
  have hdim : Module.finrank ℝ W < 4 := by
    simpa [E4] using Submodule.finrank_lt hW
  have hspan : vectorSpan ℝ (Set.range z) ≤ W := by
    rw [vectorSpan_range_eq_span_range_vsub_right ℝ z i₀]
    apply Submodule.span_le.mpr
    rintro _ ⟨i, rfl⟩
    change inner ℝ h (z i - z i₀) = 0
    rw [inner_sub_right, hface i, hface i₀, sub_self]
  have hc := hz.card_le_finrank_succ.trans
    (Nat.add_le_add_right (Submodule.finrank_mono hspan) 1)
  omega

theorem exists_weight_ge_quarter {ι : Type*} [Fintype ι] (w : ι → ℝ)
    (hw : ∑ i, w i = 1) (hc : Fintype.card ι ≤ 4) :
    ∃ a, (1 / 4 : ℝ) ≤ w a := by
  classical
  obtain ⟨a, _, _⟩ := Finset.exists_ne_zero_of_sum_ne_zero
    (show (∑ i, w i) ≠ 0 by rw [hw]; norm_num)
  letI : Nonempty ι := ⟨a⟩
  by_contra! h
  have hlt : ∑ i, w i < ∑ _i : ι, (1 / 4 : ℝ) :=
    Finset.sum_lt_sum_of_nonempty Finset.univ_nonempty fun i _ => h i
  rw [hw, Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at hlt
  have hc' : (Fintype.card ι : ℝ) ≤ 4 := by exact_mod_cast hc
  nlinarith

theorem exchange_mem_four_smul {ι : Type*} [Fintype ι] {P : Set E4}
    (hP : Convex ℝ P) (z : ι → E4) (w : ι → ℝ)
    (hz : ∀ i, z i ∈ P) (hw₀ : ∀ i, 0 ≤ w i) (hw₁ : ∑ i, w i = 1)
    {p : E4} (hp : ∑ i, w i • z i = p) (a : ι) (ha : (1 / 4 : ℝ) ≤ w a)
    {n : E4} (hn : n ∈ P) :
    (4 : ℝ) • p + n - z a ∈ (4 : ℝ) • P := by
  classical
  let v : Option ι → ℝ := fun o => match o with
    | none => 1 / 4
    | some i => w i - if i = a then 1 / 4 else 0
  let q : Option ι → E4 := fun o => o.elim n z
  have hv₀ : ∀ o ∈ (univ : Finset (Option ι)), 0 ≤ v o := by
    intro o _
    cases o with
    | none => norm_num [v]
    | some i =>
      by_cases hi : i = a
      · simpa [v, hi] using (sub_nonneg.mpr ha)
      · simpa [v, hi] using hw₀ i
  have hv₁ : ∑ o, v o = 1 := by
    simp [Fintype.sum_option, v, Finset.sum_sub_distrib, hw₁]
  have hq : ∀ o ∈ (univ : Finset (Option ι)), q o ∈ P := by
    intro o _
    cases o with
    | none => exact hn
    | some i => exact hz i
  have hmem : ∑ o, v o • q o ∈ P := hP.sum_mem hv₀ hv₁ hq
  have hsum : ∑ o, v o • q o = (1 / 4 : ℝ) • n + (p - (1 / 4 : ℝ) • z a) := by
    simp [Fintype.sum_option, v, q, sub_smul, Finset.sum_sub_distrib, hp,
      ite_smul]
  refine ⟨∑ o, v o • q o, hmem, ?_⟩
  rw [hsum]
  simp only [smul_add, smul_sub, smul_smul]
  norm_num
  abel

theorem positive_convex_support {ι : Type*} [Fintype ι]
    (z : ι → E4) (w : ι → ℝ) (hw₀ : ∀ i, 0 < w i) (hw₁ : ∑ i, w i = 1)
    {p : E4} (hp : ∑ i, w i • z i = p) (h : E4)
    (hbound : ∀ i, inner ℝ h (z i) ≤ inner ℝ h p) :
    ∀ i, inner ℝ h (z i) = inner ℝ h p := by
  have hlin : ∑ i, w i * inner ℝ h (z i) = inner ℝ h p := by
    rw [← hp, inner_sum]
    simp only [inner_smul_right]
  have hsum : ∑ i, w i * (inner ℝ h p - inner ℝ h (z i)) = 0 := by
    simp_rw [mul_sub]
    rw [Finset.sum_sub_distrib, ← Finset.sum_mul, hw₁, one_mul, hlin, sub_self]
  have hall := (Finset.sum_eq_zero_iff_of_nonneg
    (fun i (_ : i ∈ (univ : Finset ι)) =>
      mul_nonneg (hw₀ i).le (sub_nonneg.mpr (hbound i)))).mp hsum
  intro i
  have heq := (mul_eq_zero.mp (hall i (mem_univ i))).resolve_left (ne_of_gt (hw₀ i))
  linarith

theorem integer_face_hyperplane (S : Finset Z4) (h : E4) (hh : h ≠ 0) (u : Z4) :
    ∃ r : Z4, r ≠ 0 ∧ ∀ n ∈ S,
      inner ℝ h (toE n) = inner ℝ h (toE u) → intDot r n = intDot r u := by
  classical
  let T := S.filter fun n => inner ℝ h (toE n) = inner ℝ h (toE u)
  let A : Matrix T (Fin 4) ℤ := fun n i => n.val i - u i
  have hh' : (fun i => h i) ≠ (0 : Fin 4 → ℝ) := by
    intro hz
    apply hh
    ext i
    exact congrFun hz i
  have hAh : (A.map (Int.castRingHom ℝ)).mulVec (fun i => h i) = 0 := by
    ext n
    have hnface := (Finset.mem_filter.mp n.property).2
    have hin : inner ℝ h (toE n.val - toE u) = 0 := by
      rw [inner_sub_right, hnface, sub_self]
    simpa [A, Matrix.mulVec, dotProduct, PiLp.inner_apply, toE, mul_comm] using hin
  obtain ⟨r, hr, hAr⟩ := integer_normal_of_real_normal A (fun i => h i) hh' hAh
  refine ⟨r, hr, ?_⟩
  intro n hn hface
  let nn : T := ⟨n, Finset.mem_filter.mpr ⟨hn, hface⟩⟩
  have hrn := congrFun hAr nn
  have heq : intDot r n - intDot r u = 0 := by
    simpa [A, nn, Matrix.mulVec, dotProduct, intDot, sub_mul, mul_sub,
      Finset.sum_sub_distrib, mul_comm] using hrn
  exact sub_eq_zero.mp heq

/-- The exact geometric interface used by the rectangular interpolation proof. -/
def LatticeFaceSelection : Prop :=
  ∀ (N : ℕ), 1 ≤ N →
    ∀ (S : Finset Z4), S.Nonempty → S ⊆ intBox N →
      ∀ (F : Z4 → ℂ), (∃ m, F m ≠ 0) →
        (∀ m ∈ enlargedBox N, F m = 0) →
        ∃ u ∈ S, ∃ (m r : Z4) (k : ℤ),
          r ≠ 0 ∧ intDot r u = k ∧ F m ≠ 0 ∧
            ∀ n ∈ S, intDot r n ≠ k → F (m + n - u) = 0

theorem latticeFaceSelection : LatticeFaceSelection := by
  classical
  intro N hN S hSne hS F hF hFzero
  obtain ⟨m, y, hm, hy, hmin⟩ :=
    nearest_lattice_pair (fourHull S) (compact_fourHull S) (nonempty_fourHull hSne) F hF
  have houtside : toE m ≠ y := by
    intro heq
    have hmK : toE m ∈ fourHull S := by rw [heq]; exact hy
    exact hm (hFzero m (integer_mem_fourHull hN hS hmK))
  let h : E4 := toE m - y
  have hh : h ≠ 0 := sub_ne_zero.mpr houtside
  have hsupport : ∀ x ∈ fourHull S, inner ℝ h (x - y) ≤ 0 :=
    supporting_inequality (convex_fourHull S) hy (fun z hz => hmin m hm z hz)
  obtain ⟨p, hp, hyp⟩ := hy
  have hy_eq : y = (4 : ℝ) • p := hyp.symm
  have hbound : ∀ n ∈ S, inner ℝ h (toE n) ≤ inner ℝ h p := by
    intro n hn
    have hs := hsupport (4 • toE n) ⟨toE n, toE_mem_hull hn, rfl⟩
    rw [hy_eq, inner_sub_right, inner_smul_right, inner_smul_right] at hs
    linarith
  obtain ⟨ι, hι, z, w, hzS, hzind, hwpos, hwsum, hpsplit⟩ :=
    eq_pos_convex_span_of_mem_convexHull hp
  letI := hι
  have hzbound : ∀ i, inner ℝ h (z i) ≤ inner ℝ h p := by
    intro i
    obtain ⟨n, hn, hen⟩ := hzS ⟨i, rfl⟩
    rw [← hen]
    exact hbound n hn
  have hfacez : ∀ i, inner ℝ h (z i) = inner ℝ h p :=
    positive_convex_support z w hwpos hwsum hpsplit h hzbound
  have hc : Fintype.card ι ≤ 4 := support_card_le_four z hzind h hh _ hfacez
  obtain ⟨a, ha⟩ := exists_weight_ge_quarter w hwsum hc
  obtain ⟨u, hu, heu⟩ := hzS ⟨a, rfl⟩
  have hueq : inner ℝ h (toE u) = inner ℝ h p := by
    rw [heu]
    exact hfacez a
  obtain ⟨r, hr, hrface⟩ := integer_face_hyperplane S h hh u
  refine ⟨u, hu, m, r, intDot r u, hr, rfl, hm, ?_⟩
  intro n hn hnr
  by_contra hFn
  have hy' : y + toE n - toE u ∈ fourHull S := by
    rw [hy_eq, heu]
    apply exchange_mem_four_smul (convex_convexHull ℝ _) z w
      (fun i => subset_convexHull ℝ _ (hzS ⟨i, rfl⟩)) (fun i => (hwpos i).le)
      hwsum hpsplit a ha (toE_mem_hull hn)
  have hdiff : toE (m + n - u) - (y + toE n - toE u) = h := by
    simp only [toE_add, toE_sub]
    dsimp [h]
    abel
  have hmin' : ∀ x ∈ fourHull S,
      ‖toE (m + n - u) - (y + toE n - toE u)‖ ≤ ‖toE (m + n - u) - x‖ := by
    intro x hx
    rw [hdiff]
    exact hmin (m + n - u) hFn x hx
  have hproj' := supporting_inequality (convex_fourHull S) hy' hmin' y
    (show y ∈ fourHull S from ⟨p, hp, hyp⟩)
  rw [hdiff] at hproj'
  have hback : y - (y + toE n - toE u) = toE u - toE n := by abel
  rw [hback, inner_sub_right] at hproj'
  have hface_n : inner ℝ h (toE n) = inner ℝ h (toE u) := by
    have hb := hbound n hn
    rw [← hueq] at hb
    linarith
  exact hnr (hrface n hn hface_n)

/-- Universally quantified export, with no geometry proposition as a hypothesis. -/
theorem lattice_face_selection
    (N : ℕ) (hN : 1 ≤ N)
    (S : Finset Z4) (hSne : S.Nonempty) (hS : S ⊆ intBox N)
    (F : Z4 → ℂ) (hF : ∃ m, F m ≠ 0)
    (hFzero : ∀ m ∈ enlargedBox N, F m = 0) :
    ∃ u ∈ S, ∃ (m r : Z4) (k : ℤ),
      r ≠ 0 ∧ intDot r u = k ∧ F m ≠ 0 ∧
        ∀ n ∈ S, intDot r n ≠ k → F (m + n - u) = 0 :=
  latticeFaceSelection N hN S hSne hS F hF hFzero

#check lattice_face_selection
#print axioms latticeFaceSelection
#print axioms lattice_face_selection

end LSLatticeGeometry
