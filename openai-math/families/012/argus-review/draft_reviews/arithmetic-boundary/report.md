# Arithmetic boundary: bounded Engineer source assessment

**Date:** 2026-11-07. **Disposition:** attribution and conditional-use boundary
supported; the arithmetic inputs and the joint law remain unverified by this
old Argus draft. Independent review and acceptance are pending.

This assesses exactly `U_EQ23`, `U_EQ24`, `U_EQ44`, `U_M_ROW`, `U_ROOT21`,
`U_LABEL_REDUCTION`, and `C_JOINT_DICKMAN`, all version 1. The old ledger
contains 23 claim versions and 16 distinct IDs, not 23 separate results.
The seven entries begin at old `research/MATH_STATE.json` lines 142, 156,
170, 184, 376, 390, and 362, respectively. Their old open status is historical
data, not a current acceptance decision. The old report itself explicitly
leaves these inputs unestablished (`adaptive-cut-transfer/report.md:23-30`).

This is not a native independent Reviewer assessment, a new manuscript-error
search, or a proof of the reference manuscript. The conditional transfer and
its finite-size bounds belong to the other review units; no acceptance of
them is assumed here.

## 1. Attribution, source version, and actual content comparison

The primary source is the **original unpublished manuscript**, OpenAI,
*The joint Dickman law for consecutive integers*, dated September 24, 2026
(`build/main.tex:3-5`). The target assertions are attributed to that source,
not to Argus or this assessment.

The existing manifest is
`../9100012/MANUSCRIPTS.json`, which records revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its source directory is:

```
openai-math/preprints/
The-joint-Dickman-law-for-consecutive-integers-September-24-2026
```

The old `research/openai_manuscript/<manuscript-id>` resolves to this same
directory: it is a live reference symlink, not an independently preserved
manuscript copy. Below, section-file citations are relative to its
`build/sections/` directory; old-draft citations are relative to `../9000012/`.

**Actual comparison performed:** current bytes of all 13 manifest-listed TeX
files were compared against their **existing** SHA-256 digests, using the
specified Argus virtual-environment Python and `hashlib.file_digest`.
The result was **13/13 matches, no missing files, no mismatches**:

| Manifest-listed TeX file | Result |
|---|---|
| `build/main.tex` | Match |
| `build/preamble.tex` | Match |
| `build/sections/amplification.tex` | Match |
| `build/sections/arithmetic.tex` | Match |
| `build/sections/channels.tex` | Match |
| `build/sections/conclusion.tex` | Match |
| `build/sections/distribution.tex` | Match |
| `build/sections/graph.tex` | Match |
| `build/sections/introduction.tex` | Match |
| `build/sections/kernel.tex` | Match |
| `build/sections/labels.tex` | Match |
| `build/sections/moments.tex` | Match |
| `build/sections/sampling.tex` | Match; byte-digest comparison only |

No `sampling.tex` text or mathematical argument was inspected; its substantive
assessment remains with the lead. No new digest values, snapshot, provenance
packet, Git state, or old-workspace files were written. Digest equality is
evidence of agreement with the existing manifest, **not** independent
authentication of the recorded revision or validation of its mathematics.
Non-TeX metadata and bibliography were not covered by this comparison.

## 2. Shared hypotheses and normalizations

* `arithmetic.tex:13-18` sets
  \(T=\lfloor B^{.32}\rfloor\), \(P_0=B^{1000}\), and
  \(\mathcal P=\{p:P_0<p\le e^{4B}\}\). The original counting scale \(x\)
  tends to infinity at **fixed \(B\)** before \(B\to\infty\).
* `graph.tex:145-168` sets \(M=\lceil C_6T\rceil\), with fixed
  \(0<\eta<1\), \(C_6>1\), and allowed pairs
  \(\eta T\le |k-i|\le T\). All matrices are zero on other pairs,
  including the diagonal.
* \(\Omega_B\) is the finite set of subsets of \(\mathcal P\), with
  independent prime inclusions of probabilities \(1/p\)
  (`channels.tex:21-25`). The **model** sites \(S_i\) are independent.
  The actual residue sites \(S_i(u)=\{p:p\mid u+i\}\) are not independent:
  at each \(p>M\), hits at different positions are disjoint
  (`graph.tex:196-207`). Their comparison is an obligation, not a premise
  that can be imposed on the integer labels.
* The cut norm is
  \[
  \|H\|_\square=\frac1M\max_{\epsilon,\delta\in\{-1,1\}^M}
       \left|\sum_{i,k}H_{ik}\epsilon_i\delta_k\right|,
  \]
  **not** the usual dense-graph \(M^{-2}\) normalization
  (`graph.tex:170-174`). For \(|z_i|\le2\), the label energy is bounded
  by \(16\|H\|_\square\) (`graph.tex:175-188`), without independence
  between labels and residue data.
* First and squared-row bounds below are **unnormalized row sums**.
  Integrated tests and total matrix mass use \(1/M\). A restricted
  subset of positions retains that same \(M\), not its cardinality.
  Uniformity is for fixed regularity parameters, smooth weights,
  \(\eta,C_6\), and chosen coarse partition, with \(s\) in the fixed
  compact support. It is not uniformity for these parameters growing
  arbitrarily with \(B\) or simultaneously with \(x\).

## 3. Seven claim assessments

### U_EQ23 v1 — every-type conditional first moments

**Exact source:** `graph.tex:252-261`, Lemma
`lem:graph-row-mean`, equation `eq:23`; proof `263-286`.
The latent kernel is defined in `graph.tex:234-250`, equation `eq:20`.

For **every possible fixed endpoint type** \(S_i\), and every allowed
signed lag \(j=k-i\), the source asserts
\[
 \mathbb E_{S_k}\mathcal L_{ik}(S_i,S_k;s)
       \ll \Sigma(j)/T.
\]
The expectation is over the other independent endpoint only. Summing lags
gives every-type conditional expected degree \(O(1)\), and
\(\mathbb E\sum_{i,k}\mathcal L_{ik}=O(M)\).
The compact-\(s\) uniformity is specified at `graph.tex:8-12`.
\(\Sigma(j)=\prod_{p\mid j}(1+C_2/p)\) and its bounded ordinary means
are recorded at `arithmetic.tex:588-599`.

**Decisive source mechanism inspected:** the exact fair-split identity
\(A(b)K(S_i\setminus b)=B2^{-|S_i|}\), followed by the split-product
majorant `arithmetic.tex:346-352` (4) and the two-form coefficient
estimate `arithmetic.tex:601-608` (6). The remaining split expectation
has mass at most one; it is **not divided by the probability of an
admissible or typical split**. A type with no admissible split gives zero.
This explains why the assertion really is every-type, rather than a
typical-type estimate.

**Fidelity:** the old ledger reproduces this scope faithfully. It would be
an overstatement to read it as a pointwise realized degree bound or as any
conditional second-moment bound.

**Unresolved obligation:** establish the cited local split-product and
uniform sieve/coefficient bounds and their applicability to these truncated
weights, with the stated constants and signed-lag symmetry. The finite-array
Lean core and finite examples do not establish these arithmetic inputs.

### U_EQ24 v1 — integrated squared rows

**Exact source:** `moments.tex:22-38`, Proposition
`prop:moments:rows`, equation `eq:24`; parameter qualifications
`13-20`; final deduction `630-698`.

After a sufficiently fine **fixed** regularity grid and then sufficiently
small **fixed** tolerance, the assertion is
\[
 \sup_{1\le i\le M}\sum_{k\ne i}
        \mathbb E_{S_i,S_k}\mathcal L_{ik}^{\,2}
       \ll B^{-.21}.
\]
Both endpoints are integrated. The source also asserts
\[
 \mathbb E\left(\frac1M\sum_{i,k}\mathcal L_{ik}\right)^2\ll1.
\]
For every deterministic subset \(I\) of positions the estimates persist
after zeroing entries outside \(I\times I\), retaining normalization \(M\).
Constants may depend on the fixed parameters, but not on positions, \(s\),
or the first representation.

**Decisive source mechanism inspected:** weighting a first representation
changes the remaining-prime probabilities to \(1/(2p-1)\), with bounded
normalizers \(\Xi(a),\Xi(b)\), rather than conditioning on regularity
(`moments.tex:69-148`). The crucial multiplicity assertion is
`lem:moments:multiplicity`, `150-162`:
\[
 \mathbb E^{\rm tilt}_{a,b}
 [1_{\mathcal T_b\ {\rm regular}}1_{\mathcal T_a\ {\rm regular}}
           N_{a,b,c}]\ll B^{.009}.
\]
At `638-668` this is combined with the small individual contribution,
the three-form bound (7), and bounded means of \(\Sigma\).
The compatible tolerance inequalities are `arithmetic.tex:710-721`;
they leave an exponent below \(-.220\) before the \(o(1)\), hence room
for \(-.21\). The total-mass estimate then uses conditional variance,
(23), and Jensen across rows (`moments.tex:671-698`).

**Fidelity:** faithful, but the ledger's short formulation omits the grid
and tolerance qualifications. This is **not**
\(\sup_{S_i}\sum_k\mathbb E_{S_k}\mathcal L_{ik}^{\,2}
\ll B^{-.21}\). Small individual representations alone also do not prove
the result: multiplicity must be controlled under the displayed tilted
measure, with regularity indicators retained.

**Unresolved obligation:** prove that uniform weighted multiplicity estimate
and its sieve/regularity prerequisites, and justify the change-of-measure
normalizations and exponent bookkeeping over all allowed representations.
Only the final conditional variance/Jensen implication is elementary once
those inputs and (23) are granted. No arithmetic multiplicity proof was
independently verified here.

### U_EQ44 v1 — all separate bounded single-site tests

**Exact source:** `kernel.tex:736-751`, Proposition
`prop:kernel-comparison`, equation `eq:44`; proof `760-800`;
fixed-parameter context `1-38`.

For the specific comparator (43), put
\(\mathcal E_{ik}=\mathcal L_{ik}-\mathcal M_{ik}\).
Given \(\epsilon_1>0\), choose the fixed coarse partition furnished by
`channels.tex:70-84`, especially (32). The assertion is
\[
 \sup_{\substack{g_i,h_k:\Omega_B\to[-1,1]\\\text{real measurable}}}
 \frac1M\left|\sum_{i,k}
  \mathbb E_{S_i,S_k}
   [\mathcal E_{ik}(S_i,S_k;s)g_i(S_i)h_k(S_k)]\right|
 \le Ce^{-c_3C_*}+C_\eta\epsilon_1+o(1).
\]
There are **separate functions at every position**, and separate row
and column families. Zero tests, including zeros on removed positions,
are allowed. These are functions of one local site, not arbitrary
functions of the full sampled configuration. The diagonal is already
zero, not a prescription to replace a site by an independent copy there.
The remainder is uniform in all these tests and in \(s\).

Writing \(E_0=Ce^{-c_3C_*}+C_\eta\epsilon_1\), a nonnegative uniform
majorant \(\rho_B=o(1)\) gives the old transfer's
\(\beta=E_0+\rho_B\). There is **no asserted polynomial rate for
\(\rho_B\)**. The coefficient of the exponential term is independent
of \(\eta,C_6,C_*\); other fixed-parameter dependencies must not be
silently removed.

**Decisive source mechanism inspected:** the proposition's proof collects
edgewise cutoff, projection, series-tail and archimedean/coarse errors.
Uniform edgewise bounds permit the tests to vary with position.
There are at most \(M\) pairs per positive lag, so division by \(M\)
and both lag signs leave at most twice the lag-error sum—not an extra
factor \(C_6\). The cutoff estimate (33), `kernel.tex:70-86`, explicitly
has the stronger constant independence required for the exponential term.

**Fidelity:** faithful as an attributed integrated comparison. Identifying
this supremum directly with the expectation of the **sample-adaptive**
cut norm would overstate it; that passage is precisely the separate
conditional-transfer problem.

**Unresolved obligation:** establish the cutoff-loss estimates, uniform
channel/projection bounds, arithmetic kernel approximation and convergence
of the accumulated errors in the stated ranges. Inspecting their collection
does not independently certify the preceding arithmetic analysis.

### U_M_ROW v1 — comparator rows and endpoint structure

**Exact source:** comparator definition `kernel.tex:675-709`, equation
`eq:43`; deterministic estimates `753-758`,
`eq:kernel-main-row-bounds`; proof `802-820`. The independent finite
site law is separately specified at `channels.tex:21-25` and
`graph.tex:196-207`; latent symmetry/zero extension is at `graph.tex:234-250`.

For **every realization** of all site types, uniformly in block length and
the compact \(s\)-range, the asserted comparator bounds are
\[
 \sup_i\sum_k|\mathcal M_{ik}|\ll_{\eta,m_1}1,\qquad
 \sup_i\sum_k|\mathcal M_{ik}|^2\ll_{\eta,m_1}T^{-1}.
\]
They are deterministic row sums, not averaged statements and not normalized
by \(M\). Formula (43) is symmetric in endpoints, uses \(|j|\), and is zero
off allowed pairs, so the diagonal is zero. Its features satisfy
\(0\le V_l(S)\le |I_l|^{-1}\), with fixed finite \(m_1\).
The kernel domains are finite for each \(B\); this does not assert a
uniform bound on the number of types as \(B\) grows.

**Decisive source mechanism inspected:** bounded features, \(k_B\), and
\(w\) give
\[
 |\mathcal M_{ik}|\le
       (C_{\eta,m_1}/T)\,|k-i|/\varphi(|k-i|).
\]
Each row has at most two entries per positive lag. The first and second
ordinary means of \(j/\varphi(j)\) then give the two displayed estimates.
The second bound is stronger than \(B^{-.21}\), since \(T\asymp B^{.32}\).

**Fidelity:** faithful with an attribution clarification: independence is
a property of the **chosen model law**, not a deterministic consequence
of row bounds and not a property of the actual residue sites.

**Unresolved obligation:** independently check the bounded feature and
smooth-kernel prerequisites and the required ordinary means, and preserve
the actual/model distinction in applying the transfer. Symmetry and zero
diagonal can be read directly from the formulas; that does not verify the
arithmetic comparison that produced this comparator.

### U_ROOT21 v1 — independent-root expected cut comparison

**Exact source:** `graph.tex:295-313`, Proposition
`prop:graph-root-comparison`, equation `eq:21`; proof `315-480`.
The actual source label is **`prop:graph-root-comparison`**, not
`graph-cut-comparison`.

For any proposed symmetric real endpoint comparator, zero on nonpairs,
whose **total unnormalized absolute matrix mass is \(O(B^{10})\)
uniformly in its arguments**, the source asserts
\[
 \mathbb E_{u\in\widehat{\mathbb Z}}
   \|(\mathcal K_{k-i}(u+i,s)
          -\mathcal M_{ik}(S_i(u),S_k(u);s))_{i,k}\|_\square
 \le o(1)+
 \mathbb E_{(S_i)\ {\rm independent}}
   \|(\mathcal L_{ik}(S_i,S_k;s)
          -\mathcal M_{ik}(S_i,S_k;s))_{i,k}\|_\square .
\]
Both norms have the \(1/M\) normalization above; expectation is **outside
the maximizing signs**. This is neither equality nor merely comparison
against one preselected pair of tests. The error is uniform in \(s\),
with the polynomial mass bound understood for the chosen comparator
family; the statement does not discard its implicit constant.

**Decisive source mechanism inspected:** couple actual site sets to the
independent law; control site squares in the weights; discard coincident
rational roots and forced hits at third endpoints; then couple the
remaining residue tests to independent extra-root sets. The proof explicitly
avoids conditioning higher digits on absence of site squares. Polynomial
candidate/mass bounds pay for coupling failures. Finally, conditional
Bernstein bounds and a union over all \(2^{2M}\) signs control fluctuations
of the extra weights, rather than just their conditional mean.

There is an internal dependency worth preserving: `graph.tex:473-475`
explicitly uses the every-type mean lemma (23), plus Jensen, to make the
expected fluctuation small. The old graph's empty `depends_on` list for
this externally supplied input is not evidence that its manuscript proof
is mathematically independent of (23).

**Fidelity:** the old statement accurately records the source's comparator
class and expected-cut conclusion. The specific comparator's row bound,
if granted, supplies a total mass \(O(M)\), comfortably within its
polynomial hypothesis.

**Unresolved obligation:** rigorously establish all those root/site
couplings, exceptional-event weights and uniform fluctuation estimates
for these arithmetic kernels. Neither a finite endpoint model nor the
deterministic Lean inequalities prove this passage from actual integers.

### U_LABEL_REDUCTION v1 — a concrete bundle, not one proved lemma

The old wording is faithful as a **scope reservation**, but it is not an
exact stand-alone theorem. Its necessary mathematical contents can be
located and separated as follows.

1. **Labels, marginals and the actual cancellation target.**
   `labels.tex:14-70` defines bins, two independently chosen unit-modulus
   phase vectors, \(F_x=f_x-\mu\), \(|F_x|\le2\), fixed-residue marginal
   limits and fixed-multiplier invariance. The centered \(F_x\) is not
   multiplicative. Proposition `prop:mixed`, `207-216`, requires
   \[
   x^{-1}\sum_{1\le n<x}\overline{g_x(n)}F_x(n+1)\to0
   \]
   through **all integer scales**, for every fixed \(J\ge2\) and every
   pair of fixed phase vectors, not just identical vectors.

2. **The precise short-average input.**
   Lemma `lem:labels-short`, `labels.tex:223-264`, uses finite prime sets
   \(P_B\) with \(\min P_B\to\infty\), any \(T(B)\to\infty\),
   \(L_B\to\infty\), any integer starts \(a_B\), and fixed
   \(s_0,s_1,D,r,v\), with \(v\ge0\). It asserts
   \[
   \lim_{B\to\infty}\limsup_{x\to\infty}
   \frac1{Tx}\sum_{s_0Tx\le n\le s_1Tx}
   \left|\frac1{L_B}
      \sum_{\substack{a_B<i\le a_B+L_B\\i\equiv r\ (D)}}
       F_x(n+i)G_{B,v}(n+i)\right|^2=0,
   \quad
   G_{B,v}(m)=\prod_{\substack{p\in P_B\\p\mid m}}
                    \frac{1+p^{-v/B}}2 .
   \]
   This is a weighted mean-square statement with a prescribed iterated
   limit, not pointwise cancellation on every short interval.
   The proof at `437-547` uses fixed finite interpolation by nonnegative
   multiplicative functions; principal-character long means vanish via
   the marginal lemma, while nonprincipal twists use
   `lem:labels-character-distance`, `340-355`.
   The manuscript attributes the real short-interval comparison and
   complex short averages to Matomäki--Radziwiłł (Theorem 1) and the
   corrected Matomäki--Radziwiłł--Tao Theorem A.1, respectively
   (`labels.tex:294-324`). Their exact applicability and uniformity are
   **external obligations here**, not established by their bibliography
   entries or by this source inspection.

3. **From failed decorrelation to positive arithmetic energy.**
   `labels.tex:549-621` extracts a bounded profinite profile \(W\) and a
   fixed nonnegative smooth \(\phi\) with nonzero profile integral.
   `amplification.tex:86-99`, `lem:amp-divisor-moments`, requires
   \(\|D_B\|_2=O_{C_*}(1)\) and Haar mean at least \(d_0>0\), with
   \(d_0\) independent of \(C_*\). Preservation of the profile is
   `amplification.tex:566-621`. Proposition `prop:amp-energy`,
   `644-671`, then requires
   \(\liminf_B\liminf_x I_{2,x}/(BT)\ge c_5>0\), with \(c_5\)
   independent of sufficiently large fixed \(C_*\), and negligible
   equal-coefficient diagonal. The divisor-moment and arithmetic
   concentration proofs have not been independently certified here.
   `graph.tex:14-43`, `62-111`, and `145-188` describe the exact
   reindexing into shifts and the block energy (19), including
   \(O(\eta)+O(1/C_6)\) losses. This uses fixed-multiplier invariance
   at fixed \(B\), not multiplicativity of \(F_x\).

4. **Vanishing of the comparator energy and the parameter order.**
   `conclusion.tex:23-31` defines
   \(\mathcal Q^{\rm main}_{B,x}\), with \(1/(Tx)\) on origins and
   \(1/M\) inside. Lemma `lem:conclusion-features`, `35-63`, approximates
   each feature in the independent-site \(L^2\) law by a fixed finite
   linear combination of the \(G_{B,v}\). Finite-residue counting and
   lag row bounds, `114-159`, allow this replacement against the
   possibly dependent labels. Lemma `lem:conclusion-periodic`,
   `161-178`, approximates the singular series in ordinary lag mean
   by a fixed-period function. Proposition
   `prop:conclusion-main-vanishes`, `217-223`, asserts
   \(\lim_B\limsup_x|\mathcal Q^{\rm main}_{B,x}|=0\) for the fixed
   parameters; its factorization into short averages is displayed at
   `287-335`.
   Finally `conclusion.tex:345-412`, especially (the final-upper equation)
   `383-402`, assembles the diagonal, block, (21), sampling-interface
   (45), and main-energy errors. It first chooses \(C_*\), then
   \(\eta,C_6\), then \(\epsilon_1,\epsilon_2\) and the coarse partition,
   then the feature/periodic/block approximations, before the iterated
   limits. Independence of the leading constants from later choices is
   necessary to contradict \(c_5\); it is not supplied by a finite check.
   This reads the interface **as cited in conclusion.tex**, not the
   source or proof of `sampling.tex`.

5. **The final distribution deductions.**
   `distribution.tex:14-55` uses the full pair of bin characters and
   finite Fourier inversion modulo \(J+1\), since bin counts lie in
   \(\{0,\ldots,J\}\). The Dickman marginal is identified from factorial
   moments and its delay equation at `64-156`, with continuous
   distribution function \(D\) at `158-173`.
   The fixed-threshold joint law first holds at rational exponents and
   integer scales (`177-185`); `186-212` squeezes arbitrary real
   exponents and real endpoints using \(x=\lfloor X\rfloor+1\) and
   \(x/X\to1\). The proof of `thm:main`, `239-260`, removes
   \(n<\varepsilon X\), costing at most \(\varepsilon+O(1/X)\), and
   squeezes \(n^a,n^b\) between fixed \(X\)-power thresholds on the
   rest. These displayed conditional counting/continuity deductions
   preserve ordinary density and the endpoint normalization; they
   do not establish the upstream mixed decorrelation.

**Assessment:** these are identifiable, substantive obligations beyond
sampling, not an unexplained assertion that “the rest of the paper is
correct.” Their dependency structure and displayed normalizations were
checked at this bounded source level. Full proofs of the label inputs,
divisor moments, energy reductions, arithmetic prerequisites and their
external short-interval applications remain unverified here. The old
Argus work contains no independent proof of this whole bundle.

### C_JOINT_DICKMAN v1 — the unproved downstream theorem

**Exact source:** `introduction.tex:19-29`, `thm:main`; definitions of
\(P^+\) and \(\rho\) at `3-9`; final source deduction
`distribution.tex:175-260`.

For **each fixed** \(a,b\in(0,1)\), the manuscript asserts
\[
 \lim_{\substack{X\to\infty\\X\ {\rm real}}}\frac1X
 \#\{2\le n\le X:\ P^+(n)\le n^a,\ P^+(n+1)\le n^b\}
       =\rho(1/a)\rho(1/b).
\]
Counting is ordinary and unweighted, through all real endpoints.
The second threshold is **\(n^b\), not \((n+1)^b\)**, and the second
logarithmic coordinate uses \(\log n\). The theorem is not a
logarithmically averaged result, an almost-all-scales statement, a
quantitative error bound, or uniformity for varying \(a,b\).

**Fidelity:** the old ledger states precisely this theorem and explicitly
says the campaign has not established it. There is no source mismatch
or new refutation in that attribution. A version with \((n+1)^b\) is not
the literal statement assessed, regardless of possible continuity-based
equivalences.

**Unresolved obligation:** complete the upstream arithmetic, root
comparison, label/amplification/main-energy route and conditional sampling
interface, and then the final distribution deductions with their actual
hypotheses. The old route `R_MAIN_DICKMAN` is a conjunction of required
inputs, not an independent proof of the theorem.

## 4. What the old formal and finite evidence cannot discharge

The deterministic Lean scope described in old
`research/adaptive-cut-transfer/statement_fidelity.md:1-39` is arbitrary
finite real-array response, endpoint-deletion and good-configuration
inequalities. It explicitly does not encode independence, conditional
expectations, concentration, the universal probabilistic transfer, or
arithmetic properties of these kernels. No Lean compilation or old finite
checker was rerun for this source-assessment unit; their replay and
statement fidelity belong to other units.

Conditionally on (23), (24), and the comparator rows, the elementary
adapter \(H=\mathcal L+|\mathcal M|\) has \(|\mathcal E|\le H\),
every-type first rows \(O(1)\), and integrated squared rows
\[
 \sum_k\mathbb E H_{ik}^2
 \le2\sum_k\mathbb E\mathcal L_{ik}^2
       +2\sum_k\mathbb E|\mathcal M_{ik}|^2
       =O(B^{-.21}).
\]
This explains the old transfer interface without upgrading integrated
second moments to uniform conditional ones. It is an implication **from
unverified arithmetic inputs**, not their verification. Finite matrices,
rare-type examples, exact rational checks and deterministic certificates
cannot establish asymptotic prime/sieve estimates, the root coupling,
short-interval label cancellation, or natural density at all real scales.

No novelty claim, new independent proof, or certified counterexample is
made. Published results named by the manuscript have not been treated as
verified merely because their names occur in its bibliography. Independent
review of the assumptions remains the Host's responsibility.

## 5. Handoff to the lead; no ledger edits

The active `RV_SAMPLING` registrations A23, A24, A44 and AMROW have the
correct conditional boundary. **No mathematical reversal of those
assumptions is indicated by this assessment.** Source-precision refinements:

* **A23:** use `graph.tex:252-286`; retain the explicit every-type,
  other-endpoint-first-moment interpretation and compact-\(s\) uniformity.
* **A24:** use `moments.tex:13-38`; include the sufficiently fine fixed
  grid and then small fixed tolerance, both-endpoint integration, and
  unchanged \(M\) for subset restrictions.
* **A44:** use `kernel.tex:736-751`; specify
  \(E_0=Ce^{-c_3C_*}+C_\eta\epsilon_1\), the independent leading
  exponential coefficient, separate local tests including zero, and no
  rate for the uniform remainder.
* **AMROW:** use `kernel.tex:675-709,753-820` for formula, symmetry,
  nonpairs and deterministic rows; use `channels.tex:21-25` and
  `graph.tex:196-207` for finite independent **model** sites. Independence
  must not be attributed to actual residue sites or to row estimates.
* The old report's broad `kernel.tex:739-850` citation extends past the
  actual EOF at line **820**; the precise statement starts at **736**.
  For (21), the actual label is `prop:graph-root-comparison`,
  `graph.tex:295-313`. Its source proof uses (23).
* Keep `U_LABEL_REDUCTION` as the explicit bundle above and
  `C_JOINT_DICKMAN` unresolved; none of A23/A24/A44/AMROW alone, nor their
  conditional sampling consequence, discharges that bundle or (21).

Only this unit's `report.md` and `verdict.json` were written. This completes
the bounded Engineer source assessment, **not** independent acceptance of
these claims, of another unit, or of the family review.
