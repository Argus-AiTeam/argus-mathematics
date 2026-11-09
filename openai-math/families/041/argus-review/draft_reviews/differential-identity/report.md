# Differential identity: bounded old-draft assessment

**Unit:** `differential-identity`; `C_DIFF@1`, `C_DIFF@2`, `C_DIFF@3`.  
**Assessment:** `supported_scope`, for the conditional statement below. Exploratory Engineer assessment only; native independent review remains `required_pending`. No novelty is asserted.

## Claim, hypotheses, and evidence boundary

The claim is that the fixed nonzero clearing factor \(g\) admits, on a finite principal-open cover of \(P=\mathbb A^n_{\mathbb C}\), identities
\[
 \eta=\sum_j D_j(gt_j\eta),\qquad
 D_j=\sum_{|\alpha|\le o_g}c_{j,\alpha}(u)\partial_u^\alpha,
\]
where \(t_j\in R\), every coefficient is regular on its specified open, and one finite order bound \(o_g\) works for the cover. The identity is in generic middle relative de Rham cohomology, not an assertion that the relative frame extends regularly across every singular fiber.

The necessary chart hypotheses are: \(R\) is a normal integral finite-type \(\mathbb C\)-algebra of dimension \(n\); \(h:Z\to\operatorname{Spec}R\) is projective, dominant, and equidimensional of relative dimension \(n\); \(Z\) is smooth and integral of dimension \(2n\); \(h_*\mathcal O_Z=\mathcal O_{\operatorname{Spec}R}\); and a nowhere-zero volume form \(\sigma_Z\) trivializes \(\omega_Z\). A finite dominant Noether normalization \(\mu:\operatorname{Spec}R\to P\) has a nonzero \(\Delta_\mu\) over which it is finite étale and free of rank \(e_\mu\), and \(h\) is smooth there. Set \(a=\mu h\), \(du=du_1\wedge\cdots\wedge du_n\), and \(\eta=\sigma_Z/du\) on that smooth locus. Thus \(a\) is projective between smooth complex algebraic varieties. The input Hodge module is the constant polarizable pure one, not an arbitrary filtered module.

The old argument reviewed is **only** `9000041/research/cartier-clearing/proof.md:122–175`. The manuscript locators are `build/source/sections/05-base-change.tex:11–21`, `458–556` (especially `bc:differential-identity`, `bc:lowest-filtration`, and `bc:operator-bound`), and the directly relevant retention discussion at `558–595`. The source root is `openai-math/preprints/Projective-Space-Bases-of-Lagrangian-Fibrations-September-23-2026`. The reference manifest in campaign `9100041` assigns revision `4eaee87548250b2682affda7d05d947c05554bae`; the parent already checked its thirteen TeX hashes. The old staged manuscript root is a symlink to this reference source, **not an immutable historical manuscript snapshot**. This assessment does not reconstruct what an earlier manuscript revision said.

## Primary-source checks and attribution

Saito, *A young person's guide to mixed Hodge modules*, **arXiv:1605.00435v3, 8 June 2016**, Theorem 1.4, gives strict filtered direct image and pure cohomology for a projective morphism of smooth complex algebraic varieties with polarizable pure input. The theorem credits the earlier Saito Theorem 5.3.1. Section 1.2 requires strict support for the underlying complex \(\mathcal D\)-module **as well as** the rational object: there are no subobjects or quotients on smaller support. Appendix B.2 places the right-module top forms in filtration degree \(-\dim Z\); the unfiltered symbol \(\omega_Z\) must not be confused with a dualizing sheaf artificially assigned filtration degree zero. B.3 gives graph-embedding/projection direct-image conventions. Convention 2 explains passage from analytic to algebraic filtered modules. These statements were checked in the archived full text, lines `20`, `45–52`, `80–129`, and `562–608`, not inferred from a citation label.

Deligne, *Théorie de Hodge II*, Publications Mathématiques de l'IHÉS **40 (1971), 5–57**, DOI `10.1007/BF02684692`, printed pp. **43–45**, provides the needed algebraic monodromy semisimplicity. Conditions 4.2.2 require closure under direct factors, sums and tensor products with Tate objects, polarizability of homogeneous objects, integral lattices, and the fixed-part condition. Definition 4.2.4 and Proposition 4.2.5 place smooth proper algebraic direct images in this category; Theorem 4.2.6 then makes the underlying rational monodromy representation semisimple on a connected, locally connected, locally simply connected base. A connected smooth algebraic open has these topological properties. The short archived excerpt omits the actual theorem; the full OCR text `deligne-hodge-II.txt:1789–1876` supplies it.

The inherited attribution records `a4bbd07bdbd0ddf3e847ac03321415af.json` and `8772a75b87aec3848b01f7e44c46f796.json`, under active `research/draft_reviews/inherited/literature/`, remain unchanged. Their recorded source support concerns the propositions, not certification of every geometric premise or acceptance of this review. Saito/Deligne results are known source results; their application here is the manuscript/Argus instantiation.

## Decisive argument

Let \(d=2n\). In the right transfer Spencer resolution, the degree \(-i\) term has filtration contributions
\[
 F_{q-i-\ell}\omega_Z\otimes \bigwedge^i T_Z
       \otimes a^*F_\ell\mathcal D_P,\qquad \ell\ge0.
\]
At \(q=-d\), the source filtration vanishes unless \(i=\ell=0\). The lowest filtered complex is therefore \(\mathbf Ra_*\omega_Z\), with \(\omega_Z\) initially in degree zero. Strictness is the essential step identifying the image of its cohomology with the filtration on direct-image cohomology:
\[
 F_{-2n}\mathcal H^0(a_+\omega_Z)
   =\mathcal H^0(\mathbf Ra_*\omega_Z)=a_*\omega_Z.
\]
This does not require \(a\) to be smooth on the discriminant.

Multiplication by a nonzero base function is injective on \(\omega_Z\), since the integral source dominates \(P\). Consequently \(a_*\omega_Z\) is torsion-free. In the filtration-compatible strict-support decomposition its summands on proper supports vanish. Changing right modules to left modules tensors with \(\omega_P^{-1}\), and identifies this sheaf with \(R\eta\) inside the full-support part \(M\) of the degree-zero direct image. Generically, the relative dimension \(n\) identifies \(M\) with \(n\)-th relative de Rham cohomology.

On the **algebraic** smooth open the relevant local system is a smooth proper geometric direct image, so Deligne's theorem applies. Its semisimple local-system decomposition passes to regular holonomic minimal extensions; these simple constituents all have full support. This is not an inference from polarizability of a local system on an arbitrary small analytic open.

Inside \(M\), let \(U=\mathcal D_P(R\eta)\) and \(U_g=\mathcal D_P(gR\eta)\). Generically \(R\otimes_{\mathbb C[u]}\mathbb C(u)=\operatorname{Frac}R\), in which multiplication by \(g\) is invertible. Thus \(U\) and \(U_g\) have identical generic restrictions. Their quotient has proper support. Semisimplicity makes any subquotient a sum of full-support simple constituents, so that quotient is zero. Hence \(\eta\in U_g\).

Local membership involves finitely many operators and local sections of \(R\). On \(D(f)\) such a section is \(r/f^m\). Composing its operator with multiplication by \(f^{-m}\) absorbs this denominator, keeps all coefficients regular on \(D(f)\), and does not increase order. Thus \(t_j\) can be taken in \(R\). Quasi-compactness supplies a finite principal cover and a finite maximum order. This proves the claimed conditional identity.

## Exact input supplied to clearing, and limits

On a retained characteristic-\(p\) fiber, choose an operator open \(D(f)\) containing \(\mu(b)\). The coefficient ring
\[
 B=k[u_1,\ldots,u_n]_f\subset R_b\subset K_0=\operatorname{Frac}R
\]
is derivative-stable: \(\partial_i(r/f^m)=(f\partial_i r-mr\partial_i f)/f^{m+1}\). Enlarging to \(k[u]_{\mu(b)}\) retains this property. Regularity is on the smooth **base**, so no assertion \(\partial_i(R_b)\subset R_b\) is needed. This distinction supplies the coefficient-stability hypothesis of the adjoint application even when \(R_b\) is singular.

Retaining the nonzero étale discriminant makes \(K_0/k(u)\) finite separable; over perfect \(k\), \(u_1,\ldots,u_n\) are consequently a \(p\)-basis of \(K_0\). Retained finite ordinary-operator expressions with \(p>o_g\), their denominator units, the cover identity, and de Rham/connection base change give the reduced identity. Saito's characteristic-zero theorem is not being asserted in characteristic \(p\).

There is no unresolved step within this conditional argument. **Independent application obligations remain:** the earlier chart construction must actually supply the stated smooth integral volume-form charts and \(h_*\mathcal O_Z=R\); a common model must retain those properties and the de Rham identities on the chosen fibers; and the separate Cartier-prime input must supply \(\psi_h(1)=\delta\in k^\times\). Those are not established by Saito's citation, this local identity, or an algebraic checker. Ordinary coefficient base change and the projective-base theorem remain outside the supported scope.
