import Mathlib

open scoped BigOperators
open Module Polynomial

noncomputable section

namespace MultiplicativeShiftOrder

variable {K : Type*} [Field K]

private theorem orders_linearIndependent {S : Set ℕ} (w : S → PowerSeries K)
    (hw : ∀ i, (w i).order = (i.val : ℕ∞)) :
    LinearIndependent K w := by
  classical
  rw [linearIndependent_iff']
  intro s a h i hi
  by_contra hai
  let t := s.filter (fun j => a j ≠ 0)
  have ht : t.Nonempty := ⟨i, Finset.mem_filter.mpr ⟨hi, hai⟩⟩
  let p := t.min' ht
  have hp : p ∈ t := Finset.min'_mem t ht
  have hps : p ∈ s := (Finset.mem_filter.mp hp).1
  have hpa : a p ≠ 0 := (Finset.mem_filter.mp hp).2
  have hs : (∑ j ∈ s, a j * PowerSeries.coeff p.val (w j)) =
      a p * PowerSeries.coeff p.val (w p) := by
    apply Finset.sum_eq_single p
    · intro j hj hjp
      by_cases haj : a j = 0
      · simp [haj]
      have hpj : p ≤ j := Finset.min'_le t j (Finset.mem_filter.mpr ⟨hj, haj⟩)
      have hpj' : p.val < j.val :=
        lt_of_le_of_ne hpj (fun h => hjp (Subtype.ext h.symm))
      rw [PowerSeries.coeff_of_lt_order p.val (by
        rw [hw j]
        exact_mod_cast hpj'), mul_zero]
    · exact fun h => (h hps).elim
  have hz := congrArg (PowerSeries.coeff p.val) h
  simp only [map_sum, PowerSeries.coeff_smul, smul_eq_mul, map_zero] at hz
  rw [hs] at hz
  exact mul_ne_zero hpa (PowerSeries.order_eq_nat.mp (hw p)).1 hz

/-- A finite-dimensional space of series has a basis indexed by all its possible orders. -/
theorem exists_order_basis (V : Submodule K (PowerSeries K)) [Module.Finite K V] :
    ∃ (k : ℕ) (b : Basis (Fin k) K V) (c : Fin k → ℕ),
      k = finrank K V ∧ Function.Injective c ∧
      (∀ i, (b i : PowerSeries K).order = (c i : ℕ∞)) ∧
      ∀ y : V, (y : PowerSeries K) ≠ 0 →
        (y : PowerSeries K).order ≤ ((∑ i, c i : ℕ) : ℕ∞) := by
  classical
  let S : Set ℕ := {n | ∃ f : V, (f : PowerSeries K).order = (n : ℕ∞)}
  choose w hw using (fun n : S => n.property)
  have hli : LinearIndependent K w :=
    LinearIndependent.of_comp V.subtype
      (orders_linearIndependent (fun n => (w n : PowerSeries K)) hw)
  letI : Finite S := hli.finite
  letI : Fintype S := Fintype.ofFinite S
  let L : V →ₗ[K] (S → K) :=
    { toFun := fun f n => PowerSeries.coeff n.val (f : PowerSeries K)
      map_add' := by intros; ext; simp
      map_smul' := by intros; ext; simp }
  have hL : Function.Injective L := by
    apply LinearMap.ker_eq_bot.mp
    rw [Submodule.eq_bot_iff]
    intro f hf
    by_contra hf'
    have hf0 : (f : PowerSeries K) ≠ 0 := by
      intro hz
      exact hf' (Subtype.ext hz)
    let n := (f : PowerSeries K).order.toNat
    have hn : n ∈ S := ⟨f, (PowerSeries.coe_toNat_order hf0).symm⟩
    have hz : PowerSeries.coeff n (f : PowerSeries K) = 0 :=
      congrFun hf ⟨n, hn⟩
    exact PowerSeries.coeff_order hf0 hz
  have hdim : finrank K V ≤ Fintype.card S := by
    simpa using LinearMap.finrank_le_finrank_of_injective hL
  have hcard : Fintype.card S = finrank K V :=
    le_antisymm hli.fintype_card_le_finrank hdim
  let b₀ : Basis S K V :=
    Basis.mk hli (hli.span_eq_top_of_card_eq_finrank' hcard).ge
  let e := Fintype.equivFin S
  refine ⟨Fintype.card S, b₀.reindex e, fun i => (e.symm i).val,
    hcard, ?_, ?_, ?_⟩
  · intro i j hij
    exact e.symm.injective (Subtype.ext hij)
  · intro i
    simpa [b₀] using hw (e.symm i)
  · intro y hy
    let n := (y : PowerSeries K).order.toNat
    have hn : n ∈ S := ⟨y, (PowerSeries.coe_toNat_order hy).symm⟩
    have hb : n ≤ ∑ i : Fin (Fintype.card S), (e.symm i).val := by
      have := Finset.single_le_sum
        (fun i (_ : i ∈ (Finset.univ : Finset (Fin (Fintype.card S)))) =>
          Nat.zero_le (e.symm i).val)
        (Finset.mem_univ (e ⟨n, hn⟩))
      simpa using this
    rw [← PowerSeries.coe_toNat_order hy]
    exact_mod_cast hb

def casoratian (τ : K) {k : ℕ} (w : Fin k → PowerSeries K) :
    Matrix (Fin k) (Fin k) (PowerSeries K) :=
  fun j i => PowerSeries.rescale (τ ^ j.val) (w i)

private theorem rescale_C (a b : K) :
    PowerSeries.rescale a (PowerSeries.C b) = PowerSeries.C b := by
  ext n
  cases n <;> simp [PowerSeries.coeff_rescale]

private theorem constantCoeff_rescale (a : K) (f : PowerSeries K) :
    PowerSeries.constantCoeff (PowerSeries.rescale a f) = PowerSeries.constantCoeff f := by
  simp [← PowerSeries.coeff_zero_eq_constantCoeff, PowerSeries.coeff_rescale]

/-- The leading Casoratian determinant is a Vandermonde, in every characteristic. -/
theorem casoratian_order {k : ℕ} (τ : K)
    (hτ : Function.Injective (fun n : ℕ => τ ^ n))
    (w : Fin k → PowerSeries K) (c : Fin k → ℕ) (hc : Function.Injective c)
    (hw : ∀ i, (w i).order = (c i : ℕ∞)) :
    (casoratian τ w).det.order = ((∑ i, c i : ℕ) : ℕ∞) := by
  classical
  let r : Fin k → PowerSeries K := fun i => (w i).divXPowOrder
  have hfac (i : Fin k) : w i = PowerSeries.X ^ c i * r i := by
    have hn : (w i).order.toNat = c i := by simp [hw i]
    simpa [r, hn] using (PowerSeries.X_pow_order_mul_divXPowOrder (f := w i)).symm
  have hr (i : Fin k) : PowerSeries.constantCoeff (r i) ≠ 0 := by
    have hwi : w i ≠ 0 := by
      intro hz
      simpa [hz] using hw i
    simpa [r, PowerSeries.constantCoeff_divXPowOrder] using PowerSeries.coeff_order hwi
  let A : Matrix (Fin k) (Fin k) (PowerSeries K) :=
    fun j i => PowerSeries.C ((τ ^ j.val) ^ c i) *
      PowerSeries.rescale (τ ^ j.val) (r i)
  have hmat : casoratian τ w =
      Matrix.of (fun j i => (PowerSeries.X : PowerSeries K) ^ c i * A j i) := by
    funext j i
    dsimp [casoratian, A]
    rw [hfac, map_mul, map_pow, PowerSeries.rescale_X, mul_pow, ← map_pow]
    ring
  have hA : PowerSeries.constantCoeff A.det ≠ 0 := by
    rw [RingHom.map_det]
    have he : (PowerSeries.constantCoeff.mapMatrix A) =
        Matrix.of (fun j i => PowerSeries.constantCoeff (r i) *
          (Matrix.vandermonde (fun i => τ ^ c i)).transpose j i) := by
      ext j i
      simp [A, Matrix.vandermonde_apply, ← pow_mul, mul_comm,
        constantCoeff_rescale]
    rw [he, Matrix.det_mul_row, Matrix.det_transpose]
    exact mul_ne_zero (Finset.prod_ne_zero_iff.mpr (fun i _ => hr i))
      (Matrix.det_vandermonde_ne_zero_iff.mpr (hτ.comp hc))
  have ho : A.det.order = 0 := by
    exact (PowerSeries.order_eq_nat.mpr ⟨by
      simpa [PowerSeries.coeff_zero_eq_constantCoeff] using hA, by simp⟩)
  rw [hmat, Matrix.det_mul_row, PowerSeries.order_mul, ho, add_zero,
    PowerSeries.order_prod]
  simp

private theorem det_mul_rect {R : Type*} [CommRing R]
    {n l : Type*} [Fintype n] [DecidableEq n] [Fintype l]
    (A : Matrix n l R) (B : Matrix l n R) :
    (A * B).det =
      ∑ f : n → l, (∏ i, B (f i) i) * (A.submatrix id f).det := by
  classical
  let F : MultilinearMap R (fun _ : n => n → R) R :=
    Matrix.detRowAlternating.toMultilinearMap
  have he := F.map_sum (fun i j => B j i • A.transpose j)
  have hleft : (fun i => ∑ j, B j i • A.transpose j) = (A * B).transpose := by
    funext i j
    simp [Matrix.mul_apply, Finset.sum_apply, mul_comm]
  rw [hleft] at he
  change (A * B).transpose.det =
    ∑ f : n → l, (Matrix.of (fun i j => B (f i) i * A j (f i))).det at he
  rw [Matrix.det_transpose] at he
  rw [he]
  apply Finset.sum_congr rfl
  intro f _
  rw [Matrix.det_mul_column]
  congr 1
  exact Matrix.det_transpose (A.submatrix id f)

private theorem exists_nonzero_minor {R : Type*} [CommRing R]
    {n l : Type*} [Fintype n] [DecidableEq n] [Fintype l]
    (A : Matrix n l R) (B : Matrix l n R) (h : (A * B).det ≠ 0) :
    ∃ f : n → l, (A.submatrix id f).det ≠ 0 := by
  classical
  by_contra hf
  push Not at hf
  apply h
  rw [det_mul_rect]
  simp [hf]

private theorem natDegree_det_le {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n K[X]) (d : n → ℕ) (h : ∀ i j, (A i j).natDegree ≤ d i) :
    A.det.natDegree ≤ ∑ i, d i := by
  classical
  rw [Matrix.det_apply]
  apply Polynomial.natDegree_sum_le_of_forall_le
  intro σ _
  calc
    (Equiv.Perm.sign σ • ∏ i, A (σ i) i).natDegree ≤
        (∏ i, A (σ i) i).natDegree := Polynomial.natDegree_smul_le _ _
    _ ≤ ∑ i, (A (σ i) i).natDegree := Polynomial.natDegree_prod_le _ _
    _ ≤ ∑ i, d (σ i) := Finset.sum_le_sum (fun i _ => h (σ i) i)
    _ = ∑ i, d i := Equiv.sum_comp σ d

private theorem polynomial_order_le (p : K[X]) (hp : (p : PowerSeries K) ≠ 0) :
    (p : PowerSeries K).order ≤ (p.natDegree : ℕ∞) := by
  apply PowerSeries.order_le
  have hp' : p ≠ 0 := by simpa using hp
  simpa only [Polynomial.coeff_coe, Polynomial.coeff_natDegree] using
    Polynomial.leadingCoeff_ne_zero.mpr hp'

def polyShift (a : K) : K[X] →+* K[X] :=
  Polynomial.compRingHom (Polynomial.C a * Polynomial.X)

private theorem coe_polyShift (a : K) (p : K[X]) :
    (polyShift a p : PowerSeries K) = PowerSeries.rescale a (p : PowerSeries K) := by
  ext n
  rw [PowerSeries.coeff_rescale]
  simp only [Polynomial.coeff_coe, polyShift, Polynomial.coe_compRingHom,
    Polynomial.comp_C_mul_X_coeff]
  exact mul_comm _ _

private theorem coe_poly_sum {ι : Type*} (s : Finset ι) (f : ι → K[X]) :
    ((∑ i ∈ s, f i : K[X]) : PowerSeries K) = ∑ i ∈ s, (f i : PowerSeries K) :=
  map_sum (Polynomial.coeToPowerSeries.ringHom : K[X] →+* PowerSeries K) f s

private theorem natDegree_polyShift_le (a : K) (p : K[X]) :
    (polyShift a p).natDegree ≤ p.natDegree := by
  change (p.comp (Polynomial.C a * Polynomial.X)).natDegree ≤ p.natDegree
  calc
    _ ≤ p.natDegree * (Polynomial.C a * Polynomial.X).natDegree :=
      Polynomial.natDegree_comp_le
    _ ≤ p.natDegree * 1 := Nat.mul_le_mul_left _
      ((Polynomial.natDegree_C_mul_le _ _).trans Polynomial.natDegree_X_le)
    _ = _ := Nat.mul_one _

def numeratorRows {m : ℕ} (τ : K) (P : Matrix (Fin m) (Fin m) K[X])
    (u : Fin m → K) : ℕ → Fin m → K[X]
  | 0 => fun i => Polynomial.C (u i)
  | j + 1 => fun i => ∑ a, polyShift τ (numeratorRows τ P u j a) * P a i

private theorem numeratorRows_degree {m ν : ℕ} (τ : K)
    (P : Matrix (Fin m) (Fin m) K[X]) (hP : ∀ i j, (P i j).natDegree ≤ ν)
    (u : Fin m → K) (j : ℕ) :
    ∀ i, (numeratorRows τ P u j i).natDegree ≤ j * ν := by
  induction j with
  | zero => intro i; simp [numeratorRows]
  | succ j ih =>
    intro i
    dsimp only [numeratorRows]
    apply Polynomial.natDegree_sum_le_of_forall_le
    intro a _
    calc
      _ ≤ (polyShift τ (numeratorRows τ P u j a)).natDegree +
          (P a i).natDegree := Polynomial.natDegree_mul_le
      _ ≤ j * ν + ν :=
        Nat.add_le_add ((natDegree_polyShift_le _ _).trans (ih a)) (hP a i)
      _ = (j + 1) * ν := by ring

def denominators (τ : K) (Q : K[X]) : ℕ → PowerSeries K
  | 0 => 1
  | j + 1 => PowerSeries.rescale τ (denominators τ Q j) * (Q : PowerSeries K)

private theorem denominators_constantCoeff (τ : K) (Q : K[X]) (j : ℕ) :
    PowerSeries.constantCoeff (denominators τ Q j) = Q.coeff 0 ^ j := by
  induction j with
  | zero => simp [denominators]
  | succ j ih => simp [denominators, constantCoeff_rescale, ih, pow_succ]

private theorem denominators_ne_zero (τ : K) (Q : K[X]) (hQ : Q.coeff 0 ≠ 0) (j : ℕ) :
    denominators τ Q j ≠ 0 := by
  intro hz
  have := denominators_constantCoeff τ Q j
  rw [hz, map_zero] at this
  exact pow_ne_zero j hQ this.symm

def outputRow {m : ℕ} (u : Fin m → K) (H : Matrix (Fin m) (Fin m) (PowerSeries K)) :
    Fin m → PowerSeries K :=
  fun i => ∑ a, PowerSeries.C (u a) * H a i

private theorem numeratorRows_identity {m : ℕ} (τ : K)
    (P : Matrix (Fin m) (Fin m) K[X]) (Q : K[X])
    (H : Matrix (Fin m) (Fin m) (PowerSeries K))
    (hsys : ∀ a i, (Q : PowerSeries K) * PowerSeries.rescale τ (H a i) =
      ∑ b, (P a b : PowerSeries K) * H b i)
    (u : Fin m → K) (j : ℕ) :
    ∀ i, (∑ a, (numeratorRows τ P u j a : PowerSeries K) * H a i) =
      denominators τ Q j * PowerSeries.rescale (τ ^ j) (outputRow u H i) := by
  classical
  induction j with
  | zero => intro i; simp [numeratorRows, denominators, outputRow, PowerSeries.rescale_one]
  | succ j ih =>
    intro i
    calc
      _ = ∑ b, (∑ a, PowerSeries.rescale τ
          (numeratorRows τ P u j a : PowerSeries K) * (P a b : PowerSeries K)) *
          H b i := by
        simp only [numeratorRows, coe_poly_sum, Polynomial.coe_mul, coe_polyShift]
      _ = ∑ a, PowerSeries.rescale τ (numeratorRows τ P u j a : PowerSeries K) *
          (∑ b, (P a b : PowerSeries K) * H b i) := by
        simp only [Finset.sum_mul, Finset.mul_sum, mul_assoc]
        rw [Finset.sum_comm]
      _ = ∑ a, PowerSeries.rescale τ (numeratorRows τ P u j a : PowerSeries K) *
          ((Q : PowerSeries K) * PowerSeries.rescale τ (H a i)) := by
        simp_rw [← hsys]
      _ = (Q : PowerSeries K) * PowerSeries.rescale τ
          (∑ a, (numeratorRows τ P u j a : PowerSeries K) * H a i) := by
        simp only [map_sum, map_mul, Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro a _
        ring
      _ = _ := by
        rw [ih]
        simp only [map_mul, PowerSeries.rescale_rescale, denominators, pow_succ]
        ring

private theorem order_bound_in_span {m ν : ℕ} (τ : K)
    (hτ : Function.Injective (fun n : ℕ => τ ^ n))
    (P : Matrix (Fin m) (Fin m) K[X]) (Q : K[X])
    (hQ : Q.coeff 0 ≠ 0) (hP : ∀ i j, (P i j).natDegree ≤ ν)
    (H J : Matrix (Fin m) (Fin m) (PowerSeries K)) (hHJ : H * J = 1)
    (hsys : ∀ a i, (Q : PowerSeries K) * PowerSeries.rescale τ (H a i) =
      ∑ b, (P a b : PowerSeries K) * H b i)
    (u : Fin m → K) (y : PowerSeries K)
    (hyV : y ∈ Submodule.span K (Set.range (outputRow u H))) (hy : y ≠ 0) :
    y.order ≤ ((ν * Nat.choose m 2 : ℕ) : ℕ∞) := by
  classical
  let g := outputRow u H
  let V := Submodule.span K (Set.range g)
  letI : Module.Finite K V := Module.Finite.span_of_finite K (Set.finite_range g)
  obtain ⟨k, b, c, hk, hc, hw, hbound⟩ := exists_order_basis V
  have hkm : k ≤ m := by
    rw [hk]
    simpa [V, Set.finrank] using (finrank_range_le_card (R := K) g)
  let w : Fin k → PowerSeries K := fun i => (b i : PowerSeries K)
  let W := casoratian τ w
  have hWo : W.det.order = ((∑ i, c i : ℕ) : ℕ∞) := casoratian_order τ hτ w c hc hw
  have hW : W.det ≠ 0 := by
    intro hz
    have ht : W.det.order = ⊤ := PowerSeries.order_eq_top.mpr hz
    rw [hWo] at ht
    exact ENat.coe_ne_top _ ht
  have hyo : y.order ≤ W.det.order := by
    rw [hWo]
    exact hbound ⟨y, hyV⟩ hy
  let A : Matrix (Fin k) (Fin m) (PowerSeries K) :=
    fun i a => PowerSeries.C (b.repr ⟨g a, Submodule.subset_span ⟨a, rfl⟩⟩ i)
  have hg (a : Fin m) : g a = ∑ i, A i a * w i := by
    have he := congrArg V.subtype
      (b.sum_repr ⟨g a, Submodule.subset_span ⟨a, rfl⟩⟩)
    simp only [map_sum, map_smul] at he
    simpa only [A, w, Submodule.subtype_apply, PowerSeries.smul_eq_C_mul] using he.symm
  have hex (i : Fin k) : ∃ l : Fin m → K, ∑ a, l a • g a = w i :=
    (Submodule.mem_span_range_iff_exists_fun K).mp (b i).property
  choose l hl using hex
  let L : Matrix (Fin m) (Fin k) (PowerSeries K) := fun a i => PowerSeries.C (l i a)
  have hwL (i : Fin k) : w i = ∑ a, g a * L a i := by
    rw [← hl i]
    simp only [PowerSeries.smul_eq_C_mul]
    apply Finset.sum_congr rfl
    intro a _
    exact mul_comm _ _
  let G : Matrix (Fin k) (Fin m) (PowerSeries K) :=
    fun j a => PowerSeries.rescale (τ ^ j.val) (g a)
  have hG : G = W * A := by
    funext j a
    change PowerSeries.rescale (τ ^ j.val) (g a) =
      ∑ i, PowerSeries.rescale (τ ^ j.val) (w i) * A i a
    rw [hg]
    simp only [map_sum, map_mul, A, rescale_C]
    apply Finset.sum_congr rfl
    intro i _
    exact mul_comm _ _
  have hWL : W = G * L := by
    funext j i
    change PowerSeries.rescale (τ ^ j.val) (w i) =
      ∑ a, PowerSeries.rescale (τ ^ j.val) (g a) * L a i
    rw [hwL]
    simp only [map_sum, map_mul, L, rescale_C]
  let N : Matrix (Fin k) (Fin m) K[X] := fun j a => numeratorRows τ P u j.val a
  let M : Matrix (Fin k) (Fin m) (PowerSeries K) :=
    N.map (fun p => (p : PowerSeries K))
  let D : Matrix (Fin k) (Fin k) (PowerSeries K) :=
    Matrix.diagonal (fun j => denominators τ Q j.val)
  have hNH : M * H = D * G := by
    funext j a
    change (∑ i, (numeratorRows τ P u j.val i : PowerSeries K) * H i a) =
      (Matrix.diagonal (fun j : Fin k => denominators τ Q j.val) * G) j a
    rw [Matrix.diagonal_mul]
    exact numeratorRows_identity τ P Q H hsys u j.val a
  have hMW : M * (H * L) = D * W := by
    rw [← Matrix.mul_assoc, hNH, Matrix.mul_assoc, ← hWL]
  have hDW : (D * W).det ≠ 0 := by
    rw [Matrix.det_mul, Matrix.det_diagonal]
    exact mul_ne_zero (Finset.prod_ne_zero_iff.mpr
      (fun j _ => denominators_ne_zero τ Q hQ j.val)) hW
  obtain ⟨f, hf⟩ := exists_nonzero_minor M (H * L) (by rwa [hMW])
  let B := A * J
  have hfactor : M = (D * W) * B := by
    calc
      M = M * (H * J) := by rw [hHJ, Matrix.mul_one]
      _ = (M * H) * J := (Matrix.mul_assoc M H J).symm
      _ = (D * G) * J := by rw [hNH]
      _ = (D * W) * B := by rw [hG]; simp only [B, Matrix.mul_assoc]
  have hminor : (M.submatrix id f).det =
      (D * W).det * (B.submatrix id f).det := by
    rw [show M.submatrix id f = (D * W) * (B.submatrix id f) from by
      rw [hfactor]
      rfl]
    exact Matrix.det_mul _ _
  have hminoro : W.det.order ≤ (M.submatrix id f).det.order := by
    rw [hminor, Matrix.det_mul, PowerSeries.order_mul, PowerSeries.order_mul]
    exact le_trans (le_add_of_nonneg_left (show 0 ≤ D.det.order from bot_le))
      (le_add_of_nonneg_right
        (show 0 ≤ (B.submatrix id f).det.order from bot_le))
  let p := (N.submatrix id f).det
  have hpcoe : (p : PowerSeries K) = (M.submatrix id f).det := by
    exact (Polynomial.coeToPowerSeries.ringHom : K[X] →+* PowerSeries K).map_det
      (N.submatrix id f)
  have hp : (p : PowerSeries K) ≠ 0 := by rwa [hpcoe]
  have hpdeg : p.natDegree ≤ ν * Nat.choose k 2 := by
    calc
      _ ≤ ∑ j : Fin k, j.val * ν :=
        natDegree_det_le (N.submatrix id f) (fun j => j.val * ν)
          (fun i j => numeratorRows_degree τ P hP u i.val (f j))
      _ = ν * Nat.choose k 2 := by
        rw [← Finset.sum_mul, Fin.sum_univ_eq_sum_range (fun j : ℕ => j) k, Finset.sum_range_id,
          Nat.choose_two_right, mul_comm]
  calc
    y.order ≤ W.det.order := hyo
    _ ≤ (M.submatrix id f).det.order := hminoro
    _ = (p : PowerSeries K).order := congrArg PowerSeries.order hpcoe.symm
    _ ≤ (p.natDegree : ℕ∞) := polynomial_order_le p hp
    _ ≤ ((ν * Nat.choose k 2 : ℕ) : ℕ∞) := by exact_mod_cast hpdeg
    _ ≤ ((ν * Nat.choose m 2 : ℕ) : ℕ∞) := by
      exact_mod_cast Nat.mul_le_mul_left ν (Nat.choose_le_choose 2 hkm)

/-- The arbitrary-field multiplicative-shift order theorem, with an explicit series inverse. -/
theorem multiplicative_shift_order {m ν : ℕ} (_hm : 1 ≤ m)
    (τ : K) (_hτ0 : τ ≠ 0) (hτ : Function.Injective (fun n : ℕ => τ ^ n))
    (P : Matrix (Fin m) (Fin m) K[X]) (Q : K[X])
    (hQ0 : Q.coeff 0 ≠ 0) (_hQdeg : Q.natDegree ≤ ν)
    (hP : ∀ i j, (P i j).natDegree ≤ ν)
    (H J : Matrix (Fin m) (Fin m) (PowerSeries K))
    (hHJ : H * J = 1) (_hJH : J * H = 1)
    (hsys : (fun i j => (Q : PowerSeries K) * PowerSeries.rescale τ (H i j)) =
      P.map (fun p => (p : PowerSeries K)) * H)
    (u v : Fin m → K)
    (hy : (∑ i, ∑ j, PowerSeries.C (u i) * H i j * PowerSeries.C (v j)) ≠ 0) :
    (∑ i, ∑ j, PowerSeries.C (u i) * H i j * PowerSeries.C (v j)).order ≤
      ((ν * Nat.choose m 2 : ℕ) : ℕ∞) := by
  classical
  apply order_bound_in_span τ hτ P Q hQ0 hP H J hHJ
    (fun a i => congrFun (congrFun hsys a) i) u _ _ hy
  have he :
      (∑ i, ∑ j, PowerSeries.C (u i) * H i j * PowerSeries.C (v j)) =
      ∑ j, v j • outputRow u H j := by
    simp only [PowerSeries.smul_eq_C_mul, outputRow, Finset.mul_sum]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro j _
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [he]
  exact Submodule.sum_mem _ (fun j _ => Submodule.smul_mem _ _
    (Submodule.subset_span ⟨j, rfl⟩))

/-- Infinite multiplicative order of a unit is exactly injectivity of its natural powers in `K`. -/
theorem infinite_order_iff_injective_powers (τ : Kˣ) :
    orderOf τ = 0 ↔ Function.Injective (fun n : ℕ => (τ : K) ^ n) := by
  rw [orderOf_eq_zero_iff, ← injective_pow_iff_not_isOfFinOrder]
  constructor
  · intro h a b hab
    apply h
    exact Units.ext (by simpa using hab)
  · intro h a b hab
    apply h
    simpa using congrArg (fun x : Kˣ => (x : K)) hab

#print axioms multiplicative_shift_order

end MultiplicativeShiftOrder
