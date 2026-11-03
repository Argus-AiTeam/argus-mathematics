# Exploratory negative report: complete D81 \(h=21,\ j=0\to1\) exhaustion

## Relation to the original objective

The campaign objective in `OBJECTIVE.md` is to exhibit an explicit admissible
basis in a totally real cubic field whose standard Jacobi--Perron digit
sequence has an exact, rerunnable obstruction to eventual periodicity.

The result certified here is different in kind: it is a complete finite exact
classification of one fixed D81 quotient domain. It proves that the complete
\(h=21,\ j=0\to1\) source domain contains no target equality and therefore no
successor. It does **not** provide an admissible non-eventually-periodic basis,
an infinite-behavior certificate, or a height-uniform obstruction.

Accordingly, this is a reproducible negative result for a fully specified
exploratory domain, not a Jacobi--Perron counterexample and not a proof of
universal nonexistence.

## Exact fixed-domain result

The unimodular anchor-affine parameterization covers every lattice point in
the exact first-column polygon, every primitive first column, both determinant
orientations, and every completion in its derived shear interval. The
enumeration has no arbitrary coordinate, shear, word-length, or numerical
precision cutoff.

| Exact cell or outcome | Count |
|---|---:|
| Lattice points in the first-column polygon, including the origin | 47,617,404 |
| Primitive first columns | 28,947,904 |
| Derived shears across both orientations | 40,130,215 |
| Rejected by the named source gates | 22,933,968 |
| \(\quad t>\rho\) | 15,756,640 |
| \(\quad |\alpha|+|\beta|+|\gamma|>2F_1\) | 7,177,328 |
| \(\quad \rho>F_0\) | 0 |
| \(\quad \rho+s+t<F_0+1\) | 0 |
| Pass every source gate | 17,196,247 |
| Strictly cross the target | 17,196,247 |
| Exact target equalities | 0 |
| Unresolved orbit records or branches | 0 |
| Formed \(W\) states / equality-peeling branches | 0 |
| \(j=1\) successors | 0 |

The partition is exact:
\[
22{,}933{,}968+17{,}196{,}247=40{,}130{,}215.
\]
Every full-gate source crosses strictly at a step from 13 through 64, below
the theorem-derived 195-step bound. Because target equality is tested before
strict crossing, no equality case is hidden by the crossing classification.
With zero target equalities, no \(W\) state is formed and no successor exists
in this fixed domain.

Completeness of the finite domain follows from the exact anchor polygon and
the unique Bezout-shear completion formula. Independently of the streamed
enumeration, signed Euclidean floor sums reproduce all 47,617,404 lattice
points, and finite Möbius inversion reproduces all 28,947,904 primitive
columns. The inversion is complete because the scaled polygon at \(d=5387\)
contains only the origin. The Python transition kernel and C++ classifier
also agree on every one of the 9,056 derived shears in the complete \(u=0\)
slice, including gates, outcomes, crossing steps, and carry extrema.

The independent Reviewer subsequently reproduced the three aggregate domain
counts with a separate integer enumerator, compiled the classifier afresh and
matched the Python kernel on six new slices totaling 189,560 shears, checked
the canonical mixed-sign carry witness, and replayed thirteen distributed
boundary rows. That review supported the complete fixed
\(h=21,\ j=0\to1\) classification while explicitly declining to infer an
all-\(h\) theorem or a counterexample.

## Decisive evidence and deterministic verifiers

| Artifact | Role |
|---|---|
| `research/routes/d81-cancellation-strip-transition-kernel/DERIVATION.md` | Exact parameterization, completeness argument, gate partition, target-first transition argument, and canonical rerun commands |
| `research/routes/d81-cancellation-strip-transition-kernel/classify_affine_fibers.cpp` | Assertion-enabled exact enumerator and classifier for the complete anchor-affine domain |
| `research/routes/d81-cancellation-strip-transition-kernel/h21-affine-fiber-classification.json` | Full-run aggregate certificate for all 40,130,215 derived shears |
| `research/routes/d81-cancellation-strip-transition-kernel/verify_affine_classifier.py` | Independent floor-sum and Möbius counts, source/receipt checks, and complete \(u=0\) cross-implementation replay |
| `research/routes/d81-cancellation-strip-transition-kernel/affine-classifier-crosscheck.json` | Typed output of the independent aggregate and slice cross-check |
| `research/routes/d81-cancellation-strip-transition-kernel/verify_transition_kernel.py` | Exact Python state/basis, source-gate, target-first orbit, boundary, and integrated-certificate verifier |
| `research/routes/d81-cancellation-strip-transition-kernel/transition-kernel.json` | Integrated transition-kernel certificate embedding the full affine classification and cross-check |
| `research/routes/d81-cancellation-strip-transition-kernel/h21-affine-fiber.receipt.json` | Successful durable full-classification execution receipt |
| `research/routes/d81-cancellation-strip-transition-kernel/integrated-certificate.receipt.json` | Successful durable integrated-verifier execution receipt |
| `roles/reviewer/progress.json` | Existing independent bounded-mission verdict and its independently reproduced counts and samples |
| `research/MATH_STATE.json` and `research/PROOF_GRAPH.json` | Claim ledger and proof frontier preserving the open campaign and all-height propositions |

The retained Jacobian files in the route directory are not part of this
result's mathematical support. The typed `lattice.dual.compute` output failed
its integral row-pairing postcondition and was explicitly rejected by the
verifier rather than used as evidence.

## Deterministic rerun

Run from the campaign root:

```bash
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  research/routes/d81-cancellation-strip-transition-kernel/\
classify_affine_fibers.cpp \
  -o research/routes/d81-cancellation-strip-transition-kernel/\
classify_affine_fibers

research/routes/d81-cancellation-strip-transition-kernel/\
classify_affine_fibers --h 21 \
  > research/routes/d81-cancellation-strip-transition-kernel/\
h21-affine-fiber-classification.json

/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/d81-cancellation-strip-transition-kernel/\
verify_affine_classifier.py \
  --output research/routes/d81-cancellation-strip-transition-kernel/\
affine-classifier-crosscheck.json

/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/d81-cancellation-strip-transition-kernel/\
verify_transition_kernel.py \
  --output research/routes/d81-cancellation-strip-transition-kernel/\
transition-kernel.json
```

The full classifier is the existing exact reconstruction command; it was not
rerun for this report-only mission. This report reuses the already completed
and independently reviewed certificates without changing their claims or
counts.

## Scope boundary and open claims

The following conclusions remain open:

- `C_COUNTEREXAMPLE`: no admissible totally real cubic basis with a certified
  non-eventually-periodic Jacobi--Perron expansion was found.
- `C_INFINITE_OBSTRUCTION`: no exact infinite nonperiodicity certificate was
  proved for a campaign witness.
- `C_D81_LEVEL_DEPENDENT_NON_SMITH_EMPTY`: no argument lifts the fixed
  \(h=21\) exclusion uniformly to every \(h\ge4\).

In particular, the zero-successor result cannot be broadened beyond
\(h=21,\ j=0\to1\), cannot be read as an all-height D81 obstruction, and
cannot establish either side of the original universal periodicity problem.
No Jacobi--Perron counterexample or all-\(h\) obstruction was proved.

## Project-level independent certification

After the independent bounded-result review, a separate independent
project-level Reviewer verdict was recorded on 2026-09-04. It explicitly
certified:

1. statement fidelity to the original counterexample objective;
2. correctness of the fixed-domain exhaustion argument;
3. reproducibility from the listed artifacts and commands;
4. honesty of the fixed-\(h\), fixed-level scope; and
5. satisfaction of the exploratory research target despite the original
   counterexample and all-height propositions remaining open.

That certification applies only to this exploratory negative report and the
complete \(h=21,\ j=0\to1\) domain it describes. It neither supplies a
Jacobi--Perron counterexample nor broadens the result to all heights. This
synchronized final report changes no mathematical claim, count, or scope from
the independently reviewed version.
