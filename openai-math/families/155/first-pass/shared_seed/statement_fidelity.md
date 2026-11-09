# Universal shared-output activation: statement and proof

Claim: `C_SHARED_SEED`. Formal source: `research/shared_seed/Main.lean`.
This is a parameter-uniform verification theorem for the activation maps,
not a proof of the complete periodic-tiling theorem. No false manuscript
assertion has been identified in this bounded audit. Independent review of
this translation and of significance/novelty remains necessary.

## Exact source and scope

All source references below are to the staged September 23, 2026 manuscript
under
`research/openai_manuscript/A-translational-tile-with-no-fully-periodic-tiling-in-dimension-three-September-23-2026/build/`.
They are local primary-source locators, not unverified external citations.

| Source locator | Assertion checked |
|---|---|
| `sections/03-cyclic-encoding.tex`, `enc:ambient`, `enc:shear` | There is one cyclic output of order `D`; the high-coordinate shear is a fibre chart, not a group splitting. |
| `sections/04-activation.tex`, `act:fibre-orderings` | The two orderings are bijections of **indices**, including repeated shift values. |
| Same section, `act:ordinary-crt`, `act:seed-crt` | Actual preselected offsets have the prescribed residues; seed offsets also have zero residue modulo the other seed's `a`. |
| Same section, `act:ordinary-map`, `act:seed-map` | The indexed maps whose bijectivity is required are exactly `(c+e,beta)` and `(c+e,beta,z)`. |
| `sections/05-common-solution.tex`, `model:block-map`, `model:a-inverse`, `model:b-inverse` | The block inverse, in both block-size cases. |
| Same section, `model:seed-regions`, label-space table | Disjoint active regions of sizes 3 and 4; the remaining region has `(D-7)/6` copies of labels of sizes 2 and 3. |
| Same section, `model:shared-output`, `model:seed-outputs` | The literal common output is `z(x,k)=lambda(R(x_1)s(x))`; active and inactive useful/high outputs have the stated different formulas. |
| Same section, both paragraphs under “The inverse for each seed test” | Existence and uniqueness of the recovered batch, with no later choice of its offset. |
| Same section, “Compatibility of all the equations” | The inverse computations work for every integer `x_1` and every permitted CRT lift. Only this activation/coordinate part of the paragraph is certified here. |

The source's block lemma states that
`(l,delta) -> (C(k-l)+e_delta,T(x_1-h_1(l,delta))(k-l))`
is a bijection. The seed fibre criterion adds the source's same `z` output
and an index `tau`. The source explicitly says: “The recovery uses only
the prescribed residues of `h_1`” and “There is no dependence on a later
choice of an integer lift.” These are the delicate universal assertions
proved below, rather than assumptions of the proof.

## Objects and hypotheses encoded

Write `A=ZMod a`, `B=ZMod b`, and `P=A x B`. `Shifts a b Delta` supplies
two useful shift coordinates `ea,eb` and the *given fibre orderings*

```
orderA(delta) = (eb(delta), ea(delta)+rhoA(delta)),
orderB(delta) = (ea(delta), eb(delta)+rhoB(delta)).
```

In Lean these are equivalences to `B x A` and `A x B`; their first-coordinate
identities are proved fields, and `rhoA,rhoB` are defined by subtraction.
This is precisely `act:fibre-orderings`: a bijection on each fibre
assembles to the displayed equivalence by attaching the fixed fibre
coordinate. Conversely either equivalence restricts to the required
fibre bijections. Neither `delta -> e_delta` nor any activation map is
assumed injective. The source's uniform marginals give the two orderings;
the particular values of its nonuniform multiplicity function are not
otherwise needed for this existence calculation. They matter for the
separate activity-forcing argument, which is not the theorem here.

`rectangleShifts` also constructs such data without postulating an
activation bijection: take indices `(u,v)` in `A x B`, transpose the
indices `(1,0)` and `(0,1)`, use the transposed first coordinate as `ea`
and the original second coordinate as `eb`. Use coordinate exchange as
`orderA` and the transposition as `orderB`. For `a,b>=2` its shift
multiplicities are exactly the manuscript's `1+omega`: two at `(0,0)`
and `(1,1)`, zero at `(1,0)` and `(0,1)`, and one elsewhere. The Python
replay checks this and also independently permutes the two fibre
orderings. The universal proof is not restricted to this convenient
enumeration.

A labelled partition of `K` is encoded by

```
chart : K ≃ (Ablocks x ZMod a) + (Bblocks x ZMod b).
```

The summand and block identifier remember the arbitrary subset, and the
last coordinate is its chosen cyclic label. This is equivalent to the
manuscript's explicitly labelled set partition. Block identifiers can
include every fixed setting of the other digits. No additive property
of `chart` or of block labels is required. `useful` is `(y,0)` or `(0,y)`;
`blockRotate t` preserves the block identifier and adds `t` to its label.
Thus `chart` is not an unproved bijectivity assumption about the
activation map: it is the literal data of a labelled partition.

For two seeds of first-coordinate sizes `a,c`, define

```
World a c C1 C2 C0 =
  (C1 x ZMod c)
  + ((C2 x ZMod a) + (C0 x (ZMod a x ZMod c))).
```

The three summands are the first seed active, the second seed active,
and both inactive, respectively. `C1,C2,C0` index individual label-space
copies, not groups. `worldRotate t` preserves the summand/copy and adds
`t` to all labels present there. It is an explicitly constructed
equivalence with subtraction as inverse.

`layout : S ≃ World ...` is the manuscript's chosen labelling of the
horizontal residue set; `label : S ≃ ZMod D` is its arbitrary `lambda`.
Their composition encodes values of **one** cyclic output:

```
sharedOutput layout label t s =
  label (layout.symm (worldRotate t (layout s))).
```

The horizontal group `S` is not added as a factor of `V`. Neither layout,
lambda, nor rotation is assumed a group homomorphism. The same layout,
lambda, and rotation occur literally in both seed maps.

All integers `x` and all offset functions `H` are universally quantified.
For seed one, the only residues used for the inverse algebra are

```
H(v) = rhoA(delta) mod a,
H(v) = rhoB(delta) mod b1,
H(v) = 0           mod c.
```

For seed two interchange `a,c` and use `b2`. In particular `H` may
depend on **every** index, including `tau`, in any way. Ordinary maps
need just the first two residues. Primality, pairwise coprimality,
the distinctness of horizontal offsets, and the remaining CRT
congruences guarantee the existence/interpretation of the manuscript's
data, but are not extra restrictions secretly used in the inverse.

## Inverse proof, including both compositions

`Shifts.aMap` maps `(delta,y)` to

```
((y+ea(delta),eb(delta)), y+x-rhoA(delta)).
```

For a target `((alpha,xi),q)`, `Shifts.aInverse` is exactly

```
delta = orderA^{-1}(xi,alpha+x-q),   y = alpha-ea(delta).
```

`Shifts.a_left` and `Shifts.a_right` separately prove inverse-after-map
and map-after-inverse. The corresponding `bMap,bInverse,b_left,b_right`
use `orderB^{-1}(alpha,xi+x-q)` and `y=xi-eb(delta)`. These are both
source inverse formulas, with the original signs.

`blockEquiv` attaches the unchanged block identifier and conjugates by
`chart`. `block_lift_independent` proves that its forward function is
the *actual* source map using `x-H`, not a map with an independently
chosen offset. In an `a` block, `(H:ZMod a)=rhoA` identifies the actual
rotation with the first local map; the `b` case uses `rhoB`.
`ordinaryEquiv` reindexes source points by `k-l`.
`ordinary_eq_equiv`, `ordinary_inverse_compositions`, and
`ordinary_bijective` prove the source formula, both inverse laws, and
bijectivity at every base point.

For seeds, `viewOne` and `viewTwo` are explicit, mutually inverse
rebracketings of the *same* three-summand World. They do not discard
either inactive label. They present one chosen seed's state as
“active context” or “inactive context plus its own label.”
`world_view_one` and `world_view_two` prove how actual rotation by
`x-H` acts in those views. Every other label rotates by `x`, since
`H=0` modulo the other seed's first-coordinate size.

In the active summand, the inverse subtracts `x` from the other seed's
label, preserving its copy, and applies the block inverse. This first
determines the complete source state and hence `tau`; the recovered
block indices then select their already existing offset.

In an inactive summand, let `q` be the target's own label. The inverse is

```
source_low = beta,   l = k-beta,
delta = orderA^{-1}(xi,alpha+x-q),
source_own_label = alpha-ea(delta),
source_other_label = target_other_label-x   (when present).
```

The copy is unchanged. Hence the source state and `tau` are determined
without evaluating or selecting `H`. This applies in particular on
the both-inactive summand, where both labels are retained.

`seedEquiv` builds the active inverse from `blockEquiv` and the inactive
inverse from `Shifts.aEquiv`; `inactiveEquiv` keeps the high/low input
unchanged in the inactive case. All its inverse laws are checked, not
postulated. `seedOneRaw` and `seedTwoRaw` instead use the actual integer
`H(v)`. `seedOne_lift_independent` and `seedTwo_lift_independent` prove
pointwise equality with the constructed equivalences, splitting over
all three regions and both active block types.

`sourceReindex` is the explicit involutive subtraction
`((l,delta),tau) -> ((k-l,delta),layout(s-tau))`.
`targetReindex` turns the rotated World state into the cyclic label.
`manuscriptOneMap` and `manuscriptTwoMap` are the actual displayed
useful/high/common-output formulas after these reindexings.
`manuscript_one_eq_equiv` and `manuscript_two_eq_equiv` prove they equal
their explicit inverse-bearing equivalences for every allowed `H`.

The main declaration `simultaneous_activation` concludes **both**
bijectivities and **both inverse compositions for each seed** with
one shared `sharedOutput`. It does not assert that the two tests have
the same representing batch; the manuscript does not require that.

## Literal manuscript specialization and carries

`manuscript_specialization` specializes to

```
a=2, c=3, K1=ZMod r1, K2=ZMod r2,
S=ZMod(p^2) x ZMod(p^2), D=p^4,
C1=PUnit, C2=Fin 2, C0=Fin((p^4-7)/6).
```

Its hypotheses are exactly the two labelled input partitions, the
two fibre orderings, the label-space enumeration from the source
table, lambda, and the six residue conditions above. It is not a
numerical instance or an assumed activation equivalence. The original
`p>200` prime hypotheses ensure `p` is coprime to 6, so `p^4=1 mod 6`
and the label spaces have cardinalities `3,4,p^4-7`. The given sets
therefore admit precisely this `layout`. The locations of the sets
in the two specified horizontal residue classes matter for exclusion,
not for these activation inverse calculations.

`horizontal_source` proves from the actual hypothesis `s(h)=tau`
that `s(x-h)=s(x)-tau`, for both horizontal coordinates and arbitrary
positive or negative lifts. `shear_carry` proves, in the single ring
`ZMod(r*r)`, that

```
shear(r,x-h,k-l,beta) + h = shear(r,x,k,beta)
```

whenever `(h:ZMod r)=l`. Here
`shear(r,x,k,beta)=x+(k-x).val+r*beta.val`. It never identifies
`ZMod(r*r)` with a product of two groups of order `r`.
`line_invariance` proves that the ordinary slope-restricted shifts
leave `f(L_i(x))` unchanged. Thus the fixed-partition proof applies
to every ordinary channel of the manuscript.

These transport identities explain the extra low/horizontal CRT
conditions in the source. Those conditions do not introduce a new
dependency into the inverse, and all their permitted lifts satisfy
the universal theorem. Ordinary batches range freely in their
`z` offset, so ordinary maps impose no restriction on the shared
output used by the two seed tests.

## Evidence and remaining dependencies

The official `lean_evidence verify --claim C_SHARED_SEED` run must
show Lean 4.31.0, `exit_code=0`, and `proof_holes=[]`; its archived
certificate, not this document, establishes compiler success.
`verify.py` additionally replays exact finite inverses and checks
that the official certificate still binds this source and document.
Its small examples exhaust their finite domains/targets, while its
`p=211` seed examples use genuinely admissible large prime data and
the prescribed residue locations. These computations are tests,
not proofs of the universal quantifier. The latter is the Lean theorem.

The Jacobian discovery/inspection preceded custom finite-certificate
code. The discovered bounded exact-factorization operation does not
express the universal activation claim. Its single executed
`ZMod 25` subgroup/transversal calculation is explicitly ancillary;
the payload and typed output are preserved in dedicated JSON files.

No external literature theorem is used in this proof beyond the
kernel-checked algebra/equivalence results available in Mathlib.
The project Wiki index search found no relevant inherited page.
No failed mathematical route is being presented as evidence.

The source's activation fibre criterion converts these indexed
bijections into tiling by the activation tiles: each batch supplies
one point in its specified useful/high/common-output coordinates;
all other offsets vary freely once, and distinct horizontal offsets
separate the batches. The carry identity checks the only nontrivial
coordinate transport in that argument. This translation from sets
of tile elements to indexed maps is read in prose here, not claimed
as a formal Lean theorem.

The complete word-rule obstruction, dependence/exclusion tiling
equations, existence of all global prime choices, activity forcing
in arbitrary solutions, cyclicity of the entire finite factor,
stacking, geometric rigidification, and arbitrary-real-translation
conclusion are **not** formalized by this file. They remain outside
this bounded certification. No global novelty, publishability,
campaign-completion, or independent-Reviewer verdict is inferred
from compiler success.
