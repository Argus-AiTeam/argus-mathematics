# ext-integrand-closure

**Assessment: supported for the literal fiber expression.** Its origin as
an actual virtual localization contribution is a separate, unattempted
geometric obligation.

## Exact claim and conventions

`C40_EXT_CLOSURE`, versions 1-3:

> The exact GRR formulas and finite Euler expansions place the actual
> localization integrand in the class covered by rel:marked-reduction.

Here "actual integrand" means the literal displayed
`rel:fiber-contribution`, not independently certified virtual geometry.
The sources are OpenAI's September 24, 2026 `relation.tex`,
`rel:ext-grr`, `rel:tautological-grr`, `eq:moving-ratio`, and `eq:insertion`,
at revision `4eaee87548250b2682affda7d05d947c05554bae`, and old `REPORT.md`,
Sections 4 and 7.

The surface is smooth connected projective over \(\mathbb C\), with
\(\chi(\mathcal O_X)=1\). Use the stated line classes,
\(D_1=T,D_2=H\), nonnegative lengths and \(p\), quotient Euler convention,
and \(w_1=1/2,w_2=-1/2\). Expand at \(x_1=x_2=0\). Negative extracted
\(m_i=D_i(D_i-K)/2\) mean zero. Effectivity is not needed for this algebraic
expression. The equivariant second Chern character is taken **before**
specializing the weights.

## Decisive identities and truncation

Write
\(E_{ij}(P)=R\Gamma(P)-R\pi_*(\mathcal I_i^\vee
\otimes^{\mathbf L}\mathcal I_j(P))\).
The universal sequence and graph duality give ordered residual corrections
\[
\psi^*E_{ij}(P)-E_{ij}^-(P)
=\mathcal L^{-1}\rho^*(P-K)\otimes^{\mathbf L}\mathcal I_j|_\rho,
\]
\[
\psi^*E_{ji}(P)-E_{ji}^-(P)
=\mathcal L\rho^*P\otimes^{\mathbf L}(\mathcal I_j^\vee)|_\rho.
\]
The canonical twist is in the first formula; the second dualizes the
other ideal. Their empty-factor limits are
\(E_{i0}(P)=((K-P)^{[n_i]})^\vee\) and
\(E_{0j}(P)=P^{[n_j]}\). The even duality shift introduces no minus sign.
These are identities of perfect K-classes, not underived incidence
restrictions.

Smooth-projection GRR gives
\[
\operatorname{ch}R\pi_*R\mathcal Hom(\mathcal I_i,\mathcal I_j(P))
=\pi_*(\operatorname{ch}(\mathcal I_i^\vee)
\operatorname{ch}(\mathcal I_j)e^P\operatorname{td}(T_X)),
\]
and
\(\operatorname{ch}(P^{[n_i]})
=\pi_*((1-\operatorname{ch}(\mathcal I_i))e^P\operatorname{td}(T_X))\).
Constant complexes contribute only
\(\chi(P)=1+\frac12\int P(P-K)\), not individual cohomology dimensions.
Thus irregularity does not add unlisted scalar inputs.

Products of these surface pushforwards become a single pushforward with
separate auxiliary slots, by proper/flat base change and projection
formula over the base that still contains both outputs.

For a perfect class of rank \(r\),
\[
e_u(V)=u^r\exp\left(\sum_{k\geq1}(-1)^{k-1}(k-1)!
 \operatorname{ch}_k(V)u^{-k}\right).
\]
All moving weights have constant part \(+1\) or \(-1\), so their inverses
expand with nonnegative intrinsic Chow degrees. Fixed Euler factors are
finite polynomials and are not inverted at zero weight. For
\(N=n_1+n_2\), only intrinsic degree \(2N+2\) on \(M\times X^2\) reaches
ordinary codimension two after the Hilbert pushforward. The fixed
coefficient extraction and this degree bound make the admissible input
finite. The insertion is exactly
\([Z_i]=-\operatorname{ch}_2(\mathcal I_i)\), with its separate line and
weight terms; no Hilbert tangent class is silently omitted.

## Evidence and scope

Version 2's generic GRR assumption is relocated in version 3 to the
explicit shared `C40_CALCULUS` input, not discarded. Both legacy Engineer
and Reviewer judgements support the unchanged statement.

`initial_fiber`, `shifted_fiber`, and the ordered branches of `pull_atom`
faithfully implement the stated specializations, including both Ext
denominators. Their saved finite cases replay, but do not cover arbitrary
lines, parameters, or lengths. The uniform closure follows from the
displayed identities and finite-degree argument. No verification of
`prop:quot-pot`, `prop:fixed-pot`, or either fixed virtual-class proposition
is inferred.
