import Mathlib

namespace Continuation

theorem interior_integer_hit
    (s d : ℝ) (z : ℤ) (hs : 0 < s) (hs' : s < 1)
    (hd : |d| ≤ 1) (hz : (1 - s) * d = (z : ℝ)) :
    d = 0 := by
  have hsmall : |(1 - s) * d| < 1 := by
    rw [abs_mul, abs_of_pos (by linarith : 0 < 1 - s)]
    calc
      (1 - s) * |d| ≤ (1 - s) * 1 :=
        mul_le_mul_of_nonneg_left hd (by linarith)
      _ < 1 := by linarith
  rw [hz, abs_lt] at hsmall
  have hzsmall : (-1 : ℤ) < z ∧ z < 1 := by
    exact_mod_cast hsmall
  have hz0 : z = 0 := by omega
  have hmul : (1 - s) * d = 0 := by simpa [hz0] using hz
  exact (mul_eq_zero.mp hmul).resolve_left (by linarith)

theorem root_sum_time_strict_between
    (f g : ℝ → ℝ) (hf : StrictMono f) (hg : StrictMono g)
    (a b c : ℝ) (ha : f a = 0) (hb : g b = 0)
    (hc : f c + g c = 0) (hab : a < b) :
    a < c ∧ c < b := by
  constructor
  · by_contra hn
    have hca : c ≤ a := le_of_not_gt hn
    have hfc : f c ≤ f a := hf.monotone hca
    have hgc : g c < g b := hg (lt_of_le_of_lt hca hab)
    linarith
  · by_contra hn
    have hbc : b ≤ c := le_of_not_gt hn
    have hgc : g b ≤ g c := hg.monotone hbc
    have hfc : f a < f c := hf (lt_of_lt_of_le hab hbc)
    linarith

theorem root_sum_time_tie
    (f g : ℝ → ℝ) (hf : StrictMono f) (hg : StrictMono g)
    (a c : ℝ) (ha : f a = 0) (hb : g a = 0)
    (hc : f c + g c = 0) :
    c = a := by
  rcases lt_trichotomy c a with h | h | h
  · have hfc := hf h
    have hgc := hg h
    linarith
  · exact h
  · have hfc := hf h
    have hgc := hg h
    linarith

def MedianOrder (i j h : ℝ) : Prop :=
  (i < j ∧ i < h ∧ h < j) ∨
  (i = j ∧ h = i) ∨
  (j < i ∧ j < h ∧ h < i)

theorem root_sum_median_order
    (f g : ℝ → ℝ) (hf : StrictMono f) (hg : StrictMono g)
    (i j h : ℝ) (hi : f i = 0) (hj : g j = 0)
    (hh : f h + g h = 0) :
    MedianOrder i j h := by
  rcases lt_trichotomy i j with hij | hij | hij
  · exact Or.inl ⟨hij, root_sum_time_strict_between f g hf hg i j h hi hj hh hij⟩
  · subst j
    exact Or.inr (Or.inl ⟨rfl, root_sum_time_tie f g hf hg i h hi hj hh⟩)
  · have hm := root_sum_time_strict_between g f hg hf j i h hj hi
      (by linarith) hij
    exact Or.inr (Or.inr ⟨hij, hm⟩)

theorem a2_diamond_descent (i j h : ℝ) (hm : MedianOrder i j h) :
    (j < i → j < i) ∧
    (h < j → i < j) ∧
    (h < i → j < i) ∧
    (i < j → i < j) ∧
    (i < j → h < j) ∧
    (j < h → j < h) ∧
    (j < i → h < i) ∧
    (i < h → i < h) := by
  rcases hm with ⟨_, _, _⟩ | ⟨_, _⟩ | ⟨_, _, _⟩ <;>
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> intro H <;> linarith

theorem pair_replacement_lex
    (pre post : List ℝ) (a b c d : ℝ) (hca : c < a) :
    List.Lex (· < ·) (pre ++ c :: d :: post)
      (pre ++ a :: b :: post) := by
  exact List.Lex.append_left _ (List.Lex.rel hca) pre

theorem finite_sorting_normal_form
    {A V : Type*} [Fintype A] [LinearOrder V]
    (score : A → V) (step : A → A → Prop)
    (decreases : ∀ {a b}, step a b → score b < score a) (start : A) :
    ∃ finish, Relation.ReflTransGen step start finish ∧
      ∀ next, ¬ step finish next := by
  classical
  let reached : Finset A :=
    Finset.univ.filter (fun a => Relation.ReflTransGen step start a)
  have hne : reached.Nonempty := by
    refine ⟨start, ?_⟩
    simp [reached, Relation.ReflTransGen.refl]
  obtain ⟨finish, hfinish, hmin⟩ := reached.exists_min_image score hne
  have hreach : Relation.ReflTransGen step start finish := by
    simpa [reached] using hfinish
  refine ⟨finish, hreach, ?_⟩
  intro next hstep
  have hnext : next ∈ reached := by
    simpa [reached] using hreach.tail hstep
  exact (not_lt_of_ge (hmin next hnext)) (decreases hstep)

theorem strict_descent_card_bound
    {A V : Type*} [Fintype A] [LinearOrder V]
    (score : A → V) (m : ℕ) (states : Fin (m + 1) → A)
    (h : StrictAnti (fun i => score (states i))) :
    m + 1 ≤ Fintype.card A := by
  have hinj : Function.Injective states := by
    intro i j hij
    exact h.injective (congrArg score hij)
  simpa using Fintype.card_le_of_injective states hinj

theorem orthogonal_parity_singularity
    {I : Type*} [Fintype I] [DecidableEq I]
    (P : Matrix I I ℝ) (ho : P * P.transpose = 1)
    (hp : (-1 : ℝ) ^ Fintype.card I * P.det = -1) :
    (1 - P).det = 0 := by
  have hid : (-P) * (1 - P).transpose = 1 - P := by
    rw [Matrix.transpose_sub, Matrix.transpose_one, mul_sub, mul_one, neg_mul, ho]
    abel
  have hdet := congrArg Matrix.det hid
  rw [Matrix.det_mul, Matrix.det_neg, Matrix.det_transpose, hp] at hdet
  linarith

theorem common_potential_of_fixed_vector
    {E V : Type*} [AddCommGroup E] [Module ℝ E]
    [AddCommGroup V] [Module ℝ V]
    (B : V →ₗ[ℝ] E) (G : E →ₗ[ℝ] V) (P : E →ₗ[ℝ] E)
    (ht : B.comp G = LinearMap.id - P)
    (hG : Function.Injective G) (d : V)
    (hk : ∀ v, B v = 0 → ∃ a : ℝ, v = a • d)
    (x : E) (hx : x ≠ 0) (hfix : P x = x) :
    ∃ L, G L = d := by
  have hzero : B (G x) = 0 := by
    have heq := LinearMap.congr_fun ht x
    simpa [hfix] using heq
  obtain ⟨a, ha⟩ := hk (G x) hzero
  have ha0 : a ≠ 0 := by
    intro hz
    have hGx : G x = 0 := by simpa [hz] using ha
    apply hx
    apply hG
    simpa using hGx
  refine ⟨a⁻¹ • x, ?_⟩
  rw [map_smul, ha, smul_smul, inv_mul_cancel₀ ha0, one_smul]

theorem endpoint_of_compact_right_extension
    (S : Set ℝ) (hcompact : IsCompact S) (hne : S.Nonempty)
    (hbound : ∀ s ∈ S, s ≤ 1)
    (hextend : ∀ s ∈ S, s < 1 → ∃ t ∈ S, s < t) :
    1 ∈ S := by
  obtain ⟨s, hs⟩ := hcompact.exists_isGreatest hne
  have hsle : s ≤ 1 := hbound s hs.1
  have hseq : s = 1 := by
    by_contra hne
    obtain ⟨t, ht, hst⟩ := hextend s hs.1 (lt_of_le_of_ne hsle hne)
    exact (not_lt_of_ge (hs.2 ht)) hst
  simpa [hseq] using hs.1

end Continuation
