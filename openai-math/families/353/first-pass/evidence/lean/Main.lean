import Mathlib

noncomputable section

namespace CapGrowthAudit

def delta (n : Real) : Real := 1 / (n + 2)

def theta (n : Real) : Real := (n + 2) / (2 * (n + 1))

theorem interpolation_exponents (n : Real) (hn : 0 < n) :
    0 < theta n /\ theta n < 1 /\
      theta n * (1 - delta n) = 1 / 2 /\
      delta n * theta n + (1 - theta n) = 1 / 2 := by
  have h1 : n + 1 > 0 := by linarith
  have h2 : n + 2 > 0 := by linarith
  refine ⟨div_pos h2 (by positivity), ?_, ?_, ?_⟩
  · unfold theta
    apply (div_lt_one (by positivity : 0 < 2 * (n + 1))).2
    linarith
  · unfold theta delta
    field_simp [ne_of_gt h1, ne_of_gt h2]
    <;> ring
  · unfold theta delta
    field_simp [ne_of_gt h1, ne_of_gt h2]
    <;> ring

theorem weighted_interpolation
    (n D R t : Real) (hn : 0 < n)
    (hD : 0 < D) (hR : 0 < R) (ht : 0 < t) :
    Real.sqrt (D * R) * t =
      (D ^ delta n * R ^ (1 - delta n) * t) ^ theta n *
        (D * t) ^ (1 - theta n) := by
  have h1 : Ne (n + 1) 0 := by linarith
  have h2 : Ne (n + 2) 0 := by linarith
  have hA : 0 < D ^ delta n * R ^ (1 - delta n) * t := by positivity
  have hB : 0 < D * t := mul_pos hD ht
  have hL : 0 < Real.sqrt (D * R) * t := by positivity
  have hU :
      0 < (D ^ delta n * R ^ (1 - delta n) * t) ^ theta n *
        (D * t) ^ (1 - theta n) := by positivity
  have hlog :
      Real.log (Real.sqrt (D * R) * t) =
        Real.log ((D ^ delta n * R ^ (1 - delta n) * t) ^ theta n *
          (D * t) ^ (1 - theta n)) := by
    rw [Real.log_mul (by positivity) (ne_of_gt ht),
      Real.sqrt_eq_rpow, Real.log_rpow (mul_pos hD hR),
      Real.log_mul (ne_of_gt hD) (ne_of_gt hR)]
    rw [Real.log_mul (by positivity) (by positivity),
      Real.log_rpow hA, Real.log_rpow hB]
    rw [Real.log_mul (by positivity) (ne_of_gt ht),
      Real.log_mul (by positivity) (by positivity),
      Real.log_rpow hD, Real.log_rpow hR,
      Real.log_mul (ne_of_gt hD) (ne_of_gt ht)]
    unfold delta theta
    field_simp [h1, h2]
    <;> ring
  calc
    Real.sqrt (D * R) * t =
        Real.exp (Real.log (Real.sqrt (D * R) * t)) := (Real.exp_log hL).symm
    _ = Real.exp (Real.log
        ((D ^ delta n * R ^ (1 - delta n) * t) ^ theta n *
          (D * t) ^ (1 - theta n))) := congrArg Real.exp hlog
    _ = _ := Real.exp_log hU

theorem quadratic_nonnegative
    (a b c p d : Real) (ha : 0 < a) (hdet : 0 <= a * b - c ^ 2) :
    0 <= a * p ^ 2 + 2 * c * p * d + b * d ^ 2 := by
  have hs : 0 <= (a * p + c * d) ^ 2 + (a * b - c ^ 2) * d ^ 2 :=
    add_nonneg (sq_nonneg _) (mul_nonneg hdet (sq_nonneg _))
  have hid :
      (a * p + c * d) ^ 2 + (a * b - c ^ 2) * d ^ 2 =
        a * (a * p ^ 2 + 2 * c * p * d + b * d ^ 2) := by ring
  rw [hid] at hs
  by_contra hneg
  have hneg' : a * p ^ 2 + 2 * c * p * d + b * d ^ 2 < 0 :=
    lt_of_not_ge hneg
  have := mul_neg_of_pos_of_neg ha hneg'
  linarith

theorem scalar_coercivity
    (n p d : Real) (hnlo : 3 <= n) (hnhi : n <= 9) :
    (1 / 256 : Real) * (p ^ 2 + d ^ 2) <=
      (n - 7 / 8) * p ^ 2 + (n + 2) / 2 * p * d + 15 / 16 * d ^ 2 := by
  let a : Real := n - 7 / 8 - 1 / 256
  let b : Real := 15 / 16 - 1 / 256
  let c : Real := (n + 2) / 4
  have ha : 0 < a := by dsimp [a]; linarith
  have hprod : 0 <= (n - 2) * (9 - n) :=
    mul_nonneg (by linarith) (by linarith)
  have hdet : 0 <= a * b - c ^ 2 := by
    dsimp [a, b, c]
    nlinarith [hprod]
  have hq := quadratic_nonnegative a b c p d ha hdet
  calc
    (1 / 256 : Real) * (p ^ 2 + d ^ 2) <=
        (1 / 256 : Real) * (p ^ 2 + d ^ 2) +
          (a * p ^ 2 + 2 * c * p * d + b * d ^ 2) :=
      le_add_of_nonneg_right hq
    _ = _ := by dsimp [a, b, c]; ring

theorem finite_coercivity
    (n : Real) (k r : Nat) (hnlo : 3 <= n) (hnhi : n <= 9)
    (hk : 2 <= k) (p d : Fin k -> Real) (z : Fin r -> Real) :
    (1 / 256 : Real) *
        (1 + Finset.univ.sum (fun i => p i ^ 2) +
          Finset.univ.sum (fun i => d i ^ 2) +
          Finset.univ.sum (fun i => z i ^ 2)) <=
      (k : Real) - 15 / 8 +
        Finset.univ.sum (fun i =>
          (n - 7 / 8) * p i ^ 2 + (n + 2) / 2 * p i * d i +
            15 / 16 * d i ^ 2) +
        15 / 16 * Finset.univ.sum (fun i => z i ^ 2) := by
  have hpairs := Finset.sum_le_sum
    (s := Finset.univ) (fun (i : Fin k) _ =>
      scalar_coercivity n (p i) (d i) hnlo hnhi)
  have hkR : (2 : Real) <= k := by exact_mod_cast hk
  have hc : (1 / 256 : Real) <= (k : Real) - 15 / 8 := by linarith
  have hz0 : 0 <= Finset.univ.sum (fun i => z i ^ 2) :=
    Finset.sum_nonneg (fun _ _ => sq_nonneg _)
  have hz :
      (1 / 256 : Real) * Finset.univ.sum (fun i => z i ^ 2) <=
        15 / 16 * Finset.univ.sum (fun i => z i ^ 2) := by linarith
  calc
    _ = (1 / 256 : Real) +
        Finset.univ.sum (fun i => (1 / 256 : Real) * (p i ^ 2 + d i ^ 2)) +
        (1 / 256 : Real) * Finset.univ.sum (fun i => z i ^ 2) := by
      simp only [mul_add, Finset.sum_add_distrib, <- Finset.mul_sum]
      ring
    _ <= _ := add_le_add (add_le_add hc hpairs) hz

theorem frame_gram (k : Nat) (i j : Fin k) :
    (Finset.univ.sum (fun r : Fin k =>
      (1 + if r = i then 1 else 0 : Real) *
        (1 + if r = j then 1 else 0 : Real))) =
      (if i = j then 1 else 0 : Real) + (k : Real) + 2 := by
  classical
  have hid (r : Fin k) :
      (1 + if r = i then 1 else 0 : Real) *
          (1 + if r = j then 1 else 0 : Real) =
        1 + (if r = i then 1 else 0 : Real) +
          (if r = j then 1 else 0 : Real) +
          (if r = i then (if i = j then 1 else 0 : Real) else 0) := by
    split_ifs <;> simp_all <;> ring
  simp_rw [hid]
  simp only [Finset.sum_add_distrib]
  simp
  <;> ring

theorem recurrence_lower
    (mass : Nat -> Real) (q c : Real) (N : Nat)
    (hq : 0 <= q) (h0 : c <= mass 0)
    (hstep : forall l : Nat, l < N -> q * mass l <= mass (l + 1)) :
    c * q ^ N <= mass N := by
  have h : forall t : Nat, t <= N -> c * q ^ t <= mass t := by
    intro t
    induction t with
    | zero =>
        intro _
        simpa using h0
    | succ t ih =>
        intro ht
        have htN : t < N := by omega
        have hi := ih (by omega)
        calc
          c * q ^ (t + 1) = q * (c * q ^ t) := by rw [pow_succ]; ring
          _ <= q * mass t := mul_le_mul_of_nonneg_left hi hq
          _ <= mass (t + 1) := hstep t htN
  exact h N (Nat.le_refl N)

theorem finite_box_contradiction
    (mass : Nat -> Real) (q c upper : Real) (N : Nat)
    (hq : 0 <= q) (h0 : c <= mass 0)
    (hstep : forall l : Nat, l < N -> q * mass l <= mass (l + 1))
    (hupper : mass N <= upper) (hchoice : upper < c * q ^ N) : False := by
  have hlower := recurrence_lower mass q c N hq h0 hstep
  linarith

end CapGrowthAudit
