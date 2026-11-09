import Mathlib

set_option autoImplicit false

namespace ArithmeticBridge

@[ext]
structure RationalCode where
  p : ℕ
  n : ℕ
  d : ℕ
  t : ℕ
  s : ℕ
  q : ℕ
deriving DecidableEq

def RationalCode.Valid (z : RationalCode) : Prop :=
  z.p * z.n = 0 ∧ z.d = 1 + z.t + z.s ∧
    (z.p + z.n) * z.t + z.d = 1 + z.q * z.d

def RationalCode.value (z : RationalCode) : ℚ :=
  ((z.p : ℚ) - z.n) / z.d

lemma inverse_exists (a d : ℕ) (hd : 0 < d) (hc : a.Coprime d) :
    ∃ t s q : ℕ, d = 1 + t + s ∧ a * t + d = 1 + q * d := by
  by_cases h : d = 1
  · subst d
    exact ⟨0, 0, 0, by omega, by simp⟩
  · obtain ⟨t, ht, hm⟩ := Nat.exists_mul_mod_eq_one_of_coprime hc (by omega)
    refine ⟨t, d - 1 - t, a * t / d + 1, by omega, ?_⟩
    have hv := Nat.mod_add_div (a * t) d
    rw [hm] at hv
    nlinarith

lemma inverse_coprime (a d t q : ℕ) (h : a * t + d = 1 + q * d) :
    a.Coprime d := by
  apply Nat.coprime_of_dvd'
  intro k _ hka hkd
  have hl : k ∣ a * t + d := dvd_add (dvd_mul_of_dvd_left hka t) hkd
  rw [h] at hl
  have hr : k ∣ q * d := dvd_mul_of_dvd_right hkd q
  have hk := Nat.dvd_sub hl hr
  simpa using hk

lemma inverse_unique (a d t s q t' s' q' : ℕ)
    (hd : 0 < d) (h : d = 1 + t + s) (h' : d = 1 + t' + s')
    (he : a * t + d = 1 + q * d)
    (he' : a * t' + d = 1 + q' * d) :
    t = t' ∧ s = s' ∧ q = q' := by
  have hc := inverse_coprime a d t q he
  have hm : a * t ≡ a * t' [MOD d] := by
    have h1 := congrArg (fun x : ℕ => x % d) he
    have h2 := congrArg (fun x : ℕ => x % d) he'
    have h1' : a * t % d = 1 % d := by simpa [Nat.add_mod] using h1
    have h2' : a * t' % d = 1 % d := by simpa [Nat.add_mod] using h2
    exact h1'.trans h2'.symm
  have ht := (hm.cancel_left_of_coprime hc.symm).eq_of_lt_of_lt (by omega) (by omega)
  subst t'
  have hs : s = s' := by omega
  have hq : q = q' := by nlinarith
  exact ⟨rfl, hs, hq⟩

lemma RationalCode.normalized (z : RationalCode) (hz : z.Valid) :
    z.value.num = (z.p : ℤ) - z.n ∧ z.value.den = z.d := by
  obtain ⟨hpn, hd, he⟩ := hz
  have hdpos : 0 < z.d := by omega
  have habs : ((z.p : ℤ) - z.n).natAbs = z.p + z.n := by
    rcases Nat.mul_eq_zero.mp hpn with hp | hn
    · simp [hp]
    · simp [hn]
  have hc : Nat.Coprime ((z.p : ℤ) - z.n).natAbs (z.d : ℤ).natAbs := by
    simpa [habs] using inverse_coprime (z.p + z.n) z.d z.t z.q he
  have hn := Rat.num_div_eq_of_coprime (a := (z.p : ℤ) - z.n)
    (b := z.d) (by exact_mod_cast hdpos) hc
  have hdd := Rat.den_div_eq_of_coprime (a := (z.p : ℤ) - z.n)
    (b := z.d) (by exact_mod_cast hdpos) hc
  have hval : (((z.p : ℤ) - z.n : ℤ) : ℚ) / (z.d : ℤ) = z.value := by
    simp [RationalCode.value]
  rw [hval] at hn hdd
  constructor
  · exact hn
  · exact_mod_cast hdd

theorem rational_code_exists_unique (x : ℚ) :
    ∃! z : RationalCode, z.Valid ∧ z.value = x := by
  let p := x.num.toNat
  let n := (-x.num).toNat
  have hpn : p * n = 0 := by
    dsimp [p, n]
    rcases le_total 0 x.num with h | h
    · have : (-x.num).toNat = 0 := by omega
      simp [this]
    · have : x.num.toNat = 0 := by omega
      simp [this]
  have hdiff : (p : ℤ) - n = x.num := by dsimp [p, n]; omega
  have habs : x.num.natAbs = p + n := by
    rw [← hdiff]
    rcases Nat.mul_eq_zero.mp hpn with hp | hn
    · simp [hp]
    · simp [hn]
  have hc : (p + n).Coprime x.den := by simpa [habs] using x.reduced
  obtain ⟨t, s, q, hd, he⟩ := inverse_exists (p + n) x.den x.den_pos hc
  let z : RationalCode := ⟨p, n, x.den, t, s, q⟩
  have hz : z.Valid := ⟨hpn, hd, he⟩
  have hv : z.value = x := by
    unfold RationalCode.value
    change ((p : ℚ) - n) / x.den = x
    have : (p : ℚ) - n = (x.num : ℚ) := by exact_mod_cast hdiff
    rw [this, Rat.num_div_den]
  refine ⟨z, ⟨hz, hv⟩, ?_⟩
  intro w hw
  have hw0 := w.normalized hw.1
  have hz0 := z.normalized hz
  have hn : (w.p : ℤ) - w.n = (z.p : ℤ) - z.n := by
    rw [← hw0.1, ← hz0.1, hw.2, hv]
  have hdd : w.d = z.d := by rw [← hw0.2, ← hz0.2, hw.2, hv]
  have hp : w.p = z.p := by
    rcases Nat.mul_eq_zero.mp hw.1.1 with hwp | hwn <;>
      rcases Nat.mul_eq_zero.mp hz.1 with hzp | hzn <;> omega
  have hnn : w.n = z.n := by omega
  have hi := inverse_unique (z.p + z.n) z.d w.t w.s w.q z.t z.s z.q
    (by have := hz.2.1; omega) (by simpa [hp, hnn, hdd] using hw.1.2.1)
    hz.2.1 (by simpa [hp, hnn, hdd] using hw.1.2.2) hz.2.2
  exact RationalCode.ext hp hnn hdd hi.1 hi.2.1 hi.2.2

abbrev RationalPoint := Option (ℚ × ℚ)

@[ext]
structure PointCode where
  o : ℕ
  x : RationalCode
  y : RationalCode

def PointCode.Represents (z : PointCode) (p : RationalPoint) : Prop :=
  z.x.Valid ∧ z.y.Valid ∧
    match p with
    | none => z.o = 1 ∧ z.x.value = 0 ∧ z.y.value = 0
    | some p => z.o = 0 ∧ z.x.value = p.1 ∧ z.y.value = p.2

theorem point_code_exists_unique (p : RationalPoint) :
    ∃! z : PointCode, z.Represents p := by
  cases p with
  | none =>
    obtain ⟨c, hc, hcu⟩ := rational_code_exists_unique 0
    refine ⟨⟨1, c, c⟩, ⟨hc.1, hc.1, rfl, hc.2, hc.2⟩, ?_⟩
    intro z hz
    exact PointCode.ext hz.2.2.1 (hcu _ ⟨hz.1, hz.2.2.2.1⟩)
      (hcu _ ⟨hz.2.1, hz.2.2.2.2⟩)
  | some p =>
    obtain ⟨x, hx, hxu⟩ := rational_code_exists_unique p.1
    obtain ⟨y, hy, hyu⟩ := rational_code_exists_unique p.2
    refine ⟨⟨0, x, y⟩, ⟨hx.1, hy.1, rfl, hx.2, hy.2⟩, ?_⟩
    intro z hz
    exact PointCode.ext hz.2.2.1 (hxu _ ⟨hz.1, hz.2.2.2.1⟩)
      (hyu _ ⟨hz.2.1, hz.2.2.2.2⟩)

theorem slope_code_exists_unique (d e : ℚ) (hd : d ≠ 0) :
    ∃! z : RationalCode, z.Valid ∧ d * z.value = e := by
  obtain ⟨z, hz, hzu⟩ := rational_code_exists_unique (e / d)
  refine ⟨z, ⟨hz.1, ?_⟩, ?_⟩
  · rw [hz.2]
    field_simp
  · intro w hw
    apply hzu w
    refine ⟨hw.1, (eq_div_iff hd).mpr ?_⟩
    simpa only [mul_comm] using hw.2

def OnCurve (p : RationalPoint) : Prop :=
  match p with
  | none => True
  | some (x, y) => y ^ 2 = x ^ 3 - 25 * x

def AdditionGuard (i : Fin 7) (p q : RationalPoint) : Prop :=
  match i.val, p, q with
  | 0, none, _ => True
  | 1, some _, none => True
  | 2, some p, some q => p.1 < q.1
  | 3, some p, some q => q.1 < p.1
  | 4, some p, some q => p.1 = q.1 ∧ p.2 + q.2 = 0
  | 5, some p, some q => p.1 = q.1 ∧ p.2 = q.2 ∧ 0 < p.2
  | 6, some p, some q => p.1 = q.1 ∧ p.2 = q.2 ∧ p.2 < 0
  | _, _, _ => False

theorem addition_guards_partition (p q : RationalPoint) (hp : OnCurve p)
    (hq : OnCurve q) : ∃! i : Fin 7, AdditionGuard i p q := by
  cases p with
  | none =>
    refine ⟨0, by trivial, ?_⟩
    intro i hi
    fin_cases i <;> simp_all [AdditionGuard]
  | some p =>
    cases q with
    | none =>
      refine ⟨1, by trivial, ?_⟩
      intro i hi
      fin_cases i <;> simp_all [AdditionGuard]
    | some q =>
      by_cases hx : p.1 < q.1
      · refine ⟨2, hx, ?_⟩
        intro i hi
        fin_cases i <;> simp_all [AdditionGuard] <;> linarith
      by_cases hx' : q.1 < p.1
      · refine ⟨3, hx', ?_⟩
        intro i hi
        fin_cases i <;> simp_all [AdditionGuard] <;> linarith
      have heq : p.1 = q.1 := by linarith
      by_cases hy : p.2 + q.2 = 0
      · refine ⟨4, ⟨heq, hy⟩, ?_⟩
        intro i hi
        fin_cases i <;> simp_all [AdditionGuard] <;> linarith
      have hsq : p.2 ^ 2 = q.2 ^ 2 := by
        change p.2 ^ 2 = p.1 ^ 3 - 25 * p.1 at hp
        change q.2 ^ 2 = q.1 ^ 3 - 25 * q.1 at hq
        rw [heq] at hp
        linarith
      have hyeq : p.2 = q.2 := by
        rcases (sq_eq_sq_iff_eq_or_eq_neg).mp hsq with h | h
        · exact h
        · exact False.elim (hy (by linarith))
      by_cases hyp : 0 < p.2
      · refine ⟨5, ⟨heq, hyeq, hyp⟩, ?_⟩
        intro i hi
        fin_cases i <;> simp_all [AdditionGuard] <;> linarith
      · have hyn : p.2 < 0 := by
          by_contra hn
          have hz : p.2 = 0 := by linarith
          exact hy (by rw [← hyeq, hz]; norm_num)
        refine ⟨6, ⟨heq, hyeq, hyn⟩, ?_⟩
        intro i hi
        fin_cases i <;> simp_all [AdditionGuard] <;> linarith

theorem addition_divisors_nonzero (p q : ℚ × ℚ) (i : Fin 7)
    (h : AdditionGuard i (some p) (some q)) :
    ((i.val = 2 ∨ i.val = 3) → q.1 - p.1 ≠ 0) ∧
      ((i.val = 5 ∨ i.val = 6) → 2 * p.2 ≠ 0) := by
  fin_cases i <;> simp_all [AdditionGuard] <;> intro he <;> linarith

theorem comparison_slack (a b : ℤ) (h : b ≤ a) :
    ∃! s : ℕ, a = b + s := by
  refine ⟨(a - b).toNat, by omega, ?_⟩
  intro s hs
  omega

@[ext]
structure CaseWitness (I O : Type) (Z : I → Type) where
  output : O
  selector : I → ℕ
  coordinates : (i : I) → Z i

def CaseOK {I O : Type} [Fintype I] {Z : I → Type}
    (guard : I → Prop) (R : (i : I) → O → Z i → Prop)
    (zero : (i : I) → Z i) (z : CaseWitness I O Z) : Prop :=
  (∀ i, z.selector i = 0 ∨ z.selector i = 1) ∧
    (∑ i, z.selector i) = 1 ∧
    (∀ i, z.selector i = 1 → guard i ∧ R i z.output (z.coordinates i)) ∧
    (∀ i, z.selector i = 0 → z.coordinates i = zero i)

theorem gated_cases_unique {I O : Type} [Fintype I] {Z : I → Type}
    (guard : I → Prop) (R : (i : I) → O → Z i → Prop)
    (zero : (i : I) → Z i) (hguard : ∃! i, guard i)
    (hR : ∀ i, guard i → ∃! p : O × Z i, R i p.1 p.2) :
    ∃! z : CaseWitness I O Z, CaseOK guard R zero z := by
  classical
  obtain ⟨i₀, hi₀, hiu⟩ := hguard
  let pair (i : I) (h : guard i) := Classical.choose (hR i h)
  have pair_spec (i : I) (h : guard i) : R i (pair i h).1 (pair i h).2 :=
    (Classical.choose_spec (hR i h)).1
  have guard_iff (i : I) : guard i ↔ i = i₀ := ⟨hiu i, fun he => he ▸ hi₀⟩
  let z : CaseWitness I O Z := {
    output := (pair i₀ hi₀).1
    selector := fun i => if guard i then 1 else 0
    coordinates := fun i => if h : guard i then (pair i h).2 else zero i
  }
  have hz : CaseOK guard R zero z := by
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro i
      by_cases h : guard i <;> simp [z, h]
    · change (∑ i, if guard i then (1 : ℕ) else 0) = 1
      simp_rw [guard_iff]
      simp
    · intro i he
      have hg : guard i := by
        by_contra h
        simp [z, h] at he
      have heq := hiu i hg
      subst i
      refine ⟨hi₀, ?_⟩
      simpa only [z, dif_pos hi₀] using pair_spec i₀ hi₀
    · intro i he
      have hg : ¬ guard i := by
        intro h
        simp [z, h] at he
      simp [z, hg]
  refine ⟨z, hz, ?_⟩
  intro w hw
  have hactive : ∃ i, w.selector i = 1 := by
    by_contra hn
    have hall : ∀ i, w.selector i = 0 := by
      intro i
      rcases hw.1 i with h | h
      · exact h
      · exact False.elim (hn ⟨i, h⟩)
    have hsum : (∑ i, w.selector i) = 0 := by simp [hall]
    have hsum' := hw.2.1
    omega
  obtain ⟨i, hi⟩ := hactive
  have hi' := hiu i (hw.2.2.1 i hi).1
  subst i
  have he (j : I) : w.selector j = z.selector j := by
    by_cases hj : j = i₀
    · subst j
      simpa only [z, if_pos hi₀] using hi
    · have hng : ¬ guard j := by simpa only [guard_iff] using hj
      have hwj : w.selector j = 0 := by
        rcases hw.1 j with h | h
        · exact h
        · exact False.elim (hng (hw.2.2.1 j h).1)
      simpa only [z, if_neg hng] using hwj
  have hp := (Classical.choose_spec (hR i₀ hi₀)).2
    (w.output, w.coordinates i₀) (hw.2.2.1 i₀ hi).2
  have ho : w.output = z.output := congrArg Prod.fst hp
  have hc : w.coordinates = z.coordinates := by
    funext j
    by_cases hj : j = i₀
    · subst j
      simpa only [z, dif_pos hi₀] using congrArg Prod.snd hp
    · have hng : ¬ guard j := by simpa only [guard_iff] using hj
      have hwj : w.selector j = 0 := by simpa only [z, if_neg hng] using he j
      simpa only [z, dif_neg hng] using hw.2.2.2 j hwj
  exact CaseWitness.ext ho (funext he) hc

def MaxGuard (a b : ℕ) (i : Fin 2) : Prop :=
  if i = 0 then b ≤ a else a < b

def MaxLocal (a b : ℕ) (i : Fin 2) (h s : ℕ) : Prop :=
  if i = 0 then h = a ∧ a = b + s else h = b ∧ b = a + 1 + s

theorem maximum_complete (a b : ℕ) :
    ∃! z : CaseWitness (Fin 2) ℕ (fun _ => ℕ),
      CaseOK (MaxGuard a b) (MaxLocal a b) (fun _ => 0) z := by
  apply gated_cases_unique
  · by_cases hab : b ≤ a
    · refine ⟨0, by simpa [MaxGuard] using hab, ?_⟩
      intro i hi
      fin_cases i <;> simp_all [MaxGuard] <;> omega
    · refine ⟨1, by simpa [MaxGuard] using (show a < b by omega), ?_⟩
      intro i hi
      fin_cases i <;> simp_all [MaxGuard] <;> omega
  · intro i hi
    fin_cases i
    · have hba : b ≤ a := by simpa [MaxGuard] using hi
      refine ⟨(a, a - b), ?_, ?_⟩
      · change a = a ∧ a = b + (a - b)
        exact ⟨rfl, by omega⟩
      · rintro ⟨h, s⟩ hs
        change h = a ∧ a = b + s at hs
        apply Prod.ext <;> dsimp only <;> omega
    · have hab : a < b := by simpa [MaxGuard] using hi
      refine ⟨(b, b - a - 1), ?_, ?_⟩
      · change b = b ∧ b = a + 1 + (b - a - 1)
        exact ⟨rfl, by omega⟩
      · rintro ⟨h, s⟩ hs
        change h = b ∧ b = a + 1 + s at hs
        apply Prod.ext <;> dsimp only <;> omega

theorem unique_expansion {X A : Type} (P : X → Prop) (E : X → A → Prop)
    (hP : ∃! x, P x) (hE : ∀ x, P x → ∃! a, E x a) :
    ∃! z : X × A, P z.1 ∧ E z.1 z.2 := by
  obtain ⟨x, hx, hxu⟩ := hP
  obtain ⟨a, ha, hau⟩ := hE x hx
  refine ⟨(x, a), ⟨hx, ha⟩, ?_⟩
  rintro ⟨y, b⟩ ⟨hy, hb⟩
  have hxy := hxu y hy
  subst y
  exact Prod.ext rfl (hau b hb)

theorem slope_output_complete (d e : ℚ) (hd : d ≠ 0) (f : ℚ → RationalPoint)
    (a b : ℤ) (hab : b < a) :
    ∃! z : (RationalCode × PointCode) × ℕ,
      (z.1.1.Valid ∧ d * z.1.1.value = e) ∧
      z.1.2.Represents (f z.1.1.value) ∧ a = b + 1 + z.2 := by
  have hcodes : ∃! z : RationalCode × PointCode,
      (z.1.Valid ∧ d * z.1.value = e) ∧ z.2.Represents (f z.1.value) :=
    unique_expansion _ _ (slope_code_exists_unique d e hd)
      (fun z _ => point_code_exists_unique (f z.value))
  obtain ⟨z, hz, hzu⟩ := hcodes
  obtain ⟨s, hs, hsu⟩ := comparison_slack a (b + 1) (by omega)
  refine ⟨(z, s), ⟨hz.1, hz.2, hs⟩, ?_⟩
  rintro ⟨w, t⟩ ⟨hw1, hw2, ht⟩
  exact Prod.ext (hzu w ⟨hw1, hw2⟩) (hsu t ht)

def crossNumerator (x y : ℚ) : ℤ :=
  x.num * y.den - y.num * x.den

theorem crossNumerator_pos (x y : ℚ) (h : y < x) : 0 < crossNumerator x y := by
  have hx : (0 : ℚ) < x.den := by exact_mod_cast x.den_pos
  have hy : (0 : ℚ) < y.den := by exact_mod_cast y.den_pos
  have hdiv : (y.num : ℚ) / y.den < (x.num : ℚ) / x.den := by
    simpa only [Rat.num_div_den] using h
  have hh := (div_lt_div_iff₀ hy hx).mp hdiv
  have hi : y.num * (x.den : ℤ) < x.num * (y.den : ℤ) := by exact_mod_cast hh
  unfold crossNumerator
  omega

def chordOutput (p q : ℚ × ℚ) (l : ℚ) : RationalPoint :=
  let x := l ^ 2 - p.1 - q.1
  some (x, l * (p.1 - x) - p.2)

def SlopeLocal (d e : ℚ) (f : ℚ → RationalPoint) (gap : ℤ)
    (out : PointCode) (z : RationalCode × ℕ) : Prop :=
  (z.1.Valid ∧ d * z.1.value = e) ∧ out.Represents (f z.1.value) ∧
    gap = 1 + z.2

theorem slope_local_complete (d e : ℚ) (hd : d ≠ 0) (f : ℚ → RationalPoint)
    (gap : ℤ) (hg : 0 < gap) :
    ∃! z : PointCode × (RationalCode × ℕ), SlopeLocal d e f gap z.1 z.2 := by
  obtain ⟨s, hs, hsu⟩ := slope_output_complete d e hd f gap 0 hg
  refine ⟨(s.1.2, s.1.1, s.2), ?_, ?_⟩
  · simpa only [SlopeLocal, zero_add] using hs
  · rintro ⟨out, code, slack⟩ hz
    have hh := hsu ((code, out), slack) (by
      simpa only [SlopeLocal, zero_add] using hz)
    simpa only using congrArg
      (fun z : (RationalCode × PointCode) × ℕ => (z.1.2, z.1.1, z.2)) hh

theorem direct_local_complete (p : RationalPoint) :
    ∃! z : PointCode × PUnit, z.1.Represents p := by
  obtain ⟨c, hc, hcu⟩ := point_code_exists_unique p
  refine ⟨(c, PUnit.unit), hc, ?_⟩
  rintro ⟨d, a⟩ hd
  exact Prod.ext (hcu d hd) (Subsingleton.elim _ _)

def AddAux (i : Fin 7) : Type :=
  match i.val with
  | 2 | 3 | 5 | 6 => RationalCode × ℕ
  | _ => PUnit

def addZero (i : Fin 7) : AddAux i :=
  match i with
  | ⟨0, _⟩ => PUnit.unit
  | ⟨1, _⟩ => PUnit.unit
  | ⟨2, _⟩ => (⟨0, 0, 0, 0, 0, 0⟩, 0)
  | ⟨3, _⟩ => (⟨0, 0, 0, 0, 0, 0⟩, 0)
  | ⟨4, _⟩ => PUnit.unit
  | ⟨5, _⟩ => (⟨0, 0, 0, 0, 0, 0⟩, 0)
  | ⟨6, _⟩ => (⟨0, 0, 0, 0, 0, 0⟩, 0)
  | ⟨n + 7, h⟩ => by omega

def AdditionLocal (p q : RationalPoint) (i : Fin 7) : PointCode → AddAux i → Prop :=
  match i with
  | ⟨0, _⟩ => fun out _ => out.Represents q
  | ⟨1, _⟩ => fun out _ => out.Represents p
  | ⟨2, _⟩ =>
    match p, q with
    | some p, some q =>
      SlopeLocal (q.1 - p.1) (q.2 - p.2) (chordOutput p q) (crossNumerator q.1 p.1)
    | _, _ => fun _ _ => False
  | ⟨3, _⟩ =>
    match p, q with
    | some p, some q =>
      SlopeLocal (q.1 - p.1) (q.2 - p.2) (chordOutput p q) (crossNumerator p.1 q.1)
    | _, _ => fun _ _ => False
  | ⟨4, _⟩ => fun out _ => out.Represents none
  | ⟨5, _⟩ =>
    match p, q with
    | some p, some q =>
      SlopeLocal (2 * p.2) (3 * p.1 ^ 2 - 25) (chordOutput p q) p.2.num
    | _, _ => fun _ _ => False
  | ⟨6, _⟩ =>
    match p, q with
    | some p, some q =>
      SlopeLocal (2 * p.2) (3 * p.1 ^ 2 - 25) (chordOutput p q) (-p.2.num)
    | _, _ => fun _ _ => False
  | ⟨_, _⟩ => fun _ _ => False

theorem addition_complete (p q : RationalPoint) (hp : OnCurve p) (hq : OnCurve q) :
    ∃! z : CaseWitness (Fin 7) PointCode AddAux,
      CaseOK (fun i => AdditionGuard i p q) (AdditionLocal p q) addZero z := by
  apply gated_cases_unique _ _ _ (addition_guards_partition p q hp hq)
  intro i hi
  fin_cases i
  · exact direct_local_complete q
  · exact direct_local_complete p
  · cases p with
    | none => simp [AdditionGuard] at hi
    | some p =>
      cases q with
      | none => simp [AdditionGuard] at hi
      | some q =>
        have hh : p.1 < q.1 := hi
        exact slope_local_complete _ _ (by linarith) _
          _ (crossNumerator_pos q.1 p.1 hh)
  · cases p with
    | none => simp [AdditionGuard] at hi
    | some p =>
      cases q with
      | none => simp [AdditionGuard] at hi
      | some q =>
        have hh : q.1 < p.1 := hi
        exact slope_local_complete _ _ (by linarith) _
          _ (crossNumerator_pos p.1 q.1 hh)
  · exact direct_local_complete none
  · cases p with
    | none => simp [AdditionGuard] at hi
    | some p =>
      cases q with
      | none => simp [AdditionGuard] at hi
      | some q =>
        have hh : 0 < p.2 := hi.2.2
        have hg : 0 < p.2.num := by
          simpa [crossNumerator] using crossNumerator_pos p.2 0 hh
        exact slope_local_complete _ _ (by linarith) _ _ hg
  · cases p with
    | none => simp [AdditionGuard] at hi
    | some p =>
      cases q with
      | none => simp [AdditionGuard] at hi
      | some q =>
        have hh : p.2 < 0 := hi.2.2
        have hg : 0 < -p.2.num := by
          simpa [crossNumerator] using crossNumerator_pos 0 p.2 hh
        exact slope_local_complete _ _ (by linarith) _ _ hg

def Window (w : ℕ → ℕ) (κ k r : ℕ) : Prop :=
  w (2 * k) * w r * w 1 ≤ κ * (w k ^ 2 * w (r + 1)) ∧
    w k ^ 2 * w (r + 1) ≤ κ * (w (2 * k) * w r * w 1)

structure HeightSequence where
  w : ℕ → ℕ
  a : ℝ
  c : ℝ
  κ : ℕ
  zero : w 0 = 1
  pos : ∀ j, 0 < w j
  c_nonneg : 0 ≤ c
  a_large : 2 * c < a
  κ_error : 6 * c < Real.log κ
  separation : Real.log κ < 2 * a - 6 * c
  error : ∀ j, 1 ≤ j → |Real.log (w j) - a * (j : ℝ) ^ 2| ≤ c

namespace HeightSequence

lemma a_pos (S : HeightSequence) : 0 < S.a := by
  have := S.c_nonneg
  have := S.a_large
  linarith

theorem strictMono (S : HeightSequence) : StrictMono S.w := by
  apply strictMono_nat_of_lt_succ
  intro j
  suffices h : Real.log (S.w j) < Real.log (S.w (j + 1)) by
    exact_mod_cast (Real.log_lt_log_iff (by exact_mod_cast S.pos j)
      (by exact_mod_cast S.pos (j + 1))).mp h
  by_cases hj : j = 0
  · subst j
    have h := (abs_le.mp (S.error 1 (by omega))).1
    simp only [S.zero, Nat.cast_one, Real.log_one]
    norm_num at h
    have := S.a_large
    have := S.c_nonneg
    linarith
  · obtain ⟨hl, hu⟩ := abs_le.mp (S.error j (by omega))
    obtain ⟨hl', hu'⟩ := abs_le.mp (S.error (j + 1) (by omega))
    push_cast at hl' hu'
    have ha := S.a_pos
    have hlarge := S.a_large
    have hjr : (1 : ℝ) ≤ j := by exact_mod_cast (show 1 ≤ j by omega)
    nlinarith

theorem neighbor_max (S : HeightSequence) (n : ℤ) (hn : n ≠ 0) :
    max (S.w (n + 1).natAbs) (S.w (n - 1).natAbs) = S.w (n.natAbs + 1) := by
  cases n with
  | ofNat j =>
    change (j : ℤ) ≠ 0 at hn
    have hj : 1 ≤ j := by omega
    have hp : ((j : ℤ) + 1).natAbs = j + 1 := by
      exact (congrArg Int.natAbs (show (j : ℤ) + 1 = ((j + 1 : ℕ) : ℤ) by omega)).trans
        (Int.natAbs_natCast (j + 1))
    have hm : ((j : ℤ) - 1).natAbs = j - 1 := by
      exact (congrArg Int.natAbs (show (j : ℤ) - 1 = ((j - 1 : ℕ) : ℤ) by omega)).trans
        (Int.natAbs_natCast (j - 1))
    change max (S.w ((j : ℤ) + 1).natAbs) (S.w ((j : ℤ) - 1).natAbs) = S.w (j + 1)
    rw [hp, hm]
    exact max_eq_left (S.strictMono.monotone (by omega))
  | negSucc j =>
    have hp : (Int.negSucc j + 1).natAbs = j := by
      rw [show Int.negSucc j + 1 = -(j : ℤ) by omega]
      simp
    have hm : (Int.negSucc j - 1).natAbs = j + 2 := by
      exact (congrArg Int.natAbs (show Int.negSucc j - 1 = -((j + 2 : ℕ) : ℤ) by omega)).trans
        (by simp only [Int.natAbs_neg, Int.natAbs_natCast])
    simp only [hp, hm, Int.natAbs_negSucc]
    exact max_eq_right (S.strictMono.monotone (by omega))

theorem doubled_index (n : ℤ) : (2 * n).natAbs = 2 * n.natAbs := by
  simp [Int.natAbs_mul]

theorem bracket (S : HeightSequence) (u : ℕ) :
    ∃! k : ℕ, 1 ≤ k ∧ S.w k ≤ u + S.w 1 ∧ u + S.w 1 < S.w (k + 1) := by
  have hid : ∀ j, j ≤ S.w j := by
    intro j
    induction j with
    | zero => omega
    | succ j ih =>
      have h := S.strictMono (Nat.lt_succ_self j)
      change S.w j < S.w (j + 1) at h
      omega
  have hex : ∃ j, u + S.w 1 < S.w j := by
    refine ⟨u + S.w 1 + 1, ?_⟩
    have := hid (u + S.w 1 + 1)
    omega
  let s := Nat.find hex
  have hs : u + S.w 1 < S.w s := Nat.find_spec hex
  have hs2 : 2 ≤ s := by
    by_contra h
    have hm := S.strictMono.monotone (show s ≤ 1 by omega)
    omega
  let k := s - 1
  have hks : k + 1 = s := by dsimp [k]; omega
  have hk : 1 ≤ k := by dsimp [k]; omega
  have hl : S.w k ≤ u + S.w 1 := by
    have hm := Nat.find_min hex (show k < s by omega)
    omega
  refine ⟨k, ⟨hk, hl, by simpa [hks] using hs⟩, ?_⟩
  intro l h
  rcases lt_trichotomy l k with hlt | heq | hgt
  · have hm := S.strictMono.monotone (show l + 1 ≤ k by omega)
    omega
  · exact heq
  · have hm := S.strictMono.monotone (show k + 1 ≤ l by omega)
    have hh : u + S.w 1 < S.w (k + 1) := by simpa [hks] using hs
    omega

theorem square_window (S : HeightSequence) (k r : ℕ) (hk : 1 ≤ k) (hr : 1 ≤ r) :
    Window S.w S.κ k r ↔ r = k ^ 2 := by
  have hκ : 0 < S.κ := by
    by_contra h
    have hz : S.κ = 0 := by omega
    have hc := S.c_nonneg
    have he := S.κ_error
    simp only [hz, Nat.cast_zero, Real.log_zero] at he
    linarith
  let L := S.w (2 * k) * S.w r * S.w 1
  let D := S.w k ^ 2 * S.w (r + 1)
  have hL : (0 : ℝ) < L := by
    have h : 0 < L := Nat.mul_pos (Nat.mul_pos (S.pos _) (S.pos _)) (S.pos _)
    exact_mod_cast h
  have hD : (0 : ℝ) < D := by
    have h : 0 < D := Nat.mul_pos (pow_pos (S.pos _) _) (S.pos _)
    exact_mod_cast h
  have hκr : (0 : ℝ) < S.κ := by exact_mod_cast hκ
  have h2kp : (0 : ℝ) < S.w (2 * k) := by exact_mod_cast S.pos (2 * k)
  have hrp : (0 : ℝ) < S.w r := by exact_mod_cast S.pos r
  have h1p : (0 : ℝ) < S.w 1 := by exact_mod_cast S.pos 1
  have hkp : (0 : ℝ) < S.w k := by exact_mod_cast S.pos k
  have hr1p : (0 : ℝ) < S.w (r + 1) := by exact_mod_cast S.pos (r + 1)
  have logL : Real.log (L : ℝ) =
      Real.log (S.w (2 * k)) + Real.log (S.w r) + Real.log (S.w 1) := by
    dsimp [L]
    push_cast
    rw [Real.log_mul (by positivity) (by positivity),
      Real.log_mul (by positivity) (by positivity)]
  have logD : Real.log (D : ℝ) =
      2 * Real.log (S.w k) + Real.log (S.w (r + 1)) := by
    dsimp [D]
    push_cast
    rw [Real.log_mul (by positivity) (by positivity), Real.log_pow]
    norm_num
  have h2k := abs_le.mp (S.error (2 * k) (by omega))
  have hr0 := abs_le.mp (S.error r hr)
  have h1 := abs_le.mp (S.error 1 (by omega))
  have hk0 := abs_le.mp (S.error k hk)
  have hr1 := abs_le.mp (S.error (r + 1) (by omega))
  push_cast at h2k hr1
  norm_num at h1
  have herr :
      |Real.log (L : ℝ) - Real.log (D : ℝ) -
        2 * S.a * ((k : ℝ) ^ 2 - r)| ≤ 6 * S.c := by
    rw [logL, logD]
    apply abs_le.mpr
    constructor <;> nlinarith [h2k.1, h2k.2, hr0.1, hr0.2, h1.1, h1.2,
      hk0.1, hk0.2, hr1.1, hr1.2]
  have hw : Window S.w S.κ k r ↔
      Real.log (L : ℝ) - Real.log (D : ℝ) ≤ Real.log S.κ ∧
      -(Real.log S.κ) ≤ Real.log (L : ℝ) - Real.log (D : ℝ) := by
    unfold Window
    change L ≤ S.κ * D ∧ D ≤ S.κ * L ↔ _
    constructor
    · intro h
      have hleft : Real.log (L : ℝ) ≤ Real.log ((S.κ : ℝ) * D) :=
        Real.log_le_log hL (by exact_mod_cast h.1)
      have hright : Real.log (D : ℝ) ≤ Real.log ((S.κ : ℝ) * L) :=
        Real.log_le_log hD (by exact_mod_cast h.2)
      rw [Real.log_mul hκr.ne' hD.ne'] at hleft
      rw [Real.log_mul hκr.ne' hL.ne'] at hright
      constructor <;> linarith
    · intro h
      have hleft : Real.log (L : ℝ) ≤ Real.log ((S.κ : ℝ) * D) := by
        rw [Real.log_mul hκr.ne' hD.ne']
        linarith
      have hright : Real.log (D : ℝ) ≤ Real.log ((S.κ : ℝ) * L) := by
        rw [Real.log_mul hκr.ne' hL.ne']
        linarith
      constructor
      · exact_mod_cast (Real.log_le_log_iff hL (mul_pos hκr hD)).mp hleft
      · exact_mod_cast (Real.log_le_log_iff hD (mul_pos hκr hL)).mp hright
  rw [hw]
  constructor
  · intro h
    by_contra hne
    obtain hlt | hgt := lt_or_gt_of_ne hne
    · have hgap : (r : ℝ) + 1 ≤ (k : ℝ) ^ 2 := by
        exact_mod_cast (show r + 1 ≤ k ^ 2 by omega)
      have ha := S.a_pos
      have hsep := S.separation
      have he := (abs_le.mp herr).1
      nlinarith
    · have hgap : (k : ℝ) ^ 2 + 1 ≤ (r : ℝ) := by
        exact_mod_cast (show k ^ 2 + 1 ≤ r by omega)
      have ha := S.a_pos
      have hsep := S.separation
      have he := (abs_le.mp herr).2
      nlinarith
  · intro heq
    have hcast : (r : ℝ) = (k : ℝ) ^ 2 := by exact_mod_cast heq
    rw [hcast, sub_self, mul_zero, sub_zero] at herr
    have he := abs_le.mp herr
    have hκe := S.κ_error
    constructor <;> linarith

theorem growth_bounds (S : HeightSequence) :
    ∃ δ : ℝ, 0 < δ ∧ ∃ u₀ : ℕ, 4 ≤ u₀ ∧
      ∀ u k : ℕ, u₀ ≤ u → 1 ≤ k →
        S.w k ≤ u + S.w 1 → u + S.w 1 < S.w (k + 1) →
        δ * Real.log (u : ℝ) ^ 2 < Real.log (S.w (k ^ 2)) ∧
        Real.log (S.w (k ^ 2)) < (u : ℝ) * Real.log u := by
  have ha := S.a_pos
  have hc := S.c_nonneg
  let T := 128 * S.a * S.c + 36 / S.a + 3 * S.c + 4
  have hdiv : 0 < 36 / S.a := div_pos (by norm_num) ha
  have hac : 0 ≤ S.a * S.c := mul_nonneg ha.le hc
  have hT : 1 < T ∧ 2 * S.c < T ∧ 128 * S.a * S.c < T ∧
      36 / S.a + S.c + 1 < T := by
    dsimp [T]
    refine ⟨?_, ?_, ?_, ?_⟩ <;> nlinarith only [hac, hdiv, hc]
  obtain ⟨N, hN⟩ := exists_nat_gt (Real.exp T + (S.w 1 : ℝ) + 4)
  have hN4 : 4 ≤ N := by
    have hp := Real.exp_pos T
    have hw : (0 : ℝ) ≤ S.w 1 := Nat.cast_nonneg _
    exact_mod_cast (show (4 : ℝ) ≤ N by linarith)
  refine ⟨1 / (128 * S.a), by positivity, N, hN4, ?_⟩
  intro u k hu hk hb1 hb2
  have hur : (N : ℝ) ≤ u := by exact_mod_cast hu
  have hu4 : 4 ≤ u := le_trans hN4 hu
  have hup : (0 : ℝ) < u := by exact_mod_cast (show 0 < u by omega)
  have hu1 : (1 : ℝ) ≤ u := by exact_mod_cast (show 1 ≤ u by omega)
  have hwu : (S.w 1 : ℝ) ≤ u := by have := Real.exp_pos T; linarith
  have hLu : T < Real.log (u : ℝ) := by
    rw [← Real.log_exp T]
    apply Real.log_lt_log (Real.exp_pos T)
    have hw : (0 : ℝ) ≤ S.w 1 := Nat.cast_nonneg _
    linarith
  have hLpos : 0 ≤ Real.log (u : ℝ) := by linarith [hT.1]
  have hLone : 1 ≤ Real.log (u : ℝ) := by linarith [hT.1]
  have hUpos : (0 : ℝ) < u + S.w 1 := by positivity
  have hUlo : Real.log (u : ℝ) ≤ Real.log ((u : ℝ) + S.w 1) :=
    Real.log_le_log hup (by have hw : (0 : ℝ) ≤ S.w 1 := Nat.cast_nonneg _; linarith)
  have hUhi : Real.log ((u : ℝ) + S.w 1) ≤ 2 * Real.log u := by
    have hh := Real.log_le_log hUpos (show (u : ℝ) + S.w 1 ≤ 2 * u by linarith)
    rw [Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) hup.ne'] at hh
    have hlog2 := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)
    linarith
  obtain ⟨hkl, hku⟩ := abs_le.mp (S.error k hk)
  obtain ⟨hk1l, hk1u⟩ := abs_le.mp (S.error (k + 1) (by omega))
  push_cast at hk1l hk1u
  have hkpos : (0 : ℝ) < S.w k := by exact_mod_cast S.pos k
  have hlog1 := Real.log_le_log hkpos (show (S.w k : ℝ) ≤ u + S.w 1 by exact_mod_cast hb1)
  have hlog2 := Real.log_lt_log hUpos
    (show (u : ℝ) + S.w 1 < S.w (k + 1) by exact_mod_cast hb2)
  have hkr : (1 : ℝ) ≤ k := by exact_mod_cast hk
  have hupperidx : Real.log (u : ℝ) < 8 * S.a * (k : ℝ) ^ 2 := by
    have hscale : S.a * ((k : ℝ) + 1) ^ 2 ≤ 4 * S.a * (k : ℝ) ^ 2 := by
      have hh : ((k : ℝ) + 1) ^ 2 ≤ 4 * (k : ℝ) ^ 2 := by nlinarith only [hkr]
      nlinarith only [mul_le_mul_of_nonneg_left hh ha.le]
    nlinarith only [hlog2, hUlo, hk1u, hscale, hLu, hT.2.1]
  have hk2 : 1 ≤ k ^ 2 := by nlinarith
  obtain ⟨hgl, hgu⟩ := abs_le.mp (S.error (k ^ 2) hk2)
  push_cast at hgl hgu
  have hsmall : 128 * S.a * S.c ≤ Real.log (u : ℝ) ^ 2 := by
    have hh : Real.log (u : ℝ) ≤ Real.log (u : ℝ) ^ 2 := by nlinarith only [hLone]
    linarith only [hh, hLu, hT.2.2.1]
  have hidxsq : Real.log (u : ℝ) ^ 2 < (8 * S.a * (k : ℝ) ^ 2) ^ 2 :=
    (sq_lt_sq₀ hLpos (by positivity)).mpr hupperidx
  have hgl' := mul_le_mul_of_nonneg_left hgl ha.le
  have hlow : Real.log (u : ℝ) ^ 2 < 128 * S.a * Real.log (S.w (k ^ 2)) := by
    nlinarith only [hidxsq, hgl', hsmall]
  constructor
  · rw [one_div_mul_eq_div]
    exact (div_lt_iff₀ (by positivity : 0 < 128 * S.a)).mpr (by nlinarith only [hlow])
  · have hkbound : S.a * (k : ℝ) ^ 2 ≤ 3 * Real.log (u : ℝ) := by
      nlinarith only [hkl, hlog1, hUhi, hLu, hT.2.1, hLpos]
    have hksq : (S.a * (k : ℝ) ^ 2) ^ 2 ≤ (3 * Real.log (u : ℝ)) ^ 2 :=
      (sq_le_sq₀ (by positivity) (by positivity)).mpr hkbound
    have hsqrt := Real.sqrt_pos.mpr hup
    have hs := Real.log_le_sub_one_of_pos hsqrt
    rw [Real.log_sqrt hup.le] at hs
    have hlogsq : Real.log (u : ℝ) ^ 2 ≤ 4 * u := by
      have hh : Real.log (u : ℝ) ≤ 2 * Real.sqrt u := by linarith only [hs]
      have hh' := (sq_le_sq₀ hLpos (by positivity)).mpr hh
      nlinarith only [hh', Real.sq_sqrt hup.le]
    have hgu' := mul_le_mul_of_nonneg_left hgu ha.le
    have hbound : S.a * Real.log (S.w (k ^ 2)) ≤ 36 * u + S.a * S.c := by
      nlinarith only [hgu', hksq, hlogsq]
    have hscale : 36 / S.a + S.c < Real.log (u : ℝ) := by
      linarith [hT.2.2.2]
    have hh := mul_lt_mul_of_pos_left hscale ha
    have hcancel : S.a * (36 / S.a + S.c) = 36 + S.a * S.c := by
      field_simp
    rw [hcancel] at hh
    have hh' := mul_lt_mul_of_pos_left hh hup
    have hcu := mul_le_mul_of_nonneg_left hu1 hac
    by_contra hnot
    have hneg := mul_le_mul_of_nonneg_left (le_of_not_gt hnot) ha.le
    nlinarith only [hbound, hh', hcu, hneg]

end HeightSequence

structure OrbitGeometry (T : Type) [AddCommGroup T] where
  x : ℤ × T → ℚ
  y : ℤ × T → ℚ
  x_neg : ∀ p, x (-p) = x p
  y_neg : ∀ p, y (-p) = -y p
  x_fibre : ∀ p q, p.1 ≠ 0 → q.1 ≠ 0 → x p = x q → p = q ∨ p = -q
  y_nonzero : ∀ p, p.1 ≠ 0 → y p ≠ 0

namespace OrbitGeometry

variable {T : Type} [AddCommGroup T] (G : OrbitGeometry T)

def Maximal (p : ℤ × T) : Prop := ∀ t : T, G.x (p.1, t) ≤ G.x p

def Representative (p : ℤ × T) : Prop :=
  p.1 ≠ 0 ∧ 0 ≤ G.y p ∧ G.Maximal p

lemma maximal_neg (p : ℤ × T) (hp : G.Maximal p) : G.Maximal (-p) := by
  intro t
  have h := hp (-t)
  have hx := G.x_neg (p.1, -t)
  simp only [Prod.neg_mk, neg_neg] at hx
  rw [G.x_neg]
  change G.x (-p.1, t) ≤ G.x p
  rw [hx]
  exact h

lemma same_index_unique (p q : ℤ × T) (hn : p.1 ≠ 0) (hnq : q.1 = p.1)
    (hp : G.Maximal p) (hq : G.Maximal q) : p = q := by
  have hx1 := hp q.2
  have hx2 := hq p.2
  have he : G.x p = G.x q := by
    rw [hnq] at hx2
    have hqpair : (p.1, q.2) = q := Prod.ext hnq.symm rfl
    rw [hqpair] at hx1
    simpa using le_antisymm hx2 hx1
  rcases G.x_fibre p q hn (by simpa [hnq] using hn) he with h | h
  · exact h
  · have hh := congrArg Prod.fst h
    simp only [Prod.fst_neg, hnq] at hh
    exact False.elim (hn (by omega))

lemma representative_unique (p q : ℤ × T) (hp : G.Representative p)
    (hq : G.Representative q) (ha : p.1.natAbs = q.1.natAbs) : p = q := by
  rcases Int.natAbs_eq_natAbs_iff.mp ha with h | h
  · exact G.same_index_unique p q hp.1 h.symm hp.2.2 hq.2.2
  · have he : p = -q := G.same_index_unique p (-q) hp.1 h.symm
      hp.2.2 (G.maximal_neg q hq.2.2)
    have hy : G.y p = -G.y q := by rw [he, G.y_neg]
    have hzero : G.y q = 0 := by have := hp.2.1; have := hq.2.1; linarith
    exact False.elim (G.y_nonzero q hq.1 hzero)

theorem representatives [Fintype T] (j : ℕ) (hj : 1 ≤ j) :
    ∃! p : ℤ × T, G.Representative p ∧ p.1.natAbs = j := by
  classical
  obtain ⟨t, _, ht⟩ := Finset.exists_max_image (Finset.univ : Finset T)
    (fun t => G.x (j, t)) (by simp)
  let p : ℤ × T := (j, t)
  have hn : p.1 ≠ 0 := by dsimp [p]; exact_mod_cast (show j ≠ 0 by omega)
  have hm : G.Maximal p := by intro s; exact ht s (Finset.mem_univ _)
  have he : p.1.natAbs = j := by simp [p]
  have hex : ∃ q, G.Representative q ∧ q.1.natAbs = j := by
    by_cases hy : 0 ≤ G.y p
    · exact ⟨p, ⟨hn, hy, hm⟩, he⟩
    · refine ⟨-p, ⟨?_, ?_, G.maximal_neg p hm⟩, ?_⟩
      · simpa using hn
      · rw [G.y_neg]; linarith
      · simpa using he
  obtain ⟨p, hp⟩ := hex
  refine ⟨p, hp, ?_⟩
  intro q hq
  exact G.representative_unique q p hq.1 hp.1 (hq.2.trans hp.2.symm)

end OrbitGeometry

@[ext]
structure GrowthWitness (T : Type) where
  value : ℕ
  first : ℤ × T
  second : ℤ × T

def GrowthOK {T : Type} [AddCommGroup T] (S : HeightSequence) (G : OrbitGeometry T)
    (u : ℕ) (z : GrowthWitness T) : Prop :=
  G.Representative z.first ∧ G.Representative z.second ∧
    S.w z.first.1.natAbs ≤ u + S.w 1 ∧
    u + S.w 1 < S.w (z.first.1.natAbs + 1) ∧
    Window S.w S.κ z.first.1.natAbs z.second.1.natAbs ∧
    z.value = S.w z.second.1.natAbs

theorem growth_core_unique {T : Type} [AddCommGroup T] [Fintype T]
    (S : HeightSequence) (G : OrbitGeometry T) (u : ℕ) :
    ∃! z : GrowthWitness T, GrowthOK S G u z := by
  obtain ⟨k, hk, hku⟩ := S.bracket u
  obtain ⟨p, hp, _⟩ := G.representatives k hk.1
  have hk2 : 1 ≤ k ^ 2 := by nlinarith only [hk.1]
  obtain ⟨q, hq, _⟩ := G.representatives (k ^ 2) hk2
  let z : GrowthWitness T := ⟨S.w (k ^ 2), p, q⟩
  have hz : GrowthOK S G u z := by
    refine ⟨hp.1, hq.1, ?_, ?_, ?_, ?_⟩
    · change S.w p.1.natAbs ≤ u + S.w 1
      simpa only [hp.2] using hk.2.1
    · change u + S.w 1 < S.w (p.1.natAbs + 1)
      simpa only [hp.2] using hk.2.2
    · change Window S.w S.κ p.1.natAbs q.1.natAbs
      rw [hp.2, hq.2]
      exact (S.square_window k (k ^ 2) hk.1 hk2).mpr rfl
    · change S.w (k ^ 2) = S.w q.1.natAbs
      rw [hq.2]
  refine ⟨z, hz, ?_⟩
  intro w hw
  have hwp : 1 ≤ w.first.1.natAbs :=
    Int.natAbs_pos.mpr hw.1.1
  have hwq : 1 ≤ w.second.1.natAbs :=
    Int.natAbs_pos.mpr hw.2.1.1
  have hfirst : w.first.1.natAbs = k :=
    hku _ ⟨hwp, hw.2.2.1, hw.2.2.2.1⟩
  have hsecond : w.second.1.natAbs = k ^ 2 := by
    have hh := (S.square_window _ _ hwp hwq).mp hw.2.2.2.2.1
    simpa only [hfirst] using hh
  have hp' : w.first = p :=
    G.representative_unique _ _ hw.1 hp.1 (hfirst.trans hp.2.symm)
  have hq' : w.second = q :=
    G.representative_unique _ _ hw.2.1 hq.1 (hsecond.trans hq.2.symm)
  apply GrowthWitness.ext
  · change w.value = S.w (k ^ 2)
    rw [hw.2.2.2.2.2, hsecond]
  · exact hp'
  · exact hq'

inductive Chain {X A : Type} (R : X → X → A → Prop) :
    ℕ → X → X → List (X × A) → Prop
  | nil (x : X) : Chain R 0 x x []
  | cons {n : ℕ} {x y z : X} {a : A} {t : List (X × A)} :
      R x y a → Chain R n y z t → Chain R (n + 1) x z ((y, a) :: t)

theorem fixed_chain_complete {X A : Type} (R : X → X → A → Prop)
    (hR : ∀ x, ∃! p : X × A, R x p.1 p.2) (n : ℕ) (x : X) :
    ∃! p : X × List (X × A), Chain R n x p.1 p.2 := by
  induction n generalizing x with
  | zero =>
    refine ⟨(x, []), Chain.nil x, ?_⟩
    rintro ⟨y, t⟩ h
    cases h
    rfl
  | succ n ih =>
    obtain ⟨p, hp, hpu⟩ := hR x
    obtain ⟨q, hq, hqu⟩ := ih p.1
    refine ⟨(q.1, p :: q.2), Chain.cons hp hq, ?_⟩
    rintro ⟨y, t⟩ h
    cases h with
    | @cons n' x' y' z' a' t' hxy htail =>
      have hfirst : (y', a') = p := hpu (y', a') hxy
      have hfirst' : y' = p.1 := congrArg Prod.fst hfirst
      have htail' : Chain R n p.1 y t' := by simpa only [hfirst'] using htail
      have hrest : (y, t') = q := hqu (y, t') htail'
      have hfinal := congrArg (fun z : X × List (X × A) => (z.1, p :: z.2)) hrest
      simpa only [hfirst] using hfinal

structure GrowthCall (A : Type) where
  rel : ℕ → ℕ → A → Prop
  unique : ∀ u, ∃! z : ℕ × A, rel u z.1 z.2
  δ : ℝ
  δ_pos : 0 < δ
  u₀ : ℕ
  u₀_ge : 4 ≤ u₀
  bounds : ∀ u v a, rel u v a → u₀ ≤ u →
    δ * Real.log (u : ℝ) ^ 2 < Real.log v ∧
      Real.log (v : ℝ) < (u : ℝ) * Real.log u

def GrowthCall.project {X A : Type} (C : GrowthCall (X × A)) : GrowthCall A where
  rel u v a := ∃ x, C.rel u v (x, a)
  unique u := by
    obtain ⟨⟨v, x, a⟩, hz, hzu⟩ := C.unique u
    refine ⟨(v, a), ⟨x, hz⟩, ?_⟩
    rintro ⟨w, b⟩ ⟨y, hy⟩
    have he := hzu (w, y, b) hy
    have hv : w = v := congrArg Prod.fst he
    have ha : b = a := congrArg (fun z : ℕ × (X × A) => z.2.2) he
    exact Prod.ext hv ha
  δ := C.δ
  δ_pos := C.δ_pos
  u₀ := C.u₀
  u₀_ge := C.u₀_ge
  bounds u v a hz hu := by
    obtain ⟨x, hx⟩ := hz
    exact C.bounds u v (x, a) hx hu

theorem growth_call_exists {T B : Type} [AddCommGroup T] [Fintype T]
    (S : HeightSequence) (G : OrbitGeometry T)
    (E : ℕ → GrowthWitness T → B → Prop)
    (hE : ∀ u z, GrowthOK S G u z → ∃! b, E u z b) :
    ∃ C : GrowthCall (GrowthWitness T × B), ∀ u v z,
      C.rel u v z ↔ GrowthOK S G u z.1 ∧ E u z.1 z.2 ∧ v = z.1.value := by
  obtain ⟨δ, hδ, u₀, hu₀, hb⟩ := S.growth_bounds
  let R : ℕ → ℕ → (GrowthWitness T × B) → Prop :=
    fun u v z => GrowthOK S G u z.1 ∧ E u z.1 z.2 ∧ v = z.1.value
  have hR : ∀ u, ∃! p : ℕ × (GrowthWitness T × B), R u p.1 p.2 := by
    intro u
    obtain ⟨z, hz, hzu⟩ := unique_expansion (GrowthOK S G u) (E u)
      (growth_core_unique S G u) (hE u)
    refine ⟨(z.1.value, z), ⟨hz.1, hz.2, rfl⟩, ?_⟩
    intro p hp
    have hzz : p.2 = z := hzu _ ⟨hp.1, hp.2.1⟩
    apply Prod.ext
    · simpa only [hzz] using hp.2.2
    · exact hzz
  refine ⟨⟨R, hR, δ, hδ, u₀, hu₀, ?_⟩, by intros; rfl⟩
  intro u v z hz hu
  have hk : 1 ≤ z.1.first.1.natAbs := Int.natAbs_pos.mpr hz.1.1.1
  have hr : 1 ≤ z.1.second.1.natAbs := Int.natAbs_pos.mpr hz.1.2.1.1
  have hs := (S.square_window _ _ hk hr).mp hz.1.2.2.2.2.1
  have hv : v = S.w (z.1.first.1.natAbs ^ 2) := by
    rw [hz.2.2, hz.1.2.2.2.2.2, hs]
  rw [hv]
  exact hb u _ hu hk hz.1.2.2.1 hz.1.2.2.2.1

namespace PellTransfer

lemma coordinate_bounds {a : ℕ} (ha : 1 < a) (n : ℕ) :
    (a - 1) * Pell.yn ha (n + 1) ≤ Pell.xn ha (n + 1) ∧
      Pell.xn ha (n + 1) ≤ a * Pell.yn ha (n + 1) := by
  have hA : a - 1 + 1 = a := by omega
  have hD : a * a - 1 + 1 = a * a :=
    Nat.sub_add_cancel (by nlinarith only [ha])
  let x := Pell.xn ha n
  let y := Pell.yn ha n
  have hAy := congrArg (fun z : ℕ => z * (x + a * y)) hA
  have hDy := congrArg (fun z : ℕ => z * y) hD
  change (a - 1) * (x + y * a) ≤ x * a + (a * a - 1) * y ∧
    x * a + (a * a - 1) * y ≤ a * (x + y * a)
  constructor
  · nlinarith only [hAy, hDy, Nat.zero_le x, Nat.zero_le ((a - 1) * y)]
  · nlinarith only [hDy, Nat.zero_le y]

theorem size_bounds {a : ℕ} (ha : 1 < a) (n : ℕ) :
    (2 * a - 1) ^ n ≤ Pell.yn ha (n + 1) ∧
      Pell.yn ha (n + 1) ≤ (2 * a) ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
    have hc := coordinate_bounds ha n
    have hstep : (2 * a - 1) * Pell.yn ha (n + 1) ≤ Pell.yn ha (n + 2) ∧
        Pell.yn ha (n + 2) ≤ 2 * a * Pell.yn ha (n + 1) := by
      have hA : 2 * a - 1 = (a - 1) + a := by omega
      have hnext := Pell.yn_succ ha (n + 1)
      change Pell.yn ha (n + 2) = Pell.xn ha (n + 1) + Pell.yn ha (n + 1) * a at hnext
      rw [hA, hnext]
      constructor <;> nlinarith only [hc.1, hc.2]
    constructor
    · calc
        (2 * a - 1) ^ (n + 1) = (2 * a - 1) * (2 * a - 1) ^ n := by ring
        _ ≤ (2 * a - 1) * Pell.yn ha (n + 1) := Nat.mul_le_mul_left _ ih.1
        _ ≤ Pell.yn ha (n + 1 + 1) := by simpa [Nat.add_assoc] using hstep.1
    · calc
        Pell.yn ha (n + 1 + 1) ≤ 2 * a * Pell.yn ha (n + 1) := by
          simpa [Nat.add_assoc] using hstep.2
        _ ≤ 2 * a * (2 * a) ^ n := Nat.mul_le_mul_left _ ih.2
        _ = (2 * a) ^ (n + 1) := by ring

theorem paired_lower {b u : ℕ} (hb : 1 < b) (hu : 1 < u) (n : ℕ) :
    b ^ (n + 1) * Pell.xn hu (n + 1) ≤
        Pell.xn (a := b * u) (by nlinarith) (n + 1) ∧
      b ^ n * Pell.yn hu (n + 1) ≤
        Pell.yn (a := b * u) (by nlinarith) (n + 1) := by
  have hbu : 1 < b * u := by nlinarith
  have hD : b ^ 2 * (u * u - 1) ≤ (b * u) * (b * u) - 1 := by
    have h1 : u * u - 1 + 1 = u * u :=
      Nat.sub_add_cancel (by nlinarith only [hu])
    have h2 : (b * u) * (b * u) - 1 + 1 = (b * u) * (b * u) := by
      have : 1 ≤ (b * u) * (b * u) := by nlinarith
      omega
    have h3 := congrArg (fun z : ℕ => b ^ 2 * z) h1
    nlinarith only [h2, h3, show 1 ≤ b ^ 2 by nlinarith only [hb]]
  induction n with
  | zero => simp
  | succ n ih =>
    constructor
    · calc
        b ^ (n + 1 + 1) * Pell.xn hu (n + 1 + 1) =
            (b ^ (n + 1) * Pell.xn hu (n + 1)) * (b * u) +
            (b ^ 2 * (u * u - 1)) * (b ^ n * Pell.yn hu (n + 1)) := by
          rw [Pell.xn_succ]
          change b ^ (n + 1 + 1) *
            (Pell.xn hu (n + 1) * u + (u * u - 1) * Pell.yn hu (n + 1)) = _
          ring
        _ ≤ Pell.xn hbu (n + 1) * (b * u) +
            ((b * u) * (b * u) - 1) * Pell.yn hbu (n + 1) :=
          add_le_add (Nat.mul_le_mul_right _ ih.1) (Nat.mul_le_mul hD ih.2)
        _ = Pell.xn hbu (n + 1 + 1) := rfl
    · calc
        b ^ (n + 1) * Pell.yn hu (n + 1 + 1) =
            b ^ (n + 1) * Pell.xn hu (n + 1) +
            (b ^ n * Pell.yn hu (n + 1)) * (b * u) := by
          rw [Pell.yn_succ]
          ring
        _ ≤ Pell.xn hbu (n + 1) + Pell.yn hbu (n + 1) * (b * u) :=
          add_le_add ih.1 (Nat.mul_le_mul_right _ ih.2)
        _ = Pell.yn hbu (n + 1 + 1) := rfl

theorem paired_ratio {b u : ℕ} (hb : 1 < b) (hu : 1 < u) (n : ℕ) :
    b ^ n * Pell.yn hu (n + 1) ≤
        Pell.yn (a := b * u) (by nlinarith) (n + 1) ∧
      (2 * u - 1) ^ n * Pell.yn (a := b * u) (by nlinarith) (n + 1) ≤
        (b ^ n * (2 * u) ^ n) * Pell.yn hu (n + 1) := by
  have hbu : 1 < b * u := by nlinarith
  refine ⟨(paired_lower hb hu n).2, ?_⟩
  calc
    (2 * u - 1) ^ n * Pell.yn hbu (n + 1) ≤
        (2 * u - 1) ^ n * (2 * (b * u)) ^ n :=
      Nat.mul_le_mul_left _ (size_bounds hbu n).2
    _ = (b ^ n * (2 * u) ^ n) * (2 * u - 1) ^ n := by ring
    _ ≤ (b ^ n * (2 * u) ^ n) * Pell.yn hu (n + 1) :=
      Nat.mul_le_mul_left _ (size_bounds hu n).1

lemma power_gap (s n : ℕ) (hn : n ≤ s) :
    (s - n) * (s + 1) ^ n ≤ s ^ (n + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    have hn' : n ≤ s := by omega
    have he : s - n = s - (n + 1) + 1 := by omega
    have he' : s - n + n = s := by omega
    have hf : (s - (n + 1)) * (s + 1) ≤ s * (s - n) := by
      nlinarith only [he, he', Nat.zero_le n]
    calc
      (s - (n + 1)) * (s + 1) ^ (n + 1) =
          ((s - (n + 1)) * (s + 1)) * (s + 1) ^ n := by ring
      _ ≤ (s * (s - n)) * (s + 1) ^ n := Nat.mul_le_mul_right _ hf
      _ = s * ((s - n) * (s + 1) ^ n) := by ring
      _ ≤ s * s ^ (n + 1) := Nat.mul_le_mul_left _ (ih hn')
      _ = s ^ (n + 1 + 1) := by ring

theorem quotient_window {b u n : ℕ} (hb : 1 < b) (hu : 1 < u)
    (hn : n ≤ 2 * u - 1) (hsmall : b ^ n * n < 2 * u - 1 - n) :
    b ^ n * Pell.yn hu (n + 1) ≤ Pell.yn (a := b * u) (by nlinarith) (n + 1) ∧
      Pell.yn (a := b * u) (by nlinarith) (n + 1) <
        (b ^ n + 1) * Pell.yn hu (n + 1) := by
  have hbu : 1 < b * u := by nlinarith
  let F := Pell.yn hbu (n + 1)
  let H := Pell.yn hu (n + 1)
  let s := 2 * u - 1
  have hlo : b ^ n * H ≤ F := (paired_lower hb hu n).2
  have hs : s + 1 = 2 * u := by dsimp [s]; omega
  have hF : F ≤ b ^ n * (s + 1) ^ n := by
    have hh := (size_bounds hbu n).2
    have he : (2 * (b * u)) ^ n = b ^ n * (s + 1) ^ n := by rw [hs]; ring
    exact hh.trans_eq he
  have hH : s ^ n ≤ H := (size_bounds hu n).1
  have hbound : (s - n) * F ≤ b ^ n * s * H := by
    calc
      (s - n) * F ≤ (s - n) * (b ^ n * (s + 1) ^ n) := Nat.mul_le_mul_left _ hF
      _ = b ^ n * ((s - n) * (s + 1) ^ n) := by ring
      _ ≤ b ^ n * s ^ (n + 1) := Nat.mul_le_mul_left _ (power_gap s n hn)
      _ = b ^ n * s * s ^ n := by ring
      _ ≤ b ^ n * s * H := Nat.mul_le_mul_left _ hH
  have hHpos : 0 < H := by
    have hh := Pell.yn_ge_n hu (n + 1)
    change 0 < Pell.yn hu (n + 1)
    omega
  refine ⟨hlo, ?_⟩
  by_contra hnot
  have hh : (b ^ n + 1) * H ≤ F := le_of_not_gt hnot
  have hh' := Nat.mul_le_mul_left (s - n) hh
  have hsmall' := Nat.mul_lt_mul_of_pos_right hsmall hHpos
  have he : s - n + n = s := Nat.sub_add_cancel hn
  have he' := congrArg (fun z : ℕ => b ^ n * z * H) he
  nlinarith only [hbound, hh', hsmall', he']

theorem index_cutoff (u : ℕ) (hu : 4 ≤ u) :
    u ^ u < (2 * u - 1) ^ (u - 1) := by
  have hseven : ∀ t : ℕ, (t + 4) * 4 ^ (t + 3) < 7 ^ (t + 3) := by
    intro t
    induction t with
    | zero => norm_num
    | succ t ih =>
      have hh := Nat.mul_lt_mul_of_pos_left ih (by norm_num : 0 < 7)
      have hscale : (t + 5) * 4 ≤ 7 * (t + 4) := by omega
      have hm := Nat.mul_le_mul_right (4 ^ (t + 3)) hscale
      calc
        (t + 1 + 4) * 4 ^ (t + 1 + 3) = (t + 5) * 4 * 4 ^ (t + 3) := by ring
        _ ≤ 7 * ((t + 4) * 4 ^ (t + 3)) := by nlinarith only [hm]
        _ < 7 * 7 ^ (t + 3) := hh
        _ = 7 ^ (t + 1 + 3) := by ring
  have hcoeff : u * 4 ^ (u - 1) < 7 ^ (u - 1) := by
    have hh := hseven (u - 4)
    have he : u - 4 + 4 = u := by omega
    have he' : u - 4 + 3 = u - 1 := by omega
    simpa only [he, he'] using hh
  have hbase : 7 * u ≤ 4 * (2 * u - 1) := by
    have hs : 2 * u - 1 + 1 = 2 * u := by omega
    nlinarith only [hs, hu]
  have hp := Nat.pow_le_pow_left hbase (u - 1)
  have hmul := Nat.mul_lt_mul_of_pos_right hcoeff
    (pow_pos (show 0 < u by omega) (u - 1))
  have hexp : u - 1 + 1 = u := by omega
  have hupow : u ^ u = u ^ (u - 1) * u :=
    (congrArg (fun e : ℕ => u ^ e) hexp).symm.trans (pow_succ u (u - 1))
  have hpow : 4 ^ (u - 1) * u ^ u <
      4 ^ (u - 1) * (2 * u - 1) ^ (u - 1) := by
    calc
      4 ^ (u - 1) * u ^ u =
          (u * 4 ^ (u - 1)) * u ^ (u - 1) := by
        rw [hupow]
        ring
      _ < 7 ^ (u - 1) * u ^ (u - 1) := hmul
      _ = (7 * u) ^ (u - 1) := by rw [mul_pow]
      _ ≤ (4 * (2 * u - 1)) ^ (u - 1) := hp
      _ = 4 ^ (u - 1) * (2 * u - 1) ^ (u - 1) := by rw [mul_pow]
  exact Nat.lt_of_mul_lt_mul_left hpow

theorem pin_index {a u v y n : ℕ} (ha : 1 < a) (hu : 4 ≤ u)
    (hau : u ≤ a) (hn : n + 1 < u - 1) (hy : 0 < y)
    (hcut : y < v) (hv : v < u ^ u)
    (hsol : ∃ i, y = Pell.yn ha i)
    (hres : ∃ q, y = n + 1 + (a - 1) * q) :
    y = Pell.yn ha (n + 1) := by
  obtain ⟨i, hi⟩ := hsol
  have hi0 : 1 ≤ i := by
    by_contra h
    have : i = 0 := by omega
    simp only [this, Pell.yn_zero] at hi
    omega
  have hiu : i < u := by
    by_contra h
    have hiu' : u - 1 ≤ i - 1 := by omega
    have hi1 : i - 1 + 1 = i := by omega
    have hb := (size_bounds ha (i - 1)).1
    rw [hi1] at hb
    have hbase : 2 * u - 1 ≤ 2 * a - 1 := by omega
    have hp := (Nat.pow_le_pow_left hbase (u - 1)).trans
      (Nat.pow_le_pow_right (by omega : 0 < 2 * a - 1) hiu')
    have huc := index_cutoff u hu
    omega
  have hmod := Pell.yn_modEq_a_sub_one ha i
  obtain ⟨q, hq⟩ := hres
  have hresmod : y ≡ n + 1 [MOD a - 1] := by
    change y % (a - 1) = (n + 1) % (a - 1)
    rw [hq]
    simp [Nat.add_mod]
  have himod : i ≡ n + 1 [MOD a - 1] := by
    rw [hi] at hresmod
    exact hmod.symm.trans hresmod
  have hnmod : n + 1 < a - 1 := by omega
  have hia : i < a - 1 := by
    by_contra h
    have hieq : i = a - 1 := by omega
    have hh := himod
    change i % (a - 1) = (n + 1) % (a - 1) at hh
    rw [hieq, Nat.mod_self, Nat.mod_eq_of_lt hnmod] at hh
    omega
  have hieq := himod.eq_of_lt_of_lt hia hnmod
  simpa only [hieq] using hi

def scale (u₀ ℓ b n c : ℕ) : ℕ :=
  (c + 1) ^ ℓ * (n + 1) * (b + 1) + u₀

theorem scale_lower (u₀ ℓ b n c : ℕ) (hu₀ : 4 ≤ u₀) (hℓ : 1 ≤ ℓ) :
    (c + 1) * (n + 1) + 4 ≤ scale u₀ ℓ b n c ∧
      b < scale u₀ ℓ b n c ∧
      (c + 1) ^ ℓ ≤ scale u₀ ℓ b n c := by
  have hp : c + 1 ≤ (c + 1) ^ ℓ := by
    have hh := Nat.pow_le_pow_right (by omega : 0 < c + 1) hℓ
    simpa using hh
  have hpn := Nat.mul_le_mul_right (n + 1) hp
  have hp0 : 1 ≤ (c + 1) ^ ℓ := by
    have hh : 0 < (c + 1) ^ ℓ := by positivity
    omega
  have hn0 : 1 ≤ n + 1 := by omega
  have hprod : 1 ≤ (c + 1) ^ ℓ * (n + 1) := by nlinarith only [hp0, hn0]
  have hprod' := Nat.mul_le_mul_right (b + 1) hprod
  have htimes := Nat.mul_le_mul_left ((c + 1) ^ ℓ * (n + 1))
    (show 1 ≤ b + 1 by omega)
  have hnprod := Nat.mul_le_mul_left ((c + 1) ^ ℓ) hn0
  unfold scale
  constructor
  · nlinarith only [hpn, htimes, hu₀]
  constructor
  · nlinarith only [hprod', hu₀]
  · nlinarith only [hnprod, htimes]

theorem growth_upper {A : Type} (C : GrowthCall A) (u v : ℕ) (a : A)
    (h : C.rel u v a) (hu : C.u₀ ≤ u) : v < u ^ u := by
  have hup : (0 : ℝ) < u := by exact_mod_cast (show 0 < u by have := C.u₀_ge; omega)
  have hvp : (0 : ℝ) < v := by
    by_contra hnot
    have hv0 : v = 0 := by
      exact_mod_cast (show (v : ℝ) = 0 by
        have hh := Nat.cast_nonneg (α := ℝ) v
        linarith)
    have hh := (C.bounds u v a h hu).1
    rw [hv0, Nat.cast_zero, Real.log_zero] at hh
    have : 0 ≤ C.δ * Real.log (u : ℝ) ^ 2 := mul_nonneg C.δ_pos.le (sq_nonneg _)
    linarith
  have hh := (C.bounds u v a h hu).2
  have hpow : Real.log ((u ^ u : ℕ) : ℝ) = (u : ℝ) * Real.log u := by
    rw [Nat.cast_pow, Real.log_pow]
  rw [← hpow] at hh
  have hnpow : 0 < u ^ u := pow_pos (by exact_mod_cast hup) u
  exact_mod_cast (Real.log_lt_log_iff hvp (by exact_mod_cast hnpow)).mp hh

theorem choose_exponent {A : Type} (C : GrowthCall A) :
    ∃ ℓ : ℕ, 1 ≤ ℓ ∧ 3 < C.δ * ℓ * Real.log 2 := by
  have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hp : 0 < C.δ * Real.log 2 := mul_pos C.δ_pos hlog2
  obtain ⟨ℓ, hℓ⟩ := exists_nat_gt (3 / (C.δ * Real.log 2) + 1)
  have hfrac : 0 < 3 / (C.δ * Real.log 2) := div_pos (by norm_num) hp
  have hℓpos : 1 ≤ ℓ := by exact_mod_cast (show (1 : ℝ) ≤ ℓ by linarith)
  refine ⟨ℓ, hℓpos, ?_⟩
  have hh : 3 / (C.δ * Real.log 2) < (ℓ : ℝ) := by linarith
  have hh' := (div_lt_iff₀ hp).mp hh
  nlinarith only [hh']

theorem growth_lower {A : Type} (C : GrowthCall A) (ℓ : ℕ)
    (hℓ : 1 ≤ ℓ) (hlarge : 3 < C.δ * ℓ * Real.log 2)
    (b n v : ℕ) (a : A) (hb : 1 < b)
    (h : C.rel (scale C.u₀ ℓ b n (b ^ n)) v a) :
    Pell.yn (a := b * scale C.u₀ ℓ b n (b ^ n)) (by
        have hs := (scale_lower C.u₀ ℓ b n (b ^ n) C.u₀_ge hℓ).2.1
        have hu : 1 < scale C.u₀ ℓ b n (b ^ n) := lt_trans hb hs
        nlinarith only [hb, hu]) (n + 1) < v ∧
      Pell.yn (a := scale C.u₀ ℓ b n (b ^ n)) (by
        have hs := (scale_lower C.u₀ ℓ b n (b ^ n) C.u₀_ge hℓ).2.1
        exact lt_trans hb hs) (n + 1) < v := by
  let u := scale C.u₀ ℓ b n (b ^ n)
  have hs := scale_lower C.u₀ ℓ b n (b ^ n) C.u₀_ge hℓ
  have hu₀ : C.u₀ ≤ u := by dsimp [u, scale]; omega
  have hu4 : 4 ≤ u := le_trans C.u₀_ge hu₀
  have hu : 1 < u := by omega
  have hbu : 1 < b * u := by nlinarith only [hb, hu]
  have hup : (0 : ℝ) < u := by exact_mod_cast (show 0 < u by omega)
  have hbp : (0 : ℝ) < b := by exact_mod_cast (show 0 < b by omega)
  have hLu : 0 < Real.log (u : ℝ) := Real.log_pos (by exact_mod_cast hu)
  have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hℓr : (0 : ℝ) < ℓ := by exact_mod_cast (show 0 < ℓ by omega)
  have hpow : (b ^ n) ^ ℓ ≤ u :=
    (Nat.pow_le_pow_left (Nat.le_succ (b ^ n)) ℓ).trans hs.2.2
  have hpowp : (0 : ℝ) < ((b ^ n) ^ ℓ : ℕ) := by positivity
  have hlogpow := Real.log_le_log hpowp (show (((b ^ n) ^ ℓ : ℕ) : ℝ) ≤ u by
    exact_mod_cast hpow)
  have hlogpowval : Real.log (((b ^ n) ^ ℓ : ℕ) : ℝ) =
      (ℓ : ℝ) * n * Real.log b := by
    push_cast
    rw [Real.log_pow, Real.log_pow]
    ring
  rw [hlogpowval] at hlogpow
  have hblog : Real.log 2 ≤ Real.log (b : ℝ) :=
    Real.log_le_log (by norm_num) (by exact_mod_cast (show 2 ≤ b by omega))
  have hln := mul_le_mul_of_nonneg_left hblog
    (show 0 ≤ (ℓ : ℝ) * n by positivity)
  have hlogidx : (ℓ : ℝ) * n * Real.log 2 ≤ Real.log (u : ℝ) := le_trans hln hlogpow
  have hupper : 3 * n * Real.log (u : ℝ) < C.δ * Real.log (u : ℝ) ^ 2 := by
    have h1 := mul_le_mul_of_nonneg_right hlogidx (show 0 ≤ 3 * Real.log (u : ℝ) by positivity)
    have h2 := mul_lt_mul_of_pos_right hlarge (sq_pos_of_pos hLu)
    by_contra hn
    have h3 := mul_le_mul_of_nonneg_left (le_of_not_gt hn)
      (show 0 ≤ (ℓ : ℝ) * Real.log 2 by positivity)
    nlinarith only [h1, h2, h3]
  have hblogu : Real.log (b : ℝ) ≤ Real.log (u : ℝ) :=
    Real.log_le_log hbp (by exact_mod_cast hs.2.1.le)
  have h2logu : Real.log 2 ≤ Real.log (u : ℝ) :=
    Real.log_le_log (by norm_num) (by exact_mod_cast (show 2 ≤ u by omega))
  have hbase : Real.log ((2 * (b * u) : ℕ) : ℝ) ≤ 3 * Real.log (u : ℝ) := by
    push_cast
    rw [Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) (mul_ne_zero hbp.ne' hup.ne'),
      Real.log_mul hbp.ne' hup.ne']
    linarith only [hblogu, h2logu]
  have hbase' := mul_le_mul_of_nonneg_left hbase (Nat.cast_nonneg (α := ℝ) n)
  have hvlower := (C.bounds u v a h hu₀).1
  have hvp : (0 : ℝ) < v := by
    by_contra hn
    have hv0 : v = 0 := by
      exact_mod_cast (show (v : ℝ) = 0 by have := Nat.cast_nonneg (α := ℝ) v; linarith)
    rw [hv0, Nat.cast_zero, Real.log_zero] at hvlower
    have hp : 0 < C.δ * Real.log (u : ℝ) ^ 2 := mul_pos C.δ_pos (sq_pos_of_pos hLu)
    linarith
  have hcoord : ∀ y : ℕ, 0 < y → y ≤ (2 * (b * u)) ^ n → y < v := by
    intro y hyp hy
    have hlogy := Real.log_le_log (show (0 : ℝ) < y by exact_mod_cast hyp)
      (show (y : ℝ) ≤ ((2 * (b * u)) ^ n : ℕ) by exact_mod_cast hy)
    rw [Nat.cast_pow, Real.log_pow] at hlogy
    have hh : Real.log (y : ℝ) < Real.log (v : ℝ) := by
      linarith only [hlogy, hbase', hupper, hvlower]
    exact_mod_cast (Real.log_lt_log_iff (by exact_mod_cast hyp) hvp).mp hh
  constructor
  · apply hcoord
    · have hp := Pell.yn_ge_n hbu (n + 1)
      omega
    · exact (size_bounds hbu n).2
  · apply hcoord
    · have hp := Pell.yn_ge_n hu (n + 1)
      omega
    · exact (size_bounds hu n).2.trans
        (Nat.pow_le_pow_left (by nlinarith only [hb, hu]) n)

@[ext]
structure PowerWitness (A : Type) where
  c : ℕ
  u : ℕ
  v : ℕ
  X : ℕ
  Y : ℕ
  F : ℕ
  H : ℕ
  q : ℕ
  q' : ℕ
  r : ℕ
  sigmaB : ℕ
  sigmaF : ℕ
  sigmaFv : ℕ
  sigmaH : ℕ
  sigmaHv : ℕ
  sigmaR : ℕ
  aux : A

structure PowerOK {A : Type} (C : GrowthCall A) (ℓ b n : ℕ)
    (z : PowerWitness A) : Prop where
  input : z.u = scale C.u₀ ℓ b n z.c
  growth : C.rel z.u z.v z.aux
  pellF : z.X ^ 2 = 1 + ((b * z.u) ^ 2 - 1) * z.F ^ 2
  pellH : z.Y ^ 2 = 1 + (z.u ^ 2 - 1) * z.H ^ 2
  residueF : z.F = n + 1 + (b * z.u - 1) * z.q
  residueH : z.H = n + 1 + (z.u - 1) * z.q'
  division : z.F = z.c * z.H + z.r
  baseSlack : b = 2 + z.sigmaB
  fSlack : z.F = 1 + z.sigmaF
  fvSlack : z.v = z.F + 1 + z.sigmaFv
  hSlack : z.H = 1 + z.sigmaH
  hvSlack : z.v = z.H + 1 + z.sigmaHv
  rSlack : z.H = z.r + 1 + z.sigmaR

lemma pell_complete {a X F : ℕ} (ha : 1 < a)
    (h : X ^ 2 = 1 + (a ^ 2 - 1) * F ^ 2) :
    ∃ i, X = Pell.xn ha i ∧ F = Pell.yn ha i := by
  have he : X * X = 1 + (a * a - 1) * F * F := by
    simpa only [pow_two, mul_assoc] using h
  have hp : X * X - (a * a - 1) * F * F = 1 := by omega
  exact Pell.eq_pell ha hp

lemma pell_norm {a : ℕ} (ha : 1 < a) (n : ℕ) :
    Pell.xn ha n ^ 2 = 1 + (a ^ 2 - 1) * Pell.yn ha n ^ 2 := by
  have h := Pell.pell_eq ha n
  change Pell.xn ha n * Pell.xn ha n - (a * a - 1) * Pell.yn ha n * Pell.yn ha n = 1 at h
  have he : Pell.xn ha n * Pell.xn ha n =
      1 + (a * a - 1) * Pell.yn ha n * Pell.yn ha n := by omega
  simpa only [pow_two, mul_assoc] using he

theorem power_indices {A : Type} (C : GrowthCall A) (ℓ b n : ℕ)
    (hℓ : 1 ≤ ℓ) (z : PowerWitness A) (hz : PowerOK C ℓ b n z) :
    ∃ hu : 1 < z.u, ∃ hbu : 1 < b * z.u,
      z.F = Pell.yn hbu (n + 1) ∧ z.H = Pell.yn hu (n + 1) := by
  have hb : 1 < b := by have := hz.baseSlack; omega
  have hu₀ : C.u₀ ≤ z.u := by rw [hz.input]; unfold scale; omega
  have hu4 : 4 ≤ z.u := le_trans C.u₀_ge hu₀
  have hu : 1 < z.u := by omega
  have hbu : 1 < b * z.u := by nlinarith only [hb, hu]
  have hs := (scale_lower C.u₀ ℓ b n z.c C.u₀_ge hℓ).1
  rw [← hz.input] at hs
  have hnu : n + 5 ≤ z.u := by
    nlinarith only [hs, Nat.zero_le (z.c * n), Nat.zero_le z.c]
  have hn : n + 1 < z.u - 1 := by omega
  have hv := growth_upper C z.u z.v z.aux hz.growth hu₀
  have hFp : 0 < z.F := by have := hz.fSlack; omega
  have hHp : 0 < z.H := by have := hz.hSlack; omega
  have hFv : z.F < z.v := by have := hz.fvSlack; omega
  have hHv : z.H < z.v := by have := hz.hvSlack; omega
  obtain ⟨i, _, hi⟩ := pell_complete hbu hz.pellF
  obtain ⟨j, _, hj⟩ := pell_complete hu hz.pellH
  refine ⟨hu, hbu, ?_, ?_⟩
  · exact pin_index hbu hu4 (by nlinarith only [hb, hu]) hn hFp hFv hv
      ⟨i, hi⟩ ⟨z.q, hz.residueF⟩
  · exact pin_index hu hu4 le_rfl hn hHp hHv hv ⟨j, hj⟩ ⟨z.q', hz.residueH⟩

theorem power_output {A : Type} (C : GrowthCall A) (ℓ b n : ℕ)
    (hℓ : 1 ≤ ℓ) (z : PowerWitness A) (hz : PowerOK C ℓ b n z) :
    z.c = b ^ n := by
  obtain ⟨hu, hbu, hF, hH⟩ := power_indices C ℓ b n hℓ z hz
  have hb : 1 < b := by have := hz.baseSlack; omega
  have hHpos : 0 < z.H := by have := hz.hSlack; omega
  have hr : z.r < z.H := by have := hz.rSlack; omega
  have hlo : b ^ n * z.H ≤ z.F := by
    rw [hF, hH]
    exact (paired_lower hb hu n).2
  have hdiv : z.F < (z.c + 1) * z.H := by
    have hd := hz.division
    nlinarith only [hd, hr]
  have hbc : b ^ n ≤ z.c := by
    by_contra hnot
    have hh := Nat.mul_le_mul_right z.H (show z.c + 1 ≤ b ^ n by omega)
    omega
  have hs := (scale_lower C.u₀ ℓ b n z.c C.u₀_ge hℓ).1
  rw [← hz.input] at hs
  have hnu : n + 5 ≤ z.u := by
    nlinarith only [hs, Nat.zero_le (z.c * n), Nat.zero_le z.c]
  have hn : n ≤ 2 * z.u - 1 := by omega
  have hsub : 2 * z.u - 1 - n + n + 1 = 2 * z.u := by omega
  have hcn : z.c * n < 2 * z.u - 1 - n := by
    nlinarith only [hs, hsub, Nat.zero_le z.c, Nat.zero_le (z.c * n)]
  have hsmall : b ^ n * n < 2 * z.u - 1 - n :=
    lt_of_le_of_lt (Nat.mul_le_mul_right n hbc) hcn
  have hhi : z.F < (b ^ n + 1) * z.H := by
    rw [hF, hH]
    exact (quotient_window hb hu hn hsmall).2
  have hcb : z.c ≤ b ^ n := by
    by_contra hnot
    have hh := Nat.mul_le_mul_right z.H (show b ^ n + 1 ≤ z.c by omega)
    have hd := hz.division
    nlinarith only [hh, hd, hhi, Nat.zero_le z.r]
  omega

theorem power_exists {A : Type} (C : GrowthCall A) (ℓ b n : ℕ)
    (hℓ : 1 ≤ ℓ) (hlarge : 3 < C.δ * ℓ * Real.log 2) (hb : 1 < b) :
    ∃ z : PowerWitness A, PowerOK C ℓ b n z := by
  let c := b ^ n
  let u := scale C.u₀ ℓ b n c
  have hs := scale_lower C.u₀ ℓ b n c C.u₀_ge hℓ
  have hu : 1 < u := lt_trans hb hs.2.1
  have hbu : 1 < b * u := by nlinarith only [hb, hu]
  have hnu : n + 5 ≤ u := by
    nlinarith only [hs.1, Nat.zero_le (c * n), Nat.zero_le c]
  let F := Pell.yn hbu (n + 1)
  let H := Pell.yn hu (n + 1)
  obtain ⟨g, hg, _⟩ := C.unique u
  have hcut := growth_lower C ℓ hℓ hlarge b n g.1 g.2 hb hg
  have hFp : 0 < F := lt_of_lt_of_le (by omega : 0 < n + 1) (Pell.yn_ge_n hbu _)
  have hHp : 0 < H := lt_of_lt_of_le (by omega : 0 < n + 1) (Pell.yn_ge_n hu _)
  have hFv : F < g.1 := hcut.1
  have hHv : H < g.1 := hcut.2
  have hq : F = n + 1 + (b * u - 1) * (F / (b * u - 1)) := by
    have hm := Pell.yn_modEq_a_sub_one hbu (n + 1)
    change F % (b * u - 1) = (n + 1) % (b * u - 1) at hm
    have hau : u ≤ b * u := by nlinarith only [hb, hu]
    rw [Nat.mod_eq_of_lt (by omega : n + 1 < b * u - 1)] at hm
    have hh := Nat.mod_add_div F (b * u - 1)
    omega
  have hq' : H = n + 1 + (u - 1) * (H / (u - 1)) := by
    have hm := Pell.yn_modEq_a_sub_one hu (n + 1)
    change H % (u - 1) = (n + 1) % (u - 1) at hm
    rw [Nat.mod_eq_of_lt (by omega : n + 1 < u - 1)] at hm
    have hh := Nat.mod_add_div H (u - 1)
    omega
  have hn : n ≤ 2 * u - 1 := by omega
  have hsub : 2 * u - 1 - n + n + 1 = 2 * u := by omega
  have hsmall : b ^ n * n < 2 * u - 1 - n := by
    change c * n < _
    nlinarith only [hs.1, hsub, Nat.zero_le c, Nat.zero_le (c * n)]
  have hwin := quotient_window hb hu hn hsmall
  have hlo : c * H ≤ F := hwin.1
  have hhi : F < (c + 1) * H := hwin.2
  let r := F - c * H
  have hdiv : F = c * H + r := by dsimp [r]; omega
  have hr : r < H := by nlinarith only [hdiv, hhi]
  refine ⟨{
    c := c, u := u, v := g.1,
    X := Pell.xn hbu (n + 1), Y := Pell.xn hu (n + 1),
    F := F, H := H, q := F / (b * u - 1), q' := H / (u - 1), r := r,
    sigmaB := b - 2, sigmaF := F - 1, sigmaFv := g.1 - F - 1,
    sigmaH := H - 1, sigmaHv := g.1 - H - 1, sigmaR := H - r - 1,
    aux := g.2
  }, ?_⟩
  constructor
  · rfl
  · exact hg
  · exact pell_norm hbu (n + 1)
  · exact pell_norm hu (n + 1)
  · exact hq
  · exact hq'
  · exact hdiv
  all_goals (dsimp only; omega)

theorem power_witness_unique {A : Type} (C : GrowthCall A) (ℓ b n : ℕ)
    (hℓ : 1 ≤ ℓ) (z z' : PowerWitness A)
    (hz : PowerOK C ℓ b n z) (hz' : PowerOK C ℓ b n z') : z = z' := by
  have hc : z.c = z'.c := (power_output C ℓ b n hℓ z hz).trans
    (power_output C ℓ b n hℓ z' hz').symm
  have hu : z.u = z'.u := by rw [hz.input, hz'.input, hc]
  obtain ⟨g, _, hgu⟩ := C.unique z.u
  have hg' := hz'.growth
  rw [← hu] at hg'
  have hpair : (z.v, z.aux) = (z'.v, z'.aux) :=
    (hgu _ hz.growth).trans (hgu _ hg').symm
  have hv : z.v = z'.v := congrArg Prod.fst hpair
  have haux : z.aux = z'.aux := congrArg Prod.snd hpair
  obtain ⟨huz, hbuz, hFz, hHz⟩ := power_indices C ℓ b n hℓ z hz
  obtain ⟨_, _, hFz', hHz'⟩ := power_indices C ℓ b n hℓ z' hz'
  simp only [hu] at hFz hHz
  have hF : z.F = z'.F := hFz.trans hFz'.symm
  have hH : z.H = z'.H := hHz.trans hHz'.symm
  have hXpow : z.X ^ 2 = z'.X ^ 2 := by rw [hz.pellF, hz'.pellF, hu, hF]
  have hYpow : z.Y ^ 2 = z'.Y ^ 2 := by rw [hz.pellH, hz'.pellH, hu, hH]
  have hX : z.X = z'.X := Nat.pow_left_injective (by decide : 2 ≠ 0) hXpow
  have hY : z.Y = z'.Y := Nat.pow_left_injective (by decide : 2 ≠ 0) hYpow
  have hres' : z.F = n + 1 + (b * z.u - 1) * z'.q := by
    simpa only [← hF, ← hu] using hz'.residueF
  have hqmul : (b * z.u - 1) * z.q = (b * z.u - 1) * z'.q := by
    have hh := hz.residueF
    omega
  have hq : z.q = z'.q := Nat.eq_of_mul_eq_mul_left (by omega) hqmul
  have hresH' : z.H = n + 1 + (z.u - 1) * z'.q' := by
    simpa only [← hH, ← hu] using hz'.residueH
  have hqmul' : (z.u - 1) * z.q' = (z.u - 1) * z'.q' := by
    have hh := hz.residueH
    omega
  have hq' : z.q' = z'.q' := Nat.eq_of_mul_eq_mul_left (by omega) hqmul'
  have hdiv' : z.F = z.c * z.H + z'.r := by
    simpa only [← hF, ← hc, ← hH] using hz'.division
  have hr : z.r = z'.r := by have hh := hz.division; omega
  refine PowerWitness.ext hc hu hv hX hY hF hH hq hq' hr ?_ ?_ ?_ ?_ ?_ ?_ haux
  · have h1 := hz.baseSlack; have h2 := hz'.baseSlack; omega
  · have h1 := hz.fSlack; have h2 := hz'.fSlack; omega
  · have h1 := hz.fvSlack; have h2 := hz'.fvSlack; omega
  · have h1 := hz.hSlack; have h2 := hz'.hSlack; omega
  · have h1 := hz.hvSlack; have h2 := hz'.hvSlack; omega
  · have h1 := hz.rSlack; have h2 := hz'.rSlack; omega

theorem power_complete {A : Type} (C : GrowthCall A) (ℓ b n : ℕ)
    (hℓ : 1 ≤ ℓ) (hlarge : 3 < C.δ * ℓ * Real.log 2) :
    (∃! z : PowerWitness A, PowerOK C ℓ b n z) ↔ 2 ≤ b := by
  constructor
  · rintro ⟨z, hz, _⟩
    have hh := hz.baseSlack
    omega
  · intro hb
    obtain ⟨z, hz⟩ := power_exists C ℓ b n hℓ hlarge (by omega)
    exact ⟨z, hz, fun w hw => power_witness_unique C ℓ b n hℓ w z hw hz⟩

end PellTransfer

theorem elliptic_pell_complete {T B : Type} [AddCommGroup T] [Fintype T]
    (S : HeightSequence) (G : OrbitGeometry T)
    (E : ℕ → GrowthWitness T → B → Prop)
    (hE : ∀ u z, GrowthOK S G u z → ∃! a, E u z a) :
    ∃ C : GrowthCall B, ∃ ℓ : ℕ,
      (∀ u v a, C.rel u v a ↔
        ∃ z, GrowthOK S G u z ∧ E u z a ∧ v = z.value) ∧
      (∀ b n, (∃! z : PellTransfer.PowerWitness B,
        PellTransfer.PowerOK C ℓ b n z) ↔ 2 ≤ b) ∧
      (∀ b n z, PellTransfer.PowerOK C ℓ b n z → z.c = b ^ n) := by
  obtain ⟨D, hD⟩ := growth_call_exists S G E hE
  let C := D.project
  obtain ⟨ℓ, hℓ, hlarge⟩ := PellTransfer.choose_exponent C
  refine ⟨C, ℓ, ?_, fun b n => PellTransfer.power_complete C ℓ b n hℓ hlarge,
    fun b n z hz => PellTransfer.power_output C ℓ b n hℓ z hz⟩
  intro u v a
  change (∃ z, D.rel u v (z, a)) ↔ _
  simp only [hD]

end ArithmeticBridge
