import Mathlib

namespace CutSymbol

def rootExcess (ad ae bd be : Int) : Int :=
  max (ad - ae) 0 + max (bd - be) 0 -
    max (ad + bd - ae - be) 0

def framingExcess (a b : Int) : Int :=
  max (a - 1) 0 + max b 0 - max (a + b - 1) 0

theorem excess_nonnegative (u v : Int) :
    0 ≤ max u 0 + max v 0 - max (u + v) 0 := by
  simp only [max_def]
  split_ifs <;> omega

theorem root_excess_disjoint (ad ae bd be : Int)
    (had : 0 ≤ ad) (hae : 0 ≤ ae) (hbd : 0 ≤ bd) (hbe : 0 ≤ be)
    (hd : ad = 0 ∨ bd = 0) (he : ae = 0 ∨ be = 0) :
    rootExcess ad ae bd be = min ad be + min bd ae := by
  rcases hd with hd | hd <;> rcases he with he | he <;>
    simp_all [rootExcess, max_def, min_def] <;> split_ifs <;> omega

theorem framing_excess_disjoint (a b : Int)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hd : a = 0 ∨ b = 0) :
    framingExcess a b = if 0 < b then 1 else 0 := by
  rcases hd with hd | hd <;>
    simp_all [framingExcess, max_def] <;> split_ifs <;> omega

theorem support_length {ι : Type*} [DecidableEq ι] (A B : Finset ι) :
    (A ∪ B).card + (A ∩ B).card = A.card + B.card := by
  classical
  exact Finset.card_union_add_card_inter A B

theorem overlap_strictly_lowers_length {ι : Type*} [DecidableEq ι] (A B : Finset ι)
    (h : (A ∩ B).Nonempty) :
    (A ∪ B).card < A.card + B.card := by
  classical
  have hpos : 0 < (A ∩ B).card := Finset.card_pos.mpr h
  have hcard := support_length A B
  omega

theorem oriented_root_sign {R : Type*} [CommRing R]
    (x y : R) (u v : Nat) :
    (y - x) ^ u * (x - y) ^ v =
      (-1 : R) ^ u * (x - y) ^ (u + v) := by
  have h : y - x = -(x - y) := by ring
  rw [h, neg_pow, pow_add]
  ring

theorem finite_sign_product {ι R : Type*} [CommRing R]
    (T : Finset ι) (ε : ι → Nat) (f : ι → R) :
    (∏ d ∈ T, ((-1 : R) ^ (ε d) * f d)) =
      (-1 : R) ^ (∑ d ∈ T, ε d) * (∏ d ∈ T, f d) := by
  classical
  induction T using Finset.induction_on with
  | empty => simp
  | @insert d T hd ih =>
      simp only [Finset.prod_insert hd, Finset.sum_insert hd, ih, pow_add]
      ring

theorem finite_root_excess {ι : Type*} (T : Finset ι)
    (ad ae bd be : ι → Int)
    (had : ∀ d ∈ T, 0 ≤ ad d) (hae : ∀ d ∈ T, 0 ≤ ae d)
    (hbd : ∀ d ∈ T, 0 ≤ bd d) (hbe : ∀ d ∈ T, 0 ≤ be d)
    (hd : ∀ d ∈ T, ad d = 0 ∨ bd d = 0)
    (he : ∀ d ∈ T, ae d = 0 ∨ be d = 0) :
    (∑ d ∈ T, rootExcess (ad d) (ae d) (bd d) (be d)) =
      (∑ d ∈ T, min (ad d) (be d)) +
        (∑ d ∈ T, min (bd d) (ae d)) := by
  calc
    (∑ d ∈ T, rootExcess (ad d) (ae d) (bd d) (be d)) =
        ∑ d ∈ T, (min (ad d) (be d) + min (bd d) (ae d)) := by
      apply Finset.sum_congr rfl
      intro d hdT
      exact root_excess_disjoint (ad d) (ae d) (bd d) (be d)
        (had d hdT) (hae d hdT) (hbd d hdT) (hbe d hdT)
        (hd d hdT) (he d hdT)
    _ = _ := Finset.sum_add_distrib

end CutSymbol
