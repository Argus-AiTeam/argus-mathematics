# Uniform singular replica symbols, with a sharp half-power boundary

## Statement and scope

Let \(V=P\otimes Y\otimes F\) be a fixed finite-dimensional complex Hilbert
space, \(d=\dim V\), and \(S_k=\operatorname{Sym}^k V\). Empty factors are
allowed. Use exactly the common, padded-to-\(d\) weights
\[
 c=d+(1+t){d\choose2},\qquad
 w_k(\lambda)=\frac{\Gamma(c)}{\Gamma(c+tk)}
       \prod_{i=1}^d
       \frac{\Gamma(1+t(\lambda_i+d-i))}
            {\Gamma(1+t(d-i))}
\]
and the Schur operators \(W_{Q,k}\) of the staged area-law manuscript,
equation `replicas:w-definition`. Put
\[
 A_k=(W_{P,k}^{-1}W_{F,k}^{-1}W_{Y,k})^2,\quad
 O_k=A_k^{-1/2}\bar h A_k^{1/2}\big|_{S_k},\quad
 \bar h=k^{-1}\sum_{j=1}^kh^{(j)}.
\]
Here \(h\) is any fixed operator supported on \(PY\). For a unit
\(\theta\in V\), let \(\rho_Q\) be its marginal and set
\[
 f(\theta)=\langle\theta,
     \rho_P^t\rho_Y^{-t}h\rho_P^{-t}\rho_Y^t\theta\rangle .
\]
Every negative power is the support inverse, zero on the kernel. Positive
powers are also zero on kernels. For every density \(\sigma\) supported on
\(S_k\), use the manuscript's *same* Husimi measure
\[
 d\mu_\sigma(\theta)=D_k
       \langle\theta^{\otimes k},\sigma\theta^{\otimes k}\rangle d\theta,
 \qquad D_k={k+d-1\choose d-1}.
\]

**Theorem 1 (quantitative uniform calculus).** For every fixed
\(0<t<1/2\), the operators \(O_k\) are uniformly bounded, and \(f\) is
bounded and continuous, including at deficient-rank marginals. If \(q\)
is a fixed noncommutative polynomial, then
\[
 \sup_\sigma\left|
    \operatorname{Tr}\sigma q(O_k,O_k^*)
      -\int q(f,\bar f)\,d\mu_\sigma\right|
 \le C_{d,t,h,q}\,[\log(k+2)]^{-\beta(t)},\qquad
 \beta(t)=\min\{t/2,(1-2t)/6\}>0.                 \tag{1}
\]
Changing the constant covers the finitely many small \(k\). Moreover,
uniformly over the same densities,
\[
 \operatorname{Tr}\sigma
       (|O_k|+|O_k^*|-O_k-O_k^*)
 =2\int(|f|-\operatorname{Re}f)\,d\mu_\sigma+o(1). \tag{2}
\]
In particular, \(\|[O_k,O_k^*]\|\to0\), with the rate in (1).

**Theorem 2 (sharpness).** For these same weights, already on three fixed
qubits, the scalar polynomial conclusion is false at \(t=1/2\), and the
uniform operator bound is false for every \(t>1/2\). The counterexample
is an explicit family of symmetric pure densities, not a finite-copy
discrepancy. At \(t=1/2\) the operators are still uniformly bounded for
every fixed system and \(h\): it is scalar commutativity, not boundedness,
that first fails.

Theorem 1 verifies both `replicas:polynomial-symbol` and
`replicas:skew-symbol` throughout their literal range \(0<t<1/4\).
Theorem 2 is **not** a refutation of either manuscript assertion. No false
assertion in that range is identified here. Neither theorem certifies
the one-copy skew inequality, conditional movement, area law, or PEPS
theorem. In particular, increasing the exponent range here does not
increase the range of those other results.

## 1. Quantitative marked ratios

Here and below constants depend only on fixed one-copy data, never on a
replica density or a marginal's smallest positive eigenvalue.

Write \(l_i=\lambda_i+d-i\). On a legal removable-row branch, the marked
ratio \(R_{Q,k}=W_{Q,k}W_{Q,k-1}^{-1}\) and star \(J_{Q,k}\) have values
\[
 r_{k,l}=\frac{g_t(1+t(l-1))}{g_t(c+t(k-1))},\qquad
 j_{k,l}=(l-d)/k,\qquad
 g_t(x)=\Gamma(x+t)/\Gamma(x).                    \tag{3}
\]
For a permutation-invariant marginal on \(Q^{\otimes k}\), conditional
on its full label, the branch probability satisfies
\[
 p_{\lambda,i}=\frac{d_{\lambda-e_i}}{d_\lambda}
       \le 2^{d_Q}\frac{\lambda_i+d_Q-i}{k}
       \le 2^d l_i/k.                            \tag{4}
\]
The use of the *full* dimension in (3) and the possibly smaller
subsystem dimension in (4) is intentional.

For completeness, the representation-theoretic inputs in (3)-(4) are
the standard Schur branching identities, also derived in the staged
manuscript before the symbol lemma. Their calculation is as follows.
Schur--Weyl gives blocks \([\lambda]\otimes V_\lambda^{(q)}\); an invariant
density is the identity on the first factor times an arbitrary positive
matrix on the second. Restriction to \(S_{k-1}\) is the multiplicity-one
sum over legal \(\lambda-e_i\). Hence branch ranks are
\(d_{\lambda-e_i}\), independently of the matrix on the second factor.
Using
\[
 d_\lambda=k!\frac{\prod_{a<b}(m_a-m_b)}{\prod_a m_a!},
 \qquad m_i=\lambda_i+q-i,
\]
the dimension quotient is
\[
 \frac{m_i}{k}
 \prod_{a<i}\left(1+\frac1{m_a-m_i}\right)
 \prod_{b>i}\left(1-\frac1{m_i-m_b}\right).
\]
Earlier-row factors are at most two and later-row factors at most one;
all are nonnegative on a legal branch. This proves (4). The star's
content is \(\lambda_i-i\), giving (3). One can obtain that content
without a convention about tableaux: subtract the quadratic-Casimir
values
\(\sum_i\lambda_i(\lambda_i+q+1-2i)\) and the corresponding value at
\(\lambda-e_i\), and use
\(\sum_{ab}E_{ab}^{\rm tot}E_{ba}^{\rm tot}
 =kqI+2\sum_{j<j'}U((j\,j'))\).
The difference is \(2(\lambda_i-i)\). Finally, substituting the gamma
weights gives the first identity in (3) exactly. Thus no asymptotic
independence or full-rank hypothesis is part of the Schur input.

The displayed Specht-dimension formula also follows from the same
character input, rather than being an additional unlisted assumption.
Multiply
\((x_1+\cdots+x_q)^k=\sum_\lambda d_\lambda s_\lambda(x)\)
by \(\det[x_i^{q-j}]\), using the alternant definition of \(s_\lambda\),
and extract the coefficient of \(\prod_i x_i^{m_i}\). Strict decrease
of \(m_i\) selects just the identity alternant of \(\lambda\).
The coefficient on the other side is
\(k!\det[1/(m_i-q+j)!]\). Factoring \(1/m_i!\) from row \(i\)
leaves the monic falling-factorial Vandermonde, giving exactly the
dimension formula above. Negative reciprocal factorials mean zero.

The only gamma estimate needed is
\[
 \frac{x}{(x+t)^{1-t}}\le g_t(x)\le x^t
                  \quad(x>0,\ 0<t<1).           \tag{5}
\]
This follows directly from log convexity of the gamma integral:
the upper bound interpolates between \(x\) and \(x+1\); applying that
upper bound with base \(x+t\) and increment \(1-t\) gives the lower
bound. It is not an unverified asymptotic gamma formula.

Since \(l\ge1\) on a removable branch, (5) implies
\[
 L(l/k)^t\le r_{k,l}\le U(l/k)^t,\qquad
 L=\tfrac12[t/(c+t)]^t,\quad U=2t^{-t}.           \tag{6}
\]
Also \(0\le x^t-g_t(x)\le t(1-t)x^{t-1}\) for \(x\ge1\).
The numerator of (3) differs from \((tl)^t\) by a bounded constant;
its denominator differs from \((tk)^t\) by \(O(k^{t-1})\).
As \(l\le k+d-1\), this proves
\[
 \|R_{Q,k}-(J_{Q,k})_+^t\|\le Ck^{-t}.           \tag{7}
\]
The shift from \(l/k\) to \((l-d)_+/k\) costs at most \((d/k)^t\).
This bound is on the entire tensor space.

If \(z\in S_k\) is unit, its \(Q\) marginal is permutation invariant.
By (4) and (6), conditional on any label,
\[
 \sum_i p_{\lambda,i}r_{k,l_i}^{-2}
       \le C\sum_i(l_i/k)^{1-2t}\le C.           \tag{8}
\]
Thus \(\|R_{Q,k}^{-1}z\|\le C\). This is only an input-vector
bound; a bounded full-space inverse is not being asserted.
Equations (5)-(8) and the quadratic-form argument (13) also apply at
\(t=1/2\), since every removable \(l_i\) is positive and the sum in (8)
then has at most \(d_Q\) terms equal to one. This proves the endpoint
boundedness assertion of Theorem 2. The vanishing tail in (9), in
contrast, requires the strict inequality.

Let \(G_\delta(u)=\max(u,\delta)^{-t}\), \(0<\delta\le1\).
On \(J\ge\delta\), (6)-(7) give an operator error at most
\(Ck^{-t}\delta^{-2t}\). On \(J<\delta\), (4) gives mass at most
\(C(\delta+d/k)\), and (8) on this part is at most
\(C(\delta+d/k)^{1-2t}\). Consequently, whenever \(k\delta\ge2d\),
\[
 \|(R_{Q,k}^{-1}-G_\delta(J_{Q,k}))z\|
 \le C\{k^{-t}\delta^{-2t}+\delta^{1/2-t}\}.     \tag{9}
\]
In the same range \(\|G_\delta(J_{Q,k})z\|\le C\) independently of
\(\delta\): on \(j\ge\delta\), \(l/k=j+d/k\le2j\), and the other
part costs \(C\delta^{1-2t}\). These observations justify all uses of
inverse powers below, including sequences concentrating on small
branches.

## 2. Bounded approximation *after* compression

Put \(F(u)=u_+^t\). Let \(F_n,G_{\delta,n}\) be the degree-\(n\)
Bernstein polynomials of \(F,G_\delta\) on \([-1,1]\). The binomial
variance and Jensen's inequality give
\[
 \|F-F_n\|_\infty\le n^{-t/2},\qquad
 \|G_\delta-G_{\delta,n}\|_\infty
       \le t\delta^{-1-t}n^{-1/2}.              \tag{10}
\]
If \(\|\cdot\|_{\ell^1}\) denotes the sum of absolute monomial
coefficients, their explicit Bernstein formula also gives
\[
 \|F_n\|_{\ell^1}\le2^n,\qquad
 \|G_{\delta,n}\|_{\ell^1}\le2^n\delta^{-t}.     \tag{11}
\]
Indeed each product
\(((1+u)/2)^j((1-u)/2)^{n-j}\) has coefficient sum at most one.

Compression of the marked word is exactly \(O_k\):
\[
 \Pi_k R_P R_Y^{-1}h^{(k)}R_P^{-1}R_Y\Pi_k\big|_{S_k}. \tag{12}
\]
The \(F\) factors cancel because \(h\) is supported on \(PY\), and
the first-\((k-1)\) weights commute with the last-copy operator.
To justify approximation of (12), decompose
\(h=\sum_\nu c_\nu\otimes e_\nu\), with
\(H=\sum_\nu\|c_\nu\|\|e_\nu\|<\infty\). For one summand its
quadratic form at a symmetric vector is
\[
 \left\langle R_Y e_\nu^* R_Y^{-1}z,\,
                    R_P c_\nu R_P^{-1}z\right\rangle . \tag{13}
\]
Both inverses act **directly on the original symmetric input**.
Equations (6) and (8), followed by the numerical-radius inequality
\(\|T\|\le2\sup_{\|z\|=1}|\langle z,Tz\rangle|\), already prove
\(\sup_k\|O_k\|<\infty\).

Define the compressed approximant
\[
 B_k=\Pi_k F_n(J_P)G_{\delta,n}(J_Y)h^{(k)}
                 G_{\delta,n}(J_P)F_n(J_Y)\Pi_k\big|_{S_k}. \tag{14}
\]
Apply (7), (9), and (10) separately to the two vectors in (13),
then polarize the resulting quadratic-form error. Since the clipped
inverse has bounded norm on symmetric inputs, the forward error in
(10) is **not** multiplied by a full-space \(\delta^{-t}\) factor.
When the right-hand side is at most one,
\[
 \|O_k-B_k\|\le C\{
     k^{-t}\delta^{-2t}+\delta^{1/2-t}
       +n^{-t/2}+\delta^{-1-t}n^{-1/2}\}.        \tag{15}
\]
All vectors used in this estimate have uniformly bounded norm.
There is no assertion that (12) and (14) are close before compression.

For the scalar symbol of (14), replace every star by the corresponding
\(\rho_Q\); call the result \(b_{\delta,n}(\theta)\). The same
two-vector calculation works on one copy. In particular,
\[
 \|\rho_Q^{-t}\theta\|^2
       =\sum_{p_i>0}p_i^{1-2t}\le d_Q,\qquad
 \sum_{0<p_i<\delta}p_i^{1-2t}
       \le d_Q\delta^{1-2t}.                   \tag{16}
\]
Consequently
\[
 \sup_\theta|b_{\delta,n}(\theta)-f(\theta)|
 \le C\{\delta^{1/2-t}+n^{-t/2}
                  +\delta^{-1-t}n^{-1/2}\}.   \tag{17}
\]
This also proves boundedness of \(f\) and its continuity, since the
clipped functions are continuous and converge uniformly as
\(\delta\downarrow0\).

## 3. Multiplication after symmetric compression

Write \(T_{k,m}(G)\) for the average over ordered injections of an
\(m\)-copy operator \(G\). A full permutation average of any ambient
operator preserves \(S_k\) and restricts there to its compression.
Thus products of compressed words can be replaced *exactly* by
restrictions of products of their full permutation averages.

Expand a monomial containing \(r\) stars with a marked center.
Its distinct-donor contribution, after full averaging, is
\[
 a_{k,r}T_{k,r+1}(G),\qquad
 a_{k,r}=(k-1)_r/k^r=\prod_{j=1}^r(1-j/k),
\]
where \(G\) is the fixed ordered partial-swap word with distinct donors
and \(\|G\|\le\|h\|\). Repeated-donor coefficient mass is at most
\(1-a_{k,r}\). Therefore, for \(r<k\),
\[
 \|\mathcal T_k(\text{word})-T_{k,r+1}(G)\|
       \le 2(1-a_{k,r})\|h\|
       \le r(r+1)\|h\|/k.                     \tag{18}
\]
The elementary inequality used here is
\(1-\prod_j(1-x_j)\le\sum_jx_j\) for \(x_j\in[0,1]\).
It is universally formalized in `Main.lean`.

For independently chosen ordered injections of sizes \(m_1,\ldots,m_s\),
the overlap probability is at most
\(\sum_{i<j}m_im_j/k\). Conditional on no overlap their union is a
uniform ordered injection. Thus
\[
 \left\|\prod_iT_{k,m_i}(G_i)
               -T_{k,M}(\bigotimes_iG_i)\right\|
 \le \frac{2\sum_{i<j}m_im_j}{k}\prod_i\|G_i\|,
 \qquad M=\sum_i m_i.                         \tag{19}
\]
Each word has its own center here. Reusing the same marked center for
all factors would not prove this statement.

On \(\theta^{\otimes(r+1)}\), trace each distinct donor once. The
matrix-unit identity
\[
 \operatorname{Tr}_{\rm donor}
   [(\,|\theta\rangle\langle\theta|\otimes I\,)S_Q]
       =(\rho_Q)_{\rm center}
\]
shows, in the original order, that a star becomes \(\rho_Q\), not its
transpose. This remains true when the donor is entangled across its
one-copy factors. Distinct centers then multiply *scalar*
expectations. Adjoints give complex conjugates. This proves the
algebraic symbol rules without applying any inverse to a nonsymmetric
intermediate vector.

## 4. A uniform finite-Husimi bound with growing copy blocks

For \(M\le k\), the sphere moment identity gives exactly
\[
 \int\langle\theta^{\otimes M},G\theta^{\otimes M}\rangle d\mu_\sigma
   =\frac{D_k}{D_{k+M}}\operatorname{Tr}[(\sigma\otimes G)\Pi_{k+M}].
                                                               \tag{20}
\]
One direct derivation of the sphere identity is to expand in occupation
monomials: phases kill unequal occupations, while the simplex integral
of \(\prod |z_i|^{2n_i}\) is
\((d-1)!\prod n_i!/(k+d-1)!\). Its permutation sum is \(\Pi_k/D_k\).
Thus (20) needs no additional de Finetti theorem.

In the permutation expansion of \(\Pi_{k+M}\), the fraction mapping
every new index into an old one is
\[
 b_{k,M}=(k)_M/(k+M)_M.
\]
Every such permutation is a double translate, by old-index
permutations, of the \(M\) matched swaps. Old permutations are
absorbed by \(\sigma\), which is supported on \(S_k\). These terms
each give \(\operatorname{Tr}\sigma^{(M)}G\); the others have
absolute value at most \(d^M\|G\|\). Also
\[
 1-D_k/D_{k+M}\le (d-1)M/(k+1),\qquad
 1-b_{k,M}\le M^2/(k+1).
\]
It follows that
\[
 \left|\operatorname{Tr}\sigma T_{k,M}(G)
        -\int\langle\theta^{\otimes M},G\theta^{\otimes M}\rangle
                                                        d\mu_\sigma\right|
 \le\frac{(d-1)M+(1+d^M)M^2}{k+1}\|G\|.        \tag{21}
\]
All estimates are uniform in \(\sigma\), including \(\sigma=\sigma_k\).
The \(d^M\) factor is retained, not incorrectly called constant when
the polynomial degree grows.

## 5. A justified joint cutoff/degree schedule

Let \(L\ge1\) be the degree of \(q\), and take, for sufficiently large
\(k\),
\[
 n=\left\lfloor\frac{\log k}{8L\log(2d)}\right\rfloor,\qquad
 \delta=n^{-1/3}.
\]
In a product of at most \(L\) monomials from (14), the total number of
occupied copies is at most \(L(4n+1)\). Equations (11), (18), (19),
and (21), summed with absolute coefficients, bound the entire
polynomial-calculus error for \(B_k,b_{\delta,n}\) by
\[
 \frac{C_{q,h,d} n^2}{k}
      \delta^{-2tL}2^{4Ln}d^{L(4n+1)}
 \le C_{q,h,d}k^{-1/2}n^{2+2tL/3}.            \tag{22}
\]
The schedule makes \((2d)^{4Ln}\le k^{1/2}\). In particular all blocks
eventually fit into \(k\) copies.

Equations (15) and (17) are now
\[
 O\!\left(k^{-t}n^{2t/3}
           +n^{-t/2}+n^{-(1-2t)/6}\right).
\]
The compressed operators and scalar symbols have a common bound.
Telescoping each of the finitely many factors of \(q\) therefore
transfers these errors to \(q\), and (22) proves (1).
This explicit coefficient accounting is why the *moving* cutoff is
legitimate. Merely invoking a fixed-copy de Finetti result with
\(M=M(k)\), without (11) and (22), would not justify it.

For (2), fix an interval \([0,M_0^2]\) containing the spectra of both
\(O_k^*O_k,O_kO_k^*\) and all values \(|f|^2\). A fixed Bernstein
polynomial approximates \(\sqrt{x}\) uniformly on this interval.
The finite-dimensional spectral calculus transfers the approximation
to both positive operators in operator norm. Apply (1) to that fixed
polynomial in \(O_k^*O_k\), and also in \(O_kO_k^*\), then let the
square-root approximation error go to zero. This proves (2), without
normality or an invertibility assumption. Taking
\(q(X,Y)=XY-YX\), whose scalar value is identically zero, proves the
asserted commutator norm bound, since this commutator is self-adjoint.

## 6. Exact small-Schur-sector obstruction at the boundary

Fix \(V=(\mathbb C^2)_P\otimes(\mathbb C^2)_Y\otimes(\mathbb C^2)_F\),
so the padding dimension is **eight**, and let
\(h=|01\rangle\langle10|_{PY}\). For \(k\ge2\), set
\[
 C_{ij}=\delta_{ij}-1/k,\qquad
 \Psi_{P,k}=(k-1)^{-1/2}
      \sum_{i,j=1}^k C_{ij}|P_i,F_j;Y=0\rangle .
                                                               \tag{23}
\]
The notation means one \(P\)-excitation at copy \(i\), one
\(F\)-excitation at copy \(j\), and otherwise zero. Let \(\Psi_{Y,k}\)
be its \(P\leftrightarrow Y\) counterpart.

These are orthogonal unit vectors in \(S_k\).
Indeed, \(C^2=C\), \(C\mathbf1=0\),
\(\operatorname{Tr}C^2=k-1\), and \(C\) is invariant under simultaneous
row/column permutations. Both \(P\) and \(F\) in \(\Psi_P\) have label
\(\lambda_1=(k-1,1)\); \(Y\) has \(\lambda_0=(k)\).
The one-excitation representation is the permutation representation,
whose sum-zero subspace is the irreducible standard representation:
from any vector with unequal coordinates, subtract a transposition
to obtain \(e_i-e_j\); permutations of this difference span that
subspace. This also directly identifies the label \((k-1,1)\).
The \(P/Y\)-interchanged label statements hold for \(\Psi_Y\).

Only the unique \(P\)-excitation can be acted on by \(\bar h\).
Consequently
\[
 \bar h\Psi_P=k^{-1}\Psi_Y,\qquad
 \bar h\Psi_Y=0,\qquad
 \bar h^*\Psi_Y=k^{-1}\Psi_P,\qquad
 \bar h^*\Psi_P=0.
\]
Write \(w_0=w_k((k))\), \(w_1=w_k((k-1,1))\).
The eigenvalues of \(A_k^{1/2}\) on these two vectors are respectively
\(w_0/w_1^2\) and \(1/w_0\). Their span is reducing for \(O_k\), and
in the ordered basis \((\Psi_P,\Psi_Y)\),
\[
 O_k=\begin{pmatrix}0&0\\\alpha_k&0\end{pmatrix},\qquad
 \alpha_k=\frac1k\left[
 \frac{\Gamma(1+t(k+7))}{\Gamma(1+t(k+6))}
 \frac{\Gamma(1+6t)}{\Gamma(1+7t)}\right]^2.     \tag{24}
\]
All factors involving \(c\) cancel exactly. In particular,
\[
 \operatorname{Tr}|\Psi_P\rangle\langle\Psi_P|
          (O_kO_k^*-O_k^*O_k)=-\alpha_k^2,      \tag{25}
\]
whereas the scalar polynomial \(f\bar f-\bar f f\) is zero
pointwise for *every* Husimi measure.

At \(t=1/2\), put \(x=(k+8)/2\) and
\(B=[\Gamma(4)/\Gamma(9/2)]^2=1024/(1225\pi)\).
The elementary gamma bounds (5) give
\[
 B\,\frac{x^2}{k(x+1/2)}\le\alpha_k\le B\,x/k,\qquad
 \frac{x^2}{k(x+1/2)}-\frac12
       =\frac{7k+64}{2k(k+9)}>0.
\]
Both bounding rational functions tend to \(1/2\). Hence
\[
 \alpha_k\longrightarrow a_*=\frac{512}{1225\pi}>0,\qquad
 \lim_k\left|\operatorname{Tr}\sigma_k[O_k,O_k^*]\right|=a_*^2.
                                                               \tag{26}
\]
This proves an asymptotic obstruction, not just a finite discrepancy.
For any fixed \(t>0\), (5), together with gamma recurrence for its
integer part if necessary, gives
\[
 \alpha_k\sim
 t^{2t}\left[\frac{\Gamma(1+6t)}{\Gamma(1+7t)}\right]^2 k^{2t-1}.
\]
Thus the norm diverges for \(t>1/2\). For the manuscript's \(t<1/4\),
the same family instead has \(\alpha_k\to0\); it does not refute
the stated lemma.

There is a matching scalar boundary phenomenon. For
\(\theta_\epsilon=\sqrt{1-2\epsilon}|000\rangle+
 \sqrt{\epsilon}(|101\rangle+|011\rangle)\), \(0<\epsilon<1/2\),
the two relevant marginals are
\(\operatorname{diag}(1-\epsilon,\epsilon)\), and
\[
 f(\theta_\epsilon)=
       \epsilon^{1-2t}(1-\epsilon)^{2t}.
\]
At \(t=1/2\) this tends to one, whereas the support-power symbol at
\(|000\rangle\) is zero. Discontinuity alone is not being used as a
proof that the replica calculus fails; (23)-(26) supply that proof.

## 7. What is known, what is new here, and what the certificates check

The strongest directly relevant inspected baseline is the *fixed-copy*
Husimi approximation: Chiribella,
[arXiv:1010.1875v1, equation (5)](https://arxiv.org/html/1010.1875v1#S1.E5),
and Lewin--Nam--Rougerie,
[arXiv:1310.2200v3, Theorems 2.1-2.2, equations (2.5)-(2.8)](https://arxiv.org/html/1310.2200v3).
It is independently reconstructed in (20)-(21), not assumed to control
the inverse powers. The standard Schur branching/content conventions
are also independently source-checked at Vershik--Okounkov,
[arXiv:math/0503040v3, Theorem 2.9, Proposition 5.3, Theorem 5.8](https://arxiv.org/pdf/math/0503040v3).
Equations (3)-(4) spell out the particular consequences used here.
The Schur--Weyl and character input is Etingof et al.,
*Introduction to Representation Theory*, ISBN 9780821853511 (2011),
Corollary 5.19.2 and Theorem 5.22.1, with the characteristic-zero setup
in Section 5.18; the
[primary author PDF](https://math.mit.edu/~etingof/reprbook.pdf) was
opened at those statements. Both classical inputs are registered as
assumptions of `C_SYMBOL_SCHUR_FOUNDATION`, not as novel conclusions.

A bounded independent primary-literature lookup additionally inspected
Landsman--Moretti--van de Ven,
[arXiv:1909.10947v1, Theorem 3.4](https://arxiv.org/pdf/1909.10947v1)
(bounded polynomial mean-field quantization);
Bauer--Coburn--Hagger,
[arXiv:1704.05652v3, Theorems 3.4 and 4.9](https://arxiv.org/pdf/1704.05652v3)
(Fock-space products under uniform-continuity/VMO hypotheses);
and Oltman,
[arXiv:2207.09596v4, Theorems 2-4](https://arxiv.org/pdf/2207.09596v4)
(smooth growing-symbol calculus on a compact Kähler manifold).
Oltman's half-scale condition concerns derivative growth, **not** the
exponent \(t\) here. None of these inspected statements supplies
(9), (15), the gamma-weight endpoint family, or the rate (1).
Global novelty is **not established by this bounded search** and remains
an independent-review question.

The mathematical advance over the fixed-copy baseline is a full uniform
nonlinear symbol theorem with explicit cutoff/degree control and a
matching obstruction beyond its sharp exponent range. The existing
manuscript already asserts the qualitative subrange; that assertion
must not be relabeled as a new discovery.

`verify.py` checks exact algebraic identities with symbolic \(k\), not
an exhaustion over replica counts: the universal two-dimensional
algebra \(J^2=kJ\) behind (23), gamma-weight cancellation (24), the
endpoint rational squeeze and constant, the exponent balance, and
the induction identity behind the collision bound. It also checks
the normalized commutator against the preserved typed Jacobian result.
`exact_certificate.json` records those formulas and their precise scope.

`Main.lean` separately formalizes the universal finite-list collision
inequality and the arbitrary-real-parameter nilpotent/self-commutator
identities. Its compiler certificate does **not** formalize the Schur
decomposition, gamma integral, tensor construction, analytic estimates,
or all of Theorem 1. Those are proved above and require independent
mathematical review. No experiment or partial formalization is being
presented as a kernel proof of the complete analytic theorem.
