import Mathlib

namespace OrderedMatrix190

theorem radix_unique (m q a b c : Nat) (hq : q ∣ m)
    (hb : b < m) (hc : c < m)
    (hquot : (a + b) % m / q = (a + c) % m / q)
    (hrem : b % q = c % q) : b = c := by
  have hr : (a + b) % m % q = (a + c) % m % q := by
    calc
      (a + b) % m % q = (a + b) % q := Nat.mod_mod_of_dvd _ hq
      _ = (a % q + b % q) % q := Nat.add_mod _ _ _
      _ = (a % q + c % q) % q := by rw [hrem]
      _ = (a + c) % q := (Nat.add_mod _ _ _).symm
      _ = (a + c) % m % q := (Nat.mod_mod_of_dvd _ hq).symm
  have hs : (a + b) % m = (a + c) % m := by
    calc
      (a + b) % m = (a + b) % m % q + q * ((a + b) % m / q) :=
        (Nat.mod_add_div _ _).symm
      _ = (a + c) % m % q + q * ((a + c) % m / q) := by rw [hr, hquot]
      _ = (a + c) % m := Nat.mod_add_div _ _
  have hbc : Nat.ModEq m b c :=
    Nat.ModEq.add_left_cancel' a (show Nat.ModEq m (a + b) (a + c) from hs)
  simpa only [Nat.ModEq, Nat.mod_eq_of_lt hb, Nat.mod_eq_of_lt hc] using hbc

theorem cyclic_radix_injective (m q a : Nat) (hq : q ∣ m) :
    Function.Injective
      (fun b : Fin m => ((a + b.val) % m / q, b.val % q)) := by
  intro b c h
  apply Fin.ext
  exact radix_unique m q a b.val c.val hq b.isLt c.isLt
    (congrArg Prod.fst h) (congrArg Prod.snd h)

def AvoidP (a b c d : Bool) : Prop :=
  ¬ (a = true ∧ b = false ∧ c = true ∧ d = true)

theorem avoid_vertical_iff (a b : Bool) :
    AvoidP true a true b ↔ (b = true → a = true) := by
  cases a <;> cases b <;> simp [AvoidP]

theorem avoid_horizontal_iff (a b : Bool) :
    AvoidP a b true true ↔ (a = true → b = true) := by
  cases a <;> cases b <;> simp [AvoidP]

theorem shared_leaf_obstruction (h : Nat)
    (plus minus crossPlus crossMinus : Nat → Bool)
    (hp0 : plus 0 = true) (hm0 : minus 0 = false)
    (vp : ∀ i, i < h → AvoidP true (crossPlus i) true (plus i))
    (vm : ∀ i, i < h → AvoidP true (minus i) true (crossMinus i))
    (wp : ∀ i, i < h → AvoidP (crossPlus i) (plus (i + 1)) true true)
    (wm : ∀ i, i < h → AvoidP (minus (i + 1)) (crossMinus i) true true)
    (shared : plus h = minus h) : False := by
  have propagation : ∀ i, i ≤ h → plus i = true ∧ minus i = false := by
    intro i
    induction i with
    | zero =>
        intro _
        exact ⟨hp0, hm0⟩
    | succ i ih =>
        intro hi
        have ilt : i < h := by omega
        obtain ⟨hpi, hmi⟩ := ih (by omega)
        have hcp : crossPlus i = true :=
          (avoid_vertical_iff (crossPlus i) (plus i)).mp (vp i ilt) hpi
        have hpn : plus (i + 1) = true :=
          (avoid_horizontal_iff (crossPlus i) (plus (i + 1))).mp (wp i ilt) hcp
        have hcm : crossMinus i = false := by
          cases he : crossMinus i with
          | false => rfl
          | true =>
              have bad : minus i = true :=
                (avoid_vertical_iff (minus i) (crossMinus i)).mp (vm i ilt) he
              rw [hmi] at bad
              contradiction
        have hmn : minus (i + 1) = false := by
          cases he : minus (i + 1) with
          | false => rfl
          | true =>
              have bad : crossMinus i = true :=
                (avoid_horizontal_iff (minus (i + 1)) (crossMinus i)).mp (wm i ilt) he
              rw [hcm] at bad
              contradiction
        exact ⟨hpn, hmn⟩
  obtain ⟨hph, hmh⟩ := propagation h le_rfl
  rw [shared, hmh] at hph
  contradiction

theorem v_plus_exclusion (p a b : Nat)
    (horder : p / 2 ≤ a) (hone : a ≤ b) : ¬ b < p / 2 := by
  omega

theorem v_minus_exclusion (p a b : Nat)
    (horder : a ≤ p / 2) (hzero : b ≤ a) : ¬ p / 2 < b := by
  omega

theorem parity_parent_order (p q : Nat)
    (hparity : p % 2 = q % 2) (hparent : p / 2 ≤ q / 2) : p ≤ q := by
  omega

theorem w_plus_exclusion (p q b : Nat)
    (hparity : p % 2 = q % 2)
    (horder : b ≤ q / 2) (hone : p / 2 ≤ b) : ¬ q < p := by
  have hpq := parity_parent_order p q hparity (by omega)
  omega

theorem w_minus_nonleaf_exclusion (p q b : Nat)
    (hparity : p % 2 = q % 2)
    (horder : q / 2 ≤ b) (hzero : b ≤ p / 2) : ¬ p < q := by
  have hqp := parity_parent_order q p hparity.symm (by omega)
  omega

theorem w_minus_leaf_classification (p q b : Nat)
    (hparity : p % 2 = q % 2)
    (horder : q / 2 ≤ b) (hzero : b ≤ p / 2) (hone : p ≤ q) :
    p = q ∧ b = p / 2 := by
  have hqp := parity_parent_order q p hparity.symm (by omega)
  have heq : p = q := by omega
  constructor
  · exact heq
  · omega

def unitSignature (j u : Fin 64) : Bool := decide (u = j)

theorem unit_deletion_no_new_role (j l : Fin 64) (g : Fin 64 → Bool)
    (hmono : ∀ u, g u = true → unitSignature l u = true)
    (hrole : g = unitSignature j) : j = l := by
  have hj : g j = true := by simp [hrole, unitSignature]
  have hl := hmono j hj
  simpa [unitSignature] using hl

def suppressFirst (g : Fin 64 → Bool) (u : Fin 64) : Bool :=
  if u = 0 then false else g u

theorem suppress_first_unit :
    suppressFirst (unitSignature 0) = fun _ => false := by
  funext u
  by_cases hu : u = 0 <;> simp [suppressFirst, unitSignature, hu]

theorem two_rectangles (t : Nat) :
    t * (2 * t) + t * (2 * t) = (2 * t) ^ 2 := by
  ring

theorem repair_power_count (r : Nat) :
    2 ^ r * 2 ^ (r + 1) + 2 ^ r * 2 ^ (r + 1) = (2 ^ (r + 1)) ^ 2 := by
  rw [pow_succ]
  ring

theorem exact_copy_count_identity (m : Nat) :
    m * m * 2 * m ^ 128 = 2 * m ^ 130 := by
  ring

theorem squared_power (h : Nat) : (2 ^ h) ^ 2 = (4 : Nat) ^ h := by
  calc
    (2 ^ h) ^ 2 = 2 ^ h * 2 ^ h := by ring
    _ = (2 * 2) ^ h := (mul_pow 2 2 h).symm
    _ = (4 : Nat) ^ h := by norm_num

theorem retained_copy_bound (m n : Nat) (hm : 2 ≤ m) (hn : m ≤ n) :
    2 * m ^ 130 ≤ m * n ^ 130 := by
  calc
    2 * m ^ 130 ≤ m * m ^ 130 := Nat.mul_le_mul_right _ hm
    _ ≤ m * n ^ 130 := Nat.mul_le_mul_left _ (Nat.pow_le_pow_left hn 130)

end OrderedMatrix190
