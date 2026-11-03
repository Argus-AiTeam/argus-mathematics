# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1518

Evidence refs:
- `Independent reconstruction accounted for all 744 adjacent pairs: one outside-domain pair, 25 inherited short-side rows, and 718 eligible rows.`
- `The complete Gourdon receipt preceded the single Deleglise-Rivat submission; both complete 1,486-point tables and all 744 pair rows are byte-identical.`
- `Recomputation found zero positive eligible rows, 88 inherited sink rows, 630 new nonpositive rows, and maximum difference -100 at (5622,3929).`
- `An independent sieve reproduced all three prime counts at the reported maximum, and the pinned math-state check reported no issues after Reviewer judgements.`

Fact: A fully reconstructed finite family of 718 eligible adjacent-gap pairs contained no counterexample to pi(x+y)>pi(x)+pi(y); every eligible difference was nonpositive, with a maximum of -100 at (5622,3929). This exhausts only the frozen source-defined family and does not resolve the unrestricted existential claim.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1518

Evidence refs:
- `718 个合格对中正差值数量为 0；最大差值为 -100，出现在 (5622,3929)，两份候选表均为空。`
- `有限结论明确保留 unrestricted witness 为 open；campaign MathState、ProofGraph 以及权威项目根 MathState 检查均通过。`

Fact: 在冻结来源定义的相邻 certified-gap 有限族中，718 个合格对均不满足目标正差值条件；最大差值为 -100。该结论仅排除此有限族，原始问题中的 unrestricted witness 仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1518

Evidence refs:
- `Independently reconstructed the 13 omitted residues, CRT progression, endpoints, and 60,630 starts from the audited source offsets.`
- `Inspected producer.cpp and verifier.cpp and compared all rows: 161,033,280 integers accounted for, 3,922,438 primes including 230,790 off-template primes, and zero candidate rows.`

Fact: A reviewer-verified finite search at y=2656 found zero candidates among the 60,630 starts n=231180899451707+k*304250263527210 for 0<=k<=60629. Independent implementations agreed across every window, accounting for 161,033,280 integers and 3,922,438 primes, including 230,790 off-template primes. This exclusion applies only to the stated finite domain; it establishes neither a counterexample nor an unrestricted gap reduction.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1518

Evidence refs:
- `Inspected v1 inputs and v2 refinement.md, projection.py, synthesis.py, and verify.py: selector elimination preserves the original relaxation; whole-prime layers preserve genuine primes, including equality exceptions.`
- `Independent per-value BigInt arithmetic checked all 320 proper-prime layers and found 3754 survivors at both n=101000000000 and n=101000000001; the latter has 46433 old-guard survivors.`

Fact: In the examined prime-window relaxation, selector elimination preserves the original relaxation, and whole-prime layers preserve genuine primes, including equality exceptions. Independent exact arithmetic across all 320 proper-prime layers found 3754 survivors at each of n=101000000000 and n=101000000001, compared with 46433 old-guard survivors at the latter endpoint. This demonstrates substantial filtering without excluding genuine primes, but does not establish a full-window solution or candidate certificate.
