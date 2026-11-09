# Primary propositions used in the restricted-jet argument

An independent source-reading agent, `primary-reader`, read the archived
HTML and checked the Wendl passages against the original v2 PDF.
This is source attribution, not an independent mathematical Reviewer
acceptance of the restricted theorem. The agent returned its readings
without writing files; the excerpts below preserve that returned result.

## Wendl, arXiv:1011.1690v2

Source: <https://arxiv.org/pdf/1011.1690v2>, version 3.2,
May 28, 2014, pp. 123 and 155; corresponding HTML:
<https://arxiv.org/html/1011.1690v2>.
The HTML title displays August 24, 2026, unlike the v2 PDF.
The reader reports that the statements below agree. Do not use
the HTML generation date as the historical publication date.

The source sets up a smooth complex rank-`n` bundle over a closed
connected Riemann surface and real-linear Cauchy--Riemann operators,
with Sobolev extensions for `k>=1` and `1<p<infinity`.

**Theorem 3.22**:

> ind(D) = n chi(Sigma) + 2 c_1(E).
>
> We should emphasize, especially for readers who are more accustomed
> to algebraic geometry, that this is the real index...

Thus rank two, genus zero, and zero Chern number give real index four.
No surjectivity conclusion is inferred from this index alone.

**Theorem 3.23**:

> Suppose n=1, i.e. (E,J) -> (Sigma,j) is a complex line bundle.
>
> If c_1(E)<0, then D is injective.
>
> If c_1(E)>-chi(Sigma), then D is surjective.

Applied to `TS^2`, its degree is two and `-chi(S^2)=-2`.
Wendl later explicitly writes:

> Similarly, D_i^{S^2} is also surjective since
> c_1(TS^2)=2 > -chi(S^2).

**Section 4.4.1, unnumbered Sard--Smale theorem**:

> Suppose X and Y are smooth Banach manifolds which are separable
> and paracompact, and f:X -> Y is a smooth map whose derivative
> df(x):T_x X -> T_{f(x)}Y for every x in X is Fredholm.
> Then the regular values of f form a Baire subset of Y.

The following sentence says the finite-differentiability version
requires `k` sufficiently large, but does **not** give the exact
inequality. This passage therefore does not check the precise
finite-`C^6` threshold used in the manuscript. That threshold remains
an explicitly stated classical analytic input. The original Smale
DOI, 10.2307/2373250, led to an inaccessible JSTOR theorem page.

## Oh--Zhu, arXiv:0805.3581v3

Source: <https://arxiv.org/html/0805.3581v3>, Sections 2--3,
January 31, 2009 revision.

**Proposition 2.3**:

> The section Upsilon is transverse to the zero section...

Its proof uses the full tangent space of the almost-complex parameter
space, not exact variations of a pair of forms. The manuscript's
fixed closed two-form `B` is a different object from their `B`.

**Equation (2.12)** is the annihilator equation for the combined
map-and-jet derivative, followed by the quantifier:

> for all xi in Omega^0_{2,p}(u*TM) and B in T_J J_omega.

**Equation (2.18)** reads

> < (1/2) B composed with du composed with j, eta > = 0

and again quantifies over all `B in T_J J_omega`. Its off-mark
argument uses somewhere injectivity and unique continuation.

**Equation (3.3) and its explanation**:

> Furthermore since eta in (W^{1,p})*, the degree of P must be
> zero and so we obtain eta = alpha_{z_0} delta_{z_0}.
>
> This is because the 'evaluation at a point of the derivative'
> of W^{1,p} map does not define a continuous functional on W^{1,p}.

**Remark 3.2** explains that without reducing map variations from
`W^{k,p}` to `W^{2,p}`, the argument would only give derivatives
of the delta distribution of bounded higher order:

> This would then cause a problem in the argument for the rest
> of the proof of this lemma.

These passages support the three recorded attributions:
`SPHERE_DOMAIN`, `CR_INDEX`, and `OZ_PRIMARY`. They do not prove
the restricted pair-variation theorem.

## Recording boundary

The official `citation_check attribute` command unconditionally archives
under `research/literature/`, which is outside this mission's assigned
writable paths. No supporting attribution was forged under another
identity or written by bypassing that command. The primary-source
readings are available here for the host's independent Reviewer;
formal citation-attribution records remain outstanding.
