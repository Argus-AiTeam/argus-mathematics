import Mathlib

open scoped BigOperators

namespace OccurrenceEntropy

theorem root_code_bound
    {V A : Type*} [Fintype V] [DecidableEq V] [Fintype A]
    (F : Finset (V → A)) (seed root : Finset V)
    (D : Finset ({v : V // v ∈ root} → A))
    (rank : V → ℕ) (parent : V → V) (turn : V → A → A)
    (_hroot : root ⊆ seed)
    (hlower : ∀ v, v ∉ seed → rank (parent v) < rank v)
    (hdep : ∀ w ∈ F, ∀ v, v ∉ seed → w v = turn v (w (parent v)))
    (hdict : ∀ w ∈ F, (fun v : {v : V // v ∈ root} => w v.val) ∈ D) :
    F.card ≤ D.card * Fintype.card A ^ (seed \ root).card := by
  classical
  let code : {w // w ∈ F} →
      {r // r ∈ D} × ({v : V // v ∈ seed \ root} → A) :=
    fun w => (⟨fun v => w.val v.val, hdict w.val w.property⟩,
      fun v => w.val v.val)
  have hinj : Function.Injective code := by
    intro w w' heq
    apply Subtype.ext
    have same : ∀ n : ℕ, ∀ v : V, rank v = n → w.val v = w'.val v := by
      intro n
      induction n using Nat.strong_induction_on with
      | h n ih =>
        intro v hv
        by_cases hs : v ∈ seed
        · by_cases hr : v ∈ root
          · exact congrArg
              (fun c : {r // r ∈ D} × ({v : V // v ∈ seed \ root} → A) =>
                c.1.val ⟨v, hr⟩) heq
          · exact congrArg
              (fun c : {r // r ∈ D} × ({v : V // v ∈ seed \ root} → A) =>
                c.2 ⟨v, Finset.mem_sdiff.mpr ⟨hs, hr⟩⟩) heq
        · rw [hdep w.val w.property v hs, hdep w'.val w'.property v hs]
          exact congrArg (turn v)
            (ih (rank (parent v)) (by simpa [hv] using hlower v hs)
              (parent v) rfl)
    exact funext fun v => same (rank v) v rfl
  have hc := Fintype.card_le_of_injective code hinj
  simpa only [Fintype.card_prod, Fintype.card_coe, Fintype.card_fun] using hc

theorem projection_code_bound
    {V A B : Type*} [Fintype V] [DecidableEq V] [Fintype A] [DecidableEq B]
    (F : Finset (V → A)) (seed root : Finset V)
    (D : Finset ({v : V // v ∈ root} → A))
    (rank : V → ℕ) (parent : V → V) (turn : V → A → A)
    (hroot : root ⊆ seed)
    (hlower : ∀ v, v ∉ seed → rank (parent v) < rank v)
    (hdep : ∀ w ∈ F, ∀ v, v ∉ seed → w v = turn v (w (parent v)))
    (hdict : ∀ w ∈ F, (fun v : {v : V // v ∈ root} => w v.val) ∈ D)
    (project : (V → A) → B) :
    (F.image project).card ≤ D.card * Fintype.card A ^ (seed \ root).card :=
  (Finset.card_image_le).trans
    (root_code_bound F seed root D rank parent turn hroot hlower hdep hdict)

theorem acyclic_code_bound
    {V A : Type*} [Fintype V] [DecidableEq V] [Fintype A]
    (F : Finset (V → A)) (seed : Finset V)
    (rank : V → ℕ) (parent : V → V) (turn : V → A → A)
    (hlower : ∀ v, v ∉ seed → rank (parent v) < rank v)
    (hdep : ∀ w ∈ F, ∀ v, v ∉ seed → w v = turn v (w (parent v))) :
    F.card ≤ Fintype.card A ^ seed.card := by
  classical
  have h := root_code_bound F seed ∅ Finset.univ rank parent turn
    (by simp) hlower hdep (by intro w _; exact Finset.mem_univ _)
  simpa using h

theorem translation_self_bound
    {A : Type*} [Fintype A] (h t : ℕ) (ht : 0 < t)
    (target : Finset (Fin h)) (F : Finset (Fin h → A))
    (hshift : ∀ v ∈ target, t ≤ v.val)
    (hword : ∀ w ∈ F, ∀ v ∈ target,
      w v = w ⟨v.val - t, lt_of_le_of_lt (Nat.sub_le _ _) v.isLt⟩) :
    F.card ≤ Fintype.card A ^ (h - target.card) := by
  classical
  let parent : Fin h → Fin h :=
    fun v => ⟨v.val - t, lt_of_le_of_lt (Nat.sub_le _ _) v.isLt⟩
  have h := acyclic_code_bound F targetᶜ Fin.val parent (fun _ x => x)
    (by
      intro v hv
      have hv' : v ∈ target := by simpa using hv
      have := hshift v hv'
      simp only [parent]
      omega)
    (by
      intro w hw v hv
      exact hword w hw v (by simpa using hv))
  simpa [Finset.card_compl] using h

theorem nearly_full_reflection_impossible
    {A : Type*} (inv : A → A)
    (hfixed : ∀ a, inv a ≠ a)
    (w : ℕ → A) (h l k a : ℕ)
    (hfull : h < 2 * k)
    (hdom : l + k ≤ h)
    (himage_left : l + k - 1 ≤ a)
    (himage_right : a - l < h)
    (hreduced : ∀ i, i + 1 < h → w (i + 1) ≠ inv (w i))
    (hcompare : ∀ i, l ≤ i → i < l + k → w i = inv (w (a - i))) :
    False := by
  have hcenter_lo : l ≤ a / 2 := by omega
  have hcenter_hi : a / 2 < l + k := by omega
  by_cases heven : a % 2 = 0
  · have hmirror : a - a / 2 = a / 2 := by omega
    have hc := hcompare (a / 2) hcenter_lo hcenter_hi
    rw [hmirror] at hc
    exact hfixed (w (a / 2)) hc.symm
  · have hodd : a % 2 = 1 := by omega
    have hu : a / 2 + 1 < l + k := by omega
    have hmirror : a - (a / 2 + 1) = a / 2 := by omega
    have hc := hcompare (a / 2 + 1) (by omega) hu
    rw [hmirror] at hc
    exact hreduced (a / 2) (by omega) hc

theorem occurrence_balance
    {O B : Type*} [Fintype O] [DecidableEq O] [DecidableEq B]
    (owner : O → B) (matched : Finset O) (pair : O → O)
    (_hclosed : ∀ o ∈ matched, pair o ∈ matched)
    (hinvol : ∀ o ∈ matched, pair (pair o) = o)
    (hdifferent : ∀ o ∈ matched, owner (pair o) ≠ owner o)
    (r : B) :
    2 * (Finset.univ.filter (fun o => owner o = r)).card ≤
      Fintype.card O + matchedᶜ.card := by
  classical
  let R := Finset.univ.filter (fun o => owner o = r)
  have hmap : Set.MapsTo pair ((R ∩ matched : Finset O) : Set O)
      ((Rᶜ : Finset O) : Set O) := by
    intro o ho
    have hoR : owner o = r := (Finset.mem_filter.mp (Finset.mem_inter.mp ho).1).2
    have hd := hdifferent o (Finset.mem_inter.mp ho).2
    simpa [R, hoR] using hd
  have hinj : Set.InjOn pair ((R ∩ matched : Finset O) : Set O) := by
    intro o ho o' ho' heq
    have := congrArg pair heq
    simpa [hinvol o (Finset.mem_inter.mp ho).2,
      hinvol o' (Finset.mem_inter.mp ho').2] using this
  have hmatched := Finset.card_le_card_of_injOn pair hmap hinj
  have hfree : (R \ matched).card ≤ matchedᶜ.card := by
    apply Finset.card_le_card
    intro o ho
    simpa using (Finset.mem_sdiff.mp ho).2
  have hpartition := Finset.card_inter_add_card_sdiff R matched
  have htotal := Finset.card_add_card_compl R
  change 2 * R.card ≤ Fintype.card O + matchedᶜ.card
  omega

theorem squared_mass_bin_bound
    {W : Type*} [Fintype W] (p : W → ℝ)
    (D : Finset W) (c Q : ℝ)
    (hc : 0 ≤ c) (hp : ∀ w, 0 ≤ p w)
    (hbin : ∀ w ∈ D, c ≤ p w)
    (hmass : ∑ w, (p w) ^ 2 ≤ Q) :
    (D.card : ℝ) * c ^ 2 ≤ Q := by
  classical
  calc
    (D.card : ℝ) * c ^ 2 = ∑ _w ∈ D, c ^ 2 := by simp
    _ ≤ ∑ w ∈ D, (p w) ^ 2 := by
      apply Finset.sum_le_sum
      intro w hw
      have := hbin w hw
      have := hp w
      nlinarith
    _ ≤ ∑ w, (p w) ^ 2 := by
      apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ D)
      intro w _ _
      positivity
    _ ≤ Q := hmass

theorem projected_moment_bound
    {V A B : Type*} [Fintype V] [DecidableEq V] [Fintype A] [DecidableEq B]
    (F : Finset (V → A)) (seed root : Finset V)
    (rank : V → ℕ) (parent : V → V) (turn : V → A → A)
    (hroot : root ⊆ seed)
    (hlower : ∀ v, v ∉ seed → rank (parent v) < rank v)
    (hdep : ∀ w ∈ F, ∀ v, v ∉ seed → w v = turn v (w (parent v)))
    (p : ({v : V // v ∈ root} → A) → ℝ) (c Q : ℝ)
    (hc : 0 ≤ c) (hp : ∀ r, 0 ≤ p r)
    (hmass : ∑ r, (p r) ^ 2 ≤ Q)
    (hbin : ∀ w ∈ F, c ≤ p (fun v => w v.val))
    (project : (V → A) → B) :
    ((F.image project).card : ℝ) * c ^ 2 ≤
      Q * (Fintype.card A : ℝ) ^ (seed \ root).card := by
  classical
  let D := Finset.univ.filter (fun r => c ≤ p r)
  have hdict : ∀ w ∈ F, (fun v : {v : V // v ∈ root} => w v.val) ∈ D := by
    intro w hw
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, hbin w hw⟩
  have hn := projection_code_bound F seed root D rank parent turn
    hroot hlower hdep hdict project
  have hnreal :
      ((F.image project).card : ℝ) ≤
        (D.card : ℝ) * (Fintype.card A : ℝ) ^ (seed \ root).card := by
    exact_mod_cast hn
  have hm := squared_mass_bin_bound p D c Q hc hp
    (fun r hr => (Finset.mem_filter.mp hr).2) hmass
  calc
    ((F.image project).card : ℝ) * c ^ 2 ≤
        ((D.card : ℝ) * (Fintype.card A : ℝ) ^ (seed \ root).card) * c ^ 2 :=
      mul_le_mul_of_nonneg_right hnreal (sq_nonneg c)
    _ = ((D.card : ℝ) * c ^ 2) *
        (Fintype.card A : ℝ) ^ (seed \ root).card := by ring
    _ ≤ Q * (Fintype.card A : ℝ) ^ (seed \ root).card :=
      mul_le_mul_of_nonneg_right hm (by positivity)

theorem component_exponent
    {B : Type*} [Fintype B] (m d : B → ℝ)
    (r : B) (z b delta upper : ℝ)
    (hm : ∀ i, 0 ≤ m i)
    (hdelta : 0 ≤ delta) (hb : 0 ≤ b)
    (hlow : ∀ i, delta / 2 ≤ d i)
    (hupp : ∀ i, d i ≤ upper)
    (hmin : ∀ i, d r ≤ d i)
    (hbalance : 2 * z ≤ (∑ i, m i) + b) :
    -(∑ i, m i * d i) + 2 * z * d r - delta * z ≤
      -(delta / 2) * (∑ i, m i) + upper * b := by
  have hcost : (∑ i, m i) * d r ≤ ∑ i, m i * d i := by
    rw [Finset.sum_mul]
    apply Finset.sum_le_sum
    intro i _
    exact mul_le_mul_of_nonneg_left (hmin i) (hm i)
  have hrnon : 0 ≤ d r := by have := hlow r; linarith
  have hu : 0 ≤ upper := hrnon.trans (hupp r)
  by_cases hz : 2 * z ≤ ∑ i, m i
  · have hgap := mul_nonneg (sub_nonneg.mpr hz)
      (sub_nonneg.mpr (hlow r))
    have hfree := mul_nonneg hu hb
    nlinarith
  · have hz' : 0 ≤ 2 * z - ∑ i, m i := by linarith
    have hgap := mul_nonneg hz' (sub_nonneg.mpr (hupp r))
    have hfree := mul_nonneg hu (show 0 ≤ b - (2 * z - ∑ i, m i) by linarith)
    have hdecay := mul_nonneg hdelta
      (show 0 ≤ z - (∑ i, m i) / 2 by linarith)
    nlinarith

theorem self_component_exponent
    {B : Type*} [Fintype B] (m d : B → ℝ) (delta : ℝ)
    (hm : ∀ i, 0 ≤ m i) (hlow : ∀ i, delta / 2 ≤ d i) :
    -(∑ i, m i * d i) ≤ -(delta / 2) * (∑ i, m i) := by
  have hcost : (∑ i, m i) * (delta / 2) ≤ ∑ i, m i * d i := by
    rw [Finset.sum_mul]
    exact Finset.sum_le_sum fun i _ =>
      mul_le_mul_of_nonneg_left (hlow i) (hm i)
  nlinarith

theorem matched_component_exponent
    {O B : Type*} [Fintype O] [DecidableEq O] [Fintype B] [DecidableEq B]
    (owner : O → B) (matched : Finset O) (pair : O → O)
    (hclosed : ∀ o ∈ matched, pair o ∈ matched)
    (hinvol : ∀ o ∈ matched, pair (pair o) = o)
    (hdifferent : ∀ o ∈ matched, owner (pair o) ≠ owner o)
    (d : B → ℝ) (r rmax : B) (delta upper : ℝ)
    (hdelta : 0 ≤ delta)
    (hlow : ∀ i, delta / 2 ≤ d i)
    (hupp : ∀ i, d i ≤ upper)
    (hmin : ∀ i, d r ≤ d i) :
    -(∑ i, ((Finset.univ.filter (fun o => owner o = i)).card : ℝ) * d i) +
        2 * ((Finset.univ.filter (fun o => owner o = rmax)).card : ℝ) * d r -
        delta * ((Finset.univ.filter (fun o => owner o = rmax)).card : ℝ) ≤
      -(delta / 2) * (Fintype.card O : ℝ) + upper * (matchedᶜ.card : ℝ) := by
  have hsum : (∑ i, (Finset.univ.filter (fun o => owner o = i)).card) =
      Fintype.card O := by
    simpa using
      (Finset.card_eq_sum_card_fiberwise
        (s := Finset.univ) (t := Finset.univ)
        (f := owner) (by intro o _; exact Finset.mem_univ _)).symm
  have hsreal :
      (∑ i, ((Finset.univ.filter (fun o => owner o = i)).card : ℝ)) =
        (Fintype.card O : ℝ) := by exact_mod_cast hsum
  have hbal := occurrence_balance owner matched pair hclosed hinvol hdifferent rmax
  have hbalreal :
      2 * ((Finset.univ.filter (fun o => owner o = rmax)).card : ℝ) ≤
        (Fintype.card O : ℝ) + (matchedᶜ.card : ℝ) := by exact_mod_cast hbal
  have hx := component_exponent
    (fun i => ((Finset.univ.filter (fun o => owner o = i)).card : ℝ))
    d r ((Finset.univ.filter (fun o => owner o = rmax)).card : ℝ)
    (matchedᶜ.card : ℝ) delta upper
    (by intro i; positivity) hdelta (by positivity)
    hlow hupp hmin (by simpa [hsreal] using hbalreal)
  simpa [hsreal] using hx

theorem uniform_epsilon_budget
    (delta a H b error epsilon : ℝ)
    (hd : 0 < delta) (ha : 0 ≤ a) (hH : 0 ≤ H)
    (he : epsilon ≤ delta / (16 * (1 + a)))
    (hb : b ≤ epsilon * H)
    (herr : error ≤ delta * H / 8) :
    -(delta / 2) * H + a * b + error ≤ -(delta / 4) * H := by
  have hden : 0 < 16 * (1 + a) := by positivity
  have he' : epsilon * (16 * (1 + a)) ≤ delta :=
    (le_div_iff₀ hden).mp he
  have hm := mul_le_mul_of_nonneg_right he' hH
  have hab := mul_le_mul_of_nonneg_left hb ha
  have hsmall : a * (epsilon * H) ≤ delta * H / 16 := by
    by_cases hn : 0 ≤ epsilon
    · have hnon := mul_nonneg hn hH
      nlinarith
    · have hn' : epsilon * H ≤ 0 := mul_nonpos_of_nonpos_of_nonneg (le_of_not_ge hn) hH
      have ha' := mul_nonpos_of_nonneg_of_nonpos ha hn'
      have hpos := mul_nonneg (le_of_lt hd) hH
      nlinarith
  nlinarith

theorem log129_lt_five : Real.log 129 < 5 := by
  have he : (21 / 20 : ℝ) ≤ Real.exp (1 / 20) := by
    linarith [Real.add_one_le_exp (1 / 20 : ℝ)]
  have hp := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 21 / 20) he 100
  have heq : Real.exp (1 / 20 : ℝ) ^ 100 = Real.exp 5 := by
    rw [← Real.exp_nat_mul]
    norm_num
  rw [heq] at hp
  apply (Real.log_lt_iff_lt_exp (by norm_num : (0 : ℝ) < 129)).mpr
  have hr : (129 : ℝ) < (21 / 20 : ℝ) ^ 100 := by norm_num
  exact hr.trans_le hp

theorem manuscript_epsilon_budget
    (H b error : ℝ) (hH : 0 ≤ H)
    (hb : b ≤ H / 57600) (he : error ≤ H / 4800) :
    -(1 / 1200 : ℝ) * H + 5 * b + error ≤ -(1 / 2400 : ℝ) * H := by
  nlinarith

end OccurrenceEntropy
