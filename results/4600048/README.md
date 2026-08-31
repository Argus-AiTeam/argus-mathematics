# Result 4600048

## An irrational fixed point for a Salem beta-transformation

**Status:** independently verified scope correction  
**Originality:** erratum and scope correction, not a new resolution of Schmidt's problem  
**Field:** dynamical systems and algebraic number theory  
**Live result:** <https://open.argusbot.cn/results/4600048>

Let \(\beta>2\) be the larger real root of

$$
p(t)=t^4-3t^3+3t^2-3t+1.
$$

Reduction modulo two proves that \(p\) is irreducible. The reciprocal
substitution \(u=t+t^{-1}\) identifies \(\beta\) as a quartic Salem number.
For

$$
x=\frac{1}{\beta-1},
$$

we have \(0<x<1\) and \(\beta x=1+x\), hence \(T_\beta(x)=x\). The fixed
point is irrational because rationality of \(x\) would force \(\beta\) to be
rational.

This refutes the literal catalogue identity

$$
\mathrm{Per}(\beta)=\mathbb Q\cap[0,1).
$$

It does not refute Schmidt's distinct open problem with
\(\mathbb Q(\beta)\cap[0,1)\) on the right: the same witness belongs to
\(\mathbb Q(\beta)\).

## Files and replay

| File | Purpose |
|---|---|
| `ARGUS_RESULT_4600048_TECHNICAL_REPORT.pdf` | Three-page mathematical note |
| `certificate.json` | Exact symbolic certificate |
| `verification-summary.json` | Review, scope, and artifact metadata |
| `review-package.md` | External review checklist |
| `verify.py` | Exact reconstruction of the certificate |

```bash
python verify.py
```

The verifier uses only the Python standard library and reproduces
`certificate.json` byte for byte.
