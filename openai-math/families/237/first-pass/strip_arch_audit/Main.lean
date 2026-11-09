import Mathlib

namespace StripArchAudit

section SourceEquations

variable {K V0 V1 W0 W1 : Type*}
variable [Ring K]
variable [AddCommGroup V0] [AddCommGroup V1]
variable [AddCommGroup W0] [AddCommGroup W1]
variable [Module K V0] [Module K V1] [Module K W0] [Module K W1]

theorem projected_source
    (tx : V1 →ₗ[K] V1) (tr : W1 →ₗ[K] W1)
    (bx : V0 →ₗ[K] V1) (br : W0 →ₗ[K] W1)
    (q0 : V0 →ₗ[K] W0) (q1 : V1 →ₗ[K] W1)
    (px : V0) (pr : W0) (hx : V1) (hr : W1)
    (hp : q0 px = pr)
    (hx_eq : hx - tx hx = bx px)
    (hr_eq : hr - tr hr = br pr)
    (htransfer : forall v, q1 (tx v) = tr (q1 v))
    (hinsertion : forall p, q1 (bx p) = br (q0 p))
    (hunique : Function.Injective (fun w : W1 => w - tr w)) :
    q1 hx = hr := by
  apply hunique
  calc
    q1 hx - tr (q1 hx) = q1 (hx - tx hx) := by rw [map_sub, htransfer]
    _ = q1 (bx px) := congrArg q1 hx_eq
    _ = br (q0 px) := hinsertion px
    _ = br pr := by rw [hp]
    _ = hr - tr hr := hr_eq.symm

theorem inserted_source
    (tx : V1 →ₗ[K] V1) (tr : W1 →ₗ[K] W1)
    (bx : V0 →ₗ[K] V1) (br : W0 →ₗ[K] W1)
    (s0 : W0 →ₗ[K] V0) (s1 : W1 →ₗ[K] V1)
    (px : V0) (pr : W0) (hx : V1) (hr : W1)
    (hp : s0 pr = px)
    (hx_eq : hx - tx hx = bx px)
    (hr_eq : hr - tr hr = br pr)
    (htransfer : forall w, tx (s1 w) = s1 (tr w))
    (hinsertion : forall p, bx (s0 p) = s1 (br p))
    (hunique : Function.Injective (fun v : V1 => v - tx v)) :
    hx = s1 hr := by
  apply hunique
  calc
    hx - tx hx = bx px := hx_eq
    _ = bx (s0 pr) := by rw [hp]
    _ = s1 (br pr) := hinsertion pr
    _ = s1 (hr - tr hr) := congrArg s1 hr_eq.symm
    _ = s1 hr - tx (s1 hr) := by rw [map_sub, htransfer]

end SourceEquations

theorem adjoint_pairing_reduction
    {L R Lred Rred S : Type*}
    (insert : Rred -> R) (project : L -> Lred)
    (glue : L -> R -> S) (glueRed : Lred -> Rred -> S)
    (hadjoint : forall l r, glue l (insert r) = glueRed (project l) r)
    (left : L) (right : R) (leftRed : Lred) (rightRed : Rred)
    (hleft : project left = leftRed) (hright : right = insert rightRed) :
    glue left right = glueRed leftRed rightRed := by
  rw [hright, hadjoint, hleft]

theorem arch_interpolation
    {F : Type*} [Field F]
    (N : Nat) (hN : 2 <= N)
    (p q : Polynomial F) (nodes : Finset F)
    (hp : p.natDegree <= 2 * N)
    (hq : q.natDegree <= 2 * N)
    (hcard : 4 * N - 3 <= nodes.card)
    (heval : forall x, x ∈ nodes -> p.eval x = q.eval x) :
    p = q := by
  apply Polynomial.eq_of_natDegree_lt_card_of_eval_eq' p q nodes heval
  have hmax : max p.natDegree q.natDegree <= 2 * N := max_le hp hq
  have hstrict : 2 * N < 4 * N - 3 := by omega
  exact lt_of_le_of_lt hmax (lt_of_lt_of_le hstrict hcard)

end StripArchAudit
