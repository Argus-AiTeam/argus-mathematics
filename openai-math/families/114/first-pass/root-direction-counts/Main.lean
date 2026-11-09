import research.«balanced-summation».Main
import RankSignatures

/-!
Ordinary integer-base pair counts along an arbitrary root line.  The imported
grouped signatures supply positive penalized weights, and the imported balanced
closure eliminates all coordinate pairs.  A finite-box bijection identifies the
limit with the actual pair count; no rank compatibility or monotonicity is assumed.
-/

noncomputable section

open Finset Filter
open scoped Topology

namespace RootDirectionCounts

set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false

attribute [local instance] Classical.propDecidable

theorem step_remove {I : Type*} [Fintype I] [DecidableEq I]
    (z : I → ℤ) (i : I) :
    RankSignatures.step z i false = BalancedSummation.remove z i := by
  funext j
  by_cases h : j = i <;>
    simp [RankSignatures.step, RankSignatures.sign, BalancedSummation.remove,
      Pi.single_apply, h, sub_eq_add_neg]

def fullWeight {E I K : Type*} [Fintype E] [DecidableEq E]
    [Fintype I] [DecidableEq I] [Fintype K] [DecidableEq K]
    (f : K → Finset E → ℤ) (H : ℝ) (b : K → E → ℤ)
    (m : I → ℕ) (a : I → K) (g : I → E) (s : K → Bool) (r : ℤ) :
    (I → ℤ) → ℝ :=
  RankSignatures.totalSlice
    (RankSignatures.boxedWeight
      (RankSignatures.groupedWeight f (fun _ => H) b (fun i => (m i : ℤ)) a g s)
      (fun i => (m i : ℤ))) r

theorem fullWeight_inputs {E I K : Type*} [Fintype E] [DecidableEq E]
    [Fintype I] [DecidableEq I] [Fintype K] [DecidableEq K]
    (f : K → Finset E → ℤ) (hf : ∀ k, RankSignatures.Submodular (f k))
    (H : ℝ) (hH : 0 ≤ H) (b : K → E → ℤ)
    (m : I → ℕ) (a : I → K) (g : I → E) (s : K → Bool) (r : ℤ) :
    BalancedSummation.Positive (fullWeight f H b m a g s r) m r ∧
      BalancedSummation.Supported (fullWeight f H b m a g s r) m r ∧
      BalancedSummation.RemovalSignature (fullWeight f H b m a g s r) m r := by
  refine ⟨?_, ?_, ?_⟩
  · intro z hz ht
    have hb : RankSignatures.InBox (fun i => (m i : ℤ)) z := hz
    simp only [fullWeight, RankSignatures.totalSlice, if_pos ht,
      RankSignatures.boxedWeight, if_pos hb, RankSignatures.groupedWeight]
    exact RankSignatures.productWeight_pos _ _ _
  · intro z hz
    by_cases ht : ∑ i, z i = r
    · have hb : ¬RankSignatures.InBox (fun i => (m i : ℤ)) z :=
        fun hb => hz ⟨hb, ht⟩
      simp [fullWeight, RankSignatures.totalSlice, RankSignatures.boxedWeight, ht, hb]
    · simp [fullWeight, RankSignatures.totalSlice, ht]
  · intro z _ _
    have h := RankSignatures.boxed_disjoint_grouped_slice_signature
      f hf (fun _ => H) (fun _ => hH) b (fun i => (m i : ℤ)) a g s r z false
    have he : BalancedSummation.test (fullWeight f H b m a g s r) z =
        (RankSignatures.quadraticMatrix (fullWeight f H b m a g s r) z false).toBilin' := by
      unfold BalancedSummation.test
      congr 1
      funext i j
      simp only [RankSignatures.quadraticMatrix, step_remove]
    rw [he]
    exact h

def widths (D : ℕ) : ℕ → List ℕ
  | 0 => []
  | n + 1 => D :: widths D n

abbrev CountIndex (D n : ℕ) := BalancedSummation.PairIndex Bool (widths D n)

def caps (M D n : ℕ) : CountIndex D n → ℕ :=
  BalancedSummation.pairCaps (fun _ : Bool => M) (widths D n)

def factor (D : ℕ) : (n : ℕ) → CountIndex D n → Bool
  | 0 => fun _ => false
  | n + 1 => Sum.elim (factor D n) id

def physical {E : Type*} (D : ℕ) (j k : E) :
    (n : ℕ) → (Fin n → E) → CountIndex D n → E
  | 0, _ => fun b : Bool => if b then k else j
  | n + 1, g => Sum.elim (physical D j k n (fun i => g i.succ)) (fun _ => g 0)

def encode (D : ℕ) : (n : ℕ) → (Bool → ℤ) → (Fin n → ℤ) → CountIndex D n → ℤ
  | 0, z, _ => z
  | n + 1, z, v =>
      BalancedSummation.join (encode D n z (fun i => v i.succ)) (v 0) ((D : ℤ) - v 0)

theorem widths_sum (D n : ℕ) : (widths D n).sum = n * D := by
  induction n with
  | zero => simp [widths]
  | succ n ih => simp [widths, ih, Nat.succ_mul, Nat.add_comm]

theorem widths_positive (D n : ℕ) (hD : 1 ≤ D) :
    ∀ d ∈ widths D n, 1 ≤ d := by
  induction n with
  | zero => simp [widths]
  | succ n ih => simpa [widths] using And.intro hD ih

theorem sumPairs_encode (D n : ℕ)
    (F : (CountIndex D n → ℤ) → ℝ) (z : Bool → ℤ) :
    BalancedSummation.sumPairs (widths D n) F z =
      ∑ v : Fin n → Fin (D + 1), F (encode D n z (fun i => (v i : ℤ))) := by
  induction n with
  | zero => simp [widths, BalancedSummation.sumPairs, encode]
  | succ n ih =>
    change BalancedSummation.sumPairs (widths D n)
      (BalancedSummation.balanced
        (fun w x y => F (BalancedSummation.join w x y)) D) z = _
    rw [ih]
    calc
      _ = ∑ v : Fin n → Fin (D + 1), ∑ q : Fin (D + 1),
          F (encode D (n + 1) z
            (fun i => ((Fin.cons q v : Fin (n + 1) → Fin (D + 1)) i : ℤ))) := by
        apply sum_congr rfl
        intro v _
        rw [BalancedSummation.balanced,
          ← Fin.sum_univ_eq_sum_range]
        apply sum_congr rfl
        intro q _
        simp [encode]
      _ = ∑ u : Fin (D + 1) × (Fin n → Fin (D + 1)),
          F (encode D (n + 1) z
            (fun i => ((Fin.cons u.1 u.2 : Fin (n + 1) → Fin (D + 1)) i : ℤ))) := by
        rw [Fintype.sum_prod_type, sum_comm]
      _ = _ := Fintype.sum_equiv (Fin.consEquiv (fun _ : Fin (n + 1) => Fin (D + 1)))
        _ _ (by intro u; rfl)

theorem grouped_encode_false {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (b : Bool → E → ℤ) (j k : E) (g : Fin n → E)
    (z : Bool → ℤ) (v : Fin n → ℤ) (e : E) :
    RankSignatures.groupedVector b (fun i => (caps M D n i : ℤ))
      (factor D n) (physical D j k n g) Bool.not (encode D n z v) false e =
      b false e + (if j = e then z false else 0) +
        (if k = e then z true else 0) + ∑ i, if g i = e then v i else 0 := by
  induction n with
  | zero =>
    change RankSignatures.groupedVector (I := Bool) b
      (fun i => (caps M D 0 i : ℤ)) (factor D 0) (physical D j k 0 g)
      Bool.not (encode D 0 z v) false e = _
    simp [RankSignatures.groupedVector, RankSignatures.orientedCount,
      caps, factor, physical, encode, widths, BalancedSummation.pairCaps,
      Fintype.sum_bool, add_assoc, add_comm, add_left_comm]
  | succ n ih =>
    calc
      _ = RankSignatures.groupedVector b (fun i => (caps M D n i : ℤ))
          (factor D n) (physical D j k n (fun i => g i.succ)) Bool.not
          (encode D n z (fun i => v i.succ)) false e +
          (if g 0 = e then v 0 else 0) := by
        change RankSignatures.groupedVector (I := CountIndex D n ⊕ Bool) b
          (fun i => (caps M D (n + 1) i : ℤ)) (factor D (n + 1))
          (physical D j k (n + 1) g) Bool.not (encode D (n + 1) z v) false e = _
        simp [RankSignatures.groupedVector, Fintype.sum_sum_type,
          Fintype.sum_bool, caps, factor, physical, encode, widths,
          BalancedSummation.pairCaps, BalancedSummation.join,
          RankSignatures.orientedCount, add_assoc]
      _ = _ := by rw [ih, Fin.sum_univ_succ]; ring

theorem grouped_encode_true {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (b : Bool → E → ℤ) (j k : E) (g : Fin n → E)
    (z : Bool → ℤ) (v : Fin n → ℤ) (e : E) :
    RankSignatures.groupedVector b (fun i => (caps M D n i : ℤ))
      (factor D n) (physical D j k n g) Bool.not (encode D n z v) true e =
      b true e + ∑ i, if g i = e then v i else 0 := by
  induction n with
  | zero =>
    change RankSignatures.groupedVector (I := Bool) b
      (fun i => (caps M D 0 i : ℤ)) (factor D 0) (physical D j k 0 g)
      Bool.not (encode D 0 z v) true e = _
    simp [RankSignatures.groupedVector, RankSignatures.orientedCount,
      caps, factor, physical, encode, widths, BalancedSummation.pairCaps,
      Fintype.sum_bool]
  | succ n ih =>
    calc
      _ = RankSignatures.groupedVector b (fun i => (caps M D n i : ℤ))
          (factor D n) (physical D j k n (fun i => g i.succ)) Bool.not
          (encode D n z (fun i => v i.succ)) true e +
          (if g 0 = e then v 0 else 0) := by
        change RankSignatures.groupedVector (I := CountIndex D n ⊕ Bool) b
          (fun i => (caps M D (n + 1) i : ℤ)) (factor D (n + 1))
          (physical D j k (n + 1) g) Bool.not (encode D (n + 1) z v) true e = _
        simp [RankSignatures.groupedVector, Fintype.sum_sum_type,
          Fintype.sum_bool, caps, factor, physical, encode, widths,
          BalancedSummation.pairCaps, BalancedSummation.join,
          RankSignatures.orientedCount, add_assoc]
      _ = _ := by rw [ih, Fin.sum_univ_succ]; ring

theorem encode_box (M D n : ℕ) (z : Bool → ℤ)
    (hz : BalancedSummation.Box (fun _ => M) z)
    (v : Fin n → Fin (D + 1)) :
    BalancedSummation.Box (caps M D n) (encode D n z (fun i => (v i : ℤ))) := by
  induction n with
  | zero => exact hz
  | succ n ih =>
    apply (BalancedSummation.box_join _ _ _ _ _).mpr
    refine ⟨ih (fun i => v i.succ), ?_, ?_, ?_, ?_⟩ <;>
      have hv := (v 0).isLt <;> dsimp <;> omega

theorem encode_total (D n : ℕ) (z : Bool → ℤ) (v : Fin n → ℤ) :
    (∑ i, encode D n z v i) = (∑ i, z i) + (n : ℤ) * D := by
  induction n with
  | zero =>
    change (∑ i : Bool, z i) = (∑ i : Bool, z i) + (0 : ℤ) * D
    ring
  | succ n ih =>
    change (∑ i : CountIndex D n ⊕ Bool,
      BalancedSummation.join (encode D n z (fun i => v i.succ))
        (v 0) ((D : ℤ) - v 0) i) = _
    rw [BalancedSummation.total_join, ih]
    push_cast
    ring

theorem sum_coordinate {E : Type*} [DecidableEq E] (n : ℕ)
    (g : Fin n ≃ E) (v : Fin n → ℤ) (e : E) :
    (∑ i, if g i = e then v i else 0) = v (g.symm e) := by
  have he : ∀ i, g i = e ↔ i = g.symm e := by
    intro i
    constructor
    · intro h
      simpa using congrArg g.symm h
    · intro h
      simp [h]
  simp_rw [he]
  simp

theorem discrete_chord (N : ℕ) (L : ℕ → ℝ)
    (hL : ∀ i, 0 < i → i < N → L (i - 1) + L (i + 1) ≤ 2 * L i) :
    ∀ r, r ≤ N →
      ((N - r : ℕ) : ℝ) * L 0 + (r : ℝ) * L N ≤ (N : ℝ) * L r := by
  induction N with
  | zero =>
    intro r hr
    have : r = 0 := by omega
    simp [this]
  | succ N ih =>
    intro r hr
    by_cases hN : N = 0
    · subst N
      have : r = 0 ∨ r = 1 := by omega
      rcases this with rfl | rfl <;> simp
    have hNp : 0 < (N : ℝ) := by exact_mod_cast (Nat.pos_of_ne_zero hN)
    have hi := ih (fun i hi hit => hL i hi (by omega))
    by_cases hrN : r = N + 1
    · subst r
      simp
    have hr' : r ≤ N := by omega
    have hn1 := hi (N - 1) (by omega)
    have hn2 := hL N (by omega) (by omega)
    have hnsub : ((N - 1 : ℕ) : ℝ) = (N : ℝ) - 1 := by
      rw [Nat.cast_sub (by omega : 1 ≤ N)]
      simp
    have hndiff : N - (N - 1) = 1 := by omega
    rw [hndiff, hnsub] at hn1
    norm_num only [Nat.cast_one] at hn1
    have hnmid : L 0 + (N : ℝ) * L (N + 1) ≤ ((N : ℝ) + 1) * L N := by
      nlinarith [mul_nonneg (le_of_lt hNp) (show 0 ≤ 2 * L N -
        (L (N - 1) + L (N + 1)) by linarith)]
    have hir := hi r hr'
    rw [Nat.cast_sub hr'] at hir
    have hmul := mul_le_mul_of_nonneg_left hir
      (show 0 ≤ (N : ℝ) + 1 by positivity)
    have hmul' := mul_le_mul_of_nonneg_left hnmid (Nat.cast_nonneg r)
    apply (mul_le_mul_iff_right₀ hNp).mp
    rw [Nat.cast_sub hr, Nat.cast_add, Nat.cast_one]
    nlinarith

theorem positive_logconcave_interpolation (N : ℕ) (v : ℕ → ℝ)
    (hp : ∀ i, i ≤ N → 0 < v i)
    (hc : ∀ i, 0 < i → i < N → v (i - 1) * v (i + 1) ≤ v i ^ 2)
    (r : ℕ) (hr : r ≤ N) :
    v 0 ^ (N - r) * v N ^ r ≤ v r ^ N := by
  have hlog : ∀ i, 0 < i → i < N →
      Real.log (v (i - 1)) + Real.log (v (i + 1)) ≤ 2 * Real.log (v i) := by
    intro i hi hin
    have hp₁ := hp (i - 1) (by omega)
    have hp₂ := hp (i + 1) (by omega)
    have h := Real.log_le_log (mul_pos hp₁ hp₂) (hc i hi hin)
    simpa only [Real.log_mul (ne_of_gt hp₁) (ne_of_gt hp₂),
      Real.log_pow, Nat.cast_ofNat] using h
  have hch := discrete_chord N (fun i => Real.log (v i)) hlog r hr
  apply (Real.log_le_log_iff
    (mul_pos (pow_pos (hp 0 (Nat.zero_le _)) _) (pow_pos (hp N le_rfl) _))
    (pow_pos (hp r hr) _)).mp
  simpa only [Real.log_mul (ne_of_gt (pow_pos (hp 0 (Nat.zero_le _)) _))
      (ne_of_gt (pow_pos (hp N le_rfl) _)), Real.log_pow] using hch

def line (M : ℕ) (r : ℤ) : Bool → ℤ :=
  fun b => if b then (M : ℤ) - r else r

theorem line_total (M : ℕ) (r : ℤ) : (∑ b, line M r b) = M := by
  simp [line, Fintype.sum_bool]

theorem line_box (M : ℕ) (r : ℤ) (hr0 : 0 ≤ r) (hrM : r ≤ M) :
    BalancedSummation.Box (fun _ => M) (line M r) := by
  intro b
  cases b <;> simp only [line, Bool.false_eq_true, if_false, if_true] <;> omega

theorem test_single {I : Type*} [Fintype I] [DecidableEq I]
    (F : (I → ℤ) → ℝ) (z : I → ℤ) (i j : I) :
    BalancedSummation.test F z (Pi.single i 1) (Pi.single j 1) =
      F (BalancedSummation.remove (BalancedSummation.remove z i) j) := by
  simp [BalancedSummation.test, Matrix.toBilin'_apply, Pi.single_apply]

theorem binary_logconcave (M : ℕ) (F : (Bool → ℤ) → ℝ)
    (hp : BalancedSummation.Positive F (fun _ => M) M)
    (hs : BalancedSummation.RemovalSignature F (fun _ => M) M)
    (r : ℤ) (hr0 : 0 < r) (hrM : r < M) :
    F (line M (r - 1)) * F (line M (r + 1)) ≤ F (line M r) ^ 2 := by
  let z : Bool → ℤ := fun b => if b then (M : ℤ) - r + 1 else r + 1
  have hz : BalancedSummation.Box (fun _ => M) z := by
    intro b
    cases b <;> dsimp [z] <;> omega
  have hzt : (∑ b, z b) = (M : ℤ) + 2 := by
    simp [z, Fintype.sum_bool]
    ring
  have hff : BalancedSummation.remove (BalancedSummation.remove z false) false =
      line M (r - 1) := by
    funext b
    cases b <;> simp [BalancedSummation.remove, z, line]
    all_goals ring
  have htt : BalancedSummation.remove (BalancedSummation.remove z true) true =
      line M (r + 1) := by
    funext b
    cases b <;> simp [BalancedSummation.remove, z, line]
    all_goals ring
  have htf : BalancedSummation.remove (BalancedSummation.remove z true) false =
      line M r := by
    funext b
    cases b <;> simp [BalancedSummation.remove, z, line]
  have hpos : 0 < BalancedSummation.test F z (Pi.single false 1) (Pi.single false 1) := by
    rw [test_single, hff]
    exact hp _ (line_box M (r - 1) (by omega) (by omega)) (line_total _ _)
  have h := (BalancedSummation.signature_iff_no_positive_plane
    (BalancedSummation.test F z) (BalancedSummation.test_symmetric F z)).mp
      (hs z hz hzt) (Pi.single false 1) (Pi.single true 1) hpos
  simpa only [test_single, hff, htt, htf] using h

def approximation {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (f : Bool → Finset E → ℤ) (H : ℝ)
    (b : Bool → E → ℤ) (j k : E) (g : Fin n → E) : (Bool → ℤ) → ℝ :=
  BalancedSummation.sumPairs (widths D n)
    (fullWeight f H b (caps M D n) (factor D n) (physical D j k n g) Bool.not
      (((widths D n).sum : ℤ) + M))

theorem approximation_inputs {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (hD : 1 ≤ D)
    (f : Bool → Finset E → ℤ) (hf : ∀ c, RankSignatures.Submodular (f c))
    (H : ℝ) (hH : 0 ≤ H) (b : Bool → E → ℤ) (j k : E) (g : Fin n → E) :
    BalancedSummation.Positive (approximation M D n f H b j k g) (fun _ => M) M ∧
      BalancedSummation.Supported (approximation M D n f H b j k g) (fun _ => M) M ∧
      BalancedSummation.RemovalSignature
        (approximation M D n f H b j k g) (fun _ => M) M := by
  have hin := fullWeight_inputs f hf H hH b (caps M D n) (factor D n)
    (physical D j k n g) Bool.not (((widths D n).sum : ℤ) + M)
  have hout := BalancedSummation.balanced_pairs_removal (fun _ : Bool => M)
    (widths D n) (widths_positive D n hD) _ _ hin.1 hin.2.1 hin.2.2
  simpa only [approximation, caps, add_sub_cancel_left] using hout

theorem approximation_interpolation {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (hD : 1 ≤ D)
    (f : Bool → Finset E → ℤ) (hf : ∀ c, RankSignatures.Submodular (f c))
    (H : ℝ) (hH : 0 ≤ H) (b : Bool → E → ℤ) (j k : E) (g : Fin n → E)
    (r : ℕ) (hr : r ≤ M) :
    approximation M D n f H b j k g (line M 0) ^ (M - r) *
        approximation M D n f H b j k g (line M M) ^ r ≤
      approximation M D n f H b j k g (line M r) ^ M := by
  have hin := approximation_inputs M D n hD f hf H hH b j k g
  apply positive_logconcave_interpolation M
    (fun q => approximation M D n f H b j k g (line M q)) _ _ r hr
  · intro q hq
    apply hin.1 _ (line_box M q (by omega) (by exact_mod_cast hq))
    exact line_total M q
  · intro q hq0 hqM
    have h := binary_logconcave M _ hin.1 hin.2.2 (q : ℤ)
      (by exact_mod_cast hq0) (by exact_mod_cast hqM)
    simpa only [Nat.cast_sub (by omega : 1 ≤ q), Nat.cast_one, Nat.cast_add] using h

def rootShift {E : Type*} [DecidableEq E] (d : E → ℤ) (j k : E) (t : ℤ) : E → ℤ :=
  fun e => d e + (if e = j then t else 0) - (if e = k then t else 0)

def rankFamily {E : Type*} (f₁ f₂ : Finset E → ℤ) : Bool → Finset E → ℤ :=
  fun c => if c then f₂ else f₁

def baseline {E : Type*} [DecidableEq E] (L d : E → ℤ) (j k : E)
    (A : ℤ) (M : ℕ) : Bool → E → ℤ :=
  fun c e => if c then L e else
    L e + d e + (if e = j then A else 0) - (if e = k then A + M else 0)

def baseVector {E : Type*} {n D : ℕ}
    (L : E → ℤ) (g : Fin n ≃ E) (v : Fin n → Fin (D + 1)) : E → ℤ :=
  fun e => L e + (v (g.symm e) : ℤ)

theorem encoded_vector_false {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (L d : E → ℤ) (j k : E) (A r : ℤ)
    (g : Fin n ≃ E) (v : Fin n → Fin (D + 1)) :
    RankSignatures.groupedVector (baseline L d j k A M)
      (fun i => (caps M D n i : ℤ)) (factor D n) (physical D j k n g)
      Bool.not (encode D n (line M r) (fun i => (v i : ℤ))) false =
      fun e => baseVector L g v e + rootShift d j k (A + r) e := by
  funext e
  rw [grouped_encode_false, sum_coordinate]
  simp only [baseline, Bool.false_eq_true, if_false, line, if_true,
    baseVector, rootShift]
  simp only [eq_comm]
  split_ifs <;> ring

theorem encoded_vector_true {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (L d : E → ℤ) (j k : E) (A r : ℤ)
    (g : Fin n ≃ E) (v : Fin n → Fin (D + 1)) :
    RankSignatures.groupedVector (baseline L d j k A M)
      (fun i => (caps M D n i : ℤ)) (factor D n) (physical D j k n g)
      Bool.not (encode D n (line M r) (fun i => (v i : ℤ))) true =
      baseVector L g v := by
  funext e
  rw [grouped_encode_true, sum_coordinate]
  rfl

def boxCount {E : Type*} [Fintype E] [DecidableEq E]
    (D n : ℕ) (g : Fin n ≃ E) (f₁ f₂ : Finset E → ℤ)
    (L d : E → ℤ) (j k : E) (t : ℤ) : ℝ :=
  ∑ v : Fin n → Fin (D + 1),
    if RankSignatures.InBase f₁ (fun e => baseVector L g v e + rootShift d j k t e) ∧
      RankSignatures.InBase f₂ (baseVector L g v) then 1 else 0

theorem approximation_limit {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (g : Fin n ≃ E) (f₁ f₂ : Finset E → ℤ)
    (h₁ : f₁ ∅ = 0) (h₂ : f₂ ∅ = 0) (L d : E → ℤ) (j k : E)
    (A r : ℤ) (hr0 : 0 ≤ r) (hrM : r ≤ M) :
    Tendsto (fun H : ℝ => approximation M D n (rankFamily f₁ f₂) H
        (baseline L d j k A M) j k g (line M r)) atTop
      (𝓝 (boxCount D n g f₁ f₂ L d j k (A + r))) := by
  unfold approximation boxCount
  simp_rw [sumPairs_encode]
  apply tendsto_finsetSum
  intro v _
  have hb := encode_box M D n (line M r) (line_box M r hr0 hrM) v
  have ht : (∑ i, encode D n (line M r) (fun i => (v i : ℤ)) i) =
      ((widths D n).sum : ℤ) + M := by
    rw [encode_total, line_total, widths_sum]
    push_cast
    ring
  have hn : ∀ c, rankFamily f₁ f₂ c ∅ = 0 := by
    intro c
    cases c
    · exact h₁
    · exact h₂
  have hlim := RankSignatures.boxed_groupedWeight_limit (rankFamily f₁ f₂) hn
    (baseline L d j k A M) (fun i => (caps M D n i : ℤ))
    (factor D n) (physical D j k n g) Bool.not
    (encode D n (line M r) (fun i => (v i : ℤ)))
  have hb' : RankSignatures.InBox (fun i => (caps M D n i : ℤ))
      (encode D n (line M r) (fun i => (v i : ℤ))) := hb
  simpa only [fullWeight, RankSignatures.totalSlice, if_pos ht, hb', true_and,
    Bool.forall_bool, rankFamily, Bool.false_eq_true, if_false, if_true,
    encoded_vector_false, encoded_vector_true, and_comm] using hlim

theorem boxCount_interpolation {E : Type*} [Fintype E] [DecidableEq E]
    (M D n : ℕ) (hD : 1 ≤ D) (g : Fin n ≃ E) (f₁ f₂ : Finset E → ℤ)
    (hf₁ : RankSignatures.Submodular f₁) (hf₂ : RankSignatures.Submodular f₂)
    (h₁ : f₁ ∅ = 0) (h₂ : f₂ ∅ = 0) (L d : E → ℤ) (j k : E)
    (A : ℤ) (r : ℕ) (hr : r ≤ M) :
    boxCount D n g f₁ f₂ L d j k A ^ (M - r) *
        boxCount D n g f₁ f₂ L d j k (A + M) ^ r ≤
      boxCount D n g f₁ f₂ L d j k (A + r) ^ M := by
  have hf : ∀ c, RankSignatures.Submodular (rankFamily f₁ f₂ c) := by
    intro c
    cases c
    · exact hf₁
    · exact hf₂
  have h0 := approximation_limit M D n g f₁ f₂ h₁ h₂ L d j k A 0
    le_rfl (by omega)
  have hM := approximation_limit M D n g f₁ f₂ h₁ h₂ L d j k A M
    (by omega) le_rfl
  have hr' := approximation_limit M D n g f₁ f₂ h₁ h₂ L d j k A r
    (by omega) (by exact_mod_cast hr)
  simp only [add_zero] at h0
  apply le_of_tendsto_of_tendsto ((h0.pow (M - r)).mul (hM.pow r)) (hr'.pow M)
  filter_upwards [eventually_ge_atTop (0 : ℝ)] with H hH
  exact approximation_interpolation M D n hD (rankFamily f₁ f₂) hf H hH
    (baseline L d j k A M) j k g r hr

theorem base_coordinate_bounds {E : Type*} [Fintype E] [DecidableEq E]
    (f : Finset E → ℤ) (x : E → ℤ) (hx : RankSignatures.InBase f x) (e : E) :
    f univ - f (univ.erase e) ≤ x e ∧ x e ≤ f {e} := by
  have hu := hx.2 {e}
  have hl := hx.2 (univ.erase e)
  have ht := sum_erase_add (s := (univ : Finset E)) (f := x) (mem_univ e)
  simp only [sum_singleton] at hu
  rw [hx.1] at ht
  constructor <;> omega

theorem exists_base_box {E : Type*} [Fintype E] [DecidableEq E]
    (f : Finset E → ℤ) :
    ∃ (L : E → ℤ) (D : ℕ), 2 ≤ D ∧
      ∀ x, RankSignatures.InBase f x → ∀ e, L e ≤ x e ∧ x e ≤ L e + D := by
  let S : ℕ := ∑ A : Finset E, (f A).natAbs
  let R : ℕ := 2 * S + 1
  have hbound : ∀ A, -(S : ℤ) ≤ f A ∧ f A ≤ S := by
    intro A
    have hn : (f A).natAbs ≤ S := by
      dsimp [S]
      exact single_le_sum (fun B _ => Nat.zero_le (f B).natAbs) (mem_univ A)
    have hn' : ((f A).natAbs : ℤ) ≤ S := by exact_mod_cast hn
    have hp := Int.le_natAbs (a := f A)
    have hm := Int.le_natAbs (a := -(f A))
    simp only [Int.natAbs_neg] at hm
    constructor <;> omega
  refine ⟨fun _ => -(R : ℤ), 2 * R, by dsimp [R]; omega, ?_⟩
  intro x hx e
  have hb := base_coordinate_bounds f x hx e
  have hE := hbound univ
  have hEc := hbound (univ.erase e)
  have he := hbound {e}
  have hR : (R : ℤ) = 2 * (S : ℤ) + 1 := by simp [R]
  change -(R : ℤ) ≤ x e ∧ x e ≤ -(R : ℤ) + ((2 * R : ℕ) : ℤ)
  push_cast
  constructor <;> omega

def BasePairs {E : Type*} [Fintype E] [DecidableEq E]
    (f₁ f₂ : Finset E → ℤ) (δ : E → ℤ) :=
  {p : (E → ℤ) × (E → ℤ) //
    RankSignatures.InBase f₁ p.1 ∧ RankSignatures.InBase f₂ p.2 ∧
      ∀ e, p.1 e - p.2 e = δ e}

def pairCount {E : Type*} [Fintype E] [DecidableEq E]
    (f₁ f₂ : Finset E → ℤ) (d : E → ℤ) (j k : E) (t : ℤ) : ℕ :=
  Nat.card (BasePairs f₁ f₂ (rootShift d j k t))

def GoodChoice {E : Type*} [Fintype E] [DecidableEq E]
    (D n : ℕ) (g : Fin n ≃ E) (f₁ f₂ : Finset E → ℤ)
    (L δ : E → ℤ) (v : Fin n → Fin (D + 1)) : Prop :=
  RankSignatures.InBase f₁ (fun e => baseVector L g v e + δ e) ∧
    RankSignatures.InBase f₂ (baseVector L g v)

def choiceOf {E : Type*} (D n : ℕ) (g : Fin n ≃ E) (L x : E → ℤ)
    (hx : ∀ e, L e ≤ x e ∧ x e ≤ L e + D) : Fin n → Fin (D + 1) :=
  fun i => ⟨(x (g i) - L (g i)).toNat, by have := hx (g i); omega⟩

theorem baseVector_choiceOf {E : Type*} (D n : ℕ) (g : Fin n ≃ E) (L x : E → ℤ)
    (hx : ∀ e, L e ≤ x e ∧ x e ≤ L e + D) :
    baseVector L g (choiceOf D n g L x hx) = x := by
  funext e
  have he := hx e
  simp only [baseVector, choiceOf, Equiv.apply_symm_apply]
  rw [Int.toNat_of_nonneg (by omega : 0 ≤ x e - L e)]
  omega

def choiceToPair {E : Type*} [Fintype E] [DecidableEq E]
    (D n : ℕ) (g : Fin n ≃ E) (f₁ f₂ : Finset E → ℤ) (L δ : E → ℤ) :
    {v // GoodChoice D n g f₁ f₂ L δ v} → BasePairs f₁ f₂ δ :=
  fun v => ⟨((fun e => baseVector L g v.val e + δ e), baseVector L g v.val),
    v.property.1, v.property.2, by intro e; ring⟩

def boxPairEquiv {E : Type*} [Fintype E] [DecidableEq E]
    (D n : ℕ) (g : Fin n ≃ E) (f₁ f₂ : Finset E → ℤ) (L δ : E → ℤ)
    (hbox : ∀ x, RankSignatures.InBase f₂ x → ∀ e, L e ≤ x e ∧ x e ≤ L e + D) :
    {v // GoodChoice D n g f₁ f₂ L δ v} ≃ BasePairs f₁ f₂ δ :=
  Equiv.ofBijective (choiceToPair D n g f₁ f₂ L δ) (by
    constructor
    · intro v w hvw
      apply Subtype.ext
      funext i
      apply Fin.ext
      have he := congrArg (fun p : BasePairs f₁ f₂ δ => p.val.2 (g i)) hvw
      change L (g i) + (v.val (g.symm (g i)) : ℤ) =
        L (g i) + (w.val (g.symm (g i)) : ℤ) at he
      simp only [Equiv.symm_apply_apply] at he
      have he' : (v.val i : ℤ) = (w.val i : ℤ) := by omega
      exact_mod_cast he'
    · intro p
      let v := choiceOf D n g L p.val.2 (hbox _ p.property.2.1)
      have hx₂ : baseVector L g v = p.val.2 :=
        baseVector_choiceOf D n g L p.val.2 _
      have hx₁ : (fun e => baseVector L g v e + δ e) = p.val.1 := by
        funext e
        have he := p.property.2.2 e
        rw [hx₂]
        omega
      have hv : GoodChoice D n g f₁ f₂ L δ v := by
        unfold GoodChoice
        rw [hx₁, hx₂]
        exact ⟨p.property.1, p.property.2.1⟩
      refine ⟨⟨v, hv⟩, ?_⟩
      apply Subtype.ext
      exact Prod.ext hx₁ hx₂)

theorem basePairs_finite {E : Type*} [Fintype E] [DecidableEq E]
    (f₁ f₂ : Finset E → ℤ) (δ : E → ℤ) : Finite (BasePairs f₁ f₂ δ) := by
  obtain ⟨L, D, _, hbox⟩ := exists_base_box f₂
  exact Finite.of_equiv _
    (boxPairEquiv D (Fintype.card E) (Fintype.equivFin E).symm f₁ f₂ L δ hbox)

theorem boxCount_eq_pairCount {E : Type*} [Fintype E] [DecidableEq E]
    (D n : ℕ) (g : Fin n ≃ E) (f₁ f₂ : Finset E → ℤ)
    (L d : E → ℤ) (j k : E)
    (hbox : ∀ x, RankSignatures.InBase f₂ x → ∀ e, L e ≤ x e ∧ x e ≤ L e + D)
    (t : ℤ) :
    boxCount D n g f₁ f₂ L d j k t = (pairCount f₁ f₂ d j k t : ℝ) := by
  have he := Nat.card_congr (boxPairEquiv D n g f₁ f₂ L (rootShift d j k t) hbox)
  rw [Nat.card_eq_fintype_card] at he
  unfold pairCount
  rw [← he, Fintype.card_subtype]
  simp only [boxCount, GoodChoice]
  rw [sum_ite]
  simp

theorem pairCount_interpolation {E : Type*} [Fintype E] [DecidableEq E]
    (f₁ f₂ : Finset E → ℤ)
    (hf₁ : RankSignatures.Submodular f₁) (hf₂ : RankSignatures.Submodular f₂)
    (h₁ : f₁ ∅ = 0) (h₂ : f₂ ∅ = 0) (d : E → ℤ) (j k : E)
    (a t b : ℤ) (hat : a < t) (htb : t < b) :
    pairCount f₁ f₂ d j k a ^ (b - t).toNat *
        pairCount f₁ f₂ d j k b ^ (t - a).toNat ≤
      pairCount f₁ f₂ d j k t ^ (b - a).toNat := by
  obtain ⟨L, D, hD, hbox⟩ := exists_base_box f₂
  let n := Fintype.card E
  let g : Fin n ≃ E := (Fintype.equivFin E).symm
  let M := (b - a).toNat
  let r := (t - a).toNat
  have hM : (M : ℤ) = b - a := Int.toNat_of_nonneg (by omega)
  have hrz : (r : ℤ) = t - a := Int.toNat_of_nonneg (by omega)
  have hr : r ≤ M := by omega
  have hbr : M - r = (b - t).toNat := by omega
  have haM : a + (M : ℤ) = b := by omega
  have har : a + (r : ℤ) = t := by omega
  have hi := boxCount_interpolation M D n (by omega) g f₁ f₂ hf₁ hf₂ h₁ h₂
    L d j k a r hr
  rw [haM, har] at hi
  simp only [boxCount_eq_pairCount D n g f₁ f₂ L d j k hbox] at hi
  have hi' : pairCount f₁ f₂ d j k a ^ (M - r) *
      pairCount f₁ f₂ d j k b ^ r ≤ pairCount f₁ f₂ d j k t ^ M := by
    exact_mod_cast hi
  rw [hbr] at hi'
  exact hi'

theorem pairCount_positive_between {E : Type*} [Fintype E] [DecidableEq E]
    (f₁ f₂ : Finset E → ℤ)
    (hf₁ : RankSignatures.Submodular f₁) (hf₂ : RankSignatures.Submodular f₂)
    (h₁ : f₁ ∅ = 0) (h₂ : f₂ ∅ = 0) (d : E → ℤ) (j k : E)
    (a t b : ℤ) (hat : a ≤ t) (htb : t ≤ b)
    (ha : 0 < pairCount f₁ f₂ d j k a) (hb : 0 < pairCount f₁ f₂ d j k b) :
    0 < pairCount f₁ f₂ d j k t := by
  by_cases hta : t = a
  · simpa only [hta] using ha
  by_cases htb' : t = b
  · simpa only [htb'] using hb
  have hi := pairCount_interpolation f₁ f₂ hf₁ hf₂ h₁ h₂ d j k a t b
    (by omega) (by omega)
  by_contra hn
  have hz : pairCount f₁ f₂ d j k t = 0 := by omega
  have hN : (b - a).toNat ≠ 0 := by omega
  rw [hz, zero_pow hN] at hi
  have hp : 0 < pairCount f₁ f₂ d j k a ^ (b - t).toNat *
      pairCount f₁ f₂ d j k b ^ (t - a).toNat := by positivity
  omega

theorem rootShift_eq_root_direction {E : Type*} [DecidableEq E]
    (d : E → ℤ) (j k : E) (t : ℤ) :
    rootShift d j k t = d + t • (Pi.single j 1 - Pi.single k 1) := by
  funext e
  by_cases hj : e = j <;> by_cases hk : e = k <;>
    simp [rootShift, Pi.single_apply, hj, hk, smul_eq_mul] <;> split_ifs <;> ring

theorem root_direction_logconcavity {E : Type*} [Fintype E] [DecidableEq E]
    (f₁ f₂ : Finset E → ℤ)
    (hf₁ : RankSignatures.Submodular f₁) (hf₂ : RankSignatures.Submodular f₂)
    (h₁ : f₁ ∅ = 0) (h₂ : f₂ ∅ = 0) (d : E → ℤ) (j k : E) (_hjk : j ≠ k) :
    Set.OrdConnected {t : ℤ | 0 < pairCount f₁ f₂ d j k t} ∧
      ∀ a t b : ℤ, a < t → t < b →
        0 < pairCount f₁ f₂ d j k a → 0 < pairCount f₁ f₂ d j k b →
        pairCount f₁ f₂ d j k a ^ (b - t).toNat *
            pairCount f₁ f₂ d j k b ^ (t - a).toNat ≤
          pairCount f₁ f₂ d j k t ^ (b - a).toNat := by
  constructor
  · constructor
    intro a ha b hb t ht
    exact pairCount_positive_between f₁ f₂ hf₁ hf₂ h₁ h₂ d j k a t b
      ht.1 ht.2 ha hb
  · intro a t b hat htb _ _
    exact pairCount_interpolation f₁ f₂ hf₁ hf₂ h₁ h₂ d j k a t b hat htb

theorem root_direction_real_interpolation {E : Type*} [Fintype E] [DecidableEq E]
    (f₁ f₂ : Finset E → ℤ)
    (hf₁ : RankSignatures.Submodular f₁) (hf₂ : RankSignatures.Submodular f₂)
    (h₁ : f₁ ∅ = 0) (h₂ : f₂ ∅ = 0) (d : E → ℤ) (j k : E)
    (a t b : ℤ) (hat : a < t) (htb : t < b)
    (ha : 0 < pairCount f₁ f₂ d j k a) (hb : 0 < pairCount f₁ f₂ d j k b) :
    (pairCount f₁ f₂ d j k a : ℝ) ^ (((b : ℝ) - t) / ((b : ℝ) - a)) *
        (pairCount f₁ f₂ d j k b : ℝ) ^ (((t : ℝ) - a) / ((b : ℝ) - a)) ≤
      (pairCount f₁ f₂ d j k t : ℝ) := by
  have haR : 0 < (pairCount f₁ f₂ d j k a : ℝ) := by exact_mod_cast ha
  have hbR : 0 < (pairCount f₁ f₂ d j k b : ℝ) := by exact_mod_cast hb
  have htR : 0 < (pairCount f₁ f₂ d j k t : ℝ) := by
    exact_mod_cast pairCount_positive_between f₁ f₂ hf₁ hf₂ h₁ h₂ d j k a t b
      (le_of_lt hat) (le_of_lt htb) ha hb
  have hi : (pairCount f₁ f₂ d j k a : ℝ) ^ (b - t).toNat *
      (pairCount f₁ f₂ d j k b : ℝ) ^ (t - a).toNat ≤
        (pairCount f₁ f₂ d j k t : ℝ) ^ (b - a).toNat := by
    exact_mod_cast pairCount_interpolation f₁ f₂ hf₁ hf₂ h₁ h₂ d j k a t b hat htb
  have hlog := Real.log_le_log
    (mul_pos (pow_pos haR (b - t).toNat) (pow_pos hbR (t - a).toNat)) hi
  simp only [Real.log_mul (ne_of_gt (pow_pos haR (b - t).toNat))
    (ne_of_gt (pow_pos hbR (t - a).toNat)), Real.log_pow] at hlog
  have hcast (m : ℤ) (hm : 0 ≤ m) : (m.toNat : ℝ) = (m : ℝ) := by
    exact_mod_cast Int.toNat_of_nonneg hm
  rw [hcast (b - t) (by omega), hcast (t - a) (by omega),
    hcast (b - a) (by omega)] at hlog
  push_cast at hlog
  have hN : 0 < (b : ℝ) - a := by
    exact_mod_cast (show 0 < b - a by omega)
  rw [Real.rpow_def_of_pos haR, Real.rpow_def_of_pos hbR, ← Real.exp_add,
    ← Real.exp_log htR]
  apply Real.exp_le_exp.mpr
  have hd :
      (Real.log (pairCount f₁ f₂ d j k a : ℝ) * ((b : ℝ) - t) +
        Real.log (pairCount f₁ f₂ d j k b : ℝ) * ((t : ℝ) - a)) /
          ((b : ℝ) - a) ≤ Real.log (pairCount f₁ f₂ d j k t : ℝ) :=
    (div_le_iff₀ hN).2 (by nlinarith [hlog])
  convert hd using 1 <;> ring

#print BasePairs
#print pairCount
#check boxPairEquiv
#check basePairs_finite
#check rootShift_eq_root_direction
#check pairCount_interpolation
#check root_direction_logconcavity
#check root_direction_real_interpolation
#print axioms boxPairEquiv
#print axioms basePairs_finite
#print axioms pairCount_interpolation
#print axioms root_direction_logconcavity
#print axioms root_direction_real_interpolation

end RootDirectionCounts
