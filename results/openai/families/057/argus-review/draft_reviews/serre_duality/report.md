# Bundle-dual star and the complete reversed complex

**Assessment:** `L_SWI_DUALITY@1` is supported with completeness and the
already established exactness/closed-range hypotheses. The primary-source
reading supports the manifold maximal/minimal statements, not an unqualified
incomplete-domain identification or an orbifold theorem by attribution.
Native independent acceptance remains pending.

## Exact statement and source version

The old subject hash is
`232a209ec94aed650f863256009dd24d54978ee4422755cf76c50d75e429ff6c`.
The old draft's Section 6 asserts an isometric conjugate-linear
bundle-metric Serre star from

```text
L=E^*, (m,q), full coefficient metric G0*h
    to E, (0,m-q), reciprocal coefficient metric G0^(-1)*h^(-1).
```

It transfers the closed-domain exact complex, closed ranges and reduced
inverse bounds. The manuscript already invokes this transfer in
`spectral.tex:490-499` at revision
`4eaee87548250b2682affda7d05d947c05554bae`; the old Argus text expands its
domain justification. Neither claims a new Serre-duality theorem.

The cited source is Chakrabarti--Shaw, *L2 Serre Duality on Domains in
Complex Manifolds and Applications*, `arxiv:1006.3117v2`, printed version
December 3, 2010. The source reader independently extracted the retained PDF;
the fresh extraction is byte-identical to the old text and contains that
version stamp. PDF conversion metadata is from 2018 and is not mistaken for
the mathematical version date.

The actual passages read, including hypotheses and degrees, are in
`source_excerpt.txt`. The official independent source attribution is
`reader:duality-source-reader`, archived as
`research/literature/fcfec01ac50ee205b27e0ace2ec45a71.json`, against current
claim `R057_DUALITY`, assumption `A_CS_DOMAIN_DUALITY`. This source reading is
not the native final review of this unit or the family.

## What the source actually says

The source works on a smooth Hermitian complex manifold with a Hermitian
holomorphic bundle and its induced dual metric. Lemma 2 in Section 2.4
gives the formal bundle-dual star identities. Proposition 1, Section 3.1,
is the closed-domain statement:

- The Hilbert adjoint of **maximal** Dolbeault is transformed into
  **minimal** Dolbeault on the dual bundle.
- **Maximal** Dolbeault is transformed into the **Hilbert adjoint of
  minimal** Dolbeault on the dual bundle, the maximal formal adjoint.

These are not assertions that arbitrary maximal and minimal domains agree.
In particular, the phrase "minimal adjoint" in the review ledger's short
assumption is read as **adjoint of minimal Dolbeault**, not as the minimal
realization of the formal adjoint. The independently archived reading
explicitly disambiguates it.

The Section 3.2 observation identifies minimal and maximal Dolbeault when
the manifold itself is compact or complete. Completeness of an ambient
manifold is not completeness of every domain within it. Lemma 3 in
Section 3.3 transfers closed range in the appropriate complementary
degrees. It does not derive closed range from completeness. The source's
solvability discussion retains range/annihilator compatibility conditions;
it does not solve every closed form on an arbitrary Hermitian manifold.
The old draft has the extra exactness hypothesis needed to eliminate
cohomological obstructions.

The old source-status list also mentions Section 3.2 Theorem 1. The support
needed here is already furnished by the explicit operator/domain identities,
the complete-manifold observation, closed-range equivalence and the
Hilbert-complex argument below; no stronger unexamined consequence of that
theorem is imported.

## Direct specialization to the old complex

In a local line frame with squared full metric `G`, the coefficient part
of the bundle-dual star sends `f` to `G*conjugate(f)` in the dual frame.
Its dual squared norm is
`|G*conjugate(f)|^2/G=G*|f|^2`. Together with the form-star isometry this
proves that the map `J_h` is an isometry, including both the base coefficient
metric and the scalar multiplier. Forgetting the coefficient metric would
not give the asserted reciprocal-metric map.

Stokes' identity with one compactly supported input yields, with the
degree signs,

\[
 J_h d_h^*=\mathord{\pm}d_{\rm dual}J_h,\qquad
 J_h d=\mathord{\pm}d_{\rm dual}^*J_h.
\]

The degrees reverse: `(m,q)` goes to `(0,m-q)`, so the former identity
raises dual degree and the latter lowers it. In this **complete** setting
the core/cutoff proof in `../complete_domains/report.md` identifies minimal
and maximal differentials for each of the full smooth metrics. Applying
the local identities to the cores and closing their graphs gives exactly
the corresponding closed-domain identities.

The local integration identities remain valid on finite orbifold charts,
after taking invariant lifts; the same finite chart integration factors
occur on both sides. Averaging the compact-support approximations gives
invariant smooth cores. This is the draft's argument for the orbifold
specialization. It is not falsely attributed to a manifold-only source.

For an exact closed-range complex, the adjoint complex is exact as well:

\[
 {\rm im}\,d_q^*=(\ker d_q)^\perp
 =({\rm im}\,d_{q-1})^\perp=\ker d_{q-1}^*.
\]

The first equality uses closed range. Thus the star identifies an exact
reversed adjoint complex with the desired dual differential complex.
The endpoint is included: surjectivity of the original last differential
implies injectivity of its adjoint, giving zero degree-zero dual kernel.

The reduced inverses of a closed-range operator and its adjoint are Hilbert
adjoints on the respective kernel complements. Equivalently, if `V` is the
minimal inverse of `d`, the domain-correct identity
`d_h^*V^*u=u` on the source kernel complement exhibits `V^*` as the
reduced inverse of `d_h^*`. Hence their norms are equal. Conjugation by
the anti-isometric `J_h` preserves the norm, so no additional `S`, `b`
or multiplier factor enters. This transfers the quantitative estimate
without changing its constant.

## Findings, history and limits

No unsupported domain identification, degree reversal or extra norm factor
was identified within the complete-orbifold specialization as written.
The explicit analytic core and Hilbert-complex arguments, not just source
quotation, supply the specialization and exactness.

The old Reviewer-support evidence
`judgement-L_SWI_DUALITY-1d7ef573e28a` names the same old subject and
`proof.md`. It is consistent with the statement assessed here; the graph
still says pending review. As for the other prose judgements, its path
reference does not archive the exact proof bytes it historically read,
and neither old label constitutes current acceptance.

The remaining limits are concrete: this source alone supplies no orbifold
extension; completeness alone supplies no closed range or vanishing
cohomology; the scalar Lean source supplies none of these identities.
Those analytic hypotheses were supplied/assessed elsewhere, not silently
asserted by this source. There is no unresolved internal duality obligation
identified under them. No claim is made about general incomplete domains,
downstream abelianity, or novelty. The old result is a standard-domain-duality
application; the review's novelty status is `not_applicable`.
