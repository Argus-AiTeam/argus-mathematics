# Conditional sampling specialization

## Verdict, source and attribution

**The asymptotic specialization is supported conditionally on the stated
upstream arithmetic inputs, using the additive finite bound in the old
ledger.** Its sampling contribution is \(O(B^{-3/200})\). The full error is
\(\rho_B+O(B^{-3/200})\), where the uniform arithmetic remainder
\(\rho_B=o(1)\) has no established power rate. This does not prove the
upstream inputs, the actual-residue comparison, or the joint Dickman law.

This is an Engineer assessment pending the native independent Reviewer.
The strongest supported old conditional conclusion is preserved, not
improved into a new arithmetic theorem. No novelty claim is made.

The old Argus sources are `research/adaptive-cut-transfer/report.md`,
“Specialization to the manuscript,” `exact_certificate.json`, and
`C_SAMPLING_45 v1-v5` in campaign `9000012`. The five ledger versions have
the same natural statement; versions 2-5 successively register A23, A24,
A44 and AMROW. Those are dependency registrations, not five results.
The proof-graph route `R_45_FROM_UPSTREAM` is a conjunction of the
transfer and four input bundles.

The original source being compared is the unpublished OpenAI manuscript
*The joint Dickman law for consecutive integers*, September 24, 2026,
recorded revision `4eaee87548250b2682affda7d05d947c05554bae`,
`build/sections/sampling.tex`, Proposition
`prop:sampling-comparison`, equation (45). Current bytes of all 13
manifest-listed TeX files match their existing digests; the old reference
directory is a live symlink, not an independently preserved manuscript.

The manuscript states, for every fixed \(\epsilon_2>0\),
\[
 \mathbb E\|\mathcal E(\mathbf S;s)\|_\square
       \le E_0+\epsilon_2+o(1),\qquad
 E_0=Ce^{-c_3C_*}+C_\eta\epsilon_1,
\]
uniformly for each \(s\) in its fixed compact range. The old Argus draft
proposes the quantitative conditional refinement
\[
 \mathbb E\|\mathcal E(\mathbf S;s)\|_\square
       \le E_0+\rho_B+O(B^{-3/200}).
\]
It is a refinement of this sampling step, not a quantitative joint
smooth-number density theorem.

## Exact input boundary

The regularity parameters, sufficiently fine grid, then sufficiently
small tolerance, \(C_*,\eta,C_6,\epsilon_1\) and the chosen coarse
partition are fixed before \(B\to\infty\). The counting limit \(x\to\infty\)
elsewhere in the manuscript is taken first at fixed \(B\). Constants
need not be uniform when these fixed parameters vary with \(B\).

The input mapping, substantively assessed in
`../arithmetic-boundary/report.md`, is:

| Input | Exact role in the abstract transfer |
|---|---|
| (23), `graph.tex:252-286`, `lem:graph-row-mean` | Every fixed endpoint type has bounded expected latent degree, yielding the first-moment part of \(C_0=O(1)\). |
| (24), `moments.tex:13-38`, `prop:moments:rows` | Integrated squared latent rows are \(O(B^{-21/100})\), after the fixed grid/tolerance choices; not uniform conditional squares. |
| (44), `kernel.tex:736-751`, `prop:kernel-comparison` | Separate bounded real tests at every site, including zero on deleted positions, give \(\beta=E_0+\rho_B\). |
| Comparator (43) and row bounds, `kernel.tex:675-709,753-820` | Deterministic absolute rows \(O(1)\), squared rows \(O(T^{-1})\), symmetry and zero nonpairs. |
| Model law, `channels.tex:21-25`, `graph.tex:196-207` | Finite independent model sites; this is not independence of actual consecutive-integer residue sites. |

For \(\mathcal E=\mathcal L-\mathcal M\) use the symmetric nonnegative
envelope \(H=\mathcal L+|\mathcal M|\). Then
\[
 |\mathcal E|\le H,\qquad
 H^2\le2\mathcal L^2+2\mathcal M^2,\qquad
 T^{-1}=O(B^{-32/100})=O(B^{-21/100}),
\]
so H1-H2 follow with uniform constants \(C_0\) and
\(q=C_1B^{-21/100}\). H3 is exactly the local-test statement (44).
The leading coefficient of \(e^{-c_3C_*}\) has the manuscript's stated
independence from later \(\eta,C_6\) choices; the other constants retain
their fixed-parameter dependencies.

None of these arithmetic statements is proved by the old finite checker
or Lean source. They remain explicit assumptions in the active ledger.
Source inspection verifies their attribution and hypotheses, not their
full mathematical truth.

## Finite bound used, including the source mismatch

The source equation (3) and old `C_ADAPTIVE_TRANSFER` state different
expectation formulas. As explained in
`../finite-adaptive-transfer/report.md`, the proof supports
\[
 \mathbb EC\le b+a+2\sqrt{Mq/m}
                  +2md/M+\sqrt{(C_0^2+q)(p+\delta)}.
\]
It does not establish the printed product of the last two terms.
This specialization uses the displayed **additive ledger formula**,
openly, rather than silently relabeling it as the report's (3).
The probability inequality (4) is separately supported.

## Admissibility and rate calculation

Suppose \(c_MB^{32/100}\le M\le C_MB^{32/100}\), with positive fixed
constants. The manuscript's actual choices
\(T=\lfloor B^{32/100}\rfloor\) and \(M=\lceil C_6T\rceil\)
satisfy this for sufficiently large \(B\).
Take fixed \(K>0\) and
\[
 d=KB^{7/100},\quad
 m=\lfloor MB^{-18/100}\rfloor,\quad
 t=B^{-20/100},\quad \delta=B^{-3/100}.
\]
Since \(MB^{-18/100}\) grows like \(B^{14/100}\), eventually
\(\tfrac12 MB^{-18/100}\le m<M\), \(m\ge1\), and \(M\ge2\).
Also \(d\ge2C_0\) eventually and
\(p\le4Mq/d^2=O(B^{-3/100})<1\).
Thus all finite-theorem parameter restrictions are satisfied.

The full additive budget is:

| Quantity | Bound |
|---|---|
| \(p\) | \(O(B^{-3/100})\) |
| \(\sqrt q\) | \(O(B^{-21/200})\) |
| \(2\sqrt{Mq/m}\) | \(O(B^{-3/200})\) |
| \(2md/M\) | \(O(B^{-11/100})\) |
| \(\sqrt{(C_0^2+q)(p+\delta)}\) | \(O(B^{-3/200})\) |
| \(\log N\le m\log(2eM/m)\) | \(O(B^{14/100}\log B)\) |
| \(a\) | \(O(B^{-2/100}\sqrt{\log B})=o(B^{-3/200})\) |

The logarithmic last comparison uses
\(B^{-1/200}\sqrt{\log B}\to0\), not equality of rational exponents.
Because \(\beta=E_0+\rho_B=O(1)\), \(p\to0\), and
\(\sqrt q,a\to0\), one has \(L=O(1)\). Hence
\(b-\beta=\sqrt q+Lp=O(B^{-21/200})+O(B^{-3/100})\).
Combining the rows proves the asserted conditional expected bound.
In particular, retaining the missing additive exceptional term changes
neither this exponent nor the conditional conclusion.

For the probability bound, \(q/t=O(B^{-1/100})\) and
\(2\sqrt{Mt/m}=O(B^{-1/100})\). This recovers the source's
squared-mass threshold and skeleton scales. If one instead discards that
squared-mass event and only uses Cauchy--Schwarz on its exceptional mass,
the \(B^{-1/100}\) failure costs \(O(B^{-1/200})\) in expectation.
Direct integration of \(\sqrt Q\) is the reason the old Argus expected
sampling estimate has the better \(3/200\) exponent.

## Comparison with the actual manuscript proof

The manuscript's proof has the same decisive structure: a deterministic
small-column approximation; fixed subset/sign/type conditioning rather
than conditioning on the optimizer; an arbitrary-good-endpoint Lipschitz
bound; a **capped** infimum extension; a union over only the finite
subset/sign family; and one common degree failure. Its fixed-cap proof
uses the \(\epsilon_2\) slack for concentration and only concludes \(o(1)\).
The old Argus finite-parameter formulation makes those choices explicit
and integrates the square mass instead of discarding it.

The source explicitly identifies Alon et al. Lemma 3 and Borgs et al.
Theorem 4.6 as related bounded-kernel sampling work, not black-box
premises for these growing position-dependent kernels. This review does
not establish originality or import either theorem. The abstract
extension and bounded-differences arguments needed here are checked
directly in the finite-transfer unit.

All bounds are uniform **for each fixed** \(s\) with common constants.
There is no simultaneous good event over an uncountable \(s\)-range.
A uniform expectation bound can be integrated over the fixed range.
This is precisely the uniformity the manuscript uses.

After equation (45), the source additionally invokes (21) to compare
actual residue sites with the independent model, and uses bounded label
energies and fixed-\(B\) scale counting. The comparator row estimates
give total absolute mass \(O(M)=O(B^{32/100})\), enough for the
\(O(B^{10})\) hypothesis in (21). That verifies a conditional
**interface**, not the root comparison itself. Actual labels need not
be independent of the site types. Subsequent label cancellation,
energy contradiction and distribution deductions remain outside this
conditional result.

## Replays and final boundary

The existing rational exponent and huge-\(B\) checks were replayed in
`../finite-models-shortcuts/finite_replay/`; all seven finite result fields
matched the old certificate. That includes the illustrative nonvacuity
budget with \(B=2^{2000}\) and \(C_0=C_1=K=\beta=1\), using the
**additive** expectation formula. It does not assert those constants for
arithmetic kernels or establish any asymptotic quantifier by enumeration.
The real Lean 4.31.0 replay in `../finite-cut-core/replay/` proves only
the deterministic finite-array core. No unchanged computation was
repeated for this unit.

Concrete remaining obligations are the four arithmetic input bundles
with their fixed-parameter uniformity, the independent-root comparison,
the label/amplification/main-energy route, and the final distribution
deduction. The literal finite equation (3) remains a separate unresolved
statement, but is unnecessary for the supported conditional rate.
Independent Reviewer acceptance remains pending.
