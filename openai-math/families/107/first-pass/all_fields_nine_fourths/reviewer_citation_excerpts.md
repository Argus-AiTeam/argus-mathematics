# Primary passages independently read by Reviewer

These are citation excerpts, not a replacement for the mathematical report.
Mathematical notation from the HTML source below is transcribed in ASCII.

## Arbitrary-field spectral duality

Source: Christandl, Vrana and Zuiddam, *Universal points in the asymptotic
spectrum of tensors*, arXiv:1709.07851v3, sections 1.1 and 1.2.
Primary text independently retrieved during review:
https://arxiv.org/html/1709.07851v3

Section 1.1 describes multilinear maps "over an arbitrary field F".
Section 1.2 defines T to be equivalence classes of these F-multilinear
maps of fixed order k, with direct sum, tensor product, and restriction
order. It explicitly gives the additive unit <0> and multiplicative
unit <1>.

Theorem 1.1 states that for any semiring X contained in T there are a
compact space Delta and a semiring homomorphism
phi : X -> C^+(Delta), separating points, such that a is asymptotically
restricted by b if and only if phi(a) <= phi(b) pointwise. Its explicit
Delta is the set of restriction-monotone homomorphisms X -> R_{\geq 0},
with phi(a)(xi) = xi(a).

Proposition 1.6 states:

> Let X contained in T be a semiring. Let (Delta, phi) be an asymptotic
> spectrum of X. Let a be in X. Then
> asymptotic_subrank(a) = min_{xi in Delta} phi(a)(xi),
> asymptotic_rank(a) = max_{xi in Delta} phi(a)(xi).

The full unital semiring of finite three-tensors over the original
fixed F meets these hypotheses. The complex-only quantum functionals
constructed later in the paper are not needed for this application.

## Staged complex nine-fourths statement

Source: staged
`Matrix-Multiplication-Nine-Fourths-October-2-2026/build/paper.tex`,
label `thm:main`, lines 45-49, read directly during review.

```tex
\begin{theorem}\label{thm:main}
For every $\eps>0$, two $n\times n$ complex matrices can be multiplied
using $O_\eps(n^{9/4+\eps})$ arithmetic operations. In particular,
$\omega\leq9/4$.
\end{theorem}
```

## Staged every-fixed-field comparator

Source: staged
`Staggered-extraction-for-exact-matrix-multiplication-over-every-field-September-24-2026/build/sections/introduction.tex`,
label `thm:main`, lines 57-63, read directly during review.
The label locates the asserted proposition; the report's lines 3-10
pointer is not the location in this staged file.

```tex
\begin{theorem}\label{thm:main}
Over every fixed field $\F$, the arithmetic exponent of square matrix
multiplication satisfies
\[
 \omega_\F<2.371054886006746<2.371054887.
\]
\end{theorem}
```

The following paragraph explicitly says that the algorithms are exact,
including in positive characteristic. The opening paragraph fixes the
field and allows arithmetic constants to depend on that field and the
chosen finite construction. Attribution confirms what this comparator
states, not an independent proof of its numerical bound.
