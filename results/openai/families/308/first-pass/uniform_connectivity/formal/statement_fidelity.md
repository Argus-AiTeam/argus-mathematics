# Statement fidelity: signed occupied-slot splitting

## Exact scope and quantifiers

Claim: `C_UC_SPLIT_FORMAL`, context `CTX_UC_308`.
Source: `research/uniform_connectivity/formal/Main.lean`.
All declarations listed below are in namespace `UniformConnectivity`.

The source proves a universal **finite-support free-alphabet coefficient
theorem**, not a theorem about group cohomology or spectra. For every type
`A`, every type `R` with `[CommRing R]`, every function
`parity : A → Bool`, and every natural number `n` (including zero), it
constructs the linear equivalence

```text
tensorDirectSumEquiv parity n :
  TensorInvariants parity n ≃ₗ[R]
    DirectSum (Fin (n+1)) (fun r => PureInvariants parity r.val).
```

`A` can be infinite. There is no ordering or finiteness hypothesis on `A`,
no characteristic hypothesis on `R`, no primality or arity bound, no
invertibility of `2`, and no invertibility of `n!`. Decidable predicates
in the filtering helpers are explicit implementation hypotheses; equality
and inequalities of natural numbers provide them in every application.
Classical choice is used to package finite supports, not to choose averages.

## Objects and signs

A word is a finite `List A`. The ambient coefficient module is
`List A →₀ R`, Mathlib's finitely supported functions, not all coefficient
functions or a completed tensor module. `InvariantCoefficients parity
allowed` is the submodule of these functions satisfying both:

1. For every word `v`, if `¬ allowed v.length`, then its coefficient is zero.
2. `Signed parity f`: for every prefix `pre`, letters `a,b`, and suffix
   `post`,
   ```text
   f(pre ++ a :: b :: post)
     = koszulSign parity a b * f(pre ++ b :: a :: post).
   ```

`koszulSign parity a b` is the element `-1` of `R` when both letters have
parity `true`, and `1` otherwise. Thus this is the usual Koszul adjacent
transposition sign, including in characteristic two. No assertion that
odd repetitions vanish is used; such an assertion would need additional
torsion hypotheses.

`Option A` adjoins the distinguished unit letter `none`; `some a` is an
occupied letter. `unitParity parity none = false` and
`unitParity parity (some a) = parity a`. Consequently swapping a unit past
any letter has sign exactly one.

The actual submodules are:

```text
TensorInvariants parity n
  = InvariantCoefficients (unitParity parity) (fun k => k = n)
OccupiedInvariants parity n
  = InvariantCoefficients parity (fun k => k ≤ n)
PureInvariants parity r
  = InvariantCoefficients parity (fun k => k = r).
```

Signed permutation transport is not left as an assumption.
`KoszulPermutation parity v w s` is the inductively generated signed
reordering relation. Its constructors are `KoszulPermutation.nil` (empty
word, sign `1`), `KoszulPermutation.cons` (common initial letter, unchanged
sign), `KoszulPermutation.swap` (`b,a` to `a,b`, sign
`koszulSign parity b a`), and `KoszulPermutation.trans` (multiply the two
signs). `KoszulPermutation.isPerm` forgets the sign; conversely
`koszulPermutation_lift` proves that **every** `List.Perm v w` has such a
signed lift. `Signed.respects` proves transport in any prefix, and
`signed_permutation_invariance` proves `f v = s * f w` for every generated
signed reordering, not merely for one chosen sorting path. Distinct signed
lifts of identical words correctly impose all stabilizer constraints.

## Occupied-slot extension is proved, not assumed

Write `erase(w) = w.reduceOption`, which deletes `none` and preserves the
relative order of all occupied letters. For every natural `n` and word `v`,

```text
pad n v = v.map some ++ replicate (n - v.length) none.
```

This is defined even for `v.length > n`; it is always injective in `v`
because erasing it recovers `v`. If `v.length ≤ n`, its length is `n`.

`slide_unit` proves that a single unit can be moved through an arbitrary
subword, with arbitrary prefix and suffix, without changing the
coefficient. Induction gives `compact_units`, hence the universal
normal-form theorem

```text
signed_determined_by_occupied:
  Signed (unitParity parity) f →
  ∀ w, f w = f (pad w.length w.reduceOption).
```

Here `f` can be any coefficient function, without a support or fixed-length
assumption. The occupied part itself is still signed; the proof only moves
units and never silently replaces odd transpositions by unsigned ones.

The linear maps `restrict parity n` and `extend parity n` have coefficients

```text
(restrict parity n f)(v) = f(pad n v)
(extend parity n g)(w) =
  if w.length = n then g(w.reduceOption) else 0.
```

`restrict_signed` and `expand_signed` prove that these formulas preserve
the respective signed conditions. `expandFun_finite` proves finite support
for extension even when `A` is infinite: its support is contained in the
finite union, over `v ∈ g.support`, of all permutations of `pad n v`.
`perm_pad` supplies membership in those finite permutation lists.
Restriction is a `Finsupp.comapDomain` along the proved injection `pad n`.
Thus neither direction hides a finite-support assumption.

`restrict_extend` and `extend_restrict` prove both inverse identities.
`occupiedEquiv` packages the resulting `R`-linear equivalence.

For a pure length-`r` invariant, the extension coefficient is its
coefficient on `erase(w)` at **every** occupied `r`-subset of the `n`
positions, with the occupied letters in their relative order. No sum of
multiple representatives contributes to a single word coefficient.
This is the coefficient version of the occupied-subset orbit sum.

## The finite direct sum and the augmentation theorem

`homogeneousPart parity n r` filters the coefficients by word length `r`.
`Occupations parity n` is the finite dependent product
`(r : Fin (n+1)) → PureInvariants parity r.val`.
`decompose` takes these homogeneous parts and `assemble` sums their
inclusions. `decompose_assemble` and `assemble_decompose` prove both
inverse identities; in particular this decomposition is not an input.
`gradedEquiv` and `splitEquiv` are the corresponding linear equivalences.
`tensorDirectSumEquiv` additionally uses Mathlib's
`DirectSum.linearEquivFunOnFintype` to give the displayed **actual direct
sum** rather than just a product notation.

For every `n` the last-slot augmentation is the constructed linear map

```text
augment parity n :
  TensorInvariants parity (n+1) →ₗ[R] TensorInvariants parity n
(augment parity n f)(w) = f(w ++ [none]).
```

It is a coefficient pullback along the proved injective append-unit map,
not a sum over possible slots and not a transfer. `truncate parity n`
keeps occupied coefficients of length at most `n`. The exact conjugacy is

```text
restriction_augmentation:
  restrict parity n (augment parity n f)
    = truncate parity n (restrict parity (n+1) f)

split_augmentation:
  splitEquiv parity n (augment parity n f)
    = dropLast parity n (splitEquiv parity (n+1) f).
```

`dropLast parity n h r = h r.castSucc`. Thus each lower-occupation
coordinate is literally the same element, with coefficient one, and the
top coordinate is discarded. `augment_lower_summand` states this also on
individual summand inclusions: for all naturals `n,r`, all `hr : r ≤ n`,
and all `g : PureInvariants parity r`,

```text
augment parity n
  (extend parity (n+1) (pureToOccupied parity (n+1) r _ g))
  = extend parity n (pureToOccupied parity n r hr g).
```

`augment_top` proves the top inclusion maps to zero.
`augmentSection` is the explicit linear section
`extend(n+1) ∘ includeOccupied(n) ∘ restrict(n)`;
`augment_section` proves that applying augmentation to this section
is the identity on the target. `augmentation_surjective` follows.

Finally the **linear** equivalence

```text
augmentationKernelEquiv parity n :
  (augment parity n).ker ≃ₗ[R] PureInvariants parity (n+1)
```

is constructed with inverse `topInclusion parity n`.
`augmentation_kernel_iff` states for every source invariant `f` that
`augment parity n f = 0` iff there exists a top pure invariant `g` with
`topInclusion parity n g = f`.
This identifies the kernel, rather than only showing that one proposed
submodule is killed.

## Complete declaration inventory

The following inventory names every authored definition, abbreviation,
inductive relation, and theorem. The common quantifiers are those above;
prefixes, suffixes, and words are always arbitrary finite lists.

| Exact declarations (namespace prefix omitted) | Content and extra hypotheses |
| --- | --- |
| `koszulSign`, `unitParity`, `Signed` | Signs and adjacent-swap invariance as defined above. |
| `Signed.zero`, `Signed.add`, `Signed.smul` | Zero, addition of two signed functions, and multiplication by any `c : R` preserve `Signed`. |
| `KoszulPermutation`, `KoszulPermutation.isPerm`, `koszulPermutation_lift` | Generated signed reorders and their equivalence, after forgetting the sign, to arbitrary list permutation. |
| `Signed.respects`, `signed_permutation_invariance` | For every signed function and signed reordering with label `s : R`, transport by multiplication by `s`, with and without arbitrary prefix. |
| `blankCount`, `occupied_add_blank` | Count unit letters; occupied length plus unit count equals total length for every option word. |
| `pad`, `reduceOption_map_some`, `reduceOption_pad`, `pad_injective` | Canonical unit padding; erasure of mapped/padded words; injectivity for every `n`. |
| `length_pad` | Padded length equals `n` under exactly `v.length ≤ n`. |
| `pad_eq_normal`, `perm_pad` | For every option word, its padded erasure is its unit-count normal form and is an ordinary permutation of the word. |
| `slide_unit`, `compact_units`, `signed_determined_by_occupied` | For any signed option-word function, even-unit movement and determination by occupied normal form. No support hypothesis here. |
| `InvariantCoefficients`, `TensorInvariants`, `OccupiedInvariants`, `PureInvariants` | The finite-support submodules with the specified length and sign conditions. `allowed : ℕ → Prop` is arbitrary in the generic definition. |
| `expandFun`, `expandFun_finite`, `expandFinsupp`, `expandFinsupp_apply` | Explicit coefficient extension and its proved finite support for every finitely supported input, even without signedness. |
| `expand_signed` | Signed input functions extend to signed option-word functions at every `n`. |
| `extend`, `extend_apply`, `restrict`, `restrict_apply` | Linear extension/restriction and their exact coefficient formulas. |
| `restrict_signed` | Signed option-word functions restrict to signed functions for every `n`, without support hypotheses. |
| `restrict_extend`, `extend_restrict`, `occupiedEquiv` | Both inverse identities and their linear equivalence, for arbitrary admissible inputs. |
| `selectLengths`, `selectLengths_apply`, `selectLengths_signed` | Filtering by any `keep : ℕ → Prop` with `[DecidablePred keep]`, coefficient formula, and preservation of signedness. |
| `truncate`, `truncate_apply` | Linear cutoff from bound `n+1` to bound `n`. |
| `append_unit_injective`, `augment`, `augment_apply` | Injective last-unit append, the augmentation linear map, and its coefficient formula. |
| `pad_succ` | `pad (n+1) v = pad n v ++ [none]` under exactly `v.length ≤ n`. |
| `restriction_augmentation`, `augmentation_extension` | Augmentation conjugates to cutoff, expressed in both restriction and extension directions. |
| `includeOccupied`, `includeOccupied_apply`, `truncate_include` | Inclusion of bound `n` into bound `n+1`, unchanged coefficients, and cutoff as its retraction. |
| `augmentSection`, `augment_section`, `augmentation_surjective` | Explicit linear augmentation section, its right-inverse identity, and surjectivity for every `n`. |
| `pureToOccupied`, `pureToOccupied_apply` | Unchanged-coefficient inclusion of pure occupation `r` under the explicit hypothesis `hr : r ≤ n`. |
| `homogeneousPart`, `homogeneousPart_apply` | Extraction of occupation `r` from bound `n`, for all `n,r`, and the length-filter coefficient formula. |
| `Occupations`, `decompose`, `decompose_apply`, `assemble`, `assemble_apply` | Bounded families of pure invariants, extraction, finite summation, and their coefficient formulas. |
| `decompose_assemble`, `assemble_decompose`, `gradedEquiv` | Both direct-sum inverse identities and the linear equivalence with bounded families. |
| `splitEquiv`, `splitEquiv_apply` | Tensor-coefficient to bounded-family linear equivalence; its `r` coordinate is `f(pad n v)` when `v.length = r.val`, zero otherwise. |
| `dropLast`, `dropLast_apply`, `split_augmentation` | Coordinate restriction along `Fin.castSucc` and its exact augmentation compatibility. |
| `tensorDirectSumEquiv` | Linear equivalence to the Mathlib direct sum over `Fin (n+1)`. |
| `truncate_pure`, `augment_lower_summand` | Cutoff and augmentation act identically on every pure occupation `r ≤ n`. |
| `truncate_top`, `topInclusion`, `augment_top` | Top pure inclusion and its annihilation by cutoff/augmentation. |
| `homogeneousPart_pure` | A pure component is unchanged by its own homogeneous-part projection, for all `r ≤ n`. |
| `top_part_of_truncate_zero` | Under the explicit hypothesis `truncate parity n g = 0`, a bound-`n+1` invariant equals its top homogeneous component. |
| `augmentationKernelEquiv`, `augmentation_kernel_iff` | Linear kernel identification and the equivalent existence-of-top-preimage criterion. |

## Relationship to ordinary tensor invariants: unformalized bridge

For the intended free model, take `V = A →₀ R` with the homogeneous basis
indexed by `A`, and `U = Option A →₀ R`, where the `none` basis vector is
the even unit. Abstractly, the standard tensor-product basis identifies
their tensor powers with finitely supported coefficients on fixed-length
words. Adjacent Koszul permutations act by the signed basis permutations
used here; last-factor augmentation sends `none` to `1` and each
`some a` to `0`. Under these identifications the proved coefficient maps
are exactly the occupied-subset extension/restriction and last-slot
augmentation of the report.

**That tensor-product basis identification, its equivariance, and its
augmentation compatibility are not constructed as Mathlib tensor-product
equivalences in this source.** Likewise no separate homomorphism from
`Equiv.Perm (Fin n)` into automorphisms of a tensor module is constructed:
permutation invariance is encoded and proved via the explicit signed
adjacent-swap-generated relation, which covers every ordinary list
permutation. There is no assumption of an occupied-slot decomposition.
The result is a full universal finite-support coefficient-model theorem,
not a Lean certification for an arbitrary nonfree split graded module.
Extending to such modules is not asserted here. No cohomology, Sylow
theory, stable elements, spectra, connectivity, or whole-module model
equivalence is formalized.

## Reproducible compiler evidence

The required verification command is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/uniform_connectivity/formal/Main.lean --statement-fidelity research/uniform_connectivity/formal/statement_fidelity.md --claim C_UC_SPLIT_FORMAL --project-root campaigns/9000308 --artifact-dir research/uniform_connectivity/formal/evidence
```

The source ends with kernel dependency prints for the main declarations.
Their only foundational dependencies are subsets of `propext`,
`Classical.choice`, and `Quot.sound`; there are no project-declared
assumptions or proof holes. The compiler result, axiom audit, immutable
claim certificate, and source/fidelity hashes are produced by the official
verifier, not by this document. The fidelity explanation itself is not a
Lean theorem.
