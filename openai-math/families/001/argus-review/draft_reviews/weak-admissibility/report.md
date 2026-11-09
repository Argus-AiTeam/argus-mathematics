# Weak admissibility: review of PF-WA v1–v2 and Step 6

## Assessment and boundary

**Supported for rational admissibility, under the stipulated descent hypothesis,
including \(p=2\).** Step 6's short argument is correct with the fields,
subobjects, and normalizations made explicit below. It does not construct an
integral tensor lattice, an abelian lift, or a quasi-isogeny with a prescribed
marking. Those are different assertions.

This is an **Engineer contribution**, not independent delivery acceptance.
`independent_review = pending_native_reviewer`;
`novelty_status = not_claimed`. The contribution is an application of an existing
theorem and an elaboration of the old argument, not a new admissibility theorem.

All source line numbers are one-based in the immutable historical root
`campaigns/9000001`.
Abbreviations:

* **A** = `research/prescribed-filtration-audit`;
* **M** = `research/openai_manuscript/Milnes-rationality-conjecture-for-abelian-varieties-October-7-2026/build`.

The native skill descriptions were considered before source exploration. No
source-specific skill was applicable to checking the supplied text extracts;
there was no PDF-ingestion, new-literature, wiki, or skill-editing task. No
agents, external research, Git operations, or Argus citation-acceptance calls
were used.

## Exact old claim and manuscript hypothesis

`research/MATH_STATE.json:112–124` and `287–309` contain PF-WA v1 and v2.
Both have the same natural statement:

> “Weak admissibility together with the finite local-field descent stipulated
> in the manuscript implies admissibility, including residue characteristic two.”

Both use CTX-PF (`MATH_STATE.json:14–23`), where admissible means that the
**faithful filtered isocrystal is realized by a crystalline representation**.
Version 2 adds the external assumption CF-WA; this is not a second result or a
formal proof. The written argument is `A/realization_proof.md:272–285`, especially:

> “Every descended Frobenius subobject extends to a subisocrystal over K0;
> its Hodge and Newton numbers are unchanged by this scalar extension.”
> (`275–277`)

The manuscript explicitly defines finite local-field descent at
`M/sections/02_transport.tex:25–30`:

> “with its tensors over the maximal unramified subfield \(H_0\) of a
> finite extension \(H/\Q_p\), together with a filtration over \(H\).
> The scalar extension is to \(\Kzero H\).” (`27–29`, TeX retained)

The application is the **last sentence only** of
`lem:admissible-realization`, `02_transport.tex:350–352`, repeated in its proof
at `569–573`: finite descent and weak admissibility supply condition (1).
The strongly admissible Hodge datum, quasi-split group, characteristic-zero
lift, and prescribed geometric cocharacter orbit in `332–340` are hypotheses
of the surrounding geometric lemma. They are not additional hypotheses of
Colmez–Fontaine and are not proved by PF-WA.

### What the descent data actually are

Write \(k=\overline{\mathbf F}_p\) and
\(K_0=\operatorname{Frac}W(k)\). This is a complete discretely valued field
with perfect residue field \(k\); it is not a finite extension of \(\mathbf Q_p\).
Choose a finite extension \(H/\mathbf Q_p\), residue field
\(k_H=\mathbf F_{p^f}\), and its maximal unramified subfield
\(H_0=\operatorname{Frac}W(k_H)\). Fix compatible embeddings into a common
complete algebraically closed valued field. Then \(H_0\subset K_0\), compatibly
with Witt Frobenius. **One does not assume \(H\subset K_0\)**: the ramified part
of \(H\) generally is not in this unramified field.

Put \(L=K_0H\). Since \(H/H_0\) is finite totally ramified, \(L/K_0\) is finite
totally ramified; \(L\) is the completion of the maximal unramified extension
of \(H\). A further common finite extension \(K/K_0\) may contain both \(L\)
and the initially specified filtration field.

The hypothesis supplies, simultaneously:

1. A finite-dimensional \(H_0\)-vector space \(D_0\) with bijective
   \(\sigma\)-semilinear Frobenius \(\varphi_0\), and \(N=0\).
2. A separated, exhaustive decreasing filtration on
   \(D_H=H\otimes_{H_0}D_0\).
3. The indicated rational tensor data over \(H_0\), with their filtration and
   comparison compatibilities (and the appropriate Tate twists).
4. An identification
   \[
   K_0\otimes_{H_0}(D_0,\varphi_0,\{t_\alpha\})
     \simeq (D_x,\varphi_x,\{s_{\alpha,0,x}\}),
   \qquad
   \mathcal F_K^i=K\otimes_H\operatorname{Fil}^i D_H.
   \]

Frobenius on the first tensor product is
\(\varphi(a\otimes d)=\sigma(a)\otimes\varphi_0(d)\).
There is **no need to extend \(\sigma\) to \(H\) or to a ramified filtration
field**. The hypothesis is descent of the whole filtered isocrystal and its
tensor data, not merely a claim that the flag has finitely many coordinates
over \(K_0\). Nor does it assert a tensor-preserving trivialization over \(H_0\).

## Decisive mathematical check

### Subobjects and the direction of descent

For every \(\varphi_0\)-stable \(H_0\)-subspace \(D'_0\subset D_0\), faithful
flatness gives the subisocrystal
\(D'=K_0\otimes_{H_0}D'_0\subset D_x\). Its filtration is induced by
intersection. Flat extension of vector spaces commutes with these
intersections:
\[
 (K\otimes_H D'_H)\cap(K\otimes_H\operatorname{Fil}^iD_H)
   =K\otimes_H(D'_H\cap\operatorname{Fil}^iD_H).
\]
Thus the inequalities assumed for **all** Frobenius subobjects of \(D_x\)
apply, in particular, to every subobject descending from \(H_0\).

No converse assertion about subobjects is used. There can be additional
subobjects after residue-field extension; it is unnecessary to descend them.
CF §3.2 itself distinguishes arbitrary subspaces after extension from those
defined over the original coefficient field: the latter are exactly the
Galois-stable ones (`A/sources/Colmez-Fontaine.txt:1150–1157`).
Checking only group-stable or tensor-selected subobjects, instead of all
Frobenius subobjects in the faithful module, would not be the stated
weak-admissibility hypothesis.

### Hodge and Newton numbers: preservation, not a missing degree factor

Use the standard absolute normalization \(v_p(p)=1\). For any such subobject,
\[
 t_H(D'_0)=\sum_i i\dim_H\operatorname{gr}^iD'_H,
 \qquad
 t_N(D'_0)=v_p(\det A'),
\]
where \(A'\) is the matrix of the semilinear \(\varphi_0\) in an \(H_0\)-basis
of \(D'_0\). These definitions agree with CF §3.1, equation (3.1),
`1067–1081`, and §3.2, `1129–1131`.

The intersection identity preserves the graded dimensions, so \(t_H\) is
unchanged. The same matrix \(A'\) over \(K_0\), with the same valuation,
shows that \(t_N\) is unchanged. There is no factor \([K_0:H_0]\), an infinite
degree, because this is scalar extension, not restriction of scalars.

In finite-residue-field notation \(\varphi_0^f\) is \(H_0\)-linear and
\[
 t_N(D'_0)=\frac{1}{f}v_p(\det(\varphi_0^f|D'_0)),
 \qquad
 v_p(\det(\varphi_0^f))=f\,v_p(\det A').
\]
The unnormalized \(f\)-iterate number scales by \(f\); it must not be compared
directly with the unscaled Hodge number. Likewise a valuation normalized by
\(v_H(\pi_H)=1\) has \(v_H(p)=e_H\), and its Newton valuation must be divided
by \(e_H\) to recover this convention. Uniformly rescaling both numerical
sides is harmless; mixing conventions is not. Over \(K_0\),
\(\varphi^f\) is still \(\sigma^f\)-semilinear, not a \(K_0\)-linear operator.

Consequently,
\[
 t_H(D'_0)=t_H(D')\le t_N(D')=t_N(D'_0),
 \qquad t_H(D_0)=t_N(D_0).
\]
**Weak admissibility does descend** in the required direction.
CF §3.4 defines it as precisely total equality and these inequalities,
`Colmez-Fontaine.txt:1198–1209`.

### Theorem A, crystalline rather than merely semistable, and \(p=2\)

The supplied source is Pierre Colmez and Jean-Marc Fontaine,
*Construction des représentations p-adiques semi-stables*, the author-version
extract `A/sources/Colmez-Fontaine.txt`. Its Introduction, printed p.2,
`59–64`, explicitly says:

> “K est un corps de caractéristique 0, complet pour une valuation discrète,
> à corps résiduel parfait k de caractéristique p > 0”

It identifies its coefficient field with \(\operatorname{Frac}W(k)\), and
its field \(K\) as a finite totally ramified extension of that coefficient
field (`60–62`). For the application over \(H\), **CF's \(K\) is \(H\) and
CF's \(K_0\) is \(H_0\)**. Finite dimensionality, invertible Frobenius, and
the induced filtration are part of the definitions in §§3.2–3.4,
`1114–1121`, `1187–1209`.

Theorem A at `87` states (the extract's broken “fi” ligature restored):

> “Tout \((\varphi,N)\)-module filtré sur K qui est faiblement admissible
> est admissible.”

“Admissible” means \(D\simeq D_{\rm st}(V)\) for a finite-dimensional
semistable \(\mathbf Q_p\)-representation, not an integral or abelian
realization (`1280–1293`, §4.1). Apply the theorem to the descended data
with \(N=0\). CF §1.5 gives
\(B_{\rm cris}=B_{\rm st}^{N=0}\), `588–594`. Hence
\[
 D_{\rm cris,H}(V_H)
   =D_{\rm st,H}(V_H)^{N=0}=D_0
\]
has the full dimension: \(V_H\) is crystalline.

To justify Step 6's last scalar extension, pull back \(V_H\) along the
homomorphism of absolute Galois groups supplied by compatible closures for
\(H\subset L\subset K\). For \(L\), this is restriction to inertia via
completion of the maximal unramified extension; \(L/H\) is not being
misdescribed as a finite local-field extension. Crystalline comparison
base-changes to give
\[
 D_{\rm cris,K}(V_H|_{G_K})
      \simeq K_0\otimes_{H_0}D_0,
 \qquad
 \operatorname{Fil}_K=K\otimes_H\operatorname{Fil}_H.
\]
One can see the full-dimension assertion directly: the comparison over
\(H\) supplies \(\dim D_0\) independent crystalline periods after extension;
the period-dimension bound (CF Proposition 4.1, `1280–1284`, and
\(D_{\rm cris}\subset D_{\rm st}\)) supplies the reverse bound. Filtered
de Rham comparison gives the displayed filtration. This is rational
admissibility of exactly the prescribed scalar-extended data.

There is **no odd-prime exclusion in Theorem A**. Its setup is \(p>0\),
so the rational argument includes \(p=2\). The older special cases and
weight/ramification bounds listed after Theorem A (`91–109`) are not
restrictions on Theorem A itself.

The author-version setup is broader than finite residue fields. In
particular, a finite extension of the campaign's \(K_0\) also satisfies
its complete-DVR/perfect-residue-field hypotheses. This corroborates the
source attribution; no new hypothesis-removal result is claimed here.
The reviewed statement retains the manuscript's finite-descent hypothesis.

## Logical direction, limitations, and concrete obligations

The retired `R-PF-WA-DESCENT` in `MATH_STATE.json:826–839` made
PF-REALIZATION an obligation for PF-WA. That reverses the intended use:
\[
 \text{specified descent + weak admissibility}
 \Longrightarrow \text{descended weak admissibility}
 \xRightarrow[\ N=0\ ]{\text{CF A}}
 \text{rational crystalline admissibility}
 \Longrightarrow \text{input (1) for the geometric realization argument}.
\]
Geometric realization is not used to obtain this rational input.

There is no remaining gap in that **conditional rational implication**.
Its concrete application obligations are to provide the simultaneous
descent identification above and to use the standard all-subobjects
weak-admissibility condition. Neither finite descent of an arbitrary flag
over \(K_0\) nor the surrounding geometric argument has been established
by this unit.

The tensor equivalence in CF §4.1 (`1290–1293`) transports rational tensor
**morphisms in the admissible category**. It does not select a canonical
integral lattice, make defining tensors integral on every stable lattice,
give an integral reductive frame torsor, or identify cohomology with that
of an abelian scheme with an exact quasi-isogeny. No such conclusion follows
by choosing an arbitrary stable lattice in \(V_H\). The separate
`lattice-obstruction` unit treats that failed route; its calculation is
not repeated here. This review does not assess KZ/PR/GLX geometric steps
or the geometric \(p=2\) claims in Step 6, `287–293`.

## Citation and historical evidence accounting

* `M/references.tex:27–32` names the journal article, *Invent. Math.*
  **140** (2000), no.1, 1–43, and the author version. The preserved CF-WA
  dependency is **`doi:10.1007/s002220000042`**. It has not been changed,
  externally resolved, or submitted as a new accepted citation check.
  The local extract is the author version, with Introduction on printed
  p.2 and a contents list ending at p.35 (`19–55`), not the journal's
  1–43 typesetting. No separate author-version date is visible in the
  reviewed opening. Locators above refer to the supplied text, not an
  asserted byte-identical journal version.
* `judgement-PF-WA-bcde7cffbebb`
  (`MATH_STATE.json:597–606`) is a prior Engineer opinion.
  `judgement-CF-WA-baee99fa0445` (`681–690`) and
  `judgement-PF-WA-bba51f43432c` (`741–750`) are prior Reviewer opinions.
  They are historical inputs, not acceptance receipts for this delivery.
* No computation or Lean statement in this unit proves Theorem A or the
  surrounding geometry. The decisive work here is the explicit
  subobject/numerical argument and checking the local theorem's hypotheses.
  Novelty is unverified and not claimed. Native independent review is pending.
