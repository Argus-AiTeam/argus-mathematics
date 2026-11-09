# Field-shift synchronization

**Result:** there is an arbitrary-parameter proof of the scoped lemma for
the actual matrix edge constructions in the retained catalogue. The proof
below supplies the support and common-normalizer steps, not just the
cyclic arithmetic. The finite combinatorial core has a real, successful
Lean 4.31.0 certificate with no proof holes. Independent review, including
literature attribution, is still pending. This does not certify either
manuscript's main theorem or claim research novelty.

## Statement under audit

The target is `pkt:field-shifts`, lines 383-590 of
`research/openai_manuscript/A-Negative-Solution-to-the-Finite-Lattice-Representation-Problem-September-24-2026/build/sections/packets.tex`.
For endpoint exponent \(f\), intermediate exponent \(f'=uf/v\) in
lowest terms, and \(h=\gcd(f,f')=f/v\), it asserts that every admissible
comparison normalizer has \(h\mid(s-a)\), and that every packet of
absolute constituent types has size at most \(2v\).

The ambient hypotheses are retained comparisons and shortcuts from
`grw:remaining-paths` and `lift:edge-lifts`, classical ranks at least nine,
actual compatible component normalizers, and the natural realizations
specified in those results. Neither arbitrary digit strings nor groups
outside that range constitute counterexamples.

The proof separates three assertions: the natural-module source support
of each retained edge is nonempty and lies in one residue class modulo
the gcd of its group exponents; the same normalizer induces compatible
field actions on both edges, including characteristic-two B/C convention
changes; and the resulting cyclic/diagram action has order at most
\(2v\). The last assertion alone does not verify the first two.

## Initial scope and retrieval limits

The source is available locally. Its own assertions are audit targets,
not established assumptions. The supplied cross-campaign Wiki index
contains no entry matching finite lattice representation, field-shift,
unitary, B/C, or Steinberg. This is a scoped negative retrieval result,
not a claim that the relevant literature does not exist.

Jacobian discovery through the authorized adapter reports server
`jacobian` version `0.14.0`, protocol `2025-11-25`. The first five matches
for "finite cyclic shift stabilizer tensor Frobenius representation" do
not supply a representation-theoretic support or normalizer theorem.
No mathematical conclusion has been inferred from that discovery.

At this initial scope checkpoint no counterexample, uniform verification,
novelty claim, or independent review had been established. Both
manuscripts' main conclusions remain open in this audit.

## Manuscript dependency scope

The two manuscripts' conclusions and load-bearing reductions are recorded
as **open claims**, not as assumptions proving this audit's target.

For the negative-solution manuscript, `main:congruences`
(`introduction.tex:22-28`) follows globally from `main:group`
(`introduction.tex:41-45`) and the Pálfy-Pudlák equivalence, not from
a pointwise identification for the same lattice. The subgroup-interval
obstruction depends on the decorated Boolean detector and
`glue:contradiction` (`gluing.tex:497`). Their chain-rigidity input
(`cls:chain-rigidity`, `classification.tex:66`) depends on the retained
classical paths, actual component lifts, natural-endpoint
irreducibility, and irreducible-restriction arguments.
The field-shift lemma feeds only the uniform-composition-length input
`pkt:bounded-length`; it does not by itself prove chain rigidity,
nonrepresentation, or either main theorem.
The next separate, still-open dependency is
`irr:natural-endpoints` (`rigidity.tex:273-279`): arbitrarily long
remaining chains have arbitrarily long subchains on which each
upper natural endpoint module restricts absolutely irreducibly to
each earlier endpoint.

For the characterization/undecidability manuscript, `m:main`
(`introduction.tex:60-82`) asserts the conjunction of the finite
colored-graph criterion `f:criterion` (`graph.tex:33`),
finite-representability undecidability `n:undecidable`
(`diophantine.tex:154`), the minimum-counterexample description
`q:minimum` (`minimum.tex:352`), and subgroup-interval undecidability
`n:interval-undecidable` (`diophantine.tex:280`). Load-bearing inputs
include `f:negative-family` (`affine.tex:13`),
`f:thm-almost-simple-reduction` (`affine.tex:942`),
`r:reverse-exclusion` (`reverse.tex:36`),
`c:classical-conclusion` (`classical.tex:488`),
`c:alternating-conclusion` (`alternating.tex:188`),
`t:weighted-realization` (`weighted.tex:1283`), and
`n:template-bound` (`counting.tex:661`).
The effective witness bound, common numerical alignment, and actual
full-interval interpretation remain substantive unverified obligations.

The provenance of this dependency extraction is a bounded read-only
scope pass; no literature theorem in that pass has been promoted to an
established assumption. In particular the Pálfy-Pudlák equivalence is
itself an open audit node here, not a secretly discharged dependency.

## Uniform representation-theoretic verification

The scope of the following theorem is important. It takes the retained
**edge constructions**, nesting, and common normalization specified in
`grw:remaining-paths` and `lift:edge-lifts` as the setting of the lemma.
It proves what these constructions imply; it does not prove that the
preceding reduction really obtains this setting from every putative
long chain. That latter assertion remains open as `C_NEG_REMAINING` and
`C_NEG_LIFTS`, rather than being an established assumption in this audit.
In particular, the occurrence of a single restricted digit on a retained
nonlinear edge is an explicit hypothesis of
`grw:remaining-paths`(ii), not a new inference made here.

**Theorem.** In that setting, for arbitrary positive endpoint and
intermediate exponents \(f,f'\), every common normalizer satisfies
\(\gcd(f,f')\mid(s-a)\). If \(f'/f=u/v\) in lowest terms, each packet
has at most \(2v\) types. The natural tensor-cycle part of the proof
holds for every cycle length, not only prime lengths. No support
condition or compatible intermediate scalar operator is assumed in
addition to the actual edge constructions and common normalization.

### 1. Finite-source types and transport

Work on the specified simply connected source cover. For
\(G=(\mathbf G^{\tau F_p^r})\), the restriction and tensor-product
theorems give a unique \(r\)-digit highest-weight label for each
absolute simple module. Here \(\tau\) is trivial or a diagram
involution; the excluded bounded-rank exceptional graph cases are
not being included. A field twist translates digit positions modulo
\(r\). Wrapping through \(r\) applies \(\tau^{-1}\) to the digit,
which preserves its nonzeroness. Diagram operations and the opposition
involution describing contragredience preserve positions. These are
precisely the conclusions of the original Steinberg notes, Theorems
41 and 43, with their simply connected and restricted-weight
hypotheses retained. We do not replace the unitary parameter \(r\)
by its natural matrix-field degree \(2r\).

Let a semilinear normalizer \(m\) have target scalar exponent \(b\),
and let its source automorphism, modulo inner-diagonal operations,
be \(\gamma F_p^{a_0}\). If \(\rho\) is the source representation,
transporting a composition series using
\[
 \rho(x)mw=m\rho(\alpha_m^{-1}(x))w
\]
shows that its transported factors have types
\((L\circ\gamma^{-1})^{[\,b-a_0\,]}\).
The sign follows from the inverse on \(\alpha_m\), before applying
the \(p^b\)-semilinearity of \(m\).
An ambient correlation also takes contragredients. Inner-diagonal
operations are algebraic inner conjugacies on the cover and hence
leave absolute types unchanged. Passing through a projective central
quotient introduces no character ambiguity: the cover is perfect.
Thus the nonempty union \(E\) of nontrivial supports satisfies
\[
                         E+(b-a_0)=E.                 \tag{1}
\]
No semisimplicity of an individual edge was used.

### 2. Supports of all retained edges

Write \(d=\gcd(r,t)\), where \(r,t\) are the usual source and target
group exponents.

| Retained edge | Actual nontrivial natural constituents | Support consequence |
|---|---|---|
| Nonlinear single-digit edge | A common twist of a nonzero restricted simple module | A singleton |
| Block or form edge; subfield inclusion | Natural or dual-natural modules, with repetitions and trivial factors | One position |
| Ordinary tensor edge with one active component | The active natural action tensored with a trivial multiplicity space | Repetitions in one position |
| Restriction of scalars | Direct sum of the conjugate natural actions | Positions \(e+j\epsilon_t t\) |
| Natural tensor-cycle edge | The explicit cyclic fixed-point construction proved below | One residue class modulo \(t=d\) |
| Characteristic-two nonsingular-line edge | \(k,N_B,k\), with \(N_B\) the natural simple quotient | One nontrivial position |
| Characteristic-two special-isogeny realization | The preceding natural modules in either finite B/C convention | A common position in the convention used on that edge |

For the ordinary tensor row, every inactive image is soluble and
therefore receives the trivial homomorphism from the perfect active
component. It cannot secretly contribute another nontrivial tensor
digit. For scalar restriction, the elementary decomposition
\[
 k\otimes_{\mathbb F_{p^{\epsilon_t t}}}
       \mathbb F_{p^{\epsilon_s r}}
   \simeq\bigoplus_j k
\]
gives the displayed positions, whenever
\(\epsilon_s r=b_{\rm sc}\epsilon_t t\).
Each difference is a multiple of \(d\). Coincident positions in a
**direct sum** produce multiplicities, not tensor-digit carries.
This includes \(N\oplus N^{[r]}=N\oplus N^*\) for the unitary
degree-two restriction. At least one nontrivial factor exists: an
all-trivial composition series would give a soluble image of a
perfect active group, hence the trivial image.

Here is an independent calculation of the tensor-cycle row.
The Frobenius exponent on each factor is the ambient exponent
\(t\), not an additional source-field convention. Indeed the
ambient semilinear map restricts to a \(p^t\)-semilinear
isomorphism (or, for unitary descent, anti-isomorphism) between
the embedded full matrix algebras of the tensor factors.
After removing the entrywise Frobenius and, when needed,
transpose, a linear matrix-algebra isomorphism is inner:
its matrix units give a basis in which they are the standard
matrix units. Thus its only remaining freedom is conjugacy.
This proves the asserted factor-field exponent even for a
noncanonical tensor basis.
Put \(\theta=\eta F_p^t\) on the natural factor, where \(\eta\)
is the indicated diagram operation. On a product of \(b\) factors
let the fixed-point map cycle the factors and apply \(\theta\).
Its fixed tuples are exactly
\[
                 (g,\theta g,\ldots,\theta^{b-1}g),
                 \qquad \theta^b g=g.                 \tag{2}
\]
This follows by solving the \(b\) coordinate equations, not by
assuming a field relation from an order estimate.
This calculation covers conjugate finite realizations as well.
Indeed, on a connected classical factor product let \(F_0\) be
the indicated diagram-field-cycle map. Its differential is zero.
For every \(y\), the twisted-conjugacy orbit map
\(x\mapsto xyF_0(x)^{-1}\) has invertible differential at the
identity. Its image therefore has full dimension and, being a
constructible orbit, contains a nonempty open subset. Translating
that subset within the orbit shows that each orbit is open.
Connectedness implies that there is only one orbit. In particular
every \(c\) is \(xF_0(x)^{-1}\), which conjugates
\(\operatorname{Int}(c)F_0\) to \(F_0\).
Thus inner factors in the actual semilinear factor cycle can be
removed; changing coordinate bases, central covers, or conjugate
forms does not change its constituent types. A different standard
source identification differs by a finite-group automorphism,
which translates all positions or applies a diagram operation.
It preserves the single-residue-class property. This is the
usual inner-removal argument, included here with its connectedness
and zero-differential hypotheses rather than hidden in a citation.
Constructibility here uses the explicit ledger assumption
`A_CHEVALLEY`, Stacks Project Tag 054K, Theorem 29.23.3:
the orbit maps are quasi-compact and locally of finite presentation,
being morphisms between finite-type affine varieties.
The return map is \(\eta^bF_p^{bt}\), so the source exponent is
\(r=bt\). A tensor natural action is consequently
\[
              \bigotimes_{j=0}^{b-1} W_j^{[jt]},
                    \qquad W_j\in\{W,W^*\}.           \tag{3}
\]
For linear, symplectic, and orthogonal targets, the natural or dual
choices and form signs affect weights, not the distinct positions
\(0,t,\ldots,(b-1)t\).
If the form factors have different diagram choices along the
cycle, use their product as the return diagram; each step still
contributes exactly \(t\), with no effect on these positions.

For a **unitary target**, the return operation is explicitly
\(\eta(g)=g^{-\mathsf T}\). If \(b\) is odd, the source is
\(\operatorname{SU}_m(p^{bt})\), and its finite natural matrices
satisfy \(W^*\simeq W^{[bt]}\). Hence (3) becomes, after reordering,
\[
                    \bigotimes_{j=0}^{b-1} W^{[2jt]}.
                                                               \tag{4}
\]
Indeed, its original exponents divided by \(t\) are \(j\) for even
\(j\) and \(j+b\) for odd \(j\); these are exactly
\(0,2,\ldots,2b-2\). Multiplication by two is injective modulo
odd \(b\). Reducing (4) modulo \(r=bt\) may dualize a digit but
does not identify two positions. If \(b\) is even, the source is
\(\operatorname{SL}_m(p^{bt})\); retain the alternating natural and
dual choices in (3). Its \(b\) positions are already distinct.
The manuscript's prime even case is \(b=2\), but nothing in this
calculation requires that restriction.

Every factor in these products is a nonzero restricted natural
or dual-natural module at a different source position. The
tensor-product and finite-restriction theorems therefore identify
the finite simple type with exactly these nonzero digits. There
is no coincident-digit decomposition step left unproved. A common
initial twist simply translates all positions. This proves the
required single residue class for every row of the table.

### 3. Actual unitary descent, not just a pattern of indices

For clarity, the unitary tensor construction has a direct matrix
realization for arbitrary \(b,t,m\). Put \(q=p^t\), and choose
standard source Hermitian form matrix \(I\) when the source is
unitary. For odd \(b\) work over \(L=\mathbb F_{q^{2b}}\), with
source \(\operatorname{SU}_m(q^b)\); for even \(b\) work over
\(L=\mathbb F_{q^b}\), with source \(\operatorname{SL}_m(q^b)\).
Define
\[
 A_j(g)=
 \begin{cases}
 g^{[jt]},&j\ \text{even},\\
 (g^{-\mathsf T})^{[jt]},&j\ \text{odd},
 \end{cases}
 \qquad R(g)=\bigotimes_{j=0}^{b-1}A_j(g).
\]
In both cases \(A_{j+b}=A_j\), using the actual finite-source
equation, rather than a formal digit convention.
Let \(P\) rotate pure tensor factors one step to the right,
and let \(\delta\) raise scalars to \(q^2\). Direct substitution gives
\[
 P^2R(g)^\delta=R(g)P^2,\qquad
 R(g)^{\mathsf T}P R(g)^{[t]}=P.                       \tag{5}
\]
Thus \(D=P^2\delta\) commutes with the source action.

These are genuine descent equations. On a permutation orbit of
\(P^2\) of length \(e\), its fixed vectors have coefficients
\((z,z^{q^2},\ldots,z^{q^{2(e-1)}})\), where
\(z\in\mathbb F_{q^{2e}}\).
For any basis \(\beta_1,\ldots,\beta_e\) over
\(\mathbb F_{q^2}\), the corresponding Moore matrix is invertible:
a nonzero linearized polynomial of degree at most \(q^{2(e-1)}\)
cannot vanish on all \(q^{2e}\) elements of that subfield.
These orbit blocks give an invertible matrix \(B\) with
\[
 P^2B^\delta=B,\qquad
 R'(g)=B^{-1}R(g)B\in\operatorname{GL}_{m^b}(\mathbb F_{q^2}).
                                                               \tag{6}
\]
The matrix \(H=B^{\mathsf T}PB^{[t]}\) has entries in
\(\mathbb F_{q^2}\), is nonsingular, and satisfies
\[
 H^{[t]\mathsf T}=H,\qquad
 R'(g)^{\mathsf T}H R'(g)^{[t]}=H.                     \tag{7}
\]
For example, the first identity follows from
\((B^{[2t]})^{\mathsf T}=B^{\mathsf T}P^2\) and
\(P^2P^{-1}=P\).
Determinants are one by the tensor determinant formula and
\(\det g=1\). Consequently this is an actual special-unitary
representation, not an unrealizable support pattern.
Every nonsingular Hermitian form over a finite field is equivalent
to the standard one: diagonalize it and scale each nonzero diagonal
entry using the surjective norm map. This last assertion also follows
directly from cyclicity of the multiplicative group of the field.

The executable checks instantiate (5)-(7) in source rank nine for
both the even and odd cases. The proof (2)-(7), not those finite
instances, handles arbitrary \(b,t,m\). It does not depend on
obtaining the cited Liebeck-Seitz article.

### 4. B/C changes: the field exponent survives, arbitrary digits do not

In the notation \(s:B_\ell\to C_\ell\) and
\(t:C_\ell\to B_\ell\), the root-group formulas in Dowd-Sin,
I.3.1, are defined over \(\mathbb F_2\), commute with every
ordinary Frobenius, and satisfy \(ts=F_2\), \(st=F_2\).
On \(\mathbb F_{2^r}\)-points,
\[
                  s^{-1}=tF_2^{r-1}.                  \tag{8}
\]
This is a finite-point inverse, not an inverse inseparable
algebraic morphism. The natural weight formulas in I.3.2 give
\(s^*N_C=N_B\) and \(t^*N_B=N_C^{[1]}\), as in the
manuscript. The extra trivial factors in the nonsingular-line
filtration do not change nonempty support.

More importantly, if an intermediate finite-group automorphism
has field part \(F_2^a\), conjugating it through \(s\) still has
field part \(F_2^a\). This follows from commutation with Frobenius;
inner parts remain inner. In rank at least nine these B/C groups
in characteristic two have no extra graph operation and no
nontrivial diagonal outer part. Formula (8) gives the same conclusion
in the opposite direction. Thus the intrinsic exponent modulo \(r\)
is unchanged even when different edges use different natural
conventions.

It would be **false** to replace this argument by the stronger
claim that every module retains the same ordinary digit support.
For every \(\ell\ge9\), Dowd-Sin's exact weight map gives
\[
 s^*(\omega_1^C+\omega_\ell^C)
       =\omega_1^B+2\omega_\ell^B,\qquad
 s^*L_C(\omega_1+\omega_\ell)
       \simeq L_B(\omega_1)\otimes L_B(\omega_\ell)^{[1]}.
                                                               \tag{9}
\]
For \(r\ge2\) both highest weights are \(2^r\)-restricted.
Their finite-source supports are respectively \(\{0\}\) and
\(\{0,1\}\). Surjectivity of the isogeny on algebraically closed
points preserves simplicity on pullback, so (9) is an actual
representation-theoretic example, not an arbitrary digit string.
This retires the auxiliary route `R_BC_IDENTICAL_DIGITS`.
**The manuscript does not assert this stronger invariance**, so
(9) is not recorded as a false manuscript assertion, does not
refute `pkt:field-shifts`, and does not justify an `F_` claim.

### 5. The same intermediate exponent is available on both edges

Let \(K\le H\le T\) be the actual nested lower, intermediate,
and upper components of a shortcut, transported to fixed standard
finite covers as in the lemma's setting. A single bottom
normalizer \(m\) normalizes both \(K\) and \(H\).
Its conjugation automorphism \(\beta\) of \(H\) therefore
normalizes the actual subgroup \(K\) of \(H\); it is not merely
an abstract isomorphism between two unrelated intermediate groups.

Steinberg's finite automorphism descriptions (Theorems 30 and 36)
write \(\beta\), in the natural realization of \(H\), as
inner-diagonal, graph, and field operations. They have natural
matrix implementations: inner-diagonal conjugations are linear
similarities, field operations act entrywise with scalar exponent
\(a_1\), type A graph operations are inverse-transpose
correlations, and the high-rank orthogonal graph operation is a
linear isometry on the natural space. No triality or exceptional
low-rank graph-field operation is included. Hence there exists a
natural semilinear operator, or a correlation, implementing this
**same** \(\beta\) with scalar exponent \(a_1\). Since it
implements \(\beta\), it normalizes the actual lower image \(K\).
One need not assert that the original upper operator \(m\) itself
acts on the intermediate natural vector space.

Different decompositions alter \(a_1\) only by a multiple of the
usual intermediate period \(f'\). For a unitary or twisted
orthogonal group, a power \(F_p^{f'}\) can instead be recorded as
the diagram involution, but this makes no change modulo
\(h\mid f'\). The B/C argument above proves the same invariance
under the inseparable convention changes; it does not assume
invariance of arbitrary digit labels.
Thus both edges genuinely use the same \(a_1\) modulo \(h\).

### 6. Synchronization and packet size

By Section 2, the support in (1) is contained in a single residue
class modulo \(d\). Choose \(x\) in that nonempty support and a
representative \(y\) of its translate in the support. Since
\(r\mid x+(b-a_0)-y\) and \(d\mid r\), subtracting their common
residue gives \(d\mid b-a_0\).
Apply this to \(K\le H\) using the implementation in Section 5,
and to \(H\le T\) using the original \(m\). The conclusions are
\[
              h\mid a_1-a,\qquad h\mid s-a_1,
              \quad\text{hence}\quad h\mid s-a.        \tag{10}
\]
Since \(f=vh\), this also gives \(f\mid v(s-a)\).

For the packet bound let \(\Phi\) be field twisting of absolute
source types and \(\Delta\) the possible diagram involution
(identity when absent). These commute,
\(\Delta^2=1\), and \(\Phi^f=\tau^{-1}\).
The diagram assertion follows directly from the high-rank
classical diagrams: type A has at most the path reflection,
type D at most the interchange of its two terminal legs,
and types B and C have none. Rank-four triality and exceptional
low-rank graph-field operations are outside the stated range.
Put \(g=\Phi^h\). Then \(g^v=1\) in the untwisted case,
or \(g^v=\Delta\) in the twisted case.
Every normalizer action is in \(\langle g,\Delta\rangle\) by
(10). Upper descent has exponent \(f\) or \(2f\), hence is
in the same group; opposition duality is a diagram operation.

In the first case this commuting group is a quotient of
\(C_v\times C_2\). In the second it is cyclic, generated by
\(g\), with \(g^{2v}=1\). Its order and every orbit size are
therefore at most \(2v\). The action can be taken on the finite
set of all finite-source absolute simple types, so using the
finite-group cardinality theorem entails no finiteness assumption
on the collection of arbitrary rational algebraic modules.
Intersecting an orbit with the occurring types cannot increase
its size. This proves exactly the packet definition in
`packets.tex:301-314`.

## Evidence and limits

`lean/Main.lean` proves the support-translation implication, arbitrary
progression noncollision, odd doubling, addition in (10), and the
abstract \(2v\) group bound, including a proved group normal form.
Its source-bound certificate is
`lean/certificates/certificates/C_FIELD_COMBINATORIAL-4a4230f3fea2e934.json`.
The real compiler and axiom-audit exit codes are zero and
`proof_holes=[]`. The ledger reports `C_FIELD_COMBINATORIAL` v2
as `closed_kernel`. The statement-fidelity document explicitly
excludes the representation-theoretic arguments from that kernel
claim; Sections 1-5 remain a mathematical proof for independent
human review.

`verify.py` supplies exact finite-field and matrix replay of the
delicate constructions, checks the B/C weight calculation, replays
the bounded Jacobian output independently, and checks that the
Lean certificate still matches the formal source and its reading.
These finite calculations are regressions and constructions, not
the proof of the universal quantifier in the theorem.
The even case checks all 360 elementary generators over a polynomial
basis of \(\mathbb F_{16}/\mathbb F_2\), for
\(\operatorname{SL}_{10}(16)\to\operatorname{SU}_{100}(4)\).
The odd case constructs the descended Hermitian form on 1000
dimensions and checks four explicit source matrices in
\(\operatorname{SU}_{10}(8)\to\operatorname{SU}_{1000}(2)\);
it is not an exhaustive source-group test. A deliberately incorrect
even-unitary pattern with distinct digit positions but the dual
omitted fails the Hermitian matrix equation. It is rejected as
inadmissible, not advertised as a manuscript counterexample.

The replay command is
`python3 research/field_shift/verify.py`.
It checks the existing source-bound compiler certificate rather than
recompiling unchanged Lean. An independent fresh compiler replay uses:

```text
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/field_shift/lean/Main.lean --statement-fidelity research/field_shift/lean/statement_fidelity.md --claim C_FIELD_COMBINATORIAL --project-root . --artifact-dir research/field_shift/lean/certificates
```

The original Steinberg notes, the published 1963 paper, and the
Dowd-Sin author version were obtained. The notes' relevant theorem
statements and the Dowd-Sin root/weight formulas were read.
The cited Liebeck-Seitz article could not be obtained in this
retrieval: ResearchGate returned HTTP 403, Springer returned
HTTP 406, and the author's linked preprint list begins in 2003.
This is **not** evidence that the proposition or the citation is
false. Equations (2)-(7) replace reliance on that unread
proposition for the scoped tensor calculation.

All external propositions actually used are explicit ledger
assumptions with source and locator. The Engineer's source
reading is not independent attribution; the Host-invoked
Reviewer must confirm those citations, statement fidelity,
the matrix proof, and its application to the exact retained
constructions. Neither novelty nor publishability is certified
by the Engineer. Compared with the initial state, the advance is
the full support/compatibility argument and a universal kernel
core, not a larger finite search or a refutation of either main
theorem.
The official citation-status command currently reports 14
unchecked claim/assumption pairs (four distinct propositions);
its delivery gate is not clear. No independent reader identity
has been fabricated to clear that gate. The two campaign-local
structural checks pass, which is a different assertion.
