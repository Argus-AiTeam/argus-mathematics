# Exact affine-fiber counting and its formal boundary

## Claim, source and disposition

`C_PACK_COUNT@1` is the preliminary prose statement; v2 adds the actual Lean
source and has a different subject binding. Both express the standard
uniform/constant alternative for linear functionals. The archived v2 source
supports that precise algebraic assertion, not a packing or independence
theorem. This is an old Argus formalization/reproduction of elementary linear
algebra, not an established novel theorem.

The read-only source is
`families/076/first-pass/packing-audit/formal/Main.lean`.
Its source and fidelity text match the snapshot manifest and the immutable
`certificates/C_PACK_COUNT-0dd7e477d502abfe.json`; that certificate's subject
is exactly the old v2 binding recorded in [the index](../../DRAFT_REVIEW_INDEX.json).
The old independent support is
`judgement-C_PACK_COUNT-eb6d36b42606`, by `reviewer:65ff03c5a5e8`,
on that same subject and certificate.

## Actual quantifiers and hypotheses

`K` is a commutative field; `V,W` are additive commutative groups with
`K`-module structures. `F:V -> W` and `g:V -> K` are linear maps.
`uniform_fiber_count` additionally assumes finite `K` and `V`, a witness
`v` with `F(v)=0, g(v)=1`, arbitrary `s:W` and any `Finset B` of field
elements. There is no finiteness assumption on `W`, dimension bound,
fixed prime, odd characteristic or nonempty-fiber assumption. Its equality
is in natural numbers:

    |K| * #{x : F(x)=s and g(x) in B} = |B| * #{x : F(x)=s}.

In particular an empty fiber gives `0=0`; interpreting the identity as a
conditional probability additionally needs a nonempty finite fiber.
Neither `F` nor `(F,g)` is assumed surjective onto the whole codomain.
The kernel-witness hypothesis is essential and is not supplied automatically
by an arbitrary constraint map.

`nonparallel_forms_uniform_count` specializes to scalar-valued `f,g`,
with `f != 0` and `g != c f` for **every** `c in K`, including zero.
`exists_kernel_normalized_of_not_scalar_multiple` constructs the witness
without any finiteness hypothesis. `constant_on_fiber` assumes `g=c f`
and `f(x)=s`, and concludes `g(x)=cs`; it needs neither finiteness nor
nonzero `f`.

## Decisive argument and fidelity

The encoded equivalence sends `x` to `(g(x),x-g(x)v)` and sends `(a,z)`
back to `z+av`. The linear equations ensure the second component lies in
`F=s, g=0`, and direct substitution gives both inverse laws. Restricting
the first component to `B` gives `selectedFiberEquiv`. The two
card-factorization theorems and multiplication give the displayed identity
without division or cancellation.

For the nonproportional case choose `w` with `f(w)=1`. If `g` vanished
on `ker f`, applying it to `x-f(x)w` would show `g=g(w)f`, contrary
to the explicit hypothesis. Normalize a kernel vector with nonzero
`g` value. These are precisely the formulas and hypotheses in the
archived `statement_fidelity.md`; its interpretation agrees with the
source. The auxiliary equivalences/factorizations need no finite instances;
their interpretation as ordinary finite counts in the main theorem does.

To specialize to the manuscript, work over an admissible prime field.
Pairwise rank two supplies the nonproportional scalar forms. A signed
combination may instead be proportional and constant; the theorem does
not erase that branch. Product-fiber use requires the stated kernel
witness, not joint independence of all original forms.

## What actually ran, and what did not

The official historical `lean_check.json` records Lean **4.31.0**
(commit `68218e876d2a38b1985b8590fff244a83c321783`), Lake
`5.0.0-src+68218e8`, elan `4.2.3`, and the built workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
The recorded compiler and axiom-audit exits are both zero, with
`proof_holes=[]`; the source and fidelity hashes are bound into the
immutable certificate. `compile.log` agrees. `compiler-01.log` records
an earlier successful run with unnecessary-`simpa` and unused-instance
warnings, not a failed theorem. `compiler-final.log` records exit zero
without those warnings. Those transcripts are not additional results.

The current replay of the unmodified `verify.py` exited zero. Its
`formal_certificate` function checked the source/fidelity hashes,
embedded archived text, exact compiler-result equality, latest old claim
binding, and attachment of the mechanical evidence to that claim. This
is archival consistency replay, **not a fresh Lean compilation**.
The old source was deliberately not recompiled or copied into a new
formalization. The archived compiler result is reading material here;
it does not create mechanical evidence for the current review claim.

Only the old counting claim earned the historical kernel certificate.
Random slots, raw moments, union bounds, hypergraph deletion, the external
matching theorem, real intervals and analytic polynomial statements are
not encoded. No gap in the stated algebraic argument was found; expanding
that certification boundary would be an unsupported claim.
