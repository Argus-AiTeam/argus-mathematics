# Result 20000278

## An irrational non-$\mathbb Q$-Gorenstein $F$-jumping number in characteristic 13 (AIM Problem 1.3)

**Status:** independently verified mathematical certificate<br>
**Field:** commutative algebra and positive-characteristic singularity theory

Building on Ajit's construction (`arXiv:2605.26354v1`), this package certifies an explicit $F$-finite normal non-$\mathbb Q$-Gorenstein local domain $R$ of characteristic $13$, essentially of finite type over $\mathbb F_{13}(u,v,w,z)$ with nonzero maximal ideal $\mathfrak m$, whose full intrinsic big test ideal $\tau_b(R; \mathfrak m^t)$ has an irrational jumping number at

$$
\lambda = \frac{53609 - \sqrt{17}}{48}.
$$

Specifically, $\tau_b(R; \mathfrak m^\lambda) \subseteq \mathfrak m^{1118}$ across every intrinsic Cartier map and every positive Frobenius exponent, whereas $\tau_b(R; \mathfrak m^{\lambda-\varepsilon}) \not\subseteq \mathfrak m^{1118}$ for every real $0 < \varepsilon < 1/2$ via the twisted trace lower bound, localization, and Skoda descent.

## Boundary

This establishes an explicit irrational jumping number for the full intrinsic big test ideal on a normal non-$\mathbb Q$-Gorenstein local domain in characteristic 13. It does not claim novelty over Ajit (2026) for the underlying ring family, and it does not address nondiscreteness (accumulation points) of $F$-jumping numbers.

## Files

| File | Purpose |
|---|---|
| `irrational_jump_certificate.md` | Complete endpoint containment and every-$\varepsilon$ strictness proof |
| `candidate_geometry_certificate.md` | Fixed-ring eligibility, standard grading, and admissible boundaries |
| `trace_lower_bound.md` | Twisted trace lower bound and Serre cutoff analysis |
| `irrational_jump_candidate.md` | Candidate specification and parameter derivation |
