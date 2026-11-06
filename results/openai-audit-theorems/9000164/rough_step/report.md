# Uniform rough-step removal, with an explicit finite-power refinement

## Result and scope

This is an independent proof of Proposition `prop:rough-step`, conditional
only on the external results listed below. It also proves a stronger spatial
scale statement. It is not a proof of the manuscript's main finite
sums-and-products theorem: Prediction, Alignment, cube lifting, correlation
estimates, and the final combinatorial deduction remain outside this
certification.

The analytic argument is a mathematical proof, not a finite experiment and
not a Lean formalization of equidistribution. `Main.lean` formalizes its exact
division, rational exactness, coprime cancellation, residue reparametrization,
and noncommutative factorization core. `verify.py` independently recomputes
exact supporting witnesses, including the Jacobian interpolation output.
Neither computation is represented as a machine proof of the entire analytic
argument. Independent Reviewer acceptance and a novelty determination are
reserved for the Host-invoked Reviewer.

### Theorem 1: the requested postcondition

Fix a compact nilmanifold \(G/\Gamma\), where \(G\) is connected, simply
connected and nilpotent, fixed rational logarithmic coordinates, a smooth
metric, integers \(d\geq1,D\geq0\), and \(c,C,B>0\). For any sequence
\[
 w\to\infty,\quad W=\prod_{p\leq w}p,\quad
 W\mid L,\quad L\text{ is }w\text{-smooth},\quad
 S\to\infty,\quad S/L\to\infty,\quad
 Z/S^a\to\infty\quad\text{for every fixed }a>0,
\]
choose any \(r\bmod L\) with \((r,W)=1\) and any family \(P_t(x)\)
whose logarithm is jointly polynomial in \((t,x)\), of total degree at most
\(D\). All coefficients may vary with the sequence index, without bounds.
For every fixed \(\eta>0\), the proportion of
\(t\in\mathcal T=[S,2S)\cap(r+L\mathbb Z)\) for which
\[
 \left|\mathbb E_{\mathcal Q\cap\mathbb Z^d}F(P_t(x)\Gamma)
 -\mathbb E_{\mathcal Q\cap(b+t\mathbb Z^d)}F(P_t(x)\Gamma)\right|
 \geq\eta                                                     \tag{1}
\]
for some axis-parallel \(\mathcal Q\subseteq[-CZ,CZ]^d\), every side
at least \(cZ\), some \(b\in\mathbb Z^d\), and some complex \(F\) with
\(\|F\|_\infty+\operatorname{Lip}(F)\leq B\), tends to zero.

The existential choices in (1) are inside the definition of the bad set:
they may be made separately for every \(t\), and need not be polynomial,
continuous, or selected from a finite list. This is the original
postcondition, not an assertion for a predetermined box or test.
For large sequence index all relevant samples are nonempty, since \(Z/t\)
tends to infinity. If there are no admissible boxes, the assertion is empty.
If \(D=0\) or \(\dim G=0\), both averages agree exactly.

### Theorem 2: finite-power strengthening

Suppose \(n=\dim G\geq1\), the nilpotence step is at most \(s\geq1\),
and \(D\geq1\). Put
\[
 Q_*=D s^{n-1},\qquad A_*=2D s^{n-1}+2.                       \tag{2}
\]
Theorem 1 remains true if its superpolynomial spatial scale condition is
replaced by
\[
                    Z\geq\kappa S^{A_*}                     \tag{3}
\]
eventually, for any fixed \(\kappa>0\). All its other hypotheses and all
its adaptive quantifiers are unchanged. No rate of decay for the
exceptional proportion is asserted.

This is a genuine strengthening of the stated scale hypothesis, rather than
a bounded-coefficient specialization. It is not claimed to be an optimal
exponent. The proof below establishes Theorem 2 and hence Theorem 1.

## External inputs and source findings

| Input | Exact proposition and use | Primary source read |
|---|---|---|
| Quantitative equidistribution | Non-equidistribution on an equal-side cube in a fixed rational filtered nilmanifold implies a bounded nonzero horizontal character and bounded binomial \(C^\infty\) norm, independently of polynomial coefficients. | Green--Tao, `arxiv:1311.6170v3`, Introduction, corrected `[GT, Theorem 8.6]`, its equal-sides sentence, and Section 3. |
| Finite density theorem | For fixed \(k,\delta>0\), every sufficiently large integer interval subset of density at least \(\delta\) contains a \(k\)-term arithmetic progression with positive difference. The finite coloring consequence follows by taking density \(1/\text{number of colors}\). | Gowers, *A new proof of Szemeredi's theorem*, `doi:10.1007/s00039-001-0332-9`, Theorem **1.2**, pp. 466--467; Theorem 1.1 is the coloring theorem. |
| Rational Lie coordinates and bases | Existence of an adapted Mal'cev basis for rational filtrations; bases of rational subnilmanifolds; the exponential/logarithmic description of connected simply connected nilpotent groups. | Green--Tao, `arxiv:0709.3562v4`, Definition 2.1 and its Remarks; Proposition **A.10**. |
| Finite BCH | BCH has rational coefficients and brackets of length at most \(s\); first-/second-kind coordinate changes in a rational nested basis are rational polynomials. | Same version, Lemma A.2(i) and its proof; Lemma A.3. |

The two Green--Tao HTML documents and the primary Gowers PDF are retained
beside this report. `gowers_theorems.txt` contains the complete statements of
Theorems 1.1 and 1.2. The DOI landing page was also obtained and identifies
the same Gowers article. These sources were actually opened, not inferred
from search snippets.

The expanded erratum explicitly rejects the unrepaired unequal-side
statement when a side is small. We do not use that statement. Comparable
boxes are reduced to equal cubes below. Reading the corrected citation
alone does not verify the subsequent interpolation or dimension descent;
that inadequate route is retired, with this reason, in the claim ledger.
The qualitative orbit theorem, quantitative factorization on arbitrary
progressions, and recurrence results used elsewhere in the manuscript are
not additional assumptions of this proof.

A targeted literature lookup found no exact match for Theorem 2's complete
adaptive, coefficient-uniform rough-step statement. That limited negative
search does not establish novelty. In particular, search-engine summaries
about what the broader literature cannot prove are not adopted as facts.

## 1. Polynomiality and the comparable-box obstruction

For a step bound \(s\) and logarithmic degree bound \(D\geq1\), use
\[
 G_0=G,\qquad G_i=G^{(\lceil i/D\rceil)}\quad(i\geq1),
\]
where \(G^{(1)}=G\) is the lower central series. Its degree is at most
\(sD\); its groups are rational; and
\(\lceil i/D\rceil+\lceil j/D\rceil\geq\lceil(i+j)/D\rceil\)
gives the bracket condition. An adapted basis is fixed once these data are
fixed.

Here is the noncommutative polynomiality check. After \(k\) group
differences, maintain the invariant that every degree-\(j\) coefficient of
the logarithm lies in \(\mathfrak g_{j+k}\). It holds initially, since
all initial degrees are at most \(D\). An ordinary difference gains one
filtration index: its degree-\(j\) coefficient comes from an old degree
at least \(j+1\). Expand
\[
 \log(Q(x+h)Q(x)^{-1})
     =\operatorname{BCH}(A(x)+\Delta_hA(x),-A(x)).
\]
Terms without a difference cancel identically. Every remaining bracket has
at least one difference; summing its filtration indices puts its degree-\(j\)
coefficient in \(\mathfrak g_{j+k+1}\). The finite BCH formula suffices,
including the case \(k=0\). Thus the quantitative input applies to every
bounded-degree logarithmic polynomial, with no coefficient restriction.

Horizontal characters are used with their real lifts: the integer covector
on the horizontal torus becomes a real linear functional on its logarithm,
integral on \(\Gamma\). This explains the real-valued character polynomial
and does not require choosing separate lifts at individual indices.

Suppose a box \(\mathcal B\subseteq[-CT,CT]^d\), sides at least \(cT\),
has Haar discrepancy at least \(\epsilon>0\) for a test of norm at most
\(B\). Tile its integer points by translated equal cubes of integer side
\(\lfloor\lambda T\rfloor\), discarding boundary strips. The discarded
fraction is \(O_{d,c}(\lambda+T^{-1})\). Choose fixed \(\lambda>0\)
so their contribution is less than \(\epsilon/4\). A retained cube has a
fixed positive Haar discrepancy, so the corrected equal-side theorem
applies, at an accuracy strictly smaller than that discrepancy divided by
\(B\). The basis rationality requirement is met by decreasing this fixed
accuracy if necessary.

The fixed smooth quotient metric and the fixed Mal'cev coordinate metric
are bi-Lipschitz equivalent: compare them in local Lie-coordinate charts
and use compactness to obtain uniform constants. Absorb that fixed norm
comparison into \(B\). The same comparison is made separately on each
member of the finite quotient list, never on a length-dependent family.

Let \(D_0\) be the fixed scalar degree bound. Multiply the resulting
character by \((D_0!)^d\). Expanding the multivariate binomial basis then
makes the integer parts of all ordinary coefficients integral; errors at
degree \(I\) are \(O(T^{-|I|})\). Translating back by the integer cube
origin \(a=O(T)\) preserves integrality and changes a degree-\(J\)
error into \(O(T^{|J|-|I|})O(T^{-|J|})\) at degree \(I\).
Consequently one of finitely many fixed nonzero characters satisfies
\[
 \|\theta_I\|_{\mathbb R/\mathbb Z}\leq C_0 T^{-|I|}
              \quad (|I|>0).                               \tag{4}
\]
All constants and the character list depend only on the fixed group,
degree, dimension, box constants, norm bound, and discrepancy. This
deduction never invokes an unrestricted unequal-side theorem.

## 2. Interpolation with all length dependence exposed

Fix \(q\geq e\geq1\), \(H\geq2q+2\), and \(N=H-1\).
Let \(t_z=t_0+mz\in[S,2S)\), where \(m\) is a positive smooth
integer and every \(t_z\) is coprime to \(W\). Suppose
\[
 T(z)=t_z^e\theta(z),\quad \deg T\leq q,\quad
 \|T(z)\|_{\mathbb R/\mathbb Z}\leq\varepsilon
       =A(S/Z)^e\quad (z=0,\ldots,N).                         \tag{5}
\]
Choose nodes \(z_j=\lfloor jN/q\rfloor\), \(0\leq j\leq q\).
Their normalized gaps are at least \(1/(2q)\). For the Lagrange
basis in \(u=z/N\), the numerator coefficient \(\ell^1\) norm
is at most \(2^q\), and the absolute denominator is at least
\((2q)^{-q}\). Thus each basis polynomial has coefficient norm at
most \((4q)^q\).

Interpolate nearest integers to \(T(z_j)\), obtaining \(R\in\mathbb Q[z]\).
Since \(T\) itself has degree at most \(q\), interpolation of its errors
gives the explicit, **length-independent** estimates
\[
 \| (R-T)(N\cdot)\|_{\mathrm{coeff},1}
       \leq C_q\varepsilon,\quad
 \sup_{0\leq z\leq N}|R(z)-T(z)|\leq C_q\varepsilon,\quad
 C_q=(q+1)(4q)^q.                                           \tag{6}
\]
Use the positive integer
\[
 D_H=\prod_{0\leq i<j\leq q}(z_j-z_i)
       \leq N^{q(q+1)/2}.                                  \tag{7}
\]
Every Lagrange denominator divides \(D_H\), so \(D_H R\in\mathbb Z[z]\).
Every prime dividing \(D_H\) is at most \(N\). This is an explicit
length-dependent denominator, not a uniform rationality bound.

Put \(a=-t_0/m\). The Hasse derivatives of \(T\) of orders \(j<e\)
vanish at \(a\). By (6), and
\(\binom{k}{j}\leq2^q\), their counterparts for \(R\) satisfy
\[
 |R^{[j]}(a)|
 \leq J_q\varepsilon N^{-j}(1+|a|/N)^q
 \leq J_q\varepsilon(1+2S)^q,\qquad J_q=2^q C_q.             \tag{8}
\]
Here \(m\leq S\), since the progression has at least two terms.
On the other hand
\[
                 D_H m^q R^{[j]}(a)\in\mathbb Z.             \tag{9}
\]
Indeed, differentiating a rational polynomial in the Hasse sense introduces
only integer binomial coefficients, and substitution of \(-t_0/m\) uses
at most \(q\) powers of \(m\) in the denominator.

It suffices for exact vanishing that
\[
 D_H S^q J_q A(S/Z)^e(1+2S)^q<1.                            \tag{10}
\]
Then (8)--(9) force every such jet to be zero. Therefore
\[
 R=(t_0+mz)^e M,\qquad M\in\mathbb Q[z],\quad \deg M\leq q-e. \tag{11}
\]
Long division introduces only powers of the leading coefficient \(m^e\).
A common coefficient denominator for \(M\) divides
\[
                         D_H m^{e(q-e+1)}.                  \tag{12}
\]
Thus it is smooth as soon as \(w\geq H-1\), since \(m\) was smooth.

For every retained integer \(z\), (5)--(6) put \(R(z)\) within
\((C_q+1)\varepsilon\) of an integer. It is itself in \(D_H^{-1}\mathbb Z\).
If
\[
                  D_H(C_q+1)\varepsilon<1,                  \tag{13}
\]
then \(R(z)\) is exactly integral. Write \(M(z)=a_z/b_z\) in
lowest terms. Its denominator is smooth by (12), whereas \(t_z\) is
coprime to every prime at most \(w\). The integrality of \(t_z^eM(z)\)
implies \(b_z\mid t_z^e\), and hence \(b_z=1\). Finally (6) divided
by \(t_z^e\geq S^e\) yields
\[
                  |\theta(z)-M(z)|\leq C_q A Z^{-e}.         \tag{14}
\]
The constant in (14) does not depend on \(H\).

Under the original superpolynomial hypothesis, (10) and (13) hold for
each fixed \(H\). More precisely, if \(q\leq Q_*\) and (3) holds,
the left side of (10) is bounded by a fixed multiple, depending on \(H\),
of
\[
 S^{2q+e-A_*e}\leq S^{-1}.                                 \tag{15}
\]
The left side of (13) also tends to zero. This proves precisely the
interpolation assertion needed for both the original and the stronger
scale regime. It does not interchange a limit in \(H\) with the
asymptotic limit.

## 3. From density to arbitrarily long bad progressions

Call a fixed collection of group, degree, box, test, discrepancy, and
positive \(\kappa\) bounds a bad progression family if for every prescribed
finite length \(H\), along some sequence \(w,S\to\infty\), (3) holds and
there is a progression
\[
 t_z=t_0+mz\in[S,2S),\quad 0\leq z<H,
\]
with smooth positive \(m\), all \(t_z\) rough, and discrepancy at least
\(\eta\) at every index. Only \(P_z(x)\) must be jointly
logarithmically polynomial in \((z,x)\), with the fixed degree bound.
The boxes, residue vectors, and tests are arbitrary at each index.
The sequence and thresholds may depend on the prescribed length.

Failure of the claimed density conclusion produces such a family.
If a bad set has density at least \(\alpha>0\) on a subsequence,
the index interval in \(t=r+Lu\) has length tending to infinity.
For fixed \(H\), let \(K=K(H,\alpha/2)\) be furnished by finite
Szemeredi. Partition the index interval into blocks of length \(K\).
After discarding the last incomplete block, some full block has bad
density at least \(\alpha/2\), for large sequence index. Its bad
progression has step \(jL\), \(1\leq j\leq K\). This is smooth
once \(w\geq K\), and affine substitution for \(t\) preserves the
joint total degree.

The same density theorem at density \(1/h\) gives the finite
van der Waerden property for \(h\) colors. Thus any finite coloring
whose number of colors is independent of \(H\) can be made constant on
an arbitrarily long subprogression. Its additional step multiplier is
bounded by the prescribed starting length, so is eventually smooth.
Restriction never changes \(S,Z\) or the fixed constants. No bound
uniform in \(H\) is required for these integer step multipliers.

## 4. A common character and integer spatial coefficients

Assume a bad progression family exists. At each index, at least one of
the unrestricted and step-\(t_z\) averages differs from Haar by
\(\eta/2\). Denote its step by \(p_z\in\{1,t_z\}\), and reduce
its residue to \(b_z\in\{0,\ldots,p_z-1\}^d\).
Substitute \(x=p_zv+b_z\). Its box has scale \(Z/p_z\), side
lower bound \(cZ/p_z\), and bounded normalized location: the shift
of size at most \(p_z\) adds only \(1\) to a location constant.
Also \(Z/p_z\to\infty\). Apply (4).

Thin by the fixed finite character list to obtain one nonzero character
\(\xi\), including the bounded factorial multiplication. Write
\[
 \xi(P_z(x))=\sum_I\theta_I(z)x^I,\qquad
 \deg\theta_I\leq D-|I|.
\]
The obstruction is
\[
 \left\|p_z^{|I|}\sum_{J\geq I}\binom JI
          b_z^{J-I}\theta_J(z)\right\|_{\mathbb R/\mathbb Z}
       \leq C_0(p_z/Z)^{|I|},\quad |I|>0.                    \tag{16}
\]
The residue and choice of sampling law have not been assumed polynomial
in \(z\).

Descend through the positive spatial degrees. Suppose the higher
coefficients are \(m_J(z)+\delta_J(z)\), with integer \(m_J(z)\)
at retained indices and \(|\delta_J(z)|\leq A_J Z^{-|J|}\).
Their integer contributions to (16) vanish modulo one. Since
\(|b_z^{J-I}|\leq p_z^{|J|-|I|}\), their errors are bounded by
a fixed sum of
\[
                 A_J(p_z/Z)^{|J|}
                 \leq A_J(p_z/Z)^{|I|}.
\]
Here \(p_z/Z\leq1\) eventually. Hence
\(\|p_z^e\theta_I(z)\|\leq A_e(p_z/Z)^e\), \(e=|I|\).
If \(p_z=1\), multiply this estimate by the integer \(t_z^e\);
if \(p_z=t_z\), leave it unchanged. In either case
\[
          \|t_z^e\theta_I(z)\|\leq 2^e A_e(S/Z)^e.            \tag{17}
\]

Apply Section 2 with **\(q=D\)**, because
\(\deg(t_z^e\theta_I)\leq e+(D-e)=D\). It gives
\[
 \deg m_I\leq D-|I|,\quad m_I(z)\in\mathbb Z,\quad
 |\theta_I(z)-m_I(z)|\leq A_1 Z^{-|I|},                     \tag{18}
\]
with smooth coefficient denominators. Only finitely many degrees and
coefficients occur, so \(A_1\) is independent of \(H\). All
length-dependent exactness thresholds can be imposed simultaneously.

For the constant coefficient, let \(q_0=\deg\theta_0\leq D\).
Color the fractional parts \(\{\theta_0(z)\}\) by intervals of width
\(2^{-D-3}\), and pass to a long monochromatic progression. On each
consecutive \(q_0+2\) indices, the \((q_0+1)\)-st difference of
\(\lfloor\theta_0(z)\rfloor\) is an integer of absolute value at
most \(2^{q_0+1}2^{-D-3}<1\), and is therefore zero. Newton
interpolation supplies a rational \(m_0\) of degree at most \(q_0\)
equal to these floors on the entire retained progression. Its ordinary
coefficient denominator divides \(q_0!\). Affine reparametrization
preserves (18), its degree bounds, and its integer evaluations.

Set
\[
 m_z(x)=\sum_I m_I(z)x^I,\qquad
 a_z(x)=\xi(P_z(x))-m_z(x).
\]
Both polynomials have joint total degree at most \(D\). At every
retained integer index \(m_z\) has **integer coefficients in \(x\)**,
even though its coefficients as polynomials in \(z\) can have very
large denominators. On the full box,
\[
 |a_z(x)|\leq C_1,\qquad |\partial_{x_j}a_z(x)|\leq C_1/Z,    \tag{19}
\]
with \(C_1\) independent of \(H\): use (18) monomial by monomial,
and \(0\leq\theta_0-m_0<1\). This distinction between index
denominators and integer spatial fibers is essential.

## 5. Exact kernel descent and the finite quotient family

Choose a rational \(V\in\mathfrak g\) with \(\xi(\exp V)=1\).
The differential of a horizontal character has rational coefficients
in a rational basis, so a coordinate vector divided by a nonzero
coefficient suffices. The Mal'cev coordinates of \(\exp(uV)\)
are rational polynomials in \(u\) with zero constant terms.
Choose a fixed positive integer \(K\) divisible by their coefficient
denominators. Then \(\exp(KV)\in\Gamma\).

Put \(H_\xi=\ker\xi\) and
\[
 Q_z(x)=\exp(-a_z(x)V)\,P_z(x)\,\exp(-m_z(x)V).               \tag{20}
\]
The character of (20) is zero **for every real \((z,x)\)**, since
the horizontal splitting is a polynomial identity, not merely an
identity at sampled indices. In the indicated order,
\[
             P_z(x)=\exp(a_z(x)V)Q_z(x)\exp(m_z(x)V).         \tag{21}
\]
There is no commutative rearrangement in (20)--(21).

The exponential diffeomorphism identifies \(H_\xi\) with the linear
kernel of \(d\xi\). It is connected, simply connected, normal, rational,
and of dimension \(n-1\). The multivariate BCH expression in (20)
has brackets with at most \(s\) leaves. Every leaf is a polynomial
of degree at most \(D\), so
\[
                      \deg\log Q\leq sD.                   \tag{22}
\]
Passing to logarithmic coordinates in a rational basis of
\(\mathfrak h_\xi\) is a linear operation and does not increase this
degree. Its coefficients need not be bounded.

For completeness, compactness of the kernel quotient does not require
an assumption on \(H\)-dependent denominators. The image
\(\xi(\Gamma)\) is a nonzero subgroup of \(\mathbb Z\).
It cannot be zero, since otherwise \(\xi\) would give a surjection
from the compact \(G/\Gamma\) to \(\mathbb R\). Thus
\(\xi(\Gamma)=k\mathbb Z\), \(k>0\). The zero fiber of the
induced map \(G/\Gamma\to\mathbb R/k\mathbb Z\) identifies with
\(H_\xi/(H_\xi\cap\Gamma)\) and is compact. This proves that
\(\Lambda_0=H_\xi\cap\Gamma\) is a lattice.

Let \(\sigma_j=\exp(jV)\), \(0\leq j<K\). The only smaller
quotients needed are
\[
 H_\xi/\Lambda_j,\qquad
 \Lambda_j=H_\xi\cap\sigma_j\Gamma\sigma_j^{-1}
           =\sigma_j\Lambda_0\sigma_j^{-1}.                 \tag{23}
\]
The equality follows from normality of \(H_\xi\), so each is
indeed a lattice. Also \(\operatorname{Ad}(\sigma_j)\) is a
finite rational polynomial in \(\operatorname{ad}(jV)\);
the induced rational structure and adapted subgroup bases are
available for each quotient. Fix a smooth metric on each.

There are finitely many characters, finitely many associated \(V,K\),
and \(K\) choices of \(j\) for each character. **No interpolation
denominator appears in (23).** Rational index coefficients of \(m_I\)
enter (20) only as unrestricted coefficients of its logarithm.

## 6. Freezing, weights, and residue reparametrization

Divide every side of a test box into the same sufficiently large fixed
number \(J\) of half-open intervals (closing only the final boundary
when necessary). Each resulting subbox has side between \(cZ/J\)
and \(2CZ/J\). By (19), the change of \(a_z\) within a subbox
is \(O(C_1/J)\).

The map \((u,y)\mapsto\exp(uV)y\) has bounded derivative on
\([-C_1,C_1]\times G/\Gamma\). Hence replacing the left factor
in (21), within that subbox, by
\(\ell_{z,*}=\exp(a_z(x_*)V)\) changes the test by a uniform
amount at most \(\delta\). Choose \(J\), independent of \(H\),
so \(2\delta\leq\eta/8\).

Split further into the \(K^d\) spatial residue vectors \(u\bmod K\).
At a retained integer index the spatial coefficients of \(m_z\) are
integers, so \(m_z(x)\equiv m_z(u)=j\bmod K\) throughout the
piece. Since \(\exp(KV)\in\Gamma\), its remaining test is
\[
 h\Lambda_j\longmapsto F_z(\ell_{z,*}h\sigma_j\Gamma).        \tag{24}
\]
It is well-defined by the definition of \(\Lambda_j\), without
requiring \(\Gamma\) to be normal. Its supremum norm is at most
\(B\). Its Lipschitz norm is bounded independently of \(H,z\)
and the chosen piece: the quotient map in (24) is smooth, its domain
is compact, \(\ell_{z,*}\) ranges in a fixed compact set, and the
list (23) is finite.

Here is the counting comparison with all moduli specified. For any
interval \(I\) of length \(\ell\) and any residue modulo \(q\),
\[
          \#(I\cap(b+q\mathbb Z))=\ell/q+E,\quad |E|\leq2.   \tag{25}
\]
For \(w\geq K\), roughness gives \((t_z,K)=1\).
The unrestricted count in a piece uses grid modulus \(K\); the
step-\(t_z\) count in that same piece uses modulus \(Kt_z\),
by the Chinese remainder theorem. Applying (25) in each coordinate
shows that the two normalized weights of every piece both equal
\[
     \frac{\operatorname{vol}(\text{subbox})}
          {K^d\operatorname{vol}(\mathcal Q)}
          +O_{d,c,C,J,K}(t_z/Z).                            \tag{26}
\]
There are only \(J^dK^d\) pieces. Their total weight difference
is therefore \(O(t_z/Z)=o(1)\), uniformly in endpoints and
all chosen residues. All their conditional samples are nonempty
eventually. Boundary conventions change only the errors in (25).

After freezing, the discrepancy is at least \(7\eta/8\).
Replace one set of combination weights by the other; its error is
at most \(B\) times the total weight difference. For large sequence
index this is at most \(\eta/8\). The two averages are now
convex combinations with identical weights. The triangle inequality
therefore gives at least one piece with conditional discrepancy at
least \(3\eta/4\), in particular at least \(\eta/2\). This
argument does **not** divide the discrepancy by the number of pieces.

Choose a piece separately for each \(z\), and thin by its finitely
many choices of \(u,j\), leaving all other data adaptive. Substitute
\(x=u+Ky\). The unrestricted conditional sample becomes all
integer \(y\) in a box of scale \(Z'=Z/K\), with fixed
comparable-side and location bounds. The other sample is exactly
one class modulo **the original \(t_z\)**, since
\[
                 u+Ky\equiv b_z\pmod{t_z}
\]
has a unique class of solutions when \((K,t_z)=1\).
This is not a replacement of \(t_z\) by \(Kt_z\).
The new map \(Q_z(u+Ky)\) is jointly logarithmically polynomial
of degree at most \(sD\).

## 7. Closing the induction, including every uniformity

We prove that no bad progression family exists, by induction on
dimension, keeping the step cap \(s\) fixed. Dimension zero is a
point and has zero discrepancy. In dimension \(n\), Sections 4--6
produce a bad family on one of the quotients (23), of dimension
\(n-1\), with degree bound \(D'=sD\), discrepancy at least
\(\eta/2\), and fixed new box and norm bounds.

For \(n\geq2\) the exponent required by the induction hypothesis is
\[
 2D's^{(n-1)-1}+2=2(sD)s^{n-2}+2=A_*.
\]
Thus \(Z'=Z/K\geq(\kappa/K)S^{A_*}\) has the required
scale. For \(n=1\) the quotient is already a point. At every
interpolation stage \(q\leq D s^{n-1}=Q_*\), so (15) applies.

The quotient and constants can be fixed for unbounded lengths:
for each prescribed length first pass to a sequence subsequence fixing
its finite group choice, then take a choice occurring for unbounded
lengths. Bounds on degrees, box sides/locations, tests, discrepancy,
and the number of colors are independent of length; take maxima or
minima over the finite group choices where appropriate. A family for
unbounded prescribed lengths restricts to every fixed smaller length.
This contradicts the induction hypothesis.

Only the selected progression lengths, their interpolation denominators,
bounded affine step multipliers, and eventual thresholds depend on \(H\).
All of them are fixed **before** the associated asymptotic limit.
Neither the new Lie group/lattice choices nor analytic constants depend
on \(H\). This is the full strengthened progression exclusion.
Section 3 converts failure of the exceptional-density conclusion into
exactly such a family, completing Theorems 2 and 1.

Finally, if uniformity over coefficient vectors, residues \(r\), or
adaptive choices in (1) failed, selecting violating data at each
sequence index would produce an allowed data sequence with a fixed
positive exceptional proportion. The proved sequential assertion
rules that out. This also handles a fixed finite list of nilmanifolds
by passing to one member on a subsequence.

## What is and is not certified

Compared with the previously scoped corrected equidistribution input,
this proof supplies the missing bridge: explicit length-independent
interpolation estimates, exact smooth-denominator division, degree
control in a noncommutative kernel, a length-independent finite quotient
family, and an adaptive convex-weight comparison. It additionally
replaces the spatial superpolynomial condition by the explicit power (2).
The original proposition is not refuted, and no purported counterexample
to Hindman's conjecture is claimed.

The existing proof graph separates manuscript assertions from this
subtheorem, external inputs, analytic obligations, and exact algebra.
An Engineer proof or a successful compiler run is not an independent
Reviewer verdict; graph nodes remain unconfirmed until that review.
The cited assumptions are explicitly recorded on `RS_VERIFY`; independent
citation attribution remains the Reviewer's responsibility. This
Engineer does not confirm its own citations under a different name.

Accordingly, the ledger currently derives `closed_kernel` only for
`RS_EXACT_ALGEBRA`; `RS_VERIFY` and `RS_POWER` have Engineer-supported
proofs with their four external inputs still undischarged. The citation
work list contains eight unchecked claim/assumption pairs, four on each
analytic claim. This is a review requirement, not a passed citation gate.

The real Lean 4.31.0 run completed with exit code zero, no proof holes,
and no recording refusals; its immutable claim certificate is
`certificates/RS_EXACT_ALGEBRA-3ea594aff987b5d5.json`. The exact replay
includes 43 interpolation instances (all exponents through degree six),
24 separated-node/denominator checks, and 33,286 CRT membership checks,
as well as symbolic Heisenberg identities and necessary-hypothesis
negative controls. These finite checks support, but do not replace, the
universal estimates and induction above.

Run the exact witness replay from the campaign root:

```
/home/argustest/zimo/argus-live-update/.venv/bin/python research/rough_step/verify.py
```

The separate real Lean compiler command is:

```
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify --project-root . --claim RS_EXACT_ALGEBRA research/rough_step/Main.lean --statement-fidelity research/rough_step/statement_fidelity.md
```

The installed interface takes the source positionally, not with a
`--source` option. Its compiler certificate, source binding, and
statement-fidelity binding are recorded by that official command, not
manufactured by `verify.py`.
