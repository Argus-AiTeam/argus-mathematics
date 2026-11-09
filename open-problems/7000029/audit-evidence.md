# Evidence for 7000029

- Audit cutoff: 2026-08-27.
- Candidate: `refuted`.
- Claim alignment: `exact_intended_smooth_category`.
- Evidence level: `formal_artifact`.
- Review status: `unreviewed`.

## Exact original question

Mohammad Ghomi, *Open Problems in Geometry of Curves and Surfaces*:

- https://ghomi.math.gatech.edu/Papers/op.pdf
- Locator: §8, Problem 8.2, pp.15-16.
- Local full text:
  `.work/remaining-audit/grade-a-amr-058-083/sources/amr-069/ghomi-open-problems.txt`.

Problem 8.2 (Loewner) is:

> “Show that the index of any singularity of a principal line fields on a
> surface is at most one.”

“Index” here is the index of an isolated umbilic/principal-line
singularity. The surrounding text is important: it says Hamburger proved
the analytic case and then points to work “in the smooth case.” Thus the
still-open intended branch of this unqualified sentence was the smooth
surface claim, not an assertion that the analytic case was unknown.

## Pre-counterexample regularity distinction

John Guckenheimer, *Degenerate Umbilic Points of Analytic Surfaces*:

- https://arxiv.org/pdf/2402.17060v2
- Locator: abstract and pp.1-2.
- Local full text:
  `.work/remaining-audit/grade-a-amr-058-083/sources/amr-069/guckenheimer-2402.17060v2.txt`.

The 2025 paper describes the smooth Carathéodory status as controversial
and studies analytic surfaces. Its abstract says its argument rules out an
**integer** analytic umbilic index larger than one. This is not a smooth
theorem: real analyticity is much stronger than \(C^\infty\), and the
construction below is deliberately smooth/nonanalytic.

## Smooth counterexample and formal artifact

Levent Alpöge's 19 August 2026 announcement:

- https://x.com/__alpoge__/status/2089971359921156203
- Locator: the full long-form post, dated 2026-08-19.

It gives an explicit family \(g_k\) and states:

> “\(C^\infty\) caratheodory and loewner are false … \(g_k\) has an index
> \(1+k/2\) umbilic point at 0.”

For \(k=1\), this is index \(3/2>1\), directly contradicting Problem 8.2
in the intended smooth category. The same post says \(g_2\), extended to
the sphere, is the support function of a convex body with exactly one
umbilic.

The Google DeepMind `formal-conjectures` artifact at commit
`e329be48af2ae7bdd722832ea33e7bb322239e94`:

- Main proved module:
  https://github.com/google-deepmind/formal-conjectures/blob/e329be48af2ae7bdd722832ea33e7bb322239e94/FormalConjectures/Other/CaratheodoryLoewnerCounterexample.lean
- Successful project-build check:
  https://github.com/google-deepmind/formal-conjectures/actions/runs/32586878602/job/97064497981
- Locator: `not_loewnerConjectureOfClass_of_le_infty` and
  `not_loewnerConjectureOfClass_infty`.
- Local substantive sources: `root-closure/archives/formal-proof-sources.tar`,
  members `.work/remaining-audit/grade-a-amr-058-083/formal/Defs.lean`,
  `Smooth.lean`, `Index.lean`, and `Global.lean`.
- Local self-contained amalgamation: the same archive, member
  `.work/remaining-audit/grade-a-amr-058-083/formal/Solution.lean`, especially
  lines 91-95, 4738-4752, and 9480-9494.

The formal definition records twice the principal-line index as a winding
integer \(m\), so the conjectured bound is \(m\le2\). The proved family has
`HasIsolatedZeroIndex ... (2+k)`; taking \(k=1\) gives \(m=3\). The artifact
also proves a smooth convex-sphere support-function construction with
exactly one umbilic
(`counterexample_two_is_support_function_with_unique_umbilic`, local
`Solution.lean` lines 9427-9447).

The archived substantive proof files contain no `sorry`; the two `sorry`s are
only in the byte-identical non-proof carrier
`.work/remaining-audit/grade-a-amr-058-083/formal/Challenge.lean.txt`.
Repository metadata records the integrated “Build project” check as successful
on 2026-08-22.

The root-closure candidate additionally ran the public `lean_evidence verify`
contract on the archived `Solution.lean` source hash
`b277790c36603a3b769692db4f0aaf37a732e62d6ebc99bbec1b51b2272e32e5`
under the pinned Lean 4.33.1 project. The fresh result at
`root-closure/formal-workspaces/loewner433/project/root-closure-evidence/solution/lean_check.json`
has status `success`, compiler and axiom-audit exit 0, and no proof holes.
`root-closure/manifests/loewner-flattened-source-coverage.json` separately
maps all 251 declarations in `Defs.lean`, `Smooth.lean`, `Index.lean`, and
`Global.lean` into the marked sections compiled in `Solution.lean`; the sole
name change is the recorded private helper suffix `_global`.

The candidate then independently verified each of the four original upstream
modules at commit `e329be48af2ae7bdd722832ea33e7bb322239e94` under its locked
Lean 4.27.0 / Mathlib
`a3a10db0e9d66acbebf76c5e6a135066525ac900` environment:

| Module | Source SHA-256 | Public contract receipt |
|---|---|---|
| `Defs.lean` | `85c1ade93207d49b4d0e88abb2e62b22499ba084e8be5519dfb8aa9d9ffe6735` | `root-closure/formal-workspaces/loewner-upstream-e329-v427/project/root-closure-evidence/defs/lean_check.json` |
| `Smooth.lean` | `1c9c3b01edbf30ba5074241dbcf5b7c0e6ac6a61df671abf040ce3ddbf658c45` | `root-closure/formal-workspaces/loewner-upstream-e329-v427/project/root-closure-evidence/smooth/lean_check.json` |
| `Index.lean` | `3feef42875825ab1fef22c46d21503522f813645677f4deba89ba167be689f53` | `root-closure/formal-workspaces/loewner-upstream-e329-v427/project/root-closure-evidence/index/lean_check.json` |
| `Global.lean` | `59cb4dec1280bd9a75902861040d3e329f458c1ff4fff8f4854307bf006a659f` | `root-closure/formal-workspaces/loewner-upstream-e329-v427/project/root-closure-evidence/global/lean_check.json` |

Every receipt has `status=success`, compiler exit 0, axiom-audit exit 0, and
`proof_holes=[]`; each directory also retains its content-bound
`statement_fidelity.md` and `compile.log`. The typed aggregate is
`root-closure/formal-workspaces/loewner-upstream-e329-v427/project/root-closure-evidence/module-verification-summary.json`.
The locked upstream and dependency archives, source-hash checks, target build
log, and failed environment routes are retained beside these receipts. These
four module certificates supply the content binding; the successful
`Solution.lean` compile and 251-declaration mapping remain corroborating
checks, not substitutes for them.

## Logical comparison and current-source assessment

- The formal counterexample is in \(\mathbb R^3\)/the Hessian formulation,
  not the unrelated \(\mathbb R^4\) immersion variant mentioned in the
  original lead.
- Its regularity is \(C^\infty\), exactly enough to refute the intended
  smooth universal claim.
- It does not refute the real-analytic theorem: the flat oscillatory factor
  is smooth rather than analytic at the exceptional point.

Accordingly 7000029 is `refuted` in the exact intended smooth category,
while the analytic subclass remains positive.

## Limitation

This is a very recent author announcement plus a formal construction, not
yet a conventional peer-reviewed paper. The Lean theorem formalizes the
trace-free-Hessian version; the classical equivalence with the geometric
principal-foliation formulation is cited in the artifact (Smyth--Xavier,
DOI https://doi.org/10.1112/blms/33.1.109) rather than itself formalized.
The later standalone wrapper metadata locally records a failed “Run
Comparator” job on 2026-08-27, although the integrated Google repository
project build succeeded. The original row audit inspected but did not rerun
Lean; the later root-closure run above supplies a fresh compiler result but
does not replace the still-required independent review of this candidate.
