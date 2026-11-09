# Universal collar core: formal statement and replay review

**Assessment:** supported for exactly the five encoded universal statements.
The unchanged source compiled with Lean 4.31.0 and passed the real axiom audit
with no proof holes. This is not a formal proof of analytic geometry or of
the collar lemma. Independent review of this assessment and its statement
reading remains required.

## Claim, attribution, and version

The old source is
`9000019/research/collar_root_audit/Main.lean`, authored as part of the
`engineer:copilot` draft. Its accompanying claim is
`C9000019-COLLAR-CORE`. Versions 1 and 2 have identical natural statements;
version 1 has no recorded formal statement, whereas version 2 records this
entire source. Their old claim-content hashes are respectively
`2763bdd6adc46ed47994300b0686a72514d842ae46ad6d57db2bb2f5b889148e`
and `cf05e2e0bad955e3deaf479626e555c7d8c02d694f66cce9e40aef23a9a5ca0e`.
The mechanical certificate and final historical Reviewer support bind
**version 2**, not the unformalized version 1.

The source bytes match the supplied 2026-11-06T10:20Z snapshot manifest:
`0f03b807a37d9e107b6c848bfccb1a28ffeda3d510c1086ec84224985f9acfa2`.
The old certificate embeds the exact source and exact old fidelity document;
the ledger's formal text equals that source. This identity is stronger than
merely seeing a successful historical status label.

The replay copy is `replay/Main.lean` beside this report. It is byte-identical
to the old source and is recorded on current claim `DR019-CORE`, context
`CTX-DR019`. No theorem was changed, strengthened, or presented as new.
The old topology/order proof is an elementary deduction from standard
compactness and rational density; the remaining declarations are arithmetic
identities and an inequality contradiction. The old draft does not claim
novelty, so a novelty search is neither needed nor asserted.

## Exact declarations and decisive arguments

All declarations below are in namespace `CollarRootAudit`.

| Declaration | Quantifiers, hypotheses, and conclusion | Decisive argument |
|---|---|---|
| `rational_collar_capture` | Any compact topological space `X`, open `N`, continuous `v : X -> Real`; every point outside `N` has rational `v`-value. For any irrational `a` and real `lower < a < upper`, there are rational `lower < r < a < R < upper` such that **every** point with `r < v x < R` lies in `N`. | The closed complement is compact. Its continuous image in the Hausdorff real line is closed and avoids `a`. An interval neighborhood avoiding that image contains suitable rational endpoints. |
| `circuit_genus_balance` | All integers `n,g`: `2*(n*g)-2 = n*(2*g-2)+2*(n-1)`. | Polynomial normalization by `ring`. No curve-existence assertion. |
| `circuit_stability_balance` | All integers `n,g,val`: `2*(n*g)-2+(2+n*(val-2)) = n*(2*g-2+val)`. | Polynomial normalization by `ring`. No positive-degree, stability, or graph-realization assertion. |
| `unramified_stability_balance` | All integers `d,g,gp,val,valp`, **assuming** `2*gp-2=d*(2*g-2)` and `valp=d*val`, give `2*gp-2+valp=d*(2*g-2+val)`. | Substitution of the two assumptions, then `ring`. Riemann-Hurwitz and valence equalities are not themselves proved here. |
| `stable_tree_side_impossible` | Naturals `N,total`, with `0<N`, `total+1=2*N`, and `3*N<=total`, imply `False`. | Linear arithmetic by `omega`: stability requires at least `3N` incidences, while a tree side has `2N-1`. The graph degree-sum formula is an external application fact. |

The first theorem has no finiteness hypothesis on the complement or its
values, and no Hausdorff hypothesis on `X`. Closedness of its image uses the
real line, not Hausdorffness of `X`. Its conclusion controls all points of
`X`, rather than a selected skeleton.

The natural statement's tree-side phrase means `total+1=2*N`; it is not
silently translated using truncated natural subtraction. The explicit
`hpositive` hypothesis is redundant because that equality already excludes
`N=0`. Lean's unchanged variable-name warning is not a proof hole and does
not invalidate the theorem. The initial replay fidelity note incorrectly
called this hypothesis essential; that reading was corrected, recompiled,
and its certificate retired before any judgement was filed against it.

## Fresh compiler evidence

The final real command used the requested Argus interpreter:

```text
$WORKSPACE/argus-latest/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/draft_reviews/universal-core/replay/Main.lean --statement-fidelity research/draft_reviews/universal-core/replay/statement_fidelity.md --claim DR019-CORE --project-root campaigns/9200019 --artifact-dir research/draft_reviews/universal-core/replay --timeout 90
```

It ran `lake env lean` and the separate real `lean_axiom_audit.lean` check.
The actual toolchain is Lean **4.31.0**, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake
**5.0.0-src+68218e8**, and elan **4.2.3**. The reused built workspace is
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`; no lakefile,
dependency installation, or library rebuild was introduced.

The final compile duration recorded by Argus is **14,405 ms**; compiler and
axiom-audit exit codes are both **0**, `proof_holes=[]`, and there is no
environment failure or mechanical-recording refusal. These are measured
compiler results, not inferred from the old certificate.

`replay/verification.json`, `replay/lean_check.json`, and `replay/compile.log`
carry the exact commands and tool versions. The active immutable certificate
is
`replay/certificates/DR019-CORE-d8ef9e0160e58fa0.json`.
It binds the unchanged source hash above and fidelity hash
`8c9fde1c45ba718e9f601a3284d95fe9ecb28c95edb0dac72af9c3a182cefca6`.
The preceding certificate
`DR019-CORE-e6d400f71c3db115.json` is archived but explicitly retired for
the changed reading. No approval of that reading is inherited.

## Historical evidence and scope

The old immutable certificate
`C9000019-COLLAR-CORE-01cd07df5dd9be6d.json`,
`lean_verification.json`, `lean_check.json`, and `compile.log` describe one
successful compiler/audit run, not four proofs. The old duration is
14,272 ms. `lean_submit.json` is only a submission receipt; its historical
PID and task handle were not used as current availability evidence.
The final old judgement
`judgement-C9000019-COLLAR-CORE-17ba2f5a9c1a` by
`reviewer:copilot-f14a5035706f` refers to the exact version-2 certificate.
It supports that old reading, not automatic acceptance of the current one.

Two historical ledger routes still refer to the **version-1 core hash**.
Their natural mathematical obligation is the same, but those references do
not themselves attach the version-2 compiler evidence. The old proof graph
also leaves this node open and `reviewer_confirmed=false` while recording
`kernel_verified=true`. The index preserves these distinct facts rather
than declaring the whole graph closed.

For the analytic application, one must establish compactness of the inverse
closed annular window, openness of the node tubes, continuity of the
pulled-back valuation, and rationality of **every** bad value. The source
does not encode a Berkovich space, a stable model, residue curves, a harmonic
map, an analytic root, or a finite-etale cover. Residue-cover existence,
RNS domination, ABBR lifting, unit factorization/convergence, and common
connected covers are assessed in the `collar-root` unit. The integer
identities do not construct any of those objects.

**Remaining mathematical gap within these five literal statements: none
found.** Independent statement-fidelity review is still a human obligation.
There is no mathematical improvement over the strongest prior version;
the improvement is fresh replay and exact version/scope reconciliation.
The missing current proof graph is an administrative gate issue recorded
in the family summary, not a failed theorem or a reason to weaken it.
