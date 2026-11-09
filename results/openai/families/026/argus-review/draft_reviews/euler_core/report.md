# Euler core: supported universal algebra, not formalized analysis

**Assessment.** `L026_EULER_CORE` v4 is supported in its stated rational-algebra scope. The inherited official certificate matches the present source and fidelity document, and a fresh, read-only compiler replay succeeded. Neither result formalizes the mixed-moment asymptotic.

## Statement, version and attribution

The claim is in `CTX026_MOMENTS` v1. Its identity is recorded in this unit's `verdict.json` and the coverage index. Inherited paths below are relative to `families/026/first-pass/audit026/moments/`. The source is `Main.lean`, namespace `Audit026`; the natural reading is `statement_fidelity.md` and `verification.md` section 3. This is Argus's elementary algebraic verification of a step in OpenAI's manuscript at revision `4eaee87548250b2682affda7d05d947c05554bae`, not a novelty claim.

For a finite set \(s\), put \(A(s)=\sum_{\varnothing\ne u\subseteq s}(-1)^{|u|}\). The actual declarations are:

| Declaration | Exact quantified content |
|---|---|
| `nonempty_subset_product` | For every finite \(s\) and every \(x:\alpha\to\mathbb Q\), the nonempty-subset sum of \((-1)^{|u|}\prod_{a\in u}x(a)\) is \(\prod_{a\in s}(1-x(a))-1\). This allows \(s=\varnothing\). |
| `fiber_sign` | For every nonempty finite \(s\), \(A(s)=-1\). |
| `fiber_sign_sum` | For every finite index set \(c\) and family \(f\) with \(f(i)\) nonempty for \(i\in c\), \(\sum_{i\in c}A(f(i))=-|c|\). No disjointness assumption is present. |
| `occupied_local_density` | For the same family and all rational \(p,d\), \(1+\sum_i A(f(i))/(p-d)=1-|c|/(p-d)\). Division is Lean's totalized rational division. |
| `marked_normalization` | For every rational \(p\ne0,1\), every rational \(\nu\), and every natural \(t\), \((1-(\nu-1)/(p-1))/(1-1/p)^t=(1-\nu/p)/(1-1/p)^{t+1}\). |
| `marked_collision_normalization` | The preceding normalization with \(\nu=|c|+1\), after the nonempty-fiber sign sum. |
| `marked_zero_factor` | For rational \(p\ne0,1\) and natural \(t\), the marked left side with \(\nu=p\) is zero. |

`DecidableEq` is assumed for the coordinate type. The index family may be empty. The nonemptiness hypothesis on each fiber is essential: \(A(\varnothing)=0\), not \(-1\).

## Decisive mathematics and statement fidelity

Expanding \(\prod_{a\in s}(1-x(a))\) proves the first identity. Setting all \(x(a)=1\) gives \((1-1)^{|s|}-1=-1\) for nonempty \(s\), and summing gives the family identity. For marked normalization, both sides reduce to
\[
 (p-\nu)p^t/(p-1)^{t+1}.
\]
Thus \(\nu=p\) is allowed, and no division by a vanishing local density is used.

For actual arithmetic fibers, \(\nu\) is the number of occupied residues, including the mark when present; there are \(\nu-\delta\) allowed nonempty residue fibers. Consequently
\[
 P_p(0)=1-\frac{\nu-\delta}{p-\delta},\qquad
 \frac{P_p(0)}{(1-1/p)^t}
 =\frac{1-\nu/p}{(1-1/p)^{t+\delta}}.
\]
The passage from congruences to these disjoint residue fibers is a separate CRT/subset argument, assessed in the density and Fourier units. Lean does not define those congruences, primes, shifts, \(t\) as a shift count, infinite products, or asymptotics. In particular, the unrestricted rational identity `occupied_local_density` at \(p=d\) has no arithmetic-density interpretation.

The fidelity document correctly distinguishes these facts. Its assertion that the surrounding analysis is proved elsewhere is not itself a compiler conclusion. The current Engineer reading supports the correspondence above; native independent review remains required.

## Inherited certificates and independent opinions

| Certificate filename | Claim version | Actual outcome and disposition |
|---|---:|---|
| `L026_EULER_CORE-0bce4266d5d0d378.json` | 2 | Exit 1, `type_error`: failed rewrite and unknown `Finset.prod_const_zero`. Superseded attempt, not a false mathematical identity. |
| `L026_EULER_CORE-39bd3adb2ac78293.json` | 3 | Exit 1, `type_error`: unresolved subset goal and ineffective `simp`. Superseded attempt. |
| `L026_EULER_CORE-b8c9d7f5cbcd586a.json` | 4 | Exit 0, `success`, `proof_holes=[]`, axiom audit exit 0. Current official certificate, evidence `lean-L026_EULER_CORE-a05fba37d0b3`. |

Version 1 has no archived mechanical certificate in the inventory. The v2 and v3 sources have different hashes from v4. All three archived certificate files match the preserved snapshot; they are versions of one argument, not independent results.

The v4 source hash is `1293575ae137df404e03d06c2d5f85272f751c8e3c8b1c9726434af9164e2acd`; the fidelity hash is `6c7744c615aeb605cc3ffd87d209540efbd9fe465157e25538623207be3d4981`. Both match the certificate and snapshot. `lean_check.json`, `lean_verification.json`, and successful `compile.log` describe the same compilation, not additional theorems. `lean_submit.json` is merely an old submission receipt; its historical PID/handle was not treated as a live job.

The ledger records reviewer-produced judgement `judgement-L026_EULER_CORE-75b55630d399`, supporting the current claim identity and current certificate. This is inherited human evidence. The graph still says `in_progress`, `reviewer_confirmed:false`; the compiler wrapper still has `statement_fidelity.verified_by:null`. These different metadata channels do not erase the judgement, but neither do they manufacture a dedicated compiler-checked fidelity approval or current family acceptance.

## Fresh replay and its boundaries

`lean_replay.json` records a real run in the existing Mathlib workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`: Lean 4.31.0, commit `68218e876d2a38b1985b8590fff244a83c321783`. Compilation and the supplied new-axiom audit both exited 0; a separate `#print axioms` pass also exited 0. All seven theorems depend on the ordinary foundational axioms `propext`, `Classical.choice`, and `Quot.sound`. No new axiom or proof hole was found. This is not a claim that the development is axiom-free.

Source and fidelity identities were checked before and after the replay and were unchanged. No active `.lean` file or ledger was created. Calling `lean_evidence verify --claim` on the old directory would mutate immutable inputs, so the new run is explicitly a direct diagnostic replay; the inherited official certificate remains the claim-bound mechanical evidence.

`bounded_replay.py` calls only five inspected, read-only checker functions, not the legacy `main`, `certificate`, `lean_replay`, or `--write`. `finite_replay.json` records exact agreement with all five inherited sections: 279 equality patterns, 40,709 local normalizations at primes 2, 3, 5, 7 with at most six divisor coordinates, 48 generic symbolic cases with at most four coordinates, kernel homogeneity examples of sizes 1-4, and 168 deletion cases with block size at most seven. These overlapping counts are not counts of independent proofs or an enumeration of integer shifts in a bounded interval. Symbolic integration with positive real variables does not certify complex Fubini.

The first invocation in the legacy Argus environment failed with missing SymPy. The successful run used the already-installed `$WORKSPACE/miniconda3/bin/python3`, Python 3.13.5 and SymPy 1.14.0, in about 0.96 seconds; no shared environment was modified.

The current Jacobian adapter was separately discovered and inspected before one bounded call of `additive.subset_sum.profile.compute`. Its exact dedicated payload is six indexed `"1"` values; `jacobian_output.json` returns sums 0-6 with multiplicities \(1,6,15,20,15,6,1\), support 7 and 64 subsets. `jacobian_status.json` records exit 0, completed, no timeout or structured error, server 0.14.0 and protocol 2025-11-25. This confirms one finite binomial example, not the universal identity or any analytic theorem. The similarly named files in the old workspace are inherited receipts, not this new call.

**Remaining obligations.** No algebraic gap was identified under the stated hypotheses. Natural/formal correspondence and the use of these identities in analysis remain human mathematical questions; this unit supplies neither a formal prime-gap theorem, novelty verification, nor native independent acceptance.
