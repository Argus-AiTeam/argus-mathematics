# Whole-manuscript claims and the boundary of the old draft

## Assessment, source and attribution

**The old draft does not certify the full affine-counting, tail or density
theorems.** Those claims remain unresolved by this draft, not refuted.
Their explicit coverage here prevents either silently omitting ledger
nodes or treating a local certificate as whole-paper verification.
Reviewing the existing draft does not require opening a new audit of
every manuscript section.

The reference is OpenAI, *Squarefree values of quartics and power-free
values of polynomials*, September 24, 2026; `main.tex:32-33` identifies
the title and author. The supplied source revision is
`4eaee87548250b2682affda7d05d947c05554bae`. Main and the relevant
Sections 1, 2, 3 and 11 match that existing reference manifest. The
Argus draft, old claim ledger and old graph match their existing
preserved snapshot entries dated `2026-11-06T10:20Z`.

The broad old mission is historical data, not this review's objective.
Current deliverables are the coverage index and all six unit
assessments. The native Host-invoked independent Reviewer decides their
acceptance; this Engineer does not.

## Every broader claim and its exact disposition

For the polynomial claims, write
\(\rho_f(q)=\#\{a\bmod q:f(a)\equiv0\bmod q\}\) and
\(S_{f,k}(X)=\#\{1\le n\le X:f(n)\text{ is }k\text{-power-free}\}\).
The source includes negative values and excludes zero.

| Old claim/version | Exact statement or scoped obligation | Disposition and concrete missing support |
|---|---|---|
| **C9000020@1** | Historical disjunctive audit objective: find a certified flaw in family 020, or independently verify/repair/generalize its core theorem with a machine-checkable certificate and independent review. | Not a mathematical theorem and not the current instruction. The adaptive subsystem is narrower; its certificate does not discharge the whole old objective. |
| **C_DENSITY@1** | For \(f\in\mathbb Z[x]\) irreducible over \(\mathbb Q\), \(4\le d\le8\), \(k=d-2\), and \(\rho_f(p^k)<p^k\) for all primes, \(S_{f,k}(X)=c_{f,k}X+o_f(X)\), where \(c_{f,k}=\prod_p(1-\rho_f(p^k)/p^k)>0\). No primitivity or leading-sign restriction. | Source `01-introduction.tex:20-35`. Open in the old draft: both tail and sieve transfer remain needed. The error is for fixed \(f\), not coefficient-uniform over a family. No assertion here that this theorem is false or correct. |
| **C_LARGE_PRIME_TAIL@1** | For primitive irreducible positive-leading \(f\), \(4\le d\le8\), \(k=d-2\), some \(\delta_f>0\) satisfies \(\#\{X<n\le2X:\exists p>X,\ p^k\mid f(n)\}\ll_f X^{1-\delta_f}\). | Source `01-introduction.tex:197-207`; local admissibility is not required for this proposition. The affine counting theorem and remaining arithmetic/geometric inputs and their Section 11 assembly are not verified by the old adaptive report. |
| **C_SIEVE_TRANSFER@1** | Writing a locally admissible irreducible \(f=s c g\), with positive content \(c\) and primitive positive-leading \(g\), an \(o(X)\) large-prime tail for \(g\) implies the predicted positive density for \(f\), retaining its original local factors. | Source `02-sieve.tex:10-30` is actually stated for every \(d\ge2,k\ge2\); the old density application is narrower. Its cutoff limits, small/intermediate prime estimates and transfer proof were not audited by the old draft. Normalizing \(f\) cannot silently replace the target Euler product by that of \(g\). |
| **C_REMAINING_TAIL_INPUTS@1** | The arithmetic, determinant, lattice, Hilbert, quartic-geometry, curve and parameter inputs of Sections 4-10 have every uniformity required by the Section 11 assembly. | An explicit conjunction of unresolved obligations, not a completed Argus draft or a single proved lemma. The needed uniform parameter ranges and interfaces to affine counting have no argument in the inventoried adaptive report. |
| **C_AFFINE_COUNTING@1** | With the fixed weighted-box, degree/dimension and uniform exceptional-or-Hilbert alternatives of `thm:affine-counting`, \(|S|\ll_\epsilon X^{\sum_{h=1}^r E_h+\epsilon}\), \(E_h=\max_{h\le s\le r}\delta_s\), without an initial coefficient bound. | Source `03-affine-counting.tex:20-68`. The reviewed adaptive mechanism supplies only one dependency. The residue cut and counting tree are separate; good cumulative products do not themselves count the points. |
| **C_RESIDUE_CUT@1** | A covered \(h\)-dimensional parent satisfying the Hilbert input, with distinct primes avoiding its minor and product at least \(X^{\delta_h+\nu}\), admits a uniformly bounded-degree proper polynomial cut vanishing on its entire simultaneous residue class. | Source `03-affine-counting.tex:169-184`. The old report uses this as a separate degree input, not a proved consequence of the finite deletion inequality. Its local determinant estimates and the uniform weighted-Hilbert comparison remain outside that report's certification. |
| **C_COUNTING_TREE@1** | Residue branching, dimension induction, exceptional stopping and exponent accounting imply affine counting once adaptive products and residue cuts are supplied. | Source `03-affine-counting.tex:408-485`. Requires the reduction point counts, entire-class kernel membership, proper dimension drops, treatment of exceptional parents, and final exponent/halving argument. These are not Lean conclusions or finite regression results. The old draft expressly did not certify them. |

The affine input is not merely a Hilbert bound on the initial \(Z\).
For **every fixed degree bound** \(e\), every positive-dimensional
\(\mathbb Q\)-defined geometrically irreducible \(A\subseteq Z\) of degree
at most \(e\) meeting \(S\) must satisfy either
\(|S\cap A|\ll_{e,\alpha}X^\alpha\) for every fixed \(\alpha>0\), or
\[
H_A(T)\ge T^h/(h!\delta_h^h)-C_eT^{h-1}\quad(T\ge1),
\]
uniformly in \(X,Z,S,A\). The degree convention explicitly sums all
geometric components (`03-affine-counting.tex:20-24`); this resolves the
provisional hypothesis-matching question in the patch-height unit.

For the sieve interface the exact source formula at content primes is
\[
1-\rho_f(p^k)/p^k
=1-\rho_g(p^{k-e})/p^{k-e},\qquad e=v_p(c)<k.
\]
It is identified to prevent a scope substitution, not presented as a
verification of the entire sieve proposition.

## Dependency accounting and historical status disagreement

The old graph has 16 nodes, all `status=open` and
`reviewer_confirmed=false`. Its `routes` object is empty, while the
old ledger has seven decompositions and 18 evidence records.
Supportive historical Engineer/Reviewer labels exist for the adaptive
claims, including the final formal revision. Neither those labels
nor the graph's open labels decide the actual mathematics.

The checked human finite proof and current real compiler replay support
the limited combinatorial core. The kernel, height and product units
examine the additional manuscript-specific bridges. None proves the
missing upper-level implications:
\[
\begin{split}
C_{\rm density}&\leftarrow
 C_{\rm tail}\ \&\ C_{\rm sieve},\\
C_{\rm tail}&\leftarrow
 C_{\rm affine}\ \&\ C_{\rm remaining},\\
C_{\rm affine}&\leftarrow
 C_{\rm adaptive}\ \&\ C_{\rm residue}\ \&\ C_{\rm tree}.
\end{split}
\]
The graph also makes the counting tree depend on the adaptive mechanism
and residue cut. The index preserves every edge; it does not mark
an AND-obligation complete because one leaf was checked.

The historical `R_ADAPTIVE_FINITE` route references the unformalized
**formal claim v1**, not the successful v4. The v2/v3 compiler failures,
two different successful v4 certificate records, duplicate source and
fidelity files, and four mere submission receipts are separately
assessed in finite-deletion. They are not independent mathematical
results. The line-family obstruction retires only
`R_FULL_MINOR_INDEPENDENCE`, not a manuscript theorem.

## Contribution, exclusions and remaining review

The strongest old result already claimed the explicit finite bound,
its adaptive application, and formal certification of the incidence
core. This review does **not** strengthen that theorem or obtain a new
number-theoretic result. It checks the existing reasoning and evidence,
discharges the total-component-degree matching question, clarifies the
integer record cap and the formalization boundary, and accounts for
every broader obligation and version.

The historical Hanneke-Kontorovich lookup was contextual; the Guth
lookup was not a general degree input, and the Tao URL failed. None
establishes priority or identifies this mechanism with a known theorem.
No new novelty claim is made, and no inaccessible source or failed
execution is used in place of mathematical assessment.

Empty lock files are excluded as nonmathematical. The manuscript symlink,
manifests, compiler logs, adapter files and receipts are identified as
references or evidence, including available files absent from the
snapshot manifest. Other campaigns and later manuscript-audit findings
are not substituted for reviewing this old draft.

The independent Reviewer must examine the index and all substantive
reports, especially the prose geometry and statement fidelity.
Whole-manuscript correctness remains an explicit open boundary, not a
task-completion requirement silently imposed on this exploratory review.
