# Proposed double-fibration criterion

**Assessment: a supported conditional corollary of the same proof, not a
classification or a verified novel theorem.** Unlike an additional copy
of the numerical certificate, this is a genuinely different hypothesis
package, so it merits a separate assessment.

The assertion `DF_CRITERION` occurs in "Exact verification theorem and
rational proof format" of the old
`9000067/research/pseudoindex-five-audit/report.md`. It has no separate
old ledger claim. It is attributable to that report's proposed structural
reformulation, not to the manuscript's stated Fano/nef theorem. The
current review does not claim that it is new in the literature.

## Exact hypotheses and conclusion

Let `pi:U^9 -> V^8` and `e:U^9 -> X^6` be smooth **surjective**
morphisms of smooth connected complex projective varieties. Assume:

- Every `pi`-fibre is `P1`; the `e`-fibres are connected.
- `X` is simply connected and `H^2(X,Q)=Q h_X`.
- `c1(T_X)=5h_X`, with `h_X` a rational cohomology class, and
  `h=e^*h_X` has degree one on every `pi`-fibre.
- For **every** `pi`-fibre `C`, `T_e|C=O(-1)^3`.
- `I=int_X h_X^6` and `D=int_F c1(L)^3` are nonzero, where
  `F=e^(-1)(x)` and `L=(T_pi|F)^dual`.

With `S=int_F c1(T_F)c1(L)^2`, the conclusion is

```
3S^2 - 20SD + 32D^2 = 0.
```

These are strong hypotheses. The report drops nefness/Fano/positivity,
not their every-member, topology, cohomology, dimensional and nonzero
normalization consequences. It does not claim that any prescribed
numerical vectors can be realized by such fibrations.

## Applicability of the argument, hypothesis by hypothesis

Rational Leray--Hirsch and relative GRR apply to `pi` independently
of nefness. They give the same involution and product rule. Set
`c=c1(T_pi)`, `ell=2h-c`. Although `h_X` need not be integral,
the bundle

```
A = e^*(-K_X) tensor (T_pi^dual)^2
```

is actual, has `c1(A)=5h-2c=h+2ell`, and degree one on each
`pi`-fibre. The required splitting makes `T_e tensor A` fibrewise
trivial. Thus the same base-change argument descends `r,s,t`; there
is no additional assumption that `h` is a line-bundle class.

Smooth projectivity and simple connectedness of `X` give precisely the
complete invariant-cycle/Hodge argument needed for the two GRR
vanishings. No Fano topology theorem is needed here, since the topology
is an explicit premise. Tangent-sequence additivity and the dimensions
give the same five cohomological row groups; the two GRR polynomials
give the sixth group of integral relations.

On `F`, `h=0`, so `ell|F=-c|F=c1(L)` and
`r|F=c1(T_F)`. The conditions on `H^0(X,Q)` and `H^2(X,Q)`
give the same scalar pushforwards. Nonzero `I,D`, rather than positivity,
justify **every division** defining `xi,eta`, and their product is
the common nonzero scale for all selected coordinates. Hence the same
normalized rational theorem applies.

The tangent-map theorem is not needed in this criterion: it supplied
ampleness and `D>0` in the actual minimal-family application. Here
`L` is defined directly and `D!=0` is assumed. The proof does not
silently assume `L` is ample, globally generated, or the pullback of a
hyperplane bundle. Likewise `h_X` need not be ample.

## Limits, attribution and remaining work

This is a logical extension of the **conditional numerical implication**,
not an extension of sixfold homogeneity. Without `D!=0` or `I!=0`,
the stated normalization argument stops; no conclusion for those
degenerate cases was established. With only generic splitting or an
arbitrary noncomplete base, the descent/Hodge steps are unavailable.
These are concrete premise boundaries, not access failures.

The current assessment reuses the already inspected rational proof and
external projective-line, base-change, fixed-part, degeneration and GRR
inputs documented in `../geometric-bridges/report.md`. No additional
search, computation, family construction or cofactor computation is
required to check this corollary. No independent publication/priority
search was done, so novelty remains unverified. Historical approval of
the actual-family numerical audit does not automatically approve this
separate hypothesis replacement or this present assessment.
