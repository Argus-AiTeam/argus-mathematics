import Mathlib

namespace RapidLattice

inductive Move where
  | right
  | left
  | stay

structure Instruction (b : ℕ) where
  nextState : Fin b
  writeDigit : Fin b
  move : Move

def pack (b d L R s : ℕ) : ℕ :=
  L + b ^ d * (R + b ^ d * s)

def period (b d : ℕ) : ℕ := b ^ (2 * d + 1)

def stackUpdate (b L R w : ℕ) : Move → ℕ × ℕ
  | .right => (w + b * L, R / b)
  | .left => (L / b, L % b + b * w + b * (R - R % b))
  | .stay => (L, R - R % b + w)

def step (b d c : ℕ) (table : ℕ → ℕ → Option (Instruction b)) : ℕ :=
  let L := c % b ^ d
  let R := c / b ^ d % b ^ d
  let s := c / (b ^ d * b ^ d)
  match table s (R % b) with
  | none => 0
  | some i =>
      let out := stackUpdate b L R i.writeDigit.val i.move
      pack b (d + 2) out.1 out.2 i.nextState.val

def address (b d : ℕ) (table : ℕ → ℕ → Option (Instruction b)) (j : ℤ) : ℕ :=
  step b d (j % (period b d : ℤ)).toNat table

def haltAddress (b d : ℕ) (halt : ℕ → Bool) (j : ℤ) : Bool :=
  halt ((j % (period b d : ℤ)).toNat / (b ^ d * b ^ d))

theorem period_eq (b d : ℕ) :
    period b d = b ^ d * (b ^ d * b) := by
  unfold period
  rw [show 2 * d + 1 = (d + d) + 1 by omega, pow_succ, pow_add]
  ring

theorem push_bound (b a t B : ℕ) (ha : a < b) (ht : t < B) :
    a + b * t < b * B := by
  have h := Nat.mul_le_mul_left b (Nat.succ_le_of_lt ht)
  nlinarith

theorem power_growth (b e : ℕ) (hb : 1 ≤ b) : b ^ e ≤ b ^ (e + 1) := by
  simpa only [pow_succ, Nat.mul_one] using Nat.mul_le_mul_left (b ^ e) hb

theorem stack_sub (b R : ℕ) : R - R % b = b * (R / b) := by
  have h := Nat.mod_add_div R b
  omega

theorem push_mod (b a t : ℕ) (ha : a < b) :
    (a + b * t) % b = a := by
  simp [Nat.add_mod, Nat.mod_eq_of_lt ha]

theorem push_div (b a t : ℕ) (hb : 0 < b) (ha : a < b) :
    (a + b * t) / b = t := by
  simpa [Nat.div_eq_of_lt ha] using Nat.add_mul_div_left a t hb

theorem manuscript_stack_identities (b L R w : ℕ) (hb : 0 < b) :
    stackUpdate b L R w .right = (w + b * L, (R - R % b) / b) ∧
    stackUpdate b L R w .left =
      (L / b, L % b + b * w + b ^ 2 * (R / b)) ∧
    stackUpdate b L R w .stay = (L, w + b * (R / b)) := by
  simp only [stackUpdate, stack_sub]
  constructor
  · simp [Nat.mul_div_right, hb]
  · constructor <;> congr 1 <;> ring

theorem stacks_bounds (b d L R w : ℕ) (hb : 2 ≤ b) (hd : 1 ≤ d)
    (hL : L < b ^ d) (hR : R < b ^ d) (hw : w < b) (m : Move) :
    (stackUpdate b L R w m).1 < b ^ (d + 1) ∧
    (stackUpdate b L R w m).2 < b ^ (d + 1) := by
  have hbpos : 0 < b := by omega
  obtain ⟨e, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : d ≠ 0)
  have htail : R / b < b ^ e := by
    apply (Nat.div_lt_iff_lt_mul hbpos).2
    simpa [pow_succ, Nat.mul_comm] using hR
  have hwrite : w + b * (R / b) < b ^ (e + 1) := by
    simpa [pow_succ, Nat.mul_comm] using push_bound b w (R / b) (b ^ e) hw htail
  have hB : b ^ (e + 1) ≤ b ^ (e + 1 + 1) :=
    power_growth b (e + 1) (by omega)
  have hLdiv : L / b < b ^ (e + 1) :=
    lt_of_le_of_lt (Nat.div_le_self L b) hL
  have hRdiv : R / b < b ^ (e + 1) :=
    lt_of_le_of_lt (Nat.div_le_self R b) hR
  have hright : w + b * L < b ^ (e + 1 + 1) := by
    simpa [pow_succ, Nat.mul_comm] using
      push_bound b w L (b ^ (e + 1)) hw hL
  have hleft : L % b + b * w + b * (R - R % b) < b ^ (e + 1 + 1) := by
    have h := push_bound b (L % b) (w + b * (R / b)) (b ^ (e + 1))
      (Nat.mod_lt L hbpos) hwrite
    calc
      L % b + b * w + b * (R - R % b) =
          L % b + b * (w + b * (R / b)) := by rw [stack_sub]; ring
      _ < b * b ^ (e + 1) := h
      _ = b ^ (e + 1 + 1) := by
        simpa [Nat.mul_comm] using (pow_succ b (e + 1)).symm
  cases m with
  | right => exact ⟨hright, lt_of_lt_of_le hRdiv hB⟩
  | left => exact ⟨lt_of_lt_of_le hLdiv hB, hleft⟩
  | stay =>
      constructor
      · exact lt_of_lt_of_le hL hB
      · simp only [stackUpdate, stack_sub]
        exact lt_of_lt_of_le (by simpa [Nat.add_comm] using hwrite) hB

theorem pack_range (b d L R s : ℕ)
    (hL : L < b ^ d) (hR : R < b ^ d) (hs : s < b) :
    pack b d L R s < period b d := by
  have h := push_bound (b ^ d) R s b hR hs
  have h' := push_bound (b ^ d) L (R + b ^ d * s) (b ^ d * b) hL h
  simpa [pack, period_eq] using h'

theorem pack_decode (b d L R s : ℕ) (hb : 0 < b)
    (hL : L < b ^ d) (hR : R < b ^ d) :
    pack b d L R s % b ^ d = L ∧
    pack b d L R s / b ^ d % b ^ d = R ∧
    pack b d L R s / (b ^ d * b ^ d) = s := by
  have hB : 0 < b ^ d := pow_pos hb d
  have hdiv := push_div (b ^ d) L (R + b ^ d * s) hB hL
  constructor
  · exact push_mod (b ^ d) L (R + b ^ d * s) hL
  · constructor
    · rw [pack, hdiv]
      exact push_mod (b ^ d) R s hR
    · rw [← Nat.div_div_eq_div_mul, pack, hdiv]
      exact push_div (b ^ d) R s hB hR

theorem step_range (b d c : ℕ) (hb : 2 ≤ b) (hd : 1 ≤ d)
    (table : ℕ → ℕ → Option (Instruction b)) :
    step b d c table < period b (d + 2) := by
  have hB : 0 < b ^ d := pow_pos (by omega : 0 < b) d
  have hP : 0 < period b (d + 2) := pow_pos (by omega : 0 < b) _
  have hmono : b ^ (d + 1) ≤ b ^ (d + 2) := by
    simpa [Nat.add_assoc] using power_growth b (d + 1) (by omega)
  cases ht : table (c / (b ^ d * b ^ d)) (c / b ^ d % b ^ d % b) with
  | none => simpa [step, ht] using hP
  | some i =>
      have h := stacks_bounds b d (c % b ^ d) (c / b ^ d % b ^ d)
        i.writeDigit.val hb hd (Nat.mod_lt c hB) (Nat.mod_lt _ hB)
        i.writeDigit.isLt i.move
      have hout := pack_range b (d + 2)
        (stackUpdate b (c % b ^ d) (c / b ^ d % b ^ d) i.writeDigit.val i.move).1
        (stackUpdate b (c % b ^ d) (c / b ^ d % b ^ d) i.writeDigit.val i.move).2
        i.nextState.val (lt_of_lt_of_le h.1 hmono) (lt_of_lt_of_le h.2 hmono)
        i.nextState.isLt
      simpa [step, ht] using hout

theorem residue_shift (P j m : ℤ) : (j + m * P) % P = j % P := by
  simp [Int.add_emod]

theorem address_periodic (b d : ℕ) (table : ℕ → ℕ → Option (Instruction b))
    (j m : ℤ) :
    address b d table (j + m * (period b d : ℤ)) = address b d table j := by
  simp only [address, residue_shift]

theorem halt_periodic (b d : ℕ) (halt : ℕ → Bool) (j m : ℤ) :
    haltAddress b d halt (j + m * (period b d : ℤ)) = haltAddress b d halt j := by
  simp only [haltAddress, residue_shift]

theorem address_range (b d : ℕ) (hb : 2 ≤ b) (hd : 1 ≤ d)
    (table : ℕ → ℕ → Option (Instruction b)) (j : ℤ) :
    address b d table j < period b (d + 2) :=
  step_range b d _ hb hd table

theorem address_of_true_code (b d L R s : ℕ) (hb : 2 ≤ b)
    (hL : L < b ^ d) (hR : R < b ^ d) (hs : s < b)
    (table : ℕ → ℕ → Option (Instruction b)) (m : ℤ) :
    address b d table ((pack b d L R s : ℤ) + m * (period b d : ℤ)) =
    match table s (R % b) with
    | none => 0
    | some i =>
        pack b (d + 2) (stackUpdate b L R i.writeDigit.val i.move).1
          (stackUpdate b L R i.writeDigit.val i.move).2 i.nextState.val := by
  have hp := pack_range b d L R s hL hR hs
  have hmod : (pack b d L R s : ℤ) % (period b d : ℤ) = pack b d L R s :=
    Int.emod_eq_of_lt (by omega) (by exact_mod_cast hp)
  have hdecode := pack_decode b d L R s (by omega) hL hR
  simp only [address, residue_shift, hmod, Int.toNat_natCast, step,
    hdecode.1, hdecode.2.1, hdecode.2.2]

theorem power_dvd (b p q : ℕ) (h : p ≤ q) :
    (b : ℤ) ^ p ∣ (b : ℤ) ^ q := by
  refine ⟨(b : ℤ) ^ (q - p), ?_⟩
  rw [← pow_add]
  congr 1
  omega

theorem history_residue (b p n : ℕ) (K : ℕ → ℕ) (c : ℕ → ℤ) (m : ℤ)
    (hp : p ≤ K n) (hg : ∀ i < n, p ≤ K n - K i) :
    (c n + (∑ i ∈ Finset.range n, c i * (b : ℤ) ^ (K n - K i)) +
      m * (b : ℤ) ^ K n) % (b : ℤ) ^ p = c n % (b : ℤ) ^ p := by
  have hs : (b : ℤ) ^ p ∣
      ∑ i ∈ Finset.range n, c i * (b : ℤ) ^ (K n - K i) := by
    apply Finset.dvd_sum
    intro i hi
    rcases power_dvd b p (K n - K i) (hg i (Finset.mem_range.mp hi)) with ⟨t, ht⟩
    refine ⟨c i * t, ?_⟩
    rw [ht]
    ring
  have hm : (b : ℤ) ^ p ∣ m * (b : ℤ) ^ K n := by
    rcases power_dvd b p (K n) hp with ⟨t, ht⟩
    refine ⟨m * t, ?_⟩
    rw [ht]
    ring
  rw [Int.add_emod, Int.emod_eq_zero_of_dvd hm, add_zero, Int.emod_emod,
    Int.add_emod, Int.emod_eq_zero_of_dvd hs, add_zero, Int.emod_emod]

theorem scale_lower (K : ℕ → ℕ) (p0 : ℕ) (h0 : p0 + 10 ≤ K 0)
    (hd : ∀ n, 2 * K n ≤ K (n + 1)) (n : ℕ) :
    p0 + 4 * n + 10 ≤ K n := by
  induction n with
  | zero => simpa using h0
  | succ n ih =>
      have h := hd n
      omega

theorem scale_monotone (K : ℕ → ℕ) (hd : ∀ n, 2 * K n ≤ K (n + 1)) :
    Monotone K := by
  apply monotone_nat_of_le_succ
  intro n
  have h := hd n
  omega

theorem scale_gap (K : ℕ → ℕ) (p0 : ℕ) (h0 : p0 + 10 ≤ K 0)
    (hd : ∀ n, 2 * K n ≤ K (n + 1)) (i n : ℕ) (hi : i < n) :
    p0 + 4 * n + 6 ≤ K n - K i := by
  cases n with
  | zero => omega
  | succ n =>
      have hm := scale_monotone K hd (show i ≤ n by omega)
      have hl := scale_lower K p0 h0 hd n
      have hh := hd n
      omega

theorem plateau_margin (K : ℕ → ℕ) (p0 : ℕ) (h0 : p0 + 10 ≤ K 0)
    (hd : ∀ n, 2 * K n ≤ K (n + 1)) (n : ℕ) :
    p0 + 4 * (n + 1) + K n + 6 ≤ K (n + 1) := by
  have hl := scale_lower K p0 h0 hd n
  have hh := hd n
  omega

theorem derivative_margin (K : ℕ → ℕ) (p0 : ℕ) (h0 : p0 + 10 ≤ K 0)
    (hd : ∀ n, 2 * K n ≤ K (n + 1)) (k n : ℕ)
    (hr : (k + 2) * K n ≤ K (n + 1)) :
    p0 + 4 * (n + 1) + k * K n + K n + 6 ≤ K (n + 1) := by
  have hl := scale_lower K p0 h0 hd n
  nlinarith

theorem scheduled_history (K : ℕ → ℕ) (p0 : ℕ) (h0 : p0 + 10 ≤ K 0)
    (hd : ∀ n, 2 * K n ≤ K (n + 1)) (b n : ℕ) (c : ℕ → ℤ) (m : ℤ) :
    (c n + (∑ i ∈ Finset.range n, c i * (b : ℤ) ^ (K n - K i)) +
      m * (b : ℤ) ^ K n) % (b : ℤ) ^ (p0 + 4 * n) =
        c n % (b : ℤ) ^ (p0 + 4 * n) := by
  apply history_residue
  · have h := scale_lower K p0 h0 hd n
    omega
  · intro i hi
    have h := scale_gap K p0 h0 hd i n hi
    omega

def publishedK (p0 n : ℕ) : ℕ := (p0 + 10) * 2 ^ (n * (n + 1))

theorem published_recurrence (p0 n : ℕ) :
    publishedK p0 (n + 1) = 2 ^ (2 * n + 2) * publishedK p0 n := by
  unfold publishedK
  rw [show (n + 1) * (n + 1 + 1) = (2 * n + 2) + n * (n + 1) by ring, pow_add]
  ring

theorem linear_le_two_power (n : ℕ) : n + 1 ≤ 2 ^ n := by
  induction n with
  | zero => norm_num
  | succ n ih =>
      rw [pow_succ]
      omega

theorem published_doubling (p0 n : ℕ) :
    2 * publishedK p0 n ≤ publishedK p0 (n + 1) := by
  rw [published_recurrence]
  have h := linear_le_two_power (2 * n + 2)
  exact Nat.mul_le_mul_right _ (by omega : 2 ≤ 2 ^ (2 * n + 2))

theorem published_all_orders (p0 k n : ℕ) (hkn : k ≤ n) :
    p0 + 4 * (n + 1) + k * publishedK p0 n + publishedK p0 n + 6 ≤
      publishedK p0 (n + 1) := by
  apply derivative_margin (publishedK p0) p0 (by simp [publishedK])
    (published_doubling p0) k n
  rw [published_recurrence]
  have h := linear_le_two_power (2 * n + 2)
  exact Nat.mul_le_mul_right _ (by omega : k + 2 ≤ 2 ^ (2 * n + 2))

theorem plateau_persistence (ε δ σ : ℝ) (_hε : 0 < ε)
    (hδ : 0 ≤ δ) (hsmall : δ < ε / 4) (hσ0 : 0 ≤ σ) (hσ1 : σ ≤ 1) :
    |σ * δ| < ε / 4 := by
  rw [abs_of_nonneg (mul_nonneg hσ0 hδ)]
  nlinarith

theorem nonhalting_all_times (β γ σ : ℝ) (_hβ : 0 < β) (hγ : 0 < γ)
    (hγβ : γ ≤ β) (_hσ0 : 0 ≤ σ) (hσ1 : σ ≤ 1) :
    (1 / 2 - β) + σ * (β - γ) < 1 / 2 := by
  have h := mul_nonneg (sub_nonneg.mpr hσ1) (sub_nonneg.mpr hγβ)
  nlinarith

theorem halting_endpoint (β γ : ℝ) :
    (1 / 2 - β) + (β - γ + 2 * γ) = 1 / 2 + γ := by ring

theorem lift_divergence (a vx vy : ℝ) : a * vx + a * vy - a * (vx + vy) = 0 := by
  ring

theorem pressure_sign (g dφ : ℝ) : -(-dφ) + (g - dφ) = g := by ring

end RapidLattice
