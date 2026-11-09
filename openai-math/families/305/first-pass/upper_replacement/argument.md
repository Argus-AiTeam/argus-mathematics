# Relative upper-cap replacement

The question is Lemma `ct:upper-replacement` in the PD4 manuscript,
`build/sections/control.tex:447-527`, not the complete disk-embedding or
PD4 nonrealization theorem.

The input is a finite prepared height-eight Whitney-grope system. The first
five surface stages and the entire protected Clifford capped surfaces are
fixed. Each upper component has height at least three, and its **entire**
direction image is small. The number of upper components is not bounded.
The requested output consists of mutually disjoint framed immersed cap
discs; loops in each disc's image must be nullhomotopic in `Z`.

The manuscript proposes two separations: first between the finitely many
coordinate-cover collections, then between individual components inside
disjoint neighborhoods of the first collections. The critical question is
control of the entire first collection, not merely of each component.

## Scope and dependencies

This investigation takes the prepared input and the marking comparison of
`ct:directions` as hypotheses; it does not verify their construction.
In particular, the latter comparison identifies the homomorphism on
fundamental groups induced by the direction map followed by the central
marking with inclusion into `Z`. A loop contained in a direction patch
that is contractible therefore dies in `pi_1(Z)`.

The source comparison below establishes the lemma relative to precisely
these input hypotheses. It is a reconstruction of an existing
Freedman--Quinn argument, not a new disk-embedding theorem, a counterexample,
or verification of the PD4 manuscript's other dependencies.

## Primary-source comparison

The cited version of Freedman--Quinn (FQ) is the January 2013 reformatted,
unrevised *Topology of 4-manifolds*, as explicitly specified in
`build/references.tex`.

* FQ, Lemma 2.10.1, printed p. 39, applies to a properly immersed union of
  disk-like capped gropes of height at least three, with a continuous map
  to a locally compact metric target. It replaces caps for unchanged
  bodies, separates distinct components, and controls their image
  diameters. It has no goodness or ambient fundamental-group hypothesis.
* Its compact-case proof, Section 2.10.2, printed p. 40, first separates
  the finitely many compact-cover collections and then separates their
  members inside disjoint neighborhoods of the entire collections.
  Thus whole-collection control is explicitly part of the cited
  construction, not an inference from pairwise small intersections.
* FQ, Section 2.8.3, printed p. 36, bounds each height-raising substep by a
  diameter factor of seven. Section 2.10.2 uses two substeps, then at most
  `q-1` push-offs, each with factor three.
* FQ, Sections 2.3-2.4.2, printed pp. 27-31, defines contraction and
  push-off in neighborhoods of the framed models. Sections 2.4 and 2.7
  make height raising an extension obtained by replacing caps. These
  facts supply locality, fixed original bodies, and fixed attaching
  framings, not merely an abstract existence result.
* Powell--Ray--Teichner (PRT), arXiv:2006.05209v3, Definition 3.1,
  printed p. 9, defines geometric duality using the whole capped
  surfaces: their only intersections with the dual gropes are prescribed
  bottom-stage points. Consequently the upper system in the given
  prepared input misses the whole protected system. This uses the
  supplied duality hypothesis, not a new claim that preparation can
  always be performed.

Sources:

1. FQ, DOI `10.1515/9781400861064`, 1990; numbering in the January 2013
   reformatted unrevised edition:
   <https://archive.mpim-bonn.mpg.de/id/eprint/4789/2/FreedmanQuinn-TopologyOf4Manifolds-Reformatted2013.pdf>.
2. PRT, DOI `10.1007/s00029-025-01069-y`; the inspected author preprint
   is <https://arxiv.org/abs/2006.05209v3>.

Both PDFs were retrieved and the stated passages read. The PRT publisher
HTML endpoint returned HTTP 406; the versioned arXiv PDF was accessible.
That HTML failure is not a missing mathematical source.

## Relative replacement theorem

Let `f:U -> S` be the direction map on a relative neighborhood of the
upper system, and let `P` be the union of the protected capped surfaces.
Assume the input hypotheses above. Then there is a number `delta>0`,
depending only on a fixed finite coordinate cover of `S`, with the
following property. For every finite number of upper components with
`diam f(G_i)<delta`, the required framed immersed replacements exist.
All their image loops die in `pi_1(Z)`.

Here and below disjointness is in the relative manifold obtained by
removing a small regular neighborhood of the retained five stages.
Reattaching the unchanged collars reinstates the prescribed grope
attachments; it does not assert that symplectic attaching curves on a
retained surface have no prescribed incidence.

### 1. Relative ambient manifold and framings

Truncate each upper attaching collar on the boundary of the removed
regular neighborhood. Proper immersion of the prepared system makes
the truncated union a properly immersed union of disk-like capped
gropes, each with at least three surface stages. The truncated attaching
regions have their given product framings.

The upper union is finite and compact and misses `P`. Choose a relative
open neighborhood `U` of this union disjoint from `P` and from the
retained stages, except for the fixed boundary attaching regions. Take
it inside the region where the direction map is defined. The
neighborhood can be chosen to avoid the unused protected collar levels
as well. Apply all operations in this relative four-manifold, fixing
the attaching collars. Height raising uses internal parallel copies of
the upper grope, not the protected surfaces. This prevents either
separation phase from altering a protected cap or lower stage.

### 2. A cover margin independent of the number of components

Choose nonempty compact sets `K_1,...,K_q` covering `S`, subordinate to
open coordinate balls `V_1,...,V_q`. There is an `epsilon>0` such that
the closed epsilon-neighborhood of `K_j` is contained in `V_j` for
every `j`: use compactness of each `K_j`, openness of `V_j`, and
finiteness of the cover. Empty cover members can be omitted, so `q>=1`.

Put

```
t = 3^(q-1),       A = 49t,       B = 81t = 3^(q+3),
delta = epsilon/(2B).
```

In particular `t>=1`, `delta>0`, and `B delta=epsilon/2`.
Assign each component to the first `K_j` its entire direction image
meets. Choose a point `y_i` in that intersection and choose an anchor
`a_i` on the original body of the component. Since the entire initial
component has image diameter less than `delta`,
`d(f(a_i),y_i)<delta`. Choosing only a tip or a piece instead of the
entire component would not justify this inequality.

### 3. First separation: whole-collection containment

Use the first phase of FQ Section 2.10.2 with these `q` collections.
First raise height by one using two height-raising substeps. Contract
only the added stages of the first collection and push later
collections off the contraction. Continue through the collections.
The original bodies and their anchors are retained. The final
components still have their original height, at least three.

The FQ estimate gives, for every resulting component `G_i'`,

```
diam f(G_i') < A delta.
```

The number of components inside a collection does not enter this
estimate. A component is pushed off once per earlier collection, not
once per earlier member of that collection. Intersections newly
created among unprocessed components are allowed; processed
collections remain separated.

For **every** point `x` of a component assigned to `j`, use its own
unchanged anchor:

```
d(f(x),y_i) <= d(f(x),f(a_i)) + d(f(a_i),y_i)
            < (A+1) delta
            < B delta
            = epsilon/2.
```

The strict arithmetic margin is valid for all `q>=1`:

```
B-(A+1) = 32t-1 = 32(t-1)+31 > 0.
```

Taking the union over **all** components assigned to `j` therefore
places the entire collection image in the epsilon/2-neighborhood of
`K_j`. No bound on a chain of intersections, on a loop's length, or on
the number of components is used. Nor is a small diameter of the
whole `K_j` needed: containment in `V_j` is what the conclusion needs.

### 4. Second separation: localization replaces a component-count bound

Let `C_j` be the entire image in `U` of the resulting `j`th collection.
The nonempty `C_j` are pairwise disjoint compact sets. Each is
contained in the open set `f^(-1)(V_j)`. Hence choose pairwise
disjoint sufficiently thin relative regular neighborhoods `N_j`
of the **whole** `C_j` with

```
N_j subset U,        f(N_j) subset V_j.
```

Compactness and continuity justify the thickening; the strict margin
above leaves room for it. The regular neighborhoods are those of the
plumbed grope models, with the original attaching regions on their
boundaries.

Inside a fixed `N_j`, repeat the collection procedure, now using each
individual component as its own collection. There are finitely many,
but their number is arbitrary. Raise height before contracting only
the newly added stages, so the original upper bodies again remain.
All operations are neighborhood operations inside `N_j`. No estimate
of their number or final diameter is necessary. Different components
are now disjoint, and the operations in one `N_j` cannot meet another.

Choose disjoint smaller relative neighborhoods of the final individual
components, all inside the appropriate `N_j`. Totally contract each
component in its own neighborhood. FQ's framed model contraction
produces an immersed disk with the original framed attaching region;
only self-intersections are allowed. The disks are mutually disjoint
in the relative manifold. They avoid `P`, and reattaching their fixed
collars leaves all five retained stages unchanged.

### 5. All image loops, not just elementary double-point loops

The entire image of a resulting disk is in one `N_j`, and
`f(N_j) subset V_j`. Every loop in that disk's image therefore has
direction image in the contractible coordinate ball `V_j`.
By the assumed marking comparison of `ct:directions`, its image in
`pi_1(Z)` is trivial. Conjugating by a common base path does not change
triviality. This applies to every loop, including those passing
through arbitrarily many self-intersections.

This proves the stated relative replacement theorem and
`ct:upper-replacement` under its original hypotheses.

## The additional first-phase gallery bound

This bound is used after the lemma, rather than needed to infer nullity.
If the initial upper components have gallery-map diameter at most a
fixed `D`, the same two height-raising substeps and `q-1` push-offs
bound first-phase component-image diameters by `49*3^(q-1)D`, with
arbitrarily small thickening slack. The operations can satisfy the
estimates for both continuous maps at once: there are finitely many
operations on a finite input, so choose the neighborhood tolerances
small enough for both maps at every step.

Each unchanged body anchor lies within a uniformly bounded distance
of its original chamber label. Thus every first-phase component lies
within a fixed metric distance of that label, independently of the
number of components and of `R`. Properness and cocompactness of the
Coxeter action convert this into a fixed gallery bound. These action
properties and the initial gallery bound are inputs from the cited
manuscript setup, not newly proved here. The second phase may have no
such bound, but stays inside its `N_j`, which is sufficient for nullity.

## Certification boundary and campaign impact

`verify.py` checks the exact positive-coefficient margin identity,
the cover-only choice of `delta`, and a bounded finite-metric replay
of the inspected Jacobian operation. The identity is a universal
certificate: write `t=1+u`, `u>=0`, and the gap has coefficients
`31+32u`, both positive. The proof above supplies the triangle
inequality and arbitrary-index union argument; a finite computation
alone could not supply either the topological construction or its
quantifiers.

The script does **not** check four-manifold topology, regular
neighborhood existence, the FQ construction, the supplied preparation,
or `ct:directions`. The first three have been checked in prose against
the indicated primary sources and require independent Reviewer
reading. The last two remain the original scope hypotheses. No Lean
formalization or proof-kernel certification of the topological lemma
is claimed.

The alleged loss of whole-image control is not a refutation: the
unchanged-anchor argument plus separation of whole collections closes
that inference. There is consequently no `F_...` refutation claim for
this route. This resolves only the upper-replacement dependency.
`ct:removal`, the preparation and direction constructions, and the PD4
nonrealization theorem remain outside this verification. This known
literature reconstruction is a campaign checkpoint, not a new
publishable result or terminal campaign success.
