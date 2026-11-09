# Statement fidelity: character-complete negative-four cap arithmetic

The claim is `C_LENS_ARITH`. All declarations below are in namespace
`LensCap` in `Main.lean`. The formal source uses Mathlib over Lean 4.31.0.
There are no additional axioms or analytic index-theorem hypotheses in this
formalization. It proves arithmetic consequences, not the analytic
identification of an integer-valued function with a Fredholm index.

## Objects and quantifiers

`diracIndex a` is the integer
`(a / 4) * (1 - a % 4 - 2 * (a / 4))`, with Euclidean integer quotient and
remainder, for every integer `a`, including negative integers.
Geometrically, `a` is the twist of the canonical complex spin-c structure
on the complex-oriented negative-four disk bundle; its determinant
evaluation is `k = 2*a - 2`. The geometric interpretation is established
separately in `proof.md`, using the cited index theorems.

`b16 a` is `1 + 4*r - 2*r^2` for `r = a % 4`.
`fixedPointTerm r` is the complex number

    (i^r/(1+i)^2 + (-1)^r/4 + (-i)^r/(1-i)^2)/4.

It is the three nonidentity terms for the actual fiber character `i^r`
and tangent action `(i,i)`, with the *dual* tangent eigenvalues in the
denominator. `fixed_point_terms` and `b16_values` calculate all four
values exactly: `(1,3,1,-5)/16` and `(1,3,1,-5)`.
The identification with an equivariant index contribution is not
formalized; nor does Lean prove analytic excision.

## Index identities

`dirac_residue` quantifies over all integers `q,r`, assuming only
`0 <= r < 4`, and proves the quasi-polynomial formula at `a=4*q+r`.
`dirac_polynomial` and `dirac_square` quantify over every integer `a`.
The latter states

    32*diracIndex a = (2*(a % 4)-2)^2 - (2*a-2)^2.

Thus it retains the full twist residue modulo four, equivalently the
determinant evaluation modulo eight, rather than only the determinant
residue modulo four.

For arbitrary integer `m`, put `d=2*m` and `kappa=d^2/16=m^2/4`.
`asd_normal` proves that minus twice the two normal line indices is
`2*m^2 = 8*kappa`. `b16_pairs` proves the complete four-character
pair cancellations. `coupled_minus`, `coupled_plus`, and
`coupled_both_backgrounds` prove

    4*(diracIndex ((lam+2)/2+m) + diracIndex ((lam+2)/2-m))
      = -m^2 + m % 2,

for both and only the stated backgrounds `lam=2` or `lam=-2`.
Here `m` even means a central state and `m` odd means a trace state;
`m % 4` also distinguishes the two central lifts and the prescribed
ordered trace eigenvalue. `charge_congruence` supplies an integer witness
for divisibility of `m^2 - m % 2` by four.

`dirac_nonpositive` and `dirac_zero_iff` apply to all integers, not to a
bounded search. The latter identifies the exact zero set
`-1 <= a <= 3`, equivalently the five possible even determinant
evaluations `-4,-2,0,2,4`.
`tangential_references` instantiates these values and the two alternative
central-minus references with real correction `-2`.
`all_charge_shifts` is a rational polynomial identity for every rational
shift, hence in particular every integer shift. It gives the real spinor
correction after adding twice the Dirac correction. It does not assert
existence of a connection at every charge.
`b16_conjugation` and `dirac_conjugation` prove invariance under
`a -> 2-a` for every integer `a`, corresponding to `k -> -k`.

## Determinant and eigenline transport

`determinant_transport` and `spinor_determinant_transport` quantify over
all integers `b,e,m`. In the manuscript's actual bit family
`l[S]=2` is fixed, `c_e[S]=-4*e`, and `Lambda_e[S]=2-4*e`.
Thus `b=(l[S]+2)/2=2` is fixed, NOT increased by `2*e`.
The two bundle line degrees are `-2*e+m` and `-2*e-m`;
their total spinor twists are `b-2*e+m` and `b-2*e-m`.
`fixed_spin_c` records the fixed determinant `l`.

The order-two shift does not cancel in the ordered spinor characters.
At trace, the determinant-one Weyl map swaps the lines.
`trace_character_transport` assumes `m % 2 = 1` and supplies explicit
integer witnesses that the *swapped* new twists `-m,m` differ from
the old twists `2+m,2-m` by multiples of four.
`trace_index_transport` proves equality of the corresponding individual
Dirac indices for every integer `m`; the character interpretation of
this equality is used only when `m` is odd.

At a central state tensoring exchanges the two intrinsic states; a
Weyl map cannot conjugate `+id` to `-id`.
For comparison at a fixed exterior central state,
`central_reference_transport` uses the alternative reference
`m -> m+2`. It keeps the active twist exactly fixed and changes the
complementary twist by `-4`, hence preserves both boundary characters.
`central_reference_charge` records the accompanying integral reference
charge change `m+1`; it does not pretend this is the same interior
tensor operation at fixed relative charge.

`chern_transport` quantifies over arbitrary rational `kappa,e`,
with `c^2=-4*e^2` and `c2=kappa-e^2`. It proves invariance of the
trace-free charge and the exact changes under `e -> e+1`; at `e=0`
these are `Delta c^2=-4`, `Delta c2=-1`.

`weyl` is the explicit complex matrix `[[0,-1],[1,0]]`.
`weyl_determinant`, `weyl_trace_transport`, and `weyl_square` prove
its determinant is one, its intertwining of `diag(-z,z)` with
`diag(z,-z)` for every complex `z`, and its square is `-id`.
For `z=i` this is the prescribed trace boundary transition. It swaps
the two coordinate eigenlines. These are matrix identities, not a proof
of a determinant-line orientation or gluing theorem.

## What remains outside the compiler

The compiler does not verify the cited sources, the geometric character
identifications, the APS/Fredholm comparison, positive-scalar-curvature
kernel vanishing, coherent orientation-line gluing, cap cut counts, or
the global cosmetic surgery theorem. These require the prose proof and
independent Reviewer. Compiling this file cannot close any global
manuscript claim.
