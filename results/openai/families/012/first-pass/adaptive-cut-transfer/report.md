# Quantitative adaptive cut transfer with integrated second moments

## Result and boundary

The abstract transfer used in `sampling.tex`, Proposition
`prop:sampling-comparison`, is valid under its stated hypotheses. Theorem 1
below gives a finite-size bound for the actual adaptive sign maximum. With
the manuscript's parameters it yields

\[
 {\mathbb E}\|\mathcal E(\mathbf S)\|_\square
 \le E_0+\rho_B+O(B^{-3/200}),\qquad \rho_B=o(1).
 \tag{1}
\]

Here \(\rho_B\ge0\) majorizes the uniform remainder in (44). In particular
(45) follows, even without its additional fixed \(\epsilon_2\). The power
saving concerns the sampling error, not the unspecified arithmetic remainder
\(\rho_B\). The improvement over the supplied qualitative proof is an explicit
finite-size inequality and an expectation argument that does not discard the
squared-mass tail.

This is a proof of an abstract conditional transfer, not a proof of the joint
Dickman law. Equations (23), (24), (44), the comparator row estimates, the
independent-root comparison (21), and the rest of the arithmetic argument have
not been independently established here. No false literal manuscript
assertion has been identified in this bounded audit. Thus there is no
manufactured `F_` refutation. Independent review, mathematical significance,
and originality remain Host/Reviewer decisions; no verified-new or
campaign-completion claim is made.

## Scope and known inputs

The exact source passages used are `graph.tex` lines 252-288, `moments.tex`
lines 22-37, `kernel.tex` lines 739-850, and `sampling.tex` lines 1-455 in
the staged September 24, 2026 manuscript. The required mathematical input is:

- Every-type conditional **first** moments, not conditional second moments:
  (23) and the deterministic comparator absolute row bound give \(C_0\).
- Integrated squared rows: (24) and the comparator squared-row bound give
  \(q=C_1 B^{-21/100}\). Indeed
  \(H^2\le2\mathcal L^2+2\mathcal M^2\) for
  \(H=\mathcal L+|\mathcal M|\); \(|E|\le H\).
- The single-site tests in (44) include arbitrary separate functions at each
  index and allow the value zero on removed indices. Their bound is
  \(\beta=E_0+\rho_B\).

The manuscript explicitly cites dense bounded-kernel sampling only as related
work and supplies its own proof. It does **not** invoke those sampling
theorems as black boxes. A search located Alon et al., JCSS 67 (2003),
212-243, DOI `10.1016/S0022-0000(03)00008-4`, and Borgs et al.,
Advances in Mathematics 219 (2008), 1801-1851, DOI
`10.1016/j.aim.2008.07.008`. The latter's public arXiv text
`https://ar5iv.labs.arxiv.org/html/math/0702004` was consulted as contextual
prior art. Its Theorem 4.6(i) bounds cut-norm sampling error by
\(10k^{-1/4}\|U\|_\infty\) for an iid sample from a common graphon.
That is not automatically a uniform bound for the present position-dependent,
growing kernels. No proposition from either source is assumed in this proof, and
this limited retrieval does not establish novelty or justify a claim that no
existing theorem covers this setting.

The extension construction and concentration estimate are proved below, so
no unread literature theorem is an external proof assumption. The local
unpublished manuscript inputs are recorded as explicit, still-unproved
assumptions of `C_SAMPLING_45`, not as verified citations. The Wiki index was
searched for sampling, adaptive transfer and this manuscript family; it
provided no applicable mathematical input.

Two routes are excluded in the ledger: conditioning on the optimizer, which
can destroy independence, and replacing integrated second moments by
uniform conditional ones. Neither shortcut is attributed to the staged
proof. The rare-type example replayed by `verify.py` shows why the latter
strengthening is unavailable.

Explicitly, on a triangle let each site be rare with probability \(r^{-2}\),
and set \(E_{ik}=H_{ik}=(r/2)1_{\{S_i=S_k=\mathrm{rare}\}}\), \(r\ge2\).
Then \(C_0=1/r\), \(q=1/(2r^2)\), but the conditional squared row mass
at a rare type is \(1/2\). Disjoint copies, with zero padding if necessary,
give the same example at arbitrarily large \(M\), including
\(M\asymp B^{0.32}\), \(r\asymp B^{0.105}\). This rules out the excluded
conditional-moment shortcut, not the transfer itself; its expected cut is
its integral test value, \(r^{-3}\) on a triangle.

Jacobian discovery returned no matching concentration contract among its five
reported candidates. The inspected raw-moment contract was used only to
compute one finite illustrative mass moment, \(3/128\), not to prove the
transfer. The dedicated payload/output JSON files retain the exact typed
request and result, server version, protocol, and adapter outcome.

## Theorem 1: a finite-size bound

Let \(M\ge2\), and let \(S_i\) be independent random variables taking values
in finite sets, with possibly different laws. Let real endpoint kernels
\(E_{ik}(u,v)=E_{ki}(v,u)\) and nonnegative endpoint kernels
\(H_{ik}(u,v)=H_{ki}(v,u)\) be zero on the diagonal, with \(|E_{ik}|\le H_{ik}\).
Assume, for \(C_0,q,\beta\ge0\):

\[
 \sum_k {\mathbb E}_{S_k}H_{ik}(u,S_k)\le C_0
 \quad\text{for every }i,u,                                      \tag{H1}
\]
\[
 \sum_k {\mathbb E}H_{ik}(S_i,S_k)^2\le q
 \quad\text{for every }i,                                      \tag{H2}
\]
\[
 \frac1M\left|\sum_{i,k}{\mathbb E}
       E_{ik}(S_i,S_k)g_i(S_i)h_k(S_k)\right|\le\beta
 \quad (|g_i|,|h_k|\le1).                                     \tag{H3}
\]

The diagonal is the deterministic zero kernel; no independent copy of a site
is used on that diagonal. Define the random cut norm and squared mass by

\[
 C(\mathbf S)=\frac1M\max_{\epsilon,\delta\in\{-1,1\}^M}
       \left|\sum_{i,k}E_{ik}(S_i,S_k)\epsilon_i\delta_k\right|,
 \qquad Q=\frac1M\sum_{i,k}E_{ik}(S_i,S_k)^2.
\]

Choose any integer \(1\le m<M\), any \(d>C_0\), and any \(0<\delta<1\)
such that \(p=Mq/(d-C_0)^2<1\). (The scalar \(\delta\) is a tail parameter,
not the column-sign vector used later.) Put

\[
 N={M\choose m}2^m,\quad
 a=\sqrt{\frac{8d^2}{M}\log(N/\delta)},\quad
 L=\frac{\beta+\sqrt q+a+1}{1-p},\quad
 b=\beta+\sqrt q+Lp.                                         \tag{2}
\]

Then

\[
 \boxed{\quad {\mathbb E}C\le
 b+a+2\sqrt{\frac{Mq}{m}}+\frac{2md}{M}
       \sqrt{(C_0^2+q)(p+\delta)}.\quad}                       \tag{3}
\]

For every \(t>0\), also

\[
 {\mathbb P}\left(C>b+a+2\sqrt{\frac{Mt}{m}}+\frac{2md}{M}\right)
       \le p+\frac qt+\delta.                                \tag{4}
\]

These are universal finite inequalities; no entrywise upper bound or uniform
conditional second-moment hypothesis is present. Nonallowed pairs can remain
zero throughout.

### Proof: common degree event and mass

Write \(D_i=\sum_k H_{ik}\) and \(A=M^{-1}\sum_{i,k}|E_{ik}|\).
Conditional on \(S_i\), the off-diagonal terms of \(D_i\) are independent.
Thus, by (H1)-(H2),

\[
 {\mathbb E}\operatorname{Var}(D_i\mid S_i)\le q,\quad
 {\mathbb E}D_i^2\le C_0^2+q,\quad
 {\mathbb P}(D_i>d)\le q/(d-C_0)^2.
\]

For \(\Omega=\{\max_iD_i\le d\}\), a single union over rows gives
\({\mathbb P}(\Omega^c)\le p\). Jensen across rows, without any assertion of
row independence, gives

\[
 {\mathbb E}A^2\le \frac1M\sum_i{\mathbb E}D_i^2\le C_0^2+q,
 \qquad {\mathbb E}Q\le q.                                   \tag{5}
\]

Exactly the same degree-failure upper bound \(p\) holds for every fixed
induced subset, even after fixing all outside types: its remaining types
still have the original product law, and deleting nonnegative terms only
decreases the first- and second-moment bounds.

### Proof: deterministic approximation of the adaptive optimizer

Fix a realized matrix on \(\Omega\). Take a maximizing column-sign vector
\(\delta_k\), and set \(r_i=\sum_k E_{ik}\delta_k\). Optimizing the row signs
and absorbing the exterior absolute value shows \(MC=\sum_i|r_i|\).
For a uniformly selected size-\(m\) subset \(J\), let

\[
 \widehat r_i=\frac M m\sum_{j\in J}E_{ij}\delta_j.
\]

For any deterministic \(x_1,\ldots,x_M\), the inclusion probabilities
\({\mathbb P}(j\in J)=m/M\) and
\({\mathbb P}(j,k\in J)=m(m-1)/(M(M-1))\), \(j\ne k\), give

\[
 \operatorname{Var}\left(\frac M m\sum_{j\in J}x_j\right)
 =\frac{M-m}{m(M-1)}
       \left(M\sum_jx_j^2-\left(\sum_jx_j\right)^2\right)
 \le\frac M m\sum_jx_j^2.                                    \tag{6}
\]

With the sign convention \(\operatorname{sgn}(0)=1\),
\(|r|-r\operatorname{sgn}(\widehat r)\le2|r-\widehat r|\).
Taking expectations over \(J\), then using (6) and Cauchy--Schwarz across
rows, bounds the expected unnormalized loss by
\(2M\sqrt{MQ/m}\). Hence some \(J\) achieves at most that loss.
Its row signs are

\[
 g_i=\operatorname{sgn}\left(\sum_{j\in J}E_{ij}\delta_j\right).
\]

Removing every ordered pair incident to \(J\) changes the bilinear score
by at most \(2md\), because the matrix is symmetric and every absolute
row sum is at most \(d\). Optimizing the remaining column signs gives

\[
 C\le Z_{J,\delta|_J,\mathbf S_J}
             +2\sqrt{MQ/m}+2md/M,                            \tag{7}
\]

where \(R=J^c\) and \(Z=M^{-1}\sum_{k\in R}|\sum_{i\in R}E_{ik}g_i|\).
The maximizing signs in this deterministic argument may depend arbitrarily
on the full sample. No probabilistic conditioning on their selection has
been performed. The Lean core proves the uniform response and deletion
inequalities used here for arbitrary finite real arrays.

### Proof: means after fixing a deterministic assignment

Now fix \(J\), signs \(\sigma\) on \(J\), and types \(\mathbf t\) on \(J\),
before drawing any remaining sites. Define

\[
 g_i(u)=\operatorname{sgn}\sum_{j\in J}E_{ij}(u,t_j)\sigma_j.
\]

The remaining sites are independent. This construction can be defined for
every frozen type assignment, including assignments of probability zero;
only positive-probability assignments need be interpreted as conditional
probabilities. For \(k\in R\), define

\[
 a_k(v)=\sum_{i\in R\setminus\{k\}}
                 {\mathbb E}_{S_i}[E_{ik}(S_i,v)g_i(S_i)].
\]

Apply (H3) to these fixed \(g_i\), \(h_k(v)=\operatorname{sgn}a_k(v)\),
and zero tests outside \(R\). It bounds
\(M^{-1}\sum_{k\in R}{\mathbb E}|a_k(S_k)|\) by \(\beta\).
Conditional on \(S_k\), the centered summands in its column sum are
independent. Averaging their variances and applying Cauchy--Schwarz gives

\[
 {\mathbb E}\left|\sum_{i\in R}E_{ik}g_i-a_k(S_k)\right|
 \le\left(\sum_{i\in R}{\mathbb E}E_{ik}^2\right)^{1/2}
 \le\sqrt q.
\]

The last step uses symmetry to obtain integrated column bounds. Therefore

\[
 {\mathbb E}[Z\mid\mathbf S_J=\mathbf t]\le\beta+\sqrt q,       \tag{8}
\]

uniformly in every fixed assignment. An optimizing assignment is not what
is conditioned on.

### Proof: arbitrary good configurations and the capped extension

In the remaining product space, let \(G_R\) mean that every induced
envelope degree is at most \(d\). Its failure probability is at most \(p\);
in particular it is nonempty since \(p<1\).
For arbitrary \(\mathbf u,\mathbf v\in G_R\), let
\(I=\{i:u_i\ne v_i\}\). A summand \(E_{ik}g_i\) can change only if
\(i\in I\) or \(k\in I\). Each endpoint configuration separately has
row and column absolute masses at most \(d\). The triangle inequality gives

\[
 |Z(\mathbf u)-Z(\mathbf v)|
 \le\frac1M\sum_{i\in I\ {\rm or}\ k\in I}
          (H_{ik}(\mathbf u)+H_{ik}(\mathbf v))
 \le\frac{4d}{M}|I|.                                        \tag{9}
\]

This includes changes in the row functions \(g_i(u_i)\). It requires no
chain of good configurations. This arbitrary-endpoint estimate, rather
than a one-coordinate statement only on good pairs, is formalized in
`good_configuration_lipschitz`.

Put \(c=4d/M\), \(f=\min(Z,L)\) on \(G_R\), and extend to every remaining
configuration by

\[
 F(\mathbf u)=\min\left(L,\min_{\mathbf v\in G_R}
                 [f(\mathbf v)+c\,d_H(\mathbf u,\mathbf v)]\right).
                                                               \tag{10}
\]

All sets are finite. The triangle inequality for \(d_H\) proves this
extension is \(c\)-Lipschitz; (9) proves it equals \(f\) on \(G_R\), by
using \(f(\mathbf u)\le f(\mathbf v)+c\,d_H(\mathbf u,\mathbf v)\)
and then choosing \(\mathbf v=\mathbf u\). Clamping is nonexpansive.
Consequently \(0\le F\le L\), and (8) gives
\({\mathbb E}F\le\beta+\sqrt q+Lp=b\).
By the definition of \(L\), \(b+a=L-1<L\), so on \(G_R\)

\[
 Z>b+a\quad\Longleftrightarrow\quad F>b+a.                    \tag{11}
\]

Clamping is important: an uncapped extension bounded only by a quantity of
order \(d\) need not have a negligible mean error \(d\,p\) for the
manuscript exponents.

For completeness, bounded-differences concentration here follows as follows.
Reveal the independent remaining sites one at a time. Each Doob increment
has conditional mean zero and conditional range of length at most \(c\),
by coupling identical future coordinates. A mean-zero variable of range
length \(c\) has log moment generating function at most
\(\lambda^2c^2/8\): its second derivative is its variance under exponential
tilting, at most \(c^2/4\), since distance to the interval midpoint is at
most \(c/2\). Integrate twice from zero. Iterating conditional moment
generating functions and minimizing the exponential Markov bound yields

\[
 {\mathbb P}(F>b+a\mid\mathbf t)
 \le \exp\left(-\frac{2a^2}{|R|c^2}\right)
 \le \exp(-a^2M/(8d^2))=\delta/N.                            \tag{12}
\]

### Proof: assignment count and expectations

There are exactly \(N={M\choose m}2^m\) deterministic subset/sign
assignments. Integrate (12) over the frozen subset types for each
assignment, then union their extension tails. There is no union over
possible type values. On the *single full event* \(\Omega\), every induced
configuration belongs to its corresponding \(G_R\), by nonnegativity of
the envelope. Equations (11)-(12) therefore show that, except on an event
\(\mathcal B\) of probability at most \(p+\delta\), all the \(Z\)'s needed
in (7) are at most \(b+a\).

Adding the event \(Q>t\), of probability at most \(q/t\), proves (4).
For (3) do not discard this event. Instead integrate (7) directly on
\(\mathcal B^c\), using \({\mathbb E}\sqrt Q\le\sqrt q\). On
\(\mathcal B\), use \(C\le A\) and (5), obtaining

\[
 {\mathbb E}[C\,1_{\mathcal B}]
 \le\sqrt{(C_0^2+q)(p+\delta)}.
\]

This proves (3). In particular degree failure was counted once, not
\(N\) times. All the displayed estimates remain uniform in an external
parameter whenever their hypotheses have uniform constants.

## Specialization to the manuscript

Suppose \(c_M B^{32/100}\le M\le C_M B^{32/100}\) and
\(q=C_1B^{-21/100}\). Take exactly

\[
 d=K B^{7/100},\quad m=\lfloor M B^{-18/100}\rfloor,\quad
 t=B^{-20/100},\quad \delta=B^{-3/100}.
\]

For all sufficiently large \(B\), \(d\ge2C_0\),
\(\tfrac12 M B^{-18/100}\le m<M\), and \(p<1\). The exact powers are

\[
\begin{array}{c|c}
 p\le4Mq/d^2 & O(B^{-3/100})\\
 q/t & O(B^{-1/100})\\
 2\sqrt{Mt/m} & O(B^{-1/100})\\
 2\sqrt{Mq/m} & O(B^{-3/200})\\
 2md/M & O(B^{-11/100})\\
 \sqrt q & O(B^{-21/200}).
\end{array}
\]

Also \(\log N\le m\log(2eM/m)=O(B^{14/100}\log B)\). Thus
\[
 a=O(B^{-2/100}\sqrt{\log B})=o(B^{-3/200}),
 \qquad L=O(1).
\]
Equation (4) verifies the manuscript's squared-mass threshold, skeleton
errors and common exceptional-event probabilities. Equation (3) gives
(1), a better expectation estimate than converting that threshold event
back by Cauchy--Schwarz, which would only yield \(O(B^{-1/200})\).
Uniformity is for each fixed \(s\) with the same constants; no simultaneous
good event over all \(s\) is asserted.

## What the executable and formal certificates establish

`python3 research/adaptive-cut-transfer/verify.py` uses exact integer and
rational arithmetic. It checks full adaptive optima, every skeleton
assignment, and sampling-without-replacement moments for all 729 symmetric
zero-diagonal 4-by-4 matrices with entries in {-1,0,1}; it also exhausts
specified independent binary-type models, all their deterministic
conditionings and assignments, and their actual adaptive maxima. An
explicit disconnected good set checks that (10) does not rely on good
intermediate configurations. A rare-type family separates integrated and
conditional second moments and reproduces the Jacobian moment exactly.
It additionally checks the rational exponent calculations.

These finite experiments are regression checks, not proofs of asymptotic
quantifiers. The universal deterministic adaptive response, deletion and
arbitrary-good-endpoint inequalities are proved in `Main.lean`. The
probabilistic transfer theorem is the complete mathematical proof above,
to be independently read by Reviewer; it is not claimed to be fully
formalized. The statement-fidelity document specifies this boundary.
No upstream arithmetic claim acquires verification from the Lean core.

The fair signed three-site example has integral test norm 1 and expected
adaptive norm 2, but \(q=2\), not \(o(1)\); it is deliberately not an
asymptotic counterexample. Conditioning on its chosen optimizing signs can
change a site's rare-bit probability from \(1/2\) to \(1/4\). The verifier
also checks that the finite-size bound is nonvacuous for the exact illustrative
parameters \(C_0=C_1=K=\beta=1\), \(B=2^{2000}\), with the manuscript choices:
the sampling error bound is at most \(10\,2^{-30}\). That parameter check
does not assert these constants for the actual arithmetic kernels.
