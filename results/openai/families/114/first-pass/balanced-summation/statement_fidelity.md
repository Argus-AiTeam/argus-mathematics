# Statement fidelity: balanced summation

## Claim and source

This document describes claim `C_BALANCED` and the declarations in `Main.lean`,
all in namespace `BalancedSummation`. The target is Lemma
`lem:balanced-summation` and Definition `def:integer-signatures` in the staged
October 5, 2026 integer-polymatroid manuscript's `build/sections/signatures.tex`.
It does not describe, or certify, the manuscript's FPRAS.

The final universal declarations are `balanced_pairs_removal_spectral` and
`balanced_pairs_addition_spectral`. The coordinate-fixing declarations are
`fixing_positive`, `fixing_supported`, `fixing_removal_spectral`, and
`fixing_addition_spectral`.

## Objects and all quantifiers

`I` is any finite index type, including the empty type. A profile is a function
`I -> Int`. The capacity function `m : I -> Nat` is arbitrary and can have zero
entries. `r : Int` is arbitrary; no nonemptiness or admissible-total hypothesis
is silently imposed.

`Ms : List Nat` is any finite list with the sole condition
`forall M in Ms, 1 <= M`. There is no upper bound on the number of pairs or
their capacities. In particular capacities one and two are included.
`PairIndex I Ms` recursively adjoins two distinct coordinates per list entry,
using a disjoint sum with `Bool`. `pairCaps m Ms` assigns the associated
capacity `M` to both coordinates. This is the original situation of disjoint
equal-capacity pairs in canonical coordinates: any named finite paired box can
be presented in this way by relabeling coordinates. Neither the order of
labels nor factorization of the weight is a hypothesis.

The input `F` is an arbitrary function on **all integer profiles** of that
index type with values in `Real`. Its two hypotheses are:

* `Positive F (pairCaps m Ms) r`: for every box-valid profile of total exactly
  `r`, `F` is strictly positive.
* `Supported F (pairCaps m Ms) r`: for every profile outside that box slice,
  `F` is zero.

Together these say exactly "strictly positive on the entire slice, extended
by zero", as in the source. They impose no rank, laminar, separable,
Lorentzian-polynomial, or stronger-signature condition.

## The signature is the spectral signature, not a surrogate assumption

`remove z i` subtracts one from coordinate `i`, even when that produces an
invalid profile. `addUnit z i` adds one. Accordingly `test F z` and
`additionTest F z` are the bilinear forms of the real symmetric matrices
`F(z-e_i-e_j)` and `F(z+e_i+e_j)`. Diagonal entries make two changes in the
same coordinate. `Supported` forces all invalid entries to be zero.

`SpectralRemovalSignature` quantifies over **every box-valid display** of
total `r+2`. For its symmetric matrix, it states that any two indices of
strictly positive eigenvalues are equal. `SpectralAdditionSignature` uses
every box-valid display of total `r-2`. Mathlib's
`Matrix.IsHermitian.eigenvalues` indexes a complete orthonormal eigenbasis,
so repeated eigenvalues are counted with their multiplicities. These
predicates therefore mean at most one positive eigenvalue, including null
matrices, singular matrices, zero coordinate axes, and vacuous display sets.

The working predicate `Signature B` says that whenever `B(u,u)>0`,
`B(v,u)=0` implies `B(v,v)<=0`. It is **not** an additional input assumption.
`signature_iff_eigenvalues` proves its equivalence to the spectral condition
for every finite real symmetric matrix. The proof uses Mathlib's proved
orthonormal eigenbasis, computes the congruence to its diagonal eigenvalue
matrix, and proves `diagonal_signature`. The specialized equivalences are
`removal_signature_spectral_iff` and `addition_signature_spectral_iff`.
Thus both directions of the spectral translation are inside the compiler
boundary.

## Operation and conclusion

`balanced` is the unweighted sum over every integer `k=0,...,M` of the
profile `(z,k,M-k)`. `sumPairs` iterates this sum over all entries of `Ms`.
It is the nested finite sum written in the manuscript, not a partial,
truncated, normalized, binomially weighted, or sampled version of it.

`balanced_pairs_removal_spectral` proves that this output is positive on the
entire old box slice of total `r - Ms.sum`, zero outside that slice, and
satisfies `SpectralRemovalSignature` at that total, provided the input has
the removal signature. `balanced_pairs_addition_spectral` makes the
corresponding assertion from the input addition signature. Neither theorem
requires the input to have both signatures.

`one_pair_removal` instantiates the block-chain theorem using the actual
weight. `pairTest_chain` and `balanced_test` prove that these are precisely
the original input tests and the output test. Full-slice positivity supplies
each interior `u_k>0`; it is not assumed separately. `chain_closure`
constructs the cumulative coefficients for an arbitrary capacity and proves
nonpositivity on the common hyperplane, not just the telescoping identity.
`local_energy` handles the case of two null paired axes with positive mutual
entry, including the `M=2` middle test. `capacity_one_closure` uses the
proved `null_axis` theorem, and `one_pair_removal` proves from full-slice
positivity that a zero common column forces the old blocks to vanish.
The boundary cases do not require a hidden nonzero column.

`reflectProfile`, `signature_reflection`, and `balanced_reflection` prove
the addition result by actual box reflection and the finite reindexing
`k -> M-k`. The input and output totals are both reflected explicitly.

For fixing, `J` is any other finite coordinate type, `n : J -> Nat` its
capacities, and `w : J -> Int` any box-valid fixed profile.
`fixing_positive` and `fixing_supported` put the restricted weight on total
`r - sum_j w_j`. The two spectral fixing theorems preserve the corresponding
signature. The fixed-test identities are proved by zero-extending the old
test vectors into the fixed coordinate directions.

## Trust and limits

The source contains no admitted proofs or custom axioms. Its final commands
print the axioms of the four principal spectral declarations for inspection.
The expected foundational axioms are Lean's `propext`, `Classical.choice`,
and `Quot.sound`. Real arithmetic, finite sums, bilinear algebra, and the
spectral theorem are checked through Lean 4.31.0 and the installed Mathlib.

The Python/SymPy identity and rational finite experiments are supplementary;
they do not establish the universal theorem. Jacobian's retained inertia
response certifies only one explicit capacity-two test. This document and
the source still need independent human/Reviewer statement-fidelity review.
No new mathematical theorem, priority claim, complete manuscript audit, or
FPRAS correctness claim follows merely from the compiler verdict.
