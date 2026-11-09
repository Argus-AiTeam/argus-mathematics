# Marked-coefficient transfer audit

## Exact scope

The target is the connected argument in `05-quot.tex`, Lemma
`marked-universality` and the scalar interface, and `06-coefficient.tex`,
Lemma `moment-additivity` through `scalar-final-series`, in the staged
September 24, 2026 manuscript. The question is about its fixed marked
polynomial, not merely about numerical universality or the final residue.
The determinant-fixed obstruction theory, detector, compactification,
and support induction are separate, unverified dependencies.

Work starts with the manuscript's actual series: two Hilbert factors,
two fixed Euler classes, both cross Hom factors, independent shifts
`x_e,x_m`, and the exponential of the sum of incidence classes.
All coefficient rings are rational, all cutoffs finite, and surface
cohomology insertions may be even and inhomogeneous.

## Known inputs and excluded shortcut

The consecutive nested surface Hilbert scheme, its universal ideal
sequence, and the resolution Segre push formula are the geometric inputs
from Ellingsrud--Goettsche--Lehn, arXiv:math/9904095v1, Section 1,
especially Lemma 1.1. The manuscript also invokes that paper's
Theorem 4.2 for the numerical disjoint-union method. Its numerical
universality alone is not being taken as a proof of marked Chow
universality or of compatibility with an Euler shift.

The route "infer the fixed marked coefficient directly from ordinary
numerical universality" is excluded: equality only on genuine moment
vectors does not by itself identify an arbitrary formal coefficient,
and an Euler shift can unmask a surface-degree relation. The required
replacement is to prove that the *particular evaluation* lies in the
genuine span and to apply additivity to each shifted invariant before
differentiating. This is an obstruction to a shortcut, not a
counterexample to the manuscript.

## Result and its limits

The selected transfer has a uniform proof. In particular, the suspected
failure of the genuine-moment span does **not** occur. Both shifts must be
retained independently until after additivity has been applied to the
shifted invariant. Doing this gives the manuscript's

\[
 [x]c(q,x,x)=\frac{q(1+2q)}{(1+4q)^{3/2}}
\]

and its equation `scalar-final-series`, for arbitrary finite cutoffs.
This is a mathematical proof with an offline exact-algebra certificate,
**not** a kernel formalization of Chow theory. Independent Host review
is pending. It neither proves nor refutes the manuscript's main theorem.

The argument also gives an all-arity extension. This extension is stated
below without claiming certified novelty or publishable significance.
Numerical logarithmic additivity itself is explicitly prior art in EGL.

## Primary-source scope

A separate read-only source reader, `egl-primary-reader`, obtained and
read the following primary texts during this task:

1. [EGL, arXiv:math/9904095v1](https://arxiv.org/abs/math/9904095v1),
   Sections 1, 3, 4. Section 1 identifies consecutive nesting with
   the **quotient** projectivization of the universal ideal and supplies
   the residual ideal sequence. It records smoothness, attributing it
   to earlier work; it does not prove that fact there. Lemma 1.1 states
   \(\sigma_*(\ell^i)=(-1)^i c_i(\mathcal O_n)=(-1)^i c_i(-I_n)\).
   The proof uses a two-term locally free resolution. Theorem 4.2
   establishes the numerical disjoint-union/logarithmic-linearity
   method; its proof concludes that "log h is a linear function."
   Its stated result is not arbitrary-output relative Chow universality.
2. [Kong, arXiv:2608.25447v1](https://arxiv.org/abs/2608.25447v1),
   Section 2.1, Lemma 2.1 and Proposition 2.2, and Section 3.3,
   Lemma 3.4. For a smooth projective surface family over a smooth
   connected quasi-projective base, Lemma 2.1 supplies the relative
   projectivization, exact sequences and the same pushforward sign.
   Proposition 2.2 integrates to the base. Lemma 3.4 concerns one and
   two outputs for curve families, the two-point factorization being
   off the relative diagonal. It is not the surface all-output theorem.

These are geometric inputs, not endorsements of the manuscript's
conclusion. The usual rational Chow projection formula, flat base change,
regular-embedding Riemann--Roch, excess intersection, and the elementary
geometry of symmetric powers of smooth curves are accepted background.
They are not kernel-verified here.

Two targeted prior-art searches found no inspected primary passage
giving the complete bare-moment/Euler-shift transfer or the all-arity
formula below. This bounded negative lookup is **not** proof of novelty.
The strongest prior result in the campaign ledger was an untested
objective; there was no prior verification or counterexample to improve.
Relative to the manuscript, the addition here is a constructive
span formula, an explicit cutoff argument for twisting, and the
simultaneous/all-arity identities, not a new numerical-universality method.

## Uniform transfer theorem

Write \(\Theta\) for exactly the series in `theta-series`, with exactly
the moving ratio in `moving-ratio`. Keep \(L,H\) independent of
\(K,A_0,D\), put \(B=-A_0-D\), and keep \(x_e,x_m\) independent.
Let

\[
 {\cal D}=q\frac{d}{dq},\qquad
 w(1+w)=q,\quad w(0)=0.
\]

Every assertion below is coefficientwise: choose any finite Hilbert
length, output and shift cutoffs before calculation. The statements for
different cutoffs agree under further truncation.

For \(m\geq1\), let \(E_m\) keep actual top-degree unmarked intersection
numbers, give \(M_m(1)\) value one, and give every other marked moment
value zero. For any cutoff containing \(m\), there are universal series
\(C_m(q,x_e,x_m)\), independent of the surface intersection numbers,
such that

\[
 \begin{split}
 E_m(\Theta)&=U(q,x_e,x_m)
           \exp\left(C_m(q,x_e,x_m)\frac{p^m}{m!}\right), \tag{1}\\
 C_m&={\cal D}^{m-1}C_1, \tag{2}\\
 C_m(q,0,x_m)&=0, \tag{3}\\
 [x_e]C_m(q,x_e,0)&={\cal D}^{m-1}w, \tag{4}\\
 [x]C_m(q,x,x)&={\cal D}^{m-1}w. \tag{5}
 \end{split}
\]

Here \(U=\Theta|_{p=0}\) on the actual unmarked data. More generally, if
the bare moments \(M_m(1)\) have arbitrary rational values \(\lambda_m\)
within a finite cutoff and every positively decorated marked moment is
zero, the exponent in (1) is
\(\sum_m\lambda_m C_m p^m/m!\).

For any integer \(j\geq0\), (1)--(5) imply

\[
 [p^{mj}x^j]E_m(\Theta(q,p,x,x))
 =\frac{U(q,0,0)}{(m!)^j j!}
       ({\cal D}^{m-1}w)^j. \tag{6}
\]

In particular \(m=3\) is the manuscript's bare-triple coefficient.
No linear independence of Chow diagonals, of genuine moment vectors,
or of arbitrary formal moment coordinates is asserted.

### Proof: the retained-output recursion

It suffices to prove a statement for each finite polynomial integrand;
Euler inverses are dealt with by truncation below. For a Hilbert factor
of positive length \(r\), set \(N_r=X^{[r-1,r]}_{/S}\) with maps
\(\psi,\phi,\rho,\sigma=(\phi,\rho)\) as in the manuscript.
All output factors are carried along unchanged.

The Hilbert and consecutive nested schemes are smooth over \(S\).
One may either use Kong's relative construction or reduce smoothness
etale locally at the finite support to the plane. On the distinct-point
locus \(\psi\) has degree \(r\). Therefore, for an operational class
\(a\) on the product including every output,

\[
 \psi_*(\psi^*a\cap[N_r])=r\,a\cap[X^{[r]}_{/S}].
\]

Rational division by \(r\) is legitimate. In each surface slot use

\[
 [\psi_X^*I_r]=[\phi_X^*I_{r-1}]-[j_*{\cal L}]. \tag{7}
\]

The minus sign in (7) is fixed by the exact sequence, not by a
numerical convention. The graph \(j\) is a regular codimension-two
embedding with normal bundle \(\rho^*T_{X/S}\), so

\[
 \operatorname{ch}(j_*{\cal L})
 =j_*\left(e^\zeta\,\rho^*\operatorname{td}(T_{X/S})^{-1}\right).
 \tag{8}
\]

Duals use \(\operatorname{ch}_i(F^\vee)=(-1)^i\operatorname{ch}_i(F)\).
If \(0\to V_-\to V_+\to I_{r-1}\to0\) is a locally free resolution,
then \(\operatorname{rk}V_+=\operatorname{rk}V_-+1\).
The quotient projectivization is the regular zero locus of
\(V_-^\vee(1)\) in \(\mathbb P(V_+)\). The projective bundle formula
gives, with no change of convention,

\[
 \sigma_*(\zeta^a)=
 \left[\frac{c(V_-^\vee)}{c(V_+^\vee)}\right]_a
 =(-1)^a c_a(-I_{r-1}). \tag{9}
\]

This agrees with EGL Lemma 1.1 and Kong Lemma 2.1. In particular it
is not the unsigned Segre class of the ideal.

After (7)--(9), every coefficient is pulled back from the smaller
Hilbert factors and the residual surface coordinate. Separate any
products of surface pushes into distinct auxiliary coordinates before
using the projection formula. This also applies to the
Riemann--Roch expressions for tautological bundles and both point Hom
complexes. Each step strictly lowers total Hilbert length.

At length zero, choose an order on equality edges. An edge joining
different connected components identifies their coordinates with no
excess; an edge inside a connected component contributes
\(c_2(T_{X/S})\). Thus a connected component touching outputs is
their equality diagonal decorated on its common coordinate.
A component touching no output is pushed to the base. No output has
been integrated. These operations prove the required relative marked
formula, not just a numerical integral formula. Fixing the reduction
and edge orders once gives the polynomial representative in question.

The formulas are functorial for the flat base changes and line-bundle
twists used below. Their reduction order depends on the Hilbert factors
and equality graph, not on numerical values of \(L,H\) or either shift.

### Proof: finiteness and the Euler twist

Put \(n=r+s\). The moving weights have invertible constant term
(\(1-x_m\) or \(-1+x_m\)); their Euler inverses have no negative
intrinsic Chow degrees. The fixed Euler factors also have no negative
intrinsic degrees after expanding in \(x_e\).

A monomial selecting \(j\) bare output components has total
Euler-plus-moving intrinsic degree \(2n-2j\). To see this, if there
are \(k\) outputs, the incidence classes have degree \(2k\) before
the Hilbert push, while the bare output diagonals have degree
\(2(k-j)\); pushing the Hilbert product subtracts \(2n\).
Thus moving terms of intrinsic degree greater than \(2n\) can
contribute neither to genuine numerical integrals nor to this selected
coefficient. The bound is independent of \(H\) and remains valid
after an Euler shift. All relevant expansions are consequently finite.

One must nevertheless keep decorations of degree greater than two in
the *unspecialized* relative polynomial. Discarding \(H^3\) before
twisting would be wrong: its first shift produces \(-3x_eH^2\).
The moving-degree bound just proved does not make that discard.

On the constant surface family over \(\mathbb P^a\), take
\(a\) larger than the shift cutoff, write \(t=c_1(\mathcal O(1))\),
and replace the surface line \(H\) by
\(H\otimes\mathcal O(-1)\). Finite-flat pushforward for the universal
subscheme gives

\[
 (H\otimes\mathcal O(-1))^{[s]}
       =H^{[s]}\otimes\mathcal O(-1).
\]

Hence

\[
 e_t((H^{[s]})^\vee)
       =(-1)^s e((H-t)^{[s]}).
\]

In (8), and in the tautological Riemann--Roch calculation, tensoring
multiplies the relevant Chern character by \(e^{-t}\).
The projection formula moves every \(t\) outside the push.
Therefore *the fixed polynomial procedure itself* commutes with

\[
 M_k(H^a\beta)\longmapsto
 \sum_{i=0}^a\binom ai(-t)^iM_k(H^{a-i}\beta). \tag{10}
\]

Since \(1,t,\ldots,t^a\) are independent in \(CH^*(\mathbb P^a)_\mathbb Q\),
this proves covariance for every coefficient within the cutoff.
No assertion that \(H-t\) is a numerical surface divisor is involved.
The moving ratio contains no auxiliary \(H\), so it is unchanged.
Equation (10) is linear on moment symbols and preserves their number
in a monomial as well as their marked weight \(k\).

### Proof: a constructive genuine-span lemma

Let \(K\) be the largest marked weight present in the chosen finite
polynomial. Fix any connected surface with the required line data and
a degree-one point class \(P\). Let \(v(z)\) be its genuine numerical
moment vector, including all retained decorations, and put

\[
 d(u)=v(u+P)-v(u).
\]

Because \(P^2=0\), \(\int_XP=1\), and \(P\alpha=0\) for every
positive-degree decoration, the only nonzero coordinates are

\[
 d(u)_{M_k(1)}=k u^{k-1},\qquad 1\leq k\leq K. \tag{11}
\]

Unmarked coordinates cancel. This uses actual rational Chow classes,
not hypothetical independent numerical invariants.

For nodes \(0,\ldots,K-1\), let

\[
 \ell_i(T)=\prod_{\substack{0\leq h<K\\h\ne i}}
                    \frac{T-h}{i-h},\qquad
 a_i^{(m)}=\frac1m[T^{m-1}]\ell_i(T).
\]

The Lagrange identity for \(T^{k-1}\) gives

\[
 \sum_{i=0}^{K-1}a_i^{(m)}k i^{k-1}=\delta_{km}. \tag{12}
\]

Consequently, if \(e_m\) is the vector with its sole nonzero coordinate
at \(M_m(1)\), then

\[
 e_m=\sum_i a_i^{(m)}d(i),\qquad E_m=v(0)+e_m. \tag{13}
\]

The Vandermonde determinant is
\(K!\prod_{0\leq i<j<K}(j-i)\ne0\).
Equations (11)--(13) prove the span assertion for **every** finite
\(K\), and simultaneously for arbitrary bare values \(\lambda_m\).
The exact program constructs these polynomials and checks an
eight-moment instance; the proof is (12), not that finite instance.

### Proof: what disjoint-union additivity actually implies

At each finite cutoff, take \(\log\Theta\) as a polynomial in the
moment variables with coefficients in the truncated \(q,p,x_e,x_m\)
ring. It exists since the length-zero term is one.
For genuine data the series is multiplicative under disjoint unions:
Hilbert schemes split by component lengths, tautological Euler
classes split, cross Hom complexes between different components
are zero, and incidence exponentials multiply.

For any finite list of genuine vectors \(v_1,\ldots,v_h\) and
nonnegative integers \(n_i\), each coefficient polynomial \(F\) of
the logarithm therefore satisfies

\[
 F\!\left(\sum_i n_i v_i\right)=\sum_i n_i F(v_i). \tag{14}
\]

Both sides are polynomials in the \(n_i\). A polynomial over
\(\mathbb Q\) vanishing on the whole nonnegative integer grid is
zero, by induction on its number of variables. Thus (14) holds
for rational \(n_i\). Decomposing by moment-count proves that its
constant part and every part of count at least two vanish on the
rational span \(V\) of genuine vectors. Only its one-moment part
survives on \(V\).

This is **not** a claim that the full formal logarithm is linear
in independent moment symbols. It is linear only on \(V\).
Since (13) places the required evaluation in \(V\), that is enough.

Every coefficient of \(p^k\) has marked weight \(k\): each insertion
creates one retained output, reductions never remove an output,
and logarithmic multiplication preserves this weight. Its
one-moment part must therefore be

\[
 \frac{p^k}{k!}\sum_\alpha b_{k,\alpha}(q,x_e,x_m)M_k(\alpha).
 \tag{15}
\]

Equations (13)--(15), followed by exponentiation, prove (1) with
\(C_m=b_{m,1}\), and prove its simultaneous-moment version.
The coefficients \(b\) are universal coefficients of the polynomial,
not functions of unmarked intersection numbers.

The same reasoning applies **for each pair of shifts**. If the
logarithm is split by moment-count before (10), then (10) preserves
that split; the shifted components of count at least two still
vanish on \(V\). Their derivatives also vanish at \(E_m\).
This is precisely why unmasking \(M_0(H^3)\) in an individual
nonlinear monomial is not a counterexample.

There is a useful further uniqueness statement. Two fixed universal
representatives computing the same genuine shifted invariant agree
on all nonnegative combinations of any finite set of genuine
vectors. Applying grid interpolation to their difference shows that
they agree on \(V\), hence at (13), after shifting as well.
The selected evaluation is therefore not an arbitrary extension
off the numerical locus.

### Proof: shift differentiation and all arities

At zero shifts, write \(b_{m,H}=C_{H,m}(q)\) in (15).
Differentiate (10) and then apply \(E_m\).
The only term in (15) that can become an undecorated marked moment
is \(M_m(H)\), and its derivative is \(-M_m(1)\).
Unmarked terms cannot appear at positive \(p\)-degree. By the
shifted additivity just proved, all higher moment-count terms
contribute zero. Thus, uniformly in length,

\[
 [x_e]C_m(q,x_e,0)=-C_{H,m}(q). \tag{16}
\]

For completeness, all arities are related even before taking a shift
derivative. On genuine data put \(z=u+cP\).
The unit incidence has value \(r+s\), so

\[
 \left.\partial_c\log\Theta(q,p;u+cP)\right|_{c=0}
                  =p A(qe^{pu},x_e,x_m) \tag{17}
\]

for the point-incidence series divided by the unmarked series.
On the other hand, (15) and \(P\alpha=0\) for positive decorations
give the same derivative as

\[
 p\sum_{m\geq1}C_m(q,x_e,x_m)\frac{(pu)^{m-1}}{(m-1)!}. \tag{18}
\]

At \(u=0\), (17)--(18) identify \(A=C_1\).
Expanding \(A(qe^{pu})=\exp(pu{\cal D})A(q)\) proves (2).
This expansion is finite at every prescribed marked cutoff.

At \(x_e=0\), choose smooth transverse very ample representatives
of \(L,H\). Their tautological sections have regular zero schemes
\(L^{(r)},H^{(s)}\), respectively. Taking dual Euler classes
contributes sign \((-1)^{r+s}\).
The point class restricts to zero on either curve. Hence the
point perturbation in (17) is zero, with \(x_m\) still independent.
Equation (18) shows \(C_m(q,0,x_m)=0\).
Since this is the coefficient of a single bare moment in the
universal one-moment part, its vanishing is independent of all
intersection numbers. This proves (3), including for negative
lines after later specialization.

### Proof: the two-curve calculation and the coefficient of \(H\)

Here both shifts are zero and \(z=u+\tau Z\) with \(Z\) a divisor.
Set

\[
 d_1=(A_0+2D)L,\quad d_2=BH,\quad I=LH,\qquad
 2h_1-2=L(L+K),\quad 2h_2-2=H(H+K).
\]

On an ordered symmetric power, the roots of a tautological line
are \(M_i-\delta_i\), with
\(\delta_i=\sum_{j<i}\Delta_{ij}\).
Two surface line restrictions at the same curve position multiply
to zero. Writing \(t_i=1+\delta_i\), the low one-body quotient,
including its dual Euler sign, becomes

\[
 \frac{t_i-K_i-A_{0,i}}
      {(t_i-K_i+B_i)(t_i+B_i)}
       =\frac1{t_i-(A_0+2D)_i}. \tag{19}
\]

Cross multiplication proves (19) in the ring where products of
line classes at that position are zero; `verify.py` checks this
symbolic identity. The high factor is
\((-1)^s c_{+1}(B^{[s]})^{-1}\).

At one transverse intersection of \(L,H\), resolving the two
independent point-containment divisors gives the point Hom
character

\[
 e^{x'}(1-e^{-x'})(1-e^{-y'})
   =e^{x'}+e^{-y'}-1-e^{x'-y'}.
\]

The determinant normal of the first subscheme accounts for \(e^{x'}\).
Its Euler class at weight one is
\((1+x')(1-y')/(1+x'-y')\). The two Hom terms have the same
numerical character, since surface line twists at the fixed
intersection point have degree zero. Their product over the \(I\)
intersections is

\[
 \left(\frac{(1+x')(1-y')}{1+x'-y'}\right)^{2I}. \tag{20}
\]

In particular, omitting a Hom term would change the exponent.
The incidence exponential restricts to
\(\exp(pu(r+s)+p\tau(ZL\,x'+ZH\,y'))\).

For a line of degree \(d_1\) on a curve of genus \(h\), the
universal divisor sequence and Riemann--Roch give

\[
 \operatorname{ch}(M^{[r]})
 =d_1+1-h+(r-d_1-1+h+\vartheta)e^{-x'},\qquad
 c_a(M^{[r]})=(1-a x')^{r-d_1-1+h}
        \exp\left(\frac{a\vartheta}{1-a x'}\right). \tag{21}
\]

The mixed part of the universal divisor has square integral
\(-2\vartheta\), which fixes the sign in (21).
On the ordered cover, expanding the polarization in a symplectic
basis and then intersecting the point divisors gives

\[
 \int (x')^{r-j}\frac{\vartheta^j}{j!}=\binom hj. \tag{22}
\]

Indeed only distinct symplectic pairs survive; their choice gives
\(\binom hj\), after division by the cover degree and by \(j!\).
Equations (21)--(22) turn low integration into

\[
 [x'^r](1+x')^{d_1+1-2h_1-r}(1+2x')^{h_1}.
 \tag{23}
\]

For example, summing the polarization terms amounts to multiplying
by
\(\sum_j\binom{h_1}j(x'/(1+x'))^j
=((1+2x')/(1+x'))^{h_1}\), which gives (23).
Replace \(y'\) by \(-y'\) for the high factor. This absorbs
\((-1)^s\), changes (20) to
\(((1+x')(1+y')/(1+x'+y'))^{2I}\), and changes the divisor part
of the exponential to \(p\tau(ZL\,x'-ZH\,y')\).

For any formal series \(F\),

\[
 \sum_{r\geq0}Q^r[x^r]\frac{F(x)}{(1+x)^r}
        =F(w)\frac{1+w}{1+2w},\quad w(1+w)=Q. \tag{24}
\]

This is a uniform formal-residue identity: summation gives the
kernel \(F(x)(1+x)/(x(1+x)-Q)\), whose small-root residue has
denominator \(1+2w\). Equivalently, the invertible change
\(Q=x(1+x)\) gives the same formal residue coefficientwise.
There is no analytic contour or convergence assumption.

Apply (24) successively to (23) and its high analogue, with
\(Q=qe^{pu}\). Both roots are the same \(w=w(Q)\).
The complete result is

\[
 \log\Theta(q,p,0,0)
  =A\log(1+w)+G\log(1+2w)
                  +p\tau(ZL-ZH)w, \tag{25}
\]

\[
 A=d_1+d_2+4-2h_1-2h_2+4I,\qquad
 G=h_1+h_2-2-2I.
\]

The two Jacobian factors in (24) supply the constants \(+4\)
and \(-2\); the squared cross Hom contributes \(+4I\) and \(-2I\).
Thus (25) retains both Hilbert factors and their coupling.

Only degree-one decorations in (15) contribute to
\(u^{m-1}\tau\), and

\[
 [u^{m-1}\tau]M_m(H)=m\,ZH.
\]

Keep all other lines fixed and vary the very ample \(H\) through
arbitrarily large multiples of a fixed ample line, with \(Z\)
ample. The only varying degree-one intersection in this coefficient
is \(ZH\). The first two terms of (25) have no \(\tau\).
Its last term gives
\(-{\cal D}^{m-1}w/(m-1)!\) as the coefficient of
\(p^m u^{m-1}\tau ZH\). Comparing with (15) proves

\[
 C_{H,m}(q)=-{\cal D}^{m-1}w. \tag{26}
\]

Equations (16) and (26) prove (4). Since (3) kills the derivative
with respect to \(x_m\) at \(x_e=0\), differentiating along the
diagonal \(x_e=x_m=x\) proves (5). The two shift derivatives have
not been conflated.

To obtain (6), the selected \(p^{mj}\) term in (1) is
\(U C_m^j/((m!)^j j!)\). By (3), \(C_m\) is divisible by \(x\)
on the diagonal. Thus its \(x^j\) term uses the linear term in
each factor and the constant term of \(U\). This proves (6).

### The triple identity and the manuscript's final series

Implicit differentiation of \(q=w(1+w)\) gives

\[
 {\cal D}w=\frac{q}{1+2w},\qquad
 {\cal D}^2w=\frac{q(1+2q)}{(1+2w)^3}
           =\frac{q(1+2q)}{(1+4q)^{3/2}}. \tag{27}
\]

The square root is the formal branch with constant term one.
`verify.py` checks (27) as a rational-function identity in an
indeterminate \(w\), not by matching finitely many \(q\)-coefficients.
It also checks the generic coefficient identity underlying

\[
 {\cal D}^k w=\frac{q P_k(q)}{(1+4q)^{k-1/2}},\quad
 P_1=1,\quad
 P_{k+1}=(1+(6-4k)q)P_k+q(1+4q)P_k'. \tag{28}
\]

The recurrence follows for every \(k\) by the power and product
rules; checking a monomial \(P_k=q^j\) reduces it to the formal
identity
\(4(j+1)-(4k-2)=4j+6-4k\).

At \(p=0\), substitute \(L=K,H=K-D,A_0=K,D=dK\) in (25).
Polynomial continuation from very ample \(L,H\) is legitimate
coefficientwise: varying their two ample multiples gives an infinite
integer grid for each finite polynomial. This does not claim
that \(K-D\) itself has a smooth effective representative.
Writing \(s_K=K^2\), elementary substitution gives

\[
 A=ds_K,\qquad G=\frac{d(d+1)}2s_K,\qquad
 U(q,0,0)=(1+w)^{ds_K}(1+2w)^{d(d+1)s_K/2}. \tag{29}
\]

The two exponent identities in (29) are also checked symbolically
as polynomials in \(d\), with \(s_K\) factored out.

Now put \(m=3,j=t\), multiply by \((1-x)^{\chi(B)}\), and use
(6). That additional factor has constant term one, so cannot change
the lowest possible \(x\)-degree \(t\). With \(N=t-1+ds_K\),
(27)--(29) give exactly

\[
 a_{N,t}
 =\frac1{6^t t!}[q^{ds_K-1}]
       (1+w)^{ds_K}(1+2q)^t(1+4q)^E,\qquad
 E=\frac{d(d+1)s_K}{4}-\frac{3t}{2}. \tag{30}
\]

This is `scalar-final-series`, before its separate sign-definite
residue argument. The factor \(q^t\) in \(({\cal D}^2w)^t\)
accounts for the shift from \(N\) to \(ds_K-1\).
The exponential normalization is \(6^t t!\), while changing to
labeled outputs multiplies by \((3t)!\). These are different factors.

Finally, the retained-output recursion identifies a component with
three marked outputs and decoration one with its bare triple
diagonal. Therefore \(E_3\) selects exactly the sum of coefficients
of all such partitions in that fixed expression. The numerical
calculation above computes this selected scalar; it does not
replace a Chow identity by a numerical identity. The subsequent
tensor-test identification and localization relation remain the
separate obligations recorded in the proof graph.

## Independent localization probe

This is a second, finite falsification mechanism, not the proof of
the uniform theorem. It checks the Euler-shift sign directly rather
than checking only the final residue or re-expanding (27).

Take a toric \(\mathbb P^2\), choose a fixed point \(P\), and
linearize \(L,H,B\) to have zero weight there. Represent the point
class by its equivariant lift supported at \(P\).
At a partition with any points at \(P\), an unshifted fixed Euler
class has a zero root. In the first high-Euler derivative with a
point insertion, low length at \(P\) must consequently be zero.
Away from \(P\), all factors, including both cross Hom Euler
factors, cancel in the ratio of the point-marked derivative to the
unmarked series. Cross Hom factors between different fixed points
are zero. Thus the local calculation really is the derivative
of the original coupled invariant; no cross term is dropped where
it is nonzero.

For a partition \(\lambda\) of \(n\), a box \((i,j)\) has
function weight \(-ia-jb\), whereas the tangent weights are

\[
 (\operatorname{arm}+1)a-\operatorname{leg}b,\qquad
 (\operatorname{leg}+1)b-\operatorname{arm}a.
\]

Let \(T_\lambda\) be their product, and \(h_{n-1}\) the complete
homogeneous polynomial in the contents \(ia+jb\).
Scaling tangent weights by \(\epsilon\), the zero-root Euler
derivative supplies
\(\epsilon^{n-1}\prod_{(i,j)\ne(0,0)}(ia+jb)\).
The point incidence supplies \(nab\,\epsilon^2\); the Hilbert
tangent denominator supplies \(\epsilon^{2n}T_\lambda\).
The remaining high moving factor is
\(\prod_{(i,j)}(1-\epsilon(ia+jb))^{-1}\).
Its \(\epsilon^{n-1}\) coefficient is \(h_{n-1}\).
The non-equivariant local contribution is therefore

\[
 \sum_{\lambda\vdash n}
 \frac{nab\,
       \prod_{(i,j)\ne(0,0)}(ia+jb)\,
       h_{n-1}(\{ia+jb\})}{T_\lambda}. \tag{31}
\]

The program independently enumerates every partition for
\(1\leq n\leq8\), computes (31) over exact rational numbers in
three weight chambers \((11,37),(7,19),(5,-13)\), and obtains

\[
 1,-1,2,-5,14,-42,132,-429.
\]

These are the coefficients of \(w\); the all-arity relation
multiplies the \(n\)-th value by \(n^{m-1}\). In particular the
triple values are
\(1,-4,18,-80,350,-1512,6468,-27456\).
Both positive and negative tangent chambers give the same answer.
This bounded calculation found no contradictory witness and is
not being called a verification at arbitrary length.

## Reproducibility and residual obligations

Run, without network access or third-party Python packages:

```bash
python3 research/marked_coefficient_audit/verify.py
```

The script recomputes every machine-checkable field of
`exact_certificate.json`; it does not accept a stored Boolean verdict.
`--write-certificate` regenerates that file from the same exact
calculations. The program separates symbolic polynomial identities
from the finite interpolation instance and finite localization probes.

Before any custom algebra code was written, the authorized Argus
adapter was queried with `--help`, `find`, and `inspect` for
`formal_series.rational.multiply.compute`. Its bounded run used
`jacobian_payload.json`. The complete typed response is
`jacobian_result.json`, and the adapter exit/timeout status is
`jacobian_adapter_status.json`. The response preserves protocol
`2025-11-25`, server `0.14.0`, operation id, exact payload, output,
and runtime. Its scope is only multiplication modulo \(q^6\).
The offline verifier derives both operands and recomputes the
convolution rather than trusting that output. No UNKNOWN, incomplete,
timeout or transport result is used as mathematical evidence.

The campaign's initial dependency graph and cited nested-Hilbert input
were recorded before implementation, and both initial campaign-local
checks returned zero at
`campaigns/9000053`.
The final checks also returned zero at that same campaign root:
`final_validation.json` records `math_state_exit=0` and
`proof_graph_exit=0`; the graph contains sixteen nodes. All proof
nodes remain unconfirmed by a Reviewer. The isolated-Python replay
of the persistent exact certificate returned zero.

The citation gate is a distinct, still-open gate:
`citation_check status` returned exit one because `A_EGL_NESTED`
has no recorded independent attribution. The separate source
reader's lookup above is not a `citation_check` attribution.
The two explicitly accepted foundational-background assumptions
are reported as `uncited`. Passing the structural checks does
not clear these source-review obligations.

Independent review must judge the geometric proof, its statement
fidelity and any novelty/significance claim; exact arithmetic cannot
do that. In particular, the determinant-fixed obstruction theory,
fixed-branch exclusions, faithfulness of the tensor test, arbitrary-color
argument, detector, compactification comparison, support induction and
the final main theorem remain unverified here. The campaign has not
earned a publishable-completion or independent-certification verdict.
