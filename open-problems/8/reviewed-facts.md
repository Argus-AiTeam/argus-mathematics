# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8

Evidence refs:
- `The v83 terminal input equals the exact 189-digit value Phi_79(263)=(263^79-1)/262.`
- `The recorded four distinct factors are pairwise coprime, have exact scalar or ECPP primality certificates, and their product reconstructs Phi_79(263).`
- `Read-only artifact replay verified all 2054 factor entries and 1246 support records with candidate_not_exhaustion=true; the pinned repository-wide math-state check reported no issues.`

Fact: The cyclotomic value Phi_79(263) is exactly the product of four distinct, pairwise-coprime certified prime factors; this resolves one mandatory obstruction but does not establish root-4 exhaustion or produce an odd perfect number witness.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8

Evidence refs:
- `The intermediate Phi_79(263) factor discharge reconstructs the cyclotomic input exactly and extends the certified frozen seed to 2,054 entries.`
- `An independent execution of the recorded immutable replay command exited 0 and reproduced exactly one unresolved input, Phi_31(269).`
- `Direct integer arithmetic confirms Phi_31(269)=sigma(269^30), the preceding branch abundancy is 6442/3267, and the target is absent from the 2,054 frozen factor entries while being the sole unresolved record.`

Fact: A non-exhaustive frozen replay of the root-4 suffix, using 2,054 certified factor entries, reduces the bounded search to a single unresolved input: Phi_31(269)=sigma(269^30). This target is absent from the frozen entries, so the result identifies one certificate-production boundary rather than an exhaustion or counterexample; the root-4 suffix and Alpha-1 class remain open.
