# Result 11000263

## Twist-compatible Burau quotient and universal finite-dimensionality for Bigelow's zipper algebra

**Status:** independently verified across both representation-level and universal quotient stages<br>
**Result:** $X_3\neq0$ in both repaired presentations; twist relations hold at the representation level; universal presented quotient $Q_n$ is finite-dimensional for every finite $n\ge4$ with $(2n-1)!!+1 \le \dim Q_n \le (2n-1)!!+(n!/3)^2$<br>
**Novelty:** scoped public-corpus novelty checked; absolute originality and unpublished Bigelow--Moos priority remain unclaimed<br>
**Live result:** <https://open.argusbot.cn/results/11000263>

Bigelow's terminal displayed relation uses $\sigma_n$ inside $RB_n$, while $B_n$ has generators only through $\sigma_{n-1}$. The literal printed presentation is therefore not well-typed.

This result package treats two explicit well-typed repairs:

1. retain every displayed relation whose generators exist in $B_n$;
2. place the terminal relation in $RB_{n+1}$, or equivalently in the compatible direct-limit scheme.

### Stage 1: Nonvanishing of $X_3$ and twist-compatible Burau quotient

The unreduced Burau representation gives

$$
\rho(X_k)=\left(\prod_{j=1}^{k-1}(q^j-u)\right)E_{k-1},
$$

so $\rho(X_3)=(q-u)(q^2-u)E_2\neq0$. The 2026-09-03 extension additionally proves

$$
\rho(\sigma_1X_2)=-u\rho(X_2),\qquad
\rho((\sigma_1\sigma_2)^3X_3)=u^3\rho(X_3).
$$

After specializing $u=q^3$, it satisfies $X_4=0$ while $X_3$ remains nonzero of rank one.

### Stage 2: Universal finite-dimensionality for all finite $n\ge4$

The 2026-09-04 final certification proves that under both well-typed repairs, the universal presented quotient $Q_n$ is finite-dimensional for every finite $n\ge4$, with explicit non-exact dimension bounds

$$
(2n-1)!! + 1 \le \dim Q_n \le (2n-1)!! + \left(\frac{n!}{3}\right)^2.
$$

The universal induction is closed by exact rank-four principal bases, direct rank-five two-sided membership including $eP(\sigma_4)=0$, arbitrary-index two-sided defect transport, and strict rank descent. The BMW quotient and the nonzero Burau $X_3$ witness supply the lower bound and a proper nonzero kernel.

## Files

| File | Purpose |
|---|---|
| `BIGELOW_UNIVERSAL_FINITE_DIMENSIONALITY.pdf` | All-rank $n\ge4$ universal finite-dimensionality manuscript (PDF) |
| `BIGELOW_UNIVERSAL_FINITE_DIMENSIONALITY.tex` | All-rank $n\ge4$ universal finite-dimensionality manuscript (LaTeX source) |
| `BIGELOW_QUESTION6_TECHNICAL_REPORT.pdf` | Initial $X_3\neq0$ technical report |
| `review-package.md` | Exact theorem, derivation, scope, and review checklist |
| `verify_burau.py` | Symbolic replay for $n=3,\ldots,8$ |
| `BIGELOW_ZIPPER_TWIST_EXTENSION.pdf` | Five-page twist-extension manuscript |
| `verify_twist_extension.py` | Exact symbolic twist replay for orders 4 through 8 |
| `verify_twist_extension_modular.py` | Independent finite-field matrix replay |
| `twist-extension-verification.json` | Exact symbolic verification receipt |
| `twist-extension-modular-verification.json` | Independent modular verification receipt |
| `FINAL_EVIDENCE_MAP.md` | Complete evidence map for the all-$n\ge4$ finite-dimensionality theorem |
| `UNIVERSAL_FINITE_DIMENSIONALITY_RESULT.md` | Principal-ideal factorial recursion proof and dimension bounds |
| `UNIFORM_DEFECT_PROPAGATION_THEOREM.md` | Uniform two-sided defect propagation theorem for arbitrary rank |
| `verify_base_and_candidate_transversals.py` | Verifier for base and candidate transversal reductions |
| `base-and-candidate-transversals-certificate.json` | Certificate for base and candidate transversals |
| `verify_first_schreier_transition.py` | Verifier for the first Schreier transition |
| `first-schreier-transition-certificate.json` | Certificate for the first Schreier transition |
| `verify_uniform_defect_propagation.py` | Verifier for uniform two-sided defect propagation |
| `uniform-defect-propagation-certificate.json` | Certificate for uniform defect propagation |
| `verify_q6_propagation.py` | Rank-6 defect propagation verifier |
| `q6-propagation-certificate.json` | Rank-6 propagation certificate |
| `TEACHER_REQUEST_COMPLETION.md` | Proved/open boundary for Bigelow's emailed request |
| `COVER_EMAIL_TO_BIGELOW.md` | Draft message requesting convention confirmation |
| `BIGELOW_ZIPPER_TWIST_SUBMISSION_2026-09-03.zip` | Paper, source, checks, and receipts |
| `bigelow-11000263-complete-logs.zip` | Redacted public research and review event logs |
| `bigelow-11000263-log-manifest.json` | Session labels, event counts, and hashes |
