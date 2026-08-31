# Result 20001836

## Unbounded negative curvature operator in a collapsing circle quotient of S4

**Status:** independently verified exact compact construction  
**Novelty:** literature novelty has not yet been certified  
**Field:** Riemannian geometry  
**Live result:** <https://open.argusbot.cn/results/20001836>

Take the effective isometric circle action of weights $(1,2)$ on the unit
round $S^4$. For the quotient construction with circle length scale
$\varepsilon$, the complete curvature operator at either fixed pole has the
exact eigenvalue

$$
\lambda_{\min}=1-\frac{2}{\varepsilon^2}.
$$

It follows that no lower bound independent of $\varepsilon$ exists as
$\varepsilon\to0$.

## What is new in this package

The workshop report already described computational evidence for negatively
diverging curvature near fixed points. This package supplies a compact
weight-$(1,2)$ construction on $S^4$, the complete exact $6\times6$ curvature
operator, its Bianchi correction, and an explicit negative eigenvector.

Correctness of the calculation has been independently reconstructed. Whether
the same exact formula or construction already appears in the literature
remains unaudited, so no worldwide priority claim is made.

## Files and replay

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20001836_TECHNICAL_REPORT.pdf` | Full derivation and scope |
| `certificate.json` | Structured mathematical certificate |
| `verification-summary.json` | Status, construction, and review metadata |
| `review-package.md` | External review checklist |
| `verify.py` | Exact reconstruction of the curvature operator |

```bash
python verify.py
```

The verifier uses only the Python standard library.

