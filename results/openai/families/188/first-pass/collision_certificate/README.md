# All-depth collision theorem and exact technical core

`report.md` proves a finite-parameter many-root collision theorem and specializes
it to the actual deterministic good-prefix hypotheses. The resulting bound is
`O(k^2(D^-40+n^-1))`, improving the staged manuscript's `k=1,2` bound
`O(D^-35+n^-1)`. It preserves independent roots **with replacement** and
**all exposed candidate lists**, and includes every exploration depth.
A quantitative refinement is `O(k^2((1+log n)^C0 D^-96+n^-1))`.

The two improvements are the exact ordered two-path generating function
`2 exp(2x)-exp(x)` and the root-plus-fork cost `C_D^2`. The prospective
conditional-independence argument and every suffix completion scaling are
derived explicitly rather than assumed.

Run `python3 research/collision_certificate/verify.py` from the campaign root.
`exact_certificate.json` records the theorem parameters and the exact scope.
Lean **4.31.0** compiled `Main.lean` successfully with **no proof holes**;
the official ledger status of `C_SUFFIX_CORE` is `closed_kernel`.
`statement_fidelity.md` separates the universal finite combinatorial core from
the probability proof, which is not claimed to be formalized.

The bounded diagnostics covered 1,380 pattern instances, 10,128 suffixes,
36,720 proper subsets, and 225 occurrence-boundary instances. They are
diagnostics, not a replacement for the all-depth proof.

**Independent Reviewer acceptance is still required.** No refuted manuscript
assertion has been established. The full early-prefix specialization, its
independent citation attribution, and the main terminal-leave theorem are
outside this deterministic certification. Primary-source statement excerpts
for Joos--Kuehn Lemmas 7.15 and 10.1 are preserved alongside the proof.
