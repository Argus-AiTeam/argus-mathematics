import Mathlib

namespace DiskReconstruction

section Swap

variable {A B H X Y : Type*}
variable [AddCommGroup A] [AddCommGroup B] [AddCommGroup H]
variable [AddCommGroup X] [AddCommGroup Y]

def swapP (u : A × B × H) : (A × H × X) × (B × H × Y) :=
  ((u.1, u.2.2, 0), (u.2.1, u.2.2, 0))

def swapI (z : (A × H × X) × (B × H × Y)) : H × X × Y :=
  (z.1.2.1 - z.2.2.1, z.1.2.2, z.2.2.2)

def swapR (z : (A × H × X) × (B × H × Y)) : A × B × H :=
  (z.1.1, z.2.1, z.2.2.1)

def swapS (q : H × X × Y) : (A × H × X) × (B × H × Y) :=
  ((0, q.1, q.2.1), (0, 0, q.2.2))

theorem swap_ip (u : A × B × H) :
    swapI (swapP (X := X) (Y := Y) u) = 0 := by
  ext <;> simp [swapI, swapP]

theorem swap_rp (u : A × B × H) :
    swapR (swapP (X := X) (Y := Y) u) = u := by
  rfl

theorem swap_is (q : H × X × Y) :
    swapI (swapS (A := A) (B := B) q) = q := by
  ext <;> simp [swapI, swapS]

theorem swap_contraction (z : (A × H × X) × (B × H × Y)) :
    swapP (swapR z) + swapS (swapI z) = z := by
  ext <;> simp [swapP, swapR, swapS, swapI]

theorem swap_p_add (u v : A × B × H) :
    swapP (X := X) (Y := Y) (u + v) = swapP u + swapP v := by
  ext <;> simp [swapP]

theorem swap_i_add (z t : (A × H × X) × (B × H × Y)) :
    swapI (z + t) = swapI z + swapI t := by
  ext <;> simp [swapI] <;> abel

theorem swap_p_injective :
    Function.Injective (swapP (A := A) (B := B) (H := H) (X := X) (Y := Y)) := by
  intro u v huv
  have hr := congrArg (swapR (A := A) (B := B) (H := H) (X := X) (Y := Y)) huv
  simpa only [swap_rp] using hr

theorem swap_i_surjective :
    Function.Surjective (swapI (A := A) (B := B) (H := H) (X := X) (Y := Y)) := by
  intro q
  exact ⟨swapS q, swap_is q⟩

theorem swap_exact (z : (A × H × X) × (B × H × Y)) :
    swapI z = 0 ↔ ∃ u : A × B × H, swapP u = z := by
  constructor
  · intro hz
    refine ⟨swapR z, ?_⟩
    have hs : swapS (A := A) (B := B) (0 : H × X × Y) = 0 := rfl
    have hc := swap_contraction z
    rw [hz, hs, add_zero] at hc
    exact hc
  · rintro ⟨u, rfl⟩
    exact swap_ip u

end Swap

section Closure

universe u v

variable {X : ℕ → Type u} {E : ℕ → Type v}
variable (incoming : (i : ℕ) → E i → X i)
variable (outgoing : (i : ℕ) → E i → X (i + 1))

inductive LiftPath :
    (n : ℕ) → X 0 → X n → Prop
  | nil (x : X 0) : LiftPath 0 x x
  | step {n : ℕ} {start : X 0} {last : X n}
      (path : LiftPath n start last) (e : E n)
      (compatible : incoming n e = last) :
      LiftPath (n + 1) start (outgoing n e)

theorem path_exists (n : ℕ) :
    (∀ i, i < n → Function.Surjective (incoming i)) →
    ∀ start : X 0, ∃ last : X n, LiftPath incoming outgoing n start last := by
  induction n with
  | zero =>
      intro _ start
      exact ⟨start, LiftPath.nil start⟩
  | succ n ih =>
      intro surj start
      obtain ⟨last, path⟩ :=
        ih (fun i hi => surj i (Nat.lt_trans hi (Nat.lt_succ_self n))) start
      obtain ⟨e, he⟩ := surj n (Nat.lt_succ_self n) last
      exact ⟨outgoing n e, LiftPath.step path e he⟩

theorem anchored_closure (n : ℕ)
    (surj : ∀ i, i < n → Function.Surjective (incoming i))
    (start : X 0) (close : X n → X 0) [Subsingleton (X 0)] :
    ∃ last : X n,
      LiftPath incoming outgoing n start last ∧ close last = start := by
  obtain ⟨last, path⟩ := path_exists incoming outgoing n surj start
  exact ⟨last, path, Subsingleton.elim _ _⟩

end Closure

end DiskReconstruction
