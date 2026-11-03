# Campaign 1187: final exploratory negative report

> **Final exploratory outcome: no counterexample found.**
>
> Claim `C1187` remains open. This report records an exhausted set of
> independently reviewed routes; it is neither a proof nor a disproof of the
> Andrews--Curtis conjecture.

## 1. Exact objective and acceptance contract

The target was the following existential claim in the fixed-rank,
unstabilized Andrews--Curtis relation:

\[
\texttt{C1187}:\quad
\exists n\geq2,\ \exists(r_1,\ldots,r_n)\in F_n^n
\]

such that

\[
\langle\!\langle r_1,\ldots,r_n\rangle\!\rangle=F_n
\]

but \((r_1,\ldots,r_n)\) is not AC-equivalent to
\((x_1,\ldots,x_n)\) under AC1--AC3.

A successful submission had to contain all three of the following for the
same explicit tuple:

1. concrete \(n\) and finite words \(r_1,\ldots,r_n\);
2. an independently replayable exact proof of normal-closure equality; and
3. a global obstruction valid for every choice in AC1, AC2, and AC3, with
   unequal exact endpoint values.

Finite-quotient separation, abelianization, stable AC, a failed or timed-out
search, and separation inside a bounded orbit truncation do not meet item 3.
The authoritative definitions and obligations are in
`research/MATH_STATE.json` under `ctx-1187`, `C1187`, `C1187-TRIV`, and
`C1187-INV`.

No tuple in this campaign acquired the required global AC1--AC3 obstruction.
The report therefore closes at the exhausted-boundary outcome, not at a
counterexample certificate.

## 2. Candidate boundary

The principal candidate was

\[
AK(3)=
\langle a,b\mid
a^3b^{-4},\;
abab^{-1}a^{-1}b^{-1}
\rangle .
\]

The reviewed exact argument proves that its relators normally generate
\(F(a,b)\): in the quotient, \(aba=bab\) conjugates \(a\) to \(b\) and \(b\)
to \(a\); combining \(a^3=b^4\) with its conjugate gives \(a=b^{-1}\), then
\(b^2=b^7=1\), hence \(a=b=1\). The independent GAP replay also returns
quotient order one. Thus AK(3) satisfies the trivial-group half of the target.
It does **not** have a reviewed global AC obstruction, and its ordinary
fixed-rank AC status remains open.

The separately reviewed stable-status audit invalidated the cited bridge that
had been used to call AK(3) stably trivial: the intermediate MMS02
presentation contains the reported misprint, while the later ordinary
AC-equivalence certificate does not replace the missing stable path.
Accordingly, this campaign treats AK(3)'s stable status as open. In any event,
stable AC permits stabilization and is outside the `C1187` acceptance
contract. This candidate-status conclusion is the reviewed claim
`K1187-BOUNDARY`.

The same claim records the independently attributed length-14 rank-two
frontier. Carreras's audited statement says that unconditional verification
reaches total relator length 12; at length 13 every case reduces to an
AC-trivial presentation or AK(3); and explicit certificates merge four
length-14 Miller--Schupp cases into three blocks, while two proposed
\(MS(2)\)-to-AK(3) collapses remain uncertified. These are unresolved
candidate blocks, not negative witnesses, and no global AC obstruction is
known for them.

Primary evidence:
`research/experiments/ak3-solvable-distance/THEOREM.md`,
`research/experiments/ak3-solvable-distance/triviality-certificate.json`, and
`research/experiments/ak3-guyot-specific-conversion/BOUNDARY.md`. The
Reviewer-attributed Carreras frontier excerpt is
`research/literature/18f169c228d3d427a5a4f6b58c4cb7bf.json`.

## 3. Independently reviewed claim table

Every assertion below is restricted to the scope in the first column. Claim
statuses and independent Reviewer judgements are recorded in
`research/MATH_STATE.json`; the reconciled project view is
`research/PROOF_GRAPH.json`. "Collapse" means that the named invariant or
route cannot distinguish the tested endpoints. It never means that an AC path
in the free group was found.

All Python replay paths in the table are to be invoked from the campaign root
with
`/home/argustest/zimo/argus-latest/.venv/bin/python`.
The report reuses the sealed reviewed outputs and does not rebuild them.

| Scope | Strongest independently reviewed result | Claim and exact evidence | Existing exact replay |
|---|---|---|---|
| **Universal: literature status** | The standard conjecture was still unresolved in the independently attributed literature through 2026-07-26, and no accepted counterexample was supplied by the audited sources. | `K1187-STATUS`; `research/MATH_STATE.json`; Reviewer-attributed excerpts in `research/literature/53e9fc61a5614e4b42b0e91b1be07d46.json` and `research/literature/a4ede0cfdf0cb782120afd6db795e76c.json`. | Source attribution, not a computational certificate. |
| **Candidate frontier: AK(3) and length-14 Miller--Schupp blocks** | AK(3)'s ordinary AC status remains open, its cited stable-triviality bridge is invalid, and its stable status remains open. At the audited rank-two frontier, length 13 reduces to AC-trivial cases or AK(3); four length-14 Miller--Schupp cases merge into three unresolved blocks, while two proposed \(MS(2)\)-to-AK(3) collapses remain uncertified. No global AC obstruction is known for these candidates. | `K1187-BOUNDARY`; `research/experiments/ak3-guyot-specific-conversion/BOUNDARY.md`; Reviewer-attributed frontier excerpt `research/literature/18f169c228d3d427a5a4f6b58c4cb7bf.json`. | Source attribution and existing ordinary-AC certificates only; no bounded computation is promoted to a global obstruction. |
| **Universal: finite quotients** | For every balanced trivial-group presentation and every finite quotient, the relator image and basis image lie in the same finite-group AC component. Finite-quotient orbit separation therefore cannot certify `C1187`. | `K1187-FINITE`; Borovik--Lubotzky--Myasnikov, arXiv:1103.1295v1, Theorem 1.1; attributed excerpt `research/literature/e1f7a8edd9a51328193eda411848ffe2.json`. | Exact source attribution; no finite enumeration is promoted to a free-group conclusion. |
| **Candidate-specific: AK(3) triviality and free-soluble boundary** | AK(3) normally generates \(F_2\). For the symmetric signed elementary metric in \(S_d=F_2/F_2^{(d)}\), \(D_1=5\) and \(5\leq D_d\leq D_{d+1}<\infty\). Every invariant under all elementary AC moves in a fixed \(S_d\) has equal endpoint values. Guyot's coarser \(M\)-distance is at most 10 for every \(d\). | `K1187-AK3-SOLVABLE-BOUNDARY`, `C1187-AK3-M-DIVERGENCE` refuted, and `C1187-AK3-SOLVABLE-INVARIANT` refuted; `research/experiments/ak3-solvable-distance/THEOREM.md`. | `research/experiments/ak3-solvable-distance/verify.py`; additionally `gap -q research/experiments/ak3-solvable-distance/verify.g`. |
| **Candidate-specific: AK(3) nilpotent quotients** | In every free nilpotent quotient \(N_c\), the symmetric signed elementary distance satisfies \(5\leq E_c\leq15\). Hence nilpotent-distance divergence is refuted. | `K1187-SOLVABLE-NILPOTENT-PROJECTION`, `K1187-AK3-NILPOTENT-BOUND`, and `C1187-AK3-NILPOTENT-DIVERGENCE`; `research/experiments/ak3-nilpotent-distance/BOUNDARY.md`. | `research/experiments/ak3-nilpotent-distance/verify.py`. |
| **Route-specific: Magnus/Fox quantities and metabelian nongeneration** | The exact iterated Magnus move laws hold, but raw Fox \(\ell_1\)-size, support, and Laurent span have unbounded one-step change under arbitrary AC3 and no growing one-level endpoint gap. After the reviewed five signed product moves, the normalized AK(3) pair has identity abelianization but a seven-term nonunit abelianized Fox-Jacobian determinant, so it does not generate \(S_2\) as a subgroup; the nilpotent generating-pair premise cannot be reused in \(S_2\). Relative normal width also shows that normal-closure membership alone cannot bound elementary expansion of arbitrary \(M\)-multipliers. | `K1187-AK3-MAGNUS-LAWS`, `K1187-AK3-METABELIAN-NONGENERATION`, `K1187-AK3-RAW-FOX-NORM-NOGO`, and `K1187-AK3-RELATIVE-NORMAL-WIDTH`; `research/experiments/ak3-magnus-derived-distance/BOUNDARY.md`. | `research/experiments/ak3-magnus-derived-distance/verify.py --m 17`. |
| **Route-specific: normalized Magnus quantity** | The cyclic coinvariant cancels AC3 and has endpoint gap \(11d-4\), but either signed AC2 move has exact one-step change \(8m+2\) already in \(S_2\). This refutes only that normalized atomic functional, not every possible Magnus-derived invariant. | `K1187-AK3-NORMALIZED-MAGNUS-AC2-NOGO`; `research/experiments/ak3-normalized-magnus-quotient/BOUNDARY.md`. | `research/experiments/ak3-normalized-magnus-quotient/verify.py --m 17`. |
| **Route-specific: Guyot's fixed-component conversion** | The named middle multiplier has \(\lambda_2=4\) and \(\lambda_d\geq6d-8\) for every \(d\geq2\), while the two end multipliers have explicit finite factorizations. Guyot's literal factor-by-factor conversion therefore has no derived-length-independent elementary cost. This is not a lower bound for arbitrary paths. | `K1187-AK3-GUYOT-LINEAR-WIDTH`, `K1187-AK3-GUYOT-SPECIFIC-BOUNDARY`, `C1187-AK3-GUYOT-SPECIFIC-DIVERGENCE`, and `C1187-AK3-GUYOT-SPECIFIC-UNIFORM-WIDTH`; `research/experiments/ak3-guyot-specific-conversion/BOUNDARY.md`. | `research/experiments/ak3-guyot-specific-conversion/verify.py`. |
| **Route-specific: two-component holonomy** | The proposed fixed-component mod-three displacement is not path-global: one legal AC3 edge can create exact fixed-\(p\) width \(2m\), and a second family has exact minimum width \(6m\) with all shifts \(0,\ldots,6m-1\). Quotienting the holonomy kills the endpoint module class, while an exact \(S_2\) Fox calculation blocks direct conjugacy. No arbitrary-path bound follows. | `C1187-AK3-MOD3-PATH-GLOBAL` refuted; `research/experiments/ak3-two-component-holonomy/BOUNDARY.md`. | `research/experiments/ak3-two-component-holonomy/verify.py --m 17`. |
| **Route-specific: one-\(h_0\) Peiffer compiler** | If the residual correction uses \(C\) conjugated signed \(p\)-holonomies, then \(C\geq3d-7\). The one-\(h_0\) alternating Peiffer mechanism is therefore nonuniform; paths with further \(q\)-holonomies or mixing \(q\) into \(p\) remain open. | `K1187-AK3-PEIFFER-RESIDUAL-OBSTRUCTION`; `research/experiments/ak3-peiffer-residual/BOUNDARY.md`. | `research/experiments/ak3-peiffer-residual/verify.py --max-d 8`. |
| **Route-specific: cyclic cancellation** | Ivanov's rank-two CEN bridge is applicable, but AK(3)'s signed small-piece boundary and singleton-free turn condition are both destroyed by exact unrestricted CT2 families. No CEN reduction or CEN-closed separator results. | `K1187-IVANOV-RANK2-CEN-BRIDGE`, `K1187-AK3-CYCLIC-CANCELLATION-NOGO`, and `C1187-AK3-CYCLIC-CANCELLATION-SEPARATOR` refuted; `research/experiments/ak3-cyclic-cancellation-closure/BOUNDARY.md`. | `research/experiments/ak3-cyclic-cancellation-closure/verify.py \| diff research/experiments/ak3-cyclic-cancellation-closure/certificate.json -`. |
| **Candidate-specific plus universal sufficient theorem: thickenability** | The complete occurrence-level Neuwirth enumeration checks all 345600 compatible signed rotation systems for AK(3). A spherical link needs 11 face cycles; the maximum is 9 globally and 7 in the admissible opposite/opposite class. Thus AK(3) is non-thickenable. Lackenby's theorem says every thickenable balanced trivial-group presentation is ordinary fixed-rank AC-trivial, but its premise fails for AK(3), so it gives no conclusion here. | `K1187-AK3-NEUWIRTH-OBSTRUCTION`, `C1187-AK3-COMPATIBLE-SPHERICAL-LINK` refuted, `C1187-AK3-THICKENABLE` refuted, and `K1187-LACKENBY-UNSTABLE-BRIDGE`; `research/experiments/ak3-thickenability/BOUNDARY.md`. | `research/experiments/ak3-thickenability/verify.py --write-certificate research/experiments/ak3-thickenability/certificate.json`; independent triviality replay: `gap -q research/experiments/ak3-solvable-distance/verify.g`. |
| **Construction-specific: Laurent relation-module lift** | The MMS Theorem 1.6 pair cannot be retained inside its relation module and completed to a balanced normally generating tuple: its abelian rank is one short. A true stabilization makes \(\operatorname{diag}(U,1)\) explicitly elementary; quotient killing augments \(U\) to an elementary matrix; an outside completion relator leaves the invariant's domain. The planned Evans-class lift is therefore unavailable. | `C1187-LAURENT-COMPLETION` refuted and `K1187-LAURENT-NOGO`; `research/experiments/laurent-obstruction-lift/NO_GO.md`. The broader invariant claim received only an inconclusive Reviewer judgement and is not strengthened here. | `research/experiments/laurent-obstruction-lift/verify.py`. |
| **Candidate-specific: Bobtcheva--Quinn covered specializations** | Bobtcheva's general construction and the narrower Bobtcheva--Quinn homology-collapse theorem have different hypotheses. AK(3) and the standard presentation complexes have \(H_0=\mathbb Z\), \(H_1=H_2=0\), and Euler characteristic one. Every Corollary 1.2-covered specialization therefore gives \(Q=1\) on both. The separately evaluated \(\operatorname{Vec}_{C_2,\mathbb Q}\) example also gives one, but this does not extend homology dependence to all inputs of Bobtcheva's general construction. | `K1187-QUINN-HYPOTHESIS-BOUNDARY`, `K1187-AK3-Q-HOMOLOGY`, `K1187-QUINN-COVERED-EQUALITY`, `K1187-QUINN-C2-EQUALITY`, and `C1187-QUINN-COVERED-SEPARATION` refuted; `research/experiments/quinn-collapse-hypothesis-map/BOUNDARY.md`. | `research/experiments/quinn-collapse-hypothesis-map/verify.py`. |
| **Universal within the construction-admissible characteristic-zero Q branch** | Deligne's cited theorem has algebraically closed, exact \(k\)-linear, rigid, and simple-unit hypotheses not supplied by Bobtcheva's literal arbitrary-field wording. Finite stable \(\operatorname{Rep}_{\mathbb C}(G,z)\) nevertheless has \(Q(P)=|G|^{m-n}|\operatorname{Hom}(\pi_1(P),G)|\), hence value one on balanced trivial presentations, and stability does not force \(z=1\). The printed scalar clauses alone do not force \(K\)-bilinearity, as the exact twisted \(C_2\) category shows; however, Bobtcheva's Section 2.6 \(K\)-linear decomposition maps do force it. With \(K\)-bilinear tensor and \(\operatorname{End}(1)=K\), scalar extension, compatibility of \(Q\), and injective descent give equality throughout the full construction-admissible characteristic-zero branch. | `K1187-DELIGNE-CHAR0-SCOPE`, `K1187-STABLE-C4-PARITY-WITNESS`, `K1187-REP-GZ-Q-COLLAPSE`, `C1187-STABILITY-KILLS-SUPER-PARITY` refuted, `K1187-CHAR0-TWISTED-C2-OBSTRUCTION`, `C1187-BOBTCHEVA-TENSOR-BILINEARITY` refuted, `K1187-QUINN-NABLA-ADMISSION`, `K1187-CHAR0-SCALAR-DESCENT-CONDITIONAL`, `C1187-CHAR0-UNIVERSAL-Q-EQUALITY`, and `C1187-CHAR0-Q-SEPARATION` refuted; the three boundaries under `research/experiments/quinn-char0-tannakian/`, `quinn-char0-scalar-extension/`, and `quinn-semilinear-admissibility/`. | `quinn-char0-tannakian/verify.py`; `quinn-char0-scalar-extension/verify.py`; `quinn-semilinear-admissibility/verify.py`, each under `research/experiments/`. |
| **Universal within Czenky's algebraically closed positive-characteristic rank-three class** | The characteristic-three inversion equivariantization is admissible and its complete nine-label state sum is one at both endpoints. Together with the reviewed pointed, finite-group, and class-0 \(SL_2\) formulas, every category in the stated rank-three classification gives equal endpoint value one. | `K1187-QUINN-RANK3-CHAR3-ADMISSIBLE`, `K1187-QUINN-RANK3-CHAR3-EQUALITY`, `K1187-QUINN-RANK3-CLASSIFICATION-EQUALITY`, and `C1187-QUINN-RANK3-SEPARATION` refuted; `research/experiments/quinn-rank3-charp/BOUNDARY.md`. | `research/experiments/quinn-rank3-charp/verify.py`. |
| **Universal within Czenky's classified characteristic-two rank-four branch with two self-dual simples** | The printed \((\operatorname{Vec}_{C_4})^{C_3}\) description is incompatible with the fusion data; the data force \((\operatorname{Vec}_{C_2^2})^{C_3}\). Its complete sixteen-label state sum and the remaining pointed \(C_4\) case both give one at both endpoints. | `K1187-QUINN-RANK4-CHAR2-SOURCE-CORRECTION`, `K1187-QUINN-RANK4-CHAR2-ADMISSIBLE`, `K1187-QUINN-RANK4-CHAR2-STATE-SUM`, `K1187-QUINN-RANK4-CHAR2-CLASSIFICATION-EQUALITY`, and `C1187-QUINN-RANK4-CHAR2-SEPARATION` refuted; `research/experiments/quinn-rank4-char2/BOUNDARY.md`. | `research/experiments/quinn-rank4-char2/verify.py`. |
| **Universal: ordinary representations of finite linearly reductive group schemes over algebraically closed fields** | The AOV well-split form \(D(M)\rtimes H\) and the exact normalized-Haar expansion imply \(Q(P)=1\) for every balanced trivial-group presentation in every ordinary category \(\operatorname{Rep}_k(D(M)\rtimes H)\). This does not cover nonsplit, super, or genuinely non-Tannakian inputs. | `K1187-QUINN-TAME-WELL-SPLIT`, `K1187-QUINN-TAME-HAAR-FORMULA`, and `K1187-QUINN-TAME-UNIVERSAL-EQUALITY`; `research/experiments/quinn-tame-group-schemes/BOUNDARY.md`. | `research/experiments/quinn-tame-group-schemes/verify.py`; sealed output `certificate.json` in the same directory. |
| **Explicit category: characteristic-five rank-four Brauer branch** | The audited category is \(\operatorname{Ver}_5^+\boxtimes\operatorname{Ver}_5^+\); the state sum is multiplicative under Deligne products and gives one on both endpoint complexes. This closes only that explicit category, not the unclassified all-self-dual rank-four branch. | `K1187-QUINN-BRAUER-RANK4-CHAR5-IDENTIFICATION`, `K1187-QUINN-BRAUER-RANK4-CHAR5-ADMISSIBLE`, `K1187-QUINN-DELIGNE-PRODUCT-FORMULA`, `K1187-QUINN-BRAUER-RANK4-CHAR5-EQUALITY`, and `C1187-QUINN-BRAUER-RANK4-CHAR5-SEPARATION` refuted; `research/experiments/quinn-brauer-rank4-char5/BOUNDARY.md`. | `research/experiments/quinn-brauer-rank4-char5/verify.py`; sealed output `certificate.json`. |
| **Explicit category: five-simple neutral \(PO_4\) factor-swap equivariantization** | The complete equivariant structure and exact \(C_2\) unit-Hom projector expand all 25 terms. Only the untwisted connected-product state sum survives at either endpoint, giving one on both. No other rank-five category is covered. | `K1187-QUINN-PO4-SWAP-IDENTIFICATION`, `K1187-QUINN-PO4-SWAP-ADMISSIBLE`, `K1187-QUINN-PO4-SWAP-FORMULA`, `K1187-QUINN-PO4-SWAP-EQUALITY`, and `C1187-QUINN-PO4-SWAP-SEPARATION` refuted; `research/experiments/quinn-po4-swap-equivariantization/BOUNDARY.md`. | `research/experiments/quinn-po4-swap-equivariantization/verify.py`; sealed output `certificate.json`. |
| **Candidate-specific invariant: restricted Heisenberg Hopf algebra over \(\mathbb F_2\)** | The normalized eight-dimensional Hopf data and Bobtcheva translator are exact. Two independent coproduct implementations find 9261 surviving terms among 74088 for AK(3), giving scalar one; the standard scalar is also one. Only this Hopf object is exhausted by this candidate calculation. | `K1187-HOPF-HEISENBERG-F2-ADMISSIBLE`, `K1187-HOPF-BOBTCHEVA-FORMULA`, `K1187-HOPF-HEISENBERG-F2-EQUALITY`, and `C1187-HOPF-HEISENBERG-F2-SEPARATION` refuted; `research/experiments/hopf-heisenberg-f2/BOUNDARY.md`. | `research/experiments/hopf-heisenberg-f2/verify.py`; sealed output `certificate.json`. |
| **Family-wide invariant: \(AK(n)\), \(n\geq2\)** | Every source-defined \(AK(n)\) is a balanced trivial-group presentation. For the same restricted-Heisenberg \(\mathbb F_2\) invariant, \(q_n=\lambda(T^nv_0)\), \(T^4=I\), and all four residue classes equal one. Thus this invariant separates no member of the family. Ordinary AC status remains open for the unresolved members. | `K1187-AK-FAMILY-SCOPE`, `K1187-AK-FAMILY-TRIVIAL`, `K1187-HOPF-HEISENBERG-F2-AK-FAMILY-EQUALITY`, and `C1187-HOPF-HEISENBERG-F2-AK-FAMILY-SEPARATION` refuted; `research/experiments/hopf-heisenberg-ak-family/BOUNDARY.md`. | `research/experiments/hopf-heisenberg-ak-family/verify_family.py`; sealed output `certificate.json`. |
| **Family-wide invariant: Miller--Schupp \(MS(n,w)\)** | For every two-generator two-relator presentation, the restricted-Heisenberg \(\mathbb F_2\) scalar is \(\det(E)^3=\det(E)\pmod2\). It is therefore one for every \(MS(n,w)\) with \(n>0\) and \(\exp_x(w)=0\), independently of \(w\). This is an invariant collapse, not an AC classification. | `K1187-HOPF-HEISENBERG-F2-RANK2-DETERMINANT` and `K1187-HOPF-HEISENBERG-F2-MS-FAMILY-EQUALITY`; `research/experiments/hopf-heisenberg-ms-family/BOUNDARY.md`. | `research/experiments/hopf-heisenberg-ms-family/verify_family.py`; sealed output `certificate.json`. |
| **Universal: finite-dimensional normalized unimodular cocommutative Hopf algebras in ordinary \(\mathrm{Vect}_k\)** | The exact dual word-map pairing, normal-generation fiber, local Frobenius socle argument, and unimodular Nielsen lift force Bobtcheva's scalar to be one on every balanced trivial-group presentation over every field. This does not cover infinite-dimensional, noncocommutative, or non-ordinary categorical inputs. | `K1187-HOPF-DUAL-WORD-PAIRING`, `K1187-HOPF-FINITE-GROUP-SCHEME-COLLAPSE`, and `C1187-HOPF-FINITE-DIMENSIONAL-SEPARATION` refuted; `research/experiments/hopf-finite-group-scheme-collapse/BOUNDARY.md`. | `research/experiments/hopf-finite-group-scheme-collapse/verify.py`; sealed output `certificate.json`. |

## 4. What remains open

The following are unresolved; none is being reported as a theorem.

| Open proposition | Exact remaining issue |
|---|---|
| `C1187` | No explicit balanced trivial-group tuple has both an exact triviality certificate and a global AC1--AC3 obstruction certificate. |
| `C1187-TRIV` and `C1187-INV` | These are the two generic acceptance obligations for one winning tuple. AK(3) has an exact triviality proof, but no exact invariant meeting `C1187-INV`. |
| `C1187-AK3-EAC-DIVERGENCE` | For the symmetric signed elementary-AC distances \(D_d\) in the free-soluble tower, only \(D_1=5\) and \(5\leq D_d\leq D_{d+1}<\infty\) are proved. Whether \(D_d\) is unbounded remains open. Divergence would obstruct a finite free-group AC path by projection. |
| `C1187-AK3-EAC-UNIFORM-BOUND` | No derived-length-independent symbolic elementary path changing both components has been constructed. Guyot's fixed-component conversion and the one-\(h_0\) Peiffer compiler fail, but those failures do not rule out another simultaneous-component path. |
| `C1187-AK3-MAGNUS-LIPSCHITZ` | The raw and tested normalized Magnus quantities fail, but the ledger does not declare every nonlinear Magnus-derived endpoint functional impossible. This remains a possible subroute to the divergence alternative. |

The two free-soluble alternatives must not be confused with results already
closed:

- \(M\)-distance divergence is refuted by the uniform bound \(d_M\leq10\);
- nilpotent-distance divergence is refuted by \(E_c\leq15\);
- a separator living in one fixed \(S_d\) is impossible for these endpoints;
- Guyot's literal fixed-component compiler and the tested one-\(h_0\)
  compiler are nonuniform; and
- none of those statements decides whether an arbitrary ordinary AC path
  exists in \(F_2\).

There are also deliberately unexhausted scopes outside these immediate
free-soluble alternatives: AK(3)'s stable status, Quinn inputs outside the
named covered or classified branches, the unclassified all-self-dual
rank-four branch, non-Tannakian or nonsplit categorical inputs, and Hopf
objects outside the finite-dimensional ordinary cocommutative theorem.
Their openness is not evidence for or against `C1187`.

## 5. Why the evidence proves neither direction

The reviewed evidence cannot be assembled into a proof of the
Andrews--Curtis conjecture:

- equality of an invariant only says that invariant does not separate;
- an AC path in every finite or soluble quotient need not lift to one finite
  AC path in the free group;
- non-thickenability removes the premise of a sufficient theorem and says
  nothing about the conclusion;
- a failed construction or local compiler does not exhaust all AC paths; and
- no universal ordinary AC reduction theorem was proved.

It also cannot be assembled into a disproof:

- no global invariant was proved unchanged under every AC1--AC3 choice with
  unequal endpoint values;
- no finite search boundary is a global orbit obstruction;
- stable equivalence or non-equivalence is not the fixed-rank relation in the
  objective; and
- none of the candidate-specific, family-wide, or class-universal invariant
  collapses supplies the missing `C1187-INV` certificate.

## 6. Final disposition

The campaign's reviewed routes are exhausted exactly to the boundaries stated
above. They establish several exact theorems and several exact no-go results,
but the project-level mathematical gap is unchanged:

\[
\boxed{\texttt{C1187 remains open; no counterexample found.}}
\]

This is an exploratory negative report only. It does not assert that no
counterexample exists, and it does not assert that the Andrews--Curtis
conjecture is true.
