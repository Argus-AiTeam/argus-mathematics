# Exact verification of the explicit angular cylinder cover

## Result and scope

Let \(H=\sqrt2\), \(\varepsilon=1/2000\), \(\eta=1/1000\),
\(n=8\,000\,000\), and \(\Delta=2/n=\varepsilon^2\). The precise
triangles and axes in the staged angular manuscript give a covering of
every point of the **closed** tetrahedron
\[
 K=\{(x,y,Ht):0\leq t\leq1,\quad |x|\leq1-t,\quad |y|\leq t\}.
\]
There are \(2n=16\,000\,000\) compact nondegenerate triangular
perpendicular bases. Their total area \(S\) satisfies the exact bound
\[
 \frac{S}{H}\leq U<\frac12-\frac1{2\,000\,000\,000}<\frac12,
 \qquad A_{\min}(K)=H .
\]
The large rational \(U\), not a floating-point estimate, is in
`exact_certificate.json`. The coverage contradiction has positive slack
\(15983/16000000\).

This is an independent verification certificate for the manuscript's
construction, **not** a new cylinder construction, improved asymptotic
coefficient, or refutation. No false assertion was found in the four
target sections. No `F_` refutation claim is therefore asserted. The
Engineer does not supply an independent Reviewer verdict, a novelty
verdict, or a campaign-final acceptance.

The target source is
`research/openai_manuscript/Finite-angular-cylinder-covers-below-the-half-area-bound-September-27-2026/build/sections/`:
`introduction.tex`, Theorem `thm:counterexample`;
`construction.tex`, equations `parameters`, `axis-coefficients`,
`cutoffs`, `first-family`, `second-family`;
`coverage.tex`, Proposition `prop:coverage`; and
`area.tex`, equation `exact-area-sum`.

The paper already states and proves the geometric result. Compared with
that prior result, this work supplies a kernel-checked finite-selection
and radial-budget core and a different exact finite-cost certificate that
does not assume the paper's coverage proposition, Taylor remainder, or
quadrature estimate. The previously noted incomplete upstream Lean
comparators are not used as evidence. Neither companion approximation
theorem is needed.

## 1. Exact objects and all local bounds

For \(0\leq j<n\), put
\[
 a_j=-1+j\Delta,\quad b_j=a_j+\Delta,\quad
 \alpha_j=(1+a_jb_j)/4,\quad\beta_j=(a_j+b_j)/4,
\]
\[
 \phi(q)=(1-q^2)/4,\quad d(q)=q^2(1+q^2)/16,\quad
 M_j=\eta+\max\{d(a_j),d(b_j)\},\quad
 T_j=\tfrac12+\varepsilon^2M_j .
\]
These are exactly the manuscript cutoffs: \(d\) is nondecreasing in
\(q^2\), since
\[
 d(v)-d(q)=\frac{(v^2-q^2)(1+v^2+q^2)}{16}.
\]
Every \(q\in[a_j,b_j]\) has absolute value at most
\(\max(|a_j|,|b_j|)\), so the maximum on the entire interval is
the endpoint maximum.

The intercept triangles are
\[
 P_j=\{(0,y_0,Ht_0):0\leq t_0\leq T_j,\ a_jt_0\leq y_0\leq b_jt_0\},
\]
\[
 Q_j=\{(x_0,0,H(1-s_0)):0\leq s_0\leq T_j,\
                 a_js_0\leq x_0\leq b_js_0\},
\]
with respective axes
\[
 v_j=(1,\varepsilon\alpha_j,H\varepsilon\beta_j),\qquad
 w_j=(-\varepsilon\alpha_j,1,H\varepsilon\beta_j).
\]
Use the full infinite cylinders \(P_j+\mathbb R v_j\) and
\(Q_j+\mathbb R w_j\), not finite line segments or cylinders with
a different base convention.

For every sector and every \(q\) in that sector,
\[
 0\leq\alpha_j\leq\tfrac12,\quad |\beta_j|\leq\tfrac12,\quad
 |\beta_j-q/2|\leq\Delta/4,\quad
 |\alpha_j-(1+q^2)/4|\leq\Delta/2,
\]
\[
 0\leq d(q)\leq\tfrac18,\qquad
 \eta+d(q)\leq M_j\leq\eta+\tfrac18 .
\]
The script proves the polynomial inequalities uniformly, not at a
collection of mesh points. Write
\[
 a=-1+(2-\Delta)u,\quad b=a+\Delta,\quad q=a+\Delta v,
                 \qquad 0\leq u,v\leq1.
\]
Every actual sector and every point of it is included:
\(u=j/(n-1)\) and \(v=(q-a_j)/\Delta\).
`bernstein_certificate` converts each relevant rational polynomial
exactly to the tensor Bernstein basis, reconstructs the original
polynomial to check the conversion, and verifies that every coefficient
is nonnegative. Bernstein basis functions on the closed unit cube are
nonnegative and sum to one; hence the recorded minimum coefficient is a
valid universal lower bound. Only low-degree polynomials in one or two
variables occur. Nonnegativity of \(d\) follows directly from its squared
factor. This is a polynomial certificate, not an enumeration of sectors.

## 2. Finite angular selection, with no monotonicity assumption

Fix an arbitrary \((x,y,Ht)\in K\) and put \(s=1-t\). Define the finite
sequences
\[
 F_i=q_it+\varepsilon x\phi(q_i),\qquad
 G_i=q_is-\varepsilon y\phi(q_i),\quad 0\leq i\leq n.
\]
Since \(\phi(-1)=\phi(1)=0\), their endpoints satisfy
\[
 F_0=-t\leq y\leq t=F_n,\qquad
 G_0=-s\leq x\leq s=G_n.
\]
Any finite real sequence with \(F_0\leq y\leq F_n\), \(n>0\), has an
adjacent bracket. For example, take the least \(i\in\{1,\ldots,n\}\)
with \(F_i\geq y\); then \(F_{i-1}\leq y\leq F_i\). Endpoint equality
is allowed. `finite_bracket` proves the equivalent existence statement
by induction, for all positive \(n\), with no ordering hypothesis.

The identities
\[
 \alpha_j-a_j\beta_j=\phi(a_j),\qquad
 \alpha_j-b_j\beta_j=\phi(b_j)
\]
convert the lower bracket into
\[
 a_jt_0\leq y_0\leq b_jt_0,\qquad
 t_0=t-\varepsilon x\beta_j,\quad y_0=y-\varepsilon x\alpha_j.
\]
Subtracting gives \(\Delta t_0\geq0\), and \(\Delta>0\) gives
\(t_0\geq0\). Thus this cylinder contains the point if \(t_0\leq T_j\).
For the upper bracket the identical argument gives
\[
 a_ks_0\leq x_0\leq b_ks_0,\qquad
 s_0=s+\varepsilon y\beta_k\geq0,\quad x_0=x+\varepsilon y\alpha_k.
\]
It contains the point if \(s_0\leq T_k\).
`shared_left`, `shared_right`, and `sector_transfer` formalize these
conversions, including nonnegativity. The upper conversion is the
substitution \(t\mapsto s,\ x\mapsto-y,\ y\mapsto x\).

This is the entire selection argument. In particular it works at
vertices, edges, faces and coincident angular boundaries. A nonmonotone
sequence really occurs at \((x,y,t)=(1,0,0)\), where the middle value of
\(F_i\) is positive but both endpoints are zero. Neither proof nor
regression-test selection assumes monotonicity. The regression selector
uses interval bisection maintaining only the two endpoint inequalities.

## 3. Exact radial contradiction

Suppose both selected cutoffs fail. Then
\(t_0>T_j>1/2\), \(s_0>T_k>1/2\), so the ratios
\[
 q=y_0/t_0\in[a_j,b_j],\qquad p=x_0/s_0\in[a_k,b_k]
\]
are defined and belong to \([-1,1]\). Put \(a=t_0-1/2\),
\(b=s_0-1/2\), and abbreviate the lower and upper coefficients by
\((\alpha,\beta)\) and \((\alpha',\beta')\). The three intercept
identities are
\[
 a+b=-\varepsilon x\beta+\varepsilon y\beta',\quad
 qa=y-\varepsilon x\alpha-q/2,\quad
 pb=x+\varepsilon y\alpha'-p/2.
\]
Their exact polynomial combination yields
\[
 a(1-\varepsilon xq)+b(1+\varepsilon yp)
 =\varepsilon^2E-\varepsilon x(\beta-q/2)
                    +\varepsilon y(\beta'-p/2),
 \qquad E=x^2\alpha+y^2\alpha'.
\]
Both Python and `radial_budget_identity` check this identity; its
signs are not inferred from a perturbative argument.

Because \(|x|+|y|\leq1\), the first identity gives
\(a+b\leq\varepsilon/2\). Both excesses are positive, so each is at
most \(\varepsilon/2\). The remaining two identities, together with the
coefficient bounds, then give
\[
 |y-q/2|\leq\varepsilon,\qquad |x-p/2|\leq\varepsilon.
\]
For \(|x|,|p|\leq1\) the factorization of \(x^2-p^2/4\) gives
\[
 x^2-p^2/4
 \leq |x-p/2|\,|x+p/2|\leq\tfrac32\varepsilon,
\]
and similarly for \(y,q\). Multiplying these upper bounds by
nonnegative \(\alpha,\alpha'\leq1/2\), and using the coefficient errors,
gives
\[
 E\leq\frac{p^2+q^2+2p^2q^2}{16}
                       +\tfrac32\varepsilon+\Delta/4
   \leq d(p)+d(q)+\tfrac32\varepsilon+\Delta/4.
\]
The final inequality is the exact sum-of-squares identity
\[
 d(p)+d(q)-\frac{p^2+q^2+2p^2q^2}{16}
                    =\frac{(p^2-q^2)^2}{16}\geq0.
\]
It is **not** taken to be strictly positive. In particular no step is
lost on \(p^2=q^2\). `rough_angle`, `square_error`, `energy_bound`,
and `surplus_nonnegative` prove the bounds in Lean from the displayed
primitive hypotheses, rather than assuming them as a coverage lemma.

The two factors on the left of the budget identity are at least
\(1-\varepsilon>0\). Strict cap failure and the beta-error bounds thus
give
\[
 W:=(M_j+M_k)(1-\varepsilon)-E-\frac{\Delta}{4\varepsilon}<0 .
\]
On the other hand set
\[
 \gamma=2\eta-\varepsilon(1/4+2\eta)
                    -\tfrac32\varepsilon-\Delta/4
                    -\frac{\Delta}{4\varepsilon}.
\]
The exact identity
\[
 \begin{split}
 W-\gamma={}&[M_j+M_k-d(p)-d(q)-2\eta]\\
 &+\varepsilon[1/4+2\eta-M_j-M_k]\\
 &+[d(p)+d(q)+\tfrac32\varepsilon+\Delta/4-E]
 \end{split}
\]
is a sum of three nonnegative quantities. For the prescribed parameters,
\[
 \gamma=2\eta-(2+2\eta)\varepsilon-\varepsilon^2/4
        =\frac{15983}{16000000}>0 .
\]
This contradicts \(W<0\), establishing coverage of every point of \(K\).
`radial_caps` is the all-real-variables formal theorem for this
contradiction. The Jacobian adapter independently returned the exact
enclosure \([15983/16000000,1/500]\) for the corresponding gap
polynomial on \([0,1/2000]\).

A zero intercept is harmless: its closed sector inequalities force its
angular intercept coordinate to be zero, and it is already within its
positive cap. A cap equality is membership. Ratios were introduced only
under strict double failure, so no division by zero occurs on a boundary.

## 4. Perpendicular bases and the projection minimum

The intercept planes have normals \(e_x,e_y\). Their normal components
of \(v_j,w_j\), respectively, equal one. Therefore orthogonal projection
onto the corresponding perpendicular plane is injective on the
intercept plane: a vector in its kernel would have to be both parallel
to the axis and tangent to the intercept plane, and hence zero.
Since \(\Delta>0\) and \(T_j>0\), both intercept triangles are
nondegenerate. Their projections remain compact nondegenerate
triangles. Projection along an axis does not change the infinite
cylinder because \(p-\pi_{v^\perp}p\) is parallel to \(v\).

The area of each intercept triangle is \(H\Delta T_j^2/2\).
For planar orthogonal projection the area multiplier is the absolute
inner product of the two unit normals; this follows by projecting an
oriented pair of triangle edges and taking its cross product. Here the
multiplier is
\[
 \frac{1}{\sqrt{1+\varepsilon^2(\alpha_j^2+2\beta_j^2)}}.
\]
The script independently computes both triangle cross products and both
axis norms, including the sign change in the upper axis. Thus
\[
 \frac SH=\sum_{j=0}^{n-1}
  \frac{\Delta T_j^2}{\sqrt{1+\varepsilon^2(\alpha_j^2+2\beta_j^2)}}.
 \tag{1}
\]

For completeness the four outward face area vectors of \(K\) are
\((0,\pm H,-1)\), \((\pm H,0,1)\); the script checks their orientations
against all vertices and derives them from face cross products. For a
unit direction \(u\), faces with positive normal dot product project to
the shadow with disjoint interiors: a nonexceptional line parallel to
\(u\) through the shadow has exactly one forward endpoint on such a
face. Projected edges and parallel faces have area zero. Each face
contributes its positive normal dot product. Since the four area
vectors sum to zero, the shadow area is half their absolute dot-product
sum. The elementary identity
\(|A+B|+|A-B|=2\max(|A|,|B|)\) therefore gives
\[
 A(u)=\max(H|u_x|,|u_z|)+\max(H|u_y|,|u_z|).
\]
Let \(U=\max(|u_x|,|u_z|/H)\) and
\(V=\max(|u_y|,|u_z|/H)\). Both are nonnegative and
\[
 (U+V)^2-1=(U^2-u_x^2)+(V^2-u_y^2)
                         +2(UV-u_z^2/2)\geq0 .
\]
Consequently \(A(u)=H(U+V)\geq H\). Equality holds at \(u=e_x\), proving
\(A_{\min}(K)=H\). This face-by-face argument proves the needed
projection formula directly; it does not invoke an external literature
theorem.

## 5. A different exact finite-area certificate

For every \(z\geq0\) put \(R(z)=1-z/2+3z^2/8\). The identities
\[
 R(z)=\frac56+\frac38(z-\tfrac23)^2,\quad
 R(z)^2(1+z)-1=\frac{z^3(9z^2-15z+40)}{64},
\]
\[
 9z^2-15z+40=9(z-\tfrac56)^2+\frac{135}{4}
\]
give \(R(z)>0\) and \(R(z)^2(1+z)\geq1\). Since the real square root
is positive, \(1/\sqrt{1+z}\leq R(z)\).
`reciprocal_sqrt_majorant` proves the actual unsquared inequality for
all nonnegative real \(z\).

There are \(m=n/2=4\,000\,000\) positive-half intervals
\([r/m,(r+1)/m]\), \(0\leq r<m\). Reflection to the negative half
leaves \(\alpha,T\) unchanged and reverses the sign of \(\beta\).
Write
\[
 A_r=\left(\frac{1+r(r+1)/m^2}{4}\right)^2
                     +2\left(\frac{2r+1}{4m}\right)^2,\qquad
 M_r=\eta+d((r+1)/m),\quad T_r=\tfrac12+\varepsilon^2M_r.
\]
Equation (1) and the majorant show
\[
 \frac SH\leq
 U:=\frac2m\sum_{r=0}^{m-1}
 T_r^2\left(1-\frac{\varepsilon^2A_r}{2}
                       +\frac{3\varepsilon^4A_r^2}{8}\right).
 \tag{2}
\]
The summand in (2) is a rational polynomial in \(r\) of degree 16.
No radical approximation, analytic remainder estimate, limiting
argument, numerical integration, or mesh enumeration is used.

To evaluate it, let \(s_k=\sum_{r=0}^{m-1}r^k\). The binomial identity
and telescoping give the exact recurrence
\[
 s_k=\frac{m^{k+1}-\sum_{i=0}^{k-1}{k+1\choose i}s_i}{k+1}
       \quad(0\leq k\leq16).
\]
The empty sum gives \(s_0=m\). The script checks the polynomial
telescoping identity for each required degree and performs the 17
rational computations. It then verifies by exact integer
cross-multiplication that
\[
 \tfrac12-U>\frac1{2\,000\,000\,000}.
\]
The exact rational \(U\) and its saving are retained in the certificate.
This only certifies the requested strict saving; it does not claim an
improved geometric coefficient.

## 6. Evidence, limitations, and replay

Run from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/angular_certificate/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/angular_certificate/Main.lean --statement-fidelity research/angular_certificate/statement_fidelity.md --claim C_ANGULAR_CORE --project-root .
```

The first command recomputes and compares the stored exact certificate.
`--write` regenerates it when the verifier changes. SymPy supplies exact
rational polynomial arithmetic, not numerical optimization or a trusted
coverage oracle. The certificate also includes 39 exact regression
examples: all face/edge/vertex averages, near-tip edges, and selected
closed cap/sector boundaries. These examples are expressly not the
universal proof.

The Jacobian operation was discovered and its exact typed contract was
inspected before execution through the required isolated Argus adapter.
`jacobian_payload.json`, `jacobian_output.json`, and
`jacobian_status.json` retain its operation id, full input and typed
output, server/protocol versions, and measured exit/timeout/error status.
No inconclusive result is treated as mathematical evidence.

The formal source and its statement-fidelity document specify exactly
what Lean proves. The remaining Euclidean bridges, the elementary
endpoint-max argument, Bernstein basis soundness, and finite
power-summation interpretation are proved explicitly above and replayed
algebraically by Python; they are not claimed to be fully formalized in
Lean. The full geometric claim requires independent review of these
bridges and of the translation. No companion approximation theorem or
unread external cited proposition is an assumption of this proof.

The real Lean 4.31.0 run recorded in `lean_run_v2.json` completed with
`exit_code=0`, `proof_holes=[]`, and axiom-audit exit code zero. Its
mechanical `supports` evidence on `C_ANGULAR_CORE` is archived at
`certificates/C_ANGULAR_CORE-be21af6c89e8632c.json`. The source and fidelity
document have not been edited since that run. An earlier compiler run
failed on definition computability and renamed library lemmas; that
inconclusive run remains recorded and is not a mathematical refutation.

The audits of the finite-cylinder ruled-set approximation, finite
triangular radial-sweep approximation, and slope-field perturbation
manuscripts remain deferred branches. They are not dependencies of the
exact angular verification. This report does not certify their
statements, later angular extensions, or the all-epsilon asymptotic
theorem beyond the concrete parameters requested here.
