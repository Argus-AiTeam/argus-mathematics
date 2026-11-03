# An explicit CAT(0), free-by-cyclic group that is not RFRS

This is a reconstruction of **Wu-Ye, arXiv:2504.14192v1, Example 7.2
(p. 21)**, not a new example. The mathematical certificate consists of this
proof and the exact algebra in `certificate.py`. It is a candidate for
independent Reviewer replay, not an assertion of Reviewer acceptance.

## 1. Statement and source alignment

Let \(F=F(a,b)\), and define
\[
 \phi(a)=ab,\qquad \phi(b)=ab^2.
\]
Then \(\phi\) is an automorphism, and
\[
 G=F\rtimes_\phi\mathbb Z
  =\langle a,b,t\mid tat^{-1}=ab,\quad tbt^{-1}=ab^2\rangle
\]
admits a proper cocompact isometric action on a CAT(0) square complex
but has **no RFRS filtration**.

Here an RFRS filtration is a sequence \(G=G_0\geq G_1\geq\cdots\) of
finite-index normal subgroups of \(G\), with trivial intersection and
\[
 \ker(G_i\longrightarrow H_1(G_i;\mathbb Q))\ \leq G_{i+1}.
 \tag{1}
\]
The kernel in (1) consists of the elements having a positive power in
\([G_i,G_i]\). In fact, the argument below excludes even chains in which
normality is not required. Virtually RFRS means that **some** finite-index
subgroup has its own RFRS filtration, starting at that subgroup.

The original input is the row with ID 20001516 in
`../../inputs/POSSIBLE_COUNTEREXAMPLES_ALL.csv`; the independently reviewed
source audit is `../../audits/status/agent-priority-01.csv:10`, with these
paths interpreted from the campaign work directory. Both remain read-only.
The audit classifies the broad question as partially resolved and records
that the catalog title overstates an equivalence.

[AIM Problem 5.3](http://aimpl.org/freebycyclic/5/) asks about the relationship
between CAT(0) and RFRS for free-by-cyclic groups. It neither states a four-way
equivalence nor inserts "virtually." Wu-Ye Question 1.2 adds the parenthetical
virtual variant, and Section 7 explicitly distinguishes it from AIM's wording.
The result here negates **CAT(0) implies ordinary RFRS**, already in rank two.
It does not resolve all directions of AIM's question.

Wu-Ye explicitly describe this example as virtually RFRS. Thus this is
**not** a counterexample to a virtual-RFRS assertion. No virtual-RFRS result
is needed in our negative proof. Their Theorem 1.7 and Corollary 4.6 concern
the specified one-vertex tubular class; we do not apply them to this example.
Their remaining questions are not claimed to be resolved.

## 2. The automorphism and the free-by-cyclic structure

Define the endomorphism \(\psi:F\to F\) by
\[
 \psi(a)=ab^{-1}a,\qquad \psi(b)=a^{-1}b.
\]
Free reduction gives
\[
\begin{aligned}
 \phi(\psi(a))&=(ab)(ab^2)^{-1}(ab)=a,\\
 \phi(\psi(b))&=(ab)^{-1}(ab^2)=b,\\
 \psi(\phi(a))&=(ab^{-1}a)(a^{-1}b)=a,\\
 \psi(\phi(b))&=(ab^{-1}a)(a^{-1}b)^2=b.
\end{aligned}
\]
Maps of a free group are determined by the images of its basis, so both
compositions are the identity. This proves invertibility in the free group,
not just invertibility of an abelianization matrix.

For completeness, this also identifies the kernel of the presentation.
On \(F\times\mathbb Z\) define
\[
 (u,k)(v,l)=(u\phi^k(v),k+l).
\]
The elements \((a,0),(b,0),(1,1)\) satisfy the displayed presentation.
Conversely, in the presented group the assignment
\((u,k)\mapsto u t^k\) is a homomorphism: the defining relations imply
\(t^kvt^{-k}=\phi^k(v)\) for every integer \(k\), using \(\psi\) when
\(k<0\). The two maps are inverse on generators. Thus the presentation is
exactly the semidirect product, \(F\) embeds, and
\[
 \pi:G\longrightarrow\mathbb Z,\qquad
 \pi(a)=\pi(b)=0,\quad\pi(t)=1
\]
has kernel \(F\). In particular \(a\neq1\) in \(G\).

The replay searches all 53 reduced words of length at most three for the
preimages of \(a,b\), recovers precisely the displayed \(\psi\), and then
checks **both** compositions. The successful finite search supplies explicit
words; its search bound is not used to infer any infinite nonexistence claim.

## 3. Fully instantiated CAT(0) criterion

Use the published version of J. O. Button and R. P. Kropholler,
*Nonhyperbolic free-by-cyclic and one-relator groups*,
New York J. Math. **22** (2016), 755-774,
[Theorem 2.1, p. 758](https://nyjm.albany.edu/j/2016/22-35v.pdf):
for every automorphism \(\alpha\) of \(F_2\), the group
\(F_2\rtimes_\alpha\mathbb Z\) acts freely, cellularly, properly and
cocompactly on a CAT(0) square complex.

Every hypothesis is instantiated here:

| Theorem hypothesis or convention | This group |
| --- | --- |
| Free group of rank two | The explicitly embedded \(F(a,b)\) |
| An automorphism, not an arbitrary endomorphism | \(\phi\), with two-sided inverse \(\psi\) above |
| Mapping torus with \(txt^{-1}=\alpha(x)\) | Exactly the displayed presentation |

There is no polynomial-growth, atoroidality, finite-order, or tubular
hypothesis in this theorem. The construction in its proof is a compact
nonpositively curved square complex with this fundamental group; the group
acts on its CAT(0) universal cover by deck transformations (p. 759).
The metric is the lifted piecewise Euclidean path metric, so these deck
transformations are isometries. Properness and cocompactness are part of
the theorem, not inferred merely from having some CAT(0) action.

The relevant construction case can also be identified without guessing.
Button-Kropholler use
\[
 \lambda:a\mapsto ba,\ b\mapsto b,\qquad
 \rho:a\mapsto a,\ b\mapsto ab.
\]
Changing the stable letter to \(s=bt\) gives
\[
 sas^{-1}=ba,\qquad sbs^{-1}=bab,
\]
which is \(\lambda\circ\rho\). This is their Section 2.2.1, Case 2,
\(n=1,\epsilon=0\). The block construction, collapse, subdivision, and
link argument appear on pp. 759-764. The replay checks the stable-letter
normalization. We rely on the cited theorem for the CAT(0) construction;
the program does **not** claim to reconstruct its square complex or to
mechanically verify its link argument.

This named theorem is the only non-elementary mathematical dependency
of the certificate. It is recorded as `BK-THEOREM-2-1` in the ledger.

## 4. An exact obstruction valid for every positive power

With columns equal to the exponent sums of the images of \(a,b\),
the induced map on \(F_{\mathrm{ab}}\cong\mathbb Z^2\) is
\[
 M=\begin{pmatrix}1&1\\1&2\end{pmatrix},\qquad
 \det M=1,\quad\operatorname{tr}M=3,\quad
 M^2-3M+I=0.
\]
Consequently \(q(x)=\det(xI-M)=x^2-3x+1\).
The exact Jacobian operation and the independent replay agree on these
coefficients. That single matrix computation is **not** the universal step.

Here is an integer proof of the universal step. Put \(T_n=\operatorname{tr}(M^n)\).
Multiplying the displayed matrix identity by \(M^n\) and taking traces gives
\[
 T_0=2,\quad T_1=3,\qquad T_{n+2}=3T_{n+1}-T_n\quad(n\geq0).
 \tag{2}
\]
Write a consecutive pair as
\[
 (T_n,T_{n+1})=(2+p,\ 3+p+q),\qquad p,q\in\mathbb Z_{\geq0}.
\]
At \(n=0\), \(p=q=0\). Under (2), the next pair has parameters
\[
 p'=1+p+q,\qquad q'=3+p+2q.
 \tag{3}
\]
All coefficients in (3) are nonnegative, and \(p'\geq1\).
Induction proves \(T_n>2\) for **every** \(n\geq1\).
The replay checks the matrix identity and the affine coefficient identities
and signs in (3). Induction, not a list of tested exponents, supplies the
unbounded quantifier.

For a two-by-two matrix \(X\), direct expansion gives
\(\det(X-I)=\det X-\operatorname{tr}X+1\). Since \(\det(M^n)=1\),
\[
 \boxed{\det(M^n-I)=2-T_n<0\quad\hbox{for every }n\geq1.}
 \tag{4}
\]
Alternatively, \(q(0)=1,q(1)=-1,q(2)=-1,q(3)=1\), so its two distinct
real roots lie in \((0,1)\) and \((2,3)\). Neither has a positive power
equal to one. Diagonalizing \(M\) then gives the same nonvanishing.
The recurrence proof above avoids needing this spectral alternative.

## 5. All cyclic covers and all admissible filtrations

For \(n\geq1\), define
\[
 K_n=\pi^{-1}(n\mathbb Z)=\langle F,t^n\rangle
       =F\rtimes_{\phi^n}\mathbb Z.
\]
Its abelianization, read directly from the mapping-torus presentation, is
\[
 (K_n)_{\mathrm{ab}}
  \cong \mathbb Z\oplus
       \mathbb Z^2/(M^n-I)\mathbb Z^2.
 \tag{5}
\]
The free summand is the class of \(t^n\); the other two generators are
subject to exactly the columns of \(M^n-I\). By (4), the latter quotient
is finite. Tensoring with \(\mathbb Q\) gives
\[
 H_1(K_n;\mathbb Q)\cong\mathbb Q,\qquad
 \boxed{\ker(K_n\to H_1(K_n;\mathbb Q))=F.}
 \tag{6}
\]
For the second equality, an element has the unique form \(f(t^n)^k\);
its rational abelianization is \(k\) times the nonzero stable-letter class.
It vanishes exactly when \(k=0\).

Now let \(G=G_0\geq G_1\geq\cdots\) be **any** finite-index chain
satisfying (1). We prove \(F\leq G_i\) for every \(i\).
The base case is immediate. If \(F\leq G_i\), then the subgroup
correspondence for \(G/F\cong\mathbb Z\) gives
\[
 G_i=\pi^{-1}(n_i\mathbb Z)=K_{n_i}
\]
for some positive \(n_i\), since \(G_i\) has finite index.
Explicitly, a subgroup containing \(\ker\pi\) contains every element
with the same \(\pi\)-value as any of its elements, which proves this
equality without any normality assumption. Equation (6), followed by
(1), forces \(F\leq G_{i+1}\), completing the induction. Therefore
\[
 1\neq F\ \leq\ \bigcap_{i\geq0}G_i.
\]
This contradicts the separation axiom of an RFRS filtration.
The chain was arbitrary. We did **not** restrict attention in advance
to cyclic covers: the RFRS containment axiom forces every stage into
that form.

For comparison with Wu-Ye's source argument (Lemma 7.1 and Example 7.2,
p. 21), the same obstruction can be expressed without classifying
the entire chain. If the chain first loses \(F\) at stage \(j+1\),
some \(h\in F\) has nonzero rational abelianization in \(G_j\).
This finitely generated group then has a homomorphism to \(\mathbb Z\)
nonzero on \(h\). Finite index supplies \(t^n\in G_j\) for some \(n>0\).
Restriction to \(K_n\) contradicts (5). This first-exit argument
independently checks that the obstruction addresses arbitrary filtrations.
We have supplied the argument itself, rather than assuming Lemma 7.1.

For a finite-index subgroup not containing all of \(F\), the induction's
base case is unavailable. Thus nothing here excludes RFRS filtrations
in all finite-index subgroups. Replacing ordinary non-RFRS by
non-virtual-RFRS would change the quantifiers and invalidate the argument.

## 6. Exact replay and its limits

From the campaign work directory:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/source-negative-certificate/certificate.py
```

The script uses only the Python standard library, integer arithmetic,
exact rational arithmetic, and free reduction. It recomputes the finite
data independently of the saved Jacobian answer and compares them.
It terminates with a nonzero exit on a failed identity. Its JSON output
is a finite algebra report, not a compiler certificate of the entire proof.
No Lean source, proof-hole claim, floating-point threshold, or finite
filtration enumeration is involved.

The independently rerunnable Jacobian command is:

```bash
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian run \
  matrix.characteristic_polynomial.compute \
  --file research/source-negative-certificate/jacobian-payload.json
```

The inspected declaration, exact payload, exact typed output, narrowed
discovery, and invocation status are the `jacobian-*.json` files beside
this proof. The pinned CLI was used directly; no MCP server session or
Argus adapter was invoked. Its distribution version is 0.14.0; no
negotiated server/protocol version is claimed.

The independent Reviewer must read the universal argument and the
instantiated CAT(0) theorem, not merely approve a successful Python exit.
Source PDFs/text and the AIM page are retained in `sources/`; the canonical
external sources and locators are also recorded in `research/MATH_STATE.json`.
The original input and reviewed audit are referenced in place, not copied.
Independent citation attribution and the scientific verdict remain with
the normal Reviewer path.

Compared with the prior accepted result, which repaired only the proof
graph, this candidate supplies the actual group, the inverse automorphism,
the CAT(0) criterion with every hypothesis instantiated, and the universal
filtration obstruction. It is a reproducibility/source-correction result,
not a new counterexample or a resolution of the virtual relationship.
