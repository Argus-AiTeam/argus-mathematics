# Explicitly excluded manuscript chain

## Assessment

**The old work supplies no completed independent verification of these six
downstream claims.** This is a substantive scope assessment of what the old
draft proves, not a fresh error search through the original manuscript.
The old proof's section 7 explicitly withholds these conclusions; its ledger
and proof graph retain their obligations. The original source is accessible,
and its statements were matched to the references below. This verdict is
therefore not based on missing access or a failed run.

The manuscript is OpenAI, *The generalized Mukai conjecture*, dated September
24, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`. Its seven
listed TeX inputs match the supplied manifest. Unless otherwise stated, its
working setup is a smooth connected complex projective Fano \(X\),
\(n>0\), \(r=\rho_X\), pseudoindex \(\iota\geq2\); numerical degrees sum
over actual curve classes. The main theorem also includes \(\iota=1\).
None of the six claims has a supporting judgment in the old ledger.

## Exact assertions and concrete obligations

| Claim/version and source | Assertion under the manuscript setup | Obligation not discharged by the old proof/certificate |
|---|---|---|
| `CMAIN@1`; `introduction.tex`, `thm:main` | \(\rho_X(\iota_X-1)\leq n\), with equality exactly for \((\mathbb P^{\iota_X-1})^{\rho_X}\), for every positive-dimensional smooth connected complex Fano | The five downstream inputs below, not just `CDESC`, must be verified and composed. Equality requires the geometric family/product argument as well as the inequality. |
| `CDENSE@1`; `descendants.tex`, `lem:free-dense` | Nonconstant free numerical degrees are closed under addition and positive multiples and Zariski dense in \(N_1(X)_\mathbb C\) | The addition smoothing, rational-curve spanning, and comb-smoothing-to-free arguments are not in the old proof. The manuscript invokes rational connectedness and Tian--Zong for the latter steps; their hypotheses and applications are not checked by the nine groups. Spanning plus addition would then give density via the positive integral grid. |
| `CREC@1`; `setup.tex`, `lem:recurrence`, `eq:recurrence`, `eq:string-pairing` | For \(d_\beta>0\), \(\beta_jv_\beta=\sum_\gamma A_{j,\gamma}v_{\beta-\gamma}\); for positive \(\beta\), \((v_\beta,1)=\langle\tau_{d_\beta-2}(\mathrm{pt})\rangle_\beta\) | Verify the virtual divisor/TRR/string identities, splitting and classical term with the actual conventions. Here \(v_0=\mathrm{pt}\); positive \(v_\beta\) is the Poincare dual of the two-point descendant sum, all other \(v_\beta=0\), and no unstable degree-zero two-point invariant is inserted. None of that is computed by the old verifier. |
| `CSPEC@1`; `spectral.tex`, `prop:spectral` | A joint diagonal tuple of the commuting quantum divisors over an algebraic closure of \(\mathbb C(q_1,\ldots,q_r)\) is algebraically independent over \(\mathbb C\) | Check the passage from relations on all tuples to a homogeneous annihilating polynomial, the normalized recurrence estimates and iteration along a free direction avoiding that polynomial. The lower bound supplies one side of the final contradiction, not these reductions or uniform bounds. |
| `CTRACE@1`; `trace.tex`, `lem:alternating-trace`, `lem:spectral-trace`, `prop:independent-correspondences` | The independent joint tuple yields independent positive degrees \(\gamma_1,\ldots,\gamma_r\) with \(S_{\gamma_1}\cdots S_{\gamma_r}\ne0\) and \(\sum_j(d_{\gamma_j}-1)\leq n\) | Check the differential-form alternating trace with the inserted commuting matrix, nonvanishing from one joint tuple and extraction of independent degree vectors from coefficients. The Smith matrix here is unrelated to these quantum-divisor matrices. |
| `CEQUALITY@1`; `equality.tex`, `lem:minimum-degree-incidence`, `prop:equality-rigidity` | At \(r(\iota-1)=n\), the nonzero independent product yields the families required to conclude \(X\cong(\mathbb P^{\iota-1})^r\) | Verify conversion of correspondence support into actual proper irreducible components of normalized `RatCurves`, the nonempty ordered chain and the covering property of each family. Apply the corrected ordered-chain bound and product theorem with all their family hypotheses, not arbitrary proper subfamilies. |

These are identifiable mathematical gaps **in the old verification coverage**,
not identified flaws in the manuscript's proofs. This review neither asserts
the claims true nor refutes them. The original manuscript contains proposed
arguments, but treating those as independent old-Argus proofs would substitute
the object of an audit for its evidence.

For the equality claim, the source explicitly states the delicate hypotheses:
the ordered-chain theorem uses proper **irreducible components** of
\(\operatorname{RatCurves}^{\mathrm n}\) with independent numerical classes
and a nonempty ordered endpoint locus. The product characterization requires
independent unsplit **covering** families of degrees \(n_j+1\), with
\(n_j>0\) and \(\sum n_j=n\). The source itself warns that arbitrary proper
subfamilies are insufficient. Those are concrete obligations, not consequences
of a point-descendant coefficient calculation. The external ordered-chain
and product theorems are identified here as manuscript dependencies, not adopted
as proved inputs to a new theorem or independently re-audited citations.

## Dependencies, attribution and status

`RMAIN` in the old ledger is the AND of `CDESC`, `CDENSE`, `CREC`, `CSPEC`,
`CTRACE`, `CEQUALITY`. The graph further shows
`CSPEC <- {CREC,CDENSE,CDESC}`, `CTRACE <- CSPEC` and
`CEQUALITY <- CTRACE`. Supporting the descendant proposition leaves those
other inputs unverified. `CGENERAL` broadens a lower-bound input; it does not
bypass any downstream obligation.

The six assertions are attributed to the supplied manuscript, not to an
original Argus discovery. Their novelty and mathematical correctness were
not established by the old scoped work or this coverage review. No failed
attack, certified counterexample, or refutation of an original manuscript
claim appears in the fourteen-artifact inventory. The historical umbrella
`C9000063@1` is an audit mission, not a theorem; it is indexed but excluded
as a separate mathematical unit. Its broad objective cannot be declared
mathematically accomplished just because one input proposition was supported.

All six statement versions are included in this unit's `verdict.json`.
They have no old supporting judgment, no Lean source, and no computational
certificate that purports to settle them. Their old graph nodes remain open.
Those are appropriately limited conclusions about the old work; completion
of this review does not require resolving the six claims or starting a new
research campaign. The native Host Reviewer decides whether that distinction
and the complete coverage are adequate.
