# Reverse-exposure safety and residual encoding

## Conclusion and scope

**No substantive false assertion or exact counterexample was identified in the two scoped arguments.** The adaptive exposure, the hybrid comparison, and the timeline-independent residual count have valid local justifications as written, provided the density/path/grouping properties they explicitly invoke are supplied by the definitions elsewhere. This is a bounded mathematical investigation, not an independent Reviewer acceptance or a verification of the full expected-minimum theorem.

Source locators below are relative to
`research/openai_manuscript/One-Sample-Suffices-for-Matroid-Prophet-Inequalities-against-an-Almighty-Adversary-September-23-2026/build/sections/`.
The source analysis concerns `safety.tex`, `transfer.tex`, and the generator lemma in `algorithm.tex:308–345`. No external reference is used as evidence.

The main potentially dangerous assertions are quoted below. None was found false under its stated conditioning. In particular, conditioning on an auxiliary exposure transcript must not be confused with conditioning on the adversary's complete information.

## 1. Reverse exposure: the filtration does not leak unused bits

The recursion and departing-query rule are in `safety.tex:43–92`. At reverse time \(k\), write \(S=X(k+1)\), \(N=\mathcal G_k(C,S)\). The important facts are:

1. \(N_j\) is computed before querying any current-group guard bit.
2. Every possible output satisfies \(N_j\subseteq S_j\).
3. Since \(N_j\) is a flat, adjoining guard labels already in \(N_j\) has no effect. Thus only
   \[
   G_j\cap(S_j\setminus N_j)
   \]
   needs to be queried.
4. The next domain is predictable from the existing transcript. Different groups have disjoint labels; different reverse steps for one group have disjoint departing sets.

The containment in item 2 uses the nesting and monotonicity stated at `safety.tex:60–67`: inductively \(A_{j-1}\subseteq S_{j-1}\subseteq F_{j-1}(k+1)\), hence
\[
Q_{j,k}(A_{j-1})\subseteq Q_{j,k+1}(F_{j-1}(k+1))=S_j.
\]
All additions used to form \(A_j\) also belong to the flat \(S_j\). Therefore its closure remains inside \(S_j\).

Consequently a transcript fixes values only at its queried coordinates. Conditional on it, the remaining coordinates in the relevant groups retain their original joint product law. In particular, the statement

> “Conditional on \(\mathcal H_b\), the unqueried bits on [\(V_b\)] are jointly independent Bernoulli bits of rate \(t\).”

at `safety.tex:83–89` is justified. Although the *set* of remaining coordinates is random, it is fixed after conditioning on the transcript, and every preceding query was chosen without looking at the value it was about to query.

The predictable-hazard assertion

> “Before exit, these probabilities are nondecreasing in the order of the reverse computation.”

at `safety.tex:99–105` also follows. Couple two prospective transitions with one independent mask \(\xi\) on the original coordinate universe. A smaller time and smaller incoming state give a smaller output under the same \(\xi\). On a surviving trajectory this makes the next exit probability no smaller. No coupling of the actual previously queried bits is required.

### Full-seed adversaries

The filtration is an analytical filtration, not the adversary's information; this distinction is explicit at `safety.tex:38–41` and `90–92`. An adversary can know all guard/test bits without invalidating expectations computed using a smaller analytical sigma-field. What would be invalid is additionally conditioning these product-law claims on an arbitrary seed-dependent arrival order or acceptance history. The scoped proof does not do that.

## 2. The disjoint-certificate budget handles adaptive transactions

The lemma and proof are `safety.tex:120–187`. Its logarithmic resource argument is valid even when queries, transaction boundaries, and termination are adaptive.

For remaining coordinates \(V\), let \(p(V)\) be failure probability with coordinates outside \(V\) set to zero. Let \(I\) be the current transaction's positive answers and let \(p_I(V)\) be failure probability with these coordinates forced to one. Monotonicity gives
\[
\delta\le p(V)\le1,\qquad 0\le Z:=p_I(V)/p(V)\le1.
\]
For the next queried coordinate \(e\), put \(V'=V\setminus\{e\}\). Conditional on the transcript, its law is still its original Bernoulli law, so
\[
\mathbb E[Z-Z'\mid\text{transcript}]
=Z\left(1-\frac{p(V)}{p(V')}\right)
\le \log p(V')-\log p(V).
\]
The denominator on the right after querying is the same for either answer. This is the important reason the calculation survives adaptive choice of the next coordinate.

A transaction starts at \(Z=1\). If its positives certify the event, it ends at \(Z=0\); otherwise \(1-Z_{\rm end}\ge0\). Its success indicator is therefore at most its realized net decrement. Resetting the transaction resets \(I\), not the depleted set \(V\). The \(\log p(V)\) increments telescope across all transactions and cost at most \(-\log\delta\). Finite query and transaction bounds justify summation without an unbounded stopping argument.

### Why earlier positive answers need not enter a later certificate

The high-risk sentence is:

> “Evaluating \(\mathcal G_k(c^I,S)\), with every other guard bit set to zero, gives the same output as the actual step.”

at `safety.tex:218–225`. This is correct **with the actual incoming state \(S\) held fixed**. Induct over groups. The nominal flat \(N_j\) is unchanged because it depends on preceding groups' reconstructed intermediate flats, not current-group guard bits. Every positive addition outside \(N_j\) was queried in this step and is in \(I\). Positive additions inside \(N_j\) are redundant. Previously queried coordinates lie outside the current input domain.

For a hazard band's entry time/state \(k_0,S^0\), monotonicity then gives
\[
\mathcal G_k(c^I,S)\subseteq\mathcal G_{k_0}(c^I,S^0).
\]
A non-exit certifies the fixed increasing survival event at entry using only this step's positives. The proof does **not** recompute \(S\) after deleting earlier positive answers; `safety.tex:231–233` expressly rules out that invalid shortcut.

### Exit mass and indices

The band argument is `safety.tex:202–250`. A band \([p_0,2p_0)\) has expected non-exit count at most \(\log(1/p_0)\), and at most one exit step. Its exit probability is thus at most
\[
2p_0\bigl(\log(1/p_0)+1\bigr).
\]
For hazards below \(\eta=2^{-12}\), the dyadic bands give exactly
\[
2^{-11}(14\log2+1)<15/2048<1/2.
\]
Together with eventual exit at \(X_h(a_h-1)=L\), this proves
\[
\sum_{b=a_h}^{0}\mathbb E[
 {\bf1}_{d\in X_h(b)}p_{b-1}^2\mid H,D]\ge\eta/2.
\]
Here \(p_{b-1}\) is the hazard of birth **\(b\)**, not birth \(b-1\). The indexing in the subsequent hybrid argument is consistent with this.

## 3. Hybrid law and deterministic protection

The hybrid is constructed at `safety.tex:269–285`, and its conditional law is justified at `287–310`. It retains \(C\) on coordinates not queried during the ordinary step and substitutes the independent same-rate mask \(T\) on coordinates queried during that step.

The assertion

> “Consequently the whole hybrid vector on the input domains has the fresh product law, conditional on \(\mathcal H_{b-1}\).”

at `safety.tex:291–293` is valid. Conditional on the complete ordinary-step transcript:

* the departing/retained partition is fixed;
* the retained \(C\)-bits have never been queried;
* all \(T\)-bits are independent of that transcript;
* the retained \(C\)-bits and substituted \(T\)-bits are jointly independent.

The frozen input \(S=X(b)\) is already determined by \(\mathcal H_b\). Therefore the hybrid output's conditional law given the finer transcript \(\mathcal H_{b-1}\) is the ordinary transition law determined by \(\mathcal H_b\). Since the ordinary output is measurable in the finer transcript, this proves conditional independence of the **two outputs**, and the double-exit probability is precisely
\[
{\bf1}_{d\in X_h(b)}p_{b-1}^2.
\]
It does not prove independence from the entire original guard mask. Nor does it prove independence of hybrid experiments at different endpoints; the manuscript explicitly disclaims the latter at `safety.tex:308–311`.

The deterministic inclusion at `safety.tex:313–339`,
\[
Q_h(F_{h-1}(b-2)\cup K_{h,b})\subseteq\widetilde N_h,
\]
has the right direction. At each lower group:

* monotonicity places \(X_j(b-2)\) in \(\widetilde N_j\);
* retained guard additions include \(C_j\cap X_j(b-1)\), hence generate \(F_j(b-2)\);
* substituted additions include \(T_j\cap(X_j(b)\setminus X_j(b-1))\);
* extensivity carries forward the test additions from earlier groups.

Thus \(\widetilde A_{h-1}\) spans \(F_{h-1}(b-2)\cup K_{h,b}\), and the enabled focal density map gives the inclusion. It holds for every complete bit assignment, even though \(F_{h-1}(b-2)\) has not yet been exposed in the analytical filtration. One must not condition on that future flat to justify the hybrid's product law; the proof does not.

Summing endpoint bounds uses linearity, not independence across endpoints.

### Baseline loss and parity

The safe-count conclusion is `safety.tex:355–384`. Given the invoked facts that \(X_h(a_h)=Q_h(L)\) and no birth occurs at \(a_h+1\), discarding invalid births costs at most
\[
|D_h\cap Y\cap Q_h(L)|\le \operatorname{rk}(Q_h(L))
\le |D_h|/\kappa.
\]
The first inequality uses independence of \(Y\). The fair independent parity halves the remaining count. In fact the displayed reasoning gives the stronger bound
\[
\mathbb E[\sigma_h\mid H,D]\ge
\frac{\eta}{4}|D_h\cap Y|-\frac{|D_h|}{2\kappa}.
\]
The stated bound with \(-|D_h|/\kappa\) is therefore conservative, not a factor-of-two error.

## 4. One generator budget really covers all times

The generator proof is `algorithm.tex:308–345`. Given the stated density-maximization objective, it is a rank-telescoping argument rather than a repeated charge at each time.

Let \(P_k=\operatorname{cl}(F_{h-1}(k)\cup X_h(k-1))\). Both this flat and \(X_h(k)\) are feasible, and monotonicity places the former inside the latter. Optimality yields
\[
\kappa\bigl(\operatorname{rk}X_h(k)-\operatorname{rk}P_k\bigr)
\le |D_h\cap X_h(k)|-|D_h\cap X_h(k-1)|.
\]
Also
\[
\operatorname{cl}\bigl(F_{h-1}(k)\cup(D_h\cap X_h(k))\bigr)=X_h(k):
\]
a proper subflat here would retain the same sample count at smaller rank and strictly improve the objective. Consequently an extension basis over \(P_k\) can be taken from \(D_h\cap X_h(k)\). Earlier generators already lie in \(P_k\), so newly chosen ones are distinct. Summing telescopes the right side and bounds the **union** of generators by \(|D_h|/\kappa\).

First appearance times of these generators give the insertion-time representation used at `transfer.tex:229–234`. No additional time-dependent generator budget is needed.

## 5. The marked-pivot lemma has no hidden ordering factor

The statement and proof are `transfer.tex:94–191`. The literal claim

> “In particular, all movable orders, positions, and marks have already been counted, with no additional permutation or timeline factor.”

at `transfer.tex:189–190` is justified by the following decomposition.

**Possible retained bases.** Delete an old occurrence redundant over its old predecessors. It remains redundant after any insertions, so this deletion preserves all pivot marks. Surviving old occurrences form an ordered basis \(b_1,\ldots,b_r\). For all movable labels \(A\), the fixed numbers
\[
\Delta_j=\operatorname{rk}(A\mid B_{j-1})
          -\operatorname{rk}(A\mid B_j)\in\{0,1\}
\]
sum to \(\operatorname{rk}(A)\le s\). When \(\Delta_j=0\), \(b_j\) remains independent even after all movable labels are present and cannot be omitted by greedy processing of any interleaving. Thus only at most \(s\) old positions can be omitted. Their subsets and the retained movable subsets give at most \(2^s2^s=4^s\) retained bases, regarded as collections of occurrences. Repeated labels cause no problem; an independent retained basis cannot retain two parallel copies of the same label.

**Pivot from a fixed basis.** For a retained basis \(J\), every nonloop \(f\) has a unique inclusion-minimal spanning support \(S_f\subseteq J\). Submodularity shows that the intersection of two spanning subsets of an independent set still spans \(f\). The pivot of \(f\) is precisely the last occurrence in \(S_f\), since the retained occurrences span every processed prefix.

**Orders and marks at once.** Fix signed, widely spaced powers of two for retained old occurrences. Any order and marks of at most \(s\) retained movable occurrences can be represented by assigning them signed powers in the gaps. The last absolute score dominates the sum of all earlier absolute scores. Hence its mark is the sign of the sum over \(S_f\).

Treating movable signed scores as at most \(s\) real variables makes these \(n\) sums affine functions. Every attainable pivot vector is an all-strict sign pattern, so there are at most
\[
\sum_{\ell=0}^{s}\binom n\ell
\]
patterns per retained basis. The arrangement recurrence, including constants, coincident hyperplanes, and zero restrictions, is supplied in `transfer.tex:175–187`; an external citation is not needed to close this step.

This auxiliary real sign representation is **not** a linear representation of the matroid. The proof uses matroid rank and independent-set supports and therefore does not require representability. Nonloops are necessary to avoid empty supports, and they are explicitly required in the lemma and invoked for the candidate labels at `transfer.tex:343–345`.

## 6. The two pivot tests encode the actual residual

### Conditioning and fixed old sequences

The conditioning is specified at `transfer.tex:205–227`: fix \(H\), parity, and \(D,C,T\) outside the true group \(U_i\), but neither its focal bits nor its listing event. Lower groups determine the potential index \(h\), incoming path \(F=F_{h-1}\), activation time, and all \(K_{h,b}\). The focal group's bits cannot affect a lower group. Thus both old sequences are fixed before the focal masks are exposed.

Put \(q=\lfloor n/\kappa\rfloor\). The generator union \(J\subseteq U_i\) has size at most \(q\). If \(z_h\le n/\kappa\), the disjoint witness union \(Z=\bigcup_b Z_b\) also has size at most \(q\). The family can enumerate the two subsets without encoding their actual insertion times.

### Exact span identities

The first sequence (`transfer.tex:241–254`) processes old \(F(k)\), then generators with insertion time \(k\); the whole block has mark \(1\) exactly for valid endpoints. Its endpoint span is \(X_h(k)\). Therefore its mark-\(1\) set is exactly the union of valid birth sets \(P_{h,b}\).

In the second sequence (`transfer.tex:256–305`), each chosen-parity layer has:

| Stage | Added occurrences | Mark | Resulting span |
|---|---|---|---|
| Start | Earlier layers | — | \(X_h(b-2)\) |
| Phase (i) | \(K_{h,b}\), then \(Z_b\) | \(0\) | \(\operatorname{cl}(X_h(b-2)\cup K_{h,b}\cup Z_b)\) |
| Phase (ii) | \(F(b)\), then generators with \(b-2<\tau(g)\le b\) | \(1\) | \(X_h(b)\) |

The last equality uses \(K_{h,b}\subseteq F(b)\), \(Z_b\subseteq X_h(b)\), and the generator representation. All earlier witnesses and competitors are absorbed into the preceding exact endpoint flat.

The postponement of a generator originally inserted at \(b-1\) is legitimate: the second sequence is not asserted to preserve \(X_h(b-1)\). It preserves the two endpoints and the explicitly desired phase-(i) span. A label with valid birth \(b\) lies outside \(X_h(b-1)\), hence outside \(X_h(b-2)\), and is spanned by the layer's end. Its second mark is \(1\) exactly when it is outside the phase-(i) span, which is exactly its residual membership.

Labels born at \(b-1\) may also receive second mark \(1\); the first test rejects them. The residual is therefore precisely the intersection of the two mark-\(1\) sets. Neither test alone would suffice.

### Size bound

There are at most \(S_q(n)^2\) subset pairs, where \(S_d(n)=\sum_{\ell=0}^d\binom n\ell\). Each sequence has at most \(2q\) movable occurrences. Therefore `transfer.tex:307–342` gives
\[
|\mathfrak R_i|
\le S_q(n)^2\bigl(4^{2q}S_{2q}(n)\bigr)^2,
\]
and
\[
\log|\mathfrak R_i|
\le\frac n\kappa(6\log\kappa+6+4\log2)
\le\frac{1000\log\kappa}{\kappa}n.
\]
The floors are valid: \(q\le n/\kappa\) and \(2q\le\lfloor2n/\kappa\rfloor\). The larger family permits arbitrary movable marks and placements, so it includes all actual witness choices without separately counting layer assignments.

## 7. The dependent residual is handled by a legitimate uniform union bound

The deterministic rank comparison is `transfer.tex:47–83`. The extension witnesses span every unsacrificed birth label over its base, so the residual lies in \(O=D\cup C\). A safe sample outside the residual lies in
\[
D_h\cap\bigl(\operatorname{cl}(Q'_b\cup Z_b)\setminus Q'_b\bigr),
\qquad Q'_b=Q_h(F_{h-1}(b-2)\cup K_{h,b}).
\]
The invoked density residual inequality charges these samples by at most \(\kappa|Z_b|\). Thus
\[
\sigma_h\le\kappa z_h+|\mathcal R_h|.
\]

Conditional on the information defining the uniform family, the focal indicators of \(O\) remain independent, each of probability
\[
p_O=\tfrac14+\tfrac34t\le\tfrac12.
\]
For every fixed member \(R_0\), its containment probability in \(O\) is at most \(2^{-|R_0|}\). The family is independent of the focal bits; its selected member need not be. No conditioning on listing is taken.

With \(\delta=2^{-26}\), the tail calculation in `transfer.tex:365–388` is valid:
\[
\Pr(\exists R_0\in\mathfrak R_i:
 R_0\subseteq O,\ |R_0|>\delta n)
\le 2^{-(2^{-26}-100000\,2^{-100})n}
\le2^{-2^{-27}n}<2^{-26}.
\]
Here \(n\ge2^{100}\) and \(100000<2^{73}\). Therefore the error variable in `transfer.tex:390–410` satisfies
\[
\mathbb E[e_i\mid H]\le2^{-25}n,\qquad
\sigma_i\le\kappa z_i+e_i
\]
on all branches, including \(z_i>n/\kappa\).

Averaging the safe bound gives \(\gamma=\eta/16=2^{-16}\), using the asserted unlisted-branch property and a \(D\)-independent \(Y_i\). Finally
\[
\kappa^{-1}+2^{-25}\le2^{-23}
\]
gives the claimed transfer estimate. There is substantial slack in both the entropy and tail constants.

## 8. Exact finite adversarial checks

The following deterministic checks were executed using only Python's standard-library exact integers and fractions. They are finite stress tests, not replacements for the general proofs above.

1. **Adaptive certificate budget:** all 167 non-universal increasing events on four coordinates, including the empty event, were checked for five rate profiles: uniform \(1/4,1/2,3/4,t\), and \((1/4,1/2,3/4,1/8)\). Exact Bellman optimization allowed every next-coordinate choice and unsuccessful reset. For remaining set \(V\) and transaction positives \(I\), a certificate returns \(1+B(V,\varnothing)\); otherwise optimize stopping, resetting, or querying each \(e\in V\). All **835** optimal expectations were below exact rational lower bounds for \(-\log\delta\). The logarithm lower bounds used 12 positive terms of
   \[
   \log x=2\sum_{j\ge0}\frac{((x-1)/(x+1))^{2j+1}}{2j+1},
   \]
   after factoring out powers of two to reduce \(x\) to \([1,2)\).
2. **Adaptive retained/substituted hybrid:** four coordinates were queried adaptively: first coordinate \(0\); then \(1\) if its answer is \(1\), otherwise \(2\); then \(3\) only if the second answer differs from the first. Exhaustive guard/test assignments verified
   \[
   \Pr(\text{transcript}=\tau,\widetilde C=c)
   =\Pr(\text{transcript}=\tau)\Pr(C=c)
   \]
   for all transcripts and vectors, at rates \(1/2\) and \(t=2^{-140}\). All **192** rational equalities passed.
3. **Two-test residual encoding:** in the binary rank-three matroid on the seven nonzero vectors of \(\mathbb F_2^3\), take \(a=-4\), \(F(k)=\varnothing\) for \(k<-2\), \(F(-2)=\operatorname{cl}\{1\}\), \(F(-1)=\operatorname{cl}\{1,2\}\), and \(F(0)=F(1)=E\). Enumerate every generator subset of size at most two, every insertion time in \(\{-4,-2,-1,0\}\), both parities, every focal \(O\) containing the generators, and independently \(K_b\in\{\varnothing,F(b)\}\) at each layer. Choose canonical greedy extension witnesses. All **101376** cases satisfied both exact endpoint identities, \(\mathcal R\subseteq O\), and “first mark-\(1\) set intersect second mark-\(1\) set \(=\mathcal R\).” This checks the encoding identities, not the manuscript's density construction at its enormous fixed \(\kappa\).
4. Exact rational arithmetic also checked the conservative dyadic bound \(15/2048<1/2\), the residual exponent coefficient, \(\gamma\), and the final transfer slack.

## 9. What this investigation does not establish

The following are load-bearing interfaces, not additional flaws identified here:

* The actual density maps must be flat-valued, extensive, monotone in base/time, and optimize the stated sample-count-minus-rank objective; the residual density inequality must follow from those actual definitions.
* The path boundary facts \(X_h(a_h-1)=L\), \(X_h(a_h)=Q_h(L)\), absence of birth at \(a_h+1\), and \(F(0)=E\) are invoked in these sections. Absence of the \(a_h+1\) birth does not follow from generic monotonicity alone.
* The true groups must be fixed before focal \(D,C,T\) bits, contain only candidate nonloops, and have lower-group indices unaffected by focal listing. The averaging at `transfer.tex:355–363` also needs unlisted \(\Rightarrow D\cap U_i=\varnothing\) and \(Y_i\) fixed under conditioning on \(H\), rather than chosen using \(D\).
* These sections estimate seed-defined nominal statistics. They contain no exchange of expectation with minimum over orders. To conclude an **expected minimum**, the later argument still needs an appropriate deterministic comparison valid for every ordering of each fixed complete seed. Such a comparison is not proved by the safe-count or transfer expectations alone.

No literal flawed manuscript assertion is proposed for a refutation ledger from this bounded thread. The delicate local assertions checked above survive the conditioning, indexing, and timeline tests; the outstanding task is to verify their interfaces against the actual definitions and the eventual pointwise adversarial-order comparison.
