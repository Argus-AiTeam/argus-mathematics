# Full-rate fixed-path fibers at every endpoint-jet depth

**Theorem (CFULLJETFIBER).** For every pair of integers \(r,m\geq1\),
use the independently reviewed polarized switches \(S_{r,0},S_{r,1}\).
Coalesce the switch roots at the internal sites of
\(v_0v_1\cdots v_{m+1}\), according to a binary word
\(\epsilon\in\{0,1\}^m\), and append the same two-edge path at \(v_0\).
Let \(A_\epsilon(x,y)\) be the resulting forest refinement. Then
\[
 \epsilon\longmapsto [y^r]A_\epsilon(x,y)
 \quad\hbox{is injective}.                                      \tag{F1}
\]
In particular, all \(2^m\) full HOMFLY polynomials are distinct on
\[
 N=n(r)m+4,\qquad
 n(r)=\frac{98q_r(3r-2q_r)+1}{3}\leq37r^2,\qquad
 q_r=2^{\lfloor\log_2r\rfloor}.                                  \tag{F2}
\]
The trees are connected and ordinary-simple, of maximum degree at most
five. They share the entire normalized quiver point count and Alexander
polynomial, the first \(r\) normalized top-\(a\) layers, and all derivatives
through order \(r-1\) at \(a=1\), for normalized and full HOMFLY.
They retain the reviewed connected simple non-reduced plabic realizations.
Thus this fixed-marker joint-invariant fiber satisfies
\[
 \log_2|\text{fiber}|=m=\frac{N-4}{n(r)}
                         \geq\frac{N-4}{37r^2}.                 \tag{F3}
\]

This is an ordinary all-\(r\), all-\(m\) proof, accompanied by an exact
rerunnable delta certificate. It is not a finite-experiment inference or
a formal-kernel certificate. The four mathematical claims below are
independently accepted by `reviewer:copilot-full-jet-scalar-review` in
the current ledger. Historical originality and publication significance
are separate, still uncertified requirements; the campaign is not complete.

## Scope: accepted inputs, unchanged

The current claim ledger independently supports `CPOLARSEED`,
`CPOLARDECODE`, `CPOLARDATA`, and `CPOLARFIBER`, with judgements by
`reviewer:copilot-polarized-jet-review`. Their statements and
`polarized_jet_fibers.{md,py,json}` are unchanged. We reuse the actual
graphs from its `switch(r, bit)` and `family(r, word, "path")`, not a
conditional replacement family. The accepted polarized scalar guarantee
was \(\lceil2^{m/2}\rceil\), with rate at least \(1/(74r^2)\). The
present delta proves injectivity of the path marker alone, doubling that
guaranteed rate at the same exact depth, order, and degree.

The depth-one scalar proof `CSCALARJET`, `CSCALARDEGREE`, `CSCALAR`,
and `CSCALARFIBER` already gives rate \(1/33\). We reuse its path-boundary
calculation, but not its degree-25 seed-specific spectral conclusion as
a conclusion about higher depths. The arbitrary-depth cubic construction,
all prior certificates, retired routes, and citation judgements are
preserved. The known source baseline is the already independently
inspected Schwartz `arxiv:2410.00399v2`, Definition 3.1, Lemma 4.1,
Theorems 3.11 and 4.6, Corollary 4.12; Galashin--Lam
`arxiv:2208.01175v1`, Proposition 5.8; and `CPLABIC`, `CINTERLACE`,
and the recorded rooted-transfer comparison with Traldi
`arxiv:0808.1888v4`. No new external proposition is needed below.
The elementary forest spectral facts used here are proved explicitly.
No completed citation review or denied source acquisition is repeated.
The unread closest dissertation and final-journal bodies remain the
historical-priority limitation, not evidence of novelty.

Write
\[
 C_i=C_{S_{r,i}},\quad D_i=C_{S_{r,i}-z},\quad
 E_i=(yC_i-D_i)/K,\quad K=y-1+xy^2,\quad
 \Delta_r=C_0-C_1=D_0-D_1.                                    \tag{F4}
\]
The reviewed polarization proves that \(K\mid\Delta_r\), that
\(\Delta_r\) has exact order \(r\) at each endpoint \(y=0,1\), and
\[
 \nu_x(\Delta_r)=8r-2,\qquad
 [x^{8r-2}]\Delta_r
   =(-1)^r y^r(y-1)^{r+1}(y-2)^{2r-2}.                         \tag{F5}
\]
Whole, deleted, and root-product states agree modulo
\(y^r(y-1)^r\). Polynomial attachment and the path marker preserve this
congruence. All uses of these conclusions refer to the accepted claims.

## The actual order-\(r\) coefficient (CFULLJETCOEFF)

Put \(B=\left(\begin{smallmatrix}1&x\\1&0\end{smallmatrix}\right)\),
\(v=(1,1)^t\), and \(O_i=C_i-xyE_i\). The accepted transfer and path row are
\[
 T_i=\begin{pmatrix}O_i&xD_i\\E_i&0\end{pmatrix},\qquad
 \rho_y=(1,xy)B^3
  =\bigl(1+2x+xy(1+x),\,x+x^2+x^2y\bigr),\qquad
 A_\epsilon=\rho_yT_{\epsilon_1}\cdots T_{\epsilon_m}v.          \tag{F6}
\]
Equal whole/deleted defects give the complete polynomial identity
\[
 T_0-T_1=(\Delta_r/K)J_y,\qquad
 J_y=\begin{pmatrix}y-1+xy&xK\\y-1&0\end{pmatrix},\qquad
 J_0=-B.                                                       \tag{F7}
\]
Let
\[
 \gamma_r=[y^r]\Delta_r,\quad
 c_*=C_i(x,0),\quad D_*=D_i(x,0),\quad s=c_*/D_*,\quad
 M=\begin{pmatrix}s&x\\1&0\end{pmatrix}.
 \tag{F8}
\]
These are independent of \(i\), and \(T_i(x,0)=D_*M\), since
\(E_i(x,0)=D_*\). The denominator \(D_*\) has constant coefficient one.
As \(K(x,0)=-1\) and \(\Delta_r\) has order \(r\),
\[
 [y^r](\Delta_r/K)=-\gamma_r,\qquad
 [y^r](T_0-T_1)=\gamma_r B.                                    \tag{F9}
\]
This is coefficient extraction from the exact gap, not the first
derivative reused at higher depth. In fact that derivative vanishes
when \(r>1\). An order-\(r\) derivative is \(r!\) times (F9).

For equal-length words \(\epsilon,\eta\), put
\(d_i=\eta_i-\epsilon_i\) and \(h=\sum_i d_i\). Telescoping the
matrix products inserts \(d_i(T_0-T_1)\) at site \(i\), with
\(\epsilon\)-prefix and \(\eta\)-suffix. The gap already contains
\(y^r\), so every other factor, including \(\rho_y\), contributes
only its value at zero to that coefficient. With
\[
 \rho=\rho_0=(a,b)=(1+2x,x+x^2),\quad
 \Phi_m=\rho M^mv,\quad
 w_i=(\rho M^{i-1}e_1)(e_1^tM^{m-i}v),
 \tag{F10}
\]
and \(B=M+(1-s)e_1e_1^t\), this proves
\[
 [y^r](A_\epsilon-A_\eta)
   =\gamma_rD_*^{m-1}
       \left(h\Phi_m+(1-s)\sum_{i=1}^m d_iw_i\right).            \tag{F11}
\]
The formula is valid also for \(r=1\) and \(m=1\).

Equation (F5), with polynomial coefficient extraction in \(x,y\), gives
\[
 \gamma_r=-4^{r-1}x^{8r-2}+O(x^{8r-1}).                       \tag{F12}
\]
This also follows directly from polarization:
\(\gamma_{a+b}=-\gamma_a\gamma_b
(c_{*,a}-D_{*,a})(c_{*,b}-D_{*,b})\), and each degree-two root has
\(c_*-D_*=2x+O(x^2)\). Thus \(s=1+2x+O(x^2)\), while
\(D_*(0)=\Phi_m(0)=1\). The coefficient of \(x^{8r-2}\) in
(F11) is exactly \(-4^{r-1}h\). Equality in (F1) therefore forces
\[
 h=0,\qquad \sum_i d_iw_i=0.                                  \tag{F13}
\]
Here \(\gamma_r,D_*,1-s\) are nonzero field elements. The remaining
issue is uniform noncancellation, not rooted-pair injectivity.

## A uniform forest spectral lemma (CFULLJETSPECTRUM)

**Lemma.** Let \(T\) be a connected rooted tree with a root-to-vertex
path of length \(\ell\geq4\). Reduce its matching ratio to \(c(x)/d(x)\),
where \(c,d\in\mathbb Q[x]\) are coprime and \(c(0)=d(0)=1\).
Then
\[
 c^2+4xd^2\text{ is not a square in }\mathbb Q(x),\qquad
 k:=\max\{2\deg c,\,2\deg d+1\}\geq\ell+1\geq5.                 \tag{F14}
\]
Moreover \(k\) is exactly the number of root-visible distinct adjacency
eigenvalues. No irreducibility computation for individual seeds is needed.

**Proof.** Let \(H\) be the real symmetric adjacency matrix. Its
characteristic polynomial and that of the root-deleted forest satisfy
\[
 \chi_T(z)=z^{|T|}M_T(-z^{-2}),\qquad
 \chi_{T-z_0}(z)=z^{|T|-1}M_{T-z_0}(-z^{-2}).                  \tag{F15}
\]
Indeed, the determinant expansion has no permutation cycles of length
at least three, since \(T\) is a forest. Its disjoint transpositions
are precisely matchings; each contributes a factor \(-1\), with
one factor \(z\) for every fixed point. This proves (F15).

A real symmetric matrix has an orthonormal eigenbasis: maximizing the
Rayleigh quotient on the unit sphere gives one eigenvector; its
orthogonal complement is invariant, and induction gives the basis.
For distinct eigenvalues \(\theta\), let
\(\omega_\theta=\|\operatorname{proj}_{\theta}e_{z_0}\|^2\).
Cramer's rule and this decomposition give
\[
 \frac{\chi_{T-z_0}(z)}{\chi_T(z)}
   =e_{z_0}^t(zI-H)^{-1}e_{z_0}
   =\sum_{\omega_\theta>0}\frac{\omega_\theta}{z-\theta},
 \qquad \omega_\theta>0,\quad \sum\omega_\theta=1.              \tag{F16}
\]
Every visible \(\theta\) is a genuine simple pole: its positive residue
cannot cancel against the other, regular terms.

Set
\[
 p(z)=z^k c(-z^{-2}),\qquad q(z)=z^{k-1}d(-z^{-2}).
 \tag{F17}
\]
These are monic polynomials of degrees \(k,k-1\). At nonzero roots
they have no common zero, by coprimality of \(c,d\). At zero, exactly
one of their lowest exponents is zero: the maximum defining \(k\)
is between an even number and an odd number, so is attained only once.
That polynomial has a nonzero constant coefficient. Hence \(p,q\)
are coprime. Equations (F15)--(F16) identify \(q/p\) with the reduced
root resolvent. Its denominator degree \(k\) is therefore the number
of visible eigenvalues.

Since \(\sum\omega_\theta\theta^2=(H^2)_{z_0z_0}
=\deg(z_0)>0\), some visible \(\theta\) is nonzero.
At such a pole, \(p(\theta)=0\) and \(q(\theta)\ne0\).
Consequently \(x_0=-\theta^{-2}<0\) has
\[
 c(x_0)=0,\quad d(x_0)\ne0,\quad
 (c^2+4xd^2)(x_0)=4x_0d(x_0)^2<0.                            \tag{F18}
\]
A rational square cannot be negative there: equivalently, continuity
gives a negative interval, whereas a rational square is nonnegative
away from its finitely many poles. This proves nonsquareness exactly,
without a numerical approximation to \(\theta\).

Finally, the vectors \(e_{z_0},He_{z_0},\ldots,H^\ell e_{z_0}\)
are linearly independent. On the successive vertices of the path,
an entry of \(H^j e_{z_0}\) is zero at distance greater than \(j\)
and is one at distance \(j\), because the shortest tree path is unique.
The resulting triangular minor has diagonal entries one.
The full cyclic span has dimension equal to the number of visible
eigenvalues: the nonzero spectral projections are independent, and
the Vandermonde matrix in their distinct eigenvalues spans them.
Thus \(k\geq\ell+1\), proving (F14).

**Application to every actual polarized seed.** The unchanged 33-vertex
edge lists contain, in both bits, the exact simple path
\[
 0,23,22,17,18,19,20,21.                                     \tag{F19}
\]
Its length is seven, in particular at least four. In each recursive
polarization, the first coalesced child contains a fresh, unchanged
copy of \(S_{\lfloor r/2\rfloor,0}\). Coalescence identifies only roots;
it deletes none of this copy's vertices or edges. Prepending the edge
from the fresh root to the child's root gives a simple path one edge
longer. As the whole graph is a tree, there is no shortcut. Induction
therefore preserves the required root-path bound at every \(r\), for
both bits, before (F14) is applied. In the actual labels of `switch`,
the path recursion is \(P_{r,i}=(0,1+P_{\lfloor r/2\rfloor,0})\)
for \(r>1\), with (F19) at \(r=1\).

For the matching ratio \(s=c/d\) at any depth, (F14) makes
\[
 Q(x,\lambda)=d(x)\lambda^2-c(x)\lambda-xd(x)                  \tag{F20}
\]
irreducible over \(\mathbb Q(x)\). Coprimality of \(c,d\) makes it
primitive over \(\mathbb Q[x]\), so Gauss's lemma makes it irreducible
in \(\mathbb Q[x,\lambda]\). Take the formal root
\(\lambda=1+O(x)\) of \(\lambda^2-s\lambda-x=0\), and put
\[
 \mu=-x/\lambda,\qquad t=\mu/\lambda=-x/\lambda^2=-x+O(x^2).
 \tag{F21}
\]
The formal root exists uniquely by recursively solving coefficients,
since the derivative at \(x=0,\lambda=1\) is one.
The valuation of \(t\) is one, so no nonzero polynomial over
\(\mathbb Q\) can vanish at \(t\): its lowest power of \(t\) has
strictly smaller valuation than every other term. Thus \(t\) is
transcendental over \(\mathbb Q\).

Localizing at \(\lambda\), the invertible change \(x=-t\lambda^2\)
sends \(Q\) to \(\lambda F\), where
\[
 F(t,\lambda)=(1+t)\lambda d(-t\lambda^2)-c(-t\lambda^2).
 \tag{F22}
\]
Irreducibility is preserved in the Laurent-polynomial ring. As
\(F(t,0)=-1\), no factor can disappear as a power of \(\lambda\)
under localization. Hence \(F\) is irreducible in
\(\mathbb Q[t,\lambda]\), and over \(\mathbb Q(t)\).
Its \(\lambda\)-degree is precisely \(k\): the two possible leading
degrees \(2\deg d+1\) and \(2\deg c\) have different parity.
Thus
\[
 [\mathbb Q(t,\lambda):\mathbb Q(t)]=k\geq5.                   \tag{F23}
\]
This extends the accepted depth-one degree argument by a uniform
spectral proof for the actual family, not a conditional criterion.

## Noncancellation and exact decoding (CFULLJETDECODE)

The unchanged Cayley--Hamilton and boundary calculation
(S21)--(S24) in `scalar_fibers.md` works for any \(s\) above:
\[
 \begin{split}
 \rho M^{i-1}e_1
 &=\frac{(a\lambda+b)\lambda^{i-1}
             -(a\mu+b)\mu^{i-1}}{\lambda-\mu},\\
 e_1^tM^{m-i}v
 &=\frac{(\lambda+x)\lambda^{m-i}
             -(\mu+x)\mu^{m-i}}{\lambda-\mu}.
 \end{split}                                                 \tag{F24}
\]
The denominators are nonzero; \(\lambda-\mu=1+O(x)\).
Put \(P(t)=\sum_i d_it^{i-1}\) and
\(P^{\rm rev}(t)=t^{m-1}P(t^{-1})\), including leading zero
coefficients when necessary. If \(h=0\), multiplying (F24) gives
\[
 \sum_i d_iw_i=-\frac{\lambda^{m-1}}{(\lambda-\mu)^2}
    \left(A P^{\rm rev}(t)+B_1P(t)\right),
 \quad A=(a\lambda+b)(\mu+x),\quad B_1=(a\mu+b)(\lambda+x).
 \tag{F25}
\]
The same path boundary has, after dividing \(A,B_1\) by the
nonzero factor \(t\lambda^2\),
\[
 \begin{split}
 A_0&=(1-t\lambda-2t\lambda^2+t^2\lambda^3)(1-\lambda),\\
 B_0&=(1-\lambda-2t\lambda^2+t\lambda^3)(1-t\lambda),\\
 B_0-A_0&=t(t-1)\lambda^3.
 \end{split}                                                 \tag{F26}
\]
Both degrees are at most four and both constant coefficients are one.
For a nonzero vector \(d\), transcendence gives \(P(t)\ne0\).
Equations (F13) and (F25) would force
\[
 B_0-\theta A_0=0,\qquad
 \theta=-P^{\rm rev}(t)/P(t)\in\mathbb Q(t).                    \tag{F27}
\]
This is a nonzero polynomial of degree at most four: an identity would
force \(\theta=1\) from its constant coefficient, and then contradict
the last line of (F26). Equation (F27) contradicts (F23).
Every \(d_i\) is therefore zero, proving (F1) for all \(r,m\).
The argument works for arbitrary rational \(d_i\), not just binary
differences.

It also gives an explicit finite exact decoder. Compute the reference
\(H_0=[y^r]A_{0^m}\) and the known polynomials
\[
 f_i(x)=\gamma_r\,\rho(D_*M)^{i-1}B(D_*M)^{m-i}v.
 \tag{F28}
\]
For an input \(H=[y^r]A_\epsilon\), (F11) says
\(H_0-H=\sum_i\epsilon_i f_i\). The preceding proof makes these
\(m\) polynomials linearly independent over \(\mathbb Q\).
Equate their finitely many \(x\)-coefficients and solve this full-rank
rational linear system. Its unique solution is the word \(\epsilon\).
In particular \(-4^{1-r}[x^{8r-2}](H_0-H)=|\epsilon|\).
The certificate implements this coefficient-system decoder and checks
the reconstructed polynomial, not just the sampled pivot equations.

## Faithful endpoints, HOMFLY, size, and plabic conclusions

All graph and invariant data are the unchanged reviewed data of
`CPOLARSEED` and `CPOLARDATA`. Each switch has \(n(r)\) vertices,
root degree two, and maximum degree five. Coalescing at \(m\) internal
path sites gives \(n(r)m+2\) vertices; the fixed marker adds two.
Site roots have degree four, and the marked left endpoint has degree
two. These operations preserve tree connectivity and simplicity.

At the fixed common order \(N\), the accepted translations are
\[
 \begin{split}
 P_\epsilon(a,z)&=a^{-N}z^N A_\epsilon(z^{-2},1-a^{-2}),\\
 R_\epsilon(q)&=(q-1)^N A_\epsilon\!\left(q/(q-1)^2,1\right),\\
 P_\epsilon(1,z)&=z^N A_\epsilon(z^{-2},0).
 \end{split}                                                 \tag{F29}
\]
The point count here is the reviewed normalized rational function;
it is not relabelled as an unnormalized variety-count polynomial.
The substitution in the first line is injective on
\(\mathbb Z[x,y]\), and the common Laurent monomial is nonzero.
Thus (F1) counts full HOMFLY polynomials, not merely graphs.

The accepted divisibility of every pairwise difference by
\(y^r(y-1)^r\) gives both entire endpoint invariants and the requested
jets. With \(u=a^{-2}\), normalized differences are divisible by
\(u^r(1-u)^r\), so their coefficients of \(u^j\), \(j<r\), agree.
At \(a=1\), \(1-a^{-2}=2(a-1)+O((a-1)^2)\). Consequently
\[
 [(a-1)^r](P_\epsilon-P_\eta)
   =2^r z^N [y^r](A_\epsilon-A_\eta)(z^{-2}).                  \tag{F30}
\]
All lower derivatives of normalized and full HOMFLY agree, while
the first omitted Alexander-endpoint coefficient, and equivalently
the order-\(r\) full derivative, distinguishes all words.
No first omitted top-\(a\) coefficient injectivity is asserted.

For \(N\geq37\), `CPLABIC` applies unchanged to every tree. It gives
a connected ordinary-simple and plabic-simple disk graph with \(N\)
interior faces, \(6N-2\) black boundary vertices, the tree quiver, and
the specified opposite-color interior leaf certifying non-reducedness.
Degree five is the tree degree bound, not a disk-graph bound.
No non-alternating or mutation-equivalence assertion is added.
This proves (F2)--(F3) with all the claimed invariant and link conclusions.

## Exact delta replay and its limits

```sh
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python research/full_jet_scalar_fibers.py --check research/full_jet_scalar_fibers.json
```

The new replay checks the complete generic transfer gap and its
order-\(r\) coefficient reduction, the new matching and gap recurrences,
the localized spectral identity, and the typed cleared-transfer
characteristic polynomial. Small exact forest determinants and Krylov
ranks check both parity cases of the spectral-degree identification.
Actual reviewed base edges check (F19); actual recursive graphs check
its preservation. New all-\(x\) Taylor computations at depths two and
three check the first omitted coefficient, its predicted transfer
insertions, and exact coefficient decoding. These bounded samples test
the implementation and indexing; (F7)--(F27), not enumeration, prove
all quantifiers. Unchanged reviewed certificate programs are not invoked.

The new certificate generation exited zero in 12.8 seconds and persisted
19,455 bytes with exact JSON readback. All 56 residuals are zero: 21
unrestricted or typed identities, nine small-forest determinant/resolvent
checks, six new seed-coefficient/matching checks, and 20 word-coefficient
checks. The 20 words are decoded exactly at \((r,m)=(2,1),(2,2),(2,3),
(3,1),(3,2)\). Actual marked graphs on 266 and 658 vertices agree with
the all-\(x\) Taylor transfer through orders two and three. Equal-weight
words \(01\) and \(10\) have nonzero order-\(r\) coefficient gaps, with
\(x\)-leading terms \(8x^{17}\) at depth two and \(32x^{25}\) at depth
three. Thus these checks exercise positional information, not just word
weight. They remain bounded implementation checks, not the uniform proof.

Jacobian discovery and exact-contract inspection preceded this custom
certificate. The one bounded operation
`matrix.symbolic.characteristic_polynomial.compute` returned
\(\Lambda^2-c\Lambda-xd^2\) for the polynomial matrix
\(\left(\begin{smallmatrix}c&xd\\d&0\end{smallmatrix}\right)\).
Its server version 0.14.0, protocol 2025-11-25, exact payload, complete
typed output, adapter exit zero, no timeout, and no structured error
are preserved in dedicated `jacobian/full-jet-scalar-*.json` files.
This result supplies the characteristic polynomial only, not an
irreducibility or all-depth theorem verdict.

`CFULLJETCOEFF`, `CFULLJETSPECTRUM`, `CFULLJETDECODE`, and
`CFULLJETFIBER` have independent mathematical acceptance. Their
statements, proof identities, and certificates are unchanged by the
publication comparison below. No accepted certificate is replayed in
this source-comparison cycle. Historical originality and publication
significance are not certified by mathematical acceptance or structural
checks.

## Publication statement and candidate new core

For a tree of fixed order \(N\), put
\(\widehat P_T=a^Nz^{-N}P_T=C_T(z^{-2},1-a^{-2})\), and let
\(\mathcal D_r(T)\) consist of \(N\), the entire normalized
\(R_T(q)\), the entire \(P_T(1,z)\), the coefficients of
\(t^0,\ldots,t^{r-1}\) in \(\widehat P_T\), where \(t=a^{-2}\),
and the derivatives of \(P_T\) and \(\widehat P_T\) at \(a=1\)
of orders less than \(r\). Equations (F1)--(F3) and (F29)--(F30)
prove the following non-recovery statement:

For every \(r,m\geq1\), a single value of \(\mathcal D_r\) has at
least \(2^m\) distinct full HOMFLY polynomials among explicitly
realized connected simple non-reduced plabic graphs with degree-five
tree quivers of order \(N=n(r)m+4\). Within the constructed family
there are exactly \(2^m\), and the first omitted Alexander-endpoint
coefficient determines the word by a full-rank rational coefficient
system. At fixed \(r\), this gives a positive exponential fiber rate
at least \(1/(37r^2)\). These are the stated constructed orders,
not all integer orders \(N\); quadratic depth cost is an upper bound
for this construction, not a lower bound on every possible construction.

The candidate contribution is this simultaneous arbitrary-depth,
bounded-degree, quantitative non-recovery theorem and its uniform scalar
decoder. It is not a new HOMFLY/forest invariant, endpoint substitution,
rooted-transfer formula, or spectral-resolvent identity. Traldi transfer
supplies the matrix expression; it does not alone exclude the word
relation (F27). The independently accepted degree comparison
(F23)--(F27) supplies precisely that exclusion for every actual seed
and every word length. Rooted-pair separation alone would yield only
the earlier two-marker guarantee, not (F1). No historical originality
is inferred merely from this distinction.

The knot restriction is the independently accepted
`CKNOTJETFIBER` in `knot_jet_fibers.md`, with order
\(N=2n(r)m+8\), tree degree six, and rate at least
\((N-8)/(74r^2)\) for the logarithm of fiber size. Compare this with
the present degree-five link bound \((N-4)/(37r^2)\):
knotness is an additional restriction at doubled order, not a rate
improvement. Known corona surgery is not a separate originality claim.

## Primary-source comparison, 3 November 2026

The already independently attributed Schwartz v2, Galashin--Lam,
forest-interlace, and Traldi statements remain the proof's unchanged
source baseline. In particular, Galashin--Lam's published comparison is
with normalized top \(a\)-degree, not full two-variable HOMFLY.
The theorem above does not refute that comparison or its
mutation-equivalence conjecture.

The complete 13-page author-hosted Stoimenow manuscript
*Independence polynomials and Alexander-Conway polynomials of plumbing
links* was obtained and read in this cycle. Its actual link is
`http://stoimenov.net/stoimeno/homepage/papers/plumb_rev.pdf`, as
listed by the author; the search-generated `plumb_rev4.pdf` URL was
not used. The paper list dates the manuscript 30 January 2021,
while the PDF metadata dates its production 8 June 2021 and names
`plumb_rev4.dvi`. The retained PDF and text are
`literature/stoimenow-plumb-rev.{pdf,txt}`. This provenance identifies
the author manuscript associated with
`doi:10.1016/j.jcta.2021.105487`, not an inspected publisher-formatted
version. The actual statements and hypotheses are retained in
`literature/stoimenow-plumbing-excerpt.txt`.

Section 2, equation (1), identifies independence of the **line graph**
with matching of the plumbing tree:
\(I_{\Lambda(G)}(x)=M_G(x)\). For ordinary positive Hopf bands,
Section 4.2, Lemma 4.1, equation (10), then gives
\(\nabla_{L(G)}(z)=z^{|G|}M_G(z^{-2})\). This is the same
polynomial formula as our known Schwartz matching endpoint; it is
not a formula replacing \(M_G\) by the independence polynomial
\(I_G\) of the tree quiver. No isotopy between the two link
constructions is asserted. The remark in Section 4.1 about chord
orders concerns mutant plumbing links with equal polynomials,
not a family with distinct full HOMFLY polynomials.

The source's Corollary 5.2, equation (18), concerns alternating
tree plumbing links, log-concavity, triangular Alexander coefficients,
and their adjacent-coefficient ratio. It is **not** a theorem on
families agreeing through a finite number of coefficients. The
search-generated claim to that effect, and its supposed HOMFLY remark,
are unsupported by the directly read body and are not used.
None of the statements in this inspected manuscript gives simultaneous
finite-jet fibers, scalar word decoding, or the quadratic-depth
exponential bound. This is a comparison with that body only, not
an assertion of absence throughout the literature.

A bounded source-acquisition task in this cycle obtained neither
Schwartz's dissertation body nor the final IMRN body. The new final
article HTML request returned HTTP 403. Readable author pages and
arXiv metadata supplied no explicit final-version equivalence;
the FPSAC page's "Final version: April 1, 2025" refers to its
12-page SLC extended abstract, not the 2026 IMRN article.
The exact successful and unsuccessful URLs are recorded in the existing
`literature/cited_propositions.txt`. Previously denied endpoints were
not retried. Those access results are not novelty evidence.

Consequently `CJETSOURCECOMPARE` records only this scoped comparison.
The candidate's historical originality remains unresolved against the
closest dissertation and final article; field-level publication
significance also awaits independent assessment. The complete theorem
and accepted exact certificates are preserved, but this cycle cannot
certify `novelty_status=verified_new` or campaign completion.
