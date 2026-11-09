import Mathlib

open scoped BigOperators

namespace RawLength

variable {E V I F : Type*}

noncomputable def mass [Fintype E] (w x : E → ℝ) : ℝ :=
  ∑ e, w e * |x e|

noncomputable def projection [Fintype E]
    (image : E → Option I) (sign x : E → ℝ) (i : I) : ℝ := by
  classical
  exact ∑ e, if image e = some i then sign e * x e else 0

noncomputable def clipped (live : I → Prop)
    (image : E → Option I) (x : E → ℝ) (e : E) : ℝ := by
  classical
  exact if (match image e with | none => True | some i => live i) then x e else 0

theorem projection_clip [Fintype E]
    (live : I → Prop) [DecidablePred live]
    (image : E → Option I) (sign x : E → ℝ) (i : I) :
    projection image sign (clipped live image x) i =
      if live i then projection image sign x i else 0 := by
  classical
  by_cases hi : live i
  · simp only [hi, if_true, projection]
    apply Finset.sum_congr rfl
    intro e _
    by_cases he : image e = some i
    · simp [he, clipped, hi]
    · simp [he]
  · simp only [hi, if_false, projection]
    apply Finset.sum_eq_zero
    intro e _
    by_cases he : image e = some i
    · simp [he, clipped, hi]
    · simp [he]

theorem projection_add [Fintype E]
    (image : E → Option I) (sign x y : E → ℝ) (i : I) :
    projection image sign (fun e => x e + y e) i =
      projection image sign x i + projection image sign y i := by
  classical
  simp only [projection, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro e _
  split_ifs <;> ring

theorem mass_nonneg [Fintype E] (w x : E → ℝ) (hw : ∀ e, 0 ≤ w e) :
    0 ≤ mass w x :=
  Finset.sum_nonneg fun e _ => mul_nonneg (hw e) (abs_nonneg _)

theorem mass_add [Fintype E] (w x y : E → ℝ) (hw : ∀ e, 0 ≤ w e) :
    mass w (fun e => x e + y e) ≤ mass w x + mass w y := by
  unfold mass
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro e _
  calc
    w e * |x e + y e| ≤ w e * (|x e| + |y e|) :=
      mul_le_mul_of_nonneg_left (abs_add_le _ _) (hw e)
    _ = w e * |x e| + w e * |y e| := by ring

theorem mass_sub [Fintype E] (w x y : E → ℝ) (hw : ∀ e, 0 ≤ w e) :
    mass w (fun e => x e - y e) ≤ mass w x + mass w y := by
  simpa only [sub_eq_add_neg, mass, abs_neg] using
    mass_add w x (fun e => -y e) hw

theorem mass_scale [Fintype E] (w x : E → ℝ) (a : ℝ) :
    mass w (fun e => a * x e) = |a| * mass w x := by
  simp only [mass, abs_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro e _
  ring

theorem mass_sum [Fintype E] [Fintype F]
    (w : E → ℝ) (x : F → E → ℝ) (hw : ∀ e, 0 ≤ w e) :
    mass w (fun e => ∑ f, x f e) ≤ ∑ f, mass w (x f) := by
  calc
    mass w (fun e => ∑ f, x f e)
        ≤ ∑ e, w e * ∑ f, |x f e| := by
      apply Finset.sum_le_sum
      intro e _
      exact mul_le_mul_of_nonneg_left (Finset.abs_sum_le_sum_abs _ _) (hw e)
    _ = ∑ f, mass w (x f) := by
      simp only [mass, Finset.mul_sum]
      rw [Finset.sum_comm]

theorem linear_mass_le [Fintype E] [Fintype V]
    (A : V → E → ℝ) (w : V → ℝ) (u x : E → ℝ)
    (hw : ∀ v, 0 ≤ w v)
    (hcol : ∀ e, (∑ v, w v * |A v e|) ≤ u e) :
    mass w (fun v => ∑ e, A v e * x e) ≤ mass u x := by
  calc
    mass w (fun v => ∑ e, A v e * x e)
        ≤ ∑ e, mass w (fun v => A v e * x e) :=
      mass_sum w (fun e v => A v e * x e) hw
    _ = ∑ e, (∑ v, w v * |A v e|) * |x e| := by
      apply Finset.sum_congr rfl
      intro e _
      simp only [mass, abs_mul, Finset.sum_mul, mul_assoc]
    _ ≤ mass u x := by
      apply Finset.sum_le_sum
      intro e _
      exact mul_le_mul_of_nonneg_right (hcol e) (abs_nonneg _)

noncomputable def incidence [Fintype E]
    (tail head : E → V) (x : E → ℝ) (v : V) : ℝ := by
  classical
  exact ∑ e, ((if head e = v then (1 : ℝ) else 0) -
    (if tail e = v then (1 : ℝ) else 0)) * x e

theorem incidence_mass_le [Fintype E] [Fintype V]
    (tail head : E → V) (x : E → ℝ) :
    mass (fun _ => 1) (incidence tail head x) ≤ 2 * mass (fun _ => 1) x := by
  classical
  have hcol : ∀ e, (∑ v,
      |(if head e = v then (1 : ℝ) else 0) -
        (if tail e = v then (1 : ℝ) else 0)|) ≤ 2 := by
    intro e
    calc
      _ ≤ ∑ v, (|(if head e = v then (1 : ℝ) else 0)| +
          |(if tail e = v then (1 : ℝ) else 0)|) :=
        Finset.sum_le_sum fun v _ => abs_sub _ _
      _ = 2 := by
        have habs (z v : V) :
            |if z = v then (1 : ℝ) else 0| =
              (if z = v then (1 : ℝ) else 0) := by
          split_ifs <;> norm_num
        simp only [Finset.sum_add_distrib]
        simp_rw [habs]
        norm_num [eq_comm]
  have h := linear_mass_le
    (fun v e => (if head e = v then (1 : ℝ) else 0) -
      (if tail e = v then (1 : ℝ) else 0))
    (fun _ => 1) (fun _ => 2) x (fun _ => by norm_num)
    (by simpa only [one_mul] using hcol)
  simpa only [incidence, mass, one_mul, Finset.mul_sum] using h

theorem completion_cost_le [Fintype E] [Fintype V]
    (tail head : E → V) (w x : E → ℝ) (n : ℝ)
    (hw : ∀ e, 1 ≤ w e) :
    mass w x + mass (fun _ => 1) (incidence tail head x) + n
      ≤ 3 * mass w x + n := by
  have hweight : mass (fun _ => 1) x ≤ mass w x := by
    apply Finset.sum_le_sum
    intro e _
    exact mul_le_mul_of_nonneg_right (hw e) (abs_nonneg _)
  have hi := incidence_mass_le tail head x
  linarith

def walkNet [DecidableEq E] (walk : List (E × Bool)) (e : E) : ℝ :=
  (walk.map fun p => if p.1 = e then if p.2 then 1 else -1 else 0).sum

def walkRaw (w : E → ℝ) (walk : List (E × Bool)) : ℝ :=
  (walk.map fun p => w p.1).sum

theorem cancel_pair [DecidableEq E]
    (pre post : List (E × Bool)) (e v : E) (w : E → ℝ) :
    walkNet (pre ++ [(e, true), (e, false)] ++ post) v =
        walkNet (pre ++ post) v ∧
      walkRaw w (pre ++ [(e, true), (e, false)] ++ post) =
        walkRaw w (pre ++ post) + 2 * w e := by
  constructor
  · by_cases he : e = v <;> simp [walkNet, he]
  · simp only [walkRaw, List.map_append, List.sum_append,
      List.map_cons, List.map_nil, List.sum_cons, List.sum_nil]
    ring

theorem cancellation_nonexpansive [DecidableEq E]
    (pre post : List (E × Bool)) (e : E) (w : E → ℝ) (hw : 0 ≤ w e) :
    walkRaw w (pre ++ post) ≤
      walkRaw w (pre ++ [(e, true), (e, false)] ++ post) := by
  have h := (cancel_pair pre post e e w).2
  linarith

theorem raw_score_preserved (g score childRaw parentRaw : ℝ)
    (hs : 0 ≤ score) (hlen : parentRaw ≤ childRaw)
    (hscore : score * childRaw ≤ |g|) :
    score * parentRaw ≤ |g| :=
  (mul_le_mul_of_nonneg_left hlen hs).trans hscore

theorem transfer_bound (A X Y beta Z L O q v localPart childPart : ℝ)
    (hO : 0 ≤ O)
    (hq : q ≤ (2 * beta + 1) * A * X)
    (hv : v ≤ 3 * q + Y)
    (hl : |localPart| ≤ 2 * Z * A * X * L)
    (hc : |childPart| ≤ v * O) :
    |localPart + childPart| ≤
      2 * Z * A * X * L + ((6 * beta + 3) * A * X + Y) * O := by
  have hv' : v ≤ (6 * beta + 3) * A * X + Y := by
    calc
      v ≤ 3 * q + Y := hv
      _ ≤ 3 * ((2 * beta + 1) * A * X) + Y := by linarith
      _ = (6 * beta + 3) * A * X + Y := by ring
  calc
    |localPart + childPart| ≤ |localPart| + |childPart| := abs_add_le _ _
    _ ≤ 2 * Z * A * X * L + ((6 * beta + 3) * A * X + Y) * O :=
      add_le_add hl (hc.trans (mul_le_mul_of_nonneg_right hv' hO))

theorem max_transfer (A X Y beta Z L O T : ℝ)
    (hA : 1 ≤ A) (hX : 0 ≤ X) (hY : 0 ≤ Y)
    (hb : 0 ≤ beta) (hZ : 1 ≤ Z) (hT : 0 ≤ T)
    (hL : L ≤ T) (hO : O ≤ T) :
    2 * Z * A * X * L + ((6 * beta + 3) * A * X + Y) * O
      ≤ (2 * Z + 6 * beta + 3) * A * (X + Y) * T := by
  have hA0 : 0 ≤ A := le_trans (by norm_num) hA
  have hZ0 : 0 ≤ Z := le_trans (by norm_num) hZ
  have hlocal : 0 ≤ 2 * Z * A * X := by positivity
  have hchild : 0 ≤ (6 * beta + 3) * A * X + Y := by positivity
  have hcoef : 1 ≤ (2 * Z + 6 * beta + 3) * A := by
    have hbase : 1 ≤ 2 * Z + 6 * beta + 3 := by linarith
    nlinarith
  have hy : Y * T ≤ ((2 * Z + 6 * beta + 3) * A) * (Y * T) :=
    le_mul_of_one_le_left (mul_nonneg hY hT) hcoef
  calc
    _ ≤ 2 * Z * A * X * T + ((6 * beta + 3) * A * X + Y) * T :=
      add_le_add (mul_le_mul_of_nonneg_left hL hlocal)
        (mul_le_mul_of_nonneg_left hO hchild)
    _ ≤ (2 * Z + 6 * beta + 3) * A * (X + Y) * T := by
      nlinarith only [hy]

theorem improved_constant (p A : ℝ) (hp : 0 ≤ p) (hA : 0 ≤ A) :
    (2 * (40 * (p + 1)) + 6 * (17 * (p + 1)) + 3) * A
      ≤ 5 * (40 * (p + 1)) * A := by
  have h : 2 * (40 * (p + 1)) + 6 * (17 * (p + 1)) + 3
      ≤ 5 * (40 * (p + 1)) := by linarith
  nlinarith

theorem manuscript_child_constant (p : ℝ) (hp : 0 ≤ p) :
    6 * (17 * (p + 1)) + 3 ≤ 12 * (40 * (p + 1)) := by
  linarith

theorem guarded_loss (A Z b : ℝ) (hA : 0 ≤ A) (hZ : 0 ≤ Z)
    (hguard : 20 * Z * A ≤ b ^ 2) :
    5 * Z * A ≤ b ^ 2 := by
  nlinarith [mul_nonneg hA hZ]

theorem recursive_choice (eta L O child : ℝ)
    (hL : 0 ≤ L) (heta : eta ≤ 1) (hchild : eta * O ≤ child) :
    eta * max L O ≤ max L child := by
  by_cases h : L ≤ O
  · rw [max_eq_right h]
    exact hchild.trans (le_max_right _ _)
  · rw [max_eq_left (le_of_not_ge h)]
    have h' : eta * L ≤ L := by nlinarith
    exact h'.trans (le_max_left _ _)

theorem outer_exponent_margin (a u : ℝ)
    (ha : 1 ≤ a) (hu : 2 * a ^ 2 ≤ u) :
    a ^ 2 ≤ (6 * a + 8) * u := by
  have hu0 : 0 ≤ u := by nlinarith [sq_nonneg a]
  have hcoef : 1 ≤ 6 * a + 8 := by linarith
  have hsmall : a ^ 2 ≤ u := by nlinarith [sq_nonneg a]
  exact hsmall.trans (le_mul_of_one_le_left hu0 hcoef)

end RawLength
