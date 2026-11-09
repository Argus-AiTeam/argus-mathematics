# Remaining first joins: Engineer assessment

**Disposition:** the consolidated v5 argument supports the stated **conditional analytic estimate**, including its mass-sensitive oriented mixed bound. This is a mathematical reading of the proof, not a kernel proof, a new manuscript-error search, or native independent acceptance. No concrete in-scope unsupported implication was identified in the argument described below. Construction of the stipulated data and histories remains outside this result.

## 1. Claim, versions, attribution, and hypotheses

The read-only draft is `9000022/research/remaining-first-joins/report.md` (34,594 inventory bytes), with `verify.py` and `exact_certificate.json`. Paths prefixed `9000022/` are relative to `campaigns/`. Exact ledger-version pointers, evidence subjects, and duplicate representations are in `research/DRAFT_REVIEW_INDEX.json`. The comparison manuscript is *The weak inhomogeneous Duffin-Schaeffer conjecture*, September 25, 2026, pinned by `MANUSCRIPTS.json` to revision **`4eaee87548250b2682affda7d05d947c05554bae`**. The existing source and snapshot binding results are reused; no manifest was rebuilt.

The strongest assertion, **C_RFJ_QUANT v5**, is

\[
 Q_{\rm broad}+Q_{\rm narrow}\ll_{k_0}W^{201/200}.
 \tag{R1}
\]

Broad counts use the product of the two outer mask laws, fixed distance constant \(C\), and width weight \(r_{\min}\). Narrow counts are exact same-width, same-remaining-mask comparisons in one new cell, with **one** common law coefficient. Adjacent simultaneous-birth comparisons, including the direct newborn self/diagonal terms, are excluded. Both counts are at the pair's first-sharing epoch. Constants may depend on the fixed hierarchy and \(k_0\), not on the finite block, its tail position, the realized history, \(W\), or the slot cap \(N_0\).

The assertion is conditional on precisely these data:

* Centre objects \((L_i,r_i,b_i)\), with \(b_i=B_i^*\) an integer shell, \(B_i\le b_i<2B_i\), exact dyadic widths, and at most one object per \((L,r,b)\). Original assigned rows are disjoint between objects. Write \(k_i=L_ir_i\), \(\delta_i=\sum_{v\text{ assigned}}\phi(v)/L_i\), \(m_i=k_i\delta_i\), and \(\sum_i m_i\le W\le1\). These are not updated or surviving table masses.
* Assignment by the manuscript's minimum-cost rule, retained density cutoff \(\delta_i\ge e^{-8b_i/25}\), one retained type and separated band colour, and the stated high/medium starts and sparse-bin conditions.
* Good assigned masks: the excess-prime-power bound; divisor-count bound \(e^{s'B_i}\) on initial segments of reciprocal sum at most \(s_{\rm low}B_i\); and \(\sum_{p\mid d,\ p>d_0B_i}(\log p)^{3/10}/p\le1\). The high-type dense-bin condition remains part of the stipulated source data. Adaptive tail deficits are squarefree.
* The actual core-equivariant operations, nonnegative raw weights, actual matching row/column capacities and complete after-prime mask preservation, same-location projections, increasing component chronology, preliminary tests, and admissible finite histories. Same-cell span bounds are stipulated, not constructed here: `tables.tex:170-175` bounds separation by \(O(r_i e^{-E_gB_i})\) when measured at either endpoint.

The proof reproduces and quantifies `joins.tex:join:remaining-first-joins`, its endpoint and roundoff arguments, and the elementary tensor argument in `preliminaries.tex:ar:pivot, ar:tensor`. The additional proposed strengthening is to retain \(W\) in the smaller-band object count, changing the oriented mixed error from the manuscript's \(O(W)\) to \(O(W^2)\). It is a logical strengthening at the stipulated interface level; **publication novelty and significance have not been established**. BHV14 and BHV18 are attributed background, not premises.

## 2. The claimed retirement of IN_CENTRES

The three input assumptions were recorded in the active ledger before this assessment. Their historical retirement at v5 was not taken as evidence by itself.

Let \(F(c)=10c_++(-c)_+\). The assignment cost is \(b+10a+F(c)\), with \(b>0,a\ge0\), and \(\log k=-b+a+c\). Both \(-\log k\) and \(10\log k\) are bounded by that cost. Consequently

\[
 k_i\ge e^{-b_i-1},\quad
 m_i\ge e^{-1}e^{-33b_i/25},\quad
 \delta_i^{-1}\le e^{16B_i/25}.
 \tag{R2}
\]

The density inequality is the retention hypothesis, not a newly proved retention theorem. The scale inequalities follow from the minimum-cost definition; no lower bound for adaptive surviving masses is substituted. Consolidation by \((L,r,b)\) and partition of the original assigned rows give uniqueness and disjoint mass accounting (`centres.tex:175-225,286-324`).

Using any source of object \(i\) as a candidate for an assigned row \(v\) of object \(j\), subadditivity of \(F\) gives the draft's cost bound

\[
 b_i+1+10\log\frac v{(v,L_i)}
 +10\log\frac{r_j}{r_{\min}}+\log^+\frac{r_i}{r_j}.
\]

If both exterior alternatives failed, this would be at most \(b_i+1+.85b_j<b_j\), for the stipulated sufficiently small band ratio and sufficiently large shells, contradicting minimality. Thus, for that actual row,

\[
 \frac v{(v,L_i)}\frac{r_j}{r_{\min}}>e^{3b_j/200}
 \quad\text{or}\quad \log(r_i/r_j)>.7b_j.
 \tag{R3}
\]

The remaining-pair classification also uses actual source conditions, not mask independence. Two old endpoints in distinct children at the previous height are distant. Untreated newborn-newborn pairs are nonadjacent and distant. In the nondistant old-newborn case, prime-exponent agreement at large bins excludes a high newborn and excludes an old centre in the same or a larger retained band. A shared dense bin above \(\ell B_j\) would contradict the old medium centre's last dense height. Hence the newborn starts at \(Y=A_0B_j\), the old band satisfies \(B_i/B_j\le\theta\), and

\[
 \Sigma=\sum_{\substack{p\mid L_iL_j\\\log\log p<Y}}\frac1p
 \le s_{\rm low}B_j.
 \tag{R4}
\]

This agrees with `joins.tex:47-107` and `centres.tex:392-416`. For charged pairs, apply classification to the **image** pair. Earlier-component transport keeps an old endpoint in its old child and leaves a newborn static; BC preserves first-sharing epoch. An image which is distant is counted as distant, not assumed to remain mixed.

These are sufficient centre interfaces for this estimate. They do not prove that the manuscript's preliminary selections retain a fixed mass fraction or that every construction input exists.

## 3. The claimed retirement of IN_FIELDS

At an actual full adaptive prime, with preweight \(w>0\), link masses \(m_\xi\), unpaired part \(u=w-\sum m_\xi\), and success indicators \(I_\xi\), the multiplier is

\[
 1-\sum_\xi(m_\xi/w)I_\xi-u/(pw).
 \tag{R5}
\]

Actual orbit invariance fixes the coefficients and positive-prefix condition, and each individual \(I_\xi\) has mean \(1/p\). Therefore the multiplier has mean \(R_p=1-1/p\), without independence between successes. The explicit \(R_p\) extension on unavailable/zero-prefix orbits is legitimate because those are invariant orbits with no actual positive weight. Earlier fields are invariant on the orbit; later omissions at other primes preserve it. Reverse orbit averaging proves product means for every selected subset. Dropping extra birth filters and discard fractions is an upper replacement after static-anchor averaging, keeping the **same actual** adaptive multipliers; it does not recompute matching for auxiliary anchors.

The post-\(p\) core retains unprocessed prime powers. Periods of fields through \(p\) have prime support at most \(p\), divide the projected denominator, and are bounded by \(L_i/\mathrm{core}_p\le e^{C_{\rm per}p}\). The source's core reduction is \(4+\lfloor CX/\log l\rfloor\) at passed primes, where \(X=e^{2h_HY}\). Above \(e^{O(X)}\), each reduction cost is \(O(\log l)\); below it the total is \(e^{O(X)}\). The elementary binomial prime-log bound gives

\[
 \log(L_i/\mathrm{core}_p)
 \ll e^{h_*Y/10}+p+e^{O(X)}\ll p,
\]

since \(\log p\ge e^Y\), \(2h_H<1\), and the starting bands are sufficiently large. None of these terms counts slots or matching labels (`tables.tex:97-146,737-761,838-908`).

The component-path bound is consistent with the mass and parameter hypotheses rather than an \(N_0\) bound: at height \(Y\), eligible bands have \(B_i\le Y/A_0\); (R2) and \(\sum m_i\le1\) bound their number by \(e^{1+(66/25)Y/A_0}\). A spanning tree has at most that many edges of log-cost \(O(\beta Y)\). Enlarging the fixed \(A_0\) as stipulated, and choosing the minimum band last, absorbs this in the stated \(e^{h_*Y/10}\) budget.

For periods \(D_1\mid v,D_2\mid w\), determinant-cycle averaging has period dividing \(P=D_1D_2\) and independent residue mean \(\mu\). A Bezout increment of \(P\) preserves the residues; averaging a full determinant period enumerates all numerator-residue pairs. Nonnegativity bounds each incomplete end period by \(P\mu\). Thus the error is \(O(P\mu)\), not a support-size error, also on progressions coprime to \(P\) (`preliminaries.tex:278-308`). Choosing \(\rho\) after \(C_{\rm per}\) makes \(P\le e^{\epsilon H}\).

This reconstructs the needed one-sided interface **under the structural operation hypotheses**. It is not a proof of partition existence or of all virtual-marginal conclusions.

## 4. Local algebra, endpoint restoration, and currencies

For an unrestricted deficit coordinate \(a\) at \(p^\nu\parallel L\), probabilities are \(R_pp^{-a}\) for \(a<\nu\), and \(p^{-\nu}\) at \(a=\nu\). They sum to one and give \(\Pr(a\ge1)=1/p\). The identity \(R_{\rm done}(L/d)/d=\pi_{\rm done}(d)\) restores the original first-mass law, including exhausted prime powers.

At common high static primes, coincident exclusions have relative density \(1/R_p\le1+2/p\), and distinct exclusions have density \((1-2/p)/R_p^2\le1\). Expansion over squarefree coincidence moduli gives a bounded main product \(\prod(1+2/p^2)\), and a roundoff product at most \(e^{2\Sigma}\). The low period and high congruence moduli are coprime. The source range separation explains why unread high static factors are not combined with genuinely adaptive low companions.

For continuing main terms, let \(A_i(a)\) be the assigned processed probability at outer mask \(a\). Then \(A_i\le1\), \(\mathbb EA_i\le\delta_i\). Independent outer laws give \(\delta_i\delta_j\). With a common law only \(\mathbb E(A_iA_j)\le\min(\delta_i,\delta_j)\) is used. The same-cell span at both endpoints gives \(S\ll e^{-E_g\max(B_i,B_j)}\); \(E_g\ge2\) and (R2) absorb the missing density. The common probability is never squared.

At a bad-omission stop, dropping one assignment produces \(1/p\), even at a fixed outer mask. The two good-mask/centre controls give

\[
 \sum \frac{e^{8\kappa Y_p}}p\ll_\rho e^{-A_0B_i/4}.
\]

Indeed factor \((\log p)^{8\kappa-1}\) from the \(UT\) log-weighted sum, or \((\log p)^{8\kappa-3/10}\) from the partner's good-mask sum. With \(\kappa\le1/320\), both have more than the required decay. \(A_0/4>16/25\) pays the dropped assignment density while retaining the other assignment.

For linked main terms, reuse only the assessed BC mechanism: reciprocal later omissions on the widened original-minus tuples, actual plus capacities, complete outer currency, and unique first epoch. The product of restricted-grid cycle size and interval length is

\[
 k_{L'}k_{M'}/(p^2d'e').
\]

Restoring ordinary factors costs at most \(e^{12Y_p+6}\) per mapped side. The mapped processed law has forced deficit exactly one at \(p\), of probability at most \(1/p\); a static partner retains its assignment and contributes at most \(2A_j(a)/p\). Hence there are **two** powers of \(p\) in the main probability saving, in either currency. Mapped density restoration costs at most \(e^{32Y_p/(25A_0)}\), and

\[
 \sum_p e^{(24+32/(25A_0))Y_p}/p^2
 \le\sum_{n\ge2}(\log n)^{25}/n^2<\infty.
\]

The explicit elementary bound \(2^{26}25!\) follows by comparison with \(n^{-3/2}\). For image cutoffs, \(H'\le H+p\) at sufficiently large onset, and \(q=\rho/[4(1+\rho)]\) gives \(qH'<p\). The smaller \(d_0<q/2\) and good image rows justify restoration for the changed centres; the old cutoff is not silently reused.

For roundoffs no \(e^{24Y_p}\) main-restoration cost is introduced. At local centre exponents \(m+h,m\), \(x=1/p\), the unrestricted positive extension is

\[
 F_h(x)=\sum_{a,b\ge0}2^{[a>0]+[b>0]}
 p^{\min(a,h+b)-a-b}
 =\frac{(2h+1)+6x+(1-2h)x^2}{(1-x)^2}.
\]

Finite exponent limits only decrease this sum. The factorizations

\[
 (1+32x-F_0)(1-x)^2=8x(1-2x)(3-2x),\quad
 ((2h+1)F_0-F_h)(1-x)^2=4hx(3+x)
\]

and \((h+1)^2\ge2h+1\) are nonnegative for \(0\le x\le1/2,h\ge0\). They prove the universal local bound, not just its finite tests:

\[
 \sum_{d,e}2^{\omega(d)+\omega(e)}
 \frac{(Td,Ue)}{de}\le\tau(UT)^2e^{32\Sigma}.
\]

Later-mask and stopping-prime sums fit within the draft's deliberately loose absolute coefficient 64, yielding

\[
 C\Theta\tau(UT)^2e^{\epsilon H+64\Sigma}.
 \tag{R6}
\]

For the mixed relative version, fix the actual newborn mask \(c_j\), set \(W'=M/c_j\) and \(E_{\rm ext}=W'/(W',L)\). Splitting the old local deficit at its free allowance \(t=n-(m-c)\) and summing the geometric tail gives

\[
 \sum_d2^{\omega(d)}\frac{(W',L/d)}{W'}
 \le E_{\rm ext}^{-1}\tau(U)^2\tau(c_j)^2e^{4\Sigma}.
\]

The fixed partner omega allowance costs \(\tau(c_j)\). After division by the **original** newborn first mass, the error is bounded by

\[
 Ce^{\epsilon H+64\Sigma}\frac{r_{\min}}{r_j}
 E_{\rm ext}^{-1}\tau(U)^2\tau(c_j)^3.
 \tag{R7}
\]

A linked mixed newborn is static; dividing both counted denominators by the same full \(p\) divides their gcd by \(p\) and leaves the exterior ratio unchanged. Relative to the original newborn mass it adds \(1/p\), already covered in (R6)-(R7). Every true assigned row \(v\) divides \(W'\), so (R3) applies to that row. This is not a fictitious newly assigned denominator.

## 5. The claimed retirement of IN_TENSOR and universal summation

The one-coordinate argument in draft Section 7 is sufficient for the required tensor inequality. Here is why the concentration step is uniform in support size. For probability vectors \(\alpha,\beta\), the off-diagonal \(q^{|a-b|}\) kernel has \(\ell^2\) operator norm \(O(q)\), while \(\|\alpha^u\|_2,\|\beta^u\|_2\le1\). If its full quadratic sum is at least one, the diagonal sum is \(1-O(q)\); \(\sum\alpha^{2u}\le(\max\alpha)^{2u-1}\) forces dominant atoms of mass \(1-O_u(q)\). Their indices must agree: otherwise the actual diagonal sum tends to zero, contradicting the preceding lower bound.

At the common index, let \(d\) be total off-atom mass. The central contribution is at most \(1-c_ud\), the double-off part is \(O_u(d^{2u})\), and Holder with the geometric kernel bounds the single-off part by \(O_u(qd^u)\), independently of the number of atoms. For sufficiently small \(q\), absorb \(d^{2u}\), since \(2u>1\). Optimizing \(-cd+Cqd^u\) gives excess \(O_u(q^{1/(1-u)})\). Totals below one already satisfy the bound; finitely many larger prime-coordinate \(q\)'s use the finite convolution norm.

Slice by one prime exponent, apply this bound to slice totals, and iterate. For \(q=p^{-s}\) the product of one-prime constants converges when \(s/(1-u)>1\). Therefore, for finite nonnegative sequences,

\[
 \sum_{L,M}\frac{(x_Ly_M)^u}
 {(LM/(L,M)^2)^s}
 \le C_{u,s}\left(\sum x_L\sum y_M\right)^u,
 \quad \tfrac12<u<1,\quad s>1-u.
 \tag{R8}
\]

No unproved external gcd-sum theorem is needed. This is a reproduction of the pertinent elementary argument in the pinned `preliminaries.tex`, not a novelty claim.

At fixed shells and exact dyadic widths there is no repeated \((L,r)\). Apply (R8), then the summable width kernel \(2^{-\lambda|k-l|}\); its \(\ell^2\) bound and \(\sum M_r^{2u}\le(\sum M_r)^{2u}\) give \(CW^{2u}\) per shell pair. Thus neither width support size nor history size enters the constant.

The elementary prime-harmonic estimate gives \(\Sigma\le3(Y+1)\); the divisor estimate \(\tau(n)^D\le C_{D,\delta}n^\delta\) follows by treating large primes geometrically and finitely many small primes separately. Both are proved in the draft; no asymptotic prime-number or literature premise is hidden here.

The centre conversion is

\[
 \Theta\le C(m_im_j)^u(UT)^{-1/2}
 (r_{\min}/r_{\max})^{1/2}
 e^{[4/25+(33/25)(u-1/2)](b_i+b_j)}.
\]

For distant pairs, \(u=3/4,s=3/8\) leave tensor gap \(1/8\). The distant separation pays harmonic/period costs and leaves \(e^{-Y}\) and a positive width power. Summing \(O((Y+1)^2)\) shell pairs over dyadic heights gives \(O_{k_0}(W^{3/2})\).

For width-separated mixed pairs, \(u=201/400,s=399/800\) leave gap \(1/800\). Reserve width power \(1/8\); the other \(3/8\) pays conversion costs and leaves shell saving \(e^{-b_j/20}\). The exact remaining margin is \(18817/1000000>0\). The summable shell series is \(\sum_t(t+1)e^{-t/20}\); hence the bound is \(O_{k_0}(W^{201/200})\).

The parameter certificate is genuinely symbolic, not a single feasible point: \(D=64+d,\ A_0=8+a,\ \beta=64(3D+3)+b\), for all \(d,a,b\ge0\). After clearing positive denominators, all coefficients of each of eight margin numerators/denominators are nonnegative, with positive constants. Source-required dyadic geometric choices form an admissible subfamily. Decreasing the small parameters preserves the inequalities.

The dependency order is viable: fix the absolute harmonic coefficient and geometry, enlarge \(A_0\), choose the small exponents, \(s'\), occupancy/moment parameters, \(D_0\), and colour separation, then the remaining fixed models/localization constants. Choose \(\rho\) after \(C_{\rm per}\), \(d_0\) after the image cutoff, and \(k_0\) last. `prescriptions.tex:65-93` confirms that the divisor moment \(C_M\) does not depend on later model/tag parameters, and that \(d_0\) changes onset size rather than a harmonic coefficient. Tiny-power multiplicative constants are fixed before the final onset; no count or constant depends on \(N_0\).

## 6. The oriented mixed improvement

If \(\log(r_i/r_j)\le.65b_j\), (R3) and \(v\mid W'\) give exterior-width saving \(e^{-\eta B_j}\), \(\eta=3/200\). Good masks give \(\tau(c_j)\le e^{s'B_j}\); (R4), the tiny divisor power and (R7) then give the relative bound per old centre

\[
 C_{k_0}e^{-[\eta-\epsilon(2+\beta A_0/2)
                    -\delta\beta A_0/2-Ds_{\rm low}-Ds']B_j}.
\]

Every eligible old object has \(b_i<2\theta B_j\), so (R2) gives \(m_i\ge e^{-1}e^{-4\theta B_j}\). **Disjoint original assignments**, not disjoint matching labels, imply

\[
 \#\{i:B_i\le\theta B_j\}\le eW e^{4\theta B_j}.
 \tag{R9}
\]

Keeping this \(W\) is justified for any upper bound \(W\) on original retained mass. It would be unjustified for a total of surviving adaptive masses; the draft explicitly does not use that interpretation.

The full exponent cost, including \(4\theta\), is at most \(\eta\,601/12800<\eta/2\). Thus the total relative error for a fixed newborn row is at most \(C_{k_0}W e^{-\eta B_j/2}\). Its retained outer-law first mass sums to at most \(m_j\), also for a common law because the old assignment has already been dropped and the estimate is uniform at each fixed newborn outer mask. Each newborn has one start, capacity has removed origin multiplicity, and stopping primes were already summed. Therefore

\[
 C_{k_0}W\sum_jm_j e^{-\eta B_j/2}\le C_{k_0}W^2.
 \tag{R10}
\]

This supports the proposed improvement over the source's coarse \(O(W)\) oriented estimate. Together with main terms \(O(W^2)\), distant errors \(O(W^{3/2})\), and width-separated errors \(O(W^{201/200})\), it yields (R1), since \(0<W\le1\). Empty retained families have zero counts.

Compared with the strongest independently reviewed prior result, BC v2, this adds an **analytic conditional estimate**, rather than another finite transport certificate. It does not enlarge BC's independent-review binding or establish the other manuscript inputs.

## 7. Computations actually replayed and their limits

All of `verify.py`, including its entry point, was inspected before execution. Default mode reads and compares the old certificate; only `--write-certificate` writes it. That flag was not supplied, and bytecode generation was disabled.

The first attempt using the required legacy Argus interpreter failed at import with `ModuleNotFoundError: sympy` (exit 1). The old report specifies the live-update interpreter for its **standalone checker**, which imports no Argus module. Running that explicit recorded interpreter succeeded (exit **0**, 0.597 seconds). No dependency was installed in a shared environment. Both attempts, commands, outputs and side-effect review are retained in `verify-replay.json`; the initial environment failure is not a mathematical verdict.

The successful replay checks **11 symbolic identities**, **8 unbounded-family positive-coefficient parameter certificates**, 1,014 gcd cases, 7,098 conditional cases, 72 deficit laws (8,184 regression cases), 49,686 actual projected-grid gcd identities, and 2,932 determinant-cycle/residue cases. The finite cases use primes \(2,3,5,7,11,101\) and centre exponents \(0\) through \(12\); determinant tests use primes \(2,3,5,7\) and common exponents 1 and 2. They corroborate translations and orientation, not universal quantifiers or analytic summations.

A fresh small Jacobian operation checks the **discrepant** case \(h=1\), rather than repeating the archived common-case order-13 query. After discovery and exact typed-contract inspection, the isolated adapter ran `combinatorics.generating_function.coefficients.compute` on

\[
 (3+6x-x^2)/(1-2x+x^2),\qquad \text{order }8.
\]

The dedicated `jacobian-payload.json` is the exact request. `jacobian-output.json` records exact rational coefficients **3, 12, 20, 28, 36, 44, 52, 60**, eight zero residual coefficients, and congruence modulo \(x^8\). `jacobian-status.json` records adapter exit **0**, timeout **false**, structured error **null**, server **0.14.0**, protocol **2025-11-25**. Discovery and inspected contract are separate JSON files. This is bounded exact corroboration of \(F_1\), not proof of all \(h\) or (R1).

The old Jacobian prefix, symbolic certificates, and certificate JSON are representations of supporting calculations, not additional theorems. Neither the old nor the fresh computation executes the one-sided orbit proof, convergence, tensorization, image classification, or (R9)-(R10). Those were assessed mathematically above. No Lean file was created or recompiled.

## 8. Every version and remaining obligations

| Old claim/version | Assessment and dependency boundary |
|---|---|
| C_RFJ_QUANT v1 | Historical assertion in CTX_RFJ v1, no registered interfaces or directly bound evidence. Not counted as a separately proved version. |
| C_RFJ_QUANT v2 | Same asserted estimate, with IN_CENTRES registered; superseded dependency state, not independent proof. |
| C_RFJ_QUANT v3 | Adds IN_FIELDS; still a historical conditional assertion. |
| C_RFJ_QUANT v4 | Adds IN_TENSOR; all three imported interfaces explicit. Not a new result. |
| **C_RFJ_QUANT v5** | CTX_RFJ v2 clarifies \(W\) as an upper bound and claims all three derivations. Sections 2-6 support these derivations and the conditional analytic conclusion. Native independent review remains outstanding. |
| C_RFJ_LOCAL v1 / v2 | One local algebra argument; v2 uses corrected context. The infinite positive extensions and factorizations establish the universal bounds; bounded regressions and prefixes only corroborate them. |
| C_RFJ_ENDPOINT v1 / v2 | One conditional endpoint/main-term argument, with v2 in corrected context. Separate means, two currencies, forced-omission savings, and image cutoffs were checked in Sections 3-4. |
| C_RFJ_SUM v1 / v2 | One summation argument, with v2 in corrected context. Tensor proof, strict margins, width/shell sums, and original-mass count were checked in Sections 5-6. |
| C_REMAINING_JOIN v1 | The legacy target has both a retired placeholder route and the later RFJ route. The stronger v5 estimate implies this target under its stated data; no second theorem or new BC review is counted. |
| C_ENDPOINT_COUNT v1 / v2 | v1 is an explicitly unverified placeholder; v2 makes the quantified claim supported here via C_RFJ_ENDPOINT v2. The current report does not retrospectively certify a missing v1 proof. |
| C_ROUNDOFF_SUM v1 / v2 | v1 is an explicitly unverified placeholder; v2 is supported via C_RFJ_SUM v2, within the same stipulated scope. |

This is **16 versions**, not sixteen independent results. Historical `reviewer:copilot-rfj`/Engineer support labels are not native Host review. R_REMAINING_JOIN and R_RFJ_QUANT were superseded, not refuted; the current route is R_RFJ_UNIFORM. Their exact bindings and reasons remain in the index.

Concrete limitations remain: the existence and acceptable total losses of admissible partitions/histories, the preliminary selections/purges as a complete construction, direct simultaneous-birth comparisons and static extra tests, sparse-alignment sums, and the final finite-construction/second-moment reduction are not established by this conditional estimate. Neither BC's historical compilation nor the successful RFJ replay proves those obligations. The unverified novelty claim is not promoted.

Within the stipulated retained-centre, good-mask and structural-history setting, the three interface retirements have mathematical reasons, rather than merely the old ledger's assertion of retirement. This Engineer assessment supports that scope only. The native independent Reviewer must still decide correctness, source correspondence, and family-wide completion.
