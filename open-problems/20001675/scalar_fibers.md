# Full-rate scalar fibers for the fixed path marker

**Theorem.** For every \(m\geq1\), the unchanged reviewed trees
\(U_{m,\epsilon}\), \(\epsilon\in\{0,1\}^m\), become pairwise distinct
in their full forest refinement after appending the same two-edge path
at \(v_0\):
\[
 A_\epsilon=(1+x)C_{U_{m,\epsilon}}+xC_{U_{m,\epsilon}-v_0}.
 \tag{S1}
\]
Consequently, this fixed marker gives \(2^m\) distinct full two-variable
HOMFLY polynomials on \(N=33m+4\) connected trees of maximum degree
five with identical entire independence and matching polynomials.
The reviewed connected simple non-reduced plabic realizations apply
to every member, and the joint normalized-point-count/Alexander fiber
satisfies
\[
 \log_2|\text{fiber}|\geq (N-4)/33,\qquad N=33m+4.
 \tag{S2}
\]
This is an ordinary all-\(m\) proof with exact algebraic replay.
Independent review of the new scalar theorem is pending. Historical
originality and publication-level acceptance remain unverified.

## Scope and unchanged inputs

The strongest independently accepted prior result is
`CEXPONENTIAL`: at least \(\lceil2^{m/2}\rceil\) full polynomials on
the same order \(33m+4\), using whichever of two fixed marker families
has the larger image. Its rate is \(1/66\). The new assertion is that
the path marker alone is injective on every word, doubling that rate
to \(1/33\) without changing order, degree, seeds, endpoint invariants,
or realizations.

Use the reviewed rooted pieces \(S_0,S_1\), their polynomials
\(C_i,D_i,E_i\), and the unchanged chain definition from
`joint_refinement.md` and `exponential_fibers.md`. In particular
\[
 K=y-1+xy^2,\quad E_i=(yC_i-D_i)/K,\quad
 \Delta=C_0-C_1=D_0-D_1
 =-x^6y(y-1)(1+x)K C_A C_B.                    \tag{S3}
\]
Both whole and deleted states agree at \(y=0,1\).
These are the accepted `CJOINTSEED` inputs, not reconstructed results.
The rooted recurrence, point-count and HOMFLY conventions, Alexander
specialization, and all-\(n\) disk construction are the previously
reviewed dependencies `CINTERMEDIATE`, `CEXPMARKERS`, `CEXPONENTIAL`,
and `CPLABIC`, with their already checked citations. No new external
proposition is assumed here.

The known source baseline remains Schwartz `arxiv:2410.00399v2`,
Definition 3.1, Lemma 4.1, Theorems 3.11 and 4.6, and Corollary 4.12;
Galashin--Lam `arxiv:2208.01175v1`, Proposition 5.8; and the previously
inspected interlace and rooted-transfer antecedents recorded in
`CINTERLACE` and `CJOINTCOMPARE`. General rooted transfer and these
translations are not claimed as new. The unread closest dissertation
and final-journal bodies still block historical originality assessment;
no denied source was retried.

Rooted-pair injectivity and the two-marker determinant do not imply
(S1). A scalar combination can cancel two unequal rooted states, so
the old \(x\)-adic ratio argument is not used to infer scalar
injectivity. An exact evaluation probe at \(x=2,y=3\) found all scalar
values distinct for \(3\leq m\leq14\). This finite observation was
only internal falsification; none of the proof below depends on it.

## Polynomial transfer and an exact arbitrary-word defect

Set \(O_i=C_i-xyE_i\). For a rooted piece with a child of states
\((O,E)\), the reviewed attachment recurrence becomes
\[
 \binom{O'}{E'}=
 T_i\binom OE,\qquad
 T_i=\begin{pmatrix}O_i&xD_i\\E_i&0\end{pmatrix}.
 \tag{S4}
\]
Indeed \(E'=E_iO\), while
\(O'=O_iO+xD_iE\), using \(yC_i=D_i+KE_i\).
A plain path vertex has transfer
\[
 B=\begin{pmatrix}1&x\\1&0\end{pmatrix}.
 \tag{S5}
\]
The right endpoint has vector \(v=(1,1)^t\). The old left endpoint
and its two new path vertices give
\[
 r_y=(1,xy)B^3
 =\bigl(1+2x+xy(1+x),\ x+x^2+x^2y\bigr),
 \qquad A_\epsilon=r_yT_{\epsilon_1}\cdots T_{\epsilon_m}v.
 \tag{S6}
\]
This also recovers the accepted leaf-recurrence formula (S1).

Put
\[
 \Gamma=-x^6y(y-1)(1+x)C_AC_B,\qquad
 J_y=\begin{pmatrix}y-1+xy&xK\\y-1&0\end{pmatrix}.
 \tag{S7}
\]
Equation (S3) gives the polynomial identity \(T_0-T_1=\Gamma J_y\).
For \(d_i=\eta_i-\epsilon_i\), ordinary product telescoping gives
the exact defect for arbitrary equal-length words:
\[
 A_\epsilon-A_\eta
 =\Gamma r_y\sum_{i=1}^m d_i
   T_{\epsilon_1}\cdots T_{\epsilon_{i-1}}
   J_y
   T_{\eta_{i+1}}\cdots T_{\eta_m}v.              \tag{S8}
\]
Empty products are identities. This is a polynomial identity, with no
division at \(K=0\) or either endpoint specialization. The exact full
HOMFLY defect is \(a^{-N}z^N\) times (S8) after
\(x=z^{-2},y=1-a^{-2}\), in the reviewed forest skein convention.

## The first endpoint derivative retains the entire word

At \(y=0\), let
\[
 c_*=C_0(x,0)=C_1(x,0),\quad
 D_*=D_0(x,0)=D_1(x,0),\quad s=c_*/D_*.
 \tag{S9}
\]
Here \(E_i(x,0)=D_*\), so
\[
 T_i(x,0)=D_* M,\qquad
 M=\begin{pmatrix}s&x\\1&0\end{pmatrix}.
 \tag{S10}
\]
This normalization takes place in \(\mathbb Q(x)\), with
\(D_*(0)=1\) ensuring a nonzero denominator. The later eigenvalue
calculations take place in its quadratic extension and formal-series
embedding; every inversion is of a nonzero field element, not an
evaluation at a pole.
Differentiating the exact matrix gap, not a numerical specialization,
gives
\[
 \left.\partial_y(T_0-T_1)\right|_{y=0}
 =\gamma B,\qquad
 \gamma=-x^6(1+x)M_A(x)M_B(x)\ne0.              \tag{S11}
\]
Write \(r=r_0=(a,b)=(1+2x,x+x^2)\),
\(\Phi_m=rM^mv\), \(h=\sum_i d_i\), and
\[
 w_i=(rM^{i-1}e_1)(e_1^tM^{m-i}v),\qquad e_1=(1,0)^t.
 \tag{S12}
\]
Since \(B=M+(1-s)e_1e_1^t\), differentiating (S8) gives the exact
linear word-decoding identity
\[
 \left.\partial_y(A_\epsilon-A_\eta)\right|_{y=0}
 =\gamma D_*^{m-1}
       \left(h\Phi_m+(1-s)\sum_i d_iw_i\right).
 \tag{S13}
\]
Changes in the common derivative of the other factors, including
\(r_y\), cancel because the zero-order word products agree.

The constant terms of \(c_*,D_*,\Phi_m\) are 1, and the reviewed
degree-two root gives \(s=1+2x+O(x^2)\). Thus the \(x^6\) coefficient
of (S13) is \(-h\). If \(A_\epsilon=A_\eta\), necessarily \(h=0\).
Because \(\gamma,D_*,1-s\) are nonzero, (S13) then forces
\[
 \sum_i d_iw_i=0.                              \tag{S14}
\]
We prove that this is impossible for a nonzero rational coefficient
vector \((d_1,\ldots,d_m)\). This stronger linear assertion will
establish injectivity.

## Exact spectral degree of the reviewed matching ratio

Cancel the common factor \(g=1+4x+2x^2\) from \(c_*,D_*\), obtaining
coprime polynomials \(c,d\) with constant coefficient 1:
\[
\begin{split}
c={}&1+28x+335x^2+2260x^3+9551x^4+26543x^5\\
 &+49502x^6+62051x^7+51521x^8+27417x^9\\
 &+8800x^{10}+1514x^{11}+104x^{12},\\
d={}&1+26x+291x^2+1846x^3+7358x^4+19308x^5\\
 &+33982x^6+40119x^7+31276x^8+15569x^9\\
 &+4658x^{10}+746x^{11}+48x^{12}.
\end{split}                                                   \tag{S15}
\]
Exact division and a polynomial gcd establish these assertions in
`scalar_fibers.py`. A particularly small irreducibility certificate is
\[
 c(-1/2)=d(-1/2)=-1/1024,\qquad
 (c^2+4xd^2)(-1/2)=-1/1048576<0.                \tag{S16}
\]
Therefore \(c^2+4xd^2\) is not a square in \(\mathbb Q(x)\):
a rational square is nonnegative at every real point where defined,
and cannot have a pole at this finite polynomial value. It follows
that
\[
 Q(x,\lambda)=d(x)\lambda^2-c(x)\lambda-xd(x)
 \tag{S17}
\]
is irreducible over \(\mathbb Q(x)\). It is primitive over
\(\mathbb Q[x]\), since \(\gcd(c,d)=1\), and hence irreducible in
\(\mathbb Q[x,\lambda]\).

Take the formal root \(\lambda=1+O(x)\) of
\(\lambda^2-s\lambda-x=0\), let \(\mu=-x/\lambda\), and put
\[
 t=\mu/\lambda=-x/\lambda^2=-x+O(x^2).
 \tag{S18}
\]
In particular \(t\) is transcendental over \(\mathbb Q\).
Localize at \(\lambda\), and make the invertible change
\(x=-t\lambda^2\). Under this ring isomorphism, (S17) becomes
\(\lambda F(t,\lambda)\), where
\[
 F(t,\lambda)=(1+t)\lambda d(-t\lambda^2)
                  -c(-t\lambda^2).             \tag{S19}
\]
Irreducibility is preserved by the isomorphism and localization.
Since \(F(t,0)=-1\), no factor of \(F\) can become a Laurent unit
by localization. Thus \(F\) is irreducible in
\(\mathbb Q[t,\lambda]\), and over \(\mathbb Q(t)\).
Its degree in \(\lambda\) is 25: the degree-12 term of \(d\)
contributes \(48(1+t)t^{12}\lambda^{25}\), whereas the \(c\) term
has degree 24. Consequently
\[
 [\mathbb Q(t,\lambda):\mathbb Q(t)]=25.         \tag{S20}
\]
This is a proof of the degree, not an irreducibility guess from a CAS.

## Noncancellation of every scalar word

The eigenvalues of \(M\) are \(\lambda,\mu\), with
\(\lambda+\mu=s\), \(\lambda\mu=-x\), and \(\lambda-\mu\ne0\).
The Cayley--Hamilton recurrence, including its initial values, gives
\[
\begin{split}
 rM^{i-1}e_1
  &=\frac{(a\lambda+b)\lambda^{i-1}
             -(a\mu+b)\mu^{i-1}}{\lambda-\mu},\\
 e_1^tM^{m-i}v
  &=\frac{(\lambda+x)\lambda^{m-i}
             -(\mu+x)\mu^{m-i}}{\lambda-\mu}.
\end{split}                                                   \tag{S21}
\]
Set \(P(t)=\sum_i d_it^{i-1}\) and
\(P^{\mathrm{rev}}(t)=t^{m-1}P(t^{-1})\).
For \(h=0\), multiplication in (S21) yields
\[
 \sum_i d_iw_i
 =-\frac{\lambda^{m-1}}{(\lambda-\mu)^2}
   \left(A P^{\mathrm{rev}}(t)+B_1P(t)\right),
 \tag{S22}
\]
where \(A=(a\lambda+b)(\mu+x)\) and
\(B_1=(a\mu+b)(\lambda+x)\).
After \(x=-t\lambda^2,\mu=t\lambda\), divide their common nonzero
factor \(t\lambda^2\). The remaining polynomials are
\[
\begin{split}
 A_0&=(1-t\lambda-2t\lambda^2+t^2\lambda^3)(1-\lambda),\\
 B_0&=(1-\lambda-2t\lambda^2+t\lambda^3)(1-t\lambda),\\
 B_0-A_0&=t(t-1)\lambda^3.                     \tag{S23}
\end{split}
\]
Their degrees in \(\lambda\) are at most four and their constant
coefficients are both 1.

If some \(d_i\ne0\), transcendence of \(t\) gives \(P(t)\ne0\).
Equations (S14) and (S22) would give
\[
 B_0-\theta A_0=0,\qquad
 \theta=-P^{\mathrm{rev}}(t)/P(t)\in\mathbb Q(t).
 \tag{S24}
\]
For every \(\theta\), this is a nonzero polynomial of degree at most
four: a polynomial identity would force \(\theta=1\) from the
constant term, but then (S23) is nonzero. Equation (S24) contradicts
the degree 25 in (S20). Hence every \(d_i=0\) and \(\epsilon=\eta\).
The first derivative alone therefore decodes all words, for every
length. This proves (S1); no bounded search or rooted-pair inference
fills an unproved step.

## Fixed-order invariant and plabic translations

The path marker adds exactly two vertices, changes the degree of
\(v_0\) from one to two, and preserves connectivity and the maximum
degree-five bound. The accepted whole and deleted endpoint equalities
and (S1) give equality of both entire polynomials
\(I_T(x)=C_T(x,1)\) and \(M_T(x)=C_T(x,0)\) for this same marker
at every word.

At the common order \(N\), the reviewed formulas are
\[
\begin{split}
 R_T(q)&=(q-1)^N I_T\bigl(q/(q-1)^2\bigr),\\
 P_T(a,z)&=a^{-N}z^N C_T(z^{-2},1-a^{-2}),\\
 P_T(1,z)&=z^N M_T(z^{-2}).
\end{split}                                                   \tag{S25}
\]
The last line is the reviewed Alexander/Conway specialization.
The first line is the normalized quiver point-count rational
function, not an assertion that an unnormalized variety count is a
polynomial. The middle line is injective on \(\mathbb Z[x,y]\)
at fixed \(N\): powers of \(x\) remain distinct powers of \(z^{-2}\),
and \(y\mapsto1-a^{-2}\) is an injective polynomial substitution.
Thus every word gives a different full HOMFLY polynomial while both
joint invariants remain identical.

Apply the unchanged `CPLABIC` polygon-cell construction; \(N\geq37\)
satisfies its \(n\geq2\) hypothesis. It yields connected ordinary-simple
and plabic-simple disk maps with \(N\) interior faces, mutable quiver
an orientation of the input tree, and \(6N-2\) black degree-one
boundary vertices. The specified opposite-color interior leaf with
neighbor degree at least four certifies non-reducedness.
Connectedness supplies the hypothesis of the reviewed link-identification
theorem. No non-alternating or mutation-equivalence assertion is made.
This proves the full-rate fiber conclusion (S2).

## Exact replay and acceptance boundary

Run

```sh
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python research/scalar_fibers.py --check research/scalar_fibers.json
```

The new replay reads, but does not rebuild, the accepted seed and
root-state certificates. It verifies the complete polynomial matrix
gap (S7), the derivative gap (S11), the reduced matching polynomials
and exact nonsquare witness (S15)--(S16), the invertible curve
substitution (S19) and its degree, the universal boundary algebra
(S23), and new finite algebraic indexing samples for (S13) and (S22).
The written localization and minimal-degree proof, not those samples,
establish every \(m\). Unchanged reviewed skein, point-count, and
disk certificates are reused, not replayed or relabelled.

Before custom certificate code, the Argus Jacobian bridge discovered
and inspected `polynomial.multivariate.factor.compute` and executed
one bounded factorization of the normalized two-switch path-marker
commutator. Its exact value is
\(-x^2K(s_0-s_1)\), so the actual two-switch scalar defect is
\(-x^2K(C_0E_1-C_1E_0)\). Dedicated
`jacobian/scalar-fibers-{discovery,contract,input,output,status}.json`
preserve the operation, payload, typed response, server 0.14.0,
protocol 2025-11-25, `FACTORIZED`, exact reconstruction, adapter exit
zero, and no timeout or structured error. This local factorization
does not prove the all-word theorem or its originality.

**Contribution boundary.** Compared directly with the independently
accepted rate \(1/66\), this proof supplies fixed-marker scalar
injectivity and rate \(1/33\) at identical order and degree. Its
new mathematical mechanism is the first endpoint derivative and the
degree-25 obstruction to boundary cancellation, not another finite
search or the retired matching-visible amplification. Normal
Host-invoked independent review is still required. Closest-source
priority and publication significance remain unresolved, so this note
does not declare the campaign complete or claim `verified_new`.
