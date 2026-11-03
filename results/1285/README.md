# Result 1285

## Asymptotic success upper bounds for restricted CRT-local factoring controllers and ECM dual-chain counterfamilies

**Status:** independently verified scoped complexity lower bounds (Tier-B seed)<br>
**Field:** computational number theory

This package establishes two exact negative theorems against restricted deterministic integer-factoring controller families:

1. **One-gcd CRT-local controllers:** an infinite balanced-semiprime family against frozen one-gcd CRT-local controllers with equality and Jacobi-symbol feedback, bounding asymptotic success by $5/8 + o(1)$.
2. **ECM dual-chain counterfamily:** for every fixed positive rational resource tuple $(c, e)$, a shell-uniform Rankin and effective prime-selection argument proves a balanced-semiprime counterfamily with $\eta = 1/(256 \max(3c+2, e+1))$, supported by an independent reconstruction of $65,537$ shell heights and $42,875$ triples.

## Boundary

These lower bounds apply to the specified restricted controller grammars; unrestricted classical polynomial-time integer factoring remains open.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_1285_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `NEGATIVE_REPORT.md` | Asymptotic lower bounds for the CRT-local and low-$L_1$ factoring models |
| `ecm_dual_chain_analysis.md` | Proof of the balanced-semiprime counterfamily for the ECM dual-chain route |
| `ecm_dual_chain_certificate.json` | Exact finite-shell certificate |
| `reviewer-replay-20260905.json` | Independent Reviewer reconstruction of 65,537 shell heights and 42,875 triples |
| `reviewer-jacobian-order-four-20260905.json` | Jacobian elliptic-curve point-order verification |
| `verification-summary.json` | Structured verification summary |
