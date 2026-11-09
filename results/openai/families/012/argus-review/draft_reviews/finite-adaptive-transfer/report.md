# Finite adaptive transfer: two different expectation statements

## Assessment

The **additive expectation bound in the old ledger and the probability
bound (4) are supported by the prose argument**, under exactly the hypotheses
below. The displayed expectation equation (3) is a different statement and
**is not established by that argument**. This assessment supplies neither a
counterexample to the printed inequality nor a proof of it. It identifies the
precise missing inference; it does not refute the original manuscript.

This is an Engineer mathematical reading, pending the Host-invoked independent
Reviewer. The probability argument is not Lean-verified. No novelty or
independent arithmetic theorem is claimed.

## Source, versions, attribution and hypotheses

The source is read-only campaign `9000012`,
`research/adaptive-cut-transfer/report.md`, Theorem 1, definitions (2) and
equations (3)-(12). Its bytes agree with the existing preserved manifest
dated `2026-11-06T10:20Z`. The old ledger's
`C_ADAPTIVE_TRANSFER v1`, five `L_CUT_* v1` obligations, and
`R_ADAPTIVE_FINITE` describe this one argument. They are not six independent
results. The old Engineer and Reviewer judgments are historical opinions,
not this review's acceptance.

The quantitative theorem is an old Argus proposed refinement of the sampling
argument in the unpublished September 24, 2026 manuscript. The manuscript's
`sampling.tex`, Proposition `prop:sampling-comparison`, states a qualitative
conditional conclusion; it is not the source of the mismatched numbered
equation (3) in the Argus report.

For completeness, the theorem's exact setting is:

* An integer \(M\ge2\) and independent finite-valued sites \(S_1,\ldots,S_M\),
  with possibly distinct laws.
* Real endpoint kernels \(E_{ik}(u,v)=E_{ki}(v,u)\) and nonnegative symmetric
  envelopes \(H_{ik}(u,v)=H_{ki}(v,u)\), both deterministically zero on the
  diagonal, with \(|E_{ik}|\le H_{ik}\). Nonallowed pairs may also be zero.
* Nonnegative constants \(C_0,q,\beta\) with
  \[
  \sum_k\mathbb E_{S_k}H_{ik}(u,S_k)\le C_0\quad\text{for every }i,u,
  \qquad
  \sum_k\mathbb E H_{ik}(S_i,S_k)^2\le q\quad\text{for every }i.
  \]
  The first is every-type conditional first-moment control; the second
  integrates **both** endpoints, not a uniform conditional second moment.
* For every separate pair of real single-site test families bounded by one,
  including tests zero on any removed indices,
  \[
  M^{-1}\left|\sum_{i,k}\mathbb E
       [E_{ik}(S_i,S_k)g_i(S_i)h_k(S_k)]\right|\le\beta .
  \]

Put \(C=M^{-1}\max_{\epsilon,\delta\in\{-1,1\}^M}
|\sum_{i,k}E_{ik}\epsilon_i\delta_k|\) and
\(Q=M^{-1}\sum_{i,k}E_{ik}^2\). This is the manuscript's \(1/M\)
normalization, not \(1/M^2\). The scalar \(\delta\) in the next display is
a tail parameter, not the column-sign vector.

For integers \(1\le m<M\), \(d>C_0\), \(0<\delta<1\), require
\[
 p=\frac{Mq}{(d-C_0)^2}<1,\quad
 N=\binom Mm2^m,\quad
 a=\sqrt{\frac{8d^2}{M}\log(N/\delta)},\quad
 L=\frac{\beta+\sqrt q+a+1}{1-p},\quad b=\beta+\sqrt q+Lp.
\]
There is no entrywise upper bound on the kernels and no hypothesis that
the adaptive signs are independent of the sites.

## The equation (3)/ledger discrepancy

Let \(D=2md/M\), \(T=\sqrt{(C_0^2+q)(p+\delta)}\), and
\(G=b+a+2\sqrt{Mq/m}\). The two original statements are:

| Original location | Exact expectation assertion |
|---|---|
| Old report, displayed equation (3) | \(\mathbb EC\le G+DT\) |
| Old `MATH_STATE.json`, `C_ADAPTIVE_TRANSFER v1` | \(\mathbb EC\le G+D+T\) |

These are not equivalent, and their right sides are not globally ordered
for arbitrary nonnegative \(D,T\). In the manuscript specialization both
tend to zero, so the printed product is smaller than the additive remainder
eventually. No hypothesis of Theorem 1 permits replacing \(D+T\) by \(DT\).

The proof gives a common event \(\mathcal B\) with
\(\mathbb P(\mathcal B)\le p+\delta\). On its complement,
\[
 C\le b+a+2\sqrt{MQ/m}+D .
\]
On \(\mathcal B\), it uses \(C\le A=M^{-1}\sum_{i,k}|E_{ik}|\) and
\(\mathbb EA^2\le C_0^2+q\). Therefore the actual integration is
\[
\begin{aligned}
 \mathbb EC
 &\le (b+a+D)\mathbb P(\mathcal B^c)
       +2\sqrt{M/m}\,\mathbb E[\sqrt Q\,1_{\mathcal B^c}]
       +\mathbb E[A1_{\mathcal B}]\\
 &\le b+a+2\sqrt{Mq/m}
             +\frac{2md}{M}+\sqrt{(C_0^2+q)(p+\delta)} .
\end{aligned}
\]
The deletion error is paid on the good event, and the absolute-mass error
is paid on the bad event. They **add**; neither multiplies the other.
This proves precisely the ledger formula. The old proof's sentence
“This proves (3)” is an invalid inference for its literal displayed (3).

An algebraic mismatch is not itself a counterexample to an inequality.
The honest residual obligation for the printed formula is a separate
valid derivation under the same hypotheses, or an exact violating model.
Neither is supplied in the old sources or claimed here. A source correction
to the additive ledger formula would resolve the mismatch, but the old
sources were not edited.

## Checking the five decisive obligations

### L_CUT_DEGREE: supported

For \(D_i=\sum_kH_{ik}\), condition on \(S_i\). The off-diagonal terms
are independent because the other sites are independent and the diagonal
is deterministic zero. The hypotheses give
\[
 \mathbb E\operatorname{Var}(D_i\mid S_i)\le q,\quad
 \mathbb ED_i^2\le C_0^2+q,\quad
 \mathbb P(D_i>d)\le q/(d-C_0)^2.
\]
One union over at most \(M\) rows costs \(p\). Jensen across rows, which
does not require row independence, gives
\(\mathbb EA^2\le C_0^2+q\); domination gives \(\mathbb EQ\le q\).
Deleting indices decreases nonnegative row masses and integrated square
sums. Conditioning on fixed outside types leaves the induced sites'
original product law. Thus the same induced-degree failure bound holds
uniformly, without a conditional second-moment premise.

### L_CUT_SKELETON: supported

For a fixed realized matrix, choose maximizing column signs and put
\(r_i=\sum_kE_{ik}\delta_k\). Then \(MC=\sum_i|r_i|\). Uniform sampling
of a size-\(m\) subset gives, for any deterministic real vector \(x\),
\[
 \operatorname{Var}\left(\frac M m\sum_{j\in J}x_j\right)
 =\frac{M-m}{m(M-1)}
       \left(M\sum_jx_j^2-\left(\sum_jx_j\right)^2\right)
 \le\frac M m\sum_jx_j^2 .
\]
This follows from the one- and two-index inclusion probabilities; it is
not an iid-column assertion. The scalar inequality
\(|r|-r\operatorname{sgn}(\widehat r)\le2|r-\widehat r|\),
with sign \(+1\) at zero, and Cauchy--Schwarz give expected total loss
at most \(2M\sqrt{MQ/m}\). Some subset attains that bound.

On the full degree-good event, symmetry bounds the mass of all ordered
pairs incident to \(J\) by \(2md\). Removing them and optimizing the
remaining column signs gives the report's (7),
\(C\le Z+2\sqrt{MQ/m}+D\). The optimizing subset/signs may depend on
the full realization; this is a deterministic existence argument, not
probabilistic conditioning on their selection.

The fresh deterministic Lean replay supports the response and deletion
inequalities here. It does not formalize the sampling variance or the
probabilistic existence argument.

### L_CUT_FIXED_MEAN: supported

Fix \(J\), its signs, and its types before drawing the remaining sites.
Then \(g_i(u)=\operatorname{sgn}\sum_{j\in J}E_{ij}(u,t_j)\sigma_j\)
is a fixed function of one site. For each remaining column \(k\), define
the conditional mean \(a_k(v)\) as in the old (8). Choosing
\(h_k(v)=\operatorname{sgn}a_k(v)\) and zero tests outside the remainder
bounds \(M^{-1}\sum_k\mathbb E|a_k(S_k)|\) by \(\beta\).

Conditional on \(S_k\), the centered remaining column summands are
independent. Averaging their variances before Cauchy--Schwarz and using
symmetry yields at most \(\sqrt q\) error per column. Hence
\(\mathbb E[Z\mid\mathbf S_J=\mathbf t]\le\beta+\sqrt q\).
For probability-zero frozen type assignments this means the same
explicit product-law construction, not an undefined conditional ratio.
No union over type assignments is necessary.

### L_CUT_EXTENSION: supported

For arbitrary two induced-good configurations differing at positions
\(I\), only ordered pairs incident to \(I\) can change, including the
change in the single-site row signs. The separate endpoint row/column
masses give \(|Z(u)-Z(v)|\le4d|I|/M\).
The formal core certifies the required arbitrary-endpoint array
inequality. No path of intermediate good configurations is assumed.

The finite good set is nonempty because \(p<1\).
For \(c=4d/M\), the capped infimum extension of
\(\min(Z,L)\) is nonnegative, bounded by \(L\), \(c\)-Lipschitz on the
entire product space, and agrees with \(\min(Z,L)\) on that good set.
These facts follow directly from the triangle inequality and choosing the
same point in the infimum. Its conditional mean is at most \(b\).
Crucially \(b+a=L-1<L\), so capping does not change the relevant good-set
threshold event.

Revealing independent sites makes each Doob increment have conditional
range length at most \(c\). The old proof gives the elementary log-mgf
bound \(\lambda^2c^2/8\) by bounding the exponentially tilted variance
by \(c^2/4\). Iteration and exponential Markov yield
\[
 \mathbb P(F>b+a\mid\mathbf t)
 \le \exp(-2a^2/(|R|c^2))
 \le \exp(-a^2M/(8d^2))=\delta/N .
\]
Thus no unread external concentration theorem is needed for this
particular prose proof.

### L_CUT_UNION: supported with additive expectation bookkeeping

There are exactly \(\binom Mm2^m\) deterministic subset/sign
assignments. Integrate each extension tail over its frozen subset types
and union those \(N\) tails. The single full degree-good event implies
every induced good event, so its failure is charged once, not \(N\)
times. This gives the common event used above with probability bound
\(p+\delta\).

Adding the event \(Q>t\), whose probability is at most \(q/t\), proves
the original probability statement for every \(t>0\):
\[
 \mathbb P\!\left(C>b+a+2\sqrt{Mt/m}+2md/M\right)
       \le p+q/t+\delta .
\]
For expectation, retaining the square mass and using
\(\mathbb E\sqrt Q\le\sqrt q\) yields the **additive** formula.
It does not yield the printed product formula.

## Evidence classes, assumptions and unresolved scope

The above is a universal finite-parameter **prose proof assessment** of the
ledger statement and probability bound, not a finite experiment promoted
to a theorem or a fully formal probability proof.

Relevant replays are reused from the other units:
`../finite-cut-core/replay/lean_check.json` and its certificate record a
real Lean 4.31.0 successful compile/audit without holes;
`../finite-models-shortcuts/finite_replay/comparison.json` records equality
of all seven finite result fields. Those replays cover their explicitly
bounded scopes and were not redundantly rerun here. In particular the
old huge-\(B\) nonvacuity check budgets deletion and exceptional mass
**additively**, so it is not a test of displayed (3).

No unproved arithmetic or graphon theorem is used in this abstract
derivation. Its three mathematical assumptions H1-H3 must still be
established when the theorem is applied. The model-law independence
cannot be imposed on actual consecutive-integer residue sites.
Conditioning on a realized optimizer and upgrading integrated second
moments to every-type second moments are separately retired shortcuts,
with concrete examples in `../finite-models-shortcuts/report.md`.

The outstanding mathematical issue within this unit is the literal
printed expectation formula. The surrounding arithmetic, asymptotic
specialization, actual/model comparison and joint law are assessed in
other units. The absent active proof graph is a distinct workflow
blocker, not a mathematical counterexample. Native independent review
of all these assessments remains required.
