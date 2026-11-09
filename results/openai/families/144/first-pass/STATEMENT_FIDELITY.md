# Statement fidelity: finite-character and prime-sieve core

The Lean source is `Main.lean`; its ledger claim is `C144_SIEVE_KERNEL`.
It does **not** encode the full analytic assertion `C144_SIGNAL`.

All definitions and declarations are in namespace `SignalAudit`.
`P : Nat` has hypothesis `NeZero P`. Thus the character identities include
every positive modulus, not just the squarefree modulus used in the paper.
The application selects P >= 2. `Complex` is the complex field and
`ZMod P` is the full residue ring, not only its units.

`ZMod.stdAddChar` is Mathlib's standard positive additive character,
exp(2*pi*i*j/P). `unitIndicator k` is 1 if k is a unit and 0 otherwise.
`ramanujan h` is its negative-exponent discrete Fourier transform.
`ramanujan_sum` expands this as the sum of exp(-2*pi*i*a*h/P) over
unit residue classes a; nonunit summands are zero. This is the manuscript's
C_P(h), with the same sign.

`selector k` divides the positive-exponent transform of C_P by P.
`selector_eq_indicator` proves it equals the unit indicator for every
residue k. `baseline_formula` gives the corresponding normalized transform
of the constant 1: the indicator that k=0. `joint_transform` combines these
two identities for arbitrary complex scalars q, gamma, d. In the analytic
application these are qhat_0(v), gamma, and d(v); the theorem makes no claim
about constructing those scalars as Fourier integrals or about positivity.

`intCast_isUnit_iff` explicitly identifies the unit condition for every
integer m, including negative integers, with
Nat.Coprime(m.natAbs,P). `integer_selector` gives the normalized transform
at that signed integer frequency. There is no assumption that m is a unit.

`sievePrimes K` is the finite set of primes <= K. `sieveModulus K` is their
product, including the empty-product convention. `sieveModulus_pos`,
`prime_dvd_sieveModulus`, and `exists_sieve_modulus` prove that for every
natural K >= 2 this product is >= 2 and is divisible by every prime <= K.

`harmonic_not_unit` assumes an arbitrary positive P containing all primes
<= K, 2 <= ell <= K, and an arbitrary residue m. It proves ell*m is not a
unit. `higher_mode_zero` applies the selector identity to every signed
integer m and proves its higher-harmonic transform is zero. It does not
silently assume m coprime to P.

The analytic proof must separately show that all surviving harmonics have
ell <= K and must bound the noncharacter phases when t is not 1. Neither
the finite-c perturbation bound, a smooth cutoff jitter law, stationary
phase, fast averaging, physical map convergence, nor the Banach-spectrum
conclusion is encoded in this Lean file. Those are mathematical arguments
in `research/SIGNAL_AUDIT.md`, awaiting independent human review. A successful
compiler run is evidence only for the declarations described here.
