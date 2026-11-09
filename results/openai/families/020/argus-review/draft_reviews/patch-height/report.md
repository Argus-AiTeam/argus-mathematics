# Uniform patch degrees, heights and divisor budget

## Status, exact claim and provenance

**Engineer assessment:** the construction genuinely explains how to avoid an initial coefficient bound. Its linear-algebra step, projection argument and geometric recursion work under the manuscript's explicit **total geometric degree** convention, including lower-dimensional components. Parent integration checked that convention at M:20-24; it is not inferred from a historical support label.

Exact old claim **C_ADAPTIVE_HEIGHT@1**:

> For fixed ordinary degree limits and fixed path length, the patch construction in Lemma affine-patches gives uniformly bounded degrees and nonzero integer evaluated minors whose product has absolute value at most X^K for a fixed K, independent of z, all blocks and initial equation coefficients.

Read-only sources:

- **R:** campaign `9000020/research/adaptive_prime_audit/report.md`, lines 160–266; the product being bounded is defined at 103–117.
- **M:** September 24, 2026 manuscript, `build/sections/03-affine-counting.tex`, lines 75–159 and 236–297. The patch lemma and proof are at 86–154; the fixed-length degree recurrence and actual path are at 248–279.
- Supplied manuscript reference revision: `4eaee87548250b2682affda7d05d947c05554bae`; supplied preserved snapshot: `2026-11-06T10:20Z`. No integrity checks were repeated.

The old Argus report is an argument/reconstruction, not proof of originality. This report is an Engineer contribution, not a native independent Reviewer decision. No legacy workspace, ledger, graph or manuscript was changed.

## Hypotheses that the argument actually uses

The point set \(S\) is finite and integral, with the fixed weighted-box bound and \(X\ge2\). The only quantitative use of that box bound is: for each fixed ordinary degree \(d\), the integer evaluations of all monomials of degree at most \(d\) are bounded by \(C_dX^{a_d}\), where \(C_d,a_d\) depend only on \(d,N\) and the fixed box constants and weights. No bound on \(|S|\) is required.

The initial algebraic set has fixed geometric complexity, and the ordinary cut degrees \(D_i\) and path length \(r\) are fixed before the prime choices. All algebraic sets are treated as **reduced sets over \(\mathbb C\)**, decomposed into their geometrically irreducible components. A rational patch component is thus both \(\mathbb C\)-irreducible and defined over \(\mathbb Q\).

For clarity, the degree bound needed below is a bound for
\[
\delta(V)=\sum_{A\text{ an irreducible component of }V}\deg(\overline A),
\]
where \(\overline A\) is its projective closure and all component dimensions are included. A separate bound on the number and degrees of every component would also suffice. Parent integration read M:20-24: "for a reducible algebraic set we use the sum of the degrees of its irreducible components. Irreducibility is over \(\mathbb C\)." M:37-68 fixes the weighted box, ambient data, initial degree and dimension, with no initial coefficient bound. The required convention is therefore present in the actual source. A leading-Hilbert-coefficient degree counting only maximal-dimensional components would not suffice, but that is not the convention used here.

## 1. The precise geometric degree input

The needed bounded-degree lemma is:

> In fixed affine ambient dimension, a bound on total geometric degree bounds the number and individual degrees of reduced irreducible components. Proper hypersurface sections, intersections of two bounded-total-degree sets, and closures of same-dimensional linear images have uniformly bounded total geometric degree. These bounds are independent of equation coefficients. Components contained in a cutting hypersurface are retained rather than treated as proper cuts.

This is a standard degree package, not a Guth/Tao incidence or counting theorem. R:165–188 supplies the relevant algebraic justification; it can be applied componentwise as follows.

- On a projective irreducible component, a homogeneous polynomial not vanishing identically is a nonzerodivisor in its homogeneous coordinate domain. The exact sequence with multiplication by that polynomial gives the usual hypersurface-section bound \(d\deg A\). Principal ideal/dimension theory makes the reduced proper section pure of codimension one; passing to reduced support can only decrease the counted degree. Affine components are bounded by the projective section, including any contributions at infinity.
- If a component is contained in the hypersurface, retain its original degree. Summing over the current irreducible components gives
  \[
  \delta(V\cap V(f))\le\max(1,d)\delta(V)
  \]
  for a polynomial of degree at most \(d\), with the empty and identically-zero restrictions handled in the evident way. Repeating this argument bounds cuts by any fixed finite list. It does not assume every cut is proper.
- For arbitrary intersections, work first with a pair of irreducible components. The affine product has bounded degree: its total-degree associated-graded Hilbert series is the product of those of the factors. Intersect the product with the linear diagonal, retaining contained components at each linear cut. The diagonal identifies the result linearly with the original intersection. Sum this bound over component pairs. This also handles reducibility and components of different dimensions.
- If a linear projection of an irreducible \(A\) has image closure \(B\) of the same dimension, pullback injects the filtered coordinate ring of \(B\) into that of \(A\), without increasing polynomial degree. Comparing the leading coefficients of their cumulative Hilbert functions gives \(\deg B\le\deg A\). The projection need not be finite everywhere, and no assertion about behavior at the projection center at infinity is needed.

These are actual reasons for the degree bounds, not an appeal to a bounded number of equations alone. Embedded scheme components are not new objects to cover: the manuscript uses algebraic zero sets and their reduced irreducible components. Conversely, silently using only a top-dimensional degree would break the component-count conclusion.

For the actual paths, a full kernel in degree at most \(D_i\) has at most \(M_i=\binom{N+D_i}{N}\) basis elements. Therefore
\[
\delta\bigl(A_{i-1}\cap V(\mathcal K_i)\bigr)
\le \delta(A_{i-1})\max(1,D_i)^{M_i}.
\]
This remains true if some or all kernel equations vanish on a component, and if the expected dimension drop fails. No height estimate for a radical ideal or its generators is being assumed.

## 2. Descent of components not defined over \(\mathbb Q\)

M:99–116 and R:190–199 give a usable descent argument. If a geometric irreducible component \(A\) is not \(\mathbb Q\)-defined, choose an automorphism \(\sigma\) of \(\mathbb C\) fixing \(\mathbb Q\) such that \(\sigma A\ne A\). Every rational point of \(A\) is fixed by \(\sigma\), hence belongs to \(A\cap\sigma A\). Since the two irreducible varieties have the same dimension and are distinct, this is a proper closed subset of \(A\). Its degree is bounded by the intersection argument above, independently of the coefficients or of the chosen automorphism.

The assertion that such a \(\sigma\) exists is justified, not merely assumed: if every automorphism preserved \(A\), it would preserve each degree-truncated ideal space. The unique RREF basis in fixed monomial coordinates would then have every coefficient fixed by \(\operatorname{Aut}(\mathbb C/\mathbb Q)\). That fixed field is \(\mathbb Q\): nonrational algebraic elements have conjugates, and a transcendental element can be included in a transcendence basis over \(\overline{\mathbb Q}\), moved there, and the map extended to an algebraic closure. The RREF bases would therefore supply rational equations for \(A\), a contradiction.

After every subsequent intersection one must again split over \(\mathbb C\) and perform this descent when necessary. Even a rationally defined intersection can have non-rational geometric components. The recursive proof allows this; it does not presume all components remain rational after base change.

## 3. Low-degree equations have enough generic Jacobian rank

For a \(\mathbb Q\)-defined geometric irreducible \(A\), of dimension \(h\) and degree \(e'\), choose \(h\) algebraically independent coordinate functions. Every other coordinate is algebraic over their function field. Its joint image with those \(h\) coordinates has irreducible closure of dimension \(h\) in \(\mathbb A^{h+1}\), hence is a hypersurface.

The same-dimensional projection bound makes its irreducible equation \(f_j\) have total degree at most \(e'\). It must depend on its extra coordinate; otherwise it would contradict independence of the first \(h\) coordinates. In characteristic zero,
\(\partial f_j/\partial x_j\) is nonzero modulo the irreducible hypersurface equation. This follows equally from separability or from irreducibility and the smaller degree of that derivative in \(x_j\).

Lift these equations to the original ambient space. In the \(N-h\) extra coordinate columns, their Jacobian is diagonal. Each diagonal entry is nonzero in the domain \(\mathbb C[A]\), so their product is nonzero there. Thus the **degree-at-most-\(e'\) ideal piece**, not necessarily a generating set for the whole ideal, has generic Jacobian rank \(N-h\) (M:118–126; R:201–208).

This argument needs neither global smoothness nor a global complete-intersection description. A nonzero chosen minor gives local smooth coordinates on its open subset; the remaining locus, including singular points, is handled below.

## 4. Bounded-height equations from actual integer evaluations

Evaluate all \(L=\binom{N+e'}N\) monomials of degree at most \(e'\) on \(S\cap A\). The matrix \(E\) is integral and has entries of absolute value at most \(H=C_{e'}X^{a_{e'}}\). Its number of rows may be large, but its number of columns is fixed.

Let \(t=\operatorname{rank}E\). Choose \(t\) independent rows and \(t\) pivot columns with nonsingular square matrix \(P\). For each free column, put \(\det P\) in that free coordinate, zero in the other free coordinates, and solve the pivot coordinates using \(-\operatorname{adj}(P)\) times the selected column. These integer vectors form a rational basis of \(\ker E\). Each coordinate is a determinant of size at most \(t\), hence has absolute value at most \(t!H^t\). If \(t=0\), use the unit vectors; if \(t=L\), the kernel is zero. This proves the claimed height bound independently of the number of rows and of every coefficient defining \(A\).

Divide by content and fix a sign, if desired; this does not increase heights. Fixed monomial/point orders and first-admissible pivot choices make this part deterministic. RREF followed by bounded determinant clearing is another valid description; uncontrolled multiplication by arbitrary integers is not.

Let \(W=\ker_{\mathbb Q}E\) and \(I_{\le e'}(A)\) be the complex degree-truncated ideal. Since \(A\) is rationally defined, its degree pieces have rational bases, and
\[
I_{\le e'}(A)\subseteq W\otimes_{\mathbb Q}\mathbb C.
\]
There are exactly the two cases in M:137–145 and R:217–224:

- **Strict containment.** At least one of the bounded-height rational spanning polynomials of \(W\) is not identically zero on \(A\). Its zero set nevertheless contains every point of \(S\cap A\). Intersect with this polynomial, split the proper intersection into components and recurse in smaller dimension. Crucially, the proof does not claim that every equation of the original high-height variety has become small; it replaces that variety by smaller pieces still containing all relevant sample points.
- **Equality.** The bounded-height spanning polynomials actually vanish on \(A\), and their gradients supply the generic rank from section 3. Hence some \(N-h\) of them and some coordinate columns give a minor nonzero on \(A\). This is a valid patch. All uncovered points lie on the proper intersection \(A\cap V(\Delta)\), which is split and processed recursively.

Empty sampled components can be discarded. A geometric zero-dimensional rational component meeting \(S\) is precisely an integer point \(z\), not a higher-degree closed point over \(\mathbb Q\). Use \(x_j-z_j\), whose coefficients obey the box bound and whose Jacobian minor is \(1\). For \(h=N\), the empty equation list and minor \(1\) are valid.

## 5. Uniform recursion, normalization and evaluated minors

Every recursive child is in a proper subset of the current irreducible component. Degree bounds cover the conjugate intersection, the degree-\(e'\) polynomial cut, and the boundary cut by a minor of degree at most \((N-h)(e'-1)\). For example a bound of the form \(E_{\mathrm{next}}\le c_NE^2\), enlarged to handle small degrees, suffices. Each split has at most its total degree many irreducible components, and a branch has at most \(N\) strict dimension decreases. Consequently the whole list has bounded length, with uniformly bounded component and equation degrees.

At a node the cofactor construction uses only the bounded number of monomials determined by that node's degree. Thus its coefficient exponent is bounded in terms of the preceding degree bound, not in terms of the coefficients defining the node. Repeating the construction after arbitrary-coefficient component splits causes no height accumulation from those coefficients.

Each patch uses at most \(N\) integer polynomials. Differentiation multiplies coefficients by bounded degrees; a determinant uses a bounded number of bounded-degree products. Its coefficients, ordinary degree, and its evaluation at an admissible integer point are therefore all bounded by fixed powers of \(X\), with fixed constant factors. At a covered point the evaluated minor is a **nonzero integer**.

The fixed list convention must select among these bounded-height outputs and fix their integer normalization, minor and ordering (M:150–158). It can be fixed non-effectively; an implementable decomposition algorithm is not asserted. Equality of input sets, degree allowances and \(S\) then yields identical normalized outputs. Merely choosing an arbitrary deterministic rescaling, with no regard to the lemma's coefficient bounds, would not be this construction.

Apply this bound successively to the fixed-length path. The kernel intersections have the degree bound in section 1 and the patch recursion has the uniform bounds above. Fixed \(r,D_i\) therefore give fixed constants \(C_*,K_*\) with
\[
1\le\left|\prod_{j=0}^r\Delta_j(z)\right|
\le C_*X^{K_*}\le X^K\quad(X\ge2),
\]
where \(K=K_*+\max(0,\log_2 C_*)\) can be enlarged to an integer. It is independent of \(z\), all block choices, the cardinality of \(S\), and initial defining coefficients. No expected dimension drop or initial height bound was used.

## 6. Distinct-prime divisor budget

Let \(m\) be that nonzero integer product and let \(s\) distinct primes, each at least \(X^\zeta\), divide it, for fixed \(\zeta>0\). Their product divides \(|m|\), so
\[
X^{\zeta s}\le\prod_{j=1}^s q_j\le |m|\le X^K,
\qquad s\le \lfloor K/\zeta\rfloor.
\]
This counts distinct primes, not multiplicities. It holds separately and uniformly for every actual path, even though its minor product may depend on the selected primes. It uses no independence assertion or conditioning on record stability (R:246–255). The fixed-degree, fixed-length premise is what permits \(K\) to be fixed before \(\zeta\). The subsequent sampling error formula and constant scheduling in R:257–266 belong to other units and were not rederived here.

## Assessment and concrete remaining obligations

- **Complete within the explicit hypotheses:** cofactor/Cramer height control; the strict/equal nullspace dichotomy; low-degree generic Jacobian rank; coverage of singular/exceptional and non-rational pieces; finite recursion; integer clearing and normalization; evaluated-product height and the divisor budget. These arguments explain the initial-coefficient independence rather than presupposing it.
- **Standard geometric input, not a checked external citation:** irreducible decomposition and dimension theory, the Hilbert-polynomial hypersurface bound, product/intersection degree bounds, and the same-dimensional projection inequality. The precise package is stated and justified above. No uncited global smoothness, complete-intersection, generic finite-projection-everywhere, or bounded radical-generator-height assumption is needed. No Guth/Tao result is imported.
- **Hypothesis matching discharged:** M:20-24 expressly controls the sum over all geometric components, and M:37-68 supplies the fixed weighted-box and initial-complexity hypotheses. The hypothetical top-dimensional-degree obstruction does not apply to this manuscript. Common cut degrees remain fixed inputs to this unit; their scheduling is assessed in cumulative-products, not obtained from a new proof of the residue-cut lemma.
- **No independent or whole-paper acceptance:** initial theorem hypotheses, residue cuts, deletion/probability proof, prime-pool/product scheduling, counting and all full-paper consequences remain outside this unit. No formalization or computation was claimed to establish the geometry. The finite old exact certificate was not rerun and does not resolve these universal obligations. The official graph-checker blocker was not bypassed.

No mathematical counterexample to the coefficient-free patch construction was found in the assessed argument. The supported conclusion uses the explicit total-component degree premise actually stated by the manuscript, not a blanket correctness claim for the manuscript. Native Host-invoked independent review is still required. Novelty is **not established**.
