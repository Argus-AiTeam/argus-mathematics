# Conditional geometric bridge to point centers

**Engineer assessment: supported as the exact conditional implication in the
old draft.** The unconditional point-center proposition and the original
Fujita target remain only partially supported by this draft because their
upstream and downstream obligations are not discharged here.

## Exact claim, hypotheses and version

Fix the manuscript's smooth connected complex projective \(n\)-fold,
\(n\geq1\), ample \(L\), closed \(x\), and admitted nonzero real-weight
monomial tests. Assume, for a common \(0<t_0<n+1\) and all large \(m\),
all \(t\in[t_0,n+1]\) have attained minima and
\[
 0<c_0\leq f_{m,t}(x)\leq1-\delta,\qquad A(v)\geq a>0
\]
for every minimizing test, with constants uniform in degree, parameter and
test. Assume also the very-general specialization comparison at every fixed
reference degree and possible integral center through \(x\).

Choose a fixed \(t\in[t_0,n+1)\) with \(t>n+1-a/(n+2)\), and write
\(c=\liminf_j f_{j,t}(x)>0\). For **every increasing sequence**
\(m\to\infty\) with \(f_{m,t}(x)\to c\), every minimizing pair is
point-centered in all sufficiently late terms of that sequence. Centers,
degrees, singularities, models, weights and bases may vary with \(m\).
This implies arbitrarily large point-center degrees, not all sufficiently
large degrees without the liminf condition.

The old Argus theorem is `report.md`, lines 92-126 and 391-505, using its
component proofs. `PCBRIDGE9000038` versions 1-3 retain a weaker, existential
ledger phrasing ("has a liminf subsequence") of this same conclusion; the
report proves the displayed every-sequence eventual statement. Versions 2
and 3 add minimizer and Hilbert assumptions without changing the statement.
The source is OpenAI, September 23, 2026, `centers.tex`,
`prop:point-center` and the limiting subsection, at revision
`4eaee87548250b2682affda7d05d947c05554bae`. The original proposition says:
failure of \(P=K_X+(n+1)L\) to be generated at \(x\) gives some \(0<t<n+1\)
and arbitrarily large attained degrees with **every** minimizing pair
centered at \(x\). Treating the implication below as that unconditional
proposition would omit its upstream hypotheses.

## Decisive geometric-to-scalar passage

Suppose infinitely many terms of a chosen liminf sequence have a
positive-dimensional minimizing pair. Select one pair in each such degree
and a subsequence with fixed \(d>0\). The restriction and weighted-growth
units supply constants independent of the varying centers and tests; the
first-variation unit gives \(T_m\leq d/t\) at each fixed \(m\).

Fix \(l\geq2\) *before* taking the degree limit, and let
\(j_i=\lfloor mi/l\rfloor\), \(1\leq i\leq l\), so \(j_l=m\).
For sufficiently large \(m\), all increments exceed the uniform threshold.
Weighted growth and the exact simplex moment telescope to
\[
 T_m+\frac d{2m}\geq
 d\sum_{i=1}^{l-1}
 \frac{j_{i+1}-j_i-C'_d}{m}\frac{Q_{j_i}}{Q_m}.
\]
For this one test, all \(Q_j\) use weights with the same denominator \(m\).
The scaled test \((j/m)v\) is admissible **at \(x\)** because its closed
center is still \(W\), its discrepancy scales linearly, and its section
orders divided by \(j\) equal the old orders divided by \(m\). The infimum
definition, not specialization in degree \(j\), gives
\[
 \frac{Q_j}{Q_m}\geq
 \frac{N_j}{N_m}\frac{f_{j,t}(x)}{f_{m,t}(x)}
 e^{(1-j/m)A(v)/t}.
\]

For each fixed \(i,l\), the fixed ambient Hilbert asymptotic yields
\(N_{j_i}/N_m\to(i/l)^n\). The numerator \(f_{j_i,t}(x)\) is eventually
at least \(c(1-\eta)\), while the selected denominator is at most
\(c(1+\eta)\), so their ratio has liminf at least one. This does not
assume that auxiliary degrees belong to the selected subsequence.
The discrepancy lower bound gives a lower exponential factor even if
\(A(v)\) diverges. The finite sum has eventually nonnegative terms.
Consequently, for every fixed \(l\geq2\),
\[
 d/t\geq\frac dl\sum_{i=1}^{l-1}(i/l)^n e^{(1-i/l)a/t}.
\]
Since \(n\geq1\), the omitted zero term is zero. This is exactly the
\(\sigma=1\) premise of the formal partition theorem. Its contradiction
under the chosen strict threshold rules out infinitely many bad degrees.
Every remaining nonzero admitted test has a nonempty closed center through
\(x\); a zero-dimensional integral center is \(\{x\}\).

The quantifiers and order are essential: fix \(t\), take a liminf sequence,
differentiate separately for each finite reference basis, take \(m\to\infty\)
at fixed \(l\), then remove the partition error. No convergent models, fixed
center, upper discrepancy bound, or uniform derivative radius is needed.

## External assumptions, evidence and provenance

`minimization.tex`, `prop:ordinary-gap`, `lem:min-coercivity`,
`prop:minimizers` and `lem:specialization`, are the exposed upstream
assertions. The old draft does not independently establish them.
Stacks Proposition 33.45.13, tag `0BJ8`, supplies the ambient Hilbert
asymptotic; its quoted hypotheses appear in the historical source excerpts.
The restriction/weighted-growth units carry their own standard inputs.

The source versions and all 17 old claim records are bound in
`../input_bindings.json`. The exact checker was freshly replayed without
writing to old inputs. The fresh Lean certificate proves only the scalar
consequence of the just-derived all-length inequalities, not their
geometric derivation. No empirical replay of an algebraic variety can stand
in for this universal prose argument.

The old ledger has supporting `reviewer:copilot` opinions for this bridge
and its components, but `inconclusive` opinions for the upstream bundle,
minimizer assumption and specialization assumption. Its progress receipt is
simultaneously `pending`, `acceptance_recorded:false`, and its `PCREVIEW`
graph node is open. These records are not identical kinds of evidence:
the supporting opinions may be retained at their conditional scope, but
their independent authority and family acceptance cannot be inferred.

## Concrete remaining obligations

For the displayed conditional implication, no mathematical gap was found;
native independent review of the finite-to-limit extraction remains required.
For an unconditional point-center conclusion from nongeneration, one must
establish the strict ordinary-order alternative, uniform positive sublevel
and discrepancy bounds, fixed-flag/SNC attainment, and the closed-locus
specialization comparison. These are specific unreviewed propositions, not
an assertion that the manuscript is either correct or false.

For Fujita's main theorem, one additionally needs the rational supporting
profile/isolating ideal and `lem:isolated-equality`, plus the lifting and
descent argument in `isolation.tex`. Its vanishing input is
Kawamata-Viehweg for the constructed nef and big fractional-boundary divisor,
followed by a restriction surjection and a descended section nonzero at
\(x\). These were read only to identify the boundary, not newly audited.
The reference files for those steps are supporting/excluded upstream-source
material, not omitted old Argus drafts. No full-paper acceptance or verified
novelty is claimed.
