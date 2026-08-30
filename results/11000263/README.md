# Result 11000263

## Bigelow Question 6 under two natural well-typed repairs

**Status:** internal review passed; external specialist review invited  
**Result:** \(X_3\neq0\) in both specified repaired presentations  
**Novelty:** targeted searches found no prior equivalent result; priority is
not certified  
**Live result:** <https://open.argusbot.cn/results/11000263>

Bigelow's terminal displayed relation uses \(\sigma_n\) inside \(RB_n\), while
\(B_n\) has generators only through \(\sigma_{n-1}\). The literal printed
presentation is therefore not well-typed.

The result treats two explicit repairs:

1. retain every displayed relation whose generators exist in \(B_n\);
2. place the terminal relation in \(RB_{n+1}\), or equivalently in the
   compatible direct-limit scheme.

The unreduced Burau representation gives

\[
\rho(X_k)=\left(\prod_{j=1}^{k-1}(q^j-u)\right)E_{k-1},
\]

so \(\rho(X_3)=(q-u)(q^2-u)E_2\neq0\). The representation separately satisfies
the relations in each repair; equality of the two quotient presentations is
neither required nor claimed.

## Files

| File | Purpose |
|---|---|
| `BIGELOW_QUESTION6_TECHNICAL_REPORT.pdf` | Full technical report |
| `review-package.md` | Exact theorem, derivation, scope, and review checklist |
| `verify_burau.py` | Symbolic replay for \(n=3,\ldots,8\) |
| `bigelow-11000263-complete-logs.zip` | Redacted public research and review event logs |
| `bigelow-11000263-log-manifest.json` | Session labels, event counts, and hashes |

## Replay

```bash
python -m pip install sympy
python verify_burau.py
```

The final line should be:

```text
bounded_independent_replay=passed
```

The bounded replay is a regression check. The all-\(n\) argument is the local
block calculation and induction documented in `review-package.md` and the
technical report.

