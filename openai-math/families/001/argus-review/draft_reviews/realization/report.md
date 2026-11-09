# Prescribed filtration with one algebraic marking

**Engineer assessment:** the existing argument supports PF-REALIZATION
relative to the stated geometric theorems, with the characteristic-two
restrictions retained. It is not a kernel proof of geometry, a verification
of the entire manuscript, or a new theorem/novelty claim.
**Independent acceptance:** pending the native Host-invoked Reviewer.

## Statement, attribution, and versions

Write `A = research/prescribed-filtration-audit/` and
`B = research/openai_manuscript/Milnes-rationality-conjecture-for-abelian-varieties-October-7-2026/build/`.
All `A`, `B`, and source-text line references below are in the immutable
campaign `9000001`, not in this review's writable directory.

The source claim is OpenAI's October 7, 2026
`B/sections/02_transport.tex:330-352`, `lem:admissible-realization`;
its proof ends at line 574. The reference TeX matches the revision recorded
in the supplied manuscript manifest,
`4eaee87548250b2682affda7d05d947c05554bae`. The Argus draft is
`A/realization_proof.md`, especially Steps 1-5. Its explicit propagation
argument is an elaboration of the manuscript's invocation of marked
uniformization, not a separately established novel result.

Let \(k=\overline{\mathbf F}_p\), \(K_0=\operatorname{Frac}W(k)\).
Assume:

1. \((J,X_J,\mathcal J)\) is strongly admissible in **Kisin-Zhou
   arXiv:2505.02165v1, Definition 2.1.6**, with its adapted closed
   self-dual Hodge embedding, connected full stabilizer model, and
   sufficiently small neat prime-to-\(p\) level. In particular the
   centralizer condition is R-smooth, and at \(p=2\) the relative roots
   over \(\breve{\mathbf Q}_2\) are reduced.
2. \(J_{\mathbf Q_p}\) is quasi-split, \(x\in\mathcal S_K(k)\) has a
   characteristic-zero lift, and \(C_x\) is the corresponding abelian
   variety with its canonical defining tensors.
3. A filtration \(\mathcal F\) on
   \(D_x=H^1_{\mathrm{cris}}(C_x/W(k))[1/p]\), over a finite
   extension \(K/K_0\), is admissible as a faithful filtered isocrystal
   and geometrically lies in the prescribed \(J\)-cocharacter orbit.

The conclusion is that, after a **finite** further extension, there are a
point \(y\in\mathcal I_x\), a lift \(\widetilde y\), and **one algebraic
quasi-isogeny** \(b:C_x\longrightarrow C_y\) such that it preserves the
canonical crystalline tensors and every prime-to-\(p\) defining tensor and

\[
 b^*\operatorname{Fil}^1H^1_{\mathrm{dR}}(C_{\widetilde y})
       =\mathcal F^1.
\]

Here \(\mathcal I_x\) means the simultaneous tensor isogeny class, not a
product of unrelated local isomorphism classes
(`B/sections/02_transport.tex:307-329`;
`KZ-2505.02165v1.txt:652-685`, section 2.2.4 and Theorem 2.2.5).
Defining invariant tensors and any included rational \(J\)-invariants
are the scope of tensor preservation. This is not an assertion that
arbitrary polarization classes are fixed without their similitude
normalization; the latter is the separate MR-NORMALIZATION claim.

The ledger contains PF-REALIZATION v1, PF-FLAG v1-v2,
PF-INTEGRAL v1-v4, and PF-SAME-MARKING v1-v2. Their natural statements do
not change. The later versions add the named assumptions: PR-ADMISSIBLE;
KZ-MODEL, then GLX-UNIFORMIZATION, then PR-MARKED-PULLBACK; and
GLX-COMPONENTS, respectively. They are versions of four assertions,
not nine independent results.

## Source applications actually checked

These are external mathematical inputs, not consequences of the Python
or Lean computations. The supplied versioned primary texts were opened
at the following locators; no current web version was substituted.

| Input and exact version | Source passage read, including the relevant hypotheses | Application |
|---|---|---|
| Kisin-Zhou, arXiv:2505.02165v1, Definition 2.1.6 and Proposition 2.1.9 | `KZ-2505.02165v1.txt:334-398`: full connected stabilizer, R-smooth centralizer, and "If p = 2, then the relative root system ... is reduced"; the proposition gives a closed embedding on a self-dual lattice | The integral level is the stipulated one, not an arbitrary stable lattice |
| Same, Theorem 2.1.12 and sections 2.1.13-2.1.14 | `:439-526`: "Let ... be a strongly admissible triple"; part (3), for neat level, identifies completions and says pullback of the canonical shtuka is the tautological shtuka; section 2.1.14 gives the dual/Frobenius descent and \([b_x]\in B(J,\mu^{-1})\) | Correct integral model, tensor-compatible faithful abelian realization, and Kottwitz invariant |
| Pappas-Rapoport, arXiv:2106.08270v6, section 3.1.1 and Proposition 3.1.1(i), (3.1.9) | `PR-2106.08270v6.txt:2853-2890,2924-2975`: assume connected special fiber and \([b]\in B(G,\mu^{-1})\); (i) assumes \(\rho^{-1}(Z_{G'})\subset Z_G\); admissible sets are the images of the etale crystalline period maps | Detect admissibility in the faithful GL realization and lift the specified period, not merely some admissible period |
| Same, Proposition 3.5.1 | `:3896-3937`: assuming the formal model under discussion, (i) identifies the generic fiber, (ii) identifies the perfect reduced fiber with the ADLV, and (iii) identifies specialization with Breuil-Kisin specialization | The chosen generic point and its special lattice belong to the same framed object |
| Same, (4.1.1), Definition 4.5.1, section 4.5.2, Theorem 4.5.2 | `:4447-4468,4972-5077`: equal rational/real split ranks of the connected center; global Hodge type uses a full connected Bruhat-Tits stabilizer; the adapted immersion and canonical model are specified | Check applicability instead of silently importing a hyperspecial or odd-prime theorem |
| Same, section 4.10.1 and Lemma 4.10.2 | `:5955-6080`: the marked Siegel pullback has a universal \(p\)-divisible quasi-isogeny; equality \(t_{a,\mathrm{crys}}=q^*t_{a,\mathrm{crys},0}\) cuts out the open-and-closed RZ part; its map respects the framed \(G\)-shtuka | Retain both the point and its marking, not only its image in the global model |
| Gleason-Lim-Xu, arXiv:2208.07195v3, Corollary 6.3 and proof | `GLX-2208.07195v3.txt:2061-2208`: start with a tuple of global Hodge type and the dilated Hodge immersion; "The map c ... is an isomorphism"; the proof constructs compatible actual at-\(p\) Hecke points in the marked pullback | Discharges PR's condition \(U_x\), including the exact marked comparison |
| Same, Corollary 3.13 | `:1159-1177`: "For any point x" at the given parahoric level, specialization of the \(G(\mathbf Q_p)/K_p\) orbit surjects on the connected components of the ADLV | A common supply of simultaneous good witnesses for every component |

These passages support the old recorded assumptions. The old ledger's six
source judgements are historical reader opinions and have no archived
`citation_check attribute` excerpt receipts in the supplied inventory;
they were not mistaken for new independent acceptance. The passages above,
with their hypotheses and exact versioned text files, are the present
source reading. This review does not modify or retrospectively close the
old citation ledger.

## Decisive argument and possible failure points

### 1. The hypotheses really supply this model and this period problem

A closed embedding on a self-dual symplectic lattice factors through its
similitude stabilizer integrally. The generic similitude identities extend
by flatness, and applying the same identities to the inverse makes the
multiplier a unit. The schematic closure is \(\mathcal J\) itself, so the
adapted embedding is a special case of the dilated immersion used by PR.
If PR's lattice-chain construction repeats a faithful representation,
this does not replace the original abelian marking: the canonical shtuka
and its faithful vector realization are compared with the given universal
abelian family by KZ sections 2.1.13-2.1.14 and PR Theorem 4.5.2. Merely
claiming independence of integral models without this vector comparison
would not be enough.

The center-rank check in Step 1 is valid. For the connected real center,
the kernel of the similitude character commutes with \(h(i)\) and preserves
the definite form \(\psi(v,h(i)w)\). Its faithful image is compact, so the
real split rank is at most one. The rational Hodge weight torus supplies a
nontrivial rational split direction, on which the multiplier is \(t^2\)
or \(t^{-2}\). Thus both split ranks are one, as required by PR (4.1.1).

The faithful flag map is a closed immersion: the inverse image of the
GL parabolic for the represented cocharacter is the \(J\)-parabolic.
The unique geometric preimage of a \(K\)-rational flag therefore descends
to \(K\). The representation is of Hodge type, so the required
cocharacters are minuscule. Faithfulness also gives
\(\rho^{-1}(Z_{\mathrm{GL}})\subset Z_J\); the elementary injectivity
argument remains to be interpreted for these algebraic groups, rather
than being supplied scheme-theoretically by PF-CORE.

Admissibility in the hypothesis gives a crystalline representation. Its
crystalline and filtered de Rham comparisons identify the associated
modification with its trivial vector bundle on the Fargues-Fontaine
curve. This is the GL admissible locus, not just the weakly admissible
locus. Equation (3.1.9), **using the Kottwitz invariant already supplied
by the geometric point**, puts the \(J\)-flag in the \(J\)-admissible
locus. Omitting that invariant or substituting weak admissibility here
without the descent argument would leave a genuine gap.

The etale period map has a nonempty fiber over that specified flag at
the fixed parahoric level. A nonempty affinoid neighborhood of this
zero-dimensional rigid fiber has a classical point with finite residue
extension. This justifies the finite extension in Step 2 even though
\(K_0\) itself is not a finite local field.

### 2. Algebraicity does not mean every automorphism of a \(p\)-divisible group is algebraic

Let \(z\) be that framed generic point. GLX Corollary 6.3 identifies its
integral local Shimura variety with the **marked** tensor-compatible
Siegel pullback. Its classical point extends to an \(\mathcal O_K\)-point
of a special formal chart: evaluation of the chart's ring is integral
and the ideal of definition maps to topologically nilpotent elements.
The formal map gives the abelian lift and its faithful \(p\)-divisible
group, with the same tautological shtuka. PR Proposition 3.5.1 identifies
the corresponding specialization, rather than authorizing a second
choice of lattice.

The Siegel uniformization supplies an algebraic quasi-isogeny with that
marking. Explicitly, on a chart where a \(p\)-denominator is bounded,
multiply the inverse \(p\)-divisible marking by a power of \(p\), take
its finite flat kernel inside \(C_x[p^\infty]\), and quotient \(C_x\)
by that subgroup. The induced identification of the quotient's
\(p\)-divisible group with the target is part of the construction.
This is the abelian object selected by marked Siegel uniformization,
with the identity prime-to-\(p\) coordinate. The quasi-isogenies glue
in the rational category over the perfect reduced fiber.

Consequently one obtains a universal algebraic \(b\) there, and its
crystalline tensor equality is exactly the defining open-and-closed
condition in PR section 4.10.1. This argument does **not** assert that
an arbitrary automorphism of \(C_x[p^\infty]\) is induced by an
endomorphism of the fixed \(C_x\): a different marking changes the
tautological identification of the quotient.

### 3. The same \(b\), not a newly chosen isogeny, has the other realizations

This is the important extra content of the old draft's Step 4.
Let \(T\) be the perfect reduced fiber of this marked RZ space.
Keep the universal \(b\) and the identity away-from-\(p\) coordinate.
Its \(p\)-power denominators are units at every \(\ell\ne p\), so
it identifies the target's integral \(\ell\)-adic local system with
that of the **constant source** \(C_x\).

The canonical tensor sections are supplied by the integral model
(`KZ-2505.02165v1.txt:308-325`, section 2.1.4).
For a fixed rational tensor clear its fixed denominator (or work on
compatible denominator charts). Its pulled-back discrepancy modulo
\(\ell^n\) is now a section of a **constant finite etale sheaf**.
It is a locally constant function on the underlying space of \(T\).
This trivialization by the actual universal \(b\) is essential:
an arbitrary lisse local system, without it, would not be a map
into the fixed value types of the Lean theorem.

Use the initial characteristic-zero lift with its identity marking.
At-\(p\) \(J\)-Hecke quasi-isogenies preserve **all** the canonical
defining tensors in characteristic zero; their specializations preserve
the prime-to-\(p\) tensors. The two diagrams in the proof of GLX
Corollary 6.3 (`:2181-2208`) place these very Hecke points in the
**marked Siegel RZ space**. A point there remembers the
\(p\)-divisible quasi-isogeny, not just the global abelian image.
Thus the specializations are evaluations of this universal \(b\);
one is not applying Kisin's existential characterization to choose
a substitute \(b'\) at each image point. Equality of the marked
\(p\)-divisible maps also identifies the algebraic quasi-isogenies,
since the map from algebraic rational homomorphisms to their
\(p\)-divisible realizations is injective.

Corollary 3.13 says these specializations meet **every connected
component**, after identifying \(T\) with the ADLV by the integral
comparison. This is a common good-point set, chosen independently
of the tensor, \(\ell\), and \(n\). Each finite discrepancy is
constant on a connected component and zero at its good point;
hence it is zero everywhere. Separation of the integral
\(\ell\)-adic tensor lattice then gives exact rational equality.
The quantifiers are

\[
 \exists b\ \ \forall\alpha\ \forall\ell\ne p\ \forall n,
 \quad d_{\alpha,\ell,n}(b)=0,
\]

not \(\forall\alpha,\ell\ \exists b_{\alpha,\ell}\).
The argument establishes the former because \(b\) was already fixed
before any index was selected.

### 4. The period is the exact pullback by this \(b\)

With the marking convention of the draft, \(q=b^{-1}\), so
contravariance gives \(q^*=(b^*)^{-1}\). The marked crystalline
period is

\[
 \pi_{\mathrm{GM}}(z)
  =(q^*)^{-1}\operatorname{Fil}^1
  =b^*\operatorname{Fil}^1=\mathcal F^1.
\]

There is no subsequent self-quasi-isogeny conjugating the period and
no extension of Witt Frobenius to the ramified filtration field.
KZ section 2.1.14 supplies the outer Frobenius convention; the
two abstract identities and the separate symbolic reproduction check
its algebra, not the geometric comparisons themselves.

## Characteristic two and restrictions not to erase

The claim is **not** an unrestricted assertion for every parahoric
Hodge-type datum at \(p=2\). It keeps KZ's strong-admissibility
conditions, in particular the reduced relative roots and R-smoothness.
Those are used for the closed adapted embedding. Neatness, the full
connected stabilizer, and the canonical model/comparison also remain.

GLX's introductory Assumption 1.4 (`:155-176`) imposes \(p>2\),
tameness, and a fundamental-group restriction for its earlier
CM-lifting applications. It must not be used as an unrestricted
CM-lifting theorem here. Its **separate** global-Hodge-type
uniformization application is restated at `:301-337` and
`:2061-2124`; Corollary 6.3 uses the PR global-Hodge-type hypotheses.
Corollary 3.13 is a local component statement without an odd-prime
restriction. As a cross-check on this reading, KZ v1 Theorem 2.2.5
(`:678-685`) explicitly applies GLX Corollary 6.3 in its strongly
admissible setting, which includes \(p=2\); KZ Remark 2.2.8
(`:695-702`) separately distinguishes the older restricted
CM-lifting theorem. PR Theorem 4.5.2 and GLX Corollary 6.3, rather
than restricted special cases or the formerly conjectural \(U_x\)
alone, are the inputs used here.

No step of finite-etale propagation divides by \(2\). The local
projector obstruction is a warning against inserting an arbitrary
stable lattice, not a counterexample to this choice of a framed
point. Weak admissibility supplies rational admissibility only with
the stipulated finite descent; see the separate weak-admissibility unit.

## Evidence boundary, comparison, and remaining obligations

The exact algebra replay and one bounded typed Jacobian solve are
recorded in the symbolic-frobenius unit. The matched historical
PF-CORE v2 certificate and supplemental Lean 4.31.0 stdin run,
including all four axiom printouts, are recorded in the lean-core
unit. Neither is attached as mechanical evidence to PF-REALIZATION.
There is no useful numerical or compiler experiment that would
verify the geometric bridge assessed here, so no additional run
was substituted for the source reading.

Compared with the strongest relevant earlier discussion (Milne SVp
v2.4 section 12), the old Argus draft makes the marked realization
and the common-Hecke-witness propagation explicit. Compared with
PF-CORE alone, it supplies the geometric instantiation of the
space, universal marking, locally constant discrepancies, and
component witnesses. These are mathematical improvements in
explicitness and scope of the relative argument, not verified
novelty. Milne v2.4 neither checks these details nor retroactively
supplies them to v2.2.

No invalid step or counterexample to PF-REALIZATION was established
in this review. Its supported status is **relative to** KZ, PR,
GLX, and the standard crystalline/de Rham comparison and rigid
point facts used above. A foundational or kernel proof would still
have to formalize those geometric constructions and comparisons;
PF-CORE leaves them external. Applying the lemma to transport also
requires constructing the auxiliary datum and prescribed data and
proving rational normalization; proving MR-MAIN additionally
requires the balanced-Weil and CM-reduction arguments. Those are
separate source-context obligations, not defects manufactured in
this lemma and not discharged here. The native independent
Reviewer must decide whether this relative assessment and its
source applications are accepted.
