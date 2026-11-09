# A quotient-uniform algebraic obstruction

## Statement and scope

Fix a prime \(q\), integers \(h,r\geq1\) with \(q>r\), a nonempty
\(S\subset\mathbb F_q\), and \(P=\mathbb F_q^h\), \(m=|P|\).
Let \(I\) be a finite label set of size \(N\). For each \(i\), choose a
distinct mark \(a_i\in S^h\) and a nonzero direction \(d_i\in P\), and put
\[
 \ell_i=\{a_i+t d_i:t\in\mathbb F_q\},\qquad
 I(z)=\{i:z\in\ell_i,\ z\ne a_i\}.
\]
Assume \(2h(|S|-1)<q-1\). Let \(E\subset P\). At every \(z\notin E\),
assume \(I(z)\) is partitioned into two blocks. Each block has a
bijection with \(\mathbb Z/s_b\times\mathbb Z/t_b\), with \(s_b,t_b\geq r\).
Write its coordinates as \(\alpha_b,\beta_b\).

**Universal theorem.** Suppose
\[
 Nr/4>2m+r|E|.
 \tag{1}
\]
For every finite group \(Q\), it is impossible to choose elements
\(g_{iuv},L_{b,u,j},R_{b,v,k}\in Q\), \(0\leq u,v<r\), satisfying
\[
 g_{iuv}=L_{b,u,\alpha_b(i)+v}^{-1}
          R_{b,v,\beta_b(i)+u}\quad(i\in I_b)
 \tag{2}
\]
and simultaneously
\[
 g_{iuv}g_{iu'v}^{-1}g_{iu'v'}g_{iuv'}^{-1}\ne1
 \quad(i\in I,\ u\ne u',\ v\ne v').
 \tag{3}
\]
The group order \(D=|Q|\) is arbitrary, including \(q\mid D\).
In fact, (1) can be weakened to \(Nr/4\geq2m+r|E|\).

This theorem is about **fixed data**, not their existence. It requires
neither an incidence-girth hypothesis nor a geometric theorem. Those are
needed elsewhere in the manuscript to construct the data and prove
nonidentity of the words in the infinite group. They remain unverified
in this mission.

The strongest prior result in the project ledger was the unverified
campaign objective, not a proof of this obstruction. The improvement here
is a complete independent derivation with explicit interfaces, exact
adversarial fixtures, and a compiler-checked algebraic core. The weak-budget
extension follows from a strict version of the integral rank comparison.
No priority or verified-new literature claim is made.

## 1. Regular permutations and the two traces

Use column vectors indexed by \(Q\) and define
\[
 U(g)_{x,y}=[x=gy].
\]
The \((x,y)\) entry of \(U(g)U(h)\) is
\(\sum_z[x=gz][z=hy]=[x=ghy]\). Thus \(U(g)U(h)=U(gh)\),
with exactly this order, and \(U(g)^{\mathsf T}=U(g^{-1})\).
Left multiplication fixes a group element only when \(g=1\), by right
cancellation. Consequently its **integer** trace is \(D\) if \(g=1\)
and zero otherwise.

Set \(Y_i=(U(g_{iuv}))_{u,v}\), an integer matrix of size \(rD\).
Every row has squared norm \(r\). For \(A_i=Y_iY_i^{\mathsf T}\),
\[
 (A_i)_{u,u'}=\sum_v U(g_{iuv}g_{iu'v}^{-1}),
 \qquad \operatorname{tr}A_i=r^2D.
 \tag{4}
\]
Expanding its squared trace gives
\[
 \operatorname{tr}(A_i^2)=
 \sum_{u,u',v,v'}
 \operatorname{tr}U(g_{iuv}g_{iu'v}^{-1}g_{iu'v'}g_{iuv'}^{-1}).
 \tag{5}
\]
If either pair of indices agrees, the group word cancels to identity.
Otherwise (3) makes its trace zero. The degenerate set has size
\(r^3+r^3-r^2\), by inclusion-exclusion. Therefore
\[
 \operatorname{tr}(A_i^2)=(2r^3-r^2)D.
 \tag{6}
\]
These are real/integer trace identities, not traces computed modulo \(q\).

Here is the needed rank estimate without assuming a spectral inequality.
If \(A=YY^{\mathsf T}\) has image dimension \(d\), Gram-Schmidt gives
an orthonormal basis of that image. Its orthogonal projection \(T\)
satisfies \(TA=A\) and \(\sum_{jk}T_{jk}^2=d\).
Entrywise Cauchy-Schwarz, and symmetry of \(A,T\), yield
\[
 (\operatorname{tr}A)^2
 =\left(\sum_{jk}T_{jk}A_{jk}\right)^2
 \leq d\sum_{jk}A_{jk}^2=d\operatorname{tr}(A^2).
\]
Also \(\ker(YY^{\mathsf T})=\ker Y^{\mathsf T}\), since
\(x^{\mathsf T}YY^{\mathsf T}x=\|Y^{\mathsf T}x\|^2\), so
\(\operatorname{rank}A=\operatorname{rank}Y\). Equations (4)--(6) give
\[
 d_i:=\operatorname{rank}_{\mathbb R}Y_i
 \geq \frac{r^2D}{2r-1}\geq\frac{rD}{2}>0.
 \tag{7}
\]
This argument also proves the trace-rank inequality being used.

## 2. Integral minors, not division by the group order

Let \(M\) be any integer matrix with squared row norms at most \(r\geq1\),
and let \(d>0\) be its real rank. Elimination identifies a nonsingular
\(d\)-by-\(d\) minor \(B\): pivot rows and columns give such a minor,
and any larger minor vanishes. Restricting columns cannot increase norms.
Orthogonalizing the rows of \(B\) expresses \(|\det B|\) as the product
of their successive perpendicular lengths; each is at most the original
row length. Hence
\[
 1\leq|\det B|\leq r^{d/2}.
 \tag{8}
\]
Let \(e=\operatorname{rank}_{\mathbb F_q}\overline B\). Choose \(e\)
original rows spanning its row space modulo \(q\). For each other row,
subtract an integer lift of its linear combination of those fixed rows.
These operations preserve the determinant and make all entries in the
remaining \(d-e\) rows divisible by \(q\). Multilinearity of the determinant
then proves
\[
 q^{d-e}\mid\det B,\qquad q^{2(d-e)}\leq r^d.
 \tag{9}
\]
If \(2e\leq d\), then \(q^d\leq q^{2(d-e)}\leq r^d\), contradicting
\(q>r\) and \(d>0\). Thus
\[
 \operatorname{rank}_{\mathbb F_q}\overline M
 \ \geq e>d/2.
 \tag{10}
\]
For \(d=0\) the weak inequality is immediate. The manuscript's
non-strict half-rank lemma is therefore valid. Applying (10) to \(Y_i\)
and then (7) gives the slightly stronger conclusion
\[
 \operatorname{rank}_{\mathbb F_q}Y_i
 >\frac{r^2D}{2(2r-1)}\geq\frac{rD}{4}.
 \tag{11}
\]
No step divides by \(D\) in the field. The only modular inverses in this
proof concern the prime-field row-space calculation.

## 3. Shifted Cartesian blocks: the noncommutative factorization

Fix a block \(b\), and fix \(u,v\) before summing. The map
\[
 i\longmapsto(\alpha_b(i)+v,\ \beta_b(i)+u)
\]
is a bijection from \(I_b\) onto
\(\mathbb Z/s_b\times\mathbb Z/t_b\): it is the given coordinate
bijection followed by two translations. By (2) and the homomorphism
identity already proved,
\[
 \begin{split}
 \sum_{i\in I_b}U(g_{iuv})
 &=\sum_j\sum_k U(L_{b,u,j}^{-1})U(R_{b,v,k})\\
 &=\left(\sum_jU(L_{b,u,j}^{-1})\right)
   \left(\sum_kU(R_{b,v,k})\right).
 \end{split}
 \tag{12}
\]
Distributivity, not commutation, proves the last equality.
The first factor depends only on \(u\); the second only on \(v\).
Thus (12) proves an equality of whole block matrices, with a block
column of height \(r\) and a block row of width \(r\), and inner
dimension \(D\). Each block sum has rank at most \(D\).

For \(Z(z)=\sum_{i\in I(z)}Y_i\), the two-block partition gives
\[
 \operatorname{rank}Z(z)\leq2D\quad(z\notin E),\qquad
 \operatorname{rank}Z(z)\leq rD\quad(z\in E).
 \tag{13}
\]
For the first bound, the image of a sum is contained in the sum of
the images, and the image of a product is contained in the image
of its first factor. The second bound is just the ambient dimension.
Exceptional incidences are retained.

## 4. Interpolation and the own-mark puncture

For \(a_i=(a_{i1},\ldots,a_{ih})\), put
\[
 f_i(X)=\prod_{t=1}^h\prod_{a\in S\setminus\{a_{it}\}}
            \frac{X_t-a}{a_{it}-a},\qquad H(z)=f(z)f(z)^{\mathsf T}.
 \tag{14}
\]
All denominators are nonzero. Evaluation on the grid proves
\(f_i(a_j)=[i=j]\): an unequal grid coordinate supplies a zero
factor; equal coordinates supply ones. Therefore \(H(a_i)=E_{ii}\),
and each \(H(z)\) has image in the span of \(f(z)\), of dimension
at most one.

Every entry of \(H(a_i+Td_i)\) has degree at most
\(2h(|S|-1)<q-1\). For \(0\leq n<q-1\),
\(\sum_{t\in\mathbb F_q}t^n=0\).
For \(n=0\) this is \(q=0\) in the field. For \(n>0\), the polynomial
\(X^n-1\) has at most \(n\) roots: induction follows by division by
\(X-a\) at each root. There is consequently a nonzero \(c\) with
\(c^n\ne1\). Multiplication by \(c\) permutes the field, so the power
sum equals \(c^n\) times itself and is zero. Expanding a polynomial
as a sum of monomials now proves its zero line sum.

Because \(d_i\ne0\), \(t\mapsto a_i+td_i\) is injective, so summing
over parameters sums over the line once. Removing \(t=0\) yields
\[
 \sum_{z:\ i\in I(z)}H(z)=-H(a_i)=-E_{ii}.
 \tag{15}
\]
Only this line's own mark is removed. A different mark lying on the
line is still included. Neither line distinctness nor any genericity
of the marked configurations was used.

## 5. Tensor identity and the strict contradiction

Distributivity of the Kronecker product and exchange of finite sums give
\[
 \begin{split}
 \sum_{z\in P}H(z)\otimes Z(z)
 &=\sum_i\left(\sum_{z:\ i\in I(z)}H(z)\right)\otimes Y_i\\
 &=-\sum_iE_{ii}\otimes Y_i=-\bigoplus_iY_i .
 \end{split}
 \tag{16}
\]
This identity is entrywise over the field; its sign is essential and
is immaterial only after taking rank.
For completeness, the image of \(H\otimes Z\) is contained in
\(\operatorname{im}H\otimes\operatorname{im}Z\): it suffices to check
pure tensors of basis vectors. A tensor product of bases has
\((\dim\operatorname{im}H)(\dim\operatorname{im}Z)\) members.
Thus each summand in (16) has rank at most \(\operatorname{rank}Z(z)\).
The images of the separate diagonal blocks form a direct sum, so
the left side has rank \(\sum_i\operatorname{rank}Y_i\).
Subadditivity and (11)--(13) imply
\[
 NrD/4
 <\sum_i\operatorname{rank}Y_i
 \leq2(m-|E|)D+r|E|D
 \leq2mD+r|E|D.
 \tag{17}
\]
Here \(N>0\) follows from either budget, since \(m>0\).
Dividing this **ordinary integer/real inequality** by the positive
integer \(D\) contradicts even the weak budget. This proves the theorem.

## 6. The finite-family quantifier

Let \(G\) be any group, and \(W\) any finite family. Suppose no finite
quotient keeps all its members nonidentity. If each \(w\in W\) survived
under some \(\phi_w:G\to Q_w\), the map
\(\phi:G\to\prod_{w\in W}Q_w\), \(g\mapsto(\phi_w(g))_w\), would
preserve every member: its own coordinate is nonidentity.
The finite image of \(\phi\) is a quotient with the same property,
a contradiction. Hence some fixed \(w\) is killed by every finite-group
homomorphism. If \(W\) were empty, the trivial quotient would already
preserve it vacuously, so the premise itself rules that case out.

For the manuscript, apply this to its rectangular words after mapping
the triangle relations into each finite image. Nonidentity of those
words **in \(G\)** is needed only to conclude the finite residual is
nontrivial; it has not been assumed in proving the algebraic obstruction.

## Certification boundary

`Main.lean` and `statement_fidelity.md` specify the exact universal
algebraic subtheorems checked by Lean. The real-rank and integral-minor
arguments above are mathematical proofs, not claims that Python or the
Lean core formalizes them automatically. `verify.py` replays exact finite
fixtures, including noncommuting permutations, quotient orders divisible
by the characteristic, actual loss of rank under reduction, the own-mark
puncture, and the complete tensor identity. These fixtures are supporting
checks, not a finite-search proof of a universal statement.

No staged manuscript assertion was found false in this algebraic audit.
No `F_` refutation claim is warranted by these results. The entire
hyperbolic-group construction, novelty, publishability, and independent
Reviewer acceptance are not certified by this mission.

The official `lean_evidence verify --claim Q_FORMAL_CORE` run exited zero
with no proof holes and a successful axiom audit. Its archived certificate is
`certificates/Q_FORMAL_CORE-8eb74f0574b0b4e3.json`. The ledger derives
`closed_kernel` for **that core claim only**; statement-fidelity review
is still independent work.

Replay the persistent exact certificate from the campaign root:

```sh
python3 research/quotient_uniform/verify.py
```

This also checks that the current Lean source and fidelity document match
the actual archived compiler evidence. To obtain a fresh compiler result:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/quotient_uniform/Main.lean --statement-fidelity research/quotient_uniform/statement_fidelity.md --project-root . --claim Q_FORMAL_CORE --timeout 110
```
