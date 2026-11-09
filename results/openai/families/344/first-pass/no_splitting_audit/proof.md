# No-splitting determinant comparison

## Result and scope

Theorem `weighted:geodesic` is valid under the geometric and Jacobi
hypotheses explicitly stated in sections 01--02 of the staged manuscript.
Below is a proof for every pair of positive ranks \(m,k\), including the
equality assertion. It does not impose a curvature bound, parallel
curvature eigenspaces, or totally geodesic curvature-four spheres.

The proof actually establishes the following stronger, lag-resolved
statement. Set \(T=\pi\), \(D=T/2\), and
\[
 w(z)=\sin^m z\,|\sin(2z)/2|^k.
\]
Extend the symmetric endpoint determinant \(f\) separately periodically
with period \(T\). Then
\[
 \boxed{\quad \frac1T\int_0^T f(x,x+z)\,dx\ \geq\ w(z)
       \qquad(0\leq z\leq T).\quad}                 \tag{1}
\]
In particular, the manuscript's double integral inequality holds.
Equality in that double integral holds if and only if
\(f(x,y)=w(|y-x|)\) on the entire closed square.
In fact, for \(z\notin\{0,D,T\}\) the stronger geometric-mean bound is
\[
 \frac1T\int_0^T\log\frac{f(x,x+z)}{w(z)}\,dx\ge0.       \tag{1a}
\]
Equality in (1) at any such individual lag holds if and only if
\(f(x,x+z)=w(z)\) for every \(x\).

This is a mathematical proof with an exact algebraic certificate, not a
claim that a finite computation proves an analytic theorem. The Lean
source certifies only the rectangular matrix identities named in its
statement-fidelity document. The scalar cancellation, positivity,
integration, and equality propagation are proved below, not in Lean.
Independent Reviewer acceptance and a novelty determination remain
outstanding. Neither the global volume equality argument nor the
classification or quaternionic upper-bound branches is certified here.

## Retrieved known status and limitations

The following are statements about the cited versions, not a claim about
all literature through November 2026.

* McKay, *Summary of progress on the Blaschke conjecture*,
  `arxiv:1309.1326v5`, section 3, explicitly says that the conjecture is
  solved there only for homology spheres and homology real projective
  spaces. That version corrects earlier sphere-fibration arguments. Its
  section 4, conditions (4) and (6), supplies the closed-geodesic and
  great-sphere cut-fibration structure used as input by the manuscript.
  We do not infer metric rigidity, a Hopf identification, or a curvature
  splitting from that structure.
* Rovenskii--Toponogov, *Great sphere foliations and manifolds with
  curvature bounded above*, `arxiv:dg-ga/9609007v1`, Theorem 26 with
  properties F1--F2 in Theorem 19, gives a projective volume comparison
  under additional totally geodesic round-sphere hypotheses. F1 supplies
  curvature-four spheres; F2 controls their intersections. Their proof
  explicitly splits the Jacobi equation using these spheres. Those
  additional hypotheses are not assumptions in this audit.
* Kazdan's Appendix E is a predecessor cited by the manuscript, not an
  imported theorem in this proof. No claim is made to have checked its
  numbered formulas. The necessary measurable-weight cancellation is
  derived in full below.

Short passages actually retrieved are in `literature/`. Citation
attribution by someone independent of the assumption filer is still
required. The recorded abandoned route is to infer a parallel or totally
geodesic curvature splitting from great-sphere fibers alone: these sources
do not supply that inference.

The pre-audit ledger contained only the overarching audit objective.
Compared with that state, the advance is a full local comparison proof,
an explicit check of all four endpoint orders, and (1), rather than a
finite no-counterexample search. Compared with Theorem 26 above, the
argument does not assume its F1--F2 geometry. No verified-new literature
claim is being inferred from these two retrieved sources.
The geometric-mean form (1a) is stronger than the arithmetic lag
comparison (1); both are stronger than the manuscript's unlocalized
double integral.

## 1. Exact input and symplectic reduction

It suffices to assume a smooth \(T\)-periodic curve \(L_t\) of Lagrangian
\(d\)-planes in a real symplectic vector space \((\mathcal J,\omega)\),
where \(d=m+k\), such that:

1. The velocity form \(G_t(I,J)=\omega(I,\dot J_t)\) on \(L_t\) is
   positive definite.
2. For \(0<y-x<T\), the intersection \(L_x\cap L_y\) has dimension \(k\)
   when \(y-x=D\), and is zero otherwise.

These are not additional geometric assertions: they follow from the
normal Jacobi equation and precisely the structure posited in sections
01--02. Indeed,
\(\omega(I,J)=\langle I,J'\rangle-\langle I',J\rangle\) is constant by
the self-adjoint Jacobi equation. The subspace of fields vanishing at
\(t\) is Lagrangian. Differentiating \(J_s(s)=0\) gives
\(G_t(I,J)=\langle I'(t),J'(t)\rangle>0\). The identity
\(\phi_T=\mathrm{Id}_{SM}\), differentiated for arbitrary normal initial
data, makes fields and their derivatives periodic in their actual
tangent spaces. No assertion about trivial parallel holonomy is used.
The absence of conjugate points before \(D\), the nullity \(k\) at \(D\),
and periodicity give condition 2 also for separations between \(D\) and
\(T\).

Define \(f(x,y)\) to be the absolute determinant of \(\omega\) between
\(G_x\)- and \(G_y\)-orthonormal frames of the two planes. Orthogonal
frame changes leave it unchanged. It is continuous, symmetric, and
separately periodic. Evaluating the Wronskian at \(y\) shows it is
exactly the absolute Jacobi determinant with orthonormal initial
derivatives at \(x\).

Choose a \(G_0\)-orthonormal basis of the vertical plane \(L_0=\{q=0\}\)
whose first \(k\) vectors span \(L_0\cap L_D\). Choose its dual
horizontal coordinates. On
\(\mathcal I=(0,D)\cup(D,T)\), transversality gives
\[
 L_t=\{(q,A(t)q)\},\qquad A=A^{\mathsf T},\quad A'>0.
\]
The graph frame has velocity metric \(A'\) and endpoint pairing
\(A(y)-A(x)\); therefore
\[
 f(x,y)=\frac{|\det(A(y)-A(x))|}
                 {\sqrt{\det A'(x)\det A'(y)}}.             \tag{2}
\]
Write the fixed blocks as
\[
 A=\begin{pmatrix}V&C\\C^{\mathsf T}&H\end{pmatrix},
 \qquad S=V'-C'(H')^{-1}C'^{\mathsf T}.
\]
The dimensions of \(H,S\) are \(m,k\). Positivity and block elimination
give \(H'>0,\ S>0,\ \det A'=\det H'\det S\).
In particular, no step has set \(C\) or \(C'\) to zero.

## 2. Pole expansions and endpoint control

At \(D\), choose a smooth frame \(F=(X,P)^{\mathsf T}\) whose first
\(k\) columns at \(D\) equal the adapted vertical vectors. Isotropy
forces the image of \(X(D)\) to be the last \(m\) coordinates.
Choose the other columns so their last-coordinate value matrix \(M\)
is invertible. With \(\tau=t-D\), divide the first \(k\) columns of
\(X\) by \(\tau\). This is a smooth division, since they vanish at
\(D\). The resulting matrix has the form
\[
 \widetilde X(D)=\begin{pmatrix}-G&0\\N&M\end{pmatrix},
 \qquad G=G_D|_{L_0\cap L_D}>0.
\]
The sign follows directly from
\(\omega((0,e_a),\dot F_b)=-e_a^{\mathsf T}X_b'\).
Thus \(\widetilde X\) is invertible nearby. In
\(A=P\,\operatorname{diag}(\tau^{-1}I_k,I_m)\widetilde X^{-1}\),
the residue is exactly \(-\operatorname{diag}(G^{-1},0)\).
Subtracting this residue leaves a smooth function: for a smooth
matrix \(U\), \((U(t)-U(D))/(t-D)\) extends smoothly by the integral
of \(U'\) along the segment. Consequently,
\[
 A(t)=-\frac{\operatorname{diag}(B,0)}{t-D}+R_D(t),
 \qquad B=G^{-1}>0,                                  \tag{3}
\]
with a smooth remainder, and there is no off-diagonal pole.

The sections
\[
 E_z(t)=((0,z),(C(t)z,H(t)z))\in L_t
\]
are smooth through \(D\); for \(z\ne0\) their limit is nonzero.
The velocity identity at \(D\) gives
\(z^{\mathsf T}H'(D)z=G_D(E_z(D),E_z(D))>0\).
At \(0\) the same divided-frame calculation uses \(G_0=I_d\);
at \(T\) use periodicity of both \(L\) and \(G\). Hence
\[
 A(t)=-I_d/(t-t_0)+R_{t_0}(t)\quad(t_0=0,T),           \tag{4}
\]
again with smooth remainders.

Define
\[
 h=\det(H')^{1/m},\quad s=\det S^{1/k},\quad
 s_i(t)=s(t+iD)\quad(0<t<D,\ i=0,1).
\]
Equation (4) implies \(H'=\tau^{-2}I_m+O(1)\),
\(C'=O(1)\), and \(S=\tau^{-2}I_k+O(1)\) at \(0,T\).
Equation (3), together with invertible \(H'(D)\), implies
\(S=(t-D)^{-2}B+O(1)\) at \(D\). Thus the positive ratios
\[
 h(t)\sin^2t,\qquad s_i(t)\sin^2(2t)/4                 \tag{5}
\]
extend continuously to their closed intervals. Their endpoint limits
are respectively \((1,1)\), \((1,\det B^{1/k})\), and
\((\det B^{1/k},1)\). Compactness supplies common finite positive
lower and upper bounds \(\alpha,\beta\).
This establishes the precise integrability input; it does not presume
that a pole residue at \(D\) is the identity.

## 3. Schur bounds, with the reversed actual order included

For distinct chart endpoints write \(\Delta U=U(y)-U(x)\).
Because \(H'>0\) also at \(D\),
\(\Delta H=\int_x^y H'\) is definite with the sign of \(y-x\).
It is invertible even in the reversed order. Set
\[
 Q(x,y)=\Delta V-\Delta C(\Delta H)^{-1}\Delta C^{\mathsf T},
 \qquad R=\Delta C(\Delta H)^{-1}.
\]
Block congruence gives
\(\det\Delta A=\det\Delta H\det Q\) and
\(Q(y,x)=-Q(x,y)\). At a cut pair the nullity of \(\Delta A\)
is \(k\); its regular block is invertible, so the \(k\)-by-\(k\)
matrix \(Q\) is zero, not merely singular. Near the diagonal,
Taylor expansion gives \(Q(x,y)=(y-x)S(x)+O((y-x)^2)\).

Differentiation, at either endpoint \(a=y\) or \(a=x\), yields
\[
 \begin{split}
 \partial_yQ&=V'(y)-C'(y)R^{\mathsf T}-RC'(y)^{\mathsf T}
                       +RH'(y)R^{\mathsf T},\\
 -\partial_xQ&=V'(x)-C'(x)R^{\mathsf T}-RC'(x)^{\mathsf T}
                       +RH'(x)R^{\mathsf T}.
 \end{split}
\]
For either endpoint this common expression is exactly
\[
 S(a)+(R-C'(a)H'(a)^{-1})\,H'(a)\,
                (R-C'(a)H'(a)^{-1})^{\mathsf T}.       \tag{6}
\]
The second term is positive semidefinite: on a vector \(z\) it is
the positive quadratic form of \(H'(a)\) on the transpose-image of
\(z\). Therefore \(\partial_yQ\ge S(y)\) and
\(-\partial_xQ\ge S(x)\), independently of the sign of \(\Delta H\).
The arbitrary rectangular algebra in (6) and the sign reversal are
the two declarations formalized in `lean/Main.lean`.

Here are all four integrations for \(0<u<v<D\). The indicated
starting and terminal values of \(Q\) are zero.

| \(i,j\) | fixed first endpoint; moving second | moving first; fixed second | actual order |
|---|---|---|---|
| 0,0 | \(u;\ u\longrightarrow v\) | \(u\longrightarrow v;\ v\) | \(x<y\) |
| 1,1 | \(u+D;\ u+D\longrightarrow v+D\) | \(u+D\longrightarrow v+D;\ v+D\) | \(x<y\) |
| 0,1 | \(u;\ u+D\longrightarrow v+D\) | \(u\longrightarrow v;\ v+D\) | \(x<y\) |
| 1,0 | \(u+D;\ u\longrightarrow v\) | \(u+D\longrightarrow v+D;\ v\) | \(x>y\) |

No moving endpoint crosses a chart pole. In the equal-index cases
take a shortened interval first and use the diagonal limit.
In every case integration gives both bounds
\[
 Q(u+iD,v+jD)\ge \int_u^v S(t+iD)\,dt,\qquad
 Q(u+iD,v+jD)\ge \int_u^v S(t+jD)\,dt.                \tag{7}
\]
Both right sides are positive definite. In particular \(Q>0\) also
for \(i=1,j=0\). The negative sign of \(\Delta H\) in that case never
reverses (7).

## 4. Arbitrary-rank determinant reduction

For an \(r\)-by-\(r\) positive definite real matrix \(M\), let
\(\delta_r(M)=\det M^{1/r}\). Diagonalizing the positive matrix
\(M^{1/2}PM^{1/2}\) and applying scalar arithmetic--geometric mean
proves
\[
 \delta_r(M)=\inf_{P>0,\ \det P=1}\frac1r\operatorname{tr}(PM).
                                                               \tag{8}
\]
The lower bound follows because the product of those eigenvalues
is \(\det M\). Equality holds at \(P=\delta_r(M)M^{-1}\).
It follows directly that \(\delta_r\) is monotone in semidefinite
order. For a continuous positive matrix function on a compact
interval it also follows that
\[
 \delta_r\left(\int_a^b M(t)\,dt\right)
       \ge\int_a^b\delta_r(M(t))\,dt:                 \tag{9}
\]
for each admissible \(P\), integrate its pointwise lower bound
in (8), then take the infimum. This proves the integral
determinant inequality for all ranks, not by testing ranks.

Factor (2) as \(f=f_Hf_K\), where
\[
 f_H=\frac{|\det\Delta H|}{\sqrt{\det H'(x)\det H'(y)}},
 \qquad
 f_K=\frac{|\det Q|}{\sqrt{\det S(x)\det S(y)}} .
\]
Both factors are symmetric in actual endpoints. Equations (7)--(9)
give
\[
 \begin{split}
 f_H(x,y)^{1/m}&\ge
       \frac{|\int_x^y h|}{\sqrt{h(x)h(y)}},\\
 f_K(u+iD,v+jD)^{1/k}&\ge
       \frac{\sqrt{(\int_u^v s_i)(\int_u^v s_j)}}
            {\sqrt{s_i(u)s_j(v)}}.                  \tag{10}
 \end{split}
\]
For the second bound, \(\delta_k(Q)\) dominates both scalar integrals
and therefore their geometric mean. These are integrals on closed
interior subintervals; no pole is integrated through in the fast
block. For the reversed slow interval apply (9) to \(-\Delta H\).

## 5. Cancellation for measurable weights

We prove the scalar fact required by (10), rather than cite a
regularity-dependent variant. Let \(b>0,\lambda=\pi/b\),
\(p_0=\lambda^2/\sin^2(\lambda t)\), \(p>0\) continuous,
and \(g=\log(p/p_0)\) bounded. Let \(W\ge0\) be measurable,
\(W(b-z)=W(z)\) almost everywhere, and
\(K(z)=W(z)/\sin(\lambda z)\) essentially bounded.
For \(0<x<y<b\), put \(P_0=\int_x^yp_0\) and
\(d\nu_{xy}=p_0(t)\,dt/P_0\). Direct integration gives
\[
 P_0=\frac{\lambda\sin(\lambda(y-x))}
                  {\sin(\lambda x)\sin(\lambda y)},\qquad
 \frac{P_0}{\sqrt{p_0(x)p_0(y)}}=
                  \frac{\sin(\lambda(y-x))}{\lambda}.           \tag{11}
\]
The probability averages of \(g\) and
\(\log\int e^g\,d\nu\) are bounded by \(\|g\|_\infty\).
All the following integrals are therefore absolutely integrable.

Let \(I_W=\int_0^bW\) and
\[
 F(t)=\int_{0<x<t<y<b}
            K(y-x)\sin(\lambda x)\sin(\lambda y)\,dx\,dy.
\]
The double kernel is bounded. Fubini, or the difference of its two
indefinite boundary integrals, proves that \(F\) is absolutely
continuous and
\[
 \begin{split}
 F'(t)&=\sin(\lambda t)
 \left[\int_0^{b-t}K(z)\sin(\lambda(t+z))\,dz
       -\int_0^tK(z)\sin(\lambda(t-z))\,dz\right]\\
 &=\sin(\lambda t)\int_0^bK(z)\sin(\lambda(t+z))\,dz\\
 &=I_W\sin(\lambda t)\cos(\lambda t)
 \quad\text{for almost every }t.
 \end{split}
\]
The second equality substitutes \(z=b-r\) in the subtracted
integral; the sign is from
\(\sin(\lambda(t-b+r))=-\sin(\lambda(t+r))\).
The last equality uses
\(\int K(z)\cos(\lambda z)\,dz=0\) by reflection and
\(\int K(z)\sin(\lambda z)\,dz=I_W\).
It follows, since \(F(0)=0\), that
\[
 F(t)=\frac{I_W}{2\lambda}\sin^2(\lambda t),\qquad
 \frac{p_0(t)}{\lambda}F(t)=I_W/2.                   \tag{12}
\]
This differentiates neither \(K\) nor \(W\).

Use (11)--(12) and absolutely integrable Fubini to obtain
\[
 \int_{\Delta_b}W(y-x)\int_x^yg\,d\nu_{xy}\,dx\,dy
       =\frac{I_W}{2}\int_0^bg(t)\,dt.
\]
The endpoint average has the same integral, because its coefficient
at \(g(t)/2\) is
\(\int_0^{b-t}W+\int_0^tW=I_W\).
Subtracting gives the exact identity
\[
 \begin{split}
 \int_{\Delta_b}W(y-x)
 \left[\log\frac{\int_x^yp}{\int_x^yp_0}
                  -\frac{g(x)+g(y)}2\right]
 =\int_{\Delta_b}W(y-x)
 \left[\log\int e^g\,d\nu_{xy}-\int g\,d\nu_{xy}\right]
 \ge0.                                                   \tag{13}
 \end{split}
\]
The inequality is Jensen for the exponential followed by the
increasing logarithm. It concerns a probability measure on
\((x,y)\), not a nonexistent finite integral of \(p_0\) over
\((0,b)\).

## 6. Logarithmic integrability and four folded weights

Exclude the finitely many lines where an endpoint is \(D\), the
endpoints coincide, or their separation is \(D\).
Write
\[
 L_H=\log(f_H/\sin^m|y-x|),\quad
 L_K=\log(f_K/|\sin(2|y-x|)/2|^k),\quad L=L_H+L_K.
\]
Set these functions to zero on the excluded null set.
By (5), (10), and (11), with \(\eta=\alpha/\beta>0\),
\[
 L_H\ge m\log\eta,\qquad L_K\ge k\log\eta.             \tag{14}
\]
The off-diagonal lower bounds use the geometric mean in (10),
so the same \(\eta\) works in the mixed-index cases.
Since \(wL^+\le f\) and \(f\) is bounded on the compact square,
\(wL^+\) is integrable. Equation (14) bounds both negative
parts; it also gives
\(L_H^+\le L^+-k\log\eta\) and
\(L_K^+\le L^+-m\log\eta\).
Thus \(wL_H,wL_K,wL\) are absolutely integrable.

We can use any bounded, nonnegative measurable \(q\) satisfying
\(q(T-z)=q(z)\) almost everywhere, and put \(W=qw\).
All the preceding integrability statements remain valid with \(W\).
The original theorem is the choice \(q=1\).

Apply (13) with \(b=T,\lambda=1,p=h\), weight \(W\),
and bounded \(g_H=\log(h/\csc^2t)\).
The first bound in (10) gives
\[
 \int_{(0,T)^2} W(|y-x|)L_H(x,y)\,dx\,dy\ge0.         \tag{15}
\]
Its weight assumptions hold because
\(W/\sin z=q\sin^{m-1}z|\sin(2z)/2|^k\) is bounded
and \(W(T-z)=W(z)\).

For the fast block set \(B_0(z)=\sin(2z)/2>0\) on \((0,D)\),
\(p_0=4\csc^2(2t)\), and
\[
 g_i=\log(s_i/p_0),\qquad
 A_i(u,v)=\log\frac{\int_u^vs_i}{\int_u^vp_0}.
\]
The second bound in (10) becomes, for every \(i,j\),
\[
 \frac1k L_K(u+iD,v+jD)\ge
  \frac12[A_i(u,v)+A_j(u,v)-g_i(u)-g_j(v)].            \tag{16}
\]
The actual distances in the order \(00,11,01,10\) are
\(z,z,D+z,D-z\), respectively. In all four cases the fast
reference factor is \(B_0(z)\), including when \(x>y\).
Their weights are exactly
\[
 (W_{ij}(z))=
 B_0(z)^k
 \begin{pmatrix}
  q(z)\sin^m z & q(D-z)\cos^m z\\
  q(D-z)\cos^m z & q(z)\sin^m z
 \end{pmatrix}.                                      \tag{17}
\]
Every row and column has the same sum \(W_D(z)\).
Reflection \(z\mapsto D-z\) exchanges the two summands of that
sum, so \(W_D\) is symmetric. Moreover
\[
 \frac{W_D(z)}{\sin(2z)}
 =2^{-k}\sin^{k-1}(2z)
       [q(z)\sin^m z+q(D-z)\cos^m z]
\]
is bounded for all \(m,k\ge1\). For \(q=1,k=1\) its limit is
\(1/2\) at both endpoints. No vanishing limit was required.

Multiply (16) by (17) and sum over all four pairs. The row
sums collect \(A_i-g_i(u)\); the column sums collect
\(A_j-g_j(v)\). Exactly, the resulting lower bound is
\[
 W_D(z)\sum_{i=0}^1
       [A_i(u,v)-(g_i(u)+g_i(v))/2].                 \tag{18}
\]
Apply (13) separately to \(s_0,s_1\) with \(b=D,\lambda=2\)
and weight \(W_D\). Its integral over \(0<u<v<D\) is nonnegative.
The four regions used here have increasing residues modulo \(D\).
Their transposes have decreasing residues. These eight disjoint
regions cover the square apart from the excluded lines, with
Jacobian one. Endpoint symmetry therefore gives
\[
 \int_{(0,T)^2}W(|y-x|)L_K(x,y)\,dx\,dy
 =2k\int_{\Delta_D}\sum_{i,j}
               W_{ij}\frac{L_K(u+iD,v+jD)}k\,du\,dv\ge0.         \tag{19}
\]
The factors \(2\) and \(k\) have different origins and are both
needed. This completes the folded cancellation without assuming
half-period equality of the profiles \(s_0,s_1\).

## 7. Comparison, equality, and fixed-lag strengthening

Equations (15) and (19) prove the entropy inequality
\(\int qw\log(f/w)\ge0\).
For \(r>0\) let \(\Phi(r)=r-1-\log r\).
Its derivative \(1-1/r\) shows that its unique minimum is zero
at \(r=1\). Absolute integrability already established justifies
the finite identity
\[
 \int q(f-w)=\int qw\log(f/w)+\int qw\Phi(f/w)\ge0.     \tag{20}
\]
The ratio is used only off the null lines; values on those
lines do not affect (20). The last integrand is integrable
because it is the difference of the other integrable terms.

For \(q=1\), (20) is the requested comparison. Equality forces
\(\Phi(f/w)=0\) almost everywhere where \(w>0\), hence \(f=w\)
almost everywhere. The full-measure equality set is dense
in the closed square: any relative neighborhood meets the
interior in positive area. Continuity of \(f\) and \(w\)
then gives equality at every pair, including the boundary,
diagonal, and cut lines. The converse is immediate.

For completeness, define the continuous periodic function
\[
 A(z)=T^{-1}\int_0^T f(x,x+z)\,dx.
\]
Symmetry and a change of origin give \(A(T-z)=A(z)\).
For symmetric \(q\), periodicity and the measure-preserving
substitution \(z=(y-x)\bmod T\) convert (20) to
\[
 T\int_0^T q(z)[A(z)-w(z)]\,dz\ge0.                  \tag{21}
\]
 One can localize the entropy itself, not just (20). For
 \(z\in(0,T)\setminus\{D\}\), put
 \[
  B(z)=T^{-1}\int_0^T\log[f(x,x+z)/w(z)]\,dx.
 \]
 The intersection pattern makes \(f(x,x+z)>0\) for every \(x\).
 On each compact lag interval avoiding \(0,D,T\), compactness
 therefore bounds \(f\) and \(w\) away from zero. It follows
 that \(B\) is continuous there and \(B(T-z)=B(z)\).
 The entropy inequality, with the same change of variables, is
 \(T\int_0^Tq(z)w(z)B(z)\,dz\ge0\).
 If \(B(z_0)<0\), continuity gives a small open lag interval,
 away from the exceptional lags, on which it is negative.
 Adjoin its reflected interval and use the indicator of their
 union as \(q\). Since \(w>0\) there, the integral is strictly
 negative, a contradiction. This proves (1a).

 For each fixed nonexceptional lag, the finite pointwise defect
 identity also gives
 \[
  A(z)-w(z)=w(z)\left[
  B(z)+\frac1T\int_0^T\Phi(f(x,x+z)/w(z))\,dx\right]\ge0. \tag{22}
 \]
 Thus (1) holds at those lags; at \(0,D,T\) the intersection
 pattern already makes \(f=w=0\). If equality holds in (1)
 at a nonexceptional lag, the last nonnegative integral is
 zero, and continuity in \(x\) forces \(f(x,x+z)=w(z)\)
 for every \(x\). The converse is immediate.
 This proves the claimed fixed-lag equality assertion as well
 as the stronger geometric-mean statement.

## Certificate coverage and remaining obligations

`../../verify.py` is a deterministic exact checker, with no numerical
quadrature or random search. It requires Python 3 and SymPy; run it from
any directory with `python /path/to/9000344/verify.py`.
`../../exact_certificate.json` records its
bounded symbolic reductions. These include the Schur derivative
formula, nonzero off-diagonal blocks, both signs of the regular
endpoint difference, all four model endpoint orders, the chord and
coefficient identities, and the folded row/column cancellation with
independent weight values and independent endpoint data.

`lean/Main.lean` addresses the arbitrary rectangular algebra, not
only the \(k=1,m=2\) symbolic example used for adapter replay.
The arbitrary-rank determinant inequality is proved by (8)--(9),
the endpoint analysis by (3)--(5), and the measurable-weight
integration by (11)--(13). These arguments are the analytic coverage
of this report, not assertions about what the executable checks.

The external geometric structure is accepted exactly as a hypothesis
of the live objective; its classical proof and the other manuscript
branches remain unaudited. No counterexample to a Blaschke manifold
is claimed. No finite matrix example is promoted to a geometric
counterexample. No independent review or verified novelty is claimed.
