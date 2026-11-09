# Exact inseparable genus estimate: source-bound audit

## Scope and literal target

The target is `thm:inseparable-genus` in
`research/openai_manuscript/The-Blockwise-Alperin-Weight-Conjecture-September-23-2026/build/sections/differentials.tex`,
lines 35-54. The manuscript's definition of a curve is a regular integral
projective curve, not necessarily geometrically reduced. All degrees and
Euler characteristics are over the specified ground field.

Let \(p\) be prime, \(\kappa=\overline{\mathbb F}_p\), \(n=p^s\),
\(h\geq1\), \(s\geq h\), \(m=|J|\), and
\[
 N=p^{s-h}>m(h+\log_p m).
\]
The fields and marked elliptic torsor are those of `prop:twist-index`:
\(F'=\kappa(A_0^n)\), \(F'/F_0\) is cyclic Galois of degree \(n\),
and \(E_{F'}=A_{0,F'}\). The finite etale divisor \(\mathcal B\) splits
into the distinct rational points \(t_1,\ldots,t_n\) over \(F'\).
For finite \(F/F_0\) with \([F:F_0]_p\leq p^h\), set \(S=FF'\).
Let \(Z\) be the normalization of \(E_F\) in a purely inseparable
function-field extension of degree \(d\leq m\). The assertion to settle is
\[
 \nu_F(Z)/d\ \geq\ \sum_{i=1}^{n}(1-r_i^{-1}),
 \qquad
 \nu_F(Z)=-2\bigl(\dim_F H^0(Z,\mathcal O_Z)
                         -\dim_F H^1(Z,\mathcal O_Z)\bigr),
\]
where \(r_i\) is the local ramification index after the separable extension
to \(S\). Residue degrees and constant-field degrees must not be discarded.
This is not a claim that the blockwise Alperin weight conjecture has been
verified.

## Persisted source findings

| Source | Assertion and audit interface |
|---|---|
| `twist.tex`, `prop:twist-index` | The translated cyclic twist has index exactly \(p^s\); the proof uses the full geometric multiplicity in cycle sums. |
| `twist.tex`, `cor:index-base-change` | Every divisor degree on \(E_F\), and on a regular finite cover of it, is divisible by \(N\). Pushforward uses full residue degrees. |
| `twist.tex`, `lem:label-rank` | Every subset of the covectors \(v_i=(1,-t_i^*\eta)\) loses at most \(h\) ranks over \(S\). |
| `differentials.tex`, `prop:absolute-genus` | \(\Omega_{C/\kappa}\) is locally free and \(\deg\det\Omega_{C/\kappa}=\nu_S(C)\), with no geometric-reducedness assumption. |
| `differentials.tex`, `lem:height-one` | For exponent-one degree \(p^a\), the tangent kernel and cokernel have rank \(a\), with determinant exponent \(+p\). |
| `differentials.tex`, proof of `thm:inseparable-genus` | Vanishing is along the full pullback divisor of a ramified label, not its reduced support. |
| Same proof | The tower is \(M_j=M_eM_z^{p^j}\); its genus recurrence has a factor \(1/p\), not \(1/q_j\). |
| Same proof | Rounding uses a divisor defined over \(F\): \(\gamma^*\mathcal B_F-(\gamma^{-1}\mathcal B_F)_{\rm red}\). |

These are source assertions, not yet independent certifications. No false
assertion has been identified at this scope checkpoint.

## Main theorem dependency trace

The main statement (`intro.tex`, `thm:main`, lines 42-47) is
\(l(B)=|W_p(B)|\) for every finite group, prime, and block. The relevant route is
\[
 \texttt{thm:inseparable-genus}
 \longrightarrow \texttt{eq:sharp-specialization}
 \longrightarrow \texttt{prop:specialization-model}
 \longrightarrow \texttt{prop:no-small-cover}
 \longrightarrow \texttt{thm:tuple-divisibility}
 \longrightarrow \texttt{prop:group-reduction}
 \longrightarrow \texttt{thm:main}.
\]
The specialization model also uses the residue-degree equality and
valuation-theoretic inputs. The no-small-cover step also uses
`lem:valuation-model-connectedness` and the hypothesis \(O_p(J)=1\).
Tuple divisibility additionally uses `prop:small-orbit-descent` and
`lem:marked-cover-classification`. The group reduction uses the tuple trace,
normal \(p\)-core cancellation, alternating subsections, trace limit, chain
transform, and normalizer projection. Those other branches remain outside
this bounded genus mission.

## Scope: existing mathematics and exclusions

Key classical inputs are regularity over a perfect
field (Stacks, Tag 00TV, Lemma 10.140.5), flat coherent-cohomology base
change (Tag 02KH, Lemma 30.5.2), and projective-space duality (Tag 0A9W,
Lemma 48.15.1). Normalization finiteness is supplied by the Nagata
property (Tag 0335, Proposition 10.162.16), and the Ext passage uses
the bounded-complex spectral sequence in Section 20.43 (Tag 0BQP).
Their primary-source statements have been obtained. The perfect-field
hypothesis makes the residue extensions in
00TV separable; the base change in 02KH is a field extension and hence
flat; 0A9W is used only for projective space over the stated field.

Tate's genus-change theorem and the geometric-integrality versions of
genus-change results are not substitutes for the present statement.
Ekedahl's foliation formula is background, not an unverified shortcut in
the proof: the local kernel/cokernel calculation must be supplied directly.
The Numdam primary record for Ekedahl's 1988 paper was found, but the
specific cited proposition has not been read and is not assumed.

The inherited project Wiki was searched for inseparable genus, imperfect
fields, height-one curve morphisms, and Alperin weights. No relevant prior
result was found. Finite tests, an unramified constant extension, and a
conditional integer-rounding lemma alone cannot settle this target.

## Certification boundary

The report will distinguish the geometric proof, exact symbolic checks,
finite adversarial experiments, and any formalized arithmetic deduction.
No finite computation will be presented as a proof about all curves.
Independent Reviewer confirmation is required and has not been supplied.

## Theorem A: an intrinsic rank-profile inequality

Here is a generalization that isolates the complete geometric estimate
from the special translated twist.

Let \(k\) be any perfect field of characteristic \(p>0\), let \(F/k\)
be finitely generated, and let \(E/F\) be a smooth projective
geometrically integral genus-one curve. Suppose a finite separable
extension \(S/F\) identifies \(E_S\) with \(A_S\), where \(A/k\) is
an elliptic curve. Let a finite etale divisor \(\mathcal B/F\) split
over \(S\) into distinct rational points \(t_1,\ldots,t_n\). Let
\(Z\) be the normalization in a finite purely inseparable extension of
\(F(E)\), of degree \(d=p^a\). No geometric-reducedness or constant-field
hypothesis is imposed on \(Z\).

For \(d>1\), form the tower
\[
 M_j=S(E)S(Z)^{p^j},\quad
 Y_j=\operatorname{Norm}_{M_j}(E_S),\quad
 d_j=[M_j:S(E)],\quad d_j/d_{j+1}=p^{m_j},
 \qquad 0\leq j<b.
\]
Here \(b\) is the first terminal index. For a nonzero invariant
differential \(\eta\) on \(A/k\), put \(v_i=(1,-t_i^*\eta)\).
Let \(I_j\) consist of the labels ramified in \(Y_j\to E_S\), and set
\[
 c_j=\operatorname{rank}_S\{v_i:i\in I_j\},
 \qquad w_j=(1-p^{-1})p^{-j}.
\]
Then
\[
 \boxed{\quad
 \frac{\nu_F(Z)}d\ \geq\
       \sum_{j=0}^{b-1}w_j\max(0,c_j-m_j).
 \quad}                                                     \tag{A}
\]
In particular, let \(h\) be a nonnegative integer. If every subset of
the \(v_i\) has rank at least its cardinality minus \(h\), then, with
\(r_i\) the initial ramification
indices,
\[
 \frac{\nu_F(Z)}d\geq
 \sum_i(1-r_i^{-1})-E,\qquad
 E=\sum_{j=0}^{b-1}w_j(h+m_j).                               \tag{B}
\]
If every divisor degree on \(E/F\) is divisible by a positive integer
\(N\), the exact marked-ramification inequality follows whenever
\[
                         N>dE.                             \tag{C}
\]
For \(d=1\) the exact inequality is \(0\geq0\), with no threshold.

### Proof: degrees and absolute duality

For a regular integral projective curve \(C/U\), degrees are sums of
valuations weighted by the full degrees \([\kappa(x):U]\).
The one-step divisor exact sequence has quotient of \(U\)-dimension
\([\kappa(x):U]\); hence
\[
 \chi_U(\mathcal O_C(D))=\deg_U D+\chi_U(\mathcal O_C).
                                                               \tag{1}
\]
Every line bundle has a rational section and is of this form. A finite
dominant morphism between regular curves is flat: its local modules
over a DVR are finite torsion-free, hence free. If its degree is \(q\),
the length of its reduction modulo a downstairs uniformizer gives
\[
             \sum_{y\mid x}e_y[\kappa(y):\kappa(x)]=q.          \tag{2}
\]
It follows directly that pullback multiplies divisor degrees by \(q\)
and pushforward preserves degrees over the stated field. No residue
separability is used.

Put \(\rho=\operatorname{trdeg}_k U\). The local rings of \(C\)
are essentially of finite type over the perfect field \(k\). Regularity
and Tag 00TV therefore make their absolute cotangents free of rank
\(\rho+1\). Embed \(C\) in \(\mathbb P^e_U\). The local ideal is a
regular sequence of length \(e-1\): a regular local ring with regular
quotient has this property, as is also seen by lifting a basis of the
kernel on cotangent spaces and comparing dimensions. Consequently the
absolute conormal sequence is short exact. Indeed its rightmost term
is locally free; the kernel and the conormal module are locally free
of the same rank \(e-1\), and the natural surjection between them is an
isomorphism.

Taking determinants identifies \(\det\Omega_{C/k}\), up to a constant
line of degree zero, with
\[
 L=\mathcal O_C(-e-1)\otimes
                 \det(\mathcal I/\mathcal I^2)^{-1}.
\]
The Koszul resolution gives only the row
\(\mathcal Ext^{e-1}(i_*\mathcal O_C,\mathcal O(-e-1))=i_*L\).
Projective-space duality (Tag 0A9W) and the local-to-global Ext
sequence then give
\(H^r(C,\mathcal O_C)^\vee=H^{1-r}(C,L)\), for \(r=0,1\).
Thus \(\chi_U(L)=-\chi_U(\mathcal O_C)\), and (1) proves
\[
                 \deg_U\det\Omega_{C/k}=\nu_U(C).             \tag{3}
\]
In particular, replacing \(\dim_U H^0\) by 1 would be invalid here;
it has not been done.

### Proof: the height-one identity, including its sign

Consider a height-one map \(C\to C'\), of degree \(q=p^m\).
At a closed point, write \(B\subset A\) for the DVRs. Normality gives
\(A^p\subset B\). The ramification index \(\epsilon\) divides \(p\),
since the \(p\)th power of an upstairs uniformizer belongs to \(B\).
Equation (2) gives \(q=\epsilon f\), where \(f\) is the residue degree.
The exponent-one residue extension has a \(p\)-basis. Lift its
generators \(b_1,\ldots,b_r\) to \(A\), and append the upstairs
uniformizer if \(\epsilon=p\). There are exactly \(m\) generators.
Their \(p\)-restricted monomials form a basis modulo the downstairs
uniformizer: use the filtration by powers of the upstairs uniformizer,
whose successive quotients are the full residue field. Nakayama and
freeness of rank \(q\) therefore give the actual presentation
\[
 A=B[X_1,\ldots,X_m]/(X_1^p-c_1,\ldots,X_m^p-c_m),
 \quad b_\ell^p=c_\ell\in B.                                 \tag{4}
\]
This explicitly includes simultaneous ramification and inseparable
residue extension. It is not a presentation inferred only from the
generic fields.

Set \(V=A\otimes_B\Omega_{B/k}\), and let \(W\) be the span of
the \(dc_\ell\). Differentiating (4) gives
\[
 \Omega_{A/k}=(V/W)\oplus\bigoplus_{\ell=1}^m A\,db_\ell.
\]
Both absolute cotangent modules have rank \(\rho+1\), so \(V/W\)
is free and \(W\) is free of rank \(m\), with basis \(dc_\ell\).
The tangent kernel \(\mathcal F\) has coordinates \(D(b_\ell)\);
the tangent cokernel \(\mathcal Q=W^\vee\) has coordinates
\(\delta(c_\ell)\).

On changing generators to \(b'_u=P_u(b)\), with coefficients in \(B\),
the kernel coordinates change by
\(J=(\partial P_u/\partial X_\ell)(b)\).
The coefficients' \(p\)th powers have zero absolute differential, so
the cokernel coordinates change by \(J^{[p]}\), not by its inverse.
Thus \(\det\mathcal Q=(\det\mathcal F)^{\otimes p}\);
switching from coordinates to frames inverts both transitions and
does not change the exponent's sign. The alternating determinant of
the tangent sequence, followed by (3), gives
\[
       \nu(C)=q\nu(C')+(p-1)\deg\mathcal F.                   \tag{5}
\]
The arbitrary-size identity
\(\det(J^{[p]})=(\det J)^p\) is part of the formal algebraic core.
The local geometry and the transition conventions remain part of
this prose proof.

### Proof: the tower and the complete marked divisors

Normalization is finite for a variety over a field (the Nagata
property, Tag 0335). A normalization map in a purely inseparable
extension is radicial: suitable \(p\)-powers of every integral
element lie downstairs, so primes and their residue embeddings are
unique after every base change. Separable scalar extension preserves
regularity. Hence \(Z_S\) is regular, and its finite surjective
radicial map onto the integral \(E_S\) makes it integral as well.
It is the required normalization, has degree \(d\) by flatness, and
has the same numerical Euler characteristic over \(S\) as \(Z\)
has over \(F\), by Tag 02KH. All intermediate \(Y_j\) have the
same properties.

The regularity assertion here can also be checked without an extra
geometric hypothesis: a finite separable field extension gives a
finite etale algebra over each downstairs DVR. After localizing at
a prime, its residue algebra is a field and its maximal ideal is
generated by the downstairs uniformizer. It is a regular local ring
of dimension one. At a generic point the localization is a field.
For a reduced finite divisor, its coordinate algebra is a product of
fields; tensoring each with a separable extension is again reduced.
This proves both separable-base-change assertions used in the argument.

The fields satisfy \(M_{j+1}=S(E)M_j^p\). There is no stationary
nonterminal stage: if \(M_j=M_{j+1}\), iteration would give
\(M_j=S(E)M_j^{p^v}\) for every \(v\), and large \(v\) would give
\(M_j=S(E)\). Thus \(m_j\geq1\),
\(\sum_jm_j=a\), and \(1\leq b\leq a\).
An absolute derivation kills \(S(E)\) precisely when it kills
\(S(E)M_j^p\). The kernel of the tangent map to \(E_S\)
is therefore the height-one kernel even as a sheaf: both targets
are torsion-free, so generic vanishing is actual vanishing.

Let \(\mathcal H_j\) be the tangent-map image in the trivial
absolute tangent bundle of \(E_S=A_S\), and set
\(B_j=-\deg_S\mathcal H_j\). Its rank is \(\rho+1-m_j\).
From the exact image sequence,
\(B_j=\nu(Y_j)+\deg\mathcal F_j\).
Eliminating \(\deg\mathcal F_j\) in (5) gives
\[
 \frac{\nu(Y_j)}{d_j}
 =p^{-1}\frac{\nu(Y_{j+1})}{d_{j+1}}
      +(1-p^{-1})\frac{B_j}{d_j}.                           \tag{6}
\]
The factor is \(p^{-1}\) irrespective of \(m_j\).

At a ramified label, take a parameter \(a_i\) downstairs. Modulo
\((a_i)\), its absolute differential is \(\lambda_i v_i\), with
\(\lambda_i\in S^\times\): the relative differential is nonzero
at a rational point of the smooth elliptic curve. Upstairs,
\(a_i=u\tau^r\) with \(p\mid r\), so
\[
                    da_i=a_i\,u^{-1}du.
 \]
Pulling back the preceding congruence shows that the image of \(v_i\)
in \(\Omega_{Y_j/k}\) belongs to \(a_i\Omega_{Y_j/k}\).
Evaluating on absolute tangent vectors shows that \(v_i\) takes
\(\mathcal H_j\) into \(\mathcal O(-D_{j,i})\), where
\(D_{j,i}=\gamma_j^*(t_i)\) is the *full* divisor.
This proof differentiates over \(k\), not over \(S\), and does not
assume that the upstairs residue field is separable.

Choose \(c_j\) independent such covectors and complete them to a
constant basis. It gives an injection
\[
 \mathcal H_j\hookrightarrow
 \mathcal O^{\rho+1-c_j}\oplus
                   \bigoplus_{\text{chosen }i}\mathcal O(-D_{j,i}).
\]
The top exterior power has a nonzero component. Of its
\(\rho+1-m_j\) selected line summands, at least
\(\max(0,c_j-m_j)\) must be negative. Each selected divisor has
degree \(d_j\) by (2). A nonzero map of line bundles has an effective
zero divisor, so
\[
                    B_j/d_j\geq\max(0,c_j-m_j).              \tag{7}
\]
This also covers rank zero. Since \(\nu(E_S)=0\), iteration of
(6) and (7) proves (A).

Write \(r_i=p^{u_i}\). Each height-one local index is at most \(p\).
Thus the label is ramified in every stage \(j<u_i\), whether or
not it is ramified at additional stages. Its weighted contribution
is at least
\(\sum_{j<u_i}w_j=1-p^{-u_i}\). Substituting
\(c_j\geq |I_j|-h\) in (7) and summing proves (B).

### Proof: descent and exact rounding over the original field

By (3), \(\nu_F(Z)\) is the degree of a line bundle on \(Z/F\),
hence of a divisor. Its pushforward to \(E/F\) preserves the
degree, so it belongs to \(N\mathbb Z\).

Let \(T=(\gamma^{-1}\mathcal B)_{\rm red}\) on \(Z/F\).
It is a divisor because \(Z\) is regular of dimension one.
Separable scalar extension preserves reducedness, so \(T_S\)
is exactly the reduced inverse image of the split labels.
At the unique point \(z_i\) above \(t_i\), (2) says
\[
             [\kappa(z_i):S]=d/r_i.
\]
Consequently
\[
 \deg_F(\gamma^*\mathcal B-T)
 =\deg_S(\gamma_S^*\mathcal B_S-T_S)
 =dn-\sum_i d/r_i
 =d\sum_i(1-r_i^{-1}).                                      \tag{8}
\]
These are full residue degrees; \(T_S\) need not be etale over \(S\).
The divisor in (8) was defined over \(F\), so pushforward makes its
degree a multiple of \(N\). The integer
\[
                 \Delta=\nu_F(Z)-d\sum_i(1-r_i^{-1})
\]
therefore belongs to \(N\mathbb Z\). By (B),
\(\Delta\geq-dE\). Condition (C) gives \(\Delta>-N\), hence
\(\Delta\geq0\). This finishes the complete proof of Theorem A.

## Theorem B: a sharper uniform threshold

For positive stage ranks with \(\sum m_j=a\), their exact error satisfies
\[
 E\leq \Phi_{p,a,h}(b)
 :=(h+1)(1-p^{-b})+(1-p^{-1})(a-b).                          \tag{9}
\]
Indeed, split \(m_j=1+(m_j-1)\). The unit parts contribute
\(1-p^{-b}\), and all remaining weights are at most \(w_0=1-p^{-1}\).
Equality in this *numerical profile bound* is attained by
\((a-b+1,1,\ldots,1)\). No assertion that this is a genus-equality
example is intended.

Let \(b_*\) be the smaller of \(a\) and the least positive \(b\)
with \(p^b\geq h+1\), and set
\[
 U_p(a,h)=\Phi_{p,a,h}(b_*),\qquad U_p(0,h)=0.                \tag{10}
\]
This is the maximum of (9), because
\[
 \Phi(b+1)-\Phi(b)
       =(1-p^{-1})\bigl((h+1)p^{-b}-1\bigr).                 \tag{11}
\]
An equality in (11) merely gives two maximizing lengths.
For \(d=p^a>1\), the sufficient threshold in Theorem A can therefore
be replaced by
\[
                         N>p^a U_p(a,h).                   \tag{12}
\]
For a uniform bound \(d\leq m\), put \(A=\lfloor\log_p m\rfloor\).
Then \(N>p^A U_p(A,h)\) suffices. To check monotonicity without
rounding real logarithms, keep a maximizing length for \(a\) when
passing to \(a+1\); its value increases by \(1-p^{-1}\).
Thus \(U_p(a,h)\), and then \(p^aU_p(a,h)\), increase with \(a\).
If \(A=0\), all allowed covers have degree one.

For example, for \(p=2,h=1,m=8\), (10) gives \(U_2(3,1)=2\).
The new threshold is \(N>16\); the manuscript uses \(N>32\).
For \(N=2^{s-1}\), this reduces the sufficient value of \(s\)
from 7 to 6. This is a genuine theorem-level improvement of the
sufficient threshold, not a counterexample to the original estimate.
It is not a claim that either geometric threshold is optimal.

## Application to the exact manuscript theorem

For the translated twist, its index is \(p^s\). Here is the
source-specific reason the index and rank inputs survive the stated
extensions, rather than a replacement by geometrically integral covers.

For a divisor of degree \(b\) on the twist, take its full geometric
group-law sum \(v\) after splitting. For an inseparable point, its
geometric multiplicity is its inseparable degree. Multiplication by
\(p^u\) moves that point into the corresponding separable field:
\([p]^*k(A)\subset k(A)^p\), since the invariant differential pulls
back to zero and \([k(A):k(A)^p]=p\). Normality permits evaluation
of the \(p\)th roots wherever their powers are regular. Taking the
sum over separable conjugates therefore gives \(v\in A(F')\),
even with inseparable residue fields.

An \(F'\)-point of \(A\) is a rational map \(A^n\dashrightarrow A\).
It is a constant plus endomorphisms in each coordinate. One can
verify the needed rigidity directly: an origin-preserving morphism
of an elliptic curve is a homomorphism by applying properness to
\(f(x+y)-f(x)-f(y)\); regarding a rational map as a morphism in
one variable over the other variables then splits off one such
endomorphism at a time. These endomorphisms descend to \(k\):
every \(A(k)\)-point is torsion for \(k=\overline{\mathbb F}_p\),
its torsion image belongs to the finite scheme \(A[N]\) and hence
is a \(k\)-point, and linear independence of finitely many scalar
coefficients recovers each rational function from its values on the
infinite set \(A(k)\). This argument does not assume that a general
\(F'\)-point is torsion.

Write \(v=c+\sum_i\beta_i(t_i)\). The twist descent gives
\(\sigma(v)+[b]P=v\), where
\(\sigma(t_i)=t_{i+1}-P\). Comparing the maps in each coordinate
forces all \(\beta_i=\beta\). The translation terms then sum to
\(\beta([p^s]P)=0\), so \([b]P=0\), and \(p^s\mid b\).
The descended degree-\(p^s\) divisor gives equality for the index.

Now any divisor degree \(e\) on \(E_F\) pushes down to a divisor
of degree \([F:F_0]e\) on \(E\). Since the \(p\)-part of this
extension degree is at most \(p^h\), it follows that \(N\mid e\).
This argument also proves the same statement on \(Z\) by pushforward,
with no separability condition on \(F/F_0\) or the residue fields.

The original forms \(t_i^*\eta\) are a basis of
\(\Omega_{F'/k}\). The degree identity
\[
 [S:F']\,[F':F_0]=[S:F]\,[F:F_0]
\]
and \([S:F]\mid p^s\) show \([S:F']_p\leq p^h\).
The two absolute differential spaces in
\[
 S\otimes_{F'}\Omega_{F'/k}\longrightarrow\Omega_{S/k}
                      \longrightarrow\Omega_{S/F'}\to0
\]
both have dimension \(n\), so the kernel's dimension is
\(\dim_S\Omega_{S/F'}\). A maximal separable subextension contributes
zero; an inseparable extension of degree \(p^u\) can be generated by
at most \(u\) elements, so this dimension is at most \(h\).
Every coordinate subset loses at most \(h\) ranks; projection shows
the same lower rank bound for \(v_i=(1,-t_i^*\eta)\).

All hypotheses of Theorem A are now available in the exact fields.
Finally \(m_j\leq a=\log_p d\) and \(\sum_jw_j<1\), so
\[
 dE<d(h+\log_p d)\leq m(h+\log_p m)<N.
\]
Theorem A proves the entire stated inequality, with the original
threshold unchanged, and Theorem B additionally lowers its sufficient
threshold. There is no refutation claim \(F_{\rm LABEL}\) to record
unless an actual false manuscript assertion is subsequently found.

## Literature and novelty limits

The primary statement in Stacks Tag 0CD0 requires both smoothness of
the source over the ground field and \(H^0=\) the ground field.
It therefore cannot replace the argument above. A web-search summary
that omitted those conditions was not adopted as evidence. The
primary section itself gives a regular but nonsmooth genus-change
example (Tag 0CD1), reinforcing the necessity of the distinction.

The rank-profile form and the smaller sufficient threshold are derived
here relative to the strongest relevant prior result, namely the
staged theorem with error \(h+\log_p d\). The limited literature
retrieval did not establish that these refinements are previously
published or that they are new. No `verified_new` novelty verdict or
independent publishability verdict is asserted by Engineer.

## Exact geometric controls and strictness

These are constructions with proofs, not a purported enumeration of
the manuscript's curves.

First take the smooth characteristic-two cubic
\[
 A:\quad Y^2Z+XYZ=X^3+Z^3.
\]
The affine Jacobian ideal is the unit ideal: \(f_y=x\) and
\(f_x=y+x^2\) would force \(x=y=0\), where \(f=1\).
At \(O=[0:1:0]\), \(f_Z=1\). This verifies smoothness.
Coordinate squaring preserves the equation and is the relative
Frobenius \(f:A\to A\), a purely inseparable degree-two morphism.
The source and target both have genus one. At \(O\), \(X/Y\) is a
local parameter and pulls back to its square, so the index is two
and the residue degree is one.

For the single mark \(O\), the covector rank is one, \(m_0=1\),
\(h=0\), \(N=1\), and \(dE=2(1/2)=1=N\).
Nevertheless the exact marked-ramification inequality without the
strict threshold would read \(0\geq1/2\), which is false.

There is also a positive-\(h\), nontrivial-index version. Use this same
curve over \(\overline{\mathbb F}_2\), its nonzero two-torsion point
\(P=(0,1)\), and the translated cyclic twist with \(s=1,n=2\).
The point is its own inverse under the Weierstrass formula
\(-(x,y)=(x,y+x)\), and squaring fixes it. The index proof above
gives an index-two torsor \(E/F_0\). Frobenius commutes with the
semilinear descent action:
\[
 f(\sigma(x)+P)=\sigma(f(x))+P.
\]
It therefore descends to a degree-two radicial endomorphism \(E\to E\).
Now use the descended divisor \(D=O+P\), not the manuscript's
generic-projection divisor \(\mathcal B\). Both split labels are
constant, so their two conormal covectors have rank one. Thus \(h=1\)
works for every subset, \(N=2\), \(d=2\), \(m_0=1\), and \(dE=2=N\).
Both ramification indices are two, while \(\nu(E)=0\).
The weakened assertion would read \(0\geq1\). This proves:

**Strictness proposition.** In Theorems A and B the strict sufficient
threshold cannot be replaced uniformly by a weak inequality, even
for \(h=1\), index two, and smooth geometrically integral covers.

This construction does not refute the manuscript: it uses the other
descended divisor and fails the required strict threshold. The only
Frobenius input is the usual relative Frobenius of a smooth curve,
whose degree here can also be read from its one-variable function
field over perfect constants. Its descent uses the explicitly checked
identity above, not an assertion that arbitrary twists admit a
degree-two Frobenius endomorphism.

For the constant-field control, take \(u\in F\setminus F^p\),
\(L=F(u^{1/p})\), and \(Z=E_L\) regarded as a curve over \(F\).
Geometric integrality of \(E/F\) makes the generic extension degree
\(p\). The finite map \(E_L\to E\) has normal source and is the
normalization; its source is regular and projective over \(F\).
It is not geometrically reduced over \(F\), since after algebraic
closure the constant algebra is a nonreduced length-\(p\) algebra.
Flat cohomology base change gives \(H^0=L=H^1\), so \(\nu_F(Z)=0\).
At any split rational label the parameter is unchanged: \(r=1\)
and the residue degree is \(p\). Accordingly the reduced inverse-image
point has degree \(p\), not 1. The same construction is available over
the manuscript's imperfect \(F_0\); a separable splitting extension
cannot contain the missing purely inseparable root.

These controls explain why imposing geometric reducedness, replacing
full residue degrees by point counts, or using smooth-source genus
invariance would not be a valid proof of the target.

## Reproducible certification and outstanding review

Run, from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/genus-bound-audit/verify.py
```

The script needs Python 3.10 or later and SymPy. It replays the
recorded exact Jacobian determinant independently, checks universal
rational-polynomial residuals, examines every positive stage-rank
composition with \(1\leq a\leq8\) for the stated small primes and
rank allowances (5,100 cases), and checks all binary local paths of
length at most eight (2,040 cases). It also checks the explicit
cubic's smoothness and Frobenius polynomial, and validates that the
official Lean record still matches the source and fidelity document.
Those finite experiments are separate from the complete prose proof.

The real Lean 4.31.0 compiler has returned exit code zero with no
proof holes for `C_FORMAL_CORE`. To repeat that compiler run, use:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/genus-bound-audit/lean/Main.lean --statement-fidelity research/genus-bound-audit/lean/statement_fidelity.md --claim C_FORMAL_CORE --project-root .
```

The compiler establishes the arbitrary-size Frobenius determinant
identity, the genus-recurrence numerator, the geometric sum, the
universal discounted-error bound, and the degree-lattice deduction.
It does not establish the geometric hypotheses, the geometry in
Theorem A, the optimizing-length argument, the strictness construction,
or novelty. `exact_certificate.json` records that boundary explicitly.

The independent Reviewer has not yet been invoked. All geometric
claims, statement fidelity, significance and novelty remain subject
to that review; there is no final campaign acceptance. Primary-source
passages for the five used classical inputs are in `literature/`
beside this report. Independent citation attribution is also pending.
The citation adapter's fixed archive destination, `research/literature/`,
is outside this mission's writable paths, so the Host must arrange
that archival through an authorized path owner rather than asking
this mission's Reviewer to write outside its boundary.
