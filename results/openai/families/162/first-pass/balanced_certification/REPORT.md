# Balanced Ryser theorem: exact verification

The full balanced prime-order theorem passed a pinned Lean 4.34.1
replay of its 668 upstream proof modules and the official proof-hole
audit. A separately authored deterministic construction core passed
Lean 4.31.0. Both compiler answers have exit code zero, no proof holes,
and only `propext`, `Classical.choice`, and `Quot.sound` as transitive
axioms. The integrated result is `exact_certificate.json`.
Independent Reviewer acceptance and publishable significance remain
unsettled; no new combinatorial construction is claimed.

## Statement and scope

The balanced manuscript, `paper.tex`, Theorem `thm:main`, asserts

> There exists an integer q0 such that, for every prime q >= q0, there
> exists a finite intersecting (q+1)-partite (q+1)-uniform hypergraph
> with exactly q+1 vertices in each part, no isolated vertex, and
> covering number q+1.

The threshold is existential and independent of the prime. A cover may
use vertices in different parts. Distinct edges are ordinary vertex sets,
not repeated indexed copies. Nonemptiness is part of "intersecting".

The extension-field manuscript instead asserts: there exists s0 such
that every prime s >= s0 with s = 2 modulo 3 admits n0(s) >= 3, and
every odd integer n >= n0(s) admits an intersecting (s^n+1)-partite,
(s^n+1)-uniform finite hypergraph with covering number s^n+1. It does
not assert balance. Verifying one of these statements does not verify
the other.

## Retrieved mathematical inputs

The staged sources are links into the assigned OpenAI source mirror.
The pinned public source is `openai/math`, revision
`4eaee87548250b2682affda7d05d947c05554bae`.
Its `lean/docs/162.md` states the complete balanced scope, not merely
a finite comparator. `OAI/Combinatorics/BalancedRyser/Model.lean`
defines `PartiteHypergraph r n` as a finite set of functions
`Fin r -> Fin n`, with unrestricted finite vertex covers.
`Results.lean`, lines 402-404, declares
`OAI.Balanced.main_result : OAI.Balanced.MainResult`.
Source-level declaration is not a compiler certificate.

The native source requests Lean 4.34.1 and Mathlib revision
`d13f23b723b8a846827a245b89c10fc7d3f11612`.
The assigned built Mathlib workspace uses Lean 4.31.0. At initial
scope both compiler toolchains were installed, but the staged native
project had no `.lake` build directory. The pinned native library
cache and package archives were subsequently restored inside this
campaign, without downgrading the upstream library.

The balanced stability argument cites Szonyi and Weiner,
*A stability theorem for lines in Galois planes of prime order*,
doi:10.1007/s10623-011-9495-z, Theorem 4, also reproduced as
Heger and Nagy, doi:10.1002/jcd.21527, Result 3.6. This is a
proposition-level external dependency until independently attributed.
The actual reproduction in arXiv:1603.02933v1, Result 3.6, has now
been read and matches the stated hypotheses and constants; see
`stability_excerpt.md` and the downloaded `heger_nagy.html`.
The original DOI's full text has not been used as independently read
evidence. Historical citations in the
introductions are not used as proof assumptions here.

## Load-bearing decomposition

All node identifiers below are recorded in `research/MATH_STATE.json`.
An edge in `research/PROOF_GRAPH.json` is an obligation, not evidence.

| Claim | Source label | Mathematical role |
|---|---|---|
| C_BALANCED | paper: thm:main | Full prime-order balanced conclusion |
| C_BALANCED_DET | construction: prop:deterministic-reduction | Valid compatible four-tuples, occupancy, core-pencil concentration and local obstruction imply the hypergraph conclusion |
| C_BALANCED_CAND | candidates: prop:candidate-graph | Linear candidate pools, bounded degrees/codegrees and constituent occupancy |
| C_BALANCED_MOMENT | candidates: lem:pattern-moments | Uniform conditional pattern counts imply high-moment estimates |
| C_BALANCED_SELECT | selection: sel:selection | Independent transversal with bounded cylinders and line occupancy |
| C_BALANCED_TAIL | selection: sel:tail-cylinder | Local-lemma completion with conditional-cylinder control |
| C_BALANCED_DOM | selection: sel:deletion-domination | Selected three-line deletion law is pointwise exp(O(q))-dominated |
| C_BALANCED_PROFILE | deletion: lem:profile-counting | Forbidden profile classes cost exp(-Omega(q log q)) |
| C_BALANCED_DELETE | deletion: thm:deletion | Robust Poisson, occupancy and almost-cover conclusions under the changed law |
| C_BALANCED_STABLE | deletion: lem:prime-stability | Almost-cover by at most q lines forces a large projective pencil in prime planes |
| C_BALANCED_CORE | deletion: cor:core-pencil | Small covers of the retained core concentrate in a pencil |
| C_BALANCED_LOCAL | local: prop:pencil-local and reuse lemmas | The remaining designated points exceed the pencil's cover budget |
| C_BALANCED_REUSE_HIGH | local: lem:pencil-reuse | Three generator reuses cost O(q^-3) at a fixed point |
| C_BALANCED_REUSE_SMALL | local: lem:pencil-small-reuse | Aligned bad-cover bounds for reuse count zero or one |
| C_BALANCED_REUSE_TWO | local: lem:pencil-two-reuses | The summed additional incidence cost for exactly two reuses |
| C_AFFINE_MOMENT | elementary: lem:affine-second-moment | Exact incidence and variance identities |
| C_DRIFT | elementary: lem:bounded-drift-concentration | Fixed-time concentration with predictable drift |
| C_JUMPS | elementary: lem:independent-trial-jumps | Bounded independent-trial exposures |
| C_EXT_MAIN | extension paper: thm:main | Full odd-extension conclusion, with degree threshold depending on s |
| C_EXT_GADGET | extension construction: lem:gadget | Cubic bijection and weighted line/point obstruction in the small field |
| C_EXT_INC | extension incidence: thm:incidence | Uniform incidence saving when proper subfields have size at most q^(1/3) |
| C_EXT_ADDITIVE | extension incidence: extraction/scalar-covering/approximate-subfield lemmas | Additive-combinatorial input to the incidence saving |
| C_EXT_SUMSET | extension incidence: inc-sumset-estimates | Triangle, covering and multiple-sum inequalities |
| C_EXT_EXTRACTION | extension incidence: inc-simultaneous-extraction | A large subset with simultaneous small difference and quotient sets |
| C_EXT_SCALAR | extension incidence: inc-scalar-coverings | Uniform scalar-expression coverings, with nonzero inversion arguments |
| C_EXT_NO_APPROX | extension incidence: inc-no-approximate-subfield | Exclusion of square-root-scale approximate subfields |
| C_EXT_MARTINGALE | extension linecover: lem:martingale | Bounded-increment, bounded-variance concentration |
| C_EXT_PLACEMENT | extension construction: subfield placement and con-double-directions | Odd-degree subfield bound and direction assignments of multiplicity at most two |
| C_EXT_LINE | extension linecover: lem:linecover | Independent deletions force line occupancy and almost-pencils |
| C_EXT_SELECTION | extension selection: thm:selection | Compatible translates from bounded independent pools |
| C_EXT_DOMCERT | extension selection: sel-domination | Small domination certificate for failure of an independent transversal |
| C_EXT_POOL | extension construction: con-pool-properties | Uniform pool survival, pencil concentration and five-group bound |
| C_EXT_INTERSECT | extension construction: con-intersection/con-label-action | Intersection, edge distinctness and action of each vertex on exceptional positions |
| C_EXT_COVER | extension construction: final cover argument | Infinite/internal/external pencil-center budgets exclude covers of size q |

The balanced assembly requires a positive-probability candidate event,
successful selection, occupancy, core concentration and the local
condition in the *same* experiment. Separate high-probability statements
without their law comparison do not establish the theorem. The
deterministic reduction then uses rho*q > 2*(1+B), with
B = ceil(log q). Its geometry works over prime powers; primality
enters through core-cover stability.

For the extension theorem the cubic map is bijective because
gcd(3,s^n-1)=1 for s = 2 modulo 3 and n odd. The proper-subfield
condition follows because every proper divisor of odd n is at most
n/3. Neither fact supplies the missing probabilistic construction.

## Certification boundary

Native Lean 4.34.1 replay, transitive-axiom inspection, ordinary
hypergraph statement fidelity, and an independently checked Lean
4.31.0 load-bearing core are separate obligations. An exact finite
test or a source scan cannot replace any of them. No manuscript
assertion has been established false, so no refutation judgement is
filed. This route verifies the balanced conclusion; it does not
certify every literal prose step of both manuscripts.
Independent Reviewer confirmation is reserved to the Host.

## Independent deterministic core and adversarial checks

`Main.lean` now has a real Lean 4.31.0 certificate:
`certificates/C_BALANCED_431-78437717eea1ad53.json`, exit code zero,
with no proof holes. The printed transitive axioms of the load-bearing
declarations are exactly `propext`, `Classical.choice`, and `Quot.sound`.
The separate `statement_fidelity.md` names the finite occupancy-forcing,
parallel-pencil, all affine-center budget cases, and partition/hypergraph
cover-equivalence theorems. They apply to arbitrary finite set systems;
they do not assume that the asymptotic geometric data exist.

The exact finite audit checks the affine incidence identities on every
point subset at orders 2 and 3, and on 63, 115 and 267 specified sets
at prime orders 5, 7 and 11. The tuple audit examines all four-generator
cycles in one specified constituent configuration at each of orders
5, 7 and 11: respectively 18, 100 and 328 aligned tuples, with 12
valid tuples at each order. Every crossing pair of the opposite-pair
partition has the required shared merged block. These are bounded
orientation tests, not existence proofs for the full compatible
configuration.

The inspected Jacobian contract is
`hypergraph.independence_number.compute`. One five-second,
ten-solver-call operation on the order-two affine-plane baseline
returned `EXACT`, independence number four, adapter exit code zero.
An independent exhaustive replay of all 64 vertex subsets gives
covering number two. The preserved request and typed reply record
Jacobian 0.14.0 and protocol 2025-11-25. This known baseline is not
a Ryser counterexample or a publishable result on its own.

The first native replay restored the exact pinned Mathlib cache but
failed because the cache bootstrap's partial Batteries namespace
shadowed the complete package. Bootstrap and theorem object search
paths were separated; the corrected durable replay completed all 668
source-bound modules with exit code zero. The initial official native
wrapper also exposed fixed-basename staging and an ambient compiler
search-path mismatch. The core source and fidelity were restored
byte-for-byte from their archived successful certificate, and native
staging was isolated in `native/evidence/` with the native compiler
first on PATH. Fresh official runs then certified both sources. These
were harness failures, not mathematical refutations; no failed run is
used as supporting evidence.

## Full theorem certificate and mathematical improvement

The strongest prior evidence was a public source declaration of
`OAI.Balanced.main_result`. The new evidence is an actual source-bound
native proof replay, a successful official compiler/proof-hole audit,
and an independently authored Lean 4.31.0 finite-set-system core.
This improves source-level trust to kernel-checked verification of
the entire quantified balanced conclusion, not just another finite
test or a proof of an ordinary-hypergraph encoding.

The native certificate is
`native/evidence/certificates/C_BALANCED_NATIVE-7b67cd817e773c32.json`.
It compiles the explicit statement in `NativeMain.lean`; its staged
source and fidelity must agree byte-for-byte with their originals.
The compiler's printed definitions confirm unrestricted mixed-part
covers, nonempty intersecting edge sets, every declared vertex
nonisolated, and both attainment and the universal lower bound for
cover number. `native_statement_fidelity.md` gives the graph-of-a-
function translation to ordinary finite set-hypergraphs. Thus the
result gives exactly q+1 vertices in each of q+1 disjoint parts and
q+1 vertices per edge. Nonempty pairwise intersection also gives
matching number one, so covering number q+1 violates the Ryser
bound q. This is an existence-theorem verification, not an enumerated
finite witness or an explicit prime threshold.

Mathlib's pinned cache and its manifest-pinned packages are trusted
library-build inputs. They were not independently rebuilt. The
entire upstream balanced proof closure was compiled locally.
The Lean 4.31.0 source proves only the stated deterministic core,
not the asymptotic construction or the extension-field theorem.
The paper-based decomposition remains recorded separately; the
direct native certification route does not pretend that all its
literal intermediate assertions have received independent prose review.

## Rerun and independent review

From the campaign root:

```bash
python3 research/balanced_certification/verify.py
python3 research/balanced_certification/verify.py --replay-lean
```

The first command checks the current source/fidelity/claim/certificate
bindings and reruns the exact finite audits. The second additionally
runs both real entrypoint compilers and official proof-hole audits.
It does not rebuild all imported upstream modules.

For an independent rebuild of the entire pinned upstream closure,
run `research/balanced_certification/native_replay.py --rebuild` with
the explicit Argus interpreter through the host's durable direct
runner, then rerun the second command above. The initial complete
replay took about 1,212 seconds on its assigned four CPUs. The driver
now uses the included campaign-local pinned sources, not an external
source mirror; standard-library caches remain trusted inputs.

The Host-invoked Reviewer must check the two statement-fidelity
documents, replay the certificate, independently attribute the saved
Heger--Nagy Result 3.6 excerpt, and judge novelty/significance.
Engineer opinions are not independent acceptance. The campaign-local
ledger and proof-graph checks both passed at
`campaigns/9000162`
with exit code zero. The graph has 38 nodes and reserves all
Reviewer-confirmation flags for the independent review.
Citation status still returns exit code one solely for the
inconclusive `C_BALANCED_STABLE / A_HN2016` attribution. The saved
source and excerpt are ready for that independent reading. This
paper-route literature assumption is not an additional axiom of
the closed native kernel proof.
