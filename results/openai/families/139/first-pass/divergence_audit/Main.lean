import Lean.Elab.Tactic.Omega

namespace DivergenceAudit

structure State where
  a : Nat
  e : Nat
  h : Nat
  v : Nat
  deriving DecidableEq, Repr

def initial (n : Nat) : State := ⟨n, 0, 0, 0⟩

inductive Step : State → State → Prop
  | primary (a e h v : Nat) :
      Step ⟨a + 1, e, h, v⟩ ⟨a, e + 1, h, v⟩
  | hessian (a e h v : Nat) :
      Step ⟨a + 1, e, h, v⟩ ⟨a, e, h + 1, v⟩
  | birth (a e h v : Nat) :
      Step ⟨a + 2, e, h, v⟩ ⟨a, e, h, v + 1⟩

theorem Step.conservation {x y : State} (step : Step x y) :
    y.a + y.e + y.h + 2 * y.v = x.a + x.e + x.h + 2 * x.v := by
  cases step <;> dsimp <;> omega

theorem Step.count_increment {x y : State} (step : Step x y) :
    y.e + y.h + y.v = x.e + x.h + x.v + 1 := by
  cases step <;> dsimp <;> omega

theorem Step.adjoints_decrease {x y : State} (step : Step x y) :
    y.a + 1 ≤ x.a := by
  cases step <;> dsimp <;> omega

inductive History (n : Nat) : Nat → State → Prop
  | start : History n 0 (initial n)
  | next {depth : Nat} {x y : State} :
      History n depth x → Step x y → History n (depth + 1) y

theorem History.resource_invariant {n depth : Nat} {r : State}
    (history : History n depth r) :
    r.a + r.e + r.h + 2 * r.v = n := by
  induction history with
  | start => simp [initial]
  | next history step ih => exact step.conservation.trans ih

theorem History.depth_identity {n depth : Nat} {r : State}
    (history : History n depth r) :
    depth = r.e + r.h + r.v := by
  induction history with
  | start => simp [initial]
  | next history step ih =>
      have increment := step.count_increment
      omega

theorem History.depth_budget {n depth : Nat} {r : State}
    (history : History n depth r) :
    depth + r.a + r.v = n := by
  have conserved := history.resource_invariant
  have counted := history.depth_identity
  omega

theorem History.depth_le {n depth : Nat} {r : State}
    (history : History n depth r) :
    depth ≤ n := by
  have budget := history.depth_budget
  omega

theorem History.resource_bounds {n depth : Nat} {r : State}
    (history : History n depth r) :
    r.e + r.h ≤ n ∧ r.e + r.h + r.v ≤ n ∧ r.a ≤ n ∧ r.v ≤ n := by
  have conserved := history.resource_invariant
  omega

theorem History.terminal_conservation {n depth : Nat} {r : State}
    (history : History n depth r) (terminal : r.a = 0) :
    r.e + r.h + 2 * r.v = n := by
  have conserved := history.resource_invariant
  omega

theorem History.terminal_depth_identity {n depth : Nat} {r : State}
    (history : History n depth r) (terminal : r.a = 0) :
    depth + r.v = n := by
  have budget := history.depth_budget
  omega

theorem History.primary_exponent_le {n depth : Nat} {r : State}
    (history : History n depth r) (k j : Nat) :
    n * (k + j) + r.e + r.h ≤ n * (k + j + 1) := by
  have bounded := history.resource_bounds
  simp only [Nat.mul_add, Nat.mul_one]
  omega

theorem History.dimension_exponent_le {n depth : Nat} {r : State}
    (history : History n depth r) (j : Nat) :
    n * (j + 1) + r.e + r.h + r.v ≤ 2 * n * (j + 1) := by
  have bounded := history.resource_bounds
  have base : n ≤ n * (j + 1) := by
    have multiplied := Nat.mul_le_mul_left n (show 1 ≤ j + 1 by omega)
    simpa only [Nat.mul_one] using multiplied
  calc
    n * (j + 1) + r.e + r.h + r.v ≤
        n * (j + 1) + n * (j + 1) := by omega
    _ = (n + n) * (j + 1) := (Nat.add_mul n n (j + 1)).symm
    _ = 2 * n * (j + 1) := by
      congr 1
      omega

inductive Target (n : Nat) (r : State) where
  | primary : Fin n → Target n r
  | hessian : Fin r.v → Target n r
  | pair : Fin (r.a - 1) → Target n r

def nextState {n : Nat} {r : State} : Target n r → State
  | .primary _ => ⟨r.a - 1, r.e + 1, r.h, r.v⟩
  | .hessian _ => ⟨r.a - 1, r.e, r.h + 1, r.v⟩
  | .pair _ => ⟨r.a - 2, r.e, r.h, r.v + 1⟩

theorem target_is_step {n : Nat} {r : State}
    (active : 0 < r.a) (target : Target n r) :
    Step r (nextState target) := by
  cases r with
  | mk a e h v =>
      change 0 < a at active
      cases target with
      | primary i =>
          have restored : a - 1 + 1 = a := by omega
          simpa only [nextState, restored] using (Step.primary (a - 1) e h v)
      | hessian i =>
          have restored : a - 1 + 1 = a := by omega
          simpa only [nextState, restored] using (Step.hessian (a - 1) e h v)
      | pair i =>
          have index_bound := i.isLt
          change i.val < a - 1 at index_bound
          have restored : a - 2 + 2 = a := by omega
          simpa only [nextState, restored] using (Step.birth (a - 2) e h v)

def targetCount (n : Nat) (r : State) : Nat := n + r.v + (r.a - 1)

theorem History.target_count_le {n depth : Nat} {r : State}
    (history : History n depth r) :
    targetCount n r ≤ 3 * n := by
  have bounded := history.resource_bounds
  unfold targetCount
  omega

def sumFin : (m : Nat) → (Fin m → Nat) → Nat
  | 0, _ => 0
  | m + 1, f => f ⟨0, Nat.zero_lt_succ m⟩ + sumFin m (fun i => f i.succ)

theorem sumFin_le : ∀ (m b : Nat) (f : Fin m → Nat),
    (∀ i, f i ≤ b) → sumFin m f ≤ m * b
  | 0, b, f, bounded => by simp [sumFin]
  | m + 1, b, f, bounded => by
      have head := bounded ⟨0, Nat.zero_lt_succ m⟩
      have tail := sumFin_le m b (fun i => f i.succ) (fun i => bounded i.succ)
      simp only [sumFin, Nat.succ_mul]
      omega

theorem sumFin_const (m b : Nat) :
    sumFin m (fun _ => b) = m * b := by
  induction m with
  | zero => simp [sumFin]
  | succ m ih =>
      simp only [sumFin, Nat.succ_mul, ih]
      omega

def targetSum {n : Nat} {r : State} (f : Target n r → Nat) : Nat :=
  sumFin n (fun i => f (.primary i)) +
    sumFin r.v (fun i => f (.hessian i)) +
    sumFin (r.a - 1) (fun i => f (.pair i))

theorem targetSum_const {n : Nat} {r : State} (b : Nat) :
    targetSum (n := n) (r := r) (fun _ => b) = targetCount n r * b := by
  simp only [targetSum, sumFin_const, targetCount, Nat.add_mul]

theorem targetSum_le {n : Nat} {r : State}
    (b : Nat) (f : Target n r → Nat) (bounded : ∀ target, f target ≤ b) :
    targetSum f ≤ targetCount n r * b := by
  have primary := sumFin_le n b (fun i => f (.primary i))
    (fun i => bounded (.primary i))
  have hessian := sumFin_le r.v b (fun i => f (.hessian i))
    (fun i => bounded (.hessian i))
  have pair := sumFin_le (r.a - 1) b (fun i => f (.pair i))
    (fun i => bounded (.pair i))
  simp only [targetSum, targetCount, Nat.add_mul]
  omega

inductive Expansion (n : Nat) : State → Type
  | terminal (r : State) (done : r.a = 0) : Expansion n r
  | branch (r : State) (active : 0 < r.a)
      (children : (target : Target n r) → Expansion n (nextState target)) :
      Expansion n r

def fullExpansion (n : Nat) (r : State) : Expansion n r := by
  by_cases terminal : r.a = 0
  · exact .terminal r terminal
  · have active : 0 < r.a := by omega
    exact .branch r active (fun target => fullExpansion n (nextState target))
termination_by r.a
decreasing_by
  have decreased := (target_is_step active target).adjoints_decrease
  omega

def Expansion.leaves {n : Nat} : {r : State} → Expansion n r → Nat
  | _, .terminal _ _ => 1
  | _, .branch _ _ children =>
      targetSum (fun target => Expansion.leaves (children target))

theorem Expansion.leaves_le {n : Nat} {r : State} (tree : Expansion n r) :
    ∀ {depth : Nat}, History n depth r → tree.leaves ≤ (3 * n) ^ r.a := by
  induction tree with
  | terminal r done =>
      intro depth history
      simp [Expansion.leaves, done]
  | branch r active children ih =>
      intro depth history
      have positive : 0 < 3 * n := by
        have bounded := history.resource_bounds
        omega
      have child_bounds : ∀ target : Target n r,
          (children target).leaves ≤ (3 * n) ^ (r.a - 1) := by
        intro target
        have legal := target_is_step active target
        have next_history := History.next history legal
        have child_bound := ih target next_history
        have decreased := legal.adjoints_decrease
        exact Nat.le_trans child_bound (Nat.pow_le_pow_right positive (by omega))
      have summed := targetSum_le ((3 * n) ^ (r.a - 1))
        (fun target => (children target).leaves) child_bounds
      have restored : r.a - 1 + 1 = r.a := by omega
      calc
        (Expansion.branch r active children).leaves ≤
            targetCount n r * (3 * n) ^ (r.a - 1) := summed
        _ ≤ (3 * n) * (3 * n) ^ (r.a - 1) :=
          Nat.mul_le_mul_right _ history.target_count_le
        _ = (3 * n) ^ (r.a - 1 + 1) := by
          rw [Nat.pow_succ]
          exact Nat.mul_comm _ _
        _ = (3 * n) ^ r.a := by rw [restored]

theorem root_leaf_bound (n : Nat) (tree : Expansion n (initial n)) :
    tree.leaves ≤ (3 * n) ^ n := by
  simpa only [initial] using tree.leaves_le (History.start (n := n))

theorem full_expansion_leaf_bound (n : Nat) :
    (fullExpansion n (initial n)).leaves ≤ (3 * n) ^ n :=
  root_leaf_bound n (fullExpansion n (initial n))

theorem high_trace_moment_core (s k j depth : Nat) (r : State)
    (history : History (2 * s) depth r) (terminal : r.a = 0) :
    r.e + r.h + 2 * r.v = 2 * s ∧
      (2 * s) * (k + j) + r.e + r.h ≤ (2 * s) * (k + j + 1) ∧
      (2 * s) * (j + 1) + r.e + r.h + r.v ≤ 2 * (2 * s) * (j + 1) ∧
      depth ≤ 2 * s :=
  ⟨history.terminal_conservation terminal, history.primary_exponent_le k j,
    history.dimension_exponent_le j, history.depth_le⟩

end DivergenceAudit
