# Point-center mechanism: source scope and universal verification

## Scope and classification

The target is `prop:point-center` in the staged September 23, 2026
manuscript, `build/sections/centers.tex`. The selected outcome is a universal,
conditional verification theorem, not a counterexample and not a proof of
Fujita's conjecture. Independent review and publication-level novelty
assessment are pending.

The earlier project ledger contained only the overall audit objective; it
contained no proved point-center result. This work supplies a full
derivation of the center mechanism, including uniform restriction images,
weighted growth, first variation, and the prescribed order of limits. A
quantitative refinement replaces the implicit choice of `t` by the
sufficient inequality `t > n+1-a_*/(n+2)`.

## Exact source findings

The source was read together with `preliminaries.tex`, the definition
`eq:min-objective`, and the statements and proofs surrounding
`prop:minimizers` and `lem:specialization` in `minimization.tex`.

* `lem:uniform-restrictions` is about the image of
  `H^0(X,hL) -> H^0(W,hL|_W)`. No surjectivity or extension theorem on
  singular `W` is asserted or needed.
* The center is closed, integral, and contains `x`. The smooth point used for
  Taylor expansion is allowed to vary with the center and reference degree.
* One test, local frame, and coordinate system are fixed across all auxiliary
  degrees for a given `m`. They need not be fixed as `m` varies.
* Only the degree-`m` first variation invokes specialization at `y`.
  The comparison in degree `j` is at `x` using `(j/m)v`.
* Differentiation is at fixed `m`; the partition limit takes `m -> infinity`
  with its length fixed, followed by partition refinement.

The following upstream manuscript assertions are **not independently verified
by this mission**:

1. Failure of adjoint generation gives the strict ordinary-order gap.
2. `prop:minimizers` supplies attainment in all sufficiently large degrees,
   a common interval `[t_0,n+1]`, a positive finite lower limit of the minima,
   and a discrepancy lower bound `a_*>0` uniform on that interval.
3. `lem:specialization` supplies `f_{m,t}(y) >= f_{m,t}(x)` at a very general
   point of each possible center.

The point-center theorem below is an implication from these assertions.
It cannot close their proofs or the later isolation and lifting arguments.

The project wiki index had no entry matching Fujita, point centers,
restriction spaces, tangential variation, or this campaign identifier.

## Literature boundary

The only non-elementary convex-geometric input needed is Brunn--Minkowski
for compact measurable sets, not just convex bodies:
Gardner, *The Brunn--Minkowski inequality* (2002),
DOI `10.1090/S0273-0979-02-00941-2`, Theorem 4.1.
The exact statement was read on printed page 362 of the primary
author-university PDF; `gardner_excerpt.txt` preserves its hypotheses.
A local primary copy is retained as `gardner.pdf` for independent reading.
A search response paraphrasing only the convex-body version was insufficient.
The publisher download returned HTTP 403; the university copy was accessible.

Eventual global generation is the implication (1) -> (7) of the Stacks
Project, Proposition 28.27.13, tag `01Q3`, read in the primary source
`https://stacks.math.columbia.edu/tag/01PR`.
The positive integer degree and finite-map degree formula are Stacks
Project Lemmas 33.45.4, 33.45.9, and 33.45.11 (tags `0BEQ`, `0BEV`,
`0BEX`); Hilbert asymptotics are Proposition 33.45.13 (tag `0BJ8`).
These statements and their proofs were read in the primary section
`https://stacks.math.columbia.edu/tag/0BEL`.
Finite linear projection and generic smoothness are geometric inputs,
not consequences of the Lean certificate.

The one-dimensional-leaf count is proved directly by finite-dimensional
elimination, so the manuscript's comparison with Kaveh--Khovanskii,
Proposition 2.6, is not a dependency of the independent argument.

## Jacobian scope

The authorized adapter reports Jacobian 0.14.0, MCP protocol 2025-11-25.
Discovery and inspection show that `polytope.lattice_points.count` is
restricted to dimensions at most four. It cannot certify the arbitrary
dimension theorem, and will not be used as if it did.

`polynomial.multivariate.factor.compute` accepts bounded sparse polynomials
over `QQ`. It is applicable to the exact denominator-cleared algebra in the
quantitative terminal contradiction. Its typed payload and output will be
kept separately from this report. Polynomial factorization alone is not
evidence for the geometric or limiting steps.

## Universal theorem

Let \(X,L,n,x\) and the admitted monomial tests be exactly as in the
manuscript, with \(n\geq1\). Suppose the following upstream conclusions hold:

1. For some \(0<t_0<n+1\), all sufficiently large degrees and every
   \(t\in[t_0,n+1]\) have attained minima, bounded between two fixed
   constants \(0<c_0\leq f_{m,t}(x)\leq1-\delta\).
2. Every minimizing test in that range has \(A(v)\geq a>0\), where \(a\)
   is independent of the degree, the test, and \(t\).
3. For each fixed reference degree and every possible integral center
   \(W\ni x\), the stated very-general specialization comparison holds.

**Theorem.** Fix any
\[
 t\in[t_0,n+1),\qquad t>n+1-\frac{a}{n+2}.
 \tag{1}
\]
Write \(c=\liminf_j f_{j,t}(x)\). On every increasing sequence
\(m\to\infty\) with \(f_{m,t}(x)\to c\), all sufficiently late degrees
have **every** minimizing monomial pair centered exactly at \(\{x\}\).
The centers, their degrees and singularities, the models, the weights,
and the bases may all vary with \(m\).

Such a \(t\) exists: take the midpoint of \(n+1\) and
\(\max\{t_0,n+1-a/(n+2)\}\). This choice precedes the degree sequence.
The conclusion is eventually along a liminf sequence, hence at arbitrarily
large degrees, exactly as `prop:point-center` requires. It does **not**
assert point centers in every sufficiently large degree without a
liminf-sequence hypothesis. The restriction and slice-growth estimates
below, in contrast, do hold in every sufficiently large auxiliary degree.

This proves the selected point-center implication conditionally on the
three exposed upstream conclusions. Its proof follows.

### 1. Uniform restriction images in every large degree

Fix \(k>0\) with \(kL\) very ample and fix \(1\leq d\leq n\). Put
\(D_0=k^d\). For any integral \(d\)-dimensional \(W\subset X\),
its degree in this embedding is
\[
 D=(kL)^d\cdot W=k^d(L^d\cdot W)\geq D_0.
 \tag{2}
\]
The last factor is a positive integer; smoothness or bounded degree of
\(W\) is not required.

A general \((d+1)\)-tuple of linear forms has no common zero on \(W\).
It defines a finite surjective linear projection
\(\pi:W\to\mathbb P^d\). For completeness, its pullback of
\(\mathcal O(1)\) is the ample bundle \(kL|_W\); a positive-dimensional
projective fiber would make this bundle trivial on a curve in that
fiber, contradicting ampleness. Thus the proper morphism is
quasi-finite and hence finite. The degree formula gives
\([\mathbb C(W):\mathbb C(\mathbb P^d)]=D\).

Set \(K=\mathbb C(\mathbb P^d)\), \(E=\mathbb C(W)\), and let \(s_0\)
be a nonzero projection coordinate. Characteristic zero makes \(E/K\)
separable, so the geometric generic fiber consists of \(D\) distinct
points. All are in \(s_0\ne0\). Select \(D_0\) of them. Products of at
most \(D_0-1\) affine linear forms interpolate arbitrary values on these
selected points: for each point, use one separating factor for every
other selected point. Homogenizing with \(s_0\) gives degree-\(D_0\)
ambient forms. Consequently
\[
 V_{D_0}\otimes_{\mathbb C}K\longrightarrow E,\qquad
 F\longmapsto F/s_0^{D_0}
 \tag{3}
\]
has rank at least \(D_0\). Rank is preserved by field extension, so
this geometric-generic-fiber argument really proves a statement over
\(K\). A monomial spanning set of \(V_{D_0}\) therefore contains
\(F_1,\ldots,F_{D_0}\) whose normalized restrictions are
\(K\)-linearly independent.

For \(q\geq D_0\), multiply each \(F_i\) by the degree-\((q-D_0)\)
monomials in the projection coordinates. A complex linear dependence
among these products, divided by \(s_0^q\), would be a \(K\)-linear
dependence among the \(F_i/s_0^{D_0}\). Each coefficient must vanish;
surjectivity onto \(\mathbb P^d\) then makes each base polynomial zero.
Thus these are independent restrictions of actual sections on \(X\):
\[
 I_W(qk)\geq D_0\binom{q-D_0+d}{d},\qquad
 (d!I_W(qk))^{1/d}\geq qk-kD_0.
 \tag{4}
\]
The second inequality follows by expanding the binomial as a product of
\(d\) factors, each at least \(q-D_0\).

For each residue \(r\bmod k\), choose once a nonnegative integer \(h_r\)
in that residue with \(h_rL\) globally generated. Given \(W\), choose a
section of this bundle nonzero at one point of \(W\). Multiplication by
its restriction injects restriction images, since \(W\) is integral.
The section may depend on \(W\); the degree \(h_r\) does not. Writing
\(h=qk+h_r\), (4) proves
\[
 (d!I_W(h))^{1/d}\geq h-C_d\quad(h\geq H_d),\qquad
 C_d=H_d=\max_r h_r+k^{d+1}.
 \tag{5}
\]
This covers all sufficiently large integers, not only multiples of \(k\).
No section of \(hL|_W\) outside the restriction image has been used.

### 2. Pure initials, with no extension assumption

Fix one minimizing test in one reference degree \(m\), with center
\(W\) of dimension \(d>0\). Choose \(y\in W_{\rm sm}\) very general
for specialization in degree \(m\) only. On the smooth model choose
\(z\) in its open positive-support stratum, smooth over \(y\), avoiding
the other components of the relative canonical divisor.

There are \(r\) positive-weight parameters, \(n-d-r\) fiber parameters,
and \(d\) tangent parameters pulled back from affine projective
coordinates on \(W\). Such tangent parameters exist because the fixed
embedding has rank \(d\) on the tangent space at a smooth point.
Generic smoothness supplies the fiber parameters. Complete these by the
equations of the \(r\) crossing components. This gives a regular system
of parameters compatible with the entire local relative canonical divisor.

Use the pullback of a frame of \(L\) near \(y\), in every degree.
Write exponents as \((p,\beta)\in\mathbb N^{n-d}\times\mathbb N^d\);
\(\ell(p)\) is the old weighted order and is zero on fiber parameters.
Order monomials by \(\ell(p)\), then \(|\beta|\), then a fixed
additive monomial well-order such as total-degree lexicographic order.
The combined order is additive and well-founded: below any bound only
finitely many positive-weight exponent vectors occur; tangential degrees
and then the final well-order settle the remaining ties.

Let \(\Gamma_j\) be the initials of the nonzero sections of \(R_j\).
Finite-dimensional elimination, one leading coefficient at a time,
gives
\[
 \#\Gamma_j=N_j,\qquad \Gamma_j+\Gamma_h\subset\Gamma_{j+h}.
 \tag{6}
\]
Indeed, elimination drops dimension at each step and takes exactly
\(N_j\) steps. Representatives of the resulting distinct initials are
a basis; the initial of any nonzero linear combination is the smallest
initial with nonzero coefficient. Multiplication of nonzero germs adds
initials. These facts do not require a finitely generated semigroup.

Setting the positive parameters to zero restricts a section to the
stratum. That restriction is pulled back from \(W\); in the completed
local rings it is a power series in the \(d\) tangent parameters alone,
with no fiber variables. A nonzero restriction therefore has old weight
zero and a pure tangential initial. A section in the kernel of restriction
has every term divisible by a positive parameter, so has strictly positive
old weight. Thus leading initials of the restriction image lift to pure
initials independently of the choice of lift. Eliminating inside the
image proves
\[
 \#G_0(h)\geq I_W(h),\qquad
 G_p(j)=\{\beta:(p,\beta)\in\Gamma_j\}.
 \tag{7}
\]
This is the precise image-to-initials bridge. It does not extend an
arbitrary section on \(W\), assume normality of \(W\), or require
uniform choices of the smooth point or local coordinates.

Put \(h_0=kd\). If the selected tangent parameters are \(s_i/s_0\),
then, for every \(\beta\in\{0,1\}^d\), the actual degree-\(h_0\) section
\(\prod_i s_i^{\beta_i}s_0^{d-|\beta|}\) has pure initial \((0,\beta)\).
The change of local frame is a unit with initial zero. Hence
\[
 \{0,1\}^d\subset G_0(h_0).
 \tag{8}
\]

### 3. Uniform weighted slice growth and the moment

For nonempty finite lattice sets \(A,C\subset\mathbb Z^d\), thicken
by the closed unit cube. The resulting finite unions have volumes
\(\#A,\#C\), since distinct cubes overlap only on their boundaries, and
\[
 (A+[0,1]^d)+(C+[0,1]^d)
   =A+C+\{0,1\}^d+[0,1]^d.
\]
Gardner's general Brunn--Minkowski theorem applies: both sets and their
sum are compact, nonempty, and measurable. It gives the correctly
oriented inequality
\[
 \#(A+C+\{0,1\}^d)^{1/d}\geq(\#A)^{1/d}+(\#C)^{1/d}.
 \tag{9}
\]

Define \(b_p(j)=(d!\#G_p(j))^{1/d}\), with value zero for an empty
slice. Apply (9) to \(G_p(j)\) and \(G_0(h-h_0)\), and use
(5)--(8). For every nonempty slice and every sufficiently large \(h\),
\[
 b_p(j+h)\geq b_p(j)+h-C'_d,\qquad C'_d=C_d+h_0.
 \tag{10}
\]
Its threshold can be taken to be
\(\max\{h_0+H_d,\lceil C'_d\rceil\}\). It is independent of \(j,p,W\),
the coordinates, and the model. The latter threshold also ensures a
nonnegative increment.

For this one test and reference degree \(m\), keep the weights
\(w_p=e^{-\ell(p)/m}>0\) fixed in all auxiliary degrees, and put
\[
 Q_j=\sum_p w_p\#G_p(j),\qquad
 B_j=\frac1{d!}\sum_p w_p b_p(j)^{d+1}.
 \tag{11}
\]
For \(b,\Delta\geq0\),
\((b+\Delta)^{d+1}\geq b^{d+1}+(d+1)\Delta b^d\).
Multiplying (10) by these fixed weights and summing the old nonempty
slices proves
\[
 B_{j+h}\geq B_j+(d+1)(h-C'_d)Q_j.
 \tag{12}
\]
All new slices have nonnegative contribution; none must be matched to
an old slice. This is precisely where degree-independent constants are
needed. `power_growth` and `weighted_growth` formalize the algebra for
arbitrary natural powers and arbitrary finite sets.

Here is a full proof of the moment comparison, rather than an assumed
moment bound. Given a finite \(A\subset\mathbb N^d\), write \(N=\#A\)
and \(b=(d!N)^{1/d}\). Let \(E=A+[0,1]^d\), and let
\(S=\{u\geq0:\sum u_i\leq b\}\). These sets have equal volume \(N\).
Writing \(r(u)=\sum u_i\),
\[
 \int_Er-\int_Sr
  =\int_{\mathbb R_{\geq0}^d}(1_E-1_S)(r-b)\geq0.
 \tag{13}
\]
The integrand is nonnegative both inside and outside \(S\).
The simplex has volume \(b^d/d!\) and
\(\int_Sr=d b^{d+1}/((d+1)d!)\), obtained by integrating the
level-simplex density \(r^{d-1}/(d-1)!\).
Also \(\int_Er=\sum_{\beta\in A}|\beta|+(d/2)N\).
Apply this to each slice, multiply by \(w_p\), and sum:
\[
 U_m+\frac d2 Q_m\geq\frac d{d+1}B_m,\qquad
 U_m=\sum_{(p,\beta)\in\Gamma_m}w_p|\beta|.
 \tag{14}
\]
The manuscript uses the weaker additive error \(dQ_m\); (14) retains
the exact cube-center contribution. Empty slices contribute zero.

### 4. First variation at fixed reference degree

Choose the basis of distinct initials in degree \(m\). Since the
initial order compares the old valuation first, this basis is adapted
to its filtration: at every threshold it has the maximal possible number
of basis vectors above that threshold. Its sorted values dominate those
of any other basis. Replacing the minimizing basis by this basis can
only decrease the objective, so minimality forces equality. The test
and its center have not changed. Consequently
\[
 Q_m=N_m f_{m,t}(x)e^{-A(v)/t}.
 \tag{15}
\]

Give the tangent parameters weight \(\epsilon\), the fiber parameters
weight \(\epsilon^2\), and leave the old positive weights unchanged.
For \(\epsilon>0\) this is an admitted test centered at \(y\), and
\[
 A(v_\epsilon)=A(v)+d\epsilon+(n-d-r)\epsilon^2.
 \tag{16}
\]
The extra coordinate divisors have discrepancy one at \(z\), since
all other relative canonical components were avoided.

For each section of this fixed finite basis with initial \((p,\beta)\),
\[
 v_\epsilon(s)=\ell(p)+\epsilon|\beta|+O(\epsilon^2).
 \tag{17}
\]
To see this for an infinite Taylor series, fix one term of least old
weight and least tangential degree. Only finitely many positive exponent
vectors occur below a fixed old-weight bound, giving a positive gap
above the least old weight in that bound. The chosen term excludes all
larger old weights for sufficiently small \(\epsilon\). Among terms of
least old weight, the tangential degrees are nonnegative integers; the
least one is the linear coefficient. A term achieving it supplies a
finite upper bound for the remaining fiber-degree contribution.
All added weights are nonnegative, giving the matching lower bound.
No bound on how small \(\epsilon\) must be is asserted uniformly in
\(m,W\), or the model.

Let \(F(\epsilon)\) be the objective of this fixed basis and perturbed
test. Specialization only in degree \(m\) gives
\(F(\epsilon)\geq f_{m,t}(y)\geq f_{m,t}(x)=F(0)\).
Using (16)--(17), the right derivative is
\[
 F'(0+)=\frac{e^{A(v)/t}}{N_m}
       \left(\frac dt Q_m-\frac1m U_m\right)\geq0.
 \tag{18}
\]
Every factor canceled here is positive. Thus the sign is
\[
 T_m:=\frac{U_m}{mQ_m}\leq\frac dt.
 \tag{19}
\]
This argument works for each test of each minimizing pair, even though
the adapted replacement basis may differ from its original basis.

### 5. Auxiliary-degree comparison and the order of limits

Suppose infinitely many degrees of a liminf sequence admit a
positive-dimensional minimizing pair. Choose one in each such degree.
Since there are only finitely many possible center dimensions, pass to
a subsequence with a fixed \(d>0\). All formulas so far apply separately
to these chosen tests, with the same constants \(C'_d,H_d,h_0\).

Fix an integer \(l\geq2\) **before** sending \(m\) to infinity, and
put \(j_i=\lfloor mi/l\rfloor\), \(1\leq i\leq l\).
The increments tend to infinity. Apply (12) successively, starting with
\(B_{j_1}\geq0\), and then use (14). This gives
\[
 T_m+\frac d{2m}\geq
 d\sum_{i=1}^{l-1}\frac{j_{i+1}-j_i-C'_d}{m}\frac{Q_{j_i}}{Q_m}.
 \tag{20}
\]
`growth_telescope` and `moment_telescope` prove this finite telescoping
algebra; division by the positive \(mQ_m\) gives (20).

For every positive auxiliary degree \(j\) with \(N_j>0\), the scaled
test \((j/m)v\) is still admissible at \(x\), with the same closed
center \(W\). Its section orders divided by \(j\) are the old orders
divided by \(m\), and its discrepancy is \(jA(v)/m\). Applying the
definition of the infimum to the basis with initials \(\Gamma_j\) gives
\[
 Q_j\geq N_j f_{j,t}(x)e^{-jA(v)/(mt)},\qquad
 \frac{Q_j}{Q_m}\geq
 \frac{N_j}{N_m}\frac{f_{j,t}(x)}{f_{m,t}(x)}
 e^{(1-j/m)A(v)/t}.
 \tag{21}
\]
This is a comparison **at \(x\)**. Simultaneous specialization in
infinitely many auxiliary degrees is neither used nor assumed.

For fixed \(i,l\), Hilbert asymptotics imply
\(N_{j_i}/N_m\to(i/l)^n\). Since \(j_i\to\infty\),
\(c=\liminf_j f_{j,t}(x)>0\), and \(f_{m,t}(x)\to c\),
\[
 \liminf_m\frac{f_{j_i,t}(x)}{f_{m,t}(x)}\geq1.
 \tag{22}
\]
Explicitly, for every \(0<\eta<1\), the numerator is eventually at
least \(c(1-\eta)\) and the denominator at most \(c(1+\eta)\);
then let \(\eta\downarrow0\). The degrees \(j_i\) need not themselves
belong to any minimizing subsequence.

Finally \(A(v)\geq a\), so the exponential in (21) is at least
\(e^{(1-j_i/m)a/t}\). Each sum in (20) has finitely many eventually
nonnegative terms. Taking its liminf and using (19) proves, for
**every fixed integer** \(l\geq2\),
\[
 \frac dt\geq
 \frac dl\sum_{i=1}^{l-1}(i/l)^n e^{(1-i/l)a/t}.
 \tag{23}
\]
No upper discrepancy bound, convergent sequence of models, fixed center,
or uniform Taylor differentiation radius is needed for this passage.
The upper discrepancy bound in the upstream proposition is not used by
the point-center argument once attainment and the positive lower bound
are available.

### 6. The universal limiting contradiction, with an exact error bound

One can now refine the partition: continuity makes the right side of
(23) tend to \(d\int_0^1s^n e^{(1-s)a/t}\,ds\).
This is exactly the manuscript's order \(m\to\infty\) at fixed \(l\),
then \(l\to\infty\). Its original choice using \(a/(n+1)\) works
because \(t<n+1\) and the integrand is strictly larger than \(s^n\)
on \(0<s<1\).

There is a more quantitative closure that does not assume any
Riemann-sum convergence. Define
\[
 S_q(l)=\frac1l\sum_{i=0}^{l-1}(i/l)^q.
 \]
For every natural \(q\) and every \(l\geq1\), monotone integral
comparison for \(x^q\) gives
\[
 \frac1{q+1}-\frac1l\leq S_q(l)\leq\frac1{q+1}.
 \tag{24}
\]
For \(u\geq0\), use \(e^z\geq1+z\) term by term and apply both sides
of (24):
\[
 \begin{split}
 R_n(u,l)&:=\frac1l\sum_{i=0}^{l-1}(i/l)^n e^{(1-i/l)u}\\
 &\geq (1+u)S_n(l)-uS_{n+1}(l)\\
 &\geq \frac1{n+1}+\frac{u}{(n+1)(n+2)}-\frac{1+u}{l}.
 \end{split}
 \tag{25}
\]
For \(n\geq1\), the zero-index summand vanishes, matching (23)
exactly. These estimates, including monotone integral comparisons
for arbitrary \(q\), are proved in Lean, not inferred from tested
dimensions.

Apply (25) to (23) with \(u=a/t\). Since (23) holds for every
\(l\geq2\), the Archimedean property removes the explicit \(1/l\)
error and gives
\[
 \frac1t\geq\frac1{n+1}+
              \frac{a}{t(n+1)(n+2)}.
 \tag{26}
\]
All denominators are positive. Exact multiplication reduces this to
\[
 t+\frac{a}{n+2}\leq n+1,
 \tag{27}
\]
contradicting (1). Thus only finitely many selected degrees have any
positive-dimensional minimizing pair. A nonzero test has nonempty
closed center containing \(x\); all remaining centers must be
\(\{x\}\). This proves the theorem.

### 7. Structural slope version

The same proof works for a multiplicative graded system with
one-dimensional Taylor leaves, \(N_j\sim c_Xj^n\) with \(c_X>0\),
the same bounded-degree cube, and a **uniform** pure-slice bound
\(b_0(h)\geq\sigma h-C\), for \(\sigma>0\).
Replace (10) by
\(b_p(j+h)\geq b_p(j)+\sigma h-(C+\sigma h_0)\).
The limit of the increments in (20) is then \(\sigma/l\).
Consequently persistent positive-dimensional minimizers imply
\[
 \sigma\left(t+\frac{a}{n+2}\right)\leq n+1.
 \tag{28}
\]
The precise abstract hypotheses are multiplicativity, this uniform
pure-slice growth and cube, nonnegative transverse weights independent
of auxiliary degree, the tangent-variation upper bound, the scaled-test
comparison (21), and the positive liminf subsequence. Equation (28)
does not assume the desired lower moment: (9)--(14) and (20)--(25)
derive it from these hypotheses.

This generalization and the explicit discrepancy obstruction are
quantitative consequences of the verified mechanism. They are not a
claim that \(\sigma=(L^d\cdot W)^{1/d}\) can be used uniformly for
unbounded-degree moving centers. Only \(\sigma=1\) was established
geometrically above.

## Certification boundary

`Main.lean` proves the arbitrary-dimension weighted growth algebra,
finite moment telescoping, explicit exponential partition lower bound,
Archimedean error removal, obstruction (28), and parameter existence.
`statement_fidelity.md` lists every declaration, quantifier, and unformalized
geometric passage. In particular Lean does not assume or prove the upstream
manuscript assertions, and successful compilation is not advertised as a
formal proof of all the geometry.

`verify.py` replays the exact Jacobian polynomial reconstruction,
denominator-cleared identities, the finite regression fixtures, and the
recorded official compiler result. The finite fixtures are only adversarial
regressions; the arbitrary-dimension theorem is supported by the proof above
and the universally quantified Lean declarations, not by their exhaustion.
Independent source attribution, mathematical review of the unformalized
passages, and publication-level novelty assessment remain Reviewer work.

A bounded literature search for the specific quantitative criterion returned
the manuscript and secondary descriptions of it, but no independently
established source for that criterion. This does not establish novelty or
justify `novelty_status=verified_new`. No such status is claimed here.

## Recorded result and reproduction

The official Lean 4.31.0 run returned `exit_code=0`, `proof_holes=[]`,
and `audit_exit_code=0`. Both printed axiom lists contain only
`propext`, `Classical.choice`, and `Quot.sound`.
The successful claim-bound archive is
`certificates/PC9000038-a85c81f177e68679.json`; the official output is
`lean_verify.json`. The ledger derives `closed_kernel` for **PC9000038
only**. It does not derive kernel closure for the geometric bridge.
Earlier unsuccessful compiler attempts remain inconclusive historical
records, not mathematical evidence.

The exact replay passed and generated `exact_certificate.json`.
Its regression fixtures check 773 finite simplex moments, 282 finite
cube-sum inequalities, 160 rational polynomial partition estimates,
and 39 weighted slice-growth instances. They are explicitly labeled
regressions rather than proofs of the universal claims.
The admissible \(\mathbb P^2\) fixture has
\[
 T_{12}=\frac{91477}{196610},\qquad
 \frac13-T_{12}=-\frac{77821}{589830}<0.
 \]
It confirms the variation sign by exhibiting a descent direction for
that particular positive-center test. The test is **not** minimizing,
and is not offered as a counterexample to any manuscript proposition.

From any working directory, the saved exact evidence can be replayed with
the absolute path to this script; from the campaign root:

```bash
python3 research/fujita_point_center/verify.py
```

For a fresh real compiler run rather than replay of the archived verdict:

```bash
python3 research/fujita_point_center/verify.py --compile
```

That flag calls the authorized interpreter, the official claim-bound Lean
verifier, and both official structural checks. It fails explicitly on a
compiler, axiom-audit, source-freshness, or structural failure. No dependency
installation or new Lake workspace is needed. The installed verifier takes
the Lean source as a positional argument; the equivalent direct command is

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/fujita_point_center/Main.lean \
  --statement-fidelity research/fujita_point_center/statement_fidelity.md \
  --claim PC9000038 --project-root .
```

The authoritative checked project root is
`campaigns/9000038`.
The latest `math_state check` and `proof_graph_check check` both exited
zero there; `validation.json` records those exact statuses.

Independent review has not been performed by the Engineer. The
`BM-compact` assumption still requires independent citation attribution;
the assumption's filer has read the primary statement and supplied
`gardner_excerpt.txt`, but did not file a supporting attribution under
another name. The official attribution command archives outside this
mission's writable paths, so the Engineer did not create an unauthorized
`research/literature/` archive. The host-dispatched Reviewer must handle
that delivery gate within its authorized scope.

The overall Fujita claim, the upstream manuscript dependencies, subsequent
isolation and lifting, significance, and novelty are not certified by this
Engineer result. The campaign is not declared complete.
