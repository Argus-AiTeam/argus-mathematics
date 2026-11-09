# A bounded finite-witness theorem for relative null layers

The target is Proposition `null:obstruction` in the staged September 23,
2026 version of *Parabolic Intersections in Artin Groups*, Section 5.
Here \(I\) is a nonempty connected subset of the operated colors,
\(c_I>0\), \(C_Ic_I=0\), \(c=0\) off \(I\), \(J\subset I\) is spherical,
and \(q\) is any integer. The objects are the actual family
\(E_L(z)=B_zP_{f,L}\), not arbitrary coefficient arrays. The fixed exterior
is capped at \(q\) and its level-\(q\) counts on
\((I\setminus J)\cup\partial I\) equal those of \(c\).

The disputed possibility is a strict lower bound
\(m_j^q(z)>c_j\) for every \(j\in J\) at **every** representative of
\(A_Jx\) capped on \(I\). A single representative with such counts is not
a counterexample. When \(J\) is empty, the claim excludes the exterior
configuration itself.

## Input boundary and literature

The needed manuscript inputs are the Frobenius trace and twist action
(`cat:frobenius`, `cat:action`), actual-family support and label
proportionality (`cat:family`, `lay:labels`), the layer calculus
(`lay:adjacent`, `lay:positive`, `lay:bottom`), cap accessibility
(`cap:access`), and the strict capped-layer hull (`cap:hull`).
The three Section 5 interfaces to audit are `null:hom`,
`null:injection`, and `null:separation`.

Heng--Licata, arXiv:2412.15919v1, provides the surrounding
fusion-labelled zigzag and categorical-action framework. Its introduction
explicitly distinguishes the constructed action from the general
faithfulness and contractibility conjectures. Neither general
faithfulness nor general contractibility is an available input here.
The primary version was opened at
<https://arxiv.org/html/2412.15919v1>.
An automated search summary suggested a null-root theorem in that paper
but did not identify a proposition; that suggestion is not evidence and
is not used. No external theorem resolving this exact relative
null-layer assertion has yet been obtained.

Two inadmissible routes are excluded from the outset: treating an
arbitrary numerical array as a transported projective, and replacing the
universal representative hypothesis by a test at a single word.
Neither establishes a refutation. A bounded search without a witness
would establish neither the obstruction nor its negation.

## 1. The stronger statement

Retain the actual manuscript construction, including all fusion labels,
both gradings, positive weights, the relative frame \(f\), and the
auxiliary color \(o\). Fix the exterior in the first paragraph. Suppose
first that \(J\ne\varnothing\), and start with any representative \(z\)
already capped at \(q\) on \(I\cup\partial I\).

Write \(d_{\min}\) for its lowest occupied family level. Let \(d_b\) be
the lowest occupied level on \(\partial I\), whose existence is proved
below, and set
\[
 N=d_b-d_{\min}+1,\qquad L=\ell(w_J).
\]
For each \(w\in W_J\), fix a negative reduced lift \(G_w\), with
\(G_1=1\). Its action on signed generator counts is \(w\).

**Finite-witness theorem (`N_BOUNDED_NULL`).** There are a positive word
\(u\) in \(J\), of length at most \(NL\), and \(w\in W_J\), such that
\[
 m_j^q(G_wuz)\le c_j\quad\hbox{for at least one }j\in J.
 \tag{1}
\]
Every prefix of \(u\) is cap-preserving, and the final negative lift is
cap-preserving. In particular the witness has word length at most
\((N+1)L\) relative to \(z\). This holds for every integer \(q\), with no
adjacency assumption between \(f\) and \(I\).

Prefixes here are in **action order**: for
\(u=\sigma_{j_r}\cdots\sigma_{j_1}\), they are
\(\sigma_{j_t}\cdots\sigma_{j_1}\), \(0\le t\le r\).

If \(J=\varnothing\), no such capped starting representative exists.

This is a universal theorem with a parameter-dependent witness bound,
not the outcome of an exhaustion to a fixed radius. The improvement
over the manuscript's Proposition `null:obstruction` is mathematical:
only the finite tests \(G_w\), at the successive states of a bounded
positive path, are needed. Neither a universal hypothesis on the entire
coset nor a convex-interior computation is needed by the proof below.
No claim of independently verified novelty or publication acceptance is
made before the required independent review.

Call a capped representative **good** when all its finitely many
Weyl-lift tests are strict:
\[
 m_j^q(G_wz)>c_j\quad(w\in W_J,\ j\in J).
 \tag{2}
\]
Failure of goodness supplies (1) immediately. Below, whenever a move
reaches a representative that is not good, the construction stops and
outputs that representative's failed test.

## 2. Direct Hom proofs, without a spectral sequence

Write \(D=D_1+D_2\) for the full Hom differential between minimal
transported complexes, with subscripts denoting the increase of path
length. There are only lengths \(0,1,2\). The cochain degree, not the
internal or total degree, determines the sign in \(D\).

### 2.1 Middle exactness

Take a homogeneous length-one \(D_1\)-cycle between any ordered pair
of pure layers, and extend it by zero to the full complexes. It is an
actual \(D\)-cycle: \(D_1\) vanishes by assumption and \(D_2\) would
have length three.

For distinct family labels, actual Hom cohomology is zero. For equal
labels it is two-dimensional, generated by the identity and a single
normalized diagonal token. These facts follow by applying the
homotopy-invertible transport to the initial \(P_{f,L}\)'s. The identity
has a nonzero length-zero diagonal entry, and no boundary has any
length-zero entry. The token is an actual cycle and has nonzero
Frobenius cochain supertrace. Boundaries have zero supertrace, by
cyclicity with the cochain sign.

A length-one cycle can represent neither generator. A chosen diagonal
length-zero coefficient kills its identity coefficient; supertrace
kills its token coefficient. Thus it is an actual boundary. Taking
the length-one component of a primitive shows it is a \(D_1\)-boundary
already: the component is \(D_1\) of the primitive's length-zero part.
Project further to the ordered pair of layers, which \(D_1\) preserves.
This proves `null:middle` for every ordered pair, not just for their
sum. Pure direct summands give direct summands of the linear Hom
complex, so the conclusion persists for them.

The parameterized linear-algebra implications in this paragraph are
`middleExact` and `middleExactAcyclic` in `Main.lean`. Their cycle-span
hypotheses are furnished here by the actual transported Hom calculation,
not assumed for arbitrary coefficient arrays.

The symmetric Frobenius trace also pairs opposite length-\(j\) and
length-\((2-j)\) Hom spaces perfectly. The internal degrees add to two
and the cochain degrees add to zero. Its adjointness identity for
\(D_1\), with the cochain sign, makes the induced cohomology pairings
perfect. Euler characteristic therefore gives, after weighting,
\[
 D_0v^{\mathsf T}Cy
   =h_0^{\rm wt}(\mathcal V,\mathcal Y)
    +h_0^{\rm wt}(\mathcal Y,\mathcal V)
    -h_1^{\rm wt}(\mathcal V,\mathcal Y).
 \tag{3}
\]
This identity is valid for subrepresentation families as well; middle
vanishing is asserted only for actual layers and their pure direct
summands, not for arbitrary subrepresentations.

### 2.2 The capped secondary injection

Let \(M_L\) be a pure direct summand of the \(q\)-layer supported on
\(I\), and let \(g:M_L\to Y^d(E_H)\) be a homogeneous length-zero
linear cocycle, \(d<q\), of bidegree \((n,v)\). Thus \(n+v=d-q<0\).
Extend \(g\) by zero.

Its full differential has length two. The target-differential term
goes from source level \(q\) to target level \(d-1\). The
source-differential term would require a token from level \(q+1\)
at a vertex of \(I\), and the cap excludes that term. The pure
direct-summand hypothesis ensures that zero extension introduces no
additional linear differential terms.

Suppose the remaining length-two image is a linear boundary,
\(D_2g=D_1h\), in the stated block. Choose \(h\) of length one, from
\(M_L\) to \(Y^{d-1}(E_H)\), of the same bidegree as \(g\). Then
\[
 D(g-h)=0:
\]
the first term is \(D_2g\), the second is \(D_1h\), and every product
involving \(D_2h\) has length three. The actual Hom cohomology is zero
in this negative total degree, so \(g-h\) is an actual boundary.
But an actual boundary has zero length-zero component. Hence \(g=0\).
There are no incoming linear boundaries in length zero. This proves
the literal injection `null:secondary-map`, including its specified
source and target blocks.

Pairing length two with reverse length zero and summing positive label
weights gives
\[
 h_0^{\rm wt}(\mathcal M,\mathcal Y^d)
 \le h_0^{\rm wt}(\mathcal Y^{d-1},\mathcal M).
 \tag{4}
\]
`secondaryKernelZero` formalizes exactly the cycle-correction argument.
It assumes exactness only in the homogeneous space containing this
negative-total-degree cycle; it does not assert acyclicity of diagonal
Hom in total degrees zero or two.

## 3. Finite Weyl tests and separation

At a capped representative put
\[
 M_L=Y^q(E_L)|_{\widetilde I},\quad
 \sum_Lw_L\dim M_L=\phi m,\quad e=m-c.
\]
The zero level-\(q\) boundary counts make \(M_L\) an actual **pure**
direct summand. There is no assertion that it splits off the full
transported complex. The vector \(e\) is supported on \(J\).

### 3.1 Actual subobjects for the finite tests

For each \(w\), apply \(G_w\) to the full pure \(q\)-layer.
Reduced-word amplitude puts the result in levels \(q-1,q\).
Apply \(G_w^{-1}\), whose amplitude is \([0,1]\), to the low/high
truncation triangle. The low endpoint has levels \(q-1,q\), the high
endpoint \(q,q+1\), and the middle is pure at \(q\). The flanking
cohomology groups force both endpoints to be pure at \(q\). Thus the
triangle is an actual short exact sequence of coefficient
representations
\[
 0\longrightarrow S_{w,L}\longrightarrow Y^q(E_L)
       \longrightarrow Q_{w,L}\longrightarrow0.
 \tag{5}
\]
The subobject is supported on \(J\): it came from the low part,
where all exterior-color counts are unchanged, and inverse twisting
in \(J\) preserves that support. Consequently it lies in \(M_L\).
Twists, canonical truncations, and their morphisms commute with label
tensoring, so its weighted generator array has the form \(\phi s_w\).

Applying \(G_w\) to the quotient recovers the pure high part. Signed
generator counts transform by \(w\); the actual capped negative
operation identifies that high part with the \(q\)-layer at \(G_wz\).
Since \(w c=c\),
\[
 (m^q(G_wz)-c)_J=(w(e-s_w))_J.
 \tag{6}
\]
Remote level-\(q\) coordinates cause no omitted term: they are outside
\(I\cup\partial I\), have zero Cartan coupling to \(J\), and are fixed
by \(W_J\). Equation (6) is the same numerical calculation used in
`cap:hull`, but it uses only the chosen finite reduced lifts, not the
universal representative hypothesis.

### 3.2 The chamber fact used here

For completeness, the needed finite chamber covering has a short
linear proof. On \(\mathbb R^J\) choose \(p\) with \(C_Jp=\mathbf1\),
possible since \(J\) is spherical and \(C_J\) is positive definite.
For a nonzero functional \(\lambda\), choose \(w\in W_J\) maximizing
\(\lambda(wp)\). With \(\nu=\lambda\circ w\), maximality against
\(ws_j\) gives
\[
 0\le \nu(p)-\nu(s_jp)=\nu(\varepsilon_j).
\]
At least one of these coefficients is positive, since \(w\) is
invertible and \(\lambda\ne0\). Hence
\[
 \lambda(v)=\sum_j a_j(w^{-1}v)_j,\quad
 a_j\ge0,\quad\text{some }a_j>0.
 \tag{7}
\]
This argument uses finiteness of \(W_J\), not any chamber coverage
claim for an infinite Coxeter group.

### 3.3 Finite-test separation

Suppose the representative is good and a layer family \(\mathcal Y\),
of folded dimension \(y\), has zero socle on \(J\). Any nonzero
length-zero cocycle \(S_{w,L}\to Y_H\) would have a nonzero graded image
supported on \(J\). In its highest occupied cochain placement that
image has a nonzero socle, also a socle in the target on \(J\). Thus
\[
 h_0^{\rm wt}(\mathcal S_w,\mathcal Y)=0.
\]
Inclusion gives
\(h_0^{\rm wt}(\mathcal Y,\mathcal S_w)
 \le h_0^{\rm wt}(\mathcal Y,\mathcal M)\).
Subtract (3) for \((\mathcal S_w,\mathcal Y)\) from (3) for
\((\mathcal M,\mathcal Y)\). Middle vanishing is used only for the
latter pair. Nonnegativity of the other middle dimension gives
\[
 D_0(m-s_w)^{\mathsf T}Cy
       \ge H:=h_0^{\rm wt}(\mathcal M,\mathcal Y)\ge0
       \quad(w\in W_J).
 \tag{8}
\]

Put \(B=D_0c^{\mathsf T}Cy\le0\), and let
\(\eta(v)=D_0v^{\mathsf T}(Cy)_J\) on \(\mathbb R^J\).
If \(\eta\ne0\), apply (7) to \(-\eta\). Goodness and (6) imply
\[
 \eta(e-s_w)<0
\]
for the selected \(w\). But the left side of (8) is
\(B+\eta(e-s_w)<0\), a contradiction. Therefore
\[
 (Cy)_J=0,\qquad B=H=0.
 \tag{9}
\]
Here \(B=0\) forces boundary vanishing, because
\[
 c^{\mathsf T}Cy
   =-\sum_{a\notin I}\sum_{i\in I}b_{ai}c_i y_a
\]
has strictly negative coefficient for every occupied boundary color.
Finally \(m=c+e\) and (9) give \(m^{\mathsf T}Cy=0\); (3) gives the
reverse Hom vanishing. We have proved
\[
 y|_{\partial I}=0,\quad (Cy)_J=0,\quad
 h_0^{\rm wt}(\mathcal M,\mathcal Y)
 =h_0^{\rm wt}(\mathcal Y,\mathcal M)=0.
 \tag{10}
\]
This proof does not replace actual subobjects by arbitrary numerical
vectors. `strictChamberDetect` and `finiteSeparation` prove its
linear-algebra implications over arbitrary finite real coordinate
spaces.

## 4. The bounded cap-preserving construction

### 4.1 A fixed occupied boundary

The set \(I\setminus J\) is nonempty: otherwise the positive null
vector would contradict positive definiteness of \(C_J\).
Its positive prescribed \(q\)-count occurs in an individual family
member. That member's minimal color support is connected and contains
the unchanged \(f\)-generator, outside \(I\). A support path from that
color to \(f\) must meet \(\partial I\). Thus an occupied boundary level
exists. Boundary cap and zero \(q\)-counts imply
\[
 d_{\min}\le d_b<q.
 \tag{11}
\]
All boundary colors are outside \(J\); their generator placements, and
therefore \(d_b\), are fixed throughout the construction. Positive
amplitude preserves the initial global lower bound \(d_{\min}\).

### 4.2 Stage invariant and the permitted firing

At the start of stage \(d\), maintain for every \(k<d\)
\[
 \operatorname{soc}_{\widetilde J}\mathcal Y^k=0,\quad
 (Cm^k)_J=0,\quad
 h_0^{\rm wt}(\mathcal M,\mathcal Y^k)
 =h_0^{\rm wt}(\mathcal Y^k,\mathcal M)=0.
 \tag{12}
\]
The summand \(\mathcal M\) is always the **current** \(q\)-layer
summand. Initially (12) is vacuous below \(d_{\min}\).

If the state is good, (4) and (12) at \(d-1\) imply
\(h_0^{\rm wt}(\mathcal M,\mathcal Y^d)=0\), since \(d\le d_b<q\).
If \(\mathcal Y^d\) has a socle at color \(j\in J\), every top of
\(\mathcal M\) at that color must vanish. Otherwise label
proportionality supplies a simple quotient at the same unfolded vertex
as that socle, in some source member. Quotient followed by socle
inclusion is a nonzero homogeneous length-zero cocycle, contradicting
the Hom vanishing. The two cochain placements may differ: the
corresponding Hom bidegree is allowed and was included in (4).

The top of \(M_L\) there is the top of the full \(q\)-layer, since it is
a pure block summand. Consequently \(F_j\) preserves the cap. This
justifies performing the move **before** using any property of the
new \(q\)-layer.

### 4.3 Preservation, including the changing \(q\)-layer

If the new state is not good, output its failed finite test. Otherwise
ascend through \(k<d\). Suppose the old top at \(j\) in level \(k-1\)
has already been shown to vanish; below \(d_{\min}\) this is vacuous.
The adjacent-layer exact sequence now says
\[
 Y^k_{\rm new}=Y^k(F_jY^k_{\rm old}).
 \tag{13}
\]
In particular there is no contribution from old level \(k-1\).
The old zero socle on \(J\) remains zero after this pure bottom
operation. Finite-test separation at the **new** representative
therefore supplies all new conditions (12) at level \(k\), including
the Hom conditions with the new \(\mathcal M\).

Both old and new Cartan rows at \(j\) are zero. Other coordinates at
level \(k\) are unchanged, so their difference is
\(2(m_{{\rm new},j}^k-m_{{\rm old},j}^k)=0\). On the other hand the
pure bottom formula is
\[
 m_{{\rm new},j}^k
 =m_{{\rm old},j}^k-(Cm_{\rm old}^k)_j+t_j^k,
\]
where \(t_j^k\) is the weighted old top. Thus \(t_j^k=0\).
Positive label weights kill every constituent top, supplying the
premise for the next \(k\). This is `topVanishes`.

The order is essential: the old top at \(k-1\) justifies (13); only
then do separation and the row comparison prove the old top at \(k\).
At \(k=d-1\) this also justifies (13) for the current stage level \(d\).
There is no circular assumption that an arbitrary pure summand
splits from the full complex, or that previous Hom vanishing
automatically survives a change of \(\mathcal M\).

### 4.4 At most \(L\) firings per stage

The changes at level \(d\) are now the pure bottom operations, which
satisfy the positive braid relations. Write the last operation on the
left. A fired reduced Coxeter word cannot next be extended by a left
descent \(j\): the Coxeter word property moves that \(j\) to the
leftmost, last-action end of a reduced expression of the previous
word; its bottom operation has zero \(j\)-socle, contradicting the
chosen nonzero socle. Each firing is therefore a Coxeter ascent.
Its rank is its reduced length, at most \(L\).

The ascent test uses the old, good state, so it remains valid even if
the new state fails goodness. More explicitly, the rank-state in
`rankStage` consists of a capped representative and a reduced fired
word; its layer-identification and earlier-stage assertions are
required only **if** that representative is good. A good successor
gets those assertions from Section 4.3; at a bad successor they are
vacuous and the procedure stops. Thus the argument does not silently
use new-state separation before checking the new finite tests.

If no failed finite test has appeared, at most \(L\) moves finish the
stage with zero \(J\)-socle. Equation (10) supplies (12) for the next
stage. `rankStage` proves this bounded-rank argument, including the
possibility that goodness fails immediately after a move.

There are \(N\) stages, through \(d_b\) inclusive. Were every visited
representative good, finishing the last stage would give
\(m^{d_b}|_{\partial I}=0\) by (10), contradicting the fixed occupied
boundary. `boundedStagesEscape` constructs a path of at most \(NL\)
actual moves to a representative that is not good. Its failed
Weyl-lift test gives (1), and the lift has length at most \(L\).
This proves the finite-witness theorem.

## 5. Empty \(J\) and the literal manuscript proposition

There is a shorter argument for \(J=\varnothing\). The pure summand
\(\mathcal M\) supported on \(I\) has folded dimension exactly \(c\).
It is nonzero. Its self middle Hom vanishes by Section 2.1, so (3)
gives
\[
 0=D_0c^{\mathsf T}Cc
    =2h_0^{\rm wt}(\mathcal M,\mathcal M)>0.
\]
The last strict inequality follows from the identity of any nonzero
member and its positive squared label weight. This contradiction
does not need connected support or the occupied-boundary argument.

For nonempty \(J\), the literal proposition initially assumes only a
cap on its fixed exterior. Since
\(\partial J\subseteq(I\setminus J)\cup\partial I\), cap accessibility
gives a representative capped on \(J\), hence on all \(I\).
The finite-witness theorem then gives a capped representative in the
same coset with the required non-strict coordinate, contradicting the
proposition's universal strict hypothesis. This proves exactly
`null:obstruction` for every integer \(q\).

## 6. Which earlier inputs are used, and why they apply

The preceding proof is relative to the algebra and actual family
constructed in Sections 2--3 of the manuscript. The following are the
specific categorical interfaces, not assumptions of the target's
conclusion.

1. **Trace and action.** The trace has nonzero weights on every token
   and pairs opposite arrows perfectly. The elementary evaluation and
   coevaluation complexes are homotopy inverses by cancelling their
   token and unit scalar blocks. For one arrow, the two neighboring
   two-term complexes identify up to the two grading shifts, giving
   the three-term braid homotopy by twist conjugation. Orthogonal
   fibers commute. Positive definiteness of a spherical color
   subsystem unfolds it to finite simply-laced type: the positive
   vector obtained from \(C_J^{-1}\mathbf1\) proves positivity in
   every unfolded block by the displayed scaled-form identity.
   The intertwining \(\widetilde C\phi=\phi C\) makes color-word
   descents whole fibers, so reduced alternating rank-two color
   words lift to the same longest element. These facts justify the
   color action also for the manuscript's per-edge label choice;
   they do not appeal to general faithfulness.
2. **Actual family.** Invertibility preserves the initial Hom spaces
   and indecomposability. Tensoring a minimal differential by a
   right simple outside the acted color kills the inserted
   bimodules, so exterior generator placements are fixed. A
   disconnected minimal support would split a noncontractible
   minimal complex, contradicting indecomposability; the fixed
   \(f\)-generator locates its component. Exact right label
   tensoring and the weighted fusion identity give the positive
   fiberwise proportionality of generators, tops, socles, and
   functorially constructed subobjects used above.
3. **Single twists and adjacent layers.** Cancelling the length-zero
   evaluation pairs leaves only levels \(d,d+1\) on pure input.
   The acted test is the token source shifted by
   \(\langle2\rangle[1]\); its upper generators are the old tops.
   Signed counts give the bottom reflection-plus-top formula.
   The tested cone at an unacted neighbor proves preservation of
   zero socle when both old socles vanish. The adjacent-layer short
   exact sequence follows by applying amplitude \([0,1]\) to the
   truncation triangle; both flanking cohomology groups vanish.
   No assumption of exactness of an arbitrary quotient of full
   complexes is made. Positive bottom braid relations follow
   because later positive operations cannot return a discarded
   higher layer to the bottom.
4. **Reduced-word amplitude and negative cap.** These are the
   inputs to (5). The highest-test divisor argument is used only
   on the finite simply-laced unfolding of \(J\). The neighboring
   cone's connecting map is the opposite-arrow product, a nonzero
   token scalar; this identifies its image with the kernel of the
   following test arrow. The induction then extracts a repeated
   left divisor if test height rises twice along a reduced word.
   Such a repetition contradicts reducedness, giving positive
   amplitude \([0,1]\); inverse equivalence gives \([-1,0]\).
   This argument uses arbitrary bounded tests, so pure layers with
   support outside \(J\) are allowed. For the cap, the high quotient
   is supported outside \(J\cup\partial J\) and every inserted
   evaluation or coevaluation term on it is zero. Negative twists
   keep the low truncation below \(q\), hence preserve the joint
   cap and identify its \(q\)-layer with the operation on the old
   pure \(q\)-layer. The same reduced-length ascent argument removes
   excess top levels to prove cap accessibility.

These are prose verifications of the manuscript interfaces, not a
Lean formalization of the fusion-category construction. The only
external Coxeter propositions required here are the reduced word
property and the finite/positive-definite criterion. Their exact
Davis statements, including hypotheses, are archived as
`literature/davis_word_excerpt.txt` and
`literature/davis_finite_excerpt.txt`. Independent attribution is
reserved for the host-invoked Reviewer; it is not impersonated by
the Engineer.

## 7. Exact evidence and its limits

`Main.lean` proves the eight general implications named in
`statement_fidelity.md`. The real Lean 4.31.0 compiler and axiom audit
returned exit code zero and no proof holes; the official certificate
is attached to ledger claim `K_NULL_CORE`. This is a formal certificate
of the indicated algebraic and bounded-induction core, **not** a kernel
proof of the full categorical theorem.

`verify.py` checks `exact_certificate.json`, exact rational polynomial
identities and its source-bound compiler record, and replays an actual
transported-complex example over \(\mathbb Q\). It rejects corrupted
certificates rather than overwriting them with regenerated output.
The optional compiler replay makes a new real run, not a claimed
verdict supplied by the script.

The example has \(S=\{a,b,k\}\), \(m_{ab}=\infty\), \(m_{ak}=3\),
\(m_{bk}=2\), \(X=\{a,b\}\), so \(f\) is adjacent only to \(k\).
With \(I=\{a,b\}\), \(J=\{b\}\), \(c=(1,1)\), \(q=1\), and
\(z=\sigma_b\sigma_a^2\sigma_k\), the minimal complex has eight
generators and \(m_I^1(z)=(1,2)\). Its boundary \(k\) is occupied at
level zero but not one. The finite negative test
\(\sigma_b^{-1}z\) has \(m_I^1=(1,0)\), and is still capped.
Thus this is an actual remote-frame example exercising the cap and
two-layer Hom interface, **not** a counterexample to the manuscript:
its second Weyl test fails the universal strict condition.

The exact replay also checks the two actual self-Hom dimensions,
middle vanishing for all four pairs of occupied layers, and thirty
single-twist inverse tests. Jacobian independently computes the rank
of the displayed \(5\)-by-\(5\) linear Hom differential; its exact
typed payload, operation contract, result, protocol, and server
version are preserved in `jacobian/`. These finite calculations
support implementation and sign checks only. The proof of the
unbounded theorem is Sections 2--5, not these examples.

No false literal manuscript assertion has been established by this
work. Consequently no `F_...` refutation claim is manufactured.
Independent review of the prose bridge, source attribution, and
the significance and novelty of the finite-witness strengthening
remains required. The global manuscript theorems and the campaign
root are not certified by this local result.

## 8. The positive-move bound is sharp for every amplitude

The same remote-frame diagram gives an unbounded sharpness family, not
just the finite example above. Put
\[
 z_n=\sigma_b^{-n}\sigma_a^2\sigma_k,\qquad n\ge0.
\]
There is a minimal model \(C_n=E(z_n)\) with the following generators:
\[
\begin{array}{c|c|c}
 \text{generator}&\text{cochain}&\text{internal}\\ \hline
 f&0&0\\
 k&-1&1\\
 A_s\text{ at }a,\ s=0,1&-2-s&2+2s\\
 B_{s,r,t}\text{ at }b,\ s=0,1,\ r=0,1,\ 1\le t\le n
    &-2-s+t&3+2s-2t .
\end{array}
\tag{14}
\]
All its nonzero differential entries have coefficient one:
\[
 k\longrightarrow f,\quad A_0\longrightarrow k,\quad
 A_1\xrightarrow{\text{token}}A_0,\quad
 A_s\xrightarrow{\text{arrow }r} B_{s,r,1},\quad
 B_{s,r,t}\xrightarrow{\text{token}}B_{s,r,t+1}.
 \tag{15}
\]
The last two types are present only when their indices exist.
All composites are zero by the zigzag multiplication: a nonbacktrack
is zero, and any radical product of length at least three is zero.
Thus this is a genuine minimal complex in every parameter.

Here is a **uniform** proof of its orbit realizability. The base case
\(C_0=B_a^2B_kP_f\) is the explicit two successive evaluation
cancellations; it has the four fixed generators in (14). To prove
\(D_bC_n\simeq C_{n+1}\) for arbitrary \(n\), group the expanded
negative twist into five blocks:
\(A\) (the four fixed generators), \(B\) (old \(b\)-generators),
\(C\) (new insertions from the two \(a\)-generators), and \(U,T\)
(unit and token insertions from \(B\)).
Let \(d\) be the differential on \(A\), \(r:A\to C\) the two-channel
arrow matrix, \(k:C\to B\) the inclusion at the start of each old
string, \(j:B\to B\) the scalar next-index matrix, and \(t\) the
token. The old differential is \(kr\) into \(B\) and \(tj\) within
\(B\). The negative-twist differential is the block matrix
\[
 D=\begin{pmatrix}
 d&0&0&0&0\\
 kr&tj&0&0&0\\
 r&0&0&0&0\\
 0&t&0&0&0\\
 0&1&-k&-j&0
 \end{pmatrix}.
 \tag{16}
\]
Matrix entries act on columns, so products use composition order.
The minus signs are precisely the differential on the inserted
cochain-degree-one bimodule term. The unit/token dual-basis
coevaluation gives the \(1\) and \(t\) in the old \(B\) column.

Only the following relations are needed:
\[
 d^2=0,\quad rd=0,\quad tr=0,\quad t^2=0,\quad
 tj=jt,\quad tk=kt.
 \tag{17}
\]
They hold for every \(n\): the first is the fixed base complex,
the next two are zero path products, and \(j,k\) have scalar entries
between \(b\)-projectives. No bounded nilpotence index of \(j\) is
assumed.

On the three remaining blocks \(A,C,U\), put
\[
 \bar D=\begin{pmatrix}d&0&0\\r&0&0\\0&tk&tj\end{pmatrix},
\quad
 i=\begin{pmatrix}
 1&0&0\\0&k&j\\0&1&0\\0&0&1\\0&0&0
 \end{pmatrix},
\quad
 p=\begin{pmatrix}
 1&0&0&0&0\\0&0&1&0&0\\0&0&0&1&-t
 \end{pmatrix}.
 \tag{18}
\]
Let \(h\) have its sole nonzero block \(h_{B,T}=1\).
Exact noncommutative expansion using (17) verifies
\[
 D^2=\bar D^2=0,\quad Di=i\bar D,\quad pD=\bar Dp,\quad
 pi=1,\quad ip+Dh+hD=1.
 \tag{19}
\]
These are actual chain-homotopy inverse equations, not an equality of
generator counts. The placements in (14) make \(i,p\) homogeneous of
bidegree \((0,0)\), and \(h\) of bidegree \((-1,0)\).
The new \(C\) block is \(B_{s,r,1}\); old unit insertions \(U\) are
the new \(B_{s,r,t+1}\). Thus \(\bar D\) is exactly (15) for \(n+1\).
This proves the claimed actual-frame orbit formula by induction on
**all** \(n\). Empty \(B,U,T\) blocks give the same base transition.

The matrices (16)--(18) and the permitted relations (17) are supplied
in `exact_certificate.json`. The standalone verifier checks all six
identities (19) in the free associative rational algebra modulo
exactly these relations. It rejects additional relations such as
an assumed target identity. Each reduction is a sound ring
replacement, so a zero normal form proves a universal identity;
confluence or a finite matrix substitution is not being assumed.
Finite sample transports additionally check the placement
instantiation, but do not prove the induction.

Finally \(B_{s,r,t}\) has level \(s+1-t\). For \(n\ge1\) the lowest
level is \(1-n\), attained at \(s=0,t=n\). Level one occurs precisely
at \(s=t=1\), in the two channels. Consequently every \(z_n\), \(n\ge1\),
is capped at \(q=1\), with
\[
 m_a^1(z_n)=1,\quad m_b^1(z_n)=2,\quad d_b=0,\quad
 d_{\min}=1-n,\quad N=n,\quad L=1.
\]
Its two finite tests are \(z_n,z_{n+1}\), both strict. The only
positive words in \(J=\{b\}\) are \(\sigma_b^r\). For \(r<n\), their
two tests are \(z_{n-r},z_{n-r+1}\), again both strict; after exactly
\(n\) moves, \(z_0\) has \(m_b^1=0\). Every intervening cap is valid.
Thus **the bound \(NL\) for the positive part is attained for every
positive integer \(N\)**, even with a nonadjacent frame and a
rank-one spherical parabolic. This also proves that the positive
budget cannot be replaced by a bound independent of the lower
amplitude. It does not assert optimality of the additional negative
lift allowance \(L\).
