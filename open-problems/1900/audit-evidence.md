# Evidence for 1900 (Erdős problem 43)

- Audit cutoff: `2026-08-27`
- Candidate `resolution_status`: `refuted`
- Candidate `claim_alignment`: `exact_both_branches_refuted_by_separate_constructions`
- Candidate `evidence_level`: `formal_artifact`
- Candidate `resolution_date`: `2026-05-10`
- `review_status`: `unreviewed`

## Input claim, with quantifiers separated

Write \(f(N)\) for the **maximum cardinality** of a Sidon subset of
\([N]=\{1,\ldots,N\}\). The input combines two universal asymptotic claims.

1. **Additive-error branch.** Does there exist an absolute real constant
   \(C\) and \(N_0\) such that, for every \(N\geq N_0\) and every pair of
   Sidon sets \(A,B\subseteq[N]\) satisfying
   \((A-A)\cap(B-B)=\{0\}\),
   \[
   { |A|\choose2}+{|B|\choose2}\leq {f(N)\choose2}+C?
   \]
2. **Equal-size fixed-saving branch.** Does there exist an absolute
   \(c>0\) and an error \(o(1)\), uniform in all admissible pairs, such that
   eventually the same hypotheses plus \(|A|=|B|\) imply
   \[
   {|A|\choose2}+{|B|\choose2}
   \leq(1-c+o(1)){f(N)\choose2}?
   \]

The condition on difference sets is equality, not merely disjointness after
discarding selected representations. Both \(A\) and \(B\) must themselves be
Sidon and lie in the same interval \([N]\).

## Cutoff-current maintained record

The cutoff anchor is the author-maintained `teorth/erdosproblems` snapshot
[`9cfb265`](https://github.com/teorth/erdosproblems/commit/9cfb265f9fa57390908d80624d61b9551d454398)
of 2026-08-26 08:34:03 UTC. Its `data/problems.yaml` records #43 as
`disproved (Lean)`, with formal-status update `2026-08-23`. The
[current problem](https://www.erdosproblems.com/43) gives exactly the two
claims above. The [revision history](https://www.erdosproblems.com/history/43)
has a 2026-05-10 revision already recording both negative answers: branch 1
via #42, and branch 2 via Barreto's construction. Thus `2026-05-10` is the
earliest precisely dated maintained-history revision located that closes the
combined item; the later `2026-08-23` date is the status/Lean update.

The maintained labels are only the cutoff/status anchor. The mathematical
checks below use the proof artifacts and construction, not the label.

## Branch 1: complete proof artifact and exact implication

The decisive full artifact is the standalone Lean file for the solution of
#42:

- `Shashi456/erdos-formalizations`,
  [`Erdos/P42/CompactCayley/Proof.lean`](https://github.com/Shashi456/erdos-formalizations/blob/7f57ea4bc629433ba03ed358f3ca4168c5efaabf/Erdos/P42/CompactCayley/Proof.lean),
  commit `7f57ea4` dated 2026-05-10.
- Local full text: `root-closure/archives/formal-proof-sources.tar`, member
  `.work/remaining-audit/low-grade-erdos/sidon-ap/sources/erdos42-compact-cayley-Proof.lean`.
- Source locations: lines 14328-14352 prove the compact Cayley clique
  theorem; lines 14384-14482 prove `theorem_1_1_from_compact_cayley`;
  lines 14592-14717 give the `Set ℕ` theorem and the eventual
  formal-conjectures-shaped statement; lines 14797-14801 contain the axiom
  audit.

### Cutoff-pinned local reproduction

The local 604,558-byte bundle has Git blob
`946a418b13080b80b1aeb0ca76e22b574619982e`, exactly matching
`Erdos/P42/CompactCayley/Proof.lean` at commit `7f57ea4`. The same commit's
three dependency-control files were preserved byte-for-byte under
`.work/remaining-audit/low-grade-erdos/sidon-ap/formal-reproduction/`:

- `lean-toolchain`: Lean `4.27.0`;
- `lakefile.toml`: Mathlib input revision `v4.27.0`;
- `lake-manifest.json`: Mathlib commit
  `a3a10db0e9d66acbebf76c5e6a135066525ac900` and eight exact transitive
  revisions.

`source-identity.log` records the matching Git blob identities for the bundle
and all three control files. No proof source was edited. The durable direct
run
`audit-1900-lean427-replay-1787991420903610458` executed `/bin/bash replay.sh`
for 307.4 seconds and exited 0. Its exact command and status are in
`.argus_subagents/audit-1900-lean427-replay.json`; the complete output is in
`.argus_subagents/audit-1900-lean427-replay_logs/stdout.log`. The two
mathematical commands inside the preserved script were:

```text
lake exe cache get
lake env lean ../sources/erdos42-compact-cayley-Proof.lean
```

The first command successfully installed the exact manifest cache; Lake
normalised the package URLs by performing one checkout of each recorded
revision, with no retry. The generated VCS metadata was removed after the
run, so the final evidence tree contains no `.git` directory. The decisive
statuses in the durable output are:

```text
CACHE_GET_STATUS=0
LEAN_REPLAY_STATUS=0
SOURCE_TRUST_MARKER_STATUS=0
SORRY_AXIOM_STATUS=0
FORMAL_REPRODUCTION_STATUS=0
```

`replay.log` prints all five public theorem dependencies as exactly
`[propext, Classical.choice, Quot.sound]`. It contains no `sorryAx`;
`source-trust-markers.log` and `sorry-axiom.log` are empty. Thus the exact
cutoff artifact, not an adapted port, was independently replayed in its own
locked environment.

The root-closure candidate also reran the public `lean_evidence verify`
contract against the same source hash
`8286145f40352c0b2a34286f9beddb3728fe446a1055d5a52e5861d52b072cac`
under Lean 4.27.0. The fresh result at
`root-closure/formal-workspaces/erdos427/evidence/lean_check.json` has status
`success`, compiler and axiom-audit exit 0, no proof holes, and the same five
axiom sets shown above.

An earlier unlocked host-Mathlib compatibility probe is retained at
`.work/remaining-audit/low-grade-erdos/sidon-ap/erdos42-lean-compile.log`.
That 384-line log contains elaboration errors and `sorryAx` in the resulting
failed environment. It is a failed compatibility run, not a proof error and
not evidence for the theorem. The old run did not preserve a task receipt or
version prologue; the successful locked run above supersedes it rather than
silently relabelling it.

Theorem 1.1 is stronger than needed: for every fixed \(M\geq1\), all
sufficiently large \(N\), and **every nonempty** Sidon \(A\subseteq[N]\), it
constructs a Sidon \(B\subseteq[N]\) with \(|B|=M\) and
\((A-A)\cap(B-B)=\{0\}\). It does not merely handle one special \(A\).

Now take \(A=A_N\) of maximum cardinality, so \(|A|=f(N)\). If a constant
\(C\) in branch 1 existed, choose a fixed integer \(M\) with
\({M\choose2}>C\). The theorem supplies \(B\) for all sufficiently large
\(N\), and then
\[
 {|A|\choose2}+{|B|\choose2}
 ={f(N)\choose2}+{M\choose2}>{f(N)\choose2}+C.
\]
All five input conditions—common interval, both Sidon, exact difference-set
intersection, comparison with the actual \(f(N)\), and eventual
quantification—are present. This exactly refutes branch 1.

## Branch 2: construction checked condition by condition

The [complete construction in the maintained forum](https://www.erdosproblems.com/forum/thread/43)
uses the Bose--Chowla theorem. A full independently page-locatable account
of that ingredient is Nathanson, *The Bose-Chowla argument for Sidon sets*,
J. Number Theory 238 (2022), 133-146,
[arXiv:2104.12711](https://arxiv.org/abs/2104.12711): Theorem 1 and proof,
preprint pp.3-4, state that for every prime power \(q\) there is a
cardinality-\(q\) Sidon set modulo \(q^2-1\), contained in
\(\{1,\ldots,q^2-2\}\). Local full text and extraction:

- `.work/remaining-audit/low-grade-erdos/sidon-ap/sources/nathanson-bose-chowla.pdf`
- `.work/remaining-audit/low-grade-erdos/sidon-ap/sources/nathanson-bose-chowla.txt`

For an odd prime power \(q\), put \(2N=q^2-1\), and split such a modular
Sidon set \(S\) into its even and odd parts, of sizes \(a,b\). Uniqueness of
nonzero directed differences modulo \(2N\) makes the two within-parity
difference collections disjoint subsets of the \(N-1\) nonzero even
residues. Hence
\[
 a(a-1)+b(b-1)\leq N-1,\qquad (a-b)^2\leq2q-3.
\]
Choose \(m=\min(a,b)=q/2-O(\sqrt q)\) elements from each parity class. Divide
the evens by 2 and map each odd \(o\) to \((o-1)/2\), then translate both
sets by 1. This gives:

- \(A,B\subseteq[N]\);
- \(|A|=|B|=m\);
- each is Sidon, since an integer sum collision lifts to one modulo
  \(q^2-1\);
- a shared nonzero difference would lift to the same directed modular
  difference from one even-even ordered pair and one odd-odd ordered pair,
  contradicting modular Sidon uniqueness. Thus
  \((A-A)\cap(B-B)=\{0\}\).

### The constant-one asymptotic for \(f(N)\)

The normalization needed here is explicitly supported by two full texts
already preserved in this audit; it is not inferred from the weaker
all-differences count.

1. Erdős, *Some of my forgotten problems in number theory*
   ([DOI 10.46298/hrj.1992.125](https://doi.org/10.46298/hrj.1992.125)),
   section 2 “Problems on Sidon sequences,” printed p.37 (PDF p.4), defines
   \(f(n)\) as the largest \(k\) for which
   \(a_1<\cdots<a_k\leq n\) is Sidon—the same \(f\) used here—and records
   Lindström's bound
   \[
     f(n)<n^{1/2}+n^{1/4}+1.
   \]
   The local full text is
   `.work/remaining-audit/low-grade-erdos/open-status/sources/2334/erdos-1992-forgotten-problems.pdf`;
   the exact page extraction is adjacent at
   `erdos-1992-forgotten-problems-pages/page-04.txt`.
2. Nathanson, section 2, preprint p.2, defines \(F_h(n)\) as the largest
   order-\(h\) Sidon set in \(\{1,\ldots,n\}\). Thus \(F_2(n)=f(n)\).
   Theorem 2 and its proof, preprint p.4, give
   \[
     \liminf_{n\to\infty}\frac{F_h(n)}{n^{1/h}}\geq1,
   \]
   hence \(\liminf f(n)/\sqrt n\geq1\). Together with Lindström's bound,
   this proves
   \[
     f(N)=(1+o(1))\sqrt N.
   \]

Only the upper half is needed to defeat the proposed saving: it gives
\[
  {f(N)\choose2}\leq \frac N2+O(N^{3/4}).
\]
The Nathanson lower half additionally justifies the ratio statement below.

Finally,
\[
 {|A|\choose2}+{|B|\choose2}=m(m-1)
   =N/2+O(N^{3/4}),
\]
while the now-located \(f(N)=(1+o(1))\sqrt N\) gives
\({f(N)\choose2}=(1/2+o(1))N\). Along the infinite sequence
\(N=(q^2-1)/2\), the ratio tends to 1. Consequently every fixed
\(c>0\) fails. This checks the equal-cardinality and fixed-proportion
quantifiers exactly. This construction alone does **not** determine the
sign of the additive \(O(1)\) error, so it was not used to refute branch 1.

## Bounded Jacobian check is not asymptotic evidence

The preserved adapter record `jacobian-run.json` uses Jacobian MCP
`0.14.0`, protocol `native CLI typed JSON`, operation
`additive.ordered_difference_profile.compute`, and the exact payload in
`jacobian-payload.json`. It completed with `adapter_status: success`, no
adapter error, no timeout, and runtime 1 ms. Its typed output checks only the
four labelled vectors encoding \(A=\{2,3\}\) and \(B=\{1,11\}\): all 12
ordered nonzero differences have multiplicity one, and the within-label
differences are disjoint.

This is one finite sanity check of the Sidon/difference conditions. It proves
no eventual statement and supports neither asymptotic refutation. The two
branches are decided only by the locked formal theorem and the
Bose--Chowla/Barreto construction above.

## The requested “Szabó 1999” lead is a source mismatch

The located full paper is Tibor Szabó, *Intersection Properties of Subsets
of Integers*, European J. Combin. 20 (1999), 429-444,
[DOI 10.1006/eujc.1997.0176](https://doi.org/10.1006/eujc.1997.0176).
It was read rather than accepted from a citation snippet. Abstract p.1,
Theorem 2.1 p.3, and the construction in section 5, printed pp.443-444
(preprint pp.20-21), concern the maximum number of families whose pairwise
intersections are nonempty arithmetic progressions. The full text contains
no Sidon-set result and no \(A-A,B-B\) construction. It pertains to Erdős
#272 (this shard's ID 2022), not #43. It therefore supplies **no** condition
of ID 1900 and is not represented as a decisive paper.

Local full text:
`.work/remaining-audit/low-grade-erdos/sidon-ap/sources/szabo-1999-intersection-properties.{pdf,txt}`.
The decisive sources for ID 1900 are instead the complete #42 proof and the
Bose--Chowla/Barreto construction above.

## Structured candidate and limitations

- `resolution_status`: `refuted`
- `claim_alignment`: `exact_both_branches_refuted_by_separate_constructions`
- `evidence_level`: `formal_artifact`
- `resolution_date`: `2026-05-10`
- `source_urls`:
  - https://www.erdosproblems.com/43
  - https://www.erdosproblems.com/history/43
  - https://www.erdosproblems.com/forum/thread/43
  - https://github.com/Shashi456/erdos-formalizations/blob/7f57ea4bc629433ba03ed358f3ca4168c5efaabf/Erdos/P42/CompactCayley/Proof.lean
  - https://arxiv.org/abs/2104.12711
  - https://doi.org/10.46298/hrj.1992.125
  - https://doi.org/10.1006/eujc.1997.0176
- `source_location`: `Proof.lean lines 14328-14717 and 14797-14801; locked Lean 4.27 replay.log and source-identity.log; Nathanson definition p.2, Theorems 1-2 pp.3-4; Erdős 1992 section 2 p.37 (PDF p.4), definition of f and Lindström bound; problem-43 forum Lemmas 1-3 and Theorem 1; Szabó abstract/Theorem 2.1/section 5 (mismatch check)`
- `audit_notes`: `The exact cutoff formal artifact was replayed under its pinned Lean/Mathlib 4.27 manifest with exit 0 and only propext, Classical.choice, and Quot.sound; it refutes the additive branch. A separate checked Bose-Chowla/Barreto construction refutes the equal-size fixed-saving branch; the required f(N)~sqrt(N) normalization is located in Erdős 1992 p.37 and Nathanson Theorem 2 p.4. The earlier unlocked-host failure and finite Jacobian example are explicitly non-evidence.`
- `review_status`: `unreviewed`

Limitations: the original Erdős 1982/1995 papers were not needed to decide
the present formulations and were not re-audited here. The locked formal
artifact establishes branch 1 but does not formalize the separate Barreto
construction for branch 2, and no claim is made that the forum comment has
journal publication.
