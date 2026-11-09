# Statement fidelity: selected-bin rational core

`Main.lean` is a universal theorem over **real** variables, not a check of
sampled dyadic bins. All numerals and fractions in it are exact. All three
declarations are in the namespace `SelectedBinCoefficient`.

The declaration `no_unsafe_selected_exponents`
quantifies over nonnegative `a,b,c,z,y,H`, with `z+c=1` and
`d=(a+b+y+H)/100000`. Here `a` is the manuscript's `alpha`, `d` is
its `Delta`, and the other letters have the same meaning as in
`selection.tex`, equation `sel:powers`. It assumes the strict near-selection
inequality and the exhaustive disjunction of the two energy-derived far
bounds, with the original split at `H=2c` (equality in the first branch).
It concludes `False` if **both** coefficient inequalities are unsafe.
Equivalently, under the other assumptions, at least one of

```
b <= 2H/3+z/6-d/3,
H+2y-z/2+d <= b
```

holds. These are precisely the safe alternatives after taking logarithms
of the two terms defining `U`, with equality allowed.

Two conditional hypotheses encode availability of occupation entries:

1. If both `z-y>3/10` and `1-a-y>3/10`, the stable far bound
   `b<H/2+y+z/500` is available.
2. If both momentum exponents exceed `7/10` and all four strict
   intermediate-angle window inequalities hold, the improved far bound
   `b<H/2+(29/50)y+d` is available.

Neither antecedent is assumed outright. The proof derives the stable
antecedent using energy alone, then derives the improved antecedent using
the stable bound. The improved hypotheses are stronger than the closed
window in the manuscript, so its analytic bound, if valid, applies.
Both far bounds are **weaker** than the manuscript bounds: the nonpositive
term `-min(a,c)` is dropped; stable-cell absorption is relaxed to
`z/500`. Thus the formal proof does not obtain a contradiction by making
the occupation information stronger than the source.

`energy_maximum_branches` quantifies over real
`i,H,c` with `i<=-2c`. It proves the exact energy maximum when `H<=2c`,
and its upper envelope when `H>2c`, including the equality boundary.
Here `i=log(I)/log(P)`.

`occupation_maximum_envelope` quantifies over
real `i,H,c,rho,t` with `i<=-2c`, `H>=2c`, `rho>=c`, and `t>=0`.
It bounds all three exponents in the occupation maximum, including
the zero exponent for the constant plateau. Specializing
`t=y+z/1000` covers the stable entry after absorption; specializing
`t=0` covers the improved entry. `rho=max(a,c)`.

The Lean statements do **not** contain particles, fields, source-time
geometry, actual occupation measures, real powers, square roots, logarithms,
or an existential `Pstar`. They do not prove any analytic occupation bound,
the direction-change estimate, a signed-force identity, bootstrap closure,
continuation, or global Vlasov--Maxwell regularity. Their conversion into
the exact representative theorem and the explicit threshold uniform in all
bins and all `I>0` are proved in `REPORT.md`, not by Lean.

The ledger claim `C_SEL362_CORE` is this rational core only.
`C_SEL362_THRESHOLD` and `C_SEL362_EXPONENTS` are separate prose claims.
Independent Reviewer assessment of this translation and these prose proofs
is still required; kernel compilation cannot establish statement fidelity.
