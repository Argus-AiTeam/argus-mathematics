import Mathlib

noncomputable section

open Complex

namespace ZeroFreeTraces

theorem quadratic_factor (A L D : ℂ) (hD : D ≠ 0) :
    ∃ r s : ℂ, (∀ z : ℂ, A + L * z + D * z ^ 2 = D * (z - r) * (z - s)) ∧
      D * r * s = A := by
  obtain ⟨w, hw⟩ := IsAlgClosed.exists_pow_nat_eq (L ^ 2 - 4 * D * A)
    (by decide : 0 < (2 : ℕ))
  let r := (-L + w) / (2 * D)
  let s := (-L - w) / (2 * D)
  have hs : D * (r + s) = -L := by
    dsimp [r, s]
    field_simp
    ring
  have hp : D * r * s = A := by
    dsimp [r, s]
    field_simp
    linear_combination -hw
  refine ⟨r, s, ?_, hp⟩
  intro z
  linear_combination z * hs - hp

theorem bivariate_coefficient_bound (A B C D : ℂ) (r s : ℝ)
    (hr : 0 < r) (hs : 0 < s)
    (h : ∀ x y : ℂ, ‖x‖ < r → ‖y‖ < s →
      A + B * x + C * y + D * x * y ≠ 0) :
    ‖D‖ * r * s ≤ ‖A‖ := by
  by_cases hD : D = 0
  · simp [hD]
  let K : ℂ := D * (r : ℂ) * (s : ℂ)
  have hK : K ≠ 0 := by
    dsimp [K]
    exact mul_ne_zero (mul_ne_zero hD (ofReal_ne_zero.mpr hr.ne'))
      (ofReal_ne_zero.mpr hs.ne')
  obtain ⟨u, v, hf, hp⟩ := quadratic_factor A
    (B * (r : ℂ) + C * (s : ℂ)) K hK
  have hn : ∀ z : ℂ,
      A + (B * (r : ℂ) + C * (s : ℂ)) * z + K * z ^ 2 = 0 →
      1 ≤ ‖z‖ := by
    intro z hz
    by_contra hn
    have hzlt : ‖z‖ < 1 := lt_of_not_ge hn
    have hx : ‖(r : ℂ) * z‖ < r := by
      rw [norm_mul, norm_real, Real.norm_eq_abs, abs_of_pos hr]
      nlinarith
    have hy : ‖(s : ℂ) * z‖ < s := by
      rw [norm_mul, norm_real, Real.norm_eq_abs, abs_of_pos hs]
      nlinarith
    apply h ((r : ℂ) * z) ((s : ℂ) * z) hx hy
    calc
      _ = A + (B * (r : ℂ) + C * (s : ℂ)) * z + K * z ^ 2 := by
        dsimp [K]
        ring
      _ = 0 := hz
  have hu : 1 ≤ ‖u‖ := hn u (by rw [hf]; simp)
  have hv : 1 ≤ ‖v‖ := hn v (by rw [hf]; simp)
  have hnorm := congrArg norm hp
  have hKn : ‖K‖ = ‖D‖ * r * s := by
    simp [K, abs_of_pos hr, abs_of_pos hs]
  rw [norm_mul, norm_mul, hKn] at hnorm
  have hmul : 1 ≤ ‖u‖ * ‖v‖ := by nlinarith
  have hnon : 0 ≤ ‖D‖ * r * s := by positivity
  nlinarith [mul_nonneg hnon (sub_nonneg.mpr hmul)]

theorem bivariate_contraction (A B C D : ℂ) (R : ℝ) (hR : 1 < R)
    (h : ∀ x y : ℂ, ‖x‖ < R → ‖y‖ < 1 →
      A + B * x + C * y + D * x * y ≠ 0) :
    A + D ≠ 0 := by
  have hA : A ≠ 0 := by
    simpa using h 0 0 (by simpa using (lt_trans zero_lt_one hR)) (by simp)
  have hb := bivariate_coefficient_bound A B C D R 1 (by linarith) zero_lt_one h
  simp only [mul_one] at hb
  have hlt : ‖D‖ < ‖A‖ := by
    by_contra hn
    have hd : ‖A‖ ≤ ‖D‖ := le_of_not_gt hn
    have hle : ‖A‖ * R ≤ ‖A‖ :=
      (mul_le_mul_of_nonneg_right hd (by linarith)).trans hb
    have hstrict : ‖A‖ < ‖A‖ * R := by
      simpa using mul_lt_mul_of_pos_left hR (norm_pos_iff.mpr hA)
    exact (not_lt_of_ge hle) hstrict
  intro hz
  have he : A = -D := by linear_combination hz
  simp [he] at hlt

theorem bivariate_contraction_lower_bound (A B C D : ℂ) (R : ℝ) (hR : 1 < R)
    (h : ∀ x y : ℂ, ‖x‖ < R → ‖y‖ < 1 →
      A + B * x + C * y + D * x * y ≠ 0) :
    (1 - 1 / R) * ‖A‖ ≤ ‖A + D‖ := by
  have hR0 : 0 < R := by linarith
  have hb := bivariate_coefficient_bound A B C D R 1 hR0 zero_lt_one h
  simp only [mul_one] at hb
  have hdiv : ‖D‖ ≤ ‖A‖ / R := (le_div_iff₀ hR0).mpr hb
  have htri : ‖A‖ ≤ ‖A + D‖ + ‖D‖ := by
    calc
      ‖A‖ = ‖(A + D) - D‖ := by congr 1; ring
      _ ≤ ‖A + D‖ + ‖D‖ := norm_sub_le _ _
  calc
    (1 - 1 / R) * ‖A‖ = ‖A‖ - ‖A‖ / R := by ring
    _ ≤ ‖A + D‖ := by linarith

@[reducible] def PairPoly : ℕ → Type
  | 0 => ℂ
  | n + 1 => Bool → Bool → PairPoly n

def padd : {n : ℕ} → PairPoly n → PairPoly n → PairPoly n
  | 0, p, q => p + q
  | _ + 1, p, q => fun i j => padd (p i j) (q i j)

def peval : {n : ℕ} → PairPoly n → (Fin n → ℂ) → (Fin n → ℂ) → ℂ
  | 0, p, _, _ => p
  | _ + 1, p, x, y =>
      peval (p false false) (fun i => x i.succ) (fun i => y i.succ) +
      peval (p true false) (fun i => x i.succ) (fun i => y i.succ) * x 0 +
      peval (p false true) (fun i => x i.succ) (fun i => y i.succ) * y 0 +
      peval (p true true) (fun i => x i.succ) (fun i => y i.succ) * x 0 * y 0

theorem peval_add {n : ℕ} (p q : PairPoly n) (x y : Fin n → ℂ) :
    peval (padd p q) x y = peval p x y + peval q x y := by
  induction n with
  | zero => rfl
  | succ n ih =>
      simp only [peval, padd, ih]
      ring

def contract {n : ℕ} (p : PairPoly (n + 1)) : PairPoly n :=
  padd (p false false) (p true true)

def close : {n : ℕ} → PairPoly n → ℂ
  | 0, p => p
  | _ + 1, p => close (contract p)

def DiskStable {n : ℕ} (p : PairPoly n) (R : ℝ) : Prop :=
  ∀ x y : Fin n → ℂ, (∀ i, ‖x i‖ < R) → (∀ i, ‖y i‖ < 1) →
    peval p x y ≠ 0

theorem disk_section_stable {n : ℕ} (p : PairPoly (n + 1)) (R : ℝ)
    (hp : DiskStable p R) (x y : Fin n → ℂ)
    (hx : ∀ i, ‖x i‖ < R) (hy : ∀ i, ‖y i‖ < 1) :
    ∀ u v : ℂ, ‖u‖ < R → ‖v‖ < 1 →
      peval (p false false) x y + peval (p true false) x y * u +
      peval (p false true) x y * v + peval (p true true) x y * u * v ≠ 0 := by
  intro u v hu hv
  have h := hp (Fin.cons u x) (Fin.cons v y)
    (fun i => Fin.cases hu (fun j => by simpa using hx j) i)
    (fun i => Fin.cases hv (fun j => by simpa using hy j) i)
  simpa [peval] using h

theorem contract_stable {n : ℕ} (p : PairPoly (n + 1)) (R : ℝ)
    (hR : 1 < R) (hp : DiskStable p R) : DiskStable (contract p) R := by
  intro x y hx hy
  simpa [contract, peval_add] using bivariate_contraction
    (peval (p false false) x y) (peval (p true false) x y)
    (peval (p false true) x y) (peval (p true true) x y) R hR
    (disk_section_stable p R hp x y hx hy)

theorem complete_cyclic_contraction_nonzero {n : ℕ} (p : PairPoly n)
    (R : ℝ) (hR : 1 < R) (hp : DiskStable p R) : close p ≠ 0 := by
  induction n with
  | zero => exact hp Fin.elim0 Fin.elim0 (by simp) (by simp)
  | succ n ih => exact ih (contract p) (contract_stable p R hR hp)

theorem contract_zero_lower_bound {n : ℕ} (p : PairPoly (n + 1)) (R : ℝ)
    (hR : 1 < R) (hp : DiskStable p R) :
    (1 - 1 / R) * ‖peval p (fun _ => 0) (fun _ => 0)‖ ≤
      ‖peval (contract p) (fun _ => 0) (fun _ => 0)‖ := by
  have hs := disk_section_stable p R hp (fun _ => 0) (fun _ => 0)
    (fun _ => by simpa using (lt_trans zero_lt_one hR)) (fun _ => by simp)
  have h := bivariate_contraction_lower_bound
    (peval (p false false) (fun _ => 0) (fun _ => 0))
    (peval (p true false) (fun _ => 0) (fun _ => 0))
    (peval (p false true) (fun _ => 0) (fun _ => 0))
    (peval (p true true) (fun _ => 0) (fun _ => 0)) R hR hs
  simpa [contract, peval_add, peval] using h

theorem complete_cyclic_contraction_lower_bound {n : ℕ} (p : PairPoly n)
    (R : ℝ) (hR : 1 < R) (hp : DiskStable p R) :
    (1 - 1 / R) ^ n * ‖peval p (fun _ => 0) (fun _ => 0)‖ ≤ ‖close p‖ := by
  have hq : 0 ≤ 1 - 1 / R :=
    sub_nonneg.mpr ((div_le_one (by linarith : 0 < R)).mpr hR.le)
  induction n with
  | zero => simp [close, peval]
  | succ n ih =>
      have hi := ih (contract p) (contract_stable p R hR hp)
      have hs := contract_zero_lower_bound p R hR hp
      calc
        _ = (1 - 1 / R) ^ n * ((1 - 1 / R) *
            ‖peval p (fun _ => 0) (fun _ => 0)‖) := by rw [pow_succ]; ring
        _ ≤ (1 - 1 / R) ^ n *
            ‖peval (contract p) (fun _ => 0) (fun _ => 0)‖ :=
          mul_le_mul_of_nonneg_left hs (pow_nonneg hq n)
        _ ≤ ‖close p‖ := hi

@[reducible] def State : ℕ → Type
  | 0 => Unit
  | n + 1 => Bool × State n

instance stateFintype (n : ℕ) : Fintype (State n) := by
  induction n with
  | zero => exact inferInstanceAs (Fintype Unit)
  | succ n ih => exact inferInstanceAs (Fintype (Bool × State n))

instance stateDecidableEq (n : ℕ) : DecidableEq (State n) := by
  induction n with
  | zero => exact inferInstanceAs (DecidableEq Unit)
  | succ n ih => exact inferInstanceAs (DecidableEq (Bool × State n))

def matrixSymbol : {n : ℕ} → Matrix (State n) (State n) ℂ → PairPoly n
  | 0, M => M () ()
  | _ + 1, M => fun i j => matrixSymbol (fun u v => M (j, u) (i, v))

theorem matrixSymbol_add {n : ℕ} (M N : Matrix (State n) (State n) ℂ) :
    matrixSymbol (M + N) = padd (matrixSymbol M) (matrixSymbol N) := by
  induction n with
  | zero => rfl
  | succ n ih =>
      funext i j
      exact ih _ _

theorem close_matrixSymbol {n : ℕ} (M : Matrix (State n) (State n) ℂ) :
    close (matrixSymbol M) = Matrix.trace M := by
  induction n with
  | zero => simp [close, matrixSymbol, Matrix.trace, State]
  | succ n ih =>
      change close (padd (matrixSymbol (fun u v => M (false, u) (false, v)))
        (matrixSymbol (fun u v => M (true, u) (true, v)))) = _
      rw [← matrixSymbol_add, ih, Matrix.trace_add]
      simp [Matrix.trace, State, Fintype.sum_prod_type, add_comm]

theorem disk_stable_matrix_trace_nonzero {n : ℕ}
    (M : Matrix (State n) (State n) ℂ) (R : ℝ) (hR : 1 < R)
    (hM : DiskStable (matrixSymbol M) R) : Matrix.trace M ≠ 0 := by
  rw [← close_matrixSymbol]
  exact complete_cyclic_contraction_nonzero _ R hR hM

theorem disk_stable_matrix_trace_lower_bound {n : ℕ}
    (M : Matrix (State n) (State n) ℂ) (R : ℝ) (hR : 1 < R)
    (hM : DiskStable (matrixSymbol M) R) :
    (1 - 1 / R) ^ n *
      ‖peval (matrixSymbol M) (fun _ => 0) (fun _ => 0)‖ ≤ ‖Matrix.trace M‖ := by
  rw [← close_matrixSymbol]
  exact complete_cyclic_contraction_lower_bound _ R hR hM

theorem su11_disk_identity (a b x : ℂ) :
    normSq (a + b * x) - normSq (star b + star a * x) =
      (normSq a - normSq b) * (1 - normSq x) := by
  simp [Complex.normSq_apply, Complex.mul_re, Complex.mul_im]
  ring

theorem real_sl2_norm_identity (a b c d : ℝ) :
    normSq (⟨(a + d) / 2, (b - c) / 2⟩ : ℂ) -
      normSq (⟨(a - d) / 2, -(b + c) / 2⟩ : ℂ) = a * d - b * c := by
  simp [Complex.normSq_apply]
  ring

theorem su11_open_disk (a b x : ℂ) (hab : normSq a - normSq b = 1)
    (hx : normSq x < 1) :
    a + b * x ≠ 0 ∧ normSq ((star b + star a * x) / (a + b * x)) < 1 := by
  have hid := su11_disk_identity a b x
  rw [hab, one_mul] at hid
  have hpos : 0 < normSq (a + b * x) := by
    nlinarith [normSq_nonneg (star b + star a * x)]
  have hne : a + b * x ≠ 0 := by
    intro hz
    simp [hz] at hpos
  refine ⟨hne, ?_⟩
  rw [normSq_div]
  exact (div_lt_one hpos).mpr (by linarith)

theorem field_then_real_pulses_strict (a b r x : ℂ)
    (hab : normSq a - normSq b = 1) (hr : normSq r < 1) (hx : normSq x ≤ 1) :
    a + b * (r * x) ≠ 0 ∧
      normSq ((star b + star a * (r * x)) / (a + b * (r * x))) < 1 := by
  apply su11_open_disk a b (r * x) hab
  rw [normSq_mul]
  nlinarith [normSq_nonneg r, normSq_nonneg x]

section Projection

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def slotWord (E P : Matrix ι ι ℂ) : List (Matrix ι ι ℂ) → Matrix ι ι ℂ
  | [] => 1
  | U :: Us => E * P * U * slotWord E P Us

def projectedWord (E P : Matrix ι ι ℂ) : List (Matrix ι ι ℂ) → Matrix ι ι ℂ
  | [] => P
  | U :: Us => E * P * U * P * projectedWord E P Us

theorem slotWord_supported (E P : Matrix ι ι ℂ) (hP : P * P = P)
    (hEP : P * E = E * P) (U : Matrix ι ι ℂ) (Us : List (Matrix ι ι ℂ)) :
    P * slotWord E P (U :: Us) = slotWord E P (U :: Us) := by
  have h : P * E * P = E * P := by rw [hEP, mul_assoc, hP]
  calc
    _ = (P * E * P) * U * slotWord E P Us := by simp [slotWord, mul_assoc]
    _ = _ := by rw [h]; rfl

theorem projectedWord_eq (E P : Matrix ι ι ℂ) (hP : P * P = P)
    (hEP : P * E = E * P) (Us : List (Matrix ι ι ℂ)) :
    projectedWord E P Us = slotWord E P Us * P := by
  induction Us with
  | nil => simp [projectedWord, slotWord]
  | cons U Us ih =>
      have hs : P * (slotWord E P Us * P) = slotWord E P Us * P := by
        cases Us with
        | nil => simpa [slotWord] using hP
        | cons V Vs =>
            rw [← mul_assoc, slotWord_supported E P hP hEP]
      calc
        _ = (E * P * U) * (P * (slotWord E P Us * P)) := by
          simp only [projectedWord, ih, mul_assoc]
        _ = (E * P * U) * (slotWord E P Us * P) := by rw [hs]
        _ = _ := by simp [slotWord, mul_assoc]

theorem projected_trace_eq_slot_trace (E P : Matrix ι ι ℂ) (hP : P * P = P)
    (hEP : P * E = E * P) (U : Matrix ι ι ℂ) (Us : List (Matrix ι ι ℂ)) :
    Matrix.trace (projectedWord E P (U :: Us)) =
      Matrix.trace (slotWord E P (U :: Us)) := by
  rw [projectedWord_eq E P hP hEP, Matrix.trace_mul_comm,
    slotWord_supported E P hP hEP]

end Projection

end ZeroFreeTraces
