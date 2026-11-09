# Two-intercept reshaping in arbitrary characteristic

## Statement and source fidelity

The object audited is `prop:reshape` in
`research/openai_manuscript/Maximal-multipoint-Seshadri-constants-in-positive-characteristic-October-5-2026/build/build/sections/04-reshape.tex`.
Here a graded family means finite sets \(S_N\subset\mathbb Z^n\), \(N\geq1\),
with \(S_N+S_M\subset S_{N+M}\), and
\[
 \Delta(a_1,\ldots,a_n)
 =\{z\in\mathbb R_{\geq0}^n:\ \sum z_i/a_i\leq1\}.
\]
The base field is algebraically closed, as stipulated in
`02-transfer.tex`. No countability or characteristic restriction is needed
for the result proved below. Supports are constructed for each chosen field;
they need not be the same in different characteristics.

The manuscript asks for arbitrary positive real intercepts, \(n\geq2\),
\(H=AB\), \(d=\max(3/A,2/B)\), and \(0<dw<1/16\). Its conclusion is
degreewise cardinality-preserving, graded reshaping into
\(\Delta(w,H/w,a_3,\ldots,a_n)\), with backward transfer of all finite
multipoint jet-surjectivity tests. This is the target, not an assumption.
The main Seshadri and Nagata assertions are not premises and are not
certified by this audit.

An eliminated objection is characteristic-two coincidence of the branches.
The staged positive-characteristic source uses
\(g=y^2+xy-x^3\), not the complex companion's
\(y^2-x^2(1+x)\). For the polynomial actually used, \(Z^2+Z-x\)
has distinct simple roots \(0,-1\) modulo \(x\), even in characteristic
two. Another inapplicable objection is that compression must give consecutive
exponents: the source expressly permits gaps, including the orders \(0,p\)
of \(\langle1,z^p\rangle\) in characteristic \(p\).

## Strengthened theorem

Let \(k\) be any algebraically closed field. Under the hypotheses above,
replace \(dw<1/16\) by the weaker condition
\[
                         0<dw<1/3.
\]
Then the same conclusion holds. Moreover, for every degree \(N\), every
number of distinct torus points, and every list of nonnegative jet orders
\((m_1,\ldots,m_r)\), the *maximum rank* of the corresponding evaluation
map cannot increase under the transformation. Thus all mixed-order
jet-surjectivity tests transfer backward, not just equal-order tests.
Coordinates \(3,\ldots,n\) are unchanged labels throughout.

This is a universal theorem, not an inference from the finite computations
accompanying it. The improvement asserted here is relative to the explicit
constant in the staged manuscript. A claim of priority over the literature,
or of publishable novelty, requires independent review and is not made here.

## Elementary least-term and specialization facts

For an addition-compatible total well-order on nonnegative integral
exponents, the least exponent of a product is the sum of the least
exponents. In a finite-dimensional space \(V\) of formal series, successively
eliminating the coefficient of the least term constructs a basis with
distinct least exponents. Every nonzero linear combination has the least
exponent of one of those basis elements. Consequently the set of possible
least exponents has exactly \(\dim V\) elements. If
\(V_{N,\gamma}V_{M,\delta}\subset V_{N+M,\gamma+\delta}\), the resulting
labelled supports are graded. This proves cardinality and cross-degree
multiplication simultaneously, with no bound on \(N,M\).

Use the order comparing \((\alpha+t\beta,\beta)\) lexicographically,
for any real \(t>0\). There are finitely many exponents below any given
weight. For any finite list of series and their least exponents, take a
bound larger than all their least weights. Perturb \(t\) to a sufficiently
close rational \(t'>t\). The finite strict comparisons persist, ties are
resolved by increasing \(\beta\), and terms above the bound cannot intrude,
because their weights only increase. Clearing denominators supplies a
common positive integral exposing weight. The order is fixed in every
degree; only this auxiliary exposing weight depends on the finite test.

Here is the rank form of the specialization argument. Suppose polynomial
or Laurent-polynomial functions \(f_j\), written in formal parameters at a
smooth point, have uniquely least terms \(c_jz^{e_j}\) for a common positive
integral weight \(\lambda\). Include unchanged Laurent monomials
\(u^{\gamma_j}\). At a tuple \((Q_i,U_i)\) of distinct torus points,
substitute
\[
 z_a=s^{\lambda_a}(Q_{i,a}+\delta_a),\qquad
 u_b=U_{i,b}+\epsilon_b
\]
in \(k[[s]][\delta,\epsilon]/(\delta,\epsilon)^{m_i+1}\) for each block.
Divide column \(j\) by \(c_js^{\lambda\cdot e_j}\). All columns remain
integral over \(k[[s]]\), and their reductions are exactly the mixed-order
jet columns of \(z^{e_j}u^{\gamma_j}\). Every nonzero minor of size \(\rho\)
in that reduced matrix remains nonzero over \(k((s))\). There are no
derivatives divided by factorials.

For the coordinate changes used here, the induced maps on the full jet
algebras are isomorphisms independently of the rank of the chosen functions.
Indeed, the inverse formal coordinate series can be evaluated at the
displayed \(s\)-adically small arguments, and their Jacobian has invertible
constant determinant. After inverting \(s\), the additional diagonal
scalings \(s^{\lambda_a}\) are invertible. This identifies the truncated
local rings in both directions. The original points over \(k((s))\) are
distinct: an invertible formal coordinate map preserves equality of
centers, and the scaled pairs \((Q_i,U_i)\) were distinct.

The nonzero minor is therefore a nonzero rational function on the
configuration space for the original functions. Clear the finitely many
Laurent denominators. A nonzero polynomial over the infinite field \(k\)
is nonzero somewhere in any prescribed nonempty affine open: this follows
by induction on the number of variables from the univariate root bound,
applied also to the finitely many polynomials defining the open.
Thus rank at least \(\rho\) is attained at distinct \(k\)-points in the
torus. This proves rank domination, and in particular backward
surjectivity, for every finite list \((m_i)\).

For a row of Laurent polynomials in \(z\), use the local parameter \(z-1\).
The same argument proves rank transfer for replacement by orders at \(1\).
If the row exponents range from \(a_-\) to \(a_+\), multiplication by
\(z^{-a_-}\) is a unit at \(1\) and turns every row element into a
polynomial of degree at most \(a_+-a_-\). A nonzero polynomial cannot
vanish to order greater than its degree. Hence all compressed orders lie
in \([0,a_+-a_-]\). This works with negative exponents and in every
characteristic; it does not assert consecutiveness.

An integral unimodular exponent change is a torus automorphism. It
preserves cardinalities, addition, and all mixed-order jet ranks exactly.

## The nodal bound, including characteristic two

Put \(W=dH=\max(2A,3B)\), \(c=1/d\), and \(T=dW\).
Since \(dA\geq3\) and \(dB\geq2\), multiplication gives
\(T=(dA)(dB)\geq6\).
Take \(g=y^2+xy-x^3\). The coefficient recursion for
\(r^2+r=x\), with prescribed constant term \(0\) or \(-1\), has a unique
solution in \(k[[x]]\): at each step the coefficient to solve has multiplier
\(2r(0)+1\), which is \(1\) or \(-1\), never zero in any characteristic.
Writing the roots as \(r_1,r_2\), their sum is \(-1\) and product is
\(-x\). The parameters
\[
 \eta=y-xr_1(x),\qquad \xi=y-xr_2(x)
\]
have independent linear terms \(y,y+x\) and satisfy \(g=\xi\eta\).
An invertible linear part gives an inverse formal substitution by recursive
solution degree by degree. This also supplies the formal inverse used in
the preceding rank argument.

The parametrization \(x=v(v+1)\), \(y=v^2(v+1)\) induces an injection
\(k[x,y]/(g)\hookrightarrow k[v]\). For completeness, divide a polynomial
by the monic polynomial \(g\) in \(y\). A remainder is \(a(x)+yb(x)\);
its specialization is \(a(v(v+1))+v\,v(v+1)b(v(v+1))\).
The two summands, when nonzero, have respectively even and odd degrees,
so cannot cancel. This proves injectivity and the kernel statement
without a separability assumption.

Let \(f=g^ef_0\ne0\) with \(g\nmid f_0\), all exponents of \(f\) lying in
\(\kappa\Delta(A,B)\), \(\kappa\geq0\). Weighted degree with weights
\(1/A,1/B\) is additive, since highest-weight forms multiply in a domain.
The mixed term of \(g\) has weight at most \(d\), so
\[
 ed\leq\kappa,\qquad
 \deg_{A,B}f_0\leq\kappa-ed,\qquad
 \deg f_0(v(v+1),v^2(v+1))\leq W(\kappa-ed).
\]
The last polynomial is nonzero by the injection just proved.
The two formal branches correspond to \(v=0,-1\); the surviving local
parameters have order one there. If
\(\nu_t(f_0)=(\alpha,\beta)\), \(\mu=\alpha+t\beta\), restricting the
series to each branch gives respective orders at least \(\mu,\mu/t\).
The points \(0,-1\) are distinct, including in characteristic two, so their
orders add to at most the degree of the nonzero polynomial. Therefore
\[
 (1+1/t)\mu\leq W(\kappa-ed).
\]
For \(a=Wt/(1+t)\), \(b=W/(1+t)\), this is exactly
\((\alpha,\beta)\in(\kappa-ed)\Delta(a,b)\).
Since \(\nu_t(g^e)=(e,e)=ed(c,c)\), convexity gives
\[
 \nu_t(f)\in
 \kappa Q,\qquad
 Q=\operatorname{conv}\{0,(a,0),(c,c),(0,b)\}.
\]
This includes \(e=0\) and \(\kappa=0\); the latter allows only constants.

## A fixed primitive direction and the improved constant

Set \(R=H/w\), \(a_0=WT/(1+T)\), and assume \(dw<1/3\). Then \(R>3W\).
Consider the open interval
\[
 L=d(R-3W),\qquad U=d(R-3a_0).
\]
Its length is \(3T/(1+T)>2\). Thus it contains two consecutive integers:
if \(q=\lfloor L\rfloor+1\), then \(L<q<q+1<U\).
At least one of \(q,q+1\) is not divisible by \(3\).
Choose it as \(i\). The vector \(u=(i,3)\) is primitive. Define
\[
 a=(R-i/d)/3,\qquad b=W-a,\qquad t=a/b.
\]
The interval inequalities give \(a_0<a<W\), \(b>0\), and \(t>T\).
The heights of the vertices of
\[
 P=\operatorname{conv}\{(-b,0),(a,0),(0,c)\}
\]
under \(z\mapsto\det(u,z)\) are
\[
                    -3a<3b<i/d.
\]
Their range is exactly \(i/d+3a=R\), because
\(i/d-3b=R-3W>0\). All statements are for arbitrary real parameters;
no rational approximation of an intercept is made.

This replaces the manuscript's dyadic choice of the second component by
the fixed value \(3\). It both simplifies that step and strengthens the
uniform sufficient condition. No assertion is made that \(1/3\) is optimal.

## Complete composition and all-degree coverage

Choose \(t\) and \(u\) once, independent of \(N\). For each unchanged label
\(\gamma=(\gamma_3,\ldots,\gamma_n)\) in degree \(N\), put
\(\kappa=N-\sum_{h\geq3}\gamma_h/a_h\). The nonnegative original exponents
imply \(\kappa\geq0\) and the pair row is in
\(\kappa\Delta(A,B)\). Apply the nodal least-term construction separately
to these row spaces. Their products land in the row with added degree
and label because the original family was graded. The least-term facts
prove exact cardinality and gradedness. For each degree only finitely many
bases are involved, so one common exposing weight handles every label in
any finite mixed-jet test. Rank transfers back by the specialization proof.
Empty rows remain empty; a completely empty degree has rank zero.
No simultaneous choice of points for infinitely many degrees is asserted
or needed: each backward finite-jet test has its own tuple.

For clarity, all subsequent bounds are *continuous slice-length bounds*,
not lattice-point counts. If a row in a polygonal slice has extreme
integral exponents \(a_-,a_+\), then its compressed orders are bounded by
\(a_+-a_-\), which is at most that slice's real length. This justifies
every compression for arbitrary real endpoints.

Since \(t>T\), one has \(c/a+c/b>1\), and \(Q\) is the stated
quadrilateral. The shear \((\alpha,\beta)\mapsto(\alpha-\beta,\beta)\)
followed by vertical compression gives \(P\): at horizontal coordinate
\(q\), the sheared polygon has vertical slice length
\[
 c(1+q/b)\quad(-b\leq q\leq0),\qquad
 c(1-q/a)\quad(0\leq q\leq a).
\]
Its area is \(c(a+b)/2=H/2\).

Choose any integral \(v\) with \(\det(u,v)=1\), and express exponents in
the basis \((u,v)\). The second coordinate is \(\det(u,z)\), so the vertex
heights are \(q_0=-3a<q_1=3b<q_2=i/d\). Horizontal slice length rises
linearly from zero at \(q_0\), reaches its maximum at \(q_1\), and falls
linearly to zero at \(q_2\). Its maximum is \(w\), since the area is
\((q_2-q_0)\cdot\text{maximum}/2=H/2\).
Horizontal compression therefore bounds the support by
\[
                  \operatorname{conv}\{(0,q_0),(w,q_1),(0,q_2)\}.
\]
At horizontal coordinate \(h\in[0,w]\), this tent has vertical length
\((q_2-q_0)(1-h/w)=R(1-h/w)\). Final vertical compression gives
\(\Delta(w,R)\). Every slice formula commutes with every real dilation
\(\kappa>0\). For \(\kappa=0\), the only possible exponent is \(0\);
all linear maps and all order-at-one operations fix it.

Restoring the unchanged labels proves
\[
 S'_N\subset N\Delta(w,H/w,a_3,\ldots,a_n),\qquad
 \#S'_N=\#S_N.
\]
Each operation is fixed across all degrees and is multiplicative at the
row-space level. Thus \(S'_N+S'_M\subset S'_{N+M}\) for all positive
degrees, not just the degrees tested computationally. Repeated rank
domination proves the full mixed-order assertion, hence the manuscript's
backward jet transfer in every degree. For \(n=2\) there is one empty
label, and the same proof applies.

## Corresponding constructions and downstream limits

The complex higher-dimensional companion's `sections/reshaping.tex`
contains the same two-intercept proposition and its nodal,
shear/compression, primitive-height, and final tent steps. Its node is
\(y^2-x^2(1+x)\), parametrized by
\(x=v^2-1,\ y=v(v^2-1)\), appropriate over the complex numbers.
Its `sections/transfers.tex` supplies finite analytic jet-rank persistence
and the elementary transformations. The surface companion's
`sections/node.tex` bounds actual section valuations by a quadrilateral
with \(c=1/d\), \(a+b=dH\), and area \(H/2\);
`sections/compression.tex` then performs the diagonal-to-triangle
compression and backward section-jet transfer. These are provenance and
dependency comparisons, not assumptions that their main theorems hold.

The higher-dimensional downstream uses are the initial flag supports,
full-density saturation, and elongated-simplex interpolation. The surface
downstream use is the subsequent interpolation/nef argument in
`sections/nef.tex`. In the positive-characteristic source the next use is
`05-interpolation.tex`, `prop:generic-jets`, which iterates reshaping
before applying interior filling and interpolation. Proving reshaping
alone does not verify those later implications or any main maximality
theorem. The independent graph keeps them open.

The exact companion source roots are
`research/openai_manuscript/Maximal-Multipoint-Seshadri-Constants-in-Higher-Dimensions-October-5-2026/build/`
and
`research/openai_manuscript/Maximal-Seshadri-Constants-on-Arbitrary-Polarized-Surfaces-September-23-2026/build/`.
In the first, the delegated source trace locates the reshaping statement
at `sections/reshaping.tex:16-29`, the complex node at lines 61-70,
the unchanged-label residual degree at lines 42-49, and the final tent
steps at lines 250-276. Its elementary transfer statements are in
`sections/transfers.tex:155-169,222-263`. In the second, the trace locates
the nodal quadrilateral at `sections/node.tex:110-151`, the
diagonal compression at `sections/compression.tex:57-121`, the
section-transfer corollary at lines 138-155, and the downstream nef use
at `sections/nef.tex:206-220`. These locators identify the staged versions,
not moving theorem numbers in external editions.

## Evidence boundary

The proof above is a mathematical proof of the strengthened reshaping
theorem. The accompanying exact computations are adversarial examples and
independent algebraic checks, not a proof of its universal quantifiers.
The Lean source and its statement-fidelity document specify exactly which
universal arithmetic and geometric identities are kernel-checked.
They do not formalize algebraic geometry, all formal series, or the whole
reshaping theorem. Independent Reviewer confirmation remains required.

The official Lean run returned `exit_code=0`, `proof_holes=[]`, and
`audit_exit_code=0` on Lean 4.31.0. Its mechanical evidence is attached
only to `C_RS_HEIGHT`, at
`lean/certificates/C_RS_HEIGHT-c62d2854794e7272.json`. The ledger derives
`closed_kernel` for that claim; this does not certify statement fidelity
or the full reshaping theorem. The original source and fidelity document
match the archived compiler inputs.

The exact Python replay passed 60 rational-parameter polygon and
height-choice cases, including values beyond the old `dw<1/16` bound.
It also computed four full support-composition examples in characteristics
zero, two, three and five, checked cardinalities, labels and all available
cross-degree sums, and checked real polygon containment at every stage.
The three-dimensional cases include residual degree zero.
One-point jet ranks were compared through order three. The
characteristic-five example also exhausts all 15 distinct normalized
two-point torus tuples, for mixed orders `(0,1)` and `(1,2)`, at every
stage in degrees one through four. These are explicitly finite-field
maxima, not a substitute for the universal geometric rank proof.
The separate Jacobian typed result verifies rank two for the nodal
linear coordinate change over the prime field of characteristic two.
Its exact payload, typed output, server/protocol versions and adapter
exit status are retained in the `jacobian_*.json` files.

Reproduce the exact supplementary certificate, without third-party Python
packages, using

```sh
python3 research/reshaping_audit/verify.py
```

Reproduce the formal claim with the prescribed interpreter:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/reshaping_audit/Main.lean --statement-fidelity research/reshaping_audit/statement_fidelity.md --artifact-dir research/reshaping_audit/lean --project-root . --claim C_RS_HEIGHT
```

No manuscript assertion has been found false in this resolved construction.
Accordingly there is no invented `F_` refutation. All main maximality
claims remain open. No unproved external mathematical proposition is
used by this self-contained proof, so there is no outstanding external
citation dependency. The source comparisons above establish an improvement
over the staged constant, not global literature priority.
