# Ordinary coefficient base change: the scope beyond clearing

## Exact old claim and reference source

**Engineer assessment: partial support.** `C_ORDINARY@1` records the assertion of Proposition `bc:ordinary`, not an independently proved arbitrary-module base-change theorem. The checked, supported portion is the ordinary homotopy criterion and the conditional coefficient-complex route. Establishing that route on the geometric charts, with its descent and simultaneous reduction data, remains beyond the old local clearing certificate.

The source is *Projective-Space Bases of Lagrangian Fibrations*, `build/source/sections/05-base-change.tex`, with necessary chart and coefficient setup in `02-setup.tex`, `03-local-tensor.tex`, and `04-stratum.tex`. All TeX references here are at **revision `4eaee87548250b2682affda7d05d947c05554bae`**, in the declared root `openai-math/preprints/Projective-Space-Bases-of-Lagrangian-Fibrations-September-23-2026`. The old staging tree resolves to that root. These are manifest-matched **reference manuscript versions, not preserved Argus snapshot members**. Hash reconciliation is inherited from the current inventory; it establishes the reference version, not theorem validity.

This review reads the ordinary-complex and tensor prerequisites, the final ordinary-base-change proposition, and the chain-map compatibility that connects a clearing unit to a homotopy splitting. It does not reassess the separate differential-operator identity, Frobenius-duality trace construction, or completed rational field-trace argument. Their requisite scalar identities are treated as conditional inputs.

## Quantifiers and geometric hypotheses

Proposition `bc:ordinary` does **not** assert the result over every characteristic or for arbitrary maps from symplectic manifolds. After finite characteristic-zero preparation, any fixed finite enlargement of the algebraic/coherent data, and an allowed nonempty principal localization, it asserts suitable number-field models and geometric reductions in arbitrarily large residue characteristics. On every chart of the finite retained cover one requires
\[
\psi_X(1)=\delta\in k^*,\qquad p>e_\mu,\qquad p>o_g.
\]
Here \(e_\mu\) is the generic degree of the fixed Noether normalization and \(o_g\) the ordinary differential-order bound for the fixed clearing factor. The surrounding preparations retain the identities, geometric properties, and invert the finite deck-group orders.

On **each such reduction**, for **every \(R\)-module \(M\)** and **every degree \(i\)**, the canonical map is
\[
(R^ih_*\mathcal O_Z)\otimes_R M
\longrightarrow R^ih_*(h^*\widetilde M).
\]
Both tensor and pullback are ordinary. No finite-generation, support, or flatness hypothesis is placed on \(M\) for this chartwise statement. The neighborhoods and the reduction are selected before \(M\).

The retained chart is not an arbitrary singular base: `loc:maximal-charts` and the opening of §05 provide a normal affine chart \(C=\operatorname{Spec}R\), a smooth canonical-trivial source \(Z\) of dimension \(2n\), and a projective, equidimensional map \(h\) of relative dimension \(n\), with connected fibers and \(h_*\mathcal O_Z=\mathcal O_C\). The normalized source maps étale to the original source. A finite projection \(\pi:Z\to Y=\mathbb P^n_R\) and a finite dominant smooth slice \(\operatorname{Spec}E\to\operatorname{Spec}R\) are chosen. The finite algebras \(\mathcal V=\pi_*\mathcal O_Z\) and \(E_Y=E\otimes_R\mathcal O_Y\) have regular total spaces. Neither \(E\) nor \(h\) is assumed flat over \(R\).

The Euler consequence has narrower coefficient quantifiers: \(M\) is **coherent**, supported on **some finite thickening** \(\mathcal S_k\) of the smooth stratum stack inside the formal ambient system. One reduction is asserted to work for all such \(M\) and all \(k\). Their supports are proper, so the coherent Euler characteristics exist. This is not an Euler statement for unrestricted infinite modules.

## What the ordinary-complex argument actually establishes

Lemma `bc:homotopy-criterion` is a valid elementary conditional statement: actual \(R\)-linear chain maps and chain homotopies realizing \(C\simeq D_0\), with \(d_{D_0}=0\), remain homotopy inverses after ordinary tensoring with any \(M\). For \(D_0\), the natural cohomology-coefficient map is the identity. Naturality transfers that conclusion to \(C\). No flatness of \(M\), \(D_0\), or \(C\)'s terms is needed. A quasi-isomorphism in a derived category alone would not justify this operation.

The manuscript deliberately supplies additional machinery to construct such a complex. Equation `bc:additive-generator` requires \(\mathcal V\) locally in \(\operatorname{add}(E_Y)\). With \(\mathsf H=\operatorname{End}_R(E)\), evaluation `bc:evaluation` identifies
\(\mathcal P\otimes_{\mathsf H_Y}E_Y=\mathcal V\), where \(\mathcal P=\mathcal Hom(E_Y,\mathcal V)\) is locally finite projective on the right over \(\mathsf H_Y\).

Lemma `bc:uniform-twists` uses locally split \(\mathsf H_Y\)-resolutions and flatness of \(\mathsf H_Y\) as a right \(\mathsf H\)-module, coming from \(Y/R\) being flat. This is a different flatness assertion from flatness of \(E/R\). It produces a twist bound independent of every left \(\mathsf H\)-module \(Q\). Applying it to \(Q=E\otimes_RM\), the split Koszul coresolution gives `bc:ordinary-complex`. The Čech/Koszul augmentation and multiplication by \(m\in M\) explicitly provide `bc:canonical-compatibility`. Thus the desired map is the **canonical** coefficient map, not an unspecified abstract isomorphism of modules.

The comparisons between Koszul exponents are actual homotopy equivalences over \(\mathsf H\), constructed **before** tensoring with \(E\). Equations `bc:power-comparison`, `bc:cleared-homotopy`, and `bc:transported-homotopy` retain the same factor \(g\). This is the required protection against silently tensoring a derived comparison by a possibly nonflat \(E\).

## Concrete obligations not supplied by the local certificate

1. **Coefficient realization and its flatness mechanism.** On the retained geometric charts, establish the finite-regular-algebra comparison `bc:finite-modules`, hence the additive generator, evaluation, and locally split resolutions used for `bc:ordinary-complex`. The local identity \(\psi(gt)=\psi(1)\) says nothing about \(\mathcal V\), the \(\mathsf H\)-projective complexes, or a bound valid for all coefficient modules. The needed flatness is over the auxiliary coefficient algebra; imposing \(M\)-flatness would weaken, not prove, the actual claim.

2. **A scalar unit must become a chain-level splitting.** In `bc:frobenius-koszul` and `bc:pushed-homotopy`, the pushed map \(F_*\mathsf m_g\) is not scalar multiplication by \(g\) on the Frobenius module: the latter uses \(g^p\). The source explicitly distinguishes them. Equation `bc:cartier-composite` requires sheaf maps whose composite is exactly \(u\,\mathrm{id}_{\mathcal V}\), where \(u=\psi_h(gt)\) is a unit, and natural lifts of those maps to the same Koszul complex. Only then can the pushed homotopy be composed and divided by \(u\). The subsequent idempotent argument genuinely splits a homotopy retract. Clearing alone neither constructs these sheaf/chain maps nor verifies their compatibility.

3. **Tensor fixed parts and ordinary descent are additional geometry.** In `str:products`, the source étale torsors and normalized overlaps descend ordinary pullback to the schemes \(X_k\); they do not identify \(X_k\) with an arbitrary coarse fiber product. The fixed global \(\phi_j\)'s extend reflexively in `str:direct-images`. For the tensor coefficient calculus, `str:barred-hom` and `str:uniform` must transport ambient mixed tensors, Hom, trace kernels, and residual idempotents under flat transverse extension and compatible overlaps. The residual tensor invariants are not the full internal End representation (`loc:tannakian`). Moreover, §04 explicitly warns that the map from truncated **ambient** End to **full** \(\operatorname{End}_{\mathcal S_k}\) need be neither injective nor surjective. A scalar clearing witness cannot identify those objects or descend their fixed parts.

4. **Simultaneity must precede coefficients.** The finite diagrams, canonical identifications, and module-independent splitting neighborhoods must survive one permitted reduction; ideal-preserving overlap maps must work for every \(I^k\). The manuscript explains this through finite marked-product data and uniform twists, not by spreading infinitely many individual modules. This stronger statement still needs justification independently of the local certificate.

These are specific missing bridges in the **old evidence's supported scope**, not a claim that the manuscript lacks proof paragraphs or that its proposition is false. The reference supplies intended arguments for each bridge. The present review identifies their hypotheses and the reason the local certificate does not settle them. No admissible counterexample or decisive invalid argument has been established, and no computation was run: the old algebraic executable would not certify these constructions. Native independent review is required and pending.
