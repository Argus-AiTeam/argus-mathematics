import Mathlib

namespace TensorAudit

noncomputable section

variable {ι : Type*} [Fintype ι]

abbrev Tensor (ι : Type*) := ι → ι → ι → ℝ

def total (F : Tensor ι) : ℝ := ∑ i, ∑ j, ∑ k, F i j k

def normSq (F : Tensor ι) : ℝ := total fun i j k => F i j k ^ 2

def pairing (F G : Tensor ι) : ℝ := total fun i j k => F i j k * G i j k

def swap12 (F : Tensor ι) : Tensor ι := fun i j k => F j i k

def cycle (F : Tensor ι) : Tensor ι := fun i j k => F k i j

def sym (F : Tensor ι) : Tensor ι :=
  fun i j k => (F i j k + F j i k + F k i j) / 3

def fullSym (F : Tensor ι) : Tensor ι :=
  fun i j k =>
    (F i j k + F i k j + F j i k + F j k i + F k i j + F k j i) / 6

def kernelTensor (S J : Tensor ι) : Tensor ι :=
  fun i j k => S i j k + J j i k

def symmetric3 (S : Tensor ι) : Prop :=
  (∀ i j k, S i j k = S j i k) ∧ (∀ i j k, S i j k = S i k j)

def lastSymmetric (J : Tensor ι) : Prop := ∀ i j k, J i j k = J i k j

def defect (S J : Tensor ι) : ℝ :=
  total fun i j k =>
    2 * S i j k ^ 2 + 4 * (S i j k * J i j k) +
      J i j k ^ 2 + J i j k * J j i k

theorem total_swap12 (F : Tensor ι) :
    total (fun i j k => F j i k) = total F := by
  unfold total
  exact Finset.sum_comm

theorem total_swap23 (F : Tensor ι) :
    total (fun i j k => F i k j) = total F := by
  unfold total
  apply Finset.sum_congr rfl
  intro i _
  exact Finset.sum_comm

theorem total_cycle (F : Tensor ι) :
    total (fun i j k => F k i j) = total F := by
  unfold total
  calc
    (∑ i, ∑ j, ∑ k, F k i j) = ∑ i, ∑ k, ∑ j, F k i j := by
      apply Finset.sum_congr rfl
      intro i _
      exact Finset.sum_comm
    _ = ∑ k, ∑ i, ∑ j, F k i j := Finset.sum_comm

theorem norm_swap12 (J : Tensor ι) : normSq (swap12 J) = normSq J :=
  total_swap12 fun i j k => J i j k ^ 2

theorem norm_cycle (J : Tensor ι) : normSq (cycle J) = normSq J :=
  total_cycle fun i j k => J i j k ^ 2

theorem pairing_swap12 (S J : Tensor ι) (hS : symmetric3 S) :
    pairing S (swap12 J) = pairing S J := by
  calc
    pairing S (swap12 J) =
        total (fun i j k => S j i k * J j i k) := by
      apply congrArg total
      funext i j k
      exact congrArg (fun s => s * J j i k) (hS.1 i j k)
    _ = pairing S J := total_swap12 fun i j k => S i j k * J i j k

theorem pairing_cycle (S J : Tensor ι) (hS : symmetric3 S) :
    pairing S (cycle J) = pairing S J := by
  calc
    pairing S (cycle J) =
        total (fun i j k => S k i j * J k i j) := by
      apply congrArg total
      funext i j k
      have hs : S i j k = S k i j := (hS.2 i j k).trans (hS.1 i k j)
      exact congrArg (fun s => s * J k i j) hs
    _ = pairing S J := total_cycle fun i j k => S i j k * J i j k

theorem pairing_J_cycle (J : Tensor ι) (hJ : lastSymmetric J) :
    pairing J (cycle J) = pairing J (swap12 J) := by
  calc
    pairing J (cycle J) =
        total (fun i j k => J i k j * J j i k) :=
      (total_swap23 fun i j k => J i j k * J k i j).symm
    _ = pairing J (swap12 J) := by
      apply congrArg total
      funext i j k
      exact congrArg (fun a => a * J j i k) (hJ i k j)

theorem pairing_swap_cycle (J : Tensor ι) (hJ : lastSymmetric J) :
    pairing (swap12 J) (cycle J) = pairing J (swap12 J) := by
  calc
    pairing (swap12 J) (cycle J) =
        total (fun i j k => J i j k * J k j i) :=
      (total_swap12 fun i j k => J j i k * J k i j).symm
    _ = pairing J (cycle J) := by
      apply congrArg total
      funext i j k
      exact congrArg (fun a => J i j k * a) (hJ k j i)
    _ = pairing J (swap12 J) := pairing_J_cycle J hJ

theorem norm_add (F G : Tensor ι) :
    normSq (fun i j k => F i j k + G i j k) =
      normSq F + 2 * pairing F G + normSq G := by
  simp only [normSq, pairing, total, add_sq, mul_assoc,
    Finset.sum_add_distrib, Finset.mul_sum]

theorem norm_sub (F G : Tensor ι) :
    normSq (fun i j k => F i j k - G i j k) =
      normSq F - 2 * pairing F G + normSq G := by
  simp only [normSq, pairing, total, sub_sq, mul_assoc,
    Finset.sum_add_distrib, Finset.sum_sub_distrib, Finset.mul_sum]

theorem pairing_sym (S J : Tensor ι) (hS : symmetric3 S) :
    pairing S (sym J) = pairing S J := by
  have scalar (a b c d : ℝ) :
      a * ((b + c + d) / 3) = (a * b + a * c + a * d) / 3 := by ring
  have expand : pairing S (sym J) =
      (pairing S J + pairing S (swap12 J) + pairing S (cycle J)) / 3 := by
    simp only [pairing, sym, swap12, cycle, scalar, total,
      ← Finset.sum_div, Finset.sum_add_distrib]
  rw [expand, pairing_swap12 S J hS, pairing_cycle S J hS]
  ring

theorem norm_sym (J : Tensor ι) (hJ : lastSymmetric J) :
    normSq (sym J) = (normSq J + 2 * pairing J (swap12 J)) / 3 := by
  have scalar (a b c : ℝ) :
      ((a + b + c) / 3) ^ 2 =
        (a ^ 2 + b ^ 2 + c ^ 2 + 2 * (a * b) +
          2 * (a * c) + 2 * (b * c)) / 9 := by ring
  have expand : normSq (sym J) =
      (normSq J + normSq (swap12 J) + normSq (cycle J) +
        2 * pairing J (swap12 J) + 2 * pairing J (cycle J) +
        2 * pairing (swap12 J) (cycle J)) / 9 := by
    simp only [normSq, sym, swap12, cycle, pairing, scalar, total,
      ← Finset.sum_div, Finset.sum_add_distrib, Finset.mul_sum]
  rw [expand, norm_swap12, norm_cycle, pairing_J_cycle J hJ,
    pairing_swap_cycle J hJ]
  ring

omit [Fintype ι] in
theorem fullSym_kernel (S J : Tensor ι)
    (hS : symmetric3 S) (hJ : lastSymmetric J) :
    fullSym (kernelTensor S J) = fun i j k => S i j k + sym J i j k := by
  funext i j k
  have hs1 : S i k j = S i j k := hS.2 i k j
  have hs2 : S j i k = S i j k := hS.1 j i k
  have hs3 : S j k i = S i j k := (hS.2 j k i).trans hs2
  have hs4 : S k i j = S i j k := (hS.1 k i j).trans hs1
  have hs5 : S k j i = S i j k := (hS.2 k j i).trans hs4
  have hj1 : J i k j = J i j k := hJ i k j
  have hj2 : J j k i = J j i k := hJ j k i
  have hj3 : J k j i = J k i j := hJ k j i
  simp only [fullSym, kernelTensor, sym, hs1, hs2, hs3, hs4, hs5, hj1, hj2, hj3]
  ring

theorem defect_expand (S J : Tensor ι) :
    defect S J =
      2 * normSq S + 4 * pairing S J + normSq J + pairing J (swap12 J) := by
  simp only [defect, normSq, pairing, swap12, total,
    Finset.sum_add_distrib, Finset.mul_sum]

theorem tensor_squares (S J : Tensor ι)
    (hS : symmetric3 S) (hJ : lastSymmetric J) :
    defect S J =
      2 * normSq (fun i j k => S i j k + sym J i j k) +
        normSq (fun i j k => J i j k - swap12 J i j k) / 6 := by
  rw [defect_expand, norm_add, norm_sub, pairing_sym S J hS,
    norm_sym J hJ, norm_swap12]
  ring

theorem invariant_derivative_form (S J : Tensor ι)
    (hS : symmetric3 S) (hJ : lastSymmetric J) :
    defect S J =
      normSq (kernelTensor S J) / 2 +
        3 * normSq (fullSym (kernelTensor S J)) / 2 := by
  rw [fullSym_kernel S J hS hJ, defect_expand]
  change _ = normSq (fun i j k => S i j k + swap12 J i j k) / 2 +
    3 * normSq (fun i j k => S i j k + sym J i j k) / 2
  rw [norm_add, norm_add, pairing_swap12 S J hS, norm_swap12,
    pairing_sym S J hS, norm_sym J hJ]
  ring

theorem normSq_nonnegative (F : Tensor ι) : 0 ≤ normSq F := by
  unfold normSq total
  exact Finset.sum_nonneg fun i _ =>
    Finset.sum_nonneg fun j _ => Finset.sum_nonneg fun k _ => sq_nonneg (F i j k)

theorem derivative_lower_bound (S J : Tensor ι)
    (hS : symmetric3 S) (hJ : lastSymmetric J) :
    normSq (kernelTensor S J) / 2 ≤ defect S J := by
  rw [invariant_derivative_form S J hS hJ]
  have h := normSq_nonnegative (fullSym (kernelTensor S J))
  linarith

theorem defect_nonnegative (S J : Tensor ι)
    (hS : symmetric3 S) (hJ : lastSymmetric J) : 0 ≤ defect S J := by
  have h := derivative_lower_bound S J hS hJ
  have hk := normSq_nonnegative (kernelTensor S J)
  linarith

end

end TensorAudit
