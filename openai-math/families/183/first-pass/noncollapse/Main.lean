import Mathlib

/-!
Three-direction compactness in the max norm on `ℝ × ℝ`.
The bounded-image directional defect is uniform in the source points.
-/

open Filter Set Topology

namespace ThreeDirection

abbrev Plane := ℝ × ℝ

def seg (x y : Plane) (t : ℝ) : Plane := (1 - t) • x + t • y

def SameLine (x y : Plane) : Prop :=
  x.2 = y.2 ∨ x.1 = y.1 ∨ x.1 - x.2 = y.1 - y.2

def Turning (f : Plane → Plane) (H : ℝ) : Prop :=
  ∀ x y, SameLine x y → ∀ t ∈ Icc (0 : ℝ) 1,
    ‖f (seg x y t) - f x‖ ≤ H * ‖f y - f x‖

def Defect (f : Plane → Plane) (R ε : ℝ) : Prop :=
  ∀ x y, ‖f x‖ ≤ R → ‖f y‖ ≤ R →
    (x.2 = y.2 → |(f y).2 - (f x).2| ≤ ε) ∧
    (x.1 = y.1 → |(f y).1 - (f x).1| ≤ ε) ∧
    (x.1 - x.2 = y.1 - y.2 →
      |((f y).1 - (f y).2) - ((f x).1 - (f x).2)| ≤ ε)

def VanishingDefect (F : ℕ → Plane → Plane) : Prop :=
  ∀ R > 0, ∀ ε > 0, ∀ᶠ n in atTop, Defect (F n) R ε

def EventuallyBounded (F : ℕ → Plane → Plane) (x : Plane) : Prop :=
  ∃ B : ℝ, 0 ≤ B ∧ ∀ᶠ n in atTop, ‖F n x‖ ≤ B

lemma abs_fst_le (x : Plane) : |x.1| ≤ ‖x‖ := by
  simpa only [Prod.norm_def, Real.norm_eq_abs] using
    (le_max_left ‖x.1‖ ‖x.2‖)

lemma abs_snd_le (x : Plane) : |x.2| ≤ ‖x‖ := by
  simpa only [Prod.norm_def, Real.norm_eq_abs] using
    (le_max_right ‖x.1‖ ‖x.2‖)

lemma norm_le {x : Plane} {B : ℝ} (h₁ : |x.1| ≤ B) (h₂ : |x.2| ≤ B) :
    ‖x‖ ≤ B := by
  simpa only [Prod.norm_def, Real.norm_eq_abs] using max_le h₁ h₂

lemma continuous_seg (x y : Plane) : Continuous (seg x y) := by
  unfold seg
  fun_prop

@[simp] lemma seg_zero (x y : Plane) : seg x y 0 = x := by simp [seg]
@[simp] lemma seg_one (x y : Plane) : seg x y 1 = y := by simp [seg]
@[simp] lemma add_zero_pair (x : Plane) : x + (0, 0) = x := by ext <;> simp

lemma segment_bound {f : Plane → Plane} {H B : ℝ} (hH : 0 ≤ H)
    (ht : Turning f H) {x y : Plane} (hxy : SameLine x y)
    (hx : ‖f x‖ ≤ B) (hy : ‖f y‖ ≤ B) {t : ℝ} (htm : t ∈ Icc (0 : ℝ) 1) :
    ‖f (seg x y t)‖ ≤ (1 + 2 * H) * B := by
  calc
    ‖f (seg x y t)‖ = ‖(f (seg x y t) - f x) + f x‖ := by rw [sub_add_cancel]
    _ ≤ ‖f (seg x y t) - f x‖ + ‖f x‖ := norm_add_le _ _
    _ ≤ H * ‖f y - f x‖ + ‖f x‖ := by linarith [ht x y hxy t htm]
    _ ≤ H * (‖f y‖ + ‖f x‖) + ‖f x‖ :=
      by nlinarith [mul_le_mul_of_nonneg_left (norm_sub_le (f y) (f x)) hH]
    _ ≤ (1 + 2 * H) * B := by nlinarith

lemma EventuallyBounded.segment {F : ℕ → Plane → Plane} {H : ℝ}
    (hH : 0 ≤ H) (ht : ∀ n, Turning (F n) H) {x y : Plane}
    (hx : EventuallyBounded F x) (hy : EventuallyBounded F y) (hxy : SameLine x y)
    {t : ℝ} (htm : t ∈ Icc (0 : ℝ) 1) :
    EventuallyBounded F (seg x y t) := by
  obtain ⟨B, hB, hb⟩ := hx
  obtain ⟨C, hC, hc⟩ := hy
  refine ⟨(1 + 2 * H) * max B C, by positivity, ?_⟩
  filter_upwards [hb, hc] with n hn hm
  exact segment_bound hH (ht n) hxy
    (hn.trans (le_max_left _ _)) (hm.trans (le_max_right _ _)) htm

/-- Continuity, not injectivity, supplies the finite-radius exit point. -/
lemma bound_of_no_exit {f : Plane → Plane} (hf : Continuous f)
    {p : ℝ → Plane} (hp : Continuous p) {R : ℝ}
    (h₀ : ‖f (p 0)‖ ≤ R)
    (havoid : ∀ t ∈ Icc (0 : ℝ) 1, ‖f (p t)‖ = R → False) :
    ‖f (p 1)‖ ≤ R := by
  by_contra h
  have hr : R ≤ ‖f (p 1)‖ := le_of_lt (lt_of_not_ge h)
  obtain ⟨t, htm, ht⟩ :=
    intermediate_value_Icc (by norm_num : (0 : ℝ) ≤ 1)
      ((hf.comp hp).norm.continuousOn) ⟨h₀, hr⟩
  exact havoid t htm ht

lemma diagonal_bound_horizontal {f : Plane → Plane} {H B : ℝ}
    (hf : Continuous f) (hH : 0 ≤ H) (hB : 0 ≤ B) (ht : Turning f H)
    (hd : Defect f ((1 + 2 * H) * B + 2 * B + 3) 1)
    (x : Plane) (a : ℝ) (hx : ‖f x‖ ≤ B)
    (hy : ‖f (x + (a, 0))‖ ≤ B) :
    ‖f (x + (a, a))‖ ≤ (1 + 2 * H) * B + 2 * B + 3 := by
  let C := (1 + 2 * H) * B
  let R := C + 2 * B + 3
  have hC : B ≤ C := by dsimp [C]; nlinarith
  have hR : C ≤ R := by dsimp [R]; linarith
  have hxs : ‖f x‖ ≤ R := hx.trans (hC.trans hR)
  have hp : Continuous (fun t : ℝ => x + (t * a, t * a)) := by fun_prop
  have he := bound_of_no_exit hf hp (R := R) (by simpa using hxs) ?_
  · simpa using he
  intro t htm hex
  let q : Plane := x + (t * a, 0)
  let p : Plane := x + (t * a, t * a)
  have heq : seg x (x + (a, 0)) t = q := by
    ext <;> simp [seg, q] <;> ring
  have hq : ‖f q‖ ≤ C := by
    rw [← heq]
    exact segment_bound hH ht (Or.inl (by simp)) hx hy htm
  have hpr : ‖f p‖ ≤ R := le_of_eq hex
  have hv := (hd q p (hq.trans hR) hpr).2.1 (by simp [q, p])
  have hdg := (hd x p hxs hpr).2.2 (by simp [p])
  have hx₁ := (abs_le.mp ((abs_fst_le (f x)).trans hx))
  have hx₂ := (abs_le.mp ((abs_snd_le (f x)).trans hx))
  have hq₁ := (abs_le.mp ((abs_fst_le (f q)).trans hq))
  have hv' := abs_le.mp hv
  have hd' := abs_le.mp hdg
  have hp₁ : |(f p).1| ≤ C + 2 * B + 2 := abs_le.mpr ⟨by linarith, by linarith⟩
  have hp₂ : |(f p).2| ≤ C + 2 * B + 2 := abs_le.mpr ⟨by linarith, by linarith⟩
  have := norm_le hp₁ hp₂
  change ‖f p‖ = R at hex
  dsimp [R] at hex
  linarith

lemma diagonal_bound_vertical {f : Plane → Plane} {H B : ℝ}
    (hf : Continuous f) (hH : 0 ≤ H) (hB : 0 ≤ B) (ht : Turning f H)
    (hd : Defect f ((1 + 2 * H) * B + 2 * B + 3) 1)
    (x : Plane) (a : ℝ) (hx : ‖f x‖ ≤ B)
    (hy : ‖f (x + (0, a))‖ ≤ B) :
    ‖f (x + (a, a))‖ ≤ (1 + 2 * H) * B + 2 * B + 3 := by
  let C := (1 + 2 * H) * B
  let R := C + 2 * B + 3
  have hC : B ≤ C := by dsimp [C]; nlinarith
  have hR : C ≤ R := by dsimp [R]; linarith
  have hxs : ‖f x‖ ≤ R := hx.trans (hC.trans hR)
  have hp : Continuous (fun t : ℝ => x + (t * a, t * a)) := by fun_prop
  have he := bound_of_no_exit hf hp (R := R) (by simpa using hxs) ?_
  · simpa using he
  intro t htm hex
  let q : Plane := x + (0, t * a)
  let p : Plane := x + (t * a, t * a)
  have heq : seg x (x + (0, a)) t = q := by
    ext <;> simp [seg, q] <;> ring
  have hq : ‖f q‖ ≤ C := by
    rw [← heq]
    exact segment_bound hH ht (Or.inr (Or.inl (by simp))) hx hy htm
  have hpr : ‖f p‖ ≤ R := le_of_eq hex
  have hv := (hd q p (hq.trans hR) hpr).1 (by simp [q, p])
  have hdg := (hd x p hxs hpr).2.2 (by simp [p])
  have hx₁ := (abs_le.mp ((abs_fst_le (f x)).trans hx))
  have hx₂ := (abs_le.mp ((abs_snd_le (f x)).trans hx))
  have hq₂ := (abs_le.mp ((abs_snd_le (f q)).trans hq))
  have hv' := abs_le.mp hv
  have hd' := abs_le.mp hdg
  have hp₁ : |(f p).1| ≤ C + 2 * B + 2 := abs_le.mpr ⟨by linarith, by linarith⟩
  have hp₂ : |(f p).2| ≤ C + 2 * B + 2 := abs_le.mpr ⟨by linarith, by linarith⟩
  have := norm_le hp₁ hp₂
  change ‖f p‖ = R at hex
  dsimp [R] at hex
  linarith

lemma axis_bound_diagonal {f : Plane → Plane} {H B : ℝ}
    (hf : Continuous f) (hH : 0 ≤ H) (hB : 0 ≤ B) (ht : Turning f H)
    (hd : Defect f ((1 + 2 * H) * B + B + 3) 1)
    (x : Plane) (a : ℝ) (hx : ‖f x‖ ≤ B)
    (hy : ‖f (x + (a, a))‖ ≤ B) :
    ‖f (x + (a, 0))‖ ≤ (1 + 2 * H) * B + B + 3 ∧
    ‖f (x + (0, a))‖ ≤ (1 + 2 * H) * B + B + 3 := by
  let C := (1 + 2 * H) * B
  let R := C + B + 3
  have hC : B ≤ C := by dsimp [C]; nlinarith
  have hR : C ≤ R := by dsimp [R]; linarith
  have hxs : ‖f x‖ ≤ R := hx.trans (hC.trans hR)
  have hdiag : ∀ t ∈ Icc (0 : ℝ) 1, ‖f (x + (t * a, t * a))‖ ≤ C := by
    intro t htm
    have heq : seg x (x + (a, a)) t = x + (t * a, t * a) := by
      ext <;> simp [seg] <;> ring
    rw [← heq]
    exact segment_bound hH ht (Or.inr (Or.inr (by simp))) hx hy htm
  have hx₁ := abs_le.mp ((abs_fst_le (f x)).trans hx)
  have hx₂ := abs_le.mp ((abs_snd_le (f x)).trans hx)
  constructor
  · have hp : Continuous (fun t : ℝ => x + (t * a, 0)) := by fun_prop
    have he := bound_of_no_exit hf hp (R := R) (by simpa using hxs) ?_
    · simpa using he
    intro t htm hex
    let p : Plane := x + (t * a, 0)
    let q : Plane := x + (t * a, t * a)
    have hq := hdiag t htm
    have hpr : ‖f p‖ ≤ R := le_of_eq hex
    have hh := abs_le.mp ((hd x p hxs hpr).1 (by simp [p]))
    have hv := abs_le.mp ((hd q p (hq.trans hR) hpr).2.1 (by simp [q, p]))
    have hq₁ := abs_le.mp ((abs_fst_le (f q)).trans hq)
    have hle : ‖f p‖ ≤ C + B + 2 :=
      norm_le (abs_le.mpr ⟨by linarith, by linarith⟩)
        (abs_le.mpr ⟨by linarith, by linarith⟩)
    change ‖f p‖ = R at hex
    dsimp [R] at hex
    linarith
  · have hp : Continuous (fun t : ℝ => x + (0, t * a)) := by fun_prop
    have he := bound_of_no_exit hf hp (R := R) (by simpa using hxs) ?_
    · simpa using he
    intro t htm hex
    let p : Plane := x + (0, t * a)
    let q : Plane := x + (t * a, t * a)
    have hq := hdiag t htm
    have hpr : ‖f p‖ ≤ R := le_of_eq hex
    have hv := abs_le.mp ((hd x p hxs hpr).2.1 (by simp [p]))
    have hh := abs_le.mp ((hd q p (hq.trans hR) hpr).1 (by simp [q, p]))
    have hq₂ := abs_le.mp ((abs_snd_le (f q)).trans hq)
    have hle : ‖f p‖ ≤ C + B + 2 :=
      norm_le (abs_le.mpr ⟨by linarith, by linarith⟩)
        (abs_le.mpr ⟨by linarith, by linarith⟩)
    change ‖f p‖ = R at hex
    dsimp [R] at hex
    linarith

section Bootstrap

variable {F : ℕ → Plane → Plane} {H : ℝ}
variable (hH : 0 ≤ H) (hf : ∀ n, Continuous (F n))
variable (ht : ∀ n, Turning (F n) H) (hd : VanishingDefect F)
include hH hf ht hd

lemma bounded_diagonal_horizontal (x : Plane) (a : ℝ)
    (hx : EventuallyBounded F x) (hy : EventuallyBounded F (x + (a, 0))) :
    EventuallyBounded F (x + (a, a)) := by
  obtain ⟨B, hB, hb⟩ := hx
  obtain ⟨C, hC, hc⟩ := hy
  let D := B + C
  have hD : 0 ≤ D := add_nonneg hB hC
  let R := (1 + 2 * H) * D + 2 * D + 3
  have hR : 0 < R := by dsimp [R]; positivity
  refine ⟨R, hR.le, ?_⟩
  filter_upwards [hb, hc, hd R hR 1 (by norm_num)] with n hn hm he
  exact diagonal_bound_horizontal (hf n) hH hD (ht n) he x a
    (hn.trans (by dsimp [D]; linarith)) (hm.trans (by dsimp [D]; linarith))

lemma bounded_diagonal_vertical (x : Plane) (a : ℝ)
    (hx : EventuallyBounded F x) (hy : EventuallyBounded F (x + (0, a))) :
    EventuallyBounded F (x + (a, a)) := by
  obtain ⟨B, hB, hb⟩ := hx
  obtain ⟨C, hC, hc⟩ := hy
  let D := B + C
  have hD : 0 ≤ D := add_nonneg hB hC
  let R := (1 + 2 * H) * D + 2 * D + 3
  have hR : 0 < R := by dsimp [R]; positivity
  refine ⟨R, hR.le, ?_⟩
  filter_upwards [hb, hc, hd R hR 1 (by norm_num)] with n hn hm he
  exact diagonal_bound_vertical (hf n) hH hD (ht n) he x a
    (hn.trans (by dsimp [D]; linarith)) (hm.trans (by dsimp [D]; linarith))

lemma bounded_axes_diagonal (x : Plane) (a : ℝ)
    (hx : EventuallyBounded F x) (hy : EventuallyBounded F (x + (a, a))) :
    EventuallyBounded F (x + (a, 0)) ∧ EventuallyBounded F (x + (0, a)) := by
  obtain ⟨B, hB, hb⟩ := hx
  obtain ⟨C, hC, hc⟩ := hy
  let D := B + C
  have hD : 0 ≤ D := add_nonneg hB hC
  let R := (1 + 2 * H) * D + D + 3
  have hR : 0 < R := by dsimp [R]; positivity
  have he : ∀ᶠ n in atTop,
      ‖F n (x + (a, 0))‖ ≤ R ∧ ‖F n (x + (0, a))‖ ≤ R := by
    filter_upwards [hb, hc, hd R hR 1 (by norm_num)] with n hn hm he
    exact axis_bound_diagonal (hf n) hH hD (ht n) he x a
      (hn.trans (by dsimp [D]; linarith)) (hm.trans (by dsimp [D]; linarith))
  exact ⟨⟨R, hR.le, he.mono fun _ h => h.1⟩, ⟨R, hR.le, he.mono fun _ h => h.2⟩⟩

/-- Triangle completion allows arbitrary signed edge lengths. -/
theorem complete_horizontal (x : Plane) (a : ℝ)
    (hx : EventuallyBounded F x) (hy : EventuallyBounded F (x + (a, 0))) :
    EventuallyBounded F (x + (a, a)) ∧ EventuallyBounded F (x + (0, a)) := by
  have hz := bounded_diagonal_horizontal hH hf ht hd x a hx hy
  exact ⟨hz, (bounded_axes_diagonal hH hf ht hd x a hx hz).2⟩

theorem complete_vertical (x : Plane) (a : ℝ)
    (hx : EventuallyBounded F x) (hy : EventuallyBounded F (x + (0, a))) :
    EventuallyBounded F (x + (a, a)) ∧ EventuallyBounded F (x + (a, 0)) := by
  have hz := bounded_diagonal_vertical hH hf ht hd x a hx hy
  exact ⟨hz, (bounded_axes_diagonal hH hf ht hd x a hx hz).1⟩

lemma bounded_axis_double (h₀ : EventuallyBounded F (0, 0)) (r : ℝ)
    (hr : EventuallyBounded F (r, 0)) : EventuallyBounded F (2 * r, 0) := by
  have ha := (complete_horizontal hH hf ht hd (0, 0) r h₀ (by simpa using hr)).1
  have hb : EventuallyBounded F (r, r) := by simpa using ha
  have hc := (complete_vertical hH hf ht hd (r, 0) r hr (by simpa using hb)).2
  convert hc using 1
  ext <;> simp
  ring

lemma bounded_axis_neg (h₀ : EventuallyBounded F (0, 0)) (r : ℝ)
    (hr : EventuallyBounded F (r, 0)) : EventuallyBounded F (-r, 0) := by
  have ha := (complete_horizontal hH hf ht hd (r, 0) (-r) hr (by simpa using h₀)).1
  have hb : EventuallyBounded F (0, -r) := by simpa using ha
  have hc := (complete_vertical hH hf ht hd (0, 0) (-r) h₀ (by simpa using hb)).2
  simpa using hc

end Bootstrap

lemma horizontal_param {a b u c : ℝ} (hab : a < b) (hu : u ∈ Icc a b) :
    ∃ t ∈ Icc (0 : ℝ) 1, seg (a, c) (b, c) t = (u, c) := by
  refine ⟨(u - a) / (b - a), ⟨div_nonneg (by linarith [hu.1]) (by linarith),
    (div_le_one (by linarith : 0 < b - a)).mpr (by linarith [hu.2])⟩, ?_⟩
  apply Prod.ext
  · change (1 - (u - a) / (b - a)) * a + ((u - a) / (b - a)) * b = u
    field_simp [ne_of_gt (sub_pos.mpr hab)]
    ring
  · change (1 - (u - a) / (b - a)) * c + ((u - a) / (b - a)) * c = c
    ring

lemma vertical_param {a b u c : ℝ} (hab : a < b) (hu : u ∈ Icc a b) :
    ∃ t ∈ Icc (0 : ℝ) 1, seg (c, a) (c, b) t = (c, u) := by
  refine ⟨(u - a) / (b - a), ⟨div_nonneg (by linarith [hu.1]) (by linarith),
    (div_le_one (by linarith : 0 < b - a)).mpr (by linarith [hu.2])⟩, ?_⟩
  apply Prod.ext
  · change (1 - (u - a) / (b - a)) * c + ((u - a) / (b - a)) * c = c
    ring
  · change (1 - (u - a) / (b - a)) * a + ((u - a) / (b - a)) * b = u
    field_simp [ne_of_gt (sub_pos.mpr hab)]
    ring

lemma rectangle_bound {f : Plane → Plane} {H B a b c d : ℝ}
    (hH : 0 ≤ H) (ht : Turning f H) (hab : a < b) (hcd : c < d)
    (hac : ‖f (a, c)‖ ≤ B) (hbc : ‖f (b, c)‖ ≤ B)
    (had : ‖f (a, d)‖ ≤ B) (hbd : ‖f (b, d)‖ ≤ B)
    {p : Plane} (hp : p.1 ∈ Icc a b ∧ p.2 ∈ Icc c d) :
    ‖f p‖ ≤ (1 + 2 * H) * ((1 + 2 * H) * B) := by
  obtain ⟨s, hsm, hs⟩ := horizontal_param (c := c) hab hp.1
  obtain ⟨t, htm, ht'⟩ := horizontal_param (c := d) hab hp.1
  obtain ⟨u, hum, hu⟩ := vertical_param (c := p.1) hcd hp.2
  have hb : ‖f (p.1, c)‖ ≤ (1 + 2 * H) * B := by
    rw [← hs]
    exact segment_bound hH ht (x := (a, c)) (y := (b, c)) (Or.inl rfl) hac hbc hsm
  have hd : ‖f (p.1, d)‖ ≤ (1 + 2 * H) * B := by
    rw [← ht']
    exact segment_bound hH ht (x := (a, d)) (y := (b, d)) (Or.inl rfl) had hbd htm
  have he := segment_bound hH ht (x := (p.1, c)) (y := (p.1, d))
    (Or.inr (Or.inl rfl)) hb hd hum
  simpa only [hu, Prod.mk.eta] using he

section GlobalBounds

variable {F : ℕ → Plane → Plane} {H : ℝ}
variable (hH : 0 ≤ H) (hf : ∀ n, Continuous (F n))
variable (ht : ∀ n, Turning (F n) H) (hd : VanishingDefect F)
variable (h₀ : EventuallyBounded F (0, 0)) (h₁ : EventuallyBounded F (1, 0))
include hH hf ht hd h₀ h₁

lemma bounded_axis_nat : ∀ k : ℕ, EventuallyBounded F ((k : ℝ) + 1, 0) := by
  intro k
  induction k with
  | zero => simpa using h₁
  | succ k ih =>
    have hh := bounded_axis_double hH hf ht hd h₀ ((k : ℝ) + 1) ih
    have hk : (0 : ℝ) < 2 * ((k : ℝ) + 1) := by positivity
    obtain ⟨t, htm, he⟩ := horizontal_param (c := (0 : ℝ)) hk
      (show (k : ℝ) + 2 ∈ Icc 0 (2 * ((k : ℝ) + 1)) from
        ⟨by positivity, by have := Nat.cast_nonneg (α := ℝ) k; linarith⟩)
    have hb := EventuallyBounded.segment hH ht h₀ hh (Or.inl rfl) htm
    rw [he] at hb
    convert hb using 1
    ext <;> simp
    ring

theorem bounded_axis (r : ℝ) : EventuallyBounded F (r, 0) := by
  obtain ⟨k, hk⟩ := exists_nat_gt |r|
  let b : ℝ := (k : ℝ) + 1
  have hb : 0 < b := by dsimp [b]; positivity
  have hp := bounded_axis_nat hH hf ht hd h₀ h₁ k
  have hn := bounded_axis_neg hH hf ht hd h₀ b hp
  obtain ⟨t, htm, he⟩ := horizontal_param (c := (0 : ℝ)) (by linarith : -b < b)
    (show r ∈ Icc (-b) b from ⟨by dsimp [b]; linarith [neg_abs_le r],
      by dsimp [b]; linarith [le_abs_self r]⟩)
  have hh := EventuallyBounded.segment hH ht hn hp (Or.inl rfl) htm
  rwa [he] at hh

/-- The four-corner argument derives local image bounds; these are not hypotheses. -/
theorem eventually_bounded_on_ball (M : ℝ) :
    ∃ B : ℝ, 0 ≤ B ∧ ∀ᶠ n in atTop, ∀ p : Plane, ‖p‖ ≤ M → ‖F n p‖ ≤ B := by
  let r := |M| + 1
  have hr : 0 < r := by dsimp [r]; positivity
  have hm := bounded_axis hH hf ht hd h₀ h₁ (-r)
  have hp := bounded_axis hH hf ht hd h₀ h₁ r
  have htop := complete_horizontal hH hf ht hd (-r, 0) (2 * r) hm (by
    convert hp using 1
    ext <;> simp
    ring)
  have hbottom := complete_horizontal hH hf ht hd (r, 0) (-2 * r) hp (by
    convert hm using 1
    ext <;> simp
    ring)
  have hac : EventuallyBounded F (-r, -2 * r) := by
    convert hbottom.1 using 1
    ext <;> simp
    ring
  have hbc : EventuallyBounded F (r, -2 * r) := by
    simpa using hbottom.2
  have had : EventuallyBounded F (-r, 2 * r) := by simpa using htop.2
  have hbd : EventuallyBounded F (r, 2 * r) := by
    convert htop.1 using 1
    ext <;> simp
    ring
  obtain ⟨A, hA, ha⟩ := hac
  obtain ⟨B, hB, hb⟩ := hbc
  obtain ⟨C, hC, hc⟩ := had
  obtain ⟨D, hD, he⟩ := hbd
  let S := A + B + C + D
  refine ⟨(1 + 2 * H) * ((1 + 2 * H) * S), by dsimp [S]; positivity, ?_⟩
  filter_upwards [ha, hb, hc, he] with n han hbn hcn hdn p hpm
  have hp₁ := abs_le.mp ((abs_fst_le p).trans hpm)
  have hp₂ := abs_le.mp ((abs_snd_le p).trans hpm)
  apply rectangle_bound hH (ht n) (by linarith : -r < r)
    (by linarith : -2 * r < 2 * r)
    (han.trans (by dsimp [S]; linarith)) (hbn.trans (by dsimp [S]; linarith))
    (hcn.trans (by dsimp [S]; linarith)) (hdn.trans (by dsimp [S]; linarith))
  dsimp [r]
  exact ⟨⟨by linarith [le_abs_self M], by linarith [le_abs_self M]⟩,
    ⟨by linarith [le_abs_self M], by linarith [le_abs_self M]⟩⟩

theorem eventually_bounded_all (p : Plane) : EventuallyBounded F p := by
  obtain ⟨B, hB, hb⟩ := eventually_bounded_on_ball hH hf ht hd h₀ h₁ ‖p‖
  exact ⟨B, hB, hb.mono fun _ h => h p le_rfl⟩

end GlobalBounds

def PreservesDirections (f : Plane → Plane) : Prop :=
  ∀ x y,
    (x.2 = y.2 → (f x).2 = (f y).2) ∧
    (x.1 = y.1 → (f x).1 = (f y).1) ∧
    (x.1 - x.2 = y.1 - y.2 → (f x).1 - (f x).2 = (f y).1 - (f y).2)

lemma tendsto_zero_of_abs {u : ℕ → ℝ}
    (hu : ∀ ε > 0, ∀ᶠ n in atTop, |u n| ≤ ε) :
    Tendsto u atTop (𝓝 0) := by
  apply Metric.tendsto_nhds.mpr
  intro ε hε
  filter_upwards [hu (ε / 2) (by positivity)] with n hn
  simpa only [Real.dist_eq, sub_zero] using hn.trans_lt (half_lt_self hε)

lemma fixed_defects {F : ℕ → Plane → Plane} (hd : VanishingDefect F)
    {x y : Plane} (hx : EventuallyBounded F x) (hy : EventuallyBounded F y) :
    (x.2 = y.2 → Tendsto (fun n => (F n y).2 - (F n x).2) atTop (𝓝 0)) ∧
    (x.1 = y.1 → Tendsto (fun n => (F n y).1 - (F n x).1) atTop (𝓝 0)) ∧
    (x.1 - x.2 = y.1 - y.2 → Tendsto
      (fun n => ((F n y).1 - (F n y).2) - ((F n x).1 - (F n x).2)) atTop (𝓝 0)) := by
  obtain ⟨B, hB, hb⟩ := hx
  obtain ⟨C, hC, hc⟩ := hy
  let R := B + C + 1
  have hR : 0 < R := by dsimp [R]; positivity
  have he : ∀ ε > 0, ∀ᶠ n in atTop,
      (x.2 = y.2 → |(F n y).2 - (F n x).2| ≤ ε) ∧
      (x.1 = y.1 → |(F n y).1 - (F n x).1| ≤ ε) ∧
      (x.1 - x.2 = y.1 - y.2 →
        |((F n y).1 - (F n y).2) - ((F n x).1 - (F n x).2)| ≤ ε) := by
    intro ε hε
    filter_upwards [hb, hc, hd R hR ε hε] with n hn hm h
    exact h x y (hn.trans (by dsimp [R]; linarith)) (hm.trans (by dsimp [R]; linarith))
  refine ⟨?_, ?_, ?_⟩
  · intro hxy
    exact tendsto_zero_of_abs fun ε hε => (he ε hε).mono fun _ h => h.1 hxy
  · intro hxy
    exact tendsto_zero_of_abs fun ε hε => (he ε hε).mono fun _ h => h.2.1 hxy
  · intro hxy
    exact tendsto_zero_of_abs fun ε hε => (he ε hε).mono fun _ h => h.2.2 hxy

lemma limit_preserves_directions {F : ℕ → Plane → Plane} {f : Plane → Plane}
    (hd : VanishingDefect F) (hb : ∀ x, EventuallyBounded F x)
    {l : Filter ℕ} [l.NeBot] (hl : l ≤ atTop)
    (hp : ∀ x, Tendsto (fun n => F n x) l (𝓝 (f x))) :
    PreservesDirections f := by
  intro x y
  have hh := fixed_defects hd (hb x) (hb y)
  refine ⟨?_, ?_, ?_⟩
  · intro hxy
    have he := tendsto_nhds_unique ((hp y).snd_nhds.sub (hp x).snd_nhds)
      ((hh.1 hxy).mono_left hl)
    linarith
  · intro hxy
    have he := tendsto_nhds_unique ((hp y).fst_nhds.sub (hp x).fst_nhds)
      ((hh.2.1 hxy).mono_left hl)
    linarith
  · intro hxy
    have he := tendsto_nhds_unique
      (((hp y).fst_nhds.sub (hp y).snd_nhds).sub ((hp x).fst_nhds.sub (hp x).snd_nhds))
      ((hh.2.2 hxy).mono_left hl)
    linarith

lemma limit_turning {F : ℕ → Plane → Plane} {f : Plane → Plane} {H : ℝ}
    (ht : ∀ n, Turning (F n) H) {l : Filter ℕ} [l.NeBot]
    (hp : ∀ x, Tendsto (fun n => F n x) l (𝓝 (f x))) :
    Turning f H := by
  intro x y hxy t htm
  have he : Tendsto (fun n => ‖F n (seg x y t) - F n x‖ - H * ‖F n y - F n x‖)
      l (𝓝 (‖f (seg x y t) - f x‖ - H * ‖f y - f x‖)) :=
    ((hp _).sub (hp _)).norm.sub (tendsto_const_nhds.mul (((hp _).sub (hp _)).norm))
  have hh := le_of_tendsto he (Eventually.of_forall fun n => sub_nonpos.mpr (ht n x y hxy t htm))
  linarith

/-- Exact three-direction incidence plus bounded turning forces scalar rigidity. -/
theorem exact_rigidity {f : Plane → Plane} {H σ : ℝ}
    (ht : Turning f H) (hd : PreservesDirections f)
    (h₀ : f (0, 0) = (0, 0)) (h₁ : f (1, 0) = (σ, 0)) :
    f = fun p => σ • p := by
  let g : ℝ → ℝ := fun t => (f (t, 0)).1
  have hg₀ : g 0 = 0 := by simp [g, h₀]
  have hg₁ : g 1 = σ := by simp [g, h₁]
  have hgdiag : ∀ t, (f (0, t)).2 = g t := by
    intro t
    have hv := (hd (t, t) (t, 0)).2.1 rfl
    have hh := (hd (t, t) (0, t)).1 rfl
    have he := (hd (0, 0) (t, t)).2.2 (by simp)
    rw [h₀] at he
    dsimp [g]
    dsimp at he
    linarith
  have hform : ∀ x y, f (x, y) = (g x, g y) := by
    intro x y
    apply Prod.ext
    · exact (hd (x, y) (x, 0)).2.1 rfl
    · exact ((hd (x, y) (0, y)).1 rfl).trans (hgdiag y)
  have hgadd : ∀ x y, g (x + y) = g x + g y := by
    intro x y
    have he := (hd (x, 0) (x + y, y)).2.2 (by simp)
    rw [hform, hform, hg₀] at he
    dsimp at he
    linarith
  let A : ℝ →+ ℝ := { toFun := g, map_zero' := hg₀, map_add' := hgadd }
  have hpos : ∀ t ∈ Icc (0 : ℝ) 1, |g t| ≤ H * |σ| := by
    intro t htm
    have he := ht (0, 0) (1, 0) (Or.inl rfl) t htm
    have heq : seg (0, 0) (1, 0) t = (t, 0) := by ext <;> simp [seg]
    rw [heq, h₀, h₁] at he
    change |(f (t, 0)).1| ≤ H * |σ|
    apply (abs_fst_le (f (t, 0))).trans
    simpa [Prod.norm_def, Real.norm_eq_abs] using he
  have hbound : ∀ t ∈ Metric.ball (0 : ℝ) 1, |A t| ≤ H * |σ| := by
    intro t ht
    have ht' : |t| < 1 := by simpa [Real.dist_eq] using ht
    by_cases h : 0 ≤ t
    · exact hpos t ⟨h, (le_abs_self t).trans ht'.le⟩
    · have he := hpos (-t) ⟨by linarith, by linarith [neg_abs_le t]⟩
      change |A (-t)| ≤ H * |σ| at he
      simpa only [map_neg, abs_neg] using he
  have hbounded : Bornology.IsBounded (A '' Metric.ball (0 : ℝ) 1) := by
    apply (Metric.isBounded_iff_subset_ball 0).mpr
    refine ⟨H * |σ| + 1, ?_⟩
    rintro z ⟨t, htm, rfl⟩
    simpa only [Metric.mem_ball, Real.dist_eq, sub_zero] using
      (hbound t htm).trans_lt (by linarith : H * |σ| < H * |σ| + 1)
  have hcont : Continuous A :=
    A.continuous_of_isBounded_nhds_zero (Metric.ball_mem_nhds _ zero_lt_one) hbounded
  let L : ℝ →L[ℝ] ℝ := A.toRealLinearMap hcont
  have hlinear : ∀ t, g t = σ * t := by
    intro t
    have he := L.map_smul t (1 : ℝ)
    change g (t * 1) = t * g 1 at he
    simpa only [mul_one, hg₁, mul_comm] using he
  funext p
  rcases p with ⟨x, y⟩
  rw [hform]
  ext <;> simp [hlinear]

lemma EventuallyBounded.global_bound {F : ℕ → Plane → Plane} {p : Plane}
    (hb : EventuallyBounded F p) : ∃ C : ℝ, ∀ n, ‖F n p‖ ≤ C := by
  obtain ⟨B, hB, hb⟩ := hb
  obtain ⟨N, hN⟩ := eventually_atTop.mp hb
  refine ⟨B + ∑ i ∈ Finset.range N, ‖F i p‖, ?_⟩
  intro n
  by_cases hn : n < N
  · have hs : ‖F n p‖ ≤ ∑ i ∈ Finset.range N, ‖F i p‖ :=
      Finset.single_le_sum (fun i _ => norm_nonneg (F i p)) (Finset.mem_range.mpr hn)
    linarith
  · have hs : 0 ≤ ∑ i ∈ Finset.range N, ‖F i p‖ := Finset.sum_nonneg fun _ _ => norm_nonneg _
    have := hN n (by omega)
    linarith

lemma eventuallyBounded_of_tendsto {F : ℕ → Plane → Plane} {p v : Plane}
    (hp : Tendsto (fun n => F n p) atTop (𝓝 v)) : EventuallyBounded F p := by
  have he := (Metric.tendsto_nhds.mp hp) 1 zero_lt_one
  refine ⟨‖v‖ + 1, by positivity, ?_⟩
  filter_upwards [he] with n hn
  have hh := norm_add_le (F n p - v) v
  rw [sub_add_cancel] at hh
  rw [dist_eq_norm] at hn
  linarith

/-- Pointwise convergence is obtained from Tychonoff compactness, not assumed. -/
theorem pointwise_convergence {F : ℕ → Plane → Plane} {H σ : ℝ}
    (hH : 0 ≤ H) (hf : ∀ n, Continuous (F n)) (ht : ∀ n, Turning (F n) H)
    (hd : VanishingDefect F) (h₀ : ∀ n, F n (0, 0) = (0, 0))
    (h₁ : Tendsto (fun n => F n (1, 0)) atTop (𝓝 (σ, 0))) :
    ∀ p, Tendsto (fun n => F n p) atTop (𝓝 (σ • p)) := by
  have hz : EventuallyBounded F (0, 0) :=
    ⟨0, le_rfl, Eventually.of_forall fun n => by simp [h₀ n]⟩
  have he : EventuallyBounded F (1, 0) := eventuallyBounded_of_tendsto h₁
  have hb := eventually_bounded_all hH hf ht hd hz he
  choose C hC using fun p => (hb p).global_bound
  have hK : IsCompact {f : Plane → Plane | ∀ p, ‖f p‖ ≤ C p} := by
    simpa only [Metric.mem_closedBall, dist_zero_right] using
      (isCompact_pi_infinite fun p => isCompact_closedBall (0 : Plane) (C p))
  have hconv : Tendsto F atTop (𝓝 (fun p : Plane => σ • p)) := by
    apply hK.tendsto_nhds_of_unique_mapClusterPt
      (Eventually.of_forall fun n p => hC p n)
    intro f _ hcluster
    let l : Filter ℕ := comap F (𝓝 f) ⊓ atTop
    haveI : l.NeBot := neBot_inf_comap_iff_map'.mpr hcluster
    have hl : l ≤ atTop := inf_le_right
    have hpt : ∀ p, Tendsto (fun n => F n p) l (𝓝 (f p)) :=
      tendsto_pi_nhds.mp (tendsto_comap.mono_left inf_le_left)
    have hf₀ : f (0, 0) = (0, 0) := by
      apply tendsto_nhds_unique (hpt (0, 0))
      simpa only [h₀] using
        (tendsto_const_nhds : Tendsto (fun _ : ℕ => ((0, 0) : Plane)) l (𝓝 (0, 0)))
    have hf₁ : f (1, 0) = (σ, 0) :=
      tendsto_nhds_unique (hpt (1, 0)) (h₁.mono_left hl)
    exact exact_rigidity (limit_turning ht hpt) (limit_preserves_directions hd hb hl hpt) hf₀ hf₁
  exact tendsto_pi_nhds.mp hconv

lemma Turning.sub_const {f : Plane → Plane} {H : ℝ} (ht : Turning f H) (c : Plane) :
    Turning (fun p => f p - c) H := by
  intro x y hxy t htm
  simpa only [sub_sub_sub_cancel_right] using ht x y hxy t htm

/-- Two interpolations on an arbitrarily small rectangle upgrade the derived
pointwise convergence to locally uniform convergence. -/
theorem locallyUniform_of_pointwise {F : ℕ → Plane → Plane} {H σ : ℝ}
    (hH : 0 ≤ H) (ht : ∀ n, Turning (F n) H)
    (hp : ∀ p, Tendsto (fun n => F n p) atTop (𝓝 (σ • p))) :
    TendstoLocallyUniformly F (fun p => σ • p) atTop := by
  apply Metric.tendstoLocallyUniformly_iff.mpr
  intro ε hε p
  let A := 1 + 2 * H
  let C := A * (A * (|σ| + 1)) + |σ| + 1
  have hA : 0 < A := by dsimp [A]; linarith
  have hC : 0 < C := by dsimp [C]; positivity
  let δ := ε / (2 * C)
  have hδ : 0 < δ := by dsimp [δ]; positivity
  have hδeq : C * δ = ε / 2 := by
    dsimp [δ]
    field_simp
  have corner : ∀ q : Plane, ‖q - p‖ ≤ δ →
      ∀ᶠ n in atTop, ‖F n q - σ • p‖ ≤ (|σ| + 1) * δ := by
    intro q hq
    filter_upwards [(Metric.tendsto_nhds.mp (hp q)) δ hδ] with n hn
    rw [dist_eq_norm] at hn
    have heq : F n q - σ • p = (F n q - σ • q) + σ • (q - p) := by
      module
    rw [heq]
    calc
      ‖(F n q - σ • q) + σ • (q - p)‖
          ≤ ‖F n q - σ • q‖ + ‖σ • (q - p)‖ := norm_add_le _ _
      _ ≤ δ + |σ| * δ := by
        rw [norm_smul, Real.norm_eq_abs]
        nlinarith [mul_le_mul_of_nonneg_left hq (abs_nonneg σ)]
      _ = (|σ| + 1) * δ := by ring
  have hac := corner (p.1 - δ, p.2 - δ) (by
    apply norm_le <;> simp [abs_of_pos hδ])
  have hbc := corner (p.1 + δ, p.2 - δ) (by
    apply norm_le <;> simp [abs_of_pos hδ])
  have had := corner (p.1 - δ, p.2 + δ) (by
    apply norm_le <;> simp [abs_of_pos hδ])
  have hbd := corner (p.1 + δ, p.2 + δ) (by
    apply norm_le <;> simp [abs_of_pos hδ])
  refine ⟨Metric.ball p δ, Metric.ball_mem_nhds p hδ, ?_⟩
  filter_upwards [hac, hbc, had, hbd] with n han hbn hcn hdn y hy
  have hynorm : ‖y - p‖ ≤ δ := le_of_lt (by simpa only [Metric.mem_ball, dist_eq_norm] using hy)
  have hy₁ := abs_le.mp ((abs_fst_le (y - p)).trans hynorm)
  have hy₂ := abs_le.mp ((abs_snd_le (y - p)).trans hynorm)
  have hrect : ‖F n y - σ • p‖ ≤ A * (A * ((|σ| + 1) * δ)) := by
    apply rectangle_bound hH ((ht n).sub_const (σ • p))
      (by linarith : p.1 - δ < p.1 + δ) (by linarith : p.2 - δ < p.2 + δ)
      han hbn hcn hdn
    dsimp at hy₁ hy₂
    exact ⟨⟨by linarith, by linarith⟩, ⟨by linarith, by linarith⟩⟩
  have hother : dist (σ • y) (σ • p) ≤ |σ| * δ := by
    rw [dist_eq_norm, ← smul_sub, norm_smul, Real.norm_eq_abs]
    exact mul_le_mul_of_nonneg_left hynorm (abs_nonneg σ)
  have htotal : A * (A * ((|σ| + 1) * δ)) + |σ| * δ ≤ C * δ := by
    dsimp [C]
    nlinarith
  have hh := dist_triangle (σ • y) (σ • p) (F n y)
  have hr : dist (σ • p) (F n y) ≤ A * (A * ((|σ| + 1) * δ)) := by
    simpa only [dist_eq_norm, norm_sub_rev] using hrect
  have he : dist (σ • y) (F n y) ≤ ε / 2 := by
    rw [← hδeq]
    linarith
  exact he.trans_lt (half_lt_self hε)

/-- Anchored full convergence. No local boundedness, equicontinuity, injectivity,
or finite-stage line preservation is assumed. The scalar can even be zero. -/
theorem anchored_convergence {F : ℕ → Plane → Plane} {H σ : ℝ}
    (hH : 0 ≤ H) (hf : ∀ n, Continuous (F n)) (ht : ∀ n, Turning (F n) H)
    (hd : VanishingDefect F) (h₀ : ∀ n, F n (0, 0) = (0, 0))
    (h₁ : Tendsto (fun n => F n (1, 0)) atTop (𝓝 (σ, 0))) :
    TendstoLocallyUniformly F (fun p => σ • p) atTop :=
  locallyUniform_of_pointwise hH ht (pointwise_convergence hH hf ht hd h₀ h₁)

lemma VanishingDefect.subsequence {F : ℕ → Plane → Plane} (hd : VanishingDefect F)
    {s : ℕ → ℕ} (hs : StrictMono s) : VanishingDefect (fun n => F (s n)) := by
  intro R hR ε hε
  exact hs.tendsto_atTop.eventually (hd R hR ε hε)

/-- Every subsequence has a locally uniformly convergent further subsequence;
normalization leaves exactly the two scalars `-1` and `1`. -/
theorem sequential_compactness {F : ℕ → Plane → Plane} {H : ℝ}
    (hH : 0 ≤ H) (hf : ∀ n, Continuous (F n)) (ht : ∀ n, Turning (F n) H)
    (hd : VanishingDefect F) (h₀ : ∀ n, F n (0, 0) = (0, 0))
    (h₁ : ∀ n, ‖F n (1, 0)‖ = 1) (s : ℕ → ℕ) (hs : StrictMono s) :
    ∃ r : ℕ → ℕ, StrictMono r ∧ ∃ σ : ℝ, (σ = -1 ∨ σ = 1) ∧
      TendstoLocallyUniformly (fun n => F (s (r n))) (fun p => σ • p) atTop := by
  obtain ⟨a, _, r, hr, ha⟩ :=
    (isCompact_closedBall (0 : Plane) 1).tendsto_subseq
      (fun n => show F (s n) (1, 0) ∈ Metric.closedBall (0 : Plane) 1 by
        simpa only [Metric.mem_closedBall, dist_zero_right, h₁] using (le_rfl : (1 : ℝ) ≤ 1))
  have hz : EventuallyBounded F (0, 0) :=
    ⟨0, le_rfl, Eventually.of_forall fun n => by simp [h₀ n]⟩
  have he : EventuallyBounded F (1, 0) :=
    ⟨1, zero_le_one, Eventually.of_forall fun n => (h₁ n).le⟩
  have hdir := (fixed_defects hd hz he).1 rfl
  have ha₂ : a.2 = 0 := by
    have hc : Tendsto (fun n => (F (s (r n)) (1, 0)).2) atTop (𝓝 0) := by
      have hcomp : Tendsto
          (fun n => (F (s (r n)) (1, 0)).2 - (F (s (r n)) (0, 0)).2)
          atTop (𝓝 0) := hdir.comp (hs.comp hr).tendsto_atTop
      simpa only [h₀, sub_zero] using hcomp
    exact tendsto_nhds_unique ha.snd_nhds hc
  have hanorm : ‖a‖ = 1 := by
    apply tendsto_nhds_unique ha.norm
    simpa only [Function.comp_apply, h₁] using
      (tendsto_const_nhds : Tendsto (fun _ : ℕ => (1 : ℝ)) atTop (𝓝 1))
  have habs : |a.1| = 1 := by
    simpa [Prod.norm_def, Real.norm_eq_abs, ha₂] using hanorm
  have hsign : a.1 = -1 ∨ a.1 = 1 := by
    rcases (abs_eq (by norm_num : (0 : ℝ) ≤ 1)).mp habs with h | h
    · exact Or.inr h
    · exact Or.inl h
  refine ⟨r, hr, a.1, hsign, ?_⟩
  apply anchored_convergence hH (fun n => hf (s (r n))) (fun n => ht (s (r n)))
    ((hd.subsequence hs).subsequence hr) (fun n => h₀ (s (r n)))
  have hae : a = (a.1, 0) := Prod.ext rfl ha₂
  rw [← hae]
  exact ha

def UniformDirection (F : ℕ → Plane → Plane) (c : Plane → ℝ) : Prop :=
  ∀ R > 0, ∀ ε > 0, ∀ᶠ n in atTop, ∀ x y,
    ‖F n x‖ ≤ R → ‖F n y‖ ≤ R → c x = c y → |c (F n y) - c (F n x)| ≤ ε

/-- The two source points may move with the index, with no bound on their
positions. The condition is required along every strict-monotone subsequence. -/
def MovingDirection (F : ℕ → Plane → Plane) (c : Plane → ℝ) : Prop :=
  ∀ (s : ℕ → ℕ), StrictMono s → ∀ (x y : ℕ → Plane) (a b : Plane),
    (∀ n, c (x n) = c (y n)) →
    Tendsto (fun n => F (s n) (x n)) atTop (𝓝 a) →
    Tendsto (fun n => F (s n) (y n)) atTop (𝓝 b) → c a = c b

def MovingDirections (F : ℕ → Plane → Plane) : Prop :=
  MovingDirection F Prod.snd ∧ MovingDirection F Prod.fst ∧
    MovingDirection F (fun p => p.1 - p.2)

lemma movingDirection_of_uniformDirection {F : ℕ → Plane → Plane} {c : Plane → ℝ}
    (hc : Continuous c) (hu : UniformDirection F c) : MovingDirection F c := by
  intro s hs x y a b hxy ha hb
  obtain ⟨A, hA⟩ := ha.norm.isBoundedUnder_le
  obtain ⟨B, hB⟩ := hb.norm.isBoundedUnder_le
  let R := |A| + |B| + 1
  have hR : 0 < R := by dsimp [R]; positivity
  have hzero : Tendsto
      (fun n => c (F (s n) (y n)) - c (F (s n) (x n))) atTop (𝓝 0) := by
    apply tendsto_zero_of_abs
    intro ε hε
    filter_upwards [hA, hB, hs.tendsto_atTop.eventually (hu R hR ε hε)] with n han hbn hn
    exact hn (x n) (y n)
      (han.trans (by dsimp [R]; linarith [le_abs_self A, abs_nonneg B]))
      (hbn.trans (by dsimp [R]; linarith [le_abs_self B, abs_nonneg A]))
      (hxy n)
  have he := tendsto_nhds_unique
    (((hc.tendsto b).comp hb).sub ((hc.tendsto a).comp ha)) hzero
  linarith

/-- Compactness of bounded image pairs proves the converse, without any
continuity or boundedness assumption on the maps `F n`. -/
lemma uniformDirection_of_movingDirection {F : ℕ → Plane → Plane} {c : Plane → ℝ}
    (hc : Continuous c) (hm : MovingDirection F c) : UniformDirection F c := by
  classical
  intro R hR ε hε
  by_contra he
  obtain ⟨s, hs, hbad⟩ := extraction_of_frequently_atTop (not_eventually.mp he)
  have hex : ∀ n, ∃ x y : Plane, ‖F (s n) x‖ ≤ R ∧ ‖F (s n) y‖ ≤ R ∧
      c x = c y ∧ ε < |c (F (s n) y) - c (F (s n) x)| := by
    intro n
    have hn := hbad n
    push Not at hn
    obtain ⟨x, y, hx, hy, heq, herr⟩ := hn
    exact ⟨x, y, hx, hy, heq, herr⟩
  choose x y hx hy heq herr using hex
  obtain ⟨v, _, r, hr, hv⟩ :=
    ((isCompact_closedBall (0 : Plane) R).prod (isCompact_closedBall (0 : Plane) R)).tendsto_subseq
      (fun n => show (F (s n) (x n), F (s n) (y n)) ∈
        Metric.closedBall (0 : Plane) R ×ˢ Metric.closedBall (0 : Plane) R from
        ⟨by simpa only [Metric.mem_closedBall, dist_zero_right] using hx n,
          by simpa only [Metric.mem_closedBall, dist_zero_right] using hy n⟩)
  have ha : Tendsto (fun n => F (s (r n)) (x (r n))) atTop (𝓝 v.1) := hv.fst_nhds
  have hb : Tendsto (fun n => F (s (r n)) (y (r n))) atTop (𝓝 v.2) := hv.snd_nhds
  have heqv : c v.1 = c v.2 :=
    hm (s ∘ r) (hs.comp hr) (x ∘ r) (y ∘ r) v.1 v.2 (fun n => heq (r n)) ha hb
  have hlim : Tendsto
      (fun n => |c (F (s (r n)) (y (r n))) - c (F (s (r n)) (x (r n)))|)
      atTop (𝓝 0) := by
    have hh : Tendsto
        (fun n => |c (F (s (r n)) (y (r n))) - c (F (s (r n)) (x (r n)))|)
        atTop (𝓝 |c v.2 - c v.1|) :=
      (((hc.tendsto v.2).comp hb).sub ((hc.tendsto v.1).comp ha)).abs
    simpa only [heqv, sub_self, abs_zero] using hh
  have hh : ε ≤ 0 := ge_of_tendsto hlim (Eventually.of_forall fun n => (herr (r n)).le)
  linarith

theorem movingDirection_iff_uniformDirection {F : ℕ → Plane → Plane} {c : Plane → ℝ}
    (hc : Continuous c) : MovingDirection F c ↔ UniformDirection F c :=
  ⟨uniformDirection_of_movingDirection hc, movingDirection_of_uniformDirection hc⟩

/-- Exact equivalence of the moving-limit and bounded-image formulations. -/
theorem movingDirections_iff_vanishingDefect {F : ℕ → Plane → Plane} :
    MovingDirections F ↔ VanishingDefect F := by
  constructor
  · intro hm R hR ε hε
    have hh := uniformDirection_of_movingDirection continuous_snd hm.1
    have hv := uniformDirection_of_movingDirection continuous_fst hm.2.1
    have hdc := uniformDirection_of_movingDirection
      (continuous_fst.sub continuous_snd) hm.2.2
    filter_upwards [hh R hR ε hε, hv R hR ε hε, hdc R hR ε hε] with n hn hm he
    intro x y hx hy
    exact ⟨hn x y hx hy, hm x y hx hy, he x y hx hy⟩
  · intro hd
    have hh : UniformDirection F Prod.snd := by
      intro R hR ε hε
      filter_upwards [hd R hR ε hε] with n hn x y hx hy hxy
      exact (hn x y hx hy).1 hxy
    have hv : UniformDirection F Prod.fst := by
      intro R hR ε hε
      filter_upwards [hd R hR ε hε] with n hn x y hx hy hxy
      exact (hn x y hx hy).2.1 hxy
    have hdc : UniformDirection F (fun p => p.1 - p.2) := by
      intro R hR ε hε
      filter_upwards [hd R hR ε hε] with n hn x y hx hy hxy
      exact (hn x y hx hy).2.2 hxy
    exact ⟨movingDirection_of_uniformDirection continuous_snd hh,
      movingDirection_of_uniformDirection continuous_fst hv,
      movingDirection_of_uniformDirection (continuous_fst.sub continuous_snd) hdc⟩

theorem anchored_convergence_of_moving {F : ℕ → Plane → Plane} {H σ : ℝ}
    (hH : 0 ≤ H) (hf : ∀ n, Continuous (F n)) (ht : ∀ n, Turning (F n) H)
    (hd : MovingDirections F) (h₀ : ∀ n, F n (0, 0) = (0, 0))
    (h₁ : Tendsto (fun n => F n (1, 0)) atTop (𝓝 (σ, 0))) :
    TendstoLocallyUniformly F (fun p => σ • p) atTop :=
  anchored_convergence hH hf ht (movingDirections_iff_vanishingDefect.mp hd) h₀ h₁

/-- The sequential theorem with exactly the moving-image direction hypothesis. -/
theorem sequential_compactness_of_moving {F : ℕ → Plane → Plane} {H : ℝ}
    (hH : 0 ≤ H) (hf : ∀ n, Continuous (F n)) (ht : ∀ n, Turning (F n) H)
    (hd : MovingDirections F) (h₀ : ∀ n, F n (0, 0) = (0, 0))
    (h₁ : ∀ n, ‖F n (1, 0)‖ = 1) (s : ℕ → ℕ) (hs : StrictMono s) :
    ∃ r : ℕ → ℕ, StrictMono r ∧ ∃ σ : ℝ, (σ = -1 ∨ σ = 1) ∧
      TendstoLocallyUniformly (fun n => F (s (r n))) (fun p => σ • p) atTop :=
  sequential_compactness hH hf ht (movingDirections_iff_vanishingDefect.mp hd) h₀ h₁ s hs

end ThreeDirection

open Set Filter Topology ThreeDirection

namespace RankGeometry

def det (u v : Plane) : ℝ := u.1 * v.2 - u.2 * v.1

def e1 : Plane := (1, 0)
def e2 : Plane := (0, 1)

lemma cramer (u v x : Plane) :
    det u v • x = det x v • u + det u x • v := by
  ext <;> simp [det] <;> ring

lemma linear_pair (A : Plane →L[ℝ] Plane) (x : Plane) :
    A x = x.1 • A e1 + x.2 • A e2 := by
  rw [← map_smul, ← map_smul, ← map_add]
  congr 1
  ext <;> simp [e1, e2]

def linearDet (A : Plane →L[ℝ] Plane) : ℝ := det (A e1) (A e2)

lemma det_map (A : Plane →L[ℝ] Plane) (u v : Plane) :
    det (A u) (A v) = linearDet A * det u v := by
  rw [linear_pair A u, linear_pair A v]
  simp [linearDet, det]
  ring

lemma eq_zero_of_kills_pair (A : Plane →L[ℝ] Plane) {u v : Plane}
    (huv : det u v ≠ 0) (hu : A u = 0) (hv : A v = 0) : A = 0 := by
  apply ContinuousLinearMap.ext
  intro x
  have hh := congrArg A (cramer u v x)
  simp only [map_smul, map_add, hu, hv, smul_zero, add_zero] at hh
  exact (smul_eq_zero.mp hh).resolve_left huv

lemma injective_of_det_ne_zero (A : Plane →L[ℝ] Plane)
    (hA : linearDet A ≠ 0) {x : Plane} (hx : A x = 0) : x = 0 := by
  have h₁' : det x e1 = 0 := by
    apply (mul_eq_zero.mp (show linearDet A * det x e1 = 0 from ?_)).resolve_left hA
    rw [← det_map, hx]
    simp [det]
  have h₂' : det x e2 = 0 := by
    apply (mul_eq_zero.mp (show linearDet A * det x e2 = 0 from ?_)).resolve_left hA
    rw [← det_map, hx]
    simp [det]
  ext <;> simp [det, e1, e2] at h₁' h₂' ⊢ <;> linarith

def Projective (A : Plane →L[ℝ] Plane) (u : Fin 3 → Plane) : Prop :=
  (A (u 0)).2 = 0 ∧ (A (u 1)).1 = 0 ∧
    (A (u 2)).1 = (A (u 2)).2

def Separated (δ : ℝ) (u : Fin 3 → Plane) : Prop :=
  δ ≤ |det (u 0) (u 1)| ∧ δ ≤ |det (u 0) (u 2)| ∧
    δ ≤ |det (u 1) (u 2)|

lemma zero_of_singular_projective (A : Plane →L[ℝ] Plane)
    (u : Fin 3 → Plane)
    (h01 : det (u 0) (u 1) ≠ 0)
    (h02 : det (u 0) (u 2) ≠ 0)
    (h12 : det (u 1) (u 2) ≠ 0)
    (hp : Projective A u) (hs : linearDet A = 0) : A = 0 := by
  rcases hp with ⟨hp0, hp1, hp2⟩
  have h01' := det_map A (u 0) (u 1)
  have h02' := det_map A (u 0) (u 2)
  have h12' := det_map A (u 1) (u 2)
  simp only [hs, zero_mul, det, hp0, hp1, zero_mul, mul_zero, sub_zero, zero_sub]
    at h01' h02' h12'
  by_cases ha : (A (u 0)).1 = 0
  · have hu0 : A (u 0) = 0 := by ext <;> simp [ha, hp0]
    by_cases hb : (A (u 1)).2 = 0
    · have hu1 : A (u 1) = 0 := by ext <;> simp [hb, hp1]
      exact eq_zero_of_kills_pair A h01 hu0 hu1
    · have hc : (A (u 2)).1 = 0 := by
        have hm : (A (u 1)).2 * (A (u 2)).1 = 0 := by linarith
        exact (mul_eq_zero.mp hm).resolve_left hb
      have hu2 : A (u 2) = 0 := by ext <;> simp_all
      exact eq_zero_of_kills_pair A h02 hu0 hu2
  · have hb : (A (u 1)).2 = 0 :=
      (mul_eq_zero.mp h01').resolve_left ha
    have hc : (A (u 2)).2 = 0 :=
      (mul_eq_zero.mp h02').resolve_left ha
    have hu1 : A (u 1) = 0 := by ext <;> simp [hp1, hb]
    have hu2 : A (u 2) = 0 := by ext <;> simp_all
    exact eq_zero_of_kills_pair A h12 hu1 hu2

abbrev Bundle := (Plane →L[ℝ] Plane) × ((Fin 3 → Plane) × Plane)

def Good (δ : ℝ) (q : Bundle) : Prop :=
  ‖q.1‖ = 1 ∧ (∀ i, ‖q.2.1 i‖ = 1) ∧
    Separated δ q.2.1 ∧ Projective q.1 q.2.1 ∧ ‖q.2.2‖ = 1

lemma good_closed (δ : ℝ) : IsClosed {q : Bundle | Good δ q} := by
  have hA : IsClosed {q : Bundle | ‖q.1‖ = 1} :=
    isClosed_eq (by fun_prop) continuous_const
  have hu : IsClosed {q : Bundle | ∀ i, ‖q.2.1 i‖ = 1} := by
    convert isClosed_iInter (fun i : Fin 3 =>
      (isClosed_eq (by fun_prop) continuous_const :
        IsClosed {q : Bundle | ‖q.2.1 i‖ = 1})) using 1
    ext q
    simp
  have h01 : IsClosed {q : Bundle | δ ≤ |det (q.2.1 0) (q.2.1 1)|} :=
    isClosed_le continuous_const (by unfold det; fun_prop)
  have h02 : IsClosed {q : Bundle | δ ≤ |det (q.2.1 0) (q.2.1 2)|} :=
    isClosed_le continuous_const (by unfold det; fun_prop)
  have h12 : IsClosed {q : Bundle | δ ≤ |det (q.2.1 1) (q.2.1 2)|} :=
    isClosed_le continuous_const (by unfold det; fun_prop)
  have hp0 : IsClosed {q : Bundle | (q.1 (q.2.1 0)).2 = 0} :=
    isClosed_eq (by fun_prop) continuous_const
  have hp1 : IsClosed {q : Bundle | (q.1 (q.2.1 1)).1 = 0} :=
    isClosed_eq (by fun_prop) continuous_const
  have hp2 : IsClosed {q : Bundle | (q.1 (q.2.1 2)).1 = (q.1 (q.2.1 2)).2} :=
    isClosed_eq (by fun_prop) (by fun_prop)
  have hx : IsClosed {q : Bundle | ‖q.2.2‖ = 1} :=
    isClosed_eq (by fun_prop) continuous_const
  exact hA.inter (hu.inter ((h01.inter (h02.inter h12)).inter
    ((hp0.inter (hp1.inter hp2)).inter hx)))

lemma good_compact (δ : ℝ) : IsCompact {q : Bundle | Good δ q} := by
  apply (isCompact_closedBall (0 : Bundle) 1).of_isClosed_subset (good_closed δ)
  intro q hq
  rcases hq with ⟨hA, hu, _, _, hx⟩
  rw [Metric.mem_closedBall, dist_zero_right, Prod.norm_def, Prod.norm_def]
  apply max_le hA.le
  apply max_le _ hx.le
  exact (pi_norm_le_iff_of_nonneg zero_le_one).mpr fun i => (hu i).le

lemma good_image_pos {δ : ℝ} (hδ : 0 < δ) {q : Bundle} (hq : Good δ q) :
    0 < ‖q.1 q.2.2‖ := by
  rcases hq with ⟨hA, hu, hsep, hp, hx⟩
  have h01 : det (q.2.1 0) (q.2.1 1) ≠ 0 := by
    intro h; have := hsep.1; simp [h] at this; linarith
  have h02 : det (q.2.1 0) (q.2.1 2) ≠ 0 := by
    intro h; have := hsep.2.1; simp [h] at this; linarith
  have h12 : det (q.2.1 1) (q.2.1 2) ≠ 0 := by
    intro h; have := hsep.2.2; simp [h] at this; linarith
  have hd : linearDet q.1 ≠ 0 := by
    intro hh
    have hz := zero_of_singular_projective q.1 q.2.1 h01 h02 h12 hp hh
    simp [hz] at hA
  apply norm_pos_iff.mpr
  intro hz
  have := injective_of_det_ne_zero q.1 hd hz
  simp [this] at hx

theorem normalized_triple_bounds (δ : ℝ) (hδ : 0 < δ) :
    ∃ a : ℝ, 0 < a ∧ ∀ (A : Plane →L[ℝ] Plane) (u : Fin 3 → Plane),
      ‖A‖ = 1 → (∀ i, ‖u i‖ = 1) → Separated δ u → Projective A u →
      ∀ x : Plane, a * ‖x‖ ≤ ‖A x‖ ∧ ‖A x‖ ≤ ‖x‖ := by
  classical
  by_cases hn : {q : Bundle | Good δ q}.Nonempty
  · obtain ⟨q, hq, hmin⟩ := (good_compact δ).exists_isMinOn hn
      (by fun_prop : ContinuousOn (fun q : Bundle => ‖q.1 q.2.2‖) {q | Good δ q})
    refine ⟨‖q.1 q.2.2‖, good_image_pos hδ hq, ?_⟩
    intro A u hA hu hsep hp x
    constructor
    · by_cases hx : x = 0
      · simp [hx]
      have hxp : 0 < ‖x‖ := norm_pos_iff.mpr hx
      have hv : ‖(‖x‖⁻¹ : ℝ) • x‖ = 1 := by
        rw [norm_smul, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hxp),
          inv_mul_cancel₀ hxp.ne']
      have hmem : Good δ (A, u, (‖x‖⁻¹ : ℝ) • x) :=
        ⟨hA, hu, hsep, hp, hv⟩
      have hm : ‖q.1 q.2.2‖ ≤ ‖A ((‖x‖⁻¹ : ℝ) • x)‖ := hmin hmem
      simp only [map_smul, norm_smul, Real.norm_eq_abs,
        abs_of_pos (inv_pos.mpr hxp)] at hm
      calc
        ‖q.1 q.2.2‖ * ‖x‖ ≤ (‖x‖⁻¹ * ‖A x‖) * ‖x‖ :=
          mul_le_mul_of_nonneg_right hm hxp.le
        _ = ‖A x‖ := by field_simp
    · simpa only [hA, one_mul] using A.le_opNorm x
  · refine ⟨1, zero_lt_one, ?_⟩
    intro A u hA hu hsep hp x
    exfalso
    apply hn
    exact ⟨(A, u, e1), hA, hu, hsep, hp, by simp [e1, Prod.norm_def]⟩

def CoordinateSegmentControl (f : Plane → Plane) : Prop :=
  ∀ x y, SameLine x y → ∀ t ∈ Icc (0 : ℝ) 1,
    |(f (seg x y t)).1 - (f x).1| ≤ |(f y).1 - (f x).1| ∧
      |(f (seg x y t)).2 - (f x).2| ≤ |(f y).2 - (f x).2|

theorem turning_of_coordinates (P : Plane ≃L[ℝ] Plane) {f : Plane → Plane}
    (hc : CoordinateSegmentControl (fun x => P (f x))) :
    Turning f (‖P.symm.toContinuousLinearMap‖ * ‖P.toContinuousLinearMap‖) := by
  intro x y hxy t ht
  have h := hc x y hxy t ht
  have hb : ‖P (f (seg x y t) - f x)‖ ≤ ‖P (f y - f x)‖ := by
    rw [map_sub, map_sub]
    apply ThreeDirection.norm_le
    · exact h.1.trans (abs_fst_le (P (f y) - P (f x)))
    · exact h.2.trans (abs_snd_le (P (f y) - P (f x)))
  calc
    ‖f (seg x y t) - f x‖ =
        ‖P.symm (P (f (seg x y t) - f x))‖ := by rw [P.symm_apply_apply]
    _ ≤ ‖P.symm.toContinuousLinearMap‖ * ‖P (f (seg x y t) - f x)‖ :=
      P.symm.toContinuousLinearMap.le_opNorm _
    _ ≤ ‖P.symm.toContinuousLinearMap‖ * ‖P (f y - f x)‖ :=
      mul_le_mul_of_nonneg_left hb (norm_nonneg _)
    _ ≤ ‖P.symm.toContinuousLinearMap‖ *
        (‖P.toContinuousLinearMap‖ * ‖f y - f x‖) :=
      mul_le_mul_of_nonneg_left (P.toContinuousLinearMap.le_opNorm _) (norm_nonneg _)
    _ = _ := by ring

#print axioms normalized_triple_bounds

end RankGeometry

/-!
Radial comparison from normalized rank zooms.  The plane norm inherited from
`Web` is the max norm; every radial statement below uses `eucNorm`.
-/

open Filter Set Topology ThreeDirection

namespace RankRadial

noncomputable def eucNorm (x : Plane) : ℝ :=
  Real.sqrt (x.1 ^ 2 + x.2 ^ 2)

lemma eucNorm_nonneg (x : Plane) : 0 ≤ eucNorm x := Real.sqrt_nonneg _

lemma eucNorm_sq (x : Plane) : eucNorm x ^ 2 = x.1 ^ 2 + x.2 ^ 2 := by
  exact Real.sq_sqrt (by positivity)

lemma maxNorm_le_eucNorm (x : Plane) : ‖x‖ ≤ eucNorm x := by
  apply ThreeDirection.norm_le
  · nlinarith [eucNorm_sq x, eucNorm_nonneg x, sq_nonneg x.2,
      abs_nonneg x.1, sq_abs x.1]
  · nlinarith [eucNorm_sq x, eucNorm_nonneg x, sq_nonneg x.1,
      abs_nonneg x.2, sq_abs x.2]

lemma eucNorm_le_two_maxNorm (x : Plane) : eucNorm x ≤ 2 * ‖x‖ := by
  have h₁ := abs_fst_le x
  have h₂ := abs_snd_le x
  have hs₁ : x.1 ^ 2 ≤ ‖x‖ ^ 2 := by
    nlinarith [abs_nonneg x.1, norm_nonneg x, sq_abs x.1]
  have hs₂ : x.2 ^ 2 ≤ ‖x‖ ^ 2 := by
    nlinarith [abs_nonneg x.2, norm_nonneg x, sq_abs x.2]
  nlinarith [eucNorm_sq x, eucNorm_nonneg x, norm_nonneg x, sq_nonneg ‖x‖]

lemma eucNorm_smul (t : ℝ) (x : Plane) :
    eucNorm (t • x) = |t| * eucNorm x := by
  have he := eucNorm_sq (t • x)
  simp only [Prod.smul_fst, Prod.smul_snd, smul_eq_mul] at he
  have hs : (|t| * eucNorm x) ^ 2 = t ^ 2 * (x.1 ^ 2 + x.2 ^ 2) := by
    rw [mul_pow, sq_abs, eucNorm_sq]
  have hn : 0 ≤ |t| * eucNorm x := mul_nonneg (abs_nonneg _) (eucNorm_nonneg _)
  nlinarith [eucNorm_nonneg (t • x)]

def DirectedLE (s : Bool) (x y : ℝ) : Prop :=
  if s then x ≤ y else y ≤ x

/-- The two signs are arbitrary and need not agree for different coordinates. -/
def SignedMonotoneOn (g : Plane → ℝ) (R : ℝ) : Prop :=
  ∃ sx sy : Bool, ∀ x y : Plane, ‖x‖ ≤ R → ‖y‖ ≤ R →
    DirectedLE sx x.1 y.1 → DirectedLE sy x.2 y.2 → g x ≤ g y

def RankOrderOn (g : Plane → Plane) (R : ℝ) : Prop :=
  SignedMonotoneOn (fun w => (g w).1) R ∧
  SignedMonotoneOn (fun w => (g w).2) R

def corner (p : Plane) (d : ℝ) (i j : Bool) : Plane :=
  (p.1 + (if i then d else -d), p.2 + (if j then d else -d))

lemma corner_dist (p : Plane) {d : ℝ} (hd : 0 ≤ d) (i j : Bool) :
    ‖corner p d i j - p‖ ≤ d := by
  apply ThreeDirection.norm_le <;>
    cases i <;> cases j <;> simp [corner, abs_of_nonneg hd]

lemma corner_separates {p w : Plane} {d : ℝ} {q : Bool → Bool → Plane}
    (hw : ‖w - p‖ < d / 2)
    (hq : ∀ i j, ‖q i j - corner p d i j‖ < d / 2) (i j : Bool) :
    DirectedLE i w.1 (q i j).1 ∧ DirectedLE j w.2 (q i j).2 := by
  have hw₁ := abs_lt.mp ((abs_fst_le (w - p)).trans_lt hw)
  have hw₂ := abs_lt.mp ((abs_snd_le (w - p)).trans_lt hw)
  have hq₁ := abs_lt.mp ((abs_fst_le (q i j - corner p d i j)).trans_lt (hq i j))
  have hq₂ := abs_lt.mp ((abs_snd_le (q i j - corner p d i j)).trans_lt (hq i j))
  cases i <;> cases j <;>
    simp [DirectedLE, corner] at * <;> constructor <;> linarith

lemma signedMonotone_squeeze {g : Plane → ℝ} {R d M c : ℝ}
    {p w : Plane} {q : Bool → Bool → Plane}
    (hg : SignedMonotoneOn g R) (hwR : ‖w‖ ≤ R)
    (hqR : ∀ i j, ‖q i j‖ ≤ R)
    (hw : ‖w - p‖ < d / 2)
    (hq : ∀ i j, ‖q i j - corner p d i j‖ < d / 2)
    (hval : ∀ i j, |g (q i j) - c| ≤ M) :
    |g w - c| ≤ M := by
  obtain ⟨sx, sy, hm⟩ := hg
  have hlo := corner_separates hw hq (!sx) (!sy)
  have hhi := corner_separates hw hq sx sy
  have hl : g (q (!sx) (!sy)) ≤ g w := by
    apply hm _ _ (hqR _ _) hwR
    · cases sx <;> simpa [DirectedLE] using hlo.1
    · cases sy <;> simpa [DirectedLE] using hlo.2
  have hh : g w ≤ g (q sx sy) :=
    hm _ _ hwR (hqR _ _) hhi.1 hhi.2
  exact abs_le.mpr ⟨by linarith [(abs_le.mp (hval (!sx) (!sy))).1],
    by linarith [(abs_le.mp (hval sx sy)).2]⟩

/-- Four forward sample points squeeze the inverse on a neighborhood.
No continuity, local boundedness, or surjectivity of the inverse is assumed. -/
theorem inverse_comp_locallyUniform_of_pointwise
    {F G : ℕ → Plane → Plane} (B : Plane ≃L[ℝ] Plane) {σ : ℝ}
    (hσ : σ = -1 ∨ σ = 1)
    (hF : ∀ x, Tendsto (fun n => F n x) atTop (𝓝 (σ • x)))
    (hleft : ∀ n x, G n (F n x) = x)
    (horder : ∀ R > 0, ∀ᶠ n in atTop,
      RankOrderOn (fun w => G n (B w)) R) :
    TendstoLocallyUniformly (fun n w => G n (B w)) (fun w => σ • B w) atTop := by
  have hsign : |σ| = 1 := by rcases hσ with rfl | rfl <;> norm_num
  have hinvol : ∀ x : Plane, σ • (σ • x) = x := by
    intro x
    rcases hσ with rfl | rfl <;> simp
  apply Metric.tendstoLocallyUniformly_iff.mpr
  intro ε hε p
  let M := ‖B.toContinuousLinearMap‖
  have hM : 0 ≤ M := norm_nonneg _
  have hMp : 0 < M + 1 := by linarith
  let d := ε / (4 * (M + 1))
  have hd : 0 < d := by dsimp [d]; positivity
  have hdeq : (M + 1) * d = ε / 4 := by
    dsimp [d]
    field_simp
  let R := ‖p‖ + 3 * d + 1
  have hR : 0 < R := by dsimp [R]; positivity
  let q : ℕ → Bool → Bool → Plane :=
    fun n i j => B.symm (F n (σ • B (corner p d i j)))
  have hqt (i j : Bool) :
      Tendsto (fun n => q n i j) atTop (𝓝 (corner p d i j)) := by
    have ht := (B.symm.continuous.tendsto _).comp (hF (σ • B (corner p d i j)))
    simpa only [q, Function.comp_def, hinvol, B.symm_apply_apply] using ht
  have hqevent : ∀ᶠ n in atTop, ∀ i j : Bool,
      ‖q n i j - corner p d i j‖ < d / 2 := by
    rw [eventually_all]
    intro i
    rw [eventually_all]
    intro j
    simpa only [dist_eq_norm] using
      Metric.tendsto_nhds.mp (hqt i j) (d / 2) (by positivity)
  refine ⟨Metric.ball p (d / 2), Metric.ball_mem_nhds p (by positivity), ?_⟩
  filter_upwards [hqevent, horder R hR] with n hqn hmon w hw
  have hw' : ‖w - p‖ < d / 2 := by
    simpa only [Metric.mem_ball, dist_eq_norm] using hw
  have hwR : ‖w‖ ≤ R := by
    have ht := norm_le_norm_sub_add w p
    dsimp [R]
    linarith
  have hqR (i j : Bool) : ‖q n i j‖ ≤ R := by
    have ht := norm_le_norm_sub_add (q n i j) (corner p d i j)
    have hc := norm_le_norm_sub_add (corner p d i j) p
    have hd' := corner_dist p hd.le i j
    dsimp [R]
    linarith [hqn i j]
  have hsample (i j : Bool) :
      ‖G n (B (q n i j)) - σ • B p‖ ≤ M * d := by
    have he : G n (B (q n i j)) = σ • B (corner p d i j) := by
      dsimp [q]
      rw [B.apply_symm_apply, hleft]
    rw [he, ← smul_sub, norm_smul, Real.norm_eq_abs, hsign, one_mul, ← B.map_sub]
    exact (B.toContinuousLinearMap.le_opNorm _).trans
      (mul_le_mul_of_nonneg_left (corner_dist p hd.le i j) hM)
  have hnear : ‖G n (B w) - σ • B p‖ ≤ M * d := by
    apply ThreeDirection.norm_le
    · apply signedMonotone_squeeze hmon.1 hwR hqR hw' hqn
      intro i j
      exact (abs_fst_le (G n (B (q n i j)) - σ • B p)).trans (hsample i j)
    · apply signedMonotone_squeeze hmon.2 hwR hqR hw' hqn
      intro i j
      exact (abs_snd_le (G n (B (q n i j)) - σ • B p)).trans (hsample i j)
  have htarget : ‖σ • B w - σ • B p‖ ≤ M * d := by
    rw [← smul_sub, norm_smul, Real.norm_eq_abs, hsign, one_mul, ← B.map_sub]
    exact (B.toContinuousLinearMap.le_opNorm _).trans
      (mul_le_mul_of_nonneg_left (by linarith : ‖w - p‖ ≤ d) hM)
  have htotal : dist (σ • B w) (G n (B w)) ≤ 2 * M * d := by
    have ht := dist_triangle (σ • B w) (σ • B p) (G n (B w))
    rw [dist_eq_norm, dist_eq_norm, dist_eq_norm, norm_sub_rev (σ • B p)] at ht
    rw [dist_eq_norm]
    linarith
  exact htotal.trans_lt (by nlinarith)

structure Admissible (cutoff : ℝ → ℕ → ℕ) (h : ℕ → ℝ) (j : ℕ → ℕ) : Prop where
  positive : ∀ k, 0 < h k
  zero_limit : Tendsto h atTop (𝓝 0)
  index_ge : ∀ k, k ≤ j k
  cutoff_ge : ∀ k, cutoff (h k) k ≤ j k

/-- This diagonal principle preserves the order of the two limits.  In
particular, `cutoff` has no regularity or uniformity hypothesis. -/
theorem iterated_of_diagonal_subsequence
    {P : ℝ → ℕ → Prop} {cutoff : ℝ → ℕ → ℕ} {η : ℝ} (hη : 0 < η)
    (hdiag : ∀ (h : ℕ → ℝ) (j : ℕ → ℕ), Admissible cutoff h j →
      (∀ k, h k < η) →
      ∃ r : ℕ → ℕ, StrictMono r ∧ ∀ᶠ k in atTop, P (h (r k)) (j (r k))) :
    ∃ δ > 0, ∀ h : ℝ, 0 < h → h < δ → ∀ᶠ j in atTop, P h j := by
  classical
  by_contra hn
  have hfail (d : ℝ) (hd : 0 < d) :
      ∃ h : ℝ, 0 < h ∧ h < d ∧ ¬∀ᶠ j in atTop, P h j := by
    by_contra hf
    apply hn
    refine ⟨d, hd, ?_⟩
    intro h hh hh'
    by_contra hp
    exact hf ⟨h, hh, hh', hp⟩
  have hex (k : ℕ) :=
    hfail (min η (1 / ((k : ℝ) + 1))) (lt_min hη (by positivity))
  choose h hpos hsmall hbad using hex
  have hjex (k : ℕ) :
      ∃ m : ℕ, k ≤ m ∧ cutoff (h k) k ≤ m ∧ ¬ P (h k) m := by
    obtain ⟨m, hm, hpm⟩ :=
      frequently_atTop.mp (not_eventually.mp (hbad k)) (max k (cutoff (h k) k))
    exact ⟨m, (le_max_left _ _).trans hm, (le_max_right _ _).trans hm, hpm⟩
  choose j hjk hjcut hjbad using hjex
  have hlim : Tendsto h atTop (𝓝 0) :=
    squeeze_zero (fun k => (hpos k).le)
      (fun k => (hsmall k).le.trans (min_le_right _ _))
      tendsto_one_div_add_atTop_nhds_zero_nat
  obtain ⟨r, _, hgood⟩ := hdiag h j ⟨hpos, hlim, hjk, hjcut⟩
    (fun k => (hsmall k).trans_le (min_le_left _ _))
  obtain ⟨k, hk⟩ := hgood.exists
  exact hjbad (r k) hk

/-- Rank order and separated projective input triples are geometric hypotheses.
Nonlinear compactness and linear singular bounds are derived below. -/
structure NormalizedRankData where
  L : ℕ → Plane → Plane
  p : Plane
  F : ℝ → ℕ → Plane → Plane
  G : ℝ → ℕ → Plane → Plane
  B : Plane ≃L[ℝ] Plane
  A : ℝ → ℕ → Plane →L[ℝ] Plane
  scale : ℝ → ℕ → ℝ
  cutoff : ℝ → ℕ → ℕ
  radius : ℝ
  separation : ℝ
  radius_pos : 0 < radius
  separation_pos : 0 < separation
  rank_coordinates : ∀ h, 0 < h → h < radius → ∀ j,
    Continuous (F h j) ∧
      RankGeometry.CoordinateSegmentControl (fun x => B.symm (F h j x)) ∧
      F h j (0, 0) = (0, 0) ∧ ‖F h j (1, 0)‖ = 1
  left_inverse : ∀ h, 0 < h → h < radius → ∀ j x, G h j (F h j x) = x
  scale_pos : ∀ h, 0 < h → h < radius → ∀ j, 0 < scale h j
  rank_identity : ∀ h, 0 < h → h < radius → ∀ j w, ‖w‖ ≤ 1 →
    L j (p + h • w) - L j p = scale h j • A h j (G h j (B w))
  moving : ∀ h j, Admissible cutoff h j →
    MovingDirections (fun k => F (h k) (j k))
  rank_order : ∀ h j, Admissible cutoff h j → ∀ R > 0,
    ∀ᶠ k in atTop, RankOrderOn (fun w => G (h k) (j k) (B w)) R
  normalizer_geometry : ∀ h j, Admissible cutoff h j →
    ∀ᶠ k in atTop, ∃ u : Fin 3 → Plane,
      ‖A (h k) (j k)‖ = 1 ∧ (∀ i, ‖u i‖ = 1) ∧
        RankGeometry.Separated separation u ∧ RankGeometry.Projective (A (h k) (j k)) u

noncomputable def NormalizedRankData.a (D : NormalizedRankData) : ℝ :=
  (RankGeometry.normalized_triple_bounds D.separation D.separation_pos).choose

def NormalizedRankData.b (_ : NormalizedRankData) : ℝ := 1

noncomputable def NormalizedRankData.H (D : NormalizedRankData) : ℝ :=
  ‖D.B.toContinuousLinearMap‖ * ‖D.B.symm.toContinuousLinearMap‖

lemma NormalizedRankData.a_pos (D : NormalizedRankData) : 0 < D.a :=
  (RankGeometry.normalized_triple_bounds D.separation D.separation_pos).choose_spec.1

lemma NormalizedRankData.b_pos (D : NormalizedRankData) : 0 < D.b := zero_lt_one

lemma NormalizedRankData.H_nonneg (D : NormalizedRankData) : 0 ≤ D.H := by
  exact mul_nonneg (norm_nonneg _) (norm_nonneg _)

lemma NormalizedRankData.normalized (D : NormalizedRankData)
    (h : ℝ) (hh : 0 < h) (hr : h < D.radius) (j : ℕ) :
    Continuous (D.F h j) ∧ Turning (D.F h j) D.H ∧
      D.F h j (0, 0) = (0, 0) ∧ ‖D.F h j (1, 0)‖ = 1 := by
  rcases D.rank_coordinates h hh hr j with ⟨hc, ht, hzero, hone⟩
  refine ⟨hc, ?_, hzero, hone⟩
  simpa only [NormalizedRankData.H, ContinuousLinearEquiv.symm_symm] using
    RankGeometry.turning_of_coordinates D.B.symm ht

lemma NormalizedRankData.linear_bounds (D : NormalizedRankData)
    (h : ℕ → ℝ) (j : ℕ → ℕ) (hadm : Admissible D.cutoff h j) :
    ∀ᶠ k in atTop, ∀ v : Plane,
      D.a * ‖v‖ ≤ ‖D.A (h k) (j k) v‖ ∧ ‖D.A (h k) (j k) v‖ ≤ D.b * ‖v‖ := by
  filter_upwards [D.normalizer_geometry h j hadm] with k hk
  rcases hk with ⟨u, hA, hu, hsep, hp⟩
  simpa only [NormalizedRankData.a, NormalizedRankData.b, one_mul] using
    (RankGeometry.normalized_triple_bounds D.separation D.separation_pos).choose_spec.2
      (D.A (h k) (j k)) u hA hu hsep hp

lemma inverse_norm_bounds (B : Plane ≃L[ℝ] Plane)
    {g : Plane → Plane} {σ K r : ℝ} {w : Plane}
    (hσ : σ = -1 ∨ σ = 1) (hK : 1 ≤ K)
    (hB : ‖B.toContinuousLinearMap‖ ≤ K)
    (hBi : ‖B.symm.toContinuousLinearMap‖ ≤ K)
    (hr : 0 ≤ r) (hw : eucNorm w = r)
    (he : ‖g (B w) - σ • B w‖ ≤ r / (4 * K)) :
    r / (4 * K) ≤ ‖g (B w)‖ ∧ ‖g (B w)‖ ≤ 2 * K * r := by
  have hKp : 0 < K := by linarith
  have hsign : |σ| = 1 := by rcases hσ with rfl | rfl <;> norm_num
  have hnorm : ‖σ • B w‖ = ‖B w‖ := by
    rw [norm_smul, Real.norm_eq_abs, hsign, one_mul]
  have hBw : ‖B w‖ ≤ K * r := by
    calc
      ‖B w‖ ≤ ‖B.toContinuousLinearMap‖ * ‖w‖ := B.toContinuousLinearMap.le_opNorm _
      _ ≤ K * ‖w‖ := mul_le_mul_of_nonneg_right hB (norm_nonneg _)
      _ ≤ K * r := mul_le_mul_of_nonneg_left (hw ▸ maxNorm_le_eucNorm w) hKp.le
  have hback : ‖w‖ ≤ K * ‖B w‖ := by
    calc
      ‖w‖ = ‖B.symm (B w)‖ := by rw [B.symm_apply_apply]
      _ ≤ ‖B.symm.toContinuousLinearMap‖ * ‖B w‖ := B.symm.toContinuousLinearMap.le_opNorm _
      _ ≤ K * ‖B w‖ := mul_le_mul_of_nonneg_right hBi (norm_nonneg _)
  have hrbound : r ≤ 2 * K * ‖B w‖ := by
    have ht := eucNorm_le_two_maxNorm w
    rw [hw] at ht
    linarith
  have hq : K * (r / (4 * K)) = r / 4 := by field_simp
  have hl : ‖B w‖ ≤ r / (4 * K) + ‖g (B w)‖ := by
    have ht := norm_le_norm_sub_add (σ • B w) (g (B w))
    rw [hnorm, norm_sub_rev] at ht
    linarith
  have hu : ‖g (B w)‖ ≤ r / (4 * K) + K * r := by
    have ht := norm_le_norm_sub_add (g (B w)) (σ • B w)
    rw [hnorm] at ht
    linarith
  constructor
  · apply (div_le_iff₀ (by positivity : 0 < 4 * K)).mpr
    have ht := mul_le_mul_of_nonneg_left hl (by positivity : 0 ≤ 2 * K)
    nlinarith
  · have hqle : r / (4 * K) ≤ r := div_le_self hr (by linarith)
    have hrle : r ≤ K * r := by nlinarith
    nlinarith

lemma physical_norm_bounds {A : Plane →L[ℝ] Plane} {z : Plane}
    {s a b K r : ℝ} (hs : 0 < s) (ha : 0 < a) (hb : 0 < b)
    (hA : a * ‖z‖ ≤ ‖A z‖ ∧ ‖A z‖ ≤ b * ‖z‖)
    (hz : r / (4 * K) ≤ ‖z‖ ∧ ‖z‖ ≤ 2 * K * r) :
    s * a * (r / (4 * K)) ≤ eucNorm (s • A z) ∧
      eucNorm (s • A z) ≤ 4 * s * b * K * r := by
  rw [eucNorm_smul, abs_of_pos hs]
  constructor
  · calc
      s * a * (r / (4 * K)) ≤ s * (a * ‖z‖) := by
        nlinarith [mul_le_mul_of_nonneg_left hz.1 (mul_pos hs ha).le]
      _ ≤ s * ‖A z‖ := mul_le_mul_of_nonneg_left hA.1 hs.le
      _ ≤ s * eucNorm (A z) :=
        mul_le_mul_of_nonneg_left (maxNorm_le_eucNorm _) hs.le
  · calc
      s * eucNorm (A z) ≤ s * (2 * ‖A z‖) :=
        mul_le_mul_of_nonneg_left (eucNorm_le_two_maxNorm _) hs.le
      _ ≤ s * (2 * (b * ‖z‖)) := by gcongr; exact hA.2
      _ ≤ s * (2 * (b * (2 * K * r))) := by gcongr; exact hz.2
      _ = 4 * s * b * K * r := by ring

lemma pairwise_of_bounds {O I s a b K t : ℝ}
    (ha : 0 < a) (hb : 0 < b) (hK : 0 < K) (ht : 0 < t)
    (hO : s * a * (1 / (4 * K)) ≤ O ∧ O ≤ 4 * s * b * K)
    (hI : s * a * ((1 / t) / (4 * K)) ≤ I ∧
      I ≤ 4 * s * b * K * (1 / t)) :
    O / ((16 * b * K ^ 2 / a) * t) ≤ I ∧
      I ≤ (16 * b * K ^ 2 / a) * O / t := by
  have hC : 0 < 16 * b * K ^ 2 / a := by positivity
  constructor
  · calc
      O / ((16 * b * K ^ 2 / a) * t) ≤
          (4 * s * b * K) / ((16 * b * K ^ 2 / a) * t) :=
        div_le_div_of_nonneg_right hO.2 (mul_pos hC ht).le
      _ = s * a * ((1 / t) / (4 * K)) := by
        field_simp
        ring
      _ ≤ I := hI.1
  · calc
      I ≤ 4 * s * b * K * (1 / t) := hI.2
      _ = (16 * b * K ^ 2 / a) * (s * a * (1 / (4 * K))) / t := by
        field_simp
        ring
      _ ≤ (16 * b * K ^ 2 / a) * O / t :=
        div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hO.1 hC.le) ht.le

noncomputable def linearSize (B : Plane ≃L[ℝ] Plane) : ℝ :=
  ‖B.toContinuousLinearMap‖ + ‖B.symm.toContinuousLinearMap‖ + 1

lemma linearSize_ge_one (B : Plane ≃L[ℝ] Plane) : 1 ≤ linearSize B := by
  dsimp [linearSize]
  linarith [norm_nonneg B.toContinuousLinearMap, norm_nonneg B.symm.toContinuousLinearMap]

lemma linearSize_bounds (B : Plane ≃L[ℝ] Plane) :
    ‖B.toContinuousLinearMap‖ ≤ linearSize B ∧
      ‖B.symm.toContinuousLinearMap‖ ≤ linearSize B := by
  dsimp [linearSize]
  constructor <;> linarith [norm_nonneg B.toContinuousLinearMap,
    norm_nonneg B.symm.toContinuousLinearMap]

def RadialComparison (L : ℕ → Plane → Plane) (p : Plane)
    (C : ℝ) (T : ℕ) (h : ℝ) (j : ℕ) : Prop :=
  ∀ u v : Plane, eucNorm u = h → eucNorm v = h / (T : ℝ) →
    eucNorm (L j (p + u) - L j p) / (C * (T : ℝ)) ≤
        eucNorm (L j (p + v) - L j p) ∧
      eucNorm (L j (p + v) - L j p) ≤
        C * eucNorm (L j (p + u) - L j p) / (T : ℝ)

lemma radialComparison_of_inverse_error (D : NormalizedRankData)
    {h σ : ℝ} {j T : ℕ} (hh : 0 < h) (hh' : h < D.radius)
    (hT : 2 ≤ T) (hσ : σ = -1 ∨ σ = 1)
    (hA : ∀ v : Plane, D.a * ‖v‖ ≤ ‖D.A h j v‖ ∧
      ‖D.A h j v‖ ≤ D.b * ‖v‖)
    (he : ∀ w : Plane, ‖w‖ ≤ 1 →
      ‖D.G h j (D.B w) - σ • D.B w‖ ≤
        (1 / (4 * linearSize D.B)) / (T : ℝ)) :
    RadialComparison D.L D.p (16 * D.b * linearSize D.B ^ 2 / D.a) T h j := by
  let K := linearSize D.B
  have hK : 1 ≤ K := linearSize_ge_one _
  have hKp : 0 < K := by linarith
  have hT1 : (1 : ℝ) ≤ T := by exact_mod_cast (show 1 ≤ T by omega)
  have hTp : (0 : ℝ) < T := by linarith
  have hTinv : 1 / (T : ℝ) ≤ 1 := (div_le_one hTp).mpr hT1
  intro u v hu hv
  let w : Plane := h⁻¹ • u
  let z : Plane := h⁻¹ • v
  have hw : eucNorm w = 1 := by
    dsimp [w]
    rw [eucNorm_smul, abs_of_pos (inv_pos.mpr hh), hu, inv_mul_cancel₀ hh.ne']
  have hz : eucNorm z = 1 / (T : ℝ) := by
    dsimp [z]
    rw [eucNorm_smul, abs_of_pos (inv_pos.mpr hh), hv]
    field_simp
  have hwball : ‖w‖ ≤ 1 := hw ▸ maxNorm_le_eucNorm w
  have hzball : ‖z‖ ≤ 1 := (hz ▸ maxNorm_le_eucNorm z).trans hTinv
  have hew : ‖D.G h j (D.B w) - σ • D.B w‖ ≤ 1 / (4 * K) :=
    (he w hwball).trans (div_le_self (by positivity) hT1)
  have hez : ‖D.G h j (D.B z) - σ • D.B z‖ ≤ (1 / (T : ℝ)) / (4 * K) := by
    convert he z hzball using 1
    dsimp [K]
    ring
  have hwG := inverse_norm_bounds D.B hσ hK (linearSize_bounds _).1
    (linearSize_bounds _).2 (by norm_num : (0 : ℝ) ≤ 1) hw hew
  have hzG := inverse_norm_bounds D.B hσ hK (linearSize_bounds _).1
    (linearSize_bounds _).2 (by positivity : 0 ≤ 1 / (T : ℝ)) hz hez
  have ho := physical_norm_bounds (D.scale_pos h hh hh' j) D.a_pos D.b_pos
    (hA (D.G h j (D.B w))) hwG
  have hi := physical_norm_bounds (D.scale_pos h hh hh' j) D.a_pos D.b_pos
    (hA (D.G h j (D.B z))) hzG
  have hwu : h • w = u := by simp [w, smul_smul, hh.ne']
  have hzv : h • z = v := by simp [z, smul_smul, hh.ne']
  have hLo := D.rank_identity h hh hh' j w hwball
  have hLi := D.rank_identity h hh hh' j z hzball
  rw [hwu] at hLo
  rw [hzv] at hLi
  rw [← hLo] at ho
  rw [← hLi] at hi
  simp only [mul_one] at ho
  simpa only [mul_one] using pairwise_of_bounds D.a_pos D.b_pos hKp hTp ho hi

theorem NormalizedRankData.iterated_radial_with_constant (D : NormalizedRankData) :
    ∀ T : ℕ, 2 ≤ T → ∃ δ > 0, ∀ h : ℝ, 0 < h → h < δ →
      ∀ᶠ j in atTop,
        RadialComparison D.L D.p (16 * D.b * linearSize D.B ^ 2 / D.a) T h j := by
  intro T hT
  apply iterated_of_diagonal_subsequence (cutoff := D.cutoff) D.radius_pos
  intro h j hadm hsmall
  have hn (k : ℕ) := D.normalized (h k) (hadm.positive k) (hsmall k) (j k)
  obtain ⟨r, hr, σ, hσ, hforward⟩ :=
    sequential_compactness_of_moving D.H_nonneg
      (fun k => (hn k).1) (fun k => (hn k).2.1) (D.moving h j hadm)
      (fun k => (hn k).2.2.1) (fun k => (hn k).2.2.2)
      (fun k => k) (fun _ _ hk => hk)
  have hfp (x : Plane) :
      Tendsto (fun n => D.F (h (r n)) (j (r n)) x) atTop (𝓝 (σ • x)) :=
    (hforward.tendstoLocallyUniformlyOn (s := univ)).tendsto_at (mem_univ x)
  have hinv := inverse_comp_locallyUniform_of_pointwise
    (G := fun n => D.G (h (r n)) (j (r n))) D.B hσ hfp
    (fun n x => D.left_inverse (h (r n)) (hadm.positive _) (hsmall _) (j (r n)) x)
    (fun R hR => hr.tendsto_atTop.eventually (D.rank_order h j hadm R hR))
  have hu := (tendstoLocallyUniformlyOn_iff_tendstoUniformlyOn_of_compact
    (isCompact_closedBall (0 : Plane) 1)).mp hinv.tendstoLocallyUniformlyOn
  have hTp : (0 : ℝ) < T := by exact_mod_cast (show 0 < T by omega)
  have hKp : 0 < linearSize D.B := lt_of_lt_of_le zero_lt_one (linearSize_ge_one _)
  let ε := (1 / (4 * linearSize D.B)) / (T : ℝ)
  have hε : 0 < ε := by dsimp [ε]; positivity
  refine ⟨r, hr, ?_⟩
  filter_upwards [Metric.tendstoUniformlyOn_iff.mp hu ε hε,
    hr.tendsto_atTop.eventually (D.linear_bounds h j hadm)] with n hen han
  apply radialComparison_of_inverse_error D (hadm.positive _) (hsmall _) hT hσ han
  intro w hw
  have hmem : w ∈ Metric.closedBall (0 : Plane) 1 := by
    simpa only [Metric.mem_closedBall, dist_zero_right] using hw
  have hew := hen w hmem
  rw [dist_eq_norm, norm_sub_rev] at hew
  exact hew.le

/-- Euclidean offsets, with a constant independent of the integer scale ratio.
The eventual index is allowed to depend on the fixed positive radius. -/
theorem NormalizedRankData.iterated_radial (D : NormalizedRankData) :
    ∃ C : ℝ, 0 < C ∧ ∀ T : ℕ, 2 ≤ T →
      ∃ δ : ℝ, 0 < δ ∧ ∀ h : ℝ, 0 < h → h < δ →
        ∀ᶠ j in atTop, ∀ u v : Plane,
          eucNorm u = h → eucNorm v = h / (T : ℝ) →
          eucNorm (D.L j (D.p + u) - D.L j D.p) / (C * (T : ℝ)) ≤
              eucNorm (D.L j (D.p + v) - D.L j D.p) ∧
            eucNorm (D.L j (D.p + v) - D.L j D.p) ≤
              C * eucNorm (D.L j (D.p + u) - D.L j D.p) / (T : ℝ) := by
  have ha := D.a_pos
  have hb := D.b_pos
  have hK : 0 < linearSize D.B := lt_of_lt_of_le zero_lt_one (linearSize_ge_one _)
  refine ⟨16 * D.b * linearSize D.B ^ 2 / D.a, by positivity, ?_⟩
  intro T hT
  simpa only [RadialComparison] using D.iterated_radial_with_constant T hT

private lemma identity_coordinate_control :
    RankGeometry.CoordinateSegmentControl (fun x : Plane => x) := by
  intro x y _ t ht
  have hm (r : ℝ) : |t * r| ≤ |r| := by
    rw [abs_mul, abs_of_nonneg ht.1]
    nlinarith [abs_nonneg r, ht.2]
  have h₁ : (seg x y t).1 - x.1 = t * (y.1 - x.1) := by
    simp [seg]
    ring
  have h₂ : (seg x y t).2 - x.2 = t * (y.2 - x.2) := by
    simp [seg]
    ring
  exact ⟨h₁ ▸ hm (y.1 - x.1), h₂ ▸ hm (y.2 - x.2)⟩

/-- The geometric hypotheses are inhabited for every, even irregular, cutoff. -/
noncomputable def identityExample (cutoff : ℝ → ℕ → ℕ) : NormalizedRankData where
  L := fun _ x => x
  p := 0
  F := fun _ _ x => x
  G := fun _ _ x => x
  B := ContinuousLinearEquiv.refl ℝ Plane
  A := fun _ _ => ContinuousLinearMap.id ℝ Plane
  scale := fun h _ => h
  cutoff := cutoff
  radius := 1
  separation := 1
  radius_pos := zero_lt_one
  separation_pos := zero_lt_one
  rank_coordinates := by
    intro h hh hr j
    exact ⟨continuous_id, identity_coordinate_control, rfl, by simp [Prod.norm_def]⟩
  left_inverse := by intro h hh hr j x; rfl
  scale_pos := by intro h hh hr j; exact hh
  rank_identity := by intro h hh hr j w hw; simp
  moving := by
    intro h j ha
    apply movingDirections_iff_vanishingDefect.mpr
    intro R hR ε hε
    apply Eventually.of_forall
    intro n x y hx hy
    refine ⟨?_, ?_, ?_⟩ <;> intro hxy <;>
      simp only [← hxy, sub_self, abs_zero] <;> exact hε.le
  rank_order := by
    intro h j ha R hR
    apply Eventually.of_forall
    intro k
    constructor
    · refine ⟨true, true, ?_⟩
      intro x y hx hy hx' hy'
      exact hx'
    · refine ⟨true, true, ?_⟩
      intro x y hx hy hx' hy'
      exact hy'
  normalizer_geometry := by
    intro h j ha
    apply Eventually.of_forall
    intro k
    refine ⟨(fun i : Fin 3 => if i.val = 0 then RankGeometry.e1
      else if i.val = 1 then RankGeometry.e2 else (1, 1)), ?_, ?_, ?_, ?_⟩
    · simp
    · intro i
      fin_cases i <;> norm_num [RankGeometry.e1, RankGeometry.e2, Prod.norm_def]
    · norm_num [RankGeometry.Separated, RankGeometry.det, RankGeometry.e1, RankGeometry.e2]
    · norm_num [RankGeometry.Projective, RankGeometry.e1, RankGeometry.e2]

theorem identity_cutoff_example (cutoff : ℝ → ℕ → ℕ) :
    ∃ C : ℝ, 0 < C ∧ ∀ T : ℕ, 2 ≤ T →
      ∃ δ > 0, ∀ h : ℝ, 0 < h → h < δ → ∀ᶠ j in atTop,
        RadialComparison (fun _ x => x) (0, 0) C T h j :=
  (identityExample cutoff).iterated_radial

end RankRadial

#print axioms RankRadial.inverse_comp_locallyUniform_of_pointwise
#print axioms RankRadial.iterated_of_diagonal_subsequence
#print axioms RankRadial.NormalizedRankData.iterated_radial
#print axioms RankRadial.identity_cutoff_example

#print axioms ThreeDirection.sequential_compactness_of_moving
#print axioms ThreeDirection.movingDirections_iff_vanishingDefect
