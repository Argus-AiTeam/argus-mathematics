# Closed-point clearing: application, not global base change

**Engineer assessment: supported as an implication from the exact retained
inputs.** This reviews `C_CLEARING@1` and `proof.md:98-121`. It is not an
independent verification that every requested arithmetic reduction exists.
Native independent review remains pending.

## Exact claim and input identification

The manuscript target is `bc:clearing-test` in the projective-base reference
source, revision `4eaee87548250b2682affda7d05d947c05554bae`,
`build/source/sections/05-base-change.tex`. The old prose and algebraic
certificate are preserved snapshot members; the staged manuscript directory
is instead a symlink to the separately version-checked reference source.
These provenance categories must not be conflated.

Fix a retained normal integral chart, a closed point \(b\), and the finite
normalization map \(\mu\) to a smooth polynomial base with coordinates \(u\).
The characteristic-p residue field is perfect (the geometric application
uses an algebraically closed field). The retained nonzero etale
discriminant gives finite separability of
\(K_0=\operatorname{Frac}(R)\) over \(k(u)\); thus \(u\) is a p-basis.
Use \(R_b\) as the subring of \(K_0\).
The retained inputs must actually supply
\[
 s=\sum_{j,\alpha}c_{j,\alpha}\partial^\alpha(g t_j s),
 \quad
 \psi_h(r)=C_u(sr),
 \quad
 \psi_h(1)=\delta\in k^\times ,
\]
where \(s\in K_0\) may have poles, \(g,t_j\in R_b\), and the
coefficients are regular on a selected smooth-base open containing
\(\mu(b)\). The last nonzero normalization is essential; neither the
scalar identity nor compilation proves it.

## The regularity issue and decisive implication

Take \(A=k[u]_{\mu(b)}\subset R_b\), or the smaller retained
principal-open ring \(k[u]_f\) with \(f(\mu(b))\ne0\).
Both embed in \(R_b\): their inverted denominators remain nonzero in the
closed-point residue field and hence are units there.
Ordinary coordinate derivations preserve either ring, since differentiating
\(a/f^m\) only introduces further powers of the same invertible denominator.
They need not preserve the singular or ramified ring \(R_b\).

The conditional adjoint theorem therefore constructs
\[
 T=\sum_{j,\alpha}t_j(-1)^{|\alpha|}
          \partial^\alpha(c_{j,\alpha})\in R_b,
 \qquad
 \psi_h(gT)=\psi_h(1)=\delta.
\]
Thus \(\psi_h(gT)(b)\ne0\). As a local-ring element, \(T\) has a
representative on a neighborhood of \(b\), so this is the intended
closed-point regular multiplier, not merely a rational witness.
All derivatives have been transferred to the regular base coefficients;
no unsupported claim that derivatives of arbitrary \(R_b\)-elements
remain regular is used.

The independent unit assessments of the differential identity and
Frobenius trace/lift identify the exact retained inputs, coefficient ring,
p-basis, scalar formula, and \(\delta\). They support the conditional
bridges. They do not certify the existence of the chart cover, simultaneous
arithmetic retention, or nonzero-Cartier reductions in every global situation.
Those are assumptions of this application, not facts earned by the local
certificate.

## Two routes, one consequence

The adjoint route needs no completion or degree bound **after** the ordinary
scalar identity and Cartier formula have been supplied. The manuscript's
conditions \(p>e_\mu,o_g\) can be retained without being used in this
short implication; this does not remove them from upstream constructions.
Allowing arbitrary finite ordinary derivative words does not allow Hasse
derivatives.

The completed-trace unit provides a different proof of the same
noncontainment under its additional excellent-normal-completion,
separability, common-p-basis, regular-coefficient and branch-degree
hypotheses. Its final contradiction uses \(d\delta\ne0\), with
\(d\le e_\mu<p\). It is not a second independent downstream theorem.
Neither route turns excluded-hypothesis controls into manuscript
counterexamples.

## Formal and downstream scope

The fresh Lean result proves the conditional algebraic equality and ideal
noncontainment. It does not encode `Spec R`, the point \(b\), relative
duality, a Hodge module, an arithmetic model, or a Frobenius-split geometric
fiber. The local-ring interpretation above is a prose instantiation.
Its hypotheses and the separately reviewed source-mediated constructions
must remain visible even when the algebraic claim has kernel evidence.

In particular, one local unit multiplier is not the canonical isomorphism
\((R^ih_*\mathcal O_Z)\otimes_R M\to
R^ih_*(h^*\widetilde M)\) for every module \(M\).
Actual coefficient realizations, ordinary tensor-compatible chain
homotopies, and descent across overlaps and thickenings remain distinct
obligations in `ordinary-base-change/report.md`.
No projective-space-base or strong-SYZ theorem follows from this unit alone.

Relative to the strongest prior draft, the conclusion is unchanged. The
review sharpens its support boundary by making \(\psi_h(1)=\delta\ne0\),
coefficient stability, the source-version distinction, and the independent
geometric obligations explicit. It asserts no novel theorem.
