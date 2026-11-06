import Mathlib

namespace PrimeFiveKernel

structure MultiplicativeFiltration (R : Type*) [Ring R] where
  level : ℕ → AddSubgroup R
  decreasing : ∀ {i j : ℕ}, i ≤ j → level j ≤ level i
  one_mem : (1 : R) ∈ level 0
  mul_mem : ∀ {i j : ℕ} {x y : R},
    x ∈ level i → y ∈ level j → x * y ∈ level (i + j)
  separated : ∀ x : R, (∀ i : ℕ, x ∈ level i) → x = 0

theorem zero_of_constant_tail {R : Type*} [Ring R]
    (F : MultiplicativeFiltration R) {N : ℕ}
    (stable : ∀ s : ℕ, N ≤ s → F.level s = F.level (s + 1))
    {x : R} (hx : x ∈ F.level N) : x = 0 := by
  apply F.separated x
  intro s
  induction s with
  | zero => exact F.decreasing (Nat.zero_le N) hx
  | succ s ih =>
    by_cases hs : N ≤ s
    · rw [← stable s hs]
      exact ih
    · exact F.decreasing (by omega) hx

theorem power_mem {R : Type*} [Ring R]
    (F : MultiplicativeFiltration R) {x : R} {f : ℕ}
    (hx : x ∈ F.level f) (m : ℕ) : x ^ m ∈ F.level (f * m) := by
  induction m with
  | zero => simpa using F.one_mem
  | succ m ih =>
    simpa only [pow_succ, Nat.mul_succ] using F.mul_mem ih hx

theorem power_vanishes {R : Type*} [Ring R]
    (F : MultiplicativeFiltration R) {N f m : ℕ}
    (stable : ∀ s : ℕ, N ≤ s → F.level s = F.level (s + 1))
    {x : R} (hx : x ∈ F.level f) (bound : N ≤ f * m) :
    x ^ m = 0 := by
  exact zero_of_constant_tail F stable (F.decreasing bound (power_mem F hx m))

theorem nonzero_of_nonzero_graded {R : Type*} [Ring R]
    (F : MultiplicativeFiltration R) {x : R} {s : ℕ}
    (hx : x ∉ F.level (s + 1)) : x ≠ 0 := by
  intro hz
  apply hx
  rw [hz]
  exact (F.level (s + 1)).zero_mem

theorem smaller_power_nonzero {R : Type*} [MonoidWithZero R]
    {x : R} {m k : ℕ} (hm : m ≤ k) (hk : x ^ k ≠ 0) : x ^ m ≠ 0 := by
  intro hz
  apply hk
  have he : m + (k - m) = k := Nat.add_sub_of_le hm
  calc
    x ^ k = x ^ (m + (k - m)) := by rw [he]
    _ = x ^ m * x ^ (k - m) := pow_add x m (k - m)
    _ = 0 := by rw [hz, zero_mul]

theorem canonical_kernel_of_detection
    {A V B W D : Type*} [Ring A] [Ring V] [Ring B] [Ring W] [Ring D]
    (i : A →+* V) (upper : A →+* B) (j : B →+* W)
    (canonical : V →+* W) (detector : V →+* D)
    (square : canonical.comp i = j.comp upper)
    {x : A} {m : ℕ}
    (detected : (detector (i x)) ^ m ≠ 0)
    (killed : (upper x) ^ m = 0) :
    (i x) ^ m ≠ 0 ∧ canonical ((i x) ^ m) = 0 := by
  have hs : canonical (i x) = j (upper x) := by
    exact congrArg (fun f : A →+* W => f x) square
  constructor
  · intro hz
    apply detected
    simpa only [map_pow, map_zero] using congrArg detector hz
  · calc
      canonical ((i x) ^ m) = (canonical (i x)) ^ m := map_pow _ _ _
      _ = (j (upper x)) ^ m := congrArg (fun y : W => y ^ m) hs
      _ = j ((upper x) ^ m) := (map_pow _ _ _).symm
      _ = 0 := by rw [killed, map_zero]

theorem prime_five_kernel_interval
    {A V B W D : Type*} [Ring A] [Ring V] [Ring B] [Ring W] [Ring D]
    (i : A →+* V) (upper : A →+* B) (j : B →+* W)
    (canonical : V →+* W) (detector : V →+* D)
    (square : canonical.comp i = j.comp upper)
    (F : MultiplicativeFiltration B)
    (stable : ∀ s : ℕ, 26 ≤ s → F.level s = F.level (s + 1))
    {x : A} (in_two : upper x ∈ F.level 2)
    (detected_sixteen : (detector (i x)) ^ 16 ≠ 0)
    {m : ℕ} (hm : 13 ≤ m) (hm' : m ≤ 16) :
    (i x) ^ m ≠ 0 ∧ canonical ((i x) ^ m) = 0 := by
  apply canonical_kernel_of_detection i upper j canonical detector square
  · exact smaller_power_nonzero hm' detected_sixteen
  · exact power_vanishes F stable in_two (by omega)

theorem prime_five_degrees :
    2 * 5 * (5 - 1) - 2 = 38 ∧
    38 * 13 = 494 ∧ 38 * 14 = 532 ∧ 38 * 15 = 570 ∧ 38 * 16 = 608 ∧
    2 * 12 < 26 ∧ 26 ≤ 2 * 13 ∧ 27 ≤ 2 * 16 := by
  decide

#print axioms zero_of_constant_tail
#print axioms power_vanishes
#print axioms canonical_kernel_of_detection
#print axioms prime_five_kernel_interval

end PrimeFiveKernel
