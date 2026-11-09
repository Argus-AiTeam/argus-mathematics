/- Licensed upstream proof, OpenAI, Apache-2.0; see LICENSE.upstream.
Source: https://github.com/openai/math/tree/4eaee87548250b2682affda7d05d947c05554bae/lean
MODIFICATION: dependency-ordered concatenation, internal imports removed;
Lean 4.31 API spellings: IsLittleO.fun_sum -> IsLittleO.sum,
and dite_eq_left -> dif_pos (no mathematical change);
the final Campaign149 theorem is an independently written statement adapter.
No mathematical proof is attributed to the audit author. -/

import Mathlib


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.FixedMinimum -/

namespace OAI

universe uIota

noncomputable section

open scoped BigOperators
open Filter Topology

namespace Problem326.Affine

structure Label (d : ℕ) where
  slope : Fin d → ℝ
  offset : ℝ → ℝ

def Label.value {d : ℕ} (L : Label d) (h : ℝ) (x : Fin d → ℝ) : ℝ :=
  ∑ i, L.slope i * x i + L.offset h

def Active {d : ℕ} (Λ : Finset (Label d)) (L : Label d)
    (h : ℝ) (x : Fin d → ℝ) : Prop :=
  L ∈ Λ ∧ ∀ J ∈ Λ, L.value h x ≤ J.value h x

def Cube {d : ℕ} (a b : ℝ) (p : Fin d → ℝ) : Prop :=
  ∀ i, a ≤ p i ∧ p i ≤ b

def HasMinimum {d : ℕ} (p : Fin d → ℝ) (t : ℝ) : Prop :=
  (∀ i, t ≤ p i) ∧ ∃ i, p i = t

def powerPoint {d : ℕ} (h : ℝ) (p : Fin d → ℝ) : Fin d → ℝ :=
  fun i => h ^ p i

/-- The sequential condition required of a family at one fixed minimum level. -/
def ApproximatesAtMinimum {d : ℕ} (Λ : Finset (Label d))
    (a b t : ℝ) (E : (Fin d → ℝ) → ℝ) : Prop :=
  ∀ L ∈ Λ, ∀ (h : ℕ → ℝ) (p : ℕ → (Fin d → ℝ)) (p₀ : Fin d → ℝ),
    (∀ n, 0 < h n) → Tendsto h atTop (𝓝 0) →
    Tendsto p atTop (𝓝 p₀) → Cube a b p₀ → HasMinimum p₀ t →
    (∀ n, Active Λ L (h n) (powerPoint (h n) (p n))) →
    ‖p₀ - L.slope‖ < E L.slope

lemma active_mono {d : ℕ} {Λ Γ : Finset (Label d)} {L : Label d}
    {h : ℝ} {x : Fin d → ℝ} (hΛ : Λ ⊆ Γ) (hL : L ∈ Λ)
    (ha : Active Γ L h x) : Active Λ L h x :=
  ⟨hL, fun J hJ => ha.2 J (hΛ hJ)⟩

lemma active_singleton {d : ℕ} (L : Label d) (h : ℝ) (x : Fin d → ℝ) :
    Active {L} L h x := by
  classical
  refine ⟨by simp, ?_⟩
  intro J hJ
  have hJL : J = L := by simpa using hJ
  subst J
  exact le_rfl

/-- Comparison activity is insensitive to a common additive shift. -/
lemma active_iff_common_shift {ι : Type uIota} (s : Finset ι) (v : ι → ℝ)
    (i : ι) (c : ℝ) :
    (∀ j ∈ s, v i + c ≤ v j + c) ↔ (∀ j ∈ s, v i ≤ v j) := by
  simp only [add_le_add_iff_right]

lemma exists_active {d : ℕ} (Λ : Finset (Label d)) (hne : Λ.Nonempty)
    (h : ℝ) (x : Fin d → ℝ) : ∃ L, Active Λ L h x := by
  classical
  obtain ⟨L, hL, hmin⟩ := Λ.exists_min_image (fun J => J.value h x) hne
  exact ⟨L, hL, hmin⟩

/-- A finite collection of positive tolerances admits one strict common bound. -/
lemma exists_common_pos_lt {ι : Type uIota} (s : Finset ι) (E : ι → ℝ)
    (hE : ∀ i ∈ s, 0 < E i) (u : ℝ) (hu : 0 < u) :
    ∃ δ : ℝ, 0 < δ ∧ δ < u ∧ ∀ i ∈ s, δ < E i := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      exact ⟨u / 2, by positivity, by linarith, by simp⟩
  | @insert i s hi ih =>
      obtain ⟨δ, hδ, hδu, hδE⟩ := ih (fun j hj => hE j (Finset.mem_insert_of_mem hj))
      have hEi : 0 < E i := hE i (Finset.mem_insert_self _ _)
      refine ⟨min δ (E i / 2), lt_min hδ (by positivity),
        (min_le_left _ _).trans_lt hδu, ?_⟩
      intro j hj
      rcases Finset.mem_insert.mp hj with rfl | hj
      · exact (min_le_right _ _).trans_lt (by linarith)
      · exact (min_le_left _ _).trans_lt (hδE j hj)

/-- The choice of the next type threshold in the fixed-minimum induction.
The upper endpoint can itself be the preceding threshold, giving a decreasing
sequence while only querying finitely many tolerance values. -/
lemma exists_threshold {ι : Type uIota} (s : Finset ι) (E : ι → ℝ)
    (hE : ∀ i ∈ s, 0 < E i) {t u : ℝ} (htu : t < u) :
    ∃ β : ℝ, t < β ∧ β < u ∧ ∀ i ∈ s, β - t < E i := by
  obtain ⟨δ, hδ, hδu, hδE⟩ := exists_common_pos_lt s E hE (u - t) (sub_pos.mpr htu)
  refine ⟨t + δ, by linarith, by linarith, ?_⟩
  intro i hi
  simpa using hδE i hi

lemma eq_const_of_minimum_at_upper {d : ℕ} {a b : ℝ} {p : Fin d → ℝ}
    (hp : Cube a b p) (hm : HasMinimum p b) : p = fun _ => b := by
  funext i
  exact le_antisymm (hp i).2 (hm.1 i)

lemma eq_const_of_minimum_one {p : Fin 1 → ℝ} {t : ℝ}
    (hm : HasMinimum p t) : p = fun _ => t := by
  obtain ⟨i, hi⟩ := hm.2
  funext j
  have hij : j = i := Subsingleton.elim _ _
  simpa [hij] using hi

/-- Final coordinate estimate for types with a further threshold. -/
lemma norm_sub_lt_of_support {d : ℕ} (U : Finset (Fin d))
    {p r : Fin d → ℝ} {t β ε : ℝ} (hε : 0 < ε)
    (hin : ∀ i ∈ U, |p i - r i| < ε)
    (hout : ∀ i ∉ U, r i = t ∧ t ≤ p i ∧ p i ≤ β)
    (hβ : β - t < ε) : ‖p - r‖ < ε := by
  rw [pi_norm_lt_iff hε]
  intro i
  change |p i - r i| < ε
  by_cases hi : i ∈ U
  · exact hin i hi
  · obtain ⟨hr, hp, hpβ⟩ := hout i hi
    rw [hr, abs_of_nonneg (sub_nonneg.mpr hp)]
    linarith

/-- For the last type, the unique unraised coordinate realizes the minimum. -/
lemma off_support_eq_minimum {d : ℕ} (U : Finset (Fin d))
    {p : Fin d → ℝ} {t : ℝ} (hm : HasMinimum p t)
    (hin : ∀ i ∈ U, t < p i) (hcomp : ∀ i ∉ U, ∀ j ∉ U, i = j) :
    ∀ i ∉ U, p i = t := by
  obtain ⟨j, hj⟩ := hm.2
  have hjU : j ∉ U := by
    intro hjU
    have := hin j hjU
    linarith
  intro i hi
  have hij : i = j := hcomp i hi j hjU
  simpa [hij] using hj

/-- The singleton family verifies the fixed-minimum base case in dimension one. -/
lemma singleton_approximates_one (a b t : ℝ) (E : (Fin 1 → ℝ) → ℝ)
    (hE : 0 < E (fun _ => t)) :
    ApproximatesAtMinimum {⟨fun _ => t, fun _ => 0⟩} a b t E := by
  classical
  intro L hL h p p₀ hh hlim hp hp₀ hm ha
  have hL' : L = (⟨fun _ => t, fun _ => 0⟩ : Label 1) := by simpa using hL
  subst L
  rw [eq_const_of_minimum_one hm]
  simpa using hE

/-- The other singleton base case works in every dimension at the upper corner. -/
lemma singleton_approximates_upper {d : ℕ} (a b : ℝ)
    (E : (Fin d → ℝ) → ℝ) (hE : 0 < E (fun _ => b)) :
    ApproximatesAtMinimum {⟨fun _ => b, fun _ => 0⟩} a b b E := by
  classical
  intro L hL h p p₀ hh hlim hp hp₀ hm ha
  have hL' : L = (⟨fun _ => b, fun _ => 0⟩ : Label d) := by simpa using hL
  subst L
  rw [eq_const_of_minimum_at_upper hp₀ hm]
  simpa using hE

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.CoordinateEmbedding -/

namespace OAI

noncomputable section
open scoped BigOperators
open Filter Topology

namespace Problem326.Affine

local instance {d : ℕ} : DecidableEq (Label d) := Classical.decEq _

/-- Extend coordinates along an injection, using the constant baseline on its complement. -/
def embedCoordinates {k d : ℕ} (e : Fin k ↪ Fin d) (t : ℝ)
    (s : Fin k → ℝ) : Fin d → ℝ :=
  fun i => t + ∑ j, if e j = i then s j - t else 0

@[simp] theorem embedCoordinates_apply {k d : ℕ} (e : Fin k ↪ Fin d)
    (t : ℝ) (s : Fin k → ℝ) (j : Fin k) :
    embedCoordinates e t s (e j) = s j := by
  classical
  simp only [embedCoordinates, e.injective.eq_iff]
  simp

theorem embedCoordinates_outside {k d : ℕ} (e : Fin k ↪ Fin d)
    (t : ℝ) (s : Fin k → ℝ) {i : Fin d} (hi : i ∉ Set.range e) :
    embedCoordinates e t s i = t := by
  classical
  have hne (j : Fin k) : e j ≠ i := fun h => hi ⟨j, h⟩
  simp [embedCoordinates, hne]

/-- The larger-dimensional label used for a fixed-minimum type. -/
def Label.embed {k d : ℕ} (e : Fin k ↪ Fin d) (t β : ℝ)
    (L : Label k) : Label d where
  slope := embedCoordinates e t L.slope
  offset := fun h => -h ^ β + L.offset h

theorem embedCoordinates_dot {k d : ℕ} (e : Fin k ↪ Fin d)
    (t : ℝ) (s : Fin k → ℝ) (x : Fin d → ℝ) :
    (∑ i, embedCoordinates e t s i * x i) =
      (∑ j, s j * x (e j)) + t * ((∑ i, x i) - ∑ j, x (e j)) := by
  classical
  simp only [embedCoordinates, add_mul, Finset.sum_add_distrib]
  have hex : (∑ i : Fin d, (∑ j : Fin k, if e j = i then s j - t else 0) * x i) =
      ∑ j : Fin k, (s j - t) * x (e j) := by
    simp_rw [Finset.sum_mul]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro j hj
    simp [ite_mul]
  rw [hex]
  simp only [sub_mul, Finset.sum_sub_distrib, ← Finset.mul_sum]
  ring

/-- Embedded affine values differ from their projected values by a common term. -/
theorem Label.embed_value {k d : ℕ} (e : Fin k ↪ Fin d) (t β h : ℝ)
    (L : Label k) (x : Fin d → ℝ) :
    (L.embed e t β).value h x = L.value h (fun j => x (e j)) +
      t * ((∑ i, x i) - ∑ j, x (e j)) - h ^ β := by
  dsimp [Label.value, Label.embed]
  rw [embedCoordinates_dot]
  ring

theorem Label.embed_injective {k d : ℕ} (e : Fin k ↪ Fin d) (t β : ℝ) :
    Function.Injective (Label.embed e t β) := by
  intro L J heq
  have hs : L.slope = J.slope := by
    funext j
    have hj := congrArg (fun Q : Label d => Q.slope (e j)) heq
    simpa only [Label.embed, embedCoordinates_apply] using hj
  have hc : L.offset = J.offset := by
    funext h
    have hh := congrArg (fun Q : Label d => Q.offset h) heq
    dsimp [Label.embed] at hh
    linarith
  cases L
  cases J
  cases hs
  cases hc
  rfl

/-- Common baseline and offset terms preserve all comparisons, including ties. -/
theorem active_embed_iff {k d : ℕ} (e : Fin k ↪ Fin d) (t β h : ℝ)
    (Λ : Finset (Label k)) (L : Label k) (x : Fin d → ℝ) :
    Active (Λ.image (Label.embed e t β)) (L.embed e t β) h x ↔
      Active Λ L h (fun j => x (e j)) := by
  classical
  constructor
  · intro ha
    obtain ⟨J, hJ, hJL⟩ := Finset.mem_image.1 ha.1
    have hJL' : J = L := Label.embed_injective e t β hJL
    subst J
    refine ⟨hJ, ?_⟩
    intro J hJ
    have hh := ha.2 (J.embed e t β) (Finset.mem_image_of_mem _ hJ)
    simp only [Label.embed_value] at hh
    linarith
  · intro ha
    refine ⟨Finset.mem_image_of_mem _ ha.1, ?_⟩
    intro J hJ
    obtain ⟨Q, hQ, rfl⟩ := Finset.mem_image.1 hJ
    have hh := ha.2 Q hQ
    simp only [Label.embed_value]
    linarith

theorem cube_embedCoordinates {k d : ℕ} (e : Fin k ↪ Fin d)
    {a t β b : ℝ} {s : Fin k → ℝ}
    (hat : a ≤ t) (htβ : t ≤ β) (htb : t ≤ b) (hs : Cube β b s) :
    Cube a b (embedCoordinates e t s) := by
  intro i
  by_cases hi : i ∈ Set.range e
  · obtain ⟨j, rfl⟩ := hi
    rw [embedCoordinates_apply]
    exact ⟨hat.trans (htβ.trans (hs j).1), (hs j).2⟩
  · rw [embedCoordinates_outside e t s hi]
    exact ⟨hat, htb⟩

theorem hasMinimum_embedCoordinates {k d : ℕ} (e : Fin k ↪ Fin d)
    (hkd : k < d) {t : ℝ} {s : Fin k → ℝ} (hs : ∀ j, t ≤ s j) :
    HasMinimum (embedCoordinates e t s) t := by
  constructor
  · intro i
    by_cases hi : i ∈ Set.range e
    · obtain ⟨j, rfl⟩ := hi
      simpa only [embedCoordinates_apply] using hs j
    · rw [embedCoordinates_outside e t s hi]
  · have hns : ¬ Function.Surjective e := by
      intro hsurj
      have hcard := Fintype.card_le_of_surjective e hsurj
      simp only [Fintype.card_fin] at hcard
      omega
    change ¬ ∀ i, ∃ j, e j = i at hns
    push Not at hns
    obtain ⟨i, hi⟩ := hns
    refine ⟨i, embedCoordinates_outside e t s ?_⟩
    simpa only [Set.mem_range, not_exists] using hi

/-- The raised coordinates of the embedded slope are exactly the injected coordinates. -/
theorem embedCoordinates_gt_baseline_iff {k d : ℕ} (e : Fin k ↪ Fin d)
    {t : ℝ} {s : Fin k → ℝ} (hs : ∀ j, t < s j) (i : Fin d) :
    t < embedCoordinates e t s i ↔ i ∈ Set.range e := by
  by_cases hi : i ∈ Set.range e
  · obtain ⟨j, rfl⟩ := hi
    exact iff_of_true (by simpa only [embedCoordinates_apply] using hs j) ⟨j, rfl⟩
  · rw [embedCoordinates_outside e t s hi]
    simp [hi]

theorem tendsto_project_coordinates {k d : ℕ} (e : Fin k ↪ Fin d)
    {p : ℕ → (Fin d → ℝ)} {p₀ : Fin d → ℝ}
    (hp : Tendsto p atTop (𝓝 p₀)) :
    Tendsto (fun n j => p n (e j)) atTop (𝓝 (fun j => p₀ (e j))) := by
  exact tendsto_pi_nhds.2 (fun j => (tendsto_pi_nhds.1 hp) (e j))

theorem powerPoint_project {k d : ℕ} (e : Fin k ↪ Fin d)
    (h : ℝ) (p : Fin d → ℝ) :
    (fun j => powerPoint h p (e j)) = powerPoint h (fun j => p (e j)) := rfl

/-- Activity in any larger family restricts to the projected lower-dimensional family. -/
theorem active_project_of_active {k d : ℕ} (e : Fin k ↪ Fin d) (t β h : ℝ)
    {Λ : Finset (Label k)} {Γ : Finset (Label d)} {L : Label k}
    (hΛ : Λ.image (Label.embed e t β) ⊆ Γ) (hL : L ∈ Λ)
    (p : Fin d → ℝ)
    (ha : Active Γ (L.embed e t β) h (powerPoint h p)) :
    Active Λ L h (powerPoint h (fun j => p (e j))) := by
  have ha' := active_mono hΛ (Finset.mem_image_of_mem _ hL) ha
  have hp := (active_embed_iff e t β h Λ L (powerPoint h p)).1 ha'
  simpa only [powerPoint_project] using hp

/-- A projected norm estimate controls every raised coordinate of the larger slope. -/
theorem embedded_error_on_range {k d : ℕ} (e : Fin k ↪ Fin d)
    (t : ℝ) {s : Fin k → ℝ} {p : Fin d → ℝ} {ε : ℝ}
    (herr : ‖(fun j => p (e j)) - s‖ < ε) :
    ∀ i ∈ Set.range e, |p i - embedCoordinates e t s i| < ε := by
  have hε : 0 < ε := (norm_nonneg _).trans_lt herr
  have hh := (pi_norm_lt_iff hε).1 herr
  intro i hi
  obtain ⟨j, rfl⟩ := hi
  simpa only [embedCoordinates_apply, Pi.sub_apply, Real.norm_eq_abs] using hh j

/-- Canonical coordinate injection for a finite support, built from its finite enumeration. -/
def supportEmbedding {d : ℕ} (U : Finset (Fin d)) : Fin U.card ↪ Fin d :=
  U.equivFin.symm.toEmbedding.trans (Function.Embedding.subtype (fun i => i ∈ U))

@[simp] theorem supportEmbedding_mem {d : ℕ} (U : Finset (Fin d)) (j : Fin U.card) :
    supportEmbedding U j ∈ U :=
  (U.equivFin.symm j).property

theorem range_supportEmbedding {d : ℕ} (U : Finset (Fin d)) :
    Set.range (supportEmbedding U) = (U : Set (Fin d)) := by
  ext i
  constructor
  · rintro ⟨j, rfl⟩
    exact supportEmbedding_mem U j
  · intro hi
    refine ⟨U.equivFin ⟨i, hi⟩, ?_⟩
    simp [supportEmbedding]

/-- Every member of an embedded nonempty family has the required baseline minimum. -/
theorem embedded_family_data {k d : ℕ} (e : Fin k ↪ Fin d)
    (hkd : k < d) {a t β b : ℝ}
    (hat : a ≤ t) (htβ : t < β) (hβb : β < b)
    (Λ : Finset (Label k)) (hne : Λ.Nonempty)
    (hslopes : ∀ L ∈ Λ, Cube β b L.slope) :
    (Λ.image (Label.embed e t β)).Nonempty ∧
      ∀ J ∈ Λ.image (Label.embed e t β),
        Cube a b J.slope ∧ HasMinimum J.slope t ∧
        ∀ i, t < J.slope i ↔ i ∈ Set.range e := by
  classical
  refine ⟨hne.image _, ?_⟩
  intro J hJ
  obtain ⟨L, hL, rfl⟩ := Finset.mem_image.1 hJ
  refine ⟨cube_embedCoordinates e hat htβ.le (htβ.trans hβb).le (hslopes L hL), ?_, ?_⟩
  · exact hasMinimum_embedCoordinates e hkd (fun j => htβ.le.trans (hslopes L hL j).1)
  · exact embedCoordinates_gt_baseline_iff e (fun j => htβ.trans_le (hslopes L hL j).1)

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.TypeFamily -/

namespace OAI

noncomputable section
open scoped BigOperators
open Filter Topology

namespace Problem326.Affine

local instance {d : ℕ} : DecidableEq (Label d) := Classical.decEq _

/-- The type-`k` family is the finite union over coordinate injections. Indexing by all
injections avoids dependent coordinate casts; every `k`-element support is represented. -/
def typeFamily {k d : ℕ} (t β : ℝ)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k)) : Finset (Label d) :=
  Finset.univ.biUnion (fun e => (Λ e).image (Label.embed e t β))

theorem mem_typeFamily {k d : ℕ} (t β : ℝ)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k)) (J : Label d) :
    J ∈ typeFamily t β Λ ↔
      ∃ e : Fin k ↪ Fin d, ∃ L ∈ Λ e, L.embed e t β = J := by
  classical
  simp only [typeFamily, Finset.mem_biUnion, Finset.mem_univ, true_and,
    Finset.mem_image]

theorem embeddedFamily_subset_typeFamily {k d : ℕ} (t β : ℝ)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k)) (e : Fin k ↪ Fin d) :
    (Λ e).image (Label.embed e t β) ⊆ typeFamily t β Λ := by
  intro J hJ
  obtain ⟨L, hL, rfl⟩ := Finset.mem_image.1 hJ
  exact (mem_typeFamily t β Λ _).2 ⟨e, L, hL, rfl⟩

theorem typeFamily_nonempty {k d : ℕ} (hkd : k ≤ d) (t β : ℝ)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k))
    (hne : ∀ e, (Λ e).Nonempty) : (typeFamily t β Λ).Nonempty := by
  let e : Fin k ↪ Fin d := Fin.castLEEmb hkd
  obtain ⟨L, hL⟩ := hne e
  exact ⟨L.embed e t β, (mem_typeFamily t β Λ _).2 ⟨e, L, hL, rfl⟩⟩

/-- Every member of a type family has baseline minimum and exactly the injected raised support. -/
theorem typeFamily_member_data {k d : ℕ} (hkd : k < d)
    {a t β b : ℝ} (hat : a ≤ t) (htβ : t < β) (hβb : β < b)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k))
    (hslopes : ∀ e L, L ∈ Λ e → Cube β b L.slope)
    {J : Label d} (hJ : J ∈ typeFamily t β Λ) :
    Cube a b J.slope ∧ HasMinimum J.slope t ∧
      ∃ e : Fin k ↪ Fin d, ∀ i, t < J.slope i ↔ i ∈ Set.range e := by
  obtain ⟨e, L, hL, rfl⟩ := (mem_typeFamily t β Λ J).1 hJ
  refine ⟨cube_embedCoordinates e hat htβ.le (htβ.trans hβb).le (hslopes e L hL),
    hasMinimum_embedCoordinates e hkd (fun j => htβ.le.trans (hslopes e L hL j).1), e, ?_⟩
  exact embedCoordinates_gt_baseline_iff e (fun j => htβ.trans_le (hslopes e L hL j).1)

/-- Every prescribed support of size `k` occurs in the type family. -/
theorem typeFamily_support_exists {k d : ℕ} {t β b : ℝ} (htβ : t < β)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k))
    (hne : ∀ e, (Λ e).Nonempty)
    (hslopes : ∀ e L, L ∈ Λ e → Cube β b L.slope)
    (U : Finset (Fin d)) (hU : U.card = k) :
    ∃ J ∈ typeFamily t β Λ, ∀ i, t < J.slope i ↔ i ∈ U := by
  let e : Fin k ↪ Fin d := (U.orderEmbOfFin hU).toEmbedding
  obtain ⟨L, hL⟩ := hne e
  refine ⟨L.embed e t β, (mem_typeFamily t β Λ _).2 ⟨e, L, hL, rfl⟩, ?_⟩
  intro i
  change t < embedCoordinates e t L.slope i ↔ i ∈ U
  rw [embedCoordinates_gt_baseline_iff e (fun j => htβ.trans_le (hslopes e L hL j).1)]
  have hrange : Set.range e = (U : Set (Fin d)) := Finset.range_orderEmbOfFin U hU
  rw [hrange]
  rfl

/-- All comparisons in the total type family imply the lower-dimensional activity hypothesis. -/
theorem typeFamily_active_project {k d : ℕ} (t β h : ℝ)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k))
    (e : Fin k ↪ Fin d) {L : Label k} (hL : L ∈ Λ e)
    (p : Fin d → ℝ)
    (ha : Active (typeFamily t β Λ) (L.embed e t β) h (powerPoint h p)) :
    Active (Λ e) L h (powerPoint h (fun j => p (e j))) :=
  active_project_of_active e t β h (embeddedFamily_subset_typeFamily t β Λ e) hL p ha

/-- The support data in finite-set form, matching the layer-certificate interface. -/
theorem typeFamily_support_data {k d : ℕ} (t β : ℝ)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k)) {b : ℝ}
    (hslopes : ∀ e L, L ∈ Λ e → Cube β b L.slope)
    {J : Label d} (hJ : J ∈ typeFamily t β Λ) :
    ∃ U : Finset (Fin d), U.card = k ∧
      (∀ i ∈ U, β ≤ J.slope i ∧ J.slope i ≤ b) ∧
      (∀ i ∉ U, J.slope i = t) := by
  classical
  obtain ⟨e, L, hL, rfl⟩ := (mem_typeFamily t β Λ J).1 hJ
  refine ⟨Finset.univ.map e, by simp, ?_, ?_⟩
  · intro i hi
    obtain ⟨j, hj, rfl⟩ := Finset.mem_map.1 hi
    simpa only [Label.embed, embedCoordinates_apply] using hslopes e L hL j
  · intro i hi
    apply embedCoordinates_outside e t L.slope
    rintro ⟨j, rfl⟩
    exact hi (Finset.mem_map.2 ⟨j, Finset.mem_univ j, rfl⟩)

/-- Every support has a competitor equal to the baseline off that support. -/
theorem typeFamily_supported_competitor {k d : ℕ} (t β : ℝ)
    (Λ : (Fin k ↪ Fin d) → Finset (Label k))
    (hne : ∀ e, (Λ e).Nonempty)
    (U : Finset (Fin d)) (hU : U.card = k) :
    ∃ J ∈ typeFamily t β Λ, ∀ i ∉ U, J.slope i = t := by
  classical
  let e : Fin k ↪ Fin d := (U.orderEmbOfFin hU).toEmbedding
  obtain ⟨L, hL⟩ := hne e
  refine ⟨L.embed e t β, (mem_typeFamily t β Λ _).2 ⟨e, L, hL, rfl⟩, ?_⟩
  intro i hi
  apply embedCoordinates_outside e t L.slope
  have hrange : Set.range e = (U : Set (Fin d)) := Finset.range_orderEmbOfFin U hU
  simpa only [hrange, Finset.mem_coe] using hi

/-- A lower-dimensional little-offset quotient becomes the normalized `-1` offset
required of a positive type. -/
theorem Label.embed_normalized_offset {k d : ℕ} (e : Fin k ↪ Fin d)
    (t β : ℝ) (L : Label k)
    (hL : Tendsto (fun h : ℝ => L.offset h / h ^ β) (𝓝[>] 0) (𝓝 0)) :
    Tendsto (fun h : ℝ => (L.embed e t β).offset h / h ^ β)
      (𝓝[>] 0) (𝓝 (-1)) := by
  have heq : (fun h : ℝ => (L.embed e t β).offset h / h ^ β) =ᶠ[𝓝[>] 0]
      (fun h : ℝ => -1 + L.offset h / h ^ β) := by
    filter_upwards [self_mem_nhdsWithin] with h hh
    change (-h ^ β + L.offset h) / h ^ β = -1 + L.offset h / h ^ β
    rw [add_div, neg_div, div_self (ne_of_gt (Real.rpow_pos_of_pos hh β))]
  have ht : Tendsto (fun h : ℝ => -1 + L.offset h / h ^ β)
      (𝓝[>] 0) (𝓝 (-1)) := by
    simpa using tendsto_const_nhds.add hL
  exact ht.congr' heq.symm

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.AffineCertificates -/

namespace OAI

/-! Certificates for the dimension induction and interval gluing.

In particular a local certificate retains a strictly stronger offset decay
exponent. Merely retaining `o(h^t)` would not suffice for interval gluing.
-/

noncomputable section
open Filter Topology

namespace Problem326.Affine

/-- Sequential approximation on the whole exponent cube, allowing the
approximating sequence to lie outside the cube. -/
def SequentialApproximation {d : ℕ} (Λ : Finset (Label d))
    (a b : ℝ) (E : (Fin d → ℝ) → ℝ) : Prop :=
  ∀ L ∈ Λ, ∀ (h : ℕ → ℝ) (p : ℕ → (Fin d → ℝ)) (p₀ : Fin d → ℝ),
    (∀ n, 0 < h n) → Tendsto h atTop (𝓝 0) →
    Tendsto p atTop (𝓝 p₀) → Cube a b p₀ →
    (∀ n, Active Λ L (h n) (powerPoint (h n) (p n))) →
    ‖p₀ - L.slope‖ < E L.slope

/-- The conclusion of the affine approximation lemma in one dimension `d`.
The label set and its slopes are fixed before a small parameter is chosen. -/
structure FullCertificate (d : ℕ) (a b : ℝ) (E : (Fin d → ℝ) → ℝ) where
  labels : Finset (Label d)
  nonempty : labels.Nonempty
  slopes : ∀ L ∈ labels, Cube a b L.slope
  offsets : ∀ L ∈ labels,
    L.offset =o[𝓝[>] (0 : ℝ)] (fun h => h ^ a)
  approximation : SequentialApproximation labels a b E

/-- The output required at a fixed minimum before neighborhood extension.
`decay_gt` and `offsets` are essential data for the subsequent gluing step. -/
structure LocalCertificate (d : ℕ) (a b t : ℝ) (E : (Fin d → ℝ) → ℝ) where
  labels : Finset (Label d)
  baseline : (⟨fun _ => t, fun _ => 0⟩ : Label d) ∈ labels
  slopes : ∀ L ∈ labels, Cube t b L.slope
  minima : ∀ L ∈ labels, HasMinimum L.slope t
  decayExponent : ℝ
  decay_gt : t < decayExponent
  offsets : ∀ L ∈ labels,
    L.offset =o[𝓝[>] (0 : ℝ)] (fun h => h ^ decayExponent)
  approximation : ApproximatesAtMinimum labels a b t E

lemma LocalCertificate.nonempty {d : ℕ} {a b t : ℝ}
    {E : (Fin d → ℝ) → ℝ} (C : LocalCertificate d a b t E) : C.labels.Nonempty :=
  ⟨_, C.baseline⟩

/-- The fixed-minimum singleton construction in species dimension one. -/
def localCertificate_one (a b t : ℝ) (htb : t ≤ b)
    (E : (Fin 1 → ℝ) → ℝ) (hE : 0 < E (fun _ => t)) :
    LocalCertificate 1 a b t E := by
  classical
  refine {
    labels := {⟨fun _ => t, fun _ => 0⟩}
    baseline := by simp
    slopes := ?_
    minima := ?_
    decayExponent := t + 1
    decay_gt := by linarith
    offsets := ?_
    approximation := singleton_approximates_one a b t E hE
  }
  · intro L hL
    have hL' : L = (⟨fun _ => t, fun _ => 0⟩ : Label 1) := by simpa using hL
    subst L
    exact fun _ => ⟨le_rfl, htb⟩
  · intro L hL
    have hL' : L = (⟨fun _ => t, fun _ => 0⟩ : Label 1) := by simpa using hL
    subst L
    exact ⟨fun _ => le_rfl, ⟨0, rfl⟩⟩
  · intro L hL
    have hL' : L = (⟨fun _ => t, fun _ => 0⟩ : Label 1) := by simpa using hL
    subst L
    exact Asymptotics.isLittleO_zero _ _

/-- The fixed-minimum singleton construction at the upper corner. -/
def localCertificate_upper {d : ℕ} (hd : 0 < d) (a b : ℝ)
    (E : (Fin d → ℝ) → ℝ) (hE : 0 < E (fun _ => b)) :
    LocalCertificate d a b b E := by
  classical
  refine {
    labels := {⟨fun _ => b, fun _ => 0⟩}
    baseline := by simp
    slopes := ?_
    minima := ?_
    decayExponent := b + 1
    decay_gt := by linarith
    offsets := ?_
    approximation := singleton_approximates_upper a b E hE
  }
  · intro L hL
    have hL' : L = (⟨fun _ => b, fun _ => 0⟩ : Label d) := by simpa using hL
    subst L
    exact fun _ => ⟨le_rfl, le_rfl⟩
  · intro L hL
    have hL' : L = (⟨fun _ => b, fun _ => 0⟩ : Label d) := by simpa using hL
    subst L
    exact ⟨fun _ => le_rfl, ⟨⟨0, hd⟩, rfl⟩⟩
  · intro L hL
    have hL' : L = (⟨fun _ => b, fun _ => 0⟩ : Label d) := by simpa using hL
    subst L
    exact Asymptotics.isLittleO_zero _ _

/-- Harmless dimension-zero base for strong induction. It is not used as a
positive-dimensional fixed-minimum family. -/
def fullCertificate_zero (a b : ℝ) (E : (Fin 0 → ℝ) → ℝ)
    (hE : ∀ r, Cube a b r → 0 < E r) : FullCertificate 0 a b E := by
  classical
  let L : Label 0 := ⟨fun _ => a, fun _ => 0⟩
  refine {
    labels := {L}
    nonempty := Finset.singleton_nonempty L
    slopes := ?_
    offsets := ?_
    approximation := ?_
  }
  · intro J hJ i
    exact Fin.elim0 i
  · intro J hJ
    have hJL : J = L := by simpa using hJ
    subst J
    exact Asymptotics.isLittleO_zero _ _
  · intro J hJ h p p₀ hh hhlim hp hp₀ ha
    have hJL : J = L := by simpa using hJ
    subst J
    have heq : p₀ = L.slope := by funext i; exact Fin.elim0 i
    rw [heq, sub_self, norm_zero]
    exact hE L.slope (fun i => Fin.elim0 i)

/-- Strong induction assembles full certificates from fixed-minimum
certificates and finite interval gluing. -/
theorem fullCertificate_of_local_and_glue
    (construct : ∀ d : ℕ, 0 < d →
      (∀ k : ℕ, k < d → ∀ a b : ℝ, ∀ E : (Fin k → ℝ) → ℝ,
        a < b → (∀ r, Cube a b r → 0 < E r) → Nonempty (FullCertificate k a b E)) →
      ∀ a b : ℝ, ∀ E : (Fin d → ℝ) → ℝ,
        a < b → (∀ r, Cube a b r → 0 < E r) →
        ∀ t : ℝ, a ≤ t → t ≤ b → Nonempty (LocalCertificate d a b t E))
    (glue : ∀ d : ℕ, 0 < d → ∀ a b : ℝ, ∀ E : (Fin d → ℝ) → ℝ,
      a < b → (∀ r, Cube a b r → 0 < E r) →
      (∀ t : ℝ, a ≤ t → t ≤ b → Nonempty (LocalCertificate d a b t E)) →
      Nonempty (FullCertificate d a b E)) :
    ∀ d : ℕ, ∀ a b : ℝ, ∀ E : (Fin d → ℝ) → ℝ,
      a < b → (∀ r, Cube a b r → 0 < E r) → Nonempty (FullCertificate d a b E) := by
  intro d
  induction d using Nat.strong_induction_on with
  | h d ih =>
      intro a b E hab hE
      by_cases hd : d = 0
      · subst d
        exact ⟨fullCertificate_zero a b E hE⟩
      · have hdpos : 0 < d := Nat.pos_of_ne_zero hd
        exact glue d hdpos a b E hab hE (construct d hdpos ih a b E hab hE)

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.LayerSequence -/

namespace OAI

universe uAlpha

noncomputable section

namespace Problem326.Affine

/-- Build the finite sequence of type families used at a fixed minimum.
Each new threshold is chosen only after the preceding finite family, so arbitrary
positive label-dependent tolerances are allowed. The family constructor may
itself depend on the chosen threshold. -/
theorem exists_layer_sequence {α : Type uAlpha} (n : ℕ) {t b : ℝ} (htb : t < b)
    (E : α → ℝ) (F₀ : Finset α) (hE₀ : ∀ a ∈ F₀, 0 < E a)
    (Good : ℕ → ℝ → Finset α → Prop)
    (hmake : ∀ k : ℕ, 0 < k → k ≤ n → ∀ β : ℝ, t < β → β < b →
      ∃ F : Finset α, Good k β F ∧ ∀ a ∈ F, 0 < E a) :
    ∃ (β : ℕ → ℝ) (F : ℕ → Finset α),
      β 0 = b ∧ F 0 = F₀ ∧
      (∀ k, t < β k ∧ β k ≤ b ∧ ∀ a ∈ F k, 0 < E a) ∧
      ∀ k < n, β (k + 1) < β k ∧
        (∀ a ∈ F k, β (k + 1) - t < E a) ∧
        Good (k + 1) (β (k + 1)) (F (k + 1)) := by
  classical
  let S := {q : ℝ × Finset α // t < q.1 ∧ q.1 ≤ b ∧ ∀ a ∈ q.2, 0 < E a}
  let s₀ : S := ⟨(b, F₀), htb, le_rfl, hE₀⟩
  have hs : ∀ k : ℕ, ∀ s : S, ∃ s' : S, k < n →
      s'.val.1 < s.val.1 ∧
      (∀ a ∈ s.val.2, s'.val.1 - t < E a) ∧
      Good (k + 1) s'.val.1 s'.val.2 := by
    intro k s
    by_cases hk : k < n
    · obtain ⟨β, htβ, hβupper, hβE⟩ :=
        exists_threshold s.val.2 E s.property.2.2 s.property.1
      have hβb : β < b := hβupper.trans_le s.property.2.1
      obtain ⟨F, hFgood, hFE⟩ := hmake (k + 1) (by omega) (by omega) β htβ hβb
      exact ⟨⟨(β, F), htβ, hβb.le, hFE⟩, fun _ => ⟨hβupper, hβE, hFgood⟩⟩
    · exact ⟨s, fun h => (hk h).elim⟩
  choose next hnext using hs
  let state : ℕ → S := Nat.rec s₀ (fun k s => next k s)
  refine ⟨fun k => (state k).val.1, fun k => (state k).val.2, rfl, rfl, ?_, ?_⟩
  · intro k
    exact (state k).property
  · intro k hk
    exact hnext k (state k) hk

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.FixedMinimumEstimates -/

namespace OAI

universe uIota

noncomputable section

open Filter Finset
open scoped Topology BigOperators

namespace Problem326.FixedMinimum

/-- The affine value relative to the constant-slope branch `t`. -/
def relativeValue {ι : Type uIota} [Fintype ι]
    (t : ℝ) (r p : ι → ℝ) (h c : ℝ) : ℝ :=
  (∑ i, (r i - t) * h ^ p i) + c

/-- A strict limiting exponent gap makes the normalized monomial vanish.
This formulation permits the approximating exponents to leave their cube. -/
theorem tendsto_rpow_ratio {h p : ℕ → ℝ} {q p₀ : ℝ}
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hp : Tendsto p atTop (𝓝 p₀)) (hqp : q < p₀) :
    Tendsto (fun n => h n ^ p n / h n ^ q) atTop (𝓝 0) := by
  have hlim := hh0.rpow (hp.sub_const q) (Or.inr (sub_pos.mpr hqp))
  simp only [Real.zero_rpow (ne_of_gt (sub_pos.mpr hqp))] at hlim
  convert hlim using 1
  ext n
  exact (Real.rpow_sub (hh n) (p n) q).symm

/-- Finite sums of monomials whose nonzero coefficients have exponent above `q`
are negligible relative to `h^q`. -/
theorem tendsto_normalized_sum {ι : Type uIota} [Fintype ι]
    {h : ℕ → ℝ} {p : ℕ → ι → ℝ} {p₀ a : ι → ℝ} {q : ℝ}
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hp : ∀ i, Tendsto (fun n => p n i) atTop (𝓝 (p₀ i)))
    (hgap : ∀ i, a i ≠ 0 → q < p₀ i) :
    Tendsto (fun n => (∑ i, a i * h n ^ p n i) / h n ^ q)
      atTop (𝓝 0) := by
  have hterm : ∀ i, Tendsto (fun n => a i * (h n ^ p n i / h n ^ q))
      atTop (𝓝 0) := by
    intro i
    by_cases hai : a i = 0
    · simp [hai]
    · simpa using (tendsto_rpow_ratio hh hh0 (hp i) (hgap i hai)).const_mul (a i)
  have hs := tendsto_finsetSum Finset.univ (fun i _ => hterm i)
  simpa only [Finset.sum_const_zero, Finset.sum_div, mul_div_assoc] using hs

/-- A positive coefficient in a nonnegative sum cannot be dominated by a
strictly higher exponent, even in the presence of a negligible offset. -/
theorem coefficient_nonpos_of_domination
    {A B d : ℕ → ℝ} {c : ℝ}
    (hA : ∀ n, 0 < A n) (hB : ∀ n, 0 < B n)
    (hBA : Tendsto (fun n => B n / A n) atTop (𝓝 0))
    (hd : Tendsto (fun n => d n / B n) atTop (𝓝 0))
    (hdom : ∀ n, c * A n ≤ B n - d n) : c ≤ 0 := by
  have hlim : Tendsto (fun n => (B n / A n) * (1 - d n / B n))
      atTop (𝓝 0) := by
    simpa using hBA.mul (tendsto_const_nhds.sub hd)
  apply ge_of_tendsto hlim
  filter_upwards [] with n
  have h := (le_div_iff₀ (hA n)).2 (hdom n)
  convert h using 1
  field_simp [ne_of_gt (hA n), ne_of_gt (hB n)]

/-- The quotient version also allows a moving denominator exponent. -/
theorem tendsto_rpow_ratio_of_gap {h p q : ℕ → ℝ} {p₀ q₀ : ℝ}
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hp : Tendsto p atTop (𝓝 p₀)) (hq : Tendsto q atTop (𝓝 q₀))
    (hqp : q₀ < p₀) :
    Tendsto (fun n => h n ^ p n / h n ^ q n) atTop (𝓝 0) := by
  have hlim := hh0.rpow (hp.sub hq) (Or.inr (sub_pos.mpr hqp))
  simp only [Real.zero_rpow (ne_of_gt (sub_pos.mpr hqp))] at hlim
  convert hlim using 1
  ext n
  exact (Real.rpow_sub (hh n) (p n) (q n)).symm

/-- Nonnegative raised coordinates of an active branch cannot have limiting
exponent below the offset exponent. -/
theorem active_raised_exponent_ge {ι : Type uIota} [Fintype ι]
    {h c : ℕ → ℝ} {p : ℕ → ι → ℝ} {p₀ r : ι → ℝ} {t β : ℝ}
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hp : ∀ i, Tendsto (fun n => p n i) atTop (𝓝 (p₀ i)))
    (hr : ∀ i, t ≤ r i)
    (hc : Tendsto (fun n => c n / h n ^ β) atTop (𝓝 (-1)))
    (hactive : ∀ n, relativeValue t r (p n) (h n) (c n) ≤ 0)
    {i : ι} (hi : t < r i) : β ≤ p₀ i := by
  by_contra hle
  have hlt : p₀ i < β := lt_of_not_ge hle
  have hratio : Tendsto (fun n => h n ^ β / h n ^ p n i) atTop (𝓝 0) :=
    tendsto_rpow_ratio_of_gap hh hh0 tendsto_const_nhds (hp i) hlt
  have hlim : Tendsto (fun n => (-c n / h n ^ β) *
      (h n ^ β / h n ^ p n i)) atTop (𝓝 0) := by
    simpa only [neg_div, neg_neg, one_mul, mul_zero] using hc.neg.mul hratio
  have hnonpos : r i - t ≤ 0 := by
    apply ge_of_tendsto hlim
    filter_upwards [] with n
    have hsingle : (r i - t) * h n ^ p n i ≤
        ∑ j, (r j - t) * h n ^ p n j := by
      exact Finset.single_le_sum
        (fun j _ => mul_nonneg (sub_nonneg.mpr (hr j)) (Real.rpow_nonneg (hh n).le _))
        (Finset.mem_univ i)
    have hbound : (r i - t) * h n ^ p n i ≤ -c n := by
      have ha := hactive n
      unfold relativeValue at ha
      linarith
    have hdiv := (le_div_iff₀ (Real.rpow_pos_of_pos (hh n) (p n i))).2 hbound
    convert hdiv using 1
    field_simp [ne_of_gt (Real.rpow_pos_of_pos (hh n) β)]
  linarith

/-- A competitor with normalized value tending to `-1` defeats any branch
whose slope is coordinatewise above the baseline and whose normalized
offset tends to zero. No continuity of either offset is needed. -/
theorem not_active_of_offset_gap {ι : Type uIota} [Fintype ι]
    {h c d : ℕ → ℝ} {p : ℕ → ι → ℝ} {p₀ r s : ι → ℝ} {t γ : ℝ}
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hp : ∀ i, Tendsto (fun n => p n i) atTop (𝓝 (p₀ i)))
    (hr : ∀ i, t ≤ r i)
    (hc : Tendsto (fun n => c n / h n ^ γ) atTop (𝓝 0))
    (hd : Tendsto (fun n => d n / h n ^ γ) atTop (𝓝 (-1)))
    (hgap : ∀ i, s i ≠ t → γ < p₀ i) :
    ¬ (∀ n, relativeValue t r (p n) (h n) (c n) ≤
      relativeValue t s (p n) (h n) (d n)) := by
  intro hactive
  have hsum : Tendsto (fun n => (∑ i, (s i - t) * h n ^ p n i) /
      h n ^ γ) atTop (𝓝 0) :=
    tendsto_normalized_sum hh hh0 hp (fun i hi => hgap i (sub_ne_zero.mp hi))
  have hvalue : Tendsto (fun n => relativeValue t s (p n) (h n) (d n) /
      h n ^ γ) atTop (𝓝 (-1)) := by
    simpa only [relativeValue, add_div, zero_add] using hsum.add hd
  have hbad : (0 : ℝ) ≤ -1 := by
    apply le_of_tendsto_of_tendsto hc hvalue
    filter_upwards [] with n
    apply (div_le_div_iff_of_pos_right (Real.rpow_pos_of_pos (hh n) γ)).2
    have hsum0 : 0 ≤ ∑ i, (r i - t) * h n ^ p n i := by
      exact Finset.sum_nonneg fun i _ =>
        mul_nonneg (sub_nonneg.mpr (hr i)) (Real.rpow_nonneg (hh n).le _)
    have ha := hactive n
    unfold relativeValue at ha ⊢
    linarith
  norm_num at hbad

/-- The second exclusion in the fixed-minimum argument. A next-type
competitor supported on `U ∪ {j}` forces every unraised exponent below
its offset threshold. -/
theorem unraised_exponent_le {ι : Type uIota} [Fintype ι] [DecidableEq ι]
    {h c d : ℕ → ℝ} {p : ℕ → ι → ℝ} {p₀ r s : ι → ℝ}
    {t β γ : ℝ} {U : Finset ι} {j : ι}
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hp : ∀ i, Tendsto (fun n => p n i) atTop (𝓝 (p₀ i)))
    (hr : ∀ i, t ≤ r i)
    (hc : Tendsto (fun n => c n / h n ^ γ) atTop (𝓝 0))
    (hd : Tendsto (fun n => d n / h n ^ γ) atTop (𝓝 (-1)))
    (hγβ : γ < β) (hpU : ∀ i ∈ U, β ≤ p₀ i)
    (hs : ∀ i, i ∉ U → i ≠ j → s i = t)
    (hactive : ∀ n, relativeValue t r (p n) (h n) (c n) ≤
      relativeValue t s (p n) (h n) (d n)) : p₀ j ≤ γ := by
  by_contra hj
  have hj' : γ < p₀ j := lt_of_not_ge hj
  apply not_active_of_offset_gap hh hh0 hp hr hc hd _ hactive
  intro i hi
  by_cases hiU : i ∈ U
  · exact hγβ.trans_le (hpU i hiU)
  · have hij : i = j := by
      by_contra hij
      exact hi (hs i hiU hij)
    simpa only [hij] using hj'

/-- When only one coordinate is unraised, the fixed minimum determines
that coordinate exactly. -/
theorem last_unraised_eq_minimum {ι : Type uIota} {p : ι → ℝ} {t β : ℝ} {j : ι}
    (hmin : ∃ i, p i = t) (htβ : t < β)
    (hother : ∀ i, i ≠ j → β ≤ p i) : p j = t := by
  obtain ⟨i, hi⟩ := hmin
  have hij : i = j := by
    by_contra hij
    have h := hother i hij
    rw [hi] at h
    exact (not_le_of_gt htβ) h
  simpa only [hij] using hi

/-- Combining the inductive error on raised coordinates with the threshold
bound on all other coordinates yields the full sup-norm error estimate. -/
theorem error_of_raised_and_unraised {ι : Type uIota} [Fintype ι]
    {p r : ι → ℝ} {U : Set ι} {t γ ε : ℝ}
    (hraised : ∀ i ∈ U, |p i - r i| < ε)
    (hr : ∀ i ∉ U, r i = t)
    (hlo : ∀ i ∉ U, t ≤ p i)
    (hhi : ∀ i ∉ U, p i ≤ γ) (hε : γ - t < ε) :
    ∀ i, |p i - r i| < ε := by
  intro i
  by_cases hi : i ∈ U
  · exact hraised i hi
  · rw [hr i hi, abs_of_nonneg (sub_nonneg.mpr (hlo i hi))]
    exact (sub_le_sub_right (hhi i hi) t).trans_lt hε

theorem fixed_minimum_label_bound {ι : Type uIota} [Fintype ι] [DecidableEq ι]
    {h c : ℕ → ℝ} {p : ℕ → ι → ℝ} {p₀ r : ι → ℝ}
    {t β ε : ℝ} {U : Finset ι}
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (𝓝 0))
    (hp : ∀ i, Tendsto (fun n => p n i) atTop (𝓝 (p₀ i)))
    (hlo : ∀ i, t ≤ p₀ i) (hmin : ∃ i, p₀ i = t)
    (htβ : t < β) (hε : 0 < ε)
    (hrin : ∀ i ∈ U, β ≤ r i) (hrout : ∀ i ∉ U, r i = t)
    (hoffset : (U = ∅ ∧ ∀ n, c n = 0) ∨
      Tendsto (fun n => c n / h n ^ β) atTop (𝓝 (-1)))
    (hbase : ∀ n, relativeValue t r (p n) (h n) (c n) ≤ 0)
    (hind : (∀ i ∈ U, β ≤ p₀ i) → ∀ i ∈ U, |p₀ i - r i| < ε)
    (hnext : (∀ i ∉ U, ∀ j ∉ U, i = j) ∨
      ∃ γ : ℝ, γ < β ∧ γ - t < ε ∧
        ∀ j, j ∉ U → ∃ s : ι → ℝ, ∃ d : ℕ → ℝ,
          Tendsto (fun n => d n / h n ^ γ) atTop (𝓝 (-1)) ∧
          (∀ i, i ∉ U → i ≠ j → s i = t) ∧
          (∀ n, relativeValue t r (p n) (h n) (c n) ≤
            relativeValue t s (p n) (h n) (d n))) :
    ∀ i, |p₀ i - r i| < ε := by
  have hr : ∀ i, t ≤ r i := by
    intro i
    by_cases hi : i ∈ U
    · exact htβ.le.trans (hrin i hi)
    · rw [hrout i hi]
  have hpU : ∀ i ∈ U, β ≤ p₀ i := by
    intro i hi
    rcases hoffset with ⟨hU, _⟩ | hc
    · simp [hU] at hi
    · exact active_raised_exponent_ge hh hh0 hp hr hc hbase
        (htβ.trans_le (hrin i hi))
  have herrU := hind hpU
  rcases hnext with hlast | ⟨γ, hγβ, hγε, hcomp⟩
  · obtain ⟨j, hj⟩ := hmin
    have hjU : j ∉ U := by
      intro hjU
      have hb := hpU j hjU
      rw [hj] at hb
      exact (not_le_of_gt htβ) hb
    intro i
    by_cases hi : i ∈ U
    · exact herrU i hi
    · have hij := hlast i hi j hjU
      rw [hrout i hi, hij, hj, sub_self, abs_zero]
      exact hε
  · have hcγ : Tendsto (fun n => c n / h n ^ γ) atTop (𝓝 0) := by
      rcases hoffset with ⟨_, hc⟩ | hc
      · have hz : (fun n => c n / h n ^ γ) = fun _ => 0 := by
          funext n
          simp only [hc n, zero_div]
        rw [hz]
        exact tendsto_const_nhds
      · have hratio := tendsto_rpow_ratio hh hh0
          (show Tendsto (fun _ : ℕ => β) atTop (𝓝 β) from tendsto_const_nhds) hγβ
        have hlim := hc.mul hratio
        simp only [mul_zero] at hlim
        convert hlim using 1
        funext n
        field_simp [ne_of_gt (Real.rpow_pos_of_pos (hh n) β)]
    have hpout : ∀ j ∉ U, p₀ j ≤ γ := by
      intro j hj
      obtain ⟨s, d, hd, hs, ha⟩ := hcomp j hj
      exact unraised_exponent_le hh hh0 hp hr hcγ hd hγβ hpU hs ha
    exact error_of_raised_and_unraised (U := (↑U : Set ι))
      herrU hrout (fun i _ => hlo i) hpout hγε

end Problem326.FixedMinimum

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.AffineLayers -/

namespace OAI

open Filter Topology

noncomputable section
namespace Problem326.Affine

/-- The lower-dimensional induction hypothesis, transported to one support. -/
def ApproximatesOnSupport {d : ℕ} (F : Finset (Label d)) (L : Label d)
    (U : Finset (Fin d)) (t b β : ℝ) (E : (Fin d → ℝ) → ℝ) : Prop :=
  ∀ (h : ℕ → ℝ) (p : ℕ → (Fin d → ℝ)) (p₀ : Fin d → ℝ),
    (∀ n, 0 < h n) → Tendsto h atTop (𝓝 0) →
    Tendsto p atTop (𝓝 p₀) → Cube t b p₀ →
    (∀ i ∈ U, β ≤ p₀ i) →
    (∀ n, Active F L (h n) (powerPoint (h n) (p n))) →
    ∀ i ∈ U, |p₀ i - L.slope i| < E L.slope

/-- Exactly the information needed from one recursively constructed type family.
The zero type is the constant baseline; positive types have normalized offset -1.
No continuity of offsets or tolerances is assumed. -/
structure LayerCertificate {d : ℕ} (t b : ℝ) (E : (Fin d → ℝ) → ℝ)
    (k : ℕ) (β : ℝ) (F : Finset (Label d)) : Prop where
  tolerance_pos : ∀ L ∈ F, 0 < E L.slope
  support_data : ∀ L ∈ F, ∃ U : Finset (Fin d),
    U.card = k ∧
    (∀ i ∈ U, β ≤ L.slope i ∧ L.slope i ≤ b) ∧
    (∀ i ∉ U, L.slope i = t) ∧
    (k = 0 → ∀ h, L.offset h = 0) ∧
    (0 < k → Tendsto (fun h : ℝ => L.offset h / h ^ β)
      (𝓝[>] (0 : ℝ)) (𝓝 (-1))) ∧
    ApproximatesOnSupport F L U t b β E
  supported_competitor : ∀ U : Finset (Fin d), U.card = k →
    ∃ L ∈ F, ∀ i ∉ U, L.slope i = t

def baselineLabel (d : ℕ) (t : ℝ) : Label d := ⟨fun _ => t, fun _ => 0⟩

lemma baseline_layer_certificate {d : ℕ} {t b β : ℝ}
    (E : (Fin d → ℝ) → ℝ) (hE : 0 < E (fun _ => t)) :
    LayerCertificate t b E 0 β {baselineLabel d t} := by
  classical
  refine ⟨?_, ?_, ?_⟩
  · intro L hL
    have hL' : L = baselineLabel d t := by simpa using hL
    subst L
    exact hE
  · intro L hL
    have hL' : L = baselineLabel d t := by simpa using hL
    subst L
    refine ⟨∅, rfl, by simp, ?_, ?_, ?_, ?_⟩
    · simp [baselineLabel]
    · simp [baselineLabel]
    · simp
    · intro h p p₀ hh hh0 hp hp₀ hU ha i hi
      simp at hi
  · intro U hU
    have hU' : U = ∅ := Finset.card_eq_zero.mp hU
    refine ⟨baselineLabel d t, by simp, ?_⟩
    simp [baselineLabel]

lemma relativeValue_le_iff {d : ℕ} (t : ℝ) (L J : Label d)
    (h : ℝ) (p : Fin d → ℝ) :
    FixedMinimum.relativeValue t L.slope p h (L.offset h) ≤
      FixedMinimum.relativeValue t J.slope p h (J.offset h) ↔
    L.value h (powerPoint h p) ≤ J.value h (powerPoint h p) := by
  unfold FixedMinimum.relativeValue Label.value powerPoint
  simp only [sub_mul, Finset.sum_sub_distrib]
  constructor <;> intro hle <;> linarith

lemma relativeValue_baseline {d : ℕ} (t h : ℝ) (p : Fin d → ℝ) :
    FixedMinimum.relativeValue t (baselineLabel d t).slope p h
      ((baselineLabel d t).offset h) = 0 := by
  simp [FixedMinimum.relativeValue, baselineLabel]

/-- The union of all types, numbered from zero through `d - 1`. -/
def layerUnion (d : ℕ) (F : ℕ → Finset (Label d)) : Finset (Label d) := by
  classical
  exact (Finset.range d).biUnion F

lemma subset_layerUnion {d k : ℕ} (F : ℕ → Finset (Label d)) (hk : k < d) :
    F k ⊆ layerUnion d F := by
  classical
  intro L hL
  exact Finset.mem_biUnion.mpr ⟨k, Finset.mem_range.mpr hk, hL⟩

theorem layerUnion_approximatesAtMinimum {d : ℕ} (hd : 0 < d)
    {a t b : ℝ} (E : (Fin d → ℝ) → ℝ)
    (β : ℕ → ℝ) (F : ℕ → Finset (Label d))
    (hF₀ : F 0 = {baselineLabel d t})
    (hβ : ∀ k < d, t < β k)
    (hcert : ∀ k < d, LayerCertificate t b E k (β k) (F k))
    (hstep : ∀ k, k + 1 < d → β (k + 1) < β k ∧
      ∀ L ∈ F k, β (k + 1) - t < E L.slope) :
    ApproximatesAtMinimum (layerUnion d F) a b t E := by
  classical
  intro L hLall h p p₀ hh hh0 hp hp₀ hm ha
  obtain ⟨k, hk, hL⟩ := Finset.mem_biUnion.mp hLall
  have hkd : k < d := Finset.mem_range.mp hk
  have hc := hcert k hkd
  obtain ⟨U, hUcard, hUin, hUout, hzero, hoffset, hind⟩ := hc.support_data L hL
  have hε : 0 < E L.slope := hc.tolerance_pos L hL
  have hhwithin : Tendsto h atTop (𝓝[>] (0 : ℝ)) :=
    tendsto_nhdsWithin_iff.mpr ⟨hh0, Filter.Eventually.of_forall hh⟩
  have hbaseMem : baselineLabel d t ∈ layerUnion d F := by
    apply subset_layerUnion F hd
    rw [hF₀]
    simp
  have hbase : ∀ n, FixedMinimum.relativeValue t L.slope (p n) (h n) (L.offset (h n)) ≤ 0 := by
    intro n
    have hv := (ha n).2 (baselineLabel d t) hbaseMem
    have hr := (relativeValue_le_iff t L (baselineLabel d t) (h n) (p n)).mpr hv
    simpa only [relativeValue_baseline] using hr
  have hOff : (U = ∅ ∧ ∀ n, L.offset (h n) = 0) ∨
      Tendsto (fun n => L.offset (h n) / h n ^ β k) atTop (𝓝 (-1)) := by
    by_cases hk0 : k = 0
    · exact Or.inl ⟨Finset.card_eq_zero.mp (hUcard.trans hk0), fun n => hzero hk0 (h n)⟩
    · exact Or.inr ((hoffset (Nat.pos_of_ne_zero hk0)).comp hhwithin)
  have hInd : (∀ i ∈ U, β k ≤ p₀ i) →
      ∀ i ∈ U, |p₀ i - L.slope i| < E L.slope := by
    intro hraised
    apply hind h p p₀ hh hh0 hp (fun i => ⟨hm.1 i, (hp₀ i).2⟩) hraised
    intro n
    exact active_mono (subset_layerUnion F hkd) hL (ha n)
  have hNext : (∀ i ∉ U, ∀ j ∉ U, i = j) ∨
      ∃ γ : ℝ, γ < β k ∧ γ - t < E L.slope ∧
        ∀ j, j ∉ U → ∃ s : Fin d → ℝ, ∃ c : ℕ → ℝ,
          Tendsto (fun n => c n / h n ^ γ) atTop (𝓝 (-1)) ∧
          (∀ i, i ∉ U → i ≠ j → s i = t) ∧
          (∀ n, FixedMinimum.relativeValue t L.slope (p n) (h n) (L.offset (h n)) ≤
            FixedMinimum.relativeValue t s (p n) (h n) (c n)) := by
    by_cases hkNext : k + 1 < d
    · right
      refine ⟨β (k + 1), (hstep k hkNext).1, (hstep k hkNext).2 L hL, ?_⟩
      intro j hj
      have hC := hcert (k + 1) hkNext
      obtain ⟨J, hJ, hJout⟩ := hC.supported_competitor (insert j U) (by simp [hj, hUcard])
      obtain ⟨V, hVcard, hVin, hVout, hVzero, hVoffset, hVind⟩ := hC.support_data J hJ
      refine ⟨J.slope, fun n => J.offset (h n), (hVoffset (by omega)).comp hhwithin, ?_, ?_⟩
      · intro i hi hij
        apply hJout i
        simp [hi, hij]
      · intro n
        apply (relativeValue_le_iff t L J (h n) (p n)).mpr
        exact (ha n).2 J (subset_layerUnion F hkNext hJ)
    · left
      have hcard : (Finset.univ \ U).card ≤ 1 := by
        rw [Finset.card_sdiff_of_subset (Finset.subset_univ U)]
        simp only [Finset.card_univ, Fintype.card_fin, hUcard]
        omega
      intro i hi j hj
      exact (Finset.card_le_one.mp hcard) i (by simp [hi]) j (by simp [hj])
  have hbound := FixedMinimum.fixed_minimum_label_bound hh hh0
    (fun i => (tendsto_pi_nhds.mp hp) i) hm.1 hm.2 (hβ k hkd) hε
    (fun i hi => (hUin i hi).1) hUout hOff hbase hInd hNext
  apply (pi_norm_lt_iff hε).mpr
  intro i
  simpa only [Pi.sub_apply, Real.norm_eq_abs] using hbound i

/-- A normalized leading power is negligible relative to each strictly lower
power. This yields the stronger local offset decay, not merely decay at `t`. -/
lemma offset_isLittleO_of_normalized_limit {c : ℝ → ℝ} {β q A : ℝ}
    (hqβ : q < β)
    (hc : Tendsto (fun h : ℝ => c h / h ^ β) (𝓝[>] (0 : ℝ)) (𝓝 A)) :
    Asymptotics.IsLittleO (𝓝[>] (0 : ℝ)) c (fun h : ℝ => h ^ q) := by
  have hid : Tendsto (fun h : ℝ => h) (𝓝[>] (0 : ℝ)) (𝓝 0) :=
    continuousWithinAt_id
  have hpow : Tendsto (fun h : ℝ => h ^ β / h ^ q)
      (𝓝[>] (0 : ℝ)) (𝓝 0) := by
    have hlim := hid.rpow_const_nhds_zero (sub_pos.mpr hqβ)
    apply hlim.congr'
    filter_upwards [self_mem_nhdsWithin] with h hh
    exact Real.rpow_sub hh β q
  have hlim := hc.mul hpow
  simp only [mul_zero] at hlim
  apply (Asymptotics.isLittleO_iff_tendsto' ?_).mpr
  · apply hlim.congr'
    filter_upwards [self_mem_nhdsWithin] with h hh
    have hne : h ^ β ≠ 0 := ne_of_gt (Real.rpow_pos_of_pos hh β)
    field_simp [hne]
  · filter_upwards [self_mem_nhdsWithin] with h hh
    exact fun hzero => (ne_of_gt (Real.rpow_pos_of_pos hh q) hzero).elim

/-- The actual finite dependent construction at one fixed minimum, separated
from the lower-dimensional embedding used to produce each positive-type layer.
The returned decay has a strictly higher exponent than `t`, allowing localization. -/
theorem exists_fixed_minimum_family_of_layers {d : ℕ} (hd : 0 < d)
    {a t b : ℝ} (htb : t < b) (E : (Fin d → ℝ) → ℝ)
    (hE₀ : 0 < E (fun _ => t))
    (hmake : ∀ k : ℕ, 0 < k → k < d → ∀ β : ℝ, t < β → β < b →
      ∃ F : Finset (Label d), LayerCertificate t b E k β F) :
    ∃ Λ : Finset (Label d), baselineLabel d t ∈ Λ ∧
      ApproximatesAtMinimum Λ a b t E ∧
      ∀ L ∈ Λ, Cube t b L.slope ∧ HasMinimum L.slope t ∧
        ∃ q : ℝ, t < q ∧
          Asymptotics.IsLittleO (𝓝[>] (0 : ℝ)) L.offset (fun h : ℝ => h ^ q) := by
  classical
  obtain ⟨β, F, hβ₀, hF₀, hvalid, hnext⟩ :=
    exists_layer_sequence (d - 1) htb (fun L : Label d => E L.slope)
      {baselineLabel d t}
      (by intro L hL; have hL' : L = baselineLabel d t := by simpa using hL
          subst L; exact hE₀)
      (fun k β F => LayerCertificate t b E k β F)
      (by
        intro k hk hkd β htβ hβb
        obtain ⟨F, hF⟩ := hmake k hk (by omega) β htβ hβb
        exact ⟨F, hF, hF.tolerance_pos⟩)
  have hcert : ∀ k < d, LayerCertificate t b E k (β k) (F k) := by
    intro k hkd
    by_cases hk0 : k = 0
    · subst k
      rw [hF₀]
      exact baseline_layer_certificate E hE₀
    · have hkpred : k - 1 < d - 1 := by omega
      have hgood := (hnext (k - 1) hkpred).2.2
      simpa only [Nat.sub_add_cancel (Nat.one_le_iff_ne_zero.mpr hk0)] using hgood
  have hstep : ∀ k, k + 1 < d → β (k + 1) < β k ∧
      ∀ L ∈ F k, β (k + 1) - t < E L.slope := by
    intro k hk
    exact ⟨(hnext k (by omega)).1, (hnext k (by omega)).2.1⟩
  refine ⟨layerUnion d F, ?_, ?_, ?_⟩
  · apply subset_layerUnion F hd
    rw [hF₀]
    simp
  · exact layerUnion_approximatesAtMinimum hd E β F hF₀
      (fun k _ => (hvalid k).1) hcert hstep
  · intro L hLall
    obtain ⟨k, hk, hL⟩ := Finset.mem_biUnion.mp hLall
    have hkd : k < d := Finset.mem_range.mp hk
    obtain ⟨U, hUcard, hUin, hUout, hzero, hoffset, hind⟩ :=
      (hcert k hkd).support_data L hL
    have hlow : ∀ i, t ≤ L.slope i := by
      intro i
      by_cases hi : i ∈ U
      · exact (hvalid k).1.le.trans (hUin i hi).1
      · rw [hUout i hi]
    have hcube : Cube t b L.slope := by
      intro i
      refine ⟨hlow i, ?_⟩
      by_cases hi : i ∈ U
      · exact (hUin i hi).2
      · rw [hUout i hi]
        exact htb.le
    have hnotall : ¬ ∀ i, i ∈ U := by
      intro hall
      have hUuniv : U = Finset.univ := Finset.eq_univ_of_forall hall
      rw [hUuniv, Finset.card_univ, Fintype.card_fin] at hUcard
      omega
    obtain ⟨i, hi⟩ := not_forall.mp hnotall
    refine ⟨hcube, ⟨hlow, i, hUout i hi⟩, ?_⟩
    let q := (t + β k) / 2
    have htq : t < q := by dsimp [q]; linarith [(hvalid k).1]
    have hqβ : q < β k := by dsimp [q]; linarith [(hvalid k).1]
    refine ⟨q, htq, ?_⟩
    by_cases hk0 : k = 0
    · have hz : L.offset = fun _ => 0 := funext (hzero hk0)
      rw [hz]
      exact Asymptotics.isLittleO_zero _ _
    · exact offset_isLittleO_of_normalized_limit hqβ (hoffset (Nat.pos_of_ne_zero hk0))

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.TypeFamilyCertificate -/

namespace OAI

noncomputable section
open Filter Topology

namespace Problem326.Affine

local instance {d : ℕ} : DecidableEq (Label d) := Classical.decEq _

/-- Project the full lower-dimensional approximation certificate into a member of the
injection-indexed type family. The approximating exponents need not stay in any cube. -/
theorem typeFamily_approximatesOnSupport {k d : ℕ} (t β b : ℝ)
    (E : (Fin d → ℝ) → ℝ)
    (C : ∀ e : Fin k ↪ Fin d,
      FullCertificate k β b (fun s => E (embedCoordinates e t s)))
    (e : Fin k ↪ Fin d) {L : Label k} (hL : L ∈ (C e).labels) :
    ApproximatesOnSupport
      (typeFamily t β (fun e => (C e).labels)) (L.embed e t β)
      (Finset.univ.map e) t b β E := by
  intro h p p₀ hh hh0 hp hp₀ hraised ha
  have hpProj : Cube β b (fun j => p₀ (e j)) := by
    intro j
    exact ⟨hraised (e j) (Finset.mem_map.2 ⟨j, Finset.mem_univ j, rfl⟩), (hp₀ (e j)).2⟩
  have hlocal : ∀ n, Active (C e).labels L (h n)
      (powerPoint (h n) (fun j => p n (e j))) := by
    intro n
    exact typeFamily_active_project t β (h n) (fun e => (C e).labels) e hL (p n) (ha n)
  have herr := (C e).approximation L hL h (fun n j => p n (e j))
    (fun j => p₀ (e j)) hh hh0 (tendsto_project_coordinates e hp) hpProj hlocal
  intro i hi
  obtain ⟨j, hj, rfl⟩ := Finset.mem_map.1 hi
  exact embedded_error_on_range e t herr (e j) ⟨j, rfl⟩

/-- The actual positive-type constructor: lower-dimensional full certificates for every
coordinate injection produce the exact layer certificate consumed by fixed-minimum assembly. -/
theorem typeFamily_layerCertificate {k d : ℕ} (hk : 0 < k)
    {t β b : ℝ} (htβ : t < β) (hβb : β < b)
    (E : (Fin d → ℝ) → ℝ)
    (hE : ∀ r, Cube t b r → 0 < E r)
    (C : ∀ e : Fin k ↪ Fin d,
      FullCertificate k β b (fun s => E (embedCoordinates e t s))) :
    LayerCertificate t b E k β (typeFamily t β (fun e => (C e).labels)) := by
  classical
  constructor
  · intro J hJ
    obtain ⟨e, L, hL, rfl⟩ := (mem_typeFamily t β (fun e => (C e).labels) J).1 hJ
    apply hE
    exact cube_embedCoordinates e le_rfl htβ.le (htβ.trans hβb).le ((C e).slopes L hL)
  · intro J hJ
    obtain ⟨e, L, hL, rfl⟩ := (mem_typeFamily t β (fun e => (C e).labels) J).1 hJ
    refine ⟨Finset.univ.map e, by simp, ?_, ?_, ?_, ?_, ?_⟩
    · intro i hi
      obtain ⟨j, hj, rfl⟩ := Finset.mem_map.1 hi
      simpa only [Label.embed, embedCoordinates_apply] using (C e).slopes L hL j
    · intro i hi
      apply embedCoordinates_outside e t L.slope
      rintro ⟨j, rfl⟩
      exact hi (Finset.mem_map.2 ⟨j, Finset.mem_univ j, rfl⟩)
    · intro hk0
      omega
    · intro _
      exact Label.embed_normalized_offset e t β L
        ((C e).offsets L hL).tendsto_div_nhds_zero
    · exact typeFamily_approximatesOnSupport t β b E C e hL
  · exact typeFamily_supported_competitor t β (fun e => (C e).labels)
      (fun e => (C e).nonempty)

/-- The per-layer existence interface used by the finite threshold recursion.
The only input is the lower-dimensional full approximation theorem. -/
theorem exists_typeFamily_layerCertificate {k d : ℕ}
    (hk : 0 < k) (hkd : k < d) {t β b : ℝ}
    (htβ : t < β) (hβb : β < b)
    (E : (Fin d → ℝ) → ℝ)
    (hE : ∀ r, Cube t b r → 0 < E r)
    (hIH : ∀ E' : (Fin k → ℝ) → ℝ,
      (∀ s, Cube β b s → 0 < E' s) → Nonempty (FullCertificate k β b E')) :
    ∃ F : Finset (Label d), F.Nonempty ∧ LayerCertificate t b E k β F := by
  classical
  have hC (e : Fin k ↪ Fin d) :
      Nonempty (FullCertificate k β b (fun s => E (embedCoordinates e t s))) := by
    apply hIH
    intro s hs
    exact hE _ (cube_embedCoordinates e le_rfl htβ.le (htβ.trans hβb).le hs)
  let C (e : Fin k ↪ Fin d) := Classical.choice (hC e)
  exact ⟨typeFamily t β (fun e => (C e).labels),
    typeFamily_nonempty hkd.le t β _ (fun e => (C e).nonempty),
    typeFamily_layerCertificate hk htβ hβb E hE C⟩

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.AffineLocalConstructor -/

namespace OAI

open Filter Topology

noncomputable section
namespace Problem326.Affine

/-- Turn the output of the finite layer construction into the canonical local
certificate. The finite family admits one common stronger decay exponent. -/
theorem localCertificate_of_layers {d : ℕ} (hd : 0 < d)
    {a t b : ℝ} (htb : t < b) (E : (Fin d → ℝ) → ℝ)
    (hE₀ : 0 < E (fun _ => t))
    (hmake : ∀ k : ℕ, 0 < k → k < d → ∀ β : ℝ, t < β → β < b →
      ∃ F : Finset (Label d), LayerCertificate t b E k β F) :
    Nonempty (LocalCertificate d a b t E) := by
  classical
  obtain ⟨Λ, hbase, happrox, hdata⟩ :=
    exists_fixed_minimum_family_of_layers (a := a) hd htb E hE₀ hmake
  have hdecay : ∀ L : Λ, ∃ q : ℝ, t < q ∧
      Asymptotics.IsLittleO (𝓝[>] (0 : ℝ)) L.val.offset (fun h : ℝ => h ^ q) := by
    intro L
    exact (hdata L.val L.property).2.2
  choose q hqt hqdec using hdecay
  obtain ⟨η, htη, hηupper, hηq⟩ := exists_threshold (Finset.univ : Finset Λ)
    (fun L => q L - t) (fun L _ => sub_pos.mpr (hqt L))
    (show t < t + 1 by linarith)
  refine ⟨{
    labels := Λ
    baseline := hbase
    slopes := fun L hL => (hdata L hL).1
    minima := fun L hL => (hdata L hL).2.1
    decayExponent := η
    decay_gt := htη
    offsets := ?_
    approximation := happrox
  }⟩
  intro L hL
  let J : Λ := ⟨L, hL⟩
  have hηqJ : η < q J := by
    have hbound := hηq J (Finset.mem_univ J)
    linarith
  exact offset_isLittleO_of_normalized_limit hηqJ (hqdec J).tendsto_div_nhds_zero

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.ActivityLimits -/

namespace OAI

universe uX uIota

open Set Filter
open scoped Topology

namespace Problem326

/-- Limiting points of activity as the positive parameter tends to zero,
expressed using closed sets; no continuity of `active` is required. -/
def activityLimitSet {X : Type uX} [TopologicalSpace X]
    (active : ℝ → X → Prop) : Set X :=
  ⋂ n : ℕ, closure {p | ∃ h : ℝ, 0 < h ∧ h < 1 / ((n : ℝ) + 1) ∧ active h p}

theorem isClosed_activityLimitSet {X : Type uX} [TopologicalSpace X]
    (active : ℝ → X → Prop) : IsClosed (activityLimitSet active) :=
  isClosed_iInter (fun _ => isClosed_closure)

/-- Every limit of active points at positive parameters tending to zero
belongs to the closed activity-limit set. -/
theorem mem_activityLimitSet_of_tendsto
    {X : Type uX} [TopologicalSpace X] {active : ℝ → X → Prop}
    {h : ℕ → ℝ} {p : ℕ → X} {z : X}
    (hhpos : ∀ n, 0 < h n) (hh : Tendsto h atTop (𝓝 0))
    (hp : Tendsto p atTop (𝓝 z)) (ha : ∀ n, active (h n) (p n)) :
    z ∈ activityLimitSet active := by
  apply mem_iInter.mpr
  intro n
  apply isClosed_closure.mem_of_tendsto hp
  have hev : ∀ᶠ k in atTop, h k < 1 / ((n : ℝ) + 1) :=
    hh.eventually (eventually_lt_nhds (by positivity))
  filter_upwards [hev] with k hk
  exact subset_closure ⟨h k, hhpos k, hk, ha k⟩

/-- In a pseudometric space every point of the activity-limit set is realized
by an actual sequence, even when activity is not a closed relation. -/
theorem exists_active_sequence_of_mem_activityLimitSet
    {X : Type uX} [PseudoMetricSpace X] {active : ℝ → X → Prop} {z : X}
    (hz : z ∈ activityLimitSet active) :
    ∃ (h : ℕ → ℝ) (p : ℕ → X), (∀ n, 0 < h n) ∧
      Tendsto h atTop (𝓝 0) ∧ Tendsto p atTop (𝓝 z) ∧
      ∀ n, active (h n) (p n) := by
  classical
  have hex (n : ℕ) : ∃ p, (∃ h : ℝ, 0 < h ∧
      h < 1 / ((n : ℝ) + 1) ∧ active h p) ∧
      dist z p < 1 / ((n : ℝ) + 1) :=
    Metric.mem_closure_iff.mp (mem_iInter.mp hz n)
      (1 / ((n : ℝ) + 1)) (by positivity)
  choose p hp hdist using hex
  choose h hhpos hhsmall ha using hp
  refine ⟨h, p, hhpos, ?_, ?_, ha⟩
  · exact squeeze_zero (fun n => (hhpos n).le) (fun n => (hhsmall n).le)
      tendsto_one_div_add_atTop_nhds_zero_nat
  · apply tendsto_iff_dist_tendsto_zero.mpr
    apply squeeze_zero (fun _ => dist_nonneg)
      (fun n => ?_) tendsto_one_div_add_atTop_nhds_zero_nat
    simpa only [dist_comm] using (hdist n).le

/-- Compactness upgrades avoidance of one level to a positive uniform gap. -/
theorem compact_avoid_level_has_uniform_gap
    {X : Type uX} [TopologicalSpace X] {K : Set X} (hK : IsCompact K)
    {f : X → ℝ} (hf : ContinuousOn f K) (t : ℝ)
    (hne : ∀ x ∈ K, f x ≠ t) :
    ∃ ρ : ℝ, 0 < ρ ∧ ∀ x ∈ K, ρ ≤ |f x - t| := by
  rcases K.eq_empty_or_nonempty with hEmpty | hNonempty
  · exact ⟨1, zero_lt_one, by simp [hEmpty]⟩
  · obtain ⟨x, hx, hmin⟩ := hK.exists_isMinOn hNonempty
      ((hf.sub continuousOn_const).abs)
    exact ⟨|f x - t|, abs_pos.mpr (sub_ne_zero.mpr (hne x hx)), hmin⟩

/-- A good-label guarantee at one level extends to nearby levels. This is the
compact bad-limit-set argument; tolerances may vary arbitrarily between labels. -/
theorem activity_limits_good_near_level
    {X : Type uX} [TopologicalSpace X] {ι : Type uIota} [Finite ι]
    {K : Set X} (hK : IsCompact K) (active : ι → ℝ → X → Prop)
    (good : ι → Set X) (hgood : ∀ i, IsOpen (good i))
    {f : X → ℝ} (hf : ContinuousOn f K) (t : ℝ)
    (hlevel : ∀ i z, z ∈ K → f z = t →
      z ∈ activityLimitSet (active i) → z ∈ good i) :
    ∃ ρ : ℝ, 0 < ρ ∧ ∀ z ∈ K, |f z - t| < ρ →
      ∀ i, z ∈ activityLimitSet (active i) → z ∈ good i := by
  classical
  let B : Set X := K ∩ ⋃ i, activityLimitSet (active i) ∩ (good i)ᶜ
  have hB : IsCompact B := hK.inter_right
    (isClosed_iUnion_of_finite (fun i =>
      (isClosed_activityLimitSet (active i)).inter (hgood i).isClosed_compl))
  have hne : ∀ z ∈ B, f z ≠ t := by
    intro z hz heq
    obtain ⟨i, hi⟩ := mem_iUnion.mp hz.2
    exact hi.2 (hlevel i z hz.1 heq hi.1)
  obtain ⟨ρ, hρ, hgap⟩ := compact_avoid_level_has_uniform_gap hB
    (hf.mono inter_subset_left) t hne
  refine ⟨ρ, hρ, ?_⟩
  intro z hz hnear i ha
  by_contra hbad
  exact (not_le_of_gt hnear) (hgap z ⟨hz, mem_iUnion.mpr ⟨i, ha, hbad⟩⟩)

end Problem326

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.AffineLocalBand -/

namespace OAI

noncomputable section

open Set Filter
open scoped Topology

namespace Problem326.Affine

/-- The least coordinate in a positive-dimensional exponent vector. -/
def minimumCoordinate {d : ℕ} (hd : 0 < d) (p : Fin d → ℝ) : ℝ :=
  Finset.univ.inf' ⟨⟨0, hd⟩, Finset.mem_univ _⟩ p

theorem continuous_minimumCoordinate {d : ℕ} (hd : 0 < d) :
    Continuous (minimumCoordinate hd) := by
  exact Continuous.finset_inf'_apply _ (fun i _ => continuous_apply i)

theorem hasMinimum_minimumCoordinate {d : ℕ} (hd : 0 < d) (p : Fin d → ℝ) :
    HasMinimum p (minimumCoordinate hd p) := by
  refine ⟨fun i => Finset.inf'_le p (Finset.mem_univ i), ?_⟩
  obtain ⟨i, hi, heq⟩ := Finset.exists_mem_eq_inf'
    (⟨⟨0, hd⟩, Finset.mem_univ _⟩ : (Finset.univ : Finset (Fin d)).Nonempty) p
  exact ⟨i, heq.symm⟩

theorem minimumCoordinate_eq_of_hasMinimum {d : ℕ} (hd : 0 < d)
    {p : Fin d → ℝ} {t : ℝ} (hm : HasMinimum p t) :
    minimumCoordinate hd p = t := by
  apply le_antisymm
  · obtain ⟨i, hi⟩ := hm.2
    exact (Finset.inf'_le p (Finset.mem_univ i)).trans_eq hi
  · exact Finset.le_inf' _ p (fun i _ => hm.1 i)

theorem minimumCoordinate_mem_Icc {d : ℕ} (hd : 0 < d)
    {p : Fin d → ℝ} {a b : ℝ} (hp : Cube a b p) :
    minimumCoordinate hd p ∈ Icc a b := by
  obtain ⟨i, hi⟩ := (hasMinimum_minimumCoordinate hd p).2
  simpa only [← hi, Set.mem_Icc] using hp i

theorem isCompact_cube_localBand {d : ℕ} (a b : ℝ) :
    IsCompact {p : Fin d → ℝ | Cube a b p} := by
  exact isCompact_pi_infinite (fun _ => isCompact_Icc)

/-- Approximation at a fixed
minimum level extends to a band of nearby minimum levels. Approximating
sequences themselves may leave the exponent cube. -/
theorem exists_local_band_of_approximatesAtMinimum
    {d : ℕ} (hd : 0 < d) (Λ : Finset (Label d)) (a b t : ℝ)
    (E : (Fin d → ℝ) → ℝ) (happrox : ApproximatesAtMinimum Λ a b t E) :
    ∃ ρ : ℝ, 0 < ρ ∧ ∀ L ∈ Λ,
      ∀ (h : ℕ → ℝ) (p : ℕ → (Fin d → ℝ)) (p₀ : Fin d → ℝ),
      (∀ n, 0 < h n) → Tendsto h atTop (𝓝 0) →
      Tendsto p atTop (𝓝 p₀) → Cube a b p₀ →
      |minimumCoordinate hd p₀ - t| < ρ →
      (∀ n, Active Λ L (h n) (powerPoint (h n) (p n))) →
      ‖p₀ - L.slope‖ < E L.slope := by
  classical
  let active : Λ → ℝ → (Fin d → ℝ) → Prop :=
    fun L h p => Active Λ L.val h (powerPoint h p)
  let good : Λ → Set (Fin d → ℝ) :=
    fun L => {p | ‖p - L.val.slope‖ < E L.val.slope}
  have hgood (L : Λ) : IsOpen (good L) :=
    isOpen_lt (continuous_id.sub continuous_const).norm continuous_const
  have hlevel (L : Λ) (z : Fin d → ℝ) (hz : Cube a b z)
      (heq : minimumCoordinate hd z = t)
      (ha : z ∈ activityLimitSet (active L)) : z ∈ good L := by
    obtain ⟨h, p, hhpos, hh, hp, hactive⟩ :=
      exists_active_sequence_of_mem_activityLimitSet ha
    apply happrox L.val L.property h p z hhpos hh hp hz
    · simpa only [heq] using hasMinimum_minimumCoordinate hd z
    · exact hactive
  obtain ⟨ρ, hρ, hband⟩ := activity_limits_good_near_level
    (isCompact_cube_localBand (d := d) a b) active good hgood
    (continuous_minimumCoordinate hd).continuousOn t hlevel
  refine ⟨ρ, hρ, ?_⟩
  intro L hL h p p₀ hhpos hh hp hp₀ hnear hactive
  exact hband p₀ hp₀ hnear ⟨L, hL⟩
    (mem_activityLimitSet_of_tendsto hhpos hh hp hactive)

/-- Convenient family-level interface for gluing: the same finite family
approximates at every minimum level in an open interval about `t`. -/
theorem approximatesAtMinimum_nearby
    {d : ℕ} (hd : 0 < d) (Λ : Finset (Label d)) (a b t : ℝ)
    (E : (Fin d → ℝ) → ℝ) (happrox : ApproximatesAtMinimum Λ a b t E) :
    ∃ ρ : ℝ, 0 < ρ ∧ ∀ s ∈ Ioo (t - ρ) (t + ρ),
      ApproximatesAtMinimum Λ a b s E := by
  obtain ⟨ρ, hρ, hband⟩ :=
    exists_local_band_of_approximatesAtMinimum hd Λ a b t E happrox
  refine ⟨ρ, hρ, ?_⟩
  intro s hs L hL h p p₀ hhpos hh hp hp₀ hm hactive
  apply hband L hL h p p₀ hhpos hh hp hp₀ _ hactive
  rw [minimumCoordinate_eq_of_hasMinimum hd hm, abs_lt]
  constructor <;> linarith [hs.1, hs.2]

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.UniformOffsetDecay -/

namespace OAI

universe uIota

open Filter Asymptotics
open scoped Topology

namespace Problem326

private lemma power_isLittleO_at_zero {a b : ℝ} (hab : a < b) :
    (fun h : ℝ => h ^ b) =o[𝓝[>] 0] (fun h => h ^ a) := by
  apply isLittleO_of_tendsto'
  · filter_upwards [self_mem_nhdsWithin] with h hh
    exact fun he => (ne_of_gt (Real.rpow_pos_of_pos hh a) he).elim
  · have hlim : Tendsto (fun h : ℝ => h ^ (b - a)) (𝓝[>] 0) (𝓝 0) := by
      have hid : Tendsto (fun h : ℝ => h) (𝓝[>] 0) (𝓝 0) :=
        tendsto_id.mono_left nhdsWithin_le_nhds
      have hp := hid.rpow tendsto_const_nhds (Or.inr (sub_pos.mpr hab))
      simpa only [Real.zero_rpow (ne_of_gt (sub_pos.mpr hab))] using hp
    apply hlim.congr'
    filter_upwards [self_mem_nhdsWithin] with h hh
    exact Real.rpow_sub hh b a

/-- Finitely many offsets with power decay strictly stronger than `h^t` share
one stronger decay exponent. The individual powers may vary with the label. -/
theorem exists_common_offset_decay {ι : Type uIota} [Fintype ι] [Nonempty ι]
    (c : ι → ℝ → ℝ) (t : ℝ)
    (hc : ∀ i, ∃ β : ℝ, t < β ∧ c i =O[𝓝[>] 0] (fun h => h ^ β)) :
    ∃ η : ℝ, t < η ∧ ∀ i, c i =o[𝓝[>] 0] (fun h => h ^ η) := by
  classical
  choose β hβ hO using hc
  let μ := Finset.univ.inf' Finset.univ_nonempty β
  have htμ : t < μ := (Finset.lt_inf'_iff _).2 fun i _ => hβ i
  let η := (t + μ) / 2
  have htη : t < η := by dsimp [η]; linarith
  have hημ : η < μ := by dsimp [η]; linarith
  refine ⟨η, htη, fun i => ?_⟩
  have hηβ : η < β i := hημ.trans_le (Finset.inf'_le _ (Finset.mem_univ i))
  exact (hO i).trans_isLittleO (power_isLittleO_at_zero hηβ)

/-- A pre-existing localization radius can be shrunk so that all local offsets
are little-o of `h^(t+ρ)`, as required by the affine-family gluing argument. -/
theorem exists_radius_with_offset_decay {ι : Type uIota} [Fintype ι] [Nonempty ι]
    (c : ι → ℝ → ℝ) (t ρ₀ : ℝ) (hρ₀ : 0 < ρ₀)
    (hc : ∀ i, ∃ β : ℝ, t < β ∧ c i =O[𝓝[>] 0] (fun h => h ^ β)) :
    ∃ ρ : ℝ, 0 < ρ ∧ ρ < ρ₀ ∧
      ∀ i, c i =o[𝓝[>] 0] (fun h => h ^ (t + ρ)) := by
  obtain ⟨η, htη, hη⟩ := exists_common_offset_decay c t hc
  let ρ := min (ρ₀ / 2) ((η - t) / 2)
  have hρ : 0 < ρ := lt_min (by positivity) (by positivity)
  have hρ₀' : ρ < ρ₀ := (min_le_left _ _).trans_lt (by linarith)
  have htρη : t + ρ < η := by
    have hle : ρ ≤ (η - t) / 2 := min_le_right _ _
    linarith
  refine ⟨ρ, hρ, hρ₀', fun i => ?_⟩
  exact (hη i).trans (power_isLittleO_at_zero htρη)

/-- The offsets produced by the type construction have the required big-O
bound even though the leading negative power prevents a little-o bound at
that same exponent. -/
theorem shifted_offset_isBigO {d : ℝ → ℝ} {β : ℝ}
    (hd : d =o[𝓝[>] 0] (fun h => h ^ β)) :
    (fun h => -(h ^ β) + d h) =O[𝓝[>] 0] (fun h => h ^ β) := by
  exact (isBigO_refl (fun h : ℝ => h ^ β) (𝓝[>] 0)).neg_left.add hd.isBigO

/-- Normalizing a constructed negative-shift offset by its leading power gives
limit `-1`; this is the exact sequential input used by fixed-minimum activity estimates. -/
theorem shifted_offset_normalized_limit {d : ℝ → ℝ} {β : ℝ}
    (hd : d =o[𝓝[>] 0] (fun h => h ^ β)) :
    Tendsto (fun h : ℝ => (-(h ^ β) + d h) / h ^ β)
      (𝓝[>] 0) (𝓝 (-1)) := by
  have hconst : Tendsto (fun _ : ℝ => (-1 : ℝ)) (𝓝[>] 0) (𝓝 (-1)) :=
    tendsto_const_nhds
  have hlim := hconst.add hd.tendsto_div_nhds_zero
  have hlim' : Tendsto (fun h : ℝ => -1 + d h / h ^ β)
      (𝓝[>] 0) (𝓝 (-1)) := by simpa using hlim
  apply hlim'.congr'
  filter_upwards [self_mem_nhdsWithin] with h hh
  have hp : h ^ β ≠ 0 := ne_of_gt (Real.rpow_pos_of_pos hh β)
  field_simp

end Problem326

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.LocalCertificateRadius -/

namespace OAI

noncomputable section

open Filter
open scoped Topology

namespace Problem326.Affine

/-- A fixed-minimum certificate supplies a common neighborhood radius with
both approximation throughout the band and the stronger offset decay used
by the interval-gluing construction. -/
theorem LocalCertificate.exists_radius
    {d : ℕ} (hd : 0 < d) {a b t : ℝ} {E : (Fin d → ℝ) → ℝ}
    (C : LocalCertificate d a b t E) :
    ∃ ρ : ℝ, 0 < ρ ∧
      (∀ L ∈ C.labels,
        L.offset =o[𝓝[>] (0 : ℝ)] (fun h => h ^ (t + ρ))) ∧
      ∀ s : ℝ, |s - t| < ρ → ApproximatesAtMinimum C.labels a b s E := by
  classical
  obtain ⟨ρ₀, hρ₀, hnear⟩ := approximatesAtMinimum_nearby
    hd C.labels a b t E C.approximation
  let : Nonempty C.labels := ⟨⟨_, C.baseline⟩⟩
  have hdecay (L : C.labels) : ∃ β : ℝ, t < β ∧
      L.val.offset =O[𝓝[>] (0 : ℝ)] (fun h => h ^ β) :=
    ⟨C.decayExponent, C.decay_gt, (C.offsets L.val L.property).isBigO⟩
  obtain ⟨ρ, hρ, hρsmall, hoffsets⟩ := exists_radius_with_offset_decay
    (fun L : C.labels => L.val.offset) t ρ₀ hρ₀ hdecay
  refine ⟨ρ, hρ, (fun L hL => hoffsets ⟨L, hL⟩), ?_⟩
  intro s hs
  apply hnear s
  have h := abs_lt.mp (hs.trans hρsmall)
  exact ⟨by linarith [h.1], by linarith [h.2]⟩

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.AffineGluing -/

namespace OAI

universe uAlpha uIota

noncomputable section

open Filter Asymptotics
open scoped BigOperators Topology

namespace Problem326.AffineGluing

/-- A positive comparison scale dominates a finite affine error that is little-o of it. -/
theorem eventually_pos_sum_add_scale {α : Type uAlpha} {ι : Type uIota} [Fintype ι]
    {l : Filter α} {x : ι → α → ℝ} {c s : α → ℝ} (a : ι → ℝ)
    (hs : ∀ᶠ n in l, 0 < s n) (hc : c =o[l] s)
    (hx : ∀ i, x i =o[l] s) :
    ∀ᶠ n in l, 0 < (∑ i, a i * x i n) + c n + s n := by
  classical
  have hsum : (fun n => ∑ i, a i * x i n) =o[l] s := by
    exact IsLittleO.sum (fun i _ => (hx i).const_mul_left (a i))
  have herr := (hsum.add hc).eventuallyLT_norm_of_eventually_pos
    (hs.mono fun n hn => by simpa only [Real.norm_eq_abs, abs_of_pos hn] using hn)
  filter_upwards [hs, herr] with n hn he
  rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hn] at he
  have := (abs_lt.mp he).1
  linarith

/-- One positive coordinate contribution that dominates the comparison scale also
    dominates all nonnegative remaining contributions and a little-o offset. -/
theorem eventually_pos_sum_add_sub_scale {α : Type uAlpha} {ι : Type uIota} [Fintype ι]
    {l : Filter α} {x : ι → α → ℝ} {c s : α → ℝ} (a : ι → ℝ) (j : ι)
    (ha : ∀ i, 0 ≤ a i) (haj : 0 < a j)
    (hs : ∀ᶠ n in l, 0 < s n) (hc : c =o[l] s)
    (hx : ∀ᶠ n in l, ∀ i, 0 ≤ x i n)
    (hj : Tendsto (fun n => x j n / s n) l atTop) :
    ∀ᶠ n in l, 0 < (∑ i, a i * x i n) + c n - s n := by
  classical
  have hlarge := hj.eventually_gt_atTop (3 / a j)
  filter_upwards [hs, hc.eventuallyLE, hx, hlarge] with n hn he hx hlarge
  rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hn] at he
  have hcoord : 3 * s n < a j * x j n := by
    have h := (lt_div_iff₀ hn).mp hlarge
    have h' := mul_lt_mul_of_pos_left h haj
    field_simp at h'
    nlinarith
  have hsum : a j * x j n ≤ ∑ i, a i * x i n := by
    exact Finset.single_le_sum (fun i _ => mul_nonneg (ha i) (hx i)) (Finset.mem_univ j)
  have he' := (abs_le.mp he).1
  linarith

/-- The upper comparison in affine gluing forces some limiting exponent below the cut.
    The asymptotic hypotheses are exactly the variable-exponent power estimates. -/
theorem active_upper_cut {ι : Type uIota} [Fintype ι]
    {x : ι → ℕ → ℝ} {c s : ℕ → ℝ} (a p : ι → ℝ) (q : ℝ)
    (hs : ∀ᶠ n in atTop, 0 < s n) (hc : c =o[atTop] s)
    (hgap : ∀ i, q < p i → x i =o[atTop] s)
    (hactive : ∀ᶠ n in atTop, (∑ i, a i * x i n) + c n + s n ≤ 0) :
    ∃ i, p i ≤ q := by
  classical
  by_contra h
  have hp : ∀ i, q < p i := by simpa only [not_exists, not_le] using h
  have hpos := eventually_pos_sum_add_scale a hs hc (fun i => hgap i (hp i))
  obtain ⟨n, hn, hn'⟩ := (hpos.and hactive).exists
  exact (not_lt_of_ge hn') hn

/-- The lower comparison in affine gluing forces every limiting exponent above the cut. -/
theorem active_lower_cut {ι : Type uIota} [Fintype ι]
    {x : ι → ℕ → ℝ} {c s : ℕ → ℝ} (a p : ι → ℝ) (q : ℝ)
    (ha : ∀ i, 0 < a i)
    (hs : ∀ᶠ n in atTop, 0 < s n) (hc : c =o[atTop] s)
    (hx : ∀ᶠ n in atTop, ∀ i, 0 ≤ x i n)
    (hgap : ∀ i, p i < q → Tendsto (fun n => x i n / s n) atTop atTop)
    (hactive : ∀ᶠ n in atTop, (∑ i, a i * x i n) + c n - s n ≤ 0) :
    ∀ i, q ≤ p i := by
  intro i
  by_contra hi
  have hpos := eventually_pos_sum_add_sub_scale a i (fun j => (ha j).le)
    (ha i) hs hc hx (hgap i (lt_of_not_ge hi))
  obtain ⟨n, hn, hn'⟩ := (hpos.and hactive).exists
  exact (not_lt_of_ge hn') hn

/-- A supported version of the upper comparison: coordinates with zero coefficient
    need no asymptotic control. This is useful in the fixed-minimum induction. -/
theorem active_upper_cut_on_support {ι : Type uIota} [Fintype ι]
    {x : ι → ℕ → ℝ} {c s : ℕ → ℝ} (a p : ι → ℝ) (q : ℝ)
    (hs : ∀ᶠ n in atTop, 0 < s n) (hc : c =o[atTop] s)
    (hgap : ∀ i, a i ≠ 0 → q < p i → x i =o[atTop] s)
    (hactive : ∀ᶠ n in atTop, (∑ i, a i * x i n) + c n + s n ≤ 0) :
    ∃ i, a i ≠ 0 ∧ p i ≤ q := by
  classical
  by_contra h
  have hp : ∀ i, a i ≠ 0 → q < p i := by
    intro i hi
    exact lt_of_not_ge (fun hpi => h ⟨i, hi, hpi⟩)
  have hterm : ∀ i, (fun n => a i * x i n) =o[atTop] s := by
    intro i
    by_cases hi : a i = 0
    · simpa only [hi, zero_mul] using (isLittleO_zero s atTop)
    · exact (hgap i hi (hp i hi)).const_mul_left (a i)
  have hsum : (fun n => ∑ i, a i * x i n) =o[atTop] s := by
    exact IsLittleO.sum (fun i _ => hterm i)
  have herr := (hsum.add hc).eventuallyLT_norm_of_eventually_pos
    (hs.mono fun n hn => by simpa only [Real.norm_eq_abs, abs_of_pos hn] using hn)
  obtain ⟨n, hn, he, hact⟩ := (hs.and (herr.and hactive)).exists
  rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hn] at he
  have := (abs_lt.mp he).1
  linarith

/-- With nonnegative contributions, only strictly positive coefficients force a
    lower bound on the corresponding limiting exponent. -/
theorem active_nonnegative_lower_cut {ι : Type uIota} [Fintype ι]
    {x : ι → ℕ → ℝ} {c s : ℕ → ℝ} (a p : ι → ℝ) (q : ℝ)
    (ha : ∀ i, 0 ≤ a i)
    (hs : ∀ᶠ n in atTop, 0 < s n) (hc : c =o[atTop] s)
    (hx : ∀ᶠ n in atTop, ∀ i, 0 ≤ x i n)
    (hgap : ∀ i, p i < q → Tendsto (fun n => x i n / s n) atTop atTop)
    (hactive : ∀ᶠ n in atTop, (∑ i, a i * x i n) + c n - s n ≤ 0) :
    ∀ i, 0 < a i → q ≤ p i := by
  intro i hi
  by_contra hpi
  have hpos := eventually_pos_sum_add_sub_scale a i ha hi hs hc hx
    (hgap i (lt_of_not_ge hpi))
  obtain ⟨n, hn, hn'⟩ := (hpos.and hactive).exists
  exact (not_lt_of_ge hn') hn

/-- Common offset shifts preserve all comparisons inside a local family. -/
theorem common_shift_comparison (a b shift : ℝ) :
    a - shift ≤ b - shift ↔ a ≤ b := sub_le_sub_iff_right shift

theorem shifted_active_upper_cut {ι : Type uIota} [Fintype ι]
    {x : ι → ℕ → ℝ} {c : ℕ → ℝ} (scale : ℕ → ℕ → ℝ)
    (r p : ι → ℝ) (next q : ℝ) (j : ℕ)
    (hs : ∀ᶠ n in atTop, 0 < scale j n) (hc : c =o[atTop] scale j)
    (hgap : ∀ i, q < p i → x i =o[atTop] scale j)
    (hactive : ∀ᶠ n in atTop,
      (∑ i, r i * x i n) + c n - (∑ k ∈ Finset.range j, scale k n) ≤
      (∑ i, next * x i n) - (∑ k ∈ Finset.range (j + 1), scale k n)) :
    ∃ i, p i ≤ q := by
  apply active_upper_cut (fun i => r i - next) p q hs hc hgap
  filter_upwards [hactive] with n hn
  simp only [Finset.sum_range_succ, sub_mul, Finset.sum_sub_distrib] at hn ⊢
  linarith

theorem shifted_active_lower_cut {ι : Type uIota} [Fintype ι]
    {x : ι → ℕ → ℝ} {c : ℕ → ℝ} (scale : ℕ → ℕ → ℝ)
    (r p : ι → ℝ) (prev q : ℝ) (j : ℕ)
    (hr : ∀ i, prev < r i)
    (hs : ∀ᶠ n in atTop, 0 < scale j n) (hc : c =o[atTop] scale j)
    (hx : ∀ᶠ n in atTop, ∀ i, 0 ≤ x i n)
    (hgap : ∀ i, p i < q →
      Tendsto (fun n => x i n / scale j n) atTop atTop)
    (hactive : ∀ᶠ n in atTop,
      (∑ i, r i * x i n) + c n - (∑ k ∈ Finset.range (j + 1), scale k n) ≤
      (∑ i, prev * x i n) - (∑ k ∈ Finset.range j, scale k n)) :
    ∀ i, q ≤ p i := by
  apply active_lower_cut (fun i => r i - prev) p q (fun i => sub_pos.mpr (hr i))
    hs hc hx hgap
  filter_upwards [hactive] with n hn
  simp only [Finset.sum_range_succ, sub_mul, Finset.sum_sub_distrib] at hn ⊢
  linarith

end Problem326.AffineGluing

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.PowerAsymptotics -/

namespace OAI

universe uAlpha uIota

open Filter
open scoped Topology

namespace Problem326

/-- A positive gap between limiting exponents makes the ratio of powers
 tend to zero, even when the numerator's exponent varies. -/
theorem tendsto_rpow_ratio_zero {α : Type uAlpha} {l : Filter α}
    {h p : α → ℝ} {p₀ q : ℝ}
    (hh : Tendsto h l (𝓝 0)) (hhpos : ∀ᶠ n in l, 0 < h n)
    (hp : Tendsto p l (𝓝 p₀)) (hgap : q < p₀) :
    Tendsto (fun n => h n ^ p n / h n ^ q) l (𝓝 0) := by
  have hlim := hh.rpow (hp.sub_const q) (Or.inr (sub_pos.mpr hgap))
  simp only [Real.zero_rpow (ne_of_gt (sub_pos.mpr hgap))] at hlim
  apply hlim.congr'
  filter_upwards [hhpos] with n hn
  exact Real.rpow_sub hn (p n) q

/-- A negative limiting exponent gap makes the same ratio diverge. -/
theorem tendsto_rpow_ratio_atTop {α : Type uAlpha} {l : Filter α}
    {h p : α → ℝ} {p₀ q : ℝ}
    (hh : Tendsto h l (𝓝 0)) (hhpos : ∀ᶠ n in l, 0 < h n)
    (hp : Tendsto p l (𝓝 p₀)) (hgap : p₀ < q) :
    Tendsto (fun n => h n ^ p n / h n ^ q) l atTop := by
  have hlim := hh.rpow (tendsto_const_nhds.sub hp)
    (Or.inr (sub_pos.mpr hgap))
  simp only [Real.zero_rpow (ne_of_gt (sub_pos.mpr hgap))] at hlim
  have hpos : ∀ᶠ n in l, 0 < h n ^ (q - p n) := by
    filter_upwards [hhpos] with n hn
    exact Real.rpow_pos_of_pos hn _
  have hinv := tendsto_inv_nhdsGT_zero.comp (tendsto_nhdsWithin_iff.mpr ⟨hlim, hpos⟩)
  apply hinv.congr'
  filter_upwards [hhpos] with n hn
  simp only [Function.comp_apply, Real.rpow_sub hn, inv_div]

/-- Little-o form of the varying-exponent comparison. -/
theorem varying_rpow_isLittleO {α : Type uAlpha} {l : Filter α}
    {h p : α → ℝ} {p₀ q : ℝ}
    (hh : Tendsto h l (𝓝 0)) (hhpos : ∀ᶠ n in l, 0 < h n)
    (hp : Tendsto p l (𝓝 p₀)) (hgap : q < p₀) :
    (fun n => h n ^ p n) =o[l] (fun n => h n ^ q) := by
  apply Asymptotics.isLittleO_of_tendsto' _
    (tendsto_rpow_ratio_zero hh hhpos hp hgap)
  filter_upwards [hhpos] with n hn
  intro hz
  exact False.elim ((ne_of_gt (Real.rpow_pos_of_pos hn q)) hz)

/-- Fixed distinct powers are asymptotically separated at zero from the right. -/
theorem rpow_isLittleO_at_zero {p q : ℝ} (hpq : q < p) :
    (fun h : ℝ => h ^ p) =o[𝓝[>] 0] (fun h => h ^ q) :=
  varying_rpow_isLittleO nhdsWithin_le_nhds
    self_mem_nhdsWithin tendsto_const_nhds hpq

/-- The exponents corresponding to any fixed initial state tend to zero. -/
theorem tendsto_log_ratio_zero (x : ℝ) :
    Tendsto (fun h : ℝ => Real.log x / Real.log h) (𝓝[>] 0) (𝓝 0) :=
  Real.tendsto_log_nhdsGT_zero.const_div_atBot (Real.log x)

/-- One small parameter simultaneously controls every fixed initial exponent
 and a prescribed rate-separation inequality. -/
theorem exists_small_parameter_of_constants {ι : Type uIota} [Finite ι] (x : ι → ℝ)
    {H h₀ B : ℝ} (hH : 0 < H) (hh₀ : 0 < h₀) (hB : 0 < B) (A : ℝ) :
    ∃ h : ℝ, 0 < h ∧ h < h₀ ∧ h < 1 ∧
      (∀ i, |Real.log (x i) / Real.log h| < H) ∧ h ^ H * A < B := by
  have hbase : Tendsto (fun h : ℝ => h) (𝓝[>] 0) (𝓝 0) := nhdsWithin_le_nhds
  have hlogs : ∀ᶠ h : ℝ in 𝓝[>] 0,
      ∀ i, |Real.log (x i) / Real.log h| < H := by
    apply eventually_all.mpr
    intro i
    have hi := (tendsto_log_ratio_zero (x i)).abs
    simp only [abs_zero] at hi
    exact hi.eventually_lt_const hH
  have hpowers : ∀ᶠ h : ℝ in 𝓝[>] 0, h ^ H * A < B := by
    have hl := (hbase.rpow_const_nhds_zero hH).mul_const A
    simp only [zero_mul] at hl
    exact hl.eventually_lt_const hB
  have hsmall : ∀ᶠ h : ℝ in 𝓝[>] 0, h < h₀ :=
    hbase.eventually_lt_const hh₀
  have hone : ∀ᶠ h : ℝ in 𝓝[>] 0, h < 1 :=
    hbase.eventually_lt_const zero_lt_one
  have hpositive : ∀ᶠ h : ℝ in 𝓝[>] 0, 0 < h := self_mem_nhdsWithin
  exact (hpositive.and (hsmall.and (hone.and (hlogs.and hpowers)))).exists

end Problem326

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.IntervalGluing -/

namespace OAI

universe uAlpha uBeta

/-! Elementary interval-gluing facts for the affine-label construction. -/
namespace Problem326.IntervalGluing

/-- Removing nonmaximal members of a finite family preserves its union. -/
theorem exists_maximal_subfamily {α : Type uAlpha} {β : Type uBeta} (S : Finset α) (U : α → Set β) :
    ∃ T : Finset α, T ⊆ S ∧
      (∀ x ∈ S, ∃ y ∈ T, U x ⊆ U y) ∧
      (∀ x ∈ T, ∀ y ∈ T, U x ⊆ U y → U y ⊆ U x) := by
  classical
  let T := S.filter (fun x => MaximalFor (· ∈ S) U x)
  refine ⟨T, Finset.filter_subset _ _, ?_, ?_⟩
  · intro x hx
    obtain ⟨V, hxV, hV⟩ := (S.image U).exists_le_maximal (Finset.mem_image.mpr ⟨x, hx, rfl⟩)
    obtain ⟨y, hy, rfl⟩ := Finset.mem_image.mp hV.1
    refine ⟨y, Finset.mem_filter.mpr ⟨hy, hy, ?_⟩, hxV⟩
    intro z hz hyz
    exact hV.2 (Finset.mem_image.mpr ⟨z, hz, rfl⟩) hyz
  · intro x hx y hy hxy
    have hmax := (Finset.mem_filter.mp hx).2
    exact hmax.2 (Finset.mem_filter.mp hy).1 hxy

/-- For centered intervals, noncontainment forces both endpoints to follow the
order of the centers. -/
theorem endpoints_order_of_noncontainment {t u r s : ℝ}
    (htu : t < u)
    (hntu : ¬ Set.Ioo (t-r) (t+r) ⊆ Set.Ioo (u-s) (u+s))
    (hnut : ¬ Set.Ioo (u-s) (u+s) ⊆ Set.Ioo (t-r) (t+r)) :
    t-r < u-s ∧ t+r < u+s := by
  constructor
  · by_contra h
    apply hntu
    apply Set.Ioo_subset_Ioo
    · exact le_of_not_gt h
    · linarith
  · by_contra h
    apply hnut
    apply Set.Ioo_subset_Ioo
    · linarith
    · exact le_of_not_gt h

/-- Two nonempty centered intervals with mutual inclusion have equal centers. -/
theorem center_eq_of_mutual_subset {t u r s : ℝ} (hr : 0 < r) (hs : 0 < s)
    (h₁ : Set.Ioo (t-r) (t+r) ⊆ Set.Ioo (u-s) (u+s))
    (h₂ : Set.Ioo (u-s) (u+s) ⊆ Set.Ioo (t-r) (t+r)) : t = u := by
  have h₁' := (Set.Ioo_subset_Ioo_iff (show t-r < t+r by linarith)).mp h₁
  have h₂' := (Set.Ioo_subset_Ioo_iff (show u-s < u+s by linarith)).mp h₂
  linarith

/-- An arbitrary positive radius function on a compact interval has a finite
centered subcover whose centers and both endpoint lists are strictly ordered.
No continuity of the radius function is required. -/
theorem exists_ordered_interval_cover {a b : ℝ} (hab : a ≤ b)
    (r : ℝ → ℝ) (hr : ∀ t ∈ Set.Icc a b, 0 < r t) :
    ∃ n : ℕ, ∃ t : Fin (n+1) → ℝ,
      StrictMono t ∧ (∀ i, t i ∈ Set.Icc a b) ∧
      StrictMono (fun i => t i - r (t i)) ∧
      StrictMono (fun i => t i + r (t i)) ∧
      (∀ x ∈ Set.Icc a b, ∃ i, x ∈ Set.Ioo (t i-r (t i)) (t i+r (t i))) := by
  classical
  let U : ℝ → Set ℝ := fun t => Set.Ioo (t-r t) (t+r t)
  have hcov : Set.Icc a b ⊆ ⋃ t ∈ Set.Icc a b, U t := by
    intro x hx
    refine Set.mem_iUnion.mpr ⟨x, Set.mem_iUnion.mpr ⟨hx, ?_⟩⟩
    have := hr x hx
    exact ⟨by linarith, by linarith⟩
  obtain ⟨S', hS', hSf, hcovS⟩ :=
    isCompact_Icc.elim_finite_subcover_image (fun _ _ => isOpen_Ioo) hcov
  let S := hSf.toFinset
  obtain ⟨T, hTS, hdom, hmax⟩ := exists_maximal_subfamily S U
  have hTmem : ∀ t ∈ T, t ∈ Set.Icc a b := by
    intro t ht
    exact hS' (by simpa [S] using hTS ht)
  have hTcov : ∀ x ∈ Set.Icc a b, ∃ t ∈ T, x ∈ U t := by
    intro x hx
    obtain ⟨u, hu, hxu⟩ := Set.mem_iUnion₂.mp (hcovS hx)
    obtain ⟨t, ht, hut⟩ := hdom u (by simpa [S] using hu)
    exact ⟨t, ht, hut hxu⟩
  have hTne : T.Nonempty := by
    obtain ⟨t, ht, _⟩ := hTcov a ⟨le_rfl, hab⟩
    exact ⟨t, ht⟩
  obtain ⟨n, hn⟩ := Nat.exists_eq_succ_of_ne_zero (ne_of_gt hTne.card_pos)
  let t : Fin (n+1) ↪o ℝ := T.orderEmbOfFin hn
  have htmem : ∀ i, t i ∈ T := T.orderEmbOfFin_mem hn
  have htnot : ∀ i j, i < j → ¬ U (t i) ⊆ U (t j) := by
    intro i j hij hsub
    have heq := center_eq_of_mutual_subset
      (hr _ (hTmem _ (htmem i))) (hr _ (hTmem _ (htmem j)))
      hsub (hmax _ (htmem i) _ (htmem j) hsub)
    exact (ne_of_lt (t.strictMono hij)) heq
  have htends : ∀ i j, i < j →
      t i-r (t i) < t j-r (t j) ∧ t i+r (t i) < t j+r (t j) := by
    intro i j hij
    apply endpoints_order_of_noncontainment (t.strictMono hij) (htnot i j hij)
    intro hsub
    exact htnot i j hij (hmax _ (htmem j) _ (htmem i) hsub)
  refine ⟨n, t, t.strictMono, (fun i => hTmem _ (htmem i)),
    (fun _ _ hij => (htends _ _ hij).1),
    (fun _ _ hij => (htends _ _ hij).2), ?_⟩
  intro x hx
  obtain ⟨u, hu, hxu⟩ := hTcov x hx
  have hurange : u ∈ Set.range t := by
    rw [show Set.range t = (T : Set ℝ) from T.range_orderEmbOfFin hn]
    exact hu
  obtain ⟨i, rfl⟩ := hurange
  exact ⟨i, hxu⟩

/-- Overlapping intervals with ordered centers admit a transition cut inside both
intervals and strictly between their centers. -/
theorem exists_overlap_cut {t u L R L' R' : ℝ}
    (htu : t < u) (hLt : L < t) (htR : t < R)
    (hLu : L' < u) (huR : u < R') (hoverlap : L' < R) :
    ∃ q : ℝ, t < q ∧ q < u ∧ q ∈ Set.Ioo L R ∧ q ∈ Set.Ioo L' R' := by
  have hgap : max t L' < min u R := by
    exact max_lt (lt_min htu htR) (lt_min hLu hoverlap)
  obtain ⟨q, hqlo, hqhi⟩ := exists_between hgap
  have htq : t < q := lt_of_le_of_lt (le_max_left _ _) hqlo
  have hLq : L' < q := lt_of_le_of_lt (le_max_right _ _) hqlo
  have hqu : q < u := lt_of_lt_of_le hqhi (min_le_left _ _)
  have hqR : q < R := lt_of_lt_of_le hqhi (min_le_right _ _)
  exact ⟨q, htq, hqu, ⟨hLt.trans htq, hqR⟩, ⟨hLq, hqu.trans huR⟩⟩

/-- In an ordered interval cover, neighboring intervals overlap. Ordering both
endpoints is the property obtained by deleting contained intervals. -/
theorem consecutive_overlap {n : ℕ} {a b : ℝ}
    (t L R : Fin (n + 1) → ℝ)
    (hL : StrictMono L) (hR : StrictMono R)
    (hcenter : ∀ j, L j < t j ∧ t j < R j)
    (hcenter_mem : ∀ j, t j ∈ Set.Icc a b)
    (hcover : ∀ x ∈ Set.Icc a b, ∃ j, x ∈ Set.Ioo (L j) (R j))
    (i : Fin n) : L i.succ < R i.castSucc := by
  by_contra h
  have hgap : R i.castSucc ≤ L i.succ := le_of_not_gt h
  have hx : R i.castSucc ∈ Set.Icc a b := by
    constructor
    · exact (hcenter_mem i.castSucc).1.trans (hcenter i.castSucc).2.le
    · exact hgap.trans ((hcenter i.succ).1.le.trans (hcenter_mem i.succ).2)
  obtain ⟨j, hjL, hjR⟩ := hcover (R i.castSucc) hx
  by_cases hji : j ≤ i.castSucc
  · exact (not_lt_of_ge (hR.monotone hji)) hjR
  · have hij : i.succ ≤ j := by
      change i.val + 1 ≤ j.val
      have : i.castSucc < j := lt_of_not_ge hji
      change i.val < j.val at this
      omega
    exact (not_lt_of_ge (hgap.trans (hL.monotone hij))) hjL

/-- A simultaneous choice of all transition cuts in an ordered interval cover. -/
theorem exists_consecutive_cuts {n : ℕ} {a b : ℝ}
    (t L R : Fin (n + 1) → ℝ)
    (ht : StrictMono t) (hL : StrictMono L) (hR : StrictMono R)
    (hcenter : ∀ j, L j < t j ∧ t j < R j)
    (hcenter_mem : ∀ j, t j ∈ Set.Icc a b)
    (hcover : ∀ x ∈ Set.Icc a b, ∃ j, x ∈ Set.Ioo (L j) (R j)) :
    ∃ q : Fin n → ℝ, ∀ i,
      t i.castSucc < q i ∧ q i < t i.succ ∧
      q i ∈ Set.Ioo (L i.castSucc) (R i.castSucc) ∧
      q i ∈ Set.Ioo (L i.succ) (R i.succ) := by
  have hex : ∀ i : Fin n, ∃ q : ℝ,
      t i.castSucc < q ∧ q < t i.succ ∧
      q ∈ Set.Ioo (L i.castSucc) (R i.castSucc) ∧
      q ∈ Set.Ioo (L i.succ) (R i.succ) := by
    intro i
    apply exists_overlap_cut (ht (by simp))
      (hcenter i.castSucc).1 (hcenter i.castSucc).2
      (hcenter i.succ).1 (hcenter i.succ).2
    exact consecutive_overlap t L R hL hR hcenter hcenter_mem hcover i
  exact Classical.axiomOfChoice hex

/-- In an ordered centered cover, the first and last intervals contain the
corresponding endpoints of the covered compact interval. -/
theorem endpoint_membership {n : ℕ} {a b : ℝ} (hab : a ≤ b)
    (t L R : Fin (n+1) → ℝ) (hL : StrictMono L) (hR : StrictMono R)
    (hcenter : ∀ j, L j < t j ∧ t j < R j)
    (hcenter_mem : ∀ j, t j ∈ Set.Icc a b)
    (hcover : ∀ x ∈ Set.Icc a b, ∃ j, x ∈ Set.Ioo (L j) (R j)) :
    a ∈ Set.Ioo (L 0) (R 0) ∧
    b ∈ Set.Ioo (L (Fin.last n)) (R (Fin.last n)) := by
  obtain ⟨i, hi⟩ := hcover a ⟨le_rfl, hab⟩
  obtain ⟨j, hj⟩ := hcover b ⟨hab, le_rfl⟩
  constructor
  · exact ⟨(hL.monotone (Fin.zero_le i)).trans_lt hi.1,
      (hcenter_mem 0).1.trans_lt (hcenter 0).2⟩
  · exact ⟨(hcenter (Fin.last n)).1.trans_le (hcenter_mem (Fin.last n)).2,
      hj.2.trans_le (hR.monotone (Fin.le_last j))⟩

/-- Finite interval gluing data for an arbitrary positive radius function.
The chosen transition cuts lie in both adjacent intervals and strictly between
adjacent centers. Together with endpoint membership this covers every closed
piece between successive cuts by its designated interval. -/
theorem exists_interval_gluing {a b : ℝ} (hab : a ≤ b)
    (r : ℝ → ℝ) (hr : ∀ t ∈ Set.Icc a b, 0 < r t) :
    ∃ n : ℕ, ∃ t : Fin (n+1) → ℝ, ∃ q : Fin n → ℝ,
      StrictMono t ∧ (∀ i, t i ∈ Set.Icc a b) ∧
      (a ∈ Set.Ioo (t 0-r (t 0)) (t 0+r (t 0))) ∧
      (b ∈ Set.Ioo (t (Fin.last n)-r (t (Fin.last n)))
        (t (Fin.last n)+r (t (Fin.last n)))) ∧
      (∀ i, t i.castSucc < q i ∧ q i < t i.succ ∧
        q i ∈ Set.Ioo (t i.castSucc-r (t i.castSucc))
          (t i.castSucc+r (t i.castSucc)) ∧
        q i ∈ Set.Ioo (t i.succ-r (t i.succ)) (t i.succ+r (t i.succ))) := by
  obtain ⟨n, t, ht, htm, hL, hR, hcover⟩ := exists_ordered_interval_cover hab r hr
  have hcenter : ∀ i, t i-r (t i) < t i ∧ t i < t i+r (t i) := by
    intro i
    have := hr (t i) (htm i)
    constructor <;> linarith
  obtain ⟨q, hq⟩ := exists_consecutive_cuts t
    (fun i => t i-r (t i)) (fun i => t i+r (t i)) ht hL hR hcenter htm hcover
  have he := endpoint_membership hab t
    (fun i => t i-r (t i)) (fun i => t i+r (t i)) hL hR hcenter htm hcover
  exact ⟨n, t, q, ht, htm, he.1, he.2, hq⟩

end Problem326.IntervalGluing

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.AffineGlobalGluing -/

namespace OAI

noncomputable section

open Filter Asymptotics
open scoped BigOperators Topology

namespace Problem326.Affine

/-- The cumulative shift assigned to a local family at level `j`. -/
def shiftedLabel {d : ℕ} (q : ℕ → ℝ) (j : ℕ) (L : Label d) : Label d :=
  ⟨L.slope, fun h => L.offset h - ∑ k ∈ Finset.range j, h ^ q k⟩

/-- Union of the shifted local families, with levels numbered `0, ..., N`. -/
def gluedFamily {d : ℕ} (N : ℕ) (q : ℕ → ℝ)
    (Λ : ℕ → Finset (Label d)) : Finset (Label d) := by
  classical
  exact (Finset.range (N + 1)).biUnion fun j => (Λ j).image (shiftedLabel q j)

@[simp] lemma shiftedLabel_slope {d : ℕ} (q : ℕ → ℝ) (j : ℕ) (L : Label d) :
    (shiftedLabel q j L).slope = L.slope := rfl

@[simp] lemma shiftedLabel_value {d : ℕ} (q : ℕ → ℝ) (j : ℕ)
    (L : Label d) (h : ℝ) (x : Fin d → ℝ) :
    (shiftedLabel q j L).value h x = L.value h x - ∑ k ∈ Finset.range j, h ^ q k := by
  unfold Label.value shiftedLabel
  dsimp
  ring

lemma shiftedLabel_mem_gluedFamily {d : ℕ} {N j : ℕ} {q : ℕ → ℝ}
    {Λ : ℕ → Finset (Label d)} {L : Label d} (hj : j ≤ N) (hL : L ∈ Λ j) :
    shiftedLabel q j L ∈ gluedFamily N q Λ := by
  classical
  exact Finset.mem_biUnion.mpr ⟨j, Finset.mem_range.mpr (by omega),
    Finset.mem_image.mpr ⟨L, hL, rfl⟩⟩

lemma mem_gluedFamily_iff {d : ℕ} {N : ℕ} {q : ℕ → ℝ}
    {Λ : ℕ → Finset (Label d)} {L : Label d} :
    L ∈ gluedFamily N q Λ ↔
      ∃ j ≤ N, ∃ J ∈ Λ j, shiftedLabel q j J = L := by
  classical
  simp only [gluedFamily, Finset.mem_biUnion, Finset.mem_range, Finset.mem_image]
  constructor
  · rintro ⟨j, hj, J, hJ, heq⟩
    exact ⟨j, by omega, J, hJ, heq⟩
  · rintro ⟨j, hj, J, hJ, heq⟩
    exact ⟨j, by omega, J, hJ, heq⟩

lemma active_gluedFamily_restrict {d : ℕ} {N j : ℕ} {q : ℕ → ℝ}
    {Λ : ℕ → Finset (Label d)} {L : Label d} {h : ℝ} {x : Fin d → ℝ}
    (hj : j ≤ N) (hL : L ∈ Λ j)
    (ha : Active (gluedFamily N q Λ) (shiftedLabel q j L) h x) :
    Active (Λ j) L h x := by
  refine ⟨hL, fun J hJ => ?_⟩
  have hc := ha.2 (shiftedLabel q j J) (shiftedLabel_mem_gluedFamily hj hJ)
  simpa only [shiftedLabel_value, sub_le_sub_iff_right] using hc

lemma gluedFamily_nonempty {d : ℕ} (N : ℕ) (q : ℕ → ℝ)
    (Λ : ℕ → Finset (Label d)) (hΛ : (Λ 0).Nonempty) :
    (gluedFamily N q Λ).Nonempty := by
  obtain ⟨L, hL⟩ := hΛ
  exact ⟨shiftedLabel q 0 L, shiftedLabel_mem_gluedFamily (Nat.zero_le N) hL⟩

/-- The full sequential approximation conclusion, with unrestricted approximating
exponent vectors, as required by the dimensional induction. -/
def Approximates {d : ℕ} (Λ : Finset (Label d)) (a b : ℝ)
    (E : (Fin d → ℝ) → ℝ) : Prop :=
  ∀ L ∈ Λ, ∀ (h : ℕ → ℝ) (p : ℕ → (Fin d → ℝ)) (p₀ : Fin d → ℝ),
    (∀ n, 0 < h n) → Tendsto h atTop (𝓝 0) →
    Tendsto p atTop (𝓝 p₀) → Cube a b p₀ →
    (∀ n, Active Λ L (h n) (powerPoint (h n) (p n))) →
    ‖p₀ - L.slope‖ < E L.slope

/-- Compactness of the coordinate index supplies a least exponent. -/
lemma exists_hasMinimum {d : ℕ} (hd : 0 < d) (p : Fin d → ℝ) :
    ∃ t, HasMinimum p t := by
  classical
  let : Nonempty (Fin d) := ⟨⟨0, hd⟩⟩
  obtain ⟨i, hi, hmin⟩ := Finset.univ.exists_min_image p Finset.univ_nonempty
  exact ⟨p i, (fun j => hmin j (Finset.mem_univ _)), i, rfl⟩

/-- Assemble local fixed-minimum families into a global approximation family.
The two decay hypotheses are precisely those ensured by choosing each cut inside
both adjacent validity intervals. The local guarantees include the cut endpoints. -/
theorem gluedFamily_approximates {d N : ℕ} (hd : 0 < d)
    (t q : ℕ → ℝ) (Λ : ℕ → Finset (Label d)) (a b : ℝ)
    (E : (Fin d → ℝ) → ℝ)
    (hbaseline : ∀ j ≤ N, (⟨fun _ => t j, fun _ => 0⟩ : Label d) ∈ Λ j)
    (hslope : ∀ j ≤ N, ∀ L ∈ Λ j, ∀ i, t j ≤ L.slope i)
    (hcenters : ∀ j < N, t j < t (j + 1))
    (hupperdecay : ∀ j < N, ∀ L ∈ Λ j,
      L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ q j))
    (hlowerdecay : ∀ j < N, ∀ L ∈ Λ (j + 1),
      L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ q j))
    (hlocal : ∀ j ≤ N, ∀ μ ∈ Set.Icc a b,
      (j = 0 ∨ q (j - 1) ≤ μ) → (j = N ∨ μ ≤ q j) →
      ApproximatesAtMinimum (Λ j) a b μ E) :
    Approximates (gluedFamily N q Λ) a b E := by
  intro L hL h p p₀ hpos hh hp hp₀ hactive
  obtain ⟨j, hj, J, hJ, rfl⟩ := mem_gluedFamily_iff.mp hL
  have hh' : Tendsto h atTop (𝓝[>] (0 : ℝ)) :=
    tendsto_nhdsWithin_iff.mpr ⟨hh, Eventually.of_forall hpos⟩
  have hpeval : ∀ i, Tendsto (fun n => p n i) atTop (𝓝 (p₀ i)) :=
    tendsto_pi_nhds.mp hp
  obtain ⟨μ, hμ⟩ := exists_hasMinimum hd p₀
  have hupper : j = N ∨ μ ≤ q j := by
    by_cases hjN : j = N
    · exact Or.inl hjN
    right
    have hjlt : j < N := by omega
    have hcomparison : ∀ᶠ n in atTop,
        (∑ i, J.slope i * h n ^ p n i) + J.offset (h n) -
          (∑ k ∈ Finset.range j, h n ^ q k) ≤
        (∑ i : Fin d, t (j + 1) * h n ^ p n i) -
          (∑ k ∈ Finset.range (j + 1), h n ^ q k) := by
      apply Eventually.of_forall
      intro n
      have hc := (hactive n).2
        (shiftedLabel q (j + 1) ⟨fun _ => t (j + 1), fun _ => 0⟩)
        (shiftedLabel_mem_gluedFamily (by omega) (hbaseline (j + 1) (by omega)))
      simp only [shiftedLabel_value] at hc
      simpa only [Label.value, powerPoint, add_zero] using hc
    obtain ⟨i, hi⟩ := AffineGluing.shifted_active_upper_cut
      (fun k n => h n ^ q k) J.slope p₀ (t (j + 1)) (q j) j
      (Eventually.of_forall fun n => Real.rpow_pos_of_pos (hpos n) _)
      ((hupperdecay j hjlt J hJ).comp_tendsto hh')
      (fun i hgap => varying_rpow_isLittleO hh (Eventually.of_forall hpos) (hpeval i) hgap)
      hcomparison
    exact (hμ.1 i).trans hi
  have hlower : j = 0 ∨ q (j - 1) ≤ μ := by
    cases j with
    | zero => exact Or.inl rfl
    | succ k =>
      right
      have hk : k < N := by omega
      have hcomparison : ∀ᶠ n in atTop,
          (∑ i, J.slope i * h n ^ p n i) + J.offset (h n) -
            (∑ l ∈ Finset.range (k + 1), h n ^ q l) ≤
          (∑ i : Fin d, t k * h n ^ p n i) -
            (∑ l ∈ Finset.range k, h n ^ q l) := by
        apply Eventually.of_forall
        intro n
        have hc := (hactive n).2
          (shiftedLabel q k ⟨fun _ => t k, fun _ => 0⟩)
          (shiftedLabel_mem_gluedFamily (by omega) (hbaseline k (by omega)))
        simp only [shiftedLabel_value] at hc
        simpa only [Label.value, powerPoint, add_zero] using hc
      have hforced := AffineGluing.shifted_active_lower_cut
        (fun l n => h n ^ q l) J.slope p₀ (t k) (q k) k
        (fun i => (hcenters k hk).trans_le (hslope (k + 1) hj J hJ i))
        (Eventually.of_forall fun n => Real.rpow_pos_of_pos (hpos n) _)
        ((hlowerdecay k hk J hJ).comp_tendsto hh')
        (Eventually.of_forall fun n i => (Real.rpow_pos_of_pos (hpos n) (p n i)).le)
        (fun i hgap => tendsto_rpow_ratio_atTop hh (Eventually.of_forall hpos) (hpeval i) hgap)
        hcomparison
      obtain ⟨i, hi⟩ := hμ.2
      simpa only [Nat.add_sub_cancel, hi] using hforced i
  have hμab : μ ∈ Set.Icc a b := by
    obtain ⟨i, hi⟩ := hμ.2
    simpa only [Set.mem_Icc, hi] using hp₀ i
  have hresult := (hlocal j hj μ hμab hlower hupper) J hJ h p p₀ hpos hh hp hp₀ hμ
    (fun n => active_gluedFamily_restrict hj hJ (hactive n))
  simpa only [shiftedLabel_slope] using hresult

/-- Offset decay is preserved by the cumulative shifts because every cut
exponent lies strictly above the lower endpoint. -/
lemma shiftedLabel_offset_isLittleO {d : ℕ} {a : ℝ} (q : ℕ → ℝ)
    (j : ℕ) (L : Label d)
    (hL : L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ a))
    (hq : ∀ k < j, a < q k) :
    (shiftedLabel q j L).offset =o[𝓝[>] 0] (fun h : ℝ => h ^ a) := by
  have hsum : (fun h : ℝ => ∑ k ∈ Finset.range j, h ^ q k)
      =o[𝓝[>] 0] (fun h : ℝ => h ^ a) := by
    exact IsLittleO.sum (fun k hk => rpow_isLittleO_at_zero (hq k (Finset.mem_range.mp hk)))
  exact hL.sub hsum

/-- Arbitrary local radius certificates
are glued into one nonempty finite family. No regularity of `ρ`, `Γ`, or `E` is
assumed. Local guarantees on open bands suffice because all cuts lie strictly
inside both neighboring bands. -/
theorem exists_approximating_family_of_local_families {d : ℕ} (hd : 0 < d)
    {a b : ℝ} (hab : a ≤ b) (E : (Fin d → ℝ) → ℝ)
    (ρ : ℝ → ℝ) (Γ : ℝ → Finset (Label d))
    (hρ : ∀ t ∈ Set.Icc a b, 0 < ρ t)
    (hbaseline : ∀ t ∈ Set.Icc a b,
      (⟨fun _ => t, fun _ => 0⟩ : Label d) ∈ Γ t)
    (hdata : ∀ t ∈ Set.Icc a b, ∀ L ∈ Γ t,
      Cube a b L.slope ∧ HasMinimum L.slope t ∧
        L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ (t + ρ t)))
    (hlocal : ∀ t ∈ Set.Icc a b, ∀ μ : ℝ, |μ - t| < ρ t →
      ApproximatesAtMinimum (Γ t) a b μ E) :
    ∃ Λ : Finset (Label d), Λ.Nonempty ∧
      (∀ L ∈ Λ, Cube a b L.slope ∧
        L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ a)) ∧
      Approximates Λ a b E := by
  classical
  obtain ⟨N, c, q, hc, hcmem, hfirst, hlast, hcuts⟩ :=
    IntervalGluing.exists_interval_gluing hab ρ hρ
  let t : ℕ → ℝ := fun j => if hj : j ≤ N then c ⟨j, by omega⟩ else a
  let Q : ℕ → ℝ := fun j => if hj : j < N then q ⟨j, hj⟩ else a
  let Λ : ℕ → Finset (Label d) := fun j => Γ (t j)
  have htm : ∀ j ≤ N, t j ∈ Set.Icc a b := by
    intro j hj
    simpa [t, hj] using hcmem ⟨j, by omega⟩
  have hcut : ∀ j < N, t j < Q j ∧ Q j < t (j + 1) ∧
      Q j ∈ Set.Ioo (t j - ρ (t j)) (t j + ρ (t j)) ∧
      Q j ∈ Set.Ioo (t (j + 1) - ρ (t (j + 1))) (t (j + 1) + ρ (t (j + 1))) := by
    intro j hj
    have hjle : j ≤ N := by omega
    have hjsucc : j + 1 ≤ N := by omega
    simpa [t, Q, hj, hjle, hjsucc] using hcuts ⟨j, hj⟩
  have hfirst' : a ∈ Set.Ioo (t 0 - ρ (t 0)) (t 0 + ρ (t 0)) := by
    simpa [t] using hfirst
  have hlast' : b ∈ Set.Ioo (t N - ρ (t N)) (t N + ρ (t N)) := by
    simpa [t, Fin.last] using hlast
  have hbase : ∀ j ≤ N,
      (⟨fun _ => t j, fun _ => 0⟩ : Label d) ∈ Λ j := by
    intro j hj
    exact hbaseline (t j) (htm j hj)
  have hlocal' : ∀ j ≤ N, ∀ μ ∈ Set.Icc a b,
      (j = 0 ∨ Q (j - 1) ≤ μ) → (j = N ∨ μ ≤ Q j) →
      ApproximatesAtMinimum (Λ j) a b μ E := by
    intro j hj μ hμ hlo hhi
    have hlo' : t j - ρ (t j) < μ := by
      by_cases hj0 : j = 0
      · subst j
        exact hfirst'.1.trans_le hμ.1
      · have hpred : j - 1 < N := by omega
        have hpredj : j - 1 + 1 = j := by omega
        have hprev : t j - ρ (t j) < Q (j - 1) := by
          simpa only [hpredj] using (hcut (j - 1) hpred).2.2.2.1
        exact hprev.trans_le (hlo.resolve_left hj0)
    have hhi' : μ < t j + ρ (t j) := by
      by_cases hjN : j = N
      · subst j
        exact hμ.2.trans_lt hlast'.2
      · have hjlt : j < N := by omega
        exact (hhi.resolve_left hjN).trans_lt (hcut j hjlt).2.2.1.2
    exact hlocal (t j) (htm j hj) μ (abs_lt.mpr ⟨by linarith, by linarith⟩)
  have happrox : Approximates (gluedFamily N Q Λ) a b E := by
    apply gluedFamily_approximates hd t Q Λ a b E hbase
    · intro j hj L hL i
      exact (hdata (t j) (htm j hj) L hL).2.1.1 i
    · intro j hj
      exact (hcut j hj).1.trans (hcut j hj).2.1
    · intro j hj L hL
      exact ((hdata (t j) (htm j (by omega)) L hL).2.2).trans
        (rpow_isLittleO_at_zero (hcut j hj).2.2.1.2)
    · intro j hj L hL
      exact ((hdata (t (j + 1)) (htm (j + 1) (by omega)) L hL).2.2).trans
        (rpow_isLittleO_at_zero (hcut j hj).2.2.2.2)
    · exact hlocal'
  refine ⟨gluedFamily N Q Λ,
    gluedFamily_nonempty N Q Λ ⟨_, hbase 0 (Nat.zero_le N)⟩, ?_, happrox⟩
  intro L hL
  obtain ⟨j, hj, J, hJ, rfl⟩ := mem_gluedFamily_iff.mp hL
  have hJdata := hdata (t j) (htm j hj) J hJ
  refine ⟨hJdata.1, shiftedLabel_offset_isLittleO Q j J ?_ ?_⟩
  · exact hJdata.2.2.trans (rpow_isLittleO_at_zero (by
      have := hρ (t j) (htm j hj)
      have := (htm j hj).1
      linarith))
  · intro k hk
    exact (htm k (by omega)).1.trans_lt (hcut k (by omega)).1

/-- Choice-packaged form of the gluing theorem: local constructors may return
the radius and finite family existentially, and only for centers in the cube. -/
theorem exists_approximating_family_of_local_certificates {d : ℕ} (hd : 0 < d)
    {a b : ℝ} (hab : a ≤ b) (E : (Fin d → ℝ) → ℝ)
    (hcert : ∀ t ∈ Set.Icc a b, ∃ ρ : ℝ, 0 < ρ ∧
      ∃ Γ : Finset (Label d),
        (⟨fun _ => t, fun _ => 0⟩ : Label d) ∈ Γ ∧
        (∀ L ∈ Γ, Cube a b L.slope ∧ HasMinimum L.slope t ∧
          L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ (t + ρ))) ∧
        (∀ μ : ℝ, |μ - t| < ρ → ApproximatesAtMinimum Γ a b μ E)) :
    ∃ Λ : Finset (Label d), Λ.Nonempty ∧
      (∀ L ∈ Λ, Cube a b L.slope ∧
        L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ a)) ∧
      Approximates Λ a b E := by
  classical
  have hex : ∀ t : ℝ, ∃ ρ : ℝ, ∃ Γ : Finset (Label d),
      t ∈ Set.Icc a b → 0 < ρ ∧
        (⟨fun _ => t, fun _ => 0⟩ : Label d) ∈ Γ ∧
        (∀ L ∈ Γ, Cube a b L.slope ∧ HasMinimum L.slope t ∧
          L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ (t + ρ))) ∧
        (∀ μ : ℝ, |μ - t| < ρ → ApproximatesAtMinimum Γ a b μ E) := by
    intro t
    by_cases ht : t ∈ Set.Icc a b
    · obtain ⟨ρ, hρ, Γ, hΓ⟩ := hcert t ht
      exact ⟨ρ, Γ, fun _ => ⟨hρ, hΓ⟩⟩
    · exact ⟨1, ∅, fun h => (ht h).elim⟩
  choose ρ Γ hΓ using hex
  exact exists_approximating_family_of_local_families hd hab E ρ Γ
    (fun t ht => (hΓ t ht).1)
    (fun t ht => (hΓ t ht).2.1)
    (fun t ht => (hΓ t ht).2.2.1)
    (fun t ht => (hΓ t ht).2.2.2)

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.GlueLocalCertificates -/

namespace OAI

noncomputable section

open Set Filter
open scoped Topology

namespace Problem326.Affine

/-- The exact gluing interface used by the dimension induction. Local certificates
are first extended to nearby minimum levels with a common stronger decay radius,
then the finite interval construction glues them into one full certificate. -/
theorem glue_localCertificates {d : ℕ} (hd : 0 < d)
    {a b : ℝ} (hab : a ≤ b) (E : (Fin d → ℝ) → ℝ)
    (hlocal : ∀ t : ℝ, a ≤ t → t ≤ b →
      Nonempty (LocalCertificate d a b t E)) :
    Nonempty (FullCertificate d a b E) := by
  classical
  let I := {t : ℝ // t ∈ Icc a b}
  let C (t : I) : LocalCertificate d a b t.val E :=
    Classical.choice (hlocal t.val t.property.1 t.property.2)
  choose r hr hdecay happ using fun t : I => (C t).exists_radius hd
  let ρ (t : ℝ) : ℝ := if ht : t ∈ Icc a b then r ⟨t, ht⟩ else 1
  let Γ (t : ℝ) : Finset (Label d) :=
    if ht : t ∈ Icc a b then (C ⟨t, ht⟩).labels else ∅
  have hρ (t : ℝ) (ht : t ∈ Icc a b) : 0 < ρ t := by
    simpa only [ρ, dif_pos ht] using hr ⟨t, ht⟩
  have hbaseline (t : ℝ) (ht : t ∈ Icc a b) :
      (⟨fun _ => t, fun _ => 0⟩ : Label d) ∈ Γ t := by
    simpa only [Γ, dif_pos ht] using (C ⟨t, ht⟩).baseline
  have hdata (t : ℝ) (ht : t ∈ Icc a b) (L : Label d) (hL : L ∈ Γ t) :
      Cube a b L.slope ∧ HasMinimum L.slope t ∧
        L.offset =o[𝓝[>] 0] (fun h : ℝ => h ^ (t + ρ t)) := by
    have hLC : L ∈ (C ⟨t, ht⟩).labels := by
      simpa only [Γ, dif_pos ht] using hL
    refine ⟨?_, (C ⟨t, ht⟩).minima L hLC, ?_⟩
    · intro i
      have hi := (C ⟨t, ht⟩).slopes L hLC i
      exact ⟨ht.1.trans hi.1, hi.2⟩
    · simpa only [ρ, dif_pos ht] using hdecay ⟨t, ht⟩ L hLC
  have hnear (t : ℝ) (ht : t ∈ Icc a b) (μ : ℝ) (hμ : |μ - t| < ρ t) :
      ApproximatesAtMinimum (Γ t) a b μ E := by
    have hμ' : |μ - t| < r ⟨t, ht⟩ := by
      simpa only [ρ, dif_pos ht] using hμ
    simpa only [Γ, dif_pos ht] using happ ⟨t, ht⟩ μ hμ'
  obtain ⟨Λ, hΛ, hdataΛ, happΛ⟩ :=
    exists_approximating_family_of_local_families hd hab E ρ Γ hρ hbaseline hdata hnear
  exact ⟨{
    labels := Λ
    nonempty := hΛ
    slopes := fun L hL => (hdataΛ L hL).1
    offsets := fun L hL => (hdataΛ L hL).2
    approximation := happΛ
  }⟩

end Problem326.Affine

end

end OAI


/- BEGIN UPSTREAM MODULE OAI.Analysis.MassAction.AffineExistence -/

namespace OAI

noncomputable section

namespace Problem326.Affine

/-- The full affine approximation certificate, obtained by dimension induction
and finite interval gluing. The tolerance need not be continuous. -/
theorem exists_fullCertificate :
    ∀ d : ℕ, ∀ a b : ℝ, ∀ E : (Fin d → ℝ) → ℝ,
      a < b → (∀ r, Cube a b r → 0 < E r) →
      Nonempty (FullCertificate d a b E) := by
  apply fullCertificate_of_local_and_glue
  · intro d hd ih a b E hab hE t hat htb
    by_cases heq : t = b
    · subst t
      exact ⟨localCertificate_upper hd a b E (hE _ (fun _ => ⟨hab.le, le_rfl⟩))⟩
    · apply localCertificate_of_layers hd (lt_of_le_of_ne htb heq) E
        (hE _ (fun _ => ⟨hat, htb⟩))
      intro k hk hkd β htβ hβb
      obtain ⟨F, _, hF⟩ := exists_typeFamily_layerCertificate hk hkd htβ hβb E
        (fun r hr => hE r (fun i => ⟨hat.trans (hr i).1, (hr i).2⟩))
        (fun E' hE' => ih k hkd β b E' hβb hE')
      exact ⟨F, hF⟩
  · intro d hd a b E hab _ hlocal
    exact glue_localCertificates hd hab.le E hlocal

end Problem326.Affine

end

end OAI



namespace Campaign149

open Filter Topology
open OAI.Problem326.Affine

noncomputable section

/-- The literal cube-domain version of the shared manuscript lemma. -/
theorem literal_affine_lemma
    (m : ℕ) (_hm : 0 < m) (a b : ℝ) (hab : a < b)
    (E : {r : Fin m → ℝ // Cube a b r} → ℝ)
    (hE : ∀ r, 0 < E r) :
    ∃ (Λ : Finset (Label m)) (hs : ∀ L ∈ Λ, Cube a b L.slope),
      Λ.Nonempty ∧
      (∀ L ∈ Λ, L.offset =o[𝓝[>] (0 : ℝ)] (fun h => h ^ a)) ∧
      ∀ (L : Label m) (hL : L ∈ Λ)
        (h : ℕ → ℝ) (p : ℕ → (Fin m → ℝ)) (p₀ : Fin m → ℝ),
        (∀ n, 0 < h n) → Tendsto h atTop (𝓝 0) →
        Tendsto p atTop (𝓝 p₀) → Cube a b p₀ →
        (∀ n, Active Λ L (h n) (powerPoint (h n) (p n))) →
        ‖p₀ - L.slope‖ < E ⟨L.slope, hs L hL⟩ := by
  classical
  let extended : (Fin m → ℝ) → ℝ :=
    fun r => if hr : Cube a b r then E ⟨r, hr⟩ else 1
  have hpos : ∀ r, Cube a b r → 0 < extended r := by
    intro r hr
    simpa only [extended, dif_pos hr] using hE ⟨r, hr⟩
  obtain ⟨F⟩ := exists_fullCertificate m a b extended hab hpos
  refine ⟨F.labels, F.slopes, F.nonempty, F.offsets, ?_⟩
  intro L hL h p p₀ hh hh0 hp hp₀ hactive
  have hbound := F.approximation L hL h p p₀ hh hh0 hp hp₀ hactive
  simpa only [extended, dif_pos (F.slopes L hL)] using hbound

end
end Campaign149

#print axioms Campaign149.literal_affine_lemma
#print axioms OAI.Problem326.Affine.exists_fullCertificate
