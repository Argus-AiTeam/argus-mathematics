# Universal verification of the finite site-pressure mechanism

## Result and certification boundary

The positive-site-pressure theorem and its incident-edge Rayleigh deduction
in the staged below-one manuscript admit a universal proof with their stated
finite hypotheses unchanged. There is no counterexample in this report.
In particular, repeated site labels are not discarded or restricted to
bounded multiplicity.

The independent formal deliverable is the universal hard-core coefficient
theorem in `Main.lean`. It proves positivity of the **actual formal
negative logarithm** of an explicitly defined finite polymer partition
function, including arbitrary repeated site multiindices. It does not merely
formalize the already cited negative-parameter Tutte sign lemma. Below is a
complete mathematical reduction of the manuscript's site polynomial to this
formal theorem, followed by proofs of connected support, convergence, and
Rayleigh. Those graph and analytic reductions are prose proofs requiring
independent review, not Lean graph/analysis theorems.

`statement_fidelity.md` gives the precise kernel boundary. The exact
computations in `verify.py` are diagnostics and independently check the
finite identities at their stated inputs; they do not prove universal
quantifiers. An Engineer opinion, a successful compiler run, and independent
Reviewer acceptance are distinct. No independent review is claimed here.

## Exact manuscript assertions

Source:
`research/openai_manuscript/Self-dual-random-cluster-interfaces-below-one-September-23-2026/build/sections/01-pressure.tex`.

Theorem `thm:pressure`, equation `pressure:series`, asserts

\[
 -\log F_H(x)=\sum_{m\ne0}c_m x^m,\qquad c_m\geq0,
\]

for every finite graph, finite nonnegative edge odds and \(0<q<1\), where
\[
 u=1-q,\quad
 F_H(x)=\mathbb E_0\prod_{C\in\operatorname{Comp}(V,A)}
       (1-u x_C).
\]
Components include isolated vertices. Every nonzero
\(m\in\mathbb Z_{\geq0}^{V}\) is included, not just squarefree \(m\).
The theorem also asserts connected support for positive coefficients and
absolute convergence on a polydisk containing the closed unit polydisk
in its interior.

Equation `pressure:fixed-union` is the proposed exact ordinary-edge
regrouping. Equation `pressure:negative-partition` supplies its component
sign. Lemma `lem:adjacent-rayleigh` claims nonpositive covariance for
distinct incident edges, and, in a plane graph, cofacial edges; deletion
and contraction of other edges are allowed.

These are finite prerequisites for the manuscript's later rooted coverage
and restricted connection comparisons. Verifying them does not establish
interlacing, screening, conformal invariance or interface convergence.

## 1. Squarefree coefficients from independent percolation

Remove loops and combine parallel edges into odds
\(\prod_e(1+v_e)-1\). These operations preserve the site polynomial:
loops do not affect components, and a parallel family has the same
open/closed connectivity law as the combined edge under independent
percolation. Nonnegativity and finiteness of the new odds are preserved.

For the resulting simple graph set
\[
 \gamma_i=\prod_{e\ni i}(1+v_e)^{-1}>0,\qquad y_i=\gamma_i x_i.
\]
For a selected union \(T\) of open components, all edges leaving \(T\)
must be closed. The edges internal to \(T\) contribute
\[
 [x_T]F_H=
 \frac{\sum_{A\subseteq E(H[T])}v_A(-u)^{k(T,A)}}
 {\prod_{e\in E(H[T])}(1+v_e)
  \prod_{e\in\partial T}(1+v_e)}.
\]
The complementary edges sum to one. Since
\[
 \prod_{i\in T}\gamma_i
 =\prod_{e\in E(H[T])}(1+v_e)^{-2}
  \prod_{e\in\partial T}(1+v_e)^{-1},
\]
the polynomial in \(y\) has squarefree coefficient
\[
 W(T)=
 \prod_{e\in E(H[T])}(1+v_e)
 \sum_{A\subseteq E(H[T])}v_A(-u)^{k(T,A)}.                 \tag{1}
\]
Here \(W(\varnothing)=1\). A selected component product cannot repeat a
site, so there are no other polynomial coefficients. This proves
`pressure:squarefree` directly from the definition.

## 2. Fixed ordinary union and its component sign

Expand the first product in (1) using a second edge set \(B\).
Fix \(D=A\cup B\). An edge of \(D\setminus A\) is in \(B\) and contributes
\(v_e\). An edge of \(A\) contributes \(v_e(1+v_e)\) after its two
possible \(B\)-states are summed. Therefore, exactly,
\[
 \sum_{\substack{A,B\\A\cup B=D}}
 v_Av_B(-u)^{k(T,A)}
 =v_D\sum_{A\subseteq D}(-u)^{k(T,A)}(1+v)_A
 =v_D\prod_{D_0\in\operatorname{Comp}(T,D)}
       Z(D_0;-u,1+v).                                   \tag{2}
\]
Isolated vertices occur as one-vertex components with value \(-u\).
The same calculation works on every finite labeled lift of \(T\),
including arbitrary repeated types. Every lifted ordinary edge is an
edge between two distinct labeled elements; its odds may equal those
of other lifted edges without identifying their independent choices.
Thus no missing factorial or repeated-label correction occurs in (2).

For completeness, \(Z(G;-u,w)<0\) for any nonempty connected finite
multigraph when \(0<u<1\) and \(w_e\geq1\). Induct on the number of edges.
A loop factors out \(1+w_e>0\). A bridge gives
\[
 Z(G;-u,w)=(w_e-u)Z(G/e;-u,w),
\]
where \(w_e-u>0\). For any remaining edge, deletion and contraction both
leave connected nonempty graphs; deletion-contraction is the sum of
two negative terms with positive multiplier \(w_e\). The edgeless
connected initial graph has one vertex and value \(-u\).
This proves `pressure:negative-partition` without an external assumption.

## 3. Exact hard-core polymerization

For every nonempty vertex subset \(S\), define
\[
 \lambda(S)=-
 \sum_{\substack{D\subseteq E(H[S])\\(S,D)\ {\rm connected}}}
       v_D Z((S,D);-u,1+v).                              \tag{3}
\]
By the preceding sign theorem, \(\lambda(S)\geq0\).
It is zero if \(H[S]\) is disconnected; for a singleton it is \(u\).
There are finitely many such subsets.

Use the nonempty subsets as polymers, with two distinct polymers
compatible exactly when they are disjoint. Give polymer \(S\) negative
activity \(-\lambda(S)y_S\). Its hard-core partition polynomial is
\[
 \mathcal Z(y)=
 \sum_{\mathcal I\ {\rm pairwise\ disjoint}}
       \prod_{S\in\mathcal I}[-\lambda(S)y_S].            \tag{4}
\]
Equation (4) includes the empty family with weight one. Its coefficient
at \(y_T\) is the sum over partitions of \(T\) of the product of the
block weights \(-\lambda(S)\). On expanding (3), a partition together
with a connected spanning \(D\) in each block is uniquely an ordinary
edge set \(D\subseteq E(H[T])\), decomposed into its connected components.
Equation (2) then gives
\[
 [y_T]\mathcal Z=W(T),\qquad \mathcal Z(y)=F_H(x(y)).      \tag{5}
\]
Both sides are squarefree polynomials, so this coefficient comparison
is a full identity. It is not a finite-test inference.

This is the reduction that replaces the source's labeled hard-edge
cancellation argument by an explicit hard-core system. It also makes
clear why taking a logarithm must allow repeated site labels even
though (4) itself is squarefree.

## 4. Universal coefficient theorem, including all repetitions

Here is the precise algebraic theorem proved in Lean.

**Theorem.** Let \(P\) be any polymer type, \(\mathcal S\subset P\)
finite, and compatibility any symmetric relation. Let
\(a_p(t,x)\in\mathbb R[x][[t]]\) have zero constant coefficient in \(t\)
and nonnegative coefficients at every \(t^n x^m\).
Define
\[
 Z_\mathcal S=
   \sum_{\substack{I\subseteq\mathcal S\\I\ {\rm compatible}}}
        \prod_{p\in I}(-a_p).
\]
Then every coefficient of \(-\log Z_\mathcal S\) is nonnegative.
There is no bound on \(n\), on \(|\mathcal S|\), on the site set, or
on the multiplicities in \(m\).

For clarity, the following is also a complete proof. For
\(\mathcal T\subseteq\mathcal S\), simultaneously prove that
\(Z_\mathcal T/Z_\mathcal S\) is coefficientwise nonnegative.
If the sets are equal the ratio is one. Otherwise choose
\(p\in\mathcal S\setminus\mathcal T\), set
\(B=\mathcal S\setminus\{p\}\), and let \(C\subseteq B\) consist of
polymers compatible with \(p\). Splitting compatible families according
to whether they contain \(p\) gives the exact deletion identity
\[
 Z_\mathcal S=Z_B-a_pZ_C=Z_B(1-A),
 \qquad A=a_p\,Z_C/Z_B.                                 \tag{6}
\]
Induction makes both \(Z_C/Z_B\) and \(Z_\mathcal T/Z_B\)
coefficientwise nonnegative. Also \(A(0)=0\), so
\[
 \frac{Z_\mathcal T}{Z_\mathcal S}
   =\frac{Z_\mathcal T}{Z_B}\sum_{k\geq0}A^k
\]
is coefficientwise nonnegative. All inverses exist because every
partition series has constant coefficient one.

For the logarithmic derivative, (6) gives
\[
 -\frac{Z'_\mathcal S}{Z_\mathcal S}
    =-\frac{Z'_B}{Z_B}+\frac{A'}{1-A}.                   \tag{7}
\]
The derivative here is in the additional grading variable \(t\).
Differentiation preserves coefficient nonnegativity in this ring.
Induction, the ratio result, and the geometric-series result make
both terms on the right of (7) nonnegative. Mathlib's actual formal
logarithm satisfies \((\log Z)'=Z'/Z\); the Lean proof establishes
this identity as well. The constant logarithmic coefficient is zero,
and division of its \(t^n\) derivative coefficient by the positive
integer \(n\) proves the theorem.

This proof does not declare the desired coefficients positive by
definition, assume a connected-expansion identity, or replace general
multiindices by squarefree ones. `Main.lean` proves the deletion
identity from the finite compatible-family sum, as well as (6), the
ratio induction, (7), the formal-logarithm identity and coefficient
positivity.

Apply the theorem to (4) with
\[
 a_S(t,y)=\lambda(S)t^{|S|}y_S .
\]
Equation (5) becomes \(Z_\mathcal S(t,y)=F_H(x(ty))\).
By formal substitution, the coefficient of \(t^{|m|}y^m\) in its
negative logarithm is exactly \([y^m](-\log F_H(x(y)))\).
The universal theorem proves this number nonnegative for **every**
nonzero \(m\), including arbitrary repetitions. Finally
\[
 c_m=\Bigl(\prod_i\gamma_i^{m_i}\Bigr)
       [y^m](-\log F_H(x(y)))\geq0.                     \tag{8}
\]
All \(\gamma_i\) are strictly positive. The zero-vertex graph has
polynomial one and no nonzero multiindices, and is covered separately.

## 5. Source hard-edge argument and connected support

The source's alternative labeled proof is consistent with (5).
For a finite set \(U\) of labeled slots, its structure weight
\(v_Av_B(-u)^{k(U,A)}(-1)^{|L|}\) factors over the components of
\(A\cup B\cup L\). Summing unrestricted structures gives the
squarefree moment when all types differ, and zero otherwise:
any repeated type supplies a hard edge whose two choices cancel.
Every structure has a unique decomposition into its connected
components. Expanding this identity over partitions of \(U\) and
applying the moment-cumulant inversion gives the connected-structure
sum as the mixed logarithmic derivative. Repeated slots are
distinguishable throughout; the coefficient is that derivative
divided by \(\prod_i m_i!\), not by \(|m|!\).

For fixed ordinary union \(D\) with \(b\) components, (2) has sign
\((-1)^b\), or is zero because \(v_D=0\). If a possible hard edge lies
inside a \(D\)-component, its two choices cancel even after imposing
connectivity. Otherwise contract the \(D\)-components. On the resulting
hard multigraph \(K\), the connected alternating sum
\(\sum_{L\text{ spanning connected}}(-1)^{|L|}\) has sign
\((-1)^{b-1}\), or is zero. Indeed loops cancel, disconnected graphs
have no connected spanning set, and for a nonloop edge
\(C(K)=C(K\setminus e)-C(K/e)\). With the inductive signs at \(b\)
and \(b-1\) vertices, both terms have the asserted final sign.
A single vertex without loops has value one. Their product is
nonpositive, exactly as required for \(\log F_H\).

There is also a short support proof that needs no labeled machinery.
Restrict all variables outside \(S=\operatorname{supp}(m)\) to zero.
By (1), the polynomial in the remaining \(y\)-variables factors over
the components of \(H[S]\): the internal partition sum and the extra
internal-edge product both factor. Consequently its formal logarithm
is a sum of functions on those separate components. If \(H[S]\) is
disconnected, the coefficient involving every site of \(S\) is zero.
The positive rescaling (8) preserves this conclusion.

## 6. Absolute convergence past the unit polydisk

For \(x\in[0,1]^V\), each factor \(1-u x_C\) is at least \(q>0\);
thus \(F_H(x)>0\). The formal diagonal series
\[
 G(z)=\sum_{m\ne0}c_m z^{|m|}
\]
has nonnegative coefficients and positive convergence radius \(R\),
since it is \(-\log F_H(z,\ldots,z)\) near zero.
If \(0<R\leq1\), positivity at the real point \(R\) gives a zero-free
complex neighborhood and an analytic continuation of this logarithmic
germ through \(R\). For every derivative order \(j\), monotone
convergence from \(z<R\), together with continuity of that analytic
derivative, gives the finite nonnegative coefficient sum \(G^{(j)}(R)\).
For a sufficiently small \(h>0\), Taylor expansion at \(R\) and
rearrangement of nonnegative terms give
\[
 \sum_{m\ne0}c_m(R+h)^{|m|}
 =\sum_{j\geq0}\frac{G^{(j)}(R)}{j!}h^j<\infty,
\]
contradicting the radius. Therefore \(R>1\), or \(R=\infty\).
For \(1<r<R\), the diagonal sum at \(r\) bounds the absolute
multivariate sum on \(|x_i|\leq r\). Exponentiation agrees with
the polynomial near zero and hence on the polydisk, so the resulting
analytic function is the desired logarithm there.

## 7. Hub identity and incident/cofacial Rayleigh

Adjoin a hub \(o\), with any finite collection of links at each site.
Put \(s_i=\prod_{h:i-o}(1+v_h)\) and \(x_i=s_i^{-1}\).
For each fixed original open component \(C\), summing hub links gives
\(q+(s_C-1)=s_C-u\), and the hub component supplies one extra
factor \(q\). Summing original edges proves
\[
 Z_{H+o}=q\prod_{e\in E(H)}(1+v_e)\prod_i s_i F_H(1/s).
                                                               \tag{9}
\]
This is `pressure:hub-partition`, including several links at one site.

The link-dependent part of its logarithm is
\[
 \sum_h\log(1+v_h)
 -\sum_{m\ne0}c_m\prod_h(1+v_h)^{-m_{i(h)}}.             \tag{10}
\]
For distinct links \(e,f\), the mixed derivative of a monomial in
the second sum before its minus sign is
\[
 \frac{m_{i(e)}m_{i(f)}}{(1+v_e)(1+v_f)}
       \prod_h(1+v_h)^{-m_{i(h)}}\geq0.
\]
This formula also covers \(i(e)=i(f)\): the links are distinct
odds coordinates even at equal sites or equal numerical odds.
The first sum in (10) has zero mixed derivative. The larger
polydisk established above justifies termwise differentiation,
including by continuity at zero odds. Consequently
\(\partial_{v_e}\partial_{v_f}\log Z\leq0\).
For positive odds,
\[
 \operatorname{Cov}(\mathbf1_e,\mathbf1_f)
   =v_ev_f\,\partial_{v_e}\partial_{v_f}\log Z\leq0.
\]
The zero-odds statement follows by continuity, or because such an
edge is constantly closed. Loops are independent and have zero
covariance with other edges. Removing the common vertex represents
every pair of distinct incident nonloop edges as the two links
just considered, without restricting the rest of the finite graph.

For a plane graph with strictly positive odds, the complementary
dual law has odds \(q/v_e\). Cofacial primal edges are incident
dual edges, and complementing both indicators preserves covariance.
Zero odds follow by finite-law continuity; infinite odds used for
contraction have the usual finite partition ratios after cancellation
of their common leading factors. Alternatively, every deletion or
contraction minor is itself a finite graph of the allowed kind, so
the incident assertion applies afresh; plane minors give the
cofacial assertion. No FKG inequality is used.

## Exact evidence and prior knowledge

The official `lean_evidence verify --claim PC_POLYMER` run compiled the
unchanged formal source with Lean 4.31.0, exit code zero, no proof holes
and axiom-audit exit code zero. Its archived claim-bound certificate is
`certificates/PC_POLYMER-a4583f8f28fb87e7.json`. The ledger derives
`closed_kernel` for **PC_POLYMER only**; this does not promote the
FK reduction or the analytic/covariance statements to kernel proofs.

`verify.py` independently constructs \(F_H\) by enumerating independent
percolation states, constructs logarithmic coefficients by truncated
formal multiplication, and compares them with labeled cumulants and
connected triple-structure regrouping. It also computes augmented FK
partition sums and incident covariances directly from their definitions.
Inputs include nonuniform rational odds, zero odds, loops, parallel
edges, disconnected graphs, triangles and \(K_4\). The first diagnostic
run passed 80 graph/parameter cases, 2,700 coefficients through total
degree four (2,132 with repetitions), 11,612 ordinary-union groups and
920 incident covariances. The completed verifier additionally compares
648 squarefree moments with the exact polymer assembly (3)--(5),
independently reconstructs the typed Jacobian factorization from FK
definitions, and checks that the real compiler certificate still
matches both the current Lean source and the statement-fidelity note.
The finite degree bound is explicit and is not used as a proof of (8).

Replay the exact computations with

```sh
python3 research/pressure-core/verify.py
```

For a fresh real formal replay, from the campaign root use

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/pressure-core/Main.lean --statement-fidelity research/pressure-core/statement_fidelity.md --claim PC_POLYMER --project-root .
```

The Python verifier checks the existing compiler certificate's freshness;
it does not itself claim to run a compiler. The second command is the
separate genuine compiler replay. Neither the Lean source nor its
statement-fidelity note should be edited during that command.

The Jacobian adapter's bounded
`polynomial.multivariate.factor.compute` operation exactly factored
the triangle incident-Rayleigh numerator as
\[
 (\partial_a Z)(\partial_b Z)-Z\,\partial_a\partial_b Z
       =q^2(1-q)c(q+c).
\]
`jacobian_payload.json` and `jacobian_output.json` retain its exact
request, typed result, operation identifier, server version, protocol
and successful `FACTORIZED` status. This is one exact symbolic check,
not support for an unbounded inference.

The following primary sources were opened to delimit what is already
known, rather than to claim classical novelty:

| Source | Proposition read | Relation to this proof |
|---|---|---|
| Jackson--Sokal, arXiv:0806.3249v1, Theorem 4.4 | At negative cluster parameter \(s\), bridge odds at least \(-s\) and other odds at least \(-s/2\) give the component sign, strictly if every bridge inequality is strict. | The manuscript's \(s=-u,\ w\geq1\) satisfies these hypotheses. Section 2 above supplies its own elementary proof. |
| Scott--Sokal, arXiv:cond-mat/0309352v2, Proposition 2.8 | Repulsive-gas Mayer coefficients have alternating signs for all multiindices. | The generic hard-core sign principle is known. The Lean proof derives it for the present formal-series formulation without assuming this result. |
| Scott--Sokal, same version, Theorem 2.10 | Positivity along a connected negative-activity region is equivalent to zero-freeness and absolute logarithmic convergence on its polydisk. | The source's convergence reasoning is consistent with it; Section 6 proves the needed diagonal argument directly. |

Primary URLs: <https://arxiv.org/html/0806.3249v1> and
<https://arxiv.org/html/cond-mat/0309352v2>.
No proposition from those papers is an undischarged assumption of
the proof above or of the Lean theorem. The classical hard-core
sign principle and its closure under positive monomial substitutions
are not claimed as new mathematics. The contribution submitted for
review is an independent universal formal certification of the
load-bearing coefficient mechanism and the exact finite FK reduction,
not a claim that a bounded search or a known sign lemma is a new
publishable theorem. Scholarly novelty, publishable significance,
statement fidelity and the prose reduction still require the
Host-invoked independent Reviewer; the campaign is not declared complete.
