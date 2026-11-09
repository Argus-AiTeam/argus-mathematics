# Nuclear finiteness: scoped analytic audit

## Exact question and source facts

The source is OpenAI, *An explicit obstruction to nuclear norm-ultrapower
embeddings*, September 23, 2026, staged in
`research/openai_manuscript/An-explicit-obstruction-to-nuclear-norm-ultrapower-embeddings-September-23-2026/build/`.
This audit concerns `nuclear-finiteness.tex`, not the complete nonembedding
theorem.

Let \(S\) be a nonempty finite generating set of a discrete group \(\Gamma\),
let \(m=|S|\), and assume \(0<\kappa\leq 4m\) and
\[
 \sum_{s\in S}\|\rho(s)v-v\|^2\geq\kappa\|v\|^2                 \tag{G}
\]
for every unitary representation with no nonzero invariant vector, on
arbitrary Hilbert spaces. Write
\[
 L(z)=\sum_s(z_s-1)^*(z_s-1),\qquad
 d(u,\pi)=\min\operatorname{spec} L((u_s\otimes\bar\pi(s))_s),
 \qquad b=\frac{\kappa^2}{4m}.
\]
The exact target is
\[
 \liminf_j d(u,\pi_j)\geq b,                                  \tag{E}
\]
for every nonzero unital complex nuclear \(C^*\)-algebra \(B\), every
unitary \(S\)-tuple \(u\) in \(B\), and every sequence of pairwise
inequivalent nonzero finite-dimensional irreducible unitary
representations \(\pi_j\) of \(\Gamma\). Dimensions are unrestricted.
There is no separability condition on \(B\) and no relation condition on
the tuple. Nuclearity is used in its tensor-norm formulation.

The following are source assertions, not conclusions earned by this audit.

| Claim | Source label | Obligation |
|---|---|---|
| C292_MAIN | `thm:main` | The explicit full group algebra cannot embed unitally into any nuclear norm ultrapower. |
| C292_GROUP | `lem:group-data` | The dyadic affine group data, index eight, property (T), and aperiodic irreducible representation. |
| C292_SPECTRAL | `lem:spectral-gap` | The group spectral gap and its representation-matching interpretation. |
| C292_SQRT | `lem:square-root-trace` | Square-root trace inequality on arbitrary Hilbert spaces. |
| C292_WEAK | `lem:weak-mixing-bound` | The lower bound \(b\) for an arbitrary first-factor unitary tuple. |
| C292_CORONA | proof of `lem:nuclear-finiteness`, first half | The matrix corona representation has no finite-dimensional subrepresentations. |
| C292_TRANSFER | proof of `lem:nuclear-finiteness`, second half | Nuclearity gives a map **from** the spatial tensor product **to** the coordinate quotient. |
| C292_ESCAPE | proof of `lem:nuclear-finiteness`, final display | The full quantified assertion (E). |
| C292_FINITE | `lem:nuclear-finiteness` | Only finitely many irreducible types have \(d(u,\pi)<a<b\). |
| C292_VARYING | `lem:varying-gap` | The ultralimit spectral gap for every varying-dimensional representation sequence. |
| C292_INITIAL | `lem:initial-match` | The distinguished representation occurs in the coordinate matching sets on an ultrafilter-large set. |
| C292_PREDECESSOR | `lem:uniform-predecessor` | Simultaneous predecessor closure on one ultrafilter-large set. |
| C292_CYCLE | `lem:finite-predecessor-cycle` | Finite predecessor closure implies periodicity for every starting irreducible type. |

The other manuscript obligations remain open in the campaign; recording them
does not verify them.

## Prior knowledge and source availability

The manuscript explicitly presents the quotient method as Wassermann's
property-(T) method and the reduced-density argument as quantitative
Bekka/Powers--Stormer reasoning. Verification of these arguments is not a
novelty claim. A targeted search of the shared Wiki index found no page
matching nuclearity, Kirchberg, weak mixing, or this tensor-product route.

The primary Takesaki PDF was obtained from
<https://www.jstage.jst.go.jp/article/tmj1949/16/1/16_1_111/_pdf>.
Its canonical identifier is `doi:10.2748/tmj/1178243737`.
Page 111 defines condition (T) by uniqueness of the spatial cross-norm for
every second \(C^*\)-algebra; page 112, Lemma 1, identifies a tensor
representation with commuting representations of the factors. Takesaki's
condition (T) here is a **tensor-norm** condition, not Kazhdan's group
property (T).

The initial Project Euclid PDF endpoints for Powers--Stormer returned HTML
rather than a PDF. The AMS endpoint for Valette returned HTTP 403. Neither
failure is evidence against the cited mathematics. An automated search
summary incorrectly substituted trace norm for Hilbert--Schmidt norm in
the square-root inequality; that summary is not used as a source.

## Evidence boundary

A proof of (E) must check the conjugate/intertwiner orientation, the
finite-dimensional-subrepresentation exclusion, the infinite-dimensional
trace operations, and the direction and continuity of the tensor-product
map. Finite matrix experiments cannot establish (E). Any executable
certificate will distinguish exact algebraic checks from the analytic
proof and its foundational dependencies. Independent Reviewer approval is
required and has not yet been obtained.

## Result: full quantified escape theorem

**Theorem.** Under exactly the hypotheses above, (E) holds. Consequently,
for every real \(a<b\), only finitely many irreducible equivalence classes
satisfy \(d(u,\pi)<a\). This verifies the analytic assertion in the
manuscript; it is not asserted to be a new theorem or a verification of
the entire manuscript.

The proof uses the stated gap (G) as a hypothesis. Its background analytic
tools are the compact-operator spectral theorem, basic trace-ideal
calculus, faithful unital Hilbert-space realizations of \(C^*\)-algebras,
and continuous functional calculus. These are not conclusions of the
finite executable checks. The only specifically cited tensor-norm input
is the definition of nuclearity discussed above. The proof below derives
the square-root inequality rather than assuming either the weak-mixing
bound or the escape theorem.

### P0. The spectral matching assertion used in the decomposition

For any genuine unitary representation \(\rho\), its invariant subspace
and orthogonal complement reduce every \(\rho(g)\). The Laplacian is
zero on the former and at least \(\kappa1\) on the latter by (G);
it is at most \(4m1\) everywhere. A faithful unital realization preserves
spectra, giving `lem:spectral-gap`. For
\(\rho\otimes\bar\pi\), the identification in P3, now with arbitrary
target Hilbert space, identifies invariants with maps
\(A:V_\pi\to H\) satisfying \(\rho(g)A=A\pi(g)\).
Since \(\pi\) is irreducible, a nonzero such map has
\(A^*A=c1\) for \(c>0\), and hence yields an isometric intertwiner after
rescaling. Thus the Laplacian minimum is zero exactly when \(\pi\)
occurs; otherwise it is at least \(\kappa\). The spectral gap excludes
zero as a noneigenvalue spectral minimum.

### P1. Trace operations and the square-root inequality

If \(A,B\) are Hilbert--Schmidt, \(AB\) is trace class and
\(\|AB\|_1\leq\|A\|_2\|B\|_2\). Finite-rank approximation in
Hilbert--Schmidt norm therefore justifies
\(\operatorname{Tr}(AB)=\operatorname{Tr}(BA)\), including insertions of a
bounded operator. A product of positive Hilbert--Schmidt operators has
nonnegative trace: diagonalize one of them and sum its nonnegative
eigenvalues times the nonnegative diagonal entries of the other.
Absolute convergence follows from the same ideal estimate.

Let \(X,Y\geq0\) be Hilbert--Schmidt and put \(F=X-Y\),
\(J=\operatorname{sgn}F\), with \(J=0\) on the kernel and
\(\|J\|\leq1\). Then
\[
 D=X^2-Y^2=FX+YF,\qquad JF=FJ=|F|.
\]
All the following products are trace class. Trace-norm duality and the
cyclic identities just justified give
\[
 \|D\|_1\geq|\operatorname{Tr}(JD)|
 =\operatorname{Tr}(|F|(X+Y)).
\]
The last equality is legitimate because the expression on the right is
real and nonnegative. More explicitly, writing \(F=F_+-F_-\), the exact
remainder identity is
\[
 \operatorname{Tr}(|F|(X+Y))-\operatorname{Tr}(F^2)
 =2\operatorname{Tr}(F_+Y)+2\operatorname{Tr}(F_-X)\geq0.
\]
Indeed, pair \(X+Y-F=2Y\) with \(F_+\), and
\(X+Y+F=2X\) with \(F_-\). Thus
\[
 \|X-Y\|_2^2\leq\|X^2-Y^2\|_1.                         \tag{1}
\]
No operator-order assertion \(|X-Y|\leq X+Y\) is needed.

Every Hilbert--Schmidt operator is compact and has separable closed
range. For the self-adjoint \(X,Y\), both operators vanish on the
orthogonal complement of the separable closure of their ranges.
Consequently the finite-rank/trace arguments work in an arbitrary
ambient Hilbert space, not just a separable one.

The publisher's Powers--Stormer endpoint also returned HTML rather than
a PDF. The original Lemma 4.1 was therefore not independently read here.
It is a bibliographic attribution, not an undischarged dependency of
(1), whose proof is given above. Bekka's and Valette's results are likewise
not invoked to establish the quantitative bound.

### P2. Arbitrary first-factor unitaries

Let \(\sigma:\Gamma\to\mathcal U(K)\) have no nonzero finite-dimensional
subrepresentation. Conjugation
\[
 A\longmapsto\sigma(g)A\sigma(g)^*
\]
is a unitary representation on \(\mathcal S_2(K)\). It has no nonzero
invariant vector. Otherwise a nonzero invariant \(A\) would yield a
nonzero positive compact invariant \(|A|\). A nonzero eigenvalue of
\(|A|\) has a nonzero finite-dimensional eigenspace preserved by every
\(\sigma(g)\), a contradiction. This argument also applies when \(K\)
is nonseparable.

Fix a unit vector \(\xi\in E\otimes K\). It belongs to the tensor product
of separable subspaces: take a sequence of finite sums of elementary
tensors converging to it and close the spans of their factors.
An orthonormal expansion in the first factor has the form
\[
 \xi=\sum_i e_i\otimes v_i,\qquad \sum_i\|v_i\|^2=1.
\]
Define \(T=\sum_i |v_i\rangle\langle v_i|\). The positive summands
have summable trace norms, so this series converges in trace norm,
\(T\geq0\), and \(\operatorname{Tr}T=1\). With inner products linear
in the first variable,
\[
 \operatorname{Tr}(TC)=\langle(1\otimes C)\xi,\xi\rangle
 \quad(C\in\mathcal B(K)).
\]

For arbitrary unitaries \(U_s\) on \(E\), put
\(\xi_s=(U_s\otimes\sigma(s))\xi\) and
\(\delta_s=\|\xi_s-\xi\|\). The reduced density of \(\xi_s\) is
\[
 T_s=\sigma(s)T\sigma(s)^*,                                  \tag{2}
\]
because conjugating \(1\otimes C\) cancels \(U_s^*U_s\).
In particular there is no assumption that the \(U_s\) extend to a group
representation. For every \(\|C\|\leq1\), subtracting the vector
expectations and adding one cross term gives an absolute value at most
\(2\delta_s\). Trace-class duality therefore gives
\[
 \|T_s-T\|_1\leq2\delta_s.
\]
Applying (1) to \(T_s^{1/2}\) and \(T^{1/2}\), and using functional
calculus to identify the former, gives
\[
 \|\sigma(s)T^{1/2}\sigma(s)^*-T^{1/2}\|_2^2
 \leq2\delta_s.                                             \tag{3}
\]
Here \(T^{1/2}\) is Hilbert--Schmidt of norm one, although it need not
be trace class. Applying (G) to the conjugation representation and then
Cauchy--Schwarz yields
\[
 \kappa\leq2\sum_s\delta_s
 \leq2\sqrt{m}\Big(\sum_s\delta_s^2\Big)^{1/2}.
\]
All terms are nonnegative and \(m>0\), so
\[
 \sum_s\delta_s^2\geq\frac{\kappa^2}{4m}=b.                   \tag{4}
\]
Since this holds for every unit vector,
\(L((U_s\otimes\sigma(s))_s)\geq b1\).
If \(E\otimes K=0\), that operator inequality is vacuous.
This proves the full arbitrary-tuple weak-mixing bound.

### P3. Exclusion of every finite-dimensional subrepresentation

For the given sequence \(\pi_j\), put
\[
 M_j=\mathcal B(\bar V_{\pi_j}),\quad
 P=\prod_jM_j,\quad I=\{(a_j):\|a_j\|\longrightarrow0\},
 \quad Q=P/I,\quad q(g)=[(\bar\pi_j(g))_j].
\]
The product is the bounded product. Since all \(V_{\pi_j}\ne0\),
the identity sequence does not belong to \(I\); hence \(Q\ne0\).
The coordinate relations make \(q\) a genuine unitary group
representation in \(Q\).

Fix any nonzero finite-dimensional irreducible \(\tau\), of dimension
\(d\). There is a unitary identification
\[
 \bar V_{\pi_j}\otimes\bar V_\tau
 \longrightarrow\mathcal S_2(V_\tau,\bar V_{\pi_j}),
 \qquad h\otimes\bar v\longmapsto(w\longmapsto\langle w,v\rangle h).
\]
It sends \(\bar\pi_j(g)\otimes\bar\tau(g)\) to the operation
\[
 A\longmapsto\bar\pi_j(g)A\tau(g)^*.
\]
Thus an invariant vector is exactly an intertwiner
\(\tau\longrightarrow\bar\pi_j\), **not**
\(\tau\longrightarrow\pi_j\). The exceptional condition is
\(\pi_j\simeq\bar\tau\). A nonzero intertwiner between finite-dimensional
irreducibles is an isomorphism: its kernel and range are invariant, and
its polar decomposition yields unitary equivalence. Pairwise
inequivalence permits at most one exceptional \(j\). For all other \(j\),
(G) gives
\[
 L((\bar\pi_j(s)\otimes\bar\tau(s))_s)\geq\kappa1.             \tag{5}
\]

For this **fixed** \(d\), entrywise amplification gives
\[
 M_d(Q)\ \cong\
 \prod_j M_d(M_j)\big/\{(z_j):\|z_j\|\longrightarrow0\}.       \tag{6}
\]
To see both the surjectivity and the kernel, use the inequalities
\[
 \max_{a,c}\|z_{ac}\|\leq\|z\|
 \leq d\max_{a,c}\|z_{ac}\|.
\]
Boundedness, or convergence to zero, of the matrix sequence is
equivalent to that of all its finitely many entries. The entrywise
identification is a bijective unital star-homomorphism, and hence is
isometric. Since the second factor is \(M_d\), its tensor norm is
unique. This argument does not bound \(\dim\pi_j\).
Removing the one exceptional coordinate in (5) changes only an element
of the zero ideal in (6). Consequently
\[
 L((q(s)\otimes\bar\tau(s))_s)\geq\kappa1
 \quad\hbox{in }Q\otimes M_d.                               \tag{7}
\]

For any unital representation \(\eta:Q\to\mathcal B(K)\), (7) survives
under its matrix amplification. If \(\sigma=\eta q\) contained
\(\tau\), the vector \(\sum_{a=1}^d We_a\otimes\bar e_a\), where \(W\)
is an isometric intertwiner, would be a nonzero invariant vector for
\(\sigma\otimes\bar\tau\), contradicting (7). Every nonzero
finite-dimensional unitary representation has an irreducible summand,
so \(\sigma\) has none. Different \(\tau\)'s may have different
exceptional coordinates; no common exceptional index is required.

### P4. Correct direction of the tensor-product map

Choose faithful unital Hilbert-space realizations of \(B\) and \(Q\).
Their spatial tensor realization is faithful for \(B\otimes_{\min}Q\).
By P2 and P3,
\[
 \mathcal L=L((u_s\otimes q(s))_s)\geq b1
 \quad\hbox{in }B\otimes_{\min}Q.                            \tag{8}
\]
No representation dimension or separability restriction entered this
step.

Define \(C_j=B\otimes M_j\), and form their bounded-product quotient
\(C=\prod_j C_j/c_0(C_j)\). The formulas
\[
 \alpha(x)=[(x\otimes1)_j],\qquad
 \beta([(y_j)_j])=[(1_B\otimes y_j)_j]
\]
define commuting unital star-homomorphisms into \(C\).
The second map is well defined because
\(\|1_B\otimes y_j\|=\|y_j\|\); nonzero unital \(B\) is used here.
The universal property of the **maximal** tensor product gives
\[
 \Psi_{\max}:B\otimes_{\max}Q\longrightarrow C,\qquad
 x\otimes[(y_j)]\longmapsto[(x\otimes y_j)].
\]
Nuclearity identifies the maximal and minimal completions canonically.
In particular the canonical map from maximal to minimal is an
isomorphism, and its inverse allows composition with \(\Psi_{\max}\).
The resulting map \(\Psi:B\otimes_{\min}Q\to C\) is unital and positive,
so it sends (8) to
\[
 [(L_j)_j]\geq b1,\qquad
 L_j=L((u_s\otimes\bar\pi_j(s))_s).                          \tag{9}
\]
Injectivity or surjectivity of \(\Psi\) is not asserted or needed.
There is no identification of \(B\otimes_{\min}Q\) with the full
coordinate quotient, nor any unproved continuity assertion for a map
in the reverse direction.

The precise primary-source input for the tensor-norm hypothesis is
Takesaki (1964), p.111, condition (T):

> For every \(C^*\)-algebra \(\mathfrak A_2\), T-cross norm of
> \(\mathfrak A_1\odot\mathfrak A_2\) is the unique compatible norm.

This is the historical notation for the uniqueness property used here;
it must not be read as a statement about Kazhdan groups. The universal
property of the maximal completion is part of its definition.

### P5. Functional calculus gives the ordinary liminf

Each \(L_j\) is positive and has norm at most \(R=4m\), since a unitary
has distance at most two from the identity. Thus \((L_j)\) is a bounded
sequence. Let \(f(t)=\max(b-t,0)\), continuous on \([0,R]\).
Coordinate evaluation and quotient maps commute with continuous
functional calculus. Equation (9) gives
\[
 [(f(L_j))_j]=f([(L_j)_j])=0.
\]
Zero in this quotient means exactly that
\(\|f(L_j)\|\to0\) in the **ordinary** sequence sense, not merely along
an ultrafilter. Each \(C_j\) is nonzero and unital, so its positive
element \(L_j\) has a nonempty compact spectrum and an attained spectral
minimum \(d_j=d(u,\pi_j)\). The spectral norm formula gives
\[
 \|f(L_j)\|=\max(b-d_j,0)\longrightarrow0.                  \tag{10}
\]
For any \(\varepsilon>0\), eventually (10) is less than
\(\varepsilon\), which implies \(d_j>b-\varepsilon\).
Therefore \(\liminf_j d_j\geq b\), proving (E).

### P6. Finiteness and quantifier checks

If infinitely many distinct irreducible equivalence classes had
\(d(u,\pi)<a<b\), select a countable sequence of them. Such a sequence
contradicts (E), since its liminf is at most \(a\).
For \(a\leq0\) the set is empty by positivity. This proves finiteness
for every real \(a<b\), and therefore at the manuscript's threshold.
Equality \(d=b\) is deliberately not excluded by the proof.

No step asks the fixed tuple to satisfy any relation. Only the
representations \(\pi_j,\tau,\sigma\) and the conjugation representation
use group relations. The only fixed matrix size in the quotient
argument is \(\dim\tau\), chosen separately for each test irreducible.
All representations \(\pi_j\) retain unrestricted dimensions. Faithful
representations, tensor products, and the trace argument work without
separability of \(B\). If the group has only finitely many irreducible
finite-dimensional types, the sequence hypothesis is vacuous and
finiteness is immediate.

## Exact executable checks and limits

`verify.py` checks noncommutative cancellation, complex conjugate/
intertwiner orientation (including a non-self-conjugate character),
reduced-density conjugation, the square-root inequality on exact
noncommuting positive matrix examples, and the scalar inequalities and
cutoff formula. The Jacobian operation
`matrix.symbolic.multiply.compute` independently expands the block
product \([X-Y\ \ Y]\,[X;\ X-Y]=X^2-Y^2\) for generic symmetric
two-by-two matrices. Its exact input and typed output are preserved in
`exact_certificate.json`; an offline replay checks that output without
contacting the sidecar.

The local run contains 64 ordered pairs of exact positive two-by-two
matrices, including 28 noncommuting pairs, 776 rational scalar bound
cases, and 16 exact cutoff cases. For the finite square-root tests the
trace norm of the Hermitian two-by-two matrix \(D=X^2-Y^2\) is checked
without numerical eigenvalues: its square is
\(\operatorname{Tr}(D^2)+2|\det D|\).
Both sides of the tested inequality are nonnegative, so comparison
after squaring is equivalent in these cases. The three trace-remainder
tests have dimensions 2, 3, and 5; the last two explicitly include
the kernel of \(F\).

These are exact algebraic and finite adversarial checks, **not** a
machine proof of compact spectral theory, the infinite-dimensional
trace argument, tensor-norm continuity, or (E). P1--P6 supply the full
mathematical proof of (E) and require independent human/Reviewer reading.
There is no Lean formalization: a scalar-only Lean theorem would not
formalize the load-bearing analytic assertion. No manuscript flaw has
been confirmed in this scoped argument, so no refutation claim is
manufactured. The varying-dimensional ultrapower gap, simultaneous
predecessor closure, and final nonembedding theorem remain outside this
verification. Campaign-level originality and completion remain open.

The offline command
`$WORKSPACE/argus-live-update/.venv/bin/python verify.py`
exited zero. Focused in-memory corruption tests also rejected a changed
Jacobian coefficient, a timeout flag, and a mismatched request. These do
not rerun or expand the finite search. The cited tensor-norm definition
has been read in the primary source, but the ledger's
`A292_NUCLEAR_NORM` still awaits **independent** citation attribution.
Engineer support is not independent Reviewer approval; graph nodes stay
open until that review.
