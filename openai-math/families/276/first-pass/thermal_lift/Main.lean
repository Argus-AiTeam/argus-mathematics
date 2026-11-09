import Mathlib

open Matrix
open scoped ComplexOrder

noncomputable section

namespace ThermalLift

@[ext] structure Coeff where
  a : ℝ
  b : ℝ
  e : ℝ
  d : ℝ

def row0 (q : Coeff) : ℝ := q.a + q.b
def row1 (q : Coeff) : ℝ := q.e + q.d
def scalar (q : Coeff) (k : ℝ) : ℝ := row0 q * row1 q - k ^ 2

structure Admissible (q : Coeff) (k : ℝ) : Prop where
  a0 : 0 ≤ q.a
  b0 : 0 ≤ q.b
  e0 : 0 ≤ q.e
  d0 : 0 ≤ q.d
  k0 : 0 ≤ k
  mass : q.a + q.b + q.e + q.d = 1
  det : q.a * q.d - q.b * q.e = k ^ 2

def mix (w z : ℝ) (q t : Coeff) : Coeff :=
  ⟨w * q.a + z * t.a, w * q.b + z * t.b,
   w * q.e + z * t.e, w * q.d + z * t.d⟩

theorem scalar_identity {q : Coeff} {k : ℝ} (h : Admissible q k) :
    scalar q k = q.b * row1 q + q.e * row0 q := by
  dsimp [scalar, row0, row1]
  nlinarith [h.det]

theorem scalar_range {q : Coeff} {k : ℝ} (h : Admissible q k) :
    0 ≤ scalar q k ∧ scalar q k ≤ 1 / 4 := by
  have hr : 0 ≤ row0 q := add_nonneg h.a0 h.b0
  have hs : 0 ≤ row1 q := add_nonneg h.e0 h.d0
  have hm : row0 q + row1 q = 1 := by
    dsimp [row0, row1]
    linarith [h.mass]
  constructor
  · rw [scalar_identity h]
    exact add_nonneg (mul_nonneg h.b0 hs) (mul_nonneg h.e0 hr)
  · dsimp [scalar]
    nlinarith [sq_nonneg (row0 q - row1 q), sq_nonneg k]

def leftEnd (q : Coeff) (k : ℝ) : Coeff :=
  ⟨k ^ 2 / row1 q, scalar q k / row1 q, 0, row1 q⟩

def rightEnd (q : Coeff) (k : ℝ) : Coeff :=
  ⟨row0 q, 0, scalar q k / row0 q, k ^ 2 / row0 q⟩

theorem left_rows {q : Coeff} {k : ℝ} (hs : row1 q ≠ 0) :
    row0 (leftEnd q k) = row0 q ∧ row1 (leftEnd q k) = row1 q := by
  constructor
  · dsimp [row0, leftEnd, scalar]
    field_simp [hs]
    ring
  · simp [row1, leftEnd]

theorem right_rows {q : Coeff} {k : ℝ} (hr : row0 q ≠ 0) :
    row0 (rightEnd q k) = row0 q ∧ row1 (rightEnd q k) = row1 q := by
  constructor
  · simp [row0, rightEnd]
  · dsimp [row1, rightEnd, scalar]
    field_simp [hr]
    ring

theorem left_valid {q : Coeff} {k : ℝ} (h : Admissible q k)
    (hs : 0 < row1 q) : Admissible (leftEnd q k) k := by
  have hl := left_rows (k := k) (ne_of_gt hs)
  refine ⟨div_nonneg (sq_nonneg _) hs.le,
    div_nonneg (scalar_range h).1 hs.le, le_rfl, hs.le, h.k0, ?_, ?_⟩
  · have hm : row0 (leftEnd q k) + row1 (leftEnd q k) = 1 := by
      rw [hl.1, hl.2]
      dsimp [row0, row1]
      linarith [h.mass]
    dsimp [row0, row1] at hm
    linarith
  · dsimp [leftEnd]
    simp [hs.ne']

theorem right_valid {q : Coeff} {k : ℝ} (h : Admissible q k)
    (hr : 0 < row0 q) : Admissible (rightEnd q k) k := by
  have ht := right_rows (k := k) (ne_of_gt hr)
  refine ⟨hr.le, le_rfl, div_nonneg (scalar_range h).1 hr.le,
    div_nonneg (sq_nonneg _) hr.le, h.k0, ?_, ?_⟩
  · have hm : row0 (rightEnd q k) + row1 (rightEnd q k) = 1 := by
      rw [ht.1, ht.2]
      dsimp [row0, row1]
      linarith [h.mass]
    dsimp [row0, row1] at hm
    linarith
  · dsimp [rightEnd]
    field_simp [hr.ne']
    ring

structure Decomposition (q : Coeff) (k : ℝ) where
  q1 : Coeff
  q2 : Coeff
  w1 : ℝ
  w2 : ℝ
  valid1 : Admissible q1 k
  valid2 : Admissible q2 k
  edge1 : q1.e = 0
  edge2 : q2.b = 0
  w10 : 0 ≤ w1
  w20 : 0 ≤ w2
  total : w1 + w2 = 1
  recover : mix w1 w2 q1 q2 = q
  same1 : scalar q1 k = scalar q k
  same2 : scalar q2 k = scalar q k

theorem interior_decomposition {q : Coeff} {k : ℝ} (h : Admissible q k)
    (hb : 0 < q.b) (he : 0 < q.e) : Nonempty (Decomposition q k) := by
  have hr : 0 < row0 q := by dsimp [row0]; linarith [h.a0]
  have hs : 0 < row1 q := by dsimp [row1]; linarith [h.d0]
  have hu : 0 < scalar q k := by
    rw [scalar_identity h]
    exact add_pos_of_pos_of_nonneg (mul_pos hb hs) (mul_nonneg h.e0 hr.le)
  let w := q.b * row1 q / scalar q k
  let z := q.e * row0 q / scalar q k
  have hwz : w + z = 1 := by
    dsimp [w, z]
    rw [← add_div, ← scalar_identity h, div_self (ne_of_gt hu)]
  have hl := left_rows (k := k) (ne_of_gt hs)
  have ht := right_rows (k := k) (ne_of_gt hr)
  have hbrec : (mix w z (leftEnd q k) (rightEnd q k)).b = q.b := by
    dsimp [mix, leftEnd, rightEnd, w, z]
    field_simp [hs.ne', hu.ne']
    ring
  have herec : (mix w z (leftEnd q k) (rightEnd q k)).e = q.e := by
    dsimp [mix, leftEnd, rightEnd, w, z]
    field_simp [hr.ne', hu.ne']
    ring
  have hrrec : row0 (mix w z (leftEnd q k) (rightEnd q k)) = row0 q := by
    change w * (leftEnd q k).a + z * (rightEnd q k).a +
      (w * (leftEnd q k).b + z * (rightEnd q k).b) = row0 q
    calc
      _ = w * row0 (leftEnd q k) + z * row0 (rightEnd q k) := by
        dsimp [row0]; ring
      _ = row0 q := by rw [hl.1, ht.1]; nlinarith [hwz]
  have hsrec : row1 (mix w z (leftEnd q k) (rightEnd q k)) = row1 q := by
    change w * (leftEnd q k).e + z * (rightEnd q k).e +
      (w * (leftEnd q k).d + z * (rightEnd q k).d) = row1 q
    calc
      _ = w * row1 (leftEnd q k) + z * row1 (rightEnd q k) := by
        dsimp [row1]; ring
      _ = row1 q := by rw [hl.2, ht.2]; nlinarith [hwz]
  have hrec : mix w z (leftEnd q k) (rightEnd q k) = q := by
    apply Coeff.ext
    · dsimp [row0] at hrrec
      linarith [hbrec]
    · exact hbrec
    · exact herec
    · dsimp [row1] at hsrec
      linarith [herec]
  exact ⟨{
    q1 := leftEnd q k
    q2 := rightEnd q k
    w1 := w
    w2 := z
    valid1 := left_valid h hs
    valid2 := right_valid h hr
    edge1 := rfl
    edge2 := rfl
    w10 := div_nonneg (mul_nonneg h.b0 hs.le) hu.le
    w20 := div_nonneg (mul_nonneg h.e0 hr.le) hu.le
    total := hwz
    recover := hrec
    same1 := by dsimp [scalar]; rw [hl.1, hl.2]
    same2 := by dsimp [scalar]; rw [ht.1, ht.2]
  }⟩

def lower (q : Coeff) (k sx sy : ℝ) (g : ℝ → ℝ) : ℝ :=
  (q.a + q.e) * sx + (q.b + q.d) * sy + g (scalar q k)

def flipCoeff (q : Coeff) : Coeff := ⟨q.d, q.e, q.b, q.a⟩

theorem flip_valid {q : Coeff} {k : ℝ} (h : Admissible q k) :
    Admissible (flipCoeff q) k := by
  refine ⟨h.d0, h.e0, h.b0, h.a0, h.k0, ?_, ?_⟩
  · dsimp [flipCoeff]
    linarith [h.mass]
  · dsimp [flipCoeff]
    nlinarith [h.det]

theorem flip_scalar (q : Coeff) (k : ℝ) :
    scalar (flipCoeff q) k = scalar q k := by
  dsimp [scalar, row0, row1, flipCoeff]
  ring

theorem lower_recovery {q : Coeff} {k sx sy : ℝ} {g : ℝ → ℝ}
    (d : Decomposition q k) :
    d.w1 * lower d.q1 k sx sy g + d.w2 * lower d.q2 k sx sy g =
      lower q k sx sy g := by
  have ha := congrArg Coeff.a d.recover
  have hb := congrArg Coeff.b d.recover
  have he := congrArg Coeff.e d.recover
  have hd := congrArg Coeff.d d.recover
  dsimp [mix] at ha hb he hd
  dsimp [lower]
  rw [d.same1, d.same2]
  linear_combination sx * (ha + he) + sy * (hb + hd) +
    g (scalar q k) * d.total

theorem concave_endpoint_lift
    {V : Type*} [AddCommGroup V] [Module ℝ V]
    (F : Coeff → V) (E : V → ℝ) (P : V → Prop)
    (hf : ∀ w z q t, w + z = 1 →
      F (mix w z q t) = w • F q + z • F t)
    (hp : ∀ (w z : ℝ) (A B : V), 0 ≤ w → 0 ≤ z → w + z = 1 →
      P A → P B → P (w • A + z • B))
    (hc : ∀ w z A B, 0 ≤ w → 0 ≤ z → w + z = 1 →
      P A → P B → w * E A + z * E B ≤ E (w • A + z • B))
    {q : Coeff} {k sx sy : ℝ} {g : ℝ → ℝ}
    (h : Admissible q k)
    (hedge : ∀ t, Admissible t k → (t.b = 0 ∨ t.e = 0) →
      P (F t) ∧ lower t k sx sy g ≤ E (F t)) :
    P (F q) ∧ lower q k sx sy g ≤ E (F q) := by
  by_cases hb : q.b = 0
  · exact hedge q h (Or.inl hb)
  by_cases he : q.e = 0
  · exact hedge q h (Or.inr he)
  obtain ⟨d⟩ := interior_decomposition h
    (lt_of_le_of_ne h.b0 (Ne.symm hb)) (lt_of_le_of_ne h.e0 (Ne.symm he))
  obtain ⟨hp1, hb1⟩ := hedge d.q1 d.valid1 (Or.inr d.edge1)
  obtain ⟨hp2, hb2⟩ := hedge d.q2 d.valid2 (Or.inl d.edge2)
  have hm : F q = d.w1 • F d.q1 + d.w2 • F d.q2 := by
    exact (congrArg F d.recover).symm.trans (hf _ _ _ _ d.total)
  constructor
  · rw [hm]
    exact hp _ _ _ _ d.w10 d.w20 d.total hp1 hp2
  · calc
      lower q k sx sy g =
          d.w1 * lower d.q1 k sx sy g + d.w2 * lower d.q2 k sx sy g :=
        (lower_recovery d).symm
      _ ≤ d.w1 * E (F d.q1) + d.w2 * E (F d.q2) :=
        add_le_add (mul_le_mul_of_nonneg_left hb1 d.w10)
          (mul_le_mul_of_nonneg_left hb2 d.w20)
      _ ≤ E (d.w1 • F d.q1 + d.w2 • F d.q2) :=
        hc _ _ _ _ d.w10 d.w20 d.total hp1 hp2
      _ = E (F q) := congrArg E hm.symm

section Matrices

variable {m n : Type*} [Fintype m] [Fintype n]

def thermal (X Y : Matrix m n ℂ) (q : Coeff) (k : ℝ) :
    Matrix (m ⊕ m) (m ⊕ m) ℂ :=
  fromBlocks (q.a • (X * Xᴴ) + q.b • (Y * Yᴴ)) (k • (X * Yᴴ))
    (k • (Y * Xᴴ)) (q.e • (X * Xᴴ) + q.d • (Y * Yᴴ))

def gram1 (X Y : Matrix m n ℂ) (q : Coeff) :
    Matrix (m ⊕ m) (n ⊕ n) ℂ :=
  fromBlocks (Real.sqrt q.a • X) (Real.sqrt q.b • Y)
    (Real.sqrt q.d • Y) 0

def gram2 (X Y : Matrix m n ℂ) (q : Coeff) :
    Matrix (m ⊕ m) (n ⊕ n) ℂ :=
  fromBlocks (Real.sqrt q.a • X) 0
    (Real.sqrt q.d • Y) (Real.sqrt q.e • X)

def State (A : Matrix m m ℂ) : Prop := A.PosSemidef ∧ A.trace = 1

theorem sqrt_cross {q : Coeff} {k : ℝ} (h : Admissible q k)
    (hedge : q.b = 0 ∨ q.e = 0) :
    Real.sqrt q.a * Real.sqrt q.d = k := by
  have hd : q.a * q.d = k ^ 2 := by
    have hd := h.det
    rcases hedge with hb | he
    · simpa [hb] using hd
    · simpa [he] using hd
  rw [← Real.sqrt_mul h.a0, hd, Real.sqrt_sq h.k0]

omit [Fintype m] in
theorem gram1_identity (X Y : Matrix m n ℂ) {q : Coeff} {k : ℝ}
    (h : Admissible q k) (he : q.e = 0) :
    gram1 X Y q * (gram1 X Y q)ᴴ = thermal X Y q k := by
  have hk := sqrt_cross h (Or.inr he)
  have hk' : Real.sqrt q.d * Real.sqrt q.a = k := by nlinarith [hk]
  simp [gram1, thermal, fromBlocks_conjTranspose, fromBlocks_multiply,
    smul_smul, Real.mul_self_sqrt h.a0,
    Real.mul_self_sqrt h.b0, Real.mul_self_sqrt h.d0, hk, hk', he]

omit [Fintype m] in
theorem gram2_identity (X Y : Matrix m n ℂ) {q : Coeff} {k : ℝ}
    (h : Admissible q k) (hb : q.b = 0) :
    gram2 X Y q * (gram2 X Y q)ᴴ = thermal X Y q k := by
  have hk := sqrt_cross h (Or.inl hb)
  have hk' : Real.sqrt q.d * Real.sqrt q.a = k := by nlinarith [hk]
  simp [gram2, thermal, fromBlocks_conjTranspose, fromBlocks_multiply,
    smul_smul, Real.mul_self_sqrt h.a0,
    Real.mul_self_sqrt h.e0, Real.mul_self_sqrt h.d0, hk, hk', hb, add_comm]

omit [Fintype m] in
theorem thermal_mix (X Y : Matrix m n ℂ) (k w z : ℝ) (q t : Coeff)
    (hwz : w + z = 1) :
    thermal X Y (mix w z q t) k =
      w • thermal X Y q k + z • thermal X Y t k := by
  simp only [thermal, fromBlocks_smul, fromBlocks_add, smul_add, smul_smul]
  apply fromBlocks_inj.mpr
  refine ⟨?_, ?_, ?_, ?_⟩
  · simp [mix, add_smul]
    module
  · rw [← add_smul]
    rw [← add_mul, hwz, one_mul]
  · rw [← add_smul]
    rw [← add_mul, hwz, one_mul]
  · simp [mix, add_smul]
    module

theorem thermal_trace (X Y : Matrix m n ℂ) {q : Coeff} {k : ℝ}
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    (h : Admissible q k) : (thermal X Y q k).trace = 1 := by
  have ht (A B C D : Matrix m m ℂ) :
      (fromBlocks A B C D).trace = A.trace + D.trace := by
    simp [Matrix.trace, Matrix.diag, fromBlocks, Fintype.sum_sum_type]
  rw [thermal, ht]
  simp only [trace_add, trace_smul, hx, hy]
  simp only [Complex.real_smul, mul_one]
  exact_mod_cast (show q.a + q.b + (q.e + q.d) = 1 by linarith [h.mass])

theorem state_convex (w z : ℝ) (A B : Matrix m m ℂ)
    (hw : 0 ≤ w) (hz : 0 ≤ z) (hwz : w + z = 1)
    (ha : State A) (hb : State B) : State (w • A + z • B) := by
  refine ⟨(ha.1.smul hw).add (hb.1.smul hz), ?_⟩
  simp only [trace_add, trace_smul, ha.2, hb.2]
  simp only [Complex.real_smul, mul_one]
  exact_mod_cast hwz

theorem thermal_state (X Y : Matrix m n ℂ) {q : Coeff} {k : ℝ}
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    (h : Admissible q k) : State (thermal X Y q k) := by
  have hedge (t : Coeff) (ht : Admissible t k) (he : t.b = 0 ∨ t.e = 0) :
      State (thermal X Y t k) := by
    refine ⟨?_, thermal_trace X Y hx hy ht⟩
    rcases he with hb | he
    · rw [← gram2_identity X Y ht hb]
      exact posSemidef_self_mul_conjTranspose _
    · rw [← gram1_identity X Y ht he]
      exact posSemidef_self_mul_conjTranspose _
  by_cases hb : q.b = 0
  · exact hedge q h (Or.inl hb)
  by_cases he : q.e = 0
  · exact hedge q h (Or.inr he)
  obtain ⟨d⟩ := interior_decomposition h
    (lt_of_le_of_ne h.b0 (Ne.symm hb)) (lt_of_le_of_ne h.e0 (Ne.symm he))
  have hm : thermal X Y q k =
      d.w1 • thermal X Y d.q1 k + d.w2 • thermal X Y d.q2 k := by
    exact (congrArg (fun t => thermal X Y t k) d.recover).symm.trans
      (thermal_mix X Y k _ _ _ _ d.total)
  rw [hm]
  exact state_convex _ _ _ _ d.w10 d.w20 d.total
    (hedge d.q1 d.valid1 (Or.inr d.edge1)) (hedge d.q2 d.valid2 (Or.inl d.edge2))

def TriangularInput
    (E : Matrix (m ⊕ m) (m ⊕ m) ℂ → ℝ)
    (S : Matrix m m ℂ → ℝ) (g : ℝ → ℝ) : Prop :=
  ∀ (X Y : Matrix m n ℂ) (a b d : ℝ),
    (X * Xᴴ).trace = 1 → (Y * Yᴴ).trace = 1 →
    0 ≤ a → 0 ≤ b → 0 ≤ d → a + b + d = 1 →
    a * S (X * Xᴴ) + (b + d) * S (Y * Yᴴ) + g (b * d) ≤
      E (gram1 X Y ⟨a, b, 0, d⟩ * (gram1 X Y ⟨a, b, 0, d⟩)ᴴ)

theorem triangular_left_edge (X Y : Matrix m n ℂ)
    (E : Matrix (m ⊕ m) (m ⊕ m) ℂ → ℝ)
    (S : Matrix m m ℂ → ℝ) (g : ℝ → ℝ)
    (htri : TriangularInput (n := n) E S g)
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    {q : Coeff} {k : ℝ} (h : Admissible q k) (he : q.e = 0) :
    lower q k (S (X * Xᴴ)) (S (Y * Yᴴ)) g ≤ E (thermal X Y q k) := by
  have hm : q.a + q.b + q.d = 1 := by linarith [h.mass]
  have hu : scalar q k = q.b * q.d := by
    rw [scalar_identity h]
    simp [he, row1]
  have ht := htri X Y q.a q.b q.d hx hy h.a0 h.b0 h.d0 hm
  have hf : gram1 X Y ⟨q.a, q.b, 0, q.d⟩ = gram1 X Y q := rfl
  rw [hf, gram1_identity X Y h he] at ht
  simpa [lower, he, hu] using ht

omit [Fintype m] in
theorem thermal_swap (X Y : Matrix m n ℂ) (q : Coeff) (k : ℝ) :
    thermal Y X (flipCoeff q) k =
      (thermal X Y q k).submatrix Sum.swap Sum.swap := by
  simp [thermal, flipCoeff, add_comm]

theorem triangular_edges (X Y : Matrix m n ℂ)
    (E : Matrix (m ⊕ m) (m ⊕ m) ℂ → ℝ)
    (S : Matrix m m ℂ → ℝ) (g : ℝ → ℝ)
    (htri : TriangularInput (n := n) E S g)
    (hswap : ∀ A, State A → E (A.submatrix Sum.swap Sum.swap) = E A)
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    {q : Coeff} {k : ℝ} (h : Admissible q k) (he : q.b = 0 ∨ q.e = 0) :
    lower q k (S (X * Xᴴ)) (S (Y * Yᴴ)) g ≤ E (thermal X Y q k) := by
  rcases he with hb | he
  · have ht := triangular_left_edge Y X E S g htri hy hx
      (flip_valid h) hb
    rw [thermal_swap, hswap _ (thermal_state X Y hx hy h)] at ht
    have hl : lower (flipCoeff q) k (S (Y * Yᴴ)) (S (X * Xᴴ)) g =
        lower q k (S (X * Xᴴ)) (S (Y * Yᴴ)) g := by
      simp only [lower, flip_scalar]
      dsimp [flipCoeff]
      ring
    rw [hl] at ht
    exact ht
  · exact triangular_left_edge X Y E S g htri hx hy h he

theorem thermal_entropy_lift (X Y : Matrix m n ℂ)
    (E : Matrix (m ⊕ m) (m ⊕ m) ℂ → ℝ) (sx sy : ℝ) (g : ℝ → ℝ)
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    (hc : ∀ w z A B, 0 ≤ w → 0 ≤ z → w + z = 1 →
      State A → State B → w * E A + z * E B ≤ E (w • A + z • B))
    {q : Coeff} {k : ℝ} (h : Admissible q k)
    (htri : ∀ t, Admissible t k → (t.b = 0 ∨ t.e = 0) →
      lower t k sx sy g ≤ E (thermal X Y t k)) :
    State (thermal X Y q k) ∧
      0 ≤ scalar q k ∧ scalar q k ≤ 1 / 4 ∧
      lower q k sx sy g ≤ E (thermal X Y q k) := by
  have hb := concave_endpoint_lift
    (fun t => thermal X Y t k) E State
    (fun w z q t hwz => thermal_mix X Y k w z q t hwz)
    state_convex hc h
    (fun t ht he => ⟨thermal_state X Y hx hy ht, htri t ht he⟩)
  exact ⟨hb.1, (scalar_range h).1, (scalar_range h).2, hb.2⟩

theorem thermal_from_triangular (X Y : Matrix m n ℂ)
    (E : Matrix (m ⊕ m) (m ⊕ m) ℂ → ℝ)
    (S : Matrix m m ℂ → ℝ) (g : ℝ → ℝ)
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    (hc : ∀ (w z : ℝ) A B, 0 ≤ w → 0 ≤ z → w + z = 1 →
      State A → State B → w * E A + z * E B ≤ E (w • A + z • B))
    (htri : TriangularInput (n := n) E S g)
    (hswap : ∀ A, State A → E (A.submatrix Sum.swap Sum.swap) = E A)
    {q : Coeff} {k : ℝ} (h : Admissible q k) :
    State (thermal X Y q k) ∧
      0 ≤ scalar q k ∧ scalar q k ≤ 1 / 4 ∧
      lower q k (S (X * Xᴴ)) (S (Y * Yᴴ)) g ≤ E (thermal X Y q k) :=
  thermal_entropy_lift X Y E (S (X * Xᴴ)) (S (Y * Yᴴ)) g hx hy hc h
    (fun _ ht he => triangular_edges X Y E S g htri hswap hx hy ht he)

end Matrices

section KrausColumns

variable {i o l : Type*} [Fintype i] [Fintype o] [Fintype l]

def branchColumns (V : l → Matrix o i ℂ) (psi : Matrix i Unit ℂ) : Matrix o l ℂ :=
  fun a b => (V b * psi) a ()

theorem common_index_cross (V : l → Matrix o i ℂ) (psi phi : Matrix i Unit ℂ) :
    branchColumns V psi * (branchColumns V phi)ᴴ =
      ∑ b, (V b * psi) * (V b * phi)ᴴ := by
  ext a c
  simp [Matrix.sum_apply, branchColumns, Matrix.mul_apply, Matrix.conjTranspose_apply, mul_comm]

theorem common_index_kraus (V : l → Matrix o i ℂ) (psi phi : Matrix i Unit ℂ) :
    branchColumns V psi * (branchColumns V phi)ᴴ =
      ∑ b, V b * (psi * phiᴴ) * (V b)ᴴ := by
  rw [common_index_cross]
  apply Finset.sum_congr rfl
  intro b _
  simp [Matrix.conjTranspose_mul, Matrix.mul_assoc]

theorem common_index_normalized [DecidableEq i]
    (V : l → Matrix o i ℂ) (psi : Matrix i Unit ℂ)
    (hv : ∑ b, (V b)ᴴ * V b = 1) (hpsi : (psi * psiᴴ).trace = 1) :
    (branchColumns V psi * (branchColumns V psi)ᴴ).trace = 1 := by
  rw [common_index_cross, trace_sum]
  calc
    ∑ b, ((V b * psi) * (V b * psi)ᴴ).trace =
        ∑ b, (psiᴴ * ((V b)ᴴ * V b) * psi).trace := by
      apply Finset.sum_congr rfl
      intro b _
      rw [trace_mul_comm]
      simp [Matrix.conjTranspose_mul, Matrix.mul_assoc]
    _ = (psiᴴ * (∑ b, (V b)ᴴ * V b) * psi).trace := by
      rw [Matrix.mul_sum, Matrix.sum_mul, trace_sum]
    _ = 1 := by
      rw [hv, Matrix.mul_one, trace_mul_comm, hpsi]

end KrausColumns

def channelCoeff (gamma nu p : ℝ) : Coeff :=
  ⟨(1 - gamma * nu) * (1 - p), gamma * (1 - nu) * p,
    gamma * nu * (1 - p), (1 - gamma * (1 - nu)) * p⟩

def channelK (gamma p : ℝ) : ℝ :=
  Real.sqrt (1 - gamma) * Real.sqrt ((1 - p) * p)

theorem channel_admissible {gamma nu p : ℝ}
    (hg : 0 ≤ gamma ∧ gamma ≤ 1) (hn : 0 ≤ nu ∧ nu ≤ 1)
    (hp : 0 ≤ p ∧ p ≤ 1) :
    Admissible (channelCoeff gamma nu p) (channelK gamma p) := by
  have hc : gamma * nu ≤ 1 := by nlinarith [mul_nonneg hg.1 hn.1]
  have hb : gamma * (1 - nu) ≤ 1 := by nlinarith [mul_nonneg hg.1 hn.1]
  have hk : (channelK gamma p) ^ 2 = (1 - gamma) * ((1 - p) * p) := by
    dsimp [channelK]
    rw [mul_pow, Real.sq_sqrt (by linarith [hg.2]),
      Real.sq_sqrt (mul_nonneg (by linarith [hp.2]) hp.1)]
  refine ⟨mul_nonneg (by linarith) (by linarith [hp.2]),
    mul_nonneg (mul_nonneg hg.1 (by linarith [hn.2])) hp.1,
    mul_nonneg (mul_nonneg hg.1 hn.1) (by linarith [hp.2]),
    mul_nonneg (by linarith) hp.1, ?_, ?_, ?_⟩
  · dsimp [channelK]
    positivity
  · dsimp [channelCoeff]
    ring
  · dsimp [channelCoeff]
    rw [hk]
    ring

theorem channel_columns (gamma nu p : ℝ) :
    (channelCoeff gamma nu p).a + (channelCoeff gamma nu p).e = 1 - p ∧
    (channelCoeff gamma nu p).b + (channelCoeff gamma nu p).d = p := by
  constructor <;> dsimp [channelCoeff] <;> ring

theorem channel_scalar {gamma nu p : ℝ}
    (hg : gamma ≤ 1) (hp : 0 ≤ p ∧ p ≤ 1) :
    scalar (channelCoeff gamma nu p) (channelK gamma p) =
      gamma * nu * (1 - nu) + gamma * (1 - gamma) * (p - nu) ^ 2 := by
  dsimp [scalar, row0, row1, channelCoeff, channelK]
  rw [mul_pow, Real.sq_sqrt (by linarith),
    Real.sq_sqrt (mul_nonneg (by linarith [hp.2]) hp.1)]
  ring

theorem channel_entropy_lift
    {m n : Type*} [Fintype m] [Fintype n]
    (X Y : Matrix m n ℂ)
    (E : Matrix (m ⊕ m) (m ⊕ m) ℂ → ℝ) (sx sy : ℝ) (g : ℝ → ℝ)
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    (hc : ∀ (w z : ℝ) A B, 0 ≤ w → 0 ≤ z → w + z = 1 →
      State A → State B → w * E A + z * E B ≤ E (w • A + z • B))
    {gamma nu p : ℝ}
    (hg : 0 ≤ gamma ∧ gamma ≤ 1) (hn : 0 ≤ nu ∧ nu ≤ 1)
    (hp : 0 ≤ p ∧ p ≤ 1)
    (htri : ∀ t, Admissible t (channelK gamma p) →
      (t.b = 0 ∨ t.e = 0) →
      lower t (channelK gamma p) sx sy g ≤
        E (thermal X Y t (channelK gamma p))) :
    State (thermal X Y (channelCoeff gamma nu p) (channelK gamma p)) ∧
      (1 - p) * sx + p * sy +
        g (gamma * nu * (1 - nu) + gamma * (1 - gamma) * (p - nu) ^ 2) ≤
          E (thermal X Y (channelCoeff gamma nu p) (channelK gamma p)) := by
  have h := thermal_entropy_lift X Y E sx sy g hx hy hc
    (channel_admissible hg hn hp) htri
  refine ⟨h.1, ?_⟩
  have hb := h.2.2.2
  dsimp [lower] at hb
  rw [(channel_columns gamma nu p).1, (channel_columns gamma nu p).2,
    channel_scalar hg.2 hp] at hb
  exact hb

theorem channel_from_triangular
    {m n : Type*} [Fintype m] [Fintype n]
    (X Y : Matrix m n ℂ)
    (E : Matrix (m ⊕ m) (m ⊕ m) ℂ → ℝ)
    (S : Matrix m m ℂ → ℝ) (g : ℝ → ℝ)
    (hx : (X * Xᴴ).trace = 1) (hy : (Y * Yᴴ).trace = 1)
    (hc : ∀ (w z : ℝ) A B, 0 ≤ w → 0 ≤ z → w + z = 1 →
      State A → State B → w * E A + z * E B ≤ E (w • A + z • B))
    (htri : TriangularInput (n := n) E S g)
    (hswap : ∀ A, State A → E (A.submatrix Sum.swap Sum.swap) = E A)
    {gamma nu p : ℝ}
    (hg : 0 ≤ gamma ∧ gamma ≤ 1) (hn : 0 ≤ nu ∧ nu ≤ 1)
    (hp : 0 ≤ p ∧ p ≤ 1) :
    State (thermal X Y (channelCoeff gamma nu p) (channelK gamma p)) ∧
      (1 - p) * S (X * Xᴴ) + p * S (Y * Yᴴ) +
        g (gamma * nu * (1 - nu) + gamma * (1 - gamma) * (p - nu) ^ 2) ≤
          E (thermal X Y (channelCoeff gamma nu p) (channelK gamma p)) :=
  channel_entropy_lift X Y E (S (X * Xᴴ)) (S (Y * Yᴴ)) g hx hy hc hg hn hp
    (fun _ ht he => triangular_edges X Y E S g htri hswap hx hy ht he)

theorem kraus_channel_lift
    {i o l : Type*} [Fintype i] [Fintype o] [Fintype l] [DecidableEq i]
    (V : l → Matrix o i ℂ) (psi phi : Matrix i Unit ℂ)
    (hv : ∑ b, (V b)ᴴ * V b = 1)
    (hpsi : (psi * psiᴴ).trace = 1) (hphi : (phi * phiᴴ).trace = 1)
    (E : Matrix (o ⊕ o) (o ⊕ o) ℂ → ℝ)
    (S : Matrix o o ℂ → ℝ) (g : ℝ → ℝ)
    (hc : ∀ (w z : ℝ) A B, 0 ≤ w → 0 ≤ z → w + z = 1 →
      State A → State B → w * E A + z * E B ≤ E (w • A + z • B))
    (htri : TriangularInput (n := l) E S g)
    (hswap : ∀ A, State A → E (A.submatrix Sum.swap Sum.swap) = E A)
    {gamma nu p : ℝ}
    (hg : 0 ≤ gamma ∧ gamma ≤ 1) (hn : 0 ≤ nu ∧ nu ≤ 1)
    (hp : 0 ≤ p ∧ p ≤ 1) :
    let X := branchColumns V psi
    let Y := branchColumns V phi
    State (thermal X Y (channelCoeff gamma nu p) (channelK gamma p)) ∧
      (1 - p) * S (X * Xᴴ) + p * S (Y * Yᴴ) +
        g (gamma * nu * (1 - nu) + gamma * (1 - gamma) * (p - nu) ^ 2) ≤
          E (thermal X Y (channelCoeff gamma nu p) (channelK gamma p)) := by
  exact channel_from_triangular _ _ E S g
    (common_index_normalized V psi hv hpsi) (common_index_normalized V phi hv hphi)
    hc htri hswap hg hn hp

end ThermalLift
