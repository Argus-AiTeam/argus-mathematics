import Mathlib.Tactic

set_option autoImplicit false

namespace ContactValueDescent

theorem exponent_mul_integer_ne_one
    (e : Nat) (he : 2 <= e) (m : Int) :
    Not ((e : Int) * m = 1) := by
  intro h
  have he0 : (0 : Int) <= (e : Int) := Int.ofNat_nonneg e
  have he2 : (2 : Int) <= (e : Int) := by exact_mod_cast he
  have hm : (1 : Int) <= m := by
    by_contra hn
    have hm0 : m <= 0 := by omega
    have hp : (e : Int) * m <= 0 :=
      mul_nonpos_of_nonneg_of_nonpos he0 hm0
    omega
  have hp : (e : Int) <= (e : Int) * m := by
    calc
      (e : Int) = (e : Int) * 1 := (mul_one _).symm
      _ <= (e : Int) * m := mul_le_mul_of_nonneg_left hm he0
  omega

theorem power_order_obstruction
    {A : Type*} [Monoid A] (order : A -> Int)
    (e : Nat) (he : 2 <= e) (z t : A)
    (hpower : order (z ^ e) = (e : Int) * order z)
    (ht : order t = 1) :
    Not (z ^ e = t) := by
  intro hroot
  apply exponent_mul_integer_ne_one e he (order z)
  calc
    (e : Int) * order z = order (z ^ e) := hpower.symm
    _ = order t := congrArg order hroot
    _ = 1 := ht

end ContactValueDescent

#print axioms ContactValueDescent.exponent_mul_integer_ne_one
#print axioms ContactValueDescent.power_order_obstruction
