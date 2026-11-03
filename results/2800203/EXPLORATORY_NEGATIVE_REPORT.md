# Exploratory negative report: two frozen scalar-cavity boundaries

## Status and scope

This is a scoped exploratory negative result for
\(\operatorname{PC}(n,1/2,k)\) at
\[
  k=\left\lceil\frac{\sqrt n}{\log n}\right\rceil .
\]
It consolidates two exact, already reviewed route boundaries:

1. the collision-Gram-only positive-semidefinite/diagonal transfer mechanism
   cannot close; and
2. the complete score of one explicit reachable rooted-\(C_4\) schedule,
   stopped at depth three, cannot reach the required threshold
   candidate-list interface.

The underlying claims were reviewed in handoffs `f506fdcde0b3` and
`9cd6ef9a7f6e`. This aggregate report itself is submitted for a fresh,
Host-invoked independent review. It does **not** solve or refute the original
planted-clique recovery objective.

## Frozen model and candidate-list interface

Let \(S\) be the uniformly planted \(k\)-set, let every edge inside \(S\)
have signed value \(+1\), and let every other \(W_e\) be an independent
Rademacher sign. Put \(h=n^{-1/2}\). The frozen scalar cavity update is
\[
 \theta^{t+1}_{i\to j}
 =h\sum_{\ell\notin\{i,j\}}W_{i\ell}
   f_{n,t}(\theta^t_{\ell\to i}),\qquad
 \theta^{t+1}_i
 =h\sum_{\ell\ne i}W_{i\ell}
   f_{n,t}(\theta^t_{\ell\to i}),
\]
starting from all-one messages. The wider frozen grammar allows uniformly
bounded, uniformly Lipschitz, Gaussian-\(L^2\)-normalized scalar denoisers
and depth \(T_n\le C\log\log n\).

For the second subroute, the score is thresholded at an arbitrary
\(n\)-dependent real level:
\[
  T_\tau=\{i:\theta_i^3\ge \tau_n\}.
\]
The candidate-list interface requires, with probability \(1-o(1)\),
\[
 |T_\tau\cap S|=(1-o(1))k,\qquad
 |T_\tau|=o\!\left(\frac{k^2}{\log n}\right).
\tag{1}
\]
By exchangeability, (1) forces planted-root inclusion probability to tend
to one and nonplanted-root inclusion probability to tend to zero. Thus the
root-in/root-out inclusion gap must tend to one. This is the only
candidate-list implication used below. The stronger oracle score and its
cleanup interface are documented in
`research/routes/oracle-rooted-separation/oracle-rooted-separation.md`;
no oracle evaluation is used here.

## Frozen subroute A: collision-Gram-only transfer

### Definition

For root \(i\), recipient \(\ell\), \(e_\ell=\{i,\ell\}\), and incoming
full-edge Walsh coefficient field \(z_\ell\), define
\[
 B_i^\sigma(\ell,m)
 =\sum_{A,B}z_\ell(A)\overline{z_m(B)}
   \pi_{\sigma,i}\!\left(
   (A\mathbin\triangle e_\ell)\cup
   (B\mathbin\triangle e_m)\right),
\tag{2}
\]
where \(\sigma\in\{+,-\}\) denotes root-in or root-out conditioning and
\(\pi_{\sigma,i}(F)\) is the probability that all vertices of \(F\) lie in
the corresponding hidden set. Each \(B_i^\sigma\) is positive
semidefinite. The exact collision energy after the homogeneous outer update
and its recipient-diagonal scalarization are
\[
 {\cal O}_i^\sigma=h^2{\bf1}^*B_i^\sigma{\bf1},
 \qquad
 {\cal D}_i^\sigma=h^2\operatorname{tr}B_i^\sigma .
\tag{3}
\]

The frozen route
`R2800203-AMP-LOGLOG-COLLISION-GRAM-PSD-TRANSFER` sought a uniform
one-round nonlinear transfer through every admitted Lipschitz pullback,
with total loss closing through \(C\log\log n\), followed by a direct
moving-threshold comparison for atomic and zero-variance laws. It allowed
either separate positive-semidefinite control of \(B_i^+\) and \(B_i^-\),
or subtraction followed by diagonal scalar control of
\(B_i^\Delta=B_i^+-B_i^-\).

### Exact obstruction

Two reachable directions rule out those two Gram-only closures.

**Positive-semidefinite root-type domination fails.** In the reviewed
parity cascade, immediately before the third nonlinear pullback, the
root-out shifted block is exactly zero. The admitted denoiser then produces
the perturbation
\[
 {\cal T}_\ell\!\left(\alpha\delta_{e_\ell}\right)
 =\alpha\delta_\varnothing ,
 \qquad
 B^-_{\rm after}=\alpha^2{\bf1}{\bf1}^*\ne0 .
\tag{4}
\]
Consequently no finite uniform \(L\) can satisfy a positive-semidefinite
domination of the form
\[
 B^-\!\left(f(x)-\text{constant}\right)\preceq L B^-(x).
\tag{5}
\]
The same all-ones block occurs for the planted-root law, so
\(B^\Delta_{\rm after}=0\). Its score contribution is a common translation,
not root separation.

**Signed diagonal scalarization has a nonclosing loss.** For the reachable
rooted-\(C_4\) direction, put
\[
 \beta=12\delta c_1^3c_2h^{10},\qquad
 q=(k-2)(k-3),\qquad \delta=2^{-14}.
\]
The exact root-out block is zero, while the root-in block gives
\[
 \begin{aligned}
 {\cal D}_i^\Delta
 &=h^2\beta^2(k-1)(k-2)^2(k-3)^2,\\
 {\cal O}_i^\Delta
 &=h^2\beta^2(k-1)^2(k-2)^2(k-3)^2.
 \end{aligned}
\]
Hence
\[
 \boxed{\frac{{\cal O}_i^\Delta}{{\cal D}_i^\Delta}
 =k-1=(1+o(1))\frac{\sqrt n}{\log n}.}
\tag{6}
\]
Any diagonal replacement therefore incurs at least this factor, rather
than a loss that closes through the prescribed depth.

Equations (4)--(6) certify the first boundary: separate positive
root-type Gram domination is false, while differencing first destroys
positivity and leaves a signed coherence that cannot be charged to the
diagonal with a closing loss. Retaining the full recipient matrix makes
the homogeneous outer update exact, but this Gram state is not closed
under an arbitrary admitted nonlinear pullback.

Neither witness is a recovery signal. The parity root-law discrepancy is
\(O(1/\log n)\), and the rooted-\(C_4\) sector has normalized shift
\[
 \frac{3\binom{k-1}{3}}
 {\sqrt{3\binom{n-1}{3}}}
 =\frac{1+o(1)}{\sqrt2(\log n)^3}=o(1).
\tag{7}
\]

## Frozen subroute B: the complete rooted-\(C_4\) depth-three score

### Definition and admissibility

The explicit schedule uses \(f_{n,0}(1)=1\), \(\delta=2^{-14}\), and
\[
 \begin{aligned}
 \varphi_1(x)&=\operatorname{clip}_{[0,2]}(1+hx),&
 c_1&=\bigl({\mathbb E}\varphi_1(Z)^2\bigr)^{-1/2},&
 f_{n,1}&=c_1\varphi_1,\\
 R_n&=8/h,&
 \varphi_2(x)&=1+\delta h^3
   \operatorname{clip}_{[-R_n,R_n]}(x)^3,&
 c_2&=\bigl({\mathbb E}\varphi_2(Z)^2\bigr)^{-1/2},\\
 &&f_{n,2}&=c_2\varphi_2,
 \end{aligned}
\tag{8}
\]
where \(Z\sim N(0,1)\). The reviewed bounds
\[
 \frac12\le c_1<3,\qquad
 \frac{32}{33}\le c_2\le\frac{32}{31}
\]
show that these denoisers are uniformly \(8\)-bounded and
\(8\)-Lipschitz, with exact Gaussian \(L^2\) normalization and uniform
dyadic evaluators. The clips are inactive on every reached message value.
Thus (8) is an admitted, exact-real member of the frozen grammar.

The frozen route
`R2800203-AMP-LOGLOG-ROOTED-C4-DEPTH3-CANDIDATE` asks only whether the
complete score generated by (8), stopped at depth three and thresholded,
can satisfy (1). It does not quantify over later denoisers.

### Exact rooted-\(C_4\) coefficient

Every rooted four-cycle support \(C\) has the exact complete-support
coefficient
\[
 \boxed{a_i^3(C)=24\delta c_1^3c_2h^{11}
 =24\delta c_1^3c_2n^{-11/2}.}
\tag{9}
\]
There are \(3\binom{m-1}{3}\) such supports through a fixed root on \(m\)
vertices. For a planted root, precisely
\(3\binom{k-1}{3}\) planted cycles collide on the empty free support, all
with the same sign; for a nonplanted root, none do. The resulting exact
collision amplification over diagonal pre-substitution \(L^2\) energy is
\(\sqrt{3\binom{k-1}{3}}\). Equation (7) simultaneously shows why this
sector alone is not a candidate-list witness.

### Complete-score recurrence and atom-safe threshold bound

The negative conclusion is about the whole score, not a projected sector.
Define
\[
 U_{a;i}=\sum_{b\notin\{a,i\}}W_{ab},\qquad
 V_{a;i}=\sum_{\substack{b\notin\{a,i\}\\c\notin\{a,b\}}}
 W_{ab}W_{bc}.
\]
Then
\[
 \theta^2_{a\to i}=c_1h(U_{a;i}+h^2V_{a;i})
\]
and the complete third-layer score is exactly
\[
 \boxed{
 \theta_i^3=Y_i+R_i,\quad
 Y_i=c_2h\sum_{a\ne i}W_{ia},\quad
 R_i=\delta c_2h^4\sum_{a\ne i}
 W_{ia}(\theta^2_{a\to i})^3.}
\tag{10}
\]
For every fixed planted set, degree-two hypercontractivity and Minkowski's
inequality give
\[
 \|\theta^2_{a\to i}\|_6<33,\qquad
 \boxed{\|R_i\|_2
 \le\delta c_2\,33^3\frac{n-1}{n^2}=O(n^{-1}).}
\tag{11}
\]
No independence between \(R_i\) and \(Y_i\) is assumed.

Let
\[
 M_j=2^{-j}\binom{j}{\lfloor j/2\rfloor}.
\]
The affine degree laws are
\[
 Y_+=c_2h(k-1+S_{n-k}),\qquad
 Y_-=c_2hS_{n-1}.
\]
A half-lattice-spacing sandwich charges at most one binomial atom on each
side, while coupling
\(S_{n-1}=S_{n-k}+S'_{k-1}\) gives the exact degree-law total-variation
bound. Together with (11), uniformly over every moving threshold,
\[
 \boxed{
 \begin{aligned}
 \sup_x\bigl|
 \Pr(\theta_r^3\le x\mid r\in S)
 -\Pr(\theta_q^3\le x\mid q\notin S)
 \bigr|
 &\le
 \left(\frac{k-1}{2}+1\right)M_{n-k}+M_{n-1}\\
 &\quad+
 2\delta^2 33^6\frac{(n-1)^2}{n^3}\\
 &=O\!\left(\frac1{\log n}+\frac1{\sqrt n}\right)=o(1).
 \end{aligned}}
\tag{12}
\]
The same bound holds for upper-threshold events by taking left limits.
Equation (12) contradicts the inclusion gap forced by (1). Therefore the
complete reachable score (10), stopped at depth three, cannot produce the
required candidate list.

## Evidence and independent review

| Result | Symbolic source | Exact audit | Independent review |
|---|---|---|---|
| Arbitrary-depth full-support algebra and the rooted-\(C_4\) coefficient/collision | `research/routes/amp-loglog-complete-support-transfer/complete-support-transfer.md` | `research/routes/amp-loglog-complete-support-transfer/complete-support-transfer-certificate.json` | `/home/argustest/zimo/.argus-campaign-2800203-run2/projects/0631facaf2e1/handoffs/f506fdcde0b3/round-0001.json` |
| Collision-Gram obstruction and complete depth-three CDF boundary | `research/routes/amp-loglog-collision-gram-transfer/collision-gram-transfer.md` | `research/routes/amp-loglog-collision-gram-transfer/collision-gram-transfer-certificate.json` | `/home/argustest/zimo/.argus-campaign-2800203-run2/projects/0631facaf2e1/handoffs/9cd6ef9a7f6e/round-0002.json` |
| Three-bit Walsh audit | `research/routes/amp-loglog-complete-support-transfer/jacobian-walsh-payload.json` | `research/routes/amp-loglog-complete-support-transfer/jacobian-walsh-output.json` | Covered by `f506fdcde0b3` |
| Exact \(n=8,k=4\) Gram contraction | `research/routes/amp-loglog-collision-gram-transfer/jacobian-c4-rayleigh-payload.json` | `research/routes/amp-loglog-collision-gram-transfer/jacobian-c4-rayleigh-output.json` | Covered by `9cd6ef9a7f6e` |

The `f506fdcde0b3` Reviewer verified the arbitrary-depth Lagrange-XOR
operator, the 24 equal-sign rooted-\(C_4\) histories, the planted collision
count, and (7), while correctly leaving Gram transfer and atom-safe
threshold control open. The later `9cd6ef9a7f6e` Reviewer accepted the exact
complete-score decomposition, the uniform \(L^2\) remainder bound, and the
half-lattice CDF argument, and closed only the bounded collision-Gram
mechanism mission. The ledger records these statements as
`C2800203-AMP-LOGLOG-COLLISION-GRAM-BLOCK-OBSTRUCTION` and
`C2800203-AMP-LOGLOG-ROOTED-C4-FULL-SCORE-CDF`.

The finite certificates audit combinatorial bookkeeping and exact rational
instances. The arbitrary-\(n\) conclusions are the symbolic derivations in
the two Markdown sources; no finite cutoff or numerical trend is used as a
proof.

## Exact reruns

Run from the campaign root. These are the preserved commands from the
reviewed artifacts.

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/amp-loglog-complete-support-transfer/complete_support_transfer_check.py \
  --output \
  research/routes/amp-loglog-complete-support-transfer/complete-support-transfer-certificate.json

/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/amp-loglog-collision-gram-transfer/collision_gram_transfer_check.py \
  --output \
  research/routes/amp-loglog-collision-gram-transfer/collision-gram-transfer-certificate.json
```

The first checker returns `"result": "pass"`. The second returns
`"status": "exact_gram_obstruction_and_depth3_cdf_boundary"` and audits the
Gram matrices, parity null-to-all-ones transition, complete-score
recurrence, and finite exact CDF bounds.

The two preserved Jacobian operations are:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.tools.jacobian run \
  --operation boolean.fourier.walsh_transform.compute \
  --payload-file \
  research/routes/amp-loglog-complete-support-transfer/jacobian-walsh-payload.json

/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.tools.jacobian run \
  --operation quadratic_form.evaluate.compute \
  --payload-file \
  research/routes/amp-loglog-collision-gram-transfer/jacobian-c4-rayleigh-payload.json
```

Under preserved protocol `2025-11-25` and Jacobian server `0.14.0`, the
first operation returns the typed Walsh spectrum
\((0,0,0,0,0,0,0,8)\). The second returns the exact rational all-ones
contraction \(9\) for the normalized \(n=8,k=4\) block; its trace is \(3\),
so the audited quotient is \(3=k-1\). These bounded operations audit exact
instances and are not substitutes for the symbolic proofs.

## Prominent non-claims

This report makes **none** of the following claims:

- It does not control arbitrary later denoisers after the depth-three score.
- It does not rule out a direct signed cancellation recurrence with state
  beyond the collision Gram block.
- It does not exhaust the complete frozen scalar cavity grammar or prove
  its moving-threshold discrepancy is always \(o(1)\).
- It does not construct or rule out a polynomial-time evaluator for the
  transition-scale oracle score.
- It does not construct a cleanup-qualified candidate list.
- It does not prove or disprove planted-clique recovery below
  \(\sqrt n\), and it does not solve the campaign's original recovery
  objective.

The certified negative content is exactly the two frozen boundaries stated
at the start.
