# Direct terminal factors from quadratic congruences

The target is an actual product, not acceptance of the earlier construction
reduction. For a prefix of distinct primes in one source residue pair, let
P be its product and L its largest prime. We require L<q<s<P,

    P*s-1 = a*(q^2-1),  P*q-1 = b*(s^2-1),  a,b positive integers,

and (P/p)*q*s=1 modulo p^2-1 for each prefix prime p. Primality and every
coefficient of the original identity modulo n=P*q*s remain separate checks.
The original independent verifier is `../../certificates/verify_candidate.py`.
No witness or independent acceptance is presently asserted.

## Scope and existing inputs

`../joint-korselt/CONSTRUCTION.md` and `../source_criteria.md` supply the
declared pairs and retained prefix helpers. Their source implications are
not substituted for the original verifier. No new external existence theorem
is assumed. The exact universal positive-affine obstruction and the three
excluded fixed source families are not reopened.

The settled `../joint-korselt/two-free-p2000-sieved.json` records 251721
nonzero full-ring trials, 146905 small-factor rejections, and 2288 completed
prefixes. Its unresolved cursor is prefix (283,1483,1987), prefix index
2288, class zero, next V=458104008251708401. This construction starts with
that prefix and the later prefix domains; it does not resume or enlarge the
V progression. Its own checkpoint retains the input boundary exactly.
Completed prior domains, old cursors, Reviewer judgments, and the earlier
alternate-runtime question are unchanged.

## Exact generation

The second terminal equation gives

    b*s^2 = b-1 (mod P),  q = (b*s^2+1-b)/P.

Since q and s are odd with q<s, q<=s-2. Therefore

    b*s*(s^2-1) = s*(P*q-1) < P*(s^2-1),

so b*s<P and

    1 <= b <= floor((P-1)/(L+4)).

This bound follows from the actual terminal equation, not from a free
numerical cutoff. For each such b, solve the quadratic congruence modulo
every prefix prime and combine the roots by CRT modulo P. Every final
prime s>P's largest prime is coprime to P. A root s=0 modulo a prefix
prime cannot be such a prime and is omitted explicitly. Roots s=+1 or -1
cannot satisfy b*(s^2-1)=-1 modulo that prime.

For each remaining root representative z modulo p, store

    b = -(z^2-1)^(-1) (mod p).

The roots occur as z and -z; representatives 2<=z<=(p-1)/2 enumerate
each nonzero pair once. For fixed b, each local equation has either zero
or two such roots. A CRT root and its negative modulo the odd P contain
exactly one odd representative. Keeping that representative does not
discard a prime s. Since 0<s<P, each residue gives at most one possible
integer s, and the displayed formula then generates q exactly.

The implementation checks the interval, the source pair, the first
terminal equation, and every prefix equation. Any full match is replayed
with arbitrary-precision arithmetic, exact primality, and
the original coefficientwise verifier. Even a genuine original witness
outside the intended prime-factor construction is retained rather than
silently discarded. Such a witness would not establish the stronger
prime-construction milestone without its prime checks.

For the current native bounded kernel P must be less than 2^126, every prefix
prime at most 10^6, and the prefix size odd between 3 and 15. These are
explicit implementation limits, not mathematical exclusions. Products
used in the terminal equations use unsigned 256-bit arithmetic. The
s< P/b bound is applied before forming b*s^2, so that expression is less
than P^2 and fits. CRT roots use unsigned 128-bit arithmetic, with
each intermediate sum below 2P. Prefix congruences are multiplied modulo p^2-1, not
through a possibly overflowing full n.

## Jacobian's role

The installed exact contracts inspected were
`number_theory.padic.roots.compute` and
`polynomial.multivariate.resultant.compute`. The selected operation is
the former, at precision one, for the actual b=4 local congruence
4*s^2-3=0 modulo the admissible prefix prime 83. Its polynomial schema
specifies descending coefficients; the payload explicitly follows the
schema, not the opposite-looking catalog example.

The root operation returns simple roots and separately reports multiple
residues. In this construction any admissible nonzero root has derivative
2*b*s nonzero modulo p: p is odd, b=0 has no root, and s=0 is forbidden.
Thus no eligible terminal prime is lost through that contract's
multiple-root limitation. This one local arithmetic operation is not a
solver verdict for the coupled prime system. Exact requests, contracts,
outputs, and exit/timeout status are kept separately under `jacobian/`.
The pinned CLI does not expose an MCP server version or protocol, so
neither is invented.

## Reproduction

Build the bounded native arithmetic kernel:

    c++ -std=c++17 -O3 -Wall -Wextra -Werror \
      search/coupled-factor-completion/factor_roots.cpp \
      -o search/coupled-factor-completion/factor_roots

Run the Python controls and a short construction checkpoint with the pinned
interpreter. A continuation reads its own `--resume` file. Any run over two
minutes is submitted to Argus's durable runner from this route directory,
with one CPU and no accelerator.

A finite no-witness result is only a scoped computational boundary, never
proof of Agrawal's conjecture or completion of this campaign. The actual
prime product and independent Host Reviewer replay remain the goal.

Prefix primality uses the existing exact trial-division helper. For a
full-ring-passing product, the new q and s instead receive separately
replayed Pratt factor certificates, avoiding a square-root-sized sieve for
large terminal factors. The original n,r,d and full-ring replay are saved
before those requests. UNKNOWN cannot assert prime factors or complete the
stronger source-construction claim; it also cannot erase a genuine original
counterexample already established by the full-ring arithmetic.

## First measured boundary and changed construction

`p2000-pilot.json` completed the retained tail of 2582 prefix domains in
3.4082610280020162 wall seconds. It processed 191574883 quotient values,
23700203 locally soluble values, 94800812 odd CRT roots, and 2576 ordered
terminal pairs. Thirteen pairs met the source residues; none met both
terminal equations. Of the completed prefixes, 2201 had inconsistent
prefix CRT conditions. These are finite computations, not an existence
result or independently accepted exclusion of the entire conjecture.

The second mechanism changes both the elimination and the unresolved
cardinality: five prefix primes and two newly generated terminal factors.
It does not increase or resume the old V progression.

Put C=P^2-b*(P^2-1). The polynomial identity

    P^2*(P*q-1-b*(s^2-1)) + b*(P*s-1)*(P*s+1) = P^3*q-C

implies q^2-1 divides P^3*q-C at any terminal solution. Consequently

    q-1 divides U=(P-1)*(P^2+b*(P+1)),
    q+1 divides W=(P+1)*(P^2-b*(P-1)).

The inspected resultant contract eliminates s from P*q-1-b*(s^2-1)
and P*s-1 and returns the displayed polynomial P^3*q-C. This elimination
is a necessary divisibility relation, not the assertion P*s-1=0.
The actual first equation is still checked on every generated pair.

For fixed P,b the changed algorithm enumerates q=d+1 from every positive
divisor d of U, filters q+1 dividing W, and requires

    s^2 = (P*q+b-1)/b

to be an exact integer square in q<s<P. It then checks both original
terminal equations, the source pair, and every prefix equation. Root
tables exclude b only when its second terminal congruence has no eligible
nonzero root modulo a prefix prime.

The factors of P-1 and P^2+b*(P+1) are requested separately using the
inspected `integer.factor.certified_compute` operation. Its 30-digit
limit and UNKNOWN outputs are explicit unresolved cases, not exclusions.
Every COMPLETE result is replayed through its recursive Pratt certificates
and its exact product before any divisor enumeration. The order witness
criterion is sufficient: for every prime ell dividing the certified
integer p, the checks force p-1 to divide the multiplicative order modulo
ell, hence p-1 divides ell-1 and ell>=p. Thus p itself must be prime.
Factoring p-1 completely is checked recursively down to 2, not assumed.

The selected finite slabs leave all unselected prefixes and larger b
unresolved. `resultant_divisors.py` preserves the exact b cursor and every
unresolved operation. `../../certificates/coupled-factor-replay.py` can
replay an individual saved trial using its two typed factor certificates.
This is Engineer-side exact arithmetic replay, not Host Reviewer acceptance.

## Complete prefix envelope instead of an arbitrary small-b window

Let V_min be the least positive integer in any complete prefix CRT class
within the necessary complement interval. If there is none, this prefix
has no completion. Otherwise every eligible pair satisfies V=q*s>=V_min.
The terminal inequality b*s<P and q<s imply

    b^2*V < P^2,
    b <= floor(sqrt(floor((P^2-1)/V_min))).

This further bound is exact and uses no primality heuristic. For prefix
(83,107,347,563,587) it reduces the necessary b interval from
1<=b<=1723258225 to 1<=b<=1688. It addresses the missed-large-b concern
with a bound from the full prefix system, not an arbitrary scan limit.
`--prefix-envelope` enables it in the root generator; the old checkpoint
and its original counts are not rewritten or replayed.

The terminal-only positive control

    P=37*41*43*47*59=180885563, q=107, s=179,
    a=2828312, b=604081

satisfies both terminal equations and is regenerated exactly. Its factors
are not in one source pair, so it is not a source-construction witness.
It is used only to guard against an accidentally empty terminal solver.

The complete seven-factor run `seven-factor-envelope-p2000.json` examined
all 60326 five-prime prefix domains through 2000. It excluded 59451
inconsistent prefix systems and consumed 3836376 derived quotient values
in the others. It generated 9645 ordered terminal pairs, of which 106
met the source pair and none passed both terminal equations. Its elapsed
wall time was 2.8282471739221364 seconds. This is another finite
counterexample-search boundary, not a conjecture-wide result.

Higher-cardinality prefixes exceeded the first native kernel's integer
envelope: (83,347,587,1283,1307,1523,1787) has
P=77156473246355997947>2^64. The separately selected
`--arithmetic exact_python` implementation uses arbitrary-precision
integers throughout and the same exact prefix envelope. It is explicit,
not a silent native-overflow fallback. The original native implementation
and its completed cursors remain available and unchanged.

The nine-factor pilot `nine-factor-envelope-p2000.json` completed 203643
of 304353 declared prefix domains, with its next quotient b=2230001
inside prefix index 203643. It processed 12618115 quotient values and
generated 2502 ordered terminal pairs; none met both terminal equations
and the source pair. The pilot stopped after 45.53271054907236 seconds
with an unresolved domain, not an exclusion.

The route-local durable receipt is `nine-factor-submission.json`, task
`coupled-factor-nine-envelope-p2000`, run
`coupled-factor-nine-envelope-p2000-1788618423564096919`.
Its one-CPU, zero-accelerator continuation reads that pilot and writes
`nine-factor-continuation.json`; it never rewrites the pilot or a prior
V cursor. Its receipt's `check_with` command is run from this route
directory, where the Argus registry lives. A budget return, even with
zero residual candidates, leaves the existence obligation open.

## Continuation with a measured wider exact kernel

The first durable nine-factor run returned exit zero after 618.2 runner
seconds. Its cumulative checkpoint has 37297607 quotient values,
220740 completed prefixes, and 3874 ordered terminal pairs. No source-pair
solution of both terminal equations was found. It retained prefix index
220740, next b=2100001, so this run did not exhaust its declared domain.

The inspected live child was PID 2460781, not the runner's bash wrapper.
At 10:00 elapsed it had accumulated 1:00 CPU and reported 10.0% CPU on
its leased CPU 0. This is a measured shared-host occupancy observation,
not proof of a particular scheduler cause. A fixed current-prefix
profile spent 0.063 of 0.075 seconds inside `odd_root_residues`.
The repeated Python modular-root loop is therefore a measured local
hot path; no global performance attribution is asserted.

The native kernel now stores CRT residues below 2^126 in 128-bit
integers and the bounded terminal products in 256-bit integers. The
weight `(P/p)*(z*inverse(P/p) mod p)` avoids an overflowing intermediate
`z*P`. Quotient endpoints remain explicitly 64-bit. Exceeding either
contract is an error, not a skipped search case.

`wide-arithmetic-ab.json`, produced by `compare_arithmetic.py`, compares
the same exact intervals and matches against Python arbitrary precision.
Both timings exclude profiling. For the current-prefix 10000-value
interval, measured CPU times were 0.018404607 seconds (Python) and
0.002011 seconds (native, including child launch). Two other intervals
also agree exactly. These small scoped measurements justify choosing
the wider kernel; they are not a whole-campaign speed claim.

An explicit `--arithmetic native` on `--resume` changes only arithmetic
implementation while retaining the exact consumed-domain cursor. It
does not repeat, enlarge, or relabel the completed Python search.

## New largest-prime prefix domain

The nine-factor continuation completed all 304353 declared seven-prime
prefixes through 2000, with 195006719 cumulative quotient values and
12118 ordered terminal pairs. None supplied a source-pair solution of
both terminal equations. The eleven-factor computation likewise
completed 705283 nine-prime prefixes, 1332134488 quotient values and 3276
ordered terminal pairs, again without a qualifying terminal pair.
`thirteen-factor-prefixes-p2000.json` separately records that none of
793468 eleven-prime prefixes through 2000 has consistent prefix classes.
These are scoped computations; larger prefix primes and the original
counterexample question remain unresolved.

The next domain has three prefix primes at most 20000, with largest
prime strictly greater than 2000. The final q and s are still newly
generated and have no external prime cutoff. No completed old prefix
is reopened. The new enumerator records its own graph indexing and
cannot interpret the old V cursor as an index into that graph.

For two distinct prefix primes p,q, a necessary compatibility edge is

    gcd(p,q^2-1)=gcd(q,p^2-1)=1,
    p=q modulo gcd(p^2-1,q^2-1).

For an entire clique, P is a unit modulo every p^2-1. Multiplying the
prefix congruences for V by that unit changes them to

    P*V=p modulo p^2-1.

The pairwise CRT criterion is exactly the displayed edge relation.
The constructor enumerates every clique of the declared size in
increasing order and then still applies the existing `prefix_classes`
helper, including the source-pair product residue classes. Thus an edge
is never substituted for all prefix equations at a candidate.
The graph is only a way to omit already-inconsistent prefixes before
generating terminal factors, not an existence argument.

`new-largest-p20000-pilot.json` completed 23217 compatible prefix triples
and consumed 1283742 quotient values. It generated 60818 ordered terminal
pairs; 459 were in the declared source pair and none passed the other
terminal equation. It retained graph prefix index 23217, next b=1, after
45.09027371695265 seconds. This new domain is unresolved; no original
counterexample or independent acceptance has been obtained.

The active continuation is task `coupled-factor-new-largest-p20000`,
run `coupled-factor-new-largest-p20000-1788619520279396215`, with receipt
`new-largest-p20000-submission.json` and checkpoint
`new-largest-p20000-continuation.json`. It runs on one CPU with no
accelerator and preserves the pilot. Consume its actual result from this
route directory using the receipt's command; neither an empty checkpoint
note nor the previous completed task is an instruction to relaunch it.

## Primary-source scope clarification

Othman Echi, *Williams Numbers*, C. R. Math. Rep. Acad. Sci. Canada
29 (2) (2007), pp. 41-47, names the simultaneous Carmichael and
Lucas-Carmichael problem in its p. 41 abstract. The primary PDF and text
are preserved under `sources/echi-williams-2007.*`; the short exact passage
is `sources/echi-2007-scope.txt`. It describes existence as open in 2007.
This is historical status, not proof of nonexistence or a verified 2026
survey. The paper's positive a-Williams constructions concern other
values of a, not a=1, and are not accepted as products for this mission.
The generated web summary's additional claims about infinite
Lucas-Carmichael families were not relied on.

Thus the present source-pair target would also supply an ordinary
1-Williams number, in addition to passing the original Agrawal verifier.
No existence theorem for those products is assumed. This known-status
clarification leaves the live witness search and all other unresolved
Agrawal routes open.

## Measured dispatch change

The live larger-prefix worker PID 2530613 was observed with only 2.1%
CPU and wait location `kernel_clone` at 3:43 elapsed. In a 22-prefix
control, 0.040 of 0.044 profiled seconds were in `subprocess.run`;
the native arithmetic for these short quotient intervals does not
justify starting a new process for each prefix.

`stream-dispatch-abba.json` uses the same 300 actual prefix requests
and identical binary in ABBA order, with exact JSON outputs compared.
Per-request launches took 0.445620977 and 0.452161520 wall seconds;
one persistent typed arithmetic stream took 0.042163317 and 0.039340143
seconds. This is a scoped dispatch comparison on the shared host, not
a claim about the total search runtime or a scheduler diagnosis.

`factor_roots_stream --stream` accepts one numeric interval request per
line and emits the same exact result schema per line. EOF closes it.
`--arithmetic native_stream --kernel .../factor_roots_stream` selects
the persistent process explicitly. Each interval is still bound to
P, b_start, b_stop, and maximum_b; failures or missing replies do not
advance the saved arithmetic cursor. The earlier durable run keeps its
old binary and existing process until its natural budget boundary.

## Isolating both terminal quotients at once

The disjoint seven-factor domain with five prefix primes through 5000
and largest prefix prime above 2000 is also searched by direct two-quotient
elimination in `two_quotient.py`. It does not resume the V progression or
regenerate the completed lower-prime five-factor domain.

Set Q=L+2 and S=L+4. At any terminal solution,

    a>b>=1,
    a*b < P^2*Q^2*S^2 / (V_min*(Q^2-1)*(S^2-1)).

For the first inequality, (P*x-1)*(x^2-1) is strictly increasing for
x>1 and a/b is its value at s divided by its value at q. For the second,
multiply the two exact terminal equations and use q>=Q, s>=S,
q*s>=V_min, and

    (P*q-1)*(P*s-1) < P^2*q*s.

Thus the exact integer upper bound K is `(numerator-1)//denominator`;
all positive quotient pairs obey a>b and a*b<=K. A selected complete
prefix domain enumerates b<=floor((sqrt(4K+1)-1)/2) and
b+1<=a<=floor(K/b). Prefixes whose K exceeds the selected work envelope
are explicitly deferred, never declared excluded.

Eliminating q from the two actual terminal equations gives

    F(s)=a*(b*s^2+1-b)^2-P^2*(P*s+a-1)=0.

The exact Jacobian resultant is -F, preserved with the source-bound
payload under `jacobian/two-quotient-resultant.*`. Unlike the earlier
necessary resultant-divisor filter, this encodes both terminal equations
simultaneously; exact divisibility by P is still checked when recovering q.

For a>b>=1 and b*(L+4)<P with L>=5, write

    F(x)=a*b^2*x^4-2*a*b*(b-1)*x^2-P^3*x-D,
    D=a*(P^2-(b-1)^2)-P^2>0.

Since b<P/9 and a>=2, the displayed D is positive. Therefore F(x)/x^4
is strictly increasing on x>0. There is at most one positive root, and
integer bisection on L+4<=s< P/b isolates it exactly. If it is an integer
root, recover q=(b*s^2+1-b)/P and check all original equations, ordering,
source residues, prefix conditions, and the existing full-ring verifier.
No floating-point root, near-integer, or incomplete solver verdict is used.

The terminal-only positive control at P=180885563 is recovered by this
different mechanism as well; it remains inadmissible as a source-pair
counterexample. The new reduction and its implementation do not themselves
establish the actual witness required by this mission.

The two-quotient pilot `two-quotient-p5000-pilot.json` processed 2226779
positive quotient pairs in 45.000001005944796 seconds. It completed 66
selected prefixes, explicitly deferred 504 whose full K exceeded
100000, and found no exact terminal pair. The saved next work item is
prefix index 570, b=6, a=4793. Deferred prefixes were not excluded.

The one-CPU continuation is task `coupled-factor-two-quotient-p5000`,
run `coupled-factor-two-quotient-p5000-1788620337701710934`. Its receipt
`two-quotient-p5000-submission.json` preserves the submitted state and
route-local status command. The checkpoint is
`two-quotient-p5000-continuation.json`; the pilot is unchanged.

Meanwhile, `new-largest-p20000-completed.json` completed the separate
three-prime-prefix domain: all 356522 compatible prefixes, 22852976
quotient values, and 1015898 ordered terminal pairs. Of these, 7271
satisfied the source pair and none met both terminal equations. The
count equals the independently measured declared graph-domain size in
`new-largest-p20000-domain-size.json`; neither is a conjecture-wide
exhaustion result or independent Reviewer acceptance. The old durable
run was consumed at exit zero before its streaming continuation, and
all earlier cursors remain preserved.

## A direct cubic candidate instead of quartic bisection

For the selected quotient domains with a<=P, every terminal solution
has the unique possible integer

    s = floor_cuberoot(floor(P^3/(a*b^2))) + 1.

This formula is exact only in the declared a<=P subdomain; it is not
applied to larger a. To see it, put

    D = a*(P^2-(b-1)^2)-P^2.

The existing domain has a>b>=1 and b<P/(L+4)<=P/9, so a>=2 and D>0.
The quartic equation gives

    s^3-P^3/(a*b^2) = 2*(b-1)*s/b + D/(a*b^2*s) > 0.

The second term is less than P^2/(b^2*s). Since
P^3<a*b^2*s^3 and a<=P, it is less than s^2. Thus the displayed
difference is less than s^2+2s, which is at most
3s^2-3s+1 for s>=3. Therefore

    (s-1)^3 < P^3/(a*b^2) < s^3.

The formula follows, including the fact that an exact integer cube on
the right cannot yield a terminal solution. Recovering q and checking
both original equations rejects that case; no numerical rounding is used.
Integer Newton iteration computes the floor cube root and is checked at
exact large cube boundaries. The inspected Jacobian nth-root contract
returns root 178, exact=false, for the actual positive-control input
5734480; both terminal solvers then recover s=179. Its typed request and
result are in `jacobian/terminal-cube-root.*`.

The source pairs impose another exact necessary condition:

    a=0 or 1 (mod 10), b=0 or 1 (mod 10).

Within each modulus-80 pair, an odd prefix product remains in that pair,
and q^2-1=8 modulo 80 while P*s-1 is 0 or 8 modulo 80.
Within each modulus-160 pair these are respectively 48 and 0 or 48,
and division by gcd(48,160)=16 again gives quotient 0 or 1 modulo 10.
The same argument applies to b. For every prefix prime p, a and b
must also lie in the stored nonzero quadratic-root quotient classes
modulo p, because both generated terminal primes exceed every prefix
prime. These are filters of the full source construction, not exclusions
of arbitrary terminal-only integer solutions.

`--isolation cubic --source-quotient-sieve` selects this changed
factor-producing arithmetic explicitly. The driver retains every consumed
a,b cursor, rejects no prefix outside the stated formulas as a theorem,
and records larger-K or a>P domains as deferred. The measured domain has
67348 compatible new five-prime prefixes through 5000, of which 6419
have K<=100000 and 60929 are deferred; their maximum K is
18533850279291. These counts are not an existence result.

The active worker PID 2605174 was measured at 3:48 elapsed with 0:25 CPU
on CPU 0; that shared-host observation does not identify a scheduler cause.
A profile of 1000 active-prefix quotient pairs made 49476 calls to the
quartic evaluator. `cubic-isolation-abba.json` compares 10000 identical
pairs, without the source sieve, in ABBA order. Quartic CPU times were
0.318800631 and 0.319237071 seconds; cubic times were 0.029357332 and
0.029395930 seconds. Outputs and the exact positive terminal-only control
agree. This supports the scoped implementation change, not a whole-run
speed claim or a new counterexample.

## Completing the saved deferred prefixes with a different generator

The earlier durable quartic run completed with exit zero after 600.9
runner seconds, at prefix index 894, b=4, a=5025. Its cumulative record
has 4135678 a,b trials and no terminal pair. The exact cubic continuation
read that cursor only. `two-quotient-p5000-cubic.json` then consumed all
6419 selected prefixes with K<=100000, reaching 47656508 cumulative
a,b trials and 288752 new cubic isolations. It found no terminal pair
and left exactly 60929 larger-K prefixes unresolved.

The new root construction accepts that settled checkpoint using
`--deferred-quotient-input`. It enumerates exactly its saved deferred
prefix list in the original order. Each entry is checked for distinct
source-admissible primes, its recorded K is recomputed from the complete
prefix equations, and a prefix belonging to the already consumed
selected-K class is rejected as an invalid input. A running checkpoint,
duplicate prefix, or inconsistent input is not silently reused.

The measured total root domain for these prefixes is 508521298 positive
b values, with largest complete b bound 4305095. This is
`deferred-root-domain-size.json`, not a witness or a performed terminal
search. It avoids raising the selected a*b limit: s comes directly from
the complete modular-root classes, q follows from P*q-1=b*(s^2-1), and
the first terminal equation and every prefix condition remain mandatory.
The two mechanisms own disjoint prefix sets, and the original selected
and deferred files remain unchanged.

`deferred-roots-p5000.json` consumed all 60929 deferred prefixes in
33.76523985294625 wall seconds. It processed exactly 508521298 quotient
values, generated 701503 ordered terminal pairs, and found 6673 source
pair matches, none satisfying both terminal equations. The count matches
the separately measured deferred domain. Together with the 6419 selected
prefixes this covers the full declared set of 67348 compatible new
five-prime prefixes through 5000, without a witness. This does not extend
to larger prefix primes, a different factor count, or the full conjecture.

The changed unresolved domain now has seven prefix primes through 5000,
with largest prime strictly above 2000 and two free terminal primes.
It is disjoint both from the completed five-prime-prefix domain and from
the older seven-prime-prefix domain through 2000. The pilot
`nine-factor-new-largest-p5000-pilot.json` consumed 800 compatible
prefixes and 1361628842 quotient values in 45.03071010205895 seconds.
It generated 31154 ordered terminal pairs, with 291 source-pair matches
and no solution of both terminal equations. It retains prefix index 800,
next b=207000001; no domain exhaustion or independent acceptance is asserted.

Its active one-CPU continuation is task
`coupled-factor-nine-new-largest-p5000`, run
`coupled-factor-nine-new-largest-p5000-1788621382312549190`, with receipt
`nine-factor-new-largest-p5000-submission.json` and exact checkpoint
`nine-factor-new-largest-p5000-continuation.json`. The receipt's status
command is run from this route directory. The task consumes the new
pilot cursor, not a completed earlier domain, and its finite budget
cannot complete the campaign without an original witness.
