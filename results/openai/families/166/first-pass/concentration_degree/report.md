# Evaluation-flat parameter degree and the exceptional case

**Mathematical result.** Under the exact hypotheses of `conc:degree`, its
dimension, degree and exceptional-family assertions hold. The proof below
also gives a dimension-independent constant 2 for the actual incidences
constructed in `conc:rulings`, a sharp aggregate bound for all dominating
finite ruling families, and an explicit classification of the exceptional
hypersurfaces as shifted Pfaffian cylinders.

This is a proof in ordinary algebraic geometry, with two small universal
algebraic cores in Lean and an exact symbolic replay. It is not a
formalization of the geometric theorem. Independent review, attribution of
the recorded external propositions, and assessment of novelty remain
outstanding. In particular, this result does not certify `conc:rulings`,
`conc:theorem`, or the distinct-distances theorem.

## Scope and source facts

The target is Proposition `conc:degree`, not the distinct-distances theorem.
All source references below refer to the staged September 23, 2026 manuscript,
under `research/openai_manuscript/The-higher-dimensional-Erdos-distinct-distances-conjecture-September-23-2026/build/`.

* `sections/introduction.tex`, `thm:main`, asserts the constant-factor
  higher-dimensional distinct-distances conjecture. This assertion is not an
  established input to this audit.
* `sections/concentration.tex`, lines 14--42, fixes complex, reduced varieties,
  affine degree via projective closure, `S = wedge^2 E*`, `r = e-1`,
  `s0 = binomial(e-1,2)`, and `F_[v:y] = {z : zv=y}`, with `v != 0`.
* `conc:rulings`, lines 282--306, supplies the working open set and the
  incidences. Its existence and degree bounds are a separate manuscript
  dependency. In particular, its incidences have full parameter fibers
  `F_lambda intersect Omega`, and point fibers are finite and smooth or
  affine lines; the affine-line case has codimension one.
* `conc:degree`, lines 496--515, claims `dim Lambda = h+j`,
  `deg Lambda <= C_e deg V`, and that `j=1` forces a maximal isotropic
  linear `P^(e-1)`.
* `conc:theorem` uses this proposition in both specifications. Those
  specifications feed `red:global-concentration` and
  `red:local-concentration`, not conversely.

The intersection-theoretic inputs are proper pushforward and the projection
formula, the projective bundle formula, and the Whitney formula for Chern
classes on arbitrary complex varieties, including singular ones. They are
standard results, not results newly proved by a finite computation.

The primary Stacks Project texts at Tags `01OA`, `02TV`, and `02TZ` were
opened. Stacks uses **quotient** projective bundles, whereas the manuscript
uses **lines**. Thus `P_lines(U) = P_Stacks(U*)`; the pushforward series is
`c_t(U)^(-1)`, not `c_(-t)(U)^(-1)`. A web-search summary misstated the Stacks
convention; it is not used as evidence.

A targeted literature search found no primary source stating the precise
evaluation-flat/Pfaffian-cylinder classification. This is not a novelty
certificate. No external classification theorem will be assumed.

There is no inherited retired mathematical route in the current ledger.
Finite tests, a failed search for a counterexample, and a single large
degree ratio would not prove or refute the asserted uniform degree bound.

## Evidence boundary

The general geometric argument and any extension belong in this report.
`verify.py` will certify explicitly identified algebraic identities and exact
examples; it will not purport to certify all complex varieties by sampling.
No independent Reviewer verdict has yet been obtained.

## 1. A general incidence-degree inequality

We prove a slightly more general statement. Let an irreducible family of
evaluation flats, with projective parameter closure \(Y\subset\mathcal Q\),
sweep an irreducible \(V\subset S\) of dimension \(k=s_0+h\), where
\(1\le h\le e-2\). Suppose the full point incidence has generic fiber
dimension \(j\). Let \(\delta\) be the degree of that geometric generic
fiber in \(\mathbf P(E)\), **including its cycle multiplicities**. Then
\[
 \dim Y=h+j,\qquad \deg Y\le\delta\deg V.                 \tag{1}
\]
Here the full incidence contains the whole flat for each parameter.
The controlled incidence in the question has this saturation property
on its working open set. Arbitrary subfamilies need not have bounded
\(\delta\); the bound on \(\delta\) is a separate issue.

Here is the compactification, including the boundary. On
\(P=\mathbf P_{\rm lines}(E)\), write \(L=\mathcal O(-1)\),
\(Q=E/L\), and \(A=Q^*\otimes L^*\). Evaluation is a surjection
\[
 0\longrightarrow K=\bigwedge^2 Q^*
 \longrightarrow S\otimes\mathcal O_P\longrightarrow A
 \longrightarrow0 .
\]
Put \(B=\mathbf P_{\rm lines}(\mathcal O\oplus A)\).
Tensoring by \(L\) gives \(B=\mathbf P_{\rm lines}(L\oplus Q^*)\),
so the inclusion \(L\oplus Q^*\subset (E\oplus E^*)\otimes\mathcal O_P\)
defines a morphism
\[
 \mu:B\longrightarrow\mathcal Q,\qquad
 (L,[t:\psi])\longmapsto[tv:\psi(v)] .
\]
It is an isomorphism where \(v\ne0\). Over \([0:y]\) its fiber is
\(\mathbf P(\ker y)\), not a single point.

Let \(T\) be the tautological line in the **first** presentation of \(B\).
In the inverse image of \(T\) under
\[
 (\mathbb C\oplus S)\otimes\mathcal O_B
 \longrightarrow\mathcal O_B\oplus A
\]
we obtain a locally free bundle \(U\) of rank \(s_0+1\) and an exact
sequence \(0\to K\to U\to T\to0\). Set
\[
 a=c_1(L^*),\quad b=c_1(T^*),\quad
 \ell=\mu^*c_1(\mathcal O_{\mathcal Q}(1))=a+b .
\]
The last equality follows because the second tautological line is
\(T\otimes L\). Only \(a\) and \(\ell\), not \(b\), are globally
generated. Indeed, on a positive-dimensional fiber of \(\mu\) over
\([0:y]\), \(\ell=0\) while \(b=-a\).

Let \(\widetilde Y\) be the closure of the inverse image of the
nonboundary parameters in \(B\), and let
\(X=\mathbf P_{\rm lines}(U|_{\widetilde Y})\).
The affine incidence is dense in \(X\), hence its proper point map has
image exactly \(\overline V\). For the controlled incidence this also
follows directly by comparing dimensions: its inclusion in \(X\) is
locally closed, injective with the evident inverse, and has the same
dimension. Write \(f:X\to\overline V\) for the point map and
\(\xi=f^*c_1(\mathcal O_{\overline V}(1))\).

For \(t\ne0\) the fiber of \(X\to\widetilde Y\) maps to
\(\{[x_0:z]:zv=x_0y\}=\overline{F_\lambda}\).
For \(t=0\), membership of \((x_0,z|_L)\) in \(\mathbb C(0,\psi)\)
forces \(x_0=0\). Thus **no boundary parameter lies above an affine
point** \([1:z]\). The complete point fiber over such a point sits in
\(\mathbf P(E)\) via \([v]\mapsto[v:zv]\), and \(\ell\) restricts to
its ordinary hyperplane class.

The fiber dimension theorem gives \(\dim Y=h+j\). Proper pushforward
and the projection formula give
\[
 f_*(\ell^j\cap[X])=\delta[\overline V],\qquad
 \int_X\ell^j\xi^k=\delta\deg V.                         \tag{2}
\]
This computes the coefficient on the geometric generic fiber.
Components whose images have smaller dimension push to zero; fibers
over infinity are not counted as additional generic components.
These are Chow-cycle statements on integral varieties, and require no
smoothness of \(\widetilde Y\), \(X\), or \(\overline V\).

## 2. The sign and positivity calculation

For lines, the projective bundle relation and pushforward recurrence give
\(\pi_*(\xi^{s_0+h})=s_h(U)\), where \(s_t(U)=c_t(U)^{-1}\).
One can obtain this directly from Stacks' quotient convention by using
the dual bundle: \(P_{\rm lines}(U)=P_{\rm Stacks}(U^*)\).
This conversion is essential; omitting it reverses the relevant signs.

The dual tautological sequence, tensored with \(L^*\), is
\[
 0\to Q^*(1)\to E^*\otimes\mathcal O(1)\to\mathcal O(2)\to0.
\]
The Whitney formula therefore gives
\[
 s_t(U)=\frac{(1+at)^e}{(1+2at)(1-bt)}
       =\frac{(1+at)^e}{(1+2at)(1+(a-\ell)t)}.             \tag{3}
\]
Expanding the last factor as a geometric series in
\(\ell t/(1+at)\) yields
\[
 s_h(U)=\sum_{i=0}^h c(e-1-i,h-i)a^{h-i}\ell^i,\qquad
 c(p,u)=[z^u]\frac{(1+z)^p}{1+2z}.                       \tag{4}
\]
This is an identity of formal power series followed by coefficient
extraction, not an assertion that \(b\) is nef.

For all \(p,u\ge0\), the exact identity
\((1+z)^2=(1+2z)+z^2\) gives
\[
 c(p,0)=1,\quad c(p,1)=p-2,\quad
 c(p+2,u+2)=\binom p{u+2}+c(p,u).                       \tag{5}
\]
Induction on \(u\) now proves \(c(p,u)\ge0\) whenever \(p\ge u+1\):
the first two cases are explicit, and the two-step recurrence reduces
both indices by 2. `coefficient_nonnegative` proves precisely this
unrestricted induction. In (4) the needed inequality is \(e-1\ge h+1\),
and the coefficient of \(\ell^h\) is 1. Since \(a,\ell\) are globally
generated, all their mixed top intersection numbers on \(\widetilde Y\)
are nonnegative. By (2)--(4) and the birationality of \(\mu|_{\widetilde Y}\),
\[
 \deg Y=\int_{\widetilde Y}\ell^{h+j}
 \le\int_{\widetilde Y}\ell^j s_h(U)
 =\int_X\ell^j\xi^k=\delta\deg V ,
\]
proving (1). The bound is valid for singular parameter closures.

For the given controlled incidence, the complement of a dense open part
in \(X\) has dimension at most \(k+j-1\). Its components dominating \(V\)
have generic fiber dimension at most \(j-1\); the others miss a general
point. Consequently they cannot change the generic top fiber cycle.
The smooth finite point fibers give \(\delta=O_e(1)\) when \(j=0\);
when \(j=1\), the closure of the normalized affine line is a reduced
projective line and \(\delta=1\). This already proves the degree assertion
of `conc:degree`, independently of the strengthening in Section 5.

## 3. A singular-skew-pencil criterion

We need the following exact, all-dimensional linear algebra statement.
Let \(U_0\) be an \(r\)-dimensional complex vector space and
\(\Theta\subset U_0\oplus U_0^*\) an \(r\)-plane. Then
\[
 \bigl[(\alpha,\beta)\mapsto\beta-D\alpha
       \text{ is singular for every alternating }D\bigr]
\]
holds if and only if \(\Theta\) is totally isotropic for
\((\alpha,\beta)\mapsto\beta(\alpha)\) and
\(\dim\operatorname{pr}_{U_0}\Theta\) is odd.

Here is a proof, including the easily missed unequal-subspace case.
Put \(B_0=\Theta\cap U_0^*\), \(A_0=\operatorname{pr}_{U_0}\Theta\),
\(H_0=B_0^\perp\), and \(p=\dim A_0=\dim H_0\). The quotient of
the displayed map by its identity action on \(B_0\) is
\[
 C-D|_{A_0\times H_0}:A_0\longrightarrow H_0^* .
\]
For \(p=0\) it cannot be singular. If \(A_0\ne H_0\), write their
intersection as a \(q\)-space, \(q<p\), and choose bases consisting
of the same \(q\) common vectors followed by separate vectors.
The restriction of an ambient alternating form is arbitrary except
that its common \(q\)-square block is alternating. There is an
invertible such restriction:

* for even \(q\), use symplectic blocks on the common part and an
  identity matrix between the separate parts;
* for odd \(q\), pair the first \(q-1\) common vectors symplectically,
  use the block \(\left(\begin{smallmatrix}0&1\\1&0\end{smallmatrix}\right)\)
  on the last common index and one separate index on each side, and
  use an identity on the remaining separate indices.

The two off-diagonal 1's in the second construction concern different
pairs of independent ambient vectors; they do not violate
antisymmetry. Each prescription extends to the ambient space.
For this \(D_0\), \(\det(C-tD_0)\) has nonzero leading coefficient,
a contradiction. Hence \(A_0=H_0\).

If \(p\) is even a nondegenerate alternating \(D_0|_{A_0}\) gives the
same contradiction. Thus \(p\) is odd. If \(C\) is not alternating,
choose \(x\) with \(C(x,x)\ne0\) and take \(D_0\) with kernel
\(\mathbb Cx\) and a symplectic form on a complement. The coefficient
of \(t^{p-1}\) in \(\det(C-tD_0)\) is
\[
 C(x,x)\det(D_0|_{A_0/\mathbb Cx})\ne0 .
\]
This includes \(p=1\), using the empty determinant 1. Thus \(C\) is
alternating and \(B_0=A_0^\perp\), proving isotropy of \(\Theta\).
Conversely, those conditions make the quotient pencil alternating of
odd size, so its determinant always vanishes. No classification of
matrix pencils or of null subvarieties has been cited.

## 4. The affine-line exception is linear

Now let \(j=1\). The incidence hypothesis gives \(\operatorname{codim}V=1\),
hence \(h=e-2\), and Section 1 gives \(\dim\Lambda=r\).
Fix a general smooth \(\lambda=[v:y]\) and \(z_0v=y\). Set
\(U_0=E/\mathbb Cv\). The tangent space to \(\mathcal Q\) identifies with
\(U_0\oplus U_0^*\) by
\[
 (\dot v,\dot y)\longmapsto
 (\alpha,\beta)=(\dot v\bmod v,\dot y-z_0\dot v).
\]
It is well-defined modulo \((v,y)\), and its quadratic form is
\(\beta(\alpha)\). At \(z=z_0+D\) on the same flat, differentiating
the incidence equation gives, modulo \(K_v\),
\(\dot z\,v=\beta-D\alpha\).
All parameter tangents lift in the full affine incidence bundle.
Its point image lies in \(V\), so the induced \(r\)-square pencil has
rank below \(r\) on a dense set of \(D\). Polynomiality makes its
determinant identically zero for every alternating \(D\).
Section 3 proves that \(T_\lambda\Lambda\) is maximal null.

For completeness, maximal null tangency here forces linearity; it
does not merely describe an infinitesimal test. A quadric chart has
the form
\[
 x\longmapsto[e_0+x-q_0(x)f_0],
\]
with tangent quadratic form \(q_0(dx)\). At a smooth null point choose
coordinates \(x=(u,w)\), \(q_0(u,w)=u\cdot u-w\cdot w\), with tangent
plane the diagonal. The holomorphic inverse function theorem writes
the subvariety locally as \(w=F(u)\). Null tangency says
\(F_i\cdot F_j=\delta_{ij}\).

For \(T_{ijk}=F_{ij}\cdot F_k\), commuting mixed partials gives symmetry
in the first two indices; differentiating the Gram identities gives
antisymmetry in the last two. The tensor theorem
`symmetry_skew_vanish` shows \(T=0\) over any characteristic-zero field,
in particular over \(\mathbb C\). Because the \(F_k\) have Gram matrix
the identity, they span and \(F_{ij}=0\). Thus \(F\) is affine locally.
On the resulting affine null plane, \(q_0\) is affine-linear, so the
quadric-chart lift is affine-linear too. Its projective closure is a
linear isotropic \(\mathbf P^r\). It contains a nonempty smooth
analytic open subset of \(\Lambda\); irreducibility makes that subset
Zariski dense. Equality follows from the dimension \(r\).

Sections 1--4 prove every assertion of `conc:degree` under its exact
incidence hypotheses.

## 5. Dimension-independent and aggregate degree bounds

There is a useful improvement over the unspecified \(C_e\).
In a normalized chart \(v_1=1\), a basis of \(K_v\) consists of
\[
 (\varepsilon_i-v_i\varepsilon_1)\wedge
 (\varepsilon_j-v_j\varepsilon_1),\qquad i,j\ne1.
\]
The putative quadratic term is zero because
\(\varepsilon_1\wedge\varepsilon_1=0\). Thus these basis vectors are
**affine-linear** in \(v\).

The tangent-direction system has vector solution space of dimension
at most 2. If its dimension is at most 1, any nonempty normalized
point fiber has one point. If it is 2, the chart is
\(v=b(z)+\tau a(z)\). For fixed \(\tau\), each first horizontal
tangency test in the actual `conc:rulings` construction has the form
\[
 d_{B_\alpha(b+\tau a)}b_i+
 \tau\,d_{B_\alpha(b+\tau a)}a_i ,
\]
which has degree at most 2 in \(\tau\). If a test is nonzero, its
common-root set has at most 2 points, even before the second test.
If all tests vanish identically, the horizontal translations preserve
the direction incidence and integrate to whole contained flats:
the incidence is the affine-line case, not a finite component.
Explicitly, for fixed \(v\) each horizontal vector \(B_\alpha(v)\)
is constant. Its local flow is translation by \(tB_\alpha(v)\);
uniqueness of holomorphic flows keeps it in the incidence. Composing
these flows fills an analytic open part of \(z+K_v\), so every
polynomial defining \(V\) vanishes on the whole flat.
It follows that each actual finite incidence has \(\delta\le2\).
For codimension at least 2 the tangent solution space has dimension
at most 1, giving \(\delta\le1\). Together with (1),
\[
 \deg\Lambda\le2\deg V
 \quad\text{and, if }\operatorname{codim}V\ge2,\quad
 \deg\Lambda\le\deg V.                                  \tag{6}
\]
For \(j=1\), of course, \(\deg\Lambda=1\).

This argument also bounds the **sum** of the degrees of the distinct
dominating parameter components when there is no affine-line
component:
\[
 \sum_i\deg\Lambda_i\le2\deg V,                          \tag{7}
\]
and by \(\deg V\) in codimension at least 2. To see the required
counting point carefully, take the full reduced contained-flat
incidence in \(V\times\mathbf P(E)\). It is algebraic: the
coefficients of the restrictions of generators of \(I(V)\) to the
kernel bundle must all vanish. Ignore components not dominating \(V\).
If a generic tangent pencil has all first tests zero, it gives a
dominating line component. Otherwise, a general normalized chart
containing all its finitely many generic directions shows that the
**total** generic point-fiber degree is at most 2. Distinct parameter
components have disjoint generic point-fiber points: their intersection
has parameter dimension at most \(h-1\), whose whole-flat incidence
has dimension at most \(k-1\). Thus their individual \(\delta_i\)
sum to at most 2, and summing (1) gives (7).
Duplicated chart presentations are counted only once.

The factor 2 in (7) is sharp already for \(e=3\). Use
\[
 Z=\begin{pmatrix}0&x&y\\-x&0&z\\-y&-z&0\end{pmatrix},
 \qquad V=\{z=xy\}.
\]
Its two rulings, \((x,y,z)=(t,u,tu)\) and \((u,t,tu)\), have
parameters
\[
 [t:-1:0:-t:-t^2:0],\qquad[t:0:1:t:0:-t^2].
\]
Each closure is a smooth conic, so their degrees sum to 4, while
\(\deg V=2\). There are exactly two directions through every point:
substituting a line with direction \((a,b,c)\) gives the conditions
\(ab=0\) and \(c=ay+bx\). The projective quadric is smooth, so \(V\)
is irreducible; both point fibers are singletons and both complete
parameter fibers are the specified affine lines. Every nonzero
kernel direction has dimension \(s_0=1\). Thus this example checks
the hypotheses, not just a numerical degree ratio.

For the first parameter conic the homogeneous map is
\([s:t]\mapsto[st:-s^2:0:-st:-t^2:0]\).
The elimination certificate gives \(a+c=0,\ bd-c^2=0\), where
\((a,b,c,d)=(v_1,v_2,y_1,y_2)\). At \(s=0\) it includes the genuine
boundary point \([0:0:0:0:-1:0]\); this is not an extra affine flat.
The independent SymPy replay verifies the exact Jacobian ideal in
both directions.

## 6. Complete description of the exceptional hypersurfaces

The exceptional case admits an explicit converse classification.
There is an even-dimensional subspace \(A_1\subset E\),
\(\dim A_1=2m\ge2\), and an alternating \(C\in\bigwedge^2 A_1^*\)
such that
\[
 V=\{z\in S:\operatorname{Pf}(z|_{A_1}-C)=0\},\qquad
 \deg V=m,                                             \tag{8}
\]
and
\[
 \Lambda=\mathbf P(T_1),\quad
 T_1=\{(v,y):v\in A_1,\ y|_{A_1}=Cv\}.                  \tag{9}
\]
Conversely every (8) satisfies the stated incidence hypotheses on
a suitable dense open set and has parameter closure (9).

To prove necessity, let \(\mathbf P(T_1)\) be the maximal isotropic
space just obtained, and put \(A_1=\operatorname{pr}_E T_1\).
The vertical kernel is \(A_1^\perp\), by isotropy and dimension.
The restrictions to \(A_1\) of lifts of its vectors therefore define
an alternating map \(C:A_1\to A_1^*\), giving (9).
The union of all its nonboundary flats is precisely
\[
 \{z:\ker(z|_{A_1}-C)\ne0\}.                            \tag{10}
\]
Indeed a nonzero vector in that kernel gives \((v,zv)\in T_1\),
and the converse is immediate. Section 1 ensures that every such
flat is contained in \(V\), including those obtained by parameter
closure: the full projective incidence has closed point image
\(\overline V\). Dominance gives the opposite inclusion.
If \(\dim A_1\) were odd, every alternating matrix on it would be
singular, making (10) all of \(S\), a contradiction. It cannot be
zero because there are nonboundary parameters. Hence
\(\dim A_1=2m\ge2\), and (10) is (8).

Here are the degree and irreducibility details rather than an appeal
to a classification theorem. Restriction to \(A_1\) is surjective;
extend \(C\) to \(E\) and translate to reduce to the generic
\(2m\)-square alternating matrix. Its Pfaffian is a homogeneous
polynomial of degree \(m\), with the product of adjacent-pair entries
having coefficient 1. Alternating Gaussian congruence puts every
matrix of a given rank into the same symplectic-block normal form:
choose vectors with nonzero pairing, scale their pairing to 1, split
off their nonsingular two-plane by its orthogonal complement, and
induct on the remaining dimension.
The rank \(2m-2\) locus is the orbit of
\(\operatorname{diag}(0_2,J,\ldots,J)\) under the irreducible group
\(\operatorname{GL}_{2m}\). All lower ranks are limits of it by
scaling blocks, so its closure is the entire singular-matrix locus,
which is therefore irreducible. At that normal form the derivative
with respect to the first block entry is 1; thus the Pfaffian has
multiplicity one, is irreducible, and its reduced hypersurface has
degree \(m\). A surjective linear pullback adds free affine
coordinates and preserves both irreducibility and degree.

For the converse use the smooth open where \(z|_{A_1}-C\) has rank
\(2m-2\). Its kernel is a rank-2 vector bundle. Choose a normalized
coordinate nonzero on this kernel and shrink the open set so it
remains so. The kernel vectors with that coordinate 1 are an
affine-line bundle; they give a smooth irreducible closed ruling
incidence dominating this open. For \(v\) in the kernel, every
\(z'\in z+K_v\) has \((z'|_{A_1}-C)v=0\), so the **whole**
evaluation flat is contained in \(V\). The full parameter fibers
are exactly its intersections with the working open. Their dimension
is \(s_0\); consequently the parameter image has dimension
\(n-s_0=r\), and its closure, contained in the \(r\)-plane (9),
equals that plane. A single defining equation of degree \(m=\deg V\)
provides the codimension-one approximate equation required in
`conc:rulings`. Rank and coordinate conditions can be imposed by
nonzero minors of bounded multiples of this degree.

Thus the classification verifies all hypotheses and all conclusions,
not just the familiar homogeneous example with \(A_1=E,C=0\).

## Replay and remaining review boundary

Run from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/concentration_degree/verify.py
```

The certificate distinguishes universal proofs from bounded algebra
checks. It includes 55 Segre expansions, 1,023 recurrence checks, exact
kernel bases and quadratic first tests, 36 unequal-subspace skew
restrictions, odd-pencil coefficient identities in sizes 1, 3 and 5,
Pfaffian identities and whole kernel charts in sizes 2, 4 and 6, and the
sharp two-ruling example. These finite checks support, but do not
replace, the general arguments above.

The Jacobian adapter returned `COMPUTED`, not a timeout or unknown
result. Its exact request and typed response, with protocol
`2025-11-25` and server `0.14.0`, are retained in the two dedicated
JSON files. The same ideal is independently recomputed by `verify.py`.

The real Lean 4.31.0 compiler and axiom audit both returned exit code 0
with `proof_holes=[]`. The official recorder attached the immutable
certificate
`certificates/C166_COEFF-788f340e51006c37.json` to `C166_COEFF`.
Both declarations in `Main.lean` were compiled, but the mechanical
ledger record is attached only to that named claim; no mechanical
geometric verdict is asserted. An initial run also compiled but refused
ledger recording because the fidelity reader did not recognize fully
qualified declaration names. Adding the bare names corrected that
documentation compatibility issue; the subsequent actual compiler run
and current-source evidence check passed.

The geometric proposition still needs independent human/mathematical
review. The source attributions in `literature.txt` need a reader other
than the filer before the Reviewer can clear delivery. No false
manuscript assertion has been established, so no `F_*` refutation
judgement is appropriate. The classification and sharp aggregate
bound extend what is explicitly stated in the staged proposition;
their literature novelty and publishability are **not established**
by the targeted search. The overall exploratory campaign remains open.
