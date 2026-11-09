# A universal certificate for the uniform perturbation mechanism

## Result and scope

The free-group core of Proposition `prop:perturbation` is correct.
`Main.lean` proves its prefix orientation, exact collision classification,
collision energy, and coefficient domination for **every** word length
and original degree. The coefficient theorem uses actual noncommutative
group-algebra multiplication, including collection after cancellation.
Below is a rigorous analytic derivation of the proposition from that
core and Popa's independence theorem.

This is an independent verification theorem and a collision-controlled
generalization of the estimate, not a counterexample, a finite-search
conclusion, or a full Lean proof of the proposition. No false literal
manuscript assertion was identified in this mission. In particular,
negative controls for reversed conjugation are not manuscript
counterexamples: the manuscript uses the correct orientation.
Independent Reviewer acceptance and the proposition-level citation
attribution are still required.

All source references below refer to
`research/openai_manuscript/Relative-generation-and-the-generator-problem-for-finite-factors-September-23-2026/build/sections/`.
The principal source is `perturbation.tex`, from `prop:perturbation`
through its proof; the independence input is in `independence.tex`.
The downstream application is the proof of `thm:relative-generation`
in `generation.tex`. Other consequences are not certified here.

## 1. An independent collision proof

Work in the free group on \(s_1,s_2,\ldots\), put
\(g_k=s_1\cdots s_k\), and set \(p_{kj}=g_kg_j^{-1}\).
Consider the genuine homomorphism to the additive group \(\mathbb Z^2\)
given by
\[
 s_i\longmapsto(1,2i-1).
\]
Then \(g_k\mapsto(k,k^2)\), so
\[
 p_{kj}\longmapsto(k-j,k^2-j^2).
\]
If \(k\ne j\), these two coordinates determine both \(k-j\) and
\(k+j=(k^2-j^2)/(k-j)\), hence determine \(k,j\).
If \(p_{kj}=p_{ab}\), either both pairs are diagonal, or
\((k,j)=(a,b)\). Conversely those alternatives plainly imply equality.
In particular \(p_{kj}=e\) exactly when \(k=j\).

Thus, for \(1\le k,j\le\ell\), identity has multiplicity \(\ell\)
and each of the \(\ell(\ell-1)\) off-diagonal labels has multiplicity
one:
\[
 E_\ell:=\sum_p n_p^2=2\ell^2-\ell.                 \tag{1}
\]
Equivalently \(E_\ell\) counts quadruples \((k,j,a,b)\) with
\(p_{kj}=p_{ab}\); this is the formal definition `collisionEnergy`.
The equivalence is a double count: each fiber of size \(n_p\)
contributes its Cartesian square, of size \(n_p^2\).

The Lean declarations `prefix_moments`, `label_eq_iff`,
`label_eq_one_iff`, and `collision_energy` prove these statements
universally. This avoids assuming the manuscript's reduced-word
argument or its collision count.

## 2. Prefix orientation without commutation

For any group, any \(a,q\), and any list \(x_1,\ldots,x_\ell\),
let \(g_k=ax_1\cdots x_{k-1}\). Direct cancellation gives
\[
 a(qx_1)\cdots(qx_\ell)
   =\left(\prod_{k=1}^{\ell}g_kqg_k^{-1}\right)
      ax_1\cdots x_\ell.                            \tag{2}
\]
The products retain their original order. This identity is
`prefix_factorization`, proved for arbitrary lists and groups.
Substituting \(a=t_0,\ x_k=ut_k,\ q=e^{ih}\) yields exactly
`eq:perturbation-prefix`. The direction is \(g_khg_k^{-1}\),
not \(g_k^{-1}hg_k\); no commuting-prefix shortcut is involved.

## 3. A general coefficient theorem and its exact specialization

Let \(I\) be any finite token set, \(v:I\to H\) a map into
**any** group, \(b_i\) real signed weights, and \(a_i\ge|b_i|\)
nonnegative weights. Put \(A=\sum_i a_i[v_i]\) in
\(\mathbb R[H]\). For every degree \(d\), sequence predicate \(P\),
and positive integer sequence denominators \(D(q)\), one has,
at every \(w\in H\),
\[
 \left|\sum_{\substack{q:\{1,\ldots,d\}\to I\\
                  P(q),\ v_{q_1}\cdots v_{q_d}=w}}
       \frac{\prod_{r=1}^d b_{q_r}}{D(q)}\right|
 \le A^d(w).                                       \tag{3}
\]
Proof: expand \(A^d\) distributively, without permuting factors.
Apply the triangle inequality at a fixed resulting group element,
replace each \(|b_i|\) by \(a_i\), and use \(D(q)\ge1\).
Every dropped summand on the positive side is nonnegative.
Coincident products are collected on **both** sides. In particular,
products reducing to identity are retained.

`group_ring_expansion` proves the noncommutative expansion by induction
on \(d\), and `coefficient_majorization` proves (3). There is no
hypothesis asserting the conclusion, a convolution bound, a row
majorization, or a collision estimate.

For the manuscript use the tokens \(i=(k,j,\varepsilon)\), where
\(1\le k,j\le\ell\) and \(\varepsilon\in\{+1,-1\}\).
Let \(H\) be the free group on symbols \(T_p\), indexed by the inner
free-group elements, and set
\[
 v_i=T_{p_{kj}}^\varepsilon,\quad
 b_i=\varepsilon c,\quad a_i=c,\qquad c=\alpha/(2\ell).
\]
Only the finitely many labels in \(S\) occur, so enlarging the free
basis from \(S\) to the whole inner group introduces no relations.
The symbol \(T_e\) is a generator, not the identity; this distinction
is also proved by `identity_label_is_a_generator`.

Take \(P(q)\) to mean that the row indices are nondecreasing. If
\(m_k\) is the occurrence count of row \(k\), take
\(D(q)=\prod_k m_k!\). `rowFactorial_pos` proves \(D(q)\ge1\).
The specialization is `all_degree_majorization`:
\[
 |\operatorname{orderedCoefficient}(\ell,d,c,w)|
       \le (\operatorname{majorant}(\ell,c)^d)(w)
       \quad(\ell,d\in\mathbb N,\ c\ge0,\ w\in H).   \tag{4}
\]

Here is the precise bridge to the manuscript's \(\mathcal C_d\).
For a fixed exponent tuple \((m_1,\ldots,m_\ell)\), expand
\(B_1^{m_1}\cdots B_\ell^{m_\ell}\) into its token choices.
The resulting row sequence consists of \(m_1\) copies of row 1,
then \(m_2\) copies of row 2, and so forth. Conversely a
nondecreasing row sequence has exactly one such exponent tuple and
exactly that within-row token sequence. These assignments are
inverse, preserve the ordered group product, and preserve the
scalar weight \(1/\prod_k m_k!\). Thus the left coefficient in
(4) is exactly \(|\mathcal C_d(w)|\), and
\[
 A=\operatorname{majorant}(\ell,c)
    =c\sum_{p\in S}n_p(T_p+T_p^{-1}).
\]
This finite bijective regrouping is supplied here in prose; Lean
proves (4) for the explicit nondecreasing-token formula rather
than a theorem about analytic exponential series. It is not
replaced by numerical evidence. The exact verifier independently
compares both finite descriptions in its regression cases.

## 4. Collision-controlled exponential theorem

Let \((U_p)_{p\in S}\) be any finite free Haar family in a finite
tracial von Neumann algebra. For finitely many nonnegative real
weights \(b_{kp}\), set
\[
 B_k=\sum_p b_{kp}(U_p-U_p^*),\qquad
 v_p=\sum_k b_{kp},\qquad
 r=2\sqrt{2\sum_p v_p^2}.
\]
Define \(C_d\) to be the original-degree coefficient of
\(\prod_k e^{B_k}\). Then
\[
 \|C_d\|_2\le r^d
 \quad(d\ge0),\qquad
 \left\|\prod_k e^{B_k}-1-\sum_k B_k\right\|_2
       \le \frac{r^2}{1-r}\quad(r<1).               \tag{5}
\]
This is a structural generalization: only the aggregate squared
weights matter, not the number of factors or the origin of their
labels. It follows from (3) and the elementary analysis below;
the Hilbert-space estimates themselves are not formalized in Lean.

Indeed, distinct reduced words in the \(U_p\) are orthonormal.
Hence evaluation of a group-ring element \(f\) preserves the
coefficient \(2\)-norm:
\(\|\Phi(f)\|_2^2=\sum_w|f(w)|^2\).
By (3),
\[
 \|C_d\|_2\le\|A^d\|_{\ell^2(H)}
   =\|\lambda(A)^d\delta_e\|_2\le\|\lambda(A)\|^d,
 \quad A=\sum_p v_p(T_p+T_p^{-1}).                 \tag{6}
\]
Only the coefficient norm is compared across representations.
There is no assertion of operator-norm equality between them.

For completeness, the length-one convolution bound used here has
a short proof, so it need not be imported as an unverified citation.
Let \(B_a\) project onto reduced words starting with the signed
free-basis letter \(a\). Split
\[
 \lambda(a)=\lambda(a)(1-B_{a^{-1}})
                +\lambda(a)B_{a^{-1}}.
\]
For the first part, the ranges for different \(a\) are orthogonal,
giving norm at most \((\sum|v_a|^2)^{1/2}\).
For the second, triangle inequality and Cauchy--Schwarz give the
same bound because the source projections are orthogonal.
Adding gives
\(\|\sum v_a\lambda(a)\|\le2(\sum|v_a|^2)^{1/2}\).
Applied to \(A\), the two signed letters for each \(p\) yield
\(\|\lambda(A)\|\le r\).
For a fixed finite row family, the exponential expansion is
absolutely convergent in operator norm:
\(\sum_d\|C_d\|\le\exp(\sum_k\|B_k\|)\).
It therefore converges in \(2\)-norm as well. Taking partial tails
in (6), and then their limits, proves (5) by the geometric series.
Orthogonality between different original degrees is neither used
nor generally true.

For the manuscript, (1) gives
\[
 r_\ell=2\alpha\sqrt{1-\frac1{2\ell}}\le2\alpha<1.
\]
Consequently (5) gives the stated
\(4\alpha^2/(1-2\alpha)\) remainder. It also gives the slightly
sharper length-specific bound \(r_\ell^2/(1-r_\ell)\).
This sharper expression is a consequence of the same proof,
not a claimed new solution of a separate open problem.

## 5. Independence and the exact first-order correlation

The external mathematical input is Popa,
arXiv:1308.3982v3, Theorem 0.1(a), with the published counterpart
doi:10.1016/j.jfa.2014.02.004. The primary theorem was opened at
<https://arxiv.org/html/1308.3982v3>; the relevant mathematical
passage is supplied in `popa_0_1_a_excerpt.txt`. The ledger records
the precise version and proposition; a registry resolution alone
is not an independent attribution.

For \(P\subset M\) irreducible, \((P^\omega)'\cap M^\omega=\mathbb C\).
Here is the needed argument. If a bounded representative \(b_n\)
commutes with every sequence of unitaries from \(P\), then
\(\delta_n=\sup_{w\in\mathcal U(P)}\|wb_nw^*-b_n\|_2\)
tends to zero along the ultrafilter; otherwise select one offending
unitary at each coordinate. The least-norm point in the closed
convex hull of the orbit of \(b_n\) is bounded, invariant under
conjugation, and has trace \(\tau(b_n)\). Irreducibility makes it
\(\tau(b_n)1\), whence
\(\|b_n-\tau(b_n)1\|_2\le\delta_n\).
Bounded scalar sequences have scalar ultralimits. This proves
the commutant assertion without a spectral-gap assumption.

The coordinate nonintertwining condition in Popa's theorem also
holds: no nonzero corner of the diffuse factor \(P\) has a normal
embedding into a finite-dimensional matrix amplification of
\(P'\cap M=\mathbb C\). A nonzero normal representation of a
factor is faithful, which would force that corner to be finite
dimensional.

For a norm-separable unital \(D\subset M^\omega\), apply Popa to
\(X=D\cap\ker\tau\). The diffuse abelian algebra obtained contains
a Haar unitary, for example by dyadic trace partitions and the
uniform limit of their binary step functions, followed by
\(t=\exp(2\pi i h)\). Endpoint scalar/centered decompositions and
tracial rotation give
\[
 \tau(d_0t^{n_1}d_1\cdots t^{n_j}d_j)=0           \tag{7}
\]
for nonzero powers, centered internal \(d_i\), and arbitrary
endpoints. This gives a Haar unitary free from \(D\).
These steps use only standard functional calculus and trace
normality as ambient operator-algebra foundations.

Haar freeness survives replacing \(t\) by \(atb\) for unitaries
\(a,b\in D\). To check this rather than assume it, expand powers of
\(atb\) into signed \(t\)-letters. Gaps at a change of sign are
unitary conjugates of centered internal coefficients, hence
centered. Expand the equal-sign gaps into centered and scalar
parts; removing a scalar gap joins only letters of equal sign.
All surviving blocks are nonzero powers of \(t\), and (7)
annihilates each term. Adjoint absorption is immediate by reversing
the powers.

Thus the manuscript's successive \(t_0,\ldots,t_\ell\) exist in
\(P^\omega\). Its \(s_1=t_0,\ s_{j+1}=ut_j\) are successive free
Haar variables. The final \(W=(g_\ell u)t_\ell\) is Haar and free
from \(D_\ell\), and so is \(y=zW^*\). For \(p\) in the inner
free group, the \(Y_p=pyp^{-1}\) form a free Haar family:
an alternating product of their nonzero powers has internal
base-algebra factors \(p_i^{-1}p_{i+1}\) with trace zero;
(7) applies with arbitrary endpoints. Distinct reduced
\(Y\)-words are therefore orthonormal.

Now set
\[
 h=\frac{\alpha}{\ell}\sum_{j=1}^{\ell}
              \operatorname{Im}(g_j^{-1}yg_j),\qquad
 H_k=g_khg_k^{-1}.
\]
The inverse prefix labels are distinct, and the imaginary parts
are centered orthogonal vectors of squared norm \(1/2\).
Thus \(h=h^*\), \(\|h\|\le\alpha\), and
\(\|h\|_2=\alpha/\sqrt{2\ell}\). Moreover
\[
 iH_k=c\sum_j(Y_{p_{kj}}-Y_{p_{kj}}^{-1}).
\]
Equation (2) gives \(W'=(\prod_k e^{iH_k})W\).

For the linear correlation, \(\tau(\xi^*W)=0\) by (7).
For \(p\ne e\),
\[
 \tau(\xi^*Y_pW)
   =\tau(\xi^*pzW^*p^{-1}W)=0
\]
because \(p^{-1}\) is a centered internal coefficient. For every
\(p\), split \(z^*p^{-1}\) into centered and scalar parts in
\[
 \tau(\xi^*Y_p^{-1}W)=\tau(\xi^*pWz^*p^{-1}W).
\]
The centered part vanishes by (7); the scalar part is a multiple
of \(\tau(\xi^*pW^2)=0\). The only surviving terms are the
\(\ell\) diagonal positive terms \(cY_eW=cz\). Hence
\[
 \tau(\xi^*(1+C_1)W)=\frac{\alpha}{2}\tau(\xi^*z). \tag{8}
\]
Equations (5) and (8), right multiplication by the unitary \(W\),
and Cauchy--Schwarz give the exact ultrapower correlation bound.

## 6. Returning to the original factors

Every unitary of \(P^\omega\) has unitary representatives in \(P\).
Indeed, complete the polar partial isometry of a bounded
representative \(b_n\) to a unitary \(w_n\) using equality of the
complementary traces in the finite factor. Then
\[
 \|b_n-w_n\|_2=\||b_n|-1\|_2
       \le\|b_n^*b_n-1\|_2\longrightarrow_\omega0.
\]
The scalar inequality is
\(|\sqrt t-1|\le|t-1|\) for \(t\ge0\).
For the fixed finite word length, form the same prefixes,
perturbations, and exponentials on unitary representatives.
They remain uniformly bounded and represent the constructed
ultrapower elements by continuity of functional calculus.
Also
\(\|e^{ih_n}u-u\|_2\le\|h_n\|_2\), from
\(|e^{it}-1|\le|t|\).

The sets of coordinates satisfying
\[
 \|h_n\|_2<\frac{\alpha}{\sqrt{2\ell}}+\frac1\ell,
 \qquad
 |\tau(\xi^*W'_n)-\tau(\xi^*W')|<\frac1\ell
\]
both belong to the ultrafilter, so have a common coordinate.
Selecting it gives both literal inequalities of
`eq:perturbation-bounds`. Selection is separately for each
\(\ell\); no common coordinate or uniform operator-norm limit
has been assumed. This completes the proposition's derivation.

## 7. Exact implications and remaining review

The contribution beyond the initially untested route is universal:
the collision energy and the arbitrary-degree coefficient estimate
are now proved, rather than extrapolated from finite examples.
The group-independent filtered-coefficient theorem (3) separates
the general positive-convolution mechanism from the specific
prefix construction.

The bridge to relative generation is precise but not a claim
that all downstream manuscript results have been audited. At a
common continuity point of the projection norms \(f_\xi\), a
proper \(N_u=W^*(P,u)\) gives a bounded nonzero
\(\xi=z-E_{N_u}(z)\), with \(s=\|\xi\|_2>0\) and
\(\tau(\xi^*z)=s^2\). For
\(0<\alpha<\min(1/4,s/32)\), the proposition yields
\[
 |\tau(\xi^*W_\ell)|
 \ge\alpha s^2/2-s\,4\alpha^2/(1-2\alpha)-1/\ell
 >\alpha s^2/4-1/\ell .
\]
Since \(W_\ell\in N_{u_\ell}\) is unitary,
\(f_\xi(u_\ell)\ge|\tau(\xi^*W_\ell)|\), while
\(u_\ell\to u\) and \(f_\xi(u)=0\). This contradicts continuity.
The separate completeness/Baire and conditional-expectation
arguments in `generation.tex` remain analytic inputs outside Lean.
No inference about the corner encoding or free entropy is needed.

The local Wiki index had no directly matching finite-factor result.
A targeted literature search for this combination of Popa
independence, uniform perturbation, and coefficient convolution
did not establish an earlier independently verified instance.
This limited search is **not** a proof of novelty. The underlying
analytic construction belongs to the staged manuscript; mathematical
novelty and publishability of this independent formal certificate
remain decisions for the independent Reviewer.

`verify.py --write-certificate` recomputes rational group-ring
regressions, checks the token/exponent-tuple translation in its
finite cases, runs the actual Lean 4.31.0 compiler through
`lean_evidence verify --claim C_UP_CORE`, and runs both official
campaign-local structural checks. `verify.py` without that flag
repeats these computations and compilation and compares the
recomputed certificate; it never infers success from a stored
verdict. The finite regressions are explicitly ancillary to the
universal Lean proof.

The exact replay command, from the campaign directory, is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/uniform-perturbation/verify.py
```

The preserved Jacobian call was the bounded operation
`topology.simplicial.edge_path.word.compute`. Its typed output
lists six edge labels for a word that independently reduces to
identity. The output is an edge-label representation, not a
normal-form certificate. Its raw payload, result, protocol,
server version, and success status are retained; it is not used
to justify any universal mathematical conclusion.
