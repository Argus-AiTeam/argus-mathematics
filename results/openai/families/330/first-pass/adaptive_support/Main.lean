import Mathlib

open Finset Filter
open scoped BigOperators Topology Classical

noncomputable section

namespace AdaptiveSupport

def probability {A : Type*} [Fintype A] (s : Finset A) : ℝ :=
  (s.card : ℝ) / Fintype.card A

theorem probability_nonneg {A : Type*} [Fintype A] (s : Finset A) :
    0 ≤ probability s := by
  unfold probability
  positivity

theorem probability_mono {A : Type*} [Fintype A] {s t : Finset A}
    (h : s ⊆ t) : probability s ≤ probability t := by
  unfold probability
  exact div_le_div_of_nonneg_right (by exact_mod_cast Finset.card_le_card h)
    (by positivity)

theorem probability_biUnion_le {A B : Type*} [Fintype B] [DecidableEq B]
    (s : Finset A) (f : A → Finset B) :
    probability (s.biUnion f) ≤ ∑ a ∈ s, probability (f a) := by
  simp only [probability, ← Finset.sum_div]
  exact div_le_div_of_nonneg_right (by exact_mod_cast Finset.card_biUnion_le)
    (by positivity)

def cylinder {I B C : Type*} [Fintype I] [Fintype B] [Fintype C]
    (f : I → B) (allowed : I → Finset C) : Finset (B → C) := by
  classical
  exact univ.filter fun color => ∀ i, color (f i) ∈ allowed i

def splitColors {I B C : Type*} (f : I → B) (hf : Function.Injective f) :
    (B → C) ≃ (I → C) × ({b : B // b ∉ Set.range f} → C) := by
  classical
  exact (Equiv.piEquivPiSubtypeProd (fun b => b ∈ Set.range f) (fun _ => C)).trans
    (Equiv.prodCongr
      ((Equiv.ofInjective f hf).symm.arrowCongr (Equiv.refl C)) (Equiv.refl _))

theorem splitColors_first {I B C : Type*} (f : I → B) (hf : Function.Injective f)
    (color : B → C) (i : I) : (splitColors f hf color).1 i = color (f i) := by
  rfl

theorem cylinder_probability_le {I B C : Type*}
    [Fintype I] [Fintype B] [Fintype C] [Nonempty C]
    (f : I → B) (hf : Function.Injective f) (allowed : I → Finset C)
    (H : ℕ) (hH : ∀ i, (allowed i).card ≤ H) :
    probability (cylinder f allowed) ≤
      ((H : ℝ) / Fintype.card C) ^ Fintype.card I := by
  classical
  let e := splitColors (C := C) f hf
  let F := {b : B // b ∉ Set.range f}
  have himage : (cylinder f allowed).image e =
      (Fintype.piFinset allowed) ×ˢ (univ : Finset (F → C)) := by
    ext p
    constructor
    · intro hp
      obtain ⟨color, hc, rfl⟩ := mem_image.mp hp
      refine mem_product.mpr ⟨Fintype.mem_piFinset.mpr ?_, mem_univ _⟩
      intro i
      have h := hc
      simp only [cylinder, mem_filter, mem_univ, true_and] at h
      exact h i
    · intro hp
      refine mem_image.mpr ⟨e.symm p, ?_, e.apply_symm_apply p⟩
      simp only [cylinder, mem_filter, mem_univ, true_and]
      intro i
      have he : (e (e.symm p)).1 i = p.1 i := by rw [e.apply_symm_apply]
      change (e.symm p) (f i) = p.1 i at he
      rw [he]
      exact Fintype.mem_piFinset.mp (mem_product.mp hp).1 i
  have hcard : (cylinder f allowed).card =
      (∏ i, (allowed i).card) * Fintype.card (F → C) := by
    rw [← Finset.card_image_of_injective (cylinder f allowed) e.injective, himage,
      Finset.card_product, Fintype.card_piFinset, Finset.card_univ]
  have hwhole : Fintype.card (B → C) =
      Fintype.card (I → C) * Fintype.card (F → C) := by
    simpa only [Fintype.card_prod] using Fintype.card_congr e
  have hfree : (Fintype.card (F → C) : ℝ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  have hprod : (∏ i, (allowed i).card) ≤ H ^ Fintype.card I := by
    calc
      _ ≤ ∏ _i : I, H :=
        Finset.prod_le_prod (by intro i hi; exact Nat.zero_le _) (by intro i hi; exact hH i)
      _ = _ := by simp
  calc
    probability (cylinder f allowed) =
        ((∏ i, (allowed i).card : ℕ) : ℝ) / Fintype.card (I → C) := by
      unfold probability
      rw [hcard, hwhole, Nat.cast_mul, Nat.cast_mul]
      exact mul_div_mul_right _ _ hfree
    _ ≤ (H : ℝ) ^ Fintype.card I /
        (Fintype.card C : ℝ) ^ Fintype.card I := by
      rw [Fintype.card_fun, Nat.cast_pow]
      exact div_le_div_of_nonneg_right (by exact_mod_cast hprod) (by positivity)
    _ = _ := by rw [div_pow]

def statePaths {S : Type*} [Fintype S] (next : S → Finset S) :
    (n : ℕ) → Finset (Fin (n + 1) → S)
  | 0 => by classical exact univ
  | n + 1 => by
      classical
      exact (statePaths next n).biUnion fun a =>
        (next (a (Fin.last n))).image fun j => Fin.snoc (α := fun _ => S) a j

def follows {S : Type*} (next : S → Finset S) :
    (n : ℕ) → (Fin (n + 1) → S) → Prop
  | 0, _ => True
  | n + 1, a => follows next n (Fin.init a) ∧
      a (Fin.last (n + 1)) ∈ next ((Fin.init a) (Fin.last n))

theorem mem_statePaths_iff {S : Type*} [Fintype S] (next : S → Finset S) :
    ∀ n (a : Fin (n + 1) → S), a ∈ statePaths next n ↔ follows next n a := by
  classical
  intro n
  induction n with
  | zero => intro a; simp [statePaths, follows]
  | succ n ih =>
      intro a
      rw [statePaths]
      constructor
      · intro ha
        obtain ⟨p, hp, ha⟩ := mem_biUnion.mp ha
        obtain ⟨j, hj, hja⟩ := mem_image.mp ha
        subst a
        simpa only [follows, Fin.init_snoc, Fin.snoc_last] using
          And.intro ((ih p).mp hp) hj
      · intro ha
        refine mem_biUnion.mpr ⟨Fin.init a, (ih _).mpr ha.1, ?_⟩
        exact mem_image.mpr ⟨a (Fin.last (n + 1)), ha.2, Fin.snoc_init_self a⟩

theorem statePaths_card_le {S : Type*} [Fintype S]
    (next : S → Finset S) (Q : ℕ)
    (hQ : ∀ j, (next j).card ≤ Q) (n : ℕ) :
    (statePaths next n).card ≤ Fintype.card S * Q ^ n := by
  classical
  induction n with
  | zero => simp [statePaths]
  | succ n ih =>
      rw [statePaths]
      calc
        _ ≤ ∑ a ∈ statePaths next n,
            ((next (a (Fin.last n))).image
              fun j => Fin.snoc (α := fun _ => S) a j).card := Finset.card_biUnion_le
        _ ≤ ∑ _a ∈ statePaths next n, Q := by
          apply Finset.sum_le_sum
          intro a ha
          exact le_trans Finset.card_image_le (hQ _)
        _ = (statePaths next n).card * Q := by simp
        _ ≤ (Fintype.card S * Q ^ n) * Q := Nat.mul_le_mul_right Q ih
        _ = _ := by rw [pow_succ]; ring

def matchEvent {S B C : Type*} [Fintype S] [Fintype B] [Fintype C]
    (next : S → Finset S) (allowed : S → Finset C) {n : ℕ}
    (walks : Finset (Fin (n + 1) → B)) : Finset (B → C) := by
  classical
  exact walks.biUnion fun w =>
    (statePaths next n).biUnion fun a => cylinder w (fun i => allowed (a i))

theorem tree_matching_bound {S B C : Type*}
    [Fintype S] [Fintype B] [Fintype C] [Nonempty C]
    (next : S → Finset S) (allowed : S → Finset C)
    (d Q H n : ℕ) (walks : Finset (Fin (n + 1) → B))
    (hwalks : walks.card ≤ d ^ n)
    (hinjective : ∀ w ∈ walks, Function.Injective w)
    (hQ : ∀ j, (next j).card ≤ Q)
    (hH : ∀ j, (allowed j).card ≤ H) :
    probability (matchEvent next allowed walks) ≤
      (Fintype.card S : ℝ) * ((H : ℝ) / Fintype.card C) *
        ((d : ℝ) * Q * H / Fintype.card C) ^ n := by
  classical
  let z : ℝ := ((H : ℝ) / Fintype.card C) ^ (n + 1)
  have hwalks' : (walks.card : ℝ) ≤ (d : ℝ) ^ n := by exact_mod_cast hwalks
  have hstates' : ((statePaths next n).card : ℝ) ≤
      (Fintype.card S : ℝ) * (Q : ℝ) ^ n := by
    exact_mod_cast statePaths_card_le next Q hQ n
  have hcounts : (walks.card : ℝ) * ((statePaths next n).card : ℝ) ≤
      (d : ℝ) ^ n * ((Fintype.card S : ℝ) * (Q : ℝ) ^ n) :=
    mul_le_mul hwalks' hstates' (by positivity) (by positivity)
  calc
    probability (matchEvent next allowed walks) ≤
        ∑ w ∈ walks, probability
          ((statePaths next n).biUnion fun a => cylinder w (fun i => allowed (a i))) :=
      probability_biUnion_le walks _
    _ ≤ ∑ w ∈ walks, ∑ a ∈ statePaths next n,
        probability (cylinder w (fun i => allowed (a i))) := by
      apply Finset.sum_le_sum
      intro w hw
      exact probability_biUnion_le _ _
    _ ≤ ∑ _w ∈ walks, ∑ _a ∈ statePaths next n, z := by
      apply Finset.sum_le_sum
      intro w hw
      apply Finset.sum_le_sum
      intro a ha
      simpa only [Fintype.card_fin] using
        cylinder_probability_le w (hinjective w hw) (fun i => allowed (a i)) H
          (fun i => hH (a i))
    _ = (walks.card : ℝ) * ((statePaths next n).card : ℝ) * z := by simp; ring
    _ ≤ ((d : ℝ) ^ n * ((Fintype.card S : ℝ) * (Q : ℝ) ^ n)) * z :=
      mul_le_mul_of_nonneg_right hcounts (by dsimp [z]; positivity)
    _ = (Fintype.card S : ℝ) * ((H : ℝ) / Fintype.card C) *
        ((d : ℝ) * Q * H / Fintype.card C) ^ n := by
      dsimp [z]
      simp only [div_eq_mul_inv, mul_pow, pow_succ]
      ring

def law {A T : Type*} [Fintype A] (f : A → T) (t : T) : ℝ := by
  classical
  exact probability (univ.filter fun a => f a = t)

theorem law_event {A T : Type*} [Fintype A] [Fintype T]
    (f : A → T) (E : Finset T) :
    (∑ t ∈ E, law f t) = probability (univ.filter fun a => f a ∈ E) := by
  classical
  have hcard (P : A → Prop) [DecidablePred P] :
      ((univ.filter P).card : ℝ) = ∑ a : A, if P a then 1 else 0 := by
    rw [← Finset.sum_filter]
    simp
  simp only [law, probability, hcard, ← Finset.sum_div]
  congr 1
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a ha
  simpa only [eq_comm] using Finset.sum_ite_eq' E (f a) (fun _ => (1 : ℝ))

theorem law_sum {A T : Type*} [Fintype A] [Nonempty A] [Fintype T]
    (f : A → T) : ∑ t, law f t = 1 := by
  classical
  rw [law_event]
  simp [probability, Fintype.card_ne_zero]

def totalVariation {T : Type*} [Fintype T] (p q : T → ℝ) : ℝ :=
  (∑ t, |p t - q t|) / 2

theorem event_le_totalVariation {T : Type*} [Fintype T]
    (p q : T → ℝ) (hp : ∑ t, p t = 1) (hq : ∑ t, q t = 1) (E : Finset T) :
    (∑ t ∈ E, p t) ≤ (∑ t ∈ E, q t) + totalVariation p q := by
  classical
  have hz : (∑ t, (p t - q t)) = 0 := by
    rw [Finset.sum_sub_distrib, hp, hq, sub_self]
  have hs := Finset.sum_add_sum_compl E (fun t : T => p t - q t)
  have ha := Finset.sum_add_sum_compl E (fun t : T => |p t - q t|)
  have h1 : (∑ t ∈ E, (p t - q t)) ≤ (∑ t ∈ E, |p t - q t|) :=
    Finset.sum_le_sum fun t ht => le_abs_self _
  have h2 : -(∑ t ∈ (Eᶜ : Finset T), (p t - q t)) ≤
      (∑ t ∈ (Eᶜ : Finset T), |p t - q t|) := by
    rw [← Finset.sum_neg_distrib]
    exact Finset.sum_le_sum fun t ht => neg_le_abs _
  rw [hz] at hs
  unfold totalVariation
  rw [Finset.sum_sub_distrib] at h1 hs
  nlinarith

theorem finite_discrepancy_transfer {S B C V T : Type*}
    [Fintype S] [Fintype B] [Fintype C] [Nonempty C]
    [Fintype V] [Nonempty V] [Fintype T]
    (next : S → Finset S) (allowed : S → Finset C)
    (d Q H n : ℕ) (walks : Finset (Fin (n + 1) → B))
    (hwalks : walks.card ≤ d ^ n)
    (hinjective : ∀ w ∈ walks, Function.Injective w)
    (hQ : ∀ j, (next j).card ≤ Q)
    (hH : ∀ j, (allowed j).card ≤ H)
    (rootType : V → T) (treeType : (B → C) → T) (E : Finset T)
    (hE : ∀ color, treeType color ∈ E ↔ color ∈ matchEvent next allowed walks)
    (bad : Finset V) (hbad : ∀ v ∈ bad, rootType v ∈ E) :
    probability bad ≤ totalVariation (law rootType) (law treeType) +
      (Fintype.card S : ℝ) * ((H : ℝ) / Fintype.card C) *
        ((d : ℝ) * Q * H / Fintype.card C) ^ n := by
  classical
  have hsubset : bad ⊆ univ.filter fun v => rootType v ∈ E := by
    intro v hv
    exact mem_filter.mpr ⟨mem_univ v, hbad v hv⟩
  have heq : (univ.filter fun color => treeType color ∈ E) =
      matchEvent next allowed walks := by
    ext color
    simp only [mem_filter, mem_univ, true_and, hE]
  have htv := event_le_totalVariation (law rootType) (law treeType)
    (law_sum rootType) (law_sum treeType) E
  rw [law_event, law_event, heq] at htv
  have htree := tree_matching_bound next allowed d Q H n walks hwalks hinjective hQ hH
  have hdom := probability_mono hsubset
  linarith

theorem ratio_lt_half (d Q H k : ℕ) (hk : 0 < k) (hgap : 2 * d * Q * H < k) :
    (d : ℝ) * Q * H / k < 1 / 2 := by
  have hk' : (0 : ℝ) < k := by exact_mod_cast hk
  have hg : (2 : ℝ) * d * Q * H < k := by exact_mod_cast hgap
  apply (div_lt_iff₀ hk').mpr
  nlinarith

theorem successive_selection
    (d Q H k s : ℕ) (hk : 0 < k) (hgap : 2 * d * Q * H < k)
    (epsilon beta : ℕ → ℕ → ℝ)
    (hlimit : ∀ n, Tendsto (epsilon n) atTop (nhds 0))
    (hbound : ∀ n m, beta n m ≤ epsilon n m +
      (s : ℝ) * ((H : ℝ) / k) * ((d : ℝ) * Q * H / k) ^ n)
    (delta : ℝ) (hdelta : 0 < delta) (m₀ : ℕ) :
    ∃ n ≥ 2, ∃ M ≥ m₀, ∀ m ≥ M, beta n m < delta := by
  let rho : ℝ := (d : ℝ) * Q * H / k
  have hrho : 0 ≤ rho := by dsimp [rho]; positivity
  have hrho' : rho < 1 := lt_trans (ratio_lt_half d Q H k hk hgap) (by norm_num)
  have hgeom : Tendsto (fun n : ℕ => (s : ℝ) * ((H : ℝ) / k) * rho ^ n)
      atTop (nhds 0) := by
    simpa only [mul_zero] using
      (tendsto_pow_atTop_nhds_zero_of_lt_one hrho hrho').const_mul
        ((s : ℝ) * ((H : ℝ) / k))
  obtain ⟨N, hN⟩ := Filter.eventually_atTop.mp
    ((tendsto_order.mp hgeom).2 (delta / 2) (by linarith))
  let n := max 2 N
  have hn : (s : ℝ) * ((H : ℝ) / k) * rho ^ n < delta / 2 :=
    hN n (le_max_right _ _)
  obtain ⟨M, hM⟩ := Filter.eventually_atTop.mp
    ((tendsto_order.mp (hlimit n)).2 (delta / 2) (by linarith))
  refine ⟨n, le_max_left _ _, max m₀ M, le_max_left _ _, ?_⟩
  intro m hm
  have heps := hM m (le_trans (le_max_right _ _) hm)
  have hb := hbound n m
  change beta n m ≤ epsilon n m + (s : ℝ) * ((H : ℝ) / k) * rho ^ n at hb
  linarith

#print axioms finite_discrepancy_transfer
#print axioms successive_selection

end AdaptiveSupport
