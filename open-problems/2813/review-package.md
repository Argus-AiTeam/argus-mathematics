# Result 2813 external review package

## Result

Let `W` be the genus-three Eierlegende Wollmilchsau origami and let `f` be
the affine map obtained by the application-order word `SSTSST`, followed by
left deck translation by `-i`. Its derivative is

```text
[11  4]
[ 8  3]
```

For the mapping torus `M_f`, the exact saturated free coordinates give

```text
H_1(M_f; Z) = Z^3 + Z/2 + Z/6
PD(a)        = ( 1, -1, 1)
PD(e_f)      = (-4,  0, 0)
PD(w)        = (-2, -2, 2) = PD(e_f + 2a).
```

The class `w` is even and integral, lies in the dual Thurston unit ball, and
is not the Euler class of any smooth cooriented taut foliation on `M_f`.

## Mathematical chain

1. The eight-square quaternion gluing gives a closed genus-three surface.
2. The displayed derivative is hyperbolic, so the affine map is
   pseudo-Anosov and its closed mapping torus is hyperbolic.
3. Exact Smith reduction gives first Betti number three and a saturated free
   coordinate basis.
4. All twelve fixed points are enumerated. Their complete suspension-homology
   multiset does not contain `PD(a)=(1,-1,1)`.
5. The exact Alexander difference body contains `PD(w)`, and McMullen's norm
   comparison places `w` in the dual Thurston unit ball.
6. Liu's Lemma 3.2 excludes `w=e_f+2a` from weakly fillable contact Euler
   classes. Taut-foliation approximation then excludes every smooth
   cooriented taut foliation with Euler class `w`.

## Reproduction

Run:

```bash
python3 replay.py
```

The witness verifier uses integer and rational arithmetic and must reproduce
the published witness certificate byte for byte. The second verifier checks
the derivative traces, the rank-eight intertwiner system, and the distinct
quaternion deck actions that exclude the nearest Matheus--Yoccoz formula.

## Independent review already completed

Independent review replayed both exact certificates, checked all
claim-relevant source propositions, verified the final theorem against the
campaign objective, and recorded affirmative decisions for statement
fidelity, argument correctness, outcome honesty, and the project Goal Gate.

## Scope

This is one explicit nonrealizable class in the smooth cooriented
taut-foliation branch of Kirby Problem 3.15. It does not classify that branch
and does not decide the tight-contact, universally-tight, pseudo-Anosov-flow,
quasigeodesic-flow, or circle-action branches.

The project found no equivalent explicit pair in its audited corpus. This is
a scoped noncollision statement, not a claim of worldwide priority. Liu's
obstruction, the quaternion origami, the canonical affine lifts, and the norm
comparison are prior work.
