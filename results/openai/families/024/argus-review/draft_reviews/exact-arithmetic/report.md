# Exact arithmetic and bounded recovery diagnostics

**Engineer unit assessment:** `supported_in_stated_scope`. This completes this
unit's substantive assessment at **exploratory** level. The native Host-invoked
Reviewer accepted it as part of the complete **bounded substantive review** in
[`round-0001.json`]($WORKSPACE/.argus-campaign-9200024/projects/245cf7797dc6/handoffs/22092fed6282/round-0001.json).
That acceptance is not final project delivery; the corrected review is returned
to the Host for final disposition. Novelty is **not verified**.

## Claim, source and attribution

The historical claim is **C_ROOT_BOUNDS, version 1**, content hash
`eb828647846e872ea2256549848892a4094191c1d16479e73ad70116f030f287`,
in historical context `CTX_PREFIX` version 1. For real natural logarithms,
\[
 a_j=\int_j^{j+1}\log t\,dt
     =(j+1)\log(j+1)-j\log j-1\quad(j\ge1),
 \qquad F(r)=\sum_{j\ge1}a_jr^j,
\]
the unique root \(\rho\in(0,1)\) of \(F(\rho)=1\) satisfies
\[
 27/50<\rho<109/200,\qquad 3/5<\log(1/\rho)<2/3.
\]
The associated elementary decay assertion is, for **every integer \(h\ge4096\)**,
\[
 h^{100}(109/200)^h
 <2^{-1000}(3/4)^{h-4096}.
\]

Inputs are the read-only `9000024/research/prefix-collisions/verify.py` and
`exact_certificate.json`, with historical SHA-256 respectively
`f4f82be498a43f0aba6c973f2a8a80ad8d67e7089fa9c7da3130d9900c0139fd` and
`6895f4391ec2b23ff4f7b5c14e8a01390d7d506f930d9732d685b4b0d3a943da`.
The parent supplied the inventory/snapshot and manuscript-manifest checks; this
unit additionally records its own input hashes in `historical_replay.json`.
The defining coefficient and root passages are reproduced from the staged
manuscript sources bound to reference version
`4eaee87548250b2682affda7d05d947c05554bae`. The exact verifier is old Argus work
attributed in the ledger to `engineer:prefix`. The root/decay mathematics and
stars-and-bars counts are elementary reproductions, not established novel results.

Historical opinion `judgement-C_ROOT_BOUNDS-107d0110b8af`, by
`reviewer:copilot-math`, supports the same claim content hash and archived exact
certificate. It is usable corroboration for this unchanged, assumption-free
historical claim, **not** independent acceptance of this mission.

## Decisive argument: the infinite series, not merely 64 terms

For every integer \(j\ge1\), \(\log t>0\) on the interior of \([j,j+1]\).
Consequently \(a_j>0\). Also
\[
 a_j\le\log(j+1)\le j
\]
by monotonicity of logarithm and \(\log u\le u-1\). This proves the
**general** coefficient majorant; checking 64 coefficient intervals alone would
not prove it.

For any fixed \(r_*<1\), the majorant \(\sum_{j\ge1}j r_*^j\) converges.
Thus \(F\) converges uniformly and is continuous on \([0,r_*]\). For
\(0\le r<s<1\), positivity gives
\(F(s)-F(r)\ge a_1(s-r)>0\): \(F\) is strictly increasing on the entire
relevant domain. The endpoint inequalities below and the intermediate value
theorem therefore give existence, while strict monotonicity gives uniqueness
in \((0,1)\). This analytical justification is supplied by the assessment;
the Python output by itself is not a Lean proof of real analysis.

The logarithm enclosures are valid. For rational \(1\le x\le2\), set
\(u=(x-1)/(x+1)\in[0,1/3]\). The identity
\[
 \log x=2\sum_{j\ge0}\frac{u^{2j+1}}{2j+1}
\]
follows by integrating the geometric expansion of \(2/(1-u^2)\).
After 40 terms all omitted terms are nonnegative, and their sum is at most
\[
 \frac{2u^{81}}{81(1-u^2)}.
\]
The formula also handles \(x=1\) exactly. For larger rational \(x\), the
verifier reduces \(x=2^p y\), \(1\le y\le2\), and adds \(p\) enclosures
for \(\log2\); no floating-point logarithm is used. Subtracting \(j\log j\)
with reversed interval endpoints gives valid lower/upper intervals for \(a_j\).

For every \(0<r<1\) and integer \(N\ge0\), the uncomputed tail satisfies
\[
 0\le\sum_{j>N}a_jr^j
 \le\sum_{j>N}jr^j
 =\frac{r^{N+1}((N+1)-Nr)}{(1-r)^2}.
\]
This identity is obtained by differentiating the geometric tail, or by summing
its absolutely convergent series. The verifier uses \(N=64\), verifies positive
coefficient enclosures for those 64 terms, and adds this entire infinite-tail
majorant to the upper sum. Outward rational rounding to denominator \(10^{12}\)
then yields the following reproduced enclosures:

| Argument | Lower endpoint | Upper endpoint |
|---|---:|---:|
| \(27/50\) | \(985313099080/10^{12}\) | \(985313099081/10^{12}\) |
| \(109/200\) | \(1013785829519/10^{12}\) | \(1013785829520/10^{12}\) |

The first upper endpoint is strictly below 1; the second lower endpoint is
strictly above 1. Combined with the preceding infinite-series argument these
prove the stated **open** root bracket. The same rational logarithm enclosures
verify
\[
 3/5<L(200/109),\qquad U(50/27)<2/3.
\]
Since \(r\mapsto\log(1/r)\) is strictly decreasing, the open root bracket gives
the asserted logarithm bracket, and hence \(18<30\log(1/\rho)<20\).
Published decimal digits of \(\rho\) are not needed or certified.

## Decay and its quantifier

Put \(q=109/200\) and \(D(h)=h^{100}q^h\). The exact integer/rational
checks establish
\[
 (4097/4096)^{100}q<3/4,\qquad
 4096^{100}109^{4096}2^{1000}<200^{4096}.
\]
For **every** integer \(h\ge4096\),
\[
 \frac{D(h+1)}{D(h)}=(1+1/h)^{100}q
 \le(4097/4096)^{100}q<3/4.
\]
Induction from the exact starting inequality proves the displayed geometric
bound for all such \(h\), not a sampled range. For \(0<\rho<q\) and any fixed
degree \(d\le100\), \(h^d\rho^h\le D(h)\); fixed polynomial coefficients can
then be bounded by their absolute sum. This is uniform over \(\rho\) in the
given bracket, not over unspecified analytic constants.

The additional elementary strings in `uniform_decay_certificate()` are
consistent with elementary bounds: \(\log h\le\sqrt h\) for \(h\ge4096\), and,
putting \(s=\sqrt h\ge64\),
\(h/2-30\sqrt h-1=s(s/2-30)-1\ge127>0\).
For \(h\ge2\), \(\log h\le h\) and
\(0\le\log\log(3h)\le\log(3h)\le h\), so the two printed cost-ratio
inequalities follow. The replay also reproduces the small rational cutoff
margins. Statements referring to a Ford cutoff or dummy factor in the
certificate are application descriptions, **not** independently verified
analytic hypotheses in this unit. In particular **4096 is not an effective
\(H_0\) for Ford's theorem or unspecified constants in the analytic draft**.

## Bounded diagnostics and current Jacobian evidence

The enumeration covers exactly \(n=1,\ldots,96\) and slots \(=1,\ldots,5\):
**480 diagnostics**. For each it checks tuple products, absence of duplicate
enumerated tuples, equality to
\(\prod_{p^e\parallel n}\binom{e+k-1}{e}\), and the inequality \(k^{\Omega(n)}\).
These checks do not prove the arbitrary-\(n\) statement, nor test zero slots.
The universal finite statement is assessed in `finite-recovery-endpoints`.

Repeated factors are genuinely included:
\[
 360=2^3 3^2 5,\quad
 \binom53\binom42\binom31=180\quad(k=3);
 \qquad
 72=2^3 3^2,\quad
 \binom63\binom52=200\quad(k=4).
\]
The Cartesian pair count is \(180\cdot200=36000\le5^{11}=48828125\).
For \(2^{100}\) in 37 slots, stars-and-bars gives
\[
 \binom{136}{100}=1053971082368043306063117826442280\le37^{100}.
\]
The upper bound counts assignments of 100 labeled occurrences to 37 labeled
slots; forgetting occurrence labels maps onto exponent allocations. It is a
stress example, not a new theorem about analytic tuple recovery.

The **fresh** Jacobian sequence used only the authorized adapter executable
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`.
Discovery was restricted to **three candidates**, followed by inspection of
the current exact `integer.compute.prime_factorization` contract before running
it. The contract requires a decimal-string `value` (maximum length 20),
rejects extra input fields, and describes the domain as nonzero integers.
Its typed factor list has decimal-string primes, positive integer powers and
status `COMPLETE` or `UNKNOWN`. The saved exact payload is `{"value":"360"}`.
Only **one** mathematical operation was run, with timeout 60 seconds.

Measured result: adapter **exit 0**, typed status **COMPLETE**, factors
\((2,3),(3,2),(5,1)\), value `"360"`, protocol **2025-11-25**, server
**0.14.0**, worker runtime **234 ms**; error **null**, timeout **false**,
UNKNOWN **false**. Independently, \(2,3,5\) are prime and
\(2^3 3^2 5=360\), verifying this finite output. Discovery, contract, payload,
typed response and exit/error/timeout metadata are dedicated JSON files here.
No alternative candidate operation was used. A failure or UNKNOWN would have
been a non-conclusion, not an invalidation of the preceding manual root proof.

## Replay, limits and acceptance boundary

The replay command was:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python research/draft_reviews/exact-arithmetic/replay.py --output research/draft_reviews/exact-arithmetic/historical_replay.json
```

It exited **0** on Python **3.13.5**. It imports the historical script under
`preserved_prefix_verifier`, disables bytecode writes, never invokes its
`main`, and calls exactly `source_bindings()`, `root_certificate()`,
`uniform_decay_certificate()`, `recovery_checks()`, `jacobian_check()` and
`lean_check()`. **All six result sections exactly match the archived
certificate.** Output is in the active owned directory.

`source_bindings()` checks source snippets, not the analytic argument.
`jacobian_check()` reads the **historical** typed output; the fresh adapter
sequence above is separate. Likewise `lean_check()` checks the historical
current source/fidelity-bound successful receipt, not recompilation. The actual
fresh compilation and statement assessment are in the other owned unit.
The archived certificate's header claiming a source-bound analytic transfer
proof is not a computational certification of that theorem.

No in-scope mathematical gap remains in the root bracket or geometric bound.
The analytic transfer, application-specific tuple injection, phase uniformity,
unspecified analytic constants and manuscript main theorem are not assessed
or accepted here. Following the sibling unit's official `RV_FORMAL` ledger
write, the recorded checks used campaign root
`campaigns/9200024`: the official
`math_state check` exited **0**, `{"ok":true,"issues":[]}`; the official
`proof_graph_check check` exited **2**, reporting the missing
`research/PROOF_GRAPH.json`. That historical failure is preserved, not reported
as passing, and does not become a mathematical failure of the root proof.
`OBJECTIVE.md` does not require an active proof graph for this bounded review.
The native bounded acceptance is cited above; the graph diagnostic is
nonblocking for it. No final project delivery is claimed, and these corrected
statements are returned to the Host for final disposition.
