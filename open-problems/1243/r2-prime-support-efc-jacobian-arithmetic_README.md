# Prime-support EFC Jacobian arithmetic

> **Draft while exact jobs run:** the all-four-curves conclusions below are
> contingent on the pending representative-0 `p=5` and representative-16
> `p=7` Frobenius/root-ratio certificates. This file is not yet an accepted
> result.

`MILESTONE_STATUS=blocked`

This route finds no noncollision EFC point and does not classify the rational
points of any of the four genus-9/10 quotient curves. Its exact contribution is
an arithmetic obstruction: all four geometric Jacobians are absolutely simple,
all four geometric curve-automorphism groups are trivial, there is no map to a
positive-genus curve of smaller genus, and distinct quotient Jacobians have no
nonzero homomorphism over `Q`. Thus the proposed factor, automorphism-quotient,
and `Q`-correspondence reductions do not lead to a rational-point
classification.

The remaining gap is not a finite-search boundary. No Mordell-Weil basis,
Selmer/rank bound, geometric correspondence classification, Chabauty
certificate, or complete covering/Mordell-Weil sieve is available for these
four high-genus curves. Consequently the two EFC classes are **not excluded**,
`R2-EFC-HIT` remains open, and the original magic-square problem remains open.
There is no candidate, so the authoritative magic-square checker was not run.

## Input and exact outputs

The only curve equations used here are the four reviewed
`simultaneous_negation_quotient.polynomial` entries in
`../r2-prime-support-efc-coupled-curves/evidence/plane-models.json`.
They represent the four exact symmetry orbits indexed by `0,1,16,17`.

| Representative | Genus | Canonical quadrics | Canonical degree | Simplicity prime | Auxiliary comparison prime |
|---:|---:|---:|---:|---:|---:|
| 0 | 9 | 21 | 16 | 5 | 23 |
| 1 | 10 | 28 | 18 | 3 | 7 |
| 16 | 9 | 21 | 16 | 7 | 23 |
| 17 | 10 | 28 | 18 | 3 | 7 |

The machine-checkable aggregate is `arithmetic-gate.json`. It binds every
source artifact and replay script by SHA-256 and records the precise negative
scope:

- `jacobian_factor_path = eliminated`;
- `lower_genus_quotient_path = eliminated`;
- `nonzero_Q_correspondence_between_distinct_curves = eliminated`;
- geometric correspondences between distinct curves are not classified;
- rational points are not classified and no noncollision candidate was found.

## Canonical models and gonality

`toric_nondegeneracy.py` checks the logarithmic Jacobian ideal on the full
Newton polygon and every edge over `Q`. Every Gröbner basis is the unit basis,
so the four Laurent curves are Newton-nondegenerate. Their interior polygons
contain respectively 9, 10, 9, and 10 lattice points.

By the toric adjunction statement in Castryck--Cools, Section 4, the interior
monomials are canonical coordinates. `canonical_models.py` generates every
toric equal-exponent quadric and the translated defining-equation quadrics.
The resulting ideals are saturated and have:

- 21 quadrics, degree 16, Hilbert polynomial `16*t - 8` in genus 9;
- 28 quadrics, degree 18, Hilbert polynomial `18*t - 9` in genus 10.

The canonical image is contained in each resulting projective scheme. Equality
of dimension, degree, and the complete Hilbert polynomial leaves neither
another curve component nor a zero-dimensional residual scheme, so these are
the exact canonical models.

The same script exhausts every primitive lattice direction that could have
width at most four. Each polygon has width four in exactly the direction
`(0,1)`, up to sign, and every Castryck--Cools Theorem 6.1 exceptional interior
polygon is excluded. Theorem 6.1 and Corollary 6.3 therefore give gonality four
and exactly one tetragonal pencil for every curve.

## Good reduction

The selected reductions are certified at `p=5,3,7,3`, respectively. Auxiliary
good reductions at `p=23,7,23,7` support the correspondence comparison.

For each prime, `toric_nondegeneracy.py` proves:

1. the reduced polynomial retains plane degree 9;
2. every toric face is logarithmically nondegenerate;
3. the special normalization has the same interior-point genus as the generic
   normalization;
4. Sage's exact constant-field computation has degree one.

The primitive degree-9 plane equation defines a flat relative Cartier divisor
over `Z_(p)`. The reviewed irreducible `S4` quartic function field has no
nontrivial constant subfield: the point stabilizer `S3` is maximal in `S4`,
and the impossible degree-4 constant case would have genus zero. Thus the
generic curve is geometrically integral; the degree-one special constant field
gives the same conclusion in characteristic `p`.

Both fibers have arithmetic genus 28. Equality of their normalization genera
therefore gives equality of their total delta invariants. The nonnormal loci
are finite over the DVR, the finite-type coordinate rings are Nagata, and
flatness rules out one-dimensional components of the total space.
Greuel--Pfister Theorem 33 and Corollary 34 give simultaneous normalization.
Its proper normal fibers over perfect fields are geometrically regular, hence
this is a smooth proper good-reduction model.

## Frobenius and absolute simplicity

### Hasse-Witt coefficients and the nonordinary zeta congruence

The HLYY attribution is used **only** for the coefficient formula. For the
smooth toric compactification and its interior-monomial basis, write
`f^(p-1)=sum_u A_u t^u`. Theorem 2.2, Corollary 2.3 and Remark 2.7 of
`arxiv:1801.01189v1` give

```text
H_ij = A_(p*u_j-u_i).
```

The Introduction's discussion of an invertible Hasse-Witt matrix and a
unit-root crystal is not used to infer anything about a nonordinary curve.
The earlier inconclusive attribution is retained, not relabeled as support.

The missing implication is supplied separately by Achter--Howe,
`arxiv:1710.10726v5`, Section 2.5, equation (2.3). For any smooth projective
curve over `F_(p^e)`, with `sigma(a)=a^p` and column-action Frobenius
`F(v)=H*v^sigma`, their statement is

```text
L_C(T) = det(I-T*H*H^sigma*...*H^(sigma^(e-1))) modulo p.
```

Indeed, iterating the semilinear map gives exactly this matrix for the
`F_(p^e)`-linear map `F^e`. Over `F_p`, `e=1` and `sigma` is the identity,
so the required conclusion is `L_C(T)=det(I-T*H) mod p`. The cited statement
has **no ordinarity or invertibility hypothesis**. Over a larger finite field,
an ordinary matrix power `H^e` is not a substitute for the twisted product
unless the entries are fixed by `sigma`.

This also fixes the polynomial convention: if
`chi_H(T)=det(T*I-H)`, then `det(I-T*H)=T^g*chi_H(1/T)`.
`hasse_witt.py` uses this reciprocal, not `chi_H(T)` itself. Version 5 of
Achter--Howe explicitly corrects the mistaken characteristic-polynomial
wording in earlier versions.

As a bounded algebra sanity check, the inspected Argus sidecar operation
`prime_field.matrix.rank.compute` returns rank one for
`N=[[0,0],[1,0]]` over `F_3`, although `N^2=0` and
`det(I-T*N)=1`. Thus a singular matrix may have positive rank while its
determinant factor has degree zero. The dedicated
`research/literature/nonordinary-matrix.jacobian-{contract,payload,output}.json`
files retain the contract, exact input, typed output, server `0.14.0`,
protocol `2025-11-25`, adapter exit `0`, and no timeout or stderr.
This operation is not a curve calculation or a proof of the general
congruence.

The coefficient-only HLYY passage and the corrected zeta passage are archived
as `research/literature/hlyy-coefficient-formula-excerpt.txt` and
`research/literature/achter-howe-zeta-excerpt.txt`; the latter's primary HTML
is archived beside it. Their current ledger assumptions still require
Host-invoked independent reader judgments. This source repair changes no
point counts, integer L-polynomials, or existing certificates. In particular,
a congruence alone does not determine either pending genus-9 L-polynomial
over `Z` or establish its absolute simplicity.

`frobenius.py` uses the pinned Sage 10.9 global-function-field implementation.
`sage-l-polynomial-backend.json` records the exact official source file and
hash. That implementation enumerates all closed places of degrees `1` through
the genus, converts them to extension-field point counts, applies Newton
identities, and completes the degree-`2g` polynomial by the functional
equation.

The four resulting reversed Frobenius polynomials are irreducible over `Z`.
For each one, `frobenius_root_ratios.py` computes the exact degree
`(2g)^2` resultant whose roots are all Frobenius-root quotients. Its only
cyclotomic factor is the diagonal factor `(z-1)^(2g)`. Hence no quotient of
distinct Frobenius roots is a root of unity, so
`Q(pi^n)=Q(pi)` for every `n>0`. Howe--Zhu Proposition 3 and Lemma 4 imply
that each special Jacobian is absolutely simple and that its geometric
rational endomorphism algebra is unchanged after finite constant extension.
Because each Frobenius polynomial has exponent one, that algebra is the
Frobenius field. Sage computes its full root-of-unity group to have order two.

The representative-1 and representative-17 `p=3` polynomials were independently
reconstructed without Sage's function-field place enumerator.
`direct_toric_point_count.py` counts torus points and every primitive toric
boundary root over `F_(3^n)` for all `1<=n<=10`; both sequences are

```text
7, 19, 16, 83, 277, 652, 2030, 6419, 19177, 59389.
```

Newton identities reconstruct exactly the stored L-polynomial. For the two
genus-9 computations, independent toric counts replay the first five extension
degrees; those prefix checks are explicitly not presented as full independent
L-polynomial reconstructions.

At good reduction, smooth proper base change on prime-to-`p` Tate modules makes
specialization of geometric endomorphisms injective. A nontrivial geometric
factor of a characteristic-zero Jacobian would give a nontrivial idempotent in
its rational endomorphism algebra, whose specialization would be a nontrivial
idempotent in the division algebra of the absolutely simple special Jacobian.
This is impossible. All four characteristic-zero Jacobians are therefore
absolutely simple.

## Automorphisms, quotients, and correspondences

Every curve automorphism has finite order and acts faithfully on its Jacobian.
After specialization its induced endomorphism is a finite-order element of the
corresponding Frobenius field, hence `+1` or `-1`.

- Action `+1` fixes all canonical differentials and hence the canonical image
  pointwise, so the verified canonical embedding makes the automorphism the
  identity.
- Action `-1` is also projectively scalar on canonical differentials and fixes
  the canonical image pointwise. The automorphism would again be the identity,
  contradicting its induced action `-1`.

Thus `Aut_Qbar(C)=Aut_Q(C)=1` for all four curves. Moreover, a nonconstant map
`C -> D` in characteristic zero with `0<genus(D)<genus(C)` induces a nonzero
pullback `J_D -> J_C` with finite kernel, contradicting absolute simplicity.
There are no positive-genus lower quotients.

`correspondence_obstructions.py` uses common auxiliary good primes. At `p=23`,
representatives 0 and 16 have exact point counts 38 and 35, hence Frobenius
traces `-14` and `-11`. At `p=7`, representatives 1 and 17 have counts 15 and
13, hence traces `-7` and `-5`. Isogenous abelian varieties over `Q` have the
same good-prime Frobenius polynomial, so neither same-genus pair is
`Q`-isogenous. Different-genus Jacobians have dimensions 9 and 10. Since a
nonzero homomorphism between absolutely simple abelian varieties is an
isogeny onto the target, `Hom_Q(J_i,J_j)=0` for every distinct pair.

This last conclusion is deliberately only over `Q`; no claim that all
geometric correspondences between distinct curves have been classified is
made.

## Jacobian sidecar operation

The isolated Argus adapter discovered five candidate operations, and the exact
read-only contract for
`algebraic_geometry.affine_plane_curve.check` was inspected before execution.
Jacobian 0.14.0, protocol `2025-11-25`, accepted the exact 22-term
representative-1 payload and returned

```json
{"degree": 9, "is_valid": true, "method": "SYMPY_CURVE_CHECK"}
```

in 2 ms, with no adapter error or timeout. The discovery response, typed
contract, exact payload, and full run transcript are retained. This operation
only validates an affine plane polynomial and its degree; it supplies no
normalization, Jacobian decomposition, or rational-point conclusion.

## Primary sources

An independent reader, `reader:efc-arithmetic-auditor`, checked the archived
primary texts and confirmed all four ledger attributions:

- Castryck--Cools, arXiv:1402.4651v4, Section 4 equations (3)-(5);
- Castryck--Cools, arXiv:1402.4651v4, Theorem 6.1 and Corollary 6.3;
- Greuel--Pfister, arXiv:2107.07012v2, Theorem 33 and Corollary 34;
- Howe--Zhu, arXiv:math/0002205v1, Proposition 3 and Lemma 4.

The full archived texts and concise locator excerpts are in this directory;
the independent attribution records are in `research/literature/`.

## Exact replay

Run from the campaign root:

```bash
SAGE=research/r2-generic-section-difference/toolchain/sage-10.9/bin/python
DIR=research/r2-prime-support-efc-jacobian-arithmetic

$SAGE $DIR/canonical_models.py --output $DIR/canonical-models.json
$SAGE $DIR/toric_nondegeneracy.py --output $DIR/toric-nondegeneracy.json
$SAGE $DIR/correspondence_obstructions.py --output $DIR/correspondence-obstructions.json
$SAGE $DIR/audit_sage_backend.py --output $DIR/sage-l-polynomial-backend.json

$SAGE $DIR/frobenius.py --representative 0 --prime 5 --output $DIR/frobenius-r0-p5.json
$SAGE $DIR/frobenius.py --representative 1 --prime 3 --output $DIR/frobenius-r1-p3.json
$SAGE $DIR/frobenius.py --representative 16 --prime 7 --output $DIR/frobenius-r16-p7.json
$SAGE $DIR/frobenius.py --representative 17 --prime 3 --output $DIR/frobenius-r17-p3.json

for spec in 0:5 1:3 16:7 17:3; do
  r=${spec%:*}; p=${spec#*:}
  $SAGE $DIR/frobenius_root_ratios.py \
    --frobenius $DIR/frobenius-r${r}-p${p}.json \
    --output $DIR/frobenius-root-ratios-r${r}-p${p}.json
done

for r in 1 17; do
  $SAGE $DIR/direct_toric_point_count.py --representative $r --prime 3 \
    --frobenius $DIR/frobenius-r${r}-p3.json \
    --output $DIR/direct-point-count-r${r}-p3.json
done

$SAGE $DIR/direct_toric_prefix_count.py --representative 0 --prime 5 --degrees 5 \
  --frobenius $DIR/frobenius-r0-p5.json \
  --output $DIR/direct-point-count-prefix-r0-p5.json
$SAGE $DIR/direct_toric_prefix_count.py --representative 16 --prime 7 --degrees 5 \
  --frobenius $DIR/frobenius-r16-p7.json \
  --output $DIR/direct-point-count-prefix-r16-p7.json

/home/argustest/zimo/argus-latest/.venv/bin/python \
  $DIR/build_arithmetic_gate.py --output $DIR/arithmetic-gate.json
```

The `p=5`, `p=7`, and full direct-replay commands are long exact computations;
a timeout is not a mathematical result.

`NEXT_OWNER=reviewer`
