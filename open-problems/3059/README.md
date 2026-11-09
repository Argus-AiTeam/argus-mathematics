# Result 3059

## The Alon-Jaeger-Tarsi Conjecture in Dimensions Eight and Nine over F_5

**Status:** `independently_verified` (`publishable_theorem`, `novelty_status=verified_new`)<br>
**Resolved scope:** All invertible 8x8 and 9x9 matrices over F_5 admit a nowhere-zero input vector with nowhere-zero image<br>
**Field:** combinatorial algebra and finite fields

## Summary

We prove the Alon--Jaeger--Tarsi conjecture in dimensions eight and nine over the prime field $\mathbb{F}_5$: for every invertible matrix $A \in \mathrm{GL}_n(\mathbb{F}_5)$ ($n \in \{8,9\}$), there exists a vector $x \in (\mathbb{F}_5^\times)^n$ such that $Ax \in (\mathbb{F}_5^\times)^n$. By Alon--Tarsi polynomial nonvanishing, this is equivalent to a nonzero canonical remainder of $\prod_{i=1}^n (\sum_{j=1}^n A_{ij} X_j)$ modulo $(X_1^4-1,\ldots,X_n^4-1)$. Repeated-column permanent-rank amplification resolves all matrices of permanent rank at least six, while an exact structural classification at the minimum permanent rank five establishes that either $A$ or $A^{-1}$ contains a column of support size at most three, reducing the remaining locus to dimension eight.

## Open Boundaries

- Dimensions n >= 10 over F_5 and prime fields 7 <= p <= 61, p = 79 in general dimension

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_3059_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `ajt_f5_dimension_nine.md` | Mathematical proof / verification artifact |
| `permanent_amplification.md` | Mathematical proof / verification artifact |
| `zero_profile_final.md` | Mathematical proof / verification artifact |
| `zero_profile_final.py` | Mathematical proof / verification artifact |
| `test_permanent_amplification.py` | Mathematical proof / verification artifact |
| `verification-summary.json` | Structured verification summary |
