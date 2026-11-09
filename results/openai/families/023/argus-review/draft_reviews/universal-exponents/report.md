# Universal exponent obstruction: assessment

## Disposition and exact scope

**Supported as an abstract theorem, with fresh kernel evidence.** The source
proves that the two explicitly specified systems of necessary real inequalities
are inconsistent. It does not prove that arithmetic character sums satisfy
those inequalities. That separate assertion is assessed in
`../analytic-dual/report.md`. Native independent Reviewer acceptance is pending.

The attributed draft is Argus's `research/exceptional_moments/report.md`,
Theorem 1 and Sections 5-6, in the old workspace
`campaigns/9000023`.
Its formal source is `Main.lean` in that directory. The verbatim current-project
copy is `../Main.lean`; its statement reading is `../statement_fidelity.md`.
The original mathematical claim is `C_EXPONENTS`, versions 1-3.
This assessment neither establishes novelty nor adopts the inherited
`new_theorem` label.

Let `I` be an arbitrary finite index type. Let `a_i,v_i,r` be real numbers,
`a_i >= 0`, and `sum a_i = 1`. There is no positive lower bound on nonzero
lengths, no bound on `|I|`, and no positivity assumption on `v_i`.
For `k in N^I`, set `A(k)=sum k_i a_i`, `V(k)=sum k_i v_i`,
and `V=sum v_i`. The first endpoint does not need `v_i <= a_i`;
the second explicitly assumes it. The statement includes zero lengths.
An empty index type cannot satisfy the length-sum hypothesis.

Define

```
E1(a) = 2-a + max(1, 87/50-a, (2/3)*(1+87/50-a))
E2(a) = 4/3 + 37/50 + 2*(1-a)
G(z,r) = max(z-r, (z+max(1,2-2*z/3)-r)/2).
```

The universal first-endpoint theorem assumes:

1. `7/3 - 2*V <= r`.
2. For every `k in N^I` with `1/2 <= A(k) <= 2`,
   `r + 2*V(k) <= 2/3 + (5/3)*A(k)`.
3. For every `i` and natural `k` with `7/5 <= k*a_i <= 19/10`,
   `2*k*v_i - k*a_i <= G(k*a_i,r)`.
4. For every `i` with `a_i=1`, `7/3 <= E1(a_i)`.

Its conclusion is `False`. The last hypothesis is the implication that an
unsaved contribution would obey the full-factor upper estimate. It is not a
formal proof of that estimate's analytic applicability.

The universal second-endpoint theorem assumes:

1. `v_i <= a_i` for every `i`, and `7/3 - 2*V <= r`.
2. `r <= 2/3` and `r+4*V <= 4`.
3. For each `i` with `a_i>0`,
   `r+2*(V+v_i) <= (1+a_i)+max(4/3,1+a_i)`.
4. For every `i` with `a_i=1`, `7/3 <= E2(a_i)`.

Its conclusion is also `False`. These universal multiplicity hypotheses are
genuine hypotheses, not a finite numerical sample, and not assertions that
every abstract vector is arithmetically realizable.

## Decisive argument

First exclude `a_i=1`: nonnegativity and the length sum give `a_i<=1`,
whereas the corresponding full-factor assumption contradicts the proved
numerical bounds
`E1(1)=54/25<7/3` and `E2(1)=311/150<7/3`.
Thus every length is strictly below one.

At the first endpoint put `d_i=v_i-5*a_i/6`, `D=sum d_i`.
The lower bound becomes `r>=2/3-2*D`, and the copied-product inequalities
become `r<=2/3-2*sum k_i d_i` whenever `A(k)` is in `[1/2,2]`.
Use the all-ones vector with one coordinate raised to two. Its length
is `1+a_i` in `[1,2)`. Comparison with the lower bound forces `d_i<=0`.
For `a_i<=1/2`, omit that coordinate instead. Its length is `1-a_i`
in `[1/2,1]`, forcing `d_i>=0`. Hence every short defect, including
every zero-length defect, vanishes.

There is a positive short length: if one length exceeds `1/2`, its
positive complementary total, since it is less than one, contains a positive
length at most `1/2`; otherwise any positive length is short.
The ceiling construction in the interval unit supplies a natural multiple
of this short length in `[7/5,19/10)`. Its defect is zero, so the copied-product
inequality gives `r<=2/3`. Together with `D<=0` and the lower bound this gives
`D=0`, `r=2/3`, and then `d_i=0` for every `i`.

For the same copied factor write `z=k*a_i`. Its Gram hypothesis is now
`2*z/3 <= G(z,2/3)`. The interval theorem gives the opposing bound
`G(z,2/3) <= 2*z/3-1/30`. This is a strict contradiction.
No lower bound on the positive length or on the value exponents was used.

At the second endpoint the three scalar inequalities force exactly
`r=2/3`, `V=5/6`. For example, averaging the unsaved inequality with
the cardinality bound gives `V>=5/6`, and averaging it with the fourth-moment
bound gives `V<=5/6`; twice the unsaved inequality plus the fourth-moment
bound gives `r>=2/3`. The four nonnegative linear-combination certificates
in the exact checker verify these implications.

There is an `i` with `a_i>0` and `v_i>=5*a_i/6`. Otherwise every positive
length has strictly negative defect, every zero length has nonpositive defect
by `v_i<=a_i`, and their total cannot be zero. Repeating this factor gives
`z=1+a_i in (1,2)` and

```
r <= max(4/3,z)-2*z/3 < 2/3.
```

For `z<=4/3` the gap is `2*(z-1)/3`; for `z>=4/3` it is `(2-z)/3`.
Both are strictly positive. This contradicts the forced `r=2/3`.
The zero-length boundary is why the trivial value hypothesis matters in
this second argument.

## Statement fidelity, separately from compilation

The declarations `first_endpoint_universal` and `second_endpoint_universal`
have precisely the hypotheses above, with `weight` implementing arbitrary
natural multiplicities. `extremal_forcing` derives, rather than assumes,
all zero defects and `r=2/3`. `positive_short` retains zero entries and
requires all entries below one. `exists_high_value` uses the second endpoint's
trivial value bounds. The endpoint wrappers remove the strict-length
restriction using the conditional full-factor hypotheses, rather than silently
discarding the length-one face.

The fidelity document correctly distinguishes the numerical definitions
`firstFullUpper`, `secondFullUpper` from functional equations or sieve
estimates. Its interval optimality reading is scoped to the encoded affine
constraints; see the interval report for the width restriction. There is no
theorem in the source about primes, Eisenstein ideals, Poisson summation,
uniform asymptotic constants, or the complete first moment.

This is an engineer's mathematical reading of the statement, not an
independently accepted fidelity verdict. The kernel checks the encoded
implications. The native Reviewer must still decide whether those implications
are the right targets and whether the prose establishes their analytic premises.

## Versions, dependencies and fresh replay

The natural-language claim is unchanged across the three old ledger versions.

| Version/evidence | Actual mathematical disposition |
|---|---|
| `C_EXPONENTS` v1 | Natural statement only; no formal source attached. |
| v2; certificate `C_EXPONENTS-748bc2a3131a61a6.json`; `lean_verify_01.json` | Archived source fails compilation. `simpa` does not use `a_i=0`, and real-valued definitions lack `noncomputable`. This run is inconclusive, not a refutation. |
| v3; certificate `C_EXPONENTS-eeb17a8f1420a929.json`; `lean_verify_02.json`; `lean_check.json` | Replaces that simplification by `simpa [hz]` and marks the two real definitions `noncomputable`. Statements are unchanged. The successful archived source and fidelity text equal the current old files. |

`compile.log` is another presentation of the successful compile/audit;
the submission handle and environment probe are provenance, not additional
proofs. The arithmetic-only receipt explicitly does not certify the universal
theorem. The historical full checker does, but only within this abstract scope.
The aggregate validation log contains no claim identifiers outside the
21 identifiers mapped by the family index.

Fresh replay used:

```
$WORKSPACE/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/draft_reviews/Main.lean \
  --statement-fidelity research/draft_reviews/statement_fidelity.md \
  --artifact-dir research/draft_reviews --claim C_EXPONENTS \
  --project-root campaigns/9200023 \
  --timeout 110
```

The actual result is `success`, compiler exit `0`, axiom-audit exit `0`,
and `proof_holes=[]`, in 22090 ms. Lean is **4.31.0**, commit
`68218e876d2a38b1985b8590fff244a83c321783`; Lake is
`5.0.0-src+68218e8`; elan is `4.2.3`.
The selected prebuilt workspace is
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
No new Lake project, dependency installation or alternative Mathlib revision
was introduced; the library checkout itself was not separately Git-audited.
The printed axiom reports for the two universal theorems and `uniform_gram_gap`
contain only `propext`, `Classical.choice`, and `Quot.sound`.

The fresh result and immutable source/fidelity archive are
`../universal-exponents-lean-verification.json` and
`../certificates/C_EXPONENTS-17c57f67c7fcda79.json`.
The verifier, formal source and fidelity document were copied byte-for-byte;
neither formal input was edited during or after the compile.
The default unmodified `../verify.py` subsequently exited `0`, checking
the fresh record, both source bindings and the active claim's archived evidence.
Its result is `../verification_result.json`.

The interval argument is a mathematical dependency; its sharpness is not
needed for every version of the contradiction, but the interval coverage and
strict gap are used here. The abstract theorem has no unproved external
analytic assumptions in its formal statement beyond its explicit inequality
premises and the ordinary Lean/Mathlib foundation. The analytic origin of
`hfull`, `hcubic`, `hgram`, `hfourth` and `hrepeat` remains outside the kernel.

**Remaining boundary:** no mathematical defect was found in the encoded
abstract proof. Independent fidelity/analytic review and the family workflow
gates remain outstanding; compilation is not acceptance of `prop:dual`.
