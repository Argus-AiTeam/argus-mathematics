# Normalized rational rank-sandwich implication

**Assessment: supported in its stated rational algebraic scope.** This is an
implication for all admissible rational inputs, not an enumeration of ratios,
a geometric realization theorem, or the sixfold classification.

Throughout this report, `old/` means
`campaigns/9000067/`.
The source is the September 25, 2026 manuscript at revision
`4eaee87548250b2682affda7d05d947c05554bae`, Sections 4--5
(`eq:matrix-rows-a` through `eq:matrix-rows-f`, `eq:normalized-products`,
`lem:finite-ratio`). The old Argus report reconstructs this assertion; its
numerical conclusion, abstract rank-sandwich strategy, and convenient rational
witnesses are not new results attributable to this review.

## Exact statement and inputs

Use the ordered weight-nine monomials in
`Q[h,x2,x3,x4,x5,x6,ell,r,s,t]`, of weights
`(1,2,3,4,5,6,1,1,2,3)`, and all six row groups specified in Section 4.
They define `A`, of size `1785 x 581`. Let `K` span `ker_Q A`, and let
`P`, of size `129 x 65`, select the rows prescribed by `C1`; repetitions
in a selection are legitimate. Let the rows of `N` span `ker(P^T)`.

For **every** `xi in Q^11`, `eta in Q^18` with
`xi_0=eta_0=1` and `N(xi_i eta_j)_(i,j in C1)=0`,

```
32 - 20 eta_1 + 3 eta_1^2 = 0.
```

Equivalently, a vector in `ker A` whose selected entries equal
`a xi_i eta_j`, for a common nonzero rational `a`, has this consequence.
The common nonzero scalar can be divided out. Normalization is essential:
the old `NORMALIZATION_BOUNDARY` example `xi=0`,
`eta=(1,0,...,0)` satisfies the unnormalized equations but gives 32,
not zero. This defeats an improperly strengthened Argus assertion, not
the normalized manuscript lemma.

## Decisive argument

`old/research/pseudoindex-five-audit/verify.py`, especially
`build_constraints` and `verify_rank_certificate`, was inspected rather
than treating its final `status` as a proof.

1. The checker reconstructs the characteristic polynomials from three
   independent roots using exact symmetric-polynomial substitution. Todd
   coefficients are checked against the defining exponential series, including
   signs and factorials. It reconstructs the seven stored row labels (the last
   two labels together constitute the sixth, GRR, group), monomial order, `C1`
   and selection. There are 581 columns and 129 selected coordinates.
2. It verifies `AK=0` and `NP=0` **over Q**. Reduced denominators are
   units modulo 10007. Modular ranks `(A,K,P,N)=(516,65,60,69)` are
   lower bounds on rational ranks, not upper bounds. As `581-516=65`,
   `K` is a full rational kernel basis. Since `im P` lies in `ker N`
   and `129-69=60`, `im_Q P=ker_Q N`, both of dimension 60.
3. Cubic coordinates are `(i,sort(j,a,b))`, with `j,a,b in J`.
   The rational double-slice matrix `H3` has `69*120=8280` rows and
   6820 columns. The finite-field computation successively glues full
   slice kernels. Appending a fixed multiset index is injective; the
   compatibility kernel parametrizes exactly the old/new overlap, and
   the parametrization remains injective because its restrictions to
   both pieces are injective. Thus it computes the **whole** kernel,
   not a set of sampled solutions. Dimensions are 60, 163 and 6.
   All 120 final double slices are checked. Consequently
   `rank_Q H3 >= 6814` and `dim_Q ker H3 <= 6`.
4. Three product columns and three sparse columns are checked by exact
   rational substitution in every double slice. Their specified six-row
   minor is `-16/5`, so they are independent and form a full rational
   basis. The checker evaluates
   `Phi=32 v_(0,000)-20 v_(0,001)+3 v_(0,011)` on that basis and
   obtains zero on each column.
5. From `N(xi_i eta_j)=0`, multiplication by every `eta_a eta_b`
   gives an admissible cubic vector. On it
   `Phi=xi_0 eta_0(32 eta_0^2-20 eta_0 eta_1+3 eta_1^2)`.
   Normalization proves the lemma. For the geometric application,
   `eta_1=S/D` and the nonzero scalar is `D int_X h_X^6`.
   Multiplication by `D^2` gives `3S^2-20SD+32D^2=0`.

The prime check tests divisors through 100, sufficient for 10007.
The signed-integer matrix products have inner dimension at most 6820;
`6820*(10007-1)^2=682818645520 < 2^63-1`. Entries are reduced before
products; elimination products have smaller bounds. No floating rank,
tolerance, lifting of an arbitrary modular basis, or assumption that
the six witnesses come from varieties is needed.

This supports `C67_RATIONAL_KERNELS`, `C67_CUBIC_UPPER`,
`C67_CUBIC_BASIS`, and `C67_FINITE`, each version 1.
`C67_CORE_AUDIT` and `C67_INDEPENDENT_REVIEW` are aggregate/provenance
claims, not additional mathematical results.

## Replayed and reused evidence

`replay.json` records actual commands, exit codes, stdout, stderr, elapsed
times and toolchain. The unmodified old verifier passed in 9.595 seconds;
both existing adversarial checker tests passed (5.495 seconds for their
process). Assertions were enabled. The tests reject a corrupted annihilator
at exact `NP=0`, and reject execution with assertions disabled. They do
not constitute a general software-correctness proof.

The existing replay interpreter was
`$WORKSPACE/argus-live-update/.venv/bin/python`,
Python 3.13.5, SymPy 1.14.0, NumPy 2.5.2, matching the old verifier's
requirements. `PYTHONOPTIMIZE` was removed and bytecode writes disabled.
The mandated legacy Argus interpreter lacks SymPy; it was used for the
ledger, not misreported as the verifier environment. Nothing was installed
or changed in either shared environment. FLINT is not a verifier dependency.

The new bounded Jacobian replay followed discovery and inspection of
`polynomial.ideal.normal_form.compute`. Dedicated `jacobian_payload.json`
and `jacobian_output.json` retain the exact request and complete typed
answer. Server 0.14.0, protocol `2025-11-25`, adapter exit 0, no timeout,
`outcome=COMPUTED`, `in_ideal=true`, empty remainder, `detail=null`.
This verifies **only** the fourth Newton power-sum identity
`z1^4+z2^4+z3^4 = r^4-4r^2s+2s^2+4rt`, modulo
`r=z1+z2+z3`, `s=z1z2+z1z3+z2z3`, `t=z1z2z3`
(`NEWTON4_ADAPTER`). It does not
establish the quadratic or any geometry. The adapter was invoked through
the exact live-update interpreter, never imported into the Argus environment.

`input_identity.json` records that the preservation manifest covers only
11 of the 43 inventory artifacts, all matching. All 11 staged TeX files
match the manuscript-reference manifest. The other 32 artifacts are
inventory-listed, inspected read-only evidence, not digest-certified
snapshot copies. The fresh full certificate replay avoids relying only
on the unmanifested historical replay output.

`FORMULA_SOURCE_IDENTITY` is supported by the old
`compare_source.py`/`source_comparison.json`: exact coefficient agreement
for all 1785 rows, 581 monomials, selected coordinates and the stated
polynomial ranges. This is historical comparison evidence, not a fresh
claim that every supplied software file is unchanged or that the supplied
full verifier was independently executed. The current proof reconstructs
its input without importing that implementation; the fixed TeX
definitions were also inspected. `derive.py`, `linear_data.json`, and
`rank_certificate.py` are derivation data/packaging, not extra proofs.

## Scope and historical review

The later `reviewer-replay.json` and the old ledger's independent
judgements support the bounded numerical audit. The old report's
"pending" sentence and the verifier's hard-coded `independent_review:
pending` describe the earlier packaging/software output; they do not
erase that later review. Conversely, the later review does not certify
the full classification, canonical citation closure, Lean compilation,
publication novelty, or this campaign's complete coverage. Old graph
nodes remaining open are preserved documentary statuses, not a
refutation of the proof.

No algebraic gap was found within the stated rational theorem.
Its use for actual varieties has the separate obligations assessed in
`geometric-bridges`; recognizing a Grassmannian has further obligations
in `classification-and-recognition`. This review improves coverage and
scope reconciliation over the strongest old result, not its mathematical
bound or conclusion.
