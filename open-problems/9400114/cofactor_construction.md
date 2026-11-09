# Paired cofactor construction: existence remains unresolved

No full-ring counterexample has been obtained by these computations. The
160-prime pool, its reviewed local orders, the earlier source partition, and
the independent judgments on `coordinated_subset.md` are unchanged.

## Exact implemented predicate

For the existing paired pool, use the independently reviewed equivalence:
select an odd number of distinct primes, at least three, and require

    u_p | n/p - 1

only for selected primes, where n is their product and u_p is the exact local
order with its 2- and 5-primary parts removed. The target is still an actual
composite n with the full identity modulo (n, X^5-1), not a solution of a
necessary projection.

`coordinated_subset.py cofactor` implements this predicate with genuine
Boolean selectors. It removes the coordinates whose underlying prime is
2 or 5; it does not remove factors 2 or 5 from the orders of other unit
groups. For an active unit coordinate, the weighted logarithm sum is
congruent to the selected prime's logarithm. In the pseudo-Boolean encoding,

    sum(w_i x_i) - m sum(2^j b_j) = a

expresses the congruence modulo m. The nonnegative quotient has enough
binary positions for floor(sum(w_i)/m); the equality itself bounds it.
Modulo two the equation is an XOR. Every local equation remains conditional
on selecting a prime that requires it.

The 172 originally unresolved target/minimum-prime domains merge into
89 minimum-prime domains. Where both targets were unresolved, odd
cardinality suffices to select either target. Where just one was unresolved,
its product residue modulo five remains an explicit condition. The source
partition is checked for missing, duplicate, or mismatched domains.
Its 148 older UNSAT outcomes are not treated as an independently certified
pool boundary.

## Direct construction and joint completion

`cofactor_cliques.py` builds actual products. Pair compatibility is

    p = q modulo gcd(u_p, u_q).

For a selected prefix, each activated odd-prime unit coordinate has one
largest required modulus and a compatible target. For possible future
primes, separate bitsets record exactly the residues reachable by even and
odd index subsets. Inserting a weight w updates them by

    E_new = E union (O + w),   O_new = O union (E + w).

The additions are cyclic shifts modulo that coordinate's modulus. If the
required residual is absent for the necessary remaining cardinality parity,
no extension can work. These supports ignore future pair incompatibilities,
so they are a relaxation and cannot by themselves establish existence.

Joint completion splits a remaining indexed set into two halves and
enumerates every compatible subset of each half. A key contains all
currently active coordinate residues and the subset parity. Complementary
keys must match simultaneously. All subsets with an equal key are kept:
different subsets can activate different additional prime constraints.
Each matched pair must also satisfy cross-half compatibility and every
selected prime's actual integer cofactor divisibility.

A resulting product is persisted with its prime factors and n,5,d and is
passed to `certificates/verify_candidate.py`. Its coefficientwise result
must pass before the public progress can announce a candidate awaiting
independent review. No Engineer computation is labeled Reviewer acceptance.

## Exact continuation domains

A saved frontier records selected prime indices and the still-available
later indices, together with the original target/minimum-prime domain.
When an ordered recursive construction is interrupted, its current family
and each unsearched first-extension sibling are retained. Different first
extensions give disjoint families; completed siblings are not reinserted.
An interrupted joint completion retains its entire local family, so that
small unfinished join may be recomputed rather than silently discarded.

The `--checkpoint-seconds` option saves these families during a durable run.
`--resume` consumes a saved frontier and writes a different output file,
preserving the earlier checkpoint. It checks the source partition and the
prefix/availability conditions. A limit leaves a nonempty frontier, never
an exhausted-domain claim.

## Completed construction measurements

| Construction | Declared work and observed result |
|---|---|
| Reduced pseudo-Boolean model | All 172 source domains attempted in 89 merged searches, two seconds each. 26 merged domains returned UNSAT, covering 46 source domains; 63 returned UNKNOWN, covering 126. No model or candidate. |
| Separate-coordinate reachability | At 240 seconds: 1,730,945 clique nodes, 866,483 direct cofactor-product checks, and 1,305,524 reachability prunes. The first minimum-prime domain remained unfinished; 88 were not started. |
| Joint-signature pilot | At 2,000,000 work items: 37,522 prefix nodes, 1,962,478 half-subset nodes, 14,108 calls to joint completion (including the interrupted call), and zero matching pairs. The first minimum-prime domain remained unfinished; 88 were not started. |

The corresponding pilot results are
`coordinated-paired80-cofactor-pb.json`,
`coordinated-paired80-cofactor-reachability.json`, and
`coordinated-paired80-cofactor-joint.json`. None excludes the paired pool.
The later frontier run completed normally in 775.2 runner seconds, without
reaching either bound. It completed all 89 merged domains representing the
172 originally unresolved source domains, left an empty frontier, and
obtained no candidate. Its arithmetic work comprised 455,550 prefix nodes,
19,127,176 half-subset nodes, 158,086 joint-completion calls, zero matching
pairs, and 227,937 direct product checks.

This is an Engineer-side finite exclusion of that exact union, not an
independent Reviewer verdict. In particular, it does not turn the other
148 original solver-only UNSAT statuses into a certified whole-pool
boundary. `exhausted_declared_pool` and `campaign_complete` remain false.
The exact durable command, one-CPU lease, and status handle are retained in
`coordinated-paired80-cofactor-frontier-submission.json`.

The bounded Jacobian operation
`additive.subset_sum.residue_profile.compute` was also applied to the
cofactor logarithm modulo 173 for the selected minimum prime 347. Its
canonical projected subset gave

    1288476439453387 = 347 * 827 * 883 * 2243 * 2267.

That product fails the full-ring verifier and is rejected. The inspected
contract, payload, typed output, execution metadata, and coefficient
residual are under `jacobian/paired-cofactor-*`. This is a single-coordinate
projection, not a counterexample or a pool exclusion.

The improvement over the preceding state is an implemented and exercised
construction predicate, joint rather than separate residue matching, and
an exact unresolved-prefix continuation mechanism. The required
mathematical improvement to an explicit full-ring witness has **not** been
achieved. The original existence goal and the paired-pool existence claim
remain open.

## A different mechanism: mixed repeated factors

The next construction permitted arbitrary other factors of n but required
p^2 dividing n for at least one p from the existing paired pool. This is
different from the earlier pure-power exclusion: n is not assumed to be
a power of p, and its other factors are not taken from the pool.

Let t_p be the reviewed exact order of B=X-1 modulo (p,Phi_5). For a target
s in {2,3}, let a=1 or 3 satisfy p^a=s modulo five. A full-ring witness must
satisfy

    n = p^a modulo t_p,   n = 0 modulo p^2.

Here gcd(p,t_p)=1 and 5 divides t_p. In the quotient modulo (p^2,Phi_5),
B^t_p=1+pH for some H, so B^(p*t_p)=1. The implementation also checks this
annihilating power exactly. Thus the CRT representative e of these two
congruences determines B^n modulo (p^2,Phi_5), and e=s modulo five
determines the right side. At X=1 both sides vanish for positive exponents.
Since the resultant of X-1 and Phi_5 is the unit 5 modulo p^2, this fixes
the residual in the entire quotient by X^5-1, not merely one factor.

`mixed_cofactor_lifts.py` computes that representative and the full five
coefficient residuals. All 320 prime/target pairs for the existing 160
primes have a nonzero residual; no first-lift survivor remains. The records
in `paired80-mixed-cofactor-lifts.json` therefore rule out a repeated factor
from this particular pool for r=5 even when all other factors are arbitrary.
They do not rule out repeated primes outside the pool, squarefree products,
or other r. This derived scoped exclusion is not yet independently reviewed.

The paired pool is no longer a source of unresolved work through those
172 subset domains or through repeating any of its primes. The actual
counterexample requirement is still unmet. Increasing the same solver
timeout cannot supply a missing subset in a completed finite domain.

## Completed variable-ring product family

The alternative `linear_prime_products.py` construction searched

    n = (6m+1)(12m+1) product_{i=1}^{k-2}(9*2^i*m+1),

with 1<=m<=250000, k in {3,4,5}, and every displayed factor prime.
It additionally checked p-1 dividing n-1 for each factor, rather than
assuming that property from the formula. All 2,103 admitted seeds were
tested at r in {5,7,9,11,13,15,17,19,21,23,25,27,29,31}.

The complete result in `linear-prime-products-m250000.json` contains
17,391 nonzero local coefficient witnesses, 12,043 cases in which the
conjectured conclusion already holds, and eight noncoprime cases. A local
failure modulo a prime factor rejects the identity modulo n. The run
finished in 181.4 runner seconds without reaching its time limit. This
finite family has no candidate; it does not exclude other constructions.

## Conditional nonunits: a genuinely new subset domain

The next construction retains the original 160 local-order records and adds
the four primes below 199 in the same residue pair:

| p | Exact local order t_p | u_p | Compatible original primes |
|---|---|---|---|
| 3 | 80 | 1 | 30 |
| 83 | 68880 | 861 | 62 |
| 107 | 38160 | 477 | 83 |
| 163 | 88560 | 1107 | 87 |

Only subsets containing at least one of these four primes are searched.
Their least prime is one of the four, so four minimum-prime domains, each
with both targets, cover the new subsets exactly and omit every
original-pool-only subset.

This removes the earlier common-unit restriction. If q divides u_p and
both distinct primes p and q are selected, then q divides n/p, contradicting
n/p=1 modulo u_p. That pair is therefore forbidden. But if p is not selected,
its modulus does not impose any restriction on q.

The coordinate table represents a nonunit logarithm as undefined, not as a
unit logarithm. Such a position is never used in an active coordinate.
Compatibility removes it before that coordinate is activated; a runtime
guard rejects a violation of this invariant. Inactive coordinate totals
carry a placeholder that is never used to accept or exclude a subset.
All final selected primes are checked by their actual integer cofactors
and the separate full-ring verifier.

The paired odd-part equivalence extends to these additional primes by the
same residue calculation: p=3^epsilon modulo 80, the two-primary order
divides 16, the five-primary order divides 5, and u_p divides p^2-1.
Division by p requires only gcd(p,u_p)=1, which holds for each prime's
own order; it does not require p to be a unit in an unused prime's order.
The additional orders were computed exactly; this extension of the
construction has not been independently reviewed.

The new input is `paired80-conditional-nonunit.pool.json`; the reviewed
source pool is untouched. The durable command and the new disjoint-domain
frontier are in `paired80-conditional-nonunit-submission.json` and
`paired80-conditional-nonunit.json`. An unfinished search is not a
counterexample or an exclusion.

The conditional-nonunit run subsequently completed normally in 304.8 runner
seconds. All four merged minima and eight target/minimum-prime domains were
completed, leaving an empty frontier. It visited 179,709 prefix nodes and
7,788,561 half-subset nodes. Three joint matches were found, but none satisfied
all selected-prime conditions and the full-ring contract. No candidate was
produced. This is only an Engineer-side exclusion of the new small-prime
subset domain, not independent Reviewer acceptance or a whole-pool result.

The next mathematical mechanism is exact coefficient-gcd final-prime
completion, described in `free_prime_completion.md`. It does not repeat the
completed subset domains or increase their solver timeouts.

## Smooth exact orders without smooth upper bounds

After the initial coefficient-gcd family also completed without a candidate,
the next construction changes a mathematical restriction rather than the
coefficient-prime cutoff. The original smooth pool required both p-1 and p+1
to be 199-smooth. This implies smoothness of the order bound 10(p^2-1), but
it need not follow from smoothness of the actual order t_p.

`order_smooth_extension.py` retains the existing 164 records, including the
four small primes, and evaluates omitted primes p<=2000000 with
p=3 or 27 modulo 80. A prime is admitted exactly when its computed order
t_p is 199-smooth; no condition is imposed on the unused part of its upper
bound. The original pool and prime cutoff are unchanged.

Every searched subset must contain at least one newly admitted prime.
Original-only prefixes may be extended by a new prime, but original-only
products are never accepted or searched as final subsets. A prefix is
discarded if it contains no new prime and has none available. Joint
completion enforces the same selection requirement. The required index set
is recorded in the search result and cannot change on frontier continuation.

A completed discovery scan only specifies this enlarged finite input;
it does not assert a satisfying product. A scan or construction limit is
kept distinct from exhaustion, and an actual product still must pass the
original full-ring verifier.

The discovery finished in 139.2 computation seconds (140.5 durable-runner
seconds), evaluating all 9,175 omitted primes. It admitted no new prime.
The new-prime-required subset domain is therefore empty, and no subset
construction was run. The exact record is
`paired80-exact-order-support.pool.json`, with the outcome in
`paired80-exact-order-support.json`. This excludes only the stated
exact-order extension at the unchanged cutoff and support, not the original
pool or any larger mathematical domain.

## Removing the paired-residue restriction

The next construction retains the 164 source records but admits primitive
primes from other residue classes modulo 80. The coefficient-prime cutoff
and smoothness support remain unchanged. Every searched product must contain
at least one newly admitted prime, so no source-pool-only domain is reopened.

The odd-part predicate alone is not sufficient outside the reviewed
{3,27} pair. For each target s in {2,3}, this construction instead uses the
full exact local condition

    n = p^(a_p) modulo t_p,
    a_p = 1 if p=s modulo 5, and 3 otherwise.

All two-primary coordinates are retained. Their right-hand sides depend on
the selected prime and the target. Compatibility is tested modulo
gcd(t_p,t_q), not merely the odd parts. Every coordinate remains conditional
on a selected prime; nonunits forbid only pairs activating the conflicting
order. The product must have odd cardinality, at least three factors, and
n=s modulo five, and its actual integer residue must satisfy every selected
full local order before the separate full-ring verifier can admit it.

This changes which Frobenius-compatible residue classes may coexist; it
does not assume that the source's convenient pairs exhaust the exact-order
possibilities. No sufficient criterion or single-coordinate Jacobian
projection is substituted for an actual product.

The materialized input `primitive-full-order-smooth199.pool.json` contains
1,649 primes: the unchanged 164 source records and 1,485 added primes in
the other fourteen primitive residue classes modulo 80. Its 47 unit
coordinates have a 548-bit common modulus. Construction is in
`primitive_residue_extension.py`, with the shared clique implementation's
full-order mode selected explicitly; the original paired mode is unchanged
by default.

The existing arithmetic test suite has 50 passing controls, including
full-order/full-ring equivalence, nonunit handling, inactive two-primary
conditions from unselected primes, required-new-prime selection, and exact
frontier continuation. Synthetic positive subset controls are not
counterexamples and are rejected by the separate full-ring verifier.

The target-2 durable search is recorded in
`primitive-full-order-target2-submission.json`, with the persistent frontier
in `primitive-full-order-target2.json`. Its first 45-second checkpoint had
32 prefix-coordinate joint matches but no full selected-product match.
Those matches are not candidates. Target 3 is a separate domain, not an
exclusion inherited from the target-2 search.

Target 2 subsequently reached its 600-second search bound, returning
normally after 632.7 total runner seconds. It completed 18 minimum-prime
domains, left 1,631 unresolved, and retained 1,815 exact frontier families.
There were 158,474 prefix nodes, 8,830,146 half-subset nodes, 53 joint
prefix-coordinate matches, and 39,348 actual selected-product checks; no
candidate resulted. The new pool is not excluded.

The disjoint target-3 domains now run from the same unchanged input,
without rebuilding it or increasing the search limit. Their receipt and
frontier are `primitive-full-order-target3-submission.json` and
`primitive-full-order-target3.json`. CLI output is summarized by counts,
while the persistent results retain every required index and unfinished
family; a separate CLI regression confirms that distinction.

Relative to the prior paired construction, these computations admit
previously absent residue classes and retain the full local-order
conditions. They have not improved the central existence result: an
explicit full-ring counterexample is still missing, and neither timeout
permits campaign completion.

A separate bounded Jacobian ingredient probe inspected and executed
`diophantine.pell_equation.solve` at D=202, yielding exactly

    19731763^2 - 202 * 1388322^2 = 1.

Its x-coordinate is not a prime: 19731763 = 107 * 184409. Attempting the
prime local-order criterion on it raised an explicit order-bound error;
no local-order result was obtained. The same composite integer also fails
the original full-ring verifier at r=5, as recorded in
`rejected-pell-202-product.replay.json`. The inspected declaration, exact
payload, typed output, successful CLI status, and separate downstream
error are under `jacobian/pell-202*`.

The Pell equation supplies an integer ingredient, not a primality
certificate or a prime-product construction. This single failed ingredient
does not exclude Pell-generated primes or any original counterexample
route. No unrestricted Pell construction has been executed.
