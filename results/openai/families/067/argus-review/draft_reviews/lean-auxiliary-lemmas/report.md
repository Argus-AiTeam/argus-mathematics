# The three exact Lean declarations

**Assessment: three correct elementary rational statements, with narrowly
limited statement fidelity.** The source is reading material, not a
formalization of the numerical audit, its geometry, or this review.

The complete 1472-byte read-only source
`families/067/first-pass/pseudoindex-five-audit/Main.lean`
was inspected. It imports `Mathlib`, declares a namespace, and proves
exactly the following three theorems. No extra sixfold/rank theorem,
`sorry`, or local axiom is present in that source.

## SHIFTED_CHERN_RECOVERY

`PseudoindexFiveAudit.shifted_chern_recovery` universally quantifies
`a b d h : Q`. With

```
r = (a+h)+(b+h)+(d+h),
s = (a+h)(b+h)+(a+h)(d+h)+(b+h)(d+h),
t = (a+h)(b+h)(d+h),
```

it asserts the conjunction

```
r-3h = a+b+d,
s-2hr+3h^2 = ab+ad+bd,
t-hs+h^2r-h^3 = abd.
```

The proof unfolds the lets and uses `ring` for each equality. Direct
expansion confirms all three, including signs and coefficients.
These are the root-substitution polynomials used by the checker.
The encoded objects are four rational numbers, not actual Chern classes,
cohomology rings, bundles, a splitting principle, or descending classes.
Transporting the polynomial calculation to geometry is a separate argument.

## QUADRATIC_FACTORIZATION

`PseudoindexFiveAudit.characteristic_quadratic_factorization`
universally quantifies `S D : Q` and states

```
3S^2-20SD+32D^2 = (3S-8D)(S-4D).
```

Its `ring` proof is the exact expansion
`3S^2-12SD-8SD+32D^2`. There is **no** hypothesis that the left
side vanishes, and no assertion that `D` is positive/nonzero. The
theorem does not prove that the characteristic numbers satisfy the
quadratic or that their ratio must be `8/3` or 4. Those conclusions
require the independent geometric/algebraic premise. An identity
factoring a polynomial is not a proof of its vanishing.

## SCALAR_SPECIAL_FIBRE

`PseudoindexFiveAudit.special_fiber_jump_obstruction` states

```
exists p : Q -> Q,
  (forall t, t != 0 -> p(t) != 0) and p(0)=0.
```

The witness is `p(t)=t^2`; `pow_ne_zero 2 ht` proves the first part,
and the zero evaluation is immediate. The exact existential type is
an arbitrary **function** `Q -> Q`, not a polynomial object or a
family of vector bundles. Its chosen witness happens to be polynomial.

This valid scalar illustration does not construct an algebraic family
with a jumping splitting type, refute an every-member bundle theorem,
or prove a defect in Kanemitsu. The source comment's reference to
`F067_KANEMITSU_EVERY_MEMBER_SPLITTING` is motivational only. The
separate every-member argument in the old report remains intact.

## Compilation, fidelity, dependencies and attribution

No fresh Lean compiler run is claimed. There is no Lean compiler
certificate or statement-fidelity document for these declarations in
the 43 listed artifacts; all 35 old ledger evidence records are
judgements, not Lean mechanical evidence. The mere presence of
`import Mathlib`, the host's available Mathlib workspace, a passing
Python checker, or an old status label cannot establish compilation.
No Lean/Mathlib version is attributed to an unperformed run.

This review created no `.lean` copy or new formal claim. Its current
ledger judgement cites the review report, never the old source as a
kernel certificate for review completion. Therefore the appropriate
evidence here is the complete declaration reading and elementary
mathematical verification, with **compilation unverified** and statement
fidelity explicitly bounded above.

If compiler certification of these lemmas is later required, the concrete
obligation is a fresh real run against the exact source and an accompanying
accurate fidelity document, under an authorized writable path. It would
certify these three statements only; formalizing the rank argument,
geometric bridge, or full sixfold theorem would require new statements
and proofs. None is needed to misrepresent this reading as kernel closure.

The identities and scalar construction are standard elementary facts.
The source is an old Argus auxiliary formalization; there is no verified
novelty or geometric counterexample to count.
