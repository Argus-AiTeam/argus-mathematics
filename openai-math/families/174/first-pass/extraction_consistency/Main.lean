import Mathlib.Analysis.Matrix.PosDef
import Mathlib.Analysis.Matrix.Normed
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Convex.PartitionOfUnity
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Order.Interval.Set.Infinite
import Mathlib.Topology.Sequences
import Mathlib.Topology.EMetricSpace.Paracompact
import Mathlib.Topology.Metrizable.Uniformity
import Mathlib.Tactic

open scoped BigOperators Matrix.Norms.Elementwise
open Matrix Finset

namespace ExtractionConsistency

variable {V J E : Type*} [Fintype V] [DecidableEq V]

noncomputable def resistance (X : Matrix V V ℝ) (b : V → ℝ) : ℝ :=
  b ⬝ᵥ (X⁻¹ *ᵥ b)

def quadratic (X : Matrix V V ℝ) (z : V → ℝ) : ℝ :=
  z ⬝ᵥ (X *ᵥ z)

lemma quadratic_nonneg {X : Matrix V V ℝ} (hX : X.PosDef) (z : V → ℝ) :
    0 ≤ quadratic X z := by
  simpa [quadratic] using hX.posSemidef.dotProduct_mulVec_nonneg z

lemma resistance_nonneg {X : Matrix V V ℝ} (hX : X.PosDef) (b : V → ℝ) :
    0 ≤ resistance X b := by
  simpa [resistance] using hX.inv.posSemidef.dotProduct_mulVec_nonneg b

lemma inverse_mulVec {X : Matrix V V ℝ} (hX : X.PosDef) (b : V → ℝ) :
    X *ᵥ (X⁻¹ *ᵥ b) = b := by
  letI : Invertible X := hX.isUnit.invertible
  rw [mulVec_mulVec, mul_inv_of_invertible, one_mulVec]

lemma resistance_cauchy {X : Matrix V V ℝ} (hX : X.PosDef) (b z : V → ℝ) :
    (b ⬝ᵥ z)^2 ≤ resistance X b * quadratic X z := by
  letI : SeminormedAddCommGroup (V → ℝ) := X.toSeminormedAddCommGroup hX.posSemidef
  letI : InnerProductSpace ℝ (V → ℝ) := X.toInnerProductSpace hX.posSemidef
  have hs : Xᵀ = X := (isHermitian_iff_isSymm.mp hX.isHermitian).eq
  have hi : X *ᵥ (X⁻¹ *ᵥ b) = b := inverse_mulVec hX b
  have hc (y : V → ℝ) :
      inner ℝ (X⁻¹ *ᵥ b) y = b ⬝ᵥ y := by
    change (X *ᵥ y) ⬝ᵥ star (X⁻¹ *ᵥ b) = _
    simp only [star_trivial]
    rw [dotProduct_comm]
    have h := dotProduct_transpose_mulVec X (X⁻¹ *ᵥ b) y
    rw [hs, hi] at h
    rw [h, dotProduct_comm]
  have hz : inner ℝ z z = quadratic X z := by
    change (X *ᵥ z) ⬝ᵥ star z = _
    simp [quadratic, dotProduct_comm]
  have h := real_inner_mul_inner_self_le (X⁻¹ *ᵥ b) z
  rw [hc z, hc (X⁻¹ *ᵥ b), hz] at h
  simpa [resistance, pow_two] using h

lemma response_quadratic_bound {X : Matrix V V ℝ} (hX : X.PosDef)
    {a : ℝ} {b : V → ℝ} (hr : resistance X b ≤ a) (z : V → ℝ) :
    (b ⬝ᵥ z)^2 ≤ a * quadratic X z :=
  (resistance_cauchy hX b z).trans
    (mul_le_mul_of_nonneg_right hr (quadratic_nonneg hX z))

lemma scaled_quadratic_resistance {X : Matrix V V ℝ} (hX : X.PosDef)
    {a g : ℝ} (ha : 0 ≤ a) (hg : 0 < g) (b : V → ℝ)
    (hdom : ∀ z, g * (b ⬝ᵥ z)^2 ≤ a * quadratic X z) :
    resistance X b ≤ a / g := by
  have hr := resistance_nonneg hX b
  have h := hdom (X⁻¹ *ᵥ b)
  have hq : quadratic X (X⁻¹ *ᵥ b) = resistance X b := by
    simp only [quadratic, inverse_mulVec hX b, resistance, dotProduct_comm]
  rw [hq] at h
  change g * resistance X b ^ 2 ≤ a * resistance X b at h
  by_cases hz : resistance X b = 0
  · rw [hz]
    exact div_nonneg ha hg.le
  have hp : 0 < resistance X b := lt_of_le_of_ne hr (Ne.symm hz)
  apply (le_div_iff₀ hg).2
  by_contra hn
  have hmul := mul_pos hp (sub_pos.mpr (lt_of_not_ge hn))
  nlinarith

lemma quadratic_mixture [Fintype J] (w : J → ℝ)
    (Y : J → Matrix V V ℝ) (z : V → ℝ) :
    quadratic (∑ j, w j • Y j) z = ∑ j, w j * quadratic (Y j) z := by
  simp only [quadratic, sum_mulVec, dotProduct_sum, smul_mulVec, dotProduct_smul,
    smul_eq_mul]

lemma weighted_energy [Fintype J] (w beta Q : J → ℝ) (a v : ℝ)
    (hw : ∀ j, 0 ≤ w j) (hone : ∑ j, w j = 1)
    (h : ∀ j, (1 - beta j) * v ≤ a * Q j) :
    (1 - ∑ j, w j * beta j) * v ≤ a * ∑ j, w j * Q j := by
  have hsum := Finset.sum_le_sum (s := Finset.univ)
    (fun j _ => mul_le_mul_of_nonneg_left (h j) (hw j))
  have hl :
      (∑ j, w j * ((1 - beta j) * v)) = (1 - ∑ j, w j * beta j) * v := by
    calc
      _ = ∑ j, (w j - w j * beta j) * v := by
        apply Finset.sum_congr rfl
        intro j _
        ring
      _ = (1 - ∑ j, w j * beta j) * v := by
        rw [← Finset.sum_mul, Finset.sum_sub_distrib, hone]
  have hr : (∑ j, w j * (a * Q j)) = a * ∑ j, w j * Q j := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    ring
  rwa [hl, hr] at hsum

noncomputable def badMass [Fintype J] (w : J → ℝ)
    (Y : J → Matrix V V ℝ) (b : E → V → ℝ) (a : ℝ) (e : E) : ℝ :=
  ∑ j, if a < resistance (Y j) (b e) then w j else 0

lemma badMass_nonneg [Fintype J] (w : J → ℝ) (Y : J → Matrix V V ℝ)
    (b : E → V → ℝ) (a : ℝ) (hw : ∀ j, 0 ≤ w j) (e : E) :
    0 ≤ badMass w Y b a e := by
  classical
  exact Finset.sum_nonneg fun j _ => by
    split_ifs
    · exact hw j
    · exact le_rfl

theorem mixture_resistance_bound [Fintype J]
    (w : J → ℝ) (Y : J → Matrix V V ℝ) (b : E → V → ℝ)
    {a theta : ℝ} (ha : 0 < a) (htheta : theta < 1)
    (hw : ∀ j, 0 ≤ w j) (hone : ∑ j, w j = 1)
    (hY : ∀ j, (Y j).PosDef) (hX : (∑ j, w j • Y j).PosDef)
    (e : E) (hmass : badMass w Y b a e ≤ theta) :
    resistance (∑ j, w j • Y j) (b e) ≤ a / (1 - theta) := by
  classical
  apply scaled_quadratic_resistance hX ha.le (sub_pos.mpr htheta) (b e)
  intro z
  let beta : J → ℝ := fun j => if a < resistance (Y j) (b e) then 1 else 0
  have hrow (j : J) :
      (1 - beta j) * (b e ⬝ᵥ z)^2 ≤ a * quadratic (Y j) z := by
    dsimp [beta]
    split_ifs with h
    · simpa using mul_nonneg ha.le (quadratic_nonneg (hY j) z)
    · simpa using response_quadratic_bound (hY j) (le_of_not_gt h) z
  have henergy := weighted_energy w beta (fun j => quadratic (Y j) z)
    a ((b e ⬝ᵥ z)^2) hw hone hrow
  have hm : (∑ j, w j * beta j) = badMass w Y b a e := by
    apply Finset.sum_congr rfl
    intro j _
    dsimp [beta]
    split_ifs <;> simp
  rw [hm, ← quadratic_mixture] at henergy
  exact (mul_le_mul_of_nonneg_right (sub_le_sub_left hmass 1) (sq_nonneg _)).trans
    henergy

lemma total_bad_mass [Fintype J] [DecidableEq E]
    (B : Finset E) (w : J → ℝ) (Y : J → Matrix V V ℝ)
    (b : E → V → ℝ) (a delta : ℝ)
    (hw : ∀ j, 0 ≤ w j) (hone : ∑ j, w j = 1)
    (hresponse : ∀ j,
      ((B.filter fun e => a < resistance (Y j) (b e)).card : ℝ) ≤
        delta * (B.card : ℝ)) :
    ∑ e ∈ B, badMass w Y b a e ≤ delta * (B.card : ℝ) := by
  classical
  have hc (j : J) :
      (∑ e ∈ B, if a < resistance (Y j) (b e) then w j else 0) =
        w j * ((B.filter fun e => a < resistance (Y j) (b e)).card : ℝ) := by
    rw [← Finset.sum_filter]
    simp [mul_comm]
  calc
    _ = ∑ j, w j * ((B.filter fun e => a < resistance (Y j) (b e)).card : ℝ) := by
      simp only [badMass]
      rw [Finset.sum_comm]
      exact Finset.sum_congr rfl fun j _ => hc j
    _ ≤ ∑ j, w j * (delta * (B.card : ℝ)) :=
      Finset.sum_le_sum fun j _ => mul_le_mul_of_nonneg_left (hresponse j) (hw j)
    _ = delta * (B.card : ℝ) := by rw [← Finset.sum_mul, hone, one_mul]

theorem finite_markov_retention [DecidableEq E] (B : Finset E) (m : E → ℝ)
    {delta theta : ℝ} (hm : ∀ e ∈ B, 0 ≤ m e)
    (htotal : ∑ e ∈ B, m e ≤ delta * (B.card : ℝ)) :
    ∃ G : Finset E, G ⊆ B ∧ (∀ e ∈ G, m e ≤ theta) ∧
      theta * ((B.card : ℝ) - (G.card : ℝ)) ≤ delta * (B.card : ℝ) := by
  classical
  let D := B.filter fun e => theta < m e
  let G := B \ D
  have hD : D ⊆ B := Finset.filter_subset _ _
  have hcard : (G.card : ℝ) + (D.card : ℝ) = (B.card : ℝ) := by
    exact_mod_cast Finset.card_sdiff_add_card_eq_card hD
  have hd : theta * (D.card : ℝ) ≤ ∑ e ∈ D, m e := by
    calc
      _ = ∑ _e ∈ D, theta := by simp [mul_comm]
      _ ≤ _ := Finset.sum_le_sum fun e he =>
        (Finset.mem_filter.mp he).2.le
  have hsub : ∑ e ∈ D, m e ≤ ∑ e ∈ B, m e :=
    Finset.sum_le_sum_of_subset_of_nonneg hD fun e he _ => hm e he
  refine ⟨G, Finset.sdiff_subset, ?_, ?_⟩
  · intro e he
    have hmem := Finset.mem_sdiff.mp he
    by_contra hn
    exact hmem.2 (Finset.mem_filter.mpr ⟨hmem.1, lt_of_not_ge hn⟩)
  · have := hd.trans (hsub.trans htotal)
    have heq : (B.card : ℝ) - (G.card : ℝ) = (D.card : ℝ) := by linarith
    rwa [heq]

lemma retained_crossing_bound {r q delta theta d M c : ℝ}
    (hrq : q < r) (hq : 0 < q) (hdelta : 0 ≤ delta)
    (htheta : 0 < theta) (hd : 0 ≤ d)
    (hparameter : delta * r ≤ theta * (r - q))
    (hpacking : r * d ≤ M)
    (hretained : theta * (M - c) ≤ delta * M) :
    q * d ≤ c := by
  have hr : 0 < r := hq.trans hrq
  have hdt : delta < theta := by
    have hp : 0 < theta * q := mul_pos htheta hq
    by_contra hn
    have hm := mul_le_mul_of_nonneg_right (le_of_not_gt hn) hr.le
    nlinarith
  have hm := mul_le_mul_of_nonneg_left hpacking (sub_nonneg.mpr hdt.le)
  have hp := mul_le_mul_of_nonneg_right hparameter hd
  have hc : theta * (q * d) ≤ theta * c := by nlinarith
  by_contra hn
  have hpos := mul_pos htheta (sub_pos.mpr (lt_of_not_ge hn))
  nlinarith

theorem finite_response_forces_crossings [Fintype J] [DecidableEq E]
    (B : Finset E) (w : J → ℝ) (Y : J → Matrix V V ℝ)
    (b : E → V → ℝ) {a delta theta r q d : ℝ}
    (ha : 0 < a) (htheta0 : 0 < theta) (htheta1 : theta < 1)
    (hw : ∀ j, 0 ≤ w j) (hone : ∑ j, w j = 1)
    (hY : ∀ j, (Y j).PosDef) (hX : (∑ j, w j • Y j).PosDef)
    (hresponse : ∀ j,
      ((B.filter fun e => a < resistance (Y j) (b e)).card : ℝ) ≤
        delta * (B.card : ℝ))
    (hrq : q < r) (hq : 0 < q) (hdelta : 0 ≤ delta) (hd : 0 ≤ d)
    (hparameter : delta * r ≤ theta * (r - q))
    (hpacking : r * d ≤ (B.card : ℝ)) :
    q * d ≤ ((B.filter fun e =>
      resistance (∑ j, w j • Y j) (b e) ≤ a / (1 - theta)).card : ℝ) := by
  classical
  obtain ⟨G, hGB, hGmass, hGcount⟩ := finite_markov_retention B
    (badMass w Y b a)
    (fun e _ => badMass_nonneg w Y b a hw e)
    (total_bad_mass B w Y b a delta hw hone hresponse)
  have hcount : q * d ≤ (G.card : ℝ) :=
    retained_crossing_bound hrq hq hdelta htheta0 hd hparameter hpacking hGcount
  have hsub : G ⊆ B.filter (fun e =>
      resistance (∑ j, w j • Y j) (b e) ≤ a / (1 - theta)) := by
    intro e he
    exact Finset.mem_filter.mpr ⟨hGB he,
      mixture_resistance_bound w Y b ha htheta1 hw hone hY hX e (hGmass e he)⟩
  exact hcount.trans (by exact_mod_cast Finset.card_le_card hsub)

lemma dyadic_sum (a : ℕ) :
    (∑ j ∈ Finset.range (a + 1), (2 : ℝ) ^ (j + 1)) = 4 * (2 : ℝ)^a - 2 := by
  induction a with
  | zero => norm_num
  | succ a ih =>
      rw [Finset.sum_range_succ, ih, pow_succ]
      ring

theorem dyadic_tail_bound (a : ℕ) (M : ℕ → ℝ) (first : ℝ)
    (hM : ∀ j ∈ Finset.range (a + 1), M j ≤ (2 : ℝ)^(j + 1))
    (hfirst : (2 : ℝ)^a ≤ first) :
    (∑ j ∈ Finset.range (a + 1), M j) < 4 * first := by
  have h := Finset.sum_le_sum hM
  rw [dyadic_sum] at h
  linarith

theorem endpoint_parameter {a u delta t : ℝ}
    (ha : 0 < a) (hu : 0 < u) (hdelta0 : 0 ≤ delta) (hdeltau : delta < u)
    (ht : a * u / (u - delta) < t) :
    ∃ theta : ℝ, 0 < theta ∧ theta < 1 ∧ delta < theta * u ∧
      a / (1 - theta) < t := by
  have hud : 0 < u - delta := sub_pos.mpr hdeltau
  have ht0 : 0 < t := (div_pos (mul_pos ha hu) hud).trans ht
  have hcross : a * u < t * (u - delta) := (div_lt_iff₀ hud).mp ht
  have hxy : delta / u < (t - a) / t :=
    (div_lt_div_iff₀ hu ht0).mpr (by nlinarith)
  have heq : (t - a) / t = 1 - a / t := by
    field_simp
  rw [heq] at hxy
  have hx0 : 0 ≤ delta / u := div_nonneg hdelta0 hu.le
  have hy1 : 1 - a / t < 1 := by linarith [div_pos ha ht0]
  let theta := (delta / u + (1 - a / t)) / 2
  have hleft : delta / u < theta := by dsimp [theta]; linarith
  have hright : theta < 1 - a / t := by dsimp [theta]; linarith
  have htheta1 : theta < 1 := hright.trans hy1
  refine ⟨theta, lt_of_le_of_lt hx0 hleft, htheta1,
    (div_lt_iff₀ hu).mp hleft, ?_⟩
  apply (div_lt_iff₀ (sub_pos.mpr htheta1)).mpr
  have h := (div_lt_iff₀ ht0).mp (show a / t < 1 - theta by linarith)
  nlinarith

theorem endpoint_identity {a u delta : ℝ} (hu : u ≠ 0) (hud : u - delta ≠ 0) :
    a / (1 - delta / u) = a * u / (u - delta) := by
  field_simp

theorem endpoint_at_most_twice {a u delta : ℝ}
    (ha : 0 ≤ a) (hu : 0 < u) (hdelta : delta ≤ u / 2) :
    a * u / (u - delta) ≤ 2 * a := by
  have hud : 0 < u - delta := by linarith
  apply (div_le_iff₀ hud).mpr
  nlinarith

open Set Filter Topology

theorem nearby_response_fixed_point
    (K : Set (Matrix V V ℝ)) (hK : Convex ℝ K)
    (hfixed : ∀ f : C(K, K), ∃ x : K, f x = x)
    (response : K → K) {eps : ℝ} (heps : 0 < eps) :
    ∃ x : K, (x : Matrix V V ℝ) ∈ convexHull ℝ
      ((fun c : K => (response c : Matrix V V ℝ)) '' Metric.ball x eps) := by
  letI : ParacompactSpace K := Metric.instParacompactSpace
  let T (x : K) : Set (Matrix V V ℝ) :=
    convexHull ℝ ((fun c : K => (response c : Matrix V V ℝ)) '' Metric.ball x eps)
  have hconvex (x : K) : Convex ℝ (T x) := convex_convexHull ℝ _
  have hlocal (x : K) :
      ∃ c : Matrix V V ℝ, ∀ᶠ y in 𝓝 x, c ∈ T y := by
    refine ⟨response x, ?_⟩
    filter_upwards [Metric.ball_mem_nhds x heps] with y hy
    apply subset_convexHull ℝ
    refine ⟨x, ?_, rfl⟩
    simpa [Metric.mem_ball, dist_comm] using hy
  obtain ⟨g, hg⟩ :=
    exists_continuous_forall_mem_convex_of_local_const hconvex hlocal
  have hTK (x : K) : T x ⊆ K := by
    apply convexHull_min _ hK
    rintro z ⟨c, _, rfl⟩
    exact (response c).property
  let f : C(K, K) :=
    ⟨fun x => ⟨g x, hTK x (hg x)⟩,
      g.continuous.subtype_mk (fun x => hTK x (hg x))⟩
  obtain ⟨x, hx⟩ := hfixed f
  have hval : g x = (x : Matrix V V ℝ) :=
    congrArg (fun z : K => (z : Matrix V V ℝ)) hx
  exact ⟨x, by simpa only [hval] using hg x⟩

theorem finite_pattern_stability {Z : Type*} [PseudoMetricSpace Z] [Fintype E]
    (score : Z → E → ℝ) (hc : ∀ e, Continuous fun x => score x e)
    (x : Z) (s : ℝ) (hregular : ∀ e, score x e ≠ s) :
    ∃ rho > 0, ∀ {y : Z}, dist y x < rho →
      ∀ e, score y e ≤ s ↔ score x e ≤ s := by
  apply Metric.eventually_nhds_iff.mp
  apply Filter.eventually_all.mpr
  intro e
  rcases lt_or_gt_of_ne (hregular e) with hlt | hgt
  · filter_upwards [(tendsto_order.mp (hc e).continuousAt).2 s hlt] with y hy
    exact iff_of_true hy.le hlt.le
  · filter_upwards [(tendsto_order.mp (hc e).continuousAt).1 s hgt] with y hy
    exact iff_of_false (not_le_of_gt hy) (not_le_of_gt hgt)

theorem threshold_consistency [Fintype E] [DecidableEq E]
    (K : Set (Matrix V V ℝ)) (hcompact : IsCompact K) (hconvex : Convex ℝ K)
    (hpd : ∀ X ∈ K, X.PosDef)
    (hfixed : ∀ f : C(K, K), ∃ x : K, f x = x)
    (b : E → V → ℝ)
    (hcontinuous : ∀ e, Continuous fun x : K =>
      resistance (x : Matrix V V ℝ) (b e))
    (B : K → ℝ → Finset E)
    (hpattern : ∀ (x y : K) (s : ℝ),
      (∀ e, resistance (x : Matrix V V ℝ) (b e) ≤ s ↔
        resistance (y : Matrix V V ℝ) (b e) ≤ s) → B x s = B y s)
    (Packed : K → ℝ → Prop)
    (hmono : ∀ (x : K) {s t : ℝ}, s ≤ t → Packed x s → Packed x t)
    (hclosed : IsClosed {z : K × ℝ | Packed z.1 z.2})
    {a delta u r q : ℝ}
    (ha : 0 < a) (hu : 0 < u) (hdelta0 : 0 ≤ delta) (hdeltau : delta < u)
    (hq : 0 < q) (hrq : q < r) (hslack : r - q = u * r)
    (hobstruction : ∀ (x : K) (s : ℝ), 0 < s → ¬ Packed x s →
      ∃ d : ℝ, 0 < d ∧ r * d ≤ ((B x s).card : ℝ) ∧
        (((B x s).filter fun e =>
          resistance (x : Matrix V V ℝ) (b e) ≤ s).card : ℝ) < q * d)
    (hresponse : ∀ x : K, ∃ y : K, ∀ s : ℝ, 0 < s →
      (((B x s).filter fun e =>
        a < resistance (y : Matrix V V ℝ) (b e)).card : ℝ) ≤
          delta * ((B x s).card : ℝ)) :
    ∃ x : K, Packed x (a * u / (u - delta)) := by
  classical
  letI : TopologicalSpace.PseudoMetrizableSpace K :=
    PseudoEMetricSpace.pseudoMetrizableSpace
  letI : CompactSpace K := isCompact_iff_compactSpace.mp hcompact
  choose response hresp using hresponse
  have hr : 0 < r := hq.trans hrq
  have habove : ∀ t : ℝ, a * u / (u - delta) < t → ∃ x : K, Packed x t := by
    intro t ht
    obtain ⟨theta, htheta0, htheta1, hdelta_theta, htheta_t⟩ :=
      endpoint_parameter ha hu hdelta0 hdeltau ht
    have heps (n : ℕ) : 0 < 1 / ((n : ℝ) + 1) := by positivity
    have hex (n : ℕ) := nearby_response_fixed_point K hconvex hfixed response (heps n)
    choose xp hxp using hex
    obtain ⟨x, phi, hphi, hlim⟩ := CompactSpace.tendsto_subseq xp
    obtain ⟨s, hs, hsavoid⟩ := (Set.Ioo_infinite htheta_t).exists_notMem_finset
      (Finset.univ.image fun e => resistance (x : Matrix V V ℝ) (b e))
    have hs0 : 0 < s :=
      (div_pos ha (sub_pos.mpr htheta1)).trans hs.1
    have hregular (e : E) : resistance (x : Matrix V V ℝ) (b e) ≠ s := by
      intro he
      exact hsavoid (Finset.mem_image.mpr ⟨e, Finset.mem_univ e, he⟩)
    obtain ⟨rho, hrho, hstable⟩ :=
      finite_pattern_stability
        (fun y : K => fun e => resistance (y : Matrix V V ℝ) (b e))
        hcontinuous x s hregular
    have hxnear := (Metric.tendsto_nhds.mp hlim) (rho / 2) (half_pos hrho)
    have hepslim :
        Tendsto (fun n : ℕ => 1 / ((phi n : ℝ) + 1)) atTop (𝓝 (0 : ℝ)) :=
      tendsto_one_div_add_atTop_nhds_zero_nat.comp hphi.tendsto_atTop
    have hepsnear := (tendsto_order.mp hepslim).2 (rho / 2) (half_pos hrho)
    obtain ⟨n, hxnear, hepsnear⟩ := (hxnear.and hepsnear).exists
    change dist (xp (phi n)) x < rho / 2 at hxnear
    obtain ⟨I, hI, w, z, hw, hone, hz, hsum⟩ :=
      mem_convexHull_iff_exists_fintype.mp (hxp (phi n))
    letI : Fintype I := hI
    have hcenters (i : I) :
        ∃ c : K, dist c (xp (phi n)) < 1 / ((phi n : ℝ) + 1) ∧
          (response c : Matrix V V ℝ) = z i := by
      obtain ⟨c, hc, hcz⟩ := hz i
      exact ⟨c, hc, hcz⟩
    choose c hc hcz using hcenters
    let Y : I → Matrix V V ℝ := fun i => (response (c i) : Matrix V V ℝ)
    have hsumY : (∑ i, w i • Y i) = (xp (phi n) : Matrix V V ℝ) := by
      calc
        _ = ∑ i, w i • z i := by simp only [Y, hcz]
        _ = _ := hsum
    have hY (i : I) : (Y i).PosDef := hpd _ (response (c i)).property
    have hX : (∑ i, w i • Y i).PosDef := by
      rw [hsumY]
      exact hpd _ (xp (phi n)).property
    have hrows (i : I) :
        (((B x s).filter fun e => a < resistance (Y i) (b e)).card : ℝ) ≤
          delta * ((B x s).card : ℝ) := by
      have hdist : dist (c i) x < rho := by
        have htriangle := dist_triangle (c i) (xp (phi n)) x
        nlinarith [hc i]
      have heq : B (c i) s = B x s :=
        hpattern (c i) x s (hstable hdist)
      have h := hresp (c i) s hs0
      rw [heq] at h
      exact h
    refine ⟨x, ?_⟩
    by_contra hnot
    have hnot_s : ¬ Packed x s := fun hp => hnot (hmono x hs.2.le hp)
    obtain ⟨d, hd, hpacking, hcrossing⟩ := hobstruction x s hs0 hnot_s
    have hparameter : delta * r ≤ theta * (r - q) := by
      apply le_of_lt
      calc
        delta * r < (theta * u) * r := mul_lt_mul_of_pos_right hdelta_theta hr
        _ = theta * (r - q) := by rw [hslack]; ring
    have hcount := finite_response_forces_crossings
      (B x s) w Y b ha htheta0 htheta1 hw hone hY hX hrows
      hrq hq hdelta0 hd.le hparameter hpacking
    have hsub :
        (B x s).filter (fun e =>
          resistance (∑ i, w i • Y i) (b e) ≤ a / (1 - theta)) ⊆
        (B x s).filter (fun e =>
          resistance (x : Matrix V V ℝ) (b e) ≤ s) := by
      intro e he
      obtain ⟨heB, heR⟩ := Finset.mem_filter.mp he
      rw [hsumY] at heR
      have hxpnear : dist (xp (phi n)) x < rho := by linarith
      exact Finset.mem_filter.mpr ⟨heB,
        (hstable hxpnear e).mp (heR.trans hs.1.le)⟩
    have hcard : q * d ≤
        (((B x s).filter fun e =>
          resistance (x : Matrix V V ℝ) (b e) ≤ s).card : ℝ) :=
      hcount.trans (by exact_mod_cast Finset.card_le_card hsub)
    linarith
  have htime (n : ℕ) :
      a * u / (u - delta) < a * u / (u - delta) + 1 / ((n : ℝ) + 1) := by
    have : 0 < 1 / ((n : ℝ) + 1) := by positivity
    linarith
  choose xn hxn using fun n => habove _ (htime n)
  obtain ⟨x, phi, hphi, hlim⟩ := CompactSpace.tendsto_subseq xn
  have hepslim :
      Tendsto (fun n : ℕ => 1 / ((phi n : ℝ) + 1)) atTop (𝓝 (0 : ℝ)) :=
    tendsto_one_div_add_atTop_nhds_zero_nat.comp hphi.tendsto_atTop
  have htimelim : Tendsto
      (fun n : ℕ => a * u / (u - delta) + 1 / ((phi n : ℝ) + 1))
      atTop (𝓝 (a * u / (u - delta))) := by
    simpa using tendsto_const_nhds.add hepslim
  have hpair := hlim.prodMk_nhds htimelim
  exact ⟨x, hclosed.mem_of_tendsto hpair (Filter.Eventually.of_forall fun n => hxn (phi n))⟩

end ExtractionConsistency
