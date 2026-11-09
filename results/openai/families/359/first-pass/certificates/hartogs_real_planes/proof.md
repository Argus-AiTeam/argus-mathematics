# Real-plane Hartogs curvature

## Scope and known status

The target is the fixed-bound, eventual-threshold assertion `pinch:positivity`
in the staged threefold manuscript, Section 09. Its quantifiers allow arbitrary
Kahler error tensors of the specified types and fixed component bounds. A bad
finite value of lambda, or a family whose error bound grows with lambda, would
not refute this assertion.

The source's Sections 08-09 already give a tensor calculation, a limiting
mixed-plane equality classification, and a compactness proof of eventual
negativity. These are assertions under audit, not independently established
premises. The proposed improvement is an exact quantitative coercivity argument
covering every real plane, x=0, x unbounded, and lambda comparable to x^(3/2).
Neither the positive-density construction in Sections 04-06 nor any part of
the separate one-sided construction follows from this local calculation.

No external curvature theorem is assumed in the proof below. Its linear
algebra consists of diagonalizing a positive definite two-by-two Hermitian
matrix, Cauchy--Schwarz, and determinants of two-by-two real Gram matrices.
No false staged assertion was established in this scoped investigation.
The inherited Wiki index has no matching Hartogs or sectional-pinching topic.

## Quantitative theorem

Use the conventions and tensors of `pinch:positivity`, with the **full complex
component Frobenius norm** for the errors. Fix \(0<c\le C\) and \(e\ge0\), and set
\[
 B_0=1+2e+16e^2/c+2C^2,\qquad
 \Lambda=\max\{1,C,1+2e+41C^2+16e^2/c,\,
                    8B_0^2(B_0+C)/c^3\}.
\]
For every \(\lambda\ge\Lambda\), every \(x\ge0\), every horizontal
\(cI\le h\le CI\), and every reality-compatible Kahler tensor pair supported
on respectively four and three horizontal slots with
\(\|T_4\|_F\le ex\), \(\|T_3\|_F\le e\sqrt{x(1+x)}\), define
\[
 q=x(1+x),\quad G=\lambda I+xh,\quad
 D=(1+2x)h-qhG^{-1}h,
\]
\[
 R=-\lambda S_I-qS_h-S_V-(S_{D+V}-S_D-S_V)+T_4+T_3.
\]
Every real two-plane, for the metric convention \(g=2\operatorname{Re}(G+V)\),
satisfies
\[
 -B_{\rm curv}\le K\le-A_{\rm curv}<0,
\]
where the following explicit, deliberately nonoptimal constants suffice:
\[
 H_0=2+2C^2+(4C^2+2)/c,\qquad
 \eta=\min\{c^3/[8(\lambda+C)],1/8\},
\]
\[
 A_{\rm curv}={\min\{1,c/2,\eta/H_0\}\over2(\lambda+C)^2},\qquad
 B_{\rm curv}={4\lambda+8C^2+2+24C+3e\over\min(c/2,1)^2}.
\]
Here \(K=\mathcal H_R/(2a_{G+V})\). For arbitrary algebraic data this is a
sectional quotient; when \(R\) is the Hartogs curvature tensor it is the real
sectional curvature. Every other fixed Euclidean component-norm convention
gives the same theorem after its explicit finite-dimensional norm-equivalence
factor is incorporated into e.

This strengthens the staged core by giving a coercive mixed-block inequality,
an explicit threshold, and explicit two-sided curvature bounds. It is not a
refutation of `pinch:positivity`, which is consistent with the result.

**Dimension-free extension.** The same algebraic theorem and the same constants
hold on \(\mathbb C^n\oplus\mathbb C\), for every n>=1, with h positive definite
on the horizontal factor and the same full Frobenius error bounds. The
constants do not depend on n. The actual metric-jet audit below concerns the
staged threefold, n=2; the extension concerns every tensor of the displayed
form and its sectional quotient, without asserting a new global manifold
construction.

## 1. Independent tensor and normalization calculation

The source is the staged threefold
`build/sections/08-curvature.tex`. At a point off the zero section use the
holomorphic gauge
\(s=v+\bar v+\widetilde\phi\), where
\(s_i=s_{ik}=0\), \(s_v=1\), and \(s_{i\bar j}=h_{i\bar j}\).
The degree-four Taylor jet of the base potential is
\(\psi=|z|^2+|z|^4/2+O(|z|^6)\).
For \(F(s)=-\log(1-e^s)\), its first four derivatives are
\[
 x,\quad q,\quad q(1+2x),\quad q(1+6x+6x^2).
\]
Write \(A_{ik\bar j}=\phi_{ik\bar j}\) and
\(B_{ik\bar j\bar l}=\phi_{ik\bar j\bar l}\).
Taylor multiplication through degree four gives the following complete
derivative lists of the needed types, up to permutations:
\[
 K_{ik\bar j}=xA_{ik\bar j},\quad
 K_{iv\bar j}=qh_{i\bar j},\quad K_{vv\bar v}=q(1+2x),
\]
\[
 K_{ik\bar j\bar l}=\lambda(S_I)_{i\bar j k\bar l}
                     +xB_{ik\bar j\bar l}+q(S_h)_{i\bar j k\bar l},
\]
\[
 K_{ik\bar j\bar v}=qA_{ik\bar j},\quad
 K_{iv\bar j\bar v}=q(1+2x)h_{i\bar j},\quad
 K_{vv\bar v\bar v}=q(1+6x+6x^2).
\]
The missing types vanish. Pure horizontal third derivatives need not vanish:
their bidegrees prevent them from entering these lists.

Substitute these jets into
\[
 R_{a\bar b c\bar d}=-K_{ac\bar b\bar d}
  +\sum_{p,e}(G_{\rm full}^{-1})_{ep}K_{ac\bar e}K_{p\bar b\bar d}.
\]
The displayed inverse is transposed relative to its superscript index array.
After replacing \(\partial_v\) by \(q^{-1/2}\partial_v\), this gives exactly
the R above, with
\[
 (T_4)_{i\bar j k\bar l}
 =-xB_{ik\bar j\bar l}
  +x^2\sum_{p,e}(G^{-1})_{ep}A_{ik\bar e}\overline{A_{jl\bar p}},
\]
\[
 (T_3)_{i\bar j k\bar0}
 =\sqrt q\left(-A_{ik\bar j}
          +x\sum_{p,e}(G^{-1})_{ep}A_{ik\bar e}h_{p\bar j}\right).
\]
The remaining blocks are \(R_{i\bar j0\bar0}=-D_{i\bar j}\),
\(R_{i\bar0k\bar0}=R_{i\bar00\bar0}=0\), and
\(R_{0\bar00\bar0}=-2\).
In particular, the raw vertical numerator is
\[
 -q(1+6x+6x^2)+q(1+2x)^2=-2q^2.
\]
Since \(\|G^{-1}\|\le(\lambda+cx)^{-1}\), bounded A,B give
\(\|T_4\|\le C_4x\), \(\|T_3\|\le C_3\sqrt q\).
On an h-eigendirection with eigenvalue d,
\[
 D/h=1+2x-\frac{x(1+x)d}{\lambda+xd}.
\]
Thus \((1+x)h\le D\le(1+2x)h\) whenever \(\lambda\ge C\).

At the zero section use a regular normalized fiber coordinate W. The entire
relevant Taylor jet is
\[
 K=\lambda(|z|^2+|z|^4/2)+|W|^2(1+h_{i\bar j}z_i\bar z_j)
       +|W|^4/2.
\]
Its metric is \(\operatorname{diag}(\lambda I,1)\); the third derivatives
used by curvature vanish. The curvature is
\(-\lambda S_I\) horizontally, \(-h\) in the balanced mixed block, and
\(-2\) vertically. All other types vanish. This proves the x=0 formula
without extending a singular logarithmic coordinate.

For any real pair \(U_j=u_j+\bar u_j\), put
\(\Xi^{a\bar b}=u_1^a\bar u_2^b-u_2^a\bar u_1^b\).
Expanding a reality-compatible Kahler tensor using its two holomorphic and
two antiholomorphic symmetries gives
\[
 \mathcal H_T=-\tfrac12 T_{a\bar b c\bar d}\Xi^{a\bar b}\Xi^{c\bar d}.
\]
The real numerator is \(2\mathcal H_R\), while the squared real area is
\(4a_{G+V}\), proving the normalization in the theorem.
For a Hermitian P direct multiplication gives
\(\mathcal H_{S_P}=a_P+3b_P^2\).
Consequently, with \(F_{\rm num}=-\mathcal H_R\),
\[
 F_{\rm num}=\lambda(a_I+3b_I^2)+q(a_h+3b_h^2)+4a_V+
                 m_D+6b_Db_V-\mathcal H_{T_4}-\mathcal H_{T_3}.       \tag{1}
\]
The disk normalization gives real curvature -2, rather than -1 or -4.

`verify.py` constructs these Taylor jets independently, allowing a generic
off-diagonal complex h, arbitrary A,B, and pure third horizontal terms. It
checks all 81 curvature components off the zero section and all 81 at it.
It also verifies the contraction for a generic Hermitian six-by-six matrix
on symmetric holomorphic index pairs, not just for a selected model tensor.

## 2. A global mixed-block sum-of-squares bound

For a horizontal h set
\[
 C_h=m_h+2b_hb_V
   =\sum_{i,j}h_{i\bar j}\Xi^{i\bar0}
                                  \overline{\Xi^{j\bar0}}\ge0.
\]
The needed strengthening of the staged equality classification is
\[
                 \boxed{h\le E\le2h\quad\Longrightarrow\quad
                         P_h(E)\ge C_h.}                         \tag{2}
\]
It is a statement about every real pair, including degenerate projections.

Make h the identity by its positive square root, then diagonalize E by a
unitary horizontal transformation. Such transformations preserve all
quantities in (2). The two eigenvalues e1,e2 lie in [1,2].
For horizontal dimension n>2 first restrict h and E to the complex span of
the two horizontal projected vectors. Its complex dimension is at most two,
and every quantity in (2) depends only on these restrictions. In dimension
one, adjoin a zero second vector coordinate and let the extra eigenvalue be
one. Thus the same two-dimensional calculation proves (2) in every n>=1.
Write the horizontal coordinates of the two vectors as u1,u2 and v1,v2,
and their vertical coordinates as z,w. Put
\[
 b_i=\operatorname{Im}(u_i\bar v_i),\quad r=\operatorname{Im}(z\bar w),
\]
\[
 d=|u_1v_2-u_2v_1|^2,\quad
 c_i=|u_i\bar w-v_i\bar z|^2,\quad
 c_{12}=|u_1\bar v_2-v_1\bar u_2|^2=d+4b_1b_2.
\]
All d,ci,c12 are nonnegative, and \(C_h=c_1+c_2\). Expansion gives
\[
 P(e_1,e_2)=d+4(b_1+b_2)^2+4r^2+
                    e_1(c_1+4b_1r)+e_2(c_2+4b_2r).
\]
The four corners have the exact identities
\[
\begin{aligned}
 P(1,1)&=c_{12}+c_1+c_2+2(b_1+b_2+r)^2+
                                      2(b_1^2+b_2^2+r^2),\\
 P(1,2)&=c_{12}+c_1+2c_2+(2b_1+b_2+r)^2+3(b_2+r)^2,\\
 P(2,1)&=c_{12}+2c_1+c_2+(b_1+2b_2+r)^2+3(b_1+r)^2,\\
 P(2,2)&=d+2(c_1+c_2)+4(b_1+b_2+r)^2.
\end{aligned}                                                    \tag{3}
\]
Every corner is at least c1+c2. Because P is affine in the eigenvalues,
its bilinear interpolation with weights
\((2-e_1)(2-e_2),(2-e_1)(e_2-1),(e_1-1)(2-e_2),(e_1-1)(e_2-1)\)
is an exact identity. The weights are nonnegative and sum to one.
This proves (2). The vector-to-scalar identities are checked with all twelve
real vector components free by `verify.py`; the scalar identities and the
universal implication are also encoded in `Hartogs.mixed_coercivity`.

For later use put
\[
 A=a_h,\quad U=a_V,\quad a=\sqrt A,\quad t=\sqrt U,\quad
 s=\sqrt{A+3b_h^2},\quad S=(s-2t)^2.
\]
If \(h\le E\le(2-\delta)h\), \(0\le\delta\le1\), then also
\[
                       P_h(E)\ge S+2\delta at.                    \tag{4}
\]
Here is a direct proof, not an assumption of `pinch:square`.
When A>0, real-orthonormalize the horizontal projected pair for h.
The h-norms squared of its sums and differences with i are
\(2(1\pm|b_h|/\sqrt A)\). Comparing their E-norms using the lower
and upper form bounds gives
\[
 |b_E|\le (a+3|b_h|)/2-\delta(a+|b_h|)/2
          \le s-\delta a/2.
\]
The last step follows by squaring:
\(4s^2-(a+3|b_h|)^2=3(a-|b_h|)^2\).
For two positive semidefinite real two-by-two Gram matrices,
\(m_E\ge2\sqrt{a_EU}\ge2|b_E|t\).
Indeed, after conjugating the first matrix to the identity, the assertion
is \(\operatorname{tr}B\ge2\sqrt{\det B}\); diagonalizing B proves it,
and continuity includes singular matrices. Hence
\[
 P_h(E)\ge s^2+4t^2-4|b_E|t\ge S+2\delta at.
\]
If A=0 the horizontal projected vectors are real dependent, so \(b_E=0\);
if U=0 then \(b_V=0\). The same inequality follows directly in either
case. No division by a projected area is retained in (2) or (4).

Two scalar estimates used below are
\[
 t^2\le2a^2+S/2,\quad at\le2a^2+S/4,                            \tag{5}
\]
\[
 S/4+\delta at\ge\delta a^2/4.                                  \tag{6}
\]
For (5), \(s^2\le4a^2\) and
\[
 2a^2+S/2-t^2=(s-t)^2+(4a^2-s^2)/2\ge0;
\]
then apply \((a-t)^2\ge0\). For (6) use the exact nonnegative decomposition
\[
 S/4+\delta at-\delta a^2/4
 =\left(t-\frac{s-\delta a}{2}\right)^2
   +\frac{\delta a(s-a)}2+\frac{\delta(1-\delta)a^2}4 .
\]

## 3. Errors and the bounded interval \(0\le x\le1\)

In the original frame the Xi identities give
\[
 \|\Xi_{HH}\|_F^2=2(a_I+b_I^2)\le4a_I,\qquad
 \|\Xi_{\rm mix}\|_F^2=2(m_I+2b_Ib_V)\le4m_I.
\]
Cauchy--Schwarz in the contraction therefore gives the explicit safe bounds
\[
 |\mathcal H_{T_4}|\le2ex\,a_I,\qquad
 |\mathcal H_{T_3}|\le4e\sqrt q\,\sqrt{a_Im_I}.                   \tag{7}
\]
The latter follows because only the disjoint HH/mixed cross blocks enter;
the sharper coefficient \(1/\sqrt2\) for the corresponding product of
block norms is not needed.

For x in [0,1], \(m_D\ge cm_I\) and
\(|b_D|\le3C\sqrt{a_I}\). Since \(q\le2\), (1) and (7) imply
\[
 F_{\rm num}\ge(\lambda-2e)a_I+4U+cm_I
       -18C\sqrt{a_IU}-4\sqrt2e\sqrt{a_Im_I}.
\]
The two elementary Young inequalities
\[
 18C\sqrt{a_IU}\le2U+(81/2)C^2a_I,\quad
 4\sqrt2e\sqrt{a_Im_I}\le(c/2)m_I+16e^2a_I/c
\]
give, with the stated threshold,
\[
                 F_{\rm num}\ge a_I+2U+(c/2)m_I
                     \ge\min(1,c/2)a_{I+V}.                    \tag{8}
\]
This includes x=0, without a limiting argument.

## 4. All unbounded x, with an explicit threshold

Suppose x>=1. Divide each horizontal vector component by \(q^{1/4}\)
and evaluate the original tensor on that pair. Equivalently, work with the
rescaled tensor and metric; their sectional quotient is unchanged.
In the rest of this section all plane quantities refer to the unscaled
input pair for these rescaled tensors. In particular no plane normalization
or subsequence is used. Write
\[
 \widetilde g=G/\sqrt q+V,\quad
 E=D/\sqrt q=E_0+\epsilon h,\quad
 E_0=2h-\sqrt q\,hG^{-1}h,
\]
\[
 \epsilon=(1+2x)/\sqrt q-2,\qquad
 \delta={c\sqrt q\over\lambda+Cx}.
\]
Since \(\lambda\ge C\ge d\) for every eigenvalue d of h,
\[
 {\sqrt q\,d\over\lambda+xd}\le\sqrt{x/(1+x)}<1,\qquad
 {\sqrt q\,d\over\lambda+xd}\ge\delta>0.
\]
Thus \(0<\delta<1\) and \(h\le E_0\le(2-\delta)h\).
Rationalizing \((1+2x)^2-4q=1\) gives
\[
                    0<\epsilon\le1/(4q)\le1/8.                 \tag{9}
\]
Linearity of the mixed terms and \(m_h\ge2at\), \(|b_h|\le a\)
give \(P_h(E)\ge P_h(E_0)-4\epsilon at\).
Averaging (2) and (4) consequently gives
\[
 P_h(E)\ge C_h/2+S/2+\delta at-4\epsilon at.                    \tag{10}
\]

In the new frame the component error bounds are
\(\|\widetilde T_4\|\le ex/q\) and
\(\|\widetilde T_3\|\le e q^{-1/4}\).
Since \(C_h\ge cC_I\) and
\(\|\Xi_{\rm mix}\|^2=2C_I\), contraction and Young give
\[
 |\mathcal H_{\widetilde T_3}|
 \le2\sqrt{2/c}\,e q^{-1/4}\sqrt{a_IC_h}
 \le C_h/4+{8e^2\over c\sqrt q}a_I .
\]
Also \(|\mathcal H_{\widetilde T_4}|\le2ex\,a_I/q\).
Using (5) and (9) in (10), and \(A\le C^2a_I\), yields
\[
 \widetilde F_{\rm num}\ge
 \left({\lambda-2ex-2C^2\over q}-{8e^2\over c\sqrt q}\right)a_I
              +C_h/4+3S/8+\delta at.
\]
Apply (6) to S/4 and the last term, then \(A\ge c^2a_I\):
\[
 \widetilde F_{\rm num}\ge
 \left({\lambda-2ex-2C^2\over q}
       -{8e^2\over c\sqrt q}+{c^2\delta\over4}\right)a_I
                         +C_h/4+S/8.                           \tag{11}
\]

The following elementary universal inequality is the threshold step:
\[
 \alpha>0,\ B\ge1,\ C\ge0,\ x\ge1,\
 \lambda\ge B^2(B+C)/\alpha
 \quad\Longrightarrow\quad
 \lambda+{\alpha x^3\over\lambda+Cx}\ge Bx.                     \tag{12}
\]
If \(\lambda\ge Bx\) it is immediate. Otherwise \(x>\lambda/B\)
and hence \(\alpha x>B(B+C)\). Moreover
\(\lambda+Cx<(B+C)x\), so
\(\alpha x^3/(\lambda+Cx)>Bx\). This proves (12) in both cases.
It is also the universal theorem `Hartogs.threshold`, not a grid check.

Set \(\alpha=c^3/8\) and \(B=B_0\). Because
\(x\le\sqrt q\le2x\), (12) shows
\[
 \lambda+{c^3q^{3/2}\over8(\lambda+Cx)}
                   -2ex-2C^2-{8e^2\sqrt q\over c}\ge x.
\]
Use half of the \(c^2\delta/4\) term in (11) for this inequality.
The other half remains as a strict horizontal reserve:
\[
 \boxed{\widetilde F_{\rm num}\ge
      {a_I\over1+x}+{c^2\delta\over8}a_I+C_h/4+S/8.}             \tag{13}
\]
All inequalities are uniform for every x>=1 and lambda>=Lambda. In
particular (12)-(13) include \(\lambda\) proportional to \(x^{3/2}\);
there is no unproved asymptotic comparison at that competing scale.

For fixed lambda, \(\delta\ge c/(\lambda+C)\). From (5) and
\(m_h=C_h-2b_hb_V\le C_h+2at\) one obtains
\[
 a_{I+V}\le(1+2C^2+4C^2/c)a_I+C_h/c+(1/2+1/(2c))S
              \le H_0(a_I+C_h+S).
\]
Therefore (13) gives
\[
                 \widetilde F_{\rm num}\ge(\eta/H_0)a_{I+V}>0.  \tag{14}
\]
The final strict inequality holds for every real-linearly independent pair:
\(I+V\) is positive definite, so its real Gram determinant is positive.
No assumption on either projected area is needed.

## 5. Both sectional bounds

On [0,1], \(I+V\le G+V\le(\lambda+C)(I+V)\).
For x>=1, the rescaled metric satisfies
\[
 \min(c/2,1)(I+V)\le G/\sqrt q+V\le(\lambda+C)(I+V).
\]
Passing to determinants of the two-dimensional real Gram matrices gives
the squares of these constants. Combine (8) and (14) with
\(K=-F_{\rm num}/(2a_{\rm metric})\) to obtain the stated Acurv.

For completeness a dimension-free upper bound for the numerator is explicit
too. In the appropriate original or rescaled frame put \(a_0=a_{I+V}\).
The horizontal S terms contribute at most
\((4\lambda+8C^2)a_I\): use \(b_P^2\le a_P\), \(a_h\le C^2a_I\),
q<=2 on [0,1], and lambda/q<=lambda after rescaling on [1,infinity).
The vertical term contributes 4U.
Both D on [0,1] and E on [1,infinity) are at most 3h, hence at most 3CI.
For either form Q,
\[
 m_Q\le3Cm_I,\qquad 6|b_Qb_V|\le18C\sqrt{a_IU}
                                  \le9C(a_I+U).
\]
Thus the mixed terms contribute at most \(12Ca_0\).
On [0,1], (7) bounds the errors by
\[
 2ea_I+4\sqrt2e\sqrt{a_Im_I}
 \le2ea_I+3e(a_I+m_I)\le5ea_0.
\]
After rescaling on [1,infinity), the same estimate with q^(-1/4)<=1
gives at most \(4ea_0\). Consequently in all dimensions
\[
 |F_{\rm num}|\le N_0a_0,\qquad
 N_0=4\lambda+8C^2+4+12C+5e.
\]
The metric lower bounds give
\(|K|\le N_0/[2\min(c/2,1)^2]\le B_{\rm curv}\);
the last comparison is immediate from positivity of lambda,C,e.
The lower bounds (8), (13), and (14), all their Gram and block-norm
identities, and the threshold (12) are also dimension independent.
Together with the complex-span reduction in Section 2, this proves both
the threefold theorem and its dimension-free extension.

## 6. Exact evidence and scope of formalization

Run, from any working directory:

```
$WORKSPACE/argus-live-update/.venv/bin/python /absolute/path/to/verify.py
```

Only Python and SymPy are needed; the verifier uses exact rational polynomial
identities, not numerical tolerances or random tests. The saved
`exact_certificate.json` must agree with the freshly recomputed result.
It also checks that the archived successful Lean answer is the actual recorded
answer and that its prescribed source and fidelity digests still match the
files present. This replays the algebra and validates the persisted compiler
evidence; it does not pretend to run a new compiler.
For another Python installation with SymPy, `python3 verify.py` is equivalent.

Jacobian 0.14.0, protocol 2025-11-25, was discovered and its
`polynomial.sos.decomposition.check` contract inspected before constructing
the payload. `jacobian_contract.json`, `jacobian_payload.json`,
`jacobian_result.json`, and `jacobian_run_status.json` preserve the contract,
exact payload, typed answer, and exit/timeout status. The operation returned
`is_valid=true`, `method=EXACT_COEFFICIENT_IDENTITY`, with exit 0.
Its eight-variable bound is met by independent horizontal and vertical
unitary rotations setting the first vector to (a,0,f), with a,f real.
The second is (b+ic,d+ie,g+ik). This covers the limiting corner P(2,2)
for all pairs, including vanishing components. The all-twelve-variable
identities for all four corners are additionally checked locally.
The adapter verifies an identity; it is not being asked to prove the
geometric theorem or supply a proof strategy.

`Main.lean` separately formalizes the four-corner identities, their
nonnegative interpolation, the absorption inequalities, and (12), over all
real inputs with explicit hypotheses. `statement_fidelity.md` specifies
exactly these declarations. It does not claim that Lean formalizes the
potential, geometry, spectral theorem, norm estimates, or novelty. The
compiler run completed under Lean 4.31.0 with exit 0 and no proof holes;
`lean_verification.json` and the archived certificate named in its `kernel`
field preserve the answer. The fidelity document is unchanged from that run.

## 7. Comparison with the strongest retrieved prior results

The staged Section 09 already proves eventual negativity and fixed-lambda
pinching by compactness, including the competing \(x^{3/2}\) scale. Repeating
that existence theorem would not be an improvement. The new ingredient here
is the uniform mixed-block control (2), established by (3), followed by
the explicit dimension-free threshold and curvature constants. They eliminate
the subsequence/equality-locus argument and quantify stability against every
permitted three- and four-horizontal perturbation. No optimality is claimed.

The relevant retrieved primary comparator is Hao--Chen--Wang,
*On the negatively pinched properties of the disc bundles over negatively
pinched Kahler manifolds*, arXiv:2509.04179v1, Introduction (1)-(3),
Theorem 2, and Section 3, Theorem 4:
https://arxiv.org/html/2509.04179v1 .
Its setup identifies the base Kahler form with minus the complex Hessian of
the logarithm of the line-bundle metric. Thus the base metric and the
fiber-weight curvature are locked together. Its stated all-real-plane pinching
theorem is prior art, not a result of this audit. The present theorem instead
allows the independent forms I and h and every bounded error tensor of the
specified types, and supplies explicit constants for that robust problem.
No theorem from that paper is used as a premise here.

The initial search service suggested two other arXiv identifiers, but opening
their primary landing pages showed that 1701.03230 concerns surface
reconstruction and 1304.5622 concerns bilayer ferromagnets. Those suggestions
were rejected, not cited as curvature evidence. No claim of exhaustive
literature coverage or independently verified novelty is made. The scoped
comparison and the mathematical strengthening are ready for Host review;
publishability and campaign closure remain the independent Reviewer's
decision.
