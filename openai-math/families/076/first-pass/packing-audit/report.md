# Dependent-form signed interval packing

## Scope and sources

This audit concerns the signed-packing argument, not the analytic construction
of real ultraflat Littlewood polynomials. The detailed source is
`Nearly-minimal-maxima-and-positive-minima-of-Littlewood-polynomials-October-5-2026/build/sections/packing.tex`,
lines 19-32 and 70-323, under `research/openai_manuscript/`.
Its hypotheses are nonzero pairwise nonparallel integer forms, positive widths,
and `2 sum_i w_i < 1`. There is no assumption `r <= m`.

The manuscript explicitly rejects joint independence of all the forms.
For example, the rows `(1,0), (0,1), (1,1)` are pairwise nonparallel but
dependent. Replacing the fiber argument by joint independence is a dead route,
not an error asserted by this manuscript. The ledger records that distinction.

The inherited dependency chain is:

| Manuscript | Packing source and downstream use | Outside this audit |
|---|---|---|
| September minimal-maxima | `build/packing.tex`, `lem:signed-packing`; `sampling.tex:113-286` uses it with `w_i=abs(lambda_ai)` in `prop:almost-signs`; `reduction.tex:40-58` combines this with rounding for `thm:main` | Auxiliary polynomial, sampling estimates, rounding, all-length main theorem |
| October lower-envelope | `build/sections/packing.tex`; `sampling.tex:161-185` uses negated centers and `w_i=abs(lambda_ai)` for `prop:starting`; `correction.tex`, `prop:correction`, and `completion.tex` use the starting construction for `thm:main` | Correction estimates and the claimed lower bound `sqrt(N)/16` |
| October ultraflat | `build/sections/waves.tex:28-38` cites lower-envelope Lemma 3.1; `waves.tex:64-114` uses packing to place inverse-curvature intervals; `prop:waves` feeds `completion.tex`, `thm:main` | Balanced auxiliary construction, joined waves, exterior tails, rounding, ultraflatness |

The September and ultraflat source map was obtained by a separate read-only
source-mapping worker. It is not an independent mathematical review.

The only non-elementary mathematical input needed to pass from the counting
argument to packing is the Pippenger--Spencer edge-coloring theorem, in the
quantified formulation cited as Alon--Yuster, *On a hypergraph matching
problem*, Graphs and Combinatorics 21 (2005), 377-384, Lemma 2.1,
DOI `10.1007/s00373-005-0628-x`. The staged bibliography identifies this
proposition; primary-source reading and independent citation attribution are
separate obligations. A search-engine paraphrase was not used as evidence.

No relevant Littlewood/packing result was found in the inherited Wiki index.
The similarly named endpoint-notch packing page concerns a different problem.

## Exact target and conventions

Let `q` be an odd prime for which the form matrix has its rational rank `b`
and every pair of rows has rank two over `F_q`. Only finitely many primes
are excluded: choose a nonzero maximal minor and one nonzero two-by-two
minor per pair, and exclude their prime divisors. Modular relations are
nevertheless recomputed over `F_q`, not inferred just from rational relations.
Admissible primes are unbounded: for any finite list of primes, a prime
divisor of one plus their product lies outside that list.

Use the manuscript's positive odd slot lengths `L_i`, period
`L=sum_i L_i`, `n=(q-1)/2`, `R=floor(sqrt(q))`,
`K=ceil(n/R)`, `p=1/(2L)`, and its independently shifted and oriented
chunk construction. Define

    tau_q = (1 + 4 L K + 2 R) / q.

For `s != 0`, `Z_{i,s}` is the normalized sum over `a_i.y=s` of
`prod_{j != i} C_j(a_j.y)`, and `V_{i,s}` is `C_i(s)=1`.
The set `E_i` is exactly the union, over `j<l`, `j,l != i`, of the
nonzero `s` for which

    a_j + a_l = c a_i  or  a_j - a_l = c a_i,
    c != 0, abs(c s)_q <= R.

The target is the explicit bound, whenever `s` is outside `E_i` and
`Pr(V_{i,s})>0`,

    abs(E[Z_{i,s}^u | V_{i,s}] - p^(u(r-1)))
      <= u(r-1) tau_q + 2 binom(u(r-1),2) (2R+1)/q.

The argument below will distinguish a parameter-uniform proof from the
finite examples used to exercise the exact implementation. No failure at
finitely many primes, zero-probability conditioning event, or exceptional
center would refute an existential asymptotic packing assertion.

## Theorem: dependency-robust raw moments

The displayed target holds, in fact, for every positive integer `u`.
The coefficients in its error term are explicit and depend only on
`u,r,L,R,K,q`, not on the rank of the whole collection or on the chosen center.
No claim of literature novelty is needed or made for this strengthening.

### 1. Exact counting, including the constant alternative

Let `f,g:V -> F_q` be linear forms, with `f` nonzero. If `g=c f`,
then `g(y)=cs` for every `y` with `f(y)=s`. Otherwise there is a vector
`v` with `f(v)=0`, `g(v)=1`. To see this, choose `w` with `f(w)=1`.
If `g` vanished on `ker(f)`, applying it to `x-f(x)w` would show
`g=g(w)f`, a contradiction. Normalize any vector of `ker(f)` on which
`g` does not vanish.

More generally, if `F:V -> W` is a linear map and `F(v)=0`, `g(v)=1`,
the maps

    x -> (g(x), x-g(x)v),        (a,z) -> z+av

are inverse bijections between `F^(-1)(s)` and
`F_q x {z:F(z)=s, g(z)=0}`. Restricting the first coordinate to any
subset `B` proves the exact integer identity

    q #{x:F(x)=s, g(x) in B} = |B| #{x:F(x)=s}.

These are universal algebraic bijections, not finite tests. They are encoded
in `formal/Main.lean` as `fiberEquiv`, `selectedFiberEquiv`,
`uniform_fiber_count`, `exists_kernel_normalized_of_not_scalar_multiple`,
`nonparallel_forms_uniform_count`, and `constant_on_fiber`.
The finite-field result is a specialization of a theorem over every finite
commutative field, in arbitrary finite vector spaces.

In particular, on `a_i.y=s`, each other `a_j.y` is exactly uniform.
For a signed combination `g=a_j+a_l` or `g=a_j-a_l`, precisely one of
the following holds: its restriction is uniform, or it is constant `cs`.
In the constant case, `c` cannot be zero: `a_j=+/-a_l` would contradict
pairwise rank two. This alternatives argument is valid even when many
larger collections of the forms are dependent.

### 2. Boundary and same-copy collisions

There are at most `2 L K` noninterior positive sites: each chunk loses
at most `L` at each end, even if it is short. Thus a uniform residue
is zero, folds to a noninterior site, or folds into the entire
conditioning chunk `Q_s` with probability at most

    (1+4 L K+2R)/q = tau_q.

This estimate avoids `Q_s` whether the center `s` is interior or at an
endpoint. It never divides by the probability of `V_{i,s}`.

If two nonzero residues fold into the same chunk, then one signed
sum or difference has folded absolute value at most `R` (in fact at
most `R-1`). For two evaluations from one fiber vector, the exact
counting alternative above bounds each signed event by `(2R+1)/q`,
unless the signed form is constant. A constant event of that size
would put `s` in `E_i`; for `s` outside `E_i` its probability is zero.
This uses relations over the actual field, including ones created only
after reduction modulo `q`.

For each fixed `i`, each signed pair has at most one nonzero scalar
`c`. Multiplication by `c` permutes the field, so

    |E_i| <= 2 binom(r-1,2) (2R+1).

If `2R+1>q`, the same cardinal upper bound is still valid, though loose.

### 3. Cross-copy collisions and the explicit moment bound

Take `u` independent uniform vectors in `a_i.y=s`, independently of
the slots. Label their `k=u(r-1)` other evaluations by both copy and
form index. Evaluations from different copies are independent uniform
residues, even if their form indices are the same. Therefore their
signed sum and signed difference are uniform. Alternatively, the
general counting bijection applies on the product affine fiber: put
the normalized kernel witness in one copy and zero in all others.

There are `k` boundary/conditioning-chunk events and `binom(k,2)`
possible pairs. The union bound gives the deterministic bad-tuple
fraction

    delta_u = k tau_q + 2 binom(k,2) (2R+1)/q.

No claim of pairwise or joint independence inside one copy is made.
Outside this bad set, all required evaluations lie at interior sites in
different chunks, none equal to `Q_s`. In a specified other chunk,
one shift among `L` places the required type at that interior site,
and its orientation succeeds with probability `1/2`; hence the
probability is exactly `p=1/(2L)`.

The event `V_{i,s}` is measurable using only the shift and orientations
of `Q_s`. Thus, for every good tuple, the product of its required
center indicators has conditional expectation exactly `p^k`. For a bad
tuple its conditional expectation is in `[0,1]`. The samples themselves
remain independent uniform after conditioning, since they were chosen
independently of all slots.

Expanding the finite sum defining `Z^u` and averaging, with `d` the
actual bad fraction, gives

    E[Z^u | V] = (1-d)p^k + d a,       0 <= a <= 1.

If `d=0` the second term is zero without defining `a`. Consequently

    abs(E[Z^u | V]-p^k) <= d <= delta_u.

This proves the requested estimates for `u=1,2`, and also all positive
integer raw moments. If `delta_u>1` it is merely a loose upper bound.
If `Pr(V)=0`, the claim makes no conditional-expectation assertion.

## From moments to the manuscript's matching

Fix the forms and slot lengths, put `A=r-1`, `t=p^A>0`, and write
`D_q=t q^(b-1)`. For `q>=3`,

    R >= sqrt(q)/2,     K <= sqrt(q)+1,
    tau_q <= (8L+3)/sqrt(q),    (2R+1)/q <= 3/sqrt(q).

Hence `delta_u <= (8Lk+3k^2)/sqrt(q)`. In particular

    E[(Z-t)^2 | V] <= delta_2+2t delta_1
      <= (32LA+18A^2)/sqrt(q).

This follows by expanding the square; it does not identify raw second
moment with variance. Let `epsilon=q^(-1/8)`. Conditional Chebyshev at
threshold `epsilon t` bounds the degree-outlier probability by

    (32LA+18A^2) t^(-2) q^(-1/4).

Here the finite-sample inequality is simply
`E[(Z-t)^2|V] >= (epsilon t)^2 Pr(abs(Z-t)>epsilon t|V)`;
no additional probabilistic literature theorem is an input.

There are at most `r(q-1)` candidate nonzero centers. The actual
outlier event includes presence, so its unconditional probability is
at most this conditional bound; zero-probability presence events
contribute zero. Adding at most `r*6 binom(A,2) sqrt(q)` exceptional
vertices, the expected deletion count is at most

    C_bad q^(3/4),
    C_bad = r((32LA+18A^2)/t^2 + 6 binom(A,2)).

For sufficiently large admissible primes, `C_bad q^(-1/8)<1`.
Markov therefore gives a realization with fewer than `q^(7/8)`
vertices requiring deletion.
Indeed, if every realization had at least that many, the expectation
could not be strictly smaller.

Each compatible center tuple is included only once. Rank `b` makes
every edge have exactly `q^(m-b)` generating vectors: row reduction fixes
`b` pivot coordinates and leaves `m-b` free coordinates. Therefore

    degree(i,s) = q^(b-1) Z_{i,s}.

For two different types, pairwise rank two leaves `q^(m-2)` generators
before the other constraints are imposed. Dividing by the same
edge multiplicity gives codegree at most `q^(b-2)`. Two vertices of
one type have codegree zero. This argument remains valid when
`b<m` and `r>m`.

A surviving vertex loses at most `q^(7/8) q^(b-2)` incident edges.
Relative to `D_q` this is at most `t^(-1)q^(-1/8)`. Its retained
degree lies between

    (1-(1+t^(-1))q^(-1/8))D_q  and  (1+q^(-1/8))D_q.

The maximum relative codegree is at most `1/(t q)`. Each type
originally has `q/(2L)+O(q/R+1)` vertices and loses at most
`q^(7/8)`, so the retained total is `(1+o(1))r q/(2L)`.
All relative errors tend to zero; also `D_q -> infinity` because
`b>=2`.

Apply the external Pippenger--Spencer theorem with each fixed
`gamma>0`, eventually meeting its degree and codegree tolerances.
Degree summation gives `(1+o(1))|V|D_q/r` edges. An edge partition
into at most `(1+gamma)D_q` matchings has a class of size at least
`(1-o(1))|V|/(r(1+gamma))`. Take `H_q` to be the maximum matching
size. For each fixed `gamma>0`, its normalized lower limit is at least
`1/(1+gamma)`. Since `gamma` is arbitrary, that lower limit is at least
one. Since any matching uses one vertex of every type, the per-type
upper bound gives

    H = (1+o(1))q/(2L).

The independent source reader obtained Alon--Yuster Lemma 2.1 from
the author copy; its exact statement and reading caveat are preserved in
`literature/alon-yuster-lemma-2.1.md`. This theorem remains an explicit
external input, not a Lean-certified part of the proof.

## Strict closed-interval containment

For completeness, the width-budget hypothesis supplies the odd lengths:
choose `alpha_i>2w_i` summing to one, and choose positive odd integers
`L_i=T alpha_i+O(1)` as `T` tends to infinity. Then `L_i/sum_j L_j`
tends to `alpha_i`, so a sufficiently large fixed choice satisfies
`w_i<L_i/(2L)` for every `i`. No rationality of the widths is needed.

Let `rho=min_i L_i/(2Lw_i)>1`. Since `2LH/q -> 1`, eventually
`2LH/q > 1/rho`. Equivalently, for every type,

    w_i/H < L_i/q.

A positive slot with sites `t,...,t+L_i-1` has closed real container

    [(t-1/2)/q, (t+L_i-1/2)/q].

Its midpoint is its integer middle site divided by `q`; this uses
odd `L_i`. Different retained slots have disjoint interiors. The
positive containers lie in `[1/(2q),1/2]`, and their reflected
containers lie in `[1/2,1-1/(2q)]`. Shared endpoints, including
`1/2`, are possible and are not incorrectly declared disjoint.

The desired *closed* intervals have strictly smaller width than their
containers and the same center, so they are contained in the *open*
interiors. A matching never reuses a positive slot, even if its chosen
orientation was negative. Therefore all signed desired intervals are
pairwise disjoint. There is also a gap at zero. Reflection cannot identify
a desired interval with itself, since such an interval would contain
zero or the half-circle point.

Choose any generating vector for each matching edge and divide its
coordinates by `q` to obtain the required torus points. These finitely
many data are fixed before a later polynomial length `N` is chosen.
No divisibility restriction on `N` follows or is used.

Thus the signed-packing conclusion follows from its stated hypotheses
and the exposed edge-coloring input. No false manuscript assertion was
identified in this bounded argument; the rejected joint-independence
shortcut is explicitly not its proof.

## Certification boundary

The general counting theorem is the formal component. The probability,
deletion, external matching application, and real-interval arguments above
are mathematical proofs requiring independent reading; the compiler does
not verify them. `verify.py` replays exact finite model calculations,
the fixture fiber counts, and an explicit strict-interval example, and checks
the official counting certificate's source/fidelity binding. Its finite
calculations are regression evidence, not the proof of the universal
moment or packing statement.

This is a parameter-uniform independent verification with a general
all-positive-integer-moment extension, not a refutation, not a verification
of real ultraflatness, and not a claim of verified-new publication novelty.
Host-invoked independent mathematical review is still required.

The prior ledger contained only the campaign objective, with no established
packing claim. The improvement here is an actual universal counting
formalization and a complete dependent-form moment-to-packing proof; it does
not improve the claimed Littlewood flatness constants.

## Reproduction and recorded results

Run the standalone standard-library replay from any directory:

```bash
python3 families/076/first-pass/packing-audit/verify.py
```

`exact_certificate.json` records nine rational finite-model cases, including
`r>m`, `b<m`, boundary conditioning, unequal odd lengths, and modular-only
relations. The second-moment distinct-chunk fixture has 1344 good ordered
fiber pairs. A separate enumeration of all 48 shift/orientation states of
an entire small model agrees with the fiber-expansion first and second
moments, `1/44` and `1/484`. There is an explicit good third-order tuple
and an analytically evaluated nonvacuous second-moment error bound
`120132/1000003`; that large-field bound is not presented as an enumerated
expectation. The two-edge slot example uses vectors `(1,25)` and `(5,11)`
over `F_101` and checks strict disjointness even though a container and
its reflection share the half-circle endpoint.

The official, fresh compiler invocation was:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify \
  research/packing-audit/formal/Main.lean \
  --statement-fidelity research/packing-audit/formal/statement_fidelity.md \
  --claim C_PACK_COUNT --project-root campaigns/9000076 \
  --timeout 100
```

It returned `exit_code=0`, `proof_holes=[]`, and `audit_exit_code=0`
under Lean 4.31.0. Its immutable claim certificate is
`formal/certificates/C_PACK_COUNT-0dd7e477d502abfe.json`.
The ledger consequently derives `closed_kernel` for the *counting claim
only*. Statement fidelity still requires independent human/Reviewer reading.
The standalone script checks the actual compiler result, archived source,
fidelity document, and attachment to the current claim version; it does not
fabricate a compiler run or recompile unchanged source.

Campaign-local structural validation uses both official commands with the
exact project root above. The public Engineer progress file records their
exit statuses. These checks do not imply that a prose proof, citation
interpretation, or analytic main theorem has been independently reviewed.
The normal Host-invoked Reviewer must read the proof, replay the certificate,
and resolve the explicitly recorded citation-archive/write-scope limitation
before acceptance.
