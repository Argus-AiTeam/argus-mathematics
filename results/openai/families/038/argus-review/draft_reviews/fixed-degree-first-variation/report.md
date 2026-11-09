# Fixed-degree first variation

**Engineer assessment: supported as a conditional first-variation lemma.**
The specialization comparison is an exposed upstream assumption, not proved
by the derivative, by the fixture, or by Lean.

## Claim, hypotheses, version and attribution

Fix \(m>0\) with \(N_m>0\) and \(t>0\). Let a nonzero admitted monomial test
and basis attain \(f_{m,t}(x)\), with integral closed center \(W\ni x\) of
dimension \(d>0\). Assume that at a very general smooth \(y\in W\),
\(f_{m,t}(y)\geq f_{m,t}(x)\). For the initial basis in the fixed local
coordinates of the weighted-growth unit, put
\[
 Q_m=\sum_{\Gamma_m}e^{-\ell(p)/m},\qquad
 U_m=\sum_{\Gamma_m}|\beta|e^{-\ell(p)/m}.
\]
Then \(T_m=U_m/(mQ_m)\leq d/t\). This applies to the test of every minimizing
pair, after an adapted-basis replacement for that test. It does not assert
that all nonminimizing positive-center tests satisfy the inequality.

The old Argus argument is `report.md`, lines 333-390, equations (15)-(19);
`FV9000038` versions 1 and 2 have this same conditional statement, with
specialization explicitly recorded in version 2. It reproduces the
manuscript's `centers.tex`, `eq:center-discrepancy-variation`,
`eq:center-order-variation` and `eq:center-variation-upper`. The exact source
definition is `minimization.tex`, `eq:min-objective`, lines 268-283:
the infimum ranges over tests *and bases*, with closed center containing the
point; positive rescaling is allowed. `lem:specialization`, lines 554-585,
is for each fixed \(m\), every irreducible \(W\ni x\), and all \(t>0\).
These are OpenAI sources at the manifest-bound revision
`4eaee87548250b2682affda7d05d947c05554bae`.

## Decisive argument and the sign

The initial basis is adapted to the old valuation filtration, since the
Taylor order compares that valuation first. Its sorted valuation values
dominate those of an arbitrary basis. Replacement can only decrease the
exponential objective; because the original pair attained the infimum,
replacement has exactly the same minimum. Consequently
\(Q_m=N_m f_{m,t}(x)e^{-A(v)/t}>0\).

At the chosen smooth stratum point, give tangent parameters weight
\(\epsilon\), fiber parameters weight \(\epsilon^2\), and leave the old
positive weights unchanged. The full-boundary coordinate condition and
avoidance of other relative canonical components make each new coordinate
discrepancy one, so
\[
 A(v_\epsilon)=A(v)+d\epsilon+(n-d-r)\epsilon^2.
\]
For \(\epsilon>0\) this is an admitted point-centered test at \(y\).
For each section of this one finite basis,
\[
 v_\epsilon(s)=\ell(p)+\epsilon|\beta|+O(\epsilon^2).
\]
This expansion does not exchange a derivative with infinitely many degrees.
Below a fixed old-weight bound there are finitely many positive-coordinate
exponent choices, giving a gap above the least old weight. The least tangent
degree among terms of that weight supplies the linear coefficient. One such
term bounds the remaining fiber contribution, while all exponents are
nonnegative. Zero-weight fiber variables and irrational positive weights do
not invalidate this fixed-section argument.

For the fixed-basis objective \(F(\epsilon)\),
\[
 F(\epsilon)\geq f_{m,t}(y)\geq f_{m,t}(x)=F(0).
\]
Thus its right derivative is nonnegative:
\[
 F'(0+)=\frac{e^{A(v)/t}}{N_m}
       \left(\frac dtQ_m-\frac1mU_m\right)\geq0.
\]
Cancelling positive factors gives the **upper** moment bound \(T_m\leq d/t\).
No degree-independent radius of differentiation or specialization at every
auxiliary degree is used.

## Existing experiment and evidence

The unchanged `verify.py` was freshly run without `--compile` or
`--write-certificate`; see `../archived_exact_replay.json`. The original
\(\mathbb P^2,\mathcal O(1)\) degree-12 monomial fixture uses
\(v=12\log(2)\operatorname{ord}_{\rm line}\), so slice weights are exactly
\(2^{-p}\). It yields
\[
 T_{12}=\frac{91477}{196610},\qquad
 \frac13-T_{12}=-\frac{77821}{589830}<0.
\]
This confirms that the proposed perturbation descends for this particular
test at \(t=3\). It proves that this test is **not minimizing**, not that
the manuscript's minimizing-pair proposition is false. The fraction is a
normalized derivative; positive prefactors are omitted only for its sign.

There is no Lean declaration for this geometric derivative or specialization.
The old ledger's supporting opinions for `FV9000038` are distinct from its
`inconclusive` judgement on `manuscript-specialization`. The pending native
review receipt prevents importing those opinions as independent acceptance.

## Concrete remaining obligations

No gap was found in the derivative implication with specialization admitted.
To remove that admission, one must establish `lem:specialization` itself:
the closed realizability loci in `lem:min-flags` must allow every rational
normalized order list realized at a very general \(y\) to be realized at
\(x\), and the limiting list comparison must pass to the infimum over all
tests and bases. That proof is not supplied by this unit and was not newly
audited. The native Reviewer must check the stated conditional implication,
its adapted-basis equality and discrepancy bookkeeping; this does not require
settling the entire upstream theorem or starting a new attack.
