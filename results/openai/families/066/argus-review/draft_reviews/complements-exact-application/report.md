# Application to complements exact penalization

**Assessment:** the old proof supports `C_COMP_EXACT` v1 in the fixed
complex local setting and with the proposition's rational data. It
does not verify the complements manuscript's main theorem or its
field-descent and degeneration steps.

## Exact claim and attribution

The matched source is complements `constrained-minimum.tex:104-125`,
Proposition `a:exact-penalization`, revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its section hash is
`0647544a1f6fd7d0cdebaa5717e1b12efcb6ba4d811c044e37321b03bfbffe31`.
The old Argus application is `verification.md:398-435`; it is a
reproduction/application of that proposition, not a new complement theorem.

Let `x in U` be an affine klt germ of dimension `p`, `I0,J` nonzero
ideals, and `c>0`, `b0>=1`, `c'>=0` rational. Assume `(U,I0^c)` is lc
with a centred quasi-monomial lc place and

```
a(u)=b0*A_U(u)-c'*u(J),    A_U(u)<=a(u)<=b0*A_U(u).
```

The claim is that `a(u)^p*vol(u)` on centred quasi-monomial lc
places has a unique minimizing ray, realized by actual ordinary
effective rational klt minimizers for every sufficiently small
positive rational parameter. Its associated graded is finitely
generated, and a torus preserving the point, ideals and height fixes
the ray and the valuation after invariant normalization.
Constants may depend on the fixed germ and ideals.

The manuscript's ambient characteristic-zero generality has a
separate reduction to the complex setting. The old draft expressly
does not prove that reduction or field descent here.

## Decisive application checks

The boundary-encoding unit checks that averaging sufficiently many
general ideal equations gives `B0,BJ` with

```
e=A_U-v(B0)>=0,
{e=0}=the original ideal-lc cone,
a_D=b0*A_U-v(BJ),    A_U/2<=a_D<=b0*A_U,
a_D=a on that cone.
```

Use the bridge with `Psi=B0`, `alpha=b0` and height `a_D`.
Its displayed pair is exactly

```
Delta_t=(B0+t*BJ)/(1+t*b0).
```

This is effective and rational, not a signed-boundary substitution.
The lower bound `a_D>=A_U/2` gives positivity on every normalized
lc face. The bridge therefore applies with a singleton rational
height and forces each actual small-parameter minimizer onto the
original ideal-lc cone.

On this cone its discrepancy is `t*a/(1+t*b0)`, a positive scalar
multiple of `a`, so the constrained objective and the ordinary
pair objective have the same minimizing rays. Existence and
uniqueness come from the actual klt minimizer, rather than from
an assumption that the constrained infimum is attained.
Finite generation is invoked only after this exact identification.

Torus invariance does not require the auxiliary general equations
to be torus invariant. The original constraint and height are
invariant, hence the uniquely characterized constrained ray is
invariant. Normalizing by its positive maximal-ideal value makes
the valuation itself invariant, since the torus fixes the point
and its maximal ideal.

This also checks the scope of equation `(A4)`: a single local-ring
comparison constant works for every nonzero regular function and
all sufficiently small parameters on this fixed resolved germ.
The proof does not obtain exactness from `e=O(t)` alone.

## Evidence and unresolved scope

Prior independent support
`judgement-C_COMP_EXACT-f1b1da39e2bc` is tied to the exact v1 hash
`8737e244f70a55fa9146791f09c78181ae10851dad42578e4c9fd260368c34d2`
and the unchanged proof note. Its interpretation agrees with the
complex local application above. The same source/version alignment
does not turn a supporting opinion into current native acceptance.

External assumptions are the ordinary-input package and the
fixed-model/general-member setup assessed in the dependent units.
The real compiler evidence is only for the scalar reduction;
there is no Lean proof of this proposition's geometric hypotheses.

No missing step was identified within this local rational
application. The concrete unreviewed obligations for the main
complements theorem include reduction/field descent, compatible
specialization and degeneration, rank growth, and trace survival
and lifting. They are not consequences of local finite generation.
They remain open as obligations of the old audit, not asserted
false or mathematically open problems in the literature.
