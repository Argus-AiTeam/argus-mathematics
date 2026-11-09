# The compact-family exact-containment bridge

**Assessment:** the precise rational-coefficient theorem written in the
old proof is supported by its geometric estimates and ordinary-klt
inputs. The ledger's unqualified “every height” shorthand must be
restricted to that theorem; it is not evidence for irrational-height
exact realization. This remains a human proof assessment.

## Exact theorem and version fidelity

The subject is `C_LC_EXACT_BRIDGE` v1, hash
`efbe45216d225a295257dd60a49a64ac02907feb072dd73970602317e6389c5b`,
in `CTX_LC_EXACT` v1. The proof is the unchanged
`verification.md`, especially lines 66-107 and 345-397.

Fix a positive-dimensional complex affine Q-Gorenstein klt germ,
an effective rational sum `Psi` of principal Cartier divisors that is
lc and has a centred quasi-monomial zero-discrepancy ray, and fixed
nonzero regular equations `g_i`. Set

```
e(v)=A_X(v)-v(Psi),
b_eta(v)=alpha*A_X(v)+sum beta_i*v(g_i).
```

Let `K` be a compact coefficient family with `b_eta>0` on **all**
nonzero `A_X=1` lc rays, including noncentred faces. Suppose uniformly
for sufficiently small positive `lambda` that

```
Delta_(lambda,eta)
  = (Psi-lambda*sum beta_i*div(g_i))/(1+lambda*alpha)
```

is effective, with positive denominator. Then there is a positive
rational `lambda0` such that, for every **rational coefficient vector**
`eta in K` and rational `0<lambda<lambda0`, this is an effective
rational klt pair and its actual global normalized-volume minimizer
lies exactly on the lc cone. For fixed `eta` the minimizing ray is
independent of `lambda`, uniquely minimizes `b_eta^n*vol` on centred
lc rays, and has finitely generated associated graded.

The old ledger short statement says “every height” without the
boldfaced rational restriction. The proof theorem explicitly includes
it, and its ordinary-pair existence/finite-generation inputs are
used in the effective rational setting. Those statements must not be
silently conflated. The estimates themselves can be uniform over the
real compact coefficient set, but the written realization theorem is
quantified over its rational vectors. No conclusion for an arbitrary
irrational vector, nor a counterexample to such a conclusion, is supplied.

## Why exactness, rather than convergence, follows

The fixed model's zero-defect locus is a finite union of normalized
monomial simplices. Positive bare discrepancies make it compact;
resolved equation evaluations are continuous across faces. Thus
compact `K` and positivity on every face give a common lower height
bound. The jet, local-ring and sublevel units assess these steps
separately, rather than outsourcing them to the compiler.

Every actual minimizer is quasi-monomial and lies in the entire
sublevel defined using one fixed lc competitor. On that set there
are constants, uniform in height, competitor, test function and
small parameter, such that

```
0<b=b_eta(r)<=B,   h=b_eta(v)>=b-D*e,
V=vol(v)^(1/n) >= R/(1+C*e),   R=vol(r)^(1/n)>0.
```

The positive centering bound proves that `r` is an admissible
competitor; this is not assumed from the start. Choose one positive
rational `lambda0` below the klt/effectivity/sublevel thresholds and
`1/(2*(1+D+C*B))`. The scalar unit then gives, for every `e>0`,

```
(e+lambda*h)*V > lambda*b*R.
```

The denominator `1+lambda*alpha` is constant in the competing
valuation, so it does not change minimizers. Retraction strictly
improves every positive-defect minimizer candidate. Competitors
outside the sublevel already lose to the fixed lc ray. Hence an
actual ordinary minimizer has defect **zero at each fixed small
parameter**, not just a defect tending to zero.

On the cone the objective is `lambda*b_eta*vol^(1/n)`. Ordinary
uniqueness then gives constrained uniqueness: a minimizer for any
other small parameter minimizes the same cone objective and hence
also the first pair's objective. It is the same ray. Finite
generation applies to that actual effective rational klt minimizer,
not to a limit of unrelated finitely generated valuations.

## Attribution and strongest prior evidence

Both manuscripts already assert rational exact realization. The
old draft proposes an explicit common-threshold formulation over a
compact positive family and derives the rational result without
the Cartier manuscript's convex-domination/strict-gap route or an
assumption of constrained attainment.

The strongest prior result is not merely the scalar Lean inequality:
`reviewer:dccb8f343ba8` supported this exact claim hash in
`judgement-C_LC_EXACT_BRIDGE-b392c50acbfd`, as well as the component
claims, on the unchanged proof draft. That is applicable prior
human evidence for the precisely written rational theorem. It does
not resolve the unqualified irrational-height reading or supply
current native acceptance.

The old bounded lookup found no verified prior fixed-perturbation
containment theorem. A negative lookup is not a novelty proof.
The compact-family statement is therefore a proposed strengthening
with originality **not established**, not a verified new theorem.
This review adds coverage and scope reconciliation, not a stronger
mathematical result.

## Limits and concrete obligations

The ordinary-input unit records the external retraction, Izumi,
properness, existence, quasi-monomiality, uniqueness, finite
generation and volume-limit propositions and their restrictions.
There is no full geometric Lean formalization; the current compiler
replay concerns only the scalar/abstract reduction.

No concrete gap was identified in the precise rational theorem under
these inputs. An extension to arbitrary irrational coefficients needs
an applicable ordinary-minimization theorem and a separate argument;
continuity or finite generation cannot simply be presumed. Omitting
face positivity, changing the germ or equations, or dropping uniform
effectivity also changes the assertion. Neither manuscript main
theorem follows from this bridge alone.
