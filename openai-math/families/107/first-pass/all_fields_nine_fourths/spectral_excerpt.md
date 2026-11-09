# Read passage: spectral duality over an arbitrary field

Source: M. Christandl, P. Vrana, J. Zuiddam, *Universal points in the
asymptotic spectrum of tensors*, arXiv:1709.07851v3 (May 26, 2018).
Primary text: <https://arxiv.org/html/1709.07851v3>.

Section 1.1 explicitly starts with multilinear maps "over an arbitrary
field F." Section 1.2 defines T as equivalence classes of these tensors,
with restriction order, direct sum, and tensor product.

Theorem 1.1 (Spectral theorem), relevant statement:

> For any semiring X contained in T there are a compact space Delta and
> a homomorphism phi : X -> C+(Delta) of semirings ... such that
> a is asymptotically restricted by b if and only if phi(a) <= phi(b)
> pointwise on Delta.

The explicit Delta is the set of restriction-monotone homomorphisms
`X -> R_{\geq 0}`. The following proposition supplies exactly the
asymptotic-rank statement used here.

Proposition 1.6:

> Let X contained in T be a semiring. Let (Delta, phi) be an asymptotic
> spectrum of X. Let a in X. Then
> asymptotic subrank(a) = min_{xi in Delta} phi(a)(xi),
> asymptotic rank(a) = max_{xi in Delta} phi(a)(xi).

Application: X is the unital semiring of all finite three-tensors over
the fixed original field F, containing all diagonal tensors. No quantum
functional or complex-field existence theorem is being substituted here.
This passage was read by Engineer. Independent attribution must still be
performed by the Host-invoked Reviewer; this file is not that verdict.
