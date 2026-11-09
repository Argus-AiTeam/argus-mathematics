import Mathlib

open Finset
open scoped Classical

namespace AlignmentAudit

universe u

def triple (lo mid hi : ℕ) : Finset ℕ := {lo, mid, hi}

def Aligned {M : Type u} (A : Finset ℕ → Finset M) (B : Finset ℕ) : Prop :=
  ∃ a : M → ℕ, (∀ x, a x ∈ B) ∧
    ∀ I, I.Nonempty → I ⊆ B → ∀ x ∈ A I, a x ∈ I

def RootFor {M : Type u} (A : Finset ℕ → Finset M)
    (B : Finset ℕ) (x : M) : Prop :=
  ∃ p ∈ B, ∀ I, I.Nonempty → I ⊆ B → x ∈ A I → p ∈ I

def SeparatedOn {M : Type u} (A : Finset ℕ → Finset M) (U : Finset ℕ) : Prop :=
  ∀ I J, I.Nonempty → J.Nonempty → I ⊆ U → J ⊆ U →
    I.card ≤ 3 → J.card ≤ 3 →
    (∀ i ∈ I, ∀ j ∈ J, i < j) → Disjoint (A I) (A J)

def Witness {M : Type u} (A : Finset ℕ → Finset M)
    (lo mid hi : ℕ) (x : M) : Prop :=
  x ∈ A {lo, hi} ∧
    (∃ L, L.Nonempty ∧ L ⊆ {lo, mid} ∧ x ∈ A L) ∧
    (∃ R, R.Nonempty ∧ R ⊆ {mid, hi} ∧ x ∈ A R)

theorem aligned_iff_roots {M : Type u} (A : Finset ℕ → Finset M)
    (B : Finset ℕ) : Aligned A B ↔ ∀ x, RootFor A B x := by
  classical
  constructor
  · rintro ⟨a, haB, ha⟩ x
    exact ⟨a x, haB x, fun I hI hIB hx => ha I hI hIB x hx⟩
  · intro h
    let a : M → ℕ := fun x => (h x).choose
    refine ⟨a, fun x => (h x).choose_spec.1, ?_⟩
    intro I hI hIB x hx
    exact (h x).choose_spec.2 I hI hIB hx

theorem avoiding_occurrence {M : Type u} {A : Finset ℕ → Finset M}
    {B : Finset ℕ} {x : M} (h : ¬ RootFor A B x)
    {p : ℕ} (hp : p ∈ B) :
    ∃ I, I.Nonempty ∧ I ⊆ B ∧ x ∈ A I ∧ p ∉ I := by
  classical
  by_contra hno
  apply h
  refine ⟨p, hp, ?_⟩
  intro I hI hIB hx
  by_contra hpI
  exact hno ⟨I, hI, hIB, hx, hpI⟩

theorem card_triple_le (lo mid hi : ℕ) : (triple lo mid hi).card ≤ 3 := by
  have h₁ := Finset.card_insert_le lo ({mid, hi} : Finset ℕ)
  have h₂ := Finset.card_insert_le mid ({hi} : Finset ℕ)
  simp only [Finset.card_singleton] at h₂
  dsimp [triple]
  omega

theorem card_pair_le {I : Finset ℕ} {a b : ℕ}
    (h : I ⊆ {a, b}) : I.card ≤ 3 := by
  have h₁ := Finset.card_le_card h
  have h₂ := Finset.card_insert_le a ({b} : Finset ℕ)
  simp only [Finset.card_singleton] at h₂
  omega

theorem bad_triple_witness {M : Type u} {A : Finset ℕ → Finset M}
    {U : Finset ℕ} (hsep : SeparatedOn A U)
    {lo mid hi : ℕ} (hlo : lo < mid) (hhi : mid < hi)
    (hBU : triple lo mid hi ⊆ U)
    (hbad : ¬ Aligned A (triple lo mid hi)) :
    ∃ x, Witness A lo mid hi x := by
  classical
  have hroot : ∃ x, ¬ RootFor A (triple lo mid hi) x := by
    by_contra! h
    exact hbad ((aligned_iff_roots A _).2 h)
  obtain ⟨x, hx⟩ := hroot
  obtain ⟨I, hIne, hIB, hxI, hmidI⟩ :=
    avoiding_occurrence hx (p := mid) (by simp [triple])
  obtain ⟨L, hLne, hLB, hxL, hhiL⟩ :=
    avoiding_occurrence hx (p := hi) (by simp [triple])
  obtain ⟨R, hRne, hRB, hxR, hloR⟩ :=
    avoiding_occurrence hx (p := lo) (by simp [triple])
  have hIo : I ⊆ {lo, hi} := by
    intro z hz
    have hzB := hIB hz
    simp only [triple, Finset.mem_insert, Finset.mem_singleton] at hzB ⊢
    rcases hzB with h | h | h
    · exact Or.inl h
    · exact (hmidI (h ▸ hz)).elim
    · exact Or.inr h
  have hLl : L ⊆ {lo, mid} := by
    intro z hz
    have hzB := hLB hz
    simp only [triple, Finset.mem_insert, Finset.mem_singleton] at hzB ⊢
    rcases hzB with h | h | h
    · exact Or.inl h
    · exact Or.inr h
    · exact (hhiL (h ▸ hz)).elim
  have hRr : R ⊆ {mid, hi} := by
    intro z hz
    have hzB := hRB hz
    simp only [triple, Finset.mem_insert, Finset.mem_singleton] at hzB ⊢
    rcases hzB with h | h | h
    · exact (hloR (h ▸ hz)).elim
    · exact Or.inl h
    · exact Or.inr h
  have hloI : lo ∈ I := by
    by_contra hn
    have hd := hsep L I hLne hIne (hLB.trans hBU) (hIB.trans hBU)
      (card_pair_le hLl) (card_pair_le hIo) (by
        intro a ha b hb
        have ha' := hLl ha
        have hb' := hIo hb
        simp only [Finset.mem_insert, Finset.mem_singleton] at ha' hb'
        rcases ha' with rfl | rfl <;> rcases hb' with rfl | rfl
        · exact (hn hb).elim
        · omega
        · exact (hn hb).elim
        · exact hhi)
    exact Finset.disjoint_left.mp hd hxL hxI
  have hhiI : hi ∈ I := by
    by_contra hn
    have hd := hsep I R hIne hRne (hIB.trans hBU) (hRB.trans hBU)
      (card_pair_le hIo) (card_pair_le hRr) (by
        intro a ha b hb
        have ha' := hIo ha
        have hb' := hRr hb
        simp only [Finset.mem_insert, Finset.mem_singleton] at ha' hb'
        rcases ha' with rfl | rfl <;> rcases hb' with rfl | rfl
        · exact hlo
        · omega
        · exact (hn ha).elim
        · exact (hn ha).elim)
    exact Finset.disjoint_left.mp hd hxI hxR
  have hIe : I = {lo, hi} := Finset.Subset.antisymm hIo (by
    intro z hz
    simp only [Finset.mem_insert, Finset.mem_singleton] at hz
    rcases hz with rfl | rfl
    · exact hloI
    · exact hhiI)
  refine ⟨x, ?_, ⟨L, hLne, hLl, hxL⟩, ⟨R, hRne, hRr, hxR⟩⟩
  simpa only [hIe] using hxI

theorem witness_middle_unique {M : Type u} {A : Finset ℕ → Finset M}
    {U : Finset ℕ} (hsep : SeparatedOn A U)
    {lo mid mid' hi : ℕ}
    (hlo : lo < mid) (hhi : mid < hi)
    (hlo' : lo < mid') (hhi' : mid' < hi)
    (hBU : triple lo mid hi ⊆ U)
    (hB'U : triple lo mid' hi ⊆ U)
    {x : M} (h : Witness A lo mid hi x) (h' : Witness A lo mid' hi x) :
    mid = mid' := by
  classical
  suffices ordered :
      ∀ a b, lo < a → a < b → b < hi →
        triple lo a hi ⊆ U → triple lo b hi ⊆ U →
        Witness A lo a hi x → Witness A lo b hi x → False by
    rcases lt_trichotomy mid mid' with hlt | heq | hgt
    · exact (ordered mid mid' hlo hlt hhi' hBU hB'U h h').elim
    · exact heq
    · exact (ordered mid' mid hlo' hgt hhi hB'U hBU h' h).elim
  intro a b hla hab hbh hAU hBU ha hb
  obtain ⟨_, ⟨L, hLne, hLl, hxL⟩, _⟩ := ha
  obtain ⟨_, _, ⟨R, hRne, hRr, hxR⟩⟩ := hb
  have hLU : L ⊆ U := by
    intro z hz
    apply hAU
    have hz' := hLl hz
    simp only [triple, Finset.mem_insert, Finset.mem_singleton] at hz' ⊢
    tauto
  have hRU : R ⊆ U := by
    intro z hz
    apply hBU
    have hz' := hRr hz
    simp only [triple, Finset.mem_insert, Finset.mem_singleton] at hz' ⊢
    tauto
  have hd := hsep L R hLne hRne hLU hRU (card_pair_le hLl) (card_pair_le hRr) (by
    intro l hl r hr
    have hl' := hLl hl
    have hr' := hRr hr
    simp only [Finset.mem_insert, Finset.mem_singleton] at hl' hr'
    rcases hl' with rfl | rfl <;> rcases hr' with rfl | rfl <;> omega)
  exact Finset.disjoint_left.mp hd hxL hxR

noncomputable def badMiddles {M : Type u} (A : Finset ℕ → Finset M)
    (lo hi : ℕ) (W : Finset ℕ) : Finset ℕ := by
  classical
  exact W.filter fun mid => ¬ Aligned A (triple lo mid hi)

theorem card_badMiddles_le {M : Type u} {A : Finset ℕ → Finset M}
    {U : Finset ℕ} (hsep : SeparatedOn A U)
    {lo hi : ℕ} {W : Finset ℕ}
    (hW : ∀ mid ∈ W, lo < mid ∧ mid < hi ∧ triple lo mid hi ⊆ U) :
    (badMiddles A lo hi W).card ≤ (A {lo, hi}).card := by
  classical
  let S := badMiddles A lo hi W
  have ex : ∀ mid : S, ∃ x, Witness A lo mid hi x := by
    intro mid
    have hm := Finset.mem_filter.mp mid.property
    have hw := hW mid hm.1
    exact bad_triple_witness hsep hw.1 hw.2.1 hw.2.2 hm.2
  choose f hf using ex
  let g : S → ↥(A {lo, hi}) := fun mid => ⟨f mid, (hf mid).1⟩
  have hg : Function.Injective g := by
    intro mid mid' heq
    apply Subtype.ext
    have hm := Finset.mem_filter.mp mid.property
    have hm' := Finset.mem_filter.mp mid'.property
    have hw := hW mid hm.1
    have hw' := hW mid' hm'.1
    have hx : f mid = f mid' := congrArg Subtype.val heq
    have hwm' : Witness A lo mid' hi (f mid) := hx ▸ hf mid'
    exact witness_middle_unique hsep hw.1 hw.2.1 hw'.1 hw'.2.1
      hw.2.2 hw'.2.2 (hf mid) hwm'
  exact Finset.card_le_card_of_injective hg

noncomputable def rationalBadMass {M : Type u} (A : Finset ℕ → Finset M)
    (lo hi : ℕ) (W : Finset ℕ) : ℚ :=
  (badMiddles A lo hi W).card / (W.card : ℚ)

def uniformMass (W : Finset ℕ) (mid : ℕ) : ℚ :=
  if mid ∈ W then (W.card : ℚ)⁻¹ else 0

theorem uniformMass_nonneg (W : Finset ℕ) (mid : ℕ) :
    0 ≤ uniformMass W mid := by
  unfold uniformMass
  split_ifs <;> positivity

theorem sum_uniformMass {W : Finset ℕ} (hW : W.Nonempty) :
    ∑ mid ∈ W, uniformMass W mid = 1 := by
  have hc : (W.card : ℚ) ≠ 0 := by exact_mod_cast hW.card_pos.ne'
  simp [uniformMass, Finset.sum_const, nsmul_eq_mul, hc]

theorem rationalBadMass_eq_expectation {M : Type u}
    (A : Finset ℕ → Finset M) (lo hi : ℕ) (W : Finset ℕ) :
    rationalBadMass A lo hi W =
      ∑ mid ∈ W, if Aligned A (triple lo mid hi) then 0 else uniformMass W mid := by
  classical
  symm
  calc
    _ = ∑ mid ∈ badMiddles A lo hi W, (W.card : ℚ)⁻¹ := by
      rw [badMiddles, Finset.sum_filter]
      apply Finset.sum_congr rfl
      intro mid hm
      by_cases hg : Aligned A (triple lo mid hi) <;> simp [hg, uniformMass, hm]
    _ = rationalBadMass A lo hi W := by
      simp [rationalBadMass, Finset.sum_const, nsmul_eq_mul, div_eq_mul_inv]

theorem triple_card {lo mid hi : ℕ} (hlo : lo < mid) (hhi : mid < hi) :
    (triple lo mid hi).card = 3 := by
  have hends : lo < hi := hlo.trans hhi
  simp [triple, ne_of_lt hlo, ne_of_lt hhi, ne_of_lt hends]

theorem triple_injective_on {lo hi : ℕ} {W : Finset ℕ}
    (hW : ∀ mid ∈ W, lo < mid ∧ mid < hi) :
    Set.InjOn (fun mid => triple lo mid hi) W := by
  intro mid hm mid' hm' heq
  change triple lo mid hi = triple lo mid' hi at heq
  have hx : mid ∈ triple lo mid' hi := by rw [← heq]; simp [triple]
  have hbounds := hW mid hm
  simp only [triple, Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with h | h | h
  · omega
  · exact h
  · omega

theorem rationalBadMass_le {M : Type u} {A : Finset ℕ → Finset M}
    {U : Finset ℕ} (hsep : SeparatedOn A U)
    {lo hi : ℕ} {W : Finset ℕ} (hWne : W.Nonempty)
    (hW : ∀ mid ∈ W, lo < mid ∧ mid < hi ∧ triple lo mid hi ⊆ U)
    {d : ℕ} (hd : (A {lo, hi}).card ≤ d) :
    rationalBadMass A lo hi W ≤ (d : ℚ) / W.card := by
  have hc : (badMiddles A lo hi W).card ≤ d := (card_badMiddles_le hsep hW).trans hd
  exact div_le_div_of_nonneg_right (by exact_mod_cast hc) (by positivity)

theorem three_rational_sampler (d : ℕ) (η : ℝ) (hη : 0 < η) :
    ∃ N : ℕ, 0 < N ∧
      ∀ (M : Type u) (A : Finset ℕ → Finset M),
        SeparatedOn A (Finset.range (N + 2)) →
        (A {0, N + 1}).card ≤ d →
        ((rationalBadMass A 0 (N + 1) (Finset.Icc 1 N) : ℚ) : ℝ) < η := by
  obtain ⟨N, hN⟩ := exists_nat_gt ((d : ℝ) / η)
  have hNposR : (0 : ℝ) < N := lt_of_le_of_lt (by positivity) hN
  have hNpos : 0 < N := by exact_mod_cast hNposR
  refine ⟨N, hNpos, ?_⟩
  intro M A hsep hd
  have hWne : (Finset.Icc 1 N).Nonempty := by
    exact ⟨1, by simp; omega⟩
  have hW : ∀ mid ∈ Finset.Icc 1 N,
      0 < mid ∧ mid < N + 1 ∧ triple 0 mid (N + 1) ⊆ Finset.range (N + 2) := by
    intro mid hm
    simp only [Finset.mem_Icc] at hm
    refine ⟨by omega, by omega, ?_⟩
    intro z hz
    simp only [triple, Finset.mem_insert, Finset.mem_singleton] at hz
    simp only [Finset.mem_range]
    rcases hz with rfl | rfl | rfl <;> omega
  have hb := rationalBadMass_le hsep hWne hW hd
  have hcard : (Finset.Icc 1 N).card = N := by simp
  rw [hcard] at hb
  have hbR : ((rationalBadMass A 0 (N + 1) (Finset.Icc 1 N) : ℚ) : ℝ) ≤
      (d : ℝ) / N := by
    have hc : ((rationalBadMass A 0 (N + 1) (Finset.Icc 1 N) : ℚ) : ℝ) ≤
        (((d : ℚ) / (N : ℚ) : ℚ) : ℝ) := Rat.cast_le.2 hb
    simpa only [Rat.cast_div, Rat.cast_natCast] using hc
  apply hbR.trans_lt
  apply (div_lt_iff₀ hNposR).2
  have hm := (div_lt_iff₀ hη).1 hN
  nlinarith

end AlignmentAudit
