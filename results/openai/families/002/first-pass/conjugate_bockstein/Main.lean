import Mathlib
import Mathlib.LinearAlgebra.BilinearForm.Properties

namespace ConjugateBockstein

open LinearMap (BilinForm)

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

theorem alt_swap (e : BilinForm R M) (he : e.IsAlt) (a b : M) :
    e b a = -e a b := by
  exact (he.neg_eq a b).symm

def inducedForm (e : BilinForm R M) (a b a' b' : M) : R :=
  e a b' + e b a'

theorem induced_diagonal (e : BilinForm R M) (he : e.IsAlt) (a b : M) :
    inducedForm e a b a b = 0 := by
  dsimp [inducedForm]
  rw [alt_swap e he a b]
  ring

@[ext]
structure Heis (R M : Type*) where
  a : M
  b : M
  z : R

def hmul (e : BilinForm R M) (v w : Heis R M) : Heis R M :=
  ⟨v.a + w.a, v.b + w.b, v.z + w.z + e v.a w.b⟩

def hinv (e : BilinForm R M) (v : Heis R M) : Heis R M :=
  ⟨-v.a, -v.b, -v.z + e v.a v.b⟩

theorem hmul_assoc (e : BilinForm R M) (u v w : Heis R M) :
    hmul e (hmul e u v) w = hmul e u (hmul e v w) := by
  ext <;> simp [hmul, BilinForm.add_right] <;> abel

theorem hmul_inv (e : BilinForm R M) (v : Heis R M) :
    hmul e v (hinv e v) = ⟨0, 0, 0⟩ := by
  ext <;> simp [hmul, hinv, BilinForm.neg_right]

theorem kernel_conjugation (e : BilinForm R M) (he : e.IsAlt)
    (v : Heis R M) (a b : M) (s d : R) :
    hmul e (hmul e v ⟨s • a, s • b, d⟩) (hinv e v) =
      ⟨s • a, s • b, d + s * inducedForm e v.a v.b a b⟩ := by
  ext
  · simp [hmul, hinv]
  · simp [hmul, hinv]
  · simp only [hmul, hinv, BilinForm.add_left, BilinForm.neg_right,
      BilinForm.smul_left, BilinForm.smul_right, inducedForm]
    rw [alt_swap e he a v.b]
    ring

theorem square_zero_kernel_mul (e : BilinForm R M) (s : R) (hs : s * s = 0)
    (a b a' b' : M) (d d' : R) :
    hmul e ⟨s • a, s • b, d⟩ ⟨s • a', s • b', d'⟩ =
      ⟨s • (a + a'), s • (b + b'), d + d'⟩ := by
  ext
  · simp [hmul, smul_add]
  · simp [hmul, smul_add]
  · simp only [hmul, BilinForm.smul_left, BilinForm.smul_right]
    linear_combination (e a b') * hs

def cLift (e : BilinForm R M) (C : M →ₗ[R] M) (v : Heis R M) : Heis R M :=
  ⟨C v.b, C v.a, -v.z + e v.a v.b⟩

theorem cLift_mul (e : BilinForm R M) (he : e.IsAlt) (C : M →ₗ[R] M)
    (hC : ∀ a b, e (C a) (C b) = -e a b) (v w : Heis R M) :
    cLift e C (hmul e v w) = hmul e (cLift e C v) (cLift e C w) := by
  ext
  · simp [cLift, hmul]
  · simp [cLift, hmul]
  · simp only [cLift, hmul, BilinForm.add_left, BilinForm.add_right, hC]
    have h := alt_swap e he v.b w.a
    linear_combination h

theorem cLift_involution (e : BilinForm R M) (he : e.IsAlt) (C : M →ₗ[R] M)
    (hC : ∀ a b, e (C a) (C b) = -e a b)
    (hCC : ∀ a, C (C a) = a) (v : Heis R M) :
    cLift e C (cLift e C v) = v := by
  ext
  · exact hCC v.a
  · exact hCC v.b
  · simp only [cLift, hC]
    have h := alt_swap e he v.a v.b
    linear_combination -h

theorem inertia_graph_fixed (e : BilinForm R M) (he : e.IsAlt)
    (d u : R) (hdu : d * u = 1) (a : M) (z : R) :
    (⟨d • (u • a), u • a, z - e a (u • a)⟩ : Heis R M) =
      ⟨a, u • a, z⟩ := by
  ext <;> simp [smul_smul, hdu, he.self_eq_zero]

theorem regular_scalar_cancel (s r k : R)
    (hs : ∀ t : R, s * t = 0 → t = 0)
    (h : s * r = (s * s) * k) :
    r = s * k := by
  have hz : s * (r - s * k) = 0 := by
    linear_combination h
  exact sub_eq_zero.mp (hs _ hz)

section Compact

variable {G2 G3 L1 L2 A0 A2 : Type*}
  [AddCommGroup G2] [Module R G2] [AddCommGroup G3] [Module R G3]
  [AddCommGroup L1] [Module R L1] [AddCommGroup L2] [Module R L2]
  [AddCommGroup A0] [Module R A0] [AddCommGroup A2] [Module R A2]

def compactD (dG : G2 →ₗ[R] G3) (dL : L1 →ₗ[R] L2)
    (loc : G2 →ₗ[R] L2) (w : G2 × L1) : G3 × L2 :=
  (dG w.1, loc w.1 - dL w.2)

theorem compact_boundary_from_defects
    (dG : G2 →ₗ[R] G3) (dL : L1 →ₗ[R] L2) (loc : G2 →ₗ[R] L2)
    (s : R) (u : G3) (p a b deltaU : L2) (delta : G2) (h ell : L1)
    (hglobal : dG delta = -(s • u))
    (hlocal : loc delta = deltaU - s • a + dL ell + s • b)
    (hunram : deltaU + s • p = dL h) :
    compactD dG dL loc (-delta, -(h + ell)) =
      (s • u, s • (p + a - b)) := by
  have hU : deltaU = dL h - s • p := eq_sub_of_add_eq hunram
  apply Prod.ext
  · simp [compactD, hglobal]
  · simp only [compactD, map_neg, map_add, hlocal, hU, smul_add, smul_sub]
    abel

theorem compact_diagonal_vanishes
    (dG : G2 →ₗ[R] G3) (dL : L1 →ₗ[R] L2) (loc : G2 →ₗ[R] L2)
    (s : R) (u : G3) (p a b deltaU : L2) (delta : G2) (h ell : L1)
    (hglobal : dG delta = -(s • u))
    (hlocal : loc delta = deltaU - s • a + dL ell + s • b)
    (hunram : deltaU + s • p = dL h)
    (tr : G3 × L2 →ₗ[R] A2) (j : A0 →ₗ[R] A2)
    (hj : Function.Injective j) (t : A0)
    (hboundary : ∀ w, tr (compactD dG dL loc w) = 0)
    (htrace : tr (s • u, s • (p + a - b)) = j t) :
    t = 0 := by
  apply hj
  rw [map_zero, ← htrace]
  rw [← compact_boundary_from_defects dG dL loc s u p a b deltaU delta h ell
    hglobal hlocal hunram]
  exact hboundary _

end Compact

theorem local_primitive_leibniz {L2 L3 : Type*}
    [AddCommGroup L2] [Module R L2] [AddCommGroup L3] [Module R L3]
    (d : L2 →ₗ[R] L3) (p a b : L2) (u0 u1 u2 : L3)
    (hp : d p = u0) (ha : d a = u1) (hb : d b = -u2) :
    d (p + a - b) = u0 + u1 + u2 := by
  simp [map_add, map_sub, hp, ha, hb]

def hyperProj (b : BilinForm R M) (x y z : M) : M :=
  (b z y) • x - (b z x) • y

theorem hyperbolic_residual_orthogonal (b : BilinForm R M) (hb : b.IsAlt)
    (x y : M) (hxy : b x y = 1) (z : M) :
    b (z - hyperProj b x y z) x = 0 ∧
      b (z - hyperProj b x y z) y = 0 := by
  have hyx : b y x = -1 := by rw [alt_swap b hb x y, hxy]
  constructor <;>
    simp [hyperProj, hb.self_eq_zero, hxy, hyx]

theorem hyperbolic_plane_pairing (b : BilinForm R M) (hb : b.IsAlt)
    (x y : M) (hxy : b x y = 1) (a c d f : R) :
    b (a • x + c • y) (d • x + f • y) = a * f - c * d := by
  have hyx : b y x = -1 := by rw [alt_swap b hb x y, hxy]
  simp [BilinForm.add_right, hb.self_eq_zero, hxy, hyx]
  ring

theorem hyperbolic_independent (b : BilinForm R M) (hb : b.IsAlt)
    (x y : M) (hxy : b x y = 1) (a c : R) (h : a • x + c • y = 0) :
    a = 0 ∧ c = 0 := by
  have hyx : b y x = -1 := by rw [alt_swap b hb x y, hxy]
  have h1 := congrArg (fun z => b z y) h
  have h2 := congrArg (fun z => b z x) h
  simp [hb.self_eq_zero, hxy] at h1
  simp [hb.self_eq_zero, hyx] at h2
  exact ⟨h1, h2⟩

theorem bockstein_radical_kernel {N : Type*}
    [AddCommGroup N] [Module R N]
    (b : BilinForm R M) (hb : b.IsAlt)
    (P : M →ₗ[R] N →ₗ[R] R) (beta : M →ₗ[R] N)
    (hform : ∀ x y, b x y = P x (beta y))
    (hsep : ∀ v : N, (∀ x, P x v = 0) → v = 0) (x : M) :
    (∀ y, b x y = 0) ↔ beta x = 0 := by
  constructor
  · intro hx
    apply hsep
    intro y
    rw [← hform, alt_swap b hb x y, hx, neg_zero]
  · intro hx y
    rw [alt_swap b hb y x, hform, hx, map_zero, neg_zero]

end ConjugateBockstein
