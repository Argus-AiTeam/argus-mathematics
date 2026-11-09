# Manuscript-dependency scaffold review

## Disposition, attribution and version

**Reference-only scaffold, not fourteen additional Argus proofs.** The old
ledger and graph restate fourteen claims from OpenAI's *Bounded-Step Walks on
Gaussian Primes*, September 26, 2026. None has a standalone Argus proof,
certificate, mechanical record, or supporting judgement in the thirteen
listed artifacts. Their truth is therefore not certified by the old developed
argument. This is a concrete support/dependency gap, not a finding that the
original manuscript is false, and not an access or execution failure.

This unit exists to make those dispositions explicit rather than omit them
from the review. It contains no distinct developed Argus result to count.
The one developed proof is assessed in
[`../signed_rectangle/report.md`](../signed_rectangle/report.md).

The existing `9100028/MANUSCRIPTS.json` fixes manuscript revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its eight TeX hashes match both
the old staged sources and the reference-source files. The title, author and
date are at `main.tex:37--39`. No reference manifest, old ledger, graph or
snapshot was changed. [`source_statements.txt`](source_statements.txt)
contains exact labeled source statements, including the transfer theorem's
parameter inequalities, extracted without copying or reviewing their proof
bodies. Definitions explicitly referenced by those statements remain in the
named source. The extraction is supporting source evidence, not a new
certificate or replacement manuscript.

All fourteen claims are version 1 in `CTX9000028` v1,
`2f53d303791592f34ed923df33654d64108887806ce28d9e266821176461f7c4`.
Their individual content hashes and every dependency edge are in
`DRAFT_REVIEW_INDEX.json`. Ledger and graph statements agree exactly.
An empty graph dependency list does not make its node a proved axiom.

## Every source claim and its missing old-Argus support

Here \(G_D\) has all Gaussian primes as vertices and edges at distance at most
\(D\); \(H\) and \(I\) use the manuscript's entropy conventions. For a finite
set of rational split primes, \(\mathcal A(\mathcal P)\) excludes divisibility
by either conjugate factor over each selected prime. The following
qualifications are part of the claims, not optional generalizations.

| Old identity | Exact source scope and conclusion | Concrete missing support in the old Argus work |
|---|---|---|
| `C_MAIN` | `main.tex:63--69`, `thm:main`: for every finite real \(D\), a finite common bound \(B_D\) bounds every component of \(G_D\), independently of the initial prime, including coordinate-axis primes. | The rectangle theorem produces neither a finite sieve obstruction nor the periodic-to-component reduction. The routes through `C_SIEVE` and `C_PERIODIC` remain unsupported here. |
| `C_SIEVE` | `main.tex:120--125`, `thm:sieve`: for every \(D\ge1\), some finite \(\mathcal P_D\) of ordinary primes \(1\bmod4\), depending only on \(D\), makes \(\mathcal A(\mathcal P_D)\) contain no infinite distinct-point \(D\)-step sequence. | No old argument proves the needed multi-batch information contradiction or selects a working finite obstruction. The graph points to `information.tex` for the argument, whereas the theorem statement is in `main.tex`; these are not two results. |
| `C_PERIODIC` | `periodicity.tex:8--22`, `prop:periodic`: assuming such an obstruction for a finite \(\mathcal P\), put \(Q=\prod p\), \(K_D=\#\{v\in\mathbb Z[i]:|v|\le D\}\), and let \(E\) be all associates of the selected Gaussian factors. Every component has size at most \(\max\{Q^2,\ |E|+(K_D-1)|E|Q^2\}\). | Neither the finite periodic component argument nor treatment of exceptional prime associates is supplied by the rectangle checker. The stated obstruction hypothesis must first be established separately. |
| `C_DIFFERENCES` | `geometry.tex:16--26`, `lem:differences`: a self-avoiding \(D\)-step segment of \(n\ge1\) steps has diameter \(R\), width \(W=\max(1,\) maximum distance from a diameter line\()\), and \(A=RW\) satisfying \(cn\le A\le D^2n^2\), \(|E-E|\ge c_D A\). | The signed-rectangle certificate checks no walk-to-difference-set estimate. The manuscript's torus-degree/covering argument is not an Argus certificate for this node. |
| `C_ENRICHMENT` | `geometry.tex:280--298`, `lem:enrichment`: for a fixed self-avoiding walk, sample a uniform distinct difference of the next \(n=\lfloor e^{gU}\rfloor\) segment, choose its representing pair by a fixed rule, then a fair endpoint \(V\). For \(U>0\), \(0<g<10^{-2}\), \(q=\lfloor U/L_*\rfloor\le k\), \(b=\lfloor g^2U/L_*\rfloor\), fixed \(D\), \(T\to\infty\), and \(g^C U/\log T\to\infty\) for every fixed \(C>0\), one has \(f_V(b)/(bL_*)\ge(1+f_Z(q)/(qL_*))/2-O_D(g)\), uniformly. | Replacing the rectangle estimate supplies only one geometric input. It does not prove the sampling/entropy comparison, the many-differences input, the displacement losses, or uniform asymptotic errors. |
| `C_DISPLACEMENT` | `preliminaries.tex:119--131`, `lem:displacement`: on the fixed bounded-step walk, jointly distributed finite random times with \(|T_1-T_0|\le n\) satisfy \(H(z_{T_1}-z_{T_0})\le2\log(n+1)+O_D(1)\), also conditionally when the time bound persists. Any finite residue vector \(F\) satisfies \(H(F(z_{T_1}))\ge H(F(z_{T_0}))-H(z_{T_1}-z_{T_0})\). | This standard-type entropy input is a manuscript restatement, not one of the arithmetic line-divisibility identities checked in `verify.py`. No new Argus derivation is supplied. |
| `C_TRANSFER` | `coverage-transfer.tex:102--129`, `thm:transfer`: for the signed-coordinate conditional-iid experiment described below, under all its entropy, repetition, coverage and size inequalities, all but fraction \(\eta\) of terminal coordinates have \((\tau,\beta)\)-coverage. | The old checker has no conditional sampling, coverage deficit, repetition/concentration or parameter-budget argument. A rectangle tail cannot discharge these hypotheses or this conclusion. |
| `C_SCHEDULE` | `schedule.tex`, whole common-sampling-schedule section: its prescribed scales/checkpoints provide joint entropy, future-displacement estimates and a shared smoothed terminal law. In particular `lem:future-shift`, lines 94--110, gives \(\log(1+S_V)\le2gV\), displacement entropy \(O_D(gV)\), and, conditionally on earlier exact starts, \(\operatorname{TV}(\mathcal L(t_*),\mathcal L(t_*+a))\le T_+^{-9}\) for integers \(0\le a\le T_+\), for sufficiently large \(M\). | The ledger statement is an umbrella reference, not a self-contained quantified theorem about arbitrary schedules. No old proof checks scale matching, the shared time law, smoothing or uniform checkpoint budgets. It must not be identified solely with `lem:future-shift`. |
| `C_COVERAGE` | `schedule.tex:406--414`, `prop:coverage`: for sufficiently large \(M\), uniformly over batches, checkpoints \(0\le i\le J\), and exact starts \(a\ge0\) at \(A_i\), all but \(\eta_i\) of signed primes satisfy \(\#\{u:b_{i,a,\pi}(u)<\tau_i/p\}<p^{1-\beta_i}\), with the source's prescribed parameters and continuation law. | No old argument iterates the transfer theorem or verifies the checkpoint-specific parameters and uniformity. This is not coverage for arbitrary \(\tau_i,\beta_i,\eta_i\). |
| `C_INFORMATION` | `information.tex:41--55`, `prop:information-rate`: for sufficiently large \(M\), each scheduled batch has \(L_T^{-1}\mathbb E_{\mathcal C} I(X'_T;W_{L_T}(t_*)\mid O'_T)\ge c_1/\log T\), with \(c_1>0\) depending only on fixed schedule parameters and a threshold uniform over infinite self-avoiding \(D\)-step walks in \(\mathcal A(\mathcal P_M)\). | No old certificate connects zero avoidance and coverage to this conditional information cost, including the smaller-batch conditioning and list bounds. |
| `C_TELESCOPE` | `information.tex:303--313`, `lem:telescope`: for every fixed prime-choice collection \(\mathcal C\), \(\sum_T I(X'_T;W_{L_T}(t_*)\mid O'_T)/L_T\le\log K_D+o(1)\), uniformly over choices and walks as \(M\to\infty\). | There is no old proof of the nested-block entropy telescope, its common terminal law, or its continuity-error budget. Distinct time laws for different batches would not be the statement being cited. |
| `C_LIST` | `preliminaries.tex:162--174`, `lem:list`: for finite \(X\) with at most \(a\) values and finite \(Y\), if \(\rho=\Pr\{X\in\mathcal L(Y),\,|\mathcal L(Y)|\le b\}\), \(1\le b\le a\), then \(\log a-H(X\mid Y)\ge\rho\log(a/b)-h(\rho)\). | This is an attributed standard/Fano-type manuscript input, not a developed Argus result. The ledger's wording with globally size-bounded lists is a restricted special case, not grounds for claiming a refutation of the more general source statement. |
| `C_CONTINUITY` | `preliminaries.tex:142--150`, `lem:continuity`: two joint laws on the same finite product alphabet of size at most \(a\), at total variation \(\epsilon\le1/2\), have conditional entropies differing by at most \(2h(\epsilon)+2\epsilon\log a\). | No old checker models the joint laws, product alphabet, conditioning or total variation. Scalar algebraic equalities in a Chernoff exponent are irrelevant evidence for it. |
| `C_CONDITIONING` | `coverage-transfer.tex:34--47`, `lem:conditioning`: for finite \((Y,\mathcal H)\), independently selected uniform signed \(s\)-subset \(S\), \(\mathbb E_S H(F_S(Y))\ge(1-\epsilon)s\overline L\) and \(H(\mathcal H)\le\kappa s\overline L\) imply \(\operatorname{av}_c[\log p_c-H(\phi_c(Y)\mid\mathcal H)]\le(\epsilon+\kappa)\overline L\). No independence of \(Y,\mathcal H\) is required. | No old Argus proof establishes the shared-conditioning/subset-averaging step. It must not be replaced with a claim assuming the extra independence the source expressly avoids. |

### Transfer hypotheses retained explicitly

The coordinate setup is a lattice \(\Lambda\) with signed homomorphisms
\(\phi_{j,\sigma}\) to finite abelian groups of orders
\(T\le p_j\le2T\), and \(\overline L=k^{-1}\sum_j\log p_j\).
The subset uses distinct indices and independent fair signs and is independent
of the point experiment. For finite \(A\), let \(Y=y(A)\); conditional on
\(A\), the \(h_1,\ldots,h_n\) are iid with law \(\nu_A\);
\(\mathcal H=(h_1,\ldots,h_n)\), \(Z=Y+h_1\).
Coverage means that fewer than \(p^{1-\beta}\) residues have mass below
\(\tau/p\). It is not support cardinality or uniformity.

Besides \(1\le s\le k,n\ge1\), the theorem requires
\[
0<\tau\le3/8,\quad0<\delta\le1/64,\quad
\tau'=\tau+4\delta,\quad0<\beta'\le\beta<1,\quad
0<\eta\le1,\quad0\le\eta'\le1.
\]
At every support point \(A=a\), all but \(\eta'\) of coordinates must have
\((\tau',\beta')\)-coverage conditionally. For \(\epsilon,\kappa\ge0\),
the joint-entropy and conditioning budgets must hold, together with
\[
\eta'\le\eta\delta/100,\quad
\epsilon+\kappa\le\eta\delta\beta'/16,
\]
\[
p e^{-\delta^2np^{-\beta}/2}\le\delta/100,\quad
\delta^{-1}<p^{\beta'/2}\quad\text{for every }p=p_j,\qquad
\log(2e/\delta)\le(\beta'/4)\log T.
\]
These are exact source obligations, not consequences checked by the rectangle
program. Retaining them avoids converting a conditional transfer statement
into a purported unconditional theorem.

## Dependency and evidence assessment

The old live routes decompose `C_MAIN` into `C_SIEVE,C_PERIODIC`;
`C_SIEVE` into `C_INFORMATION,C_TELESCOPE,C_SCHEDULE`;
enrichment into differences, rectangle and displacement; transfer into
conditioning and list bounds; schedule into enrichment and displacement;
coverage into transfer and schedule; information into coverage, schedule,
displacement and list; and telescope into schedule and continuity.
These are recorded decompositions, not proofs of the implication edges or
their endpoint propositions. The sharper rectangle bound replaces only the
rectangle input. None of the other fourteen nodes has a supporting old ledger
opinion, and the exact checker never evaluates them.

The manuscript itself contains arguments and citations, but their presence
as reference inputs is not evidence that the old Argus work independently
verified them. In particular, the topology cited in the many-differences
argument, prime-density inputs to batching, entropy references, and the
periodicity source are not silently promoted into assumptions of the
rectangle proof or certified by this review. A new complete audit of those
manuscript proofs is outside the present objective. No novelty or correctness
claim about those source results follows from their appearance in the ledger.

The historical `C9000028` is a broad task description, not another theorem.
Its `R_RECTANGLE_SCOPE` edge reaches only the sharp rectangle bound. Even a
sound proof of that bound cannot by itself discharge a broad whole-paper
verification objective or `C_MAIN`. It can constitute the scoped contribution
the old proof expressly claims. This review records that distinction instead
of either accepting the full manuscript or inventing a counterexample.

All 23 graph nodes are `open` with `reviewer_confirmed=false`.
The sixteen historical support opinions belong only to the eight rectangle
claims. There is no conflicting positive review record for this scaffold
to reuse. No listed Lean source or compiler certificate formalizes any
of these fourteen claims; the reported incomplete public comparator is
excluded rather than treated as evidence.

## Result of this unit

All fourteen source identities, hypotheses, attributions, dependency roles
and missing old-Argus obligations have an explicit disposition. Their
status is **not certified by the old draft**, rather than mathematically
refuted or unresolved merely because a file was inaccessible.
The source files were available and identified exactly. This support gap
does not prevent completing an honest review of the old work; it prevents
claiming the surrounding manuscript has been verified. Final acceptance of
this classification and complete artifact coverage belongs to the native
independent Reviewer.
