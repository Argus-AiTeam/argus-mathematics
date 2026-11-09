import Mathlib

set_option autoImplicit false

namespace EndpointBridge

open scoped commutatorElement

universe u v w

variable {G : Type u} [Group G] {I : Type v}

structure Grading (I : Type v) (G : Type u) [Group G] where
  rep : (I → G) → ℕ → Prop
  diagonal : ∀ g, rep (fun _ => g) 0
  multiply : ∀ {a b m n}, rep a m → rep b n → rep (a * b) (m + n)

def Fraction (R : Grading I G) (z : I → G) (n : ℕ) : Prop :=
  ∃ a b m k, R.rep a m ∧ R.rep b k ∧ z = a * b⁻¹ ∧ m + k = n

def HasFraction (R : Grading I G) (z : I → G) : Prop :=
  ∃ n, Fraction R z n

noncomputable def spike (i : I) (g : G) : I → G := by
  classical
  exact fun j => if j = i then g else 1

@[simp] theorem spike_at (i : I) (g : G) : spike i g i = g := by
  classical
  simp [spike]

@[simp] theorem spike_off (i j : I) (g : G) (h : j ≠ i) : spike i g j = 1 := by
  classical
  simp [spike, h]

@[simp] theorem spike_one (i : I) : spike i (1 : G) = 1 := by
  classical
  ext j
  simp [spike]

theorem spike_mul (i : I) (g h : G) :
    spike i (g * h) = spike i g * spike i h := by
  classical
  ext j
  by_cases hj : j = i <;> simp [spike, hj]

theorem spike_inv (i : I) (g : G) : spike i g⁻¹ = (spike i g)⁻¹ := by
  classical
  ext j
  by_cases hj : j = i <;> simp [spike, hj]

theorem spike_conj (i : I) (g k : G) :
    spike i (k * g * k⁻¹) =
      (fun _ => k) * spike i g * (fun _ => k)⁻¹ := by
  classical
  ext j
  by_cases hj : j = i <;> simp [spike, hj]

theorem fraction_one (R : Grading I G) : Fraction R 1 0 :=
  ⟨1, 1, 0, 0, R.diagonal 1, R.diagonal 1, by simp, rfl⟩

theorem fraction_inv {R : Grading I G} {z : I → G} {n : ℕ}
    (h : Fraction R z n) : Fraction R z⁻¹ n := by
  obtain ⟨a, b, m, k, ha, hb, rfl, rfl⟩ := h
  exact ⟨b, a, k, m, hb, ha, by group, Nat.add_comm _ _⟩

theorem fraction_conj {R : Grading I G} {z : I → G} {n : ℕ}
    (h : Fraction R z n) (k : G) :
    Fraction R ((fun _ => k) * z * (fun _ => k)⁻¹) n := by
  obtain ⟨a, b, m, l, ha, hb, rfl, rfl⟩ := h
  refine ⟨(fun _ => k) * a, (fun _ => k) * b, m, l, ?_, ?_, ?_, rfl⟩
  · simpa using R.multiply (R.diagonal k) ha
  · simpa using R.multiply (R.diagonal k) hb
  · group

theorem single_multiply {R : Grading I G} {z : I → G} {g : G}
    {n m : ℕ} (i : I) (hz : Fraction R z n) (hg : Fraction R (spike i g) m) :
    Fraction R (z * spike i g) (n + m) := by
  obtain ⟨u, v, a, b, hu, hv, rfl, rfl⟩ := hz
  have hc := fraction_conj hg (v i)⁻¹
  rw [← spike_conj] at hc
  obtain ⟨p, q, c, d, hp, hq, he, hd⟩ := hc
  refine ⟨u * p, v * q, a + c, b + d, R.multiply hu hp, R.multiply hv hq, ?_, by omega⟩
  have hs : spike i ((v i)⁻¹ * g * ((v i)⁻¹)⁻¹) =
      v⁻¹ * spike i g * v := by
    classical
    ext j
    by_cases hj : j = i
    · subst j
      simp
    · simp [spike, hj]
  calc
    (u * v⁻¹) * spike i g = u * (v⁻¹ * spike i g * v) * v⁻¹ := by group
    _ = u * (p * q⁻¹) * v⁻¹ := by rw [← hs, he]
    _ = (u * p) * (v * q)⁻¹ := by group

def supportedSubgroup (R : Grading I G) (i : I) : Subgroup G where
  carrier := {g | HasFraction R (spike i g)}
  one_mem' := by exact ⟨0, by simpa using fraction_one R⟩
  mul_mem' := by
    rintro g h ⟨n, hn⟩ ⟨m, hm⟩
    exact ⟨n + m, by simpa [spike_mul] using single_multiply i hn hm⟩
  inv_mem' := by
    rintro g ⟨n, hn⟩
    exact ⟨n, by simpa [spike_inv] using fraction_inv hn⟩

instance supported_normal (R : Grading I G) (i : I) :
    (supportedSubgroup R i).Normal where
  conj_mem := by
    rintro g ⟨n, hn⟩ k
    exact ⟨n, by simpa [spike_conj] using fraction_conj hn k⟩

noncomputable def singleCost (R : Grading I G) (i : I) (g : G) : ℕ :=
  sInf {n | Fraction R (spike i g) n}

theorem singleCost_spec {R : Grading I G} {i : I} {g : G}
    (h : g ∈ supportedSubgroup R i) :
    Fraction R (spike i g) (singleCost R i g) :=
  Nat.sInf_mem h

theorem singleCost_le {R : Grading I G} {i : I} {g : G} {n : ℕ}
    (h : Fraction R (spike i g) n) : singleCost R i g ≤ n :=
  Nat.sInf_le h

@[simp] theorem singleCost_one (R : Grading I G) (i : I) :
    singleCost R i 1 = 0 := by
  exact Nat.eq_zero_of_le_zero (singleCost_le (by simpa using fraction_one R))

theorem singleCost_inv {R : Grading I G} {i : I} {g : G}
    (h : g ∈ supportedSubgroup R i) :
    singleCost R i g⁻¹ = singleCost R i g := by
  apply Nat.le_antisymm
  · exact singleCost_le (by simpa [spike_inv] using fraction_inv (singleCost_spec h))
  · have hh := singleCost_spec ((supportedSubgroup R i).inv_mem h)
    have hh' : Fraction R (spike i g) (singleCost R i g⁻¹) := by
      simpa [← spike_inv] using fraction_inv hh
    exact singleCost_le hh'

theorem singleCost_conj {R : Grading I G} {i : I} {g : G}
    (h : g ∈ supportedSubgroup R i) (k : G) :
    singleCost R i (k * g * k⁻¹) = singleCost R i g := by
  have forward : ∀ {g : G}, g ∈ supportedSubgroup R i → ∀ k : G,
      singleCost R i (k * g * k⁻¹) ≤ singleCost R i g := by
    intro g hg k
    exact singleCost_le (by simpa [spike_conj] using fraction_conj (singleCost_spec hg) k)
  apply Nat.le_antisymm (forward h k)
  have hk := (inferInstance : (supportedSubgroup R i).Normal).conj_mem g h k
  simpa [mul_assoc] using forward hk k⁻¹

theorem singleCost_mul {R : Grading I G} {i : I} {g h : G}
    (hg : g ∈ supportedSubgroup R i) (hh : h ∈ supportedSubgroup R i) :
    singleCost R i (g * h) ≤ singleCost R i g + singleCost R i h :=
  singleCost_le (by
    simpa [spike_mul] using single_multiply i (singleCost_spec hg) (singleCost_spec hh))

theorem tuple_fraction [Fintype I] (R : Grading I G) (g : I → G)
    (hg : ∀ i, g i ∈ supportedSubgroup R i) :
    Fraction R g (∑ i, singleCost R i (g i)) := by
  classical
  have parts : ∀ T : Finset I,
      Fraction R (fun j => if j ∈ T then g j else 1) (∑ i ∈ T, singleCost R i (g i)) := by
    intro T
    induction T using Finset.induction_on with
    | empty =>
      simp only [Finset.notMem_empty, ↓reduceIte, Finset.sum_empty]
      exact fraction_one R
    | @insert i T hi ih =>
      have h := single_multiply i ih (singleCost_spec (hg i))
      have he : (fun j => if j ∈ T then g j else 1) * spike i (g i) =
          (fun j => if j ∈ insert i T then g j else 1) := by
        ext j
        by_cases hji : j = i
        · subst j
          simp [hi]
        · simp [spike, hji]
      simpa [he, Finset.sum_insert, hi, Nat.add_comm] using h
  simpa using parts Finset.univ

def PairHyp (R : Grading I G) (N : Subgroup G) : Prop :=
  (∀ i j : I, i ≠ j → ∀ v n, R.rep v n →
    ∃ b m, R.rep b m ∧ v i * b i = 1 ∧ v j * b j = 1) ∧
  (∀ i j : I, i ≠ j → ∀ a ∈ N, ∀ b ∈ N,
    ∃ z n, R.rep z n ∧ z i = a ∧ z j = b)

def pairProjection (R : Grading I G) (i j : I) : Submonoid (G × G) where
  carrier := {p | ∃ z n, R.rep z n ∧ z i = p.1 ∧ z j = p.2}
  one_mem' := ⟨fun _ => 1, 0, R.diagonal 1, rfl, rfl⟩
  mul_mem' := by
    rintro a b ⟨u, n, hu, hui, huj⟩ ⟨v, m, hv, hvi, hvj⟩
    exact ⟨u * v, n + m, R.multiply hu hv, by simp [Pi.mul_apply, hui, hvi],
      by simp [Pi.mul_apply, huj, hvj]⟩

def PairProjectionHyp (R : Grading I G) (N : Subgroup G) : Prop :=
  ∀ i j : I, i ≠ j →
    (∀ p ∈ pairProjection R i j, p⁻¹ ∈ pairProjection R i j) ∧
    ∀ a ∈ N, ∀ b ∈ N, (a, b) ∈ pairProjection R i j

theorem pairHyp_of_projections {R : Grading I G} {N : Subgroup G}
    (hp : PairProjectionHyp R N) : PairHyp R N := by
  constructor
  · intro i j hij v n hv
    have hvp : (v i, v j) ∈ pairProjection R i j := ⟨v, n, hv, rfl, rfl⟩
    obtain ⟨b, m, hb, hbi, hbj⟩ := (hp i j hij).1 _ hvp
    exact ⟨b, m, hb, by simpa [hbi], by simpa [hbj]⟩
  · intro i j hij a ha b hb
    exact (hp i j hij).2 a ha b hb

def PairSupported (z : I → G) (i j : I) : Prop :=
  ∀ k, k ≠ i → k ≠ j → z k = 1

theorem pair_multiply {R : Grading I G} {N : Subgroup G}
    (hp : PairHyp R N) {i j : I} (hij : i ≠ j)
    {w z : I → G} (hz : PairSupported z i j)
    (hw : HasFraction R w) (hf : HasFraction R z) :
    HasFraction R (w * z) := by
  obtain ⟨n, u, v, a, b, hu, hv, rfl, rfl⟩ := hw
  obtain ⟨m, c, d, e, f, hc, hd, he, rfl⟩ := hf
  obtain ⟨p, l, hp', hpi, hpj⟩ := hp.1 i j hij v b hv
  have ht : Commute (v * p) z := by
    change (v * p) * z = z * (v * p)
    ext k
    by_cases hki : k = i
    · subst k
      simp [Pi.mul_apply, hpi]
    · by_cases hkj : k = j
      · subst k
        simp [Pi.mul_apply, hpj]
      · simp [Pi.mul_apply, hz k hki hkj]
  refine ⟨(a + l + e) + (b + l + f),
    (u * p) * c, (v * p) * d, a + l + e, b + l + f,
    R.multiply (R.multiply hu hp') hc, R.multiply (R.multiply hv hp') hd, ?_, rfl⟩
  calc
    (u * v⁻¹) * z = (u * p) * (v * p)⁻¹ * z := by group
    _ = (u * p) * z * (v * p)⁻¹ := by
      simpa [mul_assoc] using congrArg (fun t => (u * p) * t) ht.inv_left.eq
    _ = ((u * p) * c) * ((v * p) * d)⁻¹ := by rw [he]; group

def Grading.project {J : Type w} (R : Grading I G) (e : J → I) : Grading J G where
  rep z n := ∃ v, R.rep v n ∧ ∀ j, v (e j) = z j
  diagonal g := ⟨fun _ => g, R.diagonal g, fun _ => rfl⟩
  multiply := by
    rintro a b m n ⟨u, hu, heu⟩ ⟨v, hv, hev⟩
    exact ⟨u * v, R.multiply hu hv, fun j => by simp [Pi.mul_apply, heu, hev]⟩

theorem pairHyp_project {J : Type w} {R : Grading I G} {N : Subgroup G}
    (hp : PairHyp R N) (e : J → I) (he : Function.Injective e) :
    PairHyp (R.project e) N := by
  constructor
  · rintro i j hij v n ⟨u, hu, heu⟩
    obtain ⟨b, m, hb, hbi, hbj⟩ := hp.1 (e i) (e j) (fun h => hij (he h)) u n hu
    exact ⟨b ∘ e, m, ⟨b, hb, fun _ => rfl⟩, by simpa [heu] using hbi,
      by simpa [heu] using hbj⟩
  · intro i j hij a ha b hb
    obtain ⟨z, n, hz, hzi, hzj⟩ := hp.2 (e i) (e j) (fun h => hij (he h)) a ha b hb
    exact ⟨z ∘ e, n, ⟨z, hz, fun _ => rfl⟩, hzi, hzj⟩

def derived (N : Subgroup G) : ℕ → Subgroup G
  | 0 => N
  | r + 1 => ⁅derived N r, derived N r⁆

instance derived_normal (N : Subgroup G) [N.Normal] (r : ℕ) :
    (derived N r).Normal := by
  induction r with
  | zero => exact inferInstanceAs N.Normal
  | succ r ih =>
    change (⁅derived N r, derived N r⁆ : Subgroup G).Normal
    infer_instance

theorem derived_inclusion_aux (N : Subgroup G) (n : ℕ) :
    ∀ (I : Type v) [Fintype I] (R : Grading I G),
      Fintype.card I = n → 2 ≤ n → PairHyp R N →
      ∀ i, derived N (n - 2) ≤ supportedSubgroup R i := by
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
      change N ≤ supportedSubgroup R i
      intro g hg
      obtain ⟨z, m, hz, hzi, hzj⟩ := hp.2 i j (Ne.symm hji) g hg 1 N.one_mem
      have hcover : ∀ k : I, k = i ∨ k = j := by
        intro k
        by_contra hk
        have hki : k ≠ i := fun h => hk (Or.inl h)
        have hkj : k ≠ j := fun h => hk (Or.inr h)
        have hc := Finset.card_le_card (Finset.subset_univ ({i, j, k} : Finset I))
        simp [hcard, htwo, hji, Ne.symm hji, hki, Ne.symm hki, hkj, Ne.symm hkj] at hc
      have he : spike i g = z := by
        ext k
        rcases hcover k with rfl | rfl
        · simpa using hzi.symm
        · simp [spike, hji, hzj]
      exact ⟨m, z, 1, m, 0, hz, R.diagonal 1, by simpa using he, by omega⟩
    · have hthree : 3 ≤ n := by omega
      have hlt' : ({i, j} : Finset I).card < (Finset.univ : Finset I).card := by
        simp [hcard, hji, Ne.symm hji]
        omega
      obtain ⟨k, _, hk⟩ := Finset.exists_mem_notMem_of_card_lt_card hlt'
      simp only [Finset.mem_insert, Finset.mem_singleton, not_or] at hk
      have hki : k ≠ i := hk.1
      have hkj : k ≠ j := hk.2
      have lift_at (t : I) (hti : t ≠ i) (a : G) (ha : a ∈ derived N (n - 3)) :
          ∃ z, HasFraction R z ∧ PairSupported z i t ∧ z i = a := by
        let J := {x : I // x ≠ t}
        let RJ := R.project (fun x : J => x.val)
        have hcJ : Fintype.card J = n - 1 := by
          simpa [J, hcard] using Fintype.card_subtype_compl (fun x : I => x = t)
        have hpJ : PairHyp RJ N := pairHyp_project hp _ Subtype.val_injective
        have hd : n - 1 - 2 = n - 3 := by omega
        have hai : a ∈ supportedSubgroup RJ (⟨i, Ne.symm hti⟩ : J) :=
          ih (n - 1) (by omega) J RJ hcJ (by omega) hpJ _ (by simpa [hd] using ha)
        obtain ⟨m, u, v, p, q, hu, hv, he, hm⟩ := hai
        obtain ⟨U, hU, eU⟩ := hu
        obtain ⟨V, hV, eV⟩ := hv
        refine ⟨U * V⁻¹, ⟨p + q, U, V, p, q, hU, hV, rfl, rfl⟩, ?_, ?_⟩
        · intro l hli hlt
          change U l * (V l)⁻¹ = 1
          rw [eU (⟨l, hlt⟩ : J), eV (⟨l, hlt⟩ : J)]
          have hne : (⟨l, hlt⟩ : J) ≠ ⟨i, Ne.symm hti⟩ :=
            fun h => hli (congrArg Subtype.val h)
          simpa [spike, hne] using (congrFun he (⟨l, hlt⟩ : J)).symm
        · change U i * (V i)⁻¹ = a
          rw [eU (⟨i, Ne.symm hti⟩ : J), eV (⟨i, Ne.symm hti⟩ : J)]
          simpa using (congrFun he (⟨i, Ne.symm hti⟩ : J)).symm
      have hd : n - 2 = (n - 3) + 1 := by omega
      rw [hd, derived]
      apply Subgroup.commutator_le.mpr
      intro a ha b hb
      obtain ⟨za, hfa, hsa, hva⟩ := lift_at j hji a ha
      obtain ⟨zb, hfb, hsb, hvb⟩ := lift_at k hki b hb
      have hsai : PairSupported za⁻¹ i j := by
        intro l hli hlj
        simp [Pi.inv_apply, hsa l hli hlj]
      have hsbi : PairSupported zb⁻¹ i k := by
        intro l hli hlk
        simp [Pi.inv_apply, hsb l hli hlk]
      have hfai : HasFraction R za⁻¹ := by
        obtain ⟨m, hm⟩ := hfa
        exact ⟨m, fraction_inv hm⟩
      have hfbi : HasFraction R zb⁻¹ := by
        obtain ⟨m, hm⟩ := hfb
        exact ⟨m, fraction_inv hm⟩
      have hf := pair_multiply hp (Ne.symm hki) hsb hfa hfb
      have hf' := pair_multiply hp (Ne.symm hji) hsai hf hfai
      have hf'' := pair_multiply hp (Ne.symm hki) hsbi hf' hfbi
      have he : za * zb * za⁻¹ * zb⁻¹ = spike i ⁅a, b⁆ := by
        ext l
        by_cases hli : l = i
        · subst l
          simp [Pi.mul_apply, Pi.inv_apply, hva, hvb, commutatorElement_def]
        · by_cases hlj : l = j
          · subst l
            simp [Pi.mul_apply, Pi.inv_apply, hsb j hji (Ne.symm hkj), spike, hji]
          · simp [Pi.mul_apply, Pi.inv_apply, hsa l hli hlj, spike, hli]
      rwa [he] at hf''

theorem derived_inclusion [Fintype I] {N : Subgroup G} {R : Grading I G}
    (hs : 2 ≤ Fintype.card I) (hp : PairHyp R N) (i : I) :
    derived N (Fintype.card I - 2) ≤ supportedSubgroup R i :=
  derived_inclusion_aux N _ I R rfl hs hp i

structure InvariantCost (P : Subgroup G) where
  val : G → ℝ
  nonneg : ∀ g, 0 ≤ val g
  one : val 1 = 0
  inv : ∀ g ∈ P, val g⁻¹ = val g
  conj : ∀ g ∈ P, ∀ k, val (k * g * k⁻¹) = val g
  mul : ∀ g ∈ P, ∀ h ∈ P, val (g * h) ≤ val g + val h

noncomputable def maxCost [Fintype I] (R : Grading I G) (g : G) : ℕ :=
  Finset.univ.sup (fun i => singleCost R i g)

theorem single_le_max [Fintype I] (R : Grading I G) (i : I) (g : G) :
    singleCost R i g ≤ maxCost R g := by
  classical
  exact Finset.le_sup (f := fun i => singleCost R i g) (Finset.mem_univ i)

noncomputable def correctionCost [Fintype I] {N : Subgroup G} [N.Normal]
    {R : Grading I G} (hs : 2 ≤ Fintype.card I) (hp : PairHyp R N) :
    InvariantCost (derived N (Fintype.card I - 2)) where
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
    exact singleCost_inv (derived_inclusion hs hp i hg)
  conj g hg k := by
    classical
    congr 1
    apply Finset.sup_congr rfl
    intro i _
    exact singleCost_conj (derived_inclusion hs hp i hg) k
  mul g hg h hh := by
    have hb : maxCost R (g * h) ≤ maxCost R g + maxCost R h := by
      classical
      apply Finset.sup_le
      intro i _
      exact (singleCost_mul (derived_inclusion hs hp i hg)
        (derived_inclusion hs hp i hh)).trans
          (Nat.add_le_add (single_le_max R i g) (single_le_max R i h))
    exact_mod_cast hb

theorem list_difference_mem (P : Subgroup G) [P.Normal] (a b : List G)
    (h : List.Forall₂ (fun x y => x * y⁻¹ ∈ P) a b) :
    a.prod * b.prod⁻¹ ∈ P := by
  induction h with
  | nil => simpa using P.one_mem
  | @cons a b l k hab _ ih =>
    have hc := (inferInstance : P.Normal).conj_mem _ ih b
    have hm := P.mul_mem hab hc
    convert hm using 1 <;> simp only [List.prod_cons] <;> group

theorem list_difference_cost {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    (a b : List G) (h : List.Forall₂ (fun x y => x * y⁻¹ ∈ P) a b) :
    c.val (a.prod * b.prod⁻¹) ≤
      ((a.zip b).map (fun p => c.val (p.1 * p.2⁻¹))).sum := by
  induction h with
  | nil => simp [c.one]
  | @cons a b l k hab htail ih =>
    have hmem := list_difference_mem P l k htail
    have hc := (inferInstance : P.Normal).conj_mem _ hmem b
    have he : (a :: l).prod * (b :: k).prod⁻¹ =
        (a * b⁻¹) * (b * (l.prod * k.prod⁻¹) * b⁻¹) := by
      simp only [List.prod_cons]
      group
    rw [he]
    calc
      c.val ((a * b⁻¹) * (b * (l.prod * k.prod⁻¹) * b⁻¹)) ≤
          c.val (a * b⁻¹) + c.val (b * (l.prod * k.prod⁻¹) * b⁻¹) :=
        c.mul _ hab _ hc
      _ = c.val (a * b⁻¹) + c.val (l.prod * k.prod⁻¹) := by rw [c.conj _ hmem]
      _ ≤ _ := by simpa using add_le_add_left ih (c.val (a * b⁻¹))

theorem list_product_cost {P : Subgroup G} (c : InvariantCost P)
    (l : List G) (B : ℝ) (h : ∀ a ∈ l, a ∈ P ∧ c.val a ≤ B) :
    l.prod ∈ P ∧ c.val l.prod ≤ l.length * B := by
  induction l with
  | nil => simp [P.one_mem, c.one]
  | cons a l ih =>
    obtain ⟨ha, hca⟩ := h a (by simp)
    obtain ⟨hl, hcl⟩ := ih (fun x hx => h x (by simp [hx]))
    refine ⟨P.mul_mem ha hl, ?_⟩
    simp only [List.prod_cons, List.length_cons, Nat.cast_add, Nat.cast_one]
    calc
      c.val (a * l.prod) ≤ c.val a + c.val l.prod := c.mul _ ha _ hl
      _ ≤ B + l.length * B := add_le_add hca hcl
      _ = _ := by ring

theorem omit_one_cost {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    (l : List G) (a : G) (ha : a ∈ l) (B : ℝ)
    (h : ∀ x ∈ l, x ∈ P ∧ c.val x ≤ B) :
    l.prod * a⁻¹ ∈ P ∧ c.val (l.prod * a⁻¹) ≤ (l.length - 1) * B := by
  obtain ⟨p, q, rfl⟩ := List.append_of_mem ha
  obtain ⟨hp, hcp⟩ := list_product_cost c p B (by
    intro x hx
    exact h x (by simp [hx]))
  obtain ⟨hq, hcq⟩ := list_product_cost c q B (by
    intro x hx
    exact h x (by simp [hx]))
  have hconj := (inferInstance : P.Normal).conj_mem _ hq a
  have he : (p ++ a :: q).prod * a⁻¹ = p.prod * (a * q.prod * a⁻¹) := by
    simp [List.prod_append, mul_assoc]
  rw [he]
  refine ⟨P.mul_mem hp hconj, ?_⟩
  calc
    c.val (p.prod * (a * q.prod * a⁻¹)) ≤
        c.val p.prod + c.val (a * q.prod * a⁻¹) := c.mul _ hp _ hconj
    _ = c.val p.prod + c.val q.prod := by rw [c.conj _ hq]
    _ ≤ p.length * B + q.length * B := add_le_add hcp hcq
    _ = _ := by
      simp only [List.length_append, List.length_cons, Nat.add_sub_cancel]
      push_cast
      ring

section PermutationExpressions

variable {H : Type w} [Group H] {X : Type v} [MulAction H X]

inductive PermRep (seed : X → G) : (X → G) → ℕ → Prop
  | diagonal (g : G) : PermRep seed (fun _ => g) 0
  | atom (h : H) : PermRep seed (fun x => seed (h • x)) 1
  | mul {a b m n} : PermRep seed a m → PermRep seed b n →
      PermRep seed (a * b) (m + n)

def permGrading (seed : X → G) : Grading X G where
  rep := PermRep (H := H) seed
  diagonal := PermRep.diagonal
  multiply := PermRep.mul

theorem perm_reindex {seed : X → G} {w : X → G} {m : ℕ}
    (hw : PermRep (H := H) seed w m) (h : H) :
    PermRep (H := H) seed (fun x => w (h • x)) m := by
  induction hw with
  | diagonal g => exact PermRep.diagonal g
  | atom g => simpa [mul_smul] using (PermRep.atom (seed := seed) (g * h))
  | mul ha hb iha ihb => exact PermRep.mul iha ihb

theorem grading_list_product (R : Grading I G) (l : List (I → G)) (m : ℕ)
    (h : ∀ a ∈ l, R.rep a m) : R.rep l.prod (l.length * m) := by
  induction l with
  | nil => simpa only [List.prod_nil, List.length_nil, Nat.zero_mul, Pi.one_def] using R.diagonal 1
  | cons a l ih =>
    simpa [Nat.add_mul, Nat.add_comm] using
      R.multiply (h a (by simp)) (ih (fun b hb => h b (by simp [hb])))

def Related (x y : X) : Prop := ∃ h : H, h • x = y

theorem related_refl (x : X) : Related (H := H) x x := ⟨1, one_smul H x⟩

theorem related_symm {x y : X} (h : Related (H := H) x y) :
    Related (H := H) y x := by
  obtain ⟨g, rfl⟩ := h
  exact ⟨g⁻¹, inv_smul_smul g x⟩

theorem related_trans {x y z : X} (h : Related (H := H) x y)
    (k : Related (H := H) y z) : Related (H := H) x z := by
  obtain ⟨a, rfl⟩ := h
  obtain ⟨b, rfl⟩ := k
  exact ⟨b * a, mul_smul _ _ _⟩

theorem related_smul (x : X) (h : H) : Related (H := H) x (h • x) := ⟨h, rfl⟩

variable [Fintype H]

noncomputable def elements : List H := by
  classical
  exact Finset.univ.toList

@[simp] theorem elements_length : (elements (H := H)).length = Fintype.card H := by
  classical
  simp [elements]

@[simp] theorem mem_elements (h : H) : h ∈ elements (H := H) := by
  classical
  simp [elements]

noncomputable def average (w : X → G) : X → G :=
  fun x => ((elements (H := H)).map (fun h => w (h • x))).prod

theorem list_product_apply (l : List (I → G)) (i : I) :
    l.prod i = (l.map (fun f => f i)).prod := by
  induction l with
  | nil => rfl
  | cons a l ih => simp [Pi.mul_apply, ih]

theorem average_rep {seed w : X → G} {m : ℕ}
    (hw : PermRep (H := H) seed w m) :
    PermRep (H := H) seed (average (H := H) w) (Fintype.card H * m) := by
  have h := grading_list_product (permGrading (H := H) seed)
    ((elements (H := H)).map (fun h => fun x => w (h • x))) m (by
      intro a ha
      obtain ⟨h, _, rfl⟩ := List.mem_map.mp ha
      exact perm_reindex hw h)
  have he : ((elements (H := H)).map (fun h => fun x => w (h • x))).prod =
      average (H := H) w := by
    ext x
    simp [average, list_product_apply, List.map_map, Function.comp_def]
  simpa [he, permGrading] using h

def At (P : Subgroup G) (a : X) (w : X → G) : Prop :=
  ∀ x y, Related (H := H) a x → Related (H := H) a y → w x * (w y)⁻¹ ∈ P

def AtBound {P : Subgroup G} (c : InvariantCost P) (δ m : ℝ) (a : X) (w : X → G) : Prop :=
  ∀ x y, Related (H := H) a x → Related (H := H) a y →
    w x * (w y)⁻¹ ∈ P ∧ c.val (w x * (w y)⁻¹) ≤ δ * m

theorem at_average {P : Subgroup G} [P.Normal] {a : X} {w : X → G}
    (hw : At (H := H) P a w) : At (H := H) P a (average (H := H) w) := by
  intro x y hx hy
  apply list_difference_mem P
  apply List.forall₂_map_left_iff.mpr
  apply List.forall₂_map_right_iff.mpr
  have hl : ∀ l : List H,
      List.Forall₂ (fun h k => w (h • x) * (w (k • y))⁻¹ ∈ P) l l := by
    intro l
    induction l with
    | nil => exact .nil
    | cons h l ih =>
      exact .cons
        (hw _ _ (related_trans hx (related_smul x h)) (related_trans hy (related_smul y h))) ih
  exact hl _

theorem at_right {P : Subgroup G} {a : X} {w : X → G} (k : G)
    (hw : At (H := H) P a w) : At (H := H) P a (w * fun _ => k) := by
  intro x y hx hy
  simpa [Pi.mul_apply, mul_assoc] using hw x y hx hy

theorem average_derived (P : Subgroup G) (w : X → G) (x y : X)
    (hxy : Related (H := H) x y) (hx : ∀ h : H, w (h • x) ∈ P) :
    average (H := H) w x * (average (H := H) w y)⁻¹ ∈ ⁅P, P⁆ := by
  classical
  obtain ⟨k, rfl⟩ := hxy
  let vx : H → P := fun h => ⟨w (h • x), hx h⟩
  let vy : H → P := fun h => ⟨w (h • (k • x)), by simpa [mul_smul] using hx (h * k)⟩
  let ax : P := ((elements (H := H)).map vx).prod
  let ay : P := ((elements (H := H)).map vy).prod
  have hax : (ax : G) = average (H := H) w x := by
    simp [ax, vx, average, ← map_list_prod, Function.comp_def]
  have hay : (ay : G) = average (H := H) w (k • x) := by
    simp [ay, vy, average, ← map_list_prod, Function.comp_def]
  have hbar : Abelianization.of ax = Abelianization.of ay := by
    change Abelianization.of (((elements (H := H)).map vx).prod) =
      Abelianization.of (((elements (H := H)).map vy).prod)
    simp only [map_list_prod, List.map_map]
    simp only [elements, Finset.prod_map_toList]
    symm
    apply Fintype.prod_equiv (Equiv.mulRight k)
      (fun h => Abelianization.of (vy h)) (fun h => Abelianization.of (vx h))
    intro h
    congr 1
    apply Subtype.ext
    exact (mul_smul h k x).symm |> congrArg w
  have hker : ax * ay⁻¹ ∈ commutator P := by
    rw [← Abelianization.ker_of]
    change Abelianization.of (ax * ay⁻¹) = 1
    simp [hbar]
  have hmap : ((ax * ay⁻¹ : P) : G) ∈ (commutator P).map P.subtype :=
    Subgroup.mem_map_of_mem P.subtype hker
  rw [Subgroup.map_subtype_commutator] at hmap
  simpa [hax, hay] using hmap

noncomputable def raiseAt (a : X) (w : X → G) : X → G :=
  average (H := H) (w * fun _ => (w a)⁻¹)

theorem raise_rep {seed w : X → G} {m : ℕ} (a : X)
    (hw : PermRep (H := H) seed w m) :
    PermRep (H := H) seed (raiseAt (H := H) a w) (Fintype.card H * m) := by
  apply average_rep
  simpa using PermRep.mul hw (PermRep.diagonal (w a)⁻¹)

theorem raise_preserves {P : Subgroup G} [P.Normal] {a b : X} {w : X → G}
    (hw : At (H := H) P b w) : At (H := H) P b (raiseAt (H := H) a w) :=
  at_average (at_right _ hw)

theorem raise_improves (N : Subgroup G) (r : ℕ) {a : X} {w : X → G}
    (hw : At (H := H) (derived N r) a w) :
    At (H := H) (derived N (r + 1)) a (raiseAt (H := H) a w) := by
  intro x y hx hy
  apply average_derived (derived N r)
    (w * fun _ => (w a)⁻¹) x y (related_trans (related_symm hx) hy)
  intro h
  exact hw _ _ (related_trans hx (related_smul x h)) (related_refl a)

theorem membership_depth [Fintype X] (N : Subgroup G) [N.Normal]
    (seed : X → G)
    (hseed : ∀ a, At (H := H) N a seed) (r : ℕ) :
    ∃ w m, PermRep (H := H) seed w m ∧ 0 < m ∧
      ∀ a, At (H := H) (derived N r) a w := by
  classical
  induction r with
  | zero =>
    exact ⟨seed, 1, by simpa using (PermRep.atom (seed := seed) (1 : H)),
      by omega, hseed⟩
  | succ r ih =>
    obtain ⟨w, m, hw, hm, hall⟩ := ih
    have refine_set : ∀ T : Finset X, ∃ v n,
        PermRep (H := H) seed v n ∧ 0 < n ∧
        (∀ a, At (H := H) (derived N r) a v) ∧
        ∀ a ∈ T, At (H := H) (derived N (r + 1)) a v := by
      intro T
      induction T using Finset.induction_on with
      | empty => exact ⟨w, m, hw, hm, hall, by simp⟩
      | @insert a T ha ih =>
        obtain ⟨v, n, hv, hn, hbase, hT⟩ := ih
        refine ⟨raiseAt (H := H) a v, Fintype.card H * n, raise_rep a hv,
          Nat.mul_pos Fintype.card_pos hn, ?_, ?_⟩
        · intro b
          exact raise_preserves (hbase b)
        · intro b hb
          rcases Finset.mem_insert.mp hb with rfl | hb
          · exact raise_improves N r (hbase b)
          · exact raise_preserves (hT b hb)
    obtain ⟨v, n, hv, hn, _, hT⟩ := refine_set Finset.univ
    exact ⟨v, n, hv, hn, fun a => hT a (Finset.mem_univ _)⟩

theorem list_difference_bound {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    (l k : List G) (B : ℝ)
    (h : List.Forall₂ (fun a b => a * b⁻¹ ∈ P ∧ c.val (a * b⁻¹) ≤ B) l k) :
    l.prod * k.prod⁻¹ ∈ P ∧ c.val (l.prod * k.prod⁻¹) ≤ l.length * B := by
  induction h with
  | nil => simp [P.one_mem, c.one]
  | @cons a b l k hab htail ih =>
    have hc := (inferInstance : P.Normal).conj_mem _ ih.1 b
    have he : (a :: l).prod * (b :: k).prod⁻¹ =
        (a * b⁻¹) * (b * (l.prod * k.prod⁻¹) * b⁻¹) := by
      simp only [List.prod_cons]
      group
    rw [he]
    refine ⟨P.mul_mem hab.1 hc, ?_⟩
    calc
      c.val ((a * b⁻¹) * (b * (l.prod * k.prod⁻¹) * b⁻¹)) ≤
          c.val (a * b⁻¹) + c.val (b * (l.prod * k.prod⁻¹) * b⁻¹) :=
        c.mul _ hab.1 _ hc
      _ = c.val (a * b⁻¹) + c.val (l.prod * k.prod⁻¹) := by rw [c.conj _ ih.1]
      _ ≤ B + l.length * B := add_le_add hab.2 ih.2
      _ = _ := by simp only [List.length_cons, Nat.cast_add, Nat.cast_one]; ring

theorem atBound_average {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    {a : X} {w : X → G} {δ m : ℝ} (hw : AtBound (H := H) c δ m a w) :
    AtBound (H := H) c δ (Fintype.card H * m) a (average (H := H) w) := by
  intro x y hx hy
  have hl : ∀ l : List H,
      List.Forall₂ (fun a b : G => a * b⁻¹ ∈ P ∧
        c.val (a * b⁻¹) ≤ δ * m)
        (l.map (fun h => w (h • x))) (l.map (fun h => w (h • y))) := by
    intro l
    induction l with
    | nil => exact .nil
    | cons h l ih =>
      exact .cons
        (hw _ _ (related_trans hx (related_smul x h)) (related_trans hy (related_smul y h))) ih
  have hb := list_difference_bound c _ _ (δ * m) (hl (elements (H := H)))
  refine ⟨hb.1, ?_⟩
  calc
    c.val (average (H := H) w x * (average (H := H) w y)⁻¹) ≤
        Fintype.card H * (δ * m) := by simpa [average] using hb.2
    _ = _ := by ring

theorem atBound_right {P : Subgroup G} (c : InvariantCost P)
    {a : X} {w : X → G} {δ m : ℝ} (k : G)
    (hw : AtBound (H := H) c δ m a w) :
    AtBound (H := H) c δ m a (w * fun _ => k) := by
  intro x y hx hy
  simpa [Pi.mul_apply, mul_assoc] using hw x y hx hy

noncomputable def contractAt (a : X) (w : X → G) : X → G :=
  average (H := H) w * fun _ => (w a)⁻¹

theorem contract_rep {seed w : X → G} {m : ℕ} (a : X)
    (hw : PermRep (H := H) seed w m) :
    PermRep (H := H) seed (contractAt (H := H) a w) (Fintype.card H * m) := by
  simpa [contractAt] using PermRep.mul (average_rep hw) (PermRep.diagonal (w a)⁻¹)

theorem contract_preserves {P : Subgroup G} [P.Normal] {a b : X} {w : X → G}
    (hw : At (H := H) P b w) : At (H := H) P b (contractAt (H := H) a w) :=
  at_right _ (at_average hw)

theorem contract_preserves_bound {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    {a b : X} {w : X → G} {δ m : ℝ} (hw : AtBound (H := H) c δ m b w) :
    AtBound (H := H) c δ (Fintype.card H * m) b (contractAt (H := H) a w) :=
  atBound_right c _ (atBound_average c hw)

theorem contract_values {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    (a : X) (w : X → G) (B : ℝ)
    (hw : ∀ x, Related (H := H) a x → w x ∈ P ∧ c.val (w x) ≤ B) :
    ∀ x, Related (H := H) a x →
      contractAt (H := H) a w x ∈ P ∧
      c.val (contractAt (H := H) a w x) ≤ (Fintype.card H - 1 : ℕ) * B := by
  intro x hx
  have hmem : w a ∈ (elements (H := H)).map (fun h => w (h • x)) := by
    obtain ⟨h, hh⟩ := hx
    refine List.mem_map.mpr ⟨h⁻¹, mem_elements _, ?_⟩
    rw [← hh, inv_smul_smul]
  have hb := omit_one_cost c _ (w a) hmem B (by
    intro z hz
    obtain ⟨h, _, rfl⟩ := List.mem_map.mp hz
    exact hw _ (related_trans hx (related_smul x h)))
  have hc : 1 ≤ Fintype.card H := Fintype.card_pos
  simpa [contractAt, average, Nat.cast_sub hc] using hb

noncomputable def iterContract (a : X) (w : X → G) : ℕ → X → G
  | 0 => w
  | k + 1 => contractAt (H := H) a (iterContract a w k)

theorem iter_rep {seed w : X → G} {m : ℕ} (a : X)
    (hw : PermRep (H := H) seed w m) (k : ℕ) :
    PermRep (H := H) seed (iterContract (H := H) a w k) ((Fintype.card H) ^ k * m) := by
  induction k with
  | zero => simpa [iterContract] using hw
  | succ k ih =>
    simpa [iterContract, pow_succ, Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm] using contract_rep a ih

theorem iter_preserves {P : Subgroup G} [P.Normal] {a b : X} {w : X → G}
    (hw : At (H := H) P b w) (k : ℕ) :
    At (H := H) P b (iterContract (H := H) a w k) := by
  induction k with
  | zero => exact hw
  | succ k ih => exact contract_preserves ih

theorem iter_preserves_bound {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    {a b : X} {w : X → G} {δ m : ℝ} (hw : AtBound (H := H) c δ m b w) (k : ℕ) :
    AtBound (H := H) c δ ((Fintype.card H : ℝ) ^ k * m) b
      (iterContract (H := H) a w k) := by
  induction k with
  | zero => simpa [iterContract] using hw
  | succ k ih =>
    simpa [iterContract, pow_succ, mul_assoc, mul_left_comm, mul_comm] using
      contract_preserves_bound (a := a) c ih

theorem iter_values {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    (a : X) (w : X → G) (B : ℝ)
    (hw : ∀ x, Related (H := H) a x → w x ∈ P ∧ c.val (w x) ≤ B) (k : ℕ) :
    ∀ x, Related (H := H) a x →
      iterContract (H := H) a w k x ∈ P ∧
      c.val (iterContract (H := H) a w k x) ≤ ((Fintype.card H - 1 : ℕ) : ℝ) ^ k * B := by
  induction k with
  | zero => simpa [iterContract] using hw
  | succ k ih =>
    have h := contract_values c a (iterContract (H := H) a w k)
      (((Fintype.card H - 1 : ℕ) : ℝ) ^ k * B) ih
    simpa [iterContract, pow_succ, mul_assoc, mul_left_comm, mul_comm] using h

theorem geometric_small (h : ℕ) (hh : 0 < h) (m B δ : ℝ)
    (hm : 0 < m) (hB : 0 ≤ B) (hδ : 0 < δ) :
    ∃ k : ℕ, 2 * ((h - 1 : ℕ) : ℝ) ^ k * B ≤ δ * ((h : ℝ) ^ k * m) := by
  by_cases hzero : B = 0
  · exact ⟨0, by simp [hzero]; positivity⟩
  · have hBpos : 0 < B := lt_of_le_of_ne hB (Ne.symm hzero)
    have hhR : 0 < (h : ℝ) := by exact_mod_cast hh
    have hsub : ((h - 1 : ℕ) : ℝ) < (h : ℝ) := by
      exact_mod_cast (Nat.sub_lt hh (by omega : 0 < 1))
    have hratio : ((h - 1 : ℕ) : ℝ) / h < 1 := (div_lt_one hhR).mpr hsub
    obtain ⟨k, hk⟩ := exists_pow_lt_of_lt_one (div_pos (mul_pos hδ hm) (by positivity : 0 < 2 * B)) hratio
    rw [div_pow] at hk
    have hcross := (div_lt_div_iff₀ (pow_pos hhR k) (by positivity : 0 < 2 * B)).mp hk
    exact ⟨k, by nlinarith [hcross]⟩

theorem small_at [Fintype X] {P : Subgroup G} [P.Normal] (c : InvariantCost P)
    {seed w : X → G} {m : ℕ} (hw : PermRep (H := H) seed w m) (hm : 0 < m)
    (hall : ∀ a, At (H := H) P a w) (a : X) (δ : ℝ) (hδ : 0 < δ) :
    ∃ v n, PermRep (H := H) seed v n ∧ 0 < n ∧
      (∀ b, At (H := H) P b v) ∧ AtBound (H := H) c δ n a v ∧
      ∀ b ε, AtBound (H := H) c ε m b w → AtBound (H := H) c ε n b v := by
  classical
  let w0 : X → G := w * fun _ => (w a)⁻¹
  let B : ℝ := ∑ x : X, c.val (w0 x)
  have hB : 0 ≤ B := Finset.sum_nonneg (fun x _ => c.nonneg _)
  have hval : ∀ x, Related (H := H) a x → w0 x ∈ P ∧ c.val (w0 x) ≤ B := by
    intro x hx
    refine ⟨hall a x a hx (related_refl a), ?_⟩
    exact Finset.single_le_sum (fun y _ => c.nonneg (w0 y)) (Finset.mem_univ x)
  have hw0 : PermRep (H := H) seed w0 m := by
    simpa [w0] using PermRep.mul hw (PermRep.diagonal (w a)⁻¹)
  obtain ⟨k, hk⟩ := geometric_small (Fintype.card H) Fintype.card_pos m B δ
    (by exact_mod_cast hm) hB hδ
  let n := (Fintype.card H) ^ k * m
  let v := iterContract (H := H) a w0 k
  have hvals := iter_values c a w0 B hval k
  refine ⟨v, n, iter_rep a hw0 k, Nat.mul_pos (Nat.pow_pos Fintype.card_pos) hm,
    ?_, ?_, ?_⟩
  · intro b
    exact iter_preserves (at_right _ (hall b)) k
  · intro x y hx hy
    obtain ⟨hxP, hxc⟩ := hvals x hx
    obtain ⟨hyP, hyc⟩ := hvals y hy
    refine ⟨P.mul_mem hxP (P.inv_mem hyP), ?_⟩
    calc
      c.val (v x * (v y)⁻¹) ≤ c.val (v x) + c.val (v y)⁻¹ :=
        c.mul _ hxP _ (P.inv_mem hyP)
      _ = c.val (v x) + c.val (v y) := by rw [c.inv _ hyP]
      _ ≤ 2 * ((Fintype.card H - 1 : ℕ) : ℝ) ^ k * B := by dsimp [v]; nlinarith
      _ ≤ δ * n := by simpa [n] using hk
  · intro b ε hb
    have h := iter_preserves_bound (a := a) c (atBound_right c (w a)⁻¹ hb) k
    simpa [v, n] using h

theorem simultaneous_averaging [Fintype X] (N : Subgroup G) [N.Normal]
    (seed : X → G) (hseed : ∀ a, At (H := H) N a seed) (r : ℕ)
    (c : InvariantCost (derived N r)) (δ : ℝ) (hδ : 0 < δ) :
    ∃ w m, PermRep (H := H) seed w m ∧ 0 < m ∧
      ∀ a, AtBound (H := H) c δ m a w := by
  classical
  obtain ⟨w, m, hw, hm, hall⟩ := membership_depth N seed hseed r
  have refine_set : ∀ T : Finset X, ∃ v n,
      PermRep (H := H) seed v n ∧ 0 < n ∧
      (∀ a, At (H := H) (derived N r) a v) ∧
      ∀ a ∈ T, AtBound (H := H) c δ n a v := by
    intro T
    induction T using Finset.induction_on with
    | empty => exact ⟨w, m, hw, hm, hall, by simp⟩
    | @insert a T ha ih =>
      obtain ⟨v, n, hv, hn, hbase, hT⟩ := ih
      obtain ⟨v', n', hv', hn', hbase', ha', hp⟩ := small_at c hv hn hbase a δ hδ
      refine ⟨v', n', hv', hn', hbase', ?_⟩
      intro b hb
      rcases Finset.mem_insert.mp hb with rfl | hb
      · exact ha'
      · exact hp b δ (hT b hb)
  obtain ⟨w', m', hw', hm', _, hbound⟩ := refine_set Finset.univ
  exact ⟨w', m', hw', hm', fun a => hbound a (Finset.mem_univ _)⟩

end PermutationExpressions

inductive CopyRep (A : Set (I → G)) : (I → G) → ℕ → Prop
  | diagonal (g : G) : CopyRep A (fun _ => g) 0
  | atom (a : I → G) : a ∈ A → CopyRep A a 1
  | mul {a b m n} : CopyRep A a m → CopyRep A b n → CopyRep A (a * b) (m + n)

def copyGrading (A : Set (I → G)) : Grading I G where
  rep := CopyRep A
  diagonal := CopyRep.diagonal
  multiply := CopyRep.mul

inductive WeightedPath (A T : Set (I → G)) (q : ℝ) : (I → G) → ℝ → Prop
  | diagonal (g : G) : WeightedPath A T q (fun _ => g) 0
  | unit (a : I → G) : a ∈ A → WeightedPath A T q a 1
  | scaled (a : I → G) : a ∈ T → WeightedPath A T q a q
  | mul {a b t u} : WeightedPath A T q a t → WeightedPath A T q b u →
      WeightedPath A T q (a * b) (t + u)

theorem copy_path {A T : Set (I → G)} {q : ℝ} {a : I → G} {n : ℕ}
    (h : CopyRep A a n) : WeightedPath A T q a n := by
  induction h with
  | diagonal g => simpa using WeightedPath.diagonal (A := A) (T := T) (q := q) g
  | atom a ha => simpa using WeightedPath.unit (T := T) (q := q) a ha
  | mul ha hb iha ihb => simpa using WeightedPath.mul iha ihb

theorem perm_path {H : Type w} [Group H] {X : Type v} [MulAction H X]
    {seed w : X → G} {m : ℕ} (hw : PermRep (H := H) seed w m) (f : I → X)
    {A T : Set (I → G)} {q t : ℝ}
    (ha : ∀ h : H, WeightedPath A T q (fun i => seed (h • f i)) t) :
    WeightedPath A T q (fun i => w (f i)) (t * m) := by
  induction hw with
  | diagonal g => simpa using WeightedPath.diagonal (A := A) (T := T) (q := q) g
  | atom h => simpa using ha h
  | mul ha hb iha ihb =>
    simpa [mul_add, Pi.mul_def] using WeightedPath.mul iha ihb

theorem weight_bound (s m a b q δ : ℝ) (hs : 0 ≤ s) (hm : 0 < m)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hq : 0 < q) (hδ : 0 < δ)
    (hcost : a + b ≤ s * δ * m) :
    0 < m + a ∧ 0 ≤ q * m + b ∧ (q * m + b) / (m + a) ≤ q + s * δ := by
  have hposden : 0 < m + a := by linarith
  have hnum : 0 ≤ q * m + b := by positivity
  refine ⟨hposden, hnum, (div_le_iff₀ hposden).mpr ?_⟩
  have hbase : b ≤ s * δ * m := by linarith
  have hpos : 0 ≤ (q + s * δ) * a := by positivity
  nlinarith

section EndpointTheorem

variable {H : Type w} [Group H] [Fintype H] {X : Type v}
  [Fintype X] [MulAction H X] [Fintype I]

def scaledCopies (seed : X → G) (g : I → X) : Set (I → G) :=
  Set.range (fun h : H => fun i => seed (h • g i))

theorem abstract_endpoint_bridge (N : Subgroup G) [N.Normal]
    (A : Set (I → G)) (hs : 2 ≤ Fintype.card I) (hp : PairHyp (copyGrading A) N)
    (seed : X → G) (hseed : ∀ a, At (H := H) N a seed)
    (f g : I → X) (hfg : ∀ i, Related (H := H) (f i) (g i))
    (hf : ∀ h : H, (fun i => seed (h • f i)) ∈ A)
    (q δ : ℝ) (hq : 0 < q) (hδ : 0 < δ) :
    ∃ w m u v a b,
      PermRep (H := H) seed w m ∧ 0 < m ∧ CopyRep A u a ∧ CopyRep A v b ∧
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
  let L := derived N (Fintype.card I - 2)
  let c : InvariantCost L := correctionCost hs hp
  obtain ⟨w, m, hw, hm, hall⟩ :=
    simultaneous_averaging N seed hseed (Fintype.card I - 2) c δ hδ
  let Dp : I → G := fun i => w (f i)
  let Dm : I → G := fun i => w (g i)
  let z : I → G := Dp⁻¹ * Dm
  have hz : ∀ i, z i ∈ L ∧ c.val (z i) ≤ δ * m := by
    intro i
    obtain ⟨hr, hcr⟩ := hall (f i) (f i) (g i) (related_refl _) (hfg i)
    let r := w (f i) * (w (g i))⁻¹
    have hrinv := L.inv_mem hr
    have hc := (inferInstance : L.Normal).conj_mem r⁻¹ hrinv (w (f i))⁻¹
    have he : z i = (w (f i))⁻¹ * r⁻¹ * ((w (f i))⁻¹)⁻¹ := by
      dsimp [z, Dp, Dm, r]
      group
    refine ⟨by rwa [he], ?_⟩
    rw [he, c.conj _ hrinv, c.inv _ hr]
    exact hcr
  have hsingle : ∀ i, z i ∈ supportedSubgroup R i :=
    fun i => derived_inclusion hs hp i (hz i).1
  have hsum : ((∑ i, singleCost R i (z i) : ℕ) : ℝ) ≤ Fintype.card I * δ * m := by
    calc
      ((∑ i, singleCost R i (z i) : ℕ) : ℝ) = ∑ i, (singleCost R i (z i) : ℝ) := by simp
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
    have hab' : (a : ℝ) + b = ((∑ i, singleCost R i (z i) : ℕ) : ℝ) := by exact_mod_cast hab
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
  refine ⟨w, m, u, v, a, b, hw, hm, hu, hv, hend, hbudget,
    WeightedPath.mul hplus (copy_path hu), WeightedPath.mul hminus (copy_path hv), ?_⟩
  exact weight_bound _ _ _ _ q δ (by positivity) (by exact_mod_cast hm)
    (by positivity) (by positivity) hq hδ hbudget

end EndpointTheorem

def exponent (E : Type u) : FreeGroup E →* Multiplicative ℤ :=
  FreeGroup.lift (fun _ => Multiplicative.ofAdd (1 : ℤ))

def letterKernel (E : Type u) : Subgroup (FreeGroup E) :=
  (exponent E).ker

instance letterKernel_normal (E : Type u) : (letterKernel E).Normal := by
  unfold letterKernel
  infer_instance

def letters {E : Type u} {X : Type v} (label : X → E) : X → FreeGroup E :=
  fun x => FreeGroup.of (label x)

theorem letter_difference {E : Type u} {X : Type v} (label : X → E) (x y : X) :
    letters label x * (letters label y)⁻¹ ∈ letterKernel E := by
  change exponent E (FreeGroup.of (label x) * (FreeGroup.of (label y))⁻¹) = 1
  simp [exponent]

theorem endpoint_bridge {E : Type u} {H : Type w} [Group H] [Fintype H]
    {X : Type v} [Fintype X] [MulAction H X] [Fintype I]
    (A : Set (I → FreeGroup E)) (hs : 2 ≤ Fintype.card I)
    (hp : PairProjectionHyp (copyGrading A) (letterKernel E))
    (label : X → E) (f g : I → X) (hfg : ∀ i, Related (H := H) (f i) (g i))
    (hf : ∀ h : H, (fun i => letters label (h • f i)) ∈ A)
    (q δ : ℝ) (hq : 0 < q) (hδ : 0 < δ) :
    ∃ w m u v a b,
      PermRep (H := H) (letters label) w m ∧ 0 < m ∧ CopyRep A u a ∧ CopyRep A v b ∧
      (fun i => w (f i)) * u = (fun i => w (g i)) * v ∧
      (a + b : ℝ) ≤ Fintype.card I * δ * m ∧
      WeightedPath A (scaledCopies (H := H) (letters label) g) q
        ((fun i => w (f i)) * u) ((m : ℝ) + a) ∧
      WeightedPath A (scaledCopies (H := H) (letters label) g) q
        ((fun i => w (g i)) * v) (q * m + b) ∧
      0 < (m : ℝ) + a ∧ 0 ≤ q * m + b ∧
      (q * m + b) / ((m : ℝ) + a) ≤ q + Fintype.card I * δ := by
  apply abstract_endpoint_bridge (letterKernel E) A hs (pairHyp_of_projections hp)
    (letters label) _ f g hfg hf q δ hq hδ
  intro a x y _ _
  exact letter_difference label x y

#print axioms derived_inclusion
#print axioms correctionCost
#print axioms simultaneous_averaging
#print axioms endpoint_bridge

end EndpointBridge
