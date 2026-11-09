# Analytic tools and prior-art boundary

The target is the literal lemma `int:stieltjes` in the staged September
24, 2026 manuscript, not the full EPnI theorem. The proposed strengthening
identifies the whole representing measure. It is not being assumed.

The following standard complex-analysis tools will be used. The passages
were read at <https://dlmf.nist.gov/1.10> on November 5, 2026. Independent
attribution belongs to the Host-invoked Reviewer, not the Engineer.

## Local holomorphic inversion: DLMF 1.10(vii), equations 1.10.12-13

> Suppose f(z) is analytic at z=z0, f'(z0) != 0, and f(z0)=w0.
> Then the equation f(z)=w has a unique solution z=F(w) analytic
> at w=w0.

The conclusion is local. A global branch still needs a proof of
properness and one-sheetedness; local inversion alone does not supply it.

## Reflection: DLMF 1.10(ii), equation 1.10.5

> Let C be a simple closed contour consisting of a segment AB of the
> real axis and a contour in the upper half-plane joining the ends of AB.
> Also, let f(z) be analytic within C, continuous within and on C, and
> real on AB. Then f(z) can be continued analytically across AB by
> reflection.

The reflected value is `f(conj(z))=conj(f(z))`.

## Residues: DLMF 1.10(iv), equation 1.10.8

> If f(z) is analytic within a simple closed contour C, and continuous
> within and on C -- except in both instances for a finite number of
> singularities within C -- then
> (1/(2*pi*i)) integral_C f(z) dz = sum of the residues of f(z) within C.

The contour is positively oriented. The proof will apply this only on
finite slit annuli, before taking any endpoint limit.

## Parameter integrals: DLMF 1.10(viii), equation 1.10.18

> Let D be a domain and [a,b] be a closed finite segment of the real
> axis. Assume that for each t in [a,b], f(z,t) is an analytic function
> of z in D, and also that f(z,t) is a continuous function of both
> variables. Then F(z)=integral_a^b f(z,t) dt is analytic in D and its
> derivatives of all orders can be found by differentiating under the
> sign of integration.

> This result is also true when b=infinity, or when f(z,t) has a
> singularity at t=b, with the following conditions. For each t in
> [a,b), f(z,t) is analytic in D; f(z,t) is a continuous function of
> both variables when z in D and t in [a,b); the integral converges
> at b, and this convergence is uniform with respect to z in every
> compact subset S of D.

The proof must establish that uniform convergence, not infer it from
pointwise convergence.

## Source findings that do not certify the target

Luger and Nedic, *On quasi-Herglotz functions in one variable*,
arXiv:1909.10198v2, Theorem 2.2, gives the Herglotz representation and its
Stieltjes inversion formula, including the positive measure's growth
condition. The source was obtained and read. This is compatible with the
manuscript's classical Herglotz step, but is not a proof that this
particular inverse function meets its hypotheses. The selected proof
instead uses a subtracted keyhole contour, so it does not assume a
Stieltjes representation or the target lemma.

Kargovsky, *On the inverse of sinc x*, arXiv:2507.17914v1,
Introduction and Theorem 2.1, supplies real-branch inverse-sinc series and
integral representations. Those passages were obtained and read. They do
not state the explicit Stieltjes measure sought here. The targeted
retrieval did not locate that exact measure; this is not a verified
originality claim or an exhaustive literature search.

Finite numerical samples, Taylor coefficients, and exact rational
identities cannot establish global branch selection, integral
convergence, or the absence of a singular measure. The finite-only route
is therefore retired, although these checks remain useful diagnostics.
