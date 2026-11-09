import Mathlib

open scoped BigOperators

noncomputable section

namespace QuotientUniform

attribute [local instance] Classical.propDecidable

theorem shifted_cartesian_sum
    {A B R : Type*} [Fintype A] [Fintype B] [AddGroup A] [AddGroup B]
    [Semiring R] (L : A → R) (T : B → R) (v : A) (u : B) :
    (∑ a, ∑ b, L (a + v) * T (b + u)) = (∑ a, L a) * (∑ b, T b) := by
  have hL : (∑ a, L (a + v)) = ∑ a, L a := Equiv.sum_comp (Equiv.addRight v) L
  have hT : (∑ b, T (b + u)) = ∑ b, T b := Equiv.sum_comp (Equiv.addRight u) T
  rw [← Finset.sum_mul_sum, hL, hT]

theorem coordinate_block_factorization
    {I A B U V R : Type*} [Fintype I] [Fintype A] [Fintype B]
    [AddGroup A] [AddGroup B] [Semiring R]
    (e : I ≃ A × B) (L : U → A → R) (T : V → B → R)
    (shiftA : V → A) (shiftB : U → B) (u : U) (v : V) :
    (∑ i, L u ((e i).1 + shiftA v) * T v ((e i).2 + shiftB u)) =
      (∑ a, L u a) * (∑ b, T v b) := by
  calc
    _ = ∑ a, ∑ b, L u (a + shiftA v) * T v (b + shiftB u) := by
      simpa only [Fintype.sum_prod_type] using
        e.sum_comp (fun ab => L u (ab.1 + shiftA v) * T v (ab.2 + shiftB u))
    _ = _ := shifted_cartesian_sum (L u) (T v) (shiftA v) (shiftB u)

section Regular

variable {G : Type*} [Group G] [Fintype G] [DecidableEq G]

def regular (g : G) : Matrix G G ℤ := fun x y => if x = g * y then 1 else 0

theorem regular_mul (g h : G) : regular g * regular h = regular (g * h) := by
  ext x y
  simp only [Matrix.mul_apply, regular]
  rw [Finset.sum_eq_single (h * y)]
  · simp [mul_assoc]
  · intro b _ hb
    simp [hb]
  · simp

omit [Fintype G] in
theorem regular_transpose (g : G) : (regular g).transpose = regular g⁻¹ := by
  ext x y
  change (if y = g * x then (1 : ℤ) else 0) = if x = g⁻¹ * y then 1 else 0
  by_cases hy : y = g * x
  · simp [hy]
  · have hx : x ≠ g⁻¹ * y := by
      intro hx
      apply hy
      rw [hx]
      simp
    simp [hy, hx]

theorem regular_trace (g : G) :
    (regular g).trace = if g = 1 then (Fintype.card G : ℤ) else 0 := by
  classical
  by_cases hg : g = 1
  · subst g
    simp [Matrix.trace, regular]
  · have hfix : ∀ x : G, x ≠ g * x := by
      intro x hx
      apply hg
      have he : (1 : G) * x = g * x := by simpa using hx
      exact (mul_right_cancel he).symm
    simp [Matrix.trace, regular, hg, hfix]

theorem rectangle_trace (a b c d : G) :
    (regular a * (regular b).transpose * regular c * (regular d).transpose).trace =
      if a * b⁻¹ * c * d⁻¹ = 1 then (Fintype.card G : ℤ) else 0 := by
  simp only [regular_transpose, regular_mul, regular_trace]

theorem first_trace_sum (r : ℕ) (g : Fin r → Fin r → G) :
    (∑ u, ∑ v, (regular (g u v) * (regular (g u v)).transpose).trace) =
      (r : ℤ) ^ 2 * Fintype.card G := by
  simp [regular_transpose, regular_mul, regular_trace]
  ring

theorem rectangle_trace_degeneracy (r : ℕ) (g : Fin r → Fin r → G)
    (hrect : ∀ u u' v v', u ≠ u' → v ≠ v' →
      g u v * (g u' v)⁻¹ * g u' v' * (g u v')⁻¹ ≠ 1)
    (u u' v v' : Fin r) :
    (regular (g u v) * (regular (g u' v)).transpose *
        regular (g u' v') * (regular (g u v')).transpose).trace =
      if u = u' ∨ v = v' then (Fintype.card G : ℤ) else 0 := by
  rw [rectangle_trace]
  by_cases hu : u = u'
  · subst u'
    simp
  · by_cases hv : v = v'
    · subst v'
      simp
    · simp [hu, hv, hrect u u' v v' hu hv]

theorem second_trace_sum (r : ℕ) (g : Fin r → Fin r → G)
    (hrect : ∀ u u' v v', u ≠ u' → v ≠ v' →
      g u v * (g u' v)⁻¹ * g u' v' * (g u v')⁻¹ ≠ 1) :
    (∑ u, ∑ u', ∑ v, ∑ v',
      (regular (g u v) * (regular (g u' v)).transpose *
        regular (g u' v') * (regular (g u v')).transpose).trace) =
      (2 * (r : ℤ) ^ 3 - (r : ℤ) ^ 2) * Fintype.card G := by
  classical
  simp_rw [rectangle_trace_degeneracy r g hrect]
  have hor (u u' v v' : Fin r) :
      (if u = u' ∨ v = v' then (Fintype.card G : ℤ) else 0) =
        (if u = u' then (Fintype.card G : ℤ) else 0) +
        (if v = v' then (Fintype.card G : ℤ) else 0) -
        (if u = u' ∧ v = v' then (Fintype.card G : ℤ) else 0) := by
    split_ifs <;> omega
  simp_rw [hor, Finset.sum_sub_distrib, Finset.sum_add_distrib]
  simp [ite_and]
  ring

end Regular

section Interpolation

variable {F : Type*} [Field F]

def lagrange (S : Finset F) (a : F) : Polynomial F := by
  classical
  exact ∏ b ∈ S.erase a, Polynomial.C (a - b)⁻¹ * (Polynomial.X - Polynomial.C b)

theorem lagrange_eval_self (S : Finset F) (a : F) :
    (lagrange S a).eval a = 1 := by
  classical
  simp only [lagrange, Polynomial.eval_prod, Polynomial.eval_mul, Polynomial.eval_C,
    Polynomial.eval_sub, Polynomial.eval_X]
  apply Finset.prod_eq_one
  intro b hb
  exact inv_mul_cancel₀ (sub_ne_zero.mpr (Ne.symm (Finset.mem_erase.mp hb).1))

theorem lagrange_eval_other (S : Finset F) (a b : F) (hb : b ∈ S) (hba : b ≠ a) :
    (lagrange S a).eval b = 0 := by
  classical
  simp only [lagrange, Polynomial.eval_prod, Polynomial.eval_mul, Polynomial.eval_C,
    Polynomial.eval_sub, Polynomial.eval_X]
  exact Finset.prod_eq_zero (Finset.mem_erase.mpr ⟨hba, hb⟩) (by simp)

theorem lagrange_degree (S : Finset F) (a : F) (ha : a ∈ S) :
    (lagrange S a).natDegree ≤ S.card - 1 := by
  classical
  apply (Polynomial.natDegree_prod_le _ _).trans
  calc
    _ ≤ ∑ _b ∈ S.erase a, 1 := by
      apply Finset.sum_le_sum
      intro b _
      exact Polynomial.natDegree_mul_le.trans (by simp)
    _ = S.card - 1 := by simp [Finset.card_erase_of_mem ha]

def onLine (p : Polynomial F) (a d : F) : Polynomial F :=
  p.comp (Polynomial.C a + Polynomial.C d * Polynomial.X)

theorem onLine_degree (p : Polynomial F) (a d : F) :
    (onLine p a d).natDegree ≤ p.natDegree := by
  have hl : (Polynomial.C a + Polynomial.C d * Polynomial.X).natDegree ≤ 1 := by
    apply (Polynomial.natDegree_add_le _ _).trans
    simp only [Polynomial.natDegree_C, max_le_iff, zero_le, true_and]
    exact Polynomial.natDegree_mul_le.trans (by simp)
  exact Polynomial.natDegree_comp_le.trans (by
    simpa using Nat.mul_le_mul_left p.natDegree hl)

def gridEval {h : ℕ} (S : Finset F) (a z : Fin h → F) : F :=
  ∏ k, (lagrange S (a k)).eval (z k)

def linePoint {h : ℕ} (a d : Fin h → F) (t : F) : Fin h → F :=
  fun k => a k + d k * t

def gridOnLine {h : ℕ} (S : Finset F) (a z d : Fin h → F) : Polynomial F :=
  ∏ k, onLine (lagrange S (a k)) (z k) (d k)

theorem gridOnLine_eval {h : ℕ} (S : Finset F) (a z d : Fin h → F) (t : F) :
    (gridOnLine S a z d).eval t = gridEval S a (linePoint z d t) := by
  simp [gridOnLine, gridEval, linePoint, onLine, Polynomial.eval_prod,
    Polynomial.eval_comp]

theorem gridOnLine_degree {h : ℕ} (S : Finset F) (a z d : Fin h → F)
    (ha : ∀ k, a k ∈ S) :
    (gridOnLine S a z d).natDegree ≤ h * (S.card - 1) := by
  apply (Polynomial.natDegree_prod_le _ _).trans
  calc
    _ ≤ ∑ _k : Fin h, (S.card - 1) := by
      apply Finset.sum_le_sum
      intro k _
      exact (onLine_degree _ _ _).trans (lagrange_degree S (a k) (ha k))
    _ = h * (S.card - 1) := by simp

theorem gridEval_delta {h : ℕ} (S : Finset F) (a b : Fin h → F)
    (hb : ∀ k, b k ∈ S) :
    gridEval S a b = if a = b then 1 else 0 := by
  classical
  by_cases hab : a = b
  · subst b
    simp [gridEval, lagrange_eval_self]
  · rw [if_neg hab]
    obtain ⟨k, hk⟩ := Function.ne_iff.mp hab
    exact Finset.prod_eq_zero (Finset.mem_univ k)
      (lagrange_eval_other S (a k) (b k) (hb k) (Ne.symm hk))

variable [Fintype F]

theorem polynomial_sum_zero (p : Polynomial F) (hd : p.natDegree < Fintype.card F - 1) :
    ∑ t : F, p.eval t = 0 := by
  classical
  simp_rw [Polynomial.eval_eq_sum_range]
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro n hn
  rw [← Finset.mul_sum, FiniteField.sum_pow_lt_card_sub_one F n, mul_zero]
  exact lt_of_le_of_lt (Nat.lt_succ_iff.mp (Finset.mem_range.mp hn)) hd

theorem punctured_polynomial_sum (p : Polynomial F)
    (hd : p.natDegree < Fintype.card F - 1) :
    (∑ t ∈ Finset.univ.erase (0 : F), p.eval t) = -p.eval 0 := by
  classical
  have hs := Finset.sum_erase_add Finset.univ (fun t => p.eval t) (Finset.mem_univ 0)
  rw [polynomial_sum_zero p hd] at hs
  exact eq_neg_of_add_eq_zero_left hs

def gridWeight {h : ℕ} {I : Type*} (S : Finset F) (marks : I → Fin h → F)
    (z : Fin h → F) : Matrix I I F :=
  fun j k => gridEval S (marks j) z * gridEval S (marks k) z

theorem punctured_grid_weight {h : ℕ} {I : Type*}
    (S : Finset F) (marks : I → Fin h → F) (hinj : Function.Injective marks)
    (hm : ∀ i k, marks i k ∈ S)
    (hdeg : 2 * h * (S.card - 1) < Fintype.card F - 1)
    (i j k : I) (d : Fin h → F) :
    (∑ t ∈ Finset.univ.erase (0 : F),
      gridWeight S marks (linePoint (marks i) d t) j k) =
      -(if j = i ∧ k = i then 1 else 0) := by
  classical
  let p := gridOnLine S (marks j) (marks i) d * gridOnLine S (marks k) (marks i) d
  have hp : p.natDegree < Fintype.card F - 1 := by
    have hj := gridOnLine_degree S (marks j) (marks i) d (hm j)
    have hk := gridOnLine_degree S (marks k) (marks i) d (hm k)
    have hm' := Polynomial.natDegree_mul_le
      (p := gridOnLine S (marks j) (marks i) d)
      (q := gridOnLine S (marks k) (marks i) d)
    dsimp [p]
    nlinarith
  have hs := punctured_polynomial_sum p hp
  simp only [p, Polynomial.eval_mul, gridOnLine_eval, gridWeight] at hs ⊢
  have hzero : linePoint (marks i) d 0 = marks i := by ext a; simp [linePoint]
  rw [hzero, gridEval_delta S _ _ (hm i), gridEval_delta S _ _ (hm i)] at hs
  by_cases hji : j = i <;> by_cases hki : k = i <;>
    simpa [hinj.eq_iff, hji, hki] using hs

omit [Fintype F] in
theorem linePoint_injective {h : ℕ} (a d : Fin h → F) (hd : ∃ k, d k ≠ 0) :
    Function.Injective (linePoint a d) := by
  obtain ⟨k, hk⟩ := hd
  intro s t he
  have hc := congrFun he k
  dsimp [linePoint] at hc
  exact mul_left_cancel₀ hk (add_left_cancel hc)

def puncturedLine {h : ℕ} (a d : Fin h → F) : Finset (Fin h → F) := by
  classical
  exact (Finset.univ.erase (0 : F)).image (linePoint a d)

theorem punctured_grid_weight_line {h : ℕ} {I : Type*}
    (S : Finset F) (marks : I → Fin h → F) (hinj : Function.Injective marks)
    (hm : ∀ i k, marks i k ∈ S)
    (hdeg : 2 * h * (S.card - 1) < Fintype.card F - 1)
    (i j k : I) (d : Fin h → F) (hd : ∃ a, d a ≠ 0) :
    (∑ z ∈ puncturedLine (marks i) d, gridWeight S marks z j k) =
      -(if j = i ∧ k = i then 1 else 0) := by
  classical
  rw [puncturedLine, Finset.sum_image]
  · exact punctured_grid_weight S marks hinj hm hdeg i j k d
  · intro s _ t _ he
    exact linePoint_injective (marks i) d hd he

end Interpolation

theorem incidence_exchange {P I R : Type*} [Fintype P] [Fintype I] [DecidableEq P] [Ring R]
    (lines : I → Finset P) (H : P → R) (Y : I → R) :
    (∑ z, H z * (∑ i, if z ∈ lines i then Y i else 0)) =
      ∑ i, (∑ z ∈ lines i, H z) * Y i := by
  calc
    _ = ∑ z, ∑ i, if z ∈ lines i then H z * Y i else 0 := by
      simp_rw [Finset.mul_sum, mul_ite, mul_zero]
    _ = ∑ i, ∑ z, if z ∈ lines i then H z * Y i else 0 := Finset.sum_comm
    _ = ∑ i, ∑ z ∈ lines i, H z * Y i := by
      simp_rw [Finset.sum_ite_mem, Finset.univ_inter]
    _ = _ := by simp_rw [Finset.sum_mul]

theorem weighted_tensor_identity
    {P I A B F : Type*} [Fintype P] [Fintype I] [DecidableEq P] [DecidableEq I] [Field F]
    (lines : I → Finset P) (H : P → Matrix I I F) (Y : I → Matrix A B F)
    (hline : ∀ i j k, (∑ z ∈ lines i, H z j k) =
      -(if j = i ∧ k = i then 1 else 0)) :
    (∑ z, Matrix.kronecker (H z) (∑ i, if z ∈ lines i then Y i else 0)) =
      fun ja kb => if ja.1 = kb.1 then -Y ja.1 ja.2 kb.2 else 0 := by
  ext ⟨j, a⟩ ⟨k, b⟩
  simp only [Matrix.sum_apply, Matrix.kronecker, Matrix.kroneckerMap_apply,
    Matrix.ite_apply, Matrix.zero_apply]
  rw [incidence_exchange lines (fun z => H z j k) (fun i => Y i a b)]
  simp_rw [hline]
  by_cases hjk : j = k
  · subst k
    simp
  · rw [if_neg hjk]
    apply Finset.sum_eq_zero
    intro i _
    by_cases hji : j = i
    · subst i
      simp [Ne.symm hjk]
    · simp [hji]

theorem interpolation_tensor_identity
    {F I A B : Type*} [Field F] [Fintype F] [Fintype I] {h : ℕ}
    (S : Finset F) (marks directions : I → Fin h → F)
    (hinj : Function.Injective marks) (hm : ∀ i k, marks i k ∈ S)
    (hd : ∀ i, ∃ k, directions i k ≠ 0)
    (hdeg : 2 * h * (S.card - 1) < Fintype.card F - 1)
    (Y : I → Matrix A B F) :
    (∑ z : Fin h → F, Matrix.kronecker (gridWeight S marks z)
      (∑ i, if z ∈ puncturedLine (marks i) (directions i) then Y i else 0)) =
      fun ja kb => if ja.1 = kb.1 then -Y ja.1 ja.2 kb.2 else 0 := by
  exact weighted_tensor_identity (P := Fin h → F) (I := I) (A := A) (B := B) (F := F)
    (fun i => puncturedLine (marks i) (directions i)) (gridWeight S marks) Y
    (fun i j k => punctured_grid_weight_line S marks hinj hm hdeg i j k
      (directions i) (hd i))

theorem finite_product_quantifier
    {G I : Type u} [Group G] [Fintype I] (w : I → G)
    (hnosep : ∀ (Q : Type u) [Group Q] [Fintype Q] (f : G →* Q),
      ∃ i, f (w i) = 1) :
    ∃ i, ∀ (Q : Type u) [Group Q] [Fintype Q] (f : G →* Q), f (w i) = 1 := by
  classical
  by_contra hn
  push Not at hn
  choose Q instG instF f hf using hn
  letI : ∀ i, Group (Q i) := instG
  letI : ∀ i, Fintype (Q i) := instF
  let productMap : G →* (∀ i, Q i) := MonoidHom.pi f
  obtain ⟨i, hi⟩ := hnosep (∀ i, Q i) productMap
  exact hf i (congrFun hi i)

end QuotientUniform
