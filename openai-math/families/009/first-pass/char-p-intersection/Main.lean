import Mathlib

open scoped BigOperators
open Module

namespace CharPIntersection

variable {k F : Type*} [Field k] [Field F] [Algebra k F]
variable {p : ℕ} [Fact p.Prime] [CharP F p]

def monomial (X Y : F) (i : Fin p × Fin p) : F :=
  X ^ i.1.val * Y ^ i.2.val

def monomialSpan (X Y : F) : Submodule k F :=
  Submodule.span k (Set.range (monomial (p := p) X Y))

lemma power_reduce (x : F) (c : k) (hc : x ^ p = algebraMap k F c) (a : ℕ) :
    x ^ a = (algebraMap k F c) ^ (a / p) * x ^ (a % p) := by
  conv_lhs => rw [← Nat.mod_add_div a p]
  rw [pow_add, pow_mul, hc]
  ring

lemma monomial_product (X Y : F) (cx cy : k)
    (hx : X ^ p = algebraMap k F cx) (hy : Y ^ p = algebraMap k F cy)
    (i j : Fin p × Fin p) :
    monomial X Y i * monomial X Y j =
      (cx ^ ((i.1.val + j.1.val) / p) * cy ^ ((i.2.val + j.2.val) / p)) •
        monomial X Y
          (⟨(i.1.val + j.1.val) % p, Nat.mod_lt _ (Fact.out : p.Prime).pos⟩,
           ⟨(i.2.val + j.2.val) % p, Nat.mod_lt _ (Fact.out : p.Prime).pos⟩) := by
  simp only [monomial, Algebra.smul_def, map_mul, map_pow]
  calc
    X ^ i.1.val * Y ^ i.2.val * (X ^ j.1.val * Y ^ j.2.val) =
        X ^ (i.1.val + j.1.val) * Y ^ (i.2.val + j.2.val) := by
          simp only [pow_add]
          ring
    _ = _ := by
      rw [power_reduce X cx hx, power_reduce Y cy hy]
      ring

lemma one_mem_span (X Y : F) : (1 : F) ∈ monomialSpan (k := k) (p := p) X Y := by
  let z : Fin p := ⟨0, (Fact.out : p.Prime).pos⟩
  have h := Submodule.subset_span (R := k)
    (Set.mem_range_self (f := monomial X Y) (z, z))
  simpa [monomialSpan, monomial, z] using h

lemma mul_mem_span (X Y : F) (cx cy : k)
    (hx : X ^ p = algebraMap k F cx) (hy : Y ^ p = algebraMap k F cy)
    {u v : F} (hu : u ∈ monomialSpan (k := k) (p := p) X Y)
    (hv : v ∈ monomialSpan (k := k) (p := p) X Y) :
    u * v ∈ monomialSpan (k := k) (p := p) X Y := by
  induction hu using Submodule.span_induction with
  | mem u hu =>
      rcases hu with ⟨i, rfl⟩
      induction hv using Submodule.span_induction with
      | mem v hv =>
          rcases hv with ⟨j, rfl⟩
          rw [monomial_product X Y cx cy hx hy i j]
          exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨_, rfl⟩)
      | zero => simpa using (monomialSpan (k := k) (p := p) X Y).zero_mem
      | add u v _ _ hu hv =>
          simpa [mul_add] using (monomialSpan (k := k) (p := p) X Y).add_mem hu hv
      | smul a u _ hu =>
          simpa [Algebra.mul_smul_comm] using
            (monomialSpan (k := k) (p := p) X Y).smul_mem a hu
  | zero => simpa using (monomialSpan (k := k) (p := p) X Y).zero_mem
  | add u v _ _ hu hv =>
      simpa [add_mul] using (monomialSpan (k := k) (p := p) X Y).add_mem hu hv
  | smul a u _ hu =>
      simpa [Algebra.smul_mul_assoc] using
        (monomialSpan (k := k) (p := p) X Y).smul_mem a hu

lemma pow_mem_span (X Y : F) (cx cy : k)
    (hx : X ^ p = algebraMap k F cx) (hy : Y ^ p = algebraMap k F cy)
    {u : F} (hu : u ∈ monomialSpan (k := k) (p := p) X Y) (n : ℕ) :
    u ^ n ∈ monomialSpan (k := k) (p := p) X Y := by
  induction n with
  | zero => simpa using one_mem_span (k := k) (p := p) X Y
  | succ n ih =>
      simpa [pow_succ] using mul_mem_span X Y cx cy hx hy ih hu

lemma inv_mem_span (X Y : F) (cx cy : k)
    (hx : X ^ p = algebraMap k F cx) (hy : Y ^ p = algebraMap k F cy)
    (hpowers : ∀ z : F, ∃ c : k, z ^ p = algebraMap k F c)
    {u : F} (hu : u ∈ monomialSpan (k := k) (p := p) X Y) :
    u⁻¹ ∈ monomialSpan (k := k) (p := p) X Y := by
  by_cases hz : u = 0
  · simpa [hz] using (monomialSpan (k := k) (p := p) X Y).zero_mem
  obtain ⟨c, hc⟩ := hpowers u
  have hcp : algebraMap k F c ≠ 0 := hc ▸ pow_ne_zero p hz
  have he : u⁻¹ = c⁻¹ • u ^ (p - 1) := by
    apply (mul_left_injective₀ hz)
    simp only [inv_mul_cancel₀ hz, Algebra.smul_def, map_inv₀]
    rw [mul_assoc, ← pow_succ, Nat.sub_add_cancel (Fact.out : p.Prime).pos,
      hc, inv_mul_cancel₀ hcp]
  rw [he]
  exact Submodule.smul_mem _ _ (pow_mem_span X Y cx cy hx hy hu _)

def coordinateField (X Y : F) (cx cy : k)
    (hx : X ^ p = algebraMap k F cx) (hy : Y ^ p = algebraMap k F cy)
    (hpowers : ∀ z : F, ∃ c : k, z ^ p = algebraMap k F c) :
    IntermediateField k F where
  carrier := monomialSpan (k := k) (p := p) X Y
  zero_mem' := (monomialSpan (k := k) (p := p) X Y).zero_mem
  add_mem' := (monomialSpan (k := k) (p := p) X Y).add_mem
  one_mem' := one_mem_span (k := k) (p := p) X Y
  mul_mem' := mul_mem_span X Y cx cy hx hy
  algebraMap_mem' c := by
    simpa [Algebra.smul_def] using
      (monomialSpan (k := k) (p := p) X Y).smul_mem c
        (one_mem_span (k := k) (p := p) X Y)
  inv_mem' _ hu := inv_mem_span X Y cx cy hx hy hpowers hu

lemma coordinateField_eq_adjoin (X Y : F) (cx cy : k)
    (hx : X ^ p = algebraMap k F cx) (hy : Y ^ p = algebraMap k F cy)
    (hpowers : ∀ z : F, ∃ c : k, z ^ p = algebraMap k F c) :
    coordinateField X Y cx cy hx hy hpowers =
      IntermediateField.adjoin k ({X, Y} : Set F) := by
  apply le_antisymm
  · intro z hz
    change z ∈ (IntermediateField.adjoin k ({X, Y} : Set F)).toSubalgebra.toSubmodule
    apply Submodule.span_le.mpr ?_ hz
    rintro z ⟨i, rfl⟩
    change monomial X Y i ∈ IntermediateField.adjoin k ({X, Y} : Set F)
    exact mul_mem
      (pow_mem (IntermediateField.subset_adjoin k _ (by simp)) _)
      (pow_mem (IntermediateField.subset_adjoin k _ (by simp)) _)
  · apply IntermediateField.adjoin_le_iff.mpr
    intro z hz
    have hp : 1 < p := (Fact.out : p.Prime).one_lt
    change z ∈ monomialSpan (k := k) (p := p) X Y
    rcases Set.mem_insert_iff.mp hz with hz | hz
    · rw [hz]
      have h := Submodule.subset_span (R := k)
        (Set.mem_range_self (f := monomial X Y)
          (⟨1, hp⟩, ⟨0, (Fact.out : p.Prime).pos⟩))
      simpa [monomialSpan, monomial] using h
    · rw [Set.mem_singleton_iff.mp hz]
      have h := Submodule.subset_span (R := k)
        (Set.mem_range_self (f := monomial X Y)
          (⟨0, (Fact.out : p.Prime).pos⟩, ⟨1, hp⟩))
      simpa [monomialSpan, monomial] using h

section Diagonal

variable {ι : Type*} [Fintype ι]

noncomputable def diagonal (b : Basis ι k F) (w : ι → k) : F →ₗ[k] F :=
  b.constr k (fun i => w i • b i)

@[simp] lemma diagonal_basis (b : Basis ι k F) (w : ι → k) (i : ι) :
    diagonal b w (b i) = w i • b i :=
  b.constr_basis k _ i

lemma diagonal_repr (b : Basis ι k F) (w : ι → k) (z : F) (i : ι) :
    b.repr (diagonal b w z) i = w i * b.repr z i := by
  have h : diagonal b w z = ∑ j, (b.repr z j * w j) • b j := by
    calc
      diagonal b w z = diagonal b w (∑ j, b.repr z j • b j) := by
        rw [b.sum_repr]
      _ = _ := by simp only [map_sum, map_smul, diagonal_basis, smul_smul]
  rw [h, b.repr_sum_self]
  exact mul_comm _ _

lemma diagonal_commute (b : Basis ι k F) (w v : ι → k) (z : F) :
    diagonal b w (diagonal b v z) = diagonal b v (diagonal b w z) := by
  have h : (diagonal b w).comp (diagonal b v) =
      (diagonal b v).comp (diagonal b w) := by
    apply b.ext
    intro i
    simp [smul_smul, mul_comm]
  exact LinearMap.congr_fun h z

def leibnizDefect (D : F →ₗ[k] F) : F →ₗ[k] F →ₗ[k] F :=
  LinearMap.mk₂ k (fun u v => D (u * v) - u * D v - v * D u)
    (by intros; simp only [add_mul, map_add]; ring)
    (by
      intros
      simp only [Algebra.smul_mul_assoc, map_smul, Algebra.mul_smul_comm]
      simp only [Algebra.smul_def]
      ring)
    (by intros; simp only [mul_add, map_add]; ring)
    (by
      intros
      simp only [Algebra.smul_mul_assoc, map_smul, Algebra.mul_smul_comm]
      simp only [Algebra.smul_def]
      ring)

lemma leibniz_of_basis (b : Basis ι k F) (D : F →ₗ[k] F)
    (h : ∀ i j, D (b i * b j) = b i * D (b j) + b j * D (b i)) (u v : F) :
    D (u * v) = u * D v + v * D u := by
  have hz : leibnizDefect D = 0 := by
    apply b.ext
    intro i
    apply b.ext
    intro j
    change D (b i * b j) - b i * D (b j) - b j * D (b i) = 0
    rw [h]
    ring
  have hh := congrArg (fun f : F →ₗ[k] F →ₗ[k] F => f u v) hz
  change D (u * v) - u * D v - v * D u = 0 at hh
  linear_combination hh

end Diagonal

section Euler

variable [CharP k p]
variable (X Y : F) (cx cy : k)
variable (hx : X ^ p = algebraMap k F cx) (hy : Y ^ p = algebraMap k F cy)
variable (b : Basis (Fin p × Fin p) k F)
variable (hb : ∀ i, b i = monomial X Y i)

def weight (axis : Bool) (i : Fin p × Fin p) : k :=
  if axis then i.1.val else i.2.val

noncomputable def eulerLinear (axis : Bool) : F →ₗ[k] F :=
  diagonal b (weight (k := k) axis)

include X Y cx cy hx hy hb

lemma eulerLinear_leibniz (axis : Bool) (u v : F) :
    eulerLinear b axis (u * v) =
      u * eulerLinear b axis v + v * eulerLinear b axis u := by
  apply leibniz_of_basis b
  intro i j
  let r : Fin p × Fin p :=
    (⟨(i.1.val + j.1.val) % p, Nat.mod_lt _ (Fact.out : p.Prime).pos⟩,
     ⟨(i.2.val + j.2.val) % p, Nat.mod_lt _ (Fact.out : p.Prime).pos⟩)
  let c : k :=
    cx ^ ((i.1.val + j.1.val) / p) * cy ^ ((i.2.val + j.2.val) / p)
  have hm : b i * b j = c • b r := by
    simpa [hb, c, r] using monomial_product X Y cx cy hx hy i j
  have hw : weight (k := k) axis r =
      weight (k := k) axis i + weight (k := k) axis j := by
    cases axis <;>
      simp only [weight, Bool.false_eq_true, if_false, if_true, r, Prod.fst, Prod.snd] <;>
      rw [← Nat.cast_add, ← CharP.cast_eq_mod k p]
  change diagonal b _ (b i * b j) =
    b i * diagonal b _ (b j) + b j * diagonal b _ (b i)
  rw [hm, map_smul, diagonal_basis, diagonal_basis, diagonal_basis, hw]
  simp only [Algebra.smul_def, map_add]
  have hm' : b i * b j = algebraMap k F c * b r := by
    simpa [Algebra.smul_def] using hm
  linear_combination
    -(algebraMap k F (weight (k := k) axis i) +
      algebraMap k F (weight (k := k) axis j)) * hm'

noncomputable def euler (axis : Bool) : Derivation k F F :=
  Derivation.mk' (eulerLinear b axis) (by
    intro u v
    simpa [smul_eq_mul] using eulerLinear_leibniz X Y cx cy hx hy b hb axis u v)

@[simp] lemma euler_basis (axis : Bool) (i : Fin p × Fin p) :
    euler X Y cx cy hx hy b hb axis (b i) = weight (k := k) axis i • b i :=
  diagonal_basis b _ i

lemma euler_commute (z : F) :
    euler X Y cx cy hx hy b hb true (euler X Y cx cy hx hy b hb false z) =
      euler X Y cx cy hx hy b hb false (euler X Y cx cy hx hy b hb true z) :=
  diagonal_commute b _ _ z

lemma euler_generators :
    euler X Y cx cy hx hy b hb true X = X ∧
    euler X Y cx cy hx hy b hb true Y = 0 ∧
    euler X Y cx cy hx hy b hb false X = 0 ∧
    euler X Y cx cy hx hy b hb false Y = Y := by
  let a : Fin p := ⟨1, (Fact.out : p.Prime).one_lt⟩
  let z : Fin p := ⟨0, (Fact.out : p.Prime).pos⟩
  have hX : b (a, z) = X := by simp [hb, monomial, a, z]
  have hY : b (z, a) = Y := by simp [hb, monomial, a, z]
  change diagonal b (weight true) X = X ∧
    diagonal b (weight true) Y = 0 ∧
    diagonal b (weight false) X = 0 ∧
    diagonal b (weight false) Y = Y
  rw [← hX, ← hY]
  simp [weight, a, z]

end Euler

section Eigenvectors

variable [CharP k p]

lemma cast_fin_injective :
    Function.Injective (fun i : Fin p => (i.val : k)) := by
  intro i j h
  exact Fin.ext ((CharP.natCast_injOn_Iio k p) i.isLt j.isLt h)

lemma joint_eigenvector (b : Basis (Fin p × Fin p) k F)
    {z : F} (hz : z ≠ 0) {a d : k}
    (ha : diagonal b (weight true) z = a • z)
    (hd : diagonal b (weight false) z = d • z) :
    ∃ i : Fin p × Fin p, ∃ c : k,
      c ≠ 0 ∧ z = c • b i ∧ (i.1.val : k) = a ∧ (i.2.val : k) = d := by
  have hc : ∃ i, b.repr z i ≠ 0 := by
    by_contra! h
    apply hz
    apply b.repr.injective
    ext i
    simpa using h i
  obtain ⟨i, hi⟩ := hc
  have weights (j : Fin p × Fin p) (hj : b.repr z j ≠ 0) :
      (j.1.val : k) = a ∧ (j.2.val : k) = d := by
    have h1 := congrArg (fun v : F => b.repr v j) ha
    have h2 := congrArg (fun v : F => b.repr v j) hd
    simp only [diagonal_repr, map_smul, Finsupp.smul_apply, smul_eq_mul, weight,
      if_true, Bool.false_eq_true, if_false] at h1 h2
    exact ⟨mul_right_cancel₀ hj h1, mul_right_cancel₀ hj h2⟩
  have only (j : Fin p × Fin p) (hj : j ≠ i) : b.repr z j = 0 := by
    by_contra h
    have hjw := weights j h
    have hiw := weights i hi
    apply hj
    exact Prod.ext
      (cast_fin_injective (hjw.1.trans hiw.1.symm))
      (cast_fin_injective (hjw.2.trans hiw.2.symm))
  refine ⟨i, b.repr z i, hi, ?_, (weights i hi).1, (weights i hi).2⟩
  calc
    z = ∑ j, b.repr z j • b j := (b.sum_repr z).symm
    _ = b.repr z i • b i := by
      apply Finset.sum_eq_single i
      · intro j _ hj
        rw [only j hj, zero_smul]
      · simp

lemma constant_of_diagonal_zero (b : Basis (Fin p × Fin p) k F) (X Y : F)
    (hb : ∀ i, b i = monomial X Y i) {z : F}
    (hx : diagonal b (weight true) z = 0)
    (hy : diagonal b (weight false) z = 0) :
    ∃ c : k, z = algebraMap k F c := by
  by_cases hz : z = 0
  · exact ⟨0, by simpa using hz⟩
  obtain ⟨i, c, _, he, hi, hj⟩ := joint_eigenvector b hz
    (by simpa using hx : diagonal b (weight true) z = (0 : k) • z)
    (by simpa using hy : diagonal b (weight false) z = (0 : k) • z)
  have hi0 : i.1.val = 0 := by
    exact (CharP.natCast_injOn_Iio k p) i.1.isLt (Fact.out : p.Prime).pos
      (by simpa using hi)
  have hj0 : i.2.val = 0 := by
    exact (CharP.natCast_injOn_Iio k p) i.2.isLt (Fact.out : p.Prime).pos
      (by simpa using hj)
  refine ⟨c, ?_⟩
  simpa [hb, monomial, hi0, hj0, Algebra.smul_def] using he

end Eigenvectors

section Calculus

variable (D : Derivation k F F)

lemma deriv_mul (u v : F) : D (u * v) = D u * v + u * D v := by
  simpa [smul_eq_mul, mul_comm, add_comm] using D.leibniz u v

lemma deriv_inv {v : F} (hv : v ≠ 0) :
    D v⁻¹ = -(D v) / v ^ 2 := by
  have h := deriv_mul D v v⁻¹
  rw [mul_inv_cancel₀ hv, D.map_one_eq_zero] at h
  apply (eq_div_iff (pow_ne_zero 2 hv)).mpr
  have h' := congrArg (fun z : F => z * v) h
  simp only [zero_mul, add_mul, mul_assoc, inv_mul_cancel₀ hv, mul_one] at h'
  linear_combination -h'

lemma deriv_div (u : F) {v : F} (hv : v ≠ 0) :
    D (u / v) = (D u * v - u * D v) / v ^ 2 := by
  rw [div_eq_mul_inv, deriv_mul, deriv_inv D hv]
  field_simp
  ring

lemma deriv_power (u : F) (n : ℕ) :
    D (u ^ n) = (n : F) * u ^ (n - 1) * D u := by
  simpa [smul_eq_mul, nsmul_eq_mul, mul_assoc] using D.leibniz_pow u n

lemma deriv_kills_adjoin {t z : F} (ht : D t = 0)
    (hz : z ∈ IntermediateField.adjoin k ({t} : Set F)) : D z = 0 := by
  induction hz using IntermediateField.adjoin_induction k with
  | mem z hz => simpa [Set.mem_singleton_iff.mp hz] using ht
  | algebraMap c => exact D.map_algebraMap c
  | add u v _ _ hu hv => simp [hu, hv]
  | inv u _ hu =>
      by_cases h : u = 0
      · simp [h]
      · simp [deriv_inv D h, hu]
  | mul u v _ _ hu hv => simp [deriv_mul, hu, hv]

lemma deriv_preserves_adjoin {t z : F}
    (ht : D t ∈ IntermediateField.adjoin k ({t} : Set F))
    (hz : z ∈ IntermediateField.adjoin k ({t} : Set F)) :
    D z ∈ IntermediateField.adjoin k ({t} : Set F) := by
  induction hz using IntermediateField.adjoin_induction k with
  | mem z hz => simpa [Set.mem_singleton_iff.mp hz] using ht
  | algebraMap c => simp
  | add u v _ _ hu hv => simpa using add_mem hu hv
  | inv u hu ih =>
      by_cases h : u = 0
      · simp [h]
      · rw [deriv_inv D h]
        exact div_mem (neg_mem ih) (pow_mem hu _)
  | mul u v hu hv ihu ihv =>
      rw [deriv_mul]
      exact add_mem (mul_mem ihu hv) (mul_mem hu ihv)

end Calculus

structure Chart (X Y : F) where
  cx : k
  cy : k
  xp : X ^ p = algebraMap k F cx
  yp : Y ^ p = algebraMap k F cy
  basis : Basis (Fin p × Fin p) k F
  basis_eq : ∀ i, basis i = monomial X Y i

section ChartCalculus

variable [CharP k p] {X Y : F} (q : Chart (k := k) (p := p) X Y)

noncomputable def Chart.DX : Derivation k F F :=
  euler X Y q.cx q.cy q.xp q.yp q.basis q.basis_eq true

noncomputable def Chart.DY : Derivation k F F :=
  euler X Y q.cx q.cy q.xp q.yp q.basis q.basis_eq false

@[simp] lemma Chart.dx_X : q.DX X = X :=
  (euler_generators X Y q.cx q.cy q.xp q.yp q.basis q.basis_eq).1

@[simp] lemma Chart.dx_Y : q.DX Y = 0 :=
  (euler_generators X Y q.cx q.cy q.xp q.yp q.basis q.basis_eq).2.1

@[simp] lemma Chart.dy_X : q.DY X = 0 :=
  (euler_generators X Y q.cx q.cy q.xp q.yp q.basis q.basis_eq).2.2.1

@[simp] lemma Chart.dy_Y : q.DY Y = Y :=
  (euler_generators X Y q.cx q.cy q.xp q.yp q.basis q.basis_eq).2.2.2

lemma Chart.commute (z : F) : q.DX (q.DY z) = q.DY (q.DX z) :=
  euler_commute X Y q.cx q.cy q.xp q.yp q.basis q.basis_eq z

lemma Chart.scalar_of_zero {z : F} (hx : q.DX z = 0) (hy : q.DY z = 0) :
    ∃ c : k, z = algebraMap k F c :=
  constant_of_diagonal_zero q.basis X Y q.basis_eq hx hy

lemma Chart.kill_X {z : F} (hz : z ∈ IntermediateField.adjoin k ({X} : Set F)) :
    q.DY z = 0 :=
  deriv_kills_adjoin q.DY q.dy_X hz

lemma Chart.kill_Y {z : F} (hz : z ∈ IntermediateField.adjoin k ({Y} : Set F)) :
    q.DX z = 0 :=
  deriv_kills_adjoin q.DX q.dx_Y hz

lemma Chart.preserve_X {z : F} (hz : z ∈ IntermediateField.adjoin k ({X} : Set F)) :
    q.DX z ∈ IntermediateField.adjoin k ({X} : Set F) :=
  deriv_preserves_adjoin q.DX
    (by simpa using IntermediateField.mem_adjoin_simple_self k X) hz

lemma Chart.preserve_Y {z : F} (hz : z ∈ IntermediateField.adjoin k ({Y} : Set F)) :
    q.DY z ∈ IntermediateField.adjoin k ({Y} : Set F) :=
  deriv_preserves_adjoin q.DY
    (by simpa using IntermediateField.mem_adjoin_simple_self k Y) hz

lemma Chart.eigen_X {z : F} (hz : z ≠ 0) (hy : q.DY z = 0)
    {a : k} (hx : q.DX z = a • z) :
    ∃ m : Fin p, ∃ c : k, c ≠ 0 ∧ z = algebraMap k F c * X ^ m.val ∧
      (m.val : k) = a := by
  obtain ⟨i, c, hc, he, hi, hj⟩ := joint_eigenvector q.basis hz hx
    (by simpa [Chart.DY, euler, eulerLinear] using hy :
      diagonal q.basis (weight false) z = (0 : k) • z)
  have hj0 : i.2.val = 0 :=
    (CharP.natCast_injOn_Iio k p) i.2.isLt (Fact.out : p.Prime).pos
      (by simpa using hj)
  exact ⟨i.1, c, hc, by simpa [q.basis_eq, monomial, hj0, Algebra.smul_def] using he, hi⟩

lemma Chart.eigen_Y {z : F} (hz : z ≠ 0) (hx : q.DX z = 0)
    {a : k} (hy : q.DY z = a • z) :
    ∃ m : Fin p, ∃ c : k, c ≠ 0 ∧ z = algebraMap k F c * Y ^ m.val ∧
      (m.val : k) = a := by
  obtain ⟨i, c, hc, he, hi, hj⟩ := joint_eigenvector q.basis hz
    (by simpa [Chart.DX, euler, eulerLinear] using hx :
      diagonal q.basis (weight true) z = (0 : k) • z) hy
  have hi0 : i.1.val = 0 :=
    (CharP.natCast_injOn_Iio k p) i.1.isLt (Fact.out : p.Prime).pos
      (by simpa using hi)
  exact ⟨i.2, c, hc, by simpa [q.basis_eq, monomial, hi0, Algebra.smul_def] using he, hj⟩

end ChartCalculus

def Nonmonomial (x u : F) : Prop :=
  ∀ (m : Fin p) (c : k), u ≠ algebraMap k F c * x ^ m.val

def AffinePower (x u : F) (n : ℕ) : Prop :=
  ∃ a b : k, u ^ n = algebraMap k F a + algebraMap k F b * x ^ n

def AffinePowerNonzero (x u : F) (n : ℕ) : Prop :=
  ∃ a b : k, a ≠ 0 ∧ b ≠ 0 ∧
    u ^ n = algebraMap k F a + algebraMap k F b * x ^ n

def correction (D : Derivation k F F) (u : F) : F :=
  u / D u - 1

section WitnessAlgebra

variable (D E : Derivation k F F)

lemma common_logarithmic_weight (hcomm : ∀ z, D (E z) = E (D z))
    {A B Z : F} (hA : A ≠ 0) (hB : B ≠ 0) (hZ : Z ≠ 0)
    (hEA : E A = 0) (hDB : D B = 0)
    (hZ1 : D Z + E Z = Z)
    (hZ2 : (A + 1) * D Z + (B + 1) * E Z = Z) :
    D A / A = E B / B := by
  have hr : A * D Z + B * E Z = 0 := by
    linear_combination hZ2 - hZ1
  have hDZ : D Z ≠ 0 := by
    intro hz
    have hbz : E Z = 0 := by
      apply (mul_eq_zero.mp ?_).resolve_left hB
      simpa [hz] using hr
    exact hZ (by simpa [hz, hbz] using hZ1.symm)
  have h1 := congrArg D hZ1
  have h2 := congrArg E hZ1
  simp only [map_add] at h1 h2
  rw [hcomm] at h1
  have hd := congrArg (fun z : F => D z + E z) hr
  simp only [map_add, map_zero, deriv_mul, hEA, hDB, mul_zero, zero_mul,
    add_zero, zero_add] at hd
  rw [hcomm] at hd
  have hs : D A * D Z + E B * E Z = 0 := by
    linear_combination hd - A * h1 - B * h2 - hr
  have ht : (B * D A - A * E B) * D Z = 0 := by
    linear_combination B * hs - E B * hr
  have he : B * D A - A * E B = 0 :=
    (mul_eq_zero.mp ht).resolve_right hDZ
  apply (div_eq_div_iff hA hB).mpr
  linear_combination he

lemma correction_not_constant {x u : F} (hu : u ≠ 0) (hdu : D u ≠ 0)
    (hnon : Nonmonomial (k := k) (p := p) x u)
    (heigen : ∀ a : k, D u = a • u →
      ∃ (m : Fin p) (c : k), u = algebraMap k F c * x ^ m.val) :
    ¬ ∃ a : k, correction D u = algebraMap k F a := by
  rintro ⟨a, ha⟩
  have hb : u / D u = algebraMap k F (a + 1) := by
    simp only [correction] at ha
    simp only [map_add, map_one]
    linear_combination ha
  have hb0 : algebraMap k F (a + 1) ≠ 0 := by
    rw [← hb]
    exact div_ne_zero hu hdu
  have he : D u = (a + 1)⁻¹ • u := by
    simp only [Algebra.smul_def, map_inv₀]
    field_simp at hb ⊢
    linear_combination -hb
  obtain ⟨m, c, hc⟩ := heigen _ he
  exact hnon m c hc

end WitnessAlgebra

section CommonExponent

variable [CharP k p] {X Y U V : F}
variable (q : Chart (k := k) (p := p) X Y)

lemma Chart.dx_nonzero (hu : U ≠ 0)
    (hU : U ∈ IntermediateField.adjoin k ({X} : Set F))
    (hnon : Nonmonomial (k := k) (p := p) X U) : q.DX U ≠ 0 := by
  intro h
  obtain ⟨c, hc⟩ := q.scalar_of_zero h (q.kill_X hU)
  exact hnon ⟨0, (Fact.out : p.Prime).pos⟩ c (by simpa using hc)

lemma Chart.dy_nonzero (hu : V ≠ 0)
    (hV : V ∈ IntermediateField.adjoin k ({Y} : Set F))
    (hnon : Nonmonomial (k := k) (p := p) Y V) : q.DY V ≠ 0 := by
  intro h
  obtain ⟨c, hc⟩ := q.scalar_of_zero (q.kill_Y hV) h
  exact hnon ⟨0, (Fact.out : p.Prime).pos⟩ c (by simpa using hc)

lemma Chart.correction_X_not_constant (hu : U ≠ 0)
    (hU : U ∈ IntermediateField.adjoin k ({X} : Set F))
    (hnon : Nonmonomial (k := k) (p := p) X U) :
    ¬ ∃ a : k, correction q.DX U = algebraMap k F a := by
  apply correction_not_constant q.DX hu (q.dx_nonzero hu hU hnon) hnon
  intro a ha
  obtain ⟨m, c, _, he, _⟩ := q.eigen_X hu (q.kill_X hU) ha
  exact ⟨m, c, he⟩

lemma Chart.correction_Y_not_constant (hu : V ≠ 0)
    (hV : V ∈ IntermediateField.adjoin k ({Y} : Set F))
    (hnon : Nonmonomial (k := k) (p := p) Y V) :
    ¬ ∃ a : k, correction q.DY V = algebraMap k F a := by
  apply correction_not_constant q.DY hu (q.dy_nonzero hu hV hnon) hnon
  intro a ha
  obtain ⟨m, c, _, he, _⟩ := q.eigen_Y hu (q.kill_Y hV) ha
  exact ⟨m, c, he⟩

lemma Chart.common_weight (hX : X ≠ 0) (hU0 : U ≠ 0) (hV0 : V ≠ 0)
    (hU : U ∈ IntermediateField.adjoin k ({X} : Set F))
    (hV : V ∈ IntermediateField.adjoin k ({Y} : Set F))
    (hnu : Nonmonomial (k := k) (p := p) X U)
    (hnv : Nonmonomial (k := k) (p := p) Y V)
    {Z s t : F} (hZ : Z ≠ 0)
    (hs : s ∈ IntermediateField.adjoin k ({Y / X} : Set F))
    (ht : t ∈ IntermediateField.adjoin k ({V / U} : Set F))
    (hZs : Z = X * s) (hZt : Z = U * t) :
    ∃ m : Fin p, 0 < m.val ∧ ∃ c d : k, c ≠ 0 ∧ d ≠ 0 ∧
      correction q.DX U = algebraMap k F c * X ^ m.val ∧
      correction q.DY V = algebraMap k F d * Y ^ m.val := by
  have hdu := q.dx_nonzero hU0 hU hnu
  have hdv := q.dy_nonzero hV0 hV hnv
  have hAX := q.correction_X_not_constant hU0 hU hnu
  have hAY := q.correction_Y_not_constant hV0 hV hnv
  let A := correction q.DX U
  let B := correction q.DY V
  have hA : A ≠ 0 := by
    intro h
    exact hAX ⟨0, by simpa [A] using h⟩
  have hB : B ≠ 0 := by
    intro h
    exact hAY ⟨0, by simpa [B] using h⟩
  have hAm : A ∈ IntermediateField.adjoin k ({X} : Set F) :=
    sub_mem (div_mem hU (q.preserve_X hU)) (one_mem _)
  have hBm : B ∈ IntermediateField.adjoin k ({Y} : Set F) :=
    sub_mem (div_mem hV (q.preserve_Y hV)) (one_mem _)
  let delta := q.DX + q.DY
  have hdX : delta X = X := by simp [delta, Derivation.add_apply]
  have hdY : delta Y = Y := by simp [delta, Derivation.add_apply]
  have hdr : delta (Y / X) = 0 := by
    rw [deriv_div delta Y hX, hdX, hdY]
    simp [mul_comm]
  have hds := deriv_kills_adjoin delta hdr hs
  have hdZ : delta Z = Z := by
    rw [hZs, deriv_mul, hdX, hds, mul_zero, add_zero]
  let delta' := (U / q.DX U) • q.DX + (V / q.DY V) • q.DY
  have hdU : delta' U = U := by
    simp only [delta', Derivation.add_apply, Derivation.smul_apply, smul_eq_mul,
      q.kill_X hU, mul_zero, add_zero]
    exact div_mul_cancel₀ U hdu
  have hdV : delta' V = V := by
    simp only [delta', Derivation.add_apply, Derivation.smul_apply, smul_eq_mul,
      q.kill_Y hV, mul_zero, zero_add]
    exact div_mul_cancel₀ V hdv
  have hdr' : delta' (V / U) = 0 := by
    rw [deriv_div delta' V hU0, hdU, hdV]
    simp [mul_comm]
  have hdt := deriv_kills_adjoin delta' hdr' ht
  have hdZ' : delta' Z = Z := by
    rw [hZt, deriv_mul, hdU, hdt, mul_zero, add_zero]
  have he : q.DX A / A = q.DY B / B :=
    common_logarithmic_weight q.DX q.DY q.commute hA hB hZ
      (q.kill_X hAm) (q.kill_Y hBm)
      (by simpa [delta, Derivation.add_apply] using hdZ)
      (by simpa [A, B, correction, delta', Derivation.add_apply,
        Derivation.smul_apply, smul_eq_mul] using hdZ')
  have hmX : q.DX A / A ∈ IntermediateField.adjoin k ({X} : Set F) :=
    div_mem (q.preserve_X hAm) hAm
  have hmY : q.DX A / A ∈ IntermediateField.adjoin k ({Y} : Set F) := by
    rw [he]
    exact div_mem (q.preserve_Y hBm) hBm
  obtain ⟨a, ha⟩ := q.scalar_of_zero (q.kill_Y hmY) (q.kill_X hmX)
  have hAe : q.DX A = a • A := by
    simpa [Algebra.smul_def] using (div_eq_iff hA).mp ha
  have hBe : q.DY B = a • B := by
    simpa [Algebra.smul_def] using (div_eq_iff hB).mp (he.symm.trans ha)
  obtain ⟨m, c, hc, hAc, hma⟩ := q.eigen_X hA (q.kill_X hAm) hAe
  obtain ⟨r, d, hd, hBd, hra⟩ := q.eigen_Y hB (q.kill_Y hBm) hBe
  have hrm : r = m := cast_fin_injective (hra.trans hma.symm)
  subst r
  have hmpos : 0 < m.val := by
    by_contra! h
    exact hAX ⟨c, by simpa [A, Nat.eq_zero_of_le_zero h] using hAc⟩
  exact ⟨m, hmpos, c, d, hc, hd, hAc, hBd⟩

end CommonExponent

section Integration

variable (D : Derivation k F F) {x u : F}

lemma euler_power (hx : D x = x) (n : ℕ) :
    D (x ^ n) = (n : F) * x ^ n := by
  cases n with
  | zero => simp
  | succ n =>
      rw [deriv_power, hx, Nat.add_sub_cancel]
      rw [mul_assoc, ← pow_succ]

lemma logarithmic_power (hu : u ≠ 0) (n : ℕ) :
    D (u ^ n) / u ^ n = (n : F) * D u / u := by
  cases n with
  | zero => simp
  | succ n =>
      rw [deriv_power, Nat.add_sub_cancel, pow_succ]
      field_simp

lemma derivative_ratio_zero {a b : F} (ha : a ≠ 0) (hb : b ≠ 0)
    (he : D a / a = D b / b) : D (a / b) = 0 := by
  rw [deriv_div D a hb]
  have h := (div_eq_div_iff ha hb).mp he
  rw [show D a * b - a * D b = 0 by linear_combination h]
  exact zero_div _

lemma nat_cast_nonzero {r : ℕ} (hr : 0 < r) (hrp : r < p) : (r : F) ≠ 0 := by
  intro h
  have hh := (CharP.natCast_injOn_Iio F p) hrp (Fact.out : p.Prime).pos
    (by simpa using h)
  omega

lemma integrate_correction (hx0 : x ≠ 0) (hu0 : u ≠ 0) (hdu : D u ≠ 0)
    (hDx : D x = x) (cp : k) (hcp : x ^ p = algebraMap k F cp)
    (hu : u ∈ IntermediateField.adjoin k ({x} : Set F))
    (hkernel : ∀ z ∈ IntermediateField.adjoin k ({x} : Set F),
      D z = 0 → ∃ t : k, z = algebraMap k F t)
    (m : Fin p) (hm : 0 < m.val) (c : k) (hc : c ≠ 0)
    (hA : correction D u = algebraMap k F c * x ^ m.val) :
    AffinePowerNonzero (k := k) x u (p - m.val) := by
  let n := p - m.val
  have hn : 0 < n := Nat.sub_pos_of_lt m.isLt
  have hnm : n + m.val = p := Nat.sub_add_cancel (Nat.le_of_lt m.isLt)
  let S := x ^ n + algebraMap k F c * x ^ p
  have hB : u / D u = 1 + algebraMap k F c * x ^ m.val := by
    dsimp [correction] at hA
    linear_combination hA
  have hS : S = x ^ n * (u / D u) := by
    rw [hB]
    dsimp [S]
    have hxp : x ^ p = x ^ n * x ^ m.val := by rw [← pow_add, hnm]
    rw [hxp]
    ring
  have hS0 : S ≠ 0 := by
    rw [hS]
    exact mul_ne_zero (pow_ne_zero n hx0) (div_ne_zero hu0 hdu)
  have hDS : D S = (n : F) * x ^ n := by
    dsimp [S]
    rw [hcp, map_add, deriv_mul, D.map_algebraMap, D.map_algebraMap]
    simpa using euler_power D hDx n
  have hlog : D (u ^ n) / u ^ n = D S / S := by
    rw [logarithmic_power D hu0 n, hDS, hS]
    field_simp
  have hxmem := IntermediateField.mem_adjoin_simple_self k x
  have hSmem : S ∈ IntermediateField.adjoin k ({x} : Set F) :=
    add_mem (pow_mem hxmem _)
      (mul_mem ((IntermediateField.adjoin k ({x} : Set F)).algebraMap_mem c)
        (pow_mem hxmem _))
  obtain ⟨t, ht⟩ := hkernel (u ^ n / S) (div_mem (pow_mem hu _) hSmem)
    (derivative_ratio_zero D (pow_ne_zero n hu0) hS0 hlog)
  have ht0 : t ≠ 0 := by
    intro h
    have hq := div_ne_zero (pow_ne_zero n hu0) hS0
    exact hq (by simpa [h] using ht)
  have hcp0 : cp ≠ 0 := by
    intro h
    exact pow_ne_zero p hx0 (by simpa [h] using hcp)
  have hout : u ^ n = algebraMap k F t * S := (div_eq_iff hS0).mp ht
  refine ⟨t * c * cp, t, mul_ne_zero (mul_ne_zero ht0 hc) hcp0, ht0, ?_⟩
  change u ^ n = _
  rw [hout]
  simp only [S, hcp, map_mul]
  ring

lemma affine_forces_weight (hu0 : u ≠ 0) (hdu : D u ≠ 0)
    (hDx : D x = x) {r : ℕ} (hr : 0 < r) (hrp : r < p)
    (haff : AffinePower (k := k) x u r) :
    D (correction D u) = -(r : F) * correction D u := by
  obtain ⟨a, b, hab⟩ := haff
  have hr0 : (r : F) ≠ 0 := nat_cast_nonzero hr hrp
  have hd := congrArg D hab
  simp only [map_add, deriv_mul, D.map_algebraMap, zero_mul, zero_add,
    euler_power D hDx] at hd
  rw [deriv_power] at hd
  have hb : b ≠ 0 := by
    intro h
    have hz : (r : F) * u ^ (r - 1) * D u ≠ 0 :=
      mul_ne_zero (mul_ne_zero hr0 (pow_ne_zero _ hu0)) hdu
    exact hz (by simpa [h] using hd)
  have hbx : algebraMap k F b * x ^ r ≠ 0 := by
    intro h
    have hz : (r : F) * u ^ (r - 1) * D u ≠ 0 :=
      mul_ne_zero (mul_ne_zero hr0 (pow_ne_zero _ hu0)) hdu
    have hh : algebraMap k F b * ((r : F) * x ^ r) = 0 := by
      linear_combination (r : F) * h
    exact hz (hd.trans hh)
  have hur : u ^ (r - 1) * u = u ^ r := by
    rw [← pow_succ, Nat.sub_add_cancel hr]
  have hh : (r : F) * (u ^ r * D u - algebraMap k F b * x ^ r * u) = 0 := by
    rw [← hur]
    linear_combination u * hd
  have hrel : u ^ r * D u = algebraMap k F b * x ^ r * u :=
    sub_eq_zero.mp ((mul_eq_zero.mp hh).resolve_left hr0)
  rw [hab] at hrel
  have hAc : correction D u = algebraMap k F a / (algebraMap k F b * x ^ r) := by
    apply (eq_div_iff hbx).mpr
    dsimp [correction]
    field_simp
    linear_combination -hrel
  have hden : D (algebraMap k F b * x ^ r) =
      (r : F) * (algebraMap k F b * x ^ r) := by
    rw [deriv_mul, D.map_algebraMap, euler_power D hDx]
    ring
  rw [hAc, deriv_div D _ hbx, D.map_algebraMap, hden]
  field_simp
  ring

lemma unique_exponent (hu0 : u ≠ 0) (hdu : D u ≠ 0) (hDx : D x = x)
    (hA0 : correction D u ≠ 0) (m : Fin p) (hm : 0 < m.val)
    (c : k) (hA : correction D u = algebraMap k F c * x ^ m.val)
    {r : ℕ} (hr : 0 < r) (hrp : r < p)
    (haff : AffinePower (k := k) x u r) : r = p - m.val := by
  have hweight : D (correction D u) = (m.val : F) * correction D u := by
    rw [hA, deriv_mul, D.map_algebraMap, euler_power D hDx]
    ring
  have hother := affine_forces_weight D hu0 hdu hDx hr hrp haff
  have hzero : ((m.val : F) + (r : F)) * correction D u = 0 := by
    linear_combination hother - hweight
  have hsum : (m.val : F) + (r : F) = 0 :=
    (mul_eq_zero.mp hzero).resolve_right hA0
  have hnlt : p - m.val < p := by omega
  apply (CharP.natCast_injOn_Iio F p) hrp hnlt
  rw [Nat.cast_sub (Nat.le_of_lt m.isLt), CharP.cast_eq_zero F p]
  linear_combination hsum

end Integration

def ExponentConclusion (X Y U V : F) : Prop :=
  ∃ n : ℕ, 0 < n ∧ n < p ∧
    AffinePowerNonzero (k := k) X U n ∧
    AffinePowerNonzero (k := k) Y V n ∧
    (∀ r : ℕ, 0 < r → r < p →
      (AffinePower (k := k) X U r ∨ AffinePower (k := k) Y V r) → r = n)

theorem chart_intersection [CharP k p] {X Y U V Z s t : F}
    (q : Chart (k := k) (p := p) X Y)
    (hX : X ≠ 0) (hY : Y ≠ 0) (hU0 : U ≠ 0) (hV0 : V ≠ 0)
    (hU : U ∈ IntermediateField.adjoin k ({X} : Set F))
    (hV : V ∈ IntermediateField.adjoin k ({Y} : Set F))
    (hnu : Nonmonomial (k := k) (p := p) X U)
    (hnv : Nonmonomial (k := k) (p := p) Y V)
    (hZ : Z ≠ 0)
    (hs : s ∈ IntermediateField.adjoin k ({Y / X} : Set F))
    (ht : t ∈ IntermediateField.adjoin k ({V / U} : Set F))
    (hZs : Z = X * s) (hZt : Z = U * t) :
    ExponentConclusion (k := k) (p := p) X Y U V := by
  obtain ⟨m, hm, c, d, hc, hd, hAc, hBd⟩ :=
    q.common_weight hX hU0 hV0 hU hV hnu hnv hZ hs ht hZs hZt
  have hdu := q.dx_nonzero hU0 hU hnu
  have hdv := q.dy_nonzero hV0 hV hnv
  have hA0 : correction q.DX U ≠ 0 := by
    rw [hAc]
    exact mul_ne_zero ((map_ne_zero (algebraMap k F)).mpr hc) (pow_ne_zero _ hX)
  have hB0 : correction q.DY V ≠ 0 := by
    rw [hBd]
    exact mul_ne_zero ((map_ne_zero (algebraMap k F)).mpr hd) (pow_ne_zero _ hY)
  refine ⟨p - m.val, Nat.sub_pos_of_lt m.isLt, by omega, ?_, ?_, ?_⟩
  · exact integrate_correction q.DX hX hU0 hdu q.dx_X q.cx q.xp hU
      (fun z hz hdz => q.scalar_of_zero hdz (q.kill_X hz)) m hm c hc hAc
  · exact integrate_correction q.DY hY hV0 hdv q.dy_Y q.cy q.yp hV
      (fun z hz hdz => q.scalar_of_zero (q.kill_Y hz) hdz) m hm d hd hBd
  · intro r hr hrp h
    rcases h with hu | hv
    · exact unique_exponent q.DX hU0 hdu q.dx_X hA0 m hm c hAc hr hrp hu
    · exact unique_exponent q.DY hV0 hdv q.dy_Y hB0 m hm d hBd hr hrp hv

lemma lift_adjoin_membership (E : IntermediateField k F) {x z : F}
    (hx : x ∈ E) (hz : z ∈ E)
    (h : z ∈ IntermediateField.adjoin k ({x} : Set F)) :
    (⟨z, hz⟩ : E) ∈ IntermediateField.adjoin k ({⟨x, hx⟩} : Set E) := by
  apply (IntermediateField.map_mem_map
    (IntermediateField.adjoin k ({⟨x, hx⟩} : Set E)) E.val).mp
  rw [IntermediateField.adjoin_map, Set.image_singleton]
  exact h

theorem intersection_exponent [CharP k p]
    (hpowers : ∀ z : F, ∃ c : k, z ^ p = algebraMap k F c)
    {X Y U V Z s t : F}
    (hdegree : Module.finrank k (IntermediateField.adjoin k ({X, Y} : Set F)) = p ^ 2)
    (hX : X ≠ 0) (hY : Y ≠ 0) (hU0 : U ≠ 0) (hV0 : V ≠ 0)
    (hU : U ∈ IntermediateField.adjoin k ({X} : Set F))
    (hV : V ∈ IntermediateField.adjoin k ({Y} : Set F))
    (hnu : Nonmonomial (k := k) (p := p) X U)
    (hnv : Nonmonomial (k := k) (p := p) Y V)
    (hZ : Z ≠ 0)
    (hs : s ∈ IntermediateField.adjoin k ({Y / X} : Set F))
    (ht : t ∈ IntermediateField.adjoin k ({V / U} : Set F))
    (hZs : Z = X * s) (hZt : Z = U * t) :
    ExponentConclusion (k := k) (p := p) X Y U V := by
  obtain ⟨cx, hx⟩ := hpowers X
  obtain ⟨cy, hy⟩ := hpowers Y
  let E := coordinateField X Y cx cy hx hy hpowers
  have hE : E = IntermediateField.adjoin k ({X, Y} : Set F) :=
    coordinateField_eq_adjoin X Y cx cy hx hy hpowers
  have hXm : X ∈ E := by
    rw [hE]
    exact IntermediateField.subset_adjoin k _ (by simp)
  have hYm : Y ∈ E := by
    rw [hE]
    exact IntermediateField.subset_adjoin k _ (by simp)
  let x : E := ⟨X, hXm⟩
  let y : E := ⟨Y, hYm⟩
  let v : Fin p × Fin p → E := fun i =>
    ⟨monomial X Y i, Submodule.subset_span ⟨i, rfl⟩⟩
  have hspan : Submodule.span k (Set.range v) = ⊤ := by
    exact (Submodule.span_range_subtype_eq_top_iff
      (monomialSpan (k := k) (p := p) X Y)
      (fun i => Submodule.subset_span (Set.mem_range_self i))).mpr rfl
  have hcard : Fintype.card (Fin p × Fin p) = Module.finrank k E := by
    rw [hE, hdegree]
    simp [pow_two]
  let b : Basis (Fin p × Fin p) k E :=
    Basis.mk (linearIndependent_of_top_le_span_of_card_eq_finrank hspan.ge hcard) hspan.ge
  have hb : ∀ i, b i = monomial x y i := by
    intro i
    apply Subtype.ext
    simp [b, Basis.mk_apply, v, monomial, x, y]
  let q : Chart (k := k) (p := p) x y := {
    cx := cx
    cy := cy
    xp := by apply Subtype.ext; simpa [x] using hx
    yp := by apply Subtype.ext; simpa [y] using hy
    basis := b
    basis_eq := hb
  }
  have hle (a : F) (ha : a ∈ E) :
      IntermediateField.adjoin k ({a} : Set F) ≤ E :=
    IntermediateField.adjoin_le_iff.mpr (by simpa)
  have hUm : U ∈ E := hle X hXm hU
  have hVm : V ∈ E := hle Y hYm hV
  have hsm : s ∈ E := hle (Y / X) (div_mem hYm hXm) hs
  have htm : t ∈ E := hle (V / U) (div_mem hVm hUm) ht
  have hZm : Z ∈ E := hZs ▸ mul_mem hXm hsm
  let u : E := ⟨U, hUm⟩
  let w : E := ⟨V, hVm⟩
  let z : E := ⟨Z, hZm⟩
  let s' : E := ⟨s, hsm⟩
  let t' : E := ⟨t, htm⟩
  have hx0 : x ≠ 0 := by
    intro h
    exact hX (congrArg (fun a : E => (a : F)) h)
  have hy0 : y ≠ 0 := by
    intro h
    exact hY (congrArg (fun a : E => (a : F)) h)
  have hu0 : u ≠ 0 := by
    intro h
    exact hU0 (congrArg (fun a : E => (a : F)) h)
  have hw0 : w ≠ 0 := by
    intro h
    exact hV0 (congrArg (fun a : E => (a : F)) h)
  have hz0 : z ≠ 0 := by
    intro h
    exact hZ (congrArg (fun a : E => (a : F)) h)
  have hnum : Nonmonomial (k := k) (p := p) x u := by
    intro m c he
    apply hnu m c
    have hh := congrArg (fun a : E => (a : F)) he
    simpa [u, x] using hh
  have hnwm : Nonmonomial (k := k) (p := p) y w := by
    intro m c he
    apply hnv m c
    have hh := congrArg (fun a : E => (a : F)) he
    simpa [w, y] using hh
  have hu : u ∈ IntermediateField.adjoin k ({x} : Set E) :=
    lift_adjoin_membership E hXm hUm hU
  have hw : w ∈ IntermediateField.adjoin k ({y} : Set E) :=
    lift_adjoin_membership E hYm hVm hV
  have hs' : s' ∈ IntermediateField.adjoin k ({y / x} : Set E) :=
    lift_adjoin_membership E (div_mem hYm hXm) hsm hs
  have ht' : t' ∈ IntermediateField.adjoin k ({w / u} : Set E) :=
    lift_adjoin_membership E (div_mem hVm hUm) htm ht
  obtain ⟨n, hn, hnp, hpu, hpw, huniq⟩ :=
    chart_intersection q hx0 hy0 hu0 hw0 hu hw hnum hnwm hz0 hs' ht'
      (Subtype.ext hZs) (Subtype.ext hZt)
  refine ⟨n, hn, hnp, ?_, ?_, ?_⟩
  · obtain ⟨a, b, ha, hb, he⟩ := hpu
    refine ⟨a, b, ha, hb, ?_⟩
    have hh := congrArg (fun a : E => (a : F)) he
    simpa [u, x] using hh
  · obtain ⟨a, b, ha, hb, he⟩ := hpw
    refine ⟨a, b, ha, hb, ?_⟩
    have hh := congrArg (fun a : E => (a : F)) he
    simpa [w, y] using hh
  · intro r hr hrp h
    apply huniq r hr hrp
    rcases h with hu | hv
    · obtain ⟨a, b, he⟩ := hu
      exact Or.inl ⟨a, b, by apply Subtype.ext; exact he⟩
    · obtain ⟨a, b, he⟩ := hv
      exact Or.inr ⟨a, b, by apply Subtype.ext; exact he⟩

abbrev PthPowers (F : Type*) [Field F] (p : ℕ) [Fact p.Prime] [CharP F p] :
    Subfield F :=
  (frobenius F p).fieldRange

theorem prop_intersection
    [FiniteDimensional (PthPowers F p) F]
    {X Y U V Z s t : F}
    (hdegree : Module.finrank (PthPowers F p)
      (IntermediateField.adjoin (PthPowers F p) ({X, Y} : Set F)) = p ^ 2)
    (hX : X ≠ 0) (hY : Y ≠ 0) (hU0 : U ≠ 0) (hV0 : V ≠ 0)
    (hU : U ∈ IntermediateField.adjoin (PthPowers F p) ({X} : Set F))
    (hV : V ∈ IntermediateField.adjoin (PthPowers F p) ({Y} : Set F))
    (hnu : Nonmonomial (k := PthPowers F p) (p := p) X U)
    (hnv : Nonmonomial (k := PthPowers F p) (p := p) Y V)
    (hZ : Z ≠ 0)
    (hs : s ∈ IntermediateField.adjoin (PthPowers F p) ({Y / X} : Set F))
    (ht : t ∈ IntermediateField.adjoin (PthPowers F p) ({V / U} : Set F))
    (hs0 : s ≠ 0) (ht0 : t ≠ 0)
    (hZs : Z = X * s) (hZt : Z = U * t) :
    ExponentConclusion (k := PthPowers F p) (p := p) X Y U V := by
  have hpowers : ∀ z : F, ∃ c : PthPowers F p,
      z ^ p = algebraMap (PthPowers F p) F c := by
    intro z
    refine ⟨⟨z ^ p, ?_⟩, rfl⟩
    exact ⟨z, rfl⟩
  exact intersection_exponent hpowers hdegree hX hY hU0 hV0
    hU hV hnu hnv hZ hs ht hZs hZt

#print axioms prop_intersection

end CharPIntersection
