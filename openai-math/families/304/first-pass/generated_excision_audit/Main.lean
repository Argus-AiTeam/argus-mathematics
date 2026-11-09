import Mathlib

namespace GeneratedExcision

universe u v w z

structure BiTransfer {A : Type u} {B : Type v}
    [AddCommGroup A] [AddCommGroup B] (f : A →+ B) (q : ℕ) where
  backward : B →+ A
  forward_backward : ∀ y, f (backward y) = q • y
  backward_forward : ∀ x, backward (f x) = q • x

variable {A₀ : Type u} {B₀ : Type v} {A₁ : Type w} {B₁ : Type z}
  [AddCommGroup A₀] [AddCommGroup B₀] [AddCommGroup A₁] [AddCommGroup B₁]

def doubleTransfer
    (f : A₀ →+ B₀) (g : A₁ →+ B₁)
    (iA : A₀ →+ A₁) (iB : B₀ →+ B₁)
    (dA : A₁ →+ A₀) (dB : B₁ →+ B₀)
    (square : ∀ x, g (iA x) = iB (f x))
    (natural : ∀ x, dB (g x) = f (dA x))
    (doubleA : ∀ x, iA (dA x) = 2 • x)
    (doubleB : ∀ y, iB (dB y) = 2 • y)
    (q : ℕ) (t : BiTransfer f q) : BiTransfer g (2 * q) where
  backward := iA.comp (t.backward.comp dB)
  forward_backward := by
    intro y
    change g (iA (t.backward (dB y))) = (2 * q) • y
    rw [square, t.forward_backward, map_nsmul, doubleB]
    simp [smul_smul, Nat.mul_comm]
  backward_forward := by
    intro x
    change iA (t.backward (dB (g x))) = (2 * q) • x
    rw [natural, t.backward_forward, map_nsmul, doubleA]
    simp [smul_smul, Nat.mul_comm]

theorem transfer_bounds {A : Type u} {B : Type v}
    [AddCommGroup A] [AddCommGroup B]
    {f : A →+ B} {q : ℕ} (t : BiTransfer f q) :
    (∀ x, f x = 0 → q • x = 0) ∧
      (∀ y, ∃ x, f x = q • y) := by
  constructor
  · intro x hx
    have h := t.backward_forward x
    rw [hx, map_zero] at h
    exact h.symm
  · intro y
    exact ⟨t.backward y, t.forward_backward y⟩

structure DoublingTower (A : ℕ → Type u) (B : ℕ → Type v)
    [∀ j, AddCommGroup (A j)] [∀ j, AddCommGroup (B j)] where
  comparison : ∀ j, A j →+ B j
  includeA : ∀ j, A j →+ A (j + 1)
  includeB : ∀ j, B j →+ B (j + 1)
  returnA : ∀ j, A (j + 1) →+ A j
  returnB : ∀ j, B (j + 1) →+ B j
  square : ∀ j x, comparison (j + 1) (includeA j x) =
    includeB j (comparison j x)
  natural : ∀ j x, returnB j (comparison (j + 1) x) =
    comparison j (returnA j x)
  doubleA : ∀ j x, includeA j (returnA j x) = 2 • x
  doubleB : ∀ j y, includeB j (returnB j y) = 2 • y
  base : BiTransfer (comparison 0) 1

variable {A : ℕ → Type u} {B : ℕ → Type v}
  [∀ j, AddCommGroup (A j)] [∀ j, AddCommGroup (B j)]

def transferAt (T : DoublingTower A B) :
    (j : ℕ) → BiTransfer (T.comparison j) (2 ^ j)
  | 0 => by simpa using T.base
  | j + 1 => by
    simpa [pow_succ, Nat.mul_comm] using
      doubleTransfer (T.comparison j) (T.comparison (j + 1))
        (T.includeA j) (T.includeB j) (T.returnA j) (T.returnB j)
        (T.square j) (T.natural j) (T.doubleA j) (T.doubleB j)
        (2 ^ j) (transferAt T j)

theorem tower_bounds (T : DoublingTower A B) (j : ℕ) :
    (∀ x, T.comparison j x = 0 → (2 ^ j) • x = 0) ∧
      (∀ y, ∃ x, T.comparison j x = (2 ^ j) • y) :=
  transfer_bounds (transferAt T j)

end GeneratedExcision
