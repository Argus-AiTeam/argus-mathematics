# Result 11000263

## Twist-compatible Burau quotient for Bigelow's zipper algebra

**Status:** mathematics reviewed; ready for Bigelow's convention check<br>
**Result:** $X_3\neq0$ in both repaired presentations; the requested twist
relations and a finite-dimensional extension above BMW hold at the
representation level<br>
**Novelty:** not independently certified; no priority claim
**Live result:** <https://open.argusbot.cn/results/11000263>

Bigelow's terminal displayed relation uses $\sigma_n$ inside $RB_n$, while
$B_n$ has generators only through $\sigma_{n-1}$. The literal printed
presentation is therefore not well-typed.

The result treats two explicit repairs:

1. retain every displayed relation whose generators exist in $B_n$;
2. place the terminal relation in $RB_{n+1}$, or equivalently in the
   compatible direct-limit scheme.

The unreduced Burau representation gives

$$
\rho(X_k)=\left(\prod_{j=1}^{k-1}(q^j-u)\right)E_{k-1},
$$

so $\rho(X_3)=(q-u)(q^2-u)E_2\neq0$. The representation separately satisfies
the relations in each repair; equality of the two quotient presentations is
neither required nor claimed.

The 2026-09-03 extension additionally proves

$$
\rho(\sigma_1X_2)=-u\rho(X_2),\qquad
\rho((\sigma_1\sigma_2)^3X_3)=u^3\rho(X_3).
$$

After specializing $u=q^3$, it satisfies $X_4=0$ while $X_3$ remains nonzero
of rank one. The joint image with the specialized BMW quotient is a
finite-dimensional braid-group algebra that surjects onto BMW with nonzero
kernel. This does not assert that the universal quotient by the three new
relations is finite-dimensional.

## Files

| File | Purpose |
|---|---|
| `BIGELOW_QUESTION6_TECHNICAL_REPORT.pdf` | Full technical report |
| `review-package.md` | Exact theorem, derivation, scope, and review checklist |
| `verify_burau.py` | Symbolic replay for $n=3,\ldots,8$ |
| `BIGELOW_ZIPPER_TWIST_EXTENSION.pdf` | Five-page twist-extension manuscript |
| `verify_twist_extension.py` | Exact symbolic twist replay for orders 4 through 8 |
| `verify_twist_extension_modular.py` | Independent finite-field matrix replay |
| `twist-extension-verification.json` | Exact symbolic verification receipt |
| `twist-extension-modular-verification.json` | Independent modular verification receipt |
| `TEACHER_REQUEST_COMPLETION.md` | Proved/open boundary for Bigelow's emailed request |
| `COVER_EMAIL_TO_BIGELOW.md` | Draft message requesting convention confirmation |
| `BIGELOW_ZIPPER_TWIST_SUBMISSION_2026-09-03.zip` | Paper, source, checks, and receipts |
| `bigelow-11000263-complete-logs.zip` | Redacted public research and review event logs |
| `bigelow-11000263-log-manifest.json` | Session labels, event counts, and hashes |

## Replay

```bash
python -m pip install sympy
python verify_burau.py
python verify_twist_extension.py
python verify_twist_extension_modular.py
```

The final line should be:

```text
bounded_independent_replay=passed
```

The twist verifiers also write `status=passed` receipts. These bounded replays
are regression checks; the all-$n$ arguments are the local block calculations
and inductions in the reports.
