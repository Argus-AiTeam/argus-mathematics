# Conditional critical-regularity extension

**Engineer assessment: supported as a conditional identity theorem, not an
endpoint existence theorem.** The quantifiers and extra continuity norm
are indispensable to this assessment.

## Exact claim, source, and dependency correction

Old `BH-ENDPOINT@1` is Theorem 3 of the preserved
`9000051/research/boundary-hessian/bridge.md`. Use the same smooth metrics,
closed real \(q\), central functional, and normalizations as the literal
bridge. Suppose a holomorphic, nonsingular frame \(B\) is **already given**
in \(C^0(\overline D)\cap W^{1,2}(D)\), boundary \(h\)-unitary.
Suppose a centered family is **already given**, holomorphic in parameters
into the local Banach algebra
\[
 \mathcal A=C^0(\overline D)\cap W^{1,2}(D),\qquad
 \|u\|_{\mathcal A}=\|u\|_\infty+\|u\|_{W^{1,2}},
\]
with \(F(0)=f\), \(F(t,0)=f(0)\), and \(F_{t_j}(0,z)=zb_j(z)\).
Then all four determinant, central, Poisson, and area identities of
Theorem 1 hold.

The inherited graph lists only `BH-FLUX` below this claim. That is not
its full mathematical dependency set: it also uses the local-potential
identity, smooth composition and differentiation of densities, the
determinant calculation, and the centered first variations. It does
**not** invoke the \(p>2\) existence construction at \(p=2\).
The current index and assessment make those distinctions explicit.

This is an Argus-proposed extension of the manuscript's stated
\(p_0>2\) identities, not an independent reconstruction of an entire
critical-regularity theory. No novelty has been checked.

## Why the endpoint argument works

Multiplication is bounded on \(\mathcal A\), since the undifferentiated
factor is controlled in the sup norm and the differentiated factor in
\(L^2\). Smooth compositions with compact range have the corresponding
real differentiability. Thus the metric density and its two parameter
derivatives belong continuously to \(L^1\). This justifies the unweighted
area differentiation, but **does not by itself justify** logarithmic
integration: that functional is not bounded on unrestricted \(L^1\).

The draft supplies the missing ingredient. On a fixed smaller central
disc, source Cauchy estimates applied on a slightly larger interior
circle give parameter \(C^2\) dependence of the densities in the uniform
norm. One can choose fixed target charts near the relevant graph points;
compactness and the parameter sup norm keep them valid. Hence the
densities have \(C^2\) dependence in the space with norm
\[
               \|v\|_{L^1(D)}+\|v\|_{C^0(|z|\le1/2)} .
\]
Integration against \(\log(1/|z|)\) is continuous on this space:
outside the central disc the weight is bounded, and inside it the
weight is integrable while the density is uniformly bounded.
This is the actual endpoint argument, not a formal substitution of
\(\rho=2\) into an \(L^{\rho/2}\) Holder estimate.

The same split passes Green's logarithmic identity to \(r=1\) whenever
the function is interior smooth, boundary continuous, and has \(L^1\)
Laplacian. The small central region has bounded Laplacian; on the
remaining annulus dominated convergence uses its \(L^1\) norm.
It applies to \(\log\det N\) and to
\(|z|^2\operatorname{tr}(B^*qB)\). Positivity and compactness bound
\(N^{-1}\), so \(\log\det N\in\mathcal A\) by the weak chain rule.
The local potential calculation is still valid inside the disc, with
its density in \(L^1\). Cauchy's formula still handles the central term.

Finally the separately reviewed flux lemma requires exactly the supplied
\(W^{1,2}\) bound. The area integral and Ricci integral have unique
limits by \(L^1\) integrability, so the subsequential flux comparison
finishes the same area identity. No exponent above two is used in this
part of the argument.

## What remains outside the conclusion

The concrete missing step in an **unconditional** endpoint reading is
construction of the frame and family with this topology. At \(p=2\),
the initial small-gauge sup estimate loses its positive radius exponent;
the factor argument no longer supplies an \(s>1/2\); and the centered
Cauchy right inverse cannot be bounded by a \(W^{1,2}\)-only point
evaluation estimate. None of those failures disproves existence; they
show exactly why the previous construction does not establish it.
Moreover \(\mathcal A\) has a sup norm that ordinary \(W^{1,2}\) lacks.
Deleting that hypothesis changes the theorem.

Old `judgement-BH-ENDPOINT-74fe6def6a77` is an Engineer opinion.
There is no separately targeted old independent receipt for
`BH-ENDPOINT`. The old bridge and flux receipts support the reused
arguments only; they are not silently promoted to an independent
endpoint verdict. The primary-source assumptions for the \(p>2\)
construction are not needed to manufacture a family here, since the
family is a hypothesis.

There is no Lean source or compiler evidence. No new finite computation
or unchanged checker replay is relevant to this conditional analytic
step. No gap was found in the statement as written; an unconditional
endpoint existence or canonical-ampleness claim remains unsupported.
Current native independent review is pending.
