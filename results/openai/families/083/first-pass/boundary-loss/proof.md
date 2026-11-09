# A stopped logarithmic boundary-potential theorem

## Result and scope

This is an independent verification of the mechanism in
`build/sections/11-assembly.tex`, Lemma `assembly:boundary-loss`
(lines 224-349), not a verification of the main Hilbert-transform theorem.
Paths below are relative to the staged manuscript directory
`research/openai_manuscript/A-uniform-Hilbert-transform-estimate-for-Lipschitz-directions-September-25-2026/`.
No false assertion in the scoped lemma has been established.

The verification sharpens the manuscript's depth-independent estimate to

\[
 {\mathbb E}_\vartheta\sum_{i<k_T}
 \log\frac{m_{v_{i+1}(T)}}{n_{v_i(T)}}
 \ \le\
 2\epsilon\sum_{j<k_T}G^{-j}
       \log\frac{M_j(\epsilon)}{h_T}
 \ \le\
 \frac{2\epsilon(1-G^{-k_T})}{1-G^{-1}}\log\frac n{h_T}.
 \tag{1}
\]

In particular there is no loss proportional to angular depth. The stronger
first bound retains the spatially local eligible masses, rather than replacing
all of them by the global mass. Novelty and publishable significance of this
refinement are not independently established here.

## Objects and hypotheses

At one fixed spatial point, let there be finitely many tops \(U\), with slopes
\(s_U\in\mathbb R\), positive weights \(h_U\), and positive precisions \(d_U\).
Let \(n=\sum_Uh_U\). Fix \(G\in\mathbb N\), \(G\ge2\), \(d_0>0\), \(B>0\),
and \(d_i=d_0G^{-i}\). The grids consist of the half-open intervals
\([\vartheta+qd_i,\vartheta+(q+1)d_i)\). The single parameter \(\vartheta\)
is uniform modulo \(d_0\). A top belongs to a level-\(i\) node precisely when
its slope belongs to that interval and \(d_U\le d_i/B^2\).
For an empty collection, the packet conclusion is the identity \(0\le0\);
every logarithm below is used only after fixing an existing positive-weight top.

Use the **actual** last eligible levels \(k_T\) and \(k_s\) in
`08-hierarchy.tex`, `hier:stopping-levels`, with \(k_s\le k_{T(s)}\).
The boundary denominator is exactly `eq:src-14`: for the final transition
of its designated block, it includes the entire immediate parent's
eligible mass and only eligible immediate-child masses outside that parent,
inside its block ancestor, and at interval distance less than
\(G^{-1/4}d_i\) from the distinguished child. In particular
\(n_{v_i(T)}\le m_{v_{i+1}(T)}\le n\).

Assume \(0<\epsilon=4G^{-1/4}<1/2\), as holds for the manuscript's sufficiently
large \(L\). The proof in fact allows any radius \(\epsilon<1/2\) covering
all extra tops in a boundary denominator, and any deterministic decreasing
eligibility filtration, not only precision thresholds. No independence of
the different angular levels is a hypothesis.

For the packet conclusion we separately assume the manuscript's upstream
inputs: at the chosen point \(z\in Z_0\), every interval of lengths on top
\(T\) has sum of norm at most \(H_T=L^{C_{\rm top}}h_T^8\);
\(|q_T|\le1\); \(0<h_T\le C_3\); and \(n\le NL^{C_n}\), with
\(\log N\le2L\). The interval bound is `05-concentration.tex`, `eq:src-11`,
with the enlargement to \(h_T\) justified immediately after `eq:src-12`.
These analytic upstream inputs are **assumptions of the application**,
not results proved in this audit.

## The geometric comparison, including the parent denominator

Fix \(T\), put \(k=k_T\), and define, for every \(i<k\),

\[
 M_i(b)=\sum_{\substack{|s_U-s_T|\le bd_i\\d_U\le d_i/B^2}}h_U,\qquad
 R_i=\log(m_{v_{i+1}(T)}/n_{v_i(T)}).
\]

Then \(h_T\le M_i(b)\le n\), including \(b=0\). An extra top \(U\) in
\(m_{v_{i+1}(T)}-n_{v_i(T)}\) satisfies
\[
 |s_U-s_T| < (G^{-1/4}+2/G)d_i\le\epsilon d_i.
\]
This follows by inserting a closest pair of points in the two child
intervals; each child has length \(d_i/G\). Its eligibility at \(i+1\)
implies eligibility at \(i\). Restricting to the block ancestor can only
remove such extra mass, so the estimate is uniform in the number and
positions of block endpoints.

Let \(b_i\) be the distance to the nearer boundary of \(v_i(T)\), divided
by \(d_i\). Outside a finite null set of endpoint coincidences,
\(R_i=0\) when \(b_i>\epsilon\). When \(0<b_i\le\epsilon\), write
\(x=n_{v_i(T)}\), \(u=M_i(b_i)\), \(v=M_i(\epsilon)\), and let \(e\)
be the extra mass. The inner tops are all in the parent and disjoint
from the extras, so
\[
 x\ge u>0,\quad 0\le e\le v-u,\qquad
 \frac{x+e}{x}=1+\frac e x
 \le 1+\frac{v-u}{u}=\frac v u.
 \tag{2}
\]
This explicitly justifies the logarithmic comparison despite all other
mass already present in the denominator. The conclusion is
\[
 R_i\le {\bf1}_{\{0<b_i\le\epsilon\}}
             \log(M_i(\epsilon)/M_i(b_i)).
 \tag{3}
\]

## Stopping and the exact finite telescope

Set
\[
 a_i=\begin{cases}\log(M_i(\epsilon)/h_T),&i<k,\\0,&i\ge k.\end{cases}
\]
All these numbers are nonnegative and at most \(A=\log(n/h_T)\).
For \(0<b<\epsilon\), put \(r=\lceil\log_G(\epsilon/b)\rceil\ge1\).
If \(i+r<k\), radius containment and the decreasing eligibility threshold
give \(M_{i+r}(\epsilon)\le M_i(b)\).
If \(i+r\ge k\), use \(M_i(b)\ge h_T\), not an unjustified positive
continuation past the last eligible level. Thus in both cases
\[
 \log(M_i(\epsilon)/M_i(b))\le a_i-a_{i+r}.
 \tag{4}
\]

For every finite \(k,r\ge0\), and every sequence zero at and beyond \(k\),
the following is an **identity**:
\[
 \sum_{i<k}(a_i-a_{i+r})
       =\sum_{j<\min(r,k)}a_j.
 \tag{5}
\]
To see this before imposing support, compare the two decompositions
of \(\sum_{j<k+r}a_j\) at \(k\) and at \(r\).
The uncancelled expression is
\(\sum_{j<r}a_j-\sum_{j<r}a_{k+j}\).
The latter sum vanishes; if \(r>k\), the additional terms in the former
also vanish. This proof includes \(k=0\), \(r=0\), \(r=k\), and \(r>k\).
It neither counts transitions after stopping nor discards a terminal term.

## Averaging the one common translation

Because \(d_0/d_i=G^i\) is an integer, reduction of a uniform translation
modulo \(d_0\) modulo \(d_i\) is uniform. On one period, the normalized
distance to the nearer endpoint has density \(2\) on \([0,1/2]\).
This is a one-dimensional change of variables on the two halves of
an interval. Finite linearity of integration in (3) therefore gives
\[
 \mathbb E\sum_{i<k}R_i
 \le 2\int_0^\epsilon\sum_{i<k}
              \log(M_i(\epsilon)/M_i(b))\,db.
 \tag{6}
\]
The \(b_i\) are not jointly replaced by independent variables.
Only their individual, identical marginal laws have been used.

Put \(q=G^{-1}\). The function \(r(b)\) satisfies
\[
 \{b\in(0,\epsilon):r(b)>j\}=(0,\epsilon q^j)
 \quad\text{up to endpoints},\qquad j\ge0.
\]
Integrate (4)-(5), summing over the **finite** index set \(j<k\):
\[
 \int_0^\epsilon\sum_{j<\min(r(b),k)}a_j\,db
       =\epsilon\sum_{j<k}q^ja_j.
 \tag{7}
\]
There is no exchange of an infinite sum and a possibly singular integral.
Equivalently, partition into \(k\) geometric layers and the final tail:
\[
 \sum_{r<k}(q^r-q^{r+1})\sum_{j\le r}a_j
       +q^k\sum_{j<k}a_j
       =\sum_{j<k}q^ja_j.
 \tag{8}
\]
The tail is essential. Equations (6)-(8) prove (1), using the finite
geometric sum \(\sum_{j<k}q^j=(1-q^k)/(1-q)\).
For \(k=0\), every expression is zero, as required.

## Central cancellation and packet removal

Let \(t=\mu/K>0\). The coefficient in `08-hierarchy.tex`, `eq:src-15`,
at equal coordinates is, for a packet stopped at level \(\ell=k_s\),
\[
 n_0^t n_\ell^{-t}\prod_{i<\ell}(n_{i+1}/m_{i+1})^t
       =\prod_{i<\ell}(n_i/m_{i+1})^t
       =e^{-t\sum_{i<\ell}R_i}=\kappa_\ell.
 \tag{9}
\]
All masses appearing here are positive. Consecutive eligible masses
cancel even when other tops cease to be eligible. The empty product at
\(\ell=0\) is exactly one. This is the literal `eq:src-30`, not a
replacement using total mass in its denominator.

On one fixed top, \(d_s=w/\ell_s\). Consequently \(k_s\) is a
nondecreasing function of packet length. Group packets of the same
stopping level and let their sums be \(x_0,\ldots,x_k\), allowing empty
groups. Every suffix \(\sum_{\ell=j}^kx_\ell\) is a sum over an interval
of lengths, so its norm is at most \(H_T\). Define
\(\delta_\ell=1-\kappa_\ell\). Then
\[
 0=\delta_0\le\cdots\le\delta_k,\qquad
 \delta_k\le t\sum_{i<k}R_i,
 \tag{10}
\]
by \(1-e^{-x}\le x\) for \(x\ge0\).
The latter inequality follows from \(e^{-x}\ge1-x\).
With \(\Delta_0=\delta_0\) and
\(\Delta_j=\delta_j-\delta_{j-1}\ge0\), the exact finite Abel identity is
\[
 \sum_{\ell=0}^k\delta_\ell x_\ell
       =\sum_{j=0}^k\Delta_j\sum_{\ell=j}^kx_\ell.
 \tag{11}
\]
The triangle inequality yields a bound \(H_T\sum_j\Delta_j=H_T\delta_k\),
not a multiple of \(kH_T\). Multiplication by the fixed scalar \(q_T\)
does not increase this bound. Taking expectations gives the stronger
packet theorem
\[
 \mathbb E\Big\|\sum_{s:T(s)=T}(1-\kappa_s)q_T\phi_s\Big\|
 \le 2\epsilon t H_T
       \sum_{j<k_T}G^{-j}\log(M_j(\epsilon)/h_T)
 \le \frac{2\epsilon t}{1-G^{-1}}H_T\log(n/h_T).
 \tag{12}
\]

Finally \(0<h\le C_3\) and \(n\ge h\) imply
\[
 h^8\log(n/h)
 \le C_3^7h\log_+n
       +h\sup_{0<x\le C_3}x^7\log_+(1/x)
 \le C h(1+\log_+n).
 \tag{13}
\]
For \(0<x\le1\), writing \(x=e^{-u}\) makes the bounded term
\(u e^{-7u}\le1/7\), since \(e^{7u}\ge1+7u\ge7u\);
for \(x\ge1\), it is zero.
The manuscript's \(n\le NL^{C_n}\) and \(\log N\le2L\) give
\(1+\log_+n\lesssim L\) for sufficiently large \(L\).
Sum (12) over the finite set of tops, use \(t\le1\), and absorb fixed
polynomial powers of \(L\). This proves the literal conclusion
\[
 \mathbb E_\vartheta\|P_q(z)-\mathcal W_\vartheta(z)\|
       \le L^C\epsilon n(z),\qquad z\in Z_0.
 \tag{14}
\]

## Evidence boundaries

An exact two-top calculation independently exercises the common translation
and the block-ancestor restriction. Give both tops last eligible level \(k\),
slopes \(0,x\), and weights \(h,H>0\). For \(k\ge1\), choose
\(x=d_{k-1}/32\), \(G=65536\), and any integer \(K\ge1\).
At every active transition the two children are always within the strict
neighbor radius: their child-index difference is at most
\(\lceil x/d_{i+1}\rceil\le G^{3/4}\).
The ancestor level is exactly \(a(i)=\max(0,i+1-K)\).
Let \(E_i\) be the event that the level-\(i\) grid separates the two slopes.
Then \(E_0\subseteq\cdots\subseteq E_{k-1}\) and
\(\mathbb P(E_i)=x/d_i\).
The boundary logarithm at transition \(i\) is precisely
\({\bf1}_{E_i\setminus E_{a(i)}}\log((h+H)/h)\).
It follows **exactly**, not by sampling, that
\[
 \mathbb E\sum_{i<k}R_i
   =x\sum_{i<k}(d_i^{-1}-d_{a(i)}^{-1})\log((h+H)/h).
 \tag{15}
\]
More fully, on the stratum \(E_j\setminus E_{j-1}\), \(1\le j<k\),
the sum is \(\min(k-j,K-1)\log((h+H)/h)\), and that stratum has measure
\(x(d_j^{-1}-d_{j-1}^{-1})\). On \(E_0\) and outside \(E_{k-1}\)
the sum is zero. This supplies a compressed exact translation partition,
including all its zero strata, without enumerating \(G^k\) cells.
For \(K=3\) and \(k\ge2\), the coefficient in (15) is
\((1+G^{-1}-2G^{-(k-1)})/32\); for \(k=0,1\) it is zero.
This is a test family, not a sharpness or novelty claim.

`Main.lean` certifies the arbitrary-depth algebraic and
finite-sum core, not the analytic top estimates or the geometry of the
Hilbert-transform model. Its exact declarations and hypotheses are
specified in `statement_fidelity.md`. The official Lean 4.31.0 run succeeded
with exit code zero and no proof holes; its archived certificate is attached
to `C_BOUNDARY_CORE` in the claim ledger. This does not certify statement
fidelity, which remains a separate independent-review question.

`verify.py` and `exact_certificate.json` provide exact rational replay of
the source-bound algebra, stopping endpoints, common-grid test instances,
and any retained Jacobian output. Finite instances are adversarial checks,
not the proof of the uniform theorem. Equations (2)-(14) above supply the
application and the measure-theoretic reasoning outside the formal core.
The bounded Jacobian LP request was rejected by its simplex-basis admission
limit (`INVALID_REQUEST`, adapter exit status 2). Its exact payload and
structured error are retained. This is a tooling non-conclusion. The
four-step diagnostic LP is separately certified by an explicit rational
primal/dual pair in `exact_certificate.json`; it is not evidence for
arbitrary depth.
An independent Reviewer must still assess that translation, the upstream
assumption boundaries, and significance. The full theorem and all other
load-bearing analytic lemmas remain unverified.

Replay the exact certificate from the campaign root with
`python3 research/boundary-loss/verify.py`. A fresh real Lean replay, when
needed, is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/boundary-loss/Main.lean --project-root . \
  --statement-fidelity research/boundary-loss/statement_fidelity.md \
  --claim C_BOUNDARY_CORE
```

The only results taken on trust in applying the packet theorem to the
manuscript are the explicit local manuscript inputs `A_TOP_INTERVAL` and
`A_MASS_CAP`. The finite Abel and geometric identities are standard
identities proved again here, not novelty claims or unchecked literature
citations. No external citation is needed for the stopped-potential proof.
