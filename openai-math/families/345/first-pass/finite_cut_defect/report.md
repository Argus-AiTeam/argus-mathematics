# Finite-cut comparison with ungraded restriction images

## Scope and known status

This audit targets `build/sections/budget.tex`, from
`bud:crossing-diagram` through `bud:far-change`, and the exceptional-event
and event-summation arguments immediately following them. All manuscript
paths in this report are relative to
`research/openai_manuscript/Infinitely-many-closed-geodesic-images-on-every-Riemannian-sphere-September-24-2026/`.

The project Wiki index has no relevant finite-cut, closed-geodesic, or
Hingston--Wahl entry. The supplied scope finding also reports no relevant
reviewed-facts result; no such file was located in the campaign. These
are retrieval limits, not novelty evidence. The supplied primary-source
finding distinguishes Hingston--Wahl's canonical coproduct from
Cieliebak--Hingston--Oancea's reduced extension. Generic Frobenius failure
does not refute the restricted interchange used by this manuscript.
Neither coproduct theorem is an input to the finite-dimensional argument
below, and this mission does not re-audit those operations.

The intended verification is conditional on the actual local geometric
inputs. In particular, it does not prove that the local models or the
filtered operations in other sections exist.

## Hypotheses read in the staged source

* `setup.tex`, Section `sec:setup`: coefficients are the manuscript's
  field, total root groups are direct sums, negative degrees vanish,
  and the half-translation fixed sublevel is the doubled root sublevel.
* `local.tex`, Theorem `thm:local-control`: under finitely many prime
  images there are uniform local rank and index-support constants.
* `budget.tex`, Lemma `bud:localization`: fixed crossing groups have
  bounded root support near the root index; actual local groups are
  zero below and restriction is an isomorphism above a uniform ambient
  index window.
* `budget.tex`, `bud:crossing-diagram`: the actual and stabilized rows
  are exact and commute; the maps `f,i` preserve root labels and the
  connecting map raises the root label by one.
* `budget.tex`, `bud:far-local`: at a far cutoff, the three local
  restriction maps are injective with image precisely the low root
  subspace, and the two boundary root labels vanish.
* `budget.tex`, `bud:potential`: each fixed-cut potential has finite
  support; below the first positive event it is zero.

These are explicit hypotheses of the algebraic verification, not
dimension identities assumed in place of a proof. The following
argument derives the mixed-image, dimension, exceptional-event, and
summation conclusions.

## Universal algebraic theorem

Let all spaces be finite-dimensional over an arbitrary field. In the
fixed exact row write

```
V --delta--> W --f--> V' --i--> V --delta--> W.
```

Let `p,pw,pp` be idempotent projections on `V,W,V'`. Suppose
`pp f = f pw` and `p i = i pp`. At a far cutoff suppose also
`pw delta = delta p`. Compare two consecutive actual exact fragments

```
Cprev --> A'prev --> Aprev --> C --> A' --> A --> Cnext
```

with the fixed row by commuting restriction maps. At a far cutoff the
three local restrictions are injective, each with image `range(pw)`.
There is **no** invariance assumption on either actual restriction
image under the root projections.

Put `L=range(p)`, `L'=range(pp)`, `U=range(pw)`,
`A0=f(U)`, and let `E_q=range(epsilon_q)` and
`e_q=dim(p(E_q))`. Define
`r=dim(delta(L))` and `r_q=dim(delta(p(E_q)))`.
Then, at both consecutive actual degrees,

```
i(p'(E'_q)) = p(E_q) intersect ker(delta),
p'(E'_q) intersect ker(i) = A0,
dim U = dim A0 + r,
dim L' - dim L = dim A0 - r,
dim p'(E'_q) - dim p(E_q) = dim A0 - r_q.
```

Consequently, for the four-term potential in `bud:potential`,

```
Phi'_j - Phi_j = -(r-r_J) <= 0,       J=2j.
```

At an arbitrary cutoff, suppose `dim W` and each relevant actual local
dimension are at most `M`. The same exact comparisons, without far
injectivity or the identity `pw delta=delta p`, imply

```
abs(Phi'_j-Phi_j) <= 6M.
```

For any finite sequence of `N` events, with zero initial potential,
finite support at each stage, and at most `K` exceptional cutoffs at
each event, these statements imply

```
sum_j Phi_j <= 6MKN.
```

This is a universal theorem about exact linear comparisons, not an
inference from bounded matrix enumeration. Arbitrary compatible
idempotent cuts replace the manuscript's graded projections. The
algebra works over every field; characteristic two is needed for the
manuscript's geometric inputs, not for this implication.

### Why the cut commutes with the far connecting map

For a homogeneous vector of root degree `l`, `delta` has degree `l+1`.
If `l<j`, its image is low. If `l>j`, its image is high. For `l=j`,
its image lies in `W^(j+1)=0`. Extending by linearity proves
`pw delta=delta p`. Thus this hypothesis is derived from the manuscript's
grading and support, not from an ungraded exact sequence incorrectly
treated as periodic. The additional far vanishing `W^j=0` is compatible
with the proof but is not needed for this particular identity.

### Mixed-image lifting

Take an actual class `a` with restriction `z`. The actual connecting
class restricts to `delta z`. Far local surjectivity places this in
`U`, so

```
delta z = pw(delta z) = delta(p z).
```

If `x=p z` is killed by `delta`, the actual connecting class restricts
to zero. Local injectivity makes the actual connecting class zero.
Actual exactness therefore lifts `a` to `A'_q`. Commutativity and
`p i=i pp` give `x` in `i(pp(E'_q))`. The reverse inclusion follows
from the commuting square and `delta i=0`. This proves the first
displayed image equality even when `z` has nonzero high components.

For the kernel, a low vector killed by `i` is `f(w)` by fixed
exactness. Projecting its lift replaces `w` by `pw(w)`, without
changing that vector. Conversely every element of `U` has an actual
local lift. Its image under the actual left arrow restricts to its
image under `f`. Hence the projected-image kernel is precisely `A0`,
not merely a subspace of it.

### Dimension identities and the preceding-degree term

Apply rank-nullity to the restrictions of the fixed maps to the low
subspaces. Projected exactness gives

```
dim U = dim A0+r,
dim L' - dim L = dim A0-r.
```

Applying rank-nullity to the projected actual-image sequence just
proved gives `e'_q-e_q=dim A0-r_q`. Subtracting from the low-space
identity proves

```
D'_(j,q)-D_(j,q)=-(r-r_q).
```

The actual connecting rank equals `r_q`: its composition with the
injective next local restriction has image exactly
`delta(p(E_q))`. Exactness of the three middle actual maps now yields

```
dim A'_J-dim A_J = dim U-r_(J-1)-r_J.
```

Rank-nullity for `epsilon_J` followed by projection gives the
independently derived identity

```
H_(j,J)+t_J = dim A_J-e_J.
```

Its change is therefore `r-r_(J-1)`. Adding the two deficit changes
cancels this quantity and leaves exactly `-(r-r_J)`. Finally
`p(E_J)` is a subspace of `L`, so `r_J<=r`. No asserted manuscript
dimension formula has been imported as a hypothesis.

### Exceptional cutoffs

The induced map `pp(E'_q) -> p(E_q)` has kernel contained in
`ker(i)=range(f)`, hence of dimension at most `dim W<=M`.
Its cokernel is an image of the cokernel of the actual map
`A'_q -> A_q`, whose dimension is at most `dim C^(q+1)<=M`.
Thus `abs(e'_q-e_q)<=M`. This is `M`, not `2M`: the dimension
difference is kernel dimension minus cokernel dimension.

The same rank-nullity argument on `L' -> L` gives
`abs(dim L'-dim L)<=M`. Actual exactness gives
`abs(dim A'_J-dim A_J)<=M`. The proved potential formula is

```
Phi_j = 2 dim L-2e_J-e_(J-1)+dim A_J.
```

The four coefficient magnitudes sum to six, proving the bound `6M`.
This argument does not assume that a near local restriction is
injective or that `delta` commutes with the cut.

### Summation and the manuscript's length parameter

For any finite event sequence, the union of the supports before and
after its events is finite. Sum over that union. Each far cutoff has
nonpositive change; at most `K` other cutoffs each increase by at
most `6M`. Induction on the number of events proves `6MKN`.

Here is an explicit uniform choice in the manuscript. Enlarge `C0`
to a nonnegative integer and let `p` be the number of prime labels.
For one participating index `I`, the map `j -> 2j` injects the
exceptional positive integers into the integer interval
`[I-C0,I+C0]`. This gives at most `2C0+1` such integers.
There is at most one participating iterate per prime at one positive
event, so one may take

```
K = p(2C0+1).
```

Choose `M` uniformly for the local total fixed rank and all needed
actual local per-degree ranks, summing over at most `p` blocks.
The source's uniform index windows and
`abs(I_m-2 I_(m/2))<=n` imply `bud:far-local` after one fixed
enlargement of `C0`: below the ambient window the actual local
source is zero and there are no low roots; above it actual
restriction is already an isomorphism and every root is low.
Odd iterates have zero fixed target. Simultaneous events are
handled label by label.

Distinct event lengths below `2a` can be charged injectively to
distinct iterate labels. Since every prime length `ell_i` is positive,

```
N(a) <= sum_i floor(2a/ell_i) <= 2a sum_i 1/ell_i.
```

Therefore the preceding universal theorem gives

```
sum_(j>=1) Phi_j(a)
  <= 12 M p(2C0+1) a sum_i 1/ell_i
  <= C(1+a),
```

with a cut-independent constant. An empty prime list gives zero
potential. Vanishing mean indices cause no problem: they change
neither the number of prime labels nor the width of an individual
event's index window.

## Limits of the result

No false literal assertion has been established in the scoped
comparison. This verification does not refute or certify the
geodesic infinitude theorem. In particular it leaves the analytic
local-control proof, the construction of the geometric comparison
maps, ordinary death, and the filtered interchange outside its
certified scope. The use in `transients.tex`, `trans:used-budget`,
is conditional on those inputs.

No claim of literature novelty or publishability follows from the
negative Wiki lookup. Independent Reviewer replay, statement-fidelity
approval, and significance assessment remain pending.

## Exact and formal evidence

`Main.lean` has a real Lean 4.31.0 compiler result with exit code zero,
an independent axiom-audit command with exit code zero, and
`proof_holes=[]`. The official `lean_evidence verify --claim
C_FCD_EXACT` run attached its source- and fidelity-bound certificate
to the existing campaign ledger. `statement_fidelity.md` identifies
the declarations and the geometric scope boundary. The formal proof
includes the mixed lifting, not just the final arithmetic.

`verify.py` binds the certificate to the literal manuscript formulas
and replays three exact diagrams over F2. It checks all displayed
actual and fixed exactness relations, commuting squares, root gradings,
support at the compared actual degrees, projection identities, and
local dimension and index-window hypotheses. In every diagram the
actual image contains a mixed vector whose low projection is not
itself an actual image.

| Exact diagnostic | Old potential | New potential | Change |
|---|---:|---:|---:|
| Far, missing connecting direction | 2 | 1 | -1 |
| Far, preceding-deficit cancellation | 1 | 1 | 0 |
| Exceptional, noninjective local restrictions | 2 | 3 | 1 |

The second case is important: the preceding deficit drops by one
while the invisible dimension increases by one. The third case has
genuinely noninjective local restrictions and a positive potential
increment; the far hypotheses have not accidentally been imposed on
the exceptional theorem. The 105 small index-window checks and one
finite event sequence are additional diagnostics, not the proof of
the universal counting statements.

The preserved Jacobian call `prime_field.matrix.rank.compute`
computes rank two for a mixed vector and its low projection over F2.
Its exact payload, typed output, server version, protocol and successful
adapter status are separate JSON artifacts. It is a diagnostic only.
No timeout, unknown answer, or failed transport is used as evidence.

The mathematical improvement over the initially open ledger is a
universal, kernel-checked derivation of the mixed-image comparison and
the full event estimate, rather than a bounded search or an assumption
of the desired dimension formulas. It is not a new proof of any
geometric input, and novelty of this algebraic formulation is not
established.

To replay the exact certificate, including a fresh Lean compile:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/finite_cut_defect/verify.py
```

`--use-recorded-lean` instead checks the official compiler record and
both source bindings without recompiling unchanged text.
`exact_certificate.json` records the universal theorem separately
from the finite diagnostics and does not assert Reviewer acceptance.
