# Dependent-form conditional moments, failed shortcut and finite replay

## Exact claim and provenance

`C_PACK_MOMENTS@1` is the old Argus all-positive-integer raw-moment
extension of the manuscripts' first/second-moment argument. It is not
a verified-new literature claim. The shared old `report.md` proves it in
prose; `verify.py` and `exact_certificate.json` exercise finite cases.
The old `judgement-C_PACK_MOMENTS-464b1d3c6e4b`, by
`reviewer:65ff03c5a5e8`, binds to its exact recorded statement. Sources
are the snapshot-bound old files and the staged manuscript revision
identified in [scope](../scope-and-boundaries/report.md).

Fix nonzero pairwise nonparallel integer forms `a_1,...,a_r`, `r>=2`;
no joint-rank or `r<=m` hypothesis is imposed. Let `q` be an odd prime
preserving their rational row rank `b` and every pair's rank two.
Only finitely many primes are excluded by nonzero minors. All relations
below are tested over the **actual** `F_q`, not only over the rationals.
Fix positive odd `L_i`, let `L=sum L_i`, and set

    R=floor(sqrt(q)), K=ceil((q-1)/(2R)), p=1/(2L),
    tau_q=(1+4LK+2R)/q.

For the manuscript's independently shifted chunks and independently
oriented retained slots, `C_i(s)` indicates an oriented type-i center.
`V_i,s` is `C_i(s)=1`, and
`Z_i,s=q^{-(m-1)} sum_{a_i.y=s} product_{j!=i} C_j(a_j.y)`.
Take nonzero `s` outside `E_i`, where `E_i` is the union over
`j<l`, both distinct from `i`, of relations
`a_j +/- a_l = c a_i`, `c!=0`, with folded `abs(cs)_q<=R`.
Condition only when `Pr(V_i,s)>0`.

For every positive integer `u`, putting `k=u(r-1)`, the claim is

    abs(E[Z_i,s^u | V_i,s] - p^k)
      <= k tau_q + 2 binom(k,2)(2R+1)/q.

The inequality is exact for every such `u`; its useful asymptotic
interpretation fixes `u,r,L`. Large right-hand sides can be vacuous.
There is no assumption that the conditioning center itself is interior.

## Decisive proof, checked against the random model

Sample `u` independent uniform vectors on `a_i.y=s`, independently of
the slots. Each of the `k` other evaluations is marginally uniform by
the [counting alternative](../affine-counting/report.md). At most `2LK`
positive sites are noninterior. Folding, zero and the whole conditioning
chunk give bad probability at most `tau_q` per evaluation, regardless
of whether `s` is an endpoint.

For two evaluations in one copy, equal folded chunks force one signed
sum/difference to have folded size at most `R`. If that signed form is
nonproportional to `a_i`, the probability is at most `(2R+1)/q`.
If proportional, its value is `cs`; pairwise rank two forces `c!=0`,
and exclusion of `E_i` makes the event impossible. This is why the
exceptional set, including modular-only relations, cannot be omitted.
Across different copies the evaluations are independent uniform scalars,
so both signed combinations have the same bound, even for the same
form index.

A union bound over evaluations and unordered pairs bounds the bad-tuple
fraction by the displayed right-hand side. On a good tuple every required
evaluation lies at an interior site in a different chunk, avoiding the
conditioning chunk. Exactly one shift among `L`, and one orientation
among two, gives each required center. Chunk independence therefore
gives conditional product probability exactly `p^k`.

Conditioning only exposes randomness of the conditioning chunk; it does
not change the independently sampled tuple distribution. Bad tuples
have conditional product probabilities in `[0,1]`. Thus, for bad
fraction `d`, the expanded moment equals `(1-d)p^k+d a`,
`a in [0,1]` (with the term omitted if `d=0`), giving error at most
`d`. In particular no division by the potentially small presence
probability is used to bound the bad fraction.

The implementation agrees with this model: `Slots.probability` integrates
shifts and independent per-slot orientations; duplicate requirements
refer to the same physical center, not fresh coin tosses.
`moment_case` expands ordered fiber samples using exact fractions.
The universal proof is this good/bad-tuple argument, not the enumeration.
No gap was found within the stated hypotheses.

## Failed attack is not a manuscript error

Old `R_PACK_JOINT` is correctly retired: `(1,0),(0,1),(1,1)` are
pairwise nonparallel but jointly rank two, and their evaluations satisfy
the same linear relation. Pairwise nonparallelism does not give joint
independence. The manuscripts explicitly avoid that inference.
Rejecting this shortcut does not refute their packing lemma.

`R_PACK_MOMENTS` was retired for a different reason: its preliminary
counting-v1 reference was replaced by the encoded v2 statement.
`R_PACK_MOMENTS_FORMAL` is the current historical algebraic reduction;
its name does not mean the probability argument was formalized.

## Actual replay and its limits

The required unchanged replay ran as

    $WORKSPACE/argus-latest/.venv/bin/python \
      families/076/first-pass/packing-audit/verify.py

with no `--write-certificate`. It returned `status=verified`, nine
finite-model cases and process exit zero in **1.66 seconds**. The
captured [stdout](replay.stdout.json) and [stderr/timing](replay.stderr.txt)
are current evidence. Its printed Lean exit and proof-hole fields are
historical fields checked against the archive, not a new compiler run.
Its printed pending-Reviewer string is also an old static string.

| Finite case | q | (r,m,b) | Meaningful coverage |
|---|---:|---|---|
| dependent_boundary | 101 | (4,2,2) | Higher dependencies and boundary presence |
| other_fiber_boundary | 101 | (4,2,2) | Different conditioning form |
| unequal_odd_slots | 101 | (4,2,2) | Lengths `(1,3,1,3)` |
| good_tuples_with_dependencies | 211 | (4,2,2) | Six first-order good tuples |
| second_moment_distinct_chunks | 211 | (3,2,2) | 1344 good ordered pairs out of 44521 |
| modular_only_exception | 101 | (3,2,2) | Relation created on modular reduction |
| rank_below_ambient_dimension | 7 | (4,3,2) | Nontrivial generating multiplicity |
| rank_three_higher_dependencies | 11 | (5,3,3) | Rank-three dependent collection |
| third_raw_moment | 31 | (4,2,2) | Ordered third-moment expansion |

All nine fixtures' conditioning centers are noninterior, and **all their
displayed explicit error bounds exceed one**. They exercise exact
probabilities and algebraic branches but do not empirically establish a
nonvacuous asymptotic estimate. The third-moment enumeration has no good
tuple; a separate specified good triple at `q=101` checks conditional
product `1/64`. The large-field `120132/1000003<1` check at `q=1000003`
is a bound-only arithmetic check, not an enumerated moment.

The separate full-model check enumerates 48 shift/orientation states at
`q=11`, lengths `(1,3)`, and obtains conditional moments `1/44,1/484`,
agreeing with the independent expansion path. Guards exclude a bad
prime, zero and zero-probability conditioning. This is useful finite
regression evidence, not proof for untested fields or parameters.

## Jacobian boundary

The old contract, request and result record only rank two for the four
rows `(1,0),(0,1),(1,1),(1,2)` over `F_101`. They do not compute
conditional moments. Current discovery found the prime-field rank,
symbolic rank and finite-linear-map rank operations among its candidates.
After [inspecting the exact contract](jacobian_contract.json), one
bounded operation `prime_field.matrix.rank.compute` was executed using
the required isolated Argus adapter and the [exact payload](jacobian_request.json).
The [typed output](jacobian_result.json) preserves that payload and gives
rank `2`, server `0.14.0`, protocol `2025-11-25`, `mcp-stdio`,
runtime `0 ms`, adapter exit `0`, no structured error and no timeout.
It replays only the old atomic rank fixture. No adapter result is being
substituted for the universal moment proof.
