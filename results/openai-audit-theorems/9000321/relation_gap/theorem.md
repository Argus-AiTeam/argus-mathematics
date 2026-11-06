# Exact relation gap one for the original and extended presentations

## 1. Statement and conventions

Let \(n\in\{5,6\}\). Let \(F_5\) be free on
\(x_1,a_1,x_2,a_2,s\), and let \(F_6\) have the additional generator
\(t\). Put
\[
\begin{aligned}
r_1&=x_1a_1x_1^{-1}a_1^{-4},&
r_2&=x_2a_2x_2^{-1}a_2^{-3},\\
r_3&=x_1a_2^{-13},&
r_4&=sx_2s^{-1}a_1^{-5},&
r_5&=tst^{-1}x_1^{-1}s^{-1}.
\end{aligned}
\]
Only \(r_1,\ldots,r_{n-1}\) are used for \(F_n\). Define
\[
\begin{gathered}
N_n=\langle\!\langle r_1,\ldots,r_{n-1}\rangle\!\rangle_{F_n},
\qquad P_n=F_n/N_n,\\
t_1=x_1^2,\quad t_2=x_2^3,\quad w=t_1t_2,\\
K_n=\langle\!\langle t_1,t_2\rangle\!\rangle_{P_n},\quad
G_n=P_n/K_n,\quad R_n=\ker(F_n\longrightarrow G_n).
\end{gathered}
\]
Repeated word symbols also denote their images in the stated quotients.
Commutators mean \([u,v]=uvu^{-1}v^{-1}\).

Write \(d_F(R)\) for the least cardinality of an \(F\)-normal generating
set of \(R\), and \(d_{\mathbb ZG}(M)\) for the least number of **left
module generators**. The latter is not a claim that \(M\) is free or
has a specified group-ring rank. Throughout,
\[
\operatorname{Def}(G)=
\max\{p-q:\ G\text{ has a finite presentation with }p
\text{ generators and }q\text{ relators}\}.
\tag{1}
\]

**Theorem.** For both \(n=5\) and \(n=6\),
\[
\begin{aligned}
\langle\!\langle w\rangle\!\rangle_{P_n}
  &=\langle\!\langle t_1,t_2\rangle\!\rangle_{P_n},\\
\langle\!\langle r_1,\ldots,r_{n-1},w\rangle\!\rangle_{F_n}
  &=R_n,\\
d_{F_n}(R_n)&=n,\qquad
d_{\mathbb ZG_n}(R_n/[R_n,R_n])=n-1,\qquad
\operatorname{Def}(G_n)=0.
\end{aligned}
\tag{2}
\]
In particular, the following are explicit balanced presentations with
exact relation gap one:
\[
\begin{split}
G_5&=\langle x_1,a_1,x_2,a_2,s\mid
 r_1,r_2,r_3,r_4,x_1^2x_2^3\rangle,\\
G_6&=\langle x_1,a_1,x_2,a_2,s,t\mid
 r_1,r_2,r_3,r_4,tst^{-1}x_1^{-1}s^{-1},x_1^2x_2^3\rangle.
\end{split}
\tag{3}
\]
The normal-generator lower bound is over **all** normal generating
sets, not just sets retaining some of the displayed relators.

This presentation-theoretic consequence has independent mathematical
support, not a certified originality or significance verdict. It is
neither a refutation of the manuscript nor a Lean-certified theorem.
The universal assertions below have a mathematical proof; `verify.py`
certifies only the explicitly stated finite algebra. Section 6 separates
these accepted results from the remaining contribution assessment.

## 2. Precisely which accepted results are used

Let \(B_n\) be the presentation two-complex for \(P_n\). The unchanged
manuscript verification [V, Sections 3-6] and the accepted extension
[A, Sections 3.1-3.2] establish:

1. \(K_n\) is perfect. For \(n=5\), the actual identities
   \[
   t_1=a_2^{26}=[t_2,a_2],\qquad
   st_2s^{-1}=a_1^{15}=[t_1,a_1]
   \tag{4}
   \]
   give this result by coprime annihilation in \(K_5/[K_5,K_5]\).
   For \(n=6\), the normal closure of the perfect image of \(K_5\)
   is perfect; no embedding \(P_5\hookrightarrow P_6\) is assumed.
2. The finite-plus complexes \(X_n\) have fundamental group \(G_n\),
   and \(H_*(B_n;W)\cong H_*(X_n;W)\) for every right
   \(\mathbb ZG_n\)-module \(W\). This is an actual chain-splitting
   result, not a flatness assertion.
3. There are right complex representations \(V_n\), of dimensions
   \(d_5=1\) and \(d_6=2\), with the following generator matrices.
   Here \(\zeta^2+\zeta+1=0\) and \(\zeta\ne1\):
   \[
   \begin{array}{c|rrrrrr}
     &x_1&a_1&x_2&a_2&s&t\\ \hline
   V_5&-1&\zeta&\zeta^2&-1&1&\text{absent}\\
   V_6&-I&\zeta I&\zeta^2I&-I&
       S=\operatorname{diag}(\zeta,-\zeta)&
       T=\begin{pmatrix}0&1\\1&0\end{pmatrix}
   \end{array}
   \tag{5}
   \]
   They kill \(t_1,t_2\), so are representations of \(G_n\).
   The evaluated Fox maps
   \[
   D_n:V_n^{\,n-1}\longrightarrow V_n^{\,n}
   \tag{6}
   \]
   of the original relators are injective. The accepted maximal
   minors are \(-4(1-\zeta^2)\) for \(n=5\) and
   \(16(1-\zeta^2)^3\) for \(n=6\).
4. **Torsion obstruction.** If \(Y\) is a finite connected complex
   of dimension at most two and \(V\) is a finite-dimensional local
   system with \(H_2(Y;V)=0\), every finite-order element of
   \(\pi_1(Y)\) acts trivially on \(V\). This is the accepted
   finite-rank tower theorem applied to
   \(S^1\cup_{\deg m}D^2\). Its rank-one complex case is already the
   manuscript's torsion corollary.

These are previously proved inputs, with retained independent judgments;
the new verifier neither re-proves nor samples the tower theorem.
For clarity, (5)-(6) imply more than the originally needed \(H_2=0\).
The matrix \(x_1-I=-2I\) makes the first boundary onto. Since the cell
counts of \(B_n\) are \((1,n,n-1)\), (6) gives
\[
H_i(B_n;V_n)=0\quad\text{for all }i,\qquad
H_i(X_n;V_n)=0\quad\text{for all }i.
\tag{7}
\]
In \(G_n\), \(x_1^2=1\) and \(\rho_n(x_1)=-I\ne I\), so \(x_1\)
has order **exactly** two.

## 3. The normal-closure equalities and exact word witnesses

**Lemma 3.1.** In each \(P_n\), \([w,a_2]=t_1\), and both
normal-closure equalities in (2) hold.

**Proof.** In the quotient of \(P_n\) by \(w=1\),
\[
t_2=t_1^{-1}=a_2^{-26}.
\]
Thus \(t_2\) commutes with \(a_2\) **in this quotient**, and (4)
gives \(t_1=[t_2,a_2]=1\), then \(t_2=1\).
Conversely, killing \(t_1,t_2\) kills \(w\). This proves the
first equality; taking preimages in \(F_n\) proves the second.
No distinct conjugation actions have been assumed to commute.

There is a stronger identity before taking the quotient. Since
\([t_1,a_2]=1\) follows from \(t_1=a_2^{26}\), (4) gives
\[
[t_1t_2,a_2]
 =t_1[t_2,a_2]t_1^{-1}[t_1,a_2]
 =t_1.
\tag{8}
\]
Consequently \(t_1=[w,a_2]\) and
\(t_2=[w,a_2]^{-1}w\). These identities already exhibit their
membership in the normal closure of \(w\). \(\square\)

Here are witnesses in the **free group**, rather than just a calculation
in a quotient. Write \(a=a_2\), \(q=a^{26}\), and
\[
A=t_1q^{-1},\qquad B=[t_2,a]q^{-1},\qquad
E=[w,a]t_1^{-1}.
\]
For conjugation write \({}^{h}v=hvh^{-1}\). The following equality
is a literal free-group identity:
\[
E={}^{t_1}B\;{}^{t_1a}(A^{-1}).
\tag{9}
\]
Indeed, substitution leaves
\(t_1[t_2,a]q^{-1}a q t_1^{-1}a^{-1}t_1^{-1}\);
only powers of \(a\) are commuted, and this reduces to
\([t_1t_2,a]t_1^{-1}\).

There are two \(r_3\)-conjugates in \(A\):
\[
A=({}^{x_1}r_3)r_3.
\tag{10}
\]
For \(r=r_2=x_2a x_2^{-1}a^{-3}\), define
\[
B_1=r,\qquad
B_m={}^{x_2}B_{m-1}
       \prod_{j=0}^{3^{m-1}-1}{}^{a^{3j}}r\quad(m=2,3).
\tag{11}
\]
The product has increasing \(j\). Induction gives
\(B_m=x_2^m a x_2^{-m}a^{-3^m}\), and \(B=B_3\).
Thus (9) is a product of fifteen conjugates of \(r_2^{\pm1}\)
and \(r_3^{\pm1}\), with fully specified order and conjugators.

Finally the free-group equalities
\[
\begin{aligned}
t_1&=E^{-1}\,w\,({}^{a}w^{-1}),\\
t_2&=({}^{a}w)\,w^{-1}\,E\,w,\\
w&=t_1t_2
\end{aligned}
\tag{12}
\]
give respectively seventeen, eighteen, and two relator-conjugate
factors. The last line witnesses the reverse normal inclusion.
All witnesses use only the first five free generators, so apply
unchanged when \(r_5\) and \(t\) are present. The certificate checks
both source presentations separately, including the orientation of
the fifth relator; it does not infer a group isomorphism from a
numerical matrix representation.

## 4. Low-degree local homology and every presentation

**Lemma 4.1 (standard low-degree invariance, with proof).** Suppose
\(Z,Z'\) are connected CW complexes with their fundamental groups
identified with the same group \(G\). For any right
\(\mathbb ZG\)-module \(V\),
\[
H_i(Z;V)\cong H_i(Z';V)\qquad(i=0,1).
\tag{13}
\]
There is no corresponding assertion for \(i=2\).

**Proof.** Their augmented universal-cover cellular chains are free
left \(\mathbb ZG\)-modules, and are exact at degrees zero and one:
the universal covers are connected and simply connected. Thus each is
a partial free resolution
\[
C_2\longrightarrow C_1\longrightarrow C_0
 \longrightarrow\mathbb Z\longrightarrow0.
\]
Exactness at \(C_2\) is not asserted or needed.

For completeness, freeness lets us lift the identity of \(\mathbb Z\)
successively to maps \(f_i:C_i\to C'_i\), \(0\le i\le2\),
commuting with the boundaries; lift backwards to \(g_i\) as well.
The map \(g_0f_0-1\) lands in \(\ker\epsilon=\operatorname{im}\partial_1\),
so it lifts to \(h_0:C_0\to C_1\).
Then \(g_1f_1-1-h_0\partial_1\) lands in
\(\ker\partial_1=\operatorname{im}\partial_2\), so it lifts to
\(h_1:C_1\to C_2\). Hence
\[
g_1f_1-1=\partial_2h_1+h_0\partial_1,
\]
and the same construction applies to \(fg-1\). Tensoring with \(V\)
preserves these displayed chain-map and chain-homotopy identities,
whether or not \(V\) is flat. The induced maps on \(H_0,H_1\)
are inverse. \(\square\)

This is the usual identification with group homology in degrees
zero and one, proved here to specify the exact hypotheses.
Applying it to \(X_n\) and an **arbitrary** presentation complex
\(Y\) of \(G_n\), (7) gives
\[
H_0(Y;V_n)=H_1(Y;V_n)=0.
\tag{14}
\]
In particular, no homotopy equivalence \(Y\simeq X_n\) has been
assumed. This strengthens the campaign's earlier conclusion about
the particular \(X_n\), but is not a new general method: [BBMN,
Corollary B] uses the same transfer, as detailed in Section 6.

**Proposition 4.2.** Every finite presentation of either \(G_n\)
has nonpositive deficiency, and \(\operatorname{Def}(G_n)=0\).

**Proof.** Let the presentation have \(p\) generators and \(q\)
relators. Its finite connected two-complex \(Y\) has one vertex
and \(\chi(Y)=1-p+q\). Over \(\mathbb C\), all the cellular chain
groups and homology groups in question are finite-dimensional.
By (14) and the absence of higher cells,
\[
d_n(1-p+q)=\dim_{\mathbb C}H_2(Y;V_n)\ge0.
\tag{15}
\]
Consequently \(p-q\le1\). If \(p-q=1\), equation (15) forces
\(H_2(Y;V_n)=0\), but the element corresponding to \(x_1\) has
order two and acts by \(-I\). This contradicts the accepted torsion
obstruction. Since \(p-q\) is an integer, \(p-q\le0\).
The balanced presentations (3) attain zero. \(\square\)

The extension does **not** require an obstruction stronger than
the scalar method with finite covers. To see the same last
contradiction using only rank one, take the \(t\)-parity subgroup
\(\Gamma\le G_6\). The accepted double-cover identification
[A, Proposition 3.2] gives
\(V_6\cong\operatorname{Ind}_{\Gamma}^{G_6}\mathbb C_\lambda\),
with \(\lambda(x_1)=-1\).
It is a cellular chain identity for **any** \(G_6\)-complex, so
if the hypothetical \(Y\) had \(H_2(Y;V_6)=0\), its finite
double cover would have zero \(H_2\) with \(\lambda\).
The manuscript's scalar torsion obstruction applies there.
For \(G_5\), it applies directly on \(Y\).

Now \(R_n\) has \(n\) normal generators by (3). Any set of \(m\)
normal generators of \(R_n\) would give a presentation of \(G_n\)
with the **same \(n\) generators** and \(m\) relators.
Proposition 4.2 implies \(n-m\le0\), so \(m\ge n\).
This proves \(d_{F_n}(R_n)=n\) without any restriction on the
competing normal generating set.

## 5. Exactly \(n-1\) relation-module generators

Let \(M_n=R_n/[R_n,R_n]\), with the left \(G_n\)-action induced
by \(F_n\)-conjugation.

**Upper bound.** The quotient \(R_n/N_n=K_n\) is perfect.
Since the commutator subgroup of \(R_n/N_n\) is
\([R_n,R_n]N_n/N_n\), it follows that
\[
R_n=N_n[R_n,R_n].
\tag{16}
\]
The classes of \(r_1,\ldots,r_{n-1}\) therefore generate \(M_n\)
as a left \(\mathbb ZG_n\)-module. In detail, \(N_n\) consists of
products of \(F_n\)-conjugates of these words and their inverses;
these become sums of \(G_n\)-translates in the abelianization.
Conjugation by \(R_n\) itself is trivial on \(M_n\).
Thus \(d_{\mathbb ZG_n}(M_n)\le n-1\).

**Lower bound without tensoring an injection.** There is a left
\(\mathbb ZG_n\)-linear map
\[
\alpha:M_n\longrightarrow(\mathbb ZG_n)^n,\qquad
[r]\longmapsto
\left(\overline{\frac{\partial r}{\partial x_1}},
       \overline{\frac{\partial r}{\partial a_1}},\ldots\right).
\tag{17}
\]
Bars mean projection from \(\mathbb ZF_n\) to \(\mathbb ZG_n\).
Indeed, the Fox product rule is additive on \(R_n\), since its
elements project to \(1\), and therefore kills \([R_n,R_n]\).
The inverse/product rules give
\(\alpha([frf^{-1}])=\bar f\,\alpha([r])\).
These facts prove directly that (17) is well-defined and linear.
It is the usual relation map into Cayley-graph edges, but we need
not invoke even its untensored injectivity.

If \(M_n\) has \(k\) module generators, right exactness of tensor
product gives a surjection
\[
V_n^{\,k}\longrightarrow
 V_n\otimes_{\mathbb ZG_n}M_n.
\tag{18}
\]
In particular the middle space has complex dimension at most \(d_n k\).
The image of
\[
1\otimes\alpha:
V_n\otimes_{\mathbb ZG_n}M_n\longrightarrow V_n^{\,n}
\tag{19}
\]
contains the image of the accepted map \(D_n\): its block for
\(r_i\) is the map \(v\mapsto v\otimes[r_i]\), followed by (19).
The dimension of that image is \(d_n(n-1)\), by (6). Hence
\[
d_n(n-1)\le
\dim_{\mathbb C}\operatorname{im}(1\otimes\alpha)
\le \dim_{\mathbb C}(V_n\otimes_{\mathbb ZG_n}M_n)
\le d_n k.
\tag{20}
\]
As \(d_n>0\), \(k\ge n-1\).
This proves the module equality in (2) and completes the theorem.
No step claims that tensoring preserves an inclusion, and no
group-ring freeness or invariant-basis argument is being substituted
for minimal module-generator number.

## 6. Contribution and strongest predecessors

### 6.1 BBMN: an independent gap theorem and a conditional deficiency corollary

The strongest inspected predecessor is Bartholdi-Bridson-Mikhailov-
Nicholson [BBMN], **arXiv:2610.23637v1**, not only the older
conditional candidates. Its Theorem A proves that, for coprime
integers \(p,q\geq2\), the two-generator presentation
\[
H_{p,q}=\langle x,t\mid x^{pq},[x^p,tx^qt^{-1}]\rangle
\]
has
\[
d_{F_2}(R)=2,\qquad
d_{\mathbb ZH_{p,q}}(R/[R,R])=1,
\]
where \(R\) is its relator kernel. Thus **exact finite relation
gaps already exist by Theorem A, independently of the OpenAI
torsion obstruction**. The source's exclusion of a one-relator
presentation uses a nonabelian centralizer of a nonidentity
torsion element and Newman's centralizer theorem; its module
calculation also does not use the OpenAI obstruction.

Corollary B has a different dependency. The source explicitly
says that it relies on [Ope26, Corollary 2.3] and may be regarded
as conditional on that statement. It constructs a finite \(D(2)\)
complex of Euler characteristic zero for \(H_{p,q}\), by attaching
one three-cell to the displayed presentation complex, while every
finite connected two-complex with that fundamental group has
Euler characteristic at least one. With convention (1), this gives
\(\operatorname{Def}(H_{p,q})=0\).

The deficiency mechanism is the same as Section 4, not merely
analogous. BBMN uses the scalar character \(x\mapsto\zeta\),
\(t\mapsto1\), where \(\zeta\) is a primitive \(pq\)-th root.
Its evaluated boundaries give \(H_0=H_1=0\); low-degree local
homology transfers this vanishing to an arbitrary finite
two-complex \(Z\) with the same fundamental group. The OpenAI
torsion obstruction forces \(H_2(Z;\mathbb C_\rho)\ne0\), since
the finite-order element \(x\) is detected. Twisted Euler
characteristic then gives
\(\chi(Z)=\dim_{\mathbb C}H_2(Z;\mathbb C_\rho)\geq1\).
Equations (14)-(15) use precisely this transfer, Euler calculation,
and detected-torsion argument, with the coefficient dimension
\(d_n\) included.

Accordingly, **general finite-gap existence and a new universal-
deficiency method are withdrawn as originality claims**. Nor is
Corollary B an unconditional independent proof of the OpenAI
obstruction on which it relies. The accepted proof of that input
in this campaign remains [V], not BBMN. The retained independent
Reviewer excerpt records the statements, their dependency
distinction, and the proof mechanism. Reading those passages
establishes this comparison; it does not independently certify
every argument of BBMN or reprove Newman's theorem. BBMN is a
comparison source, not a new premise of the proof of (2).

### 6.2 Earlier bridges and the Fox-rank limitation

The bridges are prior work. Mannan [Ma09, Definition 4.3] calls
\(F/N\to F/R\) a partial presentation when \(R=N[R,R]\);
its kernel \(R/N\) is perfect. His Section 4, including Lemma 4.4
and Theorem 4.5, connects these presentations and deficiency drops
with Euler-characteristic obstructions to \(D(2)\).
The displayed presentation of \(P_n\) has deficiency one, and here
the quotient has \(\operatorname{Def}(G_n)=0\).
Thus this example realizes that standard mechanism. The
partial-presentation bridge, the finite-plus construction, and
the low-degree homology argument are not new general methods.
Mannan's right conjugation-module convention converts to the left
convention here by \(g\leftrightarrow g^{-1}\), without changing
minimal generator number.

Bridson-Tweedale [BTv2, Sections 2-4] use coprime annihilators to
reduce module generator number in balanced virtually free
presentations. Proposition 3.3 gives three module generators.
Their Proposition 3.6 rules out certain triples retaining two
designated relators, but does not rule out **all** triples;
their related \(D(2)\) conclusion remains conditional on the
unresolved relation-gap/deficiency assertion.
Their group deficiency convention is the negative of (1).
Their \(\operatorname{def}(F/R)=d_F(R)-d(F)\) is a *minimum*
normal-generator convention, not the length of an arbitrary
redundant relator list. For (2), their presentation values are
\(\operatorname{def}=0\) and \(\operatorname{adef}=-1\).

There is an important prohibited shortcut. [BTv2, Proposition 5.1]
shows that a presentation satisfying **Lustig's criterion** has
no relation gap. That criterion requires a suitable unital ring
representation annihilating the coefficients of a finitely
generated intermediate module
\(\pi_2(Y)\subseteq M\subseteq C_2(\widetilde Y)\), over a nonzero
ring in which left and right inverses coincide.
We neither verify nor assume this annihilation hypothesis.
In particular, an evaluated Fox rank alone is not being used to
deduce geometric deficiency: (15) gives only \(\operatorname{Def}\le1\);
the independent torsion/tower obstruction is indispensable to
exclude the remaining value one. Fox rank is used separately in
(20), where it bounds module generators.
Proposition 5.1 does not prohibit that argument.

### 6.3 The precise residual contribution and its assessment

The remaining mathematical package is specific:
**for the two epimorphisms \(F_n\to G_n\) defined in Section 1,
the normal/module minima are \((5,4)\) and \((6,5)\), both
groups have deficiency zero, and the \(G_6\) application has a
finite \(D(2)\) complex \(X_6\) satisfying every base-space scalar
tower test over every field but failing a scalar test on its
\(t\)-parity double cover.** The rank-two detector downstairs is
the induced scalar character upstairs. The last assertions are
[A, Theorem 3.1, Proposition 3.2 and Corollary 3.3], not new
conclusions of the word verifier.

| Residual content | Evidence | Comparison with the strongest predecessor |
|---|---|---|
| Sharp counts for the specified \(F_5\to G_5\) and \(F_6\to G_6\), with explicit balanced presentations | Sections 3-5; retained `relation_gap_review` in `roles/reviewer/progress.json` | BBMN treats its two-generator family, not these specified kernels. Its Theorem A already gives gap one with counts \((2,1)\); the larger counts here are not a smaller-presentation or larger-gap improvement. No isomorphism or nonisomorphism with a BBMN group is inferred from presentation size. |
| Deficiency zero over all finite presentations of \(G_5,G_6\) | Proposition 4.2 and the retained independent review | This strengthens the campaign's earlier statement about the particular plus complexes, but applies the same mechanism as conditional Corollary B. For \(G_6\), scalar theory on the double cover already suffices. |
| Exact free-word witnesses and corruption-rejecting replay | Section 7 and the unchanged certificate | These certify the displayed identities reproducibly, not a new general gap method, a universal topological theorem, or historical novelty. |
| Universal base-space scalar blindness together with the \(G_6\) exact gap | [A, Sections 3.3-3.5] and (2) | BBMN does not assert this particular all-field scalar-blind construction. It supplies a precisely scoped limitation of base-space character screening, not any additional nonrealizability reach beyond scalar tests with finite covers. |

These are supported mathematical results. The stronger *contribution
claim* submitted to the Host is only that this joint, specific
verification and scalar-blind application has original, publication-
level value beyond BBMN and the cover-aware scalar method.
**The present evidence does not establish that stronger claim.**
The absence of the particular \(G_5/G_6\) formulas from BBMN,
different presentations, and exact replay are not evidence of
field-level significance. Combining the already accepted
base-space separation with another application of the same
deficiency mechanism does not by itself supply a new general
construction, classification result, or stronger obstruction.

The Engineer therefore retires `R-RG-PUBLISHABLE`, whose
justification omitted BBMN, without retracting (2), the
all-field scalar-blindness theorem, or their accepted certificates
and judgments. The residual originality/significance assertion
remains **unestablished, not disproved**; it is submitted for a
Host-invoked independent decision, not treated as an achieved
publishable result. No replacement wording-only route is opened.
The campaign is not complete. A positive verdict must identify
substantive mathematical added value in this precise package and
explicitly support both originality and field-level significance.

## 7. Exact replay and its boundary

From the campaign root:

```bash
python3 research/relation_gap/verify.py --self-test
```

The script uses only the Python standard library. It reconstructs
(10)-(12), expands every relator-conjugate product and freely
reduces it, checks the fixed target words in both presentations,
and rejects corrupted sources, factors, signs, conjugators, and targets.
The old full verification suites are not rerun or imported.

For the newly added relator, it also computes the exact Fox derivative
over \(\mathbb Q[\zeta]/(\zeta^2+\zeta+1)\), using only the two
generator values that occur in \(w\). Its \(x_1\)-coefficient is
\(1+(-1)=0\), and its \(x_2\)-coefficient is
\[
1+\zeta^2+\zeta^4=0,\qquad
z^4+z^2+1=(z^2+z+1)(z^2-z+1).
\tag{21}
\]
All other coefficients are zero. For \(V_6\) these coefficients
multiply the identity matrix; no scalar value for \(s\) or \(t\)
is presumed. Together with the accepted ranks, this implies that
the balanced presentation complexes have twisted \(H_2\) of
dimensions one and two, respectively, in agreement with (15).
This last inference uses the accepted ranks; the new verifier
does not silently repeat their old certification.

Before writing the custom certificate code, the installed Jacobian
edge-path word contract was inspected. It is a bounded graph-path
operation, not a certificate verifier for identities modulo relators,
and was not substituted for that task. An inspected multivariate
division request for (21) was rejected with
`INVALID_REQUEST`: the implementation requires at least two
variables, although its displayed schema allowed one.
`jacobian_payload.json`, `jacobian_result.json`, and
`jacobian_status.json` retain that failed request and structured
error. It has no mathematical conclusion.

The subsequently inspected, genuinely univariate operation
`polynomial.factor.compute` returned the two factors in (21),
each with multiplicity one, content one, and exact product
reconstruction. Its payload, typed output, and successful adapter
status are retained in `jacobian_factor_payload.json`,
`jacobian_factor_result.json`, and `jacobian_factor_status.json`.
The observed server version was 0.14.0, protocol 2025-11-25;
the adapter exited zero without a timeout. Only the displayed
product identity is used, not a claim about certified irreducibility.

Neither the Python certificate nor the Jacobian operation proves
low-degree homology invariance, the tower theorem, universal
deficiency, minimal module generation, or novelty. Those conclusions
are distinguished in the ledger and require the mathematical proof
and independent review.

## References

- **[V]** Accepted verification of the staged OpenAI manuscript,
  `research/wall_d2_audit/report.md`, Sections 3-6, with its unchanged
  `verify.py` and `exact_certificate.json`.
- **[A]** Accepted finite-rank extension,
  `research/finite_rank_obstruction/addendum.md`, Sections 2-3.
  The all-field scalar-blindness theorem and double-cover reduction
  remain unchanged.
- **[Ma09]** W. H. Mannan, *Quillen's plus construction and the D(2)
  problem*, Algebraic & Geometric Topology 9 (2009), 1399-1411.
  DOI: `10.2140/agt.2009.9.1399`. Section 4, Definition 4.3,
  Lemma 4.4 and Theorem 4.5, printed pp. 1408-1411.
  Primary PDF retained at
  `research/wall_d2_audit/literature/mannan2009.pdf`; the new
  Section 4 extraction is under `research/literature/relation-gap-predecessors/`.
- **[BTv2]** M. R. Bridson and M. Tweedale, *Deficiency and
  abelianized deficiency of some virtually free groups*,
  `arxiv:math/0607671v2`, November 2006, Sections 2-5, pp. 2-7.
  The published article is Math. Proc. Cambridge Philos. Soc.
  143 (2007), 257-264, DOI `10.1017/S030500410700045X`.
  The exact passages here are attributed to **v2**, not silently
  relabelled as checked final typesetting. Primary PDF retained at
  `research/wall_d2_audit/literature/bridson_tweedale2006v2.pdf`;
  the new extraction is under `research/literature/relation-gap-predecessors/`.
- **[BBMN]** L. Bartholdi, M. R. Bridson, R. Mikhailov, and
  J. Nicholson, *Two-generator presentations with a relation gap*,
  [arXiv:2610.23637v1](https://arxiv.org/html/2610.23637v1),
  submitted October 16, 2026. Theorem A; qualification preceding
  Corollary B; Corollary B and its proof. The independently inspected
  primary passage is retained at
  `research/literature/relation-gap-predecessors/bartholdi-bridson-mikhailov-nicholson2026-review-excerpt.txt`.
  This source attribution and comparison do not certify its whole proof.
