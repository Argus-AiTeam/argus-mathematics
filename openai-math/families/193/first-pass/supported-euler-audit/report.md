# Supported Euler comparison: Proposition as:base-equality

## Statement and scope

The target is `as:base-equality`, in
`build/sections/asymptotic.tex:338-463` of the staged September 23, 2026
manuscript. Its assertion is

\[
 \chi_{\rm ord}(X\otimes_A^{\mathbf L}T)
 = r\chi_A(X)
 = \chi_C(X\otimes_A^{\mathbf L}T)
 \qquad (X\in\mathcal P_A^J).
\]

Here \(A\) is the stated excellent regular local
\(\mathbb Z_{(p)}\)-algebra of dimension \(e>0\), \(J\) its maximal
ideal, and \(z_1,\ldots,z_e\) its regular parameters. The finite local
domain \(T\) has the same residue field and \(r=\operatorname{rank}_A T\).
The \(T\)-algebra \(C\) has the nonnegative additive length in
`as:length-hypotheses`, including all parameter powers. No faithfulness
of this length is assumed.

The sequence ranks are \(O(s_n)\), all complexes have a common bounded
degree interval, and the rank-small generators satisfy the **ordinary**
estimate \(o(s_n)\). The abelian length quotients instead kill zero
normalized ultralimit length. There is no assumption here that
\(s_n\longrightarrow\infty\). Support means a fixed power of each parameter
annihilates the identity in the category in question. In particular,
neither a uniformly supported representative of the object itself nor a
lift of its summand projector may be assumed.

The campaign's Serre-positivity claim and the descent, connective-coefficient,
approximation, and positive-evaluation steps remain separate obligations.
An Engineer argument is not an independent Reviewer certification.

## External inputs settled in scope

These are foundational inputs or narrowly scoped literature inputs, not
certifications of the manuscript's applications.

* **Finite resolutions:** Stacks Project, Tag `00OE`, Lemma 10.110.8:
  a Noetherian regular ring of dimension \(e\) has global dimension \(e\).
  Thus finite modules over the local ring \(A\) have bounded finite free
  resolutions. Finiteness of successive syzygies uses Noetherianity;
  finite projectives over a local ring are free.
* **Regular parameters:** Stacks Tag `00NN`, Lemmas 10.106.2-3:
  a regular local ring is a domain and its minimal maximal-ideal
  generators form a regular sequence. The Koszul resolution then follows
  by induction: tensoring with the next two-term Koszul factor takes
  the cone of a nonzerodivisor on the preceding degree-zero quotient.
* **Finite spectral data:** Stacks Tags `012O`, `0130`, `0132`, and `061Z`
  give naturality of filtered-complex spectral sequences, the double-complex
  pages, finite convergence, and the hyper-Tor page. Only the finite,
  bounded case is used. They do **not** by themselves assert descent through
  the manuscript's Verdier quotient.
* **Idempotent completion:** Balmer--Schlichting,
  DOI `10.1006/jabr.2000.8529`, Proposition 1.3, Definition 1.10,
  and Theorem 1.12: additive functors into idempotent-complete targets extend,
  and distinguished triangles in the completion are summands of original
  distinguished triangles. This does **not** assert lifting of projectors.
* **Serre quotients:** Stacks Tag `02MS`, Lemma 12.10.6, constructs the
  abelian quotient and its exact quotient functor. The length-zero class
  must first be proved Serre; its application is not automatic.
* **Normalized length, only for the separate length-input node:** CLMST
  `arxiv:2209.04046v4`, Notation 4.0.1, Corollary 4.0.4,
  Propositions 4.0.10 and 4.0.14. Their setting is a complete
  mixed-characteristic local domain with perfect residue field, its chosen
  Cohen subring and perfectoid tower. They give almost annihilation of
  parameter homology, invariance of normalized length under the indicated
  almost isomorphisms, and the parameter-quotient multiplicity formula.
  At tower stage zero this supplies the asserted length identities.
  This does not certify descent to another base or the manuscript's entire
  implementation of `len:input`. The target comparison takes
  `as:length-hypotheses` as hypotheses and does not invoke CLMST.
* **Descent, only for the separate descent node:** Land--Tamme
  `arxiv:1808.05559v3`, Corollary 3.9 and Remark 3.10 give truncation/excision
  for rational infinitesimal \(K\)-theory; Theorem B.3 gives cdh descent
  with connective algebra coefficients over the stated base scheme.
  Finite-surjection descent, the orbit argument, and identification of the
  manuscript's coefficient algebra are additional obligations, not
  consequences recorded as established here.

The downloaded primary sources are in `sources/`. Supporting citation
attribution by an independent reader is still required. The inherited Wiki
has no page on this supported Euler comparison; its unrelated Serre-duality
and Bass--Serre pages supply no input.

## Excluded route

Evaluating raw homology on an arbitrary unsupported lift cannot define these
functors. The manuscript itself gives the DVR example in
`as:nonuniform-warning`. That is a failed strategy, not a new refutation.
It is recorded as a retired route. No counterexample to the proposition,
and no false proof step, has yet been established by this scope work.

## Exact computation selected

The bounded Jacobian operation `matrix.nullspace.compute` was inspected and
run on the integral differential \((0,-b,a)\) over the monomial basis
\((1,a,b,ab)\) of \(\mathbb Q[a,b]/(a^2,b^2)\).
It returned rank \(3\) and kernel spanned by \(ab\).
The exact request and typed response are `jacobian_payload.json` and
`jacobian_output.json`; the adapter exited zero, with protocol
`2025-11-25`, server `0.14.0`, and no reported error or timeout.
The rational answer is not asserted to be a finite-field answer.
Independent finite-field replay and its mathematical application are
developed below.

The inspected operation `finite_field.linear_map.rank.compute` instead
requires a direction in a finite extension and a matrix-space basis.
That contract does not directly describe this Tor differential; it was
not forced onto the problem.

## Verification theorem

**Theorem.** Under exactly the hypotheses above, `as:supported-quotient`,
the evaluations needed for `as:base-equality`, and `as:base-equality`
hold. In fact there is a natural isomorphism

\[
 \mathsf H_i^C(X\otimes_A^{\mathbf L}T)
 \ \simeq\
 \overline F\bigl(\mathsf H_i^A(X)\bigr),
 \qquad X\in\mathcal P_A^J,
 \tag{1}
\]

where \(\overline F:\overline{\mathcal A}_A\to
\overline{\mathcal A}_C\) is the exact functor induced by
\(V\mapsto V\otimes_A C\). Consequently
\(b_i^C(X\otimes_A^{\mathbf L}T)=r b_i^A(X)\) in every degree.
There is in general no analogous coefficientwise identity for ordinary
homology; the ordinary assertion is an Euler identity.

This is an Engineer's mathematical verification, with a formal module
core and exact computational supporting evidence. It is not a kernel
formalization of the entire theorem and is not yet independently reviewed.

### 1. Supported roofs and bounded evaluations

We include these constructions because applying a spectral sequence only
to supported representatives would not cover the question.

Write \(\mathcal Q_S=\mathcal S_S/
(\mathcal S_S\cap\mathcal N_S)\).
If \(X\in\mathcal S_S\), \(N\in\mathcal N_S\), and \(f:X\to N\),
choose \(v\) killing every parameter action on \(X\). Exactness of
\(\operatorname{Hom}(X,-)\) applied to

\[
 \operatorname{fib}(z_j^v:N'\to N')\longrightarrow N'
       \xrightarrow{z_j^v}N'
\]

lifts a map \(X\to N'\) to the fiber: its composite with \(z_j^v\)
is zero by centrality and the zero action on the **original source**
\(X\). Iterating, \(f\) factors through \(K_v\otimes_A N[-e]\).
This object is small by thickness and uniformly supported by the Koszul
homotopies.

For a roof \(X\leftarrow Z\to Y\) between supported objects with small
left cone \(N_0\), factor \(X\to N_0\) through a supported small object
\(N_1\) as just proved. The fiber \(Z_1\) of \(X\to N_1\) is supported.
The map of fiber triangles refines the original roof to
\(X\leftarrow Z_1\to Y\), with left cone \(N_1\). This proves fullness.
For faithfulness, if a supported numerator \(f:Z\to Y\) is zero in the
ambient quotient, a denominator \(W\to Z\) with small cone makes its
composite zero. The triangle then factors \(f\) through that cone.
Factor its first leg through a supported small object as above; it is
already zero in \(\mathcal Q_S\). Applying this to a roof's numerator
proves faithfulness.

If \(X\) is supported only in \(\mathcal P_S\), write it as a retract of
\(q_SF\), enlarging a prequotient retract to a bounded free sequence
\(F\). Choose \(v\) killing its parameter actions in \(\mathcal P_S\).
Successively taking cones of zero actions shows that \(X\) is a retract
of \(K_v\otimes_A X\), hence of \(q_S(K_v\otimes_A F)\).
The latter has a uniformly supported bounded free lift. Thus

\[
 \mathcal P_S^J\simeq\mathcal Q_S^\natural.                 \tag{2}
\]

There was no replacement of quotient support by support on a chosen lift.

For completeness, put \(L_T=\length_T\) and \(L_C=\lambda\).
For fixed \(v\), Koszul homology first in \(K_v\otimes F_n\) gives

\[
 L_S H_i(K_v\otimes_A F_n)
 \ \leq\ \sum_{j=0}^e
       \operatorname{rank}_S(F_{n,i-j})\,L_S H_j(K_v\otimes_A S),
 \tag{3}
\]

where for \(S=C\) the free complex is first extended from \(T\).
The ordinary constants are finite because \(T\) is finite over \(A\)
and \((z_1^v,\ldots,z_e^v)\) is \(J\)-primary. The \(C\) constants
are \(v^e r\) for \(j=0\) and zero otherwise by the hypotheses.
Finite spectral-page subquotients and finite filtrations justify the
inequality using only nonnegativity and additivity. All bounds have
constants independent of \(n\).

If \(F\) is uniformly supported, successive split cones give
\(K_v\otimes F\simeq\bigoplus_jF[j]^{\binom ej}\).
No simultaneous choice of commuting null homotopies is required:
at each step a cone of a zero map splits. Therefore (3) bounds the
actual homology of \(F_n\) by \(O(s_n)\).
Each parameter power kills this homology; for example
\(J^{e(v-1)+1}\subseteq(z_1^v,\ldots,z_e^v)\) gives a common
primary annihilator. A supported prequotient retract is a retract of a
uniformly supported bounded free Koszul lift by the same argument as
above, so these bounds extend to all of \(\mathcal S_S\).

The uniformly primary, finite-length \(O(s_n)\) sequence categories are
abelian. Their zero normalized-ultralimit-length objects are Serre:
subobjects and quotients have smaller nonnegative length, and normalized
length is additive on short exact sequences. Their Serre quotients
therefore have the stated finite additive lengths.

For fixed \(v\), the class of \(N\in\mathcal D_S\) whose
\(H_i(K_v\otimes N)\) vanish in the length quotients for every \(i\)
is thick: homology long exact sequences and retracts prove this.
By (3) it contains every ordinary \(o(s_n)\)-rank generator, hence
\(\mathcal N_S\). If \(N\) is also supported, the split-cone retraction
then makes \(H_i(N)\) zero in the length quotients.
Thus supported-small-cone maps induce homology isomorphisms there.
Homology localizes to \(\mathcal Q_S\) and extends to
\(\mathcal Q_S^\natural\) by idempotent images.

Compatible idempotent images preserve exact sequences, as proved in
Step 2. Balmer--Schlichting then supplies the triangle structure needed
to conclude that the extended functors are homological. Each object is
a summand of one bounded lift, so only finitely many homologies are
nonzero, and the Euler sums are additive. These are precisely the
evaluations used below, not new functions defined from unsupported raw
homology. The split-cone argument in the quotient also proves
`as:koszul-polynomial`.

### 2. Images of idempotents in an abelian target

Everything in this step occurs **after applying a functor** to an abelian
category \(\mathcal B\). It does not assert a lift to the original
complexes.

An idempotent \(p\) splits an object as
\(\operatorname{im}p\oplus\operatorname{im}(1-p)\).
If maps in an exact sequence commute with compatible idempotents,
the sequence is a direct sum of its two image sequences. Its homology
is the direct sum of theirs, so both image sequences are exact.
Likewise, an idempotent chain map splits a complex, proving canonically

\[
 H(\operatorname{im}p)\simeq\operatorname{im}H(p).          \tag{4}
\]

For a \(p\)-invariant subobject \(F\subseteq B\),

\[
 \operatorname{im}p\cap F=p(F).                           \tag{5}
\]

One inclusion follows from invariance. For the other, \(p\) restricts to
the identity on \(\operatorname{im}p\); the intersection is therefore
already the image of its restriction from \(F\). Applying exact image
sequences to \(0\to F_{u-1}\to F_u\to\operatorname{gr}_uB\to0\)
gives

\[
 \operatorname{gr}_u(\operatorname{im}p)
       \simeq\operatorname{im}(\operatorname{gr}_u p),     \tag{6}
\]

with the filtration \(p(F_u)=\operatorname{im}p\cap F_u\).
This is a categorical argument in any abelian target; it makes no
representation assumption on its morphisms.

`Main.lean` checks the arbitrary-ring module core of exact image sequences,
(5), and fixed-element lifting for invariant quotients.
`statement_fidelity.md` separates that core from the unformalized
categorical construction.

### 3. A localization lemma for finite spectral data

This is the passage whose compatibility must be proved, not assumed.

For an abelian category \(\mathcal B\), let
\(\operatorname{Sp}_k^{\rm fin}(\mathcal B)\) have the following objects:
a finite-support spectral sequence from page \(k\), its differentials and
specified transition isomorphisms \(E_{r+1}\simeq H(E_r)\), a finitely
graded abutment \(B_i\) with finite exhaustive filtrations, and specified
isomorphisms
\(\operatorname{gr}_u B_i\simeq E_\infty^{u,i-u}\).
One may retain all the pages, constant after stabilization; no common
bound across different objects is required. Morphisms are page maps and
filtered abutment maps compatible with all these data.
They are not assumed strict.

**Inversion lemma.** A morphism in this category that is an isomorphism
on page \(k\) is an isomorphism of the entire spectral datum.

Indeed it is an isomorphism on every subsequent page by functoriality
of homology. Thus it is an isomorphism on every graded piece of every
abutment. Take common lower and upper filtration bounds for the two
objects. Induction in

\[
 0\longrightarrow F_{u-1}B_i\longrightarrow F_uB_i
       \longrightarrow\operatorname{gr}_u B_i\longrightarrow0
\]

and the short five lemma make every filtration-piece map an isomorphism.
In particular the total abutment map is an isomorphism, and its inverse
preserves each filtration piece because those piece maps are isomorphisms.
The inverses commute with the structural maps. This proves the lemma,
including the filtered part; an unfiltered abutment isomorphism alone
would not suffice.

**Image lemma.** This category is idempotent complete. For an idempotent
datum take its image on each page. Equation (4) supplies the transition
isomorphisms. Filter its image abutment by the images of the filtration
steps; (5)-(6) supply precisely the required graded identifications.
All supports and filtrations stay finite. The image's inclusion and
projection are morphisms of spectral data and split the idempotent.

Consequently, suppose an actual functor from \(\mathcal S_A\) to this
category is constructed and its page \(k\) inverts supported-small-cone
maps. The inversion lemma proves that the **whole** functor inverts them.
By the ordinary categorical localization property, a supported roof
\(Y\leftarrow^s Z\to^f Y'\) acts by
\(\Phi(f)\Phi(s)^{-1}\), independently of the roof. It factors through
\(\mathcal Q_A\). The image lemma then extends it to
\(\mathcal Q_A^\natural\).
This conclusion has not assumed any idempotent lift or any compatibility
of the filtrations beyond what was explicitly constructed.

An augmentation or other natural abutment identification constructed
before localization remains natural after localization: its naturality
squares for inverses follow by multiplying those for \(s\) by
\(\Phi(s)^{-1}\). They also remain natural on idempotent images.
This identifies the action on the abutment with the intended scalar
extension action, rather than a newly chosen action.

### 4. The ordinary spectral datum really satisfies the lemma

Fix a finite free resolution \(P_\bullet\to T\), with
\(\rho_u=\operatorname{rank}_A P_u\).
For a uniformly supported bounded free sequence \(Y\), filter
\(\operatorname{Tot}(Y\otimes_A P)\) increasingly by the \(P\)-degree.
The differential in \(P\) lowers that degree, so this is a filtration
by subcomplexes. The initial page is exactly `as:ordinary-page`:

\[
 E^1_{u,b}=H_b(Y)\otimes_A P_u=H_b(Y)^{\oplus\rho_u}.       \tag{7}
\]

It lies in \(\overline{\mathcal A}_A\).
Pages are subquotients of this finite rectangle; abutment filtration
pieces are finite extensions of its eventual subquotients.
Their lengths are \(O(s_n)\), and a bounded product of their common
primary annihilators annihilates each extension. Thus **every** part
of the spectral datum belongs to the actual sequence category and its
Serre quotient.

A homotopy in \(Y\) tensored with \(P\) preserves the \(P\)-degree
filtration. With total differential
\(d(y_b\otimes p)=d_Yy_b\otimes p+(-1)^b y_b\otimes d_Pp\),
the homotopy is \(h_Y\otimes1\): its two \(d_P\)-cross terms cancel
because \(h_Y\) raises \(b\) by one.
It gives the same page-one map and the same total homology
map. The induced filtration-piece maps agree as well, since these are
subobjects of total homology. Later page maps are determined by the
page-one maps. Thus this is a functor from the supported homotopy
category, not merely from chain maps. Extend to supported prequotient
retracts by the image lemma; Step 1 shows that these are all of
\(\mathcal S_A\).

For a supported-small-cone map \(s\), Step 1 makes every \(H_b(s)\)
an isomorphism in \(\overline{\mathcal A}_A\).
Finite free \(P_u\) makes (7) an isomorphism on every component.
The inversion lemma therefore localizes the whole finite filtered
datum, not just its pages.

Because \(Y\) is bounded free, the natural augmentation
\(\operatorname{Tot}(Y\otimes P)\to Y\otimes T\) is a quasi-isomorphism.
Its abutment identification is natural and localizes as in Step 3.
Scalar extension takes a rank-small free \(A\)-sequence to a rank-small
free \(T\)-sequence, hence takes \(\mathcal N_A\) to \(\mathcal N_T\);
it also preserves support. Thus its supported homology evaluation
is indeed defined on the same roofs.

Restriction of finite \(T\)-modules to \(A\) is exact and preserves
length: all \(T\)-composition factors are the common residue field,
of \(A\)-length one. It therefore induces a length-preserving exact
functor \(\overline{\mathcal A}_T\to\overline{\mathcal A}_A\).
Under this functor the augmentation identifies the abutment with
\(\mathsf H_i^{\rm ord}(Y\otimes T)\).

Now let \(a\) be any idempotent of \(Y\) **in \(\mathcal Q_A\)**.
The localized functor makes it an actual idempotent on every page and
every abutment filtration step. By the natural augmentation its
abutment action is the ordinary homology of the scalar-extended
idempotent. The image lemma applies to this action without selecting
any representative chain projector.

### 5. Ordinary Euler calculation on the actual summand

Set \(V_b=\operatorname{im}\mathsf H_b^A(a)\) and
\(\ell_b=\overline\length_A V_b\).
The image of (7) is \(V_b^{\oplus\rho_u}\): the page-one functor
is literally the finite direct sum of the localized homology functor,
also on roof inverses.

For any finite homological page, its differential decreases total degree
by one. At each position, the length of the page term is the length of
its next-page homology plus its incoming- and outgoing-boundary lengths.
In the signed sum each boundary appears twice with opposite signs.
Thus the page Euler sum is unchanged. This applies to the **image**
spectral datum by (4). On its last page, finite-filtration additivity
and (6) identify that Euler sum with the Euler sum of the image
abutment. Consequently

\[
 \begin{split}
 \chi_{\rm ord}((Y,a)\otimes_A^{\mathbf L}T)
  &=\sum_{u,b}(-1)^{u+b}\rho_u\ell_b\\
  &=\left(\sum_u(-1)^u\rho_u\right)
          \sum_b(-1)^b\ell_b
   = r\,\chi_A(Y,a).                                    \tag{8}
 \end{split}
\]

The last equality tensors \(P_\bullet\to T\) with the fraction field of
the regular local domain \(A\). Exactness gives the alternating rank
\(r\). No \(A\)-flatness or Cohen--Macaulayness of \(T\) was used.

### 6. The normalized tensor functor and its spectral datum

For the residue field \(k=A/J\), the regular-parameter Koszul resolution
and `as:length-hypotheses` at \(v=1\) give
\(\lambda\operatorname{Tor}_u^A(k,C)=0\) for \(u>0\) and
\(\lambda(k\otimes C)=r\).

Induct on a composition series of a finite-length \(A\)-module \(V\).
For \(0\to V'\to V\to k\to0\), the Tor long exact sequence shows
each positive Tor of \(V\) is an extension of subquotients of positive
Tors of \(V'\) and \(k\); their lengths are zero by nonnegativity and
additivity. The sequence

\[
 \operatorname{Tor}_1^A(k,C)\longrightarrow
 V'\otimes C\longrightarrow V\otimes C\longrightarrow k\otimes C
 \longrightarrow0
\]

then gives the degree-zero length by additivity, since the first image
has length zero. All these modules have finite length in the specified
sense. This proves `as:finite-tor` without a completeness assumption:

\[
 \lambda\operatorname{Tor}_u^A(V,C)=0\ (u>0),\qquad
 \lambda(V\otimes C)=r\length_A V.                        \tag{9}
\]

A power \(J^m\) annihilating \(V\) annihilates these Tor modules as
well: multiplication by each of its elements on \(V\) is the zero
derived morphism, so induces zero after derived tensoring.

Apply (9) termwise to uniformly primary, \(O(s_n)\)-length sequences.
The functor \(F(V)=V\otimes C\), followed by the target Serre quotient,
is exact: for a short exact sequence its left-exactness defect is an
image of a positive Tor module of zero length. It kills the source
zero-ultralimit-length Serre class, since its lengths are exactly
multiplied by \(r\). The universal property of the Serre quotient
therefore gives an exact functor

\[
 \overline F:\overline{\mathcal A}_A
             \longrightarrow\overline{\mathcal A}_C,
 \qquad \overline\lambda\,\overline F=r\,\overline\length_A .
 \tag{10}
\]

There is no assertion that tensoring is exact before the target
length-zero quotient.

For uniformly supported \(Y\), take its canonical finite Postnikov
tower in \(D(A)\), apply derived tensor with \(C\), and apply homology.
This gives the natural hyper-Tor spectral datum `as:c-page`,

\[
 {}^CE^2_{u,b}=\operatorname{Tor}_u^A(H_b(Y),C)
       \Longrightarrow H_{u+b}(Y\otimes_A^{\mathbf L}C).   \tag{11}
\]

The canonical truncation functors and their natural triangles give
maps of the entire tower, so they give functorial page maps **and**
filtered abutment maps on derived morphisms. No functorial choice of
free resolutions of all \(H_b(Y_n)\) is being assumed.
The coordinate \(b\) lies in one common bounded interval and
\(0\leq u\leq e\), by regularity of \(A\).
Equation (9) gives uniform primary annihilators and finite \(O(s_n)\)
lengths on page two. All later pages and the finite filtered
abutment are again in the target sequence category. These statements
also follow on the abutment directly from Step 1.

In \(\overline{\mathcal A}_C\), (11) has only the \(u=0\) line,
which is \(\overline F(H_b(Y))\). A supported-small-cone map is an
isomorphism on \(H_b(Y)\) in \(\overline{\mathcal A}_A\), hence on
this line by (10), and on the other lines since they are zero.
The inversion lemma for \(k=2\) now proves actual localization of this
entire filtered datum.

Its abutment is the prescribed \(C\)-homology evaluation after scalar
extension, by associativity
\((Y\otimes_A^{\mathbf L}T)\otimes_T^{\mathbf L}C
 \simeq Y\otimes_A^{\mathbf L}C\).
This identification is natural before localization and remains so.
For \((Y,a)\), exactness of \(\overline F\) makes the image of its
zero-Tor term exactly \(\overline F(V_b)\). The image lemma identifies
this with the corresponding image abutment; equivalently the single
surviving graded piece gives the natural isomorphism (1).
Taking lengths and Euler sums yields

\[
 \chi_C((Y,a)\otimes_A^{\mathbf L}T)
        = r\sum_b(-1)^b\ell_b.                          \tag{12}
\]

Finally (2) presents **every** supported quotient object as such a
\((Y,a)\). Equations (8) and (12) prove the proposition under its full
support and idempotent hypotheses. This proves the desired compatibility
rather than assuming it as an abstract lemma.

## An admissible nonflat test family

Fix a prime \(p\), let \(k=\mathbb F_p\), and put

\[
 A=k[[a,b]],\quad B=k[[u,b]],\quad a=u^2,\quad
 I=(a,b)\subset A,\quad T=A\oplus Iu\subset B,\quad C=B.
 \tag{13}
\]

The map \(\mathbb Z_{(p)}\to A\) is reduction modulo \(p\).
The ring \(A\) is excellent regular local of dimension two.
The parity decomposition of power series in \(u\) gives
\(B=A\oplus Au\). Since \((Iu)^2=aI^2\subseteq A\),
\(T\) is a subring, finite as an \(A\)-module and a domain.
It is local with residue field \(k\): an element with unit even part has
an inverse in \(T\), by the conjugate formula with denominator
\(x^2-a y^2\in A^\times\); the other elements lie in its maximal ideal.
Its \(A\)-rank is two. A finite free resolution is

\[
 0\longrightarrow A
   \xrightarrow{(0,-b,a)} A^3
   \xrightarrow{(x,y,z)\mapsto x+(ay+bz)u}T
   \longrightarrow0.                                  \tag{14}
\]

Exactness follows from the syzygy of the regular pair \(a,b\).
Thus \(T\) is not \(A\)-flat.
Take \(\lambda=\length_B\) on primary-torsion \(B\)-modules,
allowing infinite values outside the finite-length part. The
\(A\)-module \(B\) is free of rank two.
The pair \(u^{2v},b^v\) is \(B\)-regular and has quotient length
\(2v^2\). Hence **all** the section's length hypotheses hold, not just
their first few tested instances.

For \(V=A/(a^m,b^q)\), \(m,q\geq1\), put \(d=mq\).
Tensoring (14) with \(V\) gives the differential \((0,-b,a)\)
from \(V\) to \(V^3\).
The common annihilator of \(a,b\) in \(V\) is exactly its
one-dimensional socle \(k a^{m-1}b^{q-1}\).
Every other monomial column has a private nonzero target coordinate:
use the \(-b\) coordinate if its \(b\)-exponent is below \(q-1\),
and otherwise its \(a\) coordinate. Thus the rank is \(d-1\)
over every field and

\[
 \length\operatorname{Tor}_0^A(V,T)=2d+1,\quad
 \length\operatorname{Tor}_1^A(V,T)=1,\quad
 \chi(V,T)=2d.
 \tag{15}
\]

By contrast, \(V\otimes_A B\) has length \(2d\) and no higher Tor.
The supported sequence \(Y_n=K(a^m,b^q;A)^{\oplus n}\), normalized
by \(s_n=n\), retains this positive ordinary Tor correction: its
normalized ordinary homology lengths are \(2d+1,1\), not \(2d,0\).
The equalities of Euler sums hold exactly.
This is not a counterexample to `as:base-equality`; it refutes only the
unjustified stronger route of treating \(T\) as flat or its positive
Tor as negligible.

For a quotient stress test, append one copy of this uniformly
supported Koszul complex to \(2n\) copies, and act on the copies by
\(\operatorname{diag}(1_n,0_n,2)\) in characteristic three.
The square-minus-itself factors through that one extra Koszul copy,
whose term ranks are \(1,2,1=o(n)\). It is therefore an idempotent
after the **ordinary** rank quotient although this representative is
not a projector. Projection away from the extra copy is a supported
denominator. This particular quotient idempotent does have another
projector lift; the example is not advertised as a nonlifting witness.
The general proof, not this example, covers idempotents with no lift.

## Evidence and limits

`verify.py` replays the typed Jacobian answer over the rationals, checks
its exact kernel and rank, checks the nonflat Tor matrices over several
prime fields and rectangular truncations, exhausts small commuting
idempotents on a two-term complex, and checks invariant-filtration image
and quotient identities. It also checks the symbolic total-degree change
of a spectral differential and the exact boundary cancellation used in
the finite Euler argument. These are supporting computations, not a
finite-experiment substitute for Steps 1-6.

The formal certificate concerns only `C193_IMAGE_CORE`, with the precise
fidelity limitations stated alongside its source. No claim is made that
the compiler constructed the Serre quotient, the supported roofs, or the
spectral-data localization.

The real Lean 4.31.0 run in `lean_verification.json` succeeded with
`exit_code=0`, `proof_holes=[]`, and a recorded mechanical certificate at
`certificates/C193_IMAGE_CORE-2c78a4abb06dac43.json`. The subsequent official
freshness check found no issues. The initial import-only attempt failed
because the selected submodule import did not expose `LinearMap.range`;
the corrected import was compiled, rather than relabelling that failure.
No theorem source or fidelity document was edited after the successful run.

The persisted `exact_certificate.json` has been replayed by the default
`python3 research/supported-euler-audit/verify.py` command. It contains 48
exact nonflat-family cases, all 18 and 32 commuting projector pairs for
the chosen two-term complex over \(\mathbb F_2\) and \(\mathbb F_3\),
and all 34 and 60 invariant projector/subspace pairs, respectively.
Those finite checks are not claimed to certify a general quotient.

**Classification.** No false manuscript proposition and no false proof
step have been found in this comparison. The identified quotient/idempotent
compatibility uncertainty is resolved by the argument above, subject to
independent review of the unformalized steps and the foundational source
readings. A remaining unformalized dependency is not presented as a
counterexample. In particular this work does not refute Serre positivity.

**Improvement over the strongest prior result.** The manuscript already
states the equality and sketches its spectral-sequence proof. This report
supplies the explicit spectral-data target, proves the filtered inversion
and image criteria, checks that the actual two constructions meet them,
and identifies the natural scalar-extension action. It additionally states
the functor-level \(C\)-homology comparison and supplies a faithful formal
module core and a nonflat full-hypotheses test. Novelty and publishable
significance are not claimed verified. This bounded bridge result does not
close the campaign's independent publishable-result objective.

All nonformal manuscript nodes remain `open` and `reviewer_confirmed=false`
in the proof graph. Supporting source attribution and statement-fidelity
review are outstanding for the independent Reviewer; the Engineer's source
readings are not recorded as independent confirmations.
