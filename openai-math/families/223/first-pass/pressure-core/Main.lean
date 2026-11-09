import Mathlib

noncomputable section

open scoped BigOperators

namespace PressureCore

abbrev SiteRing (V : Type*) := MvPolynomial V ℝ
abbrev Series (V : Type*) := PowerSeries (SiteRing V)

variable {V P : Type*}

def PolyNN (p : SiteRing V) : Prop :=
  ∀ m, 0 ≤ MvPolynomial.coeff m p

def SeriesNN (f : Series V) : Prop :=
  ∀ n, PolyNN (PowerSeries.coeff n f)

theorem polyNN_zero : PolyNN (0 : SiteRing V) := by
  intro m
  simp

theorem polyNN_one : PolyNN (1 : SiteRing V) := by
  classical
  intro m
  rw [MvPolynomial.coeff_one]
  split_ifs <;> norm_num

theorem polyNN_add {p r : SiteRing V} (hp : PolyNN p) (hr : PolyNN r) :
    PolyNN (p + r) := by
  intro m
  simpa only [MvPolynomial.coeff_add] using add_nonneg (hp m) (hr m)

theorem polyNN_sum {I : Type*} (s : Finset I) (f : I → SiteRing V)
    (hf : ∀ i ∈ s, PolyNN (f i)) : PolyNN (∑ i ∈ s, f i) := by
  intro m
  rw [MvPolynomial.coeff_sum]
  exact Finset.sum_nonneg fun i hi => hf i hi m

theorem polyNN_mul {p r : SiteRing V} (hp : PolyNN p) (hr : PolyNN r) :
    PolyNN (p * r) := by
  classical
  intro m
  rw [MvPolynomial.coeff_mul]
  exact Finset.sum_nonneg fun ij _ => mul_nonneg (hp ij.1) (hr ij.2)

theorem polyNN_nat (n : ℕ) : PolyNN (n : SiteRing V) := by
  induction n with
  | zero => simpa using (polyNN_zero (V := V))
  | succ n ih =>
      simpa only [Nat.cast_add, Nat.cast_one] using polyNN_add ih polyNN_one

theorem seriesNN_zero : SeriesNN (0 : Series V) := by
  intro n
  simpa using (polyNN_zero (V := V))

theorem seriesNN_one : SeriesNN (1 : Series V) := by
  intro n
  rw [PowerSeries.coeff_one]
  split_ifs
  · exact polyNN_one
  · exact polyNN_zero

theorem seriesNN_add {f g : Series V} (hf : SeriesNN f) (hg : SeriesNN g) :
    SeriesNN (f + g) := by
  intro n
  simpa only [map_add] using polyNN_add (hf n) (hg n)

theorem seriesNN_mul {f g : Series V} (hf : SeriesNN f) (hg : SeriesNN g) :
    SeriesNN (f * g) := by
  intro n
  rw [PowerSeries.coeff_mul]
  exact polyNN_sum _ _ fun ij _ => polyNN_mul (hf ij.1) (hg ij.2)

theorem seriesNN_derivative {f : Series V} (hf : SeriesNN f) :
    SeriesNN (PowerSeries.derivative (SiteRing V) f) := by
  intro n
  rw [PowerSeries.coeff_derivative]
  simpa only [Nat.cast_add, Nat.cast_one] using
    polyNN_mul (hf (n + 1)) (polyNN_nat (n + 1))

def inv1 (f : Series V) : Series V :=
  PowerSeries.invOfUnit f 1

theorem mul_inv1 {f : Series V} (hf : PowerSeries.constantCoeff f = 1) :
    f * inv1 f = 1 :=
  PowerSeries.mul_invOfUnit f 1 hf

theorem inv1_mul {f : Series V} (hf : PowerSeries.constantCoeff f = 1) :
    inv1 f * f = 1 :=
  PowerSeries.invOfUnit_mul f 1 hf

theorem ratio_eq_of_mul {f g z : Series V}
    (hz : PowerSeries.constantCoeff z = 1) (h : f * z = g) :
    f = g * inv1 z := by
  calc
    f = f * (z * inv1 z) := by rw [mul_inv1 hz, mul_one]
    _ = (f * z) * inv1 z := by ring
    _ = g * inv1 z := by rw [h]

theorem geometric_nonnegative {a : Series V} (ha : SeriesNN a) :
    SeriesNN (inv1 (1 - a)) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n ih =>
      rw [inv1, PowerSeries.coeff_invOfUnit]
      by_cases hn : n = 0
      · simp only [hn, ↓reduceIte, inv_one, Units.val_one]
        exact polyNN_one
      · simp only [if_neg hn, inv_one, Units.val_one, neg_one_mul]
        rw [← Finset.sum_neg_distrib]
        apply polyNN_sum
        intro ij hij
        by_cases hj : ij.2 < n
        · have hi : ij.1 ≠ 0 := by
            have heq : ij.1 + ij.2 = n := Finset.mem_antidiagonal.mp hij
            omega
          simp only [if_pos hj, map_sub, PowerSeries.coeff_one, if_neg hi,
            zero_sub, neg_mul, neg_neg]
          exact polyNN_mul (ha ij.1) (ih ij.2 hj)
        · simp only [if_neg hj, neg_zero]
          exact polyNN_zero

def Compatible (rel : P → P → Prop) (s : Finset P) : Prop :=
  ∀ a ∈ s, ∀ b ∈ s, a ≠ b → rel a b

theorem compatible_insert [DecidableEq P] {rel : P → P → Prop}
    (hrel : Std.Symm rel) {p : P} {s : Finset P} (hp : p ∉ s) :
    Compatible rel (insert p s) ↔
      Compatible rel s ∧ ∀ j ∈ s, rel p j := by
  constructor
  · intro h
    constructor
    · intro a ha b hb hab
      exact h a (Finset.mem_insert_of_mem ha) b (Finset.mem_insert_of_mem hb) hab
    · intro j hj
      exact h p (Finset.mem_insert_self _ _) j (Finset.mem_insert_of_mem hj)
        (by intro h; exact hp (h ▸ hj))
  · rintro ⟨hs, hj⟩ a ha b hb hab
    by_cases hap : a = p
    · subst a
      exact hj b ((Finset.mem_insert.mp hb).resolve_left (Ne.symm hab))
    · have has : a ∈ s := (Finset.mem_insert.mp ha).resolve_left hap
      by_cases hbp : b = p
      · subst b
        exact hrel.symm p a (hj a has)
      · exact hs a has b ((Finset.mem_insert.mp hb).resolve_left hbp) hab

def partition (rel : P → P → Prop) (activity : P → Series V) (s : Finset P) :
    Series V := by
  classical
  exact ∑ t ∈ s.powerset, if Compatible rel t then ∏ p ∈ t, -activity p else 0

@[simp]
theorem partition_empty (rel : P → P → Prop) (activity : P → Series V) :
    partition rel activity ∅ = 1 := by
  classical
  simp [partition, Compatible]

theorem partition_insert [DecidableEq P] {rel : P → P → Prop}
    [DecidableRel rel] (hrel : Std.Symm rel) (activity : P → Series V)
    {p : P} {s : Finset P} (hp : p ∉ s) :
    partition rel activity (insert p s) =
      partition rel activity s -
        activity p * partition rel activity (s.filter (rel p)) := by
  classical
  let f : Finset P → Series V :=
    fun t => if Compatible rel (insert p t) then ∏ j ∈ insert p t, -activity j else 0
  have hsub : (s.filter (rel p)).powerset ⊆ s.powerset := by
    intro t ht
    exact Finset.mem_powerset.mpr
      ((Finset.mem_powerset.mp ht).trans (Finset.filter_subset _ _))
  have hrestrict :
      ∑ t ∈ (s.filter (rel p)).powerset, f t = ∑ t ∈ s.powerset, f t := by
    apply Finset.sum_subset hsub
    intro t ht hnot
    have hpt : p ∉ t := fun h => hp ((Finset.mem_powerset.mp ht) h)
    have hbad : ¬Compatible rel (insert p t) := by
      intro h
      apply hnot
      apply Finset.mem_powerset.mpr
      intro j hj
      exact Finset.mem_filter.mpr
        ⟨(Finset.mem_powerset.mp ht) hj, (compatible_insert hrel hpt).mp h |>.2 j hj⟩
    simp [f, hbad]
  have hsum :
      ∑ t ∈ s.powerset, f t =
        -activity p * partition rel activity (s.filter (rel p)) := by
    rw [← hrestrict, partition, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro t ht
    have hts : t ⊆ s := (Finset.mem_powerset.mp ht).trans (Finset.filter_subset _ _)
    have hpt : p ∉ t := fun h => hp (hts h)
    have hall : ∀ j ∈ t, rel p j := by
      intro j hj
      exact (Finset.mem_filter.mp ((Finset.mem_powerset.mp ht) hj)).2
    by_cases hc : Compatible rel t
    · have hci : Compatible rel (insert p t) :=
        (compatible_insert hrel hpt).mpr ⟨hc, hall⟩
      simp [f, hci, hc, Finset.prod_insert, hpt]
    · have hci : ¬Compatible rel (insert p t) :=
        fun h => hc ((compatible_insert hrel hpt).mp h).1
      simp [f, hci, hc]
  rw [partition, Finset.sum_powerset_insert hp]
  change partition rel activity s + ∑ t ∈ s.powerset, f t = _
  rw [hsum]
  ring

theorem partition_constant [DecidableEq P] {rel : P → P → Prop}
    [DecidableRel rel] (hrel : Std.Symm rel) (activity : P → Series V)
    (ha0 : ∀ p, PowerSeries.constantCoeff (activity p) = 0) (s : Finset P) :
    PowerSeries.constantCoeff (partition rel activity s) = 1 := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert p s hp ih =>
      rw [partition_insert hrel activity hp]
      simp only [map_sub, map_mul, ha0, zero_mul, sub_zero, ih]

theorem partition_factor [DecidableEq P] {rel : P → P → Prop}
    [DecidableRel rel] (hrel : Std.Symm rel) (activity : P → Series V)
    (ha0 : ∀ p, PowerSeries.constantCoeff (activity p) = 0)
    {s : Finset P} {p : P} (hp : p ∈ s) :
    partition rel activity s =
      partition rel activity (s.erase p) *
        (1 - activity p *
          (partition rel activity ((s.erase p).filter (rel p)) *
            inv1 (partition rel activity (s.erase p)))) := by
  have hrec := partition_insert hrel activity (Finset.notMem_erase p s)
  rw [Finset.insert_erase hp] at hrec
  rw [hrec]
  have hf := mul_inv1 (partition_constant hrel activity ha0 (s.erase p))
  calc
    _ = partition rel activity (s.erase p) -
        activity p * partition rel activity ((s.erase p).filter (rel p)) *
          (partition rel activity (s.erase p) * inv1 (partition rel activity (s.erase p))) := by
            rw [hf]
            ring
    _ = _ := by ring

theorem partition_ratio_nonnegative [DecidableEq P] {rel : P → P → Prop}
    [DecidableRel rel] (hrel : Std.Symm rel) (activity : P → Series V)
    (ha0 : ∀ p, PowerSeries.constantCoeff (activity p) = 0)
    (ha : ∀ p, SeriesNN (activity p)) (s t : Finset P) (ht : t ⊆ s) :
    SeriesNN (partition rel activity t * inv1 (partition rel activity s)) := by
  classical
  revert t
  refine Finset.strongInductionOn s ?_
  intro s ih t ht
  by_cases hts : t = s
  · rw [hts, mul_inv1 (partition_constant hrel activity ha0 s)]
    exact seriesNN_one
  · have hn : ¬s ⊆ t := fun h => hts (Finset.Subset.antisymm ht h)
    obtain ⟨p, hp, hpt⟩ := Finset.not_subset.mp hn
    let b := s.erase p
    let c := b.filter (rel p)
    let f := partition rel activity b
    let a := activity p * (partition rel activity c * inv1 f)
    let g := 1 - a
    have hb : b ⊂ s := Finset.erase_ssubset hp
    have htb : t ⊆ b := by
      intro j hj
      exact Finset.mem_erase.mpr ⟨by intro h; exact hpt (h ▸ hj), ht hj⟩
    have hc : c ⊆ b := Finset.filter_subset _ _
    have hratio : SeriesNN (partition rel activity c * inv1 f) :=
      ih b hb c hc
    have hann : SeriesNN a := seriesNN_mul (ha p) hratio
    have hf : PowerSeries.constantCoeff f = 1 :=
      partition_constant hrel activity ha0 b
    have hg : PowerSeries.constantCoeff g = 1 := by
      simp [g, a, ha0]
    have hfactor : partition rel activity s = f * g :=
      partition_factor hrel activity ha0 hp
    have heq :
        (partition rel activity t * inv1 f) * inv1 g =
          partition rel activity t * inv1 (partition rel activity s) := by
      apply ratio_eq_of_mul (partition_constant hrel activity ha0 s)
      rw [hfactor]
      calc
        _ = partition rel activity t * (inv1 f * f) * (inv1 g * g) := by ring
        _ = partition rel activity t := by rw [inv1_mul hf, inv1_mul hg]; ring
    rw [← heq]
    exact seriesNN_mul (ih b hb t htb) (geometric_nonnegative hann)

def logDerivative (f : Series V) : Series V :=
  -(PowerSeries.derivative (SiteRing V) f) * inv1 f

theorem logDerivative_mul {f g : Series V}
    (hf : PowerSeries.constantCoeff f = 1) (hg : PowerSeries.constantCoeff g = 1) :
    logDerivative (f * g) = logDerivative f + logDerivative g := by
  have hfg : PowerSeries.constantCoeff (f * g) = 1 := by simp [hf, hg]
  unfold logDerivative
  symm
  apply ratio_eq_of_mul hfg
  calc
    _ = -(PowerSeries.derivative (SiteRing V) f) * g * (inv1 f * f) +
        -(PowerSeries.derivative (SiteRing V) g) * f * (inv1 g * g) := by ring
    _ = -(PowerSeries.derivative (SiteRing V) (f * g)) := by
      rw [inv1_mul hf, inv1_mul hg]
      rw [Derivation.leibniz]
      simp only [smul_eq_mul]
      ring

theorem partition_logDerivative_nonnegative [DecidableEq P] {rel : P → P → Prop}
    [DecidableRel rel] (hrel : Std.Symm rel) (activity : P → Series V)
    (ha0 : ∀ p, PowerSeries.constantCoeff (activity p) = 0)
    (ha : ∀ p, SeriesNN (activity p)) (s : Finset P) :
    SeriesNN (logDerivative (partition rel activity s)) := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      simp only [partition_empty, logDerivative, Derivation.map_one_eq_zero, neg_zero, zero_mul]
      exact seriesNN_zero
  | @insert p s hp ih =>
      let c := s.filter (rel p)
      let f := partition rel activity s
      let a := activity p * (partition rel activity c * inv1 f)
      let g := 1 - a
      have hratio : SeriesNN (partition rel activity c * inv1 f) :=
        partition_ratio_nonnegative hrel activity ha0 ha s c (Finset.filter_subset _ _)
      have hann : SeriesNN a := seriesNN_mul (ha p) hratio
      have hf : PowerSeries.constantCoeff f = 1 :=
        partition_constant hrel activity ha0 s
      have hg : PowerSeries.constantCoeff g = 1 := by simp [g, a, ha0]
      have hfactor : partition rel activity (insert p s) = f * g := by
        simpa [f, g, a, c, hp] using
          (partition_factor hrel activity ha0 (Finset.mem_insert_self p s))
      rw [hfactor, logDerivative_mul hf hg]
      apply seriesNN_add ih
      have hderiv : logDerivative g =
          PowerSeries.derivative (SiteRing V) a * inv1 g := by
        simp [logDerivative, g]
      rw [hderiv]
      exact seriesNN_mul (seriesNN_derivative hann) (geometric_nonnegative hann)

theorem derivative_log_base :
    PowerSeries.derivative (SiteRing V) (PowerSeries.log (SiteRing V)) *
      (1 + PowerSeries.X) = 1 := by
  rw [PowerSeries.deriv_log, mul_add, mul_one]
  ext n
  cases n with
  | zero => simp
  | succ n =>
      simp [PowerSeries.coeff_succ_mul_X, pow_succ]

theorem derivative_logOf {f : Series V} (hf : PowerSeries.constantCoeff f = 1) :
    PowerSeries.derivative (SiteRing V) (PowerSeries.logOf f) =
      PowerSeries.derivative (SiteRing V) f * inv1 f := by
  have hs : PowerSeries.HasSubst (f - 1) :=
    PowerSeries.HasSubst.of_constantCoeff_zero' (by simp [hf])
  have hbase := congrArg (fun z : Series V => z.subst (f - 1))
    (derivative_log_base (V := V))
  have hone : (1 : Series V).subst (f - 1) = 1 := by
    rw [← PowerSeries.coe_substAlgHom (R := SiteRing V) hs]
    exact map_one _
  have hadd : (1 + PowerSeries.X : Series V).subst (f - 1) = f := by
    rw [PowerSeries.subst_add hs, hone, PowerSeries.subst_X hs]
    ring
  rw [PowerSeries.subst_mul hs, hadd, hone] at hbase
  have hinv :
      (PowerSeries.derivative (SiteRing V) (PowerSeries.log (SiteRing V))).subst (f - 1)
        = inv1 f := by
    simpa using ratio_eq_of_mul hf hbase
  rw [PowerSeries.logOf_eq, PowerSeries.derivative_subst _ hs, hinv]
  simp only [map_sub, Derivation.map_one_eq_zero, sub_zero]
  ring

theorem hard_core_pressure_nonnegative [DecidableEq P] {rel : P → P → Prop}
    [DecidableRel rel] (hrel : Std.Symm rel) (activity : P → Series V)
    (ha0 : ∀ p, PowerSeries.constantCoeff (activity p) = 0)
    (ha : ∀ p, SeriesNN (activity p)) (s : Finset P) :
    SeriesNN (-PowerSeries.logOf (partition rel activity s)) := by
  classical
  have hc := partition_constant hrel activity ha0 s
  have hd := partition_logDerivative_nonnegative hrel activity ha0 ha s
  have heq :
      PowerSeries.derivative (SiteRing V) (-PowerSeries.logOf (partition rel activity s)) =
        logDerivative (partition rel activity s) := by
    rw [map_neg, derivative_logOf hc]
    simp [logDerivative]
  intro n
  cases n with
  | zero =>
      rw [PowerSeries.coeff_zero_eq_constantCoeff_apply, map_neg,
        PowerSeries.constantCoeff_logOf hc, neg_zero]
      exact polyNN_zero
  | succ n =>
      intro m
      have h := hd n m
      rw [← heq, PowerSeries.coeff_derivative] at h
      have hcoeff :
          MvPolynomial.coeff m
            (PowerSeries.coeff (n + 1)
              (-PowerSeries.logOf (partition rel activity s)) * (n + 1 : SiteRing V)) =
          MvPolynomial.coeff m
            (PowerSeries.coeff (n + 1)
              (-PowerSeries.logOf (partition rel activity s))) * (n + 1 : ℝ) := by
        have hcast : (n + 1 : SiteRing V) = MvPolynomial.C (n + 1 : ℝ) := by simp
        rw [hcast, mul_comm, MvPolynomial.coeff_C_mul]
        ring
      rw [hcoeff] at h
      exact nonneg_of_mul_nonneg_left h (by positivity : (0 : ℝ) < n + 1)

theorem polyNN_monomial (m : V →₀ ℕ) {a : ℝ} (ha : 0 ≤ a) :
    PolyNN (MvPolynomial.monomial m a) := by
  classical
  intro d
  rw [MvPolynomial.coeff_monomial]
  split_ifs
  · exact ha
  · exact le_rfl

theorem monomial_pressure_nonnegative [DecidableEq P] {rel : P → P → Prop}
    [DecidableRel rel] (hrel : Std.Symm rel)
    (amplitude : P → ℝ) (site : P → (V →₀ ℕ)) (degree : P → ℕ)
    (hamplitude : ∀ p, 0 ≤ amplitude p) (hdegree : ∀ p, 0 < degree p)
    (s : Finset P) (n : ℕ) (m : V →₀ ℕ) :
    0 ≤ MvPolynomial.coeff m
      (PowerSeries.coeff n
        (-PowerSeries.logOf
          (partition rel
            (fun p => PowerSeries.monomial (degree p)
              (MvPolynomial.monomial (site p) (amplitude p))) s))) := by
  have ha0 : ∀ p, PowerSeries.constantCoeff
      (PowerSeries.monomial (degree p)
        (MvPolynomial.monomial (site p) (amplitude p))) = 0 := by
    intro p
    rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply, PowerSeries.coeff_monomial]
    simp [Ne.symm (ne_of_gt (hdegree p))]
  have ha : ∀ p, SeriesNN
      (PowerSeries.monomial (degree p)
        (MvPolynomial.monomial (site p) (amplitude p))) := by
    intro p j
    rw [PowerSeries.coeff_monomial]
    split_ifs
    · exact polyNN_monomial _ (hamplitude p)
    · exact polyNN_zero
  exact hard_core_pressure_nonnegative hrel _ ha0 ha s n m

end PressureCore
