# Primary propositions used in the review

These are source readings, not an independent mathematical verdict or an
automated `citation_check attribute` record. The dedicated primary-source
reader obtained the public sources below; the Engineer compiled its returned
readings here. Mathematical formulas below state the propositions; explanatory
sentences are paraphrases, not purported verbatim quotations.

## Mellit, published version

Source: [*Toric stratifications of character varieties*](https://pmihes.centre-mersenne.org/item/10.1007/s10240-025-00158-0.pdf),
`doi:10.1007/s10240-025-00158-0`, published 2025.
Do not substitute numbering from *Cell decompositions of character varieties*,
`arxiv:1905.10685v1`.

Definition 4.9, printed p. 192: genericity excludes product-one choices of
\(r\) eigenvalues at each puncture, for every \(1\le r<n\), together with
the total determinant constraint. The extracted determinant display has an
index discrepancy; the introduction p. 153 and section 8.1 p. 227 give the
intended product over all punctures. This review uses the consistent total
determinant condition, not that extraction discrepancy as a new objection.

Proposition 6.10, pp. 213-214: the connectedness/scalar-stabilizer condition
identifies the torus image with
\(\{t:\det t=\operatorname{sign}(\pi)\}\). The determinant-one image used in
section 8 is the relevant special case, not a general replacement of that
formula by \(\det t=1\). Proposition 6.12 selects the connected strata over
generic fibers.

Theorem 6.14, p. 215, gives the braid variety's curious Lefschetz middle
weight \(\ell(\beta)-n-c(\beta)+2\) for generic parameter.
Sections 7.2 and 7.4, pp. 217 and 225-226, use distinct last eigenvalues
and construct a rank \(r=\binom n2\) auxiliary vector bundle.
Theorem 7.5 has generic, nicely ordered diagonal puncture data and
**distinct last eigenvalues**. For original regular flagged fiber dimension
\(\delta\), the common compact-support middle actual \(W\)-index on the
auxiliary refinements is \(\delta+2r\). The rank shift must not be discarded
or interpreted as a half weight.

Sections 8.1-8.2, pp. 227-228, define the generic ordered parameter base
without requiring distinct eigenvalues. The flagged family allows
nonsemisimple last monodromy at collisions. Proposition 8.7 and its proof,
p. 233, give local constancy of compact-support cohomology and of its weight
gradeds. The proof uses a rank-\(\binom n2\) **affine** bundle and then
vector-bundle refinements over
\[
Z\simeq\mathbb A^a\times(\mathbb C^*)^{t-n+1}\times V,
\]
with map to \(V\) the projection. Here \(t\) is the local torus-dimension
symbol in the proof, not the auxiliary rank. This is a product description
of the **bases of refinements**, not an assertion that all total vector
bundles are algebraically trivial. The relative proposition and the
distinct-eigenvalue theorem are different assertions.

Proposition 8.7 itself is not a statement that the structural morphism
\(\chi_F:X_{\rm sm}\to V\) is smooth. The old report supplies a separate
commutator-submersion/free-quotient argument; the application must use that
argument rather than ascribe it to this proposition.

Section 8.5, pp. 236-237, computes
\[
\nabla[\omega]=2\sum_i d\log t_i\otimes c_1(L_i)
\]
and states flatness modulo \(W_2\). Thus transport preserves the image in
\(\operatorname{Gr}^W_4H^2\), not necessarily the whole \(H^2\)-class.
Theorem 8.13 is the paper's general generic-case conclusion; citing it
alone would still not remove the need to justify passage to the particular
finite cover with all deck characters.

**Reading outcome:** supports the distinct/relative distinction and the
stratification inputs at their stated scopes. Smoothness of the family's
structural map needs the separate geometric argument. The collision
numbering in `arxiv:1905.10685v1` is historical attribution in the old notes;
that preprint was not separately opened in this source-reading task.

## de Cataldo--Maulik--Shen, version 1

Source: [arXiv PDF 2002.03336v1](https://arxiv.org/pdf/2002.03336v1),
dated 2020-02-09, setup pp. 2-5. A nonsingular projective complex curve has
\(g\ge2\), \(n\ge2\), and \(\gcd(n,d)=1\). The smooth fixed-determinant
SL moduli spaces carry \(\Gamma=\operatorname{Pic}^0(C)[n]\).

Theorem 0.2, p. 2, asserts variant \(P=W\) for **prime** \(n\).
Proposition 1.2, p. 5, deduces \(P=W\) on the **invariant** SL summand from
GL\(_n\) \(P=W\) for the same curve and degree.
Neither assertion supplies composite-rank variant \(P=W\).

Proposition 1.4, pp. 5-6, holds for arbitrary \(n\ge2\). If \(p\) is the
smallest prime divisor of \(n\), then
\[
P_{k-n(n-n/p)(g-1)}H^k_{\rm var}(M_{\rm Dol},\mathbb Q)
=H^k_{\rm var}(M_{\rm Dol},\mathbb Q).
\]
With the normalized filtration's negative range zero, this yields the
low-degree variant vanishing used in the old report. It is a filtration
bound, not an all-degree variant comparison theorem.

**Reading outcome:** supports all three proposition-level uses with the
prime/invariant/arbitrary-rank scopes separated.

## Maulik--Shen, final preprint version 2

Source: [arXiv PDF 2209.02568v2](https://arxiv.org/pdf/2209.02568v2),
dated 2024-05-17. The opening setup is smooth coprime degree and \(g\ge2\).

Section 2.1, pp. 8-9, forms the quotient
\(\widehat M_{\rm Dol}=\check M_{\rm Dol}/\Gamma\) and its projective universal
bundle. Theorem 2.1(i) says that the projective tautological classes
\[
c_k(\gamma)=q_{M*}\big(q_C^*\gamma\,\operatorname{ch}_k(\mathcal U)\big),
\qquad k\ge2,\quad \gamma\in H^j(C),
\]
generate \(H^*(\widehat M_{\rm Dol},\mathbb Q)\).
Their degrees are \(2k+j-2\). Consequently all generators have degree at
least two and there is at most one degree-two generator, \(c_2(1)\).
This is quotient/invariant generation, not full SL generation.
Theorem 0.3, pp. 1-3, also states prime-rank SL \(P=W\) in the coprime setup.

**Reading outcome:** supports the invariant low-degree use and prime-rank
background; the separate arbitrary-rank variant bound is still necessary.

## Maulik--Shen, published Annals abstract

Source: [Annals 200 (2024), pp. 529-556, abstract](https://annals.math.princeton.edu/2024/200-2/p03),
`doi:10.4007/annals.2024.200.2.3`.
The abstract states GL\(_n\) \(P=W\) for all ranks and curves of genus at
least two. The abstract does not itself spell out coprimality; the version-2
preprint setup above does.

**Reading outcome:** supports the all-rank published baseline, not a full
fixed-determinant composite-rank variant theorem. Published full text
redirected to a bot challenge; the abstract and the precisely versioned
primary preprint were accessible. No inaccessible full-text passage is
claimed to have been read.
