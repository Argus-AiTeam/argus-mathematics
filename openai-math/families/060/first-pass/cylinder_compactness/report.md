# Proper holomorphic cylinders: an explicit target-slab theorem

## Result and scope

We prove the universal estimate asserted in `cylinder:estimate`, not just a
finite collection of Fourier examples. On the full cylinder the conclusion
can be strengthened from \(CM(1+E)\) to \(CME\). We give explicit constants
and replace the manuscript's analytic-cycle compactness step by a direct
Stokes argument. The replacement applies even when the source domain has
missing points. No Bishop or Harvey--Shiffman compactness theorem is assumed.

The proof also verifies that the two cylinder applications preserve the
common area exponent \(A\). The conclusion that the manuscript's divisor
components are compact is **conditional on the upstream premises listed in
Section 7**. In particular this is neither a proof nor a refutation of the
Global Spherical Shell conjecture. No false manuscript assertion is claimed
by this report. Independent Reviewer acceptance, including significance and
novelty assessment, remains required.

The earlier result available at scope was the manuscript's non-effective
small-energy argument. The mathematical improvement here is an explicit
graph-filling threshold and a complete proper-domain proof that does not
rely on the inaccessible compactness citation. It also gives the stronger
linear-energy bound for intervals of arbitrary length, in any target with
the uniform chart geometry below, not only a compact-quotient target.

## 1. Statement with explicit constants

Let \(Y\) be a Hermitian complex surface. Suppose every \(p\in Y\) has a
holomorphic chart
\[
 \Phi_p:U_p(4r)\longrightarrow B_{\mathbb C^2}(0,4r),
 \qquad \Phi_p(p)=0,
\]
where \(r>0\) is fixed. Write \(U_p(s)=\Phi_p^{-1}(B(0,s))\).
On each chart suppose tangent norms satisfy
\[
 K^{-1}|d\Phi_p(\zeta)|\leq|\zeta|_Y
       \leq K|d\Phi_p(\zeta)|,\qquad K\geq1.
\]
Let \(h:Y\to\mathbb R\) be smooth with \(|dh|\leq H\).
No compact quotient or properness of \(h\) is needed for this theorem.
The manuscript's finite nested coordinate atlas supplies these hypotheses.

Use the source cylinder \(\mathcal C=\mathbb C/(2\pi i\mathbb Z)\), coordinate
\(v=t+i\theta\), strips \(S_j=[j,j+1]\times S^1\), and thickenings
\(C_j^s=(j-s,j+1+s)\times S^1\). Choose an integer \(P\geq4K^2\), and set
\[
\begin{split}
 R_s&=2P+8, &N&=R_s+1=2P+9, &Q&=2R_s+2=4P+18,\\
 \epsilon_*&=\frac{r^2}{65536K^2N},&
 \delta&=8KrH+1,&D_*&=2Kr,\\
 L_*&=4PD_*=8PKr,&\Lambda&=HL_*,&
 R_0&=\Lambda+\delta,\\
 O&=2Q+3,&B_*&=O/\epsilon_*,&
 C_*&=1+B_*+6L_*B_* .
\end{split}                                                    \tag{1}
\]
These are geometry-only constants. The large numerical denominators are
convenient margins, not claimed sharp constants.

**Theorem.** Let \(\Omega\subset\mathcal C\) be a domain and let
\(f:\Omega\to Y\) be nonconstant, proper, and holomorphic. Put
\(u=|df(\partial_t)|\). For any measurable \(w\geq0\), suppose
\[
 M=\sup_{j\in\mathbb Z}\|w\|_{L^2(\Omega\cap S_j)}<\infty .
\]
For any interval \(I\subset\mathbb R\), of any length, put
\[
 E=\int_{\Omega\cap(h\circ f)^{-1}(I+[-R_0,R_0])}u^2\,dt\,d\theta.
\]
If \(E<\infty\), then
\[
 \int_{\Omega\cap(h\circ f)^{-1}(I)}uw\,dt\,d\theta
       \leq C_*ME.                                             \tag{2}
\]
For a full source end \(t>a\) cut from a proper normalization, the
corresponding integrals restricted to that end satisfy
\[
 \int_{t>a,\ h\circ f\in I}uw
       \leq C_{\rm end}M(1+E),\qquad
 C_{\rm end}=C_*+(2Q+4)+3L_* .                                  \tag{3}
\]
Local graph closedness away from the artificial boundary is sufficient
for this end version. It follows from the ambient normalization's
properness; properness of the restricted end map is not asserted.

## 2. A holomorphic area lower bound, including the sign

We first prove the only area-quantization fact needed below.
Let \(G\) be a holomorphic map from a planar open set to \(\mathbb C^2\).
Suppose a component of \(G^{-1}(B(q,s))\), containing a point with image
\(q\), is relatively compact in the source and has no source boundary
there. Then
\[
                 \int |G'|^2\,dA\ \geq\ \pi s^2.                \tag{4}
\]
The integral may be taken over the entire component. A constant map
cannot satisfy the stated compact-sublevel condition.

Here is a proof that does not presume embeddedness, injectivity, or a
regular target value at \(q\). Set \(F=G-q\), \(S=|F|^2\), \(T=|F'|^2\),
and \(J=\sum F_i'\overline{F_i}\). Away from common zeros,
\[
 \Delta S=4T,\qquad
 \Delta\log|F|=\frac{2(ST-|J|^2)}{S^2}\geq0.
\]
The inequality is exactly the complex Lagrange identity
\[
 ST-|J|^2=|F_1F_2'-F_2F_1'|^2.                                \tag{5}
\]
At a common zero of order \(m\geq1\), write \(F=z^mF_0\) with
\(F_0(0)\ne0\). The distributional Laplacian of \(\log|F|\) has the
positive atom \(2\pi m\delta_0\).

Choose a regular sublevel \(s'<s\) and its component \(V\) containing
the marked zero. Its closure is compact, and its smooth boundary has
\(S=(s')^2\). With
\(d^c b=-b_y\,dx+b_x\,dy\), so \(dd^c b=(\Delta b)dA\), Stokes gives
\[
\begin{split}
 \int_V T\,dA
 &=\tfrac14\int_{\partial V}d^cS\\
 &=\tfrac{(s')^2}{2}\int_{\partial V}d^c\log|F|
 \ \geq\ \pi(s')^2 .
\end{split}
\]
The boundary orientation is the positive planar orientation; there is
no sign reversal on inner boundary components. Let regular \(s'\)
increase to \(s\). This proves (4), also when the sublevel has holes or
the map is branched. Identity (5) is checked both by the exact offline
script and by the archived typed Jacobian operation.

## 3. Explicit filling of a possibly incomplete source disk

**Graph-filling lemma.** Let \(R,r>0\). Let \(D\) be an open subset of
\(D(0,2R)\), and let \(G:D\to B(0,4r)\subset\mathbb C^2\) be holomorphic.
Assume its graph is **closed in the whole product**
\(D(0,2R)\times B(0,4r)\), not merely closed over \(D\).
Suppose \(0\in D\), \(G(0)=0\), and
\[
             e:=\int_D|G'|^2\,dA\leq r^2/65536.
\]
Then \(D(0,R)\subset D\) and \(|G|<r/2\) there.

**Proof.** Closedness says that a sequence of source points converging
inside \(D(0,2R)\), whose target values converge inside \(B(0,4r)\),
cannot exit the domain. This is the precise replacement for properness
in this local lemma.

Every circle \(|z|=\rho\), \(R<\rho<2R\), contains a graph point with
\(|G|<r/16\). Otherwise, for each regular \(s<r/16\), the component
of \(\{|z|<\rho,\ |G|<s\}\) containing zero has compact closure,
by graph closedness and the absence of such a point on the source
circle. Equation (4) would give \(e\geq\pi(r/16)^2\) by passage to
the limit, a contradiction.

Fubini supplies a circle with
\[
 \int_{D\cap\{|z|=\rho\}}|G'|^2\,ds\leq e/R.
\]
The sum of the lengths of its image arcs is at most
\[
 \sqrt{(2\pi\rho)(e/R)}
       \leq\sqrt{4\pi e}<r/64 .
\]
Start on this circle at the point with \(|G|<r/16\).
The connected source arc containing it cannot end: its image has total
variation less than \(r/64\), so it has an endpoint limit inside
\(B(0,r/8)\), and graph closedness would extend the arc.
Consequently the entire circle belongs to \(D\) and its image lies in
\(B(0,r/8)\). This argument is valid for countably many possible arcs;
only finite total length and local smoothness on each arc are used.

There is no graph point inside this circle with \(|G|=r/2\).
If such a point had image \(q\), the ball \(B(q,r/4)\) would lie in
\(B(0,3r/4)\), and its closure would be disjoint from the boundary
circle's image. The appropriate preimage component would have compact
closure inside the circle, by graph closedness. Equation (4) would
give \(e\geq\pi(r/4)^2\), again a contradiction.

The component of \(D\cap D(0,\rho)\) containing an inner collar of
the boundary circle therefore has image in \(B(0,r/2)\).
It is open in \(D(0,\rho)\). It is also closed there: a limiting
source point has a target subsequence in the compact closed ball
\(\overline{B(0,r/2)}\), belongs to the graph, and cannot have image
on its radius-\(r/2\) boundary. Thus this component is the whole
disk, proving the lemma. This also explicitly rules out hidden source
punctures. All compact-sublevel uses above may be exhausted by smaller
regular target radii, as in Section 2.

## 4. Uniform small-energy cost and long chains

Call \(j\) flat exactly as in the manuscript: the full compact cylinder
\(\overline{C_j^{2P+2}}\) lies in the source and its image is in one
\(U_p(r)\).

**Small-energy cost.** If \(v_0\in\Omega\cap S_j\), \(h(f(v_0))\in I\),
and \(j\) is nonflat, then
\[
 \int_{\Omega\cap C_j^Q\cap(h\circ f)^{-1}(I+[-\delta,\delta])}
             u^2\,dA\ \geq\epsilon_* .                          \tag{6}
\]
To prove the contrapositive, use the chart centered at \(p=f(v_0)\),
lift the cylinder to the plane, and center the lift at \(v_0\).
The disk of radius \(2R_s\) projects into \(C_j^Q\).
For any cylinder point it has at most
\[
  \lfloor2R_s/\pi\rfloor+1\leq R_s+1=N
\]
preimages. This follows by counting imaginary coordinates spaced
\(2\pi\) in an interval of length \(4R_s\).
The entire chart \(U_p(4r)\) has
\(|h-h(p)|\leq4KrH<\delta\). Consequently its lifted coordinate
graph has vertical energy at most \(K^2N\) times the integral in
(6), hence less than \(r^2/65536\).

This graph is closed in the required product. Indeed, convergent
source and target-coordinate sequences project to a compact target
subset of \(U_p(4r)\). Properness of \(f\) forces their projected
source limits into \(\Omega\); their fixed finite lifts then remain
in the lifted domain. We do not assert that the infinite lifted map
itself is proper.

Section 3 fills the radius-\(R_s\) disk with image in \(U_p(r/2)\).
Every point of \(\overline{C_j^{2P+2}}\) has a lift whose real distance
from the marked point is at most \(2P+3\) and imaginary distance at
most \(\pi\). Since
\[
 R_s^2-(2P+3)^2-16=20P+39>0,\qquad \pi<4,
\]
this compact cylinder is inside the filled disk's projection.
Thus \(j\) is flat. This proves (6) with the explicit constants (1),
without a subsequence argument.

**Flat-chain summability.** On a flat strip, the coordinate map \(F\)
has norm at most \(r\). Cauchy's estimate on unit source disks gives
\(m_j:=\sup_{S_j}u\leq D_*\), also on the slightly larger cylinders
used to bound the Fourier coefficients.
The periodic holomorphic derivative \(F'\) has zero angular constant
mode, since it is the derivative of a single-valued coordinate map:
\[
 \int_0^{2\pi}F'(t+i\theta)\,d\theta=0.
\]
Expanding \(F'=\sum_{n\ne0}c_ne^{nv}\), estimating positive modes on
\(t=j+1+P\) and negative modes on \(t=j-P\), and comparing tangent
norms gives
\[
 m_j\leq\frac{2K^2}{e^P-1}
             \max_{|k-j|\leq P}m_k
       \leq\tfrac12\max_{|k-j|\leq P}m_k                         \tag{7}
\]
whenever those indices all belong to the same flat chain.
For example each positive coefficient contributes at most the right
circle's supremum times \(e^{-nP}\) on \(S_j\); their sum is
\((e^P-1)^{-1}\). The left circle gives the identical negative-mode
bound. The final inequality uses \(e^P-1\geq P\geq4K^2\).
Only intrinsic \(m_k\)'s occur in (7), so repeated chart changes
introduce no accumulating comparison factors.

If \(J\) is a maximal chain and \(d(j)\) is its integer distance to
the nearer finite endpoint, induction on \(\lfloor d(j)/P\rfloor\)
gives \(m_j\leq D_*2^{-\lfloor d(j)/P\rfloor}\).
At most \(2P\) indices have any specified value of this floor, hence
\[
                    \sum_{j\in J}m_j\leq4PD_*=L_* .             \tag{8}
\]
For a half-infinite chain the same estimate, with its one finite
endpoint, applies. If \(J=\mathbb Z\), (7) can be iterated arbitrarily
often at every index, forcing \(df=0\), contrary to nonconstancy.
This proves (8) for every possible chain length, not just finite ones.

A chain meeting the target interval \(I\) has a finite endpoint.
Travel from a marked point in the \(t\)-direction at fixed angle.
Equation (8) bounds the height change by \(\Lambda=HL_*\).
The endpoint's neighboring nonflat closed strip contains the shared
boundary point, which lies in \(\Omega\) because the endpoint strip
has a full thickening. That strip therefore meets
\(I+[-\Lambda,\Lambda]\).

## 5. Charging proves the universal estimate

Let \(\mathcal N\) be all nonflat strips meeting
\(I+[-\Lambda,\Lambda]\). Apply (6) to a marked point in each.
The enlarged source cylinders overlap at most \(O=2Q+3\) times.
For every finite subset, summation yields
\[
                  \#\mathcal N\,\epsilon_*\leq OE.              \tag{9}
\]
Thus \(\mathcal N\) is finite and has at most \(B_*E\) elements.
No energy outside the enlarged target interval defining \(E\) has
entered this inequality.

On the subset of nonflat strips actually meeting \(I\), two
Cauchy--Schwarz inequalities give
\[
 \sum_{\rm nonflat}\int_{S_j\cap\Omega\cap\{h\circ f\in I\}}uw
       \leq M\sqrt{\#\mathcal N}\sqrt E
       \leq (1+B_*)ME .
\]
Here \(\sqrt{B_*}\leq1+B_*\) for every positive \(B_*\).
On each flat chain, (8) and the strip area \(2\pi\) give
\(\int_Juw\leq\sqrt{2\pi}ML_*<3ML_*\).
Every contributing chain charges a finite endpoint to a member of
\(\mathcal N\); a nonflat strip is adjacent to at most two chains.
Hence their total contribution is at most \(6L_*B_*ME\).
This proves (2), including \(E=0\) and \(M=0\).

For \(t>a\), discard an initial block of at most \(2Q+4\) strips,
so all remaining \(Q\)-thickenings lie inside the end. On that block
Cauchy--Schwarz bounds the integral by
\(M\sqrt{2Q+4}\sqrt E\leq(2Q+4)M(1+E)\).
There is at most one remaining flat chain touching the cut and thus
not chargeable to a nonflat strip; its contribution is at most
\(3ML_*\). Every other term is as above. This proves (3).

## 6. The gauge requires no unverified embedding citation

For completeness we justify the precise analytic input used in the
plane case. If \(a\in L^1(\mathcal C)\cap L^2(\mathcal C)\), put
\[
 a_0(t)=(2\pi)^{-1}\int a(t,\theta)d\theta,\qquad
 g_0(t)=2\int_{-\infty}^t a_0(s)\,ds .
\]
Then \(\|g_0\|_\infty\leq\|a\|_1/\pi\), and \(g_0'=2a_0\) is
in \(L^2\). For the nonzero angular modes, set
\[
 \widehat{g_\perp}(\xi,n)=2\widehat{a_\perp}(\xi,n)/(i\xi-n).
\]
Since \(n^2\geq1\), the squared \(W^{1,2}\) multiplier is at most
\(4(1+\xi^2+n^2)/(\xi^2+n^2)\leq8\).
Plancherel proves the global \(W^{1,2}\) bound for \(g_\perp\).
Thus \(g=g_0+g_\perp\) solves \(\bar\partial g=a\,d\bar v\) and has
uniform full \(W^{1,2}(S_j)\) norm. Local ellipticity gives smoothness
where \(a\) is smooth.

Here is a direct proof of the required exponential integrability,
so no Trudinger theorem is an undischarged specialized premise.
For a real function on the fixed rectangle \([0,1]\times[0,2\pi]\),
even reflection across its sides followed by a fixed cutoff gives an
extension to \(H^1(\mathbb R^2)\), with norm bound
\(C_{\rm ext}\|u\|_{W^{1,2}}\), equal to \(u\) on the rectangle.
The bound follows by the change-of-variables formula on each reflected
copy and the product rule for the cutoff, and is independent of \(j\).

Use the unitary two-dimensional Fourier transform. For \(p\geq4\),
Hausdorff--Young (interpolation of \(L^1\to L^\infty\) and Plancherel)
and weighted Holder give
\[
 \|u\|_p\leq\|Eu\|_p
 \leq\|Eu\|_{H^1}
       \left(\int_{\mathbb R^2}(1+|\xi|^2)^{-s/2}d\xi\right)^{1/s},
 \qquad s=\frac{2p}{p-2}.
\]
The integral is \(2\pi/(s-2)=\pi(p-2)/2\); its \(1/s\) power is
at most \(\sqrt{2p}\). Consequently, for every integer \(m\geq1\),
\[
 \int_{S_j}|u|^{2m}\leq
          (4m C_{\rm ext}^2 B^2)^m
 \quad\text{if}\quad\|u\|_{W^{1,2}(S_j)}\leq B .
\]
The \(m=1\) case follows directly from the norm.
Since \(m!\geq(m/e)^m\) (integrate \(\log x\)) and \(e<3\),
expanding the exponential with \(c=1/(24C_{\rm ext}^2)\) gives
\[
 \int_{S_j}\exp(cu^2/B^2)\leq2\pi+\sum_{m\geq1}2^{-m}=2\pi+1.
\]
For \(B=0\) the function is zero. Finally
\[
 p|u|\leq cu^2/B^2+p^2B^2/(4c)
\]
proves uniformly bounded strip integrals of \(e^{p|u|}\) for each
fixed finite \(p\). Applied to \(u=\operatorname{Re}g\), this proves
exactly `cylinder:gauge-exp`, including both signs of the gauge.
No assertion of a constant uniform in \(p\) is needed or made.

## 7. Exact extent of the compactness application

The following are **manuscript inputs, not verified conclusions of this
mission**:

| Input | Staged assertion | Used for |
|---|---|---|
| AREA | `curve:area` | The same area exponent \(A>0\) for every fixed translate |
| PLANAR | `curve:genus` | Every noncompact normalization is a domain in the sphere |
| SECTION | `compact:section`, `curve:gamma-choice` | One fixed \(E,s,D\), end limits \((1,0)\), and connection decay \(\gamma>2A+10\) |
| RESIDUE | `curve:residue`, `weighted:currents` | Scalar impossibility and independence in a single finite-dimensional fixed-bundle cohomology space |

Assume these inputs, the proper height and deck convention
\(h\circ T=h+1\), and properness of the normalization maps.
We now verify the logical bridge without assuming its conclusion.

For \(I_l=[-l-1,-l]\), its fixed \(R_0\)-enlargement is covered by
a fixed finite number of unit slabs with indices differing from \(l\)
by a bounded amount. AREA therefore gives \(E_l\leq C_Be^{Al}\).
The finitely many slabs outside the negative tail have finite area
and change only \(C_B\). Equations (2)--(3) give
\[
 \int_{h\circ f\in I_l}uw\leq C_{B,w}e^{Al}.                    \tag{10}
\]
There is no multiplication of \(A\) by the source-chain length, the
chart factor, or the number of fixed translates.

If a planar normalization omits at least two sphere points, a Mobius
change embeds it in \(\mathbb C^*\), hence in \(\mathcal C\).
The proper map is unchanged up to this source biholomorphism.
Use \(w=1\), whose strip \(L^2\) norm is at most \(\sqrt{2\pi}\).
The nonzero differential \(dz/z=dv\) has pushforward masses bounded
by (10). RESIDUE excludes it. The only possible open normalization
is therefore the plane.

For a plane component \(B\), put \(f_k=T^k\circ f\).
Properness and its finite upper height bound imply
\(h(f_k(z))\to-\infty\) uniformly as \(|z|\to\infty\).
In the unit smooth negative-end frame write the connection as
\(\bar\partial+\eta\) and
\(f_k^*\eta=a(v)d\bar v\), \(v=\log z\).
Then \(|a|\leq Ce^{-\gamma|h\circ f_k|}u\).
Equation (10) with \(w=1\), and the area-energy identity separately,
give
\[
 \|a\|_1\leq C_k\sum_{l\geq0}e^{-(\gamma-A)l}<\infty,\qquad
 \|a\|_2^2\leq C_k\sum_{l\geq0}e^{-(2\gamma-A)l}<\infty .
\]
Cut off at the finite side to apply Section 6 on the full cylinder.
It gives one periodic \(g\) with uniformly bounded strip norms and
both exponential signs integrable. If \(\sigma\) is the coefficient
of \(f_k^*s\), then \(H=e^g\sigma\) is ordinary holomorphic and
periodic. SECTION and properness give
\(\sup_{S_j}|\sigma|\to0\); thus \(\int_{S_j}|H|^2\to0\).
The holomorphic mean-value inequality on fixed disks contained in
three adjacent strips implies uniform \(H\to0\) as \(t\to\infty\).
The removable singularity theorem at \(z=\infty\) gives
\(H(z)=O(1/z)\).

It follows that the coefficient of
\(\alpha_k=(f_k^*s)\,dz\) relative to \(dv\) is bounded by
\(C_ke^{-\operatorname{Re}g}\). This is an admissible multiplier
in (10), so the current \((f_k)_*\alpha_k\) has mass exponent
**the same \(A\)**. Its omitted compact source disk affects finitely
many target slabs only.

The curves \(T^kB\) have distinct upper height suprema \(M_B+k\).
For all sufficiently large \(k\) they are not contained in \(D\),
so the differentials \(\alpha_k\) are nonzero. Fix
\(\varepsilon>0\) and \(b>\max(A,\varepsilon)\) once, independent
of \(k\). RESIDUE then gives infinitely many independent classes in
one finite-dimensional space \(H^{2,1}_{-\varepsilon,b}(Y,E)\),
a contradiction. Separate constants \(C_k\) and upper support bounds
do not change that space. This proves the **conditional bridge**.
It does not discharge AREA, PLANAR, SECTION, or RESIDUE.

## 8. Prior knowledge, sources, and adversarial scope

The shared Wiki had no page on this cylinder assertion. Its
buffered-chain splitting page concerns a different Cauchy-potential
problem and is not a premise.

An independent literature researcher checked the primary Trudinger
journal scan at
`https://www.iumj.indiana.edu/IUMJ/FTDLOAD/1968/17/17028/pdf`,
DOI `10.1512/iumj.1968.17.17028`, pp. 474--479, especially Theorem 2
on p. 478. The full Sobolev norm is defined on p. 474; Theorem 2
begins "Let [the domain] satisfy a cone condition." A rectangle
satisfies that condition, and the zero-boundary space is treated
separately. This supports the manuscript's full-norm use rather than
an incorrectly boundary-normalized version. Section 6 supplies an
independent proof, so this citation is not an outstanding assumption
of our theorem.

The same bounded primary-source investigation could not obtain the
actual Harvey--Shiffman Theorems 3.9--3.10, pp. 585--586, through
the official Annals/JSTOR and author routes. It also could not obtain
Bishop through the official Project Euclid and archive routes.
Metadata and search summaries do not establish their hypotheses.
The citation-dependent route is retired for this access limitation,
not because either theorem or its application was disproved.
Sections 2--4 remove the dependency instead.

The theorem has been checked at the genuine problematic boundaries:
arbitrary missing source points, branching, arbitrarily long and
one-sided infinite flat chains, changes of target charts, a finite
artificial source boundary, varying multiplier, and fixed translates
with unrelated area constants. A slit-domain map with bounded image
but finite source boundary is not proper and is not a refutation.
Likewise a nonzero constant Fourier mode cannot be inserted into the
derivative of a single-valued chart-valued cylinder map.

## 9. What the executable certificate does and does not check

Run `python3 research/cylinder_compactness/verify.py`.
It uses exact SymPy rational polynomial arithmetic, not floating
samples. It replays (5), checks its binding to the typed Jacobian
payload and result, verifies all numerical margins in the disk-filling
argument, verifies the symbolic uniform constants and geometric-series
identities, and checks the exponents and Fourier multiplier bounds.
Its rational proof of \(3<\pi<4\) uses the integrated alternating
polynomial lower bound for \(1/(1+x^2)\), not a decimal approximation.

The code does **not** implement a kernel for Stokes' theorem, Fubini,
source-graph closedness, holomorphic continuation, or the upstream
manuscript premises. Those are proved in Sections 2--7 or explicitly
left as inputs there. The exact algebra replay is supporting evidence
for this universal analytic proof, not a claim that a finite
experiment or one sum-of-squares identity proves the entire estimate.
There is no Lean source awaiting an unavailable compiler, and no
claimed kernel certification. The Host's independent Reviewer must
read the analytic proof and replay the code before accepting the
mission.
