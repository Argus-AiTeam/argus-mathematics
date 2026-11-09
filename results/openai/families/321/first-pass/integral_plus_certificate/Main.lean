import Mathlib

open scoped BigOperators

noncomputable section

namespace IntegralPlus

abbrev Free := FreeGroup (Fin 5)

def X : Free := FreeGroup.of 0
def A : Free := FreeGroup.of 1
def Y : Free := FreeGroup.of 2
def B : Free := FreeGroup.of 3
def S : Free := FreeGroup.of 4

def r1 : Free := X * A * X⁻¹ * (A ^ 4)⁻¹
def r2 : Free := Y * B * Y⁻¹ * (B ^ 3)⁻¹
def r3 : Free := X * (B ^ 13)⁻¹
def r4 : Free := S * Y * S⁻¹ * (A ^ 5)⁻¹
def t1 : Free := X ^ 2
def t2 : Free := Y ^ 3
def rels : Set Free := {r1, r2, r3, r4, t1, t2}

abbrev G := PresentedGroup rels
abbrev R := MonoidAlgebra ℤ G
abbrev C (n : ℕ) := Fin n → R

def quotient : Free →* G := PresentedGroup.mk rels
def monG : G →* R := MonoidAlgebra.of ℤ G
def mon : Free →* R := monG.comp quotient
def basis {n : ℕ} (i : Fin n) : C n := Pi.single i 1

@[simp] theorem mon_mul_inv (w : Free) : mon w * mon w⁻¹ = 1 := by
  rw [← map_mul, mul_inv_cancel, map_one]

@[simp] theorem mon_inv_mul (w : Free) : mon w⁻¹ * mon w = 1 := by
  rw [← map_mul, inv_mul_cancel, map_one]

theorem mon_inv_one {w : Free} (h : mon w = 1) : mon w⁻¹ = 1 := by
  simpa only [h, one_mul] using mon_mul_inv w

theorem mon_relation {w : Free} (h : w ∈ rels) : mon w = 1 := by
  change monG (PresentedGroup.mk rels w) = 1
  rw [PresentedGroup.one_of_mem h, map_one]

@[simp] theorem mon_t1 : mon t1 = 1 := mon_relation (by simp [rels])
@[simp] theorem mon_t2 : mon t2 = 1 := mon_relation (by simp [rels])

def action : G →* MulAut (Multiplicative (C 5)) where
  toFun g :=
    { toFun := fun v => Multiplicative.ofAdd (monG g • v.toAdd)
      invFun := fun v => Multiplicative.ofAdd (monG g⁻¹ • v.toAdd)
      left_inv := by
        intro v
        change monG g⁻¹ • (monG g • v.toAdd) = v.toAdd
        rw [smul_smul, ← map_mul, inv_mul_cancel, map_one, one_smul]
      right_inv := by
        intro v
        change monG g • (monG g⁻¹ • v.toAdd) = v.toAdd
        rw [smul_smul, ← map_mul, mul_inv_cancel, map_one, one_smul]
      map_mul' := by
        intro v w
        change monG g • (v.toAdd + w.toAdd) =
          monG g • v.toAdd + monG g • w.toAdd
        exact smul_add _ _ _ }
  map_one' := by
    apply MulEquiv.ext
    intro v
    change monG 1 • v.toAdd = v.toAdd
    rw [map_one, one_smul]
  map_mul' := by
    intro g h
    apply MulEquiv.ext
    intro v
    change monG (g * h) • v.toAdd = monG g • (monG h • v.toAdd)
    rw [map_mul, mul_smul]

abbrev PathGroup := Multiplicative (C 5) ⋊[action] G

def path : Free →* PathGroup :=
  FreeGroup.lift fun i => ⟨Multiplicative.ofAdd (basis i), quotient (FreeGroup.of i)⟩

theorem path_right (w : Free) : (path w).right = quotient w := by
  have h : (SemidirectProduct.rightHom : PathGroup →* G).comp path = quotient :=
    FreeGroup.ext_hom _ _ (by intro i; simp [path])
  exact congrArg (fun f : Free →* G => f w) h

def fox (w : Free) : C 5 := (path w).left.toAdd

@[simp] theorem fox_one : fox 1 = 0 := by simp [fox]

@[simp] theorem fox_of (i : Fin 5) : fox (FreeGroup.of i) = basis i := by
  simp [fox, path]

theorem fox_mul (u v : Free) : fox (u * v) = fox u + mon u • fox v := by
  simp [fox, action, mon, path_right]

theorem fox_inv (w : Free) : fox w⁻¹ = -(mon w⁻¹ • fox w) := by
  simp [fox, action, mon, path_right, smul_neg]

def norm (n : ℕ) (a : R) : R := ∑ j ∈ Finset.range n, a ^ j

theorem fox_pow (w : Free) (n : ℕ) : fox (w ^ n) = norm n (mon w) • fox w := by
  induction n with
  | zero => simp [norm]
  | succ n ih =>
      rw [pow_succ, fox_mul, ih, map_pow]
      simp [norm, Finset.sum_range_succ, add_smul]

def conjugate (c w : Free) : Free := c * w * c⁻¹
def commutator (u v : Free) : Free := u * v * u⁻¹ * v⁻¹

theorem mon_conjugate {w : Free} (h : mon w = 1) (c : Free) :
    mon (conjugate c w) = 1 := by
  simp [conjugate, map_mul, h]

theorem fox_conjugate {w : Free} (h : mon w = 1) (c : Free) :
    fox (conjugate c w) = mon c • fox w := by
  simp only [conjugate, fox_mul, fox_inv, map_mul, h, mul_one,
    smul_neg, smul_smul, mon_mul_inv, one_smul]
  abel

theorem mon_commutator {u : Free} (h : mon u = 1) (v : Free) :
    mon (commutator u v) = 1 := by
  simp [commutator, map_mul, h, mon_inv_one h]

theorem fox_commutator {u : Free} (h : mon u = 1) (v : Free) :
    fox (commutator u v) = (1 - mon v) • fox u := by
  simp only [commutator, fox_mul, fox_inv, map_mul, h, mon_inv_one h,
    one_mul, mul_one, one_smul, smul_neg, smul_smul, mon_mul_inv,
    sub_smul]
  abel

theorem fox_difference {u v : Free} (hu : mon u = 1) (hv : mon v = 1) :
    fox (u * v⁻¹) = fox u - fox v := by
  simp [fox_mul, fox_inv, hu, mon_inv_one hv, sub_eq_add_neg]

def rowMap {n m : ℕ} (rows : Fin n → C m) : C n →ₗ[R] C m where
  toFun v := ∑ i, v i • rows i
  map_add' v w := by simp [add_smul, Finset.sum_add_distrib]
  map_smul' a v := by simp [Finset.smul_sum, smul_smul]

@[simp] theorem rowMap_basis {n m : ℕ} (rows : Fin n → C m) (i : Fin n) :
    rowMap rows (basis i) = rows i := by
  classical
  simp [rowMap, basis, Pi.single_apply, ite_smul]

def original : Fin 4 → Free := ![r1, r2, r3, r4]
def dB : C 4 →ₗ[R] C 5 := rowMap (fun i => fox (original i))

theorem mon_original (i : Fin 4) : mon (original i) = 1 := by
  fin_cases i <;> apply mon_relation <;> simp [original, rels]

structure Factor where
  index : Fin 4
  conjugator : Free
  positive : Bool

def factorWord (f : Factor) : Free :=
  conjugate f.conjugator (if f.positive then original f.index else (original f.index)⁻¹)

def factorChain (f : Factor) : C 4 :=
  (if f.positive then mon f.conjugator else -mon f.conjugator) • basis f.index

def witnessWord (fs : List Factor) : Free := (fs.map factorWord).prod
def witnessChain (fs : List Factor) : C 4 := (fs.map factorChain).sum

theorem mon_factor (f : Factor) : mon (factorWord f) = 1 := by
  unfold factorWord
  apply mon_conjugate
  cases f.positive <;> simp [mon_original, mon_inv_one (mon_original f.index)]

theorem dB_factor (f : Factor) : dB (factorChain f) = fox (factorWord f) := by
  cases h : f.positive <;>
    simp [factorChain, factorWord, h, dB, fox_conjugate, mon_original,
      mon_inv_one (mon_original f.index), fox_inv, neg_smul]

theorem mon_witness (fs : List Factor) : mon (witnessWord fs) = 1 := by
  induction fs with
  | nil => simp [witnessWord]
  | cons f fs ih => simpa [witnessWord, map_mul, mon_factor] using ih

theorem dB_witness (fs : List Factor) : dB (witnessChain fs) = fox (witnessWord fs) := by
  induction fs with
  | nil => simp [witnessChain, witnessWord]
  | cons f fs ih =>
      simpa only [witnessChain, witnessWord, List.map_cons, List.sum_cons,
        List.prod_cons, map_add, fox_mul, mon_factor, one_smul, dB_factor] using
        congrArg (fun z => fox (factorWord f) + z) ih

def wU1 : List Factor :=
  [⟨0, X, true⟩, ⟨0, 1, true⟩, ⟨0, A ^ 4, true⟩,
   ⟨0, A ^ 8, true⟩, ⟨0, A ^ 12, true⟩]

def wU2 : List Factor :=
  [⟨1, Y ^ 2, true⟩, ⟨1, Y, true⟩, ⟨1, Y * B ^ 3, true⟩,
   ⟨1, Y * B ^ 6, true⟩, ⟨1, 1, true⟩, ⟨1, B ^ 3, true⟩,
   ⟨1, B ^ 6, true⟩, ⟨1, B ^ 9, true⟩, ⟨1, B ^ 12, true⟩,
   ⟨1, B ^ 15, true⟩, ⟨1, B ^ 18, true⟩, ⟨1, B ^ 21, true⟩,
   ⟨1, B ^ 24, true⟩]

def wP1 : List Factor := [⟨2, X, true⟩, ⟨2, 1, true⟩]
def wP2 : List Factor :=
  [⟨3, (S * Y * S⁻¹) ^ 2, true⟩, ⟨3, S * Y * S⁻¹, true⟩, ⟨3, 1, true⟩]

def invertFactor (f : Factor) : Factor := ⟨f.index, f.conjugator, !f.positive⟩

theorem factorChain_inverted (f : Factor) :
    factorChain (invertFactor f) = -factorChain f := by
  cases h : f.positive <;> simp [invertFactor, factorChain, h, neg_smul]

theorem witnessChain_inverted (fs : List Factor) :
    witnessChain (fs.reverse.map invertFactor) = -witnessChain fs := by
  simp [witnessChain, List.map_map, Function.comp_def, factorChain_inverted]
  induction fs with
  | nil => simp
  | cons f fs ih =>
      simp only [List.map_cons, List.sum_cons, ih]
      abel

theorem witnessChain_append (fs gs : List Factor) :
    witnessChain (fs ++ gs) = witnessChain fs + witnessChain gs := by
  simp [witnessChain]

def wE1 : List Factor := wP1 ++ wU2.reverse.map invertFactor
def wE2 : List Factor := wP2 ++ wU1.reverse.map invertFactor

theorem word_U1 : witnessWord wU1 = commutator t1 A * (A ^ 15)⁻¹ := by
  simp only [witnessWord, wU1, List.map_cons, List.map_nil, List.prod_cons,
    List.prod_nil, factorWord, original, Matrix.cons_val_zero,
    if_true, conjugate, r1, commutator, t1]
  group
  simp [zpow_ofNat, pow_two, mul_assoc]

theorem word_U2 : witnessWord wU2 = commutator t2 B * (B ^ 26)⁻¹ := by
  simp [witnessWord, wU2, factorWord, original, conjugate, r2, commutator, t2]
  group

theorem word_P1 : witnessWord wP1 = t1 * (B ^ 26)⁻¹ := by
  simp [witnessWord, wP1, factorWord, original, conjugate, r3, t1]
  group
  simp [zpow_ofNat, pow_two, mul_assoc]

theorem word_P2 : witnessWord wP2 = conjugate S t2 * (A ^ 15)⁻¹ := by
  simp [witnessWord, wP2, factorWord, original, conjugate, r4, t2]
  group

theorem word_E1 : witnessWord wE1 = t1 * (commutator t2 B)⁻¹ := by
  simp [witnessWord, wE1, wP1, wU2, invertFactor, factorWord, original,
    conjugate, r3, r2, commutator, t1, t2]
  group
  simp [zpow_ofNat, pow_two, pow_succ Y 2, mul_assoc]

theorem word_E2 : witnessWord wE2 = conjugate S t2 * (commutator t1 A)⁻¹ := by
  simp [witnessWord, wE2, wP2, wU1, invertFactor, factorWord, original,
    conjugate, r4, r1, commutator, t1, t2]
  group
  simp [zpow_ofNat, pow_two, mul_assoc]

theorem A_order : mon A ^ 15 = 1 := by
  have h := mon_witness wP2
  rw [word_P2, map_mul, mon_conjugate mon_t2 S, one_mul] at h
  have k := mon_inv_mul (A ^ 15)
  rw [h, one_mul, map_pow] at k
  exact k

theorem B_order : mon B ^ 26 = 1 := by
  have h := mon_witness wP1
  rw [word_P1, map_mul, mon_t1, one_mul] at h
  have k := mon_inv_mul (B ^ 26)
  rw [h, one_mul, map_pow] at k
  exact k

def U1 : C 4 := witnessChain wU1
def U2 : C 4 := witnessChain wU2
def P1 : C 4 := witnessChain wP1
def P2 : C 4 := witnessChain wP2
def E1 : C 4 := P1 - U2
def E2 : C 4 := P2 - U1
def b1 : C 5 := fox t1
def b2 : C 5 := fox t2
def N15 : R := norm 15 (mon A)
def N26 : R := norm 26 (mon B)

theorem chain_E1 : witnessChain wE1 = E1 := by
  rw [wE1, witnessChain_append, witnessChain_inverted]
  simp only [E1, P1, U2, sub_eq_add_neg]

theorem chain_E2 : witnessChain wE2 = E2 := by
  rw [wE2, witnessChain_append, witnessChain_inverted]
  simp only [E2, P2, U1, sub_eq_add_neg]

theorem dB_U1 : dB U1 = (1 - mon A) • b1 - N15 • basis 1 := by
  rw [U1, dB_witness, word_U1,
    fox_difference (mon_commutator mon_t1 A) (by simpa only [map_pow] using A_order),
    fox_commutator mon_t1 A, fox_pow]
  simp only [b1, N15, A, fox_of]

theorem dB_U2 : dB U2 = (1 - mon B) • b2 - N26 • basis 3 := by
  rw [U2, dB_witness, word_U2,
    fox_difference (mon_commutator mon_t2 B) (by simpa only [map_pow] using B_order),
    fox_commutator mon_t2 B, fox_pow]
  simp only [b2, N26, B, fox_of]

theorem dB_P1 : dB P1 = b1 - N26 • basis 3 := by
  rw [P1, dB_witness, word_P1,
    fox_difference mon_t1 (by simpa only [map_pow] using B_order), fox_pow]
  simp only [b1, N26, B, fox_of]

theorem dB_P2 : dB P2 = mon S • b2 - N15 • basis 1 := by
  rw [P2, dB_witness, word_P2,
    fox_difference (mon_conjugate mon_t2 S) (by simpa only [map_pow] using A_order),
    fox_conjugate mon_t2 S, fox_pow]
  simp only [b2, N15, A, fox_of]

theorem dB_E1 : dB E1 = b1 - (1 - mon B) • b2 := by
  rw [E1, map_sub, dB_P1, dB_U2]
  abel

theorem dB_E2 : dB E2 = mon S • b2 - (1 - mon A) • b1 := by
  rw [E2, map_sub, dB_P2, dB_U1]
  abel

theorem norm_annihilator (n : ℕ) (a : R) (h : a ^ n = 1) :
    norm n a * (1 - a) = 0 := by
  simpa [norm, h] using geom_sum_mul_neg a n

theorem norm_square (n : ℕ) (a : R) (h : a ^ n = 1) :
    norm n a * norm n a = n • norm n a := by
  have hs : a * norm n a = norm n a := by
    have hz := mul_geom_sum a n
    change (a - 1) * norm n a = a ^ n - 1 at hz
    rw [h, sub_self, sub_mul, one_mul] at hz
    exact sub_eq_zero.mp hz
  have hi (j : ℕ) : a ^ j * norm n a = norm n a := by
    induction j with
    | zero => simp
    | succ j ih => rw [pow_succ', mul_assoc, ih, hs]
  calc
    norm n a * norm n a = ∑ j ∈ Finset.range n, a ^ j * norm n a := by
      exact Finset.sum_mul _ _ _
    _ = n • norm n a := by simp only [hi, Finset.sum_const, Finset.card_range]

def F26 : C 4 := (26 : ℕ) • P1 - N26 • U2
def F15_2 : C 4 := mon S⁻¹ • ((15 : ℕ) • P2 - N15 • U1)
def F15_1 : C 4 := (15 : ℕ) • E1 + (1 - mon B) • F15_2
def F1 : C 4 := (7 : ℕ) • F15_1 - (4 : ℕ) • F26
def F2 : C 4 := mon S⁻¹ • (E2 + (1 - mon A) • F1)

theorem dB_F26 : dB F26 = (26 : ℕ) • b1 := by
  rw [F26, map_sub, map_nsmul, map_smul, dB_P1, dB_U2]
  simp only [smul_sub, smul_smul, N26]
  rw [norm_annihilator 26 (mon B) B_order, norm_square 26 (mon B) B_order]
  simp only [zero_smul, sub_neg_eq_add, zero_sub, smul_assoc]
  abel

theorem dB_F15_2 : dB F15_2 = (15 : ℕ) • b2 := by
  have h : dB ((15 : ℕ) • P2 - N15 • U1) = (15 : ℕ) • (mon S • b2) := by
    rw [map_sub, map_nsmul, map_smul, dB_P2, dB_U1]
    simp only [smul_sub, smul_smul, N15]
    rw [norm_annihilator 15 (mon A) A_order, norm_square 15 (mon A) A_order]
    simp only [zero_smul, sub_neg_eq_add, zero_sub, smul_assoc]
    abel
  rw [F15_2, map_smul, h, smul_comm (mon S⁻¹) (15 : ℕ),
    smul_smul, mon_inv_mul, one_smul]

theorem dB_F15_1 : dB F15_1 = (15 : ℕ) • b1 := by
  rw [F15_1, map_add, map_nsmul, map_smul, dB_E1, dB_F15_2]
  rw [smul_sub, smul_comm (1 - mon B) (15 : ℕ)]
  abel

theorem dB_F1 : dB F1 = b1 := by
  rw [F1, map_sub, map_nsmul, map_nsmul, dB_F15_1, dB_F26]
  abel

theorem dB_F2 : dB F2 = b2 := by
  rw [F2, map_smul, map_add, map_smul, dB_E2, dB_F1]
  simp [smul_smul]

def fill : C 2 →ₗ[R] C 4 := rowMap ![F1, F2]
def addedBoundary : C 2 →ₗ[R] C 5 := rowMap ![b1, b2]

theorem fill_boundary (w : C 2) : dB (fill w) = addedBoundary w := by
  simp [fill, addedBoundary, rowMap, Fin.sum_univ_two, dB_F1, dB_F2]

abbrev C2 := C 4 × C 2

def D2 : C2 →ₗ[R] C 5 where
  toFun z := dB z.1 + addedBoundary z.2
  map_add' v w := by simp; abel
  map_smul' a v := by simp [smul_add]

def D3 : C 2 →ₗ[R] C2 where
  toFun w := (-fill w, w)
  map_add' v w := by simp [Prod.add_def]; abel
  map_smul' a v := by simp [Prod.smul_mk]

def q : C2 →ₗ[R] C 2 := LinearMap.snd R (C 4) (C 2)

def includeOld : C 4 →ₗ[R] C2 where
  toFun v := (v, 0)
  map_add' v w := by simp [Prod.add_def]
  map_smul' a v := by simp [Prod.smul_mk]

def retract : C2 →ₗ[R] C 4 where
  toFun z := z.1 + fill z.2
  map_add' v w := by simp; abel
  map_smul' a v := by simp [smul_add]

theorem D2_D3 (w : C 2) : D2 (D3 w) = 0 := by
  simp [D2, D3, fill_boundary]

theorem q_D3 (w : C 2) : q (D3 w) = w := rfl

theorem D3_injective : Function.Injective D3 := by
  intro u v h
  exact congrArg q h

theorem retract_include (v : C 4) : retract (includeOld v) = v := by
  simp [retract, includeOld]

theorem retract_D3 (w : C 2) : retract (D3 w) = 0 := by
  simp [retract, D3]

theorem boundary_retract (z : C2) : dB (retract z) = D2 z := by
  simp [retract, D2, fill_boundary]

theorem homotopy_degree_two (z : C2) :
    z - includeOld (retract z) = D3 (q z) := by
  apply Prod.ext
  · simp [includeOld, retract, D3, q]
  · simp [includeOld, D3, q]

theorem homotopy_degree_three (w : C 2) : q (D3 w) = w := q_D3 w

def splitCoordinates : C2 ≃ₗ[R] C2 where
  toFun z := (z.1 + fill z.2, z.2)
  invFun z := (z.1 - fill z.2, z.2)
  left_inv z := by simp
  right_inv z := by simp
  map_add' v w := by simp [Prod.add_def]; abel
  map_smul' a v := by simp [Prod.smul_mk, smul_add]

theorem split_D3 (w : C 2) : splitCoordinates (D3 w) = (0, w) := by
  simp [splitCoordinates, D3]

theorem split_boundary (z : C2) : D2 (splitCoordinates.symm z) = dB z.1 := by
  simp [splitCoordinates, D2, fill_boundary]

theorem cochain_extension {M : Type*} [AddCommGroup M] [Module R M]
    (f : C 2 →ₗ[R] M) : (f.comp q).comp D3 = f := by
  apply LinearMap.ext
  intro w
  rfl

def d1 : C 5 →ₗ[R] R where
  toFun v := ∑ i, v i * (mon (FreeGroup.of i) - 1)
  map_add' v w := by simp [add_mul, Finset.sum_add_distrib]
  map_smul' a v := by simp [Finset.mul_sum, mul_assoc]

@[simp] theorem d1_basis (i : Fin 5) : d1 (basis i) = mon (FreeGroup.of i) - 1 := by
  classical
  simp [d1, basis, Pi.single_apply, ite_mul]

theorem fox_fundamental (w : Free) : d1 (fox w) = mon w - 1 := by
  refine FreeGroup.induction_on w ?_ ?_ ?_ ?_
  · simp
  · intro i
    rw [fox_of, d1_basis]
  · intro i ih
    rw [fox_inv, map_neg, map_smul, ih]
    change -(mon (FreeGroup.of i)⁻¹ * (mon (FreeGroup.of i) - 1)) =
      mon (FreeGroup.of i)⁻¹ - 1
    rw [mul_sub, mon_inv_mul, mul_one]
    abel
  · intro u v hu hv
    rw [fox_mul, map_add, map_smul, hu, hv, map_mul]
    change (mon u - 1) + mon u * (mon v - 1) = mon u * mon v - 1
    noncomm_ring

theorem d1_dB (v : C 4) : d1 (dB v) = 0 := by
  simp [dB, rowMap, fox_fundamental, mon_original]

theorem d1_added (w : C 2) : d1 (addedBoundary w) = 0 := by
  simp [addedBoundary, rowMap, Fin.sum_univ_two, b1, b2, fox_fundamental]

theorem d1_D2 (z : C2) : d1 (D2 z) = 0 := by
  simp [D2, d1_dB, d1_added]

theorem instantiated_integral_plus :
    (∀ z : C2, d1 (D2 z) = 0) ∧
    (∀ w : C 2, D2 (D3 w) = 0 ∧ q (D3 w) = w) ∧
    (∀ v : C 4, retract (includeOld v) = v) ∧
    (∀ z : C2, dB (retract z) = D2 z ∧
      z - includeOld (retract z) = D3 (q z)) := by
  exact ⟨d1_D2, fun w => ⟨D2_D3 w, q_D3 w⟩, retract_include,
    fun z => ⟨boundary_retract z, homotopy_degree_two z⟩⟩

#print axioms instantiated_integral_plus
#print axioms cochain_extension

end IntegralPlus
