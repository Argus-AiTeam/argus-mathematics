# Result 1285

## An Unconditional Exponential Worst-Case Lower Bound for Adaptive Signed-Chain Elliptic Curve Factorization Programs

**Status:** `independently_verified` (`publishable_theorem`, `novelty_status=verified_new`)<br>
**Resolved scope:** Every uniform adaptive signed-chain ECM shell-bank program faces an effective balanced squarefree n-bit semiprime N_n requiring exponential worst-case bit operations, plus exact 14,400-pair KS13-CRT-Feedback negative witness<br>
**Field:** computational number theory and arithmetic complexity

## Summary

We prove an unconditional worst-case complexity lower bound for uniform adaptive signed-chain Elliptic Curve Method (ECM) shell-bank factorization programs. In this model, a classical program may adaptively generate division-polynomial and signed-chain scalar schedules based on intermediate register comparisons while sampling independent Weierstrass curves modulo $N$. By establishing complete signed arithmetic containment, a varying-exponent Rankin smoothness bound across adaptive branches, and selector-tape averaging, we prove that every such program admits an effective balanced squarefree $n$-bit semiprime $N_n$ on which its success probability is exponentially small unless the bit-operation budget grows super-polynomially.

## Open Boundaries

- Unrestricted polynomial-time integer factorization

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_1285_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `analysis.md` | Mathematical proof / verification artifact |
| `literature.md` | Mathematical proof / verification artifact |
| `ecm-adaptive-schedule-lower-bound_verify.py` | Mathematical proof / verification artifact |
| `verification-summary.json` | Structured verification summary |
